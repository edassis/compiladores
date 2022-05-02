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
};

void append_new(char* name, int location, int type, Symb** head);
Symb* find(char* name, Symb** head);
void used(char* name, Symb** head);
void printTS(Symb** head);
Symb** cria_lista();
