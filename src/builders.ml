open Ast_helper
open Asttypes
open Parsetree

let lid s = {txt = Longident.Lident s; loc = !default_loc}
let lid_exp s = Exp.ident (lid s)
let str_loc s = {txt = s; loc = !default_loc}

let str_exp s = Exp.constant (Pconst_string (s, None))

(* Construct a list as an AST *)
let ast_of_list l =
  let mk_list_element acc x =
    Exp.construct (lid "::") (Some (Exp.tuple [x; acc])) in
  List.fold_left
    mk_list_element (Exp.construct (lid "[]") None) (List.rev l)
