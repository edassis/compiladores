#pragma once
#include <cstdint>
#include <string>
#include <map>
#include <vector>

enum SymbId{
    NONE,
    FN,
    VAR,
};


struct Symb{
    char* name;
    int32_t size;
    int32_t loc;
    int32_t usado;
    int type;
    struct Symb *next;
    int32_t nivel;
};

struct ExisteVar{
    char* name;
    struct ExisteVar *next;
};

extern int exist;

extern char* nome;

extern struct Symb* teste;
extern struct Symb* achei;
extern struct Symb* elem;
extern struct ExisteVar* usadas;

extern struct Symb** head;
extern struct ExisteVar** VarUsadas;

void append_new(char* name, int location, int type, int nivel, Symb** head);
Symb* find(char* name, Symb** head);
void used(Symb** head, ExisteVar** VarUsadas);
void printTS(Symb** head);
Symb** cria_lista();
ExisteVar** cria_lista_var();
void var_append(char*name, ExisteVar** VarUsadas);
