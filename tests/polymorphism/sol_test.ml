open Test_lib
open Report

let function_return_three =
  Section
  ([Text "Function:"; Code "return_three"],
  test_function_1_against_solution [%ty : int -> int] "return_three"
  ~sampler:sample_int
  ~gen:10 [] @
  test_function_1_against_solution [%ty : char -> int] "return_three"
  ~sampler:sample_char
  ~gen:10 [])

let function_fst =
  Section
  ([Text "Function:"; Code "fst"],
  test_function_1_against_solution [%ty : int * int -> int] "fst"
  ~sampler:(fun () -> (sample_int (), sample_int ()))
  ~gen:10 [] @
  test_function_1_against_solution [%ty : int * char -> int] "fst"
  ~sampler:(fun () -> (sample_int (), sample_char ()))
  ~gen:10 [])

let function_id =
  Section
  ([Text "Function:"; Code "id"],
  test_function_1_against_solution [%ty : int -> int] "id"
  ~sampler:(fun () -> (Random.int 100))
  ~gen:10 [])

let () =
  set_result @@
  ast_sanity_check code_ast @@
  fun () -> [function_return_three; function_fst; function_id]
