# Installation procedure

## Requirements

Please make sure that you have the following tools installed.
- opam (>= 2.00)
- make (>= 4)

Warning: opam 2.0 has not been officially released yet.

## Installation

We are going to install learn-ocaml-autogen via opam, using a local copy of the
program.

Create a package pinned to this directory.
```
$ opam pin add learn-ocaml-autogen .
```
Installation should follow. Before learn-ocaml-autogen, missing dependencies
will also be installed. That’s it!

## Using opam

If you want to remove learn-ocaml-autogen, you can do it with opam.
```
$ opam remove learn-ocaml-autogen
```
You can also reinstall it.
```
$ opam install learn-ocaml-autogen
```

If you wish to remove the pin associated to the repository, you can use:
```
$ opam pin remove learn-ocaml-autogen
```
