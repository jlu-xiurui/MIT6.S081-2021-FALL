#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

int main(int argc,char* argv[]){
	char buf[12];
	int i = 2;
	if(argc < 3){
		fprintf(2,"xargs <function> <args>\n");
		exit(1);
	}
	char* new_argv[MAXARG];
	new_argv[0] = argv[1];
	while(argv[i] != 0){
		new_argv[i-1] = argv[i];
		if(i > MAXARG - 1){
			fprintf(2,"too many args\n");
			exit(1);
		}
		i++;
	}
	new_argv[i] = 0;
	char c,*p = buf;
	while(read(0,&c,1) != 0){
		if(c == '\n'){
			*p = '\0';
			new_argv[i-1] = buf;
			if(fork() == 0){
				exec(new_argv[0],new_argv);
				exit(0);
			}
			wait(0);
			p = buf;
		}
		else
			*p++ = c;
	}	
	exit(0);


}
