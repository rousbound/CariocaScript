# Report

## Shift/Reduce Conflicts

The grammar presented on the project statement is clearly ambiguous.
After formalizing it in Yacc (Bison), 8 SR (shift/reduce) conflicts
were presented:

* Dangling ELSE Problem, known to occurr frequently in
ALGOL-like languages, like C, Pascal, Java, Lua... <sup>(1)</sup>

* Right recursion on cmds and var_list rules, which should
be avoided not only due to the SR conflict it causes, but also
because "it would use up space on the Bison stack in proportion
to the number of elements in the sequence, because all elements
must be shifted onto the stack before the rule can be applied
even once." <sup>(2)</sup>

To solve the last conflict is pretty trivial: simply swapping the
terms turns it into left recursion, which is OK!

But to fix the DEP (Dangling ELSE Problem), there are two main
ways: Either we rewrite the grammar to make it unambiguous, or
use Bison tools to define which rule has more priority over another.
We chose to change the grammar so that every IF statement ends
with an END clause. So we went from this rule:

```
SE STRING ENTAO cmds SENAO cmds
SE STRING ENTAO cmds
```

To the following.

```
SE STRING ENTAO cmds SENAO cmds FIM
SE STRING ENTAO cmds FIM
```

That solves the SR conflict because when the parser cursor is after
'cmds', there are two different shifts: SENAO and FIM.

# Bibliography

1. [Shift/Reduce](https://www.gnu.org/software/bison/manual/html_node/Shift_002fReduce.html)
2. [Recursive Rules](https://www.gnu.org/software/bison/manual/html_node/Recursion.html)
3. [Dangling Else Solution](https://stackoverflow.com/a/12734499)
