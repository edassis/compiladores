%{
// includes, tipos (c++)
#include <iostream>
using std::cin, std::cout, std::endl;
%}
%option noyywrap
spc                 [ ]
nline               \n
tab                 \t
letra               [a-zA-Z]
digito              [0-9]
alpha               {letra}|{digito}
id	                {letra}{alpha}*
num                 \-?{digito}+(\.{digito}+)?
cl                  [^\*\)]|{alpha}
c                   {cl}|\)
comment_begin       \(\*
comment_body        {c}|\*+{cl}
comment_end         \*+\)
comment             {comment_begin}{comment_body}*{comment_end}
%%
{spc}		        cout << YYText() << " -> spc" << endl;
{nline}		        cout << YYText() << " -> nline" << endl;
{tab}		        cout << YYText() << " -> tab" << endl;
{letra}		        cout << YYText() << " -> letra" << endl;
{digito}	        cout << YYText() << " -> digito" << endl;
{alpha}	            cout << YYText() << " -> alpha" << endl;
{id}		        cout << YYText() << " -> id" << endl;
{num}		        cout << YYText() << " -> num" << endl;
{cl}		        cout << YYText() << " -> cl" << endl;
{c}		            cout << YYText() << " -> c" << endl;
{comment_begin}		cout << YYText() << " -> comment_begin" << endl;
{comment_body}		cout << YYText() << " -> comment_body" << endl;
{comment_end}		cout << YYText() << " -> comment_end" << endl;
{comment}		    cout << YYText() << " -> comment" << endl;
.                   cout << YYText() << " -> token indefinido" << endl;
%%
main() {
    yyFlexLexer lexer;
    lexer.yylex();
}