# Lab Syscall

本实验需要为xv6操作系统添加两个新的系统调用，以帮助实验者进一步了解和掌握用户层调用系统调用时，内核所完成的任务及其细节。

## 系统调用的过程

当用户层调用`fork`、`exec`等需要内核处理的函数时，即产生了相应的系统调用，控制流从用户层转移至内核层，当内核对系统调用处理完毕后，控制流重新返回用户层。从用户层的角度来看，系统调用和函数调用是类似的，这一特点使得用户在不用了解内核行为的前提下，完成一定的特权级操作，如I/0、进程创建等。

在xv6操作系统中，系统调用通过如下的行为实现：当用户调用系统调用函数时，执行的并不是某一段与系统调用函数同名的C函数，而是跳转至对应的汇编语句。通过汇编语句，将相应的系统调用号存储至寄存器`a7`，并调用`ecall`函数，如下代码段所示：

```
... C
  3 .global fork
  4 fork:
  5 	li a7, SYS_fork
  6 	ecall
  7 	ret
  8 .global exit
  9 exit:
 10 	li a7, SYS_exit
 11 	ecall
 12 	ret
...
```

当`ecall`被调用时，用户陷入陷阱（`trap`）进入内核层。在本实验中，对于陷阱的行为仅需知道以下几点。

1. 陷入陷阱时，`uservec(kernel/trampoline.S:16)` 被调用，用户寄存器被保存至`trapframe`中，由于在函数调用时，调用参数被存放在在寄存器中，因此使得内核对用户系统调用的参数是可见的。
2. 在`uservec`的结尾处，`usertrap (kernel/trap.c:37)`被调用。在该函数中，内核检测产生陷阱的原因（硬件中断、系统调用或异常），当陷阱原因为系统调用时，`syscall (kernel/syscall.c:133)`被调用以处理系统调用，最后内核通过`usertrapret (kernel/trap.c:90)`返回至用户态。

```C
161 void
162 syscall(void)
163 {
164   int num;
165   struct proc *p = myproc();
166 
167   num = p->trapframe->a7;
168   if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
169     p->trapframe->a0 = syscalls[num]();
170     if(p->tracemask & (1<<num))
171         printf("%d: syscall %s -> %d\n",p->pid,syscall_name[num],p->trapframe->a0);
172   } else {
173     printf("%d %s: unknown sys call %d\n",
174             p->pid, p->name, num);
175     p->trapframe->a0 = -1;
176   }
177 }
```

在`syscall`中，系统调用号通过存放在`trapframe`中的寄存器`a7`被取出，并被作为系统调用表`syscalls`的索引，以寻找所需的系统调用函数，并对其进行调用。其中，系统调用表`syscalls`是一个函数指针数组，其定义如下：

```C
110 static uint64 (*syscalls[])(void) = {
111 [SYS_fork]    sys_fork,
112 [SYS_exit]    sys_exit,
113 [SYS_wait]    sys_wait,
114 [SYS_pipe]    sys_pipe,
115 [SYS_read]    sys_read,
116 [SYS_kill]    sys_kill,
117 [SYS_exec]    sys_exec,
118 [SYS_fstat]   sys_fstat,
119 [SYS_chdir]   sys_chdir,
120 [SYS_dup]     sys_dup,
121 [SYS_getpid]  sys_getpid,
122 [SYS_sbrk]    sys_sbrk,
123 [SYS_sleep]   sys_sleep,
...
134}
```

在这里运用了一种比较独特的数组定义方式，在其中的一行中，中括号内的常数代表了元素索引，其后的变量即为被存放在数组中的元素。例如，第一行中的`[SYS_fork]  sys_fork`代表数组的第 `SYS_fork` 个元素为`sys_fork`。以`SYS`开头的一系列数据为在`syscall.h`中定义的常数宏，以`sys`开头的一系列函数为在 `sysproc.c` 中被定义的实际系统调用函数。

在`sysproc.c`中，实际的系统调用行为被完成，值得注意的是，用户传入系统调用函数的参数通过 `argraw` 被从 `trapframe` 中提取：

```C
 34 static uint64
 35 argraw(int n)
 36 {
 37   struct proc *p = myproc();
 38   switch (n) {
 39   case 0:
 40     return p->trapframe->a0;
 41   case 1:
 42     return p->trapframe->a1;
 43   case 2:
 44     return p->trapframe->a2;
 45   case 3:
 46     return p->trapframe->a3;
 47   case 4:
 48     return p->trapframe->a4;
 49   case 5:
 50     return p->trapframe->a5;
 51   }
 52   panic("argraw");
 53   return -1;
 54 }
```

## 实验代码及讲解

在本实验中，我们需要添加 `trace` 和 `sysinfo` 两个系统调用，合理的解决思路是跟随系统调用的控制流流程，对xv6源码进行增加。

### trace(moderate)

首先，我们需要在`user/user.h`中声明用户函数`tarce`:

```C
26 int trace(int);
```

在本部分，需要通过添加 `trace` 系统调用，使得 `user/trace.c` 中的函数生效：

