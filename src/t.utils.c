
  // Utilities module test
  // Guilherme Dantas

  #include <assert.h>
  #include <stdlib.h>
  #include "utils.h"
  #include "test.h"

  int main( void ) {

    // dynamically allocated strings
    // -- works!
    char * a = (char *) malloc(6);
    char * b = (char *) malloc(6);
    fatal_assert(a); fatal_assert(b);
    strcpy(a,"algo ");
    strcpy(b,"assim");
    char * c = concat(a,b);
    fatal_assert(c);
    assert(strcmp(c,"algo assim")==0);
    free(a); free(b); free(c);

    // const strings (not dynamically allocated)
    // -- does not work!
    char * f = concat("do ","tipo");
    fatal_assert(f);
    assert(strcmp(f,"do tipo")!=0);
    free(f);

    show_log();
    return 0;
  }
