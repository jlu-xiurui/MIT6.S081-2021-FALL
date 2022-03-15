#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

#define BUFSIZE 512
static char target[DIRSIZ];
static char path[BUFSIZE];
static void search(void);

char* fmtname()
{
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
	  return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), 0, DIRSIZ-strlen(p));
  return buf;
}
int main(int argc,char* argv[]){
	if(argc != 3){
		fprintf(2,"find <pathname> <filename>\n");
		exit(1);
	}
	strcpy(path,argv[1]);
	strcpy(target,argv[2]);
	search();
	exit(0);
}
static void search(void){
	char* p;
	int fd;
	struct dirent de;
	struct stat st;
	if((fd = open(path,0)) < 0){
		fprintf(2,"open err\n");
		exit(1);
	}
	if(fstat(fd,&st) < 0){
		fprintf(2,"fstat err\n");
		exit(1);
	}
	
	switch(st.type){
	case T_FILE:
		if(!strcmp(target,fmtname())){
			printf("%s\n",path);
		}
		break;
	case T_DIR:
		p = path + strlen(path);
		*p++ = '/';
		while(read(fd,&de,sizeof(de)) == sizeof(de)){
			if(de.inum == 0)
				continue;
			memmove(p,de.name,DIRSIZ);
			p[DIRSIZ] = 0;
			if(strcmp(p,".") && strcmp(p,".."))
				search();
			memset(p,0,DIRSIZ);
		}
	}
	close(fd);
}
