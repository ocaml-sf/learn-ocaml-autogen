open Test_lib
open Report
type int_int = (int * int)
let sample_int_int () = ((Random.int 20), (Random.int 20))
let function_incr_tuple =
  Section
    ([Text "Function:"; Code "incr_tuple"],
      (test_function_1_against_solution ([%ty :int_int -> int_int])
         "incr_tuple" ~sampler:(fun ()  -> (4, 2)) ~gen:10 []))

let function_incrincr_tuple =
  Section
    ([Text "Function:"; Code "incrincr_tuple"],
      (test_function_1_against_solution ([%ty :int_int -> int_int])
         "incrincr_tuple" ~gen:10 []))

let function_decr_tuple =
  Section
    ([Text "Function:"; Code "decr_tuple"],
      (test_function_1_against_solution ([%ty :int_int -> int_int])
         "decr_tuple" ~sampler:(fun ()  -> (4, 2)) ~gen:10 []))

let function_id_tuple =
  Section
    ([Text "Function:"; Code "id_tuple"],
      (test_function_1_against_solution ([%ty :int_int -> int_int])
         "id_tuple" ~sampler:(fun ()  -> (4, 2)) ~gen:10 []))

let () =
  set_result @@
    ((ast_sanity_check code_ast) @@
       (fun ()  ->
          [function_incr_tuple;
          function_incrincr_tuple;
          function_decr_tuple;
          function_id_tuple]))

