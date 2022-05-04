/* This block of code will go into the header file generated by bison */
%code requires{
   #include "symtab.h"
   #include <vector>
   #include <set>
   #include <map>
   #include <string>
   struct AsmLine{
      int line;
      std::string opCode;
      int type;
      int arg1;
      int arg2;
      int arg3;
   };
   extern std::vector<AsmLine> code;
   struct RegOrTmp{
      int num; // reg num
      std::string tmp_var_name; // tmp address
   };
}

/* This block will be put into the cpp source code */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <stack>
#include <vector>
#include "lexer.hpp"
#include "symtab.h"
#include "parser.hpp"
#include "globals.h"
#include <set>
#include <list>
#include <map>


std::stack<int> codeSizeStack;
std::stack<int> conditionArg;

int zr_reg = 0;
std::set<int> registers_libre{1, 2, 3, 4, 5};
std::list<RegOrTmp*> registers_used;
int sp_reg = 6;
int pc_reg = 7;
std::vector<AsmLine> code;
int value = 0;
int last_tmp_var = 0;
int level = 0;

int localVarBytes = 0;


bool isInFunction(){
   return level != 0;
}

void write_code_1(std::string name, int r, int s, int t){
   code.push_back(AsmLine{(int)code.size(), name, 1, r, s, t});
   // code.push_back(std::to_string(code.size()) + ": " + name + " " + std::to_string(r) + ", " + std::to_string(s) + ", " + std::to_string(t) + "\n");
}

void write_code_2(std::string name, int r, int d, int s){
   code.push_back(AsmLine{(int)code.size(), name, 2, r, d, s});
   // code.push_back(std::to_string(code.size()) + ": " + name + " " + std::to_string(r) + ", " + std::to_string(d) + "(" + std::to_string(t) + ")\n");
}


void removeLevel(int num){
   Symb *no = *head;
   std::stack<Symb*> noStack;
   while(no != nullptr){
      noStack.push(no);
      no = no->next;
   }
   while(!noStack.empty() && noStack.top()->nivel == num){
      free(noStack.top());
      noStack.pop();
      localVarBytes -= 1;
      write_code_2("LDC", zr_reg, 1, zr_reg);
      write_code_1("SUB", 6, 6, zr_reg);
      write_code_2("LDC", zr_reg, 0, zr_reg);
   }
   if(noStack.empty()){
      *head = nullptr;
   } else{
      noStack.top()->next = nullptr;
   }
}

void deleteUsados(){
   Symb *no = *head;
   std::stack<Symb*> noStack;
   while(no != nullptr){
      noStack.push(no);
      printf("name = %s\n", no->name);
      no = no->next;
   }
   while(!noStack.empty() && noStack.top()->usado == 1){
      free(noStack.top());
      noStack.pop();
      localVarBytes -= 1;
      write_code_2("LDC", zr_reg, 1, zr_reg);
      write_code_1("SUB", 6, 6, zr_reg);
      write_code_2("LDC", zr_reg, 0, zr_reg);
   }
   if(noStack.empty()){
      *head = nullptr;
   } else{
      noStack.top()->next = nullptr;
   }
}

