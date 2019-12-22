  #include <stdlib.h>
  #include <stdarg.h>
  #include <string.h>
  #include "utils.h"

  char * concatfunc(char * dummy, ...)
  {
    va_list va; int size = 1; char * si; va_start(va,dummy);
    while( (si=va_arg(va,char *)) != NULL )
			 size += strlen(si);
    va_end(va); 
		va_start(va,dummy);
    char * cs = (char *) malloc(sizeof(char)*size);
    if( cs == NULL ) return NULL; 
		cs[0] = '\0';
    while( (si=va_arg(va,char *)) != NULL )
			 strcat(cs,si);
    va_end(va); 
		return cs;
  }

	int getRbpOffset(int symbol){
		return 8+(symbol*8);
	}
