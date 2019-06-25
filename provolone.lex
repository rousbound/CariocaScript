%{
  #include <stdio.h>
  extern int yylex();
%}
%option noyywrap
%%
[ \t\n]         ;
[0-9]+          { printf("Found an integer: %s\n",yytext); }
[a-zA-Z0-9]+    { printf("Found a string: %s\n",yytext); }
.               { printf("Found something else: %s\n",yytext); }
%%
int main(int argc, char** argv)
{
  // lex through the input:
  while (yylex());
}
