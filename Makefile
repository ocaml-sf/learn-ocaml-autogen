FILES = prelude prepare solution template test meta
META = meta.json
BDIR = bin
SDIR = src
TDIR = tests
INPUT = input.ml

SUFFIX = .native
SOLPREFIX = sol_
MAPPREFIX = mapper_
ASTPREFIX = ptree_
TARGETS = $(addsuffix $(SUFFIX), $(addprefix $(MAPPREFIX), $(FILES)))

NAME = autogen
EXE = $(NAME)$(SUFFIX)
BEXE = $(BDIR)/$(NAME)

OCB_LIBS = -package compiler-libs.common -package cmdliner -package ezjsonm
OCB_DIR_FLAGS = -I $(SDIR)
OCB = ocamlbuild $(OCB_LIBS) $(OCB_DIR_FLAGS)

TESTS = $(wildcard $(TDIR)/*/)

OCF = ocamlfind ppx_tools/rewriter

.PHONY : all clean clear test tests_clean

all : $(TARGETS)
	$(OCB) $(EXE)
	mkdir -p $(BDIR) && mv $(EXE) $(BEXE); mv *$(SUFFIX) $(BDIR)

%.native : $(SDIR)/%.ml
	$(OCB) $@

test : all
	$(TDIR)/run-tests

clean :
	$(OCB) -clean
	rmdir $(BDIR)

tests_clean :
	@rm -f $(foreach X, $(TESTS), $(foreach Y, $(FILES), $X$Y.ml))
	@rm -f $(foreach X, $(TESTS), $(foreach Y, $(FILES), $X$(ASTPREFIX)$Y.ml))
	@rm -f $(foreach X, $(TESTS), $(foreach Y, $(FILES), $X$(ASTPREFIX)$(SOLPREFIX)$Y.ml))
	@rm -f $(foreach X, $(TESTS), $X$(META))

clear : clean tests_clean
