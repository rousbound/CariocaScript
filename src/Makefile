# Makefile
# Guilherme Dantas

CFLAGS = -w
BINFLDR = ../bin

all: setup $(BINFLDR)/provolone

setup: $(BINFLDR)

$(BINFLDR):
	mkdir -p $(BINFLDR)

lex.yy.c: provolone.l provolone.tab.h utils.h colours.h
	flex provolone.l

provolone.tab.c provolone.tab.h: provolone.y
	bison -d provolone.y

$(BINFLDR)/provolone: lex.yy.c provolone.tab.c provolone.tab.h utils.o
	gcc provolone.tab.c lex.yy.c utils.o -o $(BINFLDR)/provolone

utils.o: utils.c utils.h colours.h
	gcc utils.c -o utils.o -c

clean: clear

clear:
	rm lex.yy.c *.tab.* $(BINFLDR)/*
