open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree

let template_structure_mapper mapper s =
  let remove_type_annotations_and_body = function
    | {pstr_desc = Pstr_value (_, vbs)} ->
        let vbs' = Mapper.remove_type_annotations_in_vbs false vbs in
        Str.value Nonrecursive vbs'
    | x -> x
  in
  List.filter Mapper.keep_let_definitions s
    |> List.map remove_type_annotations_and_body

let template_mapper _argv =
  { default_mapper with
    structure = template_structure_mapper
  }

let () = register "template" template_mapper
