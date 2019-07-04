%{
  #include <string.h>
  #include "provolone.tab.h"
  #include "utils.h"
  #include "colours.h"

  #define MAX_VAR_CNT 4

  extern void yyerror(const char *s);

  char * symtab[MAX_VAR_CNT];
  int line_num = 1;
  int var_cnt = 0;
%}
%option noyywrap
%%
[ \t]         ;
ENTRADA         { return ENTRADA; }
SAIDA           { return SAIDA; }
FIM             { return FIM; }
FACA            { return FACA; }
VEZES           { return VEZES; }
ENQUANTO        { return ENQUANTO; }
SE              { return SE; }
ENTAO           { return ENTAO; }
SENAO           { return SENAO; }
INC             { return INC; }
ZERA            { return ZERA; }
[a-zA-Z]+       {
  for( int i = 0 ; i < var_cnt ; i++ )
  {
    if( !strcmp(symtab[i],yytext) )
    {
      yylval.ival = i;
      return ID;
    }
  }
  if( var_cnt == MAX_VAR_CNT )
  {
    yyerror("Exceeded limit of variables on Symbol Table.");
    yylval.ival = -1; // Error!
  }
  else
  {
    symtab[var_cnt] = strdup(yytext);
    yylval.ival = var_cnt;
    var_cnt++;
  }
  return ID;
}
\(              { return OPEN_PAR; }
\)              { return CLOSE_PAR; }
\=              { return EQ; }
\n              { ++line_num; }
.               ;
%%
void free_symtab()
{
  for(int i = 0; i < var_cnt; i++) free(symtab[i]);
}
