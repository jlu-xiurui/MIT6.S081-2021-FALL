# Lab Copy-on-Write Fork

本实验要求为xv6系统增加 `fork` 函数写时复刻功能，即当 `fork` 完成时父子进程共享同一组只读物理内存页。当进程试图读写这些物理内存时，为该进程重新分配新的物理内存页，并将共享物理内存页的内容拷贝至新内存页。该实验与 `Lazy` 实验内容类似，但难度略微更大一些。

## 实验源码及解析

为了实现写时复刻功能，我们需要对物理内存页的被映射次数进行记录，以避免在物理内存页尚被进程使用时，被拥有其的另一个进程释放。在这里将物理内存页的引用计数实现安放在`kernel/kalloc.c`中：

```
 16 static int reference_count[(PHYSTOP - 0x80000000) / PGSIZE];
 17 
 18 static int idx_rc(uint64 pa){
 19     return (pa - 0x80000000) / PGSIZE;
 20 }
 21 void add_rc(uint64 pa){
 22     reference_count[idx_rc(pa)]++;
 23 }   
 24 void sub_rc(uint64 pa){
 25     reference_count[idx_rc(pa)]--;
 26 }   
 ...
 37 void
 38 kinit()
 39 {
 40   initlock(&kmem.lock, "kmem");
 41   memset(reference_count,0,sizeof(reference_count));
 42   freerange(end, (void*)PHYSTOP);
 43 } 
```

在这里，我们仅记录用户进程可能使用的物理内存范围，即`0x80000000`至`PHYSTOP`。使用`reference_count`  数组记录该范围的所有物理内存页的引用计数。对于特定的物理地址，可以通过其与`0x80000000`的偏移量除以`PGSIZE`得到其索引。在这里提供了对该数组进行更改的`add_rc` 和 `sub_rc` 接口函数。

在 `kfree` 函数中对所要释放的物理内存页的引用计数进行判断，如其引用计数大于1，则仅将其减一；如引用次数小于1（当为1时仅有一个虚拟内存页映射至该页，当为0时为 `kinit` 初始化调用`kfree`），则释放该页并将其添加至空闲列表：

```
 58 void
 59 kfree(void *pa)
 60 {
 61   struct run *r;
 62 
 63   if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
 64     panic("kfree");
 65   if(reference_count[idx_rc((uint64)pa)] > 1){
 66       sub_rc((uint64)pa);
 67       return;
 68   }   
 69   // Fill with junk to catch dangling refs.
 70   memset(pa, 1, PGSIZE);
 71   
 72   r = (struct run*)pa;
 73   
 74   acquire(&kmem.lock);
 75   r->next = kmem.freelist;
 76   kmem.freelist = r;
 77   release(&kmem.lock);
 78   reference_count[idx_rc((uint64)pa)] = 0;
 79 }
```

在 `kalloc` 中，如空闲列表不为空，则将被分配的物理内存页的引用计数初始化为1：

```
 84 void *
 85 kalloc(void)
 86 {
 87   struct run *r;
 88 
 89   acquire(&kmem.lock);
 90   r = kmem.freelist;
 91   if(r)
 92     kmem.freelist = r->next;
 93   release(&kmem.lock);
 94 
 95   if(r)
 96     memset((char*)r, 5, PGSIZE); // fill with junk
 97 
 98   if(r)
 99     reference_count[idx_rc((uint64)r)] = 1;
100   return (void*)r;
101 } 
```

在 `kernel/vm.c` 中，我们更改 `uvmcopy` 以使得在 `fork` 时父子进程共享同一片物理内存。在这里，我们定义利用了页表项的用户保留`flag`项，规定 `#define PTE_C (1L << 5)  `，以标记虚拟内存页是否为 `COW` 页（即被写时复刻的页）: 

```
303 int
304 uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
305 {
306   pte_t *pte;
307   uint64 pa, i;
308   uint flags;
309 
310   for(i = 0; i < sz; i += PGSIZE){
311     if((pte = walk(old, i, 0)) == 0)
312       panic("uvmcopy: pte should exist");
313     if((*pte & PTE_V) == 0)
314       panic("uvmcopy: page not present");
315     pa = PTE2PA(*pte);
316     *pte = (*pte & ~PTE_W) | PTE_C;
317     flags = PTE_FLAGS(*pte);
318     if(mappages(new, i, PGSIZE,pa, flags) != 0){
319       goto err;
320     }
321     add_rc(pa);
322   }
323   return 0;
324 
325  err:
326   uvmunmap(new, 0, i / PGSIZE, 1);
327   return -1;
328 }

```

