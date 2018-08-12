open Test_lib
open Report

let%sampler[@fst] sample_fst = fun () -> (sample_int (), sample_int ())
let%sampler[@fst] sample_fst = fun () -> (0, Random.int 10)

let fst (x, y : int * int) : int = x

let%sampler[@print] sample_print = fun () -> (sample_char (), sample_int ())
let%sampler[@print] sample_print = fun () -> ('a', 15)
let%sampler[@print] sample_print = fun () -> (sample_char (), Random.int 26)

let print (c, x : char * int) : string = String.make x c
