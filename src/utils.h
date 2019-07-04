
  // Utilities module interface
  // Guilherme Dantas
  // Felipe Vieira Ferreira

  #include <stdarg.h>

  #define concat(...) concatfunc((char *)0,__VA_ARGS__,(char *)0)

  // Concatenates strings of any size
  // ... - non-null strings
  // > concatenated string, NULL
  char * concatfunc(char * dummy, ...);
