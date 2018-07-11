open Test_lib
open Report

let f (x : int) : int = x

let g (x : int) (y : int -> int) : int * (int -> int) = (x, y)

let h (x : int) (y : int -> int) (z : int -> int -> int)
: int * (int -> int) * (int -> int -> int) = (x, y, z)

let i (x : int) (y : bool) (z : char) (w : float) : int * bool * char * float =
  (x, y, z, w)
