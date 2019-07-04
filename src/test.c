
  // Test module implementation
  // Guilherme Dantas

  #include <stdio.h>
  #include <string.h>
  #include <assert.h>
  #include <stdarg.h>
  #include "test.h"

  /********************/
  /* Global variables */
  /********************/

  int n_tests = 0;   // Number of asserts
  int n_failed = 0;  // Number of failed asserts

  /*********************/
  /* Private functions */
  /*********************/

  static void printcolor(const char * tag, const char * color, const char * msg);
  static void printerror(const char * msg);
  static void printsuccess(const char * msg);

  /**********************/
  /* Exported functions */
  /**********************/

  void abort_test(int boolean, const char * label, const line)
  {
    if (boolean) return;
    assertcolor(boolean,label,line);
    printerror("The program will be aborted due to a fatal error.");
    show_log();
    exit(1);
  }

  void show_log()
  {
    char msg[256];
    sprintf(msg,"%d asserts",n_tests);
    printcolor("LOG",YELLOW,msg);
    if( n_failed == 0 ) sprintf(msg,"No errors found");
    else sprintf(msg,"%d error%s found",n_failed,n_failed==1?"":"s");
    printcolor("LOG",YELLOW,msg);
  }

  void assertcolor(int boolean, const char * label, const line)
  {
    if(boolean)
    {
      printsuccess(label);
    }
    else
    {
      char msg[256] = "";
      char line_s[8] = "";
      strcpy(msg,label);
      strcat(msg," failed at line ");
      sprintf(line_s,"%d.",line);
      strcat(msg,line_s);
      printerror(msg);
    }
    n_tests++;
  }

  /************************************/
  /* Private functions implementation */
  /************************************/

  static void printcolor(const char * tag, const char * color, const char * msg)
  {
    printf(DEFAULT_COLOUR);  printf("[");
    printf(color);          printf(tag);
    printf(DEFAULT_COLOUR);  printf("] %s\n",msg);
  }

  static void printerror(const char * msg)
  {
    printcolor("ERROR",RED,msg);
    n_failed++;
  }

  static void printsuccess(const char * msg)
  {
    printcolor("SUCCESS",GREEN,msg);
  }
