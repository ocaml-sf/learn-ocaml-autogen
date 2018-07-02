FILES = prelude prepare
SUFFIX = .native
PREFIX = make_
TARGETS = $(addsuffix $(SUFFIX), $(addprefix $(PREFIX), $(FILES)))

INPUT = input.ml

OCB_LIBS = -package compiler-libs.common
OCB = ocamlbuild $(OCB_LIBS)

OCF = ocamlfind ppx_tools/rewriter

.PHONY : clean all rewrite

all : $(TARGETS)

%.native : %.ml
	$(OCB) $@

rewrite : $(addsuffix .ml, $(FILES))

%.ml : make_%.native
	$(OCF) ./$< $(INPUT) -o $@

clean :
	$(OCB) -clean

clear : clean
	rm -f $(addsuffix .ml, $(FILES))
