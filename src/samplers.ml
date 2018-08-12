open Ast_helper
open Asttypes
open Parsetree
open Ptype

type sampler = Sampler of Parsetree.expression * ftype

let sampler e arg_ty ret_ty = Sampler (e, (arg_ty, ret_ty))

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

let remove_initial_unit = function
  | Ptyp_arrow (Nolabel,
    {ptyp_desc = Ptyp_constr ({txt = Longident.Lident "unit"}, [])},
    {ptyp_desc}) ->
      ptyp_desc
  | _ -> raise Location.(Error (error "Type does not begin with unit."))

(* Remember samplers of the kind let%sampler[@f] (: unit -> ty)? = e for use in
* f’s test function. *)
let save_sampler vb =
  let save body arg_ty attrs =
    let fs_and_ret_tys = get_sampled_functions attrs in
    let add_this_sampler (f, ret_ty) =
      add_sampler_for f (sampler body arg_ty ret_ty) in
    List.iter add_this_sampler fs_and_ret_tys
  in
  match vb with
  | {pvb_expr = {pexp_desc = Pexp_constraint (body, {ptyp_desc})};
    pvb_attributes = attrs} ->
      let ty = Typ.mk (remove_initial_unit ptyp_desc) in
      let arg_ty = Some [ty] in
      save body arg_ty attrs
  | {pvb_expr = body; pvb_attributes = attrs} ->
      save body None attrs

let save_samplers = function
  | {pstr_desc = Pstr_value (_, samplers)} -> List.iter save_sampler samplers
  | {pstr_loc = loc} ->
      raise Location.(Error (
        error ~loc "%sampler can only be used on a value definition."))

let sufficient_annotations f_ty (Sampler (_, s_ty)) =
  match f_ty, s_ty with
  | (_, _), (Some _, Some _) -> true
  | (Some _, _), (_, Some _) -> true
  | (_, Some _), (Some _, _) -> true
  | (Some _, Some _), (_, _) -> true
  | _ -> false

let test_type f_name f_ty (Sampler (_, s_ty)) =
  match f_ty, s_ty with
  | (_, _), (Some s_arg_ty, Some s_ret_ty) ->
      mk_arrow_type s_arg_ty s_ret_ty
  | (_, Some f_ret_ty), (Some s_arg_ty, None) ->
      mk_arrow_type s_arg_ty f_ret_ty
  | (Some f_arg_ty, _), (None, Some s_ret_ty) ->
      mk_arrow_type f_arg_ty s_ret_ty
  | (Some f_arg_ty, Some f_ret_ty), (None, None) ->
      mk_arrow_type f_arg_ty f_ret_ty
  | _ ->
      failwith (Printf.sprintf "WARNING Sampler for %s is not \
      annotated enough. Sampler skipped.\n" f_name)
