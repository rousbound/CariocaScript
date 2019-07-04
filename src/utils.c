
  // Utilities module implementation
  // Guilherme Dantas

  #include <stdlib.h>
  #include <stdarg.h>
  #include <string.h>
  #include "utils.h"

  char * concat(int n, char * s, ...) {
    va_list va; int size = 1;
    // Get concatenated string size
    va_start(va,s);
    for(int i = 0; i < n; i++) {
      char * si = va_arg(va,char *);
      if( si == NULL ) continue;
      size += strlen(si);
    } va_end(va);
    // Concatenate each string
    char * cs = (char *) malloc(size);
    if( cs == NULL ) return NULL;
    va_start(va,s);
    for(int i = 0; i < n; i++) {
      char * si = va_arg(va,char *);
      strcat(cs,si); free(si);
    } va_end(va);
    // Return concatenated string
    return cs;    
  }
