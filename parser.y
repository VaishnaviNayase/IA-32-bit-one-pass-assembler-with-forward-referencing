%{
#include "y.tab.h"
#include "include.h"
int yylex();
void yyerror(char*);
int location_counter,rm_counter = 0;
char flag,isReg = 1,isMem = 0,instruction_size_counter;
char* symbol;
char symbol_values[1024];
sym_table* head = NULL;
sym_table* temp_sym;
forward_data* start = NULL;
int offset = 0;
FILE* file ;
%}

%union {
	char* opname;
}

%token op0 end comma section colon e_key g_key
%token <opname> op1 op2 sym reg value dd db string resb resd start_mem end_mem
%start s
%type <opname> init mem
%%
s:op2 reg comma reg {
	fprintf(file, "%08X ",location_counter);
	rm_counter = 192;
        if(strcmp($1,"mov") == 0){
                fprintf(file, "89");
	}
        else if(strcmp($1,"add") == 0){
                fprintf(file, "01");
	}
        else if(strcmp($1,"sub") == 0){
                fprintf(file, "29"); 
        }
	else if(strcmp($1,"cmp") == 0){
                fprintf(file, "39"); 
        }	
	else if(strcmp($1,"xor") == 0){
                fprintf(file, "31");  
	}
	location_counter += 2;
	rm_counter += 8 * reg_value_counter($4);
	rm_counter += reg_value_counter($2);
	fprintf(file, "%02X\n",rm_counter);
 }
 |op2 reg comma sym {
	sym_table* temp;
	temp  = search($4);
	if(temp != NULL){
		fprintf(file, "%08X ",location_counter);
	        if(strcmp($1,"mov") == 0){
        	        rm_counter = 184 + reg_value_counter($2);
                	location_counter += 5;
        	}
		else{
			fprintf(file, "81");
			location_counter += 6;
			rm_counter = 192;
			rm_counter += reg_value_counter($2);
			if(strcmp($1,"sub") == 0){
				rm_counter += 40;
			}
			else if(strcmp($1,"cmp") == 0){
				rm_counter += 56;
			}
                	else if(strcmp($1,"xor") == 0){
				rm_counter += 48;
			}
		}
        	fprintf(file, "%02X",rm_counter);
		fprintf(file, "[%08X]\n",temp->addr);
	}
	else{
		yyerror("Symbol is not defined\n");
	}
 }
 |op2 reg comma value {
	fprintf(file, "%08X ",location_counter);
	rm_counter = 192;
	if(strcmp($1,"mov") == 0){
       	        location_counter += 5;
               	rm_counter = 184 + reg_value_counter($2);
        	fprintf(file, "%02X",rm_counter);
        	fprintf(file, "%08X\n",atoi($4));
       	}
        else{
		if(atoi($4) > 256){
        		fprintf(file, "81");
                	location_counter += 6;	
        		rm_counter += reg_value_counter($2);
        		if(strcmp($1,"sub") == 0){
				rm_counter += 40;
        		}
        		else if(strcmp($1,"cmp") == 0){
				rm_counter += 56;
	        	}
        		else if(strcmp($1,"xor") == 0){
				rm_counter += 48;
	        	}
        		fprintf(file, "%02X",rm_counter);
        		fprintf(file, "%08X\n",atoi($4));
		}
		else{
                	fprintf(file, "83");
               		location_counter += 3;
               		rm_counter += reg_value_counter($2);
                	if(strcmp($1,"sub") == 0){
                        	rm_counter += 40;
                	}
                	else if(strcmp($1,"cmp") == 0){
                        	rm_counter += 56;
                	}
                	else if(strcmp($1,"xor") == 0){
                        	rm_counter += 48;
                	}
        		fprintf(file, "%02X",rm_counter);
        		fprintf(file, "%02X\n",atoi($4));
		}
	}
 }
 |op2 reg comma mem {
	if(isReg ==  1){
		fprintf(file, "%08X ",location_counter);
        	if(strcmp($1,"mov") == 0){
                	fprintf(file, "8B");
		}
        	else if(strcmp($1,"add") == 0){
                	fprintf(file, "03");
        	}
		else if(strcmp($1,"sub") == 0){
        	        fprintf(file, "2B");
        	}
		else if(strcmp($1,"cmp") == 0){
                	fprintf(file, "3B");
        	}
		else if(strcmp($1,"xor") == 0){
        	        fprintf(file, "33"); 
		}
		location_counter += 2;
		rm_counter += 8 * reg_value_counter($2);
        	fprintf(file, "%02X\n",rm_counter);	
		isReg = 0;
 	} 
	else{
		if(temp_sym != NULL){
			fprintf(file, "\n%08X ",location_counter);
        		if(strcmp($1,"mov") == 0){
                		fprintf(file, "8B");
        		}
        		else if(strcmp($1,"add") == 0){
                		fprintf(file, "03");
        		}
        		else if(strcmp($1,"sub") == 0){
                		fprintf(file, "2B");
        		}
        		else if(strcmp($1,"cmp") == 0){
                		fprintf(file, "3B");
        		}
       			else if(strcmp($1,"xor") == 0){
        	        	fprintf(file, "33");
        		}
                	location_counter += 6;
			rm_counter += 5;
			rm_counter += 8 * reg_value_counter($2);
        		fprintf(file, "%02X",rm_counter);	
			fprintf(file, "[%08X]\n",temp_sym->addr);
		}
		else{
			yyerror("Symbol is not defined\n");
		}
	}
 }
 |op2 mem comma reg {   
        fprintf(file, "%08X ",location_counter);
	if(isReg ==  1){
                if(strcmp($1,"mov") == 0){
                        fprintf(file, "89");
                }
                else if(strcmp($1,"add") == 0){
                        fprintf(file, "01");
                }
                else if(strcmp($1,"sub") == 0){
                        fprintf(file, "29");
                }
                else if(strcmp($1,"cmp") == 0){
                        fprintf(file, "39");
                }
                else if(strcmp($1,"xor") == 0){
                        fprintf(file, "31");
                }
                location_counter += 2;
                rm_counter += 8 * reg_value_counter($4);
                fprintf(file, "%02X\n",rm_counter);
		isReg = 0;
        }
        else{
                if(temp_sym != NULL){
                        if(strcmp($1,"mov") == 0){
                                fprintf(file, "89");
                        }
                        else if(strcmp($1,"add") == 0){
                                fprintf(file, "01");
                    	}
                        else if(strcmp($1,"sub") == 0){
                                fprintf(file, "29");
                        }
                        else if(strcmp($1,"cmp") == 0){
                                fprintf(file, "39");
                        }
                        else if(strcmp($1,"xor") == 0){
                                fprintf(file, "31");
                        }
                        location_counter += 6;
                        rm_counter += 5;
                        rm_counter += 8 * reg_value_counter($4);
                        fprintf(file, "%02X",rm_counter);
                        fprintf(file, "[%08X]\n",temp_sym->addr);
                }
                else{
                        yyerror("Symbol is not defined\n");
                }
        }
 }
 |op2 mem comma value {
        fprintf(file, "%08X ",location_counter);
       	if(strcmp($1,"mov") == 0){
               	fprintf(file, "C7");
                fprintf(file, "%02X",rm_counter);
		if(isReg == 1){
              		location_counter += 6;
		}
		else{
			location_counter += 10;
                       	fprintf(file, "[%08X]",temp_sym->addr);
		}
		fprintf(file, "%08X\n",atoi($4));
       	}
	else{
		if(atoi($4) > 256){
			if(isReg ==  1){
                        	fprintf(file, "81");
                		if(strcmp($1,"sub") == 0){
					rm_counter += 40;
                		}
                		else if(strcmp($1,"cmp") == 0){
					rm_counter += 56;
                		}
                		else if(strcmp($1,"xor") == 0){
					rm_counter += 48;
                		}
                        	location_counter += 6;
                		fprintf(file, "%02X",rm_counter);
				fprintf(file, "%08X\n",atoi($4));
				isReg = 0;
        		}
        		else{
                		if(temp_sym != NULL){
                                	fprintf(file, "81");
					if(strcmp($1,"sub") == 0){
						rm_counter += 40;
                        		}	
                        		else if(strcmp($1,"cmp") == 0){
						rm_counter += 56;
                        		}
                        		else if(strcmp($1,"xor") == 0){
						rm_counter += 48;
                        		}
                                	location_counter += 10;
                        		rm_counter += 5;
                        		fprintf(file, "%02X",rm_counter);
                        		fprintf(file, "[%08X]",temp_sym->addr);
					fprintf(file, "%08X\n",atoi($4));
                		}
                		else{
                        		yyerror("Symbol is not defined\n");
                		}
			}
		}
		else{
			if(isReg ==  1){
                        	fprintf(file, "83");
                		if(strcmp($1,"sub") == 0){
                        		rm_counter += 40;
                		}
                		else if(strcmp($1,"cmp") == 0){
                        		rm_counter += 56;
                		}
                		else if(strcmp($1,"xor") == 0){
                        		rm_counter += 48;
                		}
                        	location_counter += 3;
                		fprintf(file, "%02X",rm_counter);
                		fprintf(file, "%02X\n",atoi($4));
                		isReg = 0;
        		}
        		else{
                		if(temp_sym != NULL){
                                	fprintf(file, "83");
                        		if(strcmp($1,"sub") == 0){
                                		rm_counter += 40;
                        		}
                        		else if(strcmp($1,"cmp") == 0){
                                		rm_counter += 56;
                        		}
                        		else if(strcmp($1,"xor") == 0){
                                		rm_counter += 48;
                        		}
                                	location_counter += 7;
                        		rm_counter += 5;
                        		fprintf(file, "%02X",rm_counter);
                        		fprintf(file, "[%08X]",temp_sym->addr);
                       	 		fprintf(file, "%02X\n",atoi($4));
                		}
                		else{
                        		yyerror("Symbol is not defined\n");
				}
                	}
		}
        }
 }
 |op2 mem comma sym {
        fprintf(file, "%08X ",location_counter);
	sym_table* temp = search($4); 
	if(isReg ==  1){
                if(strcmp($1,"mov") == 0){
                        fprintf(file, "C7");
                }
                else if(strcmp($1,"add") == 0){
                        fprintf(file, "81");
                }
                else if(strcmp($1,"sub") == 0){
                        fprintf(file, "81");
			rm_counter += 40;
                }
                else if(strcmp($1,"cmp") == 0){
                        fprintf(file, "81");
			rm_counter += 56;
                }
                else if(strcmp($1,"xor") == 0){
                        fprintf(file, "81");
			rm_counter += 48;
                }
                location_counter += 6;
                fprintf(file, "%02X",rm_counter);
                fprintf(file, "[%08X]\n",temp_sym->addr);
		isReg = 0;
        }
        else{
                if(temp_sym != NULL && temp != NULL){
                        if(strcmp($1,"mov") == 0){
                                fprintf(file, "C7");
                                location_counter += 10;
                        }
                        else if(strcmp($1,"add") == 0){
                                fprintf(file, "81");
				location_counter += 10;
			}
 			else if(strcmp($1,"sub") == 0){
                                fprintf(file, "81");
                                location_counter += 10;
				rm_counter += 40;
                        }
                        else if(strcmp($1,"cmp") == 0){
                                fprintf(file, "81");
                                location_counter += 10;
				rm_counter += 56;
                        }
                        else if(strcmp($1,"xor") == 0){
                                fprintf(file, "81");
                                location_counter += 10;
				rm_counter += 48;
                        }
                        rm_counter += 5;
                        fprintf(file, "%02X",rm_counter);
                        fprintf(file, "[%08X]",temp_sym->addr);
                        fprintf(file, "[%08X]\n",temp->addr);
                }
                else{
                        yyerror("Symbol is not defined\n");
                }
        }

 }
 |op1 sym {
	fprintf(file, "%08X ",location_counter);
	sym_table* temp;
	temp  = search($2);
	if(temp == NULL){
		if(strcmp($1,"jnz") == 0){
  	        	fprintf(file, "75");
                }
                else if(strcmp($1,"jz") == 0){
                        fprintf(file, "74");
                }
                else if(strcmp($1,"jmp") == 0){
                        fprintf(file, "EB");
                }
                location_counter += 2;
		insert_node(-1,'u',$2,"-1",'4');
		insert(location_counter, $2, ftell(file));		
                fprintf(file, "   ");
	}
	else if(temp != NULL){
		if(temp->section_type != 'u' && temp->section_type != 't'){
			if(strcmp($1,"jnz") == 0){
				fprintf(file, "0F85");
				location_counter += 6;
        		}
			else if(strcmp($1,"jz") == 0){
				fprintf(file, "0F84");
				location_counter += 6;
        		}	
			else if(strcmp($1,"jmp") == 0){
				fprintf(file, "E9");
				location_counter += 5;
			}
			fprintf(file, "(%08X)\n",temp->addr);
		}
		else{
			if(strcmp($1,"jnz") == 0){
                                fprintf(file, "75");
                        }
                        else if(strcmp($1,"jz") == 0){
                                fprintf(file, "74");
                        }
                        else if(strcmp($1,"jmp") == 0){
                                fprintf(file, "EB");
                        }
			location_counter += 2;
			if(temp->section_type == 't'){
				fprintf(file, "%02hhX\n",-(location_counter-temp->addr));
			}
			else{
				insert(location_counter, $2, ftell(file));		
				fprintf(file, "   "); 	
			}
		}
	}
	else{
		fprintf(file,"Symbol is not defined\n");
	}
 }
 |op1 mem {
	fprintf(file, "%08X ",location_counter);
  	if(isReg == 1){
		if(strcmp($1,"inc") == 0){
			fprintf(file, "FF");
		}
		else if(strcmp($1,"dec") == 0){
			fprintf(file, "FF");
			rm_counter += 8;
        	}
		else if(strcmp($1,"div") == 0){
			fprintf(file, "F7");
			rm_counter += 48;
		}
		else if(strcmp($1,"mul") == 0){
			fprintf(file, "F7");
			rm_counter += 32;
        	}
		else if(strcmp($1,"jmp") == 0){
			fprintf(file, "FF");
			rm_counter += 32;
		} 
		location_counter += 2;
		fprintf(file, "%02X\n",rm_counter);
		isReg = 0;
	}
	else{
		if(temp_sym != NULL){
			if(strcmp($1,"inc") == 0){
               	        	fprintf(file, "FF");
               		}
               		else if(strcmp($1,"dec") == 0){
                       		fprintf(file, "FF");
                       		rm_counter += 8;
               		}
               		else if(strcmp($1,"div") == 0){
                       		fprintf(file, "F7");
                       		rm_counter += 48;
               		}
			else if(strcmp($1,"mul") == 0){
                       		fprintf(file, "F7");
                       		rm_counter += 32;
               		}
        		else if(strcmp($1,"jmp") == 0){
               			fprintf(file, "FF");
				rm_counter += 32;
			}
               		location_counter += 6;
			rm_counter += 5;
			fprintf(file, "%02X",rm_counter);
			fprintf(file, "[%08X]\n",temp_sym->addr);
		}
		else{
			yyerror("Symbol is not defined\n");
		}
	}
 }
 |op1 reg {
	fprintf(file, "%08X ",location_counter);
	
        if(strcmp($1,"inc") == 0 | strcmp($1,"dec") == 0){
		int base_opcode = 0;
		if(strcmp($1,"inc") == 0){
			base_opcode = 64;
		}
		else{
			base_opcode = 72;
		}	
		location_counter += 1;
		rm_counter = base_opcode +  reg_value_counter($2);
        }
	else if(strcmp($1,"mul") == 0 | strcmp($1,"div") == 0){
		rm_counter = 192;
		fprintf(file, "F7");
		location_counter += 2;
		if(strcmp($1,"mul") == 0)
			rm_counter += 32;
		else
			rm_counter += 48;
		rm_counter += reg_value_counter($2);
        }
	else if(strcmp($1,"jmp") == 0){
		rm_counter = 192;
		fprintf(file, "FF");
		location_counter += 2;
		rm_counter += 32;
		rm_counter += reg_value_counter($2);
	}
	fprintf(file, "%02X\n",rm_counter);
 }
 |op0 {
 }
 |sym colon {
	sprintf(symbol_values+offset,"%d",location_counter);
	insert_node(location_counter,'t',$1,strdup(symbol_values),'4');
 }
 |sym db init {
	insert_node(location_counter,'d',$1,strdup(symbol_values),'4');
	location_counter += (offset/2);
	memset(symbol_values, 0, sizeof(symbol_values));
	offset = 0;
 }
 |sym dd init {
	insert_node(location_counter,'d',$1,strdup(symbol_values),'4');
	location_counter += (offset/2);
	memset(symbol_values, 0, sizeof(symbol_values));
	offset = 0;
 }
 |sym resb value {
	fprintf(file, "\n%08X ",location_counter);
	insert_node(location_counter,'b',$1,NULL,'1');
	fprintf(file, "<res %Xh>",atoi($3));
	location_counter += atoi($3);
 }
 |sym resd value {
	fprintf(file, "\n%08X ",location_counter);
	insert_node(location_counter,'b',$1,NULL,'4');
	fprintf(file, "<res %Xh>",(4*atoi($3)));
	location_counter += (4*atoi($3));
 }
 |section {
	location_counter = 0;
	fprintf(file, "\n");
 }
 |
 ;
