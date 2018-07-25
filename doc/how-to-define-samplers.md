# How to test functions with user-defined types: definition of a sampler

Let’s say we have a function that takes a pair of integers as an argument.
There is no automatic generation of test arguments out of the box in OCaml for
the type `int * int`. Thus, we have to define a *sampler*. In Learn-OCaml
autogen as well as in Learn-OCaml, we can have samplers both:
- globally for a defined type,
- and locally for one or more functions.

We begin by showing the syntax for globally defined samplers, then for samplers
relative to a function.

## Global samplers

There are two steps in defining a sampler:
- first, we declare the new type `t`,
- then, we define a sampler named `sampler_t`.
In our example,
```ocaml
type int_int = int * int

let sampler_int_int () = (Random.int 10, Random.int 5)
```

Learn-OCaml recognizes the type attached to a sampler by its name. By naming
(and this is necessary) the sampler `sampler_int_int`, it automatically assigns
this sampler to every argument of type `int_int`, that is `int * int`. The type
of a sampler is `unit -> t`. More informations about samplers in Learn-OCaml
are available
[here](https://github.com/ocaml-sf/learn-ocaml/blob/master/docs/howto-write-exercises.md).

If we now have a function `add_pair`, that sums both elements of a pair, there
the tuples `(x, y)` will be generated with `sampler_int_int`.
```ocaml
let add_pair ((x, y) : int_int) : int = x + y
```

## Samplers attached to one function

Now, let’s suppose we have a function `divide_pair`. This function gives the
division of the two elements of the input pair back.
```ocaml
let divide_pair ((x, y) : int_int) : int = x / y
```
For this function, we don’t want to use `sampler_int_int`. We don’t want to
test the case `y = 0` which fails for every `x`. We instead want to use the
following sampler:
```ocaml
let no_zero () = (Random.int 10, Random.int 4 + 1)
```

Inside a Learn-OCaml `test.ml` file, we would add the optional argument
`~sample:no_zero` to the test function of `divide_pair`. Notice that we could
have directly given the function anonymously, instead of pre-defining it. That
would be:
```ocaml
~sample:fun () -> (Random.int 10, Random.int 4 + 1)
```

In autogen, we use
```ocaml
let[%sampler divide_pair] = fun () -> (Random.int 10, Random.int 4 + 1)
```

Here, we use brackets around the `%sampler` keyword. This allows us to give the
name of the function we want the sampler attached to. In the output `test.ml`,
we will have a `~sample` argument with this anonymous function.

You can also give several names inside the brackets, such as
```ocaml
let[%sampler divide_pair multiply_pair add_pair]
```
