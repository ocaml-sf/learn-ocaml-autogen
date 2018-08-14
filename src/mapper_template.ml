open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree

let extension_mapper items payload = function
  | "var" -> List.map (Mapper.remove_type_annotations_in_expression false) items
  | "template" -> items
  | _ -> []

let template_mapper _argv =
  { default_mapper with
    structure =
      Mapper.solution_template_structure_mapper false extension_mapper
  }

let () = register "template" template_mapper
