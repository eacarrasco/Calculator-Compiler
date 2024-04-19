%{
#include <stdio.h>
int yylex();
int yyerror(char* s);
int regs[26];		/*Array to store variables; one for each lowercase letter */
%}
%start list	/*list is the start symbol */
%token DIGIT LETTER	/*token definitions */
%left '|'		/*operator priority; %left means left associativity */
%left '&'
%left '+' '-'
%left '*' '/'
%left UMINUS
%%
list:                       /*list can be empty */
         |
        list stat '\n'	/*list can be list + stat */
         |
        list error '\n'	/*list can be list + error, and handle error */
         {
           yyerrok;
         }
         ;
stat:    expr	/*stat can be expr, and print */
         {
           printf("%d\n",$1);
         }
         |
         LETTER '=' expr	/*stat can be assignment, and assign variable */
         {
           regs[$1] = $3;
         }
         ;
expr:    '(' expr ')'	/*expr can be (expr), and return value */
         {
           $$ = $2;
         }
         |
         expr '*' expr	/*expr = expr * expr, and return value */
         {
           $$ = $1 * $3;
         }
         |
         expr '/' expr	/*expr can be expr / expr, and return value */
         {
           $$ = $1 / $3;
         }
         |
         expr '+' expr	/*expr can be expr + expr, and return value */
         {
           $$ = $1 + $3;
         }
          |
         expr '-' expr	/*expr can be expr - expr, and return value */
         {
           $$ = $1 - $3;
         }
         |
         expr '&' expr	/*expr can be expr & expr, and return value */
         {
           $$ = $1 & $3;
         }
         |
         expr '|' expr	/*expr can be expr | expr, and return value */
         {
           $$ = $1 | $3;
         }
         |
        '-' expr %prec UMINUS	/*expr can be -expr with highest priority, and return value */
         {
           $$ = -$2;
         }
         |
         LETTER		/*expr can be a LETTER, and return the value of the variable */
         {
           $$ = regs[$1];
         }
         |
         number		/*expr can be a number */
         ;
number:  DIGIT		/*number can be a DIGIT, and return the value */
         {
           $$ = $1;
         }
	 |
         number DIGIT	/*number can be number followed by a DIGIT, in which case multiply number by 10 and add DIGIT */
         {
           $$ = 10 * $1 + $2;
         }
         ;
%%
int main()	/*Start the parser */
{
 return(yyparse());
}
int yyerror(char* s)	/*Print error to handle it */
{
  fprintf(stderr, "%s\n",s);
}
int yywrap()	/*End of input */
{
  return(1);
}
