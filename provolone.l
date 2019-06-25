%{
  #include <stdio.h>
  extern int yylex();
%}
%option noyywrap
%%
[ \t\n]         ;
ENTRADA         { printf("Match: %s\n",yytext); }
SAIDA           { printf("Match: %s\n",yytext); }
FIM             { printf("Match: %s\n",yytext); }
FACA            { printf("Match: %s\n",yytext); }
VEZES           { printf("Match: %s\n",yytext); }
SE              { printf("Match: %s\n",yytext); }
ENTAO           { printf("Match: %s\n",yytext); }
SENAO           { printf("Match: %s\n",yytext); }
INC             { printf("Match: %s\n",yytext); }
ZERA            { printf("Match: %s\n",yytext); }
[0-9]+          { printf("Found an integer: %s\n",yytext); }
[a-zA-Z0-9]+    { printf("Found a string: %s\n",yytext); }
.               ;
%%
int main(int argc, char** argv)
{
  // For now, reading from STDIN
  while (yylex());
}
