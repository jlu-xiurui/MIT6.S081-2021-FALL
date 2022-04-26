# Lab mmap

在本实验中，需要为xv6实现简单的 `mmap` 功能，以综合提升对于虚拟内存和文件系统的理解。

## 实验源码及讲解

`mmap` 的功能为将一个磁盘文件映射至内存空间的一段缓冲区（称其为**存储映射缓冲区**），当从该缓冲区中读取、存入数据时，则自动从文件中读入数据或在文件中写入数据。其使得对于文件的I/O操作不必多次调用 `read` 和 `write` 系统调用，从而减少开销。

在本实验中，我将存储映射缓冲区存放在用户进程空间的最顶端，即紧邻 `TRAMFRAME` 页的高虚拟内存部分。首先，我们需要为进程控制块 `proc` 增加新的元素，用于记录 `mmap` 的调用情况：

```
 85 struct vma{
 86     uint64 addr;
 87     uint64 sz;
 88     uint8 prot;
 89     uint8 flags;
 90     struct file* file;
 91     uint offset;
 92 };
 93 // Per-process state
 94 struct proc {
 95   struct spinlock lock;
 96 
 97   // p->lock must be held when using these:
 98   enum procstate state;        // Process state
 99   void *chan;                  // If non-zero, sleeping on chan
100   int killed;                  // If non-zero, have been killed
101   int xstate;                  // Exit status to be returned to parent's wait
102   int pid;                     // Process ID
103 
104   // wait_lock must be held when using this:
105   struct proc *parent;         // Parent process
106 
107   // these are private to the process, so p->lock need not be held.
108   uint64 kstack;               // Virtual address of kernel stack
109   uint64 sz;                   // Size of process memory (bytes)
110   pagetable_t pagetable;       // User page table
111   struct trapframe *trapframe; // data page for trampoline.S
112   struct context context;      // swtch() here to run process
113   struct file *ofile[NOFILE];  // Open files
114   struct inode *cwd;           // Current directory
115   char name[16];               // Process name (debugging)
116   struct vma vma[16];
117   uint64 mmap_addr;
118   uint8  vma_size;
119 };
```

其中，`mmap_addr` 为存储映射缓存区的最低地址，`vma_size` 为当前调用 `mmap` 的次数。在 `vma` 结构中，我们记录每次 `mmap` 调用的对应起始地址、长度、文件等信息。

在 `sys_mmap` 系统调用中，我们在进程控制块中填写与 `vma` 有关的信息：

```
105 uint64
106 sys_mmap(void){
107     int length, prot,flags,fd,offset;
108     if(argint(1, &length) < 0 || argint(2, &prot) < 0 || argint(3, &flags) < 0 || argint(4, &fd)     < 0 || argint(5, &offset) < 0){
109         return -1;
110     }
111     struct proc* p = myproc();
112     if(p->mmap_addr - p->sz < p->sz)
113         return -1;
114     if(flags & MAP_SHARED){
115         if((prot & PROT_READ) && !p->ofile[fd]->readable)
116             return -1;
117         if((prot & PROT_WRITE) && !p->ofile[fd]->writable)
118             return -1;
119     }
120     p->vma[p->vma_size].sz = length;
121     p->vma[p->vma_size].prot = prot;
122     p->vma[p->vma_size].flags = flags;
123     p->vma[p->vma_size].addr = p->mmap_addr - p->sz;
124     p->vma[p->vma_size].file = p->ofile[fd];
125     p->vma[p->vma_size].offset = offset;
126     p->mmap_addr = p->vma[p->vma_size].addr;
127     p->vma_size++;
128     filedup(p->ofile[fd]);
129     return p->mmap_addr;
130 }
```

值得注意的是，当 `flag` 为 `MAP_SHARED` 时，`mmap` 对于存储映射缓冲区的访问权限不得违背其映射文件的访问权限。并且，在`sys_mmap` 中并未分配实际的物理内存，而是在  `usertrap` 中进行懒分配：

