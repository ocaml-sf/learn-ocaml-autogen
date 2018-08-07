open Ast_helper
open Asttypes
open Parsetree

let get_lident = function
  | {pexp_desc = Pexp_ident {txt = Longident.Lident x}} -> x
  | {pexp_loc = loc} ->
      raise Location.(Error (
        error ~loc "Error while parsing: identifier expected."))

let samplers = ref []

let samplers_for f =
  try
    let s = List.assoc f !samplers in
    [(Labelled "sampler", s)]
  with Not_found -> []

(* Remember samplers of the kind let[%sampler f] = e for use in f’s test
 * function. *)
let save_sampler = function
  | {pvb_pat = {ppat_desc = Ppat_extension ({txt = "sampler"}, PStr [pstr])};
    pvb_expr = e} ->
      let make_assoc pexp = (get_lident pexp, e) in
      begin match pstr with
      | {pstr_desc = Pstr_eval ({pexp_desc = Pexp_ident _} as pexp, _)} ->
          samplers := make_assoc pexp :: !samplers
      | {pstr_desc = Pstr_eval ({pexp_desc = Pexp_apply (pexp, pexps)}, _)} ->
          let pexps = List.map snd pexps in
          samplers := List.map make_assoc (pexp :: pexps) @ !samplers
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

let remove_samplers = function
  | {pstr_desc = Pstr_value (rec_flag, vbs)} ->
      let no_sampler = List.filter (fun x -> not (is_sampler x)) vbs in
      Str.value rec_flag no_sampler
  | x -> x