```C
  6 int
  7 main(int argc, char *argv[])
  8 {
  9   int i;
 10   char *nargv[MAXARG];
 11 
 12   if(argc < 3 || (argv[1][0] < '0' || argv[1][0] > '9')){
 13     fprintf(2, "Usage: %s mask command\n", argv[0]);
 14     exit(1);
 15   }
 16 
 17   if (trace(atoi(argv[1])) < 0) {
 18     fprintf(2, "%s: trace failed\n", argv[0]);
 19     exit(1);
 20   }
 21 
 22   for(i = 2; i < argc && i < MAXARG; i++){
 23     nargv[i-2] = argv[i];
 24   }
 25   exec(nargv[0], nargv);
 26   exit(0);
 27 }
```

本函数的功能是输入一个掩码（`argv[1]`）和另一组命令行参数列表（`argv[2],argv[3]...`），使得在执行该命令行参数列表所代表的程序时，与掩码相应位对应的系统调用被调用时打印相关信息。为了使得该函数生效，我们需要构造系统调用`sys_trace`，使得该掩码传入至内核中该进程所对应的进程控制块。为此，我们需要在 `kernel/proc.h` 中为进程控制块结构添加新的元素：

```C
 86 struct proc {
 87   struct spinlock lock;
 88 
 89   // p->lock must be held when using these:
 90   enum procstate state;        // Process state
 91   struct proc *parent;         // Parent process
 92   void *chan;                  // If non-zero, sleeping on chan
 93   int killed;                  // If non-zero, have been killed
 94   int xstate;                  // Exit status to be returned to parent's wai    t
 95   int pid;                     // Process ID
 96 
 97   // these are private to the process, so p->lock need not be held.
 98   uint32 tracemask;            // the mask for trace.c to print info
 99   uint64 kstack;               // Virtual address of kernel stack
100   uint64 sz;                   // Size of process memory (bytes)
101   pagetable_t pagetable;       // User page table
102   struct trapframe *trapframe; // data page for trampoline.S
103   struct context context;      // swtch() here to run process
104   struct file *ofile[NOFILE];  // Open files
105   struct inode *cwd;           // Current directory
106   char name[16];               // Process name (debugging)
107 };
```

在这里，添加了32位无符号数 `tracemask` 以存放 `trace` 掩码。同时，在 `fork` 函数中，应当使得子进程的进程控制块继承父进程的掩码：

```
...C
283  // copy the tracemask to the child
284  np->tracemask = p->tracemask;
...
```

接下来，让我们跟随系统调用流程，对xv6源码进行添加。在系统调用发生时，用户层函数被映射至 `user/usys.S` 中的汇编语句，因此我们需要更改产生该汇编代码的文件 `user/usys.pl`：

```C
  9 sub entry {
 10     my $name = shift;
 11     print ".global $name\n";
 12     print "${name}:\n";
 13     print " li a7, SYS_${name}\n";
 14     print " ecall\n";
 15     print " ret\n";
 16 }
 17 
 18 entry("fork");
 19 entry("exit");
 20 entry("wait");
 21 entry("pipe");
 22 entry("read");
 23 entry("write");
 24 entry("close");
 25 entry("kill");
 26 entry("exec");
 27 entry("open");
 28 entry("mknod");
 29 entry("unlink");
 30 entry("fstat");
 31 entry("link");
 32 entry("mkdir");
 33 entry("chdir");
 34 entry("dup");
 35 entry("getpid");
 36 entry("sbrk");
 37 entry("sleep");
 38 entry("uptime");
 39 entry("trace");
 40 entry("sysinfo");
```

在这里，另一个系统调用 `sysinfo` 也被添加至此，在下文中不对上述相同流程进行介绍。通过 `ecall` 语句，控制流陷入内核，内核对陷阱进行检查后调用 `syscall` 函数。为了添加新的系统调用，我们需要在 `syscall.c` 中将 `sysproc.c` 中的实际系统调用函数在该文件中声明，并且修改系统调用表：

```
...C
105 extern uint64 sys_write(void);
106 extern uint64 sys_uptime(void);
107 extern uint64 sys_trace(void);
108 extern uint64 sys_sysinfo(void);
...
110 static uint64 (*syscalls[])(void) = {
111 [SYS_fork]    sys_fork,
...
132 [SYS_trace]   sys_trace,
133 [SYS_sysinfo] sys_sysinfo,
134 };
```

需要注意将新加入的系统调用号在`syscall.h`中声明。在 `sysproc.c` 中，构造 `sys_trace` 以将用户掩码添加至进程控制块：

```C
100 // set the tracemask
101 uint64
102 sys_trace(void){
103     int n;
104     if(argint(0,&n) < 0)
105         return -1;
106     myproc()->tracemask = n;
107     return 0;
108 }
```

在完成了 `trace` 系统调用之后，我们可以将掩码传入内核，接下来就是思考如何在系统调用时打印跟踪信息了。在这里，我们需要修改系统调用的主函数 `syscall` ，使得当系统调用被执行时，检查相应掩码位是否被设置，当掩码位被设置时，打印相关信息：