void removeRegOrTmp(RegOrTmp* val){
   if(val->num < 0){
      find(strdup(val->tmp_var_name.c_str()), head)->usado = 1;
      deleteUsados();
      delete val;
   } else{
      auto aux = find(strdup(val->tmp_var_name.c_str()), head);
      if(aux != nullptr){
         aux->usado = 1;
      }
      if(0 < val->num && val->num < 6){
         int reg_orig = val->num;
         registers_used.remove_if([val](RegOrTmp* regTmp){
            return regTmp == val;
         });
         registers_libre.insert(reg_orig);
         delete val;
      }
      deleteUsados();
   }
}
int getRegNumfromRegOrTmp(RegOrTmp* val){
   int reg_orig = 0;
   if(val->num < 0){
      if(registers_used.size() < 0){

         int reg_dest = registers_used.front()->num;
         registers_used.front()->num = -1; 
         registers_used.front()->tmp_var_name = "$" + std::to_string(last_tmp_var);
         last_tmp_var++;
         printf("%s\n", registers_used.front()->tmp_var_name.c_str());
         
         append_new(strdup(registers_used.front()->tmp_var_name.c_str()), localVarBytes, 1, level, head); 

         write_code_2("LDC", 0, 1, zr_reg);
         write_code_1("ADD", sp_reg, sp_reg, zr_reg);
         write_code_2("LDC", 0, 0, zr_reg);
         localVarBytes += 1;
         write_code_2("ST", reg_dest, -1, sp_reg);
         
         registers_used.pop_front();

         reg_orig = val->num = reg_dest;

         auto aux = find(strdup(val->tmp_var_name.c_str()), head);
         if(aux != nullptr){
            aux->usado = 1;
         }
         write_code_2("LD", reg_orig, aux->loc - localVarBytes, sp_reg);
         
         deleteUsados();
   
         registers_used.push_back(val);
      } else{
            
         auto reg_lib = registers_libre.begin();
         int reg_dest = *reg_lib;

         registers_libre.erase(reg_lib);
         registers_used.push_back(val);

         reg_orig = val->num = reg_dest;
         
         auto aux = find(strdup(val->tmp_var_name.c_str()), head);
         if(aux != nullptr){
            aux->usado = 1;
         }
         write_code_2("LD", reg_orig, aux->loc - localVarBytes, sp_reg);
         
         deleteUsados();

         val->tmp_var_name = "";
      }
   } else{
      reg_orig = val->num;
   }
   return reg_orig;
}

RegOrTmp* getRegOrTmp(){ 
   RegOrTmp* res = nullptr;
   auto reg_lib = registers_libre.begin();
   if(reg_lib != registers_libre.end()){
      
      int reg_dest = *reg_lib;

      registers_libre.erase(reg_lib);
      res = new RegOrTmp;
      registers_used.push_back(res);

      res->num = reg_dest;
      res->tmp_var_name = "";
   } else{
      int reg_dest = registers_used.front()->num;
      registers_used.front()->num = -1;
      registers_used.front()->tmp_var_name = "$" + std::to_string(last_tmp_var);
      last_tmp_var++;
      
      append_new(strdup(registers_used.front()->tmp_var_name.c_str()), localVarBytes, 1, level, head); 

      write_code_2("LDC", 0, 1, zr_reg);
      write_code_1("ADD", sp_reg, sp_reg, zr_reg);
      write_code_2("LDC", 0, 0, zr_reg);
      localVarBytes += 1;
      write_code_2("ST", reg_dest, -1, sp_reg);
      // simbleTableSize++;
      
      registers_used.pop_front();
      
      res = new RegOrTmp;
      registers_used.push_back(res);

      res->num = reg_dest;
      res->tmp_var_name = "";
   }
   return res;
}

%}
// #################end of code block############################# /

%union{
   double dval;
   int ival;
   char* text;
   RegOrTmp *reg_tmp;
}

%define parse.error verbose
%locations

%start program

%token MUL DIV PLUS MINUS 
%token ASSIGN
%token EQ NEQ LT LTE GT GTE
%token NOT
%token LER ESCREVER
%token IF ELSE RET FOR WHILE
%token INT FLOAT VOID
%token LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE SEMI COMMA
%token <text> ID
%token <dval> NUM
%token <text> STRCON

%type <ival> type_spec var_decl relop
%type <reg_tmp> expr unary_expr simple_expr term factor read_func func write_func

%% 
program: stmt_list                            {}
         ;

stmt_list:  %empty
            | stmt_list stmt
            | error              { yyerrok; }
            ;

decl_stmt:  decl SEMI
            ;

decl:       var_decl
            ;

var_decl:   type_spec ID                    { 
   // printf("ID = %s\n", $2);
   if($1 == 1){
      write_code_2("LDC", 0, 1, zr_reg);
      write_code_1("ADD", 6, 6, zr_reg);
      write_code_2("LDC", 0, 0, zr_reg);
      append_new($2, localVarBytes, $1, level, head);   
      $$ = localVarBytes;
      localVarBytes += 1;
   }
   
   var_append($2, VarUsadas);
}
            ;


