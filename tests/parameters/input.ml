open Test_lib
open Report

let f (x : int) : int = x

let g (x : int) (y : float) : int * float = (x, y)

let h (x : int) (y : float) (z : char) : int * float * char = (x, y, z)

let i (x : int) (y : bool) (z : char) (w : float) : int * bool * char * float =
  (x, y, z, w)