```
...
 71     } else if((which_dev = devintr()) != 0){
 72         // ok
 73     } else {
 74         uint64 va = PGROUNDDOWN(r_stval());
 75         if((r_scause() == 13 || r_scause() == 15) && va >= p->mmap_addr && va < TRAPFRAME){
 76             int vma_idx = -1;
 77             char* mem;
 78             for(int i = 0; i < p->vma_size; i++){
 79                 if(va >= p->vma[i].addr && va < p->vma[i].addr + p->sz){
 80                     vma_idx = i;
 81                     break;
 82                 }
 83             }
 84             if(vma_idx == -1)
 85                 goto error;
 86             if((mem = kalloc()) == 0){
 87                 goto error;
 88             }
 89             memset(mem,0,PGSIZE);
 90             struct vma p_vma = p->vma[vma_idx];
 91             uint8 RD_flag = p_vma.prot & 0x1;
 92             uint8 WR_flag = p_vma.prot & 0x2;
 93             uint8 flag = 0;
 94             flag = RD_flag ? flag | PTE_R : flag;
 95             flag = WR_flag ? flag | PTE_W : flag;
 96             if(mappages(p->pagetable, va, PGSIZE, (uint64)mem, flag|PTE_U) != 0){
 97                 kfree(mem);
 98                 goto error;
 99             }
100             ilock(p_vma.file->ip);
101             readi(p_vma.file->ip, 0, (uint64)mem, va - p_vma.addr + p_vma.offset,PGSIZE);
102             iunlock(p_vma.file->ip);
103             goto done;
104         }
105 error:
106         printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
107         printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
108         p->killed = 1;
109     }
110 
111 done:
112     if(p->killed)
113         exit(-1);
114 
...
```

**74 - 75行**：在这里，对于存储映射缓冲区的懒分配的策略与 `lazy`实验中的策略相似。不同的是我们需要判断，当前导致内存错误的虚拟内存是否位于存储映射缓冲区的范围内。

**76 - 85行**：如该虚拟内存位于存储映射缓存区，则寻找该虚拟内存所对应的进程 `vma` 结构，如未找到则终结该进程。

**76 - 99行**：如找到 `vma` 结构，则分配物理内存并将其清零，并将虚拟内存映射至该物理内存。根据 `vma` 结构中的 `prot` ，对页表项标志位进行建立。

**100 - 104行**：最后，从 `vma` 所对应的文件中读取数据，并将其写入存储映射缓冲区的对应位置。

```
132 uint64
133 sys_munmap(void){
134     uint64 addr;
135     int length;
136     if(argaddr(0, &addr) < 0 || argint(1, &length) < 0)
137         return -1;
138     struct proc* p = myproc();
139     for(int i = 0; i < p->vma_size; i++){
140         if(p->vma[i].addr == addr){
141             uint64 unmapsz = min(p->vma[i].sz,length);
142             if(p->vma[i].flags & MAP_SHARED){
143                 begin_op();
144                 ilock(p->vma[i].file->ip);
145                 writei(p->vma[i].file->ip, 1, addr, p->vma[i].offset, unmapsz);
146                 iunlock(p->vma[i].file->ip);
147                 end_op();
148             }
149             uvmunmap(p->pagetable,addr,unmapsz/PGSIZE,1);
150             length -= unmapsz;
151             addr += unmapsz;
152             p->vma[i].offset += unmapsz;
153             p->vma[i].sz -= unmapsz;
154             p->vma[i].addr += unmapsz;
155             if(p->vma[i].sz == 0)
156                 fileclose(p->vma[i].file);
157             if(length == 0)
158                 break;
159         }
160     }
161     return 0;
162 }

```

**134 - 140行**：在 `sys_munmap` 中，我们遍历进程的 `vma` 结构，以寻找所需解除映射的具体 `vma` 。本实验中仅在存储映射缓冲区的两端进行取消映射，使得仅需将 `vma[i]->addr` 与调用参数 `addr` 进行相等判断即可。

**141 - 148行**：当我们找到了对应的 `vma` 时，根据当前 `length` 及 `p->vma[i].sz` 值，确定对该 `vma` 取消映射的具体长度。如其标志位为 `MAP_SHARED` 则对该区域进行写回操作。在写回时注意获取 `inode` 锁及使得写回操作被 `begin_op()` 与 `end_op()` 包围。

**149 - 149行**：调用 `uvmunmap` 释放该段存储映射缓冲区，值得注意的是，由于对于存储映射缓冲区采取懒分配策略，因此需要对`uvmunmap` 进行更改，使得其跳过对无效虚拟内存页的解除映射：

```
165 void
166 uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
167 {
168   uint64 a;
169   pte_t *pte;
170 
171   if((va % PGSIZE) != 0)
172     panic("uvmunmap: not aligned");
173 
174   for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
175     if((pte = walk(pagetable, a, 0)) == 0)
176       panic("uvmunmap: walk");
177     if((*pte & PTE_V) == 0)
178         continue;
179     if(PTE_FLAGS(*pte) == PTE_V)
180       panic("uvmunmap: not a leaf");
181     if(do_free){
182       uint64 pa = PTE2PA(*pte);
183       kfree((void*)pa);
184     }
185     *pte = 0;
186   }
187 }  
```

