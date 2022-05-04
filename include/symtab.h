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

extern int exist;

extern char* nome;

extern struct Symb* teste;
extern struct Symb* achei;
extern struct Symb* elem;

extern struct Symb** head;

void append_new(char* name, int location, int type, int nivel, Symb** head);
Symb* find(char* name, Symb** head);
void used(char* name, Symb** head);
void printTS(Symb** head);
Symb** cria_lista();

