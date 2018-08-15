# How to test functions with user-defined types: definition of a sampler

Let’s say we have a function that takes a pair of integers as an argument.
There is no automatic generation of test arguments out of the box in OCaml for
the type `int * int`. Thus, we have to define a *sampler*. In Learn-OCaml
autogen as well as in Learn-OCaml, we can have samplers both:
- globally for a defined type,
- and locally for one or more functions.

We begin by showing the syntax for globally defined samplers, then for samplers
relative to a function. It is better to read this how-to after reading the
[tutorial](https://github.com/ocaml-sf/learn-ocaml/blob/master/docs/howto-write-exercises.md)
on samplers.

## Global samplers

There are two steps in defining a sampler:
- first, we declare the new type `t`,
- then, we define a sampler named `sample_t`.
In our example,
```ocaml
type int_int = int * int

let sampler_int_int () = (Random.int 10, Random.int 5)
```

If we now have a function `add_pair`, that sums both elements of a pair, there
the tuples `(x, y)` will be generated with `sampler_int_int`.
```ocaml
let add_pair (x, y : int_int) : int = x + y
```

This method is the same as without autogen. Note that there no extensions are
necessary.

## Samplers attached to one function

Now, let’s suppose we have a function `divide_pair`. This function gives the
division of the two elements of the input pair back.
```ocaml
let divide_pair (x, y : int_int) : int = x / y
```
For this function, we don’t want to use `sample_int_int`. We don’t want to test
the case `y = 0` which fails for every `x`. We instead want to use the
following sampler:
```ocaml
let no_zero () = (Random.int 10, Random.int 4 + 1)
```

In autogen, we declare:
```ocaml
let%sampler[@divide_pair] sample_divide_pair =
  fun () -> (Random.int 10, Random.int 4 + 1)
```

Here, we attach an *attribute* to `%sampler`. This allows us to give the name
of the function we want the sampler attached to. In the output `test.ml`, the
optional `~sampler` argument will be instanciated with this anonymous function.
```ocaml
~sampler:(fun () -> (Random.int 10, Random.int 4 + 1))
```
The name that we give to the sampler, here `sample_divide_pair` is of no
importance and will be ignored. But, watch out: the sampler has to be defined
before the function.

You can also give several attributes to assign the sampler to several
functions, such as:
```ocaml
let%sampler[@divide_pair][@multiply_pair][@add_pair] sample_divide_pair = …
```
Obviously, the order of the attributes does not matter, as long as the
functions appear after the sampler.

There can be several samplers referencing one function. Then, this function
will have several sets of tests, one for each sampler.
