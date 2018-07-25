open Test_lib
open Report

let[%sampler incr_tuple decr_tuple id_tuple] = fun () -> (4, 2)

type int_int = int * int
let sample_int_int () = (Random.int 20, Random.int 20)

let rec incr_tuple ((x, y) : int_int) : int_int = (x + 1, y + 1)
and incrincr_tuple ((x, y) : int_int) : int_int = (x + 2, y + 2)

let decr_tuple ((x, y) : int_int) : int_int = (x - 1, y - 1)

let id_tuple (x : int_int) : int_int = x
