open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree

let extension_mapper items payload = function
  | "var" -> List.map (Mapper.remove_type_annotations_in_expression true) items
  | "solution" -> items
  | _ -> []

let solution_mapper _argv =
  { default_mapper with
    structure =
      Mapper.solution_template_structure_mapper true extension_mapper
  }

let () = register "solution" solution_mapper
