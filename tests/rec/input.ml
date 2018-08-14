open Test_lib
open Report

let rec f (x : bool) : int = 3

let%prelude rec g y = true

let%prepare rec h z = 5
