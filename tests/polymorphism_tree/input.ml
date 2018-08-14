open Test_lib
open Report

type%prelude 'a tree =
  | Node of 'a tree * 'a tree
  | Leaf of 'a

let sample_tree sample = fun () -> Leaf (sample ())

let%sampler[@find : int -> int tree -> bool] sample_find =
  fun () -> (sample_int (), sample_tree sample_int ())
let%sampler[@find : char -> char tree -> bool] sample_find =
  fun () -> (sample_char (), sample_tree sample_char ())

let rec find x t =
  match t with
  | Node (l, r) -> find x l || find x r
  | Leaf y -> x = y

let%sampler[@fst : int tree -> int] sample_fst = sample_tree sample_int
let%sampler[@fst: char tree -> char] sample_fst = sample_tree sample_char

let rec fst t =
  match t with
  | Node (l, _) -> fst l
  | Leaf x -> x
