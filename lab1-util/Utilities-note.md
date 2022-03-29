# Lab Utilities

本实验要求实验者基于xv6的函数接口，实现一系列的用户级程序，需要实验者对于进程行为（如fork,exec,wait对进程的影响等）有一定的理解，总体难度不大。

## 实验代码及讲解

### sleep(easy)

```
  1 #include "kernel/types.h"
  2 #include "kernel/stat.h"
  3 #include "user/user.h"
  4 
  5 int main(int argc,char* argv[]){
  6     if(argc != 2){
  7         fprintf(2,"sleep <arg>\n");
  8         exit(1);
  9     }
 10     int time = atoi(argv[1]);
 11     if(sleep(time) < 0){
 12         fprintf(2,"sleep err\n");
 13         exit(1);
 14     }
 15     exit(0);
 16 }
```

借用`sleep`系统调用接口实现用户端的`sleep`程序，考察对于主函数参数`argc`及`argv`的使用，其中`argc`代表参数个数、`argv`代表参数的字符串表示，值得注意的是程序名也包括在参数之中。

### pingpong(easy)

```
  1 #include "kernel/types.h"
  2 #include "kernel/stat.h"
  3 #include "user/user.h"
  4 
  5 int main(int argc,char* argv[]){
  6     int p[2],pid;
  7     if(pipe(p) < 0){
  8         fprintf(2,"pipe err\n");
  9         exit(1);
 10     }
 11     if((pid = fork()) < 0){
 12         fprintf(2,"fork err\n");
 13         exit(1);
 14     }
 15     else if(pid == 0){
 16         char buf;
 17         close(p[0]);
 18         read(p[1],&buf,1);
 19         printf("%d: received ping\n",getpid(),buf);
 20         write(p[1],&buf,1);
 21         close(p[1]);
 22         exit(0);
 23     }
 24     char buf = 'z';
 25     close(p[1]);
 26     write(p[0],&buf,1);
 27     read(p[0],&buf,1);
 28     printf("%d: received pong\n",getpid(),buf);
 29     close(p[0]);
 30     exit(0);
 31 
 32 }
```

本函数的功能是，将一个字节的数据在父子进程之间传输，当父进程或子进程收到该字节时，打印其PID和一串消息。考察了对于进程通信方式（IPC）—— 管道的理解及使用。事实上 `pipe` 函数的作用仅为构造一对双工相连的文件描述符，在调用 `fork` 后，这一对文件描述符在父子进程中被共享，因此即可通过这对文件描述符实现父子进程的进程间通信，其工作示意图如下（摘自APUE）：

