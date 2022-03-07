%{
// #include <FlexLexer.h>       // already included by flex
#include <iostream>
using std::cin, std::cout, std::endl;
%}
  /* Definition */

/* Read only one file as input */
%option noyywrap

unary_op                    \+|\-
add_op                      \+|\-
mult_op                     \*|\/
assig_op                    \=

tipo                        "int"|"float"
id                          [[:alpha:]_]|[[:alnum:]_]*
num                         [[:digit:]]+(\.[[:digit:]]*)?

var                         {tipo}[ ]+{id}[ ]*{assig_op}[ ]*{expression}
expression                  {unary_expression}|{add_expression}|{mult_expression}
mult_expression             ({add_expression}|{unary_expression})([ ]*{mult_op}[ ]*({add_expression}|{unary_expression}))+
add_expression              {unary_expression}([ ]*{add_op}[ ]*{unary_expression})+
unary_expression            ({unary_op}[ ]*)?{num}

comment                     {comment_begin}{comment_body}*{comment_end}
comment_begin               \(\*
comment_body                [^\*]|\*+[^\*\)]
comment_end                 \*+\)

%%
  /* Rules */
{unary_op}                  |
{add_op}                    |       /* same as unary_op */
{assig_op}                  cout << YYText() << "-> ops" << endl;

{tipo}                      cout << YYText() << "-> tipo" << endl;
{id}                        cout << YYText() << "-> id" << endl;
{num}                       cout << YYText() << "-> num" << endl;

{var}                       cout << YYText() << "-> var" << endl;
    /* {expression}                cout << YYText() << "-> expression" << endl; */
{mult_expression}           cout << YYText() << "-> mult_expression" << endl;
{add_expression}            cout << YYText() << "-> add_expression" << endl;
{unary_expression}          cout << YYText() << "-> unary_expression" << endl;

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
