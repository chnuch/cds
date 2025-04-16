%{ 
    #include <stdio.h> 
    #include <ctype.h> 
 
    void print_token(const char *token_type, const char *value); 
 
     
%} 
 
%% 
 
"if"    {print_token("KEYWORD", yytext); } 
"else"  {print_token("KEYWORD", yytext); } 
"while"  {print_token("KEYWORD", yytext); } 
"return"  {print_token("KEYWORD", yytext); } 
"{"      { print_token("DELIMITER", yytext); } 
"}"      { print_token("DELIMITER", yytext); } 
"("      { print_token("DELIMITER", yytext); } 
")"      { print_token("DELIMITER", yytext); } 
 
[a-zA-Z_][a-zA-Z0-9_]{0,31} {print_token("IDENTIFIER", yytext); } 
[0-9]+(\.[0-9]+)? {print_token("NUMBER", yytext); } 
[-+=/*><] {print_token("OPERATOR", yytext); } 
"//".*  {/* ignore single line comment */} 
"/*"(.|\n)*?"*/" { /* ignore multi-line comments */ } 
[ \t\n]+    {/* ignore whitespace*/} 
 
.   {printf("Error: unrecognized char '%s'\n", yytext);} 
 
 
%% 
 
void print_token(const char *token_type, const char *value){ 
    printf("<%s, %s>\n",token_type, value  ); 
} 
 
int yywrap() { 
        return 1; // Indicates end of input 
    } 
 
int main() 
{ 
    char filename[256]; 
 
    printf("enter the file name :: "); 
    if(scanf("%255s", filename) !=1){ 
        printf("failed to read file name !\n"); 
        return 1; 
    } 
 
    FILE *file = fopen(filename, "r"); 
    if(!file){ 
        perror("error opening file"); 
        return 1; 
    } 
 
    yyin = file;  // Set the input source for the lexer 
     printf("Lexical Analysis Starting...\n"); 
    yylex();           // Start the lexical analysis 
    printf("Lexical Analysis Completed.\n"); 
 
 
    fclose(file); 
    return 0; 
 
} 
