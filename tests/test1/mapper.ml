open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree

let rec keep_in_struct extension_name mapper = function
  | { pstr_desc = Pstr_extension (
      (* Quand y a-t-il des choses dans les attributs ? *)
    ({ txt }, PStr items), _) } :: s' when txt = extension_name ->
      (* on teste sur profondeur *)
(*       keep_in_struct mapper (items :: s') *)
      (* on ne teste pas en profondeur *)
      items @ keep_in_struct extension_name mapper s'
  | { pstr_desc = Pstr_extension _ } :: s' ->
      keep_in_struct extension_name mapper s'
  | x :: s' -> x :: keep_in_struct extension_name mapper s'
  | [] -> []

let mk_mapper txt _argv =
  { default_mapper with
    structure = keep_in_struct txt
  }
