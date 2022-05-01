%{
#include <string>
#include "parser.hpp"
#include "globals.h"
#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno;
%}
  /* Definition */

/* Read only one file as input */
%option noyywrap

/* TYPE                        "int"|"float"|"void" */
ID                          [[:alpha:]_][[:alnum:]_]*
NUM                         [[:digit:]]+(\.[[:digit:]]*)?
STRCON                      \"[[:alnum:]]*\"

newline                     \n
whitespace                  [ \t]

%%
  /* Rules */
"(*"                        {
                              int c1 = 0, c2 = 0;
                              while(true) { 
                                c2 = c1;
                                c1 = yyinput();
                                if(c1 == 0 || (c2 == '*' && c1 == ')')) break;
                                if(c1 == '\n') lineno++;
                              }
                            }
"-"                         { return MINUS; }
"+"                         { return PLUS; }
"*"                         { return MUL; }
"/"                         { return DIV; }

"="                         { return ASSIGN; }

"=="                        { return EQ; }
"!="                        { return NEQ; }
"<"                         { return LT; }
"<="                        { return LTE; }
">"                         { return GT; }
">="                        { return GTE; }

"&&"                        { return AND; }
"||"                        { return OR; }

"!"                         { return NOT; }

"ler"                       { return LER; }
"escrever"                  { return ESCREVER; }

"if"                        { return IF; }
"else"                      { return ELSE; }
"return"                    { return RET; }
"for"                       { return FOR; }
"while"                     { return WHILE; }

"int"                       { return INT; }
"float"                     { return FLOAT; }
"void"                      { return VOID; }

"("                         { return LPAREN; }
")"                         { return RPAREN; }
"["                         { return LBRACK; }
"]"                         { return RBRACK; }
"{"                         { return LBRACE; }
"}"                         { return RBRACE; }
";"                         { return SEMI; }
","                         { return COMMA; }

 /* {TYPE}                      { yylval.text = yytext; return TYPE; } */
{ID}                        { yylval.text = yytext; return ID; }
{NUM}                       { yylval.dval = atof(yytext); return NUM; }
{STRCON}                    { yylval.text = yytext; return STRCON; }
{newline}                   { lineno++; }
{whitespace}                /* skip whitespace */
.                           {
                              std::string s = "unrecognized symbol " + std::string(yytext); 
                              yyerror(s.data());
                              exit(0);
                            }

%%
  /* User code */
