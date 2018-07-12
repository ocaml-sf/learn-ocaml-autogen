FILES = prelude prepare solution template test
SUFFIX = .native
SOLPREFIX = sol_
MAPPREFIX = mapper_
ASTPREFIX = ptree_
TARGETS = $(addsuffix $(SUFFIX), $(addprefix $(MAPPREFIX), $(FILES)))

INPUT = input.ml

OCB_LIBS = -package compiler-libs.common
OCB = ocamlbuild $(OCB_LIBS)

DIRS = $(wildcard tests/*/)

OCF = ocamlfind ppx_tools/rewriter

.PHONY : clean clear all tests

all : $(TARGETS)

%.native : %.ml
	$(OCB) $@

test : all
	./run-tests

clean :
	$(OCB) -clean

clear : clean
	rm -f $(foreach X, $(DIRS), $(foreach Y, $(FILES), $X$Y.ml))
	rm -f $(foreach X, $(DIRS), $(foreach Y, $(FILES), $X$(ASTPREFIX)$Y.ml))
