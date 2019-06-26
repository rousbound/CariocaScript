# Makefile
# Guilherme Dantas

CFLAGS = -w

all: provolone

lex.yy.c: provolone.l provolone.tab.h
	flex provolone.l

provolone.tab.c provolone.tab.h: provolone.y
	bison -d provolone.y

provolone: lex.yy.c provolone.tab.c provolone.tab.h
	gcc provolone.tab.c lex.yy.c -o provolone

clean: clear

clear:
	find . -type f -executable -exec sh -c "file -i '{}' | grep -q 'x-executable; charset=binary'" \; -print | xargs rm -f
	rm lex.yy.c *.tab.*
