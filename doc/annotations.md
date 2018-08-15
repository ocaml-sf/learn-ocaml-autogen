# Annotations used in Learn-OCaml autogen

This document is intended as a reference on the annotations supported by
Learn-OCaml autogen. If you haven’t, it is advised reading [how to write an
exercise with autogen](how-to-write-an-exercise-with-autogen.md) first.

Several annotations are used in Learn-OCaml autogen to discriminate some
expressions from the rest of the program. There are currently eight different
supported annotations.

<dl>
  <dt><code>%meta</code></dt>
  <dd>This annotation is used to distinguish definitions of metadata fields
  that are to be transposed into <code>meta.json</code>.</dd>

  <dt><code>%prelude</code></dt>
  <dd>Transposes the annotated expression directly into
  <code>prelude.ml</code>.</dd>

  <dt><code>%prepare</code></dt>
  <dd>Transposes the annotated expression directly into
  <code>prepare.ml</code>.</dd>

  <dt><code>%sampler<code></dt>
  <dd>This annotation is used to define a sampler for specific functions. It
  has to be associated with attributes naming these functions.</dd>

  <dt><code>%solution</code></dt>
  <dd>Transposes the annotated expression directly into
  <code>solution.ml</code>.</dd>

  <dt><code>%template</code></dt>
  <dd>Transposes the annotated expression directly into
  <code>template.ml</code>.</dd>

  <dt><code>%test</code></dt>
  <dd>Transposes the annotated expression directly into
  <code>test.ml</code>.</dd>

  <dt><code>%var</code></dt>
  <dd>This annotation is used on a variable definition. It identifies the
  variable definition as an exercise for the student and parses it to a test,
  as well as including it into the template.</dd>
</dl>

You might have recognized OCaml’s *ppx extensions*. The following describes
their use in the context of Learn-OCaml autogen. A detailed description of the
syntax of extensions is given
[here](https://caml.inria.fr/pub/docs/manual-ocaml/extn.html#sec262).

Annotations apply to a global definition to discriminate them from the rest of
the program. A definition with an annotation will be written with `%annot`
appended to the keyword, without a space between them.
```ocaml
type%prepare tree =
  | Node of tree * tree
  | Leaf of int

let%prepare null_tree = Leaf 0
```

We can distinguish two classes of annotations. The first one contains the
annotations that simply transpose a definiton as is to a file. These are
`%prelude`, `%prepare`, `%solution`, `%template` and `%test`. They can be used
on any global definition. Valid keywords are:
```
keywords :=
  | class
  | class type
  | exception
  | external
  | include
  | let
  | module
  | module type
  | open
  | type
```
A recursive `let` definition can be defined using the following syntax.
```ocaml
let%annot rec f x = …
```

The second class is the set of annotations for which the expression is parsed
before being written in one or more file(s). These annotations are only valid
on `let` definitions.
```
keywords_specials := let
```
They are:
- [meta](how-to-write-an-exercise-with-autogen.md#metadata)
- [sampler](how-to-define-samplers.md#samplers-attached-to-one-function)
- [var](advanced-features.md#testing-a-variable)
