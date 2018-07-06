open Test_lib
open Report

let%prelude prel_const = 3

let%prepare prep = if true then 3 else 5

let%prelude prel =
  let x = [1;3;5] in
  List.map (fun _ -> 1) x

let plus (x : int) (y : int) : int = x + y

let minus (x : int) (y : int) : int = x - y

let concat (x : string) (y : int) : string = x ^ (string_of_int y)

let rec recursive (x : float) : float = x

module Int = struct
  let x = 3
end
