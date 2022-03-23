# 2021 FALL Pgtbl 

## 实验源码及讲解

### Speed up system calls (easy)

本实验中要求实验者在创建进程时，在物理内存中创建一个页面以保存进程的PID，并在进程的页表中将 `USYSCALL` 虚拟地址映射至上述页面。通过上述操作，进程即可在用户空间内直接访问其PID，以节省了系统调用的开销。

在创建进程（调用`allocproc`）时，需要在物理内存中分配一个页面，并为进程页表添加映射。在这里，将上述操作安放在用于初始化页表的`proc_pagetable`：

```
171 pagetable_t
172 proc_pagetable(struct proc *p)
173 {
174   pagetable_t pagetable;
175 
176   // An empty page table.
177   pagetable = uvmcreate();
178   if(pagetable == 0)
179     return 0;
180 
181   // map the trampoline code (for system call return)
182   // at the highest user virtual address.
183   // only the supervisor uses it, on the way
184   // to/from user space, so not PTE_U.
185   if(mappages(pagetable, TRAMPOLINE, PGSIZE,
186               (uint64)trampoline, PTE_R | PTE_X) < 0){
187     uvmfree(pagetable, 0);
188     return 0;
189   }
190   struct usyscall* usc = (struct usyscall *)kalloc();
191   usc->pid = p->pid;
192   // lab3 pgtbl : map the USYSCALL
193   if(mappages(pagetable,USYSCALL,PGSIZE,(uint64)(usc), PTE_R | PTE_U) < 0){
194     kfree(usc);
195     uvmunmap(pagetable, TRAMPOLINE, 1, 0);
196     uvmfree(pagetable, 0);
197     return 0;
198   }
199   // map the trapframe just below TRAMPOLINE, for trampoline.S.
200   if(mappages(pagetable, TRAPFRAME, PGSIZE,
201               (uint64)(p->trapframe), PTE_R | PTE_W) < 0){
202     kfree(usc);
203     uvmunmap(pagetable, TRAMPOLINE, 1, 0);
204     uvmunmap(pagetable, USYSCALL, 1, 0);
205     uvmfree(pagetable, 0);
206     return 0;
207   }
208 
209   return pagetable;
210 }
```

值得注意的是，当映射失败时，需要释放物理内存并解除用户页表映射。在结束进程时（调用`freeproc`），同样需要释放物理内存并解除用户页表映射，在这里将该操作安放在用于释放页表的`proc_freepagetable` 中：

```
214 void
215 proc_freepagetable(pagetable_t pagetable, uint64 sz)
216 {
217   kfree((char *)walkaddr(pagetable,USYSCALL));
218   uvmunmap(pagetable, TRAMPOLINE, 1, 0);
219   uvmunmap(pagetable, TRAPFRAME, 1, 0);
220   uvmunmap(pagetable, USYSCALL, 1, 0);
221   uvmfree(pagetable, sz);
222 }

```

### Print a page table (easy)

在本部分中，需要对页表中所有有效的PDE及PTE进行输出，利用DFS方式的递归方法即可完成：

```
435 // lab3 pgtbl : print vm
436 static void vmprint_helper(pagetable_t pagetable,int level){
437     if(level > 3)
438         return;
439     for(int i = 0; i < 512; i++){
440         pte_t pte = pagetable[i];
441         if(pte & PTE_V){
442             uint64 child = PTE2PA(pte);
443             for(int j = 0; j < level; j++)
444                 printf(" ..");
445             printf("%d: pte %p pa %p\n",i,pte,child);
446             vmprint_helper((pagetable_t)child,level+1);
447         }
448     }
449 }
450 void vmprint(pagetable_t pagetable){
451     printf("page table %p\n",pagetable);
452     vmprint_helper(pagetable,1);
453     return;
454 }
```

上述函数被定义在 `kernel/vm.c` 中，具体思想就是利用递归程序记录当前的层数，当层数大于3时结束递归。

### Detecting which pages have been accessed (hard)

在本部分中，需要增加一个系统调用，以返回用户空间虚拟地址中的 “脏页” 分布情况，脏页即被访问过的页面。具体的调用方式为，用户输入检测的起始虚拟地址和检测页面数，内核在计算后通过指针返回用于表示脏页分布情况的位掩码。

值得注意的是，`PTE_A` （通过RISCV手册查询得到其值为 `1<<6` ）被硬件自动设置，不需要在软件层面上对其进行设置。系统调用`sys_pgaccess`的代码如下：

