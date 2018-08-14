open Test_lib
open Report

type int_int = int * int
type int_arr_int = int -> int
type float_int = float * int

let rec sample_int_int () = (1, 1)
and sample_int_arr_int () = fun x -> x
and sample_float_int () = (1., 1)

let function_make_tuple =
  Section
  ([Text "Function:"; Code "make_tuple"],
  test_function_1_against_solution [%ty : int -> float_int] "make_tuple"
  ~gen:10 [])

let function_make_int_tuple =
  Section
  ([Text "Function:"; Code "make_int_tuple"],
  test_function_1_against_solution [%ty : char -> int_int] "make_int_tuple"
  ~gen:10 [])

let function_id_int =
  Section
  ([Text "Function:"; Code "id_int"],
  test_function_1_against_solution [%ty : int -> int] "id_int"
  ~sampler:(fun () -> Random.int 10 mod 2)
  ~gen:10 [])

let function_id_float =
  Section
  ([Text "Function:"; Code "id_float"],
  test_function_1_against_solution [%ty : float -> float] "id_float"
  ~gen:10 [])

type char_int = char * int
type int_char = int * char

let rec sample_char_int () =
  let i = Random.int 255 in
  (i, char_of_int i)
and sample_int_char () =
  let (i, c) = sample_char_int () in (c, i)

let () =
  set_result @@
    ((ast_sanity_check code_ast) @@
       (fun ()  ->
          [function_make_tuple;
          function_make_int_tuple;
          function_id_int;
          function_id_float]))
