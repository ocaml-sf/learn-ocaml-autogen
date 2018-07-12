open Test_lib
open Report

let exercise_plus =
  Section
    ([Text "Function:"; Code "plus"],
      (test_function_2_against_solution ([%ty :int -> int -> int]) "plus"
         ~gen:10 []))

let exercise_minus =
  Section
    ([Text "Function:"; Code "minus"],
      (test_function_2_against_solution ([%ty :int -> int -> int]) "minus"
         ~gen:10 []))

let exercise_times =
  Section
    ([Text "Function:"; Code "times"],
      (test_function_2_against_solution ([%ty :int -> int -> int]) "times"
         ~gen:10 []))

let exercise_divide =
  Section
    ([Text "Function:"; Code "divide"],
      (test_function_2_against_solution ([%ty :int -> int -> int]) "divide"
         ~gen:10 []))

let () =
  set_result @@
    ((ast_sanity_check code_ast) @@
       (fun ()  ->
          [exercise_plus; exercise_minus; exercise_times; exercise_divide]))

