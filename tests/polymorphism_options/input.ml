open Test_lib
open Report

let%sampler[@id : int -> int] sample_id = sample_int
let%sampler[@id : char -> char] sample_id = sample_char
let%sampler[@id : int * int option -> int * int option] sample_id =
  let no_0 x = if x = 0 then None else Some x in
  fun () -> (sample_int (), no_0 (sample_int ()))

let id x = x

let%sampler[@fst : int -> float -> int] sample_fst =
  fun () -> (Random.int 10, Random.float 10.)
let%sampler[@fst : float -> int -> float] sample_fst =
  fun () -> (Random.float 10., Random.int 10)

let fst x y = x

let%sampler[@fst_of_three : int * char * float -> int] sample_fot =
  fun () -> (sample_int (), sample_char (), sample_float ())
let%sampler[@fst_of_three : int * char * int -> int] sample_fot =
  fun () -> (sample_int (), sample_char (), sample_int ())

let fst_of_three (x, y, z) = x

let%sampler[@map : (int -> float) -> int option -> float option] sample_map =
  fun () -> (float_of_int, (sample_option sample_int) ())
let%sampler[@map : (int -> int) -> int option -> int option] sample_map =
  fun () -> ((fun x -> x), None)

let map f x =
  match x with
  | Some x -> Some (f x)
  | None -> None

let%sampler[@return : int -> int option] sample_return = sample_int
let%sampler[@return : char -> char option] sample_return = sample_char

let return x = Some x

let%sampler[@map2 : (int -> char -> string) ->
  int option -> char option -> string option] sample_map2 = fun () ->
  (String.make, Some (Random.int 10), (sample_option sample_char) ())
let%sampler[@map2 : (char list list -> char list -> bool) ->
  char list list option -> char list option -> bool option] sample_map2 =
    fun () ->
      ((fun l l' -> List.concat l = l'),
      sample_option (sample_list (sample_list sample_char)) (),
      sample_option (sample_list sample_char) ())

let map2 f x y =
  match x, y with
  | Some x, Some y -> Some (f x y)
  | _ -> None
