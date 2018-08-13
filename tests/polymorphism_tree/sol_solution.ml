let rec find x t =
  match t with
  | Node (l, r) -> find x l || find x r
  | Leaf y -> x = y

let rec fst t =
  match t with
  | Node (l, _) -> fst l
  | Leaf x -> x
