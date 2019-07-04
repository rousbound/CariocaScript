# Makefile
# Guilherme Dantas

CFLAGS = -w
BINFLDR = ../bin

all: setup $(BINFLDR)/provolone tests

tests: $(BINFLDR)/t.utils

setup: $(BINFLDR)

$(BINFLDR):
	mkdir -p $(BINFLDR)

lex.yy.c: provolone.l provolone.tab.h
	flex provolone.l

provolone.tab.c provolone.tab.h: provolone.y colours.h utils.h
	bison -d provolone.y

$(BINFLDR)/provolone: lex.yy.c provolone.tab.c provolone.tab.h utils.o
	gcc provolone.tab.c lex.yy.c utils.o -o $(BINFLDR)/provolone $(CFLAGS)

utils.o: utils.c utils.h
	gcc -c utils.c -o utils.o $(CFLAGS)

t.utils.o: t.utils.c utils.h test.h
	gcc -c t.utils.c -o t.utils.o $(CFLAGS)

test.o: test.c test.h
	gcc -c test.c -o test.o $(CFLAGS)

$(BINFLDR)/t.utils: t.utils.o utils.o test.o
	gcc utils.o t.utils.o test.o -o $(BINFLDR)/t.utils $(CFLAGS)

clean: clear

clear:
	rm lex.yy.c *.tab.* $(BINFLDR)/*
