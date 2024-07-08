// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;


// COW 
int nump_using[(PGROUNDUP(PHYSTOP)/PGSIZE)];
struct spinlock nump_using_lock;

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

void
kinit()
{
  initlock(&kmem.lock, "kmem");

  // COW init nump_using as 0
  initlock(&nump_using_lock,"nump_using lock");
  acquire(&nump_using_lock);
  int sz;
  int i = 0;
  sz = PGROUNDUP(PHYSTOP)/PGSIZE;
  while(sz > i)
  {
    nump_using[i] = 1;
    i++;
  }
  release(&nump_using_lock);

  freerange(end, (void*)PHYSTOP);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;
  // if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
  //   panic("kfree");

  // COW
  int flg = 0;
  acquire(&nump_using_lock);
  int idx = (uint64)pa/PGSIZE;
  nump_using[idx] = nump_using[idx] - 1;  // decrement the count of number of processes using this page 
  if(nump_using[idx] >= 1)
    flg = 1;
  if(nump_using[idx] < 0)
    printf("kfree: nump_using < 0");
  release(&nump_using_lock);
  if(flg == 1)
    return;

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  if(r)
  {
    memset((char*)r, 5, PGSIZE); // fill with junk
    // COW
    int idxx = (uint64)r/PGSIZE;
    acquire(&nump_using_lock);
    nump_using[idxx] = nump_using[idxx] + 1;  // mark that this page is being used by one more process
    if(nump_using[idxx] < 1)
      printf("kalloc: nump_using < 1");
    release(&nump_using_lock);
  }
  return (void*)r;
}



