%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void itoa1(int a, int k);
char* insert_quad(char op[10], char arg1[10], char arg2[10], int j);

struct symtab {
    char *name;
    double value;
} SYM[20];

struct symtab *install_id(char *s);
void display_sym();

typedef struct quadruple {
    char op[10];
    char arg1[10];
    char arg2[10];
    char res[10];
} QUAD;

QUAD Q[30];
void display_quad();

int i = 0;
int tempvar = 1;
char temp[10], st[10];
%}

%union {
    struct symtab *p;
    char *v;
}

%token <p> id
%token <v> num
%right '='
%left '+' '-'
%left '*' '/'
%right '^'
%nonassoc UMINUS
%type <v> E

%%

S :
    S OS
  | OS
  ;

OS :
    AS
  ;

AS :
    id '=' E ';' {
        strcpy(Q[i].op, "=");
        strcpy(Q[i].arg1, $3);
        strcpy(Q[i].arg2, "");
        strcpy(Q[i].res, $1->name);
        i++;
    }
  ;

E :
    E '+' E { $$ = insert_quad("+", $1, $3, i++); }
  | E '-' E { $$ = insert_quad("-", $1, $3, i++); }
  | E '*' E { $$ = insert_quad("*", $1, $3, i++); }
  | E '/' E { $$ = insert_quad("/", $1, $3, i++); }
  | E '^' E { $$ = insert_quad("^", $1, $3, i++); }
  | '-' E %prec UMINUS { $$ = insert_quad("UMINUS", $2, "", i++); }
  | id { $$ = strdup($1->name); }
  | num { $$ = strdup($1); }
  ;

%%

char* insert_quad(char op[10], char arg1[10], char arg2[10], int j) {
    strcpy(Q[j].op, op);
    strcpy(Q[j].arg1, arg1);
    strcpy(Q[j].arg2, arg2);

    strcpy(temp, "t");
    itoa1(tempvar++, 10);
    strcat(temp, st);

    strcpy(Q[j].res, temp);
    return strdup(Q[j].res);
}

int yyerror(char *s) {
    printf("Error: %s\n", s);
    return 1;
}

int main() {
    yyparse();
    display_quad();
    display_sym();
    return 0;
}

struct symtab *install_id(char *s) {
    struct symtab *p;
    for (p = SYM; p < &SYM[20]; p++) {
        if (p->name && !strcmp(p->name, s))
            return p;
        else if (!p->name) {
            p->name = strdup(s);
            return p;
        }
    }
    return NULL;
}

void display_sym() {
    struct symtab *p;
    printf("\nSymbol Table:\n");
    printf("Name\tValue\n");
    for (p = SYM; p < &SYM[20]; p++) {
        if (p->name)
            printf("%s\t%lf\n", p->name, p->value);
    }
}

void itoa1(int t, int b) {
    int j = 0, k;
    char m[10];
    while (t != 0) {
        m[j++] = t % b + '0';
        t = t / b;
    }
    m[j] = '\0';

    j = 0;
    for (k = strlen(m) - 1; k >= 0; k--)
        st[j++] = m[k];
    st[j] = '\0';
}

void display_quad() {
    int j;
    printf("\nQuadruples:\n");
    printf("S.No\tOp\tArg1\tArg2\tRes\n");
    for (j = 0; j < i; j++)
        printf("%d\t%s\t%s\t%s\t%s\n", j, Q[j].op, Q[j].arg1, Q[j].arg2, Q[j].res);
}
