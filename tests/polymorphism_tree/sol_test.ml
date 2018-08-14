open Test_lib
open Report

let sample_tree sample = fun () -> Leaf (sample ())

let function_find =
  Section
  ([Text "Function:"; Code "find"],
  test_function_2_against_solution [%ty : int -> int tree -> bool] "find"
  ~sampler:(fun () -> sample_int (), sample_tree sample_int ())
  ~gen:10 [] @
  test_function_2_against_solution [%ty : char -> char tree -> bool] "find"
  ~sampler:(fun () -> sample_char (), sample_tree sample_char ())
  ~gen:10 [])

let function_fst =
  Section
  ([Text "Function:"; Code "fst"],
  test_function_1_against_solution [%ty : int tree -> int] "fst"
  ~sampler:(sample_tree sample_int)
  ~gen:10 [] @
  test_function_1_against_solution [%ty : char tree -> char] "fst"
  ~sampler:(sample_tree sample_char)
  ~gen:10 [])

let () =
  set_result @@
  ast_sanity_check code_ast @@
  fun () -> [function_find; function_fst]
