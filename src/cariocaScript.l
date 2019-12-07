%{
  #include <string.h>
  #include "cariocaScript.tab.h"

  #define MAX_VAR_CNT 4

  extern void yyerror(const char *s);
  extern int symtab_size;

  char * symtab[MAX_VAR_CNT];
  int line_num = 1;
%}
%option noyywrap
%%
[ \t]         ;
CHEGAMAIS         { return CHEGAMAIS; }
CAIFORA           { return CAIFORA; }
VALEU             { return VALEU; }
MARCA            { return MARCA; }
RAPIDAO            { return RAPIDAO; }
FACA            { return FACA; }
VEZES           { return VEZES; }
ENQUANTO        { return ENQUANTO; }
SEPA              { return SEPA; }
ENTAO           { return ENTAO; }
SENAO           { return SENAO; }
INC             { return INC; }
ZERA            { return ZERA; }
[a-zA-Z]+       {
  for( int i = 0 ; i < symtab_size ; i++ )
  {
    if( !strcmp(symtab[i],yytext) )
    {
      yylval.ival = i;
      return ID;
    }
  }
  if( symtab_size == MAX_VAR_CNT )
  {
    yylval.ival = -1; // Error!
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
\=              { return EQ; }
\+=							{ return PLUS_EQ; }
\-=							{ return MINUS_EQ; }
\n              { ++line_num; }
.               ;
%%
void free_symtab()
{
  for(int i = 0; i < symtab_size; i++) free(symtab[i]);
}
