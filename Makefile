# Makefile
# Guilherme Dantas

all: provolone

CFLAGS = -w

provolone: provolone.l
	flex provolone.l
	gcc lex.yy.c -o provolone

#provolone.tab.c provolone.tab.h: provolone.y
#	bison -d provolone.y
