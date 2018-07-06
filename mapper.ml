open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree

let keep_in_struct extension_name mapper s =
  let rec aux s acc =
    match s with
    | { pstr_desc = Pstr_extension (
      ({ txt }, PStr items), _) } :: s' when txt = extension_name ->
        aux s' (items @ acc)
    | { pstr_desc = Pstr_extension _ } :: s' | _ :: s' -> aux s' acc
    | [] -> acc
  in List.rev (aux s [])

(* Generates a mapper who ignores all expressions but the ones with the
 * extension txt *)
let mk_mapper txt _argv =
  { default_mapper with
    structure = keep_in_struct txt
  }
