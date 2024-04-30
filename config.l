%{
    #include <string.h>

    size_t line_number = 1;

    void found_token(const char*);
    void found_identifier(void);
    void found_string_literal(void);
    void found_number_literal(void);
    void found_operator(void);

    void yyerror(const char*);
%}

%x STATE_FOUND_NUMBER STATE_FOUND_IDENTIFIER

%%

<STATE_FOUND_NUMBER>[^ \t\n]    { yyerror("unidentified."); }
<STATE_FOUND_NUMBER>[ \t\n]     {
                                    BEGIN(INITIAL);
                                    yytext[strlen(yytext) - 1] = 0;
                                    found_number_literal();
                                }
<STATE_FOUND_NUMBER><<EOF>>     { found_number_literal(); yyterminate(); }

<STATE_FOUND_IDENTIFIER>[^ \t\n]    { yyerror("unidentified."); }
<STATE_FOUND_IDENTIFIER>[ \t\n]     {
                                        BEGIN(INITIAL);
                                        yytext[strlen(yytext) - 1] = 0;
                                        found_identifier();
                                    }
<STATE_FOUND_IDENTIFIER><<EOF>>     { found_identifier(); yyterminate(); }

(?i:recall)                 { found_token("T_RECALL"); }
(?i:all)                    { found_token("T_ALL"); }
(?i:next)                   { found_token("T_NEXT"); }
(?i:record)                 { found_token("T_RECORD"); }
(?i:rest)                   { found_token("T_REST"); }
(?i:for)                    { found_token("T_FOR"); }
(?i:while)                  { found_token("T_WHILE"); }
(?i:nooptimize)             { found_token("T_NOOPTIMIZE"); }
(?i:in)                     { found_token("T_IN"); }

[a-zA-Z_]([a-zA-Z_0-9])*    { BEGIN(STATE_FOUND_IDENTIFIER); yymore(); }

\"([^\"])*\n                { yyerror("string literal must be inside \" \" on a single line."); }
\"([^\"\n])*\"              { found_string_literal(); }

[<|>|=|<>|<=|>=]            { found_operator(); }

[0-9]+                      { BEGIN(STATE_FOUND_NUMBER); yymore(); }

[\n]                        { ++line_number; }
[ \t\r]                     { ; }

.                           { yyerror("unidentified."); }

%%

void found_token(const char* token)
{
    printf("token:\t\t%s\n", token);
}

void found_identifier(void)
{
    printf("identifier:\t%s\n", yytext);
}

void found_string_literal(void)
{
    printf("string literal:\t%s\n", yytext);
}

void found_number_literal(void)
{
    printf("number literal:\t%s\n", yytext);
}

void found_operator(void)
{
    printf("operator:\t%s\n", yytext);
}

void yyerror(const char* message)
{
    printf("ERROR: %s\n", message); exit(1);
}
