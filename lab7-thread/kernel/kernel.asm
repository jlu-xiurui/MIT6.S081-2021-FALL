
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
    80000016:	652050ef          	jal	ra,80005668 <start>

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
    8000005e:	008080e7          	jalr	8(ra) # 80006062 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	0a8080e7          	jalr	168(ra) # 80006116 <release>
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
    8000008e:	a8e080e7          	jalr	-1394(ra) # 80005b18 <panic>

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
    800000f8:	ede080e7          	jalr	-290(ra) # 80005fd2 <initlock>
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
    80000130:	f36080e7          	jalr	-202(ra) # 80006062 <acquire>
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
    80000148:	fd2080e7          	jalr	-46(ra) # 80006116 <release>

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
    80000172:	fa8080e7          	jalr	-88(ra) # 80006116 <release>
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
    80000360:	806080e7          	jalr	-2042(ra) # 80005b62 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	728080e7          	jalr	1832(ra) # 80001a94 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	c7c080e7          	jalr	-900(ra) # 80004ff0 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fd6080e7          	jalr	-42(ra) # 80001352 <scheduler>
    consoleinit();
    80000384:	00005097          	auipc	ra,0x5
    80000388:	6a6080e7          	jalr	1702(ra) # 80005a2a <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	9bc080e7          	jalr	-1604(ra) # 80005d48 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00005097          	auipc	ra,0x5
    800003a0:	7c6080e7          	jalr	1990(ra) # 80005b62 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00005097          	auipc	ra,0x5
    800003b0:	7b6080e7          	jalr	1974(ra) # 80005b62 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00005097          	auipc	ra,0x5
    800003c0:	7a6080e7          	jalr	1958(ra) # 80005b62 <printf>
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
    800003e8:	688080e7          	jalr	1672(ra) # 80001a6c <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	6a8080e7          	jalr	1704(ra) # 80001a94 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	be6080e7          	jalr	-1050(ra) # 80004fda <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	bf4080e7          	jalr	-1036(ra) # 80004ff0 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	dd2080e7          	jalr	-558(ra) # 800021d6 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	462080e7          	jalr	1122(ra) # 8000286e <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	40c080e7          	jalr	1036(ra) # 80003820 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	cf6080e7          	jalr	-778(ra) # 80005112 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	cfc080e7          	jalr	-772(ra) # 80001120 <userinit>
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
    8000048e:	00005097          	auipc	ra,0x5
    80000492:	68a080e7          	jalr	1674(ra) # 80005b18 <panic>
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
    80000586:	00005097          	auipc	ra,0x5
    8000058a:	592080e7          	jalr	1426(ra) # 80005b18 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00005097          	auipc	ra,0x5
    8000059a:	582080e7          	jalr	1410(ra) # 80005b18 <panic>
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
    80000610:	00005097          	auipc	ra,0x5
    80000614:	508080e7          	jalr	1288(ra) # 80005b18 <panic>

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
    80000760:	3bc080e7          	jalr	956(ra) # 80005b18 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	3ac080e7          	jalr	940(ra) # 80005b18 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	39c080e7          	jalr	924(ra) # 80005b18 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	38c080e7          	jalr	908(ra) # 80005b18 <panic>
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
    8000086e:	2ae080e7          	jalr	686(ra) # 80005b18 <panic>

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
    800009b0:	16c080e7          	jalr	364(ra) # 80005b18 <panic>
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
    80000a8c:	090080e7          	jalr	144(ra) # 80005b18 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	080080e7          	jalr	128(ra) # 80005b18 <panic>
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
    80000b06:	016080e7          	jalr	22(ra) # 80005b18 <panic>

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
    80000d0a:	17aa0a13          	addi	s4,s4,378 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000d0e:	fffff097          	auipc	ra,0xfffff
    80000d12:	40a080e7          	jalr	1034(ra) # 80000118 <kalloc>
    80000d16:	862a                	mv	a2,a0
    if(pa == 0)
    80000d18:	c131                	beqz	a0,80000d5c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d1a:	416485b3          	sub	a1,s1,s6
    80000d1e:	858d                	srai	a1,a1,0x3
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
    80000d40:	16848493          	addi	s1,s1,360
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
    80000d68:	db4080e7          	jalr	-588(ra) # 80005b18 <panic>

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
    80000d94:	242080e7          	jalr	578(ra) # 80005fd2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d98:	00007597          	auipc	a1,0x7
    80000d9c:	3d058593          	addi	a1,a1,976 # 80008168 <etext+0x168>
    80000da0:	00008517          	auipc	a0,0x8
    80000da4:	2c850513          	addi	a0,a0,712 # 80009068 <wait_lock>
    80000da8:	00005097          	auipc	ra,0x5
    80000dac:	22a080e7          	jalr	554(ra) # 80005fd2 <initlock>
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
    80000dd6:	0ae98993          	addi	s3,s3,174 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000dda:	85da                	mv	a1,s6
    80000ddc:	8526                	mv	a0,s1
    80000dde:	00005097          	auipc	ra,0x5
    80000de2:	1f4080e7          	jalr	500(ra) # 80005fd2 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	415487b3          	sub	a5,s1,s5
    80000dea:	878d                	srai	a5,a5,0x3
    80000dec:	000a3703          	ld	a4,0(s4)
    80000df0:	02e787b3          	mul	a5,a5,a4
    80000df4:	2785                	addiw	a5,a5,1
    80000df6:	00d7979b          	slliw	a5,a5,0xd
    80000dfa:	40f907b3          	sub	a5,s2,a5
    80000dfe:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	16848493          	addi	s1,s1,360
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
    80000e56:	1c4080e7          	jalr	452(ra) # 80006016 <push_off>
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
    80000e70:	24a080e7          	jalr	586(ra) # 800060b6 <pop_off>
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
    80000e94:	286080e7          	jalr	646(ra) # 80006116 <release>

  if (first) {
    80000e98:	00008797          	auipc	a5,0x8
    80000e9c:	9787a783          	lw	a5,-1672(a5) # 80008810 <first.1672>
    80000ea0:	eb89                	bnez	a5,80000eb2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ea2:	00001097          	auipc	ra,0x1
    80000ea6:	c0a080e7          	jalr	-1014(ra) # 80001aac <usertrapret>
}
    80000eaa:	60a2                	ld	ra,8(sp)
    80000eac:	6402                	ld	s0,0(sp)
    80000eae:	0141                	addi	sp,sp,16
    80000eb0:	8082                	ret
    first = 0;
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	9407af23          	sw	zero,-1698(a5) # 80008810 <first.1672>
    fsinit(ROOTDEV);
    80000eba:	4505                	li	a0,1
    80000ebc:	00002097          	auipc	ra,0x2
    80000ec0:	932080e7          	jalr	-1742(ra) # 800027ee <fsinit>
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
    80000ee0:	186080e7          	jalr	390(ra) # 80006062 <acquire>
  pid = nextpid;
    80000ee4:	00008797          	auipc	a5,0x8
    80000ee8:	93078793          	addi	a5,a5,-1744 # 80008814 <nextpid>
    80000eec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eee:	0014871b          	addiw	a4,s1,1
    80000ef2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	220080e7          	jalr	544(ra) # 80006116 <release>
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
    80000f48:	05893683          	ld	a3,88(s2)
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
    80001006:	6d28                	ld	a0,88(a0)
    80001008:	c509                	beqz	a0,80001012 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	012080e7          	jalr	18(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001012:	0404bc23          	sd	zero,88(s1)
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
    80001034:	14048c23          	sb	zero,344(s1)
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
    8000106a:	e1a90913          	addi	s2,s2,-486 # 8000ee80 <tickslock>
    acquire(&p->lock);
    8000106e:	8526                	mv	a0,s1
    80001070:	00005097          	auipc	ra,0x5
    80001074:	ff2080e7          	jalr	-14(ra) # 80006062 <acquire>
    if(p->state == UNUSED) {
    80001078:	4c9c                	lw	a5,24(s1)
    8000107a:	cf81                	beqz	a5,80001092 <allocproc+0x40>
      release(&p->lock);
    8000107c:	8526                	mv	a0,s1
    8000107e:	00005097          	auipc	ra,0x5
    80001082:	098080e7          	jalr	152(ra) # 80006116 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001086:	16848493          	addi	s1,s1,360
    8000108a:	ff2492e3          	bne	s1,s2,8000106e <allocproc+0x1c>
  return 0;
    8000108e:	4481                	li	s1,0
    80001090:	a889                	j	800010e2 <allocproc+0x90>
  p->pid = allocpid();
    80001092:	00000097          	auipc	ra,0x0
    80001096:	e34080e7          	jalr	-460(ra) # 80000ec6 <allocpid>
    8000109a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000109c:	4785                	li	a5,1
    8000109e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010a0:	fffff097          	auipc	ra,0xfffff
    800010a4:	078080e7          	jalr	120(ra) # 80000118 <kalloc>
    800010a8:	892a                	mv	s2,a0
    800010aa:	eca8                	sd	a0,88(s1)
    800010ac:	c131                	beqz	a0,800010f0 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010ae:	8526                	mv	a0,s1
    800010b0:	00000097          	auipc	ra,0x0
    800010b4:	e5c080e7          	jalr	-420(ra) # 80000f0c <proc_pagetable>
    800010b8:	892a                	mv	s2,a0
    800010ba:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010bc:	c531                	beqz	a0,80001108 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010be:	07000613          	li	a2,112
    800010c2:	4581                	li	a1,0
    800010c4:	06048513          	addi	a0,s1,96
    800010c8:	fffff097          	auipc	ra,0xfffff
    800010cc:	0b0080e7          	jalr	176(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010d0:	00000797          	auipc	a5,0x0
    800010d4:	db078793          	addi	a5,a5,-592 # 80000e80 <forkret>
    800010d8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010da:	60bc                	ld	a5,64(s1)
    800010dc:	6705                	lui	a4,0x1
    800010de:	97ba                	add	a5,a5,a4
    800010e0:	f4bc                	sd	a5,104(s1)
}
    800010e2:	8526                	mv	a0,s1
    800010e4:	60e2                	ld	ra,24(sp)
    800010e6:	6442                	ld	s0,16(sp)
    800010e8:	64a2                	ld	s1,8(sp)
    800010ea:	6902                	ld	s2,0(sp)
    800010ec:	6105                	addi	sp,sp,32
    800010ee:	8082                	ret
    freeproc(p);
    800010f0:	8526                	mv	a0,s1
    800010f2:	00000097          	auipc	ra,0x0
    800010f6:	f08080e7          	jalr	-248(ra) # 80000ffa <freeproc>
    release(&p->lock);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00005097          	auipc	ra,0x5
    80001100:	01a080e7          	jalr	26(ra) # 80006116 <release>
    return 0;
    80001104:	84ca                	mv	s1,s2
    80001106:	bff1                	j	800010e2 <allocproc+0x90>
    freeproc(p);
    80001108:	8526                	mv	a0,s1
    8000110a:	00000097          	auipc	ra,0x0
    8000110e:	ef0080e7          	jalr	-272(ra) # 80000ffa <freeproc>
    release(&p->lock);
    80001112:	8526                	mv	a0,s1
    80001114:	00005097          	auipc	ra,0x5
    80001118:	002080e7          	jalr	2(ra) # 80006116 <release>
    return 0;
    8000111c:	84ca                	mv	s1,s2
    8000111e:	b7d1                	j	800010e2 <allocproc+0x90>

0000000080001120 <userinit>:
{
    80001120:	1101                	addi	sp,sp,-32
    80001122:	ec06                	sd	ra,24(sp)
    80001124:	e822                	sd	s0,16(sp)
    80001126:	e426                	sd	s1,8(sp)
    80001128:	1000                	addi	s0,sp,32
  p = allocproc();
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	f28080e7          	jalr	-216(ra) # 80001052 <allocproc>
    80001132:	84aa                	mv	s1,a0
  initproc = p;
    80001134:	00008797          	auipc	a5,0x8
    80001138:	eca7be23          	sd	a0,-292(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000113c:	03400613          	li	a2,52
    80001140:	00007597          	auipc	a1,0x7
    80001144:	6e058593          	addi	a1,a1,1760 # 80008820 <initcode>
    80001148:	6928                	ld	a0,80(a0)
    8000114a:	fffff097          	auipc	ra,0xfffff
    8000114e:	6b6080e7          	jalr	1718(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    80001152:	6785                	lui	a5,0x1
    80001154:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001156:	6cb8                	ld	a4,88(s1)
    80001158:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000115c:	6cb8                	ld	a4,88(s1)
    8000115e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001160:	4641                	li	a2,16
    80001162:	00007597          	auipc	a1,0x7
    80001166:	01e58593          	addi	a1,a1,30 # 80008180 <etext+0x180>
    8000116a:	15848513          	addi	a0,s1,344
    8000116e:	fffff097          	auipc	ra,0xfffff
    80001172:	15c080e7          	jalr	348(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001176:	00007517          	auipc	a0,0x7
    8000117a:	01a50513          	addi	a0,a0,26 # 80008190 <etext+0x190>
    8000117e:	00002097          	auipc	ra,0x2
    80001182:	09e080e7          	jalr	158(ra) # 8000321c <namei>
    80001186:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000118a:	478d                	li	a5,3
    8000118c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000118e:	8526                	mv	a0,s1
    80001190:	00005097          	auipc	ra,0x5
    80001194:	f86080e7          	jalr	-122(ra) # 80006116 <release>
}
    80001198:	60e2                	ld	ra,24(sp)
    8000119a:	6442                	ld	s0,16(sp)
    8000119c:	64a2                	ld	s1,8(sp)
    8000119e:	6105                	addi	sp,sp,32
    800011a0:	8082                	ret

00000000800011a2 <growproc>:
{
    800011a2:	1101                	addi	sp,sp,-32
    800011a4:	ec06                	sd	ra,24(sp)
    800011a6:	e822                	sd	s0,16(sp)
    800011a8:	e426                	sd	s1,8(sp)
    800011aa:	e04a                	sd	s2,0(sp)
    800011ac:	1000                	addi	s0,sp,32
    800011ae:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011b0:	00000097          	auipc	ra,0x0
    800011b4:	c98080e7          	jalr	-872(ra) # 80000e48 <myproc>
    800011b8:	892a                	mv	s2,a0
  sz = p->sz;
    800011ba:	652c                	ld	a1,72(a0)
    800011bc:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011c0:	00904f63          	bgtz	s1,800011de <growproc+0x3c>
  } else if(n < 0){
    800011c4:	0204cc63          	bltz	s1,800011fc <growproc+0x5a>
  p->sz = sz;
    800011c8:	1602                	slli	a2,a2,0x20
    800011ca:	9201                	srli	a2,a2,0x20
    800011cc:	04c93423          	sd	a2,72(s2)
  return 0;
    800011d0:	4501                	li	a0,0
}
    800011d2:	60e2                	ld	ra,24(sp)
    800011d4:	6442                	ld	s0,16(sp)
    800011d6:	64a2                	ld	s1,8(sp)
    800011d8:	6902                	ld	s2,0(sp)
    800011da:	6105                	addi	sp,sp,32
    800011dc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011de:	9e25                	addw	a2,a2,s1
    800011e0:	1602                	slli	a2,a2,0x20
    800011e2:	9201                	srli	a2,a2,0x20
    800011e4:	1582                	slli	a1,a1,0x20
    800011e6:	9181                	srli	a1,a1,0x20
    800011e8:	6928                	ld	a0,80(a0)
    800011ea:	fffff097          	auipc	ra,0xfffff
    800011ee:	6d0080e7          	jalr	1744(ra) # 800008ba <uvmalloc>
    800011f2:	0005061b          	sext.w	a2,a0
    800011f6:	fa69                	bnez	a2,800011c8 <growproc+0x26>
      return -1;
    800011f8:	557d                	li	a0,-1
    800011fa:	bfe1                	j	800011d2 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011fc:	9e25                	addw	a2,a2,s1
    800011fe:	1602                	slli	a2,a2,0x20
    80001200:	9201                	srli	a2,a2,0x20
    80001202:	1582                	slli	a1,a1,0x20
    80001204:	9181                	srli	a1,a1,0x20
    80001206:	6928                	ld	a0,80(a0)
    80001208:	fffff097          	auipc	ra,0xfffff
    8000120c:	66a080e7          	jalr	1642(ra) # 80000872 <uvmdealloc>
    80001210:	0005061b          	sext.w	a2,a0
    80001214:	bf55                	j	800011c8 <growproc+0x26>

0000000080001216 <fork>:
{
    80001216:	7179                	addi	sp,sp,-48
    80001218:	f406                	sd	ra,40(sp)
    8000121a:	f022                	sd	s0,32(sp)
    8000121c:	ec26                	sd	s1,24(sp)
    8000121e:	e84a                	sd	s2,16(sp)
    80001220:	e44e                	sd	s3,8(sp)
    80001222:	e052                	sd	s4,0(sp)
    80001224:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	c22080e7          	jalr	-990(ra) # 80000e48 <myproc>
    8000122e:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001230:	00000097          	auipc	ra,0x0
    80001234:	e22080e7          	jalr	-478(ra) # 80001052 <allocproc>
    80001238:	10050b63          	beqz	a0,8000134e <fork+0x138>
    8000123c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000123e:	04893603          	ld	a2,72(s2)
    80001242:	692c                	ld	a1,80(a0)
    80001244:	05093503          	ld	a0,80(s2)
    80001248:	fffff097          	auipc	ra,0xfffff
    8000124c:	7be080e7          	jalr	1982(ra) # 80000a06 <uvmcopy>
    80001250:	04054663          	bltz	a0,8000129c <fork+0x86>
  np->sz = p->sz;
    80001254:	04893783          	ld	a5,72(s2)
    80001258:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000125c:	05893683          	ld	a3,88(s2)
    80001260:	87b6                	mv	a5,a3
    80001262:	0589b703          	ld	a4,88(s3)
    80001266:	12068693          	addi	a3,a3,288
    8000126a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000126e:	6788                	ld	a0,8(a5)
    80001270:	6b8c                	ld	a1,16(a5)
    80001272:	6f90                	ld	a2,24(a5)
    80001274:	01073023          	sd	a6,0(a4)
    80001278:	e708                	sd	a0,8(a4)
    8000127a:	eb0c                	sd	a1,16(a4)
    8000127c:	ef10                	sd	a2,24(a4)
    8000127e:	02078793          	addi	a5,a5,32
    80001282:	02070713          	addi	a4,a4,32
    80001286:	fed792e3          	bne	a5,a3,8000126a <fork+0x54>
  np->trapframe->a0 = 0;
    8000128a:	0589b783          	ld	a5,88(s3)
    8000128e:	0607b823          	sd	zero,112(a5)
    80001292:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001296:	15000a13          	li	s4,336
    8000129a:	a03d                	j	800012c8 <fork+0xb2>
    freeproc(np);
    8000129c:	854e                	mv	a0,s3
    8000129e:	00000097          	auipc	ra,0x0
    800012a2:	d5c080e7          	jalr	-676(ra) # 80000ffa <freeproc>
    release(&np->lock);
    800012a6:	854e                	mv	a0,s3
    800012a8:	00005097          	auipc	ra,0x5
    800012ac:	e6e080e7          	jalr	-402(ra) # 80006116 <release>
    return -1;
    800012b0:	5a7d                	li	s4,-1
    800012b2:	a069                	j	8000133c <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800012b4:	00002097          	auipc	ra,0x2
    800012b8:	5fe080e7          	jalr	1534(ra) # 800038b2 <filedup>
    800012bc:	009987b3          	add	a5,s3,s1
    800012c0:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012c2:	04a1                	addi	s1,s1,8
    800012c4:	01448763          	beq	s1,s4,800012d2 <fork+0xbc>
    if(p->ofile[i])
    800012c8:	009907b3          	add	a5,s2,s1
    800012cc:	6388                	ld	a0,0(a5)
    800012ce:	f17d                	bnez	a0,800012b4 <fork+0x9e>
    800012d0:	bfcd                	j	800012c2 <fork+0xac>
  np->cwd = idup(p->cwd);
    800012d2:	15093503          	ld	a0,336(s2)
    800012d6:	00001097          	auipc	ra,0x1
    800012da:	752080e7          	jalr	1874(ra) # 80002a28 <idup>
    800012de:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012e2:	4641                	li	a2,16
    800012e4:	15890593          	addi	a1,s2,344
    800012e8:	15898513          	addi	a0,s3,344
    800012ec:	fffff097          	auipc	ra,0xfffff
    800012f0:	fde080e7          	jalr	-34(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    800012f4:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800012f8:	854e                	mv	a0,s3
    800012fa:	00005097          	auipc	ra,0x5
    800012fe:	e1c080e7          	jalr	-484(ra) # 80006116 <release>
  acquire(&wait_lock);
    80001302:	00008497          	auipc	s1,0x8
    80001306:	d6648493          	addi	s1,s1,-666 # 80009068 <wait_lock>
    8000130a:	8526                	mv	a0,s1
    8000130c:	00005097          	auipc	ra,0x5
    80001310:	d56080e7          	jalr	-682(ra) # 80006062 <acquire>
  np->parent = p;
    80001314:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001318:	8526                	mv	a0,s1
    8000131a:	00005097          	auipc	ra,0x5
    8000131e:	dfc080e7          	jalr	-516(ra) # 80006116 <release>
  acquire(&np->lock);
    80001322:	854e                	mv	a0,s3
    80001324:	00005097          	auipc	ra,0x5
    80001328:	d3e080e7          	jalr	-706(ra) # 80006062 <acquire>
  np->state = RUNNABLE;
    8000132c:	478d                	li	a5,3
    8000132e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001332:	854e                	mv	a0,s3
    80001334:	00005097          	auipc	ra,0x5
    80001338:	de2080e7          	jalr	-542(ra) # 80006116 <release>
}
    8000133c:	8552                	mv	a0,s4
    8000133e:	70a2                	ld	ra,40(sp)
    80001340:	7402                	ld	s0,32(sp)
    80001342:	64e2                	ld	s1,24(sp)
    80001344:	6942                	ld	s2,16(sp)
    80001346:	69a2                	ld	s3,8(sp)
    80001348:	6a02                	ld	s4,0(sp)
    8000134a:	6145                	addi	sp,sp,48
    8000134c:	8082                	ret
    return -1;
    8000134e:	5a7d                	li	s4,-1
    80001350:	b7f5                	j	8000133c <fork+0x126>

0000000080001352 <scheduler>:
{
    80001352:	7139                	addi	sp,sp,-64
    80001354:	fc06                	sd	ra,56(sp)
    80001356:	f822                	sd	s0,48(sp)
    80001358:	f426                	sd	s1,40(sp)
    8000135a:	f04a                	sd	s2,32(sp)
    8000135c:	ec4e                	sd	s3,24(sp)
    8000135e:	e852                	sd	s4,16(sp)
    80001360:	e456                	sd	s5,8(sp)
    80001362:	e05a                	sd	s6,0(sp)
    80001364:	0080                	addi	s0,sp,64
    80001366:	8792                	mv	a5,tp
  int id = r_tp();
    80001368:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000136a:	00779a93          	slli	s5,a5,0x7
    8000136e:	00008717          	auipc	a4,0x8
    80001372:	ce270713          	addi	a4,a4,-798 # 80009050 <pid_lock>
    80001376:	9756                	add	a4,a4,s5
    80001378:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000137c:	00008717          	auipc	a4,0x8
    80001380:	d0c70713          	addi	a4,a4,-756 # 80009088 <cpus+0x8>
    80001384:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001386:	498d                	li	s3,3
        p->state = RUNNING;
    80001388:	4b11                	li	s6,4
        c->proc = p;
    8000138a:	079e                	slli	a5,a5,0x7
    8000138c:	00008a17          	auipc	s4,0x8
    80001390:	cc4a0a13          	addi	s4,s4,-828 # 80009050 <pid_lock>
    80001394:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001396:	0000e917          	auipc	s2,0xe
    8000139a:	aea90913          	addi	s2,s2,-1302 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000139e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013a2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013a6:	10079073          	csrw	sstatus,a5
    800013aa:	00008497          	auipc	s1,0x8
    800013ae:	0d648493          	addi	s1,s1,214 # 80009480 <proc>
    800013b2:	a03d                	j	800013e0 <scheduler+0x8e>
        p->state = RUNNING;
    800013b4:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013b8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013bc:	06048593          	addi	a1,s1,96
    800013c0:	8556                	mv	a0,s5
    800013c2:	00000097          	auipc	ra,0x0
    800013c6:	640080e7          	jalr	1600(ra) # 80001a02 <swtch>
        c->proc = 0;
    800013ca:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013ce:	8526                	mv	a0,s1
    800013d0:	00005097          	auipc	ra,0x5
    800013d4:	d46080e7          	jalr	-698(ra) # 80006116 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013d8:	16848493          	addi	s1,s1,360
    800013dc:	fd2481e3          	beq	s1,s2,8000139e <scheduler+0x4c>
      acquire(&p->lock);
    800013e0:	8526                	mv	a0,s1
    800013e2:	00005097          	auipc	ra,0x5
    800013e6:	c80080e7          	jalr	-896(ra) # 80006062 <acquire>
      if(p->state == RUNNABLE) {
    800013ea:	4c9c                	lw	a5,24(s1)
    800013ec:	ff3791e3          	bne	a5,s3,800013ce <scheduler+0x7c>
    800013f0:	b7d1                	j	800013b4 <scheduler+0x62>

00000000800013f2 <sched>:
{
    800013f2:	7179                	addi	sp,sp,-48
    800013f4:	f406                	sd	ra,40(sp)
    800013f6:	f022                	sd	s0,32(sp)
    800013f8:	ec26                	sd	s1,24(sp)
    800013fa:	e84a                	sd	s2,16(sp)
    800013fc:	e44e                	sd	s3,8(sp)
    800013fe:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001400:	00000097          	auipc	ra,0x0
    80001404:	a48080e7          	jalr	-1464(ra) # 80000e48 <myproc>
    80001408:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000140a:	00005097          	auipc	ra,0x5
    8000140e:	bde080e7          	jalr	-1058(ra) # 80005fe8 <holding>
    80001412:	c93d                	beqz	a0,80001488 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001414:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001416:	2781                	sext.w	a5,a5
    80001418:	079e                	slli	a5,a5,0x7
    8000141a:	00008717          	auipc	a4,0x8
    8000141e:	c3670713          	addi	a4,a4,-970 # 80009050 <pid_lock>
    80001422:	97ba                	add	a5,a5,a4
    80001424:	0a87a703          	lw	a4,168(a5)
    80001428:	4785                	li	a5,1
    8000142a:	06f71763          	bne	a4,a5,80001498 <sched+0xa6>
  if(p->state == RUNNING)
    8000142e:	4c98                	lw	a4,24(s1)
    80001430:	4791                	li	a5,4
    80001432:	06f70b63          	beq	a4,a5,800014a8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001436:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000143a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000143c:	efb5                	bnez	a5,800014b8 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000143e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001440:	00008917          	auipc	s2,0x8
    80001444:	c1090913          	addi	s2,s2,-1008 # 80009050 <pid_lock>
    80001448:	2781                	sext.w	a5,a5
    8000144a:	079e                	slli	a5,a5,0x7
    8000144c:	97ca                	add	a5,a5,s2
    8000144e:	0ac7a983          	lw	s3,172(a5)
    80001452:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001454:	2781                	sext.w	a5,a5
    80001456:	079e                	slli	a5,a5,0x7
    80001458:	00008597          	auipc	a1,0x8
    8000145c:	c3058593          	addi	a1,a1,-976 # 80009088 <cpus+0x8>
    80001460:	95be                	add	a1,a1,a5
    80001462:	06048513          	addi	a0,s1,96
    80001466:	00000097          	auipc	ra,0x0
    8000146a:	59c080e7          	jalr	1436(ra) # 80001a02 <swtch>
    8000146e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001470:	2781                	sext.w	a5,a5
    80001472:	079e                	slli	a5,a5,0x7
    80001474:	97ca                	add	a5,a5,s2
    80001476:	0b37a623          	sw	s3,172(a5)
}
    8000147a:	70a2                	ld	ra,40(sp)
    8000147c:	7402                	ld	s0,32(sp)
    8000147e:	64e2                	ld	s1,24(sp)
    80001480:	6942                	ld	s2,16(sp)
    80001482:	69a2                	ld	s3,8(sp)
    80001484:	6145                	addi	sp,sp,48
    80001486:	8082                	ret
    panic("sched p->lock");
    80001488:	00007517          	auipc	a0,0x7
    8000148c:	d1050513          	addi	a0,a0,-752 # 80008198 <etext+0x198>
    80001490:	00004097          	auipc	ra,0x4
    80001494:	688080e7          	jalr	1672(ra) # 80005b18 <panic>
    panic("sched locks");
    80001498:	00007517          	auipc	a0,0x7
    8000149c:	d1050513          	addi	a0,a0,-752 # 800081a8 <etext+0x1a8>
    800014a0:	00004097          	auipc	ra,0x4
    800014a4:	678080e7          	jalr	1656(ra) # 80005b18 <panic>
    panic("sched running");
    800014a8:	00007517          	auipc	a0,0x7
    800014ac:	d1050513          	addi	a0,a0,-752 # 800081b8 <etext+0x1b8>
    800014b0:	00004097          	auipc	ra,0x4
    800014b4:	668080e7          	jalr	1640(ra) # 80005b18 <panic>
    panic("sched interruptible");
    800014b8:	00007517          	auipc	a0,0x7
    800014bc:	d1050513          	addi	a0,a0,-752 # 800081c8 <etext+0x1c8>
    800014c0:	00004097          	auipc	ra,0x4
    800014c4:	658080e7          	jalr	1624(ra) # 80005b18 <panic>

00000000800014c8 <yield>:
{
    800014c8:	1101                	addi	sp,sp,-32
    800014ca:	ec06                	sd	ra,24(sp)
    800014cc:	e822                	sd	s0,16(sp)
    800014ce:	e426                	sd	s1,8(sp)
    800014d0:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014d2:	00000097          	auipc	ra,0x0
    800014d6:	976080e7          	jalr	-1674(ra) # 80000e48 <myproc>
    800014da:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014dc:	00005097          	auipc	ra,0x5
    800014e0:	b86080e7          	jalr	-1146(ra) # 80006062 <acquire>
  p->state = RUNNABLE;
    800014e4:	478d                	li	a5,3
    800014e6:	cc9c                	sw	a5,24(s1)
  sched();
    800014e8:	00000097          	auipc	ra,0x0
    800014ec:	f0a080e7          	jalr	-246(ra) # 800013f2 <sched>
  release(&p->lock);
    800014f0:	8526                	mv	a0,s1
    800014f2:	00005097          	auipc	ra,0x5
    800014f6:	c24080e7          	jalr	-988(ra) # 80006116 <release>
}
    800014fa:	60e2                	ld	ra,24(sp)
    800014fc:	6442                	ld	s0,16(sp)
    800014fe:	64a2                	ld	s1,8(sp)
    80001500:	6105                	addi	sp,sp,32
    80001502:	8082                	ret

0000000080001504 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001504:	7179                	addi	sp,sp,-48
    80001506:	f406                	sd	ra,40(sp)
    80001508:	f022                	sd	s0,32(sp)
    8000150a:	ec26                	sd	s1,24(sp)
    8000150c:	e84a                	sd	s2,16(sp)
    8000150e:	e44e                	sd	s3,8(sp)
    80001510:	1800                	addi	s0,sp,48
    80001512:	89aa                	mv	s3,a0
    80001514:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001516:	00000097          	auipc	ra,0x0
    8000151a:	932080e7          	jalr	-1742(ra) # 80000e48 <myproc>
    8000151e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001520:	00005097          	auipc	ra,0x5
    80001524:	b42080e7          	jalr	-1214(ra) # 80006062 <acquire>
  release(lk);
    80001528:	854a                	mv	a0,s2
    8000152a:	00005097          	auipc	ra,0x5
    8000152e:	bec080e7          	jalr	-1044(ra) # 80006116 <release>

  // Go to sleep.
  p->chan = chan;
    80001532:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001536:	4789                	li	a5,2
    80001538:	cc9c                	sw	a5,24(s1)

  sched();
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	eb8080e7          	jalr	-328(ra) # 800013f2 <sched>

  // Tidy up.
  p->chan = 0;
    80001542:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001546:	8526                	mv	a0,s1
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	bce080e7          	jalr	-1074(ra) # 80006116 <release>
  acquire(lk);
    80001550:	854a                	mv	a0,s2
    80001552:	00005097          	auipc	ra,0x5
    80001556:	b10080e7          	jalr	-1264(ra) # 80006062 <acquire>
}
    8000155a:	70a2                	ld	ra,40(sp)
    8000155c:	7402                	ld	s0,32(sp)
    8000155e:	64e2                	ld	s1,24(sp)
    80001560:	6942                	ld	s2,16(sp)
    80001562:	69a2                	ld	s3,8(sp)
    80001564:	6145                	addi	sp,sp,48
    80001566:	8082                	ret

0000000080001568 <wait>:
{
    80001568:	715d                	addi	sp,sp,-80
    8000156a:	e486                	sd	ra,72(sp)
    8000156c:	e0a2                	sd	s0,64(sp)
    8000156e:	fc26                	sd	s1,56(sp)
    80001570:	f84a                	sd	s2,48(sp)
    80001572:	f44e                	sd	s3,40(sp)
    80001574:	f052                	sd	s4,32(sp)
    80001576:	ec56                	sd	s5,24(sp)
    80001578:	e85a                	sd	s6,16(sp)
    8000157a:	e45e                	sd	s7,8(sp)
    8000157c:	e062                	sd	s8,0(sp)
    8000157e:	0880                	addi	s0,sp,80
    80001580:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001582:	00000097          	auipc	ra,0x0
    80001586:	8c6080e7          	jalr	-1850(ra) # 80000e48 <myproc>
    8000158a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000158c:	00008517          	auipc	a0,0x8
    80001590:	adc50513          	addi	a0,a0,-1316 # 80009068 <wait_lock>
    80001594:	00005097          	auipc	ra,0x5
    80001598:	ace080e7          	jalr	-1330(ra) # 80006062 <acquire>
    havekids = 0;
    8000159c:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000159e:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015a0:	0000e997          	auipc	s3,0xe
    800015a4:	8e098993          	addi	s3,s3,-1824 # 8000ee80 <tickslock>
        havekids = 1;
    800015a8:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015aa:	00008c17          	auipc	s8,0x8
    800015ae:	abec0c13          	addi	s8,s8,-1346 # 80009068 <wait_lock>
    havekids = 0;
    800015b2:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015b4:	00008497          	auipc	s1,0x8
    800015b8:	ecc48493          	addi	s1,s1,-308 # 80009480 <proc>
    800015bc:	a0bd                	j	8000162a <wait+0xc2>
          pid = np->pid;
    800015be:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015c2:	000b0e63          	beqz	s6,800015de <wait+0x76>
    800015c6:	4691                	li	a3,4
    800015c8:	02c48613          	addi	a2,s1,44
    800015cc:	85da                	mv	a1,s6
    800015ce:	05093503          	ld	a0,80(s2)
    800015d2:	fffff097          	auipc	ra,0xfffff
    800015d6:	538080e7          	jalr	1336(ra) # 80000b0a <copyout>
    800015da:	02054563          	bltz	a0,80001604 <wait+0x9c>
          freeproc(np);
    800015de:	8526                	mv	a0,s1
    800015e0:	00000097          	auipc	ra,0x0
    800015e4:	a1a080e7          	jalr	-1510(ra) # 80000ffa <freeproc>
          release(&np->lock);
    800015e8:	8526                	mv	a0,s1
    800015ea:	00005097          	auipc	ra,0x5
    800015ee:	b2c080e7          	jalr	-1236(ra) # 80006116 <release>
          release(&wait_lock);
    800015f2:	00008517          	auipc	a0,0x8
    800015f6:	a7650513          	addi	a0,a0,-1418 # 80009068 <wait_lock>
    800015fa:	00005097          	auipc	ra,0x5
    800015fe:	b1c080e7          	jalr	-1252(ra) # 80006116 <release>
          return pid;
    80001602:	a09d                	j	80001668 <wait+0x100>
            release(&np->lock);
    80001604:	8526                	mv	a0,s1
    80001606:	00005097          	auipc	ra,0x5
    8000160a:	b10080e7          	jalr	-1264(ra) # 80006116 <release>
            release(&wait_lock);
    8000160e:	00008517          	auipc	a0,0x8
    80001612:	a5a50513          	addi	a0,a0,-1446 # 80009068 <wait_lock>
    80001616:	00005097          	auipc	ra,0x5
    8000161a:	b00080e7          	jalr	-1280(ra) # 80006116 <release>
            return -1;
    8000161e:	59fd                	li	s3,-1
    80001620:	a0a1                	j	80001668 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001622:	16848493          	addi	s1,s1,360
    80001626:	03348463          	beq	s1,s3,8000164e <wait+0xe6>
      if(np->parent == p){
    8000162a:	7c9c                	ld	a5,56(s1)
    8000162c:	ff279be3          	bne	a5,s2,80001622 <wait+0xba>
        acquire(&np->lock);
    80001630:	8526                	mv	a0,s1
    80001632:	00005097          	auipc	ra,0x5
    80001636:	a30080e7          	jalr	-1488(ra) # 80006062 <acquire>
        if(np->state == ZOMBIE){
    8000163a:	4c9c                	lw	a5,24(s1)
    8000163c:	f94781e3          	beq	a5,s4,800015be <wait+0x56>
        release(&np->lock);
    80001640:	8526                	mv	a0,s1
    80001642:	00005097          	auipc	ra,0x5
    80001646:	ad4080e7          	jalr	-1324(ra) # 80006116 <release>
        havekids = 1;
    8000164a:	8756                	mv	a4,s5
    8000164c:	bfd9                	j	80001622 <wait+0xba>
    if(!havekids || p->killed){
    8000164e:	c701                	beqz	a4,80001656 <wait+0xee>
    80001650:	02892783          	lw	a5,40(s2)
    80001654:	c79d                	beqz	a5,80001682 <wait+0x11a>
      release(&wait_lock);
    80001656:	00008517          	auipc	a0,0x8
    8000165a:	a1250513          	addi	a0,a0,-1518 # 80009068 <wait_lock>
    8000165e:	00005097          	auipc	ra,0x5
    80001662:	ab8080e7          	jalr	-1352(ra) # 80006116 <release>
      return -1;
    80001666:	59fd                	li	s3,-1
}
    80001668:	854e                	mv	a0,s3
    8000166a:	60a6                	ld	ra,72(sp)
    8000166c:	6406                	ld	s0,64(sp)
    8000166e:	74e2                	ld	s1,56(sp)
    80001670:	7942                	ld	s2,48(sp)
    80001672:	79a2                	ld	s3,40(sp)
    80001674:	7a02                	ld	s4,32(sp)
    80001676:	6ae2                	ld	s5,24(sp)
    80001678:	6b42                	ld	s6,16(sp)
    8000167a:	6ba2                	ld	s7,8(sp)
    8000167c:	6c02                	ld	s8,0(sp)
    8000167e:	6161                	addi	sp,sp,80
    80001680:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001682:	85e2                	mv	a1,s8
    80001684:	854a                	mv	a0,s2
    80001686:	00000097          	auipc	ra,0x0
    8000168a:	e7e080e7          	jalr	-386(ra) # 80001504 <sleep>
    havekids = 0;
    8000168e:	b715                	j	800015b2 <wait+0x4a>

0000000080001690 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001690:	7139                	addi	sp,sp,-64
    80001692:	fc06                	sd	ra,56(sp)
    80001694:	f822                	sd	s0,48(sp)
    80001696:	f426                	sd	s1,40(sp)
    80001698:	f04a                	sd	s2,32(sp)
    8000169a:	ec4e                	sd	s3,24(sp)
    8000169c:	e852                	sd	s4,16(sp)
    8000169e:	e456                	sd	s5,8(sp)
    800016a0:	0080                	addi	s0,sp,64
    800016a2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016a4:	00008497          	auipc	s1,0x8
    800016a8:	ddc48493          	addi	s1,s1,-548 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016ac:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016ae:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016b0:	0000d917          	auipc	s2,0xd
    800016b4:	7d090913          	addi	s2,s2,2000 # 8000ee80 <tickslock>
    800016b8:	a821                	j	800016d0 <wakeup+0x40>
        p->state = RUNNABLE;
    800016ba:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800016be:	8526                	mv	a0,s1
    800016c0:	00005097          	auipc	ra,0x5
    800016c4:	a56080e7          	jalr	-1450(ra) # 80006116 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016c8:	16848493          	addi	s1,s1,360
    800016cc:	03248463          	beq	s1,s2,800016f4 <wakeup+0x64>
    if(p != myproc()){
    800016d0:	fffff097          	auipc	ra,0xfffff
    800016d4:	778080e7          	jalr	1912(ra) # 80000e48 <myproc>
    800016d8:	fea488e3          	beq	s1,a0,800016c8 <wakeup+0x38>
      acquire(&p->lock);
    800016dc:	8526                	mv	a0,s1
    800016de:	00005097          	auipc	ra,0x5
    800016e2:	984080e7          	jalr	-1660(ra) # 80006062 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016e6:	4c9c                	lw	a5,24(s1)
    800016e8:	fd379be3          	bne	a5,s3,800016be <wakeup+0x2e>
    800016ec:	709c                	ld	a5,32(s1)
    800016ee:	fd4798e3          	bne	a5,s4,800016be <wakeup+0x2e>
    800016f2:	b7e1                	j	800016ba <wakeup+0x2a>
    }
  }
}
    800016f4:	70e2                	ld	ra,56(sp)
    800016f6:	7442                	ld	s0,48(sp)
    800016f8:	74a2                	ld	s1,40(sp)
    800016fa:	7902                	ld	s2,32(sp)
    800016fc:	69e2                	ld	s3,24(sp)
    800016fe:	6a42                	ld	s4,16(sp)
    80001700:	6aa2                	ld	s5,8(sp)
    80001702:	6121                	addi	sp,sp,64
    80001704:	8082                	ret

0000000080001706 <reparent>:
{
    80001706:	7179                	addi	sp,sp,-48
    80001708:	f406                	sd	ra,40(sp)
    8000170a:	f022                	sd	s0,32(sp)
    8000170c:	ec26                	sd	s1,24(sp)
    8000170e:	e84a                	sd	s2,16(sp)
    80001710:	e44e                	sd	s3,8(sp)
    80001712:	e052                	sd	s4,0(sp)
    80001714:	1800                	addi	s0,sp,48
    80001716:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001718:	00008497          	auipc	s1,0x8
    8000171c:	d6848493          	addi	s1,s1,-664 # 80009480 <proc>
      pp->parent = initproc;
    80001720:	00008a17          	auipc	s4,0x8
    80001724:	8f0a0a13          	addi	s4,s4,-1808 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001728:	0000d997          	auipc	s3,0xd
    8000172c:	75898993          	addi	s3,s3,1880 # 8000ee80 <tickslock>
    80001730:	a029                	j	8000173a <reparent+0x34>
    80001732:	16848493          	addi	s1,s1,360
    80001736:	01348d63          	beq	s1,s3,80001750 <reparent+0x4a>
    if(pp->parent == p){
    8000173a:	7c9c                	ld	a5,56(s1)
    8000173c:	ff279be3          	bne	a5,s2,80001732 <reparent+0x2c>
      pp->parent = initproc;
    80001740:	000a3503          	ld	a0,0(s4)
    80001744:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001746:	00000097          	auipc	ra,0x0
    8000174a:	f4a080e7          	jalr	-182(ra) # 80001690 <wakeup>
    8000174e:	b7d5                	j	80001732 <reparent+0x2c>
}
    80001750:	70a2                	ld	ra,40(sp)
    80001752:	7402                	ld	s0,32(sp)
    80001754:	64e2                	ld	s1,24(sp)
    80001756:	6942                	ld	s2,16(sp)
    80001758:	69a2                	ld	s3,8(sp)
    8000175a:	6a02                	ld	s4,0(sp)
    8000175c:	6145                	addi	sp,sp,48
    8000175e:	8082                	ret

0000000080001760 <exit>:
{
    80001760:	7179                	addi	sp,sp,-48
    80001762:	f406                	sd	ra,40(sp)
    80001764:	f022                	sd	s0,32(sp)
    80001766:	ec26                	sd	s1,24(sp)
    80001768:	e84a                	sd	s2,16(sp)
    8000176a:	e44e                	sd	s3,8(sp)
    8000176c:	e052                	sd	s4,0(sp)
    8000176e:	1800                	addi	s0,sp,48
    80001770:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001772:	fffff097          	auipc	ra,0xfffff
    80001776:	6d6080e7          	jalr	1750(ra) # 80000e48 <myproc>
    8000177a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000177c:	00008797          	auipc	a5,0x8
    80001780:	8947b783          	ld	a5,-1900(a5) # 80009010 <initproc>
    80001784:	0d050493          	addi	s1,a0,208
    80001788:	15050913          	addi	s2,a0,336
    8000178c:	02a79363          	bne	a5,a0,800017b2 <exit+0x52>
    panic("init exiting");
    80001790:	00007517          	auipc	a0,0x7
    80001794:	a5050513          	addi	a0,a0,-1456 # 800081e0 <etext+0x1e0>
    80001798:	00004097          	auipc	ra,0x4
    8000179c:	380080e7          	jalr	896(ra) # 80005b18 <panic>
      fileclose(f);
    800017a0:	00002097          	auipc	ra,0x2
    800017a4:	164080e7          	jalr	356(ra) # 80003904 <fileclose>
      p->ofile[fd] = 0;
    800017a8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017ac:	04a1                	addi	s1,s1,8
    800017ae:	01248563          	beq	s1,s2,800017b8 <exit+0x58>
    if(p->ofile[fd]){
    800017b2:	6088                	ld	a0,0(s1)
    800017b4:	f575                	bnez	a0,800017a0 <exit+0x40>
    800017b6:	bfdd                	j	800017ac <exit+0x4c>
  begin_op();
    800017b8:	00002097          	auipc	ra,0x2
    800017bc:	c80080e7          	jalr	-896(ra) # 80003438 <begin_op>
  iput(p->cwd);
    800017c0:	1509b503          	ld	a0,336(s3)
    800017c4:	00001097          	auipc	ra,0x1
    800017c8:	45c080e7          	jalr	1116(ra) # 80002c20 <iput>
  end_op();
    800017cc:	00002097          	auipc	ra,0x2
    800017d0:	cec080e7          	jalr	-788(ra) # 800034b8 <end_op>
  p->cwd = 0;
    800017d4:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017d8:	00008497          	auipc	s1,0x8
    800017dc:	89048493          	addi	s1,s1,-1904 # 80009068 <wait_lock>
    800017e0:	8526                	mv	a0,s1
    800017e2:	00005097          	auipc	ra,0x5
    800017e6:	880080e7          	jalr	-1920(ra) # 80006062 <acquire>
  reparent(p);
    800017ea:	854e                	mv	a0,s3
    800017ec:	00000097          	auipc	ra,0x0
    800017f0:	f1a080e7          	jalr	-230(ra) # 80001706 <reparent>
  wakeup(p->parent);
    800017f4:	0389b503          	ld	a0,56(s3)
    800017f8:	00000097          	auipc	ra,0x0
    800017fc:	e98080e7          	jalr	-360(ra) # 80001690 <wakeup>
  acquire(&p->lock);
    80001800:	854e                	mv	a0,s3
    80001802:	00005097          	auipc	ra,0x5
    80001806:	860080e7          	jalr	-1952(ra) # 80006062 <acquire>
  p->xstate = status;
    8000180a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000180e:	4795                	li	a5,5
    80001810:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001814:	8526                	mv	a0,s1
    80001816:	00005097          	auipc	ra,0x5
    8000181a:	900080e7          	jalr	-1792(ra) # 80006116 <release>
  sched();
    8000181e:	00000097          	auipc	ra,0x0
    80001822:	bd4080e7          	jalr	-1068(ra) # 800013f2 <sched>
  panic("zombie exit");
    80001826:	00007517          	auipc	a0,0x7
    8000182a:	9ca50513          	addi	a0,a0,-1590 # 800081f0 <etext+0x1f0>
    8000182e:	00004097          	auipc	ra,0x4
    80001832:	2ea080e7          	jalr	746(ra) # 80005b18 <panic>

0000000080001836 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001836:	7179                	addi	sp,sp,-48
    80001838:	f406                	sd	ra,40(sp)
    8000183a:	f022                	sd	s0,32(sp)
    8000183c:	ec26                	sd	s1,24(sp)
    8000183e:	e84a                	sd	s2,16(sp)
    80001840:	e44e                	sd	s3,8(sp)
    80001842:	1800                	addi	s0,sp,48
    80001844:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001846:	00008497          	auipc	s1,0x8
    8000184a:	c3a48493          	addi	s1,s1,-966 # 80009480 <proc>
    8000184e:	0000d997          	auipc	s3,0xd
    80001852:	63298993          	addi	s3,s3,1586 # 8000ee80 <tickslock>
    acquire(&p->lock);
    80001856:	8526                	mv	a0,s1
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	80a080e7          	jalr	-2038(ra) # 80006062 <acquire>
    if(p->pid == pid){
    80001860:	589c                	lw	a5,48(s1)
    80001862:	01278d63          	beq	a5,s2,8000187c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001866:	8526                	mv	a0,s1
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	8ae080e7          	jalr	-1874(ra) # 80006116 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001870:	16848493          	addi	s1,s1,360
    80001874:	ff3491e3          	bne	s1,s3,80001856 <kill+0x20>
  }
  return -1;
    80001878:	557d                	li	a0,-1
    8000187a:	a829                	j	80001894 <kill+0x5e>
      p->killed = 1;
    8000187c:	4785                	li	a5,1
    8000187e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001880:	4c98                	lw	a4,24(s1)
    80001882:	4789                	li	a5,2
    80001884:	00f70f63          	beq	a4,a5,800018a2 <kill+0x6c>
      release(&p->lock);
    80001888:	8526                	mv	a0,s1
    8000188a:	00005097          	auipc	ra,0x5
    8000188e:	88c080e7          	jalr	-1908(ra) # 80006116 <release>
      return 0;
    80001892:	4501                	li	a0,0
}
    80001894:	70a2                	ld	ra,40(sp)
    80001896:	7402                	ld	s0,32(sp)
    80001898:	64e2                	ld	s1,24(sp)
    8000189a:	6942                	ld	s2,16(sp)
    8000189c:	69a2                	ld	s3,8(sp)
    8000189e:	6145                	addi	sp,sp,48
    800018a0:	8082                	ret
        p->state = RUNNABLE;
    800018a2:	478d                	li	a5,3
    800018a4:	cc9c                	sw	a5,24(s1)
    800018a6:	b7cd                	j	80001888 <kill+0x52>

00000000800018a8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018a8:	7179                	addi	sp,sp,-48
    800018aa:	f406                	sd	ra,40(sp)
    800018ac:	f022                	sd	s0,32(sp)
    800018ae:	ec26                	sd	s1,24(sp)
    800018b0:	e84a                	sd	s2,16(sp)
    800018b2:	e44e                	sd	s3,8(sp)
    800018b4:	e052                	sd	s4,0(sp)
    800018b6:	1800                	addi	s0,sp,48
    800018b8:	84aa                	mv	s1,a0
    800018ba:	892e                	mv	s2,a1
    800018bc:	89b2                	mv	s3,a2
    800018be:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018c0:	fffff097          	auipc	ra,0xfffff
    800018c4:	588080e7          	jalr	1416(ra) # 80000e48 <myproc>
  if(user_dst){
    800018c8:	c08d                	beqz	s1,800018ea <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018ca:	86d2                	mv	a3,s4
    800018cc:	864e                	mv	a2,s3
    800018ce:	85ca                	mv	a1,s2
    800018d0:	6928                	ld	a0,80(a0)
    800018d2:	fffff097          	auipc	ra,0xfffff
    800018d6:	238080e7          	jalr	568(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018da:	70a2                	ld	ra,40(sp)
    800018dc:	7402                	ld	s0,32(sp)
    800018de:	64e2                	ld	s1,24(sp)
    800018e0:	6942                	ld	s2,16(sp)
    800018e2:	69a2                	ld	s3,8(sp)
    800018e4:	6a02                	ld	s4,0(sp)
    800018e6:	6145                	addi	sp,sp,48
    800018e8:	8082                	ret
    memmove((char *)dst, src, len);
    800018ea:	000a061b          	sext.w	a2,s4
    800018ee:	85ce                	mv	a1,s3
    800018f0:	854a                	mv	a0,s2
    800018f2:	fffff097          	auipc	ra,0xfffff
    800018f6:	8e6080e7          	jalr	-1818(ra) # 800001d8 <memmove>
    return 0;
    800018fa:	8526                	mv	a0,s1
    800018fc:	bff9                	j	800018da <either_copyout+0x32>

00000000800018fe <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800018fe:	7179                	addi	sp,sp,-48
    80001900:	f406                	sd	ra,40(sp)
    80001902:	f022                	sd	s0,32(sp)
    80001904:	ec26                	sd	s1,24(sp)
    80001906:	e84a                	sd	s2,16(sp)
    80001908:	e44e                	sd	s3,8(sp)
    8000190a:	e052                	sd	s4,0(sp)
    8000190c:	1800                	addi	s0,sp,48
    8000190e:	892a                	mv	s2,a0
    80001910:	84ae                	mv	s1,a1
    80001912:	89b2                	mv	s3,a2
    80001914:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001916:	fffff097          	auipc	ra,0xfffff
    8000191a:	532080e7          	jalr	1330(ra) # 80000e48 <myproc>
  if(user_src){
    8000191e:	c08d                	beqz	s1,80001940 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001920:	86d2                	mv	a3,s4
    80001922:	864e                	mv	a2,s3
    80001924:	85ca                	mv	a1,s2
    80001926:	6928                	ld	a0,80(a0)
    80001928:	fffff097          	auipc	ra,0xfffff
    8000192c:	26e080e7          	jalr	622(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001930:	70a2                	ld	ra,40(sp)
    80001932:	7402                	ld	s0,32(sp)
    80001934:	64e2                	ld	s1,24(sp)
    80001936:	6942                	ld	s2,16(sp)
    80001938:	69a2                	ld	s3,8(sp)
    8000193a:	6a02                	ld	s4,0(sp)
    8000193c:	6145                	addi	sp,sp,48
    8000193e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001940:	000a061b          	sext.w	a2,s4
    80001944:	85ce                	mv	a1,s3
    80001946:	854a                	mv	a0,s2
    80001948:	fffff097          	auipc	ra,0xfffff
    8000194c:	890080e7          	jalr	-1904(ra) # 800001d8 <memmove>
    return 0;
    80001950:	8526                	mv	a0,s1
    80001952:	bff9                	j	80001930 <either_copyin+0x32>

0000000080001954 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001954:	715d                	addi	sp,sp,-80
    80001956:	e486                	sd	ra,72(sp)
    80001958:	e0a2                	sd	s0,64(sp)
    8000195a:	fc26                	sd	s1,56(sp)
    8000195c:	f84a                	sd	s2,48(sp)
    8000195e:	f44e                	sd	s3,40(sp)
    80001960:	f052                	sd	s4,32(sp)
    80001962:	ec56                	sd	s5,24(sp)
    80001964:	e85a                	sd	s6,16(sp)
    80001966:	e45e                	sd	s7,8(sp)
    80001968:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000196a:	00006517          	auipc	a0,0x6
    8000196e:	6de50513          	addi	a0,a0,1758 # 80008048 <etext+0x48>
    80001972:	00004097          	auipc	ra,0x4
    80001976:	1f0080e7          	jalr	496(ra) # 80005b62 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000197a:	00008497          	auipc	s1,0x8
    8000197e:	c5e48493          	addi	s1,s1,-930 # 800095d8 <proc+0x158>
    80001982:	0000d917          	auipc	s2,0xd
    80001986:	65690913          	addi	s2,s2,1622 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000198a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000198c:	00007997          	auipc	s3,0x7
    80001990:	87498993          	addi	s3,s3,-1932 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001994:	00007a97          	auipc	s5,0x7
    80001998:	874a8a93          	addi	s5,s5,-1932 # 80008208 <etext+0x208>
    printf("\n");
    8000199c:	00006a17          	auipc	s4,0x6
    800019a0:	6aca0a13          	addi	s4,s4,1708 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019a4:	00007b97          	auipc	s7,0x7
    800019a8:	89cb8b93          	addi	s7,s7,-1892 # 80008240 <states.1709>
    800019ac:	a00d                	j	800019ce <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019ae:	ed86a583          	lw	a1,-296(a3)
    800019b2:	8556                	mv	a0,s5
    800019b4:	00004097          	auipc	ra,0x4
    800019b8:	1ae080e7          	jalr	430(ra) # 80005b62 <printf>
    printf("\n");
    800019bc:	8552                	mv	a0,s4
    800019be:	00004097          	auipc	ra,0x4
    800019c2:	1a4080e7          	jalr	420(ra) # 80005b62 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019c6:	16848493          	addi	s1,s1,360
    800019ca:	03248163          	beq	s1,s2,800019ec <procdump+0x98>
    if(p->state == UNUSED)
    800019ce:	86a6                	mv	a3,s1
    800019d0:	ec04a783          	lw	a5,-320(s1)
    800019d4:	dbed                	beqz	a5,800019c6 <procdump+0x72>
      state = "???";
    800019d6:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019d8:	fcfb6be3          	bltu	s6,a5,800019ae <procdump+0x5a>
    800019dc:	1782                	slli	a5,a5,0x20
    800019de:	9381                	srli	a5,a5,0x20
    800019e0:	078e                	slli	a5,a5,0x3
    800019e2:	97de                	add	a5,a5,s7
    800019e4:	6390                	ld	a2,0(a5)
    800019e6:	f661                	bnez	a2,800019ae <procdump+0x5a>
      state = "???";
    800019e8:	864e                	mv	a2,s3
    800019ea:	b7d1                	j	800019ae <procdump+0x5a>
  }
}
    800019ec:	60a6                	ld	ra,72(sp)
    800019ee:	6406                	ld	s0,64(sp)
    800019f0:	74e2                	ld	s1,56(sp)
    800019f2:	7942                	ld	s2,48(sp)
    800019f4:	79a2                	ld	s3,40(sp)
    800019f6:	7a02                	ld	s4,32(sp)
    800019f8:	6ae2                	ld	s5,24(sp)
    800019fa:	6b42                	ld	s6,16(sp)
    800019fc:	6ba2                	ld	s7,8(sp)
    800019fe:	6161                	addi	sp,sp,80
    80001a00:	8082                	ret

0000000080001a02 <swtch>:
    80001a02:	00153023          	sd	ra,0(a0)
    80001a06:	00253423          	sd	sp,8(a0)
    80001a0a:	e900                	sd	s0,16(a0)
    80001a0c:	ed04                	sd	s1,24(a0)
    80001a0e:	03253023          	sd	s2,32(a0)
    80001a12:	03353423          	sd	s3,40(a0)
    80001a16:	03453823          	sd	s4,48(a0)
    80001a1a:	03553c23          	sd	s5,56(a0)
    80001a1e:	05653023          	sd	s6,64(a0)
    80001a22:	05753423          	sd	s7,72(a0)
    80001a26:	05853823          	sd	s8,80(a0)
    80001a2a:	05953c23          	sd	s9,88(a0)
    80001a2e:	07a53023          	sd	s10,96(a0)
    80001a32:	07b53423          	sd	s11,104(a0)
    80001a36:	0005b083          	ld	ra,0(a1)
    80001a3a:	0085b103          	ld	sp,8(a1)
    80001a3e:	6980                	ld	s0,16(a1)
    80001a40:	6d84                	ld	s1,24(a1)
    80001a42:	0205b903          	ld	s2,32(a1)
    80001a46:	0285b983          	ld	s3,40(a1)
    80001a4a:	0305ba03          	ld	s4,48(a1)
    80001a4e:	0385ba83          	ld	s5,56(a1)
    80001a52:	0405bb03          	ld	s6,64(a1)
    80001a56:	0485bb83          	ld	s7,72(a1)
    80001a5a:	0505bc03          	ld	s8,80(a1)
    80001a5e:	0585bc83          	ld	s9,88(a1)
    80001a62:	0605bd03          	ld	s10,96(a1)
    80001a66:	0685bd83          	ld	s11,104(a1)
    80001a6a:	8082                	ret

0000000080001a6c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a6c:	1141                	addi	sp,sp,-16
    80001a6e:	e406                	sd	ra,8(sp)
    80001a70:	e022                	sd	s0,0(sp)
    80001a72:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a74:	00006597          	auipc	a1,0x6
    80001a78:	7fc58593          	addi	a1,a1,2044 # 80008270 <states.1709+0x30>
    80001a7c:	0000d517          	auipc	a0,0xd
    80001a80:	40450513          	addi	a0,a0,1028 # 8000ee80 <tickslock>
    80001a84:	00004097          	auipc	ra,0x4
    80001a88:	54e080e7          	jalr	1358(ra) # 80005fd2 <initlock>
}
    80001a8c:	60a2                	ld	ra,8(sp)
    80001a8e:	6402                	ld	s0,0(sp)
    80001a90:	0141                	addi	sp,sp,16
    80001a92:	8082                	ret

0000000080001a94 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001a94:	1141                	addi	sp,sp,-16
    80001a96:	e422                	sd	s0,8(sp)
    80001a98:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a9a:	00003797          	auipc	a5,0x3
    80001a9e:	48678793          	addi	a5,a5,1158 # 80004f20 <kernelvec>
    80001aa2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001aa6:	6422                	ld	s0,8(sp)
    80001aa8:	0141                	addi	sp,sp,16
    80001aaa:	8082                	ret

0000000080001aac <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001aac:	1141                	addi	sp,sp,-16
    80001aae:	e406                	sd	ra,8(sp)
    80001ab0:	e022                	sd	s0,0(sp)
    80001ab2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ab4:	fffff097          	auipc	ra,0xfffff
    80001ab8:	394080e7          	jalr	916(ra) # 80000e48 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001abc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ac0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ac2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ac6:	00005617          	auipc	a2,0x5
    80001aca:	53a60613          	addi	a2,a2,1338 # 80007000 <_trampoline>
    80001ace:	00005697          	auipc	a3,0x5
    80001ad2:	53268693          	addi	a3,a3,1330 # 80007000 <_trampoline>
    80001ad6:	8e91                	sub	a3,a3,a2
    80001ad8:	040007b7          	lui	a5,0x4000
    80001adc:	17fd                	addi	a5,a5,-1
    80001ade:	07b2                	slli	a5,a5,0xc
    80001ae0:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ae2:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ae6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ae8:	180026f3          	csrr	a3,satp
    80001aec:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001aee:	6d38                	ld	a4,88(a0)
    80001af0:	6134                	ld	a3,64(a0)
    80001af2:	6585                	lui	a1,0x1
    80001af4:	96ae                	add	a3,a3,a1
    80001af6:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001af8:	6d38                	ld	a4,88(a0)
    80001afa:	00000697          	auipc	a3,0x0
    80001afe:	13868693          	addi	a3,a3,312 # 80001c32 <usertrap>
    80001b02:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b04:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b06:	8692                	mv	a3,tp
    80001b08:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b0a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b0e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b12:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b16:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b1a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b1c:	6f18                	ld	a4,24(a4)
    80001b1e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b22:	692c                	ld	a1,80(a0)
    80001b24:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b26:	00005717          	auipc	a4,0x5
    80001b2a:	56a70713          	addi	a4,a4,1386 # 80007090 <userret>
    80001b2e:	8f11                	sub	a4,a4,a2
    80001b30:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b32:	577d                	li	a4,-1
    80001b34:	177e                	slli	a4,a4,0x3f
    80001b36:	8dd9                	or	a1,a1,a4
    80001b38:	02000537          	lui	a0,0x2000
    80001b3c:	157d                	addi	a0,a0,-1
    80001b3e:	0536                	slli	a0,a0,0xd
    80001b40:	9782                	jalr	a5
}
    80001b42:	60a2                	ld	ra,8(sp)
    80001b44:	6402                	ld	s0,0(sp)
    80001b46:	0141                	addi	sp,sp,16
    80001b48:	8082                	ret

0000000080001b4a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b4a:	1101                	addi	sp,sp,-32
    80001b4c:	ec06                	sd	ra,24(sp)
    80001b4e:	e822                	sd	s0,16(sp)
    80001b50:	e426                	sd	s1,8(sp)
    80001b52:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b54:	0000d497          	auipc	s1,0xd
    80001b58:	32c48493          	addi	s1,s1,812 # 8000ee80 <tickslock>
    80001b5c:	8526                	mv	a0,s1
    80001b5e:	00004097          	auipc	ra,0x4
    80001b62:	504080e7          	jalr	1284(ra) # 80006062 <acquire>
  ticks++;
    80001b66:	00007517          	auipc	a0,0x7
    80001b6a:	4b250513          	addi	a0,a0,1202 # 80009018 <ticks>
    80001b6e:	411c                	lw	a5,0(a0)
    80001b70:	2785                	addiw	a5,a5,1
    80001b72:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b74:	00000097          	auipc	ra,0x0
    80001b78:	b1c080e7          	jalr	-1252(ra) # 80001690 <wakeup>
  release(&tickslock);
    80001b7c:	8526                	mv	a0,s1
    80001b7e:	00004097          	auipc	ra,0x4
    80001b82:	598080e7          	jalr	1432(ra) # 80006116 <release>
}
    80001b86:	60e2                	ld	ra,24(sp)
    80001b88:	6442                	ld	s0,16(sp)
    80001b8a:	64a2                	ld	s1,8(sp)
    80001b8c:	6105                	addi	sp,sp,32
    80001b8e:	8082                	ret

0000000080001b90 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b90:	1101                	addi	sp,sp,-32
    80001b92:	ec06                	sd	ra,24(sp)
    80001b94:	e822                	sd	s0,16(sp)
    80001b96:	e426                	sd	s1,8(sp)
    80001b98:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b9a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001b9e:	00074d63          	bltz	a4,80001bb8 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001ba2:	57fd                	li	a5,-1
    80001ba4:	17fe                	slli	a5,a5,0x3f
    80001ba6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ba8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001baa:	06f70363          	beq	a4,a5,80001c10 <devintr+0x80>
  }
}
    80001bae:	60e2                	ld	ra,24(sp)
    80001bb0:	6442                	ld	s0,16(sp)
    80001bb2:	64a2                	ld	s1,8(sp)
    80001bb4:	6105                	addi	sp,sp,32
    80001bb6:	8082                	ret
     (scause & 0xff) == 9){
    80001bb8:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001bbc:	46a5                	li	a3,9
    80001bbe:	fed792e3          	bne	a5,a3,80001ba2 <devintr+0x12>
    int irq = plic_claim();
    80001bc2:	00003097          	auipc	ra,0x3
    80001bc6:	466080e7          	jalr	1126(ra) # 80005028 <plic_claim>
    80001bca:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bcc:	47a9                	li	a5,10
    80001bce:	02f50763          	beq	a0,a5,80001bfc <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001bd2:	4785                	li	a5,1
    80001bd4:	02f50963          	beq	a0,a5,80001c06 <devintr+0x76>
    return 1;
    80001bd8:	4505                	li	a0,1
    } else if(irq){
    80001bda:	d8f1                	beqz	s1,80001bae <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001bdc:	85a6                	mv	a1,s1
    80001bde:	00006517          	auipc	a0,0x6
    80001be2:	69a50513          	addi	a0,a0,1690 # 80008278 <states.1709+0x38>
    80001be6:	00004097          	auipc	ra,0x4
    80001bea:	f7c080e7          	jalr	-132(ra) # 80005b62 <printf>
      plic_complete(irq);
    80001bee:	8526                	mv	a0,s1
    80001bf0:	00003097          	auipc	ra,0x3
    80001bf4:	45c080e7          	jalr	1116(ra) # 8000504c <plic_complete>
    return 1;
    80001bf8:	4505                	li	a0,1
    80001bfa:	bf55                	j	80001bae <devintr+0x1e>
      uartintr();
    80001bfc:	00004097          	auipc	ra,0x4
    80001c00:	386080e7          	jalr	902(ra) # 80005f82 <uartintr>
    80001c04:	b7ed                	j	80001bee <devintr+0x5e>
      virtio_disk_intr();
    80001c06:	00004097          	auipc	ra,0x4
    80001c0a:	926080e7          	jalr	-1754(ra) # 8000552c <virtio_disk_intr>
    80001c0e:	b7c5                	j	80001bee <devintr+0x5e>
    if(cpuid() == 0){
    80001c10:	fffff097          	auipc	ra,0xfffff
    80001c14:	20c080e7          	jalr	524(ra) # 80000e1c <cpuid>
    80001c18:	c901                	beqz	a0,80001c28 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c1a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c1e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c20:	14479073          	csrw	sip,a5
    return 2;
    80001c24:	4509                	li	a0,2
    80001c26:	b761                	j	80001bae <devintr+0x1e>
      clockintr();
    80001c28:	00000097          	auipc	ra,0x0
    80001c2c:	f22080e7          	jalr	-222(ra) # 80001b4a <clockintr>
    80001c30:	b7ed                	j	80001c1a <devintr+0x8a>

0000000080001c32 <usertrap>:
{
    80001c32:	1101                	addi	sp,sp,-32
    80001c34:	ec06                	sd	ra,24(sp)
    80001c36:	e822                	sd	s0,16(sp)
    80001c38:	e426                	sd	s1,8(sp)
    80001c3a:	e04a                	sd	s2,0(sp)
    80001c3c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c3e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c42:	1007f793          	andi	a5,a5,256
    80001c46:	e3ad                	bnez	a5,80001ca8 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c48:	00003797          	auipc	a5,0x3
    80001c4c:	2d878793          	addi	a5,a5,728 # 80004f20 <kernelvec>
    80001c50:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c54:	fffff097          	auipc	ra,0xfffff
    80001c58:	1f4080e7          	jalr	500(ra) # 80000e48 <myproc>
    80001c5c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c5e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c60:	14102773          	csrr	a4,sepc
    80001c64:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c66:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c6a:	47a1                	li	a5,8
    80001c6c:	04f71c63          	bne	a4,a5,80001cc4 <usertrap+0x92>
    if(p->killed)
    80001c70:	551c                	lw	a5,40(a0)
    80001c72:	e3b9                	bnez	a5,80001cb8 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001c74:	6cb8                	ld	a4,88(s1)
    80001c76:	6f1c                	ld	a5,24(a4)
    80001c78:	0791                	addi	a5,a5,4
    80001c7a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c7c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c80:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c84:	10079073          	csrw	sstatus,a5
    syscall();
    80001c88:	00000097          	auipc	ra,0x0
    80001c8c:	2e0080e7          	jalr	736(ra) # 80001f68 <syscall>
  if(p->killed)
    80001c90:	549c                	lw	a5,40(s1)
    80001c92:	ebc1                	bnez	a5,80001d22 <usertrap+0xf0>
  usertrapret();
    80001c94:	00000097          	auipc	ra,0x0
    80001c98:	e18080e7          	jalr	-488(ra) # 80001aac <usertrapret>
}
    80001c9c:	60e2                	ld	ra,24(sp)
    80001c9e:	6442                	ld	s0,16(sp)
    80001ca0:	64a2                	ld	s1,8(sp)
    80001ca2:	6902                	ld	s2,0(sp)
    80001ca4:	6105                	addi	sp,sp,32
    80001ca6:	8082                	ret
    panic("usertrap: not from user mode");
    80001ca8:	00006517          	auipc	a0,0x6
    80001cac:	5f050513          	addi	a0,a0,1520 # 80008298 <states.1709+0x58>
    80001cb0:	00004097          	auipc	ra,0x4
    80001cb4:	e68080e7          	jalr	-408(ra) # 80005b18 <panic>
      exit(-1);
    80001cb8:	557d                	li	a0,-1
    80001cba:	00000097          	auipc	ra,0x0
    80001cbe:	aa6080e7          	jalr	-1370(ra) # 80001760 <exit>
    80001cc2:	bf4d                	j	80001c74 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cc4:	00000097          	auipc	ra,0x0
    80001cc8:	ecc080e7          	jalr	-308(ra) # 80001b90 <devintr>
    80001ccc:	892a                	mv	s2,a0
    80001cce:	c501                	beqz	a0,80001cd6 <usertrap+0xa4>
  if(p->killed)
    80001cd0:	549c                	lw	a5,40(s1)
    80001cd2:	c3a1                	beqz	a5,80001d12 <usertrap+0xe0>
    80001cd4:	a815                	j	80001d08 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cd6:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cda:	5890                	lw	a2,48(s1)
    80001cdc:	00006517          	auipc	a0,0x6
    80001ce0:	5dc50513          	addi	a0,a0,1500 # 800082b8 <states.1709+0x78>
    80001ce4:	00004097          	auipc	ra,0x4
    80001ce8:	e7e080e7          	jalr	-386(ra) # 80005b62 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cec:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cf0:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001cf4:	00006517          	auipc	a0,0x6
    80001cf8:	5f450513          	addi	a0,a0,1524 # 800082e8 <states.1709+0xa8>
    80001cfc:	00004097          	auipc	ra,0x4
    80001d00:	e66080e7          	jalr	-410(ra) # 80005b62 <printf>
    p->killed = 1;
    80001d04:	4785                	li	a5,1
    80001d06:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d08:	557d                	li	a0,-1
    80001d0a:	00000097          	auipc	ra,0x0
    80001d0e:	a56080e7          	jalr	-1450(ra) # 80001760 <exit>
  if(which_dev == 2)
    80001d12:	4789                	li	a5,2
    80001d14:	f8f910e3          	bne	s2,a5,80001c94 <usertrap+0x62>
    yield();
    80001d18:	fffff097          	auipc	ra,0xfffff
    80001d1c:	7b0080e7          	jalr	1968(ra) # 800014c8 <yield>
    80001d20:	bf95                	j	80001c94 <usertrap+0x62>
  int which_dev = 0;
    80001d22:	4901                	li	s2,0
    80001d24:	b7d5                	j	80001d08 <usertrap+0xd6>

0000000080001d26 <kerneltrap>:
{
    80001d26:	7179                	addi	sp,sp,-48
    80001d28:	f406                	sd	ra,40(sp)
    80001d2a:	f022                	sd	s0,32(sp)
    80001d2c:	ec26                	sd	s1,24(sp)
    80001d2e:	e84a                	sd	s2,16(sp)
    80001d30:	e44e                	sd	s3,8(sp)
    80001d32:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d34:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d38:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d3c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d40:	1004f793          	andi	a5,s1,256
    80001d44:	cb85                	beqz	a5,80001d74 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d46:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d4a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d4c:	ef85                	bnez	a5,80001d84 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d4e:	00000097          	auipc	ra,0x0
    80001d52:	e42080e7          	jalr	-446(ra) # 80001b90 <devintr>
    80001d56:	cd1d                	beqz	a0,80001d94 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001d58:	4789                	li	a5,2
    80001d5a:	06f50a63          	beq	a0,a5,80001dce <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d5e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d62:	10049073          	csrw	sstatus,s1
}
    80001d66:	70a2                	ld	ra,40(sp)
    80001d68:	7402                	ld	s0,32(sp)
    80001d6a:	64e2                	ld	s1,24(sp)
    80001d6c:	6942                	ld	s2,16(sp)
    80001d6e:	69a2                	ld	s3,8(sp)
    80001d70:	6145                	addi	sp,sp,48
    80001d72:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001d74:	00006517          	auipc	a0,0x6
    80001d78:	59450513          	addi	a0,a0,1428 # 80008308 <states.1709+0xc8>
    80001d7c:	00004097          	auipc	ra,0x4
    80001d80:	d9c080e7          	jalr	-612(ra) # 80005b18 <panic>
    panic("kerneltrap: interrupts enabled");
    80001d84:	00006517          	auipc	a0,0x6
    80001d88:	5ac50513          	addi	a0,a0,1452 # 80008330 <states.1709+0xf0>
    80001d8c:	00004097          	auipc	ra,0x4
    80001d90:	d8c080e7          	jalr	-628(ra) # 80005b18 <panic>
    printf("scause %p\n", scause);
    80001d94:	85ce                	mv	a1,s3
    80001d96:	00006517          	auipc	a0,0x6
    80001d9a:	5ba50513          	addi	a0,a0,1466 # 80008350 <states.1709+0x110>
    80001d9e:	00004097          	auipc	ra,0x4
    80001da2:	dc4080e7          	jalr	-572(ra) # 80005b62 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001daa:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dae:	00006517          	auipc	a0,0x6
    80001db2:	5b250513          	addi	a0,a0,1458 # 80008360 <states.1709+0x120>
    80001db6:	00004097          	auipc	ra,0x4
    80001dba:	dac080e7          	jalr	-596(ra) # 80005b62 <printf>
    panic("kerneltrap");
    80001dbe:	00006517          	auipc	a0,0x6
    80001dc2:	5ba50513          	addi	a0,a0,1466 # 80008378 <states.1709+0x138>
    80001dc6:	00004097          	auipc	ra,0x4
    80001dca:	d52080e7          	jalr	-686(ra) # 80005b18 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dce:	fffff097          	auipc	ra,0xfffff
    80001dd2:	07a080e7          	jalr	122(ra) # 80000e48 <myproc>
    80001dd6:	d541                	beqz	a0,80001d5e <kerneltrap+0x38>
    80001dd8:	fffff097          	auipc	ra,0xfffff
    80001ddc:	070080e7          	jalr	112(ra) # 80000e48 <myproc>
    80001de0:	4d18                	lw	a4,24(a0)
    80001de2:	4791                	li	a5,4
    80001de4:	f6f71de3          	bne	a4,a5,80001d5e <kerneltrap+0x38>
    yield();
    80001de8:	fffff097          	auipc	ra,0xfffff
    80001dec:	6e0080e7          	jalr	1760(ra) # 800014c8 <yield>
    80001df0:	b7bd                	j	80001d5e <kerneltrap+0x38>

0000000080001df2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001df2:	1101                	addi	sp,sp,-32
    80001df4:	ec06                	sd	ra,24(sp)
    80001df6:	e822                	sd	s0,16(sp)
    80001df8:	e426                	sd	s1,8(sp)
    80001dfa:	1000                	addi	s0,sp,32
    80001dfc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001dfe:	fffff097          	auipc	ra,0xfffff
    80001e02:	04a080e7          	jalr	74(ra) # 80000e48 <myproc>
  switch (n) {
    80001e06:	4795                	li	a5,5
    80001e08:	0497e163          	bltu	a5,s1,80001e4a <argraw+0x58>
    80001e0c:	048a                	slli	s1,s1,0x2
    80001e0e:	00006717          	auipc	a4,0x6
    80001e12:	5a270713          	addi	a4,a4,1442 # 800083b0 <states.1709+0x170>
    80001e16:	94ba                	add	s1,s1,a4
    80001e18:	409c                	lw	a5,0(s1)
    80001e1a:	97ba                	add	a5,a5,a4
    80001e1c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e1e:	6d3c                	ld	a5,88(a0)
    80001e20:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e22:	60e2                	ld	ra,24(sp)
    80001e24:	6442                	ld	s0,16(sp)
    80001e26:	64a2                	ld	s1,8(sp)
    80001e28:	6105                	addi	sp,sp,32
    80001e2a:	8082                	ret
    return p->trapframe->a1;
    80001e2c:	6d3c                	ld	a5,88(a0)
    80001e2e:	7fa8                	ld	a0,120(a5)
    80001e30:	bfcd                	j	80001e22 <argraw+0x30>
    return p->trapframe->a2;
    80001e32:	6d3c                	ld	a5,88(a0)
    80001e34:	63c8                	ld	a0,128(a5)
    80001e36:	b7f5                	j	80001e22 <argraw+0x30>
    return p->trapframe->a3;
    80001e38:	6d3c                	ld	a5,88(a0)
    80001e3a:	67c8                	ld	a0,136(a5)
    80001e3c:	b7dd                	j	80001e22 <argraw+0x30>
    return p->trapframe->a4;
    80001e3e:	6d3c                	ld	a5,88(a0)
    80001e40:	6bc8                	ld	a0,144(a5)
    80001e42:	b7c5                	j	80001e22 <argraw+0x30>
    return p->trapframe->a5;
    80001e44:	6d3c                	ld	a5,88(a0)
    80001e46:	6fc8                	ld	a0,152(a5)
    80001e48:	bfe9                	j	80001e22 <argraw+0x30>
  panic("argraw");
    80001e4a:	00006517          	auipc	a0,0x6
    80001e4e:	53e50513          	addi	a0,a0,1342 # 80008388 <states.1709+0x148>
    80001e52:	00004097          	auipc	ra,0x4
    80001e56:	cc6080e7          	jalr	-826(ra) # 80005b18 <panic>

0000000080001e5a <fetchaddr>:
{
    80001e5a:	1101                	addi	sp,sp,-32
    80001e5c:	ec06                	sd	ra,24(sp)
    80001e5e:	e822                	sd	s0,16(sp)
    80001e60:	e426                	sd	s1,8(sp)
    80001e62:	e04a                	sd	s2,0(sp)
    80001e64:	1000                	addi	s0,sp,32
    80001e66:	84aa                	mv	s1,a0
    80001e68:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e6a:	fffff097          	auipc	ra,0xfffff
    80001e6e:	fde080e7          	jalr	-34(ra) # 80000e48 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001e72:	653c                	ld	a5,72(a0)
    80001e74:	02f4f863          	bgeu	s1,a5,80001ea4 <fetchaddr+0x4a>
    80001e78:	00848713          	addi	a4,s1,8
    80001e7c:	02e7e663          	bltu	a5,a4,80001ea8 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001e80:	46a1                	li	a3,8
    80001e82:	8626                	mv	a2,s1
    80001e84:	85ca                	mv	a1,s2
    80001e86:	6928                	ld	a0,80(a0)
    80001e88:	fffff097          	auipc	ra,0xfffff
    80001e8c:	d0e080e7          	jalr	-754(ra) # 80000b96 <copyin>
    80001e90:	00a03533          	snez	a0,a0
    80001e94:	40a00533          	neg	a0,a0
}
    80001e98:	60e2                	ld	ra,24(sp)
    80001e9a:	6442                	ld	s0,16(sp)
    80001e9c:	64a2                	ld	s1,8(sp)
    80001e9e:	6902                	ld	s2,0(sp)
    80001ea0:	6105                	addi	sp,sp,32
    80001ea2:	8082                	ret
    return -1;
    80001ea4:	557d                	li	a0,-1
    80001ea6:	bfcd                	j	80001e98 <fetchaddr+0x3e>
    80001ea8:	557d                	li	a0,-1
    80001eaa:	b7fd                	j	80001e98 <fetchaddr+0x3e>

0000000080001eac <fetchstr>:
{
    80001eac:	7179                	addi	sp,sp,-48
    80001eae:	f406                	sd	ra,40(sp)
    80001eb0:	f022                	sd	s0,32(sp)
    80001eb2:	ec26                	sd	s1,24(sp)
    80001eb4:	e84a                	sd	s2,16(sp)
    80001eb6:	e44e                	sd	s3,8(sp)
    80001eb8:	1800                	addi	s0,sp,48
    80001eba:	892a                	mv	s2,a0
    80001ebc:	84ae                	mv	s1,a1
    80001ebe:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ec0:	fffff097          	auipc	ra,0xfffff
    80001ec4:	f88080e7          	jalr	-120(ra) # 80000e48 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001ec8:	86ce                	mv	a3,s3
    80001eca:	864a                	mv	a2,s2
    80001ecc:	85a6                	mv	a1,s1
    80001ece:	6928                	ld	a0,80(a0)
    80001ed0:	fffff097          	auipc	ra,0xfffff
    80001ed4:	d52080e7          	jalr	-686(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001ed8:	00054763          	bltz	a0,80001ee6 <fetchstr+0x3a>
  return strlen(buf);
    80001edc:	8526                	mv	a0,s1
    80001ede:	ffffe097          	auipc	ra,0xffffe
    80001ee2:	41e080e7          	jalr	1054(ra) # 800002fc <strlen>
}
    80001ee6:	70a2                	ld	ra,40(sp)
    80001ee8:	7402                	ld	s0,32(sp)
    80001eea:	64e2                	ld	s1,24(sp)
    80001eec:	6942                	ld	s2,16(sp)
    80001eee:	69a2                	ld	s3,8(sp)
    80001ef0:	6145                	addi	sp,sp,48
    80001ef2:	8082                	ret

0000000080001ef4 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001ef4:	1101                	addi	sp,sp,-32
    80001ef6:	ec06                	sd	ra,24(sp)
    80001ef8:	e822                	sd	s0,16(sp)
    80001efa:	e426                	sd	s1,8(sp)
    80001efc:	1000                	addi	s0,sp,32
    80001efe:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f00:	00000097          	auipc	ra,0x0
    80001f04:	ef2080e7          	jalr	-270(ra) # 80001df2 <argraw>
    80001f08:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f0a:	4501                	li	a0,0
    80001f0c:	60e2                	ld	ra,24(sp)
    80001f0e:	6442                	ld	s0,16(sp)
    80001f10:	64a2                	ld	s1,8(sp)
    80001f12:	6105                	addi	sp,sp,32
    80001f14:	8082                	ret

0000000080001f16 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f16:	1101                	addi	sp,sp,-32
    80001f18:	ec06                	sd	ra,24(sp)
    80001f1a:	e822                	sd	s0,16(sp)
    80001f1c:	e426                	sd	s1,8(sp)
    80001f1e:	1000                	addi	s0,sp,32
    80001f20:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f22:	00000097          	auipc	ra,0x0
    80001f26:	ed0080e7          	jalr	-304(ra) # 80001df2 <argraw>
    80001f2a:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f2c:	4501                	li	a0,0
    80001f2e:	60e2                	ld	ra,24(sp)
    80001f30:	6442                	ld	s0,16(sp)
    80001f32:	64a2                	ld	s1,8(sp)
    80001f34:	6105                	addi	sp,sp,32
    80001f36:	8082                	ret

0000000080001f38 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f38:	1101                	addi	sp,sp,-32
    80001f3a:	ec06                	sd	ra,24(sp)
    80001f3c:	e822                	sd	s0,16(sp)
    80001f3e:	e426                	sd	s1,8(sp)
    80001f40:	e04a                	sd	s2,0(sp)
    80001f42:	1000                	addi	s0,sp,32
    80001f44:	84ae                	mv	s1,a1
    80001f46:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f48:	00000097          	auipc	ra,0x0
    80001f4c:	eaa080e7          	jalr	-342(ra) # 80001df2 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001f50:	864a                	mv	a2,s2
    80001f52:	85a6                	mv	a1,s1
    80001f54:	00000097          	auipc	ra,0x0
    80001f58:	f58080e7          	jalr	-168(ra) # 80001eac <fetchstr>
}
    80001f5c:	60e2                	ld	ra,24(sp)
    80001f5e:	6442                	ld	s0,16(sp)
    80001f60:	64a2                	ld	s1,8(sp)
    80001f62:	6902                	ld	s2,0(sp)
    80001f64:	6105                	addi	sp,sp,32
    80001f66:	8082                	ret

0000000080001f68 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001f68:	1101                	addi	sp,sp,-32
    80001f6a:	ec06                	sd	ra,24(sp)
    80001f6c:	e822                	sd	s0,16(sp)
    80001f6e:	e426                	sd	s1,8(sp)
    80001f70:	e04a                	sd	s2,0(sp)
    80001f72:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001f74:	fffff097          	auipc	ra,0xfffff
    80001f78:	ed4080e7          	jalr	-300(ra) # 80000e48 <myproc>
    80001f7c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001f7e:	05853903          	ld	s2,88(a0)
    80001f82:	0a893783          	ld	a5,168(s2)
    80001f86:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001f8a:	37fd                	addiw	a5,a5,-1
    80001f8c:	4751                	li	a4,20
    80001f8e:	00f76f63          	bltu	a4,a5,80001fac <syscall+0x44>
    80001f92:	00369713          	slli	a4,a3,0x3
    80001f96:	00006797          	auipc	a5,0x6
    80001f9a:	43278793          	addi	a5,a5,1074 # 800083c8 <syscalls>
    80001f9e:	97ba                	add	a5,a5,a4
    80001fa0:	639c                	ld	a5,0(a5)
    80001fa2:	c789                	beqz	a5,80001fac <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80001fa4:	9782                	jalr	a5
    80001fa6:	06a93823          	sd	a0,112(s2)
    80001faa:	a839                	j	80001fc8 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001fac:	15848613          	addi	a2,s1,344
    80001fb0:	588c                	lw	a1,48(s1)
    80001fb2:	00006517          	auipc	a0,0x6
    80001fb6:	3de50513          	addi	a0,a0,990 # 80008390 <states.1709+0x150>
    80001fba:	00004097          	auipc	ra,0x4
    80001fbe:	ba8080e7          	jalr	-1112(ra) # 80005b62 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001fc2:	6cbc                	ld	a5,88(s1)
    80001fc4:	577d                	li	a4,-1
    80001fc6:	fbb8                	sd	a4,112(a5)
  }
}
    80001fc8:	60e2                	ld	ra,24(sp)
    80001fca:	6442                	ld	s0,16(sp)
    80001fcc:	64a2                	ld	s1,8(sp)
    80001fce:	6902                	ld	s2,0(sp)
    80001fd0:	6105                	addi	sp,sp,32
    80001fd2:	8082                	ret

0000000080001fd4 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001fd4:	1101                	addi	sp,sp,-32
    80001fd6:	ec06                	sd	ra,24(sp)
    80001fd8:	e822                	sd	s0,16(sp)
    80001fda:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80001fdc:	fec40593          	addi	a1,s0,-20
    80001fe0:	4501                	li	a0,0
    80001fe2:	00000097          	auipc	ra,0x0
    80001fe6:	f12080e7          	jalr	-238(ra) # 80001ef4 <argint>
    return -1;
    80001fea:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80001fec:	00054963          	bltz	a0,80001ffe <sys_exit+0x2a>
  exit(n);
    80001ff0:	fec42503          	lw	a0,-20(s0)
    80001ff4:	fffff097          	auipc	ra,0xfffff
    80001ff8:	76c080e7          	jalr	1900(ra) # 80001760 <exit>
  return 0;  // not reached
    80001ffc:	4781                	li	a5,0
}
    80001ffe:	853e                	mv	a0,a5
    80002000:	60e2                	ld	ra,24(sp)
    80002002:	6442                	ld	s0,16(sp)
    80002004:	6105                	addi	sp,sp,32
    80002006:	8082                	ret

0000000080002008 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002008:	1141                	addi	sp,sp,-16
    8000200a:	e406                	sd	ra,8(sp)
    8000200c:	e022                	sd	s0,0(sp)
    8000200e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002010:	fffff097          	auipc	ra,0xfffff
    80002014:	e38080e7          	jalr	-456(ra) # 80000e48 <myproc>
}
    80002018:	5908                	lw	a0,48(a0)
    8000201a:	60a2                	ld	ra,8(sp)
    8000201c:	6402                	ld	s0,0(sp)
    8000201e:	0141                	addi	sp,sp,16
    80002020:	8082                	ret

0000000080002022 <sys_fork>:

uint64
sys_fork(void)
{
    80002022:	1141                	addi	sp,sp,-16
    80002024:	e406                	sd	ra,8(sp)
    80002026:	e022                	sd	s0,0(sp)
    80002028:	0800                	addi	s0,sp,16
  return fork();
    8000202a:	fffff097          	auipc	ra,0xfffff
    8000202e:	1ec080e7          	jalr	492(ra) # 80001216 <fork>
}
    80002032:	60a2                	ld	ra,8(sp)
    80002034:	6402                	ld	s0,0(sp)
    80002036:	0141                	addi	sp,sp,16
    80002038:	8082                	ret

000000008000203a <sys_wait>:

uint64
sys_wait(void)
{
    8000203a:	1101                	addi	sp,sp,-32
    8000203c:	ec06                	sd	ra,24(sp)
    8000203e:	e822                	sd	s0,16(sp)
    80002040:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002042:	fe840593          	addi	a1,s0,-24
    80002046:	4501                	li	a0,0
    80002048:	00000097          	auipc	ra,0x0
    8000204c:	ece080e7          	jalr	-306(ra) # 80001f16 <argaddr>
    80002050:	87aa                	mv	a5,a0
    return -1;
    80002052:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002054:	0007c863          	bltz	a5,80002064 <sys_wait+0x2a>
  return wait(p);
    80002058:	fe843503          	ld	a0,-24(s0)
    8000205c:	fffff097          	auipc	ra,0xfffff
    80002060:	50c080e7          	jalr	1292(ra) # 80001568 <wait>
}
    80002064:	60e2                	ld	ra,24(sp)
    80002066:	6442                	ld	s0,16(sp)
    80002068:	6105                	addi	sp,sp,32
    8000206a:	8082                	ret

000000008000206c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000206c:	7179                	addi	sp,sp,-48
    8000206e:	f406                	sd	ra,40(sp)
    80002070:	f022                	sd	s0,32(sp)
    80002072:	ec26                	sd	s1,24(sp)
    80002074:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002076:	fdc40593          	addi	a1,s0,-36
    8000207a:	4501                	li	a0,0
    8000207c:	00000097          	auipc	ra,0x0
    80002080:	e78080e7          	jalr	-392(ra) # 80001ef4 <argint>
    80002084:	87aa                	mv	a5,a0
    return -1;
    80002086:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002088:	0207c063          	bltz	a5,800020a8 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000208c:	fffff097          	auipc	ra,0xfffff
    80002090:	dbc080e7          	jalr	-580(ra) # 80000e48 <myproc>
    80002094:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002096:	fdc42503          	lw	a0,-36(s0)
    8000209a:	fffff097          	auipc	ra,0xfffff
    8000209e:	108080e7          	jalr	264(ra) # 800011a2 <growproc>
    800020a2:	00054863          	bltz	a0,800020b2 <sys_sbrk+0x46>
    return -1;
  return addr;
    800020a6:	8526                	mv	a0,s1
}
    800020a8:	70a2                	ld	ra,40(sp)
    800020aa:	7402                	ld	s0,32(sp)
    800020ac:	64e2                	ld	s1,24(sp)
    800020ae:	6145                	addi	sp,sp,48
    800020b0:	8082                	ret
    return -1;
    800020b2:	557d                	li	a0,-1
    800020b4:	bfd5                	j	800020a8 <sys_sbrk+0x3c>

00000000800020b6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800020b6:	7139                	addi	sp,sp,-64
    800020b8:	fc06                	sd	ra,56(sp)
    800020ba:	f822                	sd	s0,48(sp)
    800020bc:	f426                	sd	s1,40(sp)
    800020be:	f04a                	sd	s2,32(sp)
    800020c0:	ec4e                	sd	s3,24(sp)
    800020c2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800020c4:	fcc40593          	addi	a1,s0,-52
    800020c8:	4501                	li	a0,0
    800020ca:	00000097          	auipc	ra,0x0
    800020ce:	e2a080e7          	jalr	-470(ra) # 80001ef4 <argint>
    return -1;
    800020d2:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020d4:	06054563          	bltz	a0,8000213e <sys_sleep+0x88>
  acquire(&tickslock);
    800020d8:	0000d517          	auipc	a0,0xd
    800020dc:	da850513          	addi	a0,a0,-600 # 8000ee80 <tickslock>
    800020e0:	00004097          	auipc	ra,0x4
    800020e4:	f82080e7          	jalr	-126(ra) # 80006062 <acquire>
  ticks0 = ticks;
    800020e8:	00007917          	auipc	s2,0x7
    800020ec:	f3092903          	lw	s2,-208(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800020f0:	fcc42783          	lw	a5,-52(s0)
    800020f4:	cf85                	beqz	a5,8000212c <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800020f6:	0000d997          	auipc	s3,0xd
    800020fa:	d8a98993          	addi	s3,s3,-630 # 8000ee80 <tickslock>
    800020fe:	00007497          	auipc	s1,0x7
    80002102:	f1a48493          	addi	s1,s1,-230 # 80009018 <ticks>
    if(myproc()->killed){
    80002106:	fffff097          	auipc	ra,0xfffff
    8000210a:	d42080e7          	jalr	-702(ra) # 80000e48 <myproc>
    8000210e:	551c                	lw	a5,40(a0)
    80002110:	ef9d                	bnez	a5,8000214e <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002112:	85ce                	mv	a1,s3
    80002114:	8526                	mv	a0,s1
    80002116:	fffff097          	auipc	ra,0xfffff
    8000211a:	3ee080e7          	jalr	1006(ra) # 80001504 <sleep>
  while(ticks - ticks0 < n){
    8000211e:	409c                	lw	a5,0(s1)
    80002120:	412787bb          	subw	a5,a5,s2
    80002124:	fcc42703          	lw	a4,-52(s0)
    80002128:	fce7efe3          	bltu	a5,a4,80002106 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000212c:	0000d517          	auipc	a0,0xd
    80002130:	d5450513          	addi	a0,a0,-684 # 8000ee80 <tickslock>
    80002134:	00004097          	auipc	ra,0x4
    80002138:	fe2080e7          	jalr	-30(ra) # 80006116 <release>
  return 0;
    8000213c:	4781                	li	a5,0
}
    8000213e:	853e                	mv	a0,a5
    80002140:	70e2                	ld	ra,56(sp)
    80002142:	7442                	ld	s0,48(sp)
    80002144:	74a2                	ld	s1,40(sp)
    80002146:	7902                	ld	s2,32(sp)
    80002148:	69e2                	ld	s3,24(sp)
    8000214a:	6121                	addi	sp,sp,64
    8000214c:	8082                	ret
      release(&tickslock);
    8000214e:	0000d517          	auipc	a0,0xd
    80002152:	d3250513          	addi	a0,a0,-718 # 8000ee80 <tickslock>
    80002156:	00004097          	auipc	ra,0x4
    8000215a:	fc0080e7          	jalr	-64(ra) # 80006116 <release>
      return -1;
    8000215e:	57fd                	li	a5,-1
    80002160:	bff9                	j	8000213e <sys_sleep+0x88>

0000000080002162 <sys_kill>:

uint64
sys_kill(void)
{
    80002162:	1101                	addi	sp,sp,-32
    80002164:	ec06                	sd	ra,24(sp)
    80002166:	e822                	sd	s0,16(sp)
    80002168:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000216a:	fec40593          	addi	a1,s0,-20
    8000216e:	4501                	li	a0,0
    80002170:	00000097          	auipc	ra,0x0
    80002174:	d84080e7          	jalr	-636(ra) # 80001ef4 <argint>
    80002178:	87aa                	mv	a5,a0
    return -1;
    8000217a:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000217c:	0007c863          	bltz	a5,8000218c <sys_kill+0x2a>
  return kill(pid);
    80002180:	fec42503          	lw	a0,-20(s0)
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	6b2080e7          	jalr	1714(ra) # 80001836 <kill>
}
    8000218c:	60e2                	ld	ra,24(sp)
    8000218e:	6442                	ld	s0,16(sp)
    80002190:	6105                	addi	sp,sp,32
    80002192:	8082                	ret

0000000080002194 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002194:	1101                	addi	sp,sp,-32
    80002196:	ec06                	sd	ra,24(sp)
    80002198:	e822                	sd	s0,16(sp)
    8000219a:	e426                	sd	s1,8(sp)
    8000219c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000219e:	0000d517          	auipc	a0,0xd
    800021a2:	ce250513          	addi	a0,a0,-798 # 8000ee80 <tickslock>
    800021a6:	00004097          	auipc	ra,0x4
    800021aa:	ebc080e7          	jalr	-324(ra) # 80006062 <acquire>
  xticks = ticks;
    800021ae:	00007497          	auipc	s1,0x7
    800021b2:	e6a4a483          	lw	s1,-406(s1) # 80009018 <ticks>
  release(&tickslock);
    800021b6:	0000d517          	auipc	a0,0xd
    800021ba:	cca50513          	addi	a0,a0,-822 # 8000ee80 <tickslock>
    800021be:	00004097          	auipc	ra,0x4
    800021c2:	f58080e7          	jalr	-168(ra) # 80006116 <release>
  return xticks;
}
    800021c6:	02049513          	slli	a0,s1,0x20
    800021ca:	9101                	srli	a0,a0,0x20
    800021cc:	60e2                	ld	ra,24(sp)
    800021ce:	6442                	ld	s0,16(sp)
    800021d0:	64a2                	ld	s1,8(sp)
    800021d2:	6105                	addi	sp,sp,32
    800021d4:	8082                	ret

00000000800021d6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800021d6:	7179                	addi	sp,sp,-48
    800021d8:	f406                	sd	ra,40(sp)
    800021da:	f022                	sd	s0,32(sp)
    800021dc:	ec26                	sd	s1,24(sp)
    800021de:	e84a                	sd	s2,16(sp)
    800021e0:	e44e                	sd	s3,8(sp)
    800021e2:	e052                	sd	s4,0(sp)
    800021e4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800021e6:	00006597          	auipc	a1,0x6
    800021ea:	29258593          	addi	a1,a1,658 # 80008478 <syscalls+0xb0>
    800021ee:	0000d517          	auipc	a0,0xd
    800021f2:	caa50513          	addi	a0,a0,-854 # 8000ee98 <bcache>
    800021f6:	00004097          	auipc	ra,0x4
    800021fa:	ddc080e7          	jalr	-548(ra) # 80005fd2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800021fe:	00015797          	auipc	a5,0x15
    80002202:	c9a78793          	addi	a5,a5,-870 # 80016e98 <bcache+0x8000>
    80002206:	00015717          	auipc	a4,0x15
    8000220a:	efa70713          	addi	a4,a4,-262 # 80017100 <bcache+0x8268>
    8000220e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002212:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002216:	0000d497          	auipc	s1,0xd
    8000221a:	c9a48493          	addi	s1,s1,-870 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    8000221e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002220:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002222:	00006a17          	auipc	s4,0x6
    80002226:	25ea0a13          	addi	s4,s4,606 # 80008480 <syscalls+0xb8>
    b->next = bcache.head.next;
    8000222a:	2b893783          	ld	a5,696(s2)
    8000222e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002230:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002234:	85d2                	mv	a1,s4
    80002236:	01048513          	addi	a0,s1,16
    8000223a:	00001097          	auipc	ra,0x1
    8000223e:	4bc080e7          	jalr	1212(ra) # 800036f6 <initsleeplock>
    bcache.head.next->prev = b;
    80002242:	2b893783          	ld	a5,696(s2)
    80002246:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002248:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000224c:	45848493          	addi	s1,s1,1112
    80002250:	fd349de3          	bne	s1,s3,8000222a <binit+0x54>
  }
}
    80002254:	70a2                	ld	ra,40(sp)
    80002256:	7402                	ld	s0,32(sp)
    80002258:	64e2                	ld	s1,24(sp)
    8000225a:	6942                	ld	s2,16(sp)
    8000225c:	69a2                	ld	s3,8(sp)
    8000225e:	6a02                	ld	s4,0(sp)
    80002260:	6145                	addi	sp,sp,48
    80002262:	8082                	ret

0000000080002264 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002264:	7179                	addi	sp,sp,-48
    80002266:	f406                	sd	ra,40(sp)
    80002268:	f022                	sd	s0,32(sp)
    8000226a:	ec26                	sd	s1,24(sp)
    8000226c:	e84a                	sd	s2,16(sp)
    8000226e:	e44e                	sd	s3,8(sp)
    80002270:	1800                	addi	s0,sp,48
    80002272:	89aa                	mv	s3,a0
    80002274:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002276:	0000d517          	auipc	a0,0xd
    8000227a:	c2250513          	addi	a0,a0,-990 # 8000ee98 <bcache>
    8000227e:	00004097          	auipc	ra,0x4
    80002282:	de4080e7          	jalr	-540(ra) # 80006062 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002286:	00015497          	auipc	s1,0x15
    8000228a:	eca4b483          	ld	s1,-310(s1) # 80017150 <bcache+0x82b8>
    8000228e:	00015797          	auipc	a5,0x15
    80002292:	e7278793          	addi	a5,a5,-398 # 80017100 <bcache+0x8268>
    80002296:	02f48f63          	beq	s1,a5,800022d4 <bread+0x70>
    8000229a:	873e                	mv	a4,a5
    8000229c:	a021                	j	800022a4 <bread+0x40>
    8000229e:	68a4                	ld	s1,80(s1)
    800022a0:	02e48a63          	beq	s1,a4,800022d4 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800022a4:	449c                	lw	a5,8(s1)
    800022a6:	ff379ce3          	bne	a5,s3,8000229e <bread+0x3a>
    800022aa:	44dc                	lw	a5,12(s1)
    800022ac:	ff2799e3          	bne	a5,s2,8000229e <bread+0x3a>
      b->refcnt++;
    800022b0:	40bc                	lw	a5,64(s1)
    800022b2:	2785                	addiw	a5,a5,1
    800022b4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800022b6:	0000d517          	auipc	a0,0xd
    800022ba:	be250513          	addi	a0,a0,-1054 # 8000ee98 <bcache>
    800022be:	00004097          	auipc	ra,0x4
    800022c2:	e58080e7          	jalr	-424(ra) # 80006116 <release>
      acquiresleep(&b->lock);
    800022c6:	01048513          	addi	a0,s1,16
    800022ca:	00001097          	auipc	ra,0x1
    800022ce:	466080e7          	jalr	1126(ra) # 80003730 <acquiresleep>
      return b;
    800022d2:	a8b9                	j	80002330 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022d4:	00015497          	auipc	s1,0x15
    800022d8:	e744b483          	ld	s1,-396(s1) # 80017148 <bcache+0x82b0>
    800022dc:	00015797          	auipc	a5,0x15
    800022e0:	e2478793          	addi	a5,a5,-476 # 80017100 <bcache+0x8268>
    800022e4:	00f48863          	beq	s1,a5,800022f4 <bread+0x90>
    800022e8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800022ea:	40bc                	lw	a5,64(s1)
    800022ec:	cf81                	beqz	a5,80002304 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022ee:	64a4                	ld	s1,72(s1)
    800022f0:	fee49de3          	bne	s1,a4,800022ea <bread+0x86>
  panic("bget: no buffers");
    800022f4:	00006517          	auipc	a0,0x6
    800022f8:	19450513          	addi	a0,a0,404 # 80008488 <syscalls+0xc0>
    800022fc:	00004097          	auipc	ra,0x4
    80002300:	81c080e7          	jalr	-2020(ra) # 80005b18 <panic>
      b->dev = dev;
    80002304:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002308:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000230c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002310:	4785                	li	a5,1
    80002312:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002314:	0000d517          	auipc	a0,0xd
    80002318:	b8450513          	addi	a0,a0,-1148 # 8000ee98 <bcache>
    8000231c:	00004097          	auipc	ra,0x4
    80002320:	dfa080e7          	jalr	-518(ra) # 80006116 <release>
      acquiresleep(&b->lock);
    80002324:	01048513          	addi	a0,s1,16
    80002328:	00001097          	auipc	ra,0x1
    8000232c:	408080e7          	jalr	1032(ra) # 80003730 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002330:	409c                	lw	a5,0(s1)
    80002332:	cb89                	beqz	a5,80002344 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002334:	8526                	mv	a0,s1
    80002336:	70a2                	ld	ra,40(sp)
    80002338:	7402                	ld	s0,32(sp)
    8000233a:	64e2                	ld	s1,24(sp)
    8000233c:	6942                	ld	s2,16(sp)
    8000233e:	69a2                	ld	s3,8(sp)
    80002340:	6145                	addi	sp,sp,48
    80002342:	8082                	ret
    virtio_disk_rw(b, 0);
    80002344:	4581                	li	a1,0
    80002346:	8526                	mv	a0,s1
    80002348:	00003097          	auipc	ra,0x3
    8000234c:	f0e080e7          	jalr	-242(ra) # 80005256 <virtio_disk_rw>
    b->valid = 1;
    80002350:	4785                	li	a5,1
    80002352:	c09c                	sw	a5,0(s1)
  return b;
    80002354:	b7c5                	j	80002334 <bread+0xd0>

0000000080002356 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002356:	1101                	addi	sp,sp,-32
    80002358:	ec06                	sd	ra,24(sp)
    8000235a:	e822                	sd	s0,16(sp)
    8000235c:	e426                	sd	s1,8(sp)
    8000235e:	1000                	addi	s0,sp,32
    80002360:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002362:	0541                	addi	a0,a0,16
    80002364:	00001097          	auipc	ra,0x1
    80002368:	466080e7          	jalr	1126(ra) # 800037ca <holdingsleep>
    8000236c:	cd01                	beqz	a0,80002384 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000236e:	4585                	li	a1,1
    80002370:	8526                	mv	a0,s1
    80002372:	00003097          	auipc	ra,0x3
    80002376:	ee4080e7          	jalr	-284(ra) # 80005256 <virtio_disk_rw>
}
    8000237a:	60e2                	ld	ra,24(sp)
    8000237c:	6442                	ld	s0,16(sp)
    8000237e:	64a2                	ld	s1,8(sp)
    80002380:	6105                	addi	sp,sp,32
    80002382:	8082                	ret
    panic("bwrite");
    80002384:	00006517          	auipc	a0,0x6
    80002388:	11c50513          	addi	a0,a0,284 # 800084a0 <syscalls+0xd8>
    8000238c:	00003097          	auipc	ra,0x3
    80002390:	78c080e7          	jalr	1932(ra) # 80005b18 <panic>

0000000080002394 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002394:	1101                	addi	sp,sp,-32
    80002396:	ec06                	sd	ra,24(sp)
    80002398:	e822                	sd	s0,16(sp)
    8000239a:	e426                	sd	s1,8(sp)
    8000239c:	e04a                	sd	s2,0(sp)
    8000239e:	1000                	addi	s0,sp,32
    800023a0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023a2:	01050913          	addi	s2,a0,16
    800023a6:	854a                	mv	a0,s2
    800023a8:	00001097          	auipc	ra,0x1
    800023ac:	422080e7          	jalr	1058(ra) # 800037ca <holdingsleep>
    800023b0:	c92d                	beqz	a0,80002422 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800023b2:	854a                	mv	a0,s2
    800023b4:	00001097          	auipc	ra,0x1
    800023b8:	3d2080e7          	jalr	978(ra) # 80003786 <releasesleep>

  acquire(&bcache.lock);
    800023bc:	0000d517          	auipc	a0,0xd
    800023c0:	adc50513          	addi	a0,a0,-1316 # 8000ee98 <bcache>
    800023c4:	00004097          	auipc	ra,0x4
    800023c8:	c9e080e7          	jalr	-866(ra) # 80006062 <acquire>
  b->refcnt--;
    800023cc:	40bc                	lw	a5,64(s1)
    800023ce:	37fd                	addiw	a5,a5,-1
    800023d0:	0007871b          	sext.w	a4,a5
    800023d4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800023d6:	eb05                	bnez	a4,80002406 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800023d8:	68bc                	ld	a5,80(s1)
    800023da:	64b8                	ld	a4,72(s1)
    800023dc:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800023de:	64bc                	ld	a5,72(s1)
    800023e0:	68b8                	ld	a4,80(s1)
    800023e2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800023e4:	00015797          	auipc	a5,0x15
    800023e8:	ab478793          	addi	a5,a5,-1356 # 80016e98 <bcache+0x8000>
    800023ec:	2b87b703          	ld	a4,696(a5)
    800023f0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800023f2:	00015717          	auipc	a4,0x15
    800023f6:	d0e70713          	addi	a4,a4,-754 # 80017100 <bcache+0x8268>
    800023fa:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800023fc:	2b87b703          	ld	a4,696(a5)
    80002400:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002402:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002406:	0000d517          	auipc	a0,0xd
    8000240a:	a9250513          	addi	a0,a0,-1390 # 8000ee98 <bcache>
    8000240e:	00004097          	auipc	ra,0x4
    80002412:	d08080e7          	jalr	-760(ra) # 80006116 <release>
}
    80002416:	60e2                	ld	ra,24(sp)
    80002418:	6442                	ld	s0,16(sp)
    8000241a:	64a2                	ld	s1,8(sp)
    8000241c:	6902                	ld	s2,0(sp)
    8000241e:	6105                	addi	sp,sp,32
    80002420:	8082                	ret
    panic("brelse");
    80002422:	00006517          	auipc	a0,0x6
    80002426:	08650513          	addi	a0,a0,134 # 800084a8 <syscalls+0xe0>
    8000242a:	00003097          	auipc	ra,0x3
    8000242e:	6ee080e7          	jalr	1774(ra) # 80005b18 <panic>

0000000080002432 <bpin>:

void
bpin(struct buf *b) {
    80002432:	1101                	addi	sp,sp,-32
    80002434:	ec06                	sd	ra,24(sp)
    80002436:	e822                	sd	s0,16(sp)
    80002438:	e426                	sd	s1,8(sp)
    8000243a:	1000                	addi	s0,sp,32
    8000243c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000243e:	0000d517          	auipc	a0,0xd
    80002442:	a5a50513          	addi	a0,a0,-1446 # 8000ee98 <bcache>
    80002446:	00004097          	auipc	ra,0x4
    8000244a:	c1c080e7          	jalr	-996(ra) # 80006062 <acquire>
  b->refcnt++;
    8000244e:	40bc                	lw	a5,64(s1)
    80002450:	2785                	addiw	a5,a5,1
    80002452:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002454:	0000d517          	auipc	a0,0xd
    80002458:	a4450513          	addi	a0,a0,-1468 # 8000ee98 <bcache>
    8000245c:	00004097          	auipc	ra,0x4
    80002460:	cba080e7          	jalr	-838(ra) # 80006116 <release>
}
    80002464:	60e2                	ld	ra,24(sp)
    80002466:	6442                	ld	s0,16(sp)
    80002468:	64a2                	ld	s1,8(sp)
    8000246a:	6105                	addi	sp,sp,32
    8000246c:	8082                	ret

000000008000246e <bunpin>:

void
bunpin(struct buf *b) {
    8000246e:	1101                	addi	sp,sp,-32
    80002470:	ec06                	sd	ra,24(sp)
    80002472:	e822                	sd	s0,16(sp)
    80002474:	e426                	sd	s1,8(sp)
    80002476:	1000                	addi	s0,sp,32
    80002478:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000247a:	0000d517          	auipc	a0,0xd
    8000247e:	a1e50513          	addi	a0,a0,-1506 # 8000ee98 <bcache>
    80002482:	00004097          	auipc	ra,0x4
    80002486:	be0080e7          	jalr	-1056(ra) # 80006062 <acquire>
  b->refcnt--;
    8000248a:	40bc                	lw	a5,64(s1)
    8000248c:	37fd                	addiw	a5,a5,-1
    8000248e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002490:	0000d517          	auipc	a0,0xd
    80002494:	a0850513          	addi	a0,a0,-1528 # 8000ee98 <bcache>
    80002498:	00004097          	auipc	ra,0x4
    8000249c:	c7e080e7          	jalr	-898(ra) # 80006116 <release>
}
    800024a0:	60e2                	ld	ra,24(sp)
    800024a2:	6442                	ld	s0,16(sp)
    800024a4:	64a2                	ld	s1,8(sp)
    800024a6:	6105                	addi	sp,sp,32
    800024a8:	8082                	ret

00000000800024aa <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800024aa:	1101                	addi	sp,sp,-32
    800024ac:	ec06                	sd	ra,24(sp)
    800024ae:	e822                	sd	s0,16(sp)
    800024b0:	e426                	sd	s1,8(sp)
    800024b2:	e04a                	sd	s2,0(sp)
    800024b4:	1000                	addi	s0,sp,32
    800024b6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800024b8:	00d5d59b          	srliw	a1,a1,0xd
    800024bc:	00015797          	auipc	a5,0x15
    800024c0:	0b87a783          	lw	a5,184(a5) # 80017574 <sb+0x1c>
    800024c4:	9dbd                	addw	a1,a1,a5
    800024c6:	00000097          	auipc	ra,0x0
    800024ca:	d9e080e7          	jalr	-610(ra) # 80002264 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800024ce:	0074f713          	andi	a4,s1,7
    800024d2:	4785                	li	a5,1
    800024d4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800024d8:	14ce                	slli	s1,s1,0x33
    800024da:	90d9                	srli	s1,s1,0x36
    800024dc:	00950733          	add	a4,a0,s1
    800024e0:	05874703          	lbu	a4,88(a4)
    800024e4:	00e7f6b3          	and	a3,a5,a4
    800024e8:	c69d                	beqz	a3,80002516 <bfree+0x6c>
    800024ea:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800024ec:	94aa                	add	s1,s1,a0
    800024ee:	fff7c793          	not	a5,a5
    800024f2:	8ff9                	and	a5,a5,a4
    800024f4:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800024f8:	00001097          	auipc	ra,0x1
    800024fc:	118080e7          	jalr	280(ra) # 80003610 <log_write>
  brelse(bp);
    80002500:	854a                	mv	a0,s2
    80002502:	00000097          	auipc	ra,0x0
    80002506:	e92080e7          	jalr	-366(ra) # 80002394 <brelse>
}
    8000250a:	60e2                	ld	ra,24(sp)
    8000250c:	6442                	ld	s0,16(sp)
    8000250e:	64a2                	ld	s1,8(sp)
    80002510:	6902                	ld	s2,0(sp)
    80002512:	6105                	addi	sp,sp,32
    80002514:	8082                	ret
    panic("freeing free block");
    80002516:	00006517          	auipc	a0,0x6
    8000251a:	f9a50513          	addi	a0,a0,-102 # 800084b0 <syscalls+0xe8>
    8000251e:	00003097          	auipc	ra,0x3
    80002522:	5fa080e7          	jalr	1530(ra) # 80005b18 <panic>

0000000080002526 <balloc>:
{
    80002526:	711d                	addi	sp,sp,-96
    80002528:	ec86                	sd	ra,88(sp)
    8000252a:	e8a2                	sd	s0,80(sp)
    8000252c:	e4a6                	sd	s1,72(sp)
    8000252e:	e0ca                	sd	s2,64(sp)
    80002530:	fc4e                	sd	s3,56(sp)
    80002532:	f852                	sd	s4,48(sp)
    80002534:	f456                	sd	s5,40(sp)
    80002536:	f05a                	sd	s6,32(sp)
    80002538:	ec5e                	sd	s7,24(sp)
    8000253a:	e862                	sd	s8,16(sp)
    8000253c:	e466                	sd	s9,8(sp)
    8000253e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002540:	00015797          	auipc	a5,0x15
    80002544:	01c7a783          	lw	a5,28(a5) # 8001755c <sb+0x4>
    80002548:	cbd1                	beqz	a5,800025dc <balloc+0xb6>
    8000254a:	8baa                	mv	s7,a0
    8000254c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000254e:	00015b17          	auipc	s6,0x15
    80002552:	00ab0b13          	addi	s6,s6,10 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002556:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002558:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000255a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000255c:	6c89                	lui	s9,0x2
    8000255e:	a831                	j	8000257a <balloc+0x54>
    brelse(bp);
    80002560:	854a                	mv	a0,s2
    80002562:	00000097          	auipc	ra,0x0
    80002566:	e32080e7          	jalr	-462(ra) # 80002394 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000256a:	015c87bb          	addw	a5,s9,s5
    8000256e:	00078a9b          	sext.w	s5,a5
    80002572:	004b2703          	lw	a4,4(s6)
    80002576:	06eaf363          	bgeu	s5,a4,800025dc <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000257a:	41fad79b          	sraiw	a5,s5,0x1f
    8000257e:	0137d79b          	srliw	a5,a5,0x13
    80002582:	015787bb          	addw	a5,a5,s5
    80002586:	40d7d79b          	sraiw	a5,a5,0xd
    8000258a:	01cb2583          	lw	a1,28(s6)
    8000258e:	9dbd                	addw	a1,a1,a5
    80002590:	855e                	mv	a0,s7
    80002592:	00000097          	auipc	ra,0x0
    80002596:	cd2080e7          	jalr	-814(ra) # 80002264 <bread>
    8000259a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000259c:	004b2503          	lw	a0,4(s6)
    800025a0:	000a849b          	sext.w	s1,s5
    800025a4:	8662                	mv	a2,s8
    800025a6:	faa4fde3          	bgeu	s1,a0,80002560 <balloc+0x3a>
      m = 1 << (bi % 8);
    800025aa:	41f6579b          	sraiw	a5,a2,0x1f
    800025ae:	01d7d69b          	srliw	a3,a5,0x1d
    800025b2:	00c6873b          	addw	a4,a3,a2
    800025b6:	00777793          	andi	a5,a4,7
    800025ba:	9f95                	subw	a5,a5,a3
    800025bc:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800025c0:	4037571b          	sraiw	a4,a4,0x3
    800025c4:	00e906b3          	add	a3,s2,a4
    800025c8:	0586c683          	lbu	a3,88(a3)
    800025cc:	00d7f5b3          	and	a1,a5,a3
    800025d0:	cd91                	beqz	a1,800025ec <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025d2:	2605                	addiw	a2,a2,1
    800025d4:	2485                	addiw	s1,s1,1
    800025d6:	fd4618e3          	bne	a2,s4,800025a6 <balloc+0x80>
    800025da:	b759                	j	80002560 <balloc+0x3a>
  panic("balloc: out of blocks");
    800025dc:	00006517          	auipc	a0,0x6
    800025e0:	eec50513          	addi	a0,a0,-276 # 800084c8 <syscalls+0x100>
    800025e4:	00003097          	auipc	ra,0x3
    800025e8:	534080e7          	jalr	1332(ra) # 80005b18 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025ec:	974a                	add	a4,a4,s2
    800025ee:	8fd5                	or	a5,a5,a3
    800025f0:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800025f4:	854a                	mv	a0,s2
    800025f6:	00001097          	auipc	ra,0x1
    800025fa:	01a080e7          	jalr	26(ra) # 80003610 <log_write>
        brelse(bp);
    800025fe:	854a                	mv	a0,s2
    80002600:	00000097          	auipc	ra,0x0
    80002604:	d94080e7          	jalr	-620(ra) # 80002394 <brelse>
  bp = bread(dev, bno);
    80002608:	85a6                	mv	a1,s1
    8000260a:	855e                	mv	a0,s7
    8000260c:	00000097          	auipc	ra,0x0
    80002610:	c58080e7          	jalr	-936(ra) # 80002264 <bread>
    80002614:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002616:	40000613          	li	a2,1024
    8000261a:	4581                	li	a1,0
    8000261c:	05850513          	addi	a0,a0,88
    80002620:	ffffe097          	auipc	ra,0xffffe
    80002624:	b58080e7          	jalr	-1192(ra) # 80000178 <memset>
  log_write(bp);
    80002628:	854a                	mv	a0,s2
    8000262a:	00001097          	auipc	ra,0x1
    8000262e:	fe6080e7          	jalr	-26(ra) # 80003610 <log_write>
  brelse(bp);
    80002632:	854a                	mv	a0,s2
    80002634:	00000097          	auipc	ra,0x0
    80002638:	d60080e7          	jalr	-672(ra) # 80002394 <brelse>
}
    8000263c:	8526                	mv	a0,s1
    8000263e:	60e6                	ld	ra,88(sp)
    80002640:	6446                	ld	s0,80(sp)
    80002642:	64a6                	ld	s1,72(sp)
    80002644:	6906                	ld	s2,64(sp)
    80002646:	79e2                	ld	s3,56(sp)
    80002648:	7a42                	ld	s4,48(sp)
    8000264a:	7aa2                	ld	s5,40(sp)
    8000264c:	7b02                	ld	s6,32(sp)
    8000264e:	6be2                	ld	s7,24(sp)
    80002650:	6c42                	ld	s8,16(sp)
    80002652:	6ca2                	ld	s9,8(sp)
    80002654:	6125                	addi	sp,sp,96
    80002656:	8082                	ret

0000000080002658 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002658:	7179                	addi	sp,sp,-48
    8000265a:	f406                	sd	ra,40(sp)
    8000265c:	f022                	sd	s0,32(sp)
    8000265e:	ec26                	sd	s1,24(sp)
    80002660:	e84a                	sd	s2,16(sp)
    80002662:	e44e                	sd	s3,8(sp)
    80002664:	e052                	sd	s4,0(sp)
    80002666:	1800                	addi	s0,sp,48
    80002668:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000266a:	47ad                	li	a5,11
    8000266c:	04b7fe63          	bgeu	a5,a1,800026c8 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002670:	ff45849b          	addiw	s1,a1,-12
    80002674:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002678:	0ff00793          	li	a5,255
    8000267c:	0ae7e363          	bltu	a5,a4,80002722 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002680:	08052583          	lw	a1,128(a0)
    80002684:	c5ad                	beqz	a1,800026ee <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002686:	00092503          	lw	a0,0(s2)
    8000268a:	00000097          	auipc	ra,0x0
    8000268e:	bda080e7          	jalr	-1062(ra) # 80002264 <bread>
    80002692:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002694:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002698:	02049593          	slli	a1,s1,0x20
    8000269c:	9181                	srli	a1,a1,0x20
    8000269e:	058a                	slli	a1,a1,0x2
    800026a0:	00b784b3          	add	s1,a5,a1
    800026a4:	0004a983          	lw	s3,0(s1)
    800026a8:	04098d63          	beqz	s3,80002702 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800026ac:	8552                	mv	a0,s4
    800026ae:	00000097          	auipc	ra,0x0
    800026b2:	ce6080e7          	jalr	-794(ra) # 80002394 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800026b6:	854e                	mv	a0,s3
    800026b8:	70a2                	ld	ra,40(sp)
    800026ba:	7402                	ld	s0,32(sp)
    800026bc:	64e2                	ld	s1,24(sp)
    800026be:	6942                	ld	s2,16(sp)
    800026c0:	69a2                	ld	s3,8(sp)
    800026c2:	6a02                	ld	s4,0(sp)
    800026c4:	6145                	addi	sp,sp,48
    800026c6:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800026c8:	02059493          	slli	s1,a1,0x20
    800026cc:	9081                	srli	s1,s1,0x20
    800026ce:	048a                	slli	s1,s1,0x2
    800026d0:	94aa                	add	s1,s1,a0
    800026d2:	0504a983          	lw	s3,80(s1)
    800026d6:	fe0990e3          	bnez	s3,800026b6 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800026da:	4108                	lw	a0,0(a0)
    800026dc:	00000097          	auipc	ra,0x0
    800026e0:	e4a080e7          	jalr	-438(ra) # 80002526 <balloc>
    800026e4:	0005099b          	sext.w	s3,a0
    800026e8:	0534a823          	sw	s3,80(s1)
    800026ec:	b7e9                	j	800026b6 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800026ee:	4108                	lw	a0,0(a0)
    800026f0:	00000097          	auipc	ra,0x0
    800026f4:	e36080e7          	jalr	-458(ra) # 80002526 <balloc>
    800026f8:	0005059b          	sext.w	a1,a0
    800026fc:	08b92023          	sw	a1,128(s2)
    80002700:	b759                	j	80002686 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002702:	00092503          	lw	a0,0(s2)
    80002706:	00000097          	auipc	ra,0x0
    8000270a:	e20080e7          	jalr	-480(ra) # 80002526 <balloc>
    8000270e:	0005099b          	sext.w	s3,a0
    80002712:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002716:	8552                	mv	a0,s4
    80002718:	00001097          	auipc	ra,0x1
    8000271c:	ef8080e7          	jalr	-264(ra) # 80003610 <log_write>
    80002720:	b771                	j	800026ac <bmap+0x54>
  panic("bmap: out of range");
    80002722:	00006517          	auipc	a0,0x6
    80002726:	dbe50513          	addi	a0,a0,-578 # 800084e0 <syscalls+0x118>
    8000272a:	00003097          	auipc	ra,0x3
    8000272e:	3ee080e7          	jalr	1006(ra) # 80005b18 <panic>

0000000080002732 <iget>:
{
    80002732:	7179                	addi	sp,sp,-48
    80002734:	f406                	sd	ra,40(sp)
    80002736:	f022                	sd	s0,32(sp)
    80002738:	ec26                	sd	s1,24(sp)
    8000273a:	e84a                	sd	s2,16(sp)
    8000273c:	e44e                	sd	s3,8(sp)
    8000273e:	e052                	sd	s4,0(sp)
    80002740:	1800                	addi	s0,sp,48
    80002742:	89aa                	mv	s3,a0
    80002744:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002746:	00015517          	auipc	a0,0x15
    8000274a:	e3250513          	addi	a0,a0,-462 # 80017578 <itable>
    8000274e:	00004097          	auipc	ra,0x4
    80002752:	914080e7          	jalr	-1772(ra) # 80006062 <acquire>
  empty = 0;
    80002756:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002758:	00015497          	auipc	s1,0x15
    8000275c:	e3848493          	addi	s1,s1,-456 # 80017590 <itable+0x18>
    80002760:	00017697          	auipc	a3,0x17
    80002764:	8c068693          	addi	a3,a3,-1856 # 80019020 <log>
    80002768:	a039                	j	80002776 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000276a:	02090b63          	beqz	s2,800027a0 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000276e:	08848493          	addi	s1,s1,136
    80002772:	02d48a63          	beq	s1,a3,800027a6 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002776:	449c                	lw	a5,8(s1)
    80002778:	fef059e3          	blez	a5,8000276a <iget+0x38>
    8000277c:	4098                	lw	a4,0(s1)
    8000277e:	ff3716e3          	bne	a4,s3,8000276a <iget+0x38>
    80002782:	40d8                	lw	a4,4(s1)
    80002784:	ff4713e3          	bne	a4,s4,8000276a <iget+0x38>
      ip->ref++;
    80002788:	2785                	addiw	a5,a5,1
    8000278a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000278c:	00015517          	auipc	a0,0x15
    80002790:	dec50513          	addi	a0,a0,-532 # 80017578 <itable>
    80002794:	00004097          	auipc	ra,0x4
    80002798:	982080e7          	jalr	-1662(ra) # 80006116 <release>
      return ip;
    8000279c:	8926                	mv	s2,s1
    8000279e:	a03d                	j	800027cc <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027a0:	f7f9                	bnez	a5,8000276e <iget+0x3c>
    800027a2:	8926                	mv	s2,s1
    800027a4:	b7e9                	j	8000276e <iget+0x3c>
  if(empty == 0)
    800027a6:	02090c63          	beqz	s2,800027de <iget+0xac>
  ip->dev = dev;
    800027aa:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800027ae:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800027b2:	4785                	li	a5,1
    800027b4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800027b8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800027bc:	00015517          	auipc	a0,0x15
    800027c0:	dbc50513          	addi	a0,a0,-580 # 80017578 <itable>
    800027c4:	00004097          	auipc	ra,0x4
    800027c8:	952080e7          	jalr	-1710(ra) # 80006116 <release>
}
    800027cc:	854a                	mv	a0,s2
    800027ce:	70a2                	ld	ra,40(sp)
    800027d0:	7402                	ld	s0,32(sp)
    800027d2:	64e2                	ld	s1,24(sp)
    800027d4:	6942                	ld	s2,16(sp)
    800027d6:	69a2                	ld	s3,8(sp)
    800027d8:	6a02                	ld	s4,0(sp)
    800027da:	6145                	addi	sp,sp,48
    800027dc:	8082                	ret
    panic("iget: no inodes");
    800027de:	00006517          	auipc	a0,0x6
    800027e2:	d1a50513          	addi	a0,a0,-742 # 800084f8 <syscalls+0x130>
    800027e6:	00003097          	auipc	ra,0x3
    800027ea:	332080e7          	jalr	818(ra) # 80005b18 <panic>

00000000800027ee <fsinit>:
fsinit(int dev) {
    800027ee:	7179                	addi	sp,sp,-48
    800027f0:	f406                	sd	ra,40(sp)
    800027f2:	f022                	sd	s0,32(sp)
    800027f4:	ec26                	sd	s1,24(sp)
    800027f6:	e84a                	sd	s2,16(sp)
    800027f8:	e44e                	sd	s3,8(sp)
    800027fa:	1800                	addi	s0,sp,48
    800027fc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800027fe:	4585                	li	a1,1
    80002800:	00000097          	auipc	ra,0x0
    80002804:	a64080e7          	jalr	-1436(ra) # 80002264 <bread>
    80002808:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000280a:	00015997          	auipc	s3,0x15
    8000280e:	d4e98993          	addi	s3,s3,-690 # 80017558 <sb>
    80002812:	02000613          	li	a2,32
    80002816:	05850593          	addi	a1,a0,88
    8000281a:	854e                	mv	a0,s3
    8000281c:	ffffe097          	auipc	ra,0xffffe
    80002820:	9bc080e7          	jalr	-1604(ra) # 800001d8 <memmove>
  brelse(bp);
    80002824:	8526                	mv	a0,s1
    80002826:	00000097          	auipc	ra,0x0
    8000282a:	b6e080e7          	jalr	-1170(ra) # 80002394 <brelse>
  if(sb.magic != FSMAGIC)
    8000282e:	0009a703          	lw	a4,0(s3)
    80002832:	102037b7          	lui	a5,0x10203
    80002836:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000283a:	02f71263          	bne	a4,a5,8000285e <fsinit+0x70>
  initlog(dev, &sb);
    8000283e:	00015597          	auipc	a1,0x15
    80002842:	d1a58593          	addi	a1,a1,-742 # 80017558 <sb>
    80002846:	854a                	mv	a0,s2
    80002848:	00001097          	auipc	ra,0x1
    8000284c:	b4c080e7          	jalr	-1204(ra) # 80003394 <initlog>
}
    80002850:	70a2                	ld	ra,40(sp)
    80002852:	7402                	ld	s0,32(sp)
    80002854:	64e2                	ld	s1,24(sp)
    80002856:	6942                	ld	s2,16(sp)
    80002858:	69a2                	ld	s3,8(sp)
    8000285a:	6145                	addi	sp,sp,48
    8000285c:	8082                	ret
    panic("invalid file system");
    8000285e:	00006517          	auipc	a0,0x6
    80002862:	caa50513          	addi	a0,a0,-854 # 80008508 <syscalls+0x140>
    80002866:	00003097          	auipc	ra,0x3
    8000286a:	2b2080e7          	jalr	690(ra) # 80005b18 <panic>

000000008000286e <iinit>:
{
    8000286e:	7179                	addi	sp,sp,-48
    80002870:	f406                	sd	ra,40(sp)
    80002872:	f022                	sd	s0,32(sp)
    80002874:	ec26                	sd	s1,24(sp)
    80002876:	e84a                	sd	s2,16(sp)
    80002878:	e44e                	sd	s3,8(sp)
    8000287a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000287c:	00006597          	auipc	a1,0x6
    80002880:	ca458593          	addi	a1,a1,-860 # 80008520 <syscalls+0x158>
    80002884:	00015517          	auipc	a0,0x15
    80002888:	cf450513          	addi	a0,a0,-780 # 80017578 <itable>
    8000288c:	00003097          	auipc	ra,0x3
    80002890:	746080e7          	jalr	1862(ra) # 80005fd2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002894:	00015497          	auipc	s1,0x15
    80002898:	d0c48493          	addi	s1,s1,-756 # 800175a0 <itable+0x28>
    8000289c:	00016997          	auipc	s3,0x16
    800028a0:	79498993          	addi	s3,s3,1940 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800028a4:	00006917          	auipc	s2,0x6
    800028a8:	c8490913          	addi	s2,s2,-892 # 80008528 <syscalls+0x160>
    800028ac:	85ca                	mv	a1,s2
    800028ae:	8526                	mv	a0,s1
    800028b0:	00001097          	auipc	ra,0x1
    800028b4:	e46080e7          	jalr	-442(ra) # 800036f6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800028b8:	08848493          	addi	s1,s1,136
    800028bc:	ff3498e3          	bne	s1,s3,800028ac <iinit+0x3e>
}
    800028c0:	70a2                	ld	ra,40(sp)
    800028c2:	7402                	ld	s0,32(sp)
    800028c4:	64e2                	ld	s1,24(sp)
    800028c6:	6942                	ld	s2,16(sp)
    800028c8:	69a2                	ld	s3,8(sp)
    800028ca:	6145                	addi	sp,sp,48
    800028cc:	8082                	ret

00000000800028ce <ialloc>:
{
    800028ce:	715d                	addi	sp,sp,-80
    800028d0:	e486                	sd	ra,72(sp)
    800028d2:	e0a2                	sd	s0,64(sp)
    800028d4:	fc26                	sd	s1,56(sp)
    800028d6:	f84a                	sd	s2,48(sp)
    800028d8:	f44e                	sd	s3,40(sp)
    800028da:	f052                	sd	s4,32(sp)
    800028dc:	ec56                	sd	s5,24(sp)
    800028de:	e85a                	sd	s6,16(sp)
    800028e0:	e45e                	sd	s7,8(sp)
    800028e2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800028e4:	00015717          	auipc	a4,0x15
    800028e8:	c8072703          	lw	a4,-896(a4) # 80017564 <sb+0xc>
    800028ec:	4785                	li	a5,1
    800028ee:	04e7fa63          	bgeu	a5,a4,80002942 <ialloc+0x74>
    800028f2:	8aaa                	mv	s5,a0
    800028f4:	8bae                	mv	s7,a1
    800028f6:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800028f8:	00015a17          	auipc	s4,0x15
    800028fc:	c60a0a13          	addi	s4,s4,-928 # 80017558 <sb>
    80002900:	00048b1b          	sext.w	s6,s1
    80002904:	0044d593          	srli	a1,s1,0x4
    80002908:	018a2783          	lw	a5,24(s4)
    8000290c:	9dbd                	addw	a1,a1,a5
    8000290e:	8556                	mv	a0,s5
    80002910:	00000097          	auipc	ra,0x0
    80002914:	954080e7          	jalr	-1708(ra) # 80002264 <bread>
    80002918:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000291a:	05850993          	addi	s3,a0,88
    8000291e:	00f4f793          	andi	a5,s1,15
    80002922:	079a                	slli	a5,a5,0x6
    80002924:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002926:	00099783          	lh	a5,0(s3)
    8000292a:	c785                	beqz	a5,80002952 <ialloc+0x84>
    brelse(bp);
    8000292c:	00000097          	auipc	ra,0x0
    80002930:	a68080e7          	jalr	-1432(ra) # 80002394 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002934:	0485                	addi	s1,s1,1
    80002936:	00ca2703          	lw	a4,12(s4)
    8000293a:	0004879b          	sext.w	a5,s1
    8000293e:	fce7e1e3          	bltu	a5,a4,80002900 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002942:	00006517          	auipc	a0,0x6
    80002946:	bee50513          	addi	a0,a0,-1042 # 80008530 <syscalls+0x168>
    8000294a:	00003097          	auipc	ra,0x3
    8000294e:	1ce080e7          	jalr	462(ra) # 80005b18 <panic>
      memset(dip, 0, sizeof(*dip));
    80002952:	04000613          	li	a2,64
    80002956:	4581                	li	a1,0
    80002958:	854e                	mv	a0,s3
    8000295a:	ffffe097          	auipc	ra,0xffffe
    8000295e:	81e080e7          	jalr	-2018(ra) # 80000178 <memset>
      dip->type = type;
    80002962:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002966:	854a                	mv	a0,s2
    80002968:	00001097          	auipc	ra,0x1
    8000296c:	ca8080e7          	jalr	-856(ra) # 80003610 <log_write>
      brelse(bp);
    80002970:	854a                	mv	a0,s2
    80002972:	00000097          	auipc	ra,0x0
    80002976:	a22080e7          	jalr	-1502(ra) # 80002394 <brelse>
      return iget(dev, inum);
    8000297a:	85da                	mv	a1,s6
    8000297c:	8556                	mv	a0,s5
    8000297e:	00000097          	auipc	ra,0x0
    80002982:	db4080e7          	jalr	-588(ra) # 80002732 <iget>
}
    80002986:	60a6                	ld	ra,72(sp)
    80002988:	6406                	ld	s0,64(sp)
    8000298a:	74e2                	ld	s1,56(sp)
    8000298c:	7942                	ld	s2,48(sp)
    8000298e:	79a2                	ld	s3,40(sp)
    80002990:	7a02                	ld	s4,32(sp)
    80002992:	6ae2                	ld	s5,24(sp)
    80002994:	6b42                	ld	s6,16(sp)
    80002996:	6ba2                	ld	s7,8(sp)
    80002998:	6161                	addi	sp,sp,80
    8000299a:	8082                	ret

000000008000299c <iupdate>:
{
    8000299c:	1101                	addi	sp,sp,-32
    8000299e:	ec06                	sd	ra,24(sp)
    800029a0:	e822                	sd	s0,16(sp)
    800029a2:	e426                	sd	s1,8(sp)
    800029a4:	e04a                	sd	s2,0(sp)
    800029a6:	1000                	addi	s0,sp,32
    800029a8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800029aa:	415c                	lw	a5,4(a0)
    800029ac:	0047d79b          	srliw	a5,a5,0x4
    800029b0:	00015597          	auipc	a1,0x15
    800029b4:	bc05a583          	lw	a1,-1088(a1) # 80017570 <sb+0x18>
    800029b8:	9dbd                	addw	a1,a1,a5
    800029ba:	4108                	lw	a0,0(a0)
    800029bc:	00000097          	auipc	ra,0x0
    800029c0:	8a8080e7          	jalr	-1880(ra) # 80002264 <bread>
    800029c4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800029c6:	05850793          	addi	a5,a0,88
    800029ca:	40c8                	lw	a0,4(s1)
    800029cc:	893d                	andi	a0,a0,15
    800029ce:	051a                	slli	a0,a0,0x6
    800029d0:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800029d2:	04449703          	lh	a4,68(s1)
    800029d6:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800029da:	04649703          	lh	a4,70(s1)
    800029de:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800029e2:	04849703          	lh	a4,72(s1)
    800029e6:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800029ea:	04a49703          	lh	a4,74(s1)
    800029ee:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800029f2:	44f8                	lw	a4,76(s1)
    800029f4:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800029f6:	03400613          	li	a2,52
    800029fa:	05048593          	addi	a1,s1,80
    800029fe:	0531                	addi	a0,a0,12
    80002a00:	ffffd097          	auipc	ra,0xffffd
    80002a04:	7d8080e7          	jalr	2008(ra) # 800001d8 <memmove>
  log_write(bp);
    80002a08:	854a                	mv	a0,s2
    80002a0a:	00001097          	auipc	ra,0x1
    80002a0e:	c06080e7          	jalr	-1018(ra) # 80003610 <log_write>
  brelse(bp);
    80002a12:	854a                	mv	a0,s2
    80002a14:	00000097          	auipc	ra,0x0
    80002a18:	980080e7          	jalr	-1664(ra) # 80002394 <brelse>
}
    80002a1c:	60e2                	ld	ra,24(sp)
    80002a1e:	6442                	ld	s0,16(sp)
    80002a20:	64a2                	ld	s1,8(sp)
    80002a22:	6902                	ld	s2,0(sp)
    80002a24:	6105                	addi	sp,sp,32
    80002a26:	8082                	ret

0000000080002a28 <idup>:
{
    80002a28:	1101                	addi	sp,sp,-32
    80002a2a:	ec06                	sd	ra,24(sp)
    80002a2c:	e822                	sd	s0,16(sp)
    80002a2e:	e426                	sd	s1,8(sp)
    80002a30:	1000                	addi	s0,sp,32
    80002a32:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002a34:	00015517          	auipc	a0,0x15
    80002a38:	b4450513          	addi	a0,a0,-1212 # 80017578 <itable>
    80002a3c:	00003097          	auipc	ra,0x3
    80002a40:	626080e7          	jalr	1574(ra) # 80006062 <acquire>
  ip->ref++;
    80002a44:	449c                	lw	a5,8(s1)
    80002a46:	2785                	addiw	a5,a5,1
    80002a48:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002a4a:	00015517          	auipc	a0,0x15
    80002a4e:	b2e50513          	addi	a0,a0,-1234 # 80017578 <itable>
    80002a52:	00003097          	auipc	ra,0x3
    80002a56:	6c4080e7          	jalr	1732(ra) # 80006116 <release>
}
    80002a5a:	8526                	mv	a0,s1
    80002a5c:	60e2                	ld	ra,24(sp)
    80002a5e:	6442                	ld	s0,16(sp)
    80002a60:	64a2                	ld	s1,8(sp)
    80002a62:	6105                	addi	sp,sp,32
    80002a64:	8082                	ret

0000000080002a66 <ilock>:
{
    80002a66:	1101                	addi	sp,sp,-32
    80002a68:	ec06                	sd	ra,24(sp)
    80002a6a:	e822                	sd	s0,16(sp)
    80002a6c:	e426                	sd	s1,8(sp)
    80002a6e:	e04a                	sd	s2,0(sp)
    80002a70:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002a72:	c115                	beqz	a0,80002a96 <ilock+0x30>
    80002a74:	84aa                	mv	s1,a0
    80002a76:	451c                	lw	a5,8(a0)
    80002a78:	00f05f63          	blez	a5,80002a96 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002a7c:	0541                	addi	a0,a0,16
    80002a7e:	00001097          	auipc	ra,0x1
    80002a82:	cb2080e7          	jalr	-846(ra) # 80003730 <acquiresleep>
  if(ip->valid == 0){
    80002a86:	40bc                	lw	a5,64(s1)
    80002a88:	cf99                	beqz	a5,80002aa6 <ilock+0x40>
}
    80002a8a:	60e2                	ld	ra,24(sp)
    80002a8c:	6442                	ld	s0,16(sp)
    80002a8e:	64a2                	ld	s1,8(sp)
    80002a90:	6902                	ld	s2,0(sp)
    80002a92:	6105                	addi	sp,sp,32
    80002a94:	8082                	ret
    panic("ilock");
    80002a96:	00006517          	auipc	a0,0x6
    80002a9a:	ab250513          	addi	a0,a0,-1358 # 80008548 <syscalls+0x180>
    80002a9e:	00003097          	auipc	ra,0x3
    80002aa2:	07a080e7          	jalr	122(ra) # 80005b18 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002aa6:	40dc                	lw	a5,4(s1)
    80002aa8:	0047d79b          	srliw	a5,a5,0x4
    80002aac:	00015597          	auipc	a1,0x15
    80002ab0:	ac45a583          	lw	a1,-1340(a1) # 80017570 <sb+0x18>
    80002ab4:	9dbd                	addw	a1,a1,a5
    80002ab6:	4088                	lw	a0,0(s1)
    80002ab8:	fffff097          	auipc	ra,0xfffff
    80002abc:	7ac080e7          	jalr	1964(ra) # 80002264 <bread>
    80002ac0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ac2:	05850593          	addi	a1,a0,88
    80002ac6:	40dc                	lw	a5,4(s1)
    80002ac8:	8bbd                	andi	a5,a5,15
    80002aca:	079a                	slli	a5,a5,0x6
    80002acc:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ace:	00059783          	lh	a5,0(a1)
    80002ad2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002ad6:	00259783          	lh	a5,2(a1)
    80002ada:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ade:	00459783          	lh	a5,4(a1)
    80002ae2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ae6:	00659783          	lh	a5,6(a1)
    80002aea:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002aee:	459c                	lw	a5,8(a1)
    80002af0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002af2:	03400613          	li	a2,52
    80002af6:	05b1                	addi	a1,a1,12
    80002af8:	05048513          	addi	a0,s1,80
    80002afc:	ffffd097          	auipc	ra,0xffffd
    80002b00:	6dc080e7          	jalr	1756(ra) # 800001d8 <memmove>
    brelse(bp);
    80002b04:	854a                	mv	a0,s2
    80002b06:	00000097          	auipc	ra,0x0
    80002b0a:	88e080e7          	jalr	-1906(ra) # 80002394 <brelse>
    ip->valid = 1;
    80002b0e:	4785                	li	a5,1
    80002b10:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b12:	04449783          	lh	a5,68(s1)
    80002b16:	fbb5                	bnez	a5,80002a8a <ilock+0x24>
      panic("ilock: no type");
    80002b18:	00006517          	auipc	a0,0x6
    80002b1c:	a3850513          	addi	a0,a0,-1480 # 80008550 <syscalls+0x188>
    80002b20:	00003097          	auipc	ra,0x3
    80002b24:	ff8080e7          	jalr	-8(ra) # 80005b18 <panic>

0000000080002b28 <iunlock>:
{
    80002b28:	1101                	addi	sp,sp,-32
    80002b2a:	ec06                	sd	ra,24(sp)
    80002b2c:	e822                	sd	s0,16(sp)
    80002b2e:	e426                	sd	s1,8(sp)
    80002b30:	e04a                	sd	s2,0(sp)
    80002b32:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002b34:	c905                	beqz	a0,80002b64 <iunlock+0x3c>
    80002b36:	84aa                	mv	s1,a0
    80002b38:	01050913          	addi	s2,a0,16
    80002b3c:	854a                	mv	a0,s2
    80002b3e:	00001097          	auipc	ra,0x1
    80002b42:	c8c080e7          	jalr	-884(ra) # 800037ca <holdingsleep>
    80002b46:	cd19                	beqz	a0,80002b64 <iunlock+0x3c>
    80002b48:	449c                	lw	a5,8(s1)
    80002b4a:	00f05d63          	blez	a5,80002b64 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002b4e:	854a                	mv	a0,s2
    80002b50:	00001097          	auipc	ra,0x1
    80002b54:	c36080e7          	jalr	-970(ra) # 80003786 <releasesleep>
}
    80002b58:	60e2                	ld	ra,24(sp)
    80002b5a:	6442                	ld	s0,16(sp)
    80002b5c:	64a2                	ld	s1,8(sp)
    80002b5e:	6902                	ld	s2,0(sp)
    80002b60:	6105                	addi	sp,sp,32
    80002b62:	8082                	ret
    panic("iunlock");
    80002b64:	00006517          	auipc	a0,0x6
    80002b68:	9fc50513          	addi	a0,a0,-1540 # 80008560 <syscalls+0x198>
    80002b6c:	00003097          	auipc	ra,0x3
    80002b70:	fac080e7          	jalr	-84(ra) # 80005b18 <panic>

0000000080002b74 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002b74:	7179                	addi	sp,sp,-48
    80002b76:	f406                	sd	ra,40(sp)
    80002b78:	f022                	sd	s0,32(sp)
    80002b7a:	ec26                	sd	s1,24(sp)
    80002b7c:	e84a                	sd	s2,16(sp)
    80002b7e:	e44e                	sd	s3,8(sp)
    80002b80:	e052                	sd	s4,0(sp)
    80002b82:	1800                	addi	s0,sp,48
    80002b84:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002b86:	05050493          	addi	s1,a0,80
    80002b8a:	08050913          	addi	s2,a0,128
    80002b8e:	a021                	j	80002b96 <itrunc+0x22>
    80002b90:	0491                	addi	s1,s1,4
    80002b92:	01248d63          	beq	s1,s2,80002bac <itrunc+0x38>
    if(ip->addrs[i]){
    80002b96:	408c                	lw	a1,0(s1)
    80002b98:	dde5                	beqz	a1,80002b90 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002b9a:	0009a503          	lw	a0,0(s3)
    80002b9e:	00000097          	auipc	ra,0x0
    80002ba2:	90c080e7          	jalr	-1780(ra) # 800024aa <bfree>
      ip->addrs[i] = 0;
    80002ba6:	0004a023          	sw	zero,0(s1)
    80002baa:	b7dd                	j	80002b90 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002bac:	0809a583          	lw	a1,128(s3)
    80002bb0:	e185                	bnez	a1,80002bd0 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002bb2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002bb6:	854e                	mv	a0,s3
    80002bb8:	00000097          	auipc	ra,0x0
    80002bbc:	de4080e7          	jalr	-540(ra) # 8000299c <iupdate>
}
    80002bc0:	70a2                	ld	ra,40(sp)
    80002bc2:	7402                	ld	s0,32(sp)
    80002bc4:	64e2                	ld	s1,24(sp)
    80002bc6:	6942                	ld	s2,16(sp)
    80002bc8:	69a2                	ld	s3,8(sp)
    80002bca:	6a02                	ld	s4,0(sp)
    80002bcc:	6145                	addi	sp,sp,48
    80002bce:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002bd0:	0009a503          	lw	a0,0(s3)
    80002bd4:	fffff097          	auipc	ra,0xfffff
    80002bd8:	690080e7          	jalr	1680(ra) # 80002264 <bread>
    80002bdc:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002bde:	05850493          	addi	s1,a0,88
    80002be2:	45850913          	addi	s2,a0,1112
    80002be6:	a811                	j	80002bfa <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002be8:	0009a503          	lw	a0,0(s3)
    80002bec:	00000097          	auipc	ra,0x0
    80002bf0:	8be080e7          	jalr	-1858(ra) # 800024aa <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002bf4:	0491                	addi	s1,s1,4
    80002bf6:	01248563          	beq	s1,s2,80002c00 <itrunc+0x8c>
      if(a[j])
    80002bfa:	408c                	lw	a1,0(s1)
    80002bfc:	dde5                	beqz	a1,80002bf4 <itrunc+0x80>
    80002bfe:	b7ed                	j	80002be8 <itrunc+0x74>
    brelse(bp);
    80002c00:	8552                	mv	a0,s4
    80002c02:	fffff097          	auipc	ra,0xfffff
    80002c06:	792080e7          	jalr	1938(ra) # 80002394 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c0a:	0809a583          	lw	a1,128(s3)
    80002c0e:	0009a503          	lw	a0,0(s3)
    80002c12:	00000097          	auipc	ra,0x0
    80002c16:	898080e7          	jalr	-1896(ra) # 800024aa <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c1a:	0809a023          	sw	zero,128(s3)
    80002c1e:	bf51                	j	80002bb2 <itrunc+0x3e>

0000000080002c20 <iput>:
{
    80002c20:	1101                	addi	sp,sp,-32
    80002c22:	ec06                	sd	ra,24(sp)
    80002c24:	e822                	sd	s0,16(sp)
    80002c26:	e426                	sd	s1,8(sp)
    80002c28:	e04a                	sd	s2,0(sp)
    80002c2a:	1000                	addi	s0,sp,32
    80002c2c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c2e:	00015517          	auipc	a0,0x15
    80002c32:	94a50513          	addi	a0,a0,-1718 # 80017578 <itable>
    80002c36:	00003097          	auipc	ra,0x3
    80002c3a:	42c080e7          	jalr	1068(ra) # 80006062 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002c3e:	4498                	lw	a4,8(s1)
    80002c40:	4785                	li	a5,1
    80002c42:	02f70363          	beq	a4,a5,80002c68 <iput+0x48>
  ip->ref--;
    80002c46:	449c                	lw	a5,8(s1)
    80002c48:	37fd                	addiw	a5,a5,-1
    80002c4a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c4c:	00015517          	auipc	a0,0x15
    80002c50:	92c50513          	addi	a0,a0,-1748 # 80017578 <itable>
    80002c54:	00003097          	auipc	ra,0x3
    80002c58:	4c2080e7          	jalr	1218(ra) # 80006116 <release>
}
    80002c5c:	60e2                	ld	ra,24(sp)
    80002c5e:	6442                	ld	s0,16(sp)
    80002c60:	64a2                	ld	s1,8(sp)
    80002c62:	6902                	ld	s2,0(sp)
    80002c64:	6105                	addi	sp,sp,32
    80002c66:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002c68:	40bc                	lw	a5,64(s1)
    80002c6a:	dff1                	beqz	a5,80002c46 <iput+0x26>
    80002c6c:	04a49783          	lh	a5,74(s1)
    80002c70:	fbf9                	bnez	a5,80002c46 <iput+0x26>
    acquiresleep(&ip->lock);
    80002c72:	01048913          	addi	s2,s1,16
    80002c76:	854a                	mv	a0,s2
    80002c78:	00001097          	auipc	ra,0x1
    80002c7c:	ab8080e7          	jalr	-1352(ra) # 80003730 <acquiresleep>
    release(&itable.lock);
    80002c80:	00015517          	auipc	a0,0x15
    80002c84:	8f850513          	addi	a0,a0,-1800 # 80017578 <itable>
    80002c88:	00003097          	auipc	ra,0x3
    80002c8c:	48e080e7          	jalr	1166(ra) # 80006116 <release>
    itrunc(ip);
    80002c90:	8526                	mv	a0,s1
    80002c92:	00000097          	auipc	ra,0x0
    80002c96:	ee2080e7          	jalr	-286(ra) # 80002b74 <itrunc>
    ip->type = 0;
    80002c9a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002c9e:	8526                	mv	a0,s1
    80002ca0:	00000097          	auipc	ra,0x0
    80002ca4:	cfc080e7          	jalr	-772(ra) # 8000299c <iupdate>
    ip->valid = 0;
    80002ca8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002cac:	854a                	mv	a0,s2
    80002cae:	00001097          	auipc	ra,0x1
    80002cb2:	ad8080e7          	jalr	-1320(ra) # 80003786 <releasesleep>
    acquire(&itable.lock);
    80002cb6:	00015517          	auipc	a0,0x15
    80002cba:	8c250513          	addi	a0,a0,-1854 # 80017578 <itable>
    80002cbe:	00003097          	auipc	ra,0x3
    80002cc2:	3a4080e7          	jalr	932(ra) # 80006062 <acquire>
    80002cc6:	b741                	j	80002c46 <iput+0x26>

0000000080002cc8 <iunlockput>:
{
    80002cc8:	1101                	addi	sp,sp,-32
    80002cca:	ec06                	sd	ra,24(sp)
    80002ccc:	e822                	sd	s0,16(sp)
    80002cce:	e426                	sd	s1,8(sp)
    80002cd0:	1000                	addi	s0,sp,32
    80002cd2:	84aa                	mv	s1,a0
  iunlock(ip);
    80002cd4:	00000097          	auipc	ra,0x0
    80002cd8:	e54080e7          	jalr	-428(ra) # 80002b28 <iunlock>
  iput(ip);
    80002cdc:	8526                	mv	a0,s1
    80002cde:	00000097          	auipc	ra,0x0
    80002ce2:	f42080e7          	jalr	-190(ra) # 80002c20 <iput>
}
    80002ce6:	60e2                	ld	ra,24(sp)
    80002ce8:	6442                	ld	s0,16(sp)
    80002cea:	64a2                	ld	s1,8(sp)
    80002cec:	6105                	addi	sp,sp,32
    80002cee:	8082                	ret

0000000080002cf0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002cf0:	1141                	addi	sp,sp,-16
    80002cf2:	e422                	sd	s0,8(sp)
    80002cf4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002cf6:	411c                	lw	a5,0(a0)
    80002cf8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002cfa:	415c                	lw	a5,4(a0)
    80002cfc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002cfe:	04451783          	lh	a5,68(a0)
    80002d02:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d06:	04a51783          	lh	a5,74(a0)
    80002d0a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d0e:	04c56783          	lwu	a5,76(a0)
    80002d12:	e99c                	sd	a5,16(a1)
}
    80002d14:	6422                	ld	s0,8(sp)
    80002d16:	0141                	addi	sp,sp,16
    80002d18:	8082                	ret

0000000080002d1a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d1a:	457c                	lw	a5,76(a0)
    80002d1c:	0ed7e963          	bltu	a5,a3,80002e0e <readi+0xf4>
{
    80002d20:	7159                	addi	sp,sp,-112
    80002d22:	f486                	sd	ra,104(sp)
    80002d24:	f0a2                	sd	s0,96(sp)
    80002d26:	eca6                	sd	s1,88(sp)
    80002d28:	e8ca                	sd	s2,80(sp)
    80002d2a:	e4ce                	sd	s3,72(sp)
    80002d2c:	e0d2                	sd	s4,64(sp)
    80002d2e:	fc56                	sd	s5,56(sp)
    80002d30:	f85a                	sd	s6,48(sp)
    80002d32:	f45e                	sd	s7,40(sp)
    80002d34:	f062                	sd	s8,32(sp)
    80002d36:	ec66                	sd	s9,24(sp)
    80002d38:	e86a                	sd	s10,16(sp)
    80002d3a:	e46e                	sd	s11,8(sp)
    80002d3c:	1880                	addi	s0,sp,112
    80002d3e:	8baa                	mv	s7,a0
    80002d40:	8c2e                	mv	s8,a1
    80002d42:	8ab2                	mv	s5,a2
    80002d44:	84b6                	mv	s1,a3
    80002d46:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002d48:	9f35                	addw	a4,a4,a3
    return 0;
    80002d4a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002d4c:	0ad76063          	bltu	a4,a3,80002dec <readi+0xd2>
  if(off + n > ip->size)
    80002d50:	00e7f463          	bgeu	a5,a4,80002d58 <readi+0x3e>
    n = ip->size - off;
    80002d54:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d58:	0a0b0963          	beqz	s6,80002e0a <readi+0xf0>
    80002d5c:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002d5e:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002d62:	5cfd                	li	s9,-1
    80002d64:	a82d                	j	80002d9e <readi+0x84>
    80002d66:	020a1d93          	slli	s11,s4,0x20
    80002d6a:	020ddd93          	srli	s11,s11,0x20
    80002d6e:	05890613          	addi	a2,s2,88
    80002d72:	86ee                	mv	a3,s11
    80002d74:	963a                	add	a2,a2,a4
    80002d76:	85d6                	mv	a1,s5
    80002d78:	8562                	mv	a0,s8
    80002d7a:	fffff097          	auipc	ra,0xfffff
    80002d7e:	b2e080e7          	jalr	-1234(ra) # 800018a8 <either_copyout>
    80002d82:	05950d63          	beq	a0,s9,80002ddc <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002d86:	854a                	mv	a0,s2
    80002d88:	fffff097          	auipc	ra,0xfffff
    80002d8c:	60c080e7          	jalr	1548(ra) # 80002394 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d90:	013a09bb          	addw	s3,s4,s3
    80002d94:	009a04bb          	addw	s1,s4,s1
    80002d98:	9aee                	add	s5,s5,s11
    80002d9a:	0569f763          	bgeu	s3,s6,80002de8 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002d9e:	000ba903          	lw	s2,0(s7)
    80002da2:	00a4d59b          	srliw	a1,s1,0xa
    80002da6:	855e                	mv	a0,s7
    80002da8:	00000097          	auipc	ra,0x0
    80002dac:	8b0080e7          	jalr	-1872(ra) # 80002658 <bmap>
    80002db0:	0005059b          	sext.w	a1,a0
    80002db4:	854a                	mv	a0,s2
    80002db6:	fffff097          	auipc	ra,0xfffff
    80002dba:	4ae080e7          	jalr	1198(ra) # 80002264 <bread>
    80002dbe:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dc0:	3ff4f713          	andi	a4,s1,1023
    80002dc4:	40ed07bb          	subw	a5,s10,a4
    80002dc8:	413b06bb          	subw	a3,s6,s3
    80002dcc:	8a3e                	mv	s4,a5
    80002dce:	2781                	sext.w	a5,a5
    80002dd0:	0006861b          	sext.w	a2,a3
    80002dd4:	f8f679e3          	bgeu	a2,a5,80002d66 <readi+0x4c>
    80002dd8:	8a36                	mv	s4,a3
    80002dda:	b771                	j	80002d66 <readi+0x4c>
      brelse(bp);
    80002ddc:	854a                	mv	a0,s2
    80002dde:	fffff097          	auipc	ra,0xfffff
    80002de2:	5b6080e7          	jalr	1462(ra) # 80002394 <brelse>
      tot = -1;
    80002de6:	59fd                	li	s3,-1
  }
  return tot;
    80002de8:	0009851b          	sext.w	a0,s3
}
    80002dec:	70a6                	ld	ra,104(sp)
    80002dee:	7406                	ld	s0,96(sp)
    80002df0:	64e6                	ld	s1,88(sp)
    80002df2:	6946                	ld	s2,80(sp)
    80002df4:	69a6                	ld	s3,72(sp)
    80002df6:	6a06                	ld	s4,64(sp)
    80002df8:	7ae2                	ld	s5,56(sp)
    80002dfa:	7b42                	ld	s6,48(sp)
    80002dfc:	7ba2                	ld	s7,40(sp)
    80002dfe:	7c02                	ld	s8,32(sp)
    80002e00:	6ce2                	ld	s9,24(sp)
    80002e02:	6d42                	ld	s10,16(sp)
    80002e04:	6da2                	ld	s11,8(sp)
    80002e06:	6165                	addi	sp,sp,112
    80002e08:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e0a:	89da                	mv	s3,s6
    80002e0c:	bff1                	j	80002de8 <readi+0xce>
    return 0;
    80002e0e:	4501                	li	a0,0
}
    80002e10:	8082                	ret

0000000080002e12 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e12:	457c                	lw	a5,76(a0)
    80002e14:	10d7e863          	bltu	a5,a3,80002f24 <writei+0x112>
{
    80002e18:	7159                	addi	sp,sp,-112
    80002e1a:	f486                	sd	ra,104(sp)
    80002e1c:	f0a2                	sd	s0,96(sp)
    80002e1e:	eca6                	sd	s1,88(sp)
    80002e20:	e8ca                	sd	s2,80(sp)
    80002e22:	e4ce                	sd	s3,72(sp)
    80002e24:	e0d2                	sd	s4,64(sp)
    80002e26:	fc56                	sd	s5,56(sp)
    80002e28:	f85a                	sd	s6,48(sp)
    80002e2a:	f45e                	sd	s7,40(sp)
    80002e2c:	f062                	sd	s8,32(sp)
    80002e2e:	ec66                	sd	s9,24(sp)
    80002e30:	e86a                	sd	s10,16(sp)
    80002e32:	e46e                	sd	s11,8(sp)
    80002e34:	1880                	addi	s0,sp,112
    80002e36:	8b2a                	mv	s6,a0
    80002e38:	8c2e                	mv	s8,a1
    80002e3a:	8ab2                	mv	s5,a2
    80002e3c:	8936                	mv	s2,a3
    80002e3e:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002e40:	00e687bb          	addw	a5,a3,a4
    80002e44:	0ed7e263          	bltu	a5,a3,80002f28 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002e48:	00043737          	lui	a4,0x43
    80002e4c:	0ef76063          	bltu	a4,a5,80002f2c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e50:	0c0b8863          	beqz	s7,80002f20 <writei+0x10e>
    80002e54:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e56:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002e5a:	5cfd                	li	s9,-1
    80002e5c:	a091                	j	80002ea0 <writei+0x8e>
    80002e5e:	02099d93          	slli	s11,s3,0x20
    80002e62:	020ddd93          	srli	s11,s11,0x20
    80002e66:	05848513          	addi	a0,s1,88
    80002e6a:	86ee                	mv	a3,s11
    80002e6c:	8656                	mv	a2,s5
    80002e6e:	85e2                	mv	a1,s8
    80002e70:	953a                	add	a0,a0,a4
    80002e72:	fffff097          	auipc	ra,0xfffff
    80002e76:	a8c080e7          	jalr	-1396(ra) # 800018fe <either_copyin>
    80002e7a:	07950263          	beq	a0,s9,80002ede <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002e7e:	8526                	mv	a0,s1
    80002e80:	00000097          	auipc	ra,0x0
    80002e84:	790080e7          	jalr	1936(ra) # 80003610 <log_write>
    brelse(bp);
    80002e88:	8526                	mv	a0,s1
    80002e8a:	fffff097          	auipc	ra,0xfffff
    80002e8e:	50a080e7          	jalr	1290(ra) # 80002394 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e92:	01498a3b          	addw	s4,s3,s4
    80002e96:	0129893b          	addw	s2,s3,s2
    80002e9a:	9aee                	add	s5,s5,s11
    80002e9c:	057a7663          	bgeu	s4,s7,80002ee8 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ea0:	000b2483          	lw	s1,0(s6)
    80002ea4:	00a9559b          	srliw	a1,s2,0xa
    80002ea8:	855a                	mv	a0,s6
    80002eaa:	fffff097          	auipc	ra,0xfffff
    80002eae:	7ae080e7          	jalr	1966(ra) # 80002658 <bmap>
    80002eb2:	0005059b          	sext.w	a1,a0
    80002eb6:	8526                	mv	a0,s1
    80002eb8:	fffff097          	auipc	ra,0xfffff
    80002ebc:	3ac080e7          	jalr	940(ra) # 80002264 <bread>
    80002ec0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ec2:	3ff97713          	andi	a4,s2,1023
    80002ec6:	40ed07bb          	subw	a5,s10,a4
    80002eca:	414b86bb          	subw	a3,s7,s4
    80002ece:	89be                	mv	s3,a5
    80002ed0:	2781                	sext.w	a5,a5
    80002ed2:	0006861b          	sext.w	a2,a3
    80002ed6:	f8f674e3          	bgeu	a2,a5,80002e5e <writei+0x4c>
    80002eda:	89b6                	mv	s3,a3
    80002edc:	b749                	j	80002e5e <writei+0x4c>
      brelse(bp);
    80002ede:	8526                	mv	a0,s1
    80002ee0:	fffff097          	auipc	ra,0xfffff
    80002ee4:	4b4080e7          	jalr	1204(ra) # 80002394 <brelse>
  }

  if(off > ip->size)
    80002ee8:	04cb2783          	lw	a5,76(s6)
    80002eec:	0127f463          	bgeu	a5,s2,80002ef4 <writei+0xe2>
    ip->size = off;
    80002ef0:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002ef4:	855a                	mv	a0,s6
    80002ef6:	00000097          	auipc	ra,0x0
    80002efa:	aa6080e7          	jalr	-1370(ra) # 8000299c <iupdate>

  return tot;
    80002efe:	000a051b          	sext.w	a0,s4
}
    80002f02:	70a6                	ld	ra,104(sp)
    80002f04:	7406                	ld	s0,96(sp)
    80002f06:	64e6                	ld	s1,88(sp)
    80002f08:	6946                	ld	s2,80(sp)
    80002f0a:	69a6                	ld	s3,72(sp)
    80002f0c:	6a06                	ld	s4,64(sp)
    80002f0e:	7ae2                	ld	s5,56(sp)
    80002f10:	7b42                	ld	s6,48(sp)
    80002f12:	7ba2                	ld	s7,40(sp)
    80002f14:	7c02                	ld	s8,32(sp)
    80002f16:	6ce2                	ld	s9,24(sp)
    80002f18:	6d42                	ld	s10,16(sp)
    80002f1a:	6da2                	ld	s11,8(sp)
    80002f1c:	6165                	addi	sp,sp,112
    80002f1e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f20:	8a5e                	mv	s4,s7
    80002f22:	bfc9                	j	80002ef4 <writei+0xe2>
    return -1;
    80002f24:	557d                	li	a0,-1
}
    80002f26:	8082                	ret
    return -1;
    80002f28:	557d                	li	a0,-1
    80002f2a:	bfe1                	j	80002f02 <writei+0xf0>
    return -1;
    80002f2c:	557d                	li	a0,-1
    80002f2e:	bfd1                	j	80002f02 <writei+0xf0>

0000000080002f30 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002f30:	1141                	addi	sp,sp,-16
    80002f32:	e406                	sd	ra,8(sp)
    80002f34:	e022                	sd	s0,0(sp)
    80002f36:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002f38:	4639                	li	a2,14
    80002f3a:	ffffd097          	auipc	ra,0xffffd
    80002f3e:	316080e7          	jalr	790(ra) # 80000250 <strncmp>
}
    80002f42:	60a2                	ld	ra,8(sp)
    80002f44:	6402                	ld	s0,0(sp)
    80002f46:	0141                	addi	sp,sp,16
    80002f48:	8082                	ret

0000000080002f4a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002f4a:	7139                	addi	sp,sp,-64
    80002f4c:	fc06                	sd	ra,56(sp)
    80002f4e:	f822                	sd	s0,48(sp)
    80002f50:	f426                	sd	s1,40(sp)
    80002f52:	f04a                	sd	s2,32(sp)
    80002f54:	ec4e                	sd	s3,24(sp)
    80002f56:	e852                	sd	s4,16(sp)
    80002f58:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002f5a:	04451703          	lh	a4,68(a0)
    80002f5e:	4785                	li	a5,1
    80002f60:	00f71a63          	bne	a4,a5,80002f74 <dirlookup+0x2a>
    80002f64:	892a                	mv	s2,a0
    80002f66:	89ae                	mv	s3,a1
    80002f68:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f6a:	457c                	lw	a5,76(a0)
    80002f6c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002f6e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f70:	e79d                	bnez	a5,80002f9e <dirlookup+0x54>
    80002f72:	a8a5                	j	80002fea <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002f74:	00005517          	auipc	a0,0x5
    80002f78:	5f450513          	addi	a0,a0,1524 # 80008568 <syscalls+0x1a0>
    80002f7c:	00003097          	auipc	ra,0x3
    80002f80:	b9c080e7          	jalr	-1124(ra) # 80005b18 <panic>
      panic("dirlookup read");
    80002f84:	00005517          	auipc	a0,0x5
    80002f88:	5fc50513          	addi	a0,a0,1532 # 80008580 <syscalls+0x1b8>
    80002f8c:	00003097          	auipc	ra,0x3
    80002f90:	b8c080e7          	jalr	-1140(ra) # 80005b18 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f94:	24c1                	addiw	s1,s1,16
    80002f96:	04c92783          	lw	a5,76(s2)
    80002f9a:	04f4f763          	bgeu	s1,a5,80002fe8 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002f9e:	4741                	li	a4,16
    80002fa0:	86a6                	mv	a3,s1
    80002fa2:	fc040613          	addi	a2,s0,-64
    80002fa6:	4581                	li	a1,0
    80002fa8:	854a                	mv	a0,s2
    80002faa:	00000097          	auipc	ra,0x0
    80002fae:	d70080e7          	jalr	-656(ra) # 80002d1a <readi>
    80002fb2:	47c1                	li	a5,16
    80002fb4:	fcf518e3          	bne	a0,a5,80002f84 <dirlookup+0x3a>
    if(de.inum == 0)
    80002fb8:	fc045783          	lhu	a5,-64(s0)
    80002fbc:	dfe1                	beqz	a5,80002f94 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80002fbe:	fc240593          	addi	a1,s0,-62
    80002fc2:	854e                	mv	a0,s3
    80002fc4:	00000097          	auipc	ra,0x0
    80002fc8:	f6c080e7          	jalr	-148(ra) # 80002f30 <namecmp>
    80002fcc:	f561                	bnez	a0,80002f94 <dirlookup+0x4a>
      if(poff)
    80002fce:	000a0463          	beqz	s4,80002fd6 <dirlookup+0x8c>
        *poff = off;
    80002fd2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002fd6:	fc045583          	lhu	a1,-64(s0)
    80002fda:	00092503          	lw	a0,0(s2)
    80002fde:	fffff097          	auipc	ra,0xfffff
    80002fe2:	754080e7          	jalr	1876(ra) # 80002732 <iget>
    80002fe6:	a011                	j	80002fea <dirlookup+0xa0>
  return 0;
    80002fe8:	4501                	li	a0,0
}
    80002fea:	70e2                	ld	ra,56(sp)
    80002fec:	7442                	ld	s0,48(sp)
    80002fee:	74a2                	ld	s1,40(sp)
    80002ff0:	7902                	ld	s2,32(sp)
    80002ff2:	69e2                	ld	s3,24(sp)
    80002ff4:	6a42                	ld	s4,16(sp)
    80002ff6:	6121                	addi	sp,sp,64
    80002ff8:	8082                	ret

0000000080002ffa <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002ffa:	711d                	addi	sp,sp,-96
    80002ffc:	ec86                	sd	ra,88(sp)
    80002ffe:	e8a2                	sd	s0,80(sp)
    80003000:	e4a6                	sd	s1,72(sp)
    80003002:	e0ca                	sd	s2,64(sp)
    80003004:	fc4e                	sd	s3,56(sp)
    80003006:	f852                	sd	s4,48(sp)
    80003008:	f456                	sd	s5,40(sp)
    8000300a:	f05a                	sd	s6,32(sp)
    8000300c:	ec5e                	sd	s7,24(sp)
    8000300e:	e862                	sd	s8,16(sp)
    80003010:	e466                	sd	s9,8(sp)
    80003012:	1080                	addi	s0,sp,96
    80003014:	84aa                	mv	s1,a0
    80003016:	8b2e                	mv	s6,a1
    80003018:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000301a:	00054703          	lbu	a4,0(a0)
    8000301e:	02f00793          	li	a5,47
    80003022:	02f70363          	beq	a4,a5,80003048 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003026:	ffffe097          	auipc	ra,0xffffe
    8000302a:	e22080e7          	jalr	-478(ra) # 80000e48 <myproc>
    8000302e:	15053503          	ld	a0,336(a0)
    80003032:	00000097          	auipc	ra,0x0
    80003036:	9f6080e7          	jalr	-1546(ra) # 80002a28 <idup>
    8000303a:	89aa                	mv	s3,a0
  while(*path == '/')
    8000303c:	02f00913          	li	s2,47
  len = path - s;
    80003040:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003042:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003044:	4c05                	li	s8,1
    80003046:	a865                	j	800030fe <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003048:	4585                	li	a1,1
    8000304a:	4505                	li	a0,1
    8000304c:	fffff097          	auipc	ra,0xfffff
    80003050:	6e6080e7          	jalr	1766(ra) # 80002732 <iget>
    80003054:	89aa                	mv	s3,a0
    80003056:	b7dd                	j	8000303c <namex+0x42>
      iunlockput(ip);
    80003058:	854e                	mv	a0,s3
    8000305a:	00000097          	auipc	ra,0x0
    8000305e:	c6e080e7          	jalr	-914(ra) # 80002cc8 <iunlockput>
      return 0;
    80003062:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003064:	854e                	mv	a0,s3
    80003066:	60e6                	ld	ra,88(sp)
    80003068:	6446                	ld	s0,80(sp)
    8000306a:	64a6                	ld	s1,72(sp)
    8000306c:	6906                	ld	s2,64(sp)
    8000306e:	79e2                	ld	s3,56(sp)
    80003070:	7a42                	ld	s4,48(sp)
    80003072:	7aa2                	ld	s5,40(sp)
    80003074:	7b02                	ld	s6,32(sp)
    80003076:	6be2                	ld	s7,24(sp)
    80003078:	6c42                	ld	s8,16(sp)
    8000307a:	6ca2                	ld	s9,8(sp)
    8000307c:	6125                	addi	sp,sp,96
    8000307e:	8082                	ret
      iunlock(ip);
    80003080:	854e                	mv	a0,s3
    80003082:	00000097          	auipc	ra,0x0
    80003086:	aa6080e7          	jalr	-1370(ra) # 80002b28 <iunlock>
      return ip;
    8000308a:	bfe9                	j	80003064 <namex+0x6a>
      iunlockput(ip);
    8000308c:	854e                	mv	a0,s3
    8000308e:	00000097          	auipc	ra,0x0
    80003092:	c3a080e7          	jalr	-966(ra) # 80002cc8 <iunlockput>
      return 0;
    80003096:	89d2                	mv	s3,s4
    80003098:	b7f1                	j	80003064 <namex+0x6a>
  len = path - s;
    8000309a:	40b48633          	sub	a2,s1,a1
    8000309e:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800030a2:	094cd463          	bge	s9,s4,8000312a <namex+0x130>
    memmove(name, s, DIRSIZ);
    800030a6:	4639                	li	a2,14
    800030a8:	8556                	mv	a0,s5
    800030aa:	ffffd097          	auipc	ra,0xffffd
    800030ae:	12e080e7          	jalr	302(ra) # 800001d8 <memmove>
  while(*path == '/')
    800030b2:	0004c783          	lbu	a5,0(s1)
    800030b6:	01279763          	bne	a5,s2,800030c4 <namex+0xca>
    path++;
    800030ba:	0485                	addi	s1,s1,1
  while(*path == '/')
    800030bc:	0004c783          	lbu	a5,0(s1)
    800030c0:	ff278de3          	beq	a5,s2,800030ba <namex+0xc0>
    ilock(ip);
    800030c4:	854e                	mv	a0,s3
    800030c6:	00000097          	auipc	ra,0x0
    800030ca:	9a0080e7          	jalr	-1632(ra) # 80002a66 <ilock>
    if(ip->type != T_DIR){
    800030ce:	04499783          	lh	a5,68(s3)
    800030d2:	f98793e3          	bne	a5,s8,80003058 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800030d6:	000b0563          	beqz	s6,800030e0 <namex+0xe6>
    800030da:	0004c783          	lbu	a5,0(s1)
    800030de:	d3cd                	beqz	a5,80003080 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800030e0:	865e                	mv	a2,s7
    800030e2:	85d6                	mv	a1,s5
    800030e4:	854e                	mv	a0,s3
    800030e6:	00000097          	auipc	ra,0x0
    800030ea:	e64080e7          	jalr	-412(ra) # 80002f4a <dirlookup>
    800030ee:	8a2a                	mv	s4,a0
    800030f0:	dd51                	beqz	a0,8000308c <namex+0x92>
    iunlockput(ip);
    800030f2:	854e                	mv	a0,s3
    800030f4:	00000097          	auipc	ra,0x0
    800030f8:	bd4080e7          	jalr	-1068(ra) # 80002cc8 <iunlockput>
    ip = next;
    800030fc:	89d2                	mv	s3,s4
  while(*path == '/')
    800030fe:	0004c783          	lbu	a5,0(s1)
    80003102:	05279763          	bne	a5,s2,80003150 <namex+0x156>
    path++;
    80003106:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003108:	0004c783          	lbu	a5,0(s1)
    8000310c:	ff278de3          	beq	a5,s2,80003106 <namex+0x10c>
  if(*path == 0)
    80003110:	c79d                	beqz	a5,8000313e <namex+0x144>
    path++;
    80003112:	85a6                	mv	a1,s1
  len = path - s;
    80003114:	8a5e                	mv	s4,s7
    80003116:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003118:	01278963          	beq	a5,s2,8000312a <namex+0x130>
    8000311c:	dfbd                	beqz	a5,8000309a <namex+0xa0>
    path++;
    8000311e:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003120:	0004c783          	lbu	a5,0(s1)
    80003124:	ff279ce3          	bne	a5,s2,8000311c <namex+0x122>
    80003128:	bf8d                	j	8000309a <namex+0xa0>
    memmove(name, s, len);
    8000312a:	2601                	sext.w	a2,a2
    8000312c:	8556                	mv	a0,s5
    8000312e:	ffffd097          	auipc	ra,0xffffd
    80003132:	0aa080e7          	jalr	170(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003136:	9a56                	add	s4,s4,s5
    80003138:	000a0023          	sb	zero,0(s4)
    8000313c:	bf9d                	j	800030b2 <namex+0xb8>
  if(nameiparent){
    8000313e:	f20b03e3          	beqz	s6,80003064 <namex+0x6a>
    iput(ip);
    80003142:	854e                	mv	a0,s3
    80003144:	00000097          	auipc	ra,0x0
    80003148:	adc080e7          	jalr	-1316(ra) # 80002c20 <iput>
    return 0;
    8000314c:	4981                	li	s3,0
    8000314e:	bf19                	j	80003064 <namex+0x6a>
  if(*path == 0)
    80003150:	d7fd                	beqz	a5,8000313e <namex+0x144>
  while(*path != '/' && *path != 0)
    80003152:	0004c783          	lbu	a5,0(s1)
    80003156:	85a6                	mv	a1,s1
    80003158:	b7d1                	j	8000311c <namex+0x122>

000000008000315a <dirlink>:
{
    8000315a:	7139                	addi	sp,sp,-64
    8000315c:	fc06                	sd	ra,56(sp)
    8000315e:	f822                	sd	s0,48(sp)
    80003160:	f426                	sd	s1,40(sp)
    80003162:	f04a                	sd	s2,32(sp)
    80003164:	ec4e                	sd	s3,24(sp)
    80003166:	e852                	sd	s4,16(sp)
    80003168:	0080                	addi	s0,sp,64
    8000316a:	892a                	mv	s2,a0
    8000316c:	8a2e                	mv	s4,a1
    8000316e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003170:	4601                	li	a2,0
    80003172:	00000097          	auipc	ra,0x0
    80003176:	dd8080e7          	jalr	-552(ra) # 80002f4a <dirlookup>
    8000317a:	e93d                	bnez	a0,800031f0 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000317c:	04c92483          	lw	s1,76(s2)
    80003180:	c49d                	beqz	s1,800031ae <dirlink+0x54>
    80003182:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003184:	4741                	li	a4,16
    80003186:	86a6                	mv	a3,s1
    80003188:	fc040613          	addi	a2,s0,-64
    8000318c:	4581                	li	a1,0
    8000318e:	854a                	mv	a0,s2
    80003190:	00000097          	auipc	ra,0x0
    80003194:	b8a080e7          	jalr	-1142(ra) # 80002d1a <readi>
    80003198:	47c1                	li	a5,16
    8000319a:	06f51163          	bne	a0,a5,800031fc <dirlink+0xa2>
    if(de.inum == 0)
    8000319e:	fc045783          	lhu	a5,-64(s0)
    800031a2:	c791                	beqz	a5,800031ae <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031a4:	24c1                	addiw	s1,s1,16
    800031a6:	04c92783          	lw	a5,76(s2)
    800031aa:	fcf4ede3          	bltu	s1,a5,80003184 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800031ae:	4639                	li	a2,14
    800031b0:	85d2                	mv	a1,s4
    800031b2:	fc240513          	addi	a0,s0,-62
    800031b6:	ffffd097          	auipc	ra,0xffffd
    800031ba:	0d6080e7          	jalr	214(ra) # 8000028c <strncpy>
  de.inum = inum;
    800031be:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031c2:	4741                	li	a4,16
    800031c4:	86a6                	mv	a3,s1
    800031c6:	fc040613          	addi	a2,s0,-64
    800031ca:	4581                	li	a1,0
    800031cc:	854a                	mv	a0,s2
    800031ce:	00000097          	auipc	ra,0x0
    800031d2:	c44080e7          	jalr	-956(ra) # 80002e12 <writei>
    800031d6:	872a                	mv	a4,a0
    800031d8:	47c1                	li	a5,16
  return 0;
    800031da:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031dc:	02f71863          	bne	a4,a5,8000320c <dirlink+0xb2>
}
    800031e0:	70e2                	ld	ra,56(sp)
    800031e2:	7442                	ld	s0,48(sp)
    800031e4:	74a2                	ld	s1,40(sp)
    800031e6:	7902                	ld	s2,32(sp)
    800031e8:	69e2                	ld	s3,24(sp)
    800031ea:	6a42                	ld	s4,16(sp)
    800031ec:	6121                	addi	sp,sp,64
    800031ee:	8082                	ret
    iput(ip);
    800031f0:	00000097          	auipc	ra,0x0
    800031f4:	a30080e7          	jalr	-1488(ra) # 80002c20 <iput>
    return -1;
    800031f8:	557d                	li	a0,-1
    800031fa:	b7dd                	j	800031e0 <dirlink+0x86>
      panic("dirlink read");
    800031fc:	00005517          	auipc	a0,0x5
    80003200:	39450513          	addi	a0,a0,916 # 80008590 <syscalls+0x1c8>
    80003204:	00003097          	auipc	ra,0x3
    80003208:	914080e7          	jalr	-1772(ra) # 80005b18 <panic>
    panic("dirlink");
    8000320c:	00005517          	auipc	a0,0x5
    80003210:	49450513          	addi	a0,a0,1172 # 800086a0 <syscalls+0x2d8>
    80003214:	00003097          	auipc	ra,0x3
    80003218:	904080e7          	jalr	-1788(ra) # 80005b18 <panic>

000000008000321c <namei>:

struct inode*
namei(char *path)
{
    8000321c:	1101                	addi	sp,sp,-32
    8000321e:	ec06                	sd	ra,24(sp)
    80003220:	e822                	sd	s0,16(sp)
    80003222:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003224:	fe040613          	addi	a2,s0,-32
    80003228:	4581                	li	a1,0
    8000322a:	00000097          	auipc	ra,0x0
    8000322e:	dd0080e7          	jalr	-560(ra) # 80002ffa <namex>
}
    80003232:	60e2                	ld	ra,24(sp)
    80003234:	6442                	ld	s0,16(sp)
    80003236:	6105                	addi	sp,sp,32
    80003238:	8082                	ret

000000008000323a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000323a:	1141                	addi	sp,sp,-16
    8000323c:	e406                	sd	ra,8(sp)
    8000323e:	e022                	sd	s0,0(sp)
    80003240:	0800                	addi	s0,sp,16
    80003242:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003244:	4585                	li	a1,1
    80003246:	00000097          	auipc	ra,0x0
    8000324a:	db4080e7          	jalr	-588(ra) # 80002ffa <namex>
}
    8000324e:	60a2                	ld	ra,8(sp)
    80003250:	6402                	ld	s0,0(sp)
    80003252:	0141                	addi	sp,sp,16
    80003254:	8082                	ret

0000000080003256 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003256:	1101                	addi	sp,sp,-32
    80003258:	ec06                	sd	ra,24(sp)
    8000325a:	e822                	sd	s0,16(sp)
    8000325c:	e426                	sd	s1,8(sp)
    8000325e:	e04a                	sd	s2,0(sp)
    80003260:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003262:	00016917          	auipc	s2,0x16
    80003266:	dbe90913          	addi	s2,s2,-578 # 80019020 <log>
    8000326a:	01892583          	lw	a1,24(s2)
    8000326e:	02892503          	lw	a0,40(s2)
    80003272:	fffff097          	auipc	ra,0xfffff
    80003276:	ff2080e7          	jalr	-14(ra) # 80002264 <bread>
    8000327a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000327c:	02c92683          	lw	a3,44(s2)
    80003280:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003282:	02d05763          	blez	a3,800032b0 <write_head+0x5a>
    80003286:	00016797          	auipc	a5,0x16
    8000328a:	dca78793          	addi	a5,a5,-566 # 80019050 <log+0x30>
    8000328e:	05c50713          	addi	a4,a0,92
    80003292:	36fd                	addiw	a3,a3,-1
    80003294:	1682                	slli	a3,a3,0x20
    80003296:	9281                	srli	a3,a3,0x20
    80003298:	068a                	slli	a3,a3,0x2
    8000329a:	00016617          	auipc	a2,0x16
    8000329e:	dba60613          	addi	a2,a2,-582 # 80019054 <log+0x34>
    800032a2:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800032a4:	4390                	lw	a2,0(a5)
    800032a6:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800032a8:	0791                	addi	a5,a5,4
    800032aa:	0711                	addi	a4,a4,4
    800032ac:	fed79ce3          	bne	a5,a3,800032a4 <write_head+0x4e>
  }
  bwrite(buf);
    800032b0:	8526                	mv	a0,s1
    800032b2:	fffff097          	auipc	ra,0xfffff
    800032b6:	0a4080e7          	jalr	164(ra) # 80002356 <bwrite>
  brelse(buf);
    800032ba:	8526                	mv	a0,s1
    800032bc:	fffff097          	auipc	ra,0xfffff
    800032c0:	0d8080e7          	jalr	216(ra) # 80002394 <brelse>
}
    800032c4:	60e2                	ld	ra,24(sp)
    800032c6:	6442                	ld	s0,16(sp)
    800032c8:	64a2                	ld	s1,8(sp)
    800032ca:	6902                	ld	s2,0(sp)
    800032cc:	6105                	addi	sp,sp,32
    800032ce:	8082                	ret

00000000800032d0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800032d0:	00016797          	auipc	a5,0x16
    800032d4:	d7c7a783          	lw	a5,-644(a5) # 8001904c <log+0x2c>
    800032d8:	0af05d63          	blez	a5,80003392 <install_trans+0xc2>
{
    800032dc:	7139                	addi	sp,sp,-64
    800032de:	fc06                	sd	ra,56(sp)
    800032e0:	f822                	sd	s0,48(sp)
    800032e2:	f426                	sd	s1,40(sp)
    800032e4:	f04a                	sd	s2,32(sp)
    800032e6:	ec4e                	sd	s3,24(sp)
    800032e8:	e852                	sd	s4,16(sp)
    800032ea:	e456                	sd	s5,8(sp)
    800032ec:	e05a                	sd	s6,0(sp)
    800032ee:	0080                	addi	s0,sp,64
    800032f0:	8b2a                	mv	s6,a0
    800032f2:	00016a97          	auipc	s5,0x16
    800032f6:	d5ea8a93          	addi	s5,s5,-674 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800032fa:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800032fc:	00016997          	auipc	s3,0x16
    80003300:	d2498993          	addi	s3,s3,-732 # 80019020 <log>
    80003304:	a035                	j	80003330 <install_trans+0x60>
      bunpin(dbuf);
    80003306:	8526                	mv	a0,s1
    80003308:	fffff097          	auipc	ra,0xfffff
    8000330c:	166080e7          	jalr	358(ra) # 8000246e <bunpin>
    brelse(lbuf);
    80003310:	854a                	mv	a0,s2
    80003312:	fffff097          	auipc	ra,0xfffff
    80003316:	082080e7          	jalr	130(ra) # 80002394 <brelse>
    brelse(dbuf);
    8000331a:	8526                	mv	a0,s1
    8000331c:	fffff097          	auipc	ra,0xfffff
    80003320:	078080e7          	jalr	120(ra) # 80002394 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003324:	2a05                	addiw	s4,s4,1
    80003326:	0a91                	addi	s5,s5,4
    80003328:	02c9a783          	lw	a5,44(s3)
    8000332c:	04fa5963          	bge	s4,a5,8000337e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003330:	0189a583          	lw	a1,24(s3)
    80003334:	014585bb          	addw	a1,a1,s4
    80003338:	2585                	addiw	a1,a1,1
    8000333a:	0289a503          	lw	a0,40(s3)
    8000333e:	fffff097          	auipc	ra,0xfffff
    80003342:	f26080e7          	jalr	-218(ra) # 80002264 <bread>
    80003346:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003348:	000aa583          	lw	a1,0(s5)
    8000334c:	0289a503          	lw	a0,40(s3)
    80003350:	fffff097          	auipc	ra,0xfffff
    80003354:	f14080e7          	jalr	-236(ra) # 80002264 <bread>
    80003358:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000335a:	40000613          	li	a2,1024
    8000335e:	05890593          	addi	a1,s2,88
    80003362:	05850513          	addi	a0,a0,88
    80003366:	ffffd097          	auipc	ra,0xffffd
    8000336a:	e72080e7          	jalr	-398(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000336e:	8526                	mv	a0,s1
    80003370:	fffff097          	auipc	ra,0xfffff
    80003374:	fe6080e7          	jalr	-26(ra) # 80002356 <bwrite>
    if(recovering == 0)
    80003378:	f80b1ce3          	bnez	s6,80003310 <install_trans+0x40>
    8000337c:	b769                	j	80003306 <install_trans+0x36>
}
    8000337e:	70e2                	ld	ra,56(sp)
    80003380:	7442                	ld	s0,48(sp)
    80003382:	74a2                	ld	s1,40(sp)
    80003384:	7902                	ld	s2,32(sp)
    80003386:	69e2                	ld	s3,24(sp)
    80003388:	6a42                	ld	s4,16(sp)
    8000338a:	6aa2                	ld	s5,8(sp)
    8000338c:	6b02                	ld	s6,0(sp)
    8000338e:	6121                	addi	sp,sp,64
    80003390:	8082                	ret
    80003392:	8082                	ret

0000000080003394 <initlog>:
{
    80003394:	7179                	addi	sp,sp,-48
    80003396:	f406                	sd	ra,40(sp)
    80003398:	f022                	sd	s0,32(sp)
    8000339a:	ec26                	sd	s1,24(sp)
    8000339c:	e84a                	sd	s2,16(sp)
    8000339e:	e44e                	sd	s3,8(sp)
    800033a0:	1800                	addi	s0,sp,48
    800033a2:	892a                	mv	s2,a0
    800033a4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800033a6:	00016497          	auipc	s1,0x16
    800033aa:	c7a48493          	addi	s1,s1,-902 # 80019020 <log>
    800033ae:	00005597          	auipc	a1,0x5
    800033b2:	1f258593          	addi	a1,a1,498 # 800085a0 <syscalls+0x1d8>
    800033b6:	8526                	mv	a0,s1
    800033b8:	00003097          	auipc	ra,0x3
    800033bc:	c1a080e7          	jalr	-998(ra) # 80005fd2 <initlock>
  log.start = sb->logstart;
    800033c0:	0149a583          	lw	a1,20(s3)
    800033c4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800033c6:	0109a783          	lw	a5,16(s3)
    800033ca:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800033cc:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800033d0:	854a                	mv	a0,s2
    800033d2:	fffff097          	auipc	ra,0xfffff
    800033d6:	e92080e7          	jalr	-366(ra) # 80002264 <bread>
  log.lh.n = lh->n;
    800033da:	4d3c                	lw	a5,88(a0)
    800033dc:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800033de:	02f05563          	blez	a5,80003408 <initlog+0x74>
    800033e2:	05c50713          	addi	a4,a0,92
    800033e6:	00016697          	auipc	a3,0x16
    800033ea:	c6a68693          	addi	a3,a3,-918 # 80019050 <log+0x30>
    800033ee:	37fd                	addiw	a5,a5,-1
    800033f0:	1782                	slli	a5,a5,0x20
    800033f2:	9381                	srli	a5,a5,0x20
    800033f4:	078a                	slli	a5,a5,0x2
    800033f6:	06050613          	addi	a2,a0,96
    800033fa:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800033fc:	4310                	lw	a2,0(a4)
    800033fe:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003400:	0711                	addi	a4,a4,4
    80003402:	0691                	addi	a3,a3,4
    80003404:	fef71ce3          	bne	a4,a5,800033fc <initlog+0x68>
  brelse(buf);
    80003408:	fffff097          	auipc	ra,0xfffff
    8000340c:	f8c080e7          	jalr	-116(ra) # 80002394 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003410:	4505                	li	a0,1
    80003412:	00000097          	auipc	ra,0x0
    80003416:	ebe080e7          	jalr	-322(ra) # 800032d0 <install_trans>
  log.lh.n = 0;
    8000341a:	00016797          	auipc	a5,0x16
    8000341e:	c207a923          	sw	zero,-974(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    80003422:	00000097          	auipc	ra,0x0
    80003426:	e34080e7          	jalr	-460(ra) # 80003256 <write_head>
}
    8000342a:	70a2                	ld	ra,40(sp)
    8000342c:	7402                	ld	s0,32(sp)
    8000342e:	64e2                	ld	s1,24(sp)
    80003430:	6942                	ld	s2,16(sp)
    80003432:	69a2                	ld	s3,8(sp)
    80003434:	6145                	addi	sp,sp,48
    80003436:	8082                	ret

0000000080003438 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003438:	1101                	addi	sp,sp,-32
    8000343a:	ec06                	sd	ra,24(sp)
    8000343c:	e822                	sd	s0,16(sp)
    8000343e:	e426                	sd	s1,8(sp)
    80003440:	e04a                	sd	s2,0(sp)
    80003442:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003444:	00016517          	auipc	a0,0x16
    80003448:	bdc50513          	addi	a0,a0,-1060 # 80019020 <log>
    8000344c:	00003097          	auipc	ra,0x3
    80003450:	c16080e7          	jalr	-1002(ra) # 80006062 <acquire>
  while(1){
    if(log.committing){
    80003454:	00016497          	auipc	s1,0x16
    80003458:	bcc48493          	addi	s1,s1,-1076 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000345c:	4979                	li	s2,30
    8000345e:	a039                	j	8000346c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003460:	85a6                	mv	a1,s1
    80003462:	8526                	mv	a0,s1
    80003464:	ffffe097          	auipc	ra,0xffffe
    80003468:	0a0080e7          	jalr	160(ra) # 80001504 <sleep>
    if(log.committing){
    8000346c:	50dc                	lw	a5,36(s1)
    8000346e:	fbed                	bnez	a5,80003460 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003470:	509c                	lw	a5,32(s1)
    80003472:	0017871b          	addiw	a4,a5,1
    80003476:	0007069b          	sext.w	a3,a4
    8000347a:	0027179b          	slliw	a5,a4,0x2
    8000347e:	9fb9                	addw	a5,a5,a4
    80003480:	0017979b          	slliw	a5,a5,0x1
    80003484:	54d8                	lw	a4,44(s1)
    80003486:	9fb9                	addw	a5,a5,a4
    80003488:	00f95963          	bge	s2,a5,8000349a <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000348c:	85a6                	mv	a1,s1
    8000348e:	8526                	mv	a0,s1
    80003490:	ffffe097          	auipc	ra,0xffffe
    80003494:	074080e7          	jalr	116(ra) # 80001504 <sleep>
    80003498:	bfd1                	j	8000346c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000349a:	00016517          	auipc	a0,0x16
    8000349e:	b8650513          	addi	a0,a0,-1146 # 80019020 <log>
    800034a2:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800034a4:	00003097          	auipc	ra,0x3
    800034a8:	c72080e7          	jalr	-910(ra) # 80006116 <release>
      break;
    }
  }
}
    800034ac:	60e2                	ld	ra,24(sp)
    800034ae:	6442                	ld	s0,16(sp)
    800034b0:	64a2                	ld	s1,8(sp)
    800034b2:	6902                	ld	s2,0(sp)
    800034b4:	6105                	addi	sp,sp,32
    800034b6:	8082                	ret

00000000800034b8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800034b8:	7139                	addi	sp,sp,-64
    800034ba:	fc06                	sd	ra,56(sp)
    800034bc:	f822                	sd	s0,48(sp)
    800034be:	f426                	sd	s1,40(sp)
    800034c0:	f04a                	sd	s2,32(sp)
    800034c2:	ec4e                	sd	s3,24(sp)
    800034c4:	e852                	sd	s4,16(sp)
    800034c6:	e456                	sd	s5,8(sp)
    800034c8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800034ca:	00016497          	auipc	s1,0x16
    800034ce:	b5648493          	addi	s1,s1,-1194 # 80019020 <log>
    800034d2:	8526                	mv	a0,s1
    800034d4:	00003097          	auipc	ra,0x3
    800034d8:	b8e080e7          	jalr	-1138(ra) # 80006062 <acquire>
  log.outstanding -= 1;
    800034dc:	509c                	lw	a5,32(s1)
    800034de:	37fd                	addiw	a5,a5,-1
    800034e0:	0007891b          	sext.w	s2,a5
    800034e4:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800034e6:	50dc                	lw	a5,36(s1)
    800034e8:	efb9                	bnez	a5,80003546 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800034ea:	06091663          	bnez	s2,80003556 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800034ee:	00016497          	auipc	s1,0x16
    800034f2:	b3248493          	addi	s1,s1,-1230 # 80019020 <log>
    800034f6:	4785                	li	a5,1
    800034f8:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800034fa:	8526                	mv	a0,s1
    800034fc:	00003097          	auipc	ra,0x3
    80003500:	c1a080e7          	jalr	-998(ra) # 80006116 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003504:	54dc                	lw	a5,44(s1)
    80003506:	06f04763          	bgtz	a5,80003574 <end_op+0xbc>
    acquire(&log.lock);
    8000350a:	00016497          	auipc	s1,0x16
    8000350e:	b1648493          	addi	s1,s1,-1258 # 80019020 <log>
    80003512:	8526                	mv	a0,s1
    80003514:	00003097          	auipc	ra,0x3
    80003518:	b4e080e7          	jalr	-1202(ra) # 80006062 <acquire>
    log.committing = 0;
    8000351c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003520:	8526                	mv	a0,s1
    80003522:	ffffe097          	auipc	ra,0xffffe
    80003526:	16e080e7          	jalr	366(ra) # 80001690 <wakeup>
    release(&log.lock);
    8000352a:	8526                	mv	a0,s1
    8000352c:	00003097          	auipc	ra,0x3
    80003530:	bea080e7          	jalr	-1046(ra) # 80006116 <release>
}
    80003534:	70e2                	ld	ra,56(sp)
    80003536:	7442                	ld	s0,48(sp)
    80003538:	74a2                	ld	s1,40(sp)
    8000353a:	7902                	ld	s2,32(sp)
    8000353c:	69e2                	ld	s3,24(sp)
    8000353e:	6a42                	ld	s4,16(sp)
    80003540:	6aa2                	ld	s5,8(sp)
    80003542:	6121                	addi	sp,sp,64
    80003544:	8082                	ret
    panic("log.committing");
    80003546:	00005517          	auipc	a0,0x5
    8000354a:	06250513          	addi	a0,a0,98 # 800085a8 <syscalls+0x1e0>
    8000354e:	00002097          	auipc	ra,0x2
    80003552:	5ca080e7          	jalr	1482(ra) # 80005b18 <panic>
    wakeup(&log);
    80003556:	00016497          	auipc	s1,0x16
    8000355a:	aca48493          	addi	s1,s1,-1334 # 80019020 <log>
    8000355e:	8526                	mv	a0,s1
    80003560:	ffffe097          	auipc	ra,0xffffe
    80003564:	130080e7          	jalr	304(ra) # 80001690 <wakeup>
  release(&log.lock);
    80003568:	8526                	mv	a0,s1
    8000356a:	00003097          	auipc	ra,0x3
    8000356e:	bac080e7          	jalr	-1108(ra) # 80006116 <release>
  if(do_commit){
    80003572:	b7c9                	j	80003534 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003574:	00016a97          	auipc	s5,0x16
    80003578:	adca8a93          	addi	s5,s5,-1316 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000357c:	00016a17          	auipc	s4,0x16
    80003580:	aa4a0a13          	addi	s4,s4,-1372 # 80019020 <log>
    80003584:	018a2583          	lw	a1,24(s4)
    80003588:	012585bb          	addw	a1,a1,s2
    8000358c:	2585                	addiw	a1,a1,1
    8000358e:	028a2503          	lw	a0,40(s4)
    80003592:	fffff097          	auipc	ra,0xfffff
    80003596:	cd2080e7          	jalr	-814(ra) # 80002264 <bread>
    8000359a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000359c:	000aa583          	lw	a1,0(s5)
    800035a0:	028a2503          	lw	a0,40(s4)
    800035a4:	fffff097          	auipc	ra,0xfffff
    800035a8:	cc0080e7          	jalr	-832(ra) # 80002264 <bread>
    800035ac:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800035ae:	40000613          	li	a2,1024
    800035b2:	05850593          	addi	a1,a0,88
    800035b6:	05848513          	addi	a0,s1,88
    800035ba:	ffffd097          	auipc	ra,0xffffd
    800035be:	c1e080e7          	jalr	-994(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800035c2:	8526                	mv	a0,s1
    800035c4:	fffff097          	auipc	ra,0xfffff
    800035c8:	d92080e7          	jalr	-622(ra) # 80002356 <bwrite>
    brelse(from);
    800035cc:	854e                	mv	a0,s3
    800035ce:	fffff097          	auipc	ra,0xfffff
    800035d2:	dc6080e7          	jalr	-570(ra) # 80002394 <brelse>
    brelse(to);
    800035d6:	8526                	mv	a0,s1
    800035d8:	fffff097          	auipc	ra,0xfffff
    800035dc:	dbc080e7          	jalr	-580(ra) # 80002394 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035e0:	2905                	addiw	s2,s2,1
    800035e2:	0a91                	addi	s5,s5,4
    800035e4:	02ca2783          	lw	a5,44(s4)
    800035e8:	f8f94ee3          	blt	s2,a5,80003584 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800035ec:	00000097          	auipc	ra,0x0
    800035f0:	c6a080e7          	jalr	-918(ra) # 80003256 <write_head>
    install_trans(0); // Now install writes to home locations
    800035f4:	4501                	li	a0,0
    800035f6:	00000097          	auipc	ra,0x0
    800035fa:	cda080e7          	jalr	-806(ra) # 800032d0 <install_trans>
    log.lh.n = 0;
    800035fe:	00016797          	auipc	a5,0x16
    80003602:	a407a723          	sw	zero,-1458(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003606:	00000097          	auipc	ra,0x0
    8000360a:	c50080e7          	jalr	-944(ra) # 80003256 <write_head>
    8000360e:	bdf5                	j	8000350a <end_op+0x52>

0000000080003610 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003610:	1101                	addi	sp,sp,-32
    80003612:	ec06                	sd	ra,24(sp)
    80003614:	e822                	sd	s0,16(sp)
    80003616:	e426                	sd	s1,8(sp)
    80003618:	e04a                	sd	s2,0(sp)
    8000361a:	1000                	addi	s0,sp,32
    8000361c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000361e:	00016917          	auipc	s2,0x16
    80003622:	a0290913          	addi	s2,s2,-1534 # 80019020 <log>
    80003626:	854a                	mv	a0,s2
    80003628:	00003097          	auipc	ra,0x3
    8000362c:	a3a080e7          	jalr	-1478(ra) # 80006062 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003630:	02c92603          	lw	a2,44(s2)
    80003634:	47f5                	li	a5,29
    80003636:	06c7c563          	blt	a5,a2,800036a0 <log_write+0x90>
    8000363a:	00016797          	auipc	a5,0x16
    8000363e:	a027a783          	lw	a5,-1534(a5) # 8001903c <log+0x1c>
    80003642:	37fd                	addiw	a5,a5,-1
    80003644:	04f65e63          	bge	a2,a5,800036a0 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003648:	00016797          	auipc	a5,0x16
    8000364c:	9f87a783          	lw	a5,-1544(a5) # 80019040 <log+0x20>
    80003650:	06f05063          	blez	a5,800036b0 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003654:	4781                	li	a5,0
    80003656:	06c05563          	blez	a2,800036c0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000365a:	44cc                	lw	a1,12(s1)
    8000365c:	00016717          	auipc	a4,0x16
    80003660:	9f470713          	addi	a4,a4,-1548 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003664:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003666:	4314                	lw	a3,0(a4)
    80003668:	04b68c63          	beq	a3,a1,800036c0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000366c:	2785                	addiw	a5,a5,1
    8000366e:	0711                	addi	a4,a4,4
    80003670:	fef61be3          	bne	a2,a5,80003666 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003674:	0621                	addi	a2,a2,8
    80003676:	060a                	slli	a2,a2,0x2
    80003678:	00016797          	auipc	a5,0x16
    8000367c:	9a878793          	addi	a5,a5,-1624 # 80019020 <log>
    80003680:	963e                	add	a2,a2,a5
    80003682:	44dc                	lw	a5,12(s1)
    80003684:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003686:	8526                	mv	a0,s1
    80003688:	fffff097          	auipc	ra,0xfffff
    8000368c:	daa080e7          	jalr	-598(ra) # 80002432 <bpin>
    log.lh.n++;
    80003690:	00016717          	auipc	a4,0x16
    80003694:	99070713          	addi	a4,a4,-1648 # 80019020 <log>
    80003698:	575c                	lw	a5,44(a4)
    8000369a:	2785                	addiw	a5,a5,1
    8000369c:	d75c                	sw	a5,44(a4)
    8000369e:	a835                	j	800036da <log_write+0xca>
    panic("too big a transaction");
    800036a0:	00005517          	auipc	a0,0x5
    800036a4:	f1850513          	addi	a0,a0,-232 # 800085b8 <syscalls+0x1f0>
    800036a8:	00002097          	auipc	ra,0x2
    800036ac:	470080e7          	jalr	1136(ra) # 80005b18 <panic>
    panic("log_write outside of trans");
    800036b0:	00005517          	auipc	a0,0x5
    800036b4:	f2050513          	addi	a0,a0,-224 # 800085d0 <syscalls+0x208>
    800036b8:	00002097          	auipc	ra,0x2
    800036bc:	460080e7          	jalr	1120(ra) # 80005b18 <panic>
  log.lh.block[i] = b->blockno;
    800036c0:	00878713          	addi	a4,a5,8
    800036c4:	00271693          	slli	a3,a4,0x2
    800036c8:	00016717          	auipc	a4,0x16
    800036cc:	95870713          	addi	a4,a4,-1704 # 80019020 <log>
    800036d0:	9736                	add	a4,a4,a3
    800036d2:	44d4                	lw	a3,12(s1)
    800036d4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800036d6:	faf608e3          	beq	a2,a5,80003686 <log_write+0x76>
  }
  release(&log.lock);
    800036da:	00016517          	auipc	a0,0x16
    800036de:	94650513          	addi	a0,a0,-1722 # 80019020 <log>
    800036e2:	00003097          	auipc	ra,0x3
    800036e6:	a34080e7          	jalr	-1484(ra) # 80006116 <release>
}
    800036ea:	60e2                	ld	ra,24(sp)
    800036ec:	6442                	ld	s0,16(sp)
    800036ee:	64a2                	ld	s1,8(sp)
    800036f0:	6902                	ld	s2,0(sp)
    800036f2:	6105                	addi	sp,sp,32
    800036f4:	8082                	ret

00000000800036f6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800036f6:	1101                	addi	sp,sp,-32
    800036f8:	ec06                	sd	ra,24(sp)
    800036fa:	e822                	sd	s0,16(sp)
    800036fc:	e426                	sd	s1,8(sp)
    800036fe:	e04a                	sd	s2,0(sp)
    80003700:	1000                	addi	s0,sp,32
    80003702:	84aa                	mv	s1,a0
    80003704:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003706:	00005597          	auipc	a1,0x5
    8000370a:	eea58593          	addi	a1,a1,-278 # 800085f0 <syscalls+0x228>
    8000370e:	0521                	addi	a0,a0,8
    80003710:	00003097          	auipc	ra,0x3
    80003714:	8c2080e7          	jalr	-1854(ra) # 80005fd2 <initlock>
  lk->name = name;
    80003718:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000371c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003720:	0204a423          	sw	zero,40(s1)
}
    80003724:	60e2                	ld	ra,24(sp)
    80003726:	6442                	ld	s0,16(sp)
    80003728:	64a2                	ld	s1,8(sp)
    8000372a:	6902                	ld	s2,0(sp)
    8000372c:	6105                	addi	sp,sp,32
    8000372e:	8082                	ret

0000000080003730 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003730:	1101                	addi	sp,sp,-32
    80003732:	ec06                	sd	ra,24(sp)
    80003734:	e822                	sd	s0,16(sp)
    80003736:	e426                	sd	s1,8(sp)
    80003738:	e04a                	sd	s2,0(sp)
    8000373a:	1000                	addi	s0,sp,32
    8000373c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000373e:	00850913          	addi	s2,a0,8
    80003742:	854a                	mv	a0,s2
    80003744:	00003097          	auipc	ra,0x3
    80003748:	91e080e7          	jalr	-1762(ra) # 80006062 <acquire>
  while (lk->locked) {
    8000374c:	409c                	lw	a5,0(s1)
    8000374e:	cb89                	beqz	a5,80003760 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003750:	85ca                	mv	a1,s2
    80003752:	8526                	mv	a0,s1
    80003754:	ffffe097          	auipc	ra,0xffffe
    80003758:	db0080e7          	jalr	-592(ra) # 80001504 <sleep>
  while (lk->locked) {
    8000375c:	409c                	lw	a5,0(s1)
    8000375e:	fbed                	bnez	a5,80003750 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003760:	4785                	li	a5,1
    80003762:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003764:	ffffd097          	auipc	ra,0xffffd
    80003768:	6e4080e7          	jalr	1764(ra) # 80000e48 <myproc>
    8000376c:	591c                	lw	a5,48(a0)
    8000376e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003770:	854a                	mv	a0,s2
    80003772:	00003097          	auipc	ra,0x3
    80003776:	9a4080e7          	jalr	-1628(ra) # 80006116 <release>
}
    8000377a:	60e2                	ld	ra,24(sp)
    8000377c:	6442                	ld	s0,16(sp)
    8000377e:	64a2                	ld	s1,8(sp)
    80003780:	6902                	ld	s2,0(sp)
    80003782:	6105                	addi	sp,sp,32
    80003784:	8082                	ret

0000000080003786 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003786:	1101                	addi	sp,sp,-32
    80003788:	ec06                	sd	ra,24(sp)
    8000378a:	e822                	sd	s0,16(sp)
    8000378c:	e426                	sd	s1,8(sp)
    8000378e:	e04a                	sd	s2,0(sp)
    80003790:	1000                	addi	s0,sp,32
    80003792:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003794:	00850913          	addi	s2,a0,8
    80003798:	854a                	mv	a0,s2
    8000379a:	00003097          	auipc	ra,0x3
    8000379e:	8c8080e7          	jalr	-1848(ra) # 80006062 <acquire>
  lk->locked = 0;
    800037a2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037a6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800037aa:	8526                	mv	a0,s1
    800037ac:	ffffe097          	auipc	ra,0xffffe
    800037b0:	ee4080e7          	jalr	-284(ra) # 80001690 <wakeup>
  release(&lk->lk);
    800037b4:	854a                	mv	a0,s2
    800037b6:	00003097          	auipc	ra,0x3
    800037ba:	960080e7          	jalr	-1696(ra) # 80006116 <release>
}
    800037be:	60e2                	ld	ra,24(sp)
    800037c0:	6442                	ld	s0,16(sp)
    800037c2:	64a2                	ld	s1,8(sp)
    800037c4:	6902                	ld	s2,0(sp)
    800037c6:	6105                	addi	sp,sp,32
    800037c8:	8082                	ret

00000000800037ca <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800037ca:	7179                	addi	sp,sp,-48
    800037cc:	f406                	sd	ra,40(sp)
    800037ce:	f022                	sd	s0,32(sp)
    800037d0:	ec26                	sd	s1,24(sp)
    800037d2:	e84a                	sd	s2,16(sp)
    800037d4:	e44e                	sd	s3,8(sp)
    800037d6:	1800                	addi	s0,sp,48
    800037d8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800037da:	00850913          	addi	s2,a0,8
    800037de:	854a                	mv	a0,s2
    800037e0:	00003097          	auipc	ra,0x3
    800037e4:	882080e7          	jalr	-1918(ra) # 80006062 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800037e8:	409c                	lw	a5,0(s1)
    800037ea:	ef99                	bnez	a5,80003808 <holdingsleep+0x3e>
    800037ec:	4481                	li	s1,0
  release(&lk->lk);
    800037ee:	854a                	mv	a0,s2
    800037f0:	00003097          	auipc	ra,0x3
    800037f4:	926080e7          	jalr	-1754(ra) # 80006116 <release>
  return r;
}
    800037f8:	8526                	mv	a0,s1
    800037fa:	70a2                	ld	ra,40(sp)
    800037fc:	7402                	ld	s0,32(sp)
    800037fe:	64e2                	ld	s1,24(sp)
    80003800:	6942                	ld	s2,16(sp)
    80003802:	69a2                	ld	s3,8(sp)
    80003804:	6145                	addi	sp,sp,48
    80003806:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003808:	0284a983          	lw	s3,40(s1)
    8000380c:	ffffd097          	auipc	ra,0xffffd
    80003810:	63c080e7          	jalr	1596(ra) # 80000e48 <myproc>
    80003814:	5904                	lw	s1,48(a0)
    80003816:	413484b3          	sub	s1,s1,s3
    8000381a:	0014b493          	seqz	s1,s1
    8000381e:	bfc1                	j	800037ee <holdingsleep+0x24>

0000000080003820 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003820:	1141                	addi	sp,sp,-16
    80003822:	e406                	sd	ra,8(sp)
    80003824:	e022                	sd	s0,0(sp)
    80003826:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003828:	00005597          	auipc	a1,0x5
    8000382c:	dd858593          	addi	a1,a1,-552 # 80008600 <syscalls+0x238>
    80003830:	00016517          	auipc	a0,0x16
    80003834:	93850513          	addi	a0,a0,-1736 # 80019168 <ftable>
    80003838:	00002097          	auipc	ra,0x2
    8000383c:	79a080e7          	jalr	1946(ra) # 80005fd2 <initlock>
}
    80003840:	60a2                	ld	ra,8(sp)
    80003842:	6402                	ld	s0,0(sp)
    80003844:	0141                	addi	sp,sp,16
    80003846:	8082                	ret

0000000080003848 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003848:	1101                	addi	sp,sp,-32
    8000384a:	ec06                	sd	ra,24(sp)
    8000384c:	e822                	sd	s0,16(sp)
    8000384e:	e426                	sd	s1,8(sp)
    80003850:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003852:	00016517          	auipc	a0,0x16
    80003856:	91650513          	addi	a0,a0,-1770 # 80019168 <ftable>
    8000385a:	00003097          	auipc	ra,0x3
    8000385e:	808080e7          	jalr	-2040(ra) # 80006062 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003862:	00016497          	auipc	s1,0x16
    80003866:	91e48493          	addi	s1,s1,-1762 # 80019180 <ftable+0x18>
    8000386a:	00017717          	auipc	a4,0x17
    8000386e:	8b670713          	addi	a4,a4,-1866 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    80003872:	40dc                	lw	a5,4(s1)
    80003874:	cf99                	beqz	a5,80003892 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003876:	02848493          	addi	s1,s1,40
    8000387a:	fee49ce3          	bne	s1,a4,80003872 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000387e:	00016517          	auipc	a0,0x16
    80003882:	8ea50513          	addi	a0,a0,-1814 # 80019168 <ftable>
    80003886:	00003097          	auipc	ra,0x3
    8000388a:	890080e7          	jalr	-1904(ra) # 80006116 <release>
  return 0;
    8000388e:	4481                	li	s1,0
    80003890:	a819                	j	800038a6 <filealloc+0x5e>
      f->ref = 1;
    80003892:	4785                	li	a5,1
    80003894:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003896:	00016517          	auipc	a0,0x16
    8000389a:	8d250513          	addi	a0,a0,-1838 # 80019168 <ftable>
    8000389e:	00003097          	auipc	ra,0x3
    800038a2:	878080e7          	jalr	-1928(ra) # 80006116 <release>
}
    800038a6:	8526                	mv	a0,s1
    800038a8:	60e2                	ld	ra,24(sp)
    800038aa:	6442                	ld	s0,16(sp)
    800038ac:	64a2                	ld	s1,8(sp)
    800038ae:	6105                	addi	sp,sp,32
    800038b0:	8082                	ret

00000000800038b2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800038b2:	1101                	addi	sp,sp,-32
    800038b4:	ec06                	sd	ra,24(sp)
    800038b6:	e822                	sd	s0,16(sp)
    800038b8:	e426                	sd	s1,8(sp)
    800038ba:	1000                	addi	s0,sp,32
    800038bc:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800038be:	00016517          	auipc	a0,0x16
    800038c2:	8aa50513          	addi	a0,a0,-1878 # 80019168 <ftable>
    800038c6:	00002097          	auipc	ra,0x2
    800038ca:	79c080e7          	jalr	1948(ra) # 80006062 <acquire>
  if(f->ref < 1)
    800038ce:	40dc                	lw	a5,4(s1)
    800038d0:	02f05263          	blez	a5,800038f4 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800038d4:	2785                	addiw	a5,a5,1
    800038d6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800038d8:	00016517          	auipc	a0,0x16
    800038dc:	89050513          	addi	a0,a0,-1904 # 80019168 <ftable>
    800038e0:	00003097          	auipc	ra,0x3
    800038e4:	836080e7          	jalr	-1994(ra) # 80006116 <release>
  return f;
}
    800038e8:	8526                	mv	a0,s1
    800038ea:	60e2                	ld	ra,24(sp)
    800038ec:	6442                	ld	s0,16(sp)
    800038ee:	64a2                	ld	s1,8(sp)
    800038f0:	6105                	addi	sp,sp,32
    800038f2:	8082                	ret
    panic("filedup");
    800038f4:	00005517          	auipc	a0,0x5
    800038f8:	d1450513          	addi	a0,a0,-748 # 80008608 <syscalls+0x240>
    800038fc:	00002097          	auipc	ra,0x2
    80003900:	21c080e7          	jalr	540(ra) # 80005b18 <panic>

0000000080003904 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003904:	7139                	addi	sp,sp,-64
    80003906:	fc06                	sd	ra,56(sp)
    80003908:	f822                	sd	s0,48(sp)
    8000390a:	f426                	sd	s1,40(sp)
    8000390c:	f04a                	sd	s2,32(sp)
    8000390e:	ec4e                	sd	s3,24(sp)
    80003910:	e852                	sd	s4,16(sp)
    80003912:	e456                	sd	s5,8(sp)
    80003914:	0080                	addi	s0,sp,64
    80003916:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003918:	00016517          	auipc	a0,0x16
    8000391c:	85050513          	addi	a0,a0,-1968 # 80019168 <ftable>
    80003920:	00002097          	auipc	ra,0x2
    80003924:	742080e7          	jalr	1858(ra) # 80006062 <acquire>
  if(f->ref < 1)
    80003928:	40dc                	lw	a5,4(s1)
    8000392a:	06f05163          	blez	a5,8000398c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000392e:	37fd                	addiw	a5,a5,-1
    80003930:	0007871b          	sext.w	a4,a5
    80003934:	c0dc                	sw	a5,4(s1)
    80003936:	06e04363          	bgtz	a4,8000399c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000393a:	0004a903          	lw	s2,0(s1)
    8000393e:	0094ca83          	lbu	s5,9(s1)
    80003942:	0104ba03          	ld	s4,16(s1)
    80003946:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000394a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000394e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003952:	00016517          	auipc	a0,0x16
    80003956:	81650513          	addi	a0,a0,-2026 # 80019168 <ftable>
    8000395a:	00002097          	auipc	ra,0x2
    8000395e:	7bc080e7          	jalr	1980(ra) # 80006116 <release>

  if(ff.type == FD_PIPE){
    80003962:	4785                	li	a5,1
    80003964:	04f90d63          	beq	s2,a5,800039be <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003968:	3979                	addiw	s2,s2,-2
    8000396a:	4785                	li	a5,1
    8000396c:	0527e063          	bltu	a5,s2,800039ac <fileclose+0xa8>
    begin_op();
    80003970:	00000097          	auipc	ra,0x0
    80003974:	ac8080e7          	jalr	-1336(ra) # 80003438 <begin_op>
    iput(ff.ip);
    80003978:	854e                	mv	a0,s3
    8000397a:	fffff097          	auipc	ra,0xfffff
    8000397e:	2a6080e7          	jalr	678(ra) # 80002c20 <iput>
    end_op();
    80003982:	00000097          	auipc	ra,0x0
    80003986:	b36080e7          	jalr	-1226(ra) # 800034b8 <end_op>
    8000398a:	a00d                	j	800039ac <fileclose+0xa8>
    panic("fileclose");
    8000398c:	00005517          	auipc	a0,0x5
    80003990:	c8450513          	addi	a0,a0,-892 # 80008610 <syscalls+0x248>
    80003994:	00002097          	auipc	ra,0x2
    80003998:	184080e7          	jalr	388(ra) # 80005b18 <panic>
    release(&ftable.lock);
    8000399c:	00015517          	auipc	a0,0x15
    800039a0:	7cc50513          	addi	a0,a0,1996 # 80019168 <ftable>
    800039a4:	00002097          	auipc	ra,0x2
    800039a8:	772080e7          	jalr	1906(ra) # 80006116 <release>
  }
}
    800039ac:	70e2                	ld	ra,56(sp)
    800039ae:	7442                	ld	s0,48(sp)
    800039b0:	74a2                	ld	s1,40(sp)
    800039b2:	7902                	ld	s2,32(sp)
    800039b4:	69e2                	ld	s3,24(sp)
    800039b6:	6a42                	ld	s4,16(sp)
    800039b8:	6aa2                	ld	s5,8(sp)
    800039ba:	6121                	addi	sp,sp,64
    800039bc:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800039be:	85d6                	mv	a1,s5
    800039c0:	8552                	mv	a0,s4
    800039c2:	00000097          	auipc	ra,0x0
    800039c6:	34c080e7          	jalr	844(ra) # 80003d0e <pipeclose>
    800039ca:	b7cd                	j	800039ac <fileclose+0xa8>

00000000800039cc <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800039cc:	715d                	addi	sp,sp,-80
    800039ce:	e486                	sd	ra,72(sp)
    800039d0:	e0a2                	sd	s0,64(sp)
    800039d2:	fc26                	sd	s1,56(sp)
    800039d4:	f84a                	sd	s2,48(sp)
    800039d6:	f44e                	sd	s3,40(sp)
    800039d8:	0880                	addi	s0,sp,80
    800039da:	84aa                	mv	s1,a0
    800039dc:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800039de:	ffffd097          	auipc	ra,0xffffd
    800039e2:	46a080e7          	jalr	1130(ra) # 80000e48 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800039e6:	409c                	lw	a5,0(s1)
    800039e8:	37f9                	addiw	a5,a5,-2
    800039ea:	4705                	li	a4,1
    800039ec:	04f76763          	bltu	a4,a5,80003a3a <filestat+0x6e>
    800039f0:	892a                	mv	s2,a0
    ilock(f->ip);
    800039f2:	6c88                	ld	a0,24(s1)
    800039f4:	fffff097          	auipc	ra,0xfffff
    800039f8:	072080e7          	jalr	114(ra) # 80002a66 <ilock>
    stati(f->ip, &st);
    800039fc:	fb840593          	addi	a1,s0,-72
    80003a00:	6c88                	ld	a0,24(s1)
    80003a02:	fffff097          	auipc	ra,0xfffff
    80003a06:	2ee080e7          	jalr	750(ra) # 80002cf0 <stati>
    iunlock(f->ip);
    80003a0a:	6c88                	ld	a0,24(s1)
    80003a0c:	fffff097          	auipc	ra,0xfffff
    80003a10:	11c080e7          	jalr	284(ra) # 80002b28 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a14:	46e1                	li	a3,24
    80003a16:	fb840613          	addi	a2,s0,-72
    80003a1a:	85ce                	mv	a1,s3
    80003a1c:	05093503          	ld	a0,80(s2)
    80003a20:	ffffd097          	auipc	ra,0xffffd
    80003a24:	0ea080e7          	jalr	234(ra) # 80000b0a <copyout>
    80003a28:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003a2c:	60a6                	ld	ra,72(sp)
    80003a2e:	6406                	ld	s0,64(sp)
    80003a30:	74e2                	ld	s1,56(sp)
    80003a32:	7942                	ld	s2,48(sp)
    80003a34:	79a2                	ld	s3,40(sp)
    80003a36:	6161                	addi	sp,sp,80
    80003a38:	8082                	ret
  return -1;
    80003a3a:	557d                	li	a0,-1
    80003a3c:	bfc5                	j	80003a2c <filestat+0x60>

0000000080003a3e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003a3e:	7179                	addi	sp,sp,-48
    80003a40:	f406                	sd	ra,40(sp)
    80003a42:	f022                	sd	s0,32(sp)
    80003a44:	ec26                	sd	s1,24(sp)
    80003a46:	e84a                	sd	s2,16(sp)
    80003a48:	e44e                	sd	s3,8(sp)
    80003a4a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003a4c:	00854783          	lbu	a5,8(a0)
    80003a50:	c3d5                	beqz	a5,80003af4 <fileread+0xb6>
    80003a52:	84aa                	mv	s1,a0
    80003a54:	89ae                	mv	s3,a1
    80003a56:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003a58:	411c                	lw	a5,0(a0)
    80003a5a:	4705                	li	a4,1
    80003a5c:	04e78963          	beq	a5,a4,80003aae <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003a60:	470d                	li	a4,3
    80003a62:	04e78d63          	beq	a5,a4,80003abc <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003a66:	4709                	li	a4,2
    80003a68:	06e79e63          	bne	a5,a4,80003ae4 <fileread+0xa6>
    ilock(f->ip);
    80003a6c:	6d08                	ld	a0,24(a0)
    80003a6e:	fffff097          	auipc	ra,0xfffff
    80003a72:	ff8080e7          	jalr	-8(ra) # 80002a66 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003a76:	874a                	mv	a4,s2
    80003a78:	5094                	lw	a3,32(s1)
    80003a7a:	864e                	mv	a2,s3
    80003a7c:	4585                	li	a1,1
    80003a7e:	6c88                	ld	a0,24(s1)
    80003a80:	fffff097          	auipc	ra,0xfffff
    80003a84:	29a080e7          	jalr	666(ra) # 80002d1a <readi>
    80003a88:	892a                	mv	s2,a0
    80003a8a:	00a05563          	blez	a0,80003a94 <fileread+0x56>
      f->off += r;
    80003a8e:	509c                	lw	a5,32(s1)
    80003a90:	9fa9                	addw	a5,a5,a0
    80003a92:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003a94:	6c88                	ld	a0,24(s1)
    80003a96:	fffff097          	auipc	ra,0xfffff
    80003a9a:	092080e7          	jalr	146(ra) # 80002b28 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003a9e:	854a                	mv	a0,s2
    80003aa0:	70a2                	ld	ra,40(sp)
    80003aa2:	7402                	ld	s0,32(sp)
    80003aa4:	64e2                	ld	s1,24(sp)
    80003aa6:	6942                	ld	s2,16(sp)
    80003aa8:	69a2                	ld	s3,8(sp)
    80003aaa:	6145                	addi	sp,sp,48
    80003aac:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003aae:	6908                	ld	a0,16(a0)
    80003ab0:	00000097          	auipc	ra,0x0
    80003ab4:	3c8080e7          	jalr	968(ra) # 80003e78 <piperead>
    80003ab8:	892a                	mv	s2,a0
    80003aba:	b7d5                	j	80003a9e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003abc:	02451783          	lh	a5,36(a0)
    80003ac0:	03079693          	slli	a3,a5,0x30
    80003ac4:	92c1                	srli	a3,a3,0x30
    80003ac6:	4725                	li	a4,9
    80003ac8:	02d76863          	bltu	a4,a3,80003af8 <fileread+0xba>
    80003acc:	0792                	slli	a5,a5,0x4
    80003ace:	00015717          	auipc	a4,0x15
    80003ad2:	5fa70713          	addi	a4,a4,1530 # 800190c8 <devsw>
    80003ad6:	97ba                	add	a5,a5,a4
    80003ad8:	639c                	ld	a5,0(a5)
    80003ada:	c38d                	beqz	a5,80003afc <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003adc:	4505                	li	a0,1
    80003ade:	9782                	jalr	a5
    80003ae0:	892a                	mv	s2,a0
    80003ae2:	bf75                	j	80003a9e <fileread+0x60>
    panic("fileread");
    80003ae4:	00005517          	auipc	a0,0x5
    80003ae8:	b3c50513          	addi	a0,a0,-1220 # 80008620 <syscalls+0x258>
    80003aec:	00002097          	auipc	ra,0x2
    80003af0:	02c080e7          	jalr	44(ra) # 80005b18 <panic>
    return -1;
    80003af4:	597d                	li	s2,-1
    80003af6:	b765                	j	80003a9e <fileread+0x60>
      return -1;
    80003af8:	597d                	li	s2,-1
    80003afa:	b755                	j	80003a9e <fileread+0x60>
    80003afc:	597d                	li	s2,-1
    80003afe:	b745                	j	80003a9e <fileread+0x60>

0000000080003b00 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003b00:	715d                	addi	sp,sp,-80
    80003b02:	e486                	sd	ra,72(sp)
    80003b04:	e0a2                	sd	s0,64(sp)
    80003b06:	fc26                	sd	s1,56(sp)
    80003b08:	f84a                	sd	s2,48(sp)
    80003b0a:	f44e                	sd	s3,40(sp)
    80003b0c:	f052                	sd	s4,32(sp)
    80003b0e:	ec56                	sd	s5,24(sp)
    80003b10:	e85a                	sd	s6,16(sp)
    80003b12:	e45e                	sd	s7,8(sp)
    80003b14:	e062                	sd	s8,0(sp)
    80003b16:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003b18:	00954783          	lbu	a5,9(a0)
    80003b1c:	10078663          	beqz	a5,80003c28 <filewrite+0x128>
    80003b20:	892a                	mv	s2,a0
    80003b22:	8aae                	mv	s5,a1
    80003b24:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b26:	411c                	lw	a5,0(a0)
    80003b28:	4705                	li	a4,1
    80003b2a:	02e78263          	beq	a5,a4,80003b4e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b2e:	470d                	li	a4,3
    80003b30:	02e78663          	beq	a5,a4,80003b5c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b34:	4709                	li	a4,2
    80003b36:	0ee79163          	bne	a5,a4,80003c18 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003b3a:	0ac05d63          	blez	a2,80003bf4 <filewrite+0xf4>
    int i = 0;
    80003b3e:	4981                	li	s3,0
    80003b40:	6b05                	lui	s6,0x1
    80003b42:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003b46:	6b85                	lui	s7,0x1
    80003b48:	c00b8b9b          	addiw	s7,s7,-1024
    80003b4c:	a861                	j	80003be4 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003b4e:	6908                	ld	a0,16(a0)
    80003b50:	00000097          	auipc	ra,0x0
    80003b54:	22e080e7          	jalr	558(ra) # 80003d7e <pipewrite>
    80003b58:	8a2a                	mv	s4,a0
    80003b5a:	a045                	j	80003bfa <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003b5c:	02451783          	lh	a5,36(a0)
    80003b60:	03079693          	slli	a3,a5,0x30
    80003b64:	92c1                	srli	a3,a3,0x30
    80003b66:	4725                	li	a4,9
    80003b68:	0cd76263          	bltu	a4,a3,80003c2c <filewrite+0x12c>
    80003b6c:	0792                	slli	a5,a5,0x4
    80003b6e:	00015717          	auipc	a4,0x15
    80003b72:	55a70713          	addi	a4,a4,1370 # 800190c8 <devsw>
    80003b76:	97ba                	add	a5,a5,a4
    80003b78:	679c                	ld	a5,8(a5)
    80003b7a:	cbdd                	beqz	a5,80003c30 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003b7c:	4505                	li	a0,1
    80003b7e:	9782                	jalr	a5
    80003b80:	8a2a                	mv	s4,a0
    80003b82:	a8a5                	j	80003bfa <filewrite+0xfa>
    80003b84:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003b88:	00000097          	auipc	ra,0x0
    80003b8c:	8b0080e7          	jalr	-1872(ra) # 80003438 <begin_op>
      ilock(f->ip);
    80003b90:	01893503          	ld	a0,24(s2)
    80003b94:	fffff097          	auipc	ra,0xfffff
    80003b98:	ed2080e7          	jalr	-302(ra) # 80002a66 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003b9c:	8762                	mv	a4,s8
    80003b9e:	02092683          	lw	a3,32(s2)
    80003ba2:	01598633          	add	a2,s3,s5
    80003ba6:	4585                	li	a1,1
    80003ba8:	01893503          	ld	a0,24(s2)
    80003bac:	fffff097          	auipc	ra,0xfffff
    80003bb0:	266080e7          	jalr	614(ra) # 80002e12 <writei>
    80003bb4:	84aa                	mv	s1,a0
    80003bb6:	00a05763          	blez	a0,80003bc4 <filewrite+0xc4>
        f->off += r;
    80003bba:	02092783          	lw	a5,32(s2)
    80003bbe:	9fa9                	addw	a5,a5,a0
    80003bc0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003bc4:	01893503          	ld	a0,24(s2)
    80003bc8:	fffff097          	auipc	ra,0xfffff
    80003bcc:	f60080e7          	jalr	-160(ra) # 80002b28 <iunlock>
      end_op();
    80003bd0:	00000097          	auipc	ra,0x0
    80003bd4:	8e8080e7          	jalr	-1816(ra) # 800034b8 <end_op>

      if(r != n1){
    80003bd8:	009c1f63          	bne	s8,s1,80003bf6 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003bdc:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003be0:	0149db63          	bge	s3,s4,80003bf6 <filewrite+0xf6>
      int n1 = n - i;
    80003be4:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003be8:	84be                	mv	s1,a5
    80003bea:	2781                	sext.w	a5,a5
    80003bec:	f8fb5ce3          	bge	s6,a5,80003b84 <filewrite+0x84>
    80003bf0:	84de                	mv	s1,s7
    80003bf2:	bf49                	j	80003b84 <filewrite+0x84>
    int i = 0;
    80003bf4:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003bf6:	013a1f63          	bne	s4,s3,80003c14 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003bfa:	8552                	mv	a0,s4
    80003bfc:	60a6                	ld	ra,72(sp)
    80003bfe:	6406                	ld	s0,64(sp)
    80003c00:	74e2                	ld	s1,56(sp)
    80003c02:	7942                	ld	s2,48(sp)
    80003c04:	79a2                	ld	s3,40(sp)
    80003c06:	7a02                	ld	s4,32(sp)
    80003c08:	6ae2                	ld	s5,24(sp)
    80003c0a:	6b42                	ld	s6,16(sp)
    80003c0c:	6ba2                	ld	s7,8(sp)
    80003c0e:	6c02                	ld	s8,0(sp)
    80003c10:	6161                	addi	sp,sp,80
    80003c12:	8082                	ret
    ret = (i == n ? n : -1);
    80003c14:	5a7d                	li	s4,-1
    80003c16:	b7d5                	j	80003bfa <filewrite+0xfa>
    panic("filewrite");
    80003c18:	00005517          	auipc	a0,0x5
    80003c1c:	a1850513          	addi	a0,a0,-1512 # 80008630 <syscalls+0x268>
    80003c20:	00002097          	auipc	ra,0x2
    80003c24:	ef8080e7          	jalr	-264(ra) # 80005b18 <panic>
    return -1;
    80003c28:	5a7d                	li	s4,-1
    80003c2a:	bfc1                	j	80003bfa <filewrite+0xfa>
      return -1;
    80003c2c:	5a7d                	li	s4,-1
    80003c2e:	b7f1                	j	80003bfa <filewrite+0xfa>
    80003c30:	5a7d                	li	s4,-1
    80003c32:	b7e1                	j	80003bfa <filewrite+0xfa>

0000000080003c34 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003c34:	7179                	addi	sp,sp,-48
    80003c36:	f406                	sd	ra,40(sp)
    80003c38:	f022                	sd	s0,32(sp)
    80003c3a:	ec26                	sd	s1,24(sp)
    80003c3c:	e84a                	sd	s2,16(sp)
    80003c3e:	e44e                	sd	s3,8(sp)
    80003c40:	e052                	sd	s4,0(sp)
    80003c42:	1800                	addi	s0,sp,48
    80003c44:	84aa                	mv	s1,a0
    80003c46:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003c48:	0005b023          	sd	zero,0(a1)
    80003c4c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003c50:	00000097          	auipc	ra,0x0
    80003c54:	bf8080e7          	jalr	-1032(ra) # 80003848 <filealloc>
    80003c58:	e088                	sd	a0,0(s1)
    80003c5a:	c551                	beqz	a0,80003ce6 <pipealloc+0xb2>
    80003c5c:	00000097          	auipc	ra,0x0
    80003c60:	bec080e7          	jalr	-1044(ra) # 80003848 <filealloc>
    80003c64:	00aa3023          	sd	a0,0(s4)
    80003c68:	c92d                	beqz	a0,80003cda <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003c6a:	ffffc097          	auipc	ra,0xffffc
    80003c6e:	4ae080e7          	jalr	1198(ra) # 80000118 <kalloc>
    80003c72:	892a                	mv	s2,a0
    80003c74:	c125                	beqz	a0,80003cd4 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003c76:	4985                	li	s3,1
    80003c78:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003c7c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003c80:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003c84:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003c88:	00005597          	auipc	a1,0x5
    80003c8c:	9b858593          	addi	a1,a1,-1608 # 80008640 <syscalls+0x278>
    80003c90:	00002097          	auipc	ra,0x2
    80003c94:	342080e7          	jalr	834(ra) # 80005fd2 <initlock>
  (*f0)->type = FD_PIPE;
    80003c98:	609c                	ld	a5,0(s1)
    80003c9a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003c9e:	609c                	ld	a5,0(s1)
    80003ca0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ca4:	609c                	ld	a5,0(s1)
    80003ca6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003caa:	609c                	ld	a5,0(s1)
    80003cac:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003cb0:	000a3783          	ld	a5,0(s4)
    80003cb4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003cb8:	000a3783          	ld	a5,0(s4)
    80003cbc:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003cc0:	000a3783          	ld	a5,0(s4)
    80003cc4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003cc8:	000a3783          	ld	a5,0(s4)
    80003ccc:	0127b823          	sd	s2,16(a5)
  return 0;
    80003cd0:	4501                	li	a0,0
    80003cd2:	a025                	j	80003cfa <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003cd4:	6088                	ld	a0,0(s1)
    80003cd6:	e501                	bnez	a0,80003cde <pipealloc+0xaa>
    80003cd8:	a039                	j	80003ce6 <pipealloc+0xb2>
    80003cda:	6088                	ld	a0,0(s1)
    80003cdc:	c51d                	beqz	a0,80003d0a <pipealloc+0xd6>
    fileclose(*f0);
    80003cde:	00000097          	auipc	ra,0x0
    80003ce2:	c26080e7          	jalr	-986(ra) # 80003904 <fileclose>
  if(*f1)
    80003ce6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003cea:	557d                	li	a0,-1
  if(*f1)
    80003cec:	c799                	beqz	a5,80003cfa <pipealloc+0xc6>
    fileclose(*f1);
    80003cee:	853e                	mv	a0,a5
    80003cf0:	00000097          	auipc	ra,0x0
    80003cf4:	c14080e7          	jalr	-1004(ra) # 80003904 <fileclose>
  return -1;
    80003cf8:	557d                	li	a0,-1
}
    80003cfa:	70a2                	ld	ra,40(sp)
    80003cfc:	7402                	ld	s0,32(sp)
    80003cfe:	64e2                	ld	s1,24(sp)
    80003d00:	6942                	ld	s2,16(sp)
    80003d02:	69a2                	ld	s3,8(sp)
    80003d04:	6a02                	ld	s4,0(sp)
    80003d06:	6145                	addi	sp,sp,48
    80003d08:	8082                	ret
  return -1;
    80003d0a:	557d                	li	a0,-1
    80003d0c:	b7fd                	j	80003cfa <pipealloc+0xc6>

0000000080003d0e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003d0e:	1101                	addi	sp,sp,-32
    80003d10:	ec06                	sd	ra,24(sp)
    80003d12:	e822                	sd	s0,16(sp)
    80003d14:	e426                	sd	s1,8(sp)
    80003d16:	e04a                	sd	s2,0(sp)
    80003d18:	1000                	addi	s0,sp,32
    80003d1a:	84aa                	mv	s1,a0
    80003d1c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003d1e:	00002097          	auipc	ra,0x2
    80003d22:	344080e7          	jalr	836(ra) # 80006062 <acquire>
  if(writable){
    80003d26:	02090d63          	beqz	s2,80003d60 <pipeclose+0x52>
    pi->writeopen = 0;
    80003d2a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003d2e:	21848513          	addi	a0,s1,536
    80003d32:	ffffe097          	auipc	ra,0xffffe
    80003d36:	95e080e7          	jalr	-1698(ra) # 80001690 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003d3a:	2204b783          	ld	a5,544(s1)
    80003d3e:	eb95                	bnez	a5,80003d72 <pipeclose+0x64>
    release(&pi->lock);
    80003d40:	8526                	mv	a0,s1
    80003d42:	00002097          	auipc	ra,0x2
    80003d46:	3d4080e7          	jalr	980(ra) # 80006116 <release>
    kfree((char*)pi);
    80003d4a:	8526                	mv	a0,s1
    80003d4c:	ffffc097          	auipc	ra,0xffffc
    80003d50:	2d0080e7          	jalr	720(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003d54:	60e2                	ld	ra,24(sp)
    80003d56:	6442                	ld	s0,16(sp)
    80003d58:	64a2                	ld	s1,8(sp)
    80003d5a:	6902                	ld	s2,0(sp)
    80003d5c:	6105                	addi	sp,sp,32
    80003d5e:	8082                	ret
    pi->readopen = 0;
    80003d60:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003d64:	21c48513          	addi	a0,s1,540
    80003d68:	ffffe097          	auipc	ra,0xffffe
    80003d6c:	928080e7          	jalr	-1752(ra) # 80001690 <wakeup>
    80003d70:	b7e9                	j	80003d3a <pipeclose+0x2c>
    release(&pi->lock);
    80003d72:	8526                	mv	a0,s1
    80003d74:	00002097          	auipc	ra,0x2
    80003d78:	3a2080e7          	jalr	930(ra) # 80006116 <release>
}
    80003d7c:	bfe1                	j	80003d54 <pipeclose+0x46>

0000000080003d7e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003d7e:	7159                	addi	sp,sp,-112
    80003d80:	f486                	sd	ra,104(sp)
    80003d82:	f0a2                	sd	s0,96(sp)
    80003d84:	eca6                	sd	s1,88(sp)
    80003d86:	e8ca                	sd	s2,80(sp)
    80003d88:	e4ce                	sd	s3,72(sp)
    80003d8a:	e0d2                	sd	s4,64(sp)
    80003d8c:	fc56                	sd	s5,56(sp)
    80003d8e:	f85a                	sd	s6,48(sp)
    80003d90:	f45e                	sd	s7,40(sp)
    80003d92:	f062                	sd	s8,32(sp)
    80003d94:	ec66                	sd	s9,24(sp)
    80003d96:	1880                	addi	s0,sp,112
    80003d98:	84aa                	mv	s1,a0
    80003d9a:	8aae                	mv	s5,a1
    80003d9c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003d9e:	ffffd097          	auipc	ra,0xffffd
    80003da2:	0aa080e7          	jalr	170(ra) # 80000e48 <myproc>
    80003da6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003da8:	8526                	mv	a0,s1
    80003daa:	00002097          	auipc	ra,0x2
    80003dae:	2b8080e7          	jalr	696(ra) # 80006062 <acquire>
  while(i < n){
    80003db2:	0d405163          	blez	s4,80003e74 <pipewrite+0xf6>
    80003db6:	8ba6                	mv	s7,s1
  int i = 0;
    80003db8:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003dba:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003dbc:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003dc0:	21c48c13          	addi	s8,s1,540
    80003dc4:	a08d                	j	80003e26 <pipewrite+0xa8>
      release(&pi->lock);
    80003dc6:	8526                	mv	a0,s1
    80003dc8:	00002097          	auipc	ra,0x2
    80003dcc:	34e080e7          	jalr	846(ra) # 80006116 <release>
      return -1;
    80003dd0:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003dd2:	854a                	mv	a0,s2
    80003dd4:	70a6                	ld	ra,104(sp)
    80003dd6:	7406                	ld	s0,96(sp)
    80003dd8:	64e6                	ld	s1,88(sp)
    80003dda:	6946                	ld	s2,80(sp)
    80003ddc:	69a6                	ld	s3,72(sp)
    80003dde:	6a06                	ld	s4,64(sp)
    80003de0:	7ae2                	ld	s5,56(sp)
    80003de2:	7b42                	ld	s6,48(sp)
    80003de4:	7ba2                	ld	s7,40(sp)
    80003de6:	7c02                	ld	s8,32(sp)
    80003de8:	6ce2                	ld	s9,24(sp)
    80003dea:	6165                	addi	sp,sp,112
    80003dec:	8082                	ret
      wakeup(&pi->nread);
    80003dee:	8566                	mv	a0,s9
    80003df0:	ffffe097          	auipc	ra,0xffffe
    80003df4:	8a0080e7          	jalr	-1888(ra) # 80001690 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003df8:	85de                	mv	a1,s7
    80003dfa:	8562                	mv	a0,s8
    80003dfc:	ffffd097          	auipc	ra,0xffffd
    80003e00:	708080e7          	jalr	1800(ra) # 80001504 <sleep>
    80003e04:	a839                	j	80003e22 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003e06:	21c4a783          	lw	a5,540(s1)
    80003e0a:	0017871b          	addiw	a4,a5,1
    80003e0e:	20e4ae23          	sw	a4,540(s1)
    80003e12:	1ff7f793          	andi	a5,a5,511
    80003e16:	97a6                	add	a5,a5,s1
    80003e18:	f9f44703          	lbu	a4,-97(s0)
    80003e1c:	00e78c23          	sb	a4,24(a5)
      i++;
    80003e20:	2905                	addiw	s2,s2,1
  while(i < n){
    80003e22:	03495d63          	bge	s2,s4,80003e5c <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003e26:	2204a783          	lw	a5,544(s1)
    80003e2a:	dfd1                	beqz	a5,80003dc6 <pipewrite+0x48>
    80003e2c:	0289a783          	lw	a5,40(s3)
    80003e30:	fbd9                	bnez	a5,80003dc6 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003e32:	2184a783          	lw	a5,536(s1)
    80003e36:	21c4a703          	lw	a4,540(s1)
    80003e3a:	2007879b          	addiw	a5,a5,512
    80003e3e:	faf708e3          	beq	a4,a5,80003dee <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e42:	4685                	li	a3,1
    80003e44:	01590633          	add	a2,s2,s5
    80003e48:	f9f40593          	addi	a1,s0,-97
    80003e4c:	0509b503          	ld	a0,80(s3)
    80003e50:	ffffd097          	auipc	ra,0xffffd
    80003e54:	d46080e7          	jalr	-698(ra) # 80000b96 <copyin>
    80003e58:	fb6517e3          	bne	a0,s6,80003e06 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003e5c:	21848513          	addi	a0,s1,536
    80003e60:	ffffe097          	auipc	ra,0xffffe
    80003e64:	830080e7          	jalr	-2000(ra) # 80001690 <wakeup>
  release(&pi->lock);
    80003e68:	8526                	mv	a0,s1
    80003e6a:	00002097          	auipc	ra,0x2
    80003e6e:	2ac080e7          	jalr	684(ra) # 80006116 <release>
  return i;
    80003e72:	b785                	j	80003dd2 <pipewrite+0x54>
  int i = 0;
    80003e74:	4901                	li	s2,0
    80003e76:	b7dd                	j	80003e5c <pipewrite+0xde>

0000000080003e78 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003e78:	715d                	addi	sp,sp,-80
    80003e7a:	e486                	sd	ra,72(sp)
    80003e7c:	e0a2                	sd	s0,64(sp)
    80003e7e:	fc26                	sd	s1,56(sp)
    80003e80:	f84a                	sd	s2,48(sp)
    80003e82:	f44e                	sd	s3,40(sp)
    80003e84:	f052                	sd	s4,32(sp)
    80003e86:	ec56                	sd	s5,24(sp)
    80003e88:	e85a                	sd	s6,16(sp)
    80003e8a:	0880                	addi	s0,sp,80
    80003e8c:	84aa                	mv	s1,a0
    80003e8e:	892e                	mv	s2,a1
    80003e90:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003e92:	ffffd097          	auipc	ra,0xffffd
    80003e96:	fb6080e7          	jalr	-74(ra) # 80000e48 <myproc>
    80003e9a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003e9c:	8b26                	mv	s6,s1
    80003e9e:	8526                	mv	a0,s1
    80003ea0:	00002097          	auipc	ra,0x2
    80003ea4:	1c2080e7          	jalr	450(ra) # 80006062 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ea8:	2184a703          	lw	a4,536(s1)
    80003eac:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003eb0:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003eb4:	02f71463          	bne	a4,a5,80003edc <piperead+0x64>
    80003eb8:	2244a783          	lw	a5,548(s1)
    80003ebc:	c385                	beqz	a5,80003edc <piperead+0x64>
    if(pr->killed){
    80003ebe:	028a2783          	lw	a5,40(s4)
    80003ec2:	ebc1                	bnez	a5,80003f52 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ec4:	85da                	mv	a1,s6
    80003ec6:	854e                	mv	a0,s3
    80003ec8:	ffffd097          	auipc	ra,0xffffd
    80003ecc:	63c080e7          	jalr	1596(ra) # 80001504 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ed0:	2184a703          	lw	a4,536(s1)
    80003ed4:	21c4a783          	lw	a5,540(s1)
    80003ed8:	fef700e3          	beq	a4,a5,80003eb8 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003edc:	09505263          	blez	s5,80003f60 <piperead+0xe8>
    80003ee0:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003ee2:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80003ee4:	2184a783          	lw	a5,536(s1)
    80003ee8:	21c4a703          	lw	a4,540(s1)
    80003eec:	02f70d63          	beq	a4,a5,80003f26 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003ef0:	0017871b          	addiw	a4,a5,1
    80003ef4:	20e4ac23          	sw	a4,536(s1)
    80003ef8:	1ff7f793          	andi	a5,a5,511
    80003efc:	97a6                	add	a5,a5,s1
    80003efe:	0187c783          	lbu	a5,24(a5)
    80003f02:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f06:	4685                	li	a3,1
    80003f08:	fbf40613          	addi	a2,s0,-65
    80003f0c:	85ca                	mv	a1,s2
    80003f0e:	050a3503          	ld	a0,80(s4)
    80003f12:	ffffd097          	auipc	ra,0xffffd
    80003f16:	bf8080e7          	jalr	-1032(ra) # 80000b0a <copyout>
    80003f1a:	01650663          	beq	a0,s6,80003f26 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f1e:	2985                	addiw	s3,s3,1
    80003f20:	0905                	addi	s2,s2,1
    80003f22:	fd3a91e3          	bne	s5,s3,80003ee4 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003f26:	21c48513          	addi	a0,s1,540
    80003f2a:	ffffd097          	auipc	ra,0xffffd
    80003f2e:	766080e7          	jalr	1894(ra) # 80001690 <wakeup>
  release(&pi->lock);
    80003f32:	8526                	mv	a0,s1
    80003f34:	00002097          	auipc	ra,0x2
    80003f38:	1e2080e7          	jalr	482(ra) # 80006116 <release>
  return i;
}
    80003f3c:	854e                	mv	a0,s3
    80003f3e:	60a6                	ld	ra,72(sp)
    80003f40:	6406                	ld	s0,64(sp)
    80003f42:	74e2                	ld	s1,56(sp)
    80003f44:	7942                	ld	s2,48(sp)
    80003f46:	79a2                	ld	s3,40(sp)
    80003f48:	7a02                	ld	s4,32(sp)
    80003f4a:	6ae2                	ld	s5,24(sp)
    80003f4c:	6b42                	ld	s6,16(sp)
    80003f4e:	6161                	addi	sp,sp,80
    80003f50:	8082                	ret
      release(&pi->lock);
    80003f52:	8526                	mv	a0,s1
    80003f54:	00002097          	auipc	ra,0x2
    80003f58:	1c2080e7          	jalr	450(ra) # 80006116 <release>
      return -1;
    80003f5c:	59fd                	li	s3,-1
    80003f5e:	bff9                	j	80003f3c <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f60:	4981                	li	s3,0
    80003f62:	b7d1                	j	80003f26 <piperead+0xae>

0000000080003f64 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80003f64:	df010113          	addi	sp,sp,-528
    80003f68:	20113423          	sd	ra,520(sp)
    80003f6c:	20813023          	sd	s0,512(sp)
    80003f70:	ffa6                	sd	s1,504(sp)
    80003f72:	fbca                	sd	s2,496(sp)
    80003f74:	f7ce                	sd	s3,488(sp)
    80003f76:	f3d2                	sd	s4,480(sp)
    80003f78:	efd6                	sd	s5,472(sp)
    80003f7a:	ebda                	sd	s6,464(sp)
    80003f7c:	e7de                	sd	s7,456(sp)
    80003f7e:	e3e2                	sd	s8,448(sp)
    80003f80:	ff66                	sd	s9,440(sp)
    80003f82:	fb6a                	sd	s10,432(sp)
    80003f84:	f76e                	sd	s11,424(sp)
    80003f86:	0c00                	addi	s0,sp,528
    80003f88:	84aa                	mv	s1,a0
    80003f8a:	dea43c23          	sd	a0,-520(s0)
    80003f8e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003f92:	ffffd097          	auipc	ra,0xffffd
    80003f96:	eb6080e7          	jalr	-330(ra) # 80000e48 <myproc>
    80003f9a:	892a                	mv	s2,a0

  begin_op();
    80003f9c:	fffff097          	auipc	ra,0xfffff
    80003fa0:	49c080e7          	jalr	1180(ra) # 80003438 <begin_op>

  if((ip = namei(path)) == 0){
    80003fa4:	8526                	mv	a0,s1
    80003fa6:	fffff097          	auipc	ra,0xfffff
    80003faa:	276080e7          	jalr	630(ra) # 8000321c <namei>
    80003fae:	c92d                	beqz	a0,80004020 <exec+0xbc>
    80003fb0:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003fb2:	fffff097          	auipc	ra,0xfffff
    80003fb6:	ab4080e7          	jalr	-1356(ra) # 80002a66 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003fba:	04000713          	li	a4,64
    80003fbe:	4681                	li	a3,0
    80003fc0:	e5040613          	addi	a2,s0,-432
    80003fc4:	4581                	li	a1,0
    80003fc6:	8526                	mv	a0,s1
    80003fc8:	fffff097          	auipc	ra,0xfffff
    80003fcc:	d52080e7          	jalr	-686(ra) # 80002d1a <readi>
    80003fd0:	04000793          	li	a5,64
    80003fd4:	00f51a63          	bne	a0,a5,80003fe8 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80003fd8:	e5042703          	lw	a4,-432(s0)
    80003fdc:	464c47b7          	lui	a5,0x464c4
    80003fe0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003fe4:	04f70463          	beq	a4,a5,8000402c <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003fe8:	8526                	mv	a0,s1
    80003fea:	fffff097          	auipc	ra,0xfffff
    80003fee:	cde080e7          	jalr	-802(ra) # 80002cc8 <iunlockput>
    end_op();
    80003ff2:	fffff097          	auipc	ra,0xfffff
    80003ff6:	4c6080e7          	jalr	1222(ra) # 800034b8 <end_op>
  }
  return -1;
    80003ffa:	557d                	li	a0,-1
}
    80003ffc:	20813083          	ld	ra,520(sp)
    80004000:	20013403          	ld	s0,512(sp)
    80004004:	74fe                	ld	s1,504(sp)
    80004006:	795e                	ld	s2,496(sp)
    80004008:	79be                	ld	s3,488(sp)
    8000400a:	7a1e                	ld	s4,480(sp)
    8000400c:	6afe                	ld	s5,472(sp)
    8000400e:	6b5e                	ld	s6,464(sp)
    80004010:	6bbe                	ld	s7,456(sp)
    80004012:	6c1e                	ld	s8,448(sp)
    80004014:	7cfa                	ld	s9,440(sp)
    80004016:	7d5a                	ld	s10,432(sp)
    80004018:	7dba                	ld	s11,424(sp)
    8000401a:	21010113          	addi	sp,sp,528
    8000401e:	8082                	ret
    end_op();
    80004020:	fffff097          	auipc	ra,0xfffff
    80004024:	498080e7          	jalr	1176(ra) # 800034b8 <end_op>
    return -1;
    80004028:	557d                	li	a0,-1
    8000402a:	bfc9                	j	80003ffc <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000402c:	854a                	mv	a0,s2
    8000402e:	ffffd097          	auipc	ra,0xffffd
    80004032:	ede080e7          	jalr	-290(ra) # 80000f0c <proc_pagetable>
    80004036:	8baa                	mv	s7,a0
    80004038:	d945                	beqz	a0,80003fe8 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000403a:	e7042983          	lw	s3,-400(s0)
    8000403e:	e8845783          	lhu	a5,-376(s0)
    80004042:	c7ad                	beqz	a5,800040ac <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004044:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004046:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004048:	6c85                	lui	s9,0x1
    8000404a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000404e:	def43823          	sd	a5,-528(s0)
    80004052:	a42d                	j	8000427c <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004054:	00004517          	auipc	a0,0x4
    80004058:	5f450513          	addi	a0,a0,1524 # 80008648 <syscalls+0x280>
    8000405c:	00002097          	auipc	ra,0x2
    80004060:	abc080e7          	jalr	-1348(ra) # 80005b18 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004064:	8756                	mv	a4,s5
    80004066:	012d86bb          	addw	a3,s11,s2
    8000406a:	4581                	li	a1,0
    8000406c:	8526                	mv	a0,s1
    8000406e:	fffff097          	auipc	ra,0xfffff
    80004072:	cac080e7          	jalr	-852(ra) # 80002d1a <readi>
    80004076:	2501                	sext.w	a0,a0
    80004078:	1aaa9963          	bne	s5,a0,8000422a <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    8000407c:	6785                	lui	a5,0x1
    8000407e:	0127893b          	addw	s2,a5,s2
    80004082:	77fd                	lui	a5,0xfffff
    80004084:	01478a3b          	addw	s4,a5,s4
    80004088:	1f897163          	bgeu	s2,s8,8000426a <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    8000408c:	02091593          	slli	a1,s2,0x20
    80004090:	9181                	srli	a1,a1,0x20
    80004092:	95ea                	add	a1,a1,s10
    80004094:	855e                	mv	a0,s7
    80004096:	ffffc097          	auipc	ra,0xffffc
    8000409a:	470080e7          	jalr	1136(ra) # 80000506 <walkaddr>
    8000409e:	862a                	mv	a2,a0
    if(pa == 0)
    800040a0:	d955                	beqz	a0,80004054 <exec+0xf0>
      n = PGSIZE;
    800040a2:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800040a4:	fd9a70e3          	bgeu	s4,s9,80004064 <exec+0x100>
      n = sz - i;
    800040a8:	8ad2                	mv	s5,s4
    800040aa:	bf6d                	j	80004064 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040ac:	4901                	li	s2,0
  iunlockput(ip);
    800040ae:	8526                	mv	a0,s1
    800040b0:	fffff097          	auipc	ra,0xfffff
    800040b4:	c18080e7          	jalr	-1000(ra) # 80002cc8 <iunlockput>
  end_op();
    800040b8:	fffff097          	auipc	ra,0xfffff
    800040bc:	400080e7          	jalr	1024(ra) # 800034b8 <end_op>
  p = myproc();
    800040c0:	ffffd097          	auipc	ra,0xffffd
    800040c4:	d88080e7          	jalr	-632(ra) # 80000e48 <myproc>
    800040c8:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800040ca:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800040ce:	6785                	lui	a5,0x1
    800040d0:	17fd                	addi	a5,a5,-1
    800040d2:	993e                	add	s2,s2,a5
    800040d4:	757d                	lui	a0,0xfffff
    800040d6:	00a977b3          	and	a5,s2,a0
    800040da:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800040de:	6609                	lui	a2,0x2
    800040e0:	963e                	add	a2,a2,a5
    800040e2:	85be                	mv	a1,a5
    800040e4:	855e                	mv	a0,s7
    800040e6:	ffffc097          	auipc	ra,0xffffc
    800040ea:	7d4080e7          	jalr	2004(ra) # 800008ba <uvmalloc>
    800040ee:	8b2a                	mv	s6,a0
  ip = 0;
    800040f0:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800040f2:	12050c63          	beqz	a0,8000422a <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800040f6:	75f9                	lui	a1,0xffffe
    800040f8:	95aa                	add	a1,a1,a0
    800040fa:	855e                	mv	a0,s7
    800040fc:	ffffd097          	auipc	ra,0xffffd
    80004100:	9dc080e7          	jalr	-1572(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    80004104:	7c7d                	lui	s8,0xfffff
    80004106:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004108:	e0043783          	ld	a5,-512(s0)
    8000410c:	6388                	ld	a0,0(a5)
    8000410e:	c535                	beqz	a0,8000417a <exec+0x216>
    80004110:	e9040993          	addi	s3,s0,-368
    80004114:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004118:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000411a:	ffffc097          	auipc	ra,0xffffc
    8000411e:	1e2080e7          	jalr	482(ra) # 800002fc <strlen>
    80004122:	2505                	addiw	a0,a0,1
    80004124:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004128:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000412c:	13896363          	bltu	s2,s8,80004252 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004130:	e0043d83          	ld	s11,-512(s0)
    80004134:	000dba03          	ld	s4,0(s11)
    80004138:	8552                	mv	a0,s4
    8000413a:	ffffc097          	auipc	ra,0xffffc
    8000413e:	1c2080e7          	jalr	450(ra) # 800002fc <strlen>
    80004142:	0015069b          	addiw	a3,a0,1
    80004146:	8652                	mv	a2,s4
    80004148:	85ca                	mv	a1,s2
    8000414a:	855e                	mv	a0,s7
    8000414c:	ffffd097          	auipc	ra,0xffffd
    80004150:	9be080e7          	jalr	-1602(ra) # 80000b0a <copyout>
    80004154:	10054363          	bltz	a0,8000425a <exec+0x2f6>
    ustack[argc] = sp;
    80004158:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000415c:	0485                	addi	s1,s1,1
    8000415e:	008d8793          	addi	a5,s11,8
    80004162:	e0f43023          	sd	a5,-512(s0)
    80004166:	008db503          	ld	a0,8(s11)
    8000416a:	c911                	beqz	a0,8000417e <exec+0x21a>
    if(argc >= MAXARG)
    8000416c:	09a1                	addi	s3,s3,8
    8000416e:	fb3c96e3          	bne	s9,s3,8000411a <exec+0x1b6>
  sz = sz1;
    80004172:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004176:	4481                	li	s1,0
    80004178:	a84d                	j	8000422a <exec+0x2c6>
  sp = sz;
    8000417a:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000417c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000417e:	00349793          	slli	a5,s1,0x3
    80004182:	f9040713          	addi	a4,s0,-112
    80004186:	97ba                	add	a5,a5,a4
    80004188:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000418c:	00148693          	addi	a3,s1,1
    80004190:	068e                	slli	a3,a3,0x3
    80004192:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004196:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000419a:	01897663          	bgeu	s2,s8,800041a6 <exec+0x242>
  sz = sz1;
    8000419e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800041a2:	4481                	li	s1,0
    800041a4:	a059                	j	8000422a <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800041a6:	e9040613          	addi	a2,s0,-368
    800041aa:	85ca                	mv	a1,s2
    800041ac:	855e                	mv	a0,s7
    800041ae:	ffffd097          	auipc	ra,0xffffd
    800041b2:	95c080e7          	jalr	-1700(ra) # 80000b0a <copyout>
    800041b6:	0a054663          	bltz	a0,80004262 <exec+0x2fe>
  p->trapframe->a1 = sp;
    800041ba:	058ab783          	ld	a5,88(s5)
    800041be:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800041c2:	df843783          	ld	a5,-520(s0)
    800041c6:	0007c703          	lbu	a4,0(a5)
    800041ca:	cf11                	beqz	a4,800041e6 <exec+0x282>
    800041cc:	0785                	addi	a5,a5,1
    if(*s == '/')
    800041ce:	02f00693          	li	a3,47
    800041d2:	a039                	j	800041e0 <exec+0x27c>
      last = s+1;
    800041d4:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800041d8:	0785                	addi	a5,a5,1
    800041da:	fff7c703          	lbu	a4,-1(a5)
    800041de:	c701                	beqz	a4,800041e6 <exec+0x282>
    if(*s == '/')
    800041e0:	fed71ce3          	bne	a4,a3,800041d8 <exec+0x274>
    800041e4:	bfc5                	j	800041d4 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800041e6:	4641                	li	a2,16
    800041e8:	df843583          	ld	a1,-520(s0)
    800041ec:	158a8513          	addi	a0,s5,344
    800041f0:	ffffc097          	auipc	ra,0xffffc
    800041f4:	0da080e7          	jalr	218(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800041f8:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800041fc:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004200:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004204:	058ab783          	ld	a5,88(s5)
    80004208:	e6843703          	ld	a4,-408(s0)
    8000420c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000420e:	058ab783          	ld	a5,88(s5)
    80004212:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004216:	85ea                	mv	a1,s10
    80004218:	ffffd097          	auipc	ra,0xffffd
    8000421c:	d90080e7          	jalr	-624(ra) # 80000fa8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004220:	0004851b          	sext.w	a0,s1
    80004224:	bbe1                	j	80003ffc <exec+0x98>
    80004226:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000422a:	e0843583          	ld	a1,-504(s0)
    8000422e:	855e                	mv	a0,s7
    80004230:	ffffd097          	auipc	ra,0xffffd
    80004234:	d78080e7          	jalr	-648(ra) # 80000fa8 <proc_freepagetable>
  if(ip){
    80004238:	da0498e3          	bnez	s1,80003fe8 <exec+0x84>
  return -1;
    8000423c:	557d                	li	a0,-1
    8000423e:	bb7d                	j	80003ffc <exec+0x98>
    80004240:	e1243423          	sd	s2,-504(s0)
    80004244:	b7dd                	j	8000422a <exec+0x2c6>
    80004246:	e1243423          	sd	s2,-504(s0)
    8000424a:	b7c5                	j	8000422a <exec+0x2c6>
    8000424c:	e1243423          	sd	s2,-504(s0)
    80004250:	bfe9                	j	8000422a <exec+0x2c6>
  sz = sz1;
    80004252:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004256:	4481                	li	s1,0
    80004258:	bfc9                	j	8000422a <exec+0x2c6>
  sz = sz1;
    8000425a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000425e:	4481                	li	s1,0
    80004260:	b7e9                	j	8000422a <exec+0x2c6>
  sz = sz1;
    80004262:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004266:	4481                	li	s1,0
    80004268:	b7c9                	j	8000422a <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000426a:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000426e:	2b05                	addiw	s6,s6,1
    80004270:	0389899b          	addiw	s3,s3,56
    80004274:	e8845783          	lhu	a5,-376(s0)
    80004278:	e2fb5be3          	bge	s6,a5,800040ae <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000427c:	2981                	sext.w	s3,s3
    8000427e:	03800713          	li	a4,56
    80004282:	86ce                	mv	a3,s3
    80004284:	e1840613          	addi	a2,s0,-488
    80004288:	4581                	li	a1,0
    8000428a:	8526                	mv	a0,s1
    8000428c:	fffff097          	auipc	ra,0xfffff
    80004290:	a8e080e7          	jalr	-1394(ra) # 80002d1a <readi>
    80004294:	03800793          	li	a5,56
    80004298:	f8f517e3          	bne	a0,a5,80004226 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    8000429c:	e1842783          	lw	a5,-488(s0)
    800042a0:	4705                	li	a4,1
    800042a2:	fce796e3          	bne	a5,a4,8000426e <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800042a6:	e4043603          	ld	a2,-448(s0)
    800042aa:	e3843783          	ld	a5,-456(s0)
    800042ae:	f8f669e3          	bltu	a2,a5,80004240 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042b2:	e2843783          	ld	a5,-472(s0)
    800042b6:	963e                	add	a2,a2,a5
    800042b8:	f8f667e3          	bltu	a2,a5,80004246 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800042bc:	85ca                	mv	a1,s2
    800042be:	855e                	mv	a0,s7
    800042c0:	ffffc097          	auipc	ra,0xffffc
    800042c4:	5fa080e7          	jalr	1530(ra) # 800008ba <uvmalloc>
    800042c8:	e0a43423          	sd	a0,-504(s0)
    800042cc:	d141                	beqz	a0,8000424c <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    800042ce:	e2843d03          	ld	s10,-472(s0)
    800042d2:	df043783          	ld	a5,-528(s0)
    800042d6:	00fd77b3          	and	a5,s10,a5
    800042da:	fba1                	bnez	a5,8000422a <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800042dc:	e2042d83          	lw	s11,-480(s0)
    800042e0:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800042e4:	f80c03e3          	beqz	s8,8000426a <exec+0x306>
    800042e8:	8a62                	mv	s4,s8
    800042ea:	4901                	li	s2,0
    800042ec:	b345                	j	8000408c <exec+0x128>

00000000800042ee <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800042ee:	7179                	addi	sp,sp,-48
    800042f0:	f406                	sd	ra,40(sp)
    800042f2:	f022                	sd	s0,32(sp)
    800042f4:	ec26                	sd	s1,24(sp)
    800042f6:	e84a                	sd	s2,16(sp)
    800042f8:	1800                	addi	s0,sp,48
    800042fa:	892e                	mv	s2,a1
    800042fc:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800042fe:	fdc40593          	addi	a1,s0,-36
    80004302:	ffffe097          	auipc	ra,0xffffe
    80004306:	bf2080e7          	jalr	-1038(ra) # 80001ef4 <argint>
    8000430a:	04054063          	bltz	a0,8000434a <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000430e:	fdc42703          	lw	a4,-36(s0)
    80004312:	47bd                	li	a5,15
    80004314:	02e7ed63          	bltu	a5,a4,8000434e <argfd+0x60>
    80004318:	ffffd097          	auipc	ra,0xffffd
    8000431c:	b30080e7          	jalr	-1232(ra) # 80000e48 <myproc>
    80004320:	fdc42703          	lw	a4,-36(s0)
    80004324:	01a70793          	addi	a5,a4,26
    80004328:	078e                	slli	a5,a5,0x3
    8000432a:	953e                	add	a0,a0,a5
    8000432c:	611c                	ld	a5,0(a0)
    8000432e:	c395                	beqz	a5,80004352 <argfd+0x64>
    return -1;
  if(pfd)
    80004330:	00090463          	beqz	s2,80004338 <argfd+0x4a>
    *pfd = fd;
    80004334:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004338:	4501                	li	a0,0
  if(pf)
    8000433a:	c091                	beqz	s1,8000433e <argfd+0x50>
    *pf = f;
    8000433c:	e09c                	sd	a5,0(s1)
}
    8000433e:	70a2                	ld	ra,40(sp)
    80004340:	7402                	ld	s0,32(sp)
    80004342:	64e2                	ld	s1,24(sp)
    80004344:	6942                	ld	s2,16(sp)
    80004346:	6145                	addi	sp,sp,48
    80004348:	8082                	ret
    return -1;
    8000434a:	557d                	li	a0,-1
    8000434c:	bfcd                	j	8000433e <argfd+0x50>
    return -1;
    8000434e:	557d                	li	a0,-1
    80004350:	b7fd                	j	8000433e <argfd+0x50>
    80004352:	557d                	li	a0,-1
    80004354:	b7ed                	j	8000433e <argfd+0x50>

0000000080004356 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004356:	1101                	addi	sp,sp,-32
    80004358:	ec06                	sd	ra,24(sp)
    8000435a:	e822                	sd	s0,16(sp)
    8000435c:	e426                	sd	s1,8(sp)
    8000435e:	1000                	addi	s0,sp,32
    80004360:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004362:	ffffd097          	auipc	ra,0xffffd
    80004366:	ae6080e7          	jalr	-1306(ra) # 80000e48 <myproc>
    8000436a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000436c:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    80004370:	4501                	li	a0,0
    80004372:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004374:	6398                	ld	a4,0(a5)
    80004376:	cb19                	beqz	a4,8000438c <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004378:	2505                	addiw	a0,a0,1
    8000437a:	07a1                	addi	a5,a5,8
    8000437c:	fed51ce3          	bne	a0,a3,80004374 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004380:	557d                	li	a0,-1
}
    80004382:	60e2                	ld	ra,24(sp)
    80004384:	6442                	ld	s0,16(sp)
    80004386:	64a2                	ld	s1,8(sp)
    80004388:	6105                	addi	sp,sp,32
    8000438a:	8082                	ret
      p->ofile[fd] = f;
    8000438c:	01a50793          	addi	a5,a0,26
    80004390:	078e                	slli	a5,a5,0x3
    80004392:	963e                	add	a2,a2,a5
    80004394:	e204                	sd	s1,0(a2)
      return fd;
    80004396:	b7f5                	j	80004382 <fdalloc+0x2c>

0000000080004398 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004398:	715d                	addi	sp,sp,-80
    8000439a:	e486                	sd	ra,72(sp)
    8000439c:	e0a2                	sd	s0,64(sp)
    8000439e:	fc26                	sd	s1,56(sp)
    800043a0:	f84a                	sd	s2,48(sp)
    800043a2:	f44e                	sd	s3,40(sp)
    800043a4:	f052                	sd	s4,32(sp)
    800043a6:	ec56                	sd	s5,24(sp)
    800043a8:	0880                	addi	s0,sp,80
    800043aa:	89ae                	mv	s3,a1
    800043ac:	8ab2                	mv	s5,a2
    800043ae:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800043b0:	fb040593          	addi	a1,s0,-80
    800043b4:	fffff097          	auipc	ra,0xfffff
    800043b8:	e86080e7          	jalr	-378(ra) # 8000323a <nameiparent>
    800043bc:	892a                	mv	s2,a0
    800043be:	12050f63          	beqz	a0,800044fc <create+0x164>
    return 0;

  ilock(dp);
    800043c2:	ffffe097          	auipc	ra,0xffffe
    800043c6:	6a4080e7          	jalr	1700(ra) # 80002a66 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800043ca:	4601                	li	a2,0
    800043cc:	fb040593          	addi	a1,s0,-80
    800043d0:	854a                	mv	a0,s2
    800043d2:	fffff097          	auipc	ra,0xfffff
    800043d6:	b78080e7          	jalr	-1160(ra) # 80002f4a <dirlookup>
    800043da:	84aa                	mv	s1,a0
    800043dc:	c921                	beqz	a0,8000442c <create+0x94>
    iunlockput(dp);
    800043de:	854a                	mv	a0,s2
    800043e0:	fffff097          	auipc	ra,0xfffff
    800043e4:	8e8080e7          	jalr	-1816(ra) # 80002cc8 <iunlockput>
    ilock(ip);
    800043e8:	8526                	mv	a0,s1
    800043ea:	ffffe097          	auipc	ra,0xffffe
    800043ee:	67c080e7          	jalr	1660(ra) # 80002a66 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800043f2:	2981                	sext.w	s3,s3
    800043f4:	4789                	li	a5,2
    800043f6:	02f99463          	bne	s3,a5,8000441e <create+0x86>
    800043fa:	0444d783          	lhu	a5,68(s1)
    800043fe:	37f9                	addiw	a5,a5,-2
    80004400:	17c2                	slli	a5,a5,0x30
    80004402:	93c1                	srli	a5,a5,0x30
    80004404:	4705                	li	a4,1
    80004406:	00f76c63          	bltu	a4,a5,8000441e <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000440a:	8526                	mv	a0,s1
    8000440c:	60a6                	ld	ra,72(sp)
    8000440e:	6406                	ld	s0,64(sp)
    80004410:	74e2                	ld	s1,56(sp)
    80004412:	7942                	ld	s2,48(sp)
    80004414:	79a2                	ld	s3,40(sp)
    80004416:	7a02                	ld	s4,32(sp)
    80004418:	6ae2                	ld	s5,24(sp)
    8000441a:	6161                	addi	sp,sp,80
    8000441c:	8082                	ret
    iunlockput(ip);
    8000441e:	8526                	mv	a0,s1
    80004420:	fffff097          	auipc	ra,0xfffff
    80004424:	8a8080e7          	jalr	-1880(ra) # 80002cc8 <iunlockput>
    return 0;
    80004428:	4481                	li	s1,0
    8000442a:	b7c5                	j	8000440a <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000442c:	85ce                	mv	a1,s3
    8000442e:	00092503          	lw	a0,0(s2)
    80004432:	ffffe097          	auipc	ra,0xffffe
    80004436:	49c080e7          	jalr	1180(ra) # 800028ce <ialloc>
    8000443a:	84aa                	mv	s1,a0
    8000443c:	c529                	beqz	a0,80004486 <create+0xee>
  ilock(ip);
    8000443e:	ffffe097          	auipc	ra,0xffffe
    80004442:	628080e7          	jalr	1576(ra) # 80002a66 <ilock>
  ip->major = major;
    80004446:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000444a:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000444e:	4785                	li	a5,1
    80004450:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004454:	8526                	mv	a0,s1
    80004456:	ffffe097          	auipc	ra,0xffffe
    8000445a:	546080e7          	jalr	1350(ra) # 8000299c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000445e:	2981                	sext.w	s3,s3
    80004460:	4785                	li	a5,1
    80004462:	02f98a63          	beq	s3,a5,80004496 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004466:	40d0                	lw	a2,4(s1)
    80004468:	fb040593          	addi	a1,s0,-80
    8000446c:	854a                	mv	a0,s2
    8000446e:	fffff097          	auipc	ra,0xfffff
    80004472:	cec080e7          	jalr	-788(ra) # 8000315a <dirlink>
    80004476:	06054b63          	bltz	a0,800044ec <create+0x154>
  iunlockput(dp);
    8000447a:	854a                	mv	a0,s2
    8000447c:	fffff097          	auipc	ra,0xfffff
    80004480:	84c080e7          	jalr	-1972(ra) # 80002cc8 <iunlockput>
  return ip;
    80004484:	b759                	j	8000440a <create+0x72>
    panic("create: ialloc");
    80004486:	00004517          	auipc	a0,0x4
    8000448a:	1e250513          	addi	a0,a0,482 # 80008668 <syscalls+0x2a0>
    8000448e:	00001097          	auipc	ra,0x1
    80004492:	68a080e7          	jalr	1674(ra) # 80005b18 <panic>
    dp->nlink++;  // for ".."
    80004496:	04a95783          	lhu	a5,74(s2)
    8000449a:	2785                	addiw	a5,a5,1
    8000449c:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800044a0:	854a                	mv	a0,s2
    800044a2:	ffffe097          	auipc	ra,0xffffe
    800044a6:	4fa080e7          	jalr	1274(ra) # 8000299c <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800044aa:	40d0                	lw	a2,4(s1)
    800044ac:	00004597          	auipc	a1,0x4
    800044b0:	1cc58593          	addi	a1,a1,460 # 80008678 <syscalls+0x2b0>
    800044b4:	8526                	mv	a0,s1
    800044b6:	fffff097          	auipc	ra,0xfffff
    800044ba:	ca4080e7          	jalr	-860(ra) # 8000315a <dirlink>
    800044be:	00054f63          	bltz	a0,800044dc <create+0x144>
    800044c2:	00492603          	lw	a2,4(s2)
    800044c6:	00004597          	auipc	a1,0x4
    800044ca:	1ba58593          	addi	a1,a1,442 # 80008680 <syscalls+0x2b8>
    800044ce:	8526                	mv	a0,s1
    800044d0:	fffff097          	auipc	ra,0xfffff
    800044d4:	c8a080e7          	jalr	-886(ra) # 8000315a <dirlink>
    800044d8:	f80557e3          	bgez	a0,80004466 <create+0xce>
      panic("create dots");
    800044dc:	00004517          	auipc	a0,0x4
    800044e0:	1ac50513          	addi	a0,a0,428 # 80008688 <syscalls+0x2c0>
    800044e4:	00001097          	auipc	ra,0x1
    800044e8:	634080e7          	jalr	1588(ra) # 80005b18 <panic>
    panic("create: dirlink");
    800044ec:	00004517          	auipc	a0,0x4
    800044f0:	1ac50513          	addi	a0,a0,428 # 80008698 <syscalls+0x2d0>
    800044f4:	00001097          	auipc	ra,0x1
    800044f8:	624080e7          	jalr	1572(ra) # 80005b18 <panic>
    return 0;
    800044fc:	84aa                	mv	s1,a0
    800044fe:	b731                	j	8000440a <create+0x72>

0000000080004500 <sys_dup>:
{
    80004500:	7179                	addi	sp,sp,-48
    80004502:	f406                	sd	ra,40(sp)
    80004504:	f022                	sd	s0,32(sp)
    80004506:	ec26                	sd	s1,24(sp)
    80004508:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000450a:	fd840613          	addi	a2,s0,-40
    8000450e:	4581                	li	a1,0
    80004510:	4501                	li	a0,0
    80004512:	00000097          	auipc	ra,0x0
    80004516:	ddc080e7          	jalr	-548(ra) # 800042ee <argfd>
    return -1;
    8000451a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000451c:	02054363          	bltz	a0,80004542 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004520:	fd843503          	ld	a0,-40(s0)
    80004524:	00000097          	auipc	ra,0x0
    80004528:	e32080e7          	jalr	-462(ra) # 80004356 <fdalloc>
    8000452c:	84aa                	mv	s1,a0
    return -1;
    8000452e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004530:	00054963          	bltz	a0,80004542 <sys_dup+0x42>
  filedup(f);
    80004534:	fd843503          	ld	a0,-40(s0)
    80004538:	fffff097          	auipc	ra,0xfffff
    8000453c:	37a080e7          	jalr	890(ra) # 800038b2 <filedup>
  return fd;
    80004540:	87a6                	mv	a5,s1
}
    80004542:	853e                	mv	a0,a5
    80004544:	70a2                	ld	ra,40(sp)
    80004546:	7402                	ld	s0,32(sp)
    80004548:	64e2                	ld	s1,24(sp)
    8000454a:	6145                	addi	sp,sp,48
    8000454c:	8082                	ret

000000008000454e <sys_read>:
{
    8000454e:	7179                	addi	sp,sp,-48
    80004550:	f406                	sd	ra,40(sp)
    80004552:	f022                	sd	s0,32(sp)
    80004554:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004556:	fe840613          	addi	a2,s0,-24
    8000455a:	4581                	li	a1,0
    8000455c:	4501                	li	a0,0
    8000455e:	00000097          	auipc	ra,0x0
    80004562:	d90080e7          	jalr	-624(ra) # 800042ee <argfd>
    return -1;
    80004566:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004568:	04054163          	bltz	a0,800045aa <sys_read+0x5c>
    8000456c:	fe440593          	addi	a1,s0,-28
    80004570:	4509                	li	a0,2
    80004572:	ffffe097          	auipc	ra,0xffffe
    80004576:	982080e7          	jalr	-1662(ra) # 80001ef4 <argint>
    return -1;
    8000457a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000457c:	02054763          	bltz	a0,800045aa <sys_read+0x5c>
    80004580:	fd840593          	addi	a1,s0,-40
    80004584:	4505                	li	a0,1
    80004586:	ffffe097          	auipc	ra,0xffffe
    8000458a:	990080e7          	jalr	-1648(ra) # 80001f16 <argaddr>
    return -1;
    8000458e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004590:	00054d63          	bltz	a0,800045aa <sys_read+0x5c>
  return fileread(f, p, n);
    80004594:	fe442603          	lw	a2,-28(s0)
    80004598:	fd843583          	ld	a1,-40(s0)
    8000459c:	fe843503          	ld	a0,-24(s0)
    800045a0:	fffff097          	auipc	ra,0xfffff
    800045a4:	49e080e7          	jalr	1182(ra) # 80003a3e <fileread>
    800045a8:	87aa                	mv	a5,a0
}
    800045aa:	853e                	mv	a0,a5
    800045ac:	70a2                	ld	ra,40(sp)
    800045ae:	7402                	ld	s0,32(sp)
    800045b0:	6145                	addi	sp,sp,48
    800045b2:	8082                	ret

00000000800045b4 <sys_write>:
{
    800045b4:	7179                	addi	sp,sp,-48
    800045b6:	f406                	sd	ra,40(sp)
    800045b8:	f022                	sd	s0,32(sp)
    800045ba:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045bc:	fe840613          	addi	a2,s0,-24
    800045c0:	4581                	li	a1,0
    800045c2:	4501                	li	a0,0
    800045c4:	00000097          	auipc	ra,0x0
    800045c8:	d2a080e7          	jalr	-726(ra) # 800042ee <argfd>
    return -1;
    800045cc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045ce:	04054163          	bltz	a0,80004610 <sys_write+0x5c>
    800045d2:	fe440593          	addi	a1,s0,-28
    800045d6:	4509                	li	a0,2
    800045d8:	ffffe097          	auipc	ra,0xffffe
    800045dc:	91c080e7          	jalr	-1764(ra) # 80001ef4 <argint>
    return -1;
    800045e0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045e2:	02054763          	bltz	a0,80004610 <sys_write+0x5c>
    800045e6:	fd840593          	addi	a1,s0,-40
    800045ea:	4505                	li	a0,1
    800045ec:	ffffe097          	auipc	ra,0xffffe
    800045f0:	92a080e7          	jalr	-1750(ra) # 80001f16 <argaddr>
    return -1;
    800045f4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045f6:	00054d63          	bltz	a0,80004610 <sys_write+0x5c>
  return filewrite(f, p, n);
    800045fa:	fe442603          	lw	a2,-28(s0)
    800045fe:	fd843583          	ld	a1,-40(s0)
    80004602:	fe843503          	ld	a0,-24(s0)
    80004606:	fffff097          	auipc	ra,0xfffff
    8000460a:	4fa080e7          	jalr	1274(ra) # 80003b00 <filewrite>
    8000460e:	87aa                	mv	a5,a0
}
    80004610:	853e                	mv	a0,a5
    80004612:	70a2                	ld	ra,40(sp)
    80004614:	7402                	ld	s0,32(sp)
    80004616:	6145                	addi	sp,sp,48
    80004618:	8082                	ret

000000008000461a <sys_close>:
{
    8000461a:	1101                	addi	sp,sp,-32
    8000461c:	ec06                	sd	ra,24(sp)
    8000461e:	e822                	sd	s0,16(sp)
    80004620:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004622:	fe040613          	addi	a2,s0,-32
    80004626:	fec40593          	addi	a1,s0,-20
    8000462a:	4501                	li	a0,0
    8000462c:	00000097          	auipc	ra,0x0
    80004630:	cc2080e7          	jalr	-830(ra) # 800042ee <argfd>
    return -1;
    80004634:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004636:	02054463          	bltz	a0,8000465e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000463a:	ffffd097          	auipc	ra,0xffffd
    8000463e:	80e080e7          	jalr	-2034(ra) # 80000e48 <myproc>
    80004642:	fec42783          	lw	a5,-20(s0)
    80004646:	07e9                	addi	a5,a5,26
    80004648:	078e                	slli	a5,a5,0x3
    8000464a:	97aa                	add	a5,a5,a0
    8000464c:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004650:	fe043503          	ld	a0,-32(s0)
    80004654:	fffff097          	auipc	ra,0xfffff
    80004658:	2b0080e7          	jalr	688(ra) # 80003904 <fileclose>
  return 0;
    8000465c:	4781                	li	a5,0
}
    8000465e:	853e                	mv	a0,a5
    80004660:	60e2                	ld	ra,24(sp)
    80004662:	6442                	ld	s0,16(sp)
    80004664:	6105                	addi	sp,sp,32
    80004666:	8082                	ret

0000000080004668 <sys_fstat>:
{
    80004668:	1101                	addi	sp,sp,-32
    8000466a:	ec06                	sd	ra,24(sp)
    8000466c:	e822                	sd	s0,16(sp)
    8000466e:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004670:	fe840613          	addi	a2,s0,-24
    80004674:	4581                	li	a1,0
    80004676:	4501                	li	a0,0
    80004678:	00000097          	auipc	ra,0x0
    8000467c:	c76080e7          	jalr	-906(ra) # 800042ee <argfd>
    return -1;
    80004680:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004682:	02054563          	bltz	a0,800046ac <sys_fstat+0x44>
    80004686:	fe040593          	addi	a1,s0,-32
    8000468a:	4505                	li	a0,1
    8000468c:	ffffe097          	auipc	ra,0xffffe
    80004690:	88a080e7          	jalr	-1910(ra) # 80001f16 <argaddr>
    return -1;
    80004694:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004696:	00054b63          	bltz	a0,800046ac <sys_fstat+0x44>
  return filestat(f, st);
    8000469a:	fe043583          	ld	a1,-32(s0)
    8000469e:	fe843503          	ld	a0,-24(s0)
    800046a2:	fffff097          	auipc	ra,0xfffff
    800046a6:	32a080e7          	jalr	810(ra) # 800039cc <filestat>
    800046aa:	87aa                	mv	a5,a0
}
    800046ac:	853e                	mv	a0,a5
    800046ae:	60e2                	ld	ra,24(sp)
    800046b0:	6442                	ld	s0,16(sp)
    800046b2:	6105                	addi	sp,sp,32
    800046b4:	8082                	ret

00000000800046b6 <sys_link>:
{
    800046b6:	7169                	addi	sp,sp,-304
    800046b8:	f606                	sd	ra,296(sp)
    800046ba:	f222                	sd	s0,288(sp)
    800046bc:	ee26                	sd	s1,280(sp)
    800046be:	ea4a                	sd	s2,272(sp)
    800046c0:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800046c2:	08000613          	li	a2,128
    800046c6:	ed040593          	addi	a1,s0,-304
    800046ca:	4501                	li	a0,0
    800046cc:	ffffe097          	auipc	ra,0xffffe
    800046d0:	86c080e7          	jalr	-1940(ra) # 80001f38 <argstr>
    return -1;
    800046d4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800046d6:	10054e63          	bltz	a0,800047f2 <sys_link+0x13c>
    800046da:	08000613          	li	a2,128
    800046de:	f5040593          	addi	a1,s0,-176
    800046e2:	4505                	li	a0,1
    800046e4:	ffffe097          	auipc	ra,0xffffe
    800046e8:	854080e7          	jalr	-1964(ra) # 80001f38 <argstr>
    return -1;
    800046ec:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800046ee:	10054263          	bltz	a0,800047f2 <sys_link+0x13c>
  begin_op();
    800046f2:	fffff097          	auipc	ra,0xfffff
    800046f6:	d46080e7          	jalr	-698(ra) # 80003438 <begin_op>
  if((ip = namei(old)) == 0){
    800046fa:	ed040513          	addi	a0,s0,-304
    800046fe:	fffff097          	auipc	ra,0xfffff
    80004702:	b1e080e7          	jalr	-1250(ra) # 8000321c <namei>
    80004706:	84aa                	mv	s1,a0
    80004708:	c551                	beqz	a0,80004794 <sys_link+0xde>
  ilock(ip);
    8000470a:	ffffe097          	auipc	ra,0xffffe
    8000470e:	35c080e7          	jalr	860(ra) # 80002a66 <ilock>
  if(ip->type == T_DIR){
    80004712:	04449703          	lh	a4,68(s1)
    80004716:	4785                	li	a5,1
    80004718:	08f70463          	beq	a4,a5,800047a0 <sys_link+0xea>
  ip->nlink++;
    8000471c:	04a4d783          	lhu	a5,74(s1)
    80004720:	2785                	addiw	a5,a5,1
    80004722:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004726:	8526                	mv	a0,s1
    80004728:	ffffe097          	auipc	ra,0xffffe
    8000472c:	274080e7          	jalr	628(ra) # 8000299c <iupdate>
  iunlock(ip);
    80004730:	8526                	mv	a0,s1
    80004732:	ffffe097          	auipc	ra,0xffffe
    80004736:	3f6080e7          	jalr	1014(ra) # 80002b28 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000473a:	fd040593          	addi	a1,s0,-48
    8000473e:	f5040513          	addi	a0,s0,-176
    80004742:	fffff097          	auipc	ra,0xfffff
    80004746:	af8080e7          	jalr	-1288(ra) # 8000323a <nameiparent>
    8000474a:	892a                	mv	s2,a0
    8000474c:	c935                	beqz	a0,800047c0 <sys_link+0x10a>
  ilock(dp);
    8000474e:	ffffe097          	auipc	ra,0xffffe
    80004752:	318080e7          	jalr	792(ra) # 80002a66 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004756:	00092703          	lw	a4,0(s2)
    8000475a:	409c                	lw	a5,0(s1)
    8000475c:	04f71d63          	bne	a4,a5,800047b6 <sys_link+0x100>
    80004760:	40d0                	lw	a2,4(s1)
    80004762:	fd040593          	addi	a1,s0,-48
    80004766:	854a                	mv	a0,s2
    80004768:	fffff097          	auipc	ra,0xfffff
    8000476c:	9f2080e7          	jalr	-1550(ra) # 8000315a <dirlink>
    80004770:	04054363          	bltz	a0,800047b6 <sys_link+0x100>
  iunlockput(dp);
    80004774:	854a                	mv	a0,s2
    80004776:	ffffe097          	auipc	ra,0xffffe
    8000477a:	552080e7          	jalr	1362(ra) # 80002cc8 <iunlockput>
  iput(ip);
    8000477e:	8526                	mv	a0,s1
    80004780:	ffffe097          	auipc	ra,0xffffe
    80004784:	4a0080e7          	jalr	1184(ra) # 80002c20 <iput>
  end_op();
    80004788:	fffff097          	auipc	ra,0xfffff
    8000478c:	d30080e7          	jalr	-720(ra) # 800034b8 <end_op>
  return 0;
    80004790:	4781                	li	a5,0
    80004792:	a085                	j	800047f2 <sys_link+0x13c>
    end_op();
    80004794:	fffff097          	auipc	ra,0xfffff
    80004798:	d24080e7          	jalr	-732(ra) # 800034b8 <end_op>
    return -1;
    8000479c:	57fd                	li	a5,-1
    8000479e:	a891                	j	800047f2 <sys_link+0x13c>
    iunlockput(ip);
    800047a0:	8526                	mv	a0,s1
    800047a2:	ffffe097          	auipc	ra,0xffffe
    800047a6:	526080e7          	jalr	1318(ra) # 80002cc8 <iunlockput>
    end_op();
    800047aa:	fffff097          	auipc	ra,0xfffff
    800047ae:	d0e080e7          	jalr	-754(ra) # 800034b8 <end_op>
    return -1;
    800047b2:	57fd                	li	a5,-1
    800047b4:	a83d                	j	800047f2 <sys_link+0x13c>
    iunlockput(dp);
    800047b6:	854a                	mv	a0,s2
    800047b8:	ffffe097          	auipc	ra,0xffffe
    800047bc:	510080e7          	jalr	1296(ra) # 80002cc8 <iunlockput>
  ilock(ip);
    800047c0:	8526                	mv	a0,s1
    800047c2:	ffffe097          	auipc	ra,0xffffe
    800047c6:	2a4080e7          	jalr	676(ra) # 80002a66 <ilock>
  ip->nlink--;
    800047ca:	04a4d783          	lhu	a5,74(s1)
    800047ce:	37fd                	addiw	a5,a5,-1
    800047d0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047d4:	8526                	mv	a0,s1
    800047d6:	ffffe097          	auipc	ra,0xffffe
    800047da:	1c6080e7          	jalr	454(ra) # 8000299c <iupdate>
  iunlockput(ip);
    800047de:	8526                	mv	a0,s1
    800047e0:	ffffe097          	auipc	ra,0xffffe
    800047e4:	4e8080e7          	jalr	1256(ra) # 80002cc8 <iunlockput>
  end_op();
    800047e8:	fffff097          	auipc	ra,0xfffff
    800047ec:	cd0080e7          	jalr	-816(ra) # 800034b8 <end_op>
  return -1;
    800047f0:	57fd                	li	a5,-1
}
    800047f2:	853e                	mv	a0,a5
    800047f4:	70b2                	ld	ra,296(sp)
    800047f6:	7412                	ld	s0,288(sp)
    800047f8:	64f2                	ld	s1,280(sp)
    800047fa:	6952                	ld	s2,272(sp)
    800047fc:	6155                	addi	sp,sp,304
    800047fe:	8082                	ret

0000000080004800 <sys_unlink>:
{
    80004800:	7151                	addi	sp,sp,-240
    80004802:	f586                	sd	ra,232(sp)
    80004804:	f1a2                	sd	s0,224(sp)
    80004806:	eda6                	sd	s1,216(sp)
    80004808:	e9ca                	sd	s2,208(sp)
    8000480a:	e5ce                	sd	s3,200(sp)
    8000480c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000480e:	08000613          	li	a2,128
    80004812:	f3040593          	addi	a1,s0,-208
    80004816:	4501                	li	a0,0
    80004818:	ffffd097          	auipc	ra,0xffffd
    8000481c:	720080e7          	jalr	1824(ra) # 80001f38 <argstr>
    80004820:	18054163          	bltz	a0,800049a2 <sys_unlink+0x1a2>
  begin_op();
    80004824:	fffff097          	auipc	ra,0xfffff
    80004828:	c14080e7          	jalr	-1004(ra) # 80003438 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000482c:	fb040593          	addi	a1,s0,-80
    80004830:	f3040513          	addi	a0,s0,-208
    80004834:	fffff097          	auipc	ra,0xfffff
    80004838:	a06080e7          	jalr	-1530(ra) # 8000323a <nameiparent>
    8000483c:	84aa                	mv	s1,a0
    8000483e:	c979                	beqz	a0,80004914 <sys_unlink+0x114>
  ilock(dp);
    80004840:	ffffe097          	auipc	ra,0xffffe
    80004844:	226080e7          	jalr	550(ra) # 80002a66 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004848:	00004597          	auipc	a1,0x4
    8000484c:	e3058593          	addi	a1,a1,-464 # 80008678 <syscalls+0x2b0>
    80004850:	fb040513          	addi	a0,s0,-80
    80004854:	ffffe097          	auipc	ra,0xffffe
    80004858:	6dc080e7          	jalr	1756(ra) # 80002f30 <namecmp>
    8000485c:	14050a63          	beqz	a0,800049b0 <sys_unlink+0x1b0>
    80004860:	00004597          	auipc	a1,0x4
    80004864:	e2058593          	addi	a1,a1,-480 # 80008680 <syscalls+0x2b8>
    80004868:	fb040513          	addi	a0,s0,-80
    8000486c:	ffffe097          	auipc	ra,0xffffe
    80004870:	6c4080e7          	jalr	1732(ra) # 80002f30 <namecmp>
    80004874:	12050e63          	beqz	a0,800049b0 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004878:	f2c40613          	addi	a2,s0,-212
    8000487c:	fb040593          	addi	a1,s0,-80
    80004880:	8526                	mv	a0,s1
    80004882:	ffffe097          	auipc	ra,0xffffe
    80004886:	6c8080e7          	jalr	1736(ra) # 80002f4a <dirlookup>
    8000488a:	892a                	mv	s2,a0
    8000488c:	12050263          	beqz	a0,800049b0 <sys_unlink+0x1b0>
  ilock(ip);
    80004890:	ffffe097          	auipc	ra,0xffffe
    80004894:	1d6080e7          	jalr	470(ra) # 80002a66 <ilock>
  if(ip->nlink < 1)
    80004898:	04a91783          	lh	a5,74(s2)
    8000489c:	08f05263          	blez	a5,80004920 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800048a0:	04491703          	lh	a4,68(s2)
    800048a4:	4785                	li	a5,1
    800048a6:	08f70563          	beq	a4,a5,80004930 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800048aa:	4641                	li	a2,16
    800048ac:	4581                	li	a1,0
    800048ae:	fc040513          	addi	a0,s0,-64
    800048b2:	ffffc097          	auipc	ra,0xffffc
    800048b6:	8c6080e7          	jalr	-1850(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800048ba:	4741                	li	a4,16
    800048bc:	f2c42683          	lw	a3,-212(s0)
    800048c0:	fc040613          	addi	a2,s0,-64
    800048c4:	4581                	li	a1,0
    800048c6:	8526                	mv	a0,s1
    800048c8:	ffffe097          	auipc	ra,0xffffe
    800048cc:	54a080e7          	jalr	1354(ra) # 80002e12 <writei>
    800048d0:	47c1                	li	a5,16
    800048d2:	0af51563          	bne	a0,a5,8000497c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800048d6:	04491703          	lh	a4,68(s2)
    800048da:	4785                	li	a5,1
    800048dc:	0af70863          	beq	a4,a5,8000498c <sys_unlink+0x18c>
  iunlockput(dp);
    800048e0:	8526                	mv	a0,s1
    800048e2:	ffffe097          	auipc	ra,0xffffe
    800048e6:	3e6080e7          	jalr	998(ra) # 80002cc8 <iunlockput>
  ip->nlink--;
    800048ea:	04a95783          	lhu	a5,74(s2)
    800048ee:	37fd                	addiw	a5,a5,-1
    800048f0:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800048f4:	854a                	mv	a0,s2
    800048f6:	ffffe097          	auipc	ra,0xffffe
    800048fa:	0a6080e7          	jalr	166(ra) # 8000299c <iupdate>
  iunlockput(ip);
    800048fe:	854a                	mv	a0,s2
    80004900:	ffffe097          	auipc	ra,0xffffe
    80004904:	3c8080e7          	jalr	968(ra) # 80002cc8 <iunlockput>
  end_op();
    80004908:	fffff097          	auipc	ra,0xfffff
    8000490c:	bb0080e7          	jalr	-1104(ra) # 800034b8 <end_op>
  return 0;
    80004910:	4501                	li	a0,0
    80004912:	a84d                	j	800049c4 <sys_unlink+0x1c4>
    end_op();
    80004914:	fffff097          	auipc	ra,0xfffff
    80004918:	ba4080e7          	jalr	-1116(ra) # 800034b8 <end_op>
    return -1;
    8000491c:	557d                	li	a0,-1
    8000491e:	a05d                	j	800049c4 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004920:	00004517          	auipc	a0,0x4
    80004924:	d8850513          	addi	a0,a0,-632 # 800086a8 <syscalls+0x2e0>
    80004928:	00001097          	auipc	ra,0x1
    8000492c:	1f0080e7          	jalr	496(ra) # 80005b18 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004930:	04c92703          	lw	a4,76(s2)
    80004934:	02000793          	li	a5,32
    80004938:	f6e7f9e3          	bgeu	a5,a4,800048aa <sys_unlink+0xaa>
    8000493c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004940:	4741                	li	a4,16
    80004942:	86ce                	mv	a3,s3
    80004944:	f1840613          	addi	a2,s0,-232
    80004948:	4581                	li	a1,0
    8000494a:	854a                	mv	a0,s2
    8000494c:	ffffe097          	auipc	ra,0xffffe
    80004950:	3ce080e7          	jalr	974(ra) # 80002d1a <readi>
    80004954:	47c1                	li	a5,16
    80004956:	00f51b63          	bne	a0,a5,8000496c <sys_unlink+0x16c>
    if(de.inum != 0)
    8000495a:	f1845783          	lhu	a5,-232(s0)
    8000495e:	e7a1                	bnez	a5,800049a6 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004960:	29c1                	addiw	s3,s3,16
    80004962:	04c92783          	lw	a5,76(s2)
    80004966:	fcf9ede3          	bltu	s3,a5,80004940 <sys_unlink+0x140>
    8000496a:	b781                	j	800048aa <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000496c:	00004517          	auipc	a0,0x4
    80004970:	d5450513          	addi	a0,a0,-684 # 800086c0 <syscalls+0x2f8>
    80004974:	00001097          	auipc	ra,0x1
    80004978:	1a4080e7          	jalr	420(ra) # 80005b18 <panic>
    panic("unlink: writei");
    8000497c:	00004517          	auipc	a0,0x4
    80004980:	d5c50513          	addi	a0,a0,-676 # 800086d8 <syscalls+0x310>
    80004984:	00001097          	auipc	ra,0x1
    80004988:	194080e7          	jalr	404(ra) # 80005b18 <panic>
    dp->nlink--;
    8000498c:	04a4d783          	lhu	a5,74(s1)
    80004990:	37fd                	addiw	a5,a5,-1
    80004992:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004996:	8526                	mv	a0,s1
    80004998:	ffffe097          	auipc	ra,0xffffe
    8000499c:	004080e7          	jalr	4(ra) # 8000299c <iupdate>
    800049a0:	b781                	j	800048e0 <sys_unlink+0xe0>
    return -1;
    800049a2:	557d                	li	a0,-1
    800049a4:	a005                	j	800049c4 <sys_unlink+0x1c4>
    iunlockput(ip);
    800049a6:	854a                	mv	a0,s2
    800049a8:	ffffe097          	auipc	ra,0xffffe
    800049ac:	320080e7          	jalr	800(ra) # 80002cc8 <iunlockput>
  iunlockput(dp);
    800049b0:	8526                	mv	a0,s1
    800049b2:	ffffe097          	auipc	ra,0xffffe
    800049b6:	316080e7          	jalr	790(ra) # 80002cc8 <iunlockput>
  end_op();
    800049ba:	fffff097          	auipc	ra,0xfffff
    800049be:	afe080e7          	jalr	-1282(ra) # 800034b8 <end_op>
  return -1;
    800049c2:	557d                	li	a0,-1
}
    800049c4:	70ae                	ld	ra,232(sp)
    800049c6:	740e                	ld	s0,224(sp)
    800049c8:	64ee                	ld	s1,216(sp)
    800049ca:	694e                	ld	s2,208(sp)
    800049cc:	69ae                	ld	s3,200(sp)
    800049ce:	616d                	addi	sp,sp,240
    800049d0:	8082                	ret

00000000800049d2 <sys_open>:

uint64
sys_open(void)
{
    800049d2:	7131                	addi	sp,sp,-192
    800049d4:	fd06                	sd	ra,184(sp)
    800049d6:	f922                	sd	s0,176(sp)
    800049d8:	f526                	sd	s1,168(sp)
    800049da:	f14a                	sd	s2,160(sp)
    800049dc:	ed4e                	sd	s3,152(sp)
    800049de:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800049e0:	08000613          	li	a2,128
    800049e4:	f5040593          	addi	a1,s0,-176
    800049e8:	4501                	li	a0,0
    800049ea:	ffffd097          	auipc	ra,0xffffd
    800049ee:	54e080e7          	jalr	1358(ra) # 80001f38 <argstr>
    return -1;
    800049f2:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800049f4:	0c054163          	bltz	a0,80004ab6 <sys_open+0xe4>
    800049f8:	f4c40593          	addi	a1,s0,-180
    800049fc:	4505                	li	a0,1
    800049fe:	ffffd097          	auipc	ra,0xffffd
    80004a02:	4f6080e7          	jalr	1270(ra) # 80001ef4 <argint>
    80004a06:	0a054863          	bltz	a0,80004ab6 <sys_open+0xe4>

  begin_op();
    80004a0a:	fffff097          	auipc	ra,0xfffff
    80004a0e:	a2e080e7          	jalr	-1490(ra) # 80003438 <begin_op>

  if(omode & O_CREATE){
    80004a12:	f4c42783          	lw	a5,-180(s0)
    80004a16:	2007f793          	andi	a5,a5,512
    80004a1a:	cbdd                	beqz	a5,80004ad0 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004a1c:	4681                	li	a3,0
    80004a1e:	4601                	li	a2,0
    80004a20:	4589                	li	a1,2
    80004a22:	f5040513          	addi	a0,s0,-176
    80004a26:	00000097          	auipc	ra,0x0
    80004a2a:	972080e7          	jalr	-1678(ra) # 80004398 <create>
    80004a2e:	892a                	mv	s2,a0
    if(ip == 0){
    80004a30:	c959                	beqz	a0,80004ac6 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004a32:	04491703          	lh	a4,68(s2)
    80004a36:	478d                	li	a5,3
    80004a38:	00f71763          	bne	a4,a5,80004a46 <sys_open+0x74>
    80004a3c:	04695703          	lhu	a4,70(s2)
    80004a40:	47a5                	li	a5,9
    80004a42:	0ce7ec63          	bltu	a5,a4,80004b1a <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004a46:	fffff097          	auipc	ra,0xfffff
    80004a4a:	e02080e7          	jalr	-510(ra) # 80003848 <filealloc>
    80004a4e:	89aa                	mv	s3,a0
    80004a50:	10050263          	beqz	a0,80004b54 <sys_open+0x182>
    80004a54:	00000097          	auipc	ra,0x0
    80004a58:	902080e7          	jalr	-1790(ra) # 80004356 <fdalloc>
    80004a5c:	84aa                	mv	s1,a0
    80004a5e:	0e054663          	bltz	a0,80004b4a <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004a62:	04491703          	lh	a4,68(s2)
    80004a66:	478d                	li	a5,3
    80004a68:	0cf70463          	beq	a4,a5,80004b30 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004a6c:	4789                	li	a5,2
    80004a6e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004a72:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004a76:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004a7a:	f4c42783          	lw	a5,-180(s0)
    80004a7e:	0017c713          	xori	a4,a5,1
    80004a82:	8b05                	andi	a4,a4,1
    80004a84:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004a88:	0037f713          	andi	a4,a5,3
    80004a8c:	00e03733          	snez	a4,a4
    80004a90:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004a94:	4007f793          	andi	a5,a5,1024
    80004a98:	c791                	beqz	a5,80004aa4 <sys_open+0xd2>
    80004a9a:	04491703          	lh	a4,68(s2)
    80004a9e:	4789                	li	a5,2
    80004aa0:	08f70f63          	beq	a4,a5,80004b3e <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004aa4:	854a                	mv	a0,s2
    80004aa6:	ffffe097          	auipc	ra,0xffffe
    80004aaa:	082080e7          	jalr	130(ra) # 80002b28 <iunlock>
  end_op();
    80004aae:	fffff097          	auipc	ra,0xfffff
    80004ab2:	a0a080e7          	jalr	-1526(ra) # 800034b8 <end_op>

  return fd;
}
    80004ab6:	8526                	mv	a0,s1
    80004ab8:	70ea                	ld	ra,184(sp)
    80004aba:	744a                	ld	s0,176(sp)
    80004abc:	74aa                	ld	s1,168(sp)
    80004abe:	790a                	ld	s2,160(sp)
    80004ac0:	69ea                	ld	s3,152(sp)
    80004ac2:	6129                	addi	sp,sp,192
    80004ac4:	8082                	ret
      end_op();
    80004ac6:	fffff097          	auipc	ra,0xfffff
    80004aca:	9f2080e7          	jalr	-1550(ra) # 800034b8 <end_op>
      return -1;
    80004ace:	b7e5                	j	80004ab6 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004ad0:	f5040513          	addi	a0,s0,-176
    80004ad4:	ffffe097          	auipc	ra,0xffffe
    80004ad8:	748080e7          	jalr	1864(ra) # 8000321c <namei>
    80004adc:	892a                	mv	s2,a0
    80004ade:	c905                	beqz	a0,80004b0e <sys_open+0x13c>
    ilock(ip);
    80004ae0:	ffffe097          	auipc	ra,0xffffe
    80004ae4:	f86080e7          	jalr	-122(ra) # 80002a66 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004ae8:	04491703          	lh	a4,68(s2)
    80004aec:	4785                	li	a5,1
    80004aee:	f4f712e3          	bne	a4,a5,80004a32 <sys_open+0x60>
    80004af2:	f4c42783          	lw	a5,-180(s0)
    80004af6:	dba1                	beqz	a5,80004a46 <sys_open+0x74>
      iunlockput(ip);
    80004af8:	854a                	mv	a0,s2
    80004afa:	ffffe097          	auipc	ra,0xffffe
    80004afe:	1ce080e7          	jalr	462(ra) # 80002cc8 <iunlockput>
      end_op();
    80004b02:	fffff097          	auipc	ra,0xfffff
    80004b06:	9b6080e7          	jalr	-1610(ra) # 800034b8 <end_op>
      return -1;
    80004b0a:	54fd                	li	s1,-1
    80004b0c:	b76d                	j	80004ab6 <sys_open+0xe4>
      end_op();
    80004b0e:	fffff097          	auipc	ra,0xfffff
    80004b12:	9aa080e7          	jalr	-1622(ra) # 800034b8 <end_op>
      return -1;
    80004b16:	54fd                	li	s1,-1
    80004b18:	bf79                	j	80004ab6 <sys_open+0xe4>
    iunlockput(ip);
    80004b1a:	854a                	mv	a0,s2
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	1ac080e7          	jalr	428(ra) # 80002cc8 <iunlockput>
    end_op();
    80004b24:	fffff097          	auipc	ra,0xfffff
    80004b28:	994080e7          	jalr	-1644(ra) # 800034b8 <end_op>
    return -1;
    80004b2c:	54fd                	li	s1,-1
    80004b2e:	b761                	j	80004ab6 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004b30:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004b34:	04691783          	lh	a5,70(s2)
    80004b38:	02f99223          	sh	a5,36(s3)
    80004b3c:	bf2d                	j	80004a76 <sys_open+0xa4>
    itrunc(ip);
    80004b3e:	854a                	mv	a0,s2
    80004b40:	ffffe097          	auipc	ra,0xffffe
    80004b44:	034080e7          	jalr	52(ra) # 80002b74 <itrunc>
    80004b48:	bfb1                	j	80004aa4 <sys_open+0xd2>
      fileclose(f);
    80004b4a:	854e                	mv	a0,s3
    80004b4c:	fffff097          	auipc	ra,0xfffff
    80004b50:	db8080e7          	jalr	-584(ra) # 80003904 <fileclose>
    iunlockput(ip);
    80004b54:	854a                	mv	a0,s2
    80004b56:	ffffe097          	auipc	ra,0xffffe
    80004b5a:	172080e7          	jalr	370(ra) # 80002cc8 <iunlockput>
    end_op();
    80004b5e:	fffff097          	auipc	ra,0xfffff
    80004b62:	95a080e7          	jalr	-1702(ra) # 800034b8 <end_op>
    return -1;
    80004b66:	54fd                	li	s1,-1
    80004b68:	b7b9                	j	80004ab6 <sys_open+0xe4>

0000000080004b6a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004b6a:	7175                	addi	sp,sp,-144
    80004b6c:	e506                	sd	ra,136(sp)
    80004b6e:	e122                	sd	s0,128(sp)
    80004b70:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004b72:	fffff097          	auipc	ra,0xfffff
    80004b76:	8c6080e7          	jalr	-1850(ra) # 80003438 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004b7a:	08000613          	li	a2,128
    80004b7e:	f7040593          	addi	a1,s0,-144
    80004b82:	4501                	li	a0,0
    80004b84:	ffffd097          	auipc	ra,0xffffd
    80004b88:	3b4080e7          	jalr	948(ra) # 80001f38 <argstr>
    80004b8c:	02054963          	bltz	a0,80004bbe <sys_mkdir+0x54>
    80004b90:	4681                	li	a3,0
    80004b92:	4601                	li	a2,0
    80004b94:	4585                	li	a1,1
    80004b96:	f7040513          	addi	a0,s0,-144
    80004b9a:	fffff097          	auipc	ra,0xfffff
    80004b9e:	7fe080e7          	jalr	2046(ra) # 80004398 <create>
    80004ba2:	cd11                	beqz	a0,80004bbe <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ba4:	ffffe097          	auipc	ra,0xffffe
    80004ba8:	124080e7          	jalr	292(ra) # 80002cc8 <iunlockput>
  end_op();
    80004bac:	fffff097          	auipc	ra,0xfffff
    80004bb0:	90c080e7          	jalr	-1780(ra) # 800034b8 <end_op>
  return 0;
    80004bb4:	4501                	li	a0,0
}
    80004bb6:	60aa                	ld	ra,136(sp)
    80004bb8:	640a                	ld	s0,128(sp)
    80004bba:	6149                	addi	sp,sp,144
    80004bbc:	8082                	ret
    end_op();
    80004bbe:	fffff097          	auipc	ra,0xfffff
    80004bc2:	8fa080e7          	jalr	-1798(ra) # 800034b8 <end_op>
    return -1;
    80004bc6:	557d                	li	a0,-1
    80004bc8:	b7fd                	j	80004bb6 <sys_mkdir+0x4c>

0000000080004bca <sys_mknod>:

uint64
sys_mknod(void)
{
    80004bca:	7135                	addi	sp,sp,-160
    80004bcc:	ed06                	sd	ra,152(sp)
    80004bce:	e922                	sd	s0,144(sp)
    80004bd0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004bd2:	fffff097          	auipc	ra,0xfffff
    80004bd6:	866080e7          	jalr	-1946(ra) # 80003438 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004bda:	08000613          	li	a2,128
    80004bde:	f7040593          	addi	a1,s0,-144
    80004be2:	4501                	li	a0,0
    80004be4:	ffffd097          	auipc	ra,0xffffd
    80004be8:	354080e7          	jalr	852(ra) # 80001f38 <argstr>
    80004bec:	04054a63          	bltz	a0,80004c40 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004bf0:	f6c40593          	addi	a1,s0,-148
    80004bf4:	4505                	li	a0,1
    80004bf6:	ffffd097          	auipc	ra,0xffffd
    80004bfa:	2fe080e7          	jalr	766(ra) # 80001ef4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004bfe:	04054163          	bltz	a0,80004c40 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004c02:	f6840593          	addi	a1,s0,-152
    80004c06:	4509                	li	a0,2
    80004c08:	ffffd097          	auipc	ra,0xffffd
    80004c0c:	2ec080e7          	jalr	748(ra) # 80001ef4 <argint>
     argint(1, &major) < 0 ||
    80004c10:	02054863          	bltz	a0,80004c40 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004c14:	f6841683          	lh	a3,-152(s0)
    80004c18:	f6c41603          	lh	a2,-148(s0)
    80004c1c:	458d                	li	a1,3
    80004c1e:	f7040513          	addi	a0,s0,-144
    80004c22:	fffff097          	auipc	ra,0xfffff
    80004c26:	776080e7          	jalr	1910(ra) # 80004398 <create>
     argint(2, &minor) < 0 ||
    80004c2a:	c919                	beqz	a0,80004c40 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	09c080e7          	jalr	156(ra) # 80002cc8 <iunlockput>
  end_op();
    80004c34:	fffff097          	auipc	ra,0xfffff
    80004c38:	884080e7          	jalr	-1916(ra) # 800034b8 <end_op>
  return 0;
    80004c3c:	4501                	li	a0,0
    80004c3e:	a031                	j	80004c4a <sys_mknod+0x80>
    end_op();
    80004c40:	fffff097          	auipc	ra,0xfffff
    80004c44:	878080e7          	jalr	-1928(ra) # 800034b8 <end_op>
    return -1;
    80004c48:	557d                	li	a0,-1
}
    80004c4a:	60ea                	ld	ra,152(sp)
    80004c4c:	644a                	ld	s0,144(sp)
    80004c4e:	610d                	addi	sp,sp,160
    80004c50:	8082                	ret

0000000080004c52 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004c52:	7135                	addi	sp,sp,-160
    80004c54:	ed06                	sd	ra,152(sp)
    80004c56:	e922                	sd	s0,144(sp)
    80004c58:	e526                	sd	s1,136(sp)
    80004c5a:	e14a                	sd	s2,128(sp)
    80004c5c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004c5e:	ffffc097          	auipc	ra,0xffffc
    80004c62:	1ea080e7          	jalr	490(ra) # 80000e48 <myproc>
    80004c66:	892a                	mv	s2,a0
  
  begin_op();
    80004c68:	ffffe097          	auipc	ra,0xffffe
    80004c6c:	7d0080e7          	jalr	2000(ra) # 80003438 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004c70:	08000613          	li	a2,128
    80004c74:	f6040593          	addi	a1,s0,-160
    80004c78:	4501                	li	a0,0
    80004c7a:	ffffd097          	auipc	ra,0xffffd
    80004c7e:	2be080e7          	jalr	702(ra) # 80001f38 <argstr>
    80004c82:	04054b63          	bltz	a0,80004cd8 <sys_chdir+0x86>
    80004c86:	f6040513          	addi	a0,s0,-160
    80004c8a:	ffffe097          	auipc	ra,0xffffe
    80004c8e:	592080e7          	jalr	1426(ra) # 8000321c <namei>
    80004c92:	84aa                	mv	s1,a0
    80004c94:	c131                	beqz	a0,80004cd8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004c96:	ffffe097          	auipc	ra,0xffffe
    80004c9a:	dd0080e7          	jalr	-560(ra) # 80002a66 <ilock>
  if(ip->type != T_DIR){
    80004c9e:	04449703          	lh	a4,68(s1)
    80004ca2:	4785                	li	a5,1
    80004ca4:	04f71063          	bne	a4,a5,80004ce4 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ca8:	8526                	mv	a0,s1
    80004caa:	ffffe097          	auipc	ra,0xffffe
    80004cae:	e7e080e7          	jalr	-386(ra) # 80002b28 <iunlock>
  iput(p->cwd);
    80004cb2:	15093503          	ld	a0,336(s2)
    80004cb6:	ffffe097          	auipc	ra,0xffffe
    80004cba:	f6a080e7          	jalr	-150(ra) # 80002c20 <iput>
  end_op();
    80004cbe:	ffffe097          	auipc	ra,0xffffe
    80004cc2:	7fa080e7          	jalr	2042(ra) # 800034b8 <end_op>
  p->cwd = ip;
    80004cc6:	14993823          	sd	s1,336(s2)
  return 0;
    80004cca:	4501                	li	a0,0
}
    80004ccc:	60ea                	ld	ra,152(sp)
    80004cce:	644a                	ld	s0,144(sp)
    80004cd0:	64aa                	ld	s1,136(sp)
    80004cd2:	690a                	ld	s2,128(sp)
    80004cd4:	610d                	addi	sp,sp,160
    80004cd6:	8082                	ret
    end_op();
    80004cd8:	ffffe097          	auipc	ra,0xffffe
    80004cdc:	7e0080e7          	jalr	2016(ra) # 800034b8 <end_op>
    return -1;
    80004ce0:	557d                	li	a0,-1
    80004ce2:	b7ed                	j	80004ccc <sys_chdir+0x7a>
    iunlockput(ip);
    80004ce4:	8526                	mv	a0,s1
    80004ce6:	ffffe097          	auipc	ra,0xffffe
    80004cea:	fe2080e7          	jalr	-30(ra) # 80002cc8 <iunlockput>
    end_op();
    80004cee:	ffffe097          	auipc	ra,0xffffe
    80004cf2:	7ca080e7          	jalr	1994(ra) # 800034b8 <end_op>
    return -1;
    80004cf6:	557d                	li	a0,-1
    80004cf8:	bfd1                	j	80004ccc <sys_chdir+0x7a>

0000000080004cfa <sys_exec>:

uint64
sys_exec(void)
{
    80004cfa:	7145                	addi	sp,sp,-464
    80004cfc:	e786                	sd	ra,456(sp)
    80004cfe:	e3a2                	sd	s0,448(sp)
    80004d00:	ff26                	sd	s1,440(sp)
    80004d02:	fb4a                	sd	s2,432(sp)
    80004d04:	f74e                	sd	s3,424(sp)
    80004d06:	f352                	sd	s4,416(sp)
    80004d08:	ef56                	sd	s5,408(sp)
    80004d0a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004d0c:	08000613          	li	a2,128
    80004d10:	f4040593          	addi	a1,s0,-192
    80004d14:	4501                	li	a0,0
    80004d16:	ffffd097          	auipc	ra,0xffffd
    80004d1a:	222080e7          	jalr	546(ra) # 80001f38 <argstr>
    return -1;
    80004d1e:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004d20:	0c054a63          	bltz	a0,80004df4 <sys_exec+0xfa>
    80004d24:	e3840593          	addi	a1,s0,-456
    80004d28:	4505                	li	a0,1
    80004d2a:	ffffd097          	auipc	ra,0xffffd
    80004d2e:	1ec080e7          	jalr	492(ra) # 80001f16 <argaddr>
    80004d32:	0c054163          	bltz	a0,80004df4 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004d36:	10000613          	li	a2,256
    80004d3a:	4581                	li	a1,0
    80004d3c:	e4040513          	addi	a0,s0,-448
    80004d40:	ffffb097          	auipc	ra,0xffffb
    80004d44:	438080e7          	jalr	1080(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004d48:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004d4c:	89a6                	mv	s3,s1
    80004d4e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004d50:	02000a13          	li	s4,32
    80004d54:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004d58:	00391513          	slli	a0,s2,0x3
    80004d5c:	e3040593          	addi	a1,s0,-464
    80004d60:	e3843783          	ld	a5,-456(s0)
    80004d64:	953e                	add	a0,a0,a5
    80004d66:	ffffd097          	auipc	ra,0xffffd
    80004d6a:	0f4080e7          	jalr	244(ra) # 80001e5a <fetchaddr>
    80004d6e:	02054a63          	bltz	a0,80004da2 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004d72:	e3043783          	ld	a5,-464(s0)
    80004d76:	c3b9                	beqz	a5,80004dbc <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004d78:	ffffb097          	auipc	ra,0xffffb
    80004d7c:	3a0080e7          	jalr	928(ra) # 80000118 <kalloc>
    80004d80:	85aa                	mv	a1,a0
    80004d82:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004d86:	cd11                	beqz	a0,80004da2 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004d88:	6605                	lui	a2,0x1
    80004d8a:	e3043503          	ld	a0,-464(s0)
    80004d8e:	ffffd097          	auipc	ra,0xffffd
    80004d92:	11e080e7          	jalr	286(ra) # 80001eac <fetchstr>
    80004d96:	00054663          	bltz	a0,80004da2 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004d9a:	0905                	addi	s2,s2,1
    80004d9c:	09a1                	addi	s3,s3,8
    80004d9e:	fb491be3          	bne	s2,s4,80004d54 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004da2:	10048913          	addi	s2,s1,256
    80004da6:	6088                	ld	a0,0(s1)
    80004da8:	c529                	beqz	a0,80004df2 <sys_exec+0xf8>
    kfree(argv[i]);
    80004daa:	ffffb097          	auipc	ra,0xffffb
    80004dae:	272080e7          	jalr	626(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004db2:	04a1                	addi	s1,s1,8
    80004db4:	ff2499e3          	bne	s1,s2,80004da6 <sys_exec+0xac>
  return -1;
    80004db8:	597d                	li	s2,-1
    80004dba:	a82d                	j	80004df4 <sys_exec+0xfa>
      argv[i] = 0;
    80004dbc:	0a8e                	slli	s5,s5,0x3
    80004dbe:	fc040793          	addi	a5,s0,-64
    80004dc2:	9abe                	add	s5,s5,a5
    80004dc4:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004dc8:	e4040593          	addi	a1,s0,-448
    80004dcc:	f4040513          	addi	a0,s0,-192
    80004dd0:	fffff097          	auipc	ra,0xfffff
    80004dd4:	194080e7          	jalr	404(ra) # 80003f64 <exec>
    80004dd8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004dda:	10048993          	addi	s3,s1,256
    80004dde:	6088                	ld	a0,0(s1)
    80004de0:	c911                	beqz	a0,80004df4 <sys_exec+0xfa>
    kfree(argv[i]);
    80004de2:	ffffb097          	auipc	ra,0xffffb
    80004de6:	23a080e7          	jalr	570(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004dea:	04a1                	addi	s1,s1,8
    80004dec:	ff3499e3          	bne	s1,s3,80004dde <sys_exec+0xe4>
    80004df0:	a011                	j	80004df4 <sys_exec+0xfa>
  return -1;
    80004df2:	597d                	li	s2,-1
}
    80004df4:	854a                	mv	a0,s2
    80004df6:	60be                	ld	ra,456(sp)
    80004df8:	641e                	ld	s0,448(sp)
    80004dfa:	74fa                	ld	s1,440(sp)
    80004dfc:	795a                	ld	s2,432(sp)
    80004dfe:	79ba                	ld	s3,424(sp)
    80004e00:	7a1a                	ld	s4,416(sp)
    80004e02:	6afa                	ld	s5,408(sp)
    80004e04:	6179                	addi	sp,sp,464
    80004e06:	8082                	ret

0000000080004e08 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004e08:	7139                	addi	sp,sp,-64
    80004e0a:	fc06                	sd	ra,56(sp)
    80004e0c:	f822                	sd	s0,48(sp)
    80004e0e:	f426                	sd	s1,40(sp)
    80004e10:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004e12:	ffffc097          	auipc	ra,0xffffc
    80004e16:	036080e7          	jalr	54(ra) # 80000e48 <myproc>
    80004e1a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004e1c:	fd840593          	addi	a1,s0,-40
    80004e20:	4501                	li	a0,0
    80004e22:	ffffd097          	auipc	ra,0xffffd
    80004e26:	0f4080e7          	jalr	244(ra) # 80001f16 <argaddr>
    return -1;
    80004e2a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004e2c:	0e054063          	bltz	a0,80004f0c <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004e30:	fc840593          	addi	a1,s0,-56
    80004e34:	fd040513          	addi	a0,s0,-48
    80004e38:	fffff097          	auipc	ra,0xfffff
    80004e3c:	dfc080e7          	jalr	-516(ra) # 80003c34 <pipealloc>
    return -1;
    80004e40:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004e42:	0c054563          	bltz	a0,80004f0c <sys_pipe+0x104>
  fd0 = -1;
    80004e46:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004e4a:	fd043503          	ld	a0,-48(s0)
    80004e4e:	fffff097          	auipc	ra,0xfffff
    80004e52:	508080e7          	jalr	1288(ra) # 80004356 <fdalloc>
    80004e56:	fca42223          	sw	a0,-60(s0)
    80004e5a:	08054c63          	bltz	a0,80004ef2 <sys_pipe+0xea>
    80004e5e:	fc843503          	ld	a0,-56(s0)
    80004e62:	fffff097          	auipc	ra,0xfffff
    80004e66:	4f4080e7          	jalr	1268(ra) # 80004356 <fdalloc>
    80004e6a:	fca42023          	sw	a0,-64(s0)
    80004e6e:	06054863          	bltz	a0,80004ede <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004e72:	4691                	li	a3,4
    80004e74:	fc440613          	addi	a2,s0,-60
    80004e78:	fd843583          	ld	a1,-40(s0)
    80004e7c:	68a8                	ld	a0,80(s1)
    80004e7e:	ffffc097          	auipc	ra,0xffffc
    80004e82:	c8c080e7          	jalr	-884(ra) # 80000b0a <copyout>
    80004e86:	02054063          	bltz	a0,80004ea6 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004e8a:	4691                	li	a3,4
    80004e8c:	fc040613          	addi	a2,s0,-64
    80004e90:	fd843583          	ld	a1,-40(s0)
    80004e94:	0591                	addi	a1,a1,4
    80004e96:	68a8                	ld	a0,80(s1)
    80004e98:	ffffc097          	auipc	ra,0xffffc
    80004e9c:	c72080e7          	jalr	-910(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004ea0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004ea2:	06055563          	bgez	a0,80004f0c <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004ea6:	fc442783          	lw	a5,-60(s0)
    80004eaa:	07e9                	addi	a5,a5,26
    80004eac:	078e                	slli	a5,a5,0x3
    80004eae:	97a6                	add	a5,a5,s1
    80004eb0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004eb4:	fc042503          	lw	a0,-64(s0)
    80004eb8:	0569                	addi	a0,a0,26
    80004eba:	050e                	slli	a0,a0,0x3
    80004ebc:	9526                	add	a0,a0,s1
    80004ebe:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004ec2:	fd043503          	ld	a0,-48(s0)
    80004ec6:	fffff097          	auipc	ra,0xfffff
    80004eca:	a3e080e7          	jalr	-1474(ra) # 80003904 <fileclose>
    fileclose(wf);
    80004ece:	fc843503          	ld	a0,-56(s0)
    80004ed2:	fffff097          	auipc	ra,0xfffff
    80004ed6:	a32080e7          	jalr	-1486(ra) # 80003904 <fileclose>
    return -1;
    80004eda:	57fd                	li	a5,-1
    80004edc:	a805                	j	80004f0c <sys_pipe+0x104>
    if(fd0 >= 0)
    80004ede:	fc442783          	lw	a5,-60(s0)
    80004ee2:	0007c863          	bltz	a5,80004ef2 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80004ee6:	01a78513          	addi	a0,a5,26
    80004eea:	050e                	slli	a0,a0,0x3
    80004eec:	9526                	add	a0,a0,s1
    80004eee:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004ef2:	fd043503          	ld	a0,-48(s0)
    80004ef6:	fffff097          	auipc	ra,0xfffff
    80004efa:	a0e080e7          	jalr	-1522(ra) # 80003904 <fileclose>
    fileclose(wf);
    80004efe:	fc843503          	ld	a0,-56(s0)
    80004f02:	fffff097          	auipc	ra,0xfffff
    80004f06:	a02080e7          	jalr	-1534(ra) # 80003904 <fileclose>
    return -1;
    80004f0a:	57fd                	li	a5,-1
}
    80004f0c:	853e                	mv	a0,a5
    80004f0e:	70e2                	ld	ra,56(sp)
    80004f10:	7442                	ld	s0,48(sp)
    80004f12:	74a2                	ld	s1,40(sp)
    80004f14:	6121                	addi	sp,sp,64
    80004f16:	8082                	ret
	...

0000000080004f20 <kernelvec>:
    80004f20:	7111                	addi	sp,sp,-256
    80004f22:	e006                	sd	ra,0(sp)
    80004f24:	e40a                	sd	sp,8(sp)
    80004f26:	e80e                	sd	gp,16(sp)
    80004f28:	ec12                	sd	tp,24(sp)
    80004f2a:	f016                	sd	t0,32(sp)
    80004f2c:	f41a                	sd	t1,40(sp)
    80004f2e:	f81e                	sd	t2,48(sp)
    80004f30:	fc22                	sd	s0,56(sp)
    80004f32:	e0a6                	sd	s1,64(sp)
    80004f34:	e4aa                	sd	a0,72(sp)
    80004f36:	e8ae                	sd	a1,80(sp)
    80004f38:	ecb2                	sd	a2,88(sp)
    80004f3a:	f0b6                	sd	a3,96(sp)
    80004f3c:	f4ba                	sd	a4,104(sp)
    80004f3e:	f8be                	sd	a5,112(sp)
    80004f40:	fcc2                	sd	a6,120(sp)
    80004f42:	e146                	sd	a7,128(sp)
    80004f44:	e54a                	sd	s2,136(sp)
    80004f46:	e94e                	sd	s3,144(sp)
    80004f48:	ed52                	sd	s4,152(sp)
    80004f4a:	f156                	sd	s5,160(sp)
    80004f4c:	f55a                	sd	s6,168(sp)
    80004f4e:	f95e                	sd	s7,176(sp)
    80004f50:	fd62                	sd	s8,184(sp)
    80004f52:	e1e6                	sd	s9,192(sp)
    80004f54:	e5ea                	sd	s10,200(sp)
    80004f56:	e9ee                	sd	s11,208(sp)
    80004f58:	edf2                	sd	t3,216(sp)
    80004f5a:	f1f6                	sd	t4,224(sp)
    80004f5c:	f5fa                	sd	t5,232(sp)
    80004f5e:	f9fe                	sd	t6,240(sp)
    80004f60:	dc7fc0ef          	jal	ra,80001d26 <kerneltrap>
    80004f64:	6082                	ld	ra,0(sp)
    80004f66:	6122                	ld	sp,8(sp)
    80004f68:	61c2                	ld	gp,16(sp)
    80004f6a:	7282                	ld	t0,32(sp)
    80004f6c:	7322                	ld	t1,40(sp)
    80004f6e:	73c2                	ld	t2,48(sp)
    80004f70:	7462                	ld	s0,56(sp)
    80004f72:	6486                	ld	s1,64(sp)
    80004f74:	6526                	ld	a0,72(sp)
    80004f76:	65c6                	ld	a1,80(sp)
    80004f78:	6666                	ld	a2,88(sp)
    80004f7a:	7686                	ld	a3,96(sp)
    80004f7c:	7726                	ld	a4,104(sp)
    80004f7e:	77c6                	ld	a5,112(sp)
    80004f80:	7866                	ld	a6,120(sp)
    80004f82:	688a                	ld	a7,128(sp)
    80004f84:	692a                	ld	s2,136(sp)
    80004f86:	69ca                	ld	s3,144(sp)
    80004f88:	6a6a                	ld	s4,152(sp)
    80004f8a:	7a8a                	ld	s5,160(sp)
    80004f8c:	7b2a                	ld	s6,168(sp)
    80004f8e:	7bca                	ld	s7,176(sp)
    80004f90:	7c6a                	ld	s8,184(sp)
    80004f92:	6c8e                	ld	s9,192(sp)
    80004f94:	6d2e                	ld	s10,200(sp)
    80004f96:	6dce                	ld	s11,208(sp)
    80004f98:	6e6e                	ld	t3,216(sp)
    80004f9a:	7e8e                	ld	t4,224(sp)
    80004f9c:	7f2e                	ld	t5,232(sp)
    80004f9e:	7fce                	ld	t6,240(sp)
    80004fa0:	6111                	addi	sp,sp,256
    80004fa2:	10200073          	sret
    80004fa6:	00000013          	nop
    80004faa:	00000013          	nop
    80004fae:	0001                	nop

0000000080004fb0 <timervec>:
    80004fb0:	34051573          	csrrw	a0,mscratch,a0
    80004fb4:	e10c                	sd	a1,0(a0)
    80004fb6:	e510                	sd	a2,8(a0)
    80004fb8:	e914                	sd	a3,16(a0)
    80004fba:	6d0c                	ld	a1,24(a0)
    80004fbc:	7110                	ld	a2,32(a0)
    80004fbe:	6194                	ld	a3,0(a1)
    80004fc0:	96b2                	add	a3,a3,a2
    80004fc2:	e194                	sd	a3,0(a1)
    80004fc4:	4589                	li	a1,2
    80004fc6:	14459073          	csrw	sip,a1
    80004fca:	6914                	ld	a3,16(a0)
    80004fcc:	6510                	ld	a2,8(a0)
    80004fce:	610c                	ld	a1,0(a0)
    80004fd0:	34051573          	csrrw	a0,mscratch,a0
    80004fd4:	30200073          	mret
	...

0000000080004fda <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004fda:	1141                	addi	sp,sp,-16
    80004fdc:	e422                	sd	s0,8(sp)
    80004fde:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004fe0:	0c0007b7          	lui	a5,0xc000
    80004fe4:	4705                	li	a4,1
    80004fe6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80004fe8:	c3d8                	sw	a4,4(a5)
}
    80004fea:	6422                	ld	s0,8(sp)
    80004fec:	0141                	addi	sp,sp,16
    80004fee:	8082                	ret

0000000080004ff0 <plicinithart>:

void
plicinithart(void)
{
    80004ff0:	1141                	addi	sp,sp,-16
    80004ff2:	e406                	sd	ra,8(sp)
    80004ff4:	e022                	sd	s0,0(sp)
    80004ff6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004ff8:	ffffc097          	auipc	ra,0xffffc
    80004ffc:	e24080e7          	jalr	-476(ra) # 80000e1c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005000:	0085171b          	slliw	a4,a0,0x8
    80005004:	0c0027b7          	lui	a5,0xc002
    80005008:	97ba                	add	a5,a5,a4
    8000500a:	40200713          	li	a4,1026
    8000500e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005012:	00d5151b          	slliw	a0,a0,0xd
    80005016:	0c2017b7          	lui	a5,0xc201
    8000501a:	953e                	add	a0,a0,a5
    8000501c:	00052023          	sw	zero,0(a0)
}
    80005020:	60a2                	ld	ra,8(sp)
    80005022:	6402                	ld	s0,0(sp)
    80005024:	0141                	addi	sp,sp,16
    80005026:	8082                	ret

0000000080005028 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005028:	1141                	addi	sp,sp,-16
    8000502a:	e406                	sd	ra,8(sp)
    8000502c:	e022                	sd	s0,0(sp)
    8000502e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005030:	ffffc097          	auipc	ra,0xffffc
    80005034:	dec080e7          	jalr	-532(ra) # 80000e1c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005038:	00d5179b          	slliw	a5,a0,0xd
    8000503c:	0c201537          	lui	a0,0xc201
    80005040:	953e                	add	a0,a0,a5
  return irq;
}
    80005042:	4148                	lw	a0,4(a0)
    80005044:	60a2                	ld	ra,8(sp)
    80005046:	6402                	ld	s0,0(sp)
    80005048:	0141                	addi	sp,sp,16
    8000504a:	8082                	ret

000000008000504c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000504c:	1101                	addi	sp,sp,-32
    8000504e:	ec06                	sd	ra,24(sp)
    80005050:	e822                	sd	s0,16(sp)
    80005052:	e426                	sd	s1,8(sp)
    80005054:	1000                	addi	s0,sp,32
    80005056:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005058:	ffffc097          	auipc	ra,0xffffc
    8000505c:	dc4080e7          	jalr	-572(ra) # 80000e1c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005060:	00d5151b          	slliw	a0,a0,0xd
    80005064:	0c2017b7          	lui	a5,0xc201
    80005068:	97aa                	add	a5,a5,a0
    8000506a:	c3c4                	sw	s1,4(a5)
}
    8000506c:	60e2                	ld	ra,24(sp)
    8000506e:	6442                	ld	s0,16(sp)
    80005070:	64a2                	ld	s1,8(sp)
    80005072:	6105                	addi	sp,sp,32
    80005074:	8082                	ret

0000000080005076 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005076:	1141                	addi	sp,sp,-16
    80005078:	e406                	sd	ra,8(sp)
    8000507a:	e022                	sd	s0,0(sp)
    8000507c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000507e:	479d                	li	a5,7
    80005080:	06a7c963          	blt	a5,a0,800050f2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005084:	00016797          	auipc	a5,0x16
    80005088:	f7c78793          	addi	a5,a5,-132 # 8001b000 <disk>
    8000508c:	00a78733          	add	a4,a5,a0
    80005090:	6789                	lui	a5,0x2
    80005092:	97ba                	add	a5,a5,a4
    80005094:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005098:	e7ad                	bnez	a5,80005102 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000509a:	00451793          	slli	a5,a0,0x4
    8000509e:	00018717          	auipc	a4,0x18
    800050a2:	f6270713          	addi	a4,a4,-158 # 8001d000 <disk+0x2000>
    800050a6:	6314                	ld	a3,0(a4)
    800050a8:	96be                	add	a3,a3,a5
    800050aa:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800050ae:	6314                	ld	a3,0(a4)
    800050b0:	96be                	add	a3,a3,a5
    800050b2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800050b6:	6314                	ld	a3,0(a4)
    800050b8:	96be                	add	a3,a3,a5
    800050ba:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800050be:	6318                	ld	a4,0(a4)
    800050c0:	97ba                	add	a5,a5,a4
    800050c2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800050c6:	00016797          	auipc	a5,0x16
    800050ca:	f3a78793          	addi	a5,a5,-198 # 8001b000 <disk>
    800050ce:	97aa                	add	a5,a5,a0
    800050d0:	6509                	lui	a0,0x2
    800050d2:	953e                	add	a0,a0,a5
    800050d4:	4785                	li	a5,1
    800050d6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800050da:	00018517          	auipc	a0,0x18
    800050de:	f3e50513          	addi	a0,a0,-194 # 8001d018 <disk+0x2018>
    800050e2:	ffffc097          	auipc	ra,0xffffc
    800050e6:	5ae080e7          	jalr	1454(ra) # 80001690 <wakeup>
}
    800050ea:	60a2                	ld	ra,8(sp)
    800050ec:	6402                	ld	s0,0(sp)
    800050ee:	0141                	addi	sp,sp,16
    800050f0:	8082                	ret
    panic("free_desc 1");
    800050f2:	00003517          	auipc	a0,0x3
    800050f6:	5f650513          	addi	a0,a0,1526 # 800086e8 <syscalls+0x320>
    800050fa:	00001097          	auipc	ra,0x1
    800050fe:	a1e080e7          	jalr	-1506(ra) # 80005b18 <panic>
    panic("free_desc 2");
    80005102:	00003517          	auipc	a0,0x3
    80005106:	5f650513          	addi	a0,a0,1526 # 800086f8 <syscalls+0x330>
    8000510a:	00001097          	auipc	ra,0x1
    8000510e:	a0e080e7          	jalr	-1522(ra) # 80005b18 <panic>

0000000080005112 <virtio_disk_init>:
{
    80005112:	1101                	addi	sp,sp,-32
    80005114:	ec06                	sd	ra,24(sp)
    80005116:	e822                	sd	s0,16(sp)
    80005118:	e426                	sd	s1,8(sp)
    8000511a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000511c:	00003597          	auipc	a1,0x3
    80005120:	5ec58593          	addi	a1,a1,1516 # 80008708 <syscalls+0x340>
    80005124:	00018517          	auipc	a0,0x18
    80005128:	00450513          	addi	a0,a0,4 # 8001d128 <disk+0x2128>
    8000512c:	00001097          	auipc	ra,0x1
    80005130:	ea6080e7          	jalr	-346(ra) # 80005fd2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005134:	100017b7          	lui	a5,0x10001
    80005138:	4398                	lw	a4,0(a5)
    8000513a:	2701                	sext.w	a4,a4
    8000513c:	747277b7          	lui	a5,0x74727
    80005140:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005144:	0ef71163          	bne	a4,a5,80005226 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005148:	100017b7          	lui	a5,0x10001
    8000514c:	43dc                	lw	a5,4(a5)
    8000514e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005150:	4705                	li	a4,1
    80005152:	0ce79a63          	bne	a5,a4,80005226 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005156:	100017b7          	lui	a5,0x10001
    8000515a:	479c                	lw	a5,8(a5)
    8000515c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000515e:	4709                	li	a4,2
    80005160:	0ce79363          	bne	a5,a4,80005226 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005164:	100017b7          	lui	a5,0x10001
    80005168:	47d8                	lw	a4,12(a5)
    8000516a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000516c:	554d47b7          	lui	a5,0x554d4
    80005170:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005174:	0af71963          	bne	a4,a5,80005226 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005178:	100017b7          	lui	a5,0x10001
    8000517c:	4705                	li	a4,1
    8000517e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005180:	470d                	li	a4,3
    80005182:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005184:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005186:	c7ffe737          	lui	a4,0xc7ffe
    8000518a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000518e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005190:	2701                	sext.w	a4,a4
    80005192:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005194:	472d                	li	a4,11
    80005196:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005198:	473d                	li	a4,15
    8000519a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000519c:	6705                	lui	a4,0x1
    8000519e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800051a0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800051a4:	5bdc                	lw	a5,52(a5)
    800051a6:	2781                	sext.w	a5,a5
  if(max == 0)
    800051a8:	c7d9                	beqz	a5,80005236 <virtio_disk_init+0x124>
  if(max < NUM)
    800051aa:	471d                	li	a4,7
    800051ac:	08f77d63          	bgeu	a4,a5,80005246 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800051b0:	100014b7          	lui	s1,0x10001
    800051b4:	47a1                	li	a5,8
    800051b6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800051b8:	6609                	lui	a2,0x2
    800051ba:	4581                	li	a1,0
    800051bc:	00016517          	auipc	a0,0x16
    800051c0:	e4450513          	addi	a0,a0,-444 # 8001b000 <disk>
    800051c4:	ffffb097          	auipc	ra,0xffffb
    800051c8:	fb4080e7          	jalr	-76(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800051cc:	00016717          	auipc	a4,0x16
    800051d0:	e3470713          	addi	a4,a4,-460 # 8001b000 <disk>
    800051d4:	00c75793          	srli	a5,a4,0xc
    800051d8:	2781                	sext.w	a5,a5
    800051da:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800051dc:	00018797          	auipc	a5,0x18
    800051e0:	e2478793          	addi	a5,a5,-476 # 8001d000 <disk+0x2000>
    800051e4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800051e6:	00016717          	auipc	a4,0x16
    800051ea:	e9a70713          	addi	a4,a4,-358 # 8001b080 <disk+0x80>
    800051ee:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800051f0:	00017717          	auipc	a4,0x17
    800051f4:	e1070713          	addi	a4,a4,-496 # 8001c000 <disk+0x1000>
    800051f8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800051fa:	4705                	li	a4,1
    800051fc:	00e78c23          	sb	a4,24(a5)
    80005200:	00e78ca3          	sb	a4,25(a5)
    80005204:	00e78d23          	sb	a4,26(a5)
    80005208:	00e78da3          	sb	a4,27(a5)
    8000520c:	00e78e23          	sb	a4,28(a5)
    80005210:	00e78ea3          	sb	a4,29(a5)
    80005214:	00e78f23          	sb	a4,30(a5)
    80005218:	00e78fa3          	sb	a4,31(a5)
}
    8000521c:	60e2                	ld	ra,24(sp)
    8000521e:	6442                	ld	s0,16(sp)
    80005220:	64a2                	ld	s1,8(sp)
    80005222:	6105                	addi	sp,sp,32
    80005224:	8082                	ret
    panic("could not find virtio disk");
    80005226:	00003517          	auipc	a0,0x3
    8000522a:	4f250513          	addi	a0,a0,1266 # 80008718 <syscalls+0x350>
    8000522e:	00001097          	auipc	ra,0x1
    80005232:	8ea080e7          	jalr	-1814(ra) # 80005b18 <panic>
    panic("virtio disk has no queue 0");
    80005236:	00003517          	auipc	a0,0x3
    8000523a:	50250513          	addi	a0,a0,1282 # 80008738 <syscalls+0x370>
    8000523e:	00001097          	auipc	ra,0x1
    80005242:	8da080e7          	jalr	-1830(ra) # 80005b18 <panic>
    panic("virtio disk max queue too short");
    80005246:	00003517          	auipc	a0,0x3
    8000524a:	51250513          	addi	a0,a0,1298 # 80008758 <syscalls+0x390>
    8000524e:	00001097          	auipc	ra,0x1
    80005252:	8ca080e7          	jalr	-1846(ra) # 80005b18 <panic>

0000000080005256 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005256:	7159                	addi	sp,sp,-112
    80005258:	f486                	sd	ra,104(sp)
    8000525a:	f0a2                	sd	s0,96(sp)
    8000525c:	eca6                	sd	s1,88(sp)
    8000525e:	e8ca                	sd	s2,80(sp)
    80005260:	e4ce                	sd	s3,72(sp)
    80005262:	e0d2                	sd	s4,64(sp)
    80005264:	fc56                	sd	s5,56(sp)
    80005266:	f85a                	sd	s6,48(sp)
    80005268:	f45e                	sd	s7,40(sp)
    8000526a:	f062                	sd	s8,32(sp)
    8000526c:	ec66                	sd	s9,24(sp)
    8000526e:	e86a                	sd	s10,16(sp)
    80005270:	1880                	addi	s0,sp,112
    80005272:	892a                	mv	s2,a0
    80005274:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005276:	00c52c83          	lw	s9,12(a0)
    8000527a:	001c9c9b          	slliw	s9,s9,0x1
    8000527e:	1c82                	slli	s9,s9,0x20
    80005280:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005284:	00018517          	auipc	a0,0x18
    80005288:	ea450513          	addi	a0,a0,-348 # 8001d128 <disk+0x2128>
    8000528c:	00001097          	auipc	ra,0x1
    80005290:	dd6080e7          	jalr	-554(ra) # 80006062 <acquire>
  for(int i = 0; i < 3; i++){
    80005294:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005296:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005298:	00016b97          	auipc	s7,0x16
    8000529c:	d68b8b93          	addi	s7,s7,-664 # 8001b000 <disk>
    800052a0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800052a2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800052a4:	8a4e                	mv	s4,s3
    800052a6:	a051                	j	8000532a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800052a8:	00fb86b3          	add	a3,s7,a5
    800052ac:	96da                	add	a3,a3,s6
    800052ae:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800052b2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800052b4:	0207c563          	bltz	a5,800052de <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800052b8:	2485                	addiw	s1,s1,1
    800052ba:	0711                	addi	a4,a4,4
    800052bc:	25548063          	beq	s1,s5,800054fc <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800052c0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800052c2:	00018697          	auipc	a3,0x18
    800052c6:	d5668693          	addi	a3,a3,-682 # 8001d018 <disk+0x2018>
    800052ca:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800052cc:	0006c583          	lbu	a1,0(a3)
    800052d0:	fde1                	bnez	a1,800052a8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800052d2:	2785                	addiw	a5,a5,1
    800052d4:	0685                	addi	a3,a3,1
    800052d6:	ff879be3          	bne	a5,s8,800052cc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800052da:	57fd                	li	a5,-1
    800052dc:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800052de:	02905a63          	blez	s1,80005312 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800052e2:	f9042503          	lw	a0,-112(s0)
    800052e6:	00000097          	auipc	ra,0x0
    800052ea:	d90080e7          	jalr	-624(ra) # 80005076 <free_desc>
      for(int j = 0; j < i; j++)
    800052ee:	4785                	li	a5,1
    800052f0:	0297d163          	bge	a5,s1,80005312 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800052f4:	f9442503          	lw	a0,-108(s0)
    800052f8:	00000097          	auipc	ra,0x0
    800052fc:	d7e080e7          	jalr	-642(ra) # 80005076 <free_desc>
      for(int j = 0; j < i; j++)
    80005300:	4789                	li	a5,2
    80005302:	0097d863          	bge	a5,s1,80005312 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005306:	f9842503          	lw	a0,-104(s0)
    8000530a:	00000097          	auipc	ra,0x0
    8000530e:	d6c080e7          	jalr	-660(ra) # 80005076 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005312:	00018597          	auipc	a1,0x18
    80005316:	e1658593          	addi	a1,a1,-490 # 8001d128 <disk+0x2128>
    8000531a:	00018517          	auipc	a0,0x18
    8000531e:	cfe50513          	addi	a0,a0,-770 # 8001d018 <disk+0x2018>
    80005322:	ffffc097          	auipc	ra,0xffffc
    80005326:	1e2080e7          	jalr	482(ra) # 80001504 <sleep>
  for(int i = 0; i < 3; i++){
    8000532a:	f9040713          	addi	a4,s0,-112
    8000532e:	84ce                	mv	s1,s3
    80005330:	bf41                	j	800052c0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005332:	20058713          	addi	a4,a1,512
    80005336:	00471693          	slli	a3,a4,0x4
    8000533a:	00016717          	auipc	a4,0x16
    8000533e:	cc670713          	addi	a4,a4,-826 # 8001b000 <disk>
    80005342:	9736                	add	a4,a4,a3
    80005344:	4685                	li	a3,1
    80005346:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000534a:	20058713          	addi	a4,a1,512
    8000534e:	00471693          	slli	a3,a4,0x4
    80005352:	00016717          	auipc	a4,0x16
    80005356:	cae70713          	addi	a4,a4,-850 # 8001b000 <disk>
    8000535a:	9736                	add	a4,a4,a3
    8000535c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005360:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005364:	7679                	lui	a2,0xffffe
    80005366:	963e                	add	a2,a2,a5
    80005368:	00018697          	auipc	a3,0x18
    8000536c:	c9868693          	addi	a3,a3,-872 # 8001d000 <disk+0x2000>
    80005370:	6298                	ld	a4,0(a3)
    80005372:	9732                	add	a4,a4,a2
    80005374:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005376:	6298                	ld	a4,0(a3)
    80005378:	9732                	add	a4,a4,a2
    8000537a:	4541                	li	a0,16
    8000537c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000537e:	6298                	ld	a4,0(a3)
    80005380:	9732                	add	a4,a4,a2
    80005382:	4505                	li	a0,1
    80005384:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005388:	f9442703          	lw	a4,-108(s0)
    8000538c:	6288                	ld	a0,0(a3)
    8000538e:	962a                	add	a2,a2,a0
    80005390:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005394:	0712                	slli	a4,a4,0x4
    80005396:	6290                	ld	a2,0(a3)
    80005398:	963a                	add	a2,a2,a4
    8000539a:	05890513          	addi	a0,s2,88
    8000539e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800053a0:	6294                	ld	a3,0(a3)
    800053a2:	96ba                	add	a3,a3,a4
    800053a4:	40000613          	li	a2,1024
    800053a8:	c690                	sw	a2,8(a3)
  if(write)
    800053aa:	140d0063          	beqz	s10,800054ea <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800053ae:	00018697          	auipc	a3,0x18
    800053b2:	c526b683          	ld	a3,-942(a3) # 8001d000 <disk+0x2000>
    800053b6:	96ba                	add	a3,a3,a4
    800053b8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800053bc:	00016817          	auipc	a6,0x16
    800053c0:	c4480813          	addi	a6,a6,-956 # 8001b000 <disk>
    800053c4:	00018517          	auipc	a0,0x18
    800053c8:	c3c50513          	addi	a0,a0,-964 # 8001d000 <disk+0x2000>
    800053cc:	6114                	ld	a3,0(a0)
    800053ce:	96ba                	add	a3,a3,a4
    800053d0:	00c6d603          	lhu	a2,12(a3)
    800053d4:	00166613          	ori	a2,a2,1
    800053d8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800053dc:	f9842683          	lw	a3,-104(s0)
    800053e0:	6110                	ld	a2,0(a0)
    800053e2:	9732                	add	a4,a4,a2
    800053e4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800053e8:	20058613          	addi	a2,a1,512
    800053ec:	0612                	slli	a2,a2,0x4
    800053ee:	9642                	add	a2,a2,a6
    800053f0:	577d                	li	a4,-1
    800053f2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800053f6:	00469713          	slli	a4,a3,0x4
    800053fa:	6114                	ld	a3,0(a0)
    800053fc:	96ba                	add	a3,a3,a4
    800053fe:	03078793          	addi	a5,a5,48
    80005402:	97c2                	add	a5,a5,a6
    80005404:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005406:	611c                	ld	a5,0(a0)
    80005408:	97ba                	add	a5,a5,a4
    8000540a:	4685                	li	a3,1
    8000540c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000540e:	611c                	ld	a5,0(a0)
    80005410:	97ba                	add	a5,a5,a4
    80005412:	4809                	li	a6,2
    80005414:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005418:	611c                	ld	a5,0(a0)
    8000541a:	973e                	add	a4,a4,a5
    8000541c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005420:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005424:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005428:	6518                	ld	a4,8(a0)
    8000542a:	00275783          	lhu	a5,2(a4)
    8000542e:	8b9d                	andi	a5,a5,7
    80005430:	0786                	slli	a5,a5,0x1
    80005432:	97ba                	add	a5,a5,a4
    80005434:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005438:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000543c:	6518                	ld	a4,8(a0)
    8000543e:	00275783          	lhu	a5,2(a4)
    80005442:	2785                	addiw	a5,a5,1
    80005444:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005448:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000544c:	100017b7          	lui	a5,0x10001
    80005450:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005454:	00492703          	lw	a4,4(s2)
    80005458:	4785                	li	a5,1
    8000545a:	02f71163          	bne	a4,a5,8000547c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000545e:	00018997          	auipc	s3,0x18
    80005462:	cca98993          	addi	s3,s3,-822 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005466:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005468:	85ce                	mv	a1,s3
    8000546a:	854a                	mv	a0,s2
    8000546c:	ffffc097          	auipc	ra,0xffffc
    80005470:	098080e7          	jalr	152(ra) # 80001504 <sleep>
  while(b->disk == 1) {
    80005474:	00492783          	lw	a5,4(s2)
    80005478:	fe9788e3          	beq	a5,s1,80005468 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000547c:	f9042903          	lw	s2,-112(s0)
    80005480:	20090793          	addi	a5,s2,512
    80005484:	00479713          	slli	a4,a5,0x4
    80005488:	00016797          	auipc	a5,0x16
    8000548c:	b7878793          	addi	a5,a5,-1160 # 8001b000 <disk>
    80005490:	97ba                	add	a5,a5,a4
    80005492:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005496:	00018997          	auipc	s3,0x18
    8000549a:	b6a98993          	addi	s3,s3,-1174 # 8001d000 <disk+0x2000>
    8000549e:	00491713          	slli	a4,s2,0x4
    800054a2:	0009b783          	ld	a5,0(s3)
    800054a6:	97ba                	add	a5,a5,a4
    800054a8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800054ac:	854a                	mv	a0,s2
    800054ae:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800054b2:	00000097          	auipc	ra,0x0
    800054b6:	bc4080e7          	jalr	-1084(ra) # 80005076 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800054ba:	8885                	andi	s1,s1,1
    800054bc:	f0ed                	bnez	s1,8000549e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800054be:	00018517          	auipc	a0,0x18
    800054c2:	c6a50513          	addi	a0,a0,-918 # 8001d128 <disk+0x2128>
    800054c6:	00001097          	auipc	ra,0x1
    800054ca:	c50080e7          	jalr	-944(ra) # 80006116 <release>
}
    800054ce:	70a6                	ld	ra,104(sp)
    800054d0:	7406                	ld	s0,96(sp)
    800054d2:	64e6                	ld	s1,88(sp)
    800054d4:	6946                	ld	s2,80(sp)
    800054d6:	69a6                	ld	s3,72(sp)
    800054d8:	6a06                	ld	s4,64(sp)
    800054da:	7ae2                	ld	s5,56(sp)
    800054dc:	7b42                	ld	s6,48(sp)
    800054de:	7ba2                	ld	s7,40(sp)
    800054e0:	7c02                	ld	s8,32(sp)
    800054e2:	6ce2                	ld	s9,24(sp)
    800054e4:	6d42                	ld	s10,16(sp)
    800054e6:	6165                	addi	sp,sp,112
    800054e8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800054ea:	00018697          	auipc	a3,0x18
    800054ee:	b166b683          	ld	a3,-1258(a3) # 8001d000 <disk+0x2000>
    800054f2:	96ba                	add	a3,a3,a4
    800054f4:	4609                	li	a2,2
    800054f6:	00c69623          	sh	a2,12(a3)
    800054fa:	b5c9                	j	800053bc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800054fc:	f9042583          	lw	a1,-112(s0)
    80005500:	20058793          	addi	a5,a1,512
    80005504:	0792                	slli	a5,a5,0x4
    80005506:	00016517          	auipc	a0,0x16
    8000550a:	ba250513          	addi	a0,a0,-1118 # 8001b0a8 <disk+0xa8>
    8000550e:	953e                	add	a0,a0,a5
  if(write)
    80005510:	e20d11e3          	bnez	s10,80005332 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005514:	20058713          	addi	a4,a1,512
    80005518:	00471693          	slli	a3,a4,0x4
    8000551c:	00016717          	auipc	a4,0x16
    80005520:	ae470713          	addi	a4,a4,-1308 # 8001b000 <disk>
    80005524:	9736                	add	a4,a4,a3
    80005526:	0a072423          	sw	zero,168(a4)
    8000552a:	b505                	j	8000534a <virtio_disk_rw+0xf4>

000000008000552c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000552c:	1101                	addi	sp,sp,-32
    8000552e:	ec06                	sd	ra,24(sp)
    80005530:	e822                	sd	s0,16(sp)
    80005532:	e426                	sd	s1,8(sp)
    80005534:	e04a                	sd	s2,0(sp)
    80005536:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005538:	00018517          	auipc	a0,0x18
    8000553c:	bf050513          	addi	a0,a0,-1040 # 8001d128 <disk+0x2128>
    80005540:	00001097          	auipc	ra,0x1
    80005544:	b22080e7          	jalr	-1246(ra) # 80006062 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005548:	10001737          	lui	a4,0x10001
    8000554c:	533c                	lw	a5,96(a4)
    8000554e:	8b8d                	andi	a5,a5,3
    80005550:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005552:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005556:	00018797          	auipc	a5,0x18
    8000555a:	aaa78793          	addi	a5,a5,-1366 # 8001d000 <disk+0x2000>
    8000555e:	6b94                	ld	a3,16(a5)
    80005560:	0207d703          	lhu	a4,32(a5)
    80005564:	0026d783          	lhu	a5,2(a3)
    80005568:	06f70163          	beq	a4,a5,800055ca <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000556c:	00016917          	auipc	s2,0x16
    80005570:	a9490913          	addi	s2,s2,-1388 # 8001b000 <disk>
    80005574:	00018497          	auipc	s1,0x18
    80005578:	a8c48493          	addi	s1,s1,-1396 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000557c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005580:	6898                	ld	a4,16(s1)
    80005582:	0204d783          	lhu	a5,32(s1)
    80005586:	8b9d                	andi	a5,a5,7
    80005588:	078e                	slli	a5,a5,0x3
    8000558a:	97ba                	add	a5,a5,a4
    8000558c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000558e:	20078713          	addi	a4,a5,512
    80005592:	0712                	slli	a4,a4,0x4
    80005594:	974a                	add	a4,a4,s2
    80005596:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000559a:	e731                	bnez	a4,800055e6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000559c:	20078793          	addi	a5,a5,512
    800055a0:	0792                	slli	a5,a5,0x4
    800055a2:	97ca                	add	a5,a5,s2
    800055a4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800055a6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800055aa:	ffffc097          	auipc	ra,0xffffc
    800055ae:	0e6080e7          	jalr	230(ra) # 80001690 <wakeup>

    disk.used_idx += 1;
    800055b2:	0204d783          	lhu	a5,32(s1)
    800055b6:	2785                	addiw	a5,a5,1
    800055b8:	17c2                	slli	a5,a5,0x30
    800055ba:	93c1                	srli	a5,a5,0x30
    800055bc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800055c0:	6898                	ld	a4,16(s1)
    800055c2:	00275703          	lhu	a4,2(a4)
    800055c6:	faf71be3          	bne	a4,a5,8000557c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800055ca:	00018517          	auipc	a0,0x18
    800055ce:	b5e50513          	addi	a0,a0,-1186 # 8001d128 <disk+0x2128>
    800055d2:	00001097          	auipc	ra,0x1
    800055d6:	b44080e7          	jalr	-1212(ra) # 80006116 <release>
}
    800055da:	60e2                	ld	ra,24(sp)
    800055dc:	6442                	ld	s0,16(sp)
    800055de:	64a2                	ld	s1,8(sp)
    800055e0:	6902                	ld	s2,0(sp)
    800055e2:	6105                	addi	sp,sp,32
    800055e4:	8082                	ret
      panic("virtio_disk_intr status");
    800055e6:	00003517          	auipc	a0,0x3
    800055ea:	19250513          	addi	a0,a0,402 # 80008778 <syscalls+0x3b0>
    800055ee:	00000097          	auipc	ra,0x0
    800055f2:	52a080e7          	jalr	1322(ra) # 80005b18 <panic>

00000000800055f6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800055f6:	1141                	addi	sp,sp,-16
    800055f8:	e422                	sd	s0,8(sp)
    800055fa:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800055fc:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005600:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005604:	0037979b          	slliw	a5,a5,0x3
    80005608:	02004737          	lui	a4,0x2004
    8000560c:	97ba                	add	a5,a5,a4
    8000560e:	0200c737          	lui	a4,0x200c
    80005612:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005616:	000f4637          	lui	a2,0xf4
    8000561a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000561e:	95b2                	add	a1,a1,a2
    80005620:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005622:	00269713          	slli	a4,a3,0x2
    80005626:	9736                	add	a4,a4,a3
    80005628:	00371693          	slli	a3,a4,0x3
    8000562c:	00019717          	auipc	a4,0x19
    80005630:	9d470713          	addi	a4,a4,-1580 # 8001e000 <timer_scratch>
    80005634:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005636:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005638:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000563a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000563e:	00000797          	auipc	a5,0x0
    80005642:	97278793          	addi	a5,a5,-1678 # 80004fb0 <timervec>
    80005646:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000564a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000564e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005652:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005656:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000565a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000565e:	30479073          	csrw	mie,a5
}
    80005662:	6422                	ld	s0,8(sp)
    80005664:	0141                	addi	sp,sp,16
    80005666:	8082                	ret

0000000080005668 <start>:
{
    80005668:	1141                	addi	sp,sp,-16
    8000566a:	e406                	sd	ra,8(sp)
    8000566c:	e022                	sd	s0,0(sp)
    8000566e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005670:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005674:	7779                	lui	a4,0xffffe
    80005676:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    8000567a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000567c:	6705                	lui	a4,0x1
    8000567e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005682:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005684:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005688:	ffffb797          	auipc	a5,0xffffb
    8000568c:	c9e78793          	addi	a5,a5,-866 # 80000326 <main>
    80005690:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005694:	4781                	li	a5,0
    80005696:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000569a:	67c1                	lui	a5,0x10
    8000569c:	17fd                	addi	a5,a5,-1
    8000569e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800056a2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800056a6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800056aa:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800056ae:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800056b2:	57fd                	li	a5,-1
    800056b4:	83a9                	srli	a5,a5,0xa
    800056b6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800056ba:	47bd                	li	a5,15
    800056bc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800056c0:	00000097          	auipc	ra,0x0
    800056c4:	f36080e7          	jalr	-202(ra) # 800055f6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800056c8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800056cc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800056ce:	823e                	mv	tp,a5
  asm volatile("mret");
    800056d0:	30200073          	mret
}
    800056d4:	60a2                	ld	ra,8(sp)
    800056d6:	6402                	ld	s0,0(sp)
    800056d8:	0141                	addi	sp,sp,16
    800056da:	8082                	ret

00000000800056dc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800056dc:	715d                	addi	sp,sp,-80
    800056de:	e486                	sd	ra,72(sp)
    800056e0:	e0a2                	sd	s0,64(sp)
    800056e2:	fc26                	sd	s1,56(sp)
    800056e4:	f84a                	sd	s2,48(sp)
    800056e6:	f44e                	sd	s3,40(sp)
    800056e8:	f052                	sd	s4,32(sp)
    800056ea:	ec56                	sd	s5,24(sp)
    800056ec:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800056ee:	04c05663          	blez	a2,8000573a <consolewrite+0x5e>
    800056f2:	8a2a                	mv	s4,a0
    800056f4:	84ae                	mv	s1,a1
    800056f6:	89b2                	mv	s3,a2
    800056f8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800056fa:	5afd                	li	s5,-1
    800056fc:	4685                	li	a3,1
    800056fe:	8626                	mv	a2,s1
    80005700:	85d2                	mv	a1,s4
    80005702:	fbf40513          	addi	a0,s0,-65
    80005706:	ffffc097          	auipc	ra,0xffffc
    8000570a:	1f8080e7          	jalr	504(ra) # 800018fe <either_copyin>
    8000570e:	01550c63          	beq	a0,s5,80005726 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005712:	fbf44503          	lbu	a0,-65(s0)
    80005716:	00000097          	auipc	ra,0x0
    8000571a:	78e080e7          	jalr	1934(ra) # 80005ea4 <uartputc>
  for(i = 0; i < n; i++){
    8000571e:	2905                	addiw	s2,s2,1
    80005720:	0485                	addi	s1,s1,1
    80005722:	fd299de3          	bne	s3,s2,800056fc <consolewrite+0x20>
  }

  return i;
}
    80005726:	854a                	mv	a0,s2
    80005728:	60a6                	ld	ra,72(sp)
    8000572a:	6406                	ld	s0,64(sp)
    8000572c:	74e2                	ld	s1,56(sp)
    8000572e:	7942                	ld	s2,48(sp)
    80005730:	79a2                	ld	s3,40(sp)
    80005732:	7a02                	ld	s4,32(sp)
    80005734:	6ae2                	ld	s5,24(sp)
    80005736:	6161                	addi	sp,sp,80
    80005738:	8082                	ret
  for(i = 0; i < n; i++){
    8000573a:	4901                	li	s2,0
    8000573c:	b7ed                	j	80005726 <consolewrite+0x4a>

000000008000573e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000573e:	7119                	addi	sp,sp,-128
    80005740:	fc86                	sd	ra,120(sp)
    80005742:	f8a2                	sd	s0,112(sp)
    80005744:	f4a6                	sd	s1,104(sp)
    80005746:	f0ca                	sd	s2,96(sp)
    80005748:	ecce                	sd	s3,88(sp)
    8000574a:	e8d2                	sd	s4,80(sp)
    8000574c:	e4d6                	sd	s5,72(sp)
    8000574e:	e0da                	sd	s6,64(sp)
    80005750:	fc5e                	sd	s7,56(sp)
    80005752:	f862                	sd	s8,48(sp)
    80005754:	f466                	sd	s9,40(sp)
    80005756:	f06a                	sd	s10,32(sp)
    80005758:	ec6e                	sd	s11,24(sp)
    8000575a:	0100                	addi	s0,sp,128
    8000575c:	8b2a                	mv	s6,a0
    8000575e:	8aae                	mv	s5,a1
    80005760:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005762:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005766:	00021517          	auipc	a0,0x21
    8000576a:	9da50513          	addi	a0,a0,-1574 # 80026140 <cons>
    8000576e:	00001097          	auipc	ra,0x1
    80005772:	8f4080e7          	jalr	-1804(ra) # 80006062 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005776:	00021497          	auipc	s1,0x21
    8000577a:	9ca48493          	addi	s1,s1,-1590 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000577e:	89a6                	mv	s3,s1
    80005780:	00021917          	auipc	s2,0x21
    80005784:	a5890913          	addi	s2,s2,-1448 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005788:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000578a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000578c:	4da9                	li	s11,10
  while(n > 0){
    8000578e:	07405863          	blez	s4,800057fe <consoleread+0xc0>
    while(cons.r == cons.w){
    80005792:	0984a783          	lw	a5,152(s1)
    80005796:	09c4a703          	lw	a4,156(s1)
    8000579a:	02f71463          	bne	a4,a5,800057c2 <consoleread+0x84>
      if(myproc()->killed){
    8000579e:	ffffb097          	auipc	ra,0xffffb
    800057a2:	6aa080e7          	jalr	1706(ra) # 80000e48 <myproc>
    800057a6:	551c                	lw	a5,40(a0)
    800057a8:	e7b5                	bnez	a5,80005814 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800057aa:	85ce                	mv	a1,s3
    800057ac:	854a                	mv	a0,s2
    800057ae:	ffffc097          	auipc	ra,0xffffc
    800057b2:	d56080e7          	jalr	-682(ra) # 80001504 <sleep>
    while(cons.r == cons.w){
    800057b6:	0984a783          	lw	a5,152(s1)
    800057ba:	09c4a703          	lw	a4,156(s1)
    800057be:	fef700e3          	beq	a4,a5,8000579e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800057c2:	0017871b          	addiw	a4,a5,1
    800057c6:	08e4ac23          	sw	a4,152(s1)
    800057ca:	07f7f713          	andi	a4,a5,127
    800057ce:	9726                	add	a4,a4,s1
    800057d0:	01874703          	lbu	a4,24(a4)
    800057d4:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800057d8:	079c0663          	beq	s8,s9,80005844 <consoleread+0x106>
    cbuf = c;
    800057dc:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800057e0:	4685                	li	a3,1
    800057e2:	f8f40613          	addi	a2,s0,-113
    800057e6:	85d6                	mv	a1,s5
    800057e8:	855a                	mv	a0,s6
    800057ea:	ffffc097          	auipc	ra,0xffffc
    800057ee:	0be080e7          	jalr	190(ra) # 800018a8 <either_copyout>
    800057f2:	01a50663          	beq	a0,s10,800057fe <consoleread+0xc0>
    dst++;
    800057f6:	0a85                	addi	s5,s5,1
    --n;
    800057f8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    800057fa:	f9bc1ae3          	bne	s8,s11,8000578e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800057fe:	00021517          	auipc	a0,0x21
    80005802:	94250513          	addi	a0,a0,-1726 # 80026140 <cons>
    80005806:	00001097          	auipc	ra,0x1
    8000580a:	910080e7          	jalr	-1776(ra) # 80006116 <release>

  return target - n;
    8000580e:	414b853b          	subw	a0,s7,s4
    80005812:	a811                	j	80005826 <consoleread+0xe8>
        release(&cons.lock);
    80005814:	00021517          	auipc	a0,0x21
    80005818:	92c50513          	addi	a0,a0,-1748 # 80026140 <cons>
    8000581c:	00001097          	auipc	ra,0x1
    80005820:	8fa080e7          	jalr	-1798(ra) # 80006116 <release>
        return -1;
    80005824:	557d                	li	a0,-1
}
    80005826:	70e6                	ld	ra,120(sp)
    80005828:	7446                	ld	s0,112(sp)
    8000582a:	74a6                	ld	s1,104(sp)
    8000582c:	7906                	ld	s2,96(sp)
    8000582e:	69e6                	ld	s3,88(sp)
    80005830:	6a46                	ld	s4,80(sp)
    80005832:	6aa6                	ld	s5,72(sp)
    80005834:	6b06                	ld	s6,64(sp)
    80005836:	7be2                	ld	s7,56(sp)
    80005838:	7c42                	ld	s8,48(sp)
    8000583a:	7ca2                	ld	s9,40(sp)
    8000583c:	7d02                	ld	s10,32(sp)
    8000583e:	6de2                	ld	s11,24(sp)
    80005840:	6109                	addi	sp,sp,128
    80005842:	8082                	ret
      if(n < target){
    80005844:	000a071b          	sext.w	a4,s4
    80005848:	fb777be3          	bgeu	a4,s7,800057fe <consoleread+0xc0>
        cons.r--;
    8000584c:	00021717          	auipc	a4,0x21
    80005850:	98f72623          	sw	a5,-1652(a4) # 800261d8 <cons+0x98>
    80005854:	b76d                	j	800057fe <consoleread+0xc0>

0000000080005856 <consputc>:
{
    80005856:	1141                	addi	sp,sp,-16
    80005858:	e406                	sd	ra,8(sp)
    8000585a:	e022                	sd	s0,0(sp)
    8000585c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000585e:	10000793          	li	a5,256
    80005862:	00f50a63          	beq	a0,a5,80005876 <consputc+0x20>
    uartputc_sync(c);
    80005866:	00000097          	auipc	ra,0x0
    8000586a:	564080e7          	jalr	1380(ra) # 80005dca <uartputc_sync>
}
    8000586e:	60a2                	ld	ra,8(sp)
    80005870:	6402                	ld	s0,0(sp)
    80005872:	0141                	addi	sp,sp,16
    80005874:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005876:	4521                	li	a0,8
    80005878:	00000097          	auipc	ra,0x0
    8000587c:	552080e7          	jalr	1362(ra) # 80005dca <uartputc_sync>
    80005880:	02000513          	li	a0,32
    80005884:	00000097          	auipc	ra,0x0
    80005888:	546080e7          	jalr	1350(ra) # 80005dca <uartputc_sync>
    8000588c:	4521                	li	a0,8
    8000588e:	00000097          	auipc	ra,0x0
    80005892:	53c080e7          	jalr	1340(ra) # 80005dca <uartputc_sync>
    80005896:	bfe1                	j	8000586e <consputc+0x18>

0000000080005898 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005898:	1101                	addi	sp,sp,-32
    8000589a:	ec06                	sd	ra,24(sp)
    8000589c:	e822                	sd	s0,16(sp)
    8000589e:	e426                	sd	s1,8(sp)
    800058a0:	e04a                	sd	s2,0(sp)
    800058a2:	1000                	addi	s0,sp,32
    800058a4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800058a6:	00021517          	auipc	a0,0x21
    800058aa:	89a50513          	addi	a0,a0,-1894 # 80026140 <cons>
    800058ae:	00000097          	auipc	ra,0x0
    800058b2:	7b4080e7          	jalr	1972(ra) # 80006062 <acquire>

  switch(c){
    800058b6:	47d5                	li	a5,21
    800058b8:	0af48663          	beq	s1,a5,80005964 <consoleintr+0xcc>
    800058bc:	0297ca63          	blt	a5,s1,800058f0 <consoleintr+0x58>
    800058c0:	47a1                	li	a5,8
    800058c2:	0ef48763          	beq	s1,a5,800059b0 <consoleintr+0x118>
    800058c6:	47c1                	li	a5,16
    800058c8:	10f49a63          	bne	s1,a5,800059dc <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800058cc:	ffffc097          	auipc	ra,0xffffc
    800058d0:	088080e7          	jalr	136(ra) # 80001954 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800058d4:	00021517          	auipc	a0,0x21
    800058d8:	86c50513          	addi	a0,a0,-1940 # 80026140 <cons>
    800058dc:	00001097          	auipc	ra,0x1
    800058e0:	83a080e7          	jalr	-1990(ra) # 80006116 <release>
}
    800058e4:	60e2                	ld	ra,24(sp)
    800058e6:	6442                	ld	s0,16(sp)
    800058e8:	64a2                	ld	s1,8(sp)
    800058ea:	6902                	ld	s2,0(sp)
    800058ec:	6105                	addi	sp,sp,32
    800058ee:	8082                	ret
  switch(c){
    800058f0:	07f00793          	li	a5,127
    800058f4:	0af48e63          	beq	s1,a5,800059b0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800058f8:	00021717          	auipc	a4,0x21
    800058fc:	84870713          	addi	a4,a4,-1976 # 80026140 <cons>
    80005900:	0a072783          	lw	a5,160(a4)
    80005904:	09872703          	lw	a4,152(a4)
    80005908:	9f99                	subw	a5,a5,a4
    8000590a:	07f00713          	li	a4,127
    8000590e:	fcf763e3          	bltu	a4,a5,800058d4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005912:	47b5                	li	a5,13
    80005914:	0cf48763          	beq	s1,a5,800059e2 <consoleintr+0x14a>
      consputc(c);
    80005918:	8526                	mv	a0,s1
    8000591a:	00000097          	auipc	ra,0x0
    8000591e:	f3c080e7          	jalr	-196(ra) # 80005856 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005922:	00021797          	auipc	a5,0x21
    80005926:	81e78793          	addi	a5,a5,-2018 # 80026140 <cons>
    8000592a:	0a07a703          	lw	a4,160(a5)
    8000592e:	0017069b          	addiw	a3,a4,1
    80005932:	0006861b          	sext.w	a2,a3
    80005936:	0ad7a023          	sw	a3,160(a5)
    8000593a:	07f77713          	andi	a4,a4,127
    8000593e:	97ba                	add	a5,a5,a4
    80005940:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005944:	47a9                	li	a5,10
    80005946:	0cf48563          	beq	s1,a5,80005a10 <consoleintr+0x178>
    8000594a:	4791                	li	a5,4
    8000594c:	0cf48263          	beq	s1,a5,80005a10 <consoleintr+0x178>
    80005950:	00021797          	auipc	a5,0x21
    80005954:	8887a783          	lw	a5,-1912(a5) # 800261d8 <cons+0x98>
    80005958:	0807879b          	addiw	a5,a5,128
    8000595c:	f6f61ce3          	bne	a2,a5,800058d4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005960:	863e                	mv	a2,a5
    80005962:	a07d                	j	80005a10 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005964:	00020717          	auipc	a4,0x20
    80005968:	7dc70713          	addi	a4,a4,2012 # 80026140 <cons>
    8000596c:	0a072783          	lw	a5,160(a4)
    80005970:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005974:	00020497          	auipc	s1,0x20
    80005978:	7cc48493          	addi	s1,s1,1996 # 80026140 <cons>
    while(cons.e != cons.w &&
    8000597c:	4929                	li	s2,10
    8000597e:	f4f70be3          	beq	a4,a5,800058d4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005982:	37fd                	addiw	a5,a5,-1
    80005984:	07f7f713          	andi	a4,a5,127
    80005988:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000598a:	01874703          	lbu	a4,24(a4)
    8000598e:	f52703e3          	beq	a4,s2,800058d4 <consoleintr+0x3c>
      cons.e--;
    80005992:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005996:	10000513          	li	a0,256
    8000599a:	00000097          	auipc	ra,0x0
    8000599e:	ebc080e7          	jalr	-324(ra) # 80005856 <consputc>
    while(cons.e != cons.w &&
    800059a2:	0a04a783          	lw	a5,160(s1)
    800059a6:	09c4a703          	lw	a4,156(s1)
    800059aa:	fcf71ce3          	bne	a4,a5,80005982 <consoleintr+0xea>
    800059ae:	b71d                	j	800058d4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800059b0:	00020717          	auipc	a4,0x20
    800059b4:	79070713          	addi	a4,a4,1936 # 80026140 <cons>
    800059b8:	0a072783          	lw	a5,160(a4)
    800059bc:	09c72703          	lw	a4,156(a4)
    800059c0:	f0f70ae3          	beq	a4,a5,800058d4 <consoleintr+0x3c>
      cons.e--;
    800059c4:	37fd                	addiw	a5,a5,-1
    800059c6:	00021717          	auipc	a4,0x21
    800059ca:	80f72d23          	sw	a5,-2022(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    800059ce:	10000513          	li	a0,256
    800059d2:	00000097          	auipc	ra,0x0
    800059d6:	e84080e7          	jalr	-380(ra) # 80005856 <consputc>
    800059da:	bded                	j	800058d4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800059dc:	ee048ce3          	beqz	s1,800058d4 <consoleintr+0x3c>
    800059e0:	bf21                	j	800058f8 <consoleintr+0x60>
      consputc(c);
    800059e2:	4529                	li	a0,10
    800059e4:	00000097          	auipc	ra,0x0
    800059e8:	e72080e7          	jalr	-398(ra) # 80005856 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800059ec:	00020797          	auipc	a5,0x20
    800059f0:	75478793          	addi	a5,a5,1876 # 80026140 <cons>
    800059f4:	0a07a703          	lw	a4,160(a5)
    800059f8:	0017069b          	addiw	a3,a4,1
    800059fc:	0006861b          	sext.w	a2,a3
    80005a00:	0ad7a023          	sw	a3,160(a5)
    80005a04:	07f77713          	andi	a4,a4,127
    80005a08:	97ba                	add	a5,a5,a4
    80005a0a:	4729                	li	a4,10
    80005a0c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005a10:	00020797          	auipc	a5,0x20
    80005a14:	7cc7a623          	sw	a2,1996(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005a18:	00020517          	auipc	a0,0x20
    80005a1c:	7c050513          	addi	a0,a0,1984 # 800261d8 <cons+0x98>
    80005a20:	ffffc097          	auipc	ra,0xffffc
    80005a24:	c70080e7          	jalr	-912(ra) # 80001690 <wakeup>
    80005a28:	b575                	j	800058d4 <consoleintr+0x3c>

0000000080005a2a <consoleinit>:

void
consoleinit(void)
{
    80005a2a:	1141                	addi	sp,sp,-16
    80005a2c:	e406                	sd	ra,8(sp)
    80005a2e:	e022                	sd	s0,0(sp)
    80005a30:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005a32:	00003597          	auipc	a1,0x3
    80005a36:	d5e58593          	addi	a1,a1,-674 # 80008790 <syscalls+0x3c8>
    80005a3a:	00020517          	auipc	a0,0x20
    80005a3e:	70650513          	addi	a0,a0,1798 # 80026140 <cons>
    80005a42:	00000097          	auipc	ra,0x0
    80005a46:	590080e7          	jalr	1424(ra) # 80005fd2 <initlock>

  uartinit();
    80005a4a:	00000097          	auipc	ra,0x0
    80005a4e:	330080e7          	jalr	816(ra) # 80005d7a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005a52:	00013797          	auipc	a5,0x13
    80005a56:	67678793          	addi	a5,a5,1654 # 800190c8 <devsw>
    80005a5a:	00000717          	auipc	a4,0x0
    80005a5e:	ce470713          	addi	a4,a4,-796 # 8000573e <consoleread>
    80005a62:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005a64:	00000717          	auipc	a4,0x0
    80005a68:	c7870713          	addi	a4,a4,-904 # 800056dc <consolewrite>
    80005a6c:	ef98                	sd	a4,24(a5)
}
    80005a6e:	60a2                	ld	ra,8(sp)
    80005a70:	6402                	ld	s0,0(sp)
    80005a72:	0141                	addi	sp,sp,16
    80005a74:	8082                	ret

0000000080005a76 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005a76:	7179                	addi	sp,sp,-48
    80005a78:	f406                	sd	ra,40(sp)
    80005a7a:	f022                	sd	s0,32(sp)
    80005a7c:	ec26                	sd	s1,24(sp)
    80005a7e:	e84a                	sd	s2,16(sp)
    80005a80:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005a82:	c219                	beqz	a2,80005a88 <printint+0x12>
    80005a84:	08054663          	bltz	a0,80005b10 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005a88:	2501                	sext.w	a0,a0
    80005a8a:	4881                	li	a7,0
    80005a8c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005a90:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005a92:	2581                	sext.w	a1,a1
    80005a94:	00003617          	auipc	a2,0x3
    80005a98:	d2c60613          	addi	a2,a2,-724 # 800087c0 <digits>
    80005a9c:	883a                	mv	a6,a4
    80005a9e:	2705                	addiw	a4,a4,1
    80005aa0:	02b577bb          	remuw	a5,a0,a1
    80005aa4:	1782                	slli	a5,a5,0x20
    80005aa6:	9381                	srli	a5,a5,0x20
    80005aa8:	97b2                	add	a5,a5,a2
    80005aaa:	0007c783          	lbu	a5,0(a5)
    80005aae:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005ab2:	0005079b          	sext.w	a5,a0
    80005ab6:	02b5553b          	divuw	a0,a0,a1
    80005aba:	0685                	addi	a3,a3,1
    80005abc:	feb7f0e3          	bgeu	a5,a1,80005a9c <printint+0x26>

  if(sign)
    80005ac0:	00088b63          	beqz	a7,80005ad6 <printint+0x60>
    buf[i++] = '-';
    80005ac4:	fe040793          	addi	a5,s0,-32
    80005ac8:	973e                	add	a4,a4,a5
    80005aca:	02d00793          	li	a5,45
    80005ace:	fef70823          	sb	a5,-16(a4)
    80005ad2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005ad6:	02e05763          	blez	a4,80005b04 <printint+0x8e>
    80005ada:	fd040793          	addi	a5,s0,-48
    80005ade:	00e784b3          	add	s1,a5,a4
    80005ae2:	fff78913          	addi	s2,a5,-1
    80005ae6:	993a                	add	s2,s2,a4
    80005ae8:	377d                	addiw	a4,a4,-1
    80005aea:	1702                	slli	a4,a4,0x20
    80005aec:	9301                	srli	a4,a4,0x20
    80005aee:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005af2:	fff4c503          	lbu	a0,-1(s1)
    80005af6:	00000097          	auipc	ra,0x0
    80005afa:	d60080e7          	jalr	-672(ra) # 80005856 <consputc>
  while(--i >= 0)
    80005afe:	14fd                	addi	s1,s1,-1
    80005b00:	ff2499e3          	bne	s1,s2,80005af2 <printint+0x7c>
}
    80005b04:	70a2                	ld	ra,40(sp)
    80005b06:	7402                	ld	s0,32(sp)
    80005b08:	64e2                	ld	s1,24(sp)
    80005b0a:	6942                	ld	s2,16(sp)
    80005b0c:	6145                	addi	sp,sp,48
    80005b0e:	8082                	ret
    x = -xx;
    80005b10:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005b14:	4885                	li	a7,1
    x = -xx;
    80005b16:	bf9d                	j	80005a8c <printint+0x16>

0000000080005b18 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005b18:	1101                	addi	sp,sp,-32
    80005b1a:	ec06                	sd	ra,24(sp)
    80005b1c:	e822                	sd	s0,16(sp)
    80005b1e:	e426                	sd	s1,8(sp)
    80005b20:	1000                	addi	s0,sp,32
    80005b22:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005b24:	00020797          	auipc	a5,0x20
    80005b28:	6c07ae23          	sw	zero,1756(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005b2c:	00003517          	auipc	a0,0x3
    80005b30:	c6c50513          	addi	a0,a0,-916 # 80008798 <syscalls+0x3d0>
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	02e080e7          	jalr	46(ra) # 80005b62 <printf>
  printf(s);
    80005b3c:	8526                	mv	a0,s1
    80005b3e:	00000097          	auipc	ra,0x0
    80005b42:	024080e7          	jalr	36(ra) # 80005b62 <printf>
  printf("\n");
    80005b46:	00002517          	auipc	a0,0x2
    80005b4a:	50250513          	addi	a0,a0,1282 # 80008048 <etext+0x48>
    80005b4e:	00000097          	auipc	ra,0x0
    80005b52:	014080e7          	jalr	20(ra) # 80005b62 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005b56:	4785                	li	a5,1
    80005b58:	00003717          	auipc	a4,0x3
    80005b5c:	4cf72223          	sw	a5,1220(a4) # 8000901c <panicked>
  for(;;)
    80005b60:	a001                	j	80005b60 <panic+0x48>

0000000080005b62 <printf>:
{
    80005b62:	7131                	addi	sp,sp,-192
    80005b64:	fc86                	sd	ra,120(sp)
    80005b66:	f8a2                	sd	s0,112(sp)
    80005b68:	f4a6                	sd	s1,104(sp)
    80005b6a:	f0ca                	sd	s2,96(sp)
    80005b6c:	ecce                	sd	s3,88(sp)
    80005b6e:	e8d2                	sd	s4,80(sp)
    80005b70:	e4d6                	sd	s5,72(sp)
    80005b72:	e0da                	sd	s6,64(sp)
    80005b74:	fc5e                	sd	s7,56(sp)
    80005b76:	f862                	sd	s8,48(sp)
    80005b78:	f466                	sd	s9,40(sp)
    80005b7a:	f06a                	sd	s10,32(sp)
    80005b7c:	ec6e                	sd	s11,24(sp)
    80005b7e:	0100                	addi	s0,sp,128
    80005b80:	8a2a                	mv	s4,a0
    80005b82:	e40c                	sd	a1,8(s0)
    80005b84:	e810                	sd	a2,16(s0)
    80005b86:	ec14                	sd	a3,24(s0)
    80005b88:	f018                	sd	a4,32(s0)
    80005b8a:	f41c                	sd	a5,40(s0)
    80005b8c:	03043823          	sd	a6,48(s0)
    80005b90:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005b94:	00020d97          	auipc	s11,0x20
    80005b98:	66cdad83          	lw	s11,1644(s11) # 80026200 <pr+0x18>
  if(locking)
    80005b9c:	020d9b63          	bnez	s11,80005bd2 <printf+0x70>
  if (fmt == 0)
    80005ba0:	040a0263          	beqz	s4,80005be4 <printf+0x82>
  va_start(ap, fmt);
    80005ba4:	00840793          	addi	a5,s0,8
    80005ba8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005bac:	000a4503          	lbu	a0,0(s4)
    80005bb0:	16050263          	beqz	a0,80005d14 <printf+0x1b2>
    80005bb4:	4481                	li	s1,0
    if(c != '%'){
    80005bb6:	02500a93          	li	s5,37
    switch(c){
    80005bba:	07000b13          	li	s6,112
  consputc('x');
    80005bbe:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005bc0:	00003b97          	auipc	s7,0x3
    80005bc4:	c00b8b93          	addi	s7,s7,-1024 # 800087c0 <digits>
    switch(c){
    80005bc8:	07300c93          	li	s9,115
    80005bcc:	06400c13          	li	s8,100
    80005bd0:	a82d                	j	80005c0a <printf+0xa8>
    acquire(&pr.lock);
    80005bd2:	00020517          	auipc	a0,0x20
    80005bd6:	61650513          	addi	a0,a0,1558 # 800261e8 <pr>
    80005bda:	00000097          	auipc	ra,0x0
    80005bde:	488080e7          	jalr	1160(ra) # 80006062 <acquire>
    80005be2:	bf7d                	j	80005ba0 <printf+0x3e>
    panic("null fmt");
    80005be4:	00003517          	auipc	a0,0x3
    80005be8:	bc450513          	addi	a0,a0,-1084 # 800087a8 <syscalls+0x3e0>
    80005bec:	00000097          	auipc	ra,0x0
    80005bf0:	f2c080e7          	jalr	-212(ra) # 80005b18 <panic>
      consputc(c);
    80005bf4:	00000097          	auipc	ra,0x0
    80005bf8:	c62080e7          	jalr	-926(ra) # 80005856 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005bfc:	2485                	addiw	s1,s1,1
    80005bfe:	009a07b3          	add	a5,s4,s1
    80005c02:	0007c503          	lbu	a0,0(a5)
    80005c06:	10050763          	beqz	a0,80005d14 <printf+0x1b2>
    if(c != '%'){
    80005c0a:	ff5515e3          	bne	a0,s5,80005bf4 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005c0e:	2485                	addiw	s1,s1,1
    80005c10:	009a07b3          	add	a5,s4,s1
    80005c14:	0007c783          	lbu	a5,0(a5)
    80005c18:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005c1c:	cfe5                	beqz	a5,80005d14 <printf+0x1b2>
    switch(c){
    80005c1e:	05678a63          	beq	a5,s6,80005c72 <printf+0x110>
    80005c22:	02fb7663          	bgeu	s6,a5,80005c4e <printf+0xec>
    80005c26:	09978963          	beq	a5,s9,80005cb8 <printf+0x156>
    80005c2a:	07800713          	li	a4,120
    80005c2e:	0ce79863          	bne	a5,a4,80005cfe <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005c32:	f8843783          	ld	a5,-120(s0)
    80005c36:	00878713          	addi	a4,a5,8
    80005c3a:	f8e43423          	sd	a4,-120(s0)
    80005c3e:	4605                	li	a2,1
    80005c40:	85ea                	mv	a1,s10
    80005c42:	4388                	lw	a0,0(a5)
    80005c44:	00000097          	auipc	ra,0x0
    80005c48:	e32080e7          	jalr	-462(ra) # 80005a76 <printint>
      break;
    80005c4c:	bf45                	j	80005bfc <printf+0x9a>
    switch(c){
    80005c4e:	0b578263          	beq	a5,s5,80005cf2 <printf+0x190>
    80005c52:	0b879663          	bne	a5,s8,80005cfe <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005c56:	f8843783          	ld	a5,-120(s0)
    80005c5a:	00878713          	addi	a4,a5,8
    80005c5e:	f8e43423          	sd	a4,-120(s0)
    80005c62:	4605                	li	a2,1
    80005c64:	45a9                	li	a1,10
    80005c66:	4388                	lw	a0,0(a5)
    80005c68:	00000097          	auipc	ra,0x0
    80005c6c:	e0e080e7          	jalr	-498(ra) # 80005a76 <printint>
      break;
    80005c70:	b771                	j	80005bfc <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005c72:	f8843783          	ld	a5,-120(s0)
    80005c76:	00878713          	addi	a4,a5,8
    80005c7a:	f8e43423          	sd	a4,-120(s0)
    80005c7e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005c82:	03000513          	li	a0,48
    80005c86:	00000097          	auipc	ra,0x0
    80005c8a:	bd0080e7          	jalr	-1072(ra) # 80005856 <consputc>
  consputc('x');
    80005c8e:	07800513          	li	a0,120
    80005c92:	00000097          	auipc	ra,0x0
    80005c96:	bc4080e7          	jalr	-1084(ra) # 80005856 <consputc>
    80005c9a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005c9c:	03c9d793          	srli	a5,s3,0x3c
    80005ca0:	97de                	add	a5,a5,s7
    80005ca2:	0007c503          	lbu	a0,0(a5)
    80005ca6:	00000097          	auipc	ra,0x0
    80005caa:	bb0080e7          	jalr	-1104(ra) # 80005856 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005cae:	0992                	slli	s3,s3,0x4
    80005cb0:	397d                	addiw	s2,s2,-1
    80005cb2:	fe0915e3          	bnez	s2,80005c9c <printf+0x13a>
    80005cb6:	b799                	j	80005bfc <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005cb8:	f8843783          	ld	a5,-120(s0)
    80005cbc:	00878713          	addi	a4,a5,8
    80005cc0:	f8e43423          	sd	a4,-120(s0)
    80005cc4:	0007b903          	ld	s2,0(a5)
    80005cc8:	00090e63          	beqz	s2,80005ce4 <printf+0x182>
      for(; *s; s++)
    80005ccc:	00094503          	lbu	a0,0(s2)
    80005cd0:	d515                	beqz	a0,80005bfc <printf+0x9a>
        consputc(*s);
    80005cd2:	00000097          	auipc	ra,0x0
    80005cd6:	b84080e7          	jalr	-1148(ra) # 80005856 <consputc>
      for(; *s; s++)
    80005cda:	0905                	addi	s2,s2,1
    80005cdc:	00094503          	lbu	a0,0(s2)
    80005ce0:	f96d                	bnez	a0,80005cd2 <printf+0x170>
    80005ce2:	bf29                	j	80005bfc <printf+0x9a>
        s = "(null)";
    80005ce4:	00003917          	auipc	s2,0x3
    80005ce8:	abc90913          	addi	s2,s2,-1348 # 800087a0 <syscalls+0x3d8>
      for(; *s; s++)
    80005cec:	02800513          	li	a0,40
    80005cf0:	b7cd                	j	80005cd2 <printf+0x170>
      consputc('%');
    80005cf2:	8556                	mv	a0,s5
    80005cf4:	00000097          	auipc	ra,0x0
    80005cf8:	b62080e7          	jalr	-1182(ra) # 80005856 <consputc>
      break;
    80005cfc:	b701                	j	80005bfc <printf+0x9a>
      consputc('%');
    80005cfe:	8556                	mv	a0,s5
    80005d00:	00000097          	auipc	ra,0x0
    80005d04:	b56080e7          	jalr	-1194(ra) # 80005856 <consputc>
      consputc(c);
    80005d08:	854a                	mv	a0,s2
    80005d0a:	00000097          	auipc	ra,0x0
    80005d0e:	b4c080e7          	jalr	-1204(ra) # 80005856 <consputc>
      break;
    80005d12:	b5ed                	j	80005bfc <printf+0x9a>
  if(locking)
    80005d14:	020d9163          	bnez	s11,80005d36 <printf+0x1d4>
}
    80005d18:	70e6                	ld	ra,120(sp)
    80005d1a:	7446                	ld	s0,112(sp)
    80005d1c:	74a6                	ld	s1,104(sp)
    80005d1e:	7906                	ld	s2,96(sp)
    80005d20:	69e6                	ld	s3,88(sp)
    80005d22:	6a46                	ld	s4,80(sp)
    80005d24:	6aa6                	ld	s5,72(sp)
    80005d26:	6b06                	ld	s6,64(sp)
    80005d28:	7be2                	ld	s7,56(sp)
    80005d2a:	7c42                	ld	s8,48(sp)
    80005d2c:	7ca2                	ld	s9,40(sp)
    80005d2e:	7d02                	ld	s10,32(sp)
    80005d30:	6de2                	ld	s11,24(sp)
    80005d32:	6129                	addi	sp,sp,192
    80005d34:	8082                	ret
    release(&pr.lock);
    80005d36:	00020517          	auipc	a0,0x20
    80005d3a:	4b250513          	addi	a0,a0,1202 # 800261e8 <pr>
    80005d3e:	00000097          	auipc	ra,0x0
    80005d42:	3d8080e7          	jalr	984(ra) # 80006116 <release>
}
    80005d46:	bfc9                	j	80005d18 <printf+0x1b6>

0000000080005d48 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005d48:	1101                	addi	sp,sp,-32
    80005d4a:	ec06                	sd	ra,24(sp)
    80005d4c:	e822                	sd	s0,16(sp)
    80005d4e:	e426                	sd	s1,8(sp)
    80005d50:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005d52:	00020497          	auipc	s1,0x20
    80005d56:	49648493          	addi	s1,s1,1174 # 800261e8 <pr>
    80005d5a:	00003597          	auipc	a1,0x3
    80005d5e:	a5e58593          	addi	a1,a1,-1442 # 800087b8 <syscalls+0x3f0>
    80005d62:	8526                	mv	a0,s1
    80005d64:	00000097          	auipc	ra,0x0
    80005d68:	26e080e7          	jalr	622(ra) # 80005fd2 <initlock>
  pr.locking = 1;
    80005d6c:	4785                	li	a5,1
    80005d6e:	cc9c                	sw	a5,24(s1)
}
    80005d70:	60e2                	ld	ra,24(sp)
    80005d72:	6442                	ld	s0,16(sp)
    80005d74:	64a2                	ld	s1,8(sp)
    80005d76:	6105                	addi	sp,sp,32
    80005d78:	8082                	ret

0000000080005d7a <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005d7a:	1141                	addi	sp,sp,-16
    80005d7c:	e406                	sd	ra,8(sp)
    80005d7e:	e022                	sd	s0,0(sp)
    80005d80:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005d82:	100007b7          	lui	a5,0x10000
    80005d86:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005d8a:	f8000713          	li	a4,-128
    80005d8e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005d92:	470d                	li	a4,3
    80005d94:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005d98:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005d9c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005da0:	469d                	li	a3,7
    80005da2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005da6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005daa:	00003597          	auipc	a1,0x3
    80005dae:	a2e58593          	addi	a1,a1,-1490 # 800087d8 <digits+0x18>
    80005db2:	00020517          	auipc	a0,0x20
    80005db6:	45650513          	addi	a0,a0,1110 # 80026208 <uart_tx_lock>
    80005dba:	00000097          	auipc	ra,0x0
    80005dbe:	218080e7          	jalr	536(ra) # 80005fd2 <initlock>
}
    80005dc2:	60a2                	ld	ra,8(sp)
    80005dc4:	6402                	ld	s0,0(sp)
    80005dc6:	0141                	addi	sp,sp,16
    80005dc8:	8082                	ret

0000000080005dca <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005dca:	1101                	addi	sp,sp,-32
    80005dcc:	ec06                	sd	ra,24(sp)
    80005dce:	e822                	sd	s0,16(sp)
    80005dd0:	e426                	sd	s1,8(sp)
    80005dd2:	1000                	addi	s0,sp,32
    80005dd4:	84aa                	mv	s1,a0
  push_off();
    80005dd6:	00000097          	auipc	ra,0x0
    80005dda:	240080e7          	jalr	576(ra) # 80006016 <push_off>

  if(panicked){
    80005dde:	00003797          	auipc	a5,0x3
    80005de2:	23e7a783          	lw	a5,574(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005de6:	10000737          	lui	a4,0x10000
  if(panicked){
    80005dea:	c391                	beqz	a5,80005dee <uartputc_sync+0x24>
    for(;;)
    80005dec:	a001                	j	80005dec <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005dee:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005df2:	0ff7f793          	andi	a5,a5,255
    80005df6:	0207f793          	andi	a5,a5,32
    80005dfa:	dbf5                	beqz	a5,80005dee <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005dfc:	0ff4f793          	andi	a5,s1,255
    80005e00:	10000737          	lui	a4,0x10000
    80005e04:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005e08:	00000097          	auipc	ra,0x0
    80005e0c:	2ae080e7          	jalr	686(ra) # 800060b6 <pop_off>
}
    80005e10:	60e2                	ld	ra,24(sp)
    80005e12:	6442                	ld	s0,16(sp)
    80005e14:	64a2                	ld	s1,8(sp)
    80005e16:	6105                	addi	sp,sp,32
    80005e18:	8082                	ret

0000000080005e1a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005e1a:	00003717          	auipc	a4,0x3
    80005e1e:	20673703          	ld	a4,518(a4) # 80009020 <uart_tx_r>
    80005e22:	00003797          	auipc	a5,0x3
    80005e26:	2067b783          	ld	a5,518(a5) # 80009028 <uart_tx_w>
    80005e2a:	06e78c63          	beq	a5,a4,80005ea2 <uartstart+0x88>
{
    80005e2e:	7139                	addi	sp,sp,-64
    80005e30:	fc06                	sd	ra,56(sp)
    80005e32:	f822                	sd	s0,48(sp)
    80005e34:	f426                	sd	s1,40(sp)
    80005e36:	f04a                	sd	s2,32(sp)
    80005e38:	ec4e                	sd	s3,24(sp)
    80005e3a:	e852                	sd	s4,16(sp)
    80005e3c:	e456                	sd	s5,8(sp)
    80005e3e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005e40:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005e44:	00020a17          	auipc	s4,0x20
    80005e48:	3c4a0a13          	addi	s4,s4,964 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005e4c:	00003497          	auipc	s1,0x3
    80005e50:	1d448493          	addi	s1,s1,468 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005e54:	00003997          	auipc	s3,0x3
    80005e58:	1d498993          	addi	s3,s3,468 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005e5c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005e60:	0ff7f793          	andi	a5,a5,255
    80005e64:	0207f793          	andi	a5,a5,32
    80005e68:	c785                	beqz	a5,80005e90 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005e6a:	01f77793          	andi	a5,a4,31
    80005e6e:	97d2                	add	a5,a5,s4
    80005e70:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005e74:	0705                	addi	a4,a4,1
    80005e76:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005e78:	8526                	mv	a0,s1
    80005e7a:	ffffc097          	auipc	ra,0xffffc
    80005e7e:	816080e7          	jalr	-2026(ra) # 80001690 <wakeup>
    
    WriteReg(THR, c);
    80005e82:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005e86:	6098                	ld	a4,0(s1)
    80005e88:	0009b783          	ld	a5,0(s3)
    80005e8c:	fce798e3          	bne	a5,a4,80005e5c <uartstart+0x42>
  }
}
    80005e90:	70e2                	ld	ra,56(sp)
    80005e92:	7442                	ld	s0,48(sp)
    80005e94:	74a2                	ld	s1,40(sp)
    80005e96:	7902                	ld	s2,32(sp)
    80005e98:	69e2                	ld	s3,24(sp)
    80005e9a:	6a42                	ld	s4,16(sp)
    80005e9c:	6aa2                	ld	s5,8(sp)
    80005e9e:	6121                	addi	sp,sp,64
    80005ea0:	8082                	ret
    80005ea2:	8082                	ret

0000000080005ea4 <uartputc>:
{
    80005ea4:	7179                	addi	sp,sp,-48
    80005ea6:	f406                	sd	ra,40(sp)
    80005ea8:	f022                	sd	s0,32(sp)
    80005eaa:	ec26                	sd	s1,24(sp)
    80005eac:	e84a                	sd	s2,16(sp)
    80005eae:	e44e                	sd	s3,8(sp)
    80005eb0:	e052                	sd	s4,0(sp)
    80005eb2:	1800                	addi	s0,sp,48
    80005eb4:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80005eb6:	00020517          	auipc	a0,0x20
    80005eba:	35250513          	addi	a0,a0,850 # 80026208 <uart_tx_lock>
    80005ebe:	00000097          	auipc	ra,0x0
    80005ec2:	1a4080e7          	jalr	420(ra) # 80006062 <acquire>
  if(panicked){
    80005ec6:	00003797          	auipc	a5,0x3
    80005eca:	1567a783          	lw	a5,342(a5) # 8000901c <panicked>
    80005ece:	c391                	beqz	a5,80005ed2 <uartputc+0x2e>
    for(;;)
    80005ed0:	a001                	j	80005ed0 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005ed2:	00003797          	auipc	a5,0x3
    80005ed6:	1567b783          	ld	a5,342(a5) # 80009028 <uart_tx_w>
    80005eda:	00003717          	auipc	a4,0x3
    80005ede:	14673703          	ld	a4,326(a4) # 80009020 <uart_tx_r>
    80005ee2:	02070713          	addi	a4,a4,32
    80005ee6:	02f71b63          	bne	a4,a5,80005f1c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005eea:	00020a17          	auipc	s4,0x20
    80005eee:	31ea0a13          	addi	s4,s4,798 # 80026208 <uart_tx_lock>
    80005ef2:	00003497          	auipc	s1,0x3
    80005ef6:	12e48493          	addi	s1,s1,302 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005efa:	00003917          	auipc	s2,0x3
    80005efe:	12e90913          	addi	s2,s2,302 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005f02:	85d2                	mv	a1,s4
    80005f04:	8526                	mv	a0,s1
    80005f06:	ffffb097          	auipc	ra,0xffffb
    80005f0a:	5fe080e7          	jalr	1534(ra) # 80001504 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f0e:	00093783          	ld	a5,0(s2)
    80005f12:	6098                	ld	a4,0(s1)
    80005f14:	02070713          	addi	a4,a4,32
    80005f18:	fef705e3          	beq	a4,a5,80005f02 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005f1c:	00020497          	auipc	s1,0x20
    80005f20:	2ec48493          	addi	s1,s1,748 # 80026208 <uart_tx_lock>
    80005f24:	01f7f713          	andi	a4,a5,31
    80005f28:	9726                	add	a4,a4,s1
    80005f2a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    80005f2e:	0785                	addi	a5,a5,1
    80005f30:	00003717          	auipc	a4,0x3
    80005f34:	0ef73c23          	sd	a5,248(a4) # 80009028 <uart_tx_w>
      uartstart();
    80005f38:	00000097          	auipc	ra,0x0
    80005f3c:	ee2080e7          	jalr	-286(ra) # 80005e1a <uartstart>
      release(&uart_tx_lock);
    80005f40:	8526                	mv	a0,s1
    80005f42:	00000097          	auipc	ra,0x0
    80005f46:	1d4080e7          	jalr	468(ra) # 80006116 <release>
}
    80005f4a:	70a2                	ld	ra,40(sp)
    80005f4c:	7402                	ld	s0,32(sp)
    80005f4e:	64e2                	ld	s1,24(sp)
    80005f50:	6942                	ld	s2,16(sp)
    80005f52:	69a2                	ld	s3,8(sp)
    80005f54:	6a02                	ld	s4,0(sp)
    80005f56:	6145                	addi	sp,sp,48
    80005f58:	8082                	ret

0000000080005f5a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005f5a:	1141                	addi	sp,sp,-16
    80005f5c:	e422                	sd	s0,8(sp)
    80005f5e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005f60:	100007b7          	lui	a5,0x10000
    80005f64:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005f68:	8b85                	andi	a5,a5,1
    80005f6a:	cb91                	beqz	a5,80005f7e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005f6c:	100007b7          	lui	a5,0x10000
    80005f70:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80005f74:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80005f78:	6422                	ld	s0,8(sp)
    80005f7a:	0141                	addi	sp,sp,16
    80005f7c:	8082                	ret
    return -1;
    80005f7e:	557d                	li	a0,-1
    80005f80:	bfe5                	j	80005f78 <uartgetc+0x1e>

0000000080005f82 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80005f82:	1101                	addi	sp,sp,-32
    80005f84:	ec06                	sd	ra,24(sp)
    80005f86:	e822                	sd	s0,16(sp)
    80005f88:	e426                	sd	s1,8(sp)
    80005f8a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005f8c:	54fd                	li	s1,-1
    int c = uartgetc();
    80005f8e:	00000097          	auipc	ra,0x0
    80005f92:	fcc080e7          	jalr	-52(ra) # 80005f5a <uartgetc>
    if(c == -1)
    80005f96:	00950763          	beq	a0,s1,80005fa4 <uartintr+0x22>
      break;
    consoleintr(c);
    80005f9a:	00000097          	auipc	ra,0x0
    80005f9e:	8fe080e7          	jalr	-1794(ra) # 80005898 <consoleintr>
  while(1){
    80005fa2:	b7f5                	j	80005f8e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80005fa4:	00020497          	auipc	s1,0x20
    80005fa8:	26448493          	addi	s1,s1,612 # 80026208 <uart_tx_lock>
    80005fac:	8526                	mv	a0,s1
    80005fae:	00000097          	auipc	ra,0x0
    80005fb2:	0b4080e7          	jalr	180(ra) # 80006062 <acquire>
  uartstart();
    80005fb6:	00000097          	auipc	ra,0x0
    80005fba:	e64080e7          	jalr	-412(ra) # 80005e1a <uartstart>
  release(&uart_tx_lock);
    80005fbe:	8526                	mv	a0,s1
    80005fc0:	00000097          	auipc	ra,0x0
    80005fc4:	156080e7          	jalr	342(ra) # 80006116 <release>
}
    80005fc8:	60e2                	ld	ra,24(sp)
    80005fca:	6442                	ld	s0,16(sp)
    80005fcc:	64a2                	ld	s1,8(sp)
    80005fce:	6105                	addi	sp,sp,32
    80005fd0:	8082                	ret

0000000080005fd2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005fd2:	1141                	addi	sp,sp,-16
    80005fd4:	e422                	sd	s0,8(sp)
    80005fd6:	0800                	addi	s0,sp,16
  lk->name = name;
    80005fd8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005fda:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005fde:	00053823          	sd	zero,16(a0)
}
    80005fe2:	6422                	ld	s0,8(sp)
    80005fe4:	0141                	addi	sp,sp,16
    80005fe6:	8082                	ret

0000000080005fe8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005fe8:	411c                	lw	a5,0(a0)
    80005fea:	e399                	bnez	a5,80005ff0 <holding+0x8>
    80005fec:	4501                	li	a0,0
  return r;
}
    80005fee:	8082                	ret
{
    80005ff0:	1101                	addi	sp,sp,-32
    80005ff2:	ec06                	sd	ra,24(sp)
    80005ff4:	e822                	sd	s0,16(sp)
    80005ff6:	e426                	sd	s1,8(sp)
    80005ff8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005ffa:	6904                	ld	s1,16(a0)
    80005ffc:	ffffb097          	auipc	ra,0xffffb
    80006000:	e30080e7          	jalr	-464(ra) # 80000e2c <mycpu>
    80006004:	40a48533          	sub	a0,s1,a0
    80006008:	00153513          	seqz	a0,a0
}
    8000600c:	60e2                	ld	ra,24(sp)
    8000600e:	6442                	ld	s0,16(sp)
    80006010:	64a2                	ld	s1,8(sp)
    80006012:	6105                	addi	sp,sp,32
    80006014:	8082                	ret

0000000080006016 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006016:	1101                	addi	sp,sp,-32
    80006018:	ec06                	sd	ra,24(sp)
    8000601a:	e822                	sd	s0,16(sp)
    8000601c:	e426                	sd	s1,8(sp)
    8000601e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006020:	100024f3          	csrr	s1,sstatus
    80006024:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006028:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000602a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000602e:	ffffb097          	auipc	ra,0xffffb
    80006032:	dfe080e7          	jalr	-514(ra) # 80000e2c <mycpu>
    80006036:	5d3c                	lw	a5,120(a0)
    80006038:	cf89                	beqz	a5,80006052 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000603a:	ffffb097          	auipc	ra,0xffffb
    8000603e:	df2080e7          	jalr	-526(ra) # 80000e2c <mycpu>
    80006042:	5d3c                	lw	a5,120(a0)
    80006044:	2785                	addiw	a5,a5,1
    80006046:	dd3c                	sw	a5,120(a0)
}
    80006048:	60e2                	ld	ra,24(sp)
    8000604a:	6442                	ld	s0,16(sp)
    8000604c:	64a2                	ld	s1,8(sp)
    8000604e:	6105                	addi	sp,sp,32
    80006050:	8082                	ret
    mycpu()->intena = old;
    80006052:	ffffb097          	auipc	ra,0xffffb
    80006056:	dda080e7          	jalr	-550(ra) # 80000e2c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000605a:	8085                	srli	s1,s1,0x1
    8000605c:	8885                	andi	s1,s1,1
    8000605e:	dd64                	sw	s1,124(a0)
    80006060:	bfe9                	j	8000603a <push_off+0x24>

0000000080006062 <acquire>:
{
    80006062:	1101                	addi	sp,sp,-32
    80006064:	ec06                	sd	ra,24(sp)
    80006066:	e822                	sd	s0,16(sp)
    80006068:	e426                	sd	s1,8(sp)
    8000606a:	1000                	addi	s0,sp,32
    8000606c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000606e:	00000097          	auipc	ra,0x0
    80006072:	fa8080e7          	jalr	-88(ra) # 80006016 <push_off>
  if(holding(lk))
    80006076:	8526                	mv	a0,s1
    80006078:	00000097          	auipc	ra,0x0
    8000607c:	f70080e7          	jalr	-144(ra) # 80005fe8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006080:	4705                	li	a4,1
  if(holding(lk))
    80006082:	e115                	bnez	a0,800060a6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006084:	87ba                	mv	a5,a4
    80006086:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000608a:	2781                	sext.w	a5,a5
    8000608c:	ffe5                	bnez	a5,80006084 <acquire+0x22>
  __sync_synchronize();
    8000608e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006092:	ffffb097          	auipc	ra,0xffffb
    80006096:	d9a080e7          	jalr	-614(ra) # 80000e2c <mycpu>
    8000609a:	e888                	sd	a0,16(s1)
}
    8000609c:	60e2                	ld	ra,24(sp)
    8000609e:	6442                	ld	s0,16(sp)
    800060a0:	64a2                	ld	s1,8(sp)
    800060a2:	6105                	addi	sp,sp,32
    800060a4:	8082                	ret
    panic("acquire");
    800060a6:	00002517          	auipc	a0,0x2
    800060aa:	73a50513          	addi	a0,a0,1850 # 800087e0 <digits+0x20>
    800060ae:	00000097          	auipc	ra,0x0
    800060b2:	a6a080e7          	jalr	-1430(ra) # 80005b18 <panic>

00000000800060b6 <pop_off>:

void
pop_off(void)
{
    800060b6:	1141                	addi	sp,sp,-16
    800060b8:	e406                	sd	ra,8(sp)
    800060ba:	e022                	sd	s0,0(sp)
    800060bc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800060be:	ffffb097          	auipc	ra,0xffffb
    800060c2:	d6e080e7          	jalr	-658(ra) # 80000e2c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800060c6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800060ca:	8b89                	andi	a5,a5,2
  if(intr_get())
    800060cc:	e78d                	bnez	a5,800060f6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800060ce:	5d3c                	lw	a5,120(a0)
    800060d0:	02f05b63          	blez	a5,80006106 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800060d4:	37fd                	addiw	a5,a5,-1
    800060d6:	0007871b          	sext.w	a4,a5
    800060da:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800060dc:	eb09                	bnez	a4,800060ee <pop_off+0x38>
    800060de:	5d7c                	lw	a5,124(a0)
    800060e0:	c799                	beqz	a5,800060ee <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800060e2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800060e6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800060ea:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800060ee:	60a2                	ld	ra,8(sp)
    800060f0:	6402                	ld	s0,0(sp)
    800060f2:	0141                	addi	sp,sp,16
    800060f4:	8082                	ret
    panic("pop_off - interruptible");
    800060f6:	00002517          	auipc	a0,0x2
    800060fa:	6f250513          	addi	a0,a0,1778 # 800087e8 <digits+0x28>
    800060fe:	00000097          	auipc	ra,0x0
    80006102:	a1a080e7          	jalr	-1510(ra) # 80005b18 <panic>
    panic("pop_off");
    80006106:	00002517          	auipc	a0,0x2
    8000610a:	6fa50513          	addi	a0,a0,1786 # 80008800 <digits+0x40>
    8000610e:	00000097          	auipc	ra,0x0
    80006112:	a0a080e7          	jalr	-1526(ra) # 80005b18 <panic>

0000000080006116 <release>:
{
    80006116:	1101                	addi	sp,sp,-32
    80006118:	ec06                	sd	ra,24(sp)
    8000611a:	e822                	sd	s0,16(sp)
    8000611c:	e426                	sd	s1,8(sp)
    8000611e:	1000                	addi	s0,sp,32
    80006120:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006122:	00000097          	auipc	ra,0x0
    80006126:	ec6080e7          	jalr	-314(ra) # 80005fe8 <holding>
    8000612a:	c115                	beqz	a0,8000614e <release+0x38>
  lk->cpu = 0;
    8000612c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006130:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006134:	0f50000f          	fence	iorw,ow
    80006138:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000613c:	00000097          	auipc	ra,0x0
    80006140:	f7a080e7          	jalr	-134(ra) # 800060b6 <pop_off>
}
    80006144:	60e2                	ld	ra,24(sp)
    80006146:	6442                	ld	s0,16(sp)
    80006148:	64a2                	ld	s1,8(sp)
    8000614a:	6105                	addi	sp,sp,32
    8000614c:	8082                	ret
    panic("release");
    8000614e:	00002517          	auipc	a0,0x2
    80006152:	6ba50513          	addi	a0,a0,1722 # 80008808 <digits+0x48>
    80006156:	00000097          	auipc	ra,0x0
    8000615a:	9c2080e7          	jalr	-1598(ra) # 80005b18 <panic>
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
