#include<stdio.h>
#include<stdlib.h>
#include<string.h>

typedef struct sym_table{
	int addr;
	char section_type;
	char* name;
	char* val;
	char size;
	struct sym_table* next;
} sym_table;

typedef struct forward_data{
        int loc_cnt;
        char* name;
        unsigned long file_ptr;
        struct forward_data* next;
} forward_data;

void insert(int loc_cnt, char* name, unsigned long file_ptr);
forward_data* search_data(char* name);
void print();
int reg_value_counter(char* reg_name);
sym_table* create_node();
void insert_node(int addr, char section_type, char* name, char* val,char size);
sym_table* search(char* name);
