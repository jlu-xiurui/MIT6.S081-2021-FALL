

# Lab Lock

在本实验中，需要通过降低xv6中内存分配器及磁盘块缓存中锁的粒度，以提升这两个程序的并行性。在 `Thread` 实验中我们已经尝试了锁的基本使用，而在本实验中则需要对并发条件下的临界区保护具备更深的理解，以在降低锁粒度的条件下不破坏程序的并发安全。

## 实验源码及讲解

### Memory allocator (moderate)

在本部分中，我们需要将内存分配器的锁粒度从全局锁降低为每CPU一个的小粒度锁，并使得各CPU分别拥有并使用它们的空闲列表，使得各CPU的内存分配是相互独立的，以提升并行性。当一个CPU的空闲列表为空时，该CPU需要在其他CPU的空闲列表中试图寻找空闲内存块，这一点为本部分的主要复杂度来源。

首先，我们需要在 `kmem` 结构中为每个CPU各自分配一个空闲列表及互斥锁。在 `kinit` 中，我们将空闲内存块均匀地添加在各个空闲列表中，并初始化各空闲列表的互斥锁。

```
 21 struct {
 22   struct spinlock lock[NCPU];
 23   struct run *freelist[NCPU];
 24 } kmem;
 25 
 26 void
 27 kinit()
 28 {
 29     for(int i = 0; i < NCPU; i++){
 30         initlock(&kmem.lock[i], "kmem");
 31     }
 32     //freerange(end,(char*)PHYSTOP);
 33     char *p = (char*)PGROUNDUP((uint64)end);
 34     uint64 memsize = (uint64)PHYSTOP - (uint64)end;
 35     for(int i = 0; i < NCPU; i++){
 36         for(; p + PGSIZE <= end + memsize*(i+1)/NCPU; p += PGSIZE){
 37             struct run *r = (struct run*)p;
 38             acquire(&kmem.lock[i]);
 39             r->next = kmem.freelist[i];
 40             kmem.freelist[i] = r;
 41             release(&kmem.lock[i]);
 42         }
 43     }
 44 
 45 }
```

`kfree` 改变不大。其在对应空闲列表锁的保护下，将空闲块添加至该空闲列表：

```
 60 void
 61 kfree(void *pa)
 62 {
 63   struct run *r;
 64 
 65   if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
 66     panic("kfree");
 67 
 68   // Fill with junk to catch dangling refs.
 69   memset(pa, 1, PGSIZE);
 70 
 71   r = (struct run*)pa;
 72   int CPU = cpuid();
 73   acquire(&kmem.lock[CPU]);
 74   r->next = kmem.freelist[CPU];
 75   kmem.freelist[CPU] = r;
 76   release(&kmem.lock[CPU]);
 77 }
```

在 `kalloc` 中，我们首先获取本CPU的互斥锁，并尝试从本CPU的空闲列表中获取空闲块。如本CPU的空闲列表为空，则在其余CPU的互斥锁保护下，尝试在其空闲列表中获取空闲块。

```
 82 void *
 83 kalloc(void)
 84 {
 85   struct run *r;
 86   int CPU = cpuid();
 87   acquire(&kmem.lock[CPU]);
 88   r = kmem.freelist[CPU];
 89   if(r)
 90     kmem.freelist[CPU] = r->next;
 91   else{
 92       for(int i = 0; i < NCPU; i++){
 93           if(i != CPU){
 94               acquire(&kmem.lock[i]);
 95               if(kmem.freelist[i]){
 96                   r = kmem.freelist[i];
 97                   kmem.freelist[i] = r->next;
 98                   release(&kmem.lock[i]);
 99                   break;
100               }
101               release(&kmem.lock[i]);
102           }
103       }
104   }
105   release(&kmem.lock[CPU]);
106 
107   if(r)
108     memset((char*)r, 5, PGSIZE); // fill with junk
109   return (void*)r;
110 }
```

### Buffer cache (hard)

