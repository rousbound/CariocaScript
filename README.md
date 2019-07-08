# Final Project Report

* **Course:** INF1022
* **Semester:** 2019.1
* **Supervisor:** Edward Hermann Haeusler
* **Group members:** *Felipe Vieira Ferreira*, *Guilherme Dantas de Oliveira* & *Roberto Mario Lemos Teran Luna*

## Getting Started

In order to have the project running on your machine, you must install the **Flex** and **Bison** packages. For the following installations, you'll be prompted with a y/N question - answer with 'y', for yes.

``` bash
$ sudo yum install flex.x86_64
$ sudo yum install bison.x86_64
```

## Running tests

From the root, you may run the parser/compiler by first giving execution permition to the `build.sh` shell script, then running it.

``` bash
$ chmod +x build.sh
$ ./build.sh [file]
```

The argument is optional. If no argument is given, the parser will simply **run all Provol-One scripts** located in the `tests` folder. Alternatively, if the program has been already compiled, you can simply run:

``` bash
$ ./bin/provolone [file]
```

The argument is optional. If no argument is given, the parser will simply read from **stdin**.

## Shift/Reduce Conflicts

The grammar presented on the project statement is clearly ambiguous. After formalizing it in Yacc (Bison), 8 SR (shift/reduce) conflicts were presented:

* Dangling ELSE Problem, known for occurring frequently in *ALGOL*-like languages, like *C*, *Pascal*, *Java*, *Lua*... <sup>(1)</sup>

* Right recursion on `cmds` and `var_list` rules, which should be avoided not only due to the SR conflicts caused, but also because "it would use up space on the Bison stack in proportion to the number of elements in the sequence, because all elements must be shifted onto the stack before the rule can be applied even once." <sup>(2)</sup> In other words, the parser does not know when to stop shifting before reducing.

The solution to the last conflict is pretty trivial: simply swapping the terms turns the right recursion into left recursion, which is OK for LALR parsers!

```
cmds: cmd cmds (BEFORE)
cmds: cmds cmd (AFTER)

var_list: var_def var_list (BEFORE)
var_list: var_list var_def (AFTER)
```

But to fix the DEP (Dangling ELSE Problem)<sup>(3)</sup>, there are two main ways: Either we rewrite the grammar to make it unambiguous, or use Bison tools to define which rule has more priority (or as written on Bison documentation, 'precedence') over the other. We chose to change the grammar so that every `SE` clause ends with the `FIM` token, just like every `ENQUANTO` and `FACA` clause. So we went from this rule:

```
SE STRING ENTAO cmds SENAO cmds
SE STRING ENTAO cmds
```

To the following:

```
SE STRING ENTAO cmds SENAO cmds FIM
SE STRING ENTAO cmds FIM
```

That solves the later SR conflict because when the parser cursor is after 'cmds', there are two different shifts: `SENAO` and `FIM`. Thus, having two different tokens to shift resolves the conflict.

## Code Generation

Since JFLAP Multi-Tape Turing Machine has the limit of **five tapes**, our program will be limited to having a maximum of four variables (input and output) - one tape for each. The remaining tape will be used to store the counter for the `FACA` loops.

Thankfully, Hermann has provided the Turing Machines for each operation used in the Provol-One language. They are described by a XML file with the `.jff` extension.

Each command will correspond to a **Building Block**, that always contains one initial state and one final state (that, differently from the main final state, will not interrupt the TM - but instead, will exit the Building Block scope). This JFLAP artifact helps us build the Turing Machine by recycling code!<sup>(4)</sup>

In the XML, the building blocks are specified with the `<block>` tab. And inside these, `<tag>id</tag>` will specify the block tag. Later on, the block will be declared as `<id>...</id>` on the same scope as the `<block>` tag.<sup>(5)</sup>

That way, we can define each command at the end of the program and simply call the building block whenever a command is found. But the real challenge will be to deal with loop commands like `ENQUANTO` and `FACA`, since they will deal with more than one value on the last tape.

## Symbol Table

Since the Turing Machine will be able to handle only up to 4 variables, *the symbol table will also hold up to 4 symbols*. The algorithm works as follows: every time the lexer parses the regular expression for `id`, it will look for a symbol of same string on the symbol table. If found, its index in the symbol table is returned. If not, it checks whether there is room for a new symbol definition (`#syms < 4`) and if the rule the parser is currently on accepts a new symbol definition (e.g. after `ENTRADA` and `SAIDA` tokens).

If not (full symbol table or if symbol is in the middle of the code - thus, not initialized), a compilation error is thrown by the `yyerror` bison routine<sup>(6)</sup> and the program is interrupted. Else, the new symbol table entry is registered, the `#syms` counter is incremented by the parser, and the new symbol index is returned.

Also, to avoid memory leak, a routine has to be called after `yyparse` to free the allocated symbols on the symbol table. It is called on the `main` function on the parser, imported from the lexer.

## Intermediate Code

As advised by Hermann, an intermediate code between *Provol-One* and *JFLAP XML dialect* might help structure the output painlessly. Thought of as a less abstract language, this intermediate code describes what the *JFLAP Turing Machine* should do in relation to its tapes and its current state in the *DFA* (*deterministic finite automata*).

We've decided to output this code as pairs of (state,command). The command might have a `goto` statement, which will work much like a transition to the state it points to. If no such redirection is specified, the normal flow will prevail (that is, set current state to next line's state and execute its command). The program ends when it arrives at the last state of the program (of higher index, and also, in the last line of the intermediate code).

# Bibliography

1. [Shift/Reduce](https://www.gnu.org/software/bison/manual/html_node/Shift_002fReduce.html)
2. [Recursive Rules](https://www.gnu.org/software/bison/manual/html_node/Recursion.html)
3. [Dangling Else Solution](https://stackoverflow.com/a/12734499)
4. [JFLAP TM Building Blocks](http://www.jflap.org/tutorial/turing/buildingblocks/buildingblocks.htm)
5. [JFLAP TM Building Blocks Examples](http://www.jflap.org/jflapfiles/TMBBexamples/)
6. [Error Reporting in Bison](https://www.gnu.org/software/bison/manual/html_node/Error-Reporting.html)
