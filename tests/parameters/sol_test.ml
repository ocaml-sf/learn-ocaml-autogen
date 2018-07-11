open Test_lib
open Report

let exercise_f =
  Section
    ([Text "Function:"; Code "f"],
      (test_function_1_against_solution ([%ty :int -> int]) "f" ~gen:10 []))

let exercise_g =
  Section
    ([Text "Function:"; Code "g"],
      (test_function_2_against_solution
         ([%ty :int -> (int -> int) -> (int * (int -> int))]) "g" ~gen:10 []))

let exercise_h =
  Section
    ([Text "Function:"; Code "h"],
      (test_function_3_against_solution
         ([%ty
            :int ->
               (int -> int) ->
                 (int -> int -> int) ->
                   (int * (int -> int) * (int -> int -> int))]) "h" ~gen:10
         []))

let exercise_i =
  Section
    ([Text "Function:"; Code "i"],
      (test_function_4_against_solution
         ([%ty :int -> bool -> char -> float -> (int * bool * char * float)])
         "i" ~gen:10 []))

let () =
  set_result @@
    ((ast_sanity_check code_ast) @@
       (fun ()  -> [exercise_f; exercise_g; exercise_h; exercise_i]))