在本部分中，需要降低磁盘缓冲区的锁粒度，以提升其并行性。基本思想是，原本磁盘缓冲区通过单一空闲链表以管理缓存区，因此在 `bget` 和 `brelse` 必须获取全局锁以保护缓冲区。因此，我们可以通过哈希表的方式来管理缓冲区，使得一组 `dev` 及 `blockno` 与一个哈希桶单一映射，通过此方法我们仅需在 `bget` 和 `brelse` 中保持哈希桶的锁，既可以保证对应缓冲区保持并发安全。

首先，我们在 `bcache` 中存放若干哈希桶及其对应的锁，并定义一系列用于在哈希表中增添、查找、删除元素的功能函数。值得注意的是，我们不在对哈希表操作的功能函数中使用互斥锁，而在 `bget` 中根据特定情况使用锁：

```
 26 #define HASHSIZE 17
 27 
 28 struct {
 29     struct spinlock lock;
 30     struct buf buf[NBUF];
 31 
 32     struct spinlock hashlock[HASHSIZE];
 33     struct buf buckets[HASHSIZE];
 34   // Linked list of all buffers, through prev/next.
 35   // Sorted by how recently the buffer was used.
 36   // head.next is most recent, head.prev is least.
 37 } bcache;
 39 static int hash(uint dev,uint blockno){
 40     return (dev + blockno) % HASHSIZE;
 41 }
 42 
 43 static void insert(struct buf* buf){
 44     uint dev = buf->dev,blockno = buf->blockno;
 45     int idx = hash(dev,blockno);
 46     buf->next = bcache.buckets[idx].next;
 47     bcache.buckets[idx].next = buf;
 48 }
 49 
 50 static struct buf* find(uint dev,uint blockno){
 51     struct buf* b;
 52     int idx = hash(dev,blockno);
 53     for(b = bcache.buckets[idx].next; b != 0; b = b->next){
 54         if(b->dev == dev && b->blockno == blockno){
 55             return b;
 56         }
 57     }
 58     return 0;
 59 }
 60 
 61 static void erase(uint dev,uint blockno){
 62     struct buf* b;
 63     int idx = hash(dev,blockno);
 64     for(b = &bcache.buckets[idx]; b->next != 0; b = b->next){
 65         if(b->next->dev == dev && b->next->blockno == blockno){
 66             b->next = b->next->next;
 67             return;
 68         }
 69     }
 70 }
 71 void
 72 binit(void)
 73 {
 74   struct buf *b;
 75 
 76   initlock(&bcache.lock, "bcache");
 77   // Create linked list of buffers
 78   for(b = bcache.buf; b < bcache.buf+NBUF; b++){
 79     initsleeplock(&b->lock, "buffer");
 80   }
 81   for(int i = 0; i < HASHSIZE; i++){
 82       initlock(&bcache.hashlock[i], "bcache_hash");
 83   }
 84 }
```

`bget` 函数是本部分的难点所在。其难点主要在于，在哈希表中查找元素及在查找失败在哈希表中驱逐、分配元素的工作必须是原子的。在这里，解决该问题的基本思想是利用哈希桶的锁，保证对缓冲区中磁盘块、哈希桶的操作是并行安全的。其原理在于，各磁盘块都根据 其 `dev` 和 `blockno` 被组织到了各自的哈希桶中，即磁盘块与哈希桶具有单一映射关系，因此对于哈希桶的锁保护也可以同时保护对应的磁盘块。其具体代码如下：

```
 89 static struct buf*
 90 bget(uint dev, uint blockno)
 91 {
 92     struct buf *b;
 93 
 94     int idx = hash(dev,blockno);
 95     // Is the block already cached?
 96     acquire(&bcache.hashlock[idx]);
 97     if((b = find(dev,blockno)) != 0){
 98         b->refcnt++;
 99         release(&bcache.hashlock[idx]);
100         acquiresleep(&b->lock);
101         return b;
102     }
103 
104     // Not cached.
105     // Recycle the least recently used (LRU) unused buffer.
106     for(int i = 0; i < NBUF; i++){
107         b = &bcache.buf[i];
108         int bucket = hash(b->dev,b->blockno);
109         if(bucket != idx){
110             acquire(&bcache.hashlock[bucket]);
111         }
112         if(b->refcnt == 0) {
113             erase(b->dev,b->blockno);
114             b->dev = dev;
115             b->blockno = blockno;
116             b->valid = 0;
117             b->refcnt = 1;
118             insert(b);
119 
120             if(bucket != idx)
121                 release(&bcache.hashlock[bucket]);
122             release(&bcache.hashlock[idx]);
123             acquiresleep(&b->lock);
124             return b;
125         }
126         if(bucket != idx){
127             release(&bcache.hashlock[bucket]);
128         }
129     }
130     panic("bget: no buffers");
131 }
```

