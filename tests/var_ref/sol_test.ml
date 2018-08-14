open Test_lib
open Report

let variable_x =
  Section
  ([Text "Variable:"; Code "x"],
  test_variable_against_solution [%ty : int] "x")

let reference_r =
  Section
  ([Text "Reference:"; Code "r"],
  test_ref [%ty : int] r 2)

let () = r := !r - 2

let () =
  set_result @@
  ast_sanity_check code_ast @@
  fun () -> [variable_x; reference_r]
