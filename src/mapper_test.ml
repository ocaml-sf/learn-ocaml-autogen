open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree

let function_names = ref []
let samplers = ref []

let gen_nb = 10

let mk_lid s = {txt = Longident.Lident s; loc = !default_loc}
let mk_lid_exp s = Exp.ident (mk_lid s)
let mk_str_loc s = {txt = s; loc = !default_loc}

(* pexp should represent a function. *)
let get_types pexp =
  let rec aux pexp args =
    match pexp with
    (* Variable *)
    | {pexp_desc = Pexp_fun
        (_, _,
        {ppat_desc = Ppat_constraint (_, {ptyp_desc = ty})},
        pexp')} ->
          aux pexp' (ty :: args)
    (* Function *)
    | {pexp_desc = Pexp_constraint (_, {ptyp_desc = ty})} ->
        (List.rev args, ty)
    | {pexp_loc = loc} ->
        raise Location.(Error (error ~loc "Not enough type annotations."))
  in aux pexp []

let mk_ty_extension args result =
  let add_arrow = fun acc ty -> Typ.arrow Nolabel ty acc in
  let mk_arrow_type = List.fold_left add_arrow result (List.rev args) in
  Exp.extension (
    {txt = "ty"; loc = !default_loc},
    PTyp mk_arrow_type)

let sampler_for f samplers =
  try
    let s = List.assoc f samplers in
    [(Labelled "sampler", s)]
  with Not_found -> []

(* Construct a list as an AST *)
let ast_of_list l =
  let mk_list_element acc x =
    Exp.construct (mk_lid "::") (Some (Exp.tuple [x; acc])) in
  List.fold_left
    mk_list_element (Exp.construct (mk_lid "[]") None) (List.rev l)

(* Create a test for function fun_name of type represented by ty_extension. *)
let mk_test_function which_test_against ty_extension fun_name =
  let fun_name_exp = Exp.constant (Pconst_string (fun_name, None)) in
  let sampler = sampler_for fun_name !samplers in
  let default_text = [
    Exp.construct (mk_lid "Text") (Some (
      Exp.constant (Pconst_string ("Function:", None))));
    Exp.construct (mk_lid "Code") (Some (fun_name_exp))] in
  Str.value Nonrecursive [
    Vb.mk (Pat.var (mk_str_loc ("exercise_" ^ fun_name))) (
      Exp.construct (mk_lid "Section") (Some (
        Exp.tuple [
          ast_of_list default_text;
          Exp.apply (mk_lid_exp which_test_against) ([
            (Nolabel, ty_extension);
            (Nolabel, fun_name_exp)]
            @ sampler @
            [(Labelled "gen", Exp.constant (
              Pconst_integer (string_of_int gen_nb, None)));
            (Nolabel, Exp.construct (mk_lid "[]") None)])])))]

(* Each function has a separate test, called exercise_"fun_name". The main
 * function puts them alltogether. *)
let mk_main_function function_names =
  let exercises_names =
    List.map (fun x -> mk_lid_exp ("exercise_" ^ x)) function_names in
  Str.value Nonrecursive ([
    Vb.mk (Pat.construct (mk_lid "()") None)
      (Exp.apply (mk_lid_exp "@@") [
        (Nolabel, Exp.ident (mk_lid "set_result"));
        (Nolabel, Exp.apply (mk_lid_exp "@@") [
          (Nolabel, Exp.apply (mk_lid_exp "ast_sanity_check") [
            (Nolabel, mk_lid_exp "code_ast")]);
          (Nolabel, Exp.fun_ Nolabel None (Pat.construct (mk_lid "()") None) (
            ast_of_list exercises_names))])])])

let test_function_of_vb rec_flag vb =
  match vb with
  | {pvb_pat = {ppat_desc = Ppat_var {txt = fun_name}}; pvb_expr = pexp} ->
      assert (not (Mapper.is_sampler vb));
      let (args, return_type) = get_types pexp in
      let nb_of_args = List.length args in
      (* Basic test functions are defined for up to four parameters. For more
       * parameters we need a more complicated function, which use is harder
       * to encode as an AST. Need for this function does not come often
       * anyway.
       * *)
      if nb_of_args > 4 then
        raise Location.(Error (
          error (Printf.sprintf "Too many parameters for function \
            %s: 4 maximum accepted for automatic generation." fun_name)));
      let which_test_against = Printf.sprintf
        "test_function_%s_against_solution" (string_of_int nb_of_args) in
      let args_core_type = List.map Typ.mk args in
      let return_core_type = Typ.mk return_type in
      let ty_extension = mk_ty_extension args_core_type return_core_type in
      function_names := fun_name :: !function_names;
      mk_test_function which_test_against ty_extension fun_name
  | _ -> raise Location.(Error (error "Not a function."))

let get_lident = function
  | {pexp_desc = Pexp_ident {txt = Longident.Lident x}} -> x
  | {pexp_loc = loc} ->
      raise Location.(Error (
        error ~loc "Error while parsing: identifier expected."))

(* Remember samplers of the kind let[%sampler f] = e for use in f’s test
 * function. *)
let save_sampler = function
  | {pvb_pat = {ppat_desc = Ppat_extension ({txt = "sampler"}, PStr [pstr])};
    pvb_expr = e} ->
      let make_assoc pexp = (get_lident pexp, e) in
      begin match pstr with
      | {pstr_desc = Pstr_eval ({pexp_desc = Pexp_ident _} as pexp, _)} ->
          samplers := make_assoc pexp :: !samplers
      | {pstr_desc = Pstr_eval ({pexp_desc = Pexp_apply (pexp, pexps)}, _)} ->
          let pexps = List.map snd pexps in
          samplers := List.map make_assoc (pexp :: pexps) @ !samplers
      | {pstr_loc = loc} ->
          raise Location.(Error (
            error ~loc "Sampler extensions expect one or more function names."))
      end
  | {pvb_loc = loc} ->
      raise Location.(Error (error ~loc "Not a sampler extension."))

let split_samplers vbs =
  let anonymous_samplers = List.filter Mapper.is_sampler_extension vbs
  and global_samplers = List.filter Mapper.is_sampler_function vbs
  and no_samplers = List.filter (fun x -> not (Mapper.is_sampler x)) vbs in
  (anonymous_samplers, global_samplers, no_samplers)

let test_structure_mapper mapper s =
  let rec replace s acc =
    match s with
    (* We replace a function by the corresponding test. *)
    | {pstr_desc = Pstr_value (rec_flag, vbs)} :: s' ->
        (* If case of a value definition, we have to remove local sampler
         * definitions, keep global samplers as if and create tests functions
         * for each solution function.*)
        let (anonymous_samp, global_samp, no_samp) = split_samplers vbs in
        List.iter save_sampler anonymous_samp;
        let pstr_samplers = Str.value rec_flag global_samp in
        let pstr_tests = List.rev_map (test_function_of_vb rec_flag) no_samp in
        (* Inside a mutually recursive definition, samplers are taken apart and
         * moved before the test function. *)
        let pstr_l = pstr_tests @ [pstr_samplers] in
        let pstrs = List.filter Mapper.keep_let_definitions pstr_l in
        replace s' (pstrs @ acc)
    (* We keep open declarations in the test (in particular "open Test_lib" and
     * "open Report"). We also keep type declarations, as they are used to
     * define samplers. *)
    | ({pstr_desc = Pstr_open _} | {pstr_desc = Pstr_type _} as x) :: s' ->
        replace s' (x :: acc)
    | _ :: s' -> replace s' acc
    (* Main function is put at the end of the program. *)
    | [] -> mk_main_function (List.rev !function_names) :: acc
  in
  List.rev (replace s [])

let test_mapper argv_ =
  { default_mapper with
    structure = test_structure_mapper
  }

let () = register "test" test_mapper