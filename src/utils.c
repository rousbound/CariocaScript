
  // Utilities module
  // Guilherme Dantas

  #include <stdio.h>
  #include <stdlib.h>
  #include <stdarg.h>
  #include "utils.h"
  #include "colours.h"

  /**********************/
  /* Exported functions */
  /**********************/

  int fatal_error (const char * err_msg_format, ...)
  {
    va_list vl;
    va_start(vl, err_msg_format);
    fprintf(stderr, "\033[1;31m");
    vfprintf(stderr,err_msg_format, vl);
    fprintf(stderr, "\033[0m");
    va_end(vl);
    return EXIT_FAILURE;
  }
  
  void printc(const char * tag, const char * color, const char * msg, ...)
  {
    printf(DEFAULT_COLOUR); printf("[");
    printf(color);          printf(tag);
    printf(DEFAULT_COLOUR); printf("] ");
    va_list vl;
    va_start(vl, msg);
    vfprintf(stdout,msg,vl);
    va_end(vl);
  }
