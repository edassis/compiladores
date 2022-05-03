// #include "symtab.h"
// #include <iostream>

// void append_new(char const* name, int32_t size, int32_t location, int32_t usado, SymbId type, Symb** head){
// 	struct Symb* newNode = new Symb;
//  	struct Symb *last = *head;
 	
//  	newNode->name = name;
// 	newNode->size = size;
// 	newNode->loc = location;
// 	newNode->usado = usado;
// 	newNode->type = type;
// 	newNode->next = NULL;
 
// 	if (*head == NULL) {
// 		*head = newNode;
// 		return;
// 	}
 
// 	while (last->next != NULL) {
// 		last = last->next;
// 		last->next = newNode;
// 		return;
// 	}
	
// 	return;
// }

// Symb* find(const char* name, Symb** head){
// 	if (head == NULL){
// 		return NULL;
// 	}

// 	if (*head == NULL){
// 		return NULL;
// 	}
 
// 	struct Symb *elem = *head; 
// 	while ((elem->next != NULL)){
// 		if ((elem->name) == name){
// 			return elem;
// 		} else {
// 			elem = elem->next;
// 		}
// 	}
// 	return NULL; 
// }

// int used(const char* name, Symb** head){
// 	if (*head == NULL){
// 		return 0;
// 	}
 
// 	struct Symb *elem = *head; 
// 	while ((elem->next != NULL)){
// 		if ((elem->name) == name){
// 			elem->usado = 1;
// 			return 1;
// 		} else {
// 			elem = elem->next;
// 		}
// 	}
// 	return 0; 
// }

// void printTS(Symb** head){
// 	if (*head == NULL){
// 		printf("Tabela vazia");
// 		return;
// 	}
 
// 	struct Symb *elem = *head; 
// 	while ((elem->next != NULL)){
// 		std::cout<<elem->name;
// 	}
// 	return ; 
// }