**96 - 102行**：首先根据所需查询的磁盘块的 `dev` 和 `blockno` 得到对应的哈希桶，并在哈希桶锁的保护下利用 `find` 搜索缓存区中是否缓存了该磁盘块。如查找成功，则在哈希桶锁的保护下递增 `b->refcnt`。最后，释放哈希桶锁、获得磁盘块睡眠锁并返回。在这里，为了方便区分，将所需查询的磁盘块所对应的哈希桶称为**查询哈希桶**，将当前缓冲区中可用缓存块所对应的哈希桶成为**驱逐哈希桶**。

**103 - 112行**：如未查找成功，则不释放**查询哈希桶**锁，以保证**在查询哈希桶中查找及在查询哈希桶插入操作**是原子的。在这里，遍历`bcache.buf` 中各缓存块，在其对应的哈希桶锁的保护下检查其是否可用（`b->refcnt` 为0）。在这里值得注意的是，如`bcache.buf` 中的缓存块是否映射至**查询哈希桶**，以避免重复获取该锁导致死锁。

**113 - 125行**：如当前缓存块可用（在这里为了简单采用了序列化驱逐的方式，而并未采用LRU方式），则在**驱逐哈希桶**中驱逐该缓存块中原有的磁盘块，并将所需查询的磁盘块信息填入该缓冲块，并插入至**查询哈希桶**。最后，释放**驱逐哈希桶**的锁和**查询哈希桶**的锁。

**126 - 127行**：如当前缓存快不可用，则释放该缓存块所对应哈希桶的锁。

在 `brelse` 中，释放磁盘块的睡眠锁，并在其对应哈希桶锁的保护下递减`b->refcnt`（在 `bpin` 和 `bunpin` 中同理）：

```
158 void
159 brelse(struct buf *b)
160 {
161   if(!holdingsleep(&b->lock))
162     panic("brelse");
163 
164   releasesleep(&b->lock);
165   int idx = hash(b->dev,b->blockno);
166   acquire(&bcache.hashlock[idx]);
167   b->refcnt--;
168   release(&bcache.hashlock[idx]);
169 }
171 void
172 bpin(struct buf *b) {
173   int idx = hash(b->dev,b->blockno);
174   acquire(&bcache.hashlock[idx]);
175   b->refcnt++;
176   release(&bcache.hashlock[idx]);
177 }
178 
179 void
180 bunpin(struct buf *b) {
181   int idx = hash(b->dev,b->blockno);
182   acquire(&bcache.hashlock[idx]);
183   b->refcnt--;
184   release(&bcache.hashlock[idx]);
185 }

```

## 实验结果

值得注意的是，需要在本实验中将 `kernel/param.h` 中的磁盘大小 `FSSIZE` 从1000调整至10000（在2020版本中的`FSSIZE`值），以避免在调用 `usertests` 时由于磁盘块不足导致 `panic: balloc: out of blocks`。

```
== Test running kalloctest == (54.2s) 
== Test   kalloctest: test1 == 
  kalloctest: test1: OK 
== Test   kalloctest: test2 == 
  kalloctest: test2: OK 
== Test kalloctest: sbrkmuch == kalloctest: sbrkmuch: OK (6.9s) 
== Test running bcachetest == (8.3s) 
== Test   bcachetest: test0 == 
  bcachetest: test0: OK 
== Test   bcachetest: test1 == 
  bcachetest: test1: OK 
== Test usertests == usertests: OK (101.4s) 
    (Old xv6.out.usertests failure log removed)
== Test time == 
time: OK 
Score: 70/70
```

