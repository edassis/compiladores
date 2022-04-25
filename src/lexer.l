%{
#include <string>
#include "parser.hpp"
#include "globals.h"
#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno;
%}
  /* Definition */

/* Read only one file as input */
%option noyywrap

TYPE                        "int"|"float"
ID                          [[:alpha:]_][[:alnum:]_]*
NUM                         [[:digit:]]+(\.[[:digit:]]*)?

LPAREN                      \(
RPAREN                      \)
newline                     \n
whitespace                  [ \t]

%%
  /* Rules */
"-"                         { return MINUS; }
"+"                         { return PLUS; }
"*"                         { return MULT; }
"/"                         { return DIV; }
"="                         { return EQUAL; }
";"                         { return SEMI; }
"escreva"                   { return ESCREVA; }
{TYPE}                      { yylval.text = yytext; return TYPE; }
{ID}                        { yylval.text = yytext; return ID; }
{NUM}                       { yylval.dval = atof(yytext); return NUM; }
{LPAREN}                    { return LPAREN; }
{RPAREN}                    { return RPAREN; }
{newline}                   { lineno++; }
{whitespace}                /* skip whitespace */
"(*"                        {
                              int c1 = 0, c2 = 0;
                              while(true) { 
                                c2 = c1;
                                c1 = yyinput();
                                if(c1 == 0 || (c2 == '*' && c1 == ')')) break;
                                if(c1 == '\n') lineno++;
                              }
                            }
.                           {
                              std::string s = "unrecognized symbol " + std::string(yytext); 
                              yyerror(s.data());
                              exit(0);
                            }

%%
  /* User code */
