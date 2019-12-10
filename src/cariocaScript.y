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
%token NAMORAL
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
%token PLUS_PLUS
%token MINUS_MINUS
%token MINUS
%token PLUS_EQ
%token MINUS_EQ

%token <ival> ID
%type <sval> program
%type <sval> var_list
%type <sval> input
%type <sval> var_def
%type <sval> var_ref
%type <sval> cmds
%type <sval> cmd

%%
program: CHEGAMAIS input NAMORAL cmds VALEU
  {
    char * s_fim = (char *) malloc(sizeof(char)*64);
    char * s_begin = (char *) malloc(sizeof(char)*256);
    char * s_load = (char *) malloc(sizeof(char)*128);
    char * s_printf = (char *) malloc(sizeof(char)*128);
    if( !s_fim || !s_begin || !s_load || !s_printf)
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
		
		int local_variable_stacksize = (symtab_size*8)+      // The subq $%d instruction needs to be multiple of 16.
																	((symtab_size*8)%16);  // If we have 4 variables that's 24 bytes,
																												 // but the stack needs to be set to 32
																												 // bytes.

		sprintf(s_begin,     ".globl  cariocaScript\n "
												 "Si:  .string \"Meu Brother: \"\n\n "
												 "Sii:  .string \"%%d\"\n\n "
												 "Nl:  .string \"\\n\"\n\n "
												 "Sf:  .string \"Meu Parcerasso:%%d\\n\"\n\n "
												 "cariocaScript:\n\t "
												 "pushq %rbp\n\t "
												 "movq %rsp,%rbp\n\t "
												 "subq $%d, %rsp\n\n\t ",local_variable_stacksize);

			
		sprintf(s_fim,"    \t movq %rbp, %rsp\n\t "
												 "popq %rbp\n\t ret");

		
    $$ = concat(
			s_begin,
      $2,
      $4,
      s_fim
    );
    if( !$$ )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    free($2);
    free($4);
    free(s_fim);
    free(s_begin);
    free(s_load);
    printf("%s\n",$$); // show program
    free($$);
  };
input: var_list{
    char * s_printf = (char *) malloc(sizeof(char)*32);
    char * s_newline = (char *) malloc(sizeof(char)*32);
		sprintf(s_printf,"movq $Si, %rdi\n\t "
										"call printf\n\t "); 

		sprintf(s_newline,"movq $Nl, %rdi\n\t "
										"call printf\n\n\t "); 
		$$ = concat(s_printf, $1, s_newline);
		free(s_printf); free($1); free(s_newline);
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
      char * s_id = (char *) malloc(sizeof(char)*64);
      if( !s_id )
      {
        yyerror(MEM_ERROR);
        YYERROR;
      }
      symtab_size++;

      sprintf(s_id,  "movq $Sii, %rdi\n\t "
									   "leaq -%d(%%rbp), %%rsi\n\t "
										 "call scanf\n\n\t ",getRbpOffset($1));

      $$ = s_id;
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

    sprintf(s_copia,"  \t movl $0,%%r12d\n"
										"L%d:\n",label);

    sprintf(s_inc,  "  \t addl $1,%%r12d \n");

    sprintf(s_if,   "  \t cmpl %%r12d,-%d(%rbp)\n" 
								     " \t jne L%d \n",getRbpOffset($2),label);

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
											    "cmpl $0, -%d(%rbp)\n\t "
											    "je L%d\n",label,getRbpOffset($2),label+1);

    sprintf(s_fim,     "\t jmp L%d\n"
											 "L%d:\n",label,label+1);

    sprintf(s_exit,    "\n");

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
  | SEPA var_ref TA_LGD cmds SENAO cmds VALEU
  {
    char * s_if = (char *) malloc(sizeof(char)*64);
    char * s_else = (char *) malloc(sizeof(char)*32);
    char * s_exit = (char *) malloc(sizeof(char)*8);
    if( !s_if || !s_else || !s_exit )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_if,"cmpl $0,-%d(%rbp) \n\t "
								 "je L%d\n",getRbpOffset($2),label);

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

    sprintf(s_if,    " \t cmpl $0,-%d(%rbp) "
								    "\n\t je L%d\n",getRbpOffset($2),label);

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
    char * s_temp = (char *) malloc(sizeof(char)*64);
    char * s_attr = (char *) malloc(sizeof(char)*64);
    if( !s_attr )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_temp,"\t movl -%d(%rbp), %%r12d \n",getRbpOffset($3));
    sprintf(s_attr,"\t movl %%r12d, -%d(%rbp) \n",getRbpOffset($1));
    $$ = concat(s_temp,s_attr);
  }
  | var_ref PLUS_PLUS 
  {
    char * s_pp = (char *) malloc(sizeof(char)*64);
    if( !s_pp )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_pp,"\t addl $1, -%d(%rbp) \n",getRbpOffset($1));
    $$ = s_pp;
  }
  | var_ref MINUS_MINUS 
  {
    char * s_mm = (char *) malloc(sizeof(char)*64);
    if( !s_mm )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_mm,"\t subl $1, -%d(%rbp) \n",getRbpOffset($1));
    $$ = s_mm;
  }
  | var_ref PLUS_EQ var_ref
  {
    char * s_inc = (char *) malloc(sizeof(char)*48);
    if( !s_inc )
    {
      yyerror(MEM_ERROR);
      YYERROR;
    }
    sprintf(s_inc,"\t addl -%d(%rbp), -%d(%rbp) \n",getRbpOffset($3),getRbpOffset($1));
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
    sprintf(s_inc,"\t subl -%d(%rbp), -%d(%rbp) \n",getRbpOffset($3),getRbpOffset($1));
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
    sprintf(s_zero,"movl $0, -%d(%rbp)\n",getRbpOffset($3));
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
											 "movl -%d(%rbp), %%esi\n\t "
											 "call printf\n\n ",getRbpOffset($3)); 

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
