open Test_lib
open Report

let%meta identifier = "meta"
let%meta stars = 3
let%meta title = "Blimey! this is a really trivial exercise"
let%meta short_description = "Identity function"
let%meta authors = [("Me", "me@myself.fr")]

let id (x : int) : int = x
