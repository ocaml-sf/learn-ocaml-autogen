# How to use Learn-OCaml autogen?

Suppose we have a Learn-OCaml exercises directory. We want to create a new
exercise *circle*. Learn-OCaml autogen only needs an exercise directory with a
file called `input.ml`.

So, let’s create `circle/input.ml`. You can copy the following code to follow
this tutorial. Detailed instructions to write an input file are available
[here](write_ex.md).

```ocaml
open Test_lib
open Report

let%prelude pi = 3.14159265

let diameter (r : float) : float = 2. *. pi *. r
```

The command `learn-ocaml-autogen circle` will generate every file needed by
Learn-OCaml: `prelude.ml`, `prepare.ml`, `solution.ml`, `template.ml` and
`test.ml`. You can run Learn-OCaml and verify that the exercise was correctly
generated. If you want to change its content, modify input.ml and run
`learn-ocaml autogen circle` again.

You can also use Learn-OCaml autogen to generate files for several exercises by
using the `learn-ocaml-autogen` with as many arguments as you wish. For
example:
```bash
learn-ocaml-autogen circle recursivity sum_types
```

To generate only certain files, add `--` after the exercises names, followed by
the kind of files you want. For example:
```
learn-ocaml-autogen circle recursivity sum_types -- test template
```
