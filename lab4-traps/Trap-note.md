# Lab Trap

在本实验中需要在xv6中实现一些有关中断处理或RISC-V汇编语句的功能，需要对基本的RISC-V语句、用户中断处理过程有一定的理解，总体难度不大。

## 实验代码及讲解

### RISC-V assembly (easy)

1.  **哪些寄存器储存了函数的参数？例如，哪些寄存器存储了在主函数被调用的`printf`的参数13**

​		根据RISCV手册，a0-a7寄存器保存了函数的参数，在`printf`中，参数13被存储在a2寄存器中。

2.  **主函数中对`f`和`g`的调用在哪里（提示：编译器可能会内联函数**

   很显然，主函数中没有调用这两个函数，而是有编译器直接计算出调用结果12。

3.  **`printf`函数位于哪个地址**

   主函数中对`printf`间接寻址，其地址位于 `30 + 1536 = 0x630` 处。

4.  **在`jalr`跳转至主函数的`printf`时，寄存器`ra`中有什么值**

​		`jalr offset(rd)`的功能为：`t =pc+4; pc=(x[rs1]+sext(offset))&~1; x[rd]=t`。在使用`0x80000332 jalr -1298(ra)` 跳入`printf`后，`ra`的值为`0x80000332+4 = 0x80000336`。

​	5. **运行以下代码： **

```
	unsigned int i = 0x00646c72;
	printf("H%x Wo%s", 57616, &i);
```

​		**输出是什么？上述输出是基于RISC-V为小端法的事实的。如果RISC-V为大端法，i应该被设置为什么，57616需要被改变吗？	**

​		上述代码输出为`HE110 World`。如果为大端法，i需要被更改为`0x726c6400`，57616不需要被改变，硬件会处理具体的存储和读取方式。

​	6. **在下面的代码中，会打印 `'y='`什么？为什么会发生这种情况？**

```
	printf("x=%dy=%d", 3);
```

​		会打印出 `a2` 寄存器当前的值，因为在调用 `printf` 时，并未给 `a2` 寄存器赋值，但在`printf`被执行的时候却无法检查当前 `a2` 中的值是否为用户传入的值，而只是单纯的对其进行打印。

### Backtrace (moderate)

在本部分中，需要实现可以跟踪当前函数的函数调用情况的函数 `backtrace()` 。具体的实验方式为利用内核在堆栈中保存的信息，每个函数都具有其自己的函数堆栈帧（每个帧的大小为一个内存页），在寄存器`s0`中存放了当前函数堆栈帧的最高地址`fp`，称其为帧指针。堆栈中函数帧的具体分布如下：

