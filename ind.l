%{
#include <stdlib.h>
#include "ind.tab.h"
%}

digit [0-9]
letter [A-z]
symb [A-z_0-9]

%%
(\+|\-|\/|\*)	{ yylval.value = strdup(yytext); return bin_arithm; }
"&&" { yylval.value = strdup(yytext); return bitwise; }
"||" { yylval.value = strdup(yytext); return bitwise; }

"="	{ return assign; }
";"	{ return semicolon; }
"if"	{ return IF; }
"else"	{ return EL; }


"("	{ return l_cbr; }
")"	{ return r_cbr; }
"{"	{ return l_fbr; }
"}"	{ return r_fbr; }

[!]{0,1}{letter}{symb}*	{ yylval.value = strdup(yytext); return var; }
{digit}+		{ yylval.numb = atoi(yytext); return CONST; }

[ \0\t]+ ;
\n	;
.	;
%%

#ifndef yywrap
int yywrap () { return 1; }
#endif

