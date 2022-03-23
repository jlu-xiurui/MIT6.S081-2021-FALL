#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "date.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  if(argint(0, &n) < 0)
    return -1;
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  if(argaddr(0, &p) < 0)
    return -1;
  return wait(p);
}

uint64
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
  // lab pgtbl: your code here.
    uint64 va,dst;
    int n;
    if(argint(1, &n) < 0 || argaddr(0, &va) < 0 || argaddr(2, &dst) < 0)
        return -1;
    if(n > 64 || n < 0)
        return -1;
    uint64 bitmask = 0,mask = 1;
    pte_t *pte;
    pagetable_t pagetable = myproc()->pagetable;
    while(n > 0){
        pte = walk(pagetable,va,1);
        if(pte){
            if(*pte & PTE_A)
                bitmask |= mask;
            *pte = *pte & (~PTE_A);
        }
        mask <<= 1;
        va = (uint64)((char*)(va)+PGSIZE);
        n--;
    }
    if(copyout(pagetable,dst,(char *)&bitmask,sizeof(bitmask)) < 0)
        return -1;
    return 0;
}
#endif

uint64
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

