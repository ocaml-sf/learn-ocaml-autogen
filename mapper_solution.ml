open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree

(* The type of the function is only used in grading, not in the solution. *)
let rec remove_type_annotations = function
  (* Argument type annotation. *)
  | {pexp_loc = loc; pexp_desc = Pexp_fun (rec_flag, e,
      {ppat_desc = Ppat_constraint (pattern, ty)}, body)} ->
        Exp.fun_ ~loc rec_flag e pattern (remove_type_annotations body)
  (* ty is the last type annotation: the return type. *)
  | {pexp_desc = Pexp_constraint (e, ty)} -> e
  | {pexp_loc = loc} ->
      raise (Location.Error (
        Location.error ~loc "Not a function or lacking type annotations."))

let solution_structure_mapper mapper s =
  let keep_let_definitions = function
    | {pstr_desc = Pstr_value _} -> true
    | _ -> false
  in
  let remove_type_annotations_in_expression = function
    | {pstr_desc = Pstr_value (rec_flag,
      [{pvb_pat; pvb_expr; pvb_attributes; pvb_loc}])} ->
        let e = remove_type_annotations pvb_expr in
        let vb = {pvb_pat; pvb_expr = e; pvb_attributes; pvb_loc} in
        Str.value rec_flag [vb]
    | x -> x
  in
  List.filter keep_let_definitions s
    |> List.map remove_type_annotations_in_expression

let solution_mapper _argv =
  { default_mapper with
    structure = solution_structure_mapper
  }

let () = register "solution" solution_mapper