```C
136 static char* syscall_name[] = {
137 [SYS_fork]    "fork",
138 [SYS_exit]    "exit",
139 [SYS_wait]    "wait",
140 [SYS_pipe]    "pipe",
141 [SYS_read]    "read",
142 [SYS_kill]    "kill",
143 [SYS_exec]    "exec",
144 [SYS_fstat]   "fstat",
145 [SYS_chdir]   "chdir",
146 [SYS_dup]     "dup",
147 [SYS_getpid]  "getpid",
148 [SYS_sbrk]    "sbrk",
149 [SYS_sleep]   "sleep",
150 [SYS_uptime]  "uptime",
151 [SYS_open]    "open",
152 [SYS_write]   "write",
153 [SYS_mknod]   "mknod",
154 [SYS_unlink]  "unlink",
155 [SYS_link]    "link",
156 [SYS_mkdir]   "mkdir",
157 [SYS_close]   "close",
158 [SYS_trace]   "trace",
159 [SYS_sysinfo] "sysinfo",
160 };
161 void
162 syscall(void)
163 {
164   int num;
165   struct proc *p = myproc();
166 
167   num = p->trapframe->a7;
168   if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
169     p->trapframe->a0 = syscalls[num]();
170     if(p->tracemask & (1<<num))
171         printf("%d: syscall %s -> %d\n",p->pid,syscall_name[num],p->trapframe->a0);
172   } else {
173     printf("%d %s: unknown sys call %d\n",
174             p->pid, p->name, num);
175     p->trapframe->a0 = -1;
176   }
177 }
```

### sysinfo(moderate)

```C
  1 struct sysinfo {
  2   uint64 freemem;   // amount of free memory (bytes)
  3   uint64 nproc;     // number of process
  4 };
```

在此部分，我们需要设计 `sysinfo` 函数，使得内核填写用户传入的 `struct sysinfo*` 指针所对应结构中的系统进程数和系统空闲内存数。首先，我们需要在`user/user.h`中声明用户函数`sysinfo` 以及结构 `sysinfo`:

```C
 3 struct sysinfo;
...
 27 int sysinfo(struct sysinfo*);
```

在这里，从用户层进入内核层的陷阱过程与上部分相同，在此不再赘述，我们直接进行系统调用的实现部分。为了提取系统进程数和系统空闲内存数，我们需要在负责遍历进程列表的 `proc.c` 和空闲内存页链表的 `kalloc.c` 文件中增加新的功能函数。

在xv6中，进程的信息是被`proc.c`中的进程列表所保存的：

```C
 11 struct proc proc[NPROC];
```

为了提取系统进程数，我们仅需遍历该进程列表，寻找状态 `state` 不为 `UNUSERD` 的进程即可：

```C
701 // lab2 syscall : get the nproc
702 uint64
703 getnproc(void){
704     struct proc* p;
705     uint64 ret = 0;
706     for(p = proc; p < &proc[NPROC]; p++) {
707         if(p->state != UNUSED){
708             ret++;
709         }
710     }
711     return ret;
712 }
```

在xv6中，空闲的内存块被组织成空闲内存页链表，其中的每个内存块的大小均为`PGSIZE`字节，即为页大小。在这里，我们遍历链表，记录结点个数即可，需要注意遍历前后对链表加删锁：

```C
 84 //lab2 syscall : get the freemem
 85 uint64
 86 getfreemem(void){
 87     struct run *r;
 88     uint64 ret = 0;
 89     acquire(&kmem.lock);
 90     r = kmem.freelist;
 91     while(r){
 92         ret += PGSIZE;
 93         r = r->next;
 94     }
 95     release(&kmem.lock);
 96     return ret;
 97 }
```

有了这两个功能函数，我们仅需实现 `sysproc.c` 中的实际系统调用函数即可，注意在该文件出导入 `sysinfo.h` 头文件，并且在`kernel/def.h` 中声明`struct sysinfo` 以及以上两个功能函数：

```C
110 // get the freemem and nproc
111 uint64
112 sys_sysinfo(void){
113     uint64 addr; // user pointer to sysinfo
114     if(argaddr(0,&addr) < 0)
115         return -1;
116     struct sysinfo si;
117     struct proc *p = myproc();
118     si.freemem = getfreemem();
119     si.nproc = getnproc();
120     if(copyout(p->pagetable,addr,(char *)&si,sizeof(si)) < 0)
121         return -1;
122     return 0;
123 }
```

在本函数中，通过 `argaddr` 提取存放在 `trapframe` 中被用户传入的指针，并构造 `sysinfo` 结构，调用上述两个功能函数填充结构。最后，调用 `copyout` 将结构复制至内核地址空间即可。

## 实验结果

调用`make grade` ，可以得到以下输出

```
== Test trace 32 grep == 
$ make qemu-gdb
trace 32 grep: OK (3.4s) 
== Test trace all grep == 
$ make qemu-gdb
trace all grep: OK (1.1s) 
== Test trace nothing == 
$ make qemu-gdb
trace nothing: OK (0.9s) 
== Test trace children == 
$ make qemu-gdb
trace children: OK (11.6s) 
== Test sysinfotest == 
$ make qemu-gdb
sysinfotest: OK (2.0s) 
== Test time == 
time: OK 
Score: 35/35
```
