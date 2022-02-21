%{
// #include <FlexLexer.h>       // already included by flex
#include <iostream>
using std::cin, std::cout, std::endl;
%}
  /* Definition */

/* Read only one file as input */
%option noyywrap

letra                       [a-zA-Z]
digito                      [0-9]
unary_op                    \+|\-
add_op                      \+|\-
assig_op                    \=
tipo                        "int"|"float"

alphan                      {letra}|{digito}
id                          (_|{letra})(_|{alphan})*
/* num                         (\+|\-)?{digito}+(\.{digito}*)? */
num                         {digito}+(\.{digito}*)?

var                         {tipo}[ ]+{id}[ ]*{assig_op}[ ]*{expression}
expression                  {unary_expression}|{additive_expression}
unary_expression            {unary_op}?{num}
additive_expression         {unary_expression}([ ]*{add_op}[ ]*{unary_expression})+

comment                     {comment_begin}{comment_body}*{comment_end}
comment_begin               \(\*
comment_body                [^\*]|\*+[^\*\)]
comment_end                 \*+\)

%%
  /* Rules */
{var}                       cout << YYText() << "-> var" << endl;
{expression}                cout << YYText() << "-> expression" << endl;
{additive_expression}       cout << YYText() << "-> additive_expression" << endl;
{unary_expression}          cout << YYText() << "-> unary_expression" << endl;
{id}                        cout << YYText() << "-> id" << endl;
{tipo}                      cout << YYText() << "-> tipo" << endl;
{letra}                     cout << YYText() << "-> letra" << endl;
{num}                       cout << YYText() << "-> num" << endl;
{unary_op}                  cout << YYText() << "-> unary_op" << endl;
{add_op}                    cout << YYText() << "-> add_op" << endl;
{assig_op}                  cout << YYText() << "-> assig_op" << endl;
{comment}                   cout << YYText() << "-> coment" << endl;
[ \t\n\r]                   /* skip whitespace */
.                           cout << YYText() << "-> token indefinido" << endl;

%%
  /* User's  code */
int main() {
    yyFlexLexer lexer;
    lexer.yylex();

    return 0;
}
