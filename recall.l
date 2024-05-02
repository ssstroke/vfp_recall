%{
  #include <stdio.h>
  #include <stdlib.h>

  #include "y.tab.h"
%}

%%

(?i:recall)       return KEYWORD_RECALL;
(?i:all)          return KEYWORD_ALL;
(?i:next)         return KEYWORD_NEXT;
(?i:record)       return KEYWORD_RECORD;
(?i:rest)         return KEYWORD_REST;
(?i:for)          return KEYWORD_FOR;
(?i:while)        return KEYWORD_WHILE;
(?i:nooptimize)   return KEYWORD_NOOPTIMIZE;
(?i:in)           return KEYWORD_IN;

[a-zA-Z_]([a-zA-Z_0-9])*    return IDENTIFIER;

("<"|">"|"="|"<>"|"<="|">=")  return OPERATOR_LOGICAL;

"-"   return '-';
"+"   return '+';
"*"   return '*';
"/"   return '/';

[0-9]+              return LITERAL_NUMBER;
\"(\\.|[^"\\])*\"   return LITERAL_STRING;

[ \t\n]   ;

.   { fprintf(stderr, "Unexpected symbol: %s\n", yytext); exit(EXIT_FAILURE); }

%%

