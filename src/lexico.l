%{
// #include <FlexLexer.h>       // already included by flex
#include <iostream>
using std::cin, std::cout, std::endl;
%}
  /* Definition */

/* Read only one file as input */
%option noyywrap

letra               [a-zA-Z]
digito              [0-9]
alpha               {letra}|{digito}
id                  (_|{letra})(_|{alpha})*
num                 (\+|\-)?{digito}+(\.{digito}+)?
comment_begin       \(\*
comment_body        [^\*]|\*+[^\*\)]
comment_end         \*+\)
comment             {comment_begin}{comment_body}*{comment_end}

%%
  /* Rules */
{id}                cout << YYText() << "-> id" << endl;
{num}               cout << YYText() << "-> num" << endl;
{comment}           cout << YYText() << "-> comment" << endl;
[ \t\n\r]           /* skip whitespace */
.                   cout << YYText() << "-> token indefinido" << endl;

%%
  /* User's  code */
int main() {
    yyFlexLexer lexer;
    lexer.yylex();

    return 0;
}
