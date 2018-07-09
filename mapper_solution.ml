open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree

let solution_structure_mapper mapper s =
  let remove_type_annotations_in_expression = function
    | {pstr_desc = Pstr_value (rec_flag,
      [{pvb_pat; pvb_expr; pvb_attributes; pvb_loc}])} ->
        let e = Mapper.remove_type_annotations true pvb_expr in
        let vb = {pvb_pat; pvb_expr = e; pvb_attributes; pvb_loc} in
        Str.value rec_flag [vb]
    | x -> x
  in
  List.filter Mapper.keep_let_definitions s
    |> List.map remove_type_annotations_in_expression

let solution_mapper _argv =
  { default_mapper with
    structure = solution_structure_mapper
  }

let () = register "solution" solution_mapper
