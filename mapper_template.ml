open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree

(* Not only do we not need type annotations, we also don’t want the user to see
 * the solution. *)
let rec get_rid_of_body = function
  (* Argument type annotation. *)
  | {pexp_loc = loc; pexp_desc = Pexp_fun (rec_flag, e,
      {ppat_desc = Ppat_constraint (pattern, ty)}, body)} ->
        Exp.fun_ ~loc rec_flag e pattern (get_rid_of_body body)
  | {pexp_loc = loc; pexp_attributes = attrs;
      pexp_desc = Pexp_constraint _} ->
        Exp.constant ~loc ~attrs (
          Pconst_string ("Replace this string by your implementation.", None))
  | {pexp_loc = loc} ->
      raise (Location.Error (
        Location.error ~loc "Not a function or lacking type annotations."))

let template_structure_mapper mapper s =
  let remove_type_annotations_and_body = function
    | {pstr_desc = Pstr_value (_,
      [{pvb_pat; pvb_expr; pvb_attributes; pvb_loc}])} ->
        let e = Mapper.remove_type_annotations false pvb_expr in
        let vb = {pvb_pat; pvb_expr = e; pvb_attributes; pvb_loc} in
        Str.value Nonrecursive [vb]
    | x -> x
  in
  List.filter Mapper.keep_let_definitions s
    |> List.map remove_type_annotations_and_body

let template_mapper _argv =
  { default_mapper with
    structure = template_structure_mapper
  }

let () = register "template" template_mapper
