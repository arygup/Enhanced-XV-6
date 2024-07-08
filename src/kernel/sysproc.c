#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "globals.h"



uint64 sys_sigalarm(void)          // sigalarm
{
  myproc()->current_ticks = 0;     // update ticks
  argint(0, &myproc()->ticks);     // 1st argument retrieve an integer argument from the user's memory space.
  argaddr(1, &myproc()->handler);  // 2nd argument retrieve an address (pointer) argument from the user's memory space.
  return 0;
}

uint64 sys_sigreturn(void)        // sigreturn gpt
{
    struct proc* p = myproc();

    // Restore the saved trapframe from sigalarm
    memmove(p->trapframe, p->sigalarm, PGSIZE);

    // Free the memory allocated for sigalarm
    kfree(p->sigalarm);
    // p->sigalarm = NULL;
    
    // if(p->sigalarm)
    //   return -1;
    // Reset current_ticks to 0
    p->current_ticks = 0;

    // Return the value of a0 from the restored trapframe
    return p->trapframe->a0;
}



uint64 sys_set_priority(void)   // chat gpt 
{                               // copilot
  int pid, priority;
  int oldpriority = 0, flag = 0;
  argint(0, &priority);
  argint(1, &pid);
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
  {
    acquire(&p->lock);
    if (p->pid == pid)
    {
      oldpriority = p->priority;
      p->dynamic_priority = priority + 25;
      p->priority = priority;
      release(&p->lock);
      flag = 1;
      break;
    }
    release(&p->lock);
  }
  if (flag == 0)
  {
    printf("Process with PID %d does not exist\n", pid);
    return -1;
  }
  if (oldpriority > priority)
    yield();
  // printf("set_priority: %d %d %d\n", pid, oldpriority, priority);
  return oldpriority;
}


uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0; // not reached
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
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if (growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n)
  {
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
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
sys_waitx(void)
{
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
  argaddr(1, &addr1); // user virtual memory
  argaddr(2, &addr2);
  int ret = waitx(addr, &wtime, &rtime);
  struct proc *p = myproc();
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    return -1;
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    return -1;
  return ret;
}