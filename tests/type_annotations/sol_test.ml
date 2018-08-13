open Test_lib
open Report

let function_f =
  Section
  ([Text "Function:"; Code "f"],
  test_function_2_against_solution [%ty : int -> float -> float] "f"
  ~gen:10 [])

let function_g =
  Section
  ([Text "Function:"; Code "g"],
  test_function_2_against_solution [%ty : int -> float -> float] "g"
  ~sampler:(fun () -> sample_int(), sample_float ())
  ~gen:10 [])

let function_h =
  Section
  ([Text "Function:"; Code "h"],
  test_function_2_against_solution [%ty : int -> float -> float] "h"
  ~sampler:(fun () -> sample_int (), sample_float ())
  ~gen:10 [])

let function_i =
  Section
  ([Text "Function:"; Code "i"],
  test_function_2_against_solution [%ty : int -> int -> float] "i"
  ~sampler:(fun () -> sample_int (), sample_int ())
  ~gen:10 [] @
  test_function_2_against_solution [%ty : char -> bool -> float] "i"
  ~sampler:(fun () -> sample_char (), sample_bool ())
  ~gen:10 [])

let function_j =
  Section
  ([Text "Function:"; Code "j"],
  test_function_2_against_solution [%ty : int -> char -> int * char] "j"
  ~sampler:(fun () -> sample_int (), sample_char ())
  ~gen:10 [] @
  test_function_2_against_solution [%ty : float -> bool -> float * bool] "j"
  ~sampler:(fun () -> sample_float (), sample_bool ())
  ~gen:10 [])

let () =
  set_result @@
  ast_sanity_check code_ast @@
  fun () -> [function_f; function_g; function_h; function_i; function_j]
