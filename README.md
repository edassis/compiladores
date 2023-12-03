# Compiladores

A prototype compiler that outputs an intermediate code for the 'TM' VM.

Group:
- [Eduardo F. Assis](https://github.com/edassis): Lexical and syntactic analysis;
- [Carlos Gabriel V. N. Soares](https://github.com/gabuvns): Syntactic analysis;
- [Maria Julia Dias Lima](https://github.com/majuhdl): Semantic analysis;
- [Oscar E. B. M. Silva](https://github.com/Oscar2019): Code generation.

## Build

```
./run.sh
```

If it doesn't work, ensure file's execute privileges:
```
chmod u+x run.sh
```

Clean bin files with: 
```
rm -r build a
```

## Run

```
./a tests/<chose one>
```

Like:
```
./a tests/teste.txt
```

Will be generated an output file containing the assembly of the
compiled code: `out.tm`

## Dependencies
- GCC 7.3;
- CMAKE 3.16.3;
- GNU Make 4.2.1;
- Flex 2.6.4;
- Bison 3.5.1;
