# 2020 FALL Pgtbl

## 实验源码与讲解

### Print a page table (easy)

本部分与2020Fall的对应部分完全一致，在这里不重复介绍。

### A kernel page table per process (hard)

在本部分中，需要实验者为xv6系统的进程增加其专属内核页表副本。在进程被调度时，进程使用其专属的内核页表，而不使用原来xv6中定义在 `vm.c`的 单一内核页表 `kernel_pagetable`。为了实现这一点，首先需要在进程控制块中增加内核页表的根页目录表 `kpagetable `:

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
 98   uint64 kstack;               // Virtual address of kernel stack
 99   uint64 sz;                   // Size of process memory (bytes)
100   pagetable_t pagetable;       // User page table
101   pagetable_t kpagetable;      // User kernel page table
102   struct trapframe *trapframe; // data page for trampoline.S
103   struct context context;      // swtch() here to run process
104   struct file *ofile[NOFILE];  // Open files
105   struct inode *cwd;           // Current directory
106   char name[16];               // Process name (debugging)
107 };
```

在xv6中，进程的生成和释放分别通过 `allocproc` 和 `freeproc` 两个函数实现。在创建内核页表副本之前，我们需要对xv6内核地址布局进行理解，xv6内核地址分布如下：

![figure1](https://github.com/jlu-xiurui/MIT6.S081-2021-FALL/blob/master/lab3-pgtbl/pgtbl-2020FALL/figure1.png)

在这里，除了为用户提供的内核栈  `Kstack` 外，其余的页均具有固定的虚拟地址和物理地址，且已经被分配在物理内存中。因此，在本部分中，内核栈 `Kstack` 的物理内存分配和释放为关键之处。在这里，内核页表副本的初始化与内核页表 `kernel_pagetable` 的初始化函数 `kvminit` 所作的工作类似，在分配了根目录表 `kpagetable` 后，通过 `mappages` 函数将内核地址空间中除 `Kstack` 的部分各自进行映射。值得注意的是，由于实验下一部分的需要，在这里不能对 `CLINT` 进行映射（实际上实验指导书中也没有进行这个页面的映射）：

```C
 23 void
 24 user_kvmmap(pagetable_t kpagetable,uint64 va, uint64 sz,uint64 pa, int perm)
 25 {
 26   if(mappages(kpagetable, va, sz, pa, perm) != 0){
 27     panic("user_kvmmap");
 28   }
 29 }
 30 pagetable_t
 31 user_kvmcreate()
 32 {
 33   pagetable_t kpagetable = (pagetable_t) kalloc();
 34   memset(kpagetable, 0, PGSIZE);
 35 
 36   // uart registers
 37   user_kvmmap(kpagetable,UART0,PGSIZE, UART0, PTE_R | PTE_W);
 38 
 39   // virtio mmio disk interface
 40   user_kvmmap(kpagetable,VIRTIO0, PGSIZE,VIRTIO0, PTE_R | PTE_W);
 41 
 42   // CLINT
 43   //user_kvmmap(kpagetable,CLINT,0x10000,CLINT, PTE_R | PTE_W);
 44 
 45   // PLIC
 46   user_kvmmap(kpagetable,PLIC,0x400000,PLIC, PTE_R | PTE_W);
 47 
 48   // map kernel text executable and read-only.
 49   user_kvmmap(kpagetable,KERNBASE,(uint64)etext-KERNBASE,KERNBASE, PTE_R | PTE_X);
 50 
 51   // map kernel data and the physical RAM we'll make use of.
 52   user_kvmmap(kpagetable,(uint64)etext,PHYSTOP-(uint64)etext,(uint64)etext, PTE_R | PTE_W);
 53 
 54   // map the trampoline for trap entry/exit to
 55   // the highest virtual address in the kernel.
 56   user_kvmmap(kpagetable,TRAMPOLINE, PGSIZE,(uint64)trampoline, PTE_R | PTE_X);
 57   return kpagetable;
 58 
 59 }
```

在 `procinit` 中，为了使得进程内核栈与其所属的内核页表副本关联起来，我们将内核栈的初始化操作移至 `allocporc `：

```C
 25 void
 26 procinit(void)
 27 {
 28   struct proc *p;
 29 
 30   initlock(&pid_lock, "nextpid");
 31   for(p = proc; p < &proc[NPROC]; p++) {
 32       initlock(&p->lock, "proc");
 33       // Allocate a page for the process's kernel stack.
 34       // Map it high in memory, followed by an invalid
 35       // guard page.
 36   }
 37   kvminithart();
 38 }
