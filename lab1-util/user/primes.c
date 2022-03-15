#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc,char* argv[]){
	int pid,pl[2];
	if(pipe(pl) < 0){
		fprintf(2,"pipe error\n");
		exit(1);
	}
	if((pid = fork()) < 0){
		fprintf(2,"fork error\n");
		exit(1);
	}
	else if(pid == 0){
		close(pl[1]);
		int prime = 0,n,pr[2];
		int first = 1;
		while(read(pl[0],&n,1) != 0){
			if(prime == 0){
				prime = n;
				printf("prime %d\n",prime);
			}
			else if(first){
				first = 0;
				pipe(pr);
				if(fork() == 0){
					first = 1;
					prime = 0;
					pl[0] = pr[0];
					close(pr[1]);
				}
				else
					close(pr[0]);
			}
			if(prime != 0 && n % prime != 0){
				write(pr[1],&n,1);
			}
		}
		close(pr[1]);
		close(pl[0]);
		wait(0);
		exit(0);
	}
	close(pl[0]);
	for(int i = 2 ;i <= 35 ;i++){
		write(pl[1],&i,1);
	}
	close(pl[1]);
	wait(0);
	exit(0);
}
