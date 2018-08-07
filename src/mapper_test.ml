open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree

let test_names = ref []
let samplers = ref []

let add_test_name test_name = test_names := test_name :: !test_names

let gen_nb = 10

let mk_lid s = {txt = Longident.Lident s; loc = !default_loc}
let mk_lid_exp s = Exp.ident (mk_lid s)
let mk_str_loc s = {txt = s; loc = !default_loc}

let mk_str_exp s = Exp.constant (Pconst_string (s, None))

type kind =
  (* name, type, number of parameters *)
  | Function of string * Parsetree.expression * int
  (* name, type *)
  | Variable of string * Parsetree.expression
  (* name, type, expected value *)
  | Reference of string * Parsetree.expression * Parsetree.expression

let kind_to_string = function
  | Function _ -> "function"
  | Variable _ -> "variable"
  | Reference _ -> "reference"

let get_name = function
  | Function (name, _, _) | Variable (name, _) | Reference (name, _, _) -> name

let mk_test_name kind =
  let name = get_name kind in
  kind_to_string kind ^ "_" ^ name

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
  let arrow_type = List.fold_left add_arrow result (List.rev args) in
  Exp.extension (
    {txt = "ty"; loc = !default_loc},
    PTyp arrow_type)

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

let mk_test_function fun_name ty_extension which_test =
  let sampler = sampler_for fun_name !samplers in
  Exp.apply (mk_lid_exp which_test) ([
    (Nolabel, ty_extension);
    (Nolabel, mk_str_exp fun_name)]
    @ sampler @
    [(Labelled "gen", Exp.constant (
      Pconst_integer (string_of_int gen_nb, None)));
    (Nolabel, Exp.construct (mk_lid "[]") None)])

let mk_test_var var_name ty_extension =
  Exp.apply (mk_lid_exp "test_variable_against_solution") [
    (Nolabel, ty_extension);
    (Nolabel, mk_str_exp var_name)]

let mk_test_ref ref_name ty_extension exp =
  Exp.apply (mk_lid_exp "test_ref") [
    (Nolabel, ty_extension);
    (Nolabel, mk_lid_exp ref_name);
    (Nolabel, exp)]

let mk_report = function
  | Function (name, ty, n) ->
      if n > 4 then
        raise Location.(Error (
          error (Printf.sprintf "Too many parameters for function \
            %s: 4 maximum accepted for automatic generation." name)));
      let which_test = Printf.sprintf
        "test_function_%s_against_solution" (string_of_int n) in
      mk_test_function name ty which_test
  | Variable (name, ty) -> mk_test_var name ty
  | Reference (name, ty, exp) -> mk_test_ref name ty exp

let mk_test kind =
  let name = get_name kind in
  let test_name = mk_test_name kind in
  test_names := test_name :: !test_names;
  let header_kind = String.capitalize_ascii (kind_to_string kind) in
  let header = [
    Exp.construct (mk_lid "Text") (Some (
      Exp.constant (Pconst_string (header_kind ^ ":", None))));
    Exp.construct (mk_lid "Code") (Some (mk_str_exp name))] in
  Str.value Nonrecursive [
    Vb.mk (Pat.var (mk_str_loc test_name)) (
      Exp.construct (mk_lid "Section") (Some (
        Exp.tuple [
          ast_of_list header;
          mk_report kind])))]

let test_function_of_vb rec_flag = function
  | {pvb_pat = {ppat_desc = Ppat_var {txt = fun_name}}; pvb_expr = pexp} ->
      let (args, return_type) = get_types pexp in
      let nb_of_args = List.length args in
      let args_core_type = List.map Typ.mk args in
      let return_core_type = Typ.mk return_type in
      let ty_extension = mk_ty_extension args_core_type return_core_type in
      mk_test (Function (fun_name, ty_extension, nb_of_args))
  | _ -> raise Location.(Error (error "Not a function."))

let test_variable_of_vb = function
  | {pvb_pat = {ppat_desc = Ppat_var {txt = name}}; pvb_expr = pexp} ->
      let ty_extension = mk_ty_extension [] (Typ.mk (snd (get_types pexp))) in
      mk_test (Variable (name, ty_extension))
  | {pvb_loc = loc} ->
      raise Location.(Error (error ~loc "Variable not annotated."))

let test_reference_of_vb = function
  | {pvb_pat = {ppat_desc = Ppat_var {txt = name}}; pvb_expr = {pexp_desc}} ->
      begin match pexp_desc with
      | Pexp_constraint (expected, {ptyp_desc = ty}) ->
          let ty_extension = mk_ty_extension [] (Typ.mk ty) in
          mk_test (Reference (name, ty_extension, expected))
      | _ -> raise Location.(Error (error "Reference not annotated."))
      end
  | {pvb_loc = loc} ->
      raise Location.(Error (error ~loc "Variable expected in %ref."))

let test_of_item test_of_vb = function
  | {pstr_desc = Pstr_value (_, vbs)} ->
      List.map test_of_vb vbs
  | {pstr_loc = loc} ->
      raise Location.(Error (error ~loc "Value expected."))

let test_variable_of_item = test_of_item test_variable_of_vb
let test_reference_of_item = test_of_item test_reference_of_vb

(* The main function puts the test functions alltogether. *)
let mk_main_function test_names =
  Str.value Nonrecursive ([
    Vb.mk (Pat.construct (mk_lid "()") None)
      (Exp.apply (mk_lid_exp "@@") [
        (Nolabel, Exp.ident (mk_lid "set_result"));
        (Nolabel, Exp.apply (mk_lid_exp "@@") [
          (Nolabel, Exp.apply (mk_lid_exp "ast_sanity_check") [
            (Nolabel, mk_lid_exp "code_ast")]);
          (Nolabel, Exp.fun_ Nolabel None (Pat.construct (mk_lid "()") None) (
            ast_of_list (List.map mk_lid_exp test_names)))])])])

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

let extension_mapper items payload = function
  | "var" -> List.concat (List.map test_variable_of_item items)
  | "ref" -> List.concat (List.map test_reference_of_item items)
  | "test" -> items
  | _ -> []

let test_structure_mapper mapper s =
  let rec replace acc = function
    (* We replace a function by the corresponding test. *)
    | {pstr_desc = Pstr_value (rec_flag, vbs)} :: s ->
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
        let pstrs = List.filter Mapper.is_let_definition pstr_l in
        replace (pstrs @ acc) s
    | {pstr_desc = Pstr_extension (({txt}, PStr items), payload)} :: s ->
        replace (extension_mapper items payload txt @ acc) s
    (* We keep open declarations in the test (in particular "open Test_lib" and
     * "open Report"). We also keep type declarations, as they are used to
     * define samplers. *)
    | ({pstr_desc = Pstr_open _} | {pstr_desc = Pstr_type _} as x) :: s ->
        replace (x :: acc) s
    | _ :: s -> replace acc s
    (* Main function is put at the end of the program. *)
    | [] -> mk_main_function (List.rev !test_names) :: acc
  in
  List.rev (replace [] s)

let test_mapper argv_ =
  { default_mapper with
    structure = test_structure_mapper
  }

let () = register "test" test_mapper
