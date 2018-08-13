open Ast_helper
open Asttypes
open Parsetree
open Ftype

type sampler = Sampler of Parsetree.expression * Ftype.t

let samplers = Hashtbl.create 20

let samplers_for = Hashtbl.find_all samplers

let add_sampler_for = Hashtbl.add samplers

let is_sampler_function = function
  | {pvb_pat = {ppat_desc = Ppat_var {txt = fun_name}}} ->
      begin
        try String.sub fun_name 0 7 = "sample_"
        with Invalid_argument _ -> false
      end
  | x -> false

let remove_samplers_from_struct = function
  | {pstr_desc = Pstr_value (rec_flag, vbs)} ->
      let no_sampler = List.filter (fun x -> not (is_sampler_function x)) vbs in
      Str.value rec_flag no_sampler
  | x -> x

let get_sampled_functions =
  let get_sampled_function = function
    | ({txt}, PTyp ty) -> (txt, Some ty)
    | ({txt}, _) -> (txt, None)
  in List.map get_sampled_function

(* Remember samplers of the kind let%sampler[@f (: ty)?] = e for use in
* f’s test function. *)
let save_sampler = function
  | {pvb_expr = body; pvb_attributes = attrs} ->
      let fs_tys = get_sampled_functions attrs in
      List.iter (fun (f, ty) -> add_sampler_for f (Sampler (body, ty))) fs_tys

let save_samplers = function
  | {pstr_desc = Pstr_value (_, samplers)} -> List.iter save_sampler samplers
  | {pstr_loc = loc} ->
      raise Location.(Error (
        error ~loc "%sampler can only be used on a value definition."))

let sufficient_annotations f_ty (Sampler (_, s_ty)) =
  match f_ty, s_ty with
  | None, None -> false
  | _ -> true

let test_type f_ty (Sampler (_, s_ty)) =
  match f_ty, s_ty with
  | _, Some ty -> Some ty
  | _, None -> f_ty
