# Compiladores

Group:
- [Eduardo F. Assis](@edassis): Análise léxica e sintática;
- [Carlos Gabriel V. N. Soares](@gabuvns): Análise sintática;
- [Maria Julia Dias Lima](@majuhdl): Análise semântica;
- [Oscar E. B. M. Silva](@Oscar2019): Geração de código.

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