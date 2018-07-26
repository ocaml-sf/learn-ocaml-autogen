open Test_lib
open Report

(*
type meta = {
  learnocaml_version : string;
  kind : string;
  stars : int;
  title : string;
  short_description : string;
  identifier : string;
  authors : string list
}
*)

(*
let meta = {
  stars = 3;
  title = "A trivial exercise";
  short_description = "Identity function";
  authors = ["Me", "me@myself.fr"]
}
*)

let%meta stars = 3
let%meta title = "Blimey! this is a really trivial exercise"
let%meta short_description = "Identity function"
let%meta authors = ["Me", "me@myself.fr"]

let id (x : int) : int = x
