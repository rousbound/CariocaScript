
  // Utilities module interface
  // Guilherme Dantas
  // Felipe Vieira Ferreira

  // Concatenates strings of any size
  // n - number of strings
  // s, ... - dynamically allocated strings
  // > concatenated string, NULL
  // [!] if any of the strings are NULL,
  // they'll be simply ignored.
  // [!] if one of the strings isn't
  // dynamically allocated, it will crash :)
  char * concat(int n, ...);
