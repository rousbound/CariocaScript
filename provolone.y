%{
  #include <stdio.h>
  #include <stdlib.h>

  // Declare stuff from Flex that Bison needs to know about:
  extern int yylex();
  extern int yyparse();
  extern FILE *yyin;
  extern int line_num;
 
  void yyerror(const char *s);
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
  char *sval;
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

// Define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the %union:
%token <sval> STRING

%%
// This is the actual grammar that bison will parse, but for right now it's just
// something silly to echo to the screen what bison gets from flex.  We'll
// make a real one shortly:
program: ENTRADA var_list SAIDA var_list cmds FIM
  {
    printf("Program parsed.\n");
  };
var_list: STRING var_list
  {
    printf("Variable list parsed.\n");
  }
  | STRING
  {
    printf("Variable list parsed.\n");
  };
cmds: cmd cmds
  {
    printf("Command parsed.\n");
  }
  | cmd
  {
    printf("Command parsed.\n");
  };
cmd: FACA STRING VEZES cmds FIM
  {
    printf("For loop parsed.\n");
  }
  | ENQUANTO STRING FACA cmds FIM
  {
    printf("While loop parsed.\n");
  }
  | SE STRING ENTAO cmds SENAO cmds
  {
    printf("If else parsed.\n");
  }
  | SE STRING ENTAO cmds
  {
    printf("If parsed.\n");
  }
  | STRING EQ STRING
  {
    printf("Attribution parsed.\n");
  }
  | INC OPEN_PAR STRING CLOSE_PAR
  {
    printf("Increment parsed.\n");
  }
  | ZERA OPEN_PAR STRING CLOSE_PAR
  {
    printf("Zero-ing parsed.\n");
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
}

void yyerror(const char *s) {
  printf("Parsing error at line %d: '%s'\n",line_num,s);
  // might as well halt now:
  exit(-1);
}
