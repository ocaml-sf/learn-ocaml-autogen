open Test_lib
open Report
let function_id =
  Section
    ([Text "Function:"; Code "id"],
      (test_function_1_against_solution ([%ty :int -> int]) "id" ~gen:10 []))

let () =
  set_result @@ ((ast_sanity_check code_ast) @@ (fun ()  -> [function_id]))
