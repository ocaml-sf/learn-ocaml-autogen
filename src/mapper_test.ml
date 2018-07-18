open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree

let function_names = ref []
let samplers = ref []

let gen_nb = 10

let mk_lid s = {txt = Longident.Lident s; loc = !default_loc}
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
        raise (Location.Error (
          Location.error ~loc "Not enough type annotations."))
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
(*   option_map (fun s -> (Labelled "sample", s)) sampler_exp *)

(* Create a test for function fun_name of type represented by ty_extension. *)
let mk_test_function which_test_against ty_extension fun_name =
  let fun_name_exp = Exp.constant (Pconst_string (fun_name, None)) in
  let sampler = sampler_for fun_name !samplers in
  Str.value Nonrecursive [
    Vb.mk (Pat.var (mk_str_loc ("exercise_" ^ fun_name))) (
      Exp.construct (mk_lid "Section") (Some (
        Exp.tuple [
          Exp.construct (mk_lid "::") (Some (
            Exp.tuple [
              Exp.construct (mk_lid "Text") (Some (
                Exp.constant (Pconst_string ("Function:", None))));
              Exp.construct (mk_lid "::") (Some (
                Exp.tuple [
                  Exp.construct (mk_lid "Code") (Some (fun_name_exp));
                  Exp.construct (mk_lid "[]") None]))]));
          Exp.apply (Exp.ident (mk_lid which_test_against)) ([
            (Nolabel, ty_extension);
            (Nolabel, fun_name_exp)]
            @ sampler @
            [(Labelled "gen", Exp.constant (
              Pconst_integer (string_of_int gen_nb, None)));
            (Nolabel, Exp.construct (mk_lid "[]") None)])])))]

let rec mk_exercises_list = function
  | ex :: exercises ->
      Exp.construct (mk_lid "::") (Some (
        Exp.tuple [
          Exp.ident (mk_lid ("exercise_" ^ ex));
          mk_exercises_list exercises]))
  | [] -> Exp.construct (mk_lid "[]") None

(* Each function has a separate test, called exercise_"fun_name". The main
 * function puts them alltogether. *)
let mk_main_function function_names =
  Str.value Nonrecursive ([
    Vb.mk (Pat.construct (mk_lid "()") None)
      (Exp.apply (Exp.ident (mk_lid "@@")) [
        (Nolabel, Exp.ident (mk_lid "set_result"));
        (Nolabel, Exp.apply (Exp.ident (mk_lid "@@")) [
          (Nolabel, Exp.apply (Exp.ident (mk_lid "ast_sanity_check")) [
            (Nolabel, Exp.ident (mk_lid "code_ast"))]);
          (Nolabel, Exp.fun_ Nolabel None (Pat.construct (mk_lid "()") None) (
            mk_exercises_list function_names))])])])

let test_function_of_vb vb =
  match vb with
  | {pvb_pat = {ppat_desc = Ppat_var {txt = fun_name}}; pvb_expr = pexp} ->
      (* Mutually recursive samplers? *)
      let is_sampler_function =
        try String.sub fun_name 0 7 = "sample_"
        with Invalid_argument _ -> false in
      if is_sampler_function then
        Str.value Nonrecursive [vb]
      else
        let (args, return_type) = get_types pexp in
        let nb_of_args = List.length args in
        (* Basic test functions are defined for up to four parameters. For more
         * parameters we need a more complicated function, which use is harder
         * to encode as an AST. Need for this function does not come often
         * anyway.
         * *)
        if nb_of_args > 4 then
          raise (Location.Error (
            Location.error (Printf.sprintf "Too many parameters for function
              %s: 4 maximum accepted for automatic generation." fun_name )));
        let which_test_against = Printf.sprintf
          "test_function_%s_against_solution" (string_of_int nb_of_args) in
        let args_core_type = List.map Typ.mk args in
        let return_core_type = Typ.mk return_type in
        let ty_extension = mk_ty_extension args_core_type return_core_type in
        function_names := fun_name :: !function_names;
        mk_test_function which_test_against ty_extension fun_name
  | _ -> raise (Location.Error (Location.error "Not a function."))

let fetch_sampler = function
  | {pvb_pat = {ppat_desc = Ppat_extension ({txt = "sampler"}, PStr [pstr])};
    pvb_expr = e} ->
      begin match pstr with
      | {pstr_desc = Pstr_eval ({
        pexp_desc = Pexp_ident {txt = Longident.Lident f}}, _)} ->
          samplers := (f, e) :: !samplers
      | {pstr_loc = loc} ->
          raise (Location.Error (
            Location.error ~loc "Sampler extensions expect a function name."))
      end
  | {pvb_loc = loc} ->
      raise (Location.Error (Location.error ~loc "Not a sampler extension."))

let is_sampler_extension = function
  | {pvb_pat = {ppat_desc = Ppat_extension ({txt = "sampler"}, _)}} -> true
  | _ -> false

let test_structure_mapper mapper s =
  let rec replace s acc =
    match s with
    (* We replace a function by the corresponding test. *)
    | {pstr_desc = Pstr_value (_, vbs)} :: s' ->
        let samps = List.filter is_sampler_extension vbs in
        List.iter fetch_sampler samps;
        let not_sampler_extension x = not (is_sampler_extension x) in
        let functions = List.filter not_sampler_extension vbs in
        if functions = [] then
          replace s' acc
        else
          let vbs' = List.rev_map test_function_of_vb functions in
          replace s' (vbs' @ acc)
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
