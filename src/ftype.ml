open Ast_helper
open Asttypes
open Parsetree

type t = Parsetree.core_type option

let option_map2 f o1 o2 =
  match o1, o2 with
  | Some x, Some y -> Some (f x y)
  | _, _ -> None

let arrow = option_map2 (Typ.arrow Nolabel)

let get_arg_type = function
  | {ppat_desc = Ppat_constraint (_, ty)} -> Some ty
  | _ -> None

let get_expr_type = function
  | {pexp_desc = Pexp_constraint (_, ty)} -> Some ty
  | _ -> None

let rec get_function_type = function
  | {pexp_desc = Pexp_fun (_, _, ppat, pexp)} ->
      let ty = get_arg_type ppat in
      arrow ty (get_function_type pexp)
  | e -> get_expr_type e

let mk_ty_extension ty = Exp.extension ({txt = "ty"; loc = !default_loc}, PTyp ty)

(* mk_ty_extension (Some t) = [%ty t] *)
let mk_fty_extension fun_name = function
  | Some ty -> mk_ty_extension ty
  | None ->
    raise Location.(Error (error (
      Printf.sprintf "ERROR Function %s and its samplers are not \
      annotated enough." fun_name)))