init:string {
    	int i = 1;
	fprintf(file, "\n%08X ",location_counter);
	while($1[i] != '\"')
	{
		sprintf(symbol_values+offset,"%02X",$1[i]);
		offset += 2;
		fprintf(file, "%X",$1[i]);
		i++;
 	}
}
 |value {
	int i = 0,k=atoi($1);
	fprintf(file, "\n%08X ",location_counter);
	if(flag == 0){
		fprintf(file, "%02X ",atoi($1));
		i = 1;
	}
	else if(flag == 1){
		fprintf(file, "%08X ",atoi($1));	
		i = 4;
	}
	for(int j=0;j<i;j++){
		sprintf(symbol_values+offset,"%02X",*(((unsigned char*)&k)+j));
		offset += 2;
	}
 }
 |init comma value {
	int i = 0,k=atoi($3);
	if(flag == 0){
		fprintf(file, "%02X ",atoi($3));
		i = 1;
	}
	else if(flag == 1){
		fprintf(file, "%08X ",atoi($3));	
		i = 4;
	}
	for(int j=0;j<i;j++){
		sprintf(symbol_values+offset,"%02X",*(((unsigned char*)&k)+j));
		offset += 2;
	}
 }
 |init comma string {
    	int i = 1;
	while($3[i] != '\"')
	{
		sprintf(symbol_values+offset,"%02X",$3[i]);
		offset += 2;
		fprintf(file, "%X",$3[i]);
		i++;
 	}
 }  
 ;
