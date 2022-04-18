
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001f117          	auipc	sp,0x1f
    80000004:	49010113          	addi	sp,sp,1168 # 8001f490 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	72e060ef          	jal	ra,80006744 <start>

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
    80000030:	00027797          	auipc	a5,0x27
    80000034:	56078793          	addi	a5,a5,1376 # 80027590 <end>
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
    80000050:	0000a917          	auipc	s2,0xa
    80000054:	00090913          	mv	s2,s2
    80000058:	854a                	mv	a0,s2
    8000005a:	00007097          	auipc	ra,0x7
    8000005e:	0e4080e7          	jalr	228(ra) # 8000713e <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2) # 8000a068 <kmem+0x18>
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00007097          	auipc	ra,0x7
    80000072:	184080e7          	jalr	388(ra) # 800071f2 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00009517          	auipc	a0,0x9
    80000086:	f8e50513          	addi	a0,a0,-114 # 80009010 <etext+0x10>
    8000008a:	00007097          	auipc	ra,0x7
    8000008e:	b6a080e7          	jalr	-1174(ra) # 80006bf4 <panic>

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
    800000e4:	00009597          	auipc	a1,0x9
    800000e8:	f3458593          	addi	a1,a1,-204 # 80009018 <etext+0x18>
    800000ec:	0000a517          	auipc	a0,0xa
    800000f0:	f6450513          	addi	a0,a0,-156 # 8000a050 <kmem>
    800000f4:	00007097          	auipc	ra,0x7
    800000f8:	fba080e7          	jalr	-70(ra) # 800070ae <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00027517          	auipc	a0,0x27
    80000104:	49050513          	addi	a0,a0,1168 # 80027590 <end>
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
    80000122:	0000a497          	auipc	s1,0xa
    80000126:	f2e48493          	addi	s1,s1,-210 # 8000a050 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00007097          	auipc	ra,0x7
    80000130:	012080e7          	jalr	18(ra) # 8000713e <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	0000a517          	auipc	a0,0xa
    8000013e:	f1650513          	addi	a0,a0,-234 # 8000a050 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00007097          	auipc	ra,0x7
    80000148:	0ae080e7          	jalr	174(ra) # 800071f2 <release>

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
    80000166:	0000a517          	auipc	a0,0xa
    8000016a:	eea50513          	addi	a0,a0,-278 # 8000a050 <kmem>
    8000016e:	00007097          	auipc	ra,0x7
    80000172:	084080e7          	jalr	132(ra) # 800071f2 <release>
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
    80000326:	1101                	addi	sp,sp,-32
    80000328:	ec06                	sd	ra,24(sp)
    8000032a:	e822                	sd	s0,16(sp)
    8000032c:	e426                	sd	s1,8(sp)
    8000032e:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80000330:	00001097          	auipc	ra,0x1
    80000334:	b44080e7          	jalr	-1212(ra) # 80000e74 <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    80000338:	0000a497          	auipc	s1,0xa
    8000033c:	cc848493          	addi	s1,s1,-824 # 8000a000 <started>
  if(cpuid() == 0){
    80000340:	c531                	beqz	a0,8000038c <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    80000342:	8526                	mv	a0,s1
    80000344:	00007097          	auipc	ra,0x7
    80000348:	f0c080e7          	jalr	-244(ra) # 80007250 <lockfree_read4>
    8000034c:	d97d                	beqz	a0,80000342 <main+0x1c>
      ;
    __sync_synchronize();
    8000034e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000352:	00001097          	auipc	ra,0x1
    80000356:	b22080e7          	jalr	-1246(ra) # 80000e74 <cpuid>
    8000035a:	85aa                	mv	a1,a0
    8000035c:	00009517          	auipc	a0,0x9
    80000360:	cdc50513          	addi	a0,a0,-804 # 80009038 <etext+0x38>
    80000364:	00007097          	auipc	ra,0x7
    80000368:	8da080e7          	jalr	-1830(ra) # 80006c3e <printf>
    kvminithart();    // turn on paging
    8000036c:	00000097          	auipc	ra,0x0
    80000370:	0e8080e7          	jalr	232(ra) # 80000454 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000374:	00001097          	auipc	ra,0x1
    80000378:	778080e7          	jalr	1912(ra) # 80001aec <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000037c:	00005097          	auipc	ra,0x5
    80000380:	dd8080e7          	jalr	-552(ra) # 80005154 <plicinithart>
  }

  scheduler();        
    80000384:	00001097          	auipc	ra,0x1
    80000388:	026080e7          	jalr	38(ra) # 800013aa <scheduler>
    consoleinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	77a080e7          	jalr	1914(ra) # 80006b06 <consoleinit>
    printfinit();
    80000394:	00007097          	auipc	ra,0x7
    80000398:	a90080e7          	jalr	-1392(ra) # 80006e24 <printfinit>
    printf("\n");
    8000039c:	00009517          	auipc	a0,0x9
    800003a0:	cac50513          	addi	a0,a0,-852 # 80009048 <etext+0x48>
    800003a4:	00007097          	auipc	ra,0x7
    800003a8:	89a080e7          	jalr	-1894(ra) # 80006c3e <printf>
    printf("xv6 kernel is booting\n");
    800003ac:	00009517          	auipc	a0,0x9
    800003b0:	c7450513          	addi	a0,a0,-908 # 80009020 <etext+0x20>
    800003b4:	00007097          	auipc	ra,0x7
    800003b8:	88a080e7          	jalr	-1910(ra) # 80006c3e <printf>
    printf("\n");
    800003bc:	00009517          	auipc	a0,0x9
    800003c0:	c8c50513          	addi	a0,a0,-884 # 80009048 <etext+0x48>
    800003c4:	00007097          	auipc	ra,0x7
    800003c8:	87a080e7          	jalr	-1926(ra) # 80006c3e <printf>
    kinit();         // physical page allocator
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	d10080e7          	jalr	-752(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	362080e7          	jalr	866(ra) # 80000736 <kvminit>
    kvminithart();   // turn on paging
    800003dc:	00000097          	auipc	ra,0x0
    800003e0:	078080e7          	jalr	120(ra) # 80000454 <kvminithart>
    procinit();      // process table
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	9e2080e7          	jalr	-1566(ra) # 80000dc6 <procinit>
    trapinit();      // trap vectors
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	6d8080e7          	jalr	1752(ra) # 80001ac4 <trapinit>
    trapinithart();  // install kernel trap vector
    800003f4:	00001097          	auipc	ra,0x1
    800003f8:	6f8080e7          	jalr	1784(ra) # 80001aec <trapinithart>
    plicinit();      // set up interrupt controller
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	d2e080e7          	jalr	-722(ra) # 8000512a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000404:	00005097          	auipc	ra,0x5
    80000408:	d50080e7          	jalr	-688(ra) # 80005154 <plicinithart>
    binit();         // buffer cache
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	e52080e7          	jalr	-430(ra) # 8000225e <binit>
    iinit();         // inode table
    80000414:	00002097          	auipc	ra,0x2
    80000418:	4e2080e7          	jalr	1250(ra) # 800028f6 <iinit>
    fileinit();      // file table
    8000041c:	00003097          	auipc	ra,0x3
    80000420:	48c080e7          	jalr	1164(ra) # 800038a8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000424:	00005097          	auipc	ra,0x5
    80000428:	e58080e7          	jalr	-424(ra) # 8000527c <virtio_disk_init>
    pci_init();
    8000042c:	00006097          	auipc	ra,0x6
    80000430:	218080e7          	jalr	536(ra) # 80006644 <pci_init>
    sockinit();
    80000434:	00006097          	auipc	ra,0x6
    80000438:	e06080e7          	jalr	-506(ra) # 8000623a <sockinit>
    userinit();      // first user process
    8000043c:	00001097          	auipc	ra,0x1
    80000440:	d3c080e7          	jalr	-708(ra) # 80001178 <userinit>
    __sync_synchronize();
    80000444:	0ff0000f          	fence
    started = 1;
    80000448:	4785                	li	a5,1
    8000044a:	0000a717          	auipc	a4,0xa
    8000044e:	baf72b23          	sw	a5,-1098(a4) # 8000a000 <started>
    80000452:	bf0d                	j	80000384 <main+0x5e>

0000000080000454 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000454:	1141                	addi	sp,sp,-16
    80000456:	e422                	sd	s0,8(sp)
    80000458:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000045a:	0000a797          	auipc	a5,0xa
    8000045e:	bae7b783          	ld	a5,-1106(a5) # 8000a008 <kernel_pagetable>
    80000462:	83b1                	srli	a5,a5,0xc
    80000464:	577d                	li	a4,-1
    80000466:	177e                	slli	a4,a4,0x3f
    80000468:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000046a:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000046e:	12000073          	sfence.vma
  sfence_vma();
}
    80000472:	6422                	ld	s0,8(sp)
    80000474:	0141                	addi	sp,sp,16
    80000476:	8082                	ret

0000000080000478 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000478:	7139                	addi	sp,sp,-64
    8000047a:	fc06                	sd	ra,56(sp)
    8000047c:	f822                	sd	s0,48(sp)
    8000047e:	f426                	sd	s1,40(sp)
    80000480:	f04a                	sd	s2,32(sp)
    80000482:	ec4e                	sd	s3,24(sp)
    80000484:	e852                	sd	s4,16(sp)
    80000486:	e456                	sd	s5,8(sp)
    80000488:	e05a                	sd	s6,0(sp)
    8000048a:	0080                	addi	s0,sp,64
    8000048c:	84aa                	mv	s1,a0
    8000048e:	89ae                	mv	s3,a1
    80000490:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000492:	57fd                	li	a5,-1
    80000494:	83e9                	srli	a5,a5,0x1a
    80000496:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000498:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000049a:	04b7f263          	bgeu	a5,a1,800004de <walk+0x66>
    panic("walk");
    8000049e:	00009517          	auipc	a0,0x9
    800004a2:	bb250513          	addi	a0,a0,-1102 # 80009050 <etext+0x50>
    800004a6:	00006097          	auipc	ra,0x6
    800004aa:	74e080e7          	jalr	1870(ra) # 80006bf4 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004ae:	060a8663          	beqz	s5,8000051a <walk+0xa2>
    800004b2:	00000097          	auipc	ra,0x0
    800004b6:	c66080e7          	jalr	-922(ra) # 80000118 <kalloc>
    800004ba:	84aa                	mv	s1,a0
    800004bc:	c529                	beqz	a0,80000506 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004be:	6605                	lui	a2,0x1
    800004c0:	4581                	li	a1,0
    800004c2:	00000097          	auipc	ra,0x0
    800004c6:	cb6080e7          	jalr	-842(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ca:	00c4d793          	srli	a5,s1,0xc
    800004ce:	07aa                	slli	a5,a5,0xa
    800004d0:	0017e793          	ori	a5,a5,1
    800004d4:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004d8:	3a5d                	addiw	s4,s4,-9
    800004da:	036a0063          	beq	s4,s6,800004fa <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004de:	0149d933          	srl	s2,s3,s4
    800004e2:	1ff97913          	andi	s2,s2,511
    800004e6:	090e                	slli	s2,s2,0x3
    800004e8:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ea:	00093483          	ld	s1,0(s2)
    800004ee:	0014f793          	andi	a5,s1,1
    800004f2:	dfd5                	beqz	a5,800004ae <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004f4:	80a9                	srli	s1,s1,0xa
    800004f6:	04b2                	slli	s1,s1,0xc
    800004f8:	b7c5                	j	800004d8 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004fa:	00c9d513          	srli	a0,s3,0xc
    800004fe:	1ff57513          	andi	a0,a0,511
    80000502:	050e                	slli	a0,a0,0x3
    80000504:	9526                	add	a0,a0,s1
}
    80000506:	70e2                	ld	ra,56(sp)
    80000508:	7442                	ld	s0,48(sp)
    8000050a:	74a2                	ld	s1,40(sp)
    8000050c:	7902                	ld	s2,32(sp)
    8000050e:	69e2                	ld	s3,24(sp)
    80000510:	6a42                	ld	s4,16(sp)
    80000512:	6aa2                	ld	s5,8(sp)
    80000514:	6b02                	ld	s6,0(sp)
    80000516:	6121                	addi	sp,sp,64
    80000518:	8082                	ret
        return 0;
    8000051a:	4501                	li	a0,0
    8000051c:	b7ed                	j	80000506 <walk+0x8e>

000000008000051e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000051e:	57fd                	li	a5,-1
    80000520:	83e9                	srli	a5,a5,0x1a
    80000522:	00b7f463          	bgeu	a5,a1,8000052a <walkaddr+0xc>
    return 0;
    80000526:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000528:	8082                	ret
{
    8000052a:	1141                	addi	sp,sp,-16
    8000052c:	e406                	sd	ra,8(sp)
    8000052e:	e022                	sd	s0,0(sp)
    80000530:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000532:	4601                	li	a2,0
    80000534:	00000097          	auipc	ra,0x0
    80000538:	f44080e7          	jalr	-188(ra) # 80000478 <walk>
  if(pte == 0)
    8000053c:	c105                	beqz	a0,8000055c <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000053e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000540:	0117f693          	andi	a3,a5,17
    80000544:	4745                	li	a4,17
    return 0;
    80000546:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000548:	00e68663          	beq	a3,a4,80000554 <walkaddr+0x36>
}
    8000054c:	60a2                	ld	ra,8(sp)
    8000054e:	6402                	ld	s0,0(sp)
    80000550:	0141                	addi	sp,sp,16
    80000552:	8082                	ret
  pa = PTE2PA(*pte);
    80000554:	00a7d513          	srli	a0,a5,0xa
    80000558:	0532                	slli	a0,a0,0xc
  return pa;
    8000055a:	bfcd                	j	8000054c <walkaddr+0x2e>
    return 0;
    8000055c:	4501                	li	a0,0
    8000055e:	b7fd                	j	8000054c <walkaddr+0x2e>

0000000080000560 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000560:	715d                	addi	sp,sp,-80
    80000562:	e486                	sd	ra,72(sp)
    80000564:	e0a2                	sd	s0,64(sp)
    80000566:	fc26                	sd	s1,56(sp)
    80000568:	f84a                	sd	s2,48(sp)
    8000056a:	f44e                	sd	s3,40(sp)
    8000056c:	f052                	sd	s4,32(sp)
    8000056e:	ec56                	sd	s5,24(sp)
    80000570:	e85a                	sd	s6,16(sp)
    80000572:	e45e                	sd	s7,8(sp)
    80000574:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000576:	c205                	beqz	a2,80000596 <mappages+0x36>
    80000578:	8aaa                	mv	s5,a0
    8000057a:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000057c:	77fd                	lui	a5,0xfffff
    8000057e:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000582:	15fd                	addi	a1,a1,-1
    80000584:	00c589b3          	add	s3,a1,a2
    80000588:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000058c:	8952                	mv	s2,s4
    8000058e:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000592:	6b85                	lui	s7,0x1
    80000594:	a015                	j	800005b8 <mappages+0x58>
    panic("mappages: size");
    80000596:	00009517          	auipc	a0,0x9
    8000059a:	ac250513          	addi	a0,a0,-1342 # 80009058 <etext+0x58>
    8000059e:	00006097          	auipc	ra,0x6
    800005a2:	656080e7          	jalr	1622(ra) # 80006bf4 <panic>
      panic("mappages: remap");
    800005a6:	00009517          	auipc	a0,0x9
    800005aa:	ac250513          	addi	a0,a0,-1342 # 80009068 <etext+0x68>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	646080e7          	jalr	1606(ra) # 80006bf4 <panic>
    a += PGSIZE;
    800005b6:	995e                	add	s2,s2,s7
  for(;;){
    800005b8:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005bc:	4605                	li	a2,1
    800005be:	85ca                	mv	a1,s2
    800005c0:	8556                	mv	a0,s5
    800005c2:	00000097          	auipc	ra,0x0
    800005c6:	eb6080e7          	jalr	-330(ra) # 80000478 <walk>
    800005ca:	cd19                	beqz	a0,800005e8 <mappages+0x88>
    if(*pte & PTE_V)
    800005cc:	611c                	ld	a5,0(a0)
    800005ce:	8b85                	andi	a5,a5,1
    800005d0:	fbf9                	bnez	a5,800005a6 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005d2:	80b1                	srli	s1,s1,0xc
    800005d4:	04aa                	slli	s1,s1,0xa
    800005d6:	0164e4b3          	or	s1,s1,s6
    800005da:	0014e493          	ori	s1,s1,1
    800005de:	e104                	sd	s1,0(a0)
    if(a == last)
    800005e0:	fd391be3          	bne	s2,s3,800005b6 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005e4:	4501                	li	a0,0
    800005e6:	a011                	j	800005ea <mappages+0x8a>
      return -1;
    800005e8:	557d                	li	a0,-1
}
    800005ea:	60a6                	ld	ra,72(sp)
    800005ec:	6406                	ld	s0,64(sp)
    800005ee:	74e2                	ld	s1,56(sp)
    800005f0:	7942                	ld	s2,48(sp)
    800005f2:	79a2                	ld	s3,40(sp)
    800005f4:	7a02                	ld	s4,32(sp)
    800005f6:	6ae2                	ld	s5,24(sp)
    800005f8:	6b42                	ld	s6,16(sp)
    800005fa:	6ba2                	ld	s7,8(sp)
    800005fc:	6161                	addi	sp,sp,80
    800005fe:	8082                	ret

0000000080000600 <kvmmap>:
{
    80000600:	1141                	addi	sp,sp,-16
    80000602:	e406                	sd	ra,8(sp)
    80000604:	e022                	sd	s0,0(sp)
    80000606:	0800                	addi	s0,sp,16
    80000608:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000060a:	86b2                	mv	a3,a2
    8000060c:	863e                	mv	a2,a5
    8000060e:	00000097          	auipc	ra,0x0
    80000612:	f52080e7          	jalr	-174(ra) # 80000560 <mappages>
    80000616:	e509                	bnez	a0,80000620 <kvmmap+0x20>
}
    80000618:	60a2                	ld	ra,8(sp)
    8000061a:	6402                	ld	s0,0(sp)
    8000061c:	0141                	addi	sp,sp,16
    8000061e:	8082                	ret
    panic("kvmmap");
    80000620:	00009517          	auipc	a0,0x9
    80000624:	a5850513          	addi	a0,a0,-1448 # 80009078 <etext+0x78>
    80000628:	00006097          	auipc	ra,0x6
    8000062c:	5cc080e7          	jalr	1484(ra) # 80006bf4 <panic>

0000000080000630 <kvmmake>:
{
    80000630:	1101                	addi	sp,sp,-32
    80000632:	ec06                	sd	ra,24(sp)
    80000634:	e822                	sd	s0,16(sp)
    80000636:	e426                	sd	s1,8(sp)
    80000638:	e04a                	sd	s2,0(sp)
    8000063a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000063c:	00000097          	auipc	ra,0x0
    80000640:	adc080e7          	jalr	-1316(ra) # 80000118 <kalloc>
    80000644:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000646:	6605                	lui	a2,0x1
    80000648:	4581                	li	a1,0
    8000064a:	00000097          	auipc	ra,0x0
    8000064e:	b2e080e7          	jalr	-1234(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000652:	4719                	li	a4,6
    80000654:	6685                	lui	a3,0x1
    80000656:	10000637          	lui	a2,0x10000
    8000065a:	100005b7          	lui	a1,0x10000
    8000065e:	8526                	mv	a0,s1
    80000660:	00000097          	auipc	ra,0x0
    80000664:	fa0080e7          	jalr	-96(ra) # 80000600 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000668:	4719                	li	a4,6
    8000066a:	6685                	lui	a3,0x1
    8000066c:	10001637          	lui	a2,0x10001
    80000670:	100015b7          	lui	a1,0x10001
    80000674:	8526                	mv	a0,s1
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	f8a080e7          	jalr	-118(ra) # 80000600 <kvmmap>
  kvmmap(kpgtbl, 0x30000000L, 0x30000000L, 0x10000000, PTE_R | PTE_W);
    8000067e:	4719                	li	a4,6
    80000680:	100006b7          	lui	a3,0x10000
    80000684:	30000637          	lui	a2,0x30000
    80000688:	300005b7          	lui	a1,0x30000
    8000068c:	8526                	mv	a0,s1
    8000068e:	00000097          	auipc	ra,0x0
    80000692:	f72080e7          	jalr	-142(ra) # 80000600 <kvmmap>
  kvmmap(kpgtbl, 0x40000000L, 0x40000000L, 0x20000, PTE_R | PTE_W);
    80000696:	4719                	li	a4,6
    80000698:	000206b7          	lui	a3,0x20
    8000069c:	40000637          	lui	a2,0x40000
    800006a0:	400005b7          	lui	a1,0x40000
    800006a4:	8526                	mv	a0,s1
    800006a6:	00000097          	auipc	ra,0x0
    800006aa:	f5a080e7          	jalr	-166(ra) # 80000600 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006ae:	4719                	li	a4,6
    800006b0:	004006b7          	lui	a3,0x400
    800006b4:	0c000637          	lui	a2,0xc000
    800006b8:	0c0005b7          	lui	a1,0xc000
    800006bc:	8526                	mv	a0,s1
    800006be:	00000097          	auipc	ra,0x0
    800006c2:	f42080e7          	jalr	-190(ra) # 80000600 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c6:	00009917          	auipc	s2,0x9
    800006ca:	93a90913          	addi	s2,s2,-1734 # 80009000 <etext>
    800006ce:	4729                	li	a4,10
    800006d0:	80009697          	auipc	a3,0x80009
    800006d4:	93068693          	addi	a3,a3,-1744 # 9000 <_entry-0x7fff7000>
    800006d8:	4605                	li	a2,1
    800006da:	067e                	slli	a2,a2,0x1f
    800006dc:	85b2                	mv	a1,a2
    800006de:	8526                	mv	a0,s1
    800006e0:	00000097          	auipc	ra,0x0
    800006e4:	f20080e7          	jalr	-224(ra) # 80000600 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006e8:	4719                	li	a4,6
    800006ea:	46c5                	li	a3,17
    800006ec:	06ee                	slli	a3,a3,0x1b
    800006ee:	412686b3          	sub	a3,a3,s2
    800006f2:	864a                	mv	a2,s2
    800006f4:	85ca                	mv	a1,s2
    800006f6:	8526                	mv	a0,s1
    800006f8:	00000097          	auipc	ra,0x0
    800006fc:	f08080e7          	jalr	-248(ra) # 80000600 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000700:	4729                	li	a4,10
    80000702:	6685                	lui	a3,0x1
    80000704:	00008617          	auipc	a2,0x8
    80000708:	8fc60613          	addi	a2,a2,-1796 # 80008000 <_trampoline>
    8000070c:	040005b7          	lui	a1,0x4000
    80000710:	15fd                	addi	a1,a1,-1
    80000712:	05b2                	slli	a1,a1,0xc
    80000714:	8526                	mv	a0,s1
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	eea080e7          	jalr	-278(ra) # 80000600 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000071e:	8526                	mv	a0,s1
    80000720:	00000097          	auipc	ra,0x0
    80000724:	612080e7          	jalr	1554(ra) # 80000d32 <proc_mapstacks>
}
    80000728:	8526                	mv	a0,s1
    8000072a:	60e2                	ld	ra,24(sp)
    8000072c:	6442                	ld	s0,16(sp)
    8000072e:	64a2                	ld	s1,8(sp)
    80000730:	6902                	ld	s2,0(sp)
    80000732:	6105                	addi	sp,sp,32
    80000734:	8082                	ret

0000000080000736 <kvminit>:
{
    80000736:	1141                	addi	sp,sp,-16
    80000738:	e406                	sd	ra,8(sp)
    8000073a:	e022                	sd	s0,0(sp)
    8000073c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000073e:	00000097          	auipc	ra,0x0
    80000742:	ef2080e7          	jalr	-270(ra) # 80000630 <kvmmake>
    80000746:	0000a797          	auipc	a5,0xa
    8000074a:	8ca7b123          	sd	a0,-1854(a5) # 8000a008 <kernel_pagetable>
}
    8000074e:	60a2                	ld	ra,8(sp)
    80000750:	6402                	ld	s0,0(sp)
    80000752:	0141                	addi	sp,sp,16
    80000754:	8082                	ret

0000000080000756 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000756:	715d                	addi	sp,sp,-80
    80000758:	e486                	sd	ra,72(sp)
    8000075a:	e0a2                	sd	s0,64(sp)
    8000075c:	fc26                	sd	s1,56(sp)
    8000075e:	f84a                	sd	s2,48(sp)
    80000760:	f44e                	sd	s3,40(sp)
    80000762:	f052                	sd	s4,32(sp)
    80000764:	ec56                	sd	s5,24(sp)
    80000766:	e85a                	sd	s6,16(sp)
    80000768:	e45e                	sd	s7,8(sp)
    8000076a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000076c:	03459793          	slli	a5,a1,0x34
    80000770:	e795                	bnez	a5,8000079c <uvmunmap+0x46>
    80000772:	8a2a                	mv	s4,a0
    80000774:	892e                	mv	s2,a1
    80000776:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000778:	0632                	slli	a2,a2,0xc
    8000077a:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%p pte=%p\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    8000077e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000780:	6b05                	lui	s6,0x1
    80000782:	0935e263          	bltu	a1,s3,80000806 <uvmunmap+0xb0>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000786:	60a6                	ld	ra,72(sp)
    80000788:	6406                	ld	s0,64(sp)
    8000078a:	74e2                	ld	s1,56(sp)
    8000078c:	7942                	ld	s2,48(sp)
    8000078e:	79a2                	ld	s3,40(sp)
    80000790:	7a02                	ld	s4,32(sp)
    80000792:	6ae2                	ld	s5,24(sp)
    80000794:	6b42                	ld	s6,16(sp)
    80000796:	6ba2                	ld	s7,8(sp)
    80000798:	6161                	addi	sp,sp,80
    8000079a:	8082                	ret
    panic("uvmunmap: not aligned");
    8000079c:	00009517          	auipc	a0,0x9
    800007a0:	8e450513          	addi	a0,a0,-1820 # 80009080 <etext+0x80>
    800007a4:	00006097          	auipc	ra,0x6
    800007a8:	450080e7          	jalr	1104(ra) # 80006bf4 <panic>
      panic("uvmunmap: walk");
    800007ac:	00009517          	auipc	a0,0x9
    800007b0:	8ec50513          	addi	a0,a0,-1812 # 80009098 <etext+0x98>
    800007b4:	00006097          	auipc	ra,0x6
    800007b8:	440080e7          	jalr	1088(ra) # 80006bf4 <panic>
      printf("va=%p pte=%p\n", a, *pte);
    800007bc:	862a                	mv	a2,a0
    800007be:	85ca                	mv	a1,s2
    800007c0:	00009517          	auipc	a0,0x9
    800007c4:	8e850513          	addi	a0,a0,-1816 # 800090a8 <etext+0xa8>
    800007c8:	00006097          	auipc	ra,0x6
    800007cc:	476080e7          	jalr	1142(ra) # 80006c3e <printf>
      panic("uvmunmap: not mapped");
    800007d0:	00009517          	auipc	a0,0x9
    800007d4:	8e850513          	addi	a0,a0,-1816 # 800090b8 <etext+0xb8>
    800007d8:	00006097          	auipc	ra,0x6
    800007dc:	41c080e7          	jalr	1052(ra) # 80006bf4 <panic>
      panic("uvmunmap: not a leaf");
    800007e0:	00009517          	auipc	a0,0x9
    800007e4:	8f050513          	addi	a0,a0,-1808 # 800090d0 <etext+0xd0>
    800007e8:	00006097          	auipc	ra,0x6
    800007ec:	40c080e7          	jalr	1036(ra) # 80006bf4 <panic>
      uint64 pa = PTE2PA(*pte);
    800007f0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007f2:	0532                	slli	a0,a0,0xc
    800007f4:	00000097          	auipc	ra,0x0
    800007f8:	828080e7          	jalr	-2008(ra) # 8000001c <kfree>
    *pte = 0;
    800007fc:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000800:	995a                	add	s2,s2,s6
    80000802:	f93972e3          	bgeu	s2,s3,80000786 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000806:	4601                	li	a2,0
    80000808:	85ca                	mv	a1,s2
    8000080a:	8552                	mv	a0,s4
    8000080c:	00000097          	auipc	ra,0x0
    80000810:	c6c080e7          	jalr	-916(ra) # 80000478 <walk>
    80000814:	84aa                	mv	s1,a0
    80000816:	d959                	beqz	a0,800007ac <uvmunmap+0x56>
    if((*pte & PTE_V) == 0) {
    80000818:	6108                	ld	a0,0(a0)
    8000081a:	00157793          	andi	a5,a0,1
    8000081e:	dfd9                	beqz	a5,800007bc <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000820:	3ff57793          	andi	a5,a0,1023
    80000824:	fb778ee3          	beq	a5,s7,800007e0 <uvmunmap+0x8a>
    if(do_free){
    80000828:	fc0a8ae3          	beqz	s5,800007fc <uvmunmap+0xa6>
    8000082c:	b7d1                	j	800007f0 <uvmunmap+0x9a>

000000008000082e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000082e:	1101                	addi	sp,sp,-32
    80000830:	ec06                	sd	ra,24(sp)
    80000832:	e822                	sd	s0,16(sp)
    80000834:	e426                	sd	s1,8(sp)
    80000836:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	8e0080e7          	jalr	-1824(ra) # 80000118 <kalloc>
    80000840:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000842:	c519                	beqz	a0,80000850 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000844:	6605                	lui	a2,0x1
    80000846:	4581                	li	a1,0
    80000848:	00000097          	auipc	ra,0x0
    8000084c:	930080e7          	jalr	-1744(ra) # 80000178 <memset>
  return pagetable;
}
    80000850:	8526                	mv	a0,s1
    80000852:	60e2                	ld	ra,24(sp)
    80000854:	6442                	ld	s0,16(sp)
    80000856:	64a2                	ld	s1,8(sp)
    80000858:	6105                	addi	sp,sp,32
    8000085a:	8082                	ret

000000008000085c <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000085c:	7179                	addi	sp,sp,-48
    8000085e:	f406                	sd	ra,40(sp)
    80000860:	f022                	sd	s0,32(sp)
    80000862:	ec26                	sd	s1,24(sp)
    80000864:	e84a                	sd	s2,16(sp)
    80000866:	e44e                	sd	s3,8(sp)
    80000868:	e052                	sd	s4,0(sp)
    8000086a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000086c:	6785                	lui	a5,0x1
    8000086e:	04f67863          	bgeu	a2,a5,800008be <uvminit+0x62>
    80000872:	8a2a                	mv	s4,a0
    80000874:	89ae                	mv	s3,a1
    80000876:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000878:	00000097          	auipc	ra,0x0
    8000087c:	8a0080e7          	jalr	-1888(ra) # 80000118 <kalloc>
    80000880:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000882:	6605                	lui	a2,0x1
    80000884:	4581                	li	a1,0
    80000886:	00000097          	auipc	ra,0x0
    8000088a:	8f2080e7          	jalr	-1806(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000088e:	4779                	li	a4,30
    80000890:	86ca                	mv	a3,s2
    80000892:	6605                	lui	a2,0x1
    80000894:	4581                	li	a1,0
    80000896:	8552                	mv	a0,s4
    80000898:	00000097          	auipc	ra,0x0
    8000089c:	cc8080e7          	jalr	-824(ra) # 80000560 <mappages>
  memmove(mem, src, sz);
    800008a0:	8626                	mv	a2,s1
    800008a2:	85ce                	mv	a1,s3
    800008a4:	854a                	mv	a0,s2
    800008a6:	00000097          	auipc	ra,0x0
    800008aa:	932080e7          	jalr	-1742(ra) # 800001d8 <memmove>
}
    800008ae:	70a2                	ld	ra,40(sp)
    800008b0:	7402                	ld	s0,32(sp)
    800008b2:	64e2                	ld	s1,24(sp)
    800008b4:	6942                	ld	s2,16(sp)
    800008b6:	69a2                	ld	s3,8(sp)
    800008b8:	6a02                	ld	s4,0(sp)
    800008ba:	6145                	addi	sp,sp,48
    800008bc:	8082                	ret
    panic("inituvm: more than a page");
    800008be:	00009517          	auipc	a0,0x9
    800008c2:	82a50513          	addi	a0,a0,-2006 # 800090e8 <etext+0xe8>
    800008c6:	00006097          	auipc	ra,0x6
    800008ca:	32e080e7          	jalr	814(ra) # 80006bf4 <panic>

00000000800008ce <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008ce:	1101                	addi	sp,sp,-32
    800008d0:	ec06                	sd	ra,24(sp)
    800008d2:	e822                	sd	s0,16(sp)
    800008d4:	e426                	sd	s1,8(sp)
    800008d6:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008d8:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008da:	00b67d63          	bgeu	a2,a1,800008f4 <uvmdealloc+0x26>
    800008de:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008e0:	6785                	lui	a5,0x1
    800008e2:	17fd                	addi	a5,a5,-1
    800008e4:	00f60733          	add	a4,a2,a5
    800008e8:	767d                	lui	a2,0xfffff
    800008ea:	8f71                	and	a4,a4,a2
    800008ec:	97ae                	add	a5,a5,a1
    800008ee:	8ff1                	and	a5,a5,a2
    800008f0:	00f76863          	bltu	a4,a5,80000900 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008f4:	8526                	mv	a0,s1
    800008f6:	60e2                	ld	ra,24(sp)
    800008f8:	6442                	ld	s0,16(sp)
    800008fa:	64a2                	ld	s1,8(sp)
    800008fc:	6105                	addi	sp,sp,32
    800008fe:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000900:	8f99                	sub	a5,a5,a4
    80000902:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000904:	4685                	li	a3,1
    80000906:	0007861b          	sext.w	a2,a5
    8000090a:	85ba                	mv	a1,a4
    8000090c:	00000097          	auipc	ra,0x0
    80000910:	e4a080e7          	jalr	-438(ra) # 80000756 <uvmunmap>
    80000914:	b7c5                	j	800008f4 <uvmdealloc+0x26>

0000000080000916 <uvmalloc>:
  if(newsz < oldsz)
    80000916:	0ab66163          	bltu	a2,a1,800009b8 <uvmalloc+0xa2>
{
    8000091a:	7139                	addi	sp,sp,-64
    8000091c:	fc06                	sd	ra,56(sp)
    8000091e:	f822                	sd	s0,48(sp)
    80000920:	f426                	sd	s1,40(sp)
    80000922:	f04a                	sd	s2,32(sp)
    80000924:	ec4e                	sd	s3,24(sp)
    80000926:	e852                	sd	s4,16(sp)
    80000928:	e456                	sd	s5,8(sp)
    8000092a:	0080                	addi	s0,sp,64
    8000092c:	8aaa                	mv	s5,a0
    8000092e:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000930:	6985                	lui	s3,0x1
    80000932:	19fd                	addi	s3,s3,-1
    80000934:	95ce                	add	a1,a1,s3
    80000936:	79fd                	lui	s3,0xfffff
    80000938:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000093c:	08c9f063          	bgeu	s3,a2,800009bc <uvmalloc+0xa6>
    80000940:	894e                	mv	s2,s3
    mem = kalloc();
    80000942:	fffff097          	auipc	ra,0xfffff
    80000946:	7d6080e7          	jalr	2006(ra) # 80000118 <kalloc>
    8000094a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000094c:	c51d                	beqz	a0,8000097a <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000094e:	6605                	lui	a2,0x1
    80000950:	4581                	li	a1,0
    80000952:	00000097          	auipc	ra,0x0
    80000956:	826080e7          	jalr	-2010(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    8000095a:	4779                	li	a4,30
    8000095c:	86a6                	mv	a3,s1
    8000095e:	6605                	lui	a2,0x1
    80000960:	85ca                	mv	a1,s2
    80000962:	8556                	mv	a0,s5
    80000964:	00000097          	auipc	ra,0x0
    80000968:	bfc080e7          	jalr	-1028(ra) # 80000560 <mappages>
    8000096c:	e905                	bnez	a0,8000099c <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000096e:	6785                	lui	a5,0x1
    80000970:	993e                	add	s2,s2,a5
    80000972:	fd4968e3          	bltu	s2,s4,80000942 <uvmalloc+0x2c>
  return newsz;
    80000976:	8552                	mv	a0,s4
    80000978:	a809                	j	8000098a <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000097a:	864e                	mv	a2,s3
    8000097c:	85ca                	mv	a1,s2
    8000097e:	8556                	mv	a0,s5
    80000980:	00000097          	auipc	ra,0x0
    80000984:	f4e080e7          	jalr	-178(ra) # 800008ce <uvmdealloc>
      return 0;
    80000988:	4501                	li	a0,0
}
    8000098a:	70e2                	ld	ra,56(sp)
    8000098c:	7442                	ld	s0,48(sp)
    8000098e:	74a2                	ld	s1,40(sp)
    80000990:	7902                	ld	s2,32(sp)
    80000992:	69e2                	ld	s3,24(sp)
    80000994:	6a42                	ld	s4,16(sp)
    80000996:	6aa2                	ld	s5,8(sp)
    80000998:	6121                	addi	sp,sp,64
    8000099a:	8082                	ret
      kfree(mem);
    8000099c:	8526                	mv	a0,s1
    8000099e:	fffff097          	auipc	ra,0xfffff
    800009a2:	67e080e7          	jalr	1662(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009a6:	864e                	mv	a2,s3
    800009a8:	85ca                	mv	a1,s2
    800009aa:	8556                	mv	a0,s5
    800009ac:	00000097          	auipc	ra,0x0
    800009b0:	f22080e7          	jalr	-222(ra) # 800008ce <uvmdealloc>
      return 0;
    800009b4:	4501                	li	a0,0
    800009b6:	bfd1                	j	8000098a <uvmalloc+0x74>
    return oldsz;
    800009b8:	852e                	mv	a0,a1
}
    800009ba:	8082                	ret
  return newsz;
    800009bc:	8532                	mv	a0,a2
    800009be:	b7f1                	j	8000098a <uvmalloc+0x74>

00000000800009c0 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009c0:	7179                	addi	sp,sp,-48
    800009c2:	f406                	sd	ra,40(sp)
    800009c4:	f022                	sd	s0,32(sp)
    800009c6:	ec26                	sd	s1,24(sp)
    800009c8:	e84a                	sd	s2,16(sp)
    800009ca:	e44e                	sd	s3,8(sp)
    800009cc:	e052                	sd	s4,0(sp)
    800009ce:	1800                	addi	s0,sp,48
    800009d0:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009d2:	84aa                	mv	s1,a0
    800009d4:	6905                	lui	s2,0x1
    800009d6:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009d8:	4985                	li	s3,1
    800009da:	a821                	j	800009f2 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009dc:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009de:	0532                	slli	a0,a0,0xc
    800009e0:	00000097          	auipc	ra,0x0
    800009e4:	fe0080e7          	jalr	-32(ra) # 800009c0 <freewalk>
      pagetable[i] = 0;
    800009e8:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009ec:	04a1                	addi	s1,s1,8
    800009ee:	03248163          	beq	s1,s2,80000a10 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009f2:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009f4:	00f57793          	andi	a5,a0,15
    800009f8:	ff3782e3          	beq	a5,s3,800009dc <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009fc:	8905                	andi	a0,a0,1
    800009fe:	d57d                	beqz	a0,800009ec <freewalk+0x2c>
      panic("freewalk: leaf");
    80000a00:	00008517          	auipc	a0,0x8
    80000a04:	70850513          	addi	a0,a0,1800 # 80009108 <etext+0x108>
    80000a08:	00006097          	auipc	ra,0x6
    80000a0c:	1ec080e7          	jalr	492(ra) # 80006bf4 <panic>
    }
  }
  kfree((void*)pagetable);
    80000a10:	8552                	mv	a0,s4
    80000a12:	fffff097          	auipc	ra,0xfffff
    80000a16:	60a080e7          	jalr	1546(ra) # 8000001c <kfree>
}
    80000a1a:	70a2                	ld	ra,40(sp)
    80000a1c:	7402                	ld	s0,32(sp)
    80000a1e:	64e2                	ld	s1,24(sp)
    80000a20:	6942                	ld	s2,16(sp)
    80000a22:	69a2                	ld	s3,8(sp)
    80000a24:	6a02                	ld	s4,0(sp)
    80000a26:	6145                	addi	sp,sp,48
    80000a28:	8082                	ret

0000000080000a2a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a2a:	1101                	addi	sp,sp,-32
    80000a2c:	ec06                	sd	ra,24(sp)
    80000a2e:	e822                	sd	s0,16(sp)
    80000a30:	e426                	sd	s1,8(sp)
    80000a32:	1000                	addi	s0,sp,32
    80000a34:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a36:	e999                	bnez	a1,80000a4c <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a38:	8526                	mv	a0,s1
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	f86080e7          	jalr	-122(ra) # 800009c0 <freewalk>
}
    80000a42:	60e2                	ld	ra,24(sp)
    80000a44:	6442                	ld	s0,16(sp)
    80000a46:	64a2                	ld	s1,8(sp)
    80000a48:	6105                	addi	sp,sp,32
    80000a4a:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a4c:	6605                	lui	a2,0x1
    80000a4e:	167d                	addi	a2,a2,-1
    80000a50:	962e                	add	a2,a2,a1
    80000a52:	4685                	li	a3,1
    80000a54:	8231                	srli	a2,a2,0xc
    80000a56:	4581                	li	a1,0
    80000a58:	00000097          	auipc	ra,0x0
    80000a5c:	cfe080e7          	jalr	-770(ra) # 80000756 <uvmunmap>
    80000a60:	bfe1                	j	80000a38 <uvmfree+0xe>

0000000080000a62 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a62:	c679                	beqz	a2,80000b30 <uvmcopy+0xce>
{
    80000a64:	715d                	addi	sp,sp,-80
    80000a66:	e486                	sd	ra,72(sp)
    80000a68:	e0a2                	sd	s0,64(sp)
    80000a6a:	fc26                	sd	s1,56(sp)
    80000a6c:	f84a                	sd	s2,48(sp)
    80000a6e:	f44e                	sd	s3,40(sp)
    80000a70:	f052                	sd	s4,32(sp)
    80000a72:	ec56                	sd	s5,24(sp)
    80000a74:	e85a                	sd	s6,16(sp)
    80000a76:	e45e                	sd	s7,8(sp)
    80000a78:	0880                	addi	s0,sp,80
    80000a7a:	8b2a                	mv	s6,a0
    80000a7c:	8aae                	mv	s5,a1
    80000a7e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a80:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a82:	4601                	li	a2,0
    80000a84:	85ce                	mv	a1,s3
    80000a86:	855a                	mv	a0,s6
    80000a88:	00000097          	auipc	ra,0x0
    80000a8c:	9f0080e7          	jalr	-1552(ra) # 80000478 <walk>
    80000a90:	c531                	beqz	a0,80000adc <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a92:	6118                	ld	a4,0(a0)
    80000a94:	00177793          	andi	a5,a4,1
    80000a98:	cbb1                	beqz	a5,80000aec <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a9a:	00a75593          	srli	a1,a4,0xa
    80000a9e:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000aa2:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000aa6:	fffff097          	auipc	ra,0xfffff
    80000aaa:	672080e7          	jalr	1650(ra) # 80000118 <kalloc>
    80000aae:	892a                	mv	s2,a0
    80000ab0:	c939                	beqz	a0,80000b06 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000ab2:	6605                	lui	a2,0x1
    80000ab4:	85de                	mv	a1,s7
    80000ab6:	fffff097          	auipc	ra,0xfffff
    80000aba:	722080e7          	jalr	1826(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000abe:	8726                	mv	a4,s1
    80000ac0:	86ca                	mv	a3,s2
    80000ac2:	6605                	lui	a2,0x1
    80000ac4:	85ce                	mv	a1,s3
    80000ac6:	8556                	mv	a0,s5
    80000ac8:	00000097          	auipc	ra,0x0
    80000acc:	a98080e7          	jalr	-1384(ra) # 80000560 <mappages>
    80000ad0:	e515                	bnez	a0,80000afc <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ad2:	6785                	lui	a5,0x1
    80000ad4:	99be                	add	s3,s3,a5
    80000ad6:	fb49e6e3          	bltu	s3,s4,80000a82 <uvmcopy+0x20>
    80000ada:	a081                	j	80000b1a <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000adc:	00008517          	auipc	a0,0x8
    80000ae0:	63c50513          	addi	a0,a0,1596 # 80009118 <etext+0x118>
    80000ae4:	00006097          	auipc	ra,0x6
    80000ae8:	110080e7          	jalr	272(ra) # 80006bf4 <panic>
      panic("uvmcopy: page not present");
    80000aec:	00008517          	auipc	a0,0x8
    80000af0:	64c50513          	addi	a0,a0,1612 # 80009138 <etext+0x138>
    80000af4:	00006097          	auipc	ra,0x6
    80000af8:	100080e7          	jalr	256(ra) # 80006bf4 <panic>
      kfree(mem);
    80000afc:	854a                	mv	a0,s2
    80000afe:	fffff097          	auipc	ra,0xfffff
    80000b02:	51e080e7          	jalr	1310(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b06:	4685                	li	a3,1
    80000b08:	00c9d613          	srli	a2,s3,0xc
    80000b0c:	4581                	li	a1,0
    80000b0e:	8556                	mv	a0,s5
    80000b10:	00000097          	auipc	ra,0x0
    80000b14:	c46080e7          	jalr	-954(ra) # 80000756 <uvmunmap>
  return -1;
    80000b18:	557d                	li	a0,-1
}
    80000b1a:	60a6                	ld	ra,72(sp)
    80000b1c:	6406                	ld	s0,64(sp)
    80000b1e:	74e2                	ld	s1,56(sp)
    80000b20:	7942                	ld	s2,48(sp)
    80000b22:	79a2                	ld	s3,40(sp)
    80000b24:	7a02                	ld	s4,32(sp)
    80000b26:	6ae2                	ld	s5,24(sp)
    80000b28:	6b42                	ld	s6,16(sp)
    80000b2a:	6ba2                	ld	s7,8(sp)
    80000b2c:	6161                	addi	sp,sp,80
    80000b2e:	8082                	ret
  return 0;
    80000b30:	4501                	li	a0,0
}
    80000b32:	8082                	ret

0000000080000b34 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b34:	1141                	addi	sp,sp,-16
    80000b36:	e406                	sd	ra,8(sp)
    80000b38:	e022                	sd	s0,0(sp)
    80000b3a:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b3c:	4601                	li	a2,0
    80000b3e:	00000097          	auipc	ra,0x0
    80000b42:	93a080e7          	jalr	-1734(ra) # 80000478 <walk>
  if(pte == 0)
    80000b46:	c901                	beqz	a0,80000b56 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b48:	611c                	ld	a5,0(a0)
    80000b4a:	9bbd                	andi	a5,a5,-17
    80000b4c:	e11c                	sd	a5,0(a0)
}
    80000b4e:	60a2                	ld	ra,8(sp)
    80000b50:	6402                	ld	s0,0(sp)
    80000b52:	0141                	addi	sp,sp,16
    80000b54:	8082                	ret
    panic("uvmclear");
    80000b56:	00008517          	auipc	a0,0x8
    80000b5a:	60250513          	addi	a0,a0,1538 # 80009158 <etext+0x158>
    80000b5e:	00006097          	auipc	ra,0x6
    80000b62:	096080e7          	jalr	150(ra) # 80006bf4 <panic>

0000000080000b66 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b66:	c6bd                	beqz	a3,80000bd4 <copyout+0x6e>
{
    80000b68:	715d                	addi	sp,sp,-80
    80000b6a:	e486                	sd	ra,72(sp)
    80000b6c:	e0a2                	sd	s0,64(sp)
    80000b6e:	fc26                	sd	s1,56(sp)
    80000b70:	f84a                	sd	s2,48(sp)
    80000b72:	f44e                	sd	s3,40(sp)
    80000b74:	f052                	sd	s4,32(sp)
    80000b76:	ec56                	sd	s5,24(sp)
    80000b78:	e85a                	sd	s6,16(sp)
    80000b7a:	e45e                	sd	s7,8(sp)
    80000b7c:	e062                	sd	s8,0(sp)
    80000b7e:	0880                	addi	s0,sp,80
    80000b80:	8b2a                	mv	s6,a0
    80000b82:	8c2e                	mv	s8,a1
    80000b84:	8a32                	mv	s4,a2
    80000b86:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b88:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b8a:	6a85                	lui	s5,0x1
    80000b8c:	a015                	j	80000bb0 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b8e:	9562                	add	a0,a0,s8
    80000b90:	0004861b          	sext.w	a2,s1
    80000b94:	85d2                	mv	a1,s4
    80000b96:	41250533          	sub	a0,a0,s2
    80000b9a:	fffff097          	auipc	ra,0xfffff
    80000b9e:	63e080e7          	jalr	1598(ra) # 800001d8 <memmove>

    len -= n;
    80000ba2:	409989b3          	sub	s3,s3,s1
    src += n;
    80000ba6:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000ba8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bac:	02098263          	beqz	s3,80000bd0 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000bb0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bb4:	85ca                	mv	a1,s2
    80000bb6:	855a                	mv	a0,s6
    80000bb8:	00000097          	auipc	ra,0x0
    80000bbc:	966080e7          	jalr	-1690(ra) # 8000051e <walkaddr>
    if(pa0 == 0)
    80000bc0:	cd01                	beqz	a0,80000bd8 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bc2:	418904b3          	sub	s1,s2,s8
    80000bc6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bc8:	fc99f3e3          	bgeu	s3,s1,80000b8e <copyout+0x28>
    80000bcc:	84ce                	mv	s1,s3
    80000bce:	b7c1                	j	80000b8e <copyout+0x28>
  }
  return 0;
    80000bd0:	4501                	li	a0,0
    80000bd2:	a021                	j	80000bda <copyout+0x74>
    80000bd4:	4501                	li	a0,0
}
    80000bd6:	8082                	ret
      return -1;
    80000bd8:	557d                	li	a0,-1
}
    80000bda:	60a6                	ld	ra,72(sp)
    80000bdc:	6406                	ld	s0,64(sp)
    80000bde:	74e2                	ld	s1,56(sp)
    80000be0:	7942                	ld	s2,48(sp)
    80000be2:	79a2                	ld	s3,40(sp)
    80000be4:	7a02                	ld	s4,32(sp)
    80000be6:	6ae2                	ld	s5,24(sp)
    80000be8:	6b42                	ld	s6,16(sp)
    80000bea:	6ba2                	ld	s7,8(sp)
    80000bec:	6c02                	ld	s8,0(sp)
    80000bee:	6161                	addi	sp,sp,80
    80000bf0:	8082                	ret

0000000080000bf2 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000bf2:	c6bd                	beqz	a3,80000c60 <copyin+0x6e>
{
    80000bf4:	715d                	addi	sp,sp,-80
    80000bf6:	e486                	sd	ra,72(sp)
    80000bf8:	e0a2                	sd	s0,64(sp)
    80000bfa:	fc26                	sd	s1,56(sp)
    80000bfc:	f84a                	sd	s2,48(sp)
    80000bfe:	f44e                	sd	s3,40(sp)
    80000c00:	f052                	sd	s4,32(sp)
    80000c02:	ec56                	sd	s5,24(sp)
    80000c04:	e85a                	sd	s6,16(sp)
    80000c06:	e45e                	sd	s7,8(sp)
    80000c08:	e062                	sd	s8,0(sp)
    80000c0a:	0880                	addi	s0,sp,80
    80000c0c:	8b2a                	mv	s6,a0
    80000c0e:	8a2e                	mv	s4,a1
    80000c10:	8c32                	mv	s8,a2
    80000c12:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c14:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c16:	6a85                	lui	s5,0x1
    80000c18:	a015                	j	80000c3c <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c1a:	9562                	add	a0,a0,s8
    80000c1c:	0004861b          	sext.w	a2,s1
    80000c20:	412505b3          	sub	a1,a0,s2
    80000c24:	8552                	mv	a0,s4
    80000c26:	fffff097          	auipc	ra,0xfffff
    80000c2a:	5b2080e7          	jalr	1458(ra) # 800001d8 <memmove>

    len -= n;
    80000c2e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c32:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c34:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c38:	02098263          	beqz	s3,80000c5c <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c3c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c40:	85ca                	mv	a1,s2
    80000c42:	855a                	mv	a0,s6
    80000c44:	00000097          	auipc	ra,0x0
    80000c48:	8da080e7          	jalr	-1830(ra) # 8000051e <walkaddr>
    if(pa0 == 0)
    80000c4c:	cd01                	beqz	a0,80000c64 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c4e:	418904b3          	sub	s1,s2,s8
    80000c52:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c54:	fc99f3e3          	bgeu	s3,s1,80000c1a <copyin+0x28>
    80000c58:	84ce                	mv	s1,s3
    80000c5a:	b7c1                	j	80000c1a <copyin+0x28>
  }
  return 0;
    80000c5c:	4501                	li	a0,0
    80000c5e:	a021                	j	80000c66 <copyin+0x74>
    80000c60:	4501                	li	a0,0
}
    80000c62:	8082                	ret
      return -1;
    80000c64:	557d                	li	a0,-1
}
    80000c66:	60a6                	ld	ra,72(sp)
    80000c68:	6406                	ld	s0,64(sp)
    80000c6a:	74e2                	ld	s1,56(sp)
    80000c6c:	7942                	ld	s2,48(sp)
    80000c6e:	79a2                	ld	s3,40(sp)
    80000c70:	7a02                	ld	s4,32(sp)
    80000c72:	6ae2                	ld	s5,24(sp)
    80000c74:	6b42                	ld	s6,16(sp)
    80000c76:	6ba2                	ld	s7,8(sp)
    80000c78:	6c02                	ld	s8,0(sp)
    80000c7a:	6161                	addi	sp,sp,80
    80000c7c:	8082                	ret

0000000080000c7e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c7e:	c6c5                	beqz	a3,80000d26 <copyinstr+0xa8>
{
    80000c80:	715d                	addi	sp,sp,-80
    80000c82:	e486                	sd	ra,72(sp)
    80000c84:	e0a2                	sd	s0,64(sp)
    80000c86:	fc26                	sd	s1,56(sp)
    80000c88:	f84a                	sd	s2,48(sp)
    80000c8a:	f44e                	sd	s3,40(sp)
    80000c8c:	f052                	sd	s4,32(sp)
    80000c8e:	ec56                	sd	s5,24(sp)
    80000c90:	e85a                	sd	s6,16(sp)
    80000c92:	e45e                	sd	s7,8(sp)
    80000c94:	0880                	addi	s0,sp,80
    80000c96:	8a2a                	mv	s4,a0
    80000c98:	8b2e                	mv	s6,a1
    80000c9a:	8bb2                	mv	s7,a2
    80000c9c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c9e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ca0:	6985                	lui	s3,0x1
    80000ca2:	a035                	j	80000cce <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000ca4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ca8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000caa:	0017b793          	seqz	a5,a5
    80000cae:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cb2:	60a6                	ld	ra,72(sp)
    80000cb4:	6406                	ld	s0,64(sp)
    80000cb6:	74e2                	ld	s1,56(sp)
    80000cb8:	7942                	ld	s2,48(sp)
    80000cba:	79a2                	ld	s3,40(sp)
    80000cbc:	7a02                	ld	s4,32(sp)
    80000cbe:	6ae2                	ld	s5,24(sp)
    80000cc0:	6b42                	ld	s6,16(sp)
    80000cc2:	6ba2                	ld	s7,8(sp)
    80000cc4:	6161                	addi	sp,sp,80
    80000cc6:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cc8:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000ccc:	c8a9                	beqz	s1,80000d1e <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cce:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cd2:	85ca                	mv	a1,s2
    80000cd4:	8552                	mv	a0,s4
    80000cd6:	00000097          	auipc	ra,0x0
    80000cda:	848080e7          	jalr	-1976(ra) # 8000051e <walkaddr>
    if(pa0 == 0)
    80000cde:	c131                	beqz	a0,80000d22 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000ce0:	41790833          	sub	a6,s2,s7
    80000ce4:	984e                	add	a6,a6,s3
    if(n > max)
    80000ce6:	0104f363          	bgeu	s1,a6,80000cec <copyinstr+0x6e>
    80000cea:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cec:	955e                	add	a0,a0,s7
    80000cee:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cf2:	fc080be3          	beqz	a6,80000cc8 <copyinstr+0x4a>
    80000cf6:	985a                	add	a6,a6,s6
    80000cf8:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000cfa:	41650633          	sub	a2,a0,s6
    80000cfe:	14fd                	addi	s1,s1,-1
    80000d00:	9b26                	add	s6,s6,s1
    80000d02:	00f60733          	add	a4,a2,a5
    80000d06:	00074703          	lbu	a4,0(a4)
    80000d0a:	df49                	beqz	a4,80000ca4 <copyinstr+0x26>
        *dst = *p;
    80000d0c:	00e78023          	sb	a4,0(a5)
      --max;
    80000d10:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d14:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d16:	ff0796e3          	bne	a5,a6,80000d02 <copyinstr+0x84>
      dst++;
    80000d1a:	8b42                	mv	s6,a6
    80000d1c:	b775                	j	80000cc8 <copyinstr+0x4a>
    80000d1e:	4781                	li	a5,0
    80000d20:	b769                	j	80000caa <copyinstr+0x2c>
      return -1;
    80000d22:	557d                	li	a0,-1
    80000d24:	b779                	j	80000cb2 <copyinstr+0x34>
  int got_null = 0;
    80000d26:	4781                	li	a5,0
  if(got_null){
    80000d28:	0017b793          	seqz	a5,a5
    80000d2c:	40f00533          	neg	a0,a5
}
    80000d30:	8082                	ret

0000000080000d32 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d32:	7139                	addi	sp,sp,-64
    80000d34:	fc06                	sd	ra,56(sp)
    80000d36:	f822                	sd	s0,48(sp)
    80000d38:	f426                	sd	s1,40(sp)
    80000d3a:	f04a                	sd	s2,32(sp)
    80000d3c:	ec4e                	sd	s3,24(sp)
    80000d3e:	e852                	sd	s4,16(sp)
    80000d40:	e456                	sd	s5,8(sp)
    80000d42:	e05a                	sd	s6,0(sp)
    80000d44:	0080                	addi	s0,sp,64
    80000d46:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d48:	00009497          	auipc	s1,0x9
    80000d4c:	75848493          	addi	s1,s1,1880 # 8000a4a0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d50:	8b26                	mv	s6,s1
    80000d52:	00008a97          	auipc	s5,0x8
    80000d56:	2aea8a93          	addi	s5,s5,686 # 80009000 <etext>
    80000d5a:	01000937          	lui	s2,0x1000
    80000d5e:	197d                	addi	s2,s2,-1
    80000d60:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d62:	0000fa17          	auipc	s4,0xf
    80000d66:	13ea0a13          	addi	s4,s4,318 # 8000fea0 <tickslock>
    char *pa = kalloc();
    80000d6a:	fffff097          	auipc	ra,0xfffff
    80000d6e:	3ae080e7          	jalr	942(ra) # 80000118 <kalloc>
    80000d72:	862a                	mv	a2,a0
    if(pa == 0)
    80000d74:	c129                	beqz	a0,80000db6 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000d76:	416485b3          	sub	a1,s1,s6
    80000d7a:	858d                	srai	a1,a1,0x3
    80000d7c:	000ab783          	ld	a5,0(s5)
    80000d80:	02f585b3          	mul	a1,a1,a5
    80000d84:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d88:	4719                	li	a4,6
    80000d8a:	6685                	lui	a3,0x1
    80000d8c:	40b905b3          	sub	a1,s2,a1
    80000d90:	854e                	mv	a0,s3
    80000d92:	00000097          	auipc	ra,0x0
    80000d96:	86e080e7          	jalr	-1938(ra) # 80000600 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d9a:	16848493          	addi	s1,s1,360
    80000d9e:	fd4496e3          	bne	s1,s4,80000d6a <proc_mapstacks+0x38>
  }
}
    80000da2:	70e2                	ld	ra,56(sp)
    80000da4:	7442                	ld	s0,48(sp)
    80000da6:	74a2                	ld	s1,40(sp)
    80000da8:	7902                	ld	s2,32(sp)
    80000daa:	69e2                	ld	s3,24(sp)
    80000dac:	6a42                	ld	s4,16(sp)
    80000dae:	6aa2                	ld	s5,8(sp)
    80000db0:	6b02                	ld	s6,0(sp)
    80000db2:	6121                	addi	sp,sp,64
    80000db4:	8082                	ret
      panic("kalloc");
    80000db6:	00008517          	auipc	a0,0x8
    80000dba:	3b250513          	addi	a0,a0,946 # 80009168 <etext+0x168>
    80000dbe:	00006097          	auipc	ra,0x6
    80000dc2:	e36080e7          	jalr	-458(ra) # 80006bf4 <panic>

0000000080000dc6 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000dc6:	7139                	addi	sp,sp,-64
    80000dc8:	fc06                	sd	ra,56(sp)
    80000dca:	f822                	sd	s0,48(sp)
    80000dcc:	f426                	sd	s1,40(sp)
    80000dce:	f04a                	sd	s2,32(sp)
    80000dd0:	ec4e                	sd	s3,24(sp)
    80000dd2:	e852                	sd	s4,16(sp)
    80000dd4:	e456                	sd	s5,8(sp)
    80000dd6:	e05a                	sd	s6,0(sp)
    80000dd8:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dda:	00008597          	auipc	a1,0x8
    80000dde:	39658593          	addi	a1,a1,918 # 80009170 <etext+0x170>
    80000de2:	00009517          	auipc	a0,0x9
    80000de6:	28e50513          	addi	a0,a0,654 # 8000a070 <pid_lock>
    80000dea:	00006097          	auipc	ra,0x6
    80000dee:	2c4080e7          	jalr	708(ra) # 800070ae <initlock>
  initlock(&wait_lock, "wait_lock");
    80000df2:	00008597          	auipc	a1,0x8
    80000df6:	38658593          	addi	a1,a1,902 # 80009178 <etext+0x178>
    80000dfa:	00009517          	auipc	a0,0x9
    80000dfe:	28e50513          	addi	a0,a0,654 # 8000a088 <wait_lock>
    80000e02:	00006097          	auipc	ra,0x6
    80000e06:	2ac080e7          	jalr	684(ra) # 800070ae <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0a:	00009497          	auipc	s1,0x9
    80000e0e:	69648493          	addi	s1,s1,1686 # 8000a4a0 <proc>
      initlock(&p->lock, "proc");
    80000e12:	00008b17          	auipc	s6,0x8
    80000e16:	376b0b13          	addi	s6,s6,886 # 80009188 <etext+0x188>
      p->kstack = KSTACK((int) (p - proc));
    80000e1a:	8aa6                	mv	s5,s1
    80000e1c:	00008a17          	auipc	s4,0x8
    80000e20:	1e4a0a13          	addi	s4,s4,484 # 80009000 <etext>
    80000e24:	01000937          	lui	s2,0x1000
    80000e28:	197d                	addi	s2,s2,-1
    80000e2a:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e2c:	0000f997          	auipc	s3,0xf
    80000e30:	07498993          	addi	s3,s3,116 # 8000fea0 <tickslock>
      initlock(&p->lock, "proc");
    80000e34:	85da                	mv	a1,s6
    80000e36:	8526                	mv	a0,s1
    80000e38:	00006097          	auipc	ra,0x6
    80000e3c:	276080e7          	jalr	630(ra) # 800070ae <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e40:	415487b3          	sub	a5,s1,s5
    80000e44:	878d                	srai	a5,a5,0x3
    80000e46:	000a3703          	ld	a4,0(s4)
    80000e4a:	02e787b3          	mul	a5,a5,a4
    80000e4e:	00d7979b          	slliw	a5,a5,0xd
    80000e52:	40f907b3          	sub	a5,s2,a5
    80000e56:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e58:	16848493          	addi	s1,s1,360
    80000e5c:	fd349ce3          	bne	s1,s3,80000e34 <procinit+0x6e>
  }
}
    80000e60:	70e2                	ld	ra,56(sp)
    80000e62:	7442                	ld	s0,48(sp)
    80000e64:	74a2                	ld	s1,40(sp)
    80000e66:	7902                	ld	s2,32(sp)
    80000e68:	69e2                	ld	s3,24(sp)
    80000e6a:	6a42                	ld	s4,16(sp)
    80000e6c:	6aa2                	ld	s5,8(sp)
    80000e6e:	6b02                	ld	s6,0(sp)
    80000e70:	6121                	addi	sp,sp,64
    80000e72:	8082                	ret

0000000080000e74 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e74:	1141                	addi	sp,sp,-16
    80000e76:	e422                	sd	s0,8(sp)
    80000e78:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e7a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e7c:	2501                	sext.w	a0,a0
    80000e7e:	6422                	ld	s0,8(sp)
    80000e80:	0141                	addi	sp,sp,16
    80000e82:	8082                	ret

0000000080000e84 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e84:	1141                	addi	sp,sp,-16
    80000e86:	e422                	sd	s0,8(sp)
    80000e88:	0800                	addi	s0,sp,16
    80000e8a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e8c:	2781                	sext.w	a5,a5
    80000e8e:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e90:	00009517          	auipc	a0,0x9
    80000e94:	21050513          	addi	a0,a0,528 # 8000a0a0 <cpus>
    80000e98:	953e                	add	a0,a0,a5
    80000e9a:	6422                	ld	s0,8(sp)
    80000e9c:	0141                	addi	sp,sp,16
    80000e9e:	8082                	ret

0000000080000ea0 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000ea0:	1101                	addi	sp,sp,-32
    80000ea2:	ec06                	sd	ra,24(sp)
    80000ea4:	e822                	sd	s0,16(sp)
    80000ea6:	e426                	sd	s1,8(sp)
    80000ea8:	1000                	addi	s0,sp,32
  push_off();
    80000eaa:	00006097          	auipc	ra,0x6
    80000eae:	248080e7          	jalr	584(ra) # 800070f2 <push_off>
    80000eb2:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000eb4:	2781                	sext.w	a5,a5
    80000eb6:	079e                	slli	a5,a5,0x7
    80000eb8:	00009717          	auipc	a4,0x9
    80000ebc:	1b870713          	addi	a4,a4,440 # 8000a070 <pid_lock>
    80000ec0:	97ba                	add	a5,a5,a4
    80000ec2:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ec4:	00006097          	auipc	ra,0x6
    80000ec8:	2ce080e7          	jalr	718(ra) # 80007192 <pop_off>
  return p;
}
    80000ecc:	8526                	mv	a0,s1
    80000ece:	60e2                	ld	ra,24(sp)
    80000ed0:	6442                	ld	s0,16(sp)
    80000ed2:	64a2                	ld	s1,8(sp)
    80000ed4:	6105                	addi	sp,sp,32
    80000ed6:	8082                	ret

0000000080000ed8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ed8:	1141                	addi	sp,sp,-16
    80000eda:	e406                	sd	ra,8(sp)
    80000edc:	e022                	sd	s0,0(sp)
    80000ede:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ee0:	00000097          	auipc	ra,0x0
    80000ee4:	fc0080e7          	jalr	-64(ra) # 80000ea0 <myproc>
    80000ee8:	00006097          	auipc	ra,0x6
    80000eec:	30a080e7          	jalr	778(ra) # 800071f2 <release>

  if (first) {
    80000ef0:	00009797          	auipc	a5,0x9
    80000ef4:	9b07a783          	lw	a5,-1616(a5) # 800098a0 <first.1722>
    80000ef8:	eb89                	bnez	a5,80000f0a <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000efa:	00001097          	auipc	ra,0x1
    80000efe:	c0a080e7          	jalr	-1014(ra) # 80001b04 <usertrapret>
}
    80000f02:	60a2                	ld	ra,8(sp)
    80000f04:	6402                	ld	s0,0(sp)
    80000f06:	0141                	addi	sp,sp,16
    80000f08:	8082                	ret
    first = 0;
    80000f0a:	00009797          	auipc	a5,0x9
    80000f0e:	9807ab23          	sw	zero,-1642(a5) # 800098a0 <first.1722>
    fsinit(ROOTDEV);
    80000f12:	4505                	li	a0,1
    80000f14:	00002097          	auipc	ra,0x2
    80000f18:	962080e7          	jalr	-1694(ra) # 80002876 <fsinit>
    80000f1c:	bff9                	j	80000efa <forkret+0x22>

0000000080000f1e <allocpid>:
allocpid() {
    80000f1e:	1101                	addi	sp,sp,-32
    80000f20:	ec06                	sd	ra,24(sp)
    80000f22:	e822                	sd	s0,16(sp)
    80000f24:	e426                	sd	s1,8(sp)
    80000f26:	e04a                	sd	s2,0(sp)
    80000f28:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f2a:	00009917          	auipc	s2,0x9
    80000f2e:	14690913          	addi	s2,s2,326 # 8000a070 <pid_lock>
    80000f32:	854a                	mv	a0,s2
    80000f34:	00006097          	auipc	ra,0x6
    80000f38:	20a080e7          	jalr	522(ra) # 8000713e <acquire>
  pid = nextpid;
    80000f3c:	00009797          	auipc	a5,0x9
    80000f40:	96878793          	addi	a5,a5,-1688 # 800098a4 <nextpid>
    80000f44:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f46:	0014871b          	addiw	a4,s1,1
    80000f4a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f4c:	854a                	mv	a0,s2
    80000f4e:	00006097          	auipc	ra,0x6
    80000f52:	2a4080e7          	jalr	676(ra) # 800071f2 <release>
}
    80000f56:	8526                	mv	a0,s1
    80000f58:	60e2                	ld	ra,24(sp)
    80000f5a:	6442                	ld	s0,16(sp)
    80000f5c:	64a2                	ld	s1,8(sp)
    80000f5e:	6902                	ld	s2,0(sp)
    80000f60:	6105                	addi	sp,sp,32
    80000f62:	8082                	ret

0000000080000f64 <proc_pagetable>:
{
    80000f64:	1101                	addi	sp,sp,-32
    80000f66:	ec06                	sd	ra,24(sp)
    80000f68:	e822                	sd	s0,16(sp)
    80000f6a:	e426                	sd	s1,8(sp)
    80000f6c:	e04a                	sd	s2,0(sp)
    80000f6e:	1000                	addi	s0,sp,32
    80000f70:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f72:	00000097          	auipc	ra,0x0
    80000f76:	8bc080e7          	jalr	-1860(ra) # 8000082e <uvmcreate>
    80000f7a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f7c:	c121                	beqz	a0,80000fbc <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f7e:	4729                	li	a4,10
    80000f80:	00007697          	auipc	a3,0x7
    80000f84:	08068693          	addi	a3,a3,128 # 80008000 <_trampoline>
    80000f88:	6605                	lui	a2,0x1
    80000f8a:	040005b7          	lui	a1,0x4000
    80000f8e:	15fd                	addi	a1,a1,-1
    80000f90:	05b2                	slli	a1,a1,0xc
    80000f92:	fffff097          	auipc	ra,0xfffff
    80000f96:	5ce080e7          	jalr	1486(ra) # 80000560 <mappages>
    80000f9a:	02054863          	bltz	a0,80000fca <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f9e:	4719                	li	a4,6
    80000fa0:	05893683          	ld	a3,88(s2)
    80000fa4:	6605                	lui	a2,0x1
    80000fa6:	020005b7          	lui	a1,0x2000
    80000faa:	15fd                	addi	a1,a1,-1
    80000fac:	05b6                	slli	a1,a1,0xd
    80000fae:	8526                	mv	a0,s1
    80000fb0:	fffff097          	auipc	ra,0xfffff
    80000fb4:	5b0080e7          	jalr	1456(ra) # 80000560 <mappages>
    80000fb8:	02054163          	bltz	a0,80000fda <proc_pagetable+0x76>
}
    80000fbc:	8526                	mv	a0,s1
    80000fbe:	60e2                	ld	ra,24(sp)
    80000fc0:	6442                	ld	s0,16(sp)
    80000fc2:	64a2                	ld	s1,8(sp)
    80000fc4:	6902                	ld	s2,0(sp)
    80000fc6:	6105                	addi	sp,sp,32
    80000fc8:	8082                	ret
    uvmfree(pagetable, 0);
    80000fca:	4581                	li	a1,0
    80000fcc:	8526                	mv	a0,s1
    80000fce:	00000097          	auipc	ra,0x0
    80000fd2:	a5c080e7          	jalr	-1444(ra) # 80000a2a <uvmfree>
    return 0;
    80000fd6:	4481                	li	s1,0
    80000fd8:	b7d5                	j	80000fbc <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fda:	4681                	li	a3,0
    80000fdc:	4605                	li	a2,1
    80000fde:	040005b7          	lui	a1,0x4000
    80000fe2:	15fd                	addi	a1,a1,-1
    80000fe4:	05b2                	slli	a1,a1,0xc
    80000fe6:	8526                	mv	a0,s1
    80000fe8:	fffff097          	auipc	ra,0xfffff
    80000fec:	76e080e7          	jalr	1902(ra) # 80000756 <uvmunmap>
    uvmfree(pagetable, 0);
    80000ff0:	4581                	li	a1,0
    80000ff2:	8526                	mv	a0,s1
    80000ff4:	00000097          	auipc	ra,0x0
    80000ff8:	a36080e7          	jalr	-1482(ra) # 80000a2a <uvmfree>
    return 0;
    80000ffc:	4481                	li	s1,0
    80000ffe:	bf7d                	j	80000fbc <proc_pagetable+0x58>

0000000080001000 <proc_freepagetable>:
{
    80001000:	1101                	addi	sp,sp,-32
    80001002:	ec06                	sd	ra,24(sp)
    80001004:	e822                	sd	s0,16(sp)
    80001006:	e426                	sd	s1,8(sp)
    80001008:	e04a                	sd	s2,0(sp)
    8000100a:	1000                	addi	s0,sp,32
    8000100c:	84aa                	mv	s1,a0
    8000100e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001010:	4681                	li	a3,0
    80001012:	4605                	li	a2,1
    80001014:	040005b7          	lui	a1,0x4000
    80001018:	15fd                	addi	a1,a1,-1
    8000101a:	05b2                	slli	a1,a1,0xc
    8000101c:	fffff097          	auipc	ra,0xfffff
    80001020:	73a080e7          	jalr	1850(ra) # 80000756 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001024:	4681                	li	a3,0
    80001026:	4605                	li	a2,1
    80001028:	020005b7          	lui	a1,0x2000
    8000102c:	15fd                	addi	a1,a1,-1
    8000102e:	05b6                	slli	a1,a1,0xd
    80001030:	8526                	mv	a0,s1
    80001032:	fffff097          	auipc	ra,0xfffff
    80001036:	724080e7          	jalr	1828(ra) # 80000756 <uvmunmap>
  uvmfree(pagetable, sz);
    8000103a:	85ca                	mv	a1,s2
    8000103c:	8526                	mv	a0,s1
    8000103e:	00000097          	auipc	ra,0x0
    80001042:	9ec080e7          	jalr	-1556(ra) # 80000a2a <uvmfree>
}
    80001046:	60e2                	ld	ra,24(sp)
    80001048:	6442                	ld	s0,16(sp)
    8000104a:	64a2                	ld	s1,8(sp)
    8000104c:	6902                	ld	s2,0(sp)
    8000104e:	6105                	addi	sp,sp,32
    80001050:	8082                	ret

0000000080001052 <freeproc>:
{
    80001052:	1101                	addi	sp,sp,-32
    80001054:	ec06                	sd	ra,24(sp)
    80001056:	e822                	sd	s0,16(sp)
    80001058:	e426                	sd	s1,8(sp)
    8000105a:	1000                	addi	s0,sp,32
    8000105c:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000105e:	6d28                	ld	a0,88(a0)
    80001060:	c509                	beqz	a0,8000106a <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001062:	fffff097          	auipc	ra,0xfffff
    80001066:	fba080e7          	jalr	-70(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000106a:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000106e:	68a8                	ld	a0,80(s1)
    80001070:	c511                	beqz	a0,8000107c <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001072:	64ac                	ld	a1,72(s1)
    80001074:	00000097          	auipc	ra,0x0
    80001078:	f8c080e7          	jalr	-116(ra) # 80001000 <proc_freepagetable>
  p->pagetable = 0;
    8000107c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001080:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001084:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001088:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000108c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001090:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001094:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001098:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000109c:	0004ac23          	sw	zero,24(s1)
}
    800010a0:	60e2                	ld	ra,24(sp)
    800010a2:	6442                	ld	s0,16(sp)
    800010a4:	64a2                	ld	s1,8(sp)
    800010a6:	6105                	addi	sp,sp,32
    800010a8:	8082                	ret

00000000800010aa <allocproc>:
{
    800010aa:	1101                	addi	sp,sp,-32
    800010ac:	ec06                	sd	ra,24(sp)
    800010ae:	e822                	sd	s0,16(sp)
    800010b0:	e426                	sd	s1,8(sp)
    800010b2:	e04a                	sd	s2,0(sp)
    800010b4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010b6:	00009497          	auipc	s1,0x9
    800010ba:	3ea48493          	addi	s1,s1,1002 # 8000a4a0 <proc>
    800010be:	0000f917          	auipc	s2,0xf
    800010c2:	de290913          	addi	s2,s2,-542 # 8000fea0 <tickslock>
    acquire(&p->lock);
    800010c6:	8526                	mv	a0,s1
    800010c8:	00006097          	auipc	ra,0x6
    800010cc:	076080e7          	jalr	118(ra) # 8000713e <acquire>
    if(p->state == UNUSED) {
    800010d0:	4c9c                	lw	a5,24(s1)
    800010d2:	cf81                	beqz	a5,800010ea <allocproc+0x40>
      release(&p->lock);
    800010d4:	8526                	mv	a0,s1
    800010d6:	00006097          	auipc	ra,0x6
    800010da:	11c080e7          	jalr	284(ra) # 800071f2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010de:	16848493          	addi	s1,s1,360
    800010e2:	ff2492e3          	bne	s1,s2,800010c6 <allocproc+0x1c>
  return 0;
    800010e6:	4481                	li	s1,0
    800010e8:	a889                	j	8000113a <allocproc+0x90>
  p->pid = allocpid();
    800010ea:	00000097          	auipc	ra,0x0
    800010ee:	e34080e7          	jalr	-460(ra) # 80000f1e <allocpid>
    800010f2:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010f4:	4785                	li	a5,1
    800010f6:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010f8:	fffff097          	auipc	ra,0xfffff
    800010fc:	020080e7          	jalr	32(ra) # 80000118 <kalloc>
    80001100:	892a                	mv	s2,a0
    80001102:	eca8                	sd	a0,88(s1)
    80001104:	c131                	beqz	a0,80001148 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001106:	8526                	mv	a0,s1
    80001108:	00000097          	auipc	ra,0x0
    8000110c:	e5c080e7          	jalr	-420(ra) # 80000f64 <proc_pagetable>
    80001110:	892a                	mv	s2,a0
    80001112:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001114:	c531                	beqz	a0,80001160 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001116:	07000613          	li	a2,112
    8000111a:	4581                	li	a1,0
    8000111c:	06048513          	addi	a0,s1,96
    80001120:	fffff097          	auipc	ra,0xfffff
    80001124:	058080e7          	jalr	88(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001128:	00000797          	auipc	a5,0x0
    8000112c:	db078793          	addi	a5,a5,-592 # 80000ed8 <forkret>
    80001130:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001132:	60bc                	ld	a5,64(s1)
    80001134:	6705                	lui	a4,0x1
    80001136:	97ba                	add	a5,a5,a4
    80001138:	f4bc                	sd	a5,104(s1)
}
    8000113a:	8526                	mv	a0,s1
    8000113c:	60e2                	ld	ra,24(sp)
    8000113e:	6442                	ld	s0,16(sp)
    80001140:	64a2                	ld	s1,8(sp)
    80001142:	6902                	ld	s2,0(sp)
    80001144:	6105                	addi	sp,sp,32
    80001146:	8082                	ret
    freeproc(p);
    80001148:	8526                	mv	a0,s1
    8000114a:	00000097          	auipc	ra,0x0
    8000114e:	f08080e7          	jalr	-248(ra) # 80001052 <freeproc>
    release(&p->lock);
    80001152:	8526                	mv	a0,s1
    80001154:	00006097          	auipc	ra,0x6
    80001158:	09e080e7          	jalr	158(ra) # 800071f2 <release>
    return 0;
    8000115c:	84ca                	mv	s1,s2
    8000115e:	bff1                	j	8000113a <allocproc+0x90>
    freeproc(p);
    80001160:	8526                	mv	a0,s1
    80001162:	00000097          	auipc	ra,0x0
    80001166:	ef0080e7          	jalr	-272(ra) # 80001052 <freeproc>
    release(&p->lock);
    8000116a:	8526                	mv	a0,s1
    8000116c:	00006097          	auipc	ra,0x6
    80001170:	086080e7          	jalr	134(ra) # 800071f2 <release>
    return 0;
    80001174:	84ca                	mv	s1,s2
    80001176:	b7d1                	j	8000113a <allocproc+0x90>

0000000080001178 <userinit>:
{
    80001178:	1101                	addi	sp,sp,-32
    8000117a:	ec06                	sd	ra,24(sp)
    8000117c:	e822                	sd	s0,16(sp)
    8000117e:	e426                	sd	s1,8(sp)
    80001180:	1000                	addi	s0,sp,32
  p = allocproc();
    80001182:	00000097          	auipc	ra,0x0
    80001186:	f28080e7          	jalr	-216(ra) # 800010aa <allocproc>
    8000118a:	84aa                	mv	s1,a0
  initproc = p;
    8000118c:	00009797          	auipc	a5,0x9
    80001190:	e8a7b223          	sd	a0,-380(a5) # 8000a010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001194:	03400613          	li	a2,52
    80001198:	00008597          	auipc	a1,0x8
    8000119c:	72858593          	addi	a1,a1,1832 # 800098c0 <initcode>
    800011a0:	6928                	ld	a0,80(a0)
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	6ba080e7          	jalr	1722(ra) # 8000085c <uvminit>
  p->sz = PGSIZE;
    800011aa:	6785                	lui	a5,0x1
    800011ac:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011ae:	6cb8                	ld	a4,88(s1)
    800011b0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011b4:	6cb8                	ld	a4,88(s1)
    800011b6:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011b8:	4641                	li	a2,16
    800011ba:	00008597          	auipc	a1,0x8
    800011be:	fd658593          	addi	a1,a1,-42 # 80009190 <etext+0x190>
    800011c2:	15848513          	addi	a0,s1,344
    800011c6:	fffff097          	auipc	ra,0xfffff
    800011ca:	104080e7          	jalr	260(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    800011ce:	00008517          	auipc	a0,0x8
    800011d2:	fd250513          	addi	a0,a0,-46 # 800091a0 <etext+0x1a0>
    800011d6:	00002097          	auipc	ra,0x2
    800011da:	0ce080e7          	jalr	206(ra) # 800032a4 <namei>
    800011de:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011e2:	478d                	li	a5,3
    800011e4:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011e6:	8526                	mv	a0,s1
    800011e8:	00006097          	auipc	ra,0x6
    800011ec:	00a080e7          	jalr	10(ra) # 800071f2 <release>
}
    800011f0:	60e2                	ld	ra,24(sp)
    800011f2:	6442                	ld	s0,16(sp)
    800011f4:	64a2                	ld	s1,8(sp)
    800011f6:	6105                	addi	sp,sp,32
    800011f8:	8082                	ret

00000000800011fa <growproc>:
{
    800011fa:	1101                	addi	sp,sp,-32
    800011fc:	ec06                	sd	ra,24(sp)
    800011fe:	e822                	sd	s0,16(sp)
    80001200:	e426                	sd	s1,8(sp)
    80001202:	e04a                	sd	s2,0(sp)
    80001204:	1000                	addi	s0,sp,32
    80001206:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001208:	00000097          	auipc	ra,0x0
    8000120c:	c98080e7          	jalr	-872(ra) # 80000ea0 <myproc>
    80001210:	892a                	mv	s2,a0
  sz = p->sz;
    80001212:	652c                	ld	a1,72(a0)
    80001214:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001218:	00904f63          	bgtz	s1,80001236 <growproc+0x3c>
  } else if(n < 0){
    8000121c:	0204cc63          	bltz	s1,80001254 <growproc+0x5a>
  p->sz = sz;
    80001220:	1602                	slli	a2,a2,0x20
    80001222:	9201                	srli	a2,a2,0x20
    80001224:	04c93423          	sd	a2,72(s2)
  return 0;
    80001228:	4501                	li	a0,0
}
    8000122a:	60e2                	ld	ra,24(sp)
    8000122c:	6442                	ld	s0,16(sp)
    8000122e:	64a2                	ld	s1,8(sp)
    80001230:	6902                	ld	s2,0(sp)
    80001232:	6105                	addi	sp,sp,32
    80001234:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001236:	9e25                	addw	a2,a2,s1
    80001238:	1602                	slli	a2,a2,0x20
    8000123a:	9201                	srli	a2,a2,0x20
    8000123c:	1582                	slli	a1,a1,0x20
    8000123e:	9181                	srli	a1,a1,0x20
    80001240:	6928                	ld	a0,80(a0)
    80001242:	fffff097          	auipc	ra,0xfffff
    80001246:	6d4080e7          	jalr	1748(ra) # 80000916 <uvmalloc>
    8000124a:	0005061b          	sext.w	a2,a0
    8000124e:	fa69                	bnez	a2,80001220 <growproc+0x26>
      return -1;
    80001250:	557d                	li	a0,-1
    80001252:	bfe1                	j	8000122a <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001254:	9e25                	addw	a2,a2,s1
    80001256:	1602                	slli	a2,a2,0x20
    80001258:	9201                	srli	a2,a2,0x20
    8000125a:	1582                	slli	a1,a1,0x20
    8000125c:	9181                	srli	a1,a1,0x20
    8000125e:	6928                	ld	a0,80(a0)
    80001260:	fffff097          	auipc	ra,0xfffff
    80001264:	66e080e7          	jalr	1646(ra) # 800008ce <uvmdealloc>
    80001268:	0005061b          	sext.w	a2,a0
    8000126c:	bf55                	j	80001220 <growproc+0x26>

000000008000126e <fork>:
{
    8000126e:	7179                	addi	sp,sp,-48
    80001270:	f406                	sd	ra,40(sp)
    80001272:	f022                	sd	s0,32(sp)
    80001274:	ec26                	sd	s1,24(sp)
    80001276:	e84a                	sd	s2,16(sp)
    80001278:	e44e                	sd	s3,8(sp)
    8000127a:	e052                	sd	s4,0(sp)
    8000127c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000127e:	00000097          	auipc	ra,0x0
    80001282:	c22080e7          	jalr	-990(ra) # 80000ea0 <myproc>
    80001286:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001288:	00000097          	auipc	ra,0x0
    8000128c:	e22080e7          	jalr	-478(ra) # 800010aa <allocproc>
    80001290:	10050b63          	beqz	a0,800013a6 <fork+0x138>
    80001294:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001296:	04893603          	ld	a2,72(s2)
    8000129a:	692c                	ld	a1,80(a0)
    8000129c:	05093503          	ld	a0,80(s2)
    800012a0:	fffff097          	auipc	ra,0xfffff
    800012a4:	7c2080e7          	jalr	1986(ra) # 80000a62 <uvmcopy>
    800012a8:	04054663          	bltz	a0,800012f4 <fork+0x86>
  np->sz = p->sz;
    800012ac:	04893783          	ld	a5,72(s2)
    800012b0:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012b4:	05893683          	ld	a3,88(s2)
    800012b8:	87b6                	mv	a5,a3
    800012ba:	0589b703          	ld	a4,88(s3)
    800012be:	12068693          	addi	a3,a3,288
    800012c2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012c6:	6788                	ld	a0,8(a5)
    800012c8:	6b8c                	ld	a1,16(a5)
    800012ca:	6f90                	ld	a2,24(a5)
    800012cc:	01073023          	sd	a6,0(a4)
    800012d0:	e708                	sd	a0,8(a4)
    800012d2:	eb0c                	sd	a1,16(a4)
    800012d4:	ef10                	sd	a2,24(a4)
    800012d6:	02078793          	addi	a5,a5,32
    800012da:	02070713          	addi	a4,a4,32
    800012de:	fed792e3          	bne	a5,a3,800012c2 <fork+0x54>
  np->trapframe->a0 = 0;
    800012e2:	0589b783          	ld	a5,88(s3)
    800012e6:	0607b823          	sd	zero,112(a5)
    800012ea:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012ee:	15000a13          	li	s4,336
    800012f2:	a03d                	j	80001320 <fork+0xb2>
    freeproc(np);
    800012f4:	854e                	mv	a0,s3
    800012f6:	00000097          	auipc	ra,0x0
    800012fa:	d5c080e7          	jalr	-676(ra) # 80001052 <freeproc>
    release(&np->lock);
    800012fe:	854e                	mv	a0,s3
    80001300:	00006097          	auipc	ra,0x6
    80001304:	ef2080e7          	jalr	-270(ra) # 800071f2 <release>
    return -1;
    80001308:	5a7d                	li	s4,-1
    8000130a:	a069                	j	80001394 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    8000130c:	00002097          	auipc	ra,0x2
    80001310:	62e080e7          	jalr	1582(ra) # 8000393a <filedup>
    80001314:	009987b3          	add	a5,s3,s1
    80001318:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000131a:	04a1                	addi	s1,s1,8
    8000131c:	01448763          	beq	s1,s4,8000132a <fork+0xbc>
    if(p->ofile[i])
    80001320:	009907b3          	add	a5,s2,s1
    80001324:	6388                	ld	a0,0(a5)
    80001326:	f17d                	bnez	a0,8000130c <fork+0x9e>
    80001328:	bfcd                	j	8000131a <fork+0xac>
  np->cwd = idup(p->cwd);
    8000132a:	15093503          	ld	a0,336(s2)
    8000132e:	00001097          	auipc	ra,0x1
    80001332:	782080e7          	jalr	1922(ra) # 80002ab0 <idup>
    80001336:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000133a:	4641                	li	a2,16
    8000133c:	15890593          	addi	a1,s2,344
    80001340:	15898513          	addi	a0,s3,344
    80001344:	fffff097          	auipc	ra,0xfffff
    80001348:	f86080e7          	jalr	-122(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    8000134c:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001350:	854e                	mv	a0,s3
    80001352:	00006097          	auipc	ra,0x6
    80001356:	ea0080e7          	jalr	-352(ra) # 800071f2 <release>
  acquire(&wait_lock);
    8000135a:	00009497          	auipc	s1,0x9
    8000135e:	d2e48493          	addi	s1,s1,-722 # 8000a088 <wait_lock>
    80001362:	8526                	mv	a0,s1
    80001364:	00006097          	auipc	ra,0x6
    80001368:	dda080e7          	jalr	-550(ra) # 8000713e <acquire>
  np->parent = p;
    8000136c:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001370:	8526                	mv	a0,s1
    80001372:	00006097          	auipc	ra,0x6
    80001376:	e80080e7          	jalr	-384(ra) # 800071f2 <release>
  acquire(&np->lock);
    8000137a:	854e                	mv	a0,s3
    8000137c:	00006097          	auipc	ra,0x6
    80001380:	dc2080e7          	jalr	-574(ra) # 8000713e <acquire>
  np->state = RUNNABLE;
    80001384:	478d                	li	a5,3
    80001386:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000138a:	854e                	mv	a0,s3
    8000138c:	00006097          	auipc	ra,0x6
    80001390:	e66080e7          	jalr	-410(ra) # 800071f2 <release>
}
    80001394:	8552                	mv	a0,s4
    80001396:	70a2                	ld	ra,40(sp)
    80001398:	7402                	ld	s0,32(sp)
    8000139a:	64e2                	ld	s1,24(sp)
    8000139c:	6942                	ld	s2,16(sp)
    8000139e:	69a2                	ld	s3,8(sp)
    800013a0:	6a02                	ld	s4,0(sp)
    800013a2:	6145                	addi	sp,sp,48
    800013a4:	8082                	ret
    return -1;
    800013a6:	5a7d                	li	s4,-1
    800013a8:	b7f5                	j	80001394 <fork+0x126>

00000000800013aa <scheduler>:
{
    800013aa:	7139                	addi	sp,sp,-64
    800013ac:	fc06                	sd	ra,56(sp)
    800013ae:	f822                	sd	s0,48(sp)
    800013b0:	f426                	sd	s1,40(sp)
    800013b2:	f04a                	sd	s2,32(sp)
    800013b4:	ec4e                	sd	s3,24(sp)
    800013b6:	e852                	sd	s4,16(sp)
    800013b8:	e456                	sd	s5,8(sp)
    800013ba:	e05a                	sd	s6,0(sp)
    800013bc:	0080                	addi	s0,sp,64
    800013be:	8792                	mv	a5,tp
  int id = r_tp();
    800013c0:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013c2:	00779a93          	slli	s5,a5,0x7
    800013c6:	00009717          	auipc	a4,0x9
    800013ca:	caa70713          	addi	a4,a4,-854 # 8000a070 <pid_lock>
    800013ce:	9756                	add	a4,a4,s5
    800013d0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013d4:	00009717          	auipc	a4,0x9
    800013d8:	cd470713          	addi	a4,a4,-812 # 8000a0a8 <cpus+0x8>
    800013dc:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013de:	498d                	li	s3,3
        p->state = RUNNING;
    800013e0:	4b11                	li	s6,4
        c->proc = p;
    800013e2:	079e                	slli	a5,a5,0x7
    800013e4:	00009a17          	auipc	s4,0x9
    800013e8:	c8ca0a13          	addi	s4,s4,-884 # 8000a070 <pid_lock>
    800013ec:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ee:	0000f917          	auipc	s2,0xf
    800013f2:	ab290913          	addi	s2,s2,-1358 # 8000fea0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013fa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013fe:	10079073          	csrw	sstatus,a5
    80001402:	00009497          	auipc	s1,0x9
    80001406:	09e48493          	addi	s1,s1,158 # 8000a4a0 <proc>
    8000140a:	a03d                	j	80001438 <scheduler+0x8e>
        p->state = RUNNING;
    8000140c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001410:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001414:	06048593          	addi	a1,s1,96
    80001418:	8556                	mv	a0,s5
    8000141a:	00000097          	auipc	ra,0x0
    8000141e:	640080e7          	jalr	1600(ra) # 80001a5a <swtch>
        c->proc = 0;
    80001422:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001426:	8526                	mv	a0,s1
    80001428:	00006097          	auipc	ra,0x6
    8000142c:	dca080e7          	jalr	-566(ra) # 800071f2 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001430:	16848493          	addi	s1,s1,360
    80001434:	fd2481e3          	beq	s1,s2,800013f6 <scheduler+0x4c>
      acquire(&p->lock);
    80001438:	8526                	mv	a0,s1
    8000143a:	00006097          	auipc	ra,0x6
    8000143e:	d04080e7          	jalr	-764(ra) # 8000713e <acquire>
      if(p->state == RUNNABLE) {
    80001442:	4c9c                	lw	a5,24(s1)
    80001444:	ff3791e3          	bne	a5,s3,80001426 <scheduler+0x7c>
    80001448:	b7d1                	j	8000140c <scheduler+0x62>

000000008000144a <sched>:
{
    8000144a:	7179                	addi	sp,sp,-48
    8000144c:	f406                	sd	ra,40(sp)
    8000144e:	f022                	sd	s0,32(sp)
    80001450:	ec26                	sd	s1,24(sp)
    80001452:	e84a                	sd	s2,16(sp)
    80001454:	e44e                	sd	s3,8(sp)
    80001456:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001458:	00000097          	auipc	ra,0x0
    8000145c:	a48080e7          	jalr	-1464(ra) # 80000ea0 <myproc>
    80001460:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001462:	00006097          	auipc	ra,0x6
    80001466:	c62080e7          	jalr	-926(ra) # 800070c4 <holding>
    8000146a:	c93d                	beqz	a0,800014e0 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000146c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000146e:	2781                	sext.w	a5,a5
    80001470:	079e                	slli	a5,a5,0x7
    80001472:	00009717          	auipc	a4,0x9
    80001476:	bfe70713          	addi	a4,a4,-1026 # 8000a070 <pid_lock>
    8000147a:	97ba                	add	a5,a5,a4
    8000147c:	0a87a703          	lw	a4,168(a5)
    80001480:	4785                	li	a5,1
    80001482:	06f71763          	bne	a4,a5,800014f0 <sched+0xa6>
  if(p->state == RUNNING)
    80001486:	4c98                	lw	a4,24(s1)
    80001488:	4791                	li	a5,4
    8000148a:	06f70b63          	beq	a4,a5,80001500 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000148e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001492:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001494:	efb5                	bnez	a5,80001510 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001496:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001498:	00009917          	auipc	s2,0x9
    8000149c:	bd890913          	addi	s2,s2,-1064 # 8000a070 <pid_lock>
    800014a0:	2781                	sext.w	a5,a5
    800014a2:	079e                	slli	a5,a5,0x7
    800014a4:	97ca                	add	a5,a5,s2
    800014a6:	0ac7a983          	lw	s3,172(a5)
    800014aa:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014ac:	2781                	sext.w	a5,a5
    800014ae:	079e                	slli	a5,a5,0x7
    800014b0:	00009597          	auipc	a1,0x9
    800014b4:	bf858593          	addi	a1,a1,-1032 # 8000a0a8 <cpus+0x8>
    800014b8:	95be                	add	a1,a1,a5
    800014ba:	06048513          	addi	a0,s1,96
    800014be:	00000097          	auipc	ra,0x0
    800014c2:	59c080e7          	jalr	1436(ra) # 80001a5a <swtch>
    800014c6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c8:	2781                	sext.w	a5,a5
    800014ca:	079e                	slli	a5,a5,0x7
    800014cc:	97ca                	add	a5,a5,s2
    800014ce:	0b37a623          	sw	s3,172(a5)
}
    800014d2:	70a2                	ld	ra,40(sp)
    800014d4:	7402                	ld	s0,32(sp)
    800014d6:	64e2                	ld	s1,24(sp)
    800014d8:	6942                	ld	s2,16(sp)
    800014da:	69a2                	ld	s3,8(sp)
    800014dc:	6145                	addi	sp,sp,48
    800014de:	8082                	ret
    panic("sched p->lock");
    800014e0:	00008517          	auipc	a0,0x8
    800014e4:	cc850513          	addi	a0,a0,-824 # 800091a8 <etext+0x1a8>
    800014e8:	00005097          	auipc	ra,0x5
    800014ec:	70c080e7          	jalr	1804(ra) # 80006bf4 <panic>
    panic("sched locks");
    800014f0:	00008517          	auipc	a0,0x8
    800014f4:	cc850513          	addi	a0,a0,-824 # 800091b8 <etext+0x1b8>
    800014f8:	00005097          	auipc	ra,0x5
    800014fc:	6fc080e7          	jalr	1788(ra) # 80006bf4 <panic>
    panic("sched running");
    80001500:	00008517          	auipc	a0,0x8
    80001504:	cc850513          	addi	a0,a0,-824 # 800091c8 <etext+0x1c8>
    80001508:	00005097          	auipc	ra,0x5
    8000150c:	6ec080e7          	jalr	1772(ra) # 80006bf4 <panic>
    panic("sched interruptible");
    80001510:	00008517          	auipc	a0,0x8
    80001514:	cc850513          	addi	a0,a0,-824 # 800091d8 <etext+0x1d8>
    80001518:	00005097          	auipc	ra,0x5
    8000151c:	6dc080e7          	jalr	1756(ra) # 80006bf4 <panic>

0000000080001520 <yield>:
{
    80001520:	1101                	addi	sp,sp,-32
    80001522:	ec06                	sd	ra,24(sp)
    80001524:	e822                	sd	s0,16(sp)
    80001526:	e426                	sd	s1,8(sp)
    80001528:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000152a:	00000097          	auipc	ra,0x0
    8000152e:	976080e7          	jalr	-1674(ra) # 80000ea0 <myproc>
    80001532:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001534:	00006097          	auipc	ra,0x6
    80001538:	c0a080e7          	jalr	-1014(ra) # 8000713e <acquire>
  p->state = RUNNABLE;
    8000153c:	478d                	li	a5,3
    8000153e:	cc9c                	sw	a5,24(s1)
  sched();
    80001540:	00000097          	auipc	ra,0x0
    80001544:	f0a080e7          	jalr	-246(ra) # 8000144a <sched>
  release(&p->lock);
    80001548:	8526                	mv	a0,s1
    8000154a:	00006097          	auipc	ra,0x6
    8000154e:	ca8080e7          	jalr	-856(ra) # 800071f2 <release>
}
    80001552:	60e2                	ld	ra,24(sp)
    80001554:	6442                	ld	s0,16(sp)
    80001556:	64a2                	ld	s1,8(sp)
    80001558:	6105                	addi	sp,sp,32
    8000155a:	8082                	ret

000000008000155c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000155c:	7179                	addi	sp,sp,-48
    8000155e:	f406                	sd	ra,40(sp)
    80001560:	f022                	sd	s0,32(sp)
    80001562:	ec26                	sd	s1,24(sp)
    80001564:	e84a                	sd	s2,16(sp)
    80001566:	e44e                	sd	s3,8(sp)
    80001568:	1800                	addi	s0,sp,48
    8000156a:	89aa                	mv	s3,a0
    8000156c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000156e:	00000097          	auipc	ra,0x0
    80001572:	932080e7          	jalr	-1742(ra) # 80000ea0 <myproc>
    80001576:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001578:	00006097          	auipc	ra,0x6
    8000157c:	bc6080e7          	jalr	-1082(ra) # 8000713e <acquire>
  release(lk);
    80001580:	854a                	mv	a0,s2
    80001582:	00006097          	auipc	ra,0x6
    80001586:	c70080e7          	jalr	-912(ra) # 800071f2 <release>

  // Go to sleep.
  p->chan = chan;
    8000158a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000158e:	4789                	li	a5,2
    80001590:	cc9c                	sw	a5,24(s1)

  sched();
    80001592:	00000097          	auipc	ra,0x0
    80001596:	eb8080e7          	jalr	-328(ra) # 8000144a <sched>

  // Tidy up.
  p->chan = 0;
    8000159a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000159e:	8526                	mv	a0,s1
    800015a0:	00006097          	auipc	ra,0x6
    800015a4:	c52080e7          	jalr	-942(ra) # 800071f2 <release>
  acquire(lk);
    800015a8:	854a                	mv	a0,s2
    800015aa:	00006097          	auipc	ra,0x6
    800015ae:	b94080e7          	jalr	-1132(ra) # 8000713e <acquire>
}
    800015b2:	70a2                	ld	ra,40(sp)
    800015b4:	7402                	ld	s0,32(sp)
    800015b6:	64e2                	ld	s1,24(sp)
    800015b8:	6942                	ld	s2,16(sp)
    800015ba:	69a2                	ld	s3,8(sp)
    800015bc:	6145                	addi	sp,sp,48
    800015be:	8082                	ret

00000000800015c0 <wait>:
{
    800015c0:	715d                	addi	sp,sp,-80
    800015c2:	e486                	sd	ra,72(sp)
    800015c4:	e0a2                	sd	s0,64(sp)
    800015c6:	fc26                	sd	s1,56(sp)
    800015c8:	f84a                	sd	s2,48(sp)
    800015ca:	f44e                	sd	s3,40(sp)
    800015cc:	f052                	sd	s4,32(sp)
    800015ce:	ec56                	sd	s5,24(sp)
    800015d0:	e85a                	sd	s6,16(sp)
    800015d2:	e45e                	sd	s7,8(sp)
    800015d4:	e062                	sd	s8,0(sp)
    800015d6:	0880                	addi	s0,sp,80
    800015d8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015da:	00000097          	auipc	ra,0x0
    800015de:	8c6080e7          	jalr	-1850(ra) # 80000ea0 <myproc>
    800015e2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015e4:	00009517          	auipc	a0,0x9
    800015e8:	aa450513          	addi	a0,a0,-1372 # 8000a088 <wait_lock>
    800015ec:	00006097          	auipc	ra,0x6
    800015f0:	b52080e7          	jalr	-1198(ra) # 8000713e <acquire>
    havekids = 0;
    800015f4:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015f6:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015f8:	0000f997          	auipc	s3,0xf
    800015fc:	8a898993          	addi	s3,s3,-1880 # 8000fea0 <tickslock>
        havekids = 1;
    80001600:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001602:	00009c17          	auipc	s8,0x9
    80001606:	a86c0c13          	addi	s8,s8,-1402 # 8000a088 <wait_lock>
    havekids = 0;
    8000160a:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000160c:	00009497          	auipc	s1,0x9
    80001610:	e9448493          	addi	s1,s1,-364 # 8000a4a0 <proc>
    80001614:	a0bd                	j	80001682 <wait+0xc2>
          pid = np->pid;
    80001616:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000161a:	000b0e63          	beqz	s6,80001636 <wait+0x76>
    8000161e:	4691                	li	a3,4
    80001620:	02c48613          	addi	a2,s1,44
    80001624:	85da                	mv	a1,s6
    80001626:	05093503          	ld	a0,80(s2)
    8000162a:	fffff097          	auipc	ra,0xfffff
    8000162e:	53c080e7          	jalr	1340(ra) # 80000b66 <copyout>
    80001632:	02054563          	bltz	a0,8000165c <wait+0x9c>
          freeproc(np);
    80001636:	8526                	mv	a0,s1
    80001638:	00000097          	auipc	ra,0x0
    8000163c:	a1a080e7          	jalr	-1510(ra) # 80001052 <freeproc>
          release(&np->lock);
    80001640:	8526                	mv	a0,s1
    80001642:	00006097          	auipc	ra,0x6
    80001646:	bb0080e7          	jalr	-1104(ra) # 800071f2 <release>
          release(&wait_lock);
    8000164a:	00009517          	auipc	a0,0x9
    8000164e:	a3e50513          	addi	a0,a0,-1474 # 8000a088 <wait_lock>
    80001652:	00006097          	auipc	ra,0x6
    80001656:	ba0080e7          	jalr	-1120(ra) # 800071f2 <release>
          return pid;
    8000165a:	a09d                	j	800016c0 <wait+0x100>
            release(&np->lock);
    8000165c:	8526                	mv	a0,s1
    8000165e:	00006097          	auipc	ra,0x6
    80001662:	b94080e7          	jalr	-1132(ra) # 800071f2 <release>
            release(&wait_lock);
    80001666:	00009517          	auipc	a0,0x9
    8000166a:	a2250513          	addi	a0,a0,-1502 # 8000a088 <wait_lock>
    8000166e:	00006097          	auipc	ra,0x6
    80001672:	b84080e7          	jalr	-1148(ra) # 800071f2 <release>
            return -1;
    80001676:	59fd                	li	s3,-1
    80001678:	a0a1                	j	800016c0 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000167a:	16848493          	addi	s1,s1,360
    8000167e:	03348463          	beq	s1,s3,800016a6 <wait+0xe6>
      if(np->parent == p){
    80001682:	7c9c                	ld	a5,56(s1)
    80001684:	ff279be3          	bne	a5,s2,8000167a <wait+0xba>
        acquire(&np->lock);
    80001688:	8526                	mv	a0,s1
    8000168a:	00006097          	auipc	ra,0x6
    8000168e:	ab4080e7          	jalr	-1356(ra) # 8000713e <acquire>
        if(np->state == ZOMBIE){
    80001692:	4c9c                	lw	a5,24(s1)
    80001694:	f94781e3          	beq	a5,s4,80001616 <wait+0x56>
        release(&np->lock);
    80001698:	8526                	mv	a0,s1
    8000169a:	00006097          	auipc	ra,0x6
    8000169e:	b58080e7          	jalr	-1192(ra) # 800071f2 <release>
        havekids = 1;
    800016a2:	8756                	mv	a4,s5
    800016a4:	bfd9                	j	8000167a <wait+0xba>
    if(!havekids || p->killed){
    800016a6:	c701                	beqz	a4,800016ae <wait+0xee>
    800016a8:	02892783          	lw	a5,40(s2)
    800016ac:	c79d                	beqz	a5,800016da <wait+0x11a>
      release(&wait_lock);
    800016ae:	00009517          	auipc	a0,0x9
    800016b2:	9da50513          	addi	a0,a0,-1574 # 8000a088 <wait_lock>
    800016b6:	00006097          	auipc	ra,0x6
    800016ba:	b3c080e7          	jalr	-1220(ra) # 800071f2 <release>
      return -1;
    800016be:	59fd                	li	s3,-1
}
    800016c0:	854e                	mv	a0,s3
    800016c2:	60a6                	ld	ra,72(sp)
    800016c4:	6406                	ld	s0,64(sp)
    800016c6:	74e2                	ld	s1,56(sp)
    800016c8:	7942                	ld	s2,48(sp)
    800016ca:	79a2                	ld	s3,40(sp)
    800016cc:	7a02                	ld	s4,32(sp)
    800016ce:	6ae2                	ld	s5,24(sp)
    800016d0:	6b42                	ld	s6,16(sp)
    800016d2:	6ba2                	ld	s7,8(sp)
    800016d4:	6c02                	ld	s8,0(sp)
    800016d6:	6161                	addi	sp,sp,80
    800016d8:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016da:	85e2                	mv	a1,s8
    800016dc:	854a                	mv	a0,s2
    800016de:	00000097          	auipc	ra,0x0
    800016e2:	e7e080e7          	jalr	-386(ra) # 8000155c <sleep>
    havekids = 0;
    800016e6:	b715                	j	8000160a <wait+0x4a>

00000000800016e8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016e8:	7139                	addi	sp,sp,-64
    800016ea:	fc06                	sd	ra,56(sp)
    800016ec:	f822                	sd	s0,48(sp)
    800016ee:	f426                	sd	s1,40(sp)
    800016f0:	f04a                	sd	s2,32(sp)
    800016f2:	ec4e                	sd	s3,24(sp)
    800016f4:	e852                	sd	s4,16(sp)
    800016f6:	e456                	sd	s5,8(sp)
    800016f8:	0080                	addi	s0,sp,64
    800016fa:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016fc:	00009497          	auipc	s1,0x9
    80001700:	da448493          	addi	s1,s1,-604 # 8000a4a0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001704:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001706:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001708:	0000e917          	auipc	s2,0xe
    8000170c:	79890913          	addi	s2,s2,1944 # 8000fea0 <tickslock>
    80001710:	a821                	j	80001728 <wakeup+0x40>
        p->state = RUNNABLE;
    80001712:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001716:	8526                	mv	a0,s1
    80001718:	00006097          	auipc	ra,0x6
    8000171c:	ada080e7          	jalr	-1318(ra) # 800071f2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001720:	16848493          	addi	s1,s1,360
    80001724:	03248463          	beq	s1,s2,8000174c <wakeup+0x64>
    if(p != myproc()){
    80001728:	fffff097          	auipc	ra,0xfffff
    8000172c:	778080e7          	jalr	1912(ra) # 80000ea0 <myproc>
    80001730:	fea488e3          	beq	s1,a0,80001720 <wakeup+0x38>
      acquire(&p->lock);
    80001734:	8526                	mv	a0,s1
    80001736:	00006097          	auipc	ra,0x6
    8000173a:	a08080e7          	jalr	-1528(ra) # 8000713e <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000173e:	4c9c                	lw	a5,24(s1)
    80001740:	fd379be3          	bne	a5,s3,80001716 <wakeup+0x2e>
    80001744:	709c                	ld	a5,32(s1)
    80001746:	fd4798e3          	bne	a5,s4,80001716 <wakeup+0x2e>
    8000174a:	b7e1                	j	80001712 <wakeup+0x2a>
    }
  }
}
    8000174c:	70e2                	ld	ra,56(sp)
    8000174e:	7442                	ld	s0,48(sp)
    80001750:	74a2                	ld	s1,40(sp)
    80001752:	7902                	ld	s2,32(sp)
    80001754:	69e2                	ld	s3,24(sp)
    80001756:	6a42                	ld	s4,16(sp)
    80001758:	6aa2                	ld	s5,8(sp)
    8000175a:	6121                	addi	sp,sp,64
    8000175c:	8082                	ret

000000008000175e <reparent>:
{
    8000175e:	7179                	addi	sp,sp,-48
    80001760:	f406                	sd	ra,40(sp)
    80001762:	f022                	sd	s0,32(sp)
    80001764:	ec26                	sd	s1,24(sp)
    80001766:	e84a                	sd	s2,16(sp)
    80001768:	e44e                	sd	s3,8(sp)
    8000176a:	e052                	sd	s4,0(sp)
    8000176c:	1800                	addi	s0,sp,48
    8000176e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001770:	00009497          	auipc	s1,0x9
    80001774:	d3048493          	addi	s1,s1,-720 # 8000a4a0 <proc>
      pp->parent = initproc;
    80001778:	00009a17          	auipc	s4,0x9
    8000177c:	898a0a13          	addi	s4,s4,-1896 # 8000a010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001780:	0000e997          	auipc	s3,0xe
    80001784:	72098993          	addi	s3,s3,1824 # 8000fea0 <tickslock>
    80001788:	a029                	j	80001792 <reparent+0x34>
    8000178a:	16848493          	addi	s1,s1,360
    8000178e:	01348d63          	beq	s1,s3,800017a8 <reparent+0x4a>
    if(pp->parent == p){
    80001792:	7c9c                	ld	a5,56(s1)
    80001794:	ff279be3          	bne	a5,s2,8000178a <reparent+0x2c>
      pp->parent = initproc;
    80001798:	000a3503          	ld	a0,0(s4)
    8000179c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000179e:	00000097          	auipc	ra,0x0
    800017a2:	f4a080e7          	jalr	-182(ra) # 800016e8 <wakeup>
    800017a6:	b7d5                	j	8000178a <reparent+0x2c>
}
    800017a8:	70a2                	ld	ra,40(sp)
    800017aa:	7402                	ld	s0,32(sp)
    800017ac:	64e2                	ld	s1,24(sp)
    800017ae:	6942                	ld	s2,16(sp)
    800017b0:	69a2                	ld	s3,8(sp)
    800017b2:	6a02                	ld	s4,0(sp)
    800017b4:	6145                	addi	sp,sp,48
    800017b6:	8082                	ret

00000000800017b8 <exit>:
{
    800017b8:	7179                	addi	sp,sp,-48
    800017ba:	f406                	sd	ra,40(sp)
    800017bc:	f022                	sd	s0,32(sp)
    800017be:	ec26                	sd	s1,24(sp)
    800017c0:	e84a                	sd	s2,16(sp)
    800017c2:	e44e                	sd	s3,8(sp)
    800017c4:	e052                	sd	s4,0(sp)
    800017c6:	1800                	addi	s0,sp,48
    800017c8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017ca:	fffff097          	auipc	ra,0xfffff
    800017ce:	6d6080e7          	jalr	1750(ra) # 80000ea0 <myproc>
    800017d2:	89aa                	mv	s3,a0
  if(p == initproc)
    800017d4:	00009797          	auipc	a5,0x9
    800017d8:	83c7b783          	ld	a5,-1988(a5) # 8000a010 <initproc>
    800017dc:	0d050493          	addi	s1,a0,208
    800017e0:	15050913          	addi	s2,a0,336
    800017e4:	02a79363          	bne	a5,a0,8000180a <exit+0x52>
    panic("init exiting");
    800017e8:	00008517          	auipc	a0,0x8
    800017ec:	a0850513          	addi	a0,a0,-1528 # 800091f0 <etext+0x1f0>
    800017f0:	00005097          	auipc	ra,0x5
    800017f4:	404080e7          	jalr	1028(ra) # 80006bf4 <panic>
      fileclose(f);
    800017f8:	00002097          	auipc	ra,0x2
    800017fc:	194080e7          	jalr	404(ra) # 8000398c <fileclose>
      p->ofile[fd] = 0;
    80001800:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001804:	04a1                	addi	s1,s1,8
    80001806:	01248563          	beq	s1,s2,80001810 <exit+0x58>
    if(p->ofile[fd]){
    8000180a:	6088                	ld	a0,0(s1)
    8000180c:	f575                	bnez	a0,800017f8 <exit+0x40>
    8000180e:	bfdd                	j	80001804 <exit+0x4c>
  begin_op();
    80001810:	00002097          	auipc	ra,0x2
    80001814:	cb0080e7          	jalr	-848(ra) # 800034c0 <begin_op>
  iput(p->cwd);
    80001818:	1509b503          	ld	a0,336(s3)
    8000181c:	00001097          	auipc	ra,0x1
    80001820:	48c080e7          	jalr	1164(ra) # 80002ca8 <iput>
  end_op();
    80001824:	00002097          	auipc	ra,0x2
    80001828:	d1c080e7          	jalr	-740(ra) # 80003540 <end_op>
  p->cwd = 0;
    8000182c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001830:	00009497          	auipc	s1,0x9
    80001834:	85848493          	addi	s1,s1,-1960 # 8000a088 <wait_lock>
    80001838:	8526                	mv	a0,s1
    8000183a:	00006097          	auipc	ra,0x6
    8000183e:	904080e7          	jalr	-1788(ra) # 8000713e <acquire>
  reparent(p);
    80001842:	854e                	mv	a0,s3
    80001844:	00000097          	auipc	ra,0x0
    80001848:	f1a080e7          	jalr	-230(ra) # 8000175e <reparent>
  wakeup(p->parent);
    8000184c:	0389b503          	ld	a0,56(s3)
    80001850:	00000097          	auipc	ra,0x0
    80001854:	e98080e7          	jalr	-360(ra) # 800016e8 <wakeup>
  acquire(&p->lock);
    80001858:	854e                	mv	a0,s3
    8000185a:	00006097          	auipc	ra,0x6
    8000185e:	8e4080e7          	jalr	-1820(ra) # 8000713e <acquire>
  p->xstate = status;
    80001862:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001866:	4795                	li	a5,5
    80001868:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000186c:	8526                	mv	a0,s1
    8000186e:	00006097          	auipc	ra,0x6
    80001872:	984080e7          	jalr	-1660(ra) # 800071f2 <release>
  sched();
    80001876:	00000097          	auipc	ra,0x0
    8000187a:	bd4080e7          	jalr	-1068(ra) # 8000144a <sched>
  panic("zombie exit");
    8000187e:	00008517          	auipc	a0,0x8
    80001882:	98250513          	addi	a0,a0,-1662 # 80009200 <etext+0x200>
    80001886:	00005097          	auipc	ra,0x5
    8000188a:	36e080e7          	jalr	878(ra) # 80006bf4 <panic>

000000008000188e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000188e:	7179                	addi	sp,sp,-48
    80001890:	f406                	sd	ra,40(sp)
    80001892:	f022                	sd	s0,32(sp)
    80001894:	ec26                	sd	s1,24(sp)
    80001896:	e84a                	sd	s2,16(sp)
    80001898:	e44e                	sd	s3,8(sp)
    8000189a:	1800                	addi	s0,sp,48
    8000189c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000189e:	00009497          	auipc	s1,0x9
    800018a2:	c0248493          	addi	s1,s1,-1022 # 8000a4a0 <proc>
    800018a6:	0000e997          	auipc	s3,0xe
    800018aa:	5fa98993          	addi	s3,s3,1530 # 8000fea0 <tickslock>
    acquire(&p->lock);
    800018ae:	8526                	mv	a0,s1
    800018b0:	00006097          	auipc	ra,0x6
    800018b4:	88e080e7          	jalr	-1906(ra) # 8000713e <acquire>
    if(p->pid == pid){
    800018b8:	589c                	lw	a5,48(s1)
    800018ba:	01278d63          	beq	a5,s2,800018d4 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018be:	8526                	mv	a0,s1
    800018c0:	00006097          	auipc	ra,0x6
    800018c4:	932080e7          	jalr	-1742(ra) # 800071f2 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018c8:	16848493          	addi	s1,s1,360
    800018cc:	ff3491e3          	bne	s1,s3,800018ae <kill+0x20>
  }
  return -1;
    800018d0:	557d                	li	a0,-1
    800018d2:	a829                	j	800018ec <kill+0x5e>
      p->killed = 1;
    800018d4:	4785                	li	a5,1
    800018d6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018d8:	4c98                	lw	a4,24(s1)
    800018da:	4789                	li	a5,2
    800018dc:	00f70f63          	beq	a4,a5,800018fa <kill+0x6c>
      release(&p->lock);
    800018e0:	8526                	mv	a0,s1
    800018e2:	00006097          	auipc	ra,0x6
    800018e6:	910080e7          	jalr	-1776(ra) # 800071f2 <release>
      return 0;
    800018ea:	4501                	li	a0,0
}
    800018ec:	70a2                	ld	ra,40(sp)
    800018ee:	7402                	ld	s0,32(sp)
    800018f0:	64e2                	ld	s1,24(sp)
    800018f2:	6942                	ld	s2,16(sp)
    800018f4:	69a2                	ld	s3,8(sp)
    800018f6:	6145                	addi	sp,sp,48
    800018f8:	8082                	ret
        p->state = RUNNABLE;
    800018fa:	478d                	li	a5,3
    800018fc:	cc9c                	sw	a5,24(s1)
    800018fe:	b7cd                	j	800018e0 <kill+0x52>

0000000080001900 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001900:	7179                	addi	sp,sp,-48
    80001902:	f406                	sd	ra,40(sp)
    80001904:	f022                	sd	s0,32(sp)
    80001906:	ec26                	sd	s1,24(sp)
    80001908:	e84a                	sd	s2,16(sp)
    8000190a:	e44e                	sd	s3,8(sp)
    8000190c:	e052                	sd	s4,0(sp)
    8000190e:	1800                	addi	s0,sp,48
    80001910:	84aa                	mv	s1,a0
    80001912:	892e                	mv	s2,a1
    80001914:	89b2                	mv	s3,a2
    80001916:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001918:	fffff097          	auipc	ra,0xfffff
    8000191c:	588080e7          	jalr	1416(ra) # 80000ea0 <myproc>
  if(user_dst){
    80001920:	c08d                	beqz	s1,80001942 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001922:	86d2                	mv	a3,s4
    80001924:	864e                	mv	a2,s3
    80001926:	85ca                	mv	a1,s2
    80001928:	6928                	ld	a0,80(a0)
    8000192a:	fffff097          	auipc	ra,0xfffff
    8000192e:	23c080e7          	jalr	572(ra) # 80000b66 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001932:	70a2                	ld	ra,40(sp)
    80001934:	7402                	ld	s0,32(sp)
    80001936:	64e2                	ld	s1,24(sp)
    80001938:	6942                	ld	s2,16(sp)
    8000193a:	69a2                	ld	s3,8(sp)
    8000193c:	6a02                	ld	s4,0(sp)
    8000193e:	6145                	addi	sp,sp,48
    80001940:	8082                	ret
    memmove((char *)dst, src, len);
    80001942:	000a061b          	sext.w	a2,s4
    80001946:	85ce                	mv	a1,s3
    80001948:	854a                	mv	a0,s2
    8000194a:	fffff097          	auipc	ra,0xfffff
    8000194e:	88e080e7          	jalr	-1906(ra) # 800001d8 <memmove>
    return 0;
    80001952:	8526                	mv	a0,s1
    80001954:	bff9                	j	80001932 <either_copyout+0x32>

0000000080001956 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001956:	7179                	addi	sp,sp,-48
    80001958:	f406                	sd	ra,40(sp)
    8000195a:	f022                	sd	s0,32(sp)
    8000195c:	ec26                	sd	s1,24(sp)
    8000195e:	e84a                	sd	s2,16(sp)
    80001960:	e44e                	sd	s3,8(sp)
    80001962:	e052                	sd	s4,0(sp)
    80001964:	1800                	addi	s0,sp,48
    80001966:	892a                	mv	s2,a0
    80001968:	84ae                	mv	s1,a1
    8000196a:	89b2                	mv	s3,a2
    8000196c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000196e:	fffff097          	auipc	ra,0xfffff
    80001972:	532080e7          	jalr	1330(ra) # 80000ea0 <myproc>
  if(user_src){
    80001976:	c08d                	beqz	s1,80001998 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001978:	86d2                	mv	a3,s4
    8000197a:	864e                	mv	a2,s3
    8000197c:	85ca                	mv	a1,s2
    8000197e:	6928                	ld	a0,80(a0)
    80001980:	fffff097          	auipc	ra,0xfffff
    80001984:	272080e7          	jalr	626(ra) # 80000bf2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001988:	70a2                	ld	ra,40(sp)
    8000198a:	7402                	ld	s0,32(sp)
    8000198c:	64e2                	ld	s1,24(sp)
    8000198e:	6942                	ld	s2,16(sp)
    80001990:	69a2                	ld	s3,8(sp)
    80001992:	6a02                	ld	s4,0(sp)
    80001994:	6145                	addi	sp,sp,48
    80001996:	8082                	ret
    memmove(dst, (char*)src, len);
    80001998:	000a061b          	sext.w	a2,s4
    8000199c:	85ce                	mv	a1,s3
    8000199e:	854a                	mv	a0,s2
    800019a0:	fffff097          	auipc	ra,0xfffff
    800019a4:	838080e7          	jalr	-1992(ra) # 800001d8 <memmove>
    return 0;
    800019a8:	8526                	mv	a0,s1
    800019aa:	bff9                	j	80001988 <either_copyin+0x32>

00000000800019ac <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019ac:	715d                	addi	sp,sp,-80
    800019ae:	e486                	sd	ra,72(sp)
    800019b0:	e0a2                	sd	s0,64(sp)
    800019b2:	fc26                	sd	s1,56(sp)
    800019b4:	f84a                	sd	s2,48(sp)
    800019b6:	f44e                	sd	s3,40(sp)
    800019b8:	f052                	sd	s4,32(sp)
    800019ba:	ec56                	sd	s5,24(sp)
    800019bc:	e85a                	sd	s6,16(sp)
    800019be:	e45e                	sd	s7,8(sp)
    800019c0:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019c2:	00007517          	auipc	a0,0x7
    800019c6:	68650513          	addi	a0,a0,1670 # 80009048 <etext+0x48>
    800019ca:	00005097          	auipc	ra,0x5
    800019ce:	274080e7          	jalr	628(ra) # 80006c3e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d2:	00009497          	auipc	s1,0x9
    800019d6:	c2648493          	addi	s1,s1,-986 # 8000a5f8 <proc+0x158>
    800019da:	0000e917          	auipc	s2,0xe
    800019de:	61e90913          	addi	s2,s2,1566 # 8000fff8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e4:	00008997          	auipc	s3,0x8
    800019e8:	82c98993          	addi	s3,s3,-2004 # 80009210 <etext+0x210>
    printf("%d %s %s", p->pid, state, p->name);
    800019ec:	00008a97          	auipc	s5,0x8
    800019f0:	82ca8a93          	addi	s5,s5,-2004 # 80009218 <etext+0x218>
    printf("\n");
    800019f4:	00007a17          	auipc	s4,0x7
    800019f8:	654a0a13          	addi	s4,s4,1620 # 80009048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019fc:	00008b97          	auipc	s7,0x8
    80001a00:	854b8b93          	addi	s7,s7,-1964 # 80009250 <states.1759>
    80001a04:	a00d                	j	80001a26 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a06:	ed86a583          	lw	a1,-296(a3)
    80001a0a:	8556                	mv	a0,s5
    80001a0c:	00005097          	auipc	ra,0x5
    80001a10:	232080e7          	jalr	562(ra) # 80006c3e <printf>
    printf("\n");
    80001a14:	8552                	mv	a0,s4
    80001a16:	00005097          	auipc	ra,0x5
    80001a1a:	228080e7          	jalr	552(ra) # 80006c3e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a1e:	16848493          	addi	s1,s1,360
    80001a22:	03248163          	beq	s1,s2,80001a44 <procdump+0x98>
    if(p->state == UNUSED)
    80001a26:	86a6                	mv	a3,s1
    80001a28:	ec04a783          	lw	a5,-320(s1)
    80001a2c:	dbed                	beqz	a5,80001a1e <procdump+0x72>
      state = "???";
    80001a2e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a30:	fcfb6be3          	bltu	s6,a5,80001a06 <procdump+0x5a>
    80001a34:	1782                	slli	a5,a5,0x20
    80001a36:	9381                	srli	a5,a5,0x20
    80001a38:	078e                	slli	a5,a5,0x3
    80001a3a:	97de                	add	a5,a5,s7
    80001a3c:	6390                	ld	a2,0(a5)
    80001a3e:	f661                	bnez	a2,80001a06 <procdump+0x5a>
      state = "???";
    80001a40:	864e                	mv	a2,s3
    80001a42:	b7d1                	j	80001a06 <procdump+0x5a>
  }
}
    80001a44:	60a6                	ld	ra,72(sp)
    80001a46:	6406                	ld	s0,64(sp)
    80001a48:	74e2                	ld	s1,56(sp)
    80001a4a:	7942                	ld	s2,48(sp)
    80001a4c:	79a2                	ld	s3,40(sp)
    80001a4e:	7a02                	ld	s4,32(sp)
    80001a50:	6ae2                	ld	s5,24(sp)
    80001a52:	6b42                	ld	s6,16(sp)
    80001a54:	6ba2                	ld	s7,8(sp)
    80001a56:	6161                	addi	sp,sp,80
    80001a58:	8082                	ret

0000000080001a5a <swtch>:
    80001a5a:	00153023          	sd	ra,0(a0)
    80001a5e:	00253423          	sd	sp,8(a0)
    80001a62:	e900                	sd	s0,16(a0)
    80001a64:	ed04                	sd	s1,24(a0)
    80001a66:	03253023          	sd	s2,32(a0)
    80001a6a:	03353423          	sd	s3,40(a0)
    80001a6e:	03453823          	sd	s4,48(a0)
    80001a72:	03553c23          	sd	s5,56(a0)
    80001a76:	05653023          	sd	s6,64(a0)
    80001a7a:	05753423          	sd	s7,72(a0)
    80001a7e:	05853823          	sd	s8,80(a0)
    80001a82:	05953c23          	sd	s9,88(a0)
    80001a86:	07a53023          	sd	s10,96(a0)
    80001a8a:	07b53423          	sd	s11,104(a0)
    80001a8e:	0005b083          	ld	ra,0(a1)
    80001a92:	0085b103          	ld	sp,8(a1)
    80001a96:	6980                	ld	s0,16(a1)
    80001a98:	6d84                	ld	s1,24(a1)
    80001a9a:	0205b903          	ld	s2,32(a1)
    80001a9e:	0285b983          	ld	s3,40(a1)
    80001aa2:	0305ba03          	ld	s4,48(a1)
    80001aa6:	0385ba83          	ld	s5,56(a1)
    80001aaa:	0405bb03          	ld	s6,64(a1)
    80001aae:	0485bb83          	ld	s7,72(a1)
    80001ab2:	0505bc03          	ld	s8,80(a1)
    80001ab6:	0585bc83          	ld	s9,88(a1)
    80001aba:	0605bd03          	ld	s10,96(a1)
    80001abe:	0685bd83          	ld	s11,104(a1)
    80001ac2:	8082                	ret

0000000080001ac4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ac4:	1141                	addi	sp,sp,-16
    80001ac6:	e406                	sd	ra,8(sp)
    80001ac8:	e022                	sd	s0,0(sp)
    80001aca:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001acc:	00007597          	auipc	a1,0x7
    80001ad0:	7b458593          	addi	a1,a1,1972 # 80009280 <states.1759+0x30>
    80001ad4:	0000e517          	auipc	a0,0xe
    80001ad8:	3cc50513          	addi	a0,a0,972 # 8000fea0 <tickslock>
    80001adc:	00005097          	auipc	ra,0x5
    80001ae0:	5d2080e7          	jalr	1490(ra) # 800070ae <initlock>
}
    80001ae4:	60a2                	ld	ra,8(sp)
    80001ae6:	6402                	ld	s0,0(sp)
    80001ae8:	0141                	addi	sp,sp,16
    80001aea:	8082                	ret

0000000080001aec <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001aec:	1141                	addi	sp,sp,-16
    80001aee:	e422                	sd	s0,8(sp)
    80001af0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af2:	00003797          	auipc	a5,0x3
    80001af6:	57e78793          	addi	a5,a5,1406 # 80005070 <kernelvec>
    80001afa:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001afe:	6422                	ld	s0,8(sp)
    80001b00:	0141                	addi	sp,sp,16
    80001b02:	8082                	ret

0000000080001b04 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b04:	1141                	addi	sp,sp,-16
    80001b06:	e406                	sd	ra,8(sp)
    80001b08:	e022                	sd	s0,0(sp)
    80001b0a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b0c:	fffff097          	auipc	ra,0xfffff
    80001b10:	394080e7          	jalr	916(ra) # 80000ea0 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b14:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b18:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b1a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b1e:	00006617          	auipc	a2,0x6
    80001b22:	4e260613          	addi	a2,a2,1250 # 80008000 <_trampoline>
    80001b26:	00006697          	auipc	a3,0x6
    80001b2a:	4da68693          	addi	a3,a3,1242 # 80008000 <_trampoline>
    80001b2e:	8e91                	sub	a3,a3,a2
    80001b30:	040007b7          	lui	a5,0x4000
    80001b34:	17fd                	addi	a5,a5,-1
    80001b36:	07b2                	slli	a5,a5,0xc
    80001b38:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b3a:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b3e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b40:	180026f3          	csrr	a3,satp
    80001b44:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b46:	6d38                	ld	a4,88(a0)
    80001b48:	6134                	ld	a3,64(a0)
    80001b4a:	6585                	lui	a1,0x1
    80001b4c:	96ae                	add	a3,a3,a1
    80001b4e:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b50:	6d38                	ld	a4,88(a0)
    80001b52:	00000697          	auipc	a3,0x0
    80001b56:	14a68693          	addi	a3,a3,330 # 80001c9c <usertrap>
    80001b5a:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b5c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b5e:	8692                	mv	a3,tp
    80001b60:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b62:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b66:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b6a:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b6e:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b72:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b74:	6f18                	ld	a4,24(a4)
    80001b76:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b7a:	692c                	ld	a1,80(a0)
    80001b7c:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b7e:	00006717          	auipc	a4,0x6
    80001b82:	51270713          	addi	a4,a4,1298 # 80008090 <userret>
    80001b86:	8f11                	sub	a4,a4,a2
    80001b88:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b8a:	577d                	li	a4,-1
    80001b8c:	177e                	slli	a4,a4,0x3f
    80001b8e:	8dd9                	or	a1,a1,a4
    80001b90:	02000537          	lui	a0,0x2000
    80001b94:	157d                	addi	a0,a0,-1
    80001b96:	0536                	slli	a0,a0,0xd
    80001b98:	9782                	jalr	a5
}
    80001b9a:	60a2                	ld	ra,8(sp)
    80001b9c:	6402                	ld	s0,0(sp)
    80001b9e:	0141                	addi	sp,sp,16
    80001ba0:	8082                	ret

0000000080001ba2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001ba2:	1101                	addi	sp,sp,-32
    80001ba4:	ec06                	sd	ra,24(sp)
    80001ba6:	e822                	sd	s0,16(sp)
    80001ba8:	e426                	sd	s1,8(sp)
    80001baa:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bac:	0000e497          	auipc	s1,0xe
    80001bb0:	2f448493          	addi	s1,s1,756 # 8000fea0 <tickslock>
    80001bb4:	8526                	mv	a0,s1
    80001bb6:	00005097          	auipc	ra,0x5
    80001bba:	588080e7          	jalr	1416(ra) # 8000713e <acquire>
  ticks++;
    80001bbe:	00008517          	auipc	a0,0x8
    80001bc2:	45a50513          	addi	a0,a0,1114 # 8000a018 <ticks>
    80001bc6:	411c                	lw	a5,0(a0)
    80001bc8:	2785                	addiw	a5,a5,1
    80001bca:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bcc:	00000097          	auipc	ra,0x0
    80001bd0:	b1c080e7          	jalr	-1252(ra) # 800016e8 <wakeup>
  release(&tickslock);
    80001bd4:	8526                	mv	a0,s1
    80001bd6:	00005097          	auipc	ra,0x5
    80001bda:	61c080e7          	jalr	1564(ra) # 800071f2 <release>
}
    80001bde:	60e2                	ld	ra,24(sp)
    80001be0:	6442                	ld	s0,16(sp)
    80001be2:	64a2                	ld	s1,8(sp)
    80001be4:	6105                	addi	sp,sp,32
    80001be6:	8082                	ret

0000000080001be8 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001be8:	1101                	addi	sp,sp,-32
    80001bea:	ec06                	sd	ra,24(sp)
    80001bec:	e822                	sd	s0,16(sp)
    80001bee:	e426                	sd	s1,8(sp)
    80001bf0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bf2:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bf6:	00074d63          	bltz	a4,80001c10 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bfa:	57fd                	li	a5,-1
    80001bfc:	17fe                	slli	a5,a5,0x3f
    80001bfe:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c00:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c02:	06f70c63          	beq	a4,a5,80001c7a <devintr+0x92>
  }
}
    80001c06:	60e2                	ld	ra,24(sp)
    80001c08:	6442                	ld	s0,16(sp)
    80001c0a:	64a2                	ld	s1,8(sp)
    80001c0c:	6105                	addi	sp,sp,32
    80001c0e:	8082                	ret
     (scause & 0xff) == 9){
    80001c10:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c14:	46a5                	li	a3,9
    80001c16:	fed792e3          	bne	a5,a3,80001bfa <devintr+0x12>
    int irq = plic_claim();
    80001c1a:	00003097          	auipc	ra,0x3
    80001c1e:	578080e7          	jalr	1400(ra) # 80005192 <plic_claim>
    80001c22:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c24:	47a9                	li	a5,10
    80001c26:	02f50563          	beq	a0,a5,80001c50 <devintr+0x68>
    } else if(irq == VIRTIO0_IRQ){
    80001c2a:	4785                	li	a5,1
    80001c2c:	02f50d63          	beq	a0,a5,80001c66 <devintr+0x7e>
    else if(irq == E1000_IRQ){
    80001c30:	02100793          	li	a5,33
    80001c34:	02f50e63          	beq	a0,a5,80001c70 <devintr+0x88>
    return 1;
    80001c38:	4505                	li	a0,1
    else if(irq){
    80001c3a:	d4f1                	beqz	s1,80001c06 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c3c:	85a6                	mv	a1,s1
    80001c3e:	00007517          	auipc	a0,0x7
    80001c42:	64a50513          	addi	a0,a0,1610 # 80009288 <states.1759+0x38>
    80001c46:	00005097          	auipc	ra,0x5
    80001c4a:	ff8080e7          	jalr	-8(ra) # 80006c3e <printf>
    80001c4e:	a029                	j	80001c58 <devintr+0x70>
      uartintr();
    80001c50:	00005097          	auipc	ra,0x5
    80001c54:	40e080e7          	jalr	1038(ra) # 8000705e <uartintr>
      plic_complete(irq);
    80001c58:	8526                	mv	a0,s1
    80001c5a:	00003097          	auipc	ra,0x3
    80001c5e:	55c080e7          	jalr	1372(ra) # 800051b6 <plic_complete>
    return 1;
    80001c62:	4505                	li	a0,1
    80001c64:	b74d                	j	80001c06 <devintr+0x1e>
      virtio_disk_intr();
    80001c66:	00004097          	auipc	ra,0x4
    80001c6a:	a30080e7          	jalr	-1488(ra) # 80005696 <virtio_disk_intr>
    80001c6e:	b7ed                	j	80001c58 <devintr+0x70>
      e1000_intr();
    80001c70:	00004097          	auipc	ra,0x4
    80001c74:	d8e080e7          	jalr	-626(ra) # 800059fe <e1000_intr>
    80001c78:	b7c5                	j	80001c58 <devintr+0x70>
    if(cpuid() == 0){
    80001c7a:	fffff097          	auipc	ra,0xfffff
    80001c7e:	1fa080e7          	jalr	506(ra) # 80000e74 <cpuid>
    80001c82:	c901                	beqz	a0,80001c92 <devintr+0xaa>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c84:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c88:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c8a:	14479073          	csrw	sip,a5
    return 2;
    80001c8e:	4509                	li	a0,2
    80001c90:	bf9d                	j	80001c06 <devintr+0x1e>
      clockintr();
    80001c92:	00000097          	auipc	ra,0x0
    80001c96:	f10080e7          	jalr	-240(ra) # 80001ba2 <clockintr>
    80001c9a:	b7ed                	j	80001c84 <devintr+0x9c>

0000000080001c9c <usertrap>:
{
    80001c9c:	1101                	addi	sp,sp,-32
    80001c9e:	ec06                	sd	ra,24(sp)
    80001ca0:	e822                	sd	s0,16(sp)
    80001ca2:	e426                	sd	s1,8(sp)
    80001ca4:	e04a                	sd	s2,0(sp)
    80001ca6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ca8:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cac:	1007f793          	andi	a5,a5,256
    80001cb0:	e3b9                	bnez	a5,80001cf6 <usertrap+0x5a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cb2:	00003797          	auipc	a5,0x3
    80001cb6:	3be78793          	addi	a5,a5,958 # 80005070 <kernelvec>
    80001cba:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cbe:	fffff097          	auipc	ra,0xfffff
    80001cc2:	1e2080e7          	jalr	482(ra) # 80000ea0 <myproc>
    80001cc6:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cc8:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cca:	14102773          	csrr	a4,sepc
    80001cce:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cd0:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cd4:	47a1                	li	a5,8
    80001cd6:	02f70863          	beq	a4,a5,80001d06 <usertrap+0x6a>
  } else if((which_dev = devintr()) != 0){
    80001cda:	00000097          	auipc	ra,0x0
    80001cde:	f0e080e7          	jalr	-242(ra) # 80001be8 <devintr>
    80001ce2:	892a                	mv	s2,a0
    80001ce4:	c551                	beqz	a0,80001d70 <usertrap+0xd4>
  if(lockfree_read4(&p->killed))
    80001ce6:	02848513          	addi	a0,s1,40
    80001cea:	00005097          	auipc	ra,0x5
    80001cee:	566080e7          	jalr	1382(ra) # 80007250 <lockfree_read4>
    80001cf2:	cd21                	beqz	a0,80001d4a <usertrap+0xae>
    80001cf4:	a0b1                	j	80001d40 <usertrap+0xa4>
    panic("usertrap: not from user mode");
    80001cf6:	00007517          	auipc	a0,0x7
    80001cfa:	5b250513          	addi	a0,a0,1458 # 800092a8 <states.1759+0x58>
    80001cfe:	00005097          	auipc	ra,0x5
    80001d02:	ef6080e7          	jalr	-266(ra) # 80006bf4 <panic>
    if(lockfree_read4(&p->killed))
    80001d06:	02850513          	addi	a0,a0,40
    80001d0a:	00005097          	auipc	ra,0x5
    80001d0e:	546080e7          	jalr	1350(ra) # 80007250 <lockfree_read4>
    80001d12:	e929                	bnez	a0,80001d64 <usertrap+0xc8>
    p->trapframe->epc += 4;
    80001d14:	6cb8                	ld	a4,88(s1)
    80001d16:	6f1c                	ld	a5,24(a4)
    80001d18:	0791                	addi	a5,a5,4
    80001d1a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d1c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d20:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d24:	10079073          	csrw	sstatus,a5
    syscall();
    80001d28:	00000097          	auipc	ra,0x0
    80001d2c:	2c8080e7          	jalr	712(ra) # 80001ff0 <syscall>
  if(lockfree_read4(&p->killed))
    80001d30:	02848513          	addi	a0,s1,40
    80001d34:	00005097          	auipc	ra,0x5
    80001d38:	51c080e7          	jalr	1308(ra) # 80007250 <lockfree_read4>
    80001d3c:	c911                	beqz	a0,80001d50 <usertrap+0xb4>
    80001d3e:	4901                	li	s2,0
    exit(-1);
    80001d40:	557d                	li	a0,-1
    80001d42:	00000097          	auipc	ra,0x0
    80001d46:	a76080e7          	jalr	-1418(ra) # 800017b8 <exit>
  if(which_dev == 2)
    80001d4a:	4789                	li	a5,2
    80001d4c:	04f90c63          	beq	s2,a5,80001da4 <usertrap+0x108>
  usertrapret();
    80001d50:	00000097          	auipc	ra,0x0
    80001d54:	db4080e7          	jalr	-588(ra) # 80001b04 <usertrapret>
}
    80001d58:	60e2                	ld	ra,24(sp)
    80001d5a:	6442                	ld	s0,16(sp)
    80001d5c:	64a2                	ld	s1,8(sp)
    80001d5e:	6902                	ld	s2,0(sp)
    80001d60:	6105                	addi	sp,sp,32
    80001d62:	8082                	ret
      exit(-1);
    80001d64:	557d                	li	a0,-1
    80001d66:	00000097          	auipc	ra,0x0
    80001d6a:	a52080e7          	jalr	-1454(ra) # 800017b8 <exit>
    80001d6e:	b75d                	j	80001d14 <usertrap+0x78>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d70:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d74:	5890                	lw	a2,48(s1)
    80001d76:	00007517          	auipc	a0,0x7
    80001d7a:	55250513          	addi	a0,a0,1362 # 800092c8 <states.1759+0x78>
    80001d7e:	00005097          	auipc	ra,0x5
    80001d82:	ec0080e7          	jalr	-320(ra) # 80006c3e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d86:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d8a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d8e:	00007517          	auipc	a0,0x7
    80001d92:	56a50513          	addi	a0,a0,1386 # 800092f8 <states.1759+0xa8>
    80001d96:	00005097          	auipc	ra,0x5
    80001d9a:	ea8080e7          	jalr	-344(ra) # 80006c3e <printf>
    p->killed = 1;
    80001d9e:	4785                	li	a5,1
    80001da0:	d49c                	sw	a5,40(s1)
    80001da2:	b779                	j	80001d30 <usertrap+0x94>
    yield();
    80001da4:	fffff097          	auipc	ra,0xfffff
    80001da8:	77c080e7          	jalr	1916(ra) # 80001520 <yield>
    80001dac:	b755                	j	80001d50 <usertrap+0xb4>

0000000080001dae <kerneltrap>:
{
    80001dae:	7179                	addi	sp,sp,-48
    80001db0:	f406                	sd	ra,40(sp)
    80001db2:	f022                	sd	s0,32(sp)
    80001db4:	ec26                	sd	s1,24(sp)
    80001db6:	e84a                	sd	s2,16(sp)
    80001db8:	e44e                	sd	s3,8(sp)
    80001dba:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dbc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dc0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dc4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dc8:	1004f793          	andi	a5,s1,256
    80001dcc:	cb85                	beqz	a5,80001dfc <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dce:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dd2:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dd4:	ef85                	bnez	a5,80001e0c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dd6:	00000097          	auipc	ra,0x0
    80001dda:	e12080e7          	jalr	-494(ra) # 80001be8 <devintr>
    80001dde:	cd1d                	beqz	a0,80001e1c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001de0:	4789                	li	a5,2
    80001de2:	06f50a63          	beq	a0,a5,80001e56 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001de6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dea:	10049073          	csrw	sstatus,s1
}
    80001dee:	70a2                	ld	ra,40(sp)
    80001df0:	7402                	ld	s0,32(sp)
    80001df2:	64e2                	ld	s1,24(sp)
    80001df4:	6942                	ld	s2,16(sp)
    80001df6:	69a2                	ld	s3,8(sp)
    80001df8:	6145                	addi	sp,sp,48
    80001dfa:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001dfc:	00007517          	auipc	a0,0x7
    80001e00:	51c50513          	addi	a0,a0,1308 # 80009318 <states.1759+0xc8>
    80001e04:	00005097          	auipc	ra,0x5
    80001e08:	df0080e7          	jalr	-528(ra) # 80006bf4 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e0c:	00007517          	auipc	a0,0x7
    80001e10:	53450513          	addi	a0,a0,1332 # 80009340 <states.1759+0xf0>
    80001e14:	00005097          	auipc	ra,0x5
    80001e18:	de0080e7          	jalr	-544(ra) # 80006bf4 <panic>
    printf("scause %p\n", scause);
    80001e1c:	85ce                	mv	a1,s3
    80001e1e:	00007517          	auipc	a0,0x7
    80001e22:	54250513          	addi	a0,a0,1346 # 80009360 <states.1759+0x110>
    80001e26:	00005097          	auipc	ra,0x5
    80001e2a:	e18080e7          	jalr	-488(ra) # 80006c3e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e2e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e32:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e36:	00007517          	auipc	a0,0x7
    80001e3a:	53a50513          	addi	a0,a0,1338 # 80009370 <states.1759+0x120>
    80001e3e:	00005097          	auipc	ra,0x5
    80001e42:	e00080e7          	jalr	-512(ra) # 80006c3e <printf>
    panic("kerneltrap");
    80001e46:	00007517          	auipc	a0,0x7
    80001e4a:	54250513          	addi	a0,a0,1346 # 80009388 <states.1759+0x138>
    80001e4e:	00005097          	auipc	ra,0x5
    80001e52:	da6080e7          	jalr	-602(ra) # 80006bf4 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e56:	fffff097          	auipc	ra,0xfffff
    80001e5a:	04a080e7          	jalr	74(ra) # 80000ea0 <myproc>
    80001e5e:	d541                	beqz	a0,80001de6 <kerneltrap+0x38>
    80001e60:	fffff097          	auipc	ra,0xfffff
    80001e64:	040080e7          	jalr	64(ra) # 80000ea0 <myproc>
    80001e68:	4d18                	lw	a4,24(a0)
    80001e6a:	4791                	li	a5,4
    80001e6c:	f6f71de3          	bne	a4,a5,80001de6 <kerneltrap+0x38>
    yield();
    80001e70:	fffff097          	auipc	ra,0xfffff
    80001e74:	6b0080e7          	jalr	1712(ra) # 80001520 <yield>
    80001e78:	b7bd                	j	80001de6 <kerneltrap+0x38>

0000000080001e7a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e7a:	1101                	addi	sp,sp,-32
    80001e7c:	ec06                	sd	ra,24(sp)
    80001e7e:	e822                	sd	s0,16(sp)
    80001e80:	e426                	sd	s1,8(sp)
    80001e82:	1000                	addi	s0,sp,32
    80001e84:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e86:	fffff097          	auipc	ra,0xfffff
    80001e8a:	01a080e7          	jalr	26(ra) # 80000ea0 <myproc>
  switch (n) {
    80001e8e:	4795                	li	a5,5
    80001e90:	0497e163          	bltu	a5,s1,80001ed2 <argraw+0x58>
    80001e94:	048a                	slli	s1,s1,0x2
    80001e96:	00007717          	auipc	a4,0x7
    80001e9a:	52a70713          	addi	a4,a4,1322 # 800093c0 <states.1759+0x170>
    80001e9e:	94ba                	add	s1,s1,a4
    80001ea0:	409c                	lw	a5,0(s1)
    80001ea2:	97ba                	add	a5,a5,a4
    80001ea4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ea6:	6d3c                	ld	a5,88(a0)
    80001ea8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001eaa:	60e2                	ld	ra,24(sp)
    80001eac:	6442                	ld	s0,16(sp)
    80001eae:	64a2                	ld	s1,8(sp)
    80001eb0:	6105                	addi	sp,sp,32
    80001eb2:	8082                	ret
    return p->trapframe->a1;
    80001eb4:	6d3c                	ld	a5,88(a0)
    80001eb6:	7fa8                	ld	a0,120(a5)
    80001eb8:	bfcd                	j	80001eaa <argraw+0x30>
    return p->trapframe->a2;
    80001eba:	6d3c                	ld	a5,88(a0)
    80001ebc:	63c8                	ld	a0,128(a5)
    80001ebe:	b7f5                	j	80001eaa <argraw+0x30>
    return p->trapframe->a3;
    80001ec0:	6d3c                	ld	a5,88(a0)
    80001ec2:	67c8                	ld	a0,136(a5)
    80001ec4:	b7dd                	j	80001eaa <argraw+0x30>
    return p->trapframe->a4;
    80001ec6:	6d3c                	ld	a5,88(a0)
    80001ec8:	6bc8                	ld	a0,144(a5)
    80001eca:	b7c5                	j	80001eaa <argraw+0x30>
    return p->trapframe->a5;
    80001ecc:	6d3c                	ld	a5,88(a0)
    80001ece:	6fc8                	ld	a0,152(a5)
    80001ed0:	bfe9                	j	80001eaa <argraw+0x30>
  panic("argraw");
    80001ed2:	00007517          	auipc	a0,0x7
    80001ed6:	4c650513          	addi	a0,a0,1222 # 80009398 <states.1759+0x148>
    80001eda:	00005097          	auipc	ra,0x5
    80001ede:	d1a080e7          	jalr	-742(ra) # 80006bf4 <panic>

0000000080001ee2 <fetchaddr>:
{
    80001ee2:	1101                	addi	sp,sp,-32
    80001ee4:	ec06                	sd	ra,24(sp)
    80001ee6:	e822                	sd	s0,16(sp)
    80001ee8:	e426                	sd	s1,8(sp)
    80001eea:	e04a                	sd	s2,0(sp)
    80001eec:	1000                	addi	s0,sp,32
    80001eee:	84aa                	mv	s1,a0
    80001ef0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ef2:	fffff097          	auipc	ra,0xfffff
    80001ef6:	fae080e7          	jalr	-82(ra) # 80000ea0 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001efa:	653c                	ld	a5,72(a0)
    80001efc:	02f4f863          	bgeu	s1,a5,80001f2c <fetchaddr+0x4a>
    80001f00:	00848713          	addi	a4,s1,8
    80001f04:	02e7e663          	bltu	a5,a4,80001f30 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f08:	46a1                	li	a3,8
    80001f0a:	8626                	mv	a2,s1
    80001f0c:	85ca                	mv	a1,s2
    80001f0e:	6928                	ld	a0,80(a0)
    80001f10:	fffff097          	auipc	ra,0xfffff
    80001f14:	ce2080e7          	jalr	-798(ra) # 80000bf2 <copyin>
    80001f18:	00a03533          	snez	a0,a0
    80001f1c:	40a00533          	neg	a0,a0
}
    80001f20:	60e2                	ld	ra,24(sp)
    80001f22:	6442                	ld	s0,16(sp)
    80001f24:	64a2                	ld	s1,8(sp)
    80001f26:	6902                	ld	s2,0(sp)
    80001f28:	6105                	addi	sp,sp,32
    80001f2a:	8082                	ret
    return -1;
    80001f2c:	557d                	li	a0,-1
    80001f2e:	bfcd                	j	80001f20 <fetchaddr+0x3e>
    80001f30:	557d                	li	a0,-1
    80001f32:	b7fd                	j	80001f20 <fetchaddr+0x3e>

0000000080001f34 <fetchstr>:
{
    80001f34:	7179                	addi	sp,sp,-48
    80001f36:	f406                	sd	ra,40(sp)
    80001f38:	f022                	sd	s0,32(sp)
    80001f3a:	ec26                	sd	s1,24(sp)
    80001f3c:	e84a                	sd	s2,16(sp)
    80001f3e:	e44e                	sd	s3,8(sp)
    80001f40:	1800                	addi	s0,sp,48
    80001f42:	892a                	mv	s2,a0
    80001f44:	84ae                	mv	s1,a1
    80001f46:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f48:	fffff097          	auipc	ra,0xfffff
    80001f4c:	f58080e7          	jalr	-168(ra) # 80000ea0 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f50:	86ce                	mv	a3,s3
    80001f52:	864a                	mv	a2,s2
    80001f54:	85a6                	mv	a1,s1
    80001f56:	6928                	ld	a0,80(a0)
    80001f58:	fffff097          	auipc	ra,0xfffff
    80001f5c:	d26080e7          	jalr	-730(ra) # 80000c7e <copyinstr>
  if(err < 0)
    80001f60:	00054763          	bltz	a0,80001f6e <fetchstr+0x3a>
  return strlen(buf);
    80001f64:	8526                	mv	a0,s1
    80001f66:	ffffe097          	auipc	ra,0xffffe
    80001f6a:	396080e7          	jalr	918(ra) # 800002fc <strlen>
}
    80001f6e:	70a2                	ld	ra,40(sp)
    80001f70:	7402                	ld	s0,32(sp)
    80001f72:	64e2                	ld	s1,24(sp)
    80001f74:	6942                	ld	s2,16(sp)
    80001f76:	69a2                	ld	s3,8(sp)
    80001f78:	6145                	addi	sp,sp,48
    80001f7a:	8082                	ret

0000000080001f7c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f7c:	1101                	addi	sp,sp,-32
    80001f7e:	ec06                	sd	ra,24(sp)
    80001f80:	e822                	sd	s0,16(sp)
    80001f82:	e426                	sd	s1,8(sp)
    80001f84:	1000                	addi	s0,sp,32
    80001f86:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f88:	00000097          	auipc	ra,0x0
    80001f8c:	ef2080e7          	jalr	-270(ra) # 80001e7a <argraw>
    80001f90:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f92:	4501                	li	a0,0
    80001f94:	60e2                	ld	ra,24(sp)
    80001f96:	6442                	ld	s0,16(sp)
    80001f98:	64a2                	ld	s1,8(sp)
    80001f9a:	6105                	addi	sp,sp,32
    80001f9c:	8082                	ret

0000000080001f9e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f9e:	1101                	addi	sp,sp,-32
    80001fa0:	ec06                	sd	ra,24(sp)
    80001fa2:	e822                	sd	s0,16(sp)
    80001fa4:	e426                	sd	s1,8(sp)
    80001fa6:	1000                	addi	s0,sp,32
    80001fa8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001faa:	00000097          	auipc	ra,0x0
    80001fae:	ed0080e7          	jalr	-304(ra) # 80001e7a <argraw>
    80001fb2:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fb4:	4501                	li	a0,0
    80001fb6:	60e2                	ld	ra,24(sp)
    80001fb8:	6442                	ld	s0,16(sp)
    80001fba:	64a2                	ld	s1,8(sp)
    80001fbc:	6105                	addi	sp,sp,32
    80001fbe:	8082                	ret

0000000080001fc0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fc0:	1101                	addi	sp,sp,-32
    80001fc2:	ec06                	sd	ra,24(sp)
    80001fc4:	e822                	sd	s0,16(sp)
    80001fc6:	e426                	sd	s1,8(sp)
    80001fc8:	e04a                	sd	s2,0(sp)
    80001fca:	1000                	addi	s0,sp,32
    80001fcc:	84ae                	mv	s1,a1
    80001fce:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fd0:	00000097          	auipc	ra,0x0
    80001fd4:	eaa080e7          	jalr	-342(ra) # 80001e7a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fd8:	864a                	mv	a2,s2
    80001fda:	85a6                	mv	a1,s1
    80001fdc:	00000097          	auipc	ra,0x0
    80001fe0:	f58080e7          	jalr	-168(ra) # 80001f34 <fetchstr>
}
    80001fe4:	60e2                	ld	ra,24(sp)
    80001fe6:	6442                	ld	s0,16(sp)
    80001fe8:	64a2                	ld	s1,8(sp)
    80001fea:	6902                	ld	s2,0(sp)
    80001fec:	6105                	addi	sp,sp,32
    80001fee:	8082                	ret

0000000080001ff0 <syscall>:



void
syscall(void)
{
    80001ff0:	1101                	addi	sp,sp,-32
    80001ff2:	ec06                	sd	ra,24(sp)
    80001ff4:	e822                	sd	s0,16(sp)
    80001ff6:	e426                	sd	s1,8(sp)
    80001ff8:	e04a                	sd	s2,0(sp)
    80001ffa:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001ffc:	fffff097          	auipc	ra,0xfffff
    80002000:	ea4080e7          	jalr	-348(ra) # 80000ea0 <myproc>
    80002004:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002006:	05853903          	ld	s2,88(a0)
    8000200a:	0a893783          	ld	a5,168(s2)
    8000200e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002012:	37fd                	addiw	a5,a5,-1
    80002014:	4771                	li	a4,28
    80002016:	00f76f63          	bltu	a4,a5,80002034 <syscall+0x44>
    8000201a:	00369713          	slli	a4,a3,0x3
    8000201e:	00007797          	auipc	a5,0x7
    80002022:	3ba78793          	addi	a5,a5,954 # 800093d8 <syscalls>
    80002026:	97ba                	add	a5,a5,a4
    80002028:	639c                	ld	a5,0(a5)
    8000202a:	c789                	beqz	a5,80002034 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000202c:	9782                	jalr	a5
    8000202e:	06a93823          	sd	a0,112(s2)
    80002032:	a839                	j	80002050 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002034:	15848613          	addi	a2,s1,344
    80002038:	588c                	lw	a1,48(s1)
    8000203a:	00007517          	auipc	a0,0x7
    8000203e:	36650513          	addi	a0,a0,870 # 800093a0 <states.1759+0x150>
    80002042:	00005097          	auipc	ra,0x5
    80002046:	bfc080e7          	jalr	-1028(ra) # 80006c3e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000204a:	6cbc                	ld	a5,88(s1)
    8000204c:	577d                	li	a4,-1
    8000204e:	fbb8                	sd	a4,112(a5)
  }
}
    80002050:	60e2                	ld	ra,24(sp)
    80002052:	6442                	ld	s0,16(sp)
    80002054:	64a2                	ld	s1,8(sp)
    80002056:	6902                	ld	s2,0(sp)
    80002058:	6105                	addi	sp,sp,32
    8000205a:	8082                	ret

000000008000205c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000205c:	1101                	addi	sp,sp,-32
    8000205e:	ec06                	sd	ra,24(sp)
    80002060:	e822                	sd	s0,16(sp)
    80002062:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002064:	fec40593          	addi	a1,s0,-20
    80002068:	4501                	li	a0,0
    8000206a:	00000097          	auipc	ra,0x0
    8000206e:	f12080e7          	jalr	-238(ra) # 80001f7c <argint>
    return -1;
    80002072:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002074:	00054963          	bltz	a0,80002086 <sys_exit+0x2a>
  exit(n);
    80002078:	fec42503          	lw	a0,-20(s0)
    8000207c:	fffff097          	auipc	ra,0xfffff
    80002080:	73c080e7          	jalr	1852(ra) # 800017b8 <exit>
  return 0;  // not reached
    80002084:	4781                	li	a5,0
}
    80002086:	853e                	mv	a0,a5
    80002088:	60e2                	ld	ra,24(sp)
    8000208a:	6442                	ld	s0,16(sp)
    8000208c:	6105                	addi	sp,sp,32
    8000208e:	8082                	ret

0000000080002090 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002090:	1141                	addi	sp,sp,-16
    80002092:	e406                	sd	ra,8(sp)
    80002094:	e022                	sd	s0,0(sp)
    80002096:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002098:	fffff097          	auipc	ra,0xfffff
    8000209c:	e08080e7          	jalr	-504(ra) # 80000ea0 <myproc>
}
    800020a0:	5908                	lw	a0,48(a0)
    800020a2:	60a2                	ld	ra,8(sp)
    800020a4:	6402                	ld	s0,0(sp)
    800020a6:	0141                	addi	sp,sp,16
    800020a8:	8082                	ret

00000000800020aa <sys_fork>:

uint64
sys_fork(void)
{
    800020aa:	1141                	addi	sp,sp,-16
    800020ac:	e406                	sd	ra,8(sp)
    800020ae:	e022                	sd	s0,0(sp)
    800020b0:	0800                	addi	s0,sp,16
  return fork();
    800020b2:	fffff097          	auipc	ra,0xfffff
    800020b6:	1bc080e7          	jalr	444(ra) # 8000126e <fork>
}
    800020ba:	60a2                	ld	ra,8(sp)
    800020bc:	6402                	ld	s0,0(sp)
    800020be:	0141                	addi	sp,sp,16
    800020c0:	8082                	ret

00000000800020c2 <sys_wait>:

uint64
sys_wait(void)
{
    800020c2:	1101                	addi	sp,sp,-32
    800020c4:	ec06                	sd	ra,24(sp)
    800020c6:	e822                	sd	s0,16(sp)
    800020c8:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800020ca:	fe840593          	addi	a1,s0,-24
    800020ce:	4501                	li	a0,0
    800020d0:	00000097          	auipc	ra,0x0
    800020d4:	ece080e7          	jalr	-306(ra) # 80001f9e <argaddr>
    800020d8:	87aa                	mv	a5,a0
    return -1;
    800020da:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800020dc:	0007c863          	bltz	a5,800020ec <sys_wait+0x2a>
  return wait(p);
    800020e0:	fe843503          	ld	a0,-24(s0)
    800020e4:	fffff097          	auipc	ra,0xfffff
    800020e8:	4dc080e7          	jalr	1244(ra) # 800015c0 <wait>
}
    800020ec:	60e2                	ld	ra,24(sp)
    800020ee:	6442                	ld	s0,16(sp)
    800020f0:	6105                	addi	sp,sp,32
    800020f2:	8082                	ret

00000000800020f4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020f4:	7179                	addi	sp,sp,-48
    800020f6:	f406                	sd	ra,40(sp)
    800020f8:	f022                	sd	s0,32(sp)
    800020fa:	ec26                	sd	s1,24(sp)
    800020fc:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800020fe:	fdc40593          	addi	a1,s0,-36
    80002102:	4501                	li	a0,0
    80002104:	00000097          	auipc	ra,0x0
    80002108:	e78080e7          	jalr	-392(ra) # 80001f7c <argint>
    8000210c:	87aa                	mv	a5,a0
    return -1;
    8000210e:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002110:	0207c063          	bltz	a5,80002130 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002114:	fffff097          	auipc	ra,0xfffff
    80002118:	d8c080e7          	jalr	-628(ra) # 80000ea0 <myproc>
    8000211c:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000211e:	fdc42503          	lw	a0,-36(s0)
    80002122:	fffff097          	auipc	ra,0xfffff
    80002126:	0d8080e7          	jalr	216(ra) # 800011fa <growproc>
    8000212a:	00054863          	bltz	a0,8000213a <sys_sbrk+0x46>
    return -1;
  return addr;
    8000212e:	8526                	mv	a0,s1
}
    80002130:	70a2                	ld	ra,40(sp)
    80002132:	7402                	ld	s0,32(sp)
    80002134:	64e2                	ld	s1,24(sp)
    80002136:	6145                	addi	sp,sp,48
    80002138:	8082                	ret
    return -1;
    8000213a:	557d                	li	a0,-1
    8000213c:	bfd5                	j	80002130 <sys_sbrk+0x3c>

000000008000213e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000213e:	7139                	addi	sp,sp,-64
    80002140:	fc06                	sd	ra,56(sp)
    80002142:	f822                	sd	s0,48(sp)
    80002144:	f426                	sd	s1,40(sp)
    80002146:	f04a                	sd	s2,32(sp)
    80002148:	ec4e                	sd	s3,24(sp)
    8000214a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000214c:	fcc40593          	addi	a1,s0,-52
    80002150:	4501                	li	a0,0
    80002152:	00000097          	auipc	ra,0x0
    80002156:	e2a080e7          	jalr	-470(ra) # 80001f7c <argint>
    return -1;
    8000215a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000215c:	06054563          	bltz	a0,800021c6 <sys_sleep+0x88>
  acquire(&tickslock);
    80002160:	0000e517          	auipc	a0,0xe
    80002164:	d4050513          	addi	a0,a0,-704 # 8000fea0 <tickslock>
    80002168:	00005097          	auipc	ra,0x5
    8000216c:	fd6080e7          	jalr	-42(ra) # 8000713e <acquire>
  ticks0 = ticks;
    80002170:	00008917          	auipc	s2,0x8
    80002174:	ea892903          	lw	s2,-344(s2) # 8000a018 <ticks>
  while(ticks - ticks0 < n){
    80002178:	fcc42783          	lw	a5,-52(s0)
    8000217c:	cf85                	beqz	a5,800021b4 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000217e:	0000e997          	auipc	s3,0xe
    80002182:	d2298993          	addi	s3,s3,-734 # 8000fea0 <tickslock>
    80002186:	00008497          	auipc	s1,0x8
    8000218a:	e9248493          	addi	s1,s1,-366 # 8000a018 <ticks>
    if(myproc()->killed){
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	d12080e7          	jalr	-750(ra) # 80000ea0 <myproc>
    80002196:	551c                	lw	a5,40(a0)
    80002198:	ef9d                	bnez	a5,800021d6 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000219a:	85ce                	mv	a1,s3
    8000219c:	8526                	mv	a0,s1
    8000219e:	fffff097          	auipc	ra,0xfffff
    800021a2:	3be080e7          	jalr	958(ra) # 8000155c <sleep>
  while(ticks - ticks0 < n){
    800021a6:	409c                	lw	a5,0(s1)
    800021a8:	412787bb          	subw	a5,a5,s2
    800021ac:	fcc42703          	lw	a4,-52(s0)
    800021b0:	fce7efe3          	bltu	a5,a4,8000218e <sys_sleep+0x50>
  }
  release(&tickslock);
    800021b4:	0000e517          	auipc	a0,0xe
    800021b8:	cec50513          	addi	a0,a0,-788 # 8000fea0 <tickslock>
    800021bc:	00005097          	auipc	ra,0x5
    800021c0:	036080e7          	jalr	54(ra) # 800071f2 <release>
  return 0;
    800021c4:	4781                	li	a5,0
}
    800021c6:	853e                	mv	a0,a5
    800021c8:	70e2                	ld	ra,56(sp)
    800021ca:	7442                	ld	s0,48(sp)
    800021cc:	74a2                	ld	s1,40(sp)
    800021ce:	7902                	ld	s2,32(sp)
    800021d0:	69e2                	ld	s3,24(sp)
    800021d2:	6121                	addi	sp,sp,64
    800021d4:	8082                	ret
      release(&tickslock);
    800021d6:	0000e517          	auipc	a0,0xe
    800021da:	cca50513          	addi	a0,a0,-822 # 8000fea0 <tickslock>
    800021de:	00005097          	auipc	ra,0x5
    800021e2:	014080e7          	jalr	20(ra) # 800071f2 <release>
      return -1;
    800021e6:	57fd                	li	a5,-1
    800021e8:	bff9                	j	800021c6 <sys_sleep+0x88>

00000000800021ea <sys_kill>:

uint64
sys_kill(void)
{
    800021ea:	1101                	addi	sp,sp,-32
    800021ec:	ec06                	sd	ra,24(sp)
    800021ee:	e822                	sd	s0,16(sp)
    800021f0:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800021f2:	fec40593          	addi	a1,s0,-20
    800021f6:	4501                	li	a0,0
    800021f8:	00000097          	auipc	ra,0x0
    800021fc:	d84080e7          	jalr	-636(ra) # 80001f7c <argint>
    80002200:	87aa                	mv	a5,a0
    return -1;
    80002202:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002204:	0007c863          	bltz	a5,80002214 <sys_kill+0x2a>
  return kill(pid);
    80002208:	fec42503          	lw	a0,-20(s0)
    8000220c:	fffff097          	auipc	ra,0xfffff
    80002210:	682080e7          	jalr	1666(ra) # 8000188e <kill>
}
    80002214:	60e2                	ld	ra,24(sp)
    80002216:	6442                	ld	s0,16(sp)
    80002218:	6105                	addi	sp,sp,32
    8000221a:	8082                	ret

000000008000221c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000221c:	1101                	addi	sp,sp,-32
    8000221e:	ec06                	sd	ra,24(sp)
    80002220:	e822                	sd	s0,16(sp)
    80002222:	e426                	sd	s1,8(sp)
    80002224:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002226:	0000e517          	auipc	a0,0xe
    8000222a:	c7a50513          	addi	a0,a0,-902 # 8000fea0 <tickslock>
    8000222e:	00005097          	auipc	ra,0x5
    80002232:	f10080e7          	jalr	-240(ra) # 8000713e <acquire>
  xticks = ticks;
    80002236:	00008497          	auipc	s1,0x8
    8000223a:	de24a483          	lw	s1,-542(s1) # 8000a018 <ticks>
  release(&tickslock);
    8000223e:	0000e517          	auipc	a0,0xe
    80002242:	c6250513          	addi	a0,a0,-926 # 8000fea0 <tickslock>
    80002246:	00005097          	auipc	ra,0x5
    8000224a:	fac080e7          	jalr	-84(ra) # 800071f2 <release>
  return xticks;
}
    8000224e:	02049513          	slli	a0,s1,0x20
    80002252:	9101                	srli	a0,a0,0x20
    80002254:	60e2                	ld	ra,24(sp)
    80002256:	6442                	ld	s0,16(sp)
    80002258:	64a2                	ld	s1,8(sp)
    8000225a:	6105                	addi	sp,sp,32
    8000225c:	8082                	ret

000000008000225e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000225e:	7179                	addi	sp,sp,-48
    80002260:	f406                	sd	ra,40(sp)
    80002262:	f022                	sd	s0,32(sp)
    80002264:	ec26                	sd	s1,24(sp)
    80002266:	e84a                	sd	s2,16(sp)
    80002268:	e44e                	sd	s3,8(sp)
    8000226a:	e052                	sd	s4,0(sp)
    8000226c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000226e:	00007597          	auipc	a1,0x7
    80002272:	25a58593          	addi	a1,a1,602 # 800094c8 <syscalls+0xf0>
    80002276:	0000e517          	auipc	a0,0xe
    8000227a:	c4250513          	addi	a0,a0,-958 # 8000feb8 <bcache>
    8000227e:	00005097          	auipc	ra,0x5
    80002282:	e30080e7          	jalr	-464(ra) # 800070ae <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002286:	00016797          	auipc	a5,0x16
    8000228a:	c3278793          	addi	a5,a5,-974 # 80017eb8 <bcache+0x8000>
    8000228e:	00016717          	auipc	a4,0x16
    80002292:	e9270713          	addi	a4,a4,-366 # 80018120 <bcache+0x8268>
    80002296:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000229a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000229e:	0000e497          	auipc	s1,0xe
    800022a2:	c3248493          	addi	s1,s1,-974 # 8000fed0 <bcache+0x18>
    b->next = bcache.head.next;
    800022a6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800022a8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800022aa:	00007a17          	auipc	s4,0x7
    800022ae:	226a0a13          	addi	s4,s4,550 # 800094d0 <syscalls+0xf8>
    b->next = bcache.head.next;
    800022b2:	2b893783          	ld	a5,696(s2)
    800022b6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800022b8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022bc:	85d2                	mv	a1,s4
    800022be:	01048513          	addi	a0,s1,16
    800022c2:	00001097          	auipc	ra,0x1
    800022c6:	4bc080e7          	jalr	1212(ra) # 8000377e <initsleeplock>
    bcache.head.next->prev = b;
    800022ca:	2b893783          	ld	a5,696(s2)
    800022ce:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022d0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022d4:	45848493          	addi	s1,s1,1112
    800022d8:	fd349de3          	bne	s1,s3,800022b2 <binit+0x54>
  }
}
    800022dc:	70a2                	ld	ra,40(sp)
    800022de:	7402                	ld	s0,32(sp)
    800022e0:	64e2                	ld	s1,24(sp)
    800022e2:	6942                	ld	s2,16(sp)
    800022e4:	69a2                	ld	s3,8(sp)
    800022e6:	6a02                	ld	s4,0(sp)
    800022e8:	6145                	addi	sp,sp,48
    800022ea:	8082                	ret

00000000800022ec <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022ec:	7179                	addi	sp,sp,-48
    800022ee:	f406                	sd	ra,40(sp)
    800022f0:	f022                	sd	s0,32(sp)
    800022f2:	ec26                	sd	s1,24(sp)
    800022f4:	e84a                	sd	s2,16(sp)
    800022f6:	e44e                	sd	s3,8(sp)
    800022f8:	1800                	addi	s0,sp,48
    800022fa:	89aa                	mv	s3,a0
    800022fc:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800022fe:	0000e517          	auipc	a0,0xe
    80002302:	bba50513          	addi	a0,a0,-1094 # 8000feb8 <bcache>
    80002306:	00005097          	auipc	ra,0x5
    8000230a:	e38080e7          	jalr	-456(ra) # 8000713e <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000230e:	00016497          	auipc	s1,0x16
    80002312:	e624b483          	ld	s1,-414(s1) # 80018170 <bcache+0x82b8>
    80002316:	00016797          	auipc	a5,0x16
    8000231a:	e0a78793          	addi	a5,a5,-502 # 80018120 <bcache+0x8268>
    8000231e:	02f48f63          	beq	s1,a5,8000235c <bread+0x70>
    80002322:	873e                	mv	a4,a5
    80002324:	a021                	j	8000232c <bread+0x40>
    80002326:	68a4                	ld	s1,80(s1)
    80002328:	02e48a63          	beq	s1,a4,8000235c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000232c:	449c                	lw	a5,8(s1)
    8000232e:	ff379ce3          	bne	a5,s3,80002326 <bread+0x3a>
    80002332:	44dc                	lw	a5,12(s1)
    80002334:	ff2799e3          	bne	a5,s2,80002326 <bread+0x3a>
      b->refcnt++;
    80002338:	40bc                	lw	a5,64(s1)
    8000233a:	2785                	addiw	a5,a5,1
    8000233c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000233e:	0000e517          	auipc	a0,0xe
    80002342:	b7a50513          	addi	a0,a0,-1158 # 8000feb8 <bcache>
    80002346:	00005097          	auipc	ra,0x5
    8000234a:	eac080e7          	jalr	-340(ra) # 800071f2 <release>
      acquiresleep(&b->lock);
    8000234e:	01048513          	addi	a0,s1,16
    80002352:	00001097          	auipc	ra,0x1
    80002356:	466080e7          	jalr	1126(ra) # 800037b8 <acquiresleep>
      return b;
    8000235a:	a8b9                	j	800023b8 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000235c:	00016497          	auipc	s1,0x16
    80002360:	e0c4b483          	ld	s1,-500(s1) # 80018168 <bcache+0x82b0>
    80002364:	00016797          	auipc	a5,0x16
    80002368:	dbc78793          	addi	a5,a5,-580 # 80018120 <bcache+0x8268>
    8000236c:	00f48863          	beq	s1,a5,8000237c <bread+0x90>
    80002370:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002372:	40bc                	lw	a5,64(s1)
    80002374:	cf81                	beqz	a5,8000238c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002376:	64a4                	ld	s1,72(s1)
    80002378:	fee49de3          	bne	s1,a4,80002372 <bread+0x86>
  panic("bget: no buffers");
    8000237c:	00007517          	auipc	a0,0x7
    80002380:	15c50513          	addi	a0,a0,348 # 800094d8 <syscalls+0x100>
    80002384:	00005097          	auipc	ra,0x5
    80002388:	870080e7          	jalr	-1936(ra) # 80006bf4 <panic>
      b->dev = dev;
    8000238c:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002390:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002394:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002398:	4785                	li	a5,1
    8000239a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000239c:	0000e517          	auipc	a0,0xe
    800023a0:	b1c50513          	addi	a0,a0,-1252 # 8000feb8 <bcache>
    800023a4:	00005097          	auipc	ra,0x5
    800023a8:	e4e080e7          	jalr	-434(ra) # 800071f2 <release>
      acquiresleep(&b->lock);
    800023ac:	01048513          	addi	a0,s1,16
    800023b0:	00001097          	auipc	ra,0x1
    800023b4:	408080e7          	jalr	1032(ra) # 800037b8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800023b8:	409c                	lw	a5,0(s1)
    800023ba:	cb89                	beqz	a5,800023cc <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800023bc:	8526                	mv	a0,s1
    800023be:	70a2                	ld	ra,40(sp)
    800023c0:	7402                	ld	s0,32(sp)
    800023c2:	64e2                	ld	s1,24(sp)
    800023c4:	6942                	ld	s2,16(sp)
    800023c6:	69a2                	ld	s3,8(sp)
    800023c8:	6145                	addi	sp,sp,48
    800023ca:	8082                	ret
    virtio_disk_rw(b, 0);
    800023cc:	4581                	li	a1,0
    800023ce:	8526                	mv	a0,s1
    800023d0:	00003097          	auipc	ra,0x3
    800023d4:	ff0080e7          	jalr	-16(ra) # 800053c0 <virtio_disk_rw>
    b->valid = 1;
    800023d8:	4785                	li	a5,1
    800023da:	c09c                	sw	a5,0(s1)
  return b;
    800023dc:	b7c5                	j	800023bc <bread+0xd0>

00000000800023de <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023de:	1101                	addi	sp,sp,-32
    800023e0:	ec06                	sd	ra,24(sp)
    800023e2:	e822                	sd	s0,16(sp)
    800023e4:	e426                	sd	s1,8(sp)
    800023e6:	1000                	addi	s0,sp,32
    800023e8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023ea:	0541                	addi	a0,a0,16
    800023ec:	00001097          	auipc	ra,0x1
    800023f0:	466080e7          	jalr	1126(ra) # 80003852 <holdingsleep>
    800023f4:	cd01                	beqz	a0,8000240c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023f6:	4585                	li	a1,1
    800023f8:	8526                	mv	a0,s1
    800023fa:	00003097          	auipc	ra,0x3
    800023fe:	fc6080e7          	jalr	-58(ra) # 800053c0 <virtio_disk_rw>
}
    80002402:	60e2                	ld	ra,24(sp)
    80002404:	6442                	ld	s0,16(sp)
    80002406:	64a2                	ld	s1,8(sp)
    80002408:	6105                	addi	sp,sp,32
    8000240a:	8082                	ret
    panic("bwrite");
    8000240c:	00007517          	auipc	a0,0x7
    80002410:	0e450513          	addi	a0,a0,228 # 800094f0 <syscalls+0x118>
    80002414:	00004097          	auipc	ra,0x4
    80002418:	7e0080e7          	jalr	2016(ra) # 80006bf4 <panic>

000000008000241c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000241c:	1101                	addi	sp,sp,-32
    8000241e:	ec06                	sd	ra,24(sp)
    80002420:	e822                	sd	s0,16(sp)
    80002422:	e426                	sd	s1,8(sp)
    80002424:	e04a                	sd	s2,0(sp)
    80002426:	1000                	addi	s0,sp,32
    80002428:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000242a:	01050913          	addi	s2,a0,16
    8000242e:	854a                	mv	a0,s2
    80002430:	00001097          	auipc	ra,0x1
    80002434:	422080e7          	jalr	1058(ra) # 80003852 <holdingsleep>
    80002438:	c92d                	beqz	a0,800024aa <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000243a:	854a                	mv	a0,s2
    8000243c:	00001097          	auipc	ra,0x1
    80002440:	3d2080e7          	jalr	978(ra) # 8000380e <releasesleep>

  acquire(&bcache.lock);
    80002444:	0000e517          	auipc	a0,0xe
    80002448:	a7450513          	addi	a0,a0,-1420 # 8000feb8 <bcache>
    8000244c:	00005097          	auipc	ra,0x5
    80002450:	cf2080e7          	jalr	-782(ra) # 8000713e <acquire>
  b->refcnt--;
    80002454:	40bc                	lw	a5,64(s1)
    80002456:	37fd                	addiw	a5,a5,-1
    80002458:	0007871b          	sext.w	a4,a5
    8000245c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000245e:	eb05                	bnez	a4,8000248e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002460:	68bc                	ld	a5,80(s1)
    80002462:	64b8                	ld	a4,72(s1)
    80002464:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002466:	64bc                	ld	a5,72(s1)
    80002468:	68b8                	ld	a4,80(s1)
    8000246a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000246c:	00016797          	auipc	a5,0x16
    80002470:	a4c78793          	addi	a5,a5,-1460 # 80017eb8 <bcache+0x8000>
    80002474:	2b87b703          	ld	a4,696(a5)
    80002478:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000247a:	00016717          	auipc	a4,0x16
    8000247e:	ca670713          	addi	a4,a4,-858 # 80018120 <bcache+0x8268>
    80002482:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002484:	2b87b703          	ld	a4,696(a5)
    80002488:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000248a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000248e:	0000e517          	auipc	a0,0xe
    80002492:	a2a50513          	addi	a0,a0,-1494 # 8000feb8 <bcache>
    80002496:	00005097          	auipc	ra,0x5
    8000249a:	d5c080e7          	jalr	-676(ra) # 800071f2 <release>
}
    8000249e:	60e2                	ld	ra,24(sp)
    800024a0:	6442                	ld	s0,16(sp)
    800024a2:	64a2                	ld	s1,8(sp)
    800024a4:	6902                	ld	s2,0(sp)
    800024a6:	6105                	addi	sp,sp,32
    800024a8:	8082                	ret
    panic("brelse");
    800024aa:	00007517          	auipc	a0,0x7
    800024ae:	04e50513          	addi	a0,a0,78 # 800094f8 <syscalls+0x120>
    800024b2:	00004097          	auipc	ra,0x4
    800024b6:	742080e7          	jalr	1858(ra) # 80006bf4 <panic>

00000000800024ba <bpin>:

void
bpin(struct buf *b) {
    800024ba:	1101                	addi	sp,sp,-32
    800024bc:	ec06                	sd	ra,24(sp)
    800024be:	e822                	sd	s0,16(sp)
    800024c0:	e426                	sd	s1,8(sp)
    800024c2:	1000                	addi	s0,sp,32
    800024c4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024c6:	0000e517          	auipc	a0,0xe
    800024ca:	9f250513          	addi	a0,a0,-1550 # 8000feb8 <bcache>
    800024ce:	00005097          	auipc	ra,0x5
    800024d2:	c70080e7          	jalr	-912(ra) # 8000713e <acquire>
  b->refcnt++;
    800024d6:	40bc                	lw	a5,64(s1)
    800024d8:	2785                	addiw	a5,a5,1
    800024da:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024dc:	0000e517          	auipc	a0,0xe
    800024e0:	9dc50513          	addi	a0,a0,-1572 # 8000feb8 <bcache>
    800024e4:	00005097          	auipc	ra,0x5
    800024e8:	d0e080e7          	jalr	-754(ra) # 800071f2 <release>
}
    800024ec:	60e2                	ld	ra,24(sp)
    800024ee:	6442                	ld	s0,16(sp)
    800024f0:	64a2                	ld	s1,8(sp)
    800024f2:	6105                	addi	sp,sp,32
    800024f4:	8082                	ret

00000000800024f6 <bunpin>:

void
bunpin(struct buf *b) {
    800024f6:	1101                	addi	sp,sp,-32
    800024f8:	ec06                	sd	ra,24(sp)
    800024fa:	e822                	sd	s0,16(sp)
    800024fc:	e426                	sd	s1,8(sp)
    800024fe:	1000                	addi	s0,sp,32
    80002500:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002502:	0000e517          	auipc	a0,0xe
    80002506:	9b650513          	addi	a0,a0,-1610 # 8000feb8 <bcache>
    8000250a:	00005097          	auipc	ra,0x5
    8000250e:	c34080e7          	jalr	-972(ra) # 8000713e <acquire>
  b->refcnt--;
    80002512:	40bc                	lw	a5,64(s1)
    80002514:	37fd                	addiw	a5,a5,-1
    80002516:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002518:	0000e517          	auipc	a0,0xe
    8000251c:	9a050513          	addi	a0,a0,-1632 # 8000feb8 <bcache>
    80002520:	00005097          	auipc	ra,0x5
    80002524:	cd2080e7          	jalr	-814(ra) # 800071f2 <release>
}
    80002528:	60e2                	ld	ra,24(sp)
    8000252a:	6442                	ld	s0,16(sp)
    8000252c:	64a2                	ld	s1,8(sp)
    8000252e:	6105                	addi	sp,sp,32
    80002530:	8082                	ret

0000000080002532 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002532:	1101                	addi	sp,sp,-32
    80002534:	ec06                	sd	ra,24(sp)
    80002536:	e822                	sd	s0,16(sp)
    80002538:	e426                	sd	s1,8(sp)
    8000253a:	e04a                	sd	s2,0(sp)
    8000253c:	1000                	addi	s0,sp,32
    8000253e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002540:	00d5d59b          	srliw	a1,a1,0xd
    80002544:	00016797          	auipc	a5,0x16
    80002548:	0507a783          	lw	a5,80(a5) # 80018594 <sb+0x1c>
    8000254c:	9dbd                	addw	a1,a1,a5
    8000254e:	00000097          	auipc	ra,0x0
    80002552:	d9e080e7          	jalr	-610(ra) # 800022ec <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002556:	0074f713          	andi	a4,s1,7
    8000255a:	4785                	li	a5,1
    8000255c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002560:	14ce                	slli	s1,s1,0x33
    80002562:	90d9                	srli	s1,s1,0x36
    80002564:	00950733          	add	a4,a0,s1
    80002568:	05874703          	lbu	a4,88(a4)
    8000256c:	00e7f6b3          	and	a3,a5,a4
    80002570:	c69d                	beqz	a3,8000259e <bfree+0x6c>
    80002572:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002574:	94aa                	add	s1,s1,a0
    80002576:	fff7c793          	not	a5,a5
    8000257a:	8ff9                	and	a5,a5,a4
    8000257c:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002580:	00001097          	auipc	ra,0x1
    80002584:	118080e7          	jalr	280(ra) # 80003698 <log_write>
  brelse(bp);
    80002588:	854a                	mv	a0,s2
    8000258a:	00000097          	auipc	ra,0x0
    8000258e:	e92080e7          	jalr	-366(ra) # 8000241c <brelse>
}
    80002592:	60e2                	ld	ra,24(sp)
    80002594:	6442                	ld	s0,16(sp)
    80002596:	64a2                	ld	s1,8(sp)
    80002598:	6902                	ld	s2,0(sp)
    8000259a:	6105                	addi	sp,sp,32
    8000259c:	8082                	ret
    panic("freeing free block");
    8000259e:	00007517          	auipc	a0,0x7
    800025a2:	f6250513          	addi	a0,a0,-158 # 80009500 <syscalls+0x128>
    800025a6:	00004097          	auipc	ra,0x4
    800025aa:	64e080e7          	jalr	1614(ra) # 80006bf4 <panic>

00000000800025ae <balloc>:
{
    800025ae:	711d                	addi	sp,sp,-96
    800025b0:	ec86                	sd	ra,88(sp)
    800025b2:	e8a2                	sd	s0,80(sp)
    800025b4:	e4a6                	sd	s1,72(sp)
    800025b6:	e0ca                	sd	s2,64(sp)
    800025b8:	fc4e                	sd	s3,56(sp)
    800025ba:	f852                	sd	s4,48(sp)
    800025bc:	f456                	sd	s5,40(sp)
    800025be:	f05a                	sd	s6,32(sp)
    800025c0:	ec5e                	sd	s7,24(sp)
    800025c2:	e862                	sd	s8,16(sp)
    800025c4:	e466                	sd	s9,8(sp)
    800025c6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025c8:	00016797          	auipc	a5,0x16
    800025cc:	fb47a783          	lw	a5,-76(a5) # 8001857c <sb+0x4>
    800025d0:	cbd1                	beqz	a5,80002664 <balloc+0xb6>
    800025d2:	8baa                	mv	s7,a0
    800025d4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025d6:	00016b17          	auipc	s6,0x16
    800025da:	fa2b0b13          	addi	s6,s6,-94 # 80018578 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025de:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025e0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025e2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025e4:	6c89                	lui	s9,0x2
    800025e6:	a831                	j	80002602 <balloc+0x54>
    brelse(bp);
    800025e8:	854a                	mv	a0,s2
    800025ea:	00000097          	auipc	ra,0x0
    800025ee:	e32080e7          	jalr	-462(ra) # 8000241c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800025f2:	015c87bb          	addw	a5,s9,s5
    800025f6:	00078a9b          	sext.w	s5,a5
    800025fa:	004b2703          	lw	a4,4(s6)
    800025fe:	06eaf363          	bgeu	s5,a4,80002664 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002602:	41fad79b          	sraiw	a5,s5,0x1f
    80002606:	0137d79b          	srliw	a5,a5,0x13
    8000260a:	015787bb          	addw	a5,a5,s5
    8000260e:	40d7d79b          	sraiw	a5,a5,0xd
    80002612:	01cb2583          	lw	a1,28(s6)
    80002616:	9dbd                	addw	a1,a1,a5
    80002618:	855e                	mv	a0,s7
    8000261a:	00000097          	auipc	ra,0x0
    8000261e:	cd2080e7          	jalr	-814(ra) # 800022ec <bread>
    80002622:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002624:	004b2503          	lw	a0,4(s6)
    80002628:	000a849b          	sext.w	s1,s5
    8000262c:	8662                	mv	a2,s8
    8000262e:	faa4fde3          	bgeu	s1,a0,800025e8 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002632:	41f6579b          	sraiw	a5,a2,0x1f
    80002636:	01d7d69b          	srliw	a3,a5,0x1d
    8000263a:	00c6873b          	addw	a4,a3,a2
    8000263e:	00777793          	andi	a5,a4,7
    80002642:	9f95                	subw	a5,a5,a3
    80002644:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002648:	4037571b          	sraiw	a4,a4,0x3
    8000264c:	00e906b3          	add	a3,s2,a4
    80002650:	0586c683          	lbu	a3,88(a3)
    80002654:	00d7f5b3          	and	a1,a5,a3
    80002658:	cd91                	beqz	a1,80002674 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000265a:	2605                	addiw	a2,a2,1
    8000265c:	2485                	addiw	s1,s1,1
    8000265e:	fd4618e3          	bne	a2,s4,8000262e <balloc+0x80>
    80002662:	b759                	j	800025e8 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002664:	00007517          	auipc	a0,0x7
    80002668:	eb450513          	addi	a0,a0,-332 # 80009518 <syscalls+0x140>
    8000266c:	00004097          	auipc	ra,0x4
    80002670:	588080e7          	jalr	1416(ra) # 80006bf4 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002674:	974a                	add	a4,a4,s2
    80002676:	8fd5                	or	a5,a5,a3
    80002678:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000267c:	854a                	mv	a0,s2
    8000267e:	00001097          	auipc	ra,0x1
    80002682:	01a080e7          	jalr	26(ra) # 80003698 <log_write>
        brelse(bp);
    80002686:	854a                	mv	a0,s2
    80002688:	00000097          	auipc	ra,0x0
    8000268c:	d94080e7          	jalr	-620(ra) # 8000241c <brelse>
  bp = bread(dev, bno);
    80002690:	85a6                	mv	a1,s1
    80002692:	855e                	mv	a0,s7
    80002694:	00000097          	auipc	ra,0x0
    80002698:	c58080e7          	jalr	-936(ra) # 800022ec <bread>
    8000269c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000269e:	40000613          	li	a2,1024
    800026a2:	4581                	li	a1,0
    800026a4:	05850513          	addi	a0,a0,88
    800026a8:	ffffe097          	auipc	ra,0xffffe
    800026ac:	ad0080e7          	jalr	-1328(ra) # 80000178 <memset>
  log_write(bp);
    800026b0:	854a                	mv	a0,s2
    800026b2:	00001097          	auipc	ra,0x1
    800026b6:	fe6080e7          	jalr	-26(ra) # 80003698 <log_write>
  brelse(bp);
    800026ba:	854a                	mv	a0,s2
    800026bc:	00000097          	auipc	ra,0x0
    800026c0:	d60080e7          	jalr	-672(ra) # 8000241c <brelse>
}
    800026c4:	8526                	mv	a0,s1
    800026c6:	60e6                	ld	ra,88(sp)
    800026c8:	6446                	ld	s0,80(sp)
    800026ca:	64a6                	ld	s1,72(sp)
    800026cc:	6906                	ld	s2,64(sp)
    800026ce:	79e2                	ld	s3,56(sp)
    800026d0:	7a42                	ld	s4,48(sp)
    800026d2:	7aa2                	ld	s5,40(sp)
    800026d4:	7b02                	ld	s6,32(sp)
    800026d6:	6be2                	ld	s7,24(sp)
    800026d8:	6c42                	ld	s8,16(sp)
    800026da:	6ca2                	ld	s9,8(sp)
    800026dc:	6125                	addi	sp,sp,96
    800026de:	8082                	ret

00000000800026e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800026e0:	7179                	addi	sp,sp,-48
    800026e2:	f406                	sd	ra,40(sp)
    800026e4:	f022                	sd	s0,32(sp)
    800026e6:	ec26                	sd	s1,24(sp)
    800026e8:	e84a                	sd	s2,16(sp)
    800026ea:	e44e                	sd	s3,8(sp)
    800026ec:	e052                	sd	s4,0(sp)
    800026ee:	1800                	addi	s0,sp,48
    800026f0:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026f2:	47ad                	li	a5,11
    800026f4:	04b7fe63          	bgeu	a5,a1,80002750 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800026f8:	ff45849b          	addiw	s1,a1,-12
    800026fc:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002700:	0ff00793          	li	a5,255
    80002704:	0ae7e363          	bltu	a5,a4,800027aa <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002708:	08052583          	lw	a1,128(a0)
    8000270c:	c5ad                	beqz	a1,80002776 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000270e:	00092503          	lw	a0,0(s2)
    80002712:	00000097          	auipc	ra,0x0
    80002716:	bda080e7          	jalr	-1062(ra) # 800022ec <bread>
    8000271a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000271c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002720:	02049593          	slli	a1,s1,0x20
    80002724:	9181                	srli	a1,a1,0x20
    80002726:	058a                	slli	a1,a1,0x2
    80002728:	00b784b3          	add	s1,a5,a1
    8000272c:	0004a983          	lw	s3,0(s1)
    80002730:	04098d63          	beqz	s3,8000278a <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002734:	8552                	mv	a0,s4
    80002736:	00000097          	auipc	ra,0x0
    8000273a:	ce6080e7          	jalr	-794(ra) # 8000241c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000273e:	854e                	mv	a0,s3
    80002740:	70a2                	ld	ra,40(sp)
    80002742:	7402                	ld	s0,32(sp)
    80002744:	64e2                	ld	s1,24(sp)
    80002746:	6942                	ld	s2,16(sp)
    80002748:	69a2                	ld	s3,8(sp)
    8000274a:	6a02                	ld	s4,0(sp)
    8000274c:	6145                	addi	sp,sp,48
    8000274e:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002750:	02059493          	slli	s1,a1,0x20
    80002754:	9081                	srli	s1,s1,0x20
    80002756:	048a                	slli	s1,s1,0x2
    80002758:	94aa                	add	s1,s1,a0
    8000275a:	0504a983          	lw	s3,80(s1)
    8000275e:	fe0990e3          	bnez	s3,8000273e <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002762:	4108                	lw	a0,0(a0)
    80002764:	00000097          	auipc	ra,0x0
    80002768:	e4a080e7          	jalr	-438(ra) # 800025ae <balloc>
    8000276c:	0005099b          	sext.w	s3,a0
    80002770:	0534a823          	sw	s3,80(s1)
    80002774:	b7e9                	j	8000273e <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002776:	4108                	lw	a0,0(a0)
    80002778:	00000097          	auipc	ra,0x0
    8000277c:	e36080e7          	jalr	-458(ra) # 800025ae <balloc>
    80002780:	0005059b          	sext.w	a1,a0
    80002784:	08b92023          	sw	a1,128(s2)
    80002788:	b759                	j	8000270e <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000278a:	00092503          	lw	a0,0(s2)
    8000278e:	00000097          	auipc	ra,0x0
    80002792:	e20080e7          	jalr	-480(ra) # 800025ae <balloc>
    80002796:	0005099b          	sext.w	s3,a0
    8000279a:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000279e:	8552                	mv	a0,s4
    800027a0:	00001097          	auipc	ra,0x1
    800027a4:	ef8080e7          	jalr	-264(ra) # 80003698 <log_write>
    800027a8:	b771                	j	80002734 <bmap+0x54>
  panic("bmap: out of range");
    800027aa:	00007517          	auipc	a0,0x7
    800027ae:	d8650513          	addi	a0,a0,-634 # 80009530 <syscalls+0x158>
    800027b2:	00004097          	auipc	ra,0x4
    800027b6:	442080e7          	jalr	1090(ra) # 80006bf4 <panic>

00000000800027ba <iget>:
{
    800027ba:	7179                	addi	sp,sp,-48
    800027bc:	f406                	sd	ra,40(sp)
    800027be:	f022                	sd	s0,32(sp)
    800027c0:	ec26                	sd	s1,24(sp)
    800027c2:	e84a                	sd	s2,16(sp)
    800027c4:	e44e                	sd	s3,8(sp)
    800027c6:	e052                	sd	s4,0(sp)
    800027c8:	1800                	addi	s0,sp,48
    800027ca:	89aa                	mv	s3,a0
    800027cc:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027ce:	00016517          	auipc	a0,0x16
    800027d2:	dca50513          	addi	a0,a0,-566 # 80018598 <itable>
    800027d6:	00005097          	auipc	ra,0x5
    800027da:	968080e7          	jalr	-1688(ra) # 8000713e <acquire>
  empty = 0;
    800027de:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027e0:	00016497          	auipc	s1,0x16
    800027e4:	dd048493          	addi	s1,s1,-560 # 800185b0 <itable+0x18>
    800027e8:	00018697          	auipc	a3,0x18
    800027ec:	85868693          	addi	a3,a3,-1960 # 8001a040 <log>
    800027f0:	a039                	j	800027fe <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027f2:	02090b63          	beqz	s2,80002828 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027f6:	08848493          	addi	s1,s1,136
    800027fa:	02d48a63          	beq	s1,a3,8000282e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027fe:	449c                	lw	a5,8(s1)
    80002800:	fef059e3          	blez	a5,800027f2 <iget+0x38>
    80002804:	4098                	lw	a4,0(s1)
    80002806:	ff3716e3          	bne	a4,s3,800027f2 <iget+0x38>
    8000280a:	40d8                	lw	a4,4(s1)
    8000280c:	ff4713e3          	bne	a4,s4,800027f2 <iget+0x38>
      ip->ref++;
    80002810:	2785                	addiw	a5,a5,1
    80002812:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002814:	00016517          	auipc	a0,0x16
    80002818:	d8450513          	addi	a0,a0,-636 # 80018598 <itable>
    8000281c:	00005097          	auipc	ra,0x5
    80002820:	9d6080e7          	jalr	-1578(ra) # 800071f2 <release>
      return ip;
    80002824:	8926                	mv	s2,s1
    80002826:	a03d                	j	80002854 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002828:	f7f9                	bnez	a5,800027f6 <iget+0x3c>
    8000282a:	8926                	mv	s2,s1
    8000282c:	b7e9                	j	800027f6 <iget+0x3c>
  if(empty == 0)
    8000282e:	02090c63          	beqz	s2,80002866 <iget+0xac>
  ip->dev = dev;
    80002832:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002836:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000283a:	4785                	li	a5,1
    8000283c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002840:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002844:	00016517          	auipc	a0,0x16
    80002848:	d5450513          	addi	a0,a0,-684 # 80018598 <itable>
    8000284c:	00005097          	auipc	ra,0x5
    80002850:	9a6080e7          	jalr	-1626(ra) # 800071f2 <release>
}
    80002854:	854a                	mv	a0,s2
    80002856:	70a2                	ld	ra,40(sp)
    80002858:	7402                	ld	s0,32(sp)
    8000285a:	64e2                	ld	s1,24(sp)
    8000285c:	6942                	ld	s2,16(sp)
    8000285e:	69a2                	ld	s3,8(sp)
    80002860:	6a02                	ld	s4,0(sp)
    80002862:	6145                	addi	sp,sp,48
    80002864:	8082                	ret
    panic("iget: no inodes");
    80002866:	00007517          	auipc	a0,0x7
    8000286a:	ce250513          	addi	a0,a0,-798 # 80009548 <syscalls+0x170>
    8000286e:	00004097          	auipc	ra,0x4
    80002872:	386080e7          	jalr	902(ra) # 80006bf4 <panic>

0000000080002876 <fsinit>:
fsinit(int dev) {
    80002876:	7179                	addi	sp,sp,-48
    80002878:	f406                	sd	ra,40(sp)
    8000287a:	f022                	sd	s0,32(sp)
    8000287c:	ec26                	sd	s1,24(sp)
    8000287e:	e84a                	sd	s2,16(sp)
    80002880:	e44e                	sd	s3,8(sp)
    80002882:	1800                	addi	s0,sp,48
    80002884:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002886:	4585                	li	a1,1
    80002888:	00000097          	auipc	ra,0x0
    8000288c:	a64080e7          	jalr	-1436(ra) # 800022ec <bread>
    80002890:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002892:	00016997          	auipc	s3,0x16
    80002896:	ce698993          	addi	s3,s3,-794 # 80018578 <sb>
    8000289a:	02000613          	li	a2,32
    8000289e:	05850593          	addi	a1,a0,88
    800028a2:	854e                	mv	a0,s3
    800028a4:	ffffe097          	auipc	ra,0xffffe
    800028a8:	934080e7          	jalr	-1740(ra) # 800001d8 <memmove>
  brelse(bp);
    800028ac:	8526                	mv	a0,s1
    800028ae:	00000097          	auipc	ra,0x0
    800028b2:	b6e080e7          	jalr	-1170(ra) # 8000241c <brelse>
  if(sb.magic != FSMAGIC)
    800028b6:	0009a703          	lw	a4,0(s3)
    800028ba:	102037b7          	lui	a5,0x10203
    800028be:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028c2:	02f71263          	bne	a4,a5,800028e6 <fsinit+0x70>
  initlog(dev, &sb);
    800028c6:	00016597          	auipc	a1,0x16
    800028ca:	cb258593          	addi	a1,a1,-846 # 80018578 <sb>
    800028ce:	854a                	mv	a0,s2
    800028d0:	00001097          	auipc	ra,0x1
    800028d4:	b4c080e7          	jalr	-1204(ra) # 8000341c <initlog>
}
    800028d8:	70a2                	ld	ra,40(sp)
    800028da:	7402                	ld	s0,32(sp)
    800028dc:	64e2                	ld	s1,24(sp)
    800028de:	6942                	ld	s2,16(sp)
    800028e0:	69a2                	ld	s3,8(sp)
    800028e2:	6145                	addi	sp,sp,48
    800028e4:	8082                	ret
    panic("invalid file system");
    800028e6:	00007517          	auipc	a0,0x7
    800028ea:	c7250513          	addi	a0,a0,-910 # 80009558 <syscalls+0x180>
    800028ee:	00004097          	auipc	ra,0x4
    800028f2:	306080e7          	jalr	774(ra) # 80006bf4 <panic>

00000000800028f6 <iinit>:
{
    800028f6:	7179                	addi	sp,sp,-48
    800028f8:	f406                	sd	ra,40(sp)
    800028fa:	f022                	sd	s0,32(sp)
    800028fc:	ec26                	sd	s1,24(sp)
    800028fe:	e84a                	sd	s2,16(sp)
    80002900:	e44e                	sd	s3,8(sp)
    80002902:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002904:	00007597          	auipc	a1,0x7
    80002908:	c6c58593          	addi	a1,a1,-916 # 80009570 <syscalls+0x198>
    8000290c:	00016517          	auipc	a0,0x16
    80002910:	c8c50513          	addi	a0,a0,-884 # 80018598 <itable>
    80002914:	00004097          	auipc	ra,0x4
    80002918:	79a080e7          	jalr	1946(ra) # 800070ae <initlock>
  for(i = 0; i < NINODE; i++) {
    8000291c:	00016497          	auipc	s1,0x16
    80002920:	ca448493          	addi	s1,s1,-860 # 800185c0 <itable+0x28>
    80002924:	00017997          	auipc	s3,0x17
    80002928:	72c98993          	addi	s3,s3,1836 # 8001a050 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000292c:	00007917          	auipc	s2,0x7
    80002930:	c4c90913          	addi	s2,s2,-948 # 80009578 <syscalls+0x1a0>
    80002934:	85ca                	mv	a1,s2
    80002936:	8526                	mv	a0,s1
    80002938:	00001097          	auipc	ra,0x1
    8000293c:	e46080e7          	jalr	-442(ra) # 8000377e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002940:	08848493          	addi	s1,s1,136
    80002944:	ff3498e3          	bne	s1,s3,80002934 <iinit+0x3e>
}
    80002948:	70a2                	ld	ra,40(sp)
    8000294a:	7402                	ld	s0,32(sp)
    8000294c:	64e2                	ld	s1,24(sp)
    8000294e:	6942                	ld	s2,16(sp)
    80002950:	69a2                	ld	s3,8(sp)
    80002952:	6145                	addi	sp,sp,48
    80002954:	8082                	ret

0000000080002956 <ialloc>:
{
    80002956:	715d                	addi	sp,sp,-80
    80002958:	e486                	sd	ra,72(sp)
    8000295a:	e0a2                	sd	s0,64(sp)
    8000295c:	fc26                	sd	s1,56(sp)
    8000295e:	f84a                	sd	s2,48(sp)
    80002960:	f44e                	sd	s3,40(sp)
    80002962:	f052                	sd	s4,32(sp)
    80002964:	ec56                	sd	s5,24(sp)
    80002966:	e85a                	sd	s6,16(sp)
    80002968:	e45e                	sd	s7,8(sp)
    8000296a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    8000296c:	00016717          	auipc	a4,0x16
    80002970:	c1872703          	lw	a4,-1000(a4) # 80018584 <sb+0xc>
    80002974:	4785                	li	a5,1
    80002976:	04e7fa63          	bgeu	a5,a4,800029ca <ialloc+0x74>
    8000297a:	8aaa                	mv	s5,a0
    8000297c:	8bae                	mv	s7,a1
    8000297e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002980:	00016a17          	auipc	s4,0x16
    80002984:	bf8a0a13          	addi	s4,s4,-1032 # 80018578 <sb>
    80002988:	00048b1b          	sext.w	s6,s1
    8000298c:	0044d593          	srli	a1,s1,0x4
    80002990:	018a2783          	lw	a5,24(s4)
    80002994:	9dbd                	addw	a1,a1,a5
    80002996:	8556                	mv	a0,s5
    80002998:	00000097          	auipc	ra,0x0
    8000299c:	954080e7          	jalr	-1708(ra) # 800022ec <bread>
    800029a0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029a2:	05850993          	addi	s3,a0,88
    800029a6:	00f4f793          	andi	a5,s1,15
    800029aa:	079a                	slli	a5,a5,0x6
    800029ac:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029ae:	00099783          	lh	a5,0(s3)
    800029b2:	c785                	beqz	a5,800029da <ialloc+0x84>
    brelse(bp);
    800029b4:	00000097          	auipc	ra,0x0
    800029b8:	a68080e7          	jalr	-1432(ra) # 8000241c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029bc:	0485                	addi	s1,s1,1
    800029be:	00ca2703          	lw	a4,12(s4)
    800029c2:	0004879b          	sext.w	a5,s1
    800029c6:	fce7e1e3          	bltu	a5,a4,80002988 <ialloc+0x32>
  panic("ialloc: no inodes");
    800029ca:	00007517          	auipc	a0,0x7
    800029ce:	bb650513          	addi	a0,a0,-1098 # 80009580 <syscalls+0x1a8>
    800029d2:	00004097          	auipc	ra,0x4
    800029d6:	222080e7          	jalr	546(ra) # 80006bf4 <panic>
      memset(dip, 0, sizeof(*dip));
    800029da:	04000613          	li	a2,64
    800029de:	4581                	li	a1,0
    800029e0:	854e                	mv	a0,s3
    800029e2:	ffffd097          	auipc	ra,0xffffd
    800029e6:	796080e7          	jalr	1942(ra) # 80000178 <memset>
      dip->type = type;
    800029ea:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800029ee:	854a                	mv	a0,s2
    800029f0:	00001097          	auipc	ra,0x1
    800029f4:	ca8080e7          	jalr	-856(ra) # 80003698 <log_write>
      brelse(bp);
    800029f8:	854a                	mv	a0,s2
    800029fa:	00000097          	auipc	ra,0x0
    800029fe:	a22080e7          	jalr	-1502(ra) # 8000241c <brelse>
      return iget(dev, inum);
    80002a02:	85da                	mv	a1,s6
    80002a04:	8556                	mv	a0,s5
    80002a06:	00000097          	auipc	ra,0x0
    80002a0a:	db4080e7          	jalr	-588(ra) # 800027ba <iget>
}
    80002a0e:	60a6                	ld	ra,72(sp)
    80002a10:	6406                	ld	s0,64(sp)
    80002a12:	74e2                	ld	s1,56(sp)
    80002a14:	7942                	ld	s2,48(sp)
    80002a16:	79a2                	ld	s3,40(sp)
    80002a18:	7a02                	ld	s4,32(sp)
    80002a1a:	6ae2                	ld	s5,24(sp)
    80002a1c:	6b42                	ld	s6,16(sp)
    80002a1e:	6ba2                	ld	s7,8(sp)
    80002a20:	6161                	addi	sp,sp,80
    80002a22:	8082                	ret

0000000080002a24 <iupdate>:
{
    80002a24:	1101                	addi	sp,sp,-32
    80002a26:	ec06                	sd	ra,24(sp)
    80002a28:	e822                	sd	s0,16(sp)
    80002a2a:	e426                	sd	s1,8(sp)
    80002a2c:	e04a                	sd	s2,0(sp)
    80002a2e:	1000                	addi	s0,sp,32
    80002a30:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a32:	415c                	lw	a5,4(a0)
    80002a34:	0047d79b          	srliw	a5,a5,0x4
    80002a38:	00016597          	auipc	a1,0x16
    80002a3c:	b585a583          	lw	a1,-1192(a1) # 80018590 <sb+0x18>
    80002a40:	9dbd                	addw	a1,a1,a5
    80002a42:	4108                	lw	a0,0(a0)
    80002a44:	00000097          	auipc	ra,0x0
    80002a48:	8a8080e7          	jalr	-1880(ra) # 800022ec <bread>
    80002a4c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a4e:	05850793          	addi	a5,a0,88
    80002a52:	40c8                	lw	a0,4(s1)
    80002a54:	893d                	andi	a0,a0,15
    80002a56:	051a                	slli	a0,a0,0x6
    80002a58:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002a5a:	04449703          	lh	a4,68(s1)
    80002a5e:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002a62:	04649703          	lh	a4,70(s1)
    80002a66:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002a6a:	04849703          	lh	a4,72(s1)
    80002a6e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002a72:	04a49703          	lh	a4,74(s1)
    80002a76:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002a7a:	44f8                	lw	a4,76(s1)
    80002a7c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a7e:	03400613          	li	a2,52
    80002a82:	05048593          	addi	a1,s1,80
    80002a86:	0531                	addi	a0,a0,12
    80002a88:	ffffd097          	auipc	ra,0xffffd
    80002a8c:	750080e7          	jalr	1872(ra) # 800001d8 <memmove>
  log_write(bp);
    80002a90:	854a                	mv	a0,s2
    80002a92:	00001097          	auipc	ra,0x1
    80002a96:	c06080e7          	jalr	-1018(ra) # 80003698 <log_write>
  brelse(bp);
    80002a9a:	854a                	mv	a0,s2
    80002a9c:	00000097          	auipc	ra,0x0
    80002aa0:	980080e7          	jalr	-1664(ra) # 8000241c <brelse>
}
    80002aa4:	60e2                	ld	ra,24(sp)
    80002aa6:	6442                	ld	s0,16(sp)
    80002aa8:	64a2                	ld	s1,8(sp)
    80002aaa:	6902                	ld	s2,0(sp)
    80002aac:	6105                	addi	sp,sp,32
    80002aae:	8082                	ret

0000000080002ab0 <idup>:
{
    80002ab0:	1101                	addi	sp,sp,-32
    80002ab2:	ec06                	sd	ra,24(sp)
    80002ab4:	e822                	sd	s0,16(sp)
    80002ab6:	e426                	sd	s1,8(sp)
    80002ab8:	1000                	addi	s0,sp,32
    80002aba:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002abc:	00016517          	auipc	a0,0x16
    80002ac0:	adc50513          	addi	a0,a0,-1316 # 80018598 <itable>
    80002ac4:	00004097          	auipc	ra,0x4
    80002ac8:	67a080e7          	jalr	1658(ra) # 8000713e <acquire>
  ip->ref++;
    80002acc:	449c                	lw	a5,8(s1)
    80002ace:	2785                	addiw	a5,a5,1
    80002ad0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ad2:	00016517          	auipc	a0,0x16
    80002ad6:	ac650513          	addi	a0,a0,-1338 # 80018598 <itable>
    80002ada:	00004097          	auipc	ra,0x4
    80002ade:	718080e7          	jalr	1816(ra) # 800071f2 <release>
}
    80002ae2:	8526                	mv	a0,s1
    80002ae4:	60e2                	ld	ra,24(sp)
    80002ae6:	6442                	ld	s0,16(sp)
    80002ae8:	64a2                	ld	s1,8(sp)
    80002aea:	6105                	addi	sp,sp,32
    80002aec:	8082                	ret

0000000080002aee <ilock>:
{
    80002aee:	1101                	addi	sp,sp,-32
    80002af0:	ec06                	sd	ra,24(sp)
    80002af2:	e822                	sd	s0,16(sp)
    80002af4:	e426                	sd	s1,8(sp)
    80002af6:	e04a                	sd	s2,0(sp)
    80002af8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002afa:	c115                	beqz	a0,80002b1e <ilock+0x30>
    80002afc:	84aa                	mv	s1,a0
    80002afe:	451c                	lw	a5,8(a0)
    80002b00:	00f05f63          	blez	a5,80002b1e <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b04:	0541                	addi	a0,a0,16
    80002b06:	00001097          	auipc	ra,0x1
    80002b0a:	cb2080e7          	jalr	-846(ra) # 800037b8 <acquiresleep>
  if(ip->valid == 0){
    80002b0e:	40bc                	lw	a5,64(s1)
    80002b10:	cf99                	beqz	a5,80002b2e <ilock+0x40>
}
    80002b12:	60e2                	ld	ra,24(sp)
    80002b14:	6442                	ld	s0,16(sp)
    80002b16:	64a2                	ld	s1,8(sp)
    80002b18:	6902                	ld	s2,0(sp)
    80002b1a:	6105                	addi	sp,sp,32
    80002b1c:	8082                	ret
    panic("ilock");
    80002b1e:	00007517          	auipc	a0,0x7
    80002b22:	a7a50513          	addi	a0,a0,-1414 # 80009598 <syscalls+0x1c0>
    80002b26:	00004097          	auipc	ra,0x4
    80002b2a:	0ce080e7          	jalr	206(ra) # 80006bf4 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b2e:	40dc                	lw	a5,4(s1)
    80002b30:	0047d79b          	srliw	a5,a5,0x4
    80002b34:	00016597          	auipc	a1,0x16
    80002b38:	a5c5a583          	lw	a1,-1444(a1) # 80018590 <sb+0x18>
    80002b3c:	9dbd                	addw	a1,a1,a5
    80002b3e:	4088                	lw	a0,0(s1)
    80002b40:	fffff097          	auipc	ra,0xfffff
    80002b44:	7ac080e7          	jalr	1964(ra) # 800022ec <bread>
    80002b48:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b4a:	05850593          	addi	a1,a0,88
    80002b4e:	40dc                	lw	a5,4(s1)
    80002b50:	8bbd                	andi	a5,a5,15
    80002b52:	079a                	slli	a5,a5,0x6
    80002b54:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b56:	00059783          	lh	a5,0(a1)
    80002b5a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b5e:	00259783          	lh	a5,2(a1)
    80002b62:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b66:	00459783          	lh	a5,4(a1)
    80002b6a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b6e:	00659783          	lh	a5,6(a1)
    80002b72:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b76:	459c                	lw	a5,8(a1)
    80002b78:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b7a:	03400613          	li	a2,52
    80002b7e:	05b1                	addi	a1,a1,12
    80002b80:	05048513          	addi	a0,s1,80
    80002b84:	ffffd097          	auipc	ra,0xffffd
    80002b88:	654080e7          	jalr	1620(ra) # 800001d8 <memmove>
    brelse(bp);
    80002b8c:	854a                	mv	a0,s2
    80002b8e:	00000097          	auipc	ra,0x0
    80002b92:	88e080e7          	jalr	-1906(ra) # 8000241c <brelse>
    ip->valid = 1;
    80002b96:	4785                	li	a5,1
    80002b98:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b9a:	04449783          	lh	a5,68(s1)
    80002b9e:	fbb5                	bnez	a5,80002b12 <ilock+0x24>
      panic("ilock: no type");
    80002ba0:	00007517          	auipc	a0,0x7
    80002ba4:	a0050513          	addi	a0,a0,-1536 # 800095a0 <syscalls+0x1c8>
    80002ba8:	00004097          	auipc	ra,0x4
    80002bac:	04c080e7          	jalr	76(ra) # 80006bf4 <panic>

0000000080002bb0 <iunlock>:
{
    80002bb0:	1101                	addi	sp,sp,-32
    80002bb2:	ec06                	sd	ra,24(sp)
    80002bb4:	e822                	sd	s0,16(sp)
    80002bb6:	e426                	sd	s1,8(sp)
    80002bb8:	e04a                	sd	s2,0(sp)
    80002bba:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bbc:	c905                	beqz	a0,80002bec <iunlock+0x3c>
    80002bbe:	84aa                	mv	s1,a0
    80002bc0:	01050913          	addi	s2,a0,16
    80002bc4:	854a                	mv	a0,s2
    80002bc6:	00001097          	auipc	ra,0x1
    80002bca:	c8c080e7          	jalr	-884(ra) # 80003852 <holdingsleep>
    80002bce:	cd19                	beqz	a0,80002bec <iunlock+0x3c>
    80002bd0:	449c                	lw	a5,8(s1)
    80002bd2:	00f05d63          	blez	a5,80002bec <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bd6:	854a                	mv	a0,s2
    80002bd8:	00001097          	auipc	ra,0x1
    80002bdc:	c36080e7          	jalr	-970(ra) # 8000380e <releasesleep>
}
    80002be0:	60e2                	ld	ra,24(sp)
    80002be2:	6442                	ld	s0,16(sp)
    80002be4:	64a2                	ld	s1,8(sp)
    80002be6:	6902                	ld	s2,0(sp)
    80002be8:	6105                	addi	sp,sp,32
    80002bea:	8082                	ret
    panic("iunlock");
    80002bec:	00007517          	auipc	a0,0x7
    80002bf0:	9c450513          	addi	a0,a0,-1596 # 800095b0 <syscalls+0x1d8>
    80002bf4:	00004097          	auipc	ra,0x4
    80002bf8:	000080e7          	jalr	ra # 80006bf4 <panic>

0000000080002bfc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002bfc:	7179                	addi	sp,sp,-48
    80002bfe:	f406                	sd	ra,40(sp)
    80002c00:	f022                	sd	s0,32(sp)
    80002c02:	ec26                	sd	s1,24(sp)
    80002c04:	e84a                	sd	s2,16(sp)
    80002c06:	e44e                	sd	s3,8(sp)
    80002c08:	e052                	sd	s4,0(sp)
    80002c0a:	1800                	addi	s0,sp,48
    80002c0c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c0e:	05050493          	addi	s1,a0,80
    80002c12:	08050913          	addi	s2,a0,128
    80002c16:	a021                	j	80002c1e <itrunc+0x22>
    80002c18:	0491                	addi	s1,s1,4
    80002c1a:	01248d63          	beq	s1,s2,80002c34 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c1e:	408c                	lw	a1,0(s1)
    80002c20:	dde5                	beqz	a1,80002c18 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c22:	0009a503          	lw	a0,0(s3)
    80002c26:	00000097          	auipc	ra,0x0
    80002c2a:	90c080e7          	jalr	-1780(ra) # 80002532 <bfree>
      ip->addrs[i] = 0;
    80002c2e:	0004a023          	sw	zero,0(s1)
    80002c32:	b7dd                	j	80002c18 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c34:	0809a583          	lw	a1,128(s3)
    80002c38:	e185                	bnez	a1,80002c58 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c3a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c3e:	854e                	mv	a0,s3
    80002c40:	00000097          	auipc	ra,0x0
    80002c44:	de4080e7          	jalr	-540(ra) # 80002a24 <iupdate>
}
    80002c48:	70a2                	ld	ra,40(sp)
    80002c4a:	7402                	ld	s0,32(sp)
    80002c4c:	64e2                	ld	s1,24(sp)
    80002c4e:	6942                	ld	s2,16(sp)
    80002c50:	69a2                	ld	s3,8(sp)
    80002c52:	6a02                	ld	s4,0(sp)
    80002c54:	6145                	addi	sp,sp,48
    80002c56:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c58:	0009a503          	lw	a0,0(s3)
    80002c5c:	fffff097          	auipc	ra,0xfffff
    80002c60:	690080e7          	jalr	1680(ra) # 800022ec <bread>
    80002c64:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c66:	05850493          	addi	s1,a0,88
    80002c6a:	45850913          	addi	s2,a0,1112
    80002c6e:	a811                	j	80002c82 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002c70:	0009a503          	lw	a0,0(s3)
    80002c74:	00000097          	auipc	ra,0x0
    80002c78:	8be080e7          	jalr	-1858(ra) # 80002532 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002c7c:	0491                	addi	s1,s1,4
    80002c7e:	01248563          	beq	s1,s2,80002c88 <itrunc+0x8c>
      if(a[j])
    80002c82:	408c                	lw	a1,0(s1)
    80002c84:	dde5                	beqz	a1,80002c7c <itrunc+0x80>
    80002c86:	b7ed                	j	80002c70 <itrunc+0x74>
    brelse(bp);
    80002c88:	8552                	mv	a0,s4
    80002c8a:	fffff097          	auipc	ra,0xfffff
    80002c8e:	792080e7          	jalr	1938(ra) # 8000241c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c92:	0809a583          	lw	a1,128(s3)
    80002c96:	0009a503          	lw	a0,0(s3)
    80002c9a:	00000097          	auipc	ra,0x0
    80002c9e:	898080e7          	jalr	-1896(ra) # 80002532 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ca2:	0809a023          	sw	zero,128(s3)
    80002ca6:	bf51                	j	80002c3a <itrunc+0x3e>

0000000080002ca8 <iput>:
{
    80002ca8:	1101                	addi	sp,sp,-32
    80002caa:	ec06                	sd	ra,24(sp)
    80002cac:	e822                	sd	s0,16(sp)
    80002cae:	e426                	sd	s1,8(sp)
    80002cb0:	e04a                	sd	s2,0(sp)
    80002cb2:	1000                	addi	s0,sp,32
    80002cb4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cb6:	00016517          	auipc	a0,0x16
    80002cba:	8e250513          	addi	a0,a0,-1822 # 80018598 <itable>
    80002cbe:	00004097          	auipc	ra,0x4
    80002cc2:	480080e7          	jalr	1152(ra) # 8000713e <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cc6:	4498                	lw	a4,8(s1)
    80002cc8:	4785                	li	a5,1
    80002cca:	02f70363          	beq	a4,a5,80002cf0 <iput+0x48>
  ip->ref--;
    80002cce:	449c                	lw	a5,8(s1)
    80002cd0:	37fd                	addiw	a5,a5,-1
    80002cd2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cd4:	00016517          	auipc	a0,0x16
    80002cd8:	8c450513          	addi	a0,a0,-1852 # 80018598 <itable>
    80002cdc:	00004097          	auipc	ra,0x4
    80002ce0:	516080e7          	jalr	1302(ra) # 800071f2 <release>
}
    80002ce4:	60e2                	ld	ra,24(sp)
    80002ce6:	6442                	ld	s0,16(sp)
    80002ce8:	64a2                	ld	s1,8(sp)
    80002cea:	6902                	ld	s2,0(sp)
    80002cec:	6105                	addi	sp,sp,32
    80002cee:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cf0:	40bc                	lw	a5,64(s1)
    80002cf2:	dff1                	beqz	a5,80002cce <iput+0x26>
    80002cf4:	04a49783          	lh	a5,74(s1)
    80002cf8:	fbf9                	bnez	a5,80002cce <iput+0x26>
    acquiresleep(&ip->lock);
    80002cfa:	01048913          	addi	s2,s1,16
    80002cfe:	854a                	mv	a0,s2
    80002d00:	00001097          	auipc	ra,0x1
    80002d04:	ab8080e7          	jalr	-1352(ra) # 800037b8 <acquiresleep>
    release(&itable.lock);
    80002d08:	00016517          	auipc	a0,0x16
    80002d0c:	89050513          	addi	a0,a0,-1904 # 80018598 <itable>
    80002d10:	00004097          	auipc	ra,0x4
    80002d14:	4e2080e7          	jalr	1250(ra) # 800071f2 <release>
    itrunc(ip);
    80002d18:	8526                	mv	a0,s1
    80002d1a:	00000097          	auipc	ra,0x0
    80002d1e:	ee2080e7          	jalr	-286(ra) # 80002bfc <itrunc>
    ip->type = 0;
    80002d22:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d26:	8526                	mv	a0,s1
    80002d28:	00000097          	auipc	ra,0x0
    80002d2c:	cfc080e7          	jalr	-772(ra) # 80002a24 <iupdate>
    ip->valid = 0;
    80002d30:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d34:	854a                	mv	a0,s2
    80002d36:	00001097          	auipc	ra,0x1
    80002d3a:	ad8080e7          	jalr	-1320(ra) # 8000380e <releasesleep>
    acquire(&itable.lock);
    80002d3e:	00016517          	auipc	a0,0x16
    80002d42:	85a50513          	addi	a0,a0,-1958 # 80018598 <itable>
    80002d46:	00004097          	auipc	ra,0x4
    80002d4a:	3f8080e7          	jalr	1016(ra) # 8000713e <acquire>
    80002d4e:	b741                	j	80002cce <iput+0x26>

0000000080002d50 <iunlockput>:
{
    80002d50:	1101                	addi	sp,sp,-32
    80002d52:	ec06                	sd	ra,24(sp)
    80002d54:	e822                	sd	s0,16(sp)
    80002d56:	e426                	sd	s1,8(sp)
    80002d58:	1000                	addi	s0,sp,32
    80002d5a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d5c:	00000097          	auipc	ra,0x0
    80002d60:	e54080e7          	jalr	-428(ra) # 80002bb0 <iunlock>
  iput(ip);
    80002d64:	8526                	mv	a0,s1
    80002d66:	00000097          	auipc	ra,0x0
    80002d6a:	f42080e7          	jalr	-190(ra) # 80002ca8 <iput>
}
    80002d6e:	60e2                	ld	ra,24(sp)
    80002d70:	6442                	ld	s0,16(sp)
    80002d72:	64a2                	ld	s1,8(sp)
    80002d74:	6105                	addi	sp,sp,32
    80002d76:	8082                	ret

0000000080002d78 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d78:	1141                	addi	sp,sp,-16
    80002d7a:	e422                	sd	s0,8(sp)
    80002d7c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d7e:	411c                	lw	a5,0(a0)
    80002d80:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d82:	415c                	lw	a5,4(a0)
    80002d84:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d86:	04451783          	lh	a5,68(a0)
    80002d8a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d8e:	04a51783          	lh	a5,74(a0)
    80002d92:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d96:	04c56783          	lwu	a5,76(a0)
    80002d9a:	e99c                	sd	a5,16(a1)
}
    80002d9c:	6422                	ld	s0,8(sp)
    80002d9e:	0141                	addi	sp,sp,16
    80002da0:	8082                	ret

0000000080002da2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002da2:	457c                	lw	a5,76(a0)
    80002da4:	0ed7e963          	bltu	a5,a3,80002e96 <readi+0xf4>
{
    80002da8:	7159                	addi	sp,sp,-112
    80002daa:	f486                	sd	ra,104(sp)
    80002dac:	f0a2                	sd	s0,96(sp)
    80002dae:	eca6                	sd	s1,88(sp)
    80002db0:	e8ca                	sd	s2,80(sp)
    80002db2:	e4ce                	sd	s3,72(sp)
    80002db4:	e0d2                	sd	s4,64(sp)
    80002db6:	fc56                	sd	s5,56(sp)
    80002db8:	f85a                	sd	s6,48(sp)
    80002dba:	f45e                	sd	s7,40(sp)
    80002dbc:	f062                	sd	s8,32(sp)
    80002dbe:	ec66                	sd	s9,24(sp)
    80002dc0:	e86a                	sd	s10,16(sp)
    80002dc2:	e46e                	sd	s11,8(sp)
    80002dc4:	1880                	addi	s0,sp,112
    80002dc6:	8baa                	mv	s7,a0
    80002dc8:	8c2e                	mv	s8,a1
    80002dca:	8ab2                	mv	s5,a2
    80002dcc:	84b6                	mv	s1,a3
    80002dce:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002dd0:	9f35                	addw	a4,a4,a3
    return 0;
    80002dd2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002dd4:	0ad76063          	bltu	a4,a3,80002e74 <readi+0xd2>
  if(off + n > ip->size)
    80002dd8:	00e7f463          	bgeu	a5,a4,80002de0 <readi+0x3e>
    n = ip->size - off;
    80002ddc:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002de0:	0a0b0963          	beqz	s6,80002e92 <readi+0xf0>
    80002de4:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002de6:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002dea:	5cfd                	li	s9,-1
    80002dec:	a82d                	j	80002e26 <readi+0x84>
    80002dee:	020a1d93          	slli	s11,s4,0x20
    80002df2:	020ddd93          	srli	s11,s11,0x20
    80002df6:	05890613          	addi	a2,s2,88
    80002dfa:	86ee                	mv	a3,s11
    80002dfc:	963a                	add	a2,a2,a4
    80002dfe:	85d6                	mv	a1,s5
    80002e00:	8562                	mv	a0,s8
    80002e02:	fffff097          	auipc	ra,0xfffff
    80002e06:	afe080e7          	jalr	-1282(ra) # 80001900 <either_copyout>
    80002e0a:	05950d63          	beq	a0,s9,80002e64 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e0e:	854a                	mv	a0,s2
    80002e10:	fffff097          	auipc	ra,0xfffff
    80002e14:	60c080e7          	jalr	1548(ra) # 8000241c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e18:	013a09bb          	addw	s3,s4,s3
    80002e1c:	009a04bb          	addw	s1,s4,s1
    80002e20:	9aee                	add	s5,s5,s11
    80002e22:	0569f763          	bgeu	s3,s6,80002e70 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002e26:	000ba903          	lw	s2,0(s7)
    80002e2a:	00a4d59b          	srliw	a1,s1,0xa
    80002e2e:	855e                	mv	a0,s7
    80002e30:	00000097          	auipc	ra,0x0
    80002e34:	8b0080e7          	jalr	-1872(ra) # 800026e0 <bmap>
    80002e38:	0005059b          	sext.w	a1,a0
    80002e3c:	854a                	mv	a0,s2
    80002e3e:	fffff097          	auipc	ra,0xfffff
    80002e42:	4ae080e7          	jalr	1198(ra) # 800022ec <bread>
    80002e46:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e48:	3ff4f713          	andi	a4,s1,1023
    80002e4c:	40ed07bb          	subw	a5,s10,a4
    80002e50:	413b06bb          	subw	a3,s6,s3
    80002e54:	8a3e                	mv	s4,a5
    80002e56:	2781                	sext.w	a5,a5
    80002e58:	0006861b          	sext.w	a2,a3
    80002e5c:	f8f679e3          	bgeu	a2,a5,80002dee <readi+0x4c>
    80002e60:	8a36                	mv	s4,a3
    80002e62:	b771                	j	80002dee <readi+0x4c>
      brelse(bp);
    80002e64:	854a                	mv	a0,s2
    80002e66:	fffff097          	auipc	ra,0xfffff
    80002e6a:	5b6080e7          	jalr	1462(ra) # 8000241c <brelse>
      tot = -1;
    80002e6e:	59fd                	li	s3,-1
  }
  return tot;
    80002e70:	0009851b          	sext.w	a0,s3
}
    80002e74:	70a6                	ld	ra,104(sp)
    80002e76:	7406                	ld	s0,96(sp)
    80002e78:	64e6                	ld	s1,88(sp)
    80002e7a:	6946                	ld	s2,80(sp)
    80002e7c:	69a6                	ld	s3,72(sp)
    80002e7e:	6a06                	ld	s4,64(sp)
    80002e80:	7ae2                	ld	s5,56(sp)
    80002e82:	7b42                	ld	s6,48(sp)
    80002e84:	7ba2                	ld	s7,40(sp)
    80002e86:	7c02                	ld	s8,32(sp)
    80002e88:	6ce2                	ld	s9,24(sp)
    80002e8a:	6d42                	ld	s10,16(sp)
    80002e8c:	6da2                	ld	s11,8(sp)
    80002e8e:	6165                	addi	sp,sp,112
    80002e90:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e92:	89da                	mv	s3,s6
    80002e94:	bff1                	j	80002e70 <readi+0xce>
    return 0;
    80002e96:	4501                	li	a0,0
}
    80002e98:	8082                	ret

0000000080002e9a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e9a:	457c                	lw	a5,76(a0)
    80002e9c:	10d7e863          	bltu	a5,a3,80002fac <writei+0x112>
{
    80002ea0:	7159                	addi	sp,sp,-112
    80002ea2:	f486                	sd	ra,104(sp)
    80002ea4:	f0a2                	sd	s0,96(sp)
    80002ea6:	eca6                	sd	s1,88(sp)
    80002ea8:	e8ca                	sd	s2,80(sp)
    80002eaa:	e4ce                	sd	s3,72(sp)
    80002eac:	e0d2                	sd	s4,64(sp)
    80002eae:	fc56                	sd	s5,56(sp)
    80002eb0:	f85a                	sd	s6,48(sp)
    80002eb2:	f45e                	sd	s7,40(sp)
    80002eb4:	f062                	sd	s8,32(sp)
    80002eb6:	ec66                	sd	s9,24(sp)
    80002eb8:	e86a                	sd	s10,16(sp)
    80002eba:	e46e                	sd	s11,8(sp)
    80002ebc:	1880                	addi	s0,sp,112
    80002ebe:	8b2a                	mv	s6,a0
    80002ec0:	8c2e                	mv	s8,a1
    80002ec2:	8ab2                	mv	s5,a2
    80002ec4:	8936                	mv	s2,a3
    80002ec6:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002ec8:	00e687bb          	addw	a5,a3,a4
    80002ecc:	0ed7e263          	bltu	a5,a3,80002fb0 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ed0:	00043737          	lui	a4,0x43
    80002ed4:	0ef76063          	bltu	a4,a5,80002fb4 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ed8:	0c0b8863          	beqz	s7,80002fa8 <writei+0x10e>
    80002edc:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ede:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ee2:	5cfd                	li	s9,-1
    80002ee4:	a091                	j	80002f28 <writei+0x8e>
    80002ee6:	02099d93          	slli	s11,s3,0x20
    80002eea:	020ddd93          	srli	s11,s11,0x20
    80002eee:	05848513          	addi	a0,s1,88
    80002ef2:	86ee                	mv	a3,s11
    80002ef4:	8656                	mv	a2,s5
    80002ef6:	85e2                	mv	a1,s8
    80002ef8:	953a                	add	a0,a0,a4
    80002efa:	fffff097          	auipc	ra,0xfffff
    80002efe:	a5c080e7          	jalr	-1444(ra) # 80001956 <either_copyin>
    80002f02:	07950263          	beq	a0,s9,80002f66 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f06:	8526                	mv	a0,s1
    80002f08:	00000097          	auipc	ra,0x0
    80002f0c:	790080e7          	jalr	1936(ra) # 80003698 <log_write>
    brelse(bp);
    80002f10:	8526                	mv	a0,s1
    80002f12:	fffff097          	auipc	ra,0xfffff
    80002f16:	50a080e7          	jalr	1290(ra) # 8000241c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f1a:	01498a3b          	addw	s4,s3,s4
    80002f1e:	0129893b          	addw	s2,s3,s2
    80002f22:	9aee                	add	s5,s5,s11
    80002f24:	057a7663          	bgeu	s4,s7,80002f70 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f28:	000b2483          	lw	s1,0(s6)
    80002f2c:	00a9559b          	srliw	a1,s2,0xa
    80002f30:	855a                	mv	a0,s6
    80002f32:	fffff097          	auipc	ra,0xfffff
    80002f36:	7ae080e7          	jalr	1966(ra) # 800026e0 <bmap>
    80002f3a:	0005059b          	sext.w	a1,a0
    80002f3e:	8526                	mv	a0,s1
    80002f40:	fffff097          	auipc	ra,0xfffff
    80002f44:	3ac080e7          	jalr	940(ra) # 800022ec <bread>
    80002f48:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f4a:	3ff97713          	andi	a4,s2,1023
    80002f4e:	40ed07bb          	subw	a5,s10,a4
    80002f52:	414b86bb          	subw	a3,s7,s4
    80002f56:	89be                	mv	s3,a5
    80002f58:	2781                	sext.w	a5,a5
    80002f5a:	0006861b          	sext.w	a2,a3
    80002f5e:	f8f674e3          	bgeu	a2,a5,80002ee6 <writei+0x4c>
    80002f62:	89b6                	mv	s3,a3
    80002f64:	b749                	j	80002ee6 <writei+0x4c>
      brelse(bp);
    80002f66:	8526                	mv	a0,s1
    80002f68:	fffff097          	auipc	ra,0xfffff
    80002f6c:	4b4080e7          	jalr	1204(ra) # 8000241c <brelse>
  }

  if(off > ip->size)
    80002f70:	04cb2783          	lw	a5,76(s6)
    80002f74:	0127f463          	bgeu	a5,s2,80002f7c <writei+0xe2>
    ip->size = off;
    80002f78:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f7c:	855a                	mv	a0,s6
    80002f7e:	00000097          	auipc	ra,0x0
    80002f82:	aa6080e7          	jalr	-1370(ra) # 80002a24 <iupdate>

  return tot;
    80002f86:	000a051b          	sext.w	a0,s4
}
    80002f8a:	70a6                	ld	ra,104(sp)
    80002f8c:	7406                	ld	s0,96(sp)
    80002f8e:	64e6                	ld	s1,88(sp)
    80002f90:	6946                	ld	s2,80(sp)
    80002f92:	69a6                	ld	s3,72(sp)
    80002f94:	6a06                	ld	s4,64(sp)
    80002f96:	7ae2                	ld	s5,56(sp)
    80002f98:	7b42                	ld	s6,48(sp)
    80002f9a:	7ba2                	ld	s7,40(sp)
    80002f9c:	7c02                	ld	s8,32(sp)
    80002f9e:	6ce2                	ld	s9,24(sp)
    80002fa0:	6d42                	ld	s10,16(sp)
    80002fa2:	6da2                	ld	s11,8(sp)
    80002fa4:	6165                	addi	sp,sp,112
    80002fa6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fa8:	8a5e                	mv	s4,s7
    80002faa:	bfc9                	j	80002f7c <writei+0xe2>
    return -1;
    80002fac:	557d                	li	a0,-1
}
    80002fae:	8082                	ret
    return -1;
    80002fb0:	557d                	li	a0,-1
    80002fb2:	bfe1                	j	80002f8a <writei+0xf0>
    return -1;
    80002fb4:	557d                	li	a0,-1
    80002fb6:	bfd1                	j	80002f8a <writei+0xf0>

0000000080002fb8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002fb8:	1141                	addi	sp,sp,-16
    80002fba:	e406                	sd	ra,8(sp)
    80002fbc:	e022                	sd	s0,0(sp)
    80002fbe:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fc0:	4639                	li	a2,14
    80002fc2:	ffffd097          	auipc	ra,0xffffd
    80002fc6:	28e080e7          	jalr	654(ra) # 80000250 <strncmp>
}
    80002fca:	60a2                	ld	ra,8(sp)
    80002fcc:	6402                	ld	s0,0(sp)
    80002fce:	0141                	addi	sp,sp,16
    80002fd0:	8082                	ret

0000000080002fd2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fd2:	7139                	addi	sp,sp,-64
    80002fd4:	fc06                	sd	ra,56(sp)
    80002fd6:	f822                	sd	s0,48(sp)
    80002fd8:	f426                	sd	s1,40(sp)
    80002fda:	f04a                	sd	s2,32(sp)
    80002fdc:	ec4e                	sd	s3,24(sp)
    80002fde:	e852                	sd	s4,16(sp)
    80002fe0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fe2:	04451703          	lh	a4,68(a0)
    80002fe6:	4785                	li	a5,1
    80002fe8:	00f71a63          	bne	a4,a5,80002ffc <dirlookup+0x2a>
    80002fec:	892a                	mv	s2,a0
    80002fee:	89ae                	mv	s3,a1
    80002ff0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ff2:	457c                	lw	a5,76(a0)
    80002ff4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002ff6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ff8:	e79d                	bnez	a5,80003026 <dirlookup+0x54>
    80002ffa:	a8a5                	j	80003072 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002ffc:	00006517          	auipc	a0,0x6
    80003000:	5bc50513          	addi	a0,a0,1468 # 800095b8 <syscalls+0x1e0>
    80003004:	00004097          	auipc	ra,0x4
    80003008:	bf0080e7          	jalr	-1040(ra) # 80006bf4 <panic>
      panic("dirlookup read");
    8000300c:	00006517          	auipc	a0,0x6
    80003010:	5c450513          	addi	a0,a0,1476 # 800095d0 <syscalls+0x1f8>
    80003014:	00004097          	auipc	ra,0x4
    80003018:	be0080e7          	jalr	-1056(ra) # 80006bf4 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000301c:	24c1                	addiw	s1,s1,16
    8000301e:	04c92783          	lw	a5,76(s2)
    80003022:	04f4f763          	bgeu	s1,a5,80003070 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003026:	4741                	li	a4,16
    80003028:	86a6                	mv	a3,s1
    8000302a:	fc040613          	addi	a2,s0,-64
    8000302e:	4581                	li	a1,0
    80003030:	854a                	mv	a0,s2
    80003032:	00000097          	auipc	ra,0x0
    80003036:	d70080e7          	jalr	-656(ra) # 80002da2 <readi>
    8000303a:	47c1                	li	a5,16
    8000303c:	fcf518e3          	bne	a0,a5,8000300c <dirlookup+0x3a>
    if(de.inum == 0)
    80003040:	fc045783          	lhu	a5,-64(s0)
    80003044:	dfe1                	beqz	a5,8000301c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003046:	fc240593          	addi	a1,s0,-62
    8000304a:	854e                	mv	a0,s3
    8000304c:	00000097          	auipc	ra,0x0
    80003050:	f6c080e7          	jalr	-148(ra) # 80002fb8 <namecmp>
    80003054:	f561                	bnez	a0,8000301c <dirlookup+0x4a>
      if(poff)
    80003056:	000a0463          	beqz	s4,8000305e <dirlookup+0x8c>
        *poff = off;
    8000305a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000305e:	fc045583          	lhu	a1,-64(s0)
    80003062:	00092503          	lw	a0,0(s2)
    80003066:	fffff097          	auipc	ra,0xfffff
    8000306a:	754080e7          	jalr	1876(ra) # 800027ba <iget>
    8000306e:	a011                	j	80003072 <dirlookup+0xa0>
  return 0;
    80003070:	4501                	li	a0,0
}
    80003072:	70e2                	ld	ra,56(sp)
    80003074:	7442                	ld	s0,48(sp)
    80003076:	74a2                	ld	s1,40(sp)
    80003078:	7902                	ld	s2,32(sp)
    8000307a:	69e2                	ld	s3,24(sp)
    8000307c:	6a42                	ld	s4,16(sp)
    8000307e:	6121                	addi	sp,sp,64
    80003080:	8082                	ret

0000000080003082 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003082:	711d                	addi	sp,sp,-96
    80003084:	ec86                	sd	ra,88(sp)
    80003086:	e8a2                	sd	s0,80(sp)
    80003088:	e4a6                	sd	s1,72(sp)
    8000308a:	e0ca                	sd	s2,64(sp)
    8000308c:	fc4e                	sd	s3,56(sp)
    8000308e:	f852                	sd	s4,48(sp)
    80003090:	f456                	sd	s5,40(sp)
    80003092:	f05a                	sd	s6,32(sp)
    80003094:	ec5e                	sd	s7,24(sp)
    80003096:	e862                	sd	s8,16(sp)
    80003098:	e466                	sd	s9,8(sp)
    8000309a:	1080                	addi	s0,sp,96
    8000309c:	84aa                	mv	s1,a0
    8000309e:	8b2e                	mv	s6,a1
    800030a0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800030a2:	00054703          	lbu	a4,0(a0)
    800030a6:	02f00793          	li	a5,47
    800030aa:	02f70363          	beq	a4,a5,800030d0 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030ae:	ffffe097          	auipc	ra,0xffffe
    800030b2:	df2080e7          	jalr	-526(ra) # 80000ea0 <myproc>
    800030b6:	15053503          	ld	a0,336(a0)
    800030ba:	00000097          	auipc	ra,0x0
    800030be:	9f6080e7          	jalr	-1546(ra) # 80002ab0 <idup>
    800030c2:	89aa                	mv	s3,a0
  while(*path == '/')
    800030c4:	02f00913          	li	s2,47
  len = path - s;
    800030c8:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800030ca:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030cc:	4c05                	li	s8,1
    800030ce:	a865                	j	80003186 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800030d0:	4585                	li	a1,1
    800030d2:	4505                	li	a0,1
    800030d4:	fffff097          	auipc	ra,0xfffff
    800030d8:	6e6080e7          	jalr	1766(ra) # 800027ba <iget>
    800030dc:	89aa                	mv	s3,a0
    800030de:	b7dd                	j	800030c4 <namex+0x42>
      iunlockput(ip);
    800030e0:	854e                	mv	a0,s3
    800030e2:	00000097          	auipc	ra,0x0
    800030e6:	c6e080e7          	jalr	-914(ra) # 80002d50 <iunlockput>
      return 0;
    800030ea:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030ec:	854e                	mv	a0,s3
    800030ee:	60e6                	ld	ra,88(sp)
    800030f0:	6446                	ld	s0,80(sp)
    800030f2:	64a6                	ld	s1,72(sp)
    800030f4:	6906                	ld	s2,64(sp)
    800030f6:	79e2                	ld	s3,56(sp)
    800030f8:	7a42                	ld	s4,48(sp)
    800030fa:	7aa2                	ld	s5,40(sp)
    800030fc:	7b02                	ld	s6,32(sp)
    800030fe:	6be2                	ld	s7,24(sp)
    80003100:	6c42                	ld	s8,16(sp)
    80003102:	6ca2                	ld	s9,8(sp)
    80003104:	6125                	addi	sp,sp,96
    80003106:	8082                	ret
      iunlock(ip);
    80003108:	854e                	mv	a0,s3
    8000310a:	00000097          	auipc	ra,0x0
    8000310e:	aa6080e7          	jalr	-1370(ra) # 80002bb0 <iunlock>
      return ip;
    80003112:	bfe9                	j	800030ec <namex+0x6a>
      iunlockput(ip);
    80003114:	854e                	mv	a0,s3
    80003116:	00000097          	auipc	ra,0x0
    8000311a:	c3a080e7          	jalr	-966(ra) # 80002d50 <iunlockput>
      return 0;
    8000311e:	89d2                	mv	s3,s4
    80003120:	b7f1                	j	800030ec <namex+0x6a>
  len = path - s;
    80003122:	40b48633          	sub	a2,s1,a1
    80003126:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000312a:	094cd463          	bge	s9,s4,800031b2 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000312e:	4639                	li	a2,14
    80003130:	8556                	mv	a0,s5
    80003132:	ffffd097          	auipc	ra,0xffffd
    80003136:	0a6080e7          	jalr	166(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000313a:	0004c783          	lbu	a5,0(s1)
    8000313e:	01279763          	bne	a5,s2,8000314c <namex+0xca>
    path++;
    80003142:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003144:	0004c783          	lbu	a5,0(s1)
    80003148:	ff278de3          	beq	a5,s2,80003142 <namex+0xc0>
    ilock(ip);
    8000314c:	854e                	mv	a0,s3
    8000314e:	00000097          	auipc	ra,0x0
    80003152:	9a0080e7          	jalr	-1632(ra) # 80002aee <ilock>
    if(ip->type != T_DIR){
    80003156:	04499783          	lh	a5,68(s3)
    8000315a:	f98793e3          	bne	a5,s8,800030e0 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000315e:	000b0563          	beqz	s6,80003168 <namex+0xe6>
    80003162:	0004c783          	lbu	a5,0(s1)
    80003166:	d3cd                	beqz	a5,80003108 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003168:	865e                	mv	a2,s7
    8000316a:	85d6                	mv	a1,s5
    8000316c:	854e                	mv	a0,s3
    8000316e:	00000097          	auipc	ra,0x0
    80003172:	e64080e7          	jalr	-412(ra) # 80002fd2 <dirlookup>
    80003176:	8a2a                	mv	s4,a0
    80003178:	dd51                	beqz	a0,80003114 <namex+0x92>
    iunlockput(ip);
    8000317a:	854e                	mv	a0,s3
    8000317c:	00000097          	auipc	ra,0x0
    80003180:	bd4080e7          	jalr	-1068(ra) # 80002d50 <iunlockput>
    ip = next;
    80003184:	89d2                	mv	s3,s4
  while(*path == '/')
    80003186:	0004c783          	lbu	a5,0(s1)
    8000318a:	05279763          	bne	a5,s2,800031d8 <namex+0x156>
    path++;
    8000318e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003190:	0004c783          	lbu	a5,0(s1)
    80003194:	ff278de3          	beq	a5,s2,8000318e <namex+0x10c>
  if(*path == 0)
    80003198:	c79d                	beqz	a5,800031c6 <namex+0x144>
    path++;
    8000319a:	85a6                	mv	a1,s1
  len = path - s;
    8000319c:	8a5e                	mv	s4,s7
    8000319e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800031a0:	01278963          	beq	a5,s2,800031b2 <namex+0x130>
    800031a4:	dfbd                	beqz	a5,80003122 <namex+0xa0>
    path++;
    800031a6:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800031a8:	0004c783          	lbu	a5,0(s1)
    800031ac:	ff279ce3          	bne	a5,s2,800031a4 <namex+0x122>
    800031b0:	bf8d                	j	80003122 <namex+0xa0>
    memmove(name, s, len);
    800031b2:	2601                	sext.w	a2,a2
    800031b4:	8556                	mv	a0,s5
    800031b6:	ffffd097          	auipc	ra,0xffffd
    800031ba:	022080e7          	jalr	34(ra) # 800001d8 <memmove>
    name[len] = 0;
    800031be:	9a56                	add	s4,s4,s5
    800031c0:	000a0023          	sb	zero,0(s4)
    800031c4:	bf9d                	j	8000313a <namex+0xb8>
  if(nameiparent){
    800031c6:	f20b03e3          	beqz	s6,800030ec <namex+0x6a>
    iput(ip);
    800031ca:	854e                	mv	a0,s3
    800031cc:	00000097          	auipc	ra,0x0
    800031d0:	adc080e7          	jalr	-1316(ra) # 80002ca8 <iput>
    return 0;
    800031d4:	4981                	li	s3,0
    800031d6:	bf19                	j	800030ec <namex+0x6a>
  if(*path == 0)
    800031d8:	d7fd                	beqz	a5,800031c6 <namex+0x144>
  while(*path != '/' && *path != 0)
    800031da:	0004c783          	lbu	a5,0(s1)
    800031de:	85a6                	mv	a1,s1
    800031e0:	b7d1                	j	800031a4 <namex+0x122>

00000000800031e2 <dirlink>:
{
    800031e2:	7139                	addi	sp,sp,-64
    800031e4:	fc06                	sd	ra,56(sp)
    800031e6:	f822                	sd	s0,48(sp)
    800031e8:	f426                	sd	s1,40(sp)
    800031ea:	f04a                	sd	s2,32(sp)
    800031ec:	ec4e                	sd	s3,24(sp)
    800031ee:	e852                	sd	s4,16(sp)
    800031f0:	0080                	addi	s0,sp,64
    800031f2:	892a                	mv	s2,a0
    800031f4:	8a2e                	mv	s4,a1
    800031f6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031f8:	4601                	li	a2,0
    800031fa:	00000097          	auipc	ra,0x0
    800031fe:	dd8080e7          	jalr	-552(ra) # 80002fd2 <dirlookup>
    80003202:	e93d                	bnez	a0,80003278 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003204:	04c92483          	lw	s1,76(s2)
    80003208:	c49d                	beqz	s1,80003236 <dirlink+0x54>
    8000320a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000320c:	4741                	li	a4,16
    8000320e:	86a6                	mv	a3,s1
    80003210:	fc040613          	addi	a2,s0,-64
    80003214:	4581                	li	a1,0
    80003216:	854a                	mv	a0,s2
    80003218:	00000097          	auipc	ra,0x0
    8000321c:	b8a080e7          	jalr	-1142(ra) # 80002da2 <readi>
    80003220:	47c1                	li	a5,16
    80003222:	06f51163          	bne	a0,a5,80003284 <dirlink+0xa2>
    if(de.inum == 0)
    80003226:	fc045783          	lhu	a5,-64(s0)
    8000322a:	c791                	beqz	a5,80003236 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000322c:	24c1                	addiw	s1,s1,16
    8000322e:	04c92783          	lw	a5,76(s2)
    80003232:	fcf4ede3          	bltu	s1,a5,8000320c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003236:	4639                	li	a2,14
    80003238:	85d2                	mv	a1,s4
    8000323a:	fc240513          	addi	a0,s0,-62
    8000323e:	ffffd097          	auipc	ra,0xffffd
    80003242:	04e080e7          	jalr	78(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003246:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000324a:	4741                	li	a4,16
    8000324c:	86a6                	mv	a3,s1
    8000324e:	fc040613          	addi	a2,s0,-64
    80003252:	4581                	li	a1,0
    80003254:	854a                	mv	a0,s2
    80003256:	00000097          	auipc	ra,0x0
    8000325a:	c44080e7          	jalr	-956(ra) # 80002e9a <writei>
    8000325e:	872a                	mv	a4,a0
    80003260:	47c1                	li	a5,16
  return 0;
    80003262:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003264:	02f71863          	bne	a4,a5,80003294 <dirlink+0xb2>
}
    80003268:	70e2                	ld	ra,56(sp)
    8000326a:	7442                	ld	s0,48(sp)
    8000326c:	74a2                	ld	s1,40(sp)
    8000326e:	7902                	ld	s2,32(sp)
    80003270:	69e2                	ld	s3,24(sp)
    80003272:	6a42                	ld	s4,16(sp)
    80003274:	6121                	addi	sp,sp,64
    80003276:	8082                	ret
    iput(ip);
    80003278:	00000097          	auipc	ra,0x0
    8000327c:	a30080e7          	jalr	-1488(ra) # 80002ca8 <iput>
    return -1;
    80003280:	557d                	li	a0,-1
    80003282:	b7dd                	j	80003268 <dirlink+0x86>
      panic("dirlink read");
    80003284:	00006517          	auipc	a0,0x6
    80003288:	35c50513          	addi	a0,a0,860 # 800095e0 <syscalls+0x208>
    8000328c:	00004097          	auipc	ra,0x4
    80003290:	968080e7          	jalr	-1688(ra) # 80006bf4 <panic>
    panic("dirlink");
    80003294:	00006517          	auipc	a0,0x6
    80003298:	45c50513          	addi	a0,a0,1116 # 800096f0 <syscalls+0x318>
    8000329c:	00004097          	auipc	ra,0x4
    800032a0:	958080e7          	jalr	-1704(ra) # 80006bf4 <panic>

00000000800032a4 <namei>:

struct inode*
namei(char *path)
{
    800032a4:	1101                	addi	sp,sp,-32
    800032a6:	ec06                	sd	ra,24(sp)
    800032a8:	e822                	sd	s0,16(sp)
    800032aa:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800032ac:	fe040613          	addi	a2,s0,-32
    800032b0:	4581                	li	a1,0
    800032b2:	00000097          	auipc	ra,0x0
    800032b6:	dd0080e7          	jalr	-560(ra) # 80003082 <namex>
}
    800032ba:	60e2                	ld	ra,24(sp)
    800032bc:	6442                	ld	s0,16(sp)
    800032be:	6105                	addi	sp,sp,32
    800032c0:	8082                	ret

00000000800032c2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032c2:	1141                	addi	sp,sp,-16
    800032c4:	e406                	sd	ra,8(sp)
    800032c6:	e022                	sd	s0,0(sp)
    800032c8:	0800                	addi	s0,sp,16
    800032ca:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032cc:	4585                	li	a1,1
    800032ce:	00000097          	auipc	ra,0x0
    800032d2:	db4080e7          	jalr	-588(ra) # 80003082 <namex>
}
    800032d6:	60a2                	ld	ra,8(sp)
    800032d8:	6402                	ld	s0,0(sp)
    800032da:	0141                	addi	sp,sp,16
    800032dc:	8082                	ret

00000000800032de <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032de:	1101                	addi	sp,sp,-32
    800032e0:	ec06                	sd	ra,24(sp)
    800032e2:	e822                	sd	s0,16(sp)
    800032e4:	e426                	sd	s1,8(sp)
    800032e6:	e04a                	sd	s2,0(sp)
    800032e8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032ea:	00017917          	auipc	s2,0x17
    800032ee:	d5690913          	addi	s2,s2,-682 # 8001a040 <log>
    800032f2:	01892583          	lw	a1,24(s2)
    800032f6:	02892503          	lw	a0,40(s2)
    800032fa:	fffff097          	auipc	ra,0xfffff
    800032fe:	ff2080e7          	jalr	-14(ra) # 800022ec <bread>
    80003302:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003304:	02c92683          	lw	a3,44(s2)
    80003308:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000330a:	02d05763          	blez	a3,80003338 <write_head+0x5a>
    8000330e:	00017797          	auipc	a5,0x17
    80003312:	d6278793          	addi	a5,a5,-670 # 8001a070 <log+0x30>
    80003316:	05c50713          	addi	a4,a0,92
    8000331a:	36fd                	addiw	a3,a3,-1
    8000331c:	1682                	slli	a3,a3,0x20
    8000331e:	9281                	srli	a3,a3,0x20
    80003320:	068a                	slli	a3,a3,0x2
    80003322:	00017617          	auipc	a2,0x17
    80003326:	d5260613          	addi	a2,a2,-686 # 8001a074 <log+0x34>
    8000332a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000332c:	4390                	lw	a2,0(a5)
    8000332e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003330:	0791                	addi	a5,a5,4
    80003332:	0711                	addi	a4,a4,4
    80003334:	fed79ce3          	bne	a5,a3,8000332c <write_head+0x4e>
  }
  bwrite(buf);
    80003338:	8526                	mv	a0,s1
    8000333a:	fffff097          	auipc	ra,0xfffff
    8000333e:	0a4080e7          	jalr	164(ra) # 800023de <bwrite>
  brelse(buf);
    80003342:	8526                	mv	a0,s1
    80003344:	fffff097          	auipc	ra,0xfffff
    80003348:	0d8080e7          	jalr	216(ra) # 8000241c <brelse>
}
    8000334c:	60e2                	ld	ra,24(sp)
    8000334e:	6442                	ld	s0,16(sp)
    80003350:	64a2                	ld	s1,8(sp)
    80003352:	6902                	ld	s2,0(sp)
    80003354:	6105                	addi	sp,sp,32
    80003356:	8082                	ret

0000000080003358 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003358:	00017797          	auipc	a5,0x17
    8000335c:	d147a783          	lw	a5,-748(a5) # 8001a06c <log+0x2c>
    80003360:	0af05d63          	blez	a5,8000341a <install_trans+0xc2>
{
    80003364:	7139                	addi	sp,sp,-64
    80003366:	fc06                	sd	ra,56(sp)
    80003368:	f822                	sd	s0,48(sp)
    8000336a:	f426                	sd	s1,40(sp)
    8000336c:	f04a                	sd	s2,32(sp)
    8000336e:	ec4e                	sd	s3,24(sp)
    80003370:	e852                	sd	s4,16(sp)
    80003372:	e456                	sd	s5,8(sp)
    80003374:	e05a                	sd	s6,0(sp)
    80003376:	0080                	addi	s0,sp,64
    80003378:	8b2a                	mv	s6,a0
    8000337a:	00017a97          	auipc	s5,0x17
    8000337e:	cf6a8a93          	addi	s5,s5,-778 # 8001a070 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003382:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003384:	00017997          	auipc	s3,0x17
    80003388:	cbc98993          	addi	s3,s3,-836 # 8001a040 <log>
    8000338c:	a035                	j	800033b8 <install_trans+0x60>
      bunpin(dbuf);
    8000338e:	8526                	mv	a0,s1
    80003390:	fffff097          	auipc	ra,0xfffff
    80003394:	166080e7          	jalr	358(ra) # 800024f6 <bunpin>
    brelse(lbuf);
    80003398:	854a                	mv	a0,s2
    8000339a:	fffff097          	auipc	ra,0xfffff
    8000339e:	082080e7          	jalr	130(ra) # 8000241c <brelse>
    brelse(dbuf);
    800033a2:	8526                	mv	a0,s1
    800033a4:	fffff097          	auipc	ra,0xfffff
    800033a8:	078080e7          	jalr	120(ra) # 8000241c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033ac:	2a05                	addiw	s4,s4,1
    800033ae:	0a91                	addi	s5,s5,4
    800033b0:	02c9a783          	lw	a5,44(s3)
    800033b4:	04fa5963          	bge	s4,a5,80003406 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033b8:	0189a583          	lw	a1,24(s3)
    800033bc:	014585bb          	addw	a1,a1,s4
    800033c0:	2585                	addiw	a1,a1,1
    800033c2:	0289a503          	lw	a0,40(s3)
    800033c6:	fffff097          	auipc	ra,0xfffff
    800033ca:	f26080e7          	jalr	-218(ra) # 800022ec <bread>
    800033ce:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033d0:	000aa583          	lw	a1,0(s5)
    800033d4:	0289a503          	lw	a0,40(s3)
    800033d8:	fffff097          	auipc	ra,0xfffff
    800033dc:	f14080e7          	jalr	-236(ra) # 800022ec <bread>
    800033e0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033e2:	40000613          	li	a2,1024
    800033e6:	05890593          	addi	a1,s2,88
    800033ea:	05850513          	addi	a0,a0,88
    800033ee:	ffffd097          	auipc	ra,0xffffd
    800033f2:	dea080e7          	jalr	-534(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033f6:	8526                	mv	a0,s1
    800033f8:	fffff097          	auipc	ra,0xfffff
    800033fc:	fe6080e7          	jalr	-26(ra) # 800023de <bwrite>
    if(recovering == 0)
    80003400:	f80b1ce3          	bnez	s6,80003398 <install_trans+0x40>
    80003404:	b769                	j	8000338e <install_trans+0x36>
}
    80003406:	70e2                	ld	ra,56(sp)
    80003408:	7442                	ld	s0,48(sp)
    8000340a:	74a2                	ld	s1,40(sp)
    8000340c:	7902                	ld	s2,32(sp)
    8000340e:	69e2                	ld	s3,24(sp)
    80003410:	6a42                	ld	s4,16(sp)
    80003412:	6aa2                	ld	s5,8(sp)
    80003414:	6b02                	ld	s6,0(sp)
    80003416:	6121                	addi	sp,sp,64
    80003418:	8082                	ret
    8000341a:	8082                	ret

000000008000341c <initlog>:
{
    8000341c:	7179                	addi	sp,sp,-48
    8000341e:	f406                	sd	ra,40(sp)
    80003420:	f022                	sd	s0,32(sp)
    80003422:	ec26                	sd	s1,24(sp)
    80003424:	e84a                	sd	s2,16(sp)
    80003426:	e44e                	sd	s3,8(sp)
    80003428:	1800                	addi	s0,sp,48
    8000342a:	892a                	mv	s2,a0
    8000342c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000342e:	00017497          	auipc	s1,0x17
    80003432:	c1248493          	addi	s1,s1,-1006 # 8001a040 <log>
    80003436:	00006597          	auipc	a1,0x6
    8000343a:	1ba58593          	addi	a1,a1,442 # 800095f0 <syscalls+0x218>
    8000343e:	8526                	mv	a0,s1
    80003440:	00004097          	auipc	ra,0x4
    80003444:	c6e080e7          	jalr	-914(ra) # 800070ae <initlock>
  log.start = sb->logstart;
    80003448:	0149a583          	lw	a1,20(s3)
    8000344c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000344e:	0109a783          	lw	a5,16(s3)
    80003452:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003454:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003458:	854a                	mv	a0,s2
    8000345a:	fffff097          	auipc	ra,0xfffff
    8000345e:	e92080e7          	jalr	-366(ra) # 800022ec <bread>
  log.lh.n = lh->n;
    80003462:	4d3c                	lw	a5,88(a0)
    80003464:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003466:	02f05563          	blez	a5,80003490 <initlog+0x74>
    8000346a:	05c50713          	addi	a4,a0,92
    8000346e:	00017697          	auipc	a3,0x17
    80003472:	c0268693          	addi	a3,a3,-1022 # 8001a070 <log+0x30>
    80003476:	37fd                	addiw	a5,a5,-1
    80003478:	1782                	slli	a5,a5,0x20
    8000347a:	9381                	srli	a5,a5,0x20
    8000347c:	078a                	slli	a5,a5,0x2
    8000347e:	06050613          	addi	a2,a0,96
    80003482:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003484:	4310                	lw	a2,0(a4)
    80003486:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003488:	0711                	addi	a4,a4,4
    8000348a:	0691                	addi	a3,a3,4
    8000348c:	fef71ce3          	bne	a4,a5,80003484 <initlog+0x68>
  brelse(buf);
    80003490:	fffff097          	auipc	ra,0xfffff
    80003494:	f8c080e7          	jalr	-116(ra) # 8000241c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003498:	4505                	li	a0,1
    8000349a:	00000097          	auipc	ra,0x0
    8000349e:	ebe080e7          	jalr	-322(ra) # 80003358 <install_trans>
  log.lh.n = 0;
    800034a2:	00017797          	auipc	a5,0x17
    800034a6:	bc07a523          	sw	zero,-1078(a5) # 8001a06c <log+0x2c>
  write_head(); // clear the log
    800034aa:	00000097          	auipc	ra,0x0
    800034ae:	e34080e7          	jalr	-460(ra) # 800032de <write_head>
}
    800034b2:	70a2                	ld	ra,40(sp)
    800034b4:	7402                	ld	s0,32(sp)
    800034b6:	64e2                	ld	s1,24(sp)
    800034b8:	6942                	ld	s2,16(sp)
    800034ba:	69a2                	ld	s3,8(sp)
    800034bc:	6145                	addi	sp,sp,48
    800034be:	8082                	ret

00000000800034c0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034c0:	1101                	addi	sp,sp,-32
    800034c2:	ec06                	sd	ra,24(sp)
    800034c4:	e822                	sd	s0,16(sp)
    800034c6:	e426                	sd	s1,8(sp)
    800034c8:	e04a                	sd	s2,0(sp)
    800034ca:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034cc:	00017517          	auipc	a0,0x17
    800034d0:	b7450513          	addi	a0,a0,-1164 # 8001a040 <log>
    800034d4:	00004097          	auipc	ra,0x4
    800034d8:	c6a080e7          	jalr	-918(ra) # 8000713e <acquire>
  while(1){
    if(log.committing){
    800034dc:	00017497          	auipc	s1,0x17
    800034e0:	b6448493          	addi	s1,s1,-1180 # 8001a040 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034e4:	4979                	li	s2,30
    800034e6:	a039                	j	800034f4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800034e8:	85a6                	mv	a1,s1
    800034ea:	8526                	mv	a0,s1
    800034ec:	ffffe097          	auipc	ra,0xffffe
    800034f0:	070080e7          	jalr	112(ra) # 8000155c <sleep>
    if(log.committing){
    800034f4:	50dc                	lw	a5,36(s1)
    800034f6:	fbed                	bnez	a5,800034e8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034f8:	509c                	lw	a5,32(s1)
    800034fa:	0017871b          	addiw	a4,a5,1
    800034fe:	0007069b          	sext.w	a3,a4
    80003502:	0027179b          	slliw	a5,a4,0x2
    80003506:	9fb9                	addw	a5,a5,a4
    80003508:	0017979b          	slliw	a5,a5,0x1
    8000350c:	54d8                	lw	a4,44(s1)
    8000350e:	9fb9                	addw	a5,a5,a4
    80003510:	00f95963          	bge	s2,a5,80003522 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003514:	85a6                	mv	a1,s1
    80003516:	8526                	mv	a0,s1
    80003518:	ffffe097          	auipc	ra,0xffffe
    8000351c:	044080e7          	jalr	68(ra) # 8000155c <sleep>
    80003520:	bfd1                	j	800034f4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003522:	00017517          	auipc	a0,0x17
    80003526:	b1e50513          	addi	a0,a0,-1250 # 8001a040 <log>
    8000352a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000352c:	00004097          	auipc	ra,0x4
    80003530:	cc6080e7          	jalr	-826(ra) # 800071f2 <release>
      break;
    }
  }
}
    80003534:	60e2                	ld	ra,24(sp)
    80003536:	6442                	ld	s0,16(sp)
    80003538:	64a2                	ld	s1,8(sp)
    8000353a:	6902                	ld	s2,0(sp)
    8000353c:	6105                	addi	sp,sp,32
    8000353e:	8082                	ret

0000000080003540 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003540:	7139                	addi	sp,sp,-64
    80003542:	fc06                	sd	ra,56(sp)
    80003544:	f822                	sd	s0,48(sp)
    80003546:	f426                	sd	s1,40(sp)
    80003548:	f04a                	sd	s2,32(sp)
    8000354a:	ec4e                	sd	s3,24(sp)
    8000354c:	e852                	sd	s4,16(sp)
    8000354e:	e456                	sd	s5,8(sp)
    80003550:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003552:	00017497          	auipc	s1,0x17
    80003556:	aee48493          	addi	s1,s1,-1298 # 8001a040 <log>
    8000355a:	8526                	mv	a0,s1
    8000355c:	00004097          	auipc	ra,0x4
    80003560:	be2080e7          	jalr	-1054(ra) # 8000713e <acquire>
  log.outstanding -= 1;
    80003564:	509c                	lw	a5,32(s1)
    80003566:	37fd                	addiw	a5,a5,-1
    80003568:	0007891b          	sext.w	s2,a5
    8000356c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000356e:	50dc                	lw	a5,36(s1)
    80003570:	efb9                	bnez	a5,800035ce <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003572:	06091663          	bnez	s2,800035de <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003576:	00017497          	auipc	s1,0x17
    8000357a:	aca48493          	addi	s1,s1,-1334 # 8001a040 <log>
    8000357e:	4785                	li	a5,1
    80003580:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003582:	8526                	mv	a0,s1
    80003584:	00004097          	auipc	ra,0x4
    80003588:	c6e080e7          	jalr	-914(ra) # 800071f2 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000358c:	54dc                	lw	a5,44(s1)
    8000358e:	06f04763          	bgtz	a5,800035fc <end_op+0xbc>
    acquire(&log.lock);
    80003592:	00017497          	auipc	s1,0x17
    80003596:	aae48493          	addi	s1,s1,-1362 # 8001a040 <log>
    8000359a:	8526                	mv	a0,s1
    8000359c:	00004097          	auipc	ra,0x4
    800035a0:	ba2080e7          	jalr	-1118(ra) # 8000713e <acquire>
    log.committing = 0;
    800035a4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035a8:	8526                	mv	a0,s1
    800035aa:	ffffe097          	auipc	ra,0xffffe
    800035ae:	13e080e7          	jalr	318(ra) # 800016e8 <wakeup>
    release(&log.lock);
    800035b2:	8526                	mv	a0,s1
    800035b4:	00004097          	auipc	ra,0x4
    800035b8:	c3e080e7          	jalr	-962(ra) # 800071f2 <release>
}
    800035bc:	70e2                	ld	ra,56(sp)
    800035be:	7442                	ld	s0,48(sp)
    800035c0:	74a2                	ld	s1,40(sp)
    800035c2:	7902                	ld	s2,32(sp)
    800035c4:	69e2                	ld	s3,24(sp)
    800035c6:	6a42                	ld	s4,16(sp)
    800035c8:	6aa2                	ld	s5,8(sp)
    800035ca:	6121                	addi	sp,sp,64
    800035cc:	8082                	ret
    panic("log.committing");
    800035ce:	00006517          	auipc	a0,0x6
    800035d2:	02a50513          	addi	a0,a0,42 # 800095f8 <syscalls+0x220>
    800035d6:	00003097          	auipc	ra,0x3
    800035da:	61e080e7          	jalr	1566(ra) # 80006bf4 <panic>
    wakeup(&log);
    800035de:	00017497          	auipc	s1,0x17
    800035e2:	a6248493          	addi	s1,s1,-1438 # 8001a040 <log>
    800035e6:	8526                	mv	a0,s1
    800035e8:	ffffe097          	auipc	ra,0xffffe
    800035ec:	100080e7          	jalr	256(ra) # 800016e8 <wakeup>
  release(&log.lock);
    800035f0:	8526                	mv	a0,s1
    800035f2:	00004097          	auipc	ra,0x4
    800035f6:	c00080e7          	jalr	-1024(ra) # 800071f2 <release>
  if(do_commit){
    800035fa:	b7c9                	j	800035bc <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035fc:	00017a97          	auipc	s5,0x17
    80003600:	a74a8a93          	addi	s5,s5,-1420 # 8001a070 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003604:	00017a17          	auipc	s4,0x17
    80003608:	a3ca0a13          	addi	s4,s4,-1476 # 8001a040 <log>
    8000360c:	018a2583          	lw	a1,24(s4)
    80003610:	012585bb          	addw	a1,a1,s2
    80003614:	2585                	addiw	a1,a1,1
    80003616:	028a2503          	lw	a0,40(s4)
    8000361a:	fffff097          	auipc	ra,0xfffff
    8000361e:	cd2080e7          	jalr	-814(ra) # 800022ec <bread>
    80003622:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003624:	000aa583          	lw	a1,0(s5)
    80003628:	028a2503          	lw	a0,40(s4)
    8000362c:	fffff097          	auipc	ra,0xfffff
    80003630:	cc0080e7          	jalr	-832(ra) # 800022ec <bread>
    80003634:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003636:	40000613          	li	a2,1024
    8000363a:	05850593          	addi	a1,a0,88
    8000363e:	05848513          	addi	a0,s1,88
    80003642:	ffffd097          	auipc	ra,0xffffd
    80003646:	b96080e7          	jalr	-1130(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    8000364a:	8526                	mv	a0,s1
    8000364c:	fffff097          	auipc	ra,0xfffff
    80003650:	d92080e7          	jalr	-622(ra) # 800023de <bwrite>
    brelse(from);
    80003654:	854e                	mv	a0,s3
    80003656:	fffff097          	auipc	ra,0xfffff
    8000365a:	dc6080e7          	jalr	-570(ra) # 8000241c <brelse>
    brelse(to);
    8000365e:	8526                	mv	a0,s1
    80003660:	fffff097          	auipc	ra,0xfffff
    80003664:	dbc080e7          	jalr	-580(ra) # 8000241c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003668:	2905                	addiw	s2,s2,1
    8000366a:	0a91                	addi	s5,s5,4
    8000366c:	02ca2783          	lw	a5,44(s4)
    80003670:	f8f94ee3          	blt	s2,a5,8000360c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003674:	00000097          	auipc	ra,0x0
    80003678:	c6a080e7          	jalr	-918(ra) # 800032de <write_head>
    install_trans(0); // Now install writes to home locations
    8000367c:	4501                	li	a0,0
    8000367e:	00000097          	auipc	ra,0x0
    80003682:	cda080e7          	jalr	-806(ra) # 80003358 <install_trans>
    log.lh.n = 0;
    80003686:	00017797          	auipc	a5,0x17
    8000368a:	9e07a323          	sw	zero,-1562(a5) # 8001a06c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000368e:	00000097          	auipc	ra,0x0
    80003692:	c50080e7          	jalr	-944(ra) # 800032de <write_head>
    80003696:	bdf5                	j	80003592 <end_op+0x52>

0000000080003698 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003698:	1101                	addi	sp,sp,-32
    8000369a:	ec06                	sd	ra,24(sp)
    8000369c:	e822                	sd	s0,16(sp)
    8000369e:	e426                	sd	s1,8(sp)
    800036a0:	e04a                	sd	s2,0(sp)
    800036a2:	1000                	addi	s0,sp,32
    800036a4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800036a6:	00017917          	auipc	s2,0x17
    800036aa:	99a90913          	addi	s2,s2,-1638 # 8001a040 <log>
    800036ae:	854a                	mv	a0,s2
    800036b0:	00004097          	auipc	ra,0x4
    800036b4:	a8e080e7          	jalr	-1394(ra) # 8000713e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036b8:	02c92603          	lw	a2,44(s2)
    800036bc:	47f5                	li	a5,29
    800036be:	06c7c563          	blt	a5,a2,80003728 <log_write+0x90>
    800036c2:	00017797          	auipc	a5,0x17
    800036c6:	99a7a783          	lw	a5,-1638(a5) # 8001a05c <log+0x1c>
    800036ca:	37fd                	addiw	a5,a5,-1
    800036cc:	04f65e63          	bge	a2,a5,80003728 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036d0:	00017797          	auipc	a5,0x17
    800036d4:	9907a783          	lw	a5,-1648(a5) # 8001a060 <log+0x20>
    800036d8:	06f05063          	blez	a5,80003738 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036dc:	4781                	li	a5,0
    800036de:	06c05563          	blez	a2,80003748 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036e2:	44cc                	lw	a1,12(s1)
    800036e4:	00017717          	auipc	a4,0x17
    800036e8:	98c70713          	addi	a4,a4,-1652 # 8001a070 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036ec:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036ee:	4314                	lw	a3,0(a4)
    800036f0:	04b68c63          	beq	a3,a1,80003748 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036f4:	2785                	addiw	a5,a5,1
    800036f6:	0711                	addi	a4,a4,4
    800036f8:	fef61be3          	bne	a2,a5,800036ee <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036fc:	0621                	addi	a2,a2,8
    800036fe:	060a                	slli	a2,a2,0x2
    80003700:	00017797          	auipc	a5,0x17
    80003704:	94078793          	addi	a5,a5,-1728 # 8001a040 <log>
    80003708:	963e                	add	a2,a2,a5
    8000370a:	44dc                	lw	a5,12(s1)
    8000370c:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000370e:	8526                	mv	a0,s1
    80003710:	fffff097          	auipc	ra,0xfffff
    80003714:	daa080e7          	jalr	-598(ra) # 800024ba <bpin>
    log.lh.n++;
    80003718:	00017717          	auipc	a4,0x17
    8000371c:	92870713          	addi	a4,a4,-1752 # 8001a040 <log>
    80003720:	575c                	lw	a5,44(a4)
    80003722:	2785                	addiw	a5,a5,1
    80003724:	d75c                	sw	a5,44(a4)
    80003726:	a835                	j	80003762 <log_write+0xca>
    panic("too big a transaction");
    80003728:	00006517          	auipc	a0,0x6
    8000372c:	ee050513          	addi	a0,a0,-288 # 80009608 <syscalls+0x230>
    80003730:	00003097          	auipc	ra,0x3
    80003734:	4c4080e7          	jalr	1220(ra) # 80006bf4 <panic>
    panic("log_write outside of trans");
    80003738:	00006517          	auipc	a0,0x6
    8000373c:	ee850513          	addi	a0,a0,-280 # 80009620 <syscalls+0x248>
    80003740:	00003097          	auipc	ra,0x3
    80003744:	4b4080e7          	jalr	1204(ra) # 80006bf4 <panic>
  log.lh.block[i] = b->blockno;
    80003748:	00878713          	addi	a4,a5,8
    8000374c:	00271693          	slli	a3,a4,0x2
    80003750:	00017717          	auipc	a4,0x17
    80003754:	8f070713          	addi	a4,a4,-1808 # 8001a040 <log>
    80003758:	9736                	add	a4,a4,a3
    8000375a:	44d4                	lw	a3,12(s1)
    8000375c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000375e:	faf608e3          	beq	a2,a5,8000370e <log_write+0x76>
  }
  release(&log.lock);
    80003762:	00017517          	auipc	a0,0x17
    80003766:	8de50513          	addi	a0,a0,-1826 # 8001a040 <log>
    8000376a:	00004097          	auipc	ra,0x4
    8000376e:	a88080e7          	jalr	-1400(ra) # 800071f2 <release>
}
    80003772:	60e2                	ld	ra,24(sp)
    80003774:	6442                	ld	s0,16(sp)
    80003776:	64a2                	ld	s1,8(sp)
    80003778:	6902                	ld	s2,0(sp)
    8000377a:	6105                	addi	sp,sp,32
    8000377c:	8082                	ret

000000008000377e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000377e:	1101                	addi	sp,sp,-32
    80003780:	ec06                	sd	ra,24(sp)
    80003782:	e822                	sd	s0,16(sp)
    80003784:	e426                	sd	s1,8(sp)
    80003786:	e04a                	sd	s2,0(sp)
    80003788:	1000                	addi	s0,sp,32
    8000378a:	84aa                	mv	s1,a0
    8000378c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000378e:	00006597          	auipc	a1,0x6
    80003792:	eb258593          	addi	a1,a1,-334 # 80009640 <syscalls+0x268>
    80003796:	0521                	addi	a0,a0,8
    80003798:	00004097          	auipc	ra,0x4
    8000379c:	916080e7          	jalr	-1770(ra) # 800070ae <initlock>
  lk->name = name;
    800037a0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800037a4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037a8:	0204a423          	sw	zero,40(s1)
}
    800037ac:	60e2                	ld	ra,24(sp)
    800037ae:	6442                	ld	s0,16(sp)
    800037b0:	64a2                	ld	s1,8(sp)
    800037b2:	6902                	ld	s2,0(sp)
    800037b4:	6105                	addi	sp,sp,32
    800037b6:	8082                	ret

00000000800037b8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037b8:	1101                	addi	sp,sp,-32
    800037ba:	ec06                	sd	ra,24(sp)
    800037bc:	e822                	sd	s0,16(sp)
    800037be:	e426                	sd	s1,8(sp)
    800037c0:	e04a                	sd	s2,0(sp)
    800037c2:	1000                	addi	s0,sp,32
    800037c4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037c6:	00850913          	addi	s2,a0,8
    800037ca:	854a                	mv	a0,s2
    800037cc:	00004097          	auipc	ra,0x4
    800037d0:	972080e7          	jalr	-1678(ra) # 8000713e <acquire>
  while (lk->locked) {
    800037d4:	409c                	lw	a5,0(s1)
    800037d6:	cb89                	beqz	a5,800037e8 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037d8:	85ca                	mv	a1,s2
    800037da:	8526                	mv	a0,s1
    800037dc:	ffffe097          	auipc	ra,0xffffe
    800037e0:	d80080e7          	jalr	-640(ra) # 8000155c <sleep>
  while (lk->locked) {
    800037e4:	409c                	lw	a5,0(s1)
    800037e6:	fbed                	bnez	a5,800037d8 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037e8:	4785                	li	a5,1
    800037ea:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037ec:	ffffd097          	auipc	ra,0xffffd
    800037f0:	6b4080e7          	jalr	1716(ra) # 80000ea0 <myproc>
    800037f4:	591c                	lw	a5,48(a0)
    800037f6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037f8:	854a                	mv	a0,s2
    800037fa:	00004097          	auipc	ra,0x4
    800037fe:	9f8080e7          	jalr	-1544(ra) # 800071f2 <release>
}
    80003802:	60e2                	ld	ra,24(sp)
    80003804:	6442                	ld	s0,16(sp)
    80003806:	64a2                	ld	s1,8(sp)
    80003808:	6902                	ld	s2,0(sp)
    8000380a:	6105                	addi	sp,sp,32
    8000380c:	8082                	ret

000000008000380e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000380e:	1101                	addi	sp,sp,-32
    80003810:	ec06                	sd	ra,24(sp)
    80003812:	e822                	sd	s0,16(sp)
    80003814:	e426                	sd	s1,8(sp)
    80003816:	e04a                	sd	s2,0(sp)
    80003818:	1000                	addi	s0,sp,32
    8000381a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000381c:	00850913          	addi	s2,a0,8
    80003820:	854a                	mv	a0,s2
    80003822:	00004097          	auipc	ra,0x4
    80003826:	91c080e7          	jalr	-1764(ra) # 8000713e <acquire>
  lk->locked = 0;
    8000382a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000382e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003832:	8526                	mv	a0,s1
    80003834:	ffffe097          	auipc	ra,0xffffe
    80003838:	eb4080e7          	jalr	-332(ra) # 800016e8 <wakeup>
  release(&lk->lk);
    8000383c:	854a                	mv	a0,s2
    8000383e:	00004097          	auipc	ra,0x4
    80003842:	9b4080e7          	jalr	-1612(ra) # 800071f2 <release>
}
    80003846:	60e2                	ld	ra,24(sp)
    80003848:	6442                	ld	s0,16(sp)
    8000384a:	64a2                	ld	s1,8(sp)
    8000384c:	6902                	ld	s2,0(sp)
    8000384e:	6105                	addi	sp,sp,32
    80003850:	8082                	ret

0000000080003852 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003852:	7179                	addi	sp,sp,-48
    80003854:	f406                	sd	ra,40(sp)
    80003856:	f022                	sd	s0,32(sp)
    80003858:	ec26                	sd	s1,24(sp)
    8000385a:	e84a                	sd	s2,16(sp)
    8000385c:	e44e                	sd	s3,8(sp)
    8000385e:	1800                	addi	s0,sp,48
    80003860:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003862:	00850913          	addi	s2,a0,8
    80003866:	854a                	mv	a0,s2
    80003868:	00004097          	auipc	ra,0x4
    8000386c:	8d6080e7          	jalr	-1834(ra) # 8000713e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003870:	409c                	lw	a5,0(s1)
    80003872:	ef99                	bnez	a5,80003890 <holdingsleep+0x3e>
    80003874:	4481                	li	s1,0
  release(&lk->lk);
    80003876:	854a                	mv	a0,s2
    80003878:	00004097          	auipc	ra,0x4
    8000387c:	97a080e7          	jalr	-1670(ra) # 800071f2 <release>
  return r;
}
    80003880:	8526                	mv	a0,s1
    80003882:	70a2                	ld	ra,40(sp)
    80003884:	7402                	ld	s0,32(sp)
    80003886:	64e2                	ld	s1,24(sp)
    80003888:	6942                	ld	s2,16(sp)
    8000388a:	69a2                	ld	s3,8(sp)
    8000388c:	6145                	addi	sp,sp,48
    8000388e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003890:	0284a983          	lw	s3,40(s1)
    80003894:	ffffd097          	auipc	ra,0xffffd
    80003898:	60c080e7          	jalr	1548(ra) # 80000ea0 <myproc>
    8000389c:	5904                	lw	s1,48(a0)
    8000389e:	413484b3          	sub	s1,s1,s3
    800038a2:	0014b493          	seqz	s1,s1
    800038a6:	bfc1                	j	80003876 <holdingsleep+0x24>

00000000800038a8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800038a8:	1141                	addi	sp,sp,-16
    800038aa:	e406                	sd	ra,8(sp)
    800038ac:	e022                	sd	s0,0(sp)
    800038ae:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800038b0:	00006597          	auipc	a1,0x6
    800038b4:	da058593          	addi	a1,a1,-608 # 80009650 <syscalls+0x278>
    800038b8:	00017517          	auipc	a0,0x17
    800038bc:	8d050513          	addi	a0,a0,-1840 # 8001a188 <ftable>
    800038c0:	00003097          	auipc	ra,0x3
    800038c4:	7ee080e7          	jalr	2030(ra) # 800070ae <initlock>
}
    800038c8:	60a2                	ld	ra,8(sp)
    800038ca:	6402                	ld	s0,0(sp)
    800038cc:	0141                	addi	sp,sp,16
    800038ce:	8082                	ret

00000000800038d0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038d0:	1101                	addi	sp,sp,-32
    800038d2:	ec06                	sd	ra,24(sp)
    800038d4:	e822                	sd	s0,16(sp)
    800038d6:	e426                	sd	s1,8(sp)
    800038d8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038da:	00017517          	auipc	a0,0x17
    800038de:	8ae50513          	addi	a0,a0,-1874 # 8001a188 <ftable>
    800038e2:	00004097          	auipc	ra,0x4
    800038e6:	85c080e7          	jalr	-1956(ra) # 8000713e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038ea:	00017497          	auipc	s1,0x17
    800038ee:	8b648493          	addi	s1,s1,-1866 # 8001a1a0 <ftable+0x18>
    800038f2:	00018717          	auipc	a4,0x18
    800038f6:	b6e70713          	addi	a4,a4,-1170 # 8001b460 <ftable+0x12d8>
    if(f->ref == 0){
    800038fa:	40dc                	lw	a5,4(s1)
    800038fc:	cf99                	beqz	a5,8000391a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038fe:	03048493          	addi	s1,s1,48
    80003902:	fee49ce3          	bne	s1,a4,800038fa <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003906:	00017517          	auipc	a0,0x17
    8000390a:	88250513          	addi	a0,a0,-1918 # 8001a188 <ftable>
    8000390e:	00004097          	auipc	ra,0x4
    80003912:	8e4080e7          	jalr	-1820(ra) # 800071f2 <release>
  return 0;
    80003916:	4481                	li	s1,0
    80003918:	a819                	j	8000392e <filealloc+0x5e>
      f->ref = 1;
    8000391a:	4785                	li	a5,1
    8000391c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000391e:	00017517          	auipc	a0,0x17
    80003922:	86a50513          	addi	a0,a0,-1942 # 8001a188 <ftable>
    80003926:	00004097          	auipc	ra,0x4
    8000392a:	8cc080e7          	jalr	-1844(ra) # 800071f2 <release>
}
    8000392e:	8526                	mv	a0,s1
    80003930:	60e2                	ld	ra,24(sp)
    80003932:	6442                	ld	s0,16(sp)
    80003934:	64a2                	ld	s1,8(sp)
    80003936:	6105                	addi	sp,sp,32
    80003938:	8082                	ret

000000008000393a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000393a:	1101                	addi	sp,sp,-32
    8000393c:	ec06                	sd	ra,24(sp)
    8000393e:	e822                	sd	s0,16(sp)
    80003940:	e426                	sd	s1,8(sp)
    80003942:	1000                	addi	s0,sp,32
    80003944:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003946:	00017517          	auipc	a0,0x17
    8000394a:	84250513          	addi	a0,a0,-1982 # 8001a188 <ftable>
    8000394e:	00003097          	auipc	ra,0x3
    80003952:	7f0080e7          	jalr	2032(ra) # 8000713e <acquire>
  if(f->ref < 1)
    80003956:	40dc                	lw	a5,4(s1)
    80003958:	02f05263          	blez	a5,8000397c <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000395c:	2785                	addiw	a5,a5,1
    8000395e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003960:	00017517          	auipc	a0,0x17
    80003964:	82850513          	addi	a0,a0,-2008 # 8001a188 <ftable>
    80003968:	00004097          	auipc	ra,0x4
    8000396c:	88a080e7          	jalr	-1910(ra) # 800071f2 <release>
  return f;
}
    80003970:	8526                	mv	a0,s1
    80003972:	60e2                	ld	ra,24(sp)
    80003974:	6442                	ld	s0,16(sp)
    80003976:	64a2                	ld	s1,8(sp)
    80003978:	6105                	addi	sp,sp,32
    8000397a:	8082                	ret
    panic("filedup");
    8000397c:	00006517          	auipc	a0,0x6
    80003980:	cdc50513          	addi	a0,a0,-804 # 80009658 <syscalls+0x280>
    80003984:	00003097          	auipc	ra,0x3
    80003988:	270080e7          	jalr	624(ra) # 80006bf4 <panic>

000000008000398c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000398c:	7139                	addi	sp,sp,-64
    8000398e:	fc06                	sd	ra,56(sp)
    80003990:	f822                	sd	s0,48(sp)
    80003992:	f426                	sd	s1,40(sp)
    80003994:	f04a                	sd	s2,32(sp)
    80003996:	ec4e                	sd	s3,24(sp)
    80003998:	e852                	sd	s4,16(sp)
    8000399a:	e456                	sd	s5,8(sp)
    8000399c:	e05a                	sd	s6,0(sp)
    8000399e:	0080                	addi	s0,sp,64
    800039a0:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800039a2:	00016517          	auipc	a0,0x16
    800039a6:	7e650513          	addi	a0,a0,2022 # 8001a188 <ftable>
    800039aa:	00003097          	auipc	ra,0x3
    800039ae:	794080e7          	jalr	1940(ra) # 8000713e <acquire>
  if(f->ref < 1)
    800039b2:	40dc                	lw	a5,4(s1)
    800039b4:	04f05f63          	blez	a5,80003a12 <fileclose+0x86>
    panic("fileclose");
  if(--f->ref > 0){
    800039b8:	37fd                	addiw	a5,a5,-1
    800039ba:	0007871b          	sext.w	a4,a5
    800039be:	c0dc                	sw	a5,4(s1)
    800039c0:	06e04163          	bgtz	a4,80003a22 <fileclose+0x96>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800039c4:	0004a903          	lw	s2,0(s1)
    800039c8:	0094ca83          	lbu	s5,9(s1)
    800039cc:	0104ba03          	ld	s4,16(s1)
    800039d0:	0184b983          	ld	s3,24(s1)
    800039d4:	0204bb03          	ld	s6,32(s1)
  f->ref = 0;
    800039d8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039dc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039e0:	00016517          	auipc	a0,0x16
    800039e4:	7a850513          	addi	a0,a0,1960 # 8001a188 <ftable>
    800039e8:	00004097          	auipc	ra,0x4
    800039ec:	80a080e7          	jalr	-2038(ra) # 800071f2 <release>

  if(ff.type == FD_PIPE){
    800039f0:	4785                	li	a5,1
    800039f2:	04f90a63          	beq	s2,a5,80003a46 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039f6:	ffe9079b          	addiw	a5,s2,-2
    800039fa:	4705                	li	a4,1
    800039fc:	04f77c63          	bgeu	a4,a5,80003a54 <fileclose+0xc8>
    begin_op();
    iput(ff.ip);
    end_op();
  }
#ifdef LAB_NET
  else if(ff.type == FD_SOCK){
    80003a00:	4791                	li	a5,4
    80003a02:	02f91863          	bne	s2,a5,80003a32 <fileclose+0xa6>
    sockclose(ff.sock);
    80003a06:	855a                	mv	a0,s6
    80003a08:	00003097          	auipc	ra,0x3
    80003a0c:	980080e7          	jalr	-1664(ra) # 80006388 <sockclose>
    80003a10:	a00d                	j	80003a32 <fileclose+0xa6>
    panic("fileclose");
    80003a12:	00006517          	auipc	a0,0x6
    80003a16:	c4e50513          	addi	a0,a0,-946 # 80009660 <syscalls+0x288>
    80003a1a:	00003097          	auipc	ra,0x3
    80003a1e:	1da080e7          	jalr	474(ra) # 80006bf4 <panic>
    release(&ftable.lock);
    80003a22:	00016517          	auipc	a0,0x16
    80003a26:	76650513          	addi	a0,a0,1894 # 8001a188 <ftable>
    80003a2a:	00003097          	auipc	ra,0x3
    80003a2e:	7c8080e7          	jalr	1992(ra) # 800071f2 <release>
  }
#endif
}
    80003a32:	70e2                	ld	ra,56(sp)
    80003a34:	7442                	ld	s0,48(sp)
    80003a36:	74a2                	ld	s1,40(sp)
    80003a38:	7902                	ld	s2,32(sp)
    80003a3a:	69e2                	ld	s3,24(sp)
    80003a3c:	6a42                	ld	s4,16(sp)
    80003a3e:	6aa2                	ld	s5,8(sp)
    80003a40:	6b02                	ld	s6,0(sp)
    80003a42:	6121                	addi	sp,sp,64
    80003a44:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a46:	85d6                	mv	a1,s5
    80003a48:	8552                	mv	a0,s4
    80003a4a:	00000097          	auipc	ra,0x0
    80003a4e:	37c080e7          	jalr	892(ra) # 80003dc6 <pipeclose>
    80003a52:	b7c5                	j	80003a32 <fileclose+0xa6>
    begin_op();
    80003a54:	00000097          	auipc	ra,0x0
    80003a58:	a6c080e7          	jalr	-1428(ra) # 800034c0 <begin_op>
    iput(ff.ip);
    80003a5c:	854e                	mv	a0,s3
    80003a5e:	fffff097          	auipc	ra,0xfffff
    80003a62:	24a080e7          	jalr	586(ra) # 80002ca8 <iput>
    end_op();
    80003a66:	00000097          	auipc	ra,0x0
    80003a6a:	ada080e7          	jalr	-1318(ra) # 80003540 <end_op>
    80003a6e:	b7d1                	j	80003a32 <fileclose+0xa6>

0000000080003a70 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a70:	715d                	addi	sp,sp,-80
    80003a72:	e486                	sd	ra,72(sp)
    80003a74:	e0a2                	sd	s0,64(sp)
    80003a76:	fc26                	sd	s1,56(sp)
    80003a78:	f84a                	sd	s2,48(sp)
    80003a7a:	f44e                	sd	s3,40(sp)
    80003a7c:	0880                	addi	s0,sp,80
    80003a7e:	84aa                	mv	s1,a0
    80003a80:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a82:	ffffd097          	auipc	ra,0xffffd
    80003a86:	41e080e7          	jalr	1054(ra) # 80000ea0 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a8a:	409c                	lw	a5,0(s1)
    80003a8c:	37f9                	addiw	a5,a5,-2
    80003a8e:	4705                	li	a4,1
    80003a90:	04f76763          	bltu	a4,a5,80003ade <filestat+0x6e>
    80003a94:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a96:	6c88                	ld	a0,24(s1)
    80003a98:	fffff097          	auipc	ra,0xfffff
    80003a9c:	056080e7          	jalr	86(ra) # 80002aee <ilock>
    stati(f->ip, &st);
    80003aa0:	fb840593          	addi	a1,s0,-72
    80003aa4:	6c88                	ld	a0,24(s1)
    80003aa6:	fffff097          	auipc	ra,0xfffff
    80003aaa:	2d2080e7          	jalr	722(ra) # 80002d78 <stati>
    iunlock(f->ip);
    80003aae:	6c88                	ld	a0,24(s1)
    80003ab0:	fffff097          	auipc	ra,0xfffff
    80003ab4:	100080e7          	jalr	256(ra) # 80002bb0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ab8:	46e1                	li	a3,24
    80003aba:	fb840613          	addi	a2,s0,-72
    80003abe:	85ce                	mv	a1,s3
    80003ac0:	05093503          	ld	a0,80(s2)
    80003ac4:	ffffd097          	auipc	ra,0xffffd
    80003ac8:	0a2080e7          	jalr	162(ra) # 80000b66 <copyout>
    80003acc:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003ad0:	60a6                	ld	ra,72(sp)
    80003ad2:	6406                	ld	s0,64(sp)
    80003ad4:	74e2                	ld	s1,56(sp)
    80003ad6:	7942                	ld	s2,48(sp)
    80003ad8:	79a2                	ld	s3,40(sp)
    80003ada:	6161                	addi	sp,sp,80
    80003adc:	8082                	ret
  return -1;
    80003ade:	557d                	li	a0,-1
    80003ae0:	bfc5                	j	80003ad0 <filestat+0x60>

0000000080003ae2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ae2:	7179                	addi	sp,sp,-48
    80003ae4:	f406                	sd	ra,40(sp)
    80003ae6:	f022                	sd	s0,32(sp)
    80003ae8:	ec26                	sd	s1,24(sp)
    80003aea:	e84a                	sd	s2,16(sp)
    80003aec:	e44e                	sd	s3,8(sp)
    80003aee:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003af0:	00854783          	lbu	a5,8(a0)
    80003af4:	cfc5                	beqz	a5,80003bac <fileread+0xca>
    80003af6:	84aa                	mv	s1,a0
    80003af8:	89ae                	mv	s3,a1
    80003afa:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003afc:	411c                	lw	a5,0(a0)
    80003afe:	4705                	li	a4,1
    80003b00:	02e78963          	beq	a5,a4,80003b32 <fileread+0x50>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b04:	470d                	li	a4,3
    80003b06:	02e78d63          	beq	a5,a4,80003b40 <fileread+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b0a:	4709                	li	a4,2
    80003b0c:	04e78e63          	beq	a5,a4,80003b68 <fileread+0x86>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
  }
#ifdef LAB_NET
  else if(f->type == FD_SOCK){
    80003b10:	4711                	li	a4,4
    80003b12:	08e79563          	bne	a5,a4,80003b9c <fileread+0xba>
    r = sockread(f->sock, addr, n);
    80003b16:	7108                	ld	a0,32(a0)
    80003b18:	00003097          	auipc	ra,0x3
    80003b1c:	900080e7          	jalr	-1792(ra) # 80006418 <sockread>
    80003b20:	892a                	mv	s2,a0
  else {
    panic("fileread");
  }

  return r;
}
    80003b22:	854a                	mv	a0,s2
    80003b24:	70a2                	ld	ra,40(sp)
    80003b26:	7402                	ld	s0,32(sp)
    80003b28:	64e2                	ld	s1,24(sp)
    80003b2a:	6942                	ld	s2,16(sp)
    80003b2c:	69a2                	ld	s3,8(sp)
    80003b2e:	6145                	addi	sp,sp,48
    80003b30:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b32:	6908                	ld	a0,16(a0)
    80003b34:	00000097          	auipc	ra,0x0
    80003b38:	3fc080e7          	jalr	1020(ra) # 80003f30 <piperead>
    80003b3c:	892a                	mv	s2,a0
    80003b3e:	b7d5                	j	80003b22 <fileread+0x40>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b40:	02c51783          	lh	a5,44(a0)
    80003b44:	03079693          	slli	a3,a5,0x30
    80003b48:	92c1                	srli	a3,a3,0x30
    80003b4a:	4725                	li	a4,9
    80003b4c:	06d76263          	bltu	a4,a3,80003bb0 <fileread+0xce>
    80003b50:	0792                	slli	a5,a5,0x4
    80003b52:	00016717          	auipc	a4,0x16
    80003b56:	59670713          	addi	a4,a4,1430 # 8001a0e8 <devsw>
    80003b5a:	97ba                	add	a5,a5,a4
    80003b5c:	639c                	ld	a5,0(a5)
    80003b5e:	cbb9                	beqz	a5,80003bb4 <fileread+0xd2>
    r = devsw[f->major].read(1, addr, n);
    80003b60:	4505                	li	a0,1
    80003b62:	9782                	jalr	a5
    80003b64:	892a                	mv	s2,a0
    80003b66:	bf75                	j	80003b22 <fileread+0x40>
    ilock(f->ip);
    80003b68:	6d08                	ld	a0,24(a0)
    80003b6a:	fffff097          	auipc	ra,0xfffff
    80003b6e:	f84080e7          	jalr	-124(ra) # 80002aee <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b72:	874a                	mv	a4,s2
    80003b74:	5494                	lw	a3,40(s1)
    80003b76:	864e                	mv	a2,s3
    80003b78:	4585                	li	a1,1
    80003b7a:	6c88                	ld	a0,24(s1)
    80003b7c:	fffff097          	auipc	ra,0xfffff
    80003b80:	226080e7          	jalr	550(ra) # 80002da2 <readi>
    80003b84:	892a                	mv	s2,a0
    80003b86:	00a05563          	blez	a0,80003b90 <fileread+0xae>
      f->off += r;
    80003b8a:	549c                	lw	a5,40(s1)
    80003b8c:	9fa9                	addw	a5,a5,a0
    80003b8e:	d49c                	sw	a5,40(s1)
    iunlock(f->ip);
    80003b90:	6c88                	ld	a0,24(s1)
    80003b92:	fffff097          	auipc	ra,0xfffff
    80003b96:	01e080e7          	jalr	30(ra) # 80002bb0 <iunlock>
    80003b9a:	b761                	j	80003b22 <fileread+0x40>
    panic("fileread");
    80003b9c:	00006517          	auipc	a0,0x6
    80003ba0:	ad450513          	addi	a0,a0,-1324 # 80009670 <syscalls+0x298>
    80003ba4:	00003097          	auipc	ra,0x3
    80003ba8:	050080e7          	jalr	80(ra) # 80006bf4 <panic>
    return -1;
    80003bac:	597d                	li	s2,-1
    80003bae:	bf95                	j	80003b22 <fileread+0x40>
      return -1;
    80003bb0:	597d                	li	s2,-1
    80003bb2:	bf85                	j	80003b22 <fileread+0x40>
    80003bb4:	597d                	li	s2,-1
    80003bb6:	b7b5                	j	80003b22 <fileread+0x40>

0000000080003bb8 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003bb8:	00954783          	lbu	a5,9(a0)
    80003bbc:	12078263          	beqz	a5,80003ce0 <filewrite+0x128>
{
    80003bc0:	715d                	addi	sp,sp,-80
    80003bc2:	e486                	sd	ra,72(sp)
    80003bc4:	e0a2                	sd	s0,64(sp)
    80003bc6:	fc26                	sd	s1,56(sp)
    80003bc8:	f84a                	sd	s2,48(sp)
    80003bca:	f44e                	sd	s3,40(sp)
    80003bcc:	f052                	sd	s4,32(sp)
    80003bce:	ec56                	sd	s5,24(sp)
    80003bd0:	e85a                	sd	s6,16(sp)
    80003bd2:	e45e                	sd	s7,8(sp)
    80003bd4:	e062                	sd	s8,0(sp)
    80003bd6:	0880                	addi	s0,sp,80
    80003bd8:	84aa                	mv	s1,a0
    80003bda:	8aae                	mv	s5,a1
    80003bdc:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bde:	411c                	lw	a5,0(a0)
    80003be0:	4705                	li	a4,1
    80003be2:	02e78c63          	beq	a5,a4,80003c1a <filewrite+0x62>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003be6:	470d                	li	a4,3
    80003be8:	02e78f63          	beq	a5,a4,80003c26 <filewrite+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bec:	4709                	li	a4,2
    80003bee:	04e78f63          	beq	a5,a4,80003c4c <filewrite+0x94>
      i += r;
    }
    ret = (i == n ? n : -1);
  }
#ifdef LAB_NET
  else if(f->type == FD_SOCK){
    80003bf2:	4711                	li	a4,4
    80003bf4:	0ce79e63          	bne	a5,a4,80003cd0 <filewrite+0x118>
    ret = sockwrite(f->sock, addr, n);
    80003bf8:	7108                	ld	a0,32(a0)
    80003bfa:	00003097          	auipc	ra,0x3
    80003bfe:	8ee080e7          	jalr	-1810(ra) # 800064e8 <sockwrite>
  else {
    panic("filewrite");
  }

  return ret;
}
    80003c02:	60a6                	ld	ra,72(sp)
    80003c04:	6406                	ld	s0,64(sp)
    80003c06:	74e2                	ld	s1,56(sp)
    80003c08:	7942                	ld	s2,48(sp)
    80003c0a:	79a2                	ld	s3,40(sp)
    80003c0c:	7a02                	ld	s4,32(sp)
    80003c0e:	6ae2                	ld	s5,24(sp)
    80003c10:	6b42                	ld	s6,16(sp)
    80003c12:	6ba2                	ld	s7,8(sp)
    80003c14:	6c02                	ld	s8,0(sp)
    80003c16:	6161                	addi	sp,sp,80
    80003c18:	8082                	ret
    ret = pipewrite(f->pipe, addr, n);
    80003c1a:	6908                	ld	a0,16(a0)
    80003c1c:	00000097          	auipc	ra,0x0
    80003c20:	21a080e7          	jalr	538(ra) # 80003e36 <pipewrite>
    80003c24:	bff9                	j	80003c02 <filewrite+0x4a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c26:	02c51783          	lh	a5,44(a0)
    80003c2a:	03079693          	slli	a3,a5,0x30
    80003c2e:	92c1                	srli	a3,a3,0x30
    80003c30:	4725                	li	a4,9
    80003c32:	0ad76963          	bltu	a4,a3,80003ce4 <filewrite+0x12c>
    80003c36:	0792                	slli	a5,a5,0x4
    80003c38:	00016717          	auipc	a4,0x16
    80003c3c:	4b070713          	addi	a4,a4,1200 # 8001a0e8 <devsw>
    80003c40:	97ba                	add	a5,a5,a4
    80003c42:	679c                	ld	a5,8(a5)
    80003c44:	c3d5                	beqz	a5,80003ce8 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003c46:	4505                	li	a0,1
    80003c48:	9782                	jalr	a5
    80003c4a:	bf65                	j	80003c02 <filewrite+0x4a>
    while(i < n){
    80003c4c:	06c05c63          	blez	a2,80003cc4 <filewrite+0x10c>
    int i = 0;
    80003c50:	4981                	li	s3,0
    80003c52:	6b05                	lui	s6,0x1
    80003c54:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c58:	6b85                	lui	s7,0x1
    80003c5a:	c00b8b9b          	addiw	s7,s7,-1024
    80003c5e:	a899                	j	80003cb4 <filewrite+0xfc>
    80003c60:	00090c1b          	sext.w	s8,s2
      begin_op();
    80003c64:	00000097          	auipc	ra,0x0
    80003c68:	85c080e7          	jalr	-1956(ra) # 800034c0 <begin_op>
      ilock(f->ip);
    80003c6c:	6c88                	ld	a0,24(s1)
    80003c6e:	fffff097          	auipc	ra,0xfffff
    80003c72:	e80080e7          	jalr	-384(ra) # 80002aee <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c76:	8762                	mv	a4,s8
    80003c78:	5494                	lw	a3,40(s1)
    80003c7a:	01598633          	add	a2,s3,s5
    80003c7e:	4585                	li	a1,1
    80003c80:	6c88                	ld	a0,24(s1)
    80003c82:	fffff097          	auipc	ra,0xfffff
    80003c86:	218080e7          	jalr	536(ra) # 80002e9a <writei>
    80003c8a:	892a                	mv	s2,a0
    80003c8c:	00a05563          	blez	a0,80003c96 <filewrite+0xde>
        f->off += r;
    80003c90:	549c                	lw	a5,40(s1)
    80003c92:	9fa9                	addw	a5,a5,a0
    80003c94:	d49c                	sw	a5,40(s1)
      iunlock(f->ip);
    80003c96:	6c88                	ld	a0,24(s1)
    80003c98:	fffff097          	auipc	ra,0xfffff
    80003c9c:	f18080e7          	jalr	-232(ra) # 80002bb0 <iunlock>
      end_op();
    80003ca0:	00000097          	auipc	ra,0x0
    80003ca4:	8a0080e7          	jalr	-1888(ra) # 80003540 <end_op>
      if(r != n1){
    80003ca8:	012c1f63          	bne	s8,s2,80003cc6 <filewrite+0x10e>
      i += r;
    80003cac:	013909bb          	addw	s3,s2,s3
    while(i < n){
    80003cb0:	0149db63          	bge	s3,s4,80003cc6 <filewrite+0x10e>
      int n1 = n - i;
    80003cb4:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003cb8:	893e                	mv	s2,a5
    80003cba:	2781                	sext.w	a5,a5
    80003cbc:	fafb52e3          	bge	s6,a5,80003c60 <filewrite+0xa8>
    80003cc0:	895e                	mv	s2,s7
    80003cc2:	bf79                	j	80003c60 <filewrite+0xa8>
    int i = 0;
    80003cc4:	4981                	li	s3,0
    ret = (i == n ? n : -1);
    80003cc6:	8552                	mv	a0,s4
    80003cc8:	f33a0de3          	beq	s4,s3,80003c02 <filewrite+0x4a>
    80003ccc:	557d                	li	a0,-1
    80003cce:	bf15                	j	80003c02 <filewrite+0x4a>
    panic("filewrite");
    80003cd0:	00006517          	auipc	a0,0x6
    80003cd4:	9b050513          	addi	a0,a0,-1616 # 80009680 <syscalls+0x2a8>
    80003cd8:	00003097          	auipc	ra,0x3
    80003cdc:	f1c080e7          	jalr	-228(ra) # 80006bf4 <panic>
    return -1;
    80003ce0:	557d                	li	a0,-1
}
    80003ce2:	8082                	ret
      return -1;
    80003ce4:	557d                	li	a0,-1
    80003ce6:	bf31                	j	80003c02 <filewrite+0x4a>
    80003ce8:	557d                	li	a0,-1
    80003cea:	bf21                	j	80003c02 <filewrite+0x4a>

0000000080003cec <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003cec:	7179                	addi	sp,sp,-48
    80003cee:	f406                	sd	ra,40(sp)
    80003cf0:	f022                	sd	s0,32(sp)
    80003cf2:	ec26                	sd	s1,24(sp)
    80003cf4:	e84a                	sd	s2,16(sp)
    80003cf6:	e44e                	sd	s3,8(sp)
    80003cf8:	e052                	sd	s4,0(sp)
    80003cfa:	1800                	addi	s0,sp,48
    80003cfc:	84aa                	mv	s1,a0
    80003cfe:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d00:	0005b023          	sd	zero,0(a1)
    80003d04:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d08:	00000097          	auipc	ra,0x0
    80003d0c:	bc8080e7          	jalr	-1080(ra) # 800038d0 <filealloc>
    80003d10:	e088                	sd	a0,0(s1)
    80003d12:	c551                	beqz	a0,80003d9e <pipealloc+0xb2>
    80003d14:	00000097          	auipc	ra,0x0
    80003d18:	bbc080e7          	jalr	-1092(ra) # 800038d0 <filealloc>
    80003d1c:	00aa3023          	sd	a0,0(s4)
    80003d20:	c92d                	beqz	a0,80003d92 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d22:	ffffc097          	auipc	ra,0xffffc
    80003d26:	3f6080e7          	jalr	1014(ra) # 80000118 <kalloc>
    80003d2a:	892a                	mv	s2,a0
    80003d2c:	c125                	beqz	a0,80003d8c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d2e:	4985                	li	s3,1
    80003d30:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d34:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d38:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d3c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d40:	00006597          	auipc	a1,0x6
    80003d44:	95058593          	addi	a1,a1,-1712 # 80009690 <syscalls+0x2b8>
    80003d48:	00003097          	auipc	ra,0x3
    80003d4c:	366080e7          	jalr	870(ra) # 800070ae <initlock>
  (*f0)->type = FD_PIPE;
    80003d50:	609c                	ld	a5,0(s1)
    80003d52:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d56:	609c                	ld	a5,0(s1)
    80003d58:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d5c:	609c                	ld	a5,0(s1)
    80003d5e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d62:	609c                	ld	a5,0(s1)
    80003d64:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d68:	000a3783          	ld	a5,0(s4)
    80003d6c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d70:	000a3783          	ld	a5,0(s4)
    80003d74:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d78:	000a3783          	ld	a5,0(s4)
    80003d7c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d80:	000a3783          	ld	a5,0(s4)
    80003d84:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d88:	4501                	li	a0,0
    80003d8a:	a025                	j	80003db2 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d8c:	6088                	ld	a0,0(s1)
    80003d8e:	e501                	bnez	a0,80003d96 <pipealloc+0xaa>
    80003d90:	a039                	j	80003d9e <pipealloc+0xb2>
    80003d92:	6088                	ld	a0,0(s1)
    80003d94:	c51d                	beqz	a0,80003dc2 <pipealloc+0xd6>
    fileclose(*f0);
    80003d96:	00000097          	auipc	ra,0x0
    80003d9a:	bf6080e7          	jalr	-1034(ra) # 8000398c <fileclose>
  if(*f1)
    80003d9e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003da2:	557d                	li	a0,-1
  if(*f1)
    80003da4:	c799                	beqz	a5,80003db2 <pipealloc+0xc6>
    fileclose(*f1);
    80003da6:	853e                	mv	a0,a5
    80003da8:	00000097          	auipc	ra,0x0
    80003dac:	be4080e7          	jalr	-1052(ra) # 8000398c <fileclose>
  return -1;
    80003db0:	557d                	li	a0,-1
}
    80003db2:	70a2                	ld	ra,40(sp)
    80003db4:	7402                	ld	s0,32(sp)
    80003db6:	64e2                	ld	s1,24(sp)
    80003db8:	6942                	ld	s2,16(sp)
    80003dba:	69a2                	ld	s3,8(sp)
    80003dbc:	6a02                	ld	s4,0(sp)
    80003dbe:	6145                	addi	sp,sp,48
    80003dc0:	8082                	ret
  return -1;
    80003dc2:	557d                	li	a0,-1
    80003dc4:	b7fd                	j	80003db2 <pipealloc+0xc6>

0000000080003dc6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003dc6:	1101                	addi	sp,sp,-32
    80003dc8:	ec06                	sd	ra,24(sp)
    80003dca:	e822                	sd	s0,16(sp)
    80003dcc:	e426                	sd	s1,8(sp)
    80003dce:	e04a                	sd	s2,0(sp)
    80003dd0:	1000                	addi	s0,sp,32
    80003dd2:	84aa                	mv	s1,a0
    80003dd4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003dd6:	00003097          	auipc	ra,0x3
    80003dda:	368080e7          	jalr	872(ra) # 8000713e <acquire>
  if(writable){
    80003dde:	02090d63          	beqz	s2,80003e18 <pipeclose+0x52>
    pi->writeopen = 0;
    80003de2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003de6:	21848513          	addi	a0,s1,536
    80003dea:	ffffe097          	auipc	ra,0xffffe
    80003dee:	8fe080e7          	jalr	-1794(ra) # 800016e8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003df2:	2204b783          	ld	a5,544(s1)
    80003df6:	eb95                	bnez	a5,80003e2a <pipeclose+0x64>
    release(&pi->lock);
    80003df8:	8526                	mv	a0,s1
    80003dfa:	00003097          	auipc	ra,0x3
    80003dfe:	3f8080e7          	jalr	1016(ra) # 800071f2 <release>
    kfree((char*)pi);
    80003e02:	8526                	mv	a0,s1
    80003e04:	ffffc097          	auipc	ra,0xffffc
    80003e08:	218080e7          	jalr	536(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e0c:	60e2                	ld	ra,24(sp)
    80003e0e:	6442                	ld	s0,16(sp)
    80003e10:	64a2                	ld	s1,8(sp)
    80003e12:	6902                	ld	s2,0(sp)
    80003e14:	6105                	addi	sp,sp,32
    80003e16:	8082                	ret
    pi->readopen = 0;
    80003e18:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e1c:	21c48513          	addi	a0,s1,540
    80003e20:	ffffe097          	auipc	ra,0xffffe
    80003e24:	8c8080e7          	jalr	-1848(ra) # 800016e8 <wakeup>
    80003e28:	b7e9                	j	80003df2 <pipeclose+0x2c>
    release(&pi->lock);
    80003e2a:	8526                	mv	a0,s1
    80003e2c:	00003097          	auipc	ra,0x3
    80003e30:	3c6080e7          	jalr	966(ra) # 800071f2 <release>
}
    80003e34:	bfe1                	j	80003e0c <pipeclose+0x46>

0000000080003e36 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e36:	7159                	addi	sp,sp,-112
    80003e38:	f486                	sd	ra,104(sp)
    80003e3a:	f0a2                	sd	s0,96(sp)
    80003e3c:	eca6                	sd	s1,88(sp)
    80003e3e:	e8ca                	sd	s2,80(sp)
    80003e40:	e4ce                	sd	s3,72(sp)
    80003e42:	e0d2                	sd	s4,64(sp)
    80003e44:	fc56                	sd	s5,56(sp)
    80003e46:	f85a                	sd	s6,48(sp)
    80003e48:	f45e                	sd	s7,40(sp)
    80003e4a:	f062                	sd	s8,32(sp)
    80003e4c:	ec66                	sd	s9,24(sp)
    80003e4e:	1880                	addi	s0,sp,112
    80003e50:	84aa                	mv	s1,a0
    80003e52:	8aae                	mv	s5,a1
    80003e54:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e56:	ffffd097          	auipc	ra,0xffffd
    80003e5a:	04a080e7          	jalr	74(ra) # 80000ea0 <myproc>
    80003e5e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e60:	8526                	mv	a0,s1
    80003e62:	00003097          	auipc	ra,0x3
    80003e66:	2dc080e7          	jalr	732(ra) # 8000713e <acquire>
  while(i < n){
    80003e6a:	0d405163          	blez	s4,80003f2c <pipewrite+0xf6>
    80003e6e:	8ba6                	mv	s7,s1
  int i = 0;
    80003e70:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e72:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e74:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e78:	21c48c13          	addi	s8,s1,540
    80003e7c:	a08d                	j	80003ede <pipewrite+0xa8>
      release(&pi->lock);
    80003e7e:	8526                	mv	a0,s1
    80003e80:	00003097          	auipc	ra,0x3
    80003e84:	372080e7          	jalr	882(ra) # 800071f2 <release>
      return -1;
    80003e88:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e8a:	854a                	mv	a0,s2
    80003e8c:	70a6                	ld	ra,104(sp)
    80003e8e:	7406                	ld	s0,96(sp)
    80003e90:	64e6                	ld	s1,88(sp)
    80003e92:	6946                	ld	s2,80(sp)
    80003e94:	69a6                	ld	s3,72(sp)
    80003e96:	6a06                	ld	s4,64(sp)
    80003e98:	7ae2                	ld	s5,56(sp)
    80003e9a:	7b42                	ld	s6,48(sp)
    80003e9c:	7ba2                	ld	s7,40(sp)
    80003e9e:	7c02                	ld	s8,32(sp)
    80003ea0:	6ce2                	ld	s9,24(sp)
    80003ea2:	6165                	addi	sp,sp,112
    80003ea4:	8082                	ret
      wakeup(&pi->nread);
    80003ea6:	8566                	mv	a0,s9
    80003ea8:	ffffe097          	auipc	ra,0xffffe
    80003eac:	840080e7          	jalr	-1984(ra) # 800016e8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003eb0:	85de                	mv	a1,s7
    80003eb2:	8562                	mv	a0,s8
    80003eb4:	ffffd097          	auipc	ra,0xffffd
    80003eb8:	6a8080e7          	jalr	1704(ra) # 8000155c <sleep>
    80003ebc:	a839                	j	80003eda <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ebe:	21c4a783          	lw	a5,540(s1)
    80003ec2:	0017871b          	addiw	a4,a5,1
    80003ec6:	20e4ae23          	sw	a4,540(s1)
    80003eca:	1ff7f793          	andi	a5,a5,511
    80003ece:	97a6                	add	a5,a5,s1
    80003ed0:	f9f44703          	lbu	a4,-97(s0)
    80003ed4:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ed8:	2905                	addiw	s2,s2,1
  while(i < n){
    80003eda:	03495d63          	bge	s2,s4,80003f14 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003ede:	2204a783          	lw	a5,544(s1)
    80003ee2:	dfd1                	beqz	a5,80003e7e <pipewrite+0x48>
    80003ee4:	0289a783          	lw	a5,40(s3)
    80003ee8:	fbd9                	bnez	a5,80003e7e <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003eea:	2184a783          	lw	a5,536(s1)
    80003eee:	21c4a703          	lw	a4,540(s1)
    80003ef2:	2007879b          	addiw	a5,a5,512
    80003ef6:	faf708e3          	beq	a4,a5,80003ea6 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003efa:	4685                	li	a3,1
    80003efc:	01590633          	add	a2,s2,s5
    80003f00:	f9f40593          	addi	a1,s0,-97
    80003f04:	0509b503          	ld	a0,80(s3)
    80003f08:	ffffd097          	auipc	ra,0xffffd
    80003f0c:	cea080e7          	jalr	-790(ra) # 80000bf2 <copyin>
    80003f10:	fb6517e3          	bne	a0,s6,80003ebe <pipewrite+0x88>
  wakeup(&pi->nread);
    80003f14:	21848513          	addi	a0,s1,536
    80003f18:	ffffd097          	auipc	ra,0xffffd
    80003f1c:	7d0080e7          	jalr	2000(ra) # 800016e8 <wakeup>
  release(&pi->lock);
    80003f20:	8526                	mv	a0,s1
    80003f22:	00003097          	auipc	ra,0x3
    80003f26:	2d0080e7          	jalr	720(ra) # 800071f2 <release>
  return i;
    80003f2a:	b785                	j	80003e8a <pipewrite+0x54>
  int i = 0;
    80003f2c:	4901                	li	s2,0
    80003f2e:	b7dd                	j	80003f14 <pipewrite+0xde>

0000000080003f30 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f30:	715d                	addi	sp,sp,-80
    80003f32:	e486                	sd	ra,72(sp)
    80003f34:	e0a2                	sd	s0,64(sp)
    80003f36:	fc26                	sd	s1,56(sp)
    80003f38:	f84a                	sd	s2,48(sp)
    80003f3a:	f44e                	sd	s3,40(sp)
    80003f3c:	f052                	sd	s4,32(sp)
    80003f3e:	ec56                	sd	s5,24(sp)
    80003f40:	e85a                	sd	s6,16(sp)
    80003f42:	0880                	addi	s0,sp,80
    80003f44:	84aa                	mv	s1,a0
    80003f46:	892e                	mv	s2,a1
    80003f48:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f4a:	ffffd097          	auipc	ra,0xffffd
    80003f4e:	f56080e7          	jalr	-170(ra) # 80000ea0 <myproc>
    80003f52:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f54:	8b26                	mv	s6,s1
    80003f56:	8526                	mv	a0,s1
    80003f58:	00003097          	auipc	ra,0x3
    80003f5c:	1e6080e7          	jalr	486(ra) # 8000713e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f60:	2184a703          	lw	a4,536(s1)
    80003f64:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f68:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f6c:	02f71463          	bne	a4,a5,80003f94 <piperead+0x64>
    80003f70:	2244a783          	lw	a5,548(s1)
    80003f74:	c385                	beqz	a5,80003f94 <piperead+0x64>
    if(pr->killed){
    80003f76:	028a2783          	lw	a5,40(s4)
    80003f7a:	ebc1                	bnez	a5,8000400a <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f7c:	85da                	mv	a1,s6
    80003f7e:	854e                	mv	a0,s3
    80003f80:	ffffd097          	auipc	ra,0xffffd
    80003f84:	5dc080e7          	jalr	1500(ra) # 8000155c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f88:	2184a703          	lw	a4,536(s1)
    80003f8c:	21c4a783          	lw	a5,540(s1)
    80003f90:	fef700e3          	beq	a4,a5,80003f70 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f94:	09505263          	blez	s5,80004018 <piperead+0xe8>
    80003f98:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f9a:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80003f9c:	2184a783          	lw	a5,536(s1)
    80003fa0:	21c4a703          	lw	a4,540(s1)
    80003fa4:	02f70d63          	beq	a4,a5,80003fde <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003fa8:	0017871b          	addiw	a4,a5,1
    80003fac:	20e4ac23          	sw	a4,536(s1)
    80003fb0:	1ff7f793          	andi	a5,a5,511
    80003fb4:	97a6                	add	a5,a5,s1
    80003fb6:	0187c783          	lbu	a5,24(a5)
    80003fba:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fbe:	4685                	li	a3,1
    80003fc0:	fbf40613          	addi	a2,s0,-65
    80003fc4:	85ca                	mv	a1,s2
    80003fc6:	050a3503          	ld	a0,80(s4)
    80003fca:	ffffd097          	auipc	ra,0xffffd
    80003fce:	b9c080e7          	jalr	-1124(ra) # 80000b66 <copyout>
    80003fd2:	01650663          	beq	a0,s6,80003fde <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fd6:	2985                	addiw	s3,s3,1
    80003fd8:	0905                	addi	s2,s2,1
    80003fda:	fd3a91e3          	bne	s5,s3,80003f9c <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003fde:	21c48513          	addi	a0,s1,540
    80003fe2:	ffffd097          	auipc	ra,0xffffd
    80003fe6:	706080e7          	jalr	1798(ra) # 800016e8 <wakeup>
  release(&pi->lock);
    80003fea:	8526                	mv	a0,s1
    80003fec:	00003097          	auipc	ra,0x3
    80003ff0:	206080e7          	jalr	518(ra) # 800071f2 <release>
  return i;
}
    80003ff4:	854e                	mv	a0,s3
    80003ff6:	60a6                	ld	ra,72(sp)
    80003ff8:	6406                	ld	s0,64(sp)
    80003ffa:	74e2                	ld	s1,56(sp)
    80003ffc:	7942                	ld	s2,48(sp)
    80003ffe:	79a2                	ld	s3,40(sp)
    80004000:	7a02                	ld	s4,32(sp)
    80004002:	6ae2                	ld	s5,24(sp)
    80004004:	6b42                	ld	s6,16(sp)
    80004006:	6161                	addi	sp,sp,80
    80004008:	8082                	ret
      release(&pi->lock);
    8000400a:	8526                	mv	a0,s1
    8000400c:	00003097          	auipc	ra,0x3
    80004010:	1e6080e7          	jalr	486(ra) # 800071f2 <release>
      return -1;
    80004014:	59fd                	li	s3,-1
    80004016:	bff9                	j	80003ff4 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004018:	4981                	li	s3,0
    8000401a:	b7d1                	j	80003fde <piperead+0xae>

000000008000401c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000401c:	df010113          	addi	sp,sp,-528
    80004020:	20113423          	sd	ra,520(sp)
    80004024:	20813023          	sd	s0,512(sp)
    80004028:	ffa6                	sd	s1,504(sp)
    8000402a:	fbca                	sd	s2,496(sp)
    8000402c:	f7ce                	sd	s3,488(sp)
    8000402e:	f3d2                	sd	s4,480(sp)
    80004030:	efd6                	sd	s5,472(sp)
    80004032:	ebda                	sd	s6,464(sp)
    80004034:	e7de                	sd	s7,456(sp)
    80004036:	e3e2                	sd	s8,448(sp)
    80004038:	ff66                	sd	s9,440(sp)
    8000403a:	fb6a                	sd	s10,432(sp)
    8000403c:	f76e                	sd	s11,424(sp)
    8000403e:	0c00                	addi	s0,sp,528
    80004040:	84aa                	mv	s1,a0
    80004042:	dea43c23          	sd	a0,-520(s0)
    80004046:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000404a:	ffffd097          	auipc	ra,0xffffd
    8000404e:	e56080e7          	jalr	-426(ra) # 80000ea0 <myproc>
    80004052:	892a                	mv	s2,a0

  begin_op();
    80004054:	fffff097          	auipc	ra,0xfffff
    80004058:	46c080e7          	jalr	1132(ra) # 800034c0 <begin_op>

  if((ip = namei(path)) == 0){
    8000405c:	8526                	mv	a0,s1
    8000405e:	fffff097          	auipc	ra,0xfffff
    80004062:	246080e7          	jalr	582(ra) # 800032a4 <namei>
    80004066:	c92d                	beqz	a0,800040d8 <exec+0xbc>
    80004068:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000406a:	fffff097          	auipc	ra,0xfffff
    8000406e:	a84080e7          	jalr	-1404(ra) # 80002aee <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004072:	04000713          	li	a4,64
    80004076:	4681                	li	a3,0
    80004078:	e5040613          	addi	a2,s0,-432
    8000407c:	4581                	li	a1,0
    8000407e:	8526                	mv	a0,s1
    80004080:	fffff097          	auipc	ra,0xfffff
    80004084:	d22080e7          	jalr	-734(ra) # 80002da2 <readi>
    80004088:	04000793          	li	a5,64
    8000408c:	00f51a63          	bne	a0,a5,800040a0 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004090:	e5042703          	lw	a4,-432(s0)
    80004094:	464c47b7          	lui	a5,0x464c4
    80004098:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000409c:	04f70463          	beq	a4,a5,800040e4 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800040a0:	8526                	mv	a0,s1
    800040a2:	fffff097          	auipc	ra,0xfffff
    800040a6:	cae080e7          	jalr	-850(ra) # 80002d50 <iunlockput>
    end_op();
    800040aa:	fffff097          	auipc	ra,0xfffff
    800040ae:	496080e7          	jalr	1174(ra) # 80003540 <end_op>
  }
  return -1;
    800040b2:	557d                	li	a0,-1
}
    800040b4:	20813083          	ld	ra,520(sp)
    800040b8:	20013403          	ld	s0,512(sp)
    800040bc:	74fe                	ld	s1,504(sp)
    800040be:	795e                	ld	s2,496(sp)
    800040c0:	79be                	ld	s3,488(sp)
    800040c2:	7a1e                	ld	s4,480(sp)
    800040c4:	6afe                	ld	s5,472(sp)
    800040c6:	6b5e                	ld	s6,464(sp)
    800040c8:	6bbe                	ld	s7,456(sp)
    800040ca:	6c1e                	ld	s8,448(sp)
    800040cc:	7cfa                	ld	s9,440(sp)
    800040ce:	7d5a                	ld	s10,432(sp)
    800040d0:	7dba                	ld	s11,424(sp)
    800040d2:	21010113          	addi	sp,sp,528
    800040d6:	8082                	ret
    end_op();
    800040d8:	fffff097          	auipc	ra,0xfffff
    800040dc:	468080e7          	jalr	1128(ra) # 80003540 <end_op>
    return -1;
    800040e0:	557d                	li	a0,-1
    800040e2:	bfc9                	j	800040b4 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800040e4:	854a                	mv	a0,s2
    800040e6:	ffffd097          	auipc	ra,0xffffd
    800040ea:	e7e080e7          	jalr	-386(ra) # 80000f64 <proc_pagetable>
    800040ee:	8baa                	mv	s7,a0
    800040f0:	d945                	beqz	a0,800040a0 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040f2:	e7042983          	lw	s3,-400(s0)
    800040f6:	e8845783          	lhu	a5,-376(s0)
    800040fa:	c7ad                	beqz	a5,80004164 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040fc:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040fe:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004100:	6c85                	lui	s9,0x1
    80004102:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004106:	def43823          	sd	a5,-528(s0)
    8000410a:	a42d                	j	80004334 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000410c:	00005517          	auipc	a0,0x5
    80004110:	58c50513          	addi	a0,a0,1420 # 80009698 <syscalls+0x2c0>
    80004114:	00003097          	auipc	ra,0x3
    80004118:	ae0080e7          	jalr	-1312(ra) # 80006bf4 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000411c:	8756                	mv	a4,s5
    8000411e:	012d86bb          	addw	a3,s11,s2
    80004122:	4581                	li	a1,0
    80004124:	8526                	mv	a0,s1
    80004126:	fffff097          	auipc	ra,0xfffff
    8000412a:	c7c080e7          	jalr	-900(ra) # 80002da2 <readi>
    8000412e:	2501                	sext.w	a0,a0
    80004130:	1aaa9963          	bne	s5,a0,800042e2 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004134:	6785                	lui	a5,0x1
    80004136:	0127893b          	addw	s2,a5,s2
    8000413a:	77fd                	lui	a5,0xfffff
    8000413c:	01478a3b          	addw	s4,a5,s4
    80004140:	1f897163          	bgeu	s2,s8,80004322 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004144:	02091593          	slli	a1,s2,0x20
    80004148:	9181                	srli	a1,a1,0x20
    8000414a:	95ea                	add	a1,a1,s10
    8000414c:	855e                	mv	a0,s7
    8000414e:	ffffc097          	auipc	ra,0xffffc
    80004152:	3d0080e7          	jalr	976(ra) # 8000051e <walkaddr>
    80004156:	862a                	mv	a2,a0
    if(pa == 0)
    80004158:	d955                	beqz	a0,8000410c <exec+0xf0>
      n = PGSIZE;
    8000415a:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000415c:	fd9a70e3          	bgeu	s4,s9,8000411c <exec+0x100>
      n = sz - i;
    80004160:	8ad2                	mv	s5,s4
    80004162:	bf6d                	j	8000411c <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004164:	4901                	li	s2,0
  iunlockput(ip);
    80004166:	8526                	mv	a0,s1
    80004168:	fffff097          	auipc	ra,0xfffff
    8000416c:	be8080e7          	jalr	-1048(ra) # 80002d50 <iunlockput>
  end_op();
    80004170:	fffff097          	auipc	ra,0xfffff
    80004174:	3d0080e7          	jalr	976(ra) # 80003540 <end_op>
  p = myproc();
    80004178:	ffffd097          	auipc	ra,0xffffd
    8000417c:	d28080e7          	jalr	-728(ra) # 80000ea0 <myproc>
    80004180:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004182:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004186:	6785                	lui	a5,0x1
    80004188:	17fd                	addi	a5,a5,-1
    8000418a:	993e                	add	s2,s2,a5
    8000418c:	757d                	lui	a0,0xfffff
    8000418e:	00a977b3          	and	a5,s2,a0
    80004192:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004196:	6609                	lui	a2,0x2
    80004198:	963e                	add	a2,a2,a5
    8000419a:	85be                	mv	a1,a5
    8000419c:	855e                	mv	a0,s7
    8000419e:	ffffc097          	auipc	ra,0xffffc
    800041a2:	778080e7          	jalr	1912(ra) # 80000916 <uvmalloc>
    800041a6:	8b2a                	mv	s6,a0
  ip = 0;
    800041a8:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800041aa:	12050c63          	beqz	a0,800042e2 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800041ae:	75f9                	lui	a1,0xffffe
    800041b0:	95aa                	add	a1,a1,a0
    800041b2:	855e                	mv	a0,s7
    800041b4:	ffffd097          	auipc	ra,0xffffd
    800041b8:	980080e7          	jalr	-1664(ra) # 80000b34 <uvmclear>
  stackbase = sp - PGSIZE;
    800041bc:	7c7d                	lui	s8,0xfffff
    800041be:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800041c0:	e0043783          	ld	a5,-512(s0)
    800041c4:	6388                	ld	a0,0(a5)
    800041c6:	c535                	beqz	a0,80004232 <exec+0x216>
    800041c8:	e9040993          	addi	s3,s0,-368
    800041cc:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800041d0:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800041d2:	ffffc097          	auipc	ra,0xffffc
    800041d6:	12a080e7          	jalr	298(ra) # 800002fc <strlen>
    800041da:	2505                	addiw	a0,a0,1
    800041dc:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800041e0:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800041e4:	13896363          	bltu	s2,s8,8000430a <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800041e8:	e0043d83          	ld	s11,-512(s0)
    800041ec:	000dba03          	ld	s4,0(s11)
    800041f0:	8552                	mv	a0,s4
    800041f2:	ffffc097          	auipc	ra,0xffffc
    800041f6:	10a080e7          	jalr	266(ra) # 800002fc <strlen>
    800041fa:	0015069b          	addiw	a3,a0,1
    800041fe:	8652                	mv	a2,s4
    80004200:	85ca                	mv	a1,s2
    80004202:	855e                	mv	a0,s7
    80004204:	ffffd097          	auipc	ra,0xffffd
    80004208:	962080e7          	jalr	-1694(ra) # 80000b66 <copyout>
    8000420c:	10054363          	bltz	a0,80004312 <exec+0x2f6>
    ustack[argc] = sp;
    80004210:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004214:	0485                	addi	s1,s1,1
    80004216:	008d8793          	addi	a5,s11,8
    8000421a:	e0f43023          	sd	a5,-512(s0)
    8000421e:	008db503          	ld	a0,8(s11)
    80004222:	c911                	beqz	a0,80004236 <exec+0x21a>
    if(argc >= MAXARG)
    80004224:	09a1                	addi	s3,s3,8
    80004226:	fb3c96e3          	bne	s9,s3,800041d2 <exec+0x1b6>
  sz = sz1;
    8000422a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000422e:	4481                	li	s1,0
    80004230:	a84d                	j	800042e2 <exec+0x2c6>
  sp = sz;
    80004232:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004234:	4481                	li	s1,0
  ustack[argc] = 0;
    80004236:	00349793          	slli	a5,s1,0x3
    8000423a:	f9040713          	addi	a4,s0,-112
    8000423e:	97ba                	add	a5,a5,a4
    80004240:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004244:	00148693          	addi	a3,s1,1
    80004248:	068e                	slli	a3,a3,0x3
    8000424a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000424e:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004252:	01897663          	bgeu	s2,s8,8000425e <exec+0x242>
  sz = sz1;
    80004256:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000425a:	4481                	li	s1,0
    8000425c:	a059                	j	800042e2 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000425e:	e9040613          	addi	a2,s0,-368
    80004262:	85ca                	mv	a1,s2
    80004264:	855e                	mv	a0,s7
    80004266:	ffffd097          	auipc	ra,0xffffd
    8000426a:	900080e7          	jalr	-1792(ra) # 80000b66 <copyout>
    8000426e:	0a054663          	bltz	a0,8000431a <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004272:	058ab783          	ld	a5,88(s5)
    80004276:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000427a:	df843783          	ld	a5,-520(s0)
    8000427e:	0007c703          	lbu	a4,0(a5)
    80004282:	cf11                	beqz	a4,8000429e <exec+0x282>
    80004284:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004286:	02f00693          	li	a3,47
    8000428a:	a039                	j	80004298 <exec+0x27c>
      last = s+1;
    8000428c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004290:	0785                	addi	a5,a5,1
    80004292:	fff7c703          	lbu	a4,-1(a5)
    80004296:	c701                	beqz	a4,8000429e <exec+0x282>
    if(*s == '/')
    80004298:	fed71ce3          	bne	a4,a3,80004290 <exec+0x274>
    8000429c:	bfc5                	j	8000428c <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    8000429e:	4641                	li	a2,16
    800042a0:	df843583          	ld	a1,-520(s0)
    800042a4:	158a8513          	addi	a0,s5,344
    800042a8:	ffffc097          	auipc	ra,0xffffc
    800042ac:	022080e7          	jalr	34(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800042b0:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800042b4:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800042b8:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800042bc:	058ab783          	ld	a5,88(s5)
    800042c0:	e6843703          	ld	a4,-408(s0)
    800042c4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800042c6:	058ab783          	ld	a5,88(s5)
    800042ca:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800042ce:	85ea                	mv	a1,s10
    800042d0:	ffffd097          	auipc	ra,0xffffd
    800042d4:	d30080e7          	jalr	-720(ra) # 80001000 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800042d8:	0004851b          	sext.w	a0,s1
    800042dc:	bbe1                	j	800040b4 <exec+0x98>
    800042de:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800042e2:	e0843583          	ld	a1,-504(s0)
    800042e6:	855e                	mv	a0,s7
    800042e8:	ffffd097          	auipc	ra,0xffffd
    800042ec:	d18080e7          	jalr	-744(ra) # 80001000 <proc_freepagetable>
  if(ip){
    800042f0:	da0498e3          	bnez	s1,800040a0 <exec+0x84>
  return -1;
    800042f4:	557d                	li	a0,-1
    800042f6:	bb7d                	j	800040b4 <exec+0x98>
    800042f8:	e1243423          	sd	s2,-504(s0)
    800042fc:	b7dd                	j	800042e2 <exec+0x2c6>
    800042fe:	e1243423          	sd	s2,-504(s0)
    80004302:	b7c5                	j	800042e2 <exec+0x2c6>
    80004304:	e1243423          	sd	s2,-504(s0)
    80004308:	bfe9                	j	800042e2 <exec+0x2c6>
  sz = sz1;
    8000430a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000430e:	4481                	li	s1,0
    80004310:	bfc9                	j	800042e2 <exec+0x2c6>
  sz = sz1;
    80004312:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004316:	4481                	li	s1,0
    80004318:	b7e9                	j	800042e2 <exec+0x2c6>
  sz = sz1;
    8000431a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000431e:	4481                	li	s1,0
    80004320:	b7c9                	j	800042e2 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004322:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004326:	2b05                	addiw	s6,s6,1
    80004328:	0389899b          	addiw	s3,s3,56
    8000432c:	e8845783          	lhu	a5,-376(s0)
    80004330:	e2fb5be3          	bge	s6,a5,80004166 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004334:	2981                	sext.w	s3,s3
    80004336:	03800713          	li	a4,56
    8000433a:	86ce                	mv	a3,s3
    8000433c:	e1840613          	addi	a2,s0,-488
    80004340:	4581                	li	a1,0
    80004342:	8526                	mv	a0,s1
    80004344:	fffff097          	auipc	ra,0xfffff
    80004348:	a5e080e7          	jalr	-1442(ra) # 80002da2 <readi>
    8000434c:	03800793          	li	a5,56
    80004350:	f8f517e3          	bne	a0,a5,800042de <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004354:	e1842783          	lw	a5,-488(s0)
    80004358:	4705                	li	a4,1
    8000435a:	fce796e3          	bne	a5,a4,80004326 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    8000435e:	e4043603          	ld	a2,-448(s0)
    80004362:	e3843783          	ld	a5,-456(s0)
    80004366:	f8f669e3          	bltu	a2,a5,800042f8 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000436a:	e2843783          	ld	a5,-472(s0)
    8000436e:	963e                	add	a2,a2,a5
    80004370:	f8f667e3          	bltu	a2,a5,800042fe <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004374:	85ca                	mv	a1,s2
    80004376:	855e                	mv	a0,s7
    80004378:	ffffc097          	auipc	ra,0xffffc
    8000437c:	59e080e7          	jalr	1438(ra) # 80000916 <uvmalloc>
    80004380:	e0a43423          	sd	a0,-504(s0)
    80004384:	d141                	beqz	a0,80004304 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004386:	e2843d03          	ld	s10,-472(s0)
    8000438a:	df043783          	ld	a5,-528(s0)
    8000438e:	00fd77b3          	and	a5,s10,a5
    80004392:	fba1                	bnez	a5,800042e2 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004394:	e2042d83          	lw	s11,-480(s0)
    80004398:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000439c:	f80c03e3          	beqz	s8,80004322 <exec+0x306>
    800043a0:	8a62                	mv	s4,s8
    800043a2:	4901                	li	s2,0
    800043a4:	b345                	j	80004144 <exec+0x128>

00000000800043a6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800043a6:	7179                	addi	sp,sp,-48
    800043a8:	f406                	sd	ra,40(sp)
    800043aa:	f022                	sd	s0,32(sp)
    800043ac:	ec26                	sd	s1,24(sp)
    800043ae:	e84a                	sd	s2,16(sp)
    800043b0:	1800                	addi	s0,sp,48
    800043b2:	892e                	mv	s2,a1
    800043b4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800043b6:	fdc40593          	addi	a1,s0,-36
    800043ba:	ffffe097          	auipc	ra,0xffffe
    800043be:	bc2080e7          	jalr	-1086(ra) # 80001f7c <argint>
    800043c2:	04054063          	bltz	a0,80004402 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800043c6:	fdc42703          	lw	a4,-36(s0)
    800043ca:	47bd                	li	a5,15
    800043cc:	02e7ed63          	bltu	a5,a4,80004406 <argfd+0x60>
    800043d0:	ffffd097          	auipc	ra,0xffffd
    800043d4:	ad0080e7          	jalr	-1328(ra) # 80000ea0 <myproc>
    800043d8:	fdc42703          	lw	a4,-36(s0)
    800043dc:	01a70793          	addi	a5,a4,26
    800043e0:	078e                	slli	a5,a5,0x3
    800043e2:	953e                	add	a0,a0,a5
    800043e4:	611c                	ld	a5,0(a0)
    800043e6:	c395                	beqz	a5,8000440a <argfd+0x64>
    return -1;
  if(pfd)
    800043e8:	00090463          	beqz	s2,800043f0 <argfd+0x4a>
    *pfd = fd;
    800043ec:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800043f0:	4501                	li	a0,0
  if(pf)
    800043f2:	c091                	beqz	s1,800043f6 <argfd+0x50>
    *pf = f;
    800043f4:	e09c                	sd	a5,0(s1)
}
    800043f6:	70a2                	ld	ra,40(sp)
    800043f8:	7402                	ld	s0,32(sp)
    800043fa:	64e2                	ld	s1,24(sp)
    800043fc:	6942                	ld	s2,16(sp)
    800043fe:	6145                	addi	sp,sp,48
    80004400:	8082                	ret
    return -1;
    80004402:	557d                	li	a0,-1
    80004404:	bfcd                	j	800043f6 <argfd+0x50>
    return -1;
    80004406:	557d                	li	a0,-1
    80004408:	b7fd                	j	800043f6 <argfd+0x50>
    8000440a:	557d                	li	a0,-1
    8000440c:	b7ed                	j	800043f6 <argfd+0x50>

000000008000440e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000440e:	1101                	addi	sp,sp,-32
    80004410:	ec06                	sd	ra,24(sp)
    80004412:	e822                	sd	s0,16(sp)
    80004414:	e426                	sd	s1,8(sp)
    80004416:	1000                	addi	s0,sp,32
    80004418:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000441a:	ffffd097          	auipc	ra,0xffffd
    8000441e:	a86080e7          	jalr	-1402(ra) # 80000ea0 <myproc>
    80004422:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004424:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd7b40>
    80004428:	4501                	li	a0,0
    8000442a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000442c:	6398                	ld	a4,0(a5)
    8000442e:	cb19                	beqz	a4,80004444 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004430:	2505                	addiw	a0,a0,1
    80004432:	07a1                	addi	a5,a5,8
    80004434:	fed51ce3          	bne	a0,a3,8000442c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004438:	557d                	li	a0,-1
}
    8000443a:	60e2                	ld	ra,24(sp)
    8000443c:	6442                	ld	s0,16(sp)
    8000443e:	64a2                	ld	s1,8(sp)
    80004440:	6105                	addi	sp,sp,32
    80004442:	8082                	ret
      p->ofile[fd] = f;
    80004444:	01a50793          	addi	a5,a0,26
    80004448:	078e                	slli	a5,a5,0x3
    8000444a:	963e                	add	a2,a2,a5
    8000444c:	e204                	sd	s1,0(a2)
      return fd;
    8000444e:	b7f5                	j	8000443a <fdalloc+0x2c>

0000000080004450 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004450:	715d                	addi	sp,sp,-80
    80004452:	e486                	sd	ra,72(sp)
    80004454:	e0a2                	sd	s0,64(sp)
    80004456:	fc26                	sd	s1,56(sp)
    80004458:	f84a                	sd	s2,48(sp)
    8000445a:	f44e                	sd	s3,40(sp)
    8000445c:	f052                	sd	s4,32(sp)
    8000445e:	ec56                	sd	s5,24(sp)
    80004460:	0880                	addi	s0,sp,80
    80004462:	89ae                	mv	s3,a1
    80004464:	8ab2                	mv	s5,a2
    80004466:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004468:	fb040593          	addi	a1,s0,-80
    8000446c:	fffff097          	auipc	ra,0xfffff
    80004470:	e56080e7          	jalr	-426(ra) # 800032c2 <nameiparent>
    80004474:	892a                	mv	s2,a0
    80004476:	12050f63          	beqz	a0,800045b4 <create+0x164>
    return 0;

  ilock(dp);
    8000447a:	ffffe097          	auipc	ra,0xffffe
    8000447e:	674080e7          	jalr	1652(ra) # 80002aee <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004482:	4601                	li	a2,0
    80004484:	fb040593          	addi	a1,s0,-80
    80004488:	854a                	mv	a0,s2
    8000448a:	fffff097          	auipc	ra,0xfffff
    8000448e:	b48080e7          	jalr	-1208(ra) # 80002fd2 <dirlookup>
    80004492:	84aa                	mv	s1,a0
    80004494:	c921                	beqz	a0,800044e4 <create+0x94>
    iunlockput(dp);
    80004496:	854a                	mv	a0,s2
    80004498:	fffff097          	auipc	ra,0xfffff
    8000449c:	8b8080e7          	jalr	-1864(ra) # 80002d50 <iunlockput>
    ilock(ip);
    800044a0:	8526                	mv	a0,s1
    800044a2:	ffffe097          	auipc	ra,0xffffe
    800044a6:	64c080e7          	jalr	1612(ra) # 80002aee <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800044aa:	2981                	sext.w	s3,s3
    800044ac:	4789                	li	a5,2
    800044ae:	02f99463          	bne	s3,a5,800044d6 <create+0x86>
    800044b2:	0444d783          	lhu	a5,68(s1)
    800044b6:	37f9                	addiw	a5,a5,-2
    800044b8:	17c2                	slli	a5,a5,0x30
    800044ba:	93c1                	srli	a5,a5,0x30
    800044bc:	4705                	li	a4,1
    800044be:	00f76c63          	bltu	a4,a5,800044d6 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800044c2:	8526                	mv	a0,s1
    800044c4:	60a6                	ld	ra,72(sp)
    800044c6:	6406                	ld	s0,64(sp)
    800044c8:	74e2                	ld	s1,56(sp)
    800044ca:	7942                	ld	s2,48(sp)
    800044cc:	79a2                	ld	s3,40(sp)
    800044ce:	7a02                	ld	s4,32(sp)
    800044d0:	6ae2                	ld	s5,24(sp)
    800044d2:	6161                	addi	sp,sp,80
    800044d4:	8082                	ret
    iunlockput(ip);
    800044d6:	8526                	mv	a0,s1
    800044d8:	fffff097          	auipc	ra,0xfffff
    800044dc:	878080e7          	jalr	-1928(ra) # 80002d50 <iunlockput>
    return 0;
    800044e0:	4481                	li	s1,0
    800044e2:	b7c5                	j	800044c2 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800044e4:	85ce                	mv	a1,s3
    800044e6:	00092503          	lw	a0,0(s2)
    800044ea:	ffffe097          	auipc	ra,0xffffe
    800044ee:	46c080e7          	jalr	1132(ra) # 80002956 <ialloc>
    800044f2:	84aa                	mv	s1,a0
    800044f4:	c529                	beqz	a0,8000453e <create+0xee>
  ilock(ip);
    800044f6:	ffffe097          	auipc	ra,0xffffe
    800044fa:	5f8080e7          	jalr	1528(ra) # 80002aee <ilock>
  ip->major = major;
    800044fe:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004502:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004506:	4785                	li	a5,1
    80004508:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000450c:	8526                	mv	a0,s1
    8000450e:	ffffe097          	auipc	ra,0xffffe
    80004512:	516080e7          	jalr	1302(ra) # 80002a24 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004516:	2981                	sext.w	s3,s3
    80004518:	4785                	li	a5,1
    8000451a:	02f98a63          	beq	s3,a5,8000454e <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    8000451e:	40d0                	lw	a2,4(s1)
    80004520:	fb040593          	addi	a1,s0,-80
    80004524:	854a                	mv	a0,s2
    80004526:	fffff097          	auipc	ra,0xfffff
    8000452a:	cbc080e7          	jalr	-836(ra) # 800031e2 <dirlink>
    8000452e:	06054b63          	bltz	a0,800045a4 <create+0x154>
  iunlockput(dp);
    80004532:	854a                	mv	a0,s2
    80004534:	fffff097          	auipc	ra,0xfffff
    80004538:	81c080e7          	jalr	-2020(ra) # 80002d50 <iunlockput>
  return ip;
    8000453c:	b759                	j	800044c2 <create+0x72>
    panic("create: ialloc");
    8000453e:	00005517          	auipc	a0,0x5
    80004542:	17a50513          	addi	a0,a0,378 # 800096b8 <syscalls+0x2e0>
    80004546:	00002097          	auipc	ra,0x2
    8000454a:	6ae080e7          	jalr	1710(ra) # 80006bf4 <panic>
    dp->nlink++;  // for ".."
    8000454e:	04a95783          	lhu	a5,74(s2)
    80004552:	2785                	addiw	a5,a5,1
    80004554:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004558:	854a                	mv	a0,s2
    8000455a:	ffffe097          	auipc	ra,0xffffe
    8000455e:	4ca080e7          	jalr	1226(ra) # 80002a24 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004562:	40d0                	lw	a2,4(s1)
    80004564:	00005597          	auipc	a1,0x5
    80004568:	16458593          	addi	a1,a1,356 # 800096c8 <syscalls+0x2f0>
    8000456c:	8526                	mv	a0,s1
    8000456e:	fffff097          	auipc	ra,0xfffff
    80004572:	c74080e7          	jalr	-908(ra) # 800031e2 <dirlink>
    80004576:	00054f63          	bltz	a0,80004594 <create+0x144>
    8000457a:	00492603          	lw	a2,4(s2)
    8000457e:	00005597          	auipc	a1,0x5
    80004582:	15258593          	addi	a1,a1,338 # 800096d0 <syscalls+0x2f8>
    80004586:	8526                	mv	a0,s1
    80004588:	fffff097          	auipc	ra,0xfffff
    8000458c:	c5a080e7          	jalr	-934(ra) # 800031e2 <dirlink>
    80004590:	f80557e3          	bgez	a0,8000451e <create+0xce>
      panic("create dots");
    80004594:	00005517          	auipc	a0,0x5
    80004598:	14450513          	addi	a0,a0,324 # 800096d8 <syscalls+0x300>
    8000459c:	00002097          	auipc	ra,0x2
    800045a0:	658080e7          	jalr	1624(ra) # 80006bf4 <panic>
    panic("create: dirlink");
    800045a4:	00005517          	auipc	a0,0x5
    800045a8:	14450513          	addi	a0,a0,324 # 800096e8 <syscalls+0x310>
    800045ac:	00002097          	auipc	ra,0x2
    800045b0:	648080e7          	jalr	1608(ra) # 80006bf4 <panic>
    return 0;
    800045b4:	84aa                	mv	s1,a0
    800045b6:	b731                	j	800044c2 <create+0x72>

00000000800045b8 <sys_dup>:
{
    800045b8:	7179                	addi	sp,sp,-48
    800045ba:	f406                	sd	ra,40(sp)
    800045bc:	f022                	sd	s0,32(sp)
    800045be:	ec26                	sd	s1,24(sp)
    800045c0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045c2:	fd840613          	addi	a2,s0,-40
    800045c6:	4581                	li	a1,0
    800045c8:	4501                	li	a0,0
    800045ca:	00000097          	auipc	ra,0x0
    800045ce:	ddc080e7          	jalr	-548(ra) # 800043a6 <argfd>
    return -1;
    800045d2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800045d4:	02054363          	bltz	a0,800045fa <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800045d8:	fd843503          	ld	a0,-40(s0)
    800045dc:	00000097          	auipc	ra,0x0
    800045e0:	e32080e7          	jalr	-462(ra) # 8000440e <fdalloc>
    800045e4:	84aa                	mv	s1,a0
    return -1;
    800045e6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800045e8:	00054963          	bltz	a0,800045fa <sys_dup+0x42>
  filedup(f);
    800045ec:	fd843503          	ld	a0,-40(s0)
    800045f0:	fffff097          	auipc	ra,0xfffff
    800045f4:	34a080e7          	jalr	842(ra) # 8000393a <filedup>
  return fd;
    800045f8:	87a6                	mv	a5,s1
}
    800045fa:	853e                	mv	a0,a5
    800045fc:	70a2                	ld	ra,40(sp)
    800045fe:	7402                	ld	s0,32(sp)
    80004600:	64e2                	ld	s1,24(sp)
    80004602:	6145                	addi	sp,sp,48
    80004604:	8082                	ret

0000000080004606 <sys_read>:
{
    80004606:	7179                	addi	sp,sp,-48
    80004608:	f406                	sd	ra,40(sp)
    8000460a:	f022                	sd	s0,32(sp)
    8000460c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000460e:	fe840613          	addi	a2,s0,-24
    80004612:	4581                	li	a1,0
    80004614:	4501                	li	a0,0
    80004616:	00000097          	auipc	ra,0x0
    8000461a:	d90080e7          	jalr	-624(ra) # 800043a6 <argfd>
    return -1;
    8000461e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004620:	04054163          	bltz	a0,80004662 <sys_read+0x5c>
    80004624:	fe440593          	addi	a1,s0,-28
    80004628:	4509                	li	a0,2
    8000462a:	ffffe097          	auipc	ra,0xffffe
    8000462e:	952080e7          	jalr	-1710(ra) # 80001f7c <argint>
    return -1;
    80004632:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004634:	02054763          	bltz	a0,80004662 <sys_read+0x5c>
    80004638:	fd840593          	addi	a1,s0,-40
    8000463c:	4505                	li	a0,1
    8000463e:	ffffe097          	auipc	ra,0xffffe
    80004642:	960080e7          	jalr	-1696(ra) # 80001f9e <argaddr>
    return -1;
    80004646:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004648:	00054d63          	bltz	a0,80004662 <sys_read+0x5c>
  return fileread(f, p, n);
    8000464c:	fe442603          	lw	a2,-28(s0)
    80004650:	fd843583          	ld	a1,-40(s0)
    80004654:	fe843503          	ld	a0,-24(s0)
    80004658:	fffff097          	auipc	ra,0xfffff
    8000465c:	48a080e7          	jalr	1162(ra) # 80003ae2 <fileread>
    80004660:	87aa                	mv	a5,a0
}
    80004662:	853e                	mv	a0,a5
    80004664:	70a2                	ld	ra,40(sp)
    80004666:	7402                	ld	s0,32(sp)
    80004668:	6145                	addi	sp,sp,48
    8000466a:	8082                	ret

000000008000466c <sys_write>:
{
    8000466c:	7179                	addi	sp,sp,-48
    8000466e:	f406                	sd	ra,40(sp)
    80004670:	f022                	sd	s0,32(sp)
    80004672:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004674:	fe840613          	addi	a2,s0,-24
    80004678:	4581                	li	a1,0
    8000467a:	4501                	li	a0,0
    8000467c:	00000097          	auipc	ra,0x0
    80004680:	d2a080e7          	jalr	-726(ra) # 800043a6 <argfd>
    return -1;
    80004684:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004686:	04054163          	bltz	a0,800046c8 <sys_write+0x5c>
    8000468a:	fe440593          	addi	a1,s0,-28
    8000468e:	4509                	li	a0,2
    80004690:	ffffe097          	auipc	ra,0xffffe
    80004694:	8ec080e7          	jalr	-1812(ra) # 80001f7c <argint>
    return -1;
    80004698:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000469a:	02054763          	bltz	a0,800046c8 <sys_write+0x5c>
    8000469e:	fd840593          	addi	a1,s0,-40
    800046a2:	4505                	li	a0,1
    800046a4:	ffffe097          	auipc	ra,0xffffe
    800046a8:	8fa080e7          	jalr	-1798(ra) # 80001f9e <argaddr>
    return -1;
    800046ac:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ae:	00054d63          	bltz	a0,800046c8 <sys_write+0x5c>
  return filewrite(f, p, n);
    800046b2:	fe442603          	lw	a2,-28(s0)
    800046b6:	fd843583          	ld	a1,-40(s0)
    800046ba:	fe843503          	ld	a0,-24(s0)
    800046be:	fffff097          	auipc	ra,0xfffff
    800046c2:	4fa080e7          	jalr	1274(ra) # 80003bb8 <filewrite>
    800046c6:	87aa                	mv	a5,a0
}
    800046c8:	853e                	mv	a0,a5
    800046ca:	70a2                	ld	ra,40(sp)
    800046cc:	7402                	ld	s0,32(sp)
    800046ce:	6145                	addi	sp,sp,48
    800046d0:	8082                	ret

00000000800046d2 <sys_close>:
{
    800046d2:	1101                	addi	sp,sp,-32
    800046d4:	ec06                	sd	ra,24(sp)
    800046d6:	e822                	sd	s0,16(sp)
    800046d8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800046da:	fe040613          	addi	a2,s0,-32
    800046de:	fec40593          	addi	a1,s0,-20
    800046e2:	4501                	li	a0,0
    800046e4:	00000097          	auipc	ra,0x0
    800046e8:	cc2080e7          	jalr	-830(ra) # 800043a6 <argfd>
    return -1;
    800046ec:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800046ee:	02054463          	bltz	a0,80004716 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800046f2:	ffffc097          	auipc	ra,0xffffc
    800046f6:	7ae080e7          	jalr	1966(ra) # 80000ea0 <myproc>
    800046fa:	fec42783          	lw	a5,-20(s0)
    800046fe:	07e9                	addi	a5,a5,26
    80004700:	078e                	slli	a5,a5,0x3
    80004702:	97aa                	add	a5,a5,a0
    80004704:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004708:	fe043503          	ld	a0,-32(s0)
    8000470c:	fffff097          	auipc	ra,0xfffff
    80004710:	280080e7          	jalr	640(ra) # 8000398c <fileclose>
  return 0;
    80004714:	4781                	li	a5,0
}
    80004716:	853e                	mv	a0,a5
    80004718:	60e2                	ld	ra,24(sp)
    8000471a:	6442                	ld	s0,16(sp)
    8000471c:	6105                	addi	sp,sp,32
    8000471e:	8082                	ret

0000000080004720 <sys_fstat>:
{
    80004720:	1101                	addi	sp,sp,-32
    80004722:	ec06                	sd	ra,24(sp)
    80004724:	e822                	sd	s0,16(sp)
    80004726:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004728:	fe840613          	addi	a2,s0,-24
    8000472c:	4581                	li	a1,0
    8000472e:	4501                	li	a0,0
    80004730:	00000097          	auipc	ra,0x0
    80004734:	c76080e7          	jalr	-906(ra) # 800043a6 <argfd>
    return -1;
    80004738:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000473a:	02054563          	bltz	a0,80004764 <sys_fstat+0x44>
    8000473e:	fe040593          	addi	a1,s0,-32
    80004742:	4505                	li	a0,1
    80004744:	ffffe097          	auipc	ra,0xffffe
    80004748:	85a080e7          	jalr	-1958(ra) # 80001f9e <argaddr>
    return -1;
    8000474c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000474e:	00054b63          	bltz	a0,80004764 <sys_fstat+0x44>
  return filestat(f, st);
    80004752:	fe043583          	ld	a1,-32(s0)
    80004756:	fe843503          	ld	a0,-24(s0)
    8000475a:	fffff097          	auipc	ra,0xfffff
    8000475e:	316080e7          	jalr	790(ra) # 80003a70 <filestat>
    80004762:	87aa                	mv	a5,a0
}
    80004764:	853e                	mv	a0,a5
    80004766:	60e2                	ld	ra,24(sp)
    80004768:	6442                	ld	s0,16(sp)
    8000476a:	6105                	addi	sp,sp,32
    8000476c:	8082                	ret

000000008000476e <sys_link>:
{
    8000476e:	7169                	addi	sp,sp,-304
    80004770:	f606                	sd	ra,296(sp)
    80004772:	f222                	sd	s0,288(sp)
    80004774:	ee26                	sd	s1,280(sp)
    80004776:	ea4a                	sd	s2,272(sp)
    80004778:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000477a:	08000613          	li	a2,128
    8000477e:	ed040593          	addi	a1,s0,-304
    80004782:	4501                	li	a0,0
    80004784:	ffffe097          	auipc	ra,0xffffe
    80004788:	83c080e7          	jalr	-1988(ra) # 80001fc0 <argstr>
    return -1;
    8000478c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000478e:	10054e63          	bltz	a0,800048aa <sys_link+0x13c>
    80004792:	08000613          	li	a2,128
    80004796:	f5040593          	addi	a1,s0,-176
    8000479a:	4505                	li	a0,1
    8000479c:	ffffe097          	auipc	ra,0xffffe
    800047a0:	824080e7          	jalr	-2012(ra) # 80001fc0 <argstr>
    return -1;
    800047a4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047a6:	10054263          	bltz	a0,800048aa <sys_link+0x13c>
  begin_op();
    800047aa:	fffff097          	auipc	ra,0xfffff
    800047ae:	d16080e7          	jalr	-746(ra) # 800034c0 <begin_op>
  if((ip = namei(old)) == 0){
    800047b2:	ed040513          	addi	a0,s0,-304
    800047b6:	fffff097          	auipc	ra,0xfffff
    800047ba:	aee080e7          	jalr	-1298(ra) # 800032a4 <namei>
    800047be:	84aa                	mv	s1,a0
    800047c0:	c551                	beqz	a0,8000484c <sys_link+0xde>
  ilock(ip);
    800047c2:	ffffe097          	auipc	ra,0xffffe
    800047c6:	32c080e7          	jalr	812(ra) # 80002aee <ilock>
  if(ip->type == T_DIR){
    800047ca:	04449703          	lh	a4,68(s1)
    800047ce:	4785                	li	a5,1
    800047d0:	08f70463          	beq	a4,a5,80004858 <sys_link+0xea>
  ip->nlink++;
    800047d4:	04a4d783          	lhu	a5,74(s1)
    800047d8:	2785                	addiw	a5,a5,1
    800047da:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047de:	8526                	mv	a0,s1
    800047e0:	ffffe097          	auipc	ra,0xffffe
    800047e4:	244080e7          	jalr	580(ra) # 80002a24 <iupdate>
  iunlock(ip);
    800047e8:	8526                	mv	a0,s1
    800047ea:	ffffe097          	auipc	ra,0xffffe
    800047ee:	3c6080e7          	jalr	966(ra) # 80002bb0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800047f2:	fd040593          	addi	a1,s0,-48
    800047f6:	f5040513          	addi	a0,s0,-176
    800047fa:	fffff097          	auipc	ra,0xfffff
    800047fe:	ac8080e7          	jalr	-1336(ra) # 800032c2 <nameiparent>
    80004802:	892a                	mv	s2,a0
    80004804:	c935                	beqz	a0,80004878 <sys_link+0x10a>
  ilock(dp);
    80004806:	ffffe097          	auipc	ra,0xffffe
    8000480a:	2e8080e7          	jalr	744(ra) # 80002aee <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000480e:	00092703          	lw	a4,0(s2)
    80004812:	409c                	lw	a5,0(s1)
    80004814:	04f71d63          	bne	a4,a5,8000486e <sys_link+0x100>
    80004818:	40d0                	lw	a2,4(s1)
    8000481a:	fd040593          	addi	a1,s0,-48
    8000481e:	854a                	mv	a0,s2
    80004820:	fffff097          	auipc	ra,0xfffff
    80004824:	9c2080e7          	jalr	-1598(ra) # 800031e2 <dirlink>
    80004828:	04054363          	bltz	a0,8000486e <sys_link+0x100>
  iunlockput(dp);
    8000482c:	854a                	mv	a0,s2
    8000482e:	ffffe097          	auipc	ra,0xffffe
    80004832:	522080e7          	jalr	1314(ra) # 80002d50 <iunlockput>
  iput(ip);
    80004836:	8526                	mv	a0,s1
    80004838:	ffffe097          	auipc	ra,0xffffe
    8000483c:	470080e7          	jalr	1136(ra) # 80002ca8 <iput>
  end_op();
    80004840:	fffff097          	auipc	ra,0xfffff
    80004844:	d00080e7          	jalr	-768(ra) # 80003540 <end_op>
  return 0;
    80004848:	4781                	li	a5,0
    8000484a:	a085                	j	800048aa <sys_link+0x13c>
    end_op();
    8000484c:	fffff097          	auipc	ra,0xfffff
    80004850:	cf4080e7          	jalr	-780(ra) # 80003540 <end_op>
    return -1;
    80004854:	57fd                	li	a5,-1
    80004856:	a891                	j	800048aa <sys_link+0x13c>
    iunlockput(ip);
    80004858:	8526                	mv	a0,s1
    8000485a:	ffffe097          	auipc	ra,0xffffe
    8000485e:	4f6080e7          	jalr	1270(ra) # 80002d50 <iunlockput>
    end_op();
    80004862:	fffff097          	auipc	ra,0xfffff
    80004866:	cde080e7          	jalr	-802(ra) # 80003540 <end_op>
    return -1;
    8000486a:	57fd                	li	a5,-1
    8000486c:	a83d                	j	800048aa <sys_link+0x13c>
    iunlockput(dp);
    8000486e:	854a                	mv	a0,s2
    80004870:	ffffe097          	auipc	ra,0xffffe
    80004874:	4e0080e7          	jalr	1248(ra) # 80002d50 <iunlockput>
  ilock(ip);
    80004878:	8526                	mv	a0,s1
    8000487a:	ffffe097          	auipc	ra,0xffffe
    8000487e:	274080e7          	jalr	628(ra) # 80002aee <ilock>
  ip->nlink--;
    80004882:	04a4d783          	lhu	a5,74(s1)
    80004886:	37fd                	addiw	a5,a5,-1
    80004888:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000488c:	8526                	mv	a0,s1
    8000488e:	ffffe097          	auipc	ra,0xffffe
    80004892:	196080e7          	jalr	406(ra) # 80002a24 <iupdate>
  iunlockput(ip);
    80004896:	8526                	mv	a0,s1
    80004898:	ffffe097          	auipc	ra,0xffffe
    8000489c:	4b8080e7          	jalr	1208(ra) # 80002d50 <iunlockput>
  end_op();
    800048a0:	fffff097          	auipc	ra,0xfffff
    800048a4:	ca0080e7          	jalr	-864(ra) # 80003540 <end_op>
  return -1;
    800048a8:	57fd                	li	a5,-1
}
    800048aa:	853e                	mv	a0,a5
    800048ac:	70b2                	ld	ra,296(sp)
    800048ae:	7412                	ld	s0,288(sp)
    800048b0:	64f2                	ld	s1,280(sp)
    800048b2:	6952                	ld	s2,272(sp)
    800048b4:	6155                	addi	sp,sp,304
    800048b6:	8082                	ret

00000000800048b8 <sys_unlink>:
{
    800048b8:	7151                	addi	sp,sp,-240
    800048ba:	f586                	sd	ra,232(sp)
    800048bc:	f1a2                	sd	s0,224(sp)
    800048be:	eda6                	sd	s1,216(sp)
    800048c0:	e9ca                	sd	s2,208(sp)
    800048c2:	e5ce                	sd	s3,200(sp)
    800048c4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048c6:	08000613          	li	a2,128
    800048ca:	f3040593          	addi	a1,s0,-208
    800048ce:	4501                	li	a0,0
    800048d0:	ffffd097          	auipc	ra,0xffffd
    800048d4:	6f0080e7          	jalr	1776(ra) # 80001fc0 <argstr>
    800048d8:	18054163          	bltz	a0,80004a5a <sys_unlink+0x1a2>
  begin_op();
    800048dc:	fffff097          	auipc	ra,0xfffff
    800048e0:	be4080e7          	jalr	-1052(ra) # 800034c0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800048e4:	fb040593          	addi	a1,s0,-80
    800048e8:	f3040513          	addi	a0,s0,-208
    800048ec:	fffff097          	auipc	ra,0xfffff
    800048f0:	9d6080e7          	jalr	-1578(ra) # 800032c2 <nameiparent>
    800048f4:	84aa                	mv	s1,a0
    800048f6:	c979                	beqz	a0,800049cc <sys_unlink+0x114>
  ilock(dp);
    800048f8:	ffffe097          	auipc	ra,0xffffe
    800048fc:	1f6080e7          	jalr	502(ra) # 80002aee <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004900:	00005597          	auipc	a1,0x5
    80004904:	dc858593          	addi	a1,a1,-568 # 800096c8 <syscalls+0x2f0>
    80004908:	fb040513          	addi	a0,s0,-80
    8000490c:	ffffe097          	auipc	ra,0xffffe
    80004910:	6ac080e7          	jalr	1708(ra) # 80002fb8 <namecmp>
    80004914:	14050a63          	beqz	a0,80004a68 <sys_unlink+0x1b0>
    80004918:	00005597          	auipc	a1,0x5
    8000491c:	db858593          	addi	a1,a1,-584 # 800096d0 <syscalls+0x2f8>
    80004920:	fb040513          	addi	a0,s0,-80
    80004924:	ffffe097          	auipc	ra,0xffffe
    80004928:	694080e7          	jalr	1684(ra) # 80002fb8 <namecmp>
    8000492c:	12050e63          	beqz	a0,80004a68 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004930:	f2c40613          	addi	a2,s0,-212
    80004934:	fb040593          	addi	a1,s0,-80
    80004938:	8526                	mv	a0,s1
    8000493a:	ffffe097          	auipc	ra,0xffffe
    8000493e:	698080e7          	jalr	1688(ra) # 80002fd2 <dirlookup>
    80004942:	892a                	mv	s2,a0
    80004944:	12050263          	beqz	a0,80004a68 <sys_unlink+0x1b0>
  ilock(ip);
    80004948:	ffffe097          	auipc	ra,0xffffe
    8000494c:	1a6080e7          	jalr	422(ra) # 80002aee <ilock>
  if(ip->nlink < 1)
    80004950:	04a91783          	lh	a5,74(s2)
    80004954:	08f05263          	blez	a5,800049d8 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004958:	04491703          	lh	a4,68(s2)
    8000495c:	4785                	li	a5,1
    8000495e:	08f70563          	beq	a4,a5,800049e8 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004962:	4641                	li	a2,16
    80004964:	4581                	li	a1,0
    80004966:	fc040513          	addi	a0,s0,-64
    8000496a:	ffffc097          	auipc	ra,0xffffc
    8000496e:	80e080e7          	jalr	-2034(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004972:	4741                	li	a4,16
    80004974:	f2c42683          	lw	a3,-212(s0)
    80004978:	fc040613          	addi	a2,s0,-64
    8000497c:	4581                	li	a1,0
    8000497e:	8526                	mv	a0,s1
    80004980:	ffffe097          	auipc	ra,0xffffe
    80004984:	51a080e7          	jalr	1306(ra) # 80002e9a <writei>
    80004988:	47c1                	li	a5,16
    8000498a:	0af51563          	bne	a0,a5,80004a34 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    8000498e:	04491703          	lh	a4,68(s2)
    80004992:	4785                	li	a5,1
    80004994:	0af70863          	beq	a4,a5,80004a44 <sys_unlink+0x18c>
  iunlockput(dp);
    80004998:	8526                	mv	a0,s1
    8000499a:	ffffe097          	auipc	ra,0xffffe
    8000499e:	3b6080e7          	jalr	950(ra) # 80002d50 <iunlockput>
  ip->nlink--;
    800049a2:	04a95783          	lhu	a5,74(s2)
    800049a6:	37fd                	addiw	a5,a5,-1
    800049a8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049ac:	854a                	mv	a0,s2
    800049ae:	ffffe097          	auipc	ra,0xffffe
    800049b2:	076080e7          	jalr	118(ra) # 80002a24 <iupdate>
  iunlockput(ip);
    800049b6:	854a                	mv	a0,s2
    800049b8:	ffffe097          	auipc	ra,0xffffe
    800049bc:	398080e7          	jalr	920(ra) # 80002d50 <iunlockput>
  end_op();
    800049c0:	fffff097          	auipc	ra,0xfffff
    800049c4:	b80080e7          	jalr	-1152(ra) # 80003540 <end_op>
  return 0;
    800049c8:	4501                	li	a0,0
    800049ca:	a84d                	j	80004a7c <sys_unlink+0x1c4>
    end_op();
    800049cc:	fffff097          	auipc	ra,0xfffff
    800049d0:	b74080e7          	jalr	-1164(ra) # 80003540 <end_op>
    return -1;
    800049d4:	557d                	li	a0,-1
    800049d6:	a05d                	j	80004a7c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800049d8:	00005517          	auipc	a0,0x5
    800049dc:	d2050513          	addi	a0,a0,-736 # 800096f8 <syscalls+0x320>
    800049e0:	00002097          	auipc	ra,0x2
    800049e4:	214080e7          	jalr	532(ra) # 80006bf4 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049e8:	04c92703          	lw	a4,76(s2)
    800049ec:	02000793          	li	a5,32
    800049f0:	f6e7f9e3          	bgeu	a5,a4,80004962 <sys_unlink+0xaa>
    800049f4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049f8:	4741                	li	a4,16
    800049fa:	86ce                	mv	a3,s3
    800049fc:	f1840613          	addi	a2,s0,-232
    80004a00:	4581                	li	a1,0
    80004a02:	854a                	mv	a0,s2
    80004a04:	ffffe097          	auipc	ra,0xffffe
    80004a08:	39e080e7          	jalr	926(ra) # 80002da2 <readi>
    80004a0c:	47c1                	li	a5,16
    80004a0e:	00f51b63          	bne	a0,a5,80004a24 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a12:	f1845783          	lhu	a5,-232(s0)
    80004a16:	e7a1                	bnez	a5,80004a5e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a18:	29c1                	addiw	s3,s3,16
    80004a1a:	04c92783          	lw	a5,76(s2)
    80004a1e:	fcf9ede3          	bltu	s3,a5,800049f8 <sys_unlink+0x140>
    80004a22:	b781                	j	80004962 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a24:	00005517          	auipc	a0,0x5
    80004a28:	cec50513          	addi	a0,a0,-788 # 80009710 <syscalls+0x338>
    80004a2c:	00002097          	auipc	ra,0x2
    80004a30:	1c8080e7          	jalr	456(ra) # 80006bf4 <panic>
    panic("unlink: writei");
    80004a34:	00005517          	auipc	a0,0x5
    80004a38:	cf450513          	addi	a0,a0,-780 # 80009728 <syscalls+0x350>
    80004a3c:	00002097          	auipc	ra,0x2
    80004a40:	1b8080e7          	jalr	440(ra) # 80006bf4 <panic>
    dp->nlink--;
    80004a44:	04a4d783          	lhu	a5,74(s1)
    80004a48:	37fd                	addiw	a5,a5,-1
    80004a4a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a4e:	8526                	mv	a0,s1
    80004a50:	ffffe097          	auipc	ra,0xffffe
    80004a54:	fd4080e7          	jalr	-44(ra) # 80002a24 <iupdate>
    80004a58:	b781                	j	80004998 <sys_unlink+0xe0>
    return -1;
    80004a5a:	557d                	li	a0,-1
    80004a5c:	a005                	j	80004a7c <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a5e:	854a                	mv	a0,s2
    80004a60:	ffffe097          	auipc	ra,0xffffe
    80004a64:	2f0080e7          	jalr	752(ra) # 80002d50 <iunlockput>
  iunlockput(dp);
    80004a68:	8526                	mv	a0,s1
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	2e6080e7          	jalr	742(ra) # 80002d50 <iunlockput>
  end_op();
    80004a72:	fffff097          	auipc	ra,0xfffff
    80004a76:	ace080e7          	jalr	-1330(ra) # 80003540 <end_op>
  return -1;
    80004a7a:	557d                	li	a0,-1
}
    80004a7c:	70ae                	ld	ra,232(sp)
    80004a7e:	740e                	ld	s0,224(sp)
    80004a80:	64ee                	ld	s1,216(sp)
    80004a82:	694e                	ld	s2,208(sp)
    80004a84:	69ae                	ld	s3,200(sp)
    80004a86:	616d                	addi	sp,sp,240
    80004a88:	8082                	ret

0000000080004a8a <sys_open>:

uint64
sys_open(void)
{
    80004a8a:	7131                	addi	sp,sp,-192
    80004a8c:	fd06                	sd	ra,184(sp)
    80004a8e:	f922                	sd	s0,176(sp)
    80004a90:	f526                	sd	s1,168(sp)
    80004a92:	f14a                	sd	s2,160(sp)
    80004a94:	ed4e                	sd	s3,152(sp)
    80004a96:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004a98:	08000613          	li	a2,128
    80004a9c:	f5040593          	addi	a1,s0,-176
    80004aa0:	4501                	li	a0,0
    80004aa2:	ffffd097          	auipc	ra,0xffffd
    80004aa6:	51e080e7          	jalr	1310(ra) # 80001fc0 <argstr>
    return -1;
    80004aaa:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004aac:	0c054163          	bltz	a0,80004b6e <sys_open+0xe4>
    80004ab0:	f4c40593          	addi	a1,s0,-180
    80004ab4:	4505                	li	a0,1
    80004ab6:	ffffd097          	auipc	ra,0xffffd
    80004aba:	4c6080e7          	jalr	1222(ra) # 80001f7c <argint>
    80004abe:	0a054863          	bltz	a0,80004b6e <sys_open+0xe4>

  begin_op();
    80004ac2:	fffff097          	auipc	ra,0xfffff
    80004ac6:	9fe080e7          	jalr	-1538(ra) # 800034c0 <begin_op>

  if(omode & O_CREATE){
    80004aca:	f4c42783          	lw	a5,-180(s0)
    80004ace:	2007f793          	andi	a5,a5,512
    80004ad2:	cbdd                	beqz	a5,80004b88 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ad4:	4681                	li	a3,0
    80004ad6:	4601                	li	a2,0
    80004ad8:	4589                	li	a1,2
    80004ada:	f5040513          	addi	a0,s0,-176
    80004ade:	00000097          	auipc	ra,0x0
    80004ae2:	972080e7          	jalr	-1678(ra) # 80004450 <create>
    80004ae6:	892a                	mv	s2,a0
    if(ip == 0){
    80004ae8:	c959                	beqz	a0,80004b7e <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004aea:	04491703          	lh	a4,68(s2)
    80004aee:	478d                	li	a5,3
    80004af0:	00f71763          	bne	a4,a5,80004afe <sys_open+0x74>
    80004af4:	04695703          	lhu	a4,70(s2)
    80004af8:	47a5                	li	a5,9
    80004afa:	0ce7ec63          	bltu	a5,a4,80004bd2 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004afe:	fffff097          	auipc	ra,0xfffff
    80004b02:	dd2080e7          	jalr	-558(ra) # 800038d0 <filealloc>
    80004b06:	89aa                	mv	s3,a0
    80004b08:	10050263          	beqz	a0,80004c0c <sys_open+0x182>
    80004b0c:	00000097          	auipc	ra,0x0
    80004b10:	902080e7          	jalr	-1790(ra) # 8000440e <fdalloc>
    80004b14:	84aa                	mv	s1,a0
    80004b16:	0e054663          	bltz	a0,80004c02 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b1a:	04491703          	lh	a4,68(s2)
    80004b1e:	478d                	li	a5,3
    80004b20:	0cf70463          	beq	a4,a5,80004be8 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b24:	4789                	li	a5,2
    80004b26:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b2a:	0209a423          	sw	zero,40(s3)
  }
  f->ip = ip;
    80004b2e:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b32:	f4c42783          	lw	a5,-180(s0)
    80004b36:	0017c713          	xori	a4,a5,1
    80004b3a:	8b05                	andi	a4,a4,1
    80004b3c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b40:	0037f713          	andi	a4,a5,3
    80004b44:	00e03733          	snez	a4,a4
    80004b48:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b4c:	4007f793          	andi	a5,a5,1024
    80004b50:	c791                	beqz	a5,80004b5c <sys_open+0xd2>
    80004b52:	04491703          	lh	a4,68(s2)
    80004b56:	4789                	li	a5,2
    80004b58:	08f70f63          	beq	a4,a5,80004bf6 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004b5c:	854a                	mv	a0,s2
    80004b5e:	ffffe097          	auipc	ra,0xffffe
    80004b62:	052080e7          	jalr	82(ra) # 80002bb0 <iunlock>
  end_op();
    80004b66:	fffff097          	auipc	ra,0xfffff
    80004b6a:	9da080e7          	jalr	-1574(ra) # 80003540 <end_op>

  return fd;
}
    80004b6e:	8526                	mv	a0,s1
    80004b70:	70ea                	ld	ra,184(sp)
    80004b72:	744a                	ld	s0,176(sp)
    80004b74:	74aa                	ld	s1,168(sp)
    80004b76:	790a                	ld	s2,160(sp)
    80004b78:	69ea                	ld	s3,152(sp)
    80004b7a:	6129                	addi	sp,sp,192
    80004b7c:	8082                	ret
      end_op();
    80004b7e:	fffff097          	auipc	ra,0xfffff
    80004b82:	9c2080e7          	jalr	-1598(ra) # 80003540 <end_op>
      return -1;
    80004b86:	b7e5                	j	80004b6e <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004b88:	f5040513          	addi	a0,s0,-176
    80004b8c:	ffffe097          	auipc	ra,0xffffe
    80004b90:	718080e7          	jalr	1816(ra) # 800032a4 <namei>
    80004b94:	892a                	mv	s2,a0
    80004b96:	c905                	beqz	a0,80004bc6 <sys_open+0x13c>
    ilock(ip);
    80004b98:	ffffe097          	auipc	ra,0xffffe
    80004b9c:	f56080e7          	jalr	-170(ra) # 80002aee <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004ba0:	04491703          	lh	a4,68(s2)
    80004ba4:	4785                	li	a5,1
    80004ba6:	f4f712e3          	bne	a4,a5,80004aea <sys_open+0x60>
    80004baa:	f4c42783          	lw	a5,-180(s0)
    80004bae:	dba1                	beqz	a5,80004afe <sys_open+0x74>
      iunlockput(ip);
    80004bb0:	854a                	mv	a0,s2
    80004bb2:	ffffe097          	auipc	ra,0xffffe
    80004bb6:	19e080e7          	jalr	414(ra) # 80002d50 <iunlockput>
      end_op();
    80004bba:	fffff097          	auipc	ra,0xfffff
    80004bbe:	986080e7          	jalr	-1658(ra) # 80003540 <end_op>
      return -1;
    80004bc2:	54fd                	li	s1,-1
    80004bc4:	b76d                	j	80004b6e <sys_open+0xe4>
      end_op();
    80004bc6:	fffff097          	auipc	ra,0xfffff
    80004bca:	97a080e7          	jalr	-1670(ra) # 80003540 <end_op>
      return -1;
    80004bce:	54fd                	li	s1,-1
    80004bd0:	bf79                	j	80004b6e <sys_open+0xe4>
    iunlockput(ip);
    80004bd2:	854a                	mv	a0,s2
    80004bd4:	ffffe097          	auipc	ra,0xffffe
    80004bd8:	17c080e7          	jalr	380(ra) # 80002d50 <iunlockput>
    end_op();
    80004bdc:	fffff097          	auipc	ra,0xfffff
    80004be0:	964080e7          	jalr	-1692(ra) # 80003540 <end_op>
    return -1;
    80004be4:	54fd                	li	s1,-1
    80004be6:	b761                	j	80004b6e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004be8:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004bec:	04691783          	lh	a5,70(s2)
    80004bf0:	02f99623          	sh	a5,44(s3)
    80004bf4:	bf2d                	j	80004b2e <sys_open+0xa4>
    itrunc(ip);
    80004bf6:	854a                	mv	a0,s2
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	004080e7          	jalr	4(ra) # 80002bfc <itrunc>
    80004c00:	bfb1                	j	80004b5c <sys_open+0xd2>
      fileclose(f);
    80004c02:	854e                	mv	a0,s3
    80004c04:	fffff097          	auipc	ra,0xfffff
    80004c08:	d88080e7          	jalr	-632(ra) # 8000398c <fileclose>
    iunlockput(ip);
    80004c0c:	854a                	mv	a0,s2
    80004c0e:	ffffe097          	auipc	ra,0xffffe
    80004c12:	142080e7          	jalr	322(ra) # 80002d50 <iunlockput>
    end_op();
    80004c16:	fffff097          	auipc	ra,0xfffff
    80004c1a:	92a080e7          	jalr	-1750(ra) # 80003540 <end_op>
    return -1;
    80004c1e:	54fd                	li	s1,-1
    80004c20:	b7b9                	j	80004b6e <sys_open+0xe4>

0000000080004c22 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c22:	7175                	addi	sp,sp,-144
    80004c24:	e506                	sd	ra,136(sp)
    80004c26:	e122                	sd	s0,128(sp)
    80004c28:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c2a:	fffff097          	auipc	ra,0xfffff
    80004c2e:	896080e7          	jalr	-1898(ra) # 800034c0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c32:	08000613          	li	a2,128
    80004c36:	f7040593          	addi	a1,s0,-144
    80004c3a:	4501                	li	a0,0
    80004c3c:	ffffd097          	auipc	ra,0xffffd
    80004c40:	384080e7          	jalr	900(ra) # 80001fc0 <argstr>
    80004c44:	02054963          	bltz	a0,80004c76 <sys_mkdir+0x54>
    80004c48:	4681                	li	a3,0
    80004c4a:	4601                	li	a2,0
    80004c4c:	4585                	li	a1,1
    80004c4e:	f7040513          	addi	a0,s0,-144
    80004c52:	fffff097          	auipc	ra,0xfffff
    80004c56:	7fe080e7          	jalr	2046(ra) # 80004450 <create>
    80004c5a:	cd11                	beqz	a0,80004c76 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c5c:	ffffe097          	auipc	ra,0xffffe
    80004c60:	0f4080e7          	jalr	244(ra) # 80002d50 <iunlockput>
  end_op();
    80004c64:	fffff097          	auipc	ra,0xfffff
    80004c68:	8dc080e7          	jalr	-1828(ra) # 80003540 <end_op>
  return 0;
    80004c6c:	4501                	li	a0,0
}
    80004c6e:	60aa                	ld	ra,136(sp)
    80004c70:	640a                	ld	s0,128(sp)
    80004c72:	6149                	addi	sp,sp,144
    80004c74:	8082                	ret
    end_op();
    80004c76:	fffff097          	auipc	ra,0xfffff
    80004c7a:	8ca080e7          	jalr	-1846(ra) # 80003540 <end_op>
    return -1;
    80004c7e:	557d                	li	a0,-1
    80004c80:	b7fd                	j	80004c6e <sys_mkdir+0x4c>

0000000080004c82 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004c82:	7135                	addi	sp,sp,-160
    80004c84:	ed06                	sd	ra,152(sp)
    80004c86:	e922                	sd	s0,144(sp)
    80004c88:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004c8a:	fffff097          	auipc	ra,0xfffff
    80004c8e:	836080e7          	jalr	-1994(ra) # 800034c0 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c92:	08000613          	li	a2,128
    80004c96:	f7040593          	addi	a1,s0,-144
    80004c9a:	4501                	li	a0,0
    80004c9c:	ffffd097          	auipc	ra,0xffffd
    80004ca0:	324080e7          	jalr	804(ra) # 80001fc0 <argstr>
    80004ca4:	04054a63          	bltz	a0,80004cf8 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004ca8:	f6c40593          	addi	a1,s0,-148
    80004cac:	4505                	li	a0,1
    80004cae:	ffffd097          	auipc	ra,0xffffd
    80004cb2:	2ce080e7          	jalr	718(ra) # 80001f7c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cb6:	04054163          	bltz	a0,80004cf8 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004cba:	f6840593          	addi	a1,s0,-152
    80004cbe:	4509                	li	a0,2
    80004cc0:	ffffd097          	auipc	ra,0xffffd
    80004cc4:	2bc080e7          	jalr	700(ra) # 80001f7c <argint>
     argint(1, &major) < 0 ||
    80004cc8:	02054863          	bltz	a0,80004cf8 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ccc:	f6841683          	lh	a3,-152(s0)
    80004cd0:	f6c41603          	lh	a2,-148(s0)
    80004cd4:	458d                	li	a1,3
    80004cd6:	f7040513          	addi	a0,s0,-144
    80004cda:	fffff097          	auipc	ra,0xfffff
    80004cde:	776080e7          	jalr	1910(ra) # 80004450 <create>
     argint(2, &minor) < 0 ||
    80004ce2:	c919                	beqz	a0,80004cf8 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ce4:	ffffe097          	auipc	ra,0xffffe
    80004ce8:	06c080e7          	jalr	108(ra) # 80002d50 <iunlockput>
  end_op();
    80004cec:	fffff097          	auipc	ra,0xfffff
    80004cf0:	854080e7          	jalr	-1964(ra) # 80003540 <end_op>
  return 0;
    80004cf4:	4501                	li	a0,0
    80004cf6:	a031                	j	80004d02 <sys_mknod+0x80>
    end_op();
    80004cf8:	fffff097          	auipc	ra,0xfffff
    80004cfc:	848080e7          	jalr	-1976(ra) # 80003540 <end_op>
    return -1;
    80004d00:	557d                	li	a0,-1
}
    80004d02:	60ea                	ld	ra,152(sp)
    80004d04:	644a                	ld	s0,144(sp)
    80004d06:	610d                	addi	sp,sp,160
    80004d08:	8082                	ret

0000000080004d0a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d0a:	7135                	addi	sp,sp,-160
    80004d0c:	ed06                	sd	ra,152(sp)
    80004d0e:	e922                	sd	s0,144(sp)
    80004d10:	e526                	sd	s1,136(sp)
    80004d12:	e14a                	sd	s2,128(sp)
    80004d14:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d16:	ffffc097          	auipc	ra,0xffffc
    80004d1a:	18a080e7          	jalr	394(ra) # 80000ea0 <myproc>
    80004d1e:	892a                	mv	s2,a0
  
  begin_op();
    80004d20:	ffffe097          	auipc	ra,0xffffe
    80004d24:	7a0080e7          	jalr	1952(ra) # 800034c0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d28:	08000613          	li	a2,128
    80004d2c:	f6040593          	addi	a1,s0,-160
    80004d30:	4501                	li	a0,0
    80004d32:	ffffd097          	auipc	ra,0xffffd
    80004d36:	28e080e7          	jalr	654(ra) # 80001fc0 <argstr>
    80004d3a:	04054b63          	bltz	a0,80004d90 <sys_chdir+0x86>
    80004d3e:	f6040513          	addi	a0,s0,-160
    80004d42:	ffffe097          	auipc	ra,0xffffe
    80004d46:	562080e7          	jalr	1378(ra) # 800032a4 <namei>
    80004d4a:	84aa                	mv	s1,a0
    80004d4c:	c131                	beqz	a0,80004d90 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d4e:	ffffe097          	auipc	ra,0xffffe
    80004d52:	da0080e7          	jalr	-608(ra) # 80002aee <ilock>
  if(ip->type != T_DIR){
    80004d56:	04449703          	lh	a4,68(s1)
    80004d5a:	4785                	li	a5,1
    80004d5c:	04f71063          	bne	a4,a5,80004d9c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d60:	8526                	mv	a0,s1
    80004d62:	ffffe097          	auipc	ra,0xffffe
    80004d66:	e4e080e7          	jalr	-434(ra) # 80002bb0 <iunlock>
  iput(p->cwd);
    80004d6a:	15093503          	ld	a0,336(s2)
    80004d6e:	ffffe097          	auipc	ra,0xffffe
    80004d72:	f3a080e7          	jalr	-198(ra) # 80002ca8 <iput>
  end_op();
    80004d76:	ffffe097          	auipc	ra,0xffffe
    80004d7a:	7ca080e7          	jalr	1994(ra) # 80003540 <end_op>
  p->cwd = ip;
    80004d7e:	14993823          	sd	s1,336(s2)
  return 0;
    80004d82:	4501                	li	a0,0
}
    80004d84:	60ea                	ld	ra,152(sp)
    80004d86:	644a                	ld	s0,144(sp)
    80004d88:	64aa                	ld	s1,136(sp)
    80004d8a:	690a                	ld	s2,128(sp)
    80004d8c:	610d                	addi	sp,sp,160
    80004d8e:	8082                	ret
    end_op();
    80004d90:	ffffe097          	auipc	ra,0xffffe
    80004d94:	7b0080e7          	jalr	1968(ra) # 80003540 <end_op>
    return -1;
    80004d98:	557d                	li	a0,-1
    80004d9a:	b7ed                	j	80004d84 <sys_chdir+0x7a>
    iunlockput(ip);
    80004d9c:	8526                	mv	a0,s1
    80004d9e:	ffffe097          	auipc	ra,0xffffe
    80004da2:	fb2080e7          	jalr	-78(ra) # 80002d50 <iunlockput>
    end_op();
    80004da6:	ffffe097          	auipc	ra,0xffffe
    80004daa:	79a080e7          	jalr	1946(ra) # 80003540 <end_op>
    return -1;
    80004dae:	557d                	li	a0,-1
    80004db0:	bfd1                	j	80004d84 <sys_chdir+0x7a>

0000000080004db2 <sys_exec>:

uint64
sys_exec(void)
{
    80004db2:	7145                	addi	sp,sp,-464
    80004db4:	e786                	sd	ra,456(sp)
    80004db6:	e3a2                	sd	s0,448(sp)
    80004db8:	ff26                	sd	s1,440(sp)
    80004dba:	fb4a                	sd	s2,432(sp)
    80004dbc:	f74e                	sd	s3,424(sp)
    80004dbe:	f352                	sd	s4,416(sp)
    80004dc0:	ef56                	sd	s5,408(sp)
    80004dc2:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004dc4:	08000613          	li	a2,128
    80004dc8:	f4040593          	addi	a1,s0,-192
    80004dcc:	4501                	li	a0,0
    80004dce:	ffffd097          	auipc	ra,0xffffd
    80004dd2:	1f2080e7          	jalr	498(ra) # 80001fc0 <argstr>
    return -1;
    80004dd6:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004dd8:	0c054a63          	bltz	a0,80004eac <sys_exec+0xfa>
    80004ddc:	e3840593          	addi	a1,s0,-456
    80004de0:	4505                	li	a0,1
    80004de2:	ffffd097          	auipc	ra,0xffffd
    80004de6:	1bc080e7          	jalr	444(ra) # 80001f9e <argaddr>
    80004dea:	0c054163          	bltz	a0,80004eac <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004dee:	10000613          	li	a2,256
    80004df2:	4581                	li	a1,0
    80004df4:	e4040513          	addi	a0,s0,-448
    80004df8:	ffffb097          	auipc	ra,0xffffb
    80004dfc:	380080e7          	jalr	896(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e00:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e04:	89a6                	mv	s3,s1
    80004e06:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e08:	02000a13          	li	s4,32
    80004e0c:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e10:	00391513          	slli	a0,s2,0x3
    80004e14:	e3040593          	addi	a1,s0,-464
    80004e18:	e3843783          	ld	a5,-456(s0)
    80004e1c:	953e                	add	a0,a0,a5
    80004e1e:	ffffd097          	auipc	ra,0xffffd
    80004e22:	0c4080e7          	jalr	196(ra) # 80001ee2 <fetchaddr>
    80004e26:	02054a63          	bltz	a0,80004e5a <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004e2a:	e3043783          	ld	a5,-464(s0)
    80004e2e:	c3b9                	beqz	a5,80004e74 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e30:	ffffb097          	auipc	ra,0xffffb
    80004e34:	2e8080e7          	jalr	744(ra) # 80000118 <kalloc>
    80004e38:	85aa                	mv	a1,a0
    80004e3a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e3e:	cd11                	beqz	a0,80004e5a <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e40:	6605                	lui	a2,0x1
    80004e42:	e3043503          	ld	a0,-464(s0)
    80004e46:	ffffd097          	auipc	ra,0xffffd
    80004e4a:	0ee080e7          	jalr	238(ra) # 80001f34 <fetchstr>
    80004e4e:	00054663          	bltz	a0,80004e5a <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004e52:	0905                	addi	s2,s2,1
    80004e54:	09a1                	addi	s3,s3,8
    80004e56:	fb491be3          	bne	s2,s4,80004e0c <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e5a:	10048913          	addi	s2,s1,256
    80004e5e:	6088                	ld	a0,0(s1)
    80004e60:	c529                	beqz	a0,80004eaa <sys_exec+0xf8>
    kfree(argv[i]);
    80004e62:	ffffb097          	auipc	ra,0xffffb
    80004e66:	1ba080e7          	jalr	442(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e6a:	04a1                	addi	s1,s1,8
    80004e6c:	ff2499e3          	bne	s1,s2,80004e5e <sys_exec+0xac>
  return -1;
    80004e70:	597d                	li	s2,-1
    80004e72:	a82d                	j	80004eac <sys_exec+0xfa>
      argv[i] = 0;
    80004e74:	0a8e                	slli	s5,s5,0x3
    80004e76:	fc040793          	addi	a5,s0,-64
    80004e7a:	9abe                	add	s5,s5,a5
    80004e7c:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004e80:	e4040593          	addi	a1,s0,-448
    80004e84:	f4040513          	addi	a0,s0,-192
    80004e88:	fffff097          	auipc	ra,0xfffff
    80004e8c:	194080e7          	jalr	404(ra) # 8000401c <exec>
    80004e90:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e92:	10048993          	addi	s3,s1,256
    80004e96:	6088                	ld	a0,0(s1)
    80004e98:	c911                	beqz	a0,80004eac <sys_exec+0xfa>
    kfree(argv[i]);
    80004e9a:	ffffb097          	auipc	ra,0xffffb
    80004e9e:	182080e7          	jalr	386(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ea2:	04a1                	addi	s1,s1,8
    80004ea4:	ff3499e3          	bne	s1,s3,80004e96 <sys_exec+0xe4>
    80004ea8:	a011                	j	80004eac <sys_exec+0xfa>
  return -1;
    80004eaa:	597d                	li	s2,-1
}
    80004eac:	854a                	mv	a0,s2
    80004eae:	60be                	ld	ra,456(sp)
    80004eb0:	641e                	ld	s0,448(sp)
    80004eb2:	74fa                	ld	s1,440(sp)
    80004eb4:	795a                	ld	s2,432(sp)
    80004eb6:	79ba                	ld	s3,424(sp)
    80004eb8:	7a1a                	ld	s4,416(sp)
    80004eba:	6afa                	ld	s5,408(sp)
    80004ebc:	6179                	addi	sp,sp,464
    80004ebe:	8082                	ret

0000000080004ec0 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004ec0:	7139                	addi	sp,sp,-64
    80004ec2:	fc06                	sd	ra,56(sp)
    80004ec4:	f822                	sd	s0,48(sp)
    80004ec6:	f426                	sd	s1,40(sp)
    80004ec8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004eca:	ffffc097          	auipc	ra,0xffffc
    80004ece:	fd6080e7          	jalr	-42(ra) # 80000ea0 <myproc>
    80004ed2:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004ed4:	fd840593          	addi	a1,s0,-40
    80004ed8:	4501                	li	a0,0
    80004eda:	ffffd097          	auipc	ra,0xffffd
    80004ede:	0c4080e7          	jalr	196(ra) # 80001f9e <argaddr>
    return -1;
    80004ee2:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004ee4:	0e054063          	bltz	a0,80004fc4 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004ee8:	fc840593          	addi	a1,s0,-56
    80004eec:	fd040513          	addi	a0,s0,-48
    80004ef0:	fffff097          	auipc	ra,0xfffff
    80004ef4:	dfc080e7          	jalr	-516(ra) # 80003cec <pipealloc>
    return -1;
    80004ef8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004efa:	0c054563          	bltz	a0,80004fc4 <sys_pipe+0x104>
  fd0 = -1;
    80004efe:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f02:	fd043503          	ld	a0,-48(s0)
    80004f06:	fffff097          	auipc	ra,0xfffff
    80004f0a:	508080e7          	jalr	1288(ra) # 8000440e <fdalloc>
    80004f0e:	fca42223          	sw	a0,-60(s0)
    80004f12:	08054c63          	bltz	a0,80004faa <sys_pipe+0xea>
    80004f16:	fc843503          	ld	a0,-56(s0)
    80004f1a:	fffff097          	auipc	ra,0xfffff
    80004f1e:	4f4080e7          	jalr	1268(ra) # 8000440e <fdalloc>
    80004f22:	fca42023          	sw	a0,-64(s0)
    80004f26:	06054863          	bltz	a0,80004f96 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f2a:	4691                	li	a3,4
    80004f2c:	fc440613          	addi	a2,s0,-60
    80004f30:	fd843583          	ld	a1,-40(s0)
    80004f34:	68a8                	ld	a0,80(s1)
    80004f36:	ffffc097          	auipc	ra,0xffffc
    80004f3a:	c30080e7          	jalr	-976(ra) # 80000b66 <copyout>
    80004f3e:	02054063          	bltz	a0,80004f5e <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f42:	4691                	li	a3,4
    80004f44:	fc040613          	addi	a2,s0,-64
    80004f48:	fd843583          	ld	a1,-40(s0)
    80004f4c:	0591                	addi	a1,a1,4
    80004f4e:	68a8                	ld	a0,80(s1)
    80004f50:	ffffc097          	auipc	ra,0xffffc
    80004f54:	c16080e7          	jalr	-1002(ra) # 80000b66 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f58:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f5a:	06055563          	bgez	a0,80004fc4 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004f5e:	fc442783          	lw	a5,-60(s0)
    80004f62:	07e9                	addi	a5,a5,26
    80004f64:	078e                	slli	a5,a5,0x3
    80004f66:	97a6                	add	a5,a5,s1
    80004f68:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004f6c:	fc042503          	lw	a0,-64(s0)
    80004f70:	0569                	addi	a0,a0,26
    80004f72:	050e                	slli	a0,a0,0x3
    80004f74:	9526                	add	a0,a0,s1
    80004f76:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004f7a:	fd043503          	ld	a0,-48(s0)
    80004f7e:	fffff097          	auipc	ra,0xfffff
    80004f82:	a0e080e7          	jalr	-1522(ra) # 8000398c <fileclose>
    fileclose(wf);
    80004f86:	fc843503          	ld	a0,-56(s0)
    80004f8a:	fffff097          	auipc	ra,0xfffff
    80004f8e:	a02080e7          	jalr	-1534(ra) # 8000398c <fileclose>
    return -1;
    80004f92:	57fd                	li	a5,-1
    80004f94:	a805                	j	80004fc4 <sys_pipe+0x104>
    if(fd0 >= 0)
    80004f96:	fc442783          	lw	a5,-60(s0)
    80004f9a:	0007c863          	bltz	a5,80004faa <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80004f9e:	01a78513          	addi	a0,a5,26
    80004fa2:	050e                	slli	a0,a0,0x3
    80004fa4:	9526                	add	a0,a0,s1
    80004fa6:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004faa:	fd043503          	ld	a0,-48(s0)
    80004fae:	fffff097          	auipc	ra,0xfffff
    80004fb2:	9de080e7          	jalr	-1570(ra) # 8000398c <fileclose>
    fileclose(wf);
    80004fb6:	fc843503          	ld	a0,-56(s0)
    80004fba:	fffff097          	auipc	ra,0xfffff
    80004fbe:	9d2080e7          	jalr	-1582(ra) # 8000398c <fileclose>
    return -1;
    80004fc2:	57fd                	li	a5,-1
}
    80004fc4:	853e                	mv	a0,a5
    80004fc6:	70e2                	ld	ra,56(sp)
    80004fc8:	7442                	ld	s0,48(sp)
    80004fca:	74a2                	ld	s1,40(sp)
    80004fcc:	6121                	addi	sp,sp,64
    80004fce:	8082                	ret

0000000080004fd0 <sys_connect>:


#ifdef LAB_NET
int
sys_connect(void)
{
    80004fd0:	7179                	addi	sp,sp,-48
    80004fd2:	f406                	sd	ra,40(sp)
    80004fd4:	f022                	sd	s0,32(sp)
    80004fd6:	1800                	addi	s0,sp,48
  int fd;
  uint32 raddr;
  uint32 rport;
  uint32 lport;

  if (argint(0, (int*)&raddr) < 0 ||
    80004fd8:	fe440593          	addi	a1,s0,-28
    80004fdc:	4501                	li	a0,0
    80004fde:	ffffd097          	auipc	ra,0xffffd
    80004fe2:	f9e080e7          	jalr	-98(ra) # 80001f7c <argint>
    80004fe6:	06054663          	bltz	a0,80005052 <sys_connect+0x82>
      argint(1, (int*)&lport) < 0 ||
    80004fea:	fdc40593          	addi	a1,s0,-36
    80004fee:	4505                	li	a0,1
    80004ff0:	ffffd097          	auipc	ra,0xffffd
    80004ff4:	f8c080e7          	jalr	-116(ra) # 80001f7c <argint>
  if (argint(0, (int*)&raddr) < 0 ||
    80004ff8:	04054f63          	bltz	a0,80005056 <sys_connect+0x86>
      argint(2, (int*)&rport) < 0) {
    80004ffc:	fe040593          	addi	a1,s0,-32
    80005000:	4509                	li	a0,2
    80005002:	ffffd097          	auipc	ra,0xffffd
    80005006:	f7a080e7          	jalr	-134(ra) # 80001f7c <argint>
      argint(1, (int*)&lport) < 0 ||
    8000500a:	04054863          	bltz	a0,8000505a <sys_connect+0x8a>
    return -1;
  }

  if(sockalloc(&f, raddr, lport, rport) < 0)
    8000500e:	fe045683          	lhu	a3,-32(s0)
    80005012:	fdc45603          	lhu	a2,-36(s0)
    80005016:	fe442583          	lw	a1,-28(s0)
    8000501a:	fe840513          	addi	a0,s0,-24
    8000501e:	00001097          	auipc	ra,0x1
    80005022:	244080e7          	jalr	580(ra) # 80006262 <sockalloc>
    80005026:	02054c63          	bltz	a0,8000505e <sys_connect+0x8e>
    return -1;
  if((fd=fdalloc(f)) < 0){
    8000502a:	fe843503          	ld	a0,-24(s0)
    8000502e:	fffff097          	auipc	ra,0xfffff
    80005032:	3e0080e7          	jalr	992(ra) # 8000440e <fdalloc>
    80005036:	00054663          	bltz	a0,80005042 <sys_connect+0x72>
    fileclose(f);
    return -1;
  }

  return fd;
}
    8000503a:	70a2                	ld	ra,40(sp)
    8000503c:	7402                	ld	s0,32(sp)
    8000503e:	6145                	addi	sp,sp,48
    80005040:	8082                	ret
    fileclose(f);
    80005042:	fe843503          	ld	a0,-24(s0)
    80005046:	fffff097          	auipc	ra,0xfffff
    8000504a:	946080e7          	jalr	-1722(ra) # 8000398c <fileclose>
    return -1;
    8000504e:	557d                	li	a0,-1
    80005050:	b7ed                	j	8000503a <sys_connect+0x6a>
    return -1;
    80005052:	557d                	li	a0,-1
    80005054:	b7dd                	j	8000503a <sys_connect+0x6a>
    80005056:	557d                	li	a0,-1
    80005058:	b7cd                	j	8000503a <sys_connect+0x6a>
    8000505a:	557d                	li	a0,-1
    8000505c:	bff9                	j	8000503a <sys_connect+0x6a>
    return -1;
    8000505e:	557d                	li	a0,-1
    80005060:	bfe9                	j	8000503a <sys_connect+0x6a>
	...

0000000080005070 <kernelvec>:
    80005070:	7111                	addi	sp,sp,-256
    80005072:	e006                	sd	ra,0(sp)
    80005074:	e40a                	sd	sp,8(sp)
    80005076:	e80e                	sd	gp,16(sp)
    80005078:	ec12                	sd	tp,24(sp)
    8000507a:	f016                	sd	t0,32(sp)
    8000507c:	f41a                	sd	t1,40(sp)
    8000507e:	f81e                	sd	t2,48(sp)
    80005080:	fc22                	sd	s0,56(sp)
    80005082:	e0a6                	sd	s1,64(sp)
    80005084:	e4aa                	sd	a0,72(sp)
    80005086:	e8ae                	sd	a1,80(sp)
    80005088:	ecb2                	sd	a2,88(sp)
    8000508a:	f0b6                	sd	a3,96(sp)
    8000508c:	f4ba                	sd	a4,104(sp)
    8000508e:	f8be                	sd	a5,112(sp)
    80005090:	fcc2                	sd	a6,120(sp)
    80005092:	e146                	sd	a7,128(sp)
    80005094:	e54a                	sd	s2,136(sp)
    80005096:	e94e                	sd	s3,144(sp)
    80005098:	ed52                	sd	s4,152(sp)
    8000509a:	f156                	sd	s5,160(sp)
    8000509c:	f55a                	sd	s6,168(sp)
    8000509e:	f95e                	sd	s7,176(sp)
    800050a0:	fd62                	sd	s8,184(sp)
    800050a2:	e1e6                	sd	s9,192(sp)
    800050a4:	e5ea                	sd	s10,200(sp)
    800050a6:	e9ee                	sd	s11,208(sp)
    800050a8:	edf2                	sd	t3,216(sp)
    800050aa:	f1f6                	sd	t4,224(sp)
    800050ac:	f5fa                	sd	t5,232(sp)
    800050ae:	f9fe                	sd	t6,240(sp)
    800050b0:	cfffc0ef          	jal	ra,80001dae <kerneltrap>
    800050b4:	6082                	ld	ra,0(sp)
    800050b6:	6122                	ld	sp,8(sp)
    800050b8:	61c2                	ld	gp,16(sp)
    800050ba:	7282                	ld	t0,32(sp)
    800050bc:	7322                	ld	t1,40(sp)
    800050be:	73c2                	ld	t2,48(sp)
    800050c0:	7462                	ld	s0,56(sp)
    800050c2:	6486                	ld	s1,64(sp)
    800050c4:	6526                	ld	a0,72(sp)
    800050c6:	65c6                	ld	a1,80(sp)
    800050c8:	6666                	ld	a2,88(sp)
    800050ca:	7686                	ld	a3,96(sp)
    800050cc:	7726                	ld	a4,104(sp)
    800050ce:	77c6                	ld	a5,112(sp)
    800050d0:	7866                	ld	a6,120(sp)
    800050d2:	688a                	ld	a7,128(sp)
    800050d4:	692a                	ld	s2,136(sp)
    800050d6:	69ca                	ld	s3,144(sp)
    800050d8:	6a6a                	ld	s4,152(sp)
    800050da:	7a8a                	ld	s5,160(sp)
    800050dc:	7b2a                	ld	s6,168(sp)
    800050de:	7bca                	ld	s7,176(sp)
    800050e0:	7c6a                	ld	s8,184(sp)
    800050e2:	6c8e                	ld	s9,192(sp)
    800050e4:	6d2e                	ld	s10,200(sp)
    800050e6:	6dce                	ld	s11,208(sp)
    800050e8:	6e6e                	ld	t3,216(sp)
    800050ea:	7e8e                	ld	t4,224(sp)
    800050ec:	7f2e                	ld	t5,232(sp)
    800050ee:	7fce                	ld	t6,240(sp)
    800050f0:	6111                	addi	sp,sp,256
    800050f2:	10200073          	sret
    800050f6:	00000013          	nop
    800050fa:	00000013          	nop
    800050fe:	0001                	nop

0000000080005100 <timervec>:
    80005100:	34051573          	csrrw	a0,mscratch,a0
    80005104:	e10c                	sd	a1,0(a0)
    80005106:	e510                	sd	a2,8(a0)
    80005108:	e914                	sd	a3,16(a0)
    8000510a:	6d0c                	ld	a1,24(a0)
    8000510c:	7110                	ld	a2,32(a0)
    8000510e:	6194                	ld	a3,0(a1)
    80005110:	96b2                	add	a3,a3,a2
    80005112:	e194                	sd	a3,0(a1)
    80005114:	4589                	li	a1,2
    80005116:	14459073          	csrw	sip,a1
    8000511a:	6914                	ld	a3,16(a0)
    8000511c:	6510                	ld	a2,8(a0)
    8000511e:	610c                	ld	a1,0(a0)
    80005120:	34051573          	csrrw	a0,mscratch,a0
    80005124:	30200073          	mret
	...

000000008000512a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000512a:	1141                	addi	sp,sp,-16
    8000512c:	e422                	sd	s0,8(sp)
    8000512e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005130:	0c0007b7          	lui	a5,0xc000
    80005134:	4705                	li	a4,1
    80005136:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005138:	c3d8                	sw	a4,4(a5)
    8000513a:	0791                	addi	a5,a5,4
  
#ifdef LAB_NET
  // PCIE IRQs are 32 to 35
  for(int irq = 1; irq < 0x35; irq++){
    *(uint32*)(PLIC + irq*4) = 1;
    8000513c:	4685                	li	a3,1
  for(int irq = 1; irq < 0x35; irq++){
    8000513e:	0c000737          	lui	a4,0xc000
    80005142:	0d470713          	addi	a4,a4,212 # c0000d4 <_entry-0x73ffff2c>
    *(uint32*)(PLIC + irq*4) = 1;
    80005146:	c394                	sw	a3,0(a5)
  for(int irq = 1; irq < 0x35; irq++){
    80005148:	0791                	addi	a5,a5,4
    8000514a:	fee79ee3          	bne	a5,a4,80005146 <plicinit+0x1c>
  }
#endif  
}
    8000514e:	6422                	ld	s0,8(sp)
    80005150:	0141                	addi	sp,sp,16
    80005152:	8082                	ret

0000000080005154 <plicinithart>:

void
plicinithart(void)
{
    80005154:	1141                	addi	sp,sp,-16
    80005156:	e406                	sd	ra,8(sp)
    80005158:	e022                	sd	s0,0(sp)
    8000515a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000515c:	ffffc097          	auipc	ra,0xffffc
    80005160:	d18080e7          	jalr	-744(ra) # 80000e74 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005164:	0085171b          	slliw	a4,a0,0x8
    80005168:	0c0027b7          	lui	a5,0xc002
    8000516c:	97ba                	add	a5,a5,a4
    8000516e:	40200713          	li	a4,1026
    80005172:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

#ifdef LAB_NET
  // hack to get at next 32 IRQs for e1000
  *(uint32*)(PLIC_SENABLE(hart)+4) = 0xffffffff;
    80005176:	577d                	li	a4,-1
    80005178:	08e7a223          	sw	a4,132(a5)
#endif
  
  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    8000517c:	00d5151b          	slliw	a0,a0,0xd
    80005180:	0c2017b7          	lui	a5,0xc201
    80005184:	953e                	add	a0,a0,a5
    80005186:	00052023          	sw	zero,0(a0)
}
    8000518a:	60a2                	ld	ra,8(sp)
    8000518c:	6402                	ld	s0,0(sp)
    8000518e:	0141                	addi	sp,sp,16
    80005190:	8082                	ret

0000000080005192 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005192:	1141                	addi	sp,sp,-16
    80005194:	e406                	sd	ra,8(sp)
    80005196:	e022                	sd	s0,0(sp)
    80005198:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000519a:	ffffc097          	auipc	ra,0xffffc
    8000519e:	cda080e7          	jalr	-806(ra) # 80000e74 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051a2:	00d5179b          	slliw	a5,a0,0xd
    800051a6:	0c201537          	lui	a0,0xc201
    800051aa:	953e                	add	a0,a0,a5
  return irq;
}
    800051ac:	4148                	lw	a0,4(a0)
    800051ae:	60a2                	ld	ra,8(sp)
    800051b0:	6402                	ld	s0,0(sp)
    800051b2:	0141                	addi	sp,sp,16
    800051b4:	8082                	ret

00000000800051b6 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051b6:	1101                	addi	sp,sp,-32
    800051b8:	ec06                	sd	ra,24(sp)
    800051ba:	e822                	sd	s0,16(sp)
    800051bc:	e426                	sd	s1,8(sp)
    800051be:	1000                	addi	s0,sp,32
    800051c0:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051c2:	ffffc097          	auipc	ra,0xffffc
    800051c6:	cb2080e7          	jalr	-846(ra) # 80000e74 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051ca:	00d5151b          	slliw	a0,a0,0xd
    800051ce:	0c2017b7          	lui	a5,0xc201
    800051d2:	97aa                	add	a5,a5,a0
    800051d4:	c3c4                	sw	s1,4(a5)
}
    800051d6:	60e2                	ld	ra,24(sp)
    800051d8:	6442                	ld	s0,16(sp)
    800051da:	64a2                	ld	s1,8(sp)
    800051dc:	6105                	addi	sp,sp,32
    800051de:	8082                	ret

00000000800051e0 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051e0:	1141                	addi	sp,sp,-16
    800051e2:	e406                	sd	ra,8(sp)
    800051e4:	e022                	sd	s0,0(sp)
    800051e6:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051e8:	479d                	li	a5,7
    800051ea:	06a7c963          	blt	a5,a0,8000525c <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800051ee:	00017797          	auipc	a5,0x17
    800051f2:	e1278793          	addi	a5,a5,-494 # 8001c000 <disk>
    800051f6:	00a78733          	add	a4,a5,a0
    800051fa:	6789                	lui	a5,0x2
    800051fc:	97ba                	add	a5,a5,a4
    800051fe:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005202:	e7ad                	bnez	a5,8000526c <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005204:	00451793          	slli	a5,a0,0x4
    80005208:	00019717          	auipc	a4,0x19
    8000520c:	df870713          	addi	a4,a4,-520 # 8001e000 <disk+0x2000>
    80005210:	6314                	ld	a3,0(a4)
    80005212:	96be                	add	a3,a3,a5
    80005214:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005218:	6314                	ld	a3,0(a4)
    8000521a:	96be                	add	a3,a3,a5
    8000521c:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005220:	6314                	ld	a3,0(a4)
    80005222:	96be                	add	a3,a3,a5
    80005224:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005228:	6318                	ld	a4,0(a4)
    8000522a:	97ba                	add	a5,a5,a4
    8000522c:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005230:	00017797          	auipc	a5,0x17
    80005234:	dd078793          	addi	a5,a5,-560 # 8001c000 <disk>
    80005238:	97aa                	add	a5,a5,a0
    8000523a:	6509                	lui	a0,0x2
    8000523c:	953e                	add	a0,a0,a5
    8000523e:	4785                	li	a5,1
    80005240:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005244:	00019517          	auipc	a0,0x19
    80005248:	dd450513          	addi	a0,a0,-556 # 8001e018 <disk+0x2018>
    8000524c:	ffffc097          	auipc	ra,0xffffc
    80005250:	49c080e7          	jalr	1180(ra) # 800016e8 <wakeup>
}
    80005254:	60a2                	ld	ra,8(sp)
    80005256:	6402                	ld	s0,0(sp)
    80005258:	0141                	addi	sp,sp,16
    8000525a:	8082                	ret
    panic("free_desc 1");
    8000525c:	00004517          	auipc	a0,0x4
    80005260:	4dc50513          	addi	a0,a0,1244 # 80009738 <syscalls+0x360>
    80005264:	00002097          	auipc	ra,0x2
    80005268:	990080e7          	jalr	-1648(ra) # 80006bf4 <panic>
    panic("free_desc 2");
    8000526c:	00004517          	auipc	a0,0x4
    80005270:	4dc50513          	addi	a0,a0,1244 # 80009748 <syscalls+0x370>
    80005274:	00002097          	auipc	ra,0x2
    80005278:	980080e7          	jalr	-1664(ra) # 80006bf4 <panic>

000000008000527c <virtio_disk_init>:
{
    8000527c:	1101                	addi	sp,sp,-32
    8000527e:	ec06                	sd	ra,24(sp)
    80005280:	e822                	sd	s0,16(sp)
    80005282:	e426                	sd	s1,8(sp)
    80005284:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005286:	00004597          	auipc	a1,0x4
    8000528a:	4d258593          	addi	a1,a1,1234 # 80009758 <syscalls+0x380>
    8000528e:	00019517          	auipc	a0,0x19
    80005292:	e9a50513          	addi	a0,a0,-358 # 8001e128 <disk+0x2128>
    80005296:	00002097          	auipc	ra,0x2
    8000529a:	e18080e7          	jalr	-488(ra) # 800070ae <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000529e:	100017b7          	lui	a5,0x10001
    800052a2:	4398                	lw	a4,0(a5)
    800052a4:	2701                	sext.w	a4,a4
    800052a6:	747277b7          	lui	a5,0x74727
    800052aa:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052ae:	0ef71163          	bne	a4,a5,80005390 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052b2:	100017b7          	lui	a5,0x10001
    800052b6:	43dc                	lw	a5,4(a5)
    800052b8:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052ba:	4705                	li	a4,1
    800052bc:	0ce79a63          	bne	a5,a4,80005390 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052c0:	100017b7          	lui	a5,0x10001
    800052c4:	479c                	lw	a5,8(a5)
    800052c6:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052c8:	4709                	li	a4,2
    800052ca:	0ce79363          	bne	a5,a4,80005390 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052ce:	100017b7          	lui	a5,0x10001
    800052d2:	47d8                	lw	a4,12(a5)
    800052d4:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052d6:	554d47b7          	lui	a5,0x554d4
    800052da:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052de:	0af71963          	bne	a4,a5,80005390 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052e2:	100017b7          	lui	a5,0x10001
    800052e6:	4705                	li	a4,1
    800052e8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ea:	470d                	li	a4,3
    800052ec:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052ee:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052f0:	c7ffe737          	lui	a4,0xc7ffe
    800052f4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd71cf>
    800052f8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052fa:	2701                	sext.w	a4,a4
    800052fc:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052fe:	472d                	li	a4,11
    80005300:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005302:	473d                	li	a4,15
    80005304:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005306:	6705                	lui	a4,0x1
    80005308:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000530a:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000530e:	5bdc                	lw	a5,52(a5)
    80005310:	2781                	sext.w	a5,a5
  if(max == 0)
    80005312:	c7d9                	beqz	a5,800053a0 <virtio_disk_init+0x124>
  if(max < NUM)
    80005314:	471d                	li	a4,7
    80005316:	08f77d63          	bgeu	a4,a5,800053b0 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000531a:	100014b7          	lui	s1,0x10001
    8000531e:	47a1                	li	a5,8
    80005320:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005322:	6609                	lui	a2,0x2
    80005324:	4581                	li	a1,0
    80005326:	00017517          	auipc	a0,0x17
    8000532a:	cda50513          	addi	a0,a0,-806 # 8001c000 <disk>
    8000532e:	ffffb097          	auipc	ra,0xffffb
    80005332:	e4a080e7          	jalr	-438(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005336:	00017717          	auipc	a4,0x17
    8000533a:	cca70713          	addi	a4,a4,-822 # 8001c000 <disk>
    8000533e:	00c75793          	srli	a5,a4,0xc
    80005342:	2781                	sext.w	a5,a5
    80005344:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005346:	00019797          	auipc	a5,0x19
    8000534a:	cba78793          	addi	a5,a5,-838 # 8001e000 <disk+0x2000>
    8000534e:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005350:	00017717          	auipc	a4,0x17
    80005354:	d3070713          	addi	a4,a4,-720 # 8001c080 <disk+0x80>
    80005358:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000535a:	00018717          	auipc	a4,0x18
    8000535e:	ca670713          	addi	a4,a4,-858 # 8001d000 <disk+0x1000>
    80005362:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005364:	4705                	li	a4,1
    80005366:	00e78c23          	sb	a4,24(a5)
    8000536a:	00e78ca3          	sb	a4,25(a5)
    8000536e:	00e78d23          	sb	a4,26(a5)
    80005372:	00e78da3          	sb	a4,27(a5)
    80005376:	00e78e23          	sb	a4,28(a5)
    8000537a:	00e78ea3          	sb	a4,29(a5)
    8000537e:	00e78f23          	sb	a4,30(a5)
    80005382:	00e78fa3          	sb	a4,31(a5)
}
    80005386:	60e2                	ld	ra,24(sp)
    80005388:	6442                	ld	s0,16(sp)
    8000538a:	64a2                	ld	s1,8(sp)
    8000538c:	6105                	addi	sp,sp,32
    8000538e:	8082                	ret
    panic("could not find virtio disk");
    80005390:	00004517          	auipc	a0,0x4
    80005394:	3d850513          	addi	a0,a0,984 # 80009768 <syscalls+0x390>
    80005398:	00002097          	auipc	ra,0x2
    8000539c:	85c080e7          	jalr	-1956(ra) # 80006bf4 <panic>
    panic("virtio disk has no queue 0");
    800053a0:	00004517          	auipc	a0,0x4
    800053a4:	3e850513          	addi	a0,a0,1000 # 80009788 <syscalls+0x3b0>
    800053a8:	00002097          	auipc	ra,0x2
    800053ac:	84c080e7          	jalr	-1972(ra) # 80006bf4 <panic>
    panic("virtio disk max queue too short");
    800053b0:	00004517          	auipc	a0,0x4
    800053b4:	3f850513          	addi	a0,a0,1016 # 800097a8 <syscalls+0x3d0>
    800053b8:	00002097          	auipc	ra,0x2
    800053bc:	83c080e7          	jalr	-1988(ra) # 80006bf4 <panic>

00000000800053c0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053c0:	7159                	addi	sp,sp,-112
    800053c2:	f486                	sd	ra,104(sp)
    800053c4:	f0a2                	sd	s0,96(sp)
    800053c6:	eca6                	sd	s1,88(sp)
    800053c8:	e8ca                	sd	s2,80(sp)
    800053ca:	e4ce                	sd	s3,72(sp)
    800053cc:	e0d2                	sd	s4,64(sp)
    800053ce:	fc56                	sd	s5,56(sp)
    800053d0:	f85a                	sd	s6,48(sp)
    800053d2:	f45e                	sd	s7,40(sp)
    800053d4:	f062                	sd	s8,32(sp)
    800053d6:	ec66                	sd	s9,24(sp)
    800053d8:	e86a                	sd	s10,16(sp)
    800053da:	1880                	addi	s0,sp,112
    800053dc:	892a                	mv	s2,a0
    800053de:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053e0:	00c52c83          	lw	s9,12(a0)
    800053e4:	001c9c9b          	slliw	s9,s9,0x1
    800053e8:	1c82                	slli	s9,s9,0x20
    800053ea:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053ee:	00019517          	auipc	a0,0x19
    800053f2:	d3a50513          	addi	a0,a0,-710 # 8001e128 <disk+0x2128>
    800053f6:	00002097          	auipc	ra,0x2
    800053fa:	d48080e7          	jalr	-696(ra) # 8000713e <acquire>
  for(int i = 0; i < 3; i++){
    800053fe:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005400:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005402:	00017b97          	auipc	s7,0x17
    80005406:	bfeb8b93          	addi	s7,s7,-1026 # 8001c000 <disk>
    8000540a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000540c:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    8000540e:	8a4e                	mv	s4,s3
    80005410:	a051                	j	80005494 <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005412:	00fb86b3          	add	a3,s7,a5
    80005416:	96da                	add	a3,a3,s6
    80005418:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    8000541c:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000541e:	0207c563          	bltz	a5,80005448 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005422:	2485                	addiw	s1,s1,1
    80005424:	0711                	addi	a4,a4,4
    80005426:	25548063          	beq	s1,s5,80005666 <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    8000542a:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    8000542c:	00019697          	auipc	a3,0x19
    80005430:	bec68693          	addi	a3,a3,-1044 # 8001e018 <disk+0x2018>
    80005434:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005436:	0006c583          	lbu	a1,0(a3)
    8000543a:	fde1                	bnez	a1,80005412 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000543c:	2785                	addiw	a5,a5,1
    8000543e:	0685                	addi	a3,a3,1
    80005440:	ff879be3          	bne	a5,s8,80005436 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005444:	57fd                	li	a5,-1
    80005446:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005448:	02905a63          	blez	s1,8000547c <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    8000544c:	f9042503          	lw	a0,-112(s0)
    80005450:	00000097          	auipc	ra,0x0
    80005454:	d90080e7          	jalr	-624(ra) # 800051e0 <free_desc>
      for(int j = 0; j < i; j++)
    80005458:	4785                	li	a5,1
    8000545a:	0297d163          	bge	a5,s1,8000547c <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    8000545e:	f9442503          	lw	a0,-108(s0)
    80005462:	00000097          	auipc	ra,0x0
    80005466:	d7e080e7          	jalr	-642(ra) # 800051e0 <free_desc>
      for(int j = 0; j < i; j++)
    8000546a:	4789                	li	a5,2
    8000546c:	0097d863          	bge	a5,s1,8000547c <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005470:	f9842503          	lw	a0,-104(s0)
    80005474:	00000097          	auipc	ra,0x0
    80005478:	d6c080e7          	jalr	-660(ra) # 800051e0 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000547c:	00019597          	auipc	a1,0x19
    80005480:	cac58593          	addi	a1,a1,-852 # 8001e128 <disk+0x2128>
    80005484:	00019517          	auipc	a0,0x19
    80005488:	b9450513          	addi	a0,a0,-1132 # 8001e018 <disk+0x2018>
    8000548c:	ffffc097          	auipc	ra,0xffffc
    80005490:	0d0080e7          	jalr	208(ra) # 8000155c <sleep>
  for(int i = 0; i < 3; i++){
    80005494:	f9040713          	addi	a4,s0,-112
    80005498:	84ce                	mv	s1,s3
    8000549a:	bf41                	j	8000542a <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    8000549c:	20058713          	addi	a4,a1,512
    800054a0:	00471693          	slli	a3,a4,0x4
    800054a4:	00017717          	auipc	a4,0x17
    800054a8:	b5c70713          	addi	a4,a4,-1188 # 8001c000 <disk>
    800054ac:	9736                	add	a4,a4,a3
    800054ae:	4685                	li	a3,1
    800054b0:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054b4:	20058713          	addi	a4,a1,512
    800054b8:	00471693          	slli	a3,a4,0x4
    800054bc:	00017717          	auipc	a4,0x17
    800054c0:	b4470713          	addi	a4,a4,-1212 # 8001c000 <disk>
    800054c4:	9736                	add	a4,a4,a3
    800054c6:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800054ca:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054ce:	7679                	lui	a2,0xffffe
    800054d0:	963e                	add	a2,a2,a5
    800054d2:	00019697          	auipc	a3,0x19
    800054d6:	b2e68693          	addi	a3,a3,-1234 # 8001e000 <disk+0x2000>
    800054da:	6298                	ld	a4,0(a3)
    800054dc:	9732                	add	a4,a4,a2
    800054de:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054e0:	6298                	ld	a4,0(a3)
    800054e2:	9732                	add	a4,a4,a2
    800054e4:	4541                	li	a0,16
    800054e6:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054e8:	6298                	ld	a4,0(a3)
    800054ea:	9732                	add	a4,a4,a2
    800054ec:	4505                	li	a0,1
    800054ee:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800054f2:	f9442703          	lw	a4,-108(s0)
    800054f6:	6288                	ld	a0,0(a3)
    800054f8:	962a                	add	a2,a2,a0
    800054fa:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd6a7e>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054fe:	0712                	slli	a4,a4,0x4
    80005500:	6290                	ld	a2,0(a3)
    80005502:	963a                	add	a2,a2,a4
    80005504:	05890513          	addi	a0,s2,88
    80005508:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000550a:	6294                	ld	a3,0(a3)
    8000550c:	96ba                	add	a3,a3,a4
    8000550e:	40000613          	li	a2,1024
    80005512:	c690                	sw	a2,8(a3)
  if(write)
    80005514:	140d0063          	beqz	s10,80005654 <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005518:	00019697          	auipc	a3,0x19
    8000551c:	ae86b683          	ld	a3,-1304(a3) # 8001e000 <disk+0x2000>
    80005520:	96ba                	add	a3,a3,a4
    80005522:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005526:	00017817          	auipc	a6,0x17
    8000552a:	ada80813          	addi	a6,a6,-1318 # 8001c000 <disk>
    8000552e:	00019517          	auipc	a0,0x19
    80005532:	ad250513          	addi	a0,a0,-1326 # 8001e000 <disk+0x2000>
    80005536:	6114                	ld	a3,0(a0)
    80005538:	96ba                	add	a3,a3,a4
    8000553a:	00c6d603          	lhu	a2,12(a3)
    8000553e:	00166613          	ori	a2,a2,1
    80005542:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005546:	f9842683          	lw	a3,-104(s0)
    8000554a:	6110                	ld	a2,0(a0)
    8000554c:	9732                	add	a4,a4,a2
    8000554e:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005552:	20058613          	addi	a2,a1,512
    80005556:	0612                	slli	a2,a2,0x4
    80005558:	9642                	add	a2,a2,a6
    8000555a:	577d                	li	a4,-1
    8000555c:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005560:	00469713          	slli	a4,a3,0x4
    80005564:	6114                	ld	a3,0(a0)
    80005566:	96ba                	add	a3,a3,a4
    80005568:	03078793          	addi	a5,a5,48
    8000556c:	97c2                	add	a5,a5,a6
    8000556e:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005570:	611c                	ld	a5,0(a0)
    80005572:	97ba                	add	a5,a5,a4
    80005574:	4685                	li	a3,1
    80005576:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005578:	611c                	ld	a5,0(a0)
    8000557a:	97ba                	add	a5,a5,a4
    8000557c:	4809                	li	a6,2
    8000557e:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005582:	611c                	ld	a5,0(a0)
    80005584:	973e                	add	a4,a4,a5
    80005586:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000558a:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    8000558e:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005592:	6518                	ld	a4,8(a0)
    80005594:	00275783          	lhu	a5,2(a4)
    80005598:	8b9d                	andi	a5,a5,7
    8000559a:	0786                	slli	a5,a5,0x1
    8000559c:	97ba                	add	a5,a5,a4
    8000559e:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800055a2:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055a6:	6518                	ld	a4,8(a0)
    800055a8:	00275783          	lhu	a5,2(a4)
    800055ac:	2785                	addiw	a5,a5,1
    800055ae:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055b2:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055b6:	100017b7          	lui	a5,0x10001
    800055ba:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055be:	00492703          	lw	a4,4(s2)
    800055c2:	4785                	li	a5,1
    800055c4:	02f71163          	bne	a4,a5,800055e6 <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800055c8:	00019997          	auipc	s3,0x19
    800055cc:	b6098993          	addi	s3,s3,-1184 # 8001e128 <disk+0x2128>
  while(b->disk == 1) {
    800055d0:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800055d2:	85ce                	mv	a1,s3
    800055d4:	854a                	mv	a0,s2
    800055d6:	ffffc097          	auipc	ra,0xffffc
    800055da:	f86080e7          	jalr	-122(ra) # 8000155c <sleep>
  while(b->disk == 1) {
    800055de:	00492783          	lw	a5,4(s2)
    800055e2:	fe9788e3          	beq	a5,s1,800055d2 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800055e6:	f9042903          	lw	s2,-112(s0)
    800055ea:	20090793          	addi	a5,s2,512
    800055ee:	00479713          	slli	a4,a5,0x4
    800055f2:	00017797          	auipc	a5,0x17
    800055f6:	a0e78793          	addi	a5,a5,-1522 # 8001c000 <disk>
    800055fa:	97ba                	add	a5,a5,a4
    800055fc:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005600:	00019997          	auipc	s3,0x19
    80005604:	a0098993          	addi	s3,s3,-1536 # 8001e000 <disk+0x2000>
    80005608:	00491713          	slli	a4,s2,0x4
    8000560c:	0009b783          	ld	a5,0(s3)
    80005610:	97ba                	add	a5,a5,a4
    80005612:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005616:	854a                	mv	a0,s2
    80005618:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000561c:	00000097          	auipc	ra,0x0
    80005620:	bc4080e7          	jalr	-1084(ra) # 800051e0 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005624:	8885                	andi	s1,s1,1
    80005626:	f0ed                	bnez	s1,80005608 <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005628:	00019517          	auipc	a0,0x19
    8000562c:	b0050513          	addi	a0,a0,-1280 # 8001e128 <disk+0x2128>
    80005630:	00002097          	auipc	ra,0x2
    80005634:	bc2080e7          	jalr	-1086(ra) # 800071f2 <release>
}
    80005638:	70a6                	ld	ra,104(sp)
    8000563a:	7406                	ld	s0,96(sp)
    8000563c:	64e6                	ld	s1,88(sp)
    8000563e:	6946                	ld	s2,80(sp)
    80005640:	69a6                	ld	s3,72(sp)
    80005642:	6a06                	ld	s4,64(sp)
    80005644:	7ae2                	ld	s5,56(sp)
    80005646:	7b42                	ld	s6,48(sp)
    80005648:	7ba2                	ld	s7,40(sp)
    8000564a:	7c02                	ld	s8,32(sp)
    8000564c:	6ce2                	ld	s9,24(sp)
    8000564e:	6d42                	ld	s10,16(sp)
    80005650:	6165                	addi	sp,sp,112
    80005652:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005654:	00019697          	auipc	a3,0x19
    80005658:	9ac6b683          	ld	a3,-1620(a3) # 8001e000 <disk+0x2000>
    8000565c:	96ba                	add	a3,a3,a4
    8000565e:	4609                	li	a2,2
    80005660:	00c69623          	sh	a2,12(a3)
    80005664:	b5c9                	j	80005526 <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005666:	f9042583          	lw	a1,-112(s0)
    8000566a:	20058793          	addi	a5,a1,512
    8000566e:	0792                	slli	a5,a5,0x4
    80005670:	00017517          	auipc	a0,0x17
    80005674:	a3850513          	addi	a0,a0,-1480 # 8001c0a8 <disk+0xa8>
    80005678:	953e                	add	a0,a0,a5
  if(write)
    8000567a:	e20d11e3          	bnez	s10,8000549c <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000567e:	20058713          	addi	a4,a1,512
    80005682:	00471693          	slli	a3,a4,0x4
    80005686:	00017717          	auipc	a4,0x17
    8000568a:	97a70713          	addi	a4,a4,-1670 # 8001c000 <disk>
    8000568e:	9736                	add	a4,a4,a3
    80005690:	0a072423          	sw	zero,168(a4)
    80005694:	b505                	j	800054b4 <virtio_disk_rw+0xf4>

0000000080005696 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005696:	1101                	addi	sp,sp,-32
    80005698:	ec06                	sd	ra,24(sp)
    8000569a:	e822                	sd	s0,16(sp)
    8000569c:	e426                	sd	s1,8(sp)
    8000569e:	e04a                	sd	s2,0(sp)
    800056a0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056a2:	00019517          	auipc	a0,0x19
    800056a6:	a8650513          	addi	a0,a0,-1402 # 8001e128 <disk+0x2128>
    800056aa:	00002097          	auipc	ra,0x2
    800056ae:	a94080e7          	jalr	-1388(ra) # 8000713e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056b2:	10001737          	lui	a4,0x10001
    800056b6:	533c                	lw	a5,96(a4)
    800056b8:	8b8d                	andi	a5,a5,3
    800056ba:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056bc:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056c0:	00019797          	auipc	a5,0x19
    800056c4:	94078793          	addi	a5,a5,-1728 # 8001e000 <disk+0x2000>
    800056c8:	6b94                	ld	a3,16(a5)
    800056ca:	0207d703          	lhu	a4,32(a5)
    800056ce:	0026d783          	lhu	a5,2(a3)
    800056d2:	06f70163          	beq	a4,a5,80005734 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056d6:	00017917          	auipc	s2,0x17
    800056da:	92a90913          	addi	s2,s2,-1750 # 8001c000 <disk>
    800056de:	00019497          	auipc	s1,0x19
    800056e2:	92248493          	addi	s1,s1,-1758 # 8001e000 <disk+0x2000>
    __sync_synchronize();
    800056e6:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056ea:	6898                	ld	a4,16(s1)
    800056ec:	0204d783          	lhu	a5,32(s1)
    800056f0:	8b9d                	andi	a5,a5,7
    800056f2:	078e                	slli	a5,a5,0x3
    800056f4:	97ba                	add	a5,a5,a4
    800056f6:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056f8:	20078713          	addi	a4,a5,512
    800056fc:	0712                	slli	a4,a4,0x4
    800056fe:	974a                	add	a4,a4,s2
    80005700:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005704:	e731                	bnez	a4,80005750 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005706:	20078793          	addi	a5,a5,512
    8000570a:	0792                	slli	a5,a5,0x4
    8000570c:	97ca                	add	a5,a5,s2
    8000570e:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005710:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005714:	ffffc097          	auipc	ra,0xffffc
    80005718:	fd4080e7          	jalr	-44(ra) # 800016e8 <wakeup>

    disk.used_idx += 1;
    8000571c:	0204d783          	lhu	a5,32(s1)
    80005720:	2785                	addiw	a5,a5,1
    80005722:	17c2                	slli	a5,a5,0x30
    80005724:	93c1                	srli	a5,a5,0x30
    80005726:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000572a:	6898                	ld	a4,16(s1)
    8000572c:	00275703          	lhu	a4,2(a4)
    80005730:	faf71be3          	bne	a4,a5,800056e6 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005734:	00019517          	auipc	a0,0x19
    80005738:	9f450513          	addi	a0,a0,-1548 # 8001e128 <disk+0x2128>
    8000573c:	00002097          	auipc	ra,0x2
    80005740:	ab6080e7          	jalr	-1354(ra) # 800071f2 <release>
}
    80005744:	60e2                	ld	ra,24(sp)
    80005746:	6442                	ld	s0,16(sp)
    80005748:	64a2                	ld	s1,8(sp)
    8000574a:	6902                	ld	s2,0(sp)
    8000574c:	6105                	addi	sp,sp,32
    8000574e:	8082                	ret
      panic("virtio_disk_intr status");
    80005750:	00004517          	auipc	a0,0x4
    80005754:	07850513          	addi	a0,a0,120 # 800097c8 <syscalls+0x3f0>
    80005758:	00001097          	auipc	ra,0x1
    8000575c:	49c080e7          	jalr	1180(ra) # 80006bf4 <panic>

0000000080005760 <e1000_init>:
// called by pci_init().
// xregs is the memory address at which the
// e1000's registers are mapped.
void
e1000_init(uint32 *xregs)
{
    80005760:	7179                	addi	sp,sp,-48
    80005762:	f406                	sd	ra,40(sp)
    80005764:	f022                	sd	s0,32(sp)
    80005766:	ec26                	sd	s1,24(sp)
    80005768:	e84a                	sd	s2,16(sp)
    8000576a:	e44e                	sd	s3,8(sp)
    8000576c:	1800                	addi	s0,sp,48
    8000576e:	84aa                	mv	s1,a0
  int i;

  initlock(&e1000_rxlock, "rxe1000");
    80005770:	00004597          	auipc	a1,0x4
    80005774:	07058593          	addi	a1,a1,112 # 800097e0 <syscalls+0x408>
    80005778:	0001a517          	auipc	a0,0x1a
    8000577c:	88850513          	addi	a0,a0,-1912 # 8001f000 <e1000_rxlock>
    80005780:	00002097          	auipc	ra,0x2
    80005784:	92e080e7          	jalr	-1746(ra) # 800070ae <initlock>
  initlock(&e1000_txlock, "txe1000");
    80005788:	00004597          	auipc	a1,0x4
    8000578c:	06058593          	addi	a1,a1,96 # 800097e8 <syscalls+0x410>
    80005790:	0001a517          	auipc	a0,0x1a
    80005794:	88850513          	addi	a0,a0,-1912 # 8001f018 <e1000_txlock>
    80005798:	00002097          	auipc	ra,0x2
    8000579c:	916080e7          	jalr	-1770(ra) # 800070ae <initlock>

  regs = xregs;
    800057a0:	00005797          	auipc	a5,0x5
    800057a4:	8897b023          	sd	s1,-1920(a5) # 8000a020 <regs>

  // Reset the device
  regs[E1000_IMS] = 0; // disable interrupts
    800057a8:	0c04a823          	sw	zero,208(s1)
  regs[E1000_CTL] |= E1000_CTL_RST;
    800057ac:	409c                	lw	a5,0(s1)
    800057ae:	00400737          	lui	a4,0x400
    800057b2:	8fd9                	or	a5,a5,a4
    800057b4:	2781                	sext.w	a5,a5
    800057b6:	c09c                	sw	a5,0(s1)
  regs[E1000_IMS] = 0; // redisable interrupts
    800057b8:	0c04a823          	sw	zero,208(s1)
  __sync_synchronize();
    800057bc:	0ff0000f          	fence

  // [E1000 14.5] Transmit initialization
  memset(tx_ring, 0, sizeof(tx_ring));
    800057c0:	10000613          	li	a2,256
    800057c4:	4581                	li	a1,0
    800057c6:	0001a517          	auipc	a0,0x1a
    800057ca:	86a50513          	addi	a0,a0,-1942 # 8001f030 <tx_ring>
    800057ce:	ffffb097          	auipc	ra,0xffffb
    800057d2:	9aa080e7          	jalr	-1622(ra) # 80000178 <memset>
  for (i = 0; i < TX_RING_SIZE; i++) {
    800057d6:	0001a717          	auipc	a4,0x1a
    800057da:	86670713          	addi	a4,a4,-1946 # 8001f03c <tx_ring+0xc>
    800057de:	0001a797          	auipc	a5,0x1a
    800057e2:	95278793          	addi	a5,a5,-1710 # 8001f130 <tx_mbufs>
    800057e6:	0001a617          	auipc	a2,0x1a
    800057ea:	9ca60613          	addi	a2,a2,-1590 # 8001f1b0 <rx_ring>
    tx_ring[i].status = E1000_TXD_STAT_DD;
    800057ee:	4685                	li	a3,1
    800057f0:	00d70023          	sb	a3,0(a4)
    tx_mbufs[i] = 0;
    800057f4:	0007b023          	sd	zero,0(a5)
  for (i = 0; i < TX_RING_SIZE; i++) {
    800057f8:	0741                	addi	a4,a4,16
    800057fa:	07a1                	addi	a5,a5,8
    800057fc:	fec79ae3          	bne	a5,a2,800057f0 <e1000_init+0x90>
  }
  regs[E1000_TDBAL] = (uint64) tx_ring;
    80005800:	0001a717          	auipc	a4,0x1a
    80005804:	83070713          	addi	a4,a4,-2000 # 8001f030 <tx_ring>
    80005808:	00005797          	auipc	a5,0x5
    8000580c:	8187b783          	ld	a5,-2024(a5) # 8000a020 <regs>
    80005810:	6691                	lui	a3,0x4
    80005812:	97b6                	add	a5,a5,a3
    80005814:	80e7a023          	sw	a4,-2048(a5)
  if(sizeof(tx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_TDLEN] = sizeof(tx_ring);
    80005818:	10000713          	li	a4,256
    8000581c:	80e7a423          	sw	a4,-2040(a5)
  regs[E1000_TDH] = regs[E1000_TDT] = 0;
    80005820:	8007ac23          	sw	zero,-2024(a5)
    80005824:	8007a823          	sw	zero,-2032(a5)
  
  // [E1000 14.4] Receive initialization
  memset(rx_ring, 0, sizeof(rx_ring));
    80005828:	0001a917          	auipc	s2,0x1a
    8000582c:	98890913          	addi	s2,s2,-1656 # 8001f1b0 <rx_ring>
    80005830:	10000613          	li	a2,256
    80005834:	4581                	li	a1,0
    80005836:	854a                	mv	a0,s2
    80005838:	ffffb097          	auipc	ra,0xffffb
    8000583c:	940080e7          	jalr	-1728(ra) # 80000178 <memset>
  for (i = 0; i < RX_RING_SIZE; i++) {
    80005840:	0001a497          	auipc	s1,0x1a
    80005844:	a7048493          	addi	s1,s1,-1424 # 8001f2b0 <rx_mbufs>
    80005848:	0001a997          	auipc	s3,0x1a
    8000584c:	ae898993          	addi	s3,s3,-1304 # 8001f330 <lock>
    rx_mbufs[i] = mbufalloc(0);
    80005850:	4501                	li	a0,0
    80005852:	00000097          	auipc	ra,0x0
    80005856:	42a080e7          	jalr	1066(ra) # 80005c7c <mbufalloc>
    8000585a:	e088                	sd	a0,0(s1)
    if (!rx_mbufs[i])
    8000585c:	c945                	beqz	a0,8000590c <e1000_init+0x1ac>
      panic("e1000");
    rx_ring[i].addr = (uint64) rx_mbufs[i]->head;
    8000585e:	651c                	ld	a5,8(a0)
    80005860:	00f93023          	sd	a5,0(s2)
  for (i = 0; i < RX_RING_SIZE; i++) {
    80005864:	04a1                	addi	s1,s1,8
    80005866:	0941                	addi	s2,s2,16
    80005868:	ff3494e3          	bne	s1,s3,80005850 <e1000_init+0xf0>
  }
  regs[E1000_RDBAL] = (uint64) rx_ring;
    8000586c:	00004697          	auipc	a3,0x4
    80005870:	7b46b683          	ld	a3,1972(a3) # 8000a020 <regs>
    80005874:	0001a717          	auipc	a4,0x1a
    80005878:	93c70713          	addi	a4,a4,-1732 # 8001f1b0 <rx_ring>
    8000587c:	678d                	lui	a5,0x3
    8000587e:	97b6                	add	a5,a5,a3
    80005880:	80e7a023          	sw	a4,-2048(a5) # 2800 <_entry-0x7fffd800>
  if(sizeof(rx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_RDH] = 0;
    80005884:	8007a823          	sw	zero,-2032(a5)
  regs[E1000_RDT] = RX_RING_SIZE - 1;
    80005888:	473d                	li	a4,15
    8000588a:	80e7ac23          	sw	a4,-2024(a5)
  regs[E1000_RDLEN] = sizeof(rx_ring);
    8000588e:	10000713          	li	a4,256
    80005892:	80e7a423          	sw	a4,-2040(a5)

  // filter by qemu's MAC address, 52:54:00:12:34:56
  regs[E1000_RA] = 0x12005452;
    80005896:	6715                	lui	a4,0x5
    80005898:	00e68633          	add	a2,a3,a4
    8000589c:	120057b7          	lui	a5,0x12005
    800058a0:	4527879b          	addiw	a5,a5,1106
    800058a4:	40f62023          	sw	a5,1024(a2)
  regs[E1000_RA+1] = 0x5634 | (1<<31);
    800058a8:	800057b7          	lui	a5,0x80005
    800058ac:	6347879b          	addiw	a5,a5,1588
    800058b0:	40f62223          	sw	a5,1028(a2)
  // multicast table
  for (int i = 0; i < 4096/32; i++)
    800058b4:	20070793          	addi	a5,a4,512 # 5200 <_entry-0x7fffae00>
    800058b8:	97b6                	add	a5,a5,a3
    800058ba:	40070713          	addi	a4,a4,1024
    800058be:	9736                	add	a4,a4,a3
    regs[E1000_MTA + i] = 0;
    800058c0:	0007a023          	sw	zero,0(a5) # ffffffff80005000 <end+0xfffffffefffdda70>
  for (int i = 0; i < 4096/32; i++)
    800058c4:	0791                	addi	a5,a5,4
    800058c6:	fee79de3          	bne	a5,a4,800058c0 <e1000_init+0x160>

  // transmitter control bits.
  regs[E1000_TCTL] = E1000_TCTL_EN |  // enable
    800058ca:	000407b7          	lui	a5,0x40
    800058ce:	10a7879b          	addiw	a5,a5,266
    800058d2:	40f6a023          	sw	a5,1024(a3)
    E1000_TCTL_PSP |                  // pad short packets
    (0x10 << E1000_TCTL_CT_SHIFT) |   // collision stuff
    (0x40 << E1000_TCTL_COLD_SHIFT);
  regs[E1000_TIPG] = 10 | (8<<10) | (6<<20); // inter-pkt gap
    800058d6:	006027b7          	lui	a5,0x602
    800058da:	27a9                	addiw	a5,a5,10
    800058dc:	40f6a823          	sw	a5,1040(a3)

  // receiver control bits.
  regs[E1000_RCTL] = E1000_RCTL_EN | // enable receiver
    800058e0:	040087b7          	lui	a5,0x4008
    800058e4:	2789                	addiw	a5,a5,2
    800058e6:	10f6a023          	sw	a5,256(a3)
    E1000_RCTL_BAM |                 // enable broadcast
    E1000_RCTL_SZ_2048 |             // 2048-byte rx buffers
    E1000_RCTL_SECRC;                // strip CRC
  
  // ask e1000 for receive interrupts.
  regs[E1000_RDTR] = 0; // interrupt after every received packet (no timer)
    800058ea:	678d                	lui	a5,0x3
    800058ec:	97b6                	add	a5,a5,a3
    800058ee:	8207a023          	sw	zero,-2016(a5) # 2820 <_entry-0x7fffd7e0>
  regs[E1000_RADV] = 0; // interrupt after every packet (no timer)
    800058f2:	8207a623          	sw	zero,-2004(a5)
  regs[E1000_IMS] = (1 << 7); // RXDW -- Receiver Descriptor Write Back
    800058f6:	08000793          	li	a5,128
    800058fa:	0cf6a823          	sw	a5,208(a3)
}
    800058fe:	70a2                	ld	ra,40(sp)
    80005900:	7402                	ld	s0,32(sp)
    80005902:	64e2                	ld	s1,24(sp)
    80005904:	6942                	ld	s2,16(sp)
    80005906:	69a2                	ld	s3,8(sp)
    80005908:	6145                	addi	sp,sp,48
    8000590a:	8082                	ret
      panic("e1000");
    8000590c:	00004517          	auipc	a0,0x4
    80005910:	ee450513          	addi	a0,a0,-284 # 800097f0 <syscalls+0x418>
    80005914:	00001097          	auipc	ra,0x1
    80005918:	2e0080e7          	jalr	736(ra) # 80006bf4 <panic>

000000008000591c <e1000_transmit>:

int
e1000_transmit(struct mbuf *m)
{
    8000591c:	1101                	addi	sp,sp,-32
    8000591e:	ec06                	sd	ra,24(sp)
    80005920:	e822                	sd	s0,16(sp)
    80005922:	e426                	sd	s1,8(sp)
    80005924:	e04a                	sd	s2,0(sp)
    80005926:	1000                	addi	s0,sp,32
    80005928:	892a                	mv	s2,a0
    // Your code here.
    //
    // the mbuf contains an ethernet frame; program it into
    // the TX descriptor ring so that the e1000 sends it. Stash
    // a pointer so that it can be freed after sending.
    acquire(&e1000_txlock);
    8000592a:	00019517          	auipc	a0,0x19
    8000592e:	6ee50513          	addi	a0,a0,1774 # 8001f018 <e1000_txlock>
    80005932:	00002097          	auipc	ra,0x2
    80005936:	80c080e7          	jalr	-2036(ra) # 8000713e <acquire>
    uint32 tail = regs[E1000_TDT];
    8000593a:	00004797          	auipc	a5,0x4
    8000593e:	6e67b783          	ld	a5,1766(a5) # 8000a020 <regs>
    80005942:	6711                	lui	a4,0x4
    80005944:	97ba                	add	a5,a5,a4
    80005946:	8187a783          	lw	a5,-2024(a5)
    8000594a:	0007849b          	sext.w	s1,a5
    if(!(tx_ring[tail].status & E1000_TXD_STAT_DD)){
    8000594e:	1782                	slli	a5,a5,0x20
    80005950:	9381                	srli	a5,a5,0x20
    80005952:	0792                	slli	a5,a5,0x4
    80005954:	00019717          	auipc	a4,0x19
    80005958:	6ac70713          	addi	a4,a4,1708 # 8001f000 <e1000_rxlock>
    8000595c:	97ba                	add	a5,a5,a4
    8000595e:	03c7c783          	lbu	a5,60(a5)
    80005962:	8b85                	andi	a5,a5,1
    80005964:	c3d9                	beqz	a5,800059ea <e1000_transmit+0xce>
        release(&e1000_txlock);
        return -1;
    }
    if(tx_mbufs[tail])
    80005966:	02049793          	slli	a5,s1,0x20
    8000596a:	9381                	srli	a5,a5,0x20
    8000596c:	00379713          	slli	a4,a5,0x3
    80005970:	00019797          	auipc	a5,0x19
    80005974:	69078793          	addi	a5,a5,1680 # 8001f000 <e1000_rxlock>
    80005978:	97ba                	add	a5,a5,a4
    8000597a:	1307b503          	ld	a0,304(a5)
    8000597e:	c509                	beqz	a0,80005988 <e1000_transmit+0x6c>
        mbuffree(tx_mbufs[tail]);
    80005980:	00000097          	auipc	ra,0x0
    80005984:	354080e7          	jalr	852(ra) # 80005cd4 <mbuffree>
    tx_ring[tail].addr = (uint64)m->head;
    80005988:	00019717          	auipc	a4,0x19
    8000598c:	67870713          	addi	a4,a4,1656 # 8001f000 <e1000_rxlock>
    80005990:	02049693          	slli	a3,s1,0x20
    80005994:	9281                	srli	a3,a3,0x20
    80005996:	00469793          	slli	a5,a3,0x4
    8000599a:	97ba                	add	a5,a5,a4
    8000599c:	00893603          	ld	a2,8(s2)
    800059a0:	fb90                	sd	a2,48(a5)
    tx_ring[tail].length = (uint16)m->len;
    800059a2:	01092603          	lw	a2,16(s2)
    800059a6:	02c79c23          	sh	a2,56(a5)
    tx_ring[tail].cmd = E1000_TXD_CMD_RS | E1000_TXD_CMD_EOP;
    800059aa:	4625                	li	a2,9
    800059ac:	02c78da3          	sb	a2,59(a5)
    tx_mbufs[tail] = m;
    800059b0:	068e                	slli	a3,a3,0x3
    800059b2:	9736                	add	a4,a4,a3
    800059b4:	13273823          	sd	s2,304(a4)
    regs[E1000_TDT] = (tail+1) % TX_RING_SIZE;
    800059b8:	2485                	addiw	s1,s1,1
    800059ba:	88bd                	andi	s1,s1,15
    800059bc:	00004797          	auipc	a5,0x4
    800059c0:	6647b783          	ld	a5,1636(a5) # 8000a020 <regs>
    800059c4:	6711                	lui	a4,0x4
    800059c6:	97ba                	add	a5,a5,a4
    800059c8:	8097ac23          	sw	s1,-2024(a5)
    release(&e1000_txlock);
    800059cc:	00019517          	auipc	a0,0x19
    800059d0:	64c50513          	addi	a0,a0,1612 # 8001f018 <e1000_txlock>
    800059d4:	00002097          	auipc	ra,0x2
    800059d8:	81e080e7          	jalr	-2018(ra) # 800071f2 <release>
    return 0;
    800059dc:	4501                	li	a0,0
}
    800059de:	60e2                	ld	ra,24(sp)
    800059e0:	6442                	ld	s0,16(sp)
    800059e2:	64a2                	ld	s1,8(sp)
    800059e4:	6902                	ld	s2,0(sp)
    800059e6:	6105                	addi	sp,sp,32
    800059e8:	8082                	ret
        release(&e1000_txlock);
    800059ea:	00019517          	auipc	a0,0x19
    800059ee:	62e50513          	addi	a0,a0,1582 # 8001f018 <e1000_txlock>
    800059f2:	00002097          	auipc	ra,0x2
    800059f6:	800080e7          	jalr	-2048(ra) # 800071f2 <release>
        return -1;
    800059fa:	557d                	li	a0,-1
    800059fc:	b7cd                	j	800059de <e1000_transmit+0xc2>

00000000800059fe <e1000_intr>:
    release(&e1000_rxlock);
}

void
e1000_intr(void)
{
    800059fe:	7179                	addi	sp,sp,-48
    80005a00:	f406                	sd	ra,40(sp)
    80005a02:	f022                	sd	s0,32(sp)
    80005a04:	ec26                	sd	s1,24(sp)
    80005a06:	e84a                	sd	s2,16(sp)
    80005a08:	e44e                	sd	s3,8(sp)
    80005a0a:	e052                	sd	s4,0(sp)
    80005a0c:	1800                	addi	s0,sp,48
  // tell the e1000 we've seen this interrupt;
  // without this the e1000 won't raise any
  // further interrupts.
  regs[E1000_ICR] = 0xffffffff;
    80005a0e:	00004497          	auipc	s1,0x4
    80005a12:	61248493          	addi	s1,s1,1554 # 8000a020 <regs>
    80005a16:	609c                	ld	a5,0(s1)
    80005a18:	577d                	li	a4,-1
    80005a1a:	0ce7a023          	sw	a4,192(a5)
    acquire(&e1000_rxlock);
    80005a1e:	00019917          	auipc	s2,0x19
    80005a22:	5e290913          	addi	s2,s2,1506 # 8001f000 <e1000_rxlock>
    80005a26:	854a                	mv	a0,s2
    80005a28:	00001097          	auipc	ra,0x1
    80005a2c:	716080e7          	jalr	1814(ra) # 8000713e <acquire>
    uint32 tail = regs[E1000_RDT];
    80005a30:	609c                	ld	a5,0(s1)
    80005a32:	670d                	lui	a4,0x3
    80005a34:	97ba                	add	a5,a5,a4
    80005a36:	8187a783          	lw	a5,-2024(a5)
    80005a3a:	0007871b          	sext.w	a4,a5
    uint32 curr = (tail + 1) % RX_RING_SIZE;
    80005a3e:	2785                	addiw	a5,a5,1
    80005a40:	00f7f493          	andi	s1,a5,15
        if(!(rx_ring[curr].status & E1000_RXD_STAT_DD)){
    80005a44:	00449793          	slli	a5,s1,0x4
    80005a48:	97ca                	add	a5,a5,s2
    80005a4a:	1bc7c783          	lbu	a5,444(a5)
    80005a4e:	8b85                	andi	a5,a5,1
    80005a50:	cfa1                	beqz	a5,80005aa8 <e1000_intr+0xaa>
        rx_mbufs[curr]->len = rx_ring[curr].length;
    80005a52:	8a4a                	mv	s4,s2
    80005a54:	00349993          	slli	s3,s1,0x3
    80005a58:	99d2                	add	s3,s3,s4
    80005a5a:	2b09b783          	ld	a5,688(s3)
    80005a5e:	00449913          	slli	s2,s1,0x4
    80005a62:	9952                	add	s2,s2,s4
    80005a64:	1b895703          	lhu	a4,440(s2)
    80005a68:	cb98                	sw	a4,16(a5)
        net_rx(rx_mbufs[curr]);
    80005a6a:	2b09b503          	ld	a0,688(s3)
    80005a6e:	00000097          	auipc	ra,0x0
    80005a72:	3da080e7          	jalr	986(ra) # 80005e48 <net_rx>
        newmbuf = mbufalloc(0);
    80005a76:	4501                	li	a0,0
    80005a78:	00000097          	auipc	ra,0x0
    80005a7c:	204080e7          	jalr	516(ra) # 80005c7c <mbufalloc>
        rx_mbufs[curr] = newmbuf;
    80005a80:	2aa9b823          	sd	a0,688(s3)
        rx_ring[curr].addr = (uint64)newmbuf->head;
    80005a84:	651c                	ld	a5,8(a0)
    80005a86:	1af93823          	sd	a5,432(s2)
        rx_ring[curr].status = 0;
    80005a8a:	1a090e23          	sb	zero,444(s2)
        curr = (curr + 1) % RX_RING_SIZE;
    80005a8e:	0014879b          	addiw	a5,s1,1
    80005a92:	0004871b          	sext.w	a4,s1
    80005a96:	00f7f493          	andi	s1,a5,15
        if(!(rx_ring[curr].status & E1000_RXD_STAT_DD)){
    80005a9a:	00449793          	slli	a5,s1,0x4
    80005a9e:	97d2                	add	a5,a5,s4
    80005aa0:	1bc7c783          	lbu	a5,444(a5)
    80005aa4:	8b85                	andi	a5,a5,1
    80005aa6:	f7dd                	bnez	a5,80005a54 <e1000_intr+0x56>
    regs[E1000_RDT] = tail;
    80005aa8:	00004797          	auipc	a5,0x4
    80005aac:	5787b783          	ld	a5,1400(a5) # 8000a020 <regs>
    80005ab0:	668d                	lui	a3,0x3
    80005ab2:	97b6                	add	a5,a5,a3
    80005ab4:	80e7ac23          	sw	a4,-2024(a5)
    release(&e1000_rxlock);
    80005ab8:	00019517          	auipc	a0,0x19
    80005abc:	54850513          	addi	a0,a0,1352 # 8001f000 <e1000_rxlock>
    80005ac0:	00001097          	auipc	ra,0x1
    80005ac4:	732080e7          	jalr	1842(ra) # 800071f2 <release>

  e1000_recv();
}
    80005ac8:	70a2                	ld	ra,40(sp)
    80005aca:	7402                	ld	s0,32(sp)
    80005acc:	64e2                	ld	s1,24(sp)
    80005ace:	6942                	ld	s2,16(sp)
    80005ad0:	69a2                	ld	s3,8(sp)
    80005ad2:	6a02                	ld	s4,0(sp)
    80005ad4:	6145                	addi	sp,sp,48
    80005ad6:	8082                	ret

0000000080005ad8 <in_cksum>:

// This code is lifted from FreeBSD's ping.c, and is copyright by the Regents
// of the University of California.
static unsigned short
in_cksum(const unsigned char *addr, int len)
{
    80005ad8:	1101                	addi	sp,sp,-32
    80005ada:	ec22                	sd	s0,24(sp)
    80005adc:	1000                	addi	s0,sp,32
  int nleft = len;
  const unsigned short *w = (const unsigned short *)addr;
  unsigned int sum = 0;
  unsigned short answer = 0;
    80005ade:	fe041723          	sh	zero,-18(s0)
  /*
   * Our algorithm is simple, using a 32 bit accumulator (sum), we add
   * sequential 16 bit words to it, and at the end, fold back all the
   * carry bits from the top 16 bits into the lower 16 bits.
   */
  while (nleft > 1)  {
    80005ae2:	4785                	li	a5,1
    80005ae4:	04b7d963          	bge	a5,a1,80005b36 <in_cksum+0x5e>
    80005ae8:	ffe5879b          	addiw	a5,a1,-2
    80005aec:	0017d61b          	srliw	a2,a5,0x1
    80005af0:	0017d71b          	srliw	a4,a5,0x1
    80005af4:	0705                	addi	a4,a4,1
    80005af6:	0706                	slli	a4,a4,0x1
    80005af8:	972a                	add	a4,a4,a0
  unsigned int sum = 0;
    80005afa:	4781                	li	a5,0
    sum += *w++;
    80005afc:	0509                	addi	a0,a0,2
    80005afe:	ffe55683          	lhu	a3,-2(a0)
    80005b02:	9fb5                	addw	a5,a5,a3
  while (nleft > 1)  {
    80005b04:	fee51ce3          	bne	a0,a4,80005afc <in_cksum+0x24>
    80005b08:	35f9                	addiw	a1,a1,-2
    80005b0a:	0016169b          	slliw	a3,a2,0x1
    80005b0e:	9d95                	subw	a1,a1,a3
    nleft -= 2;
  }

  /* mop up an odd byte, if necessary */
  if (nleft == 1) {
    80005b10:	4685                	li	a3,1
    80005b12:	02d58563          	beq	a1,a3,80005b3c <in_cksum+0x64>
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    sum += answer;
  }

  /* add back carry outs from top 16 bits to low 16 bits */
  sum = (sum & 0xffff) + (sum >> 16);
    80005b16:	03079513          	slli	a0,a5,0x30
    80005b1a:	9141                	srli	a0,a0,0x30
    80005b1c:	0107d79b          	srliw	a5,a5,0x10
    80005b20:	9fa9                	addw	a5,a5,a0
  sum += (sum >> 16);
    80005b22:	0107d51b          	srliw	a0,a5,0x10
  /* guaranteed now that the lower 16 bits of sum are correct */

  answer = ~sum; /* truncate to 16 bits */
    80005b26:	9d3d                	addw	a0,a0,a5
    80005b28:	fff54513          	not	a0,a0
  return answer;
}
    80005b2c:	1542                	slli	a0,a0,0x30
    80005b2e:	9141                	srli	a0,a0,0x30
    80005b30:	6462                	ld	s0,24(sp)
    80005b32:	6105                	addi	sp,sp,32
    80005b34:	8082                	ret
  const unsigned short *w = (const unsigned short *)addr;
    80005b36:	872a                	mv	a4,a0
  unsigned int sum = 0;
    80005b38:	4781                	li	a5,0
    80005b3a:	bfd9                	j	80005b10 <in_cksum+0x38>
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    80005b3c:	00074703          	lbu	a4,0(a4) # 3000 <_entry-0x7fffd000>
    80005b40:	fee40723          	sb	a4,-18(s0)
    sum += answer;
    80005b44:	fee45703          	lhu	a4,-18(s0)
    80005b48:	9fb9                	addw	a5,a5,a4
    80005b4a:	b7f1                	j	80005b16 <in_cksum+0x3e>

0000000080005b4c <mbufpull>:
{
    80005b4c:	1141                	addi	sp,sp,-16
    80005b4e:	e422                	sd	s0,8(sp)
    80005b50:	0800                	addi	s0,sp,16
    80005b52:	87aa                	mv	a5,a0
  char *tmp = m->head;
    80005b54:	6508                	ld	a0,8(a0)
  if (m->len < len)
    80005b56:	4b98                	lw	a4,16(a5)
    80005b58:	00b76b63          	bltu	a4,a1,80005b6e <mbufpull+0x22>
  m->len -= len;
    80005b5c:	9f0d                	subw	a4,a4,a1
    80005b5e:	cb98                	sw	a4,16(a5)
  m->head += len;
    80005b60:	1582                	slli	a1,a1,0x20
    80005b62:	9181                	srli	a1,a1,0x20
    80005b64:	95aa                	add	a1,a1,a0
    80005b66:	e78c                	sd	a1,8(a5)
}
    80005b68:	6422                	ld	s0,8(sp)
    80005b6a:	0141                	addi	sp,sp,16
    80005b6c:	8082                	ret
    return 0;
    80005b6e:	4501                	li	a0,0
    80005b70:	bfe5                	j	80005b68 <mbufpull+0x1c>

0000000080005b72 <mbufpush>:
{
    80005b72:	87aa                	mv	a5,a0
  m->head -= len;
    80005b74:	02059713          	slli	a4,a1,0x20
    80005b78:	9301                	srli	a4,a4,0x20
    80005b7a:	6508                	ld	a0,8(a0)
    80005b7c:	8d19                	sub	a0,a0,a4
    80005b7e:	e788                	sd	a0,8(a5)
  if (m->head < m->buf)
    80005b80:	01478713          	addi	a4,a5,20
    80005b84:	00e56663          	bltu	a0,a4,80005b90 <mbufpush+0x1e>
  m->len += len;
    80005b88:	4b98                	lw	a4,16(a5)
    80005b8a:	9db9                	addw	a1,a1,a4
    80005b8c:	cb8c                	sw	a1,16(a5)
}
    80005b8e:	8082                	ret
{
    80005b90:	1141                	addi	sp,sp,-16
    80005b92:	e406                	sd	ra,8(sp)
    80005b94:	e022                	sd	s0,0(sp)
    80005b96:	0800                	addi	s0,sp,16
    panic("mbufpush");
    80005b98:	00004517          	auipc	a0,0x4
    80005b9c:	c6050513          	addi	a0,a0,-928 # 800097f8 <syscalls+0x420>
    80005ba0:	00001097          	auipc	ra,0x1
    80005ba4:	054080e7          	jalr	84(ra) # 80006bf4 <panic>

0000000080005ba8 <net_tx_eth>:

// sends an ethernet packet
static void
net_tx_eth(struct mbuf *m, uint16 ethtype)
{
    80005ba8:	7179                	addi	sp,sp,-48
    80005baa:	f406                	sd	ra,40(sp)
    80005bac:	f022                	sd	s0,32(sp)
    80005bae:	ec26                	sd	s1,24(sp)
    80005bb0:	e84a                	sd	s2,16(sp)
    80005bb2:	e44e                	sd	s3,8(sp)
    80005bb4:	1800                	addi	s0,sp,48
    80005bb6:	89aa                	mv	s3,a0
    80005bb8:	892e                	mv	s2,a1
  struct eth *ethhdr;

  ethhdr = mbufpushhdr(m, *ethhdr);
    80005bba:	45b9                	li	a1,14
    80005bbc:	00000097          	auipc	ra,0x0
    80005bc0:	fb6080e7          	jalr	-74(ra) # 80005b72 <mbufpush>
    80005bc4:	84aa                	mv	s1,a0
  memmove(ethhdr->shost, local_mac, ETHADDR_LEN);
    80005bc6:	4619                	li	a2,6
    80005bc8:	00004597          	auipc	a1,0x4
    80005bcc:	ce858593          	addi	a1,a1,-792 # 800098b0 <local_mac>
    80005bd0:	0519                	addi	a0,a0,6
    80005bd2:	ffffa097          	auipc	ra,0xffffa
    80005bd6:	606080e7          	jalr	1542(ra) # 800001d8 <memmove>
  // In a real networking stack, dhost would be set to the address discovered
  // through ARP. Because we don't support enough of the ARP protocol, set it
  // to broadcast instead.
  memmove(ethhdr->dhost, broadcast_mac, ETHADDR_LEN);
    80005bda:	4619                	li	a2,6
    80005bdc:	00004597          	auipc	a1,0x4
    80005be0:	ccc58593          	addi	a1,a1,-820 # 800098a8 <broadcast_mac>
    80005be4:	8526                	mv	a0,s1
    80005be6:	ffffa097          	auipc	ra,0xffffa
    80005bea:	5f2080e7          	jalr	1522(ra) # 800001d8 <memmove>
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
    80005bee:	0089579b          	srliw	a5,s2,0x8
  ethhdr->type = htons(ethtype);
    80005bf2:	00f48623          	sb	a5,12(s1)
    80005bf6:	012486a3          	sb	s2,13(s1)
  if (e1000_transmit(m)) {
    80005bfa:	854e                	mv	a0,s3
    80005bfc:	00000097          	auipc	ra,0x0
    80005c00:	d20080e7          	jalr	-736(ra) # 8000591c <e1000_transmit>
    80005c04:	e901                	bnez	a0,80005c14 <net_tx_eth+0x6c>
    mbuffree(m);
  }
}
    80005c06:	70a2                	ld	ra,40(sp)
    80005c08:	7402                	ld	s0,32(sp)
    80005c0a:	64e2                	ld	s1,24(sp)
    80005c0c:	6942                	ld	s2,16(sp)
    80005c0e:	69a2                	ld	s3,8(sp)
    80005c10:	6145                	addi	sp,sp,48
    80005c12:	8082                	ret
  kfree(m);
    80005c14:	854e                	mv	a0,s3
    80005c16:	ffffa097          	auipc	ra,0xffffa
    80005c1a:	406080e7          	jalr	1030(ra) # 8000001c <kfree>
}
    80005c1e:	b7e5                	j	80005c06 <net_tx_eth+0x5e>

0000000080005c20 <mbufput>:
{
    80005c20:	87aa                	mv	a5,a0
  char *tmp = m->head + m->len;
    80005c22:	4918                	lw	a4,16(a0)
    80005c24:	02071693          	slli	a3,a4,0x20
    80005c28:	9281                	srli	a3,a3,0x20
    80005c2a:	6508                	ld	a0,8(a0)
    80005c2c:	9536                	add	a0,a0,a3
  m->len += len;
    80005c2e:	9f2d                	addw	a4,a4,a1
    80005c30:	0007069b          	sext.w	a3,a4
    80005c34:	cb98                	sw	a4,16(a5)
  if (m->len > MBUF_SIZE)
    80005c36:	6785                	lui	a5,0x1
    80005c38:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    80005c3c:	00d7e363          	bltu	a5,a3,80005c42 <mbufput+0x22>
}
    80005c40:	8082                	ret
{
    80005c42:	1141                	addi	sp,sp,-16
    80005c44:	e406                	sd	ra,8(sp)
    80005c46:	e022                	sd	s0,0(sp)
    80005c48:	0800                	addi	s0,sp,16
    panic("mbufput");
    80005c4a:	00004517          	auipc	a0,0x4
    80005c4e:	bbe50513          	addi	a0,a0,-1090 # 80009808 <syscalls+0x430>
    80005c52:	00001097          	auipc	ra,0x1
    80005c56:	fa2080e7          	jalr	-94(ra) # 80006bf4 <panic>

0000000080005c5a <mbuftrim>:
{
    80005c5a:	1141                	addi	sp,sp,-16
    80005c5c:	e422                	sd	s0,8(sp)
    80005c5e:	0800                	addi	s0,sp,16
  if (len > m->len)
    80005c60:	491c                	lw	a5,16(a0)
    80005c62:	00b7eb63          	bltu	a5,a1,80005c78 <mbuftrim+0x1e>
  m->len -= len;
    80005c66:	9f8d                	subw	a5,a5,a1
    80005c68:	c91c                	sw	a5,16(a0)
  return m->head + m->len;
    80005c6a:	1782                	slli	a5,a5,0x20
    80005c6c:	9381                	srli	a5,a5,0x20
    80005c6e:	6508                	ld	a0,8(a0)
    80005c70:	953e                	add	a0,a0,a5
}
    80005c72:	6422                	ld	s0,8(sp)
    80005c74:	0141                	addi	sp,sp,16
    80005c76:	8082                	ret
    return 0;
    80005c78:	4501                	li	a0,0
    80005c7a:	bfe5                	j	80005c72 <mbuftrim+0x18>

0000000080005c7c <mbufalloc>:
{
    80005c7c:	1101                	addi	sp,sp,-32
    80005c7e:	ec06                	sd	ra,24(sp)
    80005c80:	e822                	sd	s0,16(sp)
    80005c82:	e426                	sd	s1,8(sp)
    80005c84:	e04a                	sd	s2,0(sp)
    80005c86:	1000                	addi	s0,sp,32
  if (headroom > MBUF_SIZE)
    80005c88:	6785                	lui	a5,0x1
    80005c8a:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    return 0;
    80005c8e:	4901                	li	s2,0
  if (headroom > MBUF_SIZE)
    80005c90:	02a7eb63          	bltu	a5,a0,80005cc6 <mbufalloc+0x4a>
    80005c94:	84aa                	mv	s1,a0
  m = kalloc();
    80005c96:	ffffa097          	auipc	ra,0xffffa
    80005c9a:	482080e7          	jalr	1154(ra) # 80000118 <kalloc>
    80005c9e:	892a                	mv	s2,a0
  if (m == 0)
    80005ca0:	c11d                	beqz	a0,80005cc6 <mbufalloc+0x4a>
  m->next = 0;
    80005ca2:	00053023          	sd	zero,0(a0)
  m->head = (char *)m->buf + headroom;
    80005ca6:	0551                	addi	a0,a0,20
    80005ca8:	1482                	slli	s1,s1,0x20
    80005caa:	9081                	srli	s1,s1,0x20
    80005cac:	94aa                	add	s1,s1,a0
    80005cae:	00993423          	sd	s1,8(s2)
  m->len = 0;
    80005cb2:	00092823          	sw	zero,16(s2)
  memset(m->buf, 0, sizeof(m->buf));
    80005cb6:	6605                	lui	a2,0x1
    80005cb8:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    80005cbc:	4581                	li	a1,0
    80005cbe:	ffffa097          	auipc	ra,0xffffa
    80005cc2:	4ba080e7          	jalr	1210(ra) # 80000178 <memset>
}
    80005cc6:	854a                	mv	a0,s2
    80005cc8:	60e2                	ld	ra,24(sp)
    80005cca:	6442                	ld	s0,16(sp)
    80005ccc:	64a2                	ld	s1,8(sp)
    80005cce:	6902                	ld	s2,0(sp)
    80005cd0:	6105                	addi	sp,sp,32
    80005cd2:	8082                	ret

0000000080005cd4 <mbuffree>:
{
    80005cd4:	1141                	addi	sp,sp,-16
    80005cd6:	e406                	sd	ra,8(sp)
    80005cd8:	e022                	sd	s0,0(sp)
    80005cda:	0800                	addi	s0,sp,16
  kfree(m);
    80005cdc:	ffffa097          	auipc	ra,0xffffa
    80005ce0:	340080e7          	jalr	832(ra) # 8000001c <kfree>
}
    80005ce4:	60a2                	ld	ra,8(sp)
    80005ce6:	6402                	ld	s0,0(sp)
    80005ce8:	0141                	addi	sp,sp,16
    80005cea:	8082                	ret

0000000080005cec <mbufq_pushtail>:
{
    80005cec:	1141                	addi	sp,sp,-16
    80005cee:	e422                	sd	s0,8(sp)
    80005cf0:	0800                	addi	s0,sp,16
  m->next = 0;
    80005cf2:	0005b023          	sd	zero,0(a1)
  if (!q->head){
    80005cf6:	611c                	ld	a5,0(a0)
    80005cf8:	c799                	beqz	a5,80005d06 <mbufq_pushtail+0x1a>
  q->tail->next = m;
    80005cfa:	651c                	ld	a5,8(a0)
    80005cfc:	e38c                	sd	a1,0(a5)
  q->tail = m;
    80005cfe:	e50c                	sd	a1,8(a0)
}
    80005d00:	6422                	ld	s0,8(sp)
    80005d02:	0141                	addi	sp,sp,16
    80005d04:	8082                	ret
    q->head = q->tail = m;
    80005d06:	e50c                	sd	a1,8(a0)
    80005d08:	e10c                	sd	a1,0(a0)
    return;
    80005d0a:	bfdd                	j	80005d00 <mbufq_pushtail+0x14>

0000000080005d0c <mbufq_pophead>:
{
    80005d0c:	1141                	addi	sp,sp,-16
    80005d0e:	e422                	sd	s0,8(sp)
    80005d10:	0800                	addi	s0,sp,16
    80005d12:	87aa                	mv	a5,a0
  struct mbuf *head = q->head;
    80005d14:	6108                	ld	a0,0(a0)
  if (!head)
    80005d16:	c119                	beqz	a0,80005d1c <mbufq_pophead+0x10>
  q->head = head->next;
    80005d18:	6118                	ld	a4,0(a0)
    80005d1a:	e398                	sd	a4,0(a5)
}
    80005d1c:	6422                	ld	s0,8(sp)
    80005d1e:	0141                	addi	sp,sp,16
    80005d20:	8082                	ret

0000000080005d22 <mbufq_empty>:
{
    80005d22:	1141                	addi	sp,sp,-16
    80005d24:	e422                	sd	s0,8(sp)
    80005d26:	0800                	addi	s0,sp,16
  return q->head == 0;
    80005d28:	6108                	ld	a0,0(a0)
}
    80005d2a:	00153513          	seqz	a0,a0
    80005d2e:	6422                	ld	s0,8(sp)
    80005d30:	0141                	addi	sp,sp,16
    80005d32:	8082                	ret

0000000080005d34 <mbufq_init>:
{
    80005d34:	1141                	addi	sp,sp,-16
    80005d36:	e422                	sd	s0,8(sp)
    80005d38:	0800                	addi	s0,sp,16
  q->head = 0;
    80005d3a:	00053023          	sd	zero,0(a0)
}
    80005d3e:	6422                	ld	s0,8(sp)
    80005d40:	0141                	addi	sp,sp,16
    80005d42:	8082                	ret

0000000080005d44 <net_tx_udp>:

// sends a UDP packet
void
net_tx_udp(struct mbuf *m, uint32 dip,
           uint16 sport, uint16 dport)
{
    80005d44:	7179                	addi	sp,sp,-48
    80005d46:	f406                	sd	ra,40(sp)
    80005d48:	f022                	sd	s0,32(sp)
    80005d4a:	ec26                	sd	s1,24(sp)
    80005d4c:	e84a                	sd	s2,16(sp)
    80005d4e:	e44e                	sd	s3,8(sp)
    80005d50:	e052                	sd	s4,0(sp)
    80005d52:	1800                	addi	s0,sp,48
    80005d54:	8a2a                	mv	s4,a0
    80005d56:	892e                	mv	s2,a1
    80005d58:	89b2                	mv	s3,a2
    80005d5a:	84b6                	mv	s1,a3
  struct udp *udphdr;

  // put the UDP header
  udphdr = mbufpushhdr(m, *udphdr);
    80005d5c:	45a1                	li	a1,8
    80005d5e:	00000097          	auipc	ra,0x0
    80005d62:	e14080e7          	jalr	-492(ra) # 80005b72 <mbufpush>
    80005d66:	0089d61b          	srliw	a2,s3,0x8
    80005d6a:	0089999b          	slliw	s3,s3,0x8
    80005d6e:	00c9e9b3          	or	s3,s3,a2
  udphdr->sport = htons(sport);
    80005d72:	01351023          	sh	s3,0(a0)
    80005d76:	0084d69b          	srliw	a3,s1,0x8
    80005d7a:	0084949b          	slliw	s1,s1,0x8
    80005d7e:	8cd5                	or	s1,s1,a3
  udphdr->dport = htons(dport);
    80005d80:	00951123          	sh	s1,2(a0)
  udphdr->ulen = htons(m->len);
    80005d84:	010a2783          	lw	a5,16(s4)
    80005d88:	0087d713          	srli	a4,a5,0x8
    80005d8c:	0087979b          	slliw	a5,a5,0x8
    80005d90:	0ff77713          	andi	a4,a4,255
    80005d94:	8fd9                	or	a5,a5,a4
    80005d96:	00f51223          	sh	a5,4(a0)
  udphdr->sum = 0; // zero means no checksum is provided
    80005d9a:	00051323          	sh	zero,6(a0)
  iphdr = mbufpushhdr(m, *iphdr);
    80005d9e:	45d1                	li	a1,20
    80005da0:	8552                	mv	a0,s4
    80005da2:	00000097          	auipc	ra,0x0
    80005da6:	dd0080e7          	jalr	-560(ra) # 80005b72 <mbufpush>
    80005daa:	84aa                	mv	s1,a0
  memset(iphdr, 0, sizeof(*iphdr));
    80005dac:	4651                	li	a2,20
    80005dae:	4581                	li	a1,0
    80005db0:	ffffa097          	auipc	ra,0xffffa
    80005db4:	3c8080e7          	jalr	968(ra) # 80000178 <memset>
  iphdr->ip_vhl = (4 << 4) | (20 >> 2);
    80005db8:	04500793          	li	a5,69
    80005dbc:	00f48023          	sb	a5,0(s1)
  iphdr->ip_p = proto;
    80005dc0:	47c5                	li	a5,17
    80005dc2:	00f484a3          	sb	a5,9(s1)
  iphdr->ip_src = htonl(local_ip);
    80005dc6:	0f0207b7          	lui	a5,0xf020
    80005dca:	27a9                	addiw	a5,a5,10
    80005dcc:	c4dc                	sw	a5,12(s1)
          ((val & 0xff00U) >> 8));
}

static inline uint32 bswapl(uint32 val)
{
  return (((val & 0x000000ffUL) << 24) |
    80005dce:	0189179b          	slliw	a5,s2,0x18
          ((val & 0x0000ff00UL) << 8) |
          ((val & 0x00ff0000UL) >> 8) |
          ((val & 0xff000000UL) >> 24));
    80005dd2:	0189571b          	srliw	a4,s2,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005dd6:	8fd9                	or	a5,a5,a4
          ((val & 0x0000ff00UL) << 8) |
    80005dd8:	0089171b          	slliw	a4,s2,0x8
    80005ddc:	00ff06b7          	lui	a3,0xff0
    80005de0:	8f75                	and	a4,a4,a3
          ((val & 0x00ff0000UL) >> 8) |
    80005de2:	8fd9                	or	a5,a5,a4
    80005de4:	0089591b          	srliw	s2,s2,0x8
    80005de8:	65c1                	lui	a1,0x10
    80005dea:	f0058593          	addi	a1,a1,-256 # ff00 <_entry-0x7fff0100>
    80005dee:	00b97933          	and	s2,s2,a1
    80005df2:	0127e933          	or	s2,a5,s2
  iphdr->ip_dst = htonl(dip);
    80005df6:	0124a823          	sw	s2,16(s1)
  iphdr->ip_len = htons(m->len);
    80005dfa:	010a2783          	lw	a5,16(s4)
  return (((val & 0x00ffU) << 8) |
    80005dfe:	0087d713          	srli	a4,a5,0x8
    80005e02:	0087979b          	slliw	a5,a5,0x8
    80005e06:	0ff77713          	andi	a4,a4,255
    80005e0a:	8fd9                	or	a5,a5,a4
    80005e0c:	00f49123          	sh	a5,2(s1)
  iphdr->ip_ttl = 100;
    80005e10:	06400793          	li	a5,100
    80005e14:	00f48423          	sb	a5,8(s1)
  iphdr->ip_sum = in_cksum((unsigned char *)iphdr, sizeof(*iphdr));
    80005e18:	45d1                	li	a1,20
    80005e1a:	8526                	mv	a0,s1
    80005e1c:	00000097          	auipc	ra,0x0
    80005e20:	cbc080e7          	jalr	-836(ra) # 80005ad8 <in_cksum>
    80005e24:	00a49523          	sh	a0,10(s1)
  net_tx_eth(m, ETHTYPE_IP);
    80005e28:	6585                	lui	a1,0x1
    80005e2a:	80058593          	addi	a1,a1,-2048 # 800 <_entry-0x7ffff800>
    80005e2e:	8552                	mv	a0,s4
    80005e30:	00000097          	auipc	ra,0x0
    80005e34:	d78080e7          	jalr	-648(ra) # 80005ba8 <net_tx_eth>

  // now on to the IP layer
  net_tx_ip(m, IPPROTO_UDP, dip);
}
    80005e38:	70a2                	ld	ra,40(sp)
    80005e3a:	7402                	ld	s0,32(sp)
    80005e3c:	64e2                	ld	s1,24(sp)
    80005e3e:	6942                	ld	s2,16(sp)
    80005e40:	69a2                	ld	s3,8(sp)
    80005e42:	6a02                	ld	s4,0(sp)
    80005e44:	6145                	addi	sp,sp,48
    80005e46:	8082                	ret

0000000080005e48 <net_rx>:
}

// called by e1000 driver's interrupt handler to deliver a packet to the
// networking stack
void net_rx(struct mbuf *m)
{
    80005e48:	715d                	addi	sp,sp,-80
    80005e4a:	e486                	sd	ra,72(sp)
    80005e4c:	e0a2                	sd	s0,64(sp)
    80005e4e:	fc26                	sd	s1,56(sp)
    80005e50:	f84a                	sd	s2,48(sp)
    80005e52:	f44e                	sd	s3,40(sp)
    80005e54:	f052                	sd	s4,32(sp)
    80005e56:	ec56                	sd	s5,24(sp)
    80005e58:	0880                	addi	s0,sp,80
    80005e5a:	84aa                	mv	s1,a0
  struct eth *ethhdr;
  uint16 type;

  ethhdr = mbufpullhdr(m, *ethhdr);
    80005e5c:	45b9                	li	a1,14
    80005e5e:	00000097          	auipc	ra,0x0
    80005e62:	cee080e7          	jalr	-786(ra) # 80005b4c <mbufpull>
  if (!ethhdr) {
    80005e66:	c521                	beqz	a0,80005eae <net_rx+0x66>
    mbuffree(m);
    return;
  }

  type = ntohs(ethhdr->type);
    80005e68:	00c54783          	lbu	a5,12(a0)
    80005e6c:	00d54703          	lbu	a4,13(a0)
    80005e70:	0722                	slli	a4,a4,0x8
    80005e72:	8fd9                	or	a5,a5,a4
    80005e74:	0087979b          	slliw	a5,a5,0x8
    80005e78:	8321                	srli	a4,a4,0x8
    80005e7a:	8fd9                	or	a5,a5,a4
    80005e7c:	17c2                	slli	a5,a5,0x30
    80005e7e:	93c1                	srli	a5,a5,0x30
  if (type == ETHTYPE_IP)
    80005e80:	8007871b          	addiw	a4,a5,-2048
    80005e84:	cb1d                	beqz	a4,80005eba <net_rx+0x72>
    net_rx_ip(m);
  else if (type == ETHTYPE_ARP)
    80005e86:	2781                	sext.w	a5,a5
    80005e88:	6705                	lui	a4,0x1
    80005e8a:	80670713          	addi	a4,a4,-2042 # 806 <_entry-0x7ffff7fa>
    80005e8e:	18e78e63          	beq	a5,a4,8000602a <net_rx+0x1e2>
  kfree(m);
    80005e92:	8526                	mv	a0,s1
    80005e94:	ffffa097          	auipc	ra,0xffffa
    80005e98:	188080e7          	jalr	392(ra) # 8000001c <kfree>
    net_rx_arp(m);
  else
    mbuffree(m);
}
    80005e9c:	60a6                	ld	ra,72(sp)
    80005e9e:	6406                	ld	s0,64(sp)
    80005ea0:	74e2                	ld	s1,56(sp)
    80005ea2:	7942                	ld	s2,48(sp)
    80005ea4:	79a2                	ld	s3,40(sp)
    80005ea6:	7a02                	ld	s4,32(sp)
    80005ea8:	6ae2                	ld	s5,24(sp)
    80005eaa:	6161                	addi	sp,sp,80
    80005eac:	8082                	ret
  kfree(m);
    80005eae:	8526                	mv	a0,s1
    80005eb0:	ffffa097          	auipc	ra,0xffffa
    80005eb4:	16c080e7          	jalr	364(ra) # 8000001c <kfree>
}
    80005eb8:	b7d5                	j	80005e9c <net_rx+0x54>
  iphdr = mbufpullhdr(m, *iphdr);
    80005eba:	45d1                	li	a1,20
    80005ebc:	8526                	mv	a0,s1
    80005ebe:	00000097          	auipc	ra,0x0
    80005ec2:	c8e080e7          	jalr	-882(ra) # 80005b4c <mbufpull>
    80005ec6:	892a                	mv	s2,a0
  if (!iphdr)
    80005ec8:	c519                	beqz	a0,80005ed6 <net_rx+0x8e>
  if (iphdr->ip_vhl != ((4 << 4) | (20 >> 2)))
    80005eca:	00054703          	lbu	a4,0(a0)
    80005ece:	04500793          	li	a5,69
    80005ed2:	00f70863          	beq	a4,a5,80005ee2 <net_rx+0x9a>
  kfree(m);
    80005ed6:	8526                	mv	a0,s1
    80005ed8:	ffffa097          	auipc	ra,0xffffa
    80005edc:	144080e7          	jalr	324(ra) # 8000001c <kfree>
}
    80005ee0:	bf75                	j	80005e9c <net_rx+0x54>
  if (in_cksum((unsigned char *)iphdr, sizeof(*iphdr)))
    80005ee2:	45d1                	li	a1,20
    80005ee4:	00000097          	auipc	ra,0x0
    80005ee8:	bf4080e7          	jalr	-1036(ra) # 80005ad8 <in_cksum>
    80005eec:	f56d                	bnez	a0,80005ed6 <net_rx+0x8e>
    80005eee:	00695783          	lhu	a5,6(s2)
    80005ef2:	0087d713          	srli	a4,a5,0x8
    80005ef6:	0087979b          	slliw	a5,a5,0x8
    80005efa:	0ff77713          	andi	a4,a4,255
    80005efe:	8fd9                	or	a5,a5,a4
  if (htons(iphdr->ip_off) != 0)
    80005f00:	17c2                	slli	a5,a5,0x30
    80005f02:	93c1                	srli	a5,a5,0x30
    80005f04:	fbe9                	bnez	a5,80005ed6 <net_rx+0x8e>
  if (htonl(iphdr->ip_dst) != local_ip)
    80005f06:	01092703          	lw	a4,16(s2)
  return (((val & 0x000000ffUL) << 24) |
    80005f0a:	0187179b          	slliw	a5,a4,0x18
          ((val & 0xff000000UL) >> 24));
    80005f0e:	0187569b          	srliw	a3,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005f12:	8fd5                	or	a5,a5,a3
          ((val & 0x0000ff00UL) << 8) |
    80005f14:	0087169b          	slliw	a3,a4,0x8
    80005f18:	00ff0637          	lui	a2,0xff0
    80005f1c:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    80005f1e:	8fd5                	or	a5,a5,a3
    80005f20:	0087571b          	srliw	a4,a4,0x8
    80005f24:	66c1                	lui	a3,0x10
    80005f26:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    80005f2a:	8f75                	and	a4,a4,a3
    80005f2c:	8fd9                	or	a5,a5,a4
    80005f2e:	2781                	sext.w	a5,a5
    80005f30:	0a000737          	lui	a4,0xa000
    80005f34:	20f70713          	addi	a4,a4,527 # a00020f <_entry-0x75fffdf1>
    80005f38:	f8e79fe3          	bne	a5,a4,80005ed6 <net_rx+0x8e>
  if (iphdr->ip_p != IPPROTO_UDP)
    80005f3c:	00994703          	lbu	a4,9(s2)
    80005f40:	47c5                	li	a5,17
    80005f42:	f8f71ae3          	bne	a4,a5,80005ed6 <net_rx+0x8e>
  return (((val & 0x00ffU) << 8) |
    80005f46:	00295783          	lhu	a5,2(s2)
    80005f4a:	0087d713          	srli	a4,a5,0x8
    80005f4e:	0087999b          	slliw	s3,a5,0x8
    80005f52:	0ff77793          	andi	a5,a4,255
    80005f56:	00f9e9b3          	or	s3,s3,a5
    80005f5a:	19c2                	slli	s3,s3,0x30
    80005f5c:	0309d993          	srli	s3,s3,0x30
  len = ntohs(iphdr->ip_len) - sizeof(*iphdr);
    80005f60:	fec9879b          	addiw	a5,s3,-20
    80005f64:	03079a13          	slli	s4,a5,0x30
    80005f68:	030a5a13          	srli	s4,s4,0x30
  udphdr = mbufpullhdr(m, *udphdr);
    80005f6c:	45a1                	li	a1,8
    80005f6e:	8526                	mv	a0,s1
    80005f70:	00000097          	auipc	ra,0x0
    80005f74:	bdc080e7          	jalr	-1060(ra) # 80005b4c <mbufpull>
    80005f78:	8aaa                	mv	s5,a0
  if (!udphdr)
    80005f7a:	c915                	beqz	a0,80005fae <net_rx+0x166>
    80005f7c:	00455783          	lhu	a5,4(a0)
    80005f80:	0087d713          	srli	a4,a5,0x8
    80005f84:	0087979b          	slliw	a5,a5,0x8
    80005f88:	0ff77713          	andi	a4,a4,255
    80005f8c:	8fd9                	or	a5,a5,a4
  if (ntohs(udphdr->ulen) != len)
    80005f8e:	2a01                	sext.w	s4,s4
    80005f90:	17c2                	slli	a5,a5,0x30
    80005f92:	93c1                	srli	a5,a5,0x30
    80005f94:	00fa1d63          	bne	s4,a5,80005fae <net_rx+0x166>
  len -= sizeof(*udphdr);
    80005f98:	fe49879b          	addiw	a5,s3,-28
  if (len > m->len)
    80005f9c:	0107979b          	slliw	a5,a5,0x10
    80005fa0:	0107d79b          	srliw	a5,a5,0x10
    80005fa4:	0007871b          	sext.w	a4,a5
    80005fa8:	488c                	lw	a1,16(s1)
    80005faa:	00e5f863          	bgeu	a1,a4,80005fba <net_rx+0x172>
  kfree(m);
    80005fae:	8526                	mv	a0,s1
    80005fb0:	ffffa097          	auipc	ra,0xffffa
    80005fb4:	06c080e7          	jalr	108(ra) # 8000001c <kfree>
}
    80005fb8:	b5d5                	j	80005e9c <net_rx+0x54>
  mbuftrim(m, m->len - len);
    80005fba:	9d9d                	subw	a1,a1,a5
    80005fbc:	8526                	mv	a0,s1
    80005fbe:	00000097          	auipc	ra,0x0
    80005fc2:	c9c080e7          	jalr	-868(ra) # 80005c5a <mbuftrim>
  sip = ntohl(iphdr->ip_src);
    80005fc6:	00c92783          	lw	a5,12(s2)
    80005fca:	000ad703          	lhu	a4,0(s5)
    80005fce:	00875693          	srli	a3,a4,0x8
    80005fd2:	0087171b          	slliw	a4,a4,0x8
    80005fd6:	0ff6f693          	andi	a3,a3,255
    80005fda:	8ed9                	or	a3,a3,a4
    80005fdc:	002ad703          	lhu	a4,2(s5)
    80005fe0:	00875613          	srli	a2,a4,0x8
    80005fe4:	0087171b          	slliw	a4,a4,0x8
    80005fe8:	0ff67613          	andi	a2,a2,255
    80005fec:	8e59                	or	a2,a2,a4
  return (((val & 0x000000ffUL) << 24) |
    80005fee:	0187971b          	slliw	a4,a5,0x18
          ((val & 0xff000000UL) >> 24));
    80005ff2:	0187d59b          	srliw	a1,a5,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005ff6:	8f4d                	or	a4,a4,a1
          ((val & 0x0000ff00UL) << 8) |
    80005ff8:	0087959b          	slliw	a1,a5,0x8
    80005ffc:	00ff0537          	lui	a0,0xff0
    80006000:	8de9                	and	a1,a1,a0
          ((val & 0x00ff0000UL) >> 8) |
    80006002:	8f4d                	or	a4,a4,a1
    80006004:	0087d79b          	srliw	a5,a5,0x8
    80006008:	65c1                	lui	a1,0x10
    8000600a:	f0058593          	addi	a1,a1,-256 # ff00 <_entry-0x7fff0100>
    8000600e:	8fed                	and	a5,a5,a1
    80006010:	8fd9                	or	a5,a5,a4
  sockrecvudp(m, sip, dport, sport);
    80006012:	16c2                	slli	a3,a3,0x30
    80006014:	92c1                	srli	a3,a3,0x30
    80006016:	1642                	slli	a2,a2,0x30
    80006018:	9241                	srli	a2,a2,0x30
    8000601a:	0007859b          	sext.w	a1,a5
    8000601e:	8526                	mv	a0,s1
    80006020:	00000097          	auipc	ra,0x0
    80006024:	55c080e7          	jalr	1372(ra) # 8000657c <sockrecvudp>
  return;
    80006028:	bd95                	j	80005e9c <net_rx+0x54>
  arphdr = mbufpullhdr(m, *arphdr);
    8000602a:	45f1                	li	a1,28
    8000602c:	8526                	mv	a0,s1
    8000602e:	00000097          	auipc	ra,0x0
    80006032:	b1e080e7          	jalr	-1250(ra) # 80005b4c <mbufpull>
    80006036:	892a                	mv	s2,a0
  if (!arphdr)
    80006038:	c179                	beqz	a0,800060fe <net_rx+0x2b6>
  if (ntohs(arphdr->hrd) != ARP_HRD_ETHER ||
    8000603a:	00054783          	lbu	a5,0(a0) # ff0000 <_entry-0x7f010000>
    8000603e:	00154703          	lbu	a4,1(a0)
    80006042:	0722                	slli	a4,a4,0x8
    80006044:	8fd9                	or	a5,a5,a4
  return (((val & 0x00ffU) << 8) |
    80006046:	0087979b          	slliw	a5,a5,0x8
    8000604a:	8321                	srli	a4,a4,0x8
    8000604c:	8fd9                	or	a5,a5,a4
    8000604e:	17c2                	slli	a5,a5,0x30
    80006050:	93c1                	srli	a5,a5,0x30
    80006052:	4705                	li	a4,1
    80006054:	0ae79563          	bne	a5,a4,800060fe <net_rx+0x2b6>
      ntohs(arphdr->pro) != ETHTYPE_IP ||
    80006058:	00254783          	lbu	a5,2(a0)
    8000605c:	00354703          	lbu	a4,3(a0)
    80006060:	0722                	slli	a4,a4,0x8
    80006062:	8fd9                	or	a5,a5,a4
    80006064:	0087979b          	slliw	a5,a5,0x8
    80006068:	8321                	srli	a4,a4,0x8
    8000606a:	8fd9                	or	a5,a5,a4
  if (ntohs(arphdr->hrd) != ARP_HRD_ETHER ||
    8000606c:	0107979b          	slliw	a5,a5,0x10
    80006070:	0107d79b          	srliw	a5,a5,0x10
    80006074:	8007879b          	addiw	a5,a5,-2048
    80006078:	e3d9                	bnez	a5,800060fe <net_rx+0x2b6>
      ntohs(arphdr->pro) != ETHTYPE_IP ||
    8000607a:	00454703          	lbu	a4,4(a0)
    8000607e:	4799                	li	a5,6
    80006080:	06f71f63          	bne	a4,a5,800060fe <net_rx+0x2b6>
      arphdr->hln != ETHADDR_LEN ||
    80006084:	00554703          	lbu	a4,5(a0)
    80006088:	4791                	li	a5,4
    8000608a:	06f71a63          	bne	a4,a5,800060fe <net_rx+0x2b6>
  if (ntohs(arphdr->op) != ARP_OP_REQUEST || tip != local_ip)
    8000608e:	00654783          	lbu	a5,6(a0)
    80006092:	00754703          	lbu	a4,7(a0)
    80006096:	0722                	slli	a4,a4,0x8
    80006098:	8fd9                	or	a5,a5,a4
    8000609a:	0087979b          	slliw	a5,a5,0x8
    8000609e:	8321                	srli	a4,a4,0x8
    800060a0:	8fd9                	or	a5,a5,a4
    800060a2:	17c2                	slli	a5,a5,0x30
    800060a4:	93c1                	srli	a5,a5,0x30
    800060a6:	4705                	li	a4,1
    800060a8:	04e79b63          	bne	a5,a4,800060fe <net_rx+0x2b6>
  tip = ntohl(arphdr->tip); // target IP address
    800060ac:	01854783          	lbu	a5,24(a0)
    800060b0:	01954703          	lbu	a4,25(a0)
    800060b4:	0722                	slli	a4,a4,0x8
    800060b6:	8f5d                	or	a4,a4,a5
    800060b8:	01a54783          	lbu	a5,26(a0)
    800060bc:	07c2                	slli	a5,a5,0x10
    800060be:	8f5d                	or	a4,a4,a5
    800060c0:	01b54783          	lbu	a5,27(a0)
    800060c4:	07e2                	slli	a5,a5,0x18
    800060c6:	8fd9                	or	a5,a5,a4
    800060c8:	0007871b          	sext.w	a4,a5
  return (((val & 0x000000ffUL) << 24) |
    800060cc:	0187979b          	slliw	a5,a5,0x18
          ((val & 0xff000000UL) >> 24));
    800060d0:	0187569b          	srliw	a3,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    800060d4:	8fd5                	or	a5,a5,a3
          ((val & 0x0000ff00UL) << 8) |
    800060d6:	0087169b          	slliw	a3,a4,0x8
    800060da:	00ff0637          	lui	a2,0xff0
    800060de:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    800060e0:	8fd5                	or	a5,a5,a3
    800060e2:	0087571b          	srliw	a4,a4,0x8
    800060e6:	66c1                	lui	a3,0x10
    800060e8:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    800060ec:	8f75                	and	a4,a4,a3
    800060ee:	8fd9                	or	a5,a5,a4
  if (ntohs(arphdr->op) != ARP_OP_REQUEST || tip != local_ip)
    800060f0:	2781                	sext.w	a5,a5
    800060f2:	0a000737          	lui	a4,0xa000
    800060f6:	20f70713          	addi	a4,a4,527 # a00020f <_entry-0x75fffdf1>
    800060fa:	00e78863          	beq	a5,a4,8000610a <net_rx+0x2c2>
  kfree(m);
    800060fe:	8526                	mv	a0,s1
    80006100:	ffffa097          	auipc	ra,0xffffa
    80006104:	f1c080e7          	jalr	-228(ra) # 8000001c <kfree>
}
    80006108:	bb51                	j	80005e9c <net_rx+0x54>
  memmove(smac, arphdr->sha, ETHADDR_LEN); // sender's ethernet address
    8000610a:	4619                	li	a2,6
    8000610c:	00850593          	addi	a1,a0,8
    80006110:	fb840513          	addi	a0,s0,-72
    80006114:	ffffa097          	auipc	ra,0xffffa
    80006118:	0c4080e7          	jalr	196(ra) # 800001d8 <memmove>
  sip = ntohl(arphdr->sip); // sender's IP address (qemu's slirp)
    8000611c:	00e94783          	lbu	a5,14(s2)
    80006120:	00f94703          	lbu	a4,15(s2)
    80006124:	0722                	slli	a4,a4,0x8
    80006126:	8f5d                	or	a4,a4,a5
    80006128:	01094783          	lbu	a5,16(s2)
    8000612c:	07c2                	slli	a5,a5,0x10
    8000612e:	8f5d                	or	a4,a4,a5
    80006130:	01194783          	lbu	a5,17(s2)
    80006134:	07e2                	slli	a5,a5,0x18
    80006136:	8fd9                	or	a5,a5,a4
    80006138:	0007871b          	sext.w	a4,a5
  return (((val & 0x000000ffUL) << 24) |
    8000613c:	0187991b          	slliw	s2,a5,0x18
          ((val & 0xff000000UL) >> 24));
    80006140:	0187579b          	srliw	a5,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80006144:	00f96933          	or	s2,s2,a5
          ((val & 0x0000ff00UL) << 8) |
    80006148:	0087179b          	slliw	a5,a4,0x8
    8000614c:	00ff06b7          	lui	a3,0xff0
    80006150:	8ff5                	and	a5,a5,a3
          ((val & 0x00ff0000UL) >> 8) |
    80006152:	00f96933          	or	s2,s2,a5
    80006156:	0087579b          	srliw	a5,a4,0x8
    8000615a:	6741                	lui	a4,0x10
    8000615c:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    80006160:	8ff9                	and	a5,a5,a4
    80006162:	00f96933          	or	s2,s2,a5
    80006166:	2901                	sext.w	s2,s2
  m = mbufalloc(MBUF_DEFAULT_HEADROOM);
    80006168:	08000513          	li	a0,128
    8000616c:	00000097          	auipc	ra,0x0
    80006170:	b10080e7          	jalr	-1264(ra) # 80005c7c <mbufalloc>
    80006174:	8a2a                	mv	s4,a0
  if (!m)
    80006176:	d541                	beqz	a0,800060fe <net_rx+0x2b6>
  arphdr = mbufputhdr(m, *arphdr);
    80006178:	45f1                	li	a1,28
    8000617a:	00000097          	auipc	ra,0x0
    8000617e:	aa6080e7          	jalr	-1370(ra) # 80005c20 <mbufput>
    80006182:	89aa                	mv	s3,a0
  arphdr->hrd = htons(ARP_HRD_ETHER);
    80006184:	00050023          	sb	zero,0(a0)
    80006188:	4785                	li	a5,1
    8000618a:	00f500a3          	sb	a5,1(a0)
  arphdr->pro = htons(ETHTYPE_IP);
    8000618e:	47a1                	li	a5,8
    80006190:	00f50123          	sb	a5,2(a0)
    80006194:	000501a3          	sb	zero,3(a0)
  arphdr->hln = ETHADDR_LEN;
    80006198:	4799                	li	a5,6
    8000619a:	00f50223          	sb	a5,4(a0)
  arphdr->pln = sizeof(uint32);
    8000619e:	4791                	li	a5,4
    800061a0:	00f502a3          	sb	a5,5(a0)
  arphdr->op = htons(op);
    800061a4:	00050323          	sb	zero,6(a0)
    800061a8:	4a89                	li	s5,2
    800061aa:	015503a3          	sb	s5,7(a0)
  memmove(arphdr->sha, local_mac, ETHADDR_LEN);
    800061ae:	4619                	li	a2,6
    800061b0:	00003597          	auipc	a1,0x3
    800061b4:	70058593          	addi	a1,a1,1792 # 800098b0 <local_mac>
    800061b8:	0521                	addi	a0,a0,8
    800061ba:	ffffa097          	auipc	ra,0xffffa
    800061be:	01e080e7          	jalr	30(ra) # 800001d8 <memmove>
  arphdr->sip = htonl(local_ip);
    800061c2:	47a9                	li	a5,10
    800061c4:	00f98723          	sb	a5,14(s3)
    800061c8:	000987a3          	sb	zero,15(s3)
    800061cc:	01598823          	sb	s5,16(s3)
    800061d0:	47bd                	li	a5,15
    800061d2:	00f988a3          	sb	a5,17(s3)
  memmove(arphdr->tha, dmac, ETHADDR_LEN);
    800061d6:	4619                	li	a2,6
    800061d8:	fb840593          	addi	a1,s0,-72
    800061dc:	01298513          	addi	a0,s3,18
    800061e0:	ffffa097          	auipc	ra,0xffffa
    800061e4:	ff8080e7          	jalr	-8(ra) # 800001d8 <memmove>
  return (((val & 0x000000ffUL) << 24) |
    800061e8:	0189171b          	slliw	a4,s2,0x18
          ((val & 0xff000000UL) >> 24));
    800061ec:	0189579b          	srliw	a5,s2,0x18
          ((val & 0x00ff0000UL) >> 8) |
    800061f0:	8f5d                	or	a4,a4,a5
          ((val & 0x0000ff00UL) << 8) |
    800061f2:	0089179b          	slliw	a5,s2,0x8
    800061f6:	00ff06b7          	lui	a3,0xff0
    800061fa:	8ff5                	and	a5,a5,a3
          ((val & 0x00ff0000UL) >> 8) |
    800061fc:	8f5d                	or	a4,a4,a5
    800061fe:	0089579b          	srliw	a5,s2,0x8
    80006202:	66c1                	lui	a3,0x10
    80006204:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    80006208:	8ff5                	and	a5,a5,a3
    8000620a:	8fd9                	or	a5,a5,a4
  arphdr->tip = htonl(dip);
    8000620c:	00e98c23          	sb	a4,24(s3)
    80006210:	0087d71b          	srliw	a4,a5,0x8
    80006214:	00e98ca3          	sb	a4,25(s3)
    80006218:	0107d71b          	srliw	a4,a5,0x10
    8000621c:	00e98d23          	sb	a4,26(s3)
    80006220:	0187d79b          	srliw	a5,a5,0x18
    80006224:	00f98da3          	sb	a5,27(s3)
  net_tx_eth(m, ETHTYPE_ARP);
    80006228:	6585                	lui	a1,0x1
    8000622a:	80658593          	addi	a1,a1,-2042 # 806 <_entry-0x7ffff7fa>
    8000622e:	8552                	mv	a0,s4
    80006230:	00000097          	auipc	ra,0x0
    80006234:	978080e7          	jalr	-1672(ra) # 80005ba8 <net_tx_eth>
  return 0;
    80006238:	b5d9                	j	800060fe <net_rx+0x2b6>

000000008000623a <sockinit>:
static struct spinlock lock;
static struct sock *sockets;

void
sockinit(void)
{
    8000623a:	1141                	addi	sp,sp,-16
    8000623c:	e406                	sd	ra,8(sp)
    8000623e:	e022                	sd	s0,0(sp)
    80006240:	0800                	addi	s0,sp,16
  initlock(&lock, "socktbl");
    80006242:	00003597          	auipc	a1,0x3
    80006246:	5ce58593          	addi	a1,a1,1486 # 80009810 <syscalls+0x438>
    8000624a:	00019517          	auipc	a0,0x19
    8000624e:	0e650513          	addi	a0,a0,230 # 8001f330 <lock>
    80006252:	00001097          	auipc	ra,0x1
    80006256:	e5c080e7          	jalr	-420(ra) # 800070ae <initlock>
}
    8000625a:	60a2                	ld	ra,8(sp)
    8000625c:	6402                	ld	s0,0(sp)
    8000625e:	0141                	addi	sp,sp,16
    80006260:	8082                	ret

0000000080006262 <sockalloc>:

int
sockalloc(struct file **f, uint32 raddr, uint16 lport, uint16 rport)
{
    80006262:	7139                	addi	sp,sp,-64
    80006264:	fc06                	sd	ra,56(sp)
    80006266:	f822                	sd	s0,48(sp)
    80006268:	f426                	sd	s1,40(sp)
    8000626a:	f04a                	sd	s2,32(sp)
    8000626c:	ec4e                	sd	s3,24(sp)
    8000626e:	e852                	sd	s4,16(sp)
    80006270:	e456                	sd	s5,8(sp)
    80006272:	0080                	addi	s0,sp,64
    80006274:	892a                	mv	s2,a0
    80006276:	84ae                	mv	s1,a1
    80006278:	8a32                	mv	s4,a2
    8000627a:	89b6                	mv	s3,a3
  struct sock *si, *pos;

  si = 0;
  *f = 0;
    8000627c:	00053023          	sd	zero,0(a0)
  if ((*f = filealloc()) == 0)
    80006280:	ffffd097          	auipc	ra,0xffffd
    80006284:	650080e7          	jalr	1616(ra) # 800038d0 <filealloc>
    80006288:	00a93023          	sd	a0,0(s2)
    8000628c:	c975                	beqz	a0,80006380 <sockalloc+0x11e>
    goto bad;
  if ((si = (struct sock*)kalloc()) == 0)
    8000628e:	ffffa097          	auipc	ra,0xffffa
    80006292:	e8a080e7          	jalr	-374(ra) # 80000118 <kalloc>
    80006296:	8aaa                	mv	s5,a0
    80006298:	c15d                	beqz	a0,8000633e <sockalloc+0xdc>
    goto bad;

  // initialize objects
  si->raddr = raddr;
    8000629a:	c504                	sw	s1,8(a0)
  si->lport = lport;
    8000629c:	01451623          	sh	s4,12(a0)
  si->rport = rport;
    800062a0:	01351723          	sh	s3,14(a0)
  initlock(&si->lock, "sock");
    800062a4:	00003597          	auipc	a1,0x3
    800062a8:	57458593          	addi	a1,a1,1396 # 80009818 <syscalls+0x440>
    800062ac:	0541                	addi	a0,a0,16
    800062ae:	00001097          	auipc	ra,0x1
    800062b2:	e00080e7          	jalr	-512(ra) # 800070ae <initlock>
  mbufq_init(&si->rxq);
    800062b6:	028a8513          	addi	a0,s5,40
    800062ba:	00000097          	auipc	ra,0x0
    800062be:	a7a080e7          	jalr	-1414(ra) # 80005d34 <mbufq_init>
  (*f)->type = FD_SOCK;
    800062c2:	00093783          	ld	a5,0(s2)
    800062c6:	4711                	li	a4,4
    800062c8:	c398                	sw	a4,0(a5)
  (*f)->readable = 1;
    800062ca:	00093703          	ld	a4,0(s2)
    800062ce:	4785                	li	a5,1
    800062d0:	00f70423          	sb	a5,8(a4)
  (*f)->writable = 1;
    800062d4:	00093703          	ld	a4,0(s2)
    800062d8:	00f704a3          	sb	a5,9(a4)
  (*f)->sock = si;
    800062dc:	00093783          	ld	a5,0(s2)
    800062e0:	0357b023          	sd	s5,32(a5) # f020020 <_entry-0x70fdffe0>

  // add to list of sockets
  acquire(&lock);
    800062e4:	00019517          	auipc	a0,0x19
    800062e8:	04c50513          	addi	a0,a0,76 # 8001f330 <lock>
    800062ec:	00001097          	auipc	ra,0x1
    800062f0:	e52080e7          	jalr	-430(ra) # 8000713e <acquire>
  pos = sockets;
    800062f4:	00004597          	auipc	a1,0x4
    800062f8:	d345b583          	ld	a1,-716(a1) # 8000a028 <sockets>
  while (pos) {
    800062fc:	c9b1                	beqz	a1,80006350 <sockalloc+0xee>
  pos = sockets;
    800062fe:	87ae                	mv	a5,a1
    if (pos->raddr == raddr &&
    80006300:	000a061b          	sext.w	a2,s4
        pos->lport == lport &&
    80006304:	0009869b          	sext.w	a3,s3
    80006308:	a019                	j	8000630e <sockalloc+0xac>
	pos->rport == rport) {
      release(&lock);
      goto bad;
    }
    pos = pos->next;
    8000630a:	639c                	ld	a5,0(a5)
  while (pos) {
    8000630c:	c3b1                	beqz	a5,80006350 <sockalloc+0xee>
    if (pos->raddr == raddr &&
    8000630e:	4798                	lw	a4,8(a5)
    80006310:	fe971de3          	bne	a4,s1,8000630a <sockalloc+0xa8>
    80006314:	00c7d703          	lhu	a4,12(a5)
    80006318:	fec719e3          	bne	a4,a2,8000630a <sockalloc+0xa8>
        pos->lport == lport &&
    8000631c:	00e7d703          	lhu	a4,14(a5)
    80006320:	fed715e3          	bne	a4,a3,8000630a <sockalloc+0xa8>
      release(&lock);
    80006324:	00019517          	auipc	a0,0x19
    80006328:	00c50513          	addi	a0,a0,12 # 8001f330 <lock>
    8000632c:	00001097          	auipc	ra,0x1
    80006330:	ec6080e7          	jalr	-314(ra) # 800071f2 <release>
  release(&lock);
  return 0;

bad:
  if (si)
    kfree((char*)si);
    80006334:	8556                	mv	a0,s5
    80006336:	ffffa097          	auipc	ra,0xffffa
    8000633a:	ce6080e7          	jalr	-794(ra) # 8000001c <kfree>
  if (*f)
    8000633e:	00093503          	ld	a0,0(s2)
    80006342:	c129                	beqz	a0,80006384 <sockalloc+0x122>
    fileclose(*f);
    80006344:	ffffd097          	auipc	ra,0xffffd
    80006348:	648080e7          	jalr	1608(ra) # 8000398c <fileclose>
  return -1;
    8000634c:	557d                	li	a0,-1
    8000634e:	a005                	j	8000636e <sockalloc+0x10c>
  si->next = sockets;
    80006350:	00bab023          	sd	a1,0(s5)
  sockets = si;
    80006354:	00004797          	auipc	a5,0x4
    80006358:	cd57ba23          	sd	s5,-812(a5) # 8000a028 <sockets>
  release(&lock);
    8000635c:	00019517          	auipc	a0,0x19
    80006360:	fd450513          	addi	a0,a0,-44 # 8001f330 <lock>
    80006364:	00001097          	auipc	ra,0x1
    80006368:	e8e080e7          	jalr	-370(ra) # 800071f2 <release>
  return 0;
    8000636c:	4501                	li	a0,0
}
    8000636e:	70e2                	ld	ra,56(sp)
    80006370:	7442                	ld	s0,48(sp)
    80006372:	74a2                	ld	s1,40(sp)
    80006374:	7902                	ld	s2,32(sp)
    80006376:	69e2                	ld	s3,24(sp)
    80006378:	6a42                	ld	s4,16(sp)
    8000637a:	6aa2                	ld	s5,8(sp)
    8000637c:	6121                	addi	sp,sp,64
    8000637e:	8082                	ret
  return -1;
    80006380:	557d                	li	a0,-1
    80006382:	b7f5                	j	8000636e <sockalloc+0x10c>
    80006384:	557d                	li	a0,-1
    80006386:	b7e5                	j	8000636e <sockalloc+0x10c>

0000000080006388 <sockclose>:

void
sockclose(struct sock *si)
{
    80006388:	1101                	addi	sp,sp,-32
    8000638a:	ec06                	sd	ra,24(sp)
    8000638c:	e822                	sd	s0,16(sp)
    8000638e:	e426                	sd	s1,8(sp)
    80006390:	e04a                	sd	s2,0(sp)
    80006392:	1000                	addi	s0,sp,32
    80006394:	892a                	mv	s2,a0
  struct sock **pos;
  struct mbuf *m;

  // remove from list of sockets
  acquire(&lock);
    80006396:	00019517          	auipc	a0,0x19
    8000639a:	f9a50513          	addi	a0,a0,-102 # 8001f330 <lock>
    8000639e:	00001097          	auipc	ra,0x1
    800063a2:	da0080e7          	jalr	-608(ra) # 8000713e <acquire>
  pos = &sockets;
    800063a6:	00004797          	auipc	a5,0x4
    800063aa:	c827b783          	ld	a5,-894(a5) # 8000a028 <sockets>
  while (*pos) {
    800063ae:	cb99                	beqz	a5,800063c4 <sockclose+0x3c>
    if (*pos == si){
    800063b0:	02f90563          	beq	s2,a5,800063da <sockclose+0x52>
      *pos = si->next;
      break;
    }
    pos = &(*pos)->next;
    800063b4:	873e                	mv	a4,a5
    800063b6:	639c                	ld	a5,0(a5)
  while (*pos) {
    800063b8:	c791                	beqz	a5,800063c4 <sockclose+0x3c>
    if (*pos == si){
    800063ba:	fef91de3          	bne	s2,a5,800063b4 <sockclose+0x2c>
      *pos = si->next;
    800063be:	00093783          	ld	a5,0(s2)
    800063c2:	e31c                	sd	a5,0(a4)
  }
  release(&lock);
    800063c4:	00019517          	auipc	a0,0x19
    800063c8:	f6c50513          	addi	a0,a0,-148 # 8001f330 <lock>
    800063cc:	00001097          	auipc	ra,0x1
    800063d0:	e26080e7          	jalr	-474(ra) # 800071f2 <release>

  // free any pending mbufs
  while (!mbufq_empty(&si->rxq)) {
    800063d4:	02890493          	addi	s1,s2,40
    800063d8:	a839                	j	800063f6 <sockclose+0x6e>
  pos = &sockets;
    800063da:	00004717          	auipc	a4,0x4
    800063de:	c4e70713          	addi	a4,a4,-946 # 8000a028 <sockets>
    800063e2:	bff1                	j	800063be <sockclose+0x36>
    m = mbufq_pophead(&si->rxq);
    800063e4:	8526                	mv	a0,s1
    800063e6:	00000097          	auipc	ra,0x0
    800063ea:	926080e7          	jalr	-1754(ra) # 80005d0c <mbufq_pophead>
    mbuffree(m);
    800063ee:	00000097          	auipc	ra,0x0
    800063f2:	8e6080e7          	jalr	-1818(ra) # 80005cd4 <mbuffree>
  while (!mbufq_empty(&si->rxq)) {
    800063f6:	8526                	mv	a0,s1
    800063f8:	00000097          	auipc	ra,0x0
    800063fc:	92a080e7          	jalr	-1750(ra) # 80005d22 <mbufq_empty>
    80006400:	d175                	beqz	a0,800063e4 <sockclose+0x5c>
  }

  kfree((char*)si);
    80006402:	854a                	mv	a0,s2
    80006404:	ffffa097          	auipc	ra,0xffffa
    80006408:	c18080e7          	jalr	-1000(ra) # 8000001c <kfree>
}
    8000640c:	60e2                	ld	ra,24(sp)
    8000640e:	6442                	ld	s0,16(sp)
    80006410:	64a2                	ld	s1,8(sp)
    80006412:	6902                	ld	s2,0(sp)
    80006414:	6105                	addi	sp,sp,32
    80006416:	8082                	ret

0000000080006418 <sockread>:

int
sockread(struct sock *si, uint64 addr, int n)
{
    80006418:	7139                	addi	sp,sp,-64
    8000641a:	fc06                	sd	ra,56(sp)
    8000641c:	f822                	sd	s0,48(sp)
    8000641e:	f426                	sd	s1,40(sp)
    80006420:	f04a                	sd	s2,32(sp)
    80006422:	ec4e                	sd	s3,24(sp)
    80006424:	e852                	sd	s4,16(sp)
    80006426:	e456                	sd	s5,8(sp)
    80006428:	0080                	addi	s0,sp,64
    8000642a:	84aa                	mv	s1,a0
    8000642c:	8a2e                	mv	s4,a1
    8000642e:	8ab2                	mv	s5,a2
  struct proc *pr = myproc();
    80006430:	ffffb097          	auipc	ra,0xffffb
    80006434:	a70080e7          	jalr	-1424(ra) # 80000ea0 <myproc>
    80006438:	892a                	mv	s2,a0
  struct mbuf *m;
  int len;

  acquire(&si->lock);
    8000643a:	01048993          	addi	s3,s1,16
    8000643e:	854e                	mv	a0,s3
    80006440:	00001097          	auipc	ra,0x1
    80006444:	cfe080e7          	jalr	-770(ra) # 8000713e <acquire>
  while (mbufq_empty(&si->rxq) && !pr->killed) {
    80006448:	02848493          	addi	s1,s1,40
    8000644c:	8526                	mv	a0,s1
    8000644e:	00000097          	auipc	ra,0x0
    80006452:	8d4080e7          	jalr	-1836(ra) # 80005d22 <mbufq_empty>
    80006456:	c919                	beqz	a0,8000646c <sockread+0x54>
    80006458:	02892783          	lw	a5,40(s2)
    8000645c:	eba5                	bnez	a5,800064cc <sockread+0xb4>
    sleep(&si->rxq, &si->lock);
    8000645e:	85ce                	mv	a1,s3
    80006460:	8526                	mv	a0,s1
    80006462:	ffffb097          	auipc	ra,0xffffb
    80006466:	0fa080e7          	jalr	250(ra) # 8000155c <sleep>
    8000646a:	b7cd                	j	8000644c <sockread+0x34>
  }
  if (pr->killed) {
    8000646c:	02892783          	lw	a5,40(s2)
    80006470:	efb1                	bnez	a5,800064cc <sockread+0xb4>
    release(&si->lock);
    return -1;
  }
  m = mbufq_pophead(&si->rxq);
    80006472:	8526                	mv	a0,s1
    80006474:	00000097          	auipc	ra,0x0
    80006478:	898080e7          	jalr	-1896(ra) # 80005d0c <mbufq_pophead>
    8000647c:	84aa                	mv	s1,a0
  release(&si->lock);
    8000647e:	854e                	mv	a0,s3
    80006480:	00001097          	auipc	ra,0x1
    80006484:	d72080e7          	jalr	-654(ra) # 800071f2 <release>

  len = m->len;
    80006488:	489c                	lw	a5,16(s1)
  if (len > n)
    8000648a:	89be                	mv	s3,a5
    8000648c:	00fad363          	bge	s5,a5,80006492 <sockread+0x7a>
    80006490:	89d6                	mv	s3,s5
    80006492:	2981                	sext.w	s3,s3
    len = n;
  if (copyout(pr->pagetable, addr, m->head, len) == -1) {
    80006494:	86ce                	mv	a3,s3
    80006496:	6490                	ld	a2,8(s1)
    80006498:	85d2                	mv	a1,s4
    8000649a:	05093503          	ld	a0,80(s2)
    8000649e:	ffffa097          	auipc	ra,0xffffa
    800064a2:	6c8080e7          	jalr	1736(ra) # 80000b66 <copyout>
    800064a6:	892a                	mv	s2,a0
    800064a8:	57fd                	li	a5,-1
    800064aa:	02f50863          	beq	a0,a5,800064da <sockread+0xc2>
    mbuffree(m);
    return -1;
  }
  mbuffree(m);
    800064ae:	8526                	mv	a0,s1
    800064b0:	00000097          	auipc	ra,0x0
    800064b4:	824080e7          	jalr	-2012(ra) # 80005cd4 <mbuffree>
  return len;
}
    800064b8:	854e                	mv	a0,s3
    800064ba:	70e2                	ld	ra,56(sp)
    800064bc:	7442                	ld	s0,48(sp)
    800064be:	74a2                	ld	s1,40(sp)
    800064c0:	7902                	ld	s2,32(sp)
    800064c2:	69e2                	ld	s3,24(sp)
    800064c4:	6a42                	ld	s4,16(sp)
    800064c6:	6aa2                	ld	s5,8(sp)
    800064c8:	6121                	addi	sp,sp,64
    800064ca:	8082                	ret
    release(&si->lock);
    800064cc:	854e                	mv	a0,s3
    800064ce:	00001097          	auipc	ra,0x1
    800064d2:	d24080e7          	jalr	-732(ra) # 800071f2 <release>
    return -1;
    800064d6:	59fd                	li	s3,-1
    800064d8:	b7c5                	j	800064b8 <sockread+0xa0>
    mbuffree(m);
    800064da:	8526                	mv	a0,s1
    800064dc:	fffff097          	auipc	ra,0xfffff
    800064e0:	7f8080e7          	jalr	2040(ra) # 80005cd4 <mbuffree>
    return -1;
    800064e4:	89ca                	mv	s3,s2
    800064e6:	bfc9                	j	800064b8 <sockread+0xa0>

00000000800064e8 <sockwrite>:

int
sockwrite(struct sock *si, uint64 addr, int n)
{
    800064e8:	7139                	addi	sp,sp,-64
    800064ea:	fc06                	sd	ra,56(sp)
    800064ec:	f822                	sd	s0,48(sp)
    800064ee:	f426                	sd	s1,40(sp)
    800064f0:	f04a                	sd	s2,32(sp)
    800064f2:	ec4e                	sd	s3,24(sp)
    800064f4:	e852                	sd	s4,16(sp)
    800064f6:	e456                	sd	s5,8(sp)
    800064f8:	0080                	addi	s0,sp,64
    800064fa:	8aaa                	mv	s5,a0
    800064fc:	89ae                	mv	s3,a1
    800064fe:	8932                	mv	s2,a2
  struct proc *pr = myproc();
    80006500:	ffffb097          	auipc	ra,0xffffb
    80006504:	9a0080e7          	jalr	-1632(ra) # 80000ea0 <myproc>
    80006508:	8a2a                	mv	s4,a0
  struct mbuf *m;

  m = mbufalloc(MBUF_DEFAULT_HEADROOM);
    8000650a:	08000513          	li	a0,128
    8000650e:	fffff097          	auipc	ra,0xfffff
    80006512:	76e080e7          	jalr	1902(ra) # 80005c7c <mbufalloc>
  if (!m)
    80006516:	c12d                	beqz	a0,80006578 <sockwrite+0x90>
    80006518:	84aa                	mv	s1,a0
    return -1;

  if (copyin(pr->pagetable, mbufput(m, n), addr, n) == -1) {
    8000651a:	050a3a03          	ld	s4,80(s4)
    8000651e:	85ca                	mv	a1,s2
    80006520:	fffff097          	auipc	ra,0xfffff
    80006524:	700080e7          	jalr	1792(ra) # 80005c20 <mbufput>
    80006528:	85aa                	mv	a1,a0
    8000652a:	86ca                	mv	a3,s2
    8000652c:	864e                	mv	a2,s3
    8000652e:	8552                	mv	a0,s4
    80006530:	ffffa097          	auipc	ra,0xffffa
    80006534:	6c2080e7          	jalr	1730(ra) # 80000bf2 <copyin>
    80006538:	89aa                	mv	s3,a0
    8000653a:	57fd                	li	a5,-1
    8000653c:	02f50863          	beq	a0,a5,8000656c <sockwrite+0x84>
    mbuffree(m);
    return -1;
  }
  net_tx_udp(m, si->raddr, si->lport, si->rport);
    80006540:	00ead683          	lhu	a3,14(s5)
    80006544:	00cad603          	lhu	a2,12(s5)
    80006548:	008aa583          	lw	a1,8(s5)
    8000654c:	8526                	mv	a0,s1
    8000654e:	fffff097          	auipc	ra,0xfffff
    80006552:	7f6080e7          	jalr	2038(ra) # 80005d44 <net_tx_udp>
  return n;
    80006556:	89ca                	mv	s3,s2
}
    80006558:	854e                	mv	a0,s3
    8000655a:	70e2                	ld	ra,56(sp)
    8000655c:	7442                	ld	s0,48(sp)
    8000655e:	74a2                	ld	s1,40(sp)
    80006560:	7902                	ld	s2,32(sp)
    80006562:	69e2                	ld	s3,24(sp)
    80006564:	6a42                	ld	s4,16(sp)
    80006566:	6aa2                	ld	s5,8(sp)
    80006568:	6121                	addi	sp,sp,64
    8000656a:	8082                	ret
    mbuffree(m);
    8000656c:	8526                	mv	a0,s1
    8000656e:	fffff097          	auipc	ra,0xfffff
    80006572:	766080e7          	jalr	1894(ra) # 80005cd4 <mbuffree>
    return -1;
    80006576:	b7cd                	j	80006558 <sockwrite+0x70>
    return -1;
    80006578:	59fd                	li	s3,-1
    8000657a:	bff9                	j	80006558 <sockwrite+0x70>

000000008000657c <sockrecvudp>:

// called by protocol handler layer to deliver UDP packets
void
sockrecvudp(struct mbuf *m, uint32 raddr, uint16 lport, uint16 rport)
{
    8000657c:	7139                	addi	sp,sp,-64
    8000657e:	fc06                	sd	ra,56(sp)
    80006580:	f822                	sd	s0,48(sp)
    80006582:	f426                	sd	s1,40(sp)
    80006584:	f04a                	sd	s2,32(sp)
    80006586:	ec4e                	sd	s3,24(sp)
    80006588:	e852                	sd	s4,16(sp)
    8000658a:	e456                	sd	s5,8(sp)
    8000658c:	0080                	addi	s0,sp,64
    8000658e:	8a2a                	mv	s4,a0
    80006590:	892e                	mv	s2,a1
    80006592:	89b2                	mv	s3,a2
    80006594:	8ab6                	mv	s5,a3
  // any sleeping reader. Free the mbuf if there are no sockets
  // registered to handle it.
  //
  struct sock *si;

  acquire(&lock);
    80006596:	00019517          	auipc	a0,0x19
    8000659a:	d9a50513          	addi	a0,a0,-614 # 8001f330 <lock>
    8000659e:	00001097          	auipc	ra,0x1
    800065a2:	ba0080e7          	jalr	-1120(ra) # 8000713e <acquire>
  si = sockets;
    800065a6:	00004497          	auipc	s1,0x4
    800065aa:	a824b483          	ld	s1,-1406(s1) # 8000a028 <sockets>
  while (si) {
    800065ae:	c4ad                	beqz	s1,80006618 <sockrecvudp+0x9c>
    if (si->raddr == raddr && si->lport == lport && si->rport == rport)
    800065b0:	0009871b          	sext.w	a4,s3
    800065b4:	000a869b          	sext.w	a3,s5
    800065b8:	a019                	j	800065be <sockrecvudp+0x42>
      goto found;
    si = si->next;
    800065ba:	6084                	ld	s1,0(s1)
  while (si) {
    800065bc:	ccb1                	beqz	s1,80006618 <sockrecvudp+0x9c>
    if (si->raddr == raddr && si->lport == lport && si->rport == rport)
    800065be:	449c                	lw	a5,8(s1)
    800065c0:	ff279de3          	bne	a5,s2,800065ba <sockrecvudp+0x3e>
    800065c4:	00c4d783          	lhu	a5,12(s1)
    800065c8:	fee799e3          	bne	a5,a4,800065ba <sockrecvudp+0x3e>
    800065cc:	00e4d783          	lhu	a5,14(s1)
    800065d0:	fed795e3          	bne	a5,a3,800065ba <sockrecvudp+0x3e>
  release(&lock);
  mbuffree(m);
  return;

found:
  acquire(&si->lock);
    800065d4:	01048913          	addi	s2,s1,16
    800065d8:	854a                	mv	a0,s2
    800065da:	00001097          	auipc	ra,0x1
    800065de:	b64080e7          	jalr	-1180(ra) # 8000713e <acquire>
  mbufq_pushtail(&si->rxq, m);
    800065e2:	02848493          	addi	s1,s1,40
    800065e6:	85d2                	mv	a1,s4
    800065e8:	8526                	mv	a0,s1
    800065ea:	fffff097          	auipc	ra,0xfffff
    800065ee:	702080e7          	jalr	1794(ra) # 80005cec <mbufq_pushtail>
  wakeup(&si->rxq);
    800065f2:	8526                	mv	a0,s1
    800065f4:	ffffb097          	auipc	ra,0xffffb
    800065f8:	0f4080e7          	jalr	244(ra) # 800016e8 <wakeup>
  release(&si->lock);
    800065fc:	854a                	mv	a0,s2
    800065fe:	00001097          	auipc	ra,0x1
    80006602:	bf4080e7          	jalr	-1036(ra) # 800071f2 <release>
  release(&lock);
    80006606:	00019517          	auipc	a0,0x19
    8000660a:	d2a50513          	addi	a0,a0,-726 # 8001f330 <lock>
    8000660e:	00001097          	auipc	ra,0x1
    80006612:	be4080e7          	jalr	-1052(ra) # 800071f2 <release>
    80006616:	a831                	j	80006632 <sockrecvudp+0xb6>
  release(&lock);
    80006618:	00019517          	auipc	a0,0x19
    8000661c:	d1850513          	addi	a0,a0,-744 # 8001f330 <lock>
    80006620:	00001097          	auipc	ra,0x1
    80006624:	bd2080e7          	jalr	-1070(ra) # 800071f2 <release>
  mbuffree(m);
    80006628:	8552                	mv	a0,s4
    8000662a:	fffff097          	auipc	ra,0xfffff
    8000662e:	6aa080e7          	jalr	1706(ra) # 80005cd4 <mbuffree>
}
    80006632:	70e2                	ld	ra,56(sp)
    80006634:	7442                	ld	s0,48(sp)
    80006636:	74a2                	ld	s1,40(sp)
    80006638:	7902                	ld	s2,32(sp)
    8000663a:	69e2                	ld	s3,24(sp)
    8000663c:	6a42                	ld	s4,16(sp)
    8000663e:	6aa2                	ld	s5,8(sp)
    80006640:	6121                	addi	sp,sp,64
    80006642:	8082                	ret

0000000080006644 <pci_init>:
#include "proc.h"
#include "defs.h"

void
pci_init()
{
    80006644:	715d                	addi	sp,sp,-80
    80006646:	e486                	sd	ra,72(sp)
    80006648:	e0a2                	sd	s0,64(sp)
    8000664a:	fc26                	sd	s1,56(sp)
    8000664c:	f84a                	sd	s2,48(sp)
    8000664e:	f44e                	sd	s3,40(sp)
    80006650:	f052                	sd	s4,32(sp)
    80006652:	ec56                	sd	s5,24(sp)
    80006654:	e85a                	sd	s6,16(sp)
    80006656:	e45e                	sd	s7,8(sp)
    80006658:	0880                	addi	s0,sp,80
    8000665a:	300004b7          	lui	s1,0x30000
    uint32 off = (bus << 16) | (dev << 11) | (func << 8) | (offset);
    volatile uint32 *base = ecam + off;
    uint32 id = base[0];
    
    // 100e:8086 is an e1000
    if(id == 0x100e8086){
    8000665e:	100e8937          	lui	s2,0x100e8
    80006662:	08690913          	addi	s2,s2,134 # 100e8086 <_entry-0x6ff17f7a>
      // command and status register.
      // bit 0 : I/O access enable
      // bit 1 : memory access enable
      // bit 2 : enable mastering
      base[1] = 7;
    80006666:	4b9d                	li	s7,7
      for(int i = 0; i < 6; i++){
        uint32 old = base[4+i];

        // writing all 1's to the BAR causes it to be
        // replaced with its size.
        base[4+i] = 0xffffffff;
    80006668:	5afd                	li	s5,-1
        base[4+i] = old;
      }

      // tell the e1000 to reveal its registers at
      // physical address 0x40000000.
      base[4+0] = e1000_regs;
    8000666a:	40000b37          	lui	s6,0x40000
    8000666e:	6a09                	lui	s4,0x2
  for(int dev = 0; dev < 32; dev++){
    80006670:	300409b7          	lui	s3,0x30040
    80006674:	a821                	j	8000668c <pci_init+0x48>
      base[4+0] = e1000_regs;
    80006676:	0166a823          	sw	s6,16(a3)

      e1000_init((uint32*)e1000_regs);
    8000667a:	40000537          	lui	a0,0x40000
    8000667e:	fffff097          	auipc	ra,0xfffff
    80006682:	0e2080e7          	jalr	226(ra) # 80005760 <e1000_init>
  for(int dev = 0; dev < 32; dev++){
    80006686:	94d2                	add	s1,s1,s4
    80006688:	03348a63          	beq	s1,s3,800066bc <pci_init+0x78>
    volatile uint32 *base = ecam + off;
    8000668c:	86a6                	mv	a3,s1
    uint32 id = base[0];
    8000668e:	409c                	lw	a5,0(s1)
    80006690:	2781                	sext.w	a5,a5
    if(id == 0x100e8086){
    80006692:	ff279ae3          	bne	a5,s2,80006686 <pci_init+0x42>
      base[1] = 7;
    80006696:	0174a223          	sw	s7,4(s1) # 30000004 <_entry-0x4ffffffc>
      __sync_synchronize();
    8000669a:	0ff0000f          	fence
      for(int i = 0; i < 6; i++){
    8000669e:	01048793          	addi	a5,s1,16
    800066a2:	02848613          	addi	a2,s1,40
        uint32 old = base[4+i];
    800066a6:	4398                	lw	a4,0(a5)
    800066a8:	2701                	sext.w	a4,a4
        base[4+i] = 0xffffffff;
    800066aa:	0157a023          	sw	s5,0(a5)
        __sync_synchronize();
    800066ae:	0ff0000f          	fence
        base[4+i] = old;
    800066b2:	c398                	sw	a4,0(a5)
      for(int i = 0; i < 6; i++){
    800066b4:	0791                	addi	a5,a5,4
    800066b6:	fec798e3          	bne	a5,a2,800066a6 <pci_init+0x62>
    800066ba:	bf75                	j	80006676 <pci_init+0x32>
    }
  }
}
    800066bc:	60a6                	ld	ra,72(sp)
    800066be:	6406                	ld	s0,64(sp)
    800066c0:	74e2                	ld	s1,56(sp)
    800066c2:	7942                	ld	s2,48(sp)
    800066c4:	79a2                	ld	s3,40(sp)
    800066c6:	7a02                	ld	s4,32(sp)
    800066c8:	6ae2                	ld	s5,24(sp)
    800066ca:	6b42                	ld	s6,16(sp)
    800066cc:	6ba2                	ld	s7,8(sp)
    800066ce:	6161                	addi	sp,sp,80
    800066d0:	8082                	ret

00000000800066d2 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800066d2:	1141                	addi	sp,sp,-16
    800066d4:	e422                	sd	s0,8(sp)
    800066d6:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800066d8:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800066dc:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800066e0:	0037979b          	slliw	a5,a5,0x3
    800066e4:	02004737          	lui	a4,0x2004
    800066e8:	97ba                	add	a5,a5,a4
    800066ea:	0200c737          	lui	a4,0x200c
    800066ee:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800066f2:	000f4637          	lui	a2,0xf4
    800066f6:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800066fa:	95b2                	add	a1,a1,a2
    800066fc:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800066fe:	00269713          	slli	a4,a3,0x2
    80006702:	9736                	add	a4,a4,a3
    80006704:	00371693          	slli	a3,a4,0x3
    80006708:	00019717          	auipc	a4,0x19
    8000670c:	c4870713          	addi	a4,a4,-952 # 8001f350 <timer_scratch>
    80006710:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80006712:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80006714:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80006716:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000671a:	fffff797          	auipc	a5,0xfffff
    8000671e:	9e678793          	addi	a5,a5,-1562 # 80005100 <timervec>
    80006722:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80006726:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000672a:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000672e:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80006732:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80006736:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000673a:	30479073          	csrw	mie,a5
}
    8000673e:	6422                	ld	s0,8(sp)
    80006740:	0141                	addi	sp,sp,16
    80006742:	8082                	ret

0000000080006744 <start>:
{
    80006744:	1141                	addi	sp,sp,-16
    80006746:	e406                	sd	ra,8(sp)
    80006748:	e022                	sd	s0,0(sp)
    8000674a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000674c:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80006750:	7779                	lui	a4,0xffffe
    80006752:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd726f>
    80006756:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80006758:	6705                	lui	a4,0x1
    8000675a:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000675e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80006760:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80006764:	ffffa797          	auipc	a5,0xffffa
    80006768:	bc278793          	addi	a5,a5,-1086 # 80000326 <main>
    8000676c:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80006770:	4781                	li	a5,0
    80006772:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80006776:	67c1                	lui	a5,0x10
    80006778:	17fd                	addi	a5,a5,-1
    8000677a:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000677e:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80006782:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80006786:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000678a:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000678e:	57fd                	li	a5,-1
    80006790:	83a9                	srli	a5,a5,0xa
    80006792:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80006796:	47bd                	li	a5,15
    80006798:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000679c:	00000097          	auipc	ra,0x0
    800067a0:	f36080e7          	jalr	-202(ra) # 800066d2 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800067a4:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800067a8:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800067aa:	823e                	mv	tp,a5
  asm volatile("mret");
    800067ac:	30200073          	mret
}
    800067b0:	60a2                	ld	ra,8(sp)
    800067b2:	6402                	ld	s0,0(sp)
    800067b4:	0141                	addi	sp,sp,16
    800067b6:	8082                	ret

00000000800067b8 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800067b8:	715d                	addi	sp,sp,-80
    800067ba:	e486                	sd	ra,72(sp)
    800067bc:	e0a2                	sd	s0,64(sp)
    800067be:	fc26                	sd	s1,56(sp)
    800067c0:	f84a                	sd	s2,48(sp)
    800067c2:	f44e                	sd	s3,40(sp)
    800067c4:	f052                	sd	s4,32(sp)
    800067c6:	ec56                	sd	s5,24(sp)
    800067c8:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800067ca:	04c05663          	blez	a2,80006816 <consolewrite+0x5e>
    800067ce:	8a2a                	mv	s4,a0
    800067d0:	84ae                	mv	s1,a1
    800067d2:	89b2                	mv	s3,a2
    800067d4:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800067d6:	5afd                	li	s5,-1
    800067d8:	4685                	li	a3,1
    800067da:	8626                	mv	a2,s1
    800067dc:	85d2                	mv	a1,s4
    800067de:	fbf40513          	addi	a0,s0,-65
    800067e2:	ffffb097          	auipc	ra,0xffffb
    800067e6:	174080e7          	jalr	372(ra) # 80001956 <either_copyin>
    800067ea:	01550c63          	beq	a0,s5,80006802 <consolewrite+0x4a>
      break;
    uartputc(c);
    800067ee:	fbf44503          	lbu	a0,-65(s0)
    800067f2:	00000097          	auipc	ra,0x0
    800067f6:	78e080e7          	jalr	1934(ra) # 80006f80 <uartputc>
  for(i = 0; i < n; i++){
    800067fa:	2905                	addiw	s2,s2,1
    800067fc:	0485                	addi	s1,s1,1
    800067fe:	fd299de3          	bne	s3,s2,800067d8 <consolewrite+0x20>
  }

  return i;
}
    80006802:	854a                	mv	a0,s2
    80006804:	60a6                	ld	ra,72(sp)
    80006806:	6406                	ld	s0,64(sp)
    80006808:	74e2                	ld	s1,56(sp)
    8000680a:	7942                	ld	s2,48(sp)
    8000680c:	79a2                	ld	s3,40(sp)
    8000680e:	7a02                	ld	s4,32(sp)
    80006810:	6ae2                	ld	s5,24(sp)
    80006812:	6161                	addi	sp,sp,80
    80006814:	8082                	ret
  for(i = 0; i < n; i++){
    80006816:	4901                	li	s2,0
    80006818:	b7ed                	j	80006802 <consolewrite+0x4a>

000000008000681a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000681a:	7119                	addi	sp,sp,-128
    8000681c:	fc86                	sd	ra,120(sp)
    8000681e:	f8a2                	sd	s0,112(sp)
    80006820:	f4a6                	sd	s1,104(sp)
    80006822:	f0ca                	sd	s2,96(sp)
    80006824:	ecce                	sd	s3,88(sp)
    80006826:	e8d2                	sd	s4,80(sp)
    80006828:	e4d6                	sd	s5,72(sp)
    8000682a:	e0da                	sd	s6,64(sp)
    8000682c:	fc5e                	sd	s7,56(sp)
    8000682e:	f862                	sd	s8,48(sp)
    80006830:	f466                	sd	s9,40(sp)
    80006832:	f06a                	sd	s10,32(sp)
    80006834:	ec6e                	sd	s11,24(sp)
    80006836:	0100                	addi	s0,sp,128
    80006838:	8b2a                	mv	s6,a0
    8000683a:	8aae                	mv	s5,a1
    8000683c:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000683e:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80006842:	00021517          	auipc	a0,0x21
    80006846:	c4e50513          	addi	a0,a0,-946 # 80027490 <cons>
    8000684a:	00001097          	auipc	ra,0x1
    8000684e:	8f4080e7          	jalr	-1804(ra) # 8000713e <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80006852:	00021497          	auipc	s1,0x21
    80006856:	c3e48493          	addi	s1,s1,-962 # 80027490 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000685a:	89a6                	mv	s3,s1
    8000685c:	00021917          	auipc	s2,0x21
    80006860:	ccc90913          	addi	s2,s2,-820 # 80027528 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80006864:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80006866:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80006868:	4da9                	li	s11,10
  while(n > 0){
    8000686a:	07405863          	blez	s4,800068da <consoleread+0xc0>
    while(cons.r == cons.w){
    8000686e:	0984a783          	lw	a5,152(s1)
    80006872:	09c4a703          	lw	a4,156(s1)
    80006876:	02f71463          	bne	a4,a5,8000689e <consoleread+0x84>
      if(myproc()->killed){
    8000687a:	ffffa097          	auipc	ra,0xffffa
    8000687e:	626080e7          	jalr	1574(ra) # 80000ea0 <myproc>
    80006882:	551c                	lw	a5,40(a0)
    80006884:	e7b5                	bnez	a5,800068f0 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80006886:	85ce                	mv	a1,s3
    80006888:	854a                	mv	a0,s2
    8000688a:	ffffb097          	auipc	ra,0xffffb
    8000688e:	cd2080e7          	jalr	-814(ra) # 8000155c <sleep>
    while(cons.r == cons.w){
    80006892:	0984a783          	lw	a5,152(s1)
    80006896:	09c4a703          	lw	a4,156(s1)
    8000689a:	fef700e3          	beq	a4,a5,8000687a <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    8000689e:	0017871b          	addiw	a4,a5,1
    800068a2:	08e4ac23          	sw	a4,152(s1)
    800068a6:	07f7f713          	andi	a4,a5,127
    800068aa:	9726                	add	a4,a4,s1
    800068ac:	01874703          	lbu	a4,24(a4)
    800068b0:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800068b4:	079c0663          	beq	s8,s9,80006920 <consoleread+0x106>
    cbuf = c;
    800068b8:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800068bc:	4685                	li	a3,1
    800068be:	f8f40613          	addi	a2,s0,-113
    800068c2:	85d6                	mv	a1,s5
    800068c4:	855a                	mv	a0,s6
    800068c6:	ffffb097          	auipc	ra,0xffffb
    800068ca:	03a080e7          	jalr	58(ra) # 80001900 <either_copyout>
    800068ce:	01a50663          	beq	a0,s10,800068da <consoleread+0xc0>
    dst++;
    800068d2:	0a85                	addi	s5,s5,1
    --n;
    800068d4:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    800068d6:	f9bc1ae3          	bne	s8,s11,8000686a <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800068da:	00021517          	auipc	a0,0x21
    800068de:	bb650513          	addi	a0,a0,-1098 # 80027490 <cons>
    800068e2:	00001097          	auipc	ra,0x1
    800068e6:	910080e7          	jalr	-1776(ra) # 800071f2 <release>

  return target - n;
    800068ea:	414b853b          	subw	a0,s7,s4
    800068ee:	a811                	j	80006902 <consoleread+0xe8>
        release(&cons.lock);
    800068f0:	00021517          	auipc	a0,0x21
    800068f4:	ba050513          	addi	a0,a0,-1120 # 80027490 <cons>
    800068f8:	00001097          	auipc	ra,0x1
    800068fc:	8fa080e7          	jalr	-1798(ra) # 800071f2 <release>
        return -1;
    80006900:	557d                	li	a0,-1
}
    80006902:	70e6                	ld	ra,120(sp)
    80006904:	7446                	ld	s0,112(sp)
    80006906:	74a6                	ld	s1,104(sp)
    80006908:	7906                	ld	s2,96(sp)
    8000690a:	69e6                	ld	s3,88(sp)
    8000690c:	6a46                	ld	s4,80(sp)
    8000690e:	6aa6                	ld	s5,72(sp)
    80006910:	6b06                	ld	s6,64(sp)
    80006912:	7be2                	ld	s7,56(sp)
    80006914:	7c42                	ld	s8,48(sp)
    80006916:	7ca2                	ld	s9,40(sp)
    80006918:	7d02                	ld	s10,32(sp)
    8000691a:	6de2                	ld	s11,24(sp)
    8000691c:	6109                	addi	sp,sp,128
    8000691e:	8082                	ret
      if(n < target){
    80006920:	000a071b          	sext.w	a4,s4
    80006924:	fb777be3          	bgeu	a4,s7,800068da <consoleread+0xc0>
        cons.r--;
    80006928:	00021717          	auipc	a4,0x21
    8000692c:	c0f72023          	sw	a5,-1024(a4) # 80027528 <cons+0x98>
    80006930:	b76d                	j	800068da <consoleread+0xc0>

0000000080006932 <consputc>:
{
    80006932:	1141                	addi	sp,sp,-16
    80006934:	e406                	sd	ra,8(sp)
    80006936:	e022                	sd	s0,0(sp)
    80006938:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000693a:	10000793          	li	a5,256
    8000693e:	00f50a63          	beq	a0,a5,80006952 <consputc+0x20>
    uartputc_sync(c);
    80006942:	00000097          	auipc	ra,0x0
    80006946:	564080e7          	jalr	1380(ra) # 80006ea6 <uartputc_sync>
}
    8000694a:	60a2                	ld	ra,8(sp)
    8000694c:	6402                	ld	s0,0(sp)
    8000694e:	0141                	addi	sp,sp,16
    80006950:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80006952:	4521                	li	a0,8
    80006954:	00000097          	auipc	ra,0x0
    80006958:	552080e7          	jalr	1362(ra) # 80006ea6 <uartputc_sync>
    8000695c:	02000513          	li	a0,32
    80006960:	00000097          	auipc	ra,0x0
    80006964:	546080e7          	jalr	1350(ra) # 80006ea6 <uartputc_sync>
    80006968:	4521                	li	a0,8
    8000696a:	00000097          	auipc	ra,0x0
    8000696e:	53c080e7          	jalr	1340(ra) # 80006ea6 <uartputc_sync>
    80006972:	bfe1                	j	8000694a <consputc+0x18>

0000000080006974 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80006974:	1101                	addi	sp,sp,-32
    80006976:	ec06                	sd	ra,24(sp)
    80006978:	e822                	sd	s0,16(sp)
    8000697a:	e426                	sd	s1,8(sp)
    8000697c:	e04a                	sd	s2,0(sp)
    8000697e:	1000                	addi	s0,sp,32
    80006980:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80006982:	00021517          	auipc	a0,0x21
    80006986:	b0e50513          	addi	a0,a0,-1266 # 80027490 <cons>
    8000698a:	00000097          	auipc	ra,0x0
    8000698e:	7b4080e7          	jalr	1972(ra) # 8000713e <acquire>

  switch(c){
    80006992:	47d5                	li	a5,21
    80006994:	0af48663          	beq	s1,a5,80006a40 <consoleintr+0xcc>
    80006998:	0297ca63          	blt	a5,s1,800069cc <consoleintr+0x58>
    8000699c:	47a1                	li	a5,8
    8000699e:	0ef48763          	beq	s1,a5,80006a8c <consoleintr+0x118>
    800069a2:	47c1                	li	a5,16
    800069a4:	10f49a63          	bne	s1,a5,80006ab8 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800069a8:	ffffb097          	auipc	ra,0xffffb
    800069ac:	004080e7          	jalr	4(ra) # 800019ac <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800069b0:	00021517          	auipc	a0,0x21
    800069b4:	ae050513          	addi	a0,a0,-1312 # 80027490 <cons>
    800069b8:	00001097          	auipc	ra,0x1
    800069bc:	83a080e7          	jalr	-1990(ra) # 800071f2 <release>
}
    800069c0:	60e2                	ld	ra,24(sp)
    800069c2:	6442                	ld	s0,16(sp)
    800069c4:	64a2                	ld	s1,8(sp)
    800069c6:	6902                	ld	s2,0(sp)
    800069c8:	6105                	addi	sp,sp,32
    800069ca:	8082                	ret
  switch(c){
    800069cc:	07f00793          	li	a5,127
    800069d0:	0af48e63          	beq	s1,a5,80006a8c <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800069d4:	00021717          	auipc	a4,0x21
    800069d8:	abc70713          	addi	a4,a4,-1348 # 80027490 <cons>
    800069dc:	0a072783          	lw	a5,160(a4)
    800069e0:	09872703          	lw	a4,152(a4)
    800069e4:	9f99                	subw	a5,a5,a4
    800069e6:	07f00713          	li	a4,127
    800069ea:	fcf763e3          	bltu	a4,a5,800069b0 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    800069ee:	47b5                	li	a5,13
    800069f0:	0cf48763          	beq	s1,a5,80006abe <consoleintr+0x14a>
      consputc(c);
    800069f4:	8526                	mv	a0,s1
    800069f6:	00000097          	auipc	ra,0x0
    800069fa:	f3c080e7          	jalr	-196(ra) # 80006932 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800069fe:	00021797          	auipc	a5,0x21
    80006a02:	a9278793          	addi	a5,a5,-1390 # 80027490 <cons>
    80006a06:	0a07a703          	lw	a4,160(a5)
    80006a0a:	0017069b          	addiw	a3,a4,1
    80006a0e:	0006861b          	sext.w	a2,a3
    80006a12:	0ad7a023          	sw	a3,160(a5)
    80006a16:	07f77713          	andi	a4,a4,127
    80006a1a:	97ba                	add	a5,a5,a4
    80006a1c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80006a20:	47a9                	li	a5,10
    80006a22:	0cf48563          	beq	s1,a5,80006aec <consoleintr+0x178>
    80006a26:	4791                	li	a5,4
    80006a28:	0cf48263          	beq	s1,a5,80006aec <consoleintr+0x178>
    80006a2c:	00021797          	auipc	a5,0x21
    80006a30:	afc7a783          	lw	a5,-1284(a5) # 80027528 <cons+0x98>
    80006a34:	0807879b          	addiw	a5,a5,128
    80006a38:	f6f61ce3          	bne	a2,a5,800069b0 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006a3c:	863e                	mv	a2,a5
    80006a3e:	a07d                	j	80006aec <consoleintr+0x178>
    while(cons.e != cons.w &&
    80006a40:	00021717          	auipc	a4,0x21
    80006a44:	a5070713          	addi	a4,a4,-1456 # 80027490 <cons>
    80006a48:	0a072783          	lw	a5,160(a4)
    80006a4c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006a50:	00021497          	auipc	s1,0x21
    80006a54:	a4048493          	addi	s1,s1,-1472 # 80027490 <cons>
    while(cons.e != cons.w &&
    80006a58:	4929                	li	s2,10
    80006a5a:	f4f70be3          	beq	a4,a5,800069b0 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006a5e:	37fd                	addiw	a5,a5,-1
    80006a60:	07f7f713          	andi	a4,a5,127
    80006a64:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80006a66:	01874703          	lbu	a4,24(a4)
    80006a6a:	f52703e3          	beq	a4,s2,800069b0 <consoleintr+0x3c>
      cons.e--;
    80006a6e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80006a72:	10000513          	li	a0,256
    80006a76:	00000097          	auipc	ra,0x0
    80006a7a:	ebc080e7          	jalr	-324(ra) # 80006932 <consputc>
    while(cons.e != cons.w &&
    80006a7e:	0a04a783          	lw	a5,160(s1)
    80006a82:	09c4a703          	lw	a4,156(s1)
    80006a86:	fcf71ce3          	bne	a4,a5,80006a5e <consoleintr+0xea>
    80006a8a:	b71d                	j	800069b0 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80006a8c:	00021717          	auipc	a4,0x21
    80006a90:	a0470713          	addi	a4,a4,-1532 # 80027490 <cons>
    80006a94:	0a072783          	lw	a5,160(a4)
    80006a98:	09c72703          	lw	a4,156(a4)
    80006a9c:	f0f70ae3          	beq	a4,a5,800069b0 <consoleintr+0x3c>
      cons.e--;
    80006aa0:	37fd                	addiw	a5,a5,-1
    80006aa2:	00021717          	auipc	a4,0x21
    80006aa6:	a8f72723          	sw	a5,-1394(a4) # 80027530 <cons+0xa0>
      consputc(BACKSPACE);
    80006aaa:	10000513          	li	a0,256
    80006aae:	00000097          	auipc	ra,0x0
    80006ab2:	e84080e7          	jalr	-380(ra) # 80006932 <consputc>
    80006ab6:	bded                	j	800069b0 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80006ab8:	ee048ce3          	beqz	s1,800069b0 <consoleintr+0x3c>
    80006abc:	bf21                	j	800069d4 <consoleintr+0x60>
      consputc(c);
    80006abe:	4529                	li	a0,10
    80006ac0:	00000097          	auipc	ra,0x0
    80006ac4:	e72080e7          	jalr	-398(ra) # 80006932 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006ac8:	00021797          	auipc	a5,0x21
    80006acc:	9c878793          	addi	a5,a5,-1592 # 80027490 <cons>
    80006ad0:	0a07a703          	lw	a4,160(a5)
    80006ad4:	0017069b          	addiw	a3,a4,1
    80006ad8:	0006861b          	sext.w	a2,a3
    80006adc:	0ad7a023          	sw	a3,160(a5)
    80006ae0:	07f77713          	andi	a4,a4,127
    80006ae4:	97ba                	add	a5,a5,a4
    80006ae6:	4729                	li	a4,10
    80006ae8:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80006aec:	00021797          	auipc	a5,0x21
    80006af0:	a4c7a023          	sw	a2,-1472(a5) # 8002752c <cons+0x9c>
        wakeup(&cons.r);
    80006af4:	00021517          	auipc	a0,0x21
    80006af8:	a3450513          	addi	a0,a0,-1484 # 80027528 <cons+0x98>
    80006afc:	ffffb097          	auipc	ra,0xffffb
    80006b00:	bec080e7          	jalr	-1044(ra) # 800016e8 <wakeup>
    80006b04:	b575                	j	800069b0 <consoleintr+0x3c>

0000000080006b06 <consoleinit>:

void
consoleinit(void)
{
    80006b06:	1141                	addi	sp,sp,-16
    80006b08:	e406                	sd	ra,8(sp)
    80006b0a:	e022                	sd	s0,0(sp)
    80006b0c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006b0e:	00003597          	auipc	a1,0x3
    80006b12:	d1258593          	addi	a1,a1,-750 # 80009820 <syscalls+0x448>
    80006b16:	00021517          	auipc	a0,0x21
    80006b1a:	97a50513          	addi	a0,a0,-1670 # 80027490 <cons>
    80006b1e:	00000097          	auipc	ra,0x0
    80006b22:	590080e7          	jalr	1424(ra) # 800070ae <initlock>

  uartinit();
    80006b26:	00000097          	auipc	ra,0x0
    80006b2a:	330080e7          	jalr	816(ra) # 80006e56 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80006b2e:	00013797          	auipc	a5,0x13
    80006b32:	5ba78793          	addi	a5,a5,1466 # 8001a0e8 <devsw>
    80006b36:	00000717          	auipc	a4,0x0
    80006b3a:	ce470713          	addi	a4,a4,-796 # 8000681a <consoleread>
    80006b3e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006b40:	00000717          	auipc	a4,0x0
    80006b44:	c7870713          	addi	a4,a4,-904 # 800067b8 <consolewrite>
    80006b48:	ef98                	sd	a4,24(a5)
}
    80006b4a:	60a2                	ld	ra,8(sp)
    80006b4c:	6402                	ld	s0,0(sp)
    80006b4e:	0141                	addi	sp,sp,16
    80006b50:	8082                	ret

0000000080006b52 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80006b52:	7179                	addi	sp,sp,-48
    80006b54:	f406                	sd	ra,40(sp)
    80006b56:	f022                	sd	s0,32(sp)
    80006b58:	ec26                	sd	s1,24(sp)
    80006b5a:	e84a                	sd	s2,16(sp)
    80006b5c:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80006b5e:	c219                	beqz	a2,80006b64 <printint+0x12>
    80006b60:	08054663          	bltz	a0,80006bec <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80006b64:	2501                	sext.w	a0,a0
    80006b66:	4881                	li	a7,0
    80006b68:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006b6c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006b6e:	2581                	sext.w	a1,a1
    80006b70:	00003617          	auipc	a2,0x3
    80006b74:	ce060613          	addi	a2,a2,-800 # 80009850 <digits>
    80006b78:	883a                	mv	a6,a4
    80006b7a:	2705                	addiw	a4,a4,1
    80006b7c:	02b577bb          	remuw	a5,a0,a1
    80006b80:	1782                	slli	a5,a5,0x20
    80006b82:	9381                	srli	a5,a5,0x20
    80006b84:	97b2                	add	a5,a5,a2
    80006b86:	0007c783          	lbu	a5,0(a5)
    80006b8a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006b8e:	0005079b          	sext.w	a5,a0
    80006b92:	02b5553b          	divuw	a0,a0,a1
    80006b96:	0685                	addi	a3,a3,1
    80006b98:	feb7f0e3          	bgeu	a5,a1,80006b78 <printint+0x26>

  if(sign)
    80006b9c:	00088b63          	beqz	a7,80006bb2 <printint+0x60>
    buf[i++] = '-';
    80006ba0:	fe040793          	addi	a5,s0,-32
    80006ba4:	973e                	add	a4,a4,a5
    80006ba6:	02d00793          	li	a5,45
    80006baa:	fef70823          	sb	a5,-16(a4)
    80006bae:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006bb2:	02e05763          	blez	a4,80006be0 <printint+0x8e>
    80006bb6:	fd040793          	addi	a5,s0,-48
    80006bba:	00e784b3          	add	s1,a5,a4
    80006bbe:	fff78913          	addi	s2,a5,-1
    80006bc2:	993a                	add	s2,s2,a4
    80006bc4:	377d                	addiw	a4,a4,-1
    80006bc6:	1702                	slli	a4,a4,0x20
    80006bc8:	9301                	srli	a4,a4,0x20
    80006bca:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006bce:	fff4c503          	lbu	a0,-1(s1)
    80006bd2:	00000097          	auipc	ra,0x0
    80006bd6:	d60080e7          	jalr	-672(ra) # 80006932 <consputc>
  while(--i >= 0)
    80006bda:	14fd                	addi	s1,s1,-1
    80006bdc:	ff2499e3          	bne	s1,s2,80006bce <printint+0x7c>
}
    80006be0:	70a2                	ld	ra,40(sp)
    80006be2:	7402                	ld	s0,32(sp)
    80006be4:	64e2                	ld	s1,24(sp)
    80006be6:	6942                	ld	s2,16(sp)
    80006be8:	6145                	addi	sp,sp,48
    80006bea:	8082                	ret
    x = -xx;
    80006bec:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006bf0:	4885                	li	a7,1
    x = -xx;
    80006bf2:	bf9d                	j	80006b68 <printint+0x16>

0000000080006bf4 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006bf4:	1101                	addi	sp,sp,-32
    80006bf6:	ec06                	sd	ra,24(sp)
    80006bf8:	e822                	sd	s0,16(sp)
    80006bfa:	e426                	sd	s1,8(sp)
    80006bfc:	1000                	addi	s0,sp,32
    80006bfe:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006c00:	00021797          	auipc	a5,0x21
    80006c04:	9407a823          	sw	zero,-1712(a5) # 80027550 <pr+0x18>
  printf("panic: ");
    80006c08:	00003517          	auipc	a0,0x3
    80006c0c:	c2050513          	addi	a0,a0,-992 # 80009828 <syscalls+0x450>
    80006c10:	00000097          	auipc	ra,0x0
    80006c14:	02e080e7          	jalr	46(ra) # 80006c3e <printf>
  printf(s);
    80006c18:	8526                	mv	a0,s1
    80006c1a:	00000097          	auipc	ra,0x0
    80006c1e:	024080e7          	jalr	36(ra) # 80006c3e <printf>
  printf("\n");
    80006c22:	00002517          	auipc	a0,0x2
    80006c26:	42650513          	addi	a0,a0,1062 # 80009048 <etext+0x48>
    80006c2a:	00000097          	auipc	ra,0x0
    80006c2e:	014080e7          	jalr	20(ra) # 80006c3e <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006c32:	4785                	li	a5,1
    80006c34:	00003717          	auipc	a4,0x3
    80006c38:	3ef72e23          	sw	a5,1020(a4) # 8000a030 <panicked>
  for(;;)
    80006c3c:	a001                	j	80006c3c <panic+0x48>

0000000080006c3e <printf>:
{
    80006c3e:	7131                	addi	sp,sp,-192
    80006c40:	fc86                	sd	ra,120(sp)
    80006c42:	f8a2                	sd	s0,112(sp)
    80006c44:	f4a6                	sd	s1,104(sp)
    80006c46:	f0ca                	sd	s2,96(sp)
    80006c48:	ecce                	sd	s3,88(sp)
    80006c4a:	e8d2                	sd	s4,80(sp)
    80006c4c:	e4d6                	sd	s5,72(sp)
    80006c4e:	e0da                	sd	s6,64(sp)
    80006c50:	fc5e                	sd	s7,56(sp)
    80006c52:	f862                	sd	s8,48(sp)
    80006c54:	f466                	sd	s9,40(sp)
    80006c56:	f06a                	sd	s10,32(sp)
    80006c58:	ec6e                	sd	s11,24(sp)
    80006c5a:	0100                	addi	s0,sp,128
    80006c5c:	8a2a                	mv	s4,a0
    80006c5e:	e40c                	sd	a1,8(s0)
    80006c60:	e810                	sd	a2,16(s0)
    80006c62:	ec14                	sd	a3,24(s0)
    80006c64:	f018                	sd	a4,32(s0)
    80006c66:	f41c                	sd	a5,40(s0)
    80006c68:	03043823          	sd	a6,48(s0)
    80006c6c:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006c70:	00021d97          	auipc	s11,0x21
    80006c74:	8e0dad83          	lw	s11,-1824(s11) # 80027550 <pr+0x18>
  if(locking)
    80006c78:	020d9b63          	bnez	s11,80006cae <printf+0x70>
  if (fmt == 0)
    80006c7c:	040a0263          	beqz	s4,80006cc0 <printf+0x82>
  va_start(ap, fmt);
    80006c80:	00840793          	addi	a5,s0,8
    80006c84:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006c88:	000a4503          	lbu	a0,0(s4) # 2000 <_entry-0x7fffe000>
    80006c8c:	16050263          	beqz	a0,80006df0 <printf+0x1b2>
    80006c90:	4481                	li	s1,0
    if(c != '%'){
    80006c92:	02500a93          	li	s5,37
    switch(c){
    80006c96:	07000b13          	li	s6,112
  consputc('x');
    80006c9a:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006c9c:	00003b97          	auipc	s7,0x3
    80006ca0:	bb4b8b93          	addi	s7,s7,-1100 # 80009850 <digits>
    switch(c){
    80006ca4:	07300c93          	li	s9,115
    80006ca8:	06400c13          	li	s8,100
    80006cac:	a82d                	j	80006ce6 <printf+0xa8>
    acquire(&pr.lock);
    80006cae:	00021517          	auipc	a0,0x21
    80006cb2:	88a50513          	addi	a0,a0,-1910 # 80027538 <pr>
    80006cb6:	00000097          	auipc	ra,0x0
    80006cba:	488080e7          	jalr	1160(ra) # 8000713e <acquire>
    80006cbe:	bf7d                	j	80006c7c <printf+0x3e>
    panic("null fmt");
    80006cc0:	00003517          	auipc	a0,0x3
    80006cc4:	b7850513          	addi	a0,a0,-1160 # 80009838 <syscalls+0x460>
    80006cc8:	00000097          	auipc	ra,0x0
    80006ccc:	f2c080e7          	jalr	-212(ra) # 80006bf4 <panic>
      consputc(c);
    80006cd0:	00000097          	auipc	ra,0x0
    80006cd4:	c62080e7          	jalr	-926(ra) # 80006932 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006cd8:	2485                	addiw	s1,s1,1
    80006cda:	009a07b3          	add	a5,s4,s1
    80006cde:	0007c503          	lbu	a0,0(a5)
    80006ce2:	10050763          	beqz	a0,80006df0 <printf+0x1b2>
    if(c != '%'){
    80006ce6:	ff5515e3          	bne	a0,s5,80006cd0 <printf+0x92>
    c = fmt[++i] & 0xff;
    80006cea:	2485                	addiw	s1,s1,1
    80006cec:	009a07b3          	add	a5,s4,s1
    80006cf0:	0007c783          	lbu	a5,0(a5)
    80006cf4:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80006cf8:	cfe5                	beqz	a5,80006df0 <printf+0x1b2>
    switch(c){
    80006cfa:	05678a63          	beq	a5,s6,80006d4e <printf+0x110>
    80006cfe:	02fb7663          	bgeu	s6,a5,80006d2a <printf+0xec>
    80006d02:	09978963          	beq	a5,s9,80006d94 <printf+0x156>
    80006d06:	07800713          	li	a4,120
    80006d0a:	0ce79863          	bne	a5,a4,80006dda <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80006d0e:	f8843783          	ld	a5,-120(s0)
    80006d12:	00878713          	addi	a4,a5,8
    80006d16:	f8e43423          	sd	a4,-120(s0)
    80006d1a:	4605                	li	a2,1
    80006d1c:	85ea                	mv	a1,s10
    80006d1e:	4388                	lw	a0,0(a5)
    80006d20:	00000097          	auipc	ra,0x0
    80006d24:	e32080e7          	jalr	-462(ra) # 80006b52 <printint>
      break;
    80006d28:	bf45                	j	80006cd8 <printf+0x9a>
    switch(c){
    80006d2a:	0b578263          	beq	a5,s5,80006dce <printf+0x190>
    80006d2e:	0b879663          	bne	a5,s8,80006dda <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80006d32:	f8843783          	ld	a5,-120(s0)
    80006d36:	00878713          	addi	a4,a5,8
    80006d3a:	f8e43423          	sd	a4,-120(s0)
    80006d3e:	4605                	li	a2,1
    80006d40:	45a9                	li	a1,10
    80006d42:	4388                	lw	a0,0(a5)
    80006d44:	00000097          	auipc	ra,0x0
    80006d48:	e0e080e7          	jalr	-498(ra) # 80006b52 <printint>
      break;
    80006d4c:	b771                	j	80006cd8 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006d4e:	f8843783          	ld	a5,-120(s0)
    80006d52:	00878713          	addi	a4,a5,8
    80006d56:	f8e43423          	sd	a4,-120(s0)
    80006d5a:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80006d5e:	03000513          	li	a0,48
    80006d62:	00000097          	auipc	ra,0x0
    80006d66:	bd0080e7          	jalr	-1072(ra) # 80006932 <consputc>
  consputc('x');
    80006d6a:	07800513          	li	a0,120
    80006d6e:	00000097          	auipc	ra,0x0
    80006d72:	bc4080e7          	jalr	-1084(ra) # 80006932 <consputc>
    80006d76:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006d78:	03c9d793          	srli	a5,s3,0x3c
    80006d7c:	97de                	add	a5,a5,s7
    80006d7e:	0007c503          	lbu	a0,0(a5)
    80006d82:	00000097          	auipc	ra,0x0
    80006d86:	bb0080e7          	jalr	-1104(ra) # 80006932 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006d8a:	0992                	slli	s3,s3,0x4
    80006d8c:	397d                	addiw	s2,s2,-1
    80006d8e:	fe0915e3          	bnez	s2,80006d78 <printf+0x13a>
    80006d92:	b799                	j	80006cd8 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006d94:	f8843783          	ld	a5,-120(s0)
    80006d98:	00878713          	addi	a4,a5,8
    80006d9c:	f8e43423          	sd	a4,-120(s0)
    80006da0:	0007b903          	ld	s2,0(a5)
    80006da4:	00090e63          	beqz	s2,80006dc0 <printf+0x182>
      for(; *s; s++)
    80006da8:	00094503          	lbu	a0,0(s2)
    80006dac:	d515                	beqz	a0,80006cd8 <printf+0x9a>
        consputc(*s);
    80006dae:	00000097          	auipc	ra,0x0
    80006db2:	b84080e7          	jalr	-1148(ra) # 80006932 <consputc>
      for(; *s; s++)
    80006db6:	0905                	addi	s2,s2,1
    80006db8:	00094503          	lbu	a0,0(s2)
    80006dbc:	f96d                	bnez	a0,80006dae <printf+0x170>
    80006dbe:	bf29                	j	80006cd8 <printf+0x9a>
        s = "(null)";
    80006dc0:	00003917          	auipc	s2,0x3
    80006dc4:	a7090913          	addi	s2,s2,-1424 # 80009830 <syscalls+0x458>
      for(; *s; s++)
    80006dc8:	02800513          	li	a0,40
    80006dcc:	b7cd                	j	80006dae <printf+0x170>
      consputc('%');
    80006dce:	8556                	mv	a0,s5
    80006dd0:	00000097          	auipc	ra,0x0
    80006dd4:	b62080e7          	jalr	-1182(ra) # 80006932 <consputc>
      break;
    80006dd8:	b701                	j	80006cd8 <printf+0x9a>
      consputc('%');
    80006dda:	8556                	mv	a0,s5
    80006ddc:	00000097          	auipc	ra,0x0
    80006de0:	b56080e7          	jalr	-1194(ra) # 80006932 <consputc>
      consputc(c);
    80006de4:	854a                	mv	a0,s2
    80006de6:	00000097          	auipc	ra,0x0
    80006dea:	b4c080e7          	jalr	-1204(ra) # 80006932 <consputc>
      break;
    80006dee:	b5ed                	j	80006cd8 <printf+0x9a>
  if(locking)
    80006df0:	020d9163          	bnez	s11,80006e12 <printf+0x1d4>
}
    80006df4:	70e6                	ld	ra,120(sp)
    80006df6:	7446                	ld	s0,112(sp)
    80006df8:	74a6                	ld	s1,104(sp)
    80006dfa:	7906                	ld	s2,96(sp)
    80006dfc:	69e6                	ld	s3,88(sp)
    80006dfe:	6a46                	ld	s4,80(sp)
    80006e00:	6aa6                	ld	s5,72(sp)
    80006e02:	6b06                	ld	s6,64(sp)
    80006e04:	7be2                	ld	s7,56(sp)
    80006e06:	7c42                	ld	s8,48(sp)
    80006e08:	7ca2                	ld	s9,40(sp)
    80006e0a:	7d02                	ld	s10,32(sp)
    80006e0c:	6de2                	ld	s11,24(sp)
    80006e0e:	6129                	addi	sp,sp,192
    80006e10:	8082                	ret
    release(&pr.lock);
    80006e12:	00020517          	auipc	a0,0x20
    80006e16:	72650513          	addi	a0,a0,1830 # 80027538 <pr>
    80006e1a:	00000097          	auipc	ra,0x0
    80006e1e:	3d8080e7          	jalr	984(ra) # 800071f2 <release>
}
    80006e22:	bfc9                	j	80006df4 <printf+0x1b6>

0000000080006e24 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006e24:	1101                	addi	sp,sp,-32
    80006e26:	ec06                	sd	ra,24(sp)
    80006e28:	e822                	sd	s0,16(sp)
    80006e2a:	e426                	sd	s1,8(sp)
    80006e2c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006e2e:	00020497          	auipc	s1,0x20
    80006e32:	70a48493          	addi	s1,s1,1802 # 80027538 <pr>
    80006e36:	00003597          	auipc	a1,0x3
    80006e3a:	a1258593          	addi	a1,a1,-1518 # 80009848 <syscalls+0x470>
    80006e3e:	8526                	mv	a0,s1
    80006e40:	00000097          	auipc	ra,0x0
    80006e44:	26e080e7          	jalr	622(ra) # 800070ae <initlock>
  pr.locking = 1;
    80006e48:	4785                	li	a5,1
    80006e4a:	cc9c                	sw	a5,24(s1)
}
    80006e4c:	60e2                	ld	ra,24(sp)
    80006e4e:	6442                	ld	s0,16(sp)
    80006e50:	64a2                	ld	s1,8(sp)
    80006e52:	6105                	addi	sp,sp,32
    80006e54:	8082                	ret

0000000080006e56 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006e56:	1141                	addi	sp,sp,-16
    80006e58:	e406                	sd	ra,8(sp)
    80006e5a:	e022                	sd	s0,0(sp)
    80006e5c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006e5e:	100007b7          	lui	a5,0x10000
    80006e62:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006e66:	f8000713          	li	a4,-128
    80006e6a:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006e6e:	470d                	li	a4,3
    80006e70:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006e74:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006e78:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006e7c:	469d                	li	a3,7
    80006e7e:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006e82:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006e86:	00003597          	auipc	a1,0x3
    80006e8a:	9e258593          	addi	a1,a1,-1566 # 80009868 <digits+0x18>
    80006e8e:	00020517          	auipc	a0,0x20
    80006e92:	6ca50513          	addi	a0,a0,1738 # 80027558 <uart_tx_lock>
    80006e96:	00000097          	auipc	ra,0x0
    80006e9a:	218080e7          	jalr	536(ra) # 800070ae <initlock>
}
    80006e9e:	60a2                	ld	ra,8(sp)
    80006ea0:	6402                	ld	s0,0(sp)
    80006ea2:	0141                	addi	sp,sp,16
    80006ea4:	8082                	ret

0000000080006ea6 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006ea6:	1101                	addi	sp,sp,-32
    80006ea8:	ec06                	sd	ra,24(sp)
    80006eaa:	e822                	sd	s0,16(sp)
    80006eac:	e426                	sd	s1,8(sp)
    80006eae:	1000                	addi	s0,sp,32
    80006eb0:	84aa                	mv	s1,a0
  push_off();
    80006eb2:	00000097          	auipc	ra,0x0
    80006eb6:	240080e7          	jalr	576(ra) # 800070f2 <push_off>

  if(panicked){
    80006eba:	00003797          	auipc	a5,0x3
    80006ebe:	1767a783          	lw	a5,374(a5) # 8000a030 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006ec2:	10000737          	lui	a4,0x10000
  if(panicked){
    80006ec6:	c391                	beqz	a5,80006eca <uartputc_sync+0x24>
    for(;;)
    80006ec8:	a001                	j	80006ec8 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006eca:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006ece:	0ff7f793          	andi	a5,a5,255
    80006ed2:	0207f793          	andi	a5,a5,32
    80006ed6:	dbf5                	beqz	a5,80006eca <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006ed8:	0ff4f793          	andi	a5,s1,255
    80006edc:	10000737          	lui	a4,0x10000
    80006ee0:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006ee4:	00000097          	auipc	ra,0x0
    80006ee8:	2ae080e7          	jalr	686(ra) # 80007192 <pop_off>
}
    80006eec:	60e2                	ld	ra,24(sp)
    80006eee:	6442                	ld	s0,16(sp)
    80006ef0:	64a2                	ld	s1,8(sp)
    80006ef2:	6105                	addi	sp,sp,32
    80006ef4:	8082                	ret

0000000080006ef6 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006ef6:	00003717          	auipc	a4,0x3
    80006efa:	14273703          	ld	a4,322(a4) # 8000a038 <uart_tx_r>
    80006efe:	00003797          	auipc	a5,0x3
    80006f02:	1427b783          	ld	a5,322(a5) # 8000a040 <uart_tx_w>
    80006f06:	06e78c63          	beq	a5,a4,80006f7e <uartstart+0x88>
{
    80006f0a:	7139                	addi	sp,sp,-64
    80006f0c:	fc06                	sd	ra,56(sp)
    80006f0e:	f822                	sd	s0,48(sp)
    80006f10:	f426                	sd	s1,40(sp)
    80006f12:	f04a                	sd	s2,32(sp)
    80006f14:	ec4e                	sd	s3,24(sp)
    80006f16:	e852                	sd	s4,16(sp)
    80006f18:	e456                	sd	s5,8(sp)
    80006f1a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006f1c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006f20:	00020a17          	auipc	s4,0x20
    80006f24:	638a0a13          	addi	s4,s4,1592 # 80027558 <uart_tx_lock>
    uart_tx_r += 1;
    80006f28:	00003497          	auipc	s1,0x3
    80006f2c:	11048493          	addi	s1,s1,272 # 8000a038 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006f30:	00003997          	auipc	s3,0x3
    80006f34:	11098993          	addi	s3,s3,272 # 8000a040 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006f38:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006f3c:	0ff7f793          	andi	a5,a5,255
    80006f40:	0207f793          	andi	a5,a5,32
    80006f44:	c785                	beqz	a5,80006f6c <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006f46:	01f77793          	andi	a5,a4,31
    80006f4a:	97d2                	add	a5,a5,s4
    80006f4c:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006f50:	0705                	addi	a4,a4,1
    80006f52:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006f54:	8526                	mv	a0,s1
    80006f56:	ffffa097          	auipc	ra,0xffffa
    80006f5a:	792080e7          	jalr	1938(ra) # 800016e8 <wakeup>
    
    WriteReg(THR, c);
    80006f5e:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006f62:	6098                	ld	a4,0(s1)
    80006f64:	0009b783          	ld	a5,0(s3)
    80006f68:	fce798e3          	bne	a5,a4,80006f38 <uartstart+0x42>
  }
}
    80006f6c:	70e2                	ld	ra,56(sp)
    80006f6e:	7442                	ld	s0,48(sp)
    80006f70:	74a2                	ld	s1,40(sp)
    80006f72:	7902                	ld	s2,32(sp)
    80006f74:	69e2                	ld	s3,24(sp)
    80006f76:	6a42                	ld	s4,16(sp)
    80006f78:	6aa2                	ld	s5,8(sp)
    80006f7a:	6121                	addi	sp,sp,64
    80006f7c:	8082                	ret
    80006f7e:	8082                	ret

0000000080006f80 <uartputc>:
{
    80006f80:	7179                	addi	sp,sp,-48
    80006f82:	f406                	sd	ra,40(sp)
    80006f84:	f022                	sd	s0,32(sp)
    80006f86:	ec26                	sd	s1,24(sp)
    80006f88:	e84a                	sd	s2,16(sp)
    80006f8a:	e44e                	sd	s3,8(sp)
    80006f8c:	e052                	sd	s4,0(sp)
    80006f8e:	1800                	addi	s0,sp,48
    80006f90:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006f92:	00020517          	auipc	a0,0x20
    80006f96:	5c650513          	addi	a0,a0,1478 # 80027558 <uart_tx_lock>
    80006f9a:	00000097          	auipc	ra,0x0
    80006f9e:	1a4080e7          	jalr	420(ra) # 8000713e <acquire>
  if(panicked){
    80006fa2:	00003797          	auipc	a5,0x3
    80006fa6:	08e7a783          	lw	a5,142(a5) # 8000a030 <panicked>
    80006faa:	c391                	beqz	a5,80006fae <uartputc+0x2e>
    for(;;)
    80006fac:	a001                	j	80006fac <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006fae:	00003797          	auipc	a5,0x3
    80006fb2:	0927b783          	ld	a5,146(a5) # 8000a040 <uart_tx_w>
    80006fb6:	00003717          	auipc	a4,0x3
    80006fba:	08273703          	ld	a4,130(a4) # 8000a038 <uart_tx_r>
    80006fbe:	02070713          	addi	a4,a4,32
    80006fc2:	02f71b63          	bne	a4,a5,80006ff8 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006fc6:	00020a17          	auipc	s4,0x20
    80006fca:	592a0a13          	addi	s4,s4,1426 # 80027558 <uart_tx_lock>
    80006fce:	00003497          	auipc	s1,0x3
    80006fd2:	06a48493          	addi	s1,s1,106 # 8000a038 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006fd6:	00003917          	auipc	s2,0x3
    80006fda:	06a90913          	addi	s2,s2,106 # 8000a040 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006fde:	85d2                	mv	a1,s4
    80006fe0:	8526                	mv	a0,s1
    80006fe2:	ffffa097          	auipc	ra,0xffffa
    80006fe6:	57a080e7          	jalr	1402(ra) # 8000155c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006fea:	00093783          	ld	a5,0(s2)
    80006fee:	6098                	ld	a4,0(s1)
    80006ff0:	02070713          	addi	a4,a4,32
    80006ff4:	fef705e3          	beq	a4,a5,80006fde <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006ff8:	00020497          	auipc	s1,0x20
    80006ffc:	56048493          	addi	s1,s1,1376 # 80027558 <uart_tx_lock>
    80007000:	01f7f713          	andi	a4,a5,31
    80007004:	9726                	add	a4,a4,s1
    80007006:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000700a:	0785                	addi	a5,a5,1
    8000700c:	00003717          	auipc	a4,0x3
    80007010:	02f73a23          	sd	a5,52(a4) # 8000a040 <uart_tx_w>
      uartstart();
    80007014:	00000097          	auipc	ra,0x0
    80007018:	ee2080e7          	jalr	-286(ra) # 80006ef6 <uartstart>
      release(&uart_tx_lock);
    8000701c:	8526                	mv	a0,s1
    8000701e:	00000097          	auipc	ra,0x0
    80007022:	1d4080e7          	jalr	468(ra) # 800071f2 <release>
}
    80007026:	70a2                	ld	ra,40(sp)
    80007028:	7402                	ld	s0,32(sp)
    8000702a:	64e2                	ld	s1,24(sp)
    8000702c:	6942                	ld	s2,16(sp)
    8000702e:	69a2                	ld	s3,8(sp)
    80007030:	6a02                	ld	s4,0(sp)
    80007032:	6145                	addi	sp,sp,48
    80007034:	8082                	ret

0000000080007036 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80007036:	1141                	addi	sp,sp,-16
    80007038:	e422                	sd	s0,8(sp)
    8000703a:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000703c:	100007b7          	lui	a5,0x10000
    80007040:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80007044:	8b85                	andi	a5,a5,1
    80007046:	cb91                	beqz	a5,8000705a <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80007048:	100007b7          	lui	a5,0x10000
    8000704c:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80007050:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80007054:	6422                	ld	s0,8(sp)
    80007056:	0141                	addi	sp,sp,16
    80007058:	8082                	ret
    return -1;
    8000705a:	557d                	li	a0,-1
    8000705c:	bfe5                	j	80007054 <uartgetc+0x1e>

000000008000705e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    8000705e:	1101                	addi	sp,sp,-32
    80007060:	ec06                	sd	ra,24(sp)
    80007062:	e822                	sd	s0,16(sp)
    80007064:	e426                	sd	s1,8(sp)
    80007066:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80007068:	54fd                	li	s1,-1
    int c = uartgetc();
    8000706a:	00000097          	auipc	ra,0x0
    8000706e:	fcc080e7          	jalr	-52(ra) # 80007036 <uartgetc>
    if(c == -1)
    80007072:	00950763          	beq	a0,s1,80007080 <uartintr+0x22>
      break;
    consoleintr(c);
    80007076:	00000097          	auipc	ra,0x0
    8000707a:	8fe080e7          	jalr	-1794(ra) # 80006974 <consoleintr>
  while(1){
    8000707e:	b7f5                	j	8000706a <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80007080:	00020497          	auipc	s1,0x20
    80007084:	4d848493          	addi	s1,s1,1240 # 80027558 <uart_tx_lock>
    80007088:	8526                	mv	a0,s1
    8000708a:	00000097          	auipc	ra,0x0
    8000708e:	0b4080e7          	jalr	180(ra) # 8000713e <acquire>
  uartstart();
    80007092:	00000097          	auipc	ra,0x0
    80007096:	e64080e7          	jalr	-412(ra) # 80006ef6 <uartstart>
  release(&uart_tx_lock);
    8000709a:	8526                	mv	a0,s1
    8000709c:	00000097          	auipc	ra,0x0
    800070a0:	156080e7          	jalr	342(ra) # 800071f2 <release>
}
    800070a4:	60e2                	ld	ra,24(sp)
    800070a6:	6442                	ld	s0,16(sp)
    800070a8:	64a2                	ld	s1,8(sp)
    800070aa:	6105                	addi	sp,sp,32
    800070ac:	8082                	ret

00000000800070ae <initlock>:
}
#endif

void
initlock(struct spinlock *lk, char *name)
{
    800070ae:	1141                	addi	sp,sp,-16
    800070b0:	e422                	sd	s0,8(sp)
    800070b2:	0800                	addi	s0,sp,16
  lk->name = name;
    800070b4:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800070b6:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800070ba:	00053823          	sd	zero,16(a0)
#ifdef LAB_LOCK
  lk->nts = 0;
  lk->n = 0;
  findslot(lk);
#endif  
}
    800070be:	6422                	ld	s0,8(sp)
    800070c0:	0141                	addi	sp,sp,16
    800070c2:	8082                	ret

00000000800070c4 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800070c4:	411c                	lw	a5,0(a0)
    800070c6:	e399                	bnez	a5,800070cc <holding+0x8>
    800070c8:	4501                	li	a0,0
  return r;
}
    800070ca:	8082                	ret
{
    800070cc:	1101                	addi	sp,sp,-32
    800070ce:	ec06                	sd	ra,24(sp)
    800070d0:	e822                	sd	s0,16(sp)
    800070d2:	e426                	sd	s1,8(sp)
    800070d4:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800070d6:	6904                	ld	s1,16(a0)
    800070d8:	ffffa097          	auipc	ra,0xffffa
    800070dc:	dac080e7          	jalr	-596(ra) # 80000e84 <mycpu>
    800070e0:	40a48533          	sub	a0,s1,a0
    800070e4:	00153513          	seqz	a0,a0
}
    800070e8:	60e2                	ld	ra,24(sp)
    800070ea:	6442                	ld	s0,16(sp)
    800070ec:	64a2                	ld	s1,8(sp)
    800070ee:	6105                	addi	sp,sp,32
    800070f0:	8082                	ret

00000000800070f2 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800070f2:	1101                	addi	sp,sp,-32
    800070f4:	ec06                	sd	ra,24(sp)
    800070f6:	e822                	sd	s0,16(sp)
    800070f8:	e426                	sd	s1,8(sp)
    800070fa:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800070fc:	100024f3          	csrr	s1,sstatus
    80007100:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80007104:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80007106:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000710a:	ffffa097          	auipc	ra,0xffffa
    8000710e:	d7a080e7          	jalr	-646(ra) # 80000e84 <mycpu>
    80007112:	5d3c                	lw	a5,120(a0)
    80007114:	cf89                	beqz	a5,8000712e <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80007116:	ffffa097          	auipc	ra,0xffffa
    8000711a:	d6e080e7          	jalr	-658(ra) # 80000e84 <mycpu>
    8000711e:	5d3c                	lw	a5,120(a0)
    80007120:	2785                	addiw	a5,a5,1
    80007122:	dd3c                	sw	a5,120(a0)
}
    80007124:	60e2                	ld	ra,24(sp)
    80007126:	6442                	ld	s0,16(sp)
    80007128:	64a2                	ld	s1,8(sp)
    8000712a:	6105                	addi	sp,sp,32
    8000712c:	8082                	ret
    mycpu()->intena = old;
    8000712e:	ffffa097          	auipc	ra,0xffffa
    80007132:	d56080e7          	jalr	-682(ra) # 80000e84 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80007136:	8085                	srli	s1,s1,0x1
    80007138:	8885                	andi	s1,s1,1
    8000713a:	dd64                	sw	s1,124(a0)
    8000713c:	bfe9                	j	80007116 <push_off+0x24>

000000008000713e <acquire>:
{
    8000713e:	1101                	addi	sp,sp,-32
    80007140:	ec06                	sd	ra,24(sp)
    80007142:	e822                	sd	s0,16(sp)
    80007144:	e426                	sd	s1,8(sp)
    80007146:	1000                	addi	s0,sp,32
    80007148:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000714a:	00000097          	auipc	ra,0x0
    8000714e:	fa8080e7          	jalr	-88(ra) # 800070f2 <push_off>
  if(holding(lk))
    80007152:	8526                	mv	a0,s1
    80007154:	00000097          	auipc	ra,0x0
    80007158:	f70080e7          	jalr	-144(ra) # 800070c4 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    8000715c:	4705                	li	a4,1
  if(holding(lk))
    8000715e:	e115                	bnez	a0,80007182 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80007160:	87ba                	mv	a5,a4
    80007162:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80007166:	2781                	sext.w	a5,a5
    80007168:	ffe5                	bnez	a5,80007160 <acquire+0x22>
  __sync_synchronize();
    8000716a:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000716e:	ffffa097          	auipc	ra,0xffffa
    80007172:	d16080e7          	jalr	-746(ra) # 80000e84 <mycpu>
    80007176:	e888                	sd	a0,16(s1)
}
    80007178:	60e2                	ld	ra,24(sp)
    8000717a:	6442                	ld	s0,16(sp)
    8000717c:	64a2                	ld	s1,8(sp)
    8000717e:	6105                	addi	sp,sp,32
    80007180:	8082                	ret
    panic("acquire");
    80007182:	00002517          	auipc	a0,0x2
    80007186:	6ee50513          	addi	a0,a0,1774 # 80009870 <digits+0x20>
    8000718a:	00000097          	auipc	ra,0x0
    8000718e:	a6a080e7          	jalr	-1430(ra) # 80006bf4 <panic>

0000000080007192 <pop_off>:

void
pop_off(void)
{
    80007192:	1141                	addi	sp,sp,-16
    80007194:	e406                	sd	ra,8(sp)
    80007196:	e022                	sd	s0,0(sp)
    80007198:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000719a:	ffffa097          	auipc	ra,0xffffa
    8000719e:	cea080e7          	jalr	-790(ra) # 80000e84 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800071a2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800071a6:	8b89                	andi	a5,a5,2
  if(intr_get())
    800071a8:	e78d                	bnez	a5,800071d2 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800071aa:	5d3c                	lw	a5,120(a0)
    800071ac:	02f05b63          	blez	a5,800071e2 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800071b0:	37fd                	addiw	a5,a5,-1
    800071b2:	0007871b          	sext.w	a4,a5
    800071b6:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800071b8:	eb09                	bnez	a4,800071ca <pop_off+0x38>
    800071ba:	5d7c                	lw	a5,124(a0)
    800071bc:	c799                	beqz	a5,800071ca <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800071be:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800071c2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800071c6:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800071ca:	60a2                	ld	ra,8(sp)
    800071cc:	6402                	ld	s0,0(sp)
    800071ce:	0141                	addi	sp,sp,16
    800071d0:	8082                	ret
    panic("pop_off - interruptible");
    800071d2:	00002517          	auipc	a0,0x2
    800071d6:	6a650513          	addi	a0,a0,1702 # 80009878 <digits+0x28>
    800071da:	00000097          	auipc	ra,0x0
    800071de:	a1a080e7          	jalr	-1510(ra) # 80006bf4 <panic>
    panic("pop_off");
    800071e2:	00002517          	auipc	a0,0x2
    800071e6:	6ae50513          	addi	a0,a0,1710 # 80009890 <digits+0x40>
    800071ea:	00000097          	auipc	ra,0x0
    800071ee:	a0a080e7          	jalr	-1526(ra) # 80006bf4 <panic>

00000000800071f2 <release>:
{
    800071f2:	1101                	addi	sp,sp,-32
    800071f4:	ec06                	sd	ra,24(sp)
    800071f6:	e822                	sd	s0,16(sp)
    800071f8:	e426                	sd	s1,8(sp)
    800071fa:	1000                	addi	s0,sp,32
    800071fc:	84aa                	mv	s1,a0
  if(!holding(lk))
    800071fe:	00000097          	auipc	ra,0x0
    80007202:	ec6080e7          	jalr	-314(ra) # 800070c4 <holding>
    80007206:	c115                	beqz	a0,8000722a <release+0x38>
  lk->cpu = 0;
    80007208:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000720c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80007210:	0f50000f          	fence	iorw,ow
    80007214:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80007218:	00000097          	auipc	ra,0x0
    8000721c:	f7a080e7          	jalr	-134(ra) # 80007192 <pop_off>
}
    80007220:	60e2                	ld	ra,24(sp)
    80007222:	6442                	ld	s0,16(sp)
    80007224:	64a2                	ld	s1,8(sp)
    80007226:	6105                	addi	sp,sp,32
    80007228:	8082                	ret
    panic("release");
    8000722a:	00002517          	auipc	a0,0x2
    8000722e:	66e50513          	addi	a0,a0,1646 # 80009898 <digits+0x48>
    80007232:	00000097          	auipc	ra,0x0
    80007236:	9c2080e7          	jalr	-1598(ra) # 80006bf4 <panic>

000000008000723a <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    8000723a:	1141                	addi	sp,sp,-16
    8000723c:	e422                	sd	s0,8(sp)
    8000723e:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80007240:	0ff0000f          	fence
    80007244:	6108                	ld	a0,0(a0)
    80007246:	0ff0000f          	fence
  return val;
}
    8000724a:	6422                	ld	s0,8(sp)
    8000724c:	0141                	addi	sp,sp,16
    8000724e:	8082                	ret

0000000080007250 <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    80007250:	1141                	addi	sp,sp,-16
    80007252:	e422                	sd	s0,8(sp)
    80007254:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80007256:	0ff0000f          	fence
    8000725a:	4108                	lw	a0,0(a0)
    8000725c:	0ff0000f          	fence
  return val;
}
    80007260:	2501                	sext.w	a0,a0
    80007262:	6422                	ld	s0,8(sp)
    80007264:	0141                	addi	sp,sp,16
    80007266:	8082                	ret
	...

0000000080008000 <_trampoline>:
    80008000:	14051573          	csrrw	a0,sscratch,a0
    80008004:	02153423          	sd	ra,40(a0)
    80008008:	02253823          	sd	sp,48(a0)
    8000800c:	02353c23          	sd	gp,56(a0)
    80008010:	04453023          	sd	tp,64(a0)
    80008014:	04553423          	sd	t0,72(a0)
    80008018:	04653823          	sd	t1,80(a0)
    8000801c:	04753c23          	sd	t2,88(a0)
    80008020:	f120                	sd	s0,96(a0)
    80008022:	f524                	sd	s1,104(a0)
    80008024:	fd2c                	sd	a1,120(a0)
    80008026:	e150                	sd	a2,128(a0)
    80008028:	e554                	sd	a3,136(a0)
    8000802a:	e958                	sd	a4,144(a0)
    8000802c:	ed5c                	sd	a5,152(a0)
    8000802e:	0b053023          	sd	a6,160(a0)
    80008032:	0b153423          	sd	a7,168(a0)
    80008036:	0b253823          	sd	s2,176(a0)
    8000803a:	0b353c23          	sd	s3,184(a0)
    8000803e:	0d453023          	sd	s4,192(a0)
    80008042:	0d553423          	sd	s5,200(a0)
    80008046:	0d653823          	sd	s6,208(a0)
    8000804a:	0d753c23          	sd	s7,216(a0)
    8000804e:	0f853023          	sd	s8,224(a0)
    80008052:	0f953423          	sd	s9,232(a0)
    80008056:	0fa53823          	sd	s10,240(a0)
    8000805a:	0fb53c23          	sd	s11,248(a0)
    8000805e:	11c53023          	sd	t3,256(a0)
    80008062:	11d53423          	sd	t4,264(a0)
    80008066:	11e53823          	sd	t5,272(a0)
    8000806a:	11f53c23          	sd	t6,280(a0)
    8000806e:	140022f3          	csrr	t0,sscratch
    80008072:	06553823          	sd	t0,112(a0)
    80008076:	00853103          	ld	sp,8(a0)
    8000807a:	02053203          	ld	tp,32(a0)
    8000807e:	01053283          	ld	t0,16(a0)
    80008082:	00053303          	ld	t1,0(a0)
    80008086:	18031073          	csrw	satp,t1
    8000808a:	12000073          	sfence.vma
    8000808e:	8282                	jr	t0

0000000080008090 <userret>:
    80008090:	18059073          	csrw	satp,a1
    80008094:	12000073          	sfence.vma
    80008098:	07053283          	ld	t0,112(a0)
    8000809c:	14029073          	csrw	sscratch,t0
    800080a0:	02853083          	ld	ra,40(a0)
    800080a4:	03053103          	ld	sp,48(a0)
    800080a8:	03853183          	ld	gp,56(a0)
    800080ac:	04053203          	ld	tp,64(a0)
    800080b0:	04853283          	ld	t0,72(a0)
    800080b4:	05053303          	ld	t1,80(a0)
    800080b8:	05853383          	ld	t2,88(a0)
    800080bc:	7120                	ld	s0,96(a0)
    800080be:	7524                	ld	s1,104(a0)
    800080c0:	7d2c                	ld	a1,120(a0)
    800080c2:	6150                	ld	a2,128(a0)
    800080c4:	6554                	ld	a3,136(a0)
    800080c6:	6958                	ld	a4,144(a0)
    800080c8:	6d5c                	ld	a5,152(a0)
    800080ca:	0a053803          	ld	a6,160(a0)
    800080ce:	0a853883          	ld	a7,168(a0)
    800080d2:	0b053903          	ld	s2,176(a0)
    800080d6:	0b853983          	ld	s3,184(a0)
    800080da:	0c053a03          	ld	s4,192(a0)
    800080de:	0c853a83          	ld	s5,200(a0)
    800080e2:	0d053b03          	ld	s6,208(a0)
    800080e6:	0d853b83          	ld	s7,216(a0)
    800080ea:	0e053c03          	ld	s8,224(a0)
    800080ee:	0e853c83          	ld	s9,232(a0)
    800080f2:	0f053d03          	ld	s10,240(a0)
    800080f6:	0f853d83          	ld	s11,248(a0)
    800080fa:	10053e03          	ld	t3,256(a0)
    800080fe:	10853e83          	ld	t4,264(a0)
    80008102:	11053f03          	ld	t5,272(a0)
    80008106:	11853f83          	ld	t6,280(a0)
    8000810a:	14051573          	csrrw	a0,sscratch,a0
    8000810e:	10200073          	sret
	...
