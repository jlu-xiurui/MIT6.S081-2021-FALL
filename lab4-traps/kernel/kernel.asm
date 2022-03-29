
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001e117          	auipc	sp,0x1e
    80000004:	14010113          	addi	sp,sp,320 # 8001e140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	163050ef          	jal	ra,80005978 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	374080e7          	jalr	884(ra) # 800063ce <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	414080e7          	jalr	1044(ra) # 80006482 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	d9e080e7          	jalr	-610(ra) # 80005e28 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	24a080e7          	jalr	586(ra) # 8000633e <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00026517          	auipc	a0,0x26
    80000104:	14050513          	addi	a0,a0,320 # 80026240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	2a2080e7          	jalr	674(ra) # 800063ce <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	33e080e7          	jalr	830(ra) # 80006482 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	314080e7          	jalr	788(ra) # 80006482 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	aee080e7          	jalr	-1298(ra) # 80000e1c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00009717          	auipc	a4,0x9
    8000033a:	cca70713          	addi	a4,a4,-822 # 80009000 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	ad2080e7          	jalr	-1326(ra) # 80000e1c <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	b16080e7          	jalr	-1258(ra) # 80005e72 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	736080e7          	jalr	1846(ra) # 80001aa2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	f8c080e7          	jalr	-116(ra) # 80005300 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fe4080e7          	jalr	-28(ra) # 80001360 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	9b6080e7          	jalr	-1610(ra) # 80005d3a <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	ccc080e7          	jalr	-820(ra) # 80006058 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	ad6080e7          	jalr	-1322(ra) # 80005e72 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	ac6080e7          	jalr	-1338(ra) # 80005e72 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	ab6080e7          	jalr	-1354(ra) # 80005e72 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	322080e7          	jalr	802(ra) # 800006ee <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	990080e7          	jalr	-1648(ra) # 80000d6c <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	696080e7          	jalr	1686(ra) # 80001a7a <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	6b6080e7          	jalr	1718(ra) # 80001aa2 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	ef6080e7          	jalr	-266(ra) # 800052ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	f04080e7          	jalr	-252(ra) # 80005300 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	0dc080e7          	jalr	220(ra) # 800024e0 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	76c080e7          	jalr	1900(ra) # 80002b78 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	716080e7          	jalr	1814(ra) # 80003b2a <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	006080e7          	jalr	6(ra) # 80005422 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d0a080e7          	jalr	-758(ra) # 8000112e <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00009717          	auipc	a4,0x9
    80000436:	bcf72723          	sw	a5,-1074(a4) # 80009000 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000442:	00009797          	auipc	a5,0x9
    80000446:	bc67b783          	ld	a5,-1082(a5) # 80009008 <kernel_pagetable>
    8000044a:	83b1                	srli	a5,a5,0xc
    8000044c:	577d                	li	a4,-1
    8000044e:	177e                	slli	a4,a4,0x3f
    80000450:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000452:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000456:	12000073          	sfence.vma
  sfence_vma();
}
    8000045a:	6422                	ld	s0,8(sp)
    8000045c:	0141                	addi	sp,sp,16
    8000045e:	8082                	ret

0000000080000460 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000460:	7139                	addi	sp,sp,-64
    80000462:	fc06                	sd	ra,56(sp)
    80000464:	f822                	sd	s0,48(sp)
    80000466:	f426                	sd	s1,40(sp)
    80000468:	f04a                	sd	s2,32(sp)
    8000046a:	ec4e                	sd	s3,24(sp)
    8000046c:	e852                	sd	s4,16(sp)
    8000046e:	e456                	sd	s5,8(sp)
    80000470:	e05a                	sd	s6,0(sp)
    80000472:	0080                	addi	s0,sp,64
    80000474:	84aa                	mv	s1,a0
    80000476:	89ae                	mv	s3,a1
    80000478:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047a:	57fd                	li	a5,-1
    8000047c:	83e9                	srli	a5,a5,0x1a
    8000047e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000480:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000482:	04b7f263          	bgeu	a5,a1,800004c6 <walk+0x66>
    panic("walk");
    80000486:	00008517          	auipc	a0,0x8
    8000048a:	bca50513          	addi	a0,a0,-1078 # 80008050 <etext+0x50>
    8000048e:	00006097          	auipc	ra,0x6
    80000492:	99a080e7          	jalr	-1638(ra) # 80005e28 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000496:	060a8663          	beqz	s5,80000502 <walk+0xa2>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	c7e080e7          	jalr	-898(ra) # 80000118 <kalloc>
    800004a2:	84aa                	mv	s1,a0
    800004a4:	c529                	beqz	a0,800004ee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a6:	6605                	lui	a2,0x1
    800004a8:	4581                	li	a1,0
    800004aa:	00000097          	auipc	ra,0x0
    800004ae:	cce080e7          	jalr	-818(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b2:	00c4d793          	srli	a5,s1,0xc
    800004b6:	07aa                	slli	a5,a5,0xa
    800004b8:	0017e793          	ori	a5,a5,1
    800004bc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c0:	3a5d                	addiw	s4,s4,-9
    800004c2:	036a0063          	beq	s4,s6,800004e2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c6:	0149d933          	srl	s2,s3,s4
    800004ca:	1ff97913          	andi	s2,s2,511
    800004ce:	090e                	slli	s2,s2,0x3
    800004d0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d2:	00093483          	ld	s1,0(s2)
    800004d6:	0014f793          	andi	a5,s1,1
    800004da:	dfd5                	beqz	a5,80000496 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004dc:	80a9                	srli	s1,s1,0xa
    800004de:	04b2                	slli	s1,s1,0xc
    800004e0:	b7c5                	j	800004c0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e2:	00c9d513          	srli	a0,s3,0xc
    800004e6:	1ff57513          	andi	a0,a0,511
    800004ea:	050e                	slli	a0,a0,0x3
    800004ec:	9526                	add	a0,a0,s1
}
    800004ee:	70e2                	ld	ra,56(sp)
    800004f0:	7442                	ld	s0,48(sp)
    800004f2:	74a2                	ld	s1,40(sp)
    800004f4:	7902                	ld	s2,32(sp)
    800004f6:	69e2                	ld	s3,24(sp)
    800004f8:	6a42                	ld	s4,16(sp)
    800004fa:	6aa2                	ld	s5,8(sp)
    800004fc:	6b02                	ld	s6,0(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
        return 0;
    80000502:	4501                	li	a0,0
    80000504:	b7ed                	j	800004ee <walk+0x8e>

0000000080000506 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000506:	57fd                	li	a5,-1
    80000508:	83e9                	srli	a5,a5,0x1a
    8000050a:	00b7f463          	bgeu	a5,a1,80000512 <walkaddr+0xc>
    return 0;
    8000050e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000510:	8082                	ret
{
    80000512:	1141                	addi	sp,sp,-16
    80000514:	e406                	sd	ra,8(sp)
    80000516:	e022                	sd	s0,0(sp)
    80000518:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051a:	4601                	li	a2,0
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	f44080e7          	jalr	-188(ra) # 80000460 <walk>
  if(pte == 0)
    80000524:	c105                	beqz	a0,80000544 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000526:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000528:	0117f693          	andi	a3,a5,17
    8000052c:	4745                	li	a4,17
    return 0;
    8000052e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000530:	00e68663          	beq	a3,a4,8000053c <walkaddr+0x36>
}
    80000534:	60a2                	ld	ra,8(sp)
    80000536:	6402                	ld	s0,0(sp)
    80000538:	0141                	addi	sp,sp,16
    8000053a:	8082                	ret
  pa = PTE2PA(*pte);
    8000053c:	00a7d513          	srli	a0,a5,0xa
    80000540:	0532                	slli	a0,a0,0xc
  return pa;
    80000542:	bfcd                	j	80000534 <walkaddr+0x2e>
    return 0;
    80000544:	4501                	li	a0,0
    80000546:	b7fd                	j	80000534 <walkaddr+0x2e>

0000000080000548 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000548:	715d                	addi	sp,sp,-80
    8000054a:	e486                	sd	ra,72(sp)
    8000054c:	e0a2                	sd	s0,64(sp)
    8000054e:	fc26                	sd	s1,56(sp)
    80000550:	f84a                	sd	s2,48(sp)
    80000552:	f44e                	sd	s3,40(sp)
    80000554:	f052                	sd	s4,32(sp)
    80000556:	ec56                	sd	s5,24(sp)
    80000558:	e85a                	sd	s6,16(sp)
    8000055a:	e45e                	sd	s7,8(sp)
    8000055c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055e:	c205                	beqz	a2,8000057e <mappages+0x36>
    80000560:	8aaa                	mv	s5,a0
    80000562:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000564:	77fd                	lui	a5,0xfffff
    80000566:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056a:	15fd                	addi	a1,a1,-1
    8000056c:	00c589b3          	add	s3,a1,a2
    80000570:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000574:	8952                	mv	s2,s4
    80000576:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057a:	6b85                	lui	s7,0x1
    8000057c:	a015                	j	800005a0 <mappages+0x58>
    panic("mappages: size");
    8000057e:	00008517          	auipc	a0,0x8
    80000582:	ada50513          	addi	a0,a0,-1318 # 80008058 <etext+0x58>
    80000586:	00006097          	auipc	ra,0x6
    8000058a:	8a2080e7          	jalr	-1886(ra) # 80005e28 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	892080e7          	jalr	-1902(ra) # 80005e28 <panic>
    a += PGSIZE;
    8000059e:	995e                	add	s2,s2,s7
  for(;;){
    800005a0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	4605                	li	a2,1
    800005a6:	85ca                	mv	a1,s2
    800005a8:	8556                	mv	a0,s5
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	eb6080e7          	jalr	-330(ra) # 80000460 <walk>
    800005b2:	cd19                	beqz	a0,800005d0 <mappages+0x88>
    if(*pte & PTE_V)
    800005b4:	611c                	ld	a5,0(a0)
    800005b6:	8b85                	andi	a5,a5,1
    800005b8:	fbf9                	bnez	a5,8000058e <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005ba:	80b1                	srli	s1,s1,0xc
    800005bc:	04aa                	slli	s1,s1,0xa
    800005be:	0164e4b3          	or	s1,s1,s6
    800005c2:	0014e493          	ori	s1,s1,1
    800005c6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005c8:	fd391be3          	bne	s2,s3,8000059e <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005cc:	4501                	li	a0,0
    800005ce:	a011                	j	800005d2 <mappages+0x8a>
      return -1;
    800005d0:	557d                	li	a0,-1
}
    800005d2:	60a6                	ld	ra,72(sp)
    800005d4:	6406                	ld	s0,64(sp)
    800005d6:	74e2                	ld	s1,56(sp)
    800005d8:	7942                	ld	s2,48(sp)
    800005da:	79a2                	ld	s3,40(sp)
    800005dc:	7a02                	ld	s4,32(sp)
    800005de:	6ae2                	ld	s5,24(sp)
    800005e0:	6b42                	ld	s6,16(sp)
    800005e2:	6ba2                	ld	s7,8(sp)
    800005e4:	6161                	addi	sp,sp,80
    800005e6:	8082                	ret

00000000800005e8 <kvmmap>:
{
    800005e8:	1141                	addi	sp,sp,-16
    800005ea:	e406                	sd	ra,8(sp)
    800005ec:	e022                	sd	s0,0(sp)
    800005ee:	0800                	addi	s0,sp,16
    800005f0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f2:	86b2                	mv	a3,a2
    800005f4:	863e                	mv	a2,a5
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	f52080e7          	jalr	-174(ra) # 80000548 <mappages>
    800005fe:	e509                	bnez	a0,80000608 <kvmmap+0x20>
}
    80000600:	60a2                	ld	ra,8(sp)
    80000602:	6402                	ld	s0,0(sp)
    80000604:	0141                	addi	sp,sp,16
    80000606:	8082                	ret
    panic("kvmmap");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a7050513          	addi	a0,a0,-1424 # 80008078 <etext+0x78>
    80000610:	00006097          	auipc	ra,0x6
    80000614:	818080e7          	jalr	-2024(ra) # 80005e28 <panic>

0000000080000618 <kvmmake>:
{
    80000618:	1101                	addi	sp,sp,-32
    8000061a:	ec06                	sd	ra,24(sp)
    8000061c:	e822                	sd	s0,16(sp)
    8000061e:	e426                	sd	s1,8(sp)
    80000620:	e04a                	sd	s2,0(sp)
    80000622:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000624:	00000097          	auipc	ra,0x0
    80000628:	af4080e7          	jalr	-1292(ra) # 80000118 <kalloc>
    8000062c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062e:	6605                	lui	a2,0x1
    80000630:	4581                	li	a1,0
    80000632:	00000097          	auipc	ra,0x0
    80000636:	b46080e7          	jalr	-1210(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063a:	4719                	li	a4,6
    8000063c:	6685                	lui	a3,0x1
    8000063e:	10000637          	lui	a2,0x10000
    80000642:	100005b7          	lui	a1,0x10000
    80000646:	8526                	mv	a0,s1
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	fa0080e7          	jalr	-96(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000650:	4719                	li	a4,6
    80000652:	6685                	lui	a3,0x1
    80000654:	10001637          	lui	a2,0x10001
    80000658:	100015b7          	lui	a1,0x10001
    8000065c:	8526                	mv	a0,s1
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	f8a080e7          	jalr	-118(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000666:	4719                	li	a4,6
    80000668:	004006b7          	lui	a3,0x400
    8000066c:	0c000637          	lui	a2,0xc000
    80000670:	0c0005b7          	lui	a1,0xc000
    80000674:	8526                	mv	a0,s1
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	f72080e7          	jalr	-142(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067e:	00008917          	auipc	s2,0x8
    80000682:	98290913          	addi	s2,s2,-1662 # 80008000 <etext>
    80000686:	4729                	li	a4,10
    80000688:	80008697          	auipc	a3,0x80008
    8000068c:	97868693          	addi	a3,a3,-1672 # 8000 <_entry-0x7fff8000>
    80000690:	4605                	li	a2,1
    80000692:	067e                	slli	a2,a2,0x1f
    80000694:	85b2                	mv	a1,a2
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	f50080e7          	jalr	-176(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	46c5                	li	a3,17
    800006a4:	06ee                	slli	a3,a3,0x1b
    800006a6:	412686b3          	sub	a3,a3,s2
    800006aa:	864a                	mv	a2,s2
    800006ac:	85ca                	mv	a1,s2
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f38080e7          	jalr	-200(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b8:	4729                	li	a4,10
    800006ba:	6685                	lui	a3,0x1
    800006bc:	00007617          	auipc	a2,0x7
    800006c0:	94460613          	addi	a2,a2,-1724 # 80007000 <_trampoline>
    800006c4:	040005b7          	lui	a1,0x4000
    800006c8:	15fd                	addi	a1,a1,-1
    800006ca:	05b2                	slli	a1,a1,0xc
    800006cc:	8526                	mv	a0,s1
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	f1a080e7          	jalr	-230(ra) # 800005e8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	5fe080e7          	jalr	1534(ra) # 80000cd6 <proc_mapstacks>
}
    800006e0:	8526                	mv	a0,s1
    800006e2:	60e2                	ld	ra,24(sp)
    800006e4:	6442                	ld	s0,16(sp)
    800006e6:	64a2                	ld	s1,8(sp)
    800006e8:	6902                	ld	s2,0(sp)
    800006ea:	6105                	addi	sp,sp,32
    800006ec:	8082                	ret

00000000800006ee <kvminit>:
{
    800006ee:	1141                	addi	sp,sp,-16
    800006f0:	e406                	sd	ra,8(sp)
    800006f2:	e022                	sd	s0,0(sp)
    800006f4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f22080e7          	jalr	-222(ra) # 80000618 <kvmmake>
    800006fe:	00009797          	auipc	a5,0x9
    80000702:	90a7b523          	sd	a0,-1782(a5) # 80009008 <kernel_pagetable>
}
    80000706:	60a2                	ld	ra,8(sp)
    80000708:	6402                	ld	s0,0(sp)
    8000070a:	0141                	addi	sp,sp,16
    8000070c:	8082                	ret

000000008000070e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070e:	715d                	addi	sp,sp,-80
    80000710:	e486                	sd	ra,72(sp)
    80000712:	e0a2                	sd	s0,64(sp)
    80000714:	fc26                	sd	s1,56(sp)
    80000716:	f84a                	sd	s2,48(sp)
    80000718:	f44e                	sd	s3,40(sp)
    8000071a:	f052                	sd	s4,32(sp)
    8000071c:	ec56                	sd	s5,24(sp)
    8000071e:	e85a                	sd	s6,16(sp)
    80000720:	e45e                	sd	s7,8(sp)
    80000722:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000724:	03459793          	slli	a5,a1,0x34
    80000728:	e795                	bnez	a5,80000754 <uvmunmap+0x46>
    8000072a:	8a2a                	mv	s4,a0
    8000072c:	892e                	mv	s2,a1
    8000072e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6b05                	lui	s6,0x1
    8000073a:	0735e863          	bltu	a1,s3,800007aa <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073e:	60a6                	ld	ra,72(sp)
    80000740:	6406                	ld	s0,64(sp)
    80000742:	74e2                	ld	s1,56(sp)
    80000744:	7942                	ld	s2,48(sp)
    80000746:	79a2                	ld	s3,40(sp)
    80000748:	7a02                	ld	s4,32(sp)
    8000074a:	6ae2                	ld	s5,24(sp)
    8000074c:	6b42                	ld	s6,16(sp)
    8000074e:	6ba2                	ld	s7,8(sp)
    80000750:	6161                	addi	sp,sp,80
    80000752:	8082                	ret
    panic("uvmunmap: not aligned");
    80000754:	00008517          	auipc	a0,0x8
    80000758:	92c50513          	addi	a0,a0,-1748 # 80008080 <etext+0x80>
    8000075c:	00005097          	auipc	ra,0x5
    80000760:	6cc080e7          	jalr	1740(ra) # 80005e28 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	6bc080e7          	jalr	1724(ra) # 80005e28 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	6ac080e7          	jalr	1708(ra) # 80005e28 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	69c080e7          	jalr	1692(ra) # 80005e28 <panic>
      uint64 pa = PTE2PA(*pte);
    80000794:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000796:	0532                	slli	a0,a0,0xc
    80000798:	00000097          	auipc	ra,0x0
    8000079c:	884080e7          	jalr	-1916(ra) # 8000001c <kfree>
    *pte = 0;
    800007a0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a4:	995a                	add	s2,s2,s6
    800007a6:	f9397ce3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007aa:	4601                	li	a2,0
    800007ac:	85ca                	mv	a1,s2
    800007ae:	8552                	mv	a0,s4
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	cb0080e7          	jalr	-848(ra) # 80000460 <walk>
    800007b8:	84aa                	mv	s1,a0
    800007ba:	d54d                	beqz	a0,80000764 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007bc:	6108                	ld	a0,0(a0)
    800007be:	00157793          	andi	a5,a0,1
    800007c2:	dbcd                	beqz	a5,80000774 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c4:	3ff57793          	andi	a5,a0,1023
    800007c8:	fb778ee3          	beq	a5,s7,80000784 <uvmunmap+0x76>
    if(do_free){
    800007cc:	fc0a8ae3          	beqz	s5,800007a0 <uvmunmap+0x92>
    800007d0:	b7d1                	j	80000794 <uvmunmap+0x86>

00000000800007d2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d2:	1101                	addi	sp,sp,-32
    800007d4:	ec06                	sd	ra,24(sp)
    800007d6:	e822                	sd	s0,16(sp)
    800007d8:	e426                	sd	s1,8(sp)
    800007da:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	93c080e7          	jalr	-1732(ra) # 80000118 <kalloc>
    800007e4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e6:	c519                	beqz	a0,800007f4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e8:	6605                	lui	a2,0x1
    800007ea:	4581                	li	a1,0
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	98c080e7          	jalr	-1652(ra) # 80000178 <memset>
  return pagetable;
}
    800007f4:	8526                	mv	a0,s1
    800007f6:	60e2                	ld	ra,24(sp)
    800007f8:	6442                	ld	s0,16(sp)
    800007fa:	64a2                	ld	s1,8(sp)
    800007fc:	6105                	addi	sp,sp,32
    800007fe:	8082                	ret

0000000080000800 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000800:	7179                	addi	sp,sp,-48
    80000802:	f406                	sd	ra,40(sp)
    80000804:	f022                	sd	s0,32(sp)
    80000806:	ec26                	sd	s1,24(sp)
    80000808:	e84a                	sd	s2,16(sp)
    8000080a:	e44e                	sd	s3,8(sp)
    8000080c:	e052                	sd	s4,0(sp)
    8000080e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000810:	6785                	lui	a5,0x1
    80000812:	04f67863          	bgeu	a2,a5,80000862 <uvminit+0x62>
    80000816:	8a2a                	mv	s4,a0
    80000818:	89ae                	mv	s3,a1
    8000081a:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	8fc080e7          	jalr	-1796(ra) # 80000118 <kalloc>
    80000824:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000826:	6605                	lui	a2,0x1
    80000828:	4581                	li	a1,0
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	94e080e7          	jalr	-1714(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000832:	4779                	li	a4,30
    80000834:	86ca                	mv	a3,s2
    80000836:	6605                	lui	a2,0x1
    80000838:	4581                	li	a1,0
    8000083a:	8552                	mv	a0,s4
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	d0c080e7          	jalr	-756(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    80000844:	8626                	mv	a2,s1
    80000846:	85ce                	mv	a1,s3
    80000848:	854a                	mv	a0,s2
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	98e080e7          	jalr	-1650(ra) # 800001d8 <memmove>
}
    80000852:	70a2                	ld	ra,40(sp)
    80000854:	7402                	ld	s0,32(sp)
    80000856:	64e2                	ld	s1,24(sp)
    80000858:	6942                	ld	s2,16(sp)
    8000085a:	69a2                	ld	s3,8(sp)
    8000085c:	6a02                	ld	s4,0(sp)
    8000085e:	6145                	addi	sp,sp,48
    80000860:	8082                	ret
    panic("inituvm: more than a page");
    80000862:	00008517          	auipc	a0,0x8
    80000866:	87650513          	addi	a0,a0,-1930 # 800080d8 <etext+0xd8>
    8000086a:	00005097          	auipc	ra,0x5
    8000086e:	5be080e7          	jalr	1470(ra) # 80005e28 <panic>

0000000080000872 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000872:	1101                	addi	sp,sp,-32
    80000874:	ec06                	sd	ra,24(sp)
    80000876:	e822                	sd	s0,16(sp)
    80000878:	e426                	sd	s1,8(sp)
    8000087a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087e:	00b67d63          	bgeu	a2,a1,80000898 <uvmdealloc+0x26>
    80000882:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000884:	6785                	lui	a5,0x1
    80000886:	17fd                	addi	a5,a5,-1
    80000888:	00f60733          	add	a4,a2,a5
    8000088c:	767d                	lui	a2,0xfffff
    8000088e:	8f71                	and	a4,a4,a2
    80000890:	97ae                	add	a5,a5,a1
    80000892:	8ff1                	and	a5,a5,a2
    80000894:	00f76863          	bltu	a4,a5,800008a4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000898:	8526                	mv	a0,s1
    8000089a:	60e2                	ld	ra,24(sp)
    8000089c:	6442                	ld	s0,16(sp)
    8000089e:	64a2                	ld	s1,8(sp)
    800008a0:	6105                	addi	sp,sp,32
    800008a2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a4:	8f99                	sub	a5,a5,a4
    800008a6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a8:	4685                	li	a3,1
    800008aa:	0007861b          	sext.w	a2,a5
    800008ae:	85ba                	mv	a1,a4
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	e5e080e7          	jalr	-418(ra) # 8000070e <uvmunmap>
    800008b8:	b7c5                	j	80000898 <uvmdealloc+0x26>

00000000800008ba <uvmalloc>:
  if(newsz < oldsz)
    800008ba:	0ab66163          	bltu	a2,a1,8000095c <uvmalloc+0xa2>
{
    800008be:	7139                	addi	sp,sp,-64
    800008c0:	fc06                	sd	ra,56(sp)
    800008c2:	f822                	sd	s0,48(sp)
    800008c4:	f426                	sd	s1,40(sp)
    800008c6:	f04a                	sd	s2,32(sp)
    800008c8:	ec4e                	sd	s3,24(sp)
    800008ca:	e852                	sd	s4,16(sp)
    800008cc:	e456                	sd	s5,8(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6985                	lui	s3,0x1
    800008d6:	19fd                	addi	s3,s3,-1
    800008d8:	95ce                	add	a1,a1,s3
    800008da:	79fd                	lui	s3,0xfffff
    800008dc:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e0:	08c9f063          	bgeu	s3,a2,80000960 <uvmalloc+0xa6>
    800008e4:	894e                	mv	s2,s3
    mem = kalloc();
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	832080e7          	jalr	-1998(ra) # 80000118 <kalloc>
    800008ee:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f0:	c51d                	beqz	a0,8000091e <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008f2:	6605                	lui	a2,0x1
    800008f4:	4581                	li	a1,0
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	882080e7          	jalr	-1918(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008fe:	4779                	li	a4,30
    80000900:	86a6                	mv	a3,s1
    80000902:	6605                	lui	a2,0x1
    80000904:	85ca                	mv	a1,s2
    80000906:	8556                	mv	a0,s5
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	c40080e7          	jalr	-960(ra) # 80000548 <mappages>
    80000910:	e905                	bnez	a0,80000940 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000912:	6785                	lui	a5,0x1
    80000914:	993e                	add	s2,s2,a5
    80000916:	fd4968e3          	bltu	s2,s4,800008e6 <uvmalloc+0x2c>
  return newsz;
    8000091a:	8552                	mv	a0,s4
    8000091c:	a809                	j	8000092e <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000091e:	864e                	mv	a2,s3
    80000920:	85ca                	mv	a1,s2
    80000922:	8556                	mv	a0,s5
    80000924:	00000097          	auipc	ra,0x0
    80000928:	f4e080e7          	jalr	-178(ra) # 80000872 <uvmdealloc>
      return 0;
    8000092c:	4501                	li	a0,0
}
    8000092e:	70e2                	ld	ra,56(sp)
    80000930:	7442                	ld	s0,48(sp)
    80000932:	74a2                	ld	s1,40(sp)
    80000934:	7902                	ld	s2,32(sp)
    80000936:	69e2                	ld	s3,24(sp)
    80000938:	6a42                	ld	s4,16(sp)
    8000093a:	6aa2                	ld	s5,8(sp)
    8000093c:	6121                	addi	sp,sp,64
    8000093e:	8082                	ret
      kfree(mem);
    80000940:	8526                	mv	a0,s1
    80000942:	fffff097          	auipc	ra,0xfffff
    80000946:	6da080e7          	jalr	1754(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094a:	864e                	mv	a2,s3
    8000094c:	85ca                	mv	a1,s2
    8000094e:	8556                	mv	a0,s5
    80000950:	00000097          	auipc	ra,0x0
    80000954:	f22080e7          	jalr	-222(ra) # 80000872 <uvmdealloc>
      return 0;
    80000958:	4501                	li	a0,0
    8000095a:	bfd1                	j	8000092e <uvmalloc+0x74>
    return oldsz;
    8000095c:	852e                	mv	a0,a1
}
    8000095e:	8082                	ret
  return newsz;
    80000960:	8532                	mv	a0,a2
    80000962:	b7f1                	j	8000092e <uvmalloc+0x74>

0000000080000964 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000964:	7179                	addi	sp,sp,-48
    80000966:	f406                	sd	ra,40(sp)
    80000968:	f022                	sd	s0,32(sp)
    8000096a:	ec26                	sd	s1,24(sp)
    8000096c:	e84a                	sd	s2,16(sp)
    8000096e:	e44e                	sd	s3,8(sp)
    80000970:	e052                	sd	s4,0(sp)
    80000972:	1800                	addi	s0,sp,48
    80000974:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000976:	84aa                	mv	s1,a0
    80000978:	6905                	lui	s2,0x1
    8000097a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000097c:	4985                	li	s3,1
    8000097e:	a821                	j	80000996 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000980:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000982:	0532                	slli	a0,a0,0xc
    80000984:	00000097          	auipc	ra,0x0
    80000988:	fe0080e7          	jalr	-32(ra) # 80000964 <freewalk>
      pagetable[i] = 0;
    8000098c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000990:	04a1                	addi	s1,s1,8
    80000992:	03248163          	beq	s1,s2,800009b4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000996:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000998:	00f57793          	andi	a5,a0,15
    8000099c:	ff3782e3          	beq	a5,s3,80000980 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a0:	8905                	andi	a0,a0,1
    800009a2:	d57d                	beqz	a0,80000990 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009a4:	00007517          	auipc	a0,0x7
    800009a8:	75450513          	addi	a0,a0,1876 # 800080f8 <etext+0xf8>
    800009ac:	00005097          	auipc	ra,0x5
    800009b0:	47c080e7          	jalr	1148(ra) # 80005e28 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b4:	8552                	mv	a0,s4
    800009b6:	fffff097          	auipc	ra,0xfffff
    800009ba:	666080e7          	jalr	1638(ra) # 8000001c <kfree>
}
    800009be:	70a2                	ld	ra,40(sp)
    800009c0:	7402                	ld	s0,32(sp)
    800009c2:	64e2                	ld	s1,24(sp)
    800009c4:	6942                	ld	s2,16(sp)
    800009c6:	69a2                	ld	s3,8(sp)
    800009c8:	6a02                	ld	s4,0(sp)
    800009ca:	6145                	addi	sp,sp,48
    800009cc:	8082                	ret

00000000800009ce <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ce:	1101                	addi	sp,sp,-32
    800009d0:	ec06                	sd	ra,24(sp)
    800009d2:	e822                	sd	s0,16(sp)
    800009d4:	e426                	sd	s1,8(sp)
    800009d6:	1000                	addi	s0,sp,32
    800009d8:	84aa                	mv	s1,a0
  if(sz > 0)
    800009da:	e999                	bnez	a1,800009f0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009dc:	8526                	mv	a0,s1
    800009de:	00000097          	auipc	ra,0x0
    800009e2:	f86080e7          	jalr	-122(ra) # 80000964 <freewalk>
}
    800009e6:	60e2                	ld	ra,24(sp)
    800009e8:	6442                	ld	s0,16(sp)
    800009ea:	64a2                	ld	s1,8(sp)
    800009ec:	6105                	addi	sp,sp,32
    800009ee:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f0:	6605                	lui	a2,0x1
    800009f2:	167d                	addi	a2,a2,-1
    800009f4:	962e                	add	a2,a2,a1
    800009f6:	4685                	li	a3,1
    800009f8:	8231                	srli	a2,a2,0xc
    800009fa:	4581                	li	a1,0
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	d12080e7          	jalr	-750(ra) # 8000070e <uvmunmap>
    80000a04:	bfe1                	j	800009dc <uvmfree+0xe>

0000000080000a06 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	c679                	beqz	a2,80000ad4 <uvmcopy+0xce>
{
    80000a08:	715d                	addi	sp,sp,-80
    80000a0a:	e486                	sd	ra,72(sp)
    80000a0c:	e0a2                	sd	s0,64(sp)
    80000a0e:	fc26                	sd	s1,56(sp)
    80000a10:	f84a                	sd	s2,48(sp)
    80000a12:	f44e                	sd	s3,40(sp)
    80000a14:	f052                	sd	s4,32(sp)
    80000a16:	ec56                	sd	s5,24(sp)
    80000a18:	e85a                	sd	s6,16(sp)
    80000a1a:	e45e                	sd	s7,8(sp)
    80000a1c:	0880                	addi	s0,sp,80
    80000a1e:	8b2a                	mv	s6,a0
    80000a20:	8aae                	mv	s5,a1
    80000a22:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a24:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a26:	4601                	li	a2,0
    80000a28:	85ce                	mv	a1,s3
    80000a2a:	855a                	mv	a0,s6
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	a34080e7          	jalr	-1484(ra) # 80000460 <walk>
    80000a34:	c531                	beqz	a0,80000a80 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a36:	6118                	ld	a4,0(a0)
    80000a38:	00177793          	andi	a5,a4,1
    80000a3c:	cbb1                	beqz	a5,80000a90 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3e:	00a75593          	srli	a1,a4,0xa
    80000a42:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a46:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a4a:	fffff097          	auipc	ra,0xfffff
    80000a4e:	6ce080e7          	jalr	1742(ra) # 80000118 <kalloc>
    80000a52:	892a                	mv	s2,a0
    80000a54:	c939                	beqz	a0,80000aaa <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a56:	6605                	lui	a2,0x1
    80000a58:	85de                	mv	a1,s7
    80000a5a:	fffff097          	auipc	ra,0xfffff
    80000a5e:	77e080e7          	jalr	1918(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a62:	8726                	mv	a4,s1
    80000a64:	86ca                	mv	a3,s2
    80000a66:	6605                	lui	a2,0x1
    80000a68:	85ce                	mv	a1,s3
    80000a6a:	8556                	mv	a0,s5
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	adc080e7          	jalr	-1316(ra) # 80000548 <mappages>
    80000a74:	e515                	bnez	a0,80000aa0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a76:	6785                	lui	a5,0x1
    80000a78:	99be                	add	s3,s3,a5
    80000a7a:	fb49e6e3          	bltu	s3,s4,80000a26 <uvmcopy+0x20>
    80000a7e:	a081                	j	80000abe <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a80:	00007517          	auipc	a0,0x7
    80000a84:	68850513          	addi	a0,a0,1672 # 80008108 <etext+0x108>
    80000a88:	00005097          	auipc	ra,0x5
    80000a8c:	3a0080e7          	jalr	928(ra) # 80005e28 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	390080e7          	jalr	912(ra) # 80005e28 <panic>
      kfree(mem);
    80000aa0:	854a                	mv	a0,s2
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	57a080e7          	jalr	1402(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aaa:	4685                	li	a3,1
    80000aac:	00c9d613          	srli	a2,s3,0xc
    80000ab0:	4581                	li	a1,0
    80000ab2:	8556                	mv	a0,s5
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	c5a080e7          	jalr	-934(ra) # 8000070e <uvmunmap>
  return -1;
    80000abc:	557d                	li	a0,-1
}
    80000abe:	60a6                	ld	ra,72(sp)
    80000ac0:	6406                	ld	s0,64(sp)
    80000ac2:	74e2                	ld	s1,56(sp)
    80000ac4:	7942                	ld	s2,48(sp)
    80000ac6:	79a2                	ld	s3,40(sp)
    80000ac8:	7a02                	ld	s4,32(sp)
    80000aca:	6ae2                	ld	s5,24(sp)
    80000acc:	6b42                	ld	s6,16(sp)
    80000ace:	6ba2                	ld	s7,8(sp)
    80000ad0:	6161                	addi	sp,sp,80
    80000ad2:	8082                	ret
  return 0;
    80000ad4:	4501                	li	a0,0
}
    80000ad6:	8082                	ret

0000000080000ad8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad8:	1141                	addi	sp,sp,-16
    80000ada:	e406                	sd	ra,8(sp)
    80000adc:	e022                	sd	s0,0(sp)
    80000ade:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae0:	4601                	li	a2,0
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	97e080e7          	jalr	-1666(ra) # 80000460 <walk>
  if(pte == 0)
    80000aea:	c901                	beqz	a0,80000afa <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aec:	611c                	ld	a5,0(a0)
    80000aee:	9bbd                	andi	a5,a5,-17
    80000af0:	e11c                	sd	a5,0(a0)
}
    80000af2:	60a2                	ld	ra,8(sp)
    80000af4:	6402                	ld	s0,0(sp)
    80000af6:	0141                	addi	sp,sp,16
    80000af8:	8082                	ret
    panic("uvmclear");
    80000afa:	00007517          	auipc	a0,0x7
    80000afe:	64e50513          	addi	a0,a0,1614 # 80008148 <etext+0x148>
    80000b02:	00005097          	auipc	ra,0x5
    80000b06:	326080e7          	jalr	806(ra) # 80005e28 <panic>

0000000080000b0a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b0a:	c6bd                	beqz	a3,80000b78 <copyout+0x6e>
{
    80000b0c:	715d                	addi	sp,sp,-80
    80000b0e:	e486                	sd	ra,72(sp)
    80000b10:	e0a2                	sd	s0,64(sp)
    80000b12:	fc26                	sd	s1,56(sp)
    80000b14:	f84a                	sd	s2,48(sp)
    80000b16:	f44e                	sd	s3,40(sp)
    80000b18:	f052                	sd	s4,32(sp)
    80000b1a:	ec56                	sd	s5,24(sp)
    80000b1c:	e85a                	sd	s6,16(sp)
    80000b1e:	e45e                	sd	s7,8(sp)
    80000b20:	e062                	sd	s8,0(sp)
    80000b22:	0880                	addi	s0,sp,80
    80000b24:	8b2a                	mv	s6,a0
    80000b26:	8c2e                	mv	s8,a1
    80000b28:	8a32                	mv	s4,a2
    80000b2a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2e:	6a85                	lui	s5,0x1
    80000b30:	a015                	j	80000b54 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b32:	9562                	add	a0,a0,s8
    80000b34:	0004861b          	sext.w	a2,s1
    80000b38:	85d2                	mv	a1,s4
    80000b3a:	41250533          	sub	a0,a0,s2
    80000b3e:	fffff097          	auipc	ra,0xfffff
    80000b42:	69a080e7          	jalr	1690(ra) # 800001d8 <memmove>

    len -= n;
    80000b46:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b4a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b50:	02098263          	beqz	s3,80000b74 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b54:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b58:	85ca                	mv	a1,s2
    80000b5a:	855a                	mv	a0,s6
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	9aa080e7          	jalr	-1622(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b64:	cd01                	beqz	a0,80000b7c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b66:	418904b3          	sub	s1,s2,s8
    80000b6a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b6c:	fc99f3e3          	bgeu	s3,s1,80000b32 <copyout+0x28>
    80000b70:	84ce                	mv	s1,s3
    80000b72:	b7c1                	j	80000b32 <copyout+0x28>
  }
  return 0;
    80000b74:	4501                	li	a0,0
    80000b76:	a021                	j	80000b7e <copyout+0x74>
    80000b78:	4501                	li	a0,0
}
    80000b7a:	8082                	ret
      return -1;
    80000b7c:	557d                	li	a0,-1
}
    80000b7e:	60a6                	ld	ra,72(sp)
    80000b80:	6406                	ld	s0,64(sp)
    80000b82:	74e2                	ld	s1,56(sp)
    80000b84:	7942                	ld	s2,48(sp)
    80000b86:	79a2                	ld	s3,40(sp)
    80000b88:	7a02                	ld	s4,32(sp)
    80000b8a:	6ae2                	ld	s5,24(sp)
    80000b8c:	6b42                	ld	s6,16(sp)
    80000b8e:	6ba2                	ld	s7,8(sp)
    80000b90:	6c02                	ld	s8,0(sp)
    80000b92:	6161                	addi	sp,sp,80
    80000b94:	8082                	ret

0000000080000b96 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b96:	c6bd                	beqz	a3,80000c04 <copyin+0x6e>
{
    80000b98:	715d                	addi	sp,sp,-80
    80000b9a:	e486                	sd	ra,72(sp)
    80000b9c:	e0a2                	sd	s0,64(sp)
    80000b9e:	fc26                	sd	s1,56(sp)
    80000ba0:	f84a                	sd	s2,48(sp)
    80000ba2:	f44e                	sd	s3,40(sp)
    80000ba4:	f052                	sd	s4,32(sp)
    80000ba6:	ec56                	sd	s5,24(sp)
    80000ba8:	e85a                	sd	s6,16(sp)
    80000baa:	e45e                	sd	s7,8(sp)
    80000bac:	e062                	sd	s8,0(sp)
    80000bae:	0880                	addi	s0,sp,80
    80000bb0:	8b2a                	mv	s6,a0
    80000bb2:	8a2e                	mv	s4,a1
    80000bb4:	8c32                	mv	s8,a2
    80000bb6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bba:	6a85                	lui	s5,0x1
    80000bbc:	a015                	j	80000be0 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbe:	9562                	add	a0,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412505b3          	sub	a1,a0,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60e080e7          	jalr	1550(ra) # 800001d8 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	91e080e7          	jalr	-1762(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf8:	fc99f3e3          	bgeu	s3,s1,80000bbe <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	b7c1                	j	80000bbe <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x74>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c6c5                	beqz	a3,80000cca <copyinstr+0xa8>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a035                	j	80000c72 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	0017b793          	seqz	a5,a5
    80000c52:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c56:	60a6                	ld	ra,72(sp)
    80000c58:	6406                	ld	s0,64(sp)
    80000c5a:	74e2                	ld	s1,56(sp)
    80000c5c:	7942                	ld	s2,48(sp)
    80000c5e:	79a2                	ld	s3,40(sp)
    80000c60:	7a02                	ld	s4,32(sp)
    80000c62:	6ae2                	ld	s5,24(sp)
    80000c64:	6b42                	ld	s6,16(sp)
    80000c66:	6ba2                	ld	s7,8(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c70:	c8a9                	beqz	s1,80000cc2 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c72:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c76:	85ca                	mv	a1,s2
    80000c78:	8552                	mv	a0,s4
    80000c7a:	00000097          	auipc	ra,0x0
    80000c7e:	88c080e7          	jalr	-1908(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c82:	c131                	beqz	a0,80000cc6 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c84:	41790833          	sub	a6,s2,s7
    80000c88:	984e                	add	a6,a6,s3
    if(n > max)
    80000c8a:	0104f363          	bgeu	s1,a6,80000c90 <copyinstr+0x6e>
    80000c8e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c90:	955e                	add	a0,a0,s7
    80000c92:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c96:	fc080be3          	beqz	a6,80000c6c <copyinstr+0x4a>
    80000c9a:	985a                	add	a6,a6,s6
    80000c9c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c9e:	41650633          	sub	a2,a0,s6
    80000ca2:	14fd                	addi	s1,s1,-1
    80000ca4:	9b26                	add	s6,s6,s1
    80000ca6:	00f60733          	add	a4,a2,a5
    80000caa:	00074703          	lbu	a4,0(a4)
    80000cae:	df49                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cb0:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cb8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cba:	ff0796e3          	bne	a5,a6,80000ca6 <copyinstr+0x84>
      dst++;
    80000cbe:	8b42                	mv	s6,a6
    80000cc0:	b775                	j	80000c6c <copyinstr+0x4a>
    80000cc2:	4781                	li	a5,0
    80000cc4:	b769                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc6:	557d                	li	a0,-1
    80000cc8:	b779                	j	80000c56 <copyinstr+0x34>
  int got_null = 0;
    80000cca:	4781                	li	a5,0
  if(got_null){
    80000ccc:	0017b793          	seqz	a5,a5
    80000cd0:	40f00533          	neg	a0,a5
}
    80000cd4:	8082                	ret

0000000080000cd6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd6:	7139                	addi	sp,sp,-64
    80000cd8:	fc06                	sd	ra,56(sp)
    80000cda:	f822                	sd	s0,48(sp)
    80000cdc:	f426                	sd	s1,40(sp)
    80000cde:	f04a                	sd	s2,32(sp)
    80000ce0:	ec4e                	sd	s3,24(sp)
    80000ce2:	e852                	sd	s4,16(sp)
    80000ce4:	e456                	sd	s5,8(sp)
    80000ce6:	e05a                	sd	s6,0(sp)
    80000ce8:	0080                	addi	s0,sp,64
    80000cea:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cec:	00008497          	auipc	s1,0x8
    80000cf0:	79448493          	addi	s1,s1,1940 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf4:	8b26                	mv	s6,s1
    80000cf6:	00007a97          	auipc	s5,0x7
    80000cfa:	30aa8a93          	addi	s5,s5,778 # 80008000 <etext>
    80000cfe:	04000937          	lui	s2,0x4000
    80000d02:	197d                	addi	s2,s2,-1
    80000d04:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d06:	0000ea17          	auipc	s4,0xe
    80000d0a:	77aa0a13          	addi	s4,s4,1914 # 8000f480 <tickslock>
    char *pa = kalloc();
    80000d0e:	fffff097          	auipc	ra,0xfffff
    80000d12:	40a080e7          	jalr	1034(ra) # 80000118 <kalloc>
    80000d16:	862a                	mv	a2,a0
    if(pa == 0)
    80000d18:	c131                	beqz	a0,80000d5c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d1a:	416485b3          	sub	a1,s1,s6
    80000d1e:	859d                	srai	a1,a1,0x7
    80000d20:	000ab783          	ld	a5,0(s5)
    80000d24:	02f585b3          	mul	a1,a1,a5
    80000d28:	2585                	addiw	a1,a1,1
    80000d2a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2e:	4719                	li	a4,6
    80000d30:	6685                	lui	a3,0x1
    80000d32:	40b905b3          	sub	a1,s2,a1
    80000d36:	854e                	mv	a0,s3
    80000d38:	00000097          	auipc	ra,0x0
    80000d3c:	8b0080e7          	jalr	-1872(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d40:	18048493          	addi	s1,s1,384
    80000d44:	fd4495e3          	bne	s1,s4,80000d0e <proc_mapstacks+0x38>
  }
}
    80000d48:	70e2                	ld	ra,56(sp)
    80000d4a:	7442                	ld	s0,48(sp)
    80000d4c:	74a2                	ld	s1,40(sp)
    80000d4e:	7902                	ld	s2,32(sp)
    80000d50:	69e2                	ld	s3,24(sp)
    80000d52:	6a42                	ld	s4,16(sp)
    80000d54:	6aa2                	ld	s5,8(sp)
    80000d56:	6b02                	ld	s6,0(sp)
    80000d58:	6121                	addi	sp,sp,64
    80000d5a:	8082                	ret
      panic("kalloc");
    80000d5c:	00007517          	auipc	a0,0x7
    80000d60:	3fc50513          	addi	a0,a0,1020 # 80008158 <etext+0x158>
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	0c4080e7          	jalr	196(ra) # 80005e28 <panic>

0000000080000d6c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d6c:	7139                	addi	sp,sp,-64
    80000d6e:	fc06                	sd	ra,56(sp)
    80000d70:	f822                	sd	s0,48(sp)
    80000d72:	f426                	sd	s1,40(sp)
    80000d74:	f04a                	sd	s2,32(sp)
    80000d76:	ec4e                	sd	s3,24(sp)
    80000d78:	e852                	sd	s4,16(sp)
    80000d7a:	e456                	sd	s5,8(sp)
    80000d7c:	e05a                	sd	s6,0(sp)
    80000d7e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d80:	00007597          	auipc	a1,0x7
    80000d84:	3e058593          	addi	a1,a1,992 # 80008160 <etext+0x160>
    80000d88:	00008517          	auipc	a0,0x8
    80000d8c:	2c850513          	addi	a0,a0,712 # 80009050 <pid_lock>
    80000d90:	00005097          	auipc	ra,0x5
    80000d94:	5ae080e7          	jalr	1454(ra) # 8000633e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d98:	00007597          	auipc	a1,0x7
    80000d9c:	3d058593          	addi	a1,a1,976 # 80008168 <etext+0x168>
    80000da0:	00008517          	auipc	a0,0x8
    80000da4:	2c850513          	addi	a0,a0,712 # 80009068 <wait_lock>
    80000da8:	00005097          	auipc	ra,0x5
    80000dac:	596080e7          	jalr	1430(ra) # 8000633e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db0:	00008497          	auipc	s1,0x8
    80000db4:	6d048493          	addi	s1,s1,1744 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db8:	00007b17          	auipc	s6,0x7
    80000dbc:	3c0b0b13          	addi	s6,s6,960 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dc0:	8aa6                	mv	s5,s1
    80000dc2:	00007a17          	auipc	s4,0x7
    80000dc6:	23ea0a13          	addi	s4,s4,574 # 80008000 <etext>
    80000dca:	04000937          	lui	s2,0x4000
    80000dce:	197d                	addi	s2,s2,-1
    80000dd0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd2:	0000e997          	auipc	s3,0xe
    80000dd6:	6ae98993          	addi	s3,s3,1710 # 8000f480 <tickslock>
      initlock(&p->lock, "proc");
    80000dda:	85da                	mv	a1,s6
    80000ddc:	8526                	mv	a0,s1
    80000dde:	00005097          	auipc	ra,0x5
    80000de2:	560080e7          	jalr	1376(ra) # 8000633e <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	415487b3          	sub	a5,s1,s5
    80000dea:	879d                	srai	a5,a5,0x7
    80000dec:	000a3703          	ld	a4,0(s4)
    80000df0:	02e787b3          	mul	a5,a5,a4
    80000df4:	2785                	addiw	a5,a5,1
    80000df6:	00d7979b          	slliw	a5,a5,0xd
    80000dfa:	40f907b3          	sub	a5,s2,a5
    80000dfe:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	18048493          	addi	s1,s1,384
    80000e04:	fd349be3          	bne	s1,s3,80000dda <procinit+0x6e>
  }
}
    80000e08:	70e2                	ld	ra,56(sp)
    80000e0a:	7442                	ld	s0,48(sp)
    80000e0c:	74a2                	ld	s1,40(sp)
    80000e0e:	7902                	ld	s2,32(sp)
    80000e10:	69e2                	ld	s3,24(sp)
    80000e12:	6a42                	ld	s4,16(sp)
    80000e14:	6aa2                	ld	s5,8(sp)
    80000e16:	6b02                	ld	s6,0(sp)
    80000e18:	6121                	addi	sp,sp,64
    80000e1a:	8082                	ret

0000000080000e1c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e22:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e24:	2501                	sext.w	a0,a0
    80000e26:	6422                	ld	s0,8(sp)
    80000e28:	0141                	addi	sp,sp,16
    80000e2a:	8082                	ret

0000000080000e2c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e422                	sd	s0,8(sp)
    80000e30:	0800                	addi	s0,sp,16
    80000e32:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e34:	2781                	sext.w	a5,a5
    80000e36:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e38:	00008517          	auipc	a0,0x8
    80000e3c:	24850513          	addi	a0,a0,584 # 80009080 <cpus>
    80000e40:	953e                	add	a0,a0,a5
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	addi	sp,sp,16
    80000e46:	8082                	ret

0000000080000e48 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e48:	1101                	addi	sp,sp,-32
    80000e4a:	ec06                	sd	ra,24(sp)
    80000e4c:	e822                	sd	s0,16(sp)
    80000e4e:	e426                	sd	s1,8(sp)
    80000e50:	1000                	addi	s0,sp,32
  push_off();
    80000e52:	00005097          	auipc	ra,0x5
    80000e56:	530080e7          	jalr	1328(ra) # 80006382 <push_off>
    80000e5a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e5c:	2781                	sext.w	a5,a5
    80000e5e:	079e                	slli	a5,a5,0x7
    80000e60:	00008717          	auipc	a4,0x8
    80000e64:	1f070713          	addi	a4,a4,496 # 80009050 <pid_lock>
    80000e68:	97ba                	add	a5,a5,a4
    80000e6a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e6c:	00005097          	auipc	ra,0x5
    80000e70:	5b6080e7          	jalr	1462(ra) # 80006422 <pop_off>
  return p;
}
    80000e74:	8526                	mv	a0,s1
    80000e76:	60e2                	ld	ra,24(sp)
    80000e78:	6442                	ld	s0,16(sp)
    80000e7a:	64a2                	ld	s1,8(sp)
    80000e7c:	6105                	addi	sp,sp,32
    80000e7e:	8082                	ret

0000000080000e80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e80:	1141                	addi	sp,sp,-16
    80000e82:	e406                	sd	ra,8(sp)
    80000e84:	e022                	sd	s0,0(sp)
    80000e86:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e88:	00000097          	auipc	ra,0x0
    80000e8c:	fc0080e7          	jalr	-64(ra) # 80000e48 <myproc>
    80000e90:	00005097          	auipc	ra,0x5
    80000e94:	5f2080e7          	jalr	1522(ra) # 80006482 <release>

  if (first) {
    80000e98:	00008797          	auipc	a5,0x8
    80000e9c:	9b87a783          	lw	a5,-1608(a5) # 80008850 <first.1717>
    80000ea0:	eb89                	bnez	a5,80000eb2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ea2:	00001097          	auipc	ra,0x1
    80000ea6:	c18080e7          	jalr	-1000(ra) # 80001aba <usertrapret>
}
    80000eaa:	60a2                	ld	ra,8(sp)
    80000eac:	6402                	ld	s0,0(sp)
    80000eae:	0141                	addi	sp,sp,16
    80000eb0:	8082                	ret
    first = 0;
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	9807af23          	sw	zero,-1634(a5) # 80008850 <first.1717>
    fsinit(ROOTDEV);
    80000eba:	4505                	li	a0,1
    80000ebc:	00002097          	auipc	ra,0x2
    80000ec0:	c3c080e7          	jalr	-964(ra) # 80002af8 <fsinit>
    80000ec4:	bff9                	j	80000ea2 <forkret+0x22>

0000000080000ec6 <allocpid>:
allocpid() {
    80000ec6:	1101                	addi	sp,sp,-32
    80000ec8:	ec06                	sd	ra,24(sp)
    80000eca:	e822                	sd	s0,16(sp)
    80000ecc:	e426                	sd	s1,8(sp)
    80000ece:	e04a                	sd	s2,0(sp)
    80000ed0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ed2:	00008917          	auipc	s2,0x8
    80000ed6:	17e90913          	addi	s2,s2,382 # 80009050 <pid_lock>
    80000eda:	854a                	mv	a0,s2
    80000edc:	00005097          	auipc	ra,0x5
    80000ee0:	4f2080e7          	jalr	1266(ra) # 800063ce <acquire>
  pid = nextpid;
    80000ee4:	00008797          	auipc	a5,0x8
    80000ee8:	97078793          	addi	a5,a5,-1680 # 80008854 <nextpid>
    80000eec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eee:	0014871b          	addiw	a4,s1,1
    80000ef2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	58c080e7          	jalr	1420(ra) # 80006482 <release>
}
    80000efe:	8526                	mv	a0,s1
    80000f00:	60e2                	ld	ra,24(sp)
    80000f02:	6442                	ld	s0,16(sp)
    80000f04:	64a2                	ld	s1,8(sp)
    80000f06:	6902                	ld	s2,0(sp)
    80000f08:	6105                	addi	sp,sp,32
    80000f0a:	8082                	ret

0000000080000f0c <proc_pagetable>:
{
    80000f0c:	1101                	addi	sp,sp,-32
    80000f0e:	ec06                	sd	ra,24(sp)
    80000f10:	e822                	sd	s0,16(sp)
    80000f12:	e426                	sd	s1,8(sp)
    80000f14:	e04a                	sd	s2,0(sp)
    80000f16:	1000                	addi	s0,sp,32
    80000f18:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f1a:	00000097          	auipc	ra,0x0
    80000f1e:	8b8080e7          	jalr	-1864(ra) # 800007d2 <uvmcreate>
    80000f22:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f24:	c121                	beqz	a0,80000f64 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f26:	4729                	li	a4,10
    80000f28:	00006697          	auipc	a3,0x6
    80000f2c:	0d868693          	addi	a3,a3,216 # 80007000 <_trampoline>
    80000f30:	6605                	lui	a2,0x1
    80000f32:	040005b7          	lui	a1,0x4000
    80000f36:	15fd                	addi	a1,a1,-1
    80000f38:	05b2                	slli	a1,a1,0xc
    80000f3a:	fffff097          	auipc	ra,0xfffff
    80000f3e:	60e080e7          	jalr	1550(ra) # 80000548 <mappages>
    80000f42:	02054863          	bltz	a0,80000f72 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f46:	4719                	li	a4,6
    80000f48:	07093683          	ld	a3,112(s2)
    80000f4c:	6605                	lui	a2,0x1
    80000f4e:	020005b7          	lui	a1,0x2000
    80000f52:	15fd                	addi	a1,a1,-1
    80000f54:	05b6                	slli	a1,a1,0xd
    80000f56:	8526                	mv	a0,s1
    80000f58:	fffff097          	auipc	ra,0xfffff
    80000f5c:	5f0080e7          	jalr	1520(ra) # 80000548 <mappages>
    80000f60:	02054163          	bltz	a0,80000f82 <proc_pagetable+0x76>
}
    80000f64:	8526                	mv	a0,s1
    80000f66:	60e2                	ld	ra,24(sp)
    80000f68:	6442                	ld	s0,16(sp)
    80000f6a:	64a2                	ld	s1,8(sp)
    80000f6c:	6902                	ld	s2,0(sp)
    80000f6e:	6105                	addi	sp,sp,32
    80000f70:	8082                	ret
    uvmfree(pagetable, 0);
    80000f72:	4581                	li	a1,0
    80000f74:	8526                	mv	a0,s1
    80000f76:	00000097          	auipc	ra,0x0
    80000f7a:	a58080e7          	jalr	-1448(ra) # 800009ce <uvmfree>
    return 0;
    80000f7e:	4481                	li	s1,0
    80000f80:	b7d5                	j	80000f64 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f82:	4681                	li	a3,0
    80000f84:	4605                	li	a2,1
    80000f86:	040005b7          	lui	a1,0x4000
    80000f8a:	15fd                	addi	a1,a1,-1
    80000f8c:	05b2                	slli	a1,a1,0xc
    80000f8e:	8526                	mv	a0,s1
    80000f90:	fffff097          	auipc	ra,0xfffff
    80000f94:	77e080e7          	jalr	1918(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000f98:	4581                	li	a1,0
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	00000097          	auipc	ra,0x0
    80000fa0:	a32080e7          	jalr	-1486(ra) # 800009ce <uvmfree>
    return 0;
    80000fa4:	4481                	li	s1,0
    80000fa6:	bf7d                	j	80000f64 <proc_pagetable+0x58>

0000000080000fa8 <proc_freepagetable>:
{
    80000fa8:	1101                	addi	sp,sp,-32
    80000faa:	ec06                	sd	ra,24(sp)
    80000fac:	e822                	sd	s0,16(sp)
    80000fae:	e426                	sd	s1,8(sp)
    80000fb0:	e04a                	sd	s2,0(sp)
    80000fb2:	1000                	addi	s0,sp,32
    80000fb4:	84aa                	mv	s1,a0
    80000fb6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb8:	4681                	li	a3,0
    80000fba:	4605                	li	a2,1
    80000fbc:	040005b7          	lui	a1,0x4000
    80000fc0:	15fd                	addi	a1,a1,-1
    80000fc2:	05b2                	slli	a1,a1,0xc
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	74a080e7          	jalr	1866(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	020005b7          	lui	a1,0x2000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b6                	slli	a1,a1,0xd
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	734080e7          	jalr	1844(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80000fe2:	85ca                	mv	a1,s2
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	9e8080e7          	jalr	-1560(ra) # 800009ce <uvmfree>
}
    80000fee:	60e2                	ld	ra,24(sp)
    80000ff0:	6442                	ld	s0,16(sp)
    80000ff2:	64a2                	ld	s1,8(sp)
    80000ff4:	6902                	ld	s2,0(sp)
    80000ff6:	6105                	addi	sp,sp,32
    80000ff8:	8082                	ret

0000000080000ffa <freeproc>:
{
    80000ffa:	1101                	addi	sp,sp,-32
    80000ffc:	ec06                	sd	ra,24(sp)
    80000ffe:	e822                	sd	s0,16(sp)
    80001000:	e426                	sd	s1,8(sp)
    80001002:	1000                	addi	s0,sp,32
    80001004:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001006:	7928                	ld	a0,112(a0)
    80001008:	c509                	beqz	a0,80001012 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	012080e7          	jalr	18(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001012:	0604b823          	sd	zero,112(s1)
  if(p->pagetable)
    80001016:	68a8                	ld	a0,80(s1)
    80001018:	c511                	beqz	a0,80001024 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000101a:	64ac                	ld	a1,72(s1)
    8000101c:	00000097          	auipc	ra,0x0
    80001020:	f8c080e7          	jalr	-116(ra) # 80000fa8 <proc_freepagetable>
  p->pagetable = 0;
    80001024:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001028:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000102c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001030:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001034:	16048823          	sb	zero,368(s1)
  p->chan = 0;
    80001038:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000103c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001040:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001044:	0004ac23          	sw	zero,24(s1)
}
    80001048:	60e2                	ld	ra,24(sp)
    8000104a:	6442                	ld	s0,16(sp)
    8000104c:	64a2                	ld	s1,8(sp)
    8000104e:	6105                	addi	sp,sp,32
    80001050:	8082                	ret

0000000080001052 <allocproc>:
{
    80001052:	1101                	addi	sp,sp,-32
    80001054:	ec06                	sd	ra,24(sp)
    80001056:	e822                	sd	s0,16(sp)
    80001058:	e426                	sd	s1,8(sp)
    8000105a:	e04a                	sd	s2,0(sp)
    8000105c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105e:	00008497          	auipc	s1,0x8
    80001062:	42248493          	addi	s1,s1,1058 # 80009480 <proc>
    80001066:	0000e917          	auipc	s2,0xe
    8000106a:	41a90913          	addi	s2,s2,1050 # 8000f480 <tickslock>
    acquire(&p->lock);
    8000106e:	8526                	mv	a0,s1
    80001070:	00005097          	auipc	ra,0x5
    80001074:	35e080e7          	jalr	862(ra) # 800063ce <acquire>
    if(p->state == UNUSED) {
    80001078:	4c9c                	lw	a5,24(s1)
    8000107a:	cf81                	beqz	a5,80001092 <allocproc+0x40>
      release(&p->lock);
    8000107c:	8526                	mv	a0,s1
    8000107e:	00005097          	auipc	ra,0x5
    80001082:	404080e7          	jalr	1028(ra) # 80006482 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001086:	18048493          	addi	s1,s1,384
    8000108a:	ff2492e3          	bne	s1,s2,8000106e <allocproc+0x1c>
  return 0;
    8000108e:	4481                	li	s1,0
    80001090:	a085                	j	800010f0 <allocproc+0x9e>
  p->pid = allocpid();
    80001092:	00000097          	auipc	ra,0x0
    80001096:	e34080e7          	jalr	-460(ra) # 80000ec6 <allocpid>
    8000109a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000109c:	4785                	li	a5,1
    8000109e:	cc9c                	sw	a5,24(s1)
  p->ticks = 0;
    800010a0:	0404ac23          	sw	zero,88(s1)
  p->currticks = 0;
    800010a4:	0404ae23          	sw	zero,92(s1)
  p->handler = 0;
    800010a8:	0604b023          	sd	zero,96(s1)
  p->handlerlock = 1;
    800010ac:	d4bc                	sw	a5,104(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010ae:	fffff097          	auipc	ra,0xfffff
    800010b2:	06a080e7          	jalr	106(ra) # 80000118 <kalloc>
    800010b6:	892a                	mv	s2,a0
    800010b8:	f8a8                	sd	a0,112(s1)
    800010ba:	c131                	beqz	a0,800010fe <allocproc+0xac>
  p->pagetable = proc_pagetable(p);
    800010bc:	8526                	mv	a0,s1
    800010be:	00000097          	auipc	ra,0x0
    800010c2:	e4e080e7          	jalr	-434(ra) # 80000f0c <proc_pagetable>
    800010c6:	892a                	mv	s2,a0
    800010c8:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010ca:	c531                	beqz	a0,80001116 <allocproc+0xc4>
  memset(&p->context, 0, sizeof(p->context));
    800010cc:	07000613          	li	a2,112
    800010d0:	4581                	li	a1,0
    800010d2:	07848513          	addi	a0,s1,120
    800010d6:	fffff097          	auipc	ra,0xfffff
    800010da:	0a2080e7          	jalr	162(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010de:	00000797          	auipc	a5,0x0
    800010e2:	da278793          	addi	a5,a5,-606 # 80000e80 <forkret>
    800010e6:	fcbc                	sd	a5,120(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010e8:	60bc                	ld	a5,64(s1)
    800010ea:	6705                	lui	a4,0x1
    800010ec:	97ba                	add	a5,a5,a4
    800010ee:	e0dc                	sd	a5,128(s1)
}
    800010f0:	8526                	mv	a0,s1
    800010f2:	60e2                	ld	ra,24(sp)
    800010f4:	6442                	ld	s0,16(sp)
    800010f6:	64a2                	ld	s1,8(sp)
    800010f8:	6902                	ld	s2,0(sp)
    800010fa:	6105                	addi	sp,sp,32
    800010fc:	8082                	ret
    freeproc(p);
    800010fe:	8526                	mv	a0,s1
    80001100:	00000097          	auipc	ra,0x0
    80001104:	efa080e7          	jalr	-262(ra) # 80000ffa <freeproc>
    release(&p->lock);
    80001108:	8526                	mv	a0,s1
    8000110a:	00005097          	auipc	ra,0x5
    8000110e:	378080e7          	jalr	888(ra) # 80006482 <release>
    return 0;
    80001112:	84ca                	mv	s1,s2
    80001114:	bff1                	j	800010f0 <allocproc+0x9e>
    freeproc(p);
    80001116:	8526                	mv	a0,s1
    80001118:	00000097          	auipc	ra,0x0
    8000111c:	ee2080e7          	jalr	-286(ra) # 80000ffa <freeproc>
    release(&p->lock);
    80001120:	8526                	mv	a0,s1
    80001122:	00005097          	auipc	ra,0x5
    80001126:	360080e7          	jalr	864(ra) # 80006482 <release>
    return 0;
    8000112a:	84ca                	mv	s1,s2
    8000112c:	b7d1                	j	800010f0 <allocproc+0x9e>

000000008000112e <userinit>:
{
    8000112e:	1101                	addi	sp,sp,-32
    80001130:	ec06                	sd	ra,24(sp)
    80001132:	e822                	sd	s0,16(sp)
    80001134:	e426                	sd	s1,8(sp)
    80001136:	1000                	addi	s0,sp,32
  p = allocproc();
    80001138:	00000097          	auipc	ra,0x0
    8000113c:	f1a080e7          	jalr	-230(ra) # 80001052 <allocproc>
    80001140:	84aa                	mv	s1,a0
  initproc = p;
    80001142:	00008797          	auipc	a5,0x8
    80001146:	eca7b723          	sd	a0,-306(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000114a:	03400613          	li	a2,52
    8000114e:	00007597          	auipc	a1,0x7
    80001152:	71258593          	addi	a1,a1,1810 # 80008860 <initcode>
    80001156:	6928                	ld	a0,80(a0)
    80001158:	fffff097          	auipc	ra,0xfffff
    8000115c:	6a8080e7          	jalr	1704(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    80001160:	6785                	lui	a5,0x1
    80001162:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001164:	78b8                	ld	a4,112(s1)
    80001166:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000116a:	78b8                	ld	a4,112(s1)
    8000116c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000116e:	4641                	li	a2,16
    80001170:	00007597          	auipc	a1,0x7
    80001174:	01058593          	addi	a1,a1,16 # 80008180 <etext+0x180>
    80001178:	17048513          	addi	a0,s1,368
    8000117c:	fffff097          	auipc	ra,0xfffff
    80001180:	14e080e7          	jalr	334(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001184:	00007517          	auipc	a0,0x7
    80001188:	00c50513          	addi	a0,a0,12 # 80008190 <etext+0x190>
    8000118c:	00002097          	auipc	ra,0x2
    80001190:	39a080e7          	jalr	922(ra) # 80003526 <namei>
    80001194:	16a4b423          	sd	a0,360(s1)
  p->state = RUNNABLE;
    80001198:	478d                	li	a5,3
    8000119a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000119c:	8526                	mv	a0,s1
    8000119e:	00005097          	auipc	ra,0x5
    800011a2:	2e4080e7          	jalr	740(ra) # 80006482 <release>
}
    800011a6:	60e2                	ld	ra,24(sp)
    800011a8:	6442                	ld	s0,16(sp)
    800011aa:	64a2                	ld	s1,8(sp)
    800011ac:	6105                	addi	sp,sp,32
    800011ae:	8082                	ret

00000000800011b0 <growproc>:
{
    800011b0:	1101                	addi	sp,sp,-32
    800011b2:	ec06                	sd	ra,24(sp)
    800011b4:	e822                	sd	s0,16(sp)
    800011b6:	e426                	sd	s1,8(sp)
    800011b8:	e04a                	sd	s2,0(sp)
    800011ba:	1000                	addi	s0,sp,32
    800011bc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011be:	00000097          	auipc	ra,0x0
    800011c2:	c8a080e7          	jalr	-886(ra) # 80000e48 <myproc>
    800011c6:	892a                	mv	s2,a0
  sz = p->sz;
    800011c8:	652c                	ld	a1,72(a0)
    800011ca:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011ce:	00904f63          	bgtz	s1,800011ec <growproc+0x3c>
  } else if(n < 0){
    800011d2:	0204cc63          	bltz	s1,8000120a <growproc+0x5a>
  p->sz = sz;
    800011d6:	1602                	slli	a2,a2,0x20
    800011d8:	9201                	srli	a2,a2,0x20
    800011da:	04c93423          	sd	a2,72(s2)
  return 0;
    800011de:	4501                	li	a0,0
}
    800011e0:	60e2                	ld	ra,24(sp)
    800011e2:	6442                	ld	s0,16(sp)
    800011e4:	64a2                	ld	s1,8(sp)
    800011e6:	6902                	ld	s2,0(sp)
    800011e8:	6105                	addi	sp,sp,32
    800011ea:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011ec:	9e25                	addw	a2,a2,s1
    800011ee:	1602                	slli	a2,a2,0x20
    800011f0:	9201                	srli	a2,a2,0x20
    800011f2:	1582                	slli	a1,a1,0x20
    800011f4:	9181                	srli	a1,a1,0x20
    800011f6:	6928                	ld	a0,80(a0)
    800011f8:	fffff097          	auipc	ra,0xfffff
    800011fc:	6c2080e7          	jalr	1730(ra) # 800008ba <uvmalloc>
    80001200:	0005061b          	sext.w	a2,a0
    80001204:	fa69                	bnez	a2,800011d6 <growproc+0x26>
      return -1;
    80001206:	557d                	li	a0,-1
    80001208:	bfe1                	j	800011e0 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000120a:	9e25                	addw	a2,a2,s1
    8000120c:	1602                	slli	a2,a2,0x20
    8000120e:	9201                	srli	a2,a2,0x20
    80001210:	1582                	slli	a1,a1,0x20
    80001212:	9181                	srli	a1,a1,0x20
    80001214:	6928                	ld	a0,80(a0)
    80001216:	fffff097          	auipc	ra,0xfffff
    8000121a:	65c080e7          	jalr	1628(ra) # 80000872 <uvmdealloc>
    8000121e:	0005061b          	sext.w	a2,a0
    80001222:	bf55                	j	800011d6 <growproc+0x26>

0000000080001224 <fork>:
{
    80001224:	7179                	addi	sp,sp,-48
    80001226:	f406                	sd	ra,40(sp)
    80001228:	f022                	sd	s0,32(sp)
    8000122a:	ec26                	sd	s1,24(sp)
    8000122c:	e84a                	sd	s2,16(sp)
    8000122e:	e44e                	sd	s3,8(sp)
    80001230:	e052                	sd	s4,0(sp)
    80001232:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001234:	00000097          	auipc	ra,0x0
    80001238:	c14080e7          	jalr	-1004(ra) # 80000e48 <myproc>
    8000123c:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000123e:	00000097          	auipc	ra,0x0
    80001242:	e14080e7          	jalr	-492(ra) # 80001052 <allocproc>
    80001246:	10050b63          	beqz	a0,8000135c <fork+0x138>
    8000124a:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000124c:	04893603          	ld	a2,72(s2)
    80001250:	692c                	ld	a1,80(a0)
    80001252:	05093503          	ld	a0,80(s2)
    80001256:	fffff097          	auipc	ra,0xfffff
    8000125a:	7b0080e7          	jalr	1968(ra) # 80000a06 <uvmcopy>
    8000125e:	04054663          	bltz	a0,800012aa <fork+0x86>
  np->sz = p->sz;
    80001262:	04893783          	ld	a5,72(s2)
    80001266:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000126a:	07093683          	ld	a3,112(s2)
    8000126e:	87b6                	mv	a5,a3
    80001270:	0709b703          	ld	a4,112(s3)
    80001274:	24068693          	addi	a3,a3,576
    80001278:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000127c:	6788                	ld	a0,8(a5)
    8000127e:	6b8c                	ld	a1,16(a5)
    80001280:	6f90                	ld	a2,24(a5)
    80001282:	01073023          	sd	a6,0(a4)
    80001286:	e708                	sd	a0,8(a4)
    80001288:	eb0c                	sd	a1,16(a4)
    8000128a:	ef10                	sd	a2,24(a4)
    8000128c:	02078793          	addi	a5,a5,32
    80001290:	02070713          	addi	a4,a4,32
    80001294:	fed792e3          	bne	a5,a3,80001278 <fork+0x54>
  np->trapframe->a0 = 0;
    80001298:	0709b783          	ld	a5,112(s3)
    8000129c:	0607b823          	sd	zero,112(a5)
    800012a0:	0e800493          	li	s1,232
  for(i = 0; i < NOFILE; i++)
    800012a4:	16800a13          	li	s4,360
    800012a8:	a03d                	j	800012d6 <fork+0xb2>
    freeproc(np);
    800012aa:	854e                	mv	a0,s3
    800012ac:	00000097          	auipc	ra,0x0
    800012b0:	d4e080e7          	jalr	-690(ra) # 80000ffa <freeproc>
    release(&np->lock);
    800012b4:	854e                	mv	a0,s3
    800012b6:	00005097          	auipc	ra,0x5
    800012ba:	1cc080e7          	jalr	460(ra) # 80006482 <release>
    return -1;
    800012be:	5a7d                	li	s4,-1
    800012c0:	a069                	j	8000134a <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800012c2:	00003097          	auipc	ra,0x3
    800012c6:	8fa080e7          	jalr	-1798(ra) # 80003bbc <filedup>
    800012ca:	009987b3          	add	a5,s3,s1
    800012ce:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012d0:	04a1                	addi	s1,s1,8
    800012d2:	01448763          	beq	s1,s4,800012e0 <fork+0xbc>
    if(p->ofile[i])
    800012d6:	009907b3          	add	a5,s2,s1
    800012da:	6388                	ld	a0,0(a5)
    800012dc:	f17d                	bnez	a0,800012c2 <fork+0x9e>
    800012de:	bfcd                	j	800012d0 <fork+0xac>
  np->cwd = idup(p->cwd);
    800012e0:	16893503          	ld	a0,360(s2)
    800012e4:	00002097          	auipc	ra,0x2
    800012e8:	a4e080e7          	jalr	-1458(ra) # 80002d32 <idup>
    800012ec:	16a9b423          	sd	a0,360(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012f0:	4641                	li	a2,16
    800012f2:	17090593          	addi	a1,s2,368
    800012f6:	17098513          	addi	a0,s3,368
    800012fa:	fffff097          	auipc	ra,0xfffff
    800012fe:	fd0080e7          	jalr	-48(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001302:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001306:	854e                	mv	a0,s3
    80001308:	00005097          	auipc	ra,0x5
    8000130c:	17a080e7          	jalr	378(ra) # 80006482 <release>
  acquire(&wait_lock);
    80001310:	00008497          	auipc	s1,0x8
    80001314:	d5848493          	addi	s1,s1,-680 # 80009068 <wait_lock>
    80001318:	8526                	mv	a0,s1
    8000131a:	00005097          	auipc	ra,0x5
    8000131e:	0b4080e7          	jalr	180(ra) # 800063ce <acquire>
  np->parent = p;
    80001322:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001326:	8526                	mv	a0,s1
    80001328:	00005097          	auipc	ra,0x5
    8000132c:	15a080e7          	jalr	346(ra) # 80006482 <release>
  acquire(&np->lock);
    80001330:	854e                	mv	a0,s3
    80001332:	00005097          	auipc	ra,0x5
    80001336:	09c080e7          	jalr	156(ra) # 800063ce <acquire>
  np->state = RUNNABLE;
    8000133a:	478d                	li	a5,3
    8000133c:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001340:	854e                	mv	a0,s3
    80001342:	00005097          	auipc	ra,0x5
    80001346:	140080e7          	jalr	320(ra) # 80006482 <release>
}
    8000134a:	8552                	mv	a0,s4
    8000134c:	70a2                	ld	ra,40(sp)
    8000134e:	7402                	ld	s0,32(sp)
    80001350:	64e2                	ld	s1,24(sp)
    80001352:	6942                	ld	s2,16(sp)
    80001354:	69a2                	ld	s3,8(sp)
    80001356:	6a02                	ld	s4,0(sp)
    80001358:	6145                	addi	sp,sp,48
    8000135a:	8082                	ret
    return -1;
    8000135c:	5a7d                	li	s4,-1
    8000135e:	b7f5                	j	8000134a <fork+0x126>

0000000080001360 <scheduler>:
{
    80001360:	7139                	addi	sp,sp,-64
    80001362:	fc06                	sd	ra,56(sp)
    80001364:	f822                	sd	s0,48(sp)
    80001366:	f426                	sd	s1,40(sp)
    80001368:	f04a                	sd	s2,32(sp)
    8000136a:	ec4e                	sd	s3,24(sp)
    8000136c:	e852                	sd	s4,16(sp)
    8000136e:	e456                	sd	s5,8(sp)
    80001370:	e05a                	sd	s6,0(sp)
    80001372:	0080                	addi	s0,sp,64
    80001374:	8792                	mv	a5,tp
  int id = r_tp();
    80001376:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001378:	00779a93          	slli	s5,a5,0x7
    8000137c:	00008717          	auipc	a4,0x8
    80001380:	cd470713          	addi	a4,a4,-812 # 80009050 <pid_lock>
    80001384:	9756                	add	a4,a4,s5
    80001386:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000138a:	00008717          	auipc	a4,0x8
    8000138e:	cfe70713          	addi	a4,a4,-770 # 80009088 <cpus+0x8>
    80001392:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001394:	498d                	li	s3,3
        p->state = RUNNING;
    80001396:	4b11                	li	s6,4
        c->proc = p;
    80001398:	079e                	slli	a5,a5,0x7
    8000139a:	00008a17          	auipc	s4,0x8
    8000139e:	cb6a0a13          	addi	s4,s4,-842 # 80009050 <pid_lock>
    800013a2:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013a4:	0000e917          	auipc	s2,0xe
    800013a8:	0dc90913          	addi	s2,s2,220 # 8000f480 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013ac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013b0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013b4:	10079073          	csrw	sstatus,a5
    800013b8:	00008497          	auipc	s1,0x8
    800013bc:	0c848493          	addi	s1,s1,200 # 80009480 <proc>
    800013c0:	a03d                	j	800013ee <scheduler+0x8e>
        p->state = RUNNING;
    800013c2:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013c6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013ca:	07848593          	addi	a1,s1,120
    800013ce:	8556                	mv	a0,s5
    800013d0:	00000097          	auipc	ra,0x0
    800013d4:	640080e7          	jalr	1600(ra) # 80001a10 <swtch>
        c->proc = 0;
    800013d8:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013dc:	8526                	mv	a0,s1
    800013de:	00005097          	auipc	ra,0x5
    800013e2:	0a4080e7          	jalr	164(ra) # 80006482 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e6:	18048493          	addi	s1,s1,384
    800013ea:	fd2481e3          	beq	s1,s2,800013ac <scheduler+0x4c>
      acquire(&p->lock);
    800013ee:	8526                	mv	a0,s1
    800013f0:	00005097          	auipc	ra,0x5
    800013f4:	fde080e7          	jalr	-34(ra) # 800063ce <acquire>
      if(p->state == RUNNABLE) {
    800013f8:	4c9c                	lw	a5,24(s1)
    800013fa:	ff3791e3          	bne	a5,s3,800013dc <scheduler+0x7c>
    800013fe:	b7d1                	j	800013c2 <scheduler+0x62>

0000000080001400 <sched>:
{
    80001400:	7179                	addi	sp,sp,-48
    80001402:	f406                	sd	ra,40(sp)
    80001404:	f022                	sd	s0,32(sp)
    80001406:	ec26                	sd	s1,24(sp)
    80001408:	e84a                	sd	s2,16(sp)
    8000140a:	e44e                	sd	s3,8(sp)
    8000140c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000140e:	00000097          	auipc	ra,0x0
    80001412:	a3a080e7          	jalr	-1478(ra) # 80000e48 <myproc>
    80001416:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001418:	00005097          	auipc	ra,0x5
    8000141c:	f3c080e7          	jalr	-196(ra) # 80006354 <holding>
    80001420:	c93d                	beqz	a0,80001496 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001422:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001424:	2781                	sext.w	a5,a5
    80001426:	079e                	slli	a5,a5,0x7
    80001428:	00008717          	auipc	a4,0x8
    8000142c:	c2870713          	addi	a4,a4,-984 # 80009050 <pid_lock>
    80001430:	97ba                	add	a5,a5,a4
    80001432:	0a87a703          	lw	a4,168(a5)
    80001436:	4785                	li	a5,1
    80001438:	06f71763          	bne	a4,a5,800014a6 <sched+0xa6>
  if(p->state == RUNNING)
    8000143c:	4c98                	lw	a4,24(s1)
    8000143e:	4791                	li	a5,4
    80001440:	06f70b63          	beq	a4,a5,800014b6 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001444:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001448:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000144a:	efb5                	bnez	a5,800014c6 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000144c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000144e:	00008917          	auipc	s2,0x8
    80001452:	c0290913          	addi	s2,s2,-1022 # 80009050 <pid_lock>
    80001456:	2781                	sext.w	a5,a5
    80001458:	079e                	slli	a5,a5,0x7
    8000145a:	97ca                	add	a5,a5,s2
    8000145c:	0ac7a983          	lw	s3,172(a5)
    80001460:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001462:	2781                	sext.w	a5,a5
    80001464:	079e                	slli	a5,a5,0x7
    80001466:	00008597          	auipc	a1,0x8
    8000146a:	c2258593          	addi	a1,a1,-990 # 80009088 <cpus+0x8>
    8000146e:	95be                	add	a1,a1,a5
    80001470:	07848513          	addi	a0,s1,120
    80001474:	00000097          	auipc	ra,0x0
    80001478:	59c080e7          	jalr	1436(ra) # 80001a10 <swtch>
    8000147c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000147e:	2781                	sext.w	a5,a5
    80001480:	079e                	slli	a5,a5,0x7
    80001482:	97ca                	add	a5,a5,s2
    80001484:	0b37a623          	sw	s3,172(a5)
}
    80001488:	70a2                	ld	ra,40(sp)
    8000148a:	7402                	ld	s0,32(sp)
    8000148c:	64e2                	ld	s1,24(sp)
    8000148e:	6942                	ld	s2,16(sp)
    80001490:	69a2                	ld	s3,8(sp)
    80001492:	6145                	addi	sp,sp,48
    80001494:	8082                	ret
    panic("sched p->lock");
    80001496:	00007517          	auipc	a0,0x7
    8000149a:	d0250513          	addi	a0,a0,-766 # 80008198 <etext+0x198>
    8000149e:	00005097          	auipc	ra,0x5
    800014a2:	98a080e7          	jalr	-1654(ra) # 80005e28 <panic>
    panic("sched locks");
    800014a6:	00007517          	auipc	a0,0x7
    800014aa:	d0250513          	addi	a0,a0,-766 # 800081a8 <etext+0x1a8>
    800014ae:	00005097          	auipc	ra,0x5
    800014b2:	97a080e7          	jalr	-1670(ra) # 80005e28 <panic>
    panic("sched running");
    800014b6:	00007517          	auipc	a0,0x7
    800014ba:	d0250513          	addi	a0,a0,-766 # 800081b8 <etext+0x1b8>
    800014be:	00005097          	auipc	ra,0x5
    800014c2:	96a080e7          	jalr	-1686(ra) # 80005e28 <panic>
    panic("sched interruptible");
    800014c6:	00007517          	auipc	a0,0x7
    800014ca:	d0250513          	addi	a0,a0,-766 # 800081c8 <etext+0x1c8>
    800014ce:	00005097          	auipc	ra,0x5
    800014d2:	95a080e7          	jalr	-1702(ra) # 80005e28 <panic>

00000000800014d6 <yield>:
{
    800014d6:	1101                	addi	sp,sp,-32
    800014d8:	ec06                	sd	ra,24(sp)
    800014da:	e822                	sd	s0,16(sp)
    800014dc:	e426                	sd	s1,8(sp)
    800014de:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014e0:	00000097          	auipc	ra,0x0
    800014e4:	968080e7          	jalr	-1688(ra) # 80000e48 <myproc>
    800014e8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014ea:	00005097          	auipc	ra,0x5
    800014ee:	ee4080e7          	jalr	-284(ra) # 800063ce <acquire>
  p->state = RUNNABLE;
    800014f2:	478d                	li	a5,3
    800014f4:	cc9c                	sw	a5,24(s1)
  sched();
    800014f6:	00000097          	auipc	ra,0x0
    800014fa:	f0a080e7          	jalr	-246(ra) # 80001400 <sched>
  release(&p->lock);
    800014fe:	8526                	mv	a0,s1
    80001500:	00005097          	auipc	ra,0x5
    80001504:	f82080e7          	jalr	-126(ra) # 80006482 <release>
}
    80001508:	60e2                	ld	ra,24(sp)
    8000150a:	6442                	ld	s0,16(sp)
    8000150c:	64a2                	ld	s1,8(sp)
    8000150e:	6105                	addi	sp,sp,32
    80001510:	8082                	ret

0000000080001512 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001512:	7179                	addi	sp,sp,-48
    80001514:	f406                	sd	ra,40(sp)
    80001516:	f022                	sd	s0,32(sp)
    80001518:	ec26                	sd	s1,24(sp)
    8000151a:	e84a                	sd	s2,16(sp)
    8000151c:	e44e                	sd	s3,8(sp)
    8000151e:	1800                	addi	s0,sp,48
    80001520:	89aa                	mv	s3,a0
    80001522:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001524:	00000097          	auipc	ra,0x0
    80001528:	924080e7          	jalr	-1756(ra) # 80000e48 <myproc>
    8000152c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	ea0080e7          	jalr	-352(ra) # 800063ce <acquire>
  release(lk);
    80001536:	854a                	mv	a0,s2
    80001538:	00005097          	auipc	ra,0x5
    8000153c:	f4a080e7          	jalr	-182(ra) # 80006482 <release>

  // Go to sleep.
  p->chan = chan;
    80001540:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001544:	4789                	li	a5,2
    80001546:	cc9c                	sw	a5,24(s1)

  sched();
    80001548:	00000097          	auipc	ra,0x0
    8000154c:	eb8080e7          	jalr	-328(ra) # 80001400 <sched>

  // Tidy up.
  p->chan = 0;
    80001550:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001554:	8526                	mv	a0,s1
    80001556:	00005097          	auipc	ra,0x5
    8000155a:	f2c080e7          	jalr	-212(ra) # 80006482 <release>
  acquire(lk);
    8000155e:	854a                	mv	a0,s2
    80001560:	00005097          	auipc	ra,0x5
    80001564:	e6e080e7          	jalr	-402(ra) # 800063ce <acquire>
}
    80001568:	70a2                	ld	ra,40(sp)
    8000156a:	7402                	ld	s0,32(sp)
    8000156c:	64e2                	ld	s1,24(sp)
    8000156e:	6942                	ld	s2,16(sp)
    80001570:	69a2                	ld	s3,8(sp)
    80001572:	6145                	addi	sp,sp,48
    80001574:	8082                	ret

0000000080001576 <wait>:
{
    80001576:	715d                	addi	sp,sp,-80
    80001578:	e486                	sd	ra,72(sp)
    8000157a:	e0a2                	sd	s0,64(sp)
    8000157c:	fc26                	sd	s1,56(sp)
    8000157e:	f84a                	sd	s2,48(sp)
    80001580:	f44e                	sd	s3,40(sp)
    80001582:	f052                	sd	s4,32(sp)
    80001584:	ec56                	sd	s5,24(sp)
    80001586:	e85a                	sd	s6,16(sp)
    80001588:	e45e                	sd	s7,8(sp)
    8000158a:	e062                	sd	s8,0(sp)
    8000158c:	0880                	addi	s0,sp,80
    8000158e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001590:	00000097          	auipc	ra,0x0
    80001594:	8b8080e7          	jalr	-1864(ra) # 80000e48 <myproc>
    80001598:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000159a:	00008517          	auipc	a0,0x8
    8000159e:	ace50513          	addi	a0,a0,-1330 # 80009068 <wait_lock>
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	e2c080e7          	jalr	-468(ra) # 800063ce <acquire>
    havekids = 0;
    800015aa:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015ac:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015ae:	0000e997          	auipc	s3,0xe
    800015b2:	ed298993          	addi	s3,s3,-302 # 8000f480 <tickslock>
        havekids = 1;
    800015b6:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015b8:	00008c17          	auipc	s8,0x8
    800015bc:	ab0c0c13          	addi	s8,s8,-1360 # 80009068 <wait_lock>
    havekids = 0;
    800015c0:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015c2:	00008497          	auipc	s1,0x8
    800015c6:	ebe48493          	addi	s1,s1,-322 # 80009480 <proc>
    800015ca:	a0bd                	j	80001638 <wait+0xc2>
          pid = np->pid;
    800015cc:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015d0:	000b0e63          	beqz	s6,800015ec <wait+0x76>
    800015d4:	4691                	li	a3,4
    800015d6:	02c48613          	addi	a2,s1,44
    800015da:	85da                	mv	a1,s6
    800015dc:	05093503          	ld	a0,80(s2)
    800015e0:	fffff097          	auipc	ra,0xfffff
    800015e4:	52a080e7          	jalr	1322(ra) # 80000b0a <copyout>
    800015e8:	02054563          	bltz	a0,80001612 <wait+0x9c>
          freeproc(np);
    800015ec:	8526                	mv	a0,s1
    800015ee:	00000097          	auipc	ra,0x0
    800015f2:	a0c080e7          	jalr	-1524(ra) # 80000ffa <freeproc>
          release(&np->lock);
    800015f6:	8526                	mv	a0,s1
    800015f8:	00005097          	auipc	ra,0x5
    800015fc:	e8a080e7          	jalr	-374(ra) # 80006482 <release>
          release(&wait_lock);
    80001600:	00008517          	auipc	a0,0x8
    80001604:	a6850513          	addi	a0,a0,-1432 # 80009068 <wait_lock>
    80001608:	00005097          	auipc	ra,0x5
    8000160c:	e7a080e7          	jalr	-390(ra) # 80006482 <release>
          return pid;
    80001610:	a09d                	j	80001676 <wait+0x100>
            release(&np->lock);
    80001612:	8526                	mv	a0,s1
    80001614:	00005097          	auipc	ra,0x5
    80001618:	e6e080e7          	jalr	-402(ra) # 80006482 <release>
            release(&wait_lock);
    8000161c:	00008517          	auipc	a0,0x8
    80001620:	a4c50513          	addi	a0,a0,-1460 # 80009068 <wait_lock>
    80001624:	00005097          	auipc	ra,0x5
    80001628:	e5e080e7          	jalr	-418(ra) # 80006482 <release>
            return -1;
    8000162c:	59fd                	li	s3,-1
    8000162e:	a0a1                	j	80001676 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001630:	18048493          	addi	s1,s1,384
    80001634:	03348463          	beq	s1,s3,8000165c <wait+0xe6>
      if(np->parent == p){
    80001638:	7c9c                	ld	a5,56(s1)
    8000163a:	ff279be3          	bne	a5,s2,80001630 <wait+0xba>
        acquire(&np->lock);
    8000163e:	8526                	mv	a0,s1
    80001640:	00005097          	auipc	ra,0x5
    80001644:	d8e080e7          	jalr	-626(ra) # 800063ce <acquire>
        if(np->state == ZOMBIE){
    80001648:	4c9c                	lw	a5,24(s1)
    8000164a:	f94781e3          	beq	a5,s4,800015cc <wait+0x56>
        release(&np->lock);
    8000164e:	8526                	mv	a0,s1
    80001650:	00005097          	auipc	ra,0x5
    80001654:	e32080e7          	jalr	-462(ra) # 80006482 <release>
        havekids = 1;
    80001658:	8756                	mv	a4,s5
    8000165a:	bfd9                	j	80001630 <wait+0xba>
    if(!havekids || p->killed){
    8000165c:	c701                	beqz	a4,80001664 <wait+0xee>
    8000165e:	02892783          	lw	a5,40(s2)
    80001662:	c79d                	beqz	a5,80001690 <wait+0x11a>
      release(&wait_lock);
    80001664:	00008517          	auipc	a0,0x8
    80001668:	a0450513          	addi	a0,a0,-1532 # 80009068 <wait_lock>
    8000166c:	00005097          	auipc	ra,0x5
    80001670:	e16080e7          	jalr	-490(ra) # 80006482 <release>
      return -1;
    80001674:	59fd                	li	s3,-1
}
    80001676:	854e                	mv	a0,s3
    80001678:	60a6                	ld	ra,72(sp)
    8000167a:	6406                	ld	s0,64(sp)
    8000167c:	74e2                	ld	s1,56(sp)
    8000167e:	7942                	ld	s2,48(sp)
    80001680:	79a2                	ld	s3,40(sp)
    80001682:	7a02                	ld	s4,32(sp)
    80001684:	6ae2                	ld	s5,24(sp)
    80001686:	6b42                	ld	s6,16(sp)
    80001688:	6ba2                	ld	s7,8(sp)
    8000168a:	6c02                	ld	s8,0(sp)
    8000168c:	6161                	addi	sp,sp,80
    8000168e:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001690:	85e2                	mv	a1,s8
    80001692:	854a                	mv	a0,s2
    80001694:	00000097          	auipc	ra,0x0
    80001698:	e7e080e7          	jalr	-386(ra) # 80001512 <sleep>
    havekids = 0;
    8000169c:	b715                	j	800015c0 <wait+0x4a>

000000008000169e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000169e:	7139                	addi	sp,sp,-64
    800016a0:	fc06                	sd	ra,56(sp)
    800016a2:	f822                	sd	s0,48(sp)
    800016a4:	f426                	sd	s1,40(sp)
    800016a6:	f04a                	sd	s2,32(sp)
    800016a8:	ec4e                	sd	s3,24(sp)
    800016aa:	e852                	sd	s4,16(sp)
    800016ac:	e456                	sd	s5,8(sp)
    800016ae:	0080                	addi	s0,sp,64
    800016b0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016b2:	00008497          	auipc	s1,0x8
    800016b6:	dce48493          	addi	s1,s1,-562 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016ba:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016bc:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016be:	0000e917          	auipc	s2,0xe
    800016c2:	dc290913          	addi	s2,s2,-574 # 8000f480 <tickslock>
    800016c6:	a821                	j	800016de <wakeup+0x40>
        p->state = RUNNABLE;
    800016c8:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800016cc:	8526                	mv	a0,s1
    800016ce:	00005097          	auipc	ra,0x5
    800016d2:	db4080e7          	jalr	-588(ra) # 80006482 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016d6:	18048493          	addi	s1,s1,384
    800016da:	03248463          	beq	s1,s2,80001702 <wakeup+0x64>
    if(p != myproc()){
    800016de:	fffff097          	auipc	ra,0xfffff
    800016e2:	76a080e7          	jalr	1898(ra) # 80000e48 <myproc>
    800016e6:	fea488e3          	beq	s1,a0,800016d6 <wakeup+0x38>
      acquire(&p->lock);
    800016ea:	8526                	mv	a0,s1
    800016ec:	00005097          	auipc	ra,0x5
    800016f0:	ce2080e7          	jalr	-798(ra) # 800063ce <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016f4:	4c9c                	lw	a5,24(s1)
    800016f6:	fd379be3          	bne	a5,s3,800016cc <wakeup+0x2e>
    800016fa:	709c                	ld	a5,32(s1)
    800016fc:	fd4798e3          	bne	a5,s4,800016cc <wakeup+0x2e>
    80001700:	b7e1                	j	800016c8 <wakeup+0x2a>
    }
  }
}
    80001702:	70e2                	ld	ra,56(sp)
    80001704:	7442                	ld	s0,48(sp)
    80001706:	74a2                	ld	s1,40(sp)
    80001708:	7902                	ld	s2,32(sp)
    8000170a:	69e2                	ld	s3,24(sp)
    8000170c:	6a42                	ld	s4,16(sp)
    8000170e:	6aa2                	ld	s5,8(sp)
    80001710:	6121                	addi	sp,sp,64
    80001712:	8082                	ret

0000000080001714 <reparent>:
{
    80001714:	7179                	addi	sp,sp,-48
    80001716:	f406                	sd	ra,40(sp)
    80001718:	f022                	sd	s0,32(sp)
    8000171a:	ec26                	sd	s1,24(sp)
    8000171c:	e84a                	sd	s2,16(sp)
    8000171e:	e44e                	sd	s3,8(sp)
    80001720:	e052                	sd	s4,0(sp)
    80001722:	1800                	addi	s0,sp,48
    80001724:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001726:	00008497          	auipc	s1,0x8
    8000172a:	d5a48493          	addi	s1,s1,-678 # 80009480 <proc>
      pp->parent = initproc;
    8000172e:	00008a17          	auipc	s4,0x8
    80001732:	8e2a0a13          	addi	s4,s4,-1822 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001736:	0000e997          	auipc	s3,0xe
    8000173a:	d4a98993          	addi	s3,s3,-694 # 8000f480 <tickslock>
    8000173e:	a029                	j	80001748 <reparent+0x34>
    80001740:	18048493          	addi	s1,s1,384
    80001744:	01348d63          	beq	s1,s3,8000175e <reparent+0x4a>
    if(pp->parent == p){
    80001748:	7c9c                	ld	a5,56(s1)
    8000174a:	ff279be3          	bne	a5,s2,80001740 <reparent+0x2c>
      pp->parent = initproc;
    8000174e:	000a3503          	ld	a0,0(s4)
    80001752:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001754:	00000097          	auipc	ra,0x0
    80001758:	f4a080e7          	jalr	-182(ra) # 8000169e <wakeup>
    8000175c:	b7d5                	j	80001740 <reparent+0x2c>
}
    8000175e:	70a2                	ld	ra,40(sp)
    80001760:	7402                	ld	s0,32(sp)
    80001762:	64e2                	ld	s1,24(sp)
    80001764:	6942                	ld	s2,16(sp)
    80001766:	69a2                	ld	s3,8(sp)
    80001768:	6a02                	ld	s4,0(sp)
    8000176a:	6145                	addi	sp,sp,48
    8000176c:	8082                	ret

000000008000176e <exit>:
{
    8000176e:	7179                	addi	sp,sp,-48
    80001770:	f406                	sd	ra,40(sp)
    80001772:	f022                	sd	s0,32(sp)
    80001774:	ec26                	sd	s1,24(sp)
    80001776:	e84a                	sd	s2,16(sp)
    80001778:	e44e                	sd	s3,8(sp)
    8000177a:	e052                	sd	s4,0(sp)
    8000177c:	1800                	addi	s0,sp,48
    8000177e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001780:	fffff097          	auipc	ra,0xfffff
    80001784:	6c8080e7          	jalr	1736(ra) # 80000e48 <myproc>
    80001788:	89aa                	mv	s3,a0
  if(p == initproc)
    8000178a:	00008797          	auipc	a5,0x8
    8000178e:	8867b783          	ld	a5,-1914(a5) # 80009010 <initproc>
    80001792:	0e850493          	addi	s1,a0,232
    80001796:	16850913          	addi	s2,a0,360
    8000179a:	02a79363          	bne	a5,a0,800017c0 <exit+0x52>
    panic("init exiting");
    8000179e:	00007517          	auipc	a0,0x7
    800017a2:	a4250513          	addi	a0,a0,-1470 # 800081e0 <etext+0x1e0>
    800017a6:	00004097          	auipc	ra,0x4
    800017aa:	682080e7          	jalr	1666(ra) # 80005e28 <panic>
      fileclose(f);
    800017ae:	00002097          	auipc	ra,0x2
    800017b2:	460080e7          	jalr	1120(ra) # 80003c0e <fileclose>
      p->ofile[fd] = 0;
    800017b6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017ba:	04a1                	addi	s1,s1,8
    800017bc:	01248563          	beq	s1,s2,800017c6 <exit+0x58>
    if(p->ofile[fd]){
    800017c0:	6088                	ld	a0,0(s1)
    800017c2:	f575                	bnez	a0,800017ae <exit+0x40>
    800017c4:	bfdd                	j	800017ba <exit+0x4c>
  begin_op();
    800017c6:	00002097          	auipc	ra,0x2
    800017ca:	f7c080e7          	jalr	-132(ra) # 80003742 <begin_op>
  iput(p->cwd);
    800017ce:	1689b503          	ld	a0,360(s3)
    800017d2:	00001097          	auipc	ra,0x1
    800017d6:	758080e7          	jalr	1880(ra) # 80002f2a <iput>
  end_op();
    800017da:	00002097          	auipc	ra,0x2
    800017de:	fe8080e7          	jalr	-24(ra) # 800037c2 <end_op>
  p->cwd = 0;
    800017e2:	1609b423          	sd	zero,360(s3)
  acquire(&wait_lock);
    800017e6:	00008497          	auipc	s1,0x8
    800017ea:	88248493          	addi	s1,s1,-1918 # 80009068 <wait_lock>
    800017ee:	8526                	mv	a0,s1
    800017f0:	00005097          	auipc	ra,0x5
    800017f4:	bde080e7          	jalr	-1058(ra) # 800063ce <acquire>
  reparent(p);
    800017f8:	854e                	mv	a0,s3
    800017fa:	00000097          	auipc	ra,0x0
    800017fe:	f1a080e7          	jalr	-230(ra) # 80001714 <reparent>
  wakeup(p->parent);
    80001802:	0389b503          	ld	a0,56(s3)
    80001806:	00000097          	auipc	ra,0x0
    8000180a:	e98080e7          	jalr	-360(ra) # 8000169e <wakeup>
  acquire(&p->lock);
    8000180e:	854e                	mv	a0,s3
    80001810:	00005097          	auipc	ra,0x5
    80001814:	bbe080e7          	jalr	-1090(ra) # 800063ce <acquire>
  p->xstate = status;
    80001818:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000181c:	4795                	li	a5,5
    8000181e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001822:	8526                	mv	a0,s1
    80001824:	00005097          	auipc	ra,0x5
    80001828:	c5e080e7          	jalr	-930(ra) # 80006482 <release>
  sched();
    8000182c:	00000097          	auipc	ra,0x0
    80001830:	bd4080e7          	jalr	-1068(ra) # 80001400 <sched>
  panic("zombie exit");
    80001834:	00007517          	auipc	a0,0x7
    80001838:	9bc50513          	addi	a0,a0,-1604 # 800081f0 <etext+0x1f0>
    8000183c:	00004097          	auipc	ra,0x4
    80001840:	5ec080e7          	jalr	1516(ra) # 80005e28 <panic>

0000000080001844 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001844:	7179                	addi	sp,sp,-48
    80001846:	f406                	sd	ra,40(sp)
    80001848:	f022                	sd	s0,32(sp)
    8000184a:	ec26                	sd	s1,24(sp)
    8000184c:	e84a                	sd	s2,16(sp)
    8000184e:	e44e                	sd	s3,8(sp)
    80001850:	1800                	addi	s0,sp,48
    80001852:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001854:	00008497          	auipc	s1,0x8
    80001858:	c2c48493          	addi	s1,s1,-980 # 80009480 <proc>
    8000185c:	0000e997          	auipc	s3,0xe
    80001860:	c2498993          	addi	s3,s3,-988 # 8000f480 <tickslock>
    acquire(&p->lock);
    80001864:	8526                	mv	a0,s1
    80001866:	00005097          	auipc	ra,0x5
    8000186a:	b68080e7          	jalr	-1176(ra) # 800063ce <acquire>
    if(p->pid == pid){
    8000186e:	589c                	lw	a5,48(s1)
    80001870:	01278d63          	beq	a5,s2,8000188a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001874:	8526                	mv	a0,s1
    80001876:	00005097          	auipc	ra,0x5
    8000187a:	c0c080e7          	jalr	-1012(ra) # 80006482 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000187e:	18048493          	addi	s1,s1,384
    80001882:	ff3491e3          	bne	s1,s3,80001864 <kill+0x20>
  }
  return -1;
    80001886:	557d                	li	a0,-1
    80001888:	a829                	j	800018a2 <kill+0x5e>
      p->killed = 1;
    8000188a:	4785                	li	a5,1
    8000188c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000188e:	4c98                	lw	a4,24(s1)
    80001890:	4789                	li	a5,2
    80001892:	00f70f63          	beq	a4,a5,800018b0 <kill+0x6c>
      release(&p->lock);
    80001896:	8526                	mv	a0,s1
    80001898:	00005097          	auipc	ra,0x5
    8000189c:	bea080e7          	jalr	-1046(ra) # 80006482 <release>
      return 0;
    800018a0:	4501                	li	a0,0
}
    800018a2:	70a2                	ld	ra,40(sp)
    800018a4:	7402                	ld	s0,32(sp)
    800018a6:	64e2                	ld	s1,24(sp)
    800018a8:	6942                	ld	s2,16(sp)
    800018aa:	69a2                	ld	s3,8(sp)
    800018ac:	6145                	addi	sp,sp,48
    800018ae:	8082                	ret
        p->state = RUNNABLE;
    800018b0:	478d                	li	a5,3
    800018b2:	cc9c                	sw	a5,24(s1)
    800018b4:	b7cd                	j	80001896 <kill+0x52>

00000000800018b6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018b6:	7179                	addi	sp,sp,-48
    800018b8:	f406                	sd	ra,40(sp)
    800018ba:	f022                	sd	s0,32(sp)
    800018bc:	ec26                	sd	s1,24(sp)
    800018be:	e84a                	sd	s2,16(sp)
    800018c0:	e44e                	sd	s3,8(sp)
    800018c2:	e052                	sd	s4,0(sp)
    800018c4:	1800                	addi	s0,sp,48
    800018c6:	84aa                	mv	s1,a0
    800018c8:	892e                	mv	s2,a1
    800018ca:	89b2                	mv	s3,a2
    800018cc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018ce:	fffff097          	auipc	ra,0xfffff
    800018d2:	57a080e7          	jalr	1402(ra) # 80000e48 <myproc>
  if(user_dst){
    800018d6:	c08d                	beqz	s1,800018f8 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018d8:	86d2                	mv	a3,s4
    800018da:	864e                	mv	a2,s3
    800018dc:	85ca                	mv	a1,s2
    800018de:	6928                	ld	a0,80(a0)
    800018e0:	fffff097          	auipc	ra,0xfffff
    800018e4:	22a080e7          	jalr	554(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018e8:	70a2                	ld	ra,40(sp)
    800018ea:	7402                	ld	s0,32(sp)
    800018ec:	64e2                	ld	s1,24(sp)
    800018ee:	6942                	ld	s2,16(sp)
    800018f0:	69a2                	ld	s3,8(sp)
    800018f2:	6a02                	ld	s4,0(sp)
    800018f4:	6145                	addi	sp,sp,48
    800018f6:	8082                	ret
    memmove((char *)dst, src, len);
    800018f8:	000a061b          	sext.w	a2,s4
    800018fc:	85ce                	mv	a1,s3
    800018fe:	854a                	mv	a0,s2
    80001900:	fffff097          	auipc	ra,0xfffff
    80001904:	8d8080e7          	jalr	-1832(ra) # 800001d8 <memmove>
    return 0;
    80001908:	8526                	mv	a0,s1
    8000190a:	bff9                	j	800018e8 <either_copyout+0x32>

000000008000190c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000190c:	7179                	addi	sp,sp,-48
    8000190e:	f406                	sd	ra,40(sp)
    80001910:	f022                	sd	s0,32(sp)
    80001912:	ec26                	sd	s1,24(sp)
    80001914:	e84a                	sd	s2,16(sp)
    80001916:	e44e                	sd	s3,8(sp)
    80001918:	e052                	sd	s4,0(sp)
    8000191a:	1800                	addi	s0,sp,48
    8000191c:	892a                	mv	s2,a0
    8000191e:	84ae                	mv	s1,a1
    80001920:	89b2                	mv	s3,a2
    80001922:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001924:	fffff097          	auipc	ra,0xfffff
    80001928:	524080e7          	jalr	1316(ra) # 80000e48 <myproc>
  if(user_src){
    8000192c:	c08d                	beqz	s1,8000194e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000192e:	86d2                	mv	a3,s4
    80001930:	864e                	mv	a2,s3
    80001932:	85ca                	mv	a1,s2
    80001934:	6928                	ld	a0,80(a0)
    80001936:	fffff097          	auipc	ra,0xfffff
    8000193a:	260080e7          	jalr	608(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000193e:	70a2                	ld	ra,40(sp)
    80001940:	7402                	ld	s0,32(sp)
    80001942:	64e2                	ld	s1,24(sp)
    80001944:	6942                	ld	s2,16(sp)
    80001946:	69a2                	ld	s3,8(sp)
    80001948:	6a02                	ld	s4,0(sp)
    8000194a:	6145                	addi	sp,sp,48
    8000194c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000194e:	000a061b          	sext.w	a2,s4
    80001952:	85ce                	mv	a1,s3
    80001954:	854a                	mv	a0,s2
    80001956:	fffff097          	auipc	ra,0xfffff
    8000195a:	882080e7          	jalr	-1918(ra) # 800001d8 <memmove>
    return 0;
    8000195e:	8526                	mv	a0,s1
    80001960:	bff9                	j	8000193e <either_copyin+0x32>

0000000080001962 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001962:	715d                	addi	sp,sp,-80
    80001964:	e486                	sd	ra,72(sp)
    80001966:	e0a2                	sd	s0,64(sp)
    80001968:	fc26                	sd	s1,56(sp)
    8000196a:	f84a                	sd	s2,48(sp)
    8000196c:	f44e                	sd	s3,40(sp)
    8000196e:	f052                	sd	s4,32(sp)
    80001970:	ec56                	sd	s5,24(sp)
    80001972:	e85a                	sd	s6,16(sp)
    80001974:	e45e                	sd	s7,8(sp)
    80001976:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001978:	00006517          	auipc	a0,0x6
    8000197c:	6d050513          	addi	a0,a0,1744 # 80008048 <etext+0x48>
    80001980:	00004097          	auipc	ra,0x4
    80001984:	4f2080e7          	jalr	1266(ra) # 80005e72 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001988:	00008497          	auipc	s1,0x8
    8000198c:	c6848493          	addi	s1,s1,-920 # 800095f0 <proc+0x170>
    80001990:	0000e917          	auipc	s2,0xe
    80001994:	c6090913          	addi	s2,s2,-928 # 8000f5f0 <bcache+0x158>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001998:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000199a:	00007997          	auipc	s3,0x7
    8000199e:	86698993          	addi	s3,s3,-1946 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019a2:	00007a97          	auipc	s5,0x7
    800019a6:	866a8a93          	addi	s5,s5,-1946 # 80008208 <etext+0x208>
    printf("\n");
    800019aa:	00006a17          	auipc	s4,0x6
    800019ae:	69ea0a13          	addi	s4,s4,1694 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019b2:	00007b97          	auipc	s7,0x7
    800019b6:	88eb8b93          	addi	s7,s7,-1906 # 80008240 <states.1754>
    800019ba:	a00d                	j	800019dc <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019bc:	ec06a583          	lw	a1,-320(a3)
    800019c0:	8556                	mv	a0,s5
    800019c2:	00004097          	auipc	ra,0x4
    800019c6:	4b0080e7          	jalr	1200(ra) # 80005e72 <printf>
    printf("\n");
    800019ca:	8552                	mv	a0,s4
    800019cc:	00004097          	auipc	ra,0x4
    800019d0:	4a6080e7          	jalr	1190(ra) # 80005e72 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d4:	18048493          	addi	s1,s1,384
    800019d8:	03248163          	beq	s1,s2,800019fa <procdump+0x98>
    if(p->state == UNUSED)
    800019dc:	86a6                	mv	a3,s1
    800019de:	ea84a783          	lw	a5,-344(s1)
    800019e2:	dbed                	beqz	a5,800019d4 <procdump+0x72>
      state = "???";
    800019e4:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e6:	fcfb6be3          	bltu	s6,a5,800019bc <procdump+0x5a>
    800019ea:	1782                	slli	a5,a5,0x20
    800019ec:	9381                	srli	a5,a5,0x20
    800019ee:	078e                	slli	a5,a5,0x3
    800019f0:	97de                	add	a5,a5,s7
    800019f2:	6390                	ld	a2,0(a5)
    800019f4:	f661                	bnez	a2,800019bc <procdump+0x5a>
      state = "???";
    800019f6:	864e                	mv	a2,s3
    800019f8:	b7d1                	j	800019bc <procdump+0x5a>
  }
}
    800019fa:	60a6                	ld	ra,72(sp)
    800019fc:	6406                	ld	s0,64(sp)
    800019fe:	74e2                	ld	s1,56(sp)
    80001a00:	7942                	ld	s2,48(sp)
    80001a02:	79a2                	ld	s3,40(sp)
    80001a04:	7a02                	ld	s4,32(sp)
    80001a06:	6ae2                	ld	s5,24(sp)
    80001a08:	6b42                	ld	s6,16(sp)
    80001a0a:	6ba2                	ld	s7,8(sp)
    80001a0c:	6161                	addi	sp,sp,80
    80001a0e:	8082                	ret

0000000080001a10 <swtch>:
    80001a10:	00153023          	sd	ra,0(a0)
    80001a14:	00253423          	sd	sp,8(a0)
    80001a18:	e900                	sd	s0,16(a0)
    80001a1a:	ed04                	sd	s1,24(a0)
    80001a1c:	03253023          	sd	s2,32(a0)
    80001a20:	03353423          	sd	s3,40(a0)
    80001a24:	03453823          	sd	s4,48(a0)
    80001a28:	03553c23          	sd	s5,56(a0)
    80001a2c:	05653023          	sd	s6,64(a0)
    80001a30:	05753423          	sd	s7,72(a0)
    80001a34:	05853823          	sd	s8,80(a0)
    80001a38:	05953c23          	sd	s9,88(a0)
    80001a3c:	07a53023          	sd	s10,96(a0)
    80001a40:	07b53423          	sd	s11,104(a0)
    80001a44:	0005b083          	ld	ra,0(a1)
    80001a48:	0085b103          	ld	sp,8(a1)
    80001a4c:	6980                	ld	s0,16(a1)
    80001a4e:	6d84                	ld	s1,24(a1)
    80001a50:	0205b903          	ld	s2,32(a1)
    80001a54:	0285b983          	ld	s3,40(a1)
    80001a58:	0305ba03          	ld	s4,48(a1)
    80001a5c:	0385ba83          	ld	s5,56(a1)
    80001a60:	0405bb03          	ld	s6,64(a1)
    80001a64:	0485bb83          	ld	s7,72(a1)
    80001a68:	0505bc03          	ld	s8,80(a1)
    80001a6c:	0585bc83          	ld	s9,88(a1)
    80001a70:	0605bd03          	ld	s10,96(a1)
    80001a74:	0685bd83          	ld	s11,104(a1)
    80001a78:	8082                	ret

0000000080001a7a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a7a:	1141                	addi	sp,sp,-16
    80001a7c:	e406                	sd	ra,8(sp)
    80001a7e:	e022                	sd	s0,0(sp)
    80001a80:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a82:	00006597          	auipc	a1,0x6
    80001a86:	7ee58593          	addi	a1,a1,2030 # 80008270 <states.1754+0x30>
    80001a8a:	0000e517          	auipc	a0,0xe
    80001a8e:	9f650513          	addi	a0,a0,-1546 # 8000f480 <tickslock>
    80001a92:	00005097          	auipc	ra,0x5
    80001a96:	8ac080e7          	jalr	-1876(ra) # 8000633e <initlock>
}
    80001a9a:	60a2                	ld	ra,8(sp)
    80001a9c:	6402                	ld	s0,0(sp)
    80001a9e:	0141                	addi	sp,sp,16
    80001aa0:	8082                	ret

0000000080001aa2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001aa2:	1141                	addi	sp,sp,-16
    80001aa4:	e422                	sd	s0,8(sp)
    80001aa6:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aa8:	00003797          	auipc	a5,0x3
    80001aac:	78878793          	addi	a5,a5,1928 # 80005230 <kernelvec>
    80001ab0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ab4:	6422                	ld	s0,8(sp)
    80001ab6:	0141                	addi	sp,sp,16
    80001ab8:	8082                	ret

0000000080001aba <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001aba:	1141                	addi	sp,sp,-16
    80001abc:	e406                	sd	ra,8(sp)
    80001abe:	e022                	sd	s0,0(sp)
    80001ac0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ac2:	fffff097          	auipc	ra,0xfffff
    80001ac6:	386080e7          	jalr	902(ra) # 80000e48 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aca:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ace:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ad0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ad4:	00005617          	auipc	a2,0x5
    80001ad8:	52c60613          	addi	a2,a2,1324 # 80007000 <_trampoline>
    80001adc:	00005697          	auipc	a3,0x5
    80001ae0:	52468693          	addi	a3,a3,1316 # 80007000 <_trampoline>
    80001ae4:	8e91                	sub	a3,a3,a2
    80001ae6:	040007b7          	lui	a5,0x4000
    80001aea:	17fd                	addi	a5,a5,-1
    80001aec:	07b2                	slli	a5,a5,0xc
    80001aee:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af0:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001af4:	7938                	ld	a4,112(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001af6:	180026f3          	csrr	a3,satp
    80001afa:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001afc:	7938                	ld	a4,112(a0)
    80001afe:	6134                	ld	a3,64(a0)
    80001b00:	6585                	lui	a1,0x1
    80001b02:	96ae                	add	a3,a3,a1
    80001b04:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b06:	7938                	ld	a4,112(a0)
    80001b08:	00000697          	auipc	a3,0x0
    80001b0c:	13868693          	addi	a3,a3,312 # 80001c40 <usertrap>
    80001b10:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b12:	7938                	ld	a4,112(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b14:	8692                	mv	a3,tp
    80001b16:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b18:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b1c:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b20:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b24:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b28:	7938                	ld	a4,112(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b2a:	6f18                	ld	a4,24(a4)
    80001b2c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b30:	692c                	ld	a1,80(a0)
    80001b32:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b34:	00005717          	auipc	a4,0x5
    80001b38:	55c70713          	addi	a4,a4,1372 # 80007090 <userret>
    80001b3c:	8f11                	sub	a4,a4,a2
    80001b3e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b40:	577d                	li	a4,-1
    80001b42:	177e                	slli	a4,a4,0x3f
    80001b44:	8dd9                	or	a1,a1,a4
    80001b46:	02000537          	lui	a0,0x2000
    80001b4a:	157d                	addi	a0,a0,-1
    80001b4c:	0536                	slli	a0,a0,0xd
    80001b4e:	9782                	jalr	a5
}
    80001b50:	60a2                	ld	ra,8(sp)
    80001b52:	6402                	ld	s0,0(sp)
    80001b54:	0141                	addi	sp,sp,16
    80001b56:	8082                	ret

0000000080001b58 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b58:	1101                	addi	sp,sp,-32
    80001b5a:	ec06                	sd	ra,24(sp)
    80001b5c:	e822                	sd	s0,16(sp)
    80001b5e:	e426                	sd	s1,8(sp)
    80001b60:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b62:	0000e497          	auipc	s1,0xe
    80001b66:	91e48493          	addi	s1,s1,-1762 # 8000f480 <tickslock>
    80001b6a:	8526                	mv	a0,s1
    80001b6c:	00005097          	auipc	ra,0x5
    80001b70:	862080e7          	jalr	-1950(ra) # 800063ce <acquire>
  ticks++;
    80001b74:	00007517          	auipc	a0,0x7
    80001b78:	4a450513          	addi	a0,a0,1188 # 80009018 <ticks>
    80001b7c:	411c                	lw	a5,0(a0)
    80001b7e:	2785                	addiw	a5,a5,1
    80001b80:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b82:	00000097          	auipc	ra,0x0
    80001b86:	b1c080e7          	jalr	-1252(ra) # 8000169e <wakeup>
  release(&tickslock);
    80001b8a:	8526                	mv	a0,s1
    80001b8c:	00005097          	auipc	ra,0x5
    80001b90:	8f6080e7          	jalr	-1802(ra) # 80006482 <release>
}
    80001b94:	60e2                	ld	ra,24(sp)
    80001b96:	6442                	ld	s0,16(sp)
    80001b98:	64a2                	ld	s1,8(sp)
    80001b9a:	6105                	addi	sp,sp,32
    80001b9c:	8082                	ret

0000000080001b9e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b9e:	1101                	addi	sp,sp,-32
    80001ba0:	ec06                	sd	ra,24(sp)
    80001ba2:	e822                	sd	s0,16(sp)
    80001ba4:	e426                	sd	s1,8(sp)
    80001ba6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ba8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bac:	00074d63          	bltz	a4,80001bc6 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bb0:	57fd                	li	a5,-1
    80001bb2:	17fe                	slli	a5,a5,0x3f
    80001bb4:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bb6:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bb8:	06f70363          	beq	a4,a5,80001c1e <devintr+0x80>
  }
}
    80001bbc:	60e2                	ld	ra,24(sp)
    80001bbe:	6442                	ld	s0,16(sp)
    80001bc0:	64a2                	ld	s1,8(sp)
    80001bc2:	6105                	addi	sp,sp,32
    80001bc4:	8082                	ret
     (scause & 0xff) == 9){
    80001bc6:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001bca:	46a5                	li	a3,9
    80001bcc:	fed792e3          	bne	a5,a3,80001bb0 <devintr+0x12>
    int irq = plic_claim();
    80001bd0:	00003097          	auipc	ra,0x3
    80001bd4:	768080e7          	jalr	1896(ra) # 80005338 <plic_claim>
    80001bd8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bda:	47a9                	li	a5,10
    80001bdc:	02f50763          	beq	a0,a5,80001c0a <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001be0:	4785                	li	a5,1
    80001be2:	02f50963          	beq	a0,a5,80001c14 <devintr+0x76>
    return 1;
    80001be6:	4505                	li	a0,1
    } else if(irq){
    80001be8:	d8f1                	beqz	s1,80001bbc <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001bea:	85a6                	mv	a1,s1
    80001bec:	00006517          	auipc	a0,0x6
    80001bf0:	68c50513          	addi	a0,a0,1676 # 80008278 <states.1754+0x38>
    80001bf4:	00004097          	auipc	ra,0x4
    80001bf8:	27e080e7          	jalr	638(ra) # 80005e72 <printf>
      plic_complete(irq);
    80001bfc:	8526                	mv	a0,s1
    80001bfe:	00003097          	auipc	ra,0x3
    80001c02:	75e080e7          	jalr	1886(ra) # 8000535c <plic_complete>
    return 1;
    80001c06:	4505                	li	a0,1
    80001c08:	bf55                	j	80001bbc <devintr+0x1e>
      uartintr();
    80001c0a:	00004097          	auipc	ra,0x4
    80001c0e:	6e4080e7          	jalr	1764(ra) # 800062ee <uartintr>
    80001c12:	b7ed                	j	80001bfc <devintr+0x5e>
      virtio_disk_intr();
    80001c14:	00004097          	auipc	ra,0x4
    80001c18:	c28080e7          	jalr	-984(ra) # 8000583c <virtio_disk_intr>
    80001c1c:	b7c5                	j	80001bfc <devintr+0x5e>
    if(cpuid() == 0){
    80001c1e:	fffff097          	auipc	ra,0xfffff
    80001c22:	1fe080e7          	jalr	510(ra) # 80000e1c <cpuid>
    80001c26:	c901                	beqz	a0,80001c36 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c28:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c2c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c2e:	14479073          	csrw	sip,a5
    return 2;
    80001c32:	4509                	li	a0,2
    80001c34:	b761                	j	80001bbc <devintr+0x1e>
      clockintr();
    80001c36:	00000097          	auipc	ra,0x0
    80001c3a:	f22080e7          	jalr	-222(ra) # 80001b58 <clockintr>
    80001c3e:	b7ed                	j	80001c28 <devintr+0x8a>

0000000080001c40 <usertrap>:
{
    80001c40:	1101                	addi	sp,sp,-32
    80001c42:	ec06                	sd	ra,24(sp)
    80001c44:	e822                	sd	s0,16(sp)
    80001c46:	e426                	sd	s1,8(sp)
    80001c48:	e04a                	sd	s2,0(sp)
    80001c4a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c4c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c50:	1007f793          	andi	a5,a5,256
    80001c54:	e3bd                	bnez	a5,80001cba <usertrap+0x7a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c56:	00003797          	auipc	a5,0x3
    80001c5a:	5da78793          	addi	a5,a5,1498 # 80005230 <kernelvec>
    80001c5e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c62:	fffff097          	auipc	ra,0xfffff
    80001c66:	1e6080e7          	jalr	486(ra) # 80000e48 <myproc>
    80001c6a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c6c:	793c                	ld	a5,112(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c6e:	14102773          	csrr	a4,sepc
    80001c72:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c74:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c78:	47a1                	li	a5,8
    80001c7a:	04f71e63          	bne	a4,a5,80001cd6 <usertrap+0x96>
    if(p->killed)
    80001c7e:	551c                	lw	a5,40(a0)
    80001c80:	e7a9                	bnez	a5,80001cca <usertrap+0x8a>
    p->trapframe->epc += 4;
    80001c82:	78b8                	ld	a4,112(s1)
    80001c84:	6f1c                	ld	a5,24(a4)
    80001c86:	0791                	addi	a5,a5,4
    80001c88:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c8a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c8e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c92:	10079073          	csrw	sstatus,a5
    syscall();
    80001c96:	00000097          	auipc	ra,0x0
    80001c9a:	42a080e7          	jalr	1066(ra) # 800020c0 <syscall>
  int which_dev = 0;
    80001c9e:	4901                	li	s2,0
  if(p->killed)
    80001ca0:	549c                	lw	a5,40(s1)
    80001ca2:	1c079163          	bnez	a5,80001e64 <usertrap+0x224>
  usertrapret();
    80001ca6:	00000097          	auipc	ra,0x0
    80001caa:	e14080e7          	jalr	-492(ra) # 80001aba <usertrapret>
}
    80001cae:	60e2                	ld	ra,24(sp)
    80001cb0:	6442                	ld	s0,16(sp)
    80001cb2:	64a2                	ld	s1,8(sp)
    80001cb4:	6902                	ld	s2,0(sp)
    80001cb6:	6105                	addi	sp,sp,32
    80001cb8:	8082                	ret
    panic("usertrap: not from user mode");
    80001cba:	00006517          	auipc	a0,0x6
    80001cbe:	5de50513          	addi	a0,a0,1502 # 80008298 <states.1754+0x58>
    80001cc2:	00004097          	auipc	ra,0x4
    80001cc6:	166080e7          	jalr	358(ra) # 80005e28 <panic>
      exit(-1);
    80001cca:	557d                	li	a0,-1
    80001ccc:	00000097          	auipc	ra,0x0
    80001cd0:	aa2080e7          	jalr	-1374(ra) # 8000176e <exit>
    80001cd4:	b77d                	j	80001c82 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cd6:	00000097          	auipc	ra,0x0
    80001cda:	ec8080e7          	jalr	-312(ra) # 80001b9e <devintr>
    80001cde:	892a                	mv	s2,a0
    80001ce0:	14050363          	beqz	a0,80001e26 <usertrap+0x1e6>
      if(which_dev == 2){
    80001ce4:	4789                	li	a5,2
    80001ce6:	faf51de3          	bne	a0,a5,80001ca0 <usertrap+0x60>
          if(p->ticks != 0){
    80001cea:	4cb8                	lw	a4,88(s1)
    80001cec:	12070563          	beqz	a4,80001e16 <usertrap+0x1d6>
              p->currticks++;
    80001cf0:	4cfc                	lw	a5,92(s1)
    80001cf2:	2785                	addiw	a5,a5,1
    80001cf4:	ccfc                	sw	a5,92(s1)
              if(p->currticks % p->ticks == 0 && p->handlerlock){
    80001cf6:	02e7e7bb          	remw	a5,a5,a4
    80001cfa:	10079e63          	bnez	a5,80001e16 <usertrap+0x1d6>
    80001cfe:	54bc                	lw	a5,104(s1)
    80001d00:	10078b63          	beqz	a5,80001e16 <usertrap+0x1d6>
                  p->handlerlock = 0;
    80001d04:	0604a423          	sw	zero,104(s1)
                  p->trapframe->sepc = p->trapframe->epc;
    80001d08:	78bc                	ld	a5,112(s1)
    80001d0a:	6f98                	ld	a4,24(a5)
    80001d0c:	14e7b023          	sd	a4,320(a5)
                  p->trapframe->sra = p->trapframe->ra;
    80001d10:	78bc                	ld	a5,112(s1)
    80001d12:	7798                	ld	a4,40(a5)
    80001d14:	14e7b423          	sd	a4,328(a5)
                  p->trapframe->ssp = p->trapframe->sp;
    80001d18:	78bc                	ld	a5,112(s1)
    80001d1a:	7b98                	ld	a4,48(a5)
    80001d1c:	14e7b823          	sd	a4,336(a5)
                  p->trapframe->sgp = p->trapframe->gp;
    80001d20:	78bc                	ld	a5,112(s1)
    80001d22:	7f98                	ld	a4,56(a5)
    80001d24:	14e7bc23          	sd	a4,344(a5)
                  p->trapframe->stp = p->trapframe->tp;
    80001d28:	78bc                	ld	a5,112(s1)
    80001d2a:	63b8                	ld	a4,64(a5)
    80001d2c:	16e7b023          	sd	a4,352(a5)
                  p->trapframe->st0 = p->trapframe->t0;
    80001d30:	78bc                	ld	a5,112(s1)
    80001d32:	67b8                	ld	a4,72(a5)
    80001d34:	16e7b423          	sd	a4,360(a5)
                  p->trapframe->st1 = p->trapframe->t1;
    80001d38:	78bc                	ld	a5,112(s1)
    80001d3a:	6bb8                	ld	a4,80(a5)
    80001d3c:	16e7b823          	sd	a4,368(a5)
                  p->trapframe->st2 = p->trapframe->t2;
    80001d40:	78bc                	ld	a5,112(s1)
    80001d42:	6fb8                	ld	a4,88(a5)
    80001d44:	16e7bc23          	sd	a4,376(a5)
                  p->trapframe->ss0 = p->trapframe->s0;
    80001d48:	78bc                	ld	a5,112(s1)
    80001d4a:	73b8                	ld	a4,96(a5)
    80001d4c:	18e7b023          	sd	a4,384(a5)
                  p->trapframe->ss1 = p->trapframe->s1;
    80001d50:	78bc                	ld	a5,112(s1)
    80001d52:	77b8                	ld	a4,104(a5)
    80001d54:	18e7b423          	sd	a4,392(a5)
                  p->trapframe->sa0 = p->trapframe->a0;
    80001d58:	78bc                	ld	a5,112(s1)
    80001d5a:	7bb8                	ld	a4,112(a5)
    80001d5c:	18e7b823          	sd	a4,400(a5)
                  p->trapframe->sa1 = p->trapframe->a1;
    80001d60:	78bc                	ld	a5,112(s1)
    80001d62:	7fb8                	ld	a4,120(a5)
    80001d64:	18e7bc23          	sd	a4,408(a5)
                  p->trapframe->sa2 = p->trapframe->a2;
    80001d68:	78bc                	ld	a5,112(s1)
    80001d6a:	63d8                	ld	a4,128(a5)
    80001d6c:	1ae7b023          	sd	a4,416(a5)
                  p->trapframe->sa3 = p->trapframe->a3;
    80001d70:	78bc                	ld	a5,112(s1)
    80001d72:	67d8                	ld	a4,136(a5)
    80001d74:	1ae7b423          	sd	a4,424(a5)
                  p->trapframe->sa4 = p->trapframe->a4;
    80001d78:	78bc                	ld	a5,112(s1)
    80001d7a:	6bd8                	ld	a4,144(a5)
    80001d7c:	1ae7b823          	sd	a4,432(a5)
                  p->trapframe->sa5 = p->trapframe->a5;
    80001d80:	78bc                	ld	a5,112(s1)
    80001d82:	6fd8                	ld	a4,152(a5)
    80001d84:	1ae7bc23          	sd	a4,440(a5)
                  p->trapframe->sa6 = p->trapframe->a6;
    80001d88:	78bc                	ld	a5,112(s1)
    80001d8a:	73d8                	ld	a4,160(a5)
    80001d8c:	1ce7b023          	sd	a4,448(a5)
                  p->trapframe->sa7 = p->trapframe->a7;
    80001d90:	78bc                	ld	a5,112(s1)
    80001d92:	77d8                	ld	a4,168(a5)
    80001d94:	1ce7b423          	sd	a4,456(a5)
                  p->trapframe->ss2 = p->trapframe->s2;
    80001d98:	78bc                	ld	a5,112(s1)
    80001d9a:	7bd8                	ld	a4,176(a5)
    80001d9c:	1ce7b823          	sd	a4,464(a5)
                  p->trapframe->ss3 = p->trapframe->s3;
    80001da0:	78bc                	ld	a5,112(s1)
    80001da2:	7fd8                	ld	a4,184(a5)
    80001da4:	1ce7bc23          	sd	a4,472(a5)
                  p->trapframe->ss4 = p->trapframe->s4;
    80001da8:	78bc                	ld	a5,112(s1)
    80001daa:	63f8                	ld	a4,192(a5)
    80001dac:	1ee7b023          	sd	a4,480(a5)
                  p->trapframe->ss5 = p->trapframe->s5;
    80001db0:	78bc                	ld	a5,112(s1)
    80001db2:	67f8                	ld	a4,200(a5)
    80001db4:	1ee7b423          	sd	a4,488(a5)
                  p->trapframe->ss6 = p->trapframe->s6;
    80001db8:	78bc                	ld	a5,112(s1)
    80001dba:	6bf8                	ld	a4,208(a5)
    80001dbc:	1ee7b823          	sd	a4,496(a5)
                  p->trapframe->ss7 = p->trapframe->s7;
    80001dc0:	78bc                	ld	a5,112(s1)
    80001dc2:	6ff8                	ld	a4,216(a5)
    80001dc4:	1ee7bc23          	sd	a4,504(a5)
                  p->trapframe->ss8 = p->trapframe->s8;
    80001dc8:	78bc                	ld	a5,112(s1)
    80001dca:	73f8                	ld	a4,224(a5)
    80001dcc:	20e7b023          	sd	a4,512(a5)
                  p->trapframe->ss9 = p->trapframe->s9;
    80001dd0:	78bc                	ld	a5,112(s1)
    80001dd2:	77f8                	ld	a4,232(a5)
    80001dd4:	20e7b423          	sd	a4,520(a5)
                  p->trapframe->ss10 = p->trapframe->s10;
    80001dd8:	78bc                	ld	a5,112(s1)
    80001dda:	7bf8                	ld	a4,240(a5)
    80001ddc:	20e7b823          	sd	a4,528(a5)
                  p->trapframe->ss11 = p->trapframe->s11;
    80001de0:	78bc                	ld	a5,112(s1)
    80001de2:	7ff8                	ld	a4,248(a5)
    80001de4:	20e7bc23          	sd	a4,536(a5)
                  p->trapframe->st3 = p->trapframe->t3;
    80001de8:	78bc                	ld	a5,112(s1)
    80001dea:	1007b703          	ld	a4,256(a5)
    80001dee:	22e7b023          	sd	a4,544(a5)
                  p->trapframe->st4 = p->trapframe->t4;
    80001df2:	78bc                	ld	a5,112(s1)
    80001df4:	1087b703          	ld	a4,264(a5)
    80001df8:	22e7b423          	sd	a4,552(a5)
                  p->trapframe->st5 = p->trapframe->t5;
    80001dfc:	78bc                	ld	a5,112(s1)
    80001dfe:	1107b703          	ld	a4,272(a5)
    80001e02:	22e7b823          	sd	a4,560(a5)
                  p->trapframe->st6 = p->trapframe->t6;
    80001e06:	78bc                	ld	a5,112(s1)
    80001e08:	1187b703          	ld	a4,280(a5)
    80001e0c:	22e7bc23          	sd	a4,568(a5)
                  p->trapframe->epc = p->handler;
    80001e10:	78bc                	ld	a5,112(s1)
    80001e12:	70b8                	ld	a4,96(s1)
    80001e14:	ef98                	sd	a4,24(a5)
  if(p->killed)
    80001e16:	549c                	lw	a5,40(s1)
    80001e18:	cfb1                	beqz	a5,80001e74 <usertrap+0x234>
    exit(-1);
    80001e1a:	557d                	li	a0,-1
    80001e1c:	00000097          	auipc	ra,0x0
    80001e20:	952080e7          	jalr	-1710(ra) # 8000176e <exit>
  if(which_dev == 2)
    80001e24:	a881                	j	80001e74 <usertrap+0x234>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e26:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e2a:	5890                	lw	a2,48(s1)
    80001e2c:	00006517          	auipc	a0,0x6
    80001e30:	48c50513          	addi	a0,a0,1164 # 800082b8 <states.1754+0x78>
    80001e34:	00004097          	auipc	ra,0x4
    80001e38:	03e080e7          	jalr	62(ra) # 80005e72 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e3c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e40:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e44:	00006517          	auipc	a0,0x6
    80001e48:	4a450513          	addi	a0,a0,1188 # 800082e8 <states.1754+0xa8>
    80001e4c:	00004097          	auipc	ra,0x4
    80001e50:	026080e7          	jalr	38(ra) # 80005e72 <printf>
    p->killed = 1;
    80001e54:	4785                	li	a5,1
    80001e56:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001e58:	557d                	li	a0,-1
    80001e5a:	00000097          	auipc	ra,0x0
    80001e5e:	914080e7          	jalr	-1772(ra) # 8000176e <exit>
  if(which_dev == 2)
    80001e62:	b591                	j	80001ca6 <usertrap+0x66>
    exit(-1);
    80001e64:	557d                	li	a0,-1
    80001e66:	00000097          	auipc	ra,0x0
    80001e6a:	908080e7          	jalr	-1784(ra) # 8000176e <exit>
  if(which_dev == 2)
    80001e6e:	4789                	li	a5,2
    80001e70:	e2f91be3          	bne	s2,a5,80001ca6 <usertrap+0x66>
    yield();
    80001e74:	fffff097          	auipc	ra,0xfffff
    80001e78:	662080e7          	jalr	1634(ra) # 800014d6 <yield>
    80001e7c:	b52d                	j	80001ca6 <usertrap+0x66>

0000000080001e7e <kerneltrap>:
{
    80001e7e:	7179                	addi	sp,sp,-48
    80001e80:	f406                	sd	ra,40(sp)
    80001e82:	f022                	sd	s0,32(sp)
    80001e84:	ec26                	sd	s1,24(sp)
    80001e86:	e84a                	sd	s2,16(sp)
    80001e88:	e44e                	sd	s3,8(sp)
    80001e8a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e8c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e90:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e94:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e98:	1004f793          	andi	a5,s1,256
    80001e9c:	cb85                	beqz	a5,80001ecc <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e9e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ea2:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ea4:	ef85                	bnez	a5,80001edc <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001ea6:	00000097          	auipc	ra,0x0
    80001eaa:	cf8080e7          	jalr	-776(ra) # 80001b9e <devintr>
    80001eae:	cd1d                	beqz	a0,80001eec <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001eb0:	4789                	li	a5,2
    80001eb2:	06f50a63          	beq	a0,a5,80001f26 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001eb6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eba:	10049073          	csrw	sstatus,s1
}
    80001ebe:	70a2                	ld	ra,40(sp)
    80001ec0:	7402                	ld	s0,32(sp)
    80001ec2:	64e2                	ld	s1,24(sp)
    80001ec4:	6942                	ld	s2,16(sp)
    80001ec6:	69a2                	ld	s3,8(sp)
    80001ec8:	6145                	addi	sp,sp,48
    80001eca:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ecc:	00006517          	auipc	a0,0x6
    80001ed0:	43c50513          	addi	a0,a0,1084 # 80008308 <states.1754+0xc8>
    80001ed4:	00004097          	auipc	ra,0x4
    80001ed8:	f54080e7          	jalr	-172(ra) # 80005e28 <panic>
    panic("kerneltrap: interrupts enabled");
    80001edc:	00006517          	auipc	a0,0x6
    80001ee0:	45450513          	addi	a0,a0,1108 # 80008330 <states.1754+0xf0>
    80001ee4:	00004097          	auipc	ra,0x4
    80001ee8:	f44080e7          	jalr	-188(ra) # 80005e28 <panic>
    printf("scause %p\n", scause);
    80001eec:	85ce                	mv	a1,s3
    80001eee:	00006517          	auipc	a0,0x6
    80001ef2:	46250513          	addi	a0,a0,1122 # 80008350 <states.1754+0x110>
    80001ef6:	00004097          	auipc	ra,0x4
    80001efa:	f7c080e7          	jalr	-132(ra) # 80005e72 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001efe:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f02:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f06:	00006517          	auipc	a0,0x6
    80001f0a:	45a50513          	addi	a0,a0,1114 # 80008360 <states.1754+0x120>
    80001f0e:	00004097          	auipc	ra,0x4
    80001f12:	f64080e7          	jalr	-156(ra) # 80005e72 <printf>
    panic("kerneltrap");
    80001f16:	00006517          	auipc	a0,0x6
    80001f1a:	46250513          	addi	a0,a0,1122 # 80008378 <states.1754+0x138>
    80001f1e:	00004097          	auipc	ra,0x4
    80001f22:	f0a080e7          	jalr	-246(ra) # 80005e28 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f26:	fffff097          	auipc	ra,0xfffff
    80001f2a:	f22080e7          	jalr	-222(ra) # 80000e48 <myproc>
    80001f2e:	d541                	beqz	a0,80001eb6 <kerneltrap+0x38>
    80001f30:	fffff097          	auipc	ra,0xfffff
    80001f34:	f18080e7          	jalr	-232(ra) # 80000e48 <myproc>
    80001f38:	4d18                	lw	a4,24(a0)
    80001f3a:	4791                	li	a5,4
    80001f3c:	f6f71de3          	bne	a4,a5,80001eb6 <kerneltrap+0x38>
    yield();
    80001f40:	fffff097          	auipc	ra,0xfffff
    80001f44:	596080e7          	jalr	1430(ra) # 800014d6 <yield>
    80001f48:	b7bd                	j	80001eb6 <kerneltrap+0x38>

0000000080001f4a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f4a:	1101                	addi	sp,sp,-32
    80001f4c:	ec06                	sd	ra,24(sp)
    80001f4e:	e822                	sd	s0,16(sp)
    80001f50:	e426                	sd	s1,8(sp)
    80001f52:	1000                	addi	s0,sp,32
    80001f54:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f56:	fffff097          	auipc	ra,0xfffff
    80001f5a:	ef2080e7          	jalr	-270(ra) # 80000e48 <myproc>
  switch (n) {
    80001f5e:	4795                	li	a5,5
    80001f60:	0497e163          	bltu	a5,s1,80001fa2 <argraw+0x58>
    80001f64:	048a                	slli	s1,s1,0x2
    80001f66:	00006717          	auipc	a4,0x6
    80001f6a:	44a70713          	addi	a4,a4,1098 # 800083b0 <states.1754+0x170>
    80001f6e:	94ba                	add	s1,s1,a4
    80001f70:	409c                	lw	a5,0(s1)
    80001f72:	97ba                	add	a5,a5,a4
    80001f74:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f76:	793c                	ld	a5,112(a0)
    80001f78:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f7a:	60e2                	ld	ra,24(sp)
    80001f7c:	6442                	ld	s0,16(sp)
    80001f7e:	64a2                	ld	s1,8(sp)
    80001f80:	6105                	addi	sp,sp,32
    80001f82:	8082                	ret
    return p->trapframe->a1;
    80001f84:	793c                	ld	a5,112(a0)
    80001f86:	7fa8                	ld	a0,120(a5)
    80001f88:	bfcd                	j	80001f7a <argraw+0x30>
    return p->trapframe->a2;
    80001f8a:	793c                	ld	a5,112(a0)
    80001f8c:	63c8                	ld	a0,128(a5)
    80001f8e:	b7f5                	j	80001f7a <argraw+0x30>
    return p->trapframe->a3;
    80001f90:	793c                	ld	a5,112(a0)
    80001f92:	67c8                	ld	a0,136(a5)
    80001f94:	b7dd                	j	80001f7a <argraw+0x30>
    return p->trapframe->a4;
    80001f96:	793c                	ld	a5,112(a0)
    80001f98:	6bc8                	ld	a0,144(a5)
    80001f9a:	b7c5                	j	80001f7a <argraw+0x30>
    return p->trapframe->a5;
    80001f9c:	793c                	ld	a5,112(a0)
    80001f9e:	6fc8                	ld	a0,152(a5)
    80001fa0:	bfe9                	j	80001f7a <argraw+0x30>
  panic("argraw");
    80001fa2:	00006517          	auipc	a0,0x6
    80001fa6:	3e650513          	addi	a0,a0,998 # 80008388 <states.1754+0x148>
    80001faa:	00004097          	auipc	ra,0x4
    80001fae:	e7e080e7          	jalr	-386(ra) # 80005e28 <panic>

0000000080001fb2 <fetchaddr>:
{
    80001fb2:	1101                	addi	sp,sp,-32
    80001fb4:	ec06                	sd	ra,24(sp)
    80001fb6:	e822                	sd	s0,16(sp)
    80001fb8:	e426                	sd	s1,8(sp)
    80001fba:	e04a                	sd	s2,0(sp)
    80001fbc:	1000                	addi	s0,sp,32
    80001fbe:	84aa                	mv	s1,a0
    80001fc0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fc2:	fffff097          	auipc	ra,0xfffff
    80001fc6:	e86080e7          	jalr	-378(ra) # 80000e48 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001fca:	653c                	ld	a5,72(a0)
    80001fcc:	02f4f863          	bgeu	s1,a5,80001ffc <fetchaddr+0x4a>
    80001fd0:	00848713          	addi	a4,s1,8
    80001fd4:	02e7e663          	bltu	a5,a4,80002000 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fd8:	46a1                	li	a3,8
    80001fda:	8626                	mv	a2,s1
    80001fdc:	85ca                	mv	a1,s2
    80001fde:	6928                	ld	a0,80(a0)
    80001fe0:	fffff097          	auipc	ra,0xfffff
    80001fe4:	bb6080e7          	jalr	-1098(ra) # 80000b96 <copyin>
    80001fe8:	00a03533          	snez	a0,a0
    80001fec:	40a00533          	neg	a0,a0
}
    80001ff0:	60e2                	ld	ra,24(sp)
    80001ff2:	6442                	ld	s0,16(sp)
    80001ff4:	64a2                	ld	s1,8(sp)
    80001ff6:	6902                	ld	s2,0(sp)
    80001ff8:	6105                	addi	sp,sp,32
    80001ffa:	8082                	ret
    return -1;
    80001ffc:	557d                	li	a0,-1
    80001ffe:	bfcd                	j	80001ff0 <fetchaddr+0x3e>
    80002000:	557d                	li	a0,-1
    80002002:	b7fd                	j	80001ff0 <fetchaddr+0x3e>

0000000080002004 <fetchstr>:
{
    80002004:	7179                	addi	sp,sp,-48
    80002006:	f406                	sd	ra,40(sp)
    80002008:	f022                	sd	s0,32(sp)
    8000200a:	ec26                	sd	s1,24(sp)
    8000200c:	e84a                	sd	s2,16(sp)
    8000200e:	e44e                	sd	s3,8(sp)
    80002010:	1800                	addi	s0,sp,48
    80002012:	892a                	mv	s2,a0
    80002014:	84ae                	mv	s1,a1
    80002016:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002018:	fffff097          	auipc	ra,0xfffff
    8000201c:	e30080e7          	jalr	-464(ra) # 80000e48 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002020:	86ce                	mv	a3,s3
    80002022:	864a                	mv	a2,s2
    80002024:	85a6                	mv	a1,s1
    80002026:	6928                	ld	a0,80(a0)
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	bfa080e7          	jalr	-1030(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80002030:	00054763          	bltz	a0,8000203e <fetchstr+0x3a>
  return strlen(buf);
    80002034:	8526                	mv	a0,s1
    80002036:	ffffe097          	auipc	ra,0xffffe
    8000203a:	2c6080e7          	jalr	710(ra) # 800002fc <strlen>
}
    8000203e:	70a2                	ld	ra,40(sp)
    80002040:	7402                	ld	s0,32(sp)
    80002042:	64e2                	ld	s1,24(sp)
    80002044:	6942                	ld	s2,16(sp)
    80002046:	69a2                	ld	s3,8(sp)
    80002048:	6145                	addi	sp,sp,48
    8000204a:	8082                	ret

000000008000204c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000204c:	1101                	addi	sp,sp,-32
    8000204e:	ec06                	sd	ra,24(sp)
    80002050:	e822                	sd	s0,16(sp)
    80002052:	e426                	sd	s1,8(sp)
    80002054:	1000                	addi	s0,sp,32
    80002056:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002058:	00000097          	auipc	ra,0x0
    8000205c:	ef2080e7          	jalr	-270(ra) # 80001f4a <argraw>
    80002060:	c088                	sw	a0,0(s1)
  return 0;
}
    80002062:	4501                	li	a0,0
    80002064:	60e2                	ld	ra,24(sp)
    80002066:	6442                	ld	s0,16(sp)
    80002068:	64a2                	ld	s1,8(sp)
    8000206a:	6105                	addi	sp,sp,32
    8000206c:	8082                	ret

000000008000206e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000206e:	1101                	addi	sp,sp,-32
    80002070:	ec06                	sd	ra,24(sp)
    80002072:	e822                	sd	s0,16(sp)
    80002074:	e426                	sd	s1,8(sp)
    80002076:	1000                	addi	s0,sp,32
    80002078:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000207a:	00000097          	auipc	ra,0x0
    8000207e:	ed0080e7          	jalr	-304(ra) # 80001f4a <argraw>
    80002082:	e088                	sd	a0,0(s1)
  return 0;
}
    80002084:	4501                	li	a0,0
    80002086:	60e2                	ld	ra,24(sp)
    80002088:	6442                	ld	s0,16(sp)
    8000208a:	64a2                	ld	s1,8(sp)
    8000208c:	6105                	addi	sp,sp,32
    8000208e:	8082                	ret

0000000080002090 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002090:	1101                	addi	sp,sp,-32
    80002092:	ec06                	sd	ra,24(sp)
    80002094:	e822                	sd	s0,16(sp)
    80002096:	e426                	sd	s1,8(sp)
    80002098:	e04a                	sd	s2,0(sp)
    8000209a:	1000                	addi	s0,sp,32
    8000209c:	84ae                	mv	s1,a1
    8000209e:	8932                	mv	s2,a2
  *ip = argraw(n);
    800020a0:	00000097          	auipc	ra,0x0
    800020a4:	eaa080e7          	jalr	-342(ra) # 80001f4a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800020a8:	864a                	mv	a2,s2
    800020aa:	85a6                	mv	a1,s1
    800020ac:	00000097          	auipc	ra,0x0
    800020b0:	f58080e7          	jalr	-168(ra) # 80002004 <fetchstr>
}
    800020b4:	60e2                	ld	ra,24(sp)
    800020b6:	6442                	ld	s0,16(sp)
    800020b8:	64a2                	ld	s1,8(sp)
    800020ba:	6902                	ld	s2,0(sp)
    800020bc:	6105                	addi	sp,sp,32
    800020be:	8082                	ret

00000000800020c0 <syscall>:

};

void
syscall(void)
{
    800020c0:	1101                	addi	sp,sp,-32
    800020c2:	ec06                	sd	ra,24(sp)
    800020c4:	e822                	sd	s0,16(sp)
    800020c6:	e426                	sd	s1,8(sp)
    800020c8:	e04a                	sd	s2,0(sp)
    800020ca:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020cc:	fffff097          	auipc	ra,0xfffff
    800020d0:	d7c080e7          	jalr	-644(ra) # 80000e48 <myproc>
    800020d4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020d6:	07053903          	ld	s2,112(a0)
    800020da:	0a893783          	ld	a5,168(s2)
    800020de:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020e2:	37fd                	addiw	a5,a5,-1
    800020e4:	4759                	li	a4,22
    800020e6:	00f76f63          	bltu	a4,a5,80002104 <syscall+0x44>
    800020ea:	00369713          	slli	a4,a3,0x3
    800020ee:	00006797          	auipc	a5,0x6
    800020f2:	2da78793          	addi	a5,a5,730 # 800083c8 <syscalls>
    800020f6:	97ba                	add	a5,a5,a4
    800020f8:	639c                	ld	a5,0(a5)
    800020fa:	c789                	beqz	a5,80002104 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800020fc:	9782                	jalr	a5
    800020fe:	06a93823          	sd	a0,112(s2)
    80002102:	a839                	j	80002120 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002104:	17048613          	addi	a2,s1,368
    80002108:	588c                	lw	a1,48(s1)
    8000210a:	00006517          	auipc	a0,0x6
    8000210e:	28650513          	addi	a0,a0,646 # 80008390 <states.1754+0x150>
    80002112:	00004097          	auipc	ra,0x4
    80002116:	d60080e7          	jalr	-672(ra) # 80005e72 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000211a:	78bc                	ld	a5,112(s1)
    8000211c:	577d                	li	a4,-1
    8000211e:	fbb8                	sd	a4,112(a5)
  }
}
    80002120:	60e2                	ld	ra,24(sp)
    80002122:	6442                	ld	s0,16(sp)
    80002124:	64a2                	ld	s1,8(sp)
    80002126:	6902                	ld	s2,0(sp)
    80002128:	6105                	addi	sp,sp,32
    8000212a:	8082                	ret

000000008000212c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000212c:	1101                	addi	sp,sp,-32
    8000212e:	ec06                	sd	ra,24(sp)
    80002130:	e822                	sd	s0,16(sp)
    80002132:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002134:	fec40593          	addi	a1,s0,-20
    80002138:	4501                	li	a0,0
    8000213a:	00000097          	auipc	ra,0x0
    8000213e:	f12080e7          	jalr	-238(ra) # 8000204c <argint>
    return -1;
    80002142:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002144:	00054963          	bltz	a0,80002156 <sys_exit+0x2a>
  exit(n);
    80002148:	fec42503          	lw	a0,-20(s0)
    8000214c:	fffff097          	auipc	ra,0xfffff
    80002150:	622080e7          	jalr	1570(ra) # 8000176e <exit>
  return 0;  // not reached
    80002154:	4781                	li	a5,0
}
    80002156:	853e                	mv	a0,a5
    80002158:	60e2                	ld	ra,24(sp)
    8000215a:	6442                	ld	s0,16(sp)
    8000215c:	6105                	addi	sp,sp,32
    8000215e:	8082                	ret

0000000080002160 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002160:	1141                	addi	sp,sp,-16
    80002162:	e406                	sd	ra,8(sp)
    80002164:	e022                	sd	s0,0(sp)
    80002166:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002168:	fffff097          	auipc	ra,0xfffff
    8000216c:	ce0080e7          	jalr	-800(ra) # 80000e48 <myproc>
}
    80002170:	5908                	lw	a0,48(a0)
    80002172:	60a2                	ld	ra,8(sp)
    80002174:	6402                	ld	s0,0(sp)
    80002176:	0141                	addi	sp,sp,16
    80002178:	8082                	ret

000000008000217a <sys_fork>:

uint64
sys_fork(void)
{
    8000217a:	1141                	addi	sp,sp,-16
    8000217c:	e406                	sd	ra,8(sp)
    8000217e:	e022                	sd	s0,0(sp)
    80002180:	0800                	addi	s0,sp,16
  return fork();
    80002182:	fffff097          	auipc	ra,0xfffff
    80002186:	0a2080e7          	jalr	162(ra) # 80001224 <fork>
}
    8000218a:	60a2                	ld	ra,8(sp)
    8000218c:	6402                	ld	s0,0(sp)
    8000218e:	0141                	addi	sp,sp,16
    80002190:	8082                	ret

0000000080002192 <sys_wait>:

uint64
sys_wait(void)
{
    80002192:	1101                	addi	sp,sp,-32
    80002194:	ec06                	sd	ra,24(sp)
    80002196:	e822                	sd	s0,16(sp)
    80002198:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000219a:	fe840593          	addi	a1,s0,-24
    8000219e:	4501                	li	a0,0
    800021a0:	00000097          	auipc	ra,0x0
    800021a4:	ece080e7          	jalr	-306(ra) # 8000206e <argaddr>
    800021a8:	87aa                	mv	a5,a0
    return -1;
    800021aa:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800021ac:	0007c863          	bltz	a5,800021bc <sys_wait+0x2a>
  return wait(p);
    800021b0:	fe843503          	ld	a0,-24(s0)
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	3c2080e7          	jalr	962(ra) # 80001576 <wait>
}
    800021bc:	60e2                	ld	ra,24(sp)
    800021be:	6442                	ld	s0,16(sp)
    800021c0:	6105                	addi	sp,sp,32
    800021c2:	8082                	ret

00000000800021c4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021c4:	7179                	addi	sp,sp,-48
    800021c6:	f406                	sd	ra,40(sp)
    800021c8:	f022                	sd	s0,32(sp)
    800021ca:	ec26                	sd	s1,24(sp)
    800021cc:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800021ce:	fdc40593          	addi	a1,s0,-36
    800021d2:	4501                	li	a0,0
    800021d4:	00000097          	auipc	ra,0x0
    800021d8:	e78080e7          	jalr	-392(ra) # 8000204c <argint>
    800021dc:	87aa                	mv	a5,a0
    return -1;
    800021de:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800021e0:	0207c063          	bltz	a5,80002200 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800021e4:	fffff097          	auipc	ra,0xfffff
    800021e8:	c64080e7          	jalr	-924(ra) # 80000e48 <myproc>
    800021ec:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800021ee:	fdc42503          	lw	a0,-36(s0)
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	fbe080e7          	jalr	-66(ra) # 800011b0 <growproc>
    800021fa:	00054863          	bltz	a0,8000220a <sys_sbrk+0x46>
    return -1;
  return addr;
    800021fe:	8526                	mv	a0,s1
}
    80002200:	70a2                	ld	ra,40(sp)
    80002202:	7402                	ld	s0,32(sp)
    80002204:	64e2                	ld	s1,24(sp)
    80002206:	6145                	addi	sp,sp,48
    80002208:	8082                	ret
    return -1;
    8000220a:	557d                	li	a0,-1
    8000220c:	bfd5                	j	80002200 <sys_sbrk+0x3c>

000000008000220e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000220e:	7139                	addi	sp,sp,-64
    80002210:	fc06                	sd	ra,56(sp)
    80002212:	f822                	sd	s0,48(sp)
    80002214:	f426                	sd	s1,40(sp)
    80002216:	f04a                	sd	s2,32(sp)
    80002218:	ec4e                	sd	s3,24(sp)
    8000221a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000221c:	fcc40593          	addi	a1,s0,-52
    80002220:	4501                	li	a0,0
    80002222:	00000097          	auipc	ra,0x0
    80002226:	e2a080e7          	jalr	-470(ra) # 8000204c <argint>
    return -1;
    8000222a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000222c:	06054963          	bltz	a0,8000229e <sys_sleep+0x90>
  acquire(&tickslock);
    80002230:	0000d517          	auipc	a0,0xd
    80002234:	25050513          	addi	a0,a0,592 # 8000f480 <tickslock>
    80002238:	00004097          	auipc	ra,0x4
    8000223c:	196080e7          	jalr	406(ra) # 800063ce <acquire>
  ticks0 = ticks;
    80002240:	00007917          	auipc	s2,0x7
    80002244:	dd892903          	lw	s2,-552(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002248:	fcc42783          	lw	a5,-52(s0)
    8000224c:	cf85                	beqz	a5,80002284 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000224e:	0000d997          	auipc	s3,0xd
    80002252:	23298993          	addi	s3,s3,562 # 8000f480 <tickslock>
    80002256:	00007497          	auipc	s1,0x7
    8000225a:	dc248493          	addi	s1,s1,-574 # 80009018 <ticks>
    if(myproc()->killed){
    8000225e:	fffff097          	auipc	ra,0xfffff
    80002262:	bea080e7          	jalr	-1046(ra) # 80000e48 <myproc>
    80002266:	551c                	lw	a5,40(a0)
    80002268:	e3b9                	bnez	a5,800022ae <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    8000226a:	85ce                	mv	a1,s3
    8000226c:	8526                	mv	a0,s1
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	2a4080e7          	jalr	676(ra) # 80001512 <sleep>
  while(ticks - ticks0 < n){
    80002276:	409c                	lw	a5,0(s1)
    80002278:	412787bb          	subw	a5,a5,s2
    8000227c:	fcc42703          	lw	a4,-52(s0)
    80002280:	fce7efe3          	bltu	a5,a4,8000225e <sys_sleep+0x50>
  }
  release(&tickslock);
    80002284:	0000d517          	auipc	a0,0xd
    80002288:	1fc50513          	addi	a0,a0,508 # 8000f480 <tickslock>
    8000228c:	00004097          	auipc	ra,0x4
    80002290:	1f6080e7          	jalr	502(ra) # 80006482 <release>
  backtrace();
    80002294:	00004097          	auipc	ra,0x4
    80002298:	df6080e7          	jalr	-522(ra) # 8000608a <backtrace>
  return 0;
    8000229c:	4781                	li	a5,0
}
    8000229e:	853e                	mv	a0,a5
    800022a0:	70e2                	ld	ra,56(sp)
    800022a2:	7442                	ld	s0,48(sp)
    800022a4:	74a2                	ld	s1,40(sp)
    800022a6:	7902                	ld	s2,32(sp)
    800022a8:	69e2                	ld	s3,24(sp)
    800022aa:	6121                	addi	sp,sp,64
    800022ac:	8082                	ret
      release(&tickslock);
    800022ae:	0000d517          	auipc	a0,0xd
    800022b2:	1d250513          	addi	a0,a0,466 # 8000f480 <tickslock>
    800022b6:	00004097          	auipc	ra,0x4
    800022ba:	1cc080e7          	jalr	460(ra) # 80006482 <release>
      return -1;
    800022be:	57fd                	li	a5,-1
    800022c0:	bff9                	j	8000229e <sys_sleep+0x90>

00000000800022c2 <sys_kill>:

uint64
sys_kill(void)
{
    800022c2:	1101                	addi	sp,sp,-32
    800022c4:	ec06                	sd	ra,24(sp)
    800022c6:	e822                	sd	s0,16(sp)
    800022c8:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800022ca:	fec40593          	addi	a1,s0,-20
    800022ce:	4501                	li	a0,0
    800022d0:	00000097          	auipc	ra,0x0
    800022d4:	d7c080e7          	jalr	-644(ra) # 8000204c <argint>
    800022d8:	87aa                	mv	a5,a0
    return -1;
    800022da:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800022dc:	0007c863          	bltz	a5,800022ec <sys_kill+0x2a>
  return kill(pid);
    800022e0:	fec42503          	lw	a0,-20(s0)
    800022e4:	fffff097          	auipc	ra,0xfffff
    800022e8:	560080e7          	jalr	1376(ra) # 80001844 <kill>
}
    800022ec:	60e2                	ld	ra,24(sp)
    800022ee:	6442                	ld	s0,16(sp)
    800022f0:	6105                	addi	sp,sp,32
    800022f2:	8082                	ret

00000000800022f4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022f4:	1101                	addi	sp,sp,-32
    800022f6:	ec06                	sd	ra,24(sp)
    800022f8:	e822                	sd	s0,16(sp)
    800022fa:	e426                	sd	s1,8(sp)
    800022fc:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022fe:	0000d517          	auipc	a0,0xd
    80002302:	18250513          	addi	a0,a0,386 # 8000f480 <tickslock>
    80002306:	00004097          	auipc	ra,0x4
    8000230a:	0c8080e7          	jalr	200(ra) # 800063ce <acquire>
  xticks = ticks;
    8000230e:	00007497          	auipc	s1,0x7
    80002312:	d0a4a483          	lw	s1,-758(s1) # 80009018 <ticks>
  release(&tickslock);
    80002316:	0000d517          	auipc	a0,0xd
    8000231a:	16a50513          	addi	a0,a0,362 # 8000f480 <tickslock>
    8000231e:	00004097          	auipc	ra,0x4
    80002322:	164080e7          	jalr	356(ra) # 80006482 <release>
  return xticks;
}
    80002326:	02049513          	slli	a0,s1,0x20
    8000232a:	9101                	srli	a0,a0,0x20
    8000232c:	60e2                	ld	ra,24(sp)
    8000232e:	6442                	ld	s0,16(sp)
    80002330:	64a2                	ld	s1,8(sp)
    80002332:	6105                	addi	sp,sp,32
    80002334:	8082                	ret

0000000080002336 <sys_sigalarm>:

uint64
sys_sigalarm(void){
    80002336:	1101                	addi	sp,sp,-32
    80002338:	ec06                	sd	ra,24(sp)
    8000233a:	e822                	sd	s0,16(sp)
    8000233c:	1000                	addi	s0,sp,32
    printf("sigalarm\n");
    8000233e:	00006517          	auipc	a0,0x6
    80002342:	14a50513          	addi	a0,a0,330 # 80008488 <syscalls+0xc0>
    80002346:	00004097          	auipc	ra,0x4
    8000234a:	b2c080e7          	jalr	-1236(ra) # 80005e72 <printf>
    int ticks;
    uint64 handler;
    if(argint(0,&ticks) < 0 || argaddr(1,&handler) < 0)
    8000234e:	fec40593          	addi	a1,s0,-20
    80002352:	4501                	li	a0,0
    80002354:	00000097          	auipc	ra,0x0
    80002358:	cf8080e7          	jalr	-776(ra) # 8000204c <argint>
        return -1;
    8000235c:	57fd                	li	a5,-1
    if(argint(0,&ticks) < 0 || argaddr(1,&handler) < 0)
    8000235e:	04054163          	bltz	a0,800023a0 <sys_sigalarm+0x6a>
    80002362:	fe040593          	addi	a1,s0,-32
    80002366:	4505                	li	a0,1
    80002368:	00000097          	auipc	ra,0x0
    8000236c:	d06080e7          	jalr	-762(ra) # 8000206e <argaddr>
        return -1;
    80002370:	57fd                	li	a5,-1
    if(argint(0,&ticks) < 0 || argaddr(1,&handler) < 0)
    80002372:	02054763          	bltz	a0,800023a0 <sys_sigalarm+0x6a>
    myproc()->ticks = ticks;
    80002376:	fffff097          	auipc	ra,0xfffff
    8000237a:	ad2080e7          	jalr	-1326(ra) # 80000e48 <myproc>
    8000237e:	fec42783          	lw	a5,-20(s0)
    80002382:	cd3c                	sw	a5,88(a0)
    myproc()->currticks = 0;
    80002384:	fffff097          	auipc	ra,0xfffff
    80002388:	ac4080e7          	jalr	-1340(ra) # 80000e48 <myproc>
    8000238c:	04052e23          	sw	zero,92(a0)
    myproc()->handler = handler;
    80002390:	fffff097          	auipc	ra,0xfffff
    80002394:	ab8080e7          	jalr	-1352(ra) # 80000e48 <myproc>
    80002398:	fe043783          	ld	a5,-32(s0)
    8000239c:	f13c                	sd	a5,96(a0)
    return 0;
    8000239e:	4781                	li	a5,0
}
    800023a0:	853e                	mv	a0,a5
    800023a2:	60e2                	ld	ra,24(sp)
    800023a4:	6442                	ld	s0,16(sp)
    800023a6:	6105                	addi	sp,sp,32
    800023a8:	8082                	ret

00000000800023aa <sys_sigreturn>:
uint64
sys_sigreturn(void){
    800023aa:	1141                	addi	sp,sp,-16
    800023ac:	e406                	sd	ra,8(sp)
    800023ae:	e022                	sd	s0,0(sp)
    800023b0:	0800                	addi	s0,sp,16
    printf("sigreturn\n");
    800023b2:	00006517          	auipc	a0,0x6
    800023b6:	0e650513          	addi	a0,a0,230 # 80008498 <syscalls+0xd0>
    800023ba:	00004097          	auipc	ra,0x4
    800023be:	ab8080e7          	jalr	-1352(ra) # 80005e72 <printf>
    struct proc* p = myproc();
    800023c2:	fffff097          	auipc	ra,0xfffff
    800023c6:	a86080e7          	jalr	-1402(ra) # 80000e48 <myproc>
    p->handlerlock = 1;
    800023ca:	4785                	li	a5,1
    800023cc:	d53c                	sw	a5,104(a0)
    p->trapframe->epc = p->trapframe->sepc;
    800023ce:	793c                	ld	a5,112(a0)
    800023d0:	1407b703          	ld	a4,320(a5)
    800023d4:	ef98                	sd	a4,24(a5)
    p->trapframe->ra = p->trapframe->sra;
    800023d6:	793c                	ld	a5,112(a0)
    800023d8:	1487b703          	ld	a4,328(a5)
    800023dc:	f798                	sd	a4,40(a5)
    p->trapframe->sp = p->trapframe->ssp;
    800023de:	793c                	ld	a5,112(a0)
    800023e0:	1507b703          	ld	a4,336(a5)
    800023e4:	fb98                	sd	a4,48(a5)
    p->trapframe->gp = p->trapframe->sgp;
    800023e6:	793c                	ld	a5,112(a0)
    800023e8:	1587b703          	ld	a4,344(a5)
    800023ec:	ff98                	sd	a4,56(a5)
    p->trapframe->tp = p->trapframe->stp;
    800023ee:	793c                	ld	a5,112(a0)
    800023f0:	1607b703          	ld	a4,352(a5)
    800023f4:	e3b8                	sd	a4,64(a5)
    p->trapframe->t0 = p->trapframe->st0;
    800023f6:	793c                	ld	a5,112(a0)
    800023f8:	1687b703          	ld	a4,360(a5)
    800023fc:	e7b8                	sd	a4,72(a5)
    p->trapframe->t1 = p->trapframe->st1;
    800023fe:	793c                	ld	a5,112(a0)
    80002400:	1707b703          	ld	a4,368(a5)
    80002404:	ebb8                	sd	a4,80(a5)
    p->trapframe->t2 = p->trapframe->st2;
    80002406:	793c                	ld	a5,112(a0)
    80002408:	1787b703          	ld	a4,376(a5)
    8000240c:	efb8                	sd	a4,88(a5)
    p->trapframe->s0 = p->trapframe->ss0;
    8000240e:	793c                	ld	a5,112(a0)
    80002410:	1807b703          	ld	a4,384(a5)
    80002414:	f3b8                	sd	a4,96(a5)
    p->trapframe->s1 = p->trapframe->ss1;
    80002416:	793c                	ld	a5,112(a0)
    80002418:	1887b703          	ld	a4,392(a5)
    8000241c:	f7b8                	sd	a4,104(a5)
    p->trapframe->a0 = p->trapframe->sa0;
    8000241e:	793c                	ld	a5,112(a0)
    80002420:	1907b703          	ld	a4,400(a5)
    80002424:	fbb8                	sd	a4,112(a5)
    p->trapframe->a1 = p->trapframe->sa1;
    80002426:	793c                	ld	a5,112(a0)
    80002428:	1987b703          	ld	a4,408(a5)
    8000242c:	ffb8                	sd	a4,120(a5)
    p->trapframe->a2 = p->trapframe->sa2;
    8000242e:	793c                	ld	a5,112(a0)
    80002430:	1a07b703          	ld	a4,416(a5)
    80002434:	e3d8                	sd	a4,128(a5)
    p->trapframe->a3 = p->trapframe->sa3;
    80002436:	793c                	ld	a5,112(a0)
    80002438:	1a87b703          	ld	a4,424(a5)
    8000243c:	e7d8                	sd	a4,136(a5)
    p->trapframe->a4 = p->trapframe->sa4;
    8000243e:	793c                	ld	a5,112(a0)
    80002440:	1b07b703          	ld	a4,432(a5)
    80002444:	ebd8                	sd	a4,144(a5)
    p->trapframe->a5 = p->trapframe->sa5;
    80002446:	793c                	ld	a5,112(a0)
    80002448:	1b87b703          	ld	a4,440(a5)
    8000244c:	efd8                	sd	a4,152(a5)
    p->trapframe->a6 = p->trapframe->sa6;
    8000244e:	793c                	ld	a5,112(a0)
    80002450:	1c07b703          	ld	a4,448(a5)
    80002454:	f3d8                	sd	a4,160(a5)
    p->trapframe->a7 = p->trapframe->sa7;
    80002456:	793c                	ld	a5,112(a0)
    80002458:	1c87b703          	ld	a4,456(a5)
    8000245c:	f7d8                	sd	a4,168(a5)
    p->trapframe->s2 = p->trapframe->ss2;
    8000245e:	793c                	ld	a5,112(a0)
    80002460:	1d07b703          	ld	a4,464(a5)
    80002464:	fbd8                	sd	a4,176(a5)
    p->trapframe->s3 = p->trapframe->ss3;
    80002466:	793c                	ld	a5,112(a0)
    80002468:	1d87b703          	ld	a4,472(a5)
    8000246c:	ffd8                	sd	a4,184(a5)
    p->trapframe->s4 = p->trapframe->ss4;
    8000246e:	793c                	ld	a5,112(a0)
    80002470:	1e07b703          	ld	a4,480(a5)
    80002474:	e3f8                	sd	a4,192(a5)
    p->trapframe->s5 = p->trapframe->ss5;
    80002476:	793c                	ld	a5,112(a0)
    80002478:	1e87b703          	ld	a4,488(a5)
    8000247c:	e7f8                	sd	a4,200(a5)
    p->trapframe->s6 = p->trapframe->ss6;
    8000247e:	793c                	ld	a5,112(a0)
    80002480:	1f07b703          	ld	a4,496(a5)
    80002484:	ebf8                	sd	a4,208(a5)
    p->trapframe->s7 = p->trapframe->ss7;
    80002486:	793c                	ld	a5,112(a0)
    80002488:	1f87b703          	ld	a4,504(a5)
    8000248c:	eff8                	sd	a4,216(a5)
    p->trapframe->s8 = p->trapframe->ss8;
    8000248e:	793c                	ld	a5,112(a0)
    80002490:	2007b703          	ld	a4,512(a5)
    80002494:	f3f8                	sd	a4,224(a5)
    p->trapframe->s9 = p->trapframe->ss9;
    80002496:	793c                	ld	a5,112(a0)
    80002498:	2087b703          	ld	a4,520(a5)
    8000249c:	f7f8                	sd	a4,232(a5)
    p->trapframe->s10 = p->trapframe->ss10;
    8000249e:	793c                	ld	a5,112(a0)
    800024a0:	2107b703          	ld	a4,528(a5)
    800024a4:	fbf8                	sd	a4,240(a5)
    p->trapframe->s11 = p->trapframe->ss11;
    800024a6:	793c                	ld	a5,112(a0)
    800024a8:	2187b703          	ld	a4,536(a5)
    800024ac:	fff8                	sd	a4,248(a5)
    p->trapframe->t3 = p->trapframe->st3;
    800024ae:	793c                	ld	a5,112(a0)
    800024b0:	2207b703          	ld	a4,544(a5)
    800024b4:	10e7b023          	sd	a4,256(a5)
    p->trapframe->t4 = p->trapframe->st4;
    800024b8:	793c                	ld	a5,112(a0)
    800024ba:	2287b703          	ld	a4,552(a5)
    800024be:	10e7b423          	sd	a4,264(a5)
    p->trapframe->t5 = p->trapframe->st5;
    800024c2:	793c                	ld	a5,112(a0)
    800024c4:	2307b703          	ld	a4,560(a5)
    800024c8:	10e7b823          	sd	a4,272(a5)
    p->trapframe->t6 = p->trapframe->st6;
    800024cc:	793c                	ld	a5,112(a0)
    800024ce:	2387b703          	ld	a4,568(a5)
    800024d2:	10e7bc23          	sd	a4,280(a5)
    return 0;
}
    800024d6:	4501                	li	a0,0
    800024d8:	60a2                	ld	ra,8(sp)
    800024da:	6402                	ld	s0,0(sp)
    800024dc:	0141                	addi	sp,sp,16
    800024de:	8082                	ret

00000000800024e0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024e0:	7179                	addi	sp,sp,-48
    800024e2:	f406                	sd	ra,40(sp)
    800024e4:	f022                	sd	s0,32(sp)
    800024e6:	ec26                	sd	s1,24(sp)
    800024e8:	e84a                	sd	s2,16(sp)
    800024ea:	e44e                	sd	s3,8(sp)
    800024ec:	e052                	sd	s4,0(sp)
    800024ee:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024f0:	00006597          	auipc	a1,0x6
    800024f4:	fb858593          	addi	a1,a1,-72 # 800084a8 <syscalls+0xe0>
    800024f8:	0000d517          	auipc	a0,0xd
    800024fc:	fa050513          	addi	a0,a0,-96 # 8000f498 <bcache>
    80002500:	00004097          	auipc	ra,0x4
    80002504:	e3e080e7          	jalr	-450(ra) # 8000633e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002508:	00015797          	auipc	a5,0x15
    8000250c:	f9078793          	addi	a5,a5,-112 # 80017498 <bcache+0x8000>
    80002510:	00015717          	auipc	a4,0x15
    80002514:	1f070713          	addi	a4,a4,496 # 80017700 <bcache+0x8268>
    80002518:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000251c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002520:	0000d497          	auipc	s1,0xd
    80002524:	f9048493          	addi	s1,s1,-112 # 8000f4b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002528:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000252a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000252c:	00006a17          	auipc	s4,0x6
    80002530:	f84a0a13          	addi	s4,s4,-124 # 800084b0 <syscalls+0xe8>
    b->next = bcache.head.next;
    80002534:	2b893783          	ld	a5,696(s2)
    80002538:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000253a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000253e:	85d2                	mv	a1,s4
    80002540:	01048513          	addi	a0,s1,16
    80002544:	00001097          	auipc	ra,0x1
    80002548:	4bc080e7          	jalr	1212(ra) # 80003a00 <initsleeplock>
    bcache.head.next->prev = b;
    8000254c:	2b893783          	ld	a5,696(s2)
    80002550:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002552:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002556:	45848493          	addi	s1,s1,1112
    8000255a:	fd349de3          	bne	s1,s3,80002534 <binit+0x54>
  }
}
    8000255e:	70a2                	ld	ra,40(sp)
    80002560:	7402                	ld	s0,32(sp)
    80002562:	64e2                	ld	s1,24(sp)
    80002564:	6942                	ld	s2,16(sp)
    80002566:	69a2                	ld	s3,8(sp)
    80002568:	6a02                	ld	s4,0(sp)
    8000256a:	6145                	addi	sp,sp,48
    8000256c:	8082                	ret

000000008000256e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000256e:	7179                	addi	sp,sp,-48
    80002570:	f406                	sd	ra,40(sp)
    80002572:	f022                	sd	s0,32(sp)
    80002574:	ec26                	sd	s1,24(sp)
    80002576:	e84a                	sd	s2,16(sp)
    80002578:	e44e                	sd	s3,8(sp)
    8000257a:	1800                	addi	s0,sp,48
    8000257c:	89aa                	mv	s3,a0
    8000257e:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002580:	0000d517          	auipc	a0,0xd
    80002584:	f1850513          	addi	a0,a0,-232 # 8000f498 <bcache>
    80002588:	00004097          	auipc	ra,0x4
    8000258c:	e46080e7          	jalr	-442(ra) # 800063ce <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002590:	00015497          	auipc	s1,0x15
    80002594:	1c04b483          	ld	s1,448(s1) # 80017750 <bcache+0x82b8>
    80002598:	00015797          	auipc	a5,0x15
    8000259c:	16878793          	addi	a5,a5,360 # 80017700 <bcache+0x8268>
    800025a0:	02f48f63          	beq	s1,a5,800025de <bread+0x70>
    800025a4:	873e                	mv	a4,a5
    800025a6:	a021                	j	800025ae <bread+0x40>
    800025a8:	68a4                	ld	s1,80(s1)
    800025aa:	02e48a63          	beq	s1,a4,800025de <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800025ae:	449c                	lw	a5,8(s1)
    800025b0:	ff379ce3          	bne	a5,s3,800025a8 <bread+0x3a>
    800025b4:	44dc                	lw	a5,12(s1)
    800025b6:	ff2799e3          	bne	a5,s2,800025a8 <bread+0x3a>
      b->refcnt++;
    800025ba:	40bc                	lw	a5,64(s1)
    800025bc:	2785                	addiw	a5,a5,1
    800025be:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025c0:	0000d517          	auipc	a0,0xd
    800025c4:	ed850513          	addi	a0,a0,-296 # 8000f498 <bcache>
    800025c8:	00004097          	auipc	ra,0x4
    800025cc:	eba080e7          	jalr	-326(ra) # 80006482 <release>
      acquiresleep(&b->lock);
    800025d0:	01048513          	addi	a0,s1,16
    800025d4:	00001097          	auipc	ra,0x1
    800025d8:	466080e7          	jalr	1126(ra) # 80003a3a <acquiresleep>
      return b;
    800025dc:	a8b9                	j	8000263a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025de:	00015497          	auipc	s1,0x15
    800025e2:	16a4b483          	ld	s1,362(s1) # 80017748 <bcache+0x82b0>
    800025e6:	00015797          	auipc	a5,0x15
    800025ea:	11a78793          	addi	a5,a5,282 # 80017700 <bcache+0x8268>
    800025ee:	00f48863          	beq	s1,a5,800025fe <bread+0x90>
    800025f2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025f4:	40bc                	lw	a5,64(s1)
    800025f6:	cf81                	beqz	a5,8000260e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025f8:	64a4                	ld	s1,72(s1)
    800025fa:	fee49de3          	bne	s1,a4,800025f4 <bread+0x86>
  panic("bget: no buffers");
    800025fe:	00006517          	auipc	a0,0x6
    80002602:	eba50513          	addi	a0,a0,-326 # 800084b8 <syscalls+0xf0>
    80002606:	00004097          	auipc	ra,0x4
    8000260a:	822080e7          	jalr	-2014(ra) # 80005e28 <panic>
      b->dev = dev;
    8000260e:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002612:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002616:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000261a:	4785                	li	a5,1
    8000261c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000261e:	0000d517          	auipc	a0,0xd
    80002622:	e7a50513          	addi	a0,a0,-390 # 8000f498 <bcache>
    80002626:	00004097          	auipc	ra,0x4
    8000262a:	e5c080e7          	jalr	-420(ra) # 80006482 <release>
      acquiresleep(&b->lock);
    8000262e:	01048513          	addi	a0,s1,16
    80002632:	00001097          	auipc	ra,0x1
    80002636:	408080e7          	jalr	1032(ra) # 80003a3a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000263a:	409c                	lw	a5,0(s1)
    8000263c:	cb89                	beqz	a5,8000264e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000263e:	8526                	mv	a0,s1
    80002640:	70a2                	ld	ra,40(sp)
    80002642:	7402                	ld	s0,32(sp)
    80002644:	64e2                	ld	s1,24(sp)
    80002646:	6942                	ld	s2,16(sp)
    80002648:	69a2                	ld	s3,8(sp)
    8000264a:	6145                	addi	sp,sp,48
    8000264c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000264e:	4581                	li	a1,0
    80002650:	8526                	mv	a0,s1
    80002652:	00003097          	auipc	ra,0x3
    80002656:	f14080e7          	jalr	-236(ra) # 80005566 <virtio_disk_rw>
    b->valid = 1;
    8000265a:	4785                	li	a5,1
    8000265c:	c09c                	sw	a5,0(s1)
  return b;
    8000265e:	b7c5                	j	8000263e <bread+0xd0>

0000000080002660 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002660:	1101                	addi	sp,sp,-32
    80002662:	ec06                	sd	ra,24(sp)
    80002664:	e822                	sd	s0,16(sp)
    80002666:	e426                	sd	s1,8(sp)
    80002668:	1000                	addi	s0,sp,32
    8000266a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000266c:	0541                	addi	a0,a0,16
    8000266e:	00001097          	auipc	ra,0x1
    80002672:	466080e7          	jalr	1126(ra) # 80003ad4 <holdingsleep>
    80002676:	cd01                	beqz	a0,8000268e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002678:	4585                	li	a1,1
    8000267a:	8526                	mv	a0,s1
    8000267c:	00003097          	auipc	ra,0x3
    80002680:	eea080e7          	jalr	-278(ra) # 80005566 <virtio_disk_rw>
}
    80002684:	60e2                	ld	ra,24(sp)
    80002686:	6442                	ld	s0,16(sp)
    80002688:	64a2                	ld	s1,8(sp)
    8000268a:	6105                	addi	sp,sp,32
    8000268c:	8082                	ret
    panic("bwrite");
    8000268e:	00006517          	auipc	a0,0x6
    80002692:	e4250513          	addi	a0,a0,-446 # 800084d0 <syscalls+0x108>
    80002696:	00003097          	auipc	ra,0x3
    8000269a:	792080e7          	jalr	1938(ra) # 80005e28 <panic>

000000008000269e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000269e:	1101                	addi	sp,sp,-32
    800026a0:	ec06                	sd	ra,24(sp)
    800026a2:	e822                	sd	s0,16(sp)
    800026a4:	e426                	sd	s1,8(sp)
    800026a6:	e04a                	sd	s2,0(sp)
    800026a8:	1000                	addi	s0,sp,32
    800026aa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026ac:	01050913          	addi	s2,a0,16
    800026b0:	854a                	mv	a0,s2
    800026b2:	00001097          	auipc	ra,0x1
    800026b6:	422080e7          	jalr	1058(ra) # 80003ad4 <holdingsleep>
    800026ba:	c92d                	beqz	a0,8000272c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800026bc:	854a                	mv	a0,s2
    800026be:	00001097          	auipc	ra,0x1
    800026c2:	3d2080e7          	jalr	978(ra) # 80003a90 <releasesleep>

  acquire(&bcache.lock);
    800026c6:	0000d517          	auipc	a0,0xd
    800026ca:	dd250513          	addi	a0,a0,-558 # 8000f498 <bcache>
    800026ce:	00004097          	auipc	ra,0x4
    800026d2:	d00080e7          	jalr	-768(ra) # 800063ce <acquire>
  b->refcnt--;
    800026d6:	40bc                	lw	a5,64(s1)
    800026d8:	37fd                	addiw	a5,a5,-1
    800026da:	0007871b          	sext.w	a4,a5
    800026de:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026e0:	eb05                	bnez	a4,80002710 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026e2:	68bc                	ld	a5,80(s1)
    800026e4:	64b8                	ld	a4,72(s1)
    800026e6:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800026e8:	64bc                	ld	a5,72(s1)
    800026ea:	68b8                	ld	a4,80(s1)
    800026ec:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026ee:	00015797          	auipc	a5,0x15
    800026f2:	daa78793          	addi	a5,a5,-598 # 80017498 <bcache+0x8000>
    800026f6:	2b87b703          	ld	a4,696(a5)
    800026fa:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026fc:	00015717          	auipc	a4,0x15
    80002700:	00470713          	addi	a4,a4,4 # 80017700 <bcache+0x8268>
    80002704:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002706:	2b87b703          	ld	a4,696(a5)
    8000270a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000270c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002710:	0000d517          	auipc	a0,0xd
    80002714:	d8850513          	addi	a0,a0,-632 # 8000f498 <bcache>
    80002718:	00004097          	auipc	ra,0x4
    8000271c:	d6a080e7          	jalr	-662(ra) # 80006482 <release>
}
    80002720:	60e2                	ld	ra,24(sp)
    80002722:	6442                	ld	s0,16(sp)
    80002724:	64a2                	ld	s1,8(sp)
    80002726:	6902                	ld	s2,0(sp)
    80002728:	6105                	addi	sp,sp,32
    8000272a:	8082                	ret
    panic("brelse");
    8000272c:	00006517          	auipc	a0,0x6
    80002730:	dac50513          	addi	a0,a0,-596 # 800084d8 <syscalls+0x110>
    80002734:	00003097          	auipc	ra,0x3
    80002738:	6f4080e7          	jalr	1780(ra) # 80005e28 <panic>

000000008000273c <bpin>:

void
bpin(struct buf *b) {
    8000273c:	1101                	addi	sp,sp,-32
    8000273e:	ec06                	sd	ra,24(sp)
    80002740:	e822                	sd	s0,16(sp)
    80002742:	e426                	sd	s1,8(sp)
    80002744:	1000                	addi	s0,sp,32
    80002746:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002748:	0000d517          	auipc	a0,0xd
    8000274c:	d5050513          	addi	a0,a0,-688 # 8000f498 <bcache>
    80002750:	00004097          	auipc	ra,0x4
    80002754:	c7e080e7          	jalr	-898(ra) # 800063ce <acquire>
  b->refcnt++;
    80002758:	40bc                	lw	a5,64(s1)
    8000275a:	2785                	addiw	a5,a5,1
    8000275c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000275e:	0000d517          	auipc	a0,0xd
    80002762:	d3a50513          	addi	a0,a0,-710 # 8000f498 <bcache>
    80002766:	00004097          	auipc	ra,0x4
    8000276a:	d1c080e7          	jalr	-740(ra) # 80006482 <release>
}
    8000276e:	60e2                	ld	ra,24(sp)
    80002770:	6442                	ld	s0,16(sp)
    80002772:	64a2                	ld	s1,8(sp)
    80002774:	6105                	addi	sp,sp,32
    80002776:	8082                	ret

0000000080002778 <bunpin>:

void
bunpin(struct buf *b) {
    80002778:	1101                	addi	sp,sp,-32
    8000277a:	ec06                	sd	ra,24(sp)
    8000277c:	e822                	sd	s0,16(sp)
    8000277e:	e426                	sd	s1,8(sp)
    80002780:	1000                	addi	s0,sp,32
    80002782:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002784:	0000d517          	auipc	a0,0xd
    80002788:	d1450513          	addi	a0,a0,-748 # 8000f498 <bcache>
    8000278c:	00004097          	auipc	ra,0x4
    80002790:	c42080e7          	jalr	-958(ra) # 800063ce <acquire>
  b->refcnt--;
    80002794:	40bc                	lw	a5,64(s1)
    80002796:	37fd                	addiw	a5,a5,-1
    80002798:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000279a:	0000d517          	auipc	a0,0xd
    8000279e:	cfe50513          	addi	a0,a0,-770 # 8000f498 <bcache>
    800027a2:	00004097          	auipc	ra,0x4
    800027a6:	ce0080e7          	jalr	-800(ra) # 80006482 <release>
}
    800027aa:	60e2                	ld	ra,24(sp)
    800027ac:	6442                	ld	s0,16(sp)
    800027ae:	64a2                	ld	s1,8(sp)
    800027b0:	6105                	addi	sp,sp,32
    800027b2:	8082                	ret

00000000800027b4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027b4:	1101                	addi	sp,sp,-32
    800027b6:	ec06                	sd	ra,24(sp)
    800027b8:	e822                	sd	s0,16(sp)
    800027ba:	e426                	sd	s1,8(sp)
    800027bc:	e04a                	sd	s2,0(sp)
    800027be:	1000                	addi	s0,sp,32
    800027c0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027c2:	00d5d59b          	srliw	a1,a1,0xd
    800027c6:	00015797          	auipc	a5,0x15
    800027ca:	3ae7a783          	lw	a5,942(a5) # 80017b74 <sb+0x1c>
    800027ce:	9dbd                	addw	a1,a1,a5
    800027d0:	00000097          	auipc	ra,0x0
    800027d4:	d9e080e7          	jalr	-610(ra) # 8000256e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027d8:	0074f713          	andi	a4,s1,7
    800027dc:	4785                	li	a5,1
    800027de:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027e2:	14ce                	slli	s1,s1,0x33
    800027e4:	90d9                	srli	s1,s1,0x36
    800027e6:	00950733          	add	a4,a0,s1
    800027ea:	05874703          	lbu	a4,88(a4)
    800027ee:	00e7f6b3          	and	a3,a5,a4
    800027f2:	c69d                	beqz	a3,80002820 <bfree+0x6c>
    800027f4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027f6:	94aa                	add	s1,s1,a0
    800027f8:	fff7c793          	not	a5,a5
    800027fc:	8ff9                	and	a5,a5,a4
    800027fe:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002802:	00001097          	auipc	ra,0x1
    80002806:	118080e7          	jalr	280(ra) # 8000391a <log_write>
  brelse(bp);
    8000280a:	854a                	mv	a0,s2
    8000280c:	00000097          	auipc	ra,0x0
    80002810:	e92080e7          	jalr	-366(ra) # 8000269e <brelse>
}
    80002814:	60e2                	ld	ra,24(sp)
    80002816:	6442                	ld	s0,16(sp)
    80002818:	64a2                	ld	s1,8(sp)
    8000281a:	6902                	ld	s2,0(sp)
    8000281c:	6105                	addi	sp,sp,32
    8000281e:	8082                	ret
    panic("freeing free block");
    80002820:	00006517          	auipc	a0,0x6
    80002824:	cc050513          	addi	a0,a0,-832 # 800084e0 <syscalls+0x118>
    80002828:	00003097          	auipc	ra,0x3
    8000282c:	600080e7          	jalr	1536(ra) # 80005e28 <panic>

0000000080002830 <balloc>:
{
    80002830:	711d                	addi	sp,sp,-96
    80002832:	ec86                	sd	ra,88(sp)
    80002834:	e8a2                	sd	s0,80(sp)
    80002836:	e4a6                	sd	s1,72(sp)
    80002838:	e0ca                	sd	s2,64(sp)
    8000283a:	fc4e                	sd	s3,56(sp)
    8000283c:	f852                	sd	s4,48(sp)
    8000283e:	f456                	sd	s5,40(sp)
    80002840:	f05a                	sd	s6,32(sp)
    80002842:	ec5e                	sd	s7,24(sp)
    80002844:	e862                	sd	s8,16(sp)
    80002846:	e466                	sd	s9,8(sp)
    80002848:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000284a:	00015797          	auipc	a5,0x15
    8000284e:	3127a783          	lw	a5,786(a5) # 80017b5c <sb+0x4>
    80002852:	cbd1                	beqz	a5,800028e6 <balloc+0xb6>
    80002854:	8baa                	mv	s7,a0
    80002856:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002858:	00015b17          	auipc	s6,0x15
    8000285c:	300b0b13          	addi	s6,s6,768 # 80017b58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002860:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002862:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002864:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002866:	6c89                	lui	s9,0x2
    80002868:	a831                	j	80002884 <balloc+0x54>
    brelse(bp);
    8000286a:	854a                	mv	a0,s2
    8000286c:	00000097          	auipc	ra,0x0
    80002870:	e32080e7          	jalr	-462(ra) # 8000269e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002874:	015c87bb          	addw	a5,s9,s5
    80002878:	00078a9b          	sext.w	s5,a5
    8000287c:	004b2703          	lw	a4,4(s6)
    80002880:	06eaf363          	bgeu	s5,a4,800028e6 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002884:	41fad79b          	sraiw	a5,s5,0x1f
    80002888:	0137d79b          	srliw	a5,a5,0x13
    8000288c:	015787bb          	addw	a5,a5,s5
    80002890:	40d7d79b          	sraiw	a5,a5,0xd
    80002894:	01cb2583          	lw	a1,28(s6)
    80002898:	9dbd                	addw	a1,a1,a5
    8000289a:	855e                	mv	a0,s7
    8000289c:	00000097          	auipc	ra,0x0
    800028a0:	cd2080e7          	jalr	-814(ra) # 8000256e <bread>
    800028a4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028a6:	004b2503          	lw	a0,4(s6)
    800028aa:	000a849b          	sext.w	s1,s5
    800028ae:	8662                	mv	a2,s8
    800028b0:	faa4fde3          	bgeu	s1,a0,8000286a <balloc+0x3a>
      m = 1 << (bi % 8);
    800028b4:	41f6579b          	sraiw	a5,a2,0x1f
    800028b8:	01d7d69b          	srliw	a3,a5,0x1d
    800028bc:	00c6873b          	addw	a4,a3,a2
    800028c0:	00777793          	andi	a5,a4,7
    800028c4:	9f95                	subw	a5,a5,a3
    800028c6:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028ca:	4037571b          	sraiw	a4,a4,0x3
    800028ce:	00e906b3          	add	a3,s2,a4
    800028d2:	0586c683          	lbu	a3,88(a3)
    800028d6:	00d7f5b3          	and	a1,a5,a3
    800028da:	cd91                	beqz	a1,800028f6 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028dc:	2605                	addiw	a2,a2,1
    800028de:	2485                	addiw	s1,s1,1
    800028e0:	fd4618e3          	bne	a2,s4,800028b0 <balloc+0x80>
    800028e4:	b759                	j	8000286a <balloc+0x3a>
  panic("balloc: out of blocks");
    800028e6:	00006517          	auipc	a0,0x6
    800028ea:	c1250513          	addi	a0,a0,-1006 # 800084f8 <syscalls+0x130>
    800028ee:	00003097          	auipc	ra,0x3
    800028f2:	53a080e7          	jalr	1338(ra) # 80005e28 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028f6:	974a                	add	a4,a4,s2
    800028f8:	8fd5                	or	a5,a5,a3
    800028fa:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800028fe:	854a                	mv	a0,s2
    80002900:	00001097          	auipc	ra,0x1
    80002904:	01a080e7          	jalr	26(ra) # 8000391a <log_write>
        brelse(bp);
    80002908:	854a                	mv	a0,s2
    8000290a:	00000097          	auipc	ra,0x0
    8000290e:	d94080e7          	jalr	-620(ra) # 8000269e <brelse>
  bp = bread(dev, bno);
    80002912:	85a6                	mv	a1,s1
    80002914:	855e                	mv	a0,s7
    80002916:	00000097          	auipc	ra,0x0
    8000291a:	c58080e7          	jalr	-936(ra) # 8000256e <bread>
    8000291e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002920:	40000613          	li	a2,1024
    80002924:	4581                	li	a1,0
    80002926:	05850513          	addi	a0,a0,88
    8000292a:	ffffe097          	auipc	ra,0xffffe
    8000292e:	84e080e7          	jalr	-1970(ra) # 80000178 <memset>
  log_write(bp);
    80002932:	854a                	mv	a0,s2
    80002934:	00001097          	auipc	ra,0x1
    80002938:	fe6080e7          	jalr	-26(ra) # 8000391a <log_write>
  brelse(bp);
    8000293c:	854a                	mv	a0,s2
    8000293e:	00000097          	auipc	ra,0x0
    80002942:	d60080e7          	jalr	-672(ra) # 8000269e <brelse>
}
    80002946:	8526                	mv	a0,s1
    80002948:	60e6                	ld	ra,88(sp)
    8000294a:	6446                	ld	s0,80(sp)
    8000294c:	64a6                	ld	s1,72(sp)
    8000294e:	6906                	ld	s2,64(sp)
    80002950:	79e2                	ld	s3,56(sp)
    80002952:	7a42                	ld	s4,48(sp)
    80002954:	7aa2                	ld	s5,40(sp)
    80002956:	7b02                	ld	s6,32(sp)
    80002958:	6be2                	ld	s7,24(sp)
    8000295a:	6c42                	ld	s8,16(sp)
    8000295c:	6ca2                	ld	s9,8(sp)
    8000295e:	6125                	addi	sp,sp,96
    80002960:	8082                	ret

0000000080002962 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002962:	7179                	addi	sp,sp,-48
    80002964:	f406                	sd	ra,40(sp)
    80002966:	f022                	sd	s0,32(sp)
    80002968:	ec26                	sd	s1,24(sp)
    8000296a:	e84a                	sd	s2,16(sp)
    8000296c:	e44e                	sd	s3,8(sp)
    8000296e:	e052                	sd	s4,0(sp)
    80002970:	1800                	addi	s0,sp,48
    80002972:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002974:	47ad                	li	a5,11
    80002976:	04b7fe63          	bgeu	a5,a1,800029d2 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000297a:	ff45849b          	addiw	s1,a1,-12
    8000297e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002982:	0ff00793          	li	a5,255
    80002986:	0ae7e363          	bltu	a5,a4,80002a2c <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000298a:	08052583          	lw	a1,128(a0)
    8000298e:	c5ad                	beqz	a1,800029f8 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002990:	00092503          	lw	a0,0(s2)
    80002994:	00000097          	auipc	ra,0x0
    80002998:	bda080e7          	jalr	-1062(ra) # 8000256e <bread>
    8000299c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000299e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800029a2:	02049593          	slli	a1,s1,0x20
    800029a6:	9181                	srli	a1,a1,0x20
    800029a8:	058a                	slli	a1,a1,0x2
    800029aa:	00b784b3          	add	s1,a5,a1
    800029ae:	0004a983          	lw	s3,0(s1)
    800029b2:	04098d63          	beqz	s3,80002a0c <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800029b6:	8552                	mv	a0,s4
    800029b8:	00000097          	auipc	ra,0x0
    800029bc:	ce6080e7          	jalr	-794(ra) # 8000269e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029c0:	854e                	mv	a0,s3
    800029c2:	70a2                	ld	ra,40(sp)
    800029c4:	7402                	ld	s0,32(sp)
    800029c6:	64e2                	ld	s1,24(sp)
    800029c8:	6942                	ld	s2,16(sp)
    800029ca:	69a2                	ld	s3,8(sp)
    800029cc:	6a02                	ld	s4,0(sp)
    800029ce:	6145                	addi	sp,sp,48
    800029d0:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800029d2:	02059493          	slli	s1,a1,0x20
    800029d6:	9081                	srli	s1,s1,0x20
    800029d8:	048a                	slli	s1,s1,0x2
    800029da:	94aa                	add	s1,s1,a0
    800029dc:	0504a983          	lw	s3,80(s1)
    800029e0:	fe0990e3          	bnez	s3,800029c0 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800029e4:	4108                	lw	a0,0(a0)
    800029e6:	00000097          	auipc	ra,0x0
    800029ea:	e4a080e7          	jalr	-438(ra) # 80002830 <balloc>
    800029ee:	0005099b          	sext.w	s3,a0
    800029f2:	0534a823          	sw	s3,80(s1)
    800029f6:	b7e9                	j	800029c0 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800029f8:	4108                	lw	a0,0(a0)
    800029fa:	00000097          	auipc	ra,0x0
    800029fe:	e36080e7          	jalr	-458(ra) # 80002830 <balloc>
    80002a02:	0005059b          	sext.w	a1,a0
    80002a06:	08b92023          	sw	a1,128(s2)
    80002a0a:	b759                	j	80002990 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002a0c:	00092503          	lw	a0,0(s2)
    80002a10:	00000097          	auipc	ra,0x0
    80002a14:	e20080e7          	jalr	-480(ra) # 80002830 <balloc>
    80002a18:	0005099b          	sext.w	s3,a0
    80002a1c:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002a20:	8552                	mv	a0,s4
    80002a22:	00001097          	auipc	ra,0x1
    80002a26:	ef8080e7          	jalr	-264(ra) # 8000391a <log_write>
    80002a2a:	b771                	j	800029b6 <bmap+0x54>
  panic("bmap: out of range");
    80002a2c:	00006517          	auipc	a0,0x6
    80002a30:	ae450513          	addi	a0,a0,-1308 # 80008510 <syscalls+0x148>
    80002a34:	00003097          	auipc	ra,0x3
    80002a38:	3f4080e7          	jalr	1012(ra) # 80005e28 <panic>

0000000080002a3c <iget>:
{
    80002a3c:	7179                	addi	sp,sp,-48
    80002a3e:	f406                	sd	ra,40(sp)
    80002a40:	f022                	sd	s0,32(sp)
    80002a42:	ec26                	sd	s1,24(sp)
    80002a44:	e84a                	sd	s2,16(sp)
    80002a46:	e44e                	sd	s3,8(sp)
    80002a48:	e052                	sd	s4,0(sp)
    80002a4a:	1800                	addi	s0,sp,48
    80002a4c:	89aa                	mv	s3,a0
    80002a4e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a50:	00015517          	auipc	a0,0x15
    80002a54:	12850513          	addi	a0,a0,296 # 80017b78 <itable>
    80002a58:	00004097          	auipc	ra,0x4
    80002a5c:	976080e7          	jalr	-1674(ra) # 800063ce <acquire>
  empty = 0;
    80002a60:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a62:	00015497          	auipc	s1,0x15
    80002a66:	12e48493          	addi	s1,s1,302 # 80017b90 <itable+0x18>
    80002a6a:	00017697          	auipc	a3,0x17
    80002a6e:	bb668693          	addi	a3,a3,-1098 # 80019620 <log>
    80002a72:	a039                	j	80002a80 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a74:	02090b63          	beqz	s2,80002aaa <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a78:	08848493          	addi	s1,s1,136
    80002a7c:	02d48a63          	beq	s1,a3,80002ab0 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a80:	449c                	lw	a5,8(s1)
    80002a82:	fef059e3          	blez	a5,80002a74 <iget+0x38>
    80002a86:	4098                	lw	a4,0(s1)
    80002a88:	ff3716e3          	bne	a4,s3,80002a74 <iget+0x38>
    80002a8c:	40d8                	lw	a4,4(s1)
    80002a8e:	ff4713e3          	bne	a4,s4,80002a74 <iget+0x38>
      ip->ref++;
    80002a92:	2785                	addiw	a5,a5,1
    80002a94:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a96:	00015517          	auipc	a0,0x15
    80002a9a:	0e250513          	addi	a0,a0,226 # 80017b78 <itable>
    80002a9e:	00004097          	auipc	ra,0x4
    80002aa2:	9e4080e7          	jalr	-1564(ra) # 80006482 <release>
      return ip;
    80002aa6:	8926                	mv	s2,s1
    80002aa8:	a03d                	j	80002ad6 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002aaa:	f7f9                	bnez	a5,80002a78 <iget+0x3c>
    80002aac:	8926                	mv	s2,s1
    80002aae:	b7e9                	j	80002a78 <iget+0x3c>
  if(empty == 0)
    80002ab0:	02090c63          	beqz	s2,80002ae8 <iget+0xac>
  ip->dev = dev;
    80002ab4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ab8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002abc:	4785                	li	a5,1
    80002abe:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002ac2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002ac6:	00015517          	auipc	a0,0x15
    80002aca:	0b250513          	addi	a0,a0,178 # 80017b78 <itable>
    80002ace:	00004097          	auipc	ra,0x4
    80002ad2:	9b4080e7          	jalr	-1612(ra) # 80006482 <release>
}
    80002ad6:	854a                	mv	a0,s2
    80002ad8:	70a2                	ld	ra,40(sp)
    80002ada:	7402                	ld	s0,32(sp)
    80002adc:	64e2                	ld	s1,24(sp)
    80002ade:	6942                	ld	s2,16(sp)
    80002ae0:	69a2                	ld	s3,8(sp)
    80002ae2:	6a02                	ld	s4,0(sp)
    80002ae4:	6145                	addi	sp,sp,48
    80002ae6:	8082                	ret
    panic("iget: no inodes");
    80002ae8:	00006517          	auipc	a0,0x6
    80002aec:	a4050513          	addi	a0,a0,-1472 # 80008528 <syscalls+0x160>
    80002af0:	00003097          	auipc	ra,0x3
    80002af4:	338080e7          	jalr	824(ra) # 80005e28 <panic>

0000000080002af8 <fsinit>:
fsinit(int dev) {
    80002af8:	7179                	addi	sp,sp,-48
    80002afa:	f406                	sd	ra,40(sp)
    80002afc:	f022                	sd	s0,32(sp)
    80002afe:	ec26                	sd	s1,24(sp)
    80002b00:	e84a                	sd	s2,16(sp)
    80002b02:	e44e                	sd	s3,8(sp)
    80002b04:	1800                	addi	s0,sp,48
    80002b06:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b08:	4585                	li	a1,1
    80002b0a:	00000097          	auipc	ra,0x0
    80002b0e:	a64080e7          	jalr	-1436(ra) # 8000256e <bread>
    80002b12:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b14:	00015997          	auipc	s3,0x15
    80002b18:	04498993          	addi	s3,s3,68 # 80017b58 <sb>
    80002b1c:	02000613          	li	a2,32
    80002b20:	05850593          	addi	a1,a0,88
    80002b24:	854e                	mv	a0,s3
    80002b26:	ffffd097          	auipc	ra,0xffffd
    80002b2a:	6b2080e7          	jalr	1714(ra) # 800001d8 <memmove>
  brelse(bp);
    80002b2e:	8526                	mv	a0,s1
    80002b30:	00000097          	auipc	ra,0x0
    80002b34:	b6e080e7          	jalr	-1170(ra) # 8000269e <brelse>
  if(sb.magic != FSMAGIC)
    80002b38:	0009a703          	lw	a4,0(s3)
    80002b3c:	102037b7          	lui	a5,0x10203
    80002b40:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b44:	02f71263          	bne	a4,a5,80002b68 <fsinit+0x70>
  initlog(dev, &sb);
    80002b48:	00015597          	auipc	a1,0x15
    80002b4c:	01058593          	addi	a1,a1,16 # 80017b58 <sb>
    80002b50:	854a                	mv	a0,s2
    80002b52:	00001097          	auipc	ra,0x1
    80002b56:	b4c080e7          	jalr	-1204(ra) # 8000369e <initlog>
}
    80002b5a:	70a2                	ld	ra,40(sp)
    80002b5c:	7402                	ld	s0,32(sp)
    80002b5e:	64e2                	ld	s1,24(sp)
    80002b60:	6942                	ld	s2,16(sp)
    80002b62:	69a2                	ld	s3,8(sp)
    80002b64:	6145                	addi	sp,sp,48
    80002b66:	8082                	ret
    panic("invalid file system");
    80002b68:	00006517          	auipc	a0,0x6
    80002b6c:	9d050513          	addi	a0,a0,-1584 # 80008538 <syscalls+0x170>
    80002b70:	00003097          	auipc	ra,0x3
    80002b74:	2b8080e7          	jalr	696(ra) # 80005e28 <panic>

0000000080002b78 <iinit>:
{
    80002b78:	7179                	addi	sp,sp,-48
    80002b7a:	f406                	sd	ra,40(sp)
    80002b7c:	f022                	sd	s0,32(sp)
    80002b7e:	ec26                	sd	s1,24(sp)
    80002b80:	e84a                	sd	s2,16(sp)
    80002b82:	e44e                	sd	s3,8(sp)
    80002b84:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b86:	00006597          	auipc	a1,0x6
    80002b8a:	9ca58593          	addi	a1,a1,-1590 # 80008550 <syscalls+0x188>
    80002b8e:	00015517          	auipc	a0,0x15
    80002b92:	fea50513          	addi	a0,a0,-22 # 80017b78 <itable>
    80002b96:	00003097          	auipc	ra,0x3
    80002b9a:	7a8080e7          	jalr	1960(ra) # 8000633e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b9e:	00015497          	auipc	s1,0x15
    80002ba2:	00248493          	addi	s1,s1,2 # 80017ba0 <itable+0x28>
    80002ba6:	00017997          	auipc	s3,0x17
    80002baa:	a8a98993          	addi	s3,s3,-1398 # 80019630 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002bae:	00006917          	auipc	s2,0x6
    80002bb2:	9aa90913          	addi	s2,s2,-1622 # 80008558 <syscalls+0x190>
    80002bb6:	85ca                	mv	a1,s2
    80002bb8:	8526                	mv	a0,s1
    80002bba:	00001097          	auipc	ra,0x1
    80002bbe:	e46080e7          	jalr	-442(ra) # 80003a00 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bc2:	08848493          	addi	s1,s1,136
    80002bc6:	ff3498e3          	bne	s1,s3,80002bb6 <iinit+0x3e>
}
    80002bca:	70a2                	ld	ra,40(sp)
    80002bcc:	7402                	ld	s0,32(sp)
    80002bce:	64e2                	ld	s1,24(sp)
    80002bd0:	6942                	ld	s2,16(sp)
    80002bd2:	69a2                	ld	s3,8(sp)
    80002bd4:	6145                	addi	sp,sp,48
    80002bd6:	8082                	ret

0000000080002bd8 <ialloc>:
{
    80002bd8:	715d                	addi	sp,sp,-80
    80002bda:	e486                	sd	ra,72(sp)
    80002bdc:	e0a2                	sd	s0,64(sp)
    80002bde:	fc26                	sd	s1,56(sp)
    80002be0:	f84a                	sd	s2,48(sp)
    80002be2:	f44e                	sd	s3,40(sp)
    80002be4:	f052                	sd	s4,32(sp)
    80002be6:	ec56                	sd	s5,24(sp)
    80002be8:	e85a                	sd	s6,16(sp)
    80002bea:	e45e                	sd	s7,8(sp)
    80002bec:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bee:	00015717          	auipc	a4,0x15
    80002bf2:	f7672703          	lw	a4,-138(a4) # 80017b64 <sb+0xc>
    80002bf6:	4785                	li	a5,1
    80002bf8:	04e7fa63          	bgeu	a5,a4,80002c4c <ialloc+0x74>
    80002bfc:	8aaa                	mv	s5,a0
    80002bfe:	8bae                	mv	s7,a1
    80002c00:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c02:	00015a17          	auipc	s4,0x15
    80002c06:	f56a0a13          	addi	s4,s4,-170 # 80017b58 <sb>
    80002c0a:	00048b1b          	sext.w	s6,s1
    80002c0e:	0044d593          	srli	a1,s1,0x4
    80002c12:	018a2783          	lw	a5,24(s4)
    80002c16:	9dbd                	addw	a1,a1,a5
    80002c18:	8556                	mv	a0,s5
    80002c1a:	00000097          	auipc	ra,0x0
    80002c1e:	954080e7          	jalr	-1708(ra) # 8000256e <bread>
    80002c22:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c24:	05850993          	addi	s3,a0,88
    80002c28:	00f4f793          	andi	a5,s1,15
    80002c2c:	079a                	slli	a5,a5,0x6
    80002c2e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c30:	00099783          	lh	a5,0(s3)
    80002c34:	c785                	beqz	a5,80002c5c <ialloc+0x84>
    brelse(bp);
    80002c36:	00000097          	auipc	ra,0x0
    80002c3a:	a68080e7          	jalr	-1432(ra) # 8000269e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c3e:	0485                	addi	s1,s1,1
    80002c40:	00ca2703          	lw	a4,12(s4)
    80002c44:	0004879b          	sext.w	a5,s1
    80002c48:	fce7e1e3          	bltu	a5,a4,80002c0a <ialloc+0x32>
  panic("ialloc: no inodes");
    80002c4c:	00006517          	auipc	a0,0x6
    80002c50:	91450513          	addi	a0,a0,-1772 # 80008560 <syscalls+0x198>
    80002c54:	00003097          	auipc	ra,0x3
    80002c58:	1d4080e7          	jalr	468(ra) # 80005e28 <panic>
      memset(dip, 0, sizeof(*dip));
    80002c5c:	04000613          	li	a2,64
    80002c60:	4581                	li	a1,0
    80002c62:	854e                	mv	a0,s3
    80002c64:	ffffd097          	auipc	ra,0xffffd
    80002c68:	514080e7          	jalr	1300(ra) # 80000178 <memset>
      dip->type = type;
    80002c6c:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c70:	854a                	mv	a0,s2
    80002c72:	00001097          	auipc	ra,0x1
    80002c76:	ca8080e7          	jalr	-856(ra) # 8000391a <log_write>
      brelse(bp);
    80002c7a:	854a                	mv	a0,s2
    80002c7c:	00000097          	auipc	ra,0x0
    80002c80:	a22080e7          	jalr	-1502(ra) # 8000269e <brelse>
      return iget(dev, inum);
    80002c84:	85da                	mv	a1,s6
    80002c86:	8556                	mv	a0,s5
    80002c88:	00000097          	auipc	ra,0x0
    80002c8c:	db4080e7          	jalr	-588(ra) # 80002a3c <iget>
}
    80002c90:	60a6                	ld	ra,72(sp)
    80002c92:	6406                	ld	s0,64(sp)
    80002c94:	74e2                	ld	s1,56(sp)
    80002c96:	7942                	ld	s2,48(sp)
    80002c98:	79a2                	ld	s3,40(sp)
    80002c9a:	7a02                	ld	s4,32(sp)
    80002c9c:	6ae2                	ld	s5,24(sp)
    80002c9e:	6b42                	ld	s6,16(sp)
    80002ca0:	6ba2                	ld	s7,8(sp)
    80002ca2:	6161                	addi	sp,sp,80
    80002ca4:	8082                	ret

0000000080002ca6 <iupdate>:
{
    80002ca6:	1101                	addi	sp,sp,-32
    80002ca8:	ec06                	sd	ra,24(sp)
    80002caa:	e822                	sd	s0,16(sp)
    80002cac:	e426                	sd	s1,8(sp)
    80002cae:	e04a                	sd	s2,0(sp)
    80002cb0:	1000                	addi	s0,sp,32
    80002cb2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cb4:	415c                	lw	a5,4(a0)
    80002cb6:	0047d79b          	srliw	a5,a5,0x4
    80002cba:	00015597          	auipc	a1,0x15
    80002cbe:	eb65a583          	lw	a1,-330(a1) # 80017b70 <sb+0x18>
    80002cc2:	9dbd                	addw	a1,a1,a5
    80002cc4:	4108                	lw	a0,0(a0)
    80002cc6:	00000097          	auipc	ra,0x0
    80002cca:	8a8080e7          	jalr	-1880(ra) # 8000256e <bread>
    80002cce:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cd0:	05850793          	addi	a5,a0,88
    80002cd4:	40c8                	lw	a0,4(s1)
    80002cd6:	893d                	andi	a0,a0,15
    80002cd8:	051a                	slli	a0,a0,0x6
    80002cda:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002cdc:	04449703          	lh	a4,68(s1)
    80002ce0:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002ce4:	04649703          	lh	a4,70(s1)
    80002ce8:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002cec:	04849703          	lh	a4,72(s1)
    80002cf0:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002cf4:	04a49703          	lh	a4,74(s1)
    80002cf8:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002cfc:	44f8                	lw	a4,76(s1)
    80002cfe:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d00:	03400613          	li	a2,52
    80002d04:	05048593          	addi	a1,s1,80
    80002d08:	0531                	addi	a0,a0,12
    80002d0a:	ffffd097          	auipc	ra,0xffffd
    80002d0e:	4ce080e7          	jalr	1230(ra) # 800001d8 <memmove>
  log_write(bp);
    80002d12:	854a                	mv	a0,s2
    80002d14:	00001097          	auipc	ra,0x1
    80002d18:	c06080e7          	jalr	-1018(ra) # 8000391a <log_write>
  brelse(bp);
    80002d1c:	854a                	mv	a0,s2
    80002d1e:	00000097          	auipc	ra,0x0
    80002d22:	980080e7          	jalr	-1664(ra) # 8000269e <brelse>
}
    80002d26:	60e2                	ld	ra,24(sp)
    80002d28:	6442                	ld	s0,16(sp)
    80002d2a:	64a2                	ld	s1,8(sp)
    80002d2c:	6902                	ld	s2,0(sp)
    80002d2e:	6105                	addi	sp,sp,32
    80002d30:	8082                	ret

0000000080002d32 <idup>:
{
    80002d32:	1101                	addi	sp,sp,-32
    80002d34:	ec06                	sd	ra,24(sp)
    80002d36:	e822                	sd	s0,16(sp)
    80002d38:	e426                	sd	s1,8(sp)
    80002d3a:	1000                	addi	s0,sp,32
    80002d3c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d3e:	00015517          	auipc	a0,0x15
    80002d42:	e3a50513          	addi	a0,a0,-454 # 80017b78 <itable>
    80002d46:	00003097          	auipc	ra,0x3
    80002d4a:	688080e7          	jalr	1672(ra) # 800063ce <acquire>
  ip->ref++;
    80002d4e:	449c                	lw	a5,8(s1)
    80002d50:	2785                	addiw	a5,a5,1
    80002d52:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d54:	00015517          	auipc	a0,0x15
    80002d58:	e2450513          	addi	a0,a0,-476 # 80017b78 <itable>
    80002d5c:	00003097          	auipc	ra,0x3
    80002d60:	726080e7          	jalr	1830(ra) # 80006482 <release>
}
    80002d64:	8526                	mv	a0,s1
    80002d66:	60e2                	ld	ra,24(sp)
    80002d68:	6442                	ld	s0,16(sp)
    80002d6a:	64a2                	ld	s1,8(sp)
    80002d6c:	6105                	addi	sp,sp,32
    80002d6e:	8082                	ret

0000000080002d70 <ilock>:
{
    80002d70:	1101                	addi	sp,sp,-32
    80002d72:	ec06                	sd	ra,24(sp)
    80002d74:	e822                	sd	s0,16(sp)
    80002d76:	e426                	sd	s1,8(sp)
    80002d78:	e04a                	sd	s2,0(sp)
    80002d7a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d7c:	c115                	beqz	a0,80002da0 <ilock+0x30>
    80002d7e:	84aa                	mv	s1,a0
    80002d80:	451c                	lw	a5,8(a0)
    80002d82:	00f05f63          	blez	a5,80002da0 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d86:	0541                	addi	a0,a0,16
    80002d88:	00001097          	auipc	ra,0x1
    80002d8c:	cb2080e7          	jalr	-846(ra) # 80003a3a <acquiresleep>
  if(ip->valid == 0){
    80002d90:	40bc                	lw	a5,64(s1)
    80002d92:	cf99                	beqz	a5,80002db0 <ilock+0x40>
}
    80002d94:	60e2                	ld	ra,24(sp)
    80002d96:	6442                	ld	s0,16(sp)
    80002d98:	64a2                	ld	s1,8(sp)
    80002d9a:	6902                	ld	s2,0(sp)
    80002d9c:	6105                	addi	sp,sp,32
    80002d9e:	8082                	ret
    panic("ilock");
    80002da0:	00005517          	auipc	a0,0x5
    80002da4:	7d850513          	addi	a0,a0,2008 # 80008578 <syscalls+0x1b0>
    80002da8:	00003097          	auipc	ra,0x3
    80002dac:	080080e7          	jalr	128(ra) # 80005e28 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002db0:	40dc                	lw	a5,4(s1)
    80002db2:	0047d79b          	srliw	a5,a5,0x4
    80002db6:	00015597          	auipc	a1,0x15
    80002dba:	dba5a583          	lw	a1,-582(a1) # 80017b70 <sb+0x18>
    80002dbe:	9dbd                	addw	a1,a1,a5
    80002dc0:	4088                	lw	a0,0(s1)
    80002dc2:	fffff097          	auipc	ra,0xfffff
    80002dc6:	7ac080e7          	jalr	1964(ra) # 8000256e <bread>
    80002dca:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dcc:	05850593          	addi	a1,a0,88
    80002dd0:	40dc                	lw	a5,4(s1)
    80002dd2:	8bbd                	andi	a5,a5,15
    80002dd4:	079a                	slli	a5,a5,0x6
    80002dd6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002dd8:	00059783          	lh	a5,0(a1)
    80002ddc:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002de0:	00259783          	lh	a5,2(a1)
    80002de4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002de8:	00459783          	lh	a5,4(a1)
    80002dec:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002df0:	00659783          	lh	a5,6(a1)
    80002df4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002df8:	459c                	lw	a5,8(a1)
    80002dfa:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002dfc:	03400613          	li	a2,52
    80002e00:	05b1                	addi	a1,a1,12
    80002e02:	05048513          	addi	a0,s1,80
    80002e06:	ffffd097          	auipc	ra,0xffffd
    80002e0a:	3d2080e7          	jalr	978(ra) # 800001d8 <memmove>
    brelse(bp);
    80002e0e:	854a                	mv	a0,s2
    80002e10:	00000097          	auipc	ra,0x0
    80002e14:	88e080e7          	jalr	-1906(ra) # 8000269e <brelse>
    ip->valid = 1;
    80002e18:	4785                	li	a5,1
    80002e1a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e1c:	04449783          	lh	a5,68(s1)
    80002e20:	fbb5                	bnez	a5,80002d94 <ilock+0x24>
      panic("ilock: no type");
    80002e22:	00005517          	auipc	a0,0x5
    80002e26:	75e50513          	addi	a0,a0,1886 # 80008580 <syscalls+0x1b8>
    80002e2a:	00003097          	auipc	ra,0x3
    80002e2e:	ffe080e7          	jalr	-2(ra) # 80005e28 <panic>

0000000080002e32 <iunlock>:
{
    80002e32:	1101                	addi	sp,sp,-32
    80002e34:	ec06                	sd	ra,24(sp)
    80002e36:	e822                	sd	s0,16(sp)
    80002e38:	e426                	sd	s1,8(sp)
    80002e3a:	e04a                	sd	s2,0(sp)
    80002e3c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e3e:	c905                	beqz	a0,80002e6e <iunlock+0x3c>
    80002e40:	84aa                	mv	s1,a0
    80002e42:	01050913          	addi	s2,a0,16
    80002e46:	854a                	mv	a0,s2
    80002e48:	00001097          	auipc	ra,0x1
    80002e4c:	c8c080e7          	jalr	-884(ra) # 80003ad4 <holdingsleep>
    80002e50:	cd19                	beqz	a0,80002e6e <iunlock+0x3c>
    80002e52:	449c                	lw	a5,8(s1)
    80002e54:	00f05d63          	blez	a5,80002e6e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e58:	854a                	mv	a0,s2
    80002e5a:	00001097          	auipc	ra,0x1
    80002e5e:	c36080e7          	jalr	-970(ra) # 80003a90 <releasesleep>
}
    80002e62:	60e2                	ld	ra,24(sp)
    80002e64:	6442                	ld	s0,16(sp)
    80002e66:	64a2                	ld	s1,8(sp)
    80002e68:	6902                	ld	s2,0(sp)
    80002e6a:	6105                	addi	sp,sp,32
    80002e6c:	8082                	ret
    panic("iunlock");
    80002e6e:	00005517          	auipc	a0,0x5
    80002e72:	72250513          	addi	a0,a0,1826 # 80008590 <syscalls+0x1c8>
    80002e76:	00003097          	auipc	ra,0x3
    80002e7a:	fb2080e7          	jalr	-78(ra) # 80005e28 <panic>

0000000080002e7e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e7e:	7179                	addi	sp,sp,-48
    80002e80:	f406                	sd	ra,40(sp)
    80002e82:	f022                	sd	s0,32(sp)
    80002e84:	ec26                	sd	s1,24(sp)
    80002e86:	e84a                	sd	s2,16(sp)
    80002e88:	e44e                	sd	s3,8(sp)
    80002e8a:	e052                	sd	s4,0(sp)
    80002e8c:	1800                	addi	s0,sp,48
    80002e8e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e90:	05050493          	addi	s1,a0,80
    80002e94:	08050913          	addi	s2,a0,128
    80002e98:	a021                	j	80002ea0 <itrunc+0x22>
    80002e9a:	0491                	addi	s1,s1,4
    80002e9c:	01248d63          	beq	s1,s2,80002eb6 <itrunc+0x38>
    if(ip->addrs[i]){
    80002ea0:	408c                	lw	a1,0(s1)
    80002ea2:	dde5                	beqz	a1,80002e9a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002ea4:	0009a503          	lw	a0,0(s3)
    80002ea8:	00000097          	auipc	ra,0x0
    80002eac:	90c080e7          	jalr	-1780(ra) # 800027b4 <bfree>
      ip->addrs[i] = 0;
    80002eb0:	0004a023          	sw	zero,0(s1)
    80002eb4:	b7dd                	j	80002e9a <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002eb6:	0809a583          	lw	a1,128(s3)
    80002eba:	e185                	bnez	a1,80002eda <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ebc:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ec0:	854e                	mv	a0,s3
    80002ec2:	00000097          	auipc	ra,0x0
    80002ec6:	de4080e7          	jalr	-540(ra) # 80002ca6 <iupdate>
}
    80002eca:	70a2                	ld	ra,40(sp)
    80002ecc:	7402                	ld	s0,32(sp)
    80002ece:	64e2                	ld	s1,24(sp)
    80002ed0:	6942                	ld	s2,16(sp)
    80002ed2:	69a2                	ld	s3,8(sp)
    80002ed4:	6a02                	ld	s4,0(sp)
    80002ed6:	6145                	addi	sp,sp,48
    80002ed8:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002eda:	0009a503          	lw	a0,0(s3)
    80002ede:	fffff097          	auipc	ra,0xfffff
    80002ee2:	690080e7          	jalr	1680(ra) # 8000256e <bread>
    80002ee6:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ee8:	05850493          	addi	s1,a0,88
    80002eec:	45850913          	addi	s2,a0,1112
    80002ef0:	a811                	j	80002f04 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002ef2:	0009a503          	lw	a0,0(s3)
    80002ef6:	00000097          	auipc	ra,0x0
    80002efa:	8be080e7          	jalr	-1858(ra) # 800027b4 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002efe:	0491                	addi	s1,s1,4
    80002f00:	01248563          	beq	s1,s2,80002f0a <itrunc+0x8c>
      if(a[j])
    80002f04:	408c                	lw	a1,0(s1)
    80002f06:	dde5                	beqz	a1,80002efe <itrunc+0x80>
    80002f08:	b7ed                	j	80002ef2 <itrunc+0x74>
    brelse(bp);
    80002f0a:	8552                	mv	a0,s4
    80002f0c:	fffff097          	auipc	ra,0xfffff
    80002f10:	792080e7          	jalr	1938(ra) # 8000269e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f14:	0809a583          	lw	a1,128(s3)
    80002f18:	0009a503          	lw	a0,0(s3)
    80002f1c:	00000097          	auipc	ra,0x0
    80002f20:	898080e7          	jalr	-1896(ra) # 800027b4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f24:	0809a023          	sw	zero,128(s3)
    80002f28:	bf51                	j	80002ebc <itrunc+0x3e>

0000000080002f2a <iput>:
{
    80002f2a:	1101                	addi	sp,sp,-32
    80002f2c:	ec06                	sd	ra,24(sp)
    80002f2e:	e822                	sd	s0,16(sp)
    80002f30:	e426                	sd	s1,8(sp)
    80002f32:	e04a                	sd	s2,0(sp)
    80002f34:	1000                	addi	s0,sp,32
    80002f36:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f38:	00015517          	auipc	a0,0x15
    80002f3c:	c4050513          	addi	a0,a0,-960 # 80017b78 <itable>
    80002f40:	00003097          	auipc	ra,0x3
    80002f44:	48e080e7          	jalr	1166(ra) # 800063ce <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f48:	4498                	lw	a4,8(s1)
    80002f4a:	4785                	li	a5,1
    80002f4c:	02f70363          	beq	a4,a5,80002f72 <iput+0x48>
  ip->ref--;
    80002f50:	449c                	lw	a5,8(s1)
    80002f52:	37fd                	addiw	a5,a5,-1
    80002f54:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f56:	00015517          	auipc	a0,0x15
    80002f5a:	c2250513          	addi	a0,a0,-990 # 80017b78 <itable>
    80002f5e:	00003097          	auipc	ra,0x3
    80002f62:	524080e7          	jalr	1316(ra) # 80006482 <release>
}
    80002f66:	60e2                	ld	ra,24(sp)
    80002f68:	6442                	ld	s0,16(sp)
    80002f6a:	64a2                	ld	s1,8(sp)
    80002f6c:	6902                	ld	s2,0(sp)
    80002f6e:	6105                	addi	sp,sp,32
    80002f70:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f72:	40bc                	lw	a5,64(s1)
    80002f74:	dff1                	beqz	a5,80002f50 <iput+0x26>
    80002f76:	04a49783          	lh	a5,74(s1)
    80002f7a:	fbf9                	bnez	a5,80002f50 <iput+0x26>
    acquiresleep(&ip->lock);
    80002f7c:	01048913          	addi	s2,s1,16
    80002f80:	854a                	mv	a0,s2
    80002f82:	00001097          	auipc	ra,0x1
    80002f86:	ab8080e7          	jalr	-1352(ra) # 80003a3a <acquiresleep>
    release(&itable.lock);
    80002f8a:	00015517          	auipc	a0,0x15
    80002f8e:	bee50513          	addi	a0,a0,-1042 # 80017b78 <itable>
    80002f92:	00003097          	auipc	ra,0x3
    80002f96:	4f0080e7          	jalr	1264(ra) # 80006482 <release>
    itrunc(ip);
    80002f9a:	8526                	mv	a0,s1
    80002f9c:	00000097          	auipc	ra,0x0
    80002fa0:	ee2080e7          	jalr	-286(ra) # 80002e7e <itrunc>
    ip->type = 0;
    80002fa4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002fa8:	8526                	mv	a0,s1
    80002faa:	00000097          	auipc	ra,0x0
    80002fae:	cfc080e7          	jalr	-772(ra) # 80002ca6 <iupdate>
    ip->valid = 0;
    80002fb2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fb6:	854a                	mv	a0,s2
    80002fb8:	00001097          	auipc	ra,0x1
    80002fbc:	ad8080e7          	jalr	-1320(ra) # 80003a90 <releasesleep>
    acquire(&itable.lock);
    80002fc0:	00015517          	auipc	a0,0x15
    80002fc4:	bb850513          	addi	a0,a0,-1096 # 80017b78 <itable>
    80002fc8:	00003097          	auipc	ra,0x3
    80002fcc:	406080e7          	jalr	1030(ra) # 800063ce <acquire>
    80002fd0:	b741                	j	80002f50 <iput+0x26>

0000000080002fd2 <iunlockput>:
{
    80002fd2:	1101                	addi	sp,sp,-32
    80002fd4:	ec06                	sd	ra,24(sp)
    80002fd6:	e822                	sd	s0,16(sp)
    80002fd8:	e426                	sd	s1,8(sp)
    80002fda:	1000                	addi	s0,sp,32
    80002fdc:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fde:	00000097          	auipc	ra,0x0
    80002fe2:	e54080e7          	jalr	-428(ra) # 80002e32 <iunlock>
  iput(ip);
    80002fe6:	8526                	mv	a0,s1
    80002fe8:	00000097          	auipc	ra,0x0
    80002fec:	f42080e7          	jalr	-190(ra) # 80002f2a <iput>
}
    80002ff0:	60e2                	ld	ra,24(sp)
    80002ff2:	6442                	ld	s0,16(sp)
    80002ff4:	64a2                	ld	s1,8(sp)
    80002ff6:	6105                	addi	sp,sp,32
    80002ff8:	8082                	ret

0000000080002ffa <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ffa:	1141                	addi	sp,sp,-16
    80002ffc:	e422                	sd	s0,8(sp)
    80002ffe:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003000:	411c                	lw	a5,0(a0)
    80003002:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003004:	415c                	lw	a5,4(a0)
    80003006:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003008:	04451783          	lh	a5,68(a0)
    8000300c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003010:	04a51783          	lh	a5,74(a0)
    80003014:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003018:	04c56783          	lwu	a5,76(a0)
    8000301c:	e99c                	sd	a5,16(a1)
}
    8000301e:	6422                	ld	s0,8(sp)
    80003020:	0141                	addi	sp,sp,16
    80003022:	8082                	ret

0000000080003024 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003024:	457c                	lw	a5,76(a0)
    80003026:	0ed7e963          	bltu	a5,a3,80003118 <readi+0xf4>
{
    8000302a:	7159                	addi	sp,sp,-112
    8000302c:	f486                	sd	ra,104(sp)
    8000302e:	f0a2                	sd	s0,96(sp)
    80003030:	eca6                	sd	s1,88(sp)
    80003032:	e8ca                	sd	s2,80(sp)
    80003034:	e4ce                	sd	s3,72(sp)
    80003036:	e0d2                	sd	s4,64(sp)
    80003038:	fc56                	sd	s5,56(sp)
    8000303a:	f85a                	sd	s6,48(sp)
    8000303c:	f45e                	sd	s7,40(sp)
    8000303e:	f062                	sd	s8,32(sp)
    80003040:	ec66                	sd	s9,24(sp)
    80003042:	e86a                	sd	s10,16(sp)
    80003044:	e46e                	sd	s11,8(sp)
    80003046:	1880                	addi	s0,sp,112
    80003048:	8baa                	mv	s7,a0
    8000304a:	8c2e                	mv	s8,a1
    8000304c:	8ab2                	mv	s5,a2
    8000304e:	84b6                	mv	s1,a3
    80003050:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003052:	9f35                	addw	a4,a4,a3
    return 0;
    80003054:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003056:	0ad76063          	bltu	a4,a3,800030f6 <readi+0xd2>
  if(off + n > ip->size)
    8000305a:	00e7f463          	bgeu	a5,a4,80003062 <readi+0x3e>
    n = ip->size - off;
    8000305e:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003062:	0a0b0963          	beqz	s6,80003114 <readi+0xf0>
    80003066:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003068:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000306c:	5cfd                	li	s9,-1
    8000306e:	a82d                	j	800030a8 <readi+0x84>
    80003070:	020a1d93          	slli	s11,s4,0x20
    80003074:	020ddd93          	srli	s11,s11,0x20
    80003078:	05890613          	addi	a2,s2,88
    8000307c:	86ee                	mv	a3,s11
    8000307e:	963a                	add	a2,a2,a4
    80003080:	85d6                	mv	a1,s5
    80003082:	8562                	mv	a0,s8
    80003084:	fffff097          	auipc	ra,0xfffff
    80003088:	832080e7          	jalr	-1998(ra) # 800018b6 <either_copyout>
    8000308c:	05950d63          	beq	a0,s9,800030e6 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003090:	854a                	mv	a0,s2
    80003092:	fffff097          	auipc	ra,0xfffff
    80003096:	60c080e7          	jalr	1548(ra) # 8000269e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000309a:	013a09bb          	addw	s3,s4,s3
    8000309e:	009a04bb          	addw	s1,s4,s1
    800030a2:	9aee                	add	s5,s5,s11
    800030a4:	0569f763          	bgeu	s3,s6,800030f2 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030a8:	000ba903          	lw	s2,0(s7)
    800030ac:	00a4d59b          	srliw	a1,s1,0xa
    800030b0:	855e                	mv	a0,s7
    800030b2:	00000097          	auipc	ra,0x0
    800030b6:	8b0080e7          	jalr	-1872(ra) # 80002962 <bmap>
    800030ba:	0005059b          	sext.w	a1,a0
    800030be:	854a                	mv	a0,s2
    800030c0:	fffff097          	auipc	ra,0xfffff
    800030c4:	4ae080e7          	jalr	1198(ra) # 8000256e <bread>
    800030c8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030ca:	3ff4f713          	andi	a4,s1,1023
    800030ce:	40ed07bb          	subw	a5,s10,a4
    800030d2:	413b06bb          	subw	a3,s6,s3
    800030d6:	8a3e                	mv	s4,a5
    800030d8:	2781                	sext.w	a5,a5
    800030da:	0006861b          	sext.w	a2,a3
    800030de:	f8f679e3          	bgeu	a2,a5,80003070 <readi+0x4c>
    800030e2:	8a36                	mv	s4,a3
    800030e4:	b771                	j	80003070 <readi+0x4c>
      brelse(bp);
    800030e6:	854a                	mv	a0,s2
    800030e8:	fffff097          	auipc	ra,0xfffff
    800030ec:	5b6080e7          	jalr	1462(ra) # 8000269e <brelse>
      tot = -1;
    800030f0:	59fd                	li	s3,-1
  }
  return tot;
    800030f2:	0009851b          	sext.w	a0,s3
}
    800030f6:	70a6                	ld	ra,104(sp)
    800030f8:	7406                	ld	s0,96(sp)
    800030fa:	64e6                	ld	s1,88(sp)
    800030fc:	6946                	ld	s2,80(sp)
    800030fe:	69a6                	ld	s3,72(sp)
    80003100:	6a06                	ld	s4,64(sp)
    80003102:	7ae2                	ld	s5,56(sp)
    80003104:	7b42                	ld	s6,48(sp)
    80003106:	7ba2                	ld	s7,40(sp)
    80003108:	7c02                	ld	s8,32(sp)
    8000310a:	6ce2                	ld	s9,24(sp)
    8000310c:	6d42                	ld	s10,16(sp)
    8000310e:	6da2                	ld	s11,8(sp)
    80003110:	6165                	addi	sp,sp,112
    80003112:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003114:	89da                	mv	s3,s6
    80003116:	bff1                	j	800030f2 <readi+0xce>
    return 0;
    80003118:	4501                	li	a0,0
}
    8000311a:	8082                	ret

000000008000311c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000311c:	457c                	lw	a5,76(a0)
    8000311e:	10d7e863          	bltu	a5,a3,8000322e <writei+0x112>
{
    80003122:	7159                	addi	sp,sp,-112
    80003124:	f486                	sd	ra,104(sp)
    80003126:	f0a2                	sd	s0,96(sp)
    80003128:	eca6                	sd	s1,88(sp)
    8000312a:	e8ca                	sd	s2,80(sp)
    8000312c:	e4ce                	sd	s3,72(sp)
    8000312e:	e0d2                	sd	s4,64(sp)
    80003130:	fc56                	sd	s5,56(sp)
    80003132:	f85a                	sd	s6,48(sp)
    80003134:	f45e                	sd	s7,40(sp)
    80003136:	f062                	sd	s8,32(sp)
    80003138:	ec66                	sd	s9,24(sp)
    8000313a:	e86a                	sd	s10,16(sp)
    8000313c:	e46e                	sd	s11,8(sp)
    8000313e:	1880                	addi	s0,sp,112
    80003140:	8b2a                	mv	s6,a0
    80003142:	8c2e                	mv	s8,a1
    80003144:	8ab2                	mv	s5,a2
    80003146:	8936                	mv	s2,a3
    80003148:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    8000314a:	00e687bb          	addw	a5,a3,a4
    8000314e:	0ed7e263          	bltu	a5,a3,80003232 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003152:	00043737          	lui	a4,0x43
    80003156:	0ef76063          	bltu	a4,a5,80003236 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000315a:	0c0b8863          	beqz	s7,8000322a <writei+0x10e>
    8000315e:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003160:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003164:	5cfd                	li	s9,-1
    80003166:	a091                	j	800031aa <writei+0x8e>
    80003168:	02099d93          	slli	s11,s3,0x20
    8000316c:	020ddd93          	srli	s11,s11,0x20
    80003170:	05848513          	addi	a0,s1,88
    80003174:	86ee                	mv	a3,s11
    80003176:	8656                	mv	a2,s5
    80003178:	85e2                	mv	a1,s8
    8000317a:	953a                	add	a0,a0,a4
    8000317c:	ffffe097          	auipc	ra,0xffffe
    80003180:	790080e7          	jalr	1936(ra) # 8000190c <either_copyin>
    80003184:	07950263          	beq	a0,s9,800031e8 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003188:	8526                	mv	a0,s1
    8000318a:	00000097          	auipc	ra,0x0
    8000318e:	790080e7          	jalr	1936(ra) # 8000391a <log_write>
    brelse(bp);
    80003192:	8526                	mv	a0,s1
    80003194:	fffff097          	auipc	ra,0xfffff
    80003198:	50a080e7          	jalr	1290(ra) # 8000269e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000319c:	01498a3b          	addw	s4,s3,s4
    800031a0:	0129893b          	addw	s2,s3,s2
    800031a4:	9aee                	add	s5,s5,s11
    800031a6:	057a7663          	bgeu	s4,s7,800031f2 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800031aa:	000b2483          	lw	s1,0(s6)
    800031ae:	00a9559b          	srliw	a1,s2,0xa
    800031b2:	855a                	mv	a0,s6
    800031b4:	fffff097          	auipc	ra,0xfffff
    800031b8:	7ae080e7          	jalr	1966(ra) # 80002962 <bmap>
    800031bc:	0005059b          	sext.w	a1,a0
    800031c0:	8526                	mv	a0,s1
    800031c2:	fffff097          	auipc	ra,0xfffff
    800031c6:	3ac080e7          	jalr	940(ra) # 8000256e <bread>
    800031ca:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031cc:	3ff97713          	andi	a4,s2,1023
    800031d0:	40ed07bb          	subw	a5,s10,a4
    800031d4:	414b86bb          	subw	a3,s7,s4
    800031d8:	89be                	mv	s3,a5
    800031da:	2781                	sext.w	a5,a5
    800031dc:	0006861b          	sext.w	a2,a3
    800031e0:	f8f674e3          	bgeu	a2,a5,80003168 <writei+0x4c>
    800031e4:	89b6                	mv	s3,a3
    800031e6:	b749                	j	80003168 <writei+0x4c>
      brelse(bp);
    800031e8:	8526                	mv	a0,s1
    800031ea:	fffff097          	auipc	ra,0xfffff
    800031ee:	4b4080e7          	jalr	1204(ra) # 8000269e <brelse>
  }

  if(off > ip->size)
    800031f2:	04cb2783          	lw	a5,76(s6)
    800031f6:	0127f463          	bgeu	a5,s2,800031fe <writei+0xe2>
    ip->size = off;
    800031fa:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031fe:	855a                	mv	a0,s6
    80003200:	00000097          	auipc	ra,0x0
    80003204:	aa6080e7          	jalr	-1370(ra) # 80002ca6 <iupdate>

  return tot;
    80003208:	000a051b          	sext.w	a0,s4
}
    8000320c:	70a6                	ld	ra,104(sp)
    8000320e:	7406                	ld	s0,96(sp)
    80003210:	64e6                	ld	s1,88(sp)
    80003212:	6946                	ld	s2,80(sp)
    80003214:	69a6                	ld	s3,72(sp)
    80003216:	6a06                	ld	s4,64(sp)
    80003218:	7ae2                	ld	s5,56(sp)
    8000321a:	7b42                	ld	s6,48(sp)
    8000321c:	7ba2                	ld	s7,40(sp)
    8000321e:	7c02                	ld	s8,32(sp)
    80003220:	6ce2                	ld	s9,24(sp)
    80003222:	6d42                	ld	s10,16(sp)
    80003224:	6da2                	ld	s11,8(sp)
    80003226:	6165                	addi	sp,sp,112
    80003228:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000322a:	8a5e                	mv	s4,s7
    8000322c:	bfc9                	j	800031fe <writei+0xe2>
    return -1;
    8000322e:	557d                	li	a0,-1
}
    80003230:	8082                	ret
    return -1;
    80003232:	557d                	li	a0,-1
    80003234:	bfe1                	j	8000320c <writei+0xf0>
    return -1;
    80003236:	557d                	li	a0,-1
    80003238:	bfd1                	j	8000320c <writei+0xf0>

000000008000323a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000323a:	1141                	addi	sp,sp,-16
    8000323c:	e406                	sd	ra,8(sp)
    8000323e:	e022                	sd	s0,0(sp)
    80003240:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003242:	4639                	li	a2,14
    80003244:	ffffd097          	auipc	ra,0xffffd
    80003248:	00c080e7          	jalr	12(ra) # 80000250 <strncmp>
}
    8000324c:	60a2                	ld	ra,8(sp)
    8000324e:	6402                	ld	s0,0(sp)
    80003250:	0141                	addi	sp,sp,16
    80003252:	8082                	ret

0000000080003254 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003254:	7139                	addi	sp,sp,-64
    80003256:	fc06                	sd	ra,56(sp)
    80003258:	f822                	sd	s0,48(sp)
    8000325a:	f426                	sd	s1,40(sp)
    8000325c:	f04a                	sd	s2,32(sp)
    8000325e:	ec4e                	sd	s3,24(sp)
    80003260:	e852                	sd	s4,16(sp)
    80003262:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003264:	04451703          	lh	a4,68(a0)
    80003268:	4785                	li	a5,1
    8000326a:	00f71a63          	bne	a4,a5,8000327e <dirlookup+0x2a>
    8000326e:	892a                	mv	s2,a0
    80003270:	89ae                	mv	s3,a1
    80003272:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003274:	457c                	lw	a5,76(a0)
    80003276:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003278:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000327a:	e79d                	bnez	a5,800032a8 <dirlookup+0x54>
    8000327c:	a8a5                	j	800032f4 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000327e:	00005517          	auipc	a0,0x5
    80003282:	31a50513          	addi	a0,a0,794 # 80008598 <syscalls+0x1d0>
    80003286:	00003097          	auipc	ra,0x3
    8000328a:	ba2080e7          	jalr	-1118(ra) # 80005e28 <panic>
      panic("dirlookup read");
    8000328e:	00005517          	auipc	a0,0x5
    80003292:	32250513          	addi	a0,a0,802 # 800085b0 <syscalls+0x1e8>
    80003296:	00003097          	auipc	ra,0x3
    8000329a:	b92080e7          	jalr	-1134(ra) # 80005e28 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000329e:	24c1                	addiw	s1,s1,16
    800032a0:	04c92783          	lw	a5,76(s2)
    800032a4:	04f4f763          	bgeu	s1,a5,800032f2 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032a8:	4741                	li	a4,16
    800032aa:	86a6                	mv	a3,s1
    800032ac:	fc040613          	addi	a2,s0,-64
    800032b0:	4581                	li	a1,0
    800032b2:	854a                	mv	a0,s2
    800032b4:	00000097          	auipc	ra,0x0
    800032b8:	d70080e7          	jalr	-656(ra) # 80003024 <readi>
    800032bc:	47c1                	li	a5,16
    800032be:	fcf518e3          	bne	a0,a5,8000328e <dirlookup+0x3a>
    if(de.inum == 0)
    800032c2:	fc045783          	lhu	a5,-64(s0)
    800032c6:	dfe1                	beqz	a5,8000329e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032c8:	fc240593          	addi	a1,s0,-62
    800032cc:	854e                	mv	a0,s3
    800032ce:	00000097          	auipc	ra,0x0
    800032d2:	f6c080e7          	jalr	-148(ra) # 8000323a <namecmp>
    800032d6:	f561                	bnez	a0,8000329e <dirlookup+0x4a>
      if(poff)
    800032d8:	000a0463          	beqz	s4,800032e0 <dirlookup+0x8c>
        *poff = off;
    800032dc:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032e0:	fc045583          	lhu	a1,-64(s0)
    800032e4:	00092503          	lw	a0,0(s2)
    800032e8:	fffff097          	auipc	ra,0xfffff
    800032ec:	754080e7          	jalr	1876(ra) # 80002a3c <iget>
    800032f0:	a011                	j	800032f4 <dirlookup+0xa0>
  return 0;
    800032f2:	4501                	li	a0,0
}
    800032f4:	70e2                	ld	ra,56(sp)
    800032f6:	7442                	ld	s0,48(sp)
    800032f8:	74a2                	ld	s1,40(sp)
    800032fa:	7902                	ld	s2,32(sp)
    800032fc:	69e2                	ld	s3,24(sp)
    800032fe:	6a42                	ld	s4,16(sp)
    80003300:	6121                	addi	sp,sp,64
    80003302:	8082                	ret

0000000080003304 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003304:	711d                	addi	sp,sp,-96
    80003306:	ec86                	sd	ra,88(sp)
    80003308:	e8a2                	sd	s0,80(sp)
    8000330a:	e4a6                	sd	s1,72(sp)
    8000330c:	e0ca                	sd	s2,64(sp)
    8000330e:	fc4e                	sd	s3,56(sp)
    80003310:	f852                	sd	s4,48(sp)
    80003312:	f456                	sd	s5,40(sp)
    80003314:	f05a                	sd	s6,32(sp)
    80003316:	ec5e                	sd	s7,24(sp)
    80003318:	e862                	sd	s8,16(sp)
    8000331a:	e466                	sd	s9,8(sp)
    8000331c:	1080                	addi	s0,sp,96
    8000331e:	84aa                	mv	s1,a0
    80003320:	8b2e                	mv	s6,a1
    80003322:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003324:	00054703          	lbu	a4,0(a0)
    80003328:	02f00793          	li	a5,47
    8000332c:	02f70363          	beq	a4,a5,80003352 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003330:	ffffe097          	auipc	ra,0xffffe
    80003334:	b18080e7          	jalr	-1256(ra) # 80000e48 <myproc>
    80003338:	16853503          	ld	a0,360(a0)
    8000333c:	00000097          	auipc	ra,0x0
    80003340:	9f6080e7          	jalr	-1546(ra) # 80002d32 <idup>
    80003344:	89aa                	mv	s3,a0
  while(*path == '/')
    80003346:	02f00913          	li	s2,47
  len = path - s;
    8000334a:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000334c:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000334e:	4c05                	li	s8,1
    80003350:	a865                	j	80003408 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003352:	4585                	li	a1,1
    80003354:	4505                	li	a0,1
    80003356:	fffff097          	auipc	ra,0xfffff
    8000335a:	6e6080e7          	jalr	1766(ra) # 80002a3c <iget>
    8000335e:	89aa                	mv	s3,a0
    80003360:	b7dd                	j	80003346 <namex+0x42>
      iunlockput(ip);
    80003362:	854e                	mv	a0,s3
    80003364:	00000097          	auipc	ra,0x0
    80003368:	c6e080e7          	jalr	-914(ra) # 80002fd2 <iunlockput>
      return 0;
    8000336c:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000336e:	854e                	mv	a0,s3
    80003370:	60e6                	ld	ra,88(sp)
    80003372:	6446                	ld	s0,80(sp)
    80003374:	64a6                	ld	s1,72(sp)
    80003376:	6906                	ld	s2,64(sp)
    80003378:	79e2                	ld	s3,56(sp)
    8000337a:	7a42                	ld	s4,48(sp)
    8000337c:	7aa2                	ld	s5,40(sp)
    8000337e:	7b02                	ld	s6,32(sp)
    80003380:	6be2                	ld	s7,24(sp)
    80003382:	6c42                	ld	s8,16(sp)
    80003384:	6ca2                	ld	s9,8(sp)
    80003386:	6125                	addi	sp,sp,96
    80003388:	8082                	ret
      iunlock(ip);
    8000338a:	854e                	mv	a0,s3
    8000338c:	00000097          	auipc	ra,0x0
    80003390:	aa6080e7          	jalr	-1370(ra) # 80002e32 <iunlock>
      return ip;
    80003394:	bfe9                	j	8000336e <namex+0x6a>
      iunlockput(ip);
    80003396:	854e                	mv	a0,s3
    80003398:	00000097          	auipc	ra,0x0
    8000339c:	c3a080e7          	jalr	-966(ra) # 80002fd2 <iunlockput>
      return 0;
    800033a0:	89d2                	mv	s3,s4
    800033a2:	b7f1                	j	8000336e <namex+0x6a>
  len = path - s;
    800033a4:	40b48633          	sub	a2,s1,a1
    800033a8:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800033ac:	094cd463          	bge	s9,s4,80003434 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800033b0:	4639                	li	a2,14
    800033b2:	8556                	mv	a0,s5
    800033b4:	ffffd097          	auipc	ra,0xffffd
    800033b8:	e24080e7          	jalr	-476(ra) # 800001d8 <memmove>
  while(*path == '/')
    800033bc:	0004c783          	lbu	a5,0(s1)
    800033c0:	01279763          	bne	a5,s2,800033ce <namex+0xca>
    path++;
    800033c4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033c6:	0004c783          	lbu	a5,0(s1)
    800033ca:	ff278de3          	beq	a5,s2,800033c4 <namex+0xc0>
    ilock(ip);
    800033ce:	854e                	mv	a0,s3
    800033d0:	00000097          	auipc	ra,0x0
    800033d4:	9a0080e7          	jalr	-1632(ra) # 80002d70 <ilock>
    if(ip->type != T_DIR){
    800033d8:	04499783          	lh	a5,68(s3)
    800033dc:	f98793e3          	bne	a5,s8,80003362 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800033e0:	000b0563          	beqz	s6,800033ea <namex+0xe6>
    800033e4:	0004c783          	lbu	a5,0(s1)
    800033e8:	d3cd                	beqz	a5,8000338a <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033ea:	865e                	mv	a2,s7
    800033ec:	85d6                	mv	a1,s5
    800033ee:	854e                	mv	a0,s3
    800033f0:	00000097          	auipc	ra,0x0
    800033f4:	e64080e7          	jalr	-412(ra) # 80003254 <dirlookup>
    800033f8:	8a2a                	mv	s4,a0
    800033fa:	dd51                	beqz	a0,80003396 <namex+0x92>
    iunlockput(ip);
    800033fc:	854e                	mv	a0,s3
    800033fe:	00000097          	auipc	ra,0x0
    80003402:	bd4080e7          	jalr	-1068(ra) # 80002fd2 <iunlockput>
    ip = next;
    80003406:	89d2                	mv	s3,s4
  while(*path == '/')
    80003408:	0004c783          	lbu	a5,0(s1)
    8000340c:	05279763          	bne	a5,s2,8000345a <namex+0x156>
    path++;
    80003410:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003412:	0004c783          	lbu	a5,0(s1)
    80003416:	ff278de3          	beq	a5,s2,80003410 <namex+0x10c>
  if(*path == 0)
    8000341a:	c79d                	beqz	a5,80003448 <namex+0x144>
    path++;
    8000341c:	85a6                	mv	a1,s1
  len = path - s;
    8000341e:	8a5e                	mv	s4,s7
    80003420:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003422:	01278963          	beq	a5,s2,80003434 <namex+0x130>
    80003426:	dfbd                	beqz	a5,800033a4 <namex+0xa0>
    path++;
    80003428:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000342a:	0004c783          	lbu	a5,0(s1)
    8000342e:	ff279ce3          	bne	a5,s2,80003426 <namex+0x122>
    80003432:	bf8d                	j	800033a4 <namex+0xa0>
    memmove(name, s, len);
    80003434:	2601                	sext.w	a2,a2
    80003436:	8556                	mv	a0,s5
    80003438:	ffffd097          	auipc	ra,0xffffd
    8000343c:	da0080e7          	jalr	-608(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003440:	9a56                	add	s4,s4,s5
    80003442:	000a0023          	sb	zero,0(s4)
    80003446:	bf9d                	j	800033bc <namex+0xb8>
  if(nameiparent){
    80003448:	f20b03e3          	beqz	s6,8000336e <namex+0x6a>
    iput(ip);
    8000344c:	854e                	mv	a0,s3
    8000344e:	00000097          	auipc	ra,0x0
    80003452:	adc080e7          	jalr	-1316(ra) # 80002f2a <iput>
    return 0;
    80003456:	4981                	li	s3,0
    80003458:	bf19                	j	8000336e <namex+0x6a>
  if(*path == 0)
    8000345a:	d7fd                	beqz	a5,80003448 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000345c:	0004c783          	lbu	a5,0(s1)
    80003460:	85a6                	mv	a1,s1
    80003462:	b7d1                	j	80003426 <namex+0x122>

0000000080003464 <dirlink>:
{
    80003464:	7139                	addi	sp,sp,-64
    80003466:	fc06                	sd	ra,56(sp)
    80003468:	f822                	sd	s0,48(sp)
    8000346a:	f426                	sd	s1,40(sp)
    8000346c:	f04a                	sd	s2,32(sp)
    8000346e:	ec4e                	sd	s3,24(sp)
    80003470:	e852                	sd	s4,16(sp)
    80003472:	0080                	addi	s0,sp,64
    80003474:	892a                	mv	s2,a0
    80003476:	8a2e                	mv	s4,a1
    80003478:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000347a:	4601                	li	a2,0
    8000347c:	00000097          	auipc	ra,0x0
    80003480:	dd8080e7          	jalr	-552(ra) # 80003254 <dirlookup>
    80003484:	e93d                	bnez	a0,800034fa <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003486:	04c92483          	lw	s1,76(s2)
    8000348a:	c49d                	beqz	s1,800034b8 <dirlink+0x54>
    8000348c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000348e:	4741                	li	a4,16
    80003490:	86a6                	mv	a3,s1
    80003492:	fc040613          	addi	a2,s0,-64
    80003496:	4581                	li	a1,0
    80003498:	854a                	mv	a0,s2
    8000349a:	00000097          	auipc	ra,0x0
    8000349e:	b8a080e7          	jalr	-1142(ra) # 80003024 <readi>
    800034a2:	47c1                	li	a5,16
    800034a4:	06f51163          	bne	a0,a5,80003506 <dirlink+0xa2>
    if(de.inum == 0)
    800034a8:	fc045783          	lhu	a5,-64(s0)
    800034ac:	c791                	beqz	a5,800034b8 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034ae:	24c1                	addiw	s1,s1,16
    800034b0:	04c92783          	lw	a5,76(s2)
    800034b4:	fcf4ede3          	bltu	s1,a5,8000348e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034b8:	4639                	li	a2,14
    800034ba:	85d2                	mv	a1,s4
    800034bc:	fc240513          	addi	a0,s0,-62
    800034c0:	ffffd097          	auipc	ra,0xffffd
    800034c4:	dcc080e7          	jalr	-564(ra) # 8000028c <strncpy>
  de.inum = inum;
    800034c8:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034cc:	4741                	li	a4,16
    800034ce:	86a6                	mv	a3,s1
    800034d0:	fc040613          	addi	a2,s0,-64
    800034d4:	4581                	li	a1,0
    800034d6:	854a                	mv	a0,s2
    800034d8:	00000097          	auipc	ra,0x0
    800034dc:	c44080e7          	jalr	-956(ra) # 8000311c <writei>
    800034e0:	872a                	mv	a4,a0
    800034e2:	47c1                	li	a5,16
  return 0;
    800034e4:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034e6:	02f71863          	bne	a4,a5,80003516 <dirlink+0xb2>
}
    800034ea:	70e2                	ld	ra,56(sp)
    800034ec:	7442                	ld	s0,48(sp)
    800034ee:	74a2                	ld	s1,40(sp)
    800034f0:	7902                	ld	s2,32(sp)
    800034f2:	69e2                	ld	s3,24(sp)
    800034f4:	6a42                	ld	s4,16(sp)
    800034f6:	6121                	addi	sp,sp,64
    800034f8:	8082                	ret
    iput(ip);
    800034fa:	00000097          	auipc	ra,0x0
    800034fe:	a30080e7          	jalr	-1488(ra) # 80002f2a <iput>
    return -1;
    80003502:	557d                	li	a0,-1
    80003504:	b7dd                	j	800034ea <dirlink+0x86>
      panic("dirlink read");
    80003506:	00005517          	auipc	a0,0x5
    8000350a:	0ba50513          	addi	a0,a0,186 # 800085c0 <syscalls+0x1f8>
    8000350e:	00003097          	auipc	ra,0x3
    80003512:	91a080e7          	jalr	-1766(ra) # 80005e28 <panic>
    panic("dirlink");
    80003516:	00005517          	auipc	a0,0x5
    8000351a:	1ba50513          	addi	a0,a0,442 # 800086d0 <syscalls+0x308>
    8000351e:	00003097          	auipc	ra,0x3
    80003522:	90a080e7          	jalr	-1782(ra) # 80005e28 <panic>

0000000080003526 <namei>:

struct inode*
namei(char *path)
{
    80003526:	1101                	addi	sp,sp,-32
    80003528:	ec06                	sd	ra,24(sp)
    8000352a:	e822                	sd	s0,16(sp)
    8000352c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000352e:	fe040613          	addi	a2,s0,-32
    80003532:	4581                	li	a1,0
    80003534:	00000097          	auipc	ra,0x0
    80003538:	dd0080e7          	jalr	-560(ra) # 80003304 <namex>
}
    8000353c:	60e2                	ld	ra,24(sp)
    8000353e:	6442                	ld	s0,16(sp)
    80003540:	6105                	addi	sp,sp,32
    80003542:	8082                	ret

0000000080003544 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003544:	1141                	addi	sp,sp,-16
    80003546:	e406                	sd	ra,8(sp)
    80003548:	e022                	sd	s0,0(sp)
    8000354a:	0800                	addi	s0,sp,16
    8000354c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000354e:	4585                	li	a1,1
    80003550:	00000097          	auipc	ra,0x0
    80003554:	db4080e7          	jalr	-588(ra) # 80003304 <namex>
}
    80003558:	60a2                	ld	ra,8(sp)
    8000355a:	6402                	ld	s0,0(sp)
    8000355c:	0141                	addi	sp,sp,16
    8000355e:	8082                	ret

0000000080003560 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003560:	1101                	addi	sp,sp,-32
    80003562:	ec06                	sd	ra,24(sp)
    80003564:	e822                	sd	s0,16(sp)
    80003566:	e426                	sd	s1,8(sp)
    80003568:	e04a                	sd	s2,0(sp)
    8000356a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000356c:	00016917          	auipc	s2,0x16
    80003570:	0b490913          	addi	s2,s2,180 # 80019620 <log>
    80003574:	01892583          	lw	a1,24(s2)
    80003578:	02892503          	lw	a0,40(s2)
    8000357c:	fffff097          	auipc	ra,0xfffff
    80003580:	ff2080e7          	jalr	-14(ra) # 8000256e <bread>
    80003584:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003586:	02c92683          	lw	a3,44(s2)
    8000358a:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000358c:	02d05763          	blez	a3,800035ba <write_head+0x5a>
    80003590:	00016797          	auipc	a5,0x16
    80003594:	0c078793          	addi	a5,a5,192 # 80019650 <log+0x30>
    80003598:	05c50713          	addi	a4,a0,92
    8000359c:	36fd                	addiw	a3,a3,-1
    8000359e:	1682                	slli	a3,a3,0x20
    800035a0:	9281                	srli	a3,a3,0x20
    800035a2:	068a                	slli	a3,a3,0x2
    800035a4:	00016617          	auipc	a2,0x16
    800035a8:	0b060613          	addi	a2,a2,176 # 80019654 <log+0x34>
    800035ac:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800035ae:	4390                	lw	a2,0(a5)
    800035b0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035b2:	0791                	addi	a5,a5,4
    800035b4:	0711                	addi	a4,a4,4
    800035b6:	fed79ce3          	bne	a5,a3,800035ae <write_head+0x4e>
  }
  bwrite(buf);
    800035ba:	8526                	mv	a0,s1
    800035bc:	fffff097          	auipc	ra,0xfffff
    800035c0:	0a4080e7          	jalr	164(ra) # 80002660 <bwrite>
  brelse(buf);
    800035c4:	8526                	mv	a0,s1
    800035c6:	fffff097          	auipc	ra,0xfffff
    800035ca:	0d8080e7          	jalr	216(ra) # 8000269e <brelse>
}
    800035ce:	60e2                	ld	ra,24(sp)
    800035d0:	6442                	ld	s0,16(sp)
    800035d2:	64a2                	ld	s1,8(sp)
    800035d4:	6902                	ld	s2,0(sp)
    800035d6:	6105                	addi	sp,sp,32
    800035d8:	8082                	ret

00000000800035da <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035da:	00016797          	auipc	a5,0x16
    800035de:	0727a783          	lw	a5,114(a5) # 8001964c <log+0x2c>
    800035e2:	0af05d63          	blez	a5,8000369c <install_trans+0xc2>
{
    800035e6:	7139                	addi	sp,sp,-64
    800035e8:	fc06                	sd	ra,56(sp)
    800035ea:	f822                	sd	s0,48(sp)
    800035ec:	f426                	sd	s1,40(sp)
    800035ee:	f04a                	sd	s2,32(sp)
    800035f0:	ec4e                	sd	s3,24(sp)
    800035f2:	e852                	sd	s4,16(sp)
    800035f4:	e456                	sd	s5,8(sp)
    800035f6:	e05a                	sd	s6,0(sp)
    800035f8:	0080                	addi	s0,sp,64
    800035fa:	8b2a                	mv	s6,a0
    800035fc:	00016a97          	auipc	s5,0x16
    80003600:	054a8a93          	addi	s5,s5,84 # 80019650 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003604:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003606:	00016997          	auipc	s3,0x16
    8000360a:	01a98993          	addi	s3,s3,26 # 80019620 <log>
    8000360e:	a035                	j	8000363a <install_trans+0x60>
      bunpin(dbuf);
    80003610:	8526                	mv	a0,s1
    80003612:	fffff097          	auipc	ra,0xfffff
    80003616:	166080e7          	jalr	358(ra) # 80002778 <bunpin>
    brelse(lbuf);
    8000361a:	854a                	mv	a0,s2
    8000361c:	fffff097          	auipc	ra,0xfffff
    80003620:	082080e7          	jalr	130(ra) # 8000269e <brelse>
    brelse(dbuf);
    80003624:	8526                	mv	a0,s1
    80003626:	fffff097          	auipc	ra,0xfffff
    8000362a:	078080e7          	jalr	120(ra) # 8000269e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000362e:	2a05                	addiw	s4,s4,1
    80003630:	0a91                	addi	s5,s5,4
    80003632:	02c9a783          	lw	a5,44(s3)
    80003636:	04fa5963          	bge	s4,a5,80003688 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000363a:	0189a583          	lw	a1,24(s3)
    8000363e:	014585bb          	addw	a1,a1,s4
    80003642:	2585                	addiw	a1,a1,1
    80003644:	0289a503          	lw	a0,40(s3)
    80003648:	fffff097          	auipc	ra,0xfffff
    8000364c:	f26080e7          	jalr	-218(ra) # 8000256e <bread>
    80003650:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003652:	000aa583          	lw	a1,0(s5)
    80003656:	0289a503          	lw	a0,40(s3)
    8000365a:	fffff097          	auipc	ra,0xfffff
    8000365e:	f14080e7          	jalr	-236(ra) # 8000256e <bread>
    80003662:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003664:	40000613          	li	a2,1024
    80003668:	05890593          	addi	a1,s2,88
    8000366c:	05850513          	addi	a0,a0,88
    80003670:	ffffd097          	auipc	ra,0xffffd
    80003674:	b68080e7          	jalr	-1176(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003678:	8526                	mv	a0,s1
    8000367a:	fffff097          	auipc	ra,0xfffff
    8000367e:	fe6080e7          	jalr	-26(ra) # 80002660 <bwrite>
    if(recovering == 0)
    80003682:	f80b1ce3          	bnez	s6,8000361a <install_trans+0x40>
    80003686:	b769                	j	80003610 <install_trans+0x36>
}
    80003688:	70e2                	ld	ra,56(sp)
    8000368a:	7442                	ld	s0,48(sp)
    8000368c:	74a2                	ld	s1,40(sp)
    8000368e:	7902                	ld	s2,32(sp)
    80003690:	69e2                	ld	s3,24(sp)
    80003692:	6a42                	ld	s4,16(sp)
    80003694:	6aa2                	ld	s5,8(sp)
    80003696:	6b02                	ld	s6,0(sp)
    80003698:	6121                	addi	sp,sp,64
    8000369a:	8082                	ret
    8000369c:	8082                	ret

000000008000369e <initlog>:
{
    8000369e:	7179                	addi	sp,sp,-48
    800036a0:	f406                	sd	ra,40(sp)
    800036a2:	f022                	sd	s0,32(sp)
    800036a4:	ec26                	sd	s1,24(sp)
    800036a6:	e84a                	sd	s2,16(sp)
    800036a8:	e44e                	sd	s3,8(sp)
    800036aa:	1800                	addi	s0,sp,48
    800036ac:	892a                	mv	s2,a0
    800036ae:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036b0:	00016497          	auipc	s1,0x16
    800036b4:	f7048493          	addi	s1,s1,-144 # 80019620 <log>
    800036b8:	00005597          	auipc	a1,0x5
    800036bc:	f1858593          	addi	a1,a1,-232 # 800085d0 <syscalls+0x208>
    800036c0:	8526                	mv	a0,s1
    800036c2:	00003097          	auipc	ra,0x3
    800036c6:	c7c080e7          	jalr	-900(ra) # 8000633e <initlock>
  log.start = sb->logstart;
    800036ca:	0149a583          	lw	a1,20(s3)
    800036ce:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800036d0:	0109a783          	lw	a5,16(s3)
    800036d4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800036d6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036da:	854a                	mv	a0,s2
    800036dc:	fffff097          	auipc	ra,0xfffff
    800036e0:	e92080e7          	jalr	-366(ra) # 8000256e <bread>
  log.lh.n = lh->n;
    800036e4:	4d3c                	lw	a5,88(a0)
    800036e6:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036e8:	02f05563          	blez	a5,80003712 <initlog+0x74>
    800036ec:	05c50713          	addi	a4,a0,92
    800036f0:	00016697          	auipc	a3,0x16
    800036f4:	f6068693          	addi	a3,a3,-160 # 80019650 <log+0x30>
    800036f8:	37fd                	addiw	a5,a5,-1
    800036fa:	1782                	slli	a5,a5,0x20
    800036fc:	9381                	srli	a5,a5,0x20
    800036fe:	078a                	slli	a5,a5,0x2
    80003700:	06050613          	addi	a2,a0,96
    80003704:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003706:	4310                	lw	a2,0(a4)
    80003708:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000370a:	0711                	addi	a4,a4,4
    8000370c:	0691                	addi	a3,a3,4
    8000370e:	fef71ce3          	bne	a4,a5,80003706 <initlog+0x68>
  brelse(buf);
    80003712:	fffff097          	auipc	ra,0xfffff
    80003716:	f8c080e7          	jalr	-116(ra) # 8000269e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000371a:	4505                	li	a0,1
    8000371c:	00000097          	auipc	ra,0x0
    80003720:	ebe080e7          	jalr	-322(ra) # 800035da <install_trans>
  log.lh.n = 0;
    80003724:	00016797          	auipc	a5,0x16
    80003728:	f207a423          	sw	zero,-216(a5) # 8001964c <log+0x2c>
  write_head(); // clear the log
    8000372c:	00000097          	auipc	ra,0x0
    80003730:	e34080e7          	jalr	-460(ra) # 80003560 <write_head>
}
    80003734:	70a2                	ld	ra,40(sp)
    80003736:	7402                	ld	s0,32(sp)
    80003738:	64e2                	ld	s1,24(sp)
    8000373a:	6942                	ld	s2,16(sp)
    8000373c:	69a2                	ld	s3,8(sp)
    8000373e:	6145                	addi	sp,sp,48
    80003740:	8082                	ret

0000000080003742 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003742:	1101                	addi	sp,sp,-32
    80003744:	ec06                	sd	ra,24(sp)
    80003746:	e822                	sd	s0,16(sp)
    80003748:	e426                	sd	s1,8(sp)
    8000374a:	e04a                	sd	s2,0(sp)
    8000374c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000374e:	00016517          	auipc	a0,0x16
    80003752:	ed250513          	addi	a0,a0,-302 # 80019620 <log>
    80003756:	00003097          	auipc	ra,0x3
    8000375a:	c78080e7          	jalr	-904(ra) # 800063ce <acquire>
  while(1){
    if(log.committing){
    8000375e:	00016497          	auipc	s1,0x16
    80003762:	ec248493          	addi	s1,s1,-318 # 80019620 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003766:	4979                	li	s2,30
    80003768:	a039                	j	80003776 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000376a:	85a6                	mv	a1,s1
    8000376c:	8526                	mv	a0,s1
    8000376e:	ffffe097          	auipc	ra,0xffffe
    80003772:	da4080e7          	jalr	-604(ra) # 80001512 <sleep>
    if(log.committing){
    80003776:	50dc                	lw	a5,36(s1)
    80003778:	fbed                	bnez	a5,8000376a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000377a:	509c                	lw	a5,32(s1)
    8000377c:	0017871b          	addiw	a4,a5,1
    80003780:	0007069b          	sext.w	a3,a4
    80003784:	0027179b          	slliw	a5,a4,0x2
    80003788:	9fb9                	addw	a5,a5,a4
    8000378a:	0017979b          	slliw	a5,a5,0x1
    8000378e:	54d8                	lw	a4,44(s1)
    80003790:	9fb9                	addw	a5,a5,a4
    80003792:	00f95963          	bge	s2,a5,800037a4 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003796:	85a6                	mv	a1,s1
    80003798:	8526                	mv	a0,s1
    8000379a:	ffffe097          	auipc	ra,0xffffe
    8000379e:	d78080e7          	jalr	-648(ra) # 80001512 <sleep>
    800037a2:	bfd1                	j	80003776 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800037a4:	00016517          	auipc	a0,0x16
    800037a8:	e7c50513          	addi	a0,a0,-388 # 80019620 <log>
    800037ac:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800037ae:	00003097          	auipc	ra,0x3
    800037b2:	cd4080e7          	jalr	-812(ra) # 80006482 <release>
      break;
    }
  }
}
    800037b6:	60e2                	ld	ra,24(sp)
    800037b8:	6442                	ld	s0,16(sp)
    800037ba:	64a2                	ld	s1,8(sp)
    800037bc:	6902                	ld	s2,0(sp)
    800037be:	6105                	addi	sp,sp,32
    800037c0:	8082                	ret

00000000800037c2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037c2:	7139                	addi	sp,sp,-64
    800037c4:	fc06                	sd	ra,56(sp)
    800037c6:	f822                	sd	s0,48(sp)
    800037c8:	f426                	sd	s1,40(sp)
    800037ca:	f04a                	sd	s2,32(sp)
    800037cc:	ec4e                	sd	s3,24(sp)
    800037ce:	e852                	sd	s4,16(sp)
    800037d0:	e456                	sd	s5,8(sp)
    800037d2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037d4:	00016497          	auipc	s1,0x16
    800037d8:	e4c48493          	addi	s1,s1,-436 # 80019620 <log>
    800037dc:	8526                	mv	a0,s1
    800037de:	00003097          	auipc	ra,0x3
    800037e2:	bf0080e7          	jalr	-1040(ra) # 800063ce <acquire>
  log.outstanding -= 1;
    800037e6:	509c                	lw	a5,32(s1)
    800037e8:	37fd                	addiw	a5,a5,-1
    800037ea:	0007891b          	sext.w	s2,a5
    800037ee:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037f0:	50dc                	lw	a5,36(s1)
    800037f2:	efb9                	bnez	a5,80003850 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037f4:	06091663          	bnez	s2,80003860 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800037f8:	00016497          	auipc	s1,0x16
    800037fc:	e2848493          	addi	s1,s1,-472 # 80019620 <log>
    80003800:	4785                	li	a5,1
    80003802:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003804:	8526                	mv	a0,s1
    80003806:	00003097          	auipc	ra,0x3
    8000380a:	c7c080e7          	jalr	-900(ra) # 80006482 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000380e:	54dc                	lw	a5,44(s1)
    80003810:	06f04763          	bgtz	a5,8000387e <end_op+0xbc>
    acquire(&log.lock);
    80003814:	00016497          	auipc	s1,0x16
    80003818:	e0c48493          	addi	s1,s1,-500 # 80019620 <log>
    8000381c:	8526                	mv	a0,s1
    8000381e:	00003097          	auipc	ra,0x3
    80003822:	bb0080e7          	jalr	-1104(ra) # 800063ce <acquire>
    log.committing = 0;
    80003826:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000382a:	8526                	mv	a0,s1
    8000382c:	ffffe097          	auipc	ra,0xffffe
    80003830:	e72080e7          	jalr	-398(ra) # 8000169e <wakeup>
    release(&log.lock);
    80003834:	8526                	mv	a0,s1
    80003836:	00003097          	auipc	ra,0x3
    8000383a:	c4c080e7          	jalr	-948(ra) # 80006482 <release>
}
    8000383e:	70e2                	ld	ra,56(sp)
    80003840:	7442                	ld	s0,48(sp)
    80003842:	74a2                	ld	s1,40(sp)
    80003844:	7902                	ld	s2,32(sp)
    80003846:	69e2                	ld	s3,24(sp)
    80003848:	6a42                	ld	s4,16(sp)
    8000384a:	6aa2                	ld	s5,8(sp)
    8000384c:	6121                	addi	sp,sp,64
    8000384e:	8082                	ret
    panic("log.committing");
    80003850:	00005517          	auipc	a0,0x5
    80003854:	d8850513          	addi	a0,a0,-632 # 800085d8 <syscalls+0x210>
    80003858:	00002097          	auipc	ra,0x2
    8000385c:	5d0080e7          	jalr	1488(ra) # 80005e28 <panic>
    wakeup(&log);
    80003860:	00016497          	auipc	s1,0x16
    80003864:	dc048493          	addi	s1,s1,-576 # 80019620 <log>
    80003868:	8526                	mv	a0,s1
    8000386a:	ffffe097          	auipc	ra,0xffffe
    8000386e:	e34080e7          	jalr	-460(ra) # 8000169e <wakeup>
  release(&log.lock);
    80003872:	8526                	mv	a0,s1
    80003874:	00003097          	auipc	ra,0x3
    80003878:	c0e080e7          	jalr	-1010(ra) # 80006482 <release>
  if(do_commit){
    8000387c:	b7c9                	j	8000383e <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000387e:	00016a97          	auipc	s5,0x16
    80003882:	dd2a8a93          	addi	s5,s5,-558 # 80019650 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003886:	00016a17          	auipc	s4,0x16
    8000388a:	d9aa0a13          	addi	s4,s4,-614 # 80019620 <log>
    8000388e:	018a2583          	lw	a1,24(s4)
    80003892:	012585bb          	addw	a1,a1,s2
    80003896:	2585                	addiw	a1,a1,1
    80003898:	028a2503          	lw	a0,40(s4)
    8000389c:	fffff097          	auipc	ra,0xfffff
    800038a0:	cd2080e7          	jalr	-814(ra) # 8000256e <bread>
    800038a4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800038a6:	000aa583          	lw	a1,0(s5)
    800038aa:	028a2503          	lw	a0,40(s4)
    800038ae:	fffff097          	auipc	ra,0xfffff
    800038b2:	cc0080e7          	jalr	-832(ra) # 8000256e <bread>
    800038b6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038b8:	40000613          	li	a2,1024
    800038bc:	05850593          	addi	a1,a0,88
    800038c0:	05848513          	addi	a0,s1,88
    800038c4:	ffffd097          	auipc	ra,0xffffd
    800038c8:	914080e7          	jalr	-1772(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800038cc:	8526                	mv	a0,s1
    800038ce:	fffff097          	auipc	ra,0xfffff
    800038d2:	d92080e7          	jalr	-622(ra) # 80002660 <bwrite>
    brelse(from);
    800038d6:	854e                	mv	a0,s3
    800038d8:	fffff097          	auipc	ra,0xfffff
    800038dc:	dc6080e7          	jalr	-570(ra) # 8000269e <brelse>
    brelse(to);
    800038e0:	8526                	mv	a0,s1
    800038e2:	fffff097          	auipc	ra,0xfffff
    800038e6:	dbc080e7          	jalr	-580(ra) # 8000269e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038ea:	2905                	addiw	s2,s2,1
    800038ec:	0a91                	addi	s5,s5,4
    800038ee:	02ca2783          	lw	a5,44(s4)
    800038f2:	f8f94ee3          	blt	s2,a5,8000388e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038f6:	00000097          	auipc	ra,0x0
    800038fa:	c6a080e7          	jalr	-918(ra) # 80003560 <write_head>
    install_trans(0); // Now install writes to home locations
    800038fe:	4501                	li	a0,0
    80003900:	00000097          	auipc	ra,0x0
    80003904:	cda080e7          	jalr	-806(ra) # 800035da <install_trans>
    log.lh.n = 0;
    80003908:	00016797          	auipc	a5,0x16
    8000390c:	d407a223          	sw	zero,-700(a5) # 8001964c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003910:	00000097          	auipc	ra,0x0
    80003914:	c50080e7          	jalr	-944(ra) # 80003560 <write_head>
    80003918:	bdf5                	j	80003814 <end_op+0x52>

000000008000391a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000391a:	1101                	addi	sp,sp,-32
    8000391c:	ec06                	sd	ra,24(sp)
    8000391e:	e822                	sd	s0,16(sp)
    80003920:	e426                	sd	s1,8(sp)
    80003922:	e04a                	sd	s2,0(sp)
    80003924:	1000                	addi	s0,sp,32
    80003926:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003928:	00016917          	auipc	s2,0x16
    8000392c:	cf890913          	addi	s2,s2,-776 # 80019620 <log>
    80003930:	854a                	mv	a0,s2
    80003932:	00003097          	auipc	ra,0x3
    80003936:	a9c080e7          	jalr	-1380(ra) # 800063ce <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000393a:	02c92603          	lw	a2,44(s2)
    8000393e:	47f5                	li	a5,29
    80003940:	06c7c563          	blt	a5,a2,800039aa <log_write+0x90>
    80003944:	00016797          	auipc	a5,0x16
    80003948:	cf87a783          	lw	a5,-776(a5) # 8001963c <log+0x1c>
    8000394c:	37fd                	addiw	a5,a5,-1
    8000394e:	04f65e63          	bge	a2,a5,800039aa <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003952:	00016797          	auipc	a5,0x16
    80003956:	cee7a783          	lw	a5,-786(a5) # 80019640 <log+0x20>
    8000395a:	06f05063          	blez	a5,800039ba <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000395e:	4781                	li	a5,0
    80003960:	06c05563          	blez	a2,800039ca <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003964:	44cc                	lw	a1,12(s1)
    80003966:	00016717          	auipc	a4,0x16
    8000396a:	cea70713          	addi	a4,a4,-790 # 80019650 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000396e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003970:	4314                	lw	a3,0(a4)
    80003972:	04b68c63          	beq	a3,a1,800039ca <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003976:	2785                	addiw	a5,a5,1
    80003978:	0711                	addi	a4,a4,4
    8000397a:	fef61be3          	bne	a2,a5,80003970 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000397e:	0621                	addi	a2,a2,8
    80003980:	060a                	slli	a2,a2,0x2
    80003982:	00016797          	auipc	a5,0x16
    80003986:	c9e78793          	addi	a5,a5,-866 # 80019620 <log>
    8000398a:	963e                	add	a2,a2,a5
    8000398c:	44dc                	lw	a5,12(s1)
    8000398e:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003990:	8526                	mv	a0,s1
    80003992:	fffff097          	auipc	ra,0xfffff
    80003996:	daa080e7          	jalr	-598(ra) # 8000273c <bpin>
    log.lh.n++;
    8000399a:	00016717          	auipc	a4,0x16
    8000399e:	c8670713          	addi	a4,a4,-890 # 80019620 <log>
    800039a2:	575c                	lw	a5,44(a4)
    800039a4:	2785                	addiw	a5,a5,1
    800039a6:	d75c                	sw	a5,44(a4)
    800039a8:	a835                	j	800039e4 <log_write+0xca>
    panic("too big a transaction");
    800039aa:	00005517          	auipc	a0,0x5
    800039ae:	c3e50513          	addi	a0,a0,-962 # 800085e8 <syscalls+0x220>
    800039b2:	00002097          	auipc	ra,0x2
    800039b6:	476080e7          	jalr	1142(ra) # 80005e28 <panic>
    panic("log_write outside of trans");
    800039ba:	00005517          	auipc	a0,0x5
    800039be:	c4650513          	addi	a0,a0,-954 # 80008600 <syscalls+0x238>
    800039c2:	00002097          	auipc	ra,0x2
    800039c6:	466080e7          	jalr	1126(ra) # 80005e28 <panic>
  log.lh.block[i] = b->blockno;
    800039ca:	00878713          	addi	a4,a5,8
    800039ce:	00271693          	slli	a3,a4,0x2
    800039d2:	00016717          	auipc	a4,0x16
    800039d6:	c4e70713          	addi	a4,a4,-946 # 80019620 <log>
    800039da:	9736                	add	a4,a4,a3
    800039dc:	44d4                	lw	a3,12(s1)
    800039de:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039e0:	faf608e3          	beq	a2,a5,80003990 <log_write+0x76>
  }
  release(&log.lock);
    800039e4:	00016517          	auipc	a0,0x16
    800039e8:	c3c50513          	addi	a0,a0,-964 # 80019620 <log>
    800039ec:	00003097          	auipc	ra,0x3
    800039f0:	a96080e7          	jalr	-1386(ra) # 80006482 <release>
}
    800039f4:	60e2                	ld	ra,24(sp)
    800039f6:	6442                	ld	s0,16(sp)
    800039f8:	64a2                	ld	s1,8(sp)
    800039fa:	6902                	ld	s2,0(sp)
    800039fc:	6105                	addi	sp,sp,32
    800039fe:	8082                	ret

0000000080003a00 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a00:	1101                	addi	sp,sp,-32
    80003a02:	ec06                	sd	ra,24(sp)
    80003a04:	e822                	sd	s0,16(sp)
    80003a06:	e426                	sd	s1,8(sp)
    80003a08:	e04a                	sd	s2,0(sp)
    80003a0a:	1000                	addi	s0,sp,32
    80003a0c:	84aa                	mv	s1,a0
    80003a0e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a10:	00005597          	auipc	a1,0x5
    80003a14:	c1058593          	addi	a1,a1,-1008 # 80008620 <syscalls+0x258>
    80003a18:	0521                	addi	a0,a0,8
    80003a1a:	00003097          	auipc	ra,0x3
    80003a1e:	924080e7          	jalr	-1756(ra) # 8000633e <initlock>
  lk->name = name;
    80003a22:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a26:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a2a:	0204a423          	sw	zero,40(s1)
}
    80003a2e:	60e2                	ld	ra,24(sp)
    80003a30:	6442                	ld	s0,16(sp)
    80003a32:	64a2                	ld	s1,8(sp)
    80003a34:	6902                	ld	s2,0(sp)
    80003a36:	6105                	addi	sp,sp,32
    80003a38:	8082                	ret

0000000080003a3a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a3a:	1101                	addi	sp,sp,-32
    80003a3c:	ec06                	sd	ra,24(sp)
    80003a3e:	e822                	sd	s0,16(sp)
    80003a40:	e426                	sd	s1,8(sp)
    80003a42:	e04a                	sd	s2,0(sp)
    80003a44:	1000                	addi	s0,sp,32
    80003a46:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a48:	00850913          	addi	s2,a0,8
    80003a4c:	854a                	mv	a0,s2
    80003a4e:	00003097          	auipc	ra,0x3
    80003a52:	980080e7          	jalr	-1664(ra) # 800063ce <acquire>
  while (lk->locked) {
    80003a56:	409c                	lw	a5,0(s1)
    80003a58:	cb89                	beqz	a5,80003a6a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a5a:	85ca                	mv	a1,s2
    80003a5c:	8526                	mv	a0,s1
    80003a5e:	ffffe097          	auipc	ra,0xffffe
    80003a62:	ab4080e7          	jalr	-1356(ra) # 80001512 <sleep>
  while (lk->locked) {
    80003a66:	409c                	lw	a5,0(s1)
    80003a68:	fbed                	bnez	a5,80003a5a <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a6a:	4785                	li	a5,1
    80003a6c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a6e:	ffffd097          	auipc	ra,0xffffd
    80003a72:	3da080e7          	jalr	986(ra) # 80000e48 <myproc>
    80003a76:	591c                	lw	a5,48(a0)
    80003a78:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a7a:	854a                	mv	a0,s2
    80003a7c:	00003097          	auipc	ra,0x3
    80003a80:	a06080e7          	jalr	-1530(ra) # 80006482 <release>
}
    80003a84:	60e2                	ld	ra,24(sp)
    80003a86:	6442                	ld	s0,16(sp)
    80003a88:	64a2                	ld	s1,8(sp)
    80003a8a:	6902                	ld	s2,0(sp)
    80003a8c:	6105                	addi	sp,sp,32
    80003a8e:	8082                	ret

0000000080003a90 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a90:	1101                	addi	sp,sp,-32
    80003a92:	ec06                	sd	ra,24(sp)
    80003a94:	e822                	sd	s0,16(sp)
    80003a96:	e426                	sd	s1,8(sp)
    80003a98:	e04a                	sd	s2,0(sp)
    80003a9a:	1000                	addi	s0,sp,32
    80003a9c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a9e:	00850913          	addi	s2,a0,8
    80003aa2:	854a                	mv	a0,s2
    80003aa4:	00003097          	auipc	ra,0x3
    80003aa8:	92a080e7          	jalr	-1750(ra) # 800063ce <acquire>
  lk->locked = 0;
    80003aac:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ab0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003ab4:	8526                	mv	a0,s1
    80003ab6:	ffffe097          	auipc	ra,0xffffe
    80003aba:	be8080e7          	jalr	-1048(ra) # 8000169e <wakeup>
  release(&lk->lk);
    80003abe:	854a                	mv	a0,s2
    80003ac0:	00003097          	auipc	ra,0x3
    80003ac4:	9c2080e7          	jalr	-1598(ra) # 80006482 <release>
}
    80003ac8:	60e2                	ld	ra,24(sp)
    80003aca:	6442                	ld	s0,16(sp)
    80003acc:	64a2                	ld	s1,8(sp)
    80003ace:	6902                	ld	s2,0(sp)
    80003ad0:	6105                	addi	sp,sp,32
    80003ad2:	8082                	ret

0000000080003ad4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ad4:	7179                	addi	sp,sp,-48
    80003ad6:	f406                	sd	ra,40(sp)
    80003ad8:	f022                	sd	s0,32(sp)
    80003ada:	ec26                	sd	s1,24(sp)
    80003adc:	e84a                	sd	s2,16(sp)
    80003ade:	e44e                	sd	s3,8(sp)
    80003ae0:	1800                	addi	s0,sp,48
    80003ae2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003ae4:	00850913          	addi	s2,a0,8
    80003ae8:	854a                	mv	a0,s2
    80003aea:	00003097          	auipc	ra,0x3
    80003aee:	8e4080e7          	jalr	-1820(ra) # 800063ce <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003af2:	409c                	lw	a5,0(s1)
    80003af4:	ef99                	bnez	a5,80003b12 <holdingsleep+0x3e>
    80003af6:	4481                	li	s1,0
  release(&lk->lk);
    80003af8:	854a                	mv	a0,s2
    80003afa:	00003097          	auipc	ra,0x3
    80003afe:	988080e7          	jalr	-1656(ra) # 80006482 <release>
  return r;
}
    80003b02:	8526                	mv	a0,s1
    80003b04:	70a2                	ld	ra,40(sp)
    80003b06:	7402                	ld	s0,32(sp)
    80003b08:	64e2                	ld	s1,24(sp)
    80003b0a:	6942                	ld	s2,16(sp)
    80003b0c:	69a2                	ld	s3,8(sp)
    80003b0e:	6145                	addi	sp,sp,48
    80003b10:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b12:	0284a983          	lw	s3,40(s1)
    80003b16:	ffffd097          	auipc	ra,0xffffd
    80003b1a:	332080e7          	jalr	818(ra) # 80000e48 <myproc>
    80003b1e:	5904                	lw	s1,48(a0)
    80003b20:	413484b3          	sub	s1,s1,s3
    80003b24:	0014b493          	seqz	s1,s1
    80003b28:	bfc1                	j	80003af8 <holdingsleep+0x24>

0000000080003b2a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b2a:	1141                	addi	sp,sp,-16
    80003b2c:	e406                	sd	ra,8(sp)
    80003b2e:	e022                	sd	s0,0(sp)
    80003b30:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b32:	00005597          	auipc	a1,0x5
    80003b36:	afe58593          	addi	a1,a1,-1282 # 80008630 <syscalls+0x268>
    80003b3a:	00016517          	auipc	a0,0x16
    80003b3e:	c2e50513          	addi	a0,a0,-978 # 80019768 <ftable>
    80003b42:	00002097          	auipc	ra,0x2
    80003b46:	7fc080e7          	jalr	2044(ra) # 8000633e <initlock>
}
    80003b4a:	60a2                	ld	ra,8(sp)
    80003b4c:	6402                	ld	s0,0(sp)
    80003b4e:	0141                	addi	sp,sp,16
    80003b50:	8082                	ret

0000000080003b52 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b52:	1101                	addi	sp,sp,-32
    80003b54:	ec06                	sd	ra,24(sp)
    80003b56:	e822                	sd	s0,16(sp)
    80003b58:	e426                	sd	s1,8(sp)
    80003b5a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b5c:	00016517          	auipc	a0,0x16
    80003b60:	c0c50513          	addi	a0,a0,-1012 # 80019768 <ftable>
    80003b64:	00003097          	auipc	ra,0x3
    80003b68:	86a080e7          	jalr	-1942(ra) # 800063ce <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b6c:	00016497          	auipc	s1,0x16
    80003b70:	c1448493          	addi	s1,s1,-1004 # 80019780 <ftable+0x18>
    80003b74:	00017717          	auipc	a4,0x17
    80003b78:	bac70713          	addi	a4,a4,-1108 # 8001a720 <ftable+0xfb8>
    if(f->ref == 0){
    80003b7c:	40dc                	lw	a5,4(s1)
    80003b7e:	cf99                	beqz	a5,80003b9c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b80:	02848493          	addi	s1,s1,40
    80003b84:	fee49ce3          	bne	s1,a4,80003b7c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b88:	00016517          	auipc	a0,0x16
    80003b8c:	be050513          	addi	a0,a0,-1056 # 80019768 <ftable>
    80003b90:	00003097          	auipc	ra,0x3
    80003b94:	8f2080e7          	jalr	-1806(ra) # 80006482 <release>
  return 0;
    80003b98:	4481                	li	s1,0
    80003b9a:	a819                	j	80003bb0 <filealloc+0x5e>
      f->ref = 1;
    80003b9c:	4785                	li	a5,1
    80003b9e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003ba0:	00016517          	auipc	a0,0x16
    80003ba4:	bc850513          	addi	a0,a0,-1080 # 80019768 <ftable>
    80003ba8:	00003097          	auipc	ra,0x3
    80003bac:	8da080e7          	jalr	-1830(ra) # 80006482 <release>
}
    80003bb0:	8526                	mv	a0,s1
    80003bb2:	60e2                	ld	ra,24(sp)
    80003bb4:	6442                	ld	s0,16(sp)
    80003bb6:	64a2                	ld	s1,8(sp)
    80003bb8:	6105                	addi	sp,sp,32
    80003bba:	8082                	ret

0000000080003bbc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003bbc:	1101                	addi	sp,sp,-32
    80003bbe:	ec06                	sd	ra,24(sp)
    80003bc0:	e822                	sd	s0,16(sp)
    80003bc2:	e426                	sd	s1,8(sp)
    80003bc4:	1000                	addi	s0,sp,32
    80003bc6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bc8:	00016517          	auipc	a0,0x16
    80003bcc:	ba050513          	addi	a0,a0,-1120 # 80019768 <ftable>
    80003bd0:	00002097          	auipc	ra,0x2
    80003bd4:	7fe080e7          	jalr	2046(ra) # 800063ce <acquire>
  if(f->ref < 1)
    80003bd8:	40dc                	lw	a5,4(s1)
    80003bda:	02f05263          	blez	a5,80003bfe <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003bde:	2785                	addiw	a5,a5,1
    80003be0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003be2:	00016517          	auipc	a0,0x16
    80003be6:	b8650513          	addi	a0,a0,-1146 # 80019768 <ftable>
    80003bea:	00003097          	auipc	ra,0x3
    80003bee:	898080e7          	jalr	-1896(ra) # 80006482 <release>
  return f;
}
    80003bf2:	8526                	mv	a0,s1
    80003bf4:	60e2                	ld	ra,24(sp)
    80003bf6:	6442                	ld	s0,16(sp)
    80003bf8:	64a2                	ld	s1,8(sp)
    80003bfa:	6105                	addi	sp,sp,32
    80003bfc:	8082                	ret
    panic("filedup");
    80003bfe:	00005517          	auipc	a0,0x5
    80003c02:	a3a50513          	addi	a0,a0,-1478 # 80008638 <syscalls+0x270>
    80003c06:	00002097          	auipc	ra,0x2
    80003c0a:	222080e7          	jalr	546(ra) # 80005e28 <panic>

0000000080003c0e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c0e:	7139                	addi	sp,sp,-64
    80003c10:	fc06                	sd	ra,56(sp)
    80003c12:	f822                	sd	s0,48(sp)
    80003c14:	f426                	sd	s1,40(sp)
    80003c16:	f04a                	sd	s2,32(sp)
    80003c18:	ec4e                	sd	s3,24(sp)
    80003c1a:	e852                	sd	s4,16(sp)
    80003c1c:	e456                	sd	s5,8(sp)
    80003c1e:	0080                	addi	s0,sp,64
    80003c20:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c22:	00016517          	auipc	a0,0x16
    80003c26:	b4650513          	addi	a0,a0,-1210 # 80019768 <ftable>
    80003c2a:	00002097          	auipc	ra,0x2
    80003c2e:	7a4080e7          	jalr	1956(ra) # 800063ce <acquire>
  if(f->ref < 1)
    80003c32:	40dc                	lw	a5,4(s1)
    80003c34:	06f05163          	blez	a5,80003c96 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c38:	37fd                	addiw	a5,a5,-1
    80003c3a:	0007871b          	sext.w	a4,a5
    80003c3e:	c0dc                	sw	a5,4(s1)
    80003c40:	06e04363          	bgtz	a4,80003ca6 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c44:	0004a903          	lw	s2,0(s1)
    80003c48:	0094ca83          	lbu	s5,9(s1)
    80003c4c:	0104ba03          	ld	s4,16(s1)
    80003c50:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c54:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c58:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c5c:	00016517          	auipc	a0,0x16
    80003c60:	b0c50513          	addi	a0,a0,-1268 # 80019768 <ftable>
    80003c64:	00003097          	auipc	ra,0x3
    80003c68:	81e080e7          	jalr	-2018(ra) # 80006482 <release>

  if(ff.type == FD_PIPE){
    80003c6c:	4785                	li	a5,1
    80003c6e:	04f90d63          	beq	s2,a5,80003cc8 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c72:	3979                	addiw	s2,s2,-2
    80003c74:	4785                	li	a5,1
    80003c76:	0527e063          	bltu	a5,s2,80003cb6 <fileclose+0xa8>
    begin_op();
    80003c7a:	00000097          	auipc	ra,0x0
    80003c7e:	ac8080e7          	jalr	-1336(ra) # 80003742 <begin_op>
    iput(ff.ip);
    80003c82:	854e                	mv	a0,s3
    80003c84:	fffff097          	auipc	ra,0xfffff
    80003c88:	2a6080e7          	jalr	678(ra) # 80002f2a <iput>
    end_op();
    80003c8c:	00000097          	auipc	ra,0x0
    80003c90:	b36080e7          	jalr	-1226(ra) # 800037c2 <end_op>
    80003c94:	a00d                	j	80003cb6 <fileclose+0xa8>
    panic("fileclose");
    80003c96:	00005517          	auipc	a0,0x5
    80003c9a:	9aa50513          	addi	a0,a0,-1622 # 80008640 <syscalls+0x278>
    80003c9e:	00002097          	auipc	ra,0x2
    80003ca2:	18a080e7          	jalr	394(ra) # 80005e28 <panic>
    release(&ftable.lock);
    80003ca6:	00016517          	auipc	a0,0x16
    80003caa:	ac250513          	addi	a0,a0,-1342 # 80019768 <ftable>
    80003cae:	00002097          	auipc	ra,0x2
    80003cb2:	7d4080e7          	jalr	2004(ra) # 80006482 <release>
  }
}
    80003cb6:	70e2                	ld	ra,56(sp)
    80003cb8:	7442                	ld	s0,48(sp)
    80003cba:	74a2                	ld	s1,40(sp)
    80003cbc:	7902                	ld	s2,32(sp)
    80003cbe:	69e2                	ld	s3,24(sp)
    80003cc0:	6a42                	ld	s4,16(sp)
    80003cc2:	6aa2                	ld	s5,8(sp)
    80003cc4:	6121                	addi	sp,sp,64
    80003cc6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003cc8:	85d6                	mv	a1,s5
    80003cca:	8552                	mv	a0,s4
    80003ccc:	00000097          	auipc	ra,0x0
    80003cd0:	34c080e7          	jalr	844(ra) # 80004018 <pipeclose>
    80003cd4:	b7cd                	j	80003cb6 <fileclose+0xa8>

0000000080003cd6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003cd6:	715d                	addi	sp,sp,-80
    80003cd8:	e486                	sd	ra,72(sp)
    80003cda:	e0a2                	sd	s0,64(sp)
    80003cdc:	fc26                	sd	s1,56(sp)
    80003cde:	f84a                	sd	s2,48(sp)
    80003ce0:	f44e                	sd	s3,40(sp)
    80003ce2:	0880                	addi	s0,sp,80
    80003ce4:	84aa                	mv	s1,a0
    80003ce6:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003ce8:	ffffd097          	auipc	ra,0xffffd
    80003cec:	160080e7          	jalr	352(ra) # 80000e48 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003cf0:	409c                	lw	a5,0(s1)
    80003cf2:	37f9                	addiw	a5,a5,-2
    80003cf4:	4705                	li	a4,1
    80003cf6:	04f76763          	bltu	a4,a5,80003d44 <filestat+0x6e>
    80003cfa:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cfc:	6c88                	ld	a0,24(s1)
    80003cfe:	fffff097          	auipc	ra,0xfffff
    80003d02:	072080e7          	jalr	114(ra) # 80002d70 <ilock>
    stati(f->ip, &st);
    80003d06:	fb840593          	addi	a1,s0,-72
    80003d0a:	6c88                	ld	a0,24(s1)
    80003d0c:	fffff097          	auipc	ra,0xfffff
    80003d10:	2ee080e7          	jalr	750(ra) # 80002ffa <stati>
    iunlock(f->ip);
    80003d14:	6c88                	ld	a0,24(s1)
    80003d16:	fffff097          	auipc	ra,0xfffff
    80003d1a:	11c080e7          	jalr	284(ra) # 80002e32 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d1e:	46e1                	li	a3,24
    80003d20:	fb840613          	addi	a2,s0,-72
    80003d24:	85ce                	mv	a1,s3
    80003d26:	05093503          	ld	a0,80(s2)
    80003d2a:	ffffd097          	auipc	ra,0xffffd
    80003d2e:	de0080e7          	jalr	-544(ra) # 80000b0a <copyout>
    80003d32:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d36:	60a6                	ld	ra,72(sp)
    80003d38:	6406                	ld	s0,64(sp)
    80003d3a:	74e2                	ld	s1,56(sp)
    80003d3c:	7942                	ld	s2,48(sp)
    80003d3e:	79a2                	ld	s3,40(sp)
    80003d40:	6161                	addi	sp,sp,80
    80003d42:	8082                	ret
  return -1;
    80003d44:	557d                	li	a0,-1
    80003d46:	bfc5                	j	80003d36 <filestat+0x60>

0000000080003d48 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d48:	7179                	addi	sp,sp,-48
    80003d4a:	f406                	sd	ra,40(sp)
    80003d4c:	f022                	sd	s0,32(sp)
    80003d4e:	ec26                	sd	s1,24(sp)
    80003d50:	e84a                	sd	s2,16(sp)
    80003d52:	e44e                	sd	s3,8(sp)
    80003d54:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d56:	00854783          	lbu	a5,8(a0)
    80003d5a:	c3d5                	beqz	a5,80003dfe <fileread+0xb6>
    80003d5c:	84aa                	mv	s1,a0
    80003d5e:	89ae                	mv	s3,a1
    80003d60:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d62:	411c                	lw	a5,0(a0)
    80003d64:	4705                	li	a4,1
    80003d66:	04e78963          	beq	a5,a4,80003db8 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d6a:	470d                	li	a4,3
    80003d6c:	04e78d63          	beq	a5,a4,80003dc6 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d70:	4709                	li	a4,2
    80003d72:	06e79e63          	bne	a5,a4,80003dee <fileread+0xa6>
    ilock(f->ip);
    80003d76:	6d08                	ld	a0,24(a0)
    80003d78:	fffff097          	auipc	ra,0xfffff
    80003d7c:	ff8080e7          	jalr	-8(ra) # 80002d70 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d80:	874a                	mv	a4,s2
    80003d82:	5094                	lw	a3,32(s1)
    80003d84:	864e                	mv	a2,s3
    80003d86:	4585                	li	a1,1
    80003d88:	6c88                	ld	a0,24(s1)
    80003d8a:	fffff097          	auipc	ra,0xfffff
    80003d8e:	29a080e7          	jalr	666(ra) # 80003024 <readi>
    80003d92:	892a                	mv	s2,a0
    80003d94:	00a05563          	blez	a0,80003d9e <fileread+0x56>
      f->off += r;
    80003d98:	509c                	lw	a5,32(s1)
    80003d9a:	9fa9                	addw	a5,a5,a0
    80003d9c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d9e:	6c88                	ld	a0,24(s1)
    80003da0:	fffff097          	auipc	ra,0xfffff
    80003da4:	092080e7          	jalr	146(ra) # 80002e32 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003da8:	854a                	mv	a0,s2
    80003daa:	70a2                	ld	ra,40(sp)
    80003dac:	7402                	ld	s0,32(sp)
    80003dae:	64e2                	ld	s1,24(sp)
    80003db0:	6942                	ld	s2,16(sp)
    80003db2:	69a2                	ld	s3,8(sp)
    80003db4:	6145                	addi	sp,sp,48
    80003db6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003db8:	6908                	ld	a0,16(a0)
    80003dba:	00000097          	auipc	ra,0x0
    80003dbe:	3c8080e7          	jalr	968(ra) # 80004182 <piperead>
    80003dc2:	892a                	mv	s2,a0
    80003dc4:	b7d5                	j	80003da8 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003dc6:	02451783          	lh	a5,36(a0)
    80003dca:	03079693          	slli	a3,a5,0x30
    80003dce:	92c1                	srli	a3,a3,0x30
    80003dd0:	4725                	li	a4,9
    80003dd2:	02d76863          	bltu	a4,a3,80003e02 <fileread+0xba>
    80003dd6:	0792                	slli	a5,a5,0x4
    80003dd8:	00016717          	auipc	a4,0x16
    80003ddc:	8f070713          	addi	a4,a4,-1808 # 800196c8 <devsw>
    80003de0:	97ba                	add	a5,a5,a4
    80003de2:	639c                	ld	a5,0(a5)
    80003de4:	c38d                	beqz	a5,80003e06 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003de6:	4505                	li	a0,1
    80003de8:	9782                	jalr	a5
    80003dea:	892a                	mv	s2,a0
    80003dec:	bf75                	j	80003da8 <fileread+0x60>
    panic("fileread");
    80003dee:	00005517          	auipc	a0,0x5
    80003df2:	86250513          	addi	a0,a0,-1950 # 80008650 <syscalls+0x288>
    80003df6:	00002097          	auipc	ra,0x2
    80003dfa:	032080e7          	jalr	50(ra) # 80005e28 <panic>
    return -1;
    80003dfe:	597d                	li	s2,-1
    80003e00:	b765                	j	80003da8 <fileread+0x60>
      return -1;
    80003e02:	597d                	li	s2,-1
    80003e04:	b755                	j	80003da8 <fileread+0x60>
    80003e06:	597d                	li	s2,-1
    80003e08:	b745                	j	80003da8 <fileread+0x60>

0000000080003e0a <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003e0a:	715d                	addi	sp,sp,-80
    80003e0c:	e486                	sd	ra,72(sp)
    80003e0e:	e0a2                	sd	s0,64(sp)
    80003e10:	fc26                	sd	s1,56(sp)
    80003e12:	f84a                	sd	s2,48(sp)
    80003e14:	f44e                	sd	s3,40(sp)
    80003e16:	f052                	sd	s4,32(sp)
    80003e18:	ec56                	sd	s5,24(sp)
    80003e1a:	e85a                	sd	s6,16(sp)
    80003e1c:	e45e                	sd	s7,8(sp)
    80003e1e:	e062                	sd	s8,0(sp)
    80003e20:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e22:	00954783          	lbu	a5,9(a0)
    80003e26:	10078663          	beqz	a5,80003f32 <filewrite+0x128>
    80003e2a:	892a                	mv	s2,a0
    80003e2c:	8aae                	mv	s5,a1
    80003e2e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e30:	411c                	lw	a5,0(a0)
    80003e32:	4705                	li	a4,1
    80003e34:	02e78263          	beq	a5,a4,80003e58 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e38:	470d                	li	a4,3
    80003e3a:	02e78663          	beq	a5,a4,80003e66 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e3e:	4709                	li	a4,2
    80003e40:	0ee79163          	bne	a5,a4,80003f22 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e44:	0ac05d63          	blez	a2,80003efe <filewrite+0xf4>
    int i = 0;
    80003e48:	4981                	li	s3,0
    80003e4a:	6b05                	lui	s6,0x1
    80003e4c:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003e50:	6b85                	lui	s7,0x1
    80003e52:	c00b8b9b          	addiw	s7,s7,-1024
    80003e56:	a861                	j	80003eee <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e58:	6908                	ld	a0,16(a0)
    80003e5a:	00000097          	auipc	ra,0x0
    80003e5e:	22e080e7          	jalr	558(ra) # 80004088 <pipewrite>
    80003e62:	8a2a                	mv	s4,a0
    80003e64:	a045                	j	80003f04 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e66:	02451783          	lh	a5,36(a0)
    80003e6a:	03079693          	slli	a3,a5,0x30
    80003e6e:	92c1                	srli	a3,a3,0x30
    80003e70:	4725                	li	a4,9
    80003e72:	0cd76263          	bltu	a4,a3,80003f36 <filewrite+0x12c>
    80003e76:	0792                	slli	a5,a5,0x4
    80003e78:	00016717          	auipc	a4,0x16
    80003e7c:	85070713          	addi	a4,a4,-1968 # 800196c8 <devsw>
    80003e80:	97ba                	add	a5,a5,a4
    80003e82:	679c                	ld	a5,8(a5)
    80003e84:	cbdd                	beqz	a5,80003f3a <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e86:	4505                	li	a0,1
    80003e88:	9782                	jalr	a5
    80003e8a:	8a2a                	mv	s4,a0
    80003e8c:	a8a5                	j	80003f04 <filewrite+0xfa>
    80003e8e:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e92:	00000097          	auipc	ra,0x0
    80003e96:	8b0080e7          	jalr	-1872(ra) # 80003742 <begin_op>
      ilock(f->ip);
    80003e9a:	01893503          	ld	a0,24(s2)
    80003e9e:	fffff097          	auipc	ra,0xfffff
    80003ea2:	ed2080e7          	jalr	-302(ra) # 80002d70 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ea6:	8762                	mv	a4,s8
    80003ea8:	02092683          	lw	a3,32(s2)
    80003eac:	01598633          	add	a2,s3,s5
    80003eb0:	4585                	li	a1,1
    80003eb2:	01893503          	ld	a0,24(s2)
    80003eb6:	fffff097          	auipc	ra,0xfffff
    80003eba:	266080e7          	jalr	614(ra) # 8000311c <writei>
    80003ebe:	84aa                	mv	s1,a0
    80003ec0:	00a05763          	blez	a0,80003ece <filewrite+0xc4>
        f->off += r;
    80003ec4:	02092783          	lw	a5,32(s2)
    80003ec8:	9fa9                	addw	a5,a5,a0
    80003eca:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ece:	01893503          	ld	a0,24(s2)
    80003ed2:	fffff097          	auipc	ra,0xfffff
    80003ed6:	f60080e7          	jalr	-160(ra) # 80002e32 <iunlock>
      end_op();
    80003eda:	00000097          	auipc	ra,0x0
    80003ede:	8e8080e7          	jalr	-1816(ra) # 800037c2 <end_op>

      if(r != n1){
    80003ee2:	009c1f63          	bne	s8,s1,80003f00 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ee6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003eea:	0149db63          	bge	s3,s4,80003f00 <filewrite+0xf6>
      int n1 = n - i;
    80003eee:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003ef2:	84be                	mv	s1,a5
    80003ef4:	2781                	sext.w	a5,a5
    80003ef6:	f8fb5ce3          	bge	s6,a5,80003e8e <filewrite+0x84>
    80003efa:	84de                	mv	s1,s7
    80003efc:	bf49                	j	80003e8e <filewrite+0x84>
    int i = 0;
    80003efe:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f00:	013a1f63          	bne	s4,s3,80003f1e <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f04:	8552                	mv	a0,s4
    80003f06:	60a6                	ld	ra,72(sp)
    80003f08:	6406                	ld	s0,64(sp)
    80003f0a:	74e2                	ld	s1,56(sp)
    80003f0c:	7942                	ld	s2,48(sp)
    80003f0e:	79a2                	ld	s3,40(sp)
    80003f10:	7a02                	ld	s4,32(sp)
    80003f12:	6ae2                	ld	s5,24(sp)
    80003f14:	6b42                	ld	s6,16(sp)
    80003f16:	6ba2                	ld	s7,8(sp)
    80003f18:	6c02                	ld	s8,0(sp)
    80003f1a:	6161                	addi	sp,sp,80
    80003f1c:	8082                	ret
    ret = (i == n ? n : -1);
    80003f1e:	5a7d                	li	s4,-1
    80003f20:	b7d5                	j	80003f04 <filewrite+0xfa>
    panic("filewrite");
    80003f22:	00004517          	auipc	a0,0x4
    80003f26:	73e50513          	addi	a0,a0,1854 # 80008660 <syscalls+0x298>
    80003f2a:	00002097          	auipc	ra,0x2
    80003f2e:	efe080e7          	jalr	-258(ra) # 80005e28 <panic>
    return -1;
    80003f32:	5a7d                	li	s4,-1
    80003f34:	bfc1                	j	80003f04 <filewrite+0xfa>
      return -1;
    80003f36:	5a7d                	li	s4,-1
    80003f38:	b7f1                	j	80003f04 <filewrite+0xfa>
    80003f3a:	5a7d                	li	s4,-1
    80003f3c:	b7e1                	j	80003f04 <filewrite+0xfa>

0000000080003f3e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f3e:	7179                	addi	sp,sp,-48
    80003f40:	f406                	sd	ra,40(sp)
    80003f42:	f022                	sd	s0,32(sp)
    80003f44:	ec26                	sd	s1,24(sp)
    80003f46:	e84a                	sd	s2,16(sp)
    80003f48:	e44e                	sd	s3,8(sp)
    80003f4a:	e052                	sd	s4,0(sp)
    80003f4c:	1800                	addi	s0,sp,48
    80003f4e:	84aa                	mv	s1,a0
    80003f50:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f52:	0005b023          	sd	zero,0(a1)
    80003f56:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f5a:	00000097          	auipc	ra,0x0
    80003f5e:	bf8080e7          	jalr	-1032(ra) # 80003b52 <filealloc>
    80003f62:	e088                	sd	a0,0(s1)
    80003f64:	c551                	beqz	a0,80003ff0 <pipealloc+0xb2>
    80003f66:	00000097          	auipc	ra,0x0
    80003f6a:	bec080e7          	jalr	-1044(ra) # 80003b52 <filealloc>
    80003f6e:	00aa3023          	sd	a0,0(s4)
    80003f72:	c92d                	beqz	a0,80003fe4 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f74:	ffffc097          	auipc	ra,0xffffc
    80003f78:	1a4080e7          	jalr	420(ra) # 80000118 <kalloc>
    80003f7c:	892a                	mv	s2,a0
    80003f7e:	c125                	beqz	a0,80003fde <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f80:	4985                	li	s3,1
    80003f82:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f86:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f8a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f8e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f92:	00004597          	auipc	a1,0x4
    80003f96:	6de58593          	addi	a1,a1,1758 # 80008670 <syscalls+0x2a8>
    80003f9a:	00002097          	auipc	ra,0x2
    80003f9e:	3a4080e7          	jalr	932(ra) # 8000633e <initlock>
  (*f0)->type = FD_PIPE;
    80003fa2:	609c                	ld	a5,0(s1)
    80003fa4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003fa8:	609c                	ld	a5,0(s1)
    80003faa:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003fae:	609c                	ld	a5,0(s1)
    80003fb0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fb4:	609c                	ld	a5,0(s1)
    80003fb6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003fba:	000a3783          	ld	a5,0(s4)
    80003fbe:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003fc2:	000a3783          	ld	a5,0(s4)
    80003fc6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003fca:	000a3783          	ld	a5,0(s4)
    80003fce:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003fd2:	000a3783          	ld	a5,0(s4)
    80003fd6:	0127b823          	sd	s2,16(a5)
  return 0;
    80003fda:	4501                	li	a0,0
    80003fdc:	a025                	j	80004004 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fde:	6088                	ld	a0,0(s1)
    80003fe0:	e501                	bnez	a0,80003fe8 <pipealloc+0xaa>
    80003fe2:	a039                	j	80003ff0 <pipealloc+0xb2>
    80003fe4:	6088                	ld	a0,0(s1)
    80003fe6:	c51d                	beqz	a0,80004014 <pipealloc+0xd6>
    fileclose(*f0);
    80003fe8:	00000097          	auipc	ra,0x0
    80003fec:	c26080e7          	jalr	-986(ra) # 80003c0e <fileclose>
  if(*f1)
    80003ff0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ff4:	557d                	li	a0,-1
  if(*f1)
    80003ff6:	c799                	beqz	a5,80004004 <pipealloc+0xc6>
    fileclose(*f1);
    80003ff8:	853e                	mv	a0,a5
    80003ffa:	00000097          	auipc	ra,0x0
    80003ffe:	c14080e7          	jalr	-1004(ra) # 80003c0e <fileclose>
  return -1;
    80004002:	557d                	li	a0,-1
}
    80004004:	70a2                	ld	ra,40(sp)
    80004006:	7402                	ld	s0,32(sp)
    80004008:	64e2                	ld	s1,24(sp)
    8000400a:	6942                	ld	s2,16(sp)
    8000400c:	69a2                	ld	s3,8(sp)
    8000400e:	6a02                	ld	s4,0(sp)
    80004010:	6145                	addi	sp,sp,48
    80004012:	8082                	ret
  return -1;
    80004014:	557d                	li	a0,-1
    80004016:	b7fd                	j	80004004 <pipealloc+0xc6>

0000000080004018 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004018:	1101                	addi	sp,sp,-32
    8000401a:	ec06                	sd	ra,24(sp)
    8000401c:	e822                	sd	s0,16(sp)
    8000401e:	e426                	sd	s1,8(sp)
    80004020:	e04a                	sd	s2,0(sp)
    80004022:	1000                	addi	s0,sp,32
    80004024:	84aa                	mv	s1,a0
    80004026:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004028:	00002097          	auipc	ra,0x2
    8000402c:	3a6080e7          	jalr	934(ra) # 800063ce <acquire>
  if(writable){
    80004030:	02090d63          	beqz	s2,8000406a <pipeclose+0x52>
    pi->writeopen = 0;
    80004034:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004038:	21848513          	addi	a0,s1,536
    8000403c:	ffffd097          	auipc	ra,0xffffd
    80004040:	662080e7          	jalr	1634(ra) # 8000169e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004044:	2204b783          	ld	a5,544(s1)
    80004048:	eb95                	bnez	a5,8000407c <pipeclose+0x64>
    release(&pi->lock);
    8000404a:	8526                	mv	a0,s1
    8000404c:	00002097          	auipc	ra,0x2
    80004050:	436080e7          	jalr	1078(ra) # 80006482 <release>
    kfree((char*)pi);
    80004054:	8526                	mv	a0,s1
    80004056:	ffffc097          	auipc	ra,0xffffc
    8000405a:	fc6080e7          	jalr	-58(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000405e:	60e2                	ld	ra,24(sp)
    80004060:	6442                	ld	s0,16(sp)
    80004062:	64a2                	ld	s1,8(sp)
    80004064:	6902                	ld	s2,0(sp)
    80004066:	6105                	addi	sp,sp,32
    80004068:	8082                	ret
    pi->readopen = 0;
    8000406a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000406e:	21c48513          	addi	a0,s1,540
    80004072:	ffffd097          	auipc	ra,0xffffd
    80004076:	62c080e7          	jalr	1580(ra) # 8000169e <wakeup>
    8000407a:	b7e9                	j	80004044 <pipeclose+0x2c>
    release(&pi->lock);
    8000407c:	8526                	mv	a0,s1
    8000407e:	00002097          	auipc	ra,0x2
    80004082:	404080e7          	jalr	1028(ra) # 80006482 <release>
}
    80004086:	bfe1                	j	8000405e <pipeclose+0x46>

0000000080004088 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004088:	7159                	addi	sp,sp,-112
    8000408a:	f486                	sd	ra,104(sp)
    8000408c:	f0a2                	sd	s0,96(sp)
    8000408e:	eca6                	sd	s1,88(sp)
    80004090:	e8ca                	sd	s2,80(sp)
    80004092:	e4ce                	sd	s3,72(sp)
    80004094:	e0d2                	sd	s4,64(sp)
    80004096:	fc56                	sd	s5,56(sp)
    80004098:	f85a                	sd	s6,48(sp)
    8000409a:	f45e                	sd	s7,40(sp)
    8000409c:	f062                	sd	s8,32(sp)
    8000409e:	ec66                	sd	s9,24(sp)
    800040a0:	1880                	addi	s0,sp,112
    800040a2:	84aa                	mv	s1,a0
    800040a4:	8aae                	mv	s5,a1
    800040a6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800040a8:	ffffd097          	auipc	ra,0xffffd
    800040ac:	da0080e7          	jalr	-608(ra) # 80000e48 <myproc>
    800040b0:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040b2:	8526                	mv	a0,s1
    800040b4:	00002097          	auipc	ra,0x2
    800040b8:	31a080e7          	jalr	794(ra) # 800063ce <acquire>
  while(i < n){
    800040bc:	0d405163          	blez	s4,8000417e <pipewrite+0xf6>
    800040c0:	8ba6                	mv	s7,s1
  int i = 0;
    800040c2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040c4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040c6:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800040ca:	21c48c13          	addi	s8,s1,540
    800040ce:	a08d                	j	80004130 <pipewrite+0xa8>
      release(&pi->lock);
    800040d0:	8526                	mv	a0,s1
    800040d2:	00002097          	auipc	ra,0x2
    800040d6:	3b0080e7          	jalr	944(ra) # 80006482 <release>
      return -1;
    800040da:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040dc:	854a                	mv	a0,s2
    800040de:	70a6                	ld	ra,104(sp)
    800040e0:	7406                	ld	s0,96(sp)
    800040e2:	64e6                	ld	s1,88(sp)
    800040e4:	6946                	ld	s2,80(sp)
    800040e6:	69a6                	ld	s3,72(sp)
    800040e8:	6a06                	ld	s4,64(sp)
    800040ea:	7ae2                	ld	s5,56(sp)
    800040ec:	7b42                	ld	s6,48(sp)
    800040ee:	7ba2                	ld	s7,40(sp)
    800040f0:	7c02                	ld	s8,32(sp)
    800040f2:	6ce2                	ld	s9,24(sp)
    800040f4:	6165                	addi	sp,sp,112
    800040f6:	8082                	ret
      wakeup(&pi->nread);
    800040f8:	8566                	mv	a0,s9
    800040fa:	ffffd097          	auipc	ra,0xffffd
    800040fe:	5a4080e7          	jalr	1444(ra) # 8000169e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004102:	85de                	mv	a1,s7
    80004104:	8562                	mv	a0,s8
    80004106:	ffffd097          	auipc	ra,0xffffd
    8000410a:	40c080e7          	jalr	1036(ra) # 80001512 <sleep>
    8000410e:	a839                	j	8000412c <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004110:	21c4a783          	lw	a5,540(s1)
    80004114:	0017871b          	addiw	a4,a5,1
    80004118:	20e4ae23          	sw	a4,540(s1)
    8000411c:	1ff7f793          	andi	a5,a5,511
    80004120:	97a6                	add	a5,a5,s1
    80004122:	f9f44703          	lbu	a4,-97(s0)
    80004126:	00e78c23          	sb	a4,24(a5)
      i++;
    8000412a:	2905                	addiw	s2,s2,1
  while(i < n){
    8000412c:	03495d63          	bge	s2,s4,80004166 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80004130:	2204a783          	lw	a5,544(s1)
    80004134:	dfd1                	beqz	a5,800040d0 <pipewrite+0x48>
    80004136:	0289a783          	lw	a5,40(s3)
    8000413a:	fbd9                	bnez	a5,800040d0 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000413c:	2184a783          	lw	a5,536(s1)
    80004140:	21c4a703          	lw	a4,540(s1)
    80004144:	2007879b          	addiw	a5,a5,512
    80004148:	faf708e3          	beq	a4,a5,800040f8 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000414c:	4685                	li	a3,1
    8000414e:	01590633          	add	a2,s2,s5
    80004152:	f9f40593          	addi	a1,s0,-97
    80004156:	0509b503          	ld	a0,80(s3)
    8000415a:	ffffd097          	auipc	ra,0xffffd
    8000415e:	a3c080e7          	jalr	-1476(ra) # 80000b96 <copyin>
    80004162:	fb6517e3          	bne	a0,s6,80004110 <pipewrite+0x88>
  wakeup(&pi->nread);
    80004166:	21848513          	addi	a0,s1,536
    8000416a:	ffffd097          	auipc	ra,0xffffd
    8000416e:	534080e7          	jalr	1332(ra) # 8000169e <wakeup>
  release(&pi->lock);
    80004172:	8526                	mv	a0,s1
    80004174:	00002097          	auipc	ra,0x2
    80004178:	30e080e7          	jalr	782(ra) # 80006482 <release>
  return i;
    8000417c:	b785                	j	800040dc <pipewrite+0x54>
  int i = 0;
    8000417e:	4901                	li	s2,0
    80004180:	b7dd                	j	80004166 <pipewrite+0xde>

0000000080004182 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004182:	715d                	addi	sp,sp,-80
    80004184:	e486                	sd	ra,72(sp)
    80004186:	e0a2                	sd	s0,64(sp)
    80004188:	fc26                	sd	s1,56(sp)
    8000418a:	f84a                	sd	s2,48(sp)
    8000418c:	f44e                	sd	s3,40(sp)
    8000418e:	f052                	sd	s4,32(sp)
    80004190:	ec56                	sd	s5,24(sp)
    80004192:	e85a                	sd	s6,16(sp)
    80004194:	0880                	addi	s0,sp,80
    80004196:	84aa                	mv	s1,a0
    80004198:	892e                	mv	s2,a1
    8000419a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000419c:	ffffd097          	auipc	ra,0xffffd
    800041a0:	cac080e7          	jalr	-852(ra) # 80000e48 <myproc>
    800041a4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800041a6:	8b26                	mv	s6,s1
    800041a8:	8526                	mv	a0,s1
    800041aa:	00002097          	auipc	ra,0x2
    800041ae:	224080e7          	jalr	548(ra) # 800063ce <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041b2:	2184a703          	lw	a4,536(s1)
    800041b6:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041ba:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041be:	02f71463          	bne	a4,a5,800041e6 <piperead+0x64>
    800041c2:	2244a783          	lw	a5,548(s1)
    800041c6:	c385                	beqz	a5,800041e6 <piperead+0x64>
    if(pr->killed){
    800041c8:	028a2783          	lw	a5,40(s4)
    800041cc:	ebc1                	bnez	a5,8000425c <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041ce:	85da                	mv	a1,s6
    800041d0:	854e                	mv	a0,s3
    800041d2:	ffffd097          	auipc	ra,0xffffd
    800041d6:	340080e7          	jalr	832(ra) # 80001512 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041da:	2184a703          	lw	a4,536(s1)
    800041de:	21c4a783          	lw	a5,540(s1)
    800041e2:	fef700e3          	beq	a4,a5,800041c2 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041e6:	09505263          	blez	s5,8000426a <piperead+0xe8>
    800041ea:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041ec:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800041ee:	2184a783          	lw	a5,536(s1)
    800041f2:	21c4a703          	lw	a4,540(s1)
    800041f6:	02f70d63          	beq	a4,a5,80004230 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041fa:	0017871b          	addiw	a4,a5,1
    800041fe:	20e4ac23          	sw	a4,536(s1)
    80004202:	1ff7f793          	andi	a5,a5,511
    80004206:	97a6                	add	a5,a5,s1
    80004208:	0187c783          	lbu	a5,24(a5)
    8000420c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004210:	4685                	li	a3,1
    80004212:	fbf40613          	addi	a2,s0,-65
    80004216:	85ca                	mv	a1,s2
    80004218:	050a3503          	ld	a0,80(s4)
    8000421c:	ffffd097          	auipc	ra,0xffffd
    80004220:	8ee080e7          	jalr	-1810(ra) # 80000b0a <copyout>
    80004224:	01650663          	beq	a0,s6,80004230 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004228:	2985                	addiw	s3,s3,1
    8000422a:	0905                	addi	s2,s2,1
    8000422c:	fd3a91e3          	bne	s5,s3,800041ee <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004230:	21c48513          	addi	a0,s1,540
    80004234:	ffffd097          	auipc	ra,0xffffd
    80004238:	46a080e7          	jalr	1130(ra) # 8000169e <wakeup>
  release(&pi->lock);
    8000423c:	8526                	mv	a0,s1
    8000423e:	00002097          	auipc	ra,0x2
    80004242:	244080e7          	jalr	580(ra) # 80006482 <release>
  return i;
}
    80004246:	854e                	mv	a0,s3
    80004248:	60a6                	ld	ra,72(sp)
    8000424a:	6406                	ld	s0,64(sp)
    8000424c:	74e2                	ld	s1,56(sp)
    8000424e:	7942                	ld	s2,48(sp)
    80004250:	79a2                	ld	s3,40(sp)
    80004252:	7a02                	ld	s4,32(sp)
    80004254:	6ae2                	ld	s5,24(sp)
    80004256:	6b42                	ld	s6,16(sp)
    80004258:	6161                	addi	sp,sp,80
    8000425a:	8082                	ret
      release(&pi->lock);
    8000425c:	8526                	mv	a0,s1
    8000425e:	00002097          	auipc	ra,0x2
    80004262:	224080e7          	jalr	548(ra) # 80006482 <release>
      return -1;
    80004266:	59fd                	li	s3,-1
    80004268:	bff9                	j	80004246 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000426a:	4981                	li	s3,0
    8000426c:	b7d1                	j	80004230 <piperead+0xae>

000000008000426e <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000426e:	df010113          	addi	sp,sp,-528
    80004272:	20113423          	sd	ra,520(sp)
    80004276:	20813023          	sd	s0,512(sp)
    8000427a:	ffa6                	sd	s1,504(sp)
    8000427c:	fbca                	sd	s2,496(sp)
    8000427e:	f7ce                	sd	s3,488(sp)
    80004280:	f3d2                	sd	s4,480(sp)
    80004282:	efd6                	sd	s5,472(sp)
    80004284:	ebda                	sd	s6,464(sp)
    80004286:	e7de                	sd	s7,456(sp)
    80004288:	e3e2                	sd	s8,448(sp)
    8000428a:	ff66                	sd	s9,440(sp)
    8000428c:	fb6a                	sd	s10,432(sp)
    8000428e:	f76e                	sd	s11,424(sp)
    80004290:	0c00                	addi	s0,sp,528
    80004292:	84aa                	mv	s1,a0
    80004294:	dea43c23          	sd	a0,-520(s0)
    80004298:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000429c:	ffffd097          	auipc	ra,0xffffd
    800042a0:	bac080e7          	jalr	-1108(ra) # 80000e48 <myproc>
    800042a4:	892a                	mv	s2,a0

  begin_op();
    800042a6:	fffff097          	auipc	ra,0xfffff
    800042aa:	49c080e7          	jalr	1180(ra) # 80003742 <begin_op>

  if((ip = namei(path)) == 0){
    800042ae:	8526                	mv	a0,s1
    800042b0:	fffff097          	auipc	ra,0xfffff
    800042b4:	276080e7          	jalr	630(ra) # 80003526 <namei>
    800042b8:	c92d                	beqz	a0,8000432a <exec+0xbc>
    800042ba:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042bc:	fffff097          	auipc	ra,0xfffff
    800042c0:	ab4080e7          	jalr	-1356(ra) # 80002d70 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042c4:	04000713          	li	a4,64
    800042c8:	4681                	li	a3,0
    800042ca:	e5040613          	addi	a2,s0,-432
    800042ce:	4581                	li	a1,0
    800042d0:	8526                	mv	a0,s1
    800042d2:	fffff097          	auipc	ra,0xfffff
    800042d6:	d52080e7          	jalr	-686(ra) # 80003024 <readi>
    800042da:	04000793          	li	a5,64
    800042de:	00f51a63          	bne	a0,a5,800042f2 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800042e2:	e5042703          	lw	a4,-432(s0)
    800042e6:	464c47b7          	lui	a5,0x464c4
    800042ea:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042ee:	04f70463          	beq	a4,a5,80004336 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042f2:	8526                	mv	a0,s1
    800042f4:	fffff097          	auipc	ra,0xfffff
    800042f8:	cde080e7          	jalr	-802(ra) # 80002fd2 <iunlockput>
    end_op();
    800042fc:	fffff097          	auipc	ra,0xfffff
    80004300:	4c6080e7          	jalr	1222(ra) # 800037c2 <end_op>
  }
  return -1;
    80004304:	557d                	li	a0,-1
}
    80004306:	20813083          	ld	ra,520(sp)
    8000430a:	20013403          	ld	s0,512(sp)
    8000430e:	74fe                	ld	s1,504(sp)
    80004310:	795e                	ld	s2,496(sp)
    80004312:	79be                	ld	s3,488(sp)
    80004314:	7a1e                	ld	s4,480(sp)
    80004316:	6afe                	ld	s5,472(sp)
    80004318:	6b5e                	ld	s6,464(sp)
    8000431a:	6bbe                	ld	s7,456(sp)
    8000431c:	6c1e                	ld	s8,448(sp)
    8000431e:	7cfa                	ld	s9,440(sp)
    80004320:	7d5a                	ld	s10,432(sp)
    80004322:	7dba                	ld	s11,424(sp)
    80004324:	21010113          	addi	sp,sp,528
    80004328:	8082                	ret
    end_op();
    8000432a:	fffff097          	auipc	ra,0xfffff
    8000432e:	498080e7          	jalr	1176(ra) # 800037c2 <end_op>
    return -1;
    80004332:	557d                	li	a0,-1
    80004334:	bfc9                	j	80004306 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004336:	854a                	mv	a0,s2
    80004338:	ffffd097          	auipc	ra,0xffffd
    8000433c:	bd4080e7          	jalr	-1068(ra) # 80000f0c <proc_pagetable>
    80004340:	8baa                	mv	s7,a0
    80004342:	d945                	beqz	a0,800042f2 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004344:	e7042983          	lw	s3,-400(s0)
    80004348:	e8845783          	lhu	a5,-376(s0)
    8000434c:	c7ad                	beqz	a5,800043b6 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000434e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004350:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004352:	6c85                	lui	s9,0x1
    80004354:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004358:	def43823          	sd	a5,-528(s0)
    8000435c:	a42d                	j	80004586 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000435e:	00004517          	auipc	a0,0x4
    80004362:	31a50513          	addi	a0,a0,794 # 80008678 <syscalls+0x2b0>
    80004366:	00002097          	auipc	ra,0x2
    8000436a:	ac2080e7          	jalr	-1342(ra) # 80005e28 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000436e:	8756                	mv	a4,s5
    80004370:	012d86bb          	addw	a3,s11,s2
    80004374:	4581                	li	a1,0
    80004376:	8526                	mv	a0,s1
    80004378:	fffff097          	auipc	ra,0xfffff
    8000437c:	cac080e7          	jalr	-852(ra) # 80003024 <readi>
    80004380:	2501                	sext.w	a0,a0
    80004382:	1aaa9963          	bne	s5,a0,80004534 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004386:	6785                	lui	a5,0x1
    80004388:	0127893b          	addw	s2,a5,s2
    8000438c:	77fd                	lui	a5,0xfffff
    8000438e:	01478a3b          	addw	s4,a5,s4
    80004392:	1f897163          	bgeu	s2,s8,80004574 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004396:	02091593          	slli	a1,s2,0x20
    8000439a:	9181                	srli	a1,a1,0x20
    8000439c:	95ea                	add	a1,a1,s10
    8000439e:	855e                	mv	a0,s7
    800043a0:	ffffc097          	auipc	ra,0xffffc
    800043a4:	166080e7          	jalr	358(ra) # 80000506 <walkaddr>
    800043a8:	862a                	mv	a2,a0
    if(pa == 0)
    800043aa:	d955                	beqz	a0,8000435e <exec+0xf0>
      n = PGSIZE;
    800043ac:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800043ae:	fd9a70e3          	bgeu	s4,s9,8000436e <exec+0x100>
      n = sz - i;
    800043b2:	8ad2                	mv	s5,s4
    800043b4:	bf6d                	j	8000436e <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043b6:	4901                	li	s2,0
  iunlockput(ip);
    800043b8:	8526                	mv	a0,s1
    800043ba:	fffff097          	auipc	ra,0xfffff
    800043be:	c18080e7          	jalr	-1000(ra) # 80002fd2 <iunlockput>
  end_op();
    800043c2:	fffff097          	auipc	ra,0xfffff
    800043c6:	400080e7          	jalr	1024(ra) # 800037c2 <end_op>
  p = myproc();
    800043ca:	ffffd097          	auipc	ra,0xffffd
    800043ce:	a7e080e7          	jalr	-1410(ra) # 80000e48 <myproc>
    800043d2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800043d4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800043d8:	6785                	lui	a5,0x1
    800043da:	17fd                	addi	a5,a5,-1
    800043dc:	993e                	add	s2,s2,a5
    800043de:	757d                	lui	a0,0xfffff
    800043e0:	00a977b3          	and	a5,s2,a0
    800043e4:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043e8:	6609                	lui	a2,0x2
    800043ea:	963e                	add	a2,a2,a5
    800043ec:	85be                	mv	a1,a5
    800043ee:	855e                	mv	a0,s7
    800043f0:	ffffc097          	auipc	ra,0xffffc
    800043f4:	4ca080e7          	jalr	1226(ra) # 800008ba <uvmalloc>
    800043f8:	8b2a                	mv	s6,a0
  ip = 0;
    800043fa:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043fc:	12050c63          	beqz	a0,80004534 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004400:	75f9                	lui	a1,0xffffe
    80004402:	95aa                	add	a1,a1,a0
    80004404:	855e                	mv	a0,s7
    80004406:	ffffc097          	auipc	ra,0xffffc
    8000440a:	6d2080e7          	jalr	1746(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    8000440e:	7c7d                	lui	s8,0xfffff
    80004410:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004412:	e0043783          	ld	a5,-512(s0)
    80004416:	6388                	ld	a0,0(a5)
    80004418:	c535                	beqz	a0,80004484 <exec+0x216>
    8000441a:	e9040993          	addi	s3,s0,-368
    8000441e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004422:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004424:	ffffc097          	auipc	ra,0xffffc
    80004428:	ed8080e7          	jalr	-296(ra) # 800002fc <strlen>
    8000442c:	2505                	addiw	a0,a0,1
    8000442e:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004432:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004436:	13896363          	bltu	s2,s8,8000455c <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000443a:	e0043d83          	ld	s11,-512(s0)
    8000443e:	000dba03          	ld	s4,0(s11)
    80004442:	8552                	mv	a0,s4
    80004444:	ffffc097          	auipc	ra,0xffffc
    80004448:	eb8080e7          	jalr	-328(ra) # 800002fc <strlen>
    8000444c:	0015069b          	addiw	a3,a0,1
    80004450:	8652                	mv	a2,s4
    80004452:	85ca                	mv	a1,s2
    80004454:	855e                	mv	a0,s7
    80004456:	ffffc097          	auipc	ra,0xffffc
    8000445a:	6b4080e7          	jalr	1716(ra) # 80000b0a <copyout>
    8000445e:	10054363          	bltz	a0,80004564 <exec+0x2f6>
    ustack[argc] = sp;
    80004462:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004466:	0485                	addi	s1,s1,1
    80004468:	008d8793          	addi	a5,s11,8
    8000446c:	e0f43023          	sd	a5,-512(s0)
    80004470:	008db503          	ld	a0,8(s11)
    80004474:	c911                	beqz	a0,80004488 <exec+0x21a>
    if(argc >= MAXARG)
    80004476:	09a1                	addi	s3,s3,8
    80004478:	fb3c96e3          	bne	s9,s3,80004424 <exec+0x1b6>
  sz = sz1;
    8000447c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004480:	4481                	li	s1,0
    80004482:	a84d                	j	80004534 <exec+0x2c6>
  sp = sz;
    80004484:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004486:	4481                	li	s1,0
  ustack[argc] = 0;
    80004488:	00349793          	slli	a5,s1,0x3
    8000448c:	f9040713          	addi	a4,s0,-112
    80004490:	97ba                	add	a5,a5,a4
    80004492:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004496:	00148693          	addi	a3,s1,1
    8000449a:	068e                	slli	a3,a3,0x3
    8000449c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800044a0:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800044a4:	01897663          	bgeu	s2,s8,800044b0 <exec+0x242>
  sz = sz1;
    800044a8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044ac:	4481                	li	s1,0
    800044ae:	a059                	j	80004534 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800044b0:	e9040613          	addi	a2,s0,-368
    800044b4:	85ca                	mv	a1,s2
    800044b6:	855e                	mv	a0,s7
    800044b8:	ffffc097          	auipc	ra,0xffffc
    800044bc:	652080e7          	jalr	1618(ra) # 80000b0a <copyout>
    800044c0:	0a054663          	bltz	a0,8000456c <exec+0x2fe>
  p->trapframe->a1 = sp;
    800044c4:	070ab783          	ld	a5,112(s5)
    800044c8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044cc:	df843783          	ld	a5,-520(s0)
    800044d0:	0007c703          	lbu	a4,0(a5)
    800044d4:	cf11                	beqz	a4,800044f0 <exec+0x282>
    800044d6:	0785                	addi	a5,a5,1
    if(*s == '/')
    800044d8:	02f00693          	li	a3,47
    800044dc:	a039                	j	800044ea <exec+0x27c>
      last = s+1;
    800044de:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800044e2:	0785                	addi	a5,a5,1
    800044e4:	fff7c703          	lbu	a4,-1(a5)
    800044e8:	c701                	beqz	a4,800044f0 <exec+0x282>
    if(*s == '/')
    800044ea:	fed71ce3          	bne	a4,a3,800044e2 <exec+0x274>
    800044ee:	bfc5                	j	800044de <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800044f0:	4641                	li	a2,16
    800044f2:	df843583          	ld	a1,-520(s0)
    800044f6:	170a8513          	addi	a0,s5,368
    800044fa:	ffffc097          	auipc	ra,0xffffc
    800044fe:	dd0080e7          	jalr	-560(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004502:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004506:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000450a:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000450e:	070ab783          	ld	a5,112(s5)
    80004512:	e6843703          	ld	a4,-408(s0)
    80004516:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004518:	070ab783          	ld	a5,112(s5)
    8000451c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004520:	85ea                	mv	a1,s10
    80004522:	ffffd097          	auipc	ra,0xffffd
    80004526:	a86080e7          	jalr	-1402(ra) # 80000fa8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000452a:	0004851b          	sext.w	a0,s1
    8000452e:	bbe1                	j	80004306 <exec+0x98>
    80004530:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004534:	e0843583          	ld	a1,-504(s0)
    80004538:	855e                	mv	a0,s7
    8000453a:	ffffd097          	auipc	ra,0xffffd
    8000453e:	a6e080e7          	jalr	-1426(ra) # 80000fa8 <proc_freepagetable>
  if(ip){
    80004542:	da0498e3          	bnez	s1,800042f2 <exec+0x84>
  return -1;
    80004546:	557d                	li	a0,-1
    80004548:	bb7d                	j	80004306 <exec+0x98>
    8000454a:	e1243423          	sd	s2,-504(s0)
    8000454e:	b7dd                	j	80004534 <exec+0x2c6>
    80004550:	e1243423          	sd	s2,-504(s0)
    80004554:	b7c5                	j	80004534 <exec+0x2c6>
    80004556:	e1243423          	sd	s2,-504(s0)
    8000455a:	bfe9                	j	80004534 <exec+0x2c6>
  sz = sz1;
    8000455c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004560:	4481                	li	s1,0
    80004562:	bfc9                	j	80004534 <exec+0x2c6>
  sz = sz1;
    80004564:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004568:	4481                	li	s1,0
    8000456a:	b7e9                	j	80004534 <exec+0x2c6>
  sz = sz1;
    8000456c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004570:	4481                	li	s1,0
    80004572:	b7c9                	j	80004534 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004574:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004578:	2b05                	addiw	s6,s6,1
    8000457a:	0389899b          	addiw	s3,s3,56
    8000457e:	e8845783          	lhu	a5,-376(s0)
    80004582:	e2fb5be3          	bge	s6,a5,800043b8 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004586:	2981                	sext.w	s3,s3
    80004588:	03800713          	li	a4,56
    8000458c:	86ce                	mv	a3,s3
    8000458e:	e1840613          	addi	a2,s0,-488
    80004592:	4581                	li	a1,0
    80004594:	8526                	mv	a0,s1
    80004596:	fffff097          	auipc	ra,0xfffff
    8000459a:	a8e080e7          	jalr	-1394(ra) # 80003024 <readi>
    8000459e:	03800793          	li	a5,56
    800045a2:	f8f517e3          	bne	a0,a5,80004530 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800045a6:	e1842783          	lw	a5,-488(s0)
    800045aa:	4705                	li	a4,1
    800045ac:	fce796e3          	bne	a5,a4,80004578 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800045b0:	e4043603          	ld	a2,-448(s0)
    800045b4:	e3843783          	ld	a5,-456(s0)
    800045b8:	f8f669e3          	bltu	a2,a5,8000454a <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045bc:	e2843783          	ld	a5,-472(s0)
    800045c0:	963e                	add	a2,a2,a5
    800045c2:	f8f667e3          	bltu	a2,a5,80004550 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045c6:	85ca                	mv	a1,s2
    800045c8:	855e                	mv	a0,s7
    800045ca:	ffffc097          	auipc	ra,0xffffc
    800045ce:	2f0080e7          	jalr	752(ra) # 800008ba <uvmalloc>
    800045d2:	e0a43423          	sd	a0,-504(s0)
    800045d6:	d141                	beqz	a0,80004556 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    800045d8:	e2843d03          	ld	s10,-472(s0)
    800045dc:	df043783          	ld	a5,-528(s0)
    800045e0:	00fd77b3          	and	a5,s10,a5
    800045e4:	fba1                	bnez	a5,80004534 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800045e6:	e2042d83          	lw	s11,-480(s0)
    800045ea:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045ee:	f80c03e3          	beqz	s8,80004574 <exec+0x306>
    800045f2:	8a62                	mv	s4,s8
    800045f4:	4901                	li	s2,0
    800045f6:	b345                	j	80004396 <exec+0x128>

00000000800045f8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045f8:	7179                	addi	sp,sp,-48
    800045fa:	f406                	sd	ra,40(sp)
    800045fc:	f022                	sd	s0,32(sp)
    800045fe:	ec26                	sd	s1,24(sp)
    80004600:	e84a                	sd	s2,16(sp)
    80004602:	1800                	addi	s0,sp,48
    80004604:	892e                	mv	s2,a1
    80004606:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004608:	fdc40593          	addi	a1,s0,-36
    8000460c:	ffffe097          	auipc	ra,0xffffe
    80004610:	a40080e7          	jalr	-1472(ra) # 8000204c <argint>
    80004614:	04054063          	bltz	a0,80004654 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004618:	fdc42703          	lw	a4,-36(s0)
    8000461c:	47bd                	li	a5,15
    8000461e:	02e7ed63          	bltu	a5,a4,80004658 <argfd+0x60>
    80004622:	ffffd097          	auipc	ra,0xffffd
    80004626:	826080e7          	jalr	-2010(ra) # 80000e48 <myproc>
    8000462a:	fdc42703          	lw	a4,-36(s0)
    8000462e:	01c70793          	addi	a5,a4,28
    80004632:	078e                	slli	a5,a5,0x3
    80004634:	953e                	add	a0,a0,a5
    80004636:	651c                	ld	a5,8(a0)
    80004638:	c395                	beqz	a5,8000465c <argfd+0x64>
    return -1;
  if(pfd)
    8000463a:	00090463          	beqz	s2,80004642 <argfd+0x4a>
    *pfd = fd;
    8000463e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004642:	4501                	li	a0,0
  if(pf)
    80004644:	c091                	beqz	s1,80004648 <argfd+0x50>
    *pf = f;
    80004646:	e09c                	sd	a5,0(s1)
}
    80004648:	70a2                	ld	ra,40(sp)
    8000464a:	7402                	ld	s0,32(sp)
    8000464c:	64e2                	ld	s1,24(sp)
    8000464e:	6942                	ld	s2,16(sp)
    80004650:	6145                	addi	sp,sp,48
    80004652:	8082                	ret
    return -1;
    80004654:	557d                	li	a0,-1
    80004656:	bfcd                	j	80004648 <argfd+0x50>
    return -1;
    80004658:	557d                	li	a0,-1
    8000465a:	b7fd                	j	80004648 <argfd+0x50>
    8000465c:	557d                	li	a0,-1
    8000465e:	b7ed                	j	80004648 <argfd+0x50>

0000000080004660 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004660:	1101                	addi	sp,sp,-32
    80004662:	ec06                	sd	ra,24(sp)
    80004664:	e822                	sd	s0,16(sp)
    80004666:	e426                	sd	s1,8(sp)
    80004668:	1000                	addi	s0,sp,32
    8000466a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000466c:	ffffc097          	auipc	ra,0xffffc
    80004670:	7dc080e7          	jalr	2012(ra) # 80000e48 <myproc>
    80004674:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004676:	0e850793          	addi	a5,a0,232 # fffffffffffff0e8 <end+0xffffffff7ffd8ea8>
    8000467a:	4501                	li	a0,0
    8000467c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000467e:	6398                	ld	a4,0(a5)
    80004680:	cb19                	beqz	a4,80004696 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004682:	2505                	addiw	a0,a0,1
    80004684:	07a1                	addi	a5,a5,8
    80004686:	fed51ce3          	bne	a0,a3,8000467e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000468a:	557d                	li	a0,-1
}
    8000468c:	60e2                	ld	ra,24(sp)
    8000468e:	6442                	ld	s0,16(sp)
    80004690:	64a2                	ld	s1,8(sp)
    80004692:	6105                	addi	sp,sp,32
    80004694:	8082                	ret
      p->ofile[fd] = f;
    80004696:	01c50793          	addi	a5,a0,28
    8000469a:	078e                	slli	a5,a5,0x3
    8000469c:	963e                	add	a2,a2,a5
    8000469e:	e604                	sd	s1,8(a2)
      return fd;
    800046a0:	b7f5                	j	8000468c <fdalloc+0x2c>

00000000800046a2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046a2:	715d                	addi	sp,sp,-80
    800046a4:	e486                	sd	ra,72(sp)
    800046a6:	e0a2                	sd	s0,64(sp)
    800046a8:	fc26                	sd	s1,56(sp)
    800046aa:	f84a                	sd	s2,48(sp)
    800046ac:	f44e                	sd	s3,40(sp)
    800046ae:	f052                	sd	s4,32(sp)
    800046b0:	ec56                	sd	s5,24(sp)
    800046b2:	0880                	addi	s0,sp,80
    800046b4:	89ae                	mv	s3,a1
    800046b6:	8ab2                	mv	s5,a2
    800046b8:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046ba:	fb040593          	addi	a1,s0,-80
    800046be:	fffff097          	auipc	ra,0xfffff
    800046c2:	e86080e7          	jalr	-378(ra) # 80003544 <nameiparent>
    800046c6:	892a                	mv	s2,a0
    800046c8:	12050f63          	beqz	a0,80004806 <create+0x164>
    return 0;

  ilock(dp);
    800046cc:	ffffe097          	auipc	ra,0xffffe
    800046d0:	6a4080e7          	jalr	1700(ra) # 80002d70 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046d4:	4601                	li	a2,0
    800046d6:	fb040593          	addi	a1,s0,-80
    800046da:	854a                	mv	a0,s2
    800046dc:	fffff097          	auipc	ra,0xfffff
    800046e0:	b78080e7          	jalr	-1160(ra) # 80003254 <dirlookup>
    800046e4:	84aa                	mv	s1,a0
    800046e6:	c921                	beqz	a0,80004736 <create+0x94>
    iunlockput(dp);
    800046e8:	854a                	mv	a0,s2
    800046ea:	fffff097          	auipc	ra,0xfffff
    800046ee:	8e8080e7          	jalr	-1816(ra) # 80002fd2 <iunlockput>
    ilock(ip);
    800046f2:	8526                	mv	a0,s1
    800046f4:	ffffe097          	auipc	ra,0xffffe
    800046f8:	67c080e7          	jalr	1660(ra) # 80002d70 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046fc:	2981                	sext.w	s3,s3
    800046fe:	4789                	li	a5,2
    80004700:	02f99463          	bne	s3,a5,80004728 <create+0x86>
    80004704:	0444d783          	lhu	a5,68(s1)
    80004708:	37f9                	addiw	a5,a5,-2
    8000470a:	17c2                	slli	a5,a5,0x30
    8000470c:	93c1                	srli	a5,a5,0x30
    8000470e:	4705                	li	a4,1
    80004710:	00f76c63          	bltu	a4,a5,80004728 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004714:	8526                	mv	a0,s1
    80004716:	60a6                	ld	ra,72(sp)
    80004718:	6406                	ld	s0,64(sp)
    8000471a:	74e2                	ld	s1,56(sp)
    8000471c:	7942                	ld	s2,48(sp)
    8000471e:	79a2                	ld	s3,40(sp)
    80004720:	7a02                	ld	s4,32(sp)
    80004722:	6ae2                	ld	s5,24(sp)
    80004724:	6161                	addi	sp,sp,80
    80004726:	8082                	ret
    iunlockput(ip);
    80004728:	8526                	mv	a0,s1
    8000472a:	fffff097          	auipc	ra,0xfffff
    8000472e:	8a8080e7          	jalr	-1880(ra) # 80002fd2 <iunlockput>
    return 0;
    80004732:	4481                	li	s1,0
    80004734:	b7c5                	j	80004714 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004736:	85ce                	mv	a1,s3
    80004738:	00092503          	lw	a0,0(s2)
    8000473c:	ffffe097          	auipc	ra,0xffffe
    80004740:	49c080e7          	jalr	1180(ra) # 80002bd8 <ialloc>
    80004744:	84aa                	mv	s1,a0
    80004746:	c529                	beqz	a0,80004790 <create+0xee>
  ilock(ip);
    80004748:	ffffe097          	auipc	ra,0xffffe
    8000474c:	628080e7          	jalr	1576(ra) # 80002d70 <ilock>
  ip->major = major;
    80004750:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004754:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004758:	4785                	li	a5,1
    8000475a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000475e:	8526                	mv	a0,s1
    80004760:	ffffe097          	auipc	ra,0xffffe
    80004764:	546080e7          	jalr	1350(ra) # 80002ca6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004768:	2981                	sext.w	s3,s3
    8000476a:	4785                	li	a5,1
    8000476c:	02f98a63          	beq	s3,a5,800047a0 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004770:	40d0                	lw	a2,4(s1)
    80004772:	fb040593          	addi	a1,s0,-80
    80004776:	854a                	mv	a0,s2
    80004778:	fffff097          	auipc	ra,0xfffff
    8000477c:	cec080e7          	jalr	-788(ra) # 80003464 <dirlink>
    80004780:	06054b63          	bltz	a0,800047f6 <create+0x154>
  iunlockput(dp);
    80004784:	854a                	mv	a0,s2
    80004786:	fffff097          	auipc	ra,0xfffff
    8000478a:	84c080e7          	jalr	-1972(ra) # 80002fd2 <iunlockput>
  return ip;
    8000478e:	b759                	j	80004714 <create+0x72>
    panic("create: ialloc");
    80004790:	00004517          	auipc	a0,0x4
    80004794:	f0850513          	addi	a0,a0,-248 # 80008698 <syscalls+0x2d0>
    80004798:	00001097          	auipc	ra,0x1
    8000479c:	690080e7          	jalr	1680(ra) # 80005e28 <panic>
    dp->nlink++;  // for ".."
    800047a0:	04a95783          	lhu	a5,74(s2)
    800047a4:	2785                	addiw	a5,a5,1
    800047a6:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800047aa:	854a                	mv	a0,s2
    800047ac:	ffffe097          	auipc	ra,0xffffe
    800047b0:	4fa080e7          	jalr	1274(ra) # 80002ca6 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047b4:	40d0                	lw	a2,4(s1)
    800047b6:	00004597          	auipc	a1,0x4
    800047ba:	ef258593          	addi	a1,a1,-270 # 800086a8 <syscalls+0x2e0>
    800047be:	8526                	mv	a0,s1
    800047c0:	fffff097          	auipc	ra,0xfffff
    800047c4:	ca4080e7          	jalr	-860(ra) # 80003464 <dirlink>
    800047c8:	00054f63          	bltz	a0,800047e6 <create+0x144>
    800047cc:	00492603          	lw	a2,4(s2)
    800047d0:	00004597          	auipc	a1,0x4
    800047d4:	ee058593          	addi	a1,a1,-288 # 800086b0 <syscalls+0x2e8>
    800047d8:	8526                	mv	a0,s1
    800047da:	fffff097          	auipc	ra,0xfffff
    800047de:	c8a080e7          	jalr	-886(ra) # 80003464 <dirlink>
    800047e2:	f80557e3          	bgez	a0,80004770 <create+0xce>
      panic("create dots");
    800047e6:	00004517          	auipc	a0,0x4
    800047ea:	ed250513          	addi	a0,a0,-302 # 800086b8 <syscalls+0x2f0>
    800047ee:	00001097          	auipc	ra,0x1
    800047f2:	63a080e7          	jalr	1594(ra) # 80005e28 <panic>
    panic("create: dirlink");
    800047f6:	00004517          	auipc	a0,0x4
    800047fa:	ed250513          	addi	a0,a0,-302 # 800086c8 <syscalls+0x300>
    800047fe:	00001097          	auipc	ra,0x1
    80004802:	62a080e7          	jalr	1578(ra) # 80005e28 <panic>
    return 0;
    80004806:	84aa                	mv	s1,a0
    80004808:	b731                	j	80004714 <create+0x72>

000000008000480a <sys_dup>:
{
    8000480a:	7179                	addi	sp,sp,-48
    8000480c:	f406                	sd	ra,40(sp)
    8000480e:	f022                	sd	s0,32(sp)
    80004810:	ec26                	sd	s1,24(sp)
    80004812:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004814:	fd840613          	addi	a2,s0,-40
    80004818:	4581                	li	a1,0
    8000481a:	4501                	li	a0,0
    8000481c:	00000097          	auipc	ra,0x0
    80004820:	ddc080e7          	jalr	-548(ra) # 800045f8 <argfd>
    return -1;
    80004824:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004826:	02054363          	bltz	a0,8000484c <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000482a:	fd843503          	ld	a0,-40(s0)
    8000482e:	00000097          	auipc	ra,0x0
    80004832:	e32080e7          	jalr	-462(ra) # 80004660 <fdalloc>
    80004836:	84aa                	mv	s1,a0
    return -1;
    80004838:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000483a:	00054963          	bltz	a0,8000484c <sys_dup+0x42>
  filedup(f);
    8000483e:	fd843503          	ld	a0,-40(s0)
    80004842:	fffff097          	auipc	ra,0xfffff
    80004846:	37a080e7          	jalr	890(ra) # 80003bbc <filedup>
  return fd;
    8000484a:	87a6                	mv	a5,s1
}
    8000484c:	853e                	mv	a0,a5
    8000484e:	70a2                	ld	ra,40(sp)
    80004850:	7402                	ld	s0,32(sp)
    80004852:	64e2                	ld	s1,24(sp)
    80004854:	6145                	addi	sp,sp,48
    80004856:	8082                	ret

0000000080004858 <sys_read>:
{
    80004858:	7179                	addi	sp,sp,-48
    8000485a:	f406                	sd	ra,40(sp)
    8000485c:	f022                	sd	s0,32(sp)
    8000485e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004860:	fe840613          	addi	a2,s0,-24
    80004864:	4581                	li	a1,0
    80004866:	4501                	li	a0,0
    80004868:	00000097          	auipc	ra,0x0
    8000486c:	d90080e7          	jalr	-624(ra) # 800045f8 <argfd>
    return -1;
    80004870:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004872:	04054163          	bltz	a0,800048b4 <sys_read+0x5c>
    80004876:	fe440593          	addi	a1,s0,-28
    8000487a:	4509                	li	a0,2
    8000487c:	ffffd097          	auipc	ra,0xffffd
    80004880:	7d0080e7          	jalr	2000(ra) # 8000204c <argint>
    return -1;
    80004884:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004886:	02054763          	bltz	a0,800048b4 <sys_read+0x5c>
    8000488a:	fd840593          	addi	a1,s0,-40
    8000488e:	4505                	li	a0,1
    80004890:	ffffd097          	auipc	ra,0xffffd
    80004894:	7de080e7          	jalr	2014(ra) # 8000206e <argaddr>
    return -1;
    80004898:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000489a:	00054d63          	bltz	a0,800048b4 <sys_read+0x5c>
  return fileread(f, p, n);
    8000489e:	fe442603          	lw	a2,-28(s0)
    800048a2:	fd843583          	ld	a1,-40(s0)
    800048a6:	fe843503          	ld	a0,-24(s0)
    800048aa:	fffff097          	auipc	ra,0xfffff
    800048ae:	49e080e7          	jalr	1182(ra) # 80003d48 <fileread>
    800048b2:	87aa                	mv	a5,a0
}
    800048b4:	853e                	mv	a0,a5
    800048b6:	70a2                	ld	ra,40(sp)
    800048b8:	7402                	ld	s0,32(sp)
    800048ba:	6145                	addi	sp,sp,48
    800048bc:	8082                	ret

00000000800048be <sys_write>:
{
    800048be:	7179                	addi	sp,sp,-48
    800048c0:	f406                	sd	ra,40(sp)
    800048c2:	f022                	sd	s0,32(sp)
    800048c4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048c6:	fe840613          	addi	a2,s0,-24
    800048ca:	4581                	li	a1,0
    800048cc:	4501                	li	a0,0
    800048ce:	00000097          	auipc	ra,0x0
    800048d2:	d2a080e7          	jalr	-726(ra) # 800045f8 <argfd>
    return -1;
    800048d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048d8:	04054163          	bltz	a0,8000491a <sys_write+0x5c>
    800048dc:	fe440593          	addi	a1,s0,-28
    800048e0:	4509                	li	a0,2
    800048e2:	ffffd097          	auipc	ra,0xffffd
    800048e6:	76a080e7          	jalr	1898(ra) # 8000204c <argint>
    return -1;
    800048ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048ec:	02054763          	bltz	a0,8000491a <sys_write+0x5c>
    800048f0:	fd840593          	addi	a1,s0,-40
    800048f4:	4505                	li	a0,1
    800048f6:	ffffd097          	auipc	ra,0xffffd
    800048fa:	778080e7          	jalr	1912(ra) # 8000206e <argaddr>
    return -1;
    800048fe:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004900:	00054d63          	bltz	a0,8000491a <sys_write+0x5c>
  return filewrite(f, p, n);
    80004904:	fe442603          	lw	a2,-28(s0)
    80004908:	fd843583          	ld	a1,-40(s0)
    8000490c:	fe843503          	ld	a0,-24(s0)
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	4fa080e7          	jalr	1274(ra) # 80003e0a <filewrite>
    80004918:	87aa                	mv	a5,a0
}
    8000491a:	853e                	mv	a0,a5
    8000491c:	70a2                	ld	ra,40(sp)
    8000491e:	7402                	ld	s0,32(sp)
    80004920:	6145                	addi	sp,sp,48
    80004922:	8082                	ret

0000000080004924 <sys_close>:
{
    80004924:	1101                	addi	sp,sp,-32
    80004926:	ec06                	sd	ra,24(sp)
    80004928:	e822                	sd	s0,16(sp)
    8000492a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000492c:	fe040613          	addi	a2,s0,-32
    80004930:	fec40593          	addi	a1,s0,-20
    80004934:	4501                	li	a0,0
    80004936:	00000097          	auipc	ra,0x0
    8000493a:	cc2080e7          	jalr	-830(ra) # 800045f8 <argfd>
    return -1;
    8000493e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004940:	02054463          	bltz	a0,80004968 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004944:	ffffc097          	auipc	ra,0xffffc
    80004948:	504080e7          	jalr	1284(ra) # 80000e48 <myproc>
    8000494c:	fec42783          	lw	a5,-20(s0)
    80004950:	07f1                	addi	a5,a5,28
    80004952:	078e                	slli	a5,a5,0x3
    80004954:	97aa                	add	a5,a5,a0
    80004956:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    8000495a:	fe043503          	ld	a0,-32(s0)
    8000495e:	fffff097          	auipc	ra,0xfffff
    80004962:	2b0080e7          	jalr	688(ra) # 80003c0e <fileclose>
  return 0;
    80004966:	4781                	li	a5,0
}
    80004968:	853e                	mv	a0,a5
    8000496a:	60e2                	ld	ra,24(sp)
    8000496c:	6442                	ld	s0,16(sp)
    8000496e:	6105                	addi	sp,sp,32
    80004970:	8082                	ret

0000000080004972 <sys_fstat>:
{
    80004972:	1101                	addi	sp,sp,-32
    80004974:	ec06                	sd	ra,24(sp)
    80004976:	e822                	sd	s0,16(sp)
    80004978:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000497a:	fe840613          	addi	a2,s0,-24
    8000497e:	4581                	li	a1,0
    80004980:	4501                	li	a0,0
    80004982:	00000097          	auipc	ra,0x0
    80004986:	c76080e7          	jalr	-906(ra) # 800045f8 <argfd>
    return -1;
    8000498a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000498c:	02054563          	bltz	a0,800049b6 <sys_fstat+0x44>
    80004990:	fe040593          	addi	a1,s0,-32
    80004994:	4505                	li	a0,1
    80004996:	ffffd097          	auipc	ra,0xffffd
    8000499a:	6d8080e7          	jalr	1752(ra) # 8000206e <argaddr>
    return -1;
    8000499e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049a0:	00054b63          	bltz	a0,800049b6 <sys_fstat+0x44>
  return filestat(f, st);
    800049a4:	fe043583          	ld	a1,-32(s0)
    800049a8:	fe843503          	ld	a0,-24(s0)
    800049ac:	fffff097          	auipc	ra,0xfffff
    800049b0:	32a080e7          	jalr	810(ra) # 80003cd6 <filestat>
    800049b4:	87aa                	mv	a5,a0
}
    800049b6:	853e                	mv	a0,a5
    800049b8:	60e2                	ld	ra,24(sp)
    800049ba:	6442                	ld	s0,16(sp)
    800049bc:	6105                	addi	sp,sp,32
    800049be:	8082                	ret

00000000800049c0 <sys_link>:
{
    800049c0:	7169                	addi	sp,sp,-304
    800049c2:	f606                	sd	ra,296(sp)
    800049c4:	f222                	sd	s0,288(sp)
    800049c6:	ee26                	sd	s1,280(sp)
    800049c8:	ea4a                	sd	s2,272(sp)
    800049ca:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049cc:	08000613          	li	a2,128
    800049d0:	ed040593          	addi	a1,s0,-304
    800049d4:	4501                	li	a0,0
    800049d6:	ffffd097          	auipc	ra,0xffffd
    800049da:	6ba080e7          	jalr	1722(ra) # 80002090 <argstr>
    return -1;
    800049de:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049e0:	10054e63          	bltz	a0,80004afc <sys_link+0x13c>
    800049e4:	08000613          	li	a2,128
    800049e8:	f5040593          	addi	a1,s0,-176
    800049ec:	4505                	li	a0,1
    800049ee:	ffffd097          	auipc	ra,0xffffd
    800049f2:	6a2080e7          	jalr	1698(ra) # 80002090 <argstr>
    return -1;
    800049f6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049f8:	10054263          	bltz	a0,80004afc <sys_link+0x13c>
  begin_op();
    800049fc:	fffff097          	auipc	ra,0xfffff
    80004a00:	d46080e7          	jalr	-698(ra) # 80003742 <begin_op>
  if((ip = namei(old)) == 0){
    80004a04:	ed040513          	addi	a0,s0,-304
    80004a08:	fffff097          	auipc	ra,0xfffff
    80004a0c:	b1e080e7          	jalr	-1250(ra) # 80003526 <namei>
    80004a10:	84aa                	mv	s1,a0
    80004a12:	c551                	beqz	a0,80004a9e <sys_link+0xde>
  ilock(ip);
    80004a14:	ffffe097          	auipc	ra,0xffffe
    80004a18:	35c080e7          	jalr	860(ra) # 80002d70 <ilock>
  if(ip->type == T_DIR){
    80004a1c:	04449703          	lh	a4,68(s1)
    80004a20:	4785                	li	a5,1
    80004a22:	08f70463          	beq	a4,a5,80004aaa <sys_link+0xea>
  ip->nlink++;
    80004a26:	04a4d783          	lhu	a5,74(s1)
    80004a2a:	2785                	addiw	a5,a5,1
    80004a2c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a30:	8526                	mv	a0,s1
    80004a32:	ffffe097          	auipc	ra,0xffffe
    80004a36:	274080e7          	jalr	628(ra) # 80002ca6 <iupdate>
  iunlock(ip);
    80004a3a:	8526                	mv	a0,s1
    80004a3c:	ffffe097          	auipc	ra,0xffffe
    80004a40:	3f6080e7          	jalr	1014(ra) # 80002e32 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a44:	fd040593          	addi	a1,s0,-48
    80004a48:	f5040513          	addi	a0,s0,-176
    80004a4c:	fffff097          	auipc	ra,0xfffff
    80004a50:	af8080e7          	jalr	-1288(ra) # 80003544 <nameiparent>
    80004a54:	892a                	mv	s2,a0
    80004a56:	c935                	beqz	a0,80004aca <sys_link+0x10a>
  ilock(dp);
    80004a58:	ffffe097          	auipc	ra,0xffffe
    80004a5c:	318080e7          	jalr	792(ra) # 80002d70 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a60:	00092703          	lw	a4,0(s2)
    80004a64:	409c                	lw	a5,0(s1)
    80004a66:	04f71d63          	bne	a4,a5,80004ac0 <sys_link+0x100>
    80004a6a:	40d0                	lw	a2,4(s1)
    80004a6c:	fd040593          	addi	a1,s0,-48
    80004a70:	854a                	mv	a0,s2
    80004a72:	fffff097          	auipc	ra,0xfffff
    80004a76:	9f2080e7          	jalr	-1550(ra) # 80003464 <dirlink>
    80004a7a:	04054363          	bltz	a0,80004ac0 <sys_link+0x100>
  iunlockput(dp);
    80004a7e:	854a                	mv	a0,s2
    80004a80:	ffffe097          	auipc	ra,0xffffe
    80004a84:	552080e7          	jalr	1362(ra) # 80002fd2 <iunlockput>
  iput(ip);
    80004a88:	8526                	mv	a0,s1
    80004a8a:	ffffe097          	auipc	ra,0xffffe
    80004a8e:	4a0080e7          	jalr	1184(ra) # 80002f2a <iput>
  end_op();
    80004a92:	fffff097          	auipc	ra,0xfffff
    80004a96:	d30080e7          	jalr	-720(ra) # 800037c2 <end_op>
  return 0;
    80004a9a:	4781                	li	a5,0
    80004a9c:	a085                	j	80004afc <sys_link+0x13c>
    end_op();
    80004a9e:	fffff097          	auipc	ra,0xfffff
    80004aa2:	d24080e7          	jalr	-732(ra) # 800037c2 <end_op>
    return -1;
    80004aa6:	57fd                	li	a5,-1
    80004aa8:	a891                	j	80004afc <sys_link+0x13c>
    iunlockput(ip);
    80004aaa:	8526                	mv	a0,s1
    80004aac:	ffffe097          	auipc	ra,0xffffe
    80004ab0:	526080e7          	jalr	1318(ra) # 80002fd2 <iunlockput>
    end_op();
    80004ab4:	fffff097          	auipc	ra,0xfffff
    80004ab8:	d0e080e7          	jalr	-754(ra) # 800037c2 <end_op>
    return -1;
    80004abc:	57fd                	li	a5,-1
    80004abe:	a83d                	j	80004afc <sys_link+0x13c>
    iunlockput(dp);
    80004ac0:	854a                	mv	a0,s2
    80004ac2:	ffffe097          	auipc	ra,0xffffe
    80004ac6:	510080e7          	jalr	1296(ra) # 80002fd2 <iunlockput>
  ilock(ip);
    80004aca:	8526                	mv	a0,s1
    80004acc:	ffffe097          	auipc	ra,0xffffe
    80004ad0:	2a4080e7          	jalr	676(ra) # 80002d70 <ilock>
  ip->nlink--;
    80004ad4:	04a4d783          	lhu	a5,74(s1)
    80004ad8:	37fd                	addiw	a5,a5,-1
    80004ada:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ade:	8526                	mv	a0,s1
    80004ae0:	ffffe097          	auipc	ra,0xffffe
    80004ae4:	1c6080e7          	jalr	454(ra) # 80002ca6 <iupdate>
  iunlockput(ip);
    80004ae8:	8526                	mv	a0,s1
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	4e8080e7          	jalr	1256(ra) # 80002fd2 <iunlockput>
  end_op();
    80004af2:	fffff097          	auipc	ra,0xfffff
    80004af6:	cd0080e7          	jalr	-816(ra) # 800037c2 <end_op>
  return -1;
    80004afa:	57fd                	li	a5,-1
}
    80004afc:	853e                	mv	a0,a5
    80004afe:	70b2                	ld	ra,296(sp)
    80004b00:	7412                	ld	s0,288(sp)
    80004b02:	64f2                	ld	s1,280(sp)
    80004b04:	6952                	ld	s2,272(sp)
    80004b06:	6155                	addi	sp,sp,304
    80004b08:	8082                	ret

0000000080004b0a <sys_unlink>:
{
    80004b0a:	7151                	addi	sp,sp,-240
    80004b0c:	f586                	sd	ra,232(sp)
    80004b0e:	f1a2                	sd	s0,224(sp)
    80004b10:	eda6                	sd	s1,216(sp)
    80004b12:	e9ca                	sd	s2,208(sp)
    80004b14:	e5ce                	sd	s3,200(sp)
    80004b16:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b18:	08000613          	li	a2,128
    80004b1c:	f3040593          	addi	a1,s0,-208
    80004b20:	4501                	li	a0,0
    80004b22:	ffffd097          	auipc	ra,0xffffd
    80004b26:	56e080e7          	jalr	1390(ra) # 80002090 <argstr>
    80004b2a:	18054163          	bltz	a0,80004cac <sys_unlink+0x1a2>
  begin_op();
    80004b2e:	fffff097          	auipc	ra,0xfffff
    80004b32:	c14080e7          	jalr	-1004(ra) # 80003742 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b36:	fb040593          	addi	a1,s0,-80
    80004b3a:	f3040513          	addi	a0,s0,-208
    80004b3e:	fffff097          	auipc	ra,0xfffff
    80004b42:	a06080e7          	jalr	-1530(ra) # 80003544 <nameiparent>
    80004b46:	84aa                	mv	s1,a0
    80004b48:	c979                	beqz	a0,80004c1e <sys_unlink+0x114>
  ilock(dp);
    80004b4a:	ffffe097          	auipc	ra,0xffffe
    80004b4e:	226080e7          	jalr	550(ra) # 80002d70 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b52:	00004597          	auipc	a1,0x4
    80004b56:	b5658593          	addi	a1,a1,-1194 # 800086a8 <syscalls+0x2e0>
    80004b5a:	fb040513          	addi	a0,s0,-80
    80004b5e:	ffffe097          	auipc	ra,0xffffe
    80004b62:	6dc080e7          	jalr	1756(ra) # 8000323a <namecmp>
    80004b66:	14050a63          	beqz	a0,80004cba <sys_unlink+0x1b0>
    80004b6a:	00004597          	auipc	a1,0x4
    80004b6e:	b4658593          	addi	a1,a1,-1210 # 800086b0 <syscalls+0x2e8>
    80004b72:	fb040513          	addi	a0,s0,-80
    80004b76:	ffffe097          	auipc	ra,0xffffe
    80004b7a:	6c4080e7          	jalr	1732(ra) # 8000323a <namecmp>
    80004b7e:	12050e63          	beqz	a0,80004cba <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b82:	f2c40613          	addi	a2,s0,-212
    80004b86:	fb040593          	addi	a1,s0,-80
    80004b8a:	8526                	mv	a0,s1
    80004b8c:	ffffe097          	auipc	ra,0xffffe
    80004b90:	6c8080e7          	jalr	1736(ra) # 80003254 <dirlookup>
    80004b94:	892a                	mv	s2,a0
    80004b96:	12050263          	beqz	a0,80004cba <sys_unlink+0x1b0>
  ilock(ip);
    80004b9a:	ffffe097          	auipc	ra,0xffffe
    80004b9e:	1d6080e7          	jalr	470(ra) # 80002d70 <ilock>
  if(ip->nlink < 1)
    80004ba2:	04a91783          	lh	a5,74(s2)
    80004ba6:	08f05263          	blez	a5,80004c2a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004baa:	04491703          	lh	a4,68(s2)
    80004bae:	4785                	li	a5,1
    80004bb0:	08f70563          	beq	a4,a5,80004c3a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004bb4:	4641                	li	a2,16
    80004bb6:	4581                	li	a1,0
    80004bb8:	fc040513          	addi	a0,s0,-64
    80004bbc:	ffffb097          	auipc	ra,0xffffb
    80004bc0:	5bc080e7          	jalr	1468(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bc4:	4741                	li	a4,16
    80004bc6:	f2c42683          	lw	a3,-212(s0)
    80004bca:	fc040613          	addi	a2,s0,-64
    80004bce:	4581                	li	a1,0
    80004bd0:	8526                	mv	a0,s1
    80004bd2:	ffffe097          	auipc	ra,0xffffe
    80004bd6:	54a080e7          	jalr	1354(ra) # 8000311c <writei>
    80004bda:	47c1                	li	a5,16
    80004bdc:	0af51563          	bne	a0,a5,80004c86 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004be0:	04491703          	lh	a4,68(s2)
    80004be4:	4785                	li	a5,1
    80004be6:	0af70863          	beq	a4,a5,80004c96 <sys_unlink+0x18c>
  iunlockput(dp);
    80004bea:	8526                	mv	a0,s1
    80004bec:	ffffe097          	auipc	ra,0xffffe
    80004bf0:	3e6080e7          	jalr	998(ra) # 80002fd2 <iunlockput>
  ip->nlink--;
    80004bf4:	04a95783          	lhu	a5,74(s2)
    80004bf8:	37fd                	addiw	a5,a5,-1
    80004bfa:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004bfe:	854a                	mv	a0,s2
    80004c00:	ffffe097          	auipc	ra,0xffffe
    80004c04:	0a6080e7          	jalr	166(ra) # 80002ca6 <iupdate>
  iunlockput(ip);
    80004c08:	854a                	mv	a0,s2
    80004c0a:	ffffe097          	auipc	ra,0xffffe
    80004c0e:	3c8080e7          	jalr	968(ra) # 80002fd2 <iunlockput>
  end_op();
    80004c12:	fffff097          	auipc	ra,0xfffff
    80004c16:	bb0080e7          	jalr	-1104(ra) # 800037c2 <end_op>
  return 0;
    80004c1a:	4501                	li	a0,0
    80004c1c:	a84d                	j	80004cce <sys_unlink+0x1c4>
    end_op();
    80004c1e:	fffff097          	auipc	ra,0xfffff
    80004c22:	ba4080e7          	jalr	-1116(ra) # 800037c2 <end_op>
    return -1;
    80004c26:	557d                	li	a0,-1
    80004c28:	a05d                	j	80004cce <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c2a:	00004517          	auipc	a0,0x4
    80004c2e:	aae50513          	addi	a0,a0,-1362 # 800086d8 <syscalls+0x310>
    80004c32:	00001097          	auipc	ra,0x1
    80004c36:	1f6080e7          	jalr	502(ra) # 80005e28 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c3a:	04c92703          	lw	a4,76(s2)
    80004c3e:	02000793          	li	a5,32
    80004c42:	f6e7f9e3          	bgeu	a5,a4,80004bb4 <sys_unlink+0xaa>
    80004c46:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c4a:	4741                	li	a4,16
    80004c4c:	86ce                	mv	a3,s3
    80004c4e:	f1840613          	addi	a2,s0,-232
    80004c52:	4581                	li	a1,0
    80004c54:	854a                	mv	a0,s2
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	3ce080e7          	jalr	974(ra) # 80003024 <readi>
    80004c5e:	47c1                	li	a5,16
    80004c60:	00f51b63          	bne	a0,a5,80004c76 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c64:	f1845783          	lhu	a5,-232(s0)
    80004c68:	e7a1                	bnez	a5,80004cb0 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c6a:	29c1                	addiw	s3,s3,16
    80004c6c:	04c92783          	lw	a5,76(s2)
    80004c70:	fcf9ede3          	bltu	s3,a5,80004c4a <sys_unlink+0x140>
    80004c74:	b781                	j	80004bb4 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c76:	00004517          	auipc	a0,0x4
    80004c7a:	a7a50513          	addi	a0,a0,-1414 # 800086f0 <syscalls+0x328>
    80004c7e:	00001097          	auipc	ra,0x1
    80004c82:	1aa080e7          	jalr	426(ra) # 80005e28 <panic>
    panic("unlink: writei");
    80004c86:	00004517          	auipc	a0,0x4
    80004c8a:	a8250513          	addi	a0,a0,-1406 # 80008708 <syscalls+0x340>
    80004c8e:	00001097          	auipc	ra,0x1
    80004c92:	19a080e7          	jalr	410(ra) # 80005e28 <panic>
    dp->nlink--;
    80004c96:	04a4d783          	lhu	a5,74(s1)
    80004c9a:	37fd                	addiw	a5,a5,-1
    80004c9c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ca0:	8526                	mv	a0,s1
    80004ca2:	ffffe097          	auipc	ra,0xffffe
    80004ca6:	004080e7          	jalr	4(ra) # 80002ca6 <iupdate>
    80004caa:	b781                	j	80004bea <sys_unlink+0xe0>
    return -1;
    80004cac:	557d                	li	a0,-1
    80004cae:	a005                	j	80004cce <sys_unlink+0x1c4>
    iunlockput(ip);
    80004cb0:	854a                	mv	a0,s2
    80004cb2:	ffffe097          	auipc	ra,0xffffe
    80004cb6:	320080e7          	jalr	800(ra) # 80002fd2 <iunlockput>
  iunlockput(dp);
    80004cba:	8526                	mv	a0,s1
    80004cbc:	ffffe097          	auipc	ra,0xffffe
    80004cc0:	316080e7          	jalr	790(ra) # 80002fd2 <iunlockput>
  end_op();
    80004cc4:	fffff097          	auipc	ra,0xfffff
    80004cc8:	afe080e7          	jalr	-1282(ra) # 800037c2 <end_op>
  return -1;
    80004ccc:	557d                	li	a0,-1
}
    80004cce:	70ae                	ld	ra,232(sp)
    80004cd0:	740e                	ld	s0,224(sp)
    80004cd2:	64ee                	ld	s1,216(sp)
    80004cd4:	694e                	ld	s2,208(sp)
    80004cd6:	69ae                	ld	s3,200(sp)
    80004cd8:	616d                	addi	sp,sp,240
    80004cda:	8082                	ret

0000000080004cdc <sys_open>:

uint64
sys_open(void)
{
    80004cdc:	7131                	addi	sp,sp,-192
    80004cde:	fd06                	sd	ra,184(sp)
    80004ce0:	f922                	sd	s0,176(sp)
    80004ce2:	f526                	sd	s1,168(sp)
    80004ce4:	f14a                	sd	s2,160(sp)
    80004ce6:	ed4e                	sd	s3,152(sp)
    80004ce8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cea:	08000613          	li	a2,128
    80004cee:	f5040593          	addi	a1,s0,-176
    80004cf2:	4501                	li	a0,0
    80004cf4:	ffffd097          	auipc	ra,0xffffd
    80004cf8:	39c080e7          	jalr	924(ra) # 80002090 <argstr>
    return -1;
    80004cfc:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cfe:	0c054163          	bltz	a0,80004dc0 <sys_open+0xe4>
    80004d02:	f4c40593          	addi	a1,s0,-180
    80004d06:	4505                	li	a0,1
    80004d08:	ffffd097          	auipc	ra,0xffffd
    80004d0c:	344080e7          	jalr	836(ra) # 8000204c <argint>
    80004d10:	0a054863          	bltz	a0,80004dc0 <sys_open+0xe4>

  begin_op();
    80004d14:	fffff097          	auipc	ra,0xfffff
    80004d18:	a2e080e7          	jalr	-1490(ra) # 80003742 <begin_op>

  if(omode & O_CREATE){
    80004d1c:	f4c42783          	lw	a5,-180(s0)
    80004d20:	2007f793          	andi	a5,a5,512
    80004d24:	cbdd                	beqz	a5,80004dda <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d26:	4681                	li	a3,0
    80004d28:	4601                	li	a2,0
    80004d2a:	4589                	li	a1,2
    80004d2c:	f5040513          	addi	a0,s0,-176
    80004d30:	00000097          	auipc	ra,0x0
    80004d34:	972080e7          	jalr	-1678(ra) # 800046a2 <create>
    80004d38:	892a                	mv	s2,a0
    if(ip == 0){
    80004d3a:	c959                	beqz	a0,80004dd0 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d3c:	04491703          	lh	a4,68(s2)
    80004d40:	478d                	li	a5,3
    80004d42:	00f71763          	bne	a4,a5,80004d50 <sys_open+0x74>
    80004d46:	04695703          	lhu	a4,70(s2)
    80004d4a:	47a5                	li	a5,9
    80004d4c:	0ce7ec63          	bltu	a5,a4,80004e24 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d50:	fffff097          	auipc	ra,0xfffff
    80004d54:	e02080e7          	jalr	-510(ra) # 80003b52 <filealloc>
    80004d58:	89aa                	mv	s3,a0
    80004d5a:	10050263          	beqz	a0,80004e5e <sys_open+0x182>
    80004d5e:	00000097          	auipc	ra,0x0
    80004d62:	902080e7          	jalr	-1790(ra) # 80004660 <fdalloc>
    80004d66:	84aa                	mv	s1,a0
    80004d68:	0e054663          	bltz	a0,80004e54 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d6c:	04491703          	lh	a4,68(s2)
    80004d70:	478d                	li	a5,3
    80004d72:	0cf70463          	beq	a4,a5,80004e3a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d76:	4789                	li	a5,2
    80004d78:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d7c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d80:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d84:	f4c42783          	lw	a5,-180(s0)
    80004d88:	0017c713          	xori	a4,a5,1
    80004d8c:	8b05                	andi	a4,a4,1
    80004d8e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d92:	0037f713          	andi	a4,a5,3
    80004d96:	00e03733          	snez	a4,a4
    80004d9a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d9e:	4007f793          	andi	a5,a5,1024
    80004da2:	c791                	beqz	a5,80004dae <sys_open+0xd2>
    80004da4:	04491703          	lh	a4,68(s2)
    80004da8:	4789                	li	a5,2
    80004daa:	08f70f63          	beq	a4,a5,80004e48 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004dae:	854a                	mv	a0,s2
    80004db0:	ffffe097          	auipc	ra,0xffffe
    80004db4:	082080e7          	jalr	130(ra) # 80002e32 <iunlock>
  end_op();
    80004db8:	fffff097          	auipc	ra,0xfffff
    80004dbc:	a0a080e7          	jalr	-1526(ra) # 800037c2 <end_op>

  return fd;
}
    80004dc0:	8526                	mv	a0,s1
    80004dc2:	70ea                	ld	ra,184(sp)
    80004dc4:	744a                	ld	s0,176(sp)
    80004dc6:	74aa                	ld	s1,168(sp)
    80004dc8:	790a                	ld	s2,160(sp)
    80004dca:	69ea                	ld	s3,152(sp)
    80004dcc:	6129                	addi	sp,sp,192
    80004dce:	8082                	ret
      end_op();
    80004dd0:	fffff097          	auipc	ra,0xfffff
    80004dd4:	9f2080e7          	jalr	-1550(ra) # 800037c2 <end_op>
      return -1;
    80004dd8:	b7e5                	j	80004dc0 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004dda:	f5040513          	addi	a0,s0,-176
    80004dde:	ffffe097          	auipc	ra,0xffffe
    80004de2:	748080e7          	jalr	1864(ra) # 80003526 <namei>
    80004de6:	892a                	mv	s2,a0
    80004de8:	c905                	beqz	a0,80004e18 <sys_open+0x13c>
    ilock(ip);
    80004dea:	ffffe097          	auipc	ra,0xffffe
    80004dee:	f86080e7          	jalr	-122(ra) # 80002d70 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004df2:	04491703          	lh	a4,68(s2)
    80004df6:	4785                	li	a5,1
    80004df8:	f4f712e3          	bne	a4,a5,80004d3c <sys_open+0x60>
    80004dfc:	f4c42783          	lw	a5,-180(s0)
    80004e00:	dba1                	beqz	a5,80004d50 <sys_open+0x74>
      iunlockput(ip);
    80004e02:	854a                	mv	a0,s2
    80004e04:	ffffe097          	auipc	ra,0xffffe
    80004e08:	1ce080e7          	jalr	462(ra) # 80002fd2 <iunlockput>
      end_op();
    80004e0c:	fffff097          	auipc	ra,0xfffff
    80004e10:	9b6080e7          	jalr	-1610(ra) # 800037c2 <end_op>
      return -1;
    80004e14:	54fd                	li	s1,-1
    80004e16:	b76d                	j	80004dc0 <sys_open+0xe4>
      end_op();
    80004e18:	fffff097          	auipc	ra,0xfffff
    80004e1c:	9aa080e7          	jalr	-1622(ra) # 800037c2 <end_op>
      return -1;
    80004e20:	54fd                	li	s1,-1
    80004e22:	bf79                	j	80004dc0 <sys_open+0xe4>
    iunlockput(ip);
    80004e24:	854a                	mv	a0,s2
    80004e26:	ffffe097          	auipc	ra,0xffffe
    80004e2a:	1ac080e7          	jalr	428(ra) # 80002fd2 <iunlockput>
    end_op();
    80004e2e:	fffff097          	auipc	ra,0xfffff
    80004e32:	994080e7          	jalr	-1644(ra) # 800037c2 <end_op>
    return -1;
    80004e36:	54fd                	li	s1,-1
    80004e38:	b761                	j	80004dc0 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e3a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e3e:	04691783          	lh	a5,70(s2)
    80004e42:	02f99223          	sh	a5,36(s3)
    80004e46:	bf2d                	j	80004d80 <sys_open+0xa4>
    itrunc(ip);
    80004e48:	854a                	mv	a0,s2
    80004e4a:	ffffe097          	auipc	ra,0xffffe
    80004e4e:	034080e7          	jalr	52(ra) # 80002e7e <itrunc>
    80004e52:	bfb1                	j	80004dae <sys_open+0xd2>
      fileclose(f);
    80004e54:	854e                	mv	a0,s3
    80004e56:	fffff097          	auipc	ra,0xfffff
    80004e5a:	db8080e7          	jalr	-584(ra) # 80003c0e <fileclose>
    iunlockput(ip);
    80004e5e:	854a                	mv	a0,s2
    80004e60:	ffffe097          	auipc	ra,0xffffe
    80004e64:	172080e7          	jalr	370(ra) # 80002fd2 <iunlockput>
    end_op();
    80004e68:	fffff097          	auipc	ra,0xfffff
    80004e6c:	95a080e7          	jalr	-1702(ra) # 800037c2 <end_op>
    return -1;
    80004e70:	54fd                	li	s1,-1
    80004e72:	b7b9                	j	80004dc0 <sys_open+0xe4>

0000000080004e74 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e74:	7175                	addi	sp,sp,-144
    80004e76:	e506                	sd	ra,136(sp)
    80004e78:	e122                	sd	s0,128(sp)
    80004e7a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e7c:	fffff097          	auipc	ra,0xfffff
    80004e80:	8c6080e7          	jalr	-1850(ra) # 80003742 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e84:	08000613          	li	a2,128
    80004e88:	f7040593          	addi	a1,s0,-144
    80004e8c:	4501                	li	a0,0
    80004e8e:	ffffd097          	auipc	ra,0xffffd
    80004e92:	202080e7          	jalr	514(ra) # 80002090 <argstr>
    80004e96:	02054963          	bltz	a0,80004ec8 <sys_mkdir+0x54>
    80004e9a:	4681                	li	a3,0
    80004e9c:	4601                	li	a2,0
    80004e9e:	4585                	li	a1,1
    80004ea0:	f7040513          	addi	a0,s0,-144
    80004ea4:	fffff097          	auipc	ra,0xfffff
    80004ea8:	7fe080e7          	jalr	2046(ra) # 800046a2 <create>
    80004eac:	cd11                	beqz	a0,80004ec8 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eae:	ffffe097          	auipc	ra,0xffffe
    80004eb2:	124080e7          	jalr	292(ra) # 80002fd2 <iunlockput>
  end_op();
    80004eb6:	fffff097          	auipc	ra,0xfffff
    80004eba:	90c080e7          	jalr	-1780(ra) # 800037c2 <end_op>
  return 0;
    80004ebe:	4501                	li	a0,0
}
    80004ec0:	60aa                	ld	ra,136(sp)
    80004ec2:	640a                	ld	s0,128(sp)
    80004ec4:	6149                	addi	sp,sp,144
    80004ec6:	8082                	ret
    end_op();
    80004ec8:	fffff097          	auipc	ra,0xfffff
    80004ecc:	8fa080e7          	jalr	-1798(ra) # 800037c2 <end_op>
    return -1;
    80004ed0:	557d                	li	a0,-1
    80004ed2:	b7fd                	j	80004ec0 <sys_mkdir+0x4c>

0000000080004ed4 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ed4:	7135                	addi	sp,sp,-160
    80004ed6:	ed06                	sd	ra,152(sp)
    80004ed8:	e922                	sd	s0,144(sp)
    80004eda:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004edc:	fffff097          	auipc	ra,0xfffff
    80004ee0:	866080e7          	jalr	-1946(ra) # 80003742 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ee4:	08000613          	li	a2,128
    80004ee8:	f7040593          	addi	a1,s0,-144
    80004eec:	4501                	li	a0,0
    80004eee:	ffffd097          	auipc	ra,0xffffd
    80004ef2:	1a2080e7          	jalr	418(ra) # 80002090 <argstr>
    80004ef6:	04054a63          	bltz	a0,80004f4a <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004efa:	f6c40593          	addi	a1,s0,-148
    80004efe:	4505                	li	a0,1
    80004f00:	ffffd097          	auipc	ra,0xffffd
    80004f04:	14c080e7          	jalr	332(ra) # 8000204c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f08:	04054163          	bltz	a0,80004f4a <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f0c:	f6840593          	addi	a1,s0,-152
    80004f10:	4509                	li	a0,2
    80004f12:	ffffd097          	auipc	ra,0xffffd
    80004f16:	13a080e7          	jalr	314(ra) # 8000204c <argint>
     argint(1, &major) < 0 ||
    80004f1a:	02054863          	bltz	a0,80004f4a <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f1e:	f6841683          	lh	a3,-152(s0)
    80004f22:	f6c41603          	lh	a2,-148(s0)
    80004f26:	458d                	li	a1,3
    80004f28:	f7040513          	addi	a0,s0,-144
    80004f2c:	fffff097          	auipc	ra,0xfffff
    80004f30:	776080e7          	jalr	1910(ra) # 800046a2 <create>
     argint(2, &minor) < 0 ||
    80004f34:	c919                	beqz	a0,80004f4a <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f36:	ffffe097          	auipc	ra,0xffffe
    80004f3a:	09c080e7          	jalr	156(ra) # 80002fd2 <iunlockput>
  end_op();
    80004f3e:	fffff097          	auipc	ra,0xfffff
    80004f42:	884080e7          	jalr	-1916(ra) # 800037c2 <end_op>
  return 0;
    80004f46:	4501                	li	a0,0
    80004f48:	a031                	j	80004f54 <sys_mknod+0x80>
    end_op();
    80004f4a:	fffff097          	auipc	ra,0xfffff
    80004f4e:	878080e7          	jalr	-1928(ra) # 800037c2 <end_op>
    return -1;
    80004f52:	557d                	li	a0,-1
}
    80004f54:	60ea                	ld	ra,152(sp)
    80004f56:	644a                	ld	s0,144(sp)
    80004f58:	610d                	addi	sp,sp,160
    80004f5a:	8082                	ret

0000000080004f5c <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f5c:	7135                	addi	sp,sp,-160
    80004f5e:	ed06                	sd	ra,152(sp)
    80004f60:	e922                	sd	s0,144(sp)
    80004f62:	e526                	sd	s1,136(sp)
    80004f64:	e14a                	sd	s2,128(sp)
    80004f66:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f68:	ffffc097          	auipc	ra,0xffffc
    80004f6c:	ee0080e7          	jalr	-288(ra) # 80000e48 <myproc>
    80004f70:	892a                	mv	s2,a0
  
  begin_op();
    80004f72:	ffffe097          	auipc	ra,0xffffe
    80004f76:	7d0080e7          	jalr	2000(ra) # 80003742 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f7a:	08000613          	li	a2,128
    80004f7e:	f6040593          	addi	a1,s0,-160
    80004f82:	4501                	li	a0,0
    80004f84:	ffffd097          	auipc	ra,0xffffd
    80004f88:	10c080e7          	jalr	268(ra) # 80002090 <argstr>
    80004f8c:	04054b63          	bltz	a0,80004fe2 <sys_chdir+0x86>
    80004f90:	f6040513          	addi	a0,s0,-160
    80004f94:	ffffe097          	auipc	ra,0xffffe
    80004f98:	592080e7          	jalr	1426(ra) # 80003526 <namei>
    80004f9c:	84aa                	mv	s1,a0
    80004f9e:	c131                	beqz	a0,80004fe2 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004fa0:	ffffe097          	auipc	ra,0xffffe
    80004fa4:	dd0080e7          	jalr	-560(ra) # 80002d70 <ilock>
  if(ip->type != T_DIR){
    80004fa8:	04449703          	lh	a4,68(s1)
    80004fac:	4785                	li	a5,1
    80004fae:	04f71063          	bne	a4,a5,80004fee <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fb2:	8526                	mv	a0,s1
    80004fb4:	ffffe097          	auipc	ra,0xffffe
    80004fb8:	e7e080e7          	jalr	-386(ra) # 80002e32 <iunlock>
  iput(p->cwd);
    80004fbc:	16893503          	ld	a0,360(s2)
    80004fc0:	ffffe097          	auipc	ra,0xffffe
    80004fc4:	f6a080e7          	jalr	-150(ra) # 80002f2a <iput>
  end_op();
    80004fc8:	ffffe097          	auipc	ra,0xffffe
    80004fcc:	7fa080e7          	jalr	2042(ra) # 800037c2 <end_op>
  p->cwd = ip;
    80004fd0:	16993423          	sd	s1,360(s2)
  return 0;
    80004fd4:	4501                	li	a0,0
}
    80004fd6:	60ea                	ld	ra,152(sp)
    80004fd8:	644a                	ld	s0,144(sp)
    80004fda:	64aa                	ld	s1,136(sp)
    80004fdc:	690a                	ld	s2,128(sp)
    80004fde:	610d                	addi	sp,sp,160
    80004fe0:	8082                	ret
    end_op();
    80004fe2:	ffffe097          	auipc	ra,0xffffe
    80004fe6:	7e0080e7          	jalr	2016(ra) # 800037c2 <end_op>
    return -1;
    80004fea:	557d                	li	a0,-1
    80004fec:	b7ed                	j	80004fd6 <sys_chdir+0x7a>
    iunlockput(ip);
    80004fee:	8526                	mv	a0,s1
    80004ff0:	ffffe097          	auipc	ra,0xffffe
    80004ff4:	fe2080e7          	jalr	-30(ra) # 80002fd2 <iunlockput>
    end_op();
    80004ff8:	ffffe097          	auipc	ra,0xffffe
    80004ffc:	7ca080e7          	jalr	1994(ra) # 800037c2 <end_op>
    return -1;
    80005000:	557d                	li	a0,-1
    80005002:	bfd1                	j	80004fd6 <sys_chdir+0x7a>

0000000080005004 <sys_exec>:

uint64
sys_exec(void)
{
    80005004:	7145                	addi	sp,sp,-464
    80005006:	e786                	sd	ra,456(sp)
    80005008:	e3a2                	sd	s0,448(sp)
    8000500a:	ff26                	sd	s1,440(sp)
    8000500c:	fb4a                	sd	s2,432(sp)
    8000500e:	f74e                	sd	s3,424(sp)
    80005010:	f352                	sd	s4,416(sp)
    80005012:	ef56                	sd	s5,408(sp)
    80005014:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005016:	08000613          	li	a2,128
    8000501a:	f4040593          	addi	a1,s0,-192
    8000501e:	4501                	li	a0,0
    80005020:	ffffd097          	auipc	ra,0xffffd
    80005024:	070080e7          	jalr	112(ra) # 80002090 <argstr>
    return -1;
    80005028:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000502a:	0c054a63          	bltz	a0,800050fe <sys_exec+0xfa>
    8000502e:	e3840593          	addi	a1,s0,-456
    80005032:	4505                	li	a0,1
    80005034:	ffffd097          	auipc	ra,0xffffd
    80005038:	03a080e7          	jalr	58(ra) # 8000206e <argaddr>
    8000503c:	0c054163          	bltz	a0,800050fe <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005040:	10000613          	li	a2,256
    80005044:	4581                	li	a1,0
    80005046:	e4040513          	addi	a0,s0,-448
    8000504a:	ffffb097          	auipc	ra,0xffffb
    8000504e:	12e080e7          	jalr	302(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005052:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005056:	89a6                	mv	s3,s1
    80005058:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000505a:	02000a13          	li	s4,32
    8000505e:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005062:	00391513          	slli	a0,s2,0x3
    80005066:	e3040593          	addi	a1,s0,-464
    8000506a:	e3843783          	ld	a5,-456(s0)
    8000506e:	953e                	add	a0,a0,a5
    80005070:	ffffd097          	auipc	ra,0xffffd
    80005074:	f42080e7          	jalr	-190(ra) # 80001fb2 <fetchaddr>
    80005078:	02054a63          	bltz	a0,800050ac <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    8000507c:	e3043783          	ld	a5,-464(s0)
    80005080:	c3b9                	beqz	a5,800050c6 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005082:	ffffb097          	auipc	ra,0xffffb
    80005086:	096080e7          	jalr	150(ra) # 80000118 <kalloc>
    8000508a:	85aa                	mv	a1,a0
    8000508c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005090:	cd11                	beqz	a0,800050ac <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005092:	6605                	lui	a2,0x1
    80005094:	e3043503          	ld	a0,-464(s0)
    80005098:	ffffd097          	auipc	ra,0xffffd
    8000509c:	f6c080e7          	jalr	-148(ra) # 80002004 <fetchstr>
    800050a0:	00054663          	bltz	a0,800050ac <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    800050a4:	0905                	addi	s2,s2,1
    800050a6:	09a1                	addi	s3,s3,8
    800050a8:	fb491be3          	bne	s2,s4,8000505e <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050ac:	10048913          	addi	s2,s1,256
    800050b0:	6088                	ld	a0,0(s1)
    800050b2:	c529                	beqz	a0,800050fc <sys_exec+0xf8>
    kfree(argv[i]);
    800050b4:	ffffb097          	auipc	ra,0xffffb
    800050b8:	f68080e7          	jalr	-152(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050bc:	04a1                	addi	s1,s1,8
    800050be:	ff2499e3          	bne	s1,s2,800050b0 <sys_exec+0xac>
  return -1;
    800050c2:	597d                	li	s2,-1
    800050c4:	a82d                	j	800050fe <sys_exec+0xfa>
      argv[i] = 0;
    800050c6:	0a8e                	slli	s5,s5,0x3
    800050c8:	fc040793          	addi	a5,s0,-64
    800050cc:	9abe                	add	s5,s5,a5
    800050ce:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800050d2:	e4040593          	addi	a1,s0,-448
    800050d6:	f4040513          	addi	a0,s0,-192
    800050da:	fffff097          	auipc	ra,0xfffff
    800050de:	194080e7          	jalr	404(ra) # 8000426e <exec>
    800050e2:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050e4:	10048993          	addi	s3,s1,256
    800050e8:	6088                	ld	a0,0(s1)
    800050ea:	c911                	beqz	a0,800050fe <sys_exec+0xfa>
    kfree(argv[i]);
    800050ec:	ffffb097          	auipc	ra,0xffffb
    800050f0:	f30080e7          	jalr	-208(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050f4:	04a1                	addi	s1,s1,8
    800050f6:	ff3499e3          	bne	s1,s3,800050e8 <sys_exec+0xe4>
    800050fa:	a011                	j	800050fe <sys_exec+0xfa>
  return -1;
    800050fc:	597d                	li	s2,-1
}
    800050fe:	854a                	mv	a0,s2
    80005100:	60be                	ld	ra,456(sp)
    80005102:	641e                	ld	s0,448(sp)
    80005104:	74fa                	ld	s1,440(sp)
    80005106:	795a                	ld	s2,432(sp)
    80005108:	79ba                	ld	s3,424(sp)
    8000510a:	7a1a                	ld	s4,416(sp)
    8000510c:	6afa                	ld	s5,408(sp)
    8000510e:	6179                	addi	sp,sp,464
    80005110:	8082                	ret

0000000080005112 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005112:	7139                	addi	sp,sp,-64
    80005114:	fc06                	sd	ra,56(sp)
    80005116:	f822                	sd	s0,48(sp)
    80005118:	f426                	sd	s1,40(sp)
    8000511a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000511c:	ffffc097          	auipc	ra,0xffffc
    80005120:	d2c080e7          	jalr	-724(ra) # 80000e48 <myproc>
    80005124:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005126:	fd840593          	addi	a1,s0,-40
    8000512a:	4501                	li	a0,0
    8000512c:	ffffd097          	auipc	ra,0xffffd
    80005130:	f42080e7          	jalr	-190(ra) # 8000206e <argaddr>
    return -1;
    80005134:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005136:	0e054063          	bltz	a0,80005216 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    8000513a:	fc840593          	addi	a1,s0,-56
    8000513e:	fd040513          	addi	a0,s0,-48
    80005142:	fffff097          	auipc	ra,0xfffff
    80005146:	dfc080e7          	jalr	-516(ra) # 80003f3e <pipealloc>
    return -1;
    8000514a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000514c:	0c054563          	bltz	a0,80005216 <sys_pipe+0x104>
  fd0 = -1;
    80005150:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005154:	fd043503          	ld	a0,-48(s0)
    80005158:	fffff097          	auipc	ra,0xfffff
    8000515c:	508080e7          	jalr	1288(ra) # 80004660 <fdalloc>
    80005160:	fca42223          	sw	a0,-60(s0)
    80005164:	08054c63          	bltz	a0,800051fc <sys_pipe+0xea>
    80005168:	fc843503          	ld	a0,-56(s0)
    8000516c:	fffff097          	auipc	ra,0xfffff
    80005170:	4f4080e7          	jalr	1268(ra) # 80004660 <fdalloc>
    80005174:	fca42023          	sw	a0,-64(s0)
    80005178:	06054863          	bltz	a0,800051e8 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000517c:	4691                	li	a3,4
    8000517e:	fc440613          	addi	a2,s0,-60
    80005182:	fd843583          	ld	a1,-40(s0)
    80005186:	68a8                	ld	a0,80(s1)
    80005188:	ffffc097          	auipc	ra,0xffffc
    8000518c:	982080e7          	jalr	-1662(ra) # 80000b0a <copyout>
    80005190:	02054063          	bltz	a0,800051b0 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005194:	4691                	li	a3,4
    80005196:	fc040613          	addi	a2,s0,-64
    8000519a:	fd843583          	ld	a1,-40(s0)
    8000519e:	0591                	addi	a1,a1,4
    800051a0:	68a8                	ld	a0,80(s1)
    800051a2:	ffffc097          	auipc	ra,0xffffc
    800051a6:	968080e7          	jalr	-1688(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051aa:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051ac:	06055563          	bgez	a0,80005216 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800051b0:	fc442783          	lw	a5,-60(s0)
    800051b4:	07f1                	addi	a5,a5,28
    800051b6:	078e                	slli	a5,a5,0x3
    800051b8:	97a6                	add	a5,a5,s1
    800051ba:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800051be:	fc042503          	lw	a0,-64(s0)
    800051c2:	0571                	addi	a0,a0,28
    800051c4:	050e                	slli	a0,a0,0x3
    800051c6:	9526                	add	a0,a0,s1
    800051c8:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800051cc:	fd043503          	ld	a0,-48(s0)
    800051d0:	fffff097          	auipc	ra,0xfffff
    800051d4:	a3e080e7          	jalr	-1474(ra) # 80003c0e <fileclose>
    fileclose(wf);
    800051d8:	fc843503          	ld	a0,-56(s0)
    800051dc:	fffff097          	auipc	ra,0xfffff
    800051e0:	a32080e7          	jalr	-1486(ra) # 80003c0e <fileclose>
    return -1;
    800051e4:	57fd                	li	a5,-1
    800051e6:	a805                	j	80005216 <sys_pipe+0x104>
    if(fd0 >= 0)
    800051e8:	fc442783          	lw	a5,-60(s0)
    800051ec:	0007c863          	bltz	a5,800051fc <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800051f0:	01c78513          	addi	a0,a5,28
    800051f4:	050e                	slli	a0,a0,0x3
    800051f6:	9526                	add	a0,a0,s1
    800051f8:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800051fc:	fd043503          	ld	a0,-48(s0)
    80005200:	fffff097          	auipc	ra,0xfffff
    80005204:	a0e080e7          	jalr	-1522(ra) # 80003c0e <fileclose>
    fileclose(wf);
    80005208:	fc843503          	ld	a0,-56(s0)
    8000520c:	fffff097          	auipc	ra,0xfffff
    80005210:	a02080e7          	jalr	-1534(ra) # 80003c0e <fileclose>
    return -1;
    80005214:	57fd                	li	a5,-1
}
    80005216:	853e                	mv	a0,a5
    80005218:	70e2                	ld	ra,56(sp)
    8000521a:	7442                	ld	s0,48(sp)
    8000521c:	74a2                	ld	s1,40(sp)
    8000521e:	6121                	addi	sp,sp,64
    80005220:	8082                	ret
	...

0000000080005230 <kernelvec>:
    80005230:	7111                	addi	sp,sp,-256
    80005232:	e006                	sd	ra,0(sp)
    80005234:	e40a                	sd	sp,8(sp)
    80005236:	e80e                	sd	gp,16(sp)
    80005238:	ec12                	sd	tp,24(sp)
    8000523a:	f016                	sd	t0,32(sp)
    8000523c:	f41a                	sd	t1,40(sp)
    8000523e:	f81e                	sd	t2,48(sp)
    80005240:	fc22                	sd	s0,56(sp)
    80005242:	e0a6                	sd	s1,64(sp)
    80005244:	e4aa                	sd	a0,72(sp)
    80005246:	e8ae                	sd	a1,80(sp)
    80005248:	ecb2                	sd	a2,88(sp)
    8000524a:	f0b6                	sd	a3,96(sp)
    8000524c:	f4ba                	sd	a4,104(sp)
    8000524e:	f8be                	sd	a5,112(sp)
    80005250:	fcc2                	sd	a6,120(sp)
    80005252:	e146                	sd	a7,128(sp)
    80005254:	e54a                	sd	s2,136(sp)
    80005256:	e94e                	sd	s3,144(sp)
    80005258:	ed52                	sd	s4,152(sp)
    8000525a:	f156                	sd	s5,160(sp)
    8000525c:	f55a                	sd	s6,168(sp)
    8000525e:	f95e                	sd	s7,176(sp)
    80005260:	fd62                	sd	s8,184(sp)
    80005262:	e1e6                	sd	s9,192(sp)
    80005264:	e5ea                	sd	s10,200(sp)
    80005266:	e9ee                	sd	s11,208(sp)
    80005268:	edf2                	sd	t3,216(sp)
    8000526a:	f1f6                	sd	t4,224(sp)
    8000526c:	f5fa                	sd	t5,232(sp)
    8000526e:	f9fe                	sd	t6,240(sp)
    80005270:	c0ffc0ef          	jal	ra,80001e7e <kerneltrap>
    80005274:	6082                	ld	ra,0(sp)
    80005276:	6122                	ld	sp,8(sp)
    80005278:	61c2                	ld	gp,16(sp)
    8000527a:	7282                	ld	t0,32(sp)
    8000527c:	7322                	ld	t1,40(sp)
    8000527e:	73c2                	ld	t2,48(sp)
    80005280:	7462                	ld	s0,56(sp)
    80005282:	6486                	ld	s1,64(sp)
    80005284:	6526                	ld	a0,72(sp)
    80005286:	65c6                	ld	a1,80(sp)
    80005288:	6666                	ld	a2,88(sp)
    8000528a:	7686                	ld	a3,96(sp)
    8000528c:	7726                	ld	a4,104(sp)
    8000528e:	77c6                	ld	a5,112(sp)
    80005290:	7866                	ld	a6,120(sp)
    80005292:	688a                	ld	a7,128(sp)
    80005294:	692a                	ld	s2,136(sp)
    80005296:	69ca                	ld	s3,144(sp)
    80005298:	6a6a                	ld	s4,152(sp)
    8000529a:	7a8a                	ld	s5,160(sp)
    8000529c:	7b2a                	ld	s6,168(sp)
    8000529e:	7bca                	ld	s7,176(sp)
    800052a0:	7c6a                	ld	s8,184(sp)
    800052a2:	6c8e                	ld	s9,192(sp)
    800052a4:	6d2e                	ld	s10,200(sp)
    800052a6:	6dce                	ld	s11,208(sp)
    800052a8:	6e6e                	ld	t3,216(sp)
    800052aa:	7e8e                	ld	t4,224(sp)
    800052ac:	7f2e                	ld	t5,232(sp)
    800052ae:	7fce                	ld	t6,240(sp)
    800052b0:	6111                	addi	sp,sp,256
    800052b2:	10200073          	sret
    800052b6:	00000013          	nop
    800052ba:	00000013          	nop
    800052be:	0001                	nop

00000000800052c0 <timervec>:
    800052c0:	34051573          	csrrw	a0,mscratch,a0
    800052c4:	e10c                	sd	a1,0(a0)
    800052c6:	e510                	sd	a2,8(a0)
    800052c8:	e914                	sd	a3,16(a0)
    800052ca:	6d0c                	ld	a1,24(a0)
    800052cc:	7110                	ld	a2,32(a0)
    800052ce:	6194                	ld	a3,0(a1)
    800052d0:	96b2                	add	a3,a3,a2
    800052d2:	e194                	sd	a3,0(a1)
    800052d4:	4589                	li	a1,2
    800052d6:	14459073          	csrw	sip,a1
    800052da:	6914                	ld	a3,16(a0)
    800052dc:	6510                	ld	a2,8(a0)
    800052de:	610c                	ld	a1,0(a0)
    800052e0:	34051573          	csrrw	a0,mscratch,a0
    800052e4:	30200073          	mret
	...

00000000800052ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052ea:	1141                	addi	sp,sp,-16
    800052ec:	e422                	sd	s0,8(sp)
    800052ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052f0:	0c0007b7          	lui	a5,0xc000
    800052f4:	4705                	li	a4,1
    800052f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052f8:	c3d8                	sw	a4,4(a5)
}
    800052fa:	6422                	ld	s0,8(sp)
    800052fc:	0141                	addi	sp,sp,16
    800052fe:	8082                	ret

0000000080005300 <plicinithart>:

void
plicinithart(void)
{
    80005300:	1141                	addi	sp,sp,-16
    80005302:	e406                	sd	ra,8(sp)
    80005304:	e022                	sd	s0,0(sp)
    80005306:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005308:	ffffc097          	auipc	ra,0xffffc
    8000530c:	b14080e7          	jalr	-1260(ra) # 80000e1c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005310:	0085171b          	slliw	a4,a0,0x8
    80005314:	0c0027b7          	lui	a5,0xc002
    80005318:	97ba                	add	a5,a5,a4
    8000531a:	40200713          	li	a4,1026
    8000531e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005322:	00d5151b          	slliw	a0,a0,0xd
    80005326:	0c2017b7          	lui	a5,0xc201
    8000532a:	953e                	add	a0,a0,a5
    8000532c:	00052023          	sw	zero,0(a0)
}
    80005330:	60a2                	ld	ra,8(sp)
    80005332:	6402                	ld	s0,0(sp)
    80005334:	0141                	addi	sp,sp,16
    80005336:	8082                	ret

0000000080005338 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005338:	1141                	addi	sp,sp,-16
    8000533a:	e406                	sd	ra,8(sp)
    8000533c:	e022                	sd	s0,0(sp)
    8000533e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005340:	ffffc097          	auipc	ra,0xffffc
    80005344:	adc080e7          	jalr	-1316(ra) # 80000e1c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005348:	00d5179b          	slliw	a5,a0,0xd
    8000534c:	0c201537          	lui	a0,0xc201
    80005350:	953e                	add	a0,a0,a5
  return irq;
}
    80005352:	4148                	lw	a0,4(a0)
    80005354:	60a2                	ld	ra,8(sp)
    80005356:	6402                	ld	s0,0(sp)
    80005358:	0141                	addi	sp,sp,16
    8000535a:	8082                	ret

000000008000535c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000535c:	1101                	addi	sp,sp,-32
    8000535e:	ec06                	sd	ra,24(sp)
    80005360:	e822                	sd	s0,16(sp)
    80005362:	e426                	sd	s1,8(sp)
    80005364:	1000                	addi	s0,sp,32
    80005366:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005368:	ffffc097          	auipc	ra,0xffffc
    8000536c:	ab4080e7          	jalr	-1356(ra) # 80000e1c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005370:	00d5151b          	slliw	a0,a0,0xd
    80005374:	0c2017b7          	lui	a5,0xc201
    80005378:	97aa                	add	a5,a5,a0
    8000537a:	c3c4                	sw	s1,4(a5)
}
    8000537c:	60e2                	ld	ra,24(sp)
    8000537e:	6442                	ld	s0,16(sp)
    80005380:	64a2                	ld	s1,8(sp)
    80005382:	6105                	addi	sp,sp,32
    80005384:	8082                	ret

0000000080005386 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005386:	1141                	addi	sp,sp,-16
    80005388:	e406                	sd	ra,8(sp)
    8000538a:	e022                	sd	s0,0(sp)
    8000538c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000538e:	479d                	li	a5,7
    80005390:	06a7c963          	blt	a5,a0,80005402 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005394:	00016797          	auipc	a5,0x16
    80005398:	c6c78793          	addi	a5,a5,-916 # 8001b000 <disk>
    8000539c:	00a78733          	add	a4,a5,a0
    800053a0:	6789                	lui	a5,0x2
    800053a2:	97ba                	add	a5,a5,a4
    800053a4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800053a8:	e7ad                	bnez	a5,80005412 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053aa:	00451793          	slli	a5,a0,0x4
    800053ae:	00018717          	auipc	a4,0x18
    800053b2:	c5270713          	addi	a4,a4,-942 # 8001d000 <disk+0x2000>
    800053b6:	6314                	ld	a3,0(a4)
    800053b8:	96be                	add	a3,a3,a5
    800053ba:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800053be:	6314                	ld	a3,0(a4)
    800053c0:	96be                	add	a3,a3,a5
    800053c2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800053c6:	6314                	ld	a3,0(a4)
    800053c8:	96be                	add	a3,a3,a5
    800053ca:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800053ce:	6318                	ld	a4,0(a4)
    800053d0:	97ba                	add	a5,a5,a4
    800053d2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800053d6:	00016797          	auipc	a5,0x16
    800053da:	c2a78793          	addi	a5,a5,-982 # 8001b000 <disk>
    800053de:	97aa                	add	a5,a5,a0
    800053e0:	6509                	lui	a0,0x2
    800053e2:	953e                	add	a0,a0,a5
    800053e4:	4785                	li	a5,1
    800053e6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800053ea:	00018517          	auipc	a0,0x18
    800053ee:	c2e50513          	addi	a0,a0,-978 # 8001d018 <disk+0x2018>
    800053f2:	ffffc097          	auipc	ra,0xffffc
    800053f6:	2ac080e7          	jalr	684(ra) # 8000169e <wakeup>
}
    800053fa:	60a2                	ld	ra,8(sp)
    800053fc:	6402                	ld	s0,0(sp)
    800053fe:	0141                	addi	sp,sp,16
    80005400:	8082                	ret
    panic("free_desc 1");
    80005402:	00003517          	auipc	a0,0x3
    80005406:	31650513          	addi	a0,a0,790 # 80008718 <syscalls+0x350>
    8000540a:	00001097          	auipc	ra,0x1
    8000540e:	a1e080e7          	jalr	-1506(ra) # 80005e28 <panic>
    panic("free_desc 2");
    80005412:	00003517          	auipc	a0,0x3
    80005416:	31650513          	addi	a0,a0,790 # 80008728 <syscalls+0x360>
    8000541a:	00001097          	auipc	ra,0x1
    8000541e:	a0e080e7          	jalr	-1522(ra) # 80005e28 <panic>

0000000080005422 <virtio_disk_init>:
{
    80005422:	1101                	addi	sp,sp,-32
    80005424:	ec06                	sd	ra,24(sp)
    80005426:	e822                	sd	s0,16(sp)
    80005428:	e426                	sd	s1,8(sp)
    8000542a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000542c:	00003597          	auipc	a1,0x3
    80005430:	30c58593          	addi	a1,a1,780 # 80008738 <syscalls+0x370>
    80005434:	00018517          	auipc	a0,0x18
    80005438:	cf450513          	addi	a0,a0,-780 # 8001d128 <disk+0x2128>
    8000543c:	00001097          	auipc	ra,0x1
    80005440:	f02080e7          	jalr	-254(ra) # 8000633e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005444:	100017b7          	lui	a5,0x10001
    80005448:	4398                	lw	a4,0(a5)
    8000544a:	2701                	sext.w	a4,a4
    8000544c:	747277b7          	lui	a5,0x74727
    80005450:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005454:	0ef71163          	bne	a4,a5,80005536 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005458:	100017b7          	lui	a5,0x10001
    8000545c:	43dc                	lw	a5,4(a5)
    8000545e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005460:	4705                	li	a4,1
    80005462:	0ce79a63          	bne	a5,a4,80005536 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005466:	100017b7          	lui	a5,0x10001
    8000546a:	479c                	lw	a5,8(a5)
    8000546c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000546e:	4709                	li	a4,2
    80005470:	0ce79363          	bne	a5,a4,80005536 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005474:	100017b7          	lui	a5,0x10001
    80005478:	47d8                	lw	a4,12(a5)
    8000547a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000547c:	554d47b7          	lui	a5,0x554d4
    80005480:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005484:	0af71963          	bne	a4,a5,80005536 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005488:	100017b7          	lui	a5,0x10001
    8000548c:	4705                	li	a4,1
    8000548e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005490:	470d                	li	a4,3
    80005492:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005494:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005496:	c7ffe737          	lui	a4,0xc7ffe
    8000549a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000549e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054a0:	2701                	sext.w	a4,a4
    800054a2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054a4:	472d                	li	a4,11
    800054a6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054a8:	473d                	li	a4,15
    800054aa:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800054ac:	6705                	lui	a4,0x1
    800054ae:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054b0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054b4:	5bdc                	lw	a5,52(a5)
    800054b6:	2781                	sext.w	a5,a5
  if(max == 0)
    800054b8:	c7d9                	beqz	a5,80005546 <virtio_disk_init+0x124>
  if(max < NUM)
    800054ba:	471d                	li	a4,7
    800054bc:	08f77d63          	bgeu	a4,a5,80005556 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054c0:	100014b7          	lui	s1,0x10001
    800054c4:	47a1                	li	a5,8
    800054c6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800054c8:	6609                	lui	a2,0x2
    800054ca:	4581                	li	a1,0
    800054cc:	00016517          	auipc	a0,0x16
    800054d0:	b3450513          	addi	a0,a0,-1228 # 8001b000 <disk>
    800054d4:	ffffb097          	auipc	ra,0xffffb
    800054d8:	ca4080e7          	jalr	-860(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800054dc:	00016717          	auipc	a4,0x16
    800054e0:	b2470713          	addi	a4,a4,-1244 # 8001b000 <disk>
    800054e4:	00c75793          	srli	a5,a4,0xc
    800054e8:	2781                	sext.w	a5,a5
    800054ea:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800054ec:	00018797          	auipc	a5,0x18
    800054f0:	b1478793          	addi	a5,a5,-1260 # 8001d000 <disk+0x2000>
    800054f4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800054f6:	00016717          	auipc	a4,0x16
    800054fa:	b8a70713          	addi	a4,a4,-1142 # 8001b080 <disk+0x80>
    800054fe:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005500:	00017717          	auipc	a4,0x17
    80005504:	b0070713          	addi	a4,a4,-1280 # 8001c000 <disk+0x1000>
    80005508:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000550a:	4705                	li	a4,1
    8000550c:	00e78c23          	sb	a4,24(a5)
    80005510:	00e78ca3          	sb	a4,25(a5)
    80005514:	00e78d23          	sb	a4,26(a5)
    80005518:	00e78da3          	sb	a4,27(a5)
    8000551c:	00e78e23          	sb	a4,28(a5)
    80005520:	00e78ea3          	sb	a4,29(a5)
    80005524:	00e78f23          	sb	a4,30(a5)
    80005528:	00e78fa3          	sb	a4,31(a5)
}
    8000552c:	60e2                	ld	ra,24(sp)
    8000552e:	6442                	ld	s0,16(sp)
    80005530:	64a2                	ld	s1,8(sp)
    80005532:	6105                	addi	sp,sp,32
    80005534:	8082                	ret
    panic("could not find virtio disk");
    80005536:	00003517          	auipc	a0,0x3
    8000553a:	21250513          	addi	a0,a0,530 # 80008748 <syscalls+0x380>
    8000553e:	00001097          	auipc	ra,0x1
    80005542:	8ea080e7          	jalr	-1814(ra) # 80005e28 <panic>
    panic("virtio disk has no queue 0");
    80005546:	00003517          	auipc	a0,0x3
    8000554a:	22250513          	addi	a0,a0,546 # 80008768 <syscalls+0x3a0>
    8000554e:	00001097          	auipc	ra,0x1
    80005552:	8da080e7          	jalr	-1830(ra) # 80005e28 <panic>
    panic("virtio disk max queue too short");
    80005556:	00003517          	auipc	a0,0x3
    8000555a:	23250513          	addi	a0,a0,562 # 80008788 <syscalls+0x3c0>
    8000555e:	00001097          	auipc	ra,0x1
    80005562:	8ca080e7          	jalr	-1846(ra) # 80005e28 <panic>

0000000080005566 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005566:	7159                	addi	sp,sp,-112
    80005568:	f486                	sd	ra,104(sp)
    8000556a:	f0a2                	sd	s0,96(sp)
    8000556c:	eca6                	sd	s1,88(sp)
    8000556e:	e8ca                	sd	s2,80(sp)
    80005570:	e4ce                	sd	s3,72(sp)
    80005572:	e0d2                	sd	s4,64(sp)
    80005574:	fc56                	sd	s5,56(sp)
    80005576:	f85a                	sd	s6,48(sp)
    80005578:	f45e                	sd	s7,40(sp)
    8000557a:	f062                	sd	s8,32(sp)
    8000557c:	ec66                	sd	s9,24(sp)
    8000557e:	e86a                	sd	s10,16(sp)
    80005580:	1880                	addi	s0,sp,112
    80005582:	892a                	mv	s2,a0
    80005584:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005586:	00c52c83          	lw	s9,12(a0)
    8000558a:	001c9c9b          	slliw	s9,s9,0x1
    8000558e:	1c82                	slli	s9,s9,0x20
    80005590:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005594:	00018517          	auipc	a0,0x18
    80005598:	b9450513          	addi	a0,a0,-1132 # 8001d128 <disk+0x2128>
    8000559c:	00001097          	auipc	ra,0x1
    800055a0:	e32080e7          	jalr	-462(ra) # 800063ce <acquire>
  for(int i = 0; i < 3; i++){
    800055a4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800055a6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800055a8:	00016b97          	auipc	s7,0x16
    800055ac:	a58b8b93          	addi	s7,s7,-1448 # 8001b000 <disk>
    800055b0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800055b2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800055b4:	8a4e                	mv	s4,s3
    800055b6:	a051                	j	8000563a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800055b8:	00fb86b3          	add	a3,s7,a5
    800055bc:	96da                	add	a3,a3,s6
    800055be:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800055c2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800055c4:	0207c563          	bltz	a5,800055ee <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800055c8:	2485                	addiw	s1,s1,1
    800055ca:	0711                	addi	a4,a4,4
    800055cc:	25548063          	beq	s1,s5,8000580c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800055d0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800055d2:	00018697          	auipc	a3,0x18
    800055d6:	a4668693          	addi	a3,a3,-1466 # 8001d018 <disk+0x2018>
    800055da:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800055dc:	0006c583          	lbu	a1,0(a3)
    800055e0:	fde1                	bnez	a1,800055b8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800055e2:	2785                	addiw	a5,a5,1
    800055e4:	0685                	addi	a3,a3,1
    800055e6:	ff879be3          	bne	a5,s8,800055dc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800055ea:	57fd                	li	a5,-1
    800055ec:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800055ee:	02905a63          	blez	s1,80005622 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055f2:	f9042503          	lw	a0,-112(s0)
    800055f6:	00000097          	auipc	ra,0x0
    800055fa:	d90080e7          	jalr	-624(ra) # 80005386 <free_desc>
      for(int j = 0; j < i; j++)
    800055fe:	4785                	li	a5,1
    80005600:	0297d163          	bge	a5,s1,80005622 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005604:	f9442503          	lw	a0,-108(s0)
    80005608:	00000097          	auipc	ra,0x0
    8000560c:	d7e080e7          	jalr	-642(ra) # 80005386 <free_desc>
      for(int j = 0; j < i; j++)
    80005610:	4789                	li	a5,2
    80005612:	0097d863          	bge	a5,s1,80005622 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005616:	f9842503          	lw	a0,-104(s0)
    8000561a:	00000097          	auipc	ra,0x0
    8000561e:	d6c080e7          	jalr	-660(ra) # 80005386 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005622:	00018597          	auipc	a1,0x18
    80005626:	b0658593          	addi	a1,a1,-1274 # 8001d128 <disk+0x2128>
    8000562a:	00018517          	auipc	a0,0x18
    8000562e:	9ee50513          	addi	a0,a0,-1554 # 8001d018 <disk+0x2018>
    80005632:	ffffc097          	auipc	ra,0xffffc
    80005636:	ee0080e7          	jalr	-288(ra) # 80001512 <sleep>
  for(int i = 0; i < 3; i++){
    8000563a:	f9040713          	addi	a4,s0,-112
    8000563e:	84ce                	mv	s1,s3
    80005640:	bf41                	j	800055d0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005642:	20058713          	addi	a4,a1,512
    80005646:	00471693          	slli	a3,a4,0x4
    8000564a:	00016717          	auipc	a4,0x16
    8000564e:	9b670713          	addi	a4,a4,-1610 # 8001b000 <disk>
    80005652:	9736                	add	a4,a4,a3
    80005654:	4685                	li	a3,1
    80005656:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000565a:	20058713          	addi	a4,a1,512
    8000565e:	00471693          	slli	a3,a4,0x4
    80005662:	00016717          	auipc	a4,0x16
    80005666:	99e70713          	addi	a4,a4,-1634 # 8001b000 <disk>
    8000566a:	9736                	add	a4,a4,a3
    8000566c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005670:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005674:	7679                	lui	a2,0xffffe
    80005676:	963e                	add	a2,a2,a5
    80005678:	00018697          	auipc	a3,0x18
    8000567c:	98868693          	addi	a3,a3,-1656 # 8001d000 <disk+0x2000>
    80005680:	6298                	ld	a4,0(a3)
    80005682:	9732                	add	a4,a4,a2
    80005684:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005686:	6298                	ld	a4,0(a3)
    80005688:	9732                	add	a4,a4,a2
    8000568a:	4541                	li	a0,16
    8000568c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000568e:	6298                	ld	a4,0(a3)
    80005690:	9732                	add	a4,a4,a2
    80005692:	4505                	li	a0,1
    80005694:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005698:	f9442703          	lw	a4,-108(s0)
    8000569c:	6288                	ld	a0,0(a3)
    8000569e:	962a                	add	a2,a2,a0
    800056a0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800056a4:	0712                	slli	a4,a4,0x4
    800056a6:	6290                	ld	a2,0(a3)
    800056a8:	963a                	add	a2,a2,a4
    800056aa:	05890513          	addi	a0,s2,88
    800056ae:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800056b0:	6294                	ld	a3,0(a3)
    800056b2:	96ba                	add	a3,a3,a4
    800056b4:	40000613          	li	a2,1024
    800056b8:	c690                	sw	a2,8(a3)
  if(write)
    800056ba:	140d0063          	beqz	s10,800057fa <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800056be:	00018697          	auipc	a3,0x18
    800056c2:	9426b683          	ld	a3,-1726(a3) # 8001d000 <disk+0x2000>
    800056c6:	96ba                	add	a3,a3,a4
    800056c8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056cc:	00016817          	auipc	a6,0x16
    800056d0:	93480813          	addi	a6,a6,-1740 # 8001b000 <disk>
    800056d4:	00018517          	auipc	a0,0x18
    800056d8:	92c50513          	addi	a0,a0,-1748 # 8001d000 <disk+0x2000>
    800056dc:	6114                	ld	a3,0(a0)
    800056de:	96ba                	add	a3,a3,a4
    800056e0:	00c6d603          	lhu	a2,12(a3)
    800056e4:	00166613          	ori	a2,a2,1
    800056e8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800056ec:	f9842683          	lw	a3,-104(s0)
    800056f0:	6110                	ld	a2,0(a0)
    800056f2:	9732                	add	a4,a4,a2
    800056f4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056f8:	20058613          	addi	a2,a1,512
    800056fc:	0612                	slli	a2,a2,0x4
    800056fe:	9642                	add	a2,a2,a6
    80005700:	577d                	li	a4,-1
    80005702:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005706:	00469713          	slli	a4,a3,0x4
    8000570a:	6114                	ld	a3,0(a0)
    8000570c:	96ba                	add	a3,a3,a4
    8000570e:	03078793          	addi	a5,a5,48
    80005712:	97c2                	add	a5,a5,a6
    80005714:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005716:	611c                	ld	a5,0(a0)
    80005718:	97ba                	add	a5,a5,a4
    8000571a:	4685                	li	a3,1
    8000571c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000571e:	611c                	ld	a5,0(a0)
    80005720:	97ba                	add	a5,a5,a4
    80005722:	4809                	li	a6,2
    80005724:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005728:	611c                	ld	a5,0(a0)
    8000572a:	973e                	add	a4,a4,a5
    8000572c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005730:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005734:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005738:	6518                	ld	a4,8(a0)
    8000573a:	00275783          	lhu	a5,2(a4)
    8000573e:	8b9d                	andi	a5,a5,7
    80005740:	0786                	slli	a5,a5,0x1
    80005742:	97ba                	add	a5,a5,a4
    80005744:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005748:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000574c:	6518                	ld	a4,8(a0)
    8000574e:	00275783          	lhu	a5,2(a4)
    80005752:	2785                	addiw	a5,a5,1
    80005754:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005758:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000575c:	100017b7          	lui	a5,0x10001
    80005760:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005764:	00492703          	lw	a4,4(s2)
    80005768:	4785                	li	a5,1
    8000576a:	02f71163          	bne	a4,a5,8000578c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000576e:	00018997          	auipc	s3,0x18
    80005772:	9ba98993          	addi	s3,s3,-1606 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005776:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005778:	85ce                	mv	a1,s3
    8000577a:	854a                	mv	a0,s2
    8000577c:	ffffc097          	auipc	ra,0xffffc
    80005780:	d96080e7          	jalr	-618(ra) # 80001512 <sleep>
  while(b->disk == 1) {
    80005784:	00492783          	lw	a5,4(s2)
    80005788:	fe9788e3          	beq	a5,s1,80005778 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000578c:	f9042903          	lw	s2,-112(s0)
    80005790:	20090793          	addi	a5,s2,512
    80005794:	00479713          	slli	a4,a5,0x4
    80005798:	00016797          	auipc	a5,0x16
    8000579c:	86878793          	addi	a5,a5,-1944 # 8001b000 <disk>
    800057a0:	97ba                	add	a5,a5,a4
    800057a2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800057a6:	00018997          	auipc	s3,0x18
    800057aa:	85a98993          	addi	s3,s3,-1958 # 8001d000 <disk+0x2000>
    800057ae:	00491713          	slli	a4,s2,0x4
    800057b2:	0009b783          	ld	a5,0(s3)
    800057b6:	97ba                	add	a5,a5,a4
    800057b8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057bc:	854a                	mv	a0,s2
    800057be:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057c2:	00000097          	auipc	ra,0x0
    800057c6:	bc4080e7          	jalr	-1084(ra) # 80005386 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057ca:	8885                	andi	s1,s1,1
    800057cc:	f0ed                	bnez	s1,800057ae <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057ce:	00018517          	auipc	a0,0x18
    800057d2:	95a50513          	addi	a0,a0,-1702 # 8001d128 <disk+0x2128>
    800057d6:	00001097          	auipc	ra,0x1
    800057da:	cac080e7          	jalr	-852(ra) # 80006482 <release>
}
    800057de:	70a6                	ld	ra,104(sp)
    800057e0:	7406                	ld	s0,96(sp)
    800057e2:	64e6                	ld	s1,88(sp)
    800057e4:	6946                	ld	s2,80(sp)
    800057e6:	69a6                	ld	s3,72(sp)
    800057e8:	6a06                	ld	s4,64(sp)
    800057ea:	7ae2                	ld	s5,56(sp)
    800057ec:	7b42                	ld	s6,48(sp)
    800057ee:	7ba2                	ld	s7,40(sp)
    800057f0:	7c02                	ld	s8,32(sp)
    800057f2:	6ce2                	ld	s9,24(sp)
    800057f4:	6d42                	ld	s10,16(sp)
    800057f6:	6165                	addi	sp,sp,112
    800057f8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800057fa:	00018697          	auipc	a3,0x18
    800057fe:	8066b683          	ld	a3,-2042(a3) # 8001d000 <disk+0x2000>
    80005802:	96ba                	add	a3,a3,a4
    80005804:	4609                	li	a2,2
    80005806:	00c69623          	sh	a2,12(a3)
    8000580a:	b5c9                	j	800056cc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000580c:	f9042583          	lw	a1,-112(s0)
    80005810:	20058793          	addi	a5,a1,512
    80005814:	0792                	slli	a5,a5,0x4
    80005816:	00016517          	auipc	a0,0x16
    8000581a:	89250513          	addi	a0,a0,-1902 # 8001b0a8 <disk+0xa8>
    8000581e:	953e                	add	a0,a0,a5
  if(write)
    80005820:	e20d11e3          	bnez	s10,80005642 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005824:	20058713          	addi	a4,a1,512
    80005828:	00471693          	slli	a3,a4,0x4
    8000582c:	00015717          	auipc	a4,0x15
    80005830:	7d470713          	addi	a4,a4,2004 # 8001b000 <disk>
    80005834:	9736                	add	a4,a4,a3
    80005836:	0a072423          	sw	zero,168(a4)
    8000583a:	b505                	j	8000565a <virtio_disk_rw+0xf4>

000000008000583c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000583c:	1101                	addi	sp,sp,-32
    8000583e:	ec06                	sd	ra,24(sp)
    80005840:	e822                	sd	s0,16(sp)
    80005842:	e426                	sd	s1,8(sp)
    80005844:	e04a                	sd	s2,0(sp)
    80005846:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005848:	00018517          	auipc	a0,0x18
    8000584c:	8e050513          	addi	a0,a0,-1824 # 8001d128 <disk+0x2128>
    80005850:	00001097          	auipc	ra,0x1
    80005854:	b7e080e7          	jalr	-1154(ra) # 800063ce <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005858:	10001737          	lui	a4,0x10001
    8000585c:	533c                	lw	a5,96(a4)
    8000585e:	8b8d                	andi	a5,a5,3
    80005860:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005862:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005866:	00017797          	auipc	a5,0x17
    8000586a:	79a78793          	addi	a5,a5,1946 # 8001d000 <disk+0x2000>
    8000586e:	6b94                	ld	a3,16(a5)
    80005870:	0207d703          	lhu	a4,32(a5)
    80005874:	0026d783          	lhu	a5,2(a3)
    80005878:	06f70163          	beq	a4,a5,800058da <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000587c:	00015917          	auipc	s2,0x15
    80005880:	78490913          	addi	s2,s2,1924 # 8001b000 <disk>
    80005884:	00017497          	auipc	s1,0x17
    80005888:	77c48493          	addi	s1,s1,1916 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000588c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005890:	6898                	ld	a4,16(s1)
    80005892:	0204d783          	lhu	a5,32(s1)
    80005896:	8b9d                	andi	a5,a5,7
    80005898:	078e                	slli	a5,a5,0x3
    8000589a:	97ba                	add	a5,a5,a4
    8000589c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000589e:	20078713          	addi	a4,a5,512
    800058a2:	0712                	slli	a4,a4,0x4
    800058a4:	974a                	add	a4,a4,s2
    800058a6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800058aa:	e731                	bnez	a4,800058f6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058ac:	20078793          	addi	a5,a5,512
    800058b0:	0792                	slli	a5,a5,0x4
    800058b2:	97ca                	add	a5,a5,s2
    800058b4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800058b6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058ba:	ffffc097          	auipc	ra,0xffffc
    800058be:	de4080e7          	jalr	-540(ra) # 8000169e <wakeup>

    disk.used_idx += 1;
    800058c2:	0204d783          	lhu	a5,32(s1)
    800058c6:	2785                	addiw	a5,a5,1
    800058c8:	17c2                	slli	a5,a5,0x30
    800058ca:	93c1                	srli	a5,a5,0x30
    800058cc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058d0:	6898                	ld	a4,16(s1)
    800058d2:	00275703          	lhu	a4,2(a4)
    800058d6:	faf71be3          	bne	a4,a5,8000588c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800058da:	00018517          	auipc	a0,0x18
    800058de:	84e50513          	addi	a0,a0,-1970 # 8001d128 <disk+0x2128>
    800058e2:	00001097          	auipc	ra,0x1
    800058e6:	ba0080e7          	jalr	-1120(ra) # 80006482 <release>
}
    800058ea:	60e2                	ld	ra,24(sp)
    800058ec:	6442                	ld	s0,16(sp)
    800058ee:	64a2                	ld	s1,8(sp)
    800058f0:	6902                	ld	s2,0(sp)
    800058f2:	6105                	addi	sp,sp,32
    800058f4:	8082                	ret
      panic("virtio_disk_intr status");
    800058f6:	00003517          	auipc	a0,0x3
    800058fa:	eb250513          	addi	a0,a0,-334 # 800087a8 <syscalls+0x3e0>
    800058fe:	00000097          	auipc	ra,0x0
    80005902:	52a080e7          	jalr	1322(ra) # 80005e28 <panic>

0000000080005906 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005906:	1141                	addi	sp,sp,-16
    80005908:	e422                	sd	s0,8(sp)
    8000590a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000590c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005910:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005914:	0037979b          	slliw	a5,a5,0x3
    80005918:	02004737          	lui	a4,0x2004
    8000591c:	97ba                	add	a5,a5,a4
    8000591e:	0200c737          	lui	a4,0x200c
    80005922:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005926:	000f4637          	lui	a2,0xf4
    8000592a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000592e:	95b2                	add	a1,a1,a2
    80005930:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005932:	00269713          	slli	a4,a3,0x2
    80005936:	9736                	add	a4,a4,a3
    80005938:	00371693          	slli	a3,a4,0x3
    8000593c:	00018717          	auipc	a4,0x18
    80005940:	6c470713          	addi	a4,a4,1732 # 8001e000 <timer_scratch>
    80005944:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005946:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005948:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000594a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000594e:	00000797          	auipc	a5,0x0
    80005952:	97278793          	addi	a5,a5,-1678 # 800052c0 <timervec>
    80005956:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000595a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000595e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005962:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005966:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000596a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000596e:	30479073          	csrw	mie,a5
}
    80005972:	6422                	ld	s0,8(sp)
    80005974:	0141                	addi	sp,sp,16
    80005976:	8082                	ret

0000000080005978 <start>:
{
    80005978:	1141                	addi	sp,sp,-16
    8000597a:	e406                	sd	ra,8(sp)
    8000597c:	e022                	sd	s0,0(sp)
    8000597e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005980:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005984:	7779                	lui	a4,0xffffe
    80005986:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    8000598a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000598c:	6705                	lui	a4,0x1
    8000598e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005992:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005994:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005998:	ffffb797          	auipc	a5,0xffffb
    8000599c:	98e78793          	addi	a5,a5,-1650 # 80000326 <main>
    800059a0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800059a4:	4781                	li	a5,0
    800059a6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800059aa:	67c1                	lui	a5,0x10
    800059ac:	17fd                	addi	a5,a5,-1
    800059ae:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800059b2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800059b6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800059ba:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800059be:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800059c2:	57fd                	li	a5,-1
    800059c4:	83a9                	srli	a5,a5,0xa
    800059c6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800059ca:	47bd                	li	a5,15
    800059cc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800059d0:	00000097          	auipc	ra,0x0
    800059d4:	f36080e7          	jalr	-202(ra) # 80005906 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059d8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800059dc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800059de:	823e                	mv	tp,a5
  asm volatile("mret");
    800059e0:	30200073          	mret
}
    800059e4:	60a2                	ld	ra,8(sp)
    800059e6:	6402                	ld	s0,0(sp)
    800059e8:	0141                	addi	sp,sp,16
    800059ea:	8082                	ret

00000000800059ec <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800059ec:	715d                	addi	sp,sp,-80
    800059ee:	e486                	sd	ra,72(sp)
    800059f0:	e0a2                	sd	s0,64(sp)
    800059f2:	fc26                	sd	s1,56(sp)
    800059f4:	f84a                	sd	s2,48(sp)
    800059f6:	f44e                	sd	s3,40(sp)
    800059f8:	f052                	sd	s4,32(sp)
    800059fa:	ec56                	sd	s5,24(sp)
    800059fc:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800059fe:	04c05663          	blez	a2,80005a4a <consolewrite+0x5e>
    80005a02:	8a2a                	mv	s4,a0
    80005a04:	84ae                	mv	s1,a1
    80005a06:	89b2                	mv	s3,a2
    80005a08:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a0a:	5afd                	li	s5,-1
    80005a0c:	4685                	li	a3,1
    80005a0e:	8626                	mv	a2,s1
    80005a10:	85d2                	mv	a1,s4
    80005a12:	fbf40513          	addi	a0,s0,-65
    80005a16:	ffffc097          	auipc	ra,0xffffc
    80005a1a:	ef6080e7          	jalr	-266(ra) # 8000190c <either_copyin>
    80005a1e:	01550c63          	beq	a0,s5,80005a36 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005a22:	fbf44503          	lbu	a0,-65(s0)
    80005a26:	00000097          	auipc	ra,0x0
    80005a2a:	7ea080e7          	jalr	2026(ra) # 80006210 <uartputc>
  for(i = 0; i < n; i++){
    80005a2e:	2905                	addiw	s2,s2,1
    80005a30:	0485                	addi	s1,s1,1
    80005a32:	fd299de3          	bne	s3,s2,80005a0c <consolewrite+0x20>
  }

  return i;
}
    80005a36:	854a                	mv	a0,s2
    80005a38:	60a6                	ld	ra,72(sp)
    80005a3a:	6406                	ld	s0,64(sp)
    80005a3c:	74e2                	ld	s1,56(sp)
    80005a3e:	7942                	ld	s2,48(sp)
    80005a40:	79a2                	ld	s3,40(sp)
    80005a42:	7a02                	ld	s4,32(sp)
    80005a44:	6ae2                	ld	s5,24(sp)
    80005a46:	6161                	addi	sp,sp,80
    80005a48:	8082                	ret
  for(i = 0; i < n; i++){
    80005a4a:	4901                	li	s2,0
    80005a4c:	b7ed                	j	80005a36 <consolewrite+0x4a>

0000000080005a4e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a4e:	7119                	addi	sp,sp,-128
    80005a50:	fc86                	sd	ra,120(sp)
    80005a52:	f8a2                	sd	s0,112(sp)
    80005a54:	f4a6                	sd	s1,104(sp)
    80005a56:	f0ca                	sd	s2,96(sp)
    80005a58:	ecce                	sd	s3,88(sp)
    80005a5a:	e8d2                	sd	s4,80(sp)
    80005a5c:	e4d6                	sd	s5,72(sp)
    80005a5e:	e0da                	sd	s6,64(sp)
    80005a60:	fc5e                	sd	s7,56(sp)
    80005a62:	f862                	sd	s8,48(sp)
    80005a64:	f466                	sd	s9,40(sp)
    80005a66:	f06a                	sd	s10,32(sp)
    80005a68:	ec6e                	sd	s11,24(sp)
    80005a6a:	0100                	addi	s0,sp,128
    80005a6c:	8b2a                	mv	s6,a0
    80005a6e:	8aae                	mv	s5,a1
    80005a70:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a72:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005a76:	00020517          	auipc	a0,0x20
    80005a7a:	6ca50513          	addi	a0,a0,1738 # 80026140 <cons>
    80005a7e:	00001097          	auipc	ra,0x1
    80005a82:	950080e7          	jalr	-1712(ra) # 800063ce <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a86:	00020497          	auipc	s1,0x20
    80005a8a:	6ba48493          	addi	s1,s1,1722 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a8e:	89a6                	mv	s3,s1
    80005a90:	00020917          	auipc	s2,0x20
    80005a94:	74890913          	addi	s2,s2,1864 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a98:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a9a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a9c:	4da9                	li	s11,10
  while(n > 0){
    80005a9e:	07405863          	blez	s4,80005b0e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005aa2:	0984a783          	lw	a5,152(s1)
    80005aa6:	09c4a703          	lw	a4,156(s1)
    80005aaa:	02f71463          	bne	a4,a5,80005ad2 <consoleread+0x84>
      if(myproc()->killed){
    80005aae:	ffffb097          	auipc	ra,0xffffb
    80005ab2:	39a080e7          	jalr	922(ra) # 80000e48 <myproc>
    80005ab6:	551c                	lw	a5,40(a0)
    80005ab8:	e7b5                	bnez	a5,80005b24 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005aba:	85ce                	mv	a1,s3
    80005abc:	854a                	mv	a0,s2
    80005abe:	ffffc097          	auipc	ra,0xffffc
    80005ac2:	a54080e7          	jalr	-1452(ra) # 80001512 <sleep>
    while(cons.r == cons.w){
    80005ac6:	0984a783          	lw	a5,152(s1)
    80005aca:	09c4a703          	lw	a4,156(s1)
    80005ace:	fef700e3          	beq	a4,a5,80005aae <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005ad2:	0017871b          	addiw	a4,a5,1
    80005ad6:	08e4ac23          	sw	a4,152(s1)
    80005ada:	07f7f713          	andi	a4,a5,127
    80005ade:	9726                	add	a4,a4,s1
    80005ae0:	01874703          	lbu	a4,24(a4)
    80005ae4:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005ae8:	079c0663          	beq	s8,s9,80005b54 <consoleread+0x106>
    cbuf = c;
    80005aec:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005af0:	4685                	li	a3,1
    80005af2:	f8f40613          	addi	a2,s0,-113
    80005af6:	85d6                	mv	a1,s5
    80005af8:	855a                	mv	a0,s6
    80005afa:	ffffc097          	auipc	ra,0xffffc
    80005afe:	dbc080e7          	jalr	-580(ra) # 800018b6 <either_copyout>
    80005b02:	01a50663          	beq	a0,s10,80005b0e <consoleread+0xc0>
    dst++;
    80005b06:	0a85                	addi	s5,s5,1
    --n;
    80005b08:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005b0a:	f9bc1ae3          	bne	s8,s11,80005a9e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b0e:	00020517          	auipc	a0,0x20
    80005b12:	63250513          	addi	a0,a0,1586 # 80026140 <cons>
    80005b16:	00001097          	auipc	ra,0x1
    80005b1a:	96c080e7          	jalr	-1684(ra) # 80006482 <release>

  return target - n;
    80005b1e:	414b853b          	subw	a0,s7,s4
    80005b22:	a811                	j	80005b36 <consoleread+0xe8>
        release(&cons.lock);
    80005b24:	00020517          	auipc	a0,0x20
    80005b28:	61c50513          	addi	a0,a0,1564 # 80026140 <cons>
    80005b2c:	00001097          	auipc	ra,0x1
    80005b30:	956080e7          	jalr	-1706(ra) # 80006482 <release>
        return -1;
    80005b34:	557d                	li	a0,-1
}
    80005b36:	70e6                	ld	ra,120(sp)
    80005b38:	7446                	ld	s0,112(sp)
    80005b3a:	74a6                	ld	s1,104(sp)
    80005b3c:	7906                	ld	s2,96(sp)
    80005b3e:	69e6                	ld	s3,88(sp)
    80005b40:	6a46                	ld	s4,80(sp)
    80005b42:	6aa6                	ld	s5,72(sp)
    80005b44:	6b06                	ld	s6,64(sp)
    80005b46:	7be2                	ld	s7,56(sp)
    80005b48:	7c42                	ld	s8,48(sp)
    80005b4a:	7ca2                	ld	s9,40(sp)
    80005b4c:	7d02                	ld	s10,32(sp)
    80005b4e:	6de2                	ld	s11,24(sp)
    80005b50:	6109                	addi	sp,sp,128
    80005b52:	8082                	ret
      if(n < target){
    80005b54:	000a071b          	sext.w	a4,s4
    80005b58:	fb777be3          	bgeu	a4,s7,80005b0e <consoleread+0xc0>
        cons.r--;
    80005b5c:	00020717          	auipc	a4,0x20
    80005b60:	66f72e23          	sw	a5,1660(a4) # 800261d8 <cons+0x98>
    80005b64:	b76d                	j	80005b0e <consoleread+0xc0>

0000000080005b66 <consputc>:
{
    80005b66:	1141                	addi	sp,sp,-16
    80005b68:	e406                	sd	ra,8(sp)
    80005b6a:	e022                	sd	s0,0(sp)
    80005b6c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b6e:	10000793          	li	a5,256
    80005b72:	00f50a63          	beq	a0,a5,80005b86 <consputc+0x20>
    uartputc_sync(c);
    80005b76:	00000097          	auipc	ra,0x0
    80005b7a:	5c0080e7          	jalr	1472(ra) # 80006136 <uartputc_sync>
}
    80005b7e:	60a2                	ld	ra,8(sp)
    80005b80:	6402                	ld	s0,0(sp)
    80005b82:	0141                	addi	sp,sp,16
    80005b84:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b86:	4521                	li	a0,8
    80005b88:	00000097          	auipc	ra,0x0
    80005b8c:	5ae080e7          	jalr	1454(ra) # 80006136 <uartputc_sync>
    80005b90:	02000513          	li	a0,32
    80005b94:	00000097          	auipc	ra,0x0
    80005b98:	5a2080e7          	jalr	1442(ra) # 80006136 <uartputc_sync>
    80005b9c:	4521                	li	a0,8
    80005b9e:	00000097          	auipc	ra,0x0
    80005ba2:	598080e7          	jalr	1432(ra) # 80006136 <uartputc_sync>
    80005ba6:	bfe1                	j	80005b7e <consputc+0x18>

0000000080005ba8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ba8:	1101                	addi	sp,sp,-32
    80005baa:	ec06                	sd	ra,24(sp)
    80005bac:	e822                	sd	s0,16(sp)
    80005bae:	e426                	sd	s1,8(sp)
    80005bb0:	e04a                	sd	s2,0(sp)
    80005bb2:	1000                	addi	s0,sp,32
    80005bb4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005bb6:	00020517          	auipc	a0,0x20
    80005bba:	58a50513          	addi	a0,a0,1418 # 80026140 <cons>
    80005bbe:	00001097          	auipc	ra,0x1
    80005bc2:	810080e7          	jalr	-2032(ra) # 800063ce <acquire>

  switch(c){
    80005bc6:	47d5                	li	a5,21
    80005bc8:	0af48663          	beq	s1,a5,80005c74 <consoleintr+0xcc>
    80005bcc:	0297ca63          	blt	a5,s1,80005c00 <consoleintr+0x58>
    80005bd0:	47a1                	li	a5,8
    80005bd2:	0ef48763          	beq	s1,a5,80005cc0 <consoleintr+0x118>
    80005bd6:	47c1                	li	a5,16
    80005bd8:	10f49a63          	bne	s1,a5,80005cec <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005bdc:	ffffc097          	auipc	ra,0xffffc
    80005be0:	d86080e7          	jalr	-634(ra) # 80001962 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005be4:	00020517          	auipc	a0,0x20
    80005be8:	55c50513          	addi	a0,a0,1372 # 80026140 <cons>
    80005bec:	00001097          	auipc	ra,0x1
    80005bf0:	896080e7          	jalr	-1898(ra) # 80006482 <release>
}
    80005bf4:	60e2                	ld	ra,24(sp)
    80005bf6:	6442                	ld	s0,16(sp)
    80005bf8:	64a2                	ld	s1,8(sp)
    80005bfa:	6902                	ld	s2,0(sp)
    80005bfc:	6105                	addi	sp,sp,32
    80005bfe:	8082                	ret
  switch(c){
    80005c00:	07f00793          	li	a5,127
    80005c04:	0af48e63          	beq	s1,a5,80005cc0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c08:	00020717          	auipc	a4,0x20
    80005c0c:	53870713          	addi	a4,a4,1336 # 80026140 <cons>
    80005c10:	0a072783          	lw	a5,160(a4)
    80005c14:	09872703          	lw	a4,152(a4)
    80005c18:	9f99                	subw	a5,a5,a4
    80005c1a:	07f00713          	li	a4,127
    80005c1e:	fcf763e3          	bltu	a4,a5,80005be4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c22:	47b5                	li	a5,13
    80005c24:	0cf48763          	beq	s1,a5,80005cf2 <consoleintr+0x14a>
      consputc(c);
    80005c28:	8526                	mv	a0,s1
    80005c2a:	00000097          	auipc	ra,0x0
    80005c2e:	f3c080e7          	jalr	-196(ra) # 80005b66 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c32:	00020797          	auipc	a5,0x20
    80005c36:	50e78793          	addi	a5,a5,1294 # 80026140 <cons>
    80005c3a:	0a07a703          	lw	a4,160(a5)
    80005c3e:	0017069b          	addiw	a3,a4,1
    80005c42:	0006861b          	sext.w	a2,a3
    80005c46:	0ad7a023          	sw	a3,160(a5)
    80005c4a:	07f77713          	andi	a4,a4,127
    80005c4e:	97ba                	add	a5,a5,a4
    80005c50:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005c54:	47a9                	li	a5,10
    80005c56:	0cf48563          	beq	s1,a5,80005d20 <consoleintr+0x178>
    80005c5a:	4791                	li	a5,4
    80005c5c:	0cf48263          	beq	s1,a5,80005d20 <consoleintr+0x178>
    80005c60:	00020797          	auipc	a5,0x20
    80005c64:	5787a783          	lw	a5,1400(a5) # 800261d8 <cons+0x98>
    80005c68:	0807879b          	addiw	a5,a5,128
    80005c6c:	f6f61ce3          	bne	a2,a5,80005be4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c70:	863e                	mv	a2,a5
    80005c72:	a07d                	j	80005d20 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c74:	00020717          	auipc	a4,0x20
    80005c78:	4cc70713          	addi	a4,a4,1228 # 80026140 <cons>
    80005c7c:	0a072783          	lw	a5,160(a4)
    80005c80:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c84:	00020497          	auipc	s1,0x20
    80005c88:	4bc48493          	addi	s1,s1,1212 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005c8c:	4929                	li	s2,10
    80005c8e:	f4f70be3          	beq	a4,a5,80005be4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c92:	37fd                	addiw	a5,a5,-1
    80005c94:	07f7f713          	andi	a4,a5,127
    80005c98:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c9a:	01874703          	lbu	a4,24(a4)
    80005c9e:	f52703e3          	beq	a4,s2,80005be4 <consoleintr+0x3c>
      cons.e--;
    80005ca2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ca6:	10000513          	li	a0,256
    80005caa:	00000097          	auipc	ra,0x0
    80005cae:	ebc080e7          	jalr	-324(ra) # 80005b66 <consputc>
    while(cons.e != cons.w &&
    80005cb2:	0a04a783          	lw	a5,160(s1)
    80005cb6:	09c4a703          	lw	a4,156(s1)
    80005cba:	fcf71ce3          	bne	a4,a5,80005c92 <consoleintr+0xea>
    80005cbe:	b71d                	j	80005be4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005cc0:	00020717          	auipc	a4,0x20
    80005cc4:	48070713          	addi	a4,a4,1152 # 80026140 <cons>
    80005cc8:	0a072783          	lw	a5,160(a4)
    80005ccc:	09c72703          	lw	a4,156(a4)
    80005cd0:	f0f70ae3          	beq	a4,a5,80005be4 <consoleintr+0x3c>
      cons.e--;
    80005cd4:	37fd                	addiw	a5,a5,-1
    80005cd6:	00020717          	auipc	a4,0x20
    80005cda:	50f72523          	sw	a5,1290(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005cde:	10000513          	li	a0,256
    80005ce2:	00000097          	auipc	ra,0x0
    80005ce6:	e84080e7          	jalr	-380(ra) # 80005b66 <consputc>
    80005cea:	bded                	j	80005be4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005cec:	ee048ce3          	beqz	s1,80005be4 <consoleintr+0x3c>
    80005cf0:	bf21                	j	80005c08 <consoleintr+0x60>
      consputc(c);
    80005cf2:	4529                	li	a0,10
    80005cf4:	00000097          	auipc	ra,0x0
    80005cf8:	e72080e7          	jalr	-398(ra) # 80005b66 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005cfc:	00020797          	auipc	a5,0x20
    80005d00:	44478793          	addi	a5,a5,1092 # 80026140 <cons>
    80005d04:	0a07a703          	lw	a4,160(a5)
    80005d08:	0017069b          	addiw	a3,a4,1
    80005d0c:	0006861b          	sext.w	a2,a3
    80005d10:	0ad7a023          	sw	a3,160(a5)
    80005d14:	07f77713          	andi	a4,a4,127
    80005d18:	97ba                	add	a5,a5,a4
    80005d1a:	4729                	li	a4,10
    80005d1c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d20:	00020797          	auipc	a5,0x20
    80005d24:	4ac7ae23          	sw	a2,1212(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005d28:	00020517          	auipc	a0,0x20
    80005d2c:	4b050513          	addi	a0,a0,1200 # 800261d8 <cons+0x98>
    80005d30:	ffffc097          	auipc	ra,0xffffc
    80005d34:	96e080e7          	jalr	-1682(ra) # 8000169e <wakeup>
    80005d38:	b575                	j	80005be4 <consoleintr+0x3c>

0000000080005d3a <consoleinit>:

void
consoleinit(void)
{
    80005d3a:	1141                	addi	sp,sp,-16
    80005d3c:	e406                	sd	ra,8(sp)
    80005d3e:	e022                	sd	s0,0(sp)
    80005d40:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d42:	00003597          	auipc	a1,0x3
    80005d46:	a7e58593          	addi	a1,a1,-1410 # 800087c0 <syscalls+0x3f8>
    80005d4a:	00020517          	auipc	a0,0x20
    80005d4e:	3f650513          	addi	a0,a0,1014 # 80026140 <cons>
    80005d52:	00000097          	auipc	ra,0x0
    80005d56:	5ec080e7          	jalr	1516(ra) # 8000633e <initlock>

  uartinit();
    80005d5a:	00000097          	auipc	ra,0x0
    80005d5e:	38c080e7          	jalr	908(ra) # 800060e6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d62:	00014797          	auipc	a5,0x14
    80005d66:	96678793          	addi	a5,a5,-1690 # 800196c8 <devsw>
    80005d6a:	00000717          	auipc	a4,0x0
    80005d6e:	ce470713          	addi	a4,a4,-796 # 80005a4e <consoleread>
    80005d72:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d74:	00000717          	auipc	a4,0x0
    80005d78:	c7870713          	addi	a4,a4,-904 # 800059ec <consolewrite>
    80005d7c:	ef98                	sd	a4,24(a5)
}
    80005d7e:	60a2                	ld	ra,8(sp)
    80005d80:	6402                	ld	s0,0(sp)
    80005d82:	0141                	addi	sp,sp,16
    80005d84:	8082                	ret

0000000080005d86 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d86:	7179                	addi	sp,sp,-48
    80005d88:	f406                	sd	ra,40(sp)
    80005d8a:	f022                	sd	s0,32(sp)
    80005d8c:	ec26                	sd	s1,24(sp)
    80005d8e:	e84a                	sd	s2,16(sp)
    80005d90:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d92:	c219                	beqz	a2,80005d98 <printint+0x12>
    80005d94:	08054663          	bltz	a0,80005e20 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005d98:	2501                	sext.w	a0,a0
    80005d9a:	4881                	li	a7,0
    80005d9c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005da0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005da2:	2581                	sext.w	a1,a1
    80005da4:	00003617          	auipc	a2,0x3
    80005da8:	a5460613          	addi	a2,a2,-1452 # 800087f8 <digits>
    80005dac:	883a                	mv	a6,a4
    80005dae:	2705                	addiw	a4,a4,1
    80005db0:	02b577bb          	remuw	a5,a0,a1
    80005db4:	1782                	slli	a5,a5,0x20
    80005db6:	9381                	srli	a5,a5,0x20
    80005db8:	97b2                	add	a5,a5,a2
    80005dba:	0007c783          	lbu	a5,0(a5)
    80005dbe:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005dc2:	0005079b          	sext.w	a5,a0
    80005dc6:	02b5553b          	divuw	a0,a0,a1
    80005dca:	0685                	addi	a3,a3,1
    80005dcc:	feb7f0e3          	bgeu	a5,a1,80005dac <printint+0x26>

  if(sign)
    80005dd0:	00088b63          	beqz	a7,80005de6 <printint+0x60>
    buf[i++] = '-';
    80005dd4:	fe040793          	addi	a5,s0,-32
    80005dd8:	973e                	add	a4,a4,a5
    80005dda:	02d00793          	li	a5,45
    80005dde:	fef70823          	sb	a5,-16(a4)
    80005de2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005de6:	02e05763          	blez	a4,80005e14 <printint+0x8e>
    80005dea:	fd040793          	addi	a5,s0,-48
    80005dee:	00e784b3          	add	s1,a5,a4
    80005df2:	fff78913          	addi	s2,a5,-1
    80005df6:	993a                	add	s2,s2,a4
    80005df8:	377d                	addiw	a4,a4,-1
    80005dfa:	1702                	slli	a4,a4,0x20
    80005dfc:	9301                	srli	a4,a4,0x20
    80005dfe:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e02:	fff4c503          	lbu	a0,-1(s1)
    80005e06:	00000097          	auipc	ra,0x0
    80005e0a:	d60080e7          	jalr	-672(ra) # 80005b66 <consputc>
  while(--i >= 0)
    80005e0e:	14fd                	addi	s1,s1,-1
    80005e10:	ff2499e3          	bne	s1,s2,80005e02 <printint+0x7c>
}
    80005e14:	70a2                	ld	ra,40(sp)
    80005e16:	7402                	ld	s0,32(sp)
    80005e18:	64e2                	ld	s1,24(sp)
    80005e1a:	6942                	ld	s2,16(sp)
    80005e1c:	6145                	addi	sp,sp,48
    80005e1e:	8082                	ret
    x = -xx;
    80005e20:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e24:	4885                	li	a7,1
    x = -xx;
    80005e26:	bf9d                	j	80005d9c <printint+0x16>

0000000080005e28 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e28:	1101                	addi	sp,sp,-32
    80005e2a:	ec06                	sd	ra,24(sp)
    80005e2c:	e822                	sd	s0,16(sp)
    80005e2e:	e426                	sd	s1,8(sp)
    80005e30:	1000                	addi	s0,sp,32
    80005e32:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e34:	00020797          	auipc	a5,0x20
    80005e38:	3c07a623          	sw	zero,972(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005e3c:	00003517          	auipc	a0,0x3
    80005e40:	98c50513          	addi	a0,a0,-1652 # 800087c8 <syscalls+0x400>
    80005e44:	00000097          	auipc	ra,0x0
    80005e48:	02e080e7          	jalr	46(ra) # 80005e72 <printf>
  printf(s);
    80005e4c:	8526                	mv	a0,s1
    80005e4e:	00000097          	auipc	ra,0x0
    80005e52:	024080e7          	jalr	36(ra) # 80005e72 <printf>
  printf("\n");
    80005e56:	00002517          	auipc	a0,0x2
    80005e5a:	1f250513          	addi	a0,a0,498 # 80008048 <etext+0x48>
    80005e5e:	00000097          	auipc	ra,0x0
    80005e62:	014080e7          	jalr	20(ra) # 80005e72 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e66:	4785                	li	a5,1
    80005e68:	00003717          	auipc	a4,0x3
    80005e6c:	1af72a23          	sw	a5,436(a4) # 8000901c <panicked>
  for(;;)
    80005e70:	a001                	j	80005e70 <panic+0x48>

0000000080005e72 <printf>:
{
    80005e72:	7131                	addi	sp,sp,-192
    80005e74:	fc86                	sd	ra,120(sp)
    80005e76:	f8a2                	sd	s0,112(sp)
    80005e78:	f4a6                	sd	s1,104(sp)
    80005e7a:	f0ca                	sd	s2,96(sp)
    80005e7c:	ecce                	sd	s3,88(sp)
    80005e7e:	e8d2                	sd	s4,80(sp)
    80005e80:	e4d6                	sd	s5,72(sp)
    80005e82:	e0da                	sd	s6,64(sp)
    80005e84:	fc5e                	sd	s7,56(sp)
    80005e86:	f862                	sd	s8,48(sp)
    80005e88:	f466                	sd	s9,40(sp)
    80005e8a:	f06a                	sd	s10,32(sp)
    80005e8c:	ec6e                	sd	s11,24(sp)
    80005e8e:	0100                	addi	s0,sp,128
    80005e90:	8a2a                	mv	s4,a0
    80005e92:	e40c                	sd	a1,8(s0)
    80005e94:	e810                	sd	a2,16(s0)
    80005e96:	ec14                	sd	a3,24(s0)
    80005e98:	f018                	sd	a4,32(s0)
    80005e9a:	f41c                	sd	a5,40(s0)
    80005e9c:	03043823          	sd	a6,48(s0)
    80005ea0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005ea4:	00020d97          	auipc	s11,0x20
    80005ea8:	35cdad83          	lw	s11,860(s11) # 80026200 <pr+0x18>
  if(locking)
    80005eac:	020d9b63          	bnez	s11,80005ee2 <printf+0x70>
  if (fmt == 0)
    80005eb0:	040a0263          	beqz	s4,80005ef4 <printf+0x82>
  va_start(ap, fmt);
    80005eb4:	00840793          	addi	a5,s0,8
    80005eb8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ebc:	000a4503          	lbu	a0,0(s4)
    80005ec0:	16050263          	beqz	a0,80006024 <printf+0x1b2>
    80005ec4:	4481                	li	s1,0
    if(c != '%'){
    80005ec6:	02500a93          	li	s5,37
    switch(c){
    80005eca:	07000b13          	li	s6,112
  consputc('x');
    80005ece:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ed0:	00003b97          	auipc	s7,0x3
    80005ed4:	928b8b93          	addi	s7,s7,-1752 # 800087f8 <digits>
    switch(c){
    80005ed8:	07300c93          	li	s9,115
    80005edc:	06400c13          	li	s8,100
    80005ee0:	a82d                	j	80005f1a <printf+0xa8>
    acquire(&pr.lock);
    80005ee2:	00020517          	auipc	a0,0x20
    80005ee6:	30650513          	addi	a0,a0,774 # 800261e8 <pr>
    80005eea:	00000097          	auipc	ra,0x0
    80005eee:	4e4080e7          	jalr	1252(ra) # 800063ce <acquire>
    80005ef2:	bf7d                	j	80005eb0 <printf+0x3e>
    panic("null fmt");
    80005ef4:	00003517          	auipc	a0,0x3
    80005ef8:	8e450513          	addi	a0,a0,-1820 # 800087d8 <syscalls+0x410>
    80005efc:	00000097          	auipc	ra,0x0
    80005f00:	f2c080e7          	jalr	-212(ra) # 80005e28 <panic>
      consputc(c);
    80005f04:	00000097          	auipc	ra,0x0
    80005f08:	c62080e7          	jalr	-926(ra) # 80005b66 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f0c:	2485                	addiw	s1,s1,1
    80005f0e:	009a07b3          	add	a5,s4,s1
    80005f12:	0007c503          	lbu	a0,0(a5)
    80005f16:	10050763          	beqz	a0,80006024 <printf+0x1b2>
    if(c != '%'){
    80005f1a:	ff5515e3          	bne	a0,s5,80005f04 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f1e:	2485                	addiw	s1,s1,1
    80005f20:	009a07b3          	add	a5,s4,s1
    80005f24:	0007c783          	lbu	a5,0(a5)
    80005f28:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005f2c:	cfe5                	beqz	a5,80006024 <printf+0x1b2>
    switch(c){
    80005f2e:	05678a63          	beq	a5,s6,80005f82 <printf+0x110>
    80005f32:	02fb7663          	bgeu	s6,a5,80005f5e <printf+0xec>
    80005f36:	09978963          	beq	a5,s9,80005fc8 <printf+0x156>
    80005f3a:	07800713          	li	a4,120
    80005f3e:	0ce79863          	bne	a5,a4,8000600e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005f42:	f8843783          	ld	a5,-120(s0)
    80005f46:	00878713          	addi	a4,a5,8
    80005f4a:	f8e43423          	sd	a4,-120(s0)
    80005f4e:	4605                	li	a2,1
    80005f50:	85ea                	mv	a1,s10
    80005f52:	4388                	lw	a0,0(a5)
    80005f54:	00000097          	auipc	ra,0x0
    80005f58:	e32080e7          	jalr	-462(ra) # 80005d86 <printint>
      break;
    80005f5c:	bf45                	j	80005f0c <printf+0x9a>
    switch(c){
    80005f5e:	0b578263          	beq	a5,s5,80006002 <printf+0x190>
    80005f62:	0b879663          	bne	a5,s8,8000600e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005f66:	f8843783          	ld	a5,-120(s0)
    80005f6a:	00878713          	addi	a4,a5,8
    80005f6e:	f8e43423          	sd	a4,-120(s0)
    80005f72:	4605                	li	a2,1
    80005f74:	45a9                	li	a1,10
    80005f76:	4388                	lw	a0,0(a5)
    80005f78:	00000097          	auipc	ra,0x0
    80005f7c:	e0e080e7          	jalr	-498(ra) # 80005d86 <printint>
      break;
    80005f80:	b771                	j	80005f0c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f82:	f8843783          	ld	a5,-120(s0)
    80005f86:	00878713          	addi	a4,a5,8
    80005f8a:	f8e43423          	sd	a4,-120(s0)
    80005f8e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005f92:	03000513          	li	a0,48
    80005f96:	00000097          	auipc	ra,0x0
    80005f9a:	bd0080e7          	jalr	-1072(ra) # 80005b66 <consputc>
  consputc('x');
    80005f9e:	07800513          	li	a0,120
    80005fa2:	00000097          	auipc	ra,0x0
    80005fa6:	bc4080e7          	jalr	-1084(ra) # 80005b66 <consputc>
    80005faa:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fac:	03c9d793          	srli	a5,s3,0x3c
    80005fb0:	97de                	add	a5,a5,s7
    80005fb2:	0007c503          	lbu	a0,0(a5)
    80005fb6:	00000097          	auipc	ra,0x0
    80005fba:	bb0080e7          	jalr	-1104(ra) # 80005b66 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005fbe:	0992                	slli	s3,s3,0x4
    80005fc0:	397d                	addiw	s2,s2,-1
    80005fc2:	fe0915e3          	bnez	s2,80005fac <printf+0x13a>
    80005fc6:	b799                	j	80005f0c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005fc8:	f8843783          	ld	a5,-120(s0)
    80005fcc:	00878713          	addi	a4,a5,8
    80005fd0:	f8e43423          	sd	a4,-120(s0)
    80005fd4:	0007b903          	ld	s2,0(a5)
    80005fd8:	00090e63          	beqz	s2,80005ff4 <printf+0x182>
      for(; *s; s++)
    80005fdc:	00094503          	lbu	a0,0(s2)
    80005fe0:	d515                	beqz	a0,80005f0c <printf+0x9a>
        consputc(*s);
    80005fe2:	00000097          	auipc	ra,0x0
    80005fe6:	b84080e7          	jalr	-1148(ra) # 80005b66 <consputc>
      for(; *s; s++)
    80005fea:	0905                	addi	s2,s2,1
    80005fec:	00094503          	lbu	a0,0(s2)
    80005ff0:	f96d                	bnez	a0,80005fe2 <printf+0x170>
    80005ff2:	bf29                	j	80005f0c <printf+0x9a>
        s = "(null)";
    80005ff4:	00002917          	auipc	s2,0x2
    80005ff8:	7dc90913          	addi	s2,s2,2012 # 800087d0 <syscalls+0x408>
      for(; *s; s++)
    80005ffc:	02800513          	li	a0,40
    80006000:	b7cd                	j	80005fe2 <printf+0x170>
      consputc('%');
    80006002:	8556                	mv	a0,s5
    80006004:	00000097          	auipc	ra,0x0
    80006008:	b62080e7          	jalr	-1182(ra) # 80005b66 <consputc>
      break;
    8000600c:	b701                	j	80005f0c <printf+0x9a>
      consputc('%');
    8000600e:	8556                	mv	a0,s5
    80006010:	00000097          	auipc	ra,0x0
    80006014:	b56080e7          	jalr	-1194(ra) # 80005b66 <consputc>
      consputc(c);
    80006018:	854a                	mv	a0,s2
    8000601a:	00000097          	auipc	ra,0x0
    8000601e:	b4c080e7          	jalr	-1204(ra) # 80005b66 <consputc>
      break;
    80006022:	b5ed                	j	80005f0c <printf+0x9a>
  if(locking)
    80006024:	020d9163          	bnez	s11,80006046 <printf+0x1d4>
}
    80006028:	70e6                	ld	ra,120(sp)
    8000602a:	7446                	ld	s0,112(sp)
    8000602c:	74a6                	ld	s1,104(sp)
    8000602e:	7906                	ld	s2,96(sp)
    80006030:	69e6                	ld	s3,88(sp)
    80006032:	6a46                	ld	s4,80(sp)
    80006034:	6aa6                	ld	s5,72(sp)
    80006036:	6b06                	ld	s6,64(sp)
    80006038:	7be2                	ld	s7,56(sp)
    8000603a:	7c42                	ld	s8,48(sp)
    8000603c:	7ca2                	ld	s9,40(sp)
    8000603e:	7d02                	ld	s10,32(sp)
    80006040:	6de2                	ld	s11,24(sp)
    80006042:	6129                	addi	sp,sp,192
    80006044:	8082                	ret
    release(&pr.lock);
    80006046:	00020517          	auipc	a0,0x20
    8000604a:	1a250513          	addi	a0,a0,418 # 800261e8 <pr>
    8000604e:	00000097          	auipc	ra,0x0
    80006052:	434080e7          	jalr	1076(ra) # 80006482 <release>
}
    80006056:	bfc9                	j	80006028 <printf+0x1b6>

0000000080006058 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006058:	1101                	addi	sp,sp,-32
    8000605a:	ec06                	sd	ra,24(sp)
    8000605c:	e822                	sd	s0,16(sp)
    8000605e:	e426                	sd	s1,8(sp)
    80006060:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006062:	00020497          	auipc	s1,0x20
    80006066:	18648493          	addi	s1,s1,390 # 800261e8 <pr>
    8000606a:	00002597          	auipc	a1,0x2
    8000606e:	77e58593          	addi	a1,a1,1918 # 800087e8 <syscalls+0x420>
    80006072:	8526                	mv	a0,s1
    80006074:	00000097          	auipc	ra,0x0
    80006078:	2ca080e7          	jalr	714(ra) # 8000633e <initlock>
  pr.locking = 1;
    8000607c:	4785                	li	a5,1
    8000607e:	cc9c                	sw	a5,24(s1)
}
    80006080:	60e2                	ld	ra,24(sp)
    80006082:	6442                	ld	s0,16(sp)
    80006084:	64a2                	ld	s1,8(sp)
    80006086:	6105                	addi	sp,sp,32
    80006088:	8082                	ret

000000008000608a <backtrace>:

void backtrace(void){
    8000608a:	7179                	addi	sp,sp,-48
    8000608c:	f406                	sd	ra,40(sp)
    8000608e:	f022                	sd	s0,32(sp)
    80006090:	ec26                	sd	s1,24(sp)
    80006092:	e84a                	sd	s2,16(sp)
    80006094:	e44e                	sd	s3,8(sp)
    80006096:	e052                	sd	s4,0(sp)
    80006098:	1800                	addi	s0,sp,48
  asm volatile("mv %0, s0" : "=r" (x) );
    8000609a:	84a2                	mv	s1,s0
    uint64 fp = r_fp();
    uint64 stack_top = PGROUNDUP(fp);
    8000609c:	6905                	lui	s2,0x1
    8000609e:	197d                	addi	s2,s2,-1
    800060a0:	9926                	add	s2,s2,s1
    800060a2:	79fd                	lui	s3,0xfffff
    800060a4:	01397933          	and	s2,s2,s3
    uint64 stack_down = PGROUNDDOWN(fp);
    800060a8:	0134f9b3          	and	s3,s1,s3
    while(fp < stack_top && fp > stack_down){
    800060ac:	0324f563          	bgeu	s1,s2,800060d6 <backtrace+0x4c>
    800060b0:	0299f363          	bgeu	s3,s1,800060d6 <backtrace+0x4c>
        printf("%p\n",*(uint64*)(fp - 8));
    800060b4:	00002a17          	auipc	s4,0x2
    800060b8:	73ca0a13          	addi	s4,s4,1852 # 800087f0 <syscalls+0x428>
    800060bc:	ff84b583          	ld	a1,-8(s1)
    800060c0:	8552                	mv	a0,s4
    800060c2:	00000097          	auipc	ra,0x0
    800060c6:	db0080e7          	jalr	-592(ra) # 80005e72 <printf>
        fp = *(uint64*)(fp-16);
    800060ca:	ff04b483          	ld	s1,-16(s1)
    while(fp < stack_top && fp > stack_down){
    800060ce:	0124f463          	bgeu	s1,s2,800060d6 <backtrace+0x4c>
    800060d2:	fe99e5e3          	bltu	s3,s1,800060bc <backtrace+0x32>
    }
    return;
}
    800060d6:	70a2                	ld	ra,40(sp)
    800060d8:	7402                	ld	s0,32(sp)
    800060da:	64e2                	ld	s1,24(sp)
    800060dc:	6942                	ld	s2,16(sp)
    800060de:	69a2                	ld	s3,8(sp)
    800060e0:	6a02                	ld	s4,0(sp)
    800060e2:	6145                	addi	sp,sp,48
    800060e4:	8082                	ret

00000000800060e6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800060e6:	1141                	addi	sp,sp,-16
    800060e8:	e406                	sd	ra,8(sp)
    800060ea:	e022                	sd	s0,0(sp)
    800060ec:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800060ee:	100007b7          	lui	a5,0x10000
    800060f2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060f6:	f8000713          	li	a4,-128
    800060fa:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060fe:	470d                	li	a4,3
    80006100:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006104:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006108:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000610c:	469d                	li	a3,7
    8000610e:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006112:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006116:	00002597          	auipc	a1,0x2
    8000611a:	6fa58593          	addi	a1,a1,1786 # 80008810 <digits+0x18>
    8000611e:	00020517          	auipc	a0,0x20
    80006122:	0ea50513          	addi	a0,a0,234 # 80026208 <uart_tx_lock>
    80006126:	00000097          	auipc	ra,0x0
    8000612a:	218080e7          	jalr	536(ra) # 8000633e <initlock>
}
    8000612e:	60a2                	ld	ra,8(sp)
    80006130:	6402                	ld	s0,0(sp)
    80006132:	0141                	addi	sp,sp,16
    80006134:	8082                	ret

0000000080006136 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006136:	1101                	addi	sp,sp,-32
    80006138:	ec06                	sd	ra,24(sp)
    8000613a:	e822                	sd	s0,16(sp)
    8000613c:	e426                	sd	s1,8(sp)
    8000613e:	1000                	addi	s0,sp,32
    80006140:	84aa                	mv	s1,a0
  push_off();
    80006142:	00000097          	auipc	ra,0x0
    80006146:	240080e7          	jalr	576(ra) # 80006382 <push_off>

  if(panicked){
    8000614a:	00003797          	auipc	a5,0x3
    8000614e:	ed27a783          	lw	a5,-302(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006152:	10000737          	lui	a4,0x10000
  if(panicked){
    80006156:	c391                	beqz	a5,8000615a <uartputc_sync+0x24>
    for(;;)
    80006158:	a001                	j	80006158 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000615a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000615e:	0ff7f793          	andi	a5,a5,255
    80006162:	0207f793          	andi	a5,a5,32
    80006166:	dbf5                	beqz	a5,8000615a <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006168:	0ff4f793          	andi	a5,s1,255
    8000616c:	10000737          	lui	a4,0x10000
    80006170:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006174:	00000097          	auipc	ra,0x0
    80006178:	2ae080e7          	jalr	686(ra) # 80006422 <pop_off>
}
    8000617c:	60e2                	ld	ra,24(sp)
    8000617e:	6442                	ld	s0,16(sp)
    80006180:	64a2                	ld	s1,8(sp)
    80006182:	6105                	addi	sp,sp,32
    80006184:	8082                	ret

0000000080006186 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006186:	00003717          	auipc	a4,0x3
    8000618a:	e9a73703          	ld	a4,-358(a4) # 80009020 <uart_tx_r>
    8000618e:	00003797          	auipc	a5,0x3
    80006192:	e9a7b783          	ld	a5,-358(a5) # 80009028 <uart_tx_w>
    80006196:	06e78c63          	beq	a5,a4,8000620e <uartstart+0x88>
{
    8000619a:	7139                	addi	sp,sp,-64
    8000619c:	fc06                	sd	ra,56(sp)
    8000619e:	f822                	sd	s0,48(sp)
    800061a0:	f426                	sd	s1,40(sp)
    800061a2:	f04a                	sd	s2,32(sp)
    800061a4:	ec4e                	sd	s3,24(sp)
    800061a6:	e852                	sd	s4,16(sp)
    800061a8:	e456                	sd	s5,8(sp)
    800061aa:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061ac:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061b0:	00020a17          	auipc	s4,0x20
    800061b4:	058a0a13          	addi	s4,s4,88 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    800061b8:	00003497          	auipc	s1,0x3
    800061bc:	e6848493          	addi	s1,s1,-408 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800061c0:	00003997          	auipc	s3,0x3
    800061c4:	e6898993          	addi	s3,s3,-408 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061c8:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800061cc:	0ff7f793          	andi	a5,a5,255
    800061d0:	0207f793          	andi	a5,a5,32
    800061d4:	c785                	beqz	a5,800061fc <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061d6:	01f77793          	andi	a5,a4,31
    800061da:	97d2                	add	a5,a5,s4
    800061dc:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800061e0:	0705                	addi	a4,a4,1
    800061e2:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800061e4:	8526                	mv	a0,s1
    800061e6:	ffffb097          	auipc	ra,0xffffb
    800061ea:	4b8080e7          	jalr	1208(ra) # 8000169e <wakeup>
    
    WriteReg(THR, c);
    800061ee:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800061f2:	6098                	ld	a4,0(s1)
    800061f4:	0009b783          	ld	a5,0(s3)
    800061f8:	fce798e3          	bne	a5,a4,800061c8 <uartstart+0x42>
  }
}
    800061fc:	70e2                	ld	ra,56(sp)
    800061fe:	7442                	ld	s0,48(sp)
    80006200:	74a2                	ld	s1,40(sp)
    80006202:	7902                	ld	s2,32(sp)
    80006204:	69e2                	ld	s3,24(sp)
    80006206:	6a42                	ld	s4,16(sp)
    80006208:	6aa2                	ld	s5,8(sp)
    8000620a:	6121                	addi	sp,sp,64
    8000620c:	8082                	ret
    8000620e:	8082                	ret

0000000080006210 <uartputc>:
{
    80006210:	7179                	addi	sp,sp,-48
    80006212:	f406                	sd	ra,40(sp)
    80006214:	f022                	sd	s0,32(sp)
    80006216:	ec26                	sd	s1,24(sp)
    80006218:	e84a                	sd	s2,16(sp)
    8000621a:	e44e                	sd	s3,8(sp)
    8000621c:	e052                	sd	s4,0(sp)
    8000621e:	1800                	addi	s0,sp,48
    80006220:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006222:	00020517          	auipc	a0,0x20
    80006226:	fe650513          	addi	a0,a0,-26 # 80026208 <uart_tx_lock>
    8000622a:	00000097          	auipc	ra,0x0
    8000622e:	1a4080e7          	jalr	420(ra) # 800063ce <acquire>
  if(panicked){
    80006232:	00003797          	auipc	a5,0x3
    80006236:	dea7a783          	lw	a5,-534(a5) # 8000901c <panicked>
    8000623a:	c391                	beqz	a5,8000623e <uartputc+0x2e>
    for(;;)
    8000623c:	a001                	j	8000623c <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000623e:	00003797          	auipc	a5,0x3
    80006242:	dea7b783          	ld	a5,-534(a5) # 80009028 <uart_tx_w>
    80006246:	00003717          	auipc	a4,0x3
    8000624a:	dda73703          	ld	a4,-550(a4) # 80009020 <uart_tx_r>
    8000624e:	02070713          	addi	a4,a4,32
    80006252:	02f71b63          	bne	a4,a5,80006288 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006256:	00020a17          	auipc	s4,0x20
    8000625a:	fb2a0a13          	addi	s4,s4,-78 # 80026208 <uart_tx_lock>
    8000625e:	00003497          	auipc	s1,0x3
    80006262:	dc248493          	addi	s1,s1,-574 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006266:	00003917          	auipc	s2,0x3
    8000626a:	dc290913          	addi	s2,s2,-574 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000626e:	85d2                	mv	a1,s4
    80006270:	8526                	mv	a0,s1
    80006272:	ffffb097          	auipc	ra,0xffffb
    80006276:	2a0080e7          	jalr	672(ra) # 80001512 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000627a:	00093783          	ld	a5,0(s2)
    8000627e:	6098                	ld	a4,0(s1)
    80006280:	02070713          	addi	a4,a4,32
    80006284:	fef705e3          	beq	a4,a5,8000626e <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006288:	00020497          	auipc	s1,0x20
    8000628c:	f8048493          	addi	s1,s1,-128 # 80026208 <uart_tx_lock>
    80006290:	01f7f713          	andi	a4,a5,31
    80006294:	9726                	add	a4,a4,s1
    80006296:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000629a:	0785                	addi	a5,a5,1
    8000629c:	00003717          	auipc	a4,0x3
    800062a0:	d8f73623          	sd	a5,-628(a4) # 80009028 <uart_tx_w>
      uartstart();
    800062a4:	00000097          	auipc	ra,0x0
    800062a8:	ee2080e7          	jalr	-286(ra) # 80006186 <uartstart>
      release(&uart_tx_lock);
    800062ac:	8526                	mv	a0,s1
    800062ae:	00000097          	auipc	ra,0x0
    800062b2:	1d4080e7          	jalr	468(ra) # 80006482 <release>
}
    800062b6:	70a2                	ld	ra,40(sp)
    800062b8:	7402                	ld	s0,32(sp)
    800062ba:	64e2                	ld	s1,24(sp)
    800062bc:	6942                	ld	s2,16(sp)
    800062be:	69a2                	ld	s3,8(sp)
    800062c0:	6a02                	ld	s4,0(sp)
    800062c2:	6145                	addi	sp,sp,48
    800062c4:	8082                	ret

00000000800062c6 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800062c6:	1141                	addi	sp,sp,-16
    800062c8:	e422                	sd	s0,8(sp)
    800062ca:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800062cc:	100007b7          	lui	a5,0x10000
    800062d0:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800062d4:	8b85                	andi	a5,a5,1
    800062d6:	cb91                	beqz	a5,800062ea <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800062d8:	100007b7          	lui	a5,0x10000
    800062dc:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800062e0:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800062e4:	6422                	ld	s0,8(sp)
    800062e6:	0141                	addi	sp,sp,16
    800062e8:	8082                	ret
    return -1;
    800062ea:	557d                	li	a0,-1
    800062ec:	bfe5                	j	800062e4 <uartgetc+0x1e>

00000000800062ee <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800062ee:	1101                	addi	sp,sp,-32
    800062f0:	ec06                	sd	ra,24(sp)
    800062f2:	e822                	sd	s0,16(sp)
    800062f4:	e426                	sd	s1,8(sp)
    800062f6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062f8:	54fd                	li	s1,-1
    int c = uartgetc();
    800062fa:	00000097          	auipc	ra,0x0
    800062fe:	fcc080e7          	jalr	-52(ra) # 800062c6 <uartgetc>
    if(c == -1)
    80006302:	00950763          	beq	a0,s1,80006310 <uartintr+0x22>
      break;
    consoleintr(c);
    80006306:	00000097          	auipc	ra,0x0
    8000630a:	8a2080e7          	jalr	-1886(ra) # 80005ba8 <consoleintr>
  while(1){
    8000630e:	b7f5                	j	800062fa <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006310:	00020497          	auipc	s1,0x20
    80006314:	ef848493          	addi	s1,s1,-264 # 80026208 <uart_tx_lock>
    80006318:	8526                	mv	a0,s1
    8000631a:	00000097          	auipc	ra,0x0
    8000631e:	0b4080e7          	jalr	180(ra) # 800063ce <acquire>
  uartstart();
    80006322:	00000097          	auipc	ra,0x0
    80006326:	e64080e7          	jalr	-412(ra) # 80006186 <uartstart>
  release(&uart_tx_lock);
    8000632a:	8526                	mv	a0,s1
    8000632c:	00000097          	auipc	ra,0x0
    80006330:	156080e7          	jalr	342(ra) # 80006482 <release>
}
    80006334:	60e2                	ld	ra,24(sp)
    80006336:	6442                	ld	s0,16(sp)
    80006338:	64a2                	ld	s1,8(sp)
    8000633a:	6105                	addi	sp,sp,32
    8000633c:	8082                	ret

000000008000633e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000633e:	1141                	addi	sp,sp,-16
    80006340:	e422                	sd	s0,8(sp)
    80006342:	0800                	addi	s0,sp,16
  lk->name = name;
    80006344:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006346:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000634a:	00053823          	sd	zero,16(a0)
}
    8000634e:	6422                	ld	s0,8(sp)
    80006350:	0141                	addi	sp,sp,16
    80006352:	8082                	ret

0000000080006354 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006354:	411c                	lw	a5,0(a0)
    80006356:	e399                	bnez	a5,8000635c <holding+0x8>
    80006358:	4501                	li	a0,0
  return r;
}
    8000635a:	8082                	ret
{
    8000635c:	1101                	addi	sp,sp,-32
    8000635e:	ec06                	sd	ra,24(sp)
    80006360:	e822                	sd	s0,16(sp)
    80006362:	e426                	sd	s1,8(sp)
    80006364:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006366:	6904                	ld	s1,16(a0)
    80006368:	ffffb097          	auipc	ra,0xffffb
    8000636c:	ac4080e7          	jalr	-1340(ra) # 80000e2c <mycpu>
    80006370:	40a48533          	sub	a0,s1,a0
    80006374:	00153513          	seqz	a0,a0
}
    80006378:	60e2                	ld	ra,24(sp)
    8000637a:	6442                	ld	s0,16(sp)
    8000637c:	64a2                	ld	s1,8(sp)
    8000637e:	6105                	addi	sp,sp,32
    80006380:	8082                	ret

0000000080006382 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006382:	1101                	addi	sp,sp,-32
    80006384:	ec06                	sd	ra,24(sp)
    80006386:	e822                	sd	s0,16(sp)
    80006388:	e426                	sd	s1,8(sp)
    8000638a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000638c:	100024f3          	csrr	s1,sstatus
    80006390:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006394:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006396:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000639a:	ffffb097          	auipc	ra,0xffffb
    8000639e:	a92080e7          	jalr	-1390(ra) # 80000e2c <mycpu>
    800063a2:	5d3c                	lw	a5,120(a0)
    800063a4:	cf89                	beqz	a5,800063be <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800063a6:	ffffb097          	auipc	ra,0xffffb
    800063aa:	a86080e7          	jalr	-1402(ra) # 80000e2c <mycpu>
    800063ae:	5d3c                	lw	a5,120(a0)
    800063b0:	2785                	addiw	a5,a5,1
    800063b2:	dd3c                	sw	a5,120(a0)
}
    800063b4:	60e2                	ld	ra,24(sp)
    800063b6:	6442                	ld	s0,16(sp)
    800063b8:	64a2                	ld	s1,8(sp)
    800063ba:	6105                	addi	sp,sp,32
    800063bc:	8082                	ret
    mycpu()->intena = old;
    800063be:	ffffb097          	auipc	ra,0xffffb
    800063c2:	a6e080e7          	jalr	-1426(ra) # 80000e2c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800063c6:	8085                	srli	s1,s1,0x1
    800063c8:	8885                	andi	s1,s1,1
    800063ca:	dd64                	sw	s1,124(a0)
    800063cc:	bfe9                	j	800063a6 <push_off+0x24>

00000000800063ce <acquire>:
{
    800063ce:	1101                	addi	sp,sp,-32
    800063d0:	ec06                	sd	ra,24(sp)
    800063d2:	e822                	sd	s0,16(sp)
    800063d4:	e426                	sd	s1,8(sp)
    800063d6:	1000                	addi	s0,sp,32
    800063d8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800063da:	00000097          	auipc	ra,0x0
    800063de:	fa8080e7          	jalr	-88(ra) # 80006382 <push_off>
  if(holding(lk))
    800063e2:	8526                	mv	a0,s1
    800063e4:	00000097          	auipc	ra,0x0
    800063e8:	f70080e7          	jalr	-144(ra) # 80006354 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063ec:	4705                	li	a4,1
  if(holding(lk))
    800063ee:	e115                	bnez	a0,80006412 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063f0:	87ba                	mv	a5,a4
    800063f2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063f6:	2781                	sext.w	a5,a5
    800063f8:	ffe5                	bnez	a5,800063f0 <acquire+0x22>
  __sync_synchronize();
    800063fa:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063fe:	ffffb097          	auipc	ra,0xffffb
    80006402:	a2e080e7          	jalr	-1490(ra) # 80000e2c <mycpu>
    80006406:	e888                	sd	a0,16(s1)
}
    80006408:	60e2                	ld	ra,24(sp)
    8000640a:	6442                	ld	s0,16(sp)
    8000640c:	64a2                	ld	s1,8(sp)
    8000640e:	6105                	addi	sp,sp,32
    80006410:	8082                	ret
    panic("acquire");
    80006412:	00002517          	auipc	a0,0x2
    80006416:	40650513          	addi	a0,a0,1030 # 80008818 <digits+0x20>
    8000641a:	00000097          	auipc	ra,0x0
    8000641e:	a0e080e7          	jalr	-1522(ra) # 80005e28 <panic>

0000000080006422 <pop_off>:

void
pop_off(void)
{
    80006422:	1141                	addi	sp,sp,-16
    80006424:	e406                	sd	ra,8(sp)
    80006426:	e022                	sd	s0,0(sp)
    80006428:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000642a:	ffffb097          	auipc	ra,0xffffb
    8000642e:	a02080e7          	jalr	-1534(ra) # 80000e2c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006432:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006436:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006438:	e78d                	bnez	a5,80006462 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000643a:	5d3c                	lw	a5,120(a0)
    8000643c:	02f05b63          	blez	a5,80006472 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006440:	37fd                	addiw	a5,a5,-1
    80006442:	0007871b          	sext.w	a4,a5
    80006446:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006448:	eb09                	bnez	a4,8000645a <pop_off+0x38>
    8000644a:	5d7c                	lw	a5,124(a0)
    8000644c:	c799                	beqz	a5,8000645a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000644e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006452:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006456:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000645a:	60a2                	ld	ra,8(sp)
    8000645c:	6402                	ld	s0,0(sp)
    8000645e:	0141                	addi	sp,sp,16
    80006460:	8082                	ret
    panic("pop_off - interruptible");
    80006462:	00002517          	auipc	a0,0x2
    80006466:	3be50513          	addi	a0,a0,958 # 80008820 <digits+0x28>
    8000646a:	00000097          	auipc	ra,0x0
    8000646e:	9be080e7          	jalr	-1602(ra) # 80005e28 <panic>
    panic("pop_off");
    80006472:	00002517          	auipc	a0,0x2
    80006476:	3c650513          	addi	a0,a0,966 # 80008838 <digits+0x40>
    8000647a:	00000097          	auipc	ra,0x0
    8000647e:	9ae080e7          	jalr	-1618(ra) # 80005e28 <panic>

0000000080006482 <release>:
{
    80006482:	1101                	addi	sp,sp,-32
    80006484:	ec06                	sd	ra,24(sp)
    80006486:	e822                	sd	s0,16(sp)
    80006488:	e426                	sd	s1,8(sp)
    8000648a:	1000                	addi	s0,sp,32
    8000648c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000648e:	00000097          	auipc	ra,0x0
    80006492:	ec6080e7          	jalr	-314(ra) # 80006354 <holding>
    80006496:	c115                	beqz	a0,800064ba <release+0x38>
  lk->cpu = 0;
    80006498:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000649c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800064a0:	0f50000f          	fence	iorw,ow
    800064a4:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800064a8:	00000097          	auipc	ra,0x0
    800064ac:	f7a080e7          	jalr	-134(ra) # 80006422 <pop_off>
}
    800064b0:	60e2                	ld	ra,24(sp)
    800064b2:	6442                	ld	s0,16(sp)
    800064b4:	64a2                	ld	s1,8(sp)
    800064b6:	6105                	addi	sp,sp,32
    800064b8:	8082                	ret
    panic("release");
    800064ba:	00002517          	auipc	a0,0x2
    800064be:	38650513          	addi	a0,a0,902 # 80008840 <digits+0x48>
    800064c2:	00000097          	auipc	ra,0x0
    800064c6:	966080e7          	jalr	-1690(ra) # 80005e28 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
