%{
#include <stdlib.h>
#include <string.h>
#include "malloc.h"

#define TRUE 1
#define FALSE 0

int curr_temp_reg = 0;
int block_num = 0;
int* engaged_temp_reg;
int size = 0;
char* bit;
int left = 0;
int right = 0;

int lines_cnt = 0;
%}

%union {
	char* value;
	int numb;
}

%token assign semicolon IF EL 
%token l_cbr r_cbr l_fbr r_fbr
%token <value> CONST var bitwise MARK
%token <value> bin_arithm
%type <numb> assigned bitwise_op

%%
lines:	if_operation
	| if_operation lines
	| else_operation
	| else_operation lines
	;

if_operation:	IF condition if_body
		| IF cond_one if_body_one
		;

condition: l_cbr assigned bitwise assigned r_cbr {
							left = $<value>2;
							bit = $<value>3;
							right = $<value>4;
						}
	    | l_cbr assigned assign assigned r_cbr {
	     						printf("ОШИБКА: в условии могут использоваться только bitwise операторы\n");
	     						printf("Завершение программы\n");
	     						exit(-1);
	     					 }
	    | assigned bitwise assigned {
	     						printf("ОШИБКА: условие должно быть в круглых скобках\n");
	     						printf("Завершение программы\n");
	     						exit(-1);
	     					 }
	     ;
	     
cond_one: l_cbr assigned r_cbr {
							left = $<value>2;
						}
	    
	     ;	
	     
if_body_one: l_fbr {	printf("\nНАЧАЛО БЛОКА %d-ОГО УРОВНЯ. УСЛОВИЕ: IF (R%d) == TRUE\n", block_num, left);
			printf("<НАЧАЛО БЛОКА IF %d>\n", block_num++);
		}
	  | if_body_one operation
	  | if_body_one r_fbr {
	  			printf("<КОНЕЦ БЛОКА IF %d>\n\n", --block_num);
	  		   }
	  ;	     
	     
else_operation:	EL else_body
		| EL condition else_body {
				printf("ОШИБКА: у ELSE не должно быть условия\n");
				printf("Завершение программы\n");
	     			exit(-1);
		}
		;	     

if_body: l_fbr {	printf("\nНАЧАЛО БЛОКА %d-ОГО УРОВНЯ. УСЛОВИЕ: IF (R%d %s R%d) == TRUE\n", block_num, left, bit, right);
			printf("<НАЧАЛО БЛОКА IF %d>\n", block_num++);
		}
	  | if_body operation
	  | if_body r_fbr {
	  			
	  			printf("<КОНЕЦ БЛОКА IF %d>\n\n", --block_num);
	  		   }
	  ;

else_body: l_fbr {	printf("\nНАЧАЛО БЛОКА %d-ОГО УРОВНЯ. УСЛОВИЕ: FALSE\n", block_num);
			printf("<НАЧАЛО БЛОКА ELSE %d>\n", block_num++);
		}
	  | else_body operation
	  | else_body r_fbr {
	  			printf("<КОНЕЦ БЛОКА ELSE %d>\n\n", --block_num);
	  		   }
	  ;	

operation: var assign bitwise_op semicolon {
					printf("SET %s = R%d\n", $1, $3);
				   }
	 | var assign assigned semicolon {
					printf("SET %s = R%d\n", $1, $3);
				   }
	 | var assign assigned bin_arithm assigned semicolon {
					printf("ОШИБКА: к идентификатору не должнa присваиваться арифметичексая операция\n");
	    				printf("Завершение программы\n");
	    				exit(-1);
				   }

	    | CONST assign assigned semicolon {
	    				printf("ОШИБКА: к константе нельзя присваивать значение\n");
	    				printf("Завершение программы\n");
	    				exit(-1);
	    			       }
	    | CONST assign bitwise_op semicolon {
	    				printf("ОШИБКА: к константе нельзя присваивать значение\n");
	    				printf("Завершение программы\n");
	    				exit(-1);
	    			       }			 
	    | bitwise_op assign bitwise_op semicolon {
	    				printf("ОШИБКА: к bitwise операции нельзя присваивать значение\n");
	    				printf("Завершение программы\n");
	    				exit(-1);
	    				 }
	    | bitwise_op assign assigned semicolon {
	    				printf("ОШИБКА: к bitwise операции нельзя присваивать значение\n");
	    				printf("Завершение программы\n");
	    				exit(-1);
	    				 }
	;

bitwise_op: assigned bitwise assigned {
					$$ = curr_temp_reg;
					printf("R%d = R%d %s R%d\n", curr_temp_reg++, $1, $2, $3);
				     }
	  ;

assigned: var {
		$$ = curr_temp_reg;
		printf("R%d = GET %s\n", curr_temp_reg++, $1);
	     }
	   | CONST {
	   		$$ = curr_temp_reg;
	   		printf("R%d = %d\n", curr_temp_reg++, $1);
	   	   }
	   ;
%%
int yydebug = 1;
