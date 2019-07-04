
  // Utilities module implementation
  // Guilherme Dantas
  // Felipe Vieira Ferreira

  #include <stdlib.h>
  #include <stdarg.h>
  #include <string.h>
  #include "utils.h"

  char * concatfunc(char * dummy, ...)
  {
    va_list va; int size = 1; char * si; va_start(va,dummy);
    while( (si=va_arg(va,char *)) != NULL ) size += strlen(si);
    va_end(va); va_start(va,dummy);
    char * cs = (char *) malloc(size);
    if( cs == NULL ) return NULL;
    while( (si=va_arg(va,char *)) != NULL ) strcat(cs,si);
    va_end(va); return cs;
  }
