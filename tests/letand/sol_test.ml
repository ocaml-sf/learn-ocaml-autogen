open Test_lib
open Report

let function_f =
  Section
  ([Text "Function:"; Code "f"],
    test_function_1_against_solution [%ty : int -> int]
    "f" ~gen:10 [])

let function_g =
  Section
  ([Text "Function:"; Code "g"],
    test_function_1_against_solution [%ty : int -> int]
    "g" ~gen:10 [])

let () =
  set_result @@
  ast_sanity_check code_ast @@
  fun () -> [function_f; function_g]
