# Makefile
# Guilherme Dantas

CFLAGS = -w
BINFLDR = ../bin

all: setup $(BINFLDR)/provolone

setup: $(BINFLDR)

$(BINFLDR):
	mkdir -p $(BINFLDR)

lex.yy.c: provolone.l provolone.tab.h
	flex provolone.l

provolone.tab.c provolone.tab.h: provolone.y
	bison -d provolone.y

$(BINFLDR)/provolone: lex.yy.c provolone.tab.c provolone.tab.h
	gcc provolone.tab.c lex.yy.c -o $(BINFLDR)/provolone

clean: clear

clear:
	rm lex.yy.c *.tab.* $(BINFLDR)/*
