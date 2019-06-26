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

To solve the last is pretty trivial: simply swapping the terms
turns it into left recursion, which is OK!

But the DEP (Dangling ELSE Problem) cannot be easily fixed. We
could rewrite the grammar to make it unambiguous, bit in this
case, it wouldn't be that simple. Gladly, Bison provides us with
the tools to define which rule has more priority over another.

```
%right ENTAO SENAO
```

What the code does is give the same precedence, but shifting
the token SENAO wins, because it is making it right-associative.
That way the parser will always try to identify the innermost
if-statement, in a way that the following are equal:

```
SE X ENTAO SE Y ENTAO A SENAO B
```

```
SE X ENTAO
  SE Y ENTAO A
  SENAO B
```

# Bibliography

1. [Shift/Reduce](https://www.gnu.org/software/bison/manual/html_node/Shift_002fReduce.html)
2. [Recursive Rules](https://www.gnu.org/software/bison/manual/html_node/Recursion.html)
3. [Dangling Else Solution](https://stackoverflow.com/a/12734499)
