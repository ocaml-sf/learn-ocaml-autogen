open Test_lib
open Report

let%prepare r = ref 0
let%prepare ( * ) x y = incr r; x * y

let%var x : int = 3 + 3 + 9

let%ref r : int = 2 (* expected value *)

let%test () = r := !r - 2
