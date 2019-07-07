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
  unsigned int state = 0;
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
%type <sval> var_def
%type <sval> var_ref
%type <sval> cmds
%type <sval> cmd

%%
// This is the actual grammar that bison will parse, but for right now it's just
// something silly to echo to the screen what bison gets from flex.  We'll
// make a real one shortly:
program: ENTRADA var_list SAIDA var_list cmds FIM
  {
    char * s_fim = (char *) malloc(sizeof(char)*32);
    if( !s_fim )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_fim," %d\t End of program.\n",state);
    $$ = concat(
      "\n Loaded input symbols:\n",
      $2,
      " Loaded output symbols:\n",
      $4,
      " \n State\t Command\n-------------------------------------------------\n",
      $5,
      s_fim
    );
    if( !$$ )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    free($2);
    free($4);
    free($5);
    free(s_fim);
    printf("%s\n",$$); // show program
    free($$);
  };
var_list: var_list var_def
  {
    $$ = concat($1,$2);
    if( !$$ )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    free($1); free($2);
  }
  | var_def
  {
    $$ = $1; // simply pass the pointer
  };
var_def: ID
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
      sprintf(s_id," Symbol assigned to tape %d.\n",$1);
      $$ = s_id;
      symtab_size++;
    }
  }
var_ref: ID
  {
    if( $1 >= symtab_size )
    {
      yyerror("undeclared symbol");
      YYERROR;
    }
    $$ = $1; // passes symbol table index
  }
cmds: cmds cmd
  {
    $$ = concat($1,$2);
    if( !$$ )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    free($1); free($2);
    state++;
  }
  | cmd
  {
    $$ = $1; // simply pass the pointer
    state++;
  };
cmd: FACA var_ref VEZES cmds FIM
  {
    char * s_faca = (char *) malloc(sizeof(char)*48);
    char * s_check = (char *) malloc(sizeof(char)*64);
    char * s_fim = (char *) malloc(sizeof(char)*64);
    char * s_exit = (char *) malloc(sizeof(char)*8);
    if( !s_faca || !s_fim || !s_check || !s_exit )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_faca," %d\t Add value on tape %d to stack\n",state,$2);
    sprintf(s_check," %d'\t If value on stack is zero, dequeue it and goto %d*.\n",state,state);
    sprintf(s_fim," %d\"\t Decrement value on stack and goto %d'.\n",state,state);
    sprintf(s_exit," %d*\n",state);
    $$ = concat(
      s_faca,
      s_check,
      $4,
      s_fim,
      s_exit
    );
    if( !$$ )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    free(s_faca); free(s_check); free($4); free(s_fim); free(s_exit);
  }
  | ENQUANTO var_ref FACA cmds FIM
  {
    char * s_enquanto = (char *) malloc(sizeof(char)*64);
    char * s_fim = (char *) malloc(sizeof(char)*32);
    char * s_exit = (char *) malloc(sizeof(char)*8);
    if( !s_enquanto || !s_fim || !s_exit )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_enquanto," %d\t If value on tape %d is zero, goto %d*.\n",state,$2,state);
    sprintf(s_fim," %d'\t Goto %d.\n",state,state);
    sprintf(s_exit," %d*\n",state);
    $$ = concat(
      s_enquanto,
      $4,
      s_fim,
      s_exit
    );
    if( !$$ )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    free(s_enquanto); free($4); free(s_fim); free(s_exit);
  }
  | SE var_ref ENTAO cmds SENAO cmds FIM
  {
    char * s_if = (char *) malloc(sizeof(char)*64);
    char * s_else = (char *) malloc(sizeof(char)*32);
    char * s_exit = (char *) malloc(sizeof(char)*8);
    if( !s_if || !s_else || !s_exit )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_if," %d\t If value on tape %d is zero, goto %d\".\n",state,$2,state);
    sprintf(s_else," %d'\t Goto %d*\n %d\"\n",state,state,state);
    sprintf(s_exit," %d*\n",state);
    $$ = concat(
      s_if,
      $4,
      s_else,
      $6,
      s_exit
    );
    if( !$$ )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    free(s_if); free($4); free(s_else); free($6); free(s_exit);
  }
  | SE var_ref ENTAO cmds FIM
  {
    char * s_if = (char *) malloc(sizeof(char)*64);
    char * s_exit = (char *) malloc(sizeof(char)*8);
    if( !s_if )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_if," %d\t If value on tape %d is zero, goto %d*.\n",state,$2,state);
    sprintf(s_exit," %d*\n",state);
    $$ = concat(
      s_if,
      $4,
      s_exit
    );
    if( !$$ )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    free(s_if); free($4); free(s_exit);
  }
  | var_ref EQ var_ref
  {
    char * s_attr = (char *) malloc(sizeof(char)*64);
    if( !s_attr )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_attr," %d\t Copy value from tape %d to tape %d.\n",state,$3,$1);
    $$ = s_attr;
  }
  | INC OPEN_PAR var_ref CLOSE_PAR
  {
    char * s_inc = (char *) malloc(sizeof(char)*48);
    if( !s_inc )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_inc," %d\t Increment value on tape %d.\n",state,$3);
    $$ = s_inc;
  }
  | ZERA OPEN_PAR var_ref CLOSE_PAR
  {
    char * s_zero = (char *) malloc(sizeof(char)*48);
    if( !s_zero )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_zero," %d\t Zero value on tape %d.\n",state,$3);
    $$ = s_zero;
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
