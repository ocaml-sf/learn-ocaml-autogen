open Test_lib
open Report

let function_f =
  Section
    ([Text "Function:"; Code "f"],
      (test_function_1_against_solution ([%ty :int -> int]) "f" ~gen:10 []))

let function_g =
  Section
    ([Text "Function:"; Code "g"],
      (test_function_2_against_solution
         ([%ty :int -> float -> (int * float)]) "g" ~gen:10 []))

let function_h =
  Section
    ([Text "Function:"; Code "h"],
      (test_function_3_against_solution
         ([%ty :int -> float -> char -> (int * float * char)]) "h" ~gen:10 []))

let function_i =
  Section
    ([Text "Function:"; Code "i"],
      (test_function_4_against_solution
         ([%ty :int -> bool -> char -> float -> (int * bool * char * float)])
         "i" ~gen:10 []))

let () =
  set_result @@
    ((ast_sanity_check code_ast) @@
       (fun ()  -> [function_f; function_g; function_h; function_i]))
