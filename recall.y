%{
  int yylex(void);
  int yyerror(const char* s);

  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>

  extern int yylineno;
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

statement   : KEYWORD_RECALL scope for_exp while_exp nooptimize in
            | KEYWORD_RECALL error {
              yyerror("Missing parts required after 'RECALL'. Expected: [scope], [FOR], [WHILE], [NOOPTIMIZE], [IN].");
            }
            ;

scope       : /* empty */
            | KEYWORD_ALL
            | next
            | record
            | KEYWORD_REST
            ;

next        : KEYWORD_NEXT LITERAL_NUMBER
            | KEYWORD_NEXT error {
              yyerror("Bad 'NEXT' usage. Expected: 'NEXT <number>'.");
              yyclearin;
            }
            ;

record      : KEYWORD_RECORD LITERAL_NUMBER
            | KEYWORD_RECORD error {
              yyerror("Bad 'RECORD' usage. Expected: 'RECORD <number>'.");
              yyclearin;
            }
            ;

for_exp     : /* empty */
            | KEYWORD_FOR expr_l
            | KEYWORD_FOR error {
              yyerror("Bad 'FOR' usage. Expected: 'FOR <logical expression>'.");
              yyclearin;
            }
            ;

while_exp   : /* empty */
            | KEYWORD_WHILE expr_l
            | KEYWORD_WHILE error {
              yyerror("Bad 'WHILE' usage. Expected: 'WHILE <logical expression>'.");
              yyclearin;
            }
            ;

nooptimize  : /* empty */
            | KEYWORD_NOOPTIMIZE
            ;

in          : /* empty */
            | KEYWORD_IN LITERAL_NUMBER
            | KEYWORD_IN IDENTIFIER
            | KEYWORD_IN error {
              yyerror("Bad 'IN' usage. Expected: 'IN <number>|<identifier>'.");
              yyclearin;
            }
            ;

expr_l      : operand_l OPERATOR_LOGICAL operand_l
            ;

operand_l   : LITERAL_STRING
            | IDENTIFIER
            | expr_a
            ;

expr_a      : LITERAL_NUMBER
            | expr_a '+' expr_a
            | expr_a '-' expr_a
            | expr_a '*' expr_a
            | expr_a '/' expr_a {
              if ($3 == '0')
                yyerror("Division by 0.");
            }
            ;

%%

int yyerror(const char *s) {
  /* This is an error that is not explicitly handled in the rules above. */
  if (strcmp(s, "syntax error") == 0) {
    fprintf(stderr, "ERROR: unexpected symbol on line %d\n", yylineno);
  } else {
    fprintf(stderr, "ERROR: %s on line %d\n", s, yylineno);
  }

  return 0;
}

int main(void) {
  if (yyparse() == 0)
    printf("Finished parsing.\n");

  return 0;
}
