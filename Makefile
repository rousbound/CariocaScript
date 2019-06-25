# Makefile
# Guilherme Dantas

all: provolone

CFLAGS = -w

provolone: provolone.lex
	flex provolone.lex
	gcc lex.yy.c -o provolone

#provolone.tab.c provolone.tab.h: provolone.y
#	bison -d provolone.y

#lex.yy.c: provolone.l provolone.tab.h
#	flex provolone.l

