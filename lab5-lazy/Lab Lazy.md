# Lab Lazy

在本实验中，需要为xv6增加内存分配的延时分配功能，即在调用 `sbrk` 时不直接分配内存，仅在对应的虚拟内存被使用时才为其分配物理内存，实验所需的代码量很少，但有很多细节需要被注意。

## 实验代码及解析

首先，我们需要更改系统调用 `sys_sbrk`，使得用户希望分配内存时不直接分配内存，但当用户希望释放内存时则释放对应虚拟内存：

```
 41 uint64
 42 sys_sbrk(void)
 43 {
 44   int addr;
 45   int n;
 46   
 47   if(argint(0, &n) < 0)
 48     return -1;
 49   addr = myproc()->sz;
 50   myproc()->sz += n; 
 51   if(n < 0){
 52       uvmdealloc(myproc()->pagetable,addr,myproc()->sz);
 53   } 
 54   return addr;
 55 }   
```

在这里，我们有可能在 `uvmdealloc` 中调用 `uvmunmap` 对未分配物理内存的虚拟内存释放。因此，我们需要更改`uvmunmap`，使得当对应虚拟内存未被分配物理内存时将其跳过：

```
173 void
174 uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
175 {
176   uint64 a;
177   pte_t *pte;
178 
179   if((va % PGSIZE) != 0)
180     panic("uvmunmap: not aligned");
181 
182   for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
183     if((pte = walk(pagetable, a, 0)) == 0)
184         continue;
185     if((*pte & PTE_V) == 0)
186         continue;
187     if(PTE_FLAGS(*pte) == PTE_V)
188       panic("uvmunmap: not a leaf");
189     if(do_free){
190       uint64 pa = PTE2PA(*pte);
191       kfree((void*)pa);
192     }
193     *pte = 0;
194   }
195 }
```

在这里，为 `proc` 增加了 `maxva` 条目，以记录当前进程中实际分配物理内存的最高虚拟地址；并增加了 `ustack` 条目，以记录当前进程的用户栈的最高地址。在 `usertrap` 中，进行实际的物理内存分配工作：

```
 68   } else if((which_dev = devintr()) != 0){
 69     // ok
 70   } else {
 71       uint64 va = PGROUNDDOWN(r_stval());
 72       if((r_scause() == 13 || r_scause() == 15) && va < p->sz && va >= p->ustack){
 73           char* mem = kalloc();
 74           if(va > p->maxva)
 75               p->maxva = va+PGSIZE;
 76           if(mem == 0){
 77               p->killed = 1;
 78           }
 79           else if(mappages(p->pagetable, va, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
 80               kfree(mem);
 81               p->killed = 1;
 82           }
 83       }
 84       else{
 85           printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
 86           printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
 87           p->killed = 1;
 88       }
 89   }
 90 
```

**71 - 72行：**如当前错误为页面未分配错误，在 `scause` 寄存器中存放的错误号为13或15。此时，我们检查造成页面未分配错误的虚拟地址页（利用 `PGROUNDDOWN` 提取页的低地址），如页地址位于用户栈之下、或页地址高于进程用 `sbrk` 分配的虚拟地址、或当前错误不是页面为分配错误时，则终结当前进程。

**73 - 78行：**为当前虚拟地址分配物理内存，如当前虚拟地址大于`maxva`，则将 `maxva` 置为当前虚拟地址，以标记被实际分配物理内存的最高虚拟地址；当物理内存分配错误时，杀死当前进程。

**79 - 82行**：将当前虚拟地址页映射到分配的物理内存，如映射失败则释放物理内存并杀死进程。

在这里，`maxva` 和 `ustack` 在 `exec` 中初始化：

```
...
110   // Commit to the user image.
111   oldpagetable = p->pagetable;
112   p->pagetable = pagetable;
113   p->sz = sz;
114   p->maxva = sz;
115   p->ustack = sz;
116   p->trapframe->epc = elf.entry;  // initial program counter = main
117   p->trapframe->sp = sp; // initial stack pointer
118   proc_freepagetable(oldpagetable, oldsz);
...
```

由于 `maxva` 的引入，使得 `fork` 和 `freeproc` 中不必对未分配内存的虚拟地址进行处理，使得其速度得到很大程度的优化：

```
260 int
261 fork(void)
262 {
263   int i, pid;
264   struct proc *np;
265   struct proc *p = myproc();
266 
267   // Allocate process.
268   if((np = allocproc()) == 0){
269     return -1;
270   }
271 
272   // Copy user memory from parent to child.
273   if(uvmcopy(p->pagetable, np->pagetable, p->maxva) < 0){
274     freeproc(np);
275     release(&np->lock);
276     return -1;
277   }
278   np->sz = p->sz;
279   np->maxva = p->maxva;
280   np->ustack = p->ustack;
...
```

```
136 static void
137 freeproc(struct proc *p)
138 {
139   if(p->trapframe)
140     kfree((void*)p->trapframe);
141   p->trapframe = 0;
142   printf("p->sz = %p,p->maxva = %p\n",p->sz,p->maxva);
143   if(p->pagetable)
144     proc_freepagetable(p->pagetable, p->maxva);
145   p->pagetable = 0;
146   p->sz = 0;
147   p->maxva = 0;
148   p->pid = 0;
149   p->parent = 0;
150   p->name[0] = 0;
151   p->chan = 0;
152   p->killed = 0;
153   p->xstate = 0;
154   p->state = UNUSED;
155 }
```



## 实验结果

运行 `make grade` 结果如下所示：

```
== Test   lazy: map == 
  lazy: map: OK 
== Test   lazy: unmap == 
  lazy: unmap: OK 
== Test usertests == 

$ make qemu-gdb
(297.0s) 
== Test   usertests: pgbug == 
  usertests: pgbug: OK 
== Test   usertests: sbrkbugs == 
  usertests: sbrkbugs: OK 
== Test   usertests: argptest == 
  usertests: argptest: OK 
== Test   usertests: sbrkmuch == 
  usertests: sbrkmuch: OK 
...
== Test   usertests: fourteen == 
  usertests: fourteen: OK 
== Test   usertests: bigfile == 
  usertests: bigfile: OK 
== Test   usertests: dirfile == 
  usertests: dirfile: OK 
== Test   usertests: iref == 
  usertests: iref: OK 
== Test   usertests: forktest == 
  usertests: forktest: OK 
== Test time == 
time: OK 
Score: 119/119
```

