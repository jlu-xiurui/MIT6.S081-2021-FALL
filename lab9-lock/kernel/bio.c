// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define HASHSIZE 17

struct {
    struct spinlock lock;
    struct buf buf[NBUF];
  
    struct spinlock hashlock[HASHSIZE];
    struct buf buckets[HASHSIZE];
  // Linked list of all buffers, through prev/next.
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
} bcache;

static int hash(uint dev,uint blockno){
    return (dev + blockno) % HASHSIZE;
}

static void insert(struct buf* buf){
    uint dev = buf->dev,blockno = buf->blockno;
    int idx = hash(dev,blockno);
    buf->next = bcache.buckets[idx].next;
    bcache.buckets[idx].next = buf;
}

static struct buf* find(uint dev,uint blockno){
    struct buf* b;
    int idx = hash(dev,blockno);
    for(b = bcache.buckets[idx].next; b != 0; b = b->next){
        if(b->dev == dev && b->blockno == blockno){
            return b;
        }
    }
    return 0;
}

static void erase(uint dev,uint blockno){
    struct buf* b;
    int idx = hash(dev,blockno);
    for(b = &bcache.buckets[idx]; b->next != 0; b = b->next){
        if(b->next->dev == dev && b->next->blockno == blockno){
            b->next = b->next->next;
            return;
        }
    }
}
void
binit(void)
{
  struct buf *b;

  initlock(&bcache.lock, "bcache");
  // Create linked list of buffers
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    initsleeplock(&b->lock, "buffer");
  }
  for(int i = 0; i < HASHSIZE; i++){
      initlock(&bcache.hashlock[i], "bcache_hash");
  }
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
    struct buf *b;
    
    int idx = hash(dev,blockno);
    // Is the block already cached?
    acquire(&bcache.hashlock[idx]);
    if((b = find(dev,blockno)) != 0){
        b->refcnt++;
        release(&bcache.hashlock[idx]);
        acquiresleep(&b->lock);
        return b;
    }
    
    // Not cached.
    // Recycle the least recently used (LRU) unused buffer.
    for(int i = 0; i < NBUF; i++){
        b = &bcache.buf[i];
        int bucket = hash(b->dev,b->blockno);
        if(bucket != idx){
            acquire(&bcache.hashlock[bucket]);
        }
        if(b->refcnt == 0) {
            erase(b->dev,b->blockno);
            b->dev = dev;
            b->blockno = blockno;
            b->valid = 0;
            b->refcnt = 1;
            insert(b);
            
            if(bucket != idx)
                release(&bcache.hashlock[bucket]);
            release(&bcache.hashlock[idx]);
            acquiresleep(&b->lock);
            return b;
        }
        if(bucket != idx){
            release(&bcache.hashlock[bucket]);
        }
    }
    panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");

  releasesleep(&b->lock);
  int idx = hash(b->dev,b->blockno);
  acquire(&bcache.hashlock[idx]);
  b->refcnt--;
  release(&bcache.hashlock[idx]);
}

void
bpin(struct buf *b) {
  int idx = hash(b->dev,b->blockno);
  acquire(&bcache.hashlock[idx]);
  b->refcnt++;
  release(&bcache.hashlock[idx]);
}

void
bunpin(struct buf *b) {
  int idx = hash(b->dev,b->blockno);
  acquire(&bcache.hashlock[idx]);
  b->refcnt--;
  release(&bcache.hashlock[idx]);
}


