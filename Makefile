TARGET=main

default: $(TARGET).byte

$(TARGET): default

native: $(TARGET).native

#test: test.native #mv $@ $*

%.native:
	ocamlbuild -use-ocamlfind $@

%.byte:
	ocamlbuild -use-ocamlfind $@

all: default native

clean:
	ocamlbuild -clean

.PHONY: all clean
