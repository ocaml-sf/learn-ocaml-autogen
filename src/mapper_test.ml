open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree

let test_names = ref []

let add_test_name test_name = test_names := test_name :: !test_names

let gen_nb = 10

type kind =
  (* name, argument number, parameter types, return type *)
  | Function of string * int * Ftype.t
  (* name, type *)
  | Variable of string * Parsetree.core_type
  (* name, type, expected value *)
  | Reference of string * Parsetree.core_type * Parsetree.expression

let kind_to_string = function
  | Function _ -> "function"
  | Variable _ -> "variable"
  | Reference _ -> "reference"

let get_name = function
  | Function (name, _, _) | Variable (name, _) | Reference (name, _, _) -> name

let mk_test_name kind =
  let name = get_name kind in
  kind_to_string kind ^ "_" ^ name

let option_map f = function
  | Some x -> Some (f x)
  | None -> None

let get_arg_number pexp =
  let rec aux arg_number = function
    | {pexp_desc = Pexp_fun (_, _, _, pexp)} ->
        aux (arg_number + 1) pexp
    | _ -> arg_number in
  aux 0 pexp

let mk_test_function_with_sampler fun_name sampler ty_extension which_test =
  Exp.apply (Builders.lid_exp which_test) ([
    (Nolabel, ty_extension);
    (Nolabel, Builders.str_exp fun_name)]
    @ sampler @
    [(Labelled "gen", Exp.constant (
      Pconst_integer (string_of_int gen_nb, None)));
    (Nolabel, Exp.construct (Builders.lid "[]") None)])

let mk_test_function_no_samplers fun_name fun_ty which_test =
  let ty_extension = Ftype.mk_fty_extension fun_name fun_ty in
  mk_test_function_with_sampler fun_name [] ty_extension which_test

let mk_test_function fun_name fun_ty which_test =
  let samplers_fun = Samplers.samplers_for fun_name in
  if samplers_fun = [] then
    mk_test_function_no_samplers fun_name fun_ty which_test
  else
    let samplers =
      List.filter (Samplers.sufficient_annotations fun_ty) samplers_fun in
    if samplers = [] then
      raise Location.(Error (error (
        Printf.sprintf "ERROR A test for function %s cannot be generated: \
          insufficient type annotations." fun_name)));
    let mk_test (Samplers.Sampler (s, _) as sampler) =
      let test_type = Samplers.test_type fun_ty sampler in
      let ty_extension = Ftype.mk_fty_extension fun_name test_type in
      let s_arg = [(Labelled "sampler", s)] in
      mk_test_function_with_sampler fun_name s_arg ty_extension which_test in
    let concat acc pexp =
      Exp.apply (Builders.lid_exp "@") [(Nolabel, pexp); (Nolabel, acc)] in
    let tests = List.map mk_test samplers in
    List.fold_left concat (List.hd tests) (List.tl tests)

let mk_test_var var_name ty =
  Exp.apply (Builders.lid_exp "test_variable_against_solution") [
    (Nolabel, Ftype.mk_ty_extension ty);
    (Nolabel, Builders.str_exp var_name)]

let mk_test_ref ref_name ty exp =
  Exp.apply (Builders.lid_exp "test_ref") [
    (Nolabel, Ftype.mk_ty_extension ty);
    (Nolabel, Builders.lid_exp ref_name);
    (Nolabel, exp)]

let mk_report = function
  | Function (name, arg_number, fun_ty) ->
      if arg_number > 4 then
        raise Location.(Error (
          error (Printf.sprintf "Too many parameters for function \
            %s: 4 maximum accepted for automatic generation." name)));
      let which_test = Printf.sprintf
        "test_function_%s_against_solution" (string_of_int arg_number) in
      mk_test_function name fun_ty which_test
  | Variable (name, ty) -> mk_test_var name ty
  | Reference (name, ty, exp) -> mk_test_ref name ty exp

let mk_test kind =
  let open Builders in
  let name = get_name kind in
  let test_name = mk_test_name kind in
  test_names := test_name :: !test_names;
  let header_kind = String.capitalize_ascii (kind_to_string kind) in
  let header = [
    Exp.construct (lid "Text") (Some (
      Exp.constant (Pconst_string (header_kind ^ ":", None))));
    Exp.construct (lid "Code") (Some (str_exp name))] in
  Str.value Nonrecursive [
    Vb.mk (Pat.var (str_loc test_name)) (
      Exp.construct (lid "Section") (Some (
        Exp.tuple [
          ast_of_list header;
          mk_report kind])))]

let test_function_of_vb rec_flag = function
  | {pvb_pat = {ppat_desc = Ppat_var {txt = fun_name}}; pvb_expr = pexp} ->
      let arg_number = get_arg_number pexp in
      let ty = Ftype.get_function_type pexp in
      mk_test (Function (fun_name, arg_number, ty))
  | _ -> raise Location.(Error (error "Not a function."))

let test_variable_of_vb vb =
  let error () =
    raise Location.(Error (error "Variable not annotated.")) in
  match vb with
  | {pvb_pat = {ppat_desc = Ppat_var {txt = name}}; pvb_expr = pexp} ->
      begin match pexp with
      | {pexp_desc = Pexp_constraint (_, ty)} ->
          mk_test (Variable (name, ty))
      | _ -> error ()
      end
  | _ -> error ()

let test_reference_of_vb = function
  | {pvb_pat = {ppat_desc = Ppat_var {txt = name}}; pvb_expr = {pexp_desc}} ->
      begin match pexp_desc with
      | Pexp_constraint (expected, ty) ->
          mk_test (Reference (name, ty, expected))
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
  let open Builders in
  Str.value Nonrecursive ([
    Vb.mk (Pat.construct (lid "()") None)
      (Exp.apply (lid_exp "@@") [
        (Nolabel, Exp.ident (lid "set_result"));
        (Nolabel, Exp.apply (lid_exp "@@") [
          (Nolabel, Exp.apply (lid_exp "ast_sanity_check") [
            (Nolabel, lid_exp "code_ast")]);
          (Nolabel, Exp.fun_ Nolabel None (Pat.construct (lid "()") None) (
            ast_of_list (List.map lid_exp test_names)))])])])

let extension_mapper items payload = function
  | "var" -> List.concat (List.map test_variable_of_item items)
  | "ref" -> List.concat (List.map test_reference_of_item items)
  | "sampler" -> List.iter Samplers.save_samplers items; []
  | "test" -> items
  | _ -> []

let test_structure_mapper mapper s =
  let rec replace acc = function
    (* We replace a function by the corresponding test. *)
    | {pstr_desc = Pstr_value (rec_flag, vbs)} :: s ->
        (* If case of a value definition, we have to remove local sampler
         * definitions, keep global samplers as if and create tests functions
         * for each solution function.*)
        let (global_samp, no_samp) =
          List.partition Samplers.is_sampler_function vbs in
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
