open Test_lib
open Report

type int_int = int * int
let sample_int_int () = (1, 2)

let sample_float () = 3.14159261

let function_make_tuple =
  Section
  ([Text "Function:"; Code "make_tuple"],
  (test_function_1_against_solution ([%ty : int -> int * int]) "make_tuple"
  ~gen:10 []))

let function_join =
  Section
  ([Text "Function:"; Code "join"],
  (test_function_2_against_solution ([%ty : char -> float -> (char * float)]) "join"
  ~sampler:(fun () -> ('a', 2.))
  ~gen:10 []))

let () =
  set_result @@
    ((ast_sanity_check code_ast) @@
       (fun ()  ->
          [function_make_tuple;
          function_join]))
