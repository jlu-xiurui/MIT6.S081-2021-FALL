
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00028117          	auipc	sp,0x28
    80000004:	14010113          	addi	sp,sp,320 # 80028140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	323050ef          	jal	ra,80005b38 <start>

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
    80000030:	00030797          	auipc	a5,0x30
    80000034:	21078793          	addi	a5,a5,528 # 80030240 <end>
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
    8000005e:	4d8080e7          	jalr	1240(ra) # 80006532 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	578080e7          	jalr	1400(ra) # 800065e6 <release>
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
    8000008e:	f5e080e7          	jalr	-162(ra) # 80005fe8 <panic>

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
    800000f8:	3ae080e7          	jalr	942(ra) # 800064a2 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00030517          	auipc	a0,0x30
    80000104:	14050513          	addi	a0,a0,320 # 80030240 <end>
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
    80000130:	406080e7          	jalr	1030(ra) # 80006532 <acquire>
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
    80000148:	4a2080e7          	jalr	1186(ra) # 800065e6 <release>

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
    80000172:	478080e7          	jalr	1144(ra) # 800065e6 <release>
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
    80000332:	ad4080e7          	jalr	-1324(ra) # 80000e02 <cpuid>
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
    8000034e:	ab8080e7          	jalr	-1352(ra) # 80000e02 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	cd6080e7          	jalr	-810(ra) # 80006032 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	868080e7          	jalr	-1944(ra) # 80001bd4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	14c080e7          	jalr	332(ra) # 800054c0 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	080080e7          	jalr	128(ra) # 800013fc <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	b76080e7          	jalr	-1162(ra) # 80005efa <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	e8c080e7          	jalr	-372(ra) # 80006218 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	c96080e7          	jalr	-874(ra) # 80006032 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	c86080e7          	jalr	-890(ra) # 80006032 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	c76080e7          	jalr	-906(ra) # 80006032 <printf>
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
    800003e0:	976080e7          	jalr	-1674(ra) # 80000d52 <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	7c8080e7          	jalr	1992(ra) # 80001bac <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	7e8080e7          	jalr	2024(ra) # 80001bd4 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	0b6080e7          	jalr	182(ra) # 800054aa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	0c4080e7          	jalr	196(ra) # 800054c0 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	2a2080e7          	jalr	674(ra) # 800026a6 <binit>
    iinit();         // inode table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	932080e7          	jalr	-1742(ra) # 80002d3e <iinit>
    fileinit();      // file table
    80000414:	00004097          	auipc	ra,0x4
    80000418:	8dc080e7          	jalr	-1828(ra) # 80003cf0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	1c6080e7          	jalr	454(ra) # 800055e2 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d36080e7          	jalr	-714(ra) # 8000115a <userinit>
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
    80000492:	b5a080e7          	jalr	-1190(ra) # 80005fe8 <panic>
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
    8000058a:	a62080e7          	jalr	-1438(ra) # 80005fe8 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	a52080e7          	jalr	-1454(ra) # 80005fe8 <panic>
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
    80000614:	9d8080e7          	jalr	-1576(ra) # 80005fe8 <panic>

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
    800006dc:	5e4080e7          	jalr	1508(ra) # 80000cbc <proc_mapstacks>
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
    8000072e:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
        continue;
    if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6a85                	lui	s5,0x1
    8000073a:	0735e163          	bltu	a1,s3,8000079c <uvmunmap+0x8e>
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
    8000075c:	00006097          	auipc	ra,0x6
    80000760:	88c080e7          	jalr	-1908(ra) # 80005fe8 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00006097          	auipc	ra,0x6
    80000770:	87c080e7          	jalr	-1924(ra) # 80005fe8 <panic>
      panic("uvmunmap: not a leaf");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00006097          	auipc	ra,0x6
    80000780:	86c080e7          	jalr	-1940(ra) # 80005fe8 <panic>
      uint64 pa = PTE2PA(*pte);
    80000784:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    80000786:	00c79513          	slli	a0,a5,0xc
    8000078a:	00000097          	auipc	ra,0x0
    8000078e:	892080e7          	jalr	-1902(ra) # 8000001c <kfree>
    *pte = 0;
    80000792:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000796:	9956                	add	s2,s2,s5
    80000798:	fb3973e3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000079c:	4601                	li	a2,0
    8000079e:	85ca                	mv	a1,s2
    800007a0:	8552                	mv	a0,s4
    800007a2:	00000097          	auipc	ra,0x0
    800007a6:	cbe080e7          	jalr	-834(ra) # 80000460 <walk>
    800007aa:	84aa                	mv	s1,a0
    800007ac:	dd45                	beqz	a0,80000764 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007ae:	611c                	ld	a5,0(a0)
    800007b0:	0017f713          	andi	a4,a5,1
    800007b4:	d36d                	beqz	a4,80000796 <uvmunmap+0x88>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b6:	3ff7f713          	andi	a4,a5,1023
    800007ba:	fb770de3          	beq	a4,s7,80000774 <uvmunmap+0x66>
    if(do_free){
    800007be:	fc0b0ae3          	beqz	s6,80000792 <uvmunmap+0x84>
    800007c2:	b7c9                	j	80000784 <uvmunmap+0x76>

00000000800007c4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007c4:	1101                	addi	sp,sp,-32
    800007c6:	ec06                	sd	ra,24(sp)
    800007c8:	e822                	sd	s0,16(sp)
    800007ca:	e426                	sd	s1,8(sp)
    800007cc:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	94a080e7          	jalr	-1718(ra) # 80000118 <kalloc>
    800007d6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007d8:	c519                	beqz	a0,800007e6 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007da:	6605                	lui	a2,0x1
    800007dc:	4581                	li	a1,0
    800007de:	00000097          	auipc	ra,0x0
    800007e2:	99a080e7          	jalr	-1638(ra) # 80000178 <memset>
  return pagetable;
}
    800007e6:	8526                	mv	a0,s1
    800007e8:	60e2                	ld	ra,24(sp)
    800007ea:	6442                	ld	s0,16(sp)
    800007ec:	64a2                	ld	s1,8(sp)
    800007ee:	6105                	addi	sp,sp,32
    800007f0:	8082                	ret

00000000800007f2 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007f2:	7179                	addi	sp,sp,-48
    800007f4:	f406                	sd	ra,40(sp)
    800007f6:	f022                	sd	s0,32(sp)
    800007f8:	ec26                	sd	s1,24(sp)
    800007fa:	e84a                	sd	s2,16(sp)
    800007fc:	e44e                	sd	s3,8(sp)
    800007fe:	e052                	sd	s4,0(sp)
    80000800:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000802:	6785                	lui	a5,0x1
    80000804:	04f67863          	bgeu	a2,a5,80000854 <uvminit+0x62>
    80000808:	8a2a                	mv	s4,a0
    8000080a:	89ae                	mv	s3,a1
    8000080c:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000080e:	00000097          	auipc	ra,0x0
    80000812:	90a080e7          	jalr	-1782(ra) # 80000118 <kalloc>
    80000816:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000818:	6605                	lui	a2,0x1
    8000081a:	4581                	li	a1,0
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	95c080e7          	jalr	-1700(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000824:	4779                	li	a4,30
    80000826:	86ca                	mv	a3,s2
    80000828:	6605                	lui	a2,0x1
    8000082a:	4581                	li	a1,0
    8000082c:	8552                	mv	a0,s4
    8000082e:	00000097          	auipc	ra,0x0
    80000832:	d1a080e7          	jalr	-742(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    80000836:	8626                	mv	a2,s1
    80000838:	85ce                	mv	a1,s3
    8000083a:	854a                	mv	a0,s2
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	99c080e7          	jalr	-1636(ra) # 800001d8 <memmove>
}
    80000844:	70a2                	ld	ra,40(sp)
    80000846:	7402                	ld	s0,32(sp)
    80000848:	64e2                	ld	s1,24(sp)
    8000084a:	6942                	ld	s2,16(sp)
    8000084c:	69a2                	ld	s3,8(sp)
    8000084e:	6a02                	ld	s4,0(sp)
    80000850:	6145                	addi	sp,sp,48
    80000852:	8082                	ret
    panic("inituvm: more than a page");
    80000854:	00008517          	auipc	a0,0x8
    80000858:	86c50513          	addi	a0,a0,-1940 # 800080c0 <etext+0xc0>
    8000085c:	00005097          	auipc	ra,0x5
    80000860:	78c080e7          	jalr	1932(ra) # 80005fe8 <panic>

0000000080000864 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000864:	1101                	addi	sp,sp,-32
    80000866:	ec06                	sd	ra,24(sp)
    80000868:	e822                	sd	s0,16(sp)
    8000086a:	e426                	sd	s1,8(sp)
    8000086c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000086e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000870:	00b67d63          	bgeu	a2,a1,8000088a <uvmdealloc+0x26>
    80000874:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000876:	6785                	lui	a5,0x1
    80000878:	17fd                	addi	a5,a5,-1
    8000087a:	00f60733          	add	a4,a2,a5
    8000087e:	767d                	lui	a2,0xfffff
    80000880:	8f71                	and	a4,a4,a2
    80000882:	97ae                	add	a5,a5,a1
    80000884:	8ff1                	and	a5,a5,a2
    80000886:	00f76863          	bltu	a4,a5,80000896 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000088a:	8526                	mv	a0,s1
    8000088c:	60e2                	ld	ra,24(sp)
    8000088e:	6442                	ld	s0,16(sp)
    80000890:	64a2                	ld	s1,8(sp)
    80000892:	6105                	addi	sp,sp,32
    80000894:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000896:	8f99                	sub	a5,a5,a4
    80000898:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000089a:	4685                	li	a3,1
    8000089c:	0007861b          	sext.w	a2,a5
    800008a0:	85ba                	mv	a1,a4
    800008a2:	00000097          	auipc	ra,0x0
    800008a6:	e6c080e7          	jalr	-404(ra) # 8000070e <uvmunmap>
    800008aa:	b7c5                	j	8000088a <uvmdealloc+0x26>

00000000800008ac <uvmalloc>:
  if(newsz < oldsz)
    800008ac:	0ab66163          	bltu	a2,a1,8000094e <uvmalloc+0xa2>
{
    800008b0:	7139                	addi	sp,sp,-64
    800008b2:	fc06                	sd	ra,56(sp)
    800008b4:	f822                	sd	s0,48(sp)
    800008b6:	f426                	sd	s1,40(sp)
    800008b8:	f04a                	sd	s2,32(sp)
    800008ba:	ec4e                	sd	s3,24(sp)
    800008bc:	e852                	sd	s4,16(sp)
    800008be:	e456                	sd	s5,8(sp)
    800008c0:	0080                	addi	s0,sp,64
    800008c2:	8aaa                	mv	s5,a0
    800008c4:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008c6:	6985                	lui	s3,0x1
    800008c8:	19fd                	addi	s3,s3,-1
    800008ca:	95ce                	add	a1,a1,s3
    800008cc:	79fd                	lui	s3,0xfffff
    800008ce:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008d2:	08c9f063          	bgeu	s3,a2,80000952 <uvmalloc+0xa6>
    800008d6:	894e                	mv	s2,s3
    mem = kalloc();
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	840080e7          	jalr	-1984(ra) # 80000118 <kalloc>
    800008e0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008e2:	c51d                	beqz	a0,80000910 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008e4:	6605                	lui	a2,0x1
    800008e6:	4581                	li	a1,0
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	890080e7          	jalr	-1904(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008f0:	4779                	li	a4,30
    800008f2:	86a6                	mv	a3,s1
    800008f4:	6605                	lui	a2,0x1
    800008f6:	85ca                	mv	a1,s2
    800008f8:	8556                	mv	a0,s5
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	c4e080e7          	jalr	-946(ra) # 80000548 <mappages>
    80000902:	e905                	bnez	a0,80000932 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000904:	6785                	lui	a5,0x1
    80000906:	993e                	add	s2,s2,a5
    80000908:	fd4968e3          	bltu	s2,s4,800008d8 <uvmalloc+0x2c>
  return newsz;
    8000090c:	8552                	mv	a0,s4
    8000090e:	a809                	j	80000920 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000910:	864e                	mv	a2,s3
    80000912:	85ca                	mv	a1,s2
    80000914:	8556                	mv	a0,s5
    80000916:	00000097          	auipc	ra,0x0
    8000091a:	f4e080e7          	jalr	-178(ra) # 80000864 <uvmdealloc>
      return 0;
    8000091e:	4501                	li	a0,0
}
    80000920:	70e2                	ld	ra,56(sp)
    80000922:	7442                	ld	s0,48(sp)
    80000924:	74a2                	ld	s1,40(sp)
    80000926:	7902                	ld	s2,32(sp)
    80000928:	69e2                	ld	s3,24(sp)
    8000092a:	6a42                	ld	s4,16(sp)
    8000092c:	6aa2                	ld	s5,8(sp)
    8000092e:	6121                	addi	sp,sp,64
    80000930:	8082                	ret
      kfree(mem);
    80000932:	8526                	mv	a0,s1
    80000934:	fffff097          	auipc	ra,0xfffff
    80000938:	6e8080e7          	jalr	1768(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000093c:	864e                	mv	a2,s3
    8000093e:	85ca                	mv	a1,s2
    80000940:	8556                	mv	a0,s5
    80000942:	00000097          	auipc	ra,0x0
    80000946:	f22080e7          	jalr	-222(ra) # 80000864 <uvmdealloc>
      return 0;
    8000094a:	4501                	li	a0,0
    8000094c:	bfd1                	j	80000920 <uvmalloc+0x74>
    return oldsz;
    8000094e:	852e                	mv	a0,a1
}
    80000950:	8082                	ret
  return newsz;
    80000952:	8532                	mv	a0,a2
    80000954:	b7f1                	j	80000920 <uvmalloc+0x74>

0000000080000956 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000956:	7179                	addi	sp,sp,-48
    80000958:	f406                	sd	ra,40(sp)
    8000095a:	f022                	sd	s0,32(sp)
    8000095c:	ec26                	sd	s1,24(sp)
    8000095e:	e84a                	sd	s2,16(sp)
    80000960:	e44e                	sd	s3,8(sp)
    80000962:	e052                	sd	s4,0(sp)
    80000964:	1800                	addi	s0,sp,48
    80000966:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000968:	84aa                	mv	s1,a0
    8000096a:	6905                	lui	s2,0x1
    8000096c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000096e:	4985                	li	s3,1
    80000970:	a821                	j	80000988 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000972:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000974:	0532                	slli	a0,a0,0xc
    80000976:	00000097          	auipc	ra,0x0
    8000097a:	fe0080e7          	jalr	-32(ra) # 80000956 <freewalk>
      pagetable[i] = 0;
    8000097e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000982:	04a1                	addi	s1,s1,8
    80000984:	03248163          	beq	s1,s2,800009a6 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000988:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000098a:	00f57793          	andi	a5,a0,15
    8000098e:	ff3782e3          	beq	a5,s3,80000972 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000992:	8905                	andi	a0,a0,1
    80000994:	d57d                	beqz	a0,80000982 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000996:	00007517          	auipc	a0,0x7
    8000099a:	74a50513          	addi	a0,a0,1866 # 800080e0 <etext+0xe0>
    8000099e:	00005097          	auipc	ra,0x5
    800009a2:	64a080e7          	jalr	1610(ra) # 80005fe8 <panic>
    }
  }
  kfree((void*)pagetable);
    800009a6:	8552                	mv	a0,s4
    800009a8:	fffff097          	auipc	ra,0xfffff
    800009ac:	674080e7          	jalr	1652(ra) # 8000001c <kfree>
}
    800009b0:	70a2                	ld	ra,40(sp)
    800009b2:	7402                	ld	s0,32(sp)
    800009b4:	64e2                	ld	s1,24(sp)
    800009b6:	6942                	ld	s2,16(sp)
    800009b8:	69a2                	ld	s3,8(sp)
    800009ba:	6a02                	ld	s4,0(sp)
    800009bc:	6145                	addi	sp,sp,48
    800009be:	8082                	ret

00000000800009c0 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009c0:	1101                	addi	sp,sp,-32
    800009c2:	ec06                	sd	ra,24(sp)
    800009c4:	e822                	sd	s0,16(sp)
    800009c6:	e426                	sd	s1,8(sp)
    800009c8:	1000                	addi	s0,sp,32
    800009ca:	84aa                	mv	s1,a0
  if(sz > 0)
    800009cc:	e999                	bnez	a1,800009e2 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009ce:	8526                	mv	a0,s1
    800009d0:	00000097          	auipc	ra,0x0
    800009d4:	f86080e7          	jalr	-122(ra) # 80000956 <freewalk>
}
    800009d8:	60e2                	ld	ra,24(sp)
    800009da:	6442                	ld	s0,16(sp)
    800009dc:	64a2                	ld	s1,8(sp)
    800009de:	6105                	addi	sp,sp,32
    800009e0:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009e2:	6605                	lui	a2,0x1
    800009e4:	167d                	addi	a2,a2,-1
    800009e6:	962e                	add	a2,a2,a1
    800009e8:	4685                	li	a3,1
    800009ea:	8231                	srli	a2,a2,0xc
    800009ec:	4581                	li	a1,0
    800009ee:	00000097          	auipc	ra,0x0
    800009f2:	d20080e7          	jalr	-736(ra) # 8000070e <uvmunmap>
    800009f6:	bfe1                	j	800009ce <uvmfree+0xe>

00000000800009f8 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800009f8:	c269                	beqz	a2,80000aba <uvmcopy+0xc2>
{
    800009fa:	715d                	addi	sp,sp,-80
    800009fc:	e486                	sd	ra,72(sp)
    800009fe:	e0a2                	sd	s0,64(sp)
    80000a00:	fc26                	sd	s1,56(sp)
    80000a02:	f84a                	sd	s2,48(sp)
    80000a04:	f44e                	sd	s3,40(sp)
    80000a06:	f052                	sd	s4,32(sp)
    80000a08:	ec56                	sd	s5,24(sp)
    80000a0a:	e85a                	sd	s6,16(sp)
    80000a0c:	e45e                	sd	s7,8(sp)
    80000a0e:	0880                	addi	s0,sp,80
    80000a10:	8aaa                	mv	s5,a0
    80000a12:	8b2e                	mv	s6,a1
    80000a14:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a16:	4481                	li	s1,0
    80000a18:	a829                	j	80000a32 <uvmcopy+0x3a>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000a1a:	00007517          	auipc	a0,0x7
    80000a1e:	6d650513          	addi	a0,a0,1750 # 800080f0 <etext+0xf0>
    80000a22:	00005097          	auipc	ra,0x5
    80000a26:	5c6080e7          	jalr	1478(ra) # 80005fe8 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    80000a2a:	6785                	lui	a5,0x1
    80000a2c:	94be                	add	s1,s1,a5
    80000a2e:	0944f463          	bgeu	s1,s4,80000ab6 <uvmcopy+0xbe>
    if((pte = walk(old, i, 0)) == 0)
    80000a32:	4601                	li	a2,0
    80000a34:	85a6                	mv	a1,s1
    80000a36:	8556                	mv	a0,s5
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	a28080e7          	jalr	-1496(ra) # 80000460 <walk>
    80000a40:	dd69                	beqz	a0,80000a1a <uvmcopy+0x22>
    if((*pte & PTE_V) == 0)
    80000a42:	6118                	ld	a4,0(a0)
    80000a44:	00177793          	andi	a5,a4,1
    80000a48:	d3ed                	beqz	a5,80000a2a <uvmcopy+0x32>
        continue;
    pa = PTE2PA(*pte);
    80000a4a:	00a75593          	srli	a1,a4,0xa
    80000a4e:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a52:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    80000a56:	fffff097          	auipc	ra,0xfffff
    80000a5a:	6c2080e7          	jalr	1730(ra) # 80000118 <kalloc>
    80000a5e:	89aa                	mv	s3,a0
    80000a60:	c515                	beqz	a0,80000a8c <uvmcopy+0x94>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a62:	6605                	lui	a2,0x1
    80000a64:	85de                	mv	a1,s7
    80000a66:	fffff097          	auipc	ra,0xfffff
    80000a6a:	772080e7          	jalr	1906(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a6e:	874a                	mv	a4,s2
    80000a70:	86ce                	mv	a3,s3
    80000a72:	6605                	lui	a2,0x1
    80000a74:	85a6                	mv	a1,s1
    80000a76:	855a                	mv	a0,s6
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	ad0080e7          	jalr	-1328(ra) # 80000548 <mappages>
    80000a80:	d54d                	beqz	a0,80000a2a <uvmcopy+0x32>
      kfree(mem);
    80000a82:	854e                	mv	a0,s3
    80000a84:	fffff097          	auipc	ra,0xfffff
    80000a88:	598080e7          	jalr	1432(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a8c:	4685                	li	a3,1
    80000a8e:	00c4d613          	srli	a2,s1,0xc
    80000a92:	4581                	li	a1,0
    80000a94:	855a                	mv	a0,s6
    80000a96:	00000097          	auipc	ra,0x0
    80000a9a:	c78080e7          	jalr	-904(ra) # 8000070e <uvmunmap>
  return -1;
    80000a9e:	557d                	li	a0,-1
}
    80000aa0:	60a6                	ld	ra,72(sp)
    80000aa2:	6406                	ld	s0,64(sp)
    80000aa4:	74e2                	ld	s1,56(sp)
    80000aa6:	7942                	ld	s2,48(sp)
    80000aa8:	79a2                	ld	s3,40(sp)
    80000aaa:	7a02                	ld	s4,32(sp)
    80000aac:	6ae2                	ld	s5,24(sp)
    80000aae:	6b42                	ld	s6,16(sp)
    80000ab0:	6ba2                	ld	s7,8(sp)
    80000ab2:	6161                	addi	sp,sp,80
    80000ab4:	8082                	ret
  return 0;
    80000ab6:	4501                	li	a0,0
    80000ab8:	b7e5                	j	80000aa0 <uvmcopy+0xa8>
    80000aba:	4501                	li	a0,0
}
    80000abc:	8082                	ret

0000000080000abe <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000abe:	1141                	addi	sp,sp,-16
    80000ac0:	e406                	sd	ra,8(sp)
    80000ac2:	e022                	sd	s0,0(sp)
    80000ac4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ac6:	4601                	li	a2,0
    80000ac8:	00000097          	auipc	ra,0x0
    80000acc:	998080e7          	jalr	-1640(ra) # 80000460 <walk>
  if(pte == 0)
    80000ad0:	c901                	beqz	a0,80000ae0 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ad2:	611c                	ld	a5,0(a0)
    80000ad4:	9bbd                	andi	a5,a5,-17
    80000ad6:	e11c                	sd	a5,0(a0)
}
    80000ad8:	60a2                	ld	ra,8(sp)
    80000ada:	6402                	ld	s0,0(sp)
    80000adc:	0141                	addi	sp,sp,16
    80000ade:	8082                	ret
    panic("uvmclear");
    80000ae0:	00007517          	auipc	a0,0x7
    80000ae4:	63050513          	addi	a0,a0,1584 # 80008110 <etext+0x110>
    80000ae8:	00005097          	auipc	ra,0x5
    80000aec:	500080e7          	jalr	1280(ra) # 80005fe8 <panic>

0000000080000af0 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000af0:	c6bd                	beqz	a3,80000b5e <copyout+0x6e>
{
    80000af2:	715d                	addi	sp,sp,-80
    80000af4:	e486                	sd	ra,72(sp)
    80000af6:	e0a2                	sd	s0,64(sp)
    80000af8:	fc26                	sd	s1,56(sp)
    80000afa:	f84a                	sd	s2,48(sp)
    80000afc:	f44e                	sd	s3,40(sp)
    80000afe:	f052                	sd	s4,32(sp)
    80000b00:	ec56                	sd	s5,24(sp)
    80000b02:	e85a                	sd	s6,16(sp)
    80000b04:	e45e                	sd	s7,8(sp)
    80000b06:	e062                	sd	s8,0(sp)
    80000b08:	0880                	addi	s0,sp,80
    80000b0a:	8b2a                	mv	s6,a0
    80000b0c:	8c2e                	mv	s8,a1
    80000b0e:	8a32                	mv	s4,a2
    80000b10:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b12:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b14:	6a85                	lui	s5,0x1
    80000b16:	a015                	j	80000b3a <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b18:	9562                	add	a0,a0,s8
    80000b1a:	0004861b          	sext.w	a2,s1
    80000b1e:	85d2                	mv	a1,s4
    80000b20:	41250533          	sub	a0,a0,s2
    80000b24:	fffff097          	auipc	ra,0xfffff
    80000b28:	6b4080e7          	jalr	1716(ra) # 800001d8 <memmove>

    len -= n;
    80000b2c:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b30:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b32:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b36:	02098263          	beqz	s3,80000b5a <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b3a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b3e:	85ca                	mv	a1,s2
    80000b40:	855a                	mv	a0,s6
    80000b42:	00000097          	auipc	ra,0x0
    80000b46:	9c4080e7          	jalr	-1596(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b4a:	cd01                	beqz	a0,80000b62 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b4c:	418904b3          	sub	s1,s2,s8
    80000b50:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b52:	fc99f3e3          	bgeu	s3,s1,80000b18 <copyout+0x28>
    80000b56:	84ce                	mv	s1,s3
    80000b58:	b7c1                	j	80000b18 <copyout+0x28>
  }
  return 0;
    80000b5a:	4501                	li	a0,0
    80000b5c:	a021                	j	80000b64 <copyout+0x74>
    80000b5e:	4501                	li	a0,0
}
    80000b60:	8082                	ret
      return -1;
    80000b62:	557d                	li	a0,-1
}
    80000b64:	60a6                	ld	ra,72(sp)
    80000b66:	6406                	ld	s0,64(sp)
    80000b68:	74e2                	ld	s1,56(sp)
    80000b6a:	7942                	ld	s2,48(sp)
    80000b6c:	79a2                	ld	s3,40(sp)
    80000b6e:	7a02                	ld	s4,32(sp)
    80000b70:	6ae2                	ld	s5,24(sp)
    80000b72:	6b42                	ld	s6,16(sp)
    80000b74:	6ba2                	ld	s7,8(sp)
    80000b76:	6c02                	ld	s8,0(sp)
    80000b78:	6161                	addi	sp,sp,80
    80000b7a:	8082                	ret

0000000080000b7c <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b7c:	c6bd                	beqz	a3,80000bea <copyin+0x6e>
{
    80000b7e:	715d                	addi	sp,sp,-80
    80000b80:	e486                	sd	ra,72(sp)
    80000b82:	e0a2                	sd	s0,64(sp)
    80000b84:	fc26                	sd	s1,56(sp)
    80000b86:	f84a                	sd	s2,48(sp)
    80000b88:	f44e                	sd	s3,40(sp)
    80000b8a:	f052                	sd	s4,32(sp)
    80000b8c:	ec56                	sd	s5,24(sp)
    80000b8e:	e85a                	sd	s6,16(sp)
    80000b90:	e45e                	sd	s7,8(sp)
    80000b92:	e062                	sd	s8,0(sp)
    80000b94:	0880                	addi	s0,sp,80
    80000b96:	8b2a                	mv	s6,a0
    80000b98:	8a2e                	mv	s4,a1
    80000b9a:	8c32                	mv	s8,a2
    80000b9c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b9e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ba0:	6a85                	lui	s5,0x1
    80000ba2:	a015                	j	80000bc6 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ba4:	9562                	add	a0,a0,s8
    80000ba6:	0004861b          	sext.w	a2,s1
    80000baa:	412505b3          	sub	a1,a0,s2
    80000bae:	8552                	mv	a0,s4
    80000bb0:	fffff097          	auipc	ra,0xfffff
    80000bb4:	628080e7          	jalr	1576(ra) # 800001d8 <memmove>

    len -= n;
    80000bb8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bbc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bbe:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bc2:	02098263          	beqz	s3,80000be6 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000bc6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bca:	85ca                	mv	a1,s2
    80000bcc:	855a                	mv	a0,s6
    80000bce:	00000097          	auipc	ra,0x0
    80000bd2:	938080e7          	jalr	-1736(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bd6:	cd01                	beqz	a0,80000bee <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bd8:	418904b3          	sub	s1,s2,s8
    80000bdc:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bde:	fc99f3e3          	bgeu	s3,s1,80000ba4 <copyin+0x28>
    80000be2:	84ce                	mv	s1,s3
    80000be4:	b7c1                	j	80000ba4 <copyin+0x28>
  }
  return 0;
    80000be6:	4501                	li	a0,0
    80000be8:	a021                	j	80000bf0 <copyin+0x74>
    80000bea:	4501                	li	a0,0
}
    80000bec:	8082                	ret
      return -1;
    80000bee:	557d                	li	a0,-1
}
    80000bf0:	60a6                	ld	ra,72(sp)
    80000bf2:	6406                	ld	s0,64(sp)
    80000bf4:	74e2                	ld	s1,56(sp)
    80000bf6:	7942                	ld	s2,48(sp)
    80000bf8:	79a2                	ld	s3,40(sp)
    80000bfa:	7a02                	ld	s4,32(sp)
    80000bfc:	6ae2                	ld	s5,24(sp)
    80000bfe:	6b42                	ld	s6,16(sp)
    80000c00:	6ba2                	ld	s7,8(sp)
    80000c02:	6c02                	ld	s8,0(sp)
    80000c04:	6161                	addi	sp,sp,80
    80000c06:	8082                	ret

0000000080000c08 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c08:	c6c5                	beqz	a3,80000cb0 <copyinstr+0xa8>
{
    80000c0a:	715d                	addi	sp,sp,-80
    80000c0c:	e486                	sd	ra,72(sp)
    80000c0e:	e0a2                	sd	s0,64(sp)
    80000c10:	fc26                	sd	s1,56(sp)
    80000c12:	f84a                	sd	s2,48(sp)
    80000c14:	f44e                	sd	s3,40(sp)
    80000c16:	f052                	sd	s4,32(sp)
    80000c18:	ec56                	sd	s5,24(sp)
    80000c1a:	e85a                	sd	s6,16(sp)
    80000c1c:	e45e                	sd	s7,8(sp)
    80000c1e:	0880                	addi	s0,sp,80
    80000c20:	8a2a                	mv	s4,a0
    80000c22:	8b2e                	mv	s6,a1
    80000c24:	8bb2                	mv	s7,a2
    80000c26:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c28:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c2a:	6985                	lui	s3,0x1
    80000c2c:	a035                	j	80000c58 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c2e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c32:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c34:	0017b793          	seqz	a5,a5
    80000c38:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c3c:	60a6                	ld	ra,72(sp)
    80000c3e:	6406                	ld	s0,64(sp)
    80000c40:	74e2                	ld	s1,56(sp)
    80000c42:	7942                	ld	s2,48(sp)
    80000c44:	79a2                	ld	s3,40(sp)
    80000c46:	7a02                	ld	s4,32(sp)
    80000c48:	6ae2                	ld	s5,24(sp)
    80000c4a:	6b42                	ld	s6,16(sp)
    80000c4c:	6ba2                	ld	s7,8(sp)
    80000c4e:	6161                	addi	sp,sp,80
    80000c50:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c52:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c56:	c8a9                	beqz	s1,80000ca8 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c58:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c5c:	85ca                	mv	a1,s2
    80000c5e:	8552                	mv	a0,s4
    80000c60:	00000097          	auipc	ra,0x0
    80000c64:	8a6080e7          	jalr	-1882(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c68:	c131                	beqz	a0,80000cac <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c6a:	41790833          	sub	a6,s2,s7
    80000c6e:	984e                	add	a6,a6,s3
    if(n > max)
    80000c70:	0104f363          	bgeu	s1,a6,80000c76 <copyinstr+0x6e>
    80000c74:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c76:	955e                	add	a0,a0,s7
    80000c78:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c7c:	fc080be3          	beqz	a6,80000c52 <copyinstr+0x4a>
    80000c80:	985a                	add	a6,a6,s6
    80000c82:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c84:	41650633          	sub	a2,a0,s6
    80000c88:	14fd                	addi	s1,s1,-1
    80000c8a:	9b26                	add	s6,s6,s1
    80000c8c:	00f60733          	add	a4,a2,a5
    80000c90:	00074703          	lbu	a4,0(a4)
    80000c94:	df49                	beqz	a4,80000c2e <copyinstr+0x26>
        *dst = *p;
    80000c96:	00e78023          	sb	a4,0(a5)
      --max;
    80000c9a:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000c9e:	0785                	addi	a5,a5,1
    while(n > 0){
    80000ca0:	ff0796e3          	bne	a5,a6,80000c8c <copyinstr+0x84>
      dst++;
    80000ca4:	8b42                	mv	s6,a6
    80000ca6:	b775                	j	80000c52 <copyinstr+0x4a>
    80000ca8:	4781                	li	a5,0
    80000caa:	b769                	j	80000c34 <copyinstr+0x2c>
      return -1;
    80000cac:	557d                	li	a0,-1
    80000cae:	b779                	j	80000c3c <copyinstr+0x34>
  int got_null = 0;
    80000cb0:	4781                	li	a5,0
  if(got_null){
    80000cb2:	0017b793          	seqz	a5,a5
    80000cb6:	40f00533          	neg	a0,a5
}
    80000cba:	8082                	ret

0000000080000cbc <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cbc:	7139                	addi	sp,sp,-64
    80000cbe:	fc06                	sd	ra,56(sp)
    80000cc0:	f822                	sd	s0,48(sp)
    80000cc2:	f426                	sd	s1,40(sp)
    80000cc4:	f04a                	sd	s2,32(sp)
    80000cc6:	ec4e                	sd	s3,24(sp)
    80000cc8:	e852                	sd	s4,16(sp)
    80000cca:	e456                	sd	s5,8(sp)
    80000ccc:	e05a                	sd	s6,0(sp)
    80000cce:	0080                	addi	s0,sp,64
    80000cd0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cd2:	00008497          	auipc	s1,0x8
    80000cd6:	7ae48493          	addi	s1,s1,1966 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cda:	8b26                	mv	s6,s1
    80000cdc:	00007a97          	auipc	s5,0x7
    80000ce0:	324a8a93          	addi	s5,s5,804 # 80008000 <etext>
    80000ce4:	04000937          	lui	s2,0x4000
    80000ce8:	197d                	addi	s2,s2,-1
    80000cea:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cec:	00018a17          	auipc	s4,0x18
    80000cf0:	594a0a13          	addi	s4,s4,1428 # 80019280 <tickslock>
    char *pa = kalloc();
    80000cf4:	fffff097          	auipc	ra,0xfffff
    80000cf8:	424080e7          	jalr	1060(ra) # 80000118 <kalloc>
    80000cfc:	862a                	mv	a2,a0
    if(pa == 0)
    80000cfe:	c131                	beqz	a0,80000d42 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d00:	416485b3          	sub	a1,s1,s6
    80000d04:	858d                	srai	a1,a1,0x3
    80000d06:	000ab783          	ld	a5,0(s5)
    80000d0a:	02f585b3          	mul	a1,a1,a5
    80000d0e:	2585                	addiw	a1,a1,1
    80000d10:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d14:	4719                	li	a4,6
    80000d16:	6685                	lui	a3,0x1
    80000d18:	40b905b3          	sub	a1,s2,a1
    80000d1c:	854e                	mv	a0,s3
    80000d1e:	00000097          	auipc	ra,0x0
    80000d22:	8ca080e7          	jalr	-1846(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d26:	3f848493          	addi	s1,s1,1016
    80000d2a:	fd4495e3          	bne	s1,s4,80000cf4 <proc_mapstacks+0x38>
  }
}
    80000d2e:	70e2                	ld	ra,56(sp)
    80000d30:	7442                	ld	s0,48(sp)
    80000d32:	74a2                	ld	s1,40(sp)
    80000d34:	7902                	ld	s2,32(sp)
    80000d36:	69e2                	ld	s3,24(sp)
    80000d38:	6a42                	ld	s4,16(sp)
    80000d3a:	6aa2                	ld	s5,8(sp)
    80000d3c:	6b02                	ld	s6,0(sp)
    80000d3e:	6121                	addi	sp,sp,64
    80000d40:	8082                	ret
      panic("kalloc");
    80000d42:	00007517          	auipc	a0,0x7
    80000d46:	3de50513          	addi	a0,a0,990 # 80008120 <etext+0x120>
    80000d4a:	00005097          	auipc	ra,0x5
    80000d4e:	29e080e7          	jalr	670(ra) # 80005fe8 <panic>

0000000080000d52 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d52:	7139                	addi	sp,sp,-64
    80000d54:	fc06                	sd	ra,56(sp)
    80000d56:	f822                	sd	s0,48(sp)
    80000d58:	f426                	sd	s1,40(sp)
    80000d5a:	f04a                	sd	s2,32(sp)
    80000d5c:	ec4e                	sd	s3,24(sp)
    80000d5e:	e852                	sd	s4,16(sp)
    80000d60:	e456                	sd	s5,8(sp)
    80000d62:	e05a                	sd	s6,0(sp)
    80000d64:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d66:	00007597          	auipc	a1,0x7
    80000d6a:	3c258593          	addi	a1,a1,962 # 80008128 <etext+0x128>
    80000d6e:	00008517          	auipc	a0,0x8
    80000d72:	2e250513          	addi	a0,a0,738 # 80009050 <pid_lock>
    80000d76:	00005097          	auipc	ra,0x5
    80000d7a:	72c080e7          	jalr	1836(ra) # 800064a2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d7e:	00007597          	auipc	a1,0x7
    80000d82:	3b258593          	addi	a1,a1,946 # 80008130 <etext+0x130>
    80000d86:	00008517          	auipc	a0,0x8
    80000d8a:	2e250513          	addi	a0,a0,738 # 80009068 <wait_lock>
    80000d8e:	00005097          	auipc	ra,0x5
    80000d92:	714080e7          	jalr	1812(ra) # 800064a2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d96:	00008497          	auipc	s1,0x8
    80000d9a:	6ea48493          	addi	s1,s1,1770 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000d9e:	00007b17          	auipc	s6,0x7
    80000da2:	3a2b0b13          	addi	s6,s6,930 # 80008140 <etext+0x140>
      p->kstack = KSTACK((int) (p - proc));
    80000da6:	8aa6                	mv	s5,s1
    80000da8:	00007a17          	auipc	s4,0x7
    80000dac:	258a0a13          	addi	s4,s4,600 # 80008000 <etext>
    80000db0:	04000937          	lui	s2,0x4000
    80000db4:	197d                	addi	s2,s2,-1
    80000db6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db8:	00018997          	auipc	s3,0x18
    80000dbc:	4c898993          	addi	s3,s3,1224 # 80019280 <tickslock>
      initlock(&p->lock, "proc");
    80000dc0:	85da                	mv	a1,s6
    80000dc2:	8526                	mv	a0,s1
    80000dc4:	00005097          	auipc	ra,0x5
    80000dc8:	6de080e7          	jalr	1758(ra) # 800064a2 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000dcc:	415487b3          	sub	a5,s1,s5
    80000dd0:	878d                	srai	a5,a5,0x3
    80000dd2:	000a3703          	ld	a4,0(s4)
    80000dd6:	02e787b3          	mul	a5,a5,a4
    80000dda:	2785                	addiw	a5,a5,1
    80000ddc:	00d7979b          	slliw	a5,a5,0xd
    80000de0:	40f907b3          	sub	a5,s2,a5
    80000de4:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000de6:	3f848493          	addi	s1,s1,1016
    80000dea:	fd349be3          	bne	s1,s3,80000dc0 <procinit+0x6e>
  }
}
    80000dee:	70e2                	ld	ra,56(sp)
    80000df0:	7442                	ld	s0,48(sp)
    80000df2:	74a2                	ld	s1,40(sp)
    80000df4:	7902                	ld	s2,32(sp)
    80000df6:	69e2                	ld	s3,24(sp)
    80000df8:	6a42                	ld	s4,16(sp)
    80000dfa:	6aa2                	ld	s5,8(sp)
    80000dfc:	6b02                	ld	s6,0(sp)
    80000dfe:	6121                	addi	sp,sp,64
    80000e00:	8082                	ret

0000000080000e02 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e02:	1141                	addi	sp,sp,-16
    80000e04:	e422                	sd	s0,8(sp)
    80000e06:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e08:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e0a:	2501                	sext.w	a0,a0
    80000e0c:	6422                	ld	s0,8(sp)
    80000e0e:	0141                	addi	sp,sp,16
    80000e10:	8082                	ret

0000000080000e12 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e12:	1141                	addi	sp,sp,-16
    80000e14:	e422                	sd	s0,8(sp)
    80000e16:	0800                	addi	s0,sp,16
    80000e18:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e1a:	2781                	sext.w	a5,a5
    80000e1c:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e1e:	00008517          	auipc	a0,0x8
    80000e22:	26250513          	addi	a0,a0,610 # 80009080 <cpus>
    80000e26:	953e                	add	a0,a0,a5
    80000e28:	6422                	ld	s0,8(sp)
    80000e2a:	0141                	addi	sp,sp,16
    80000e2c:	8082                	ret

0000000080000e2e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e2e:	1101                	addi	sp,sp,-32
    80000e30:	ec06                	sd	ra,24(sp)
    80000e32:	e822                	sd	s0,16(sp)
    80000e34:	e426                	sd	s1,8(sp)
    80000e36:	1000                	addi	s0,sp,32
  push_off();
    80000e38:	00005097          	auipc	ra,0x5
    80000e3c:	6ae080e7          	jalr	1710(ra) # 800064e6 <push_off>
    80000e40:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e42:	2781                	sext.w	a5,a5
    80000e44:	079e                	slli	a5,a5,0x7
    80000e46:	00008717          	auipc	a4,0x8
    80000e4a:	20a70713          	addi	a4,a4,522 # 80009050 <pid_lock>
    80000e4e:	97ba                	add	a5,a5,a4
    80000e50:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e52:	00005097          	auipc	ra,0x5
    80000e56:	734080e7          	jalr	1844(ra) # 80006586 <pop_off>
  return p;
}
    80000e5a:	8526                	mv	a0,s1
    80000e5c:	60e2                	ld	ra,24(sp)
    80000e5e:	6442                	ld	s0,16(sp)
    80000e60:	64a2                	ld	s1,8(sp)
    80000e62:	6105                	addi	sp,sp,32
    80000e64:	8082                	ret

0000000080000e66 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e66:	1141                	addi	sp,sp,-16
    80000e68:	e406                	sd	ra,8(sp)
    80000e6a:	e022                	sd	s0,0(sp)
    80000e6c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e6e:	00000097          	auipc	ra,0x0
    80000e72:	fc0080e7          	jalr	-64(ra) # 80000e2e <myproc>
    80000e76:	00005097          	auipc	ra,0x5
    80000e7a:	770080e7          	jalr	1904(ra) # 800065e6 <release>

  if (first) {
    80000e7e:	00008797          	auipc	a5,0x8
    80000e82:	9727a783          	lw	a5,-1678(a5) # 800087f0 <first.1752>
    80000e86:	eb89                	bnez	a5,80000e98 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e88:	00001097          	auipc	ra,0x1
    80000e8c:	d64080e7          	jalr	-668(ra) # 80001bec <usertrapret>
}
    80000e90:	60a2                	ld	ra,8(sp)
    80000e92:	6402                	ld	s0,0(sp)
    80000e94:	0141                	addi	sp,sp,16
    80000e96:	8082                	ret
    first = 0;
    80000e98:	00008797          	auipc	a5,0x8
    80000e9c:	9407ac23          	sw	zero,-1704(a5) # 800087f0 <first.1752>
    fsinit(ROOTDEV);
    80000ea0:	4505                	li	a0,1
    80000ea2:	00002097          	auipc	ra,0x2
    80000ea6:	e1c080e7          	jalr	-484(ra) # 80002cbe <fsinit>
    80000eaa:	bff9                	j	80000e88 <forkret+0x22>

0000000080000eac <allocpid>:
allocpid() {
    80000eac:	1101                	addi	sp,sp,-32
    80000eae:	ec06                	sd	ra,24(sp)
    80000eb0:	e822                	sd	s0,16(sp)
    80000eb2:	e426                	sd	s1,8(sp)
    80000eb4:	e04a                	sd	s2,0(sp)
    80000eb6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000eb8:	00008917          	auipc	s2,0x8
    80000ebc:	19890913          	addi	s2,s2,408 # 80009050 <pid_lock>
    80000ec0:	854a                	mv	a0,s2
    80000ec2:	00005097          	auipc	ra,0x5
    80000ec6:	670080e7          	jalr	1648(ra) # 80006532 <acquire>
  pid = nextpid;
    80000eca:	00008797          	auipc	a5,0x8
    80000ece:	92a78793          	addi	a5,a5,-1750 # 800087f4 <nextpid>
    80000ed2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ed4:	0014871b          	addiw	a4,s1,1
    80000ed8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000eda:	854a                	mv	a0,s2
    80000edc:	00005097          	auipc	ra,0x5
    80000ee0:	70a080e7          	jalr	1802(ra) # 800065e6 <release>
}
    80000ee4:	8526                	mv	a0,s1
    80000ee6:	60e2                	ld	ra,24(sp)
    80000ee8:	6442                	ld	s0,16(sp)
    80000eea:	64a2                	ld	s1,8(sp)
    80000eec:	6902                	ld	s2,0(sp)
    80000eee:	6105                	addi	sp,sp,32
    80000ef0:	8082                	ret

0000000080000ef2 <proc_pagetable>:
{
    80000ef2:	1101                	addi	sp,sp,-32
    80000ef4:	ec06                	sd	ra,24(sp)
    80000ef6:	e822                	sd	s0,16(sp)
    80000ef8:	e426                	sd	s1,8(sp)
    80000efa:	e04a                	sd	s2,0(sp)
    80000efc:	1000                	addi	s0,sp,32
    80000efe:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f00:	00000097          	auipc	ra,0x0
    80000f04:	8c4080e7          	jalr	-1852(ra) # 800007c4 <uvmcreate>
    80000f08:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f0a:	c121                	beqz	a0,80000f4a <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f0c:	4729                	li	a4,10
    80000f0e:	00006697          	auipc	a3,0x6
    80000f12:	0f268693          	addi	a3,a3,242 # 80007000 <_trampoline>
    80000f16:	6605                	lui	a2,0x1
    80000f18:	040005b7          	lui	a1,0x4000
    80000f1c:	15fd                	addi	a1,a1,-1
    80000f1e:	05b2                	slli	a1,a1,0xc
    80000f20:	fffff097          	auipc	ra,0xfffff
    80000f24:	628080e7          	jalr	1576(ra) # 80000548 <mappages>
    80000f28:	02054863          	bltz	a0,80000f58 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f2c:	4719                	li	a4,6
    80000f2e:	05893683          	ld	a3,88(s2)
    80000f32:	6605                	lui	a2,0x1
    80000f34:	020005b7          	lui	a1,0x2000
    80000f38:	15fd                	addi	a1,a1,-1
    80000f3a:	05b6                	slli	a1,a1,0xd
    80000f3c:	8526                	mv	a0,s1
    80000f3e:	fffff097          	auipc	ra,0xfffff
    80000f42:	60a080e7          	jalr	1546(ra) # 80000548 <mappages>
    80000f46:	02054163          	bltz	a0,80000f68 <proc_pagetable+0x76>
}
    80000f4a:	8526                	mv	a0,s1
    80000f4c:	60e2                	ld	ra,24(sp)
    80000f4e:	6442                	ld	s0,16(sp)
    80000f50:	64a2                	ld	s1,8(sp)
    80000f52:	6902                	ld	s2,0(sp)
    80000f54:	6105                	addi	sp,sp,32
    80000f56:	8082                	ret
    uvmfree(pagetable, 0);
    80000f58:	4581                	li	a1,0
    80000f5a:	8526                	mv	a0,s1
    80000f5c:	00000097          	auipc	ra,0x0
    80000f60:	a64080e7          	jalr	-1436(ra) # 800009c0 <uvmfree>
    return 0;
    80000f64:	4481                	li	s1,0
    80000f66:	b7d5                	j	80000f4a <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f68:	4681                	li	a3,0
    80000f6a:	4605                	li	a2,1
    80000f6c:	040005b7          	lui	a1,0x4000
    80000f70:	15fd                	addi	a1,a1,-1
    80000f72:	05b2                	slli	a1,a1,0xc
    80000f74:	8526                	mv	a0,s1
    80000f76:	fffff097          	auipc	ra,0xfffff
    80000f7a:	798080e7          	jalr	1944(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000f7e:	4581                	li	a1,0
    80000f80:	8526                	mv	a0,s1
    80000f82:	00000097          	auipc	ra,0x0
    80000f86:	a3e080e7          	jalr	-1474(ra) # 800009c0 <uvmfree>
    return 0;
    80000f8a:	4481                	li	s1,0
    80000f8c:	bf7d                	j	80000f4a <proc_pagetable+0x58>

0000000080000f8e <proc_freepagetable>:
{
    80000f8e:	1101                	addi	sp,sp,-32
    80000f90:	ec06                	sd	ra,24(sp)
    80000f92:	e822                	sd	s0,16(sp)
    80000f94:	e426                	sd	s1,8(sp)
    80000f96:	e04a                	sd	s2,0(sp)
    80000f98:	1000                	addi	s0,sp,32
    80000f9a:	84aa                	mv	s1,a0
    80000f9c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f9e:	4681                	li	a3,0
    80000fa0:	4605                	li	a2,1
    80000fa2:	040005b7          	lui	a1,0x4000
    80000fa6:	15fd                	addi	a1,a1,-1
    80000fa8:	05b2                	slli	a1,a1,0xc
    80000faa:	fffff097          	auipc	ra,0xfffff
    80000fae:	764080e7          	jalr	1892(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fb2:	4681                	li	a3,0
    80000fb4:	4605                	li	a2,1
    80000fb6:	020005b7          	lui	a1,0x2000
    80000fba:	15fd                	addi	a1,a1,-1
    80000fbc:	05b6                	slli	a1,a1,0xd
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	fffff097          	auipc	ra,0xfffff
    80000fc4:	74e080e7          	jalr	1870(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80000fc8:	85ca                	mv	a1,s2
    80000fca:	8526                	mv	a0,s1
    80000fcc:	00000097          	auipc	ra,0x0
    80000fd0:	9f4080e7          	jalr	-1548(ra) # 800009c0 <uvmfree>
}
    80000fd4:	60e2                	ld	ra,24(sp)
    80000fd6:	6442                	ld	s0,16(sp)
    80000fd8:	64a2                	ld	s1,8(sp)
    80000fda:	6902                	ld	s2,0(sp)
    80000fdc:	6105                	addi	sp,sp,32
    80000fde:	8082                	ret

0000000080000fe0 <freeproc>:
{
    80000fe0:	1101                	addi	sp,sp,-32
    80000fe2:	ec06                	sd	ra,24(sp)
    80000fe4:	e822                	sd	s0,16(sp)
    80000fe6:	e426                	sd	s1,8(sp)
    80000fe8:	1000                	addi	s0,sp,32
    80000fea:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000fec:	6d28                	ld	a0,88(a0)
    80000fee:	c509                	beqz	a0,80000ff8 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80000ff0:	fffff097          	auipc	ra,0xfffff
    80000ff4:	02c080e7          	jalr	44(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80000ff8:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000ffc:	68a8                	ld	a0,80(s1)
    80000ffe:	c511                	beqz	a0,8000100a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001000:	64ac                	ld	a1,72(s1)
    80001002:	00000097          	auipc	ra,0x0
    80001006:	f8c080e7          	jalr	-116(ra) # 80000f8e <proc_freepagetable>
  p->pagetable = 0;
    8000100a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000100e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001012:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001016:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000101a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000101e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001022:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001026:	0204a623          	sw	zero,44(s1)
  for(int i = 0; i < p->vma_size ; i++){
    8000102a:	3f04c703          	lbu	a4,1008(s1)
    8000102e:	cf15                	beqz	a4,8000106a <freeproc+0x8a>
    80001030:	16848793          	addi	a5,s1,360
    80001034:	377d                	addiw	a4,a4,-1
    80001036:	02071693          	slli	a3,a4,0x20
    8000103a:	9281                	srli	a3,a3,0x20
    8000103c:	00269713          	slli	a4,a3,0x2
    80001040:	9736                	add	a4,a4,a3
    80001042:	070e                	slli	a4,a4,0x3
    80001044:	19048693          	addi	a3,s1,400
    80001048:	9736                	add	a4,a4,a3
      p->vma[i].addr = 0;
    8000104a:	0007b023          	sd	zero,0(a5)
      p->vma[i].sz = 0;
    8000104e:	0007b423          	sd	zero,8(a5)
      p->vma[i].prot = 0;
    80001052:	00078823          	sb	zero,16(a5)
      p->vma[i].file = 0;
    80001056:	0007bc23          	sd	zero,24(a5)
      p->vma[i].flags = 0;
    8000105a:	000788a3          	sb	zero,17(a5)
      p->vma[i].offset = 0;
    8000105e:	0207a023          	sw	zero,32(a5)
  for(int i = 0; i < p->vma_size ; i++){
    80001062:	02878793          	addi	a5,a5,40
    80001066:	fee792e3          	bne	a5,a4,8000104a <freeproc+0x6a>
  p->mmap_addr = 0;
    8000106a:	3e04b423          	sd	zero,1000(s1)
  p->vma_size = 0;
    8000106e:	3e048823          	sb	zero,1008(s1)
  p->state = UNUSED;
    80001072:	0004ac23          	sw	zero,24(s1)
}
    80001076:	60e2                	ld	ra,24(sp)
    80001078:	6442                	ld	s0,16(sp)
    8000107a:	64a2                	ld	s1,8(sp)
    8000107c:	6105                	addi	sp,sp,32
    8000107e:	8082                	ret

0000000080001080 <allocproc>:
{
    80001080:	1101                	addi	sp,sp,-32
    80001082:	ec06                	sd	ra,24(sp)
    80001084:	e822                	sd	s0,16(sp)
    80001086:	e426                	sd	s1,8(sp)
    80001088:	e04a                	sd	s2,0(sp)
    8000108a:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000108c:	00008497          	auipc	s1,0x8
    80001090:	3f448493          	addi	s1,s1,1012 # 80009480 <proc>
    80001094:	00018917          	auipc	s2,0x18
    80001098:	1ec90913          	addi	s2,s2,492 # 80019280 <tickslock>
    acquire(&p->lock);
    8000109c:	8526                	mv	a0,s1
    8000109e:	00005097          	auipc	ra,0x5
    800010a2:	494080e7          	jalr	1172(ra) # 80006532 <acquire>
    if(p->state == UNUSED) {
    800010a6:	4c9c                	lw	a5,24(s1)
    800010a8:	cf81                	beqz	a5,800010c0 <allocproc+0x40>
      release(&p->lock);
    800010aa:	8526                	mv	a0,s1
    800010ac:	00005097          	auipc	ra,0x5
    800010b0:	53a080e7          	jalr	1338(ra) # 800065e6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010b4:	3f848493          	addi	s1,s1,1016
    800010b8:	ff2492e3          	bne	s1,s2,8000109c <allocproc+0x1c>
  return 0;
    800010bc:	4481                	li	s1,0
    800010be:	a8b9                	j	8000111c <allocproc+0x9c>
  p->pid = allocpid();
    800010c0:	00000097          	auipc	ra,0x0
    800010c4:	dec080e7          	jalr	-532(ra) # 80000eac <allocpid>
    800010c8:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010ca:	4785                	li	a5,1
    800010cc:	cc9c                	sw	a5,24(s1)
  p->mmap_addr = TRAPFRAME;
    800010ce:	020007b7          	lui	a5,0x2000
    800010d2:	17fd                	addi	a5,a5,-1
    800010d4:	07b6                	slli	a5,a5,0xd
    800010d6:	3ef4b423          	sd	a5,1000(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010da:	fffff097          	auipc	ra,0xfffff
    800010de:	03e080e7          	jalr	62(ra) # 80000118 <kalloc>
    800010e2:	892a                	mv	s2,a0
    800010e4:	eca8                	sd	a0,88(s1)
    800010e6:	c131                	beqz	a0,8000112a <allocproc+0xaa>
  p->pagetable = proc_pagetable(p);
    800010e8:	8526                	mv	a0,s1
    800010ea:	00000097          	auipc	ra,0x0
    800010ee:	e08080e7          	jalr	-504(ra) # 80000ef2 <proc_pagetable>
    800010f2:	892a                	mv	s2,a0
    800010f4:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010f6:	c531                	beqz	a0,80001142 <allocproc+0xc2>
  memset(&p->context, 0, sizeof(p->context));
    800010f8:	07000613          	li	a2,112
    800010fc:	4581                	li	a1,0
    800010fe:	06048513          	addi	a0,s1,96
    80001102:	fffff097          	auipc	ra,0xfffff
    80001106:	076080e7          	jalr	118(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    8000110a:	00000797          	auipc	a5,0x0
    8000110e:	d5c78793          	addi	a5,a5,-676 # 80000e66 <forkret>
    80001112:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001114:	60bc                	ld	a5,64(s1)
    80001116:	6705                	lui	a4,0x1
    80001118:	97ba                	add	a5,a5,a4
    8000111a:	f4bc                	sd	a5,104(s1)
}
    8000111c:	8526                	mv	a0,s1
    8000111e:	60e2                	ld	ra,24(sp)
    80001120:	6442                	ld	s0,16(sp)
    80001122:	64a2                	ld	s1,8(sp)
    80001124:	6902                	ld	s2,0(sp)
    80001126:	6105                	addi	sp,sp,32
    80001128:	8082                	ret
    freeproc(p);
    8000112a:	8526                	mv	a0,s1
    8000112c:	00000097          	auipc	ra,0x0
    80001130:	eb4080e7          	jalr	-332(ra) # 80000fe0 <freeproc>
    release(&p->lock);
    80001134:	8526                	mv	a0,s1
    80001136:	00005097          	auipc	ra,0x5
    8000113a:	4b0080e7          	jalr	1200(ra) # 800065e6 <release>
    return 0;
    8000113e:	84ca                	mv	s1,s2
    80001140:	bff1                	j	8000111c <allocproc+0x9c>
    freeproc(p);
    80001142:	8526                	mv	a0,s1
    80001144:	00000097          	auipc	ra,0x0
    80001148:	e9c080e7          	jalr	-356(ra) # 80000fe0 <freeproc>
    release(&p->lock);
    8000114c:	8526                	mv	a0,s1
    8000114e:	00005097          	auipc	ra,0x5
    80001152:	498080e7          	jalr	1176(ra) # 800065e6 <release>
    return 0;
    80001156:	84ca                	mv	s1,s2
    80001158:	b7d1                	j	8000111c <allocproc+0x9c>

000000008000115a <userinit>:
{
    8000115a:	1101                	addi	sp,sp,-32
    8000115c:	ec06                	sd	ra,24(sp)
    8000115e:	e822                	sd	s0,16(sp)
    80001160:	e426                	sd	s1,8(sp)
    80001162:	1000                	addi	s0,sp,32
  p = allocproc();
    80001164:	00000097          	auipc	ra,0x0
    80001168:	f1c080e7          	jalr	-228(ra) # 80001080 <allocproc>
    8000116c:	84aa                	mv	s1,a0
  initproc = p;
    8000116e:	00008797          	auipc	a5,0x8
    80001172:	eaa7b123          	sd	a0,-350(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001176:	03400613          	li	a2,52
    8000117a:	00007597          	auipc	a1,0x7
    8000117e:	68658593          	addi	a1,a1,1670 # 80008800 <initcode>
    80001182:	6928                	ld	a0,80(a0)
    80001184:	fffff097          	auipc	ra,0xfffff
    80001188:	66e080e7          	jalr	1646(ra) # 800007f2 <uvminit>
  p->sz = PGSIZE;
    8000118c:	6785                	lui	a5,0x1
    8000118e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001190:	6cb8                	ld	a4,88(s1)
    80001192:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001196:	6cb8                	ld	a4,88(s1)
    80001198:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000119a:	4641                	li	a2,16
    8000119c:	00007597          	auipc	a1,0x7
    800011a0:	fac58593          	addi	a1,a1,-84 # 80008148 <etext+0x148>
    800011a4:	15848513          	addi	a0,s1,344
    800011a8:	fffff097          	auipc	ra,0xfffff
    800011ac:	122080e7          	jalr	290(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    800011b0:	00007517          	auipc	a0,0x7
    800011b4:	fa850513          	addi	a0,a0,-88 # 80008158 <etext+0x158>
    800011b8:	00002097          	auipc	ra,0x2
    800011bc:	534080e7          	jalr	1332(ra) # 800036ec <namei>
    800011c0:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011c4:	478d                	li	a5,3
    800011c6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011c8:	8526                	mv	a0,s1
    800011ca:	00005097          	auipc	ra,0x5
    800011ce:	41c080e7          	jalr	1052(ra) # 800065e6 <release>
}
    800011d2:	60e2                	ld	ra,24(sp)
    800011d4:	6442                	ld	s0,16(sp)
    800011d6:	64a2                	ld	s1,8(sp)
    800011d8:	6105                	addi	sp,sp,32
    800011da:	8082                	ret

00000000800011dc <growproc>:
{
    800011dc:	1101                	addi	sp,sp,-32
    800011de:	ec06                	sd	ra,24(sp)
    800011e0:	e822                	sd	s0,16(sp)
    800011e2:	e426                	sd	s1,8(sp)
    800011e4:	e04a                	sd	s2,0(sp)
    800011e6:	1000                	addi	s0,sp,32
    800011e8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011ea:	00000097          	auipc	ra,0x0
    800011ee:	c44080e7          	jalr	-956(ra) # 80000e2e <myproc>
    800011f2:	892a                	mv	s2,a0
  sz = p->sz;
    800011f4:	652c                	ld	a1,72(a0)
    800011f6:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011fa:	00904f63          	bgtz	s1,80001218 <growproc+0x3c>
  } else if(n < 0){
    800011fe:	0204cc63          	bltz	s1,80001236 <growproc+0x5a>
  p->sz = sz;
    80001202:	1602                	slli	a2,a2,0x20
    80001204:	9201                	srli	a2,a2,0x20
    80001206:	04c93423          	sd	a2,72(s2)
  return 0;
    8000120a:	4501                	li	a0,0
}
    8000120c:	60e2                	ld	ra,24(sp)
    8000120e:	6442                	ld	s0,16(sp)
    80001210:	64a2                	ld	s1,8(sp)
    80001212:	6902                	ld	s2,0(sp)
    80001214:	6105                	addi	sp,sp,32
    80001216:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001218:	9e25                	addw	a2,a2,s1
    8000121a:	1602                	slli	a2,a2,0x20
    8000121c:	9201                	srli	a2,a2,0x20
    8000121e:	1582                	slli	a1,a1,0x20
    80001220:	9181                	srli	a1,a1,0x20
    80001222:	6928                	ld	a0,80(a0)
    80001224:	fffff097          	auipc	ra,0xfffff
    80001228:	688080e7          	jalr	1672(ra) # 800008ac <uvmalloc>
    8000122c:	0005061b          	sext.w	a2,a0
    80001230:	fa69                	bnez	a2,80001202 <growproc+0x26>
      return -1;
    80001232:	557d                	li	a0,-1
    80001234:	bfe1                	j	8000120c <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001236:	9e25                	addw	a2,a2,s1
    80001238:	1602                	slli	a2,a2,0x20
    8000123a:	9201                	srli	a2,a2,0x20
    8000123c:	1582                	slli	a1,a1,0x20
    8000123e:	9181                	srli	a1,a1,0x20
    80001240:	6928                	ld	a0,80(a0)
    80001242:	fffff097          	auipc	ra,0xfffff
    80001246:	622080e7          	jalr	1570(ra) # 80000864 <uvmdealloc>
    8000124a:	0005061b          	sext.w	a2,a0
    8000124e:	bf55                	j	80001202 <growproc+0x26>

0000000080001250 <fork>:
{
    80001250:	7139                	addi	sp,sp,-64
    80001252:	fc06                	sd	ra,56(sp)
    80001254:	f822                	sd	s0,48(sp)
    80001256:	f426                	sd	s1,40(sp)
    80001258:	f04a                	sd	s2,32(sp)
    8000125a:	ec4e                	sd	s3,24(sp)
    8000125c:	e852                	sd	s4,16(sp)
    8000125e:	e456                	sd	s5,8(sp)
    80001260:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80001262:	00000097          	auipc	ra,0x0
    80001266:	bcc080e7          	jalr	-1076(ra) # 80000e2e <myproc>
    8000126a:	89aa                	mv	s3,a0
    if((np = allocproc()) == 0){
    8000126c:	00000097          	auipc	ra,0x0
    80001270:	e14080e7          	jalr	-492(ra) # 80001080 <allocproc>
    80001274:	18050263          	beqz	a0,800013f8 <fork+0x1a8>
    80001278:	8a2a                	mv	s4,a0
    if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000127a:	0489b603          	ld	a2,72(s3)
    8000127e:	692c                	ld	a1,80(a0)
    80001280:	0509b503          	ld	a0,80(s3)
    80001284:	fffff097          	auipc	ra,0xfffff
    80001288:	774080e7          	jalr	1908(ra) # 800009f8 <uvmcopy>
    8000128c:	02054763          	bltz	a0,800012ba <fork+0x6a>
    np->sz = p->sz;
    80001290:	0489b783          	ld	a5,72(s3)
    80001294:	04fa3423          	sd	a5,72(s4)
    np->mmap_addr = p->mmap_addr;
    80001298:	3e89b783          	ld	a5,1000(s3)
    8000129c:	3efa3423          	sd	a5,1000(s4)
    np->vma_size = p->vma_size;
    800012a0:	3f09c783          	lbu	a5,1008(s3)
    800012a4:	3efa0823          	sb	a5,1008(s4)
    for(int i = 0; i < p->vma_size; i++){
    800012a8:	3f09c783          	lbu	a5,1008(s3)
    800012ac:	cba5                	beqz	a5,8000131c <fork+0xcc>
    800012ae:	16898493          	addi	s1,s3,360
    800012b2:	168a0913          	addi	s2,s4,360
    800012b6:	4a81                	li	s5,0
    800012b8:	a81d                	j	800012ee <fork+0x9e>
        freeproc(np);
    800012ba:	8552                	mv	a0,s4
    800012bc:	00000097          	auipc	ra,0x0
    800012c0:	d24080e7          	jalr	-732(ra) # 80000fe0 <freeproc>
        release(&np->lock);
    800012c4:	8552                	mv	a0,s4
    800012c6:	00005097          	auipc	ra,0x5
    800012ca:	320080e7          	jalr	800(ra) # 800065e6 <release>
        return -1;
    800012ce:	597d                	li	s2,-1
    800012d0:	aa11                	j	800013e4 <fork+0x194>
            filedup(p->vma[i].file);
    800012d2:	6c88                	ld	a0,24(s1)
    800012d4:	00003097          	auipc	ra,0x3
    800012d8:	aae080e7          	jalr	-1362(ra) # 80003d82 <filedup>
    for(int i = 0; i < p->vma_size; i++){
    800012dc:	2a85                	addiw	s5,s5,1
    800012de:	02848493          	addi	s1,s1,40
    800012e2:	02890913          	addi	s2,s2,40
    800012e6:	3f09c783          	lbu	a5,1008(s3)
    800012ea:	02fad963          	bge	s5,a5,8000131c <fork+0xcc>
        np->vma[i].addr = p->vma[i].addr;
    800012ee:	609c                	ld	a5,0(s1)
    800012f0:	00f93023          	sd	a5,0(s2)
        np->vma[i].sz = p->vma[i].sz;
    800012f4:	649c                	ld	a5,8(s1)
    800012f6:	00f93423          	sd	a5,8(s2)
        np->vma[i].prot = p->vma[i].prot;
    800012fa:	0104c783          	lbu	a5,16(s1)
    800012fe:	00f90823          	sb	a5,16(s2)
        np->vma[i].flags = p->vma[i].flags;
    80001302:	0114c783          	lbu	a5,17(s1)
    80001306:	00f908a3          	sb	a5,17(s2)
        np->vma[i].file = p->vma[i].file;
    8000130a:	6c9c                	ld	a5,24(s1)
    8000130c:	00f93c23          	sd	a5,24(s2)
        np->vma[i].offset = p->vma[i].offset;
    80001310:	509c                	lw	a5,32(s1)
    80001312:	02f92023          	sw	a5,32(s2)
        if(p->vma[i].sz > 0)
    80001316:	649c                	ld	a5,8(s1)
    80001318:	d3f1                	beqz	a5,800012dc <fork+0x8c>
    8000131a:	bf65                	j	800012d2 <fork+0x82>
    *(np->trapframe) = *(p->trapframe);
    8000131c:	0589b683          	ld	a3,88(s3)
    80001320:	87b6                	mv	a5,a3
    80001322:	058a3703          	ld	a4,88(s4)
    80001326:	12068693          	addi	a3,a3,288
    8000132a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000132e:	6788                	ld	a0,8(a5)
    80001330:	6b8c                	ld	a1,16(a5)
    80001332:	6f90                	ld	a2,24(a5)
    80001334:	01073023          	sd	a6,0(a4)
    80001338:	e708                	sd	a0,8(a4)
    8000133a:	eb0c                	sd	a1,16(a4)
    8000133c:	ef10                	sd	a2,24(a4)
    8000133e:	02078793          	addi	a5,a5,32
    80001342:	02070713          	addi	a4,a4,32
    80001346:	fed792e3          	bne	a5,a3,8000132a <fork+0xda>
    np->trapframe->a0 = 0;
    8000134a:	058a3783          	ld	a5,88(s4)
    8000134e:	0607b823          	sd	zero,112(a5)
    80001352:	0d000493          	li	s1,208
    for(i = 0; i < NOFILE; i++)
    80001356:	15000913          	li	s2,336
    8000135a:	a819                	j	80001370 <fork+0x120>
            np->ofile[i] = filedup(p->ofile[i]);
    8000135c:	00003097          	auipc	ra,0x3
    80001360:	a26080e7          	jalr	-1498(ra) # 80003d82 <filedup>
    80001364:	009a07b3          	add	a5,s4,s1
    80001368:	e388                	sd	a0,0(a5)
    for(i = 0; i < NOFILE; i++)
    8000136a:	04a1                	addi	s1,s1,8
    8000136c:	01248763          	beq	s1,s2,8000137a <fork+0x12a>
        if(p->ofile[i])
    80001370:	009987b3          	add	a5,s3,s1
    80001374:	6388                	ld	a0,0(a5)
    80001376:	f17d                	bnez	a0,8000135c <fork+0x10c>
    80001378:	bfcd                	j	8000136a <fork+0x11a>
    np->cwd = idup(p->cwd);
    8000137a:	1509b503          	ld	a0,336(s3)
    8000137e:	00002097          	auipc	ra,0x2
    80001382:	b7a080e7          	jalr	-1158(ra) # 80002ef8 <idup>
    80001386:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    8000138a:	4641                	li	a2,16
    8000138c:	15898593          	addi	a1,s3,344
    80001390:	158a0513          	addi	a0,s4,344
    80001394:	fffff097          	auipc	ra,0xfffff
    80001398:	f36080e7          	jalr	-202(ra) # 800002ca <safestrcpy>
    pid = np->pid;
    8000139c:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    800013a0:	8552                	mv	a0,s4
    800013a2:	00005097          	auipc	ra,0x5
    800013a6:	244080e7          	jalr	580(ra) # 800065e6 <release>
    acquire(&wait_lock);
    800013aa:	00008497          	auipc	s1,0x8
    800013ae:	cbe48493          	addi	s1,s1,-834 # 80009068 <wait_lock>
    800013b2:	8526                	mv	a0,s1
    800013b4:	00005097          	auipc	ra,0x5
    800013b8:	17e080e7          	jalr	382(ra) # 80006532 <acquire>
    np->parent = p;
    800013bc:	033a3c23          	sd	s3,56(s4)
    release(&wait_lock);
    800013c0:	8526                	mv	a0,s1
    800013c2:	00005097          	auipc	ra,0x5
    800013c6:	224080e7          	jalr	548(ra) # 800065e6 <release>
    acquire(&np->lock);
    800013ca:	8552                	mv	a0,s4
    800013cc:	00005097          	auipc	ra,0x5
    800013d0:	166080e7          	jalr	358(ra) # 80006532 <acquire>
    np->state = RUNNABLE;
    800013d4:	478d                	li	a5,3
    800013d6:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    800013da:	8552                	mv	a0,s4
    800013dc:	00005097          	auipc	ra,0x5
    800013e0:	20a080e7          	jalr	522(ra) # 800065e6 <release>
}
    800013e4:	854a                	mv	a0,s2
    800013e6:	70e2                	ld	ra,56(sp)
    800013e8:	7442                	ld	s0,48(sp)
    800013ea:	74a2                	ld	s1,40(sp)
    800013ec:	7902                	ld	s2,32(sp)
    800013ee:	69e2                	ld	s3,24(sp)
    800013f0:	6a42                	ld	s4,16(sp)
    800013f2:	6aa2                	ld	s5,8(sp)
    800013f4:	6121                	addi	sp,sp,64
    800013f6:	8082                	ret
        return -1;
    800013f8:	597d                	li	s2,-1
    800013fa:	b7ed                	j	800013e4 <fork+0x194>

00000000800013fc <scheduler>:
{
    800013fc:	7139                	addi	sp,sp,-64
    800013fe:	fc06                	sd	ra,56(sp)
    80001400:	f822                	sd	s0,48(sp)
    80001402:	f426                	sd	s1,40(sp)
    80001404:	f04a                	sd	s2,32(sp)
    80001406:	ec4e                	sd	s3,24(sp)
    80001408:	e852                	sd	s4,16(sp)
    8000140a:	e456                	sd	s5,8(sp)
    8000140c:	e05a                	sd	s6,0(sp)
    8000140e:	0080                	addi	s0,sp,64
    80001410:	8792                	mv	a5,tp
  int id = r_tp();
    80001412:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001414:	00779a93          	slli	s5,a5,0x7
    80001418:	00008717          	auipc	a4,0x8
    8000141c:	c3870713          	addi	a4,a4,-968 # 80009050 <pid_lock>
    80001420:	9756                	add	a4,a4,s5
    80001422:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001426:	00008717          	auipc	a4,0x8
    8000142a:	c6270713          	addi	a4,a4,-926 # 80009088 <cpus+0x8>
    8000142e:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001430:	498d                	li	s3,3
        p->state = RUNNING;
    80001432:	4b11                	li	s6,4
        c->proc = p;
    80001434:	079e                	slli	a5,a5,0x7
    80001436:	00008a17          	auipc	s4,0x8
    8000143a:	c1aa0a13          	addi	s4,s4,-998 # 80009050 <pid_lock>
    8000143e:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001440:	00018917          	auipc	s2,0x18
    80001444:	e4090913          	addi	s2,s2,-448 # 80019280 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001448:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000144c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001450:	10079073          	csrw	sstatus,a5
    80001454:	00008497          	auipc	s1,0x8
    80001458:	02c48493          	addi	s1,s1,44 # 80009480 <proc>
    8000145c:	a03d                	j	8000148a <scheduler+0x8e>
        p->state = RUNNING;
    8000145e:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001462:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001466:	06048593          	addi	a1,s1,96
    8000146a:	8556                	mv	a0,s5
    8000146c:	00000097          	auipc	ra,0x0
    80001470:	6d6080e7          	jalr	1750(ra) # 80001b42 <swtch>
        c->proc = 0;
    80001474:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001478:	8526                	mv	a0,s1
    8000147a:	00005097          	auipc	ra,0x5
    8000147e:	16c080e7          	jalr	364(ra) # 800065e6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001482:	3f848493          	addi	s1,s1,1016
    80001486:	fd2481e3          	beq	s1,s2,80001448 <scheduler+0x4c>
      acquire(&p->lock);
    8000148a:	8526                	mv	a0,s1
    8000148c:	00005097          	auipc	ra,0x5
    80001490:	0a6080e7          	jalr	166(ra) # 80006532 <acquire>
      if(p->state == RUNNABLE) {
    80001494:	4c9c                	lw	a5,24(s1)
    80001496:	ff3791e3          	bne	a5,s3,80001478 <scheduler+0x7c>
    8000149a:	b7d1                	j	8000145e <scheduler+0x62>

000000008000149c <sched>:
{
    8000149c:	7179                	addi	sp,sp,-48
    8000149e:	f406                	sd	ra,40(sp)
    800014a0:	f022                	sd	s0,32(sp)
    800014a2:	ec26                	sd	s1,24(sp)
    800014a4:	e84a                	sd	s2,16(sp)
    800014a6:	e44e                	sd	s3,8(sp)
    800014a8:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800014aa:	00000097          	auipc	ra,0x0
    800014ae:	984080e7          	jalr	-1660(ra) # 80000e2e <myproc>
    800014b2:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800014b4:	00005097          	auipc	ra,0x5
    800014b8:	004080e7          	jalr	4(ra) # 800064b8 <holding>
    800014bc:	c93d                	beqz	a0,80001532 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014be:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800014c0:	2781                	sext.w	a5,a5
    800014c2:	079e                	slli	a5,a5,0x7
    800014c4:	00008717          	auipc	a4,0x8
    800014c8:	b8c70713          	addi	a4,a4,-1140 # 80009050 <pid_lock>
    800014cc:	97ba                	add	a5,a5,a4
    800014ce:	0a87a703          	lw	a4,168(a5)
    800014d2:	4785                	li	a5,1
    800014d4:	06f71763          	bne	a4,a5,80001542 <sched+0xa6>
  if(p->state == RUNNING)
    800014d8:	4c98                	lw	a4,24(s1)
    800014da:	4791                	li	a5,4
    800014dc:	06f70b63          	beq	a4,a5,80001552 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014e0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014e4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014e6:	efb5                	bnez	a5,80001562 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014e8:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014ea:	00008917          	auipc	s2,0x8
    800014ee:	b6690913          	addi	s2,s2,-1178 # 80009050 <pid_lock>
    800014f2:	2781                	sext.w	a5,a5
    800014f4:	079e                	slli	a5,a5,0x7
    800014f6:	97ca                	add	a5,a5,s2
    800014f8:	0ac7a983          	lw	s3,172(a5)
    800014fc:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014fe:	2781                	sext.w	a5,a5
    80001500:	079e                	slli	a5,a5,0x7
    80001502:	00008597          	auipc	a1,0x8
    80001506:	b8658593          	addi	a1,a1,-1146 # 80009088 <cpus+0x8>
    8000150a:	95be                	add	a1,a1,a5
    8000150c:	06048513          	addi	a0,s1,96
    80001510:	00000097          	auipc	ra,0x0
    80001514:	632080e7          	jalr	1586(ra) # 80001b42 <swtch>
    80001518:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000151a:	2781                	sext.w	a5,a5
    8000151c:	079e                	slli	a5,a5,0x7
    8000151e:	97ca                	add	a5,a5,s2
    80001520:	0b37a623          	sw	s3,172(a5)
}
    80001524:	70a2                	ld	ra,40(sp)
    80001526:	7402                	ld	s0,32(sp)
    80001528:	64e2                	ld	s1,24(sp)
    8000152a:	6942                	ld	s2,16(sp)
    8000152c:	69a2                	ld	s3,8(sp)
    8000152e:	6145                	addi	sp,sp,48
    80001530:	8082                	ret
    panic("sched p->lock");
    80001532:	00007517          	auipc	a0,0x7
    80001536:	c2e50513          	addi	a0,a0,-978 # 80008160 <etext+0x160>
    8000153a:	00005097          	auipc	ra,0x5
    8000153e:	aae080e7          	jalr	-1362(ra) # 80005fe8 <panic>
    panic("sched locks");
    80001542:	00007517          	auipc	a0,0x7
    80001546:	c2e50513          	addi	a0,a0,-978 # 80008170 <etext+0x170>
    8000154a:	00005097          	auipc	ra,0x5
    8000154e:	a9e080e7          	jalr	-1378(ra) # 80005fe8 <panic>
    panic("sched running");
    80001552:	00007517          	auipc	a0,0x7
    80001556:	c2e50513          	addi	a0,a0,-978 # 80008180 <etext+0x180>
    8000155a:	00005097          	auipc	ra,0x5
    8000155e:	a8e080e7          	jalr	-1394(ra) # 80005fe8 <panic>
    panic("sched interruptible");
    80001562:	00007517          	auipc	a0,0x7
    80001566:	c2e50513          	addi	a0,a0,-978 # 80008190 <etext+0x190>
    8000156a:	00005097          	auipc	ra,0x5
    8000156e:	a7e080e7          	jalr	-1410(ra) # 80005fe8 <panic>

0000000080001572 <yield>:
{
    80001572:	1101                	addi	sp,sp,-32
    80001574:	ec06                	sd	ra,24(sp)
    80001576:	e822                	sd	s0,16(sp)
    80001578:	e426                	sd	s1,8(sp)
    8000157a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000157c:	00000097          	auipc	ra,0x0
    80001580:	8b2080e7          	jalr	-1870(ra) # 80000e2e <myproc>
    80001584:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001586:	00005097          	auipc	ra,0x5
    8000158a:	fac080e7          	jalr	-84(ra) # 80006532 <acquire>
  p->state = RUNNABLE;
    8000158e:	478d                	li	a5,3
    80001590:	cc9c                	sw	a5,24(s1)
  sched();
    80001592:	00000097          	auipc	ra,0x0
    80001596:	f0a080e7          	jalr	-246(ra) # 8000149c <sched>
  release(&p->lock);
    8000159a:	8526                	mv	a0,s1
    8000159c:	00005097          	auipc	ra,0x5
    800015a0:	04a080e7          	jalr	74(ra) # 800065e6 <release>
}
    800015a4:	60e2                	ld	ra,24(sp)
    800015a6:	6442                	ld	s0,16(sp)
    800015a8:	64a2                	ld	s1,8(sp)
    800015aa:	6105                	addi	sp,sp,32
    800015ac:	8082                	ret

00000000800015ae <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800015ae:	7179                	addi	sp,sp,-48
    800015b0:	f406                	sd	ra,40(sp)
    800015b2:	f022                	sd	s0,32(sp)
    800015b4:	ec26                	sd	s1,24(sp)
    800015b6:	e84a                	sd	s2,16(sp)
    800015b8:	e44e                	sd	s3,8(sp)
    800015ba:	1800                	addi	s0,sp,48
    800015bc:	89aa                	mv	s3,a0
    800015be:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015c0:	00000097          	auipc	ra,0x0
    800015c4:	86e080e7          	jalr	-1938(ra) # 80000e2e <myproc>
    800015c8:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015ca:	00005097          	auipc	ra,0x5
    800015ce:	f68080e7          	jalr	-152(ra) # 80006532 <acquire>
  release(lk);
    800015d2:	854a                	mv	a0,s2
    800015d4:	00005097          	auipc	ra,0x5
    800015d8:	012080e7          	jalr	18(ra) # 800065e6 <release>

  // Go to sleep.
  p->chan = chan;
    800015dc:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015e0:	4789                	li	a5,2
    800015e2:	cc9c                	sw	a5,24(s1)

  sched();
    800015e4:	00000097          	auipc	ra,0x0
    800015e8:	eb8080e7          	jalr	-328(ra) # 8000149c <sched>

  // Tidy up.
  p->chan = 0;
    800015ec:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015f0:	8526                	mv	a0,s1
    800015f2:	00005097          	auipc	ra,0x5
    800015f6:	ff4080e7          	jalr	-12(ra) # 800065e6 <release>
  acquire(lk);
    800015fa:	854a                	mv	a0,s2
    800015fc:	00005097          	auipc	ra,0x5
    80001600:	f36080e7          	jalr	-202(ra) # 80006532 <acquire>
}
    80001604:	70a2                	ld	ra,40(sp)
    80001606:	7402                	ld	s0,32(sp)
    80001608:	64e2                	ld	s1,24(sp)
    8000160a:	6942                	ld	s2,16(sp)
    8000160c:	69a2                	ld	s3,8(sp)
    8000160e:	6145                	addi	sp,sp,48
    80001610:	8082                	ret

0000000080001612 <wait>:
{
    80001612:	715d                	addi	sp,sp,-80
    80001614:	e486                	sd	ra,72(sp)
    80001616:	e0a2                	sd	s0,64(sp)
    80001618:	fc26                	sd	s1,56(sp)
    8000161a:	f84a                	sd	s2,48(sp)
    8000161c:	f44e                	sd	s3,40(sp)
    8000161e:	f052                	sd	s4,32(sp)
    80001620:	ec56                	sd	s5,24(sp)
    80001622:	e85a                	sd	s6,16(sp)
    80001624:	e45e                	sd	s7,8(sp)
    80001626:	e062                	sd	s8,0(sp)
    80001628:	0880                	addi	s0,sp,80
    8000162a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000162c:	00000097          	auipc	ra,0x0
    80001630:	802080e7          	jalr	-2046(ra) # 80000e2e <myproc>
    80001634:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001636:	00008517          	auipc	a0,0x8
    8000163a:	a3250513          	addi	a0,a0,-1486 # 80009068 <wait_lock>
    8000163e:	00005097          	auipc	ra,0x5
    80001642:	ef4080e7          	jalr	-268(ra) # 80006532 <acquire>
    havekids = 0;
    80001646:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001648:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    8000164a:	00018997          	auipc	s3,0x18
    8000164e:	c3698993          	addi	s3,s3,-970 # 80019280 <tickslock>
        havekids = 1;
    80001652:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001654:	00008c17          	auipc	s8,0x8
    80001658:	a14c0c13          	addi	s8,s8,-1516 # 80009068 <wait_lock>
    havekids = 0;
    8000165c:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000165e:	00008497          	auipc	s1,0x8
    80001662:	e2248493          	addi	s1,s1,-478 # 80009480 <proc>
    80001666:	a0bd                	j	800016d4 <wait+0xc2>
          pid = np->pid;
    80001668:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000166c:	000b0e63          	beqz	s6,80001688 <wait+0x76>
    80001670:	4691                	li	a3,4
    80001672:	02c48613          	addi	a2,s1,44
    80001676:	85da                	mv	a1,s6
    80001678:	05093503          	ld	a0,80(s2)
    8000167c:	fffff097          	auipc	ra,0xfffff
    80001680:	474080e7          	jalr	1140(ra) # 80000af0 <copyout>
    80001684:	02054563          	bltz	a0,800016ae <wait+0x9c>
          freeproc(np);
    80001688:	8526                	mv	a0,s1
    8000168a:	00000097          	auipc	ra,0x0
    8000168e:	956080e7          	jalr	-1706(ra) # 80000fe0 <freeproc>
          release(&np->lock);
    80001692:	8526                	mv	a0,s1
    80001694:	00005097          	auipc	ra,0x5
    80001698:	f52080e7          	jalr	-174(ra) # 800065e6 <release>
          release(&wait_lock);
    8000169c:	00008517          	auipc	a0,0x8
    800016a0:	9cc50513          	addi	a0,a0,-1588 # 80009068 <wait_lock>
    800016a4:	00005097          	auipc	ra,0x5
    800016a8:	f42080e7          	jalr	-190(ra) # 800065e6 <release>
          return pid;
    800016ac:	a09d                	j	80001712 <wait+0x100>
            release(&np->lock);
    800016ae:	8526                	mv	a0,s1
    800016b0:	00005097          	auipc	ra,0x5
    800016b4:	f36080e7          	jalr	-202(ra) # 800065e6 <release>
            release(&wait_lock);
    800016b8:	00008517          	auipc	a0,0x8
    800016bc:	9b050513          	addi	a0,a0,-1616 # 80009068 <wait_lock>
    800016c0:	00005097          	auipc	ra,0x5
    800016c4:	f26080e7          	jalr	-218(ra) # 800065e6 <release>
            return -1;
    800016c8:	59fd                	li	s3,-1
    800016ca:	a0a1                	j	80001712 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800016cc:	3f848493          	addi	s1,s1,1016
    800016d0:	03348463          	beq	s1,s3,800016f8 <wait+0xe6>
      if(np->parent == p){
    800016d4:	7c9c                	ld	a5,56(s1)
    800016d6:	ff279be3          	bne	a5,s2,800016cc <wait+0xba>
        acquire(&np->lock);
    800016da:	8526                	mv	a0,s1
    800016dc:	00005097          	auipc	ra,0x5
    800016e0:	e56080e7          	jalr	-426(ra) # 80006532 <acquire>
        if(np->state == ZOMBIE){
    800016e4:	4c9c                	lw	a5,24(s1)
    800016e6:	f94781e3          	beq	a5,s4,80001668 <wait+0x56>
        release(&np->lock);
    800016ea:	8526                	mv	a0,s1
    800016ec:	00005097          	auipc	ra,0x5
    800016f0:	efa080e7          	jalr	-262(ra) # 800065e6 <release>
        havekids = 1;
    800016f4:	8756                	mv	a4,s5
    800016f6:	bfd9                	j	800016cc <wait+0xba>
    if(!havekids || p->killed){
    800016f8:	c701                	beqz	a4,80001700 <wait+0xee>
    800016fa:	02892783          	lw	a5,40(s2)
    800016fe:	c79d                	beqz	a5,8000172c <wait+0x11a>
      release(&wait_lock);
    80001700:	00008517          	auipc	a0,0x8
    80001704:	96850513          	addi	a0,a0,-1688 # 80009068 <wait_lock>
    80001708:	00005097          	auipc	ra,0x5
    8000170c:	ede080e7          	jalr	-290(ra) # 800065e6 <release>
      return -1;
    80001710:	59fd                	li	s3,-1
}
    80001712:	854e                	mv	a0,s3
    80001714:	60a6                	ld	ra,72(sp)
    80001716:	6406                	ld	s0,64(sp)
    80001718:	74e2                	ld	s1,56(sp)
    8000171a:	7942                	ld	s2,48(sp)
    8000171c:	79a2                	ld	s3,40(sp)
    8000171e:	7a02                	ld	s4,32(sp)
    80001720:	6ae2                	ld	s5,24(sp)
    80001722:	6b42                	ld	s6,16(sp)
    80001724:	6ba2                	ld	s7,8(sp)
    80001726:	6c02                	ld	s8,0(sp)
    80001728:	6161                	addi	sp,sp,80
    8000172a:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000172c:	85e2                	mv	a1,s8
    8000172e:	854a                	mv	a0,s2
    80001730:	00000097          	auipc	ra,0x0
    80001734:	e7e080e7          	jalr	-386(ra) # 800015ae <sleep>
    havekids = 0;
    80001738:	b715                	j	8000165c <wait+0x4a>

000000008000173a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000173a:	7139                	addi	sp,sp,-64
    8000173c:	fc06                	sd	ra,56(sp)
    8000173e:	f822                	sd	s0,48(sp)
    80001740:	f426                	sd	s1,40(sp)
    80001742:	f04a                	sd	s2,32(sp)
    80001744:	ec4e                	sd	s3,24(sp)
    80001746:	e852                	sd	s4,16(sp)
    80001748:	e456                	sd	s5,8(sp)
    8000174a:	0080                	addi	s0,sp,64
    8000174c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000174e:	00008497          	auipc	s1,0x8
    80001752:	d3248493          	addi	s1,s1,-718 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001756:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001758:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000175a:	00018917          	auipc	s2,0x18
    8000175e:	b2690913          	addi	s2,s2,-1242 # 80019280 <tickslock>
    80001762:	a821                	j	8000177a <wakeup+0x40>
        p->state = RUNNABLE;
    80001764:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001768:	8526                	mv	a0,s1
    8000176a:	00005097          	auipc	ra,0x5
    8000176e:	e7c080e7          	jalr	-388(ra) # 800065e6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001772:	3f848493          	addi	s1,s1,1016
    80001776:	03248463          	beq	s1,s2,8000179e <wakeup+0x64>
    if(p != myproc()){
    8000177a:	fffff097          	auipc	ra,0xfffff
    8000177e:	6b4080e7          	jalr	1716(ra) # 80000e2e <myproc>
    80001782:	fea488e3          	beq	s1,a0,80001772 <wakeup+0x38>
      acquire(&p->lock);
    80001786:	8526                	mv	a0,s1
    80001788:	00005097          	auipc	ra,0x5
    8000178c:	daa080e7          	jalr	-598(ra) # 80006532 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001790:	4c9c                	lw	a5,24(s1)
    80001792:	fd379be3          	bne	a5,s3,80001768 <wakeup+0x2e>
    80001796:	709c                	ld	a5,32(s1)
    80001798:	fd4798e3          	bne	a5,s4,80001768 <wakeup+0x2e>
    8000179c:	b7e1                	j	80001764 <wakeup+0x2a>
    }
  }
}
    8000179e:	70e2                	ld	ra,56(sp)
    800017a0:	7442                	ld	s0,48(sp)
    800017a2:	74a2                	ld	s1,40(sp)
    800017a4:	7902                	ld	s2,32(sp)
    800017a6:	69e2                	ld	s3,24(sp)
    800017a8:	6a42                	ld	s4,16(sp)
    800017aa:	6aa2                	ld	s5,8(sp)
    800017ac:	6121                	addi	sp,sp,64
    800017ae:	8082                	ret

00000000800017b0 <reparent>:
{
    800017b0:	7179                	addi	sp,sp,-48
    800017b2:	f406                	sd	ra,40(sp)
    800017b4:	f022                	sd	s0,32(sp)
    800017b6:	ec26                	sd	s1,24(sp)
    800017b8:	e84a                	sd	s2,16(sp)
    800017ba:	e44e                	sd	s3,8(sp)
    800017bc:	e052                	sd	s4,0(sp)
    800017be:	1800                	addi	s0,sp,48
    800017c0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017c2:	00008497          	auipc	s1,0x8
    800017c6:	cbe48493          	addi	s1,s1,-834 # 80009480 <proc>
      pp->parent = initproc;
    800017ca:	00008a17          	auipc	s4,0x8
    800017ce:	846a0a13          	addi	s4,s4,-1978 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017d2:	00018997          	auipc	s3,0x18
    800017d6:	aae98993          	addi	s3,s3,-1362 # 80019280 <tickslock>
    800017da:	a029                	j	800017e4 <reparent+0x34>
    800017dc:	3f848493          	addi	s1,s1,1016
    800017e0:	01348d63          	beq	s1,s3,800017fa <reparent+0x4a>
    if(pp->parent == p){
    800017e4:	7c9c                	ld	a5,56(s1)
    800017e6:	ff279be3          	bne	a5,s2,800017dc <reparent+0x2c>
      pp->parent = initproc;
    800017ea:	000a3503          	ld	a0,0(s4)
    800017ee:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017f0:	00000097          	auipc	ra,0x0
    800017f4:	f4a080e7          	jalr	-182(ra) # 8000173a <wakeup>
    800017f8:	b7d5                	j	800017dc <reparent+0x2c>
}
    800017fa:	70a2                	ld	ra,40(sp)
    800017fc:	7402                	ld	s0,32(sp)
    800017fe:	64e2                	ld	s1,24(sp)
    80001800:	6942                	ld	s2,16(sp)
    80001802:	69a2                	ld	s3,8(sp)
    80001804:	6a02                	ld	s4,0(sp)
    80001806:	6145                	addi	sp,sp,48
    80001808:	8082                	ret

000000008000180a <exit>:
{
    8000180a:	7139                	addi	sp,sp,-64
    8000180c:	fc06                	sd	ra,56(sp)
    8000180e:	f822                	sd	s0,48(sp)
    80001810:	f426                	sd	s1,40(sp)
    80001812:	f04a                	sd	s2,32(sp)
    80001814:	ec4e                	sd	s3,24(sp)
    80001816:	e852                	sd	s4,16(sp)
    80001818:	e456                	sd	s5,8(sp)
    8000181a:	e05a                	sd	s6,0(sp)
    8000181c:	0080                	addi	s0,sp,64
    8000181e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001820:	fffff097          	auipc	ra,0xfffff
    80001824:	60e080e7          	jalr	1550(ra) # 80000e2e <myproc>
  if(p == initproc)
    80001828:	00007797          	auipc	a5,0x7
    8000182c:	7e87b783          	ld	a5,2024(a5) # 80009010 <initproc>
    80001830:	00a78e63          	beq	a5,a0,8000184c <exit+0x42>
    80001834:	89aa                	mv	s3,a0
  for(int i = 0; i < p->vma_size; i++){
    80001836:	3f054783          	lbu	a5,1008(a0)
    8000183a:	16850493          	addi	s1,a0,360
    8000183e:	4a01                	li	s4,0
    80001840:	e7b9                	bnez	a5,8000188e <exit+0x84>
  for(int fd = 0; fd < NOFILE; fd++){
    80001842:	0d098493          	addi	s1,s3,208
    80001846:	15098913          	addi	s2,s3,336
    8000184a:	a065                	j	800018f2 <exit+0xe8>
    panic("init exiting");
    8000184c:	00007517          	auipc	a0,0x7
    80001850:	95c50513          	addi	a0,a0,-1700 # 800081a8 <etext+0x1a8>
    80001854:	00004097          	auipc	ra,0x4
    80001858:	794080e7          	jalr	1940(ra) # 80005fe8 <panic>
      fileclose(p->vma[i].file);
    8000185c:	01893503          	ld	a0,24(s2)
    80001860:	00002097          	auipc	ra,0x2
    80001864:	574080e7          	jalr	1396(ra) # 80003dd4 <fileclose>
      uvmunmap(p->pagetable,p->vma[i].addr,p->vma[i].sz/PGSIZE,1);
    80001868:	00893603          	ld	a2,8(s2)
    8000186c:	4685                	li	a3,1
    8000186e:	8231                	srli	a2,a2,0xc
    80001870:	00093583          	ld	a1,0(s2)
    80001874:	0509b503          	ld	a0,80(s3)
    80001878:	fffff097          	auipc	ra,0xfffff
    8000187c:	e96080e7          	jalr	-362(ra) # 8000070e <uvmunmap>
  for(int i = 0; i < p->vma_size; i++){
    80001880:	2a05                	addiw	s4,s4,1
    80001882:	02848493          	addi	s1,s1,40
    80001886:	3f09c783          	lbu	a5,1008(s3)
    8000188a:	fafa5ce3          	bge	s4,a5,80001842 <exit+0x38>
      uint64 unmapsz = p->vma[i].sz;
    8000188e:	8926                	mv	s2,s1
    80001890:	0084ba83          	ld	s5,8(s1)
      if(unmapsz == 0)
    80001894:	fe0a86e3          	beqz	s5,80001880 <exit+0x76>
      if(p->vma[i].flags & MAP_SHARED){
    80001898:	0114c783          	lbu	a5,17(s1)
    8000189c:	8b85                	andi	a5,a5,1
    8000189e:	dfdd                	beqz	a5,8000185c <exit+0x52>
          begin_op();
    800018a0:	00002097          	auipc	ra,0x2
    800018a4:	068080e7          	jalr	104(ra) # 80003908 <begin_op>
          ilock(p->vma[i].file->ip);
    800018a8:	6c9c                	ld	a5,24(s1)
    800018aa:	6f88                	ld	a0,24(a5)
    800018ac:	00001097          	auipc	ra,0x1
    800018b0:	68a080e7          	jalr	1674(ra) # 80002f36 <ilock>
          writei(p->vma[i].file->ip, 1, p->vma[i].addr , p->vma[i].offset, unmapsz);
    800018b4:	6c9c                	ld	a5,24(s1)
    800018b6:	000a871b          	sext.w	a4,s5
    800018ba:	5094                	lw	a3,32(s1)
    800018bc:	6090                	ld	a2,0(s1)
    800018be:	4585                	li	a1,1
    800018c0:	6f88                	ld	a0,24(a5)
    800018c2:	00002097          	auipc	ra,0x2
    800018c6:	a20080e7          	jalr	-1504(ra) # 800032e2 <writei>
          iunlock(p->vma[i].file->ip);
    800018ca:	6c9c                	ld	a5,24(s1)
    800018cc:	6f88                	ld	a0,24(a5)
    800018ce:	00001097          	auipc	ra,0x1
    800018d2:	72a080e7          	jalr	1834(ra) # 80002ff8 <iunlock>
          end_op();
    800018d6:	00002097          	auipc	ra,0x2
    800018da:	0b2080e7          	jalr	178(ra) # 80003988 <end_op>
    800018de:	bfbd                	j	8000185c <exit+0x52>
      fileclose(f);
    800018e0:	00002097          	auipc	ra,0x2
    800018e4:	4f4080e7          	jalr	1268(ra) # 80003dd4 <fileclose>
      p->ofile[fd] = 0;
    800018e8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800018ec:	04a1                	addi	s1,s1,8
    800018ee:	00990563          	beq	s2,s1,800018f8 <exit+0xee>
    if(p->ofile[fd]){
    800018f2:	6088                	ld	a0,0(s1)
    800018f4:	f575                	bnez	a0,800018e0 <exit+0xd6>
    800018f6:	bfdd                	j	800018ec <exit+0xe2>
  begin_op();
    800018f8:	00002097          	auipc	ra,0x2
    800018fc:	010080e7          	jalr	16(ra) # 80003908 <begin_op>
  iput(p->cwd);
    80001900:	1509b503          	ld	a0,336(s3)
    80001904:	00001097          	auipc	ra,0x1
    80001908:	7ec080e7          	jalr	2028(ra) # 800030f0 <iput>
  end_op();
    8000190c:	00002097          	auipc	ra,0x2
    80001910:	07c080e7          	jalr	124(ra) # 80003988 <end_op>
  p->cwd = 0;
    80001914:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001918:	00007497          	auipc	s1,0x7
    8000191c:	75048493          	addi	s1,s1,1872 # 80009068 <wait_lock>
    80001920:	8526                	mv	a0,s1
    80001922:	00005097          	auipc	ra,0x5
    80001926:	c10080e7          	jalr	-1008(ra) # 80006532 <acquire>
  reparent(p);
    8000192a:	854e                	mv	a0,s3
    8000192c:	00000097          	auipc	ra,0x0
    80001930:	e84080e7          	jalr	-380(ra) # 800017b0 <reparent>
  wakeup(p->parent);
    80001934:	0389b503          	ld	a0,56(s3)
    80001938:	00000097          	auipc	ra,0x0
    8000193c:	e02080e7          	jalr	-510(ra) # 8000173a <wakeup>
  acquire(&p->lock);
    80001940:	854e                	mv	a0,s3
    80001942:	00005097          	auipc	ra,0x5
    80001946:	bf0080e7          	jalr	-1040(ra) # 80006532 <acquire>
  p->xstate = status;
    8000194a:	0369a623          	sw	s6,44(s3)
  p->state = ZOMBIE;
    8000194e:	4795                	li	a5,5
    80001950:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001954:	8526                	mv	a0,s1
    80001956:	00005097          	auipc	ra,0x5
    8000195a:	c90080e7          	jalr	-880(ra) # 800065e6 <release>
  sched();
    8000195e:	00000097          	auipc	ra,0x0
    80001962:	b3e080e7          	jalr	-1218(ra) # 8000149c <sched>
  panic("zombie exit");
    80001966:	00007517          	auipc	a0,0x7
    8000196a:	85250513          	addi	a0,a0,-1966 # 800081b8 <etext+0x1b8>
    8000196e:	00004097          	auipc	ra,0x4
    80001972:	67a080e7          	jalr	1658(ra) # 80005fe8 <panic>

0000000080001976 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001976:	7179                	addi	sp,sp,-48
    80001978:	f406                	sd	ra,40(sp)
    8000197a:	f022                	sd	s0,32(sp)
    8000197c:	ec26                	sd	s1,24(sp)
    8000197e:	e84a                	sd	s2,16(sp)
    80001980:	e44e                	sd	s3,8(sp)
    80001982:	1800                	addi	s0,sp,48
    80001984:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001986:	00008497          	auipc	s1,0x8
    8000198a:	afa48493          	addi	s1,s1,-1286 # 80009480 <proc>
    8000198e:	00018997          	auipc	s3,0x18
    80001992:	8f298993          	addi	s3,s3,-1806 # 80019280 <tickslock>
    acquire(&p->lock);
    80001996:	8526                	mv	a0,s1
    80001998:	00005097          	auipc	ra,0x5
    8000199c:	b9a080e7          	jalr	-1126(ra) # 80006532 <acquire>
    if(p->pid == pid){
    800019a0:	589c                	lw	a5,48(s1)
    800019a2:	01278d63          	beq	a5,s2,800019bc <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019a6:	8526                	mv	a0,s1
    800019a8:	00005097          	auipc	ra,0x5
    800019ac:	c3e080e7          	jalr	-962(ra) # 800065e6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800019b0:	3f848493          	addi	s1,s1,1016
    800019b4:	ff3491e3          	bne	s1,s3,80001996 <kill+0x20>
  }
  return -1;
    800019b8:	557d                	li	a0,-1
    800019ba:	a829                	j	800019d4 <kill+0x5e>
      p->killed = 1;
    800019bc:	4785                	li	a5,1
    800019be:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800019c0:	4c98                	lw	a4,24(s1)
    800019c2:	4789                	li	a5,2
    800019c4:	00f70f63          	beq	a4,a5,800019e2 <kill+0x6c>
      release(&p->lock);
    800019c8:	8526                	mv	a0,s1
    800019ca:	00005097          	auipc	ra,0x5
    800019ce:	c1c080e7          	jalr	-996(ra) # 800065e6 <release>
      return 0;
    800019d2:	4501                	li	a0,0
}
    800019d4:	70a2                	ld	ra,40(sp)
    800019d6:	7402                	ld	s0,32(sp)
    800019d8:	64e2                	ld	s1,24(sp)
    800019da:	6942                	ld	s2,16(sp)
    800019dc:	69a2                	ld	s3,8(sp)
    800019de:	6145                	addi	sp,sp,48
    800019e0:	8082                	ret
        p->state = RUNNABLE;
    800019e2:	478d                	li	a5,3
    800019e4:	cc9c                	sw	a5,24(s1)
    800019e6:	b7cd                	j	800019c8 <kill+0x52>

00000000800019e8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019e8:	7179                	addi	sp,sp,-48
    800019ea:	f406                	sd	ra,40(sp)
    800019ec:	f022                	sd	s0,32(sp)
    800019ee:	ec26                	sd	s1,24(sp)
    800019f0:	e84a                	sd	s2,16(sp)
    800019f2:	e44e                	sd	s3,8(sp)
    800019f4:	e052                	sd	s4,0(sp)
    800019f6:	1800                	addi	s0,sp,48
    800019f8:	84aa                	mv	s1,a0
    800019fa:	892e                	mv	s2,a1
    800019fc:	89b2                	mv	s3,a2
    800019fe:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a00:	fffff097          	auipc	ra,0xfffff
    80001a04:	42e080e7          	jalr	1070(ra) # 80000e2e <myproc>
  if(user_dst){
    80001a08:	c08d                	beqz	s1,80001a2a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a0a:	86d2                	mv	a3,s4
    80001a0c:	864e                	mv	a2,s3
    80001a0e:	85ca                	mv	a1,s2
    80001a10:	6928                	ld	a0,80(a0)
    80001a12:	fffff097          	auipc	ra,0xfffff
    80001a16:	0de080e7          	jalr	222(ra) # 80000af0 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a1a:	70a2                	ld	ra,40(sp)
    80001a1c:	7402                	ld	s0,32(sp)
    80001a1e:	64e2                	ld	s1,24(sp)
    80001a20:	6942                	ld	s2,16(sp)
    80001a22:	69a2                	ld	s3,8(sp)
    80001a24:	6a02                	ld	s4,0(sp)
    80001a26:	6145                	addi	sp,sp,48
    80001a28:	8082                	ret
    memmove((char *)dst, src, len);
    80001a2a:	000a061b          	sext.w	a2,s4
    80001a2e:	85ce                	mv	a1,s3
    80001a30:	854a                	mv	a0,s2
    80001a32:	ffffe097          	auipc	ra,0xffffe
    80001a36:	7a6080e7          	jalr	1958(ra) # 800001d8 <memmove>
    return 0;
    80001a3a:	8526                	mv	a0,s1
    80001a3c:	bff9                	j	80001a1a <either_copyout+0x32>

0000000080001a3e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a3e:	7179                	addi	sp,sp,-48
    80001a40:	f406                	sd	ra,40(sp)
    80001a42:	f022                	sd	s0,32(sp)
    80001a44:	ec26                	sd	s1,24(sp)
    80001a46:	e84a                	sd	s2,16(sp)
    80001a48:	e44e                	sd	s3,8(sp)
    80001a4a:	e052                	sd	s4,0(sp)
    80001a4c:	1800                	addi	s0,sp,48
    80001a4e:	892a                	mv	s2,a0
    80001a50:	84ae                	mv	s1,a1
    80001a52:	89b2                	mv	s3,a2
    80001a54:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a56:	fffff097          	auipc	ra,0xfffff
    80001a5a:	3d8080e7          	jalr	984(ra) # 80000e2e <myproc>
  if(user_src){
    80001a5e:	c08d                	beqz	s1,80001a80 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a60:	86d2                	mv	a3,s4
    80001a62:	864e                	mv	a2,s3
    80001a64:	85ca                	mv	a1,s2
    80001a66:	6928                	ld	a0,80(a0)
    80001a68:	fffff097          	auipc	ra,0xfffff
    80001a6c:	114080e7          	jalr	276(ra) # 80000b7c <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a70:	70a2                	ld	ra,40(sp)
    80001a72:	7402                	ld	s0,32(sp)
    80001a74:	64e2                	ld	s1,24(sp)
    80001a76:	6942                	ld	s2,16(sp)
    80001a78:	69a2                	ld	s3,8(sp)
    80001a7a:	6a02                	ld	s4,0(sp)
    80001a7c:	6145                	addi	sp,sp,48
    80001a7e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a80:	000a061b          	sext.w	a2,s4
    80001a84:	85ce                	mv	a1,s3
    80001a86:	854a                	mv	a0,s2
    80001a88:	ffffe097          	auipc	ra,0xffffe
    80001a8c:	750080e7          	jalr	1872(ra) # 800001d8 <memmove>
    return 0;
    80001a90:	8526                	mv	a0,s1
    80001a92:	bff9                	j	80001a70 <either_copyin+0x32>

0000000080001a94 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a94:	715d                	addi	sp,sp,-80
    80001a96:	e486                	sd	ra,72(sp)
    80001a98:	e0a2                	sd	s0,64(sp)
    80001a9a:	fc26                	sd	s1,56(sp)
    80001a9c:	f84a                	sd	s2,48(sp)
    80001a9e:	f44e                	sd	s3,40(sp)
    80001aa0:	f052                	sd	s4,32(sp)
    80001aa2:	ec56                	sd	s5,24(sp)
    80001aa4:	e85a                	sd	s6,16(sp)
    80001aa6:	e45e                	sd	s7,8(sp)
    80001aa8:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001aaa:	00006517          	auipc	a0,0x6
    80001aae:	59e50513          	addi	a0,a0,1438 # 80008048 <etext+0x48>
    80001ab2:	00004097          	auipc	ra,0x4
    80001ab6:	580080e7          	jalr	1408(ra) # 80006032 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001aba:	00008497          	auipc	s1,0x8
    80001abe:	b1e48493          	addi	s1,s1,-1250 # 800095d8 <proc+0x158>
    80001ac2:	00018917          	auipc	s2,0x18
    80001ac6:	91690913          	addi	s2,s2,-1770 # 800193d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aca:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001acc:	00006997          	auipc	s3,0x6
    80001ad0:	6fc98993          	addi	s3,s3,1788 # 800081c8 <etext+0x1c8>
    printf("%d %s %s", p->pid, state, p->name);
    80001ad4:	00006a97          	auipc	s5,0x6
    80001ad8:	6fca8a93          	addi	s5,s5,1788 # 800081d0 <etext+0x1d0>
    printf("\n");
    80001adc:	00006a17          	auipc	s4,0x6
    80001ae0:	56ca0a13          	addi	s4,s4,1388 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ae4:	00006b97          	auipc	s7,0x6
    80001ae8:	724b8b93          	addi	s7,s7,1828 # 80008208 <states.1789>
    80001aec:	a00d                	j	80001b0e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001aee:	ed86a583          	lw	a1,-296(a3)
    80001af2:	8556                	mv	a0,s5
    80001af4:	00004097          	auipc	ra,0x4
    80001af8:	53e080e7          	jalr	1342(ra) # 80006032 <printf>
    printf("\n");
    80001afc:	8552                	mv	a0,s4
    80001afe:	00004097          	auipc	ra,0x4
    80001b02:	534080e7          	jalr	1332(ra) # 80006032 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b06:	3f848493          	addi	s1,s1,1016
    80001b0a:	03248163          	beq	s1,s2,80001b2c <procdump+0x98>
    if(p->state == UNUSED)
    80001b0e:	86a6                	mv	a3,s1
    80001b10:	ec04a783          	lw	a5,-320(s1)
    80001b14:	dbed                	beqz	a5,80001b06 <procdump+0x72>
      state = "???";
    80001b16:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b18:	fcfb6be3          	bltu	s6,a5,80001aee <procdump+0x5a>
    80001b1c:	1782                	slli	a5,a5,0x20
    80001b1e:	9381                	srli	a5,a5,0x20
    80001b20:	078e                	slli	a5,a5,0x3
    80001b22:	97de                	add	a5,a5,s7
    80001b24:	6390                	ld	a2,0(a5)
    80001b26:	f661                	bnez	a2,80001aee <procdump+0x5a>
      state = "???";
    80001b28:	864e                	mv	a2,s3
    80001b2a:	b7d1                	j	80001aee <procdump+0x5a>
  }
}
    80001b2c:	60a6                	ld	ra,72(sp)
    80001b2e:	6406                	ld	s0,64(sp)
    80001b30:	74e2                	ld	s1,56(sp)
    80001b32:	7942                	ld	s2,48(sp)
    80001b34:	79a2                	ld	s3,40(sp)
    80001b36:	7a02                	ld	s4,32(sp)
    80001b38:	6ae2                	ld	s5,24(sp)
    80001b3a:	6b42                	ld	s6,16(sp)
    80001b3c:	6ba2                	ld	s7,8(sp)
    80001b3e:	6161                	addi	sp,sp,80
    80001b40:	8082                	ret

0000000080001b42 <swtch>:
    80001b42:	00153023          	sd	ra,0(a0)
    80001b46:	00253423          	sd	sp,8(a0)
    80001b4a:	e900                	sd	s0,16(a0)
    80001b4c:	ed04                	sd	s1,24(a0)
    80001b4e:	03253023          	sd	s2,32(a0)
    80001b52:	03353423          	sd	s3,40(a0)
    80001b56:	03453823          	sd	s4,48(a0)
    80001b5a:	03553c23          	sd	s5,56(a0)
    80001b5e:	05653023          	sd	s6,64(a0)
    80001b62:	05753423          	sd	s7,72(a0)
    80001b66:	05853823          	sd	s8,80(a0)
    80001b6a:	05953c23          	sd	s9,88(a0)
    80001b6e:	07a53023          	sd	s10,96(a0)
    80001b72:	07b53423          	sd	s11,104(a0)
    80001b76:	0005b083          	ld	ra,0(a1)
    80001b7a:	0085b103          	ld	sp,8(a1)
    80001b7e:	6980                	ld	s0,16(a1)
    80001b80:	6d84                	ld	s1,24(a1)
    80001b82:	0205b903          	ld	s2,32(a1)
    80001b86:	0285b983          	ld	s3,40(a1)
    80001b8a:	0305ba03          	ld	s4,48(a1)
    80001b8e:	0385ba83          	ld	s5,56(a1)
    80001b92:	0405bb03          	ld	s6,64(a1)
    80001b96:	0485bb83          	ld	s7,72(a1)
    80001b9a:	0505bc03          	ld	s8,80(a1)
    80001b9e:	0585bc83          	ld	s9,88(a1)
    80001ba2:	0605bd03          	ld	s10,96(a1)
    80001ba6:	0685bd83          	ld	s11,104(a1)
    80001baa:	8082                	ret

0000000080001bac <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001bac:	1141                	addi	sp,sp,-16
    80001bae:	e406                	sd	ra,8(sp)
    80001bb0:	e022                	sd	s0,0(sp)
    80001bb2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bb4:	00006597          	auipc	a1,0x6
    80001bb8:	68458593          	addi	a1,a1,1668 # 80008238 <states.1789+0x30>
    80001bbc:	00017517          	auipc	a0,0x17
    80001bc0:	6c450513          	addi	a0,a0,1732 # 80019280 <tickslock>
    80001bc4:	00005097          	auipc	ra,0x5
    80001bc8:	8de080e7          	jalr	-1826(ra) # 800064a2 <initlock>
}
    80001bcc:	60a2                	ld	ra,8(sp)
    80001bce:	6402                	ld	s0,0(sp)
    80001bd0:	0141                	addi	sp,sp,16
    80001bd2:	8082                	ret

0000000080001bd4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bd4:	1141                	addi	sp,sp,-16
    80001bd6:	e422                	sd	s0,8(sp)
    80001bd8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bda:	00004797          	auipc	a5,0x4
    80001bde:	81678793          	addi	a5,a5,-2026 # 800053f0 <kernelvec>
    80001be2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001be6:	6422                	ld	s0,8(sp)
    80001be8:	0141                	addi	sp,sp,16
    80001bea:	8082                	ret

0000000080001bec <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bec:	1141                	addi	sp,sp,-16
    80001bee:	e406                	sd	ra,8(sp)
    80001bf0:	e022                	sd	s0,0(sp)
    80001bf2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bf4:	fffff097          	auipc	ra,0xfffff
    80001bf8:	23a080e7          	jalr	570(ra) # 80000e2e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bfc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c00:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c02:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c06:	00005617          	auipc	a2,0x5
    80001c0a:	3fa60613          	addi	a2,a2,1018 # 80007000 <_trampoline>
    80001c0e:	00005697          	auipc	a3,0x5
    80001c12:	3f268693          	addi	a3,a3,1010 # 80007000 <_trampoline>
    80001c16:	8e91                	sub	a3,a3,a2
    80001c18:	040007b7          	lui	a5,0x4000
    80001c1c:	17fd                	addi	a5,a5,-1
    80001c1e:	07b2                	slli	a5,a5,0xc
    80001c20:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c22:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c26:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c28:	180026f3          	csrr	a3,satp
    80001c2c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c2e:	6d38                	ld	a4,88(a0)
    80001c30:	6134                	ld	a3,64(a0)
    80001c32:	6585                	lui	a1,0x1
    80001c34:	96ae                	add	a3,a3,a1
    80001c36:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c38:	6d38                	ld	a4,88(a0)
    80001c3a:	00000697          	auipc	a3,0x0
    80001c3e:	13868693          	addi	a3,a3,312 # 80001d72 <usertrap>
    80001c42:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c44:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c46:	8692                	mv	a3,tp
    80001c48:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c4a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c4e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c52:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c56:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c5a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c5c:	6f18                	ld	a4,24(a4)
    80001c5e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c62:	692c                	ld	a1,80(a0)
    80001c64:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c66:	00005717          	auipc	a4,0x5
    80001c6a:	42a70713          	addi	a4,a4,1066 # 80007090 <userret>
    80001c6e:	8f11                	sub	a4,a4,a2
    80001c70:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c72:	577d                	li	a4,-1
    80001c74:	177e                	slli	a4,a4,0x3f
    80001c76:	8dd9                	or	a1,a1,a4
    80001c78:	02000537          	lui	a0,0x2000
    80001c7c:	157d                	addi	a0,a0,-1
    80001c7e:	0536                	slli	a0,a0,0xd
    80001c80:	9782                	jalr	a5
}
    80001c82:	60a2                	ld	ra,8(sp)
    80001c84:	6402                	ld	s0,0(sp)
    80001c86:	0141                	addi	sp,sp,16
    80001c88:	8082                	ret

0000000080001c8a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c8a:	1101                	addi	sp,sp,-32
    80001c8c:	ec06                	sd	ra,24(sp)
    80001c8e:	e822                	sd	s0,16(sp)
    80001c90:	e426                	sd	s1,8(sp)
    80001c92:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c94:	00017497          	auipc	s1,0x17
    80001c98:	5ec48493          	addi	s1,s1,1516 # 80019280 <tickslock>
    80001c9c:	8526                	mv	a0,s1
    80001c9e:	00005097          	auipc	ra,0x5
    80001ca2:	894080e7          	jalr	-1900(ra) # 80006532 <acquire>
  ticks++;
    80001ca6:	00007517          	auipc	a0,0x7
    80001caa:	37250513          	addi	a0,a0,882 # 80009018 <ticks>
    80001cae:	411c                	lw	a5,0(a0)
    80001cb0:	2785                	addiw	a5,a5,1
    80001cb2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001cb4:	00000097          	auipc	ra,0x0
    80001cb8:	a86080e7          	jalr	-1402(ra) # 8000173a <wakeup>
  release(&tickslock);
    80001cbc:	8526                	mv	a0,s1
    80001cbe:	00005097          	auipc	ra,0x5
    80001cc2:	928080e7          	jalr	-1752(ra) # 800065e6 <release>
}
    80001cc6:	60e2                	ld	ra,24(sp)
    80001cc8:	6442                	ld	s0,16(sp)
    80001cca:	64a2                	ld	s1,8(sp)
    80001ccc:	6105                	addi	sp,sp,32
    80001cce:	8082                	ret

0000000080001cd0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001cd0:	1101                	addi	sp,sp,-32
    80001cd2:	ec06                	sd	ra,24(sp)
    80001cd4:	e822                	sd	s0,16(sp)
    80001cd6:	e426                	sd	s1,8(sp)
    80001cd8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cda:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001cde:	00074d63          	bltz	a4,80001cf8 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001ce2:	57fd                	li	a5,-1
    80001ce4:	17fe                	slli	a5,a5,0x3f
    80001ce6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ce8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cea:	06f70363          	beq	a4,a5,80001d50 <devintr+0x80>
  }
}
    80001cee:	60e2                	ld	ra,24(sp)
    80001cf0:	6442                	ld	s0,16(sp)
    80001cf2:	64a2                	ld	s1,8(sp)
    80001cf4:	6105                	addi	sp,sp,32
    80001cf6:	8082                	ret
     (scause & 0xff) == 9){
    80001cf8:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001cfc:	46a5                	li	a3,9
    80001cfe:	fed792e3          	bne	a5,a3,80001ce2 <devintr+0x12>
    int irq = plic_claim();
    80001d02:	00003097          	auipc	ra,0x3
    80001d06:	7f6080e7          	jalr	2038(ra) # 800054f8 <plic_claim>
    80001d0a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d0c:	47a9                	li	a5,10
    80001d0e:	02f50763          	beq	a0,a5,80001d3c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d12:	4785                	li	a5,1
    80001d14:	02f50963          	beq	a0,a5,80001d46 <devintr+0x76>
    return 1;
    80001d18:	4505                	li	a0,1
    } else if(irq){
    80001d1a:	d8f1                	beqz	s1,80001cee <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d1c:	85a6                	mv	a1,s1
    80001d1e:	00006517          	auipc	a0,0x6
    80001d22:	52250513          	addi	a0,a0,1314 # 80008240 <states.1789+0x38>
    80001d26:	00004097          	auipc	ra,0x4
    80001d2a:	30c080e7          	jalr	780(ra) # 80006032 <printf>
      plic_complete(irq);
    80001d2e:	8526                	mv	a0,s1
    80001d30:	00003097          	auipc	ra,0x3
    80001d34:	7ec080e7          	jalr	2028(ra) # 8000551c <plic_complete>
    return 1;
    80001d38:	4505                	li	a0,1
    80001d3a:	bf55                	j	80001cee <devintr+0x1e>
      uartintr();
    80001d3c:	00004097          	auipc	ra,0x4
    80001d40:	716080e7          	jalr	1814(ra) # 80006452 <uartintr>
    80001d44:	b7ed                	j	80001d2e <devintr+0x5e>
      virtio_disk_intr();
    80001d46:	00004097          	auipc	ra,0x4
    80001d4a:	cb6080e7          	jalr	-842(ra) # 800059fc <virtio_disk_intr>
    80001d4e:	b7c5                	j	80001d2e <devintr+0x5e>
    if(cpuid() == 0){
    80001d50:	fffff097          	auipc	ra,0xfffff
    80001d54:	0b2080e7          	jalr	178(ra) # 80000e02 <cpuid>
    80001d58:	c901                	beqz	a0,80001d68 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d5a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d5e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d60:	14479073          	csrw	sip,a5
    return 2;
    80001d64:	4509                	li	a0,2
    80001d66:	b761                	j	80001cee <devintr+0x1e>
      clockintr();
    80001d68:	00000097          	auipc	ra,0x0
    80001d6c:	f22080e7          	jalr	-222(ra) # 80001c8a <clockintr>
    80001d70:	b7ed                	j	80001d5a <devintr+0x8a>

0000000080001d72 <usertrap>:
{
    80001d72:	715d                	addi	sp,sp,-80
    80001d74:	e486                	sd	ra,72(sp)
    80001d76:	e0a2                	sd	s0,64(sp)
    80001d78:	fc26                	sd	s1,56(sp)
    80001d7a:	f84a                	sd	s2,48(sp)
    80001d7c:	f44e                	sd	s3,40(sp)
    80001d7e:	f052                	sd	s4,32(sp)
    80001d80:	ec56                	sd	s5,24(sp)
    80001d82:	e85a                	sd	s6,16(sp)
    80001d84:	e45e                	sd	s7,8(sp)
    80001d86:	0880                	addi	s0,sp,80
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d88:	100027f3          	csrr	a5,sstatus
    if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d8c:	1007f793          	andi	a5,a5,256
    80001d90:	e7bd                	bnez	a5,80001dfe <usertrap+0x8c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d92:	00003797          	auipc	a5,0x3
    80001d96:	65e78793          	addi	a5,a5,1630 # 800053f0 <kernelvec>
    80001d9a:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80001d9e:	fffff097          	auipc	ra,0xfffff
    80001da2:	090080e7          	jalr	144(ra) # 80000e2e <myproc>
    80001da6:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80001da8:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001daa:	14102773          	csrr	a4,sepc
    80001dae:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001db0:	14202773          	csrr	a4,scause
    if(r_scause() == 8){
    80001db4:	47a1                	li	a5,8
    80001db6:	06f71263          	bne	a4,a5,80001e1a <usertrap+0xa8>
        if(p->killed)
    80001dba:	551c                	lw	a5,40(a0)
    80001dbc:	eba9                	bnez	a5,80001e0e <usertrap+0x9c>
        p->trapframe->epc += 4;
    80001dbe:	6cb8                	ld	a4,88(s1)
    80001dc0:	6f1c                	ld	a5,24(a4)
    80001dc2:	0791                	addi	a5,a5,4
    80001dc4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dc6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001dca:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dce:	10079073          	csrw	sstatus,a5
        syscall();
    80001dd2:	00000097          	auipc	ra,0x0
    80001dd6:	3ea080e7          	jalr	1002(ra) # 800021bc <syscall>
    if(p->killed)
    80001dda:	549c                	lw	a5,40(s1)
    80001ddc:	18079d63          	bnez	a5,80001f76 <usertrap+0x204>
    usertrapret();
    80001de0:	00000097          	auipc	ra,0x0
    80001de4:	e0c080e7          	jalr	-500(ra) # 80001bec <usertrapret>
}
    80001de8:	60a6                	ld	ra,72(sp)
    80001dea:	6406                	ld	s0,64(sp)
    80001dec:	74e2                	ld	s1,56(sp)
    80001dee:	7942                	ld	s2,48(sp)
    80001df0:	79a2                	ld	s3,40(sp)
    80001df2:	7a02                	ld	s4,32(sp)
    80001df4:	6ae2                	ld	s5,24(sp)
    80001df6:	6b42                	ld	s6,16(sp)
    80001df8:	6ba2                	ld	s7,8(sp)
    80001dfa:	6161                	addi	sp,sp,80
    80001dfc:	8082                	ret
        panic("usertrap: not from user mode");
    80001dfe:	00006517          	auipc	a0,0x6
    80001e02:	46250513          	addi	a0,a0,1122 # 80008260 <states.1789+0x58>
    80001e06:	00004097          	auipc	ra,0x4
    80001e0a:	1e2080e7          	jalr	482(ra) # 80005fe8 <panic>
            exit(-1);
    80001e0e:	557d                	li	a0,-1
    80001e10:	00000097          	auipc	ra,0x0
    80001e14:	9fa080e7          	jalr	-1542(ra) # 8000180a <exit>
    80001e18:	b75d                	j	80001dbe <usertrap+0x4c>
    } else if((which_dev = devintr()) != 0){
    80001e1a:	00000097          	auipc	ra,0x0
    80001e1e:	eb6080e7          	jalr	-330(ra) # 80001cd0 <devintr>
    80001e22:	892a                	mv	s2,a0
    80001e24:	14051663          	bnez	a0,80001f70 <usertrap+0x1fe>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e28:	143029f3          	csrr	s3,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e2c:	14202773          	csrr	a4,scause
        if((r_scause() == 13 || r_scause() == 15) && va >= p->mmap_addr && va < TRAPFRAME){
    80001e30:	47b5                	li	a5,13
    80001e32:	04f70d63          	beq	a4,a5,80001e8c <usertrap+0x11a>
    80001e36:	14202773          	csrr	a4,scause
    80001e3a:	47bd                	li	a5,15
    80001e3c:	04f70863          	beq	a4,a5,80001e8c <usertrap+0x11a>
    80001e40:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e44:	5890                	lw	a2,48(s1)
    80001e46:	00006517          	auipc	a0,0x6
    80001e4a:	43a50513          	addi	a0,a0,1082 # 80008280 <states.1789+0x78>
    80001e4e:	00004097          	auipc	ra,0x4
    80001e52:	1e4080e7          	jalr	484(ra) # 80006032 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e56:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e5a:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e5e:	00006517          	auipc	a0,0x6
    80001e62:	45250513          	addi	a0,a0,1106 # 800082b0 <states.1789+0xa8>
    80001e66:	00004097          	auipc	ra,0x4
    80001e6a:	1cc080e7          	jalr	460(ra) # 80006032 <printf>
        p->killed = 1;
    80001e6e:	4785                	li	a5,1
    80001e70:	d49c                	sw	a5,40(s1)
        exit(-1);
    80001e72:	557d                	li	a0,-1
    80001e74:	00000097          	auipc	ra,0x0
    80001e78:	996080e7          	jalr	-1642(ra) # 8000180a <exit>
    if(which_dev == 2)
    80001e7c:	4789                	li	a5,2
    80001e7e:	f6f911e3          	bne	s2,a5,80001de0 <usertrap+0x6e>
        yield();
    80001e82:	fffff097          	auipc	ra,0xfffff
    80001e86:	6f0080e7          	jalr	1776(ra) # 80001572 <yield>
    80001e8a:	bf99                	j	80001de0 <usertrap+0x6e>
        uint64 va = PGROUNDDOWN(r_stval());
    80001e8c:	77fd                	lui	a5,0xfffff
    80001e8e:	00f9f9b3          	and	s3,s3,a5
        if((r_scause() == 13 || r_scause() == 15) && va >= p->mmap_addr && va < TRAPFRAME){
    80001e92:	3e84b783          	ld	a5,1000(s1)
    80001e96:	faf9e5e3          	bltu	s3,a5,80001e40 <usertrap+0xce>
    80001e9a:	fdfff7b7          	lui	a5,0xfdfff
    80001e9e:	07ba                	slli	a5,a5,0xe
    80001ea0:	83e9                	srli	a5,a5,0x1a
    80001ea2:	f937efe3          	bltu	a5,s3,80001e40 <usertrap+0xce>
            for(int i = 0; i < p->vma_size; i++){
    80001ea6:	3f04c683          	lbu	a3,1008(s1)
    80001eaa:	f8d05be3          	blez	a3,80001e40 <usertrap+0xce>
    80001eae:	16848713          	addi	a4,s1,360
    80001eb2:	8a4a                	mv	s4,s2
    80001eb4:	a031                	j	80001ec0 <usertrap+0x14e>
    80001eb6:	2a05                	addiw	s4,s4,1
    80001eb8:	02870713          	addi	a4,a4,40
    80001ebc:	f8da02e3          	beq	s4,a3,80001e40 <usertrap+0xce>
                if(va >= p->vma[i].addr && va < p->vma[i].addr + p->sz){
    80001ec0:	631c                	ld	a5,0(a4)
    80001ec2:	fef9eae3          	bltu	s3,a5,80001eb6 <usertrap+0x144>
    80001ec6:	64b0                	ld	a2,72(s1)
    80001ec8:	97b2                	add	a5,a5,a2
    80001eca:	fef9f6e3          	bgeu	s3,a5,80001eb6 <usertrap+0x144>
            if(vma_idx == -1)
    80001ece:	57fd                	li	a5,-1
    80001ed0:	f6fa08e3          	beq	s4,a5,80001e40 <usertrap+0xce>
            if((mem = kalloc()) == 0){
    80001ed4:	ffffe097          	auipc	ra,0xffffe
    80001ed8:	244080e7          	jalr	580(ra) # 80000118 <kalloc>
    80001edc:	8aaa                	mv	s5,a0
    80001ede:	d12d                	beqz	a0,80001e40 <usertrap+0xce>
            memset(mem,0,PGSIZE);
    80001ee0:	6605                	lui	a2,0x1
    80001ee2:	4581                	li	a1,0
    80001ee4:	ffffe097          	auipc	ra,0xffffe
    80001ee8:	294080e7          	jalr	660(ra) # 80000178 <memset>
            struct vma p_vma = p->vma[vma_idx];
    80001eec:	002a1793          	slli	a5,s4,0x2
    80001ef0:	97d2                	add	a5,a5,s4
    80001ef2:	078e                	slli	a5,a5,0x3
    80001ef4:	16878793          	addi	a5,a5,360 # fffffffffdfff168 <end+0xffffffff7dfcef28>
    80001ef8:	97a6                	add	a5,a5,s1
    80001efa:	0007bb03          	ld	s6,0(a5)
    80001efe:	0107c683          	lbu	a3,16(a5)
    80001f02:	0187ba03          	ld	s4,24(a5)
    80001f06:	0207ab83          	lw	s7,32(a5)
            uint8 RD_flag = p_vma.prot & 0x1;
    80001f0a:	0016f713          	andi	a4,a3,1
            uint8 WR_flag = p_vma.prot & 0x2;
    80001f0e:	8a89                	andi	a3,a3,2
            flag = RD_flag ? flag | PTE_R : flag;
    80001f10:	c311                	beqz	a4,80001f14 <usertrap+0x1a2>
    80001f12:	4709                	li	a4,2
            flag = WR_flag ? flag | PTE_W : flag;
    80001f14:	c299                	beqz	a3,80001f1a <usertrap+0x1a8>
    80001f16:	00476713          	ori	a4,a4,4
            if(mappages(p->pagetable, va, PGSIZE, (uint64)mem, flag|PTE_U) != 0){
    80001f1a:	01076713          	ori	a4,a4,16
    80001f1e:	86d6                	mv	a3,s5
    80001f20:	6605                	lui	a2,0x1
    80001f22:	85ce                	mv	a1,s3
    80001f24:	68a8                	ld	a0,80(s1)
    80001f26:	ffffe097          	auipc	ra,0xffffe
    80001f2a:	622080e7          	jalr	1570(ra) # 80000548 <mappages>
    80001f2e:	c519                	beqz	a0,80001f3c <usertrap+0x1ca>
                kfree(mem);
    80001f30:	8556                	mv	a0,s5
    80001f32:	ffffe097          	auipc	ra,0xffffe
    80001f36:	0ea080e7          	jalr	234(ra) # 8000001c <kfree>
                goto error;
    80001f3a:	b719                	j	80001e40 <usertrap+0xce>
            ilock(p_vma.file->ip);
    80001f3c:	018a3503          	ld	a0,24(s4)
    80001f40:	00001097          	auipc	ra,0x1
    80001f44:	ff6080e7          	jalr	-10(ra) # 80002f36 <ilock>
            readi(p_vma.file->ip, 0, (uint64)mem, va - p_vma.addr + p_vma.offset,PGSIZE);
    80001f48:	017986bb          	addw	a3,s3,s7
    80001f4c:	6705                	lui	a4,0x1
    80001f4e:	416686bb          	subw	a3,a3,s6
    80001f52:	8656                	mv	a2,s5
    80001f54:	4581                	li	a1,0
    80001f56:	018a3503          	ld	a0,24(s4)
    80001f5a:	00001097          	auipc	ra,0x1
    80001f5e:	290080e7          	jalr	656(ra) # 800031ea <readi>
            iunlock(p_vma.file->ip);
    80001f62:	018a3503          	ld	a0,24(s4)
    80001f66:	00001097          	auipc	ra,0x1
    80001f6a:	092080e7          	jalr	146(ra) # 80002ff8 <iunlock>
            goto done;
    80001f6e:	b5b5                	j	80001dda <usertrap+0x68>
    if(p->killed)
    80001f70:	549c                	lw	a5,40(s1)
    80001f72:	d789                	beqz	a5,80001e7c <usertrap+0x10a>
    80001f74:	bdfd                	j	80001e72 <usertrap+0x100>
    80001f76:	4901                	li	s2,0
    80001f78:	bded                	j	80001e72 <usertrap+0x100>

0000000080001f7a <kerneltrap>:
{
    80001f7a:	7179                	addi	sp,sp,-48
    80001f7c:	f406                	sd	ra,40(sp)
    80001f7e:	f022                	sd	s0,32(sp)
    80001f80:	ec26                	sd	s1,24(sp)
    80001f82:	e84a                	sd	s2,16(sp)
    80001f84:	e44e                	sd	s3,8(sp)
    80001f86:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f88:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f8c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f90:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f94:	1004f793          	andi	a5,s1,256
    80001f98:	cb85                	beqz	a5,80001fc8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f9a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f9e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001fa0:	ef85                	bnez	a5,80001fd8 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001fa2:	00000097          	auipc	ra,0x0
    80001fa6:	d2e080e7          	jalr	-722(ra) # 80001cd0 <devintr>
    80001faa:	cd1d                	beqz	a0,80001fe8 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fac:	4789                	li	a5,2
    80001fae:	06f50a63          	beq	a0,a5,80002022 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001fb2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fb6:	10049073          	csrw	sstatus,s1
}
    80001fba:	70a2                	ld	ra,40(sp)
    80001fbc:	7402                	ld	s0,32(sp)
    80001fbe:	64e2                	ld	s1,24(sp)
    80001fc0:	6942                	ld	s2,16(sp)
    80001fc2:	69a2                	ld	s3,8(sp)
    80001fc4:	6145                	addi	sp,sp,48
    80001fc6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001fc8:	00006517          	auipc	a0,0x6
    80001fcc:	30850513          	addi	a0,a0,776 # 800082d0 <states.1789+0xc8>
    80001fd0:	00004097          	auipc	ra,0x4
    80001fd4:	018080e7          	jalr	24(ra) # 80005fe8 <panic>
    panic("kerneltrap: interrupts enabled");
    80001fd8:	00006517          	auipc	a0,0x6
    80001fdc:	32050513          	addi	a0,a0,800 # 800082f8 <states.1789+0xf0>
    80001fe0:	00004097          	auipc	ra,0x4
    80001fe4:	008080e7          	jalr	8(ra) # 80005fe8 <panic>
    printf("scause %p\n", scause);
    80001fe8:	85ce                	mv	a1,s3
    80001fea:	00006517          	auipc	a0,0x6
    80001fee:	32e50513          	addi	a0,a0,814 # 80008318 <states.1789+0x110>
    80001ff2:	00004097          	auipc	ra,0x4
    80001ff6:	040080e7          	jalr	64(ra) # 80006032 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ffa:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ffe:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002002:	00006517          	auipc	a0,0x6
    80002006:	32650513          	addi	a0,a0,806 # 80008328 <states.1789+0x120>
    8000200a:	00004097          	auipc	ra,0x4
    8000200e:	028080e7          	jalr	40(ra) # 80006032 <printf>
    panic("kerneltrap");
    80002012:	00006517          	auipc	a0,0x6
    80002016:	32e50513          	addi	a0,a0,814 # 80008340 <states.1789+0x138>
    8000201a:	00004097          	auipc	ra,0x4
    8000201e:	fce080e7          	jalr	-50(ra) # 80005fe8 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002022:	fffff097          	auipc	ra,0xfffff
    80002026:	e0c080e7          	jalr	-500(ra) # 80000e2e <myproc>
    8000202a:	d541                	beqz	a0,80001fb2 <kerneltrap+0x38>
    8000202c:	fffff097          	auipc	ra,0xfffff
    80002030:	e02080e7          	jalr	-510(ra) # 80000e2e <myproc>
    80002034:	4d18                	lw	a4,24(a0)
    80002036:	4791                	li	a5,4
    80002038:	f6f71de3          	bne	a4,a5,80001fb2 <kerneltrap+0x38>
    yield();
    8000203c:	fffff097          	auipc	ra,0xfffff
    80002040:	536080e7          	jalr	1334(ra) # 80001572 <yield>
    80002044:	b7bd                	j	80001fb2 <kerneltrap+0x38>

0000000080002046 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002046:	1101                	addi	sp,sp,-32
    80002048:	ec06                	sd	ra,24(sp)
    8000204a:	e822                	sd	s0,16(sp)
    8000204c:	e426                	sd	s1,8(sp)
    8000204e:	1000                	addi	s0,sp,32
    80002050:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002052:	fffff097          	auipc	ra,0xfffff
    80002056:	ddc080e7          	jalr	-548(ra) # 80000e2e <myproc>
  switch (n) {
    8000205a:	4795                	li	a5,5
    8000205c:	0497e163          	bltu	a5,s1,8000209e <argraw+0x58>
    80002060:	048a                	slli	s1,s1,0x2
    80002062:	00006717          	auipc	a4,0x6
    80002066:	31670713          	addi	a4,a4,790 # 80008378 <states.1789+0x170>
    8000206a:	94ba                	add	s1,s1,a4
    8000206c:	409c                	lw	a5,0(s1)
    8000206e:	97ba                	add	a5,a5,a4
    80002070:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002072:	6d3c                	ld	a5,88(a0)
    80002074:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002076:	60e2                	ld	ra,24(sp)
    80002078:	6442                	ld	s0,16(sp)
    8000207a:	64a2                	ld	s1,8(sp)
    8000207c:	6105                	addi	sp,sp,32
    8000207e:	8082                	ret
    return p->trapframe->a1;
    80002080:	6d3c                	ld	a5,88(a0)
    80002082:	7fa8                	ld	a0,120(a5)
    80002084:	bfcd                	j	80002076 <argraw+0x30>
    return p->trapframe->a2;
    80002086:	6d3c                	ld	a5,88(a0)
    80002088:	63c8                	ld	a0,128(a5)
    8000208a:	b7f5                	j	80002076 <argraw+0x30>
    return p->trapframe->a3;
    8000208c:	6d3c                	ld	a5,88(a0)
    8000208e:	67c8                	ld	a0,136(a5)
    80002090:	b7dd                	j	80002076 <argraw+0x30>
    return p->trapframe->a4;
    80002092:	6d3c                	ld	a5,88(a0)
    80002094:	6bc8                	ld	a0,144(a5)
    80002096:	b7c5                	j	80002076 <argraw+0x30>
    return p->trapframe->a5;
    80002098:	6d3c                	ld	a5,88(a0)
    8000209a:	6fc8                	ld	a0,152(a5)
    8000209c:	bfe9                	j	80002076 <argraw+0x30>
  panic("argraw");
    8000209e:	00006517          	auipc	a0,0x6
    800020a2:	2b250513          	addi	a0,a0,690 # 80008350 <states.1789+0x148>
    800020a6:	00004097          	auipc	ra,0x4
    800020aa:	f42080e7          	jalr	-190(ra) # 80005fe8 <panic>

00000000800020ae <fetchaddr>:
{
    800020ae:	1101                	addi	sp,sp,-32
    800020b0:	ec06                	sd	ra,24(sp)
    800020b2:	e822                	sd	s0,16(sp)
    800020b4:	e426                	sd	s1,8(sp)
    800020b6:	e04a                	sd	s2,0(sp)
    800020b8:	1000                	addi	s0,sp,32
    800020ba:	84aa                	mv	s1,a0
    800020bc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020be:	fffff097          	auipc	ra,0xfffff
    800020c2:	d70080e7          	jalr	-656(ra) # 80000e2e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800020c6:	653c                	ld	a5,72(a0)
    800020c8:	02f4f863          	bgeu	s1,a5,800020f8 <fetchaddr+0x4a>
    800020cc:	00848713          	addi	a4,s1,8
    800020d0:	02e7e663          	bltu	a5,a4,800020fc <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020d4:	46a1                	li	a3,8
    800020d6:	8626                	mv	a2,s1
    800020d8:	85ca                	mv	a1,s2
    800020da:	6928                	ld	a0,80(a0)
    800020dc:	fffff097          	auipc	ra,0xfffff
    800020e0:	aa0080e7          	jalr	-1376(ra) # 80000b7c <copyin>
    800020e4:	00a03533          	snez	a0,a0
    800020e8:	40a00533          	neg	a0,a0
}
    800020ec:	60e2                	ld	ra,24(sp)
    800020ee:	6442                	ld	s0,16(sp)
    800020f0:	64a2                	ld	s1,8(sp)
    800020f2:	6902                	ld	s2,0(sp)
    800020f4:	6105                	addi	sp,sp,32
    800020f6:	8082                	ret
    return -1;
    800020f8:	557d                	li	a0,-1
    800020fa:	bfcd                	j	800020ec <fetchaddr+0x3e>
    800020fc:	557d                	li	a0,-1
    800020fe:	b7fd                	j	800020ec <fetchaddr+0x3e>

0000000080002100 <fetchstr>:
{
    80002100:	7179                	addi	sp,sp,-48
    80002102:	f406                	sd	ra,40(sp)
    80002104:	f022                	sd	s0,32(sp)
    80002106:	ec26                	sd	s1,24(sp)
    80002108:	e84a                	sd	s2,16(sp)
    8000210a:	e44e                	sd	s3,8(sp)
    8000210c:	1800                	addi	s0,sp,48
    8000210e:	892a                	mv	s2,a0
    80002110:	84ae                	mv	s1,a1
    80002112:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002114:	fffff097          	auipc	ra,0xfffff
    80002118:	d1a080e7          	jalr	-742(ra) # 80000e2e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000211c:	86ce                	mv	a3,s3
    8000211e:	864a                	mv	a2,s2
    80002120:	85a6                	mv	a1,s1
    80002122:	6928                	ld	a0,80(a0)
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	ae4080e7          	jalr	-1308(ra) # 80000c08 <copyinstr>
  if(err < 0)
    8000212c:	00054763          	bltz	a0,8000213a <fetchstr+0x3a>
  return strlen(buf);
    80002130:	8526                	mv	a0,s1
    80002132:	ffffe097          	auipc	ra,0xffffe
    80002136:	1ca080e7          	jalr	458(ra) # 800002fc <strlen>
}
    8000213a:	70a2                	ld	ra,40(sp)
    8000213c:	7402                	ld	s0,32(sp)
    8000213e:	64e2                	ld	s1,24(sp)
    80002140:	6942                	ld	s2,16(sp)
    80002142:	69a2                	ld	s3,8(sp)
    80002144:	6145                	addi	sp,sp,48
    80002146:	8082                	ret

0000000080002148 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002148:	1101                	addi	sp,sp,-32
    8000214a:	ec06                	sd	ra,24(sp)
    8000214c:	e822                	sd	s0,16(sp)
    8000214e:	e426                	sd	s1,8(sp)
    80002150:	1000                	addi	s0,sp,32
    80002152:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002154:	00000097          	auipc	ra,0x0
    80002158:	ef2080e7          	jalr	-270(ra) # 80002046 <argraw>
    8000215c:	c088                	sw	a0,0(s1)
  return 0;
}
    8000215e:	4501                	li	a0,0
    80002160:	60e2                	ld	ra,24(sp)
    80002162:	6442                	ld	s0,16(sp)
    80002164:	64a2                	ld	s1,8(sp)
    80002166:	6105                	addi	sp,sp,32
    80002168:	8082                	ret

000000008000216a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000216a:	1101                	addi	sp,sp,-32
    8000216c:	ec06                	sd	ra,24(sp)
    8000216e:	e822                	sd	s0,16(sp)
    80002170:	e426                	sd	s1,8(sp)
    80002172:	1000                	addi	s0,sp,32
    80002174:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002176:	00000097          	auipc	ra,0x0
    8000217a:	ed0080e7          	jalr	-304(ra) # 80002046 <argraw>
    8000217e:	e088                	sd	a0,0(s1)
  return 0;
}
    80002180:	4501                	li	a0,0
    80002182:	60e2                	ld	ra,24(sp)
    80002184:	6442                	ld	s0,16(sp)
    80002186:	64a2                	ld	s1,8(sp)
    80002188:	6105                	addi	sp,sp,32
    8000218a:	8082                	ret

000000008000218c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000218c:	1101                	addi	sp,sp,-32
    8000218e:	ec06                	sd	ra,24(sp)
    80002190:	e822                	sd	s0,16(sp)
    80002192:	e426                	sd	s1,8(sp)
    80002194:	e04a                	sd	s2,0(sp)
    80002196:	1000                	addi	s0,sp,32
    80002198:	84ae                	mv	s1,a1
    8000219a:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000219c:	00000097          	auipc	ra,0x0
    800021a0:	eaa080e7          	jalr	-342(ra) # 80002046 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800021a4:	864a                	mv	a2,s2
    800021a6:	85a6                	mv	a1,s1
    800021a8:	00000097          	auipc	ra,0x0
    800021ac:	f58080e7          	jalr	-168(ra) # 80002100 <fetchstr>
}
    800021b0:	60e2                	ld	ra,24(sp)
    800021b2:	6442                	ld	s0,16(sp)
    800021b4:	64a2                	ld	s1,8(sp)
    800021b6:	6902                	ld	s2,0(sp)
    800021b8:	6105                	addi	sp,sp,32
    800021ba:	8082                	ret

00000000800021bc <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    800021bc:	1101                	addi	sp,sp,-32
    800021be:	ec06                	sd	ra,24(sp)
    800021c0:	e822                	sd	s0,16(sp)
    800021c2:	e426                	sd	s1,8(sp)
    800021c4:	e04a                	sd	s2,0(sp)
    800021c6:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800021c8:	fffff097          	auipc	ra,0xfffff
    800021cc:	c66080e7          	jalr	-922(ra) # 80000e2e <myproc>
    800021d0:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021d2:	05853903          	ld	s2,88(a0)
    800021d6:	0a893783          	ld	a5,168(s2)
    800021da:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021de:	37fd                	addiw	a5,a5,-1
    800021e0:	4759                	li	a4,22
    800021e2:	00f76f63          	bltu	a4,a5,80002200 <syscall+0x44>
    800021e6:	00369713          	slli	a4,a3,0x3
    800021ea:	00006797          	auipc	a5,0x6
    800021ee:	1a678793          	addi	a5,a5,422 # 80008390 <syscalls>
    800021f2:	97ba                	add	a5,a5,a4
    800021f4:	639c                	ld	a5,0(a5)
    800021f6:	c789                	beqz	a5,80002200 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800021f8:	9782                	jalr	a5
    800021fa:	06a93823          	sd	a0,112(s2)
    800021fe:	a839                	j	8000221c <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002200:	15848613          	addi	a2,s1,344
    80002204:	588c                	lw	a1,48(s1)
    80002206:	00006517          	auipc	a0,0x6
    8000220a:	15250513          	addi	a0,a0,338 # 80008358 <states.1789+0x150>
    8000220e:	00004097          	auipc	ra,0x4
    80002212:	e24080e7          	jalr	-476(ra) # 80006032 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002216:	6cbc                	ld	a5,88(s1)
    80002218:	577d                	li	a4,-1
    8000221a:	fbb8                	sd	a4,112(a5)
  }
}
    8000221c:	60e2                	ld	ra,24(sp)
    8000221e:	6442                	ld	s0,16(sp)
    80002220:	64a2                	ld	s1,8(sp)
    80002222:	6902                	ld	s2,0(sp)
    80002224:	6105                	addi	sp,sp,32
    80002226:	8082                	ret

0000000080002228 <sys_exit>:

#define min(a, b) ((a) < (b) ? (a) : (b))

uint64
sys_exit(void)
{
    80002228:	1101                	addi	sp,sp,-32
    8000222a:	ec06                	sd	ra,24(sp)
    8000222c:	e822                	sd	s0,16(sp)
    8000222e:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002230:	fec40593          	addi	a1,s0,-20
    80002234:	4501                	li	a0,0
    80002236:	00000097          	auipc	ra,0x0
    8000223a:	f12080e7          	jalr	-238(ra) # 80002148 <argint>
    return -1;
    8000223e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002240:	00054963          	bltz	a0,80002252 <sys_exit+0x2a>
  exit(n);
    80002244:	fec42503          	lw	a0,-20(s0)
    80002248:	fffff097          	auipc	ra,0xfffff
    8000224c:	5c2080e7          	jalr	1474(ra) # 8000180a <exit>
  return 0;  // not reached
    80002250:	4781                	li	a5,0
}
    80002252:	853e                	mv	a0,a5
    80002254:	60e2                	ld	ra,24(sp)
    80002256:	6442                	ld	s0,16(sp)
    80002258:	6105                	addi	sp,sp,32
    8000225a:	8082                	ret

000000008000225c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000225c:	1141                	addi	sp,sp,-16
    8000225e:	e406                	sd	ra,8(sp)
    80002260:	e022                	sd	s0,0(sp)
    80002262:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002264:	fffff097          	auipc	ra,0xfffff
    80002268:	bca080e7          	jalr	-1078(ra) # 80000e2e <myproc>
}
    8000226c:	5908                	lw	a0,48(a0)
    8000226e:	60a2                	ld	ra,8(sp)
    80002270:	6402                	ld	s0,0(sp)
    80002272:	0141                	addi	sp,sp,16
    80002274:	8082                	ret

0000000080002276 <sys_fork>:

uint64
sys_fork(void)
{
    80002276:	1141                	addi	sp,sp,-16
    80002278:	e406                	sd	ra,8(sp)
    8000227a:	e022                	sd	s0,0(sp)
    8000227c:	0800                	addi	s0,sp,16
  return fork();
    8000227e:	fffff097          	auipc	ra,0xfffff
    80002282:	fd2080e7          	jalr	-46(ra) # 80001250 <fork>
}
    80002286:	60a2                	ld	ra,8(sp)
    80002288:	6402                	ld	s0,0(sp)
    8000228a:	0141                	addi	sp,sp,16
    8000228c:	8082                	ret

000000008000228e <sys_wait>:

uint64
sys_wait(void)
{
    8000228e:	1101                	addi	sp,sp,-32
    80002290:	ec06                	sd	ra,24(sp)
    80002292:	e822                	sd	s0,16(sp)
    80002294:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002296:	fe840593          	addi	a1,s0,-24
    8000229a:	4501                	li	a0,0
    8000229c:	00000097          	auipc	ra,0x0
    800022a0:	ece080e7          	jalr	-306(ra) # 8000216a <argaddr>
    800022a4:	87aa                	mv	a5,a0
    return -1;
    800022a6:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800022a8:	0007c863          	bltz	a5,800022b8 <sys_wait+0x2a>
  return wait(p);
    800022ac:	fe843503          	ld	a0,-24(s0)
    800022b0:	fffff097          	auipc	ra,0xfffff
    800022b4:	362080e7          	jalr	866(ra) # 80001612 <wait>
}
    800022b8:	60e2                	ld	ra,24(sp)
    800022ba:	6442                	ld	s0,16(sp)
    800022bc:	6105                	addi	sp,sp,32
    800022be:	8082                	ret

00000000800022c0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800022c0:	7179                	addi	sp,sp,-48
    800022c2:	f406                	sd	ra,40(sp)
    800022c4:	f022                	sd	s0,32(sp)
    800022c6:	ec26                	sd	s1,24(sp)
    800022c8:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800022ca:	fdc40593          	addi	a1,s0,-36
    800022ce:	4501                	li	a0,0
    800022d0:	00000097          	auipc	ra,0x0
    800022d4:	e78080e7          	jalr	-392(ra) # 80002148 <argint>
    800022d8:	87aa                	mv	a5,a0
    return -1;
    800022da:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800022dc:	0207c063          	bltz	a5,800022fc <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800022e0:	fffff097          	auipc	ra,0xfffff
    800022e4:	b4e080e7          	jalr	-1202(ra) # 80000e2e <myproc>
    800022e8:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800022ea:	fdc42503          	lw	a0,-36(s0)
    800022ee:	fffff097          	auipc	ra,0xfffff
    800022f2:	eee080e7          	jalr	-274(ra) # 800011dc <growproc>
    800022f6:	00054863          	bltz	a0,80002306 <sys_sbrk+0x46>
    return -1;
  return addr;
    800022fa:	8526                	mv	a0,s1
}
    800022fc:	70a2                	ld	ra,40(sp)
    800022fe:	7402                	ld	s0,32(sp)
    80002300:	64e2                	ld	s1,24(sp)
    80002302:	6145                	addi	sp,sp,48
    80002304:	8082                	ret
    return -1;
    80002306:	557d                	li	a0,-1
    80002308:	bfd5                	j	800022fc <sys_sbrk+0x3c>

000000008000230a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000230a:	7139                	addi	sp,sp,-64
    8000230c:	fc06                	sd	ra,56(sp)
    8000230e:	f822                	sd	s0,48(sp)
    80002310:	f426                	sd	s1,40(sp)
    80002312:	f04a                	sd	s2,32(sp)
    80002314:	ec4e                	sd	s3,24(sp)
    80002316:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002318:	fcc40593          	addi	a1,s0,-52
    8000231c:	4501                	li	a0,0
    8000231e:	00000097          	auipc	ra,0x0
    80002322:	e2a080e7          	jalr	-470(ra) # 80002148 <argint>
    return -1;
    80002326:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002328:	06054563          	bltz	a0,80002392 <sys_sleep+0x88>
  acquire(&tickslock);
    8000232c:	00017517          	auipc	a0,0x17
    80002330:	f5450513          	addi	a0,a0,-172 # 80019280 <tickslock>
    80002334:	00004097          	auipc	ra,0x4
    80002338:	1fe080e7          	jalr	510(ra) # 80006532 <acquire>
  ticks0 = ticks;
    8000233c:	00007917          	auipc	s2,0x7
    80002340:	cdc92903          	lw	s2,-804(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002344:	fcc42783          	lw	a5,-52(s0)
    80002348:	cf85                	beqz	a5,80002380 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000234a:	00017997          	auipc	s3,0x17
    8000234e:	f3698993          	addi	s3,s3,-202 # 80019280 <tickslock>
    80002352:	00007497          	auipc	s1,0x7
    80002356:	cc648493          	addi	s1,s1,-826 # 80009018 <ticks>
    if(myproc()->killed){
    8000235a:	fffff097          	auipc	ra,0xfffff
    8000235e:	ad4080e7          	jalr	-1324(ra) # 80000e2e <myproc>
    80002362:	551c                	lw	a5,40(a0)
    80002364:	ef9d                	bnez	a5,800023a2 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002366:	85ce                	mv	a1,s3
    80002368:	8526                	mv	a0,s1
    8000236a:	fffff097          	auipc	ra,0xfffff
    8000236e:	244080e7          	jalr	580(ra) # 800015ae <sleep>
  while(ticks - ticks0 < n){
    80002372:	409c                	lw	a5,0(s1)
    80002374:	412787bb          	subw	a5,a5,s2
    80002378:	fcc42703          	lw	a4,-52(s0)
    8000237c:	fce7efe3          	bltu	a5,a4,8000235a <sys_sleep+0x50>
  }
  release(&tickslock);
    80002380:	00017517          	auipc	a0,0x17
    80002384:	f0050513          	addi	a0,a0,-256 # 80019280 <tickslock>
    80002388:	00004097          	auipc	ra,0x4
    8000238c:	25e080e7          	jalr	606(ra) # 800065e6 <release>
  return 0;
    80002390:	4781                	li	a5,0
}
    80002392:	853e                	mv	a0,a5
    80002394:	70e2                	ld	ra,56(sp)
    80002396:	7442                	ld	s0,48(sp)
    80002398:	74a2                	ld	s1,40(sp)
    8000239a:	7902                	ld	s2,32(sp)
    8000239c:	69e2                	ld	s3,24(sp)
    8000239e:	6121                	addi	sp,sp,64
    800023a0:	8082                	ret
      release(&tickslock);
    800023a2:	00017517          	auipc	a0,0x17
    800023a6:	ede50513          	addi	a0,a0,-290 # 80019280 <tickslock>
    800023aa:	00004097          	auipc	ra,0x4
    800023ae:	23c080e7          	jalr	572(ra) # 800065e6 <release>
      return -1;
    800023b2:	57fd                	li	a5,-1
    800023b4:	bff9                	j	80002392 <sys_sleep+0x88>

00000000800023b6 <sys_kill>:

uint64
sys_kill(void)
{
    800023b6:	1101                	addi	sp,sp,-32
    800023b8:	ec06                	sd	ra,24(sp)
    800023ba:	e822                	sd	s0,16(sp)
    800023bc:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800023be:	fec40593          	addi	a1,s0,-20
    800023c2:	4501                	li	a0,0
    800023c4:	00000097          	auipc	ra,0x0
    800023c8:	d84080e7          	jalr	-636(ra) # 80002148 <argint>
    800023cc:	87aa                	mv	a5,a0
    return -1;
    800023ce:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800023d0:	0007c863          	bltz	a5,800023e0 <sys_kill+0x2a>
  return kill(pid);
    800023d4:	fec42503          	lw	a0,-20(s0)
    800023d8:	fffff097          	auipc	ra,0xfffff
    800023dc:	59e080e7          	jalr	1438(ra) # 80001976 <kill>
}
    800023e0:	60e2                	ld	ra,24(sp)
    800023e2:	6442                	ld	s0,16(sp)
    800023e4:	6105                	addi	sp,sp,32
    800023e6:	8082                	ret

00000000800023e8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800023e8:	1101                	addi	sp,sp,-32
    800023ea:	ec06                	sd	ra,24(sp)
    800023ec:	e822                	sd	s0,16(sp)
    800023ee:	e426                	sd	s1,8(sp)
    800023f0:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800023f2:	00017517          	auipc	a0,0x17
    800023f6:	e8e50513          	addi	a0,a0,-370 # 80019280 <tickslock>
    800023fa:	00004097          	auipc	ra,0x4
    800023fe:	138080e7          	jalr	312(ra) # 80006532 <acquire>
  xticks = ticks;
    80002402:	00007497          	auipc	s1,0x7
    80002406:	c164a483          	lw	s1,-1002(s1) # 80009018 <ticks>
  release(&tickslock);
    8000240a:	00017517          	auipc	a0,0x17
    8000240e:	e7650513          	addi	a0,a0,-394 # 80019280 <tickslock>
    80002412:	00004097          	auipc	ra,0x4
    80002416:	1d4080e7          	jalr	468(ra) # 800065e6 <release>
  return xticks;
}
    8000241a:	02049513          	slli	a0,s1,0x20
    8000241e:	9101                	srli	a0,a0,0x20
    80002420:	60e2                	ld	ra,24(sp)
    80002422:	6442                	ld	s0,16(sp)
    80002424:	64a2                	ld	s1,8(sp)
    80002426:	6105                	addi	sp,sp,32
    80002428:	8082                	ret

000000008000242a <sys_mmap>:

uint64
sys_mmap(void){
    8000242a:	7139                	addi	sp,sp,-64
    8000242c:	fc06                	sd	ra,56(sp)
    8000242e:	f822                	sd	s0,48(sp)
    80002430:	f426                	sd	s1,40(sp)
    80002432:	0080                	addi	s0,sp,64
    int length, prot,flags,fd,offset;
    if(argint(1, &length) < 0 || argint(2, &prot) < 0 || argint(3, &flags) < 0 || argint(4, &fd) < 0 || argint(5, &offset) < 0){
    80002434:	fdc40593          	addi	a1,s0,-36
    80002438:	4505                	li	a0,1
    8000243a:	00000097          	auipc	ra,0x0
    8000243e:	d0e080e7          	jalr	-754(ra) # 80002148 <argint>
        return -1;
    80002442:	57fd                	li	a5,-1
    if(argint(1, &length) < 0 || argint(2, &prot) < 0 || argint(3, &flags) < 0 || argint(4, &fd) < 0 || argint(5, &offset) < 0){
    80002444:	10054363          	bltz	a0,8000254a <sys_mmap+0x120>
    80002448:	fd840593          	addi	a1,s0,-40
    8000244c:	4509                	li	a0,2
    8000244e:	00000097          	auipc	ra,0x0
    80002452:	cfa080e7          	jalr	-774(ra) # 80002148 <argint>
        return -1;
    80002456:	57fd                	li	a5,-1
    if(argint(1, &length) < 0 || argint(2, &prot) < 0 || argint(3, &flags) < 0 || argint(4, &fd) < 0 || argint(5, &offset) < 0){
    80002458:	0e054963          	bltz	a0,8000254a <sys_mmap+0x120>
    8000245c:	fd440593          	addi	a1,s0,-44
    80002460:	450d                	li	a0,3
    80002462:	00000097          	auipc	ra,0x0
    80002466:	ce6080e7          	jalr	-794(ra) # 80002148 <argint>
        return -1;
    8000246a:	57fd                	li	a5,-1
    if(argint(1, &length) < 0 || argint(2, &prot) < 0 || argint(3, &flags) < 0 || argint(4, &fd) < 0 || argint(5, &offset) < 0){
    8000246c:	0c054f63          	bltz	a0,8000254a <sys_mmap+0x120>
    80002470:	fd040593          	addi	a1,s0,-48
    80002474:	4511                	li	a0,4
    80002476:	00000097          	auipc	ra,0x0
    8000247a:	cd2080e7          	jalr	-814(ra) # 80002148 <argint>
        return -1;
    8000247e:	57fd                	li	a5,-1
    if(argint(1, &length) < 0 || argint(2, &prot) < 0 || argint(3, &flags) < 0 || argint(4, &fd) < 0 || argint(5, &offset) < 0){
    80002480:	0c054563          	bltz	a0,8000254a <sys_mmap+0x120>
    80002484:	fcc40593          	addi	a1,s0,-52
    80002488:	4515                	li	a0,5
    8000248a:	00000097          	auipc	ra,0x0
    8000248e:	cbe080e7          	jalr	-834(ra) # 80002148 <argint>
        return -1;
    80002492:	57fd                	li	a5,-1
    if(argint(1, &length) < 0 || argint(2, &prot) < 0 || argint(3, &flags) < 0 || argint(4, &fd) < 0 || argint(5, &offset) < 0){
    80002494:	0a054b63          	bltz	a0,8000254a <sys_mmap+0x120>
    }
    struct proc* p = myproc();
    80002498:	fffff097          	auipc	ra,0xfffff
    8000249c:	996080e7          	jalr	-1642(ra) # 80000e2e <myproc>
    800024a0:	84aa                	mv	s1,a0
    if(p->mmap_addr - p->sz < p->sz)
    800024a2:	6538                	ld	a4,72(a0)
    800024a4:	3e853683          	ld	a3,1000(a0)
    800024a8:	8e99                	sub	a3,a3,a4
        return -1;
    800024aa:	57fd                	li	a5,-1
    if(p->mmap_addr - p->sz < p->sz)
    800024ac:	08e6ef63          	bltu	a3,a4,8000254a <sys_mmap+0x120>
    if(flags & MAP_SHARED){
    800024b0:	fd442583          	lw	a1,-44(s0)
    800024b4:	0015f793          	andi	a5,a1,1
    800024b8:	cf85                	beqz	a5,800024f0 <sys_mmap+0xc6>
        if((prot & PROT_READ) && !p->ofile[fd]->readable)
    800024ba:	fd842703          	lw	a4,-40(s0)
    800024be:	00177793          	andi	a5,a4,1
    800024c2:	cb99                	beqz	a5,800024d8 <sys_mmap+0xae>
    800024c4:	fd042783          	lw	a5,-48(s0)
    800024c8:	07e9                	addi	a5,a5,26
    800024ca:	078e                	slli	a5,a5,0x3
    800024cc:	97aa                	add	a5,a5,a0
    800024ce:	639c                	ld	a5,0(a5)
    800024d0:	0087c603          	lbu	a2,8(a5)
            return -1;
    800024d4:	57fd                	li	a5,-1
        if((prot & PROT_READ) && !p->ofile[fd]->readable)
    800024d6:	ca35                	beqz	a2,8000254a <sys_mmap+0x120>
        if((prot & PROT_WRITE) && !p->ofile[fd]->writable)
    800024d8:	8b09                	andi	a4,a4,2
    800024da:	cb19                	beqz	a4,800024f0 <sys_mmap+0xc6>
    800024dc:	fd042783          	lw	a5,-48(s0)
    800024e0:	07e9                	addi	a5,a5,26
    800024e2:	078e                	slli	a5,a5,0x3
    800024e4:	97a6                	add	a5,a5,s1
    800024e6:	639c                	ld	a5,0(a5)
    800024e8:	0097c703          	lbu	a4,9(a5)
            return -1;
    800024ec:	57fd                	li	a5,-1
        if((prot & PROT_WRITE) && !p->ofile[fd]->writable)
    800024ee:	cf31                	beqz	a4,8000254a <sys_mmap+0x120>
    }
    p->vma[p->vma_size].sz = length;
    800024f0:	3f04c603          	lbu	a2,1008(s1)
    800024f4:	00261713          	slli	a4,a2,0x2
    800024f8:	00e607b3          	add	a5,a2,a4
    800024fc:	078e                	slli	a5,a5,0x3
    800024fe:	97a6                	add	a5,a5,s1
    80002500:	fdc42503          	lw	a0,-36(s0)
    80002504:	16a7b823          	sd	a0,368(a5)
    p->vma[p->vma_size].prot = prot;
    80002508:	fd842503          	lw	a0,-40(s0)
    8000250c:	16a78c23          	sb	a0,376(a5)
    p->vma[p->vma_size].flags = flags;
    80002510:	16b78ca3          	sb	a1,377(a5)
    p->vma[p->vma_size].addr = p->mmap_addr - p->sz;
    80002514:	16d7b423          	sd	a3,360(a5)
    p->vma[p->vma_size].file = p->ofile[fd];
    80002518:	fd042683          	lw	a3,-48(s0)
    8000251c:	06e9                	addi	a3,a3,26
    8000251e:	068e                	slli	a3,a3,0x3
    80002520:	96a6                	add	a3,a3,s1
    80002522:	6288                	ld	a0,0(a3)
    80002524:	18a7b023          	sd	a0,384(a5)
    p->vma[p->vma_size].offset = offset;
    80002528:	fcc42683          	lw	a3,-52(s0)
    8000252c:	18d7a423          	sw	a3,392(a5)
    p->mmap_addr = p->vma[p->vma_size].addr;
    80002530:	1687b783          	ld	a5,360(a5)
    80002534:	3ef4b423          	sd	a5,1000(s1)
    p->vma_size++;
    80002538:	2605                	addiw	a2,a2,1
    8000253a:	3ec48823          	sb	a2,1008(s1)
    filedup(p->ofile[fd]);
    8000253e:	00002097          	auipc	ra,0x2
    80002542:	844080e7          	jalr	-1980(ra) # 80003d82 <filedup>
    return p->mmap_addr;
    80002546:	3e84b783          	ld	a5,1000(s1)
}
    8000254a:	853e                	mv	a0,a5
    8000254c:	70e2                	ld	ra,56(sp)
    8000254e:	7442                	ld	s0,48(sp)
    80002550:	74a2                	ld	s1,40(sp)
    80002552:	6121                	addi	sp,sp,64
    80002554:	8082                	ret

0000000080002556 <sys_munmap>:

uint64
sys_munmap(void){
    80002556:	715d                	addi	sp,sp,-80
    80002558:	e486                	sd	ra,72(sp)
    8000255a:	e0a2                	sd	s0,64(sp)
    8000255c:	fc26                	sd	s1,56(sp)
    8000255e:	f84a                	sd	s2,48(sp)
    80002560:	f44e                	sd	s3,40(sp)
    80002562:	f052                	sd	s4,32(sp)
    80002564:	ec56                	sd	s5,24(sp)
    80002566:	0880                	addi	s0,sp,80
    uint64 addr;
    int length;
    if(argaddr(0, &addr) < 0 || argint(1, &length) < 0)
    80002568:	fb840593          	addi	a1,s0,-72
    8000256c:	4501                	li	a0,0
    8000256e:	00000097          	auipc	ra,0x0
    80002572:	bfc080e7          	jalr	-1028(ra) # 8000216a <argaddr>
        return -1;
    80002576:	57fd                	li	a5,-1
    if(argaddr(0, &addr) < 0 || argint(1, &length) < 0)
    80002578:	10054963          	bltz	a0,8000268a <sys_munmap+0x134>
    8000257c:	fb440593          	addi	a1,s0,-76
    80002580:	4505                	li	a0,1
    80002582:	00000097          	auipc	ra,0x0
    80002586:	bc6080e7          	jalr	-1082(ra) # 80002148 <argint>
        return -1;
    8000258a:	57fd                	li	a5,-1
    if(argaddr(0, &addr) < 0 || argint(1, &length) < 0)
    8000258c:	0e054f63          	bltz	a0,8000268a <sys_munmap+0x134>
    struct proc* p = myproc();
    80002590:	fffff097          	auipc	ra,0xfffff
    80002594:	89e080e7          	jalr	-1890(ra) # 80000e2e <myproc>
    80002598:	8aaa                	mv	s5,a0
    for(int i = 0; i < p->vma_size; i++){
    8000259a:	3f054783          	lbu	a5,1008(a0)
    8000259e:	10078063          	beqz	a5,8000269e <sys_munmap+0x148>
    800025a2:	16850493          	addi	s1,a0,360
    800025a6:	4981                	li	s3,0
    800025a8:	a0bd                	j	80002616 <sys_munmap+0xc0>
        if(p->vma[i].addr == addr){
            uint64 unmapsz = min(p->vma[i].sz,length);
            if(p->vma[i].flags & MAP_SHARED){
    800025aa:	01194783          	lbu	a5,17(s2)
    800025ae:	8b85                	andi	a5,a5,1
    800025b0:	e3c1                	bnez	a5,80002630 <sys_munmap+0xda>
                ilock(p->vma[i].file->ip);
                writei(p->vma[i].file->ip, 1, addr, p->vma[i].offset, unmapsz);
                iunlock(p->vma[i].file->ip);
                end_op();
            }
            uvmunmap(p->pagetable,addr,unmapsz/PGSIZE,1);
    800025b2:	4685                	li	a3,1
    800025b4:	00ca5613          	srli	a2,s4,0xc
    800025b8:	fb843583          	ld	a1,-72(s0)
    800025bc:	050ab503          	ld	a0,80(s5)
    800025c0:	ffffe097          	auipc	ra,0xffffe
    800025c4:	14e080e7          	jalr	334(ra) # 8000070e <uvmunmap>
            length -= unmapsz;
    800025c8:	fb442783          	lw	a5,-76(s0)
    800025cc:	414787bb          	subw	a5,a5,s4
    800025d0:	faf42a23          	sw	a5,-76(s0)
            addr += unmapsz;
    800025d4:	fb843783          	ld	a5,-72(s0)
    800025d8:	97d2                	add	a5,a5,s4
    800025da:	faf43c23          	sd	a5,-72(s0)
            p->vma[i].offset += unmapsz;
    800025de:	02092783          	lw	a5,32(s2)
    800025e2:	014787bb          	addw	a5,a5,s4
    800025e6:	02f92023          	sw	a5,32(s2)
            p->vma[i].sz -= unmapsz;
    800025ea:	00893783          	ld	a5,8(s2)
    800025ee:	414787b3          	sub	a5,a5,s4
    800025f2:	00f93423          	sd	a5,8(s2)
            p->vma[i].addr += unmapsz;
    800025f6:	00093703          	ld	a4,0(s2)
    800025fa:	9a3a                	add	s4,s4,a4
    800025fc:	01493023          	sd	s4,0(s2)
            if(p->vma[i].sz == 0)
    80002600:	cfad                	beqz	a5,8000267a <sys_munmap+0x124>
                fileclose(p->vma[i].file);
            if(length == 0)
    80002602:	fb442783          	lw	a5,-76(s0)
    80002606:	cfd1                	beqz	a5,800026a2 <sys_munmap+0x14c>
    for(int i = 0; i < p->vma_size; i++){
    80002608:	2985                	addiw	s3,s3,1
    8000260a:	02848493          	addi	s1,s1,40
    8000260e:	3f0ac783          	lbu	a5,1008(s5)
    80002612:	06f9db63          	bge	s3,a5,80002688 <sys_munmap+0x132>
        if(p->vma[i].addr == addr){
    80002616:	8926                	mv	s2,s1
    80002618:	6098                	ld	a4,0(s1)
    8000261a:	fb843783          	ld	a5,-72(s0)
    8000261e:	fef715e3          	bne	a4,a5,80002608 <sys_munmap+0xb2>
            uint64 unmapsz = min(p->vma[i].sz,length);
    80002622:	649c                	ld	a5,8(s1)
    80002624:	fb442a03          	lw	s4,-76(s0)
    80002628:	f947f1e3          	bgeu	a5,s4,800025aa <sys_munmap+0x54>
    8000262c:	8a3e                	mv	s4,a5
    8000262e:	bfb5                	j	800025aa <sys_munmap+0x54>
                begin_op();
    80002630:	00001097          	auipc	ra,0x1
    80002634:	2d8080e7          	jalr	728(ra) # 80003908 <begin_op>
                ilock(p->vma[i].file->ip);
    80002638:	01893783          	ld	a5,24(s2)
    8000263c:	6f88                	ld	a0,24(a5)
    8000263e:	00001097          	auipc	ra,0x1
    80002642:	8f8080e7          	jalr	-1800(ra) # 80002f36 <ilock>
                writei(p->vma[i].file->ip, 1, addr, p->vma[i].offset, unmapsz);
    80002646:	01893783          	ld	a5,24(s2)
    8000264a:	000a071b          	sext.w	a4,s4
    8000264e:	02092683          	lw	a3,32(s2)
    80002652:	fb843603          	ld	a2,-72(s0)
    80002656:	4585                	li	a1,1
    80002658:	6f88                	ld	a0,24(a5)
    8000265a:	00001097          	auipc	ra,0x1
    8000265e:	c88080e7          	jalr	-888(ra) # 800032e2 <writei>
                iunlock(p->vma[i].file->ip);
    80002662:	01893783          	ld	a5,24(s2)
    80002666:	6f88                	ld	a0,24(a5)
    80002668:	00001097          	auipc	ra,0x1
    8000266c:	990080e7          	jalr	-1648(ra) # 80002ff8 <iunlock>
                end_op();
    80002670:	00001097          	auipc	ra,0x1
    80002674:	318080e7          	jalr	792(ra) # 80003988 <end_op>
    80002678:	bf2d                	j	800025b2 <sys_munmap+0x5c>
                fileclose(p->vma[i].file);
    8000267a:	01893503          	ld	a0,24(s2)
    8000267e:	00001097          	auipc	ra,0x1
    80002682:	756080e7          	jalr	1878(ra) # 80003dd4 <fileclose>
    80002686:	bfb5                	j	80002602 <sys_munmap+0xac>
                break;
        }
    }
    return 0;
    80002688:	4781                	li	a5,0
}
    8000268a:	853e                	mv	a0,a5
    8000268c:	60a6                	ld	ra,72(sp)
    8000268e:	6406                	ld	s0,64(sp)
    80002690:	74e2                	ld	s1,56(sp)
    80002692:	7942                	ld	s2,48(sp)
    80002694:	79a2                	ld	s3,40(sp)
    80002696:	7a02                	ld	s4,32(sp)
    80002698:	6ae2                	ld	s5,24(sp)
    8000269a:	6161                	addi	sp,sp,80
    8000269c:	8082                	ret
    return 0;
    8000269e:	4781                	li	a5,0
    800026a0:	b7ed                	j	8000268a <sys_munmap+0x134>
    800026a2:	4781                	li	a5,0
    800026a4:	b7dd                	j	8000268a <sys_munmap+0x134>

00000000800026a6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800026a6:	7179                	addi	sp,sp,-48
    800026a8:	f406                	sd	ra,40(sp)
    800026aa:	f022                	sd	s0,32(sp)
    800026ac:	ec26                	sd	s1,24(sp)
    800026ae:	e84a                	sd	s2,16(sp)
    800026b0:	e44e                	sd	s3,8(sp)
    800026b2:	e052                	sd	s4,0(sp)
    800026b4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800026b6:	00006597          	auipc	a1,0x6
    800026ba:	d9a58593          	addi	a1,a1,-614 # 80008450 <syscalls+0xc0>
    800026be:	00017517          	auipc	a0,0x17
    800026c2:	bda50513          	addi	a0,a0,-1062 # 80019298 <bcache>
    800026c6:	00004097          	auipc	ra,0x4
    800026ca:	ddc080e7          	jalr	-548(ra) # 800064a2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800026ce:	0001f797          	auipc	a5,0x1f
    800026d2:	bca78793          	addi	a5,a5,-1078 # 80021298 <bcache+0x8000>
    800026d6:	0001f717          	auipc	a4,0x1f
    800026da:	e2a70713          	addi	a4,a4,-470 # 80021500 <bcache+0x8268>
    800026de:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800026e2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800026e6:	00017497          	auipc	s1,0x17
    800026ea:	bca48493          	addi	s1,s1,-1078 # 800192b0 <bcache+0x18>
    b->next = bcache.head.next;
    800026ee:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800026f0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800026f2:	00006a17          	auipc	s4,0x6
    800026f6:	d66a0a13          	addi	s4,s4,-666 # 80008458 <syscalls+0xc8>
    b->next = bcache.head.next;
    800026fa:	2b893783          	ld	a5,696(s2)
    800026fe:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002700:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002704:	85d2                	mv	a1,s4
    80002706:	01048513          	addi	a0,s1,16
    8000270a:	00001097          	auipc	ra,0x1
    8000270e:	4bc080e7          	jalr	1212(ra) # 80003bc6 <initsleeplock>
    bcache.head.next->prev = b;
    80002712:	2b893783          	ld	a5,696(s2)
    80002716:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002718:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000271c:	45848493          	addi	s1,s1,1112
    80002720:	fd349de3          	bne	s1,s3,800026fa <binit+0x54>
  }
}
    80002724:	70a2                	ld	ra,40(sp)
    80002726:	7402                	ld	s0,32(sp)
    80002728:	64e2                	ld	s1,24(sp)
    8000272a:	6942                	ld	s2,16(sp)
    8000272c:	69a2                	ld	s3,8(sp)
    8000272e:	6a02                	ld	s4,0(sp)
    80002730:	6145                	addi	sp,sp,48
    80002732:	8082                	ret

0000000080002734 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002734:	7179                	addi	sp,sp,-48
    80002736:	f406                	sd	ra,40(sp)
    80002738:	f022                	sd	s0,32(sp)
    8000273a:	ec26                	sd	s1,24(sp)
    8000273c:	e84a                	sd	s2,16(sp)
    8000273e:	e44e                	sd	s3,8(sp)
    80002740:	1800                	addi	s0,sp,48
    80002742:	89aa                	mv	s3,a0
    80002744:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002746:	00017517          	auipc	a0,0x17
    8000274a:	b5250513          	addi	a0,a0,-1198 # 80019298 <bcache>
    8000274e:	00004097          	auipc	ra,0x4
    80002752:	de4080e7          	jalr	-540(ra) # 80006532 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002756:	0001f497          	auipc	s1,0x1f
    8000275a:	dfa4b483          	ld	s1,-518(s1) # 80021550 <bcache+0x82b8>
    8000275e:	0001f797          	auipc	a5,0x1f
    80002762:	da278793          	addi	a5,a5,-606 # 80021500 <bcache+0x8268>
    80002766:	02f48f63          	beq	s1,a5,800027a4 <bread+0x70>
    8000276a:	873e                	mv	a4,a5
    8000276c:	a021                	j	80002774 <bread+0x40>
    8000276e:	68a4                	ld	s1,80(s1)
    80002770:	02e48a63          	beq	s1,a4,800027a4 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002774:	449c                	lw	a5,8(s1)
    80002776:	ff379ce3          	bne	a5,s3,8000276e <bread+0x3a>
    8000277a:	44dc                	lw	a5,12(s1)
    8000277c:	ff2799e3          	bne	a5,s2,8000276e <bread+0x3a>
      b->refcnt++;
    80002780:	40bc                	lw	a5,64(s1)
    80002782:	2785                	addiw	a5,a5,1
    80002784:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002786:	00017517          	auipc	a0,0x17
    8000278a:	b1250513          	addi	a0,a0,-1262 # 80019298 <bcache>
    8000278e:	00004097          	auipc	ra,0x4
    80002792:	e58080e7          	jalr	-424(ra) # 800065e6 <release>
      acquiresleep(&b->lock);
    80002796:	01048513          	addi	a0,s1,16
    8000279a:	00001097          	auipc	ra,0x1
    8000279e:	466080e7          	jalr	1126(ra) # 80003c00 <acquiresleep>
      return b;
    800027a2:	a8b9                	j	80002800 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800027a4:	0001f497          	auipc	s1,0x1f
    800027a8:	da44b483          	ld	s1,-604(s1) # 80021548 <bcache+0x82b0>
    800027ac:	0001f797          	auipc	a5,0x1f
    800027b0:	d5478793          	addi	a5,a5,-684 # 80021500 <bcache+0x8268>
    800027b4:	00f48863          	beq	s1,a5,800027c4 <bread+0x90>
    800027b8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800027ba:	40bc                	lw	a5,64(s1)
    800027bc:	cf81                	beqz	a5,800027d4 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800027be:	64a4                	ld	s1,72(s1)
    800027c0:	fee49de3          	bne	s1,a4,800027ba <bread+0x86>
  panic("bget: no buffers");
    800027c4:	00006517          	auipc	a0,0x6
    800027c8:	c9c50513          	addi	a0,a0,-868 # 80008460 <syscalls+0xd0>
    800027cc:	00004097          	auipc	ra,0x4
    800027d0:	81c080e7          	jalr	-2020(ra) # 80005fe8 <panic>
      b->dev = dev;
    800027d4:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800027d8:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800027dc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800027e0:	4785                	li	a5,1
    800027e2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800027e4:	00017517          	auipc	a0,0x17
    800027e8:	ab450513          	addi	a0,a0,-1356 # 80019298 <bcache>
    800027ec:	00004097          	auipc	ra,0x4
    800027f0:	dfa080e7          	jalr	-518(ra) # 800065e6 <release>
      acquiresleep(&b->lock);
    800027f4:	01048513          	addi	a0,s1,16
    800027f8:	00001097          	auipc	ra,0x1
    800027fc:	408080e7          	jalr	1032(ra) # 80003c00 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002800:	409c                	lw	a5,0(s1)
    80002802:	cb89                	beqz	a5,80002814 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002804:	8526                	mv	a0,s1
    80002806:	70a2                	ld	ra,40(sp)
    80002808:	7402                	ld	s0,32(sp)
    8000280a:	64e2                	ld	s1,24(sp)
    8000280c:	6942                	ld	s2,16(sp)
    8000280e:	69a2                	ld	s3,8(sp)
    80002810:	6145                	addi	sp,sp,48
    80002812:	8082                	ret
    virtio_disk_rw(b, 0);
    80002814:	4581                	li	a1,0
    80002816:	8526                	mv	a0,s1
    80002818:	00003097          	auipc	ra,0x3
    8000281c:	f0e080e7          	jalr	-242(ra) # 80005726 <virtio_disk_rw>
    b->valid = 1;
    80002820:	4785                	li	a5,1
    80002822:	c09c                	sw	a5,0(s1)
  return b;
    80002824:	b7c5                	j	80002804 <bread+0xd0>

0000000080002826 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002826:	1101                	addi	sp,sp,-32
    80002828:	ec06                	sd	ra,24(sp)
    8000282a:	e822                	sd	s0,16(sp)
    8000282c:	e426                	sd	s1,8(sp)
    8000282e:	1000                	addi	s0,sp,32
    80002830:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002832:	0541                	addi	a0,a0,16
    80002834:	00001097          	auipc	ra,0x1
    80002838:	466080e7          	jalr	1126(ra) # 80003c9a <holdingsleep>
    8000283c:	cd01                	beqz	a0,80002854 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000283e:	4585                	li	a1,1
    80002840:	8526                	mv	a0,s1
    80002842:	00003097          	auipc	ra,0x3
    80002846:	ee4080e7          	jalr	-284(ra) # 80005726 <virtio_disk_rw>
}
    8000284a:	60e2                	ld	ra,24(sp)
    8000284c:	6442                	ld	s0,16(sp)
    8000284e:	64a2                	ld	s1,8(sp)
    80002850:	6105                	addi	sp,sp,32
    80002852:	8082                	ret
    panic("bwrite");
    80002854:	00006517          	auipc	a0,0x6
    80002858:	c2450513          	addi	a0,a0,-988 # 80008478 <syscalls+0xe8>
    8000285c:	00003097          	auipc	ra,0x3
    80002860:	78c080e7          	jalr	1932(ra) # 80005fe8 <panic>

0000000080002864 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002864:	1101                	addi	sp,sp,-32
    80002866:	ec06                	sd	ra,24(sp)
    80002868:	e822                	sd	s0,16(sp)
    8000286a:	e426                	sd	s1,8(sp)
    8000286c:	e04a                	sd	s2,0(sp)
    8000286e:	1000                	addi	s0,sp,32
    80002870:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002872:	01050913          	addi	s2,a0,16
    80002876:	854a                	mv	a0,s2
    80002878:	00001097          	auipc	ra,0x1
    8000287c:	422080e7          	jalr	1058(ra) # 80003c9a <holdingsleep>
    80002880:	c92d                	beqz	a0,800028f2 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002882:	854a                	mv	a0,s2
    80002884:	00001097          	auipc	ra,0x1
    80002888:	3d2080e7          	jalr	978(ra) # 80003c56 <releasesleep>

  acquire(&bcache.lock);
    8000288c:	00017517          	auipc	a0,0x17
    80002890:	a0c50513          	addi	a0,a0,-1524 # 80019298 <bcache>
    80002894:	00004097          	auipc	ra,0x4
    80002898:	c9e080e7          	jalr	-866(ra) # 80006532 <acquire>
  b->refcnt--;
    8000289c:	40bc                	lw	a5,64(s1)
    8000289e:	37fd                	addiw	a5,a5,-1
    800028a0:	0007871b          	sext.w	a4,a5
    800028a4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800028a6:	eb05                	bnez	a4,800028d6 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800028a8:	68bc                	ld	a5,80(s1)
    800028aa:	64b8                	ld	a4,72(s1)
    800028ac:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800028ae:	64bc                	ld	a5,72(s1)
    800028b0:	68b8                	ld	a4,80(s1)
    800028b2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800028b4:	0001f797          	auipc	a5,0x1f
    800028b8:	9e478793          	addi	a5,a5,-1564 # 80021298 <bcache+0x8000>
    800028bc:	2b87b703          	ld	a4,696(a5)
    800028c0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800028c2:	0001f717          	auipc	a4,0x1f
    800028c6:	c3e70713          	addi	a4,a4,-962 # 80021500 <bcache+0x8268>
    800028ca:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800028cc:	2b87b703          	ld	a4,696(a5)
    800028d0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800028d2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800028d6:	00017517          	auipc	a0,0x17
    800028da:	9c250513          	addi	a0,a0,-1598 # 80019298 <bcache>
    800028de:	00004097          	auipc	ra,0x4
    800028e2:	d08080e7          	jalr	-760(ra) # 800065e6 <release>
}
    800028e6:	60e2                	ld	ra,24(sp)
    800028e8:	6442                	ld	s0,16(sp)
    800028ea:	64a2                	ld	s1,8(sp)
    800028ec:	6902                	ld	s2,0(sp)
    800028ee:	6105                	addi	sp,sp,32
    800028f0:	8082                	ret
    panic("brelse");
    800028f2:	00006517          	auipc	a0,0x6
    800028f6:	b8e50513          	addi	a0,a0,-1138 # 80008480 <syscalls+0xf0>
    800028fa:	00003097          	auipc	ra,0x3
    800028fe:	6ee080e7          	jalr	1774(ra) # 80005fe8 <panic>

0000000080002902 <bpin>:

void
bpin(struct buf *b) {
    80002902:	1101                	addi	sp,sp,-32
    80002904:	ec06                	sd	ra,24(sp)
    80002906:	e822                	sd	s0,16(sp)
    80002908:	e426                	sd	s1,8(sp)
    8000290a:	1000                	addi	s0,sp,32
    8000290c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000290e:	00017517          	auipc	a0,0x17
    80002912:	98a50513          	addi	a0,a0,-1654 # 80019298 <bcache>
    80002916:	00004097          	auipc	ra,0x4
    8000291a:	c1c080e7          	jalr	-996(ra) # 80006532 <acquire>
  b->refcnt++;
    8000291e:	40bc                	lw	a5,64(s1)
    80002920:	2785                	addiw	a5,a5,1
    80002922:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002924:	00017517          	auipc	a0,0x17
    80002928:	97450513          	addi	a0,a0,-1676 # 80019298 <bcache>
    8000292c:	00004097          	auipc	ra,0x4
    80002930:	cba080e7          	jalr	-838(ra) # 800065e6 <release>
}
    80002934:	60e2                	ld	ra,24(sp)
    80002936:	6442                	ld	s0,16(sp)
    80002938:	64a2                	ld	s1,8(sp)
    8000293a:	6105                	addi	sp,sp,32
    8000293c:	8082                	ret

000000008000293e <bunpin>:

void
bunpin(struct buf *b) {
    8000293e:	1101                	addi	sp,sp,-32
    80002940:	ec06                	sd	ra,24(sp)
    80002942:	e822                	sd	s0,16(sp)
    80002944:	e426                	sd	s1,8(sp)
    80002946:	1000                	addi	s0,sp,32
    80002948:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000294a:	00017517          	auipc	a0,0x17
    8000294e:	94e50513          	addi	a0,a0,-1714 # 80019298 <bcache>
    80002952:	00004097          	auipc	ra,0x4
    80002956:	be0080e7          	jalr	-1056(ra) # 80006532 <acquire>
  b->refcnt--;
    8000295a:	40bc                	lw	a5,64(s1)
    8000295c:	37fd                	addiw	a5,a5,-1
    8000295e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002960:	00017517          	auipc	a0,0x17
    80002964:	93850513          	addi	a0,a0,-1736 # 80019298 <bcache>
    80002968:	00004097          	auipc	ra,0x4
    8000296c:	c7e080e7          	jalr	-898(ra) # 800065e6 <release>
}
    80002970:	60e2                	ld	ra,24(sp)
    80002972:	6442                	ld	s0,16(sp)
    80002974:	64a2                	ld	s1,8(sp)
    80002976:	6105                	addi	sp,sp,32
    80002978:	8082                	ret

000000008000297a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000297a:	1101                	addi	sp,sp,-32
    8000297c:	ec06                	sd	ra,24(sp)
    8000297e:	e822                	sd	s0,16(sp)
    80002980:	e426                	sd	s1,8(sp)
    80002982:	e04a                	sd	s2,0(sp)
    80002984:	1000                	addi	s0,sp,32
    80002986:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002988:	00d5d59b          	srliw	a1,a1,0xd
    8000298c:	0001f797          	auipc	a5,0x1f
    80002990:	fe87a783          	lw	a5,-24(a5) # 80021974 <sb+0x1c>
    80002994:	9dbd                	addw	a1,a1,a5
    80002996:	00000097          	auipc	ra,0x0
    8000299a:	d9e080e7          	jalr	-610(ra) # 80002734 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000299e:	0074f713          	andi	a4,s1,7
    800029a2:	4785                	li	a5,1
    800029a4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800029a8:	14ce                	slli	s1,s1,0x33
    800029aa:	90d9                	srli	s1,s1,0x36
    800029ac:	00950733          	add	a4,a0,s1
    800029b0:	05874703          	lbu	a4,88(a4)
    800029b4:	00e7f6b3          	and	a3,a5,a4
    800029b8:	c69d                	beqz	a3,800029e6 <bfree+0x6c>
    800029ba:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800029bc:	94aa                	add	s1,s1,a0
    800029be:	fff7c793          	not	a5,a5
    800029c2:	8ff9                	and	a5,a5,a4
    800029c4:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800029c8:	00001097          	auipc	ra,0x1
    800029cc:	118080e7          	jalr	280(ra) # 80003ae0 <log_write>
  brelse(bp);
    800029d0:	854a                	mv	a0,s2
    800029d2:	00000097          	auipc	ra,0x0
    800029d6:	e92080e7          	jalr	-366(ra) # 80002864 <brelse>
}
    800029da:	60e2                	ld	ra,24(sp)
    800029dc:	6442                	ld	s0,16(sp)
    800029de:	64a2                	ld	s1,8(sp)
    800029e0:	6902                	ld	s2,0(sp)
    800029e2:	6105                	addi	sp,sp,32
    800029e4:	8082                	ret
    panic("freeing free block");
    800029e6:	00006517          	auipc	a0,0x6
    800029ea:	aa250513          	addi	a0,a0,-1374 # 80008488 <syscalls+0xf8>
    800029ee:	00003097          	auipc	ra,0x3
    800029f2:	5fa080e7          	jalr	1530(ra) # 80005fe8 <panic>

00000000800029f6 <balloc>:
{
    800029f6:	711d                	addi	sp,sp,-96
    800029f8:	ec86                	sd	ra,88(sp)
    800029fa:	e8a2                	sd	s0,80(sp)
    800029fc:	e4a6                	sd	s1,72(sp)
    800029fe:	e0ca                	sd	s2,64(sp)
    80002a00:	fc4e                	sd	s3,56(sp)
    80002a02:	f852                	sd	s4,48(sp)
    80002a04:	f456                	sd	s5,40(sp)
    80002a06:	f05a                	sd	s6,32(sp)
    80002a08:	ec5e                	sd	s7,24(sp)
    80002a0a:	e862                	sd	s8,16(sp)
    80002a0c:	e466                	sd	s9,8(sp)
    80002a0e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002a10:	0001f797          	auipc	a5,0x1f
    80002a14:	f4c7a783          	lw	a5,-180(a5) # 8002195c <sb+0x4>
    80002a18:	cbd1                	beqz	a5,80002aac <balloc+0xb6>
    80002a1a:	8baa                	mv	s7,a0
    80002a1c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002a1e:	0001fb17          	auipc	s6,0x1f
    80002a22:	f3ab0b13          	addi	s6,s6,-198 # 80021958 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002a26:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002a28:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002a2a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002a2c:	6c89                	lui	s9,0x2
    80002a2e:	a831                	j	80002a4a <balloc+0x54>
    brelse(bp);
    80002a30:	854a                	mv	a0,s2
    80002a32:	00000097          	auipc	ra,0x0
    80002a36:	e32080e7          	jalr	-462(ra) # 80002864 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002a3a:	015c87bb          	addw	a5,s9,s5
    80002a3e:	00078a9b          	sext.w	s5,a5
    80002a42:	004b2703          	lw	a4,4(s6)
    80002a46:	06eaf363          	bgeu	s5,a4,80002aac <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002a4a:	41fad79b          	sraiw	a5,s5,0x1f
    80002a4e:	0137d79b          	srliw	a5,a5,0x13
    80002a52:	015787bb          	addw	a5,a5,s5
    80002a56:	40d7d79b          	sraiw	a5,a5,0xd
    80002a5a:	01cb2583          	lw	a1,28(s6)
    80002a5e:	9dbd                	addw	a1,a1,a5
    80002a60:	855e                	mv	a0,s7
    80002a62:	00000097          	auipc	ra,0x0
    80002a66:	cd2080e7          	jalr	-814(ra) # 80002734 <bread>
    80002a6a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002a6c:	004b2503          	lw	a0,4(s6)
    80002a70:	000a849b          	sext.w	s1,s5
    80002a74:	8662                	mv	a2,s8
    80002a76:	faa4fde3          	bgeu	s1,a0,80002a30 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002a7a:	41f6579b          	sraiw	a5,a2,0x1f
    80002a7e:	01d7d69b          	srliw	a3,a5,0x1d
    80002a82:	00c6873b          	addw	a4,a3,a2
    80002a86:	00777793          	andi	a5,a4,7
    80002a8a:	9f95                	subw	a5,a5,a3
    80002a8c:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002a90:	4037571b          	sraiw	a4,a4,0x3
    80002a94:	00e906b3          	add	a3,s2,a4
    80002a98:	0586c683          	lbu	a3,88(a3)
    80002a9c:	00d7f5b3          	and	a1,a5,a3
    80002aa0:	cd91                	beqz	a1,80002abc <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002aa2:	2605                	addiw	a2,a2,1
    80002aa4:	2485                	addiw	s1,s1,1
    80002aa6:	fd4618e3          	bne	a2,s4,80002a76 <balloc+0x80>
    80002aaa:	b759                	j	80002a30 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002aac:	00006517          	auipc	a0,0x6
    80002ab0:	9f450513          	addi	a0,a0,-1548 # 800084a0 <syscalls+0x110>
    80002ab4:	00003097          	auipc	ra,0x3
    80002ab8:	534080e7          	jalr	1332(ra) # 80005fe8 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002abc:	974a                	add	a4,a4,s2
    80002abe:	8fd5                	or	a5,a5,a3
    80002ac0:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002ac4:	854a                	mv	a0,s2
    80002ac6:	00001097          	auipc	ra,0x1
    80002aca:	01a080e7          	jalr	26(ra) # 80003ae0 <log_write>
        brelse(bp);
    80002ace:	854a                	mv	a0,s2
    80002ad0:	00000097          	auipc	ra,0x0
    80002ad4:	d94080e7          	jalr	-620(ra) # 80002864 <brelse>
  bp = bread(dev, bno);
    80002ad8:	85a6                	mv	a1,s1
    80002ada:	855e                	mv	a0,s7
    80002adc:	00000097          	auipc	ra,0x0
    80002ae0:	c58080e7          	jalr	-936(ra) # 80002734 <bread>
    80002ae4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002ae6:	40000613          	li	a2,1024
    80002aea:	4581                	li	a1,0
    80002aec:	05850513          	addi	a0,a0,88
    80002af0:	ffffd097          	auipc	ra,0xffffd
    80002af4:	688080e7          	jalr	1672(ra) # 80000178 <memset>
  log_write(bp);
    80002af8:	854a                	mv	a0,s2
    80002afa:	00001097          	auipc	ra,0x1
    80002afe:	fe6080e7          	jalr	-26(ra) # 80003ae0 <log_write>
  brelse(bp);
    80002b02:	854a                	mv	a0,s2
    80002b04:	00000097          	auipc	ra,0x0
    80002b08:	d60080e7          	jalr	-672(ra) # 80002864 <brelse>
}
    80002b0c:	8526                	mv	a0,s1
    80002b0e:	60e6                	ld	ra,88(sp)
    80002b10:	6446                	ld	s0,80(sp)
    80002b12:	64a6                	ld	s1,72(sp)
    80002b14:	6906                	ld	s2,64(sp)
    80002b16:	79e2                	ld	s3,56(sp)
    80002b18:	7a42                	ld	s4,48(sp)
    80002b1a:	7aa2                	ld	s5,40(sp)
    80002b1c:	7b02                	ld	s6,32(sp)
    80002b1e:	6be2                	ld	s7,24(sp)
    80002b20:	6c42                	ld	s8,16(sp)
    80002b22:	6ca2                	ld	s9,8(sp)
    80002b24:	6125                	addi	sp,sp,96
    80002b26:	8082                	ret

0000000080002b28 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002b28:	7179                	addi	sp,sp,-48
    80002b2a:	f406                	sd	ra,40(sp)
    80002b2c:	f022                	sd	s0,32(sp)
    80002b2e:	ec26                	sd	s1,24(sp)
    80002b30:	e84a                	sd	s2,16(sp)
    80002b32:	e44e                	sd	s3,8(sp)
    80002b34:	e052                	sd	s4,0(sp)
    80002b36:	1800                	addi	s0,sp,48
    80002b38:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002b3a:	47ad                	li	a5,11
    80002b3c:	04b7fe63          	bgeu	a5,a1,80002b98 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002b40:	ff45849b          	addiw	s1,a1,-12
    80002b44:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002b48:	0ff00793          	li	a5,255
    80002b4c:	0ae7e363          	bltu	a5,a4,80002bf2 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002b50:	08052583          	lw	a1,128(a0)
    80002b54:	c5ad                	beqz	a1,80002bbe <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002b56:	00092503          	lw	a0,0(s2)
    80002b5a:	00000097          	auipc	ra,0x0
    80002b5e:	bda080e7          	jalr	-1062(ra) # 80002734 <bread>
    80002b62:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002b64:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002b68:	02049593          	slli	a1,s1,0x20
    80002b6c:	9181                	srli	a1,a1,0x20
    80002b6e:	058a                	slli	a1,a1,0x2
    80002b70:	00b784b3          	add	s1,a5,a1
    80002b74:	0004a983          	lw	s3,0(s1)
    80002b78:	04098d63          	beqz	s3,80002bd2 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002b7c:	8552                	mv	a0,s4
    80002b7e:	00000097          	auipc	ra,0x0
    80002b82:	ce6080e7          	jalr	-794(ra) # 80002864 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002b86:	854e                	mv	a0,s3
    80002b88:	70a2                	ld	ra,40(sp)
    80002b8a:	7402                	ld	s0,32(sp)
    80002b8c:	64e2                	ld	s1,24(sp)
    80002b8e:	6942                	ld	s2,16(sp)
    80002b90:	69a2                	ld	s3,8(sp)
    80002b92:	6a02                	ld	s4,0(sp)
    80002b94:	6145                	addi	sp,sp,48
    80002b96:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002b98:	02059493          	slli	s1,a1,0x20
    80002b9c:	9081                	srli	s1,s1,0x20
    80002b9e:	048a                	slli	s1,s1,0x2
    80002ba0:	94aa                	add	s1,s1,a0
    80002ba2:	0504a983          	lw	s3,80(s1)
    80002ba6:	fe0990e3          	bnez	s3,80002b86 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002baa:	4108                	lw	a0,0(a0)
    80002bac:	00000097          	auipc	ra,0x0
    80002bb0:	e4a080e7          	jalr	-438(ra) # 800029f6 <balloc>
    80002bb4:	0005099b          	sext.w	s3,a0
    80002bb8:	0534a823          	sw	s3,80(s1)
    80002bbc:	b7e9                	j	80002b86 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002bbe:	4108                	lw	a0,0(a0)
    80002bc0:	00000097          	auipc	ra,0x0
    80002bc4:	e36080e7          	jalr	-458(ra) # 800029f6 <balloc>
    80002bc8:	0005059b          	sext.w	a1,a0
    80002bcc:	08b92023          	sw	a1,128(s2)
    80002bd0:	b759                	j	80002b56 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002bd2:	00092503          	lw	a0,0(s2)
    80002bd6:	00000097          	auipc	ra,0x0
    80002bda:	e20080e7          	jalr	-480(ra) # 800029f6 <balloc>
    80002bde:	0005099b          	sext.w	s3,a0
    80002be2:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002be6:	8552                	mv	a0,s4
    80002be8:	00001097          	auipc	ra,0x1
    80002bec:	ef8080e7          	jalr	-264(ra) # 80003ae0 <log_write>
    80002bf0:	b771                	j	80002b7c <bmap+0x54>
  panic("bmap: out of range");
    80002bf2:	00006517          	auipc	a0,0x6
    80002bf6:	8c650513          	addi	a0,a0,-1850 # 800084b8 <syscalls+0x128>
    80002bfa:	00003097          	auipc	ra,0x3
    80002bfe:	3ee080e7          	jalr	1006(ra) # 80005fe8 <panic>

0000000080002c02 <iget>:
{
    80002c02:	7179                	addi	sp,sp,-48
    80002c04:	f406                	sd	ra,40(sp)
    80002c06:	f022                	sd	s0,32(sp)
    80002c08:	ec26                	sd	s1,24(sp)
    80002c0a:	e84a                	sd	s2,16(sp)
    80002c0c:	e44e                	sd	s3,8(sp)
    80002c0e:	e052                	sd	s4,0(sp)
    80002c10:	1800                	addi	s0,sp,48
    80002c12:	89aa                	mv	s3,a0
    80002c14:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002c16:	0001f517          	auipc	a0,0x1f
    80002c1a:	d6250513          	addi	a0,a0,-670 # 80021978 <itable>
    80002c1e:	00004097          	auipc	ra,0x4
    80002c22:	914080e7          	jalr	-1772(ra) # 80006532 <acquire>
  empty = 0;
    80002c26:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002c28:	0001f497          	auipc	s1,0x1f
    80002c2c:	d6848493          	addi	s1,s1,-664 # 80021990 <itable+0x18>
    80002c30:	00020697          	auipc	a3,0x20
    80002c34:	7f068693          	addi	a3,a3,2032 # 80023420 <log>
    80002c38:	a039                	j	80002c46 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002c3a:	02090b63          	beqz	s2,80002c70 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002c3e:	08848493          	addi	s1,s1,136
    80002c42:	02d48a63          	beq	s1,a3,80002c76 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002c46:	449c                	lw	a5,8(s1)
    80002c48:	fef059e3          	blez	a5,80002c3a <iget+0x38>
    80002c4c:	4098                	lw	a4,0(s1)
    80002c4e:	ff3716e3          	bne	a4,s3,80002c3a <iget+0x38>
    80002c52:	40d8                	lw	a4,4(s1)
    80002c54:	ff4713e3          	bne	a4,s4,80002c3a <iget+0x38>
      ip->ref++;
    80002c58:	2785                	addiw	a5,a5,1
    80002c5a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002c5c:	0001f517          	auipc	a0,0x1f
    80002c60:	d1c50513          	addi	a0,a0,-740 # 80021978 <itable>
    80002c64:	00004097          	auipc	ra,0x4
    80002c68:	982080e7          	jalr	-1662(ra) # 800065e6 <release>
      return ip;
    80002c6c:	8926                	mv	s2,s1
    80002c6e:	a03d                	j	80002c9c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002c70:	f7f9                	bnez	a5,80002c3e <iget+0x3c>
    80002c72:	8926                	mv	s2,s1
    80002c74:	b7e9                	j	80002c3e <iget+0x3c>
  if(empty == 0)
    80002c76:	02090c63          	beqz	s2,80002cae <iget+0xac>
  ip->dev = dev;
    80002c7a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002c7e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002c82:	4785                	li	a5,1
    80002c84:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002c88:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002c8c:	0001f517          	auipc	a0,0x1f
    80002c90:	cec50513          	addi	a0,a0,-788 # 80021978 <itable>
    80002c94:	00004097          	auipc	ra,0x4
    80002c98:	952080e7          	jalr	-1710(ra) # 800065e6 <release>
}
    80002c9c:	854a                	mv	a0,s2
    80002c9e:	70a2                	ld	ra,40(sp)
    80002ca0:	7402                	ld	s0,32(sp)
    80002ca2:	64e2                	ld	s1,24(sp)
    80002ca4:	6942                	ld	s2,16(sp)
    80002ca6:	69a2                	ld	s3,8(sp)
    80002ca8:	6a02                	ld	s4,0(sp)
    80002caa:	6145                	addi	sp,sp,48
    80002cac:	8082                	ret
    panic("iget: no inodes");
    80002cae:	00006517          	auipc	a0,0x6
    80002cb2:	82250513          	addi	a0,a0,-2014 # 800084d0 <syscalls+0x140>
    80002cb6:	00003097          	auipc	ra,0x3
    80002cba:	332080e7          	jalr	818(ra) # 80005fe8 <panic>

0000000080002cbe <fsinit>:
fsinit(int dev) {
    80002cbe:	7179                	addi	sp,sp,-48
    80002cc0:	f406                	sd	ra,40(sp)
    80002cc2:	f022                	sd	s0,32(sp)
    80002cc4:	ec26                	sd	s1,24(sp)
    80002cc6:	e84a                	sd	s2,16(sp)
    80002cc8:	e44e                	sd	s3,8(sp)
    80002cca:	1800                	addi	s0,sp,48
    80002ccc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002cce:	4585                	li	a1,1
    80002cd0:	00000097          	auipc	ra,0x0
    80002cd4:	a64080e7          	jalr	-1436(ra) # 80002734 <bread>
    80002cd8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002cda:	0001f997          	auipc	s3,0x1f
    80002cde:	c7e98993          	addi	s3,s3,-898 # 80021958 <sb>
    80002ce2:	02000613          	li	a2,32
    80002ce6:	05850593          	addi	a1,a0,88
    80002cea:	854e                	mv	a0,s3
    80002cec:	ffffd097          	auipc	ra,0xffffd
    80002cf0:	4ec080e7          	jalr	1260(ra) # 800001d8 <memmove>
  brelse(bp);
    80002cf4:	8526                	mv	a0,s1
    80002cf6:	00000097          	auipc	ra,0x0
    80002cfa:	b6e080e7          	jalr	-1170(ra) # 80002864 <brelse>
  if(sb.magic != FSMAGIC)
    80002cfe:	0009a703          	lw	a4,0(s3)
    80002d02:	102037b7          	lui	a5,0x10203
    80002d06:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002d0a:	02f71263          	bne	a4,a5,80002d2e <fsinit+0x70>
  initlog(dev, &sb);
    80002d0e:	0001f597          	auipc	a1,0x1f
    80002d12:	c4a58593          	addi	a1,a1,-950 # 80021958 <sb>
    80002d16:	854a                	mv	a0,s2
    80002d18:	00001097          	auipc	ra,0x1
    80002d1c:	b4c080e7          	jalr	-1204(ra) # 80003864 <initlog>
}
    80002d20:	70a2                	ld	ra,40(sp)
    80002d22:	7402                	ld	s0,32(sp)
    80002d24:	64e2                	ld	s1,24(sp)
    80002d26:	6942                	ld	s2,16(sp)
    80002d28:	69a2                	ld	s3,8(sp)
    80002d2a:	6145                	addi	sp,sp,48
    80002d2c:	8082                	ret
    panic("invalid file system");
    80002d2e:	00005517          	auipc	a0,0x5
    80002d32:	7b250513          	addi	a0,a0,1970 # 800084e0 <syscalls+0x150>
    80002d36:	00003097          	auipc	ra,0x3
    80002d3a:	2b2080e7          	jalr	690(ra) # 80005fe8 <panic>

0000000080002d3e <iinit>:
{
    80002d3e:	7179                	addi	sp,sp,-48
    80002d40:	f406                	sd	ra,40(sp)
    80002d42:	f022                	sd	s0,32(sp)
    80002d44:	ec26                	sd	s1,24(sp)
    80002d46:	e84a                	sd	s2,16(sp)
    80002d48:	e44e                	sd	s3,8(sp)
    80002d4a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002d4c:	00005597          	auipc	a1,0x5
    80002d50:	7ac58593          	addi	a1,a1,1964 # 800084f8 <syscalls+0x168>
    80002d54:	0001f517          	auipc	a0,0x1f
    80002d58:	c2450513          	addi	a0,a0,-988 # 80021978 <itable>
    80002d5c:	00003097          	auipc	ra,0x3
    80002d60:	746080e7          	jalr	1862(ra) # 800064a2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002d64:	0001f497          	auipc	s1,0x1f
    80002d68:	c3c48493          	addi	s1,s1,-964 # 800219a0 <itable+0x28>
    80002d6c:	00020997          	auipc	s3,0x20
    80002d70:	6c498993          	addi	s3,s3,1732 # 80023430 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002d74:	00005917          	auipc	s2,0x5
    80002d78:	78c90913          	addi	s2,s2,1932 # 80008500 <syscalls+0x170>
    80002d7c:	85ca                	mv	a1,s2
    80002d7e:	8526                	mv	a0,s1
    80002d80:	00001097          	auipc	ra,0x1
    80002d84:	e46080e7          	jalr	-442(ra) # 80003bc6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002d88:	08848493          	addi	s1,s1,136
    80002d8c:	ff3498e3          	bne	s1,s3,80002d7c <iinit+0x3e>
}
    80002d90:	70a2                	ld	ra,40(sp)
    80002d92:	7402                	ld	s0,32(sp)
    80002d94:	64e2                	ld	s1,24(sp)
    80002d96:	6942                	ld	s2,16(sp)
    80002d98:	69a2                	ld	s3,8(sp)
    80002d9a:	6145                	addi	sp,sp,48
    80002d9c:	8082                	ret

0000000080002d9e <ialloc>:
{
    80002d9e:	715d                	addi	sp,sp,-80
    80002da0:	e486                	sd	ra,72(sp)
    80002da2:	e0a2                	sd	s0,64(sp)
    80002da4:	fc26                	sd	s1,56(sp)
    80002da6:	f84a                	sd	s2,48(sp)
    80002da8:	f44e                	sd	s3,40(sp)
    80002daa:	f052                	sd	s4,32(sp)
    80002dac:	ec56                	sd	s5,24(sp)
    80002dae:	e85a                	sd	s6,16(sp)
    80002db0:	e45e                	sd	s7,8(sp)
    80002db2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002db4:	0001f717          	auipc	a4,0x1f
    80002db8:	bb072703          	lw	a4,-1104(a4) # 80021964 <sb+0xc>
    80002dbc:	4785                	li	a5,1
    80002dbe:	04e7fa63          	bgeu	a5,a4,80002e12 <ialloc+0x74>
    80002dc2:	8aaa                	mv	s5,a0
    80002dc4:	8bae                	mv	s7,a1
    80002dc6:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002dc8:	0001fa17          	auipc	s4,0x1f
    80002dcc:	b90a0a13          	addi	s4,s4,-1136 # 80021958 <sb>
    80002dd0:	00048b1b          	sext.w	s6,s1
    80002dd4:	0044d593          	srli	a1,s1,0x4
    80002dd8:	018a2783          	lw	a5,24(s4)
    80002ddc:	9dbd                	addw	a1,a1,a5
    80002dde:	8556                	mv	a0,s5
    80002de0:	00000097          	auipc	ra,0x0
    80002de4:	954080e7          	jalr	-1708(ra) # 80002734 <bread>
    80002de8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002dea:	05850993          	addi	s3,a0,88
    80002dee:	00f4f793          	andi	a5,s1,15
    80002df2:	079a                	slli	a5,a5,0x6
    80002df4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002df6:	00099783          	lh	a5,0(s3)
    80002dfa:	c785                	beqz	a5,80002e22 <ialloc+0x84>
    brelse(bp);
    80002dfc:	00000097          	auipc	ra,0x0
    80002e00:	a68080e7          	jalr	-1432(ra) # 80002864 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002e04:	0485                	addi	s1,s1,1
    80002e06:	00ca2703          	lw	a4,12(s4)
    80002e0a:	0004879b          	sext.w	a5,s1
    80002e0e:	fce7e1e3          	bltu	a5,a4,80002dd0 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002e12:	00005517          	auipc	a0,0x5
    80002e16:	6f650513          	addi	a0,a0,1782 # 80008508 <syscalls+0x178>
    80002e1a:	00003097          	auipc	ra,0x3
    80002e1e:	1ce080e7          	jalr	462(ra) # 80005fe8 <panic>
      memset(dip, 0, sizeof(*dip));
    80002e22:	04000613          	li	a2,64
    80002e26:	4581                	li	a1,0
    80002e28:	854e                	mv	a0,s3
    80002e2a:	ffffd097          	auipc	ra,0xffffd
    80002e2e:	34e080e7          	jalr	846(ra) # 80000178 <memset>
      dip->type = type;
    80002e32:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002e36:	854a                	mv	a0,s2
    80002e38:	00001097          	auipc	ra,0x1
    80002e3c:	ca8080e7          	jalr	-856(ra) # 80003ae0 <log_write>
      brelse(bp);
    80002e40:	854a                	mv	a0,s2
    80002e42:	00000097          	auipc	ra,0x0
    80002e46:	a22080e7          	jalr	-1502(ra) # 80002864 <brelse>
      return iget(dev, inum);
    80002e4a:	85da                	mv	a1,s6
    80002e4c:	8556                	mv	a0,s5
    80002e4e:	00000097          	auipc	ra,0x0
    80002e52:	db4080e7          	jalr	-588(ra) # 80002c02 <iget>
}
    80002e56:	60a6                	ld	ra,72(sp)
    80002e58:	6406                	ld	s0,64(sp)
    80002e5a:	74e2                	ld	s1,56(sp)
    80002e5c:	7942                	ld	s2,48(sp)
    80002e5e:	79a2                	ld	s3,40(sp)
    80002e60:	7a02                	ld	s4,32(sp)
    80002e62:	6ae2                	ld	s5,24(sp)
    80002e64:	6b42                	ld	s6,16(sp)
    80002e66:	6ba2                	ld	s7,8(sp)
    80002e68:	6161                	addi	sp,sp,80
    80002e6a:	8082                	ret

0000000080002e6c <iupdate>:
{
    80002e6c:	1101                	addi	sp,sp,-32
    80002e6e:	ec06                	sd	ra,24(sp)
    80002e70:	e822                	sd	s0,16(sp)
    80002e72:	e426                	sd	s1,8(sp)
    80002e74:	e04a                	sd	s2,0(sp)
    80002e76:	1000                	addi	s0,sp,32
    80002e78:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e7a:	415c                	lw	a5,4(a0)
    80002e7c:	0047d79b          	srliw	a5,a5,0x4
    80002e80:	0001f597          	auipc	a1,0x1f
    80002e84:	af05a583          	lw	a1,-1296(a1) # 80021970 <sb+0x18>
    80002e88:	9dbd                	addw	a1,a1,a5
    80002e8a:	4108                	lw	a0,0(a0)
    80002e8c:	00000097          	auipc	ra,0x0
    80002e90:	8a8080e7          	jalr	-1880(ra) # 80002734 <bread>
    80002e94:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e96:	05850793          	addi	a5,a0,88
    80002e9a:	40c8                	lw	a0,4(s1)
    80002e9c:	893d                	andi	a0,a0,15
    80002e9e:	051a                	slli	a0,a0,0x6
    80002ea0:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002ea2:	04449703          	lh	a4,68(s1)
    80002ea6:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002eaa:	04649703          	lh	a4,70(s1)
    80002eae:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002eb2:	04849703          	lh	a4,72(s1)
    80002eb6:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002eba:	04a49703          	lh	a4,74(s1)
    80002ebe:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002ec2:	44f8                	lw	a4,76(s1)
    80002ec4:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ec6:	03400613          	li	a2,52
    80002eca:	05048593          	addi	a1,s1,80
    80002ece:	0531                	addi	a0,a0,12
    80002ed0:	ffffd097          	auipc	ra,0xffffd
    80002ed4:	308080e7          	jalr	776(ra) # 800001d8 <memmove>
  log_write(bp);
    80002ed8:	854a                	mv	a0,s2
    80002eda:	00001097          	auipc	ra,0x1
    80002ede:	c06080e7          	jalr	-1018(ra) # 80003ae0 <log_write>
  brelse(bp);
    80002ee2:	854a                	mv	a0,s2
    80002ee4:	00000097          	auipc	ra,0x0
    80002ee8:	980080e7          	jalr	-1664(ra) # 80002864 <brelse>
}
    80002eec:	60e2                	ld	ra,24(sp)
    80002eee:	6442                	ld	s0,16(sp)
    80002ef0:	64a2                	ld	s1,8(sp)
    80002ef2:	6902                	ld	s2,0(sp)
    80002ef4:	6105                	addi	sp,sp,32
    80002ef6:	8082                	ret

0000000080002ef8 <idup>:
{
    80002ef8:	1101                	addi	sp,sp,-32
    80002efa:	ec06                	sd	ra,24(sp)
    80002efc:	e822                	sd	s0,16(sp)
    80002efe:	e426                	sd	s1,8(sp)
    80002f00:	1000                	addi	s0,sp,32
    80002f02:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f04:	0001f517          	auipc	a0,0x1f
    80002f08:	a7450513          	addi	a0,a0,-1420 # 80021978 <itable>
    80002f0c:	00003097          	auipc	ra,0x3
    80002f10:	626080e7          	jalr	1574(ra) # 80006532 <acquire>
  ip->ref++;
    80002f14:	449c                	lw	a5,8(s1)
    80002f16:	2785                	addiw	a5,a5,1
    80002f18:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f1a:	0001f517          	auipc	a0,0x1f
    80002f1e:	a5e50513          	addi	a0,a0,-1442 # 80021978 <itable>
    80002f22:	00003097          	auipc	ra,0x3
    80002f26:	6c4080e7          	jalr	1732(ra) # 800065e6 <release>
}
    80002f2a:	8526                	mv	a0,s1
    80002f2c:	60e2                	ld	ra,24(sp)
    80002f2e:	6442                	ld	s0,16(sp)
    80002f30:	64a2                	ld	s1,8(sp)
    80002f32:	6105                	addi	sp,sp,32
    80002f34:	8082                	ret

0000000080002f36 <ilock>:
{
    80002f36:	1101                	addi	sp,sp,-32
    80002f38:	ec06                	sd	ra,24(sp)
    80002f3a:	e822                	sd	s0,16(sp)
    80002f3c:	e426                	sd	s1,8(sp)
    80002f3e:	e04a                	sd	s2,0(sp)
    80002f40:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002f42:	c115                	beqz	a0,80002f66 <ilock+0x30>
    80002f44:	84aa                	mv	s1,a0
    80002f46:	451c                	lw	a5,8(a0)
    80002f48:	00f05f63          	blez	a5,80002f66 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002f4c:	0541                	addi	a0,a0,16
    80002f4e:	00001097          	auipc	ra,0x1
    80002f52:	cb2080e7          	jalr	-846(ra) # 80003c00 <acquiresleep>
  if(ip->valid == 0){
    80002f56:	40bc                	lw	a5,64(s1)
    80002f58:	cf99                	beqz	a5,80002f76 <ilock+0x40>
}
    80002f5a:	60e2                	ld	ra,24(sp)
    80002f5c:	6442                	ld	s0,16(sp)
    80002f5e:	64a2                	ld	s1,8(sp)
    80002f60:	6902                	ld	s2,0(sp)
    80002f62:	6105                	addi	sp,sp,32
    80002f64:	8082                	ret
    panic("ilock");
    80002f66:	00005517          	auipc	a0,0x5
    80002f6a:	5ba50513          	addi	a0,a0,1466 # 80008520 <syscalls+0x190>
    80002f6e:	00003097          	auipc	ra,0x3
    80002f72:	07a080e7          	jalr	122(ra) # 80005fe8 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002f76:	40dc                	lw	a5,4(s1)
    80002f78:	0047d79b          	srliw	a5,a5,0x4
    80002f7c:	0001f597          	auipc	a1,0x1f
    80002f80:	9f45a583          	lw	a1,-1548(a1) # 80021970 <sb+0x18>
    80002f84:	9dbd                	addw	a1,a1,a5
    80002f86:	4088                	lw	a0,0(s1)
    80002f88:	fffff097          	auipc	ra,0xfffff
    80002f8c:	7ac080e7          	jalr	1964(ra) # 80002734 <bread>
    80002f90:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002f92:	05850593          	addi	a1,a0,88
    80002f96:	40dc                	lw	a5,4(s1)
    80002f98:	8bbd                	andi	a5,a5,15
    80002f9a:	079a                	slli	a5,a5,0x6
    80002f9c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002f9e:	00059783          	lh	a5,0(a1)
    80002fa2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002fa6:	00259783          	lh	a5,2(a1)
    80002faa:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002fae:	00459783          	lh	a5,4(a1)
    80002fb2:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002fb6:	00659783          	lh	a5,6(a1)
    80002fba:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002fbe:	459c                	lw	a5,8(a1)
    80002fc0:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002fc2:	03400613          	li	a2,52
    80002fc6:	05b1                	addi	a1,a1,12
    80002fc8:	05048513          	addi	a0,s1,80
    80002fcc:	ffffd097          	auipc	ra,0xffffd
    80002fd0:	20c080e7          	jalr	524(ra) # 800001d8 <memmove>
    brelse(bp);
    80002fd4:	854a                	mv	a0,s2
    80002fd6:	00000097          	auipc	ra,0x0
    80002fda:	88e080e7          	jalr	-1906(ra) # 80002864 <brelse>
    ip->valid = 1;
    80002fde:	4785                	li	a5,1
    80002fe0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002fe2:	04449783          	lh	a5,68(s1)
    80002fe6:	fbb5                	bnez	a5,80002f5a <ilock+0x24>
      panic("ilock: no type");
    80002fe8:	00005517          	auipc	a0,0x5
    80002fec:	54050513          	addi	a0,a0,1344 # 80008528 <syscalls+0x198>
    80002ff0:	00003097          	auipc	ra,0x3
    80002ff4:	ff8080e7          	jalr	-8(ra) # 80005fe8 <panic>

0000000080002ff8 <iunlock>:
{
    80002ff8:	1101                	addi	sp,sp,-32
    80002ffa:	ec06                	sd	ra,24(sp)
    80002ffc:	e822                	sd	s0,16(sp)
    80002ffe:	e426                	sd	s1,8(sp)
    80003000:	e04a                	sd	s2,0(sp)
    80003002:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003004:	c905                	beqz	a0,80003034 <iunlock+0x3c>
    80003006:	84aa                	mv	s1,a0
    80003008:	01050913          	addi	s2,a0,16
    8000300c:	854a                	mv	a0,s2
    8000300e:	00001097          	auipc	ra,0x1
    80003012:	c8c080e7          	jalr	-884(ra) # 80003c9a <holdingsleep>
    80003016:	cd19                	beqz	a0,80003034 <iunlock+0x3c>
    80003018:	449c                	lw	a5,8(s1)
    8000301a:	00f05d63          	blez	a5,80003034 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000301e:	854a                	mv	a0,s2
    80003020:	00001097          	auipc	ra,0x1
    80003024:	c36080e7          	jalr	-970(ra) # 80003c56 <releasesleep>
}
    80003028:	60e2                	ld	ra,24(sp)
    8000302a:	6442                	ld	s0,16(sp)
    8000302c:	64a2                	ld	s1,8(sp)
    8000302e:	6902                	ld	s2,0(sp)
    80003030:	6105                	addi	sp,sp,32
    80003032:	8082                	ret
    panic("iunlock");
    80003034:	00005517          	auipc	a0,0x5
    80003038:	50450513          	addi	a0,a0,1284 # 80008538 <syscalls+0x1a8>
    8000303c:	00003097          	auipc	ra,0x3
    80003040:	fac080e7          	jalr	-84(ra) # 80005fe8 <panic>

0000000080003044 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003044:	7179                	addi	sp,sp,-48
    80003046:	f406                	sd	ra,40(sp)
    80003048:	f022                	sd	s0,32(sp)
    8000304a:	ec26                	sd	s1,24(sp)
    8000304c:	e84a                	sd	s2,16(sp)
    8000304e:	e44e                	sd	s3,8(sp)
    80003050:	e052                	sd	s4,0(sp)
    80003052:	1800                	addi	s0,sp,48
    80003054:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003056:	05050493          	addi	s1,a0,80
    8000305a:	08050913          	addi	s2,a0,128
    8000305e:	a021                	j	80003066 <itrunc+0x22>
    80003060:	0491                	addi	s1,s1,4
    80003062:	01248d63          	beq	s1,s2,8000307c <itrunc+0x38>
    if(ip->addrs[i]){
    80003066:	408c                	lw	a1,0(s1)
    80003068:	dde5                	beqz	a1,80003060 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    8000306a:	0009a503          	lw	a0,0(s3)
    8000306e:	00000097          	auipc	ra,0x0
    80003072:	90c080e7          	jalr	-1780(ra) # 8000297a <bfree>
      ip->addrs[i] = 0;
    80003076:	0004a023          	sw	zero,0(s1)
    8000307a:	b7dd                	j	80003060 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000307c:	0809a583          	lw	a1,128(s3)
    80003080:	e185                	bnez	a1,800030a0 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003082:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003086:	854e                	mv	a0,s3
    80003088:	00000097          	auipc	ra,0x0
    8000308c:	de4080e7          	jalr	-540(ra) # 80002e6c <iupdate>
}
    80003090:	70a2                	ld	ra,40(sp)
    80003092:	7402                	ld	s0,32(sp)
    80003094:	64e2                	ld	s1,24(sp)
    80003096:	6942                	ld	s2,16(sp)
    80003098:	69a2                	ld	s3,8(sp)
    8000309a:	6a02                	ld	s4,0(sp)
    8000309c:	6145                	addi	sp,sp,48
    8000309e:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800030a0:	0009a503          	lw	a0,0(s3)
    800030a4:	fffff097          	auipc	ra,0xfffff
    800030a8:	690080e7          	jalr	1680(ra) # 80002734 <bread>
    800030ac:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800030ae:	05850493          	addi	s1,a0,88
    800030b2:	45850913          	addi	s2,a0,1112
    800030b6:	a811                	j	800030ca <itrunc+0x86>
        bfree(ip->dev, a[j]);
    800030b8:	0009a503          	lw	a0,0(s3)
    800030bc:	00000097          	auipc	ra,0x0
    800030c0:	8be080e7          	jalr	-1858(ra) # 8000297a <bfree>
    for(j = 0; j < NINDIRECT; j++){
    800030c4:	0491                	addi	s1,s1,4
    800030c6:	01248563          	beq	s1,s2,800030d0 <itrunc+0x8c>
      if(a[j])
    800030ca:	408c                	lw	a1,0(s1)
    800030cc:	dde5                	beqz	a1,800030c4 <itrunc+0x80>
    800030ce:	b7ed                	j	800030b8 <itrunc+0x74>
    brelse(bp);
    800030d0:	8552                	mv	a0,s4
    800030d2:	fffff097          	auipc	ra,0xfffff
    800030d6:	792080e7          	jalr	1938(ra) # 80002864 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800030da:	0809a583          	lw	a1,128(s3)
    800030de:	0009a503          	lw	a0,0(s3)
    800030e2:	00000097          	auipc	ra,0x0
    800030e6:	898080e7          	jalr	-1896(ra) # 8000297a <bfree>
    ip->addrs[NDIRECT] = 0;
    800030ea:	0809a023          	sw	zero,128(s3)
    800030ee:	bf51                	j	80003082 <itrunc+0x3e>

00000000800030f0 <iput>:
{
    800030f0:	1101                	addi	sp,sp,-32
    800030f2:	ec06                	sd	ra,24(sp)
    800030f4:	e822                	sd	s0,16(sp)
    800030f6:	e426                	sd	s1,8(sp)
    800030f8:	e04a                	sd	s2,0(sp)
    800030fa:	1000                	addi	s0,sp,32
    800030fc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800030fe:	0001f517          	auipc	a0,0x1f
    80003102:	87a50513          	addi	a0,a0,-1926 # 80021978 <itable>
    80003106:	00003097          	auipc	ra,0x3
    8000310a:	42c080e7          	jalr	1068(ra) # 80006532 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000310e:	4498                	lw	a4,8(s1)
    80003110:	4785                	li	a5,1
    80003112:	02f70363          	beq	a4,a5,80003138 <iput+0x48>
  ip->ref--;
    80003116:	449c                	lw	a5,8(s1)
    80003118:	37fd                	addiw	a5,a5,-1
    8000311a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000311c:	0001f517          	auipc	a0,0x1f
    80003120:	85c50513          	addi	a0,a0,-1956 # 80021978 <itable>
    80003124:	00003097          	auipc	ra,0x3
    80003128:	4c2080e7          	jalr	1218(ra) # 800065e6 <release>
}
    8000312c:	60e2                	ld	ra,24(sp)
    8000312e:	6442                	ld	s0,16(sp)
    80003130:	64a2                	ld	s1,8(sp)
    80003132:	6902                	ld	s2,0(sp)
    80003134:	6105                	addi	sp,sp,32
    80003136:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003138:	40bc                	lw	a5,64(s1)
    8000313a:	dff1                	beqz	a5,80003116 <iput+0x26>
    8000313c:	04a49783          	lh	a5,74(s1)
    80003140:	fbf9                	bnez	a5,80003116 <iput+0x26>
    acquiresleep(&ip->lock);
    80003142:	01048913          	addi	s2,s1,16
    80003146:	854a                	mv	a0,s2
    80003148:	00001097          	auipc	ra,0x1
    8000314c:	ab8080e7          	jalr	-1352(ra) # 80003c00 <acquiresleep>
    release(&itable.lock);
    80003150:	0001f517          	auipc	a0,0x1f
    80003154:	82850513          	addi	a0,a0,-2008 # 80021978 <itable>
    80003158:	00003097          	auipc	ra,0x3
    8000315c:	48e080e7          	jalr	1166(ra) # 800065e6 <release>
    itrunc(ip);
    80003160:	8526                	mv	a0,s1
    80003162:	00000097          	auipc	ra,0x0
    80003166:	ee2080e7          	jalr	-286(ra) # 80003044 <itrunc>
    ip->type = 0;
    8000316a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000316e:	8526                	mv	a0,s1
    80003170:	00000097          	auipc	ra,0x0
    80003174:	cfc080e7          	jalr	-772(ra) # 80002e6c <iupdate>
    ip->valid = 0;
    80003178:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000317c:	854a                	mv	a0,s2
    8000317e:	00001097          	auipc	ra,0x1
    80003182:	ad8080e7          	jalr	-1320(ra) # 80003c56 <releasesleep>
    acquire(&itable.lock);
    80003186:	0001e517          	auipc	a0,0x1e
    8000318a:	7f250513          	addi	a0,a0,2034 # 80021978 <itable>
    8000318e:	00003097          	auipc	ra,0x3
    80003192:	3a4080e7          	jalr	932(ra) # 80006532 <acquire>
    80003196:	b741                	j	80003116 <iput+0x26>

0000000080003198 <iunlockput>:
{
    80003198:	1101                	addi	sp,sp,-32
    8000319a:	ec06                	sd	ra,24(sp)
    8000319c:	e822                	sd	s0,16(sp)
    8000319e:	e426                	sd	s1,8(sp)
    800031a0:	1000                	addi	s0,sp,32
    800031a2:	84aa                	mv	s1,a0
  iunlock(ip);
    800031a4:	00000097          	auipc	ra,0x0
    800031a8:	e54080e7          	jalr	-428(ra) # 80002ff8 <iunlock>
  iput(ip);
    800031ac:	8526                	mv	a0,s1
    800031ae:	00000097          	auipc	ra,0x0
    800031b2:	f42080e7          	jalr	-190(ra) # 800030f0 <iput>
}
    800031b6:	60e2                	ld	ra,24(sp)
    800031b8:	6442                	ld	s0,16(sp)
    800031ba:	64a2                	ld	s1,8(sp)
    800031bc:	6105                	addi	sp,sp,32
    800031be:	8082                	ret

00000000800031c0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800031c0:	1141                	addi	sp,sp,-16
    800031c2:	e422                	sd	s0,8(sp)
    800031c4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800031c6:	411c                	lw	a5,0(a0)
    800031c8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800031ca:	415c                	lw	a5,4(a0)
    800031cc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800031ce:	04451783          	lh	a5,68(a0)
    800031d2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800031d6:	04a51783          	lh	a5,74(a0)
    800031da:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800031de:	04c56783          	lwu	a5,76(a0)
    800031e2:	e99c                	sd	a5,16(a1)
}
    800031e4:	6422                	ld	s0,8(sp)
    800031e6:	0141                	addi	sp,sp,16
    800031e8:	8082                	ret

00000000800031ea <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800031ea:	457c                	lw	a5,76(a0)
    800031ec:	0ed7e963          	bltu	a5,a3,800032de <readi+0xf4>
{
    800031f0:	7159                	addi	sp,sp,-112
    800031f2:	f486                	sd	ra,104(sp)
    800031f4:	f0a2                	sd	s0,96(sp)
    800031f6:	eca6                	sd	s1,88(sp)
    800031f8:	e8ca                	sd	s2,80(sp)
    800031fa:	e4ce                	sd	s3,72(sp)
    800031fc:	e0d2                	sd	s4,64(sp)
    800031fe:	fc56                	sd	s5,56(sp)
    80003200:	f85a                	sd	s6,48(sp)
    80003202:	f45e                	sd	s7,40(sp)
    80003204:	f062                	sd	s8,32(sp)
    80003206:	ec66                	sd	s9,24(sp)
    80003208:	e86a                	sd	s10,16(sp)
    8000320a:	e46e                	sd	s11,8(sp)
    8000320c:	1880                	addi	s0,sp,112
    8000320e:	8baa                	mv	s7,a0
    80003210:	8c2e                	mv	s8,a1
    80003212:	8ab2                	mv	s5,a2
    80003214:	84b6                	mv	s1,a3
    80003216:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003218:	9f35                	addw	a4,a4,a3
    return 0;
    8000321a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000321c:	0ad76063          	bltu	a4,a3,800032bc <readi+0xd2>
  if(off + n > ip->size)
    80003220:	00e7f463          	bgeu	a5,a4,80003228 <readi+0x3e>
    n = ip->size - off;
    80003224:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003228:	0a0b0963          	beqz	s6,800032da <readi+0xf0>
    8000322c:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000322e:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003232:	5cfd                	li	s9,-1
    80003234:	a82d                	j	8000326e <readi+0x84>
    80003236:	020a1d93          	slli	s11,s4,0x20
    8000323a:	020ddd93          	srli	s11,s11,0x20
    8000323e:	05890613          	addi	a2,s2,88
    80003242:	86ee                	mv	a3,s11
    80003244:	963a                	add	a2,a2,a4
    80003246:	85d6                	mv	a1,s5
    80003248:	8562                	mv	a0,s8
    8000324a:	ffffe097          	auipc	ra,0xffffe
    8000324e:	79e080e7          	jalr	1950(ra) # 800019e8 <either_copyout>
    80003252:	05950d63          	beq	a0,s9,800032ac <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003256:	854a                	mv	a0,s2
    80003258:	fffff097          	auipc	ra,0xfffff
    8000325c:	60c080e7          	jalr	1548(ra) # 80002864 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003260:	013a09bb          	addw	s3,s4,s3
    80003264:	009a04bb          	addw	s1,s4,s1
    80003268:	9aee                	add	s5,s5,s11
    8000326a:	0569f763          	bgeu	s3,s6,800032b8 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000326e:	000ba903          	lw	s2,0(s7)
    80003272:	00a4d59b          	srliw	a1,s1,0xa
    80003276:	855e                	mv	a0,s7
    80003278:	00000097          	auipc	ra,0x0
    8000327c:	8b0080e7          	jalr	-1872(ra) # 80002b28 <bmap>
    80003280:	0005059b          	sext.w	a1,a0
    80003284:	854a                	mv	a0,s2
    80003286:	fffff097          	auipc	ra,0xfffff
    8000328a:	4ae080e7          	jalr	1198(ra) # 80002734 <bread>
    8000328e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003290:	3ff4f713          	andi	a4,s1,1023
    80003294:	40ed07bb          	subw	a5,s10,a4
    80003298:	413b06bb          	subw	a3,s6,s3
    8000329c:	8a3e                	mv	s4,a5
    8000329e:	2781                	sext.w	a5,a5
    800032a0:	0006861b          	sext.w	a2,a3
    800032a4:	f8f679e3          	bgeu	a2,a5,80003236 <readi+0x4c>
    800032a8:	8a36                	mv	s4,a3
    800032aa:	b771                	j	80003236 <readi+0x4c>
      brelse(bp);
    800032ac:	854a                	mv	a0,s2
    800032ae:	fffff097          	auipc	ra,0xfffff
    800032b2:	5b6080e7          	jalr	1462(ra) # 80002864 <brelse>
      tot = -1;
    800032b6:	59fd                	li	s3,-1
  }
  return tot;
    800032b8:	0009851b          	sext.w	a0,s3
}
    800032bc:	70a6                	ld	ra,104(sp)
    800032be:	7406                	ld	s0,96(sp)
    800032c0:	64e6                	ld	s1,88(sp)
    800032c2:	6946                	ld	s2,80(sp)
    800032c4:	69a6                	ld	s3,72(sp)
    800032c6:	6a06                	ld	s4,64(sp)
    800032c8:	7ae2                	ld	s5,56(sp)
    800032ca:	7b42                	ld	s6,48(sp)
    800032cc:	7ba2                	ld	s7,40(sp)
    800032ce:	7c02                	ld	s8,32(sp)
    800032d0:	6ce2                	ld	s9,24(sp)
    800032d2:	6d42                	ld	s10,16(sp)
    800032d4:	6da2                	ld	s11,8(sp)
    800032d6:	6165                	addi	sp,sp,112
    800032d8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800032da:	89da                	mv	s3,s6
    800032dc:	bff1                	j	800032b8 <readi+0xce>
    return 0;
    800032de:	4501                	li	a0,0
}
    800032e0:	8082                	ret

00000000800032e2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800032e2:	457c                	lw	a5,76(a0)
    800032e4:	10d7e863          	bltu	a5,a3,800033f4 <writei+0x112>
{
    800032e8:	7159                	addi	sp,sp,-112
    800032ea:	f486                	sd	ra,104(sp)
    800032ec:	f0a2                	sd	s0,96(sp)
    800032ee:	eca6                	sd	s1,88(sp)
    800032f0:	e8ca                	sd	s2,80(sp)
    800032f2:	e4ce                	sd	s3,72(sp)
    800032f4:	e0d2                	sd	s4,64(sp)
    800032f6:	fc56                	sd	s5,56(sp)
    800032f8:	f85a                	sd	s6,48(sp)
    800032fa:	f45e                	sd	s7,40(sp)
    800032fc:	f062                	sd	s8,32(sp)
    800032fe:	ec66                	sd	s9,24(sp)
    80003300:	e86a                	sd	s10,16(sp)
    80003302:	e46e                	sd	s11,8(sp)
    80003304:	1880                	addi	s0,sp,112
    80003306:	8b2a                	mv	s6,a0
    80003308:	8c2e                	mv	s8,a1
    8000330a:	8ab2                	mv	s5,a2
    8000330c:	8936                	mv	s2,a3
    8000330e:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003310:	00e687bb          	addw	a5,a3,a4
    80003314:	0ed7e263          	bltu	a5,a3,800033f8 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003318:	00043737          	lui	a4,0x43
    8000331c:	0ef76063          	bltu	a4,a5,800033fc <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003320:	0c0b8863          	beqz	s7,800033f0 <writei+0x10e>
    80003324:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003326:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000332a:	5cfd                	li	s9,-1
    8000332c:	a091                	j	80003370 <writei+0x8e>
    8000332e:	02099d93          	slli	s11,s3,0x20
    80003332:	020ddd93          	srli	s11,s11,0x20
    80003336:	05848513          	addi	a0,s1,88
    8000333a:	86ee                	mv	a3,s11
    8000333c:	8656                	mv	a2,s5
    8000333e:	85e2                	mv	a1,s8
    80003340:	953a                	add	a0,a0,a4
    80003342:	ffffe097          	auipc	ra,0xffffe
    80003346:	6fc080e7          	jalr	1788(ra) # 80001a3e <either_copyin>
    8000334a:	07950263          	beq	a0,s9,800033ae <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000334e:	8526                	mv	a0,s1
    80003350:	00000097          	auipc	ra,0x0
    80003354:	790080e7          	jalr	1936(ra) # 80003ae0 <log_write>
    brelse(bp);
    80003358:	8526                	mv	a0,s1
    8000335a:	fffff097          	auipc	ra,0xfffff
    8000335e:	50a080e7          	jalr	1290(ra) # 80002864 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003362:	01498a3b          	addw	s4,s3,s4
    80003366:	0129893b          	addw	s2,s3,s2
    8000336a:	9aee                	add	s5,s5,s11
    8000336c:	057a7663          	bgeu	s4,s7,800033b8 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003370:	000b2483          	lw	s1,0(s6)
    80003374:	00a9559b          	srliw	a1,s2,0xa
    80003378:	855a                	mv	a0,s6
    8000337a:	fffff097          	auipc	ra,0xfffff
    8000337e:	7ae080e7          	jalr	1966(ra) # 80002b28 <bmap>
    80003382:	0005059b          	sext.w	a1,a0
    80003386:	8526                	mv	a0,s1
    80003388:	fffff097          	auipc	ra,0xfffff
    8000338c:	3ac080e7          	jalr	940(ra) # 80002734 <bread>
    80003390:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003392:	3ff97713          	andi	a4,s2,1023
    80003396:	40ed07bb          	subw	a5,s10,a4
    8000339a:	414b86bb          	subw	a3,s7,s4
    8000339e:	89be                	mv	s3,a5
    800033a0:	2781                	sext.w	a5,a5
    800033a2:	0006861b          	sext.w	a2,a3
    800033a6:	f8f674e3          	bgeu	a2,a5,8000332e <writei+0x4c>
    800033aa:	89b6                	mv	s3,a3
    800033ac:	b749                	j	8000332e <writei+0x4c>
      brelse(bp);
    800033ae:	8526                	mv	a0,s1
    800033b0:	fffff097          	auipc	ra,0xfffff
    800033b4:	4b4080e7          	jalr	1204(ra) # 80002864 <brelse>
  }

  if(off > ip->size)
    800033b8:	04cb2783          	lw	a5,76(s6)
    800033bc:	0127f463          	bgeu	a5,s2,800033c4 <writei+0xe2>
    ip->size = off;
    800033c0:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800033c4:	855a                	mv	a0,s6
    800033c6:	00000097          	auipc	ra,0x0
    800033ca:	aa6080e7          	jalr	-1370(ra) # 80002e6c <iupdate>

  return tot;
    800033ce:	000a051b          	sext.w	a0,s4
}
    800033d2:	70a6                	ld	ra,104(sp)
    800033d4:	7406                	ld	s0,96(sp)
    800033d6:	64e6                	ld	s1,88(sp)
    800033d8:	6946                	ld	s2,80(sp)
    800033da:	69a6                	ld	s3,72(sp)
    800033dc:	6a06                	ld	s4,64(sp)
    800033de:	7ae2                	ld	s5,56(sp)
    800033e0:	7b42                	ld	s6,48(sp)
    800033e2:	7ba2                	ld	s7,40(sp)
    800033e4:	7c02                	ld	s8,32(sp)
    800033e6:	6ce2                	ld	s9,24(sp)
    800033e8:	6d42                	ld	s10,16(sp)
    800033ea:	6da2                	ld	s11,8(sp)
    800033ec:	6165                	addi	sp,sp,112
    800033ee:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800033f0:	8a5e                	mv	s4,s7
    800033f2:	bfc9                	j	800033c4 <writei+0xe2>
    return -1;
    800033f4:	557d                	li	a0,-1
}
    800033f6:	8082                	ret
    return -1;
    800033f8:	557d                	li	a0,-1
    800033fa:	bfe1                	j	800033d2 <writei+0xf0>
    return -1;
    800033fc:	557d                	li	a0,-1
    800033fe:	bfd1                	j	800033d2 <writei+0xf0>

0000000080003400 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003400:	1141                	addi	sp,sp,-16
    80003402:	e406                	sd	ra,8(sp)
    80003404:	e022                	sd	s0,0(sp)
    80003406:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003408:	4639                	li	a2,14
    8000340a:	ffffd097          	auipc	ra,0xffffd
    8000340e:	e46080e7          	jalr	-442(ra) # 80000250 <strncmp>
}
    80003412:	60a2                	ld	ra,8(sp)
    80003414:	6402                	ld	s0,0(sp)
    80003416:	0141                	addi	sp,sp,16
    80003418:	8082                	ret

000000008000341a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000341a:	7139                	addi	sp,sp,-64
    8000341c:	fc06                	sd	ra,56(sp)
    8000341e:	f822                	sd	s0,48(sp)
    80003420:	f426                	sd	s1,40(sp)
    80003422:	f04a                	sd	s2,32(sp)
    80003424:	ec4e                	sd	s3,24(sp)
    80003426:	e852                	sd	s4,16(sp)
    80003428:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000342a:	04451703          	lh	a4,68(a0)
    8000342e:	4785                	li	a5,1
    80003430:	00f71a63          	bne	a4,a5,80003444 <dirlookup+0x2a>
    80003434:	892a                	mv	s2,a0
    80003436:	89ae                	mv	s3,a1
    80003438:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000343a:	457c                	lw	a5,76(a0)
    8000343c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000343e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003440:	e79d                	bnez	a5,8000346e <dirlookup+0x54>
    80003442:	a8a5                	j	800034ba <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003444:	00005517          	auipc	a0,0x5
    80003448:	0fc50513          	addi	a0,a0,252 # 80008540 <syscalls+0x1b0>
    8000344c:	00003097          	auipc	ra,0x3
    80003450:	b9c080e7          	jalr	-1124(ra) # 80005fe8 <panic>
      panic("dirlookup read");
    80003454:	00005517          	auipc	a0,0x5
    80003458:	10450513          	addi	a0,a0,260 # 80008558 <syscalls+0x1c8>
    8000345c:	00003097          	auipc	ra,0x3
    80003460:	b8c080e7          	jalr	-1140(ra) # 80005fe8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003464:	24c1                	addiw	s1,s1,16
    80003466:	04c92783          	lw	a5,76(s2)
    8000346a:	04f4f763          	bgeu	s1,a5,800034b8 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000346e:	4741                	li	a4,16
    80003470:	86a6                	mv	a3,s1
    80003472:	fc040613          	addi	a2,s0,-64
    80003476:	4581                	li	a1,0
    80003478:	854a                	mv	a0,s2
    8000347a:	00000097          	auipc	ra,0x0
    8000347e:	d70080e7          	jalr	-656(ra) # 800031ea <readi>
    80003482:	47c1                	li	a5,16
    80003484:	fcf518e3          	bne	a0,a5,80003454 <dirlookup+0x3a>
    if(de.inum == 0)
    80003488:	fc045783          	lhu	a5,-64(s0)
    8000348c:	dfe1                	beqz	a5,80003464 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000348e:	fc240593          	addi	a1,s0,-62
    80003492:	854e                	mv	a0,s3
    80003494:	00000097          	auipc	ra,0x0
    80003498:	f6c080e7          	jalr	-148(ra) # 80003400 <namecmp>
    8000349c:	f561                	bnez	a0,80003464 <dirlookup+0x4a>
      if(poff)
    8000349e:	000a0463          	beqz	s4,800034a6 <dirlookup+0x8c>
        *poff = off;
    800034a2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800034a6:	fc045583          	lhu	a1,-64(s0)
    800034aa:	00092503          	lw	a0,0(s2)
    800034ae:	fffff097          	auipc	ra,0xfffff
    800034b2:	754080e7          	jalr	1876(ra) # 80002c02 <iget>
    800034b6:	a011                	j	800034ba <dirlookup+0xa0>
  return 0;
    800034b8:	4501                	li	a0,0
}
    800034ba:	70e2                	ld	ra,56(sp)
    800034bc:	7442                	ld	s0,48(sp)
    800034be:	74a2                	ld	s1,40(sp)
    800034c0:	7902                	ld	s2,32(sp)
    800034c2:	69e2                	ld	s3,24(sp)
    800034c4:	6a42                	ld	s4,16(sp)
    800034c6:	6121                	addi	sp,sp,64
    800034c8:	8082                	ret

00000000800034ca <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800034ca:	711d                	addi	sp,sp,-96
    800034cc:	ec86                	sd	ra,88(sp)
    800034ce:	e8a2                	sd	s0,80(sp)
    800034d0:	e4a6                	sd	s1,72(sp)
    800034d2:	e0ca                	sd	s2,64(sp)
    800034d4:	fc4e                	sd	s3,56(sp)
    800034d6:	f852                	sd	s4,48(sp)
    800034d8:	f456                	sd	s5,40(sp)
    800034da:	f05a                	sd	s6,32(sp)
    800034dc:	ec5e                	sd	s7,24(sp)
    800034de:	e862                	sd	s8,16(sp)
    800034e0:	e466                	sd	s9,8(sp)
    800034e2:	1080                	addi	s0,sp,96
    800034e4:	84aa                	mv	s1,a0
    800034e6:	8b2e                	mv	s6,a1
    800034e8:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800034ea:	00054703          	lbu	a4,0(a0)
    800034ee:	02f00793          	li	a5,47
    800034f2:	02f70363          	beq	a4,a5,80003518 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800034f6:	ffffe097          	auipc	ra,0xffffe
    800034fa:	938080e7          	jalr	-1736(ra) # 80000e2e <myproc>
    800034fe:	15053503          	ld	a0,336(a0)
    80003502:	00000097          	auipc	ra,0x0
    80003506:	9f6080e7          	jalr	-1546(ra) # 80002ef8 <idup>
    8000350a:	89aa                	mv	s3,a0
  while(*path == '/')
    8000350c:	02f00913          	li	s2,47
  len = path - s;
    80003510:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003512:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003514:	4c05                	li	s8,1
    80003516:	a865                	j	800035ce <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003518:	4585                	li	a1,1
    8000351a:	4505                	li	a0,1
    8000351c:	fffff097          	auipc	ra,0xfffff
    80003520:	6e6080e7          	jalr	1766(ra) # 80002c02 <iget>
    80003524:	89aa                	mv	s3,a0
    80003526:	b7dd                	j	8000350c <namex+0x42>
      iunlockput(ip);
    80003528:	854e                	mv	a0,s3
    8000352a:	00000097          	auipc	ra,0x0
    8000352e:	c6e080e7          	jalr	-914(ra) # 80003198 <iunlockput>
      return 0;
    80003532:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003534:	854e                	mv	a0,s3
    80003536:	60e6                	ld	ra,88(sp)
    80003538:	6446                	ld	s0,80(sp)
    8000353a:	64a6                	ld	s1,72(sp)
    8000353c:	6906                	ld	s2,64(sp)
    8000353e:	79e2                	ld	s3,56(sp)
    80003540:	7a42                	ld	s4,48(sp)
    80003542:	7aa2                	ld	s5,40(sp)
    80003544:	7b02                	ld	s6,32(sp)
    80003546:	6be2                	ld	s7,24(sp)
    80003548:	6c42                	ld	s8,16(sp)
    8000354a:	6ca2                	ld	s9,8(sp)
    8000354c:	6125                	addi	sp,sp,96
    8000354e:	8082                	ret
      iunlock(ip);
    80003550:	854e                	mv	a0,s3
    80003552:	00000097          	auipc	ra,0x0
    80003556:	aa6080e7          	jalr	-1370(ra) # 80002ff8 <iunlock>
      return ip;
    8000355a:	bfe9                	j	80003534 <namex+0x6a>
      iunlockput(ip);
    8000355c:	854e                	mv	a0,s3
    8000355e:	00000097          	auipc	ra,0x0
    80003562:	c3a080e7          	jalr	-966(ra) # 80003198 <iunlockput>
      return 0;
    80003566:	89d2                	mv	s3,s4
    80003568:	b7f1                	j	80003534 <namex+0x6a>
  len = path - s;
    8000356a:	40b48633          	sub	a2,s1,a1
    8000356e:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003572:	094cd463          	bge	s9,s4,800035fa <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003576:	4639                	li	a2,14
    80003578:	8556                	mv	a0,s5
    8000357a:	ffffd097          	auipc	ra,0xffffd
    8000357e:	c5e080e7          	jalr	-930(ra) # 800001d8 <memmove>
  while(*path == '/')
    80003582:	0004c783          	lbu	a5,0(s1)
    80003586:	01279763          	bne	a5,s2,80003594 <namex+0xca>
    path++;
    8000358a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000358c:	0004c783          	lbu	a5,0(s1)
    80003590:	ff278de3          	beq	a5,s2,8000358a <namex+0xc0>
    ilock(ip);
    80003594:	854e                	mv	a0,s3
    80003596:	00000097          	auipc	ra,0x0
    8000359a:	9a0080e7          	jalr	-1632(ra) # 80002f36 <ilock>
    if(ip->type != T_DIR){
    8000359e:	04499783          	lh	a5,68(s3)
    800035a2:	f98793e3          	bne	a5,s8,80003528 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800035a6:	000b0563          	beqz	s6,800035b0 <namex+0xe6>
    800035aa:	0004c783          	lbu	a5,0(s1)
    800035ae:	d3cd                	beqz	a5,80003550 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800035b0:	865e                	mv	a2,s7
    800035b2:	85d6                	mv	a1,s5
    800035b4:	854e                	mv	a0,s3
    800035b6:	00000097          	auipc	ra,0x0
    800035ba:	e64080e7          	jalr	-412(ra) # 8000341a <dirlookup>
    800035be:	8a2a                	mv	s4,a0
    800035c0:	dd51                	beqz	a0,8000355c <namex+0x92>
    iunlockput(ip);
    800035c2:	854e                	mv	a0,s3
    800035c4:	00000097          	auipc	ra,0x0
    800035c8:	bd4080e7          	jalr	-1068(ra) # 80003198 <iunlockput>
    ip = next;
    800035cc:	89d2                	mv	s3,s4
  while(*path == '/')
    800035ce:	0004c783          	lbu	a5,0(s1)
    800035d2:	05279763          	bne	a5,s2,80003620 <namex+0x156>
    path++;
    800035d6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800035d8:	0004c783          	lbu	a5,0(s1)
    800035dc:	ff278de3          	beq	a5,s2,800035d6 <namex+0x10c>
  if(*path == 0)
    800035e0:	c79d                	beqz	a5,8000360e <namex+0x144>
    path++;
    800035e2:	85a6                	mv	a1,s1
  len = path - s;
    800035e4:	8a5e                	mv	s4,s7
    800035e6:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800035e8:	01278963          	beq	a5,s2,800035fa <namex+0x130>
    800035ec:	dfbd                	beqz	a5,8000356a <namex+0xa0>
    path++;
    800035ee:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800035f0:	0004c783          	lbu	a5,0(s1)
    800035f4:	ff279ce3          	bne	a5,s2,800035ec <namex+0x122>
    800035f8:	bf8d                	j	8000356a <namex+0xa0>
    memmove(name, s, len);
    800035fa:	2601                	sext.w	a2,a2
    800035fc:	8556                	mv	a0,s5
    800035fe:	ffffd097          	auipc	ra,0xffffd
    80003602:	bda080e7          	jalr	-1062(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003606:	9a56                	add	s4,s4,s5
    80003608:	000a0023          	sb	zero,0(s4)
    8000360c:	bf9d                	j	80003582 <namex+0xb8>
  if(nameiparent){
    8000360e:	f20b03e3          	beqz	s6,80003534 <namex+0x6a>
    iput(ip);
    80003612:	854e                	mv	a0,s3
    80003614:	00000097          	auipc	ra,0x0
    80003618:	adc080e7          	jalr	-1316(ra) # 800030f0 <iput>
    return 0;
    8000361c:	4981                	li	s3,0
    8000361e:	bf19                	j	80003534 <namex+0x6a>
  if(*path == 0)
    80003620:	d7fd                	beqz	a5,8000360e <namex+0x144>
  while(*path != '/' && *path != 0)
    80003622:	0004c783          	lbu	a5,0(s1)
    80003626:	85a6                	mv	a1,s1
    80003628:	b7d1                	j	800035ec <namex+0x122>

000000008000362a <dirlink>:
{
    8000362a:	7139                	addi	sp,sp,-64
    8000362c:	fc06                	sd	ra,56(sp)
    8000362e:	f822                	sd	s0,48(sp)
    80003630:	f426                	sd	s1,40(sp)
    80003632:	f04a                	sd	s2,32(sp)
    80003634:	ec4e                	sd	s3,24(sp)
    80003636:	e852                	sd	s4,16(sp)
    80003638:	0080                	addi	s0,sp,64
    8000363a:	892a                	mv	s2,a0
    8000363c:	8a2e                	mv	s4,a1
    8000363e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003640:	4601                	li	a2,0
    80003642:	00000097          	auipc	ra,0x0
    80003646:	dd8080e7          	jalr	-552(ra) # 8000341a <dirlookup>
    8000364a:	e93d                	bnez	a0,800036c0 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000364c:	04c92483          	lw	s1,76(s2)
    80003650:	c49d                	beqz	s1,8000367e <dirlink+0x54>
    80003652:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003654:	4741                	li	a4,16
    80003656:	86a6                	mv	a3,s1
    80003658:	fc040613          	addi	a2,s0,-64
    8000365c:	4581                	li	a1,0
    8000365e:	854a                	mv	a0,s2
    80003660:	00000097          	auipc	ra,0x0
    80003664:	b8a080e7          	jalr	-1142(ra) # 800031ea <readi>
    80003668:	47c1                	li	a5,16
    8000366a:	06f51163          	bne	a0,a5,800036cc <dirlink+0xa2>
    if(de.inum == 0)
    8000366e:	fc045783          	lhu	a5,-64(s0)
    80003672:	c791                	beqz	a5,8000367e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003674:	24c1                	addiw	s1,s1,16
    80003676:	04c92783          	lw	a5,76(s2)
    8000367a:	fcf4ede3          	bltu	s1,a5,80003654 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000367e:	4639                	li	a2,14
    80003680:	85d2                	mv	a1,s4
    80003682:	fc240513          	addi	a0,s0,-62
    80003686:	ffffd097          	auipc	ra,0xffffd
    8000368a:	c06080e7          	jalr	-1018(ra) # 8000028c <strncpy>
  de.inum = inum;
    8000368e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003692:	4741                	li	a4,16
    80003694:	86a6                	mv	a3,s1
    80003696:	fc040613          	addi	a2,s0,-64
    8000369a:	4581                	li	a1,0
    8000369c:	854a                	mv	a0,s2
    8000369e:	00000097          	auipc	ra,0x0
    800036a2:	c44080e7          	jalr	-956(ra) # 800032e2 <writei>
    800036a6:	872a                	mv	a4,a0
    800036a8:	47c1                	li	a5,16
  return 0;
    800036aa:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800036ac:	02f71863          	bne	a4,a5,800036dc <dirlink+0xb2>
}
    800036b0:	70e2                	ld	ra,56(sp)
    800036b2:	7442                	ld	s0,48(sp)
    800036b4:	74a2                	ld	s1,40(sp)
    800036b6:	7902                	ld	s2,32(sp)
    800036b8:	69e2                	ld	s3,24(sp)
    800036ba:	6a42                	ld	s4,16(sp)
    800036bc:	6121                	addi	sp,sp,64
    800036be:	8082                	ret
    iput(ip);
    800036c0:	00000097          	auipc	ra,0x0
    800036c4:	a30080e7          	jalr	-1488(ra) # 800030f0 <iput>
    return -1;
    800036c8:	557d                	li	a0,-1
    800036ca:	b7dd                	j	800036b0 <dirlink+0x86>
      panic("dirlink read");
    800036cc:	00005517          	auipc	a0,0x5
    800036d0:	e9c50513          	addi	a0,a0,-356 # 80008568 <syscalls+0x1d8>
    800036d4:	00003097          	auipc	ra,0x3
    800036d8:	914080e7          	jalr	-1772(ra) # 80005fe8 <panic>
    panic("dirlink");
    800036dc:	00005517          	auipc	a0,0x5
    800036e0:	f9c50513          	addi	a0,a0,-100 # 80008678 <syscalls+0x2e8>
    800036e4:	00003097          	auipc	ra,0x3
    800036e8:	904080e7          	jalr	-1788(ra) # 80005fe8 <panic>

00000000800036ec <namei>:

struct inode*
namei(char *path)
{
    800036ec:	1101                	addi	sp,sp,-32
    800036ee:	ec06                	sd	ra,24(sp)
    800036f0:	e822                	sd	s0,16(sp)
    800036f2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800036f4:	fe040613          	addi	a2,s0,-32
    800036f8:	4581                	li	a1,0
    800036fa:	00000097          	auipc	ra,0x0
    800036fe:	dd0080e7          	jalr	-560(ra) # 800034ca <namex>
}
    80003702:	60e2                	ld	ra,24(sp)
    80003704:	6442                	ld	s0,16(sp)
    80003706:	6105                	addi	sp,sp,32
    80003708:	8082                	ret

000000008000370a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000370a:	1141                	addi	sp,sp,-16
    8000370c:	e406                	sd	ra,8(sp)
    8000370e:	e022                	sd	s0,0(sp)
    80003710:	0800                	addi	s0,sp,16
    80003712:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003714:	4585                	li	a1,1
    80003716:	00000097          	auipc	ra,0x0
    8000371a:	db4080e7          	jalr	-588(ra) # 800034ca <namex>
}
    8000371e:	60a2                	ld	ra,8(sp)
    80003720:	6402                	ld	s0,0(sp)
    80003722:	0141                	addi	sp,sp,16
    80003724:	8082                	ret

0000000080003726 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003726:	1101                	addi	sp,sp,-32
    80003728:	ec06                	sd	ra,24(sp)
    8000372a:	e822                	sd	s0,16(sp)
    8000372c:	e426                	sd	s1,8(sp)
    8000372e:	e04a                	sd	s2,0(sp)
    80003730:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003732:	00020917          	auipc	s2,0x20
    80003736:	cee90913          	addi	s2,s2,-786 # 80023420 <log>
    8000373a:	01892583          	lw	a1,24(s2)
    8000373e:	02892503          	lw	a0,40(s2)
    80003742:	fffff097          	auipc	ra,0xfffff
    80003746:	ff2080e7          	jalr	-14(ra) # 80002734 <bread>
    8000374a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000374c:	02c92683          	lw	a3,44(s2)
    80003750:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003752:	02d05763          	blez	a3,80003780 <write_head+0x5a>
    80003756:	00020797          	auipc	a5,0x20
    8000375a:	cfa78793          	addi	a5,a5,-774 # 80023450 <log+0x30>
    8000375e:	05c50713          	addi	a4,a0,92
    80003762:	36fd                	addiw	a3,a3,-1
    80003764:	1682                	slli	a3,a3,0x20
    80003766:	9281                	srli	a3,a3,0x20
    80003768:	068a                	slli	a3,a3,0x2
    8000376a:	00020617          	auipc	a2,0x20
    8000376e:	cea60613          	addi	a2,a2,-790 # 80023454 <log+0x34>
    80003772:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003774:	4390                	lw	a2,0(a5)
    80003776:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003778:	0791                	addi	a5,a5,4
    8000377a:	0711                	addi	a4,a4,4
    8000377c:	fed79ce3          	bne	a5,a3,80003774 <write_head+0x4e>
  }
  bwrite(buf);
    80003780:	8526                	mv	a0,s1
    80003782:	fffff097          	auipc	ra,0xfffff
    80003786:	0a4080e7          	jalr	164(ra) # 80002826 <bwrite>
  brelse(buf);
    8000378a:	8526                	mv	a0,s1
    8000378c:	fffff097          	auipc	ra,0xfffff
    80003790:	0d8080e7          	jalr	216(ra) # 80002864 <brelse>
}
    80003794:	60e2                	ld	ra,24(sp)
    80003796:	6442                	ld	s0,16(sp)
    80003798:	64a2                	ld	s1,8(sp)
    8000379a:	6902                	ld	s2,0(sp)
    8000379c:	6105                	addi	sp,sp,32
    8000379e:	8082                	ret

00000000800037a0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800037a0:	00020797          	auipc	a5,0x20
    800037a4:	cac7a783          	lw	a5,-852(a5) # 8002344c <log+0x2c>
    800037a8:	0af05d63          	blez	a5,80003862 <install_trans+0xc2>
{
    800037ac:	7139                	addi	sp,sp,-64
    800037ae:	fc06                	sd	ra,56(sp)
    800037b0:	f822                	sd	s0,48(sp)
    800037b2:	f426                	sd	s1,40(sp)
    800037b4:	f04a                	sd	s2,32(sp)
    800037b6:	ec4e                	sd	s3,24(sp)
    800037b8:	e852                	sd	s4,16(sp)
    800037ba:	e456                	sd	s5,8(sp)
    800037bc:	e05a                	sd	s6,0(sp)
    800037be:	0080                	addi	s0,sp,64
    800037c0:	8b2a                	mv	s6,a0
    800037c2:	00020a97          	auipc	s5,0x20
    800037c6:	c8ea8a93          	addi	s5,s5,-882 # 80023450 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037ca:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800037cc:	00020997          	auipc	s3,0x20
    800037d0:	c5498993          	addi	s3,s3,-940 # 80023420 <log>
    800037d4:	a035                	j	80003800 <install_trans+0x60>
      bunpin(dbuf);
    800037d6:	8526                	mv	a0,s1
    800037d8:	fffff097          	auipc	ra,0xfffff
    800037dc:	166080e7          	jalr	358(ra) # 8000293e <bunpin>
    brelse(lbuf);
    800037e0:	854a                	mv	a0,s2
    800037e2:	fffff097          	auipc	ra,0xfffff
    800037e6:	082080e7          	jalr	130(ra) # 80002864 <brelse>
    brelse(dbuf);
    800037ea:	8526                	mv	a0,s1
    800037ec:	fffff097          	auipc	ra,0xfffff
    800037f0:	078080e7          	jalr	120(ra) # 80002864 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037f4:	2a05                	addiw	s4,s4,1
    800037f6:	0a91                	addi	s5,s5,4
    800037f8:	02c9a783          	lw	a5,44(s3)
    800037fc:	04fa5963          	bge	s4,a5,8000384e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003800:	0189a583          	lw	a1,24(s3)
    80003804:	014585bb          	addw	a1,a1,s4
    80003808:	2585                	addiw	a1,a1,1
    8000380a:	0289a503          	lw	a0,40(s3)
    8000380e:	fffff097          	auipc	ra,0xfffff
    80003812:	f26080e7          	jalr	-218(ra) # 80002734 <bread>
    80003816:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003818:	000aa583          	lw	a1,0(s5)
    8000381c:	0289a503          	lw	a0,40(s3)
    80003820:	fffff097          	auipc	ra,0xfffff
    80003824:	f14080e7          	jalr	-236(ra) # 80002734 <bread>
    80003828:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000382a:	40000613          	li	a2,1024
    8000382e:	05890593          	addi	a1,s2,88
    80003832:	05850513          	addi	a0,a0,88
    80003836:	ffffd097          	auipc	ra,0xffffd
    8000383a:	9a2080e7          	jalr	-1630(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000383e:	8526                	mv	a0,s1
    80003840:	fffff097          	auipc	ra,0xfffff
    80003844:	fe6080e7          	jalr	-26(ra) # 80002826 <bwrite>
    if(recovering == 0)
    80003848:	f80b1ce3          	bnez	s6,800037e0 <install_trans+0x40>
    8000384c:	b769                	j	800037d6 <install_trans+0x36>
}
    8000384e:	70e2                	ld	ra,56(sp)
    80003850:	7442                	ld	s0,48(sp)
    80003852:	74a2                	ld	s1,40(sp)
    80003854:	7902                	ld	s2,32(sp)
    80003856:	69e2                	ld	s3,24(sp)
    80003858:	6a42                	ld	s4,16(sp)
    8000385a:	6aa2                	ld	s5,8(sp)
    8000385c:	6b02                	ld	s6,0(sp)
    8000385e:	6121                	addi	sp,sp,64
    80003860:	8082                	ret
    80003862:	8082                	ret

0000000080003864 <initlog>:
{
    80003864:	7179                	addi	sp,sp,-48
    80003866:	f406                	sd	ra,40(sp)
    80003868:	f022                	sd	s0,32(sp)
    8000386a:	ec26                	sd	s1,24(sp)
    8000386c:	e84a                	sd	s2,16(sp)
    8000386e:	e44e                	sd	s3,8(sp)
    80003870:	1800                	addi	s0,sp,48
    80003872:	892a                	mv	s2,a0
    80003874:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003876:	00020497          	auipc	s1,0x20
    8000387a:	baa48493          	addi	s1,s1,-1110 # 80023420 <log>
    8000387e:	00005597          	auipc	a1,0x5
    80003882:	cfa58593          	addi	a1,a1,-774 # 80008578 <syscalls+0x1e8>
    80003886:	8526                	mv	a0,s1
    80003888:	00003097          	auipc	ra,0x3
    8000388c:	c1a080e7          	jalr	-998(ra) # 800064a2 <initlock>
  log.start = sb->logstart;
    80003890:	0149a583          	lw	a1,20(s3)
    80003894:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003896:	0109a783          	lw	a5,16(s3)
    8000389a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000389c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800038a0:	854a                	mv	a0,s2
    800038a2:	fffff097          	auipc	ra,0xfffff
    800038a6:	e92080e7          	jalr	-366(ra) # 80002734 <bread>
  log.lh.n = lh->n;
    800038aa:	4d3c                	lw	a5,88(a0)
    800038ac:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800038ae:	02f05563          	blez	a5,800038d8 <initlog+0x74>
    800038b2:	05c50713          	addi	a4,a0,92
    800038b6:	00020697          	auipc	a3,0x20
    800038ba:	b9a68693          	addi	a3,a3,-1126 # 80023450 <log+0x30>
    800038be:	37fd                	addiw	a5,a5,-1
    800038c0:	1782                	slli	a5,a5,0x20
    800038c2:	9381                	srli	a5,a5,0x20
    800038c4:	078a                	slli	a5,a5,0x2
    800038c6:	06050613          	addi	a2,a0,96
    800038ca:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800038cc:	4310                	lw	a2,0(a4)
    800038ce:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800038d0:	0711                	addi	a4,a4,4
    800038d2:	0691                	addi	a3,a3,4
    800038d4:	fef71ce3          	bne	a4,a5,800038cc <initlog+0x68>
  brelse(buf);
    800038d8:	fffff097          	auipc	ra,0xfffff
    800038dc:	f8c080e7          	jalr	-116(ra) # 80002864 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800038e0:	4505                	li	a0,1
    800038e2:	00000097          	auipc	ra,0x0
    800038e6:	ebe080e7          	jalr	-322(ra) # 800037a0 <install_trans>
  log.lh.n = 0;
    800038ea:	00020797          	auipc	a5,0x20
    800038ee:	b607a123          	sw	zero,-1182(a5) # 8002344c <log+0x2c>
  write_head(); // clear the log
    800038f2:	00000097          	auipc	ra,0x0
    800038f6:	e34080e7          	jalr	-460(ra) # 80003726 <write_head>
}
    800038fa:	70a2                	ld	ra,40(sp)
    800038fc:	7402                	ld	s0,32(sp)
    800038fe:	64e2                	ld	s1,24(sp)
    80003900:	6942                	ld	s2,16(sp)
    80003902:	69a2                	ld	s3,8(sp)
    80003904:	6145                	addi	sp,sp,48
    80003906:	8082                	ret

0000000080003908 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003908:	1101                	addi	sp,sp,-32
    8000390a:	ec06                	sd	ra,24(sp)
    8000390c:	e822                	sd	s0,16(sp)
    8000390e:	e426                	sd	s1,8(sp)
    80003910:	e04a                	sd	s2,0(sp)
    80003912:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003914:	00020517          	auipc	a0,0x20
    80003918:	b0c50513          	addi	a0,a0,-1268 # 80023420 <log>
    8000391c:	00003097          	auipc	ra,0x3
    80003920:	c16080e7          	jalr	-1002(ra) # 80006532 <acquire>
  while(1){
    if(log.committing){
    80003924:	00020497          	auipc	s1,0x20
    80003928:	afc48493          	addi	s1,s1,-1284 # 80023420 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000392c:	4979                	li	s2,30
    8000392e:	a039                	j	8000393c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003930:	85a6                	mv	a1,s1
    80003932:	8526                	mv	a0,s1
    80003934:	ffffe097          	auipc	ra,0xffffe
    80003938:	c7a080e7          	jalr	-902(ra) # 800015ae <sleep>
    if(log.committing){
    8000393c:	50dc                	lw	a5,36(s1)
    8000393e:	fbed                	bnez	a5,80003930 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003940:	509c                	lw	a5,32(s1)
    80003942:	0017871b          	addiw	a4,a5,1
    80003946:	0007069b          	sext.w	a3,a4
    8000394a:	0027179b          	slliw	a5,a4,0x2
    8000394e:	9fb9                	addw	a5,a5,a4
    80003950:	0017979b          	slliw	a5,a5,0x1
    80003954:	54d8                	lw	a4,44(s1)
    80003956:	9fb9                	addw	a5,a5,a4
    80003958:	00f95963          	bge	s2,a5,8000396a <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000395c:	85a6                	mv	a1,s1
    8000395e:	8526                	mv	a0,s1
    80003960:	ffffe097          	auipc	ra,0xffffe
    80003964:	c4e080e7          	jalr	-946(ra) # 800015ae <sleep>
    80003968:	bfd1                	j	8000393c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000396a:	00020517          	auipc	a0,0x20
    8000396e:	ab650513          	addi	a0,a0,-1354 # 80023420 <log>
    80003972:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003974:	00003097          	auipc	ra,0x3
    80003978:	c72080e7          	jalr	-910(ra) # 800065e6 <release>
      break;
    }
  }
}
    8000397c:	60e2                	ld	ra,24(sp)
    8000397e:	6442                	ld	s0,16(sp)
    80003980:	64a2                	ld	s1,8(sp)
    80003982:	6902                	ld	s2,0(sp)
    80003984:	6105                	addi	sp,sp,32
    80003986:	8082                	ret

0000000080003988 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003988:	7139                	addi	sp,sp,-64
    8000398a:	fc06                	sd	ra,56(sp)
    8000398c:	f822                	sd	s0,48(sp)
    8000398e:	f426                	sd	s1,40(sp)
    80003990:	f04a                	sd	s2,32(sp)
    80003992:	ec4e                	sd	s3,24(sp)
    80003994:	e852                	sd	s4,16(sp)
    80003996:	e456                	sd	s5,8(sp)
    80003998:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000399a:	00020497          	auipc	s1,0x20
    8000399e:	a8648493          	addi	s1,s1,-1402 # 80023420 <log>
    800039a2:	8526                	mv	a0,s1
    800039a4:	00003097          	auipc	ra,0x3
    800039a8:	b8e080e7          	jalr	-1138(ra) # 80006532 <acquire>
  log.outstanding -= 1;
    800039ac:	509c                	lw	a5,32(s1)
    800039ae:	37fd                	addiw	a5,a5,-1
    800039b0:	0007891b          	sext.w	s2,a5
    800039b4:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800039b6:	50dc                	lw	a5,36(s1)
    800039b8:	efb9                	bnez	a5,80003a16 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800039ba:	06091663          	bnez	s2,80003a26 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800039be:	00020497          	auipc	s1,0x20
    800039c2:	a6248493          	addi	s1,s1,-1438 # 80023420 <log>
    800039c6:	4785                	li	a5,1
    800039c8:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800039ca:	8526                	mv	a0,s1
    800039cc:	00003097          	auipc	ra,0x3
    800039d0:	c1a080e7          	jalr	-998(ra) # 800065e6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800039d4:	54dc                	lw	a5,44(s1)
    800039d6:	06f04763          	bgtz	a5,80003a44 <end_op+0xbc>
    acquire(&log.lock);
    800039da:	00020497          	auipc	s1,0x20
    800039de:	a4648493          	addi	s1,s1,-1466 # 80023420 <log>
    800039e2:	8526                	mv	a0,s1
    800039e4:	00003097          	auipc	ra,0x3
    800039e8:	b4e080e7          	jalr	-1202(ra) # 80006532 <acquire>
    log.committing = 0;
    800039ec:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800039f0:	8526                	mv	a0,s1
    800039f2:	ffffe097          	auipc	ra,0xffffe
    800039f6:	d48080e7          	jalr	-696(ra) # 8000173a <wakeup>
    release(&log.lock);
    800039fa:	8526                	mv	a0,s1
    800039fc:	00003097          	auipc	ra,0x3
    80003a00:	bea080e7          	jalr	-1046(ra) # 800065e6 <release>
}
    80003a04:	70e2                	ld	ra,56(sp)
    80003a06:	7442                	ld	s0,48(sp)
    80003a08:	74a2                	ld	s1,40(sp)
    80003a0a:	7902                	ld	s2,32(sp)
    80003a0c:	69e2                	ld	s3,24(sp)
    80003a0e:	6a42                	ld	s4,16(sp)
    80003a10:	6aa2                	ld	s5,8(sp)
    80003a12:	6121                	addi	sp,sp,64
    80003a14:	8082                	ret
    panic("log.committing");
    80003a16:	00005517          	auipc	a0,0x5
    80003a1a:	b6a50513          	addi	a0,a0,-1174 # 80008580 <syscalls+0x1f0>
    80003a1e:	00002097          	auipc	ra,0x2
    80003a22:	5ca080e7          	jalr	1482(ra) # 80005fe8 <panic>
    wakeup(&log);
    80003a26:	00020497          	auipc	s1,0x20
    80003a2a:	9fa48493          	addi	s1,s1,-1542 # 80023420 <log>
    80003a2e:	8526                	mv	a0,s1
    80003a30:	ffffe097          	auipc	ra,0xffffe
    80003a34:	d0a080e7          	jalr	-758(ra) # 8000173a <wakeup>
  release(&log.lock);
    80003a38:	8526                	mv	a0,s1
    80003a3a:	00003097          	auipc	ra,0x3
    80003a3e:	bac080e7          	jalr	-1108(ra) # 800065e6 <release>
  if(do_commit){
    80003a42:	b7c9                	j	80003a04 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a44:	00020a97          	auipc	s5,0x20
    80003a48:	a0ca8a93          	addi	s5,s5,-1524 # 80023450 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003a4c:	00020a17          	auipc	s4,0x20
    80003a50:	9d4a0a13          	addi	s4,s4,-1580 # 80023420 <log>
    80003a54:	018a2583          	lw	a1,24(s4)
    80003a58:	012585bb          	addw	a1,a1,s2
    80003a5c:	2585                	addiw	a1,a1,1
    80003a5e:	028a2503          	lw	a0,40(s4)
    80003a62:	fffff097          	auipc	ra,0xfffff
    80003a66:	cd2080e7          	jalr	-814(ra) # 80002734 <bread>
    80003a6a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003a6c:	000aa583          	lw	a1,0(s5)
    80003a70:	028a2503          	lw	a0,40(s4)
    80003a74:	fffff097          	auipc	ra,0xfffff
    80003a78:	cc0080e7          	jalr	-832(ra) # 80002734 <bread>
    80003a7c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003a7e:	40000613          	li	a2,1024
    80003a82:	05850593          	addi	a1,a0,88
    80003a86:	05848513          	addi	a0,s1,88
    80003a8a:	ffffc097          	auipc	ra,0xffffc
    80003a8e:	74e080e7          	jalr	1870(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003a92:	8526                	mv	a0,s1
    80003a94:	fffff097          	auipc	ra,0xfffff
    80003a98:	d92080e7          	jalr	-622(ra) # 80002826 <bwrite>
    brelse(from);
    80003a9c:	854e                	mv	a0,s3
    80003a9e:	fffff097          	auipc	ra,0xfffff
    80003aa2:	dc6080e7          	jalr	-570(ra) # 80002864 <brelse>
    brelse(to);
    80003aa6:	8526                	mv	a0,s1
    80003aa8:	fffff097          	auipc	ra,0xfffff
    80003aac:	dbc080e7          	jalr	-580(ra) # 80002864 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ab0:	2905                	addiw	s2,s2,1
    80003ab2:	0a91                	addi	s5,s5,4
    80003ab4:	02ca2783          	lw	a5,44(s4)
    80003ab8:	f8f94ee3          	blt	s2,a5,80003a54 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003abc:	00000097          	auipc	ra,0x0
    80003ac0:	c6a080e7          	jalr	-918(ra) # 80003726 <write_head>
    install_trans(0); // Now install writes to home locations
    80003ac4:	4501                	li	a0,0
    80003ac6:	00000097          	auipc	ra,0x0
    80003aca:	cda080e7          	jalr	-806(ra) # 800037a0 <install_trans>
    log.lh.n = 0;
    80003ace:	00020797          	auipc	a5,0x20
    80003ad2:	9607af23          	sw	zero,-1666(a5) # 8002344c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003ad6:	00000097          	auipc	ra,0x0
    80003ada:	c50080e7          	jalr	-944(ra) # 80003726 <write_head>
    80003ade:	bdf5                	j	800039da <end_op+0x52>

0000000080003ae0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003ae0:	1101                	addi	sp,sp,-32
    80003ae2:	ec06                	sd	ra,24(sp)
    80003ae4:	e822                	sd	s0,16(sp)
    80003ae6:	e426                	sd	s1,8(sp)
    80003ae8:	e04a                	sd	s2,0(sp)
    80003aea:	1000                	addi	s0,sp,32
    80003aec:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003aee:	00020917          	auipc	s2,0x20
    80003af2:	93290913          	addi	s2,s2,-1742 # 80023420 <log>
    80003af6:	854a                	mv	a0,s2
    80003af8:	00003097          	auipc	ra,0x3
    80003afc:	a3a080e7          	jalr	-1478(ra) # 80006532 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003b00:	02c92603          	lw	a2,44(s2)
    80003b04:	47f5                	li	a5,29
    80003b06:	06c7c563          	blt	a5,a2,80003b70 <log_write+0x90>
    80003b0a:	00020797          	auipc	a5,0x20
    80003b0e:	9327a783          	lw	a5,-1742(a5) # 8002343c <log+0x1c>
    80003b12:	37fd                	addiw	a5,a5,-1
    80003b14:	04f65e63          	bge	a2,a5,80003b70 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003b18:	00020797          	auipc	a5,0x20
    80003b1c:	9287a783          	lw	a5,-1752(a5) # 80023440 <log+0x20>
    80003b20:	06f05063          	blez	a5,80003b80 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003b24:	4781                	li	a5,0
    80003b26:	06c05563          	blez	a2,80003b90 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003b2a:	44cc                	lw	a1,12(s1)
    80003b2c:	00020717          	auipc	a4,0x20
    80003b30:	92470713          	addi	a4,a4,-1756 # 80023450 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003b34:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003b36:	4314                	lw	a3,0(a4)
    80003b38:	04b68c63          	beq	a3,a1,80003b90 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003b3c:	2785                	addiw	a5,a5,1
    80003b3e:	0711                	addi	a4,a4,4
    80003b40:	fef61be3          	bne	a2,a5,80003b36 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003b44:	0621                	addi	a2,a2,8
    80003b46:	060a                	slli	a2,a2,0x2
    80003b48:	00020797          	auipc	a5,0x20
    80003b4c:	8d878793          	addi	a5,a5,-1832 # 80023420 <log>
    80003b50:	963e                	add	a2,a2,a5
    80003b52:	44dc                	lw	a5,12(s1)
    80003b54:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003b56:	8526                	mv	a0,s1
    80003b58:	fffff097          	auipc	ra,0xfffff
    80003b5c:	daa080e7          	jalr	-598(ra) # 80002902 <bpin>
    log.lh.n++;
    80003b60:	00020717          	auipc	a4,0x20
    80003b64:	8c070713          	addi	a4,a4,-1856 # 80023420 <log>
    80003b68:	575c                	lw	a5,44(a4)
    80003b6a:	2785                	addiw	a5,a5,1
    80003b6c:	d75c                	sw	a5,44(a4)
    80003b6e:	a835                	j	80003baa <log_write+0xca>
    panic("too big a transaction");
    80003b70:	00005517          	auipc	a0,0x5
    80003b74:	a2050513          	addi	a0,a0,-1504 # 80008590 <syscalls+0x200>
    80003b78:	00002097          	auipc	ra,0x2
    80003b7c:	470080e7          	jalr	1136(ra) # 80005fe8 <panic>
    panic("log_write outside of trans");
    80003b80:	00005517          	auipc	a0,0x5
    80003b84:	a2850513          	addi	a0,a0,-1496 # 800085a8 <syscalls+0x218>
    80003b88:	00002097          	auipc	ra,0x2
    80003b8c:	460080e7          	jalr	1120(ra) # 80005fe8 <panic>
  log.lh.block[i] = b->blockno;
    80003b90:	00878713          	addi	a4,a5,8
    80003b94:	00271693          	slli	a3,a4,0x2
    80003b98:	00020717          	auipc	a4,0x20
    80003b9c:	88870713          	addi	a4,a4,-1912 # 80023420 <log>
    80003ba0:	9736                	add	a4,a4,a3
    80003ba2:	44d4                	lw	a3,12(s1)
    80003ba4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003ba6:	faf608e3          	beq	a2,a5,80003b56 <log_write+0x76>
  }
  release(&log.lock);
    80003baa:	00020517          	auipc	a0,0x20
    80003bae:	87650513          	addi	a0,a0,-1930 # 80023420 <log>
    80003bb2:	00003097          	auipc	ra,0x3
    80003bb6:	a34080e7          	jalr	-1484(ra) # 800065e6 <release>
}
    80003bba:	60e2                	ld	ra,24(sp)
    80003bbc:	6442                	ld	s0,16(sp)
    80003bbe:	64a2                	ld	s1,8(sp)
    80003bc0:	6902                	ld	s2,0(sp)
    80003bc2:	6105                	addi	sp,sp,32
    80003bc4:	8082                	ret

0000000080003bc6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003bc6:	1101                	addi	sp,sp,-32
    80003bc8:	ec06                	sd	ra,24(sp)
    80003bca:	e822                	sd	s0,16(sp)
    80003bcc:	e426                	sd	s1,8(sp)
    80003bce:	e04a                	sd	s2,0(sp)
    80003bd0:	1000                	addi	s0,sp,32
    80003bd2:	84aa                	mv	s1,a0
    80003bd4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003bd6:	00005597          	auipc	a1,0x5
    80003bda:	9f258593          	addi	a1,a1,-1550 # 800085c8 <syscalls+0x238>
    80003bde:	0521                	addi	a0,a0,8
    80003be0:	00003097          	auipc	ra,0x3
    80003be4:	8c2080e7          	jalr	-1854(ra) # 800064a2 <initlock>
  lk->name = name;
    80003be8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003bec:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003bf0:	0204a423          	sw	zero,40(s1)
}
    80003bf4:	60e2                	ld	ra,24(sp)
    80003bf6:	6442                	ld	s0,16(sp)
    80003bf8:	64a2                	ld	s1,8(sp)
    80003bfa:	6902                	ld	s2,0(sp)
    80003bfc:	6105                	addi	sp,sp,32
    80003bfe:	8082                	ret

0000000080003c00 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003c00:	1101                	addi	sp,sp,-32
    80003c02:	ec06                	sd	ra,24(sp)
    80003c04:	e822                	sd	s0,16(sp)
    80003c06:	e426                	sd	s1,8(sp)
    80003c08:	e04a                	sd	s2,0(sp)
    80003c0a:	1000                	addi	s0,sp,32
    80003c0c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003c0e:	00850913          	addi	s2,a0,8
    80003c12:	854a                	mv	a0,s2
    80003c14:	00003097          	auipc	ra,0x3
    80003c18:	91e080e7          	jalr	-1762(ra) # 80006532 <acquire>
  while (lk->locked) {
    80003c1c:	409c                	lw	a5,0(s1)
    80003c1e:	cb89                	beqz	a5,80003c30 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003c20:	85ca                	mv	a1,s2
    80003c22:	8526                	mv	a0,s1
    80003c24:	ffffe097          	auipc	ra,0xffffe
    80003c28:	98a080e7          	jalr	-1654(ra) # 800015ae <sleep>
  while (lk->locked) {
    80003c2c:	409c                	lw	a5,0(s1)
    80003c2e:	fbed                	bnez	a5,80003c20 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003c30:	4785                	li	a5,1
    80003c32:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003c34:	ffffd097          	auipc	ra,0xffffd
    80003c38:	1fa080e7          	jalr	506(ra) # 80000e2e <myproc>
    80003c3c:	591c                	lw	a5,48(a0)
    80003c3e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003c40:	854a                	mv	a0,s2
    80003c42:	00003097          	auipc	ra,0x3
    80003c46:	9a4080e7          	jalr	-1628(ra) # 800065e6 <release>
}
    80003c4a:	60e2                	ld	ra,24(sp)
    80003c4c:	6442                	ld	s0,16(sp)
    80003c4e:	64a2                	ld	s1,8(sp)
    80003c50:	6902                	ld	s2,0(sp)
    80003c52:	6105                	addi	sp,sp,32
    80003c54:	8082                	ret

0000000080003c56 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003c56:	1101                	addi	sp,sp,-32
    80003c58:	ec06                	sd	ra,24(sp)
    80003c5a:	e822                	sd	s0,16(sp)
    80003c5c:	e426                	sd	s1,8(sp)
    80003c5e:	e04a                	sd	s2,0(sp)
    80003c60:	1000                	addi	s0,sp,32
    80003c62:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003c64:	00850913          	addi	s2,a0,8
    80003c68:	854a                	mv	a0,s2
    80003c6a:	00003097          	auipc	ra,0x3
    80003c6e:	8c8080e7          	jalr	-1848(ra) # 80006532 <acquire>
  lk->locked = 0;
    80003c72:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003c76:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003c7a:	8526                	mv	a0,s1
    80003c7c:	ffffe097          	auipc	ra,0xffffe
    80003c80:	abe080e7          	jalr	-1346(ra) # 8000173a <wakeup>
  release(&lk->lk);
    80003c84:	854a                	mv	a0,s2
    80003c86:	00003097          	auipc	ra,0x3
    80003c8a:	960080e7          	jalr	-1696(ra) # 800065e6 <release>
}
    80003c8e:	60e2                	ld	ra,24(sp)
    80003c90:	6442                	ld	s0,16(sp)
    80003c92:	64a2                	ld	s1,8(sp)
    80003c94:	6902                	ld	s2,0(sp)
    80003c96:	6105                	addi	sp,sp,32
    80003c98:	8082                	ret

0000000080003c9a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003c9a:	7179                	addi	sp,sp,-48
    80003c9c:	f406                	sd	ra,40(sp)
    80003c9e:	f022                	sd	s0,32(sp)
    80003ca0:	ec26                	sd	s1,24(sp)
    80003ca2:	e84a                	sd	s2,16(sp)
    80003ca4:	e44e                	sd	s3,8(sp)
    80003ca6:	1800                	addi	s0,sp,48
    80003ca8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003caa:	00850913          	addi	s2,a0,8
    80003cae:	854a                	mv	a0,s2
    80003cb0:	00003097          	auipc	ra,0x3
    80003cb4:	882080e7          	jalr	-1918(ra) # 80006532 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003cb8:	409c                	lw	a5,0(s1)
    80003cba:	ef99                	bnez	a5,80003cd8 <holdingsleep+0x3e>
    80003cbc:	4481                	li	s1,0
  release(&lk->lk);
    80003cbe:	854a                	mv	a0,s2
    80003cc0:	00003097          	auipc	ra,0x3
    80003cc4:	926080e7          	jalr	-1754(ra) # 800065e6 <release>
  return r;
}
    80003cc8:	8526                	mv	a0,s1
    80003cca:	70a2                	ld	ra,40(sp)
    80003ccc:	7402                	ld	s0,32(sp)
    80003cce:	64e2                	ld	s1,24(sp)
    80003cd0:	6942                	ld	s2,16(sp)
    80003cd2:	69a2                	ld	s3,8(sp)
    80003cd4:	6145                	addi	sp,sp,48
    80003cd6:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003cd8:	0284a983          	lw	s3,40(s1)
    80003cdc:	ffffd097          	auipc	ra,0xffffd
    80003ce0:	152080e7          	jalr	338(ra) # 80000e2e <myproc>
    80003ce4:	5904                	lw	s1,48(a0)
    80003ce6:	413484b3          	sub	s1,s1,s3
    80003cea:	0014b493          	seqz	s1,s1
    80003cee:	bfc1                	j	80003cbe <holdingsleep+0x24>

0000000080003cf0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003cf0:	1141                	addi	sp,sp,-16
    80003cf2:	e406                	sd	ra,8(sp)
    80003cf4:	e022                	sd	s0,0(sp)
    80003cf6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003cf8:	00005597          	auipc	a1,0x5
    80003cfc:	8e058593          	addi	a1,a1,-1824 # 800085d8 <syscalls+0x248>
    80003d00:	00020517          	auipc	a0,0x20
    80003d04:	86850513          	addi	a0,a0,-1944 # 80023568 <ftable>
    80003d08:	00002097          	auipc	ra,0x2
    80003d0c:	79a080e7          	jalr	1946(ra) # 800064a2 <initlock>
}
    80003d10:	60a2                	ld	ra,8(sp)
    80003d12:	6402                	ld	s0,0(sp)
    80003d14:	0141                	addi	sp,sp,16
    80003d16:	8082                	ret

0000000080003d18 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003d18:	1101                	addi	sp,sp,-32
    80003d1a:	ec06                	sd	ra,24(sp)
    80003d1c:	e822                	sd	s0,16(sp)
    80003d1e:	e426                	sd	s1,8(sp)
    80003d20:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003d22:	00020517          	auipc	a0,0x20
    80003d26:	84650513          	addi	a0,a0,-1978 # 80023568 <ftable>
    80003d2a:	00003097          	auipc	ra,0x3
    80003d2e:	808080e7          	jalr	-2040(ra) # 80006532 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003d32:	00020497          	auipc	s1,0x20
    80003d36:	84e48493          	addi	s1,s1,-1970 # 80023580 <ftable+0x18>
    80003d3a:	00020717          	auipc	a4,0x20
    80003d3e:	7e670713          	addi	a4,a4,2022 # 80024520 <ftable+0xfb8>
    if(f->ref == 0){
    80003d42:	40dc                	lw	a5,4(s1)
    80003d44:	cf99                	beqz	a5,80003d62 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003d46:	02848493          	addi	s1,s1,40
    80003d4a:	fee49ce3          	bne	s1,a4,80003d42 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003d4e:	00020517          	auipc	a0,0x20
    80003d52:	81a50513          	addi	a0,a0,-2022 # 80023568 <ftable>
    80003d56:	00003097          	auipc	ra,0x3
    80003d5a:	890080e7          	jalr	-1904(ra) # 800065e6 <release>
  return 0;
    80003d5e:	4481                	li	s1,0
    80003d60:	a819                	j	80003d76 <filealloc+0x5e>
      f->ref = 1;
    80003d62:	4785                	li	a5,1
    80003d64:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003d66:	00020517          	auipc	a0,0x20
    80003d6a:	80250513          	addi	a0,a0,-2046 # 80023568 <ftable>
    80003d6e:	00003097          	auipc	ra,0x3
    80003d72:	878080e7          	jalr	-1928(ra) # 800065e6 <release>
}
    80003d76:	8526                	mv	a0,s1
    80003d78:	60e2                	ld	ra,24(sp)
    80003d7a:	6442                	ld	s0,16(sp)
    80003d7c:	64a2                	ld	s1,8(sp)
    80003d7e:	6105                	addi	sp,sp,32
    80003d80:	8082                	ret

0000000080003d82 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003d82:	1101                	addi	sp,sp,-32
    80003d84:	ec06                	sd	ra,24(sp)
    80003d86:	e822                	sd	s0,16(sp)
    80003d88:	e426                	sd	s1,8(sp)
    80003d8a:	1000                	addi	s0,sp,32
    80003d8c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003d8e:	0001f517          	auipc	a0,0x1f
    80003d92:	7da50513          	addi	a0,a0,2010 # 80023568 <ftable>
    80003d96:	00002097          	auipc	ra,0x2
    80003d9a:	79c080e7          	jalr	1948(ra) # 80006532 <acquire>
  if(f->ref < 1)
    80003d9e:	40dc                	lw	a5,4(s1)
    80003da0:	02f05263          	blez	a5,80003dc4 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003da4:	2785                	addiw	a5,a5,1
    80003da6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003da8:	0001f517          	auipc	a0,0x1f
    80003dac:	7c050513          	addi	a0,a0,1984 # 80023568 <ftable>
    80003db0:	00003097          	auipc	ra,0x3
    80003db4:	836080e7          	jalr	-1994(ra) # 800065e6 <release>
  return f;
}
    80003db8:	8526                	mv	a0,s1
    80003dba:	60e2                	ld	ra,24(sp)
    80003dbc:	6442                	ld	s0,16(sp)
    80003dbe:	64a2                	ld	s1,8(sp)
    80003dc0:	6105                	addi	sp,sp,32
    80003dc2:	8082                	ret
    panic("filedup");
    80003dc4:	00005517          	auipc	a0,0x5
    80003dc8:	81c50513          	addi	a0,a0,-2020 # 800085e0 <syscalls+0x250>
    80003dcc:	00002097          	auipc	ra,0x2
    80003dd0:	21c080e7          	jalr	540(ra) # 80005fe8 <panic>

0000000080003dd4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003dd4:	7139                	addi	sp,sp,-64
    80003dd6:	fc06                	sd	ra,56(sp)
    80003dd8:	f822                	sd	s0,48(sp)
    80003dda:	f426                	sd	s1,40(sp)
    80003ddc:	f04a                	sd	s2,32(sp)
    80003dde:	ec4e                	sd	s3,24(sp)
    80003de0:	e852                	sd	s4,16(sp)
    80003de2:	e456                	sd	s5,8(sp)
    80003de4:	0080                	addi	s0,sp,64
    80003de6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003de8:	0001f517          	auipc	a0,0x1f
    80003dec:	78050513          	addi	a0,a0,1920 # 80023568 <ftable>
    80003df0:	00002097          	auipc	ra,0x2
    80003df4:	742080e7          	jalr	1858(ra) # 80006532 <acquire>
  if(f->ref < 1)
    80003df8:	40dc                	lw	a5,4(s1)
    80003dfa:	06f05163          	blez	a5,80003e5c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003dfe:	37fd                	addiw	a5,a5,-1
    80003e00:	0007871b          	sext.w	a4,a5
    80003e04:	c0dc                	sw	a5,4(s1)
    80003e06:	06e04363          	bgtz	a4,80003e6c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003e0a:	0004a903          	lw	s2,0(s1)
    80003e0e:	0094ca83          	lbu	s5,9(s1)
    80003e12:	0104ba03          	ld	s4,16(s1)
    80003e16:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003e1a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003e1e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003e22:	0001f517          	auipc	a0,0x1f
    80003e26:	74650513          	addi	a0,a0,1862 # 80023568 <ftable>
    80003e2a:	00002097          	auipc	ra,0x2
    80003e2e:	7bc080e7          	jalr	1980(ra) # 800065e6 <release>

  if(ff.type == FD_PIPE){
    80003e32:	4785                	li	a5,1
    80003e34:	04f90d63          	beq	s2,a5,80003e8e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003e38:	3979                	addiw	s2,s2,-2
    80003e3a:	4785                	li	a5,1
    80003e3c:	0527e063          	bltu	a5,s2,80003e7c <fileclose+0xa8>
    begin_op();
    80003e40:	00000097          	auipc	ra,0x0
    80003e44:	ac8080e7          	jalr	-1336(ra) # 80003908 <begin_op>
    iput(ff.ip);
    80003e48:	854e                	mv	a0,s3
    80003e4a:	fffff097          	auipc	ra,0xfffff
    80003e4e:	2a6080e7          	jalr	678(ra) # 800030f0 <iput>
    end_op();
    80003e52:	00000097          	auipc	ra,0x0
    80003e56:	b36080e7          	jalr	-1226(ra) # 80003988 <end_op>
    80003e5a:	a00d                	j	80003e7c <fileclose+0xa8>
    panic("fileclose");
    80003e5c:	00004517          	auipc	a0,0x4
    80003e60:	78c50513          	addi	a0,a0,1932 # 800085e8 <syscalls+0x258>
    80003e64:	00002097          	auipc	ra,0x2
    80003e68:	184080e7          	jalr	388(ra) # 80005fe8 <panic>
    release(&ftable.lock);
    80003e6c:	0001f517          	auipc	a0,0x1f
    80003e70:	6fc50513          	addi	a0,a0,1788 # 80023568 <ftable>
    80003e74:	00002097          	auipc	ra,0x2
    80003e78:	772080e7          	jalr	1906(ra) # 800065e6 <release>
  }
}
    80003e7c:	70e2                	ld	ra,56(sp)
    80003e7e:	7442                	ld	s0,48(sp)
    80003e80:	74a2                	ld	s1,40(sp)
    80003e82:	7902                	ld	s2,32(sp)
    80003e84:	69e2                	ld	s3,24(sp)
    80003e86:	6a42                	ld	s4,16(sp)
    80003e88:	6aa2                	ld	s5,8(sp)
    80003e8a:	6121                	addi	sp,sp,64
    80003e8c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003e8e:	85d6                	mv	a1,s5
    80003e90:	8552                	mv	a0,s4
    80003e92:	00000097          	auipc	ra,0x0
    80003e96:	34c080e7          	jalr	844(ra) # 800041de <pipeclose>
    80003e9a:	b7cd                	j	80003e7c <fileclose+0xa8>

0000000080003e9c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003e9c:	715d                	addi	sp,sp,-80
    80003e9e:	e486                	sd	ra,72(sp)
    80003ea0:	e0a2                	sd	s0,64(sp)
    80003ea2:	fc26                	sd	s1,56(sp)
    80003ea4:	f84a                	sd	s2,48(sp)
    80003ea6:	f44e                	sd	s3,40(sp)
    80003ea8:	0880                	addi	s0,sp,80
    80003eaa:	84aa                	mv	s1,a0
    80003eac:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003eae:	ffffd097          	auipc	ra,0xffffd
    80003eb2:	f80080e7          	jalr	-128(ra) # 80000e2e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003eb6:	409c                	lw	a5,0(s1)
    80003eb8:	37f9                	addiw	a5,a5,-2
    80003eba:	4705                	li	a4,1
    80003ebc:	04f76763          	bltu	a4,a5,80003f0a <filestat+0x6e>
    80003ec0:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ec2:	6c88                	ld	a0,24(s1)
    80003ec4:	fffff097          	auipc	ra,0xfffff
    80003ec8:	072080e7          	jalr	114(ra) # 80002f36 <ilock>
    stati(f->ip, &st);
    80003ecc:	fb840593          	addi	a1,s0,-72
    80003ed0:	6c88                	ld	a0,24(s1)
    80003ed2:	fffff097          	auipc	ra,0xfffff
    80003ed6:	2ee080e7          	jalr	750(ra) # 800031c0 <stati>
    iunlock(f->ip);
    80003eda:	6c88                	ld	a0,24(s1)
    80003edc:	fffff097          	auipc	ra,0xfffff
    80003ee0:	11c080e7          	jalr	284(ra) # 80002ff8 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ee4:	46e1                	li	a3,24
    80003ee6:	fb840613          	addi	a2,s0,-72
    80003eea:	85ce                	mv	a1,s3
    80003eec:	05093503          	ld	a0,80(s2)
    80003ef0:	ffffd097          	auipc	ra,0xffffd
    80003ef4:	c00080e7          	jalr	-1024(ra) # 80000af0 <copyout>
    80003ef8:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003efc:	60a6                	ld	ra,72(sp)
    80003efe:	6406                	ld	s0,64(sp)
    80003f00:	74e2                	ld	s1,56(sp)
    80003f02:	7942                	ld	s2,48(sp)
    80003f04:	79a2                	ld	s3,40(sp)
    80003f06:	6161                	addi	sp,sp,80
    80003f08:	8082                	ret
  return -1;
    80003f0a:	557d                	li	a0,-1
    80003f0c:	bfc5                	j	80003efc <filestat+0x60>

0000000080003f0e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003f0e:	7179                	addi	sp,sp,-48
    80003f10:	f406                	sd	ra,40(sp)
    80003f12:	f022                	sd	s0,32(sp)
    80003f14:	ec26                	sd	s1,24(sp)
    80003f16:	e84a                	sd	s2,16(sp)
    80003f18:	e44e                	sd	s3,8(sp)
    80003f1a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003f1c:	00854783          	lbu	a5,8(a0)
    80003f20:	c3d5                	beqz	a5,80003fc4 <fileread+0xb6>
    80003f22:	84aa                	mv	s1,a0
    80003f24:	89ae                	mv	s3,a1
    80003f26:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003f28:	411c                	lw	a5,0(a0)
    80003f2a:	4705                	li	a4,1
    80003f2c:	04e78963          	beq	a5,a4,80003f7e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f30:	470d                	li	a4,3
    80003f32:	04e78d63          	beq	a5,a4,80003f8c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f36:	4709                	li	a4,2
    80003f38:	06e79e63          	bne	a5,a4,80003fb4 <fileread+0xa6>
    ilock(f->ip);
    80003f3c:	6d08                	ld	a0,24(a0)
    80003f3e:	fffff097          	auipc	ra,0xfffff
    80003f42:	ff8080e7          	jalr	-8(ra) # 80002f36 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003f46:	874a                	mv	a4,s2
    80003f48:	5094                	lw	a3,32(s1)
    80003f4a:	864e                	mv	a2,s3
    80003f4c:	4585                	li	a1,1
    80003f4e:	6c88                	ld	a0,24(s1)
    80003f50:	fffff097          	auipc	ra,0xfffff
    80003f54:	29a080e7          	jalr	666(ra) # 800031ea <readi>
    80003f58:	892a                	mv	s2,a0
    80003f5a:	00a05563          	blez	a0,80003f64 <fileread+0x56>
      f->off += r;
    80003f5e:	509c                	lw	a5,32(s1)
    80003f60:	9fa9                	addw	a5,a5,a0
    80003f62:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003f64:	6c88                	ld	a0,24(s1)
    80003f66:	fffff097          	auipc	ra,0xfffff
    80003f6a:	092080e7          	jalr	146(ra) # 80002ff8 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003f6e:	854a                	mv	a0,s2
    80003f70:	70a2                	ld	ra,40(sp)
    80003f72:	7402                	ld	s0,32(sp)
    80003f74:	64e2                	ld	s1,24(sp)
    80003f76:	6942                	ld	s2,16(sp)
    80003f78:	69a2                	ld	s3,8(sp)
    80003f7a:	6145                	addi	sp,sp,48
    80003f7c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003f7e:	6908                	ld	a0,16(a0)
    80003f80:	00000097          	auipc	ra,0x0
    80003f84:	3c8080e7          	jalr	968(ra) # 80004348 <piperead>
    80003f88:	892a                	mv	s2,a0
    80003f8a:	b7d5                	j	80003f6e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003f8c:	02451783          	lh	a5,36(a0)
    80003f90:	03079693          	slli	a3,a5,0x30
    80003f94:	92c1                	srli	a3,a3,0x30
    80003f96:	4725                	li	a4,9
    80003f98:	02d76863          	bltu	a4,a3,80003fc8 <fileread+0xba>
    80003f9c:	0792                	slli	a5,a5,0x4
    80003f9e:	0001f717          	auipc	a4,0x1f
    80003fa2:	52a70713          	addi	a4,a4,1322 # 800234c8 <devsw>
    80003fa6:	97ba                	add	a5,a5,a4
    80003fa8:	639c                	ld	a5,0(a5)
    80003faa:	c38d                	beqz	a5,80003fcc <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003fac:	4505                	li	a0,1
    80003fae:	9782                	jalr	a5
    80003fb0:	892a                	mv	s2,a0
    80003fb2:	bf75                	j	80003f6e <fileread+0x60>
    panic("fileread");
    80003fb4:	00004517          	auipc	a0,0x4
    80003fb8:	64450513          	addi	a0,a0,1604 # 800085f8 <syscalls+0x268>
    80003fbc:	00002097          	auipc	ra,0x2
    80003fc0:	02c080e7          	jalr	44(ra) # 80005fe8 <panic>
    return -1;
    80003fc4:	597d                	li	s2,-1
    80003fc6:	b765                	j	80003f6e <fileread+0x60>
      return -1;
    80003fc8:	597d                	li	s2,-1
    80003fca:	b755                	j	80003f6e <fileread+0x60>
    80003fcc:	597d                	li	s2,-1
    80003fce:	b745                	j	80003f6e <fileread+0x60>

0000000080003fd0 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003fd0:	715d                	addi	sp,sp,-80
    80003fd2:	e486                	sd	ra,72(sp)
    80003fd4:	e0a2                	sd	s0,64(sp)
    80003fd6:	fc26                	sd	s1,56(sp)
    80003fd8:	f84a                	sd	s2,48(sp)
    80003fda:	f44e                	sd	s3,40(sp)
    80003fdc:	f052                	sd	s4,32(sp)
    80003fde:	ec56                	sd	s5,24(sp)
    80003fe0:	e85a                	sd	s6,16(sp)
    80003fe2:	e45e                	sd	s7,8(sp)
    80003fe4:	e062                	sd	s8,0(sp)
    80003fe6:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003fe8:	00954783          	lbu	a5,9(a0)
    80003fec:	10078663          	beqz	a5,800040f8 <filewrite+0x128>
    80003ff0:	892a                	mv	s2,a0
    80003ff2:	8aae                	mv	s5,a1
    80003ff4:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ff6:	411c                	lw	a5,0(a0)
    80003ff8:	4705                	li	a4,1
    80003ffa:	02e78263          	beq	a5,a4,8000401e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ffe:	470d                	li	a4,3
    80004000:	02e78663          	beq	a5,a4,8000402c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004004:	4709                	li	a4,2
    80004006:	0ee79163          	bne	a5,a4,800040e8 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000400a:	0ac05d63          	blez	a2,800040c4 <filewrite+0xf4>
    int i = 0;
    8000400e:	4981                	li	s3,0
    80004010:	6b05                	lui	s6,0x1
    80004012:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004016:	6b85                	lui	s7,0x1
    80004018:	c00b8b9b          	addiw	s7,s7,-1024
    8000401c:	a861                	j	800040b4 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    8000401e:	6908                	ld	a0,16(a0)
    80004020:	00000097          	auipc	ra,0x0
    80004024:	22e080e7          	jalr	558(ra) # 8000424e <pipewrite>
    80004028:	8a2a                	mv	s4,a0
    8000402a:	a045                	j	800040ca <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000402c:	02451783          	lh	a5,36(a0)
    80004030:	03079693          	slli	a3,a5,0x30
    80004034:	92c1                	srli	a3,a3,0x30
    80004036:	4725                	li	a4,9
    80004038:	0cd76263          	bltu	a4,a3,800040fc <filewrite+0x12c>
    8000403c:	0792                	slli	a5,a5,0x4
    8000403e:	0001f717          	auipc	a4,0x1f
    80004042:	48a70713          	addi	a4,a4,1162 # 800234c8 <devsw>
    80004046:	97ba                	add	a5,a5,a4
    80004048:	679c                	ld	a5,8(a5)
    8000404a:	cbdd                	beqz	a5,80004100 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    8000404c:	4505                	li	a0,1
    8000404e:	9782                	jalr	a5
    80004050:	8a2a                	mv	s4,a0
    80004052:	a8a5                	j	800040ca <filewrite+0xfa>
    80004054:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004058:	00000097          	auipc	ra,0x0
    8000405c:	8b0080e7          	jalr	-1872(ra) # 80003908 <begin_op>
      ilock(f->ip);
    80004060:	01893503          	ld	a0,24(s2)
    80004064:	fffff097          	auipc	ra,0xfffff
    80004068:	ed2080e7          	jalr	-302(ra) # 80002f36 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000406c:	8762                	mv	a4,s8
    8000406e:	02092683          	lw	a3,32(s2)
    80004072:	01598633          	add	a2,s3,s5
    80004076:	4585                	li	a1,1
    80004078:	01893503          	ld	a0,24(s2)
    8000407c:	fffff097          	auipc	ra,0xfffff
    80004080:	266080e7          	jalr	614(ra) # 800032e2 <writei>
    80004084:	84aa                	mv	s1,a0
    80004086:	00a05763          	blez	a0,80004094 <filewrite+0xc4>
        f->off += r;
    8000408a:	02092783          	lw	a5,32(s2)
    8000408e:	9fa9                	addw	a5,a5,a0
    80004090:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004094:	01893503          	ld	a0,24(s2)
    80004098:	fffff097          	auipc	ra,0xfffff
    8000409c:	f60080e7          	jalr	-160(ra) # 80002ff8 <iunlock>
      end_op();
    800040a0:	00000097          	auipc	ra,0x0
    800040a4:	8e8080e7          	jalr	-1816(ra) # 80003988 <end_op>

      if(r != n1){
    800040a8:	009c1f63          	bne	s8,s1,800040c6 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    800040ac:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800040b0:	0149db63          	bge	s3,s4,800040c6 <filewrite+0xf6>
      int n1 = n - i;
    800040b4:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800040b8:	84be                	mv	s1,a5
    800040ba:	2781                	sext.w	a5,a5
    800040bc:	f8fb5ce3          	bge	s6,a5,80004054 <filewrite+0x84>
    800040c0:	84de                	mv	s1,s7
    800040c2:	bf49                	j	80004054 <filewrite+0x84>
    int i = 0;
    800040c4:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800040c6:	013a1f63          	bne	s4,s3,800040e4 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800040ca:	8552                	mv	a0,s4
    800040cc:	60a6                	ld	ra,72(sp)
    800040ce:	6406                	ld	s0,64(sp)
    800040d0:	74e2                	ld	s1,56(sp)
    800040d2:	7942                	ld	s2,48(sp)
    800040d4:	79a2                	ld	s3,40(sp)
    800040d6:	7a02                	ld	s4,32(sp)
    800040d8:	6ae2                	ld	s5,24(sp)
    800040da:	6b42                	ld	s6,16(sp)
    800040dc:	6ba2                	ld	s7,8(sp)
    800040de:	6c02                	ld	s8,0(sp)
    800040e0:	6161                	addi	sp,sp,80
    800040e2:	8082                	ret
    ret = (i == n ? n : -1);
    800040e4:	5a7d                	li	s4,-1
    800040e6:	b7d5                	j	800040ca <filewrite+0xfa>
    panic("filewrite");
    800040e8:	00004517          	auipc	a0,0x4
    800040ec:	52050513          	addi	a0,a0,1312 # 80008608 <syscalls+0x278>
    800040f0:	00002097          	auipc	ra,0x2
    800040f4:	ef8080e7          	jalr	-264(ra) # 80005fe8 <panic>
    return -1;
    800040f8:	5a7d                	li	s4,-1
    800040fa:	bfc1                	j	800040ca <filewrite+0xfa>
      return -1;
    800040fc:	5a7d                	li	s4,-1
    800040fe:	b7f1                	j	800040ca <filewrite+0xfa>
    80004100:	5a7d                	li	s4,-1
    80004102:	b7e1                	j	800040ca <filewrite+0xfa>

0000000080004104 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004104:	7179                	addi	sp,sp,-48
    80004106:	f406                	sd	ra,40(sp)
    80004108:	f022                	sd	s0,32(sp)
    8000410a:	ec26                	sd	s1,24(sp)
    8000410c:	e84a                	sd	s2,16(sp)
    8000410e:	e44e                	sd	s3,8(sp)
    80004110:	e052                	sd	s4,0(sp)
    80004112:	1800                	addi	s0,sp,48
    80004114:	84aa                	mv	s1,a0
    80004116:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004118:	0005b023          	sd	zero,0(a1)
    8000411c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004120:	00000097          	auipc	ra,0x0
    80004124:	bf8080e7          	jalr	-1032(ra) # 80003d18 <filealloc>
    80004128:	e088                	sd	a0,0(s1)
    8000412a:	c551                	beqz	a0,800041b6 <pipealloc+0xb2>
    8000412c:	00000097          	auipc	ra,0x0
    80004130:	bec080e7          	jalr	-1044(ra) # 80003d18 <filealloc>
    80004134:	00aa3023          	sd	a0,0(s4)
    80004138:	c92d                	beqz	a0,800041aa <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000413a:	ffffc097          	auipc	ra,0xffffc
    8000413e:	fde080e7          	jalr	-34(ra) # 80000118 <kalloc>
    80004142:	892a                	mv	s2,a0
    80004144:	c125                	beqz	a0,800041a4 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004146:	4985                	li	s3,1
    80004148:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000414c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004150:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004154:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004158:	00004597          	auipc	a1,0x4
    8000415c:	4c058593          	addi	a1,a1,1216 # 80008618 <syscalls+0x288>
    80004160:	00002097          	auipc	ra,0x2
    80004164:	342080e7          	jalr	834(ra) # 800064a2 <initlock>
  (*f0)->type = FD_PIPE;
    80004168:	609c                	ld	a5,0(s1)
    8000416a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000416e:	609c                	ld	a5,0(s1)
    80004170:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004174:	609c                	ld	a5,0(s1)
    80004176:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000417a:	609c                	ld	a5,0(s1)
    8000417c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004180:	000a3783          	ld	a5,0(s4)
    80004184:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004188:	000a3783          	ld	a5,0(s4)
    8000418c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004190:	000a3783          	ld	a5,0(s4)
    80004194:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004198:	000a3783          	ld	a5,0(s4)
    8000419c:	0127b823          	sd	s2,16(a5)
  return 0;
    800041a0:	4501                	li	a0,0
    800041a2:	a025                	j	800041ca <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800041a4:	6088                	ld	a0,0(s1)
    800041a6:	e501                	bnez	a0,800041ae <pipealloc+0xaa>
    800041a8:	a039                	j	800041b6 <pipealloc+0xb2>
    800041aa:	6088                	ld	a0,0(s1)
    800041ac:	c51d                	beqz	a0,800041da <pipealloc+0xd6>
    fileclose(*f0);
    800041ae:	00000097          	auipc	ra,0x0
    800041b2:	c26080e7          	jalr	-986(ra) # 80003dd4 <fileclose>
  if(*f1)
    800041b6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800041ba:	557d                	li	a0,-1
  if(*f1)
    800041bc:	c799                	beqz	a5,800041ca <pipealloc+0xc6>
    fileclose(*f1);
    800041be:	853e                	mv	a0,a5
    800041c0:	00000097          	auipc	ra,0x0
    800041c4:	c14080e7          	jalr	-1004(ra) # 80003dd4 <fileclose>
  return -1;
    800041c8:	557d                	li	a0,-1
}
    800041ca:	70a2                	ld	ra,40(sp)
    800041cc:	7402                	ld	s0,32(sp)
    800041ce:	64e2                	ld	s1,24(sp)
    800041d0:	6942                	ld	s2,16(sp)
    800041d2:	69a2                	ld	s3,8(sp)
    800041d4:	6a02                	ld	s4,0(sp)
    800041d6:	6145                	addi	sp,sp,48
    800041d8:	8082                	ret
  return -1;
    800041da:	557d                	li	a0,-1
    800041dc:	b7fd                	j	800041ca <pipealloc+0xc6>

00000000800041de <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800041de:	1101                	addi	sp,sp,-32
    800041e0:	ec06                	sd	ra,24(sp)
    800041e2:	e822                	sd	s0,16(sp)
    800041e4:	e426                	sd	s1,8(sp)
    800041e6:	e04a                	sd	s2,0(sp)
    800041e8:	1000                	addi	s0,sp,32
    800041ea:	84aa                	mv	s1,a0
    800041ec:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800041ee:	00002097          	auipc	ra,0x2
    800041f2:	344080e7          	jalr	836(ra) # 80006532 <acquire>
  if(writable){
    800041f6:	02090d63          	beqz	s2,80004230 <pipeclose+0x52>
    pi->writeopen = 0;
    800041fa:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800041fe:	21848513          	addi	a0,s1,536
    80004202:	ffffd097          	auipc	ra,0xffffd
    80004206:	538080e7          	jalr	1336(ra) # 8000173a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000420a:	2204b783          	ld	a5,544(s1)
    8000420e:	eb95                	bnez	a5,80004242 <pipeclose+0x64>
    release(&pi->lock);
    80004210:	8526                	mv	a0,s1
    80004212:	00002097          	auipc	ra,0x2
    80004216:	3d4080e7          	jalr	980(ra) # 800065e6 <release>
    kfree((char*)pi);
    8000421a:	8526                	mv	a0,s1
    8000421c:	ffffc097          	auipc	ra,0xffffc
    80004220:	e00080e7          	jalr	-512(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004224:	60e2                	ld	ra,24(sp)
    80004226:	6442                	ld	s0,16(sp)
    80004228:	64a2                	ld	s1,8(sp)
    8000422a:	6902                	ld	s2,0(sp)
    8000422c:	6105                	addi	sp,sp,32
    8000422e:	8082                	ret
    pi->readopen = 0;
    80004230:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004234:	21c48513          	addi	a0,s1,540
    80004238:	ffffd097          	auipc	ra,0xffffd
    8000423c:	502080e7          	jalr	1282(ra) # 8000173a <wakeup>
    80004240:	b7e9                	j	8000420a <pipeclose+0x2c>
    release(&pi->lock);
    80004242:	8526                	mv	a0,s1
    80004244:	00002097          	auipc	ra,0x2
    80004248:	3a2080e7          	jalr	930(ra) # 800065e6 <release>
}
    8000424c:	bfe1                	j	80004224 <pipeclose+0x46>

000000008000424e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000424e:	7159                	addi	sp,sp,-112
    80004250:	f486                	sd	ra,104(sp)
    80004252:	f0a2                	sd	s0,96(sp)
    80004254:	eca6                	sd	s1,88(sp)
    80004256:	e8ca                	sd	s2,80(sp)
    80004258:	e4ce                	sd	s3,72(sp)
    8000425a:	e0d2                	sd	s4,64(sp)
    8000425c:	fc56                	sd	s5,56(sp)
    8000425e:	f85a                	sd	s6,48(sp)
    80004260:	f45e                	sd	s7,40(sp)
    80004262:	f062                	sd	s8,32(sp)
    80004264:	ec66                	sd	s9,24(sp)
    80004266:	1880                	addi	s0,sp,112
    80004268:	84aa                	mv	s1,a0
    8000426a:	8aae                	mv	s5,a1
    8000426c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000426e:	ffffd097          	auipc	ra,0xffffd
    80004272:	bc0080e7          	jalr	-1088(ra) # 80000e2e <myproc>
    80004276:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004278:	8526                	mv	a0,s1
    8000427a:	00002097          	auipc	ra,0x2
    8000427e:	2b8080e7          	jalr	696(ra) # 80006532 <acquire>
  while(i < n){
    80004282:	0d405163          	blez	s4,80004344 <pipewrite+0xf6>
    80004286:	8ba6                	mv	s7,s1
  int i = 0;
    80004288:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000428a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000428c:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004290:	21c48c13          	addi	s8,s1,540
    80004294:	a08d                	j	800042f6 <pipewrite+0xa8>
      release(&pi->lock);
    80004296:	8526                	mv	a0,s1
    80004298:	00002097          	auipc	ra,0x2
    8000429c:	34e080e7          	jalr	846(ra) # 800065e6 <release>
      return -1;
    800042a0:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800042a2:	854a                	mv	a0,s2
    800042a4:	70a6                	ld	ra,104(sp)
    800042a6:	7406                	ld	s0,96(sp)
    800042a8:	64e6                	ld	s1,88(sp)
    800042aa:	6946                	ld	s2,80(sp)
    800042ac:	69a6                	ld	s3,72(sp)
    800042ae:	6a06                	ld	s4,64(sp)
    800042b0:	7ae2                	ld	s5,56(sp)
    800042b2:	7b42                	ld	s6,48(sp)
    800042b4:	7ba2                	ld	s7,40(sp)
    800042b6:	7c02                	ld	s8,32(sp)
    800042b8:	6ce2                	ld	s9,24(sp)
    800042ba:	6165                	addi	sp,sp,112
    800042bc:	8082                	ret
      wakeup(&pi->nread);
    800042be:	8566                	mv	a0,s9
    800042c0:	ffffd097          	auipc	ra,0xffffd
    800042c4:	47a080e7          	jalr	1146(ra) # 8000173a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800042c8:	85de                	mv	a1,s7
    800042ca:	8562                	mv	a0,s8
    800042cc:	ffffd097          	auipc	ra,0xffffd
    800042d0:	2e2080e7          	jalr	738(ra) # 800015ae <sleep>
    800042d4:	a839                	j	800042f2 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800042d6:	21c4a783          	lw	a5,540(s1)
    800042da:	0017871b          	addiw	a4,a5,1
    800042de:	20e4ae23          	sw	a4,540(s1)
    800042e2:	1ff7f793          	andi	a5,a5,511
    800042e6:	97a6                	add	a5,a5,s1
    800042e8:	f9f44703          	lbu	a4,-97(s0)
    800042ec:	00e78c23          	sb	a4,24(a5)
      i++;
    800042f0:	2905                	addiw	s2,s2,1
  while(i < n){
    800042f2:	03495d63          	bge	s2,s4,8000432c <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    800042f6:	2204a783          	lw	a5,544(s1)
    800042fa:	dfd1                	beqz	a5,80004296 <pipewrite+0x48>
    800042fc:	0289a783          	lw	a5,40(s3)
    80004300:	fbd9                	bnez	a5,80004296 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004302:	2184a783          	lw	a5,536(s1)
    80004306:	21c4a703          	lw	a4,540(s1)
    8000430a:	2007879b          	addiw	a5,a5,512
    8000430e:	faf708e3          	beq	a4,a5,800042be <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004312:	4685                	li	a3,1
    80004314:	01590633          	add	a2,s2,s5
    80004318:	f9f40593          	addi	a1,s0,-97
    8000431c:	0509b503          	ld	a0,80(s3)
    80004320:	ffffd097          	auipc	ra,0xffffd
    80004324:	85c080e7          	jalr	-1956(ra) # 80000b7c <copyin>
    80004328:	fb6517e3          	bne	a0,s6,800042d6 <pipewrite+0x88>
  wakeup(&pi->nread);
    8000432c:	21848513          	addi	a0,s1,536
    80004330:	ffffd097          	auipc	ra,0xffffd
    80004334:	40a080e7          	jalr	1034(ra) # 8000173a <wakeup>
  release(&pi->lock);
    80004338:	8526                	mv	a0,s1
    8000433a:	00002097          	auipc	ra,0x2
    8000433e:	2ac080e7          	jalr	684(ra) # 800065e6 <release>
  return i;
    80004342:	b785                	j	800042a2 <pipewrite+0x54>
  int i = 0;
    80004344:	4901                	li	s2,0
    80004346:	b7dd                	j	8000432c <pipewrite+0xde>

0000000080004348 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004348:	715d                	addi	sp,sp,-80
    8000434a:	e486                	sd	ra,72(sp)
    8000434c:	e0a2                	sd	s0,64(sp)
    8000434e:	fc26                	sd	s1,56(sp)
    80004350:	f84a                	sd	s2,48(sp)
    80004352:	f44e                	sd	s3,40(sp)
    80004354:	f052                	sd	s4,32(sp)
    80004356:	ec56                	sd	s5,24(sp)
    80004358:	e85a                	sd	s6,16(sp)
    8000435a:	0880                	addi	s0,sp,80
    8000435c:	84aa                	mv	s1,a0
    8000435e:	892e                	mv	s2,a1
    80004360:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004362:	ffffd097          	auipc	ra,0xffffd
    80004366:	acc080e7          	jalr	-1332(ra) # 80000e2e <myproc>
    8000436a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000436c:	8b26                	mv	s6,s1
    8000436e:	8526                	mv	a0,s1
    80004370:	00002097          	auipc	ra,0x2
    80004374:	1c2080e7          	jalr	450(ra) # 80006532 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004378:	2184a703          	lw	a4,536(s1)
    8000437c:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004380:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004384:	02f71463          	bne	a4,a5,800043ac <piperead+0x64>
    80004388:	2244a783          	lw	a5,548(s1)
    8000438c:	c385                	beqz	a5,800043ac <piperead+0x64>
    if(pr->killed){
    8000438e:	028a2783          	lw	a5,40(s4)
    80004392:	ebc1                	bnez	a5,80004422 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004394:	85da                	mv	a1,s6
    80004396:	854e                	mv	a0,s3
    80004398:	ffffd097          	auipc	ra,0xffffd
    8000439c:	216080e7          	jalr	534(ra) # 800015ae <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800043a0:	2184a703          	lw	a4,536(s1)
    800043a4:	21c4a783          	lw	a5,540(s1)
    800043a8:	fef700e3          	beq	a4,a5,80004388 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800043ac:	09505263          	blez	s5,80004430 <piperead+0xe8>
    800043b0:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800043b2:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800043b4:	2184a783          	lw	a5,536(s1)
    800043b8:	21c4a703          	lw	a4,540(s1)
    800043bc:	02f70d63          	beq	a4,a5,800043f6 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800043c0:	0017871b          	addiw	a4,a5,1
    800043c4:	20e4ac23          	sw	a4,536(s1)
    800043c8:	1ff7f793          	andi	a5,a5,511
    800043cc:	97a6                	add	a5,a5,s1
    800043ce:	0187c783          	lbu	a5,24(a5)
    800043d2:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800043d6:	4685                	li	a3,1
    800043d8:	fbf40613          	addi	a2,s0,-65
    800043dc:	85ca                	mv	a1,s2
    800043de:	050a3503          	ld	a0,80(s4)
    800043e2:	ffffc097          	auipc	ra,0xffffc
    800043e6:	70e080e7          	jalr	1806(ra) # 80000af0 <copyout>
    800043ea:	01650663          	beq	a0,s6,800043f6 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800043ee:	2985                	addiw	s3,s3,1
    800043f0:	0905                	addi	s2,s2,1
    800043f2:	fd3a91e3          	bne	s5,s3,800043b4 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800043f6:	21c48513          	addi	a0,s1,540
    800043fa:	ffffd097          	auipc	ra,0xffffd
    800043fe:	340080e7          	jalr	832(ra) # 8000173a <wakeup>
  release(&pi->lock);
    80004402:	8526                	mv	a0,s1
    80004404:	00002097          	auipc	ra,0x2
    80004408:	1e2080e7          	jalr	482(ra) # 800065e6 <release>
  return i;
}
    8000440c:	854e                	mv	a0,s3
    8000440e:	60a6                	ld	ra,72(sp)
    80004410:	6406                	ld	s0,64(sp)
    80004412:	74e2                	ld	s1,56(sp)
    80004414:	7942                	ld	s2,48(sp)
    80004416:	79a2                	ld	s3,40(sp)
    80004418:	7a02                	ld	s4,32(sp)
    8000441a:	6ae2                	ld	s5,24(sp)
    8000441c:	6b42                	ld	s6,16(sp)
    8000441e:	6161                	addi	sp,sp,80
    80004420:	8082                	ret
      release(&pi->lock);
    80004422:	8526                	mv	a0,s1
    80004424:	00002097          	auipc	ra,0x2
    80004428:	1c2080e7          	jalr	450(ra) # 800065e6 <release>
      return -1;
    8000442c:	59fd                	li	s3,-1
    8000442e:	bff9                	j	8000440c <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004430:	4981                	li	s3,0
    80004432:	b7d1                	j	800043f6 <piperead+0xae>

0000000080004434 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004434:	df010113          	addi	sp,sp,-528
    80004438:	20113423          	sd	ra,520(sp)
    8000443c:	20813023          	sd	s0,512(sp)
    80004440:	ffa6                	sd	s1,504(sp)
    80004442:	fbca                	sd	s2,496(sp)
    80004444:	f7ce                	sd	s3,488(sp)
    80004446:	f3d2                	sd	s4,480(sp)
    80004448:	efd6                	sd	s5,472(sp)
    8000444a:	ebda                	sd	s6,464(sp)
    8000444c:	e7de                	sd	s7,456(sp)
    8000444e:	e3e2                	sd	s8,448(sp)
    80004450:	ff66                	sd	s9,440(sp)
    80004452:	fb6a                	sd	s10,432(sp)
    80004454:	f76e                	sd	s11,424(sp)
    80004456:	0c00                	addi	s0,sp,528
    80004458:	84aa                	mv	s1,a0
    8000445a:	dea43c23          	sd	a0,-520(s0)
    8000445e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004462:	ffffd097          	auipc	ra,0xffffd
    80004466:	9cc080e7          	jalr	-1588(ra) # 80000e2e <myproc>
    8000446a:	892a                	mv	s2,a0

  begin_op();
    8000446c:	fffff097          	auipc	ra,0xfffff
    80004470:	49c080e7          	jalr	1180(ra) # 80003908 <begin_op>

  if((ip = namei(path)) == 0){
    80004474:	8526                	mv	a0,s1
    80004476:	fffff097          	auipc	ra,0xfffff
    8000447a:	276080e7          	jalr	630(ra) # 800036ec <namei>
    8000447e:	c92d                	beqz	a0,800044f0 <exec+0xbc>
    80004480:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004482:	fffff097          	auipc	ra,0xfffff
    80004486:	ab4080e7          	jalr	-1356(ra) # 80002f36 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000448a:	04000713          	li	a4,64
    8000448e:	4681                	li	a3,0
    80004490:	e5040613          	addi	a2,s0,-432
    80004494:	4581                	li	a1,0
    80004496:	8526                	mv	a0,s1
    80004498:	fffff097          	auipc	ra,0xfffff
    8000449c:	d52080e7          	jalr	-686(ra) # 800031ea <readi>
    800044a0:	04000793          	li	a5,64
    800044a4:	00f51a63          	bne	a0,a5,800044b8 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800044a8:	e5042703          	lw	a4,-432(s0)
    800044ac:	464c47b7          	lui	a5,0x464c4
    800044b0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800044b4:	04f70463          	beq	a4,a5,800044fc <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800044b8:	8526                	mv	a0,s1
    800044ba:	fffff097          	auipc	ra,0xfffff
    800044be:	cde080e7          	jalr	-802(ra) # 80003198 <iunlockput>
    end_op();
    800044c2:	fffff097          	auipc	ra,0xfffff
    800044c6:	4c6080e7          	jalr	1222(ra) # 80003988 <end_op>
  }
  return -1;
    800044ca:	557d                	li	a0,-1
}
    800044cc:	20813083          	ld	ra,520(sp)
    800044d0:	20013403          	ld	s0,512(sp)
    800044d4:	74fe                	ld	s1,504(sp)
    800044d6:	795e                	ld	s2,496(sp)
    800044d8:	79be                	ld	s3,488(sp)
    800044da:	7a1e                	ld	s4,480(sp)
    800044dc:	6afe                	ld	s5,472(sp)
    800044de:	6b5e                	ld	s6,464(sp)
    800044e0:	6bbe                	ld	s7,456(sp)
    800044e2:	6c1e                	ld	s8,448(sp)
    800044e4:	7cfa                	ld	s9,440(sp)
    800044e6:	7d5a                	ld	s10,432(sp)
    800044e8:	7dba                	ld	s11,424(sp)
    800044ea:	21010113          	addi	sp,sp,528
    800044ee:	8082                	ret
    end_op();
    800044f0:	fffff097          	auipc	ra,0xfffff
    800044f4:	498080e7          	jalr	1176(ra) # 80003988 <end_op>
    return -1;
    800044f8:	557d                	li	a0,-1
    800044fa:	bfc9                	j	800044cc <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800044fc:	854a                	mv	a0,s2
    800044fe:	ffffd097          	auipc	ra,0xffffd
    80004502:	9f4080e7          	jalr	-1548(ra) # 80000ef2 <proc_pagetable>
    80004506:	8baa                	mv	s7,a0
    80004508:	d945                	beqz	a0,800044b8 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000450a:	e7042983          	lw	s3,-400(s0)
    8000450e:	e8845783          	lhu	a5,-376(s0)
    80004512:	c7ad                	beqz	a5,8000457c <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004514:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004516:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004518:	6c85                	lui	s9,0x1
    8000451a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000451e:	def43823          	sd	a5,-528(s0)
    80004522:	a42d                	j	8000474c <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004524:	00004517          	auipc	a0,0x4
    80004528:	0fc50513          	addi	a0,a0,252 # 80008620 <syscalls+0x290>
    8000452c:	00002097          	auipc	ra,0x2
    80004530:	abc080e7          	jalr	-1348(ra) # 80005fe8 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004534:	8756                	mv	a4,s5
    80004536:	012d86bb          	addw	a3,s11,s2
    8000453a:	4581                	li	a1,0
    8000453c:	8526                	mv	a0,s1
    8000453e:	fffff097          	auipc	ra,0xfffff
    80004542:	cac080e7          	jalr	-852(ra) # 800031ea <readi>
    80004546:	2501                	sext.w	a0,a0
    80004548:	1aaa9963          	bne	s5,a0,800046fa <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    8000454c:	6785                	lui	a5,0x1
    8000454e:	0127893b          	addw	s2,a5,s2
    80004552:	77fd                	lui	a5,0xfffff
    80004554:	01478a3b          	addw	s4,a5,s4
    80004558:	1f897163          	bgeu	s2,s8,8000473a <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    8000455c:	02091593          	slli	a1,s2,0x20
    80004560:	9181                	srli	a1,a1,0x20
    80004562:	95ea                	add	a1,a1,s10
    80004564:	855e                	mv	a0,s7
    80004566:	ffffc097          	auipc	ra,0xffffc
    8000456a:	fa0080e7          	jalr	-96(ra) # 80000506 <walkaddr>
    8000456e:	862a                	mv	a2,a0
    if(pa == 0)
    80004570:	d955                	beqz	a0,80004524 <exec+0xf0>
      n = PGSIZE;
    80004572:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004574:	fd9a70e3          	bgeu	s4,s9,80004534 <exec+0x100>
      n = sz - i;
    80004578:	8ad2                	mv	s5,s4
    8000457a:	bf6d                	j	80004534 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000457c:	4901                	li	s2,0
  iunlockput(ip);
    8000457e:	8526                	mv	a0,s1
    80004580:	fffff097          	auipc	ra,0xfffff
    80004584:	c18080e7          	jalr	-1000(ra) # 80003198 <iunlockput>
  end_op();
    80004588:	fffff097          	auipc	ra,0xfffff
    8000458c:	400080e7          	jalr	1024(ra) # 80003988 <end_op>
  p = myproc();
    80004590:	ffffd097          	auipc	ra,0xffffd
    80004594:	89e080e7          	jalr	-1890(ra) # 80000e2e <myproc>
    80004598:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000459a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000459e:	6785                	lui	a5,0x1
    800045a0:	17fd                	addi	a5,a5,-1
    800045a2:	993e                	add	s2,s2,a5
    800045a4:	757d                	lui	a0,0xfffff
    800045a6:	00a977b3          	and	a5,s2,a0
    800045aa:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800045ae:	6609                	lui	a2,0x2
    800045b0:	963e                	add	a2,a2,a5
    800045b2:	85be                	mv	a1,a5
    800045b4:	855e                	mv	a0,s7
    800045b6:	ffffc097          	auipc	ra,0xffffc
    800045ba:	2f6080e7          	jalr	758(ra) # 800008ac <uvmalloc>
    800045be:	8b2a                	mv	s6,a0
  ip = 0;
    800045c0:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800045c2:	12050c63          	beqz	a0,800046fa <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800045c6:	75f9                	lui	a1,0xffffe
    800045c8:	95aa                	add	a1,a1,a0
    800045ca:	855e                	mv	a0,s7
    800045cc:	ffffc097          	auipc	ra,0xffffc
    800045d0:	4f2080e7          	jalr	1266(ra) # 80000abe <uvmclear>
  stackbase = sp - PGSIZE;
    800045d4:	7c7d                	lui	s8,0xfffff
    800045d6:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800045d8:	e0043783          	ld	a5,-512(s0)
    800045dc:	6388                	ld	a0,0(a5)
    800045de:	c535                	beqz	a0,8000464a <exec+0x216>
    800045e0:	e9040993          	addi	s3,s0,-368
    800045e4:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800045e8:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800045ea:	ffffc097          	auipc	ra,0xffffc
    800045ee:	d12080e7          	jalr	-750(ra) # 800002fc <strlen>
    800045f2:	2505                	addiw	a0,a0,1
    800045f4:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800045f8:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800045fc:	13896363          	bltu	s2,s8,80004722 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004600:	e0043d83          	ld	s11,-512(s0)
    80004604:	000dba03          	ld	s4,0(s11)
    80004608:	8552                	mv	a0,s4
    8000460a:	ffffc097          	auipc	ra,0xffffc
    8000460e:	cf2080e7          	jalr	-782(ra) # 800002fc <strlen>
    80004612:	0015069b          	addiw	a3,a0,1
    80004616:	8652                	mv	a2,s4
    80004618:	85ca                	mv	a1,s2
    8000461a:	855e                	mv	a0,s7
    8000461c:	ffffc097          	auipc	ra,0xffffc
    80004620:	4d4080e7          	jalr	1236(ra) # 80000af0 <copyout>
    80004624:	10054363          	bltz	a0,8000472a <exec+0x2f6>
    ustack[argc] = sp;
    80004628:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000462c:	0485                	addi	s1,s1,1
    8000462e:	008d8793          	addi	a5,s11,8
    80004632:	e0f43023          	sd	a5,-512(s0)
    80004636:	008db503          	ld	a0,8(s11)
    8000463a:	c911                	beqz	a0,8000464e <exec+0x21a>
    if(argc >= MAXARG)
    8000463c:	09a1                	addi	s3,s3,8
    8000463e:	fb3c96e3          	bne	s9,s3,800045ea <exec+0x1b6>
  sz = sz1;
    80004642:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004646:	4481                	li	s1,0
    80004648:	a84d                	j	800046fa <exec+0x2c6>
  sp = sz;
    8000464a:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000464c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000464e:	00349793          	slli	a5,s1,0x3
    80004652:	f9040713          	addi	a4,s0,-112
    80004656:	97ba                	add	a5,a5,a4
    80004658:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000465c:	00148693          	addi	a3,s1,1
    80004660:	068e                	slli	a3,a3,0x3
    80004662:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004666:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000466a:	01897663          	bgeu	s2,s8,80004676 <exec+0x242>
  sz = sz1;
    8000466e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004672:	4481                	li	s1,0
    80004674:	a059                	j	800046fa <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004676:	e9040613          	addi	a2,s0,-368
    8000467a:	85ca                	mv	a1,s2
    8000467c:	855e                	mv	a0,s7
    8000467e:	ffffc097          	auipc	ra,0xffffc
    80004682:	472080e7          	jalr	1138(ra) # 80000af0 <copyout>
    80004686:	0a054663          	bltz	a0,80004732 <exec+0x2fe>
  p->trapframe->a1 = sp;
    8000468a:	058ab783          	ld	a5,88(s5)
    8000468e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004692:	df843783          	ld	a5,-520(s0)
    80004696:	0007c703          	lbu	a4,0(a5)
    8000469a:	cf11                	beqz	a4,800046b6 <exec+0x282>
    8000469c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000469e:	02f00693          	li	a3,47
    800046a2:	a039                	j	800046b0 <exec+0x27c>
      last = s+1;
    800046a4:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800046a8:	0785                	addi	a5,a5,1
    800046aa:	fff7c703          	lbu	a4,-1(a5)
    800046ae:	c701                	beqz	a4,800046b6 <exec+0x282>
    if(*s == '/')
    800046b0:	fed71ce3          	bne	a4,a3,800046a8 <exec+0x274>
    800046b4:	bfc5                	j	800046a4 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800046b6:	4641                	li	a2,16
    800046b8:	df843583          	ld	a1,-520(s0)
    800046bc:	158a8513          	addi	a0,s5,344
    800046c0:	ffffc097          	auipc	ra,0xffffc
    800046c4:	c0a080e7          	jalr	-1014(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800046c8:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800046cc:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800046d0:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800046d4:	058ab783          	ld	a5,88(s5)
    800046d8:	e6843703          	ld	a4,-408(s0)
    800046dc:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800046de:	058ab783          	ld	a5,88(s5)
    800046e2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800046e6:	85ea                	mv	a1,s10
    800046e8:	ffffd097          	auipc	ra,0xffffd
    800046ec:	8a6080e7          	jalr	-1882(ra) # 80000f8e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800046f0:	0004851b          	sext.w	a0,s1
    800046f4:	bbe1                	j	800044cc <exec+0x98>
    800046f6:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800046fa:	e0843583          	ld	a1,-504(s0)
    800046fe:	855e                	mv	a0,s7
    80004700:	ffffd097          	auipc	ra,0xffffd
    80004704:	88e080e7          	jalr	-1906(ra) # 80000f8e <proc_freepagetable>
  if(ip){
    80004708:	da0498e3          	bnez	s1,800044b8 <exec+0x84>
  return -1;
    8000470c:	557d                	li	a0,-1
    8000470e:	bb7d                	j	800044cc <exec+0x98>
    80004710:	e1243423          	sd	s2,-504(s0)
    80004714:	b7dd                	j	800046fa <exec+0x2c6>
    80004716:	e1243423          	sd	s2,-504(s0)
    8000471a:	b7c5                	j	800046fa <exec+0x2c6>
    8000471c:	e1243423          	sd	s2,-504(s0)
    80004720:	bfe9                	j	800046fa <exec+0x2c6>
  sz = sz1;
    80004722:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004726:	4481                	li	s1,0
    80004728:	bfc9                	j	800046fa <exec+0x2c6>
  sz = sz1;
    8000472a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000472e:	4481                	li	s1,0
    80004730:	b7e9                	j	800046fa <exec+0x2c6>
  sz = sz1;
    80004732:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004736:	4481                	li	s1,0
    80004738:	b7c9                	j	800046fa <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000473a:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000473e:	2b05                	addiw	s6,s6,1
    80004740:	0389899b          	addiw	s3,s3,56
    80004744:	e8845783          	lhu	a5,-376(s0)
    80004748:	e2fb5be3          	bge	s6,a5,8000457e <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000474c:	2981                	sext.w	s3,s3
    8000474e:	03800713          	li	a4,56
    80004752:	86ce                	mv	a3,s3
    80004754:	e1840613          	addi	a2,s0,-488
    80004758:	4581                	li	a1,0
    8000475a:	8526                	mv	a0,s1
    8000475c:	fffff097          	auipc	ra,0xfffff
    80004760:	a8e080e7          	jalr	-1394(ra) # 800031ea <readi>
    80004764:	03800793          	li	a5,56
    80004768:	f8f517e3          	bne	a0,a5,800046f6 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    8000476c:	e1842783          	lw	a5,-488(s0)
    80004770:	4705                	li	a4,1
    80004772:	fce796e3          	bne	a5,a4,8000473e <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004776:	e4043603          	ld	a2,-448(s0)
    8000477a:	e3843783          	ld	a5,-456(s0)
    8000477e:	f8f669e3          	bltu	a2,a5,80004710 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004782:	e2843783          	ld	a5,-472(s0)
    80004786:	963e                	add	a2,a2,a5
    80004788:	f8f667e3          	bltu	a2,a5,80004716 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000478c:	85ca                	mv	a1,s2
    8000478e:	855e                	mv	a0,s7
    80004790:	ffffc097          	auipc	ra,0xffffc
    80004794:	11c080e7          	jalr	284(ra) # 800008ac <uvmalloc>
    80004798:	e0a43423          	sd	a0,-504(s0)
    8000479c:	d141                	beqz	a0,8000471c <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    8000479e:	e2843d03          	ld	s10,-472(s0)
    800047a2:	df043783          	ld	a5,-528(s0)
    800047a6:	00fd77b3          	and	a5,s10,a5
    800047aa:	fba1                	bnez	a5,800046fa <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800047ac:	e2042d83          	lw	s11,-480(s0)
    800047b0:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800047b4:	f80c03e3          	beqz	s8,8000473a <exec+0x306>
    800047b8:	8a62                	mv	s4,s8
    800047ba:	4901                	li	s2,0
    800047bc:	b345                	j	8000455c <exec+0x128>

00000000800047be <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800047be:	7179                	addi	sp,sp,-48
    800047c0:	f406                	sd	ra,40(sp)
    800047c2:	f022                	sd	s0,32(sp)
    800047c4:	ec26                	sd	s1,24(sp)
    800047c6:	e84a                	sd	s2,16(sp)
    800047c8:	1800                	addi	s0,sp,48
    800047ca:	892e                	mv	s2,a1
    800047cc:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800047ce:	fdc40593          	addi	a1,s0,-36
    800047d2:	ffffe097          	auipc	ra,0xffffe
    800047d6:	976080e7          	jalr	-1674(ra) # 80002148 <argint>
    800047da:	04054063          	bltz	a0,8000481a <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800047de:	fdc42703          	lw	a4,-36(s0)
    800047e2:	47bd                	li	a5,15
    800047e4:	02e7ed63          	bltu	a5,a4,8000481e <argfd+0x60>
    800047e8:	ffffc097          	auipc	ra,0xffffc
    800047ec:	646080e7          	jalr	1606(ra) # 80000e2e <myproc>
    800047f0:	fdc42703          	lw	a4,-36(s0)
    800047f4:	01a70793          	addi	a5,a4,26
    800047f8:	078e                	slli	a5,a5,0x3
    800047fa:	953e                	add	a0,a0,a5
    800047fc:	611c                	ld	a5,0(a0)
    800047fe:	c395                	beqz	a5,80004822 <argfd+0x64>
    return -1;
  if(pfd)
    80004800:	00090463          	beqz	s2,80004808 <argfd+0x4a>
    *pfd = fd;
    80004804:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004808:	4501                	li	a0,0
  if(pf)
    8000480a:	c091                	beqz	s1,8000480e <argfd+0x50>
    *pf = f;
    8000480c:	e09c                	sd	a5,0(s1)
}
    8000480e:	70a2                	ld	ra,40(sp)
    80004810:	7402                	ld	s0,32(sp)
    80004812:	64e2                	ld	s1,24(sp)
    80004814:	6942                	ld	s2,16(sp)
    80004816:	6145                	addi	sp,sp,48
    80004818:	8082                	ret
    return -1;
    8000481a:	557d                	li	a0,-1
    8000481c:	bfcd                	j	8000480e <argfd+0x50>
    return -1;
    8000481e:	557d                	li	a0,-1
    80004820:	b7fd                	j	8000480e <argfd+0x50>
    80004822:	557d                	li	a0,-1
    80004824:	b7ed                	j	8000480e <argfd+0x50>

0000000080004826 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004826:	1101                	addi	sp,sp,-32
    80004828:	ec06                	sd	ra,24(sp)
    8000482a:	e822                	sd	s0,16(sp)
    8000482c:	e426                	sd	s1,8(sp)
    8000482e:	1000                	addi	s0,sp,32
    80004830:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004832:	ffffc097          	auipc	ra,0xffffc
    80004836:	5fc080e7          	jalr	1532(ra) # 80000e2e <myproc>
    8000483a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000483c:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffcee90>
    80004840:	4501                	li	a0,0
    80004842:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004844:	6398                	ld	a4,0(a5)
    80004846:	cb19                	beqz	a4,8000485c <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004848:	2505                	addiw	a0,a0,1
    8000484a:	07a1                	addi	a5,a5,8
    8000484c:	fed51ce3          	bne	a0,a3,80004844 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004850:	557d                	li	a0,-1
}
    80004852:	60e2                	ld	ra,24(sp)
    80004854:	6442                	ld	s0,16(sp)
    80004856:	64a2                	ld	s1,8(sp)
    80004858:	6105                	addi	sp,sp,32
    8000485a:	8082                	ret
      p->ofile[fd] = f;
    8000485c:	01a50793          	addi	a5,a0,26
    80004860:	078e                	slli	a5,a5,0x3
    80004862:	963e                	add	a2,a2,a5
    80004864:	e204                	sd	s1,0(a2)
      return fd;
    80004866:	b7f5                	j	80004852 <fdalloc+0x2c>

0000000080004868 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004868:	715d                	addi	sp,sp,-80
    8000486a:	e486                	sd	ra,72(sp)
    8000486c:	e0a2                	sd	s0,64(sp)
    8000486e:	fc26                	sd	s1,56(sp)
    80004870:	f84a                	sd	s2,48(sp)
    80004872:	f44e                	sd	s3,40(sp)
    80004874:	f052                	sd	s4,32(sp)
    80004876:	ec56                	sd	s5,24(sp)
    80004878:	0880                	addi	s0,sp,80
    8000487a:	89ae                	mv	s3,a1
    8000487c:	8ab2                	mv	s5,a2
    8000487e:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004880:	fb040593          	addi	a1,s0,-80
    80004884:	fffff097          	auipc	ra,0xfffff
    80004888:	e86080e7          	jalr	-378(ra) # 8000370a <nameiparent>
    8000488c:	892a                	mv	s2,a0
    8000488e:	12050f63          	beqz	a0,800049cc <create+0x164>
    return 0;

  ilock(dp);
    80004892:	ffffe097          	auipc	ra,0xffffe
    80004896:	6a4080e7          	jalr	1700(ra) # 80002f36 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000489a:	4601                	li	a2,0
    8000489c:	fb040593          	addi	a1,s0,-80
    800048a0:	854a                	mv	a0,s2
    800048a2:	fffff097          	auipc	ra,0xfffff
    800048a6:	b78080e7          	jalr	-1160(ra) # 8000341a <dirlookup>
    800048aa:	84aa                	mv	s1,a0
    800048ac:	c921                	beqz	a0,800048fc <create+0x94>
    iunlockput(dp);
    800048ae:	854a                	mv	a0,s2
    800048b0:	fffff097          	auipc	ra,0xfffff
    800048b4:	8e8080e7          	jalr	-1816(ra) # 80003198 <iunlockput>
    ilock(ip);
    800048b8:	8526                	mv	a0,s1
    800048ba:	ffffe097          	auipc	ra,0xffffe
    800048be:	67c080e7          	jalr	1660(ra) # 80002f36 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800048c2:	2981                	sext.w	s3,s3
    800048c4:	4789                	li	a5,2
    800048c6:	02f99463          	bne	s3,a5,800048ee <create+0x86>
    800048ca:	0444d783          	lhu	a5,68(s1)
    800048ce:	37f9                	addiw	a5,a5,-2
    800048d0:	17c2                	slli	a5,a5,0x30
    800048d2:	93c1                	srli	a5,a5,0x30
    800048d4:	4705                	li	a4,1
    800048d6:	00f76c63          	bltu	a4,a5,800048ee <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800048da:	8526                	mv	a0,s1
    800048dc:	60a6                	ld	ra,72(sp)
    800048de:	6406                	ld	s0,64(sp)
    800048e0:	74e2                	ld	s1,56(sp)
    800048e2:	7942                	ld	s2,48(sp)
    800048e4:	79a2                	ld	s3,40(sp)
    800048e6:	7a02                	ld	s4,32(sp)
    800048e8:	6ae2                	ld	s5,24(sp)
    800048ea:	6161                	addi	sp,sp,80
    800048ec:	8082                	ret
    iunlockput(ip);
    800048ee:	8526                	mv	a0,s1
    800048f0:	fffff097          	auipc	ra,0xfffff
    800048f4:	8a8080e7          	jalr	-1880(ra) # 80003198 <iunlockput>
    return 0;
    800048f8:	4481                	li	s1,0
    800048fa:	b7c5                	j	800048da <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800048fc:	85ce                	mv	a1,s3
    800048fe:	00092503          	lw	a0,0(s2)
    80004902:	ffffe097          	auipc	ra,0xffffe
    80004906:	49c080e7          	jalr	1180(ra) # 80002d9e <ialloc>
    8000490a:	84aa                	mv	s1,a0
    8000490c:	c529                	beqz	a0,80004956 <create+0xee>
  ilock(ip);
    8000490e:	ffffe097          	auipc	ra,0xffffe
    80004912:	628080e7          	jalr	1576(ra) # 80002f36 <ilock>
  ip->major = major;
    80004916:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000491a:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000491e:	4785                	li	a5,1
    80004920:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004924:	8526                	mv	a0,s1
    80004926:	ffffe097          	auipc	ra,0xffffe
    8000492a:	546080e7          	jalr	1350(ra) # 80002e6c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000492e:	2981                	sext.w	s3,s3
    80004930:	4785                	li	a5,1
    80004932:	02f98a63          	beq	s3,a5,80004966 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004936:	40d0                	lw	a2,4(s1)
    80004938:	fb040593          	addi	a1,s0,-80
    8000493c:	854a                	mv	a0,s2
    8000493e:	fffff097          	auipc	ra,0xfffff
    80004942:	cec080e7          	jalr	-788(ra) # 8000362a <dirlink>
    80004946:	06054b63          	bltz	a0,800049bc <create+0x154>
  iunlockput(dp);
    8000494a:	854a                	mv	a0,s2
    8000494c:	fffff097          	auipc	ra,0xfffff
    80004950:	84c080e7          	jalr	-1972(ra) # 80003198 <iunlockput>
  return ip;
    80004954:	b759                	j	800048da <create+0x72>
    panic("create: ialloc");
    80004956:	00004517          	auipc	a0,0x4
    8000495a:	cea50513          	addi	a0,a0,-790 # 80008640 <syscalls+0x2b0>
    8000495e:	00001097          	auipc	ra,0x1
    80004962:	68a080e7          	jalr	1674(ra) # 80005fe8 <panic>
    dp->nlink++;  // for ".."
    80004966:	04a95783          	lhu	a5,74(s2)
    8000496a:	2785                	addiw	a5,a5,1
    8000496c:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004970:	854a                	mv	a0,s2
    80004972:	ffffe097          	auipc	ra,0xffffe
    80004976:	4fa080e7          	jalr	1274(ra) # 80002e6c <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000497a:	40d0                	lw	a2,4(s1)
    8000497c:	00004597          	auipc	a1,0x4
    80004980:	cd458593          	addi	a1,a1,-812 # 80008650 <syscalls+0x2c0>
    80004984:	8526                	mv	a0,s1
    80004986:	fffff097          	auipc	ra,0xfffff
    8000498a:	ca4080e7          	jalr	-860(ra) # 8000362a <dirlink>
    8000498e:	00054f63          	bltz	a0,800049ac <create+0x144>
    80004992:	00492603          	lw	a2,4(s2)
    80004996:	00004597          	auipc	a1,0x4
    8000499a:	cc258593          	addi	a1,a1,-830 # 80008658 <syscalls+0x2c8>
    8000499e:	8526                	mv	a0,s1
    800049a0:	fffff097          	auipc	ra,0xfffff
    800049a4:	c8a080e7          	jalr	-886(ra) # 8000362a <dirlink>
    800049a8:	f80557e3          	bgez	a0,80004936 <create+0xce>
      panic("create dots");
    800049ac:	00004517          	auipc	a0,0x4
    800049b0:	cb450513          	addi	a0,a0,-844 # 80008660 <syscalls+0x2d0>
    800049b4:	00001097          	auipc	ra,0x1
    800049b8:	634080e7          	jalr	1588(ra) # 80005fe8 <panic>
    panic("create: dirlink");
    800049bc:	00004517          	auipc	a0,0x4
    800049c0:	cb450513          	addi	a0,a0,-844 # 80008670 <syscalls+0x2e0>
    800049c4:	00001097          	auipc	ra,0x1
    800049c8:	624080e7          	jalr	1572(ra) # 80005fe8 <panic>
    return 0;
    800049cc:	84aa                	mv	s1,a0
    800049ce:	b731                	j	800048da <create+0x72>

00000000800049d0 <sys_dup>:
{
    800049d0:	7179                	addi	sp,sp,-48
    800049d2:	f406                	sd	ra,40(sp)
    800049d4:	f022                	sd	s0,32(sp)
    800049d6:	ec26                	sd	s1,24(sp)
    800049d8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800049da:	fd840613          	addi	a2,s0,-40
    800049de:	4581                	li	a1,0
    800049e0:	4501                	li	a0,0
    800049e2:	00000097          	auipc	ra,0x0
    800049e6:	ddc080e7          	jalr	-548(ra) # 800047be <argfd>
    return -1;
    800049ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800049ec:	02054363          	bltz	a0,80004a12 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800049f0:	fd843503          	ld	a0,-40(s0)
    800049f4:	00000097          	auipc	ra,0x0
    800049f8:	e32080e7          	jalr	-462(ra) # 80004826 <fdalloc>
    800049fc:	84aa                	mv	s1,a0
    return -1;
    800049fe:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004a00:	00054963          	bltz	a0,80004a12 <sys_dup+0x42>
  filedup(f);
    80004a04:	fd843503          	ld	a0,-40(s0)
    80004a08:	fffff097          	auipc	ra,0xfffff
    80004a0c:	37a080e7          	jalr	890(ra) # 80003d82 <filedup>
  return fd;
    80004a10:	87a6                	mv	a5,s1
}
    80004a12:	853e                	mv	a0,a5
    80004a14:	70a2                	ld	ra,40(sp)
    80004a16:	7402                	ld	s0,32(sp)
    80004a18:	64e2                	ld	s1,24(sp)
    80004a1a:	6145                	addi	sp,sp,48
    80004a1c:	8082                	ret

0000000080004a1e <sys_read>:
{
    80004a1e:	7179                	addi	sp,sp,-48
    80004a20:	f406                	sd	ra,40(sp)
    80004a22:	f022                	sd	s0,32(sp)
    80004a24:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a26:	fe840613          	addi	a2,s0,-24
    80004a2a:	4581                	li	a1,0
    80004a2c:	4501                	li	a0,0
    80004a2e:	00000097          	auipc	ra,0x0
    80004a32:	d90080e7          	jalr	-624(ra) # 800047be <argfd>
    return -1;
    80004a36:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a38:	04054163          	bltz	a0,80004a7a <sys_read+0x5c>
    80004a3c:	fe440593          	addi	a1,s0,-28
    80004a40:	4509                	li	a0,2
    80004a42:	ffffd097          	auipc	ra,0xffffd
    80004a46:	706080e7          	jalr	1798(ra) # 80002148 <argint>
    return -1;
    80004a4a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a4c:	02054763          	bltz	a0,80004a7a <sys_read+0x5c>
    80004a50:	fd840593          	addi	a1,s0,-40
    80004a54:	4505                	li	a0,1
    80004a56:	ffffd097          	auipc	ra,0xffffd
    80004a5a:	714080e7          	jalr	1812(ra) # 8000216a <argaddr>
    return -1;
    80004a5e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a60:	00054d63          	bltz	a0,80004a7a <sys_read+0x5c>
  return fileread(f, p, n);
    80004a64:	fe442603          	lw	a2,-28(s0)
    80004a68:	fd843583          	ld	a1,-40(s0)
    80004a6c:	fe843503          	ld	a0,-24(s0)
    80004a70:	fffff097          	auipc	ra,0xfffff
    80004a74:	49e080e7          	jalr	1182(ra) # 80003f0e <fileread>
    80004a78:	87aa                	mv	a5,a0
}
    80004a7a:	853e                	mv	a0,a5
    80004a7c:	70a2                	ld	ra,40(sp)
    80004a7e:	7402                	ld	s0,32(sp)
    80004a80:	6145                	addi	sp,sp,48
    80004a82:	8082                	ret

0000000080004a84 <sys_write>:
{
    80004a84:	7179                	addi	sp,sp,-48
    80004a86:	f406                	sd	ra,40(sp)
    80004a88:	f022                	sd	s0,32(sp)
    80004a8a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a8c:	fe840613          	addi	a2,s0,-24
    80004a90:	4581                	li	a1,0
    80004a92:	4501                	li	a0,0
    80004a94:	00000097          	auipc	ra,0x0
    80004a98:	d2a080e7          	jalr	-726(ra) # 800047be <argfd>
    return -1;
    80004a9c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a9e:	04054163          	bltz	a0,80004ae0 <sys_write+0x5c>
    80004aa2:	fe440593          	addi	a1,s0,-28
    80004aa6:	4509                	li	a0,2
    80004aa8:	ffffd097          	auipc	ra,0xffffd
    80004aac:	6a0080e7          	jalr	1696(ra) # 80002148 <argint>
    return -1;
    80004ab0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004ab2:	02054763          	bltz	a0,80004ae0 <sys_write+0x5c>
    80004ab6:	fd840593          	addi	a1,s0,-40
    80004aba:	4505                	li	a0,1
    80004abc:	ffffd097          	auipc	ra,0xffffd
    80004ac0:	6ae080e7          	jalr	1710(ra) # 8000216a <argaddr>
    return -1;
    80004ac4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004ac6:	00054d63          	bltz	a0,80004ae0 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004aca:	fe442603          	lw	a2,-28(s0)
    80004ace:	fd843583          	ld	a1,-40(s0)
    80004ad2:	fe843503          	ld	a0,-24(s0)
    80004ad6:	fffff097          	auipc	ra,0xfffff
    80004ada:	4fa080e7          	jalr	1274(ra) # 80003fd0 <filewrite>
    80004ade:	87aa                	mv	a5,a0
}
    80004ae0:	853e                	mv	a0,a5
    80004ae2:	70a2                	ld	ra,40(sp)
    80004ae4:	7402                	ld	s0,32(sp)
    80004ae6:	6145                	addi	sp,sp,48
    80004ae8:	8082                	ret

0000000080004aea <sys_close>:
{
    80004aea:	1101                	addi	sp,sp,-32
    80004aec:	ec06                	sd	ra,24(sp)
    80004aee:	e822                	sd	s0,16(sp)
    80004af0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004af2:	fe040613          	addi	a2,s0,-32
    80004af6:	fec40593          	addi	a1,s0,-20
    80004afa:	4501                	li	a0,0
    80004afc:	00000097          	auipc	ra,0x0
    80004b00:	cc2080e7          	jalr	-830(ra) # 800047be <argfd>
    return -1;
    80004b04:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004b06:	02054463          	bltz	a0,80004b2e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004b0a:	ffffc097          	auipc	ra,0xffffc
    80004b0e:	324080e7          	jalr	804(ra) # 80000e2e <myproc>
    80004b12:	fec42783          	lw	a5,-20(s0)
    80004b16:	07e9                	addi	a5,a5,26
    80004b18:	078e                	slli	a5,a5,0x3
    80004b1a:	97aa                	add	a5,a5,a0
    80004b1c:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004b20:	fe043503          	ld	a0,-32(s0)
    80004b24:	fffff097          	auipc	ra,0xfffff
    80004b28:	2b0080e7          	jalr	688(ra) # 80003dd4 <fileclose>
  return 0;
    80004b2c:	4781                	li	a5,0
}
    80004b2e:	853e                	mv	a0,a5
    80004b30:	60e2                	ld	ra,24(sp)
    80004b32:	6442                	ld	s0,16(sp)
    80004b34:	6105                	addi	sp,sp,32
    80004b36:	8082                	ret

0000000080004b38 <sys_fstat>:
{
    80004b38:	1101                	addi	sp,sp,-32
    80004b3a:	ec06                	sd	ra,24(sp)
    80004b3c:	e822                	sd	s0,16(sp)
    80004b3e:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004b40:	fe840613          	addi	a2,s0,-24
    80004b44:	4581                	li	a1,0
    80004b46:	4501                	li	a0,0
    80004b48:	00000097          	auipc	ra,0x0
    80004b4c:	c76080e7          	jalr	-906(ra) # 800047be <argfd>
    return -1;
    80004b50:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004b52:	02054563          	bltz	a0,80004b7c <sys_fstat+0x44>
    80004b56:	fe040593          	addi	a1,s0,-32
    80004b5a:	4505                	li	a0,1
    80004b5c:	ffffd097          	auipc	ra,0xffffd
    80004b60:	60e080e7          	jalr	1550(ra) # 8000216a <argaddr>
    return -1;
    80004b64:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004b66:	00054b63          	bltz	a0,80004b7c <sys_fstat+0x44>
  return filestat(f, st);
    80004b6a:	fe043583          	ld	a1,-32(s0)
    80004b6e:	fe843503          	ld	a0,-24(s0)
    80004b72:	fffff097          	auipc	ra,0xfffff
    80004b76:	32a080e7          	jalr	810(ra) # 80003e9c <filestat>
    80004b7a:	87aa                	mv	a5,a0
}
    80004b7c:	853e                	mv	a0,a5
    80004b7e:	60e2                	ld	ra,24(sp)
    80004b80:	6442                	ld	s0,16(sp)
    80004b82:	6105                	addi	sp,sp,32
    80004b84:	8082                	ret

0000000080004b86 <sys_link>:
{
    80004b86:	7169                	addi	sp,sp,-304
    80004b88:	f606                	sd	ra,296(sp)
    80004b8a:	f222                	sd	s0,288(sp)
    80004b8c:	ee26                	sd	s1,280(sp)
    80004b8e:	ea4a                	sd	s2,272(sp)
    80004b90:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b92:	08000613          	li	a2,128
    80004b96:	ed040593          	addi	a1,s0,-304
    80004b9a:	4501                	li	a0,0
    80004b9c:	ffffd097          	auipc	ra,0xffffd
    80004ba0:	5f0080e7          	jalr	1520(ra) # 8000218c <argstr>
    return -1;
    80004ba4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ba6:	10054e63          	bltz	a0,80004cc2 <sys_link+0x13c>
    80004baa:	08000613          	li	a2,128
    80004bae:	f5040593          	addi	a1,s0,-176
    80004bb2:	4505                	li	a0,1
    80004bb4:	ffffd097          	auipc	ra,0xffffd
    80004bb8:	5d8080e7          	jalr	1496(ra) # 8000218c <argstr>
    return -1;
    80004bbc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004bbe:	10054263          	bltz	a0,80004cc2 <sys_link+0x13c>
  begin_op();
    80004bc2:	fffff097          	auipc	ra,0xfffff
    80004bc6:	d46080e7          	jalr	-698(ra) # 80003908 <begin_op>
  if((ip = namei(old)) == 0){
    80004bca:	ed040513          	addi	a0,s0,-304
    80004bce:	fffff097          	auipc	ra,0xfffff
    80004bd2:	b1e080e7          	jalr	-1250(ra) # 800036ec <namei>
    80004bd6:	84aa                	mv	s1,a0
    80004bd8:	c551                	beqz	a0,80004c64 <sys_link+0xde>
  ilock(ip);
    80004bda:	ffffe097          	auipc	ra,0xffffe
    80004bde:	35c080e7          	jalr	860(ra) # 80002f36 <ilock>
  if(ip->type == T_DIR){
    80004be2:	04449703          	lh	a4,68(s1)
    80004be6:	4785                	li	a5,1
    80004be8:	08f70463          	beq	a4,a5,80004c70 <sys_link+0xea>
  ip->nlink++;
    80004bec:	04a4d783          	lhu	a5,74(s1)
    80004bf0:	2785                	addiw	a5,a5,1
    80004bf2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004bf6:	8526                	mv	a0,s1
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	274080e7          	jalr	628(ra) # 80002e6c <iupdate>
  iunlock(ip);
    80004c00:	8526                	mv	a0,s1
    80004c02:	ffffe097          	auipc	ra,0xffffe
    80004c06:	3f6080e7          	jalr	1014(ra) # 80002ff8 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004c0a:	fd040593          	addi	a1,s0,-48
    80004c0e:	f5040513          	addi	a0,s0,-176
    80004c12:	fffff097          	auipc	ra,0xfffff
    80004c16:	af8080e7          	jalr	-1288(ra) # 8000370a <nameiparent>
    80004c1a:	892a                	mv	s2,a0
    80004c1c:	c935                	beqz	a0,80004c90 <sys_link+0x10a>
  ilock(dp);
    80004c1e:	ffffe097          	auipc	ra,0xffffe
    80004c22:	318080e7          	jalr	792(ra) # 80002f36 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004c26:	00092703          	lw	a4,0(s2)
    80004c2a:	409c                	lw	a5,0(s1)
    80004c2c:	04f71d63          	bne	a4,a5,80004c86 <sys_link+0x100>
    80004c30:	40d0                	lw	a2,4(s1)
    80004c32:	fd040593          	addi	a1,s0,-48
    80004c36:	854a                	mv	a0,s2
    80004c38:	fffff097          	auipc	ra,0xfffff
    80004c3c:	9f2080e7          	jalr	-1550(ra) # 8000362a <dirlink>
    80004c40:	04054363          	bltz	a0,80004c86 <sys_link+0x100>
  iunlockput(dp);
    80004c44:	854a                	mv	a0,s2
    80004c46:	ffffe097          	auipc	ra,0xffffe
    80004c4a:	552080e7          	jalr	1362(ra) # 80003198 <iunlockput>
  iput(ip);
    80004c4e:	8526                	mv	a0,s1
    80004c50:	ffffe097          	auipc	ra,0xffffe
    80004c54:	4a0080e7          	jalr	1184(ra) # 800030f0 <iput>
  end_op();
    80004c58:	fffff097          	auipc	ra,0xfffff
    80004c5c:	d30080e7          	jalr	-720(ra) # 80003988 <end_op>
  return 0;
    80004c60:	4781                	li	a5,0
    80004c62:	a085                	j	80004cc2 <sys_link+0x13c>
    end_op();
    80004c64:	fffff097          	auipc	ra,0xfffff
    80004c68:	d24080e7          	jalr	-732(ra) # 80003988 <end_op>
    return -1;
    80004c6c:	57fd                	li	a5,-1
    80004c6e:	a891                	j	80004cc2 <sys_link+0x13c>
    iunlockput(ip);
    80004c70:	8526                	mv	a0,s1
    80004c72:	ffffe097          	auipc	ra,0xffffe
    80004c76:	526080e7          	jalr	1318(ra) # 80003198 <iunlockput>
    end_op();
    80004c7a:	fffff097          	auipc	ra,0xfffff
    80004c7e:	d0e080e7          	jalr	-754(ra) # 80003988 <end_op>
    return -1;
    80004c82:	57fd                	li	a5,-1
    80004c84:	a83d                	j	80004cc2 <sys_link+0x13c>
    iunlockput(dp);
    80004c86:	854a                	mv	a0,s2
    80004c88:	ffffe097          	auipc	ra,0xffffe
    80004c8c:	510080e7          	jalr	1296(ra) # 80003198 <iunlockput>
  ilock(ip);
    80004c90:	8526                	mv	a0,s1
    80004c92:	ffffe097          	auipc	ra,0xffffe
    80004c96:	2a4080e7          	jalr	676(ra) # 80002f36 <ilock>
  ip->nlink--;
    80004c9a:	04a4d783          	lhu	a5,74(s1)
    80004c9e:	37fd                	addiw	a5,a5,-1
    80004ca0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ca4:	8526                	mv	a0,s1
    80004ca6:	ffffe097          	auipc	ra,0xffffe
    80004caa:	1c6080e7          	jalr	454(ra) # 80002e6c <iupdate>
  iunlockput(ip);
    80004cae:	8526                	mv	a0,s1
    80004cb0:	ffffe097          	auipc	ra,0xffffe
    80004cb4:	4e8080e7          	jalr	1256(ra) # 80003198 <iunlockput>
  end_op();
    80004cb8:	fffff097          	auipc	ra,0xfffff
    80004cbc:	cd0080e7          	jalr	-816(ra) # 80003988 <end_op>
  return -1;
    80004cc0:	57fd                	li	a5,-1
}
    80004cc2:	853e                	mv	a0,a5
    80004cc4:	70b2                	ld	ra,296(sp)
    80004cc6:	7412                	ld	s0,288(sp)
    80004cc8:	64f2                	ld	s1,280(sp)
    80004cca:	6952                	ld	s2,272(sp)
    80004ccc:	6155                	addi	sp,sp,304
    80004cce:	8082                	ret

0000000080004cd0 <sys_unlink>:
{
    80004cd0:	7151                	addi	sp,sp,-240
    80004cd2:	f586                	sd	ra,232(sp)
    80004cd4:	f1a2                	sd	s0,224(sp)
    80004cd6:	eda6                	sd	s1,216(sp)
    80004cd8:	e9ca                	sd	s2,208(sp)
    80004cda:	e5ce                	sd	s3,200(sp)
    80004cdc:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004cde:	08000613          	li	a2,128
    80004ce2:	f3040593          	addi	a1,s0,-208
    80004ce6:	4501                	li	a0,0
    80004ce8:	ffffd097          	auipc	ra,0xffffd
    80004cec:	4a4080e7          	jalr	1188(ra) # 8000218c <argstr>
    80004cf0:	18054163          	bltz	a0,80004e72 <sys_unlink+0x1a2>
  begin_op();
    80004cf4:	fffff097          	auipc	ra,0xfffff
    80004cf8:	c14080e7          	jalr	-1004(ra) # 80003908 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004cfc:	fb040593          	addi	a1,s0,-80
    80004d00:	f3040513          	addi	a0,s0,-208
    80004d04:	fffff097          	auipc	ra,0xfffff
    80004d08:	a06080e7          	jalr	-1530(ra) # 8000370a <nameiparent>
    80004d0c:	84aa                	mv	s1,a0
    80004d0e:	c979                	beqz	a0,80004de4 <sys_unlink+0x114>
  ilock(dp);
    80004d10:	ffffe097          	auipc	ra,0xffffe
    80004d14:	226080e7          	jalr	550(ra) # 80002f36 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004d18:	00004597          	auipc	a1,0x4
    80004d1c:	93858593          	addi	a1,a1,-1736 # 80008650 <syscalls+0x2c0>
    80004d20:	fb040513          	addi	a0,s0,-80
    80004d24:	ffffe097          	auipc	ra,0xffffe
    80004d28:	6dc080e7          	jalr	1756(ra) # 80003400 <namecmp>
    80004d2c:	14050a63          	beqz	a0,80004e80 <sys_unlink+0x1b0>
    80004d30:	00004597          	auipc	a1,0x4
    80004d34:	92858593          	addi	a1,a1,-1752 # 80008658 <syscalls+0x2c8>
    80004d38:	fb040513          	addi	a0,s0,-80
    80004d3c:	ffffe097          	auipc	ra,0xffffe
    80004d40:	6c4080e7          	jalr	1732(ra) # 80003400 <namecmp>
    80004d44:	12050e63          	beqz	a0,80004e80 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004d48:	f2c40613          	addi	a2,s0,-212
    80004d4c:	fb040593          	addi	a1,s0,-80
    80004d50:	8526                	mv	a0,s1
    80004d52:	ffffe097          	auipc	ra,0xffffe
    80004d56:	6c8080e7          	jalr	1736(ra) # 8000341a <dirlookup>
    80004d5a:	892a                	mv	s2,a0
    80004d5c:	12050263          	beqz	a0,80004e80 <sys_unlink+0x1b0>
  ilock(ip);
    80004d60:	ffffe097          	auipc	ra,0xffffe
    80004d64:	1d6080e7          	jalr	470(ra) # 80002f36 <ilock>
  if(ip->nlink < 1)
    80004d68:	04a91783          	lh	a5,74(s2)
    80004d6c:	08f05263          	blez	a5,80004df0 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004d70:	04491703          	lh	a4,68(s2)
    80004d74:	4785                	li	a5,1
    80004d76:	08f70563          	beq	a4,a5,80004e00 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004d7a:	4641                	li	a2,16
    80004d7c:	4581                	li	a1,0
    80004d7e:	fc040513          	addi	a0,s0,-64
    80004d82:	ffffb097          	auipc	ra,0xffffb
    80004d86:	3f6080e7          	jalr	1014(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d8a:	4741                	li	a4,16
    80004d8c:	f2c42683          	lw	a3,-212(s0)
    80004d90:	fc040613          	addi	a2,s0,-64
    80004d94:	4581                	li	a1,0
    80004d96:	8526                	mv	a0,s1
    80004d98:	ffffe097          	auipc	ra,0xffffe
    80004d9c:	54a080e7          	jalr	1354(ra) # 800032e2 <writei>
    80004da0:	47c1                	li	a5,16
    80004da2:	0af51563          	bne	a0,a5,80004e4c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004da6:	04491703          	lh	a4,68(s2)
    80004daa:	4785                	li	a5,1
    80004dac:	0af70863          	beq	a4,a5,80004e5c <sys_unlink+0x18c>
  iunlockput(dp);
    80004db0:	8526                	mv	a0,s1
    80004db2:	ffffe097          	auipc	ra,0xffffe
    80004db6:	3e6080e7          	jalr	998(ra) # 80003198 <iunlockput>
  ip->nlink--;
    80004dba:	04a95783          	lhu	a5,74(s2)
    80004dbe:	37fd                	addiw	a5,a5,-1
    80004dc0:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004dc4:	854a                	mv	a0,s2
    80004dc6:	ffffe097          	auipc	ra,0xffffe
    80004dca:	0a6080e7          	jalr	166(ra) # 80002e6c <iupdate>
  iunlockput(ip);
    80004dce:	854a                	mv	a0,s2
    80004dd0:	ffffe097          	auipc	ra,0xffffe
    80004dd4:	3c8080e7          	jalr	968(ra) # 80003198 <iunlockput>
  end_op();
    80004dd8:	fffff097          	auipc	ra,0xfffff
    80004ddc:	bb0080e7          	jalr	-1104(ra) # 80003988 <end_op>
  return 0;
    80004de0:	4501                	li	a0,0
    80004de2:	a84d                	j	80004e94 <sys_unlink+0x1c4>
    end_op();
    80004de4:	fffff097          	auipc	ra,0xfffff
    80004de8:	ba4080e7          	jalr	-1116(ra) # 80003988 <end_op>
    return -1;
    80004dec:	557d                	li	a0,-1
    80004dee:	a05d                	j	80004e94 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004df0:	00004517          	auipc	a0,0x4
    80004df4:	89050513          	addi	a0,a0,-1904 # 80008680 <syscalls+0x2f0>
    80004df8:	00001097          	auipc	ra,0x1
    80004dfc:	1f0080e7          	jalr	496(ra) # 80005fe8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e00:	04c92703          	lw	a4,76(s2)
    80004e04:	02000793          	li	a5,32
    80004e08:	f6e7f9e3          	bgeu	a5,a4,80004d7a <sys_unlink+0xaa>
    80004e0c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004e10:	4741                	li	a4,16
    80004e12:	86ce                	mv	a3,s3
    80004e14:	f1840613          	addi	a2,s0,-232
    80004e18:	4581                	li	a1,0
    80004e1a:	854a                	mv	a0,s2
    80004e1c:	ffffe097          	auipc	ra,0xffffe
    80004e20:	3ce080e7          	jalr	974(ra) # 800031ea <readi>
    80004e24:	47c1                	li	a5,16
    80004e26:	00f51b63          	bne	a0,a5,80004e3c <sys_unlink+0x16c>
    if(de.inum != 0)
    80004e2a:	f1845783          	lhu	a5,-232(s0)
    80004e2e:	e7a1                	bnez	a5,80004e76 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e30:	29c1                	addiw	s3,s3,16
    80004e32:	04c92783          	lw	a5,76(s2)
    80004e36:	fcf9ede3          	bltu	s3,a5,80004e10 <sys_unlink+0x140>
    80004e3a:	b781                	j	80004d7a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004e3c:	00004517          	auipc	a0,0x4
    80004e40:	85c50513          	addi	a0,a0,-1956 # 80008698 <syscalls+0x308>
    80004e44:	00001097          	auipc	ra,0x1
    80004e48:	1a4080e7          	jalr	420(ra) # 80005fe8 <panic>
    panic("unlink: writei");
    80004e4c:	00004517          	auipc	a0,0x4
    80004e50:	86450513          	addi	a0,a0,-1948 # 800086b0 <syscalls+0x320>
    80004e54:	00001097          	auipc	ra,0x1
    80004e58:	194080e7          	jalr	404(ra) # 80005fe8 <panic>
    dp->nlink--;
    80004e5c:	04a4d783          	lhu	a5,74(s1)
    80004e60:	37fd                	addiw	a5,a5,-1
    80004e62:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004e66:	8526                	mv	a0,s1
    80004e68:	ffffe097          	auipc	ra,0xffffe
    80004e6c:	004080e7          	jalr	4(ra) # 80002e6c <iupdate>
    80004e70:	b781                	j	80004db0 <sys_unlink+0xe0>
    return -1;
    80004e72:	557d                	li	a0,-1
    80004e74:	a005                	j	80004e94 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004e76:	854a                	mv	a0,s2
    80004e78:	ffffe097          	auipc	ra,0xffffe
    80004e7c:	320080e7          	jalr	800(ra) # 80003198 <iunlockput>
  iunlockput(dp);
    80004e80:	8526                	mv	a0,s1
    80004e82:	ffffe097          	auipc	ra,0xffffe
    80004e86:	316080e7          	jalr	790(ra) # 80003198 <iunlockput>
  end_op();
    80004e8a:	fffff097          	auipc	ra,0xfffff
    80004e8e:	afe080e7          	jalr	-1282(ra) # 80003988 <end_op>
  return -1;
    80004e92:	557d                	li	a0,-1
}
    80004e94:	70ae                	ld	ra,232(sp)
    80004e96:	740e                	ld	s0,224(sp)
    80004e98:	64ee                	ld	s1,216(sp)
    80004e9a:	694e                	ld	s2,208(sp)
    80004e9c:	69ae                	ld	s3,200(sp)
    80004e9e:	616d                	addi	sp,sp,240
    80004ea0:	8082                	ret

0000000080004ea2 <sys_open>:

uint64
sys_open(void)
{
    80004ea2:	7131                	addi	sp,sp,-192
    80004ea4:	fd06                	sd	ra,184(sp)
    80004ea6:	f922                	sd	s0,176(sp)
    80004ea8:	f526                	sd	s1,168(sp)
    80004eaa:	f14a                	sd	s2,160(sp)
    80004eac:	ed4e                	sd	s3,152(sp)
    80004eae:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004eb0:	08000613          	li	a2,128
    80004eb4:	f5040593          	addi	a1,s0,-176
    80004eb8:	4501                	li	a0,0
    80004eba:	ffffd097          	auipc	ra,0xffffd
    80004ebe:	2d2080e7          	jalr	722(ra) # 8000218c <argstr>
    return -1;
    80004ec2:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ec4:	0c054163          	bltz	a0,80004f86 <sys_open+0xe4>
    80004ec8:	f4c40593          	addi	a1,s0,-180
    80004ecc:	4505                	li	a0,1
    80004ece:	ffffd097          	auipc	ra,0xffffd
    80004ed2:	27a080e7          	jalr	634(ra) # 80002148 <argint>
    80004ed6:	0a054863          	bltz	a0,80004f86 <sys_open+0xe4>

  begin_op();
    80004eda:	fffff097          	auipc	ra,0xfffff
    80004ede:	a2e080e7          	jalr	-1490(ra) # 80003908 <begin_op>

  if(omode & O_CREATE){
    80004ee2:	f4c42783          	lw	a5,-180(s0)
    80004ee6:	2007f793          	andi	a5,a5,512
    80004eea:	cbdd                	beqz	a5,80004fa0 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004eec:	4681                	li	a3,0
    80004eee:	4601                	li	a2,0
    80004ef0:	4589                	li	a1,2
    80004ef2:	f5040513          	addi	a0,s0,-176
    80004ef6:	00000097          	auipc	ra,0x0
    80004efa:	972080e7          	jalr	-1678(ra) # 80004868 <create>
    80004efe:	892a                	mv	s2,a0
    if(ip == 0){
    80004f00:	c959                	beqz	a0,80004f96 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004f02:	04491703          	lh	a4,68(s2)
    80004f06:	478d                	li	a5,3
    80004f08:	00f71763          	bne	a4,a5,80004f16 <sys_open+0x74>
    80004f0c:	04695703          	lhu	a4,70(s2)
    80004f10:	47a5                	li	a5,9
    80004f12:	0ce7ec63          	bltu	a5,a4,80004fea <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004f16:	fffff097          	auipc	ra,0xfffff
    80004f1a:	e02080e7          	jalr	-510(ra) # 80003d18 <filealloc>
    80004f1e:	89aa                	mv	s3,a0
    80004f20:	10050263          	beqz	a0,80005024 <sys_open+0x182>
    80004f24:	00000097          	auipc	ra,0x0
    80004f28:	902080e7          	jalr	-1790(ra) # 80004826 <fdalloc>
    80004f2c:	84aa                	mv	s1,a0
    80004f2e:	0e054663          	bltz	a0,8000501a <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004f32:	04491703          	lh	a4,68(s2)
    80004f36:	478d                	li	a5,3
    80004f38:	0cf70463          	beq	a4,a5,80005000 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004f3c:	4789                	li	a5,2
    80004f3e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004f42:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004f46:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004f4a:	f4c42783          	lw	a5,-180(s0)
    80004f4e:	0017c713          	xori	a4,a5,1
    80004f52:	8b05                	andi	a4,a4,1
    80004f54:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f58:	0037f713          	andi	a4,a5,3
    80004f5c:	00e03733          	snez	a4,a4
    80004f60:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004f64:	4007f793          	andi	a5,a5,1024
    80004f68:	c791                	beqz	a5,80004f74 <sys_open+0xd2>
    80004f6a:	04491703          	lh	a4,68(s2)
    80004f6e:	4789                	li	a5,2
    80004f70:	08f70f63          	beq	a4,a5,8000500e <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004f74:	854a                	mv	a0,s2
    80004f76:	ffffe097          	auipc	ra,0xffffe
    80004f7a:	082080e7          	jalr	130(ra) # 80002ff8 <iunlock>
  end_op();
    80004f7e:	fffff097          	auipc	ra,0xfffff
    80004f82:	a0a080e7          	jalr	-1526(ra) # 80003988 <end_op>

  return fd;
}
    80004f86:	8526                	mv	a0,s1
    80004f88:	70ea                	ld	ra,184(sp)
    80004f8a:	744a                	ld	s0,176(sp)
    80004f8c:	74aa                	ld	s1,168(sp)
    80004f8e:	790a                	ld	s2,160(sp)
    80004f90:	69ea                	ld	s3,152(sp)
    80004f92:	6129                	addi	sp,sp,192
    80004f94:	8082                	ret
      end_op();
    80004f96:	fffff097          	auipc	ra,0xfffff
    80004f9a:	9f2080e7          	jalr	-1550(ra) # 80003988 <end_op>
      return -1;
    80004f9e:	b7e5                	j	80004f86 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004fa0:	f5040513          	addi	a0,s0,-176
    80004fa4:	ffffe097          	auipc	ra,0xffffe
    80004fa8:	748080e7          	jalr	1864(ra) # 800036ec <namei>
    80004fac:	892a                	mv	s2,a0
    80004fae:	c905                	beqz	a0,80004fde <sys_open+0x13c>
    ilock(ip);
    80004fb0:	ffffe097          	auipc	ra,0xffffe
    80004fb4:	f86080e7          	jalr	-122(ra) # 80002f36 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004fb8:	04491703          	lh	a4,68(s2)
    80004fbc:	4785                	li	a5,1
    80004fbe:	f4f712e3          	bne	a4,a5,80004f02 <sys_open+0x60>
    80004fc2:	f4c42783          	lw	a5,-180(s0)
    80004fc6:	dba1                	beqz	a5,80004f16 <sys_open+0x74>
      iunlockput(ip);
    80004fc8:	854a                	mv	a0,s2
    80004fca:	ffffe097          	auipc	ra,0xffffe
    80004fce:	1ce080e7          	jalr	462(ra) # 80003198 <iunlockput>
      end_op();
    80004fd2:	fffff097          	auipc	ra,0xfffff
    80004fd6:	9b6080e7          	jalr	-1610(ra) # 80003988 <end_op>
      return -1;
    80004fda:	54fd                	li	s1,-1
    80004fdc:	b76d                	j	80004f86 <sys_open+0xe4>
      end_op();
    80004fde:	fffff097          	auipc	ra,0xfffff
    80004fe2:	9aa080e7          	jalr	-1622(ra) # 80003988 <end_op>
      return -1;
    80004fe6:	54fd                	li	s1,-1
    80004fe8:	bf79                	j	80004f86 <sys_open+0xe4>
    iunlockput(ip);
    80004fea:	854a                	mv	a0,s2
    80004fec:	ffffe097          	auipc	ra,0xffffe
    80004ff0:	1ac080e7          	jalr	428(ra) # 80003198 <iunlockput>
    end_op();
    80004ff4:	fffff097          	auipc	ra,0xfffff
    80004ff8:	994080e7          	jalr	-1644(ra) # 80003988 <end_op>
    return -1;
    80004ffc:	54fd                	li	s1,-1
    80004ffe:	b761                	j	80004f86 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005000:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005004:	04691783          	lh	a5,70(s2)
    80005008:	02f99223          	sh	a5,36(s3)
    8000500c:	bf2d                	j	80004f46 <sys_open+0xa4>
    itrunc(ip);
    8000500e:	854a                	mv	a0,s2
    80005010:	ffffe097          	auipc	ra,0xffffe
    80005014:	034080e7          	jalr	52(ra) # 80003044 <itrunc>
    80005018:	bfb1                	j	80004f74 <sys_open+0xd2>
      fileclose(f);
    8000501a:	854e                	mv	a0,s3
    8000501c:	fffff097          	auipc	ra,0xfffff
    80005020:	db8080e7          	jalr	-584(ra) # 80003dd4 <fileclose>
    iunlockput(ip);
    80005024:	854a                	mv	a0,s2
    80005026:	ffffe097          	auipc	ra,0xffffe
    8000502a:	172080e7          	jalr	370(ra) # 80003198 <iunlockput>
    end_op();
    8000502e:	fffff097          	auipc	ra,0xfffff
    80005032:	95a080e7          	jalr	-1702(ra) # 80003988 <end_op>
    return -1;
    80005036:	54fd                	li	s1,-1
    80005038:	b7b9                	j	80004f86 <sys_open+0xe4>

000000008000503a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000503a:	7175                	addi	sp,sp,-144
    8000503c:	e506                	sd	ra,136(sp)
    8000503e:	e122                	sd	s0,128(sp)
    80005040:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005042:	fffff097          	auipc	ra,0xfffff
    80005046:	8c6080e7          	jalr	-1850(ra) # 80003908 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000504a:	08000613          	li	a2,128
    8000504e:	f7040593          	addi	a1,s0,-144
    80005052:	4501                	li	a0,0
    80005054:	ffffd097          	auipc	ra,0xffffd
    80005058:	138080e7          	jalr	312(ra) # 8000218c <argstr>
    8000505c:	02054963          	bltz	a0,8000508e <sys_mkdir+0x54>
    80005060:	4681                	li	a3,0
    80005062:	4601                	li	a2,0
    80005064:	4585                	li	a1,1
    80005066:	f7040513          	addi	a0,s0,-144
    8000506a:	fffff097          	auipc	ra,0xfffff
    8000506e:	7fe080e7          	jalr	2046(ra) # 80004868 <create>
    80005072:	cd11                	beqz	a0,8000508e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005074:	ffffe097          	auipc	ra,0xffffe
    80005078:	124080e7          	jalr	292(ra) # 80003198 <iunlockput>
  end_op();
    8000507c:	fffff097          	auipc	ra,0xfffff
    80005080:	90c080e7          	jalr	-1780(ra) # 80003988 <end_op>
  return 0;
    80005084:	4501                	li	a0,0
}
    80005086:	60aa                	ld	ra,136(sp)
    80005088:	640a                	ld	s0,128(sp)
    8000508a:	6149                	addi	sp,sp,144
    8000508c:	8082                	ret
    end_op();
    8000508e:	fffff097          	auipc	ra,0xfffff
    80005092:	8fa080e7          	jalr	-1798(ra) # 80003988 <end_op>
    return -1;
    80005096:	557d                	li	a0,-1
    80005098:	b7fd                	j	80005086 <sys_mkdir+0x4c>

000000008000509a <sys_mknod>:

uint64
sys_mknod(void)
{
    8000509a:	7135                	addi	sp,sp,-160
    8000509c:	ed06                	sd	ra,152(sp)
    8000509e:	e922                	sd	s0,144(sp)
    800050a0:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800050a2:	fffff097          	auipc	ra,0xfffff
    800050a6:	866080e7          	jalr	-1946(ra) # 80003908 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050aa:	08000613          	li	a2,128
    800050ae:	f7040593          	addi	a1,s0,-144
    800050b2:	4501                	li	a0,0
    800050b4:	ffffd097          	auipc	ra,0xffffd
    800050b8:	0d8080e7          	jalr	216(ra) # 8000218c <argstr>
    800050bc:	04054a63          	bltz	a0,80005110 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    800050c0:	f6c40593          	addi	a1,s0,-148
    800050c4:	4505                	li	a0,1
    800050c6:	ffffd097          	auipc	ra,0xffffd
    800050ca:	082080e7          	jalr	130(ra) # 80002148 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050ce:	04054163          	bltz	a0,80005110 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    800050d2:	f6840593          	addi	a1,s0,-152
    800050d6:	4509                	li	a0,2
    800050d8:	ffffd097          	auipc	ra,0xffffd
    800050dc:	070080e7          	jalr	112(ra) # 80002148 <argint>
     argint(1, &major) < 0 ||
    800050e0:	02054863          	bltz	a0,80005110 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800050e4:	f6841683          	lh	a3,-152(s0)
    800050e8:	f6c41603          	lh	a2,-148(s0)
    800050ec:	458d                	li	a1,3
    800050ee:	f7040513          	addi	a0,s0,-144
    800050f2:	fffff097          	auipc	ra,0xfffff
    800050f6:	776080e7          	jalr	1910(ra) # 80004868 <create>
     argint(2, &minor) < 0 ||
    800050fa:	c919                	beqz	a0,80005110 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050fc:	ffffe097          	auipc	ra,0xffffe
    80005100:	09c080e7          	jalr	156(ra) # 80003198 <iunlockput>
  end_op();
    80005104:	fffff097          	auipc	ra,0xfffff
    80005108:	884080e7          	jalr	-1916(ra) # 80003988 <end_op>
  return 0;
    8000510c:	4501                	li	a0,0
    8000510e:	a031                	j	8000511a <sys_mknod+0x80>
    end_op();
    80005110:	fffff097          	auipc	ra,0xfffff
    80005114:	878080e7          	jalr	-1928(ra) # 80003988 <end_op>
    return -1;
    80005118:	557d                	li	a0,-1
}
    8000511a:	60ea                	ld	ra,152(sp)
    8000511c:	644a                	ld	s0,144(sp)
    8000511e:	610d                	addi	sp,sp,160
    80005120:	8082                	ret

0000000080005122 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005122:	7135                	addi	sp,sp,-160
    80005124:	ed06                	sd	ra,152(sp)
    80005126:	e922                	sd	s0,144(sp)
    80005128:	e526                	sd	s1,136(sp)
    8000512a:	e14a                	sd	s2,128(sp)
    8000512c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000512e:	ffffc097          	auipc	ra,0xffffc
    80005132:	d00080e7          	jalr	-768(ra) # 80000e2e <myproc>
    80005136:	892a                	mv	s2,a0
  
  begin_op();
    80005138:	ffffe097          	auipc	ra,0xffffe
    8000513c:	7d0080e7          	jalr	2000(ra) # 80003908 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005140:	08000613          	li	a2,128
    80005144:	f6040593          	addi	a1,s0,-160
    80005148:	4501                	li	a0,0
    8000514a:	ffffd097          	auipc	ra,0xffffd
    8000514e:	042080e7          	jalr	66(ra) # 8000218c <argstr>
    80005152:	04054b63          	bltz	a0,800051a8 <sys_chdir+0x86>
    80005156:	f6040513          	addi	a0,s0,-160
    8000515a:	ffffe097          	auipc	ra,0xffffe
    8000515e:	592080e7          	jalr	1426(ra) # 800036ec <namei>
    80005162:	84aa                	mv	s1,a0
    80005164:	c131                	beqz	a0,800051a8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005166:	ffffe097          	auipc	ra,0xffffe
    8000516a:	dd0080e7          	jalr	-560(ra) # 80002f36 <ilock>
  if(ip->type != T_DIR){
    8000516e:	04449703          	lh	a4,68(s1)
    80005172:	4785                	li	a5,1
    80005174:	04f71063          	bne	a4,a5,800051b4 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005178:	8526                	mv	a0,s1
    8000517a:	ffffe097          	auipc	ra,0xffffe
    8000517e:	e7e080e7          	jalr	-386(ra) # 80002ff8 <iunlock>
  iput(p->cwd);
    80005182:	15093503          	ld	a0,336(s2)
    80005186:	ffffe097          	auipc	ra,0xffffe
    8000518a:	f6a080e7          	jalr	-150(ra) # 800030f0 <iput>
  end_op();
    8000518e:	ffffe097          	auipc	ra,0xffffe
    80005192:	7fa080e7          	jalr	2042(ra) # 80003988 <end_op>
  p->cwd = ip;
    80005196:	14993823          	sd	s1,336(s2)
  return 0;
    8000519a:	4501                	li	a0,0
}
    8000519c:	60ea                	ld	ra,152(sp)
    8000519e:	644a                	ld	s0,144(sp)
    800051a0:	64aa                	ld	s1,136(sp)
    800051a2:	690a                	ld	s2,128(sp)
    800051a4:	610d                	addi	sp,sp,160
    800051a6:	8082                	ret
    end_op();
    800051a8:	ffffe097          	auipc	ra,0xffffe
    800051ac:	7e0080e7          	jalr	2016(ra) # 80003988 <end_op>
    return -1;
    800051b0:	557d                	li	a0,-1
    800051b2:	b7ed                	j	8000519c <sys_chdir+0x7a>
    iunlockput(ip);
    800051b4:	8526                	mv	a0,s1
    800051b6:	ffffe097          	auipc	ra,0xffffe
    800051ba:	fe2080e7          	jalr	-30(ra) # 80003198 <iunlockput>
    end_op();
    800051be:	ffffe097          	auipc	ra,0xffffe
    800051c2:	7ca080e7          	jalr	1994(ra) # 80003988 <end_op>
    return -1;
    800051c6:	557d                	li	a0,-1
    800051c8:	bfd1                	j	8000519c <sys_chdir+0x7a>

00000000800051ca <sys_exec>:

uint64
sys_exec(void)
{
    800051ca:	7145                	addi	sp,sp,-464
    800051cc:	e786                	sd	ra,456(sp)
    800051ce:	e3a2                	sd	s0,448(sp)
    800051d0:	ff26                	sd	s1,440(sp)
    800051d2:	fb4a                	sd	s2,432(sp)
    800051d4:	f74e                	sd	s3,424(sp)
    800051d6:	f352                	sd	s4,416(sp)
    800051d8:	ef56                	sd	s5,408(sp)
    800051da:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800051dc:	08000613          	li	a2,128
    800051e0:	f4040593          	addi	a1,s0,-192
    800051e4:	4501                	li	a0,0
    800051e6:	ffffd097          	auipc	ra,0xffffd
    800051ea:	fa6080e7          	jalr	-90(ra) # 8000218c <argstr>
    return -1;
    800051ee:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800051f0:	0c054a63          	bltz	a0,800052c4 <sys_exec+0xfa>
    800051f4:	e3840593          	addi	a1,s0,-456
    800051f8:	4505                	li	a0,1
    800051fa:	ffffd097          	auipc	ra,0xffffd
    800051fe:	f70080e7          	jalr	-144(ra) # 8000216a <argaddr>
    80005202:	0c054163          	bltz	a0,800052c4 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005206:	10000613          	li	a2,256
    8000520a:	4581                	li	a1,0
    8000520c:	e4040513          	addi	a0,s0,-448
    80005210:	ffffb097          	auipc	ra,0xffffb
    80005214:	f68080e7          	jalr	-152(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005218:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000521c:	89a6                	mv	s3,s1
    8000521e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005220:	02000a13          	li	s4,32
    80005224:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005228:	00391513          	slli	a0,s2,0x3
    8000522c:	e3040593          	addi	a1,s0,-464
    80005230:	e3843783          	ld	a5,-456(s0)
    80005234:	953e                	add	a0,a0,a5
    80005236:	ffffd097          	auipc	ra,0xffffd
    8000523a:	e78080e7          	jalr	-392(ra) # 800020ae <fetchaddr>
    8000523e:	02054a63          	bltz	a0,80005272 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005242:	e3043783          	ld	a5,-464(s0)
    80005246:	c3b9                	beqz	a5,8000528c <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005248:	ffffb097          	auipc	ra,0xffffb
    8000524c:	ed0080e7          	jalr	-304(ra) # 80000118 <kalloc>
    80005250:	85aa                	mv	a1,a0
    80005252:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005256:	cd11                	beqz	a0,80005272 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005258:	6605                	lui	a2,0x1
    8000525a:	e3043503          	ld	a0,-464(s0)
    8000525e:	ffffd097          	auipc	ra,0xffffd
    80005262:	ea2080e7          	jalr	-350(ra) # 80002100 <fetchstr>
    80005266:	00054663          	bltz	a0,80005272 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    8000526a:	0905                	addi	s2,s2,1
    8000526c:	09a1                	addi	s3,s3,8
    8000526e:	fb491be3          	bne	s2,s4,80005224 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005272:	10048913          	addi	s2,s1,256
    80005276:	6088                	ld	a0,0(s1)
    80005278:	c529                	beqz	a0,800052c2 <sys_exec+0xf8>
    kfree(argv[i]);
    8000527a:	ffffb097          	auipc	ra,0xffffb
    8000527e:	da2080e7          	jalr	-606(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005282:	04a1                	addi	s1,s1,8
    80005284:	ff2499e3          	bne	s1,s2,80005276 <sys_exec+0xac>
  return -1;
    80005288:	597d                	li	s2,-1
    8000528a:	a82d                	j	800052c4 <sys_exec+0xfa>
      argv[i] = 0;
    8000528c:	0a8e                	slli	s5,s5,0x3
    8000528e:	fc040793          	addi	a5,s0,-64
    80005292:	9abe                	add	s5,s5,a5
    80005294:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005298:	e4040593          	addi	a1,s0,-448
    8000529c:	f4040513          	addi	a0,s0,-192
    800052a0:	fffff097          	auipc	ra,0xfffff
    800052a4:	194080e7          	jalr	404(ra) # 80004434 <exec>
    800052a8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052aa:	10048993          	addi	s3,s1,256
    800052ae:	6088                	ld	a0,0(s1)
    800052b0:	c911                	beqz	a0,800052c4 <sys_exec+0xfa>
    kfree(argv[i]);
    800052b2:	ffffb097          	auipc	ra,0xffffb
    800052b6:	d6a080e7          	jalr	-662(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052ba:	04a1                	addi	s1,s1,8
    800052bc:	ff3499e3          	bne	s1,s3,800052ae <sys_exec+0xe4>
    800052c0:	a011                	j	800052c4 <sys_exec+0xfa>
  return -1;
    800052c2:	597d                	li	s2,-1
}
    800052c4:	854a                	mv	a0,s2
    800052c6:	60be                	ld	ra,456(sp)
    800052c8:	641e                	ld	s0,448(sp)
    800052ca:	74fa                	ld	s1,440(sp)
    800052cc:	795a                	ld	s2,432(sp)
    800052ce:	79ba                	ld	s3,424(sp)
    800052d0:	7a1a                	ld	s4,416(sp)
    800052d2:	6afa                	ld	s5,408(sp)
    800052d4:	6179                	addi	sp,sp,464
    800052d6:	8082                	ret

00000000800052d8 <sys_pipe>:

uint64
sys_pipe(void)
{
    800052d8:	7139                	addi	sp,sp,-64
    800052da:	fc06                	sd	ra,56(sp)
    800052dc:	f822                	sd	s0,48(sp)
    800052de:	f426                	sd	s1,40(sp)
    800052e0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800052e2:	ffffc097          	auipc	ra,0xffffc
    800052e6:	b4c080e7          	jalr	-1204(ra) # 80000e2e <myproc>
    800052ea:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800052ec:	fd840593          	addi	a1,s0,-40
    800052f0:	4501                	li	a0,0
    800052f2:	ffffd097          	auipc	ra,0xffffd
    800052f6:	e78080e7          	jalr	-392(ra) # 8000216a <argaddr>
    return -1;
    800052fa:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800052fc:	0e054063          	bltz	a0,800053dc <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005300:	fc840593          	addi	a1,s0,-56
    80005304:	fd040513          	addi	a0,s0,-48
    80005308:	fffff097          	auipc	ra,0xfffff
    8000530c:	dfc080e7          	jalr	-516(ra) # 80004104 <pipealloc>
    return -1;
    80005310:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005312:	0c054563          	bltz	a0,800053dc <sys_pipe+0x104>
  fd0 = -1;
    80005316:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000531a:	fd043503          	ld	a0,-48(s0)
    8000531e:	fffff097          	auipc	ra,0xfffff
    80005322:	508080e7          	jalr	1288(ra) # 80004826 <fdalloc>
    80005326:	fca42223          	sw	a0,-60(s0)
    8000532a:	08054c63          	bltz	a0,800053c2 <sys_pipe+0xea>
    8000532e:	fc843503          	ld	a0,-56(s0)
    80005332:	fffff097          	auipc	ra,0xfffff
    80005336:	4f4080e7          	jalr	1268(ra) # 80004826 <fdalloc>
    8000533a:	fca42023          	sw	a0,-64(s0)
    8000533e:	06054863          	bltz	a0,800053ae <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005342:	4691                	li	a3,4
    80005344:	fc440613          	addi	a2,s0,-60
    80005348:	fd843583          	ld	a1,-40(s0)
    8000534c:	68a8                	ld	a0,80(s1)
    8000534e:	ffffb097          	auipc	ra,0xffffb
    80005352:	7a2080e7          	jalr	1954(ra) # 80000af0 <copyout>
    80005356:	02054063          	bltz	a0,80005376 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000535a:	4691                	li	a3,4
    8000535c:	fc040613          	addi	a2,s0,-64
    80005360:	fd843583          	ld	a1,-40(s0)
    80005364:	0591                	addi	a1,a1,4
    80005366:	68a8                	ld	a0,80(s1)
    80005368:	ffffb097          	auipc	ra,0xffffb
    8000536c:	788080e7          	jalr	1928(ra) # 80000af0 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005370:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005372:	06055563          	bgez	a0,800053dc <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005376:	fc442783          	lw	a5,-60(s0)
    8000537a:	07e9                	addi	a5,a5,26
    8000537c:	078e                	slli	a5,a5,0x3
    8000537e:	97a6                	add	a5,a5,s1
    80005380:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005384:	fc042503          	lw	a0,-64(s0)
    80005388:	0569                	addi	a0,a0,26
    8000538a:	050e                	slli	a0,a0,0x3
    8000538c:	9526                	add	a0,a0,s1
    8000538e:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005392:	fd043503          	ld	a0,-48(s0)
    80005396:	fffff097          	auipc	ra,0xfffff
    8000539a:	a3e080e7          	jalr	-1474(ra) # 80003dd4 <fileclose>
    fileclose(wf);
    8000539e:	fc843503          	ld	a0,-56(s0)
    800053a2:	fffff097          	auipc	ra,0xfffff
    800053a6:	a32080e7          	jalr	-1486(ra) # 80003dd4 <fileclose>
    return -1;
    800053aa:	57fd                	li	a5,-1
    800053ac:	a805                	j	800053dc <sys_pipe+0x104>
    if(fd0 >= 0)
    800053ae:	fc442783          	lw	a5,-60(s0)
    800053b2:	0007c863          	bltz	a5,800053c2 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800053b6:	01a78513          	addi	a0,a5,26
    800053ba:	050e                	slli	a0,a0,0x3
    800053bc:	9526                	add	a0,a0,s1
    800053be:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800053c2:	fd043503          	ld	a0,-48(s0)
    800053c6:	fffff097          	auipc	ra,0xfffff
    800053ca:	a0e080e7          	jalr	-1522(ra) # 80003dd4 <fileclose>
    fileclose(wf);
    800053ce:	fc843503          	ld	a0,-56(s0)
    800053d2:	fffff097          	auipc	ra,0xfffff
    800053d6:	a02080e7          	jalr	-1534(ra) # 80003dd4 <fileclose>
    return -1;
    800053da:	57fd                	li	a5,-1
}
    800053dc:	853e                	mv	a0,a5
    800053de:	70e2                	ld	ra,56(sp)
    800053e0:	7442                	ld	s0,48(sp)
    800053e2:	74a2                	ld	s1,40(sp)
    800053e4:	6121                	addi	sp,sp,64
    800053e6:	8082                	ret
	...

00000000800053f0 <kernelvec>:
    800053f0:	7111                	addi	sp,sp,-256
    800053f2:	e006                	sd	ra,0(sp)
    800053f4:	e40a                	sd	sp,8(sp)
    800053f6:	e80e                	sd	gp,16(sp)
    800053f8:	ec12                	sd	tp,24(sp)
    800053fa:	f016                	sd	t0,32(sp)
    800053fc:	f41a                	sd	t1,40(sp)
    800053fe:	f81e                	sd	t2,48(sp)
    80005400:	fc22                	sd	s0,56(sp)
    80005402:	e0a6                	sd	s1,64(sp)
    80005404:	e4aa                	sd	a0,72(sp)
    80005406:	e8ae                	sd	a1,80(sp)
    80005408:	ecb2                	sd	a2,88(sp)
    8000540a:	f0b6                	sd	a3,96(sp)
    8000540c:	f4ba                	sd	a4,104(sp)
    8000540e:	f8be                	sd	a5,112(sp)
    80005410:	fcc2                	sd	a6,120(sp)
    80005412:	e146                	sd	a7,128(sp)
    80005414:	e54a                	sd	s2,136(sp)
    80005416:	e94e                	sd	s3,144(sp)
    80005418:	ed52                	sd	s4,152(sp)
    8000541a:	f156                	sd	s5,160(sp)
    8000541c:	f55a                	sd	s6,168(sp)
    8000541e:	f95e                	sd	s7,176(sp)
    80005420:	fd62                	sd	s8,184(sp)
    80005422:	e1e6                	sd	s9,192(sp)
    80005424:	e5ea                	sd	s10,200(sp)
    80005426:	e9ee                	sd	s11,208(sp)
    80005428:	edf2                	sd	t3,216(sp)
    8000542a:	f1f6                	sd	t4,224(sp)
    8000542c:	f5fa                	sd	t5,232(sp)
    8000542e:	f9fe                	sd	t6,240(sp)
    80005430:	b4bfc0ef          	jal	ra,80001f7a <kerneltrap>
    80005434:	6082                	ld	ra,0(sp)
    80005436:	6122                	ld	sp,8(sp)
    80005438:	61c2                	ld	gp,16(sp)
    8000543a:	7282                	ld	t0,32(sp)
    8000543c:	7322                	ld	t1,40(sp)
    8000543e:	73c2                	ld	t2,48(sp)
    80005440:	7462                	ld	s0,56(sp)
    80005442:	6486                	ld	s1,64(sp)
    80005444:	6526                	ld	a0,72(sp)
    80005446:	65c6                	ld	a1,80(sp)
    80005448:	6666                	ld	a2,88(sp)
    8000544a:	7686                	ld	a3,96(sp)
    8000544c:	7726                	ld	a4,104(sp)
    8000544e:	77c6                	ld	a5,112(sp)
    80005450:	7866                	ld	a6,120(sp)
    80005452:	688a                	ld	a7,128(sp)
    80005454:	692a                	ld	s2,136(sp)
    80005456:	69ca                	ld	s3,144(sp)
    80005458:	6a6a                	ld	s4,152(sp)
    8000545a:	7a8a                	ld	s5,160(sp)
    8000545c:	7b2a                	ld	s6,168(sp)
    8000545e:	7bca                	ld	s7,176(sp)
    80005460:	7c6a                	ld	s8,184(sp)
    80005462:	6c8e                	ld	s9,192(sp)
    80005464:	6d2e                	ld	s10,200(sp)
    80005466:	6dce                	ld	s11,208(sp)
    80005468:	6e6e                	ld	t3,216(sp)
    8000546a:	7e8e                	ld	t4,224(sp)
    8000546c:	7f2e                	ld	t5,232(sp)
    8000546e:	7fce                	ld	t6,240(sp)
    80005470:	6111                	addi	sp,sp,256
    80005472:	10200073          	sret
    80005476:	00000013          	nop
    8000547a:	00000013          	nop
    8000547e:	0001                	nop

0000000080005480 <timervec>:
    80005480:	34051573          	csrrw	a0,mscratch,a0
    80005484:	e10c                	sd	a1,0(a0)
    80005486:	e510                	sd	a2,8(a0)
    80005488:	e914                	sd	a3,16(a0)
    8000548a:	6d0c                	ld	a1,24(a0)
    8000548c:	7110                	ld	a2,32(a0)
    8000548e:	6194                	ld	a3,0(a1)
    80005490:	96b2                	add	a3,a3,a2
    80005492:	e194                	sd	a3,0(a1)
    80005494:	4589                	li	a1,2
    80005496:	14459073          	csrw	sip,a1
    8000549a:	6914                	ld	a3,16(a0)
    8000549c:	6510                	ld	a2,8(a0)
    8000549e:	610c                	ld	a1,0(a0)
    800054a0:	34051573          	csrrw	a0,mscratch,a0
    800054a4:	30200073          	mret
	...

00000000800054aa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800054aa:	1141                	addi	sp,sp,-16
    800054ac:	e422                	sd	s0,8(sp)
    800054ae:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800054b0:	0c0007b7          	lui	a5,0xc000
    800054b4:	4705                	li	a4,1
    800054b6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800054b8:	c3d8                	sw	a4,4(a5)
}
    800054ba:	6422                	ld	s0,8(sp)
    800054bc:	0141                	addi	sp,sp,16
    800054be:	8082                	ret

00000000800054c0 <plicinithart>:

void
plicinithart(void)
{
    800054c0:	1141                	addi	sp,sp,-16
    800054c2:	e406                	sd	ra,8(sp)
    800054c4:	e022                	sd	s0,0(sp)
    800054c6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054c8:	ffffc097          	auipc	ra,0xffffc
    800054cc:	93a080e7          	jalr	-1734(ra) # 80000e02 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800054d0:	0085171b          	slliw	a4,a0,0x8
    800054d4:	0c0027b7          	lui	a5,0xc002
    800054d8:	97ba                	add	a5,a5,a4
    800054da:	40200713          	li	a4,1026
    800054de:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800054e2:	00d5151b          	slliw	a0,a0,0xd
    800054e6:	0c2017b7          	lui	a5,0xc201
    800054ea:	953e                	add	a0,a0,a5
    800054ec:	00052023          	sw	zero,0(a0)
}
    800054f0:	60a2                	ld	ra,8(sp)
    800054f2:	6402                	ld	s0,0(sp)
    800054f4:	0141                	addi	sp,sp,16
    800054f6:	8082                	ret

00000000800054f8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800054f8:	1141                	addi	sp,sp,-16
    800054fa:	e406                	sd	ra,8(sp)
    800054fc:	e022                	sd	s0,0(sp)
    800054fe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005500:	ffffc097          	auipc	ra,0xffffc
    80005504:	902080e7          	jalr	-1790(ra) # 80000e02 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005508:	00d5179b          	slliw	a5,a0,0xd
    8000550c:	0c201537          	lui	a0,0xc201
    80005510:	953e                	add	a0,a0,a5
  return irq;
}
    80005512:	4148                	lw	a0,4(a0)
    80005514:	60a2                	ld	ra,8(sp)
    80005516:	6402                	ld	s0,0(sp)
    80005518:	0141                	addi	sp,sp,16
    8000551a:	8082                	ret

000000008000551c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000551c:	1101                	addi	sp,sp,-32
    8000551e:	ec06                	sd	ra,24(sp)
    80005520:	e822                	sd	s0,16(sp)
    80005522:	e426                	sd	s1,8(sp)
    80005524:	1000                	addi	s0,sp,32
    80005526:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005528:	ffffc097          	auipc	ra,0xffffc
    8000552c:	8da080e7          	jalr	-1830(ra) # 80000e02 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005530:	00d5151b          	slliw	a0,a0,0xd
    80005534:	0c2017b7          	lui	a5,0xc201
    80005538:	97aa                	add	a5,a5,a0
    8000553a:	c3c4                	sw	s1,4(a5)
}
    8000553c:	60e2                	ld	ra,24(sp)
    8000553e:	6442                	ld	s0,16(sp)
    80005540:	64a2                	ld	s1,8(sp)
    80005542:	6105                	addi	sp,sp,32
    80005544:	8082                	ret

0000000080005546 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005546:	1141                	addi	sp,sp,-16
    80005548:	e406                	sd	ra,8(sp)
    8000554a:	e022                	sd	s0,0(sp)
    8000554c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000554e:	479d                	li	a5,7
    80005550:	06a7c963          	blt	a5,a0,800055c2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005554:	00020797          	auipc	a5,0x20
    80005558:	aac78793          	addi	a5,a5,-1364 # 80025000 <disk>
    8000555c:	00a78733          	add	a4,a5,a0
    80005560:	6789                	lui	a5,0x2
    80005562:	97ba                	add	a5,a5,a4
    80005564:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005568:	e7ad                	bnez	a5,800055d2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000556a:	00451793          	slli	a5,a0,0x4
    8000556e:	00022717          	auipc	a4,0x22
    80005572:	a9270713          	addi	a4,a4,-1390 # 80027000 <disk+0x2000>
    80005576:	6314                	ld	a3,0(a4)
    80005578:	96be                	add	a3,a3,a5
    8000557a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000557e:	6314                	ld	a3,0(a4)
    80005580:	96be                	add	a3,a3,a5
    80005582:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005586:	6314                	ld	a3,0(a4)
    80005588:	96be                	add	a3,a3,a5
    8000558a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000558e:	6318                	ld	a4,0(a4)
    80005590:	97ba                	add	a5,a5,a4
    80005592:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005596:	00020797          	auipc	a5,0x20
    8000559a:	a6a78793          	addi	a5,a5,-1430 # 80025000 <disk>
    8000559e:	97aa                	add	a5,a5,a0
    800055a0:	6509                	lui	a0,0x2
    800055a2:	953e                	add	a0,a0,a5
    800055a4:	4785                	li	a5,1
    800055a6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800055aa:	00022517          	auipc	a0,0x22
    800055ae:	a6e50513          	addi	a0,a0,-1426 # 80027018 <disk+0x2018>
    800055b2:	ffffc097          	auipc	ra,0xffffc
    800055b6:	188080e7          	jalr	392(ra) # 8000173a <wakeup>
}
    800055ba:	60a2                	ld	ra,8(sp)
    800055bc:	6402                	ld	s0,0(sp)
    800055be:	0141                	addi	sp,sp,16
    800055c0:	8082                	ret
    panic("free_desc 1");
    800055c2:	00003517          	auipc	a0,0x3
    800055c6:	0fe50513          	addi	a0,a0,254 # 800086c0 <syscalls+0x330>
    800055ca:	00001097          	auipc	ra,0x1
    800055ce:	a1e080e7          	jalr	-1506(ra) # 80005fe8 <panic>
    panic("free_desc 2");
    800055d2:	00003517          	auipc	a0,0x3
    800055d6:	0fe50513          	addi	a0,a0,254 # 800086d0 <syscalls+0x340>
    800055da:	00001097          	auipc	ra,0x1
    800055de:	a0e080e7          	jalr	-1522(ra) # 80005fe8 <panic>

00000000800055e2 <virtio_disk_init>:
{
    800055e2:	1101                	addi	sp,sp,-32
    800055e4:	ec06                	sd	ra,24(sp)
    800055e6:	e822                	sd	s0,16(sp)
    800055e8:	e426                	sd	s1,8(sp)
    800055ea:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800055ec:	00003597          	auipc	a1,0x3
    800055f0:	0f458593          	addi	a1,a1,244 # 800086e0 <syscalls+0x350>
    800055f4:	00022517          	auipc	a0,0x22
    800055f8:	b3450513          	addi	a0,a0,-1228 # 80027128 <disk+0x2128>
    800055fc:	00001097          	auipc	ra,0x1
    80005600:	ea6080e7          	jalr	-346(ra) # 800064a2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005604:	100017b7          	lui	a5,0x10001
    80005608:	4398                	lw	a4,0(a5)
    8000560a:	2701                	sext.w	a4,a4
    8000560c:	747277b7          	lui	a5,0x74727
    80005610:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005614:	0ef71163          	bne	a4,a5,800056f6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005618:	100017b7          	lui	a5,0x10001
    8000561c:	43dc                	lw	a5,4(a5)
    8000561e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005620:	4705                	li	a4,1
    80005622:	0ce79a63          	bne	a5,a4,800056f6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005626:	100017b7          	lui	a5,0x10001
    8000562a:	479c                	lw	a5,8(a5)
    8000562c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000562e:	4709                	li	a4,2
    80005630:	0ce79363          	bne	a5,a4,800056f6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005634:	100017b7          	lui	a5,0x10001
    80005638:	47d8                	lw	a4,12(a5)
    8000563a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000563c:	554d47b7          	lui	a5,0x554d4
    80005640:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005644:	0af71963          	bne	a4,a5,800056f6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005648:	100017b7          	lui	a5,0x10001
    8000564c:	4705                	li	a4,1
    8000564e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005650:	470d                	li	a4,3
    80005652:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005654:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005656:	c7ffe737          	lui	a4,0xc7ffe
    8000565a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fce51f>
    8000565e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005660:	2701                	sext.w	a4,a4
    80005662:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005664:	472d                	li	a4,11
    80005666:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005668:	473d                	li	a4,15
    8000566a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000566c:	6705                	lui	a4,0x1
    8000566e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005670:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005674:	5bdc                	lw	a5,52(a5)
    80005676:	2781                	sext.w	a5,a5
  if(max == 0)
    80005678:	c7d9                	beqz	a5,80005706 <virtio_disk_init+0x124>
  if(max < NUM)
    8000567a:	471d                	li	a4,7
    8000567c:	08f77d63          	bgeu	a4,a5,80005716 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005680:	100014b7          	lui	s1,0x10001
    80005684:	47a1                	li	a5,8
    80005686:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005688:	6609                	lui	a2,0x2
    8000568a:	4581                	li	a1,0
    8000568c:	00020517          	auipc	a0,0x20
    80005690:	97450513          	addi	a0,a0,-1676 # 80025000 <disk>
    80005694:	ffffb097          	auipc	ra,0xffffb
    80005698:	ae4080e7          	jalr	-1308(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000569c:	00020717          	auipc	a4,0x20
    800056a0:	96470713          	addi	a4,a4,-1692 # 80025000 <disk>
    800056a4:	00c75793          	srli	a5,a4,0xc
    800056a8:	2781                	sext.w	a5,a5
    800056aa:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800056ac:	00022797          	auipc	a5,0x22
    800056b0:	95478793          	addi	a5,a5,-1708 # 80027000 <disk+0x2000>
    800056b4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800056b6:	00020717          	auipc	a4,0x20
    800056ba:	9ca70713          	addi	a4,a4,-1590 # 80025080 <disk+0x80>
    800056be:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800056c0:	00021717          	auipc	a4,0x21
    800056c4:	94070713          	addi	a4,a4,-1728 # 80026000 <disk+0x1000>
    800056c8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800056ca:	4705                	li	a4,1
    800056cc:	00e78c23          	sb	a4,24(a5)
    800056d0:	00e78ca3          	sb	a4,25(a5)
    800056d4:	00e78d23          	sb	a4,26(a5)
    800056d8:	00e78da3          	sb	a4,27(a5)
    800056dc:	00e78e23          	sb	a4,28(a5)
    800056e0:	00e78ea3          	sb	a4,29(a5)
    800056e4:	00e78f23          	sb	a4,30(a5)
    800056e8:	00e78fa3          	sb	a4,31(a5)
}
    800056ec:	60e2                	ld	ra,24(sp)
    800056ee:	6442                	ld	s0,16(sp)
    800056f0:	64a2                	ld	s1,8(sp)
    800056f2:	6105                	addi	sp,sp,32
    800056f4:	8082                	ret
    panic("could not find virtio disk");
    800056f6:	00003517          	auipc	a0,0x3
    800056fa:	ffa50513          	addi	a0,a0,-6 # 800086f0 <syscalls+0x360>
    800056fe:	00001097          	auipc	ra,0x1
    80005702:	8ea080e7          	jalr	-1814(ra) # 80005fe8 <panic>
    panic("virtio disk has no queue 0");
    80005706:	00003517          	auipc	a0,0x3
    8000570a:	00a50513          	addi	a0,a0,10 # 80008710 <syscalls+0x380>
    8000570e:	00001097          	auipc	ra,0x1
    80005712:	8da080e7          	jalr	-1830(ra) # 80005fe8 <panic>
    panic("virtio disk max queue too short");
    80005716:	00003517          	auipc	a0,0x3
    8000571a:	01a50513          	addi	a0,a0,26 # 80008730 <syscalls+0x3a0>
    8000571e:	00001097          	auipc	ra,0x1
    80005722:	8ca080e7          	jalr	-1846(ra) # 80005fe8 <panic>

0000000080005726 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005726:	7159                	addi	sp,sp,-112
    80005728:	f486                	sd	ra,104(sp)
    8000572a:	f0a2                	sd	s0,96(sp)
    8000572c:	eca6                	sd	s1,88(sp)
    8000572e:	e8ca                	sd	s2,80(sp)
    80005730:	e4ce                	sd	s3,72(sp)
    80005732:	e0d2                	sd	s4,64(sp)
    80005734:	fc56                	sd	s5,56(sp)
    80005736:	f85a                	sd	s6,48(sp)
    80005738:	f45e                	sd	s7,40(sp)
    8000573a:	f062                	sd	s8,32(sp)
    8000573c:	ec66                	sd	s9,24(sp)
    8000573e:	e86a                	sd	s10,16(sp)
    80005740:	1880                	addi	s0,sp,112
    80005742:	892a                	mv	s2,a0
    80005744:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005746:	00c52c83          	lw	s9,12(a0)
    8000574a:	001c9c9b          	slliw	s9,s9,0x1
    8000574e:	1c82                	slli	s9,s9,0x20
    80005750:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005754:	00022517          	auipc	a0,0x22
    80005758:	9d450513          	addi	a0,a0,-1580 # 80027128 <disk+0x2128>
    8000575c:	00001097          	auipc	ra,0x1
    80005760:	dd6080e7          	jalr	-554(ra) # 80006532 <acquire>
  for(int i = 0; i < 3; i++){
    80005764:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005766:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005768:	00020b97          	auipc	s7,0x20
    8000576c:	898b8b93          	addi	s7,s7,-1896 # 80025000 <disk>
    80005770:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005772:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005774:	8a4e                	mv	s4,s3
    80005776:	a051                	j	800057fa <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005778:	00fb86b3          	add	a3,s7,a5
    8000577c:	96da                	add	a3,a3,s6
    8000577e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005782:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005784:	0207c563          	bltz	a5,800057ae <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005788:	2485                	addiw	s1,s1,1
    8000578a:	0711                	addi	a4,a4,4
    8000578c:	25548063          	beq	s1,s5,800059cc <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005790:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005792:	00022697          	auipc	a3,0x22
    80005796:	88668693          	addi	a3,a3,-1914 # 80027018 <disk+0x2018>
    8000579a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000579c:	0006c583          	lbu	a1,0(a3)
    800057a0:	fde1                	bnez	a1,80005778 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800057a2:	2785                	addiw	a5,a5,1
    800057a4:	0685                	addi	a3,a3,1
    800057a6:	ff879be3          	bne	a5,s8,8000579c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800057aa:	57fd                	li	a5,-1
    800057ac:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800057ae:	02905a63          	blez	s1,800057e2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800057b2:	f9042503          	lw	a0,-112(s0)
    800057b6:	00000097          	auipc	ra,0x0
    800057ba:	d90080e7          	jalr	-624(ra) # 80005546 <free_desc>
      for(int j = 0; j < i; j++)
    800057be:	4785                	li	a5,1
    800057c0:	0297d163          	bge	a5,s1,800057e2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800057c4:	f9442503          	lw	a0,-108(s0)
    800057c8:	00000097          	auipc	ra,0x0
    800057cc:	d7e080e7          	jalr	-642(ra) # 80005546 <free_desc>
      for(int j = 0; j < i; j++)
    800057d0:	4789                	li	a5,2
    800057d2:	0097d863          	bge	a5,s1,800057e2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800057d6:	f9842503          	lw	a0,-104(s0)
    800057da:	00000097          	auipc	ra,0x0
    800057de:	d6c080e7          	jalr	-660(ra) # 80005546 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800057e2:	00022597          	auipc	a1,0x22
    800057e6:	94658593          	addi	a1,a1,-1722 # 80027128 <disk+0x2128>
    800057ea:	00022517          	auipc	a0,0x22
    800057ee:	82e50513          	addi	a0,a0,-2002 # 80027018 <disk+0x2018>
    800057f2:	ffffc097          	auipc	ra,0xffffc
    800057f6:	dbc080e7          	jalr	-580(ra) # 800015ae <sleep>
  for(int i = 0; i < 3; i++){
    800057fa:	f9040713          	addi	a4,s0,-112
    800057fe:	84ce                	mv	s1,s3
    80005800:	bf41                	j	80005790 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005802:	20058713          	addi	a4,a1,512
    80005806:	00471693          	slli	a3,a4,0x4
    8000580a:	0001f717          	auipc	a4,0x1f
    8000580e:	7f670713          	addi	a4,a4,2038 # 80025000 <disk>
    80005812:	9736                	add	a4,a4,a3
    80005814:	4685                	li	a3,1
    80005816:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000581a:	20058713          	addi	a4,a1,512
    8000581e:	00471693          	slli	a3,a4,0x4
    80005822:	0001f717          	auipc	a4,0x1f
    80005826:	7de70713          	addi	a4,a4,2014 # 80025000 <disk>
    8000582a:	9736                	add	a4,a4,a3
    8000582c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005830:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005834:	7679                	lui	a2,0xffffe
    80005836:	963e                	add	a2,a2,a5
    80005838:	00021697          	auipc	a3,0x21
    8000583c:	7c868693          	addi	a3,a3,1992 # 80027000 <disk+0x2000>
    80005840:	6298                	ld	a4,0(a3)
    80005842:	9732                	add	a4,a4,a2
    80005844:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005846:	6298                	ld	a4,0(a3)
    80005848:	9732                	add	a4,a4,a2
    8000584a:	4541                	li	a0,16
    8000584c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000584e:	6298                	ld	a4,0(a3)
    80005850:	9732                	add	a4,a4,a2
    80005852:	4505                	li	a0,1
    80005854:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005858:	f9442703          	lw	a4,-108(s0)
    8000585c:	6288                	ld	a0,0(a3)
    8000585e:	962a                	add	a2,a2,a0
    80005860:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffcddce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005864:	0712                	slli	a4,a4,0x4
    80005866:	6290                	ld	a2,0(a3)
    80005868:	963a                	add	a2,a2,a4
    8000586a:	05890513          	addi	a0,s2,88
    8000586e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005870:	6294                	ld	a3,0(a3)
    80005872:	96ba                	add	a3,a3,a4
    80005874:	40000613          	li	a2,1024
    80005878:	c690                	sw	a2,8(a3)
  if(write)
    8000587a:	140d0063          	beqz	s10,800059ba <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000587e:	00021697          	auipc	a3,0x21
    80005882:	7826b683          	ld	a3,1922(a3) # 80027000 <disk+0x2000>
    80005886:	96ba                	add	a3,a3,a4
    80005888:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000588c:	0001f817          	auipc	a6,0x1f
    80005890:	77480813          	addi	a6,a6,1908 # 80025000 <disk>
    80005894:	00021517          	auipc	a0,0x21
    80005898:	76c50513          	addi	a0,a0,1900 # 80027000 <disk+0x2000>
    8000589c:	6114                	ld	a3,0(a0)
    8000589e:	96ba                	add	a3,a3,a4
    800058a0:	00c6d603          	lhu	a2,12(a3)
    800058a4:	00166613          	ori	a2,a2,1
    800058a8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800058ac:	f9842683          	lw	a3,-104(s0)
    800058b0:	6110                	ld	a2,0(a0)
    800058b2:	9732                	add	a4,a4,a2
    800058b4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800058b8:	20058613          	addi	a2,a1,512
    800058bc:	0612                	slli	a2,a2,0x4
    800058be:	9642                	add	a2,a2,a6
    800058c0:	577d                	li	a4,-1
    800058c2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800058c6:	00469713          	slli	a4,a3,0x4
    800058ca:	6114                	ld	a3,0(a0)
    800058cc:	96ba                	add	a3,a3,a4
    800058ce:	03078793          	addi	a5,a5,48
    800058d2:	97c2                	add	a5,a5,a6
    800058d4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    800058d6:	611c                	ld	a5,0(a0)
    800058d8:	97ba                	add	a5,a5,a4
    800058da:	4685                	li	a3,1
    800058dc:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800058de:	611c                	ld	a5,0(a0)
    800058e0:	97ba                	add	a5,a5,a4
    800058e2:	4809                	li	a6,2
    800058e4:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800058e8:	611c                	ld	a5,0(a0)
    800058ea:	973e                	add	a4,a4,a5
    800058ec:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800058f0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800058f4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800058f8:	6518                	ld	a4,8(a0)
    800058fa:	00275783          	lhu	a5,2(a4)
    800058fe:	8b9d                	andi	a5,a5,7
    80005900:	0786                	slli	a5,a5,0x1
    80005902:	97ba                	add	a5,a5,a4
    80005904:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005908:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000590c:	6518                	ld	a4,8(a0)
    8000590e:	00275783          	lhu	a5,2(a4)
    80005912:	2785                	addiw	a5,a5,1
    80005914:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005918:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000591c:	100017b7          	lui	a5,0x10001
    80005920:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005924:	00492703          	lw	a4,4(s2)
    80005928:	4785                	li	a5,1
    8000592a:	02f71163          	bne	a4,a5,8000594c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000592e:	00021997          	auipc	s3,0x21
    80005932:	7fa98993          	addi	s3,s3,2042 # 80027128 <disk+0x2128>
  while(b->disk == 1) {
    80005936:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005938:	85ce                	mv	a1,s3
    8000593a:	854a                	mv	a0,s2
    8000593c:	ffffc097          	auipc	ra,0xffffc
    80005940:	c72080e7          	jalr	-910(ra) # 800015ae <sleep>
  while(b->disk == 1) {
    80005944:	00492783          	lw	a5,4(s2)
    80005948:	fe9788e3          	beq	a5,s1,80005938 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000594c:	f9042903          	lw	s2,-112(s0)
    80005950:	20090793          	addi	a5,s2,512
    80005954:	00479713          	slli	a4,a5,0x4
    80005958:	0001f797          	auipc	a5,0x1f
    8000595c:	6a878793          	addi	a5,a5,1704 # 80025000 <disk>
    80005960:	97ba                	add	a5,a5,a4
    80005962:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005966:	00021997          	auipc	s3,0x21
    8000596a:	69a98993          	addi	s3,s3,1690 # 80027000 <disk+0x2000>
    8000596e:	00491713          	slli	a4,s2,0x4
    80005972:	0009b783          	ld	a5,0(s3)
    80005976:	97ba                	add	a5,a5,a4
    80005978:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000597c:	854a                	mv	a0,s2
    8000597e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005982:	00000097          	auipc	ra,0x0
    80005986:	bc4080e7          	jalr	-1084(ra) # 80005546 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000598a:	8885                	andi	s1,s1,1
    8000598c:	f0ed                	bnez	s1,8000596e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000598e:	00021517          	auipc	a0,0x21
    80005992:	79a50513          	addi	a0,a0,1946 # 80027128 <disk+0x2128>
    80005996:	00001097          	auipc	ra,0x1
    8000599a:	c50080e7          	jalr	-944(ra) # 800065e6 <release>
}
    8000599e:	70a6                	ld	ra,104(sp)
    800059a0:	7406                	ld	s0,96(sp)
    800059a2:	64e6                	ld	s1,88(sp)
    800059a4:	6946                	ld	s2,80(sp)
    800059a6:	69a6                	ld	s3,72(sp)
    800059a8:	6a06                	ld	s4,64(sp)
    800059aa:	7ae2                	ld	s5,56(sp)
    800059ac:	7b42                	ld	s6,48(sp)
    800059ae:	7ba2                	ld	s7,40(sp)
    800059b0:	7c02                	ld	s8,32(sp)
    800059b2:	6ce2                	ld	s9,24(sp)
    800059b4:	6d42                	ld	s10,16(sp)
    800059b6:	6165                	addi	sp,sp,112
    800059b8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800059ba:	00021697          	auipc	a3,0x21
    800059be:	6466b683          	ld	a3,1606(a3) # 80027000 <disk+0x2000>
    800059c2:	96ba                	add	a3,a3,a4
    800059c4:	4609                	li	a2,2
    800059c6:	00c69623          	sh	a2,12(a3)
    800059ca:	b5c9                	j	8000588c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800059cc:	f9042583          	lw	a1,-112(s0)
    800059d0:	20058793          	addi	a5,a1,512
    800059d4:	0792                	slli	a5,a5,0x4
    800059d6:	0001f517          	auipc	a0,0x1f
    800059da:	6d250513          	addi	a0,a0,1746 # 800250a8 <disk+0xa8>
    800059de:	953e                	add	a0,a0,a5
  if(write)
    800059e0:	e20d11e3          	bnez	s10,80005802 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800059e4:	20058713          	addi	a4,a1,512
    800059e8:	00471693          	slli	a3,a4,0x4
    800059ec:	0001f717          	auipc	a4,0x1f
    800059f0:	61470713          	addi	a4,a4,1556 # 80025000 <disk>
    800059f4:	9736                	add	a4,a4,a3
    800059f6:	0a072423          	sw	zero,168(a4)
    800059fa:	b505                	j	8000581a <virtio_disk_rw+0xf4>

00000000800059fc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800059fc:	1101                	addi	sp,sp,-32
    800059fe:	ec06                	sd	ra,24(sp)
    80005a00:	e822                	sd	s0,16(sp)
    80005a02:	e426                	sd	s1,8(sp)
    80005a04:	e04a                	sd	s2,0(sp)
    80005a06:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005a08:	00021517          	auipc	a0,0x21
    80005a0c:	72050513          	addi	a0,a0,1824 # 80027128 <disk+0x2128>
    80005a10:	00001097          	auipc	ra,0x1
    80005a14:	b22080e7          	jalr	-1246(ra) # 80006532 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005a18:	10001737          	lui	a4,0x10001
    80005a1c:	533c                	lw	a5,96(a4)
    80005a1e:	8b8d                	andi	a5,a5,3
    80005a20:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005a22:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005a26:	00021797          	auipc	a5,0x21
    80005a2a:	5da78793          	addi	a5,a5,1498 # 80027000 <disk+0x2000>
    80005a2e:	6b94                	ld	a3,16(a5)
    80005a30:	0207d703          	lhu	a4,32(a5)
    80005a34:	0026d783          	lhu	a5,2(a3)
    80005a38:	06f70163          	beq	a4,a5,80005a9a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a3c:	0001f917          	auipc	s2,0x1f
    80005a40:	5c490913          	addi	s2,s2,1476 # 80025000 <disk>
    80005a44:	00021497          	auipc	s1,0x21
    80005a48:	5bc48493          	addi	s1,s1,1468 # 80027000 <disk+0x2000>
    __sync_synchronize();
    80005a4c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a50:	6898                	ld	a4,16(s1)
    80005a52:	0204d783          	lhu	a5,32(s1)
    80005a56:	8b9d                	andi	a5,a5,7
    80005a58:	078e                	slli	a5,a5,0x3
    80005a5a:	97ba                	add	a5,a5,a4
    80005a5c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a5e:	20078713          	addi	a4,a5,512
    80005a62:	0712                	slli	a4,a4,0x4
    80005a64:	974a                	add	a4,a4,s2
    80005a66:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005a6a:	e731                	bnez	a4,80005ab6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a6c:	20078793          	addi	a5,a5,512
    80005a70:	0792                	slli	a5,a5,0x4
    80005a72:	97ca                	add	a5,a5,s2
    80005a74:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005a76:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a7a:	ffffc097          	auipc	ra,0xffffc
    80005a7e:	cc0080e7          	jalr	-832(ra) # 8000173a <wakeup>

    disk.used_idx += 1;
    80005a82:	0204d783          	lhu	a5,32(s1)
    80005a86:	2785                	addiw	a5,a5,1
    80005a88:	17c2                	slli	a5,a5,0x30
    80005a8a:	93c1                	srli	a5,a5,0x30
    80005a8c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a90:	6898                	ld	a4,16(s1)
    80005a92:	00275703          	lhu	a4,2(a4)
    80005a96:	faf71be3          	bne	a4,a5,80005a4c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005a9a:	00021517          	auipc	a0,0x21
    80005a9e:	68e50513          	addi	a0,a0,1678 # 80027128 <disk+0x2128>
    80005aa2:	00001097          	auipc	ra,0x1
    80005aa6:	b44080e7          	jalr	-1212(ra) # 800065e6 <release>
}
    80005aaa:	60e2                	ld	ra,24(sp)
    80005aac:	6442                	ld	s0,16(sp)
    80005aae:	64a2                	ld	s1,8(sp)
    80005ab0:	6902                	ld	s2,0(sp)
    80005ab2:	6105                	addi	sp,sp,32
    80005ab4:	8082                	ret
      panic("virtio_disk_intr status");
    80005ab6:	00003517          	auipc	a0,0x3
    80005aba:	c9a50513          	addi	a0,a0,-870 # 80008750 <syscalls+0x3c0>
    80005abe:	00000097          	auipc	ra,0x0
    80005ac2:	52a080e7          	jalr	1322(ra) # 80005fe8 <panic>

0000000080005ac6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005ac6:	1141                	addi	sp,sp,-16
    80005ac8:	e422                	sd	s0,8(sp)
    80005aca:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005acc:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005ad0:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005ad4:	0037979b          	slliw	a5,a5,0x3
    80005ad8:	02004737          	lui	a4,0x2004
    80005adc:	97ba                	add	a5,a5,a4
    80005ade:	0200c737          	lui	a4,0x200c
    80005ae2:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005ae6:	000f4637          	lui	a2,0xf4
    80005aea:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005aee:	95b2                	add	a1,a1,a2
    80005af0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005af2:	00269713          	slli	a4,a3,0x2
    80005af6:	9736                	add	a4,a4,a3
    80005af8:	00371693          	slli	a3,a4,0x3
    80005afc:	00022717          	auipc	a4,0x22
    80005b00:	50470713          	addi	a4,a4,1284 # 80028000 <timer_scratch>
    80005b04:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005b06:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005b08:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005b0a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005b0e:	00000797          	auipc	a5,0x0
    80005b12:	97278793          	addi	a5,a5,-1678 # 80005480 <timervec>
    80005b16:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b1a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005b1e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b22:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005b26:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005b2a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005b2e:	30479073          	csrw	mie,a5
}
    80005b32:	6422                	ld	s0,8(sp)
    80005b34:	0141                	addi	sp,sp,16
    80005b36:	8082                	ret

0000000080005b38 <start>:
{
    80005b38:	1141                	addi	sp,sp,-16
    80005b3a:	e406                	sd	ra,8(sp)
    80005b3c:	e022                	sd	s0,0(sp)
    80005b3e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b40:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005b44:	7779                	lui	a4,0xffffe
    80005b46:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffce5bf>
    80005b4a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005b4c:	6705                	lui	a4,0x1
    80005b4e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005b52:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b54:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005b58:	ffffa797          	auipc	a5,0xffffa
    80005b5c:	7ce78793          	addi	a5,a5,1998 # 80000326 <main>
    80005b60:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005b64:	4781                	li	a5,0
    80005b66:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005b6a:	67c1                	lui	a5,0x10
    80005b6c:	17fd                	addi	a5,a5,-1
    80005b6e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005b72:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005b76:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005b7a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005b7e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005b82:	57fd                	li	a5,-1
    80005b84:	83a9                	srli	a5,a5,0xa
    80005b86:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005b8a:	47bd                	li	a5,15
    80005b8c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005b90:	00000097          	auipc	ra,0x0
    80005b94:	f36080e7          	jalr	-202(ra) # 80005ac6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b98:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005b9c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005b9e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005ba0:	30200073          	mret
}
    80005ba4:	60a2                	ld	ra,8(sp)
    80005ba6:	6402                	ld	s0,0(sp)
    80005ba8:	0141                	addi	sp,sp,16
    80005baa:	8082                	ret

0000000080005bac <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005bac:	715d                	addi	sp,sp,-80
    80005bae:	e486                	sd	ra,72(sp)
    80005bb0:	e0a2                	sd	s0,64(sp)
    80005bb2:	fc26                	sd	s1,56(sp)
    80005bb4:	f84a                	sd	s2,48(sp)
    80005bb6:	f44e                	sd	s3,40(sp)
    80005bb8:	f052                	sd	s4,32(sp)
    80005bba:	ec56                	sd	s5,24(sp)
    80005bbc:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005bbe:	04c05663          	blez	a2,80005c0a <consolewrite+0x5e>
    80005bc2:	8a2a                	mv	s4,a0
    80005bc4:	84ae                	mv	s1,a1
    80005bc6:	89b2                	mv	s3,a2
    80005bc8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005bca:	5afd                	li	s5,-1
    80005bcc:	4685                	li	a3,1
    80005bce:	8626                	mv	a2,s1
    80005bd0:	85d2                	mv	a1,s4
    80005bd2:	fbf40513          	addi	a0,s0,-65
    80005bd6:	ffffc097          	auipc	ra,0xffffc
    80005bda:	e68080e7          	jalr	-408(ra) # 80001a3e <either_copyin>
    80005bde:	01550c63          	beq	a0,s5,80005bf6 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005be2:	fbf44503          	lbu	a0,-65(s0)
    80005be6:	00000097          	auipc	ra,0x0
    80005bea:	78e080e7          	jalr	1934(ra) # 80006374 <uartputc>
  for(i = 0; i < n; i++){
    80005bee:	2905                	addiw	s2,s2,1
    80005bf0:	0485                	addi	s1,s1,1
    80005bf2:	fd299de3          	bne	s3,s2,80005bcc <consolewrite+0x20>
  }

  return i;
}
    80005bf6:	854a                	mv	a0,s2
    80005bf8:	60a6                	ld	ra,72(sp)
    80005bfa:	6406                	ld	s0,64(sp)
    80005bfc:	74e2                	ld	s1,56(sp)
    80005bfe:	7942                	ld	s2,48(sp)
    80005c00:	79a2                	ld	s3,40(sp)
    80005c02:	7a02                	ld	s4,32(sp)
    80005c04:	6ae2                	ld	s5,24(sp)
    80005c06:	6161                	addi	sp,sp,80
    80005c08:	8082                	ret
  for(i = 0; i < n; i++){
    80005c0a:	4901                	li	s2,0
    80005c0c:	b7ed                	j	80005bf6 <consolewrite+0x4a>

0000000080005c0e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005c0e:	7119                	addi	sp,sp,-128
    80005c10:	fc86                	sd	ra,120(sp)
    80005c12:	f8a2                	sd	s0,112(sp)
    80005c14:	f4a6                	sd	s1,104(sp)
    80005c16:	f0ca                	sd	s2,96(sp)
    80005c18:	ecce                	sd	s3,88(sp)
    80005c1a:	e8d2                	sd	s4,80(sp)
    80005c1c:	e4d6                	sd	s5,72(sp)
    80005c1e:	e0da                	sd	s6,64(sp)
    80005c20:	fc5e                	sd	s7,56(sp)
    80005c22:	f862                	sd	s8,48(sp)
    80005c24:	f466                	sd	s9,40(sp)
    80005c26:	f06a                	sd	s10,32(sp)
    80005c28:	ec6e                	sd	s11,24(sp)
    80005c2a:	0100                	addi	s0,sp,128
    80005c2c:	8b2a                	mv	s6,a0
    80005c2e:	8aae                	mv	s5,a1
    80005c30:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005c32:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005c36:	0002a517          	auipc	a0,0x2a
    80005c3a:	50a50513          	addi	a0,a0,1290 # 80030140 <cons>
    80005c3e:	00001097          	auipc	ra,0x1
    80005c42:	8f4080e7          	jalr	-1804(ra) # 80006532 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005c46:	0002a497          	auipc	s1,0x2a
    80005c4a:	4fa48493          	addi	s1,s1,1274 # 80030140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005c4e:	89a6                	mv	s3,s1
    80005c50:	0002a917          	auipc	s2,0x2a
    80005c54:	58890913          	addi	s2,s2,1416 # 800301d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005c58:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c5a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005c5c:	4da9                	li	s11,10
  while(n > 0){
    80005c5e:	07405863          	blez	s4,80005cce <consoleread+0xc0>
    while(cons.r == cons.w){
    80005c62:	0984a783          	lw	a5,152(s1)
    80005c66:	09c4a703          	lw	a4,156(s1)
    80005c6a:	02f71463          	bne	a4,a5,80005c92 <consoleread+0x84>
      if(myproc()->killed){
    80005c6e:	ffffb097          	auipc	ra,0xffffb
    80005c72:	1c0080e7          	jalr	448(ra) # 80000e2e <myproc>
    80005c76:	551c                	lw	a5,40(a0)
    80005c78:	e7b5                	bnez	a5,80005ce4 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005c7a:	85ce                	mv	a1,s3
    80005c7c:	854a                	mv	a0,s2
    80005c7e:	ffffc097          	auipc	ra,0xffffc
    80005c82:	930080e7          	jalr	-1744(ra) # 800015ae <sleep>
    while(cons.r == cons.w){
    80005c86:	0984a783          	lw	a5,152(s1)
    80005c8a:	09c4a703          	lw	a4,156(s1)
    80005c8e:	fef700e3          	beq	a4,a5,80005c6e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005c92:	0017871b          	addiw	a4,a5,1
    80005c96:	08e4ac23          	sw	a4,152(s1)
    80005c9a:	07f7f713          	andi	a4,a5,127
    80005c9e:	9726                	add	a4,a4,s1
    80005ca0:	01874703          	lbu	a4,24(a4)
    80005ca4:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005ca8:	079c0663          	beq	s8,s9,80005d14 <consoleread+0x106>
    cbuf = c;
    80005cac:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005cb0:	4685                	li	a3,1
    80005cb2:	f8f40613          	addi	a2,s0,-113
    80005cb6:	85d6                	mv	a1,s5
    80005cb8:	855a                	mv	a0,s6
    80005cba:	ffffc097          	auipc	ra,0xffffc
    80005cbe:	d2e080e7          	jalr	-722(ra) # 800019e8 <either_copyout>
    80005cc2:	01a50663          	beq	a0,s10,80005cce <consoleread+0xc0>
    dst++;
    80005cc6:	0a85                	addi	s5,s5,1
    --n;
    80005cc8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005cca:	f9bc1ae3          	bne	s8,s11,80005c5e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005cce:	0002a517          	auipc	a0,0x2a
    80005cd2:	47250513          	addi	a0,a0,1138 # 80030140 <cons>
    80005cd6:	00001097          	auipc	ra,0x1
    80005cda:	910080e7          	jalr	-1776(ra) # 800065e6 <release>

  return target - n;
    80005cde:	414b853b          	subw	a0,s7,s4
    80005ce2:	a811                	j	80005cf6 <consoleread+0xe8>
        release(&cons.lock);
    80005ce4:	0002a517          	auipc	a0,0x2a
    80005ce8:	45c50513          	addi	a0,a0,1116 # 80030140 <cons>
    80005cec:	00001097          	auipc	ra,0x1
    80005cf0:	8fa080e7          	jalr	-1798(ra) # 800065e6 <release>
        return -1;
    80005cf4:	557d                	li	a0,-1
}
    80005cf6:	70e6                	ld	ra,120(sp)
    80005cf8:	7446                	ld	s0,112(sp)
    80005cfa:	74a6                	ld	s1,104(sp)
    80005cfc:	7906                	ld	s2,96(sp)
    80005cfe:	69e6                	ld	s3,88(sp)
    80005d00:	6a46                	ld	s4,80(sp)
    80005d02:	6aa6                	ld	s5,72(sp)
    80005d04:	6b06                	ld	s6,64(sp)
    80005d06:	7be2                	ld	s7,56(sp)
    80005d08:	7c42                	ld	s8,48(sp)
    80005d0a:	7ca2                	ld	s9,40(sp)
    80005d0c:	7d02                	ld	s10,32(sp)
    80005d0e:	6de2                	ld	s11,24(sp)
    80005d10:	6109                	addi	sp,sp,128
    80005d12:	8082                	ret
      if(n < target){
    80005d14:	000a071b          	sext.w	a4,s4
    80005d18:	fb777be3          	bgeu	a4,s7,80005cce <consoleread+0xc0>
        cons.r--;
    80005d1c:	0002a717          	auipc	a4,0x2a
    80005d20:	4af72e23          	sw	a5,1212(a4) # 800301d8 <cons+0x98>
    80005d24:	b76d                	j	80005cce <consoleread+0xc0>

0000000080005d26 <consputc>:
{
    80005d26:	1141                	addi	sp,sp,-16
    80005d28:	e406                	sd	ra,8(sp)
    80005d2a:	e022                	sd	s0,0(sp)
    80005d2c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005d2e:	10000793          	li	a5,256
    80005d32:	00f50a63          	beq	a0,a5,80005d46 <consputc+0x20>
    uartputc_sync(c);
    80005d36:	00000097          	auipc	ra,0x0
    80005d3a:	564080e7          	jalr	1380(ra) # 8000629a <uartputc_sync>
}
    80005d3e:	60a2                	ld	ra,8(sp)
    80005d40:	6402                	ld	s0,0(sp)
    80005d42:	0141                	addi	sp,sp,16
    80005d44:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005d46:	4521                	li	a0,8
    80005d48:	00000097          	auipc	ra,0x0
    80005d4c:	552080e7          	jalr	1362(ra) # 8000629a <uartputc_sync>
    80005d50:	02000513          	li	a0,32
    80005d54:	00000097          	auipc	ra,0x0
    80005d58:	546080e7          	jalr	1350(ra) # 8000629a <uartputc_sync>
    80005d5c:	4521                	li	a0,8
    80005d5e:	00000097          	auipc	ra,0x0
    80005d62:	53c080e7          	jalr	1340(ra) # 8000629a <uartputc_sync>
    80005d66:	bfe1                	j	80005d3e <consputc+0x18>

0000000080005d68 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005d68:	1101                	addi	sp,sp,-32
    80005d6a:	ec06                	sd	ra,24(sp)
    80005d6c:	e822                	sd	s0,16(sp)
    80005d6e:	e426                	sd	s1,8(sp)
    80005d70:	e04a                	sd	s2,0(sp)
    80005d72:	1000                	addi	s0,sp,32
    80005d74:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005d76:	0002a517          	auipc	a0,0x2a
    80005d7a:	3ca50513          	addi	a0,a0,970 # 80030140 <cons>
    80005d7e:	00000097          	auipc	ra,0x0
    80005d82:	7b4080e7          	jalr	1972(ra) # 80006532 <acquire>

  switch(c){
    80005d86:	47d5                	li	a5,21
    80005d88:	0af48663          	beq	s1,a5,80005e34 <consoleintr+0xcc>
    80005d8c:	0297ca63          	blt	a5,s1,80005dc0 <consoleintr+0x58>
    80005d90:	47a1                	li	a5,8
    80005d92:	0ef48763          	beq	s1,a5,80005e80 <consoleintr+0x118>
    80005d96:	47c1                	li	a5,16
    80005d98:	10f49a63          	bne	s1,a5,80005eac <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005d9c:	ffffc097          	auipc	ra,0xffffc
    80005da0:	cf8080e7          	jalr	-776(ra) # 80001a94 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005da4:	0002a517          	auipc	a0,0x2a
    80005da8:	39c50513          	addi	a0,a0,924 # 80030140 <cons>
    80005dac:	00001097          	auipc	ra,0x1
    80005db0:	83a080e7          	jalr	-1990(ra) # 800065e6 <release>
}
    80005db4:	60e2                	ld	ra,24(sp)
    80005db6:	6442                	ld	s0,16(sp)
    80005db8:	64a2                	ld	s1,8(sp)
    80005dba:	6902                	ld	s2,0(sp)
    80005dbc:	6105                	addi	sp,sp,32
    80005dbe:	8082                	ret
  switch(c){
    80005dc0:	07f00793          	li	a5,127
    80005dc4:	0af48e63          	beq	s1,a5,80005e80 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005dc8:	0002a717          	auipc	a4,0x2a
    80005dcc:	37870713          	addi	a4,a4,888 # 80030140 <cons>
    80005dd0:	0a072783          	lw	a5,160(a4)
    80005dd4:	09872703          	lw	a4,152(a4)
    80005dd8:	9f99                	subw	a5,a5,a4
    80005dda:	07f00713          	li	a4,127
    80005dde:	fcf763e3          	bltu	a4,a5,80005da4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005de2:	47b5                	li	a5,13
    80005de4:	0cf48763          	beq	s1,a5,80005eb2 <consoleintr+0x14a>
      consputc(c);
    80005de8:	8526                	mv	a0,s1
    80005dea:	00000097          	auipc	ra,0x0
    80005dee:	f3c080e7          	jalr	-196(ra) # 80005d26 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005df2:	0002a797          	auipc	a5,0x2a
    80005df6:	34e78793          	addi	a5,a5,846 # 80030140 <cons>
    80005dfa:	0a07a703          	lw	a4,160(a5)
    80005dfe:	0017069b          	addiw	a3,a4,1
    80005e02:	0006861b          	sext.w	a2,a3
    80005e06:	0ad7a023          	sw	a3,160(a5)
    80005e0a:	07f77713          	andi	a4,a4,127
    80005e0e:	97ba                	add	a5,a5,a4
    80005e10:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005e14:	47a9                	li	a5,10
    80005e16:	0cf48563          	beq	s1,a5,80005ee0 <consoleintr+0x178>
    80005e1a:	4791                	li	a5,4
    80005e1c:	0cf48263          	beq	s1,a5,80005ee0 <consoleintr+0x178>
    80005e20:	0002a797          	auipc	a5,0x2a
    80005e24:	3b87a783          	lw	a5,952(a5) # 800301d8 <cons+0x98>
    80005e28:	0807879b          	addiw	a5,a5,128
    80005e2c:	f6f61ce3          	bne	a2,a5,80005da4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005e30:	863e                	mv	a2,a5
    80005e32:	a07d                	j	80005ee0 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005e34:	0002a717          	auipc	a4,0x2a
    80005e38:	30c70713          	addi	a4,a4,780 # 80030140 <cons>
    80005e3c:	0a072783          	lw	a5,160(a4)
    80005e40:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005e44:	0002a497          	auipc	s1,0x2a
    80005e48:	2fc48493          	addi	s1,s1,764 # 80030140 <cons>
    while(cons.e != cons.w &&
    80005e4c:	4929                	li	s2,10
    80005e4e:	f4f70be3          	beq	a4,a5,80005da4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005e52:	37fd                	addiw	a5,a5,-1
    80005e54:	07f7f713          	andi	a4,a5,127
    80005e58:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005e5a:	01874703          	lbu	a4,24(a4)
    80005e5e:	f52703e3          	beq	a4,s2,80005da4 <consoleintr+0x3c>
      cons.e--;
    80005e62:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005e66:	10000513          	li	a0,256
    80005e6a:	00000097          	auipc	ra,0x0
    80005e6e:	ebc080e7          	jalr	-324(ra) # 80005d26 <consputc>
    while(cons.e != cons.w &&
    80005e72:	0a04a783          	lw	a5,160(s1)
    80005e76:	09c4a703          	lw	a4,156(s1)
    80005e7a:	fcf71ce3          	bne	a4,a5,80005e52 <consoleintr+0xea>
    80005e7e:	b71d                	j	80005da4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005e80:	0002a717          	auipc	a4,0x2a
    80005e84:	2c070713          	addi	a4,a4,704 # 80030140 <cons>
    80005e88:	0a072783          	lw	a5,160(a4)
    80005e8c:	09c72703          	lw	a4,156(a4)
    80005e90:	f0f70ae3          	beq	a4,a5,80005da4 <consoleintr+0x3c>
      cons.e--;
    80005e94:	37fd                	addiw	a5,a5,-1
    80005e96:	0002a717          	auipc	a4,0x2a
    80005e9a:	34f72523          	sw	a5,842(a4) # 800301e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005e9e:	10000513          	li	a0,256
    80005ea2:	00000097          	auipc	ra,0x0
    80005ea6:	e84080e7          	jalr	-380(ra) # 80005d26 <consputc>
    80005eaa:	bded                	j	80005da4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005eac:	ee048ce3          	beqz	s1,80005da4 <consoleintr+0x3c>
    80005eb0:	bf21                	j	80005dc8 <consoleintr+0x60>
      consputc(c);
    80005eb2:	4529                	li	a0,10
    80005eb4:	00000097          	auipc	ra,0x0
    80005eb8:	e72080e7          	jalr	-398(ra) # 80005d26 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ebc:	0002a797          	auipc	a5,0x2a
    80005ec0:	28478793          	addi	a5,a5,644 # 80030140 <cons>
    80005ec4:	0a07a703          	lw	a4,160(a5)
    80005ec8:	0017069b          	addiw	a3,a4,1
    80005ecc:	0006861b          	sext.w	a2,a3
    80005ed0:	0ad7a023          	sw	a3,160(a5)
    80005ed4:	07f77713          	andi	a4,a4,127
    80005ed8:	97ba                	add	a5,a5,a4
    80005eda:	4729                	li	a4,10
    80005edc:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005ee0:	0002a797          	auipc	a5,0x2a
    80005ee4:	2ec7ae23          	sw	a2,764(a5) # 800301dc <cons+0x9c>
        wakeup(&cons.r);
    80005ee8:	0002a517          	auipc	a0,0x2a
    80005eec:	2f050513          	addi	a0,a0,752 # 800301d8 <cons+0x98>
    80005ef0:	ffffc097          	auipc	ra,0xffffc
    80005ef4:	84a080e7          	jalr	-1974(ra) # 8000173a <wakeup>
    80005ef8:	b575                	j	80005da4 <consoleintr+0x3c>

0000000080005efa <consoleinit>:

void
consoleinit(void)
{
    80005efa:	1141                	addi	sp,sp,-16
    80005efc:	e406                	sd	ra,8(sp)
    80005efe:	e022                	sd	s0,0(sp)
    80005f00:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005f02:	00003597          	auipc	a1,0x3
    80005f06:	86658593          	addi	a1,a1,-1946 # 80008768 <syscalls+0x3d8>
    80005f0a:	0002a517          	auipc	a0,0x2a
    80005f0e:	23650513          	addi	a0,a0,566 # 80030140 <cons>
    80005f12:	00000097          	auipc	ra,0x0
    80005f16:	590080e7          	jalr	1424(ra) # 800064a2 <initlock>

  uartinit();
    80005f1a:	00000097          	auipc	ra,0x0
    80005f1e:	330080e7          	jalr	816(ra) # 8000624a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005f22:	0001d797          	auipc	a5,0x1d
    80005f26:	5a678793          	addi	a5,a5,1446 # 800234c8 <devsw>
    80005f2a:	00000717          	auipc	a4,0x0
    80005f2e:	ce470713          	addi	a4,a4,-796 # 80005c0e <consoleread>
    80005f32:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005f34:	00000717          	auipc	a4,0x0
    80005f38:	c7870713          	addi	a4,a4,-904 # 80005bac <consolewrite>
    80005f3c:	ef98                	sd	a4,24(a5)
}
    80005f3e:	60a2                	ld	ra,8(sp)
    80005f40:	6402                	ld	s0,0(sp)
    80005f42:	0141                	addi	sp,sp,16
    80005f44:	8082                	ret

0000000080005f46 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005f46:	7179                	addi	sp,sp,-48
    80005f48:	f406                	sd	ra,40(sp)
    80005f4a:	f022                	sd	s0,32(sp)
    80005f4c:	ec26                	sd	s1,24(sp)
    80005f4e:	e84a                	sd	s2,16(sp)
    80005f50:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005f52:	c219                	beqz	a2,80005f58 <printint+0x12>
    80005f54:	08054663          	bltz	a0,80005fe0 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005f58:	2501                	sext.w	a0,a0
    80005f5a:	4881                	li	a7,0
    80005f5c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005f60:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005f62:	2581                	sext.w	a1,a1
    80005f64:	00003617          	auipc	a2,0x3
    80005f68:	83460613          	addi	a2,a2,-1996 # 80008798 <digits>
    80005f6c:	883a                	mv	a6,a4
    80005f6e:	2705                	addiw	a4,a4,1
    80005f70:	02b577bb          	remuw	a5,a0,a1
    80005f74:	1782                	slli	a5,a5,0x20
    80005f76:	9381                	srli	a5,a5,0x20
    80005f78:	97b2                	add	a5,a5,a2
    80005f7a:	0007c783          	lbu	a5,0(a5)
    80005f7e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005f82:	0005079b          	sext.w	a5,a0
    80005f86:	02b5553b          	divuw	a0,a0,a1
    80005f8a:	0685                	addi	a3,a3,1
    80005f8c:	feb7f0e3          	bgeu	a5,a1,80005f6c <printint+0x26>

  if(sign)
    80005f90:	00088b63          	beqz	a7,80005fa6 <printint+0x60>
    buf[i++] = '-';
    80005f94:	fe040793          	addi	a5,s0,-32
    80005f98:	973e                	add	a4,a4,a5
    80005f9a:	02d00793          	li	a5,45
    80005f9e:	fef70823          	sb	a5,-16(a4)
    80005fa2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005fa6:	02e05763          	blez	a4,80005fd4 <printint+0x8e>
    80005faa:	fd040793          	addi	a5,s0,-48
    80005fae:	00e784b3          	add	s1,a5,a4
    80005fb2:	fff78913          	addi	s2,a5,-1
    80005fb6:	993a                	add	s2,s2,a4
    80005fb8:	377d                	addiw	a4,a4,-1
    80005fba:	1702                	slli	a4,a4,0x20
    80005fbc:	9301                	srli	a4,a4,0x20
    80005fbe:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005fc2:	fff4c503          	lbu	a0,-1(s1)
    80005fc6:	00000097          	auipc	ra,0x0
    80005fca:	d60080e7          	jalr	-672(ra) # 80005d26 <consputc>
  while(--i >= 0)
    80005fce:	14fd                	addi	s1,s1,-1
    80005fd0:	ff2499e3          	bne	s1,s2,80005fc2 <printint+0x7c>
}
    80005fd4:	70a2                	ld	ra,40(sp)
    80005fd6:	7402                	ld	s0,32(sp)
    80005fd8:	64e2                	ld	s1,24(sp)
    80005fda:	6942                	ld	s2,16(sp)
    80005fdc:	6145                	addi	sp,sp,48
    80005fde:	8082                	ret
    x = -xx;
    80005fe0:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005fe4:	4885                	li	a7,1
    x = -xx;
    80005fe6:	bf9d                	j	80005f5c <printint+0x16>

0000000080005fe8 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005fe8:	1101                	addi	sp,sp,-32
    80005fea:	ec06                	sd	ra,24(sp)
    80005fec:	e822                	sd	s0,16(sp)
    80005fee:	e426                	sd	s1,8(sp)
    80005ff0:	1000                	addi	s0,sp,32
    80005ff2:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005ff4:	0002a797          	auipc	a5,0x2a
    80005ff8:	2007a623          	sw	zero,524(a5) # 80030200 <pr+0x18>
  printf("panic: ");
    80005ffc:	00002517          	auipc	a0,0x2
    80006000:	77450513          	addi	a0,a0,1908 # 80008770 <syscalls+0x3e0>
    80006004:	00000097          	auipc	ra,0x0
    80006008:	02e080e7          	jalr	46(ra) # 80006032 <printf>
  printf(s);
    8000600c:	8526                	mv	a0,s1
    8000600e:	00000097          	auipc	ra,0x0
    80006012:	024080e7          	jalr	36(ra) # 80006032 <printf>
  printf("\n");
    80006016:	00002517          	auipc	a0,0x2
    8000601a:	03250513          	addi	a0,a0,50 # 80008048 <etext+0x48>
    8000601e:	00000097          	auipc	ra,0x0
    80006022:	014080e7          	jalr	20(ra) # 80006032 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006026:	4785                	li	a5,1
    80006028:	00003717          	auipc	a4,0x3
    8000602c:	fef72a23          	sw	a5,-12(a4) # 8000901c <panicked>
  for(;;)
    80006030:	a001                	j	80006030 <panic+0x48>

0000000080006032 <printf>:
{
    80006032:	7131                	addi	sp,sp,-192
    80006034:	fc86                	sd	ra,120(sp)
    80006036:	f8a2                	sd	s0,112(sp)
    80006038:	f4a6                	sd	s1,104(sp)
    8000603a:	f0ca                	sd	s2,96(sp)
    8000603c:	ecce                	sd	s3,88(sp)
    8000603e:	e8d2                	sd	s4,80(sp)
    80006040:	e4d6                	sd	s5,72(sp)
    80006042:	e0da                	sd	s6,64(sp)
    80006044:	fc5e                	sd	s7,56(sp)
    80006046:	f862                	sd	s8,48(sp)
    80006048:	f466                	sd	s9,40(sp)
    8000604a:	f06a                	sd	s10,32(sp)
    8000604c:	ec6e                	sd	s11,24(sp)
    8000604e:	0100                	addi	s0,sp,128
    80006050:	8a2a                	mv	s4,a0
    80006052:	e40c                	sd	a1,8(s0)
    80006054:	e810                	sd	a2,16(s0)
    80006056:	ec14                	sd	a3,24(s0)
    80006058:	f018                	sd	a4,32(s0)
    8000605a:	f41c                	sd	a5,40(s0)
    8000605c:	03043823          	sd	a6,48(s0)
    80006060:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006064:	0002ad97          	auipc	s11,0x2a
    80006068:	19cdad83          	lw	s11,412(s11) # 80030200 <pr+0x18>
  if(locking)
    8000606c:	020d9b63          	bnez	s11,800060a2 <printf+0x70>
  if (fmt == 0)
    80006070:	040a0263          	beqz	s4,800060b4 <printf+0x82>
  va_start(ap, fmt);
    80006074:	00840793          	addi	a5,s0,8
    80006078:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000607c:	000a4503          	lbu	a0,0(s4)
    80006080:	16050263          	beqz	a0,800061e4 <printf+0x1b2>
    80006084:	4481                	li	s1,0
    if(c != '%'){
    80006086:	02500a93          	li	s5,37
    switch(c){
    8000608a:	07000b13          	li	s6,112
  consputc('x');
    8000608e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006090:	00002b97          	auipc	s7,0x2
    80006094:	708b8b93          	addi	s7,s7,1800 # 80008798 <digits>
    switch(c){
    80006098:	07300c93          	li	s9,115
    8000609c:	06400c13          	li	s8,100
    800060a0:	a82d                	j	800060da <printf+0xa8>
    acquire(&pr.lock);
    800060a2:	0002a517          	auipc	a0,0x2a
    800060a6:	14650513          	addi	a0,a0,326 # 800301e8 <pr>
    800060aa:	00000097          	auipc	ra,0x0
    800060ae:	488080e7          	jalr	1160(ra) # 80006532 <acquire>
    800060b2:	bf7d                	j	80006070 <printf+0x3e>
    panic("null fmt");
    800060b4:	00002517          	auipc	a0,0x2
    800060b8:	6cc50513          	addi	a0,a0,1740 # 80008780 <syscalls+0x3f0>
    800060bc:	00000097          	auipc	ra,0x0
    800060c0:	f2c080e7          	jalr	-212(ra) # 80005fe8 <panic>
      consputc(c);
    800060c4:	00000097          	auipc	ra,0x0
    800060c8:	c62080e7          	jalr	-926(ra) # 80005d26 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800060cc:	2485                	addiw	s1,s1,1
    800060ce:	009a07b3          	add	a5,s4,s1
    800060d2:	0007c503          	lbu	a0,0(a5)
    800060d6:	10050763          	beqz	a0,800061e4 <printf+0x1b2>
    if(c != '%'){
    800060da:	ff5515e3          	bne	a0,s5,800060c4 <printf+0x92>
    c = fmt[++i] & 0xff;
    800060de:	2485                	addiw	s1,s1,1
    800060e0:	009a07b3          	add	a5,s4,s1
    800060e4:	0007c783          	lbu	a5,0(a5)
    800060e8:	0007891b          	sext.w	s2,a5
    if(c == 0)
    800060ec:	cfe5                	beqz	a5,800061e4 <printf+0x1b2>
    switch(c){
    800060ee:	05678a63          	beq	a5,s6,80006142 <printf+0x110>
    800060f2:	02fb7663          	bgeu	s6,a5,8000611e <printf+0xec>
    800060f6:	09978963          	beq	a5,s9,80006188 <printf+0x156>
    800060fa:	07800713          	li	a4,120
    800060fe:	0ce79863          	bne	a5,a4,800061ce <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80006102:	f8843783          	ld	a5,-120(s0)
    80006106:	00878713          	addi	a4,a5,8
    8000610a:	f8e43423          	sd	a4,-120(s0)
    8000610e:	4605                	li	a2,1
    80006110:	85ea                	mv	a1,s10
    80006112:	4388                	lw	a0,0(a5)
    80006114:	00000097          	auipc	ra,0x0
    80006118:	e32080e7          	jalr	-462(ra) # 80005f46 <printint>
      break;
    8000611c:	bf45                	j	800060cc <printf+0x9a>
    switch(c){
    8000611e:	0b578263          	beq	a5,s5,800061c2 <printf+0x190>
    80006122:	0b879663          	bne	a5,s8,800061ce <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80006126:	f8843783          	ld	a5,-120(s0)
    8000612a:	00878713          	addi	a4,a5,8
    8000612e:	f8e43423          	sd	a4,-120(s0)
    80006132:	4605                	li	a2,1
    80006134:	45a9                	li	a1,10
    80006136:	4388                	lw	a0,0(a5)
    80006138:	00000097          	auipc	ra,0x0
    8000613c:	e0e080e7          	jalr	-498(ra) # 80005f46 <printint>
      break;
    80006140:	b771                	j	800060cc <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006142:	f8843783          	ld	a5,-120(s0)
    80006146:	00878713          	addi	a4,a5,8
    8000614a:	f8e43423          	sd	a4,-120(s0)
    8000614e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80006152:	03000513          	li	a0,48
    80006156:	00000097          	auipc	ra,0x0
    8000615a:	bd0080e7          	jalr	-1072(ra) # 80005d26 <consputc>
  consputc('x');
    8000615e:	07800513          	li	a0,120
    80006162:	00000097          	auipc	ra,0x0
    80006166:	bc4080e7          	jalr	-1084(ra) # 80005d26 <consputc>
    8000616a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000616c:	03c9d793          	srli	a5,s3,0x3c
    80006170:	97de                	add	a5,a5,s7
    80006172:	0007c503          	lbu	a0,0(a5)
    80006176:	00000097          	auipc	ra,0x0
    8000617a:	bb0080e7          	jalr	-1104(ra) # 80005d26 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000617e:	0992                	slli	s3,s3,0x4
    80006180:	397d                	addiw	s2,s2,-1
    80006182:	fe0915e3          	bnez	s2,8000616c <printf+0x13a>
    80006186:	b799                	j	800060cc <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006188:	f8843783          	ld	a5,-120(s0)
    8000618c:	00878713          	addi	a4,a5,8
    80006190:	f8e43423          	sd	a4,-120(s0)
    80006194:	0007b903          	ld	s2,0(a5)
    80006198:	00090e63          	beqz	s2,800061b4 <printf+0x182>
      for(; *s; s++)
    8000619c:	00094503          	lbu	a0,0(s2)
    800061a0:	d515                	beqz	a0,800060cc <printf+0x9a>
        consputc(*s);
    800061a2:	00000097          	auipc	ra,0x0
    800061a6:	b84080e7          	jalr	-1148(ra) # 80005d26 <consputc>
      for(; *s; s++)
    800061aa:	0905                	addi	s2,s2,1
    800061ac:	00094503          	lbu	a0,0(s2)
    800061b0:	f96d                	bnez	a0,800061a2 <printf+0x170>
    800061b2:	bf29                	j	800060cc <printf+0x9a>
        s = "(null)";
    800061b4:	00002917          	auipc	s2,0x2
    800061b8:	5c490913          	addi	s2,s2,1476 # 80008778 <syscalls+0x3e8>
      for(; *s; s++)
    800061bc:	02800513          	li	a0,40
    800061c0:	b7cd                	j	800061a2 <printf+0x170>
      consputc('%');
    800061c2:	8556                	mv	a0,s5
    800061c4:	00000097          	auipc	ra,0x0
    800061c8:	b62080e7          	jalr	-1182(ra) # 80005d26 <consputc>
      break;
    800061cc:	b701                	j	800060cc <printf+0x9a>
      consputc('%');
    800061ce:	8556                	mv	a0,s5
    800061d0:	00000097          	auipc	ra,0x0
    800061d4:	b56080e7          	jalr	-1194(ra) # 80005d26 <consputc>
      consputc(c);
    800061d8:	854a                	mv	a0,s2
    800061da:	00000097          	auipc	ra,0x0
    800061de:	b4c080e7          	jalr	-1204(ra) # 80005d26 <consputc>
      break;
    800061e2:	b5ed                	j	800060cc <printf+0x9a>
  if(locking)
    800061e4:	020d9163          	bnez	s11,80006206 <printf+0x1d4>
}
    800061e8:	70e6                	ld	ra,120(sp)
    800061ea:	7446                	ld	s0,112(sp)
    800061ec:	74a6                	ld	s1,104(sp)
    800061ee:	7906                	ld	s2,96(sp)
    800061f0:	69e6                	ld	s3,88(sp)
    800061f2:	6a46                	ld	s4,80(sp)
    800061f4:	6aa6                	ld	s5,72(sp)
    800061f6:	6b06                	ld	s6,64(sp)
    800061f8:	7be2                	ld	s7,56(sp)
    800061fa:	7c42                	ld	s8,48(sp)
    800061fc:	7ca2                	ld	s9,40(sp)
    800061fe:	7d02                	ld	s10,32(sp)
    80006200:	6de2                	ld	s11,24(sp)
    80006202:	6129                	addi	sp,sp,192
    80006204:	8082                	ret
    release(&pr.lock);
    80006206:	0002a517          	auipc	a0,0x2a
    8000620a:	fe250513          	addi	a0,a0,-30 # 800301e8 <pr>
    8000620e:	00000097          	auipc	ra,0x0
    80006212:	3d8080e7          	jalr	984(ra) # 800065e6 <release>
}
    80006216:	bfc9                	j	800061e8 <printf+0x1b6>

0000000080006218 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006218:	1101                	addi	sp,sp,-32
    8000621a:	ec06                	sd	ra,24(sp)
    8000621c:	e822                	sd	s0,16(sp)
    8000621e:	e426                	sd	s1,8(sp)
    80006220:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006222:	0002a497          	auipc	s1,0x2a
    80006226:	fc648493          	addi	s1,s1,-58 # 800301e8 <pr>
    8000622a:	00002597          	auipc	a1,0x2
    8000622e:	56658593          	addi	a1,a1,1382 # 80008790 <syscalls+0x400>
    80006232:	8526                	mv	a0,s1
    80006234:	00000097          	auipc	ra,0x0
    80006238:	26e080e7          	jalr	622(ra) # 800064a2 <initlock>
  pr.locking = 1;
    8000623c:	4785                	li	a5,1
    8000623e:	cc9c                	sw	a5,24(s1)
}
    80006240:	60e2                	ld	ra,24(sp)
    80006242:	6442                	ld	s0,16(sp)
    80006244:	64a2                	ld	s1,8(sp)
    80006246:	6105                	addi	sp,sp,32
    80006248:	8082                	ret

000000008000624a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000624a:	1141                	addi	sp,sp,-16
    8000624c:	e406                	sd	ra,8(sp)
    8000624e:	e022                	sd	s0,0(sp)
    80006250:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006252:	100007b7          	lui	a5,0x10000
    80006256:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000625a:	f8000713          	li	a4,-128
    8000625e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006262:	470d                	li	a4,3
    80006264:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006268:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000626c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006270:	469d                	li	a3,7
    80006272:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006276:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000627a:	00002597          	auipc	a1,0x2
    8000627e:	53658593          	addi	a1,a1,1334 # 800087b0 <digits+0x18>
    80006282:	0002a517          	auipc	a0,0x2a
    80006286:	f8650513          	addi	a0,a0,-122 # 80030208 <uart_tx_lock>
    8000628a:	00000097          	auipc	ra,0x0
    8000628e:	218080e7          	jalr	536(ra) # 800064a2 <initlock>
}
    80006292:	60a2                	ld	ra,8(sp)
    80006294:	6402                	ld	s0,0(sp)
    80006296:	0141                	addi	sp,sp,16
    80006298:	8082                	ret

000000008000629a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000629a:	1101                	addi	sp,sp,-32
    8000629c:	ec06                	sd	ra,24(sp)
    8000629e:	e822                	sd	s0,16(sp)
    800062a0:	e426                	sd	s1,8(sp)
    800062a2:	1000                	addi	s0,sp,32
    800062a4:	84aa                	mv	s1,a0
  push_off();
    800062a6:	00000097          	auipc	ra,0x0
    800062aa:	240080e7          	jalr	576(ra) # 800064e6 <push_off>

  if(panicked){
    800062ae:	00003797          	auipc	a5,0x3
    800062b2:	d6e7a783          	lw	a5,-658(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800062b6:	10000737          	lui	a4,0x10000
  if(panicked){
    800062ba:	c391                	beqz	a5,800062be <uartputc_sync+0x24>
    for(;;)
    800062bc:	a001                	j	800062bc <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800062be:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800062c2:	0ff7f793          	andi	a5,a5,255
    800062c6:	0207f793          	andi	a5,a5,32
    800062ca:	dbf5                	beqz	a5,800062be <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800062cc:	0ff4f793          	andi	a5,s1,255
    800062d0:	10000737          	lui	a4,0x10000
    800062d4:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    800062d8:	00000097          	auipc	ra,0x0
    800062dc:	2ae080e7          	jalr	686(ra) # 80006586 <pop_off>
}
    800062e0:	60e2                	ld	ra,24(sp)
    800062e2:	6442                	ld	s0,16(sp)
    800062e4:	64a2                	ld	s1,8(sp)
    800062e6:	6105                	addi	sp,sp,32
    800062e8:	8082                	ret

00000000800062ea <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800062ea:	00003717          	auipc	a4,0x3
    800062ee:	d3673703          	ld	a4,-714(a4) # 80009020 <uart_tx_r>
    800062f2:	00003797          	auipc	a5,0x3
    800062f6:	d367b783          	ld	a5,-714(a5) # 80009028 <uart_tx_w>
    800062fa:	06e78c63          	beq	a5,a4,80006372 <uartstart+0x88>
{
    800062fe:	7139                	addi	sp,sp,-64
    80006300:	fc06                	sd	ra,56(sp)
    80006302:	f822                	sd	s0,48(sp)
    80006304:	f426                	sd	s1,40(sp)
    80006306:	f04a                	sd	s2,32(sp)
    80006308:	ec4e                	sd	s3,24(sp)
    8000630a:	e852                	sd	s4,16(sp)
    8000630c:	e456                	sd	s5,8(sp)
    8000630e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006310:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006314:	0002aa17          	auipc	s4,0x2a
    80006318:	ef4a0a13          	addi	s4,s4,-268 # 80030208 <uart_tx_lock>
    uart_tx_r += 1;
    8000631c:	00003497          	auipc	s1,0x3
    80006320:	d0448493          	addi	s1,s1,-764 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006324:	00003997          	auipc	s3,0x3
    80006328:	d0498993          	addi	s3,s3,-764 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000632c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006330:	0ff7f793          	andi	a5,a5,255
    80006334:	0207f793          	andi	a5,a5,32
    80006338:	c785                	beqz	a5,80006360 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000633a:	01f77793          	andi	a5,a4,31
    8000633e:	97d2                	add	a5,a5,s4
    80006340:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006344:	0705                	addi	a4,a4,1
    80006346:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006348:	8526                	mv	a0,s1
    8000634a:	ffffb097          	auipc	ra,0xffffb
    8000634e:	3f0080e7          	jalr	1008(ra) # 8000173a <wakeup>
    
    WriteReg(THR, c);
    80006352:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006356:	6098                	ld	a4,0(s1)
    80006358:	0009b783          	ld	a5,0(s3)
    8000635c:	fce798e3          	bne	a5,a4,8000632c <uartstart+0x42>
  }
}
    80006360:	70e2                	ld	ra,56(sp)
    80006362:	7442                	ld	s0,48(sp)
    80006364:	74a2                	ld	s1,40(sp)
    80006366:	7902                	ld	s2,32(sp)
    80006368:	69e2                	ld	s3,24(sp)
    8000636a:	6a42                	ld	s4,16(sp)
    8000636c:	6aa2                	ld	s5,8(sp)
    8000636e:	6121                	addi	sp,sp,64
    80006370:	8082                	ret
    80006372:	8082                	ret

0000000080006374 <uartputc>:
{
    80006374:	7179                	addi	sp,sp,-48
    80006376:	f406                	sd	ra,40(sp)
    80006378:	f022                	sd	s0,32(sp)
    8000637a:	ec26                	sd	s1,24(sp)
    8000637c:	e84a                	sd	s2,16(sp)
    8000637e:	e44e                	sd	s3,8(sp)
    80006380:	e052                	sd	s4,0(sp)
    80006382:	1800                	addi	s0,sp,48
    80006384:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006386:	0002a517          	auipc	a0,0x2a
    8000638a:	e8250513          	addi	a0,a0,-382 # 80030208 <uart_tx_lock>
    8000638e:	00000097          	auipc	ra,0x0
    80006392:	1a4080e7          	jalr	420(ra) # 80006532 <acquire>
  if(panicked){
    80006396:	00003797          	auipc	a5,0x3
    8000639a:	c867a783          	lw	a5,-890(a5) # 8000901c <panicked>
    8000639e:	c391                	beqz	a5,800063a2 <uartputc+0x2e>
    for(;;)
    800063a0:	a001                	j	800063a0 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063a2:	00003797          	auipc	a5,0x3
    800063a6:	c867b783          	ld	a5,-890(a5) # 80009028 <uart_tx_w>
    800063aa:	00003717          	auipc	a4,0x3
    800063ae:	c7673703          	ld	a4,-906(a4) # 80009020 <uart_tx_r>
    800063b2:	02070713          	addi	a4,a4,32
    800063b6:	02f71b63          	bne	a4,a5,800063ec <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800063ba:	0002aa17          	auipc	s4,0x2a
    800063be:	e4ea0a13          	addi	s4,s4,-434 # 80030208 <uart_tx_lock>
    800063c2:	00003497          	auipc	s1,0x3
    800063c6:	c5e48493          	addi	s1,s1,-930 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063ca:	00003917          	auipc	s2,0x3
    800063ce:	c5e90913          	addi	s2,s2,-930 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800063d2:	85d2                	mv	a1,s4
    800063d4:	8526                	mv	a0,s1
    800063d6:	ffffb097          	auipc	ra,0xffffb
    800063da:	1d8080e7          	jalr	472(ra) # 800015ae <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063de:	00093783          	ld	a5,0(s2)
    800063e2:	6098                	ld	a4,0(s1)
    800063e4:	02070713          	addi	a4,a4,32
    800063e8:	fef705e3          	beq	a4,a5,800063d2 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800063ec:	0002a497          	auipc	s1,0x2a
    800063f0:	e1c48493          	addi	s1,s1,-484 # 80030208 <uart_tx_lock>
    800063f4:	01f7f713          	andi	a4,a5,31
    800063f8:	9726                	add	a4,a4,s1
    800063fa:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800063fe:	0785                	addi	a5,a5,1
    80006400:	00003717          	auipc	a4,0x3
    80006404:	c2f73423          	sd	a5,-984(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006408:	00000097          	auipc	ra,0x0
    8000640c:	ee2080e7          	jalr	-286(ra) # 800062ea <uartstart>
      release(&uart_tx_lock);
    80006410:	8526                	mv	a0,s1
    80006412:	00000097          	auipc	ra,0x0
    80006416:	1d4080e7          	jalr	468(ra) # 800065e6 <release>
}
    8000641a:	70a2                	ld	ra,40(sp)
    8000641c:	7402                	ld	s0,32(sp)
    8000641e:	64e2                	ld	s1,24(sp)
    80006420:	6942                	ld	s2,16(sp)
    80006422:	69a2                	ld	s3,8(sp)
    80006424:	6a02                	ld	s4,0(sp)
    80006426:	6145                	addi	sp,sp,48
    80006428:	8082                	ret

000000008000642a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000642a:	1141                	addi	sp,sp,-16
    8000642c:	e422                	sd	s0,8(sp)
    8000642e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006430:	100007b7          	lui	a5,0x10000
    80006434:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006438:	8b85                	andi	a5,a5,1
    8000643a:	cb91                	beqz	a5,8000644e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000643c:	100007b7          	lui	a5,0x10000
    80006440:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006444:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006448:	6422                	ld	s0,8(sp)
    8000644a:	0141                	addi	sp,sp,16
    8000644c:	8082                	ret
    return -1;
    8000644e:	557d                	li	a0,-1
    80006450:	bfe5                	j	80006448 <uartgetc+0x1e>

0000000080006452 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006452:	1101                	addi	sp,sp,-32
    80006454:	ec06                	sd	ra,24(sp)
    80006456:	e822                	sd	s0,16(sp)
    80006458:	e426                	sd	s1,8(sp)
    8000645a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000645c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000645e:	00000097          	auipc	ra,0x0
    80006462:	fcc080e7          	jalr	-52(ra) # 8000642a <uartgetc>
    if(c == -1)
    80006466:	00950763          	beq	a0,s1,80006474 <uartintr+0x22>
      break;
    consoleintr(c);
    8000646a:	00000097          	auipc	ra,0x0
    8000646e:	8fe080e7          	jalr	-1794(ra) # 80005d68 <consoleintr>
  while(1){
    80006472:	b7f5                	j	8000645e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006474:	0002a497          	auipc	s1,0x2a
    80006478:	d9448493          	addi	s1,s1,-620 # 80030208 <uart_tx_lock>
    8000647c:	8526                	mv	a0,s1
    8000647e:	00000097          	auipc	ra,0x0
    80006482:	0b4080e7          	jalr	180(ra) # 80006532 <acquire>
  uartstart();
    80006486:	00000097          	auipc	ra,0x0
    8000648a:	e64080e7          	jalr	-412(ra) # 800062ea <uartstart>
  release(&uart_tx_lock);
    8000648e:	8526                	mv	a0,s1
    80006490:	00000097          	auipc	ra,0x0
    80006494:	156080e7          	jalr	342(ra) # 800065e6 <release>
}
    80006498:	60e2                	ld	ra,24(sp)
    8000649a:	6442                	ld	s0,16(sp)
    8000649c:	64a2                	ld	s1,8(sp)
    8000649e:	6105                	addi	sp,sp,32
    800064a0:	8082                	ret

00000000800064a2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800064a2:	1141                	addi	sp,sp,-16
    800064a4:	e422                	sd	s0,8(sp)
    800064a6:	0800                	addi	s0,sp,16
  lk->name = name;
    800064a8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800064aa:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800064ae:	00053823          	sd	zero,16(a0)
}
    800064b2:	6422                	ld	s0,8(sp)
    800064b4:	0141                	addi	sp,sp,16
    800064b6:	8082                	ret

00000000800064b8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800064b8:	411c                	lw	a5,0(a0)
    800064ba:	e399                	bnez	a5,800064c0 <holding+0x8>
    800064bc:	4501                	li	a0,0
  return r;
}
    800064be:	8082                	ret
{
    800064c0:	1101                	addi	sp,sp,-32
    800064c2:	ec06                	sd	ra,24(sp)
    800064c4:	e822                	sd	s0,16(sp)
    800064c6:	e426                	sd	s1,8(sp)
    800064c8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800064ca:	6904                	ld	s1,16(a0)
    800064cc:	ffffb097          	auipc	ra,0xffffb
    800064d0:	946080e7          	jalr	-1722(ra) # 80000e12 <mycpu>
    800064d4:	40a48533          	sub	a0,s1,a0
    800064d8:	00153513          	seqz	a0,a0
}
    800064dc:	60e2                	ld	ra,24(sp)
    800064de:	6442                	ld	s0,16(sp)
    800064e0:	64a2                	ld	s1,8(sp)
    800064e2:	6105                	addi	sp,sp,32
    800064e4:	8082                	ret

00000000800064e6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800064e6:	1101                	addi	sp,sp,-32
    800064e8:	ec06                	sd	ra,24(sp)
    800064ea:	e822                	sd	s0,16(sp)
    800064ec:	e426                	sd	s1,8(sp)
    800064ee:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064f0:	100024f3          	csrr	s1,sstatus
    800064f4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800064f8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800064fa:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800064fe:	ffffb097          	auipc	ra,0xffffb
    80006502:	914080e7          	jalr	-1772(ra) # 80000e12 <mycpu>
    80006506:	5d3c                	lw	a5,120(a0)
    80006508:	cf89                	beqz	a5,80006522 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000650a:	ffffb097          	auipc	ra,0xffffb
    8000650e:	908080e7          	jalr	-1784(ra) # 80000e12 <mycpu>
    80006512:	5d3c                	lw	a5,120(a0)
    80006514:	2785                	addiw	a5,a5,1
    80006516:	dd3c                	sw	a5,120(a0)
}
    80006518:	60e2                	ld	ra,24(sp)
    8000651a:	6442                	ld	s0,16(sp)
    8000651c:	64a2                	ld	s1,8(sp)
    8000651e:	6105                	addi	sp,sp,32
    80006520:	8082                	ret
    mycpu()->intena = old;
    80006522:	ffffb097          	auipc	ra,0xffffb
    80006526:	8f0080e7          	jalr	-1808(ra) # 80000e12 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000652a:	8085                	srli	s1,s1,0x1
    8000652c:	8885                	andi	s1,s1,1
    8000652e:	dd64                	sw	s1,124(a0)
    80006530:	bfe9                	j	8000650a <push_off+0x24>

0000000080006532 <acquire>:
{
    80006532:	1101                	addi	sp,sp,-32
    80006534:	ec06                	sd	ra,24(sp)
    80006536:	e822                	sd	s0,16(sp)
    80006538:	e426                	sd	s1,8(sp)
    8000653a:	1000                	addi	s0,sp,32
    8000653c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000653e:	00000097          	auipc	ra,0x0
    80006542:	fa8080e7          	jalr	-88(ra) # 800064e6 <push_off>
  if(holding(lk))
    80006546:	8526                	mv	a0,s1
    80006548:	00000097          	auipc	ra,0x0
    8000654c:	f70080e7          	jalr	-144(ra) # 800064b8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006550:	4705                	li	a4,1
  if(holding(lk))
    80006552:	e115                	bnez	a0,80006576 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006554:	87ba                	mv	a5,a4
    80006556:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000655a:	2781                	sext.w	a5,a5
    8000655c:	ffe5                	bnez	a5,80006554 <acquire+0x22>
  __sync_synchronize();
    8000655e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006562:	ffffb097          	auipc	ra,0xffffb
    80006566:	8b0080e7          	jalr	-1872(ra) # 80000e12 <mycpu>
    8000656a:	e888                	sd	a0,16(s1)
}
    8000656c:	60e2                	ld	ra,24(sp)
    8000656e:	6442                	ld	s0,16(sp)
    80006570:	64a2                	ld	s1,8(sp)
    80006572:	6105                	addi	sp,sp,32
    80006574:	8082                	ret
    panic("acquire");
    80006576:	00002517          	auipc	a0,0x2
    8000657a:	24250513          	addi	a0,a0,578 # 800087b8 <digits+0x20>
    8000657e:	00000097          	auipc	ra,0x0
    80006582:	a6a080e7          	jalr	-1430(ra) # 80005fe8 <panic>

0000000080006586 <pop_off>:

void
pop_off(void)
{
    80006586:	1141                	addi	sp,sp,-16
    80006588:	e406                	sd	ra,8(sp)
    8000658a:	e022                	sd	s0,0(sp)
    8000658c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000658e:	ffffb097          	auipc	ra,0xffffb
    80006592:	884080e7          	jalr	-1916(ra) # 80000e12 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006596:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000659a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000659c:	e78d                	bnez	a5,800065c6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000659e:	5d3c                	lw	a5,120(a0)
    800065a0:	02f05b63          	blez	a5,800065d6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800065a4:	37fd                	addiw	a5,a5,-1
    800065a6:	0007871b          	sext.w	a4,a5
    800065aa:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800065ac:	eb09                	bnez	a4,800065be <pop_off+0x38>
    800065ae:	5d7c                	lw	a5,124(a0)
    800065b0:	c799                	beqz	a5,800065be <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065b2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800065b6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800065ba:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800065be:	60a2                	ld	ra,8(sp)
    800065c0:	6402                	ld	s0,0(sp)
    800065c2:	0141                	addi	sp,sp,16
    800065c4:	8082                	ret
    panic("pop_off - interruptible");
    800065c6:	00002517          	auipc	a0,0x2
    800065ca:	1fa50513          	addi	a0,a0,506 # 800087c0 <digits+0x28>
    800065ce:	00000097          	auipc	ra,0x0
    800065d2:	a1a080e7          	jalr	-1510(ra) # 80005fe8 <panic>
    panic("pop_off");
    800065d6:	00002517          	auipc	a0,0x2
    800065da:	20250513          	addi	a0,a0,514 # 800087d8 <digits+0x40>
    800065de:	00000097          	auipc	ra,0x0
    800065e2:	a0a080e7          	jalr	-1526(ra) # 80005fe8 <panic>

00000000800065e6 <release>:
{
    800065e6:	1101                	addi	sp,sp,-32
    800065e8:	ec06                	sd	ra,24(sp)
    800065ea:	e822                	sd	s0,16(sp)
    800065ec:	e426                	sd	s1,8(sp)
    800065ee:	1000                	addi	s0,sp,32
    800065f0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800065f2:	00000097          	auipc	ra,0x0
    800065f6:	ec6080e7          	jalr	-314(ra) # 800064b8 <holding>
    800065fa:	c115                	beqz	a0,8000661e <release+0x38>
  lk->cpu = 0;
    800065fc:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006600:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006604:	0f50000f          	fence	iorw,ow
    80006608:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000660c:	00000097          	auipc	ra,0x0
    80006610:	f7a080e7          	jalr	-134(ra) # 80006586 <pop_off>
}
    80006614:	60e2                	ld	ra,24(sp)
    80006616:	6442                	ld	s0,16(sp)
    80006618:	64a2                	ld	s1,8(sp)
    8000661a:	6105                	addi	sp,sp,32
    8000661c:	8082                	ret
    panic("release");
    8000661e:	00002517          	auipc	a0,0x2
    80006622:	1c250513          	addi	a0,a0,450 # 800087e0 <digits+0x48>
    80006626:	00000097          	auipc	ra,0x0
    8000662a:	9c2080e7          	jalr	-1598(ra) # 80005fe8 <panic>
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
