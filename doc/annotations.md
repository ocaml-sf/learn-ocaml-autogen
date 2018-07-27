# Annotations used in Learn-OCaml autogen

This document is intended as a reference on the annotations supported by
Learn-OCaml autogen. If you haven’t, it is advised reading [how to write an
exercise with autogen](how-to-write-an-exercise-with-autogen.md) first.

Several annotations are used in Learn-OCaml autogen to discriminate some
expressions from the rest of the program. You might have recognized so called
*ppx extensions*. There are currently four different supported annotations.

<dl>
  <dt><code>%prelude</code></dt>
  <dd>An expression annotated with <code>%prelude</code> will be transposed
  as-is, but without the annotation, into the <code>prelude.ml</code> file.
  This applies to every expression annotated as such, and only them.<dd>

  <dt><code>%prepare</code></dt>
  <dd>Same as previously, but the expression will be written inside
  <code>prepare.ml</code>.</dd>

  <dt><code>%meta</code></dt>
  <dd>This annotation is used to distinguish definitions of metadata fields
  that are to be translated into <code>meta.json</code>.</dd>

  <dt><code>%[sampler id]<code></dt>
  <dd>This annotation is used to define a sampler for the function identified
  as <code>id</code>, regardless of the surrounding sampler for its type.</dd>
</dl>

Annotated expressions serve different purposes, and so are more or less
limited. A detailled description of the syntax of extensions is given
[here](https://caml.inria.fr/pub/docs/manual-ocaml/extn.html#sec262).

We restrict ourselves to global definitions. We basically want to split
definitions between files, which is why annotating sub-expressions wouldn’t
make sense. For instance, this doesn’t work:
```ocaml
module Int = struct
  type t = int
  let%prelude x = 3
  let plus = ( + )
end
```
While this does, with the definition of x being parsed into `prelude.ml`.
```ocaml
let%prelude x = 3
module Int = struct
  type t = int
  let plus = ( + )
end
```

A definition with an annotation will be written with `%annot` appended to the
keyword, without a space between them, as you can see in the previous example.

`%prelude` and `%prepare` annotations can be used on any global definition.
Valid keywords are:
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

`%meta` annotation is only valid on a `let` expression.
```
keywords := let
```

The syntax of `%sampler` is a bit different, as it takes arguments. It is the
definition of a function, and used as such with keyword `let`:
`let[%sampler id+] = …`
*id* is the name of a function of the exercises. This is the one to which the
sampler will be assigned. The `+` sign indicates that there can be several
function identifiers.