stmt:   decl_stmt                               {}
        | assign_stmt                           {}
        | func_stmt                             {}
        | selection_stmt                        {}
        | iteration_stmt                        {}
        | return_stmt                           {}
        ;



func_stmt:  func SEMI {
   if($1 != nullptr){
      removeRegOrTmp($1);
   }
}
            ;

func:  write_func {
   $$ = $1;
}   | read_func {
   $$ = $1;
}
   ;


write_func: ESCREVER LPAREN expr RPAREN     { 
   $$ = nullptr;
   // printf("\t%f\n", $3); 
   write_code_1("OUT", $3->num, zr_reg, zr_reg);

   removeRegOrTmp($3);
}
            ;

read_func:  LER LPAREN RPAREN               {
   auto regTmp = getRegOrTmp(); 
   int reg_dest = regTmp->num;
   $$ = regTmp;
   
   write_code_1("IN", reg_dest, 0, 0);
}
            | LER LPAREN VOID RPAREN        {
   auto regTmp = getRegOrTmp(); 
   int reg_dest = regTmp->num;
   $$ = regTmp;
   
   write_code_1("IN", reg_dest, 0, 0);
}
            ;

assign_stmt:    assign SEMI         {
   // printf("atribuicao stmt\n");
}
                ;


assign: ID ASSIGN expr              {
   // printf("atribuicao 1\n");
   int reg_orig = getRegNumfromRegOrTmp($3);
   auto var_data = find($1, head);

   write_code_2("ST", reg_orig, var_data->loc - localVarBytes, sp_reg);
   
   removeRegOrTmp($3);
   
   var_append($1, VarUsadas);
}
        | var_decl ASSIGN expr      { 
   // printf("atribuicao 2\n");
   
   int reg_orig = getRegNumfromRegOrTmp($3);

   write_code_2("ST", reg_orig, $1 - localVarBytes, sp_reg);
   
   removeRegOrTmp($3);

}
        | ID ASSIGN func            {
   // printf("atribuicao funcao 1\n");
   if($3 != nullptr){
      int reg_orig = getRegNumfromRegOrTmp($3);
      auto var_data = find($1, head);

      write_code_2("ST", reg_orig, var_data->loc - localVarBytes, sp_reg);
      
      removeRegOrTmp($3);
   }
}
        | var_decl ASSIGN func      {
   // printf("atribuicao funcao 2\n");
   if($3 != nullptr){
   
      int reg_orig = getRegNumfromRegOrTmp($3);

      write_code_2("ST", reg_orig, $1 - localVarBytes, sp_reg);
      
      removeRegOrTmp($3);
   }
}
        ;


if_init:  IF {
   level++;
} LPAREN expr RPAREN {
   int num_reg_1 = getRegNumfromRegOrTmp($4);
   conditionArg.push(code.size());
   write_code_2("JEQ", num_reg_1, 0, pc_reg);
   removeRegOrTmp($4);
}LBRACE stmt_list RBRACE
         ;

selection_stmt: if_init  {
   removeLevel(level);
   level--; 
   code[conditionArg.top()].arg2 = code.size() - conditionArg.top() - 1;
   conditionArg.pop();
}
                | if_init ELSE {
   int aux = conditionArg.top();
   conditionArg.pop();

   conditionArg.push(code.size());
   write_code_2("JEQ", zr_reg, 0, pc_reg);
   removeLevel(level);
   level--; 
   level++;
   code[aux].arg2 = code.size() - aux - 1;
} LBRACE stmt_list RBRACE        {
   // printf("if/else\n");
   removeLevel(level);
   level--; 
   code[conditionArg.top()].arg2 = code.size() - conditionArg.top() - 1;
   conditionArg.pop();
}  
                ;