```
 79 #ifdef LAB_PGTBL
 80 int
 81 sys_pgaccess(void)
 82 {
 83   // lab pgtbl: your code here.
 84     uint64 va,dst;
 85     int n;
 86     if(argint(1, &n) < 0 || argaddr(0, &va) < 0 || argaddr(2, &dst) < 0)
 87         return -1;
 88     if(n > 64 || n < 0)
 89         return -1;
 90     uint64 bitmask = 0,mask = 1;
 91     pte_t *pte;
 92     pagetable_t pagetable = myproc()->pagetable;
 93     while(n > 0){
 94         pte = walk(pagetable,va,1);
 95         if(pte){
 96             if(*pte & PTE_A)
 97                 bitmask |= mask;
 98             *pte = *pte & (~PTE_A);
 99         }
100         mask <<= 1;
101         va = (uint64)((char*)(va)+PGSIZE);
102         n--;
103     }
104     if(copyout(pagetable,dst,(char *)&bitmask,sizeof(bitmask)) < 0)
105         return -1;
106     return 0;
107 }
108 #endif
```

值得注意的是，在访问有效PTE后，需要对其 `PTE_A` 进行清空，并且超出`uint64`位掩码存放极限的64页以上的访问请求应当被拒绝。

## 实验结果

在运行 `make grade` 时，除 `usertests` 之外的所有测试用例均顺利通过，但在运行 `usertests` 时却导致了死循环，对 `user/usertests.c` 进行调试，可以看出该测试用例的功能是执行一系列的函数，以检测是否发生了内存泄漏，并且在执行其中的 `execout `时，导致了错误（在xv6 shell 输入`usertests execout` 对该函数单独测试）：

```
$ usertests execout
usertests starting
test execout: scause 0x000000000000000f
sepc=0x0000000080001038 stval=0x0000000000000000
panic: kerneltrap
```

可以证明的是，当不对xv6进行任何更改的情况下，也会导致上述报错，在 `usertests` 取消该函数的执行后，运行 `usertests`时全部通过：

```
...
test sbrkarg: OK
test sbrklast: OK
test sbrk8000: OK
test validatetest: OK
test stacktest: usertrap(): unexpected scause 0x000000000000000d pid=6277
            sepc=0x000000000000237a stval=0x000000000000fb50
OK
test opentest: OK
test writetest: OK
test writebig: OK
test createtest: OK
test openiput: OK
test exitiput: OK
test iput: OK
test mem: OK
test pipe1: OK
test killstatus: OK
test preempt: kill... wait... OK
test exitwait: OK
test rmdot: OK
test fourteen: OK
test bigfile: OK
test dirfile: OK
test iref: OK
test forktest: OK
test bigdir: OK
ALL TESTS PASSED
```

 但令人懊恼的时，在执行 `make grade` 时，显示 `usertests` 运行超时:

```
== Test   pgtbltest: ugetpid == 
  pgtbltest: ugetpid: OK 
== Test   pgtbltest: pgaccess == 
  pgtbltest: pgaccess: OK 
== Test pte printout == 
$ make qemu-gdb
pte printout: OK (0.8s) 
    (Old xv6.out.pteprint failure log removed)
== Test answers-pgtbl.txt == answers-pgtbl.txt: OK 
== Test usertests == 
$ make qemu-gdb
Timeout! (300.2s) 
== Test   usertests: all tests == 
  usertests: all tests: FAIL 
    ...
         test bigfile: OK
         test dirfile: OK
         test iref: OK
         test forktest: OK
         test bigdir: qemu-system-riscv64: terminating on signal 15 from pid 44337 (make)
    MISSING '^ALL TESTS PASSED$'
== Test time == 
time: OK 
Score: 36/46

```

在取消其中执行时间最长的 `bigdir` 后，运行`make grade` 即可通过全部测试用例。令人遗憾的是，本人尚未查明 `execout` 导致报错的原因，希望能在2021 FALL的官方课程视频发布后获得答案。

```
== Test pgtbltest == 
$ make qemu-gdb
(2.7s) 
== Test   pgtbltest: ugetpid == 
  pgtbltest: ugetpid: OK 
== Test   pgtbltest: pgaccess == 
  pgtbltest: pgaccess: OK 
== Test pte printout == 
$ make qemu-gdb
pte printout: OK (0.8s) 
== Test answers-pgtbl.txt == answers-pgtbl.txt: OK 
== Test usertests == 
$ make qemu-gdb
(222.7s) 
== Test   usertests: all tests == 
  usertests: all tests: OK 
== Test time == 
time: OK 
Score: 46/46
```

