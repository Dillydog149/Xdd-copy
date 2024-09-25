
/* Dylan Bernier cssc4062 825233702
* CS530 Spring 2024
* Assignment 3 
* parser.y
*/
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE* yyin;
extern char yytext[];
%}
%error-verbose
%token <sval>ID
%token <sval>OP
%token <sval>SEMICOLON
%token NEWLINE
%token <sval>ASSIGNMENT_NL
%token END_OF_FILE
%token <sval>EQUALS
%token <sval>OPEN_PARENS
%token <sval>CLOSE_PARENS
%token <sval>INT
%token <sval>UNKNOWN
%token <sval>INVALID_ID
%union {
    char *sval;
}

%%
next:line
    |next line 
    ;

line:NEWLINE {}
    |END_OF_FILE {return 0;}
    |assignment NEWLINE {printf("VALID \n");}
    |expr NEWLINE {printf("VALID \n");} 
    |invassignment {}
    |error {yyerrok;}
    ;


assignment:id equals expr semicolon
    ;

invassignment: id equals expr NEWLINE {printf("INVALID: syntax error, expecting SEMICOLON. Specifically, ;\n");}
    ;

expr:id 
        |expr op expr
        |oparen expr cparen
        ;


id : ID {printf("%s ", $1);};
op : OP {printf("%s ", $1);};
equals: EQUALS {printf("%s ", $1);};
oparen: OPEN_PARENS {printf("%s ", $1);};
cparen: CLOSE_PARENS {printf("%s ", $1);};
semicolon : SEMICOLON {printf("%s ",$1);};

%%
int main(int argc, char **argv)
{
    if(argc < 2) {
       printf("Usage : %s <filename>\n", argv[0]);
       return 1;
    }

    FILE* inputFile = fopen(argv[1], "r");
    
    if (inputFile == NULL) { /* exits if file not found */
        printf("Error: file cannot be opened.\n");
        return 1;
    }
    
    yyin = inputFile; /* parsers reading from file */
    yyparse(); /* begin parsing process */
    return 0;  
}
int yyerror(const char *s)
{
 int ntoken = 0; /* saves token type*/
 char* t = yylval.sval; /* temp char* for printing rest of sentence */
 char* err = strdup(yylval.sval); /* saves string that caused error */
 printf("%s ", t);
 while (1) { /*continues to print the sentence after the error */
 ntoken = yylex();
 if (ntoken == NEWLINE)
    break;
 if(ntoken == END_OF_FILE)
    break;
 t = yylval.sval;
 printf("%s ", t);
 }

 printf("INVALID: %s. Specifically, %s\n", s,err); /* Prints error */
 yyparse(); /* resume parsing process */
 return 1;
}
