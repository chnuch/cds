#include <stdio.h>
#include <math.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

struct quad {
    char ope[5];
    char arg1[5];
    char arg2[5];
    char res[5];
} QUAD[20];

int i = 0, n, c = 0;

void get() {
    printf("\nEnter number of lines in a block: ");
    scanf("%d", &n);
    printf("Enter ICG in form [operator arg1 arg2 result]:\n");
    for (i = 0; i < n; i++) {
        scanf("%s %s %s %s", QUAD[i].ope, QUAD[i].arg1, QUAD[i].arg2, QUAD[i].res);
    }
}

void const_folding() {
    int j, c1 = 0, d = 0;
    char ch[10];
    int flag1 = 1, flag2 = 1;

    for (i = 0; i < n; i++) {
        flag1 = 1;
        flag2 = 1;

        for (j = 0; j < strlen(QUAD[i].arg1); j++) {
            if (!isdigit(QUAD[i].arg1[j])) {
                flag1 = 0;
                break;
            }
        }

        for (j = 0; j < strlen(QUAD[i].arg2); j++) {
            if (!isdigit(QUAD[i].arg2[j])) {
                flag2 = 0;
                break;
            }
        }

        if (flag1 == 1 && flag2 == 1) {
            c = atoi(QUAD[i].arg1);
            c1 = atoi(QUAD[i].arg2);

            if (strcmp(QUAD[i].ope, "*") == 0) d = c * c1;
            else if (strcmp(QUAD[i].ope, "/") == 0) d = c / c1;
            else if (strcmp(QUAD[i].ope, "+") == 0) d = c + c1;
            else if (strcmp(QUAD[i].ope, "-") == 0) d = c - c1;

            snprintf(ch, 10, "%d", d);
            strcpy(QUAD[i].ope, "=");
            strcpy(QUAD[i].arg1, ch);
            strcpy(QUAD[i].arg2, "\0");
        }
    }
}

void strength_reduction() {
    int j = 0, n1 = 0, m = 0, c = 0, tempo = 0, t = 0;
    char ch[10], cc[10], ct[10], pres[10];
    int flag;

    strcpy(ct, "s");

    for (i = 0; i < n; i++) {
        c = 0;

        if (strcmp(QUAD[i].ope, "*") == 0 || strcmp(QUAD[i].ope, "/") == 0) {
            j = 1;
            flag = (strcmp(QUAD[i].ope, "*") == 0) ? 0 : 1;

            if (atoi(QUAD[i].arg2) > 0) {
                m = atoi(QUAD[i].arg2);
                n1 = 0;
                while (n1 <= m) {
                    n1 = pow(2, j);
                    j++;
                }
                j = j - 2;
                n1 = pow(2, j);
                c = m - n1;

                snprintf(ch, 10, "%d", j);
                if (c == 0) {
                    if (flag == 0) strcpy(QUAD[i].ope, "<<");
                    else strcpy(QUAD[i].ope, ">>");
                    strcpy(QUAD[i].arg2, ch);
                } else {
                    strcpy(pres, QUAD[i].res);

                    if (flag == 0) strcpy(QUAD[i].ope, "<<");
                    else strcpy(QUAD[i].ope, ">>");

                    strcpy(QUAD[i].arg2, ch);
                    strcpy(QUAD[i].res, "t2");
                    i++;

                    for (t = 0; t < c; t++) {
                        for (j = n; j >= i; j--)
                            QUAD[j + 1] = QUAD[j];

                        snprintf(ch, 10, "%d", c - (c - 1));
                        snprintf(cc, 10, "%d", i);
                        strcpy(ct, "s");
                        strcat(ct, cc);

                        if (c == 1) {
                            if (flag == 0) strcpy(QUAD[i].ope, "+");
                            else strcpy(QUAD[i].ope, "-");

                            tempo = i - 1;
                            strcpy(QUAD[i].arg1, QUAD[tempo].res);
                            strcpy(QUAD[i].arg2, ch);
                            strcpy(QUAD[i].res, ct);
                        } else {
                            if (flag == 0) strcpy(QUAD[i].ope, "+");
                            else strcpy(QUAD[i].ope, "-");

                            tempo = i - 1;
                            strcpy(QUAD[i].arg1, QUAD[tempo].res);
                            strcpy(QUAD[i].arg2, ch);
                            strcpy(QUAD[i].res, ct);
                        }

                        i++;
                        n++;
                    }
                }

                for (j = i; j < n; j++) {
                    if (strcmp(QUAD[j].arg1, pres) == 0)
                        strcpy(QUAD[j].arg1, QUAD[i - 1].res);
                    else if (strcmp(QUAD[j].arg2, pres) == 0)
                        strcpy(QUAD[j].arg2, QUAD[i - 1].res);
                }

                if (c != 0)
                    i--;
            }
        }
    }
}

void disp() {
    printf("\nQuadruples:\n");
    printf("Operator\tArg1\tArg2\tResult\n");
    for (i = 0; i < n; i++) {
        printf("%s\t\t%s\t%s\t%s\n", QUAD[i].ope, QUAD[i].arg1, QUAD[i].arg2, QUAD[i].res);
    }
}

int main() {
    get();

    printf("\nInitial Quadruples:\n");
    disp();

    const_folding();
    printf("\nAfter Constant Folding:\n");
    disp();

    strength_reduction();
    printf("\nAfter Strength Reduction:\n");
    disp();

    return 0;
}
