
  // Utilities module interface
  // Guilherme Dantas

#ifndef UTILS_H
#define UTILS_H

  #include "colours.h"

  // Indicates an error through stderr output
  // err_msg_format - format, just like in printf
  // ... - arguments, just like in printf
  // > EXIT_FAILURE
  int fatal_error (const char * err_msg_format, ...);

  // Prints message to screen properly formatted and coloured
  // tag - message header that will appear in between brackets
  // color - see colours.h
  // msg, ... - format string and parameters like printf
  // > (to stdout) message
  void printc(const char * tag, const char * color, const char * msg, ...);

#endif
