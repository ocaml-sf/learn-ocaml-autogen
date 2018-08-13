open Test_lib
open Report

let function_id =
  Section
  ([Text "Function:"; Code "id"],
  test_function_1_against_solution [%ty : int -> int] "id"
  ~sampler:sample_int
  ~gen:10 [] @
  test_function_1_against_solution [%ty : char -> char] "id"
  ~sampler:sample_char
  ~gen:10 [] @
  test_function_1_against_solution
  [%ty : int * int option -> int * int option] "id"
  ~sampler:(
    let no_0 x = if x = 0 then None else Some x in
    fun () -> (sample_int (), no_0 (sample_int ())))
  ~gen:10 [])

let function_fst =
  Section
  ([Text "Function:"; Code "fst"],
  test_function_2_against_solution [%ty : int -> float -> int] "fst"
  ~sampler:(fun () -> (Random.int 10, Random.float 10.))
  ~gen:10 [] @
  test_function_2_against_solution [%ty : float -> int -> float] "fst"
  ~sampler:(fun () -> (Random.float 10., Random.int 10))
  ~gen:10 [])

let function_fst_of_three =
  Section
  ([Text "Function:"; Code "fst_of_three"],
  test_function_1_against_solution
  [%ty : int * char * float -> int] "fst_of_three"
  ~sampler:(fun () -> (sample_int (), sample_char (), sample_float ()))
  ~gen:10 [] @
  test_function_1_against_solution
  [%ty : int * char * int -> int] "fst_of_three"
  ~sampler:(fun () -> (sample_int (), sample_char (), sample_int ()))
  ~gen:10 [])

let function_map =
  Section
  ([Text "Function:"; Code "map"],
  test_function_2_against_solution
  [%ty : (int -> float) -> int option -> float option] "map"
  ~sampler:(fun () -> (float_of_int, (sample_option sample_int) ()))
  ~gen:10 [] @
  test_function_2_against_solution
  [%ty : (int -> int) -> int option -> int option] "map"
  ~sampler:(fun () -> ((fun x -> x), None))
  ~gen:10 [])

let function_return =
  Section
  ([Text "Function:"; Code "return"],
  test_function_1_against_solution
  [%ty : int -> int option] "return"
  ~sampler:sample_int
  ~gen:10 [] @
  test_function_1_against_solution
  [%ty : char -> char option] "return"
  ~sampler:sample_char
  ~gen:10 [])

let function_map2 =
  Section
  ([Text "Function:"; Code "map2"],
  test_function_3_against_solution
  [%ty : (int -> char -> string) -> int option -> char option -> string option]
  "map2"
  ~sampler:(fun () -> (
    String.make, Some (Random.int 10), (sample_option sample_char) ()))
  ~gen:10 [] @
  test_function_3_against_solution
  [%ty : (char list list -> char list -> bool) -> char list list option ->
    char list option -> bool option]
  "map2"
  ~sampler:(fun () ->
    ((fun l l' -> List.concat l = l'),
    sample_option (sample_list (sample_list sample_char)) (),
    sample_option (sample_list sample_char) ()))
  ~gen:10 [])

let () =
  set_result @@
  ast_sanity_check code_ast @@
  fun () -> [
    function_id;
    function_fst;
    function_fst_of_three;
    function_map;
    function_return;
    function_map2
  ]