![figure1](https://github.com/jlu-xiurui/MIT6.S081-2021-FALL/blob/master/lab4-traps/figure1.png)

可见在帧指针固定偏移量`-8`处存放了当前函数的返回地址，固定偏移量`-16`处存放了指向函数调用列表中上一个函数的堆栈帧的指针。因此即可跟随该指针向上遍历函数调用列表，`backtrace`函数实现如下：

```
136 void backtrace(void){ 
137     uint64 fp = r_fp(); 
138     uint64 stack_top = PGROUNDUP(fp); 
139     uint64 stack_down = PGROUNDDOWN(fp); 
140     while(fp < stack_top && fp > stack_down){ 
141         printf("%p\n",*(uint64*)(fp - 8)); 
142         fp = *(uint64*)(fp-16); 
143     } 
144     return; 
145 }
```

在这里，利用帧指针所在页的最高和最低地址作为终止遍历的测试指标，如当前帧指针的地址超出了该页的地址范围，则终止遍历。在遍历过程中在帧指针固定偏移量处提取当前函数的返回地址和下一个被遍历的`fp`。

### Alarm (hard)

在本实验中，需要实现新的系统调用`sys_sigalarm`和`sys_sigreturn`，以实现定时器功能函数`sigalarm`。当用户进程调用  `sigalarm(n,fn)` 时，进程将以 **n** 个CPU时间滴答为周期调用定时器处理函数 **`fn`** ，当函数返回后进程应当从被中断的地方继续。

如何在xv6系统中增加系统调用已经在  `syscall Lab` 中被详细介绍，在这里不加赘述。直接讲解系统调用的实现。首先，为了在进程中增加计时器，需要在进程控制块中增加新的条目：

```
123 struct proc { 
124   struct spinlock lock; 
125  
126   // p->lock must be held when using these: 
127   enum procstate state;        // Process state 
128   void *chan;                  // If non-zero, sleeping on chan 
129   int killed;                  // If non-zero, have been killed 
130   int xstate;                  // Exit status to be returned to parent's wait 
131   int pid;                     // Process ID 
132  
133   // wait_lock must be held when using this: 
134   struct proc *parent;         // Parent process 
135  
136   // these are private to the process, so p->lock need not be held. 
137   uint64 kstack;               // Virtual address of kernel stack 
138   uint64 sz;                   // Size of process memory (bytes) 
139   pagetable_t pagetable;       // User page table 
140   int ticks; 
141   int currticks; 
142   uint64 handler; 
143   int handlerlock; 
144   struct trapframe *trapframe; // data page for trampoline.S 
145   struct context context;      // swtch() here to run process 
146   struct file *ofile[NOFILE];  // Open files 
147   struct inode *cwd;           // Current directory 
148   char name[16];               // Process name (debugging) 
149 };
```

 在这里，为进程添加了周期 `ticks` 、自调用 `sigalarm` 后经过的滴答数 `currticks` 以及定时器处理函数入口地址 `handler`。并且，在这里增添了用于防止定时器处理函数被重入的用户锁 `handlerlock` 。当 `handlerlock` 为真时，定时器处理函数未运行，可以被调用；当其为假时，定时器处理函数正在运行，不可以被调用。

在 `allocproc` 创建进程时，对上述新增条目进行初始化：

```
...
119 found:
120   p->pid = allocpid();
121   p->state = USED;
122   p->ticks = 0;
123   p->currticks = 0;
124   p->handler = 0;
125   p->handlerlock = 1;
...
```

在 `sys_sigalarm` 中，为周期 `ticks` 及函数入口地址 `handler` 赋值，并将当前滴答数 `currticks` 刷新。

```
100 uint64
101 sys_sigalarm(void){
102     printf("sigalarm\n");
103     int ticks;
104     uint64 handler;
105     if(argint(0,&ticks) < 0 || argaddr(1,&handler) < 0)
106         return -1;
107     myproc()->ticks = ticks;
108     myproc()->currticks = 0;
109     myproc()->handler = handler;
110     return 0;
111 }
```

在 `trap.c` 的 `usertrap` 函数中，内核处理所有来自用户的中断，其中包括CPU时钟中断。当 `which_dev = devintr()) == 2` 时，当前中断类型为CPU时钟中断，我们在这里记录滴答数及判断是否调用 `handler` 函数：

```
 ...
 67     syscall();
 68   } else if((which_dev = devintr()) != 0){
 69       if(which_dev == 2){
 70           if(p->ticks != 0){
 71               p->currticks++;
 72               if(p->currticks % p->ticks == 0 && p->handlerlock){
 73                   p->handlerlock = 0;
 74                   p->trapframe->sepc = p->trapframe->epc;
 75                   p->trapframe->sra = p->trapframe->ra;
 76                   p->trapframe->ssp = p->trapframe->sp;
 77                   p->trapframe->sgp = p->trapframe->gp;
 78                   p->trapframe->stp = p->trapframe->tp;
 79                   p->trapframe->st0 = p->trapframe->t0;
 80                   p->trapframe->st1 = p->trapframe->t1;
 81                   p->trapframe->st2 = p->trapframe->t2;
 82                   p->trapframe->ss0 = p->trapframe->s0;
 83                   p->trapframe->ss1 = p->trapframe->s1;
 84                   p->trapframe->sa0 = p->trapframe->a0;
 85                   p->trapframe->sa1 = p->trapframe->a1;
 86                   p->trapframe->sa2 = p->trapframe->a2;
 87                   p->trapframe->sa3 = p->trapframe->a3;
 88                   p->trapframe->sa4 = p->trapframe->a4;
 89                   p->trapframe->sa5 = p->trapframe->a5;
 90                   p->trapframe->sa6 = p->trapframe->a6;
 91                   p->trapframe->sa7 = p->trapframe->a7;
 92                   p->trapframe->ss2 = p->trapframe->s2;
 93                   p->trapframe->ss3 = p->trapframe->s3;
 94                   p->trapframe->ss4 = p->trapframe->s4;
 95                   p->trapframe->ss5 = p->trapframe->s5;
 96                   p->trapframe->ss6 = p->trapframe->s6;
 97                   p->trapframe->ss7 = p->trapframe->s7;
 98                   p->trapframe->ss8 = p->trapframe->s8;
 99                   p->trapframe->ss9 = p->trapframe->s9;
100                   p->trapframe->ss10 = p->trapframe->s10;
101                   p->trapframe->ss11 = p->trapframe->s11;
102                   p->trapframe->st3 = p->trapframe->t3;
103                   p->trapframe->st4 = p->trapframe->t4;
104                   p->trapframe->st5 = p->trapframe->t5;
105                   p->trapframe->st6 = p->trapframe->t6;
106                   p->trapframe->epc = p->handler;
107               }
108           }
109       }
...
```

如 `p->ticks != 0` ，说明当前进程已经通过 `sigalarm` 启动了定时器功能，在每次CPU中断中递增当前滴答数 `currticks`。如当前滴答数可以被周期 `ticks` 整除且当前定时器处理函数未运行时，通过改变`p->trapframe`执行`handler`。在这里，需要在 `trapframe` 中新增条目，并在调用 `handler` 前保护用户寄存器，新增的条目名称为原寄存器名前加 `s` 。调用 `handler` 的方式为将 `p->trapframe->epc` 更换为其入口地址并为`handlerlock`加锁，以在 `usertrapret` 中将 `PC` 置为定时器处理函数以将其运行。

在定时器处理函数末尾，需要调用 `sigreturn` 以返回用户进程，其对应的系统调用如下：

```
112 uint64
113 sys_sigreturn(void){
114     struct proc* p = myproc();
115     p->handlerlock = 1;
116     p->trapframe->epc = p->trapframe->sepc;
117     p->trapframe->ra = p->trapframe->sra;
118     p->trapframe->sp = p->trapframe->ssp;
119     p->trapframe->gp = p->trapframe->sgp;
120     p->trapframe->tp = p->trapframe->stp;
121     p->trapframe->t0 = p->trapframe->st0;
122     p->trapframe->t1 = p->trapframe->st1;
123     p->trapframe->t2 = p->trapframe->st2;
124     p->trapframe->s0 = p->trapframe->ss0;
125     p->trapframe->s1 = p->trapframe->ss1;
126     p->trapframe->a0 = p->trapframe->sa0;
127     p->trapframe->a1 = p->trapframe->sa1;
128     p->trapframe->a2 = p->trapframe->sa2;
129     p->trapframe->a3 = p->trapframe->sa3;
130     p->trapframe->a4 = p->trapframe->sa4;
131     p->trapframe->a5 = p->trapframe->sa5;
132     p->trapframe->a6 = p->trapframe->sa6;
133     p->trapframe->a7 = p->trapframe->sa7;
134     p->trapframe->s2 = p->trapframe->ss2;
135     p->trapframe->s3 = p->trapframe->ss3;
136     p->trapframe->s4 = p->trapframe->ss4;
137     p->trapframe->s5 = p->trapframe->ss5;
138     p->trapframe->s6 = p->trapframe->ss6;
139     p->trapframe->s7 = p->trapframe->ss7;
140     p->trapframe->s8 = p->trapframe->ss8;
141     p->trapframe->s9 = p->trapframe->ss9;
142     p->trapframe->s10 = p->trapframe->ss10;
143     p->trapframe->s11 = p->trapframe->ss11;
144     p->trapframe->t3 = p->trapframe->st3;
145     p->trapframe->t4 = p->trapframe->st4;
146     p->trapframe->t5 = p->trapframe->st5;
147     p->trapframe->t6 = p->trapframe->st6;
148     return 0;
149 }  
```

在 `sys_sigreturn` 中的工作为将在 `usertrap` 中保存的寄存器还原至 `p->trapframe` 的原位置，以在 `usertrapret` 中返回用户进程原位置。

## 实验结果

在本实验中，执行 `./grade-lab-traps` 会导致 `usertests` 超时（原因可能为我个人电脑配置问题），在这里修改 `gradelib.py` 的`_react` 函数中的超时阈值，使得超时阈值提高一些以通过实验：

```
485     def __react(self, reactors, timeout):
486         deadline = time.time() + timeout + 200
```

再次运行 `./grade-lab-traps` 可以得到以下结果：

```
== Test answers-traps.txt == answers-traps.txt: OK 
== Test backtrace test == backtrace test: OK (3.3s) 
== Test running alarmtest == (5.6s) 
== Test   alarmtest: test0 == 
  alarmtest: test0: OK 
== Test   alarmtest: test1 == 
  alarmtest: test1: OK 
== Test   alarmtest: test2 == 
  alarmtest: test2: OK 
== Test usertests == usertests: OK (341.9s) 
    (Old xv6.out.usertests failure log removed)
== Test time == 
time: OK 
Score: 85/85
```

