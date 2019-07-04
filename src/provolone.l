%{
  #include "provolone.tab.h"
  #include "utils.h"
  #include "colours.h"

  #define MAX_VAR_CNT 4

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
  yylval.sval = strdup(yytext);
  var_cnt++;
  if( var_cnt > MAX_VAR_CNT )
  {
    // printc("Flex",BOLD_RED,"Exceeded limit of variables on Symbol Table.\n");
  }
  return STRING;
}
\(              { return OPEN_PAR; }
\)              { return CLOSE_PAR; }
\=              { return EQ; }
\n              { ++line_num; }
.               ;
%%
