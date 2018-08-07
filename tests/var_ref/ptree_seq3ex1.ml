seq3ex1.ml
==>
[{pstr_desc =
   Pstr_open {popen_lid = {txt = Lident "Test_lib"}; popen_override = Fresh}};
 {pstr_desc =
   Pstr_open {popen_lid = {txt = Lident "Report"}; popen_override = Fresh}};
 {pstr_desc =
   Pstr_value (Nonrecursive,
    [{pvb_pat = {ppat_desc = Ppat_construct ({txt = Lident "()"}, None)};
      pvb_expr =
       {pexp_desc =
         Pexp_apply ({pexp_desc = Pexp_ident {txt = Lident ":="}},
          [(Nolabel, {pexp_desc = Pexp_ident {txt = Lident "nbmults"}});
           (Nolabel,
            {pexp_desc =
              Pexp_apply ({pexp_desc = Pexp_ident {txt = Lident "-"}},
               [(Nolabel,
                 {pexp_desc =
                   Pexp_apply ({pexp_desc = Pexp_ident {txt = Lident "!"}},
                    [(Nolabel,
                      {pexp_desc = Pexp_ident {txt = Lident "nbmults"}})])});
                (Nolabel,
                 {pexp_desc = Pexp_constant (Pconst_integer ("3", None))})])})])}}])};
 {pstr_desc =
   Pstr_value (Nonrecursive,
    [{pvb_pat = {ppat_desc = Ppat_construct ({txt = Lident "()"}, None)};
      pvb_expr =
       {pexp_desc =
         Pexp_apply ({pexp_desc = Pexp_ident {txt = Lident "@@"}},
          [(Nolabel, {pexp_desc = Pexp_ident {txt = Lident "set_result"}});
           (Nolabel,
            {pexp_desc =
              Pexp_apply ({pexp_desc = Pexp_ident {txt = Lident "@"}},
               [(Nolabel,
                 {pexp_desc =
                   Pexp_construct ({txt = Lident "::"},
                    Some
                     {pexp_desc =
                       Pexp_tuple
                        [{pexp_desc =
                           Pexp_construct ({txt = Lident "Message"},
                            Some
                             {pexp_desc =
                               Pexp_tuple
                                [{pexp_desc =
                                   Pexp_construct ({txt = Lident "::"},
                                    Some
                                     {pexp_desc =
                                       Pexp_tuple
                                        [{pexp_desc =
                                           Pexp_construct
                                            ({txt = Lident "Text"},
                                            Some
                                             {pexp_desc =
                                               Pexp_constant
                                                (Pconst_string
                                                  ("This time, ", None))})};
                                         {pexp_desc =
                                           Pexp_construct
                                            ({txt = Lident "::"},
                                            Some
                                             {pexp_desc =
                                               Pexp_tuple
                                                [{pexp_desc =
                                                   Pexp_construct
                                                    ({txt = Lident "Code"},
                                                    Some
                                                     {pexp_desc =
                                                       Pexp_constant
                                                        (Pconst_string ("x",
                                                          None))})};
                                                 {pexp_desc =
                                                   Pexp_construct
                                                    ({txt = Lident "::"},
                                                    Some
                                                     {pexp_desc =
                                                       Pexp_tuple
                                                        [{pexp_desc =
                                                           Pexp_construct
                                                            ({txt =
                                                               Lident "Text"},
                                                            Some
                                                             {pexp_desc =
                                                               Pexp_constant
                                                                (Pconst_string
                                                                  (" is ",
                                                                  None))})};
                                                         {pexp_desc =
                                                           Pexp_construct
                                                            ({txt =
                                                               Lident "::"},
                                                            Some
                                                             {pexp_desc =
                                                               Pexp_tuple
                                                                [{pexp_desc =
                                                                   Pexp_construct
                                                                    (
                                                                    {txt =
                                                                    Lident
                                                                    "Code"},
                                                                    Some
                                                                    {pexp_desc
                                                                    =
                                                                    Pexp_apply
                                                                    ({pexp_desc
                                                                    =
                                                                    Pexp_ident
                                                                    {txt =
                                                                    Lident
                                                                    "string_of_int"}},
                                                                    [(Nolabel,
                                                                    {pexp_desc
                                                                    =
                                                                    Pexp_ident
                                                                    {txt =
                                                                    Lident
                                                                    "x"}})])})};
                                                                 {pexp_desc =
                                                                   Pexp_construct
                                                                    (
                                                                    {txt =
                                                                    Lident
                                                                    "::"},
                                                                    Some
                                                                    {pexp_desc
                                                                    =
                                                                    Pexp_tuple
                                                                    [{pexp_desc
                                                                    =
                                                                    Pexp_construct
                                                                    ({txt =
                                                                    Lident
                                                                    "Text"},
                                                                    Some
                                                                    {pexp_desc
                                                                    =
                                                                    Pexp_constant
                                                                    (Pconst_string
                                                                    (".",
                                                                    None))})};
                                                                    {pexp_desc
                                                                    =
                                                                    Pexp_construct
                                                                    ({txt =
                                                                    Lident
                                                                    "[]"},
                                                                    None)}]})}]})}]})}]})}]})};
                                 {pexp_desc =
                                   Pexp_construct
                                    ({txt = Lident "Important"}, None)}]})};
                         {pexp_desc =
                           Pexp_construct ({txt = Lident "[]"}, None)}]})});
                (Nolabel,
                 {pexp_desc =
                   Pexp_apply ({pexp_desc = Pexp_ident {txt = Lident "@@"}},
                    [(Nolabel,
                      {pexp_desc =
                        Pexp_apply
                         ({pexp_desc =
                            Pexp_ident {txt = Lident "ast_sanity_check"}},
                         [(Nolabel,
                           {pexp_desc = Pexp_ident {txt = Lident "code_ast"}})])});
                     (Nolabel,
                      {pexp_desc =
                        Pexp_fun (Nolabel, None,
                         {ppat_desc =
                           Ppat_construct ({txt = Lident "()"}, None)},
                         {pexp_desc =
                           Pexp_let (Nonrecursive,
                            [{pvb_pat =
                               {ppat_desc = Ppat_var {txt = "sanity_report"}};
                              pvb_expr =
                               {pexp_desc =
                                 Pexp_apply
                                  ({pexp_desc =
                                     Pexp_ident {txt = Lident "|>"}},
                                  [(Nolabel,
                                    {pexp_desc =
                                      Pexp_apply
                                       ({pexp_desc =
                                          Pexp_ident
                                           {txt =
                                             Lident "ast_check_structure"}},
                                       [(Labelled "on_pattern",
                                         {pexp_desc =
                                           Pexp_function
                                            [{pc_lhs =
                                               {ppat_desc =
                                                 Ppat_extension
                                                  ({txt = "pat"},
                                                   PPat
                                                    ({ppat_desc =
                                                       Ppat_var {txt = "*"}},
                                                    None))};
                                              pc_guard = None;
                                              pc_rhs =
                                               {pexp_desc =
                                                 Pexp_construct
                                                  ({txt = Lident "::"},
                                                  Some
                                                   {pexp_desc =
                                                     Pexp_tuple
                                                      [{pexp_desc =
                                                         Pexp_construct
                                                          ({txt =
                                                             Lident "Message"},
                                                          Some
                                                           {pexp_desc =
                                                             Pexp_tuple
                                                              [{pexp_desc =
                                                                 Pexp_construct
                                                                  ({txt =
                                                                    Lident
                                                                    "::"},
                                                                  Some
                                                                   {pexp_desc
                                                                    =
                                                                    Pexp_tuple
                                                                    [{pexp_desc
                                                                    =
                                                                    Pexp_construct
                                                                    ({txt =
                                                                    Lident
                                                                    "Text"},
                                                                    Some
                                                                    {pexp_desc
                                                                    =
                                                                    Pexp_constant
                                                                    (Pconst_string
                                                                    ("Don't redefine ",
                                                                    None))})};
                                                                    {pexp_desc
                                                                    =
                                                                    Pexp_construct
                                                                    ({txt =
                                                                    Lident
                                                                    "::"},
                                                                    Some
                                                                    {pexp_desc
                                                                    =
                                                                    Pexp_tuple
                                                                    [{pexp_desc
                                                                    =
                                                                    Pexp_construct
                                                                    ({txt =
                                                                    Lident
                                                                    "Code"},
                                                                    Some
                                                                    {pexp_desc
                                                                    =
                                                                    Pexp_constant
                                                                    (Pconst_string
                                                                    ("(*)",
                                                                    None))})};
                                                                    {pexp_desc
                                                                    =
                                                                    Pexp_construct
                                                                    ({txt =
                                                                    Lident
                                                                    "::"},
                                                                    Some
                                                                    {pexp_desc
                                                                    =
                                                                    Pexp_tuple
                                                                    [{pexp_desc
                                                                    =
                                                                    Pexp_construct
                                                                    ({txt =
                                                                    Lident
                                                                    "Text"},
                                                                    Some
                                                                    {pexp_desc
                                                                    =
                                                                    Pexp_constant
                                                                    (Pconst_string
                                                                    (". Please, don't.",
                                                                    None))})};
                                                                    {pexp_desc
                                                                    =
                                                                    Pexp_construct
                                                                    ({txt =
                                                                    Lident
                                                                    "[]"},
                                                                    None)}]})}]})}]})};
                                                               {pexp_desc =
                                                                 Pexp_construct
                                                                  ({txt =
                                                                    Lident
                                                                    "Failure"},
                                                                  None)}]})};
                                                       {pexp_desc =
                                                         Pexp_construct
                                                          ({txt = Lident "[]"},
                                                          None)}]})}};
                                             {pc_lhs = {ppat_desc = Ppat_any};
                                              pc_guard = None;
                                              pc_rhs =
                                               {pexp_desc =
                                                 Pexp_construct
                                                  ({txt = Lident "[]"}, None)}}]});
                                        (Labelled "on_open",
                                         {pexp_desc =
                                           Pexp_apply
                                            ({pexp_desc =
                                               Pexp_ident
                                                {txt = Lident "forbid_syntax"}},
                                            [(Nolabel,
                                              {pexp_desc =
                                                Pexp_constant
                                                 (Pconst_string ("open",
                                                   None))})])});
                                        (Labelled "on_include",
                                         {pexp_desc =
                                           Pexp_apply
                                            ({pexp_desc =
                                               Pexp_ident
                                                {txt = Lident "forbid_syntax"}},
                                            [(Nolabel,
                                              {pexp_desc =
                                                Pexp_constant
                                                 (Pconst_string ("include",
                                                   None))})])});
                                        (Labelled "on_function_call",
                                         {pexp_desc =
                                           Pexp_fun (Nolabel, None,
                                            {ppat_desc =
                                              Ppat_tuple
                                               [{ppat_desc =
                                                  Ppat_var {txt = "expr"}};
                                                {ppat_desc = Ppat_any}]},
                                            {pexp_desc =
                                              Pexp_apply
                                               ({pexp_desc =
                                                  Pexp_ident
                                                   {txt =
                                                     Lident "restrict_expr"}},
                                               [(Nolabel,
                                                 {pexp_desc =
                                                   Pexp_constant
                                                    (Pconst_string
                                                      ("function", None))});
                                                (Nolabel,
                                                 {pexp_desc =
                                                   Pexp_construct
                                                    ({txt = Lident "::"},
                                                    Some
                                                     {pexp_desc =
                                                       Pexp_tuple
                                                        [{pexp_desc =
                                                           Pexp_extension
                                                            ({txt = "expr"},
                                                             PStr
                                                              [{pstr_desc =
                                                                 Pstr_eval
                                                                  ({pexp_desc
                                                                    =
                                                                    Pexp_ident
                                                                    {txt =
                                                                    Lident
                                                                    "*"}},
                                                                  ...)}])};
                                                         {pexp_desc =
                                                           Pexp_construct
                                                            ({txt =
                                                               Lident "[]"},
                                                            None)}]})});
                                                (Nolabel,
                                                 {pexp_desc =
                                                   Pexp_ident
                                                    {txt = Lident "expr"}})])})});
                                        (Nolabel,
                                         {pexp_desc =
                                           Pexp_ident
                                            {txt = Lident "code_ast"}})])});
                                   (Nolabel,
                                    {pexp_desc =
                                      Pexp_apply
                                       ({pexp_desc =
                                          Pexp_ident
                                           {txt =
                                             Ldot (Lident "List", "sort")}},
                                       [(Nolabel,
                                         {pexp_desc =
                                           Pexp_ident
                                            {txt = Lident "compare"}})])})])}}],
                            {pexp_desc =
                              Pexp_ifthenelse
                               ({pexp_desc =
                                  Pexp_apply
                                   ({pexp_desc =
                                      Pexp_ident {txt = Lident "snd"}},
                                   [(Nolabel,
                                     {pexp_desc =
                                       Pexp_apply
                                        ({pexp_desc =
                                           Pexp_ident
                                            {txt =
                                              Ldot (Lident "Report",
                                               "result_of_report")}},
                                        [(Nolabel,
                                          {pexp_desc =
                                            Pexp_ident
                                             {txt = Lident "sanity_report"}})])})])},
                               {pexp_desc =
                                 Pexp_ident {txt = Lident "sanity_report"}},
                               Some
                                {pexp_desc =
                                  Pexp_apply
                                   ({pexp_desc =
                                      Pexp_ident {txt = Lident "@"}},
                                   [(Nolabel,
                                     {pexp_desc =
                                       Pexp_apply
                                        ({pexp_desc =
                                           Pexp_ident
                                            {txt =
                                              Lident
                                               "test_variable_against_solution"}},
                                        [(Nolabel,
                                          {pexp_desc =
                                            Pexp_extension
                                             ({txt = "ty"},
                                              PTyp
                                               {ptyp_desc =
                                                 Ptyp_constr
                                                  ({txt = Lident "int"}, 
                                                  [])})});
                                         (Nolabel,
                                          {pexp_desc =
                                            Pexp_constant
                                             (Pconst_string ("x_power_8",
                                               None))})])});
                                    (Nolabel,
                                     {pexp_desc =
                                       Pexp_apply
                                        ({pexp_desc =
                                           Pexp_ident {txt = Lident "@"}},
                                        [(Nolabel,
                                          {pexp_desc =
                                            Pexp_construct
                                             ({txt = Lident "::"},
                                             Some
                                              {pexp_desc =
                                                Pexp_tuple
                                                 [{pexp_desc =
                                                    Pexp_construct
                                                     ({txt = Lident "Message"},
                                                     Some
                                                      {pexp_desc =
                                                        Pexp_tuple
                                                         [{pexp_desc =
                                                            Pexp_construct
                                                             ({txt =
                                                                Lident "::"},
                                                             Some
                                                              {pexp_desc =
                                                                Pexp_tuple
                                                                 [{pexp_desc
                                                                    =
                                                                    Pexp_construct
                                                                    ({txt =
                                                                    Lident
                                                                    "Text"},
                                                                    Some
                                                                    {pexp_desc
                                                                    =
                                                                    Pexp_constant
                                                                    (Pconst_string
                                                                    ("Testing how many times you multiplied.",
                                                                    None))})};
                                                                  {pexp_desc
                                                                    =
                                                                    Pexp_construct
                                                                    ({txt =
                                                                    Lident
                                                                    "[]"},
                                                                    None)}]})};
                                                          {pexp_desc =
                                                            Pexp_construct
                                                             ({txt =
                                                                Lident
                                                                 "Informative"},
                                                             None)}]})};
                                                  {pexp_desc =
                                                    Pexp_construct
                                                     ({txt = Lident "[]"},
                                                     None)}]})});
                                         (Nolabel,
                                          {pexp_desc =
                                            Pexp_apply
                                             ({pexp_desc =
                                                Pexp_ident
                                                 {txt = Lident "test_ref"}},
                                             [(Nolabel,
                                               {pexp_desc =
                                                 Pexp_extension
                                                  ({txt = "ty"},
                                                   PTyp
                                                    {ptyp_desc =
                                                      Ptyp_constr
                                                       ({txt = Lident "int"},
                                                       [])})});
                                              (Nolabel,
                                               {pexp_desc =
                                                 Pexp_ident
                                                  {txt = Lident "nbmults"}});
                                              (Nolabel,
                                               {pexp_desc =
                                                 Pexp_constant
                                                  (Pconst_integer ("3", None))})])})])})])})})})})])})])})])}}])}]
=========
