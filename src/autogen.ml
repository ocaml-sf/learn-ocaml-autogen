let mk_input dir input =
  Filename.concat dir input

let mk_mapper file =
  let mapper_name = "mapper_" ^ file ^ ".native" in
  let path_to_bin = Filename.dirname Sys.argv.(0) in
  Filename.concat path_to_bin mapper_name

let mk_output dir file =
  Filename.concat dir (file ^ ".ml")

let mk_meta_json dir =
  Filename.concat dir "meta.json"

let exec ?(fatal=false) cmd error_msg =
  let exit_value = Sys.command cmd in
  if exit_value <> 0 then
    begin
      Printf.eprintf "%s" error_msg;
      if fatal then Printf.printf "Stopping the program.";
      exit exit_value
    end

let sed script output =
  let e =
    try if script.[0] = '$' then "" else "-E"
    with Invalid_argument _ -> "-E" in
  let cmd = Printf.sprintf "sed -i.bak %s %s %s" e script output in
  exec cmd (Printf.sprintf "Error while modifying %s." output)

let remove_trailing_whitespaces = sed "'s/[ \t]+$//'"

let insert_line_between_each_functions template_fill =
  sed (Printf.sprintf "'/%s/G'" template_fill)

let change_template_fill template_fill =
  let default_fill = "Replace this string by your implementation." in
  sed (Printf.sprintf "'s/%s/%s/'" default_fill template_fill)

let handle_ml_file output template_fill file =
  remove_trailing_whitespaces output;
  if file = "template" then
    begin
      change_template_fill template_fill output;
      insert_line_between_each_functions template_fill output
    end;
  Sys.remove (output ^ ".bak")

let indent_meta_json meta_json =
  let spread_left_bracket = "$'s/{/{\\\n/'" in
  let spread_right_bracket = "$'s/}/\\\n}/'" in
  let break_lines = "$'s/,/,\\\n/g'" in
  List.iter (fun script -> sed script meta_json) [
    spread_left_bracket; break_lines; spread_right_bracket];
  let stick_back_lists =
    Printf.sprintf
    "awk '/\\[/{printf \"%%s\",$0;next} 1' %s | tee %s"(* > /dev/null *)
    meta_json meta_json in
  exec stick_back_lists (Printf.sprintf "Error while modifying %s." meta_json);
  let indent = "'/^[^{}]/{s/^/  /;}'" in sed indent meta_json;
  Sys.remove (meta_json ^ ".bak")

let handle_generated_file exercise output template_fill file =
  if file = "meta" then (
    (* HACK It seems that we can’t use command-line arguments and parsing of
     * the command-line doesn’t work, so we move meta.json manually. *)
    let ex_meta_json = mk_meta_json exercise in
    Sys.rename "meta.json" ex_meta_json;
    indent_meta_json ex_meta_json;
    Sys.remove output;
    Printf.printf "File %s generated.\n" ex_meta_json
  ) else (
    handle_ml_file output template_fill file;
    Printf.printf "File %s generated.\n" output)

let generate_file exercise input template_fill file =
  let mapper = mk_mapper file in
  let input = mk_input exercise input in
  let output = mk_output exercise file in
  let ocf =
    Printf.sprintf "ocamlfind ppx_tools/rewriter %s %s -o %s" mapper input
    output in
  if (Sys.command ocf = 0) then
    handle_generated_file exercise output template_fill file
  else
    Printf.eprintf "File %s could not be generated." output

let main exercises input files not_files template_fill =
  let files = List.filter (fun x -> not (List.mem x not_files)) files in
  let gen_exercise x = List.iter (generate_file x input template_fill) files in
  List.iter gen_exercise exercises

module Args = struct
  open Cmdliner
  open Arg

  let exercises =
    non_empty & pos_all dir [] & info [] ~docv:"EXERCISES"

  let input =
    value & opt string "input.ml" & info ["i"; "input"] ~docv:"FILE" ~doc:
      "Specify the name of the input file to use, relative to the exercise \
      directory."

  let files =
    value & opt_all string ["prelude"; "prepare"; "solution"; "template";
    "test"; "meta"] & info ["o"; "output"] ~doc:
      "Must be one of `prelude', `prepare', `solution', `template', `test' or
      `meta'. Generate only the corresponding file. Can be repeated to give a
      subset of the usual files."

  let not_files =
    value & opt_all string [] & info ["n"; "no_output"] ~doc:
      "Must be one of `prelude', `prepare', `solution', `template', `test' or
      `meta'. Don't generate the corresponding file. Can be repeated."

  let template_fill =
    value & opt string "Replace this string by your implementation." & info
    ["t"; "template_fill"] ~docv:"STRING" ~doc:
      "String to be used in the template in place of the answer."

  let man = [
    `S Manpage.s_description;
    `P "$(tname) generates all files needed by Learn-OCaml for the listed
    exercises. See https://github.com/ocaml-sf/learn-ocaml-autogen/doc for
    more informations on how to write exercises with Learn-OCaml autogen.";
    `S Manpage.s_bugs;
    `P "If you find any bugs, please report them to
    https://gitub.com/ocaml-sf/learn-ocaml-autogen/issues." ]

  let cmd =
    let doc =
      "Generate a Learn-OCaml exercise from an input file" in
    Term.(const main $ exercises $ input $ files $ not_files $ template_fill),
    Term.info ~doc ~man "learn-ocaml-autogen"
end

let () =
  match Cmdliner.Term.eval ~catch:false Args.cmd
  with
  | exception Failure msg ->
      Printf.eprintf "[ERROR] %s\n" msg;
      exit 1
  | `Error _ -> exit 2
  | _ -> exit 0
