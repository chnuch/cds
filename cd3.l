%{
#include "y.tab.h"
%}

%%

"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"for"       { return FOR; }
"("         { return '('; }
")"         { return ')'; }
"{"         { return '{'; }
"}"         { return '}'; }
";"         { return ';'; }
"<" | ">" | "==" | "!=" | "<=" | ">=" { return REL_OP; }
"="         { return '='; }
[a-zA-Z_][a-zA-Z0-9_]*   { return ID; }
[0-9]+      { return NUM; }
[ \t\n]+    ; // ignore whitespace

.           { printf("Invalid character: %s\n", yytext); }

%%
int yywrap() {
    return 1;
}
