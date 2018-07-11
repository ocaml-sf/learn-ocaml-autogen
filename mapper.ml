open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree

let keep_let_definitions = function
  | {pstr_desc = Pstr_value _} -> true
  | _ -> false

(* The type of the function is only used in grading, not in the solution nor
 * the template. *)
let rec remove_type_annotations keep_body = function
  (* Argument type annotations. *)
  | {pexp_loc = loc; pexp_desc = Pexp_fun (rec_flag, e,
      {ppat_desc = Ppat_constraint (pattern, ty)}, body)} ->
        Exp.fun_ ~loc rec_flag e pattern (remove_type_annotations keep_body body)
  (* ty is the last type annotation: the return type. *)
  | {pexp_loc = loc; pexp_attributes = attrs;
      pexp_desc = Pexp_constraint (e, ty)} ->
        if keep_body then e
        else
          Exp.constant ~loc ~attrs (Pconst_string (
            "Replace this string by your implementation.", None))
  | {pexp_loc = loc} ->
      raise (Location.Error (
        Location.error ~loc "Not a function or lacking type annotations."))

let remove_type_annotations_in_vbs keep_body =
  let fetch_e_and_remove {pvb_pat; pvb_expr; pvb_attributes; pvb_loc} =
    let e = remove_type_annotations keep_body pvb_expr in
    {pvb_pat; pvb_expr = e; pvb_attributes; pvb_loc}
  in List.map fetch_e_and_remove

let keep_in_struct extension_name mapper s =
  let keep_correct_extensions = function
    | {pstr_desc = Pstr_extension (({txt}, _), _)} when txt = extension_name ->
        true
    | _ -> false
  in
  let unwrap_extension acc = function
    | {pstr_desc = Pstr_extension ((_, PStr items), _)} ->
        acc @ items
    | x -> acc
  in
  List.filter keep_correct_extensions s
    |> List.fold_left unwrap_extension []

(* Generates a mapper who ignores all expressions but the ones with the
 * extension txt *)
let mk_mapper txt _argv =
  { default_mapper with
    structure = keep_in_struct txt
  }
