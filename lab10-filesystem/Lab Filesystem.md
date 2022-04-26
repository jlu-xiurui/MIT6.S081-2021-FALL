# Lab Filesystem

在本实验中，我们需要为xv6的文件系统增添一些小功能：`inode` 的双重间接块及符号链接，总体难度不大。

## 实验代码及解析

### Large files (moderate)

在本部分中需要为 `inode` 提供双重间接块，使得xv6中的最大文件大小被增加。其原理与 `inode` 中的原有间接块类似：在双重间接块中，存放了 `NINDIRECT` 个间接块，而一个间接块中又存放了 `NINDIRECT` 个直接磁盘块，因此在双重间接块中即可表示 `NINDIRECT*NINDIRECT` 个直接磁盘块，其使得xv6的最大文件大小大大增加。

为了实现双重间接块，我们需要对 `dinode` 、 `inode` 及一系列相关宏进行更改：

```
kernel/fs.h:
 27 #define NDIRECT 11
 28 #define NINDIRECT (BSIZE / sizeof(uint))
 29 #define NDINDIRECT (NINDIRECT * NINDIRECT)
 30 #define MAXFILE (NDIRECT + NINDIRECT + NDINDIRECT)
 31 
 32 // On-disk inode structure
 33 struct dinode {
 34   short type;           // File type
 35   short major;          // Major device number (T_DEVICE only)
 36   short minor;          // Minor device number (T_DEVICE only)
 37   short nlink;          // Number of links to inode in file system
 38   uint size;            // Size of file (bytes)
 39   uint addrs[NDIRECT+2];   // Data block addresses
 40 };
 ...
kernel/file.h
 16 // in-memory copy of an inode
 17 struct inode {
 18   uint dev;           // Device number
 19   uint inum;          // inode number
 20   int ref;            // Reference count
 21   struct sleeplock lock; // protects everything below here
 22   int valid;          // inode has been read from disk?
 23 
 24   short type;         // copy of disk inode
 25   short major;
 26   short minor;
 27   short nlink;
 28   uint size;
 29   uint addrs[NDIRECT+2];
 30 };
```

在这里，我们将 `dinode` 和 `inode` 中 `addrs` 的前11个元素用于存放直接快，第12个元素用于存放间接块，第13个元素用于存放双重间接块。并且，我们需要对 `bmap` 和 `itrunc` 函数中对 `inode` 的 `addrs` 操作方法进行更改：

```
377 static uint
378 bmap(struct inode *ip, uint bn)
379 {
380   uint addr, *a;
381   struct buf *bp;
382 
383   if(bn < NDIRECT){
384     if((addr = ip->addrs[bn]) == 0)
385       ip->addrs[bn] = addr = balloc(ip->dev);
386     return addr;
387   }
388   bn -= NDIRECT;
389 
390   if(bn < NINDIRECT){
391     // Load indirect block, allocating if necessary.
392     if((addr = ip->addrs[NDIRECT]) == 0)
393       ip->addrs[NDIRECT] = addr = balloc(ip->dev);
394     bp = bread(ip->dev, addr);
395     a = (uint*)bp->data;
396     if((addr = a[bn]) == 0){
397       a[bn] = addr = balloc(ip->dev);
398       log_write(bp);
399     }
400     brelse(bp);
401     return addr;
402   }
403 
404   bn -= NINDIRECT;
405   if(bn < NDINDIRECT){
406       int idx1 = bn / NINDIRECT;
407       int idx2 = bn % NINDIRECT;
408       if((addr = ip->addrs[NDIRECT+1]) == 0)
409           ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
410       bp = bread(ip->dev,addr);
411       a = (uint*)bp->data;
412       if((addr = a[idx1]) == 0){
413           a[idx1] = addr = balloc(ip->dev);
414           log_write(bp);
415       }
416       brelse(bp);
417       bp = bread(ip->dev,addr);
418       a = (uint*)bp->data;
419       if((addr = a[idx2]) == 0){
420           a[idx2] = addr = balloc(ip->dev);
421           log_write(bp);
422       }
423       brelse(bp);
424       return addr;
425   }
426 
427   panic("bmap: out of range");
428 }
```

在 `bmap` 中，将块映射分三部分执行：

**378 - 403行**：对于块号小于 `NDIRECT + NINDIRECT` 的块，查找方式与之前相同。

**404 - 409行**：如当前块号大于间接块和直接块的表示范围，则在双重间接块中进行查找。首先根据 `bn` 提取所需磁盘块在双重间接块及其子间接块中的索引 `idx1` 和 `idx2`。如双重间接块为被分配，则分配双重间接块。

 **410 - 424行**：通过两次映射，首先从双重间接块中提取子间接块，并从子间接块中提取所需的磁盘快。在子间接块或所需磁盘块未被分配时，对其进行分配。

