open Test_lib
open Report

let function_fst =
  Section
  ([Text "Function:"; Code "fst"],
  test_function_1_against_solution [%ty : int * int -> int] "fst"
  ~sampler:(fun () -> (sample_int (), sample_int ()))
  ~gen:10 [] @
  test_function_1_against_solution [%ty : int * int -> int] "fst"
  ~sampler:(fun () -> (0, Random.int 10))
  ~gen:10 [])

let function_print =
  Section
  ([Text "Function:"; Code "print"],
  test_function_1_against_solution [%ty : char * int -> string] "print"
  ~sampler:(fun () -> (sample_char (), sample_int ()))
  ~gen:10 [] @
  test_function_1_against_solution [%ty : char * int -> string] "print"
  ~sampler:(fun () -> ('a', 15))
  ~gen:10 [] @
  test_function_1_against_solution [%ty : char * int -> string] "print"
  ~sampler:(fun () -> (sample_char (), Random.int 26))
  ~gen:10 [])

let () =
  set_result @@
  ast_sanity_check code_ast @@
  fun () -> [function_fst; function_print]
