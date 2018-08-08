open Ast_helper
open Asttypes
open Parsetree

let samplers = Hashtbl.create 20

let samplers_for = Hashtbl.find_all samplers

let add_sampler_for = Hashtbl.add samplers

let get_lident = function
  | {pexp_desc = Pexp_ident {txt = Longident.Lident x}} -> x
  | {pexp_loc = loc} ->
      raise Location.(Error (
        error ~loc "Error while parsing: identifier expected."))

(* Remember samplers of the kind let[%sampler f] = e for use in f’s test
 * function. *)
let save_sampler = function
  | {pvb_pat = {ppat_desc = Ppat_extension ({txt = "sampler"}, PStr [pstr])};
    pvb_expr = e} ->
      begin match pstr with
      (* One function in extension *)
      | {pstr_desc = Pstr_eval ({pexp_desc = Pexp_ident _} as pexp, _)} ->
          add_sampler_for (get_lident pexp) e
      (* Several functions in extension *)
      | {pstr_desc = Pstr_eval ({pexp_desc = Pexp_apply (pexp, pexps)}, _)} ->
          let functions = (pexp :: List.map snd pexps) in
          List.iter (fun s -> add_sampler_for (get_lident pexp) e) functions
      | {pstr_loc = loc} ->
          raise Location.(Error (
            error ~loc "Sampler extensions expect one or more function names."))
      end
  | {pvb_loc = loc} ->
      raise Location.(Error (error ~loc "Not a sampler extension."))

let is_sampler_extension = function
  | {pvb_pat = {ppat_desc = Ppat_extension ({txt = "sampler"}, _)}} -> true
  | _ -> false

let is_sampler_function = function
  | {pvb_pat = {ppat_desc = Ppat_var {txt = fun_name}}} ->
      begin
        try String.sub fun_name 0 7 = "sample_"
        with Invalid_argument _ -> false
      end
  | x -> false

let is_sampler x =
  is_sampler_extension x || is_sampler_function x

let remove_samplers_from_struct = function
  | {pstr_desc = Pstr_value (rec_flag, vbs)} ->
      let no_sampler = List.filter (fun x -> not (is_sampler x)) vbs in
      Str.value rec_flag no_sampler
  | x -> x
