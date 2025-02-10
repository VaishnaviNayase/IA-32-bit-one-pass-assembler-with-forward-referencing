%{
#include "y.tab.h"
#include<string.h>
extern char flag,isReg,isMem;
%}

SPACE [ \t]+
COLON :
ALPHANUM [a-zA-Z0-9]*
COMMA ,
VALUE [0-9]+
QUOTES \"[^\"]*\"
SMEMORY (dword)?\[
EMEMORY \]
%%

{SPACE} ;
mov|sub|add|cmp|xor {
	yylval.opname = strdup(yytext);	
	return op2;
}
mul|div|inc|dec|jmp|jnz|jz {
	yylval.opname = strdup(yytext);	
	return op1;
}
ret return op0;

eax|ebx|ecx|edx|esi|edi|esp|ebp { 
	if(isMem == 1){
		isReg = 1;
	}
	yylval.opname = strdup(yytext);	
	return reg;
}

db|dd {
	if(0==strcmp(yytext,"dd")){
		flag = 1;
		return dd;
	}else if(0==strcmp(yytext,"db")){
		flag = 0;
		return db;
	}
}
resb|resd {
	if(strcmp(yytext,"resd") == 0){
		flag = 1;
		return resd;
	}
	else if(strcmp(yytext,"resb") == 0){
		flag = 0;
		return resb;
	}
}
^section{SPACE}\.(bss|data|text)[ \t]*$ { 
	return section;	
}
(extern) {
	return e_key;
}
(global) {
	return g_key;
}
{SMEMORY} {
	yylval.opname = strdup(yytext);
	isMem = 1;
	return start_mem;
}
{EMEMORY} {
	yylval.opname = strdup(yytext);
	isMem = 0;
	return end_mem;
}
{QUOTES} {
	yylval.opname = strdup(yytext);
	return string;
}
[a-zA-Z_]{ALPHANUM} {
	//isReg = 0;
	yylval.opname = strdup(yytext);	
 	return sym;
}
{VALUE} {
	yylval.opname = strdup(yytext);	
 	return value;
}
{COMMA} return comma;
{COLON} return colon;
\n return end;
. ;
%%
