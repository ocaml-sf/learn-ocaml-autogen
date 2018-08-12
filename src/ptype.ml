open Ast_helper
open Asttypes
open Parsetree

(* Represents the type of a function with the parameters and the result *)
type ftype = Parsetree.core_type list option * Parsetree.core_type option

let mk_arrow_type args res =
  let add_arrow acc ty = Typ.arrow Nolabel ty acc in
  List.fold_left add_arrow res (List.rev args)

(* mk_ty_extension t = [%ty t] *)
let mk_ty_extension ty =
  Exp.extension ({txt = "ty"; loc = !default_loc}, PTyp ty)
