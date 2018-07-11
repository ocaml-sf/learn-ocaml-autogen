let%prepare prep = if true then 3 else 5

let%prelude prel =
  let x = [1;3;5] in
  List.map (fun _ -> 1) x
