%{
  #include <string.h>
  #include "cariocaScript.tab.h"

  #define MAX_VAR_CNT 8

  extern void yyerror(const char *s);
  extern int symtab_size;

  char * symtab[MAX_VAR_CNT];
  int line_num = 1;
%}
%option noyywrap
%%
[ \t]         ;
CHEGAMAIS         { return CHEGAMAIS; }
NAMORAL             { return NAMORAL; }
VALEU             { return VALEU; }
MARCA             { return MARCA; }
RAPIDAO           { return RAPIDAO; }
FACA            	{ return FACA; }
ENQUANTO        	{ return ENQUANTO; }
SEPA              { return SEPA; }
TA_LGD            { return TA_LGD; }
ENTAO           	{ return ENTAO; }
SENAO           	{ return SENAO; }
RELAXOU           { return RELAXOU; }
FALATU           { return FALATU; }

[a-zA-Z]+       {
  for( int i = 0 ; i < symtab_size ; i++ )
  {
    if( !strcmp(symtab[i],yytext) ) //yytext é um ponteiro pra string encontrada
    {
      yylval.ival = i; //yylval é o valor associado ao símbolo encontrado
      return ID;
    }
  }
  if( symtab_size == MAX_VAR_CNT )
  {
    yylval.ival = -1; 
  }
  else
  {
    symtab[symtab_size] = strdup(yytext);
    yylval.ival = symtab_size;
 }
  return ID;
}
\(              { return OPEN_PAR; }
\)              { return CLOSE_PAR; }
\{              { return OPEN_KEY; }
\}              { return CLOSE_KEY; }
\=              { return EQ; }
\+=							{ return PLUS_EQ; }
\++							{ return PLUS_PLUS; }
\--							{ return MINUS_MINUS; }
\-=							{ return MINUS_EQ; }
\n              { ++line_num; }
.               ;
%%
void free_symtab()
{
  for(int i = 0; i < symtab_size; i++) free(symtab[i]);
}
