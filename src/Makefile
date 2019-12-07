# Makefile

CFLAGS = -w
BINFLDR = ../bin

all: setup $(BINFLDR)/provolone tests

setup: $(BINFLDR)

$(BINFLDR):
	mkdir -p $(BINFLDR)

lex.yy.c: provolone.l provolone.tab.h
	flex provolone.l

provolone.tab.c provolone.tab.h: provolone.y utils.h
	bison -d provolone.y

$(BINFLDR)/provolone: lex.yy.c provolone.tab.c provolone.tab.h utils.o
	gcc provolone.tab.c lex.yy.c utils.o -o $(BINFLDR)/provolone $(CFLAGS)

utils.o: utils.c utils.h
	gcc -c utils.c -o utils.o $(CFLAGS)


clean: clear

clear:
	rm lex.yy.c *.tab.* $(BINFLDR)/*

