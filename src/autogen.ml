let mk_input dir =
  Filename.concat dir "input.ml"

let mk_mapper file =
  let mapper_name = "mapper_" ^ file ^ ".native" in
  let path_to_bin = Filename.dirname Sys.argv.(0) in
  Filename.concat path_to_bin mapper_name

let mk_output dir file =
  Filename.concat dir (file ^ ".ml")

let make_file_nicer file =
  let _ = Sys.command ("sed -Ei 's/[ \\t]+$//' " ^ file) in
  let basename = Filename.basename file in
(*
  let with_mutually_rec_functions =
    Sys.command ("grep '^and\\s' " ^ file ^ " | wc -l && exit $?") > 0 in
*)
  let add_spacing = (
    if basename = "template.ml" || basename = "solution.ml"
    (*&& not with_mutually_rec_functions *)
    then
(*       "s/(= \".*\")/\\1 ;;/; /;;/G" *)
       "/$/G"
    else
      "")
 in
(*   Printf.printf "sed -Ei '%s' %s" add_spacing file *)
  ignore (Sys.command (Printf.sprintf "sed -Ei '%s' %s" add_spacing file))

let generate_file exercise file =
  let input = mk_input exercise in
  let mapper = mk_mapper file in
  let output = mk_output exercise file in
  let ocf =
    Printf.sprintf "ocamlfind ppx_tools/rewriter %s %s > %s" mapper input
    output in
  let exit_value = Sys.command ocf in
  if (exit_value = 0) then (
    Printf.printf "File %s generated.\n" output;
    make_file_nicer output)
  else
    Printf.printf "File %s could not be generated. Exited with value %d.\n"
    output exit_value

let parse l =
  let rec aux acc = function
    | "--" :: l -> (List.rev acc, l)
    | [] -> (acc, [])
    | x :: l -> aux (x :: acc) l
  in aux [] l

let () =
  let (exercises, files) = parse (List.tl (Array.to_list Sys.argv)) in
  let files = (
    if files = [] then
      ["prelude"; "prepare"; "solution"; "template"; "test"]
    else files) in
  List.iter (fun x -> List.iter (generate_file x) files) exercises
(*
  let files = ref [] in
  let speclist = [
    ("--", Arg.Rest (fun x -> files := x :: !files),
    "Limit generated files kinds to the ones cited after.") ] in
  if !files = [] then
    files := ["prelude"; "prepare"; "solution"; "template"; "test"];
  let usage_msg = "Options avaible:" in
  if Sys.argv.(1) = "--" then
    failwith "For each file."
  else
    Arg.parse speclist (fun x -> List.iter (generate_file x) !files) usage_msg
*)