mem:start_mem sym end_mem {
	temp_sym  = search($2);
	rm_counter = 0;
	isReg = 0;
 }
 |start_mem reg end_mem {
	rm_counter = reg_value_counter($2);
	isReg = 1;
 }
 ;
%%

int reg_value_counter(char* reg_name){
	if(strcmp("eax", reg_name) == 0) return 0;
	else if(strcmp("ecx", reg_name) == 0) return 1;
	else if(strcmp("edx", reg_name) == 0) return 2;
	else if(strcmp("ebx", reg_name) == 0) return 3;
	else if(strcmp("esp", reg_name) == 0) return 4;
	else if(strcmp("ebp", reg_name) == 0) return 5;
	else if(strcmp("esi", reg_name) == 0) return 6;
	else if(strcmp("edi", reg_name) == 0) return 7;
}
sym_table* create_node(){
	sym_table* new_node = (sym_table*)malloc(sizeof(sym_table));
	new_node -> next = NULL;	
	return new_node;
}

void insert_node(int addr, char section_type, char* name, char* val,char size){
	sym_table* prev = NULL;
	sym_table* current_node = head;
	if(search(name) == NULL){
		if(current_node == NULL){
			head = create_node();
			head->addr = addr;
			head->section_type = section_type;
			head->name = name;
			head->val = val;
			head->size = size;
		}
		else{
			while(current_node != NULL){
				prev = current_node;
				current_node = current_node->next;
			}
			prev->next = create_node();
			prev->next->addr = addr;
			prev->next->section_type = section_type;
			prev->next->name = name;
			prev->next->val = val;
			prev->next->size = size;
		}
	}
	else{
		current_node = search(name);
		if(current_node->section_type == 'u'){
			current_node->section_type = section_type;
			current_node->addr = addr;
			current_node->val = val;
		}
		else{
			fprintf(file, "Symbol already exists in %c section with %d address and %s value",current_node->section_type,current_node->addr,current_node->val);	
		}
	}
}

