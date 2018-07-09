open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree

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
