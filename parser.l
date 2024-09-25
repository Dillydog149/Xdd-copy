/*
* Dylan Bernier cssc4062
* CS530 Spring 2024
* Assignment 3, Parser
* parser.l
*/
%{
#include "parser.tab.h"
%}
%option noyywrap
%%
<<EOF>>                     {return END_OF_FILE;}
[a-zA-Z][a-zA-Z0-9]*        {yylval.sval = yytext; return ID;}
[-+/*%]                     {yylval.sval = yytext; return OP;}
[=]                         {yylval.sval = yytext; return EQUALS;}
[ \t]                       ;
[\r]                        ;
;                           {yylval.sval = yytext; return SEMICOLON;}
[\n]                        {return NEWLINE;}
[(]                         {yylval.sval = yytext; return OPEN_PARENS;}
[)]                         {yylval.sval = yytext; return CLOSE_PARENS;}
[0-9][0-9]*                 {yylval.sval = yytext; return INT;}
[0-9][a-zA-Z0-9]*           {yylval.sval = yytext; return INVALID_ID;}
.                           {yylval.sval = yytext; return UNKNOWN;}
%%
