input.ml
==>
[{pstr_desc =
   Pstr_open {popen_lid = {txt = Lident "Test_lib"}; popen_override = Fresh}};
 {pstr_desc =
   Pstr_open {popen_lid = {txt = Lident "Report"}; popen_override = Fresh}};
 {pstr_desc =
   Pstr_extension
    (({txt = "prepare"},
      PStr
       [{pstr_desc =
          Pstr_value (Nonrecursive,
           [{pvb_pat = {ppat_desc = Ppat_var {txt = "r"}};
             pvb_expr =
              {pexp_desc =
                Pexp_apply ({pexp_desc = Pexp_ident {txt = Lident "ref"}},
                 [(Nolabel,
                   {pexp_desc = Pexp_constant (Pconst_integer ("0", None))})])}}])}]),
    ...)};
 {pstr_desc =
   Pstr_extension
    (({txt = "prepare"},
      PStr
       [{pstr_desc =
          Pstr_value (Nonrecursive,
           [{pvb_pat = {ppat_desc = Ppat_var {txt = "*"}};
             pvb_expr =
              {pexp_desc =
                Pexp_fun (Nolabel, None, {ppat_desc = Ppat_var {txt = "x"}},
                 {pexp_desc =
                   Pexp_fun (Nolabel, None,
                    {ppat_desc = Ppat_var {txt = "y"}},
                    {pexp_desc =
                      Pexp_sequence
                       ({pexp_desc =
                          Pexp_apply
                           ({pexp_desc = Pexp_ident {txt = Lident "incr"}},
                           [(Nolabel,
                             {pexp_desc = Pexp_ident {txt = Lident "r"}})])},
                       {pexp_desc =
                         Pexp_apply
                          ({pexp_desc = Pexp_ident {txt = Lident "*"}},
                          [(Nolabel,
                            {pexp_desc = Pexp_ident {txt = Lident "x"}});
                           (Nolabel,
                            {pexp_desc = Pexp_ident {txt = Lident "y"}})])})})})}}])}]),
    ...)};
 {pstr_desc =
   Pstr_extension
    (({txt = "var"},
      PStr
       [{pstr_desc =
          Pstr_value (Nonrecursive,
           [{pvb_pat = {ppat_desc = Ppat_var {txt = "x"}};
             pvb_expr =
              {pexp_desc =
                Pexp_constraint
                 ({pexp_desc =
                    Pexp_apply ({pexp_desc = Pexp_ident {txt = Lident "+"}},
                     [(Nolabel,
                       {pexp_desc =
                         Pexp_apply
                          ({pexp_desc = Pexp_ident {txt = Lident "+"}},
                          [(Nolabel,
                            {pexp_desc =
                              Pexp_constant (Pconst_integer ("3", None))});
                           (Nolabel,
                            {pexp_desc =
                              Pexp_constant (Pconst_integer ("3", None))})])});
                      (Nolabel,
                       {pexp_desc =
                         Pexp_constant (Pconst_integer ("9", None))})])},
                 {ptyp_desc = Ptyp_constr ({txt = Lident "int"}, [])})}}])}]),
    ...)};
 {pstr_desc =
   Pstr_extension
    (({txt = "ref"},
      PStr
       [{pstr_desc =
          Pstr_value (Nonrecursive,
           [{pvb_pat = {ppat_desc = Ppat_var {txt = "r"}};
             pvb_expr =
              {pexp_desc =
                Pexp_constraint
                 ({pexp_desc = Pexp_constant (Pconst_integer ("2", None))},
                 {ptyp_desc = Ptyp_constr ({txt = Lident "int"}, [])})}}])}]),
    ...)};
 {pstr_desc =
   Pstr_extension
    (({txt = "test"},
      PStr
       [{pstr_desc =
          Pstr_value (Nonrecursive,
           [{pvb_pat =
              {ppat_desc = Ppat_construct ({txt = Lident "()"}, None)};
             pvb_expr =
              {pexp_desc =
                Pexp_apply ({pexp_desc = Pexp_ident {txt = Lident ":="}},
                 [(Nolabel, {pexp_desc = Pexp_ident {txt = Lident "r"}});
                  (Nolabel,
                   {pexp_desc =
                     Pexp_apply ({pexp_desc = Pexp_ident {txt = Lident "-"}},
                      [(Nolabel,
                        {pexp_desc =
                          Pexp_apply
                           ({pexp_desc = Pexp_ident {txt = Lident "!"}},
                           [(Nolabel,
                             {pexp_desc = Pexp_ident {txt = Lident "r"}})])});
                       (Nolabel,
                        {pexp_desc =
                          Pexp_constant (Pconst_integer ("2", None))})])})])}}])}]),
    ...)}]
=========
