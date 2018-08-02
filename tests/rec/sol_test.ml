open Test_lib
open Report

let exercise_f =
  Section
    ([Text "Function:"; Code "f"],
      (test_function_1_against_solution
         ([%ty : bool -> int]) "f" ~gen:10 []))

let () =
  set_result @@ ((ast_sanity_check code_ast) @@ (fun ()  -> [exercise_f]))