```

在 `allocproc` 中，我们完成全部的内核页表副本创建工作：

```C
85 static struct proc*
 86 allocproc(void)
 87 {
 88   //printf("allocproc\n");
 89   struct proc *p;
 90 
 91   for(p = proc; p < &proc[NPROC]; p++) {
 92     acquire(&p->lock);
 93     if(p->state == UNUSED) {
 94       goto found;
 95     } else {
 96       release(&p->lock);
 97     }
 98   }
 99   return 0;
100   
101 found:
102   p->pid = allocpid();
103   
104   // Allocate a trapframe page.
105   if((p->trapframe = (struct trapframe *)kalloc()) == 0){
106     release(&p->lock);
107     return 0;
108   }
109 
110   // An empty user page table.
111   p->pagetable = proc_pagetable(p);
112   if(p->pagetable == 0){
113     freeproc(p);
114     release(&p->lock);
115     return 0;
116   }
117   p->kpagetable = user_kvmcreate();
118   char *pa = kalloc();
119   if(pa == 0)
120       panic("kalloc");
121   uint64 va = KSTACK(0);
122   user_kvmmap(p->kpagetable,va,PGSIZE,(uint64)pa,PTE_R | PTE_W);
123   p->kstack = KSTACK(0);
124   // Set up new context to start executing at forkret,
125   // which returns to user space.
126   memset(&p->context, 0, sizeof(p->context));
127   p->context.ra = (uint64)forkret;
128   p->context.sp = p->kstack + PGSIZE;
129   //printf("pagetable = %p,kpagetable = %p\n",p->pagetable,p->kpagetable);
130 
131   return p;
132 }
```

在这里，我们仅需关注**117**行及以后新增内容即可。首先，我们通过上述 `user_kvmcreate` 函数初始化内核页表副本。然后，为用户进程的内核栈分配物理地址，值得注意的是，由于各进程均拥有其自身的专属内核页表副本，因此内核栈只需要被存放在固定的虚拟地址处即可，在这里选择了 `KSTCAK(0)` 即 `(TRAMPOLINE - 2*PGSIZE)`。最后，将该虚拟地址映射到为其分配的物理地址处即可。

在 `freeproc` 中，我们完成所有的内核页表副本释放工作：

```C
137 static void
138 freeproc(struct proc *p)
139 {
140     //printf("freeproc\n");
141     if(p->trapframe)
142         kfree((void*)p->trapframe);
143     p->trapframe = 0;
144     if(p->kstack){
145         kfree((void*)PTE2PA(*walk(p->kpagetable,KSTACK(0),0)));
146         p->kstack = 0;
147     }
148     if(p->kpagetable)
149         user_kvmfree(p->kpagetable);
150     if(p->pagetable)
151         proc_freepagetable(p->pagetable, p->sz);
152     p->pagetable = 0;
153     p->kpagetable = 0;
154     p->sz = 0;
155     p->pid = 0;
156     p->parent = 0;
157     p->name[0] = 0;
158     p->chan = 0;
159     p->killed = 0;
160     p->xstate = 0;
161     p->state = UNUSED;
162 }
```

在本函数中，我们需要释放为内核栈所分配的物理地址，并将 `p->kstack` 置为空指针。在这里，我们调用 `user_kvmfree` 完成内核页表的释放操作：

```C
351 void kfreewalk(pagetable_t kpagetable){
352     // there are 2^9 = 512 PTEs in a page table.
353     for(int i = 0; i < 512; i++){
354         pte_t pte = kpagetable[i];
355         if((pte & PTE_V)){
356             // this PTE points to a lower-level page table.
357             if((pte & (PTE_R|PTE_W|PTE_X)) == 0){
358                 uint64 child = PTE2PA(pte);
359                 kfreewalk((pagetable_t)child);
360             }
361             kpagetable[i] = 0;
362         } 
363     }
364     kfree((void*)kpagetable);
365 
366 }
367 void user_kvmfree(pagetable_t kpagetable){
368     kfreewalk(kpagetable);
369 }
```

将该函数分为两个函数的原因为方便进行调试。其中 `kfreewalk` 递归的解除映射和释放 `PDE` 和 `PTE`。在这里，我们利用`(PTE_R | PTE_W | PTE_X)` 判断当前页存放的是为页目录表项`PDE` 还是页表项 `PTE` 。如存放的是 `PDE` 则在递归的调用 `kfreewalk` 释放其目录下的所有子页表后，将所有页目录表项置为0，并释放存储页目录表项的物理内存；如存放的是 `PTE` 则不对其继续递归，仅将表项置为0并释放物理内存即可。

由于我们不再使用位于 `vm.c` 的总内核页表 `kernel_pagetable` 为进程服务，在 `scheduler` 调度进程时我们需要将 `satp` 寄存器置为进程的专属内核页表副本，以通知硬件利用该页表进行地址转换：

```C
494 void
495 scheduler(void)
496 {
497   struct proc *p;
498   struct cpu *c = mycpu();
499 
500   c->proc = 0;
501   for(;;){
502     // Avoid deadlock by ensuring that devices can interrupt.
503     intr_on();
504 
505     int found = 0;
506     for(p = proc; p < &proc[NPROC]; p++) {
507       acquire(&p->lock);
508       if(p->state == RUNNABLE) {
509         // Switch to chosen process.  It is the process's job
510         // to release its lock and then reacquire it
511         // before jumping back to us.
512         p->state = RUNNING;
513         c->proc = p;
514         w_satp(MAKE_SATP(p->kpagetable));
515         sfence_vma();
516         swtch(&c->context, &p->context);
517         kvminithart();
518         // Process is done running for now.
519         // It should have changed its p->state before coming back.
520         c->proc = 0;
521 
522         found = 1;
523       }
524       release(&p->lock);
525     }
526 #if !defined (LAB_FS)
527     if(found == 0) {
528       intr_on();
529       kvminithart();
530       asm volatile("wfi");
531     }
532 #else
533     ;
534 #endif
535   }
536 }