iteration_stmt: WHILE {
   level++;
   codeSizeStack.push(code.size());
} LPAREN expr RPAREN{
   int num_reg_1 = getRegNumfromRegOrTmp($4);
   conditionArg.push(code.size());
   write_code_2("JEQ", num_reg_1, 0, pc_reg);
   removeRegOrTmp($4);
} LBRACE stmt_list RBRACE                                    {
   // printf("while\n");
   removeLevel(level);
   level--; 
   write_code_2("JEQ", zr_reg, codeSizeStack.top() - code.size() - 1, pc_reg);
   codeSizeStack.pop();
   code[conditionArg.top()].arg2 = code.size() - conditionArg.top() - 1;
   conditionArg.pop();
}
                | FOR {
   level++;
} LPAREN assign {
   codeSizeStack.push(code.size()); // 4 <-
} SEMI expr {
   int num_reg_1 = getRegNumfromRegOrTmp($7);
   conditionArg.push(code.size());
   write_code_2("JEQ", num_reg_1, 0, pc_reg); // 1 ->
   removeRegOrTmp($7);
   conditionArg.push(code.size());
   write_code_2("JEQ", zr_reg, 0, pc_reg); // 2 ->
   codeSizeStack.push(code.size()); // 3 <-
} SEMI assign{
   int aux = codeSizeStack.top();
   codeSizeStack.pop();
   write_code_2("JEQ", zr_reg, codeSizeStack.top() - code.size() - 1, pc_reg); // 4 ->
   codeSizeStack.pop();
   codeSizeStack.push(aux);
   code[conditionArg.top()].arg2 = code.size() - conditionArg.top() - 1; // 2 <-
   conditionArg.pop();
} RPAREN LBRACE stmt_list RBRACE            {
   // printf("for\n");
   removeLevel(level);
   level--; 
   write_code_2("JEQ", zr_reg, codeSizeStack.top() - code.size() - 1, pc_reg); // 3 ->
   codeSizeStack.pop();
   code[conditionArg.top()].arg2 = code.size() - conditionArg.top() - 1; // 1 <-
   conditionArg.pop();
}
                ;


return_stmt:    RET SEMI                    {
   // printf("return\n");
}
                | RET expr SEMI             {
   // printf("return value\n");
}
                ;


expr:   unary_expr relop unary_expr       {
   // printf("logical_expr RELOP logical_expr\n");
   int num_reg_1 = getRegNumfromRegOrTmp($1);
   int num_reg_2 = getRegNumfromRegOrTmp($3);
   write_code_1("SUB", num_reg_1, num_reg_1, num_reg_2);
   write_code_2("LDC", zr_reg, 1, 0);
   if($2 == 0){
      write_code_2("JEQ", num_reg_1, 1, pc_reg);
   } else if($2 == 1){
      write_code_2("JNE", num_reg_1, 1, pc_reg);
   } else if($2 == 2){
      write_code_2("JLT", num_reg_1, 1, pc_reg);
   } else if($2 == 3){
      write_code_2("JLE", num_reg_1, 1, pc_reg);
   } else if($2 == 4){
      write_code_2("JGT", num_reg_1, 1, pc_reg);
   } else if($2 == 5){
      write_code_2("JGE", num_reg_1, 1, pc_reg);
   }
   write_code_2("LDC", zr_reg, 0, 0);
   write_code_2("LDA", num_reg_1, 0, zr_reg);
   write_code_2("LDC", zr_reg, 0, 0);
   removeRegOrTmp($3);
   $$ = $1;
}
        /* | expr binop expr           {printf("expr binop exprn\n");} */
        /* | expr logical_op expr      {printf("expr logical_op expr\n");} */
        /* | expr relop expr           {printf("expr relop expr\n");} */
        | unary_expr                        {
   // printf("logical_expr\n");
   $$ = $1;
}
        ;

unary_expr: NOT simple_expr                     {
   // printf("NOT simple_expr\n");
   int num_reg_1 = getRegNumfromRegOrTmp($2);
   write_code_1("SUB", num_reg_1, zr_reg, num_reg_1);
   $$ = $2;
}
            | simple_expr                       {
   // printf("simple_expr\n");
   $$ = $1;
}
            ;