**150 - 161行**：最后，对该 `vma` 的成员进行更改，值得注意的是需要增加当前 `vma` 的 `offset`，使得在写回时对存储映射缓存区对应的文件偏移量处的内容进行写回。当当前 `vma` 的大小为0时，释放该 `vma` 所对应的文件。如所需解除映射的长度 `length` 为0，则结束本函数。

最后，我们需要对 `exit` 和 `fork` 进行更改，使得其对存储映射缓冲区进行合理的操作：

```
365 void
366 exit(int status)
367 {
368   struct proc *p = myproc();
369 
370   if(p == initproc)
371     panic("init exiting");
372   for(int i = 0; i < p->vma_size; i++){
373       uint64 unmapsz = p->vma[i].sz;
374       if(unmapsz == 0)
375           continue;
376       if(p->vma[i].flags & MAP_SHARED){
377           begin_op();
378           ilock(p->vma[i].file->ip);
379           writei(p->vma[i].file->ip, 1, p->vma[i].addr , p->vma[i].offset, unmapsz);
380           iunlock(p->vma[i].file->ip);
381           end_op();
382       }
383       fileclose(p->vma[i].file);
384       uvmunmap(p->pagetable,p->vma[i].addr,p->vma[i].sz/PGSIZE,1);
385   }
386   // Close all open files.
387   for(int fd = 0; fd < NOFILE; fd++){
388     if(p->ofile[fd]){
389       struct file *f = p->ofile[fd];
390       fileclose(f);
391       p->ofile[fd] = 0;
392     }
393   }
...
```

在 `exit` 中，我们对存储映射缓存区的所有内容进行类 `munmap` 操作。在这里将对进程有关 `vma` 的情况操作在 `freeproc `中集中处理：

```
154 static void
155 freeproc(struct proc *p)
156 {
157   if(p->trapframe)
158     kfree((void*)p->trapframe);
159   p->trapframe = 0;
160   if(p->pagetable)
161     proc_freepagetable(p->pagetable, p->sz);
162   p->pagetable = 0;
163   p->sz = 0;
164   p->pid = 0;
165   p->parent = 0;
166   p->name[0] = 0;
167   p->chan = 0;
168   p->killed = 0;
169   p->xstate = 0;
170   for(int i = 0; i < p->vma_size ; i++){
171       p->vma[i].addr = 0;
172       p->vma[i].sz = 0;
173       p->vma[i].prot = 0;
174       p->vma[i].file = 0;
175       p->vma[i].flags = 0;
176       p->vma[i].offset = 0;
177   }
178   p->mmap_addr = 0;
179   p->vma_size = 0;
180   p->state = UNUSED;
181 }
```

在  `fork` 中，将进程有关 `vma` 的成员进行拷贝，当对应 `vma` 有效（即大小不为零）时，对其文件的引用数递增：

```
286 int
287 fork(void)
288 {
289     int i, pid;
290     struct proc *np;
291     struct proc *p = myproc();
292 
293     // Allocate process.
294     if((np = allocproc()) == 0){
295         return -1;
296     }
297 
298     // Copy user memory from parent to child.
299     if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
300         freeproc(np);
301         release(&np->lock);
302         return -1;
303     }
304     np->sz = p->sz;
305     np->mmap_addr = p->mmap_addr;
306     np->vma_size = p->vma_size;
307 
308     for(int i = 0; i < p->vma_size; i++){
309         np->vma[i].addr = p->vma[i].addr;
310         np->vma[i].sz = p->vma[i].sz;
311         np->vma[i].prot = p->vma[i].prot;
312         np->vma[i].flags = p->vma[i].flags;
313         np->vma[i].file = p->vma[i].file;
314         np->vma[i].offset = p->vma[i].offset;
315         if(p->vma[i].sz > 0)
316             filedup(p->vma[i].file);
317     }
...
```

## 实验结果

```
== Test running mmaptest == (1.4s) 
== Test   mmaptest: mmap f == 
  mmaptest: mmap f: OK 
== Test   mmaptest: mmap private == 
  mmaptest: mmap private: OK 
== Test   mmaptest: mmap read-only == 
  mmaptest: mmap read-only: OK 
== Test   mmaptest: mmap read/write == 
  mmaptest: mmap read/write: OK 
== Test   mmaptest: mmap dirty == 
  mmaptest: mmap dirty: OK 
== Test   mmaptest: not-mapped unmap == 
  mmaptest: not-mapped unmap: OK 
== Test   mmaptest: two files == 
  mmaptest: two files: OK 
== Test   mmaptest: fork_test == 
  mmaptest: fork_test: OK 
== Test usertests == usertests: OK (102.0s) 
== Test time == 
time: OK 
Score: 140/140
```

