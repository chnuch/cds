%{
#include <stdio.h>
%}

%token Det Noun Verb Pronoun CONJ Preposition
%nonassoc Noun
%nonassoc Preposition
%nonassoc CONJ

%%
S1 : S1 S
    | S
    ;

S : SS { printf("simple sentence\n"); }
    | CS '.' { printf("Compound sentence\n"); }
    ;

CS : SS CONJ SS { printf("cs\n"); }
    | CS CONJ SS
    ;

SS : NP VP { printf("ss\n"); }
    | VP { printf("1\n"); }
    ;

NP : Det Noun { printf("2\n"); }
    | Noun { printf("3\n"); }
    | Pronoun { printf("4\n"); }
    | Det Noun PP { printf("5\n"); }
    ;

VP : Verb NP { printf("6\n"); }
    | Verb { printf("7\n"); }
    | VP PP { printf("8\n"); }
    ;

PP : Preposition NP { printf("9\n"); }
    ;

%%
void main() {
    yyparse();
}

int yyerror(char *msg) {
    printf("%s\n", msg);
    return 1;
}
