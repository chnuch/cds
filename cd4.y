%{
#include <stdio.h>
#include <stdlib.h>
%}

%token IF ELSE WHILE FOR ID NUM REL_OP

%%

program:
    stmt_list
    ;

stmt_list:
    stmt
    | stmt_list stmt
    ;

stmt:
    if_stmt
    | while_stmt
    | for_stmt
    | expr_stmt
    ;

if_stmt:
    IF '(' expr ')' stmt
    | IF '(' expr ')' stmt ELSE stmt
    ;

while_stmt:
    WHILE '(' expr ')' stmt
    ;

for_stmt:
    FOR '(' expr_stmt expr_stmt expr ')' stmt
    ;

expr_stmt:
    expr ';'
    ;

expr:
    ID '=' expr
    | ID REL_OP NUM
    | ID
    | NUM
    ;

%%

int main() {
    printf("Enter control statements (Ctrl+D to stop):\n");
    yyparse();
    printf("Syntax correct.\n");
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Syntax error: %s\n", s);
    exit(1);
}