![figure1](https://github.com/jlu-xiurui/MIT6.S081-2021-FALL/blob/master/lab1-util/figure1.png)

具体实现方式比较简单，在`pipe` 和 `fork`被调用后，在父子进程中分别关闭不同的文件描述符后，父子进程即可通过这对文件描述符进行通信，父子进程分别调用 `read` 和 `write` 传递信息即可。

### primes(moderate/hard)

```
  1 #include "kernel/types.h"
  2 #include "kernel/stat.h"
  3 #include "user/user.h"
  4 
  5 int main(int argc,char* argv[]){
  6     int pid,pl[2];
  7     if(pipe(pl) < 0){
  8         fprintf(2,"pipe error\n");
  9         exit(1);
 10     }
 11     if((pid = fork()) < 0){
 12         fprintf(2,"fork error\n");
 13         exit(1);
 14     }
 15     else if(pid == 0){
 16         close(pl[1]);
 17         int prime = 0,n,pr[2];
 18         int first = 1;
 19         while(read(pl[0],&n,1) != 0){
 20             if(prime == 0){
 21                 prime = n;
 22                 printf("prime %d\n",prime);
 23             }
 24             else if(first){
 25                 first = 0;
 26                 pipe(pr);
 27                 if(fork() == 0){
 28                     first = 1;
 29                     prime = 0;
 30                     pl[0] = pr[0];
 31                     close(pr[1]);
 32                 }
 33                 else
 34                     close(pr[0]);
 35             }
 36             if(prime != 0 && n % prime != 0){
 37                 write(pr[1],&n,1);
 38             }
 39         }
 40         close(pr[1]);
 41         close(pl[0]);
 42         wait(0);
 43         exit(0);
 44     }
 45     close(pl[0]);
 46     for(int i = 2 ;i <= 35 ;i++){
 47         write(pl[1],&i,1);
 48     }
 49     close(pl[1]);
 50     wait(0);
 51     exit(0);
 52 }
```

本程序要求建立一个双向进程链表以打印质数。除主进程外，各进程从其父进程读取数字，第一个被读取的数字即为质数，将其打印后，将从父进程中读取的数字中**不能被该质数整除**的数传入至其子进程。主进程则将2到35之间的整数输入至其子进程。具体的工作流程和伪代码如下：

```
p = get a number from left neighbor
print p
loop:
    n = get a number from left neighbor
    if (p does not divide n)
        send n to right neighbor
```

![figure2](https://github.com/jlu-xiurui/MIT6.S081-2021-FALL/blob/master/lab1-util/figure2.png)

在本程序中，主进程和其亲子进程通过管道 `pl` 进行通信，除主进程外的所有进程都通过 `pl` 与其父进程通信（接受数据），通过 `pr` 与其子进程通信（发送数据） 。对于两个管道，`pl[0]`和`pr[0]`均为管道的输入端，`pl[1]`和`pr[1]`均为管道的输出端。显而易见的是，对于除主进程以外的进程而言，其管道 `pr` 与其子进程的管道 `pl` 为同一对象。

在这里，将主进程 `fork` 后的父进程作为整个程序的输入端，即将2至35的整数输入至其子进程；`fork`后的子进程则作为双向进程链表的构造者，其具体工作流程如下：

**15-19行：**关闭接收数据管道的输出端、初始化发送数据管道及一些局部变量（`prime`为属于当前进程的质数、`n`为数据缓冲区），然后进入无限循环等待父进程的数据；

**20-23行：**当接受来自父进程的第一个数据时，将其存储在局部变量 `prime` ，并打印相关信息；

**24-34行：**当接受来自父进程的第二个数据时，创建该进程的输出数据管道、并创建其子进程。值得注意的是，在子进程被创建时，其拥有该进程所有局部变量的副本，因此需要将局部变量重新初始化，并将其该进程的输出数据管道拷贝至其自身的接收数据管道。在创建完子进程及输出管道后，需要注意关闭该进程输出管道的接收端。

**36-39行：**对于接受的所有数据，如不能被该进程的质数所整除，都将其传送至子进程。

**40-43行：**当该进程的父进程的输出文件描述符关闭时，该进程跳出循环，在关闭其输出端、输入端后，等待其子进程结束。

**44-51行：**主进程作为整个程序的数据输入端，将2至35的整数输入至其子进程，在输入完毕后，关闭输出文件描述符，并等待其子进程结束。

## find (moderate)

该程序的功能是，通过输入**查询根目录**和**目标文件名**，寻找并打印查询根目录下所有与目标文件名的名称相同的文件，该程序由几个子函数构成，在这里分别进行讲解。

```
  1 #include "kernel/types.h"
  2 #include "kernel/stat.h"
  3 #include "user/user.h"
  4 #include "kernel/fs.h"
  5 
  6 #define BUFSIZE 512
  7 static char target[DIRSIZ];
  8 static char path[BUFSIZE];
  9 static void search(void);
 10 
...
 28 int main(int argc,char* argv[]){
 29     if(argc != 3){
 30         fprintf(2,"find <pathname> <filename>\n");
 31         exit(1);
 32     }
 33     strcpy(path,argv[1]);
 34     strcpy(target,argv[2]);
 35     search();
 36     exit(0);
 37 }
```

在这里，定义了全局变量`target`用于储存**目标文件名**、`path`用于保存**当前路径名**的字符串栈，主函数将当前路径名初始化为查询根目录，并保存目标文件名后，调用递归函数`search`。

```
 11 char* fmtname()
 12 {
 13   static char buf[DIRSIZ+1];
 14   char *p;
 15 
 16   // Find first character after last slash.
 17   for(p=path+strlen(path); p >= path && *p != '/'; p--)
 18     ;
 19   p++;
 20 
 21   // Return blank-padded name.
 22   if(strlen(p) >= DIRSIZ)
 23       return p;
 24   memmove(buf, p, strlen(p));
 25   memset(buf+strlen(p), 0, DIRSIZ-strlen(p));
 26   return buf;
 27 }
```

该函数用于提取当前路径名对应的文件名，即提取当前路径名最后一个`\`后的字符串。

```
 38 static void search(void){
 39     char* p;
 40     int fd;
 41     struct dirent de;
 42     struct stat st;
 43     if((fd = open(path,0)) < 0){
 44         fprintf(2,"open err\n");
 45         exit(1);
 46     }
 47     if(fstat(fd,&st) < 0){
 48         fprintf(2,"fstat err\n");
 49         exit(1);
 50     }
 51 
 52     switch(st.type){
 53     case T_FILE:
 54         if(!strcmp(target,fmtname())){
 55             printf("%s\n",path);
 56         }
 57         break;
 58     case T_DIR:
 59         p = path + strlen(path);
 60         *p++ = '/';
 61         while(read(fd,&de,sizeof(de)) == sizeof(de)){
 62             if(de.inum == 0)
 63                 continue;
 64             memmove(p,de.name,DIRSIZ);
 65             p[DIRSIZ] = 0;
 66             if(strcmp(p,".") && strcmp(p,".."))
 67                 search();
 68             memset(p,0,DIRSIZ);
 69         }
 70     }
 71     close(fd);
 72 }
```

利用深度优先方式，递归访问当前路径名下的所有文件，包括普通文件和目录文件。如当前路径名所对应的文件为普通文件时，如该文件名与目标文件名相同，则将当前路径打印；如当前路径名所对于的文件为目录文件时，对该目录下除 `.` 和 `..` 的所有文件递归的运行`search`函数。具体的递归方式为，将文件名压入用于储存当前路径名`path`的栈中，当以该文件作为根目录的 `search` 函数运行完后，将该文件名从栈中弹出。

## xargs (moderate)

```
  1 #include "kernel/types.h"
  2 #include "kernel/stat.h"
  3 #include "user/user.h"
  4 #include "kernel/param.h"
  5 
  6 int main(int argc,char* argv[]){
  7     char buf[12];
  8     int i = 2;
  9     if(argc < 3){
 10         fprintf(2,"xargs <function> <args>\n");
 11         exit(1);
 12     }
 13     char* new_argv[MAXARG];
 14     new_argv[0] = argv[1];
 15     while(argv[i] != 0){
 16         new_argv[i-1] = argv[i];
 17         if(i > MAXARG - 1){
 18             fprintf(2,"too many args\n");
 19             exit(1);
 20         }
 21         i++;
 22     }
 23     new_argv[i] = 0;
 24     char c,*p = buf;
 25     while(read(0,&c,1) != 0){
 26         if(c == '\n'){
 27             *p = '\0';
 28             new_argv[i-1] = buf;
 29             if(fork() == 0){
 30                 exec(new_argv[0],new_argv);
 31                 exit(0);
 32             }
 33             wait(0);
 34             p = buf;
 35         }
 36         else
 37             *p++ = c;
 38     }
 39     exit(0);
 40 
 41 
 42 }
```

该程序的功能为：将输入该程序的 `argv` 数组的除`argv[0]`的其余字符串数组，作为新的命令行参数数组（称其为`new_argv`）。每当程序从标准输入接受到一行字符串时，将该行字符串作为`new_argv`的最后一个参数，并生成子进程运行该命令。

具体实现比较简单，首先从输入参数中提取`new_argv`。并以`buf`作为存储标准输入的缓存区，当读入非`\n`字符时，将其加入`buf`；当读入`\n`时，将当前缓冲区作为`new_argv`的最后一个元素，并执行`new_argv`所对应的命令，并清空缓冲区。

## 实验结果

```
xiurui@xiurui-VirtualBox:~/xv6-labs-2020$ ./grade-lab-util 
make: “kernel/kernel”已是最新。
== Test sleep, no arguments == sleep, no arguments: OK (1.4s) 
== Test sleep, returns == sleep, returns: OK (1.0s) 
== Test sleep, makes syscall == sleep, makes syscall: OK (0.9s) 
== Test pingpong == pingpong: OK (1.1s) 
== Test primes == primes: OK (1.1s) 
== Test find, in current directory == find, in current directory: OK (1.0s) 
== Test find, recursive == find, recursive: OK (1.5s) 
== Test xargs == xargs: OK (1.4s) 
== Test time == 
time: OK 
Score: 100/100
```

