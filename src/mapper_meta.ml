open Ast_mapper
open Asttypes
open Parsetree
open Ezjsonm

let print_json_in meta name =
  let out_channel = open_out name in
  to_channel out_channel meta;
  close_out out_channel

let base_meta = [
  ("learnocaml_version", string "2");
  ("kind", string "exercise");
  ("stars", unit ());
  ("title", unit ());
  ("short_description", unit ());
  ("identifier", unit ());
  ("authors", unit ())]

let add_authors authors authors' =
  match authors, authors' with
  | `A [`String name; `String mail], `Null -> `A [authors]
  | `A [`String name; `String mail], `A authors' -> `A (authors' @ [authors])
  | `A _, `Null -> authors
  | `A authors, `A authors' -> `A (authors' @ authors)
  | _, _ -> authors'

let replace_value (k, v) =
  List.map (fun (k', v') ->
    match k, k' with
    | ("authors" | "author"), "authors" -> (k', add_authors v v')
    | _, _ when k = k' -> (k, v)
    | _, _ -> (k', v'))

let rec value_of_ptree_list pexp =
  let rec value_list acc = function
    | {pexp_desc = Pexp_construct ({txt = Longident.Lident "::"},
      Some {pexp_desc = Pexp_tuple [exp; l]})} ->
        value_list (value_of_pexp exp :: acc) l
    | {pexp_desc = Pexp_construct ({txt = Longident.Lident "[]"}, None)} ->
        List.rev acc
    | _ -> failwith "Error while parsing."
  in
  `A (value_list [] pexp)

and value_of_pexp = function
  | {pexp_loc = loc; pexp_desc = Pexp_constant c} ->
      begin match c with
        | Pconst_string (s, _) -> string s
        | Pconst_integer (i, _) -> float (float_of_string i)
        | Pconst_float _ | Pconst_char _ ->
            raise Location.(Error (
              error ~loc "Wrong type inside meta definition."))
      end
  | {pexp_desc = Pexp_construct _} as pexp ->
      value_of_ptree_list pexp
  | {pexp_desc = Pexp_tuple pexps} ->
      list value_of_pexp pexps
  | {pexp_loc = loc} ->
      raise Location.(Error (error ~loc "Wrong type inside meta definition."))

let field_of_let = function
  | {pstr_desc = Pstr_value (_, [{
    pvb_pat = {ppat_desc = Ppat_var {txt}}; pvb_expr = e}])} ->
      (txt, value_of_pexp e)
  | {pstr_loc = loc} ->
      raise Location.(Error (
        error ~loc "Syntax error in metadata definition."))

(* BUG meta.json is generated with null fields *)
let check_all_fields_defined meta =
  let undefined = List.filter (fun (_, v) -> v = unit ()) meta in
  if undefined <> [] then begin
    Printf.eprintf "meta.json can’t be generated. Following fields are \
    missing:\n";
    List.iter (fun (k, _) -> Printf.eprintf "%s\n" k) undefined
  end

let json_of_parsetree ptree_struct =
  let change_field meta pstr =
    let field = field_of_let pstr in
    replace_value field meta
  in
  let meta = List.fold_left change_field base_meta ptree_struct in
  check_all_fields_defined meta;
  `O meta

let print_meta_json meta =
  let out_channel = open_out "meta.json" in
  to_channel out_channel meta;
  close_out out_channel

let meta_structure_mapper mapper s =
  let defs = Mapper.keep_unwrapped_extensions ["meta"] s in
  let meta = json_of_parsetree defs in
  print_meta_json meta;
  defs

let meta_mapper argv_ =
  { default_mapper with structure = meta_structure_mapper }

let () = register "meta_json" meta_mapper
