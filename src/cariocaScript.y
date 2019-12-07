%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include "utils.h"

  #define OVFLW_ERROR "symbol table overflow"
  #define MEM_ERROR "could not allocate memory"

  extern int yylex();
  extern int yyparse();
  extern void free_symtab();
  extern FILE *yyin;
  extern int line_num;

  void yyerror(const char *s);
  int symtab_size = 0;
  unsigned int state = 0;
	int label = 0;
%}

%union {
  int ival;
  char * sval;
}

%token CHEGAMAIS
%token CAIFORA
%token VALEU
%token FACA
%token MARCA
%token RAPIDAO
%token ENQUANTO
%token SEPA
%token FALATU
%token TA_LGD
%token ENTAO
%token SENAO
%token RELAXOU

%token OPEN_PAR
%token CLOSE_PAR
%token OPEN_KEY
%token CLOSE_KEY

%token EQ
%token PLUS
%token MINUS
%token PLUS_EQ
%token MINUS_EQ

%token <ival> ID
%type <sval> program
%type <sval> var_list
%type <sval> var_def
%type <sval> var_ref
%type <sval> cmds
%type <sval> cmd

%%
program: CHEGAMAIS var_list CAIFORA var_list cmds VALEU
  {
    char * s_fim = (char *) malloc(sizeof(char)*64);
    char * s_begin = (char *) malloc(sizeof(char)*128);
    char * s_load = (char *) malloc(sizeof(char)*128);
    char * s_printf = (char *) malloc(sizeof(char)*128);
    if( !s_fim || !s_begin || !s_load || !s_printf)
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }

		sprintf(s_begin,     ".globl  cariocaScript\n "
												 "Sf:  .string \"Output:%%d\\n\"\n\n "
												 "cariocaScript:\n\t "
												 "pushq %rbp\n\t "
												 "movq %rsp,%rbp\n\n");

		sprintf(s_load,  " \t movl %%edi, %r0\n\t " 
												 "movl %%esi, %r1\n\n");
			
		sprintf(s_fim,"    \t movq %rbp, %rsp\n\t "
												 "popq %rbp\n\t ret");

		sprintf(s_printf," \t movq $Sf, %rdi\n\t "
												 "movl %r2, %%esi\n\t "
												 "call printf\n"); 
		
    $$ = concat(
      "\n Loaded input symbols to registers:\n\n",
      $2,
      "\n Loaded output symbols to registers:\n\n",
      $4,
      " \n Labels\t Command\n-------------------------------------------------\n",
			s_begin,
			s_load,
      $5,
			s_printf,
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
    free(s_begin);
    free(s_load);
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
      sprintf(s_id,"  -Variable assigned to register %r%d.\n",$1);
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
		label++;
  }
  | cmd
  {
    $$ = $1; // simply pass the pointer
		label++;
  };
cmd: MARCA var_ref RAPIDAO cmds VALEU
  {
    char * s_copia = (char *) malloc(sizeof(char)*48);
    char * s_if = (char *) malloc(sizeof(char)*64);
    char * s_inc = (char *) malloc(sizeof(char)*32);
    char * s_exit = (char *) malloc(sizeof(char)*8);
    if( !s_copia || !s_if || !s_inc || !s_exit )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
		int iterator = symtab_size;

    sprintf(s_copia,"  \t movl $0,%r%d\n"
										"L%d:\n",iterator,label);

    sprintf(s_inc,  "  \t addl $1,%r%d \n",iterator);

    sprintf(s_if,   "  \t cmpl %r%d,%r%d\n" 
								     " \t jne L%d \n",$2,iterator,label);

    sprintf(s_exit,"\n",label);

    $$ = concat(
      s_copia,
			s_inc,
      $4,
      s_if,
			s_exit
    );
    if( !$$ )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    free(s_copia); free(s_inc); free($4); free(s_if);  free(s_exit);
  }
  | ENQUANTO var_ref FACA cmds VALEU
  {
    char * s_enquanto = (char *) malloc(sizeof(char)*64);
    char * s_fim = (char *) malloc(sizeof(char)*32);
    char * s_exit = (char *) malloc(sizeof(char)*8);
    if( !s_enquanto || !s_fim || !s_exit )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_enquanto,   "L%d:\n\t "
											    "cmpl $0, %r%d\n\t "
											    "je L%d\n",label,$2,label+1);

    sprintf(s_fim,     "\t je L%d\n"
									        "L%d:\n",label,label+1);

    sprintf(s_exit,       " \n");

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
  | SEPA var_ref ENTAO cmds SENAO cmds VALEU
  {
    char * s_if = (char *) malloc(sizeof(char)*64);
    char * s_else = (char *) malloc(sizeof(char)*32);
    char * s_exit = (char *) malloc(sizeof(char)*8);
    if( !s_if || !s_else || !s_exit )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_if," \t cmpl $0,%r%d \n\t "
								 "je L%d\n",$2,label);

    sprintf(s_else,"\t jmp L%d\n"
									 "L%d:\n",label+1,label);

    sprintf(s_exit,"L%d:\n",label+1);

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
  | SEPA var_ref TA_LGD cmds VALEU
  {
    char * s_if = (char *) malloc(sizeof(char)*64);
    char * s_exit = (char *) malloc(sizeof(char)*8);
    if( !s_if )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }

    sprintf(s_if,    " \t cmpl $0,%r%d "
								    "\n\t je L%d\n",$2,label);

    sprintf(s_exit,      "L%d:\n",label);

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
    sprintf(s_attr,"\t movl %r%d, %r%d \n",$3,$1);
    $$ = s_attr;
  }
  | var_ref PLUS_EQ var_ref
  {
    char * s_inc = (char *) malloc(sizeof(char)*48);
    if( !s_inc )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_inc,"\t addl %r%d, %r%d \n",$3,$1);
    $$ = s_inc;
  }
  | var_ref MINUS_EQ var_ref
  {
    char * s_inc = (char *) malloc(sizeof(char)*48);
    if( !s_inc )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_inc,"\t subl %r%d, %r%d \n",$3,$1);
    $$ = s_inc;
  }
  | RELAXOU OPEN_PAR var_ref CLOSE_PAR
  {
    char * s_zero = (char *) malloc(sizeof(char)*48);
    if( !s_zero )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_zero," \t movl $0, %r%d\n",$3);
    $$ = s_zero;
  }
  | FALATU OPEN_PAR var_ref CLOSE_PAR
  {
    char * s_print = (char *) malloc(sizeof(char)*96);
    if( !s_print )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
		sprintf(s_print," \t movq $Sf, %rdi\n\t "
									     "movl %r%d, %%ebx\n\t "
											 "movl %%ebx, %%esi\n\t "
											 "call printf\n\t " 
											 "movl %%ebx, %r%d\n\n ",$3,$3);

    $$ = s_print;

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
  printf("Parsing error at line %d: '%s'\n",line_num,s);
}
