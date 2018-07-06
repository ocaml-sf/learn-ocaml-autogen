open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree

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

(* Create a test for function fun_name of type represented by ty_extension. *)
let mk_test_function which_test_against ty_extension fun_name =
  let fun_name_exp = Exp.constant (Pconst_string (fun_name, None)) in
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
          Exp.apply (Exp.ident (mk_lid which_test_against)) [
            (Nolabel, ty_extension);
            (Nolabel, fun_name_exp);
            (Labelled "gen", Exp.constant (
              Pconst_integer (string_of_int gen_nb, None)));
            (Nolabel, Exp.construct (mk_lid "[]") None)]])))]

let rec mk_exercises_list = function
  | ex :: exercises ->
      Exp.construct (mk_lid "::") (Some (
        Exp.tuple [
          Exp.ident (mk_lid ("exercise_" ^ ex));
          mk_exercises_list exercises]))
  | [] -> Exp.construct (mk_lid "[]") None

(* We have each test separated for each function, with the name
 * exercise_"fun_name". The main function puts them alltogether. *)
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

let test_structure_mapper mapper s =
  let rec replace function_names s acc =
    match s with
    (* We replace a function by the corresponding test. *)
    | {pstr_loc = loc; pstr_desc = Pstr_value (_,
      [{pvb_pat = {ppat_desc = Ppat_var {txt = fun_name}};
        pvb_expr = pexp}])} :: s' ->
      let function_names = fun_name :: function_names in
      let (args, return_type) = get_types pexp in
      let nb_of_args = List.length args in
      (* Basic test functions are defined for up to four parameters. For more
       * parameters we need a more complicated function, which use is harder to
       * encode as an AST. Need for this function does not come often anyway.
       * *)
      if nb_of_args > 4 then
        raise (Location.Error (
          Location.error ~loc (Printf.sprintf "Too many parameters for function
            %s: 4 maximum accepted for automatic generation." fun_name )))
      else
        let which_test_against = Printf.sprintf
          "test_function_%s_against_solution" (string_of_int nb_of_args) in
        let args_core_type = List.map Typ.mk args in
        let return_core_type = Typ.mk return_type in
        let ty_extension = mk_ty_extension args_core_type return_core_type in
        let test_function =
          mk_test_function which_test_against ty_extension fun_name in
        replace function_names s' (test_function :: acc)
    (* We keep open declarations in the test (in particular "open Test_lib" and
     * "open Report"). *)
    | ({pstr_desc = Pstr_open _} as x) :: s' ->
        replace function_names s' (x :: acc)
    | _ :: s' -> replace function_names s' acc
    (* Main function is put at the end of the program. *)
    | [] -> mk_main_function (List.rev function_names) :: acc
  in
  List.rev (replace [] s [])

let test_mapper argv_ =
  { default_mapper with
    structure = test_structure_mapper
  }

let () = register "test" test_mapper
