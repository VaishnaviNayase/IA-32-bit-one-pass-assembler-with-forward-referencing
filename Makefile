assembler: lex.yy.c y.tab.c
	gcc -o assembler lex.yy.c y.tab.c -ll 

lex.yy.c: tokenizer.l
	lex tokenizer.l

y.tab.c: parser.y
	yacc -d parser.y

