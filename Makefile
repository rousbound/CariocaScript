# Makefile
# Guilherme Dantas

CFLAGS = -w

lex.yy.c: provolone.l provolone.tab.h
	flex provolone.l

provolone.tab.c provolone.tab.h: provolone.y
	bison -d provolone.y -v

provolone: lex.yy.c provolone.tab.c provolone.tab.h
	gcc provolone.tab.c lex.yy.c -o provolone
