open Test_lib
open Report

type%prelude t = int -> int

let%prelude rec a f = b (f 3)
and b x = if false then a (fun x -> x) else x

let rec f (x : int) : int = x
and g (x : int) : int = x
