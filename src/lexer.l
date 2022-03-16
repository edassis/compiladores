%{
#include <stdio.h>
#include "parser.hpp"
#define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno;
%}
  /* Definition */

/* Read only one file as input */
%option noyywrap

TYPE                        "int"|"float"
ID                          [[:alpha:]_][[:alnum:]_]*
NUM                         [[:digit:]]+(\.[[:digit:]]*)?

%%
  /* Rules */
"-"                         { return MINUS; }
"+"                         { return PLUS; }
"*"                         { return MULT; }
"/"                         { return DIV; }
"="                         { return EQUAL; }
{TYPE}                      { yylval.dval = atof(yytext); return TYPE; }
{ID}                        { yylval.string = yytext; return ID; }
{NUM}                       { yylval.dval = atof(yytext); return NUM; }
"\n"                        { return END; }
[ \t\r]                     /* skip whitespace */
.                           { printf("Error at line %d: unrecognized symbol \"%s\"\n", yylloc.first_line, yytext); exit(0); }

%%
  /* User code */
