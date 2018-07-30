let mk_input dir input =
  Filename.concat dir input

let mk_mapper file =
  let mapper_name = "mapper_" ^ file ^ ".native" in
  let path_to_bin = Filename.dirname Sys.argv.(0) in
  Filename.concat path_to_bin mapper_name

let mk_output dir file =
  Filename.concat dir (file ^ ".ml")

let exec ?(fatal=false) cmd error_msg =
  if Sys.command cmd <> 0 then
    begin
      Printf.eprintf "%s" error_msg;
      if fatal then Printf.printf "Stopping the program.";
      exit 1
    end

let remove_trailing_whitespaces output =
  let error_msg =
    Printf.sprintf "Could not remove trailing whitespaces in file %s." output in
  exec ("sed -Ei 's/[ \\t]+$//' " ^ output) error_msg

let insert_line_between_each_functions output template_fill =
  let default_fill = "Replace this string by your implementation." in
  let cmd =
    Printf.sprintf "sed -i 's/%s/%s/; /%s/G' %s"
    default_fill template_fill template_fill output in
  exec cmd "Could not change template. Using \"%s\" instead."

let change_template_fill output template_fill =
  remove_trailing_whitespaces output;
  let basename = Filename.basename output in
  if basename = "template.ml" then
    insert_line_between_each_functions output template_fill

let generate_file exercise input template_fill file =
  let input = mk_input exercise input in
  let mapper = mk_mapper file in
  let output = mk_output exercise file in
  let ocf =
    Printf.sprintf "ocamlfind ppx_tools/rewriter %s %s > %s" mapper input
    output in
  if (Sys.command ocf = 0) then (
    Printf.printf "File %s generated.\n" output;
    change_template_fill output template_fill)
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
    "test"] & info ["o"; "output"] ~doc:
      "Must be one of `prelude', `prepare', `solution', `template' or `test'.
      Generate only the corresponding file. Can be repeated to give a subset of
      the usual files."

  let not_files =
    value & opt_all string [] & info ["n"; "no_output"] ~doc:
      "Must be one of `prelude', `prepare', `solution', `template' or `test'.
      Don't generate the corresponding file. Can be repeated."

  let template_fill =
    value & opt string "Replace this string by your implementation." & info
    ["t"; "template_fill"] ~docv:"STRING" ~doc:
      "String to be used in the template in place of the answer."

  let man = [
    `S Manpage.s_description;
    `P "$(tname) generates all files needed by Learn-OCaml for the listed
    exercises. See https://github.com/ocaml-sf/learn-ocaml-autogen/doc for
    more informations on how to write exercises with Learn-OCaml autogen.";
(*
    `S "EXAMPLES";
    `P "$(b, learn-ocaml-autogen easy -i a.ml -n test.ml)";
    `P "You have an exercise called `easy', your input file is called
    `easy/a.ml' and you want to generate everything but `easy/test.ml'.";
    `P "$(b, learn-ocaml-autogen easy -o test -o prelude)";
    `P "You want to generate only `easy/test.ml' and `easy/prelude.ml'.";
*)
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
