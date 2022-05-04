#include "symtab.h"
#include <cstring>


int exist=0;

char* nome;

struct Symb* teste;
struct Symb* achei;
struct Symb* elem;
struct ExisteVar* usadas;

struct Symb** head = cria_lista();

struct ExisteVar** VarUsadas = cria_lista_var();

void append_new(char* name, int location, int type, int nivel, Symb** head){
	struct Symb* newNode = (struct Symb*)malloc(sizeof(struct Symb));
   /* printf("%s\n", name); */
	if (type == 0) {
		newNode->size = 0;
	}
	if (type == 1) {
		newNode->size = 4;
	}
 	
 	newNode->name = name;
	newNode->loc = location;
	newNode->usado = 0;
	newNode->type = type;
	newNode->nivel = nivel;
	newNode->next = nullptr;
 
	if (*head == nullptr) {
		*head = newNode;
		return;
	} else {
		struct Symb *last = *head;
 		while (last->next != nullptr) {
 			if(strcmp(last->name, name) != 0){
				last = last->next;
			} else {
				printf("Erro Semântico: variável '%s' já existe!\n", last->name);
				return;
			}
		}
		if(strcmp(last->name, name) != 0){
		} else {
			printf("Erro Semântico: variável '%s' já existe!\n", last->name);
			return;
		}
		last->next = newNode;
		return;
	}
}

Symb* find(char* name, Symb** head){
	if (*head == nullptr){
		return nullptr;
	}
 
	struct Symb *elem = *head; 

	while (elem != nullptr){
      /* printf("name = %s\n", name);
      printf("elem->name = %s\n", elem->name); */
		if (strcmp(elem->name, name) == 0){
			return elem;
		} else {
			elem = elem->next;
		}
	}
	return nullptr; 
}

void used(Symb** head, ExisteVar** VarUsadas){
	//exist = 0;

	if (*head == nullptr){
		return;
	}
	
	if (*VarUsadas == nullptr){
		return;
	}
	
	struct Symb *elem = *head; 
	struct ExisteVar *usadas = *VarUsadas;
	while (elem != nullptr){
		while ((usadas != nullptr)){
			if (strcmp(elem->name, usadas->name) == 0){
					elem->usado = 1;
			}
			usadas = usadas->next;
		}
		usadas = *VarUsadas;
		elem = elem->next;
	}
	
	elem = *head;
 	while (elem != nullptr) {
 		if(elem->usado != 1){
 			printf("Erro: Variável %s usada e não declarada.\n", elem->name);
 			return;
 		} else {
 			elem = elem->next;
		}
	}
	
	return;	
}

void printTS(Symb** head){
	if (*head == nullptr){
		printf("Tabela vazia\n");
		return;
	}
 
 	printf("Tabela De Símbolos:\n");
	struct Symb *elem = *head; 
	while ((elem != nullptr)){
		printf("%s\t", elem->name);
		printf("%d\t", elem->size);
		printf("%d\t", elem->loc);
		if (elem->usado == 0)
			printf("não utilizado\t");
		if(elem->usado == 1)
			printf("utilizado\t");
		if (elem->type == 0)
			printf("void\t");
		if(elem->type == 1)
			printf("int\t");
		printf("\n");
		elem = elem->next;
	}
	printf("\n");
	
	//printf("Lista:\n");
	//struct ExisteVar *elem1 = *VarUsadas; 
	//while ((elem1 != nullptr)){
	//	printf("%s\t", elem1->name);
	//	elem1=elem1->next;
	//}
}

Symb** cria_lista(){
  Symb** li=(Symb**) malloc(sizeof(Symb*));
  if(li == nullptr) return 0;
  *li = nullptr;
  return li;
}

ExisteVar** cria_lista_var(){
  ExisteVar** li=(ExisteVar**) malloc(sizeof(ExisteVar*));
  if(li == nullptr) return 0;
  *li = nullptr;
  return li;
}

void var_append(char* name, ExisteVar** VarUsadas){
	struct ExisteVar* newNode = (struct ExisteVar*)malloc(sizeof(struct ExisteVar));
   /* printf("%s\n", name); */
 	newNode->name = name;
	newNode->next = nullptr;
 
	if (*VarUsadas == nullptr) {
		*VarUsadas = newNode;
		return;
	} else {
		struct ExisteVar *last = *VarUsadas;
 		while (last->next != nullptr) {
				last = last->next;
		}

		last->next = newNode;
		return;
	}
}