simple_expr:    simple_expr PLUS term           {
   // printf("simple_expr PLUS term\n");

   int num_reg_1 = getRegNumfromRegOrTmp($1);
   int num_reg_2 = getRegNumfromRegOrTmp($3);
   write_code_1("ADD", num_reg_1, num_reg_1, num_reg_2);
   removeRegOrTmp($3);
   $$ = $1;
}
                | simple_expr MINUS term        {
   // printf("simple_expr MINUS term\n");
   int num_reg_1 = getRegNumfromRegOrTmp($1);
   int num_reg_2 = getRegNumfromRegOrTmp($3);
   write_code_1("SUB", num_reg_1, num_reg_1, num_reg_2);
   removeRegOrTmp($3);
   $$ = $1;
}
                | term                          {
   // printf("term\n");
   $$ = $1;
}
                ;

term:   term MUL factor                         {
   // printf("term MUL factor\n");

   // printf("livres_qtd = %d\n", registers_libre.size());
   // printf("used_qtd = %d\n", registers_used.size());
   int num_reg_1 = getRegNumfromRegOrTmp($1);
   int num_reg_2 = getRegNumfromRegOrTmp($3);
   write_code_1("MUL", num_reg_1, num_reg_1, num_reg_2);
   removeRegOrTmp($3);
   $$ = $1;
}
        | term DIV factor                       {
   // printf("term DIV factor\n");
   int num_reg_1 = getRegNumfromRegOrTmp($1);
   int num_reg_2 = getRegNumfromRegOrTmp($3);
   write_code_1("DIV", num_reg_1, num_reg_1, num_reg_2);
   removeRegOrTmp($3);
   $$ = $1;
}
        | factor                                {
   $$ = $1;
}
        ;

factor: LPAREN expr RPAREN                      {
   // printf("(expr)\n");
   $$ = $2;
}
        | NUM                                   {
   // printf("num\n");
   auto regTmp = getRegOrTmp(); 
   int reg_dest = regTmp->num;
   $$ = regTmp;
   
   write_code_2("LDC", reg_dest, $1, zr_reg);
}
        | ID                                    {
   // printf("id\n");

   auto regTmp = getRegOrTmp(); 
   int reg_dest = regTmp->num;
   $$ = regTmp;
   auto var_data = find($1, head);
   // printf("%p\n", var_data);

   write_code_2("LD", reg_dest, var_data->loc - localVarBytes, sp_reg);
}
        ;

relop    :  EQ {
   $$ = 0;
}
         | NEQ {
   $$ = 1;
}
         | LT {
   $$ = 2;
}
         | LTE {
   $$ = 3;
}
         | GT {
   $$ = 4;
}
         | GTE {
   $$ = 5;
}
         ;


type_spec:  INT {
   $$ = 1;
}
            /* | FLOAT {
               $$ = 2
            } */
            | VOID {
   $$ = 0;
}
            ;

%%

int lineno = 0;

bool debug = false;

void writeAsm();

int main(int argc, char **argv) {
   if (argc > 1) {
      yyin = fopen(argv[argc-1], "r");
      if (yyin == NULL){
         printf("Error opening file: %s\n", argv[argc-1]);
      }

      for(int i = 1; i < argc; i++) {
         if(std::string(argv[i]).find("-d") != std::string::npos) {
            debug = true;
            break;
         }
      }
   }

   yyparse(); // Calls yylex() for tokens.
   
   used(head, VarUsadas);
   printTS(head);

   writeAsm();
    
   fclose(yyin);
   yylex_destroy();
   return 0;
}

void yyerror(const char *msg) {
   printf("** Line %d: %s\n", lineno, msg);
}


void writeAsm() {
   write_code_1("HALT",0,0,0);   // End program execution

   std::string res;
   for(auto v : code){
      if(v.type == 1){
         res += std::to_string(v.line) + ": " + v.opCode + " " + std::to_string(v.arg1) + ", " + std::to_string(v.arg2) + ", " + std::to_string(v.arg3) + "\n";
      } else{
         res += std::to_string(v.line) + ": " + v.opCode + " " + std::to_string(v.arg1) + ", " + std::to_string(v.arg2) + "(" + std::to_string(v.arg3) + ")\n";
      }
   }
   printf("%s\n", res.c_str());
}
