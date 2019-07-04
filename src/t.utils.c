
  // Utilities module test
  // Guilherme Dantas

  #include <assert.h>
  #include <stdlib.h>
  #include "utils.h"
  #include "test.h"

  int main( void ) {

    // dynamically allocated strings
    // -- works!
    char * a = (char *) malloc(sizeof(char)*6);
    char * b = (char *) malloc(sizeof(char)*6);
    fatal_assert(a); fatal_assert(b);
    strcpy(a,"algo "); strcpy(b,"assim");
    char * c = concat(a,b);
    fatal_assert(c);
    assert(strcmp(c,"algo assim")==0);
    free(a); free(b); free(c);

    // const strings (not dynamically allocated)
    // -- does not work!
    char * d = concat("do ","tipo");
    fatal_assert(d);
    assert(strcmp(d,"do tipo")!=0);
    free(d);

    // EPSILON TESTS
    char * e = (char *) malloc(sizeof(char)*2);
    char * f = (char *) malloc(sizeof(char)*2);
    fatal_assert(e); fatal_assert(f);
    strcpy(e,"a"); strcpy(f,"");

    // a + epsilon = a
    char * g = concat(e,f);
    fatal_assert(g);
    assert(strcmp(g,e)==0);
    free(g);

    // epsilon + a = a
    g = concat(f,e);
    fatal_assert(g);
    assert(strcmp(g,e)==0);
    free(g);

    // epsilon + epsilon = epsilon
    g = concat(f,f);
    fatal_assert(g);
    assert(strcmp(g,f)==0);
    free(g);

    show_log();
    return 0;
  }
