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

let function_concat =
  Section
    ([Text "Function:"; Code "concat"],
      (test_function_2_against_solution ([%ty :string -> int -> string])
         "concat" ~gen:10 []))

let function_recursive =
  Section
    ([Text "Function:"; Code "recursive"],
      (test_function_1_against_solution ([%ty :float -> float]) "recursive"
         ~gen:10 []))

let () =
  set_result @@
    ((ast_sanity_check code_ast) @@
       (fun ()  ->
          [function_plus;
          function_minus;
          function_concat;
          function_recursive]))
