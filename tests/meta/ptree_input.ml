input.ml
==>
[{pstr_desc =
   Pstr_open {popen_lid = {txt = Lident "Test_lib"}; popen_override = Fresh}};
 {pstr_desc =
   Pstr_open {popen_lid = {txt = Lident "Report"}; popen_override = Fresh}};
 {pstr_desc =
   Pstr_value (Nonrecursive,
    [{pvb_pat = {ppat_desc = Ppat_var {txt = "meta"}};
      pvb_expr =
       {pexp_desc =
         Pexp_record
          ([({txt = Lident "stars"},
             {pexp_desc = Pexp_constant (Pconst_integer ("3", None))});
            ({txt = Lident "title"},
             {pexp_desc =
               Pexp_constant (Pconst_string ("A trivial exercise", None))});
            ({txt = Lident "short_description"},
             {pexp_desc =
               Pexp_constant (Pconst_string ("Identity function", None))});
            ({txt = Lident "authors"},
             {pexp_desc =
               Pexp_construct ({txt = Lident "::"},
                Some
                 {pexp_desc =
                   Pexp_tuple
                    [{pexp_desc =
                       Pexp_tuple
                        [{pexp_desc =
                           Pexp_constant (Pconst_string ("Me", None))};
                         {pexp_desc =
                           Pexp_constant
                            (Pconst_string ("me@myself.fr", None))}]};
                     {pexp_desc = Pexp_construct ({txt = Lident "[]"}, None)}]})})],
          None)}}])};
 {pstr_desc =
   Pstr_value (Nonrecursive,
    [{pvb_pat = {ppat_desc = Ppat_var {txt = "id"}};
      pvb_expr =
       {pexp_desc =
         Pexp_fun (Nolabel, None,
          {ppat_desc =
            Ppat_constraint ({ppat_desc = Ppat_var {txt = "x"}},
             {ptyp_desc = Ptyp_constr ({txt = Lident "int"}, [])})},
          {pexp_desc =
            Pexp_constraint ({pexp_desc = Pexp_ident {txt = Lident "x"}},
             {ptyp_desc = Ptyp_constr ({txt = Lident "int"}, [])})})}}])}]
=========
