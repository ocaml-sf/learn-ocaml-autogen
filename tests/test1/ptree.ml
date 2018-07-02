input.ml
==>
[{pstr_desc =
   Pstr_extension
    (({txt = "prepare"},
      PStr
       [{pstr_desc =
          Pstr_value (Nonrecursive,
           [{pvb_pat = {ppat_desc = Ppat_var {txt = "f"}};
             pvb_expr =
              {pexp_desc =
                Pexp_ifthenelse
                 ({pexp_desc = Pexp_construct ({txt = Lident "true"}, None)},
                 {pexp_desc = Pexp_constant (Pconst_integer ("3", None))},
                 Some
                  {pexp_desc = Pexp_constant (Pconst_integer ("5", None))})}}])}]),
    ...)};
 {pstr_desc =
   Pstr_extension
    (({txt = "prelude"},
      PStr
       [{pstr_desc =
          Pstr_value (Nonrecursive,
           [{pvb_pat = {ppat_desc = Ppat_var {txt = "g"}};
             pvb_expr =
              {pexp_desc =
                Pexp_let (Nonrecursive,
                 [{pvb_pat = {ppat_desc = Ppat_var {txt = "x"}};
                   pvb_expr =
                    {pexp_desc =
                      Pexp_construct ({txt = Lident "::"},
                       Some
                        {pexp_desc =
                          Pexp_tuple
                           [{pexp_desc =
                              Pexp_constant (Pconst_integer ("1", None))};
                            {pexp_desc =
                              Pexp_construct ({txt = Lident "::"},
                               Some
                                {pexp_desc =
                                  Pexp_tuple
                                   [{pexp_desc =
                                      Pexp_constant
                                       (Pconst_integer ("3", None))};
                                    {pexp_desc =
                                      Pexp_construct ({txt = Lident "::"},
                                       Some
                                        {pexp_desc =
                                          Pexp_tuple
                                           [{pexp_desc =
                                              Pexp_constant
                                               (Pconst_integer ("5", None))};
                                            {pexp_desc =
                                              Pexp_construct
                                               ({txt = Lident "[]"}, None)}]})}]})}]})}}],
                 {pexp_desc =
                   Pexp_apply
                    ({pexp_desc =
                       Pexp_ident {txt = Ldot (Lident "List", "map")}},
                    [(Nolabel,
                      {pexp_desc =
                        Pexp_fun (Nolabel, None, {ppat_desc = Ppat_any},
                         {pexp_desc =
                           Pexp_constant (Pconst_integer ("1", None))})});
                     (Nolabel, {pexp_desc = Pexp_ident {txt = Lident "x"}})])})}}])}]),
    ...)}]
=========
