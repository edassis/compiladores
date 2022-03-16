/* This block of code will go into the header file generated by bison */
%code requires{
   class Data;
}

/* This block will be put into the cpp source code */
%{
#include <stdio.h>
#include <stdlib.h>
#include "lexer.hpp"
void yyerror(const char *msg);

class Data {
public:
   int data;
   Data() { data = 0; }
   ~Data() {}
};

%}

%union{
  double dval;
  int ival;
  char* string;
  Data* cval;
}

%define parse.error verbose
%locations

%start input
%token TYPE MULT DIV PLUS MINUS EQUAL END
%token <string> ID
%token <dval> NUM
%type <dval> exp
%type <cval> input
%left PLUS MINUS
%left MULT DIV


%% 
input:	    { $$ = new Data(); }
			| input line { $$ = $1; $1->data++; }
			;

line:		exp END               { printf("\t%f\n", $1); }
            | ID END              { printf("\t%s\n", $1); }
			;

exp:		NUM                   { $$ = $1; }
            | MINUS exp           { $$ = -$2; }
			| exp PLUS exp        { $$ = $1 + $3; }
			| exp MINUS exp       { $$ = $1 - $3; }
			| exp MULT exp        { $$ = $1 * $3; }
			| exp DIV exp         { if ($3==0) yyerror("divide by zero"); else $$ = $1 / $3; }
			;
%%

int main(int argc, char **argv) {
   if (argc > 1) {
      yyin = fopen(argv[1], "r");
      if (yyin == NULL){
         printf("syntax: %s filename\n", argv[0]);
      }//end if
   }//end if
   yyparse(); // Calls yylex() for tokens.
   return 0;
}

void yyerror(const char *msg) {
   printf("** Line %d: %s\n", yylloc.first_line, msg);
}
