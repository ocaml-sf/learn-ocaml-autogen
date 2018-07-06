open Test_lib
open Report

let exercise_plus =
  Section
    ([ Text "Function:" ; Code "plus" ],
     test_function_2_against_solution
       [%ty : int -> int -> int ] "plus"
       ~gen:10 [])

let exercise_minus =
  Section
    ([ Text "Function:" ; Code "minus" ],
     test_function_2_against_solution
       [%ty : int -> int -> int ] "minus"
       ~gen:10 [])

let exercise_concat =
  Section
    ([ Text "Function:" ; Code "concat" ],
     test_function_2_against_solution
       [%ty : string -> int -> string ] "concat"
       ~gen:10 [])

let exercise_recursive =
  Section
    ([ Text "Function:" ; Code "recursive" ],
     test_function_1_against_solution
       [%ty : float -> float ] "recursive"
       ~gen:10 [])

let () =
  set_result @@
  ast_sanity_check code_ast @@ fun () ->
    [ exercise_plus; exercise_minus; exercise_concat; exercise_recursive]
