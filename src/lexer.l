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

COMMENT                     {COMMENT_BEG}{COMMENT_BODY}*{COMMENT_END}
COMMENT_BEG                 \(\*
COMMENT_BODY                [^\*]|\*+[^\*\)]
COMMENT_END                 \*+\)

FUNCTION_CALL               [[:alpha:]_][[:alnum:]_]*{PARENTHESIS_BEG}[0-9]*{PARENTHESIS_END}
PARENTHESIS_BEG             \(
PARENTHESIS_END             \)

%%
  /* Rules */
"("                         { return PARENTHESIS_BEG; }
")"                         { return PARENTHESIS_END; }
"-"                         { return MINUS; }
"+"                         { return PLUS; }
"*"                         { return MULT; }
"/"                         { return DIV; }
"="                         { return EQUAL; }
";"                         { return CMD_END; }
 /* {COMMENT_BODY}              { yylval.text = yytext; return COMMENT_BODY; } */
 /* {COMMENT_BEG}               { yylval.text = yytext; return COMMENT_BEG; } // Use value to facilitate concatenation */
 /* {COMMENT_END}               { yylval.text = yytext; return COMMENT_END; } */
{FUNCTION_CALL}             { yylval.text = yytext; return FUNCTION_CALL; }
{COMMENT}                   { yylval.text = yytext; return COMMENT; }
{TYPE}                      { yylval.text = yytext; return TYPE; }
{ID}                        { yylval.text = yytext; return ID; }
{NUM}                       { yylval.dval = atof(yytext); return NUM; }
[ \t\r]                     /* skip whitespace */
.                           { printf("Error at line %d: unrecognized symbol \"%s\"\n", yylloc.first_line, yytext); exit(0); }

%%
  /* User code */
