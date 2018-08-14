open Test_lib
open Report

(** Monomorphic function, no samplers *)

let f (x : int) (y : float) : float = float_of_int x +. y

(** Monomorpic function with samplers *)

(* Non-annotated sampler *)

let%sampler[@g] sample_g = fun () -> (sample_int (), sample_float ())
let g (x : int) (y : float) : float = float_of_int x +. y

(* Annotated sampler *)

let%sampler[@h : int -> float -> float] sample_h =
  fun () -> (sample_int (), sample_float ())
let h x y = float_of_int x +. y

(** Polymorphic function with monomorphic return type *)

(* Annotated sampler *)

let%sampler[@i : int -> int -> float] sample_i =
  fun () -> (sample_int (), sample_int ())
let%sampler[@i : char -> bool -> float] sample_i =
  fun () -> (sample_char (), sample_bool ())
let i x y = 3.1415

(** Polymorphic functions with polymorphic return types *)

(* Annotated samplers *)

let%sampler[@j : int -> char -> int * char] sample_j =
  fun () -> (sample_int (), sample_char ())
let%sampler[@j : float -> bool -> float * bool] sample_j =
  fun () -> (sample_float (), sample_bool ())
let j x y = (x, y)
