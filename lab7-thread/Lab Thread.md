# Lab Thread

本实验分为三个部分，首先需要我们为xv6实现用户级线程包，以加深对线程上下文切换的理解。然后，需要我们利用UNIX接口实现简易的并发哈希表及 `barrier` 屏障功能，以提升线程同步及线程安全编程能力。

## 实验代码及讲解

### Uthread: switching between threads (moderate)

在本部分中，需要我们实现xv6用户级线程包。首先，为了在线程切换时保存当前线程上下文（即寄存器和程序计数器），需要在 `thread` 结构中增加 `context` 结构保存上下文：

```
 13 struct context {
 14     uint64 ra;
 15     uint64 sp;
 16 
 17     // callee-saved
 18     uint64 s0;
 19     uint64 s1;
 20     uint64 s2;
 21     uint64 s3;
 22     uint64 s4;
 23     uint64 s5;
 24     uint64 s6;
 25     uint64 s7;
 26     uint64 s8;
 27     uint64 s9;
 28     uint64 s10;
 29     uint64 s11;
 30 };
 31 
 32 struct thread {
 33   char       stack[STACK_SIZE]; /* the thread's stack */
 34   int        state;             /* FREE, RUNNING, RUNNABLE */
 35   struct context context;
```

当 `thread_swithch` 切换线程时，其将当前线程的上下文保存在其 `thread` 结构的 `context` 中，并将被调度线程 `context` 中的条目读入寄存器：

```
  8     .globl thread_switch
  9 thread_switch:
 10 /* YOUR CODE HERE */
 11     sd ra, 0(a0)
 12     sd sp, 8(a0)
 13     sd s0, 16(a0)
 14     sd s1, 24(a0)
 15     sd s2, 32(a0)
 16     sd s3, 40(a0)
 17     sd s4, 48(a0)
 18     sd s5, 56(a0)
 19     sd s6, 64(a0)
 20     sd s7, 72(a0)
 21     sd s8, 80(a0)
 22     sd s9, 88(a0)
 23     sd s10, 96(a0)
 24     sd s11, 104(a0)
 25     
 26     ld ra, 0(a1)
 27     ld sp, 8(a1)
 28     ld s0, 16(a1)
 29     ld s1, 24(a1)
 30     ld s2, 32(a1)
 31     ld s3, 40(a1)
 32     ld s4, 48(a1)
 33     ld s5, 56(a1)
 34     ld s6, 64(a1)
 35     ld s7, 72(a1)
 36     ld s8, 80(a1)
 37     ld s9, 88(a1)
 38     ld s10, 96(a1)
 39     ld s11, 104(a1)
 40 
 41     ret    /* return to ra */
```

其中，`a0` 为当前线程的 `context` 结构地址，`a1` 为被调度线程的`context` 结构地址。

在 `RISC-V` 架构中，`ra` 寄存器保存了当前函数的返回地址。在 `thread_create` 创建线程时，我们将 `context->ra` 置为线程所需执行函数的起始地址，以在 `thread_switch` 中调用 `ret` 时，其控制流跳转至该线程的所需执行的函数：

```
 92 void
 93 thread_create(void (*func)())
 94 {
 95   struct thread *t;
 96 
 97   for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
 98     if (t->state == FREE) break;
 99   }
100   t->state = RUNNABLE;
101   // YOUR CODE HERE
102   t->context.ra = (uint64)func;
103   t->context.sp = (uint64)t->stack + STACK_SIZE;
104 }
```

`thread_schedule` 用于调度线程执行，其遍历所有线程，寻找状态为 `RUNNABLE` 的可执行线程，并调用 `thread_switch` 实施具体的线程切换：

```
 54 void
 55 thread_schedule(void)
 56 {
 57   struct thread *t, *next_thread;
 58 
 59   /* Find another runnable thread. */
 60   next_thread = 0;
 61   t = current_thread + 1;
 62   for(int i = 0; i < MAX_THREAD; i++){
 63     if(t >= all_thread + MAX_THREAD)
 64       t = all_thread;
 65     if(t->state == RUNNABLE) {
 66       next_thread = t;
 67       break;
 68     }
 69     t = t + 1;
 70   }
 71 
 72   if (next_thread == 0) {
 73     printf("thread_schedule: no runnable threads\n");
 74     exit(-1);
 75   }
 76 
 77   if (current_thread != next_thread) {         /* switch threads?  */
 78     next_thread->state = RUNNING;
 79     t = current_thread;
 80     current_thread = next_thread;
 81     /* YOUR CODE HERE
 82      * Invoke thread_switch to switch from t to next_thread:
 83      * thread_switch(??, ??);
 84      */
 85     uint64 curr_ctx = (uint64)(&t->context);
 86     uint64 next_ctx = (uint64)(&current_thread->context);
 87     thread_switch(curr_ctx,next_ctx);
 88   } else
 89     next_thread = 0;
 90 }
```

### Using threads (moderate)

在本部分中，需要我们利用UNIX接口实现简易的并发哈希表，该哈希表需要在多个线程对其进行插入操作时保证线程安全。在这里，我们的保护方式是为每一个哈希桶分配一个互斥锁，当对一个桶中的元素进行遍历时，利用该锁对桶进行保护：

首先是锁的初始化，`init` 函数被 `main` 函数调用：