```

在进程被调度前，即在调用 `swtch(&c->context, &p->context)` 前，我们将 `satp` 置为该进程的内核页表副本，并刷新TLB，并在返回后将该寄存器切换至总内核页表 `kernel_pagetable` 。如无进程需要被调度，我们仍将当前 `satp` 置为 `kernel_pagetable` 。

接下来为最值得注意的地方，由于我们使用进程专属的内核页表副本，在 `kvmpa` 中我们需要将函数中被用到的 `kernel_pagetable`  更换为进程自身的 `myproc()->kpagetable` 。这一点困扰了我很长时间，可以说是本部分的最大之坑。

```C
167 uint64
168 kvmpa(uint64 va)
169 {
170   uint64 off = va % PGSIZE;
171   pte_t *pte;
172   uint64 pa;
173 
174   pte = walk(myproc()->kpagetable, va, 0);
175   if(pte == 0)
176     panic("kvmpa");
177   if((*pte & PTE_V) == 0)
178     panic("kvmpa");
179   pa = PTE2PA(*pte);
180   return pa+off;
181 }
```

在完成了上述更改后，在xv6的shell中执行 `usertests` 以验证对xv6的更改是否破坏了其原有功能。

### Simplify `copyin/copyinstr` (hard)

在本部分中，我们需要为进程的内核页表副本增加其对应的用户页表映射。由于在内核态中 `satp` 被置为了被调度的进程的专属内核页表副本，使得在内核态中也可以直接对被调度进程的指针（存放虚拟地址）进行解引用，从而对 `copyin` 和 `copyinstr` 函数进行简化。

在这里，最需要注意的是我们仅需将**内核页表的虚拟地址**映射至**用户页表虚拟地址所映射的物理地址**即可，不需要为内核页表分配新的物理内存。实验指导书上的 **"At each point where the kernel changes a process's user mappings, change the process's kernel page table in the same way." ** 很可能对人（至少对我）进行迷惑，并使得实验者为每一处用户页表被映射的地方为内核页表施用同样或类似的函数。

首先，我们更改最复杂的 `exec` 函数，其功能是为当前进程分配全新的程序段、代码段等内存映像，并删除原有的进程内存映像。在这里仅对进行更改的部分（102行及以后）进行讲解：

```C
10 static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);
 11 int
 12 exec(char *path, char **argv)
 13 {
 14     //printf("exec\n");
 15     char *s, *last;
 16     int i, off;
 17     uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
 18     struct elfhdr elf;
 19     struct inode *ip;
 20     struct proghdr ph;
 21     pagetable_t pagetable = 0, oldpagetable;
 22     struct proc *p = myproc();
 ...
102     for(last=s=path; *s; s++)
103         if(*s == '/')
104             last = s+1;
105     safestrcpy(p->name, last, sizeof(p->name));
106     kvmdealloc(p->kpagetable,oldsz,0);
107     kvmcopy(pagetable,p->kpagetable,0,sz);
108 
109     // Commit to the user image.
110     oldpagetable = p->pagetable;
111     p->pagetable = pagetable;
112     p->sz = sz;
113     p->trapframe->epc = elf.entry;  // initial program counter = main
114     p->trapframe->sp = sp; // initial stack pointer
115     proc_freepagetable(oldpagetable, oldsz);
116     if(p->pid == 1) vmprint(pagetable);
117     return argc; // this ends up in a0, the first argument to main(argc, argv)
118 
119 bad:
120     if(pagetable)
121         proc_freepagetable(pagetable, sz);
122     if(ip){
123         iunlockput(ip);
124         end_op();
125     }
126     return -1;
127 }  
```

在这里，坑点之一在于不需要仿照用户页表的操作方式，而创建新的内核页表副本即保存其旧副本。而是仅需在对新用户页表   `pagetable` 完成初始化后，调用 `kvmdealloc` 解除原内核页表副本的映射，调用 `kvmcopy` 将新内核页表副本的虚拟地址映射至用户虚拟地址所映射的物理地址即可，映射范围为0至新进程的用户虚拟内存大小`sz`。`kvmdealloc` 的实现如下：

```C
318 uint64
319 kvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
320 {   
321   if(newsz >= oldsz)
322     return oldsz;
323   if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
324     int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
325     uvmunmap(pagetable, PGROUNDUP(newsz), npages, 0);
326   } 
327     
328   return newsz;
329 }
```

其与 `uvmdealloc` 的唯一差别在于传入 `uvmunmap` 的参数 `dofree` 被设置为0，使得在解除映射时不释放对应的物理内存。`kvmcopy` 的实现如下：

```C
416 int 
417 kvmcopy(pagetable_t old, pagetable_t new,uint64 oldsz, uint64 newsz)
418 {   
419   pte_t *pte;
420   uint64 pa, i;
421   uint flags;
422   oldsz = PGROUNDUP(oldsz);
423   for(i = oldsz; i < newsz; i += PGSIZE){
424     if((pte = walk(old, i, 0)) == 0) 
425       panic("kvmcopy: pte should exist");
426     if((*pte & PTE_V) == 0)
427       panic("kvmcopy: page not present");
428     pa = PTE2PA(*pte);
429     flags = PTE_FLAGS(*pte) & ~PTE_U;
430     if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
431       goto err;
432     }
433   }
434   return 0;
435     
436  err:
437   printf("kvmcopy err\n");
438   uvmunmap(new, oldsz, i / PGSIZE, 1);
439   return -1;
440 }
```

该函数与 `uvmcopy` 的区别在于，不为新页表 `new` 分配新的物理内存，而是仅在对应的虚拟地址处进行映射，且新映射的页表表项应当不具有 `PTE_U` 的标记。并且，为了使得该函数更方便的用于之后的更改，该函数可对任意一段虚拟内存进行拷贝，而不是从0开始的虚拟内存段。

然后就是 `fork` 函数，该函数的功能为创建新的进程，使得新的进程具有与旧进程各自的相同内存映像（**各自相同指存储物理地址不同，但内容相同**）。其更改如下：

```C
272 int
273 fork(void)
274 {
275   //printf("fork\n");
276   int i, pid;
277   struct proc *np;
278   struct proc *p = myproc();
279 
280   // Allocate process.
281   if((np = allocproc()) == 0){
282     return -1;
283   }
284   // Copy user memory from parent to child.
285   if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
286     freeproc(np);
287     release(&np->lock);
288     return -1;
289   } 
290   if(kvmcopy(np->pagetable, np->kpagetable,0, p->sz) < 0){
291     freeproc(np);
292     release(&np->lock);
293     return -1;
294   } 
295   np->sz = p->sz;
296   np->parent = p;
297   // copy saved user registers.
298   *(np->trapframe) = *(p->trapframe);
299   // Cause fork to return 0 in the child.
300   np->trapframe->a0 = 0;
301   // increment reference counts on open file descriptors.
302   for(i = 0; i < NOFILE; i++)
303     if(p->ofile[i])
304       np->ofile[i] = filedup(p->ofile[i]);
305   np->cwd = idup(p->cwd);
306   safestrcpy(np->name, p->name, sizeof(p->name));
307   pid = np->pid;
308   np->state = RUNNABLE;
309   release(&np->lock);
310   return pid;
311 } 
```

在这里，我们在完成对新进程用户页表的拷贝初始化操作后，将新进程内核页表副本的虚拟地址映射至新进程用户页表对应虚拟地址所映射物理地址。需要注意的是（又一坑点），由于新旧进程的具有不同的物理内存分布，不能从旧进程的内核页表副本`p->kpagetable`进行拷贝。

最后即为 `sbrk` 的实现函数 `growproc` ，该函数为进程分配新的物理内存，或释放物理内存：

```C
249 int
250 growproc(int n)
251 {
252   uint sz,sz1;
253   struct proc *p = myproc();
254 
255   sz = p->sz;
256   sz1 = sz;
257   if(n > 0){
258     if((sz = uvmalloc(p->pagetable, sz1, sz1 + n)) == 0) {
259       return -1;
260     }
261     kvmcopy(p->pagetable,p->kpagetable,sz1,sz1 + n);
262   } else if(n < 0){
263     sz = uvmdealloc(p->pagetable, sz1, sz1 + n);
264     kvmdealloc(p->kpagetable, sz1, sz1 + n);
265   }
266   p->sz = sz;
267   return 0;
268 }
```

当传入参数 `n` 大于 0 时，分配新的物理内存，并在内核页表副本中映射新分配的物理内存。当传入参数 `n` 小于 0 时，释放物理内存，并在内核页表副本中释放对应的虚拟内存区间。

最后，由于在内核页表副本中同时存在对用户进程地址的映射，以及对内核地址的映射，因此用户进程的虚拟地址不得超过内核地址的使用最低地址 `PLIC` ，我们在为用户地址分配新物理内存的 `uvmalloc` 中实现这一点限制：

```C
273 uint64
274 uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
275 {
276   char *mem;
277   uint64 a;
278   if(newsz > PLIC){
279       printf("out of PLIC\n");
280       return 0;
281   }
282   if(newsz < oldsz)
283     return oldsz;
284   
285   oldsz = PGROUNDUP(oldsz);
286   for(a = oldsz; a < newsz; a += PGSIZE){
287     mem = kalloc();
288     if(mem == 0){
289       uvmdealloc(pagetable, a, oldsz);
290       return 0;
291     }
292     memset(mem, 0, PGSIZE);
293     if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
294       kfree(mem);
295       uvmdealloc(pagetable, a, oldsz);
296       return 0;
297     }
298   }
299   return newsz;
300 }
```

当即将拓展至的新虚拟地址 `newsz` 大于 `PLIC` 时，不分配内存并返回0。在完成了上述函数的更改后，仅需将 `copyin` 和 `copyinstr` 替换至对新函数的调用即可。

## 实验结果

需要注意的是，除了 `time.txt` 文件，我们还需创建一个包括一定长度文字的 `answers-pgtbl.txt` 文件才能获得本实验的全部分数。运行 `./grade-lab-pgtbl` 的结果如下：

```
== Test pte printout == pte printout: OK (1.7s) 
== Test answers-pgtbl.txt == answers-pgtbl.txt: OK 
== Test count copyin == count copyin: OK (1.3s) 
== Test usertests == (184.9s) 
== Test   usertests: copyin == 
  usertests: copyin: OK 
== Test   usertests: copyinstr1 == 
  usertests: copyinstr1: OK 
== Test   usertests: copyinstr2 == 
  usertests: copyinstr2: OK 
== Test   usertests: copyinstr3 == 
  usertests: copyinstr3: OK 
== Test   usertests: sbrkmuch == 
  usertests: sbrkmuch: OK 
== Test   usertests: all tests == 
  usertests: all tests: OK 
== Test time == 
time: OK 
Score: 66/66
```

