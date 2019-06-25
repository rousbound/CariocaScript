%{
  #include "provolone.tab.h"
  int line_num = 1;
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
[a-zA-Z]+       { yylval.sval = strdup(yytext); return STRING; }
\(              { return OPEN_PAR; }
\)              { return CLOSE_PAR; }
\=              { return EQ; }
\n              { ++line_num; }
.               ;
%%
