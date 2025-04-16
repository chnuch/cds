%{
#include <stdio.h>
#include "parser.tab.h"
%}

%%
"the"|"a"|"an"                { return Det; }
"birds"|"dog"|"kettle"|"TV"|"hamburgers"|"Lois"|"pizza"|"table"|"book" { return Noun; }
"live"|"barks"|"sleeps"|"sings"|"open"|"saw"|"paint" { return Verb; }
"to"|"from"|"behind"|"above"|"below"|"between"|"in"|"out" { return Preposition; }
"she"|"he"|"they"|"we"|"I"|"you" { return Pronoun; }
"and"|"or" { return CONJ; }
[ \t\n] ; // Ignore whitespace
. { return yytext[0]; }

%%
int yywrap() {
    return 1;
}
