# How to use Learn-OCaml autogen?

Suppose we have a Learn-OCaml exercises directory called `exercises`. We want
to create a new exercise named *circle*. Learn-OCaml autogen only needs an
exercise directory with a file called `input.ml`.

So, let’s create `circle/input.ml`. You can copy the following code to follow
this tutorial. Detailed instructions to write an input file are available
[here](write_ex.md).

```ocaml
open Test_lib
open Report

let%meta stars = 1
let%meta title = "Diameter"
let%meta short_description = "Compute the diameter of a circle"
let%meta identifier = "diameter"
let%meta authors = [("Sarah Smith", "sarahs@mail.org")]

let%prelude pi = 3.14159265

let diameter (r : float) : float = 2. *. pi *. r
```

The command `learn-ocaml-autogen circle`, ran from `exercises`, will generate
every file needed by Learn-OCaml: `prelude.ml`, `prepare.ml`, `solution.ml`,
`template.ml`, `test.ml` and `meta.json`. You can run Learn-OCaml and verify
that the exercise was correctly generated. If you want to change its content,
modify `input.ml` and run `learn-ocaml autogen circle` again. Of course, you
can also modify directly the output files, be beware that if you run autogen
again, your changes will be deleted.

You can also use Learn-OCaml autogen to generate files for several exercises by
using `learn-ocaml-autogen` with as many arguments as you wish. For example:
```bash
learn-ocaml-autogen circle recursivity sum_types
```

There are several options available. You can in particular choose which files
to generate. Options are shown by running `learn-ocaml-autogen --help`.
