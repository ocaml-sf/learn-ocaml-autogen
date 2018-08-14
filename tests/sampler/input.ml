open Test_lib
open Report

(* Attached to join function. *)
let%sampler[@join] sample_join = fun () -> ('a', 2.)

(* let sample_1 : unit -> int * int = fun () -> (Random.int 10, Random.int 10)
 * or rather *)
(* Same definition as in the tests. *)
type int_int = int * int
let sample_int_int () = (1, 2)

let sample_float () = 3.14159261

let make_tuple (x : int) : int * int = (x, x)

let join (c : char) (x : float) : char * float = (c, x)
