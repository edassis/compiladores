%{
// #include <FlexLexer.h>       // already included by flex
#include <iostream>
using std::cin, std::cout, std::endl;
%}
  /* Definition */

/* Read only one file as input */
%option noyywrap

%%
  /* Rules */
\".*\"               {printf("Encontrei uma string na string %s!\n", yytext);}
[ \t\n\r]           /* skip whitespace */
.                   cout << YYText() << "-> token indefinido" << endl;

%%
  /* User's  code */
int main() {
    yyFlexLexer lexer;
    lexer.yylex();

    return 0;
}
