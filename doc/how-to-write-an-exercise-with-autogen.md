# How to write an exercise with Learn-OCaml autogen?

Every input file begins with the required library calls, needed by the test
function.

```ocaml
open Test_lib
open Report
```

## Prelude and prepare

In Learn-OCaml, it is possible to define code that must be loaded before the
student’s answer inside a `prelude.ml` file. We may also hide code to the
student by putting it in `prepare.ml`. Both of these files contain generic
OCaml code.

Inside `input.ml`, expressions written for prelude and prepare are written
almost as-if. You just write your definition or directive, introduced by
`let%prelude` or `let%prepare`. This works in particular on `let`, `type`,
`module` or `open`.

```ocaml
open%prelude String

let%prelude pi = 3.14159261

let%prepare map_incr = List.map (fun x -> x + 1)

let%prelude vector_length x y = sqrt (x *. x +. y *. y)
```

As an output, we have:

```ocaml
(* prelude.ml *)
open String

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

Inside `solution.ml` are the functions to test the student against. The file
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
the body, which must be filled by the student. Notice that the `rec` annotation
is removed from the definiton, to avoid giving away to much informations.

```ocaml
(* template.ml *)
let fact x = "Replace this string with your implementation."

let fibonacci n = "Replace this string with your implementation."

let foo x y = "Replace this string with your implementation."
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

Tests are done upon 10 generated inputs. You can change this amount by
updating the `gen` argument in the generated file. You can also add inputs that
will always be tested in the list next to it.

## About type annotation

It is important that you remember to annotate solution functions. This allows
the generation of the `%ty` extension in the arguments of the test function.
The style supported is
```ocaml
let f (arg_1 : type_1) (arg_2 : type_2) … (arg_n : type_n) : return_type = …
```
There is no need to give type annotation to prelude and prepare functions. If
you wish to do so, be aware that these annotations will be transcribed as such
inside `prelude.ml` or `prepare.ml`.

## Remarks

The order of the expressions in the file matters only between expressions with
the same goal. Prelude expressions will be written in the same order as in
`input.ml` inside `prelude.ml`. Same for `prepare.ml` and solution functions.
But between files, order does not matter. Prelude, prepare and solution
expressions can be mixed together. We could put every prelude function at the
end of the file, and prepare at the beginning.

We advise to keep a constant style of ordering. For example, always having
prelude and prepare expressions at the beginning of `input.ml`. Most
importantly, it is a good idea to keep expressions together according to their
destination files. This avoids confusion on bigger files.