```
 20 pthread_mutex_t hashlock[NBUCKET];
 21 
 22 static void
 23 init(){
 24     for(int i = 0; i < NBUCKET; i++)
 25         pthread_mutex_init(&hashlock[i],NULL);
 26 }
```

当 `put` 对于哈希表进行插入时，利用锁对针对链表结构的操作进行保护。在插入时对于链表结构的操作有部分，分别为 `put` 函数中遍历哈希桶的主键匹配，以及 `insert` 函数中对于哈希表的头插：

```
 35 static void
 36 insert(int key, int value, int i)
 37 {
 38   struct entry *e = malloc(sizeof(struct entry));
 39   e->key = key;
 40   e->value = value;
 41   pthread_mutex_lock(&hashlock[i]);
 42   e->next = table[i];
 43   table[i] = e;
 44   pthread_mutex_unlock(&hashlock[i]);
 45 }
 46 
 47 static
 48 void put(int key, int value)
 49 {
 50   int i = key % NBUCKET;
 51 
 52   // is the key already present?
 53   pthread_mutex_lock(&hashlock[i]);
 54   struct entry *e = table[i];
 55   for (; e != 0; e = e->next) {
 56     if (e->key == key)
 57       break;
 58   }
 59   pthread_mutex_unlock(&hashlock[i]);
 60   if(e){
 61     // update the existing key.
 62     e->value = value;
 63   } else {
 64     // the new is new.
 65     insert(key, value, i);
 66   }
 67 
 68 }
```

值得注意的是，在本部分中 `get` 和 `put` 是被分别调用的，因此不需要对 `get` 函数加锁。

### Barrier(moderate)

在本部分中，需要利用UNIX接口实现 `barrier` 屏障功能，其功能为只有当参与屏障的所有线程均调用 `barrier` 函数时，任意线程才可以从 `barrier` 中返回，否则就阻塞在 `barrier` 中。具体的实现方式需要使用到UNIX中的同步原语 **条件变量`pthread_cond_t`** ，其功能与xv6中的`sleep/wakeup`机制相似。其实现如下：

```
  9 struct barrier{
 10   pthread_mutex_t barrier_mutex;
 11   pthread_cond_t barrier_cond;
 12   int nthread;      // Number of threads that have reached this round of the barrier
 13   int round;     // Barrier round
 14 } bstate;
 ...
 24 static void
 25 barrier()
 26 {
 27     // YOUR CODE HERE
 28     //
 29     // Block until all threads have called barrier() and
 30     // then increment bstate.round.
 31     //
 32     pthread_mutex_lock(&bstate.barrier_mutex);
 33     int curr_round = bstate.round;
 34     bstate.nthread++;
 35     while(bstate.nthread < nthread && curr_round == bstate.round){
 36         pthread_cond_wait(&bstate.barrier_cond,&bstate.barrier_mutex);
 37     }
 38     if(curr_round == bstate.round){
 39         bstate.round++;
 40         bstate.nthread = 0;
 41     }
 42     pthread_mutex_unlock(&bstate.barrier_mutex);
 43     pthread_cond_broadcast(&bstate.barrier_cond);
 44 
 45 }
```

在这里，`nthread` 为用户输入的参与屏障的全部线程数、`bstate.nthread` 为当前达到屏障函数的线程数并被初始化为零、`bstate.round` 为屏障进行的轮数。

**32，42行：**在代码中，我们利用互斥锁 `bstate.barrier_mutex` 保护 `bstate` 中的所有条目，并用条件变量 `bstate.barrier_cond` 实现线程间的同步。

**33 - 37行：**当一个线程调用 `barrier` 时，其对 `bstate.nthread` 进行递增，并记录当前的 `bstate.round`。然后，其进入循环判断，如当前进入屏障的线程数小于全部线程数，或者当前屏障轮数没有改变时，则调用 `pthread_cond_wait` 阻塞在 `bstate.barrier_cond`条件变量上，并让出互斥锁使得其他线程得以调用 `barrier` 。

**38 - 41行：**当参与屏障的最后一个线程调用 `barrier` 时，其通过循环判断。在这里，将当前轮数 `bstate.round` 递增，使得其余被阻塞的线程可以跳出循环判断。并将 `bstate.nthread` 清零。

在这里，值得注意的是该种同步方式使得相邻两轮的屏障之间的 `bstate.nthread` 不会互相影响。因为唤醒线程调用 `pthread_cond_broadcast` 前，其余所有线程都正在被阻塞，因此唤醒线程一定会在其余线程对 `bstate.nthread` 进行递增之前将其清零、也会在其余线程记录其当前轮数之前将 `bstate.round` 递增，其也一定是在该轮中最后一个对 `bstate.nthread` 进行递增的线程。因此，该种特性使得相邻两次屏障之间是相互独立的。

**43行：**当有线程达到该处时，说明该轮中所有线程均达到了 `barrier` ，因此调用 `pthread_cond_broadcast` 唤醒其余阻塞进程。

## 实验结果：

```
./grade-lab-thread 
make: “kernel/kernel”已是最新。
== Test uthread == uthread: OK (1.3s) 
== Test answers-thread.txt == answers-thread.txt: OK 
== Test ph_safe == make: “ph”已是最新。
ph_safe: OK (10.3s) 
== Test ph_fast == make: “ph”已是最新。
ph_fast: OK (23.6s) 
== Test barrier == make: “barrier”已是最新。
barrier: OK (51.0s) 
== Test time == 
time: OK 
Score: 60/60
```

