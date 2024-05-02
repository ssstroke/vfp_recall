%{
  #include <stdio.h>
  #include <stdlib.h>
%}

%token KEYWORD_RECALL
%token KEYWORD_ALL
%token KEYWORD_NEXT
%token KEYWORD_RECORD
%token KEYWORD_REST
%token KEYWORD_FOR
%token KEYWORD_WHILE
%token KEYWORD_NOOPTIMIZE
%token KEYWORD_IN

%token IDENTIFIER

%token OPERATOR_LOGICAL

%token LITERAL_NUMBER
%token LITERAL_STRING

%left '+' '-'
%left '*' '/'

%%

command     :
            KEYWORD_RECALL scope for_exp while_exp nooptimize in
            ;

scope       : /* empty */
            | KEYWORD_ALL
            | KEYWORD_NEXT LITERAL_NUMBER
            | KEYWORD_RECORD LITERAL_NUMBER
            | KEYWORD_REST
            ;

for_exp     : /* empty */
            | KEYWORD_FOR expr_l
            ;

while_exp   : /* empty */
            | KEYWORD_WHILE expr_l
            ;

nooptimize  : /* empty */
            | KEYWORD_NOOPTIMIZE
            ;

in          : /* empty */
            | KEYWORD_IN LITERAL_NUMBER
            | KEYWORD_IN IDENTIFIER
            ;

expr_l      :
            operand_l OPERATOR_LOGICAL operand_l
            ;

operand_l   :
            LITERAL_STRING
            | IDENTIFIER
            | expr_a
            ;

expr_a      :
            LITERAL_NUMBER
            | expr_a '+' expr_a
            | expr_a '-' expr_a
            | expr_a '*' expr_a
            | expr_a '/' expr_a
            ;

%%

int yyerror(char *s) {
  fprintf(stderr, "%s\n", s);
  return 0;
}

int main(void) {
  yyparse();
  return 0;
}
