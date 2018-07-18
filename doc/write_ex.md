# How to write an exercise?

Every input file begins with the required library calls, needed by the test
function.

```ocaml
open Test_lib
open Report
```

## Prelude and prepare

Prelude and prepare functions are written almost as-if. You just write your
function, with an added `%prelude`, or `%prepare` appended to the definition
keyword. This works in particular on `let`, `type` and `module`.

```ocaml
let%prelude pi = 3.14159261

let%prepare map_incr = List.map (fun x -> x + 1)

let%prelude vector_length x y = sqrt (x *. x +. y *. y)
```

As an output, we have:

```ocaml
(* prelude.ml *)
let pi = 3.14159261

let vector_length x y = sqrt (x *. x +. y *. y)
```

```ocaml
(* prepare.ml *)
let map_incr = List.map (fun x -> x + 1)
```

To generate the three other files, you only have to write the solution. Let’s
take an example.

```ocaml
let rec fact (x : int) : int =
  if x <= 1 then 1 else x * (x - 1)

let rec fibonacci (n : int) : int =
  if n <= 1 then n
  else fibonacci (n - 1) + fibonacci (n - 2)

let foo (x : int) (y : float) : float =
  float_of_int x +. sqrt y
```

These functions do not need to be annotated with an *extension* (like
`%prelude`). Every function that is not annotated will be parsed as a solution
into `test.ml`, `template.ml` and `solution.ml`.

It is important to note that *each argument’s type must be annotated*, as well
as the function’s.

## Solution

Inside solution.ml are the functions to test the student against. The file
contains the same functions as in the input file, without type annotations.

```ocaml
(* solution.ml *)
let rec fact x =
  if x <= 1 then 1 else x * (x - 1)

let rec fibonacci n =
  if n <= 1 then n
  else fibonacci (n - 1) + fibonacci (n - 2)

let foo x y =
  (float_of_int x) + sqrt y
```

## Template

Inside template.ml are the same functions, without type annotations and without
the body, which must be filled by the student. Notice that the `rec` indication
is removed from the definiton, to avoid giving away to much informations.

```ocaml
(* template.ml *)
let fact x = "Replace this string by your implementation."

let fibonacci n = "Replace this string by your implementation."

let foo x y = "Replace this string by your implementation."
```

## Test

The file below is generated from the functions defined in the input file. For
general understanding of `test.ml` files, please check [learn-ocaml
tutorials](https://github.com/ocaml-sf/learn-ocaml/blob/master/docs/howto-write-exercises.md).

```ocaml
(* test.ml *)
open Test_lib
open Report

let exercise_fact =
  Section
    ([Text "Function:"; Code "fact"],
      test_function_1_against_solution [%ty : int -> int] "fact"
        ~gen:10 [])

let exercise_fibonacci =
  Section
    ([Text "Function:"; Code "fibonacci"],
      test_function_1_against_solution [%ty : int -> int] "fibonacci"
      ~gen:10 [])

let exercise_foo =
  Section
    ([Text "Function:"; Code "foo"],
      test_function_2_against_solution [%ty : int -> float -> float] "foo"
        ~gen:10 [])

let () =
  set_result @@
  ast_sanity_check code_ast @@
  fun () -> [exercise_fact; exercise_fibonacci; exercise_foo]
```

We use the `test_function_n_against_solution` function to test the student’s
answer against our solutions. `n` is the number of arguments of the function
and is automatically deduced from the type. Watch out, though, that Learn-OCaml
autogen does not support functions with more than four arguments, because it
would add complexity to autogen’s input files. The `%ty` extension is generated
from the type annotations.

Tests are done upon ten generated inputs. You can change this amount by
updating the `gen` argument in the generated file. You can also add inputs that
will always be tested in the list next to it.

## More on input files

- The order of every element of the file (prelude and prepare definitions,
  solutions) is of no importance. Still, we advise regrouping definitions
  according to their destination file to avoid confusion.
- As you probably noticed, only solution functions need to have type
  annotations. This is used to create the `%ty` argument in the test function,
  and therefore not useful anywhere else.
