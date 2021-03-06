BS=dune
LEXER=ocamllex
PARSER=ocamlyacc
OFILE=generated.ml

FILE?=default.pl

all:
	$(LEXER) lib/lexer/lexer.mll
	$(PARSER) lib/parser/parser.mly
	mv -f lib/lexer/lexer.ml lib/parser/parser.ml lib/parser/parser.mli lib/
	$(BS) build bin/main.exe
	
.PHONY: build clean tests

build:
	$(BS) build @install

clean:
	$(MAKE) -C incrementalizer/pierce clean
	$(MAKE) -C incrementalizer/spi-calculus clean
	$(BS) clean
	rm -f lib/lexer.ml lib/parser.ml lib/parser.mli *.txt lib/generated.ml $(OFILE)
	rm -rf generated
