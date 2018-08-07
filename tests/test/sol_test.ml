open Test_lib
open Report

let function_plus =
  Section
    ([Text "Function:"; Code "plus"],
      (test_function_2_against_solution ([%ty :int -> int -> int]) "plus"
         ~gen:10 []))

let function_minus =
  Section
    ([Text "Function:"; Code "minus"],
      (test_function_2_against_solution ([%ty :int -> int -> int]) "minus"
         ~gen:10 []))

let function_times =
  Section
    ([Text "Function:"; Code "times"],
      (test_function_2_against_solution ([%ty :int -> int -> int]) "times"
         ~gen:10 []))

let function_divide =
  Section
    ([Text "Function:"; Code "divide"],
      (test_function_2_against_solution ([%ty :int -> int -> int]) "divide"
         ~gen:10 []))

let () =
  set_result @@
    ((ast_sanity_check code_ast) @@
       (fun ()  ->
          [function_plus; function_minus; function_times; function_divide]))

