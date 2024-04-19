%{
 
#include <stdio.h>
#include "y.tab.h"
int c;			/*Used to get the character code of the next character */
extern int yylval;	/*Used to store the value of the token */
%}
%%
" "       ; /*Skip whitespace */
[a-z]     {	/*For alphabetic character, convert to number from 0-25 and return LETTER */
            c = yytext[0];
            yylval = c - 'a';
            return(LETTER);
          }
[0-9]     {	/*For numberic character, convert to number from 0-9 and return DIGIT */
            c = yytext[0];
            yylval = c - '0';
            return(DIGIT);
          }
[^a-z0-9\b]    {	/*For anything that is not lowercase alphanumeric or backspace, return the character itself */
                 c = yytext[0];
                 return(c);
               }
