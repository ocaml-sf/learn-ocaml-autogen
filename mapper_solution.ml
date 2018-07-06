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
  let rec aux s acc =
    match s with
    (* Keep let definitions. *)
    | {pstr_desc = Pstr_value (rec_flag,
      [{pvb_pat; pvb_expr; pvb_attributes; pvb_loc}])} :: s' ->
        let e = remove_type_annotations pvb_expr in
        let vb = {pvb_pat; pvb_expr = e; pvb_attributes; pvb_loc} in
        aux s' (Str.value rec_flag [vb] :: acc)
    (* Ignore the rest *)
    | x :: s' -> aux s' acc
    | [] -> acc
  in List.rev (aux s [])

let solution_mapper _argv =
  { default_mapper with
    structure = solution_structure_mapper
  }

let () = register "solution" solution_mapper
