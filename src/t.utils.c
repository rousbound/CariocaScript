
  // Utilities module test
  // Guilherme Dantas
  
  #include <assert.h>
  #include <stdlib.h>
  #include "utils.h"
  
  int main( void ) {
    char * a = (char *) malloc(16);
    char * b = (char *) malloc(16);
    strcpy(a,"algo ");
    strcpy(b,"assim");
    char * c = concat(2,a,b);
    assert(strcmp(c,"algo assim")==0);
    return 0;
  }
