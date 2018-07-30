open Ast_mapper
open Asttypes
open Parsetree
open Ezjsonm

exception MissingField

let base_meta = [
  ("learnocaml_version", string "2");
  ("kind", string "exercise");
  ("stars", unit ());
  ("title", unit ());
  ("short_description", unit ());
  ("identifier", unit ());
  ("authors", unit ())]

let replace_assoc (k, v) =
  List.map (fun (k', v') -> if k = k' then (k, v) else (k', v'))

let rec value_of_ptree_list pexp =
  let rec aux (`A acc) = function
    | {pexp_desc = Pexp_construct ({txt = Longident.Lident "::"},
      Some {pexp_desc = Pexp_tuple [exp; l]})} ->
        aux (`A (value_of_pexp exp :: acc)) l
    | {pexp_desc = Pexp_construct ({txt = Longident.Lident "[]"}, None)} ->
        `A (List.rev acc)
    | _ -> failwith "Error while parsing."
  in
  aux (`A []) pexp

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

let check_all_fields_defined meta =
  let undefined = List.filter (fun (_, v) -> v = unit ()) meta in
  if undefined <> [] then begin
    Printf.eprintf "meta.json can’t be generated. Following fields are \
    missing:\n";
    List.iter (fun (k, _) -> Printf.eprintf "%s" k) meta;
    raise MissingField
  end

let json_of_parsetree ptree_struct =
  let change_field meta pstr =
    let field = field_of_let pstr in
    replace_assoc field meta
  in
  let meta = List.fold_left change_field base_meta ptree_struct in
  check_all_fields_defined meta;
  `O meta

let print_meta_json meta =
  let out_channel = open_out "meta.json" in
  to_channel out_channel meta;
  close_out out_channel

let meta_structure_mapper mapper s =
  let defs = Mapper.keep_unwrapped_extensions "meta" s in
  let meta = json_of_parsetree defs in
  print_meta_json meta;
  defs

let meta_mapper argv_ =
  { default_mapper with structure = meta_structure_mapper }

let () = register "meta_json" meta_mapper
