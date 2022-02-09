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
id                  {letra}{alpha}*
num                 \-?{digito}+(\.{digito}+)?
comment_begin       \(\*
comment_body        [^\*]|\*+[^\*\)]
comment_end         \*+\)
comment             {comment_begin}{comment_body}*{comment_end}

%%
  /* Rules */
{letra}             cout << YYText() << "-> letra" << endl;
{digito}            cout << YYText() << "-> digito" << endl;
{alpha}             cout << YYText() << "-> alpha" << endl;
{id}                cout << YYText() << "-> id" << endl;
{num}               cout << YYText() << "-> num" << endl;
{comment_begin}     cout << YYText() << "-> comment_begin" << endl;
{comment_body}      cout << YYText() << "-> comment_body" << endl;
{comment_end}       cout << YYText() << "-> comment_end" << endl;
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
