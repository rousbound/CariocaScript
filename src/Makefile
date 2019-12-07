# Makefile

CFLAGS = -w
BINFLDR = ../bin

all: setup $(BINFLDR)/cariocaScript tests

setup: $(BINFLDR)

$(BINFLDR):
	mkdir -p $(BINFLDR)

lex.yy.c: cariocaScript.l cariocaScript.tab.h
	flex cariocaScript.l

cariocaScript.tab.c cariocaScript.tab.h: cariocaScript.y utils.h
	bison -d cariocaScript.y

$(BINFLDR)/cariocaScript: lex.yy.c cariocaScript.tab.c cariocaScript.tab.h utils.o
	gcc cariocaScript.tab.c lex.yy.c utils.o -o $(BINFLDR)/cariocaScript $(CFLAGS)

utils.o: utils.c utils.h
	gcc -c utils.c -o utils.o $(CFLAGS)


clean: clear

clear:
	rm lex.yy.c *.tab.* $(BINFLDR)/*

