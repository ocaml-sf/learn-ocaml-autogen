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
MAPPERS = $(addprefix $(MAPPREFIX), $(FILES))
TARGETS = $(addsuffix $(SUFFIX), $(MAPPERS))

MAIN = autogen
EXE = $(MAIN)$(SUFFIX)
NAME = learn-ocaml-autogen
BEXE = $(BDIR)/$(NAME)

OCB_LIBS = -package compiler-libs.common -package cmdliner -package ezjsonm
OCB_DIR_FLAGS = -I $(SDIR)
OCB = ocamlbuild $(OCB_LIBS) $(OCB_DIR_FLAGS)

TESTS = $(wildcard $(TDIR)/*/)

OCF = ocamlfind ppx_tools/rewriter

.PHONY : all clean clear test tests_clean learn-ocaml-autogen.install install remove

all : $(TARGETS)
	$(OCB) $(EXE)
	mkdir -p $(BDIR) && mv $(EXE) $(BEXE); mv *$(SUFFIX) $(BDIR)

%.native : $(SDIR)/%.ml
	$(OCB) $@

test : all
	$(TDIR)/run-tests

learn-ocaml-autogen.install :
	@echo 'bin: [' > $@
	@$(foreach X, $(TARGETS), echo '  "$(BDIR)/$X" {"$X"}' >> $@;)
	@echo '  "$(BEXE)" {"$(NAME)"}' >> $@
	@echo ']' >> $@
	@echo 'lib: [' >> $@
	@$(foreach M, $(MAPPERS), $(foreach EXT, .cmi .cmo .cmx, \
	  echo '  "_build/src/$M$(EXT)" {"$M$(EXT)"}' >> $@;))
	@echo ']' >> $@

install : all learn-ocaml-autogen.install
	@opam-installer --prefix `opam var prefix` learn-ocaml-autogen.install

remove : learn-ocaml-autogen.install
	@opam-installer --prefix `opam var prefix` -u learn-ocaml-autogen.install

clean : remove
	$(OCB) -clean
	@rm -rf rmdir $(BDIR)
	@rm -f learn-ocaml-autogen.install

tests_clean :
	@rm -f $(foreach X, $(TESTS), $(foreach Y, $(FILES), $X$Y.ml))
	@rm -f $(foreach X, $(TESTS), $(foreach Y, $(FILES), $X$(ASTPREFIX)$Y.ml))
	@rm -f $(foreach X, $(TESTS), $(foreach Y, $(FILES), $X$(ASTPREFIX)$(SOLPREFIX)$Y.ml))
	@rm -f $(foreach X, $(TESTS), $X$(META))

clear : clean tests_clean