在拷贝虚拟内存页时，我们仅将父进程的物理内存页映射至子进程的对应虚拟内存页，并为父子进程的虚拟内存页的页表项删去`PTE_W` 标记、增添`PTE_C`标记，并增加该物理内存页的引用计数（利用`add_rc`）。

在 `kernel/trap.c` 的 `usertrap`  中，我们捕捉 `COW` 页被写入的情况：

```
...
68   } else if((which_dev = devintr()) != 0){
 69     // ok
 70   } else {
 71       uint64 va = PGROUNDDOWN(r_stval());
 72       if(va >= MAXVA){
 73           p->killed = 1;
 74           exit(-1);
 75       }
 76       pte_t* pte = walk(p->pagetable,va,0);
 77       if(pte == 0){
 78           p->killed = 1;
 79           exit(-1);
 80       }
 81       uint64 pa = PTE2PA(*pte);
 82       uint64 flag = PTE_FLAGS(*pte);
 83       if((r_scause() == 13 || r_scause() == 15) && (flag & PTE_C) ){
 84           char* mem = kalloc();
 85           if(mem == 0){
 86               printf("here\n");
 87               p->killed = 1;
 88               exit(-1);
 89           }
 90           memmove(mem,(char*)pa,PGSIZE);
 91           kfree((char*)pa);
 92           *pte = PA2PTE(mem) | (flag & ~PTE_C) | PTE_W;
 93       }
 94       else{
 95           printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
 96           printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
 97           p->killed = 1;
 98       }
```

**71 - 82行：**首先，我们需要根据 `r_stval()` 返回的引起中断的虚拟地址，判断该虚拟地址是否为异常地址。如非异常地址，则根据该虚拟地址提取出页表项的 `FLAG` 标记位和其所映射的物理地址`pa`。

**83 - 89行：**在这里，我们需要利用 `r_scause()` 判断中断原因是否为页错误导致的，并确认引起页错误的页是否为 `COW` 页，如为其他情况则终结当前进程。如果当前中断是由于写入了只读物理内存 `COW` 页导致的，则为当前虚拟内存页分配新的物理内存，并将旧的物理内存页的内容拷贝至新的物理内存页。

**91 - 92行**之后，我们需要对被 `COW` 页映射的物理内存页调用`kfree`。在这里，如该物理内存页的引用计数为1，则释放了该页；如大于1，则递减了其引用计数。最后，我们需要将该虚拟内存页的页表项删去`PTE_C` 标记，并增加`PTE_W` 标记。

最后，我们需要为 `copyout` 增加与 `usertrap` 类似的判断代码，以防止对 `COW` 页的直接写入：

```
346 int
347 copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
348 {
349   uint64 n, va0, pa0, flag;
350   pte_t* pte;
351   while(len > 0){
352     va0 = PGROUNDDOWN(dstva);
353     if(va0 >= MAXVA)
354         return -1;
355     pte = walk(pagetable,va0,0);
356     if(pte == 0)
357         return -1;
358     pa0 = PTE2PA(*pte);
359     flag = PTE_FLAGS(*pte);
360     if(flag & PTE_C){
361         char* mem = kalloc();
362         if(mem == 0){
363             return -1;
364         }
365         memmove(mem,(char*)pa0,PGSIZE);
366         kfree((char*)pa0);
367         *pte = PA2PTE((uint64)mem) | (flag & ~PTE_C) | PTE_W;
368         pa0 = (uint64)mem;
369     }
370     if(pa0 == 0)
371       return -1;
372     n = PGSIZE - (dstva - va0);
373     if(n > len)
374       n = len;
375     memmove((void *)(pa0 + (dstva - va0)), src, n);
376 
377     len -= n;
378     src += n;
379     dstva = va0 + PGSIZE;
380   }
381   return 0;
382 }
```



## 实验结果

由于本人的实验环境不能在300秒内完成`usertests`，在这里，我将 `usertests` 的超时阈值增加了100秒。运行 `./grade-lab-cow`  结果如下：

```
== Test running cowtest == (11.5s) 
== Test   simple == 
  simple: OK 
== Test   three == 
  three: OK 
== Test   file == 
  file: OK 
== Test usertests == (316.9s) 
    (Old xv6.out.usertests failure log removed)
== Test   usertests: copyin == 
  usertests: copyin: OK 
== Test   usertests: copyout == 
  usertests: copyout: OK 
== Test   usertests: all tests == 
  usertests: all tests: OK 
== Test time == 
time: OK 
Score: 110/110
```

