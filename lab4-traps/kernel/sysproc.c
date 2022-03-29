#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "date.h"
#include "param.h"
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
  backtrace();
  return 0;
}

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

uint64
sys_sigalarm(void){
    printf("sigalarm\n");
    int ticks;
    uint64 handler;
    if(argint(0,&ticks) < 0 || argaddr(1,&handler) < 0)
        return -1;
    myproc()->ticks = ticks;
    myproc()->currticks = 0;
    myproc()->handler = handler;
    return 0;
}
uint64
sys_sigreturn(void){
    printf("sigreturn\n");
    struct proc* p = myproc();
    p->handlerlock = 1;
    p->trapframe->epc = p->trapframe->sepc;
    p->trapframe->ra = p->trapframe->sra;
    p->trapframe->sp = p->trapframe->ssp;
    p->trapframe->gp = p->trapframe->sgp;
    p->trapframe->tp = p->trapframe->stp;
    p->trapframe->t0 = p->trapframe->st0;
    p->trapframe->t1 = p->trapframe->st1;
    p->trapframe->t2 = p->trapframe->st2;
    p->trapframe->s0 = p->trapframe->ss0;
    p->trapframe->s1 = p->trapframe->ss1;
    p->trapframe->a0 = p->trapframe->sa0;
    p->trapframe->a1 = p->trapframe->sa1;
    p->trapframe->a2 = p->trapframe->sa2;
    p->trapframe->a3 = p->trapframe->sa3;
    p->trapframe->a4 = p->trapframe->sa4;
    p->trapframe->a5 = p->trapframe->sa5;
    p->trapframe->a6 = p->trapframe->sa6;
    p->trapframe->a7 = p->trapframe->sa7;
    p->trapframe->s2 = p->trapframe->ss2;
    p->trapframe->s3 = p->trapframe->ss3;
    p->trapframe->s4 = p->trapframe->ss4;
    p->trapframe->s5 = p->trapframe->ss5;
    p->trapframe->s6 = p->trapframe->ss6;
    p->trapframe->s7 = p->trapframe->ss7;
    p->trapframe->s8 = p->trapframe->ss8;
    p->trapframe->s9 = p->trapframe->ss9;
    p->trapframe->s10 = p->trapframe->ss10;
    p->trapframe->s11 = p->trapframe->ss11;
    p->trapframe->t3 = p->trapframe->st3;
    p->trapframe->t4 = p->trapframe->st4;
    p->trapframe->t5 = p->trapframe->st5;
    p->trapframe->t6 = p->trapframe->st6;
    return 0;
}
