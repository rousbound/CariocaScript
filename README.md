# Compiler for JFLAP Turing Machine

This final project consists in using the **Flex/Bison (Lex/Yacc)** toolkit to generate compilers that, themselves, will generate code from an imperative language called **Provol-One**, to be executed in a Turing Machine. The TMs are generated according to a XML dialect that will be interpreted by the **JFLAP Java application**. The macros contained in the XML file will work as a sort of runtime system to run the generated code, that can be aimed either for TMs with a single tape or for TMs with multiple tapes - it is totally up to the group to decide. In fact, the goal of this project is to apply the concepts learned on the Lexical and Syntactic Analysis (INF1022) course, lectured by the professor Edward Hermann Haeusler.

*(Free translation from the project statement originally in Portuguese)*

## Sections

- [Getting Started](#getting-started)
  - [Running tests](#running-tests)
- [Code Style Standard](#code-style-standard)
- [Project Information](#project-information)
- [Software Dependecies](#software-dependencies)

## Getting Started

In order to have of the project running on your machine, you must install the **Flex** and **Bison** packages. Also, you might want to install **JDK** in order to run the JFLAP application. For the following installations, you'll be prompted with a y/N question - answer with 'y', for yes.

``` bash
$ sudo yum install flex.x86_64
$ sudo yum install bison.x86_64
$ sudo yum install java-1.8.0-openjdk
```

Then you can easily compile the code by making use of the Makefile on the `src` folder

``` bash
$ cd src
$ make
```

### Running tests

From the repository root, you may run the parser/compiler as follows:

``` bash
$ chmod +x build.sh
$ ./build.sh [file]
```

The argument is optional. If no argument is given, the parser will simply **run all Provol-One scripts** located in the `tests` folder. Alternatively, if the program has been already compiled, you can simply run:

``` bash
$ ./bin/provolone [file]
```

The argument is optional. If no argument is given, the parser will simply read from **stdin**.

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

## Project Information

* [Hermann *(Course Supervisor)*](http://www-di.inf.puc-rio.br/~hermann/)
* [Statement *(in Portuguese)*](https://drive.google.com/file/d/185EW11LlP18a115te7fuPol0oz6TyTKs/view?usp=sharing)

## Software Dependencies

* [JFLAP *(Java Application)*](http://www.jflap.org/jflaptmp/)
