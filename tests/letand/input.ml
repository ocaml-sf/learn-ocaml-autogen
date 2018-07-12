open Test_lib
open Report

type%prelude t = int -> int

let%prelude rec a f = b (f 3)
and b x = if false then a (fun x -> x) else x

let rec f (x : int) : int = g (x * 2)
and g (x : int) : int =
  if x > 100 then x else f x
