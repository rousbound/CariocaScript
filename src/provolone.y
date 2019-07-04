%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include "colours.h"
  #include "utils.h"

  #define OVFLW_ERROR "symbol table overflow"
  #define MEM_ERROR "could not allocate memory"

  // Declare stuff from Flex that Bison needs to know about:
  extern int yylex();
  extern int yyparse();
  extern void free_symtab();
  extern FILE *yyin;
  extern int line_num;

  void yyerror(const char *s);
  int symtab_size = 0;
%}

// Bison fundamentally works by asking flex to get the next token, which it
// returns as an object of type "yystype".  Initially (by default), yystype
// is merely a typedef of "int", but for non-trivial projects, tokens could
// be of any arbitrary data type.  So, to deal with that, the idea is to
// override yystype's default typedef to be a C union instead.  Unions can
// hold all of the types of tokens that Flex could return, and this this means
// we can return ints or floats or strings cleanly.  Bison implements this
// mechanism with the %union directive:
%union {
  int ival;
  char * sval;
}

// define the constant-string tokens:
%token ENTRADA
%token SAIDA
%token FIM
%token FACA
%token VEZES
%token ENQUANTO
%token SE
%token ENTAO
%token SENAO
%token INC
%token ZERA
%token OPEN_PAR
%token CLOSE_PAR
%token EQ

// Define the "terminal symbol" token types and associate each with a field of the %union:
%token <ival> ID

// Define the "non-terminal symbols" types and associate each with a field of the %union:
%type <sval> program
%type <sval> var_list
%type <sval> var
%type <sval> cmds
%type <sval> cmd

%%
// This is the actual grammar that bison will parse, but for right now it's just
// something silly to echo to the screen what bison gets from flex.  We'll
// make a real one shortly:
program: ENTRADA var_list SAIDA var_list cmds FIM
  {
    char * s_entrada = (char *) malloc(sizeof(char)*32);
    char * s_saida = (char *) malloc(sizeof(char)*32);
    char * s_fim = (char *) malloc(sizeof(char)*16);
    if( !s_entrada || !s_saida || !s_fim )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_entrada,"Loaded variables as input:\n");
    sprintf(s_saida,"Loaded variables as output:\n");
    sprintf(s_fim,"End of program.");
    $$ = concat(s_entrada, $2, s_saida, $4, /*$5,*/ s_fim);
    if( !$$ )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    free(s_entrada); free($2); free(s_saida); free($4); /*free($5);*/ free(s_fim);
    printf("%s\n",$$);
  };
var_list: var_list var
  {
    $$ = concat($1,$2);
    if( !$$ )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    free($1); free($2);
  }
  | var
  {
    $$ = $1; // simply pass the pointer
  };
var: ID
  {
    if( $1 == -1 )
    {
      yyerror(OVFLW_ERROR);
      YYERROR;
    }
    else
    {
      char * s_id = (char *) malloc(sizeof(char)*32);
      if( !s_id )
      {
        yyerror(MEM_ERROR);
        YYERROR;
      }
      sprintf(s_id,"Variable parsed: %d.\n",$1);
      $$ = s_id;
      symtab_size++;
    }
  }
cmds: cmds cmd
  {
    // $$ = concat($1,$2);
    // if( !$$ )
    // {
    //   yyerror(MEM_ERROR);
    //   YYERROR;
    // }
    // free($1); free($2);
  }
  | cmd
  {
    // $$ = $1; // simply pass the pointer
  };
cmd: FACA ID VEZES cmds FIM
  {
    if( $2 >= symtab_size )
    {
      yyerror("undeclared symbol");
      YYERROR;
    }
    else
    {
      // printf("For loop parsed (%d times).\n",$2);
    }
  }
  | ENQUANTO ID FACA cmds FIM
  {
    if( $2 >= symtab_size )
    {
      yyerror("undeclared symbol");
      YYERROR;
    }
    else
    {
      // printf("While loop parsed (while %d is true).\n",$2);
    }
  }
  | SE ID ENTAO cmds SENAO cmds FIM
  {
    if( $2 >= symtab_size )
    {
      yyerror("undeclared symbol");
      YYERROR;
    }
    else
    {
      // printf("If else parsed (if %d).\n",$2);
    }
  }
  | SE ID ENTAO cmds FIM
  {
    if( $2 >= symtab_size )
    {
      yyerror("undeclared symbol");
      YYERROR;
    }
    else
    {
      // printf("If parsed (if %d).\n",$2);
    }
  }
  | ID EQ ID
  {
    if( $1 >= symtab_size ||  $3 >= symtab_size )
    {
      yyerror("undeclared symbol");
      YYERROR;
    }
    else
    {
      // printf("Attribution %d = %d parsed.\n",$1,$3);
    }
  }
  | INC OPEN_PAR ID CLOSE_PAR
  {
    if( $3 >= symtab_size )
    {
      yyerror("undeclared symbol");
      YYERROR;
    }
    else
    {
      // printf("Increment %d parsed.\n",$3);
    }
  }
  | ZERA OPEN_PAR ID CLOSE_PAR
  {
    if( $3 >= symtab_size )
    {
      yyerror("undeclared symbol");
      YYERROR;
    }
    else
    {
      // printf("Zero-ing %d parsed.\n",$3);
    }
  };
%%

int main(int argc, char** argv) {
  if( argc > 1 )
  {
    char * file_path = argv[1];
    // Open a file handle to a particular file:
    FILE *input_file = fopen(file_path, "r");
    // Make sure it is valid:
    if (!input_file) {
      printf("Can't open file '%s'.\n",file_path);
      return -1;
    }
    // Set Flex to read from it instead of defaulting to STDIN:
    yyin = input_file;
  }
  else
  {
    // Reading from STDIN
  }

  // Parse through the input:
  yyparse();
  // Free Symbol Table
  free_symtab();
}

void yyerror(const char *s) {
  printf(BOLD_CYAN);
  printf("Parsing error at line %d: '%s'\n",line_num,s);
  printf(DEFAULT_COLOUR);
}
