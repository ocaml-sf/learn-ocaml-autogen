open Test_lib
open Report

let%meta identifier = "meta"
let%meta stars = 3
let%meta title = "Blimey! this is a really trivial exercise"
let%meta short_description = "Identity function"
let%meta author = ("I", "thisisme@mail.adress")
let%meta authors = [("Me", "me@myself.fr"); ("Mine", "iwrote@this.exercise")]
let%meta author = ("Me again", "i@really.did")

let id (x : int) : int = x
