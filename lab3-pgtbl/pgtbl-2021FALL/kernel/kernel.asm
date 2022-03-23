
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
    80000016:	0f3050ef          	jal	ra,80005908 <start>

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
    8000005e:	2a8080e7          	jalr	680(ra) # 80006302 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	348080e7          	jalr	840(ra) # 800063b6 <release>
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
    8000008e:	d2e080e7          	jalr	-722(ra) # 80005db8 <panic>

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
    800000f8:	17e080e7          	jalr	382(ra) # 80006272 <initlock>
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
    80000130:	1d6080e7          	jalr	470(ra) # 80006302 <acquire>
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
    80000148:	272080e7          	jalr	626(ra) # 800063b6 <release>

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
    80000172:	248080e7          	jalr	584(ra) # 800063b6 <release>
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
    80000332:	bd0080e7          	jalr	-1072(ra) # 80000efe <cpuid>
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
    8000034e:	bb4080e7          	jalr	-1100(ra) # 80000efe <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	aa6080e7          	jalr	-1370(ra) # 80005e02 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	18a080e7          	jalr	394(ra) # 800004ee <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	8c0080e7          	jalr	-1856(ra) # 80001c2c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	f1c080e7          	jalr	-228(ra) # 80005290 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	16e080e7          	jalr	366(ra) # 800014ea <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	946080e7          	jalr	-1722(ra) # 80005cca <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	c5c080e7          	jalr	-932(ra) # 80005fe8 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	a66080e7          	jalr	-1434(ra) # 80005e02 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	a56080e7          	jalr	-1450(ra) # 80005e02 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	a46080e7          	jalr	-1466(ra) # 80005e02 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	3d4080e7          	jalr	980(ra) # 800007a0 <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	11a080e7          	jalr	282(ra) # 800004ee <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	a74080e7          	jalr	-1420(ra) # 80000e50 <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	820080e7          	jalr	-2016(ra) # 80001c04 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	840080e7          	jalr	-1984(ra) # 80001c2c <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	e86080e7          	jalr	-378(ra) # 8000527a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	e94080e7          	jalr	-364(ra) # 80005290 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	05a080e7          	jalr	90(ra) # 8000245e <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	6ea080e7          	jalr	1770(ra) # 80002af6 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	694080e7          	jalr	1684(ra) # 80003aa8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	f96080e7          	jalr	-106(ra) # 800053b2 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	e94080e7          	jalr	-364(ra) # 800012b8 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00009717          	auipc	a4,0x9
    80000436:	bcf72723          	sw	a5,-1074(a4) # 80009000 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <vmprint_helper>:
  }
}

// lab3 pgtbl : print vm
static void vmprint_helper(pagetable_t pagetable,int level){
    if(level > 3)
    8000043c:	478d                	li	a5,3
    8000043e:	0ab7c763          	blt	a5,a1,800004ec <vmprint_helper+0xb0>
static void vmprint_helper(pagetable_t pagetable,int level){
    80000442:	7159                	addi	sp,sp,-112
    80000444:	f486                	sd	ra,104(sp)
    80000446:	f0a2                	sd	s0,96(sp)
    80000448:	eca6                	sd	s1,88(sp)
    8000044a:	e8ca                	sd	s2,80(sp)
    8000044c:	e4ce                	sd	s3,72(sp)
    8000044e:	e0d2                	sd	s4,64(sp)
    80000450:	fc56                	sd	s5,56(sp)
    80000452:	f85a                	sd	s6,48(sp)
    80000454:	f45e                	sd	s7,40(sp)
    80000456:	f062                	sd	s8,32(sp)
    80000458:	ec66                	sd	s9,24(sp)
    8000045a:	e86a                	sd	s10,16(sp)
    8000045c:	e46e                	sd	s11,8(sp)
    8000045e:	1880                	addi	s0,sp,112
    80000460:	8aae                	mv	s5,a1
    80000462:	892a                	mv	s2,a0
        return;
    for(int i = 0; i < 512; i++){
    80000464:	4481                	li	s1,0
        pte_t pte = pagetable[i];
        if(pte & PTE_V){
            uint64 child = PTE2PA(pte);
            for(int j = 0; j < level; j++)
                printf(" ..");
            printf("%d: pte %p pa %p\n",i,pte,child);
    80000466:	00008c97          	auipc	s9,0x8
    8000046a:	bf2c8c93          	addi	s9,s9,-1038 # 80008058 <etext+0x58>
            vmprint_helper((pagetable_t)child,level+1);
    8000046e:	00158c1b          	addiw	s8,a1,1
            for(int j = 0; j < level; j++)
    80000472:	4d01                	li	s10,0
                printf(" ..");
    80000474:	00008b97          	auipc	s7,0x8
    80000478:	bdcb8b93          	addi	s7,s7,-1060 # 80008050 <etext+0x50>
    for(int i = 0; i < 512; i++){
    8000047c:	20000b13          	li	s6,512
    80000480:	a01d                	j	800004a6 <vmprint_helper+0x6a>
            printf("%d: pte %p pa %p\n",i,pte,child);
    80000482:	86ee                	mv	a3,s11
    80000484:	8652                	mv	a2,s4
    80000486:	85a6                	mv	a1,s1
    80000488:	8566                	mv	a0,s9
    8000048a:	00006097          	auipc	ra,0x6
    8000048e:	978080e7          	jalr	-1672(ra) # 80005e02 <printf>
            vmprint_helper((pagetable_t)child,level+1);
    80000492:	85e2                	mv	a1,s8
    80000494:	856e                	mv	a0,s11
    80000496:	00000097          	auipc	ra,0x0
    8000049a:	fa6080e7          	jalr	-90(ra) # 8000043c <vmprint_helper>
    for(int i = 0; i < 512; i++){
    8000049e:	2485                	addiw	s1,s1,1
    800004a0:	0921                	addi	s2,s2,8
    800004a2:	03648663          	beq	s1,s6,800004ce <vmprint_helper+0x92>
        pte_t pte = pagetable[i];
    800004a6:	00093a03          	ld	s4,0(s2)
        if(pte & PTE_V){
    800004aa:	001a7793          	andi	a5,s4,1
    800004ae:	dbe5                	beqz	a5,8000049e <vmprint_helper+0x62>
            uint64 child = PTE2PA(pte);
    800004b0:	00aa5d93          	srli	s11,s4,0xa
    800004b4:	0db2                	slli	s11,s11,0xc
            for(int j = 0; j < level; j++)
    800004b6:	fd5056e3          	blez	s5,80000482 <vmprint_helper+0x46>
    800004ba:	89ea                	mv	s3,s10
                printf(" ..");
    800004bc:	855e                	mv	a0,s7
    800004be:	00006097          	auipc	ra,0x6
    800004c2:	944080e7          	jalr	-1724(ra) # 80005e02 <printf>
            for(int j = 0; j < level; j++)
    800004c6:	2985                	addiw	s3,s3,1
    800004c8:	ff3a9ae3          	bne	s5,s3,800004bc <vmprint_helper+0x80>
    800004cc:	bf5d                	j	80000482 <vmprint_helper+0x46>
        }
    }    
}
    800004ce:	70a6                	ld	ra,104(sp)
    800004d0:	7406                	ld	s0,96(sp)
    800004d2:	64e6                	ld	s1,88(sp)
    800004d4:	6946                	ld	s2,80(sp)
    800004d6:	69a6                	ld	s3,72(sp)
    800004d8:	6a06                	ld	s4,64(sp)
    800004da:	7ae2                	ld	s5,56(sp)
    800004dc:	7b42                	ld	s6,48(sp)
    800004de:	7ba2                	ld	s7,40(sp)
    800004e0:	7c02                	ld	s8,32(sp)
    800004e2:	6ce2                	ld	s9,24(sp)
    800004e4:	6d42                	ld	s10,16(sp)
    800004e6:	6da2                	ld	s11,8(sp)
    800004e8:	6165                	addi	sp,sp,112
    800004ea:	8082                	ret
    800004ec:	8082                	ret

00000000800004ee <kvminithart>:
{
    800004ee:	1141                	addi	sp,sp,-16
    800004f0:	e422                	sd	s0,8(sp)
    800004f2:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    800004f4:	00009797          	auipc	a5,0x9
    800004f8:	b147b783          	ld	a5,-1260(a5) # 80009008 <kernel_pagetable>
    800004fc:	83b1                	srli	a5,a5,0xc
    800004fe:	577d                	li	a4,-1
    80000500:	177e                	slli	a4,a4,0x3f
    80000502:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000504:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000508:	12000073          	sfence.vma
}
    8000050c:	6422                	ld	s0,8(sp)
    8000050e:	0141                	addi	sp,sp,16
    80000510:	8082                	ret

0000000080000512 <walk>:
{
    80000512:	7139                	addi	sp,sp,-64
    80000514:	fc06                	sd	ra,56(sp)
    80000516:	f822                	sd	s0,48(sp)
    80000518:	f426                	sd	s1,40(sp)
    8000051a:	f04a                	sd	s2,32(sp)
    8000051c:	ec4e                	sd	s3,24(sp)
    8000051e:	e852                	sd	s4,16(sp)
    80000520:	e456                	sd	s5,8(sp)
    80000522:	e05a                	sd	s6,0(sp)
    80000524:	0080                	addi	s0,sp,64
    80000526:	84aa                	mv	s1,a0
    80000528:	89ae                	mv	s3,a1
    8000052a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000052c:	57fd                	li	a5,-1
    8000052e:	83e9                	srli	a5,a5,0x1a
    80000530:	4a79                	li	s4,30
  for(int level = 2; level > 0; level--) {
    80000532:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000534:	04b7f263          	bgeu	a5,a1,80000578 <walk+0x66>
    panic("walk");
    80000538:	00008517          	auipc	a0,0x8
    8000053c:	b3850513          	addi	a0,a0,-1224 # 80008070 <etext+0x70>
    80000540:	00006097          	auipc	ra,0x6
    80000544:	878080e7          	jalr	-1928(ra) # 80005db8 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000548:	060a8663          	beqz	s5,800005b4 <walk+0xa2>
    8000054c:	00000097          	auipc	ra,0x0
    80000550:	bcc080e7          	jalr	-1076(ra) # 80000118 <kalloc>
    80000554:	84aa                	mv	s1,a0
    80000556:	c529                	beqz	a0,800005a0 <walk+0x8e>
      memset(pagetable, 0, PGSIZE);
    80000558:	6605                	lui	a2,0x1
    8000055a:	4581                	li	a1,0
    8000055c:	00000097          	auipc	ra,0x0
    80000560:	c1c080e7          	jalr	-996(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000564:	00c4d793          	srli	a5,s1,0xc
    80000568:	07aa                	slli	a5,a5,0xa
    8000056a:	0017e793          	ori	a5,a5,1
    8000056e:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000572:	3a5d                	addiw	s4,s4,-9
    80000574:	036a0063          	beq	s4,s6,80000594 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000578:	0149d933          	srl	s2,s3,s4
    8000057c:	1ff97913          	andi	s2,s2,511
    80000580:	090e                	slli	s2,s2,0x3
    80000582:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000584:	00093483          	ld	s1,0(s2)
    80000588:	0014f793          	andi	a5,s1,1
    8000058c:	dfd5                	beqz	a5,80000548 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000058e:	80a9                	srli	s1,s1,0xa
    80000590:	04b2                	slli	s1,s1,0xc
    80000592:	b7c5                	j	80000572 <walk+0x60>
  return &pagetable[PX(0, va)];
    80000594:	00c9d513          	srli	a0,s3,0xc
    80000598:	1ff57513          	andi	a0,a0,511
    8000059c:	050e                	slli	a0,a0,0x3
    8000059e:	9526                	add	a0,a0,s1
}
    800005a0:	70e2                	ld	ra,56(sp)
    800005a2:	7442                	ld	s0,48(sp)
    800005a4:	74a2                	ld	s1,40(sp)
    800005a6:	7902                	ld	s2,32(sp)
    800005a8:	69e2                	ld	s3,24(sp)
    800005aa:	6a42                	ld	s4,16(sp)
    800005ac:	6aa2                	ld	s5,8(sp)
    800005ae:	6b02                	ld	s6,0(sp)
    800005b0:	6121                	addi	sp,sp,64
    800005b2:	8082                	ret
        return 0;
    800005b4:	4501                	li	a0,0
    800005b6:	b7ed                	j	800005a0 <walk+0x8e>

00000000800005b8 <walkaddr>:
  if(va >= MAXVA)
    800005b8:	57fd                	li	a5,-1
    800005ba:	83e9                	srli	a5,a5,0x1a
    800005bc:	00b7f463          	bgeu	a5,a1,800005c4 <walkaddr+0xc>
    return 0;
    800005c0:	4501                	li	a0,0
}
    800005c2:	8082                	ret
{
    800005c4:	1141                	addi	sp,sp,-16
    800005c6:	e406                	sd	ra,8(sp)
    800005c8:	e022                	sd	s0,0(sp)
    800005ca:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800005cc:	4601                	li	a2,0
    800005ce:	00000097          	auipc	ra,0x0
    800005d2:	f44080e7          	jalr	-188(ra) # 80000512 <walk>
  if(pte == 0)
    800005d6:	c105                	beqz	a0,800005f6 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800005d8:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800005da:	0117f693          	andi	a3,a5,17
    800005de:	4745                	li	a4,17
    return 0;
    800005e0:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800005e2:	00e68663          	beq	a3,a4,800005ee <walkaddr+0x36>
}
    800005e6:	60a2                	ld	ra,8(sp)
    800005e8:	6402                	ld	s0,0(sp)
    800005ea:	0141                	addi	sp,sp,16
    800005ec:	8082                	ret
  pa = PTE2PA(*pte);
    800005ee:	00a7d513          	srli	a0,a5,0xa
    800005f2:	0532                	slli	a0,a0,0xc
  return pa;
    800005f4:	bfcd                	j	800005e6 <walkaddr+0x2e>
    return 0;
    800005f6:	4501                	li	a0,0
    800005f8:	b7fd                	j	800005e6 <walkaddr+0x2e>

00000000800005fa <mappages>:
{
    800005fa:	715d                	addi	sp,sp,-80
    800005fc:	e486                	sd	ra,72(sp)
    800005fe:	e0a2                	sd	s0,64(sp)
    80000600:	fc26                	sd	s1,56(sp)
    80000602:	f84a                	sd	s2,48(sp)
    80000604:	f44e                	sd	s3,40(sp)
    80000606:	f052                	sd	s4,32(sp)
    80000608:	ec56                	sd	s5,24(sp)
    8000060a:	e85a                	sd	s6,16(sp)
    8000060c:	e45e                	sd	s7,8(sp)
    8000060e:	0880                	addi	s0,sp,80
  if(size == 0)
    80000610:	c205                	beqz	a2,80000630 <mappages+0x36>
    80000612:	8aaa                	mv	s5,a0
    80000614:	8b3a                	mv	s6,a4
  a = PGROUNDDOWN(va);
    80000616:	77fd                	lui	a5,0xfffff
    80000618:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000061c:	15fd                	addi	a1,a1,-1
    8000061e:	00c589b3          	add	s3,a1,a2
    80000622:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000626:	8952                	mv	s2,s4
    80000628:	41468a33          	sub	s4,a3,s4
    a += PGSIZE;
    8000062c:	6b85                	lui	s7,0x1
    8000062e:	a015                	j	80000652 <mappages+0x58>
    panic("mappages: size");
    80000630:	00008517          	auipc	a0,0x8
    80000634:	a4850513          	addi	a0,a0,-1464 # 80008078 <etext+0x78>
    80000638:	00005097          	auipc	ra,0x5
    8000063c:	780080e7          	jalr	1920(ra) # 80005db8 <panic>
      panic("mappages: remap");
    80000640:	00008517          	auipc	a0,0x8
    80000644:	a4850513          	addi	a0,a0,-1464 # 80008088 <etext+0x88>
    80000648:	00005097          	auipc	ra,0x5
    8000064c:	770080e7          	jalr	1904(ra) # 80005db8 <panic>
    a += PGSIZE;
    80000650:	995e                	add	s2,s2,s7
  for(;;){
    80000652:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000656:	4605                	li	a2,1
    80000658:	85ca                	mv	a1,s2
    8000065a:	8556                	mv	a0,s5
    8000065c:	00000097          	auipc	ra,0x0
    80000660:	eb6080e7          	jalr	-330(ra) # 80000512 <walk>
    80000664:	cd19                	beqz	a0,80000682 <mappages+0x88>
    if(*pte & PTE_V)
    80000666:	611c                	ld	a5,0(a0)
    80000668:	8b85                	andi	a5,a5,1
    8000066a:	fbf9                	bnez	a5,80000640 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000066c:	80b1                	srli	s1,s1,0xc
    8000066e:	04aa                	slli	s1,s1,0xa
    80000670:	0164e4b3          	or	s1,s1,s6
    80000674:	0014e493          	ori	s1,s1,1
    80000678:	e104                	sd	s1,0(a0)
    if(a == last)
    8000067a:	fd391be3          	bne	s2,s3,80000650 <mappages+0x56>
  return 0;
    8000067e:	4501                	li	a0,0
    80000680:	a011                	j	80000684 <mappages+0x8a>
      return -1;
    80000682:	557d                	li	a0,-1
}
    80000684:	60a6                	ld	ra,72(sp)
    80000686:	6406                	ld	s0,64(sp)
    80000688:	74e2                	ld	s1,56(sp)
    8000068a:	7942                	ld	s2,48(sp)
    8000068c:	79a2                	ld	s3,40(sp)
    8000068e:	7a02                	ld	s4,32(sp)
    80000690:	6ae2                	ld	s5,24(sp)
    80000692:	6b42                	ld	s6,16(sp)
    80000694:	6ba2                	ld	s7,8(sp)
    80000696:	6161                	addi	sp,sp,80
    80000698:	8082                	ret

000000008000069a <kvmmap>:
{
    8000069a:	1141                	addi	sp,sp,-16
    8000069c:	e406                	sd	ra,8(sp)
    8000069e:	e022                	sd	s0,0(sp)
    800006a0:	0800                	addi	s0,sp,16
    800006a2:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800006a4:	86b2                	mv	a3,a2
    800006a6:	863e                	mv	a2,a5
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	f52080e7          	jalr	-174(ra) # 800005fa <mappages>
    800006b0:	e509                	bnez	a0,800006ba <kvmmap+0x20>
}
    800006b2:	60a2                	ld	ra,8(sp)
    800006b4:	6402                	ld	s0,0(sp)
    800006b6:	0141                	addi	sp,sp,16
    800006b8:	8082                	ret
    panic("kvmmap");
    800006ba:	00008517          	auipc	a0,0x8
    800006be:	9de50513          	addi	a0,a0,-1570 # 80008098 <etext+0x98>
    800006c2:	00005097          	auipc	ra,0x5
    800006c6:	6f6080e7          	jalr	1782(ra) # 80005db8 <panic>

00000000800006ca <kvmmake>:
{
    800006ca:	1101                	addi	sp,sp,-32
    800006cc:	ec06                	sd	ra,24(sp)
    800006ce:	e822                	sd	s0,16(sp)
    800006d0:	e426                	sd	s1,8(sp)
    800006d2:	e04a                	sd	s2,0(sp)
    800006d4:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	a42080e7          	jalr	-1470(ra) # 80000118 <kalloc>
    800006de:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800006e0:	6605                	lui	a2,0x1
    800006e2:	4581                	li	a1,0
    800006e4:	00000097          	auipc	ra,0x0
    800006e8:	a94080e7          	jalr	-1388(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800006ec:	4719                	li	a4,6
    800006ee:	6685                	lui	a3,0x1
    800006f0:	10000637          	lui	a2,0x10000
    800006f4:	100005b7          	lui	a1,0x10000
    800006f8:	8526                	mv	a0,s1
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	fa0080e7          	jalr	-96(ra) # 8000069a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000702:	4719                	li	a4,6
    80000704:	6685                	lui	a3,0x1
    80000706:	10001637          	lui	a2,0x10001
    8000070a:	100015b7          	lui	a1,0x10001
    8000070e:	8526                	mv	a0,s1
    80000710:	00000097          	auipc	ra,0x0
    80000714:	f8a080e7          	jalr	-118(ra) # 8000069a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000718:	4719                	li	a4,6
    8000071a:	004006b7          	lui	a3,0x400
    8000071e:	0c000637          	lui	a2,0xc000
    80000722:	0c0005b7          	lui	a1,0xc000
    80000726:	8526                	mv	a0,s1
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	f72080e7          	jalr	-142(ra) # 8000069a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000730:	00008917          	auipc	s2,0x8
    80000734:	8d090913          	addi	s2,s2,-1840 # 80008000 <etext>
    80000738:	4729                	li	a4,10
    8000073a:	80008697          	auipc	a3,0x80008
    8000073e:	8c668693          	addi	a3,a3,-1850 # 8000 <_entry-0x7fff8000>
    80000742:	4605                	li	a2,1
    80000744:	067e                	slli	a2,a2,0x1f
    80000746:	85b2                	mv	a1,a2
    80000748:	8526                	mv	a0,s1
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	f50080e7          	jalr	-176(ra) # 8000069a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000752:	4719                	li	a4,6
    80000754:	46c5                	li	a3,17
    80000756:	06ee                	slli	a3,a3,0x1b
    80000758:	412686b3          	sub	a3,a3,s2
    8000075c:	864a                	mv	a2,s2
    8000075e:	85ca                	mv	a1,s2
    80000760:	8526                	mv	a0,s1
    80000762:	00000097          	auipc	ra,0x0
    80000766:	f38080e7          	jalr	-200(ra) # 8000069a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000076a:	4729                	li	a4,10
    8000076c:	6685                	lui	a3,0x1
    8000076e:	00007617          	auipc	a2,0x7
    80000772:	89260613          	addi	a2,a2,-1902 # 80007000 <_trampoline>
    80000776:	040005b7          	lui	a1,0x4000
    8000077a:	15fd                	addi	a1,a1,-1
    8000077c:	05b2                	slli	a1,a1,0xc
    8000077e:	8526                	mv	a0,s1
    80000780:	00000097          	auipc	ra,0x0
    80000784:	f1a080e7          	jalr	-230(ra) # 8000069a <kvmmap>
  proc_mapstacks(kpgtbl);
    80000788:	8526                	mv	a0,s1
    8000078a:	00000097          	auipc	ra,0x0
    8000078e:	632080e7          	jalr	1586(ra) # 80000dbc <proc_mapstacks>
}
    80000792:	8526                	mv	a0,s1
    80000794:	60e2                	ld	ra,24(sp)
    80000796:	6442                	ld	s0,16(sp)
    80000798:	64a2                	ld	s1,8(sp)
    8000079a:	6902                	ld	s2,0(sp)
    8000079c:	6105                	addi	sp,sp,32
    8000079e:	8082                	ret

00000000800007a0 <kvminit>:
{
    800007a0:	1141                	addi	sp,sp,-16
    800007a2:	e406                	sd	ra,8(sp)
    800007a4:	e022                	sd	s0,0(sp)
    800007a6:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800007a8:	00000097          	auipc	ra,0x0
    800007ac:	f22080e7          	jalr	-222(ra) # 800006ca <kvmmake>
    800007b0:	00009797          	auipc	a5,0x9
    800007b4:	84a7bc23          	sd	a0,-1960(a5) # 80009008 <kernel_pagetable>
}
    800007b8:	60a2                	ld	ra,8(sp)
    800007ba:	6402                	ld	s0,0(sp)
    800007bc:	0141                	addi	sp,sp,16
    800007be:	8082                	ret

00000000800007c0 <uvmunmap>:
{
    800007c0:	715d                	addi	sp,sp,-80
    800007c2:	e486                	sd	ra,72(sp)
    800007c4:	e0a2                	sd	s0,64(sp)
    800007c6:	fc26                	sd	s1,56(sp)
    800007c8:	f84a                	sd	s2,48(sp)
    800007ca:	f44e                	sd	s3,40(sp)
    800007cc:	f052                	sd	s4,32(sp)
    800007ce:	ec56                	sd	s5,24(sp)
    800007d0:	e85a                	sd	s6,16(sp)
    800007d2:	e45e                	sd	s7,8(sp)
    800007d4:	0880                	addi	s0,sp,80
  if((va % PGSIZE) != 0)
    800007d6:	03459793          	slli	a5,a1,0x34
    800007da:	e795                	bnez	a5,80000806 <uvmunmap+0x46>
    800007dc:	8a2a                	mv	s4,a0
    800007de:	892e                	mv	s2,a1
    800007e0:	8ab6                	mv	s5,a3
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007e2:	0632                	slli	a2,a2,0xc
    800007e4:	00b609b3          	add	s3,a2,a1
    if(PTE_FLAGS(*pte) == PTE_V)
    800007e8:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ea:	6b05                	lui	s6,0x1
    800007ec:	0735e863          	bltu	a1,s3,8000085c <uvmunmap+0x9c>
}
    800007f0:	60a6                	ld	ra,72(sp)
    800007f2:	6406                	ld	s0,64(sp)
    800007f4:	74e2                	ld	s1,56(sp)
    800007f6:	7942                	ld	s2,48(sp)
    800007f8:	79a2                	ld	s3,40(sp)
    800007fa:	7a02                	ld	s4,32(sp)
    800007fc:	6ae2                	ld	s5,24(sp)
    800007fe:	6b42                	ld	s6,16(sp)
    80000800:	6ba2                	ld	s7,8(sp)
    80000802:	6161                	addi	sp,sp,80
    80000804:	8082                	ret
    panic("uvmunmap: not aligned");
    80000806:	00008517          	auipc	a0,0x8
    8000080a:	89a50513          	addi	a0,a0,-1894 # 800080a0 <etext+0xa0>
    8000080e:	00005097          	auipc	ra,0x5
    80000812:	5aa080e7          	jalr	1450(ra) # 80005db8 <panic>
      panic("uvmunmap: walk");
    80000816:	00008517          	auipc	a0,0x8
    8000081a:	8a250513          	addi	a0,a0,-1886 # 800080b8 <etext+0xb8>
    8000081e:	00005097          	auipc	ra,0x5
    80000822:	59a080e7          	jalr	1434(ra) # 80005db8 <panic>
      panic("uvmunmap: not mapped");
    80000826:	00008517          	auipc	a0,0x8
    8000082a:	8a250513          	addi	a0,a0,-1886 # 800080c8 <etext+0xc8>
    8000082e:	00005097          	auipc	ra,0x5
    80000832:	58a080e7          	jalr	1418(ra) # 80005db8 <panic>
      panic("uvmunmap: not a leaf");
    80000836:	00008517          	auipc	a0,0x8
    8000083a:	8aa50513          	addi	a0,a0,-1878 # 800080e0 <etext+0xe0>
    8000083e:	00005097          	auipc	ra,0x5
    80000842:	57a080e7          	jalr	1402(ra) # 80005db8 <panic>
      uint64 pa = PTE2PA(*pte);
    80000846:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000848:	0532                	slli	a0,a0,0xc
    8000084a:	fffff097          	auipc	ra,0xfffff
    8000084e:	7d2080e7          	jalr	2002(ra) # 8000001c <kfree>
    *pte = 0;
    80000852:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000856:	995a                	add	s2,s2,s6
    80000858:	f9397ce3          	bgeu	s2,s3,800007f0 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000085c:	4601                	li	a2,0
    8000085e:	85ca                	mv	a1,s2
    80000860:	8552                	mv	a0,s4
    80000862:	00000097          	auipc	ra,0x0
    80000866:	cb0080e7          	jalr	-848(ra) # 80000512 <walk>
    8000086a:	84aa                	mv	s1,a0
    8000086c:	d54d                	beqz	a0,80000816 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000086e:	6108                	ld	a0,0(a0)
    80000870:	00157793          	andi	a5,a0,1
    80000874:	dbcd                	beqz	a5,80000826 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000876:	3ff57793          	andi	a5,a0,1023
    8000087a:	fb778ee3          	beq	a5,s7,80000836 <uvmunmap+0x76>
    if(do_free){
    8000087e:	fc0a8ae3          	beqz	s5,80000852 <uvmunmap+0x92>
    80000882:	b7d1                	j	80000846 <uvmunmap+0x86>

0000000080000884 <uvmcreate>:
{
    80000884:	1101                	addi	sp,sp,-32
    80000886:	ec06                	sd	ra,24(sp)
    80000888:	e822                	sd	s0,16(sp)
    8000088a:	e426                	sd	s1,8(sp)
    8000088c:	1000                	addi	s0,sp,32
  pagetable = (pagetable_t) kalloc();
    8000088e:	00000097          	auipc	ra,0x0
    80000892:	88a080e7          	jalr	-1910(ra) # 80000118 <kalloc>
    80000896:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000898:	c519                	beqz	a0,800008a6 <uvmcreate+0x22>
  memset(pagetable, 0, PGSIZE);
    8000089a:	6605                	lui	a2,0x1
    8000089c:	4581                	li	a1,0
    8000089e:	00000097          	auipc	ra,0x0
    800008a2:	8da080e7          	jalr	-1830(ra) # 80000178 <memset>
}
    800008a6:	8526                	mv	a0,s1
    800008a8:	60e2                	ld	ra,24(sp)
    800008aa:	6442                	ld	s0,16(sp)
    800008ac:	64a2                	ld	s1,8(sp)
    800008ae:	6105                	addi	sp,sp,32
    800008b0:	8082                	ret

00000000800008b2 <uvminit>:
{
    800008b2:	7179                	addi	sp,sp,-48
    800008b4:	f406                	sd	ra,40(sp)
    800008b6:	f022                	sd	s0,32(sp)
    800008b8:	ec26                	sd	s1,24(sp)
    800008ba:	e84a                	sd	s2,16(sp)
    800008bc:	e44e                	sd	s3,8(sp)
    800008be:	e052                	sd	s4,0(sp)
    800008c0:	1800                	addi	s0,sp,48
  if(sz >= PGSIZE)
    800008c2:	6785                	lui	a5,0x1
    800008c4:	04f67863          	bgeu	a2,a5,80000914 <uvminit+0x62>
    800008c8:	8a2a                	mv	s4,a0
    800008ca:	89ae                	mv	s3,a1
    800008cc:	84b2                	mv	s1,a2
  mem = kalloc();
    800008ce:	00000097          	auipc	ra,0x0
    800008d2:	84a080e7          	jalr	-1974(ra) # 80000118 <kalloc>
    800008d6:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800008d8:	6605                	lui	a2,0x1
    800008da:	4581                	li	a1,0
    800008dc:	00000097          	auipc	ra,0x0
    800008e0:	89c080e7          	jalr	-1892(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800008e4:	4779                	li	a4,30
    800008e6:	86ca                	mv	a3,s2
    800008e8:	6605                	lui	a2,0x1
    800008ea:	4581                	li	a1,0
    800008ec:	8552                	mv	a0,s4
    800008ee:	00000097          	auipc	ra,0x0
    800008f2:	d0c080e7          	jalr	-756(ra) # 800005fa <mappages>
  memmove(mem, src, sz);
    800008f6:	8626                	mv	a2,s1
    800008f8:	85ce                	mv	a1,s3
    800008fa:	854a                	mv	a0,s2
    800008fc:	00000097          	auipc	ra,0x0
    80000900:	8dc080e7          	jalr	-1828(ra) # 800001d8 <memmove>
}
    80000904:	70a2                	ld	ra,40(sp)
    80000906:	7402                	ld	s0,32(sp)
    80000908:	64e2                	ld	s1,24(sp)
    8000090a:	6942                	ld	s2,16(sp)
    8000090c:	69a2                	ld	s3,8(sp)
    8000090e:	6a02                	ld	s4,0(sp)
    80000910:	6145                	addi	sp,sp,48
    80000912:	8082                	ret
    panic("inituvm: more than a page");
    80000914:	00007517          	auipc	a0,0x7
    80000918:	7e450513          	addi	a0,a0,2020 # 800080f8 <etext+0xf8>
    8000091c:	00005097          	auipc	ra,0x5
    80000920:	49c080e7          	jalr	1180(ra) # 80005db8 <panic>

0000000080000924 <uvmdealloc>:
{
    80000924:	1101                	addi	sp,sp,-32
    80000926:	ec06                	sd	ra,24(sp)
    80000928:	e822                	sd	s0,16(sp)
    8000092a:	e426                	sd	s1,8(sp)
    8000092c:	1000                	addi	s0,sp,32
    return oldsz;
    8000092e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000930:	00b67d63          	bgeu	a2,a1,8000094a <uvmdealloc+0x26>
    80000934:	84b2                	mv	s1,a2
  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000936:	6785                	lui	a5,0x1
    80000938:	17fd                	addi	a5,a5,-1
    8000093a:	00f60733          	add	a4,a2,a5
    8000093e:	767d                	lui	a2,0xfffff
    80000940:	8f71                	and	a4,a4,a2
    80000942:	97ae                	add	a5,a5,a1
    80000944:	8ff1                	and	a5,a5,a2
    80000946:	00f76863          	bltu	a4,a5,80000956 <uvmdealloc+0x32>
}
    8000094a:	8526                	mv	a0,s1
    8000094c:	60e2                	ld	ra,24(sp)
    8000094e:	6442                	ld	s0,16(sp)
    80000950:	64a2                	ld	s1,8(sp)
    80000952:	6105                	addi	sp,sp,32
    80000954:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000956:	8f99                	sub	a5,a5,a4
    80000958:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000095a:	4685                	li	a3,1
    8000095c:	0007861b          	sext.w	a2,a5
    80000960:	85ba                	mv	a1,a4
    80000962:	00000097          	auipc	ra,0x0
    80000966:	e5e080e7          	jalr	-418(ra) # 800007c0 <uvmunmap>
    8000096a:	b7c5                	j	8000094a <uvmdealloc+0x26>

000000008000096c <uvmalloc>:
  if(newsz < oldsz)
    8000096c:	0ab66163          	bltu	a2,a1,80000a0e <uvmalloc+0xa2>
{
    80000970:	7139                	addi	sp,sp,-64
    80000972:	fc06                	sd	ra,56(sp)
    80000974:	f822                	sd	s0,48(sp)
    80000976:	f426                	sd	s1,40(sp)
    80000978:	f04a                	sd	s2,32(sp)
    8000097a:	ec4e                	sd	s3,24(sp)
    8000097c:	e852                	sd	s4,16(sp)
    8000097e:	e456                	sd	s5,8(sp)
    80000980:	0080                	addi	s0,sp,64
    80000982:	8aaa                	mv	s5,a0
    80000984:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000986:	6985                	lui	s3,0x1
    80000988:	19fd                	addi	s3,s3,-1
    8000098a:	95ce                	add	a1,a1,s3
    8000098c:	79fd                	lui	s3,0xfffff
    8000098e:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000992:	08c9f063          	bgeu	s3,a2,80000a12 <uvmalloc+0xa6>
    80000996:	894e                	mv	s2,s3
    mem = kalloc();
    80000998:	fffff097          	auipc	ra,0xfffff
    8000099c:	780080e7          	jalr	1920(ra) # 80000118 <kalloc>
    800009a0:	84aa                	mv	s1,a0
    if(mem == 0){
    800009a2:	c51d                	beqz	a0,800009d0 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800009a4:	6605                	lui	a2,0x1
    800009a6:	4581                	li	a1,0
    800009a8:	fffff097          	auipc	ra,0xfffff
    800009ac:	7d0080e7          	jalr	2000(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800009b0:	4779                	li	a4,30
    800009b2:	86a6                	mv	a3,s1
    800009b4:	6605                	lui	a2,0x1
    800009b6:	85ca                	mv	a1,s2
    800009b8:	8556                	mv	a0,s5
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	c40080e7          	jalr	-960(ra) # 800005fa <mappages>
    800009c2:	e905                	bnez	a0,800009f2 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009c4:	6785                	lui	a5,0x1
    800009c6:	993e                	add	s2,s2,a5
    800009c8:	fd4968e3          	bltu	s2,s4,80000998 <uvmalloc+0x2c>
  return newsz;
    800009cc:	8552                	mv	a0,s4
    800009ce:	a809                	j	800009e0 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800009d0:	864e                	mv	a2,s3
    800009d2:	85ca                	mv	a1,s2
    800009d4:	8556                	mv	a0,s5
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	f4e080e7          	jalr	-178(ra) # 80000924 <uvmdealloc>
      return 0;
    800009de:	4501                	li	a0,0
}
    800009e0:	70e2                	ld	ra,56(sp)
    800009e2:	7442                	ld	s0,48(sp)
    800009e4:	74a2                	ld	s1,40(sp)
    800009e6:	7902                	ld	s2,32(sp)
    800009e8:	69e2                	ld	s3,24(sp)
    800009ea:	6a42                	ld	s4,16(sp)
    800009ec:	6aa2                	ld	s5,8(sp)
    800009ee:	6121                	addi	sp,sp,64
    800009f0:	8082                	ret
      kfree(mem);
    800009f2:	8526                	mv	a0,s1
    800009f4:	fffff097          	auipc	ra,0xfffff
    800009f8:	628080e7          	jalr	1576(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009fc:	864e                	mv	a2,s3
    800009fe:	85ca                	mv	a1,s2
    80000a00:	8556                	mv	a0,s5
    80000a02:	00000097          	auipc	ra,0x0
    80000a06:	f22080e7          	jalr	-222(ra) # 80000924 <uvmdealloc>
      return 0;
    80000a0a:	4501                	li	a0,0
    80000a0c:	bfd1                	j	800009e0 <uvmalloc+0x74>
    return oldsz;
    80000a0e:	852e                	mv	a0,a1
}
    80000a10:	8082                	ret
  return newsz;
    80000a12:	8532                	mv	a0,a2
    80000a14:	b7f1                	j	800009e0 <uvmalloc+0x74>

0000000080000a16 <freewalk>:
{
    80000a16:	7179                	addi	sp,sp,-48
    80000a18:	f406                	sd	ra,40(sp)
    80000a1a:	f022                	sd	s0,32(sp)
    80000a1c:	ec26                	sd	s1,24(sp)
    80000a1e:	e84a                	sd	s2,16(sp)
    80000a20:	e44e                	sd	s3,8(sp)
    80000a22:	e052                	sd	s4,0(sp)
    80000a24:	1800                	addi	s0,sp,48
    80000a26:	8a2a                	mv	s4,a0
  for(int i = 0; i < 512; i++){
    80000a28:	84aa                	mv	s1,a0
    80000a2a:	6905                	lui	s2,0x1
    80000a2c:	992a                	add	s2,s2,a0
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a2e:	4985                	li	s3,1
    80000a30:	a821                	j	80000a48 <freewalk+0x32>
      uint64 child = PTE2PA(pte);
    80000a32:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000a34:	0532                	slli	a0,a0,0xc
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	fe0080e7          	jalr	-32(ra) # 80000a16 <freewalk>
      pagetable[i] = 0;
    80000a3e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a42:	04a1                	addi	s1,s1,8
    80000a44:	03248163          	beq	s1,s2,80000a66 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000a48:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a4a:	00f57793          	andi	a5,a0,15
    80000a4e:	ff3782e3          	beq	a5,s3,80000a32 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a52:	8905                	andi	a0,a0,1
    80000a54:	d57d                	beqz	a0,80000a42 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000a56:	00007517          	auipc	a0,0x7
    80000a5a:	6c250513          	addi	a0,a0,1730 # 80008118 <etext+0x118>
    80000a5e:	00005097          	auipc	ra,0x5
    80000a62:	35a080e7          	jalr	858(ra) # 80005db8 <panic>
  kfree((void*)pagetable);
    80000a66:	8552                	mv	a0,s4
    80000a68:	fffff097          	auipc	ra,0xfffff
    80000a6c:	5b4080e7          	jalr	1460(ra) # 8000001c <kfree>
}
    80000a70:	70a2                	ld	ra,40(sp)
    80000a72:	7402                	ld	s0,32(sp)
    80000a74:	64e2                	ld	s1,24(sp)
    80000a76:	6942                	ld	s2,16(sp)
    80000a78:	69a2                	ld	s3,8(sp)
    80000a7a:	6a02                	ld	s4,0(sp)
    80000a7c:	6145                	addi	sp,sp,48
    80000a7e:	8082                	ret

0000000080000a80 <uvmfree>:
{
    80000a80:	1101                	addi	sp,sp,-32
    80000a82:	ec06                	sd	ra,24(sp)
    80000a84:	e822                	sd	s0,16(sp)
    80000a86:	e426                	sd	s1,8(sp)
    80000a88:	1000                	addi	s0,sp,32
    80000a8a:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a8c:	e999                	bnez	a1,80000aa2 <uvmfree+0x22>
  freewalk(pagetable);
    80000a8e:	8526                	mv	a0,s1
    80000a90:	00000097          	auipc	ra,0x0
    80000a94:	f86080e7          	jalr	-122(ra) # 80000a16 <freewalk>
}
    80000a98:	60e2                	ld	ra,24(sp)
    80000a9a:	6442                	ld	s0,16(sp)
    80000a9c:	64a2                	ld	s1,8(sp)
    80000a9e:	6105                	addi	sp,sp,32
    80000aa0:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000aa2:	6605                	lui	a2,0x1
    80000aa4:	167d                	addi	a2,a2,-1
    80000aa6:	962e                	add	a2,a2,a1
    80000aa8:	4685                	li	a3,1
    80000aaa:	8231                	srli	a2,a2,0xc
    80000aac:	4581                	li	a1,0
    80000aae:	00000097          	auipc	ra,0x0
    80000ab2:	d12080e7          	jalr	-750(ra) # 800007c0 <uvmunmap>
    80000ab6:	bfe1                	j	80000a8e <uvmfree+0xe>

0000000080000ab8 <uvmcopy>:
  for(i = 0; i < sz; i += PGSIZE){
    80000ab8:	c679                	beqz	a2,80000b86 <uvmcopy+0xce>
{
    80000aba:	715d                	addi	sp,sp,-80
    80000abc:	e486                	sd	ra,72(sp)
    80000abe:	e0a2                	sd	s0,64(sp)
    80000ac0:	fc26                	sd	s1,56(sp)
    80000ac2:	f84a                	sd	s2,48(sp)
    80000ac4:	f44e                	sd	s3,40(sp)
    80000ac6:	f052                	sd	s4,32(sp)
    80000ac8:	ec56                	sd	s5,24(sp)
    80000aca:	e85a                	sd	s6,16(sp)
    80000acc:	e45e                	sd	s7,8(sp)
    80000ace:	0880                	addi	s0,sp,80
    80000ad0:	8b2a                	mv	s6,a0
    80000ad2:	8aae                	mv	s5,a1
    80000ad4:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000ad6:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000ad8:	4601                	li	a2,0
    80000ada:	85ce                	mv	a1,s3
    80000adc:	855a                	mv	a0,s6
    80000ade:	00000097          	auipc	ra,0x0
    80000ae2:	a34080e7          	jalr	-1484(ra) # 80000512 <walk>
    80000ae6:	c531                	beqz	a0,80000b32 <uvmcopy+0x7a>
    if((*pte & PTE_V) == 0)
    80000ae8:	6118                	ld	a4,0(a0)
    80000aea:	00177793          	andi	a5,a4,1
    80000aee:	cbb1                	beqz	a5,80000b42 <uvmcopy+0x8a>
    pa = PTE2PA(*pte);
    80000af0:	00a75593          	srli	a1,a4,0xa
    80000af4:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000af8:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000afc:	fffff097          	auipc	ra,0xfffff
    80000b00:	61c080e7          	jalr	1564(ra) # 80000118 <kalloc>
    80000b04:	892a                	mv	s2,a0
    80000b06:	c939                	beqz	a0,80000b5c <uvmcopy+0xa4>
    memmove(mem, (char*)pa, PGSIZE);
    80000b08:	6605                	lui	a2,0x1
    80000b0a:	85de                	mv	a1,s7
    80000b0c:	fffff097          	auipc	ra,0xfffff
    80000b10:	6cc080e7          	jalr	1740(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000b14:	8726                	mv	a4,s1
    80000b16:	86ca                	mv	a3,s2
    80000b18:	6605                	lui	a2,0x1
    80000b1a:	85ce                	mv	a1,s3
    80000b1c:	8556                	mv	a0,s5
    80000b1e:	00000097          	auipc	ra,0x0
    80000b22:	adc080e7          	jalr	-1316(ra) # 800005fa <mappages>
    80000b26:	e515                	bnez	a0,80000b52 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000b28:	6785                	lui	a5,0x1
    80000b2a:	99be                	add	s3,s3,a5
    80000b2c:	fb49e6e3          	bltu	s3,s4,80000ad8 <uvmcopy+0x20>
    80000b30:	a081                	j	80000b70 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000b32:	00007517          	auipc	a0,0x7
    80000b36:	5f650513          	addi	a0,a0,1526 # 80008128 <etext+0x128>
    80000b3a:	00005097          	auipc	ra,0x5
    80000b3e:	27e080e7          	jalr	638(ra) # 80005db8 <panic>
      panic("uvmcopy: page not present");
    80000b42:	00007517          	auipc	a0,0x7
    80000b46:	60650513          	addi	a0,a0,1542 # 80008148 <etext+0x148>
    80000b4a:	00005097          	auipc	ra,0x5
    80000b4e:	26e080e7          	jalr	622(ra) # 80005db8 <panic>
      kfree(mem);
    80000b52:	854a                	mv	a0,s2
    80000b54:	fffff097          	auipc	ra,0xfffff
    80000b58:	4c8080e7          	jalr	1224(ra) # 8000001c <kfree>
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b5c:	4685                	li	a3,1
    80000b5e:	00c9d613          	srli	a2,s3,0xc
    80000b62:	4581                	li	a1,0
    80000b64:	8556                	mv	a0,s5
    80000b66:	00000097          	auipc	ra,0x0
    80000b6a:	c5a080e7          	jalr	-934(ra) # 800007c0 <uvmunmap>
  return -1;
    80000b6e:	557d                	li	a0,-1
}
    80000b70:	60a6                	ld	ra,72(sp)
    80000b72:	6406                	ld	s0,64(sp)
    80000b74:	74e2                	ld	s1,56(sp)
    80000b76:	7942                	ld	s2,48(sp)
    80000b78:	79a2                	ld	s3,40(sp)
    80000b7a:	7a02                	ld	s4,32(sp)
    80000b7c:	6ae2                	ld	s5,24(sp)
    80000b7e:	6b42                	ld	s6,16(sp)
    80000b80:	6ba2                	ld	s7,8(sp)
    80000b82:	6161                	addi	sp,sp,80
    80000b84:	8082                	ret
  return 0;
    80000b86:	4501                	li	a0,0
}
    80000b88:	8082                	ret

0000000080000b8a <uvmclear>:
{
    80000b8a:	1141                	addi	sp,sp,-16
    80000b8c:	e406                	sd	ra,8(sp)
    80000b8e:	e022                	sd	s0,0(sp)
    80000b90:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000b92:	4601                	li	a2,0
    80000b94:	00000097          	auipc	ra,0x0
    80000b98:	97e080e7          	jalr	-1666(ra) # 80000512 <walk>
  if(pte == 0)
    80000b9c:	c901                	beqz	a0,80000bac <uvmclear+0x22>
  *pte &= ~PTE_U;
    80000b9e:	611c                	ld	a5,0(a0)
    80000ba0:	9bbd                	andi	a5,a5,-17
    80000ba2:	e11c                	sd	a5,0(a0)
}
    80000ba4:	60a2                	ld	ra,8(sp)
    80000ba6:	6402                	ld	s0,0(sp)
    80000ba8:	0141                	addi	sp,sp,16
    80000baa:	8082                	ret
    panic("uvmclear");
    80000bac:	00007517          	auipc	a0,0x7
    80000bb0:	5bc50513          	addi	a0,a0,1468 # 80008168 <etext+0x168>
    80000bb4:	00005097          	auipc	ra,0x5
    80000bb8:	204080e7          	jalr	516(ra) # 80005db8 <panic>

0000000080000bbc <copyout>:
  while(len > 0){
    80000bbc:	c6bd                	beqz	a3,80000c2a <copyout+0x6e>
{
    80000bbe:	715d                	addi	sp,sp,-80
    80000bc0:	e486                	sd	ra,72(sp)
    80000bc2:	e0a2                	sd	s0,64(sp)
    80000bc4:	fc26                	sd	s1,56(sp)
    80000bc6:	f84a                	sd	s2,48(sp)
    80000bc8:	f44e                	sd	s3,40(sp)
    80000bca:	f052                	sd	s4,32(sp)
    80000bcc:	ec56                	sd	s5,24(sp)
    80000bce:	e85a                	sd	s6,16(sp)
    80000bd0:	e45e                	sd	s7,8(sp)
    80000bd2:	e062                	sd	s8,0(sp)
    80000bd4:	0880                	addi	s0,sp,80
    80000bd6:	8b2a                	mv	s6,a0
    80000bd8:	8c2e                	mv	s8,a1
    80000bda:	8a32                	mv	s4,a2
    80000bdc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000bde:	7bfd                	lui	s7,0xfffff
    n = PGSIZE - (dstva - va0);
    80000be0:	6a85                	lui	s5,0x1
    80000be2:	a015                	j	80000c06 <copyout+0x4a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000be4:	9562                	add	a0,a0,s8
    80000be6:	0004861b          	sext.w	a2,s1
    80000bea:	85d2                	mv	a1,s4
    80000bec:	41250533          	sub	a0,a0,s2
    80000bf0:	fffff097          	auipc	ra,0xfffff
    80000bf4:	5e8080e7          	jalr	1512(ra) # 800001d8 <memmove>
    len -= n;
    80000bf8:	409989b3          	sub	s3,s3,s1
    src += n;
    80000bfc:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000bfe:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c02:	02098263          	beqz	s3,80000c26 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000c06:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c0a:	85ca                	mv	a1,s2
    80000c0c:	855a                	mv	a0,s6
    80000c0e:	00000097          	auipc	ra,0x0
    80000c12:	9aa080e7          	jalr	-1622(ra) # 800005b8 <walkaddr>
    if(pa0 == 0)
    80000c16:	cd01                	beqz	a0,80000c2e <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000c18:	418904b3          	sub	s1,s2,s8
    80000c1c:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c1e:	fc99f3e3          	bgeu	s3,s1,80000be4 <copyout+0x28>
    80000c22:	84ce                	mv	s1,s3
    80000c24:	b7c1                	j	80000be4 <copyout+0x28>
  return 0;
    80000c26:	4501                	li	a0,0
    80000c28:	a021                	j	80000c30 <copyout+0x74>
    80000c2a:	4501                	li	a0,0
}
    80000c2c:	8082                	ret
      return -1;
    80000c2e:	557d                	li	a0,-1
}
    80000c30:	60a6                	ld	ra,72(sp)
    80000c32:	6406                	ld	s0,64(sp)
    80000c34:	74e2                	ld	s1,56(sp)
    80000c36:	7942                	ld	s2,48(sp)
    80000c38:	79a2                	ld	s3,40(sp)
    80000c3a:	7a02                	ld	s4,32(sp)
    80000c3c:	6ae2                	ld	s5,24(sp)
    80000c3e:	6b42                	ld	s6,16(sp)
    80000c40:	6ba2                	ld	s7,8(sp)
    80000c42:	6c02                	ld	s8,0(sp)
    80000c44:	6161                	addi	sp,sp,80
    80000c46:	8082                	ret

0000000080000c48 <copyin>:
  while(len > 0){
    80000c48:	c6bd                	beqz	a3,80000cb6 <copyin+0x6e>
{
    80000c4a:	715d                	addi	sp,sp,-80
    80000c4c:	e486                	sd	ra,72(sp)
    80000c4e:	e0a2                	sd	s0,64(sp)
    80000c50:	fc26                	sd	s1,56(sp)
    80000c52:	f84a                	sd	s2,48(sp)
    80000c54:	f44e                	sd	s3,40(sp)
    80000c56:	f052                	sd	s4,32(sp)
    80000c58:	ec56                	sd	s5,24(sp)
    80000c5a:	e85a                	sd	s6,16(sp)
    80000c5c:	e45e                	sd	s7,8(sp)
    80000c5e:	e062                	sd	s8,0(sp)
    80000c60:	0880                	addi	s0,sp,80
    80000c62:	8b2a                	mv	s6,a0
    80000c64:	8a2e                	mv	s4,a1
    80000c66:	8c32                	mv	s8,a2
    80000c68:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c6a:	7bfd                	lui	s7,0xfffff
    n = PGSIZE - (srcva - va0);
    80000c6c:	6a85                	lui	s5,0x1
    80000c6e:	a015                	j	80000c92 <copyin+0x4a>
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c70:	9562                	add	a0,a0,s8
    80000c72:	0004861b          	sext.w	a2,s1
    80000c76:	412505b3          	sub	a1,a0,s2
    80000c7a:	8552                	mv	a0,s4
    80000c7c:	fffff097          	auipc	ra,0xfffff
    80000c80:	55c080e7          	jalr	1372(ra) # 800001d8 <memmove>
    len -= n;
    80000c84:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c88:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c8a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c8e:	02098263          	beqz	s3,80000cb2 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c92:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c96:	85ca                	mv	a1,s2
    80000c98:	855a                	mv	a0,s6
    80000c9a:	00000097          	auipc	ra,0x0
    80000c9e:	91e080e7          	jalr	-1762(ra) # 800005b8 <walkaddr>
    if(pa0 == 0)
    80000ca2:	cd01                	beqz	a0,80000cba <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000ca4:	418904b3          	sub	s1,s2,s8
    80000ca8:	94d6                	add	s1,s1,s5
    if(n > len)
    80000caa:	fc99f3e3          	bgeu	s3,s1,80000c70 <copyin+0x28>
    80000cae:	84ce                	mv	s1,s3
    80000cb0:	b7c1                	j	80000c70 <copyin+0x28>
  return 0;
    80000cb2:	4501                	li	a0,0
    80000cb4:	a021                	j	80000cbc <copyin+0x74>
    80000cb6:	4501                	li	a0,0
}
    80000cb8:	8082                	ret
      return -1;
    80000cba:	557d                	li	a0,-1
}
    80000cbc:	60a6                	ld	ra,72(sp)
    80000cbe:	6406                	ld	s0,64(sp)
    80000cc0:	74e2                	ld	s1,56(sp)
    80000cc2:	7942                	ld	s2,48(sp)
    80000cc4:	79a2                	ld	s3,40(sp)
    80000cc6:	7a02                	ld	s4,32(sp)
    80000cc8:	6ae2                	ld	s5,24(sp)
    80000cca:	6b42                	ld	s6,16(sp)
    80000ccc:	6ba2                	ld	s7,8(sp)
    80000cce:	6c02                	ld	s8,0(sp)
    80000cd0:	6161                	addi	sp,sp,80
    80000cd2:	8082                	ret

0000000080000cd4 <copyinstr>:
  while(got_null == 0 && max > 0){
    80000cd4:	c6c5                	beqz	a3,80000d7c <copyinstr+0xa8>
{
    80000cd6:	715d                	addi	sp,sp,-80
    80000cd8:	e486                	sd	ra,72(sp)
    80000cda:	e0a2                	sd	s0,64(sp)
    80000cdc:	fc26                	sd	s1,56(sp)
    80000cde:	f84a                	sd	s2,48(sp)
    80000ce0:	f44e                	sd	s3,40(sp)
    80000ce2:	f052                	sd	s4,32(sp)
    80000ce4:	ec56                	sd	s5,24(sp)
    80000ce6:	e85a                	sd	s6,16(sp)
    80000ce8:	e45e                	sd	s7,8(sp)
    80000cea:	0880                	addi	s0,sp,80
    80000cec:	8a2a                	mv	s4,a0
    80000cee:	8b2e                	mv	s6,a1
    80000cf0:	8bb2                	mv	s7,a2
    80000cf2:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000cf4:	7afd                	lui	s5,0xfffff
    n = PGSIZE - (srcva - va0);
    80000cf6:	6985                	lui	s3,0x1
    80000cf8:	a035                	j	80000d24 <copyinstr+0x50>
        *dst = '\0';
    80000cfa:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000cfe:	4785                	li	a5,1
  if(got_null){
    80000d00:	0017b793          	seqz	a5,a5
    80000d04:	40f00533          	neg	a0,a5
}
    80000d08:	60a6                	ld	ra,72(sp)
    80000d0a:	6406                	ld	s0,64(sp)
    80000d0c:	74e2                	ld	s1,56(sp)
    80000d0e:	7942                	ld	s2,48(sp)
    80000d10:	79a2                	ld	s3,40(sp)
    80000d12:	7a02                	ld	s4,32(sp)
    80000d14:	6ae2                	ld	s5,24(sp)
    80000d16:	6b42                	ld	s6,16(sp)
    80000d18:	6ba2                	ld	s7,8(sp)
    80000d1a:	6161                	addi	sp,sp,80
    80000d1c:	8082                	ret
    srcva = va0 + PGSIZE;
    80000d1e:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000d22:	c8a9                	beqz	s1,80000d74 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000d24:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d28:	85ca                	mv	a1,s2
    80000d2a:	8552                	mv	a0,s4
    80000d2c:	00000097          	auipc	ra,0x0
    80000d30:	88c080e7          	jalr	-1908(ra) # 800005b8 <walkaddr>
    if(pa0 == 0)
    80000d34:	c131                	beqz	a0,80000d78 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000d36:	41790833          	sub	a6,s2,s7
    80000d3a:	984e                	add	a6,a6,s3
    if(n > max)
    80000d3c:	0104f363          	bgeu	s1,a6,80000d42 <copyinstr+0x6e>
    80000d40:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000d42:	955e                	add	a0,a0,s7
    80000d44:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000d48:	fc080be3          	beqz	a6,80000d1e <copyinstr+0x4a>
    80000d4c:	985a                	add	a6,a6,s6
    80000d4e:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000d50:	41650633          	sub	a2,a0,s6
    80000d54:	14fd                	addi	s1,s1,-1
    80000d56:	9b26                	add	s6,s6,s1
    80000d58:	00f60733          	add	a4,a2,a5
    80000d5c:	00074703          	lbu	a4,0(a4)
    80000d60:	df49                	beqz	a4,80000cfa <copyinstr+0x26>
        *dst = *p;
    80000d62:	00e78023          	sb	a4,0(a5)
      --max;
    80000d66:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d6a:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d6c:	ff0796e3          	bne	a5,a6,80000d58 <copyinstr+0x84>
      dst++;
    80000d70:	8b42                	mv	s6,a6
    80000d72:	b775                	j	80000d1e <copyinstr+0x4a>
    80000d74:	4781                	li	a5,0
    80000d76:	b769                	j	80000d00 <copyinstr+0x2c>
      return -1;
    80000d78:	557d                	li	a0,-1
    80000d7a:	b779                	j	80000d08 <copyinstr+0x34>
  int got_null = 0;
    80000d7c:	4781                	li	a5,0
  if(got_null){
    80000d7e:	0017b793          	seqz	a5,a5
    80000d82:	40f00533          	neg	a0,a5
}
    80000d86:	8082                	ret

0000000080000d88 <vmprint>:
void vmprint(pagetable_t pagetable){
    80000d88:	1101                	addi	sp,sp,-32
    80000d8a:	ec06                	sd	ra,24(sp)
    80000d8c:	e822                	sd	s0,16(sp)
    80000d8e:	e426                	sd	s1,8(sp)
    80000d90:	1000                	addi	s0,sp,32
    80000d92:	84aa                	mv	s1,a0
    printf("page table %p\n",pagetable);
    80000d94:	85aa                	mv	a1,a0
    80000d96:	00007517          	auipc	a0,0x7
    80000d9a:	3e250513          	addi	a0,a0,994 # 80008178 <etext+0x178>
    80000d9e:	00005097          	auipc	ra,0x5
    80000da2:	064080e7          	jalr	100(ra) # 80005e02 <printf>
    vmprint_helper(pagetable,1);
    80000da6:	4585                	li	a1,1
    80000da8:	8526                	mv	a0,s1
    80000daa:	fffff097          	auipc	ra,0xfffff
    80000dae:	692080e7          	jalr	1682(ra) # 8000043c <vmprint_helper>
    return;
}
    80000db2:	60e2                	ld	ra,24(sp)
    80000db4:	6442                	ld	s0,16(sp)
    80000db6:	64a2                	ld	s1,8(sp)
    80000db8:	6105                	addi	sp,sp,32
    80000dba:	8082                	ret

0000000080000dbc <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000dbc:	7139                	addi	sp,sp,-64
    80000dbe:	fc06                	sd	ra,56(sp)
    80000dc0:	f822                	sd	s0,48(sp)
    80000dc2:	f426                	sd	s1,40(sp)
    80000dc4:	f04a                	sd	s2,32(sp)
    80000dc6:	ec4e                	sd	s3,24(sp)
    80000dc8:	e852                	sd	s4,16(sp)
    80000dca:	e456                	sd	s5,8(sp)
    80000dcc:	e05a                	sd	s6,0(sp)
    80000dce:	0080                	addi	s0,sp,64
    80000dd0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd2:	00008497          	auipc	s1,0x8
    80000dd6:	6ae48493          	addi	s1,s1,1710 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000dda:	8b26                	mv	s6,s1
    80000ddc:	00007a97          	auipc	s5,0x7
    80000de0:	224a8a93          	addi	s5,s5,548 # 80008000 <etext>
    80000de4:	01000937          	lui	s2,0x1000
    80000de8:	197d                	addi	s2,s2,-1
    80000dea:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dec:	0000ea17          	auipc	s4,0xe
    80000df0:	094a0a13          	addi	s4,s4,148 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000df4:	fffff097          	auipc	ra,0xfffff
    80000df8:	324080e7          	jalr	804(ra) # 80000118 <kalloc>
    80000dfc:	862a                	mv	a2,a0
    if(pa == 0)
    80000dfe:	c129                	beqz	a0,80000e40 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e00:	416485b3          	sub	a1,s1,s6
    80000e04:	858d                	srai	a1,a1,0x3
    80000e06:	000ab783          	ld	a5,0(s5)
    80000e0a:	02f585b3          	mul	a1,a1,a5
    80000e0e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e12:	4719                	li	a4,6
    80000e14:	6685                	lui	a3,0x1
    80000e16:	40b905b3          	sub	a1,s2,a1
    80000e1a:	854e                	mv	a0,s3
    80000e1c:	00000097          	auipc	ra,0x0
    80000e20:	87e080e7          	jalr	-1922(ra) # 8000069a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e24:	16848493          	addi	s1,s1,360
    80000e28:	fd4496e3          	bne	s1,s4,80000df4 <proc_mapstacks+0x38>
  }
}
    80000e2c:	70e2                	ld	ra,56(sp)
    80000e2e:	7442                	ld	s0,48(sp)
    80000e30:	74a2                	ld	s1,40(sp)
    80000e32:	7902                	ld	s2,32(sp)
    80000e34:	69e2                	ld	s3,24(sp)
    80000e36:	6a42                	ld	s4,16(sp)
    80000e38:	6aa2                	ld	s5,8(sp)
    80000e3a:	6b02                	ld	s6,0(sp)
    80000e3c:	6121                	addi	sp,sp,64
    80000e3e:	8082                	ret
      panic("kalloc");
    80000e40:	00007517          	auipc	a0,0x7
    80000e44:	34850513          	addi	a0,a0,840 # 80008188 <etext+0x188>
    80000e48:	00005097          	auipc	ra,0x5
    80000e4c:	f70080e7          	jalr	-144(ra) # 80005db8 <panic>

0000000080000e50 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e50:	7139                	addi	sp,sp,-64
    80000e52:	fc06                	sd	ra,56(sp)
    80000e54:	f822                	sd	s0,48(sp)
    80000e56:	f426                	sd	s1,40(sp)
    80000e58:	f04a                	sd	s2,32(sp)
    80000e5a:	ec4e                	sd	s3,24(sp)
    80000e5c:	e852                	sd	s4,16(sp)
    80000e5e:	e456                	sd	s5,8(sp)
    80000e60:	e05a                	sd	s6,0(sp)
    80000e62:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e64:	00007597          	auipc	a1,0x7
    80000e68:	32c58593          	addi	a1,a1,812 # 80008190 <etext+0x190>
    80000e6c:	00008517          	auipc	a0,0x8
    80000e70:	1e450513          	addi	a0,a0,484 # 80009050 <pid_lock>
    80000e74:	00005097          	auipc	ra,0x5
    80000e78:	3fe080e7          	jalr	1022(ra) # 80006272 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e7c:	00007597          	auipc	a1,0x7
    80000e80:	31c58593          	addi	a1,a1,796 # 80008198 <etext+0x198>
    80000e84:	00008517          	auipc	a0,0x8
    80000e88:	1e450513          	addi	a0,a0,484 # 80009068 <wait_lock>
    80000e8c:	00005097          	auipc	ra,0x5
    80000e90:	3e6080e7          	jalr	998(ra) # 80006272 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e94:	00008497          	auipc	s1,0x8
    80000e98:	5ec48493          	addi	s1,s1,1516 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000e9c:	00007b17          	auipc	s6,0x7
    80000ea0:	30cb0b13          	addi	s6,s6,780 # 800081a8 <etext+0x1a8>
      p->kstack = KSTACK((int) (p - proc));
    80000ea4:	8aa6                	mv	s5,s1
    80000ea6:	00007a17          	auipc	s4,0x7
    80000eaa:	15aa0a13          	addi	s4,s4,346 # 80008000 <etext>
    80000eae:	01000937          	lui	s2,0x1000
    80000eb2:	197d                	addi	s2,s2,-1
    80000eb4:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eb6:	0000e997          	auipc	s3,0xe
    80000eba:	fca98993          	addi	s3,s3,-54 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000ebe:	85da                	mv	a1,s6
    80000ec0:	8526                	mv	a0,s1
    80000ec2:	00005097          	auipc	ra,0x5
    80000ec6:	3b0080e7          	jalr	944(ra) # 80006272 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000eca:	415487b3          	sub	a5,s1,s5
    80000ece:	878d                	srai	a5,a5,0x3
    80000ed0:	000a3703          	ld	a4,0(s4)
    80000ed4:	02e787b3          	mul	a5,a5,a4
    80000ed8:	00d7979b          	slliw	a5,a5,0xd
    80000edc:	40f907b3          	sub	a5,s2,a5
    80000ee0:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ee2:	16848493          	addi	s1,s1,360
    80000ee6:	fd349ce3          	bne	s1,s3,80000ebe <procinit+0x6e>
  }
}
    80000eea:	70e2                	ld	ra,56(sp)
    80000eec:	7442                	ld	s0,48(sp)
    80000eee:	74a2                	ld	s1,40(sp)
    80000ef0:	7902                	ld	s2,32(sp)
    80000ef2:	69e2                	ld	s3,24(sp)
    80000ef4:	6a42                	ld	s4,16(sp)
    80000ef6:	6aa2                	ld	s5,8(sp)
    80000ef8:	6b02                	ld	s6,0(sp)
    80000efa:	6121                	addi	sp,sp,64
    80000efc:	8082                	ret

0000000080000efe <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000efe:	1141                	addi	sp,sp,-16
    80000f00:	e422                	sd	s0,8(sp)
    80000f02:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f04:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f06:	2501                	sext.w	a0,a0
    80000f08:	6422                	ld	s0,8(sp)
    80000f0a:	0141                	addi	sp,sp,16
    80000f0c:	8082                	ret

0000000080000f0e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f0e:	1141                	addi	sp,sp,-16
    80000f10:	e422                	sd	s0,8(sp)
    80000f12:	0800                	addi	s0,sp,16
    80000f14:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f16:	2781                	sext.w	a5,a5
    80000f18:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f1a:	00008517          	auipc	a0,0x8
    80000f1e:	16650513          	addi	a0,a0,358 # 80009080 <cpus>
    80000f22:	953e                	add	a0,a0,a5
    80000f24:	6422                	ld	s0,8(sp)
    80000f26:	0141                	addi	sp,sp,16
    80000f28:	8082                	ret

0000000080000f2a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f2a:	1101                	addi	sp,sp,-32
    80000f2c:	ec06                	sd	ra,24(sp)
    80000f2e:	e822                	sd	s0,16(sp)
    80000f30:	e426                	sd	s1,8(sp)
    80000f32:	1000                	addi	s0,sp,32
  push_off();
    80000f34:	00005097          	auipc	ra,0x5
    80000f38:	382080e7          	jalr	898(ra) # 800062b6 <push_off>
    80000f3c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f3e:	2781                	sext.w	a5,a5
    80000f40:	079e                	slli	a5,a5,0x7
    80000f42:	00008717          	auipc	a4,0x8
    80000f46:	10e70713          	addi	a4,a4,270 # 80009050 <pid_lock>
    80000f4a:	97ba                	add	a5,a5,a4
    80000f4c:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f4e:	00005097          	auipc	ra,0x5
    80000f52:	408080e7          	jalr	1032(ra) # 80006356 <pop_off>
  return p;
}
    80000f56:	8526                	mv	a0,s1
    80000f58:	60e2                	ld	ra,24(sp)
    80000f5a:	6442                	ld	s0,16(sp)
    80000f5c:	64a2                	ld	s1,8(sp)
    80000f5e:	6105                	addi	sp,sp,32
    80000f60:	8082                	ret

0000000080000f62 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f62:	1141                	addi	sp,sp,-16
    80000f64:	e406                	sd	ra,8(sp)
    80000f66:	e022                	sd	s0,0(sp)
    80000f68:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f6a:	00000097          	auipc	ra,0x0
    80000f6e:	fc0080e7          	jalr	-64(ra) # 80000f2a <myproc>
    80000f72:	00005097          	auipc	ra,0x5
    80000f76:	444080e7          	jalr	1092(ra) # 800063b6 <release>

  if (first) {
    80000f7a:	00008797          	auipc	a5,0x8
    80000f7e:	9167a783          	lw	a5,-1770(a5) # 80008890 <first.1681>
    80000f82:	eb89                	bnez	a5,80000f94 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f84:	00001097          	auipc	ra,0x1
    80000f88:	cc0080e7          	jalr	-832(ra) # 80001c44 <usertrapret>
}
    80000f8c:	60a2                	ld	ra,8(sp)
    80000f8e:	6402                	ld	s0,0(sp)
    80000f90:	0141                	addi	sp,sp,16
    80000f92:	8082                	ret
    first = 0;
    80000f94:	00008797          	auipc	a5,0x8
    80000f98:	8e07ae23          	sw	zero,-1796(a5) # 80008890 <first.1681>
    fsinit(ROOTDEV);
    80000f9c:	4505                	li	a0,1
    80000f9e:	00002097          	auipc	ra,0x2
    80000fa2:	ad8080e7          	jalr	-1320(ra) # 80002a76 <fsinit>
    80000fa6:	bff9                	j	80000f84 <forkret+0x22>

0000000080000fa8 <allocpid>:
allocpid() {
    80000fa8:	1101                	addi	sp,sp,-32
    80000faa:	ec06                	sd	ra,24(sp)
    80000fac:	e822                	sd	s0,16(sp)
    80000fae:	e426                	sd	s1,8(sp)
    80000fb0:	e04a                	sd	s2,0(sp)
    80000fb2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fb4:	00008917          	auipc	s2,0x8
    80000fb8:	09c90913          	addi	s2,s2,156 # 80009050 <pid_lock>
    80000fbc:	854a                	mv	a0,s2
    80000fbe:	00005097          	auipc	ra,0x5
    80000fc2:	344080e7          	jalr	836(ra) # 80006302 <acquire>
  pid = nextpid;
    80000fc6:	00008797          	auipc	a5,0x8
    80000fca:	8ce78793          	addi	a5,a5,-1842 # 80008894 <nextpid>
    80000fce:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fd0:	0014871b          	addiw	a4,s1,1
    80000fd4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fd6:	854a                	mv	a0,s2
    80000fd8:	00005097          	auipc	ra,0x5
    80000fdc:	3de080e7          	jalr	990(ra) # 800063b6 <release>
}
    80000fe0:	8526                	mv	a0,s1
    80000fe2:	60e2                	ld	ra,24(sp)
    80000fe4:	6442                	ld	s0,16(sp)
    80000fe6:	64a2                	ld	s1,8(sp)
    80000fe8:	6902                	ld	s2,0(sp)
    80000fea:	6105                	addi	sp,sp,32
    80000fec:	8082                	ret

0000000080000fee <proc_pagetable>:
{
    80000fee:	7179                	addi	sp,sp,-48
    80000ff0:	f406                	sd	ra,40(sp)
    80000ff2:	f022                	sd	s0,32(sp)
    80000ff4:	ec26                	sd	s1,24(sp)
    80000ff6:	e84a                	sd	s2,16(sp)
    80000ff8:	e44e                	sd	s3,8(sp)
    80000ffa:	1800                	addi	s0,sp,48
    80000ffc:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000ffe:	00000097          	auipc	ra,0x0
    80001002:	886080e7          	jalr	-1914(ra) # 80000884 <uvmcreate>
    80001006:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001008:	c535                	beqz	a0,80001074 <proc_pagetable+0x86>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000100a:	4729                	li	a4,10
    8000100c:	00006697          	auipc	a3,0x6
    80001010:	ff468693          	addi	a3,a3,-12 # 80007000 <_trampoline>
    80001014:	6605                	lui	a2,0x1
    80001016:	040005b7          	lui	a1,0x4000
    8000101a:	15fd                	addi	a1,a1,-1
    8000101c:	05b2                	slli	a1,a1,0xc
    8000101e:	fffff097          	auipc	ra,0xfffff
    80001022:	5dc080e7          	jalr	1500(ra) # 800005fa <mappages>
    80001026:	04054f63          	bltz	a0,80001084 <proc_pagetable+0x96>
  struct usyscall* usc = (struct usyscall *)kalloc();
    8000102a:	fffff097          	auipc	ra,0xfffff
    8000102e:	0ee080e7          	jalr	238(ra) # 80000118 <kalloc>
    80001032:	89aa                	mv	s3,a0
  usc->pid = p->pid;
    80001034:	03092783          	lw	a5,48(s2)
    80001038:	c11c                	sw	a5,0(a0)
  if(mappages(pagetable,USYSCALL,PGSIZE,(uint64)(usc), PTE_R | PTE_U) < 0){
    8000103a:	4749                	li	a4,18
    8000103c:	86aa                	mv	a3,a0
    8000103e:	6605                	lui	a2,0x1
    80001040:	040005b7          	lui	a1,0x4000
    80001044:	15f5                	addi	a1,a1,-3
    80001046:	05b2                	slli	a1,a1,0xc
    80001048:	8526                	mv	a0,s1
    8000104a:	fffff097          	auipc	ra,0xfffff
    8000104e:	5b0080e7          	jalr	1456(ra) # 800005fa <mappages>
    80001052:	04054163          	bltz	a0,80001094 <proc_pagetable+0xa6>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001056:	4719                	li	a4,6
    80001058:	05893683          	ld	a3,88(s2)
    8000105c:	6605                	lui	a2,0x1
    8000105e:	020005b7          	lui	a1,0x2000
    80001062:	15fd                	addi	a1,a1,-1
    80001064:	05b6                	slli	a1,a1,0xd
    80001066:	8526                	mv	a0,s1
    80001068:	fffff097          	auipc	ra,0xfffff
    8000106c:	592080e7          	jalr	1426(ra) # 800005fa <mappages>
    80001070:	04054a63          	bltz	a0,800010c4 <proc_pagetable+0xd6>
}
    80001074:	8526                	mv	a0,s1
    80001076:	70a2                	ld	ra,40(sp)
    80001078:	7402                	ld	s0,32(sp)
    8000107a:	64e2                	ld	s1,24(sp)
    8000107c:	6942                	ld	s2,16(sp)
    8000107e:	69a2                	ld	s3,8(sp)
    80001080:	6145                	addi	sp,sp,48
    80001082:	8082                	ret
    uvmfree(pagetable, 0);
    80001084:	4581                	li	a1,0
    80001086:	8526                	mv	a0,s1
    80001088:	00000097          	auipc	ra,0x0
    8000108c:	9f8080e7          	jalr	-1544(ra) # 80000a80 <uvmfree>
    return 0;
    80001090:	4481                	li	s1,0
    80001092:	b7cd                	j	80001074 <proc_pagetable+0x86>
    kfree(usc);
    80001094:	854e                	mv	a0,s3
    80001096:	fffff097          	auipc	ra,0xfffff
    8000109a:	f86080e7          	jalr	-122(ra) # 8000001c <kfree>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000109e:	4681                	li	a3,0
    800010a0:	4605                	li	a2,1
    800010a2:	040005b7          	lui	a1,0x4000
    800010a6:	15fd                	addi	a1,a1,-1
    800010a8:	05b2                	slli	a1,a1,0xc
    800010aa:	8526                	mv	a0,s1
    800010ac:	fffff097          	auipc	ra,0xfffff
    800010b0:	714080e7          	jalr	1812(ra) # 800007c0 <uvmunmap>
    uvmfree(pagetable, 0);
    800010b4:	4581                	li	a1,0
    800010b6:	8526                	mv	a0,s1
    800010b8:	00000097          	auipc	ra,0x0
    800010bc:	9c8080e7          	jalr	-1592(ra) # 80000a80 <uvmfree>
    return 0;
    800010c0:	4481                	li	s1,0
    800010c2:	bf4d                	j	80001074 <proc_pagetable+0x86>
    kfree(usc);
    800010c4:	854e                	mv	a0,s3
    800010c6:	fffff097          	auipc	ra,0xfffff
    800010ca:	f56080e7          	jalr	-170(ra) # 8000001c <kfree>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010ce:	4681                	li	a3,0
    800010d0:	4605                	li	a2,1
    800010d2:	04000937          	lui	s2,0x4000
    800010d6:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    800010da:	05b2                	slli	a1,a1,0xc
    800010dc:	8526                	mv	a0,s1
    800010de:	fffff097          	auipc	ra,0xfffff
    800010e2:	6e2080e7          	jalr	1762(ra) # 800007c0 <uvmunmap>
    uvmunmap(pagetable, USYSCALL, 1, 0);
    800010e6:	4681                	li	a3,0
    800010e8:	4605                	li	a2,1
    800010ea:	ffd90593          	addi	a1,s2,-3
    800010ee:	05b2                	slli	a1,a1,0xc
    800010f0:	8526                	mv	a0,s1
    800010f2:	fffff097          	auipc	ra,0xfffff
    800010f6:	6ce080e7          	jalr	1742(ra) # 800007c0 <uvmunmap>
    uvmfree(pagetable, 0);
    800010fa:	4581                	li	a1,0
    800010fc:	8526                	mv	a0,s1
    800010fe:	00000097          	auipc	ra,0x0
    80001102:	982080e7          	jalr	-1662(ra) # 80000a80 <uvmfree>
    return 0;
    80001106:	4481                	li	s1,0
    80001108:	b7b5                	j	80001074 <proc_pagetable+0x86>

000000008000110a <proc_freepagetable>:
{
    8000110a:	7179                	addi	sp,sp,-48
    8000110c:	f406                	sd	ra,40(sp)
    8000110e:	f022                	sd	s0,32(sp)
    80001110:	ec26                	sd	s1,24(sp)
    80001112:	e84a                	sd	s2,16(sp)
    80001114:	e44e                	sd	s3,8(sp)
    80001116:	e052                	sd	s4,0(sp)
    80001118:	1800                	addi	s0,sp,48
    8000111a:	84aa                	mv	s1,a0
    8000111c:	89ae                	mv	s3,a1
  kfree((char *)walkaddr(pagetable,USYSCALL));
    8000111e:	04000937          	lui	s2,0x4000
    80001122:	ffd90a13          	addi	s4,s2,-3 # 3fffffd <_entry-0x7c000003>
    80001126:	00ca1593          	slli	a1,s4,0xc
    8000112a:	fffff097          	auipc	ra,0xfffff
    8000112e:	48e080e7          	jalr	1166(ra) # 800005b8 <walkaddr>
    80001132:	fffff097          	auipc	ra,0xfffff
    80001136:	eea080e7          	jalr	-278(ra) # 8000001c <kfree>
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000113a:	4681                	li	a3,0
    8000113c:	4605                	li	a2,1
    8000113e:	197d                	addi	s2,s2,-1
    80001140:	00c91593          	slli	a1,s2,0xc
    80001144:	8526                	mv	a0,s1
    80001146:	fffff097          	auipc	ra,0xfffff
    8000114a:	67a080e7          	jalr	1658(ra) # 800007c0 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000114e:	4681                	li	a3,0
    80001150:	4605                	li	a2,1
    80001152:	020005b7          	lui	a1,0x2000
    80001156:	15fd                	addi	a1,a1,-1
    80001158:	05b6                	slli	a1,a1,0xd
    8000115a:	8526                	mv	a0,s1
    8000115c:	fffff097          	auipc	ra,0xfffff
    80001160:	664080e7          	jalr	1636(ra) # 800007c0 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    80001164:	4681                	li	a3,0
    80001166:	4605                	li	a2,1
    80001168:	00ca1593          	slli	a1,s4,0xc
    8000116c:	8526                	mv	a0,s1
    8000116e:	fffff097          	auipc	ra,0xfffff
    80001172:	652080e7          	jalr	1618(ra) # 800007c0 <uvmunmap>
  uvmfree(pagetable, sz);
    80001176:	85ce                	mv	a1,s3
    80001178:	8526                	mv	a0,s1
    8000117a:	00000097          	auipc	ra,0x0
    8000117e:	906080e7          	jalr	-1786(ra) # 80000a80 <uvmfree>
}
    80001182:	70a2                	ld	ra,40(sp)
    80001184:	7402                	ld	s0,32(sp)
    80001186:	64e2                	ld	s1,24(sp)
    80001188:	6942                	ld	s2,16(sp)
    8000118a:	69a2                	ld	s3,8(sp)
    8000118c:	6a02                	ld	s4,0(sp)
    8000118e:	6145                	addi	sp,sp,48
    80001190:	8082                	ret

0000000080001192 <freeproc>:
{
    80001192:	1101                	addi	sp,sp,-32
    80001194:	ec06                	sd	ra,24(sp)
    80001196:	e822                	sd	s0,16(sp)
    80001198:	e426                	sd	s1,8(sp)
    8000119a:	1000                	addi	s0,sp,32
    8000119c:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000119e:	6d28                	ld	a0,88(a0)
    800011a0:	c509                	beqz	a0,800011aa <freeproc+0x18>
    kfree((void*)p->trapframe);
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	e7a080e7          	jalr	-390(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800011aa:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800011ae:	68a8                	ld	a0,80(s1)
    800011b0:	c511                	beqz	a0,800011bc <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800011b2:	64ac                	ld	a1,72(s1)
    800011b4:	00000097          	auipc	ra,0x0
    800011b8:	f56080e7          	jalr	-170(ra) # 8000110a <proc_freepagetable>
  p->pagetable = 0;
    800011bc:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011c0:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011c4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011c8:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011cc:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800011d0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011d4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011d8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011dc:	0004ac23          	sw	zero,24(s1)
}
    800011e0:	60e2                	ld	ra,24(sp)
    800011e2:	6442                	ld	s0,16(sp)
    800011e4:	64a2                	ld	s1,8(sp)
    800011e6:	6105                	addi	sp,sp,32
    800011e8:	8082                	ret

00000000800011ea <allocproc>:
{
    800011ea:	1101                	addi	sp,sp,-32
    800011ec:	ec06                	sd	ra,24(sp)
    800011ee:	e822                	sd	s0,16(sp)
    800011f0:	e426                	sd	s1,8(sp)
    800011f2:	e04a                	sd	s2,0(sp)
    800011f4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011f6:	00008497          	auipc	s1,0x8
    800011fa:	28a48493          	addi	s1,s1,650 # 80009480 <proc>
    800011fe:	0000e917          	auipc	s2,0xe
    80001202:	c8290913          	addi	s2,s2,-894 # 8000ee80 <tickslock>
    acquire(&p->lock);
    80001206:	8526                	mv	a0,s1
    80001208:	00005097          	auipc	ra,0x5
    8000120c:	0fa080e7          	jalr	250(ra) # 80006302 <acquire>
    if(p->state == UNUSED) {
    80001210:	4c9c                	lw	a5,24(s1)
    80001212:	cf81                	beqz	a5,8000122a <allocproc+0x40>
      release(&p->lock);
    80001214:	8526                	mv	a0,s1
    80001216:	00005097          	auipc	ra,0x5
    8000121a:	1a0080e7          	jalr	416(ra) # 800063b6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000121e:	16848493          	addi	s1,s1,360
    80001222:	ff2492e3          	bne	s1,s2,80001206 <allocproc+0x1c>
  return 0;
    80001226:	4481                	li	s1,0
    80001228:	a889                	j	8000127a <allocproc+0x90>
  p->pid = allocpid();
    8000122a:	00000097          	auipc	ra,0x0
    8000122e:	d7e080e7          	jalr	-642(ra) # 80000fa8 <allocpid>
    80001232:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001234:	4785                	li	a5,1
    80001236:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001238:	fffff097          	auipc	ra,0xfffff
    8000123c:	ee0080e7          	jalr	-288(ra) # 80000118 <kalloc>
    80001240:	892a                	mv	s2,a0
    80001242:	eca8                	sd	a0,88(s1)
    80001244:	c131                	beqz	a0,80001288 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001246:	8526                	mv	a0,s1
    80001248:	00000097          	auipc	ra,0x0
    8000124c:	da6080e7          	jalr	-602(ra) # 80000fee <proc_pagetable>
    80001250:	892a                	mv	s2,a0
    80001252:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001254:	c531                	beqz	a0,800012a0 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001256:	07000613          	li	a2,112
    8000125a:	4581                	li	a1,0
    8000125c:	06048513          	addi	a0,s1,96
    80001260:	fffff097          	auipc	ra,0xfffff
    80001264:	f18080e7          	jalr	-232(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001268:	00000797          	auipc	a5,0x0
    8000126c:	cfa78793          	addi	a5,a5,-774 # 80000f62 <forkret>
    80001270:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001272:	60bc                	ld	a5,64(s1)
    80001274:	6705                	lui	a4,0x1
    80001276:	97ba                	add	a5,a5,a4
    80001278:	f4bc                	sd	a5,104(s1)
}
    8000127a:	8526                	mv	a0,s1
    8000127c:	60e2                	ld	ra,24(sp)
    8000127e:	6442                	ld	s0,16(sp)
    80001280:	64a2                	ld	s1,8(sp)
    80001282:	6902                	ld	s2,0(sp)
    80001284:	6105                	addi	sp,sp,32
    80001286:	8082                	ret
    freeproc(p);
    80001288:	8526                	mv	a0,s1
    8000128a:	00000097          	auipc	ra,0x0
    8000128e:	f08080e7          	jalr	-248(ra) # 80001192 <freeproc>
    release(&p->lock);
    80001292:	8526                	mv	a0,s1
    80001294:	00005097          	auipc	ra,0x5
    80001298:	122080e7          	jalr	290(ra) # 800063b6 <release>
    return 0;
    8000129c:	84ca                	mv	s1,s2
    8000129e:	bff1                	j	8000127a <allocproc+0x90>
    freeproc(p);
    800012a0:	8526                	mv	a0,s1
    800012a2:	00000097          	auipc	ra,0x0
    800012a6:	ef0080e7          	jalr	-272(ra) # 80001192 <freeproc>
    release(&p->lock);
    800012aa:	8526                	mv	a0,s1
    800012ac:	00005097          	auipc	ra,0x5
    800012b0:	10a080e7          	jalr	266(ra) # 800063b6 <release>
    return 0;
    800012b4:	84ca                	mv	s1,s2
    800012b6:	b7d1                	j	8000127a <allocproc+0x90>

00000000800012b8 <userinit>:
{
    800012b8:	1101                	addi	sp,sp,-32
    800012ba:	ec06                	sd	ra,24(sp)
    800012bc:	e822                	sd	s0,16(sp)
    800012be:	e426                	sd	s1,8(sp)
    800012c0:	1000                	addi	s0,sp,32
  p = allocproc();
    800012c2:	00000097          	auipc	ra,0x0
    800012c6:	f28080e7          	jalr	-216(ra) # 800011ea <allocproc>
    800012ca:	84aa                	mv	s1,a0
  initproc = p;
    800012cc:	00008797          	auipc	a5,0x8
    800012d0:	d4a7b223          	sd	a0,-700(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800012d4:	03400613          	li	a2,52
    800012d8:	00007597          	auipc	a1,0x7
    800012dc:	5c858593          	addi	a1,a1,1480 # 800088a0 <initcode>
    800012e0:	6928                	ld	a0,80(a0)
    800012e2:	fffff097          	auipc	ra,0xfffff
    800012e6:	5d0080e7          	jalr	1488(ra) # 800008b2 <uvminit>
  p->sz = PGSIZE;
    800012ea:	6785                	lui	a5,0x1
    800012ec:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800012ee:	6cb8                	ld	a4,88(s1)
    800012f0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012f4:	6cb8                	ld	a4,88(s1)
    800012f6:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012f8:	4641                	li	a2,16
    800012fa:	00007597          	auipc	a1,0x7
    800012fe:	eb658593          	addi	a1,a1,-330 # 800081b0 <etext+0x1b0>
    80001302:	15848513          	addi	a0,s1,344
    80001306:	fffff097          	auipc	ra,0xfffff
    8000130a:	fc4080e7          	jalr	-60(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    8000130e:	00007517          	auipc	a0,0x7
    80001312:	eb250513          	addi	a0,a0,-334 # 800081c0 <etext+0x1c0>
    80001316:	00002097          	auipc	ra,0x2
    8000131a:	18e080e7          	jalr	398(ra) # 800034a4 <namei>
    8000131e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001322:	478d                	li	a5,3
    80001324:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001326:	8526                	mv	a0,s1
    80001328:	00005097          	auipc	ra,0x5
    8000132c:	08e080e7          	jalr	142(ra) # 800063b6 <release>
}
    80001330:	60e2                	ld	ra,24(sp)
    80001332:	6442                	ld	s0,16(sp)
    80001334:	64a2                	ld	s1,8(sp)
    80001336:	6105                	addi	sp,sp,32
    80001338:	8082                	ret

000000008000133a <growproc>:
{
    8000133a:	1101                	addi	sp,sp,-32
    8000133c:	ec06                	sd	ra,24(sp)
    8000133e:	e822                	sd	s0,16(sp)
    80001340:	e426                	sd	s1,8(sp)
    80001342:	e04a                	sd	s2,0(sp)
    80001344:	1000                	addi	s0,sp,32
    80001346:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001348:	00000097          	auipc	ra,0x0
    8000134c:	be2080e7          	jalr	-1054(ra) # 80000f2a <myproc>
    80001350:	892a                	mv	s2,a0
  sz = p->sz;
    80001352:	652c                	ld	a1,72(a0)
    80001354:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001358:	00904f63          	bgtz	s1,80001376 <growproc+0x3c>
  } else if(n < 0){
    8000135c:	0204cc63          	bltz	s1,80001394 <growproc+0x5a>
  p->sz = sz;
    80001360:	1602                	slli	a2,a2,0x20
    80001362:	9201                	srli	a2,a2,0x20
    80001364:	04c93423          	sd	a2,72(s2)
  return 0;
    80001368:	4501                	li	a0,0
}
    8000136a:	60e2                	ld	ra,24(sp)
    8000136c:	6442                	ld	s0,16(sp)
    8000136e:	64a2                	ld	s1,8(sp)
    80001370:	6902                	ld	s2,0(sp)
    80001372:	6105                	addi	sp,sp,32
    80001374:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001376:	9e25                	addw	a2,a2,s1
    80001378:	1602                	slli	a2,a2,0x20
    8000137a:	9201                	srli	a2,a2,0x20
    8000137c:	1582                	slli	a1,a1,0x20
    8000137e:	9181                	srli	a1,a1,0x20
    80001380:	6928                	ld	a0,80(a0)
    80001382:	fffff097          	auipc	ra,0xfffff
    80001386:	5ea080e7          	jalr	1514(ra) # 8000096c <uvmalloc>
    8000138a:	0005061b          	sext.w	a2,a0
    8000138e:	fa69                	bnez	a2,80001360 <growproc+0x26>
      return -1;
    80001390:	557d                	li	a0,-1
    80001392:	bfe1                	j	8000136a <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001394:	9e25                	addw	a2,a2,s1
    80001396:	1602                	slli	a2,a2,0x20
    80001398:	9201                	srli	a2,a2,0x20
    8000139a:	1582                	slli	a1,a1,0x20
    8000139c:	9181                	srli	a1,a1,0x20
    8000139e:	6928                	ld	a0,80(a0)
    800013a0:	fffff097          	auipc	ra,0xfffff
    800013a4:	584080e7          	jalr	1412(ra) # 80000924 <uvmdealloc>
    800013a8:	0005061b          	sext.w	a2,a0
    800013ac:	bf55                	j	80001360 <growproc+0x26>

00000000800013ae <fork>:
{
    800013ae:	7179                	addi	sp,sp,-48
    800013b0:	f406                	sd	ra,40(sp)
    800013b2:	f022                	sd	s0,32(sp)
    800013b4:	ec26                	sd	s1,24(sp)
    800013b6:	e84a                	sd	s2,16(sp)
    800013b8:	e44e                	sd	s3,8(sp)
    800013ba:	e052                	sd	s4,0(sp)
    800013bc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013be:	00000097          	auipc	ra,0x0
    800013c2:	b6c080e7          	jalr	-1172(ra) # 80000f2a <myproc>
    800013c6:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800013c8:	00000097          	auipc	ra,0x0
    800013cc:	e22080e7          	jalr	-478(ra) # 800011ea <allocproc>
    800013d0:	10050b63          	beqz	a0,800014e6 <fork+0x138>
    800013d4:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013d6:	04893603          	ld	a2,72(s2)
    800013da:	692c                	ld	a1,80(a0)
    800013dc:	05093503          	ld	a0,80(s2)
    800013e0:	fffff097          	auipc	ra,0xfffff
    800013e4:	6d8080e7          	jalr	1752(ra) # 80000ab8 <uvmcopy>
    800013e8:	04054663          	bltz	a0,80001434 <fork+0x86>
  np->sz = p->sz;
    800013ec:	04893783          	ld	a5,72(s2)
    800013f0:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800013f4:	05893683          	ld	a3,88(s2)
    800013f8:	87b6                	mv	a5,a3
    800013fa:	0589b703          	ld	a4,88(s3)
    800013fe:	12068693          	addi	a3,a3,288
    80001402:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001406:	6788                	ld	a0,8(a5)
    80001408:	6b8c                	ld	a1,16(a5)
    8000140a:	6f90                	ld	a2,24(a5)
    8000140c:	01073023          	sd	a6,0(a4)
    80001410:	e708                	sd	a0,8(a4)
    80001412:	eb0c                	sd	a1,16(a4)
    80001414:	ef10                	sd	a2,24(a4)
    80001416:	02078793          	addi	a5,a5,32
    8000141a:	02070713          	addi	a4,a4,32
    8000141e:	fed792e3          	bne	a5,a3,80001402 <fork+0x54>
  np->trapframe->a0 = 0;
    80001422:	0589b783          	ld	a5,88(s3)
    80001426:	0607b823          	sd	zero,112(a5)
    8000142a:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    8000142e:	15000a13          	li	s4,336
    80001432:	a03d                	j	80001460 <fork+0xb2>
    freeproc(np);
    80001434:	854e                	mv	a0,s3
    80001436:	00000097          	auipc	ra,0x0
    8000143a:	d5c080e7          	jalr	-676(ra) # 80001192 <freeproc>
    release(&np->lock);
    8000143e:	854e                	mv	a0,s3
    80001440:	00005097          	auipc	ra,0x5
    80001444:	f76080e7          	jalr	-138(ra) # 800063b6 <release>
    return -1;
    80001448:	5a7d                	li	s4,-1
    8000144a:	a069                	j	800014d4 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    8000144c:	00002097          	auipc	ra,0x2
    80001450:	6ee080e7          	jalr	1774(ra) # 80003b3a <filedup>
    80001454:	009987b3          	add	a5,s3,s1
    80001458:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000145a:	04a1                	addi	s1,s1,8
    8000145c:	01448763          	beq	s1,s4,8000146a <fork+0xbc>
    if(p->ofile[i])
    80001460:	009907b3          	add	a5,s2,s1
    80001464:	6388                	ld	a0,0(a5)
    80001466:	f17d                	bnez	a0,8000144c <fork+0x9e>
    80001468:	bfcd                	j	8000145a <fork+0xac>
  np->cwd = idup(p->cwd);
    8000146a:	15093503          	ld	a0,336(s2)
    8000146e:	00002097          	auipc	ra,0x2
    80001472:	842080e7          	jalr	-1982(ra) # 80002cb0 <idup>
    80001476:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000147a:	4641                	li	a2,16
    8000147c:	15890593          	addi	a1,s2,344
    80001480:	15898513          	addi	a0,s3,344
    80001484:	fffff097          	auipc	ra,0xfffff
    80001488:	e46080e7          	jalr	-442(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    8000148c:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001490:	854e                	mv	a0,s3
    80001492:	00005097          	auipc	ra,0x5
    80001496:	f24080e7          	jalr	-220(ra) # 800063b6 <release>
  acquire(&wait_lock);
    8000149a:	00008497          	auipc	s1,0x8
    8000149e:	bce48493          	addi	s1,s1,-1074 # 80009068 <wait_lock>
    800014a2:	8526                	mv	a0,s1
    800014a4:	00005097          	auipc	ra,0x5
    800014a8:	e5e080e7          	jalr	-418(ra) # 80006302 <acquire>
  np->parent = p;
    800014ac:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    800014b0:	8526                	mv	a0,s1
    800014b2:	00005097          	auipc	ra,0x5
    800014b6:	f04080e7          	jalr	-252(ra) # 800063b6 <release>
  acquire(&np->lock);
    800014ba:	854e                	mv	a0,s3
    800014bc:	00005097          	auipc	ra,0x5
    800014c0:	e46080e7          	jalr	-442(ra) # 80006302 <acquire>
  np->state = RUNNABLE;
    800014c4:	478d                	li	a5,3
    800014c6:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800014ca:	854e                	mv	a0,s3
    800014cc:	00005097          	auipc	ra,0x5
    800014d0:	eea080e7          	jalr	-278(ra) # 800063b6 <release>
}
    800014d4:	8552                	mv	a0,s4
    800014d6:	70a2                	ld	ra,40(sp)
    800014d8:	7402                	ld	s0,32(sp)
    800014da:	64e2                	ld	s1,24(sp)
    800014dc:	6942                	ld	s2,16(sp)
    800014de:	69a2                	ld	s3,8(sp)
    800014e0:	6a02                	ld	s4,0(sp)
    800014e2:	6145                	addi	sp,sp,48
    800014e4:	8082                	ret
    return -1;
    800014e6:	5a7d                	li	s4,-1
    800014e8:	b7f5                	j	800014d4 <fork+0x126>

00000000800014ea <scheduler>:
{
    800014ea:	7139                	addi	sp,sp,-64
    800014ec:	fc06                	sd	ra,56(sp)
    800014ee:	f822                	sd	s0,48(sp)
    800014f0:	f426                	sd	s1,40(sp)
    800014f2:	f04a                	sd	s2,32(sp)
    800014f4:	ec4e                	sd	s3,24(sp)
    800014f6:	e852                	sd	s4,16(sp)
    800014f8:	e456                	sd	s5,8(sp)
    800014fa:	e05a                	sd	s6,0(sp)
    800014fc:	0080                	addi	s0,sp,64
    800014fe:	8792                	mv	a5,tp
  int id = r_tp();
    80001500:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001502:	00779a93          	slli	s5,a5,0x7
    80001506:	00008717          	auipc	a4,0x8
    8000150a:	b4a70713          	addi	a4,a4,-1206 # 80009050 <pid_lock>
    8000150e:	9756                	add	a4,a4,s5
    80001510:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001514:	00008717          	auipc	a4,0x8
    80001518:	b7470713          	addi	a4,a4,-1164 # 80009088 <cpus+0x8>
    8000151c:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000151e:	498d                	li	s3,3
        p->state = RUNNING;
    80001520:	4b11                	li	s6,4
        c->proc = p;
    80001522:	079e                	slli	a5,a5,0x7
    80001524:	00008a17          	auipc	s4,0x8
    80001528:	b2ca0a13          	addi	s4,s4,-1236 # 80009050 <pid_lock>
    8000152c:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000152e:	0000e917          	auipc	s2,0xe
    80001532:	95290913          	addi	s2,s2,-1710 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001536:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000153a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000153e:	10079073          	csrw	sstatus,a5
    80001542:	00008497          	auipc	s1,0x8
    80001546:	f3e48493          	addi	s1,s1,-194 # 80009480 <proc>
    8000154a:	a03d                	j	80001578 <scheduler+0x8e>
        p->state = RUNNING;
    8000154c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001550:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001554:	06048593          	addi	a1,s1,96
    80001558:	8556                	mv	a0,s5
    8000155a:	00000097          	auipc	ra,0x0
    8000155e:	640080e7          	jalr	1600(ra) # 80001b9a <swtch>
        c->proc = 0;
    80001562:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001566:	8526                	mv	a0,s1
    80001568:	00005097          	auipc	ra,0x5
    8000156c:	e4e080e7          	jalr	-434(ra) # 800063b6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001570:	16848493          	addi	s1,s1,360
    80001574:	fd2481e3          	beq	s1,s2,80001536 <scheduler+0x4c>
      acquire(&p->lock);
    80001578:	8526                	mv	a0,s1
    8000157a:	00005097          	auipc	ra,0x5
    8000157e:	d88080e7          	jalr	-632(ra) # 80006302 <acquire>
      if(p->state == RUNNABLE) {
    80001582:	4c9c                	lw	a5,24(s1)
    80001584:	ff3791e3          	bne	a5,s3,80001566 <scheduler+0x7c>
    80001588:	b7d1                	j	8000154c <scheduler+0x62>

000000008000158a <sched>:
{
    8000158a:	7179                	addi	sp,sp,-48
    8000158c:	f406                	sd	ra,40(sp)
    8000158e:	f022                	sd	s0,32(sp)
    80001590:	ec26                	sd	s1,24(sp)
    80001592:	e84a                	sd	s2,16(sp)
    80001594:	e44e                	sd	s3,8(sp)
    80001596:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001598:	00000097          	auipc	ra,0x0
    8000159c:	992080e7          	jalr	-1646(ra) # 80000f2a <myproc>
    800015a0:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	ce6080e7          	jalr	-794(ra) # 80006288 <holding>
    800015aa:	c93d                	beqz	a0,80001620 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015ac:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015ae:	2781                	sext.w	a5,a5
    800015b0:	079e                	slli	a5,a5,0x7
    800015b2:	00008717          	auipc	a4,0x8
    800015b6:	a9e70713          	addi	a4,a4,-1378 # 80009050 <pid_lock>
    800015ba:	97ba                	add	a5,a5,a4
    800015bc:	0a87a703          	lw	a4,168(a5)
    800015c0:	4785                	li	a5,1
    800015c2:	06f71763          	bne	a4,a5,80001630 <sched+0xa6>
  if(p->state == RUNNING)
    800015c6:	4c98                	lw	a4,24(s1)
    800015c8:	4791                	li	a5,4
    800015ca:	06f70b63          	beq	a4,a5,80001640 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015ce:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015d2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015d4:	efb5                	bnez	a5,80001650 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015d6:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015d8:	00008917          	auipc	s2,0x8
    800015dc:	a7890913          	addi	s2,s2,-1416 # 80009050 <pid_lock>
    800015e0:	2781                	sext.w	a5,a5
    800015e2:	079e                	slli	a5,a5,0x7
    800015e4:	97ca                	add	a5,a5,s2
    800015e6:	0ac7a983          	lw	s3,172(a5)
    800015ea:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015ec:	2781                	sext.w	a5,a5
    800015ee:	079e                	slli	a5,a5,0x7
    800015f0:	00008597          	auipc	a1,0x8
    800015f4:	a9858593          	addi	a1,a1,-1384 # 80009088 <cpus+0x8>
    800015f8:	95be                	add	a1,a1,a5
    800015fa:	06048513          	addi	a0,s1,96
    800015fe:	00000097          	auipc	ra,0x0
    80001602:	59c080e7          	jalr	1436(ra) # 80001b9a <swtch>
    80001606:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001608:	2781                	sext.w	a5,a5
    8000160a:	079e                	slli	a5,a5,0x7
    8000160c:	97ca                	add	a5,a5,s2
    8000160e:	0b37a623          	sw	s3,172(a5)
}
    80001612:	70a2                	ld	ra,40(sp)
    80001614:	7402                	ld	s0,32(sp)
    80001616:	64e2                	ld	s1,24(sp)
    80001618:	6942                	ld	s2,16(sp)
    8000161a:	69a2                	ld	s3,8(sp)
    8000161c:	6145                	addi	sp,sp,48
    8000161e:	8082                	ret
    panic("sched p->lock");
    80001620:	00007517          	auipc	a0,0x7
    80001624:	ba850513          	addi	a0,a0,-1112 # 800081c8 <etext+0x1c8>
    80001628:	00004097          	auipc	ra,0x4
    8000162c:	790080e7          	jalr	1936(ra) # 80005db8 <panic>
    panic("sched locks");
    80001630:	00007517          	auipc	a0,0x7
    80001634:	ba850513          	addi	a0,a0,-1112 # 800081d8 <etext+0x1d8>
    80001638:	00004097          	auipc	ra,0x4
    8000163c:	780080e7          	jalr	1920(ra) # 80005db8 <panic>
    panic("sched running");
    80001640:	00007517          	auipc	a0,0x7
    80001644:	ba850513          	addi	a0,a0,-1112 # 800081e8 <etext+0x1e8>
    80001648:	00004097          	auipc	ra,0x4
    8000164c:	770080e7          	jalr	1904(ra) # 80005db8 <panic>
    panic("sched interruptible");
    80001650:	00007517          	auipc	a0,0x7
    80001654:	ba850513          	addi	a0,a0,-1112 # 800081f8 <etext+0x1f8>
    80001658:	00004097          	auipc	ra,0x4
    8000165c:	760080e7          	jalr	1888(ra) # 80005db8 <panic>

0000000080001660 <yield>:
{
    80001660:	1101                	addi	sp,sp,-32
    80001662:	ec06                	sd	ra,24(sp)
    80001664:	e822                	sd	s0,16(sp)
    80001666:	e426                	sd	s1,8(sp)
    80001668:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000166a:	00000097          	auipc	ra,0x0
    8000166e:	8c0080e7          	jalr	-1856(ra) # 80000f2a <myproc>
    80001672:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001674:	00005097          	auipc	ra,0x5
    80001678:	c8e080e7          	jalr	-882(ra) # 80006302 <acquire>
  p->state = RUNNABLE;
    8000167c:	478d                	li	a5,3
    8000167e:	cc9c                	sw	a5,24(s1)
  sched();
    80001680:	00000097          	auipc	ra,0x0
    80001684:	f0a080e7          	jalr	-246(ra) # 8000158a <sched>
  release(&p->lock);
    80001688:	8526                	mv	a0,s1
    8000168a:	00005097          	auipc	ra,0x5
    8000168e:	d2c080e7          	jalr	-724(ra) # 800063b6 <release>
}
    80001692:	60e2                	ld	ra,24(sp)
    80001694:	6442                	ld	s0,16(sp)
    80001696:	64a2                	ld	s1,8(sp)
    80001698:	6105                	addi	sp,sp,32
    8000169a:	8082                	ret

000000008000169c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000169c:	7179                	addi	sp,sp,-48
    8000169e:	f406                	sd	ra,40(sp)
    800016a0:	f022                	sd	s0,32(sp)
    800016a2:	ec26                	sd	s1,24(sp)
    800016a4:	e84a                	sd	s2,16(sp)
    800016a6:	e44e                	sd	s3,8(sp)
    800016a8:	1800                	addi	s0,sp,48
    800016aa:	89aa                	mv	s3,a0
    800016ac:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016ae:	00000097          	auipc	ra,0x0
    800016b2:	87c080e7          	jalr	-1924(ra) # 80000f2a <myproc>
    800016b6:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016b8:	00005097          	auipc	ra,0x5
    800016bc:	c4a080e7          	jalr	-950(ra) # 80006302 <acquire>
  release(lk);
    800016c0:	854a                	mv	a0,s2
    800016c2:	00005097          	auipc	ra,0x5
    800016c6:	cf4080e7          	jalr	-780(ra) # 800063b6 <release>

  // Go to sleep.
  p->chan = chan;
    800016ca:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016ce:	4789                	li	a5,2
    800016d0:	cc9c                	sw	a5,24(s1)

  sched();
    800016d2:	00000097          	auipc	ra,0x0
    800016d6:	eb8080e7          	jalr	-328(ra) # 8000158a <sched>

  // Tidy up.
  p->chan = 0;
    800016da:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016de:	8526                	mv	a0,s1
    800016e0:	00005097          	auipc	ra,0x5
    800016e4:	cd6080e7          	jalr	-810(ra) # 800063b6 <release>
  acquire(lk);
    800016e8:	854a                	mv	a0,s2
    800016ea:	00005097          	auipc	ra,0x5
    800016ee:	c18080e7          	jalr	-1000(ra) # 80006302 <acquire>
}
    800016f2:	70a2                	ld	ra,40(sp)
    800016f4:	7402                	ld	s0,32(sp)
    800016f6:	64e2                	ld	s1,24(sp)
    800016f8:	6942                	ld	s2,16(sp)
    800016fa:	69a2                	ld	s3,8(sp)
    800016fc:	6145                	addi	sp,sp,48
    800016fe:	8082                	ret

0000000080001700 <wait>:
{
    80001700:	715d                	addi	sp,sp,-80
    80001702:	e486                	sd	ra,72(sp)
    80001704:	e0a2                	sd	s0,64(sp)
    80001706:	fc26                	sd	s1,56(sp)
    80001708:	f84a                	sd	s2,48(sp)
    8000170a:	f44e                	sd	s3,40(sp)
    8000170c:	f052                	sd	s4,32(sp)
    8000170e:	ec56                	sd	s5,24(sp)
    80001710:	e85a                	sd	s6,16(sp)
    80001712:	e45e                	sd	s7,8(sp)
    80001714:	e062                	sd	s8,0(sp)
    80001716:	0880                	addi	s0,sp,80
    80001718:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000171a:	00000097          	auipc	ra,0x0
    8000171e:	810080e7          	jalr	-2032(ra) # 80000f2a <myproc>
    80001722:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001724:	00008517          	auipc	a0,0x8
    80001728:	94450513          	addi	a0,a0,-1724 # 80009068 <wait_lock>
    8000172c:	00005097          	auipc	ra,0x5
    80001730:	bd6080e7          	jalr	-1066(ra) # 80006302 <acquire>
    havekids = 0;
    80001734:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001736:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    80001738:	0000d997          	auipc	s3,0xd
    8000173c:	74898993          	addi	s3,s3,1864 # 8000ee80 <tickslock>
        havekids = 1;
    80001740:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001742:	00008c17          	auipc	s8,0x8
    80001746:	926c0c13          	addi	s8,s8,-1754 # 80009068 <wait_lock>
    havekids = 0;
    8000174a:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000174c:	00008497          	auipc	s1,0x8
    80001750:	d3448493          	addi	s1,s1,-716 # 80009480 <proc>
    80001754:	a0bd                	j	800017c2 <wait+0xc2>
          pid = np->pid;
    80001756:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000175a:	000b0e63          	beqz	s6,80001776 <wait+0x76>
    8000175e:	4691                	li	a3,4
    80001760:	02c48613          	addi	a2,s1,44
    80001764:	85da                	mv	a1,s6
    80001766:	05093503          	ld	a0,80(s2)
    8000176a:	fffff097          	auipc	ra,0xfffff
    8000176e:	452080e7          	jalr	1106(ra) # 80000bbc <copyout>
    80001772:	02054563          	bltz	a0,8000179c <wait+0x9c>
          freeproc(np);
    80001776:	8526                	mv	a0,s1
    80001778:	00000097          	auipc	ra,0x0
    8000177c:	a1a080e7          	jalr	-1510(ra) # 80001192 <freeproc>
          release(&np->lock);
    80001780:	8526                	mv	a0,s1
    80001782:	00005097          	auipc	ra,0x5
    80001786:	c34080e7          	jalr	-972(ra) # 800063b6 <release>
          release(&wait_lock);
    8000178a:	00008517          	auipc	a0,0x8
    8000178e:	8de50513          	addi	a0,a0,-1826 # 80009068 <wait_lock>
    80001792:	00005097          	auipc	ra,0x5
    80001796:	c24080e7          	jalr	-988(ra) # 800063b6 <release>
          return pid;
    8000179a:	a09d                	j	80001800 <wait+0x100>
            release(&np->lock);
    8000179c:	8526                	mv	a0,s1
    8000179e:	00005097          	auipc	ra,0x5
    800017a2:	c18080e7          	jalr	-1000(ra) # 800063b6 <release>
            release(&wait_lock);
    800017a6:	00008517          	auipc	a0,0x8
    800017aa:	8c250513          	addi	a0,a0,-1854 # 80009068 <wait_lock>
    800017ae:	00005097          	auipc	ra,0x5
    800017b2:	c08080e7          	jalr	-1016(ra) # 800063b6 <release>
            return -1;
    800017b6:	59fd                	li	s3,-1
    800017b8:	a0a1                	j	80001800 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800017ba:	16848493          	addi	s1,s1,360
    800017be:	03348463          	beq	s1,s3,800017e6 <wait+0xe6>
      if(np->parent == p){
    800017c2:	7c9c                	ld	a5,56(s1)
    800017c4:	ff279be3          	bne	a5,s2,800017ba <wait+0xba>
        acquire(&np->lock);
    800017c8:	8526                	mv	a0,s1
    800017ca:	00005097          	auipc	ra,0x5
    800017ce:	b38080e7          	jalr	-1224(ra) # 80006302 <acquire>
        if(np->state == ZOMBIE){
    800017d2:	4c9c                	lw	a5,24(s1)
    800017d4:	f94781e3          	beq	a5,s4,80001756 <wait+0x56>
        release(&np->lock);
    800017d8:	8526                	mv	a0,s1
    800017da:	00005097          	auipc	ra,0x5
    800017de:	bdc080e7          	jalr	-1060(ra) # 800063b6 <release>
        havekids = 1;
    800017e2:	8756                	mv	a4,s5
    800017e4:	bfd9                	j	800017ba <wait+0xba>
    if(!havekids || p->killed){
    800017e6:	c701                	beqz	a4,800017ee <wait+0xee>
    800017e8:	02892783          	lw	a5,40(s2)
    800017ec:	c79d                	beqz	a5,8000181a <wait+0x11a>
      release(&wait_lock);
    800017ee:	00008517          	auipc	a0,0x8
    800017f2:	87a50513          	addi	a0,a0,-1926 # 80009068 <wait_lock>
    800017f6:	00005097          	auipc	ra,0x5
    800017fa:	bc0080e7          	jalr	-1088(ra) # 800063b6 <release>
      return -1;
    800017fe:	59fd                	li	s3,-1
}
    80001800:	854e                	mv	a0,s3
    80001802:	60a6                	ld	ra,72(sp)
    80001804:	6406                	ld	s0,64(sp)
    80001806:	74e2                	ld	s1,56(sp)
    80001808:	7942                	ld	s2,48(sp)
    8000180a:	79a2                	ld	s3,40(sp)
    8000180c:	7a02                	ld	s4,32(sp)
    8000180e:	6ae2                	ld	s5,24(sp)
    80001810:	6b42                	ld	s6,16(sp)
    80001812:	6ba2                	ld	s7,8(sp)
    80001814:	6c02                	ld	s8,0(sp)
    80001816:	6161                	addi	sp,sp,80
    80001818:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000181a:	85e2                	mv	a1,s8
    8000181c:	854a                	mv	a0,s2
    8000181e:	00000097          	auipc	ra,0x0
    80001822:	e7e080e7          	jalr	-386(ra) # 8000169c <sleep>
    havekids = 0;
    80001826:	b715                	j	8000174a <wait+0x4a>

0000000080001828 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001828:	7139                	addi	sp,sp,-64
    8000182a:	fc06                	sd	ra,56(sp)
    8000182c:	f822                	sd	s0,48(sp)
    8000182e:	f426                	sd	s1,40(sp)
    80001830:	f04a                	sd	s2,32(sp)
    80001832:	ec4e                	sd	s3,24(sp)
    80001834:	e852                	sd	s4,16(sp)
    80001836:	e456                	sd	s5,8(sp)
    80001838:	0080                	addi	s0,sp,64
    8000183a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000183c:	00008497          	auipc	s1,0x8
    80001840:	c4448493          	addi	s1,s1,-956 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001844:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001846:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001848:	0000d917          	auipc	s2,0xd
    8000184c:	63890913          	addi	s2,s2,1592 # 8000ee80 <tickslock>
    80001850:	a821                	j	80001868 <wakeup+0x40>
        p->state = RUNNABLE;
    80001852:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001856:	8526                	mv	a0,s1
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	b5e080e7          	jalr	-1186(ra) # 800063b6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001860:	16848493          	addi	s1,s1,360
    80001864:	03248463          	beq	s1,s2,8000188c <wakeup+0x64>
    if(p != myproc()){
    80001868:	fffff097          	auipc	ra,0xfffff
    8000186c:	6c2080e7          	jalr	1730(ra) # 80000f2a <myproc>
    80001870:	fea488e3          	beq	s1,a0,80001860 <wakeup+0x38>
      acquire(&p->lock);
    80001874:	8526                	mv	a0,s1
    80001876:	00005097          	auipc	ra,0x5
    8000187a:	a8c080e7          	jalr	-1396(ra) # 80006302 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000187e:	4c9c                	lw	a5,24(s1)
    80001880:	fd379be3          	bne	a5,s3,80001856 <wakeup+0x2e>
    80001884:	709c                	ld	a5,32(s1)
    80001886:	fd4798e3          	bne	a5,s4,80001856 <wakeup+0x2e>
    8000188a:	b7e1                	j	80001852 <wakeup+0x2a>
    }
  }
}
    8000188c:	70e2                	ld	ra,56(sp)
    8000188e:	7442                	ld	s0,48(sp)
    80001890:	74a2                	ld	s1,40(sp)
    80001892:	7902                	ld	s2,32(sp)
    80001894:	69e2                	ld	s3,24(sp)
    80001896:	6a42                	ld	s4,16(sp)
    80001898:	6aa2                	ld	s5,8(sp)
    8000189a:	6121                	addi	sp,sp,64
    8000189c:	8082                	ret

000000008000189e <reparent>:
{
    8000189e:	7179                	addi	sp,sp,-48
    800018a0:	f406                	sd	ra,40(sp)
    800018a2:	f022                	sd	s0,32(sp)
    800018a4:	ec26                	sd	s1,24(sp)
    800018a6:	e84a                	sd	s2,16(sp)
    800018a8:	e44e                	sd	s3,8(sp)
    800018aa:	e052                	sd	s4,0(sp)
    800018ac:	1800                	addi	s0,sp,48
    800018ae:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018b0:	00008497          	auipc	s1,0x8
    800018b4:	bd048493          	addi	s1,s1,-1072 # 80009480 <proc>
      pp->parent = initproc;
    800018b8:	00007a17          	auipc	s4,0x7
    800018bc:	758a0a13          	addi	s4,s4,1880 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018c0:	0000d997          	auipc	s3,0xd
    800018c4:	5c098993          	addi	s3,s3,1472 # 8000ee80 <tickslock>
    800018c8:	a029                	j	800018d2 <reparent+0x34>
    800018ca:	16848493          	addi	s1,s1,360
    800018ce:	01348d63          	beq	s1,s3,800018e8 <reparent+0x4a>
    if(pp->parent == p){
    800018d2:	7c9c                	ld	a5,56(s1)
    800018d4:	ff279be3          	bne	a5,s2,800018ca <reparent+0x2c>
      pp->parent = initproc;
    800018d8:	000a3503          	ld	a0,0(s4)
    800018dc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800018de:	00000097          	auipc	ra,0x0
    800018e2:	f4a080e7          	jalr	-182(ra) # 80001828 <wakeup>
    800018e6:	b7d5                	j	800018ca <reparent+0x2c>
}
    800018e8:	70a2                	ld	ra,40(sp)
    800018ea:	7402                	ld	s0,32(sp)
    800018ec:	64e2                	ld	s1,24(sp)
    800018ee:	6942                	ld	s2,16(sp)
    800018f0:	69a2                	ld	s3,8(sp)
    800018f2:	6a02                	ld	s4,0(sp)
    800018f4:	6145                	addi	sp,sp,48
    800018f6:	8082                	ret

00000000800018f8 <exit>:
{
    800018f8:	7179                	addi	sp,sp,-48
    800018fa:	f406                	sd	ra,40(sp)
    800018fc:	f022                	sd	s0,32(sp)
    800018fe:	ec26                	sd	s1,24(sp)
    80001900:	e84a                	sd	s2,16(sp)
    80001902:	e44e                	sd	s3,8(sp)
    80001904:	e052                	sd	s4,0(sp)
    80001906:	1800                	addi	s0,sp,48
    80001908:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000190a:	fffff097          	auipc	ra,0xfffff
    8000190e:	620080e7          	jalr	1568(ra) # 80000f2a <myproc>
    80001912:	89aa                	mv	s3,a0
  if(p == initproc)
    80001914:	00007797          	auipc	a5,0x7
    80001918:	6fc7b783          	ld	a5,1788(a5) # 80009010 <initproc>
    8000191c:	0d050493          	addi	s1,a0,208
    80001920:	15050913          	addi	s2,a0,336
    80001924:	02a79363          	bne	a5,a0,8000194a <exit+0x52>
    panic("init exiting");
    80001928:	00007517          	auipc	a0,0x7
    8000192c:	8e850513          	addi	a0,a0,-1816 # 80008210 <etext+0x210>
    80001930:	00004097          	auipc	ra,0x4
    80001934:	488080e7          	jalr	1160(ra) # 80005db8 <panic>
      fileclose(f);
    80001938:	00002097          	auipc	ra,0x2
    8000193c:	254080e7          	jalr	596(ra) # 80003b8c <fileclose>
      p->ofile[fd] = 0;
    80001940:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001944:	04a1                	addi	s1,s1,8
    80001946:	01248563          	beq	s1,s2,80001950 <exit+0x58>
    if(p->ofile[fd]){
    8000194a:	6088                	ld	a0,0(s1)
    8000194c:	f575                	bnez	a0,80001938 <exit+0x40>
    8000194e:	bfdd                	j	80001944 <exit+0x4c>
  begin_op();
    80001950:	00002097          	auipc	ra,0x2
    80001954:	d70080e7          	jalr	-656(ra) # 800036c0 <begin_op>
  iput(p->cwd);
    80001958:	1509b503          	ld	a0,336(s3)
    8000195c:	00001097          	auipc	ra,0x1
    80001960:	54c080e7          	jalr	1356(ra) # 80002ea8 <iput>
  end_op();
    80001964:	00002097          	auipc	ra,0x2
    80001968:	ddc080e7          	jalr	-548(ra) # 80003740 <end_op>
  p->cwd = 0;
    8000196c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001970:	00007497          	auipc	s1,0x7
    80001974:	6f848493          	addi	s1,s1,1784 # 80009068 <wait_lock>
    80001978:	8526                	mv	a0,s1
    8000197a:	00005097          	auipc	ra,0x5
    8000197e:	988080e7          	jalr	-1656(ra) # 80006302 <acquire>
  reparent(p);
    80001982:	854e                	mv	a0,s3
    80001984:	00000097          	auipc	ra,0x0
    80001988:	f1a080e7          	jalr	-230(ra) # 8000189e <reparent>
  wakeup(p->parent);
    8000198c:	0389b503          	ld	a0,56(s3)
    80001990:	00000097          	auipc	ra,0x0
    80001994:	e98080e7          	jalr	-360(ra) # 80001828 <wakeup>
  acquire(&p->lock);
    80001998:	854e                	mv	a0,s3
    8000199a:	00005097          	auipc	ra,0x5
    8000199e:	968080e7          	jalr	-1688(ra) # 80006302 <acquire>
  p->xstate = status;
    800019a2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800019a6:	4795                	li	a5,5
    800019a8:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800019ac:	8526                	mv	a0,s1
    800019ae:	00005097          	auipc	ra,0x5
    800019b2:	a08080e7          	jalr	-1528(ra) # 800063b6 <release>
  sched();
    800019b6:	00000097          	auipc	ra,0x0
    800019ba:	bd4080e7          	jalr	-1068(ra) # 8000158a <sched>
  panic("zombie exit");
    800019be:	00007517          	auipc	a0,0x7
    800019c2:	86250513          	addi	a0,a0,-1950 # 80008220 <etext+0x220>
    800019c6:	00004097          	auipc	ra,0x4
    800019ca:	3f2080e7          	jalr	1010(ra) # 80005db8 <panic>

00000000800019ce <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800019ce:	7179                	addi	sp,sp,-48
    800019d0:	f406                	sd	ra,40(sp)
    800019d2:	f022                	sd	s0,32(sp)
    800019d4:	ec26                	sd	s1,24(sp)
    800019d6:	e84a                	sd	s2,16(sp)
    800019d8:	e44e                	sd	s3,8(sp)
    800019da:	1800                	addi	s0,sp,48
    800019dc:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800019de:	00008497          	auipc	s1,0x8
    800019e2:	aa248493          	addi	s1,s1,-1374 # 80009480 <proc>
    800019e6:	0000d997          	auipc	s3,0xd
    800019ea:	49a98993          	addi	s3,s3,1178 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800019ee:	8526                	mv	a0,s1
    800019f0:	00005097          	auipc	ra,0x5
    800019f4:	912080e7          	jalr	-1774(ra) # 80006302 <acquire>
    if(p->pid == pid){
    800019f8:	589c                	lw	a5,48(s1)
    800019fa:	01278d63          	beq	a5,s2,80001a14 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019fe:	8526                	mv	a0,s1
    80001a00:	00005097          	auipc	ra,0x5
    80001a04:	9b6080e7          	jalr	-1610(ra) # 800063b6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a08:	16848493          	addi	s1,s1,360
    80001a0c:	ff3491e3          	bne	s1,s3,800019ee <kill+0x20>
  }
  return -1;
    80001a10:	557d                	li	a0,-1
    80001a12:	a829                	j	80001a2c <kill+0x5e>
      p->killed = 1;
    80001a14:	4785                	li	a5,1
    80001a16:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a18:	4c98                	lw	a4,24(s1)
    80001a1a:	4789                	li	a5,2
    80001a1c:	00f70f63          	beq	a4,a5,80001a3a <kill+0x6c>
      release(&p->lock);
    80001a20:	8526                	mv	a0,s1
    80001a22:	00005097          	auipc	ra,0x5
    80001a26:	994080e7          	jalr	-1644(ra) # 800063b6 <release>
      return 0;
    80001a2a:	4501                	li	a0,0
}
    80001a2c:	70a2                	ld	ra,40(sp)
    80001a2e:	7402                	ld	s0,32(sp)
    80001a30:	64e2                	ld	s1,24(sp)
    80001a32:	6942                	ld	s2,16(sp)
    80001a34:	69a2                	ld	s3,8(sp)
    80001a36:	6145                	addi	sp,sp,48
    80001a38:	8082                	ret
        p->state = RUNNABLE;
    80001a3a:	478d                	li	a5,3
    80001a3c:	cc9c                	sw	a5,24(s1)
    80001a3e:	b7cd                	j	80001a20 <kill+0x52>

0000000080001a40 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a40:	7179                	addi	sp,sp,-48
    80001a42:	f406                	sd	ra,40(sp)
    80001a44:	f022                	sd	s0,32(sp)
    80001a46:	ec26                	sd	s1,24(sp)
    80001a48:	e84a                	sd	s2,16(sp)
    80001a4a:	e44e                	sd	s3,8(sp)
    80001a4c:	e052                	sd	s4,0(sp)
    80001a4e:	1800                	addi	s0,sp,48
    80001a50:	84aa                	mv	s1,a0
    80001a52:	892e                	mv	s2,a1
    80001a54:	89b2                	mv	s3,a2
    80001a56:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a58:	fffff097          	auipc	ra,0xfffff
    80001a5c:	4d2080e7          	jalr	1234(ra) # 80000f2a <myproc>
  if(user_dst){
    80001a60:	c08d                	beqz	s1,80001a82 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a62:	86d2                	mv	a3,s4
    80001a64:	864e                	mv	a2,s3
    80001a66:	85ca                	mv	a1,s2
    80001a68:	6928                	ld	a0,80(a0)
    80001a6a:	fffff097          	auipc	ra,0xfffff
    80001a6e:	152080e7          	jalr	338(ra) # 80000bbc <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a72:	70a2                	ld	ra,40(sp)
    80001a74:	7402                	ld	s0,32(sp)
    80001a76:	64e2                	ld	s1,24(sp)
    80001a78:	6942                	ld	s2,16(sp)
    80001a7a:	69a2                	ld	s3,8(sp)
    80001a7c:	6a02                	ld	s4,0(sp)
    80001a7e:	6145                	addi	sp,sp,48
    80001a80:	8082                	ret
    memmove((char *)dst, src, len);
    80001a82:	000a061b          	sext.w	a2,s4
    80001a86:	85ce                	mv	a1,s3
    80001a88:	854a                	mv	a0,s2
    80001a8a:	ffffe097          	auipc	ra,0xffffe
    80001a8e:	74e080e7          	jalr	1870(ra) # 800001d8 <memmove>
    return 0;
    80001a92:	8526                	mv	a0,s1
    80001a94:	bff9                	j	80001a72 <either_copyout+0x32>

0000000080001a96 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a96:	7179                	addi	sp,sp,-48
    80001a98:	f406                	sd	ra,40(sp)
    80001a9a:	f022                	sd	s0,32(sp)
    80001a9c:	ec26                	sd	s1,24(sp)
    80001a9e:	e84a                	sd	s2,16(sp)
    80001aa0:	e44e                	sd	s3,8(sp)
    80001aa2:	e052                	sd	s4,0(sp)
    80001aa4:	1800                	addi	s0,sp,48
    80001aa6:	892a                	mv	s2,a0
    80001aa8:	84ae                	mv	s1,a1
    80001aaa:	89b2                	mv	s3,a2
    80001aac:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001aae:	fffff097          	auipc	ra,0xfffff
    80001ab2:	47c080e7          	jalr	1148(ra) # 80000f2a <myproc>
  if(user_src){
    80001ab6:	c08d                	beqz	s1,80001ad8 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001ab8:	86d2                	mv	a3,s4
    80001aba:	864e                	mv	a2,s3
    80001abc:	85ca                	mv	a1,s2
    80001abe:	6928                	ld	a0,80(a0)
    80001ac0:	fffff097          	auipc	ra,0xfffff
    80001ac4:	188080e7          	jalr	392(ra) # 80000c48 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001ac8:	70a2                	ld	ra,40(sp)
    80001aca:	7402                	ld	s0,32(sp)
    80001acc:	64e2                	ld	s1,24(sp)
    80001ace:	6942                	ld	s2,16(sp)
    80001ad0:	69a2                	ld	s3,8(sp)
    80001ad2:	6a02                	ld	s4,0(sp)
    80001ad4:	6145                	addi	sp,sp,48
    80001ad6:	8082                	ret
    memmove(dst, (char*)src, len);
    80001ad8:	000a061b          	sext.w	a2,s4
    80001adc:	85ce                	mv	a1,s3
    80001ade:	854a                	mv	a0,s2
    80001ae0:	ffffe097          	auipc	ra,0xffffe
    80001ae4:	6f8080e7          	jalr	1784(ra) # 800001d8 <memmove>
    return 0;
    80001ae8:	8526                	mv	a0,s1
    80001aea:	bff9                	j	80001ac8 <either_copyin+0x32>

0000000080001aec <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001aec:	715d                	addi	sp,sp,-80
    80001aee:	e486                	sd	ra,72(sp)
    80001af0:	e0a2                	sd	s0,64(sp)
    80001af2:	fc26                	sd	s1,56(sp)
    80001af4:	f84a                	sd	s2,48(sp)
    80001af6:	f44e                	sd	s3,40(sp)
    80001af8:	f052                	sd	s4,32(sp)
    80001afa:	ec56                	sd	s5,24(sp)
    80001afc:	e85a                	sd	s6,16(sp)
    80001afe:	e45e                	sd	s7,8(sp)
    80001b00:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b02:	00006517          	auipc	a0,0x6
    80001b06:	54650513          	addi	a0,a0,1350 # 80008048 <etext+0x48>
    80001b0a:	00004097          	auipc	ra,0x4
    80001b0e:	2f8080e7          	jalr	760(ra) # 80005e02 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b12:	00008497          	auipc	s1,0x8
    80001b16:	ac648493          	addi	s1,s1,-1338 # 800095d8 <proc+0x158>
    80001b1a:	0000d917          	auipc	s2,0xd
    80001b1e:	4be90913          	addi	s2,s2,1214 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b22:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b24:	00006997          	auipc	s3,0x6
    80001b28:	70c98993          	addi	s3,s3,1804 # 80008230 <etext+0x230>
    printf("%d %s %s", p->pid, state, p->name);
    80001b2c:	00006a97          	auipc	s5,0x6
    80001b30:	70ca8a93          	addi	s5,s5,1804 # 80008238 <etext+0x238>
    printf("\n");
    80001b34:	00006a17          	auipc	s4,0x6
    80001b38:	514a0a13          	addi	s4,s4,1300 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b3c:	00006b97          	auipc	s7,0x6
    80001b40:	734b8b93          	addi	s7,s7,1844 # 80008270 <states.1718>
    80001b44:	a00d                	j	80001b66 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b46:	ed86a583          	lw	a1,-296(a3)
    80001b4a:	8556                	mv	a0,s5
    80001b4c:	00004097          	auipc	ra,0x4
    80001b50:	2b6080e7          	jalr	694(ra) # 80005e02 <printf>
    printf("\n");
    80001b54:	8552                	mv	a0,s4
    80001b56:	00004097          	auipc	ra,0x4
    80001b5a:	2ac080e7          	jalr	684(ra) # 80005e02 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b5e:	16848493          	addi	s1,s1,360
    80001b62:	03248163          	beq	s1,s2,80001b84 <procdump+0x98>
    if(p->state == UNUSED)
    80001b66:	86a6                	mv	a3,s1
    80001b68:	ec04a783          	lw	a5,-320(s1)
    80001b6c:	dbed                	beqz	a5,80001b5e <procdump+0x72>
      state = "???";
    80001b6e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b70:	fcfb6be3          	bltu	s6,a5,80001b46 <procdump+0x5a>
    80001b74:	1782                	slli	a5,a5,0x20
    80001b76:	9381                	srli	a5,a5,0x20
    80001b78:	078e                	slli	a5,a5,0x3
    80001b7a:	97de                	add	a5,a5,s7
    80001b7c:	6390                	ld	a2,0(a5)
    80001b7e:	f661                	bnez	a2,80001b46 <procdump+0x5a>
      state = "???";
    80001b80:	864e                	mv	a2,s3
    80001b82:	b7d1                	j	80001b46 <procdump+0x5a>
  }
}
    80001b84:	60a6                	ld	ra,72(sp)
    80001b86:	6406                	ld	s0,64(sp)
    80001b88:	74e2                	ld	s1,56(sp)
    80001b8a:	7942                	ld	s2,48(sp)
    80001b8c:	79a2                	ld	s3,40(sp)
    80001b8e:	7a02                	ld	s4,32(sp)
    80001b90:	6ae2                	ld	s5,24(sp)
    80001b92:	6b42                	ld	s6,16(sp)
    80001b94:	6ba2                	ld	s7,8(sp)
    80001b96:	6161                	addi	sp,sp,80
    80001b98:	8082                	ret

0000000080001b9a <swtch>:
    80001b9a:	00153023          	sd	ra,0(a0)
    80001b9e:	00253423          	sd	sp,8(a0)
    80001ba2:	e900                	sd	s0,16(a0)
    80001ba4:	ed04                	sd	s1,24(a0)
    80001ba6:	03253023          	sd	s2,32(a0)
    80001baa:	03353423          	sd	s3,40(a0)
    80001bae:	03453823          	sd	s4,48(a0)
    80001bb2:	03553c23          	sd	s5,56(a0)
    80001bb6:	05653023          	sd	s6,64(a0)
    80001bba:	05753423          	sd	s7,72(a0)
    80001bbe:	05853823          	sd	s8,80(a0)
    80001bc2:	05953c23          	sd	s9,88(a0)
    80001bc6:	07a53023          	sd	s10,96(a0)
    80001bca:	07b53423          	sd	s11,104(a0)
    80001bce:	0005b083          	ld	ra,0(a1)
    80001bd2:	0085b103          	ld	sp,8(a1)
    80001bd6:	6980                	ld	s0,16(a1)
    80001bd8:	6d84                	ld	s1,24(a1)
    80001bda:	0205b903          	ld	s2,32(a1)
    80001bde:	0285b983          	ld	s3,40(a1)
    80001be2:	0305ba03          	ld	s4,48(a1)
    80001be6:	0385ba83          	ld	s5,56(a1)
    80001bea:	0405bb03          	ld	s6,64(a1)
    80001bee:	0485bb83          	ld	s7,72(a1)
    80001bf2:	0505bc03          	ld	s8,80(a1)
    80001bf6:	0585bc83          	ld	s9,88(a1)
    80001bfa:	0605bd03          	ld	s10,96(a1)
    80001bfe:	0685bd83          	ld	s11,104(a1)
    80001c02:	8082                	ret

0000000080001c04 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c04:	1141                	addi	sp,sp,-16
    80001c06:	e406                	sd	ra,8(sp)
    80001c08:	e022                	sd	s0,0(sp)
    80001c0a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c0c:	00006597          	auipc	a1,0x6
    80001c10:	69458593          	addi	a1,a1,1684 # 800082a0 <states.1718+0x30>
    80001c14:	0000d517          	auipc	a0,0xd
    80001c18:	26c50513          	addi	a0,a0,620 # 8000ee80 <tickslock>
    80001c1c:	00004097          	auipc	ra,0x4
    80001c20:	656080e7          	jalr	1622(ra) # 80006272 <initlock>
}
    80001c24:	60a2                	ld	ra,8(sp)
    80001c26:	6402                	ld	s0,0(sp)
    80001c28:	0141                	addi	sp,sp,16
    80001c2a:	8082                	ret

0000000080001c2c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c2c:	1141                	addi	sp,sp,-16
    80001c2e:	e422                	sd	s0,8(sp)
    80001c30:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c32:	00003797          	auipc	a5,0x3
    80001c36:	58e78793          	addi	a5,a5,1422 # 800051c0 <kernelvec>
    80001c3a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c3e:	6422                	ld	s0,8(sp)
    80001c40:	0141                	addi	sp,sp,16
    80001c42:	8082                	ret

0000000080001c44 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c44:	1141                	addi	sp,sp,-16
    80001c46:	e406                	sd	ra,8(sp)
    80001c48:	e022                	sd	s0,0(sp)
    80001c4a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c4c:	fffff097          	auipc	ra,0xfffff
    80001c50:	2de080e7          	jalr	734(ra) # 80000f2a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c54:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c58:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c5a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c5e:	00005617          	auipc	a2,0x5
    80001c62:	3a260613          	addi	a2,a2,930 # 80007000 <_trampoline>
    80001c66:	00005697          	auipc	a3,0x5
    80001c6a:	39a68693          	addi	a3,a3,922 # 80007000 <_trampoline>
    80001c6e:	8e91                	sub	a3,a3,a2
    80001c70:	040007b7          	lui	a5,0x4000
    80001c74:	17fd                	addi	a5,a5,-1
    80001c76:	07b2                	slli	a5,a5,0xc
    80001c78:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c7a:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c7e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c80:	180026f3          	csrr	a3,satp
    80001c84:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c86:	6d38                	ld	a4,88(a0)
    80001c88:	6134                	ld	a3,64(a0)
    80001c8a:	6585                	lui	a1,0x1
    80001c8c:	96ae                	add	a3,a3,a1
    80001c8e:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c90:	6d38                	ld	a4,88(a0)
    80001c92:	00000697          	auipc	a3,0x0
    80001c96:	13868693          	addi	a3,a3,312 # 80001dca <usertrap>
    80001c9a:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c9c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c9e:	8692                	mv	a3,tp
    80001ca0:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ca2:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001ca6:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001caa:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cae:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cb2:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cb4:	6f18                	ld	a4,24(a4)
    80001cb6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cba:	692c                	ld	a1,80(a0)
    80001cbc:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001cbe:	00005717          	auipc	a4,0x5
    80001cc2:	3d270713          	addi	a4,a4,978 # 80007090 <userret>
    80001cc6:	8f11                	sub	a4,a4,a2
    80001cc8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001cca:	577d                	li	a4,-1
    80001ccc:	177e                	slli	a4,a4,0x3f
    80001cce:	8dd9                	or	a1,a1,a4
    80001cd0:	02000537          	lui	a0,0x2000
    80001cd4:	157d                	addi	a0,a0,-1
    80001cd6:	0536                	slli	a0,a0,0xd
    80001cd8:	9782                	jalr	a5
}
    80001cda:	60a2                	ld	ra,8(sp)
    80001cdc:	6402                	ld	s0,0(sp)
    80001cde:	0141                	addi	sp,sp,16
    80001ce0:	8082                	ret

0000000080001ce2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001ce2:	1101                	addi	sp,sp,-32
    80001ce4:	ec06                	sd	ra,24(sp)
    80001ce6:	e822                	sd	s0,16(sp)
    80001ce8:	e426                	sd	s1,8(sp)
    80001cea:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001cec:	0000d497          	auipc	s1,0xd
    80001cf0:	19448493          	addi	s1,s1,404 # 8000ee80 <tickslock>
    80001cf4:	8526                	mv	a0,s1
    80001cf6:	00004097          	auipc	ra,0x4
    80001cfa:	60c080e7          	jalr	1548(ra) # 80006302 <acquire>
  ticks++;
    80001cfe:	00007517          	auipc	a0,0x7
    80001d02:	31a50513          	addi	a0,a0,794 # 80009018 <ticks>
    80001d06:	411c                	lw	a5,0(a0)
    80001d08:	2785                	addiw	a5,a5,1
    80001d0a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d0c:	00000097          	auipc	ra,0x0
    80001d10:	b1c080e7          	jalr	-1252(ra) # 80001828 <wakeup>
  release(&tickslock);
    80001d14:	8526                	mv	a0,s1
    80001d16:	00004097          	auipc	ra,0x4
    80001d1a:	6a0080e7          	jalr	1696(ra) # 800063b6 <release>
}
    80001d1e:	60e2                	ld	ra,24(sp)
    80001d20:	6442                	ld	s0,16(sp)
    80001d22:	64a2                	ld	s1,8(sp)
    80001d24:	6105                	addi	sp,sp,32
    80001d26:	8082                	ret

0000000080001d28 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d28:	1101                	addi	sp,sp,-32
    80001d2a:	ec06                	sd	ra,24(sp)
    80001d2c:	e822                	sd	s0,16(sp)
    80001d2e:	e426                	sd	s1,8(sp)
    80001d30:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d32:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d36:	00074d63          	bltz	a4,80001d50 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d3a:	57fd                	li	a5,-1
    80001d3c:	17fe                	slli	a5,a5,0x3f
    80001d3e:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d40:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d42:	06f70363          	beq	a4,a5,80001da8 <devintr+0x80>
  }
}
    80001d46:	60e2                	ld	ra,24(sp)
    80001d48:	6442                	ld	s0,16(sp)
    80001d4a:	64a2                	ld	s1,8(sp)
    80001d4c:	6105                	addi	sp,sp,32
    80001d4e:	8082                	ret
     (scause & 0xff) == 9){
    80001d50:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001d54:	46a5                	li	a3,9
    80001d56:	fed792e3          	bne	a5,a3,80001d3a <devintr+0x12>
    int irq = plic_claim();
    80001d5a:	00003097          	auipc	ra,0x3
    80001d5e:	56e080e7          	jalr	1390(ra) # 800052c8 <plic_claim>
    80001d62:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d64:	47a9                	li	a5,10
    80001d66:	02f50763          	beq	a0,a5,80001d94 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d6a:	4785                	li	a5,1
    80001d6c:	02f50963          	beq	a0,a5,80001d9e <devintr+0x76>
    return 1;
    80001d70:	4505                	li	a0,1
    } else if(irq){
    80001d72:	d8f1                	beqz	s1,80001d46 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d74:	85a6                	mv	a1,s1
    80001d76:	00006517          	auipc	a0,0x6
    80001d7a:	53250513          	addi	a0,a0,1330 # 800082a8 <states.1718+0x38>
    80001d7e:	00004097          	auipc	ra,0x4
    80001d82:	084080e7          	jalr	132(ra) # 80005e02 <printf>
      plic_complete(irq);
    80001d86:	8526                	mv	a0,s1
    80001d88:	00003097          	auipc	ra,0x3
    80001d8c:	564080e7          	jalr	1380(ra) # 800052ec <plic_complete>
    return 1;
    80001d90:	4505                	li	a0,1
    80001d92:	bf55                	j	80001d46 <devintr+0x1e>
      uartintr();
    80001d94:	00004097          	auipc	ra,0x4
    80001d98:	48e080e7          	jalr	1166(ra) # 80006222 <uartintr>
    80001d9c:	b7ed                	j	80001d86 <devintr+0x5e>
      virtio_disk_intr();
    80001d9e:	00004097          	auipc	ra,0x4
    80001da2:	a2e080e7          	jalr	-1490(ra) # 800057cc <virtio_disk_intr>
    80001da6:	b7c5                	j	80001d86 <devintr+0x5e>
    if(cpuid() == 0){
    80001da8:	fffff097          	auipc	ra,0xfffff
    80001dac:	156080e7          	jalr	342(ra) # 80000efe <cpuid>
    80001db0:	c901                	beqz	a0,80001dc0 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001db2:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001db6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001db8:	14479073          	csrw	sip,a5
    return 2;
    80001dbc:	4509                	li	a0,2
    80001dbe:	b761                	j	80001d46 <devintr+0x1e>
      clockintr();
    80001dc0:	00000097          	auipc	ra,0x0
    80001dc4:	f22080e7          	jalr	-222(ra) # 80001ce2 <clockintr>
    80001dc8:	b7ed                	j	80001db2 <devintr+0x8a>

0000000080001dca <usertrap>:
{
    80001dca:	1101                	addi	sp,sp,-32
    80001dcc:	ec06                	sd	ra,24(sp)
    80001dce:	e822                	sd	s0,16(sp)
    80001dd0:	e426                	sd	s1,8(sp)
    80001dd2:	e04a                	sd	s2,0(sp)
    80001dd4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dd6:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001dda:	1007f793          	andi	a5,a5,256
    80001dde:	e3ad                	bnez	a5,80001e40 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001de0:	00003797          	auipc	a5,0x3
    80001de4:	3e078793          	addi	a5,a5,992 # 800051c0 <kernelvec>
    80001de8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001dec:	fffff097          	auipc	ra,0xfffff
    80001df0:	13e080e7          	jalr	318(ra) # 80000f2a <myproc>
    80001df4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001df6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001df8:	14102773          	csrr	a4,sepc
    80001dfc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dfe:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e02:	47a1                	li	a5,8
    80001e04:	04f71c63          	bne	a4,a5,80001e5c <usertrap+0x92>
    if(p->killed)
    80001e08:	551c                	lw	a5,40(a0)
    80001e0a:	e3b9                	bnez	a5,80001e50 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e0c:	6cb8                	ld	a4,88(s1)
    80001e0e:	6f1c                	ld	a5,24(a4)
    80001e10:	0791                	addi	a5,a5,4
    80001e12:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e14:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e18:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e1c:	10079073          	csrw	sstatus,a5
    syscall();
    80001e20:	00000097          	auipc	ra,0x0
    80001e24:	2e0080e7          	jalr	736(ra) # 80002100 <syscall>
  if(p->killed)
    80001e28:	549c                	lw	a5,40(s1)
    80001e2a:	ebc1                	bnez	a5,80001eba <usertrap+0xf0>
  usertrapret();
    80001e2c:	00000097          	auipc	ra,0x0
    80001e30:	e18080e7          	jalr	-488(ra) # 80001c44 <usertrapret>
}
    80001e34:	60e2                	ld	ra,24(sp)
    80001e36:	6442                	ld	s0,16(sp)
    80001e38:	64a2                	ld	s1,8(sp)
    80001e3a:	6902                	ld	s2,0(sp)
    80001e3c:	6105                	addi	sp,sp,32
    80001e3e:	8082                	ret
    panic("usertrap: not from user mode");
    80001e40:	00006517          	auipc	a0,0x6
    80001e44:	48850513          	addi	a0,a0,1160 # 800082c8 <states.1718+0x58>
    80001e48:	00004097          	auipc	ra,0x4
    80001e4c:	f70080e7          	jalr	-144(ra) # 80005db8 <panic>
      exit(-1);
    80001e50:	557d                	li	a0,-1
    80001e52:	00000097          	auipc	ra,0x0
    80001e56:	aa6080e7          	jalr	-1370(ra) # 800018f8 <exit>
    80001e5a:	bf4d                	j	80001e0c <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e5c:	00000097          	auipc	ra,0x0
    80001e60:	ecc080e7          	jalr	-308(ra) # 80001d28 <devintr>
    80001e64:	892a                	mv	s2,a0
    80001e66:	c501                	beqz	a0,80001e6e <usertrap+0xa4>
  if(p->killed)
    80001e68:	549c                	lw	a5,40(s1)
    80001e6a:	c3a1                	beqz	a5,80001eaa <usertrap+0xe0>
    80001e6c:	a815                	j	80001ea0 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e6e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e72:	5890                	lw	a2,48(s1)
    80001e74:	00006517          	auipc	a0,0x6
    80001e78:	47450513          	addi	a0,a0,1140 # 800082e8 <states.1718+0x78>
    80001e7c:	00004097          	auipc	ra,0x4
    80001e80:	f86080e7          	jalr	-122(ra) # 80005e02 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e84:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e88:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e8c:	00006517          	auipc	a0,0x6
    80001e90:	48c50513          	addi	a0,a0,1164 # 80008318 <states.1718+0xa8>
    80001e94:	00004097          	auipc	ra,0x4
    80001e98:	f6e080e7          	jalr	-146(ra) # 80005e02 <printf>
    p->killed = 1;
    80001e9c:	4785                	li	a5,1
    80001e9e:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001ea0:	557d                	li	a0,-1
    80001ea2:	00000097          	auipc	ra,0x0
    80001ea6:	a56080e7          	jalr	-1450(ra) # 800018f8 <exit>
  if(which_dev == 2)
    80001eaa:	4789                	li	a5,2
    80001eac:	f8f910e3          	bne	s2,a5,80001e2c <usertrap+0x62>
    yield();
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	7b0080e7          	jalr	1968(ra) # 80001660 <yield>
    80001eb8:	bf95                	j	80001e2c <usertrap+0x62>
  int which_dev = 0;
    80001eba:	4901                	li	s2,0
    80001ebc:	b7d5                	j	80001ea0 <usertrap+0xd6>

0000000080001ebe <kerneltrap>:
{
    80001ebe:	7179                	addi	sp,sp,-48
    80001ec0:	f406                	sd	ra,40(sp)
    80001ec2:	f022                	sd	s0,32(sp)
    80001ec4:	ec26                	sd	s1,24(sp)
    80001ec6:	e84a                	sd	s2,16(sp)
    80001ec8:	e44e                	sd	s3,8(sp)
    80001eca:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ecc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ed0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ed4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001ed8:	1004f793          	andi	a5,s1,256
    80001edc:	cb85                	beqz	a5,80001f0c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ede:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ee2:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ee4:	ef85                	bnez	a5,80001f1c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001ee6:	00000097          	auipc	ra,0x0
    80001eea:	e42080e7          	jalr	-446(ra) # 80001d28 <devintr>
    80001eee:	cd1d                	beqz	a0,80001f2c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ef0:	4789                	li	a5,2
    80001ef2:	06f50a63          	beq	a0,a5,80001f66 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ef6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001efa:	10049073          	csrw	sstatus,s1
}
    80001efe:	70a2                	ld	ra,40(sp)
    80001f00:	7402                	ld	s0,32(sp)
    80001f02:	64e2                	ld	s1,24(sp)
    80001f04:	6942                	ld	s2,16(sp)
    80001f06:	69a2                	ld	s3,8(sp)
    80001f08:	6145                	addi	sp,sp,48
    80001f0a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f0c:	00006517          	auipc	a0,0x6
    80001f10:	42c50513          	addi	a0,a0,1068 # 80008338 <states.1718+0xc8>
    80001f14:	00004097          	auipc	ra,0x4
    80001f18:	ea4080e7          	jalr	-348(ra) # 80005db8 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f1c:	00006517          	auipc	a0,0x6
    80001f20:	44450513          	addi	a0,a0,1092 # 80008360 <states.1718+0xf0>
    80001f24:	00004097          	auipc	ra,0x4
    80001f28:	e94080e7          	jalr	-364(ra) # 80005db8 <panic>
    printf("scause %p\n", scause);
    80001f2c:	85ce                	mv	a1,s3
    80001f2e:	00006517          	auipc	a0,0x6
    80001f32:	45250513          	addi	a0,a0,1106 # 80008380 <states.1718+0x110>
    80001f36:	00004097          	auipc	ra,0x4
    80001f3a:	ecc080e7          	jalr	-308(ra) # 80005e02 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f3e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f42:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f46:	00006517          	auipc	a0,0x6
    80001f4a:	44a50513          	addi	a0,a0,1098 # 80008390 <states.1718+0x120>
    80001f4e:	00004097          	auipc	ra,0x4
    80001f52:	eb4080e7          	jalr	-332(ra) # 80005e02 <printf>
    panic("kerneltrap");
    80001f56:	00006517          	auipc	a0,0x6
    80001f5a:	45250513          	addi	a0,a0,1106 # 800083a8 <states.1718+0x138>
    80001f5e:	00004097          	auipc	ra,0x4
    80001f62:	e5a080e7          	jalr	-422(ra) # 80005db8 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f66:	fffff097          	auipc	ra,0xfffff
    80001f6a:	fc4080e7          	jalr	-60(ra) # 80000f2a <myproc>
    80001f6e:	d541                	beqz	a0,80001ef6 <kerneltrap+0x38>
    80001f70:	fffff097          	auipc	ra,0xfffff
    80001f74:	fba080e7          	jalr	-70(ra) # 80000f2a <myproc>
    80001f78:	4d18                	lw	a4,24(a0)
    80001f7a:	4791                	li	a5,4
    80001f7c:	f6f71de3          	bne	a4,a5,80001ef6 <kerneltrap+0x38>
    yield();
    80001f80:	fffff097          	auipc	ra,0xfffff
    80001f84:	6e0080e7          	jalr	1760(ra) # 80001660 <yield>
    80001f88:	b7bd                	j	80001ef6 <kerneltrap+0x38>

0000000080001f8a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f8a:	1101                	addi	sp,sp,-32
    80001f8c:	ec06                	sd	ra,24(sp)
    80001f8e:	e822                	sd	s0,16(sp)
    80001f90:	e426                	sd	s1,8(sp)
    80001f92:	1000                	addi	s0,sp,32
    80001f94:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f96:	fffff097          	auipc	ra,0xfffff
    80001f9a:	f94080e7          	jalr	-108(ra) # 80000f2a <myproc>
  switch (n) {
    80001f9e:	4795                	li	a5,5
    80001fa0:	0497e163          	bltu	a5,s1,80001fe2 <argraw+0x58>
    80001fa4:	048a                	slli	s1,s1,0x2
    80001fa6:	00006717          	auipc	a4,0x6
    80001faa:	43a70713          	addi	a4,a4,1082 # 800083e0 <states.1718+0x170>
    80001fae:	94ba                	add	s1,s1,a4
    80001fb0:	409c                	lw	a5,0(s1)
    80001fb2:	97ba                	add	a5,a5,a4
    80001fb4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fb6:	6d3c                	ld	a5,88(a0)
    80001fb8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fba:	60e2                	ld	ra,24(sp)
    80001fbc:	6442                	ld	s0,16(sp)
    80001fbe:	64a2                	ld	s1,8(sp)
    80001fc0:	6105                	addi	sp,sp,32
    80001fc2:	8082                	ret
    return p->trapframe->a1;
    80001fc4:	6d3c                	ld	a5,88(a0)
    80001fc6:	7fa8                	ld	a0,120(a5)
    80001fc8:	bfcd                	j	80001fba <argraw+0x30>
    return p->trapframe->a2;
    80001fca:	6d3c                	ld	a5,88(a0)
    80001fcc:	63c8                	ld	a0,128(a5)
    80001fce:	b7f5                	j	80001fba <argraw+0x30>
    return p->trapframe->a3;
    80001fd0:	6d3c                	ld	a5,88(a0)
    80001fd2:	67c8                	ld	a0,136(a5)
    80001fd4:	b7dd                	j	80001fba <argraw+0x30>
    return p->trapframe->a4;
    80001fd6:	6d3c                	ld	a5,88(a0)
    80001fd8:	6bc8                	ld	a0,144(a5)
    80001fda:	b7c5                	j	80001fba <argraw+0x30>
    return p->trapframe->a5;
    80001fdc:	6d3c                	ld	a5,88(a0)
    80001fde:	6fc8                	ld	a0,152(a5)
    80001fe0:	bfe9                	j	80001fba <argraw+0x30>
  panic("argraw");
    80001fe2:	00006517          	auipc	a0,0x6
    80001fe6:	3d650513          	addi	a0,a0,982 # 800083b8 <states.1718+0x148>
    80001fea:	00004097          	auipc	ra,0x4
    80001fee:	dce080e7          	jalr	-562(ra) # 80005db8 <panic>

0000000080001ff2 <fetchaddr>:
{
    80001ff2:	1101                	addi	sp,sp,-32
    80001ff4:	ec06                	sd	ra,24(sp)
    80001ff6:	e822                	sd	s0,16(sp)
    80001ff8:	e426                	sd	s1,8(sp)
    80001ffa:	e04a                	sd	s2,0(sp)
    80001ffc:	1000                	addi	s0,sp,32
    80001ffe:	84aa                	mv	s1,a0
    80002000:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002002:	fffff097          	auipc	ra,0xfffff
    80002006:	f28080e7          	jalr	-216(ra) # 80000f2a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    8000200a:	653c                	ld	a5,72(a0)
    8000200c:	02f4f863          	bgeu	s1,a5,8000203c <fetchaddr+0x4a>
    80002010:	00848713          	addi	a4,s1,8
    80002014:	02e7e663          	bltu	a5,a4,80002040 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002018:	46a1                	li	a3,8
    8000201a:	8626                	mv	a2,s1
    8000201c:	85ca                	mv	a1,s2
    8000201e:	6928                	ld	a0,80(a0)
    80002020:	fffff097          	auipc	ra,0xfffff
    80002024:	c28080e7          	jalr	-984(ra) # 80000c48 <copyin>
    80002028:	00a03533          	snez	a0,a0
    8000202c:	40a00533          	neg	a0,a0
}
    80002030:	60e2                	ld	ra,24(sp)
    80002032:	6442                	ld	s0,16(sp)
    80002034:	64a2                	ld	s1,8(sp)
    80002036:	6902                	ld	s2,0(sp)
    80002038:	6105                	addi	sp,sp,32
    8000203a:	8082                	ret
    return -1;
    8000203c:	557d                	li	a0,-1
    8000203e:	bfcd                	j	80002030 <fetchaddr+0x3e>
    80002040:	557d                	li	a0,-1
    80002042:	b7fd                	j	80002030 <fetchaddr+0x3e>

0000000080002044 <fetchstr>:
{
    80002044:	7179                	addi	sp,sp,-48
    80002046:	f406                	sd	ra,40(sp)
    80002048:	f022                	sd	s0,32(sp)
    8000204a:	ec26                	sd	s1,24(sp)
    8000204c:	e84a                	sd	s2,16(sp)
    8000204e:	e44e                	sd	s3,8(sp)
    80002050:	1800                	addi	s0,sp,48
    80002052:	892a                	mv	s2,a0
    80002054:	84ae                	mv	s1,a1
    80002056:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002058:	fffff097          	auipc	ra,0xfffff
    8000205c:	ed2080e7          	jalr	-302(ra) # 80000f2a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002060:	86ce                	mv	a3,s3
    80002062:	864a                	mv	a2,s2
    80002064:	85a6                	mv	a1,s1
    80002066:	6928                	ld	a0,80(a0)
    80002068:	fffff097          	auipc	ra,0xfffff
    8000206c:	c6c080e7          	jalr	-916(ra) # 80000cd4 <copyinstr>
  if(err < 0)
    80002070:	00054763          	bltz	a0,8000207e <fetchstr+0x3a>
  return strlen(buf);
    80002074:	8526                	mv	a0,s1
    80002076:	ffffe097          	auipc	ra,0xffffe
    8000207a:	286080e7          	jalr	646(ra) # 800002fc <strlen>
}
    8000207e:	70a2                	ld	ra,40(sp)
    80002080:	7402                	ld	s0,32(sp)
    80002082:	64e2                	ld	s1,24(sp)
    80002084:	6942                	ld	s2,16(sp)
    80002086:	69a2                	ld	s3,8(sp)
    80002088:	6145                	addi	sp,sp,48
    8000208a:	8082                	ret

000000008000208c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000208c:	1101                	addi	sp,sp,-32
    8000208e:	ec06                	sd	ra,24(sp)
    80002090:	e822                	sd	s0,16(sp)
    80002092:	e426                	sd	s1,8(sp)
    80002094:	1000                	addi	s0,sp,32
    80002096:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002098:	00000097          	auipc	ra,0x0
    8000209c:	ef2080e7          	jalr	-270(ra) # 80001f8a <argraw>
    800020a0:	c088                	sw	a0,0(s1)
  return 0;
}
    800020a2:	4501                	li	a0,0
    800020a4:	60e2                	ld	ra,24(sp)
    800020a6:	6442                	ld	s0,16(sp)
    800020a8:	64a2                	ld	s1,8(sp)
    800020aa:	6105                	addi	sp,sp,32
    800020ac:	8082                	ret

00000000800020ae <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020ae:	1101                	addi	sp,sp,-32
    800020b0:	ec06                	sd	ra,24(sp)
    800020b2:	e822                	sd	s0,16(sp)
    800020b4:	e426                	sd	s1,8(sp)
    800020b6:	1000                	addi	s0,sp,32
    800020b8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020ba:	00000097          	auipc	ra,0x0
    800020be:	ed0080e7          	jalr	-304(ra) # 80001f8a <argraw>
    800020c2:	e088                	sd	a0,0(s1)
  return 0;
}
    800020c4:	4501                	li	a0,0
    800020c6:	60e2                	ld	ra,24(sp)
    800020c8:	6442                	ld	s0,16(sp)
    800020ca:	64a2                	ld	s1,8(sp)
    800020cc:	6105                	addi	sp,sp,32
    800020ce:	8082                	ret

00000000800020d0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020d0:	1101                	addi	sp,sp,-32
    800020d2:	ec06                	sd	ra,24(sp)
    800020d4:	e822                	sd	s0,16(sp)
    800020d6:	e426                	sd	s1,8(sp)
    800020d8:	e04a                	sd	s2,0(sp)
    800020da:	1000                	addi	s0,sp,32
    800020dc:	84ae                	mv	s1,a1
    800020de:	8932                	mv	s2,a2
  *ip = argraw(n);
    800020e0:	00000097          	auipc	ra,0x0
    800020e4:	eaa080e7          	jalr	-342(ra) # 80001f8a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800020e8:	864a                	mv	a2,s2
    800020ea:	85a6                	mv	a1,s1
    800020ec:	00000097          	auipc	ra,0x0
    800020f0:	f58080e7          	jalr	-168(ra) # 80002044 <fetchstr>
}
    800020f4:	60e2                	ld	ra,24(sp)
    800020f6:	6442                	ld	s0,16(sp)
    800020f8:	64a2                	ld	s1,8(sp)
    800020fa:	6902                	ld	s2,0(sp)
    800020fc:	6105                	addi	sp,sp,32
    800020fe:	8082                	ret

0000000080002100 <syscall>:



void
syscall(void)
{
    80002100:	1101                	addi	sp,sp,-32
    80002102:	ec06                	sd	ra,24(sp)
    80002104:	e822                	sd	s0,16(sp)
    80002106:	e426                	sd	s1,8(sp)
    80002108:	e04a                	sd	s2,0(sp)
    8000210a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000210c:	fffff097          	auipc	ra,0xfffff
    80002110:	e1e080e7          	jalr	-482(ra) # 80000f2a <myproc>
    80002114:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002116:	05853903          	ld	s2,88(a0)
    8000211a:	0a893783          	ld	a5,168(s2)
    8000211e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002122:	37fd                	addiw	a5,a5,-1
    80002124:	4775                	li	a4,29
    80002126:	00f76f63          	bltu	a4,a5,80002144 <syscall+0x44>
    8000212a:	00369713          	slli	a4,a3,0x3
    8000212e:	00006797          	auipc	a5,0x6
    80002132:	2ca78793          	addi	a5,a5,714 # 800083f8 <syscalls>
    80002136:	97ba                	add	a5,a5,a4
    80002138:	639c                	ld	a5,0(a5)
    8000213a:	c789                	beqz	a5,80002144 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000213c:	9782                	jalr	a5
    8000213e:	06a93823          	sd	a0,112(s2)
    80002142:	a839                	j	80002160 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002144:	15848613          	addi	a2,s1,344
    80002148:	588c                	lw	a1,48(s1)
    8000214a:	00006517          	auipc	a0,0x6
    8000214e:	27650513          	addi	a0,a0,630 # 800083c0 <states.1718+0x150>
    80002152:	00004097          	auipc	ra,0x4
    80002156:	cb0080e7          	jalr	-848(ra) # 80005e02 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000215a:	6cbc                	ld	a5,88(s1)
    8000215c:	577d                	li	a4,-1
    8000215e:	fbb8                	sd	a4,112(a5)
  }
}
    80002160:	60e2                	ld	ra,24(sp)
    80002162:	6442                	ld	s0,16(sp)
    80002164:	64a2                	ld	s1,8(sp)
    80002166:	6902                	ld	s2,0(sp)
    80002168:	6105                	addi	sp,sp,32
    8000216a:	8082                	ret

000000008000216c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000216c:	1101                	addi	sp,sp,-32
    8000216e:	ec06                	sd	ra,24(sp)
    80002170:	e822                	sd	s0,16(sp)
    80002172:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002174:	fec40593          	addi	a1,s0,-20
    80002178:	4501                	li	a0,0
    8000217a:	00000097          	auipc	ra,0x0
    8000217e:	f12080e7          	jalr	-238(ra) # 8000208c <argint>
    return -1;
    80002182:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002184:	00054963          	bltz	a0,80002196 <sys_exit+0x2a>
  exit(n);
    80002188:	fec42503          	lw	a0,-20(s0)
    8000218c:	fffff097          	auipc	ra,0xfffff
    80002190:	76c080e7          	jalr	1900(ra) # 800018f8 <exit>
  return 0;  // not reached
    80002194:	4781                	li	a5,0
}
    80002196:	853e                	mv	a0,a5
    80002198:	60e2                	ld	ra,24(sp)
    8000219a:	6442                	ld	s0,16(sp)
    8000219c:	6105                	addi	sp,sp,32
    8000219e:	8082                	ret

00000000800021a0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021a0:	1141                	addi	sp,sp,-16
    800021a2:	e406                	sd	ra,8(sp)
    800021a4:	e022                	sd	s0,0(sp)
    800021a6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021a8:	fffff097          	auipc	ra,0xfffff
    800021ac:	d82080e7          	jalr	-638(ra) # 80000f2a <myproc>
}
    800021b0:	5908                	lw	a0,48(a0)
    800021b2:	60a2                	ld	ra,8(sp)
    800021b4:	6402                	ld	s0,0(sp)
    800021b6:	0141                	addi	sp,sp,16
    800021b8:	8082                	ret

00000000800021ba <sys_fork>:

uint64
sys_fork(void)
{
    800021ba:	1141                	addi	sp,sp,-16
    800021bc:	e406                	sd	ra,8(sp)
    800021be:	e022                	sd	s0,0(sp)
    800021c0:	0800                	addi	s0,sp,16
  return fork();
    800021c2:	fffff097          	auipc	ra,0xfffff
    800021c6:	1ec080e7          	jalr	492(ra) # 800013ae <fork>
}
    800021ca:	60a2                	ld	ra,8(sp)
    800021cc:	6402                	ld	s0,0(sp)
    800021ce:	0141                	addi	sp,sp,16
    800021d0:	8082                	ret

00000000800021d2 <sys_wait>:

uint64
sys_wait(void)
{
    800021d2:	1101                	addi	sp,sp,-32
    800021d4:	ec06                	sd	ra,24(sp)
    800021d6:	e822                	sd	s0,16(sp)
    800021d8:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800021da:	fe840593          	addi	a1,s0,-24
    800021de:	4501                	li	a0,0
    800021e0:	00000097          	auipc	ra,0x0
    800021e4:	ece080e7          	jalr	-306(ra) # 800020ae <argaddr>
    800021e8:	87aa                	mv	a5,a0
    return -1;
    800021ea:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800021ec:	0007c863          	bltz	a5,800021fc <sys_wait+0x2a>
  return wait(p);
    800021f0:	fe843503          	ld	a0,-24(s0)
    800021f4:	fffff097          	auipc	ra,0xfffff
    800021f8:	50c080e7          	jalr	1292(ra) # 80001700 <wait>
}
    800021fc:	60e2                	ld	ra,24(sp)
    800021fe:	6442                	ld	s0,16(sp)
    80002200:	6105                	addi	sp,sp,32
    80002202:	8082                	ret

0000000080002204 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002204:	7179                	addi	sp,sp,-48
    80002206:	f406                	sd	ra,40(sp)
    80002208:	f022                	sd	s0,32(sp)
    8000220a:	ec26                	sd	s1,24(sp)
    8000220c:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000220e:	fdc40593          	addi	a1,s0,-36
    80002212:	4501                	li	a0,0
    80002214:	00000097          	auipc	ra,0x0
    80002218:	e78080e7          	jalr	-392(ra) # 8000208c <argint>
    8000221c:	87aa                	mv	a5,a0
    return -1;
    8000221e:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002220:	0207c063          	bltz	a5,80002240 <sys_sbrk+0x3c>
  
  addr = myproc()->sz;
    80002224:	fffff097          	auipc	ra,0xfffff
    80002228:	d06080e7          	jalr	-762(ra) # 80000f2a <myproc>
    8000222c:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000222e:	fdc42503          	lw	a0,-36(s0)
    80002232:	fffff097          	auipc	ra,0xfffff
    80002236:	108080e7          	jalr	264(ra) # 8000133a <growproc>
    8000223a:	00054863          	bltz	a0,8000224a <sys_sbrk+0x46>
    return -1;
  return addr;
    8000223e:	8526                	mv	a0,s1
}
    80002240:	70a2                	ld	ra,40(sp)
    80002242:	7402                	ld	s0,32(sp)
    80002244:	64e2                	ld	s1,24(sp)
    80002246:	6145                	addi	sp,sp,48
    80002248:	8082                	ret
    return -1;
    8000224a:	557d                	li	a0,-1
    8000224c:	bfd5                	j	80002240 <sys_sbrk+0x3c>

000000008000224e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000224e:	7139                	addi	sp,sp,-64
    80002250:	fc06                	sd	ra,56(sp)
    80002252:	f822                	sd	s0,48(sp)
    80002254:	f426                	sd	s1,40(sp)
    80002256:	f04a                	sd	s2,32(sp)
    80002258:	ec4e                	sd	s3,24(sp)
    8000225a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    8000225c:	fcc40593          	addi	a1,s0,-52
    80002260:	4501                	li	a0,0
    80002262:	00000097          	auipc	ra,0x0
    80002266:	e2a080e7          	jalr	-470(ra) # 8000208c <argint>
    return -1;
    8000226a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000226c:	06054563          	bltz	a0,800022d6 <sys_sleep+0x88>
  acquire(&tickslock);
    80002270:	0000d517          	auipc	a0,0xd
    80002274:	c1050513          	addi	a0,a0,-1008 # 8000ee80 <tickslock>
    80002278:	00004097          	auipc	ra,0x4
    8000227c:	08a080e7          	jalr	138(ra) # 80006302 <acquire>
  ticks0 = ticks;
    80002280:	00007917          	auipc	s2,0x7
    80002284:	d9892903          	lw	s2,-616(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002288:	fcc42783          	lw	a5,-52(s0)
    8000228c:	cf85                	beqz	a5,800022c4 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000228e:	0000d997          	auipc	s3,0xd
    80002292:	bf298993          	addi	s3,s3,-1038 # 8000ee80 <tickslock>
    80002296:	00007497          	auipc	s1,0x7
    8000229a:	d8248493          	addi	s1,s1,-638 # 80009018 <ticks>
    if(myproc()->killed){
    8000229e:	fffff097          	auipc	ra,0xfffff
    800022a2:	c8c080e7          	jalr	-884(ra) # 80000f2a <myproc>
    800022a6:	551c                	lw	a5,40(a0)
    800022a8:	ef9d                	bnez	a5,800022e6 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022aa:	85ce                	mv	a1,s3
    800022ac:	8526                	mv	a0,s1
    800022ae:	fffff097          	auipc	ra,0xfffff
    800022b2:	3ee080e7          	jalr	1006(ra) # 8000169c <sleep>
  while(ticks - ticks0 < n){
    800022b6:	409c                	lw	a5,0(s1)
    800022b8:	412787bb          	subw	a5,a5,s2
    800022bc:	fcc42703          	lw	a4,-52(s0)
    800022c0:	fce7efe3          	bltu	a5,a4,8000229e <sys_sleep+0x50>
  }
  release(&tickslock);
    800022c4:	0000d517          	auipc	a0,0xd
    800022c8:	bbc50513          	addi	a0,a0,-1092 # 8000ee80 <tickslock>
    800022cc:	00004097          	auipc	ra,0x4
    800022d0:	0ea080e7          	jalr	234(ra) # 800063b6 <release>
  return 0;
    800022d4:	4781                	li	a5,0
}
    800022d6:	853e                	mv	a0,a5
    800022d8:	70e2                	ld	ra,56(sp)
    800022da:	7442                	ld	s0,48(sp)
    800022dc:	74a2                	ld	s1,40(sp)
    800022de:	7902                	ld	s2,32(sp)
    800022e0:	69e2                	ld	s3,24(sp)
    800022e2:	6121                	addi	sp,sp,64
    800022e4:	8082                	ret
      release(&tickslock);
    800022e6:	0000d517          	auipc	a0,0xd
    800022ea:	b9a50513          	addi	a0,a0,-1126 # 8000ee80 <tickslock>
    800022ee:	00004097          	auipc	ra,0x4
    800022f2:	0c8080e7          	jalr	200(ra) # 800063b6 <release>
      return -1;
    800022f6:	57fd                	li	a5,-1
    800022f8:	bff9                	j	800022d6 <sys_sleep+0x88>

00000000800022fa <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    800022fa:	715d                	addi	sp,sp,-80
    800022fc:	e486                	sd	ra,72(sp)
    800022fe:	e0a2                	sd	s0,64(sp)
    80002300:	fc26                	sd	s1,56(sp)
    80002302:	f84a                	sd	s2,48(sp)
    80002304:	f44e                	sd	s3,40(sp)
    80002306:	0880                	addi	s0,sp,80
  // lab pgtbl: your code here.
    uint64 va,dst;
    int n;
    if(argint(1, &n) < 0 || argaddr(0, &va) < 0 || argaddr(2, &dst) < 0)
    80002308:	fbc40593          	addi	a1,s0,-68
    8000230c:	4505                	li	a0,1
    8000230e:	00000097          	auipc	ra,0x0
    80002312:	d7e080e7          	jalr	-642(ra) # 8000208c <argint>
    80002316:	0c054263          	bltz	a0,800023da <sys_pgaccess+0xe0>
    8000231a:	fc840593          	addi	a1,s0,-56
    8000231e:	4501                	li	a0,0
    80002320:	00000097          	auipc	ra,0x0
    80002324:	d8e080e7          	jalr	-626(ra) # 800020ae <argaddr>
    80002328:	0a054b63          	bltz	a0,800023de <sys_pgaccess+0xe4>
    8000232c:	fc040593          	addi	a1,s0,-64
    80002330:	4509                	li	a0,2
    80002332:	00000097          	auipc	ra,0x0
    80002336:	d7c080e7          	jalr	-644(ra) # 800020ae <argaddr>
    8000233a:	0a054463          	bltz	a0,800023e2 <sys_pgaccess+0xe8>
        return -1;
    if(n > 64 || n < 0)
    8000233e:	fbc42703          	lw	a4,-68(s0)
    80002342:	04000793          	li	a5,64
    80002346:	0ae7e063          	bltu	a5,a4,800023e6 <sys_pgaccess+0xec>
        return -1;
    uint64 bitmask = 0,mask = 1;
    8000234a:	fa043823          	sd	zero,-80(s0)
    pte_t *pte;
    pagetable_t pagetable = myproc()->pagetable;
    8000234e:	fffff097          	auipc	ra,0xfffff
    80002352:	bdc080e7          	jalr	-1060(ra) # 80000f2a <myproc>
    80002356:	05053903          	ld	s2,80(a0)
    while(n > 0){
    8000235a:	fbc42783          	lw	a5,-68(s0)
    8000235e:	04f05b63          	blez	a5,800023b4 <sys_pgaccess+0xba>
    uint64 bitmask = 0,mask = 1;
    80002362:	4485                	li	s1,1
            if(*pte & PTE_A)
                bitmask |= mask;
            *pte = *pte & (~PTE_A);
        }
        mask <<= 1;
        va = (uint64)((char*)(va)+PGSIZE);
    80002364:	6985                	lui	s3,0x1
    80002366:	a025                	j	8000238e <sys_pgaccess+0x94>
            *pte = *pte & (~PTE_A);
    80002368:	611c                	ld	a5,0(a0)
    8000236a:	fbf7f793          	andi	a5,a5,-65
    8000236e:	e11c                	sd	a5,0(a0)
        mask <<= 1;
    80002370:	0486                	slli	s1,s1,0x1
        va = (uint64)((char*)(va)+PGSIZE);
    80002372:	fc843783          	ld	a5,-56(s0)
    80002376:	97ce                	add	a5,a5,s3
    80002378:	fcf43423          	sd	a5,-56(s0)
        n--;
    8000237c:	fbc42783          	lw	a5,-68(s0)
    80002380:	37fd                	addiw	a5,a5,-1
    80002382:	0007871b          	sext.w	a4,a5
    80002386:	faf42e23          	sw	a5,-68(s0)
    while(n > 0){
    8000238a:	02e05563          	blez	a4,800023b4 <sys_pgaccess+0xba>
        pte = walk(pagetable,va,1);
    8000238e:	4605                	li	a2,1
    80002390:	fc843583          	ld	a1,-56(s0)
    80002394:	854a                	mv	a0,s2
    80002396:	ffffe097          	auipc	ra,0xffffe
    8000239a:	17c080e7          	jalr	380(ra) # 80000512 <walk>
        if(pte){
    8000239e:	d969                	beqz	a0,80002370 <sys_pgaccess+0x76>
            if(*pte & PTE_A)
    800023a0:	611c                	ld	a5,0(a0)
    800023a2:	0407f793          	andi	a5,a5,64
    800023a6:	d3e9                	beqz	a5,80002368 <sys_pgaccess+0x6e>
                bitmask |= mask;
    800023a8:	fb043783          	ld	a5,-80(s0)
    800023ac:	8fc5                	or	a5,a5,s1
    800023ae:	faf43823          	sd	a5,-80(s0)
    800023b2:	bf5d                	j	80002368 <sys_pgaccess+0x6e>
    }
    if(copyout(pagetable,dst,(char *)&bitmask,sizeof(bitmask)) < 0)
    800023b4:	46a1                	li	a3,8
    800023b6:	fb040613          	addi	a2,s0,-80
    800023ba:	fc043583          	ld	a1,-64(s0)
    800023be:	854a                	mv	a0,s2
    800023c0:	ffffe097          	auipc	ra,0xffffe
    800023c4:	7fc080e7          	jalr	2044(ra) # 80000bbc <copyout>
    800023c8:	41f5551b          	sraiw	a0,a0,0x1f
        return -1;
    return 0;
}
    800023cc:	60a6                	ld	ra,72(sp)
    800023ce:	6406                	ld	s0,64(sp)
    800023d0:	74e2                	ld	s1,56(sp)
    800023d2:	7942                	ld	s2,48(sp)
    800023d4:	79a2                	ld	s3,40(sp)
    800023d6:	6161                	addi	sp,sp,80
    800023d8:	8082                	ret
        return -1;
    800023da:	557d                	li	a0,-1
    800023dc:	bfc5                	j	800023cc <sys_pgaccess+0xd2>
    800023de:	557d                	li	a0,-1
    800023e0:	b7f5                	j	800023cc <sys_pgaccess+0xd2>
    800023e2:	557d                	li	a0,-1
    800023e4:	b7e5                	j	800023cc <sys_pgaccess+0xd2>
        return -1;
    800023e6:	557d                	li	a0,-1
    800023e8:	b7d5                	j	800023cc <sys_pgaccess+0xd2>

00000000800023ea <sys_kill>:
#endif

uint64
sys_kill(void)
{
    800023ea:	1101                	addi	sp,sp,-32
    800023ec:	ec06                	sd	ra,24(sp)
    800023ee:	e822                	sd	s0,16(sp)
    800023f0:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800023f2:	fec40593          	addi	a1,s0,-20
    800023f6:	4501                	li	a0,0
    800023f8:	00000097          	auipc	ra,0x0
    800023fc:	c94080e7          	jalr	-876(ra) # 8000208c <argint>
    80002400:	87aa                	mv	a5,a0
    return -1;
    80002402:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002404:	0007c863          	bltz	a5,80002414 <sys_kill+0x2a>
  return kill(pid);
    80002408:	fec42503          	lw	a0,-20(s0)
    8000240c:	fffff097          	auipc	ra,0xfffff
    80002410:	5c2080e7          	jalr	1474(ra) # 800019ce <kill>
}
    80002414:	60e2                	ld	ra,24(sp)
    80002416:	6442                	ld	s0,16(sp)
    80002418:	6105                	addi	sp,sp,32
    8000241a:	8082                	ret

000000008000241c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000241c:	1101                	addi	sp,sp,-32
    8000241e:	ec06                	sd	ra,24(sp)
    80002420:	e822                	sd	s0,16(sp)
    80002422:	e426                	sd	s1,8(sp)
    80002424:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002426:	0000d517          	auipc	a0,0xd
    8000242a:	a5a50513          	addi	a0,a0,-1446 # 8000ee80 <tickslock>
    8000242e:	00004097          	auipc	ra,0x4
    80002432:	ed4080e7          	jalr	-300(ra) # 80006302 <acquire>
  xticks = ticks;
    80002436:	00007497          	auipc	s1,0x7
    8000243a:	be24a483          	lw	s1,-1054(s1) # 80009018 <ticks>
  release(&tickslock);
    8000243e:	0000d517          	auipc	a0,0xd
    80002442:	a4250513          	addi	a0,a0,-1470 # 8000ee80 <tickslock>
    80002446:	00004097          	auipc	ra,0x4
    8000244a:	f70080e7          	jalr	-144(ra) # 800063b6 <release>
  return xticks;
}
    8000244e:	02049513          	slli	a0,s1,0x20
    80002452:	9101                	srli	a0,a0,0x20
    80002454:	60e2                	ld	ra,24(sp)
    80002456:	6442                	ld	s0,16(sp)
    80002458:	64a2                	ld	s1,8(sp)
    8000245a:	6105                	addi	sp,sp,32
    8000245c:	8082                	ret

000000008000245e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000245e:	7179                	addi	sp,sp,-48
    80002460:	f406                	sd	ra,40(sp)
    80002462:	f022                	sd	s0,32(sp)
    80002464:	ec26                	sd	s1,24(sp)
    80002466:	e84a                	sd	s2,16(sp)
    80002468:	e44e                	sd	s3,8(sp)
    8000246a:	e052                	sd	s4,0(sp)
    8000246c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000246e:	00006597          	auipc	a1,0x6
    80002472:	08258593          	addi	a1,a1,130 # 800084f0 <syscalls+0xf8>
    80002476:	0000d517          	auipc	a0,0xd
    8000247a:	a2250513          	addi	a0,a0,-1502 # 8000ee98 <bcache>
    8000247e:	00004097          	auipc	ra,0x4
    80002482:	df4080e7          	jalr	-524(ra) # 80006272 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002486:	00015797          	auipc	a5,0x15
    8000248a:	a1278793          	addi	a5,a5,-1518 # 80016e98 <bcache+0x8000>
    8000248e:	00015717          	auipc	a4,0x15
    80002492:	c7270713          	addi	a4,a4,-910 # 80017100 <bcache+0x8268>
    80002496:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000249a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000249e:	0000d497          	auipc	s1,0xd
    800024a2:	a1248493          	addi	s1,s1,-1518 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    800024a6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024a8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024aa:	00006a17          	auipc	s4,0x6
    800024ae:	04ea0a13          	addi	s4,s4,78 # 800084f8 <syscalls+0x100>
    b->next = bcache.head.next;
    800024b2:	2b893783          	ld	a5,696(s2)
    800024b6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024b8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024bc:	85d2                	mv	a1,s4
    800024be:	01048513          	addi	a0,s1,16
    800024c2:	00001097          	auipc	ra,0x1
    800024c6:	4bc080e7          	jalr	1212(ra) # 8000397e <initsleeplock>
    bcache.head.next->prev = b;
    800024ca:	2b893783          	ld	a5,696(s2)
    800024ce:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024d0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024d4:	45848493          	addi	s1,s1,1112
    800024d8:	fd349de3          	bne	s1,s3,800024b2 <binit+0x54>
  }
}
    800024dc:	70a2                	ld	ra,40(sp)
    800024de:	7402                	ld	s0,32(sp)
    800024e0:	64e2                	ld	s1,24(sp)
    800024e2:	6942                	ld	s2,16(sp)
    800024e4:	69a2                	ld	s3,8(sp)
    800024e6:	6a02                	ld	s4,0(sp)
    800024e8:	6145                	addi	sp,sp,48
    800024ea:	8082                	ret

00000000800024ec <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024ec:	7179                	addi	sp,sp,-48
    800024ee:	f406                	sd	ra,40(sp)
    800024f0:	f022                	sd	s0,32(sp)
    800024f2:	ec26                	sd	s1,24(sp)
    800024f4:	e84a                	sd	s2,16(sp)
    800024f6:	e44e                	sd	s3,8(sp)
    800024f8:	1800                	addi	s0,sp,48
    800024fa:	89aa                	mv	s3,a0
    800024fc:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800024fe:	0000d517          	auipc	a0,0xd
    80002502:	99a50513          	addi	a0,a0,-1638 # 8000ee98 <bcache>
    80002506:	00004097          	auipc	ra,0x4
    8000250a:	dfc080e7          	jalr	-516(ra) # 80006302 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000250e:	00015497          	auipc	s1,0x15
    80002512:	c424b483          	ld	s1,-958(s1) # 80017150 <bcache+0x82b8>
    80002516:	00015797          	auipc	a5,0x15
    8000251a:	bea78793          	addi	a5,a5,-1046 # 80017100 <bcache+0x8268>
    8000251e:	02f48f63          	beq	s1,a5,8000255c <bread+0x70>
    80002522:	873e                	mv	a4,a5
    80002524:	a021                	j	8000252c <bread+0x40>
    80002526:	68a4                	ld	s1,80(s1)
    80002528:	02e48a63          	beq	s1,a4,8000255c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000252c:	449c                	lw	a5,8(s1)
    8000252e:	ff379ce3          	bne	a5,s3,80002526 <bread+0x3a>
    80002532:	44dc                	lw	a5,12(s1)
    80002534:	ff2799e3          	bne	a5,s2,80002526 <bread+0x3a>
      b->refcnt++;
    80002538:	40bc                	lw	a5,64(s1)
    8000253a:	2785                	addiw	a5,a5,1
    8000253c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000253e:	0000d517          	auipc	a0,0xd
    80002542:	95a50513          	addi	a0,a0,-1702 # 8000ee98 <bcache>
    80002546:	00004097          	auipc	ra,0x4
    8000254a:	e70080e7          	jalr	-400(ra) # 800063b6 <release>
      acquiresleep(&b->lock);
    8000254e:	01048513          	addi	a0,s1,16
    80002552:	00001097          	auipc	ra,0x1
    80002556:	466080e7          	jalr	1126(ra) # 800039b8 <acquiresleep>
      return b;
    8000255a:	a8b9                	j	800025b8 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000255c:	00015497          	auipc	s1,0x15
    80002560:	bec4b483          	ld	s1,-1044(s1) # 80017148 <bcache+0x82b0>
    80002564:	00015797          	auipc	a5,0x15
    80002568:	b9c78793          	addi	a5,a5,-1124 # 80017100 <bcache+0x8268>
    8000256c:	00f48863          	beq	s1,a5,8000257c <bread+0x90>
    80002570:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002572:	40bc                	lw	a5,64(s1)
    80002574:	cf81                	beqz	a5,8000258c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002576:	64a4                	ld	s1,72(s1)
    80002578:	fee49de3          	bne	s1,a4,80002572 <bread+0x86>
  panic("bget: no buffers");
    8000257c:	00006517          	auipc	a0,0x6
    80002580:	f8450513          	addi	a0,a0,-124 # 80008500 <syscalls+0x108>
    80002584:	00004097          	auipc	ra,0x4
    80002588:	834080e7          	jalr	-1996(ra) # 80005db8 <panic>
      b->dev = dev;
    8000258c:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002590:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002594:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002598:	4785                	li	a5,1
    8000259a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000259c:	0000d517          	auipc	a0,0xd
    800025a0:	8fc50513          	addi	a0,a0,-1796 # 8000ee98 <bcache>
    800025a4:	00004097          	auipc	ra,0x4
    800025a8:	e12080e7          	jalr	-494(ra) # 800063b6 <release>
      acquiresleep(&b->lock);
    800025ac:	01048513          	addi	a0,s1,16
    800025b0:	00001097          	auipc	ra,0x1
    800025b4:	408080e7          	jalr	1032(ra) # 800039b8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025b8:	409c                	lw	a5,0(s1)
    800025ba:	cb89                	beqz	a5,800025cc <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025bc:	8526                	mv	a0,s1
    800025be:	70a2                	ld	ra,40(sp)
    800025c0:	7402                	ld	s0,32(sp)
    800025c2:	64e2                	ld	s1,24(sp)
    800025c4:	6942                	ld	s2,16(sp)
    800025c6:	69a2                	ld	s3,8(sp)
    800025c8:	6145                	addi	sp,sp,48
    800025ca:	8082                	ret
    virtio_disk_rw(b, 0);
    800025cc:	4581                	li	a1,0
    800025ce:	8526                	mv	a0,s1
    800025d0:	00003097          	auipc	ra,0x3
    800025d4:	f26080e7          	jalr	-218(ra) # 800054f6 <virtio_disk_rw>
    b->valid = 1;
    800025d8:	4785                	li	a5,1
    800025da:	c09c                	sw	a5,0(s1)
  return b;
    800025dc:	b7c5                	j	800025bc <bread+0xd0>

00000000800025de <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025de:	1101                	addi	sp,sp,-32
    800025e0:	ec06                	sd	ra,24(sp)
    800025e2:	e822                	sd	s0,16(sp)
    800025e4:	e426                	sd	s1,8(sp)
    800025e6:	1000                	addi	s0,sp,32
    800025e8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025ea:	0541                	addi	a0,a0,16
    800025ec:	00001097          	auipc	ra,0x1
    800025f0:	466080e7          	jalr	1126(ra) # 80003a52 <holdingsleep>
    800025f4:	cd01                	beqz	a0,8000260c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800025f6:	4585                	li	a1,1
    800025f8:	8526                	mv	a0,s1
    800025fa:	00003097          	auipc	ra,0x3
    800025fe:	efc080e7          	jalr	-260(ra) # 800054f6 <virtio_disk_rw>
}
    80002602:	60e2                	ld	ra,24(sp)
    80002604:	6442                	ld	s0,16(sp)
    80002606:	64a2                	ld	s1,8(sp)
    80002608:	6105                	addi	sp,sp,32
    8000260a:	8082                	ret
    panic("bwrite");
    8000260c:	00006517          	auipc	a0,0x6
    80002610:	f0c50513          	addi	a0,a0,-244 # 80008518 <syscalls+0x120>
    80002614:	00003097          	auipc	ra,0x3
    80002618:	7a4080e7          	jalr	1956(ra) # 80005db8 <panic>

000000008000261c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000261c:	1101                	addi	sp,sp,-32
    8000261e:	ec06                	sd	ra,24(sp)
    80002620:	e822                	sd	s0,16(sp)
    80002622:	e426                	sd	s1,8(sp)
    80002624:	e04a                	sd	s2,0(sp)
    80002626:	1000                	addi	s0,sp,32
    80002628:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000262a:	01050913          	addi	s2,a0,16
    8000262e:	854a                	mv	a0,s2
    80002630:	00001097          	auipc	ra,0x1
    80002634:	422080e7          	jalr	1058(ra) # 80003a52 <holdingsleep>
    80002638:	c92d                	beqz	a0,800026aa <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000263a:	854a                	mv	a0,s2
    8000263c:	00001097          	auipc	ra,0x1
    80002640:	3d2080e7          	jalr	978(ra) # 80003a0e <releasesleep>

  acquire(&bcache.lock);
    80002644:	0000d517          	auipc	a0,0xd
    80002648:	85450513          	addi	a0,a0,-1964 # 8000ee98 <bcache>
    8000264c:	00004097          	auipc	ra,0x4
    80002650:	cb6080e7          	jalr	-842(ra) # 80006302 <acquire>
  b->refcnt--;
    80002654:	40bc                	lw	a5,64(s1)
    80002656:	37fd                	addiw	a5,a5,-1
    80002658:	0007871b          	sext.w	a4,a5
    8000265c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000265e:	eb05                	bnez	a4,8000268e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002660:	68bc                	ld	a5,80(s1)
    80002662:	64b8                	ld	a4,72(s1)
    80002664:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002666:	64bc                	ld	a5,72(s1)
    80002668:	68b8                	ld	a4,80(s1)
    8000266a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000266c:	00015797          	auipc	a5,0x15
    80002670:	82c78793          	addi	a5,a5,-2004 # 80016e98 <bcache+0x8000>
    80002674:	2b87b703          	ld	a4,696(a5)
    80002678:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000267a:	00015717          	auipc	a4,0x15
    8000267e:	a8670713          	addi	a4,a4,-1402 # 80017100 <bcache+0x8268>
    80002682:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002684:	2b87b703          	ld	a4,696(a5)
    80002688:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000268a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000268e:	0000d517          	auipc	a0,0xd
    80002692:	80a50513          	addi	a0,a0,-2038 # 8000ee98 <bcache>
    80002696:	00004097          	auipc	ra,0x4
    8000269a:	d20080e7          	jalr	-736(ra) # 800063b6 <release>
}
    8000269e:	60e2                	ld	ra,24(sp)
    800026a0:	6442                	ld	s0,16(sp)
    800026a2:	64a2                	ld	s1,8(sp)
    800026a4:	6902                	ld	s2,0(sp)
    800026a6:	6105                	addi	sp,sp,32
    800026a8:	8082                	ret
    panic("brelse");
    800026aa:	00006517          	auipc	a0,0x6
    800026ae:	e7650513          	addi	a0,a0,-394 # 80008520 <syscalls+0x128>
    800026b2:	00003097          	auipc	ra,0x3
    800026b6:	706080e7          	jalr	1798(ra) # 80005db8 <panic>

00000000800026ba <bpin>:

void
bpin(struct buf *b) {
    800026ba:	1101                	addi	sp,sp,-32
    800026bc:	ec06                	sd	ra,24(sp)
    800026be:	e822                	sd	s0,16(sp)
    800026c0:	e426                	sd	s1,8(sp)
    800026c2:	1000                	addi	s0,sp,32
    800026c4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026c6:	0000c517          	auipc	a0,0xc
    800026ca:	7d250513          	addi	a0,a0,2002 # 8000ee98 <bcache>
    800026ce:	00004097          	auipc	ra,0x4
    800026d2:	c34080e7          	jalr	-972(ra) # 80006302 <acquire>
  b->refcnt++;
    800026d6:	40bc                	lw	a5,64(s1)
    800026d8:	2785                	addiw	a5,a5,1
    800026da:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026dc:	0000c517          	auipc	a0,0xc
    800026e0:	7bc50513          	addi	a0,a0,1980 # 8000ee98 <bcache>
    800026e4:	00004097          	auipc	ra,0x4
    800026e8:	cd2080e7          	jalr	-814(ra) # 800063b6 <release>
}
    800026ec:	60e2                	ld	ra,24(sp)
    800026ee:	6442                	ld	s0,16(sp)
    800026f0:	64a2                	ld	s1,8(sp)
    800026f2:	6105                	addi	sp,sp,32
    800026f4:	8082                	ret

00000000800026f6 <bunpin>:

void
bunpin(struct buf *b) {
    800026f6:	1101                	addi	sp,sp,-32
    800026f8:	ec06                	sd	ra,24(sp)
    800026fa:	e822                	sd	s0,16(sp)
    800026fc:	e426                	sd	s1,8(sp)
    800026fe:	1000                	addi	s0,sp,32
    80002700:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002702:	0000c517          	auipc	a0,0xc
    80002706:	79650513          	addi	a0,a0,1942 # 8000ee98 <bcache>
    8000270a:	00004097          	auipc	ra,0x4
    8000270e:	bf8080e7          	jalr	-1032(ra) # 80006302 <acquire>
  b->refcnt--;
    80002712:	40bc                	lw	a5,64(s1)
    80002714:	37fd                	addiw	a5,a5,-1
    80002716:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002718:	0000c517          	auipc	a0,0xc
    8000271c:	78050513          	addi	a0,a0,1920 # 8000ee98 <bcache>
    80002720:	00004097          	auipc	ra,0x4
    80002724:	c96080e7          	jalr	-874(ra) # 800063b6 <release>
}
    80002728:	60e2                	ld	ra,24(sp)
    8000272a:	6442                	ld	s0,16(sp)
    8000272c:	64a2                	ld	s1,8(sp)
    8000272e:	6105                	addi	sp,sp,32
    80002730:	8082                	ret

0000000080002732 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002732:	1101                	addi	sp,sp,-32
    80002734:	ec06                	sd	ra,24(sp)
    80002736:	e822                	sd	s0,16(sp)
    80002738:	e426                	sd	s1,8(sp)
    8000273a:	e04a                	sd	s2,0(sp)
    8000273c:	1000                	addi	s0,sp,32
    8000273e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002740:	00d5d59b          	srliw	a1,a1,0xd
    80002744:	00015797          	auipc	a5,0x15
    80002748:	e307a783          	lw	a5,-464(a5) # 80017574 <sb+0x1c>
    8000274c:	9dbd                	addw	a1,a1,a5
    8000274e:	00000097          	auipc	ra,0x0
    80002752:	d9e080e7          	jalr	-610(ra) # 800024ec <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002756:	0074f713          	andi	a4,s1,7
    8000275a:	4785                	li	a5,1
    8000275c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002760:	14ce                	slli	s1,s1,0x33
    80002762:	90d9                	srli	s1,s1,0x36
    80002764:	00950733          	add	a4,a0,s1
    80002768:	05874703          	lbu	a4,88(a4)
    8000276c:	00e7f6b3          	and	a3,a5,a4
    80002770:	c69d                	beqz	a3,8000279e <bfree+0x6c>
    80002772:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002774:	94aa                	add	s1,s1,a0
    80002776:	fff7c793          	not	a5,a5
    8000277a:	8ff9                	and	a5,a5,a4
    8000277c:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002780:	00001097          	auipc	ra,0x1
    80002784:	118080e7          	jalr	280(ra) # 80003898 <log_write>
  brelse(bp);
    80002788:	854a                	mv	a0,s2
    8000278a:	00000097          	auipc	ra,0x0
    8000278e:	e92080e7          	jalr	-366(ra) # 8000261c <brelse>
}
    80002792:	60e2                	ld	ra,24(sp)
    80002794:	6442                	ld	s0,16(sp)
    80002796:	64a2                	ld	s1,8(sp)
    80002798:	6902                	ld	s2,0(sp)
    8000279a:	6105                	addi	sp,sp,32
    8000279c:	8082                	ret
    panic("freeing free block");
    8000279e:	00006517          	auipc	a0,0x6
    800027a2:	d8a50513          	addi	a0,a0,-630 # 80008528 <syscalls+0x130>
    800027a6:	00003097          	auipc	ra,0x3
    800027aa:	612080e7          	jalr	1554(ra) # 80005db8 <panic>

00000000800027ae <balloc>:
{
    800027ae:	711d                	addi	sp,sp,-96
    800027b0:	ec86                	sd	ra,88(sp)
    800027b2:	e8a2                	sd	s0,80(sp)
    800027b4:	e4a6                	sd	s1,72(sp)
    800027b6:	e0ca                	sd	s2,64(sp)
    800027b8:	fc4e                	sd	s3,56(sp)
    800027ba:	f852                	sd	s4,48(sp)
    800027bc:	f456                	sd	s5,40(sp)
    800027be:	f05a                	sd	s6,32(sp)
    800027c0:	ec5e                	sd	s7,24(sp)
    800027c2:	e862                	sd	s8,16(sp)
    800027c4:	e466                	sd	s9,8(sp)
    800027c6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027c8:	00015797          	auipc	a5,0x15
    800027cc:	d947a783          	lw	a5,-620(a5) # 8001755c <sb+0x4>
    800027d0:	cbd1                	beqz	a5,80002864 <balloc+0xb6>
    800027d2:	8baa                	mv	s7,a0
    800027d4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027d6:	00015b17          	auipc	s6,0x15
    800027da:	d82b0b13          	addi	s6,s6,-638 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027de:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027e0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027e2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800027e4:	6c89                	lui	s9,0x2
    800027e6:	a831                	j	80002802 <balloc+0x54>
    brelse(bp);
    800027e8:	854a                	mv	a0,s2
    800027ea:	00000097          	auipc	ra,0x0
    800027ee:	e32080e7          	jalr	-462(ra) # 8000261c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027f2:	015c87bb          	addw	a5,s9,s5
    800027f6:	00078a9b          	sext.w	s5,a5
    800027fa:	004b2703          	lw	a4,4(s6)
    800027fe:	06eaf363          	bgeu	s5,a4,80002864 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002802:	41fad79b          	sraiw	a5,s5,0x1f
    80002806:	0137d79b          	srliw	a5,a5,0x13
    8000280a:	015787bb          	addw	a5,a5,s5
    8000280e:	40d7d79b          	sraiw	a5,a5,0xd
    80002812:	01cb2583          	lw	a1,28(s6)
    80002816:	9dbd                	addw	a1,a1,a5
    80002818:	855e                	mv	a0,s7
    8000281a:	00000097          	auipc	ra,0x0
    8000281e:	cd2080e7          	jalr	-814(ra) # 800024ec <bread>
    80002822:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002824:	004b2503          	lw	a0,4(s6)
    80002828:	000a849b          	sext.w	s1,s5
    8000282c:	8662                	mv	a2,s8
    8000282e:	faa4fde3          	bgeu	s1,a0,800027e8 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002832:	41f6579b          	sraiw	a5,a2,0x1f
    80002836:	01d7d69b          	srliw	a3,a5,0x1d
    8000283a:	00c6873b          	addw	a4,a3,a2
    8000283e:	00777793          	andi	a5,a4,7
    80002842:	9f95                	subw	a5,a5,a3
    80002844:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002848:	4037571b          	sraiw	a4,a4,0x3
    8000284c:	00e906b3          	add	a3,s2,a4
    80002850:	0586c683          	lbu	a3,88(a3)
    80002854:	00d7f5b3          	and	a1,a5,a3
    80002858:	cd91                	beqz	a1,80002874 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000285a:	2605                	addiw	a2,a2,1
    8000285c:	2485                	addiw	s1,s1,1
    8000285e:	fd4618e3          	bne	a2,s4,8000282e <balloc+0x80>
    80002862:	b759                	j	800027e8 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002864:	00006517          	auipc	a0,0x6
    80002868:	cdc50513          	addi	a0,a0,-804 # 80008540 <syscalls+0x148>
    8000286c:	00003097          	auipc	ra,0x3
    80002870:	54c080e7          	jalr	1356(ra) # 80005db8 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002874:	974a                	add	a4,a4,s2
    80002876:	8fd5                	or	a5,a5,a3
    80002878:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000287c:	854a                	mv	a0,s2
    8000287e:	00001097          	auipc	ra,0x1
    80002882:	01a080e7          	jalr	26(ra) # 80003898 <log_write>
        brelse(bp);
    80002886:	854a                	mv	a0,s2
    80002888:	00000097          	auipc	ra,0x0
    8000288c:	d94080e7          	jalr	-620(ra) # 8000261c <brelse>
  bp = bread(dev, bno);
    80002890:	85a6                	mv	a1,s1
    80002892:	855e                	mv	a0,s7
    80002894:	00000097          	auipc	ra,0x0
    80002898:	c58080e7          	jalr	-936(ra) # 800024ec <bread>
    8000289c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000289e:	40000613          	li	a2,1024
    800028a2:	4581                	li	a1,0
    800028a4:	05850513          	addi	a0,a0,88
    800028a8:	ffffe097          	auipc	ra,0xffffe
    800028ac:	8d0080e7          	jalr	-1840(ra) # 80000178 <memset>
  log_write(bp);
    800028b0:	854a                	mv	a0,s2
    800028b2:	00001097          	auipc	ra,0x1
    800028b6:	fe6080e7          	jalr	-26(ra) # 80003898 <log_write>
  brelse(bp);
    800028ba:	854a                	mv	a0,s2
    800028bc:	00000097          	auipc	ra,0x0
    800028c0:	d60080e7          	jalr	-672(ra) # 8000261c <brelse>
}
    800028c4:	8526                	mv	a0,s1
    800028c6:	60e6                	ld	ra,88(sp)
    800028c8:	6446                	ld	s0,80(sp)
    800028ca:	64a6                	ld	s1,72(sp)
    800028cc:	6906                	ld	s2,64(sp)
    800028ce:	79e2                	ld	s3,56(sp)
    800028d0:	7a42                	ld	s4,48(sp)
    800028d2:	7aa2                	ld	s5,40(sp)
    800028d4:	7b02                	ld	s6,32(sp)
    800028d6:	6be2                	ld	s7,24(sp)
    800028d8:	6c42                	ld	s8,16(sp)
    800028da:	6ca2                	ld	s9,8(sp)
    800028dc:	6125                	addi	sp,sp,96
    800028de:	8082                	ret

00000000800028e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800028e0:	7179                	addi	sp,sp,-48
    800028e2:	f406                	sd	ra,40(sp)
    800028e4:	f022                	sd	s0,32(sp)
    800028e6:	ec26                	sd	s1,24(sp)
    800028e8:	e84a                	sd	s2,16(sp)
    800028ea:	e44e                	sd	s3,8(sp)
    800028ec:	e052                	sd	s4,0(sp)
    800028ee:	1800                	addi	s0,sp,48
    800028f0:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028f2:	47ad                	li	a5,11
    800028f4:	04b7fe63          	bgeu	a5,a1,80002950 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800028f8:	ff45849b          	addiw	s1,a1,-12
    800028fc:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002900:	0ff00793          	li	a5,255
    80002904:	0ae7e363          	bltu	a5,a4,800029aa <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002908:	08052583          	lw	a1,128(a0)
    8000290c:	c5ad                	beqz	a1,80002976 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000290e:	00092503          	lw	a0,0(s2)
    80002912:	00000097          	auipc	ra,0x0
    80002916:	bda080e7          	jalr	-1062(ra) # 800024ec <bread>
    8000291a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000291c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002920:	02049593          	slli	a1,s1,0x20
    80002924:	9181                	srli	a1,a1,0x20
    80002926:	058a                	slli	a1,a1,0x2
    80002928:	00b784b3          	add	s1,a5,a1
    8000292c:	0004a983          	lw	s3,0(s1)
    80002930:	04098d63          	beqz	s3,8000298a <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002934:	8552                	mv	a0,s4
    80002936:	00000097          	auipc	ra,0x0
    8000293a:	ce6080e7          	jalr	-794(ra) # 8000261c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000293e:	854e                	mv	a0,s3
    80002940:	70a2                	ld	ra,40(sp)
    80002942:	7402                	ld	s0,32(sp)
    80002944:	64e2                	ld	s1,24(sp)
    80002946:	6942                	ld	s2,16(sp)
    80002948:	69a2                	ld	s3,8(sp)
    8000294a:	6a02                	ld	s4,0(sp)
    8000294c:	6145                	addi	sp,sp,48
    8000294e:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002950:	02059493          	slli	s1,a1,0x20
    80002954:	9081                	srli	s1,s1,0x20
    80002956:	048a                	slli	s1,s1,0x2
    80002958:	94aa                	add	s1,s1,a0
    8000295a:	0504a983          	lw	s3,80(s1)
    8000295e:	fe0990e3          	bnez	s3,8000293e <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002962:	4108                	lw	a0,0(a0)
    80002964:	00000097          	auipc	ra,0x0
    80002968:	e4a080e7          	jalr	-438(ra) # 800027ae <balloc>
    8000296c:	0005099b          	sext.w	s3,a0
    80002970:	0534a823          	sw	s3,80(s1)
    80002974:	b7e9                	j	8000293e <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002976:	4108                	lw	a0,0(a0)
    80002978:	00000097          	auipc	ra,0x0
    8000297c:	e36080e7          	jalr	-458(ra) # 800027ae <balloc>
    80002980:	0005059b          	sext.w	a1,a0
    80002984:	08b92023          	sw	a1,128(s2)
    80002988:	b759                	j	8000290e <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000298a:	00092503          	lw	a0,0(s2)
    8000298e:	00000097          	auipc	ra,0x0
    80002992:	e20080e7          	jalr	-480(ra) # 800027ae <balloc>
    80002996:	0005099b          	sext.w	s3,a0
    8000299a:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000299e:	8552                	mv	a0,s4
    800029a0:	00001097          	auipc	ra,0x1
    800029a4:	ef8080e7          	jalr	-264(ra) # 80003898 <log_write>
    800029a8:	b771                	j	80002934 <bmap+0x54>
  panic("bmap: out of range");
    800029aa:	00006517          	auipc	a0,0x6
    800029ae:	bae50513          	addi	a0,a0,-1106 # 80008558 <syscalls+0x160>
    800029b2:	00003097          	auipc	ra,0x3
    800029b6:	406080e7          	jalr	1030(ra) # 80005db8 <panic>

00000000800029ba <iget>:
{
    800029ba:	7179                	addi	sp,sp,-48
    800029bc:	f406                	sd	ra,40(sp)
    800029be:	f022                	sd	s0,32(sp)
    800029c0:	ec26                	sd	s1,24(sp)
    800029c2:	e84a                	sd	s2,16(sp)
    800029c4:	e44e                	sd	s3,8(sp)
    800029c6:	e052                	sd	s4,0(sp)
    800029c8:	1800                	addi	s0,sp,48
    800029ca:	89aa                	mv	s3,a0
    800029cc:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029ce:	00015517          	auipc	a0,0x15
    800029d2:	baa50513          	addi	a0,a0,-1110 # 80017578 <itable>
    800029d6:	00004097          	auipc	ra,0x4
    800029da:	92c080e7          	jalr	-1748(ra) # 80006302 <acquire>
  empty = 0;
    800029de:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029e0:	00015497          	auipc	s1,0x15
    800029e4:	bb048493          	addi	s1,s1,-1104 # 80017590 <itable+0x18>
    800029e8:	00016697          	auipc	a3,0x16
    800029ec:	63868693          	addi	a3,a3,1592 # 80019020 <log>
    800029f0:	a039                	j	800029fe <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029f2:	02090b63          	beqz	s2,80002a28 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029f6:	08848493          	addi	s1,s1,136
    800029fa:	02d48a63          	beq	s1,a3,80002a2e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029fe:	449c                	lw	a5,8(s1)
    80002a00:	fef059e3          	blez	a5,800029f2 <iget+0x38>
    80002a04:	4098                	lw	a4,0(s1)
    80002a06:	ff3716e3          	bne	a4,s3,800029f2 <iget+0x38>
    80002a0a:	40d8                	lw	a4,4(s1)
    80002a0c:	ff4713e3          	bne	a4,s4,800029f2 <iget+0x38>
      ip->ref++;
    80002a10:	2785                	addiw	a5,a5,1
    80002a12:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a14:	00015517          	auipc	a0,0x15
    80002a18:	b6450513          	addi	a0,a0,-1180 # 80017578 <itable>
    80002a1c:	00004097          	auipc	ra,0x4
    80002a20:	99a080e7          	jalr	-1638(ra) # 800063b6 <release>
      return ip;
    80002a24:	8926                	mv	s2,s1
    80002a26:	a03d                	j	80002a54 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a28:	f7f9                	bnez	a5,800029f6 <iget+0x3c>
    80002a2a:	8926                	mv	s2,s1
    80002a2c:	b7e9                	j	800029f6 <iget+0x3c>
  if(empty == 0)
    80002a2e:	02090c63          	beqz	s2,80002a66 <iget+0xac>
  ip->dev = dev;
    80002a32:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a36:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a3a:	4785                	li	a5,1
    80002a3c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a40:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a44:	00015517          	auipc	a0,0x15
    80002a48:	b3450513          	addi	a0,a0,-1228 # 80017578 <itable>
    80002a4c:	00004097          	auipc	ra,0x4
    80002a50:	96a080e7          	jalr	-1686(ra) # 800063b6 <release>
}
    80002a54:	854a                	mv	a0,s2
    80002a56:	70a2                	ld	ra,40(sp)
    80002a58:	7402                	ld	s0,32(sp)
    80002a5a:	64e2                	ld	s1,24(sp)
    80002a5c:	6942                	ld	s2,16(sp)
    80002a5e:	69a2                	ld	s3,8(sp)
    80002a60:	6a02                	ld	s4,0(sp)
    80002a62:	6145                	addi	sp,sp,48
    80002a64:	8082                	ret
    panic("iget: no inodes");
    80002a66:	00006517          	auipc	a0,0x6
    80002a6a:	b0a50513          	addi	a0,a0,-1270 # 80008570 <syscalls+0x178>
    80002a6e:	00003097          	auipc	ra,0x3
    80002a72:	34a080e7          	jalr	842(ra) # 80005db8 <panic>

0000000080002a76 <fsinit>:
fsinit(int dev) {
    80002a76:	7179                	addi	sp,sp,-48
    80002a78:	f406                	sd	ra,40(sp)
    80002a7a:	f022                	sd	s0,32(sp)
    80002a7c:	ec26                	sd	s1,24(sp)
    80002a7e:	e84a                	sd	s2,16(sp)
    80002a80:	e44e                	sd	s3,8(sp)
    80002a82:	1800                	addi	s0,sp,48
    80002a84:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a86:	4585                	li	a1,1
    80002a88:	00000097          	auipc	ra,0x0
    80002a8c:	a64080e7          	jalr	-1436(ra) # 800024ec <bread>
    80002a90:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a92:	00015997          	auipc	s3,0x15
    80002a96:	ac698993          	addi	s3,s3,-1338 # 80017558 <sb>
    80002a9a:	02000613          	li	a2,32
    80002a9e:	05850593          	addi	a1,a0,88
    80002aa2:	854e                	mv	a0,s3
    80002aa4:	ffffd097          	auipc	ra,0xffffd
    80002aa8:	734080e7          	jalr	1844(ra) # 800001d8 <memmove>
  brelse(bp);
    80002aac:	8526                	mv	a0,s1
    80002aae:	00000097          	auipc	ra,0x0
    80002ab2:	b6e080e7          	jalr	-1170(ra) # 8000261c <brelse>
  if(sb.magic != FSMAGIC)
    80002ab6:	0009a703          	lw	a4,0(s3)
    80002aba:	102037b7          	lui	a5,0x10203
    80002abe:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ac2:	02f71263          	bne	a4,a5,80002ae6 <fsinit+0x70>
  initlog(dev, &sb);
    80002ac6:	00015597          	auipc	a1,0x15
    80002aca:	a9258593          	addi	a1,a1,-1390 # 80017558 <sb>
    80002ace:	854a                	mv	a0,s2
    80002ad0:	00001097          	auipc	ra,0x1
    80002ad4:	b4c080e7          	jalr	-1204(ra) # 8000361c <initlog>
}
    80002ad8:	70a2                	ld	ra,40(sp)
    80002ada:	7402                	ld	s0,32(sp)
    80002adc:	64e2                	ld	s1,24(sp)
    80002ade:	6942                	ld	s2,16(sp)
    80002ae0:	69a2                	ld	s3,8(sp)
    80002ae2:	6145                	addi	sp,sp,48
    80002ae4:	8082                	ret
    panic("invalid file system");
    80002ae6:	00006517          	auipc	a0,0x6
    80002aea:	a9a50513          	addi	a0,a0,-1382 # 80008580 <syscalls+0x188>
    80002aee:	00003097          	auipc	ra,0x3
    80002af2:	2ca080e7          	jalr	714(ra) # 80005db8 <panic>

0000000080002af6 <iinit>:
{
    80002af6:	7179                	addi	sp,sp,-48
    80002af8:	f406                	sd	ra,40(sp)
    80002afa:	f022                	sd	s0,32(sp)
    80002afc:	ec26                	sd	s1,24(sp)
    80002afe:	e84a                	sd	s2,16(sp)
    80002b00:	e44e                	sd	s3,8(sp)
    80002b02:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b04:	00006597          	auipc	a1,0x6
    80002b08:	a9458593          	addi	a1,a1,-1388 # 80008598 <syscalls+0x1a0>
    80002b0c:	00015517          	auipc	a0,0x15
    80002b10:	a6c50513          	addi	a0,a0,-1428 # 80017578 <itable>
    80002b14:	00003097          	auipc	ra,0x3
    80002b18:	75e080e7          	jalr	1886(ra) # 80006272 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b1c:	00015497          	auipc	s1,0x15
    80002b20:	a8448493          	addi	s1,s1,-1404 # 800175a0 <itable+0x28>
    80002b24:	00016997          	auipc	s3,0x16
    80002b28:	50c98993          	addi	s3,s3,1292 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b2c:	00006917          	auipc	s2,0x6
    80002b30:	a7490913          	addi	s2,s2,-1420 # 800085a0 <syscalls+0x1a8>
    80002b34:	85ca                	mv	a1,s2
    80002b36:	8526                	mv	a0,s1
    80002b38:	00001097          	auipc	ra,0x1
    80002b3c:	e46080e7          	jalr	-442(ra) # 8000397e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b40:	08848493          	addi	s1,s1,136
    80002b44:	ff3498e3          	bne	s1,s3,80002b34 <iinit+0x3e>
}
    80002b48:	70a2                	ld	ra,40(sp)
    80002b4a:	7402                	ld	s0,32(sp)
    80002b4c:	64e2                	ld	s1,24(sp)
    80002b4e:	6942                	ld	s2,16(sp)
    80002b50:	69a2                	ld	s3,8(sp)
    80002b52:	6145                	addi	sp,sp,48
    80002b54:	8082                	ret

0000000080002b56 <ialloc>:
{
    80002b56:	715d                	addi	sp,sp,-80
    80002b58:	e486                	sd	ra,72(sp)
    80002b5a:	e0a2                	sd	s0,64(sp)
    80002b5c:	fc26                	sd	s1,56(sp)
    80002b5e:	f84a                	sd	s2,48(sp)
    80002b60:	f44e                	sd	s3,40(sp)
    80002b62:	f052                	sd	s4,32(sp)
    80002b64:	ec56                	sd	s5,24(sp)
    80002b66:	e85a                	sd	s6,16(sp)
    80002b68:	e45e                	sd	s7,8(sp)
    80002b6a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b6c:	00015717          	auipc	a4,0x15
    80002b70:	9f872703          	lw	a4,-1544(a4) # 80017564 <sb+0xc>
    80002b74:	4785                	li	a5,1
    80002b76:	04e7fa63          	bgeu	a5,a4,80002bca <ialloc+0x74>
    80002b7a:	8aaa                	mv	s5,a0
    80002b7c:	8bae                	mv	s7,a1
    80002b7e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b80:	00015a17          	auipc	s4,0x15
    80002b84:	9d8a0a13          	addi	s4,s4,-1576 # 80017558 <sb>
    80002b88:	00048b1b          	sext.w	s6,s1
    80002b8c:	0044d593          	srli	a1,s1,0x4
    80002b90:	018a2783          	lw	a5,24(s4)
    80002b94:	9dbd                	addw	a1,a1,a5
    80002b96:	8556                	mv	a0,s5
    80002b98:	00000097          	auipc	ra,0x0
    80002b9c:	954080e7          	jalr	-1708(ra) # 800024ec <bread>
    80002ba0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ba2:	05850993          	addi	s3,a0,88
    80002ba6:	00f4f793          	andi	a5,s1,15
    80002baa:	079a                	slli	a5,a5,0x6
    80002bac:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bae:	00099783          	lh	a5,0(s3)
    80002bb2:	c785                	beqz	a5,80002bda <ialloc+0x84>
    brelse(bp);
    80002bb4:	00000097          	auipc	ra,0x0
    80002bb8:	a68080e7          	jalr	-1432(ra) # 8000261c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bbc:	0485                	addi	s1,s1,1
    80002bbe:	00ca2703          	lw	a4,12(s4)
    80002bc2:	0004879b          	sext.w	a5,s1
    80002bc6:	fce7e1e3          	bltu	a5,a4,80002b88 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002bca:	00006517          	auipc	a0,0x6
    80002bce:	9de50513          	addi	a0,a0,-1570 # 800085a8 <syscalls+0x1b0>
    80002bd2:	00003097          	auipc	ra,0x3
    80002bd6:	1e6080e7          	jalr	486(ra) # 80005db8 <panic>
      memset(dip, 0, sizeof(*dip));
    80002bda:	04000613          	li	a2,64
    80002bde:	4581                	li	a1,0
    80002be0:	854e                	mv	a0,s3
    80002be2:	ffffd097          	auipc	ra,0xffffd
    80002be6:	596080e7          	jalr	1430(ra) # 80000178 <memset>
      dip->type = type;
    80002bea:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bee:	854a                	mv	a0,s2
    80002bf0:	00001097          	auipc	ra,0x1
    80002bf4:	ca8080e7          	jalr	-856(ra) # 80003898 <log_write>
      brelse(bp);
    80002bf8:	854a                	mv	a0,s2
    80002bfa:	00000097          	auipc	ra,0x0
    80002bfe:	a22080e7          	jalr	-1502(ra) # 8000261c <brelse>
      return iget(dev, inum);
    80002c02:	85da                	mv	a1,s6
    80002c04:	8556                	mv	a0,s5
    80002c06:	00000097          	auipc	ra,0x0
    80002c0a:	db4080e7          	jalr	-588(ra) # 800029ba <iget>
}
    80002c0e:	60a6                	ld	ra,72(sp)
    80002c10:	6406                	ld	s0,64(sp)
    80002c12:	74e2                	ld	s1,56(sp)
    80002c14:	7942                	ld	s2,48(sp)
    80002c16:	79a2                	ld	s3,40(sp)
    80002c18:	7a02                	ld	s4,32(sp)
    80002c1a:	6ae2                	ld	s5,24(sp)
    80002c1c:	6b42                	ld	s6,16(sp)
    80002c1e:	6ba2                	ld	s7,8(sp)
    80002c20:	6161                	addi	sp,sp,80
    80002c22:	8082                	ret

0000000080002c24 <iupdate>:
{
    80002c24:	1101                	addi	sp,sp,-32
    80002c26:	ec06                	sd	ra,24(sp)
    80002c28:	e822                	sd	s0,16(sp)
    80002c2a:	e426                	sd	s1,8(sp)
    80002c2c:	e04a                	sd	s2,0(sp)
    80002c2e:	1000                	addi	s0,sp,32
    80002c30:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c32:	415c                	lw	a5,4(a0)
    80002c34:	0047d79b          	srliw	a5,a5,0x4
    80002c38:	00015597          	auipc	a1,0x15
    80002c3c:	9385a583          	lw	a1,-1736(a1) # 80017570 <sb+0x18>
    80002c40:	9dbd                	addw	a1,a1,a5
    80002c42:	4108                	lw	a0,0(a0)
    80002c44:	00000097          	auipc	ra,0x0
    80002c48:	8a8080e7          	jalr	-1880(ra) # 800024ec <bread>
    80002c4c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c4e:	05850793          	addi	a5,a0,88
    80002c52:	40c8                	lw	a0,4(s1)
    80002c54:	893d                	andi	a0,a0,15
    80002c56:	051a                	slli	a0,a0,0x6
    80002c58:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c5a:	04449703          	lh	a4,68(s1)
    80002c5e:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c62:	04649703          	lh	a4,70(s1)
    80002c66:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c6a:	04849703          	lh	a4,72(s1)
    80002c6e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c72:	04a49703          	lh	a4,74(s1)
    80002c76:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c7a:	44f8                	lw	a4,76(s1)
    80002c7c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c7e:	03400613          	li	a2,52
    80002c82:	05048593          	addi	a1,s1,80
    80002c86:	0531                	addi	a0,a0,12
    80002c88:	ffffd097          	auipc	ra,0xffffd
    80002c8c:	550080e7          	jalr	1360(ra) # 800001d8 <memmove>
  log_write(bp);
    80002c90:	854a                	mv	a0,s2
    80002c92:	00001097          	auipc	ra,0x1
    80002c96:	c06080e7          	jalr	-1018(ra) # 80003898 <log_write>
  brelse(bp);
    80002c9a:	854a                	mv	a0,s2
    80002c9c:	00000097          	auipc	ra,0x0
    80002ca0:	980080e7          	jalr	-1664(ra) # 8000261c <brelse>
}
    80002ca4:	60e2                	ld	ra,24(sp)
    80002ca6:	6442                	ld	s0,16(sp)
    80002ca8:	64a2                	ld	s1,8(sp)
    80002caa:	6902                	ld	s2,0(sp)
    80002cac:	6105                	addi	sp,sp,32
    80002cae:	8082                	ret

0000000080002cb0 <idup>:
{
    80002cb0:	1101                	addi	sp,sp,-32
    80002cb2:	ec06                	sd	ra,24(sp)
    80002cb4:	e822                	sd	s0,16(sp)
    80002cb6:	e426                	sd	s1,8(sp)
    80002cb8:	1000                	addi	s0,sp,32
    80002cba:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cbc:	00015517          	auipc	a0,0x15
    80002cc0:	8bc50513          	addi	a0,a0,-1860 # 80017578 <itable>
    80002cc4:	00003097          	auipc	ra,0x3
    80002cc8:	63e080e7          	jalr	1598(ra) # 80006302 <acquire>
  ip->ref++;
    80002ccc:	449c                	lw	a5,8(s1)
    80002cce:	2785                	addiw	a5,a5,1
    80002cd0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cd2:	00015517          	auipc	a0,0x15
    80002cd6:	8a650513          	addi	a0,a0,-1882 # 80017578 <itable>
    80002cda:	00003097          	auipc	ra,0x3
    80002cde:	6dc080e7          	jalr	1756(ra) # 800063b6 <release>
}
    80002ce2:	8526                	mv	a0,s1
    80002ce4:	60e2                	ld	ra,24(sp)
    80002ce6:	6442                	ld	s0,16(sp)
    80002ce8:	64a2                	ld	s1,8(sp)
    80002cea:	6105                	addi	sp,sp,32
    80002cec:	8082                	ret

0000000080002cee <ilock>:
{
    80002cee:	1101                	addi	sp,sp,-32
    80002cf0:	ec06                	sd	ra,24(sp)
    80002cf2:	e822                	sd	s0,16(sp)
    80002cf4:	e426                	sd	s1,8(sp)
    80002cf6:	e04a                	sd	s2,0(sp)
    80002cf8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002cfa:	c115                	beqz	a0,80002d1e <ilock+0x30>
    80002cfc:	84aa                	mv	s1,a0
    80002cfe:	451c                	lw	a5,8(a0)
    80002d00:	00f05f63          	blez	a5,80002d1e <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d04:	0541                	addi	a0,a0,16
    80002d06:	00001097          	auipc	ra,0x1
    80002d0a:	cb2080e7          	jalr	-846(ra) # 800039b8 <acquiresleep>
  if(ip->valid == 0){
    80002d0e:	40bc                	lw	a5,64(s1)
    80002d10:	cf99                	beqz	a5,80002d2e <ilock+0x40>
}
    80002d12:	60e2                	ld	ra,24(sp)
    80002d14:	6442                	ld	s0,16(sp)
    80002d16:	64a2                	ld	s1,8(sp)
    80002d18:	6902                	ld	s2,0(sp)
    80002d1a:	6105                	addi	sp,sp,32
    80002d1c:	8082                	ret
    panic("ilock");
    80002d1e:	00006517          	auipc	a0,0x6
    80002d22:	8a250513          	addi	a0,a0,-1886 # 800085c0 <syscalls+0x1c8>
    80002d26:	00003097          	auipc	ra,0x3
    80002d2a:	092080e7          	jalr	146(ra) # 80005db8 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d2e:	40dc                	lw	a5,4(s1)
    80002d30:	0047d79b          	srliw	a5,a5,0x4
    80002d34:	00015597          	auipc	a1,0x15
    80002d38:	83c5a583          	lw	a1,-1988(a1) # 80017570 <sb+0x18>
    80002d3c:	9dbd                	addw	a1,a1,a5
    80002d3e:	4088                	lw	a0,0(s1)
    80002d40:	fffff097          	auipc	ra,0xfffff
    80002d44:	7ac080e7          	jalr	1964(ra) # 800024ec <bread>
    80002d48:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d4a:	05850593          	addi	a1,a0,88
    80002d4e:	40dc                	lw	a5,4(s1)
    80002d50:	8bbd                	andi	a5,a5,15
    80002d52:	079a                	slli	a5,a5,0x6
    80002d54:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d56:	00059783          	lh	a5,0(a1)
    80002d5a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d5e:	00259783          	lh	a5,2(a1)
    80002d62:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d66:	00459783          	lh	a5,4(a1)
    80002d6a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d6e:	00659783          	lh	a5,6(a1)
    80002d72:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d76:	459c                	lw	a5,8(a1)
    80002d78:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d7a:	03400613          	li	a2,52
    80002d7e:	05b1                	addi	a1,a1,12
    80002d80:	05048513          	addi	a0,s1,80
    80002d84:	ffffd097          	auipc	ra,0xffffd
    80002d88:	454080e7          	jalr	1108(ra) # 800001d8 <memmove>
    brelse(bp);
    80002d8c:	854a                	mv	a0,s2
    80002d8e:	00000097          	auipc	ra,0x0
    80002d92:	88e080e7          	jalr	-1906(ra) # 8000261c <brelse>
    ip->valid = 1;
    80002d96:	4785                	li	a5,1
    80002d98:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d9a:	04449783          	lh	a5,68(s1)
    80002d9e:	fbb5                	bnez	a5,80002d12 <ilock+0x24>
      panic("ilock: no type");
    80002da0:	00006517          	auipc	a0,0x6
    80002da4:	82850513          	addi	a0,a0,-2008 # 800085c8 <syscalls+0x1d0>
    80002da8:	00003097          	auipc	ra,0x3
    80002dac:	010080e7          	jalr	16(ra) # 80005db8 <panic>

0000000080002db0 <iunlock>:
{
    80002db0:	1101                	addi	sp,sp,-32
    80002db2:	ec06                	sd	ra,24(sp)
    80002db4:	e822                	sd	s0,16(sp)
    80002db6:	e426                	sd	s1,8(sp)
    80002db8:	e04a                	sd	s2,0(sp)
    80002dba:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002dbc:	c905                	beqz	a0,80002dec <iunlock+0x3c>
    80002dbe:	84aa                	mv	s1,a0
    80002dc0:	01050913          	addi	s2,a0,16
    80002dc4:	854a                	mv	a0,s2
    80002dc6:	00001097          	auipc	ra,0x1
    80002dca:	c8c080e7          	jalr	-884(ra) # 80003a52 <holdingsleep>
    80002dce:	cd19                	beqz	a0,80002dec <iunlock+0x3c>
    80002dd0:	449c                	lw	a5,8(s1)
    80002dd2:	00f05d63          	blez	a5,80002dec <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002dd6:	854a                	mv	a0,s2
    80002dd8:	00001097          	auipc	ra,0x1
    80002ddc:	c36080e7          	jalr	-970(ra) # 80003a0e <releasesleep>
}
    80002de0:	60e2                	ld	ra,24(sp)
    80002de2:	6442                	ld	s0,16(sp)
    80002de4:	64a2                	ld	s1,8(sp)
    80002de6:	6902                	ld	s2,0(sp)
    80002de8:	6105                	addi	sp,sp,32
    80002dea:	8082                	ret
    panic("iunlock");
    80002dec:	00005517          	auipc	a0,0x5
    80002df0:	7ec50513          	addi	a0,a0,2028 # 800085d8 <syscalls+0x1e0>
    80002df4:	00003097          	auipc	ra,0x3
    80002df8:	fc4080e7          	jalr	-60(ra) # 80005db8 <panic>

0000000080002dfc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002dfc:	7179                	addi	sp,sp,-48
    80002dfe:	f406                	sd	ra,40(sp)
    80002e00:	f022                	sd	s0,32(sp)
    80002e02:	ec26                	sd	s1,24(sp)
    80002e04:	e84a                	sd	s2,16(sp)
    80002e06:	e44e                	sd	s3,8(sp)
    80002e08:	e052                	sd	s4,0(sp)
    80002e0a:	1800                	addi	s0,sp,48
    80002e0c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e0e:	05050493          	addi	s1,a0,80
    80002e12:	08050913          	addi	s2,a0,128
    80002e16:	a021                	j	80002e1e <itrunc+0x22>
    80002e18:	0491                	addi	s1,s1,4
    80002e1a:	01248d63          	beq	s1,s2,80002e34 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e1e:	408c                	lw	a1,0(s1)
    80002e20:	dde5                	beqz	a1,80002e18 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e22:	0009a503          	lw	a0,0(s3)
    80002e26:	00000097          	auipc	ra,0x0
    80002e2a:	90c080e7          	jalr	-1780(ra) # 80002732 <bfree>
      ip->addrs[i] = 0;
    80002e2e:	0004a023          	sw	zero,0(s1)
    80002e32:	b7dd                	j	80002e18 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e34:	0809a583          	lw	a1,128(s3)
    80002e38:	e185                	bnez	a1,80002e58 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e3a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e3e:	854e                	mv	a0,s3
    80002e40:	00000097          	auipc	ra,0x0
    80002e44:	de4080e7          	jalr	-540(ra) # 80002c24 <iupdate>
}
    80002e48:	70a2                	ld	ra,40(sp)
    80002e4a:	7402                	ld	s0,32(sp)
    80002e4c:	64e2                	ld	s1,24(sp)
    80002e4e:	6942                	ld	s2,16(sp)
    80002e50:	69a2                	ld	s3,8(sp)
    80002e52:	6a02                	ld	s4,0(sp)
    80002e54:	6145                	addi	sp,sp,48
    80002e56:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e58:	0009a503          	lw	a0,0(s3)
    80002e5c:	fffff097          	auipc	ra,0xfffff
    80002e60:	690080e7          	jalr	1680(ra) # 800024ec <bread>
    80002e64:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e66:	05850493          	addi	s1,a0,88
    80002e6a:	45850913          	addi	s2,a0,1112
    80002e6e:	a811                	j	80002e82 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e70:	0009a503          	lw	a0,0(s3)
    80002e74:	00000097          	auipc	ra,0x0
    80002e78:	8be080e7          	jalr	-1858(ra) # 80002732 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e7c:	0491                	addi	s1,s1,4
    80002e7e:	01248563          	beq	s1,s2,80002e88 <itrunc+0x8c>
      if(a[j])
    80002e82:	408c                	lw	a1,0(s1)
    80002e84:	dde5                	beqz	a1,80002e7c <itrunc+0x80>
    80002e86:	b7ed                	j	80002e70 <itrunc+0x74>
    brelse(bp);
    80002e88:	8552                	mv	a0,s4
    80002e8a:	fffff097          	auipc	ra,0xfffff
    80002e8e:	792080e7          	jalr	1938(ra) # 8000261c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e92:	0809a583          	lw	a1,128(s3)
    80002e96:	0009a503          	lw	a0,0(s3)
    80002e9a:	00000097          	auipc	ra,0x0
    80002e9e:	898080e7          	jalr	-1896(ra) # 80002732 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ea2:	0809a023          	sw	zero,128(s3)
    80002ea6:	bf51                	j	80002e3a <itrunc+0x3e>

0000000080002ea8 <iput>:
{
    80002ea8:	1101                	addi	sp,sp,-32
    80002eaa:	ec06                	sd	ra,24(sp)
    80002eac:	e822                	sd	s0,16(sp)
    80002eae:	e426                	sd	s1,8(sp)
    80002eb0:	e04a                	sd	s2,0(sp)
    80002eb2:	1000                	addi	s0,sp,32
    80002eb4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002eb6:	00014517          	auipc	a0,0x14
    80002eba:	6c250513          	addi	a0,a0,1730 # 80017578 <itable>
    80002ebe:	00003097          	auipc	ra,0x3
    80002ec2:	444080e7          	jalr	1092(ra) # 80006302 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ec6:	4498                	lw	a4,8(s1)
    80002ec8:	4785                	li	a5,1
    80002eca:	02f70363          	beq	a4,a5,80002ef0 <iput+0x48>
  ip->ref--;
    80002ece:	449c                	lw	a5,8(s1)
    80002ed0:	37fd                	addiw	a5,a5,-1
    80002ed2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ed4:	00014517          	auipc	a0,0x14
    80002ed8:	6a450513          	addi	a0,a0,1700 # 80017578 <itable>
    80002edc:	00003097          	auipc	ra,0x3
    80002ee0:	4da080e7          	jalr	1242(ra) # 800063b6 <release>
}
    80002ee4:	60e2                	ld	ra,24(sp)
    80002ee6:	6442                	ld	s0,16(sp)
    80002ee8:	64a2                	ld	s1,8(sp)
    80002eea:	6902                	ld	s2,0(sp)
    80002eec:	6105                	addi	sp,sp,32
    80002eee:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ef0:	40bc                	lw	a5,64(s1)
    80002ef2:	dff1                	beqz	a5,80002ece <iput+0x26>
    80002ef4:	04a49783          	lh	a5,74(s1)
    80002ef8:	fbf9                	bnez	a5,80002ece <iput+0x26>
    acquiresleep(&ip->lock);
    80002efa:	01048913          	addi	s2,s1,16
    80002efe:	854a                	mv	a0,s2
    80002f00:	00001097          	auipc	ra,0x1
    80002f04:	ab8080e7          	jalr	-1352(ra) # 800039b8 <acquiresleep>
    release(&itable.lock);
    80002f08:	00014517          	auipc	a0,0x14
    80002f0c:	67050513          	addi	a0,a0,1648 # 80017578 <itable>
    80002f10:	00003097          	auipc	ra,0x3
    80002f14:	4a6080e7          	jalr	1190(ra) # 800063b6 <release>
    itrunc(ip);
    80002f18:	8526                	mv	a0,s1
    80002f1a:	00000097          	auipc	ra,0x0
    80002f1e:	ee2080e7          	jalr	-286(ra) # 80002dfc <itrunc>
    ip->type = 0;
    80002f22:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f26:	8526                	mv	a0,s1
    80002f28:	00000097          	auipc	ra,0x0
    80002f2c:	cfc080e7          	jalr	-772(ra) # 80002c24 <iupdate>
    ip->valid = 0;
    80002f30:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f34:	854a                	mv	a0,s2
    80002f36:	00001097          	auipc	ra,0x1
    80002f3a:	ad8080e7          	jalr	-1320(ra) # 80003a0e <releasesleep>
    acquire(&itable.lock);
    80002f3e:	00014517          	auipc	a0,0x14
    80002f42:	63a50513          	addi	a0,a0,1594 # 80017578 <itable>
    80002f46:	00003097          	auipc	ra,0x3
    80002f4a:	3bc080e7          	jalr	956(ra) # 80006302 <acquire>
    80002f4e:	b741                	j	80002ece <iput+0x26>

0000000080002f50 <iunlockput>:
{
    80002f50:	1101                	addi	sp,sp,-32
    80002f52:	ec06                	sd	ra,24(sp)
    80002f54:	e822                	sd	s0,16(sp)
    80002f56:	e426                	sd	s1,8(sp)
    80002f58:	1000                	addi	s0,sp,32
    80002f5a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f5c:	00000097          	auipc	ra,0x0
    80002f60:	e54080e7          	jalr	-428(ra) # 80002db0 <iunlock>
  iput(ip);
    80002f64:	8526                	mv	a0,s1
    80002f66:	00000097          	auipc	ra,0x0
    80002f6a:	f42080e7          	jalr	-190(ra) # 80002ea8 <iput>
}
    80002f6e:	60e2                	ld	ra,24(sp)
    80002f70:	6442                	ld	s0,16(sp)
    80002f72:	64a2                	ld	s1,8(sp)
    80002f74:	6105                	addi	sp,sp,32
    80002f76:	8082                	ret

0000000080002f78 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f78:	1141                	addi	sp,sp,-16
    80002f7a:	e422                	sd	s0,8(sp)
    80002f7c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f7e:	411c                	lw	a5,0(a0)
    80002f80:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f82:	415c                	lw	a5,4(a0)
    80002f84:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f86:	04451783          	lh	a5,68(a0)
    80002f8a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f8e:	04a51783          	lh	a5,74(a0)
    80002f92:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f96:	04c56783          	lwu	a5,76(a0)
    80002f9a:	e99c                	sd	a5,16(a1)
}
    80002f9c:	6422                	ld	s0,8(sp)
    80002f9e:	0141                	addi	sp,sp,16
    80002fa0:	8082                	ret

0000000080002fa2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fa2:	457c                	lw	a5,76(a0)
    80002fa4:	0ed7e963          	bltu	a5,a3,80003096 <readi+0xf4>
{
    80002fa8:	7159                	addi	sp,sp,-112
    80002faa:	f486                	sd	ra,104(sp)
    80002fac:	f0a2                	sd	s0,96(sp)
    80002fae:	eca6                	sd	s1,88(sp)
    80002fb0:	e8ca                	sd	s2,80(sp)
    80002fb2:	e4ce                	sd	s3,72(sp)
    80002fb4:	e0d2                	sd	s4,64(sp)
    80002fb6:	fc56                	sd	s5,56(sp)
    80002fb8:	f85a                	sd	s6,48(sp)
    80002fba:	f45e                	sd	s7,40(sp)
    80002fbc:	f062                	sd	s8,32(sp)
    80002fbe:	ec66                	sd	s9,24(sp)
    80002fc0:	e86a                	sd	s10,16(sp)
    80002fc2:	e46e                	sd	s11,8(sp)
    80002fc4:	1880                	addi	s0,sp,112
    80002fc6:	8baa                	mv	s7,a0
    80002fc8:	8c2e                	mv	s8,a1
    80002fca:	8ab2                	mv	s5,a2
    80002fcc:	84b6                	mv	s1,a3
    80002fce:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fd0:	9f35                	addw	a4,a4,a3
    return 0;
    80002fd2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002fd4:	0ad76063          	bltu	a4,a3,80003074 <readi+0xd2>
  if(off + n > ip->size)
    80002fd8:	00e7f463          	bgeu	a5,a4,80002fe0 <readi+0x3e>
    n = ip->size - off;
    80002fdc:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fe0:	0a0b0963          	beqz	s6,80003092 <readi+0xf0>
    80002fe4:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fe6:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002fea:	5cfd                	li	s9,-1
    80002fec:	a82d                	j	80003026 <readi+0x84>
    80002fee:	020a1d93          	slli	s11,s4,0x20
    80002ff2:	020ddd93          	srli	s11,s11,0x20
    80002ff6:	05890613          	addi	a2,s2,88
    80002ffa:	86ee                	mv	a3,s11
    80002ffc:	963a                	add	a2,a2,a4
    80002ffe:	85d6                	mv	a1,s5
    80003000:	8562                	mv	a0,s8
    80003002:	fffff097          	auipc	ra,0xfffff
    80003006:	a3e080e7          	jalr	-1474(ra) # 80001a40 <either_copyout>
    8000300a:	05950d63          	beq	a0,s9,80003064 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000300e:	854a                	mv	a0,s2
    80003010:	fffff097          	auipc	ra,0xfffff
    80003014:	60c080e7          	jalr	1548(ra) # 8000261c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003018:	013a09bb          	addw	s3,s4,s3
    8000301c:	009a04bb          	addw	s1,s4,s1
    80003020:	9aee                	add	s5,s5,s11
    80003022:	0569f763          	bgeu	s3,s6,80003070 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003026:	000ba903          	lw	s2,0(s7)
    8000302a:	00a4d59b          	srliw	a1,s1,0xa
    8000302e:	855e                	mv	a0,s7
    80003030:	00000097          	auipc	ra,0x0
    80003034:	8b0080e7          	jalr	-1872(ra) # 800028e0 <bmap>
    80003038:	0005059b          	sext.w	a1,a0
    8000303c:	854a                	mv	a0,s2
    8000303e:	fffff097          	auipc	ra,0xfffff
    80003042:	4ae080e7          	jalr	1198(ra) # 800024ec <bread>
    80003046:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003048:	3ff4f713          	andi	a4,s1,1023
    8000304c:	40ed07bb          	subw	a5,s10,a4
    80003050:	413b06bb          	subw	a3,s6,s3
    80003054:	8a3e                	mv	s4,a5
    80003056:	2781                	sext.w	a5,a5
    80003058:	0006861b          	sext.w	a2,a3
    8000305c:	f8f679e3          	bgeu	a2,a5,80002fee <readi+0x4c>
    80003060:	8a36                	mv	s4,a3
    80003062:	b771                	j	80002fee <readi+0x4c>
      brelse(bp);
    80003064:	854a                	mv	a0,s2
    80003066:	fffff097          	auipc	ra,0xfffff
    8000306a:	5b6080e7          	jalr	1462(ra) # 8000261c <brelse>
      tot = -1;
    8000306e:	59fd                	li	s3,-1
  }
  return tot;
    80003070:	0009851b          	sext.w	a0,s3
}
    80003074:	70a6                	ld	ra,104(sp)
    80003076:	7406                	ld	s0,96(sp)
    80003078:	64e6                	ld	s1,88(sp)
    8000307a:	6946                	ld	s2,80(sp)
    8000307c:	69a6                	ld	s3,72(sp)
    8000307e:	6a06                	ld	s4,64(sp)
    80003080:	7ae2                	ld	s5,56(sp)
    80003082:	7b42                	ld	s6,48(sp)
    80003084:	7ba2                	ld	s7,40(sp)
    80003086:	7c02                	ld	s8,32(sp)
    80003088:	6ce2                	ld	s9,24(sp)
    8000308a:	6d42                	ld	s10,16(sp)
    8000308c:	6da2                	ld	s11,8(sp)
    8000308e:	6165                	addi	sp,sp,112
    80003090:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003092:	89da                	mv	s3,s6
    80003094:	bff1                	j	80003070 <readi+0xce>
    return 0;
    80003096:	4501                	li	a0,0
}
    80003098:	8082                	ret

000000008000309a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000309a:	457c                	lw	a5,76(a0)
    8000309c:	10d7e863          	bltu	a5,a3,800031ac <writei+0x112>
{
    800030a0:	7159                	addi	sp,sp,-112
    800030a2:	f486                	sd	ra,104(sp)
    800030a4:	f0a2                	sd	s0,96(sp)
    800030a6:	eca6                	sd	s1,88(sp)
    800030a8:	e8ca                	sd	s2,80(sp)
    800030aa:	e4ce                	sd	s3,72(sp)
    800030ac:	e0d2                	sd	s4,64(sp)
    800030ae:	fc56                	sd	s5,56(sp)
    800030b0:	f85a                	sd	s6,48(sp)
    800030b2:	f45e                	sd	s7,40(sp)
    800030b4:	f062                	sd	s8,32(sp)
    800030b6:	ec66                	sd	s9,24(sp)
    800030b8:	e86a                	sd	s10,16(sp)
    800030ba:	e46e                	sd	s11,8(sp)
    800030bc:	1880                	addi	s0,sp,112
    800030be:	8b2a                	mv	s6,a0
    800030c0:	8c2e                	mv	s8,a1
    800030c2:	8ab2                	mv	s5,a2
    800030c4:	8936                	mv	s2,a3
    800030c6:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030c8:	00e687bb          	addw	a5,a3,a4
    800030cc:	0ed7e263          	bltu	a5,a3,800031b0 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030d0:	00043737          	lui	a4,0x43
    800030d4:	0ef76063          	bltu	a4,a5,800031b4 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030d8:	0c0b8863          	beqz	s7,800031a8 <writei+0x10e>
    800030dc:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030de:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030e2:	5cfd                	li	s9,-1
    800030e4:	a091                	j	80003128 <writei+0x8e>
    800030e6:	02099d93          	slli	s11,s3,0x20
    800030ea:	020ddd93          	srli	s11,s11,0x20
    800030ee:	05848513          	addi	a0,s1,88
    800030f2:	86ee                	mv	a3,s11
    800030f4:	8656                	mv	a2,s5
    800030f6:	85e2                	mv	a1,s8
    800030f8:	953a                	add	a0,a0,a4
    800030fa:	fffff097          	auipc	ra,0xfffff
    800030fe:	99c080e7          	jalr	-1636(ra) # 80001a96 <either_copyin>
    80003102:	07950263          	beq	a0,s9,80003166 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003106:	8526                	mv	a0,s1
    80003108:	00000097          	auipc	ra,0x0
    8000310c:	790080e7          	jalr	1936(ra) # 80003898 <log_write>
    brelse(bp);
    80003110:	8526                	mv	a0,s1
    80003112:	fffff097          	auipc	ra,0xfffff
    80003116:	50a080e7          	jalr	1290(ra) # 8000261c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000311a:	01498a3b          	addw	s4,s3,s4
    8000311e:	0129893b          	addw	s2,s3,s2
    80003122:	9aee                	add	s5,s5,s11
    80003124:	057a7663          	bgeu	s4,s7,80003170 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003128:	000b2483          	lw	s1,0(s6)
    8000312c:	00a9559b          	srliw	a1,s2,0xa
    80003130:	855a                	mv	a0,s6
    80003132:	fffff097          	auipc	ra,0xfffff
    80003136:	7ae080e7          	jalr	1966(ra) # 800028e0 <bmap>
    8000313a:	0005059b          	sext.w	a1,a0
    8000313e:	8526                	mv	a0,s1
    80003140:	fffff097          	auipc	ra,0xfffff
    80003144:	3ac080e7          	jalr	940(ra) # 800024ec <bread>
    80003148:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000314a:	3ff97713          	andi	a4,s2,1023
    8000314e:	40ed07bb          	subw	a5,s10,a4
    80003152:	414b86bb          	subw	a3,s7,s4
    80003156:	89be                	mv	s3,a5
    80003158:	2781                	sext.w	a5,a5
    8000315a:	0006861b          	sext.w	a2,a3
    8000315e:	f8f674e3          	bgeu	a2,a5,800030e6 <writei+0x4c>
    80003162:	89b6                	mv	s3,a3
    80003164:	b749                	j	800030e6 <writei+0x4c>
      brelse(bp);
    80003166:	8526                	mv	a0,s1
    80003168:	fffff097          	auipc	ra,0xfffff
    8000316c:	4b4080e7          	jalr	1204(ra) # 8000261c <brelse>
  }

  if(off > ip->size)
    80003170:	04cb2783          	lw	a5,76(s6)
    80003174:	0127f463          	bgeu	a5,s2,8000317c <writei+0xe2>
    ip->size = off;
    80003178:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000317c:	855a                	mv	a0,s6
    8000317e:	00000097          	auipc	ra,0x0
    80003182:	aa6080e7          	jalr	-1370(ra) # 80002c24 <iupdate>

  return tot;
    80003186:	000a051b          	sext.w	a0,s4
}
    8000318a:	70a6                	ld	ra,104(sp)
    8000318c:	7406                	ld	s0,96(sp)
    8000318e:	64e6                	ld	s1,88(sp)
    80003190:	6946                	ld	s2,80(sp)
    80003192:	69a6                	ld	s3,72(sp)
    80003194:	6a06                	ld	s4,64(sp)
    80003196:	7ae2                	ld	s5,56(sp)
    80003198:	7b42                	ld	s6,48(sp)
    8000319a:	7ba2                	ld	s7,40(sp)
    8000319c:	7c02                	ld	s8,32(sp)
    8000319e:	6ce2                	ld	s9,24(sp)
    800031a0:	6d42                	ld	s10,16(sp)
    800031a2:	6da2                	ld	s11,8(sp)
    800031a4:	6165                	addi	sp,sp,112
    800031a6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031a8:	8a5e                	mv	s4,s7
    800031aa:	bfc9                	j	8000317c <writei+0xe2>
    return -1;
    800031ac:	557d                	li	a0,-1
}
    800031ae:	8082                	ret
    return -1;
    800031b0:	557d                	li	a0,-1
    800031b2:	bfe1                	j	8000318a <writei+0xf0>
    return -1;
    800031b4:	557d                	li	a0,-1
    800031b6:	bfd1                	j	8000318a <writei+0xf0>

00000000800031b8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031b8:	1141                	addi	sp,sp,-16
    800031ba:	e406                	sd	ra,8(sp)
    800031bc:	e022                	sd	s0,0(sp)
    800031be:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031c0:	4639                	li	a2,14
    800031c2:	ffffd097          	auipc	ra,0xffffd
    800031c6:	08e080e7          	jalr	142(ra) # 80000250 <strncmp>
}
    800031ca:	60a2                	ld	ra,8(sp)
    800031cc:	6402                	ld	s0,0(sp)
    800031ce:	0141                	addi	sp,sp,16
    800031d0:	8082                	ret

00000000800031d2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031d2:	7139                	addi	sp,sp,-64
    800031d4:	fc06                	sd	ra,56(sp)
    800031d6:	f822                	sd	s0,48(sp)
    800031d8:	f426                	sd	s1,40(sp)
    800031da:	f04a                	sd	s2,32(sp)
    800031dc:	ec4e                	sd	s3,24(sp)
    800031de:	e852                	sd	s4,16(sp)
    800031e0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031e2:	04451703          	lh	a4,68(a0)
    800031e6:	4785                	li	a5,1
    800031e8:	00f71a63          	bne	a4,a5,800031fc <dirlookup+0x2a>
    800031ec:	892a                	mv	s2,a0
    800031ee:	89ae                	mv	s3,a1
    800031f0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031f2:	457c                	lw	a5,76(a0)
    800031f4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031f6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031f8:	e79d                	bnez	a5,80003226 <dirlookup+0x54>
    800031fa:	a8a5                	j	80003272 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031fc:	00005517          	auipc	a0,0x5
    80003200:	3e450513          	addi	a0,a0,996 # 800085e0 <syscalls+0x1e8>
    80003204:	00003097          	auipc	ra,0x3
    80003208:	bb4080e7          	jalr	-1100(ra) # 80005db8 <panic>
      panic("dirlookup read");
    8000320c:	00005517          	auipc	a0,0x5
    80003210:	3ec50513          	addi	a0,a0,1004 # 800085f8 <syscalls+0x200>
    80003214:	00003097          	auipc	ra,0x3
    80003218:	ba4080e7          	jalr	-1116(ra) # 80005db8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000321c:	24c1                	addiw	s1,s1,16
    8000321e:	04c92783          	lw	a5,76(s2)
    80003222:	04f4f763          	bgeu	s1,a5,80003270 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003226:	4741                	li	a4,16
    80003228:	86a6                	mv	a3,s1
    8000322a:	fc040613          	addi	a2,s0,-64
    8000322e:	4581                	li	a1,0
    80003230:	854a                	mv	a0,s2
    80003232:	00000097          	auipc	ra,0x0
    80003236:	d70080e7          	jalr	-656(ra) # 80002fa2 <readi>
    8000323a:	47c1                	li	a5,16
    8000323c:	fcf518e3          	bne	a0,a5,8000320c <dirlookup+0x3a>
    if(de.inum == 0)
    80003240:	fc045783          	lhu	a5,-64(s0)
    80003244:	dfe1                	beqz	a5,8000321c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003246:	fc240593          	addi	a1,s0,-62
    8000324a:	854e                	mv	a0,s3
    8000324c:	00000097          	auipc	ra,0x0
    80003250:	f6c080e7          	jalr	-148(ra) # 800031b8 <namecmp>
    80003254:	f561                	bnez	a0,8000321c <dirlookup+0x4a>
      if(poff)
    80003256:	000a0463          	beqz	s4,8000325e <dirlookup+0x8c>
        *poff = off;
    8000325a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000325e:	fc045583          	lhu	a1,-64(s0)
    80003262:	00092503          	lw	a0,0(s2)
    80003266:	fffff097          	auipc	ra,0xfffff
    8000326a:	754080e7          	jalr	1876(ra) # 800029ba <iget>
    8000326e:	a011                	j	80003272 <dirlookup+0xa0>
  return 0;
    80003270:	4501                	li	a0,0
}
    80003272:	70e2                	ld	ra,56(sp)
    80003274:	7442                	ld	s0,48(sp)
    80003276:	74a2                	ld	s1,40(sp)
    80003278:	7902                	ld	s2,32(sp)
    8000327a:	69e2                	ld	s3,24(sp)
    8000327c:	6a42                	ld	s4,16(sp)
    8000327e:	6121                	addi	sp,sp,64
    80003280:	8082                	ret

0000000080003282 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003282:	711d                	addi	sp,sp,-96
    80003284:	ec86                	sd	ra,88(sp)
    80003286:	e8a2                	sd	s0,80(sp)
    80003288:	e4a6                	sd	s1,72(sp)
    8000328a:	e0ca                	sd	s2,64(sp)
    8000328c:	fc4e                	sd	s3,56(sp)
    8000328e:	f852                	sd	s4,48(sp)
    80003290:	f456                	sd	s5,40(sp)
    80003292:	f05a                	sd	s6,32(sp)
    80003294:	ec5e                	sd	s7,24(sp)
    80003296:	e862                	sd	s8,16(sp)
    80003298:	e466                	sd	s9,8(sp)
    8000329a:	1080                	addi	s0,sp,96
    8000329c:	84aa                	mv	s1,a0
    8000329e:	8b2e                	mv	s6,a1
    800032a0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032a2:	00054703          	lbu	a4,0(a0)
    800032a6:	02f00793          	li	a5,47
    800032aa:	02f70363          	beq	a4,a5,800032d0 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032ae:	ffffe097          	auipc	ra,0xffffe
    800032b2:	c7c080e7          	jalr	-900(ra) # 80000f2a <myproc>
    800032b6:	15053503          	ld	a0,336(a0)
    800032ba:	00000097          	auipc	ra,0x0
    800032be:	9f6080e7          	jalr	-1546(ra) # 80002cb0 <idup>
    800032c2:	89aa                	mv	s3,a0
  while(*path == '/')
    800032c4:	02f00913          	li	s2,47
  len = path - s;
    800032c8:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800032ca:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032cc:	4c05                	li	s8,1
    800032ce:	a865                	j	80003386 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800032d0:	4585                	li	a1,1
    800032d2:	4505                	li	a0,1
    800032d4:	fffff097          	auipc	ra,0xfffff
    800032d8:	6e6080e7          	jalr	1766(ra) # 800029ba <iget>
    800032dc:	89aa                	mv	s3,a0
    800032de:	b7dd                	j	800032c4 <namex+0x42>
      iunlockput(ip);
    800032e0:	854e                	mv	a0,s3
    800032e2:	00000097          	auipc	ra,0x0
    800032e6:	c6e080e7          	jalr	-914(ra) # 80002f50 <iunlockput>
      return 0;
    800032ea:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032ec:	854e                	mv	a0,s3
    800032ee:	60e6                	ld	ra,88(sp)
    800032f0:	6446                	ld	s0,80(sp)
    800032f2:	64a6                	ld	s1,72(sp)
    800032f4:	6906                	ld	s2,64(sp)
    800032f6:	79e2                	ld	s3,56(sp)
    800032f8:	7a42                	ld	s4,48(sp)
    800032fa:	7aa2                	ld	s5,40(sp)
    800032fc:	7b02                	ld	s6,32(sp)
    800032fe:	6be2                	ld	s7,24(sp)
    80003300:	6c42                	ld	s8,16(sp)
    80003302:	6ca2                	ld	s9,8(sp)
    80003304:	6125                	addi	sp,sp,96
    80003306:	8082                	ret
      iunlock(ip);
    80003308:	854e                	mv	a0,s3
    8000330a:	00000097          	auipc	ra,0x0
    8000330e:	aa6080e7          	jalr	-1370(ra) # 80002db0 <iunlock>
      return ip;
    80003312:	bfe9                	j	800032ec <namex+0x6a>
      iunlockput(ip);
    80003314:	854e                	mv	a0,s3
    80003316:	00000097          	auipc	ra,0x0
    8000331a:	c3a080e7          	jalr	-966(ra) # 80002f50 <iunlockput>
      return 0;
    8000331e:	89d2                	mv	s3,s4
    80003320:	b7f1                	j	800032ec <namex+0x6a>
  len = path - s;
    80003322:	40b48633          	sub	a2,s1,a1
    80003326:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000332a:	094cd463          	bge	s9,s4,800033b2 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000332e:	4639                	li	a2,14
    80003330:	8556                	mv	a0,s5
    80003332:	ffffd097          	auipc	ra,0xffffd
    80003336:	ea6080e7          	jalr	-346(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000333a:	0004c783          	lbu	a5,0(s1)
    8000333e:	01279763          	bne	a5,s2,8000334c <namex+0xca>
    path++;
    80003342:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003344:	0004c783          	lbu	a5,0(s1)
    80003348:	ff278de3          	beq	a5,s2,80003342 <namex+0xc0>
    ilock(ip);
    8000334c:	854e                	mv	a0,s3
    8000334e:	00000097          	auipc	ra,0x0
    80003352:	9a0080e7          	jalr	-1632(ra) # 80002cee <ilock>
    if(ip->type != T_DIR){
    80003356:	04499783          	lh	a5,68(s3)
    8000335a:	f98793e3          	bne	a5,s8,800032e0 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000335e:	000b0563          	beqz	s6,80003368 <namex+0xe6>
    80003362:	0004c783          	lbu	a5,0(s1)
    80003366:	d3cd                	beqz	a5,80003308 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003368:	865e                	mv	a2,s7
    8000336a:	85d6                	mv	a1,s5
    8000336c:	854e                	mv	a0,s3
    8000336e:	00000097          	auipc	ra,0x0
    80003372:	e64080e7          	jalr	-412(ra) # 800031d2 <dirlookup>
    80003376:	8a2a                	mv	s4,a0
    80003378:	dd51                	beqz	a0,80003314 <namex+0x92>
    iunlockput(ip);
    8000337a:	854e                	mv	a0,s3
    8000337c:	00000097          	auipc	ra,0x0
    80003380:	bd4080e7          	jalr	-1068(ra) # 80002f50 <iunlockput>
    ip = next;
    80003384:	89d2                	mv	s3,s4
  while(*path == '/')
    80003386:	0004c783          	lbu	a5,0(s1)
    8000338a:	05279763          	bne	a5,s2,800033d8 <namex+0x156>
    path++;
    8000338e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003390:	0004c783          	lbu	a5,0(s1)
    80003394:	ff278de3          	beq	a5,s2,8000338e <namex+0x10c>
  if(*path == 0)
    80003398:	c79d                	beqz	a5,800033c6 <namex+0x144>
    path++;
    8000339a:	85a6                	mv	a1,s1
  len = path - s;
    8000339c:	8a5e                	mv	s4,s7
    8000339e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033a0:	01278963          	beq	a5,s2,800033b2 <namex+0x130>
    800033a4:	dfbd                	beqz	a5,80003322 <namex+0xa0>
    path++;
    800033a6:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800033a8:	0004c783          	lbu	a5,0(s1)
    800033ac:	ff279ce3          	bne	a5,s2,800033a4 <namex+0x122>
    800033b0:	bf8d                	j	80003322 <namex+0xa0>
    memmove(name, s, len);
    800033b2:	2601                	sext.w	a2,a2
    800033b4:	8556                	mv	a0,s5
    800033b6:	ffffd097          	auipc	ra,0xffffd
    800033ba:	e22080e7          	jalr	-478(ra) # 800001d8 <memmove>
    name[len] = 0;
    800033be:	9a56                	add	s4,s4,s5
    800033c0:	000a0023          	sb	zero,0(s4)
    800033c4:	bf9d                	j	8000333a <namex+0xb8>
  if(nameiparent){
    800033c6:	f20b03e3          	beqz	s6,800032ec <namex+0x6a>
    iput(ip);
    800033ca:	854e                	mv	a0,s3
    800033cc:	00000097          	auipc	ra,0x0
    800033d0:	adc080e7          	jalr	-1316(ra) # 80002ea8 <iput>
    return 0;
    800033d4:	4981                	li	s3,0
    800033d6:	bf19                	j	800032ec <namex+0x6a>
  if(*path == 0)
    800033d8:	d7fd                	beqz	a5,800033c6 <namex+0x144>
  while(*path != '/' && *path != 0)
    800033da:	0004c783          	lbu	a5,0(s1)
    800033de:	85a6                	mv	a1,s1
    800033e0:	b7d1                	j	800033a4 <namex+0x122>

00000000800033e2 <dirlink>:
{
    800033e2:	7139                	addi	sp,sp,-64
    800033e4:	fc06                	sd	ra,56(sp)
    800033e6:	f822                	sd	s0,48(sp)
    800033e8:	f426                	sd	s1,40(sp)
    800033ea:	f04a                	sd	s2,32(sp)
    800033ec:	ec4e                	sd	s3,24(sp)
    800033ee:	e852                	sd	s4,16(sp)
    800033f0:	0080                	addi	s0,sp,64
    800033f2:	892a                	mv	s2,a0
    800033f4:	8a2e                	mv	s4,a1
    800033f6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033f8:	4601                	li	a2,0
    800033fa:	00000097          	auipc	ra,0x0
    800033fe:	dd8080e7          	jalr	-552(ra) # 800031d2 <dirlookup>
    80003402:	e93d                	bnez	a0,80003478 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003404:	04c92483          	lw	s1,76(s2)
    80003408:	c49d                	beqz	s1,80003436 <dirlink+0x54>
    8000340a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000340c:	4741                	li	a4,16
    8000340e:	86a6                	mv	a3,s1
    80003410:	fc040613          	addi	a2,s0,-64
    80003414:	4581                	li	a1,0
    80003416:	854a                	mv	a0,s2
    80003418:	00000097          	auipc	ra,0x0
    8000341c:	b8a080e7          	jalr	-1142(ra) # 80002fa2 <readi>
    80003420:	47c1                	li	a5,16
    80003422:	06f51163          	bne	a0,a5,80003484 <dirlink+0xa2>
    if(de.inum == 0)
    80003426:	fc045783          	lhu	a5,-64(s0)
    8000342a:	c791                	beqz	a5,80003436 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000342c:	24c1                	addiw	s1,s1,16
    8000342e:	04c92783          	lw	a5,76(s2)
    80003432:	fcf4ede3          	bltu	s1,a5,8000340c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003436:	4639                	li	a2,14
    80003438:	85d2                	mv	a1,s4
    8000343a:	fc240513          	addi	a0,s0,-62
    8000343e:	ffffd097          	auipc	ra,0xffffd
    80003442:	e4e080e7          	jalr	-434(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003446:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000344a:	4741                	li	a4,16
    8000344c:	86a6                	mv	a3,s1
    8000344e:	fc040613          	addi	a2,s0,-64
    80003452:	4581                	li	a1,0
    80003454:	854a                	mv	a0,s2
    80003456:	00000097          	auipc	ra,0x0
    8000345a:	c44080e7          	jalr	-956(ra) # 8000309a <writei>
    8000345e:	872a                	mv	a4,a0
    80003460:	47c1                	li	a5,16
  return 0;
    80003462:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003464:	02f71863          	bne	a4,a5,80003494 <dirlink+0xb2>
}
    80003468:	70e2                	ld	ra,56(sp)
    8000346a:	7442                	ld	s0,48(sp)
    8000346c:	74a2                	ld	s1,40(sp)
    8000346e:	7902                	ld	s2,32(sp)
    80003470:	69e2                	ld	s3,24(sp)
    80003472:	6a42                	ld	s4,16(sp)
    80003474:	6121                	addi	sp,sp,64
    80003476:	8082                	ret
    iput(ip);
    80003478:	00000097          	auipc	ra,0x0
    8000347c:	a30080e7          	jalr	-1488(ra) # 80002ea8 <iput>
    return -1;
    80003480:	557d                	li	a0,-1
    80003482:	b7dd                	j	80003468 <dirlink+0x86>
      panic("dirlink read");
    80003484:	00005517          	auipc	a0,0x5
    80003488:	18450513          	addi	a0,a0,388 # 80008608 <syscalls+0x210>
    8000348c:	00003097          	auipc	ra,0x3
    80003490:	92c080e7          	jalr	-1748(ra) # 80005db8 <panic>
    panic("dirlink");
    80003494:	00005517          	auipc	a0,0x5
    80003498:	28450513          	addi	a0,a0,644 # 80008718 <syscalls+0x320>
    8000349c:	00003097          	auipc	ra,0x3
    800034a0:	91c080e7          	jalr	-1764(ra) # 80005db8 <panic>

00000000800034a4 <namei>:

struct inode*
namei(char *path)
{
    800034a4:	1101                	addi	sp,sp,-32
    800034a6:	ec06                	sd	ra,24(sp)
    800034a8:	e822                	sd	s0,16(sp)
    800034aa:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034ac:	fe040613          	addi	a2,s0,-32
    800034b0:	4581                	li	a1,0
    800034b2:	00000097          	auipc	ra,0x0
    800034b6:	dd0080e7          	jalr	-560(ra) # 80003282 <namex>
}
    800034ba:	60e2                	ld	ra,24(sp)
    800034bc:	6442                	ld	s0,16(sp)
    800034be:	6105                	addi	sp,sp,32
    800034c0:	8082                	ret

00000000800034c2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034c2:	1141                	addi	sp,sp,-16
    800034c4:	e406                	sd	ra,8(sp)
    800034c6:	e022                	sd	s0,0(sp)
    800034c8:	0800                	addi	s0,sp,16
    800034ca:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034cc:	4585                	li	a1,1
    800034ce:	00000097          	auipc	ra,0x0
    800034d2:	db4080e7          	jalr	-588(ra) # 80003282 <namex>
}
    800034d6:	60a2                	ld	ra,8(sp)
    800034d8:	6402                	ld	s0,0(sp)
    800034da:	0141                	addi	sp,sp,16
    800034dc:	8082                	ret

00000000800034de <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034de:	1101                	addi	sp,sp,-32
    800034e0:	ec06                	sd	ra,24(sp)
    800034e2:	e822                	sd	s0,16(sp)
    800034e4:	e426                	sd	s1,8(sp)
    800034e6:	e04a                	sd	s2,0(sp)
    800034e8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034ea:	00016917          	auipc	s2,0x16
    800034ee:	b3690913          	addi	s2,s2,-1226 # 80019020 <log>
    800034f2:	01892583          	lw	a1,24(s2)
    800034f6:	02892503          	lw	a0,40(s2)
    800034fa:	fffff097          	auipc	ra,0xfffff
    800034fe:	ff2080e7          	jalr	-14(ra) # 800024ec <bread>
    80003502:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003504:	02c92683          	lw	a3,44(s2)
    80003508:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000350a:	02d05763          	blez	a3,80003538 <write_head+0x5a>
    8000350e:	00016797          	auipc	a5,0x16
    80003512:	b4278793          	addi	a5,a5,-1214 # 80019050 <log+0x30>
    80003516:	05c50713          	addi	a4,a0,92
    8000351a:	36fd                	addiw	a3,a3,-1
    8000351c:	1682                	slli	a3,a3,0x20
    8000351e:	9281                	srli	a3,a3,0x20
    80003520:	068a                	slli	a3,a3,0x2
    80003522:	00016617          	auipc	a2,0x16
    80003526:	b3260613          	addi	a2,a2,-1230 # 80019054 <log+0x34>
    8000352a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000352c:	4390                	lw	a2,0(a5)
    8000352e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003530:	0791                	addi	a5,a5,4
    80003532:	0711                	addi	a4,a4,4
    80003534:	fed79ce3          	bne	a5,a3,8000352c <write_head+0x4e>
  }
  bwrite(buf);
    80003538:	8526                	mv	a0,s1
    8000353a:	fffff097          	auipc	ra,0xfffff
    8000353e:	0a4080e7          	jalr	164(ra) # 800025de <bwrite>
  brelse(buf);
    80003542:	8526                	mv	a0,s1
    80003544:	fffff097          	auipc	ra,0xfffff
    80003548:	0d8080e7          	jalr	216(ra) # 8000261c <brelse>
}
    8000354c:	60e2                	ld	ra,24(sp)
    8000354e:	6442                	ld	s0,16(sp)
    80003550:	64a2                	ld	s1,8(sp)
    80003552:	6902                	ld	s2,0(sp)
    80003554:	6105                	addi	sp,sp,32
    80003556:	8082                	ret

0000000080003558 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003558:	00016797          	auipc	a5,0x16
    8000355c:	af47a783          	lw	a5,-1292(a5) # 8001904c <log+0x2c>
    80003560:	0af05d63          	blez	a5,8000361a <install_trans+0xc2>
{
    80003564:	7139                	addi	sp,sp,-64
    80003566:	fc06                	sd	ra,56(sp)
    80003568:	f822                	sd	s0,48(sp)
    8000356a:	f426                	sd	s1,40(sp)
    8000356c:	f04a                	sd	s2,32(sp)
    8000356e:	ec4e                	sd	s3,24(sp)
    80003570:	e852                	sd	s4,16(sp)
    80003572:	e456                	sd	s5,8(sp)
    80003574:	e05a                	sd	s6,0(sp)
    80003576:	0080                	addi	s0,sp,64
    80003578:	8b2a                	mv	s6,a0
    8000357a:	00016a97          	auipc	s5,0x16
    8000357e:	ad6a8a93          	addi	s5,s5,-1322 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003582:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003584:	00016997          	auipc	s3,0x16
    80003588:	a9c98993          	addi	s3,s3,-1380 # 80019020 <log>
    8000358c:	a035                	j	800035b8 <install_trans+0x60>
      bunpin(dbuf);
    8000358e:	8526                	mv	a0,s1
    80003590:	fffff097          	auipc	ra,0xfffff
    80003594:	166080e7          	jalr	358(ra) # 800026f6 <bunpin>
    brelse(lbuf);
    80003598:	854a                	mv	a0,s2
    8000359a:	fffff097          	auipc	ra,0xfffff
    8000359e:	082080e7          	jalr	130(ra) # 8000261c <brelse>
    brelse(dbuf);
    800035a2:	8526                	mv	a0,s1
    800035a4:	fffff097          	auipc	ra,0xfffff
    800035a8:	078080e7          	jalr	120(ra) # 8000261c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035ac:	2a05                	addiw	s4,s4,1
    800035ae:	0a91                	addi	s5,s5,4
    800035b0:	02c9a783          	lw	a5,44(s3)
    800035b4:	04fa5963          	bge	s4,a5,80003606 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035b8:	0189a583          	lw	a1,24(s3)
    800035bc:	014585bb          	addw	a1,a1,s4
    800035c0:	2585                	addiw	a1,a1,1
    800035c2:	0289a503          	lw	a0,40(s3)
    800035c6:	fffff097          	auipc	ra,0xfffff
    800035ca:	f26080e7          	jalr	-218(ra) # 800024ec <bread>
    800035ce:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035d0:	000aa583          	lw	a1,0(s5)
    800035d4:	0289a503          	lw	a0,40(s3)
    800035d8:	fffff097          	auipc	ra,0xfffff
    800035dc:	f14080e7          	jalr	-236(ra) # 800024ec <bread>
    800035e0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035e2:	40000613          	li	a2,1024
    800035e6:	05890593          	addi	a1,s2,88
    800035ea:	05850513          	addi	a0,a0,88
    800035ee:	ffffd097          	auipc	ra,0xffffd
    800035f2:	bea080e7          	jalr	-1046(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800035f6:	8526                	mv	a0,s1
    800035f8:	fffff097          	auipc	ra,0xfffff
    800035fc:	fe6080e7          	jalr	-26(ra) # 800025de <bwrite>
    if(recovering == 0)
    80003600:	f80b1ce3          	bnez	s6,80003598 <install_trans+0x40>
    80003604:	b769                	j	8000358e <install_trans+0x36>
}
    80003606:	70e2                	ld	ra,56(sp)
    80003608:	7442                	ld	s0,48(sp)
    8000360a:	74a2                	ld	s1,40(sp)
    8000360c:	7902                	ld	s2,32(sp)
    8000360e:	69e2                	ld	s3,24(sp)
    80003610:	6a42                	ld	s4,16(sp)
    80003612:	6aa2                	ld	s5,8(sp)
    80003614:	6b02                	ld	s6,0(sp)
    80003616:	6121                	addi	sp,sp,64
    80003618:	8082                	ret
    8000361a:	8082                	ret

000000008000361c <initlog>:
{
    8000361c:	7179                	addi	sp,sp,-48
    8000361e:	f406                	sd	ra,40(sp)
    80003620:	f022                	sd	s0,32(sp)
    80003622:	ec26                	sd	s1,24(sp)
    80003624:	e84a                	sd	s2,16(sp)
    80003626:	e44e                	sd	s3,8(sp)
    80003628:	1800                	addi	s0,sp,48
    8000362a:	892a                	mv	s2,a0
    8000362c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000362e:	00016497          	auipc	s1,0x16
    80003632:	9f248493          	addi	s1,s1,-1550 # 80019020 <log>
    80003636:	00005597          	auipc	a1,0x5
    8000363a:	fe258593          	addi	a1,a1,-30 # 80008618 <syscalls+0x220>
    8000363e:	8526                	mv	a0,s1
    80003640:	00003097          	auipc	ra,0x3
    80003644:	c32080e7          	jalr	-974(ra) # 80006272 <initlock>
  log.start = sb->logstart;
    80003648:	0149a583          	lw	a1,20(s3)
    8000364c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000364e:	0109a783          	lw	a5,16(s3)
    80003652:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003654:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003658:	854a                	mv	a0,s2
    8000365a:	fffff097          	auipc	ra,0xfffff
    8000365e:	e92080e7          	jalr	-366(ra) # 800024ec <bread>
  log.lh.n = lh->n;
    80003662:	4d3c                	lw	a5,88(a0)
    80003664:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003666:	02f05563          	blez	a5,80003690 <initlog+0x74>
    8000366a:	05c50713          	addi	a4,a0,92
    8000366e:	00016697          	auipc	a3,0x16
    80003672:	9e268693          	addi	a3,a3,-1566 # 80019050 <log+0x30>
    80003676:	37fd                	addiw	a5,a5,-1
    80003678:	1782                	slli	a5,a5,0x20
    8000367a:	9381                	srli	a5,a5,0x20
    8000367c:	078a                	slli	a5,a5,0x2
    8000367e:	06050613          	addi	a2,a0,96
    80003682:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003684:	4310                	lw	a2,0(a4)
    80003686:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003688:	0711                	addi	a4,a4,4
    8000368a:	0691                	addi	a3,a3,4
    8000368c:	fef71ce3          	bne	a4,a5,80003684 <initlog+0x68>
  brelse(buf);
    80003690:	fffff097          	auipc	ra,0xfffff
    80003694:	f8c080e7          	jalr	-116(ra) # 8000261c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003698:	4505                	li	a0,1
    8000369a:	00000097          	auipc	ra,0x0
    8000369e:	ebe080e7          	jalr	-322(ra) # 80003558 <install_trans>
  log.lh.n = 0;
    800036a2:	00016797          	auipc	a5,0x16
    800036a6:	9a07a523          	sw	zero,-1622(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    800036aa:	00000097          	auipc	ra,0x0
    800036ae:	e34080e7          	jalr	-460(ra) # 800034de <write_head>
}
    800036b2:	70a2                	ld	ra,40(sp)
    800036b4:	7402                	ld	s0,32(sp)
    800036b6:	64e2                	ld	s1,24(sp)
    800036b8:	6942                	ld	s2,16(sp)
    800036ba:	69a2                	ld	s3,8(sp)
    800036bc:	6145                	addi	sp,sp,48
    800036be:	8082                	ret

00000000800036c0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036c0:	1101                	addi	sp,sp,-32
    800036c2:	ec06                	sd	ra,24(sp)
    800036c4:	e822                	sd	s0,16(sp)
    800036c6:	e426                	sd	s1,8(sp)
    800036c8:	e04a                	sd	s2,0(sp)
    800036ca:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036cc:	00016517          	auipc	a0,0x16
    800036d0:	95450513          	addi	a0,a0,-1708 # 80019020 <log>
    800036d4:	00003097          	auipc	ra,0x3
    800036d8:	c2e080e7          	jalr	-978(ra) # 80006302 <acquire>
  while(1){
    if(log.committing){
    800036dc:	00016497          	auipc	s1,0x16
    800036e0:	94448493          	addi	s1,s1,-1724 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036e4:	4979                	li	s2,30
    800036e6:	a039                	j	800036f4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800036e8:	85a6                	mv	a1,s1
    800036ea:	8526                	mv	a0,s1
    800036ec:	ffffe097          	auipc	ra,0xffffe
    800036f0:	fb0080e7          	jalr	-80(ra) # 8000169c <sleep>
    if(log.committing){
    800036f4:	50dc                	lw	a5,36(s1)
    800036f6:	fbed                	bnez	a5,800036e8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036f8:	509c                	lw	a5,32(s1)
    800036fa:	0017871b          	addiw	a4,a5,1
    800036fe:	0007069b          	sext.w	a3,a4
    80003702:	0027179b          	slliw	a5,a4,0x2
    80003706:	9fb9                	addw	a5,a5,a4
    80003708:	0017979b          	slliw	a5,a5,0x1
    8000370c:	54d8                	lw	a4,44(s1)
    8000370e:	9fb9                	addw	a5,a5,a4
    80003710:	00f95963          	bge	s2,a5,80003722 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003714:	85a6                	mv	a1,s1
    80003716:	8526                	mv	a0,s1
    80003718:	ffffe097          	auipc	ra,0xffffe
    8000371c:	f84080e7          	jalr	-124(ra) # 8000169c <sleep>
    80003720:	bfd1                	j	800036f4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003722:	00016517          	auipc	a0,0x16
    80003726:	8fe50513          	addi	a0,a0,-1794 # 80019020 <log>
    8000372a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000372c:	00003097          	auipc	ra,0x3
    80003730:	c8a080e7          	jalr	-886(ra) # 800063b6 <release>
      break;
    }
  }
}
    80003734:	60e2                	ld	ra,24(sp)
    80003736:	6442                	ld	s0,16(sp)
    80003738:	64a2                	ld	s1,8(sp)
    8000373a:	6902                	ld	s2,0(sp)
    8000373c:	6105                	addi	sp,sp,32
    8000373e:	8082                	ret

0000000080003740 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003740:	7139                	addi	sp,sp,-64
    80003742:	fc06                	sd	ra,56(sp)
    80003744:	f822                	sd	s0,48(sp)
    80003746:	f426                	sd	s1,40(sp)
    80003748:	f04a                	sd	s2,32(sp)
    8000374a:	ec4e                	sd	s3,24(sp)
    8000374c:	e852                	sd	s4,16(sp)
    8000374e:	e456                	sd	s5,8(sp)
    80003750:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003752:	00016497          	auipc	s1,0x16
    80003756:	8ce48493          	addi	s1,s1,-1842 # 80019020 <log>
    8000375a:	8526                	mv	a0,s1
    8000375c:	00003097          	auipc	ra,0x3
    80003760:	ba6080e7          	jalr	-1114(ra) # 80006302 <acquire>
  log.outstanding -= 1;
    80003764:	509c                	lw	a5,32(s1)
    80003766:	37fd                	addiw	a5,a5,-1
    80003768:	0007891b          	sext.w	s2,a5
    8000376c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000376e:	50dc                	lw	a5,36(s1)
    80003770:	efb9                	bnez	a5,800037ce <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003772:	06091663          	bnez	s2,800037de <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003776:	00016497          	auipc	s1,0x16
    8000377a:	8aa48493          	addi	s1,s1,-1878 # 80019020 <log>
    8000377e:	4785                	li	a5,1
    80003780:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003782:	8526                	mv	a0,s1
    80003784:	00003097          	auipc	ra,0x3
    80003788:	c32080e7          	jalr	-974(ra) # 800063b6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000378c:	54dc                	lw	a5,44(s1)
    8000378e:	06f04763          	bgtz	a5,800037fc <end_op+0xbc>
    acquire(&log.lock);
    80003792:	00016497          	auipc	s1,0x16
    80003796:	88e48493          	addi	s1,s1,-1906 # 80019020 <log>
    8000379a:	8526                	mv	a0,s1
    8000379c:	00003097          	auipc	ra,0x3
    800037a0:	b66080e7          	jalr	-1178(ra) # 80006302 <acquire>
    log.committing = 0;
    800037a4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037a8:	8526                	mv	a0,s1
    800037aa:	ffffe097          	auipc	ra,0xffffe
    800037ae:	07e080e7          	jalr	126(ra) # 80001828 <wakeup>
    release(&log.lock);
    800037b2:	8526                	mv	a0,s1
    800037b4:	00003097          	auipc	ra,0x3
    800037b8:	c02080e7          	jalr	-1022(ra) # 800063b6 <release>
}
    800037bc:	70e2                	ld	ra,56(sp)
    800037be:	7442                	ld	s0,48(sp)
    800037c0:	74a2                	ld	s1,40(sp)
    800037c2:	7902                	ld	s2,32(sp)
    800037c4:	69e2                	ld	s3,24(sp)
    800037c6:	6a42                	ld	s4,16(sp)
    800037c8:	6aa2                	ld	s5,8(sp)
    800037ca:	6121                	addi	sp,sp,64
    800037cc:	8082                	ret
    panic("log.committing");
    800037ce:	00005517          	auipc	a0,0x5
    800037d2:	e5250513          	addi	a0,a0,-430 # 80008620 <syscalls+0x228>
    800037d6:	00002097          	auipc	ra,0x2
    800037da:	5e2080e7          	jalr	1506(ra) # 80005db8 <panic>
    wakeup(&log);
    800037de:	00016497          	auipc	s1,0x16
    800037e2:	84248493          	addi	s1,s1,-1982 # 80019020 <log>
    800037e6:	8526                	mv	a0,s1
    800037e8:	ffffe097          	auipc	ra,0xffffe
    800037ec:	040080e7          	jalr	64(ra) # 80001828 <wakeup>
  release(&log.lock);
    800037f0:	8526                	mv	a0,s1
    800037f2:	00003097          	auipc	ra,0x3
    800037f6:	bc4080e7          	jalr	-1084(ra) # 800063b6 <release>
  if(do_commit){
    800037fa:	b7c9                	j	800037bc <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037fc:	00016a97          	auipc	s5,0x16
    80003800:	854a8a93          	addi	s5,s5,-1964 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003804:	00016a17          	auipc	s4,0x16
    80003808:	81ca0a13          	addi	s4,s4,-2020 # 80019020 <log>
    8000380c:	018a2583          	lw	a1,24(s4)
    80003810:	012585bb          	addw	a1,a1,s2
    80003814:	2585                	addiw	a1,a1,1
    80003816:	028a2503          	lw	a0,40(s4)
    8000381a:	fffff097          	auipc	ra,0xfffff
    8000381e:	cd2080e7          	jalr	-814(ra) # 800024ec <bread>
    80003822:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003824:	000aa583          	lw	a1,0(s5)
    80003828:	028a2503          	lw	a0,40(s4)
    8000382c:	fffff097          	auipc	ra,0xfffff
    80003830:	cc0080e7          	jalr	-832(ra) # 800024ec <bread>
    80003834:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003836:	40000613          	li	a2,1024
    8000383a:	05850593          	addi	a1,a0,88
    8000383e:	05848513          	addi	a0,s1,88
    80003842:	ffffd097          	auipc	ra,0xffffd
    80003846:	996080e7          	jalr	-1642(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    8000384a:	8526                	mv	a0,s1
    8000384c:	fffff097          	auipc	ra,0xfffff
    80003850:	d92080e7          	jalr	-622(ra) # 800025de <bwrite>
    brelse(from);
    80003854:	854e                	mv	a0,s3
    80003856:	fffff097          	auipc	ra,0xfffff
    8000385a:	dc6080e7          	jalr	-570(ra) # 8000261c <brelse>
    brelse(to);
    8000385e:	8526                	mv	a0,s1
    80003860:	fffff097          	auipc	ra,0xfffff
    80003864:	dbc080e7          	jalr	-580(ra) # 8000261c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003868:	2905                	addiw	s2,s2,1
    8000386a:	0a91                	addi	s5,s5,4
    8000386c:	02ca2783          	lw	a5,44(s4)
    80003870:	f8f94ee3          	blt	s2,a5,8000380c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003874:	00000097          	auipc	ra,0x0
    80003878:	c6a080e7          	jalr	-918(ra) # 800034de <write_head>
    install_trans(0); // Now install writes to home locations
    8000387c:	4501                	li	a0,0
    8000387e:	00000097          	auipc	ra,0x0
    80003882:	cda080e7          	jalr	-806(ra) # 80003558 <install_trans>
    log.lh.n = 0;
    80003886:	00015797          	auipc	a5,0x15
    8000388a:	7c07a323          	sw	zero,1990(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000388e:	00000097          	auipc	ra,0x0
    80003892:	c50080e7          	jalr	-944(ra) # 800034de <write_head>
    80003896:	bdf5                	j	80003792 <end_op+0x52>

0000000080003898 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003898:	1101                	addi	sp,sp,-32
    8000389a:	ec06                	sd	ra,24(sp)
    8000389c:	e822                	sd	s0,16(sp)
    8000389e:	e426                	sd	s1,8(sp)
    800038a0:	e04a                	sd	s2,0(sp)
    800038a2:	1000                	addi	s0,sp,32
    800038a4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038a6:	00015917          	auipc	s2,0x15
    800038aa:	77a90913          	addi	s2,s2,1914 # 80019020 <log>
    800038ae:	854a                	mv	a0,s2
    800038b0:	00003097          	auipc	ra,0x3
    800038b4:	a52080e7          	jalr	-1454(ra) # 80006302 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038b8:	02c92603          	lw	a2,44(s2)
    800038bc:	47f5                	li	a5,29
    800038be:	06c7c563          	blt	a5,a2,80003928 <log_write+0x90>
    800038c2:	00015797          	auipc	a5,0x15
    800038c6:	77a7a783          	lw	a5,1914(a5) # 8001903c <log+0x1c>
    800038ca:	37fd                	addiw	a5,a5,-1
    800038cc:	04f65e63          	bge	a2,a5,80003928 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038d0:	00015797          	auipc	a5,0x15
    800038d4:	7707a783          	lw	a5,1904(a5) # 80019040 <log+0x20>
    800038d8:	06f05063          	blez	a5,80003938 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038dc:	4781                	li	a5,0
    800038de:	06c05563          	blez	a2,80003948 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038e2:	44cc                	lw	a1,12(s1)
    800038e4:	00015717          	auipc	a4,0x15
    800038e8:	76c70713          	addi	a4,a4,1900 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038ec:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038ee:	4314                	lw	a3,0(a4)
    800038f0:	04b68c63          	beq	a3,a1,80003948 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038f4:	2785                	addiw	a5,a5,1
    800038f6:	0711                	addi	a4,a4,4
    800038f8:	fef61be3          	bne	a2,a5,800038ee <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038fc:	0621                	addi	a2,a2,8
    800038fe:	060a                	slli	a2,a2,0x2
    80003900:	00015797          	auipc	a5,0x15
    80003904:	72078793          	addi	a5,a5,1824 # 80019020 <log>
    80003908:	963e                	add	a2,a2,a5
    8000390a:	44dc                	lw	a5,12(s1)
    8000390c:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000390e:	8526                	mv	a0,s1
    80003910:	fffff097          	auipc	ra,0xfffff
    80003914:	daa080e7          	jalr	-598(ra) # 800026ba <bpin>
    log.lh.n++;
    80003918:	00015717          	auipc	a4,0x15
    8000391c:	70870713          	addi	a4,a4,1800 # 80019020 <log>
    80003920:	575c                	lw	a5,44(a4)
    80003922:	2785                	addiw	a5,a5,1
    80003924:	d75c                	sw	a5,44(a4)
    80003926:	a835                	j	80003962 <log_write+0xca>
    panic("too big a transaction");
    80003928:	00005517          	auipc	a0,0x5
    8000392c:	d0850513          	addi	a0,a0,-760 # 80008630 <syscalls+0x238>
    80003930:	00002097          	auipc	ra,0x2
    80003934:	488080e7          	jalr	1160(ra) # 80005db8 <panic>
    panic("log_write outside of trans");
    80003938:	00005517          	auipc	a0,0x5
    8000393c:	d1050513          	addi	a0,a0,-752 # 80008648 <syscalls+0x250>
    80003940:	00002097          	auipc	ra,0x2
    80003944:	478080e7          	jalr	1144(ra) # 80005db8 <panic>
  log.lh.block[i] = b->blockno;
    80003948:	00878713          	addi	a4,a5,8
    8000394c:	00271693          	slli	a3,a4,0x2
    80003950:	00015717          	auipc	a4,0x15
    80003954:	6d070713          	addi	a4,a4,1744 # 80019020 <log>
    80003958:	9736                	add	a4,a4,a3
    8000395a:	44d4                	lw	a3,12(s1)
    8000395c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000395e:	faf608e3          	beq	a2,a5,8000390e <log_write+0x76>
  }
  release(&log.lock);
    80003962:	00015517          	auipc	a0,0x15
    80003966:	6be50513          	addi	a0,a0,1726 # 80019020 <log>
    8000396a:	00003097          	auipc	ra,0x3
    8000396e:	a4c080e7          	jalr	-1460(ra) # 800063b6 <release>
}
    80003972:	60e2                	ld	ra,24(sp)
    80003974:	6442                	ld	s0,16(sp)
    80003976:	64a2                	ld	s1,8(sp)
    80003978:	6902                	ld	s2,0(sp)
    8000397a:	6105                	addi	sp,sp,32
    8000397c:	8082                	ret

000000008000397e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000397e:	1101                	addi	sp,sp,-32
    80003980:	ec06                	sd	ra,24(sp)
    80003982:	e822                	sd	s0,16(sp)
    80003984:	e426                	sd	s1,8(sp)
    80003986:	e04a                	sd	s2,0(sp)
    80003988:	1000                	addi	s0,sp,32
    8000398a:	84aa                	mv	s1,a0
    8000398c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000398e:	00005597          	auipc	a1,0x5
    80003992:	cda58593          	addi	a1,a1,-806 # 80008668 <syscalls+0x270>
    80003996:	0521                	addi	a0,a0,8
    80003998:	00003097          	auipc	ra,0x3
    8000399c:	8da080e7          	jalr	-1830(ra) # 80006272 <initlock>
  lk->name = name;
    800039a0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039a4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039a8:	0204a423          	sw	zero,40(s1)
}
    800039ac:	60e2                	ld	ra,24(sp)
    800039ae:	6442                	ld	s0,16(sp)
    800039b0:	64a2                	ld	s1,8(sp)
    800039b2:	6902                	ld	s2,0(sp)
    800039b4:	6105                	addi	sp,sp,32
    800039b6:	8082                	ret

00000000800039b8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039b8:	1101                	addi	sp,sp,-32
    800039ba:	ec06                	sd	ra,24(sp)
    800039bc:	e822                	sd	s0,16(sp)
    800039be:	e426                	sd	s1,8(sp)
    800039c0:	e04a                	sd	s2,0(sp)
    800039c2:	1000                	addi	s0,sp,32
    800039c4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039c6:	00850913          	addi	s2,a0,8
    800039ca:	854a                	mv	a0,s2
    800039cc:	00003097          	auipc	ra,0x3
    800039d0:	936080e7          	jalr	-1738(ra) # 80006302 <acquire>
  while (lk->locked) {
    800039d4:	409c                	lw	a5,0(s1)
    800039d6:	cb89                	beqz	a5,800039e8 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039d8:	85ca                	mv	a1,s2
    800039da:	8526                	mv	a0,s1
    800039dc:	ffffe097          	auipc	ra,0xffffe
    800039e0:	cc0080e7          	jalr	-832(ra) # 8000169c <sleep>
  while (lk->locked) {
    800039e4:	409c                	lw	a5,0(s1)
    800039e6:	fbed                	bnez	a5,800039d8 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039e8:	4785                	li	a5,1
    800039ea:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039ec:	ffffd097          	auipc	ra,0xffffd
    800039f0:	53e080e7          	jalr	1342(ra) # 80000f2a <myproc>
    800039f4:	591c                	lw	a5,48(a0)
    800039f6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039f8:	854a                	mv	a0,s2
    800039fa:	00003097          	auipc	ra,0x3
    800039fe:	9bc080e7          	jalr	-1604(ra) # 800063b6 <release>
}
    80003a02:	60e2                	ld	ra,24(sp)
    80003a04:	6442                	ld	s0,16(sp)
    80003a06:	64a2                	ld	s1,8(sp)
    80003a08:	6902                	ld	s2,0(sp)
    80003a0a:	6105                	addi	sp,sp,32
    80003a0c:	8082                	ret

0000000080003a0e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a0e:	1101                	addi	sp,sp,-32
    80003a10:	ec06                	sd	ra,24(sp)
    80003a12:	e822                	sd	s0,16(sp)
    80003a14:	e426                	sd	s1,8(sp)
    80003a16:	e04a                	sd	s2,0(sp)
    80003a18:	1000                	addi	s0,sp,32
    80003a1a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a1c:	00850913          	addi	s2,a0,8
    80003a20:	854a                	mv	a0,s2
    80003a22:	00003097          	auipc	ra,0x3
    80003a26:	8e0080e7          	jalr	-1824(ra) # 80006302 <acquire>
  lk->locked = 0;
    80003a2a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a2e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a32:	8526                	mv	a0,s1
    80003a34:	ffffe097          	auipc	ra,0xffffe
    80003a38:	df4080e7          	jalr	-524(ra) # 80001828 <wakeup>
  release(&lk->lk);
    80003a3c:	854a                	mv	a0,s2
    80003a3e:	00003097          	auipc	ra,0x3
    80003a42:	978080e7          	jalr	-1672(ra) # 800063b6 <release>
}
    80003a46:	60e2                	ld	ra,24(sp)
    80003a48:	6442                	ld	s0,16(sp)
    80003a4a:	64a2                	ld	s1,8(sp)
    80003a4c:	6902                	ld	s2,0(sp)
    80003a4e:	6105                	addi	sp,sp,32
    80003a50:	8082                	ret

0000000080003a52 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a52:	7179                	addi	sp,sp,-48
    80003a54:	f406                	sd	ra,40(sp)
    80003a56:	f022                	sd	s0,32(sp)
    80003a58:	ec26                	sd	s1,24(sp)
    80003a5a:	e84a                	sd	s2,16(sp)
    80003a5c:	e44e                	sd	s3,8(sp)
    80003a5e:	1800                	addi	s0,sp,48
    80003a60:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a62:	00850913          	addi	s2,a0,8
    80003a66:	854a                	mv	a0,s2
    80003a68:	00003097          	auipc	ra,0x3
    80003a6c:	89a080e7          	jalr	-1894(ra) # 80006302 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a70:	409c                	lw	a5,0(s1)
    80003a72:	ef99                	bnez	a5,80003a90 <holdingsleep+0x3e>
    80003a74:	4481                	li	s1,0
  release(&lk->lk);
    80003a76:	854a                	mv	a0,s2
    80003a78:	00003097          	auipc	ra,0x3
    80003a7c:	93e080e7          	jalr	-1730(ra) # 800063b6 <release>
  return r;
}
    80003a80:	8526                	mv	a0,s1
    80003a82:	70a2                	ld	ra,40(sp)
    80003a84:	7402                	ld	s0,32(sp)
    80003a86:	64e2                	ld	s1,24(sp)
    80003a88:	6942                	ld	s2,16(sp)
    80003a8a:	69a2                	ld	s3,8(sp)
    80003a8c:	6145                	addi	sp,sp,48
    80003a8e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a90:	0284a983          	lw	s3,40(s1)
    80003a94:	ffffd097          	auipc	ra,0xffffd
    80003a98:	496080e7          	jalr	1174(ra) # 80000f2a <myproc>
    80003a9c:	5904                	lw	s1,48(a0)
    80003a9e:	413484b3          	sub	s1,s1,s3
    80003aa2:	0014b493          	seqz	s1,s1
    80003aa6:	bfc1                	j	80003a76 <holdingsleep+0x24>

0000000080003aa8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003aa8:	1141                	addi	sp,sp,-16
    80003aaa:	e406                	sd	ra,8(sp)
    80003aac:	e022                	sd	s0,0(sp)
    80003aae:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ab0:	00005597          	auipc	a1,0x5
    80003ab4:	bc858593          	addi	a1,a1,-1080 # 80008678 <syscalls+0x280>
    80003ab8:	00015517          	auipc	a0,0x15
    80003abc:	6b050513          	addi	a0,a0,1712 # 80019168 <ftable>
    80003ac0:	00002097          	auipc	ra,0x2
    80003ac4:	7b2080e7          	jalr	1970(ra) # 80006272 <initlock>
}
    80003ac8:	60a2                	ld	ra,8(sp)
    80003aca:	6402                	ld	s0,0(sp)
    80003acc:	0141                	addi	sp,sp,16
    80003ace:	8082                	ret

0000000080003ad0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003ad0:	1101                	addi	sp,sp,-32
    80003ad2:	ec06                	sd	ra,24(sp)
    80003ad4:	e822                	sd	s0,16(sp)
    80003ad6:	e426                	sd	s1,8(sp)
    80003ad8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003ada:	00015517          	auipc	a0,0x15
    80003ade:	68e50513          	addi	a0,a0,1678 # 80019168 <ftable>
    80003ae2:	00003097          	auipc	ra,0x3
    80003ae6:	820080e7          	jalr	-2016(ra) # 80006302 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003aea:	00015497          	auipc	s1,0x15
    80003aee:	69648493          	addi	s1,s1,1686 # 80019180 <ftable+0x18>
    80003af2:	00016717          	auipc	a4,0x16
    80003af6:	62e70713          	addi	a4,a4,1582 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    80003afa:	40dc                	lw	a5,4(s1)
    80003afc:	cf99                	beqz	a5,80003b1a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003afe:	02848493          	addi	s1,s1,40
    80003b02:	fee49ce3          	bne	s1,a4,80003afa <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b06:	00015517          	auipc	a0,0x15
    80003b0a:	66250513          	addi	a0,a0,1634 # 80019168 <ftable>
    80003b0e:	00003097          	auipc	ra,0x3
    80003b12:	8a8080e7          	jalr	-1880(ra) # 800063b6 <release>
  return 0;
    80003b16:	4481                	li	s1,0
    80003b18:	a819                	j	80003b2e <filealloc+0x5e>
      f->ref = 1;
    80003b1a:	4785                	li	a5,1
    80003b1c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b1e:	00015517          	auipc	a0,0x15
    80003b22:	64a50513          	addi	a0,a0,1610 # 80019168 <ftable>
    80003b26:	00003097          	auipc	ra,0x3
    80003b2a:	890080e7          	jalr	-1904(ra) # 800063b6 <release>
}
    80003b2e:	8526                	mv	a0,s1
    80003b30:	60e2                	ld	ra,24(sp)
    80003b32:	6442                	ld	s0,16(sp)
    80003b34:	64a2                	ld	s1,8(sp)
    80003b36:	6105                	addi	sp,sp,32
    80003b38:	8082                	ret

0000000080003b3a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b3a:	1101                	addi	sp,sp,-32
    80003b3c:	ec06                	sd	ra,24(sp)
    80003b3e:	e822                	sd	s0,16(sp)
    80003b40:	e426                	sd	s1,8(sp)
    80003b42:	1000                	addi	s0,sp,32
    80003b44:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b46:	00015517          	auipc	a0,0x15
    80003b4a:	62250513          	addi	a0,a0,1570 # 80019168 <ftable>
    80003b4e:	00002097          	auipc	ra,0x2
    80003b52:	7b4080e7          	jalr	1972(ra) # 80006302 <acquire>
  if(f->ref < 1)
    80003b56:	40dc                	lw	a5,4(s1)
    80003b58:	02f05263          	blez	a5,80003b7c <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b5c:	2785                	addiw	a5,a5,1
    80003b5e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b60:	00015517          	auipc	a0,0x15
    80003b64:	60850513          	addi	a0,a0,1544 # 80019168 <ftable>
    80003b68:	00003097          	auipc	ra,0x3
    80003b6c:	84e080e7          	jalr	-1970(ra) # 800063b6 <release>
  return f;
}
    80003b70:	8526                	mv	a0,s1
    80003b72:	60e2                	ld	ra,24(sp)
    80003b74:	6442                	ld	s0,16(sp)
    80003b76:	64a2                	ld	s1,8(sp)
    80003b78:	6105                	addi	sp,sp,32
    80003b7a:	8082                	ret
    panic("filedup");
    80003b7c:	00005517          	auipc	a0,0x5
    80003b80:	b0450513          	addi	a0,a0,-1276 # 80008680 <syscalls+0x288>
    80003b84:	00002097          	auipc	ra,0x2
    80003b88:	234080e7          	jalr	564(ra) # 80005db8 <panic>

0000000080003b8c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b8c:	7139                	addi	sp,sp,-64
    80003b8e:	fc06                	sd	ra,56(sp)
    80003b90:	f822                	sd	s0,48(sp)
    80003b92:	f426                	sd	s1,40(sp)
    80003b94:	f04a                	sd	s2,32(sp)
    80003b96:	ec4e                	sd	s3,24(sp)
    80003b98:	e852                	sd	s4,16(sp)
    80003b9a:	e456                	sd	s5,8(sp)
    80003b9c:	0080                	addi	s0,sp,64
    80003b9e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003ba0:	00015517          	auipc	a0,0x15
    80003ba4:	5c850513          	addi	a0,a0,1480 # 80019168 <ftable>
    80003ba8:	00002097          	auipc	ra,0x2
    80003bac:	75a080e7          	jalr	1882(ra) # 80006302 <acquire>
  if(f->ref < 1)
    80003bb0:	40dc                	lw	a5,4(s1)
    80003bb2:	06f05163          	blez	a5,80003c14 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bb6:	37fd                	addiw	a5,a5,-1
    80003bb8:	0007871b          	sext.w	a4,a5
    80003bbc:	c0dc                	sw	a5,4(s1)
    80003bbe:	06e04363          	bgtz	a4,80003c24 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bc2:	0004a903          	lw	s2,0(s1)
    80003bc6:	0094ca83          	lbu	s5,9(s1)
    80003bca:	0104ba03          	ld	s4,16(s1)
    80003bce:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bd2:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bd6:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bda:	00015517          	auipc	a0,0x15
    80003bde:	58e50513          	addi	a0,a0,1422 # 80019168 <ftable>
    80003be2:	00002097          	auipc	ra,0x2
    80003be6:	7d4080e7          	jalr	2004(ra) # 800063b6 <release>

  if(ff.type == FD_PIPE){
    80003bea:	4785                	li	a5,1
    80003bec:	04f90d63          	beq	s2,a5,80003c46 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003bf0:	3979                	addiw	s2,s2,-2
    80003bf2:	4785                	li	a5,1
    80003bf4:	0527e063          	bltu	a5,s2,80003c34 <fileclose+0xa8>
    begin_op();
    80003bf8:	00000097          	auipc	ra,0x0
    80003bfc:	ac8080e7          	jalr	-1336(ra) # 800036c0 <begin_op>
    iput(ff.ip);
    80003c00:	854e                	mv	a0,s3
    80003c02:	fffff097          	auipc	ra,0xfffff
    80003c06:	2a6080e7          	jalr	678(ra) # 80002ea8 <iput>
    end_op();
    80003c0a:	00000097          	auipc	ra,0x0
    80003c0e:	b36080e7          	jalr	-1226(ra) # 80003740 <end_op>
    80003c12:	a00d                	j	80003c34 <fileclose+0xa8>
    panic("fileclose");
    80003c14:	00005517          	auipc	a0,0x5
    80003c18:	a7450513          	addi	a0,a0,-1420 # 80008688 <syscalls+0x290>
    80003c1c:	00002097          	auipc	ra,0x2
    80003c20:	19c080e7          	jalr	412(ra) # 80005db8 <panic>
    release(&ftable.lock);
    80003c24:	00015517          	auipc	a0,0x15
    80003c28:	54450513          	addi	a0,a0,1348 # 80019168 <ftable>
    80003c2c:	00002097          	auipc	ra,0x2
    80003c30:	78a080e7          	jalr	1930(ra) # 800063b6 <release>
  }
}
    80003c34:	70e2                	ld	ra,56(sp)
    80003c36:	7442                	ld	s0,48(sp)
    80003c38:	74a2                	ld	s1,40(sp)
    80003c3a:	7902                	ld	s2,32(sp)
    80003c3c:	69e2                	ld	s3,24(sp)
    80003c3e:	6a42                	ld	s4,16(sp)
    80003c40:	6aa2                	ld	s5,8(sp)
    80003c42:	6121                	addi	sp,sp,64
    80003c44:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c46:	85d6                	mv	a1,s5
    80003c48:	8552                	mv	a0,s4
    80003c4a:	00000097          	auipc	ra,0x0
    80003c4e:	34c080e7          	jalr	844(ra) # 80003f96 <pipeclose>
    80003c52:	b7cd                	j	80003c34 <fileclose+0xa8>

0000000080003c54 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c54:	715d                	addi	sp,sp,-80
    80003c56:	e486                	sd	ra,72(sp)
    80003c58:	e0a2                	sd	s0,64(sp)
    80003c5a:	fc26                	sd	s1,56(sp)
    80003c5c:	f84a                	sd	s2,48(sp)
    80003c5e:	f44e                	sd	s3,40(sp)
    80003c60:	0880                	addi	s0,sp,80
    80003c62:	84aa                	mv	s1,a0
    80003c64:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c66:	ffffd097          	auipc	ra,0xffffd
    80003c6a:	2c4080e7          	jalr	708(ra) # 80000f2a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c6e:	409c                	lw	a5,0(s1)
    80003c70:	37f9                	addiw	a5,a5,-2
    80003c72:	4705                	li	a4,1
    80003c74:	04f76763          	bltu	a4,a5,80003cc2 <filestat+0x6e>
    80003c78:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c7a:	6c88                	ld	a0,24(s1)
    80003c7c:	fffff097          	auipc	ra,0xfffff
    80003c80:	072080e7          	jalr	114(ra) # 80002cee <ilock>
    stati(f->ip, &st);
    80003c84:	fb840593          	addi	a1,s0,-72
    80003c88:	6c88                	ld	a0,24(s1)
    80003c8a:	fffff097          	auipc	ra,0xfffff
    80003c8e:	2ee080e7          	jalr	750(ra) # 80002f78 <stati>
    iunlock(f->ip);
    80003c92:	6c88                	ld	a0,24(s1)
    80003c94:	fffff097          	auipc	ra,0xfffff
    80003c98:	11c080e7          	jalr	284(ra) # 80002db0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c9c:	46e1                	li	a3,24
    80003c9e:	fb840613          	addi	a2,s0,-72
    80003ca2:	85ce                	mv	a1,s3
    80003ca4:	05093503          	ld	a0,80(s2)
    80003ca8:	ffffd097          	auipc	ra,0xffffd
    80003cac:	f14080e7          	jalr	-236(ra) # 80000bbc <copyout>
    80003cb0:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cb4:	60a6                	ld	ra,72(sp)
    80003cb6:	6406                	ld	s0,64(sp)
    80003cb8:	74e2                	ld	s1,56(sp)
    80003cba:	7942                	ld	s2,48(sp)
    80003cbc:	79a2                	ld	s3,40(sp)
    80003cbe:	6161                	addi	sp,sp,80
    80003cc0:	8082                	ret
  return -1;
    80003cc2:	557d                	li	a0,-1
    80003cc4:	bfc5                	j	80003cb4 <filestat+0x60>

0000000080003cc6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cc6:	7179                	addi	sp,sp,-48
    80003cc8:	f406                	sd	ra,40(sp)
    80003cca:	f022                	sd	s0,32(sp)
    80003ccc:	ec26                	sd	s1,24(sp)
    80003cce:	e84a                	sd	s2,16(sp)
    80003cd0:	e44e                	sd	s3,8(sp)
    80003cd2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cd4:	00854783          	lbu	a5,8(a0)
    80003cd8:	c3d5                	beqz	a5,80003d7c <fileread+0xb6>
    80003cda:	84aa                	mv	s1,a0
    80003cdc:	89ae                	mv	s3,a1
    80003cde:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ce0:	411c                	lw	a5,0(a0)
    80003ce2:	4705                	li	a4,1
    80003ce4:	04e78963          	beq	a5,a4,80003d36 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ce8:	470d                	li	a4,3
    80003cea:	04e78d63          	beq	a5,a4,80003d44 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cee:	4709                	li	a4,2
    80003cf0:	06e79e63          	bne	a5,a4,80003d6c <fileread+0xa6>
    ilock(f->ip);
    80003cf4:	6d08                	ld	a0,24(a0)
    80003cf6:	fffff097          	auipc	ra,0xfffff
    80003cfa:	ff8080e7          	jalr	-8(ra) # 80002cee <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003cfe:	874a                	mv	a4,s2
    80003d00:	5094                	lw	a3,32(s1)
    80003d02:	864e                	mv	a2,s3
    80003d04:	4585                	li	a1,1
    80003d06:	6c88                	ld	a0,24(s1)
    80003d08:	fffff097          	auipc	ra,0xfffff
    80003d0c:	29a080e7          	jalr	666(ra) # 80002fa2 <readi>
    80003d10:	892a                	mv	s2,a0
    80003d12:	00a05563          	blez	a0,80003d1c <fileread+0x56>
      f->off += r;
    80003d16:	509c                	lw	a5,32(s1)
    80003d18:	9fa9                	addw	a5,a5,a0
    80003d1a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d1c:	6c88                	ld	a0,24(s1)
    80003d1e:	fffff097          	auipc	ra,0xfffff
    80003d22:	092080e7          	jalr	146(ra) # 80002db0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d26:	854a                	mv	a0,s2
    80003d28:	70a2                	ld	ra,40(sp)
    80003d2a:	7402                	ld	s0,32(sp)
    80003d2c:	64e2                	ld	s1,24(sp)
    80003d2e:	6942                	ld	s2,16(sp)
    80003d30:	69a2                	ld	s3,8(sp)
    80003d32:	6145                	addi	sp,sp,48
    80003d34:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d36:	6908                	ld	a0,16(a0)
    80003d38:	00000097          	auipc	ra,0x0
    80003d3c:	3c8080e7          	jalr	968(ra) # 80004100 <piperead>
    80003d40:	892a                	mv	s2,a0
    80003d42:	b7d5                	j	80003d26 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d44:	02451783          	lh	a5,36(a0)
    80003d48:	03079693          	slli	a3,a5,0x30
    80003d4c:	92c1                	srli	a3,a3,0x30
    80003d4e:	4725                	li	a4,9
    80003d50:	02d76863          	bltu	a4,a3,80003d80 <fileread+0xba>
    80003d54:	0792                	slli	a5,a5,0x4
    80003d56:	00015717          	auipc	a4,0x15
    80003d5a:	37270713          	addi	a4,a4,882 # 800190c8 <devsw>
    80003d5e:	97ba                	add	a5,a5,a4
    80003d60:	639c                	ld	a5,0(a5)
    80003d62:	c38d                	beqz	a5,80003d84 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d64:	4505                	li	a0,1
    80003d66:	9782                	jalr	a5
    80003d68:	892a                	mv	s2,a0
    80003d6a:	bf75                	j	80003d26 <fileread+0x60>
    panic("fileread");
    80003d6c:	00005517          	auipc	a0,0x5
    80003d70:	92c50513          	addi	a0,a0,-1748 # 80008698 <syscalls+0x2a0>
    80003d74:	00002097          	auipc	ra,0x2
    80003d78:	044080e7          	jalr	68(ra) # 80005db8 <panic>
    return -1;
    80003d7c:	597d                	li	s2,-1
    80003d7e:	b765                	j	80003d26 <fileread+0x60>
      return -1;
    80003d80:	597d                	li	s2,-1
    80003d82:	b755                	j	80003d26 <fileread+0x60>
    80003d84:	597d                	li	s2,-1
    80003d86:	b745                	j	80003d26 <fileread+0x60>

0000000080003d88 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d88:	715d                	addi	sp,sp,-80
    80003d8a:	e486                	sd	ra,72(sp)
    80003d8c:	e0a2                	sd	s0,64(sp)
    80003d8e:	fc26                	sd	s1,56(sp)
    80003d90:	f84a                	sd	s2,48(sp)
    80003d92:	f44e                	sd	s3,40(sp)
    80003d94:	f052                	sd	s4,32(sp)
    80003d96:	ec56                	sd	s5,24(sp)
    80003d98:	e85a                	sd	s6,16(sp)
    80003d9a:	e45e                	sd	s7,8(sp)
    80003d9c:	e062                	sd	s8,0(sp)
    80003d9e:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003da0:	00954783          	lbu	a5,9(a0)
    80003da4:	10078663          	beqz	a5,80003eb0 <filewrite+0x128>
    80003da8:	892a                	mv	s2,a0
    80003daa:	8aae                	mv	s5,a1
    80003dac:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dae:	411c                	lw	a5,0(a0)
    80003db0:	4705                	li	a4,1
    80003db2:	02e78263          	beq	a5,a4,80003dd6 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003db6:	470d                	li	a4,3
    80003db8:	02e78663          	beq	a5,a4,80003de4 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003dbc:	4709                	li	a4,2
    80003dbe:	0ee79163          	bne	a5,a4,80003ea0 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003dc2:	0ac05d63          	blez	a2,80003e7c <filewrite+0xf4>
    int i = 0;
    80003dc6:	4981                	li	s3,0
    80003dc8:	6b05                	lui	s6,0x1
    80003dca:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003dce:	6b85                	lui	s7,0x1
    80003dd0:	c00b8b9b          	addiw	s7,s7,-1024
    80003dd4:	a861                	j	80003e6c <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003dd6:	6908                	ld	a0,16(a0)
    80003dd8:	00000097          	auipc	ra,0x0
    80003ddc:	22e080e7          	jalr	558(ra) # 80004006 <pipewrite>
    80003de0:	8a2a                	mv	s4,a0
    80003de2:	a045                	j	80003e82 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003de4:	02451783          	lh	a5,36(a0)
    80003de8:	03079693          	slli	a3,a5,0x30
    80003dec:	92c1                	srli	a3,a3,0x30
    80003dee:	4725                	li	a4,9
    80003df0:	0cd76263          	bltu	a4,a3,80003eb4 <filewrite+0x12c>
    80003df4:	0792                	slli	a5,a5,0x4
    80003df6:	00015717          	auipc	a4,0x15
    80003dfa:	2d270713          	addi	a4,a4,722 # 800190c8 <devsw>
    80003dfe:	97ba                	add	a5,a5,a4
    80003e00:	679c                	ld	a5,8(a5)
    80003e02:	cbdd                	beqz	a5,80003eb8 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e04:	4505                	li	a0,1
    80003e06:	9782                	jalr	a5
    80003e08:	8a2a                	mv	s4,a0
    80003e0a:	a8a5                	j	80003e82 <filewrite+0xfa>
    80003e0c:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e10:	00000097          	auipc	ra,0x0
    80003e14:	8b0080e7          	jalr	-1872(ra) # 800036c0 <begin_op>
      ilock(f->ip);
    80003e18:	01893503          	ld	a0,24(s2)
    80003e1c:	fffff097          	auipc	ra,0xfffff
    80003e20:	ed2080e7          	jalr	-302(ra) # 80002cee <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e24:	8762                	mv	a4,s8
    80003e26:	02092683          	lw	a3,32(s2)
    80003e2a:	01598633          	add	a2,s3,s5
    80003e2e:	4585                	li	a1,1
    80003e30:	01893503          	ld	a0,24(s2)
    80003e34:	fffff097          	auipc	ra,0xfffff
    80003e38:	266080e7          	jalr	614(ra) # 8000309a <writei>
    80003e3c:	84aa                	mv	s1,a0
    80003e3e:	00a05763          	blez	a0,80003e4c <filewrite+0xc4>
        f->off += r;
    80003e42:	02092783          	lw	a5,32(s2)
    80003e46:	9fa9                	addw	a5,a5,a0
    80003e48:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e4c:	01893503          	ld	a0,24(s2)
    80003e50:	fffff097          	auipc	ra,0xfffff
    80003e54:	f60080e7          	jalr	-160(ra) # 80002db0 <iunlock>
      end_op();
    80003e58:	00000097          	auipc	ra,0x0
    80003e5c:	8e8080e7          	jalr	-1816(ra) # 80003740 <end_op>

      if(r != n1){
    80003e60:	009c1f63          	bne	s8,s1,80003e7e <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e64:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e68:	0149db63          	bge	s3,s4,80003e7e <filewrite+0xf6>
      int n1 = n - i;
    80003e6c:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e70:	84be                	mv	s1,a5
    80003e72:	2781                	sext.w	a5,a5
    80003e74:	f8fb5ce3          	bge	s6,a5,80003e0c <filewrite+0x84>
    80003e78:	84de                	mv	s1,s7
    80003e7a:	bf49                	j	80003e0c <filewrite+0x84>
    int i = 0;
    80003e7c:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e7e:	013a1f63          	bne	s4,s3,80003e9c <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e82:	8552                	mv	a0,s4
    80003e84:	60a6                	ld	ra,72(sp)
    80003e86:	6406                	ld	s0,64(sp)
    80003e88:	74e2                	ld	s1,56(sp)
    80003e8a:	7942                	ld	s2,48(sp)
    80003e8c:	79a2                	ld	s3,40(sp)
    80003e8e:	7a02                	ld	s4,32(sp)
    80003e90:	6ae2                	ld	s5,24(sp)
    80003e92:	6b42                	ld	s6,16(sp)
    80003e94:	6ba2                	ld	s7,8(sp)
    80003e96:	6c02                	ld	s8,0(sp)
    80003e98:	6161                	addi	sp,sp,80
    80003e9a:	8082                	ret
    ret = (i == n ? n : -1);
    80003e9c:	5a7d                	li	s4,-1
    80003e9e:	b7d5                	j	80003e82 <filewrite+0xfa>
    panic("filewrite");
    80003ea0:	00005517          	auipc	a0,0x5
    80003ea4:	80850513          	addi	a0,a0,-2040 # 800086a8 <syscalls+0x2b0>
    80003ea8:	00002097          	auipc	ra,0x2
    80003eac:	f10080e7          	jalr	-240(ra) # 80005db8 <panic>
    return -1;
    80003eb0:	5a7d                	li	s4,-1
    80003eb2:	bfc1                	j	80003e82 <filewrite+0xfa>
      return -1;
    80003eb4:	5a7d                	li	s4,-1
    80003eb6:	b7f1                	j	80003e82 <filewrite+0xfa>
    80003eb8:	5a7d                	li	s4,-1
    80003eba:	b7e1                	j	80003e82 <filewrite+0xfa>

0000000080003ebc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ebc:	7179                	addi	sp,sp,-48
    80003ebe:	f406                	sd	ra,40(sp)
    80003ec0:	f022                	sd	s0,32(sp)
    80003ec2:	ec26                	sd	s1,24(sp)
    80003ec4:	e84a                	sd	s2,16(sp)
    80003ec6:	e44e                	sd	s3,8(sp)
    80003ec8:	e052                	sd	s4,0(sp)
    80003eca:	1800                	addi	s0,sp,48
    80003ecc:	84aa                	mv	s1,a0
    80003ece:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003ed0:	0005b023          	sd	zero,0(a1)
    80003ed4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ed8:	00000097          	auipc	ra,0x0
    80003edc:	bf8080e7          	jalr	-1032(ra) # 80003ad0 <filealloc>
    80003ee0:	e088                	sd	a0,0(s1)
    80003ee2:	c551                	beqz	a0,80003f6e <pipealloc+0xb2>
    80003ee4:	00000097          	auipc	ra,0x0
    80003ee8:	bec080e7          	jalr	-1044(ra) # 80003ad0 <filealloc>
    80003eec:	00aa3023          	sd	a0,0(s4)
    80003ef0:	c92d                	beqz	a0,80003f62 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ef2:	ffffc097          	auipc	ra,0xffffc
    80003ef6:	226080e7          	jalr	550(ra) # 80000118 <kalloc>
    80003efa:	892a                	mv	s2,a0
    80003efc:	c125                	beqz	a0,80003f5c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003efe:	4985                	li	s3,1
    80003f00:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f04:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f08:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f0c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f10:	00004597          	auipc	a1,0x4
    80003f14:	7a858593          	addi	a1,a1,1960 # 800086b8 <syscalls+0x2c0>
    80003f18:	00002097          	auipc	ra,0x2
    80003f1c:	35a080e7          	jalr	858(ra) # 80006272 <initlock>
  (*f0)->type = FD_PIPE;
    80003f20:	609c                	ld	a5,0(s1)
    80003f22:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f26:	609c                	ld	a5,0(s1)
    80003f28:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f2c:	609c                	ld	a5,0(s1)
    80003f2e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f32:	609c                	ld	a5,0(s1)
    80003f34:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f38:	000a3783          	ld	a5,0(s4)
    80003f3c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f40:	000a3783          	ld	a5,0(s4)
    80003f44:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f48:	000a3783          	ld	a5,0(s4)
    80003f4c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f50:	000a3783          	ld	a5,0(s4)
    80003f54:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f58:	4501                	li	a0,0
    80003f5a:	a025                	j	80003f82 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f5c:	6088                	ld	a0,0(s1)
    80003f5e:	e501                	bnez	a0,80003f66 <pipealloc+0xaa>
    80003f60:	a039                	j	80003f6e <pipealloc+0xb2>
    80003f62:	6088                	ld	a0,0(s1)
    80003f64:	c51d                	beqz	a0,80003f92 <pipealloc+0xd6>
    fileclose(*f0);
    80003f66:	00000097          	auipc	ra,0x0
    80003f6a:	c26080e7          	jalr	-986(ra) # 80003b8c <fileclose>
  if(*f1)
    80003f6e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f72:	557d                	li	a0,-1
  if(*f1)
    80003f74:	c799                	beqz	a5,80003f82 <pipealloc+0xc6>
    fileclose(*f1);
    80003f76:	853e                	mv	a0,a5
    80003f78:	00000097          	auipc	ra,0x0
    80003f7c:	c14080e7          	jalr	-1004(ra) # 80003b8c <fileclose>
  return -1;
    80003f80:	557d                	li	a0,-1
}
    80003f82:	70a2                	ld	ra,40(sp)
    80003f84:	7402                	ld	s0,32(sp)
    80003f86:	64e2                	ld	s1,24(sp)
    80003f88:	6942                	ld	s2,16(sp)
    80003f8a:	69a2                	ld	s3,8(sp)
    80003f8c:	6a02                	ld	s4,0(sp)
    80003f8e:	6145                	addi	sp,sp,48
    80003f90:	8082                	ret
  return -1;
    80003f92:	557d                	li	a0,-1
    80003f94:	b7fd                	j	80003f82 <pipealloc+0xc6>

0000000080003f96 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f96:	1101                	addi	sp,sp,-32
    80003f98:	ec06                	sd	ra,24(sp)
    80003f9a:	e822                	sd	s0,16(sp)
    80003f9c:	e426                	sd	s1,8(sp)
    80003f9e:	e04a                	sd	s2,0(sp)
    80003fa0:	1000                	addi	s0,sp,32
    80003fa2:	84aa                	mv	s1,a0
    80003fa4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fa6:	00002097          	auipc	ra,0x2
    80003faa:	35c080e7          	jalr	860(ra) # 80006302 <acquire>
  if(writable){
    80003fae:	02090d63          	beqz	s2,80003fe8 <pipeclose+0x52>
    pi->writeopen = 0;
    80003fb2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fb6:	21848513          	addi	a0,s1,536
    80003fba:	ffffe097          	auipc	ra,0xffffe
    80003fbe:	86e080e7          	jalr	-1938(ra) # 80001828 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fc2:	2204b783          	ld	a5,544(s1)
    80003fc6:	eb95                	bnez	a5,80003ffa <pipeclose+0x64>
    release(&pi->lock);
    80003fc8:	8526                	mv	a0,s1
    80003fca:	00002097          	auipc	ra,0x2
    80003fce:	3ec080e7          	jalr	1004(ra) # 800063b6 <release>
    kfree((char*)pi);
    80003fd2:	8526                	mv	a0,s1
    80003fd4:	ffffc097          	auipc	ra,0xffffc
    80003fd8:	048080e7          	jalr	72(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003fdc:	60e2                	ld	ra,24(sp)
    80003fde:	6442                	ld	s0,16(sp)
    80003fe0:	64a2                	ld	s1,8(sp)
    80003fe2:	6902                	ld	s2,0(sp)
    80003fe4:	6105                	addi	sp,sp,32
    80003fe6:	8082                	ret
    pi->readopen = 0;
    80003fe8:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003fec:	21c48513          	addi	a0,s1,540
    80003ff0:	ffffe097          	auipc	ra,0xffffe
    80003ff4:	838080e7          	jalr	-1992(ra) # 80001828 <wakeup>
    80003ff8:	b7e9                	j	80003fc2 <pipeclose+0x2c>
    release(&pi->lock);
    80003ffa:	8526                	mv	a0,s1
    80003ffc:	00002097          	auipc	ra,0x2
    80004000:	3ba080e7          	jalr	954(ra) # 800063b6 <release>
}
    80004004:	bfe1                	j	80003fdc <pipeclose+0x46>

0000000080004006 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004006:	7159                	addi	sp,sp,-112
    80004008:	f486                	sd	ra,104(sp)
    8000400a:	f0a2                	sd	s0,96(sp)
    8000400c:	eca6                	sd	s1,88(sp)
    8000400e:	e8ca                	sd	s2,80(sp)
    80004010:	e4ce                	sd	s3,72(sp)
    80004012:	e0d2                	sd	s4,64(sp)
    80004014:	fc56                	sd	s5,56(sp)
    80004016:	f85a                	sd	s6,48(sp)
    80004018:	f45e                	sd	s7,40(sp)
    8000401a:	f062                	sd	s8,32(sp)
    8000401c:	ec66                	sd	s9,24(sp)
    8000401e:	1880                	addi	s0,sp,112
    80004020:	84aa                	mv	s1,a0
    80004022:	8aae                	mv	s5,a1
    80004024:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004026:	ffffd097          	auipc	ra,0xffffd
    8000402a:	f04080e7          	jalr	-252(ra) # 80000f2a <myproc>
    8000402e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004030:	8526                	mv	a0,s1
    80004032:	00002097          	auipc	ra,0x2
    80004036:	2d0080e7          	jalr	720(ra) # 80006302 <acquire>
  while(i < n){
    8000403a:	0d405163          	blez	s4,800040fc <pipewrite+0xf6>
    8000403e:	8ba6                	mv	s7,s1
  int i = 0;
    80004040:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004042:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004044:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004048:	21c48c13          	addi	s8,s1,540
    8000404c:	a08d                	j	800040ae <pipewrite+0xa8>
      release(&pi->lock);
    8000404e:	8526                	mv	a0,s1
    80004050:	00002097          	auipc	ra,0x2
    80004054:	366080e7          	jalr	870(ra) # 800063b6 <release>
      return -1;
    80004058:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000405a:	854a                	mv	a0,s2
    8000405c:	70a6                	ld	ra,104(sp)
    8000405e:	7406                	ld	s0,96(sp)
    80004060:	64e6                	ld	s1,88(sp)
    80004062:	6946                	ld	s2,80(sp)
    80004064:	69a6                	ld	s3,72(sp)
    80004066:	6a06                	ld	s4,64(sp)
    80004068:	7ae2                	ld	s5,56(sp)
    8000406a:	7b42                	ld	s6,48(sp)
    8000406c:	7ba2                	ld	s7,40(sp)
    8000406e:	7c02                	ld	s8,32(sp)
    80004070:	6ce2                	ld	s9,24(sp)
    80004072:	6165                	addi	sp,sp,112
    80004074:	8082                	ret
      wakeup(&pi->nread);
    80004076:	8566                	mv	a0,s9
    80004078:	ffffd097          	auipc	ra,0xffffd
    8000407c:	7b0080e7          	jalr	1968(ra) # 80001828 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004080:	85de                	mv	a1,s7
    80004082:	8562                	mv	a0,s8
    80004084:	ffffd097          	auipc	ra,0xffffd
    80004088:	618080e7          	jalr	1560(ra) # 8000169c <sleep>
    8000408c:	a839                	j	800040aa <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000408e:	21c4a783          	lw	a5,540(s1)
    80004092:	0017871b          	addiw	a4,a5,1
    80004096:	20e4ae23          	sw	a4,540(s1)
    8000409a:	1ff7f793          	andi	a5,a5,511
    8000409e:	97a6                	add	a5,a5,s1
    800040a0:	f9f44703          	lbu	a4,-97(s0)
    800040a4:	00e78c23          	sb	a4,24(a5)
      i++;
    800040a8:	2905                	addiw	s2,s2,1
  while(i < n){
    800040aa:	03495d63          	bge	s2,s4,800040e4 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    800040ae:	2204a783          	lw	a5,544(s1)
    800040b2:	dfd1                	beqz	a5,8000404e <pipewrite+0x48>
    800040b4:	0289a783          	lw	a5,40(s3)
    800040b8:	fbd9                	bnez	a5,8000404e <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040ba:	2184a783          	lw	a5,536(s1)
    800040be:	21c4a703          	lw	a4,540(s1)
    800040c2:	2007879b          	addiw	a5,a5,512
    800040c6:	faf708e3          	beq	a4,a5,80004076 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040ca:	4685                	li	a3,1
    800040cc:	01590633          	add	a2,s2,s5
    800040d0:	f9f40593          	addi	a1,s0,-97
    800040d4:	0509b503          	ld	a0,80(s3)
    800040d8:	ffffd097          	auipc	ra,0xffffd
    800040dc:	b70080e7          	jalr	-1168(ra) # 80000c48 <copyin>
    800040e0:	fb6517e3          	bne	a0,s6,8000408e <pipewrite+0x88>
  wakeup(&pi->nread);
    800040e4:	21848513          	addi	a0,s1,536
    800040e8:	ffffd097          	auipc	ra,0xffffd
    800040ec:	740080e7          	jalr	1856(ra) # 80001828 <wakeup>
  release(&pi->lock);
    800040f0:	8526                	mv	a0,s1
    800040f2:	00002097          	auipc	ra,0x2
    800040f6:	2c4080e7          	jalr	708(ra) # 800063b6 <release>
  return i;
    800040fa:	b785                	j	8000405a <pipewrite+0x54>
  int i = 0;
    800040fc:	4901                	li	s2,0
    800040fe:	b7dd                	j	800040e4 <pipewrite+0xde>

0000000080004100 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004100:	715d                	addi	sp,sp,-80
    80004102:	e486                	sd	ra,72(sp)
    80004104:	e0a2                	sd	s0,64(sp)
    80004106:	fc26                	sd	s1,56(sp)
    80004108:	f84a                	sd	s2,48(sp)
    8000410a:	f44e                	sd	s3,40(sp)
    8000410c:	f052                	sd	s4,32(sp)
    8000410e:	ec56                	sd	s5,24(sp)
    80004110:	e85a                	sd	s6,16(sp)
    80004112:	0880                	addi	s0,sp,80
    80004114:	84aa                	mv	s1,a0
    80004116:	892e                	mv	s2,a1
    80004118:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000411a:	ffffd097          	auipc	ra,0xffffd
    8000411e:	e10080e7          	jalr	-496(ra) # 80000f2a <myproc>
    80004122:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004124:	8b26                	mv	s6,s1
    80004126:	8526                	mv	a0,s1
    80004128:	00002097          	auipc	ra,0x2
    8000412c:	1da080e7          	jalr	474(ra) # 80006302 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004130:	2184a703          	lw	a4,536(s1)
    80004134:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004138:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000413c:	02f71463          	bne	a4,a5,80004164 <piperead+0x64>
    80004140:	2244a783          	lw	a5,548(s1)
    80004144:	c385                	beqz	a5,80004164 <piperead+0x64>
    if(pr->killed){
    80004146:	028a2783          	lw	a5,40(s4)
    8000414a:	ebc1                	bnez	a5,800041da <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000414c:	85da                	mv	a1,s6
    8000414e:	854e                	mv	a0,s3
    80004150:	ffffd097          	auipc	ra,0xffffd
    80004154:	54c080e7          	jalr	1356(ra) # 8000169c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004158:	2184a703          	lw	a4,536(s1)
    8000415c:	21c4a783          	lw	a5,540(s1)
    80004160:	fef700e3          	beq	a4,a5,80004140 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004164:	09505263          	blez	s5,800041e8 <piperead+0xe8>
    80004168:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000416a:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000416c:	2184a783          	lw	a5,536(s1)
    80004170:	21c4a703          	lw	a4,540(s1)
    80004174:	02f70d63          	beq	a4,a5,800041ae <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004178:	0017871b          	addiw	a4,a5,1
    8000417c:	20e4ac23          	sw	a4,536(s1)
    80004180:	1ff7f793          	andi	a5,a5,511
    80004184:	97a6                	add	a5,a5,s1
    80004186:	0187c783          	lbu	a5,24(a5)
    8000418a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000418e:	4685                	li	a3,1
    80004190:	fbf40613          	addi	a2,s0,-65
    80004194:	85ca                	mv	a1,s2
    80004196:	050a3503          	ld	a0,80(s4)
    8000419a:	ffffd097          	auipc	ra,0xffffd
    8000419e:	a22080e7          	jalr	-1502(ra) # 80000bbc <copyout>
    800041a2:	01650663          	beq	a0,s6,800041ae <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041a6:	2985                	addiw	s3,s3,1
    800041a8:	0905                	addi	s2,s2,1
    800041aa:	fd3a91e3          	bne	s5,s3,8000416c <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041ae:	21c48513          	addi	a0,s1,540
    800041b2:	ffffd097          	auipc	ra,0xffffd
    800041b6:	676080e7          	jalr	1654(ra) # 80001828 <wakeup>
  release(&pi->lock);
    800041ba:	8526                	mv	a0,s1
    800041bc:	00002097          	auipc	ra,0x2
    800041c0:	1fa080e7          	jalr	506(ra) # 800063b6 <release>
  return i;
}
    800041c4:	854e                	mv	a0,s3
    800041c6:	60a6                	ld	ra,72(sp)
    800041c8:	6406                	ld	s0,64(sp)
    800041ca:	74e2                	ld	s1,56(sp)
    800041cc:	7942                	ld	s2,48(sp)
    800041ce:	79a2                	ld	s3,40(sp)
    800041d0:	7a02                	ld	s4,32(sp)
    800041d2:	6ae2                	ld	s5,24(sp)
    800041d4:	6b42                	ld	s6,16(sp)
    800041d6:	6161                	addi	sp,sp,80
    800041d8:	8082                	ret
      release(&pi->lock);
    800041da:	8526                	mv	a0,s1
    800041dc:	00002097          	auipc	ra,0x2
    800041e0:	1da080e7          	jalr	474(ra) # 800063b6 <release>
      return -1;
    800041e4:	59fd                	li	s3,-1
    800041e6:	bff9                	j	800041c4 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041e8:	4981                	li	s3,0
    800041ea:	b7d1                	j	800041ae <piperead+0xae>

00000000800041ec <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800041ec:	df010113          	addi	sp,sp,-528
    800041f0:	20113423          	sd	ra,520(sp)
    800041f4:	20813023          	sd	s0,512(sp)
    800041f8:	ffa6                	sd	s1,504(sp)
    800041fa:	fbca                	sd	s2,496(sp)
    800041fc:	f7ce                	sd	s3,488(sp)
    800041fe:	f3d2                	sd	s4,480(sp)
    80004200:	efd6                	sd	s5,472(sp)
    80004202:	ebda                	sd	s6,464(sp)
    80004204:	e7de                	sd	s7,456(sp)
    80004206:	e3e2                	sd	s8,448(sp)
    80004208:	ff66                	sd	s9,440(sp)
    8000420a:	fb6a                	sd	s10,432(sp)
    8000420c:	f76e                	sd	s11,424(sp)
    8000420e:	0c00                	addi	s0,sp,528
    80004210:	84aa                	mv	s1,a0
    80004212:	dea43c23          	sd	a0,-520(s0)
    80004216:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000421a:	ffffd097          	auipc	ra,0xffffd
    8000421e:	d10080e7          	jalr	-752(ra) # 80000f2a <myproc>
    80004222:	892a                	mv	s2,a0

  begin_op();
    80004224:	fffff097          	auipc	ra,0xfffff
    80004228:	49c080e7          	jalr	1180(ra) # 800036c0 <begin_op>

  if((ip = namei(path)) == 0){
    8000422c:	8526                	mv	a0,s1
    8000422e:	fffff097          	auipc	ra,0xfffff
    80004232:	276080e7          	jalr	630(ra) # 800034a4 <namei>
    80004236:	c92d                	beqz	a0,800042a8 <exec+0xbc>
    80004238:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000423a:	fffff097          	auipc	ra,0xfffff
    8000423e:	ab4080e7          	jalr	-1356(ra) # 80002cee <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004242:	04000713          	li	a4,64
    80004246:	4681                	li	a3,0
    80004248:	e5040613          	addi	a2,s0,-432
    8000424c:	4581                	li	a1,0
    8000424e:	8526                	mv	a0,s1
    80004250:	fffff097          	auipc	ra,0xfffff
    80004254:	d52080e7          	jalr	-686(ra) # 80002fa2 <readi>
    80004258:	04000793          	li	a5,64
    8000425c:	00f51a63          	bne	a0,a5,80004270 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004260:	e5042703          	lw	a4,-432(s0)
    80004264:	464c47b7          	lui	a5,0x464c4
    80004268:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000426c:	04f70463          	beq	a4,a5,800042b4 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004270:	8526                	mv	a0,s1
    80004272:	fffff097          	auipc	ra,0xfffff
    80004276:	cde080e7          	jalr	-802(ra) # 80002f50 <iunlockput>
    end_op();
    8000427a:	fffff097          	auipc	ra,0xfffff
    8000427e:	4c6080e7          	jalr	1222(ra) # 80003740 <end_op>
  }
  return -1;
    80004282:	557d                	li	a0,-1
}
    80004284:	20813083          	ld	ra,520(sp)
    80004288:	20013403          	ld	s0,512(sp)
    8000428c:	74fe                	ld	s1,504(sp)
    8000428e:	795e                	ld	s2,496(sp)
    80004290:	79be                	ld	s3,488(sp)
    80004292:	7a1e                	ld	s4,480(sp)
    80004294:	6afe                	ld	s5,472(sp)
    80004296:	6b5e                	ld	s6,464(sp)
    80004298:	6bbe                	ld	s7,456(sp)
    8000429a:	6c1e                	ld	s8,448(sp)
    8000429c:	7cfa                	ld	s9,440(sp)
    8000429e:	7d5a                	ld	s10,432(sp)
    800042a0:	7dba                	ld	s11,424(sp)
    800042a2:	21010113          	addi	sp,sp,528
    800042a6:	8082                	ret
    end_op();
    800042a8:	fffff097          	auipc	ra,0xfffff
    800042ac:	498080e7          	jalr	1176(ra) # 80003740 <end_op>
    return -1;
    800042b0:	557d                	li	a0,-1
    800042b2:	bfc9                	j	80004284 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800042b4:	854a                	mv	a0,s2
    800042b6:	ffffd097          	auipc	ra,0xffffd
    800042ba:	d38080e7          	jalr	-712(ra) # 80000fee <proc_pagetable>
    800042be:	8baa                	mv	s7,a0
    800042c0:	d945                	beqz	a0,80004270 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042c2:	e7042983          	lw	s3,-400(s0)
    800042c6:	e8845783          	lhu	a5,-376(s0)
    800042ca:	c7ad                	beqz	a5,80004334 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042cc:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042ce:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800042d0:	6c85                	lui	s9,0x1
    800042d2:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042d6:	def43823          	sd	a5,-528(s0)
    800042da:	a481                	j	8000451a <exec+0x32e>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800042dc:	00004517          	auipc	a0,0x4
    800042e0:	3e450513          	addi	a0,a0,996 # 800086c0 <syscalls+0x2c8>
    800042e4:	00002097          	auipc	ra,0x2
    800042e8:	ad4080e7          	jalr	-1324(ra) # 80005db8 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042ec:	8756                	mv	a4,s5
    800042ee:	012d86bb          	addw	a3,s11,s2
    800042f2:	4581                	li	a1,0
    800042f4:	8526                	mv	a0,s1
    800042f6:	fffff097          	auipc	ra,0xfffff
    800042fa:	cac080e7          	jalr	-852(ra) # 80002fa2 <readi>
    800042fe:	2501                	sext.w	a0,a0
    80004300:	1caa9463          	bne	s5,a0,800044c8 <exec+0x2dc>
  for(i = 0; i < sz; i += PGSIZE){
    80004304:	6785                	lui	a5,0x1
    80004306:	0127893b          	addw	s2,a5,s2
    8000430a:	77fd                	lui	a5,0xfffff
    8000430c:	01478a3b          	addw	s4,a5,s4
    80004310:	1f897c63          	bgeu	s2,s8,80004508 <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    80004314:	02091593          	slli	a1,s2,0x20
    80004318:	9181                	srli	a1,a1,0x20
    8000431a:	95ea                	add	a1,a1,s10
    8000431c:	855e                	mv	a0,s7
    8000431e:	ffffc097          	auipc	ra,0xffffc
    80004322:	29a080e7          	jalr	666(ra) # 800005b8 <walkaddr>
    80004326:	862a                	mv	a2,a0
    if(pa == 0)
    80004328:	d955                	beqz	a0,800042dc <exec+0xf0>
      n = PGSIZE;
    8000432a:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000432c:	fd9a70e3          	bgeu	s4,s9,800042ec <exec+0x100>
      n = sz - i;
    80004330:	8ad2                	mv	s5,s4
    80004332:	bf6d                	j	800042ec <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004334:	4901                	li	s2,0
  iunlockput(ip);
    80004336:	8526                	mv	a0,s1
    80004338:	fffff097          	auipc	ra,0xfffff
    8000433c:	c18080e7          	jalr	-1000(ra) # 80002f50 <iunlockput>
  end_op();
    80004340:	fffff097          	auipc	ra,0xfffff
    80004344:	400080e7          	jalr	1024(ra) # 80003740 <end_op>
  p = myproc();
    80004348:	ffffd097          	auipc	ra,0xffffd
    8000434c:	be2080e7          	jalr	-1054(ra) # 80000f2a <myproc>
    80004350:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004352:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004356:	6785                	lui	a5,0x1
    80004358:	17fd                	addi	a5,a5,-1
    8000435a:	993e                	add	s2,s2,a5
    8000435c:	757d                	lui	a0,0xfffff
    8000435e:	00a977b3          	and	a5,s2,a0
    80004362:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004366:	6609                	lui	a2,0x2
    80004368:	963e                	add	a2,a2,a5
    8000436a:	85be                	mv	a1,a5
    8000436c:	855e                	mv	a0,s7
    8000436e:	ffffc097          	auipc	ra,0xffffc
    80004372:	5fe080e7          	jalr	1534(ra) # 8000096c <uvmalloc>
    80004376:	8b2a                	mv	s6,a0
  ip = 0;
    80004378:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000437a:	14050763          	beqz	a0,800044c8 <exec+0x2dc>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000437e:	75f9                	lui	a1,0xffffe
    80004380:	95aa                	add	a1,a1,a0
    80004382:	855e                	mv	a0,s7
    80004384:	ffffd097          	auipc	ra,0xffffd
    80004388:	806080e7          	jalr	-2042(ra) # 80000b8a <uvmclear>
  stackbase = sp - PGSIZE;
    8000438c:	7c7d                	lui	s8,0xfffff
    8000438e:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004390:	e0043783          	ld	a5,-512(s0)
    80004394:	6388                	ld	a0,0(a5)
    80004396:	c535                	beqz	a0,80004402 <exec+0x216>
    80004398:	e9040993          	addi	s3,s0,-368
    8000439c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043a0:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800043a2:	ffffc097          	auipc	ra,0xffffc
    800043a6:	f5a080e7          	jalr	-166(ra) # 800002fc <strlen>
    800043aa:	2505                	addiw	a0,a0,1
    800043ac:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043b0:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800043b4:	13896e63          	bltu	s2,s8,800044f0 <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043b8:	e0043d83          	ld	s11,-512(s0)
    800043bc:	000dba03          	ld	s4,0(s11)
    800043c0:	8552                	mv	a0,s4
    800043c2:	ffffc097          	auipc	ra,0xffffc
    800043c6:	f3a080e7          	jalr	-198(ra) # 800002fc <strlen>
    800043ca:	0015069b          	addiw	a3,a0,1
    800043ce:	8652                	mv	a2,s4
    800043d0:	85ca                	mv	a1,s2
    800043d2:	855e                	mv	a0,s7
    800043d4:	ffffc097          	auipc	ra,0xffffc
    800043d8:	7e8080e7          	jalr	2024(ra) # 80000bbc <copyout>
    800043dc:	10054e63          	bltz	a0,800044f8 <exec+0x30c>
    ustack[argc] = sp;
    800043e0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043e4:	0485                	addi	s1,s1,1
    800043e6:	008d8793          	addi	a5,s11,8
    800043ea:	e0f43023          	sd	a5,-512(s0)
    800043ee:	008db503          	ld	a0,8(s11)
    800043f2:	c911                	beqz	a0,80004406 <exec+0x21a>
    if(argc >= MAXARG)
    800043f4:	09a1                	addi	s3,s3,8
    800043f6:	fb3c96e3          	bne	s9,s3,800043a2 <exec+0x1b6>
  sz = sz1;
    800043fa:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043fe:	4481                	li	s1,0
    80004400:	a0e1                	j	800044c8 <exec+0x2dc>
  sp = sz;
    80004402:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004404:	4481                	li	s1,0
  ustack[argc] = 0;
    80004406:	00349793          	slli	a5,s1,0x3
    8000440a:	f9040713          	addi	a4,s0,-112
    8000440e:	97ba                	add	a5,a5,a4
    80004410:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004414:	00148693          	addi	a3,s1,1
    80004418:	068e                	slli	a3,a3,0x3
    8000441a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000441e:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004422:	01897663          	bgeu	s2,s8,8000442e <exec+0x242>
  sz = sz1;
    80004426:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000442a:	4481                	li	s1,0
    8000442c:	a871                	j	800044c8 <exec+0x2dc>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000442e:	e9040613          	addi	a2,s0,-368
    80004432:	85ca                	mv	a1,s2
    80004434:	855e                	mv	a0,s7
    80004436:	ffffc097          	auipc	ra,0xffffc
    8000443a:	786080e7          	jalr	1926(ra) # 80000bbc <copyout>
    8000443e:	0c054163          	bltz	a0,80004500 <exec+0x314>
  p->trapframe->a1 = sp;
    80004442:	058ab783          	ld	a5,88(s5)
    80004446:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000444a:	df843783          	ld	a5,-520(s0)
    8000444e:	0007c703          	lbu	a4,0(a5)
    80004452:	cf11                	beqz	a4,8000446e <exec+0x282>
    80004454:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004456:	02f00693          	li	a3,47
    8000445a:	a039                	j	80004468 <exec+0x27c>
      last = s+1;
    8000445c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004460:	0785                	addi	a5,a5,1
    80004462:	fff7c703          	lbu	a4,-1(a5)
    80004466:	c701                	beqz	a4,8000446e <exec+0x282>
    if(*s == '/')
    80004468:	fed71ce3          	bne	a4,a3,80004460 <exec+0x274>
    8000446c:	bfc5                	j	8000445c <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    8000446e:	4641                	li	a2,16
    80004470:	df843583          	ld	a1,-520(s0)
    80004474:	158a8513          	addi	a0,s5,344
    80004478:	ffffc097          	auipc	ra,0xffffc
    8000447c:	e52080e7          	jalr	-430(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004480:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004484:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004488:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000448c:	058ab783          	ld	a5,88(s5)
    80004490:	e6843703          	ld	a4,-408(s0)
    80004494:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004496:	058ab783          	ld	a5,88(s5)
    8000449a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000449e:	85ea                	mv	a1,s10
    800044a0:	ffffd097          	auipc	ra,0xffffd
    800044a4:	c6a080e7          	jalr	-918(ra) # 8000110a <proc_freepagetable>
  if(p->pid == 1)
    800044a8:	030aa703          	lw	a4,48(s5)
    800044ac:	4785                	li	a5,1
    800044ae:	00f70563          	beq	a4,a5,800044b8 <exec+0x2cc>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044b2:	0004851b          	sext.w	a0,s1
    800044b6:	b3f9                	j	80004284 <exec+0x98>
      vmprint(pagetable);
    800044b8:	855e                	mv	a0,s7
    800044ba:	ffffd097          	auipc	ra,0xffffd
    800044be:	8ce080e7          	jalr	-1842(ra) # 80000d88 <vmprint>
    800044c2:	bfc5                	j	800044b2 <exec+0x2c6>
    800044c4:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800044c8:	e0843583          	ld	a1,-504(s0)
    800044cc:	855e                	mv	a0,s7
    800044ce:	ffffd097          	auipc	ra,0xffffd
    800044d2:	c3c080e7          	jalr	-964(ra) # 8000110a <proc_freepagetable>
  if(ip){
    800044d6:	d8049de3          	bnez	s1,80004270 <exec+0x84>
  return -1;
    800044da:	557d                	li	a0,-1
    800044dc:	b365                	j	80004284 <exec+0x98>
    800044de:	e1243423          	sd	s2,-504(s0)
    800044e2:	b7dd                	j	800044c8 <exec+0x2dc>
    800044e4:	e1243423          	sd	s2,-504(s0)
    800044e8:	b7c5                	j	800044c8 <exec+0x2dc>
    800044ea:	e1243423          	sd	s2,-504(s0)
    800044ee:	bfe9                	j	800044c8 <exec+0x2dc>
  sz = sz1;
    800044f0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044f4:	4481                	li	s1,0
    800044f6:	bfc9                	j	800044c8 <exec+0x2dc>
  sz = sz1;
    800044f8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044fc:	4481                	li	s1,0
    800044fe:	b7e9                	j	800044c8 <exec+0x2dc>
  sz = sz1;
    80004500:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004504:	4481                	li	s1,0
    80004506:	b7c9                	j	800044c8 <exec+0x2dc>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004508:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000450c:	2b05                	addiw	s6,s6,1
    8000450e:	0389899b          	addiw	s3,s3,56
    80004512:	e8845783          	lhu	a5,-376(s0)
    80004516:	e2fb50e3          	bge	s6,a5,80004336 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000451a:	2981                	sext.w	s3,s3
    8000451c:	03800713          	li	a4,56
    80004520:	86ce                	mv	a3,s3
    80004522:	e1840613          	addi	a2,s0,-488
    80004526:	4581                	li	a1,0
    80004528:	8526                	mv	a0,s1
    8000452a:	fffff097          	auipc	ra,0xfffff
    8000452e:	a78080e7          	jalr	-1416(ra) # 80002fa2 <readi>
    80004532:	03800793          	li	a5,56
    80004536:	f8f517e3          	bne	a0,a5,800044c4 <exec+0x2d8>
    if(ph.type != ELF_PROG_LOAD)
    8000453a:	e1842783          	lw	a5,-488(s0)
    8000453e:	4705                	li	a4,1
    80004540:	fce796e3          	bne	a5,a4,8000450c <exec+0x320>
    if(ph.memsz < ph.filesz)
    80004544:	e4043603          	ld	a2,-448(s0)
    80004548:	e3843783          	ld	a5,-456(s0)
    8000454c:	f8f669e3          	bltu	a2,a5,800044de <exec+0x2f2>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004550:	e2843783          	ld	a5,-472(s0)
    80004554:	963e                	add	a2,a2,a5
    80004556:	f8f667e3          	bltu	a2,a5,800044e4 <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000455a:	85ca                	mv	a1,s2
    8000455c:	855e                	mv	a0,s7
    8000455e:	ffffc097          	auipc	ra,0xffffc
    80004562:	40e080e7          	jalr	1038(ra) # 8000096c <uvmalloc>
    80004566:	e0a43423          	sd	a0,-504(s0)
    8000456a:	d141                	beqz	a0,800044ea <exec+0x2fe>
    if((ph.vaddr % PGSIZE) != 0)
    8000456c:	e2843d03          	ld	s10,-472(s0)
    80004570:	df043783          	ld	a5,-528(s0)
    80004574:	00fd77b3          	and	a5,s10,a5
    80004578:	fba1                	bnez	a5,800044c8 <exec+0x2dc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000457a:	e2042d83          	lw	s11,-480(s0)
    8000457e:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004582:	f80c03e3          	beqz	s8,80004508 <exec+0x31c>
    80004586:	8a62                	mv	s4,s8
    80004588:	4901                	li	s2,0
    8000458a:	b369                	j	80004314 <exec+0x128>

000000008000458c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000458c:	7179                	addi	sp,sp,-48
    8000458e:	f406                	sd	ra,40(sp)
    80004590:	f022                	sd	s0,32(sp)
    80004592:	ec26                	sd	s1,24(sp)
    80004594:	e84a                	sd	s2,16(sp)
    80004596:	1800                	addi	s0,sp,48
    80004598:	892e                	mv	s2,a1
    8000459a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000459c:	fdc40593          	addi	a1,s0,-36
    800045a0:	ffffe097          	auipc	ra,0xffffe
    800045a4:	aec080e7          	jalr	-1300(ra) # 8000208c <argint>
    800045a8:	04054063          	bltz	a0,800045e8 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045ac:	fdc42703          	lw	a4,-36(s0)
    800045b0:	47bd                	li	a5,15
    800045b2:	02e7ed63          	bltu	a5,a4,800045ec <argfd+0x60>
    800045b6:	ffffd097          	auipc	ra,0xffffd
    800045ba:	974080e7          	jalr	-1676(ra) # 80000f2a <myproc>
    800045be:	fdc42703          	lw	a4,-36(s0)
    800045c2:	01a70793          	addi	a5,a4,26
    800045c6:	078e                	slli	a5,a5,0x3
    800045c8:	953e                	add	a0,a0,a5
    800045ca:	611c                	ld	a5,0(a0)
    800045cc:	c395                	beqz	a5,800045f0 <argfd+0x64>
    return -1;
  if(pfd)
    800045ce:	00090463          	beqz	s2,800045d6 <argfd+0x4a>
    *pfd = fd;
    800045d2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045d6:	4501                	li	a0,0
  if(pf)
    800045d8:	c091                	beqz	s1,800045dc <argfd+0x50>
    *pf = f;
    800045da:	e09c                	sd	a5,0(s1)
}
    800045dc:	70a2                	ld	ra,40(sp)
    800045de:	7402                	ld	s0,32(sp)
    800045e0:	64e2                	ld	s1,24(sp)
    800045e2:	6942                	ld	s2,16(sp)
    800045e4:	6145                	addi	sp,sp,48
    800045e6:	8082                	ret
    return -1;
    800045e8:	557d                	li	a0,-1
    800045ea:	bfcd                	j	800045dc <argfd+0x50>
    return -1;
    800045ec:	557d                	li	a0,-1
    800045ee:	b7fd                	j	800045dc <argfd+0x50>
    800045f0:	557d                	li	a0,-1
    800045f2:	b7ed                	j	800045dc <argfd+0x50>

00000000800045f4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045f4:	1101                	addi	sp,sp,-32
    800045f6:	ec06                	sd	ra,24(sp)
    800045f8:	e822                	sd	s0,16(sp)
    800045fa:	e426                	sd	s1,8(sp)
    800045fc:	1000                	addi	s0,sp,32
    800045fe:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004600:	ffffd097          	auipc	ra,0xffffd
    80004604:	92a080e7          	jalr	-1750(ra) # 80000f2a <myproc>
    80004608:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000460a:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    8000460e:	4501                	li	a0,0
    80004610:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004612:	6398                	ld	a4,0(a5)
    80004614:	cb19                	beqz	a4,8000462a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004616:	2505                	addiw	a0,a0,1
    80004618:	07a1                	addi	a5,a5,8
    8000461a:	fed51ce3          	bne	a0,a3,80004612 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000461e:	557d                	li	a0,-1
}
    80004620:	60e2                	ld	ra,24(sp)
    80004622:	6442                	ld	s0,16(sp)
    80004624:	64a2                	ld	s1,8(sp)
    80004626:	6105                	addi	sp,sp,32
    80004628:	8082                	ret
      p->ofile[fd] = f;
    8000462a:	01a50793          	addi	a5,a0,26
    8000462e:	078e                	slli	a5,a5,0x3
    80004630:	963e                	add	a2,a2,a5
    80004632:	e204                	sd	s1,0(a2)
      return fd;
    80004634:	b7f5                	j	80004620 <fdalloc+0x2c>

0000000080004636 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004636:	715d                	addi	sp,sp,-80
    80004638:	e486                	sd	ra,72(sp)
    8000463a:	e0a2                	sd	s0,64(sp)
    8000463c:	fc26                	sd	s1,56(sp)
    8000463e:	f84a                	sd	s2,48(sp)
    80004640:	f44e                	sd	s3,40(sp)
    80004642:	f052                	sd	s4,32(sp)
    80004644:	ec56                	sd	s5,24(sp)
    80004646:	0880                	addi	s0,sp,80
    80004648:	89ae                	mv	s3,a1
    8000464a:	8ab2                	mv	s5,a2
    8000464c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000464e:	fb040593          	addi	a1,s0,-80
    80004652:	fffff097          	auipc	ra,0xfffff
    80004656:	e70080e7          	jalr	-400(ra) # 800034c2 <nameiparent>
    8000465a:	892a                	mv	s2,a0
    8000465c:	12050f63          	beqz	a0,8000479a <create+0x164>
    return 0;

  ilock(dp);
    80004660:	ffffe097          	auipc	ra,0xffffe
    80004664:	68e080e7          	jalr	1678(ra) # 80002cee <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004668:	4601                	li	a2,0
    8000466a:	fb040593          	addi	a1,s0,-80
    8000466e:	854a                	mv	a0,s2
    80004670:	fffff097          	auipc	ra,0xfffff
    80004674:	b62080e7          	jalr	-1182(ra) # 800031d2 <dirlookup>
    80004678:	84aa                	mv	s1,a0
    8000467a:	c921                	beqz	a0,800046ca <create+0x94>
    iunlockput(dp);
    8000467c:	854a                	mv	a0,s2
    8000467e:	fffff097          	auipc	ra,0xfffff
    80004682:	8d2080e7          	jalr	-1838(ra) # 80002f50 <iunlockput>
    ilock(ip);
    80004686:	8526                	mv	a0,s1
    80004688:	ffffe097          	auipc	ra,0xffffe
    8000468c:	666080e7          	jalr	1638(ra) # 80002cee <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004690:	2981                	sext.w	s3,s3
    80004692:	4789                	li	a5,2
    80004694:	02f99463          	bne	s3,a5,800046bc <create+0x86>
    80004698:	0444d783          	lhu	a5,68(s1)
    8000469c:	37f9                	addiw	a5,a5,-2
    8000469e:	17c2                	slli	a5,a5,0x30
    800046a0:	93c1                	srli	a5,a5,0x30
    800046a2:	4705                	li	a4,1
    800046a4:	00f76c63          	bltu	a4,a5,800046bc <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800046a8:	8526                	mv	a0,s1
    800046aa:	60a6                	ld	ra,72(sp)
    800046ac:	6406                	ld	s0,64(sp)
    800046ae:	74e2                	ld	s1,56(sp)
    800046b0:	7942                	ld	s2,48(sp)
    800046b2:	79a2                	ld	s3,40(sp)
    800046b4:	7a02                	ld	s4,32(sp)
    800046b6:	6ae2                	ld	s5,24(sp)
    800046b8:	6161                	addi	sp,sp,80
    800046ba:	8082                	ret
    iunlockput(ip);
    800046bc:	8526                	mv	a0,s1
    800046be:	fffff097          	auipc	ra,0xfffff
    800046c2:	892080e7          	jalr	-1902(ra) # 80002f50 <iunlockput>
    return 0;
    800046c6:	4481                	li	s1,0
    800046c8:	b7c5                	j	800046a8 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800046ca:	85ce                	mv	a1,s3
    800046cc:	00092503          	lw	a0,0(s2)
    800046d0:	ffffe097          	auipc	ra,0xffffe
    800046d4:	486080e7          	jalr	1158(ra) # 80002b56 <ialloc>
    800046d8:	84aa                	mv	s1,a0
    800046da:	c529                	beqz	a0,80004724 <create+0xee>
  ilock(ip);
    800046dc:	ffffe097          	auipc	ra,0xffffe
    800046e0:	612080e7          	jalr	1554(ra) # 80002cee <ilock>
  ip->major = major;
    800046e4:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800046e8:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800046ec:	4785                	li	a5,1
    800046ee:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800046f2:	8526                	mv	a0,s1
    800046f4:	ffffe097          	auipc	ra,0xffffe
    800046f8:	530080e7          	jalr	1328(ra) # 80002c24 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046fc:	2981                	sext.w	s3,s3
    800046fe:	4785                	li	a5,1
    80004700:	02f98a63          	beq	s3,a5,80004734 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004704:	40d0                	lw	a2,4(s1)
    80004706:	fb040593          	addi	a1,s0,-80
    8000470a:	854a                	mv	a0,s2
    8000470c:	fffff097          	auipc	ra,0xfffff
    80004710:	cd6080e7          	jalr	-810(ra) # 800033e2 <dirlink>
    80004714:	06054b63          	bltz	a0,8000478a <create+0x154>
  iunlockput(dp);
    80004718:	854a                	mv	a0,s2
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	836080e7          	jalr	-1994(ra) # 80002f50 <iunlockput>
  return ip;
    80004722:	b759                	j	800046a8 <create+0x72>
    panic("create: ialloc");
    80004724:	00004517          	auipc	a0,0x4
    80004728:	fbc50513          	addi	a0,a0,-68 # 800086e0 <syscalls+0x2e8>
    8000472c:	00001097          	auipc	ra,0x1
    80004730:	68c080e7          	jalr	1676(ra) # 80005db8 <panic>
    dp->nlink++;  // for ".."
    80004734:	04a95783          	lhu	a5,74(s2)
    80004738:	2785                	addiw	a5,a5,1
    8000473a:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000473e:	854a                	mv	a0,s2
    80004740:	ffffe097          	auipc	ra,0xffffe
    80004744:	4e4080e7          	jalr	1252(ra) # 80002c24 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004748:	40d0                	lw	a2,4(s1)
    8000474a:	00004597          	auipc	a1,0x4
    8000474e:	fa658593          	addi	a1,a1,-90 # 800086f0 <syscalls+0x2f8>
    80004752:	8526                	mv	a0,s1
    80004754:	fffff097          	auipc	ra,0xfffff
    80004758:	c8e080e7          	jalr	-882(ra) # 800033e2 <dirlink>
    8000475c:	00054f63          	bltz	a0,8000477a <create+0x144>
    80004760:	00492603          	lw	a2,4(s2)
    80004764:	00004597          	auipc	a1,0x4
    80004768:	f9458593          	addi	a1,a1,-108 # 800086f8 <syscalls+0x300>
    8000476c:	8526                	mv	a0,s1
    8000476e:	fffff097          	auipc	ra,0xfffff
    80004772:	c74080e7          	jalr	-908(ra) # 800033e2 <dirlink>
    80004776:	f80557e3          	bgez	a0,80004704 <create+0xce>
      panic("create dots");
    8000477a:	00004517          	auipc	a0,0x4
    8000477e:	f8650513          	addi	a0,a0,-122 # 80008700 <syscalls+0x308>
    80004782:	00001097          	auipc	ra,0x1
    80004786:	636080e7          	jalr	1590(ra) # 80005db8 <panic>
    panic("create: dirlink");
    8000478a:	00004517          	auipc	a0,0x4
    8000478e:	f8650513          	addi	a0,a0,-122 # 80008710 <syscalls+0x318>
    80004792:	00001097          	auipc	ra,0x1
    80004796:	626080e7          	jalr	1574(ra) # 80005db8 <panic>
    return 0;
    8000479a:	84aa                	mv	s1,a0
    8000479c:	b731                	j	800046a8 <create+0x72>

000000008000479e <sys_dup>:
{
    8000479e:	7179                	addi	sp,sp,-48
    800047a0:	f406                	sd	ra,40(sp)
    800047a2:	f022                	sd	s0,32(sp)
    800047a4:	ec26                	sd	s1,24(sp)
    800047a6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047a8:	fd840613          	addi	a2,s0,-40
    800047ac:	4581                	li	a1,0
    800047ae:	4501                	li	a0,0
    800047b0:	00000097          	auipc	ra,0x0
    800047b4:	ddc080e7          	jalr	-548(ra) # 8000458c <argfd>
    return -1;
    800047b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047ba:	02054363          	bltz	a0,800047e0 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800047be:	fd843503          	ld	a0,-40(s0)
    800047c2:	00000097          	auipc	ra,0x0
    800047c6:	e32080e7          	jalr	-462(ra) # 800045f4 <fdalloc>
    800047ca:	84aa                	mv	s1,a0
    return -1;
    800047cc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047ce:	00054963          	bltz	a0,800047e0 <sys_dup+0x42>
  filedup(f);
    800047d2:	fd843503          	ld	a0,-40(s0)
    800047d6:	fffff097          	auipc	ra,0xfffff
    800047da:	364080e7          	jalr	868(ra) # 80003b3a <filedup>
  return fd;
    800047de:	87a6                	mv	a5,s1
}
    800047e0:	853e                	mv	a0,a5
    800047e2:	70a2                	ld	ra,40(sp)
    800047e4:	7402                	ld	s0,32(sp)
    800047e6:	64e2                	ld	s1,24(sp)
    800047e8:	6145                	addi	sp,sp,48
    800047ea:	8082                	ret

00000000800047ec <sys_read>:
{
    800047ec:	7179                	addi	sp,sp,-48
    800047ee:	f406                	sd	ra,40(sp)
    800047f0:	f022                	sd	s0,32(sp)
    800047f2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047f4:	fe840613          	addi	a2,s0,-24
    800047f8:	4581                	li	a1,0
    800047fa:	4501                	li	a0,0
    800047fc:	00000097          	auipc	ra,0x0
    80004800:	d90080e7          	jalr	-624(ra) # 8000458c <argfd>
    return -1;
    80004804:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004806:	04054163          	bltz	a0,80004848 <sys_read+0x5c>
    8000480a:	fe440593          	addi	a1,s0,-28
    8000480e:	4509                	li	a0,2
    80004810:	ffffe097          	auipc	ra,0xffffe
    80004814:	87c080e7          	jalr	-1924(ra) # 8000208c <argint>
    return -1;
    80004818:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000481a:	02054763          	bltz	a0,80004848 <sys_read+0x5c>
    8000481e:	fd840593          	addi	a1,s0,-40
    80004822:	4505                	li	a0,1
    80004824:	ffffe097          	auipc	ra,0xffffe
    80004828:	88a080e7          	jalr	-1910(ra) # 800020ae <argaddr>
    return -1;
    8000482c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000482e:	00054d63          	bltz	a0,80004848 <sys_read+0x5c>
  return fileread(f, p, n);
    80004832:	fe442603          	lw	a2,-28(s0)
    80004836:	fd843583          	ld	a1,-40(s0)
    8000483a:	fe843503          	ld	a0,-24(s0)
    8000483e:	fffff097          	auipc	ra,0xfffff
    80004842:	488080e7          	jalr	1160(ra) # 80003cc6 <fileread>
    80004846:	87aa                	mv	a5,a0
}
    80004848:	853e                	mv	a0,a5
    8000484a:	70a2                	ld	ra,40(sp)
    8000484c:	7402                	ld	s0,32(sp)
    8000484e:	6145                	addi	sp,sp,48
    80004850:	8082                	ret

0000000080004852 <sys_write>:
{
    80004852:	7179                	addi	sp,sp,-48
    80004854:	f406                	sd	ra,40(sp)
    80004856:	f022                	sd	s0,32(sp)
    80004858:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000485a:	fe840613          	addi	a2,s0,-24
    8000485e:	4581                	li	a1,0
    80004860:	4501                	li	a0,0
    80004862:	00000097          	auipc	ra,0x0
    80004866:	d2a080e7          	jalr	-726(ra) # 8000458c <argfd>
    return -1;
    8000486a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000486c:	04054163          	bltz	a0,800048ae <sys_write+0x5c>
    80004870:	fe440593          	addi	a1,s0,-28
    80004874:	4509                	li	a0,2
    80004876:	ffffe097          	auipc	ra,0xffffe
    8000487a:	816080e7          	jalr	-2026(ra) # 8000208c <argint>
    return -1;
    8000487e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004880:	02054763          	bltz	a0,800048ae <sys_write+0x5c>
    80004884:	fd840593          	addi	a1,s0,-40
    80004888:	4505                	li	a0,1
    8000488a:	ffffe097          	auipc	ra,0xffffe
    8000488e:	824080e7          	jalr	-2012(ra) # 800020ae <argaddr>
    return -1;
    80004892:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004894:	00054d63          	bltz	a0,800048ae <sys_write+0x5c>
  return filewrite(f, p, n);
    80004898:	fe442603          	lw	a2,-28(s0)
    8000489c:	fd843583          	ld	a1,-40(s0)
    800048a0:	fe843503          	ld	a0,-24(s0)
    800048a4:	fffff097          	auipc	ra,0xfffff
    800048a8:	4e4080e7          	jalr	1252(ra) # 80003d88 <filewrite>
    800048ac:	87aa                	mv	a5,a0
}
    800048ae:	853e                	mv	a0,a5
    800048b0:	70a2                	ld	ra,40(sp)
    800048b2:	7402                	ld	s0,32(sp)
    800048b4:	6145                	addi	sp,sp,48
    800048b6:	8082                	ret

00000000800048b8 <sys_close>:
{
    800048b8:	1101                	addi	sp,sp,-32
    800048ba:	ec06                	sd	ra,24(sp)
    800048bc:	e822                	sd	s0,16(sp)
    800048be:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048c0:	fe040613          	addi	a2,s0,-32
    800048c4:	fec40593          	addi	a1,s0,-20
    800048c8:	4501                	li	a0,0
    800048ca:	00000097          	auipc	ra,0x0
    800048ce:	cc2080e7          	jalr	-830(ra) # 8000458c <argfd>
    return -1;
    800048d2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048d4:	02054463          	bltz	a0,800048fc <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048d8:	ffffc097          	auipc	ra,0xffffc
    800048dc:	652080e7          	jalr	1618(ra) # 80000f2a <myproc>
    800048e0:	fec42783          	lw	a5,-20(s0)
    800048e4:	07e9                	addi	a5,a5,26
    800048e6:	078e                	slli	a5,a5,0x3
    800048e8:	97aa                	add	a5,a5,a0
    800048ea:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800048ee:	fe043503          	ld	a0,-32(s0)
    800048f2:	fffff097          	auipc	ra,0xfffff
    800048f6:	29a080e7          	jalr	666(ra) # 80003b8c <fileclose>
  return 0;
    800048fa:	4781                	li	a5,0
}
    800048fc:	853e                	mv	a0,a5
    800048fe:	60e2                	ld	ra,24(sp)
    80004900:	6442                	ld	s0,16(sp)
    80004902:	6105                	addi	sp,sp,32
    80004904:	8082                	ret

0000000080004906 <sys_fstat>:
{
    80004906:	1101                	addi	sp,sp,-32
    80004908:	ec06                	sd	ra,24(sp)
    8000490a:	e822                	sd	s0,16(sp)
    8000490c:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000490e:	fe840613          	addi	a2,s0,-24
    80004912:	4581                	li	a1,0
    80004914:	4501                	li	a0,0
    80004916:	00000097          	auipc	ra,0x0
    8000491a:	c76080e7          	jalr	-906(ra) # 8000458c <argfd>
    return -1;
    8000491e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004920:	02054563          	bltz	a0,8000494a <sys_fstat+0x44>
    80004924:	fe040593          	addi	a1,s0,-32
    80004928:	4505                	li	a0,1
    8000492a:	ffffd097          	auipc	ra,0xffffd
    8000492e:	784080e7          	jalr	1924(ra) # 800020ae <argaddr>
    return -1;
    80004932:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004934:	00054b63          	bltz	a0,8000494a <sys_fstat+0x44>
  return filestat(f, st);
    80004938:	fe043583          	ld	a1,-32(s0)
    8000493c:	fe843503          	ld	a0,-24(s0)
    80004940:	fffff097          	auipc	ra,0xfffff
    80004944:	314080e7          	jalr	788(ra) # 80003c54 <filestat>
    80004948:	87aa                	mv	a5,a0
}
    8000494a:	853e                	mv	a0,a5
    8000494c:	60e2                	ld	ra,24(sp)
    8000494e:	6442                	ld	s0,16(sp)
    80004950:	6105                	addi	sp,sp,32
    80004952:	8082                	ret

0000000080004954 <sys_link>:
{
    80004954:	7169                	addi	sp,sp,-304
    80004956:	f606                	sd	ra,296(sp)
    80004958:	f222                	sd	s0,288(sp)
    8000495a:	ee26                	sd	s1,280(sp)
    8000495c:	ea4a                	sd	s2,272(sp)
    8000495e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004960:	08000613          	li	a2,128
    80004964:	ed040593          	addi	a1,s0,-304
    80004968:	4501                	li	a0,0
    8000496a:	ffffd097          	auipc	ra,0xffffd
    8000496e:	766080e7          	jalr	1894(ra) # 800020d0 <argstr>
    return -1;
    80004972:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004974:	10054e63          	bltz	a0,80004a90 <sys_link+0x13c>
    80004978:	08000613          	li	a2,128
    8000497c:	f5040593          	addi	a1,s0,-176
    80004980:	4505                	li	a0,1
    80004982:	ffffd097          	auipc	ra,0xffffd
    80004986:	74e080e7          	jalr	1870(ra) # 800020d0 <argstr>
    return -1;
    8000498a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000498c:	10054263          	bltz	a0,80004a90 <sys_link+0x13c>
  begin_op();
    80004990:	fffff097          	auipc	ra,0xfffff
    80004994:	d30080e7          	jalr	-720(ra) # 800036c0 <begin_op>
  if((ip = namei(old)) == 0){
    80004998:	ed040513          	addi	a0,s0,-304
    8000499c:	fffff097          	auipc	ra,0xfffff
    800049a0:	b08080e7          	jalr	-1272(ra) # 800034a4 <namei>
    800049a4:	84aa                	mv	s1,a0
    800049a6:	c551                	beqz	a0,80004a32 <sys_link+0xde>
  ilock(ip);
    800049a8:	ffffe097          	auipc	ra,0xffffe
    800049ac:	346080e7          	jalr	838(ra) # 80002cee <ilock>
  if(ip->type == T_DIR){
    800049b0:	04449703          	lh	a4,68(s1)
    800049b4:	4785                	li	a5,1
    800049b6:	08f70463          	beq	a4,a5,80004a3e <sys_link+0xea>
  ip->nlink++;
    800049ba:	04a4d783          	lhu	a5,74(s1)
    800049be:	2785                	addiw	a5,a5,1
    800049c0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049c4:	8526                	mv	a0,s1
    800049c6:	ffffe097          	auipc	ra,0xffffe
    800049ca:	25e080e7          	jalr	606(ra) # 80002c24 <iupdate>
  iunlock(ip);
    800049ce:	8526                	mv	a0,s1
    800049d0:	ffffe097          	auipc	ra,0xffffe
    800049d4:	3e0080e7          	jalr	992(ra) # 80002db0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049d8:	fd040593          	addi	a1,s0,-48
    800049dc:	f5040513          	addi	a0,s0,-176
    800049e0:	fffff097          	auipc	ra,0xfffff
    800049e4:	ae2080e7          	jalr	-1310(ra) # 800034c2 <nameiparent>
    800049e8:	892a                	mv	s2,a0
    800049ea:	c935                	beqz	a0,80004a5e <sys_link+0x10a>
  ilock(dp);
    800049ec:	ffffe097          	auipc	ra,0xffffe
    800049f0:	302080e7          	jalr	770(ra) # 80002cee <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049f4:	00092703          	lw	a4,0(s2)
    800049f8:	409c                	lw	a5,0(s1)
    800049fa:	04f71d63          	bne	a4,a5,80004a54 <sys_link+0x100>
    800049fe:	40d0                	lw	a2,4(s1)
    80004a00:	fd040593          	addi	a1,s0,-48
    80004a04:	854a                	mv	a0,s2
    80004a06:	fffff097          	auipc	ra,0xfffff
    80004a0a:	9dc080e7          	jalr	-1572(ra) # 800033e2 <dirlink>
    80004a0e:	04054363          	bltz	a0,80004a54 <sys_link+0x100>
  iunlockput(dp);
    80004a12:	854a                	mv	a0,s2
    80004a14:	ffffe097          	auipc	ra,0xffffe
    80004a18:	53c080e7          	jalr	1340(ra) # 80002f50 <iunlockput>
  iput(ip);
    80004a1c:	8526                	mv	a0,s1
    80004a1e:	ffffe097          	auipc	ra,0xffffe
    80004a22:	48a080e7          	jalr	1162(ra) # 80002ea8 <iput>
  end_op();
    80004a26:	fffff097          	auipc	ra,0xfffff
    80004a2a:	d1a080e7          	jalr	-742(ra) # 80003740 <end_op>
  return 0;
    80004a2e:	4781                	li	a5,0
    80004a30:	a085                	j	80004a90 <sys_link+0x13c>
    end_op();
    80004a32:	fffff097          	auipc	ra,0xfffff
    80004a36:	d0e080e7          	jalr	-754(ra) # 80003740 <end_op>
    return -1;
    80004a3a:	57fd                	li	a5,-1
    80004a3c:	a891                	j	80004a90 <sys_link+0x13c>
    iunlockput(ip);
    80004a3e:	8526                	mv	a0,s1
    80004a40:	ffffe097          	auipc	ra,0xffffe
    80004a44:	510080e7          	jalr	1296(ra) # 80002f50 <iunlockput>
    end_op();
    80004a48:	fffff097          	auipc	ra,0xfffff
    80004a4c:	cf8080e7          	jalr	-776(ra) # 80003740 <end_op>
    return -1;
    80004a50:	57fd                	li	a5,-1
    80004a52:	a83d                	j	80004a90 <sys_link+0x13c>
    iunlockput(dp);
    80004a54:	854a                	mv	a0,s2
    80004a56:	ffffe097          	auipc	ra,0xffffe
    80004a5a:	4fa080e7          	jalr	1274(ra) # 80002f50 <iunlockput>
  ilock(ip);
    80004a5e:	8526                	mv	a0,s1
    80004a60:	ffffe097          	auipc	ra,0xffffe
    80004a64:	28e080e7          	jalr	654(ra) # 80002cee <ilock>
  ip->nlink--;
    80004a68:	04a4d783          	lhu	a5,74(s1)
    80004a6c:	37fd                	addiw	a5,a5,-1
    80004a6e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a72:	8526                	mv	a0,s1
    80004a74:	ffffe097          	auipc	ra,0xffffe
    80004a78:	1b0080e7          	jalr	432(ra) # 80002c24 <iupdate>
  iunlockput(ip);
    80004a7c:	8526                	mv	a0,s1
    80004a7e:	ffffe097          	auipc	ra,0xffffe
    80004a82:	4d2080e7          	jalr	1234(ra) # 80002f50 <iunlockput>
  end_op();
    80004a86:	fffff097          	auipc	ra,0xfffff
    80004a8a:	cba080e7          	jalr	-838(ra) # 80003740 <end_op>
  return -1;
    80004a8e:	57fd                	li	a5,-1
}
    80004a90:	853e                	mv	a0,a5
    80004a92:	70b2                	ld	ra,296(sp)
    80004a94:	7412                	ld	s0,288(sp)
    80004a96:	64f2                	ld	s1,280(sp)
    80004a98:	6952                	ld	s2,272(sp)
    80004a9a:	6155                	addi	sp,sp,304
    80004a9c:	8082                	ret

0000000080004a9e <sys_unlink>:
{
    80004a9e:	7151                	addi	sp,sp,-240
    80004aa0:	f586                	sd	ra,232(sp)
    80004aa2:	f1a2                	sd	s0,224(sp)
    80004aa4:	eda6                	sd	s1,216(sp)
    80004aa6:	e9ca                	sd	s2,208(sp)
    80004aa8:	e5ce                	sd	s3,200(sp)
    80004aaa:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004aac:	08000613          	li	a2,128
    80004ab0:	f3040593          	addi	a1,s0,-208
    80004ab4:	4501                	li	a0,0
    80004ab6:	ffffd097          	auipc	ra,0xffffd
    80004aba:	61a080e7          	jalr	1562(ra) # 800020d0 <argstr>
    80004abe:	18054163          	bltz	a0,80004c40 <sys_unlink+0x1a2>
  begin_op();
    80004ac2:	fffff097          	auipc	ra,0xfffff
    80004ac6:	bfe080e7          	jalr	-1026(ra) # 800036c0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004aca:	fb040593          	addi	a1,s0,-80
    80004ace:	f3040513          	addi	a0,s0,-208
    80004ad2:	fffff097          	auipc	ra,0xfffff
    80004ad6:	9f0080e7          	jalr	-1552(ra) # 800034c2 <nameiparent>
    80004ada:	84aa                	mv	s1,a0
    80004adc:	c979                	beqz	a0,80004bb2 <sys_unlink+0x114>
  ilock(dp);
    80004ade:	ffffe097          	auipc	ra,0xffffe
    80004ae2:	210080e7          	jalr	528(ra) # 80002cee <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004ae6:	00004597          	auipc	a1,0x4
    80004aea:	c0a58593          	addi	a1,a1,-1014 # 800086f0 <syscalls+0x2f8>
    80004aee:	fb040513          	addi	a0,s0,-80
    80004af2:	ffffe097          	auipc	ra,0xffffe
    80004af6:	6c6080e7          	jalr	1734(ra) # 800031b8 <namecmp>
    80004afa:	14050a63          	beqz	a0,80004c4e <sys_unlink+0x1b0>
    80004afe:	00004597          	auipc	a1,0x4
    80004b02:	bfa58593          	addi	a1,a1,-1030 # 800086f8 <syscalls+0x300>
    80004b06:	fb040513          	addi	a0,s0,-80
    80004b0a:	ffffe097          	auipc	ra,0xffffe
    80004b0e:	6ae080e7          	jalr	1710(ra) # 800031b8 <namecmp>
    80004b12:	12050e63          	beqz	a0,80004c4e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b16:	f2c40613          	addi	a2,s0,-212
    80004b1a:	fb040593          	addi	a1,s0,-80
    80004b1e:	8526                	mv	a0,s1
    80004b20:	ffffe097          	auipc	ra,0xffffe
    80004b24:	6b2080e7          	jalr	1714(ra) # 800031d2 <dirlookup>
    80004b28:	892a                	mv	s2,a0
    80004b2a:	12050263          	beqz	a0,80004c4e <sys_unlink+0x1b0>
  ilock(ip);
    80004b2e:	ffffe097          	auipc	ra,0xffffe
    80004b32:	1c0080e7          	jalr	448(ra) # 80002cee <ilock>
  if(ip->nlink < 1)
    80004b36:	04a91783          	lh	a5,74(s2)
    80004b3a:	08f05263          	blez	a5,80004bbe <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b3e:	04491703          	lh	a4,68(s2)
    80004b42:	4785                	li	a5,1
    80004b44:	08f70563          	beq	a4,a5,80004bce <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b48:	4641                	li	a2,16
    80004b4a:	4581                	li	a1,0
    80004b4c:	fc040513          	addi	a0,s0,-64
    80004b50:	ffffb097          	auipc	ra,0xffffb
    80004b54:	628080e7          	jalr	1576(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b58:	4741                	li	a4,16
    80004b5a:	f2c42683          	lw	a3,-212(s0)
    80004b5e:	fc040613          	addi	a2,s0,-64
    80004b62:	4581                	li	a1,0
    80004b64:	8526                	mv	a0,s1
    80004b66:	ffffe097          	auipc	ra,0xffffe
    80004b6a:	534080e7          	jalr	1332(ra) # 8000309a <writei>
    80004b6e:	47c1                	li	a5,16
    80004b70:	0af51563          	bne	a0,a5,80004c1a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b74:	04491703          	lh	a4,68(s2)
    80004b78:	4785                	li	a5,1
    80004b7a:	0af70863          	beq	a4,a5,80004c2a <sys_unlink+0x18c>
  iunlockput(dp);
    80004b7e:	8526                	mv	a0,s1
    80004b80:	ffffe097          	auipc	ra,0xffffe
    80004b84:	3d0080e7          	jalr	976(ra) # 80002f50 <iunlockput>
  ip->nlink--;
    80004b88:	04a95783          	lhu	a5,74(s2)
    80004b8c:	37fd                	addiw	a5,a5,-1
    80004b8e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b92:	854a                	mv	a0,s2
    80004b94:	ffffe097          	auipc	ra,0xffffe
    80004b98:	090080e7          	jalr	144(ra) # 80002c24 <iupdate>
  iunlockput(ip);
    80004b9c:	854a                	mv	a0,s2
    80004b9e:	ffffe097          	auipc	ra,0xffffe
    80004ba2:	3b2080e7          	jalr	946(ra) # 80002f50 <iunlockput>
  end_op();
    80004ba6:	fffff097          	auipc	ra,0xfffff
    80004baa:	b9a080e7          	jalr	-1126(ra) # 80003740 <end_op>
  return 0;
    80004bae:	4501                	li	a0,0
    80004bb0:	a84d                	j	80004c62 <sys_unlink+0x1c4>
    end_op();
    80004bb2:	fffff097          	auipc	ra,0xfffff
    80004bb6:	b8e080e7          	jalr	-1138(ra) # 80003740 <end_op>
    return -1;
    80004bba:	557d                	li	a0,-1
    80004bbc:	a05d                	j	80004c62 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004bbe:	00004517          	auipc	a0,0x4
    80004bc2:	b6250513          	addi	a0,a0,-1182 # 80008720 <syscalls+0x328>
    80004bc6:	00001097          	auipc	ra,0x1
    80004bca:	1f2080e7          	jalr	498(ra) # 80005db8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bce:	04c92703          	lw	a4,76(s2)
    80004bd2:	02000793          	li	a5,32
    80004bd6:	f6e7f9e3          	bgeu	a5,a4,80004b48 <sys_unlink+0xaa>
    80004bda:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bde:	4741                	li	a4,16
    80004be0:	86ce                	mv	a3,s3
    80004be2:	f1840613          	addi	a2,s0,-232
    80004be6:	4581                	li	a1,0
    80004be8:	854a                	mv	a0,s2
    80004bea:	ffffe097          	auipc	ra,0xffffe
    80004bee:	3b8080e7          	jalr	952(ra) # 80002fa2 <readi>
    80004bf2:	47c1                	li	a5,16
    80004bf4:	00f51b63          	bne	a0,a5,80004c0a <sys_unlink+0x16c>
    if(de.inum != 0)
    80004bf8:	f1845783          	lhu	a5,-232(s0)
    80004bfc:	e7a1                	bnez	a5,80004c44 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bfe:	29c1                	addiw	s3,s3,16
    80004c00:	04c92783          	lw	a5,76(s2)
    80004c04:	fcf9ede3          	bltu	s3,a5,80004bde <sys_unlink+0x140>
    80004c08:	b781                	j	80004b48 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c0a:	00004517          	auipc	a0,0x4
    80004c0e:	b2e50513          	addi	a0,a0,-1234 # 80008738 <syscalls+0x340>
    80004c12:	00001097          	auipc	ra,0x1
    80004c16:	1a6080e7          	jalr	422(ra) # 80005db8 <panic>
    panic("unlink: writei");
    80004c1a:	00004517          	auipc	a0,0x4
    80004c1e:	b3650513          	addi	a0,a0,-1226 # 80008750 <syscalls+0x358>
    80004c22:	00001097          	auipc	ra,0x1
    80004c26:	196080e7          	jalr	406(ra) # 80005db8 <panic>
    dp->nlink--;
    80004c2a:	04a4d783          	lhu	a5,74(s1)
    80004c2e:	37fd                	addiw	a5,a5,-1
    80004c30:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c34:	8526                	mv	a0,s1
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	fee080e7          	jalr	-18(ra) # 80002c24 <iupdate>
    80004c3e:	b781                	j	80004b7e <sys_unlink+0xe0>
    return -1;
    80004c40:	557d                	li	a0,-1
    80004c42:	a005                	j	80004c62 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c44:	854a                	mv	a0,s2
    80004c46:	ffffe097          	auipc	ra,0xffffe
    80004c4a:	30a080e7          	jalr	778(ra) # 80002f50 <iunlockput>
  iunlockput(dp);
    80004c4e:	8526                	mv	a0,s1
    80004c50:	ffffe097          	auipc	ra,0xffffe
    80004c54:	300080e7          	jalr	768(ra) # 80002f50 <iunlockput>
  end_op();
    80004c58:	fffff097          	auipc	ra,0xfffff
    80004c5c:	ae8080e7          	jalr	-1304(ra) # 80003740 <end_op>
  return -1;
    80004c60:	557d                	li	a0,-1
}
    80004c62:	70ae                	ld	ra,232(sp)
    80004c64:	740e                	ld	s0,224(sp)
    80004c66:	64ee                	ld	s1,216(sp)
    80004c68:	694e                	ld	s2,208(sp)
    80004c6a:	69ae                	ld	s3,200(sp)
    80004c6c:	616d                	addi	sp,sp,240
    80004c6e:	8082                	ret

0000000080004c70 <sys_open>:

uint64
sys_open(void)
{
    80004c70:	7131                	addi	sp,sp,-192
    80004c72:	fd06                	sd	ra,184(sp)
    80004c74:	f922                	sd	s0,176(sp)
    80004c76:	f526                	sd	s1,168(sp)
    80004c78:	f14a                	sd	s2,160(sp)
    80004c7a:	ed4e                	sd	s3,152(sp)
    80004c7c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c7e:	08000613          	li	a2,128
    80004c82:	f5040593          	addi	a1,s0,-176
    80004c86:	4501                	li	a0,0
    80004c88:	ffffd097          	auipc	ra,0xffffd
    80004c8c:	448080e7          	jalr	1096(ra) # 800020d0 <argstr>
    return -1;
    80004c90:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c92:	0c054163          	bltz	a0,80004d54 <sys_open+0xe4>
    80004c96:	f4c40593          	addi	a1,s0,-180
    80004c9a:	4505                	li	a0,1
    80004c9c:	ffffd097          	auipc	ra,0xffffd
    80004ca0:	3f0080e7          	jalr	1008(ra) # 8000208c <argint>
    80004ca4:	0a054863          	bltz	a0,80004d54 <sys_open+0xe4>

  begin_op();
    80004ca8:	fffff097          	auipc	ra,0xfffff
    80004cac:	a18080e7          	jalr	-1512(ra) # 800036c0 <begin_op>

  if(omode & O_CREATE){
    80004cb0:	f4c42783          	lw	a5,-180(s0)
    80004cb4:	2007f793          	andi	a5,a5,512
    80004cb8:	cbdd                	beqz	a5,80004d6e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004cba:	4681                	li	a3,0
    80004cbc:	4601                	li	a2,0
    80004cbe:	4589                	li	a1,2
    80004cc0:	f5040513          	addi	a0,s0,-176
    80004cc4:	00000097          	auipc	ra,0x0
    80004cc8:	972080e7          	jalr	-1678(ra) # 80004636 <create>
    80004ccc:	892a                	mv	s2,a0
    if(ip == 0){
    80004cce:	c959                	beqz	a0,80004d64 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cd0:	04491703          	lh	a4,68(s2)
    80004cd4:	478d                	li	a5,3
    80004cd6:	00f71763          	bne	a4,a5,80004ce4 <sys_open+0x74>
    80004cda:	04695703          	lhu	a4,70(s2)
    80004cde:	47a5                	li	a5,9
    80004ce0:	0ce7ec63          	bltu	a5,a4,80004db8 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ce4:	fffff097          	auipc	ra,0xfffff
    80004ce8:	dec080e7          	jalr	-532(ra) # 80003ad0 <filealloc>
    80004cec:	89aa                	mv	s3,a0
    80004cee:	10050263          	beqz	a0,80004df2 <sys_open+0x182>
    80004cf2:	00000097          	auipc	ra,0x0
    80004cf6:	902080e7          	jalr	-1790(ra) # 800045f4 <fdalloc>
    80004cfa:	84aa                	mv	s1,a0
    80004cfc:	0e054663          	bltz	a0,80004de8 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d00:	04491703          	lh	a4,68(s2)
    80004d04:	478d                	li	a5,3
    80004d06:	0cf70463          	beq	a4,a5,80004dce <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d0a:	4789                	li	a5,2
    80004d0c:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d10:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d14:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d18:	f4c42783          	lw	a5,-180(s0)
    80004d1c:	0017c713          	xori	a4,a5,1
    80004d20:	8b05                	andi	a4,a4,1
    80004d22:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d26:	0037f713          	andi	a4,a5,3
    80004d2a:	00e03733          	snez	a4,a4
    80004d2e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d32:	4007f793          	andi	a5,a5,1024
    80004d36:	c791                	beqz	a5,80004d42 <sys_open+0xd2>
    80004d38:	04491703          	lh	a4,68(s2)
    80004d3c:	4789                	li	a5,2
    80004d3e:	08f70f63          	beq	a4,a5,80004ddc <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d42:	854a                	mv	a0,s2
    80004d44:	ffffe097          	auipc	ra,0xffffe
    80004d48:	06c080e7          	jalr	108(ra) # 80002db0 <iunlock>
  end_op();
    80004d4c:	fffff097          	auipc	ra,0xfffff
    80004d50:	9f4080e7          	jalr	-1548(ra) # 80003740 <end_op>

  return fd;
}
    80004d54:	8526                	mv	a0,s1
    80004d56:	70ea                	ld	ra,184(sp)
    80004d58:	744a                	ld	s0,176(sp)
    80004d5a:	74aa                	ld	s1,168(sp)
    80004d5c:	790a                	ld	s2,160(sp)
    80004d5e:	69ea                	ld	s3,152(sp)
    80004d60:	6129                	addi	sp,sp,192
    80004d62:	8082                	ret
      end_op();
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	9dc080e7          	jalr	-1572(ra) # 80003740 <end_op>
      return -1;
    80004d6c:	b7e5                	j	80004d54 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d6e:	f5040513          	addi	a0,s0,-176
    80004d72:	ffffe097          	auipc	ra,0xffffe
    80004d76:	732080e7          	jalr	1842(ra) # 800034a4 <namei>
    80004d7a:	892a                	mv	s2,a0
    80004d7c:	c905                	beqz	a0,80004dac <sys_open+0x13c>
    ilock(ip);
    80004d7e:	ffffe097          	auipc	ra,0xffffe
    80004d82:	f70080e7          	jalr	-144(ra) # 80002cee <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d86:	04491703          	lh	a4,68(s2)
    80004d8a:	4785                	li	a5,1
    80004d8c:	f4f712e3          	bne	a4,a5,80004cd0 <sys_open+0x60>
    80004d90:	f4c42783          	lw	a5,-180(s0)
    80004d94:	dba1                	beqz	a5,80004ce4 <sys_open+0x74>
      iunlockput(ip);
    80004d96:	854a                	mv	a0,s2
    80004d98:	ffffe097          	auipc	ra,0xffffe
    80004d9c:	1b8080e7          	jalr	440(ra) # 80002f50 <iunlockput>
      end_op();
    80004da0:	fffff097          	auipc	ra,0xfffff
    80004da4:	9a0080e7          	jalr	-1632(ra) # 80003740 <end_op>
      return -1;
    80004da8:	54fd                	li	s1,-1
    80004daa:	b76d                	j	80004d54 <sys_open+0xe4>
      end_op();
    80004dac:	fffff097          	auipc	ra,0xfffff
    80004db0:	994080e7          	jalr	-1644(ra) # 80003740 <end_op>
      return -1;
    80004db4:	54fd                	li	s1,-1
    80004db6:	bf79                	j	80004d54 <sys_open+0xe4>
    iunlockput(ip);
    80004db8:	854a                	mv	a0,s2
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	196080e7          	jalr	406(ra) # 80002f50 <iunlockput>
    end_op();
    80004dc2:	fffff097          	auipc	ra,0xfffff
    80004dc6:	97e080e7          	jalr	-1666(ra) # 80003740 <end_op>
    return -1;
    80004dca:	54fd                	li	s1,-1
    80004dcc:	b761                	j	80004d54 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004dce:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004dd2:	04691783          	lh	a5,70(s2)
    80004dd6:	02f99223          	sh	a5,36(s3)
    80004dda:	bf2d                	j	80004d14 <sys_open+0xa4>
    itrunc(ip);
    80004ddc:	854a                	mv	a0,s2
    80004dde:	ffffe097          	auipc	ra,0xffffe
    80004de2:	01e080e7          	jalr	30(ra) # 80002dfc <itrunc>
    80004de6:	bfb1                	j	80004d42 <sys_open+0xd2>
      fileclose(f);
    80004de8:	854e                	mv	a0,s3
    80004dea:	fffff097          	auipc	ra,0xfffff
    80004dee:	da2080e7          	jalr	-606(ra) # 80003b8c <fileclose>
    iunlockput(ip);
    80004df2:	854a                	mv	a0,s2
    80004df4:	ffffe097          	auipc	ra,0xffffe
    80004df8:	15c080e7          	jalr	348(ra) # 80002f50 <iunlockput>
    end_op();
    80004dfc:	fffff097          	auipc	ra,0xfffff
    80004e00:	944080e7          	jalr	-1724(ra) # 80003740 <end_op>
    return -1;
    80004e04:	54fd                	li	s1,-1
    80004e06:	b7b9                	j	80004d54 <sys_open+0xe4>

0000000080004e08 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e08:	7175                	addi	sp,sp,-144
    80004e0a:	e506                	sd	ra,136(sp)
    80004e0c:	e122                	sd	s0,128(sp)
    80004e0e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e10:	fffff097          	auipc	ra,0xfffff
    80004e14:	8b0080e7          	jalr	-1872(ra) # 800036c0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e18:	08000613          	li	a2,128
    80004e1c:	f7040593          	addi	a1,s0,-144
    80004e20:	4501                	li	a0,0
    80004e22:	ffffd097          	auipc	ra,0xffffd
    80004e26:	2ae080e7          	jalr	686(ra) # 800020d0 <argstr>
    80004e2a:	02054963          	bltz	a0,80004e5c <sys_mkdir+0x54>
    80004e2e:	4681                	li	a3,0
    80004e30:	4601                	li	a2,0
    80004e32:	4585                	li	a1,1
    80004e34:	f7040513          	addi	a0,s0,-144
    80004e38:	fffff097          	auipc	ra,0xfffff
    80004e3c:	7fe080e7          	jalr	2046(ra) # 80004636 <create>
    80004e40:	cd11                	beqz	a0,80004e5c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e42:	ffffe097          	auipc	ra,0xffffe
    80004e46:	10e080e7          	jalr	270(ra) # 80002f50 <iunlockput>
  end_op();
    80004e4a:	fffff097          	auipc	ra,0xfffff
    80004e4e:	8f6080e7          	jalr	-1802(ra) # 80003740 <end_op>
  return 0;
    80004e52:	4501                	li	a0,0
}
    80004e54:	60aa                	ld	ra,136(sp)
    80004e56:	640a                	ld	s0,128(sp)
    80004e58:	6149                	addi	sp,sp,144
    80004e5a:	8082                	ret
    end_op();
    80004e5c:	fffff097          	auipc	ra,0xfffff
    80004e60:	8e4080e7          	jalr	-1820(ra) # 80003740 <end_op>
    return -1;
    80004e64:	557d                	li	a0,-1
    80004e66:	b7fd                	j	80004e54 <sys_mkdir+0x4c>

0000000080004e68 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e68:	7135                	addi	sp,sp,-160
    80004e6a:	ed06                	sd	ra,152(sp)
    80004e6c:	e922                	sd	s0,144(sp)
    80004e6e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e70:	fffff097          	auipc	ra,0xfffff
    80004e74:	850080e7          	jalr	-1968(ra) # 800036c0 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e78:	08000613          	li	a2,128
    80004e7c:	f7040593          	addi	a1,s0,-144
    80004e80:	4501                	li	a0,0
    80004e82:	ffffd097          	auipc	ra,0xffffd
    80004e86:	24e080e7          	jalr	590(ra) # 800020d0 <argstr>
    80004e8a:	04054a63          	bltz	a0,80004ede <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e8e:	f6c40593          	addi	a1,s0,-148
    80004e92:	4505                	li	a0,1
    80004e94:	ffffd097          	auipc	ra,0xffffd
    80004e98:	1f8080e7          	jalr	504(ra) # 8000208c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e9c:	04054163          	bltz	a0,80004ede <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004ea0:	f6840593          	addi	a1,s0,-152
    80004ea4:	4509                	li	a0,2
    80004ea6:	ffffd097          	auipc	ra,0xffffd
    80004eaa:	1e6080e7          	jalr	486(ra) # 8000208c <argint>
     argint(1, &major) < 0 ||
    80004eae:	02054863          	bltz	a0,80004ede <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004eb2:	f6841683          	lh	a3,-152(s0)
    80004eb6:	f6c41603          	lh	a2,-148(s0)
    80004eba:	458d                	li	a1,3
    80004ebc:	f7040513          	addi	a0,s0,-144
    80004ec0:	fffff097          	auipc	ra,0xfffff
    80004ec4:	776080e7          	jalr	1910(ra) # 80004636 <create>
     argint(2, &minor) < 0 ||
    80004ec8:	c919                	beqz	a0,80004ede <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eca:	ffffe097          	auipc	ra,0xffffe
    80004ece:	086080e7          	jalr	134(ra) # 80002f50 <iunlockput>
  end_op();
    80004ed2:	fffff097          	auipc	ra,0xfffff
    80004ed6:	86e080e7          	jalr	-1938(ra) # 80003740 <end_op>
  return 0;
    80004eda:	4501                	li	a0,0
    80004edc:	a031                	j	80004ee8 <sys_mknod+0x80>
    end_op();
    80004ede:	fffff097          	auipc	ra,0xfffff
    80004ee2:	862080e7          	jalr	-1950(ra) # 80003740 <end_op>
    return -1;
    80004ee6:	557d                	li	a0,-1
}
    80004ee8:	60ea                	ld	ra,152(sp)
    80004eea:	644a                	ld	s0,144(sp)
    80004eec:	610d                	addi	sp,sp,160
    80004eee:	8082                	ret

0000000080004ef0 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ef0:	7135                	addi	sp,sp,-160
    80004ef2:	ed06                	sd	ra,152(sp)
    80004ef4:	e922                	sd	s0,144(sp)
    80004ef6:	e526                	sd	s1,136(sp)
    80004ef8:	e14a                	sd	s2,128(sp)
    80004efa:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004efc:	ffffc097          	auipc	ra,0xffffc
    80004f00:	02e080e7          	jalr	46(ra) # 80000f2a <myproc>
    80004f04:	892a                	mv	s2,a0
  
  begin_op();
    80004f06:	ffffe097          	auipc	ra,0xffffe
    80004f0a:	7ba080e7          	jalr	1978(ra) # 800036c0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f0e:	08000613          	li	a2,128
    80004f12:	f6040593          	addi	a1,s0,-160
    80004f16:	4501                	li	a0,0
    80004f18:	ffffd097          	auipc	ra,0xffffd
    80004f1c:	1b8080e7          	jalr	440(ra) # 800020d0 <argstr>
    80004f20:	04054b63          	bltz	a0,80004f76 <sys_chdir+0x86>
    80004f24:	f6040513          	addi	a0,s0,-160
    80004f28:	ffffe097          	auipc	ra,0xffffe
    80004f2c:	57c080e7          	jalr	1404(ra) # 800034a4 <namei>
    80004f30:	84aa                	mv	s1,a0
    80004f32:	c131                	beqz	a0,80004f76 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f34:	ffffe097          	auipc	ra,0xffffe
    80004f38:	dba080e7          	jalr	-582(ra) # 80002cee <ilock>
  if(ip->type != T_DIR){
    80004f3c:	04449703          	lh	a4,68(s1)
    80004f40:	4785                	li	a5,1
    80004f42:	04f71063          	bne	a4,a5,80004f82 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f46:	8526                	mv	a0,s1
    80004f48:	ffffe097          	auipc	ra,0xffffe
    80004f4c:	e68080e7          	jalr	-408(ra) # 80002db0 <iunlock>
  iput(p->cwd);
    80004f50:	15093503          	ld	a0,336(s2)
    80004f54:	ffffe097          	auipc	ra,0xffffe
    80004f58:	f54080e7          	jalr	-172(ra) # 80002ea8 <iput>
  end_op();
    80004f5c:	ffffe097          	auipc	ra,0xffffe
    80004f60:	7e4080e7          	jalr	2020(ra) # 80003740 <end_op>
  p->cwd = ip;
    80004f64:	14993823          	sd	s1,336(s2)
  return 0;
    80004f68:	4501                	li	a0,0
}
    80004f6a:	60ea                	ld	ra,152(sp)
    80004f6c:	644a                	ld	s0,144(sp)
    80004f6e:	64aa                	ld	s1,136(sp)
    80004f70:	690a                	ld	s2,128(sp)
    80004f72:	610d                	addi	sp,sp,160
    80004f74:	8082                	ret
    end_op();
    80004f76:	ffffe097          	auipc	ra,0xffffe
    80004f7a:	7ca080e7          	jalr	1994(ra) # 80003740 <end_op>
    return -1;
    80004f7e:	557d                	li	a0,-1
    80004f80:	b7ed                	j	80004f6a <sys_chdir+0x7a>
    iunlockput(ip);
    80004f82:	8526                	mv	a0,s1
    80004f84:	ffffe097          	auipc	ra,0xffffe
    80004f88:	fcc080e7          	jalr	-52(ra) # 80002f50 <iunlockput>
    end_op();
    80004f8c:	ffffe097          	auipc	ra,0xffffe
    80004f90:	7b4080e7          	jalr	1972(ra) # 80003740 <end_op>
    return -1;
    80004f94:	557d                	li	a0,-1
    80004f96:	bfd1                	j	80004f6a <sys_chdir+0x7a>

0000000080004f98 <sys_exec>:

uint64
sys_exec(void)
{
    80004f98:	7145                	addi	sp,sp,-464
    80004f9a:	e786                	sd	ra,456(sp)
    80004f9c:	e3a2                	sd	s0,448(sp)
    80004f9e:	ff26                	sd	s1,440(sp)
    80004fa0:	fb4a                	sd	s2,432(sp)
    80004fa2:	f74e                	sd	s3,424(sp)
    80004fa4:	f352                	sd	s4,416(sp)
    80004fa6:	ef56                	sd	s5,408(sp)
    80004fa8:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004faa:	08000613          	li	a2,128
    80004fae:	f4040593          	addi	a1,s0,-192
    80004fb2:	4501                	li	a0,0
    80004fb4:	ffffd097          	auipc	ra,0xffffd
    80004fb8:	11c080e7          	jalr	284(ra) # 800020d0 <argstr>
    return -1;
    80004fbc:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fbe:	0c054a63          	bltz	a0,80005092 <sys_exec+0xfa>
    80004fc2:	e3840593          	addi	a1,s0,-456
    80004fc6:	4505                	li	a0,1
    80004fc8:	ffffd097          	auipc	ra,0xffffd
    80004fcc:	0e6080e7          	jalr	230(ra) # 800020ae <argaddr>
    80004fd0:	0c054163          	bltz	a0,80005092 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004fd4:	10000613          	li	a2,256
    80004fd8:	4581                	li	a1,0
    80004fda:	e4040513          	addi	a0,s0,-448
    80004fde:	ffffb097          	auipc	ra,0xffffb
    80004fe2:	19a080e7          	jalr	410(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fe6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004fea:	89a6                	mv	s3,s1
    80004fec:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fee:	02000a13          	li	s4,32
    80004ff2:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ff6:	00391513          	slli	a0,s2,0x3
    80004ffa:	e3040593          	addi	a1,s0,-464
    80004ffe:	e3843783          	ld	a5,-456(s0)
    80005002:	953e                	add	a0,a0,a5
    80005004:	ffffd097          	auipc	ra,0xffffd
    80005008:	fee080e7          	jalr	-18(ra) # 80001ff2 <fetchaddr>
    8000500c:	02054a63          	bltz	a0,80005040 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005010:	e3043783          	ld	a5,-464(s0)
    80005014:	c3b9                	beqz	a5,8000505a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005016:	ffffb097          	auipc	ra,0xffffb
    8000501a:	102080e7          	jalr	258(ra) # 80000118 <kalloc>
    8000501e:	85aa                	mv	a1,a0
    80005020:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005024:	cd11                	beqz	a0,80005040 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005026:	6605                	lui	a2,0x1
    80005028:	e3043503          	ld	a0,-464(s0)
    8000502c:	ffffd097          	auipc	ra,0xffffd
    80005030:	018080e7          	jalr	24(ra) # 80002044 <fetchstr>
    80005034:	00054663          	bltz	a0,80005040 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005038:	0905                	addi	s2,s2,1
    8000503a:	09a1                	addi	s3,s3,8
    8000503c:	fb491be3          	bne	s2,s4,80004ff2 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005040:	10048913          	addi	s2,s1,256
    80005044:	6088                	ld	a0,0(s1)
    80005046:	c529                	beqz	a0,80005090 <sys_exec+0xf8>
    kfree(argv[i]);
    80005048:	ffffb097          	auipc	ra,0xffffb
    8000504c:	fd4080e7          	jalr	-44(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005050:	04a1                	addi	s1,s1,8
    80005052:	ff2499e3          	bne	s1,s2,80005044 <sys_exec+0xac>
  return -1;
    80005056:	597d                	li	s2,-1
    80005058:	a82d                	j	80005092 <sys_exec+0xfa>
      argv[i] = 0;
    8000505a:	0a8e                	slli	s5,s5,0x3
    8000505c:	fc040793          	addi	a5,s0,-64
    80005060:	9abe                	add	s5,s5,a5
    80005062:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005066:	e4040593          	addi	a1,s0,-448
    8000506a:	f4040513          	addi	a0,s0,-192
    8000506e:	fffff097          	auipc	ra,0xfffff
    80005072:	17e080e7          	jalr	382(ra) # 800041ec <exec>
    80005076:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005078:	10048993          	addi	s3,s1,256
    8000507c:	6088                	ld	a0,0(s1)
    8000507e:	c911                	beqz	a0,80005092 <sys_exec+0xfa>
    kfree(argv[i]);
    80005080:	ffffb097          	auipc	ra,0xffffb
    80005084:	f9c080e7          	jalr	-100(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005088:	04a1                	addi	s1,s1,8
    8000508a:	ff3499e3          	bne	s1,s3,8000507c <sys_exec+0xe4>
    8000508e:	a011                	j	80005092 <sys_exec+0xfa>
  return -1;
    80005090:	597d                	li	s2,-1
}
    80005092:	854a                	mv	a0,s2
    80005094:	60be                	ld	ra,456(sp)
    80005096:	641e                	ld	s0,448(sp)
    80005098:	74fa                	ld	s1,440(sp)
    8000509a:	795a                	ld	s2,432(sp)
    8000509c:	79ba                	ld	s3,424(sp)
    8000509e:	7a1a                	ld	s4,416(sp)
    800050a0:	6afa                	ld	s5,408(sp)
    800050a2:	6179                	addi	sp,sp,464
    800050a4:	8082                	ret

00000000800050a6 <sys_pipe>:

uint64
sys_pipe(void)
{
    800050a6:	7139                	addi	sp,sp,-64
    800050a8:	fc06                	sd	ra,56(sp)
    800050aa:	f822                	sd	s0,48(sp)
    800050ac:	f426                	sd	s1,40(sp)
    800050ae:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050b0:	ffffc097          	auipc	ra,0xffffc
    800050b4:	e7a080e7          	jalr	-390(ra) # 80000f2a <myproc>
    800050b8:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050ba:	fd840593          	addi	a1,s0,-40
    800050be:	4501                	li	a0,0
    800050c0:	ffffd097          	auipc	ra,0xffffd
    800050c4:	fee080e7          	jalr	-18(ra) # 800020ae <argaddr>
    return -1;
    800050c8:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050ca:	0e054063          	bltz	a0,800051aa <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050ce:	fc840593          	addi	a1,s0,-56
    800050d2:	fd040513          	addi	a0,s0,-48
    800050d6:	fffff097          	auipc	ra,0xfffff
    800050da:	de6080e7          	jalr	-538(ra) # 80003ebc <pipealloc>
    return -1;
    800050de:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050e0:	0c054563          	bltz	a0,800051aa <sys_pipe+0x104>
  fd0 = -1;
    800050e4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050e8:	fd043503          	ld	a0,-48(s0)
    800050ec:	fffff097          	auipc	ra,0xfffff
    800050f0:	508080e7          	jalr	1288(ra) # 800045f4 <fdalloc>
    800050f4:	fca42223          	sw	a0,-60(s0)
    800050f8:	08054c63          	bltz	a0,80005190 <sys_pipe+0xea>
    800050fc:	fc843503          	ld	a0,-56(s0)
    80005100:	fffff097          	auipc	ra,0xfffff
    80005104:	4f4080e7          	jalr	1268(ra) # 800045f4 <fdalloc>
    80005108:	fca42023          	sw	a0,-64(s0)
    8000510c:	06054863          	bltz	a0,8000517c <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005110:	4691                	li	a3,4
    80005112:	fc440613          	addi	a2,s0,-60
    80005116:	fd843583          	ld	a1,-40(s0)
    8000511a:	68a8                	ld	a0,80(s1)
    8000511c:	ffffc097          	auipc	ra,0xffffc
    80005120:	aa0080e7          	jalr	-1376(ra) # 80000bbc <copyout>
    80005124:	02054063          	bltz	a0,80005144 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005128:	4691                	li	a3,4
    8000512a:	fc040613          	addi	a2,s0,-64
    8000512e:	fd843583          	ld	a1,-40(s0)
    80005132:	0591                	addi	a1,a1,4
    80005134:	68a8                	ld	a0,80(s1)
    80005136:	ffffc097          	auipc	ra,0xffffc
    8000513a:	a86080e7          	jalr	-1402(ra) # 80000bbc <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000513e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005140:	06055563          	bgez	a0,800051aa <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005144:	fc442783          	lw	a5,-60(s0)
    80005148:	07e9                	addi	a5,a5,26
    8000514a:	078e                	slli	a5,a5,0x3
    8000514c:	97a6                	add	a5,a5,s1
    8000514e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005152:	fc042503          	lw	a0,-64(s0)
    80005156:	0569                	addi	a0,a0,26
    80005158:	050e                	slli	a0,a0,0x3
    8000515a:	9526                	add	a0,a0,s1
    8000515c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005160:	fd043503          	ld	a0,-48(s0)
    80005164:	fffff097          	auipc	ra,0xfffff
    80005168:	a28080e7          	jalr	-1496(ra) # 80003b8c <fileclose>
    fileclose(wf);
    8000516c:	fc843503          	ld	a0,-56(s0)
    80005170:	fffff097          	auipc	ra,0xfffff
    80005174:	a1c080e7          	jalr	-1508(ra) # 80003b8c <fileclose>
    return -1;
    80005178:	57fd                	li	a5,-1
    8000517a:	a805                	j	800051aa <sys_pipe+0x104>
    if(fd0 >= 0)
    8000517c:	fc442783          	lw	a5,-60(s0)
    80005180:	0007c863          	bltz	a5,80005190 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005184:	01a78513          	addi	a0,a5,26
    80005188:	050e                	slli	a0,a0,0x3
    8000518a:	9526                	add	a0,a0,s1
    8000518c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005190:	fd043503          	ld	a0,-48(s0)
    80005194:	fffff097          	auipc	ra,0xfffff
    80005198:	9f8080e7          	jalr	-1544(ra) # 80003b8c <fileclose>
    fileclose(wf);
    8000519c:	fc843503          	ld	a0,-56(s0)
    800051a0:	fffff097          	auipc	ra,0xfffff
    800051a4:	9ec080e7          	jalr	-1556(ra) # 80003b8c <fileclose>
    return -1;
    800051a8:	57fd                	li	a5,-1
}
    800051aa:	853e                	mv	a0,a5
    800051ac:	70e2                	ld	ra,56(sp)
    800051ae:	7442                	ld	s0,48(sp)
    800051b0:	74a2                	ld	s1,40(sp)
    800051b2:	6121                	addi	sp,sp,64
    800051b4:	8082                	ret
	...

00000000800051c0 <kernelvec>:
    800051c0:	7111                	addi	sp,sp,-256
    800051c2:	e006                	sd	ra,0(sp)
    800051c4:	e40a                	sd	sp,8(sp)
    800051c6:	e80e                	sd	gp,16(sp)
    800051c8:	ec12                	sd	tp,24(sp)
    800051ca:	f016                	sd	t0,32(sp)
    800051cc:	f41a                	sd	t1,40(sp)
    800051ce:	f81e                	sd	t2,48(sp)
    800051d0:	fc22                	sd	s0,56(sp)
    800051d2:	e0a6                	sd	s1,64(sp)
    800051d4:	e4aa                	sd	a0,72(sp)
    800051d6:	e8ae                	sd	a1,80(sp)
    800051d8:	ecb2                	sd	a2,88(sp)
    800051da:	f0b6                	sd	a3,96(sp)
    800051dc:	f4ba                	sd	a4,104(sp)
    800051de:	f8be                	sd	a5,112(sp)
    800051e0:	fcc2                	sd	a6,120(sp)
    800051e2:	e146                	sd	a7,128(sp)
    800051e4:	e54a                	sd	s2,136(sp)
    800051e6:	e94e                	sd	s3,144(sp)
    800051e8:	ed52                	sd	s4,152(sp)
    800051ea:	f156                	sd	s5,160(sp)
    800051ec:	f55a                	sd	s6,168(sp)
    800051ee:	f95e                	sd	s7,176(sp)
    800051f0:	fd62                	sd	s8,184(sp)
    800051f2:	e1e6                	sd	s9,192(sp)
    800051f4:	e5ea                	sd	s10,200(sp)
    800051f6:	e9ee                	sd	s11,208(sp)
    800051f8:	edf2                	sd	t3,216(sp)
    800051fa:	f1f6                	sd	t4,224(sp)
    800051fc:	f5fa                	sd	t5,232(sp)
    800051fe:	f9fe                	sd	t6,240(sp)
    80005200:	cbffc0ef          	jal	ra,80001ebe <kerneltrap>
    80005204:	6082                	ld	ra,0(sp)
    80005206:	6122                	ld	sp,8(sp)
    80005208:	61c2                	ld	gp,16(sp)
    8000520a:	7282                	ld	t0,32(sp)
    8000520c:	7322                	ld	t1,40(sp)
    8000520e:	73c2                	ld	t2,48(sp)
    80005210:	7462                	ld	s0,56(sp)
    80005212:	6486                	ld	s1,64(sp)
    80005214:	6526                	ld	a0,72(sp)
    80005216:	65c6                	ld	a1,80(sp)
    80005218:	6666                	ld	a2,88(sp)
    8000521a:	7686                	ld	a3,96(sp)
    8000521c:	7726                	ld	a4,104(sp)
    8000521e:	77c6                	ld	a5,112(sp)
    80005220:	7866                	ld	a6,120(sp)
    80005222:	688a                	ld	a7,128(sp)
    80005224:	692a                	ld	s2,136(sp)
    80005226:	69ca                	ld	s3,144(sp)
    80005228:	6a6a                	ld	s4,152(sp)
    8000522a:	7a8a                	ld	s5,160(sp)
    8000522c:	7b2a                	ld	s6,168(sp)
    8000522e:	7bca                	ld	s7,176(sp)
    80005230:	7c6a                	ld	s8,184(sp)
    80005232:	6c8e                	ld	s9,192(sp)
    80005234:	6d2e                	ld	s10,200(sp)
    80005236:	6dce                	ld	s11,208(sp)
    80005238:	6e6e                	ld	t3,216(sp)
    8000523a:	7e8e                	ld	t4,224(sp)
    8000523c:	7f2e                	ld	t5,232(sp)
    8000523e:	7fce                	ld	t6,240(sp)
    80005240:	6111                	addi	sp,sp,256
    80005242:	10200073          	sret
    80005246:	00000013          	nop
    8000524a:	00000013          	nop
    8000524e:	0001                	nop

0000000080005250 <timervec>:
    80005250:	34051573          	csrrw	a0,mscratch,a0
    80005254:	e10c                	sd	a1,0(a0)
    80005256:	e510                	sd	a2,8(a0)
    80005258:	e914                	sd	a3,16(a0)
    8000525a:	6d0c                	ld	a1,24(a0)
    8000525c:	7110                	ld	a2,32(a0)
    8000525e:	6194                	ld	a3,0(a1)
    80005260:	96b2                	add	a3,a3,a2
    80005262:	e194                	sd	a3,0(a1)
    80005264:	4589                	li	a1,2
    80005266:	14459073          	csrw	sip,a1
    8000526a:	6914                	ld	a3,16(a0)
    8000526c:	6510                	ld	a2,8(a0)
    8000526e:	610c                	ld	a1,0(a0)
    80005270:	34051573          	csrrw	a0,mscratch,a0
    80005274:	30200073          	mret
	...

000000008000527a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000527a:	1141                	addi	sp,sp,-16
    8000527c:	e422                	sd	s0,8(sp)
    8000527e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005280:	0c0007b7          	lui	a5,0xc000
    80005284:	4705                	li	a4,1
    80005286:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005288:	c3d8                	sw	a4,4(a5)
}
    8000528a:	6422                	ld	s0,8(sp)
    8000528c:	0141                	addi	sp,sp,16
    8000528e:	8082                	ret

0000000080005290 <plicinithart>:

void
plicinithart(void)
{
    80005290:	1141                	addi	sp,sp,-16
    80005292:	e406                	sd	ra,8(sp)
    80005294:	e022                	sd	s0,0(sp)
    80005296:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005298:	ffffc097          	auipc	ra,0xffffc
    8000529c:	c66080e7          	jalr	-922(ra) # 80000efe <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052a0:	0085171b          	slliw	a4,a0,0x8
    800052a4:	0c0027b7          	lui	a5,0xc002
    800052a8:	97ba                	add	a5,a5,a4
    800052aa:	40200713          	li	a4,1026
    800052ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052b2:	00d5151b          	slliw	a0,a0,0xd
    800052b6:	0c2017b7          	lui	a5,0xc201
    800052ba:	953e                	add	a0,a0,a5
    800052bc:	00052023          	sw	zero,0(a0)
}
    800052c0:	60a2                	ld	ra,8(sp)
    800052c2:	6402                	ld	s0,0(sp)
    800052c4:	0141                	addi	sp,sp,16
    800052c6:	8082                	ret

00000000800052c8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052c8:	1141                	addi	sp,sp,-16
    800052ca:	e406                	sd	ra,8(sp)
    800052cc:	e022                	sd	s0,0(sp)
    800052ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052d0:	ffffc097          	auipc	ra,0xffffc
    800052d4:	c2e080e7          	jalr	-978(ra) # 80000efe <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052d8:	00d5179b          	slliw	a5,a0,0xd
    800052dc:	0c201537          	lui	a0,0xc201
    800052e0:	953e                	add	a0,a0,a5
  return irq;
}
    800052e2:	4148                	lw	a0,4(a0)
    800052e4:	60a2                	ld	ra,8(sp)
    800052e6:	6402                	ld	s0,0(sp)
    800052e8:	0141                	addi	sp,sp,16
    800052ea:	8082                	ret

00000000800052ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052ec:	1101                	addi	sp,sp,-32
    800052ee:	ec06                	sd	ra,24(sp)
    800052f0:	e822                	sd	s0,16(sp)
    800052f2:	e426                	sd	s1,8(sp)
    800052f4:	1000                	addi	s0,sp,32
    800052f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052f8:	ffffc097          	auipc	ra,0xffffc
    800052fc:	c06080e7          	jalr	-1018(ra) # 80000efe <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005300:	00d5151b          	slliw	a0,a0,0xd
    80005304:	0c2017b7          	lui	a5,0xc201
    80005308:	97aa                	add	a5,a5,a0
    8000530a:	c3c4                	sw	s1,4(a5)
}
    8000530c:	60e2                	ld	ra,24(sp)
    8000530e:	6442                	ld	s0,16(sp)
    80005310:	64a2                	ld	s1,8(sp)
    80005312:	6105                	addi	sp,sp,32
    80005314:	8082                	ret

0000000080005316 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005316:	1141                	addi	sp,sp,-16
    80005318:	e406                	sd	ra,8(sp)
    8000531a:	e022                	sd	s0,0(sp)
    8000531c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000531e:	479d                	li	a5,7
    80005320:	06a7c963          	blt	a5,a0,80005392 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005324:	00016797          	auipc	a5,0x16
    80005328:	cdc78793          	addi	a5,a5,-804 # 8001b000 <disk>
    8000532c:	00a78733          	add	a4,a5,a0
    80005330:	6789                	lui	a5,0x2
    80005332:	97ba                	add	a5,a5,a4
    80005334:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005338:	e7ad                	bnez	a5,800053a2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000533a:	00451793          	slli	a5,a0,0x4
    8000533e:	00018717          	auipc	a4,0x18
    80005342:	cc270713          	addi	a4,a4,-830 # 8001d000 <disk+0x2000>
    80005346:	6314                	ld	a3,0(a4)
    80005348:	96be                	add	a3,a3,a5
    8000534a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000534e:	6314                	ld	a3,0(a4)
    80005350:	96be                	add	a3,a3,a5
    80005352:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005356:	6314                	ld	a3,0(a4)
    80005358:	96be                	add	a3,a3,a5
    8000535a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000535e:	6318                	ld	a4,0(a4)
    80005360:	97ba                	add	a5,a5,a4
    80005362:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005366:	00016797          	auipc	a5,0x16
    8000536a:	c9a78793          	addi	a5,a5,-870 # 8001b000 <disk>
    8000536e:	97aa                	add	a5,a5,a0
    80005370:	6509                	lui	a0,0x2
    80005372:	953e                	add	a0,a0,a5
    80005374:	4785                	li	a5,1
    80005376:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000537a:	00018517          	auipc	a0,0x18
    8000537e:	c9e50513          	addi	a0,a0,-866 # 8001d018 <disk+0x2018>
    80005382:	ffffc097          	auipc	ra,0xffffc
    80005386:	4a6080e7          	jalr	1190(ra) # 80001828 <wakeup>
}
    8000538a:	60a2                	ld	ra,8(sp)
    8000538c:	6402                	ld	s0,0(sp)
    8000538e:	0141                	addi	sp,sp,16
    80005390:	8082                	ret
    panic("free_desc 1");
    80005392:	00003517          	auipc	a0,0x3
    80005396:	3ce50513          	addi	a0,a0,974 # 80008760 <syscalls+0x368>
    8000539a:	00001097          	auipc	ra,0x1
    8000539e:	a1e080e7          	jalr	-1506(ra) # 80005db8 <panic>
    panic("free_desc 2");
    800053a2:	00003517          	auipc	a0,0x3
    800053a6:	3ce50513          	addi	a0,a0,974 # 80008770 <syscalls+0x378>
    800053aa:	00001097          	auipc	ra,0x1
    800053ae:	a0e080e7          	jalr	-1522(ra) # 80005db8 <panic>

00000000800053b2 <virtio_disk_init>:
{
    800053b2:	1101                	addi	sp,sp,-32
    800053b4:	ec06                	sd	ra,24(sp)
    800053b6:	e822                	sd	s0,16(sp)
    800053b8:	e426                	sd	s1,8(sp)
    800053ba:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053bc:	00003597          	auipc	a1,0x3
    800053c0:	3c458593          	addi	a1,a1,964 # 80008780 <syscalls+0x388>
    800053c4:	00018517          	auipc	a0,0x18
    800053c8:	d6450513          	addi	a0,a0,-668 # 8001d128 <disk+0x2128>
    800053cc:	00001097          	auipc	ra,0x1
    800053d0:	ea6080e7          	jalr	-346(ra) # 80006272 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053d4:	100017b7          	lui	a5,0x10001
    800053d8:	4398                	lw	a4,0(a5)
    800053da:	2701                	sext.w	a4,a4
    800053dc:	747277b7          	lui	a5,0x74727
    800053e0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053e4:	0ef71163          	bne	a4,a5,800054c6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053e8:	100017b7          	lui	a5,0x10001
    800053ec:	43dc                	lw	a5,4(a5)
    800053ee:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053f0:	4705                	li	a4,1
    800053f2:	0ce79a63          	bne	a5,a4,800054c6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053f6:	100017b7          	lui	a5,0x10001
    800053fa:	479c                	lw	a5,8(a5)
    800053fc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053fe:	4709                	li	a4,2
    80005400:	0ce79363          	bne	a5,a4,800054c6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005404:	100017b7          	lui	a5,0x10001
    80005408:	47d8                	lw	a4,12(a5)
    8000540a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000540c:	554d47b7          	lui	a5,0x554d4
    80005410:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005414:	0af71963          	bne	a4,a5,800054c6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005418:	100017b7          	lui	a5,0x10001
    8000541c:	4705                	li	a4,1
    8000541e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005420:	470d                	li	a4,3
    80005422:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005424:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005426:	c7ffe737          	lui	a4,0xc7ffe
    8000542a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000542e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005430:	2701                	sext.w	a4,a4
    80005432:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005434:	472d                	li	a4,11
    80005436:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005438:	473d                	li	a4,15
    8000543a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000543c:	6705                	lui	a4,0x1
    8000543e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005440:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005444:	5bdc                	lw	a5,52(a5)
    80005446:	2781                	sext.w	a5,a5
  if(max == 0)
    80005448:	c7d9                	beqz	a5,800054d6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000544a:	471d                	li	a4,7
    8000544c:	08f77d63          	bgeu	a4,a5,800054e6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005450:	100014b7          	lui	s1,0x10001
    80005454:	47a1                	li	a5,8
    80005456:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005458:	6609                	lui	a2,0x2
    8000545a:	4581                	li	a1,0
    8000545c:	00016517          	auipc	a0,0x16
    80005460:	ba450513          	addi	a0,a0,-1116 # 8001b000 <disk>
    80005464:	ffffb097          	auipc	ra,0xffffb
    80005468:	d14080e7          	jalr	-748(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000546c:	00016717          	auipc	a4,0x16
    80005470:	b9470713          	addi	a4,a4,-1132 # 8001b000 <disk>
    80005474:	00c75793          	srli	a5,a4,0xc
    80005478:	2781                	sext.w	a5,a5
    8000547a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000547c:	00018797          	auipc	a5,0x18
    80005480:	b8478793          	addi	a5,a5,-1148 # 8001d000 <disk+0x2000>
    80005484:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005486:	00016717          	auipc	a4,0x16
    8000548a:	bfa70713          	addi	a4,a4,-1030 # 8001b080 <disk+0x80>
    8000548e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005490:	00017717          	auipc	a4,0x17
    80005494:	b7070713          	addi	a4,a4,-1168 # 8001c000 <disk+0x1000>
    80005498:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000549a:	4705                	li	a4,1
    8000549c:	00e78c23          	sb	a4,24(a5)
    800054a0:	00e78ca3          	sb	a4,25(a5)
    800054a4:	00e78d23          	sb	a4,26(a5)
    800054a8:	00e78da3          	sb	a4,27(a5)
    800054ac:	00e78e23          	sb	a4,28(a5)
    800054b0:	00e78ea3          	sb	a4,29(a5)
    800054b4:	00e78f23          	sb	a4,30(a5)
    800054b8:	00e78fa3          	sb	a4,31(a5)
}
    800054bc:	60e2                	ld	ra,24(sp)
    800054be:	6442                	ld	s0,16(sp)
    800054c0:	64a2                	ld	s1,8(sp)
    800054c2:	6105                	addi	sp,sp,32
    800054c4:	8082                	ret
    panic("could not find virtio disk");
    800054c6:	00003517          	auipc	a0,0x3
    800054ca:	2ca50513          	addi	a0,a0,714 # 80008790 <syscalls+0x398>
    800054ce:	00001097          	auipc	ra,0x1
    800054d2:	8ea080e7          	jalr	-1814(ra) # 80005db8 <panic>
    panic("virtio disk has no queue 0");
    800054d6:	00003517          	auipc	a0,0x3
    800054da:	2da50513          	addi	a0,a0,730 # 800087b0 <syscalls+0x3b8>
    800054de:	00001097          	auipc	ra,0x1
    800054e2:	8da080e7          	jalr	-1830(ra) # 80005db8 <panic>
    panic("virtio disk max queue too short");
    800054e6:	00003517          	auipc	a0,0x3
    800054ea:	2ea50513          	addi	a0,a0,746 # 800087d0 <syscalls+0x3d8>
    800054ee:	00001097          	auipc	ra,0x1
    800054f2:	8ca080e7          	jalr	-1846(ra) # 80005db8 <panic>

00000000800054f6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054f6:	7159                	addi	sp,sp,-112
    800054f8:	f486                	sd	ra,104(sp)
    800054fa:	f0a2                	sd	s0,96(sp)
    800054fc:	eca6                	sd	s1,88(sp)
    800054fe:	e8ca                	sd	s2,80(sp)
    80005500:	e4ce                	sd	s3,72(sp)
    80005502:	e0d2                	sd	s4,64(sp)
    80005504:	fc56                	sd	s5,56(sp)
    80005506:	f85a                	sd	s6,48(sp)
    80005508:	f45e                	sd	s7,40(sp)
    8000550a:	f062                	sd	s8,32(sp)
    8000550c:	ec66                	sd	s9,24(sp)
    8000550e:	e86a                	sd	s10,16(sp)
    80005510:	1880                	addi	s0,sp,112
    80005512:	892a                	mv	s2,a0
    80005514:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005516:	00c52c83          	lw	s9,12(a0)
    8000551a:	001c9c9b          	slliw	s9,s9,0x1
    8000551e:	1c82                	slli	s9,s9,0x20
    80005520:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005524:	00018517          	auipc	a0,0x18
    80005528:	c0450513          	addi	a0,a0,-1020 # 8001d128 <disk+0x2128>
    8000552c:	00001097          	auipc	ra,0x1
    80005530:	dd6080e7          	jalr	-554(ra) # 80006302 <acquire>
  for(int i = 0; i < 3; i++){
    80005534:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005536:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005538:	00016b97          	auipc	s7,0x16
    8000553c:	ac8b8b93          	addi	s7,s7,-1336 # 8001b000 <disk>
    80005540:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005542:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005544:	8a4e                	mv	s4,s3
    80005546:	a051                	j	800055ca <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005548:	00fb86b3          	add	a3,s7,a5
    8000554c:	96da                	add	a3,a3,s6
    8000554e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005552:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005554:	0207c563          	bltz	a5,8000557e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005558:	2485                	addiw	s1,s1,1
    8000555a:	0711                	addi	a4,a4,4
    8000555c:	25548063          	beq	s1,s5,8000579c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005560:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005562:	00018697          	auipc	a3,0x18
    80005566:	ab668693          	addi	a3,a3,-1354 # 8001d018 <disk+0x2018>
    8000556a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000556c:	0006c583          	lbu	a1,0(a3)
    80005570:	fde1                	bnez	a1,80005548 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005572:	2785                	addiw	a5,a5,1
    80005574:	0685                	addi	a3,a3,1
    80005576:	ff879be3          	bne	a5,s8,8000556c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000557a:	57fd                	li	a5,-1
    8000557c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000557e:	02905a63          	blez	s1,800055b2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005582:	f9042503          	lw	a0,-112(s0)
    80005586:	00000097          	auipc	ra,0x0
    8000558a:	d90080e7          	jalr	-624(ra) # 80005316 <free_desc>
      for(int j = 0; j < i; j++)
    8000558e:	4785                	li	a5,1
    80005590:	0297d163          	bge	a5,s1,800055b2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005594:	f9442503          	lw	a0,-108(s0)
    80005598:	00000097          	auipc	ra,0x0
    8000559c:	d7e080e7          	jalr	-642(ra) # 80005316 <free_desc>
      for(int j = 0; j < i; j++)
    800055a0:	4789                	li	a5,2
    800055a2:	0097d863          	bge	a5,s1,800055b2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055a6:	f9842503          	lw	a0,-104(s0)
    800055aa:	00000097          	auipc	ra,0x0
    800055ae:	d6c080e7          	jalr	-660(ra) # 80005316 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055b2:	00018597          	auipc	a1,0x18
    800055b6:	b7658593          	addi	a1,a1,-1162 # 8001d128 <disk+0x2128>
    800055ba:	00018517          	auipc	a0,0x18
    800055be:	a5e50513          	addi	a0,a0,-1442 # 8001d018 <disk+0x2018>
    800055c2:	ffffc097          	auipc	ra,0xffffc
    800055c6:	0da080e7          	jalr	218(ra) # 8000169c <sleep>
  for(int i = 0; i < 3; i++){
    800055ca:	f9040713          	addi	a4,s0,-112
    800055ce:	84ce                	mv	s1,s3
    800055d0:	bf41                	j	80005560 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800055d2:	20058713          	addi	a4,a1,512
    800055d6:	00471693          	slli	a3,a4,0x4
    800055da:	00016717          	auipc	a4,0x16
    800055de:	a2670713          	addi	a4,a4,-1498 # 8001b000 <disk>
    800055e2:	9736                	add	a4,a4,a3
    800055e4:	4685                	li	a3,1
    800055e6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055ea:	20058713          	addi	a4,a1,512
    800055ee:	00471693          	slli	a3,a4,0x4
    800055f2:	00016717          	auipc	a4,0x16
    800055f6:	a0e70713          	addi	a4,a4,-1522 # 8001b000 <disk>
    800055fa:	9736                	add	a4,a4,a3
    800055fc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005600:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005604:	7679                	lui	a2,0xffffe
    80005606:	963e                	add	a2,a2,a5
    80005608:	00018697          	auipc	a3,0x18
    8000560c:	9f868693          	addi	a3,a3,-1544 # 8001d000 <disk+0x2000>
    80005610:	6298                	ld	a4,0(a3)
    80005612:	9732                	add	a4,a4,a2
    80005614:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005616:	6298                	ld	a4,0(a3)
    80005618:	9732                	add	a4,a4,a2
    8000561a:	4541                	li	a0,16
    8000561c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000561e:	6298                	ld	a4,0(a3)
    80005620:	9732                	add	a4,a4,a2
    80005622:	4505                	li	a0,1
    80005624:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005628:	f9442703          	lw	a4,-108(s0)
    8000562c:	6288                	ld	a0,0(a3)
    8000562e:	962a                	add	a2,a2,a0
    80005630:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005634:	0712                	slli	a4,a4,0x4
    80005636:	6290                	ld	a2,0(a3)
    80005638:	963a                	add	a2,a2,a4
    8000563a:	05890513          	addi	a0,s2,88
    8000563e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005640:	6294                	ld	a3,0(a3)
    80005642:	96ba                	add	a3,a3,a4
    80005644:	40000613          	li	a2,1024
    80005648:	c690                	sw	a2,8(a3)
  if(write)
    8000564a:	140d0063          	beqz	s10,8000578a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000564e:	00018697          	auipc	a3,0x18
    80005652:	9b26b683          	ld	a3,-1614(a3) # 8001d000 <disk+0x2000>
    80005656:	96ba                	add	a3,a3,a4
    80005658:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000565c:	00016817          	auipc	a6,0x16
    80005660:	9a480813          	addi	a6,a6,-1628 # 8001b000 <disk>
    80005664:	00018517          	auipc	a0,0x18
    80005668:	99c50513          	addi	a0,a0,-1636 # 8001d000 <disk+0x2000>
    8000566c:	6114                	ld	a3,0(a0)
    8000566e:	96ba                	add	a3,a3,a4
    80005670:	00c6d603          	lhu	a2,12(a3)
    80005674:	00166613          	ori	a2,a2,1
    80005678:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000567c:	f9842683          	lw	a3,-104(s0)
    80005680:	6110                	ld	a2,0(a0)
    80005682:	9732                	add	a4,a4,a2
    80005684:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005688:	20058613          	addi	a2,a1,512
    8000568c:	0612                	slli	a2,a2,0x4
    8000568e:	9642                	add	a2,a2,a6
    80005690:	577d                	li	a4,-1
    80005692:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005696:	00469713          	slli	a4,a3,0x4
    8000569a:	6114                	ld	a3,0(a0)
    8000569c:	96ba                	add	a3,a3,a4
    8000569e:	03078793          	addi	a5,a5,48
    800056a2:	97c2                	add	a5,a5,a6
    800056a4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    800056a6:	611c                	ld	a5,0(a0)
    800056a8:	97ba                	add	a5,a5,a4
    800056aa:	4685                	li	a3,1
    800056ac:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056ae:	611c                	ld	a5,0(a0)
    800056b0:	97ba                	add	a5,a5,a4
    800056b2:	4809                	li	a6,2
    800056b4:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800056b8:	611c                	ld	a5,0(a0)
    800056ba:	973e                	add	a4,a4,a5
    800056bc:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056c0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800056c4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056c8:	6518                	ld	a4,8(a0)
    800056ca:	00275783          	lhu	a5,2(a4)
    800056ce:	8b9d                	andi	a5,a5,7
    800056d0:	0786                	slli	a5,a5,0x1
    800056d2:	97ba                	add	a5,a5,a4
    800056d4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800056d8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056dc:	6518                	ld	a4,8(a0)
    800056de:	00275783          	lhu	a5,2(a4)
    800056e2:	2785                	addiw	a5,a5,1
    800056e4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056e8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056ec:	100017b7          	lui	a5,0x10001
    800056f0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056f4:	00492703          	lw	a4,4(s2)
    800056f8:	4785                	li	a5,1
    800056fa:	02f71163          	bne	a4,a5,8000571c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800056fe:	00018997          	auipc	s3,0x18
    80005702:	a2a98993          	addi	s3,s3,-1494 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005706:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005708:	85ce                	mv	a1,s3
    8000570a:	854a                	mv	a0,s2
    8000570c:	ffffc097          	auipc	ra,0xffffc
    80005710:	f90080e7          	jalr	-112(ra) # 8000169c <sleep>
  while(b->disk == 1) {
    80005714:	00492783          	lw	a5,4(s2)
    80005718:	fe9788e3          	beq	a5,s1,80005708 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000571c:	f9042903          	lw	s2,-112(s0)
    80005720:	20090793          	addi	a5,s2,512
    80005724:	00479713          	slli	a4,a5,0x4
    80005728:	00016797          	auipc	a5,0x16
    8000572c:	8d878793          	addi	a5,a5,-1832 # 8001b000 <disk>
    80005730:	97ba                	add	a5,a5,a4
    80005732:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005736:	00018997          	auipc	s3,0x18
    8000573a:	8ca98993          	addi	s3,s3,-1846 # 8001d000 <disk+0x2000>
    8000573e:	00491713          	slli	a4,s2,0x4
    80005742:	0009b783          	ld	a5,0(s3)
    80005746:	97ba                	add	a5,a5,a4
    80005748:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000574c:	854a                	mv	a0,s2
    8000574e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005752:	00000097          	auipc	ra,0x0
    80005756:	bc4080e7          	jalr	-1084(ra) # 80005316 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000575a:	8885                	andi	s1,s1,1
    8000575c:	f0ed                	bnez	s1,8000573e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000575e:	00018517          	auipc	a0,0x18
    80005762:	9ca50513          	addi	a0,a0,-1590 # 8001d128 <disk+0x2128>
    80005766:	00001097          	auipc	ra,0x1
    8000576a:	c50080e7          	jalr	-944(ra) # 800063b6 <release>
}
    8000576e:	70a6                	ld	ra,104(sp)
    80005770:	7406                	ld	s0,96(sp)
    80005772:	64e6                	ld	s1,88(sp)
    80005774:	6946                	ld	s2,80(sp)
    80005776:	69a6                	ld	s3,72(sp)
    80005778:	6a06                	ld	s4,64(sp)
    8000577a:	7ae2                	ld	s5,56(sp)
    8000577c:	7b42                	ld	s6,48(sp)
    8000577e:	7ba2                	ld	s7,40(sp)
    80005780:	7c02                	ld	s8,32(sp)
    80005782:	6ce2                	ld	s9,24(sp)
    80005784:	6d42                	ld	s10,16(sp)
    80005786:	6165                	addi	sp,sp,112
    80005788:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000578a:	00018697          	auipc	a3,0x18
    8000578e:	8766b683          	ld	a3,-1930(a3) # 8001d000 <disk+0x2000>
    80005792:	96ba                	add	a3,a3,a4
    80005794:	4609                	li	a2,2
    80005796:	00c69623          	sh	a2,12(a3)
    8000579a:	b5c9                	j	8000565c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000579c:	f9042583          	lw	a1,-112(s0)
    800057a0:	20058793          	addi	a5,a1,512
    800057a4:	0792                	slli	a5,a5,0x4
    800057a6:	00016517          	auipc	a0,0x16
    800057aa:	90250513          	addi	a0,a0,-1790 # 8001b0a8 <disk+0xa8>
    800057ae:	953e                	add	a0,a0,a5
  if(write)
    800057b0:	e20d11e3          	bnez	s10,800055d2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800057b4:	20058713          	addi	a4,a1,512
    800057b8:	00471693          	slli	a3,a4,0x4
    800057bc:	00016717          	auipc	a4,0x16
    800057c0:	84470713          	addi	a4,a4,-1980 # 8001b000 <disk>
    800057c4:	9736                	add	a4,a4,a3
    800057c6:	0a072423          	sw	zero,168(a4)
    800057ca:	b505                	j	800055ea <virtio_disk_rw+0xf4>

00000000800057cc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057cc:	1101                	addi	sp,sp,-32
    800057ce:	ec06                	sd	ra,24(sp)
    800057d0:	e822                	sd	s0,16(sp)
    800057d2:	e426                	sd	s1,8(sp)
    800057d4:	e04a                	sd	s2,0(sp)
    800057d6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057d8:	00018517          	auipc	a0,0x18
    800057dc:	95050513          	addi	a0,a0,-1712 # 8001d128 <disk+0x2128>
    800057e0:	00001097          	auipc	ra,0x1
    800057e4:	b22080e7          	jalr	-1246(ra) # 80006302 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057e8:	10001737          	lui	a4,0x10001
    800057ec:	533c                	lw	a5,96(a4)
    800057ee:	8b8d                	andi	a5,a5,3
    800057f0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057f2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057f6:	00018797          	auipc	a5,0x18
    800057fa:	80a78793          	addi	a5,a5,-2038 # 8001d000 <disk+0x2000>
    800057fe:	6b94                	ld	a3,16(a5)
    80005800:	0207d703          	lhu	a4,32(a5)
    80005804:	0026d783          	lhu	a5,2(a3)
    80005808:	06f70163          	beq	a4,a5,8000586a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000580c:	00015917          	auipc	s2,0x15
    80005810:	7f490913          	addi	s2,s2,2036 # 8001b000 <disk>
    80005814:	00017497          	auipc	s1,0x17
    80005818:	7ec48493          	addi	s1,s1,2028 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000581c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005820:	6898                	ld	a4,16(s1)
    80005822:	0204d783          	lhu	a5,32(s1)
    80005826:	8b9d                	andi	a5,a5,7
    80005828:	078e                	slli	a5,a5,0x3
    8000582a:	97ba                	add	a5,a5,a4
    8000582c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000582e:	20078713          	addi	a4,a5,512
    80005832:	0712                	slli	a4,a4,0x4
    80005834:	974a                	add	a4,a4,s2
    80005836:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000583a:	e731                	bnez	a4,80005886 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000583c:	20078793          	addi	a5,a5,512
    80005840:	0792                	slli	a5,a5,0x4
    80005842:	97ca                	add	a5,a5,s2
    80005844:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005846:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000584a:	ffffc097          	auipc	ra,0xffffc
    8000584e:	fde080e7          	jalr	-34(ra) # 80001828 <wakeup>

    disk.used_idx += 1;
    80005852:	0204d783          	lhu	a5,32(s1)
    80005856:	2785                	addiw	a5,a5,1
    80005858:	17c2                	slli	a5,a5,0x30
    8000585a:	93c1                	srli	a5,a5,0x30
    8000585c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005860:	6898                	ld	a4,16(s1)
    80005862:	00275703          	lhu	a4,2(a4)
    80005866:	faf71be3          	bne	a4,a5,8000581c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000586a:	00018517          	auipc	a0,0x18
    8000586e:	8be50513          	addi	a0,a0,-1858 # 8001d128 <disk+0x2128>
    80005872:	00001097          	auipc	ra,0x1
    80005876:	b44080e7          	jalr	-1212(ra) # 800063b6 <release>
}
    8000587a:	60e2                	ld	ra,24(sp)
    8000587c:	6442                	ld	s0,16(sp)
    8000587e:	64a2                	ld	s1,8(sp)
    80005880:	6902                	ld	s2,0(sp)
    80005882:	6105                	addi	sp,sp,32
    80005884:	8082                	ret
      panic("virtio_disk_intr status");
    80005886:	00003517          	auipc	a0,0x3
    8000588a:	f6a50513          	addi	a0,a0,-150 # 800087f0 <syscalls+0x3f8>
    8000588e:	00000097          	auipc	ra,0x0
    80005892:	52a080e7          	jalr	1322(ra) # 80005db8 <panic>

0000000080005896 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005896:	1141                	addi	sp,sp,-16
    80005898:	e422                	sd	s0,8(sp)
    8000589a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000589c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800058a0:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800058a4:	0037979b          	slliw	a5,a5,0x3
    800058a8:	02004737          	lui	a4,0x2004
    800058ac:	97ba                	add	a5,a5,a4
    800058ae:	0200c737          	lui	a4,0x200c
    800058b2:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058b6:	000f4637          	lui	a2,0xf4
    800058ba:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058be:	95b2                	add	a1,a1,a2
    800058c0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058c2:	00269713          	slli	a4,a3,0x2
    800058c6:	9736                	add	a4,a4,a3
    800058c8:	00371693          	slli	a3,a4,0x3
    800058cc:	00018717          	auipc	a4,0x18
    800058d0:	73470713          	addi	a4,a4,1844 # 8001e000 <timer_scratch>
    800058d4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058d6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058d8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058da:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058de:	00000797          	auipc	a5,0x0
    800058e2:	97278793          	addi	a5,a5,-1678 # 80005250 <timervec>
    800058e6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058ea:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058ee:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058f2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058f6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058fa:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058fe:	30479073          	csrw	mie,a5
}
    80005902:	6422                	ld	s0,8(sp)
    80005904:	0141                	addi	sp,sp,16
    80005906:	8082                	ret

0000000080005908 <start>:
{
    80005908:	1141                	addi	sp,sp,-16
    8000590a:	e406                	sd	ra,8(sp)
    8000590c:	e022                	sd	s0,0(sp)
    8000590e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005910:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005914:	7779                	lui	a4,0xffffe
    80005916:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    8000591a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000591c:	6705                	lui	a4,0x1
    8000591e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005922:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005924:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005928:	ffffb797          	auipc	a5,0xffffb
    8000592c:	9fe78793          	addi	a5,a5,-1538 # 80000326 <main>
    80005930:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005934:	4781                	li	a5,0
    80005936:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000593a:	67c1                	lui	a5,0x10
    8000593c:	17fd                	addi	a5,a5,-1
    8000593e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005942:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005946:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000594a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000594e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005952:	57fd                	li	a5,-1
    80005954:	83a9                	srli	a5,a5,0xa
    80005956:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000595a:	47bd                	li	a5,15
    8000595c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005960:	00000097          	auipc	ra,0x0
    80005964:	f36080e7          	jalr	-202(ra) # 80005896 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005968:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000596c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000596e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005970:	30200073          	mret
}
    80005974:	60a2                	ld	ra,8(sp)
    80005976:	6402                	ld	s0,0(sp)
    80005978:	0141                	addi	sp,sp,16
    8000597a:	8082                	ret

000000008000597c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000597c:	715d                	addi	sp,sp,-80
    8000597e:	e486                	sd	ra,72(sp)
    80005980:	e0a2                	sd	s0,64(sp)
    80005982:	fc26                	sd	s1,56(sp)
    80005984:	f84a                	sd	s2,48(sp)
    80005986:	f44e                	sd	s3,40(sp)
    80005988:	f052                	sd	s4,32(sp)
    8000598a:	ec56                	sd	s5,24(sp)
    8000598c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000598e:	04c05663          	blez	a2,800059da <consolewrite+0x5e>
    80005992:	8a2a                	mv	s4,a0
    80005994:	84ae                	mv	s1,a1
    80005996:	89b2                	mv	s3,a2
    80005998:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000599a:	5afd                	li	s5,-1
    8000599c:	4685                	li	a3,1
    8000599e:	8626                	mv	a2,s1
    800059a0:	85d2                	mv	a1,s4
    800059a2:	fbf40513          	addi	a0,s0,-65
    800059a6:	ffffc097          	auipc	ra,0xffffc
    800059aa:	0f0080e7          	jalr	240(ra) # 80001a96 <either_copyin>
    800059ae:	01550c63          	beq	a0,s5,800059c6 <consolewrite+0x4a>
      break;
    uartputc(c);
    800059b2:	fbf44503          	lbu	a0,-65(s0)
    800059b6:	00000097          	auipc	ra,0x0
    800059ba:	78e080e7          	jalr	1934(ra) # 80006144 <uartputc>
  for(i = 0; i < n; i++){
    800059be:	2905                	addiw	s2,s2,1
    800059c0:	0485                	addi	s1,s1,1
    800059c2:	fd299de3          	bne	s3,s2,8000599c <consolewrite+0x20>
  }

  return i;
}
    800059c6:	854a                	mv	a0,s2
    800059c8:	60a6                	ld	ra,72(sp)
    800059ca:	6406                	ld	s0,64(sp)
    800059cc:	74e2                	ld	s1,56(sp)
    800059ce:	7942                	ld	s2,48(sp)
    800059d0:	79a2                	ld	s3,40(sp)
    800059d2:	7a02                	ld	s4,32(sp)
    800059d4:	6ae2                	ld	s5,24(sp)
    800059d6:	6161                	addi	sp,sp,80
    800059d8:	8082                	ret
  for(i = 0; i < n; i++){
    800059da:	4901                	li	s2,0
    800059dc:	b7ed                	j	800059c6 <consolewrite+0x4a>

00000000800059de <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059de:	7119                	addi	sp,sp,-128
    800059e0:	fc86                	sd	ra,120(sp)
    800059e2:	f8a2                	sd	s0,112(sp)
    800059e4:	f4a6                	sd	s1,104(sp)
    800059e6:	f0ca                	sd	s2,96(sp)
    800059e8:	ecce                	sd	s3,88(sp)
    800059ea:	e8d2                	sd	s4,80(sp)
    800059ec:	e4d6                	sd	s5,72(sp)
    800059ee:	e0da                	sd	s6,64(sp)
    800059f0:	fc5e                	sd	s7,56(sp)
    800059f2:	f862                	sd	s8,48(sp)
    800059f4:	f466                	sd	s9,40(sp)
    800059f6:	f06a                	sd	s10,32(sp)
    800059f8:	ec6e                	sd	s11,24(sp)
    800059fa:	0100                	addi	s0,sp,128
    800059fc:	8b2a                	mv	s6,a0
    800059fe:	8aae                	mv	s5,a1
    80005a00:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a02:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005a06:	00020517          	auipc	a0,0x20
    80005a0a:	73a50513          	addi	a0,a0,1850 # 80026140 <cons>
    80005a0e:	00001097          	auipc	ra,0x1
    80005a12:	8f4080e7          	jalr	-1804(ra) # 80006302 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a16:	00020497          	auipc	s1,0x20
    80005a1a:	72a48493          	addi	s1,s1,1834 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a1e:	89a6                	mv	s3,s1
    80005a20:	00020917          	auipc	s2,0x20
    80005a24:	7b890913          	addi	s2,s2,1976 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a28:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a2a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a2c:	4da9                	li	s11,10
  while(n > 0){
    80005a2e:	07405863          	blez	s4,80005a9e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005a32:	0984a783          	lw	a5,152(s1)
    80005a36:	09c4a703          	lw	a4,156(s1)
    80005a3a:	02f71463          	bne	a4,a5,80005a62 <consoleread+0x84>
      if(myproc()->killed){
    80005a3e:	ffffb097          	auipc	ra,0xffffb
    80005a42:	4ec080e7          	jalr	1260(ra) # 80000f2a <myproc>
    80005a46:	551c                	lw	a5,40(a0)
    80005a48:	e7b5                	bnez	a5,80005ab4 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005a4a:	85ce                	mv	a1,s3
    80005a4c:	854a                	mv	a0,s2
    80005a4e:	ffffc097          	auipc	ra,0xffffc
    80005a52:	c4e080e7          	jalr	-946(ra) # 8000169c <sleep>
    while(cons.r == cons.w){
    80005a56:	0984a783          	lw	a5,152(s1)
    80005a5a:	09c4a703          	lw	a4,156(s1)
    80005a5e:	fef700e3          	beq	a4,a5,80005a3e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a62:	0017871b          	addiw	a4,a5,1
    80005a66:	08e4ac23          	sw	a4,152(s1)
    80005a6a:	07f7f713          	andi	a4,a5,127
    80005a6e:	9726                	add	a4,a4,s1
    80005a70:	01874703          	lbu	a4,24(a4)
    80005a74:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a78:	079c0663          	beq	s8,s9,80005ae4 <consoleread+0x106>
    cbuf = c;
    80005a7c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a80:	4685                	li	a3,1
    80005a82:	f8f40613          	addi	a2,s0,-113
    80005a86:	85d6                	mv	a1,s5
    80005a88:	855a                	mv	a0,s6
    80005a8a:	ffffc097          	auipc	ra,0xffffc
    80005a8e:	fb6080e7          	jalr	-74(ra) # 80001a40 <either_copyout>
    80005a92:	01a50663          	beq	a0,s10,80005a9e <consoleread+0xc0>
    dst++;
    80005a96:	0a85                	addi	s5,s5,1
    --n;
    80005a98:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005a9a:	f9bc1ae3          	bne	s8,s11,80005a2e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a9e:	00020517          	auipc	a0,0x20
    80005aa2:	6a250513          	addi	a0,a0,1698 # 80026140 <cons>
    80005aa6:	00001097          	auipc	ra,0x1
    80005aaa:	910080e7          	jalr	-1776(ra) # 800063b6 <release>

  return target - n;
    80005aae:	414b853b          	subw	a0,s7,s4
    80005ab2:	a811                	j	80005ac6 <consoleread+0xe8>
        release(&cons.lock);
    80005ab4:	00020517          	auipc	a0,0x20
    80005ab8:	68c50513          	addi	a0,a0,1676 # 80026140 <cons>
    80005abc:	00001097          	auipc	ra,0x1
    80005ac0:	8fa080e7          	jalr	-1798(ra) # 800063b6 <release>
        return -1;
    80005ac4:	557d                	li	a0,-1
}
    80005ac6:	70e6                	ld	ra,120(sp)
    80005ac8:	7446                	ld	s0,112(sp)
    80005aca:	74a6                	ld	s1,104(sp)
    80005acc:	7906                	ld	s2,96(sp)
    80005ace:	69e6                	ld	s3,88(sp)
    80005ad0:	6a46                	ld	s4,80(sp)
    80005ad2:	6aa6                	ld	s5,72(sp)
    80005ad4:	6b06                	ld	s6,64(sp)
    80005ad6:	7be2                	ld	s7,56(sp)
    80005ad8:	7c42                	ld	s8,48(sp)
    80005ada:	7ca2                	ld	s9,40(sp)
    80005adc:	7d02                	ld	s10,32(sp)
    80005ade:	6de2                	ld	s11,24(sp)
    80005ae0:	6109                	addi	sp,sp,128
    80005ae2:	8082                	ret
      if(n < target){
    80005ae4:	000a071b          	sext.w	a4,s4
    80005ae8:	fb777be3          	bgeu	a4,s7,80005a9e <consoleread+0xc0>
        cons.r--;
    80005aec:	00020717          	auipc	a4,0x20
    80005af0:	6ef72623          	sw	a5,1772(a4) # 800261d8 <cons+0x98>
    80005af4:	b76d                	j	80005a9e <consoleread+0xc0>

0000000080005af6 <consputc>:
{
    80005af6:	1141                	addi	sp,sp,-16
    80005af8:	e406                	sd	ra,8(sp)
    80005afa:	e022                	sd	s0,0(sp)
    80005afc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005afe:	10000793          	li	a5,256
    80005b02:	00f50a63          	beq	a0,a5,80005b16 <consputc+0x20>
    uartputc_sync(c);
    80005b06:	00000097          	auipc	ra,0x0
    80005b0a:	564080e7          	jalr	1380(ra) # 8000606a <uartputc_sync>
}
    80005b0e:	60a2                	ld	ra,8(sp)
    80005b10:	6402                	ld	s0,0(sp)
    80005b12:	0141                	addi	sp,sp,16
    80005b14:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b16:	4521                	li	a0,8
    80005b18:	00000097          	auipc	ra,0x0
    80005b1c:	552080e7          	jalr	1362(ra) # 8000606a <uartputc_sync>
    80005b20:	02000513          	li	a0,32
    80005b24:	00000097          	auipc	ra,0x0
    80005b28:	546080e7          	jalr	1350(ra) # 8000606a <uartputc_sync>
    80005b2c:	4521                	li	a0,8
    80005b2e:	00000097          	auipc	ra,0x0
    80005b32:	53c080e7          	jalr	1340(ra) # 8000606a <uartputc_sync>
    80005b36:	bfe1                	j	80005b0e <consputc+0x18>

0000000080005b38 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b38:	1101                	addi	sp,sp,-32
    80005b3a:	ec06                	sd	ra,24(sp)
    80005b3c:	e822                	sd	s0,16(sp)
    80005b3e:	e426                	sd	s1,8(sp)
    80005b40:	e04a                	sd	s2,0(sp)
    80005b42:	1000                	addi	s0,sp,32
    80005b44:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b46:	00020517          	auipc	a0,0x20
    80005b4a:	5fa50513          	addi	a0,a0,1530 # 80026140 <cons>
    80005b4e:	00000097          	auipc	ra,0x0
    80005b52:	7b4080e7          	jalr	1972(ra) # 80006302 <acquire>

  switch(c){
    80005b56:	47d5                	li	a5,21
    80005b58:	0af48663          	beq	s1,a5,80005c04 <consoleintr+0xcc>
    80005b5c:	0297ca63          	blt	a5,s1,80005b90 <consoleintr+0x58>
    80005b60:	47a1                	li	a5,8
    80005b62:	0ef48763          	beq	s1,a5,80005c50 <consoleintr+0x118>
    80005b66:	47c1                	li	a5,16
    80005b68:	10f49a63          	bne	s1,a5,80005c7c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b6c:	ffffc097          	auipc	ra,0xffffc
    80005b70:	f80080e7          	jalr	-128(ra) # 80001aec <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b74:	00020517          	auipc	a0,0x20
    80005b78:	5cc50513          	addi	a0,a0,1484 # 80026140 <cons>
    80005b7c:	00001097          	auipc	ra,0x1
    80005b80:	83a080e7          	jalr	-1990(ra) # 800063b6 <release>
}
    80005b84:	60e2                	ld	ra,24(sp)
    80005b86:	6442                	ld	s0,16(sp)
    80005b88:	64a2                	ld	s1,8(sp)
    80005b8a:	6902                	ld	s2,0(sp)
    80005b8c:	6105                	addi	sp,sp,32
    80005b8e:	8082                	ret
  switch(c){
    80005b90:	07f00793          	li	a5,127
    80005b94:	0af48e63          	beq	s1,a5,80005c50 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b98:	00020717          	auipc	a4,0x20
    80005b9c:	5a870713          	addi	a4,a4,1448 # 80026140 <cons>
    80005ba0:	0a072783          	lw	a5,160(a4)
    80005ba4:	09872703          	lw	a4,152(a4)
    80005ba8:	9f99                	subw	a5,a5,a4
    80005baa:	07f00713          	li	a4,127
    80005bae:	fcf763e3          	bltu	a4,a5,80005b74 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005bb2:	47b5                	li	a5,13
    80005bb4:	0cf48763          	beq	s1,a5,80005c82 <consoleintr+0x14a>
      consputc(c);
    80005bb8:	8526                	mv	a0,s1
    80005bba:	00000097          	auipc	ra,0x0
    80005bbe:	f3c080e7          	jalr	-196(ra) # 80005af6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bc2:	00020797          	auipc	a5,0x20
    80005bc6:	57e78793          	addi	a5,a5,1406 # 80026140 <cons>
    80005bca:	0a07a703          	lw	a4,160(a5)
    80005bce:	0017069b          	addiw	a3,a4,1
    80005bd2:	0006861b          	sext.w	a2,a3
    80005bd6:	0ad7a023          	sw	a3,160(a5)
    80005bda:	07f77713          	andi	a4,a4,127
    80005bde:	97ba                	add	a5,a5,a4
    80005be0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005be4:	47a9                	li	a5,10
    80005be6:	0cf48563          	beq	s1,a5,80005cb0 <consoleintr+0x178>
    80005bea:	4791                	li	a5,4
    80005bec:	0cf48263          	beq	s1,a5,80005cb0 <consoleintr+0x178>
    80005bf0:	00020797          	auipc	a5,0x20
    80005bf4:	5e87a783          	lw	a5,1512(a5) # 800261d8 <cons+0x98>
    80005bf8:	0807879b          	addiw	a5,a5,128
    80005bfc:	f6f61ce3          	bne	a2,a5,80005b74 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c00:	863e                	mv	a2,a5
    80005c02:	a07d                	j	80005cb0 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c04:	00020717          	auipc	a4,0x20
    80005c08:	53c70713          	addi	a4,a4,1340 # 80026140 <cons>
    80005c0c:	0a072783          	lw	a5,160(a4)
    80005c10:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c14:	00020497          	auipc	s1,0x20
    80005c18:	52c48493          	addi	s1,s1,1324 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005c1c:	4929                	li	s2,10
    80005c1e:	f4f70be3          	beq	a4,a5,80005b74 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c22:	37fd                	addiw	a5,a5,-1
    80005c24:	07f7f713          	andi	a4,a5,127
    80005c28:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c2a:	01874703          	lbu	a4,24(a4)
    80005c2e:	f52703e3          	beq	a4,s2,80005b74 <consoleintr+0x3c>
      cons.e--;
    80005c32:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c36:	10000513          	li	a0,256
    80005c3a:	00000097          	auipc	ra,0x0
    80005c3e:	ebc080e7          	jalr	-324(ra) # 80005af6 <consputc>
    while(cons.e != cons.w &&
    80005c42:	0a04a783          	lw	a5,160(s1)
    80005c46:	09c4a703          	lw	a4,156(s1)
    80005c4a:	fcf71ce3          	bne	a4,a5,80005c22 <consoleintr+0xea>
    80005c4e:	b71d                	j	80005b74 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c50:	00020717          	auipc	a4,0x20
    80005c54:	4f070713          	addi	a4,a4,1264 # 80026140 <cons>
    80005c58:	0a072783          	lw	a5,160(a4)
    80005c5c:	09c72703          	lw	a4,156(a4)
    80005c60:	f0f70ae3          	beq	a4,a5,80005b74 <consoleintr+0x3c>
      cons.e--;
    80005c64:	37fd                	addiw	a5,a5,-1
    80005c66:	00020717          	auipc	a4,0x20
    80005c6a:	56f72d23          	sw	a5,1402(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c6e:	10000513          	li	a0,256
    80005c72:	00000097          	auipc	ra,0x0
    80005c76:	e84080e7          	jalr	-380(ra) # 80005af6 <consputc>
    80005c7a:	bded                	j	80005b74 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c7c:	ee048ce3          	beqz	s1,80005b74 <consoleintr+0x3c>
    80005c80:	bf21                	j	80005b98 <consoleintr+0x60>
      consputc(c);
    80005c82:	4529                	li	a0,10
    80005c84:	00000097          	auipc	ra,0x0
    80005c88:	e72080e7          	jalr	-398(ra) # 80005af6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c8c:	00020797          	auipc	a5,0x20
    80005c90:	4b478793          	addi	a5,a5,1204 # 80026140 <cons>
    80005c94:	0a07a703          	lw	a4,160(a5)
    80005c98:	0017069b          	addiw	a3,a4,1
    80005c9c:	0006861b          	sext.w	a2,a3
    80005ca0:	0ad7a023          	sw	a3,160(a5)
    80005ca4:	07f77713          	andi	a4,a4,127
    80005ca8:	97ba                	add	a5,a5,a4
    80005caa:	4729                	li	a4,10
    80005cac:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005cb0:	00020797          	auipc	a5,0x20
    80005cb4:	52c7a623          	sw	a2,1324(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005cb8:	00020517          	auipc	a0,0x20
    80005cbc:	52050513          	addi	a0,a0,1312 # 800261d8 <cons+0x98>
    80005cc0:	ffffc097          	auipc	ra,0xffffc
    80005cc4:	b68080e7          	jalr	-1176(ra) # 80001828 <wakeup>
    80005cc8:	b575                	j	80005b74 <consoleintr+0x3c>

0000000080005cca <consoleinit>:

void
consoleinit(void)
{
    80005cca:	1141                	addi	sp,sp,-16
    80005ccc:	e406                	sd	ra,8(sp)
    80005cce:	e022                	sd	s0,0(sp)
    80005cd0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005cd2:	00003597          	auipc	a1,0x3
    80005cd6:	b3658593          	addi	a1,a1,-1226 # 80008808 <syscalls+0x410>
    80005cda:	00020517          	auipc	a0,0x20
    80005cde:	46650513          	addi	a0,a0,1126 # 80026140 <cons>
    80005ce2:	00000097          	auipc	ra,0x0
    80005ce6:	590080e7          	jalr	1424(ra) # 80006272 <initlock>

  uartinit();
    80005cea:	00000097          	auipc	ra,0x0
    80005cee:	330080e7          	jalr	816(ra) # 8000601a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cf2:	00013797          	auipc	a5,0x13
    80005cf6:	3d678793          	addi	a5,a5,982 # 800190c8 <devsw>
    80005cfa:	00000717          	auipc	a4,0x0
    80005cfe:	ce470713          	addi	a4,a4,-796 # 800059de <consoleread>
    80005d02:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d04:	00000717          	auipc	a4,0x0
    80005d08:	c7870713          	addi	a4,a4,-904 # 8000597c <consolewrite>
    80005d0c:	ef98                	sd	a4,24(a5)
}
    80005d0e:	60a2                	ld	ra,8(sp)
    80005d10:	6402                	ld	s0,0(sp)
    80005d12:	0141                	addi	sp,sp,16
    80005d14:	8082                	ret

0000000080005d16 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d16:	7179                	addi	sp,sp,-48
    80005d18:	f406                	sd	ra,40(sp)
    80005d1a:	f022                	sd	s0,32(sp)
    80005d1c:	ec26                	sd	s1,24(sp)
    80005d1e:	e84a                	sd	s2,16(sp)
    80005d20:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d22:	c219                	beqz	a2,80005d28 <printint+0x12>
    80005d24:	08054663          	bltz	a0,80005db0 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005d28:	2501                	sext.w	a0,a0
    80005d2a:	4881                	li	a7,0
    80005d2c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d30:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d32:	2581                	sext.w	a1,a1
    80005d34:	00003617          	auipc	a2,0x3
    80005d38:	b0460613          	addi	a2,a2,-1276 # 80008838 <digits>
    80005d3c:	883a                	mv	a6,a4
    80005d3e:	2705                	addiw	a4,a4,1
    80005d40:	02b577bb          	remuw	a5,a0,a1
    80005d44:	1782                	slli	a5,a5,0x20
    80005d46:	9381                	srli	a5,a5,0x20
    80005d48:	97b2                	add	a5,a5,a2
    80005d4a:	0007c783          	lbu	a5,0(a5)
    80005d4e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d52:	0005079b          	sext.w	a5,a0
    80005d56:	02b5553b          	divuw	a0,a0,a1
    80005d5a:	0685                	addi	a3,a3,1
    80005d5c:	feb7f0e3          	bgeu	a5,a1,80005d3c <printint+0x26>

  if(sign)
    80005d60:	00088b63          	beqz	a7,80005d76 <printint+0x60>
    buf[i++] = '-';
    80005d64:	fe040793          	addi	a5,s0,-32
    80005d68:	973e                	add	a4,a4,a5
    80005d6a:	02d00793          	li	a5,45
    80005d6e:	fef70823          	sb	a5,-16(a4)
    80005d72:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d76:	02e05763          	blez	a4,80005da4 <printint+0x8e>
    80005d7a:	fd040793          	addi	a5,s0,-48
    80005d7e:	00e784b3          	add	s1,a5,a4
    80005d82:	fff78913          	addi	s2,a5,-1
    80005d86:	993a                	add	s2,s2,a4
    80005d88:	377d                	addiw	a4,a4,-1
    80005d8a:	1702                	slli	a4,a4,0x20
    80005d8c:	9301                	srli	a4,a4,0x20
    80005d8e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d92:	fff4c503          	lbu	a0,-1(s1)
    80005d96:	00000097          	auipc	ra,0x0
    80005d9a:	d60080e7          	jalr	-672(ra) # 80005af6 <consputc>
  while(--i >= 0)
    80005d9e:	14fd                	addi	s1,s1,-1
    80005da0:	ff2499e3          	bne	s1,s2,80005d92 <printint+0x7c>
}
    80005da4:	70a2                	ld	ra,40(sp)
    80005da6:	7402                	ld	s0,32(sp)
    80005da8:	64e2                	ld	s1,24(sp)
    80005daa:	6942                	ld	s2,16(sp)
    80005dac:	6145                	addi	sp,sp,48
    80005dae:	8082                	ret
    x = -xx;
    80005db0:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005db4:	4885                	li	a7,1
    x = -xx;
    80005db6:	bf9d                	j	80005d2c <printint+0x16>

0000000080005db8 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005db8:	1101                	addi	sp,sp,-32
    80005dba:	ec06                	sd	ra,24(sp)
    80005dbc:	e822                	sd	s0,16(sp)
    80005dbe:	e426                	sd	s1,8(sp)
    80005dc0:	1000                	addi	s0,sp,32
    80005dc2:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005dc4:	00020797          	auipc	a5,0x20
    80005dc8:	4207ae23          	sw	zero,1084(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005dcc:	00003517          	auipc	a0,0x3
    80005dd0:	a4450513          	addi	a0,a0,-1468 # 80008810 <syscalls+0x418>
    80005dd4:	00000097          	auipc	ra,0x0
    80005dd8:	02e080e7          	jalr	46(ra) # 80005e02 <printf>
  printf(s);
    80005ddc:	8526                	mv	a0,s1
    80005dde:	00000097          	auipc	ra,0x0
    80005de2:	024080e7          	jalr	36(ra) # 80005e02 <printf>
  printf("\n");
    80005de6:	00002517          	auipc	a0,0x2
    80005dea:	26250513          	addi	a0,a0,610 # 80008048 <etext+0x48>
    80005dee:	00000097          	auipc	ra,0x0
    80005df2:	014080e7          	jalr	20(ra) # 80005e02 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005df6:	4785                	li	a5,1
    80005df8:	00003717          	auipc	a4,0x3
    80005dfc:	22f72223          	sw	a5,548(a4) # 8000901c <panicked>
  for(;;)
    80005e00:	a001                	j	80005e00 <panic+0x48>

0000000080005e02 <printf>:
{
    80005e02:	7131                	addi	sp,sp,-192
    80005e04:	fc86                	sd	ra,120(sp)
    80005e06:	f8a2                	sd	s0,112(sp)
    80005e08:	f4a6                	sd	s1,104(sp)
    80005e0a:	f0ca                	sd	s2,96(sp)
    80005e0c:	ecce                	sd	s3,88(sp)
    80005e0e:	e8d2                	sd	s4,80(sp)
    80005e10:	e4d6                	sd	s5,72(sp)
    80005e12:	e0da                	sd	s6,64(sp)
    80005e14:	fc5e                	sd	s7,56(sp)
    80005e16:	f862                	sd	s8,48(sp)
    80005e18:	f466                	sd	s9,40(sp)
    80005e1a:	f06a                	sd	s10,32(sp)
    80005e1c:	ec6e                	sd	s11,24(sp)
    80005e1e:	0100                	addi	s0,sp,128
    80005e20:	8a2a                	mv	s4,a0
    80005e22:	e40c                	sd	a1,8(s0)
    80005e24:	e810                	sd	a2,16(s0)
    80005e26:	ec14                	sd	a3,24(s0)
    80005e28:	f018                	sd	a4,32(s0)
    80005e2a:	f41c                	sd	a5,40(s0)
    80005e2c:	03043823          	sd	a6,48(s0)
    80005e30:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e34:	00020d97          	auipc	s11,0x20
    80005e38:	3ccdad83          	lw	s11,972(s11) # 80026200 <pr+0x18>
  if(locking)
    80005e3c:	020d9b63          	bnez	s11,80005e72 <printf+0x70>
  if (fmt == 0)
    80005e40:	040a0263          	beqz	s4,80005e84 <printf+0x82>
  va_start(ap, fmt);
    80005e44:	00840793          	addi	a5,s0,8
    80005e48:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e4c:	000a4503          	lbu	a0,0(s4)
    80005e50:	16050263          	beqz	a0,80005fb4 <printf+0x1b2>
    80005e54:	4481                	li	s1,0
    if(c != '%'){
    80005e56:	02500a93          	li	s5,37
    switch(c){
    80005e5a:	07000b13          	li	s6,112
  consputc('x');
    80005e5e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e60:	00003b97          	auipc	s7,0x3
    80005e64:	9d8b8b93          	addi	s7,s7,-1576 # 80008838 <digits>
    switch(c){
    80005e68:	07300c93          	li	s9,115
    80005e6c:	06400c13          	li	s8,100
    80005e70:	a82d                	j	80005eaa <printf+0xa8>
    acquire(&pr.lock);
    80005e72:	00020517          	auipc	a0,0x20
    80005e76:	37650513          	addi	a0,a0,886 # 800261e8 <pr>
    80005e7a:	00000097          	auipc	ra,0x0
    80005e7e:	488080e7          	jalr	1160(ra) # 80006302 <acquire>
    80005e82:	bf7d                	j	80005e40 <printf+0x3e>
    panic("null fmt");
    80005e84:	00003517          	auipc	a0,0x3
    80005e88:	99c50513          	addi	a0,a0,-1636 # 80008820 <syscalls+0x428>
    80005e8c:	00000097          	auipc	ra,0x0
    80005e90:	f2c080e7          	jalr	-212(ra) # 80005db8 <panic>
      consputc(c);
    80005e94:	00000097          	auipc	ra,0x0
    80005e98:	c62080e7          	jalr	-926(ra) # 80005af6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e9c:	2485                	addiw	s1,s1,1
    80005e9e:	009a07b3          	add	a5,s4,s1
    80005ea2:	0007c503          	lbu	a0,0(a5)
    80005ea6:	10050763          	beqz	a0,80005fb4 <printf+0x1b2>
    if(c != '%'){
    80005eaa:	ff5515e3          	bne	a0,s5,80005e94 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005eae:	2485                	addiw	s1,s1,1
    80005eb0:	009a07b3          	add	a5,s4,s1
    80005eb4:	0007c783          	lbu	a5,0(a5)
    80005eb8:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005ebc:	cfe5                	beqz	a5,80005fb4 <printf+0x1b2>
    switch(c){
    80005ebe:	05678a63          	beq	a5,s6,80005f12 <printf+0x110>
    80005ec2:	02fb7663          	bgeu	s6,a5,80005eee <printf+0xec>
    80005ec6:	09978963          	beq	a5,s9,80005f58 <printf+0x156>
    80005eca:	07800713          	li	a4,120
    80005ece:	0ce79863          	bne	a5,a4,80005f9e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005ed2:	f8843783          	ld	a5,-120(s0)
    80005ed6:	00878713          	addi	a4,a5,8
    80005eda:	f8e43423          	sd	a4,-120(s0)
    80005ede:	4605                	li	a2,1
    80005ee0:	85ea                	mv	a1,s10
    80005ee2:	4388                	lw	a0,0(a5)
    80005ee4:	00000097          	auipc	ra,0x0
    80005ee8:	e32080e7          	jalr	-462(ra) # 80005d16 <printint>
      break;
    80005eec:	bf45                	j	80005e9c <printf+0x9a>
    switch(c){
    80005eee:	0b578263          	beq	a5,s5,80005f92 <printf+0x190>
    80005ef2:	0b879663          	bne	a5,s8,80005f9e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005ef6:	f8843783          	ld	a5,-120(s0)
    80005efa:	00878713          	addi	a4,a5,8
    80005efe:	f8e43423          	sd	a4,-120(s0)
    80005f02:	4605                	li	a2,1
    80005f04:	45a9                	li	a1,10
    80005f06:	4388                	lw	a0,0(a5)
    80005f08:	00000097          	auipc	ra,0x0
    80005f0c:	e0e080e7          	jalr	-498(ra) # 80005d16 <printint>
      break;
    80005f10:	b771                	j	80005e9c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f12:	f8843783          	ld	a5,-120(s0)
    80005f16:	00878713          	addi	a4,a5,8
    80005f1a:	f8e43423          	sd	a4,-120(s0)
    80005f1e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005f22:	03000513          	li	a0,48
    80005f26:	00000097          	auipc	ra,0x0
    80005f2a:	bd0080e7          	jalr	-1072(ra) # 80005af6 <consputc>
  consputc('x');
    80005f2e:	07800513          	li	a0,120
    80005f32:	00000097          	auipc	ra,0x0
    80005f36:	bc4080e7          	jalr	-1084(ra) # 80005af6 <consputc>
    80005f3a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f3c:	03c9d793          	srli	a5,s3,0x3c
    80005f40:	97de                	add	a5,a5,s7
    80005f42:	0007c503          	lbu	a0,0(a5)
    80005f46:	00000097          	auipc	ra,0x0
    80005f4a:	bb0080e7          	jalr	-1104(ra) # 80005af6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f4e:	0992                	slli	s3,s3,0x4
    80005f50:	397d                	addiw	s2,s2,-1
    80005f52:	fe0915e3          	bnez	s2,80005f3c <printf+0x13a>
    80005f56:	b799                	j	80005e9c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f58:	f8843783          	ld	a5,-120(s0)
    80005f5c:	00878713          	addi	a4,a5,8
    80005f60:	f8e43423          	sd	a4,-120(s0)
    80005f64:	0007b903          	ld	s2,0(a5)
    80005f68:	00090e63          	beqz	s2,80005f84 <printf+0x182>
      for(; *s; s++)
    80005f6c:	00094503          	lbu	a0,0(s2)
    80005f70:	d515                	beqz	a0,80005e9c <printf+0x9a>
        consputc(*s);
    80005f72:	00000097          	auipc	ra,0x0
    80005f76:	b84080e7          	jalr	-1148(ra) # 80005af6 <consputc>
      for(; *s; s++)
    80005f7a:	0905                	addi	s2,s2,1
    80005f7c:	00094503          	lbu	a0,0(s2)
    80005f80:	f96d                	bnez	a0,80005f72 <printf+0x170>
    80005f82:	bf29                	j	80005e9c <printf+0x9a>
        s = "(null)";
    80005f84:	00003917          	auipc	s2,0x3
    80005f88:	89490913          	addi	s2,s2,-1900 # 80008818 <syscalls+0x420>
      for(; *s; s++)
    80005f8c:	02800513          	li	a0,40
    80005f90:	b7cd                	j	80005f72 <printf+0x170>
      consputc('%');
    80005f92:	8556                	mv	a0,s5
    80005f94:	00000097          	auipc	ra,0x0
    80005f98:	b62080e7          	jalr	-1182(ra) # 80005af6 <consputc>
      break;
    80005f9c:	b701                	j	80005e9c <printf+0x9a>
      consputc('%');
    80005f9e:	8556                	mv	a0,s5
    80005fa0:	00000097          	auipc	ra,0x0
    80005fa4:	b56080e7          	jalr	-1194(ra) # 80005af6 <consputc>
      consputc(c);
    80005fa8:	854a                	mv	a0,s2
    80005faa:	00000097          	auipc	ra,0x0
    80005fae:	b4c080e7          	jalr	-1204(ra) # 80005af6 <consputc>
      break;
    80005fb2:	b5ed                	j	80005e9c <printf+0x9a>
  if(locking)
    80005fb4:	020d9163          	bnez	s11,80005fd6 <printf+0x1d4>
}
    80005fb8:	70e6                	ld	ra,120(sp)
    80005fba:	7446                	ld	s0,112(sp)
    80005fbc:	74a6                	ld	s1,104(sp)
    80005fbe:	7906                	ld	s2,96(sp)
    80005fc0:	69e6                	ld	s3,88(sp)
    80005fc2:	6a46                	ld	s4,80(sp)
    80005fc4:	6aa6                	ld	s5,72(sp)
    80005fc6:	6b06                	ld	s6,64(sp)
    80005fc8:	7be2                	ld	s7,56(sp)
    80005fca:	7c42                	ld	s8,48(sp)
    80005fcc:	7ca2                	ld	s9,40(sp)
    80005fce:	7d02                	ld	s10,32(sp)
    80005fd0:	6de2                	ld	s11,24(sp)
    80005fd2:	6129                	addi	sp,sp,192
    80005fd4:	8082                	ret
    release(&pr.lock);
    80005fd6:	00020517          	auipc	a0,0x20
    80005fda:	21250513          	addi	a0,a0,530 # 800261e8 <pr>
    80005fde:	00000097          	auipc	ra,0x0
    80005fe2:	3d8080e7          	jalr	984(ra) # 800063b6 <release>
}
    80005fe6:	bfc9                	j	80005fb8 <printf+0x1b6>

0000000080005fe8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fe8:	1101                	addi	sp,sp,-32
    80005fea:	ec06                	sd	ra,24(sp)
    80005fec:	e822                	sd	s0,16(sp)
    80005fee:	e426                	sd	s1,8(sp)
    80005ff0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ff2:	00020497          	auipc	s1,0x20
    80005ff6:	1f648493          	addi	s1,s1,502 # 800261e8 <pr>
    80005ffa:	00003597          	auipc	a1,0x3
    80005ffe:	83658593          	addi	a1,a1,-1994 # 80008830 <syscalls+0x438>
    80006002:	8526                	mv	a0,s1
    80006004:	00000097          	auipc	ra,0x0
    80006008:	26e080e7          	jalr	622(ra) # 80006272 <initlock>
  pr.locking = 1;
    8000600c:	4785                	li	a5,1
    8000600e:	cc9c                	sw	a5,24(s1)
}
    80006010:	60e2                	ld	ra,24(sp)
    80006012:	6442                	ld	s0,16(sp)
    80006014:	64a2                	ld	s1,8(sp)
    80006016:	6105                	addi	sp,sp,32
    80006018:	8082                	ret

000000008000601a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000601a:	1141                	addi	sp,sp,-16
    8000601c:	e406                	sd	ra,8(sp)
    8000601e:	e022                	sd	s0,0(sp)
    80006020:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006022:	100007b7          	lui	a5,0x10000
    80006026:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000602a:	f8000713          	li	a4,-128
    8000602e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006032:	470d                	li	a4,3
    80006034:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006038:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000603c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006040:	469d                	li	a3,7
    80006042:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006046:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000604a:	00003597          	auipc	a1,0x3
    8000604e:	80658593          	addi	a1,a1,-2042 # 80008850 <digits+0x18>
    80006052:	00020517          	auipc	a0,0x20
    80006056:	1b650513          	addi	a0,a0,438 # 80026208 <uart_tx_lock>
    8000605a:	00000097          	auipc	ra,0x0
    8000605e:	218080e7          	jalr	536(ra) # 80006272 <initlock>
}
    80006062:	60a2                	ld	ra,8(sp)
    80006064:	6402                	ld	s0,0(sp)
    80006066:	0141                	addi	sp,sp,16
    80006068:	8082                	ret

000000008000606a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000606a:	1101                	addi	sp,sp,-32
    8000606c:	ec06                	sd	ra,24(sp)
    8000606e:	e822                	sd	s0,16(sp)
    80006070:	e426                	sd	s1,8(sp)
    80006072:	1000                	addi	s0,sp,32
    80006074:	84aa                	mv	s1,a0
  push_off();
    80006076:	00000097          	auipc	ra,0x0
    8000607a:	240080e7          	jalr	576(ra) # 800062b6 <push_off>

  if(panicked){
    8000607e:	00003797          	auipc	a5,0x3
    80006082:	f9e7a783          	lw	a5,-98(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006086:	10000737          	lui	a4,0x10000
  if(panicked){
    8000608a:	c391                	beqz	a5,8000608e <uartputc_sync+0x24>
    for(;;)
    8000608c:	a001                	j	8000608c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000608e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006092:	0ff7f793          	andi	a5,a5,255
    80006096:	0207f793          	andi	a5,a5,32
    8000609a:	dbf5                	beqz	a5,8000608e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000609c:	0ff4f793          	andi	a5,s1,255
    800060a0:	10000737          	lui	a4,0x10000
    800060a4:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    800060a8:	00000097          	auipc	ra,0x0
    800060ac:	2ae080e7          	jalr	686(ra) # 80006356 <pop_off>
}
    800060b0:	60e2                	ld	ra,24(sp)
    800060b2:	6442                	ld	s0,16(sp)
    800060b4:	64a2                	ld	s1,8(sp)
    800060b6:	6105                	addi	sp,sp,32
    800060b8:	8082                	ret

00000000800060ba <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060ba:	00003717          	auipc	a4,0x3
    800060be:	f6673703          	ld	a4,-154(a4) # 80009020 <uart_tx_r>
    800060c2:	00003797          	auipc	a5,0x3
    800060c6:	f667b783          	ld	a5,-154(a5) # 80009028 <uart_tx_w>
    800060ca:	06e78c63          	beq	a5,a4,80006142 <uartstart+0x88>
{
    800060ce:	7139                	addi	sp,sp,-64
    800060d0:	fc06                	sd	ra,56(sp)
    800060d2:	f822                	sd	s0,48(sp)
    800060d4:	f426                	sd	s1,40(sp)
    800060d6:	f04a                	sd	s2,32(sp)
    800060d8:	ec4e                	sd	s3,24(sp)
    800060da:	e852                	sd	s4,16(sp)
    800060dc:	e456                	sd	s5,8(sp)
    800060de:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060e0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060e4:	00020a17          	auipc	s4,0x20
    800060e8:	124a0a13          	addi	s4,s4,292 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    800060ec:	00003497          	auipc	s1,0x3
    800060f0:	f3448493          	addi	s1,s1,-204 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060f4:	00003997          	auipc	s3,0x3
    800060f8:	f3498993          	addi	s3,s3,-204 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060fc:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006100:	0ff7f793          	andi	a5,a5,255
    80006104:	0207f793          	andi	a5,a5,32
    80006108:	c785                	beqz	a5,80006130 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000610a:	01f77793          	andi	a5,a4,31
    8000610e:	97d2                	add	a5,a5,s4
    80006110:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006114:	0705                	addi	a4,a4,1
    80006116:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006118:	8526                	mv	a0,s1
    8000611a:	ffffb097          	auipc	ra,0xffffb
    8000611e:	70e080e7          	jalr	1806(ra) # 80001828 <wakeup>
    
    WriteReg(THR, c);
    80006122:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006126:	6098                	ld	a4,0(s1)
    80006128:	0009b783          	ld	a5,0(s3)
    8000612c:	fce798e3          	bne	a5,a4,800060fc <uartstart+0x42>
  }
}
    80006130:	70e2                	ld	ra,56(sp)
    80006132:	7442                	ld	s0,48(sp)
    80006134:	74a2                	ld	s1,40(sp)
    80006136:	7902                	ld	s2,32(sp)
    80006138:	69e2                	ld	s3,24(sp)
    8000613a:	6a42                	ld	s4,16(sp)
    8000613c:	6aa2                	ld	s5,8(sp)
    8000613e:	6121                	addi	sp,sp,64
    80006140:	8082                	ret
    80006142:	8082                	ret

0000000080006144 <uartputc>:
{
    80006144:	7179                	addi	sp,sp,-48
    80006146:	f406                	sd	ra,40(sp)
    80006148:	f022                	sd	s0,32(sp)
    8000614a:	ec26                	sd	s1,24(sp)
    8000614c:	e84a                	sd	s2,16(sp)
    8000614e:	e44e                	sd	s3,8(sp)
    80006150:	e052                	sd	s4,0(sp)
    80006152:	1800                	addi	s0,sp,48
    80006154:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006156:	00020517          	auipc	a0,0x20
    8000615a:	0b250513          	addi	a0,a0,178 # 80026208 <uart_tx_lock>
    8000615e:	00000097          	auipc	ra,0x0
    80006162:	1a4080e7          	jalr	420(ra) # 80006302 <acquire>
  if(panicked){
    80006166:	00003797          	auipc	a5,0x3
    8000616a:	eb67a783          	lw	a5,-330(a5) # 8000901c <panicked>
    8000616e:	c391                	beqz	a5,80006172 <uartputc+0x2e>
    for(;;)
    80006170:	a001                	j	80006170 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006172:	00003797          	auipc	a5,0x3
    80006176:	eb67b783          	ld	a5,-330(a5) # 80009028 <uart_tx_w>
    8000617a:	00003717          	auipc	a4,0x3
    8000617e:	ea673703          	ld	a4,-346(a4) # 80009020 <uart_tx_r>
    80006182:	02070713          	addi	a4,a4,32
    80006186:	02f71b63          	bne	a4,a5,800061bc <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000618a:	00020a17          	auipc	s4,0x20
    8000618e:	07ea0a13          	addi	s4,s4,126 # 80026208 <uart_tx_lock>
    80006192:	00003497          	auipc	s1,0x3
    80006196:	e8e48493          	addi	s1,s1,-370 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000619a:	00003917          	auipc	s2,0x3
    8000619e:	e8e90913          	addi	s2,s2,-370 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061a2:	85d2                	mv	a1,s4
    800061a4:	8526                	mv	a0,s1
    800061a6:	ffffb097          	auipc	ra,0xffffb
    800061aa:	4f6080e7          	jalr	1270(ra) # 8000169c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061ae:	00093783          	ld	a5,0(s2)
    800061b2:	6098                	ld	a4,0(s1)
    800061b4:	02070713          	addi	a4,a4,32
    800061b8:	fef705e3          	beq	a4,a5,800061a2 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061bc:	00020497          	auipc	s1,0x20
    800061c0:	04c48493          	addi	s1,s1,76 # 80026208 <uart_tx_lock>
    800061c4:	01f7f713          	andi	a4,a5,31
    800061c8:	9726                	add	a4,a4,s1
    800061ca:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800061ce:	0785                	addi	a5,a5,1
    800061d0:	00003717          	auipc	a4,0x3
    800061d4:	e4f73c23          	sd	a5,-424(a4) # 80009028 <uart_tx_w>
      uartstart();
    800061d8:	00000097          	auipc	ra,0x0
    800061dc:	ee2080e7          	jalr	-286(ra) # 800060ba <uartstart>
      release(&uart_tx_lock);
    800061e0:	8526                	mv	a0,s1
    800061e2:	00000097          	auipc	ra,0x0
    800061e6:	1d4080e7          	jalr	468(ra) # 800063b6 <release>
}
    800061ea:	70a2                	ld	ra,40(sp)
    800061ec:	7402                	ld	s0,32(sp)
    800061ee:	64e2                	ld	s1,24(sp)
    800061f0:	6942                	ld	s2,16(sp)
    800061f2:	69a2                	ld	s3,8(sp)
    800061f4:	6a02                	ld	s4,0(sp)
    800061f6:	6145                	addi	sp,sp,48
    800061f8:	8082                	ret

00000000800061fa <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061fa:	1141                	addi	sp,sp,-16
    800061fc:	e422                	sd	s0,8(sp)
    800061fe:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006200:	100007b7          	lui	a5,0x10000
    80006204:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006208:	8b85                	andi	a5,a5,1
    8000620a:	cb91                	beqz	a5,8000621e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000620c:	100007b7          	lui	a5,0x10000
    80006210:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006214:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006218:	6422                	ld	s0,8(sp)
    8000621a:	0141                	addi	sp,sp,16
    8000621c:	8082                	ret
    return -1;
    8000621e:	557d                	li	a0,-1
    80006220:	bfe5                	j	80006218 <uartgetc+0x1e>

0000000080006222 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006222:	1101                	addi	sp,sp,-32
    80006224:	ec06                	sd	ra,24(sp)
    80006226:	e822                	sd	s0,16(sp)
    80006228:	e426                	sd	s1,8(sp)
    8000622a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000622c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000622e:	00000097          	auipc	ra,0x0
    80006232:	fcc080e7          	jalr	-52(ra) # 800061fa <uartgetc>
    if(c == -1)
    80006236:	00950763          	beq	a0,s1,80006244 <uartintr+0x22>
      break;
    consoleintr(c);
    8000623a:	00000097          	auipc	ra,0x0
    8000623e:	8fe080e7          	jalr	-1794(ra) # 80005b38 <consoleintr>
  while(1){
    80006242:	b7f5                	j	8000622e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006244:	00020497          	auipc	s1,0x20
    80006248:	fc448493          	addi	s1,s1,-60 # 80026208 <uart_tx_lock>
    8000624c:	8526                	mv	a0,s1
    8000624e:	00000097          	auipc	ra,0x0
    80006252:	0b4080e7          	jalr	180(ra) # 80006302 <acquire>
  uartstart();
    80006256:	00000097          	auipc	ra,0x0
    8000625a:	e64080e7          	jalr	-412(ra) # 800060ba <uartstart>
  release(&uart_tx_lock);
    8000625e:	8526                	mv	a0,s1
    80006260:	00000097          	auipc	ra,0x0
    80006264:	156080e7          	jalr	342(ra) # 800063b6 <release>
}
    80006268:	60e2                	ld	ra,24(sp)
    8000626a:	6442                	ld	s0,16(sp)
    8000626c:	64a2                	ld	s1,8(sp)
    8000626e:	6105                	addi	sp,sp,32
    80006270:	8082                	ret

0000000080006272 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006272:	1141                	addi	sp,sp,-16
    80006274:	e422                	sd	s0,8(sp)
    80006276:	0800                	addi	s0,sp,16
  lk->name = name;
    80006278:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000627a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000627e:	00053823          	sd	zero,16(a0)
}
    80006282:	6422                	ld	s0,8(sp)
    80006284:	0141                	addi	sp,sp,16
    80006286:	8082                	ret

0000000080006288 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006288:	411c                	lw	a5,0(a0)
    8000628a:	e399                	bnez	a5,80006290 <holding+0x8>
    8000628c:	4501                	li	a0,0
  return r;
}
    8000628e:	8082                	ret
{
    80006290:	1101                	addi	sp,sp,-32
    80006292:	ec06                	sd	ra,24(sp)
    80006294:	e822                	sd	s0,16(sp)
    80006296:	e426                	sd	s1,8(sp)
    80006298:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000629a:	6904                	ld	s1,16(a0)
    8000629c:	ffffb097          	auipc	ra,0xffffb
    800062a0:	c72080e7          	jalr	-910(ra) # 80000f0e <mycpu>
    800062a4:	40a48533          	sub	a0,s1,a0
    800062a8:	00153513          	seqz	a0,a0
}
    800062ac:	60e2                	ld	ra,24(sp)
    800062ae:	6442                	ld	s0,16(sp)
    800062b0:	64a2                	ld	s1,8(sp)
    800062b2:	6105                	addi	sp,sp,32
    800062b4:	8082                	ret

00000000800062b6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062b6:	1101                	addi	sp,sp,-32
    800062b8:	ec06                	sd	ra,24(sp)
    800062ba:	e822                	sd	s0,16(sp)
    800062bc:	e426                	sd	s1,8(sp)
    800062be:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062c0:	100024f3          	csrr	s1,sstatus
    800062c4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062c8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062ca:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062ce:	ffffb097          	auipc	ra,0xffffb
    800062d2:	c40080e7          	jalr	-960(ra) # 80000f0e <mycpu>
    800062d6:	5d3c                	lw	a5,120(a0)
    800062d8:	cf89                	beqz	a5,800062f2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062da:	ffffb097          	auipc	ra,0xffffb
    800062de:	c34080e7          	jalr	-972(ra) # 80000f0e <mycpu>
    800062e2:	5d3c                	lw	a5,120(a0)
    800062e4:	2785                	addiw	a5,a5,1
    800062e6:	dd3c                	sw	a5,120(a0)
}
    800062e8:	60e2                	ld	ra,24(sp)
    800062ea:	6442                	ld	s0,16(sp)
    800062ec:	64a2                	ld	s1,8(sp)
    800062ee:	6105                	addi	sp,sp,32
    800062f0:	8082                	ret
    mycpu()->intena = old;
    800062f2:	ffffb097          	auipc	ra,0xffffb
    800062f6:	c1c080e7          	jalr	-996(ra) # 80000f0e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062fa:	8085                	srli	s1,s1,0x1
    800062fc:	8885                	andi	s1,s1,1
    800062fe:	dd64                	sw	s1,124(a0)
    80006300:	bfe9                	j	800062da <push_off+0x24>

0000000080006302 <acquire>:
{
    80006302:	1101                	addi	sp,sp,-32
    80006304:	ec06                	sd	ra,24(sp)
    80006306:	e822                	sd	s0,16(sp)
    80006308:	e426                	sd	s1,8(sp)
    8000630a:	1000                	addi	s0,sp,32
    8000630c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000630e:	00000097          	auipc	ra,0x0
    80006312:	fa8080e7          	jalr	-88(ra) # 800062b6 <push_off>
  if(holding(lk))
    80006316:	8526                	mv	a0,s1
    80006318:	00000097          	auipc	ra,0x0
    8000631c:	f70080e7          	jalr	-144(ra) # 80006288 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006320:	4705                	li	a4,1
  if(holding(lk))
    80006322:	e115                	bnez	a0,80006346 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006324:	87ba                	mv	a5,a4
    80006326:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000632a:	2781                	sext.w	a5,a5
    8000632c:	ffe5                	bnez	a5,80006324 <acquire+0x22>
  __sync_synchronize();
    8000632e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006332:	ffffb097          	auipc	ra,0xffffb
    80006336:	bdc080e7          	jalr	-1060(ra) # 80000f0e <mycpu>
    8000633a:	e888                	sd	a0,16(s1)
}
    8000633c:	60e2                	ld	ra,24(sp)
    8000633e:	6442                	ld	s0,16(sp)
    80006340:	64a2                	ld	s1,8(sp)
    80006342:	6105                	addi	sp,sp,32
    80006344:	8082                	ret
    panic("acquire");
    80006346:	00002517          	auipc	a0,0x2
    8000634a:	51250513          	addi	a0,a0,1298 # 80008858 <digits+0x20>
    8000634e:	00000097          	auipc	ra,0x0
    80006352:	a6a080e7          	jalr	-1430(ra) # 80005db8 <panic>

0000000080006356 <pop_off>:

void
pop_off(void)
{
    80006356:	1141                	addi	sp,sp,-16
    80006358:	e406                	sd	ra,8(sp)
    8000635a:	e022                	sd	s0,0(sp)
    8000635c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000635e:	ffffb097          	auipc	ra,0xffffb
    80006362:	bb0080e7          	jalr	-1104(ra) # 80000f0e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006366:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000636a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000636c:	e78d                	bnez	a5,80006396 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000636e:	5d3c                	lw	a5,120(a0)
    80006370:	02f05b63          	blez	a5,800063a6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006374:	37fd                	addiw	a5,a5,-1
    80006376:	0007871b          	sext.w	a4,a5
    8000637a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000637c:	eb09                	bnez	a4,8000638e <pop_off+0x38>
    8000637e:	5d7c                	lw	a5,124(a0)
    80006380:	c799                	beqz	a5,8000638e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006382:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006386:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000638a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000638e:	60a2                	ld	ra,8(sp)
    80006390:	6402                	ld	s0,0(sp)
    80006392:	0141                	addi	sp,sp,16
    80006394:	8082                	ret
    panic("pop_off - interruptible");
    80006396:	00002517          	auipc	a0,0x2
    8000639a:	4ca50513          	addi	a0,a0,1226 # 80008860 <digits+0x28>
    8000639e:	00000097          	auipc	ra,0x0
    800063a2:	a1a080e7          	jalr	-1510(ra) # 80005db8 <panic>
    panic("pop_off");
    800063a6:	00002517          	auipc	a0,0x2
    800063aa:	4d250513          	addi	a0,a0,1234 # 80008878 <digits+0x40>
    800063ae:	00000097          	auipc	ra,0x0
    800063b2:	a0a080e7          	jalr	-1526(ra) # 80005db8 <panic>

00000000800063b6 <release>:
{
    800063b6:	1101                	addi	sp,sp,-32
    800063b8:	ec06                	sd	ra,24(sp)
    800063ba:	e822                	sd	s0,16(sp)
    800063bc:	e426                	sd	s1,8(sp)
    800063be:	1000                	addi	s0,sp,32
    800063c0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063c2:	00000097          	auipc	ra,0x0
    800063c6:	ec6080e7          	jalr	-314(ra) # 80006288 <holding>
    800063ca:	c115                	beqz	a0,800063ee <release+0x38>
  lk->cpu = 0;
    800063cc:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063d0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063d4:	0f50000f          	fence	iorw,ow
    800063d8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063dc:	00000097          	auipc	ra,0x0
    800063e0:	f7a080e7          	jalr	-134(ra) # 80006356 <pop_off>
}
    800063e4:	60e2                	ld	ra,24(sp)
    800063e6:	6442                	ld	s0,16(sp)
    800063e8:	64a2                	ld	s1,8(sp)
    800063ea:	6105                	addi	sp,sp,32
    800063ec:	8082                	ret
    panic("release");
    800063ee:	00002517          	auipc	a0,0x2
    800063f2:	49250513          	addi	a0,a0,1170 # 80008880 <digits+0x48>
    800063f6:	00000097          	auipc	ra,0x0
    800063fa:	9c2080e7          	jalr	-1598(ra) # 80005db8 <panic>
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