```
432 void
433 itrunc(struct inode *ip)
434 {
435     int i, j;
436     struct buf *bp,*subbp;
437     uint *a,*suba;
438 
439     for(i = 0; i < NDIRECT; i++){
440         if(ip->addrs[i]){
441             bfree(ip->dev, ip->addrs[i]);
442             ip->addrs[i] = 0;
443         }
444     }
445 
446     if(ip->addrs[NDIRECT]){
447         bp = bread(ip->dev, ip->addrs[NDIRECT]);
448         a = (uint*)bp->data;
449         for(j = 0; j < NINDIRECT; j++){
450             if(a[j])
451                 bfree(ip->dev, a[j]);
452         }
453         brelse(bp);
454         bfree(ip->dev, ip->addrs[NDIRECT]);
455         ip->addrs[NDIRECT] = 0;
456     }
457 
458     if(ip->addrs[NDIRECT+1]){
459         bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
460         a = (uint*)bp->data;
461         for(i = 0; i < NINDIRECT; i++){
462             if(a[i]){
463                 subbp = bread(ip->dev,a[i]);
464                 suba = (uint*)subbp->data;
465                 for(j = 0; j < NINDIRECT; j++){
466                     if(suba[j])
467                         bfree(ip->dev,suba[j]);
468                 }
469                 brelse(subbp);
470                 bfree(ip->dev,a[i]);
471                 a[i] = 0;
472             }
473         }
474         brelse(bp);
475         bfree(ip->dev, ip->addrs[NDIRECT+1]);
476         ip->addrs[NDIRECT+1] = 0;
477     }
478 
479     ip->size = 0;
480     iupdate(ip);
481 }
```

在 `btrunc` 中，我们需要搜索双重间接块中的所有子间接块，以及子间接块中的所有直接块，并释放其中被分配的块，其实现逻辑比较简单，在这里就不对其进行介绍。

### Symbolic links (moderate)

在本部分中，需要为xv6提供符号链接功能。在UNIX操作系统中，文件链接可以被分为硬链接和符号链接（软连接）两种。其中硬链接即为原xv6中的 `sys_link` 功能，其为链接得到的新文件分配与被链接的旧文件相同的 `inode`，因 `inode` 中存放了构成文件的各磁盘块的块号，因此硬链接得到了原有文件的物理副本，且仅当硬链接文件和原文件均被删除时，构成文件的磁盘块才会被释放；符号连接则仅在新文件中存放了被链接文件的路径名，其链接方式更加轻量且可跨文件系统、跨主机链接，但当被链接文件被删除时符号链接文件也随之失效。

符号链接的具体的实现并不复杂，仅需在系统调用 `sys_symlink` 中创建类型为 `T_SYMLINK` （在 `kernel/stat.h` 中定义）的文件，并在该文件中存放被链接文件的路径名即可：

```
506 uint64
507 sys_symlink(void){
508     char target[MAXPATH], path[MAXPATH];
509     struct inode *ip;
510 
511     if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0)
512         return -1;
513 
514     begin_op();
515     if((ip = create(path,T_SYMLINK,0,0)) == 0){
516         end_op();
517         return -1;
518     }
519 
520     if(writei(ip, 0, (uint64)target, 0, strlen(target)) != strlen(target)){
521         end_op();
522         return -1;
523     }
524     end_op();
525     iunlockput(ip);
526     return 0;
527 }
```

需要注意的点主要有两个：需要使用 `begin_op` 和 `end_op` 包围对文件系统进行操作的代码段，以及在调用末尾释放在 `create` 中获取的 `inode` 锁。除此以外，我们还需对 `sys_open` 的行为进行修正：

```
...
325   int cnt = 0;
326   while(ip->type == T_SYMLINK && cnt < 10 && !(omode & O_NOFOLLOW)){
327       oldip = ip;
328       if(readi(ip,0,(uint64)path,0,ip->size) != ip->size || (ip = namei(path)) == 0){
329           iunlockput(oldip);
330           end_op();
331           return -1;
332       }
333       iunlockput(oldip);
334       ilock(ip);
335       cnt++;
336   }
337 
338   if(cnt == 10){
339       iunlockput(ip);
340       end_op();
341       return -1;
342   }
343   if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
344     if(f)
345       fileclose(f);
346     iunlockput(ip);
347     end_op();
348     return -1;
349   }
...
```

在寻找或创建 `inode` 后，分配 `file` 和文件描述符前，需要根据 `O_NOFOLLOW` （`kernel/fcntl.h`中定义）判断是否对符号链接进行跟踪。在这里，首先对当前 `inode` 类型进行判断，如未指定 `O_NOFOLLOW`、当前文件类型为 `T_SYMLINK` 、且跟随次数小于10，则对该符号链接进行跟随。跟随方式即为从符号链接中读取其指向的路径名，并将当前 `inode` 指定为路径名所对应的文件即可。如无法找到该文件或跟随次数超过10，则 `sys_open` 返回 -1。

## 实验结果

```
== Test running bigfile == running bigfile: OK (88.9s) 
== Test running symlinktest == (0.5s) 
== Test   symlinktest: symlinks == 
  symlinktest: symlinks: OK 
== Test   symlinktest: concurrent symlinks == 
  symlinktest: concurrent symlinks: OK 
== Test usertests == usertests: OK (163.6s) 
== Test time == 
time: OK 
Score: 100/100
```

