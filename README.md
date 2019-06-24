# Final Project for Lexical and Syntactic Analysis

This final project consists in using the **Flex/Bison (Lex/Yacc)** toolkit to generate compilers that,
themselves, will generate code from an imperative language called **Provol-One**, to be executed in a Turing
Machine. The TMs are generated according to a XML dialect that will be interpreted by the **JFLAP Java
application**. The macros contained in the XML file will work as a sort of runtime system to run the
generated code, that can be aimed either for TMs with a single tape or for TMs with multiple tapes - it
is totally up to the group to decide. In fact, the goal of this project is to apply the concepts learned
on the INF1022 course, lectured by the professor Edward Hermann Haeusler.

*(Free translation from the project statement originally in Portuguese)*

## Code Style Standard


* Indent with 2 spaces (configurable on text editor)
* Underscores may be added to improve readability
* Function and variables names should be lower case

``` c
double get_circumference (double radius);
```

* Constants names should be upper case

``` c
#define PI 3.1415f
// or
double PI = 3.1415;
```

* Open code blocks on the following line

``` c
if( get_circumference(radius) == 0 )
{
  exit(1);
}
```

* One-liners are allowed if to improve conciseness

``` c
if( get_circumference(radius) == 0 ) exit(1);
```

* Document functions as follow

``` c
// Opens file for read only access
// file_name - file relative path
// > file pointer, NULL
// [!] if an error occurs, file will not
// be opened and NULL will be returned
FILE * read_file (const char * file_name);
```

## Links

* [Hermann](http://www-di.inf.puc-rio.br/~hermann/)
* [Project statement](http://www.tecmf.inf.puc-rio.br/INF1022?action=AttachFile&do=get&target=ProjetoFinal.pdf)
* [JFLAP](http://www.jflap.org/)
* [Java](https://www.java.com/pt_BR/download/)
* [Flex/Bison](https://aquamentus.com/flex_bison.html)
