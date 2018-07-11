type t = int -> int

let rec a f = b (f 3)
and b x = if false then a (fun x  -> x) else x
