# Advanced features

## Testing a variable

Defining a test on a function is as easy as writing the solution down.
```ocaml
let incr (x : int) : int = x + 1
```

However, when defining a test on a variable, the extension `%var` is needed,
to differenciate it from a function. You also need to annotate the type.
```ocaml
let%var x : float = sqrt 2.
```
The behaviour of autogen will be very similar to when dealing with functions,
only the test will be a bit different, as we are testing a unique value.

## Testing polymorphic functions

For now, we have only defined tests on *monomorphic* functions. What if we want
to test *polymorphic* functions, such as generic functions on lists?

The idea is to have several tests concatenated together, where each of these
tests is done on a precise type, without type variables. For instance, I ask a
student to rewrite `List.map`, so that it works on every `'a list`.
```ocaml
let map f = function
  | [] -> []
  | h :: r -> (f h) :: map f r
```
The type of this function is `('a -> 'b) -> 'a list -> 'b list`. So, I might
for example want to try it for `'a = int` and `'b = float` and `'a = char` and
`'b = char`. This way, I’m assured that the function works for different `'a`s
and `'b`s.

We are going to use something that is already there in autogen: defining
several samplers for a function. It goes as follows:

1) Write the function to test.
2) Define as many samplers as different types you want to test.

The first step is trivial. There is one particularity: as the function is
polymorphic, you don’t have to write its type. Type will be given by the
samplers.

Second step is the same construction as
[usual](how-to-define-samplers.md#samplers-attached-to-one-function),
with only one difference: the type of the function is given inside the
attribute. Remember that the name of the sampler doesn’t have any importance.
```ocaml
let%sampler[@map : (int -> float) -> int list -> float list] sample_map =
  fun () -> (float_of_int, sample_list sample_int ())
let%sampler[@map : (char -> char) -> char list -> char list] sample_map =
  fun () -> (fun c -> c, sample_list sample_char ())
```

Note that for monomorphic functions, you can have either type annotations on
the definition, or in the sampler if you have one (or both). For example:
```ocaml
let%sampler[@incr : int -> int] sample_incr = sample_int

let incr x = x + 1
```
