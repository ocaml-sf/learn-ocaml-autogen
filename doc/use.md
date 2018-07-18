# How to use Learn-OCaml autogen?

Suppose we have a learn-ocaml exercises directory. We want to create a new
exercise *maths*. Learn-OCaml autogen only needs an exercise directory with a
file called `input.ml`.

So, let’s create maths/input.ml. You can copy the following code to follow this
tutorial. Detailed instructions to write an input file are avaible
[here](write_ex.md).

```ocaml
open Test_lib
open Report

let%prelude pi = 3.14159261

let diameter (r : float) = 2. *. pi *. r
```

`learn-ocaml-autogen maths` will generate every file needed by Learn-OCaml:
prelude.ml, prepare.ml, solution.ml, template.ml and test.ml. You can run OCaml
to try it for yourself. If you want to change the content of the exercise,
modify input.ml and run `learn-ocaml autogen maths` once again.

You can also use Learn-OCaml autogen to generate files for several exercises by
using `learn-ocaml-autogen` with as many arguments as you wish, for example:
```bash
learn-ocaml-autogen maths recursivity sum_types
```

To only generate certain files, add `--` after the exercises names followed by
the kind of files you want. For example:
```bash
learn-ocaml-autogen maths recursivity sum_types -- test template
```
