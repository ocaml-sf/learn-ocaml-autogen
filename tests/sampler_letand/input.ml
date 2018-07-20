open Test_lib
open Report

type int_int = int * int
type int_arr_int = int -> int
type float_int = float * int

let rec sample_int_int () = (1, 1)
and sample_int_arr_int () = fun x -> x

and make_tuple (x : int) : float_int = (float_of_int x, x)
and make_int_tuple (x : char) : int_int =
  let i = int_of_char x in (i, i)

and sample_float_int () = (1., 1)

let rec id_int (x : int) : int = x
and id_float (x : float) : float = x

and[%sampler id_int] = fun () -> Random.int 10 mod 2

type char_int = char * int
type int_char = int * char

let rec sample_char_int () =
  let i = Random.int 255 in
  (i, char_of_int i)
and sample_int_char () =
  let (i, c) = sample_char_int () in (c, i)
