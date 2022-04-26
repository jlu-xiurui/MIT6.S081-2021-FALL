# MIT6.S081
MIT 6.S081 2021 FALL配套实验的代码及笔记，每个实验的对应源码位于对应的文件夹中。课程网站为[MIT6.S081](https://pdos.csail.mit.edu/6.828/2020/xv6.html)

### 1. Lab Utilities [Lab1-note](https://github.com/jlu-xiurui/MIT6.S081-2021-FALL/blob/master/lab1-util/Utilities-note.md)
本实验要求实验者基于xv6的函数接口，实现一系列的用户级程序，需要实验者对于进程行为（如fork,exec,wait对进程的影响等）有一定的理解，总体难度不大。

### 2. Lab Syscall [Lab2-note](https://github.com/jlu-xiurui/MIT6.S081-2021-FALL/blob/master/lab2-syscall/README.md)
本实验需要为xv6操作系统添加两个新的系统调用，以帮助实验者进一步了解和掌握用户层调用系统调用时，内核所完成的任务及其细节。 

### 3. Lab Pgtbl [lab3-note](https://github.com/jlu-xiurui/MIT6.S081-2021-FALL/blob/master/lab3-pgtbl/README.md)
在本实验中，要求实验者在xv6中增加一些有关页表操作的机制，以在此过程中加深实验者对于虚拟地址与物理地址、页表映射过程的理解。由于2021Fall与2020Fall的pgtbl实验差别较大，在这里对两者均进行了完成。总体而言，2020Fall的难度要远大于2021Fall。如果有时间的话，强烈建议在两者间选择2020Fall进行完成，以获得对于页表机制更加深刻、全面的理解。 

### 4. Lab Trap [lab4-note](https://github.com/jlu-xiurui/MIT6.S081-2021-FALL/blob/master/lab4-traps/Trap-note.md)

在本实验中需要在xv6中实现一些有关中断处理或RISC-V汇编语句的功能，需要对基本的RISC-V语句、用户中断处理过程有一定的理解，总体难度不大。

### 5. Lab Lazy [lab5-lazy](https://github.com/jlu-xiurui/MIT6.S081-2021-FALL/blob/master/lab5-lazy/Lab%20Lazy.md)

在本实验中，需要为xv6增加内存分配的延时分配功能，即在调用 sbrk 时不直接分配内存，仅在对应的虚拟内存被使用时才为其分配物理内存，实验所需的代码量很少，但有很多细节需要被注意。

### 6. Lab Cow [lab6-Cow](https://github.com/jlu-xiurui/MIT6.S081-2021-FALL/blob/master/lab6-cow/Lab%20Copy-on-Write%20Fork.md) 

本实验要求为xv6系统增加 `fork` 函数写时复刻功能，即当 `fork` 完成时父子进程共享同一组只读物理内存页。当进程试图读写这些物理内存时，为该进程重新分配新的物理内存页，并将共享物理内存页的内容拷贝至新内存页。该实验与 `Lazy` 实验内容类似，但难度略微更大一些。

### 7. Lab Thread [lab7-thread](https://github.com/jlu-xiurui/MIT6.S081-2021-FALL/blob/master/lab7-thread/Lab%20Thread.md) 

本实验分为三个部分，首先需要我们为xv6实现用户级线程包，以加深对线程上下文切换的理解。然后，需要我们利用UNIX接口实现简易的并发哈希表及 `barrier` 屏障功能，以提升线程同步及线程安全编程能力。

### 8. Lab Net [lab8-net](https://github.com/jlu-xiurui/MIT6.S081-2021-FALL/blob/master/lab8-net/Lab%20Net.md)

在本实验中，需要补全xv6的网络驱动程序，使其可以基于E1000设备进行网络通信。虽然实验看起来难度很大，且E1000的软件开发手册也十分难懂，但如果跟随实验指导书的提示，本实验的难度则并不是很大。

### 9. Lab Lock [lab9-lock](https://github.com/jlu-xiurui/MIT6.S081-2021-FALL/blob/master/lab9-lock/Lab%20Lock.md)

在本实验中，需要通过降低xv6中内存分配器及磁盘块缓存中锁的粒度，以提升这两个程序的并行性。在 Thread 实验中我们已经尝试了锁的基本使用，而在本实验中则需要对并发条件下的临界区保护具备更深的理解，以在降低锁粒度的条件下不破坏程序的并发安全。


### 10. Lab Filesystem [lab10-Filesystem](https://github.com/jlu-xiurui/MIT6.S081-2021-FALL/blob/master/lab9-lock/Lab%20Lock.md)

在本实验中，我们需要为xv6的文件系统增添一些小功能：inode 的双重间接块及符号链接，总体难度不大。
