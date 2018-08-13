open Test_lib
open Report

let%sampler[@return_three : int -> int] srt = sample_int
let%sampler[@return_three : char -> int] srt = sample_char

let return_three x : int = 3

let%sampler[@fst : int * int -> int] sample_fst =
  fun () -> (sample_int (), sample_int ())
let%sampler[@fst : int * char -> int] sample_fst =
  fun () -> (sample_int (), sample_char ())

let fst (x, y : int * int) : int = x

let%sampler[@id : int -> int] sample_id =
  fun () -> (Random.int 100)

let id x = x
