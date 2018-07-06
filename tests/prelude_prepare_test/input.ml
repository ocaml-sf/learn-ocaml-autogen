open Test_lib
open Report

let%prepare prep = if true then 3 else 5

let%prelude prel =
  let x = [1;3;5] in
  List.map (fun _ -> 1) x

let plus (x : int) (y : int) : int = x + y

let minus (x : int) (y : int) : int = x - y

let times (x : int) (y : int) : int = x * y

let divide (x : int) (y : int) : int = x / y
