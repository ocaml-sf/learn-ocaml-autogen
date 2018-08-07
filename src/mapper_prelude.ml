open Ast_mapper

let () = register "prelude" (Mapper.prepare_prelude_mapper "prelude")
