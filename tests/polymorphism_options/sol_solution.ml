let id x = x

let fst x y = x

let fst_of_three (x, y, z) = x

let map f x =
  match x with
  | Some x -> Some (f x)
  | None -> None

let return x = Some x

let map2 f x y =
  match x, y with
  | Some x, Some y -> Some (f x y)
  | _ -> None