sym_table* search(char* name){
	sym_table* current_node = head,*output = NULL;
	while(current_node != NULL){
		if(strcmp(current_node->name, name) == 0){
		       output =  current_node;
		} 
		current_node = current_node->next;
	}
	return output;
}

void print_table(){
	sym_table* current_node = head;
	while(current_node != NULL){
		fprintf(file, "%08X\t%c\t%s\t%s\t%c\n",current_node->addr,current_node->section_type,current_node->name,current_node->val,current_node->size);
		current_node = current_node->next;
	}	
}

forward_data* create(){
        forward_data* new_node = (forward_data*)malloc(sizeof(forward_data));
        new_node->next = NULL;
        return new_node;
}

void insert(int loc_cnt, char* name, unsigned long file_ptr){
        forward_data* prev = NULL;
        forward_data* current_node = start;
        if(current_node == NULL){
                start = create();
                start->loc_cnt = loc_cnt;
                start->name = name;
                start->file_ptr = file_ptr;
        }
        else{
                while(current_node != NULL){
                        prev = current_node;
                        current_node = current_node->next;
                }
                prev->next = create();
                prev->next->loc_cnt = loc_cnt;
                prev->next->name = name;
                prev->next->file_ptr = file_ptr;
        }
}

forward_data* search_data(char* name){
        forward_data* current_node = start,*output = NULL;
        while(current_node != NULL){
                if(strcmp(current_node->name, name) == 0){
                       output =  current_node;
                }
                current_node = current_node->next;
        }
        return output;
}
void print(){
        forward_data* current_node = start;
        while(current_node != NULL){
	fprintf(file, "done\n");
                fprintf(file, "%d\t%s\t%lu\n",current_node->loc_cnt,current_node->name,current_node->file_ptr);
                current_node = current_node->next;
        }
}

void yyerror(char*){
	yyparse();
}
int main(){
	file = fopen("p.lst","rb+");
	if(file == NULL){
		perror("file cannot open\n");
		return 1;
	} 
	yyparse();	
	fprintf(file, "\n-------------------------SYMBOL TABLE----------------------------------------------\n");
	print_table();
	fprintf(file, "\n-------------------------Forward----------------------------------------------\n");
	print();
	forward_data* current = start;
	while(current){
		sym_table* new = head;
		while(new){
			if(strcmp(new->name ,current->name) == 0 && new->section_type != 'u'){
				fseek(file, current->file_ptr ,SEEK_SET);
				fprintf(file, "%02hhX\n",new->addr-current->loc_cnt);
				break;
			}
			new = new->next;
		}
		if(new == NULL){
			yyerror("Symbol is used but not defined\n");
		}
		current = current->next;
	}
	sym_table* new = head;
	while(new){
		if(new->section_type == 'u')
		{
			yyerror("Symbol is used but not defined\n");
		}
		new = new->next;
	}	
	fclose(file);
	return 0;
}
