
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
    80000016:	7a2050ef          	jal	ra,800057b8 <start>

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
    8000004c:	17a080e7          	jalr	378(ra) # 800001c2 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	158080e7          	jalr	344(ra) # 800061b2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1f8080e7          	jalr	504(ra) # 80006266 <release>
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
    8000008e:	bde080e7          	jalr	-1058(ra) # 80005c68 <panic>

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
    800000f8:	02e080e7          	jalr	46(ra) # 80006122 <initlock>
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
    80000130:	086080e7          	jalr	134(ra) # 800061b2 <acquire>
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
    80000148:	122080e7          	jalr	290(ra) # 80006266 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	070080e7          	jalr	112(ra) # 800001c2 <memset>
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
    80000172:	0f8080e7          	jalr	248(ra) # 80006266 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <getfreemem>:
    80000178:	1101                	addi	sp,sp,-32
    8000017a:	ec06                	sd	ra,24(sp)
    8000017c:	e822                	sd	s0,16(sp)
    8000017e:	e426                	sd	s1,8(sp)
    80000180:	1000                	addi	s0,sp,32
    80000182:	00009497          	auipc	s1,0x9
    80000186:	eae48493          	addi	s1,s1,-338 # 80009030 <kmem>
    8000018a:	8526                	mv	a0,s1
    8000018c:	00006097          	auipc	ra,0x6
    80000190:	026080e7          	jalr	38(ra) # 800061b2 <acquire>
    80000194:	6c9c                	ld	a5,24(s1)
    80000196:	c785                	beqz	a5,800001be <getfreemem+0x46>
    80000198:	4481                	li	s1,0
    8000019a:	6705                	lui	a4,0x1
    8000019c:	94ba                	add	s1,s1,a4
    8000019e:	639c                	ld	a5,0(a5)
    800001a0:	fff5                	bnez	a5,8000019c <getfreemem+0x24>
    800001a2:	00009517          	auipc	a0,0x9
    800001a6:	e8e50513          	addi	a0,a0,-370 # 80009030 <kmem>
    800001aa:	00006097          	auipc	ra,0x6
    800001ae:	0bc080e7          	jalr	188(ra) # 80006266 <release>
    800001b2:	8526                	mv	a0,s1
    800001b4:	60e2                	ld	ra,24(sp)
    800001b6:	6442                	ld	s0,16(sp)
    800001b8:	64a2                	ld	s1,8(sp)
    800001ba:	6105                	addi	sp,sp,32
    800001bc:	8082                	ret
    800001be:	4481                	li	s1,0
    800001c0:	b7cd                	j	800001a2 <getfreemem+0x2a>

00000000800001c2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c2:	1141                	addi	sp,sp,-16
    800001c4:	e422                	sd	s0,8(sp)
    800001c6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001c8:	ce09                	beqz	a2,800001e2 <memset+0x20>
    800001ca:	87aa                	mv	a5,a0
    800001cc:	fff6071b          	addiw	a4,a2,-1
    800001d0:	1702                	slli	a4,a4,0x20
    800001d2:	9301                	srli	a4,a4,0x20
    800001d4:	0705                	addi	a4,a4,1
    800001d6:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001dc:	0785                	addi	a5,a5,1
    800001de:	fee79de3          	bne	a5,a4,800001d8 <memset+0x16>
  }
  return dst;
}
    800001e2:	6422                	ld	s0,8(sp)
    800001e4:	0141                	addi	sp,sp,16
    800001e6:	8082                	ret

00000000800001e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e8:	1141                	addi	sp,sp,-16
    800001ea:	e422                	sd	s0,8(sp)
    800001ec:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ee:	ca05                	beqz	a2,8000021e <memcmp+0x36>
    800001f0:	fff6069b          	addiw	a3,a2,-1
    800001f4:	1682                	slli	a3,a3,0x20
    800001f6:	9281                	srli	a3,a3,0x20
    800001f8:	0685                	addi	a3,a3,1
    800001fa:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fc:	00054783          	lbu	a5,0(a0)
    80000200:	0005c703          	lbu	a4,0(a1)
    80000204:	00e79863          	bne	a5,a4,80000214 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000208:	0505                	addi	a0,a0,1
    8000020a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000020c:	fed518e3          	bne	a0,a3,800001fc <memcmp+0x14>
  }

  return 0;
    80000210:	4501                	li	a0,0
    80000212:	a019                	j	80000218 <memcmp+0x30>
      return *s1 - *s2;
    80000214:	40e7853b          	subw	a0,a5,a4
}
    80000218:	6422                	ld	s0,8(sp)
    8000021a:	0141                	addi	sp,sp,16
    8000021c:	8082                	ret
  return 0;
    8000021e:	4501                	li	a0,0
    80000220:	bfe5                	j	80000218 <memcmp+0x30>

0000000080000222 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000222:	1141                	addi	sp,sp,-16
    80000224:	e422                	sd	s0,8(sp)
    80000226:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000228:	ca0d                	beqz	a2,8000025a <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000022a:	00a5f963          	bgeu	a1,a0,8000023c <memmove+0x1a>
    8000022e:	02061693          	slli	a3,a2,0x20
    80000232:	9281                	srli	a3,a3,0x20
    80000234:	00d58733          	add	a4,a1,a3
    80000238:	02e56463          	bltu	a0,a4,80000260 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000023c:	fff6079b          	addiw	a5,a2,-1
    80000240:	1782                	slli	a5,a5,0x20
    80000242:	9381                	srli	a5,a5,0x20
    80000244:	0785                	addi	a5,a5,1
    80000246:	97ae                	add	a5,a5,a1
    80000248:	872a                	mv	a4,a0
      *d++ = *s++;
    8000024a:	0585                	addi	a1,a1,1
    8000024c:	0705                	addi	a4,a4,1
    8000024e:	fff5c683          	lbu	a3,-1(a1)
    80000252:	fed70fa3          	sb	a3,-1(a4) # fff <_entry-0x7ffff001>
    while(n-- > 0)
    80000256:	fef59ae3          	bne	a1,a5,8000024a <memmove+0x28>

  return dst;
}
    8000025a:	6422                	ld	s0,8(sp)
    8000025c:	0141                	addi	sp,sp,16
    8000025e:	8082                	ret
    d += n;
    80000260:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000262:	fff6079b          	addiw	a5,a2,-1
    80000266:	1782                	slli	a5,a5,0x20
    80000268:	9381                	srli	a5,a5,0x20
    8000026a:	fff7c793          	not	a5,a5
    8000026e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000270:	177d                	addi	a4,a4,-1
    80000272:	16fd                	addi	a3,a3,-1
    80000274:	00074603          	lbu	a2,0(a4)
    80000278:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000027c:	fef71ae3          	bne	a4,a5,80000270 <memmove+0x4e>
    80000280:	bfe9                	j	8000025a <memmove+0x38>

0000000080000282 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000282:	1141                	addi	sp,sp,-16
    80000284:	e406                	sd	ra,8(sp)
    80000286:	e022                	sd	s0,0(sp)
    80000288:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	f98080e7          	jalr	-104(ra) # 80000222 <memmove>
}
    80000292:	60a2                	ld	ra,8(sp)
    80000294:	6402                	ld	s0,0(sp)
    80000296:	0141                	addi	sp,sp,16
    80000298:	8082                	ret

000000008000029a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000029a:	1141                	addi	sp,sp,-16
    8000029c:	e422                	sd	s0,8(sp)
    8000029e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800002a0:	ce11                	beqz	a2,800002bc <strncmp+0x22>
    800002a2:	00054783          	lbu	a5,0(a0)
    800002a6:	cf89                	beqz	a5,800002c0 <strncmp+0x26>
    800002a8:	0005c703          	lbu	a4,0(a1)
    800002ac:	00f71a63          	bne	a4,a5,800002c0 <strncmp+0x26>
    n--, p++, q++;
    800002b0:	367d                	addiw	a2,a2,-1
    800002b2:	0505                	addi	a0,a0,1
    800002b4:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b6:	f675                	bnez	a2,800002a2 <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b8:	4501                	li	a0,0
    800002ba:	a809                	j	800002cc <strncmp+0x32>
    800002bc:	4501                	li	a0,0
    800002be:	a039                	j	800002cc <strncmp+0x32>
  if(n == 0)
    800002c0:	ca09                	beqz	a2,800002d2 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002c2:	00054503          	lbu	a0,0(a0)
    800002c6:	0005c783          	lbu	a5,0(a1)
    800002ca:	9d1d                	subw	a0,a0,a5
}
    800002cc:	6422                	ld	s0,8(sp)
    800002ce:	0141                	addi	sp,sp,16
    800002d0:	8082                	ret
    return 0;
    800002d2:	4501                	li	a0,0
    800002d4:	bfe5                	j	800002cc <strncmp+0x32>

00000000800002d6 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002d6:	1141                	addi	sp,sp,-16
    800002d8:	e422                	sd	s0,8(sp)
    800002da:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002dc:	872a                	mv	a4,a0
    800002de:	8832                	mv	a6,a2
    800002e0:	367d                	addiw	a2,a2,-1
    800002e2:	01005963          	blez	a6,800002f4 <strncpy+0x1e>
    800002e6:	0705                	addi	a4,a4,1
    800002e8:	0005c783          	lbu	a5,0(a1)
    800002ec:	fef70fa3          	sb	a5,-1(a4)
    800002f0:	0585                	addi	a1,a1,1
    800002f2:	f7f5                	bnez	a5,800002de <strncpy+0x8>
    ;
  while(n-- > 0)
    800002f4:	00c05d63          	blez	a2,8000030e <strncpy+0x38>
    800002f8:	86ba                	mv	a3,a4
    *s++ = 0;
    800002fa:	0685                	addi	a3,a3,1
    800002fc:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000300:	fff6c793          	not	a5,a3
    80000304:	9fb9                	addw	a5,a5,a4
    80000306:	010787bb          	addw	a5,a5,a6
    8000030a:	fef048e3          	bgtz	a5,800002fa <strncpy+0x24>
  return os;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret

0000000080000314 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000314:	1141                	addi	sp,sp,-16
    80000316:	e422                	sd	s0,8(sp)
    80000318:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000031a:	02c05363          	blez	a2,80000340 <safestrcpy+0x2c>
    8000031e:	fff6069b          	addiw	a3,a2,-1
    80000322:	1682                	slli	a3,a3,0x20
    80000324:	9281                	srli	a3,a3,0x20
    80000326:	96ae                	add	a3,a3,a1
    80000328:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000032a:	00d58963          	beq	a1,a3,8000033c <safestrcpy+0x28>
    8000032e:	0585                	addi	a1,a1,1
    80000330:	0785                	addi	a5,a5,1
    80000332:	fff5c703          	lbu	a4,-1(a1)
    80000336:	fee78fa3          	sb	a4,-1(a5)
    8000033a:	fb65                	bnez	a4,8000032a <safestrcpy+0x16>
    ;
  *s = 0;
    8000033c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000340:	6422                	ld	s0,8(sp)
    80000342:	0141                	addi	sp,sp,16
    80000344:	8082                	ret

0000000080000346 <strlen>:

int
strlen(const char *s)
{
    80000346:	1141                	addi	sp,sp,-16
    80000348:	e422                	sd	s0,8(sp)
    8000034a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000034c:	00054783          	lbu	a5,0(a0)
    80000350:	cf91                	beqz	a5,8000036c <strlen+0x26>
    80000352:	0505                	addi	a0,a0,1
    80000354:	87aa                	mv	a5,a0
    80000356:	4685                	li	a3,1
    80000358:	9e89                	subw	a3,a3,a0
    8000035a:	00f6853b          	addw	a0,a3,a5
    8000035e:	0785                	addi	a5,a5,1
    80000360:	fff7c703          	lbu	a4,-1(a5)
    80000364:	fb7d                	bnez	a4,8000035a <strlen+0x14>
    ;
  return n;
}
    80000366:	6422                	ld	s0,8(sp)
    80000368:	0141                	addi	sp,sp,16
    8000036a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000036c:	4501                	li	a0,0
    8000036e:	bfe5                	j	80000366 <strlen+0x20>

0000000080000370 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000370:	1141                	addi	sp,sp,-16
    80000372:	e406                	sd	ra,8(sp)
    80000374:	e022                	sd	s0,0(sp)
    80000376:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000378:	00001097          	auipc	ra,0x1
    8000037c:	aee080e7          	jalr	-1298(ra) # 80000e66 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000380:	00009717          	auipc	a4,0x9
    80000384:	c8070713          	addi	a4,a4,-896 # 80009000 <started>
  if(cpuid() == 0){
    80000388:	c139                	beqz	a0,800003ce <main+0x5e>
    while(started == 0)
    8000038a:	431c                	lw	a5,0(a4)
    8000038c:	2781                	sext.w	a5,a5
    8000038e:	dff5                	beqz	a5,8000038a <main+0x1a>
      ;
    __sync_synchronize();
    80000390:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000394:	00001097          	auipc	ra,0x1
    80000398:	ad2080e7          	jalr	-1326(ra) # 80000e66 <cpuid>
    8000039c:	85aa                	mv	a1,a0
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c9a50513          	addi	a0,a0,-870 # 80008038 <etext+0x38>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	90c080e7          	jalr	-1780(ra) # 80005cb2 <printf>
    kvminithart();    // turn on paging
    800003ae:	00000097          	auipc	ra,0x0
    800003b2:	0d8080e7          	jalr	216(ra) # 80000486 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003b6:	00001097          	auipc	ra,0x1
    800003ba:	75e080e7          	jalr	1886(ra) # 80001b14 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003be:	00005097          	auipc	ra,0x5
    800003c2:	d82080e7          	jalr	-638(ra) # 80005140 <plicinithart>
  }

  scheduler();        
    800003c6:	00001097          	auipc	ra,0x1
    800003ca:	fde080e7          	jalr	-34(ra) # 800013a4 <scheduler>
    consoleinit();
    800003ce:	00005097          	auipc	ra,0x5
    800003d2:	7ac080e7          	jalr	1964(ra) # 80005b7a <consoleinit>
    printfinit();
    800003d6:	00006097          	auipc	ra,0x6
    800003da:	ac2080e7          	jalr	-1342(ra) # 80005e98 <printfinit>
    printf("\n");
    800003de:	00008517          	auipc	a0,0x8
    800003e2:	c6a50513          	addi	a0,a0,-918 # 80008048 <etext+0x48>
    800003e6:	00006097          	auipc	ra,0x6
    800003ea:	8cc080e7          	jalr	-1844(ra) # 80005cb2 <printf>
    printf("xv6 kernel is booting\n");
    800003ee:	00008517          	auipc	a0,0x8
    800003f2:	c3250513          	addi	a0,a0,-974 # 80008020 <etext+0x20>
    800003f6:	00006097          	auipc	ra,0x6
    800003fa:	8bc080e7          	jalr	-1860(ra) # 80005cb2 <printf>
    printf("\n");
    800003fe:	00008517          	auipc	a0,0x8
    80000402:	c4a50513          	addi	a0,a0,-950 # 80008048 <etext+0x48>
    80000406:	00006097          	auipc	ra,0x6
    8000040a:	8ac080e7          	jalr	-1876(ra) # 80005cb2 <printf>
    kinit();         // physical page allocator
    8000040e:	00000097          	auipc	ra,0x0
    80000412:	cce080e7          	jalr	-818(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    80000416:	00000097          	auipc	ra,0x0
    8000041a:	322080e7          	jalr	802(ra) # 80000738 <kvminit>
    kvminithart();   // turn on paging
    8000041e:	00000097          	auipc	ra,0x0
    80000422:	068080e7          	jalr	104(ra) # 80000486 <kvminithart>
    procinit();      // process table
    80000426:	00001097          	auipc	ra,0x1
    8000042a:	990080e7          	jalr	-1648(ra) # 80000db6 <procinit>
    trapinit();      // trap vectors
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	6be080e7          	jalr	1726(ra) # 80001aec <trapinit>
    trapinithart();  // install kernel trap vector
    80000436:	00001097          	auipc	ra,0x1
    8000043a:	6de080e7          	jalr	1758(ra) # 80001b14 <trapinithart>
    plicinit();      // set up interrupt controller
    8000043e:	00005097          	auipc	ra,0x5
    80000442:	cec080e7          	jalr	-788(ra) # 8000512a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000446:	00005097          	auipc	ra,0x5
    8000044a:	cfa080e7          	jalr	-774(ra) # 80005140 <plicinithart>
    binit();         // buffer cache
    8000044e:	00002097          	auipc	ra,0x2
    80000452:	ede080e7          	jalr	-290(ra) # 8000232c <binit>
    iinit();         // inode table
    80000456:	00002097          	auipc	ra,0x2
    8000045a:	56e080e7          	jalr	1390(ra) # 800029c4 <iinit>
    fileinit();      // file table
    8000045e:	00003097          	auipc	ra,0x3
    80000462:	518080e7          	jalr	1304(ra) # 80003976 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000466:	00005097          	auipc	ra,0x5
    8000046a:	dfc080e7          	jalr	-516(ra) # 80005262 <virtio_disk_init>
    userinit();      // first user process
    8000046e:	00001097          	auipc	ra,0x1
    80000472:	cfc080e7          	jalr	-772(ra) # 8000116a <userinit>
    __sync_synchronize();
    80000476:	0ff0000f          	fence
    started = 1;
    8000047a:	4785                	li	a5,1
    8000047c:	00009717          	auipc	a4,0x9
    80000480:	b8f72223          	sw	a5,-1148(a4) # 80009000 <started>
    80000484:	b789                	j	800003c6 <main+0x56>

0000000080000486 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000486:	1141                	addi	sp,sp,-16
    80000488:	e422                	sd	s0,8(sp)
    8000048a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000048c:	00009797          	auipc	a5,0x9
    80000490:	b7c7b783          	ld	a5,-1156(a5) # 80009008 <kernel_pagetable>
    80000494:	83b1                	srli	a5,a5,0xc
    80000496:	577d                	li	a4,-1
    80000498:	177e                	slli	a4,a4,0x3f
    8000049a:	8fd9                	or	a5,a5,a4

// use riscv's sv39 page table scheme.
#define SATP_SV39 (8L << 60)

#define MAKE_SATP(pagetable) (SATP_SV39 | (((uint64)pagetable) >> 12))

    8000049c:	18079073          	csrw	satp,a5
{
  uint64 x;
  asm volatile("mv %0, ra" : "=r" (x) );
  return x;
}

    800004a0:	12000073          	sfence.vma
  sfence_vma();
}
    800004a4:	6422                	ld	s0,8(sp)
    800004a6:	0141                	addi	sp,sp,16
    800004a8:	8082                	ret

00000000800004aa <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004aa:	7139                	addi	sp,sp,-64
    800004ac:	fc06                	sd	ra,56(sp)
    800004ae:	f822                	sd	s0,48(sp)
    800004b0:	f426                	sd	s1,40(sp)
    800004b2:	f04a                	sd	s2,32(sp)
    800004b4:	ec4e                	sd	s3,24(sp)
    800004b6:	e852                	sd	s4,16(sp)
    800004b8:	e456                	sd	s5,8(sp)
    800004ba:	e05a                	sd	s6,0(sp)
    800004bc:	0080                	addi	s0,sp,64
    800004be:	84aa                	mv	s1,a0
    800004c0:	89ae                	mv	s3,a1
    800004c2:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004c4:	57fd                	li	a5,-1
    800004c6:	83e9                	srli	a5,a5,0x1a
    800004c8:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004ca:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004cc:	04b7f263          	bgeu	a5,a1,80000510 <walk+0x66>
    panic("walk");
    800004d0:	00008517          	auipc	a0,0x8
    800004d4:	b8050513          	addi	a0,a0,-1152 # 80008050 <etext+0x50>
    800004d8:	00005097          	auipc	ra,0x5
    800004dc:	790080e7          	jalr	1936(ra) # 80005c68 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004e0:	060a8663          	beqz	s5,8000054c <walk+0xa2>
    800004e4:	00000097          	auipc	ra,0x0
    800004e8:	c34080e7          	jalr	-972(ra) # 80000118 <kalloc>
    800004ec:	84aa                	mv	s1,a0
    800004ee:	c529                	beqz	a0,80000538 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004f0:	6605                	lui	a2,0x1
    800004f2:	4581                	li	a1,0
    800004f4:	00000097          	auipc	ra,0x0
    800004f8:	cce080e7          	jalr	-818(ra) # 800001c2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004fc:	00c4d793          	srli	a5,s1,0xc
    80000500:	07aa                	slli	a5,a5,0xa
    80000502:	0017e793          	ori	a5,a5,1
    80000506:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000050a:	3a5d                	addiw	s4,s4,-9
    8000050c:	036a0063          	beq	s4,s6,8000052c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000510:	0149d933          	srl	s2,s3,s4
    80000514:	1ff97913          	andi	s2,s2,511
    80000518:	090e                	slli	s2,s2,0x3
    8000051a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000051c:	00093483          	ld	s1,0(s2)
    80000520:	0014f793          	andi	a5,s1,1
    80000524:	dfd5                	beqz	a5,800004e0 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000526:	80a9                	srli	s1,s1,0xa
    80000528:	04b2                	slli	s1,s1,0xc
    8000052a:	b7c5                	j	8000050a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000052c:	00c9d513          	srli	a0,s3,0xc
    80000530:	1ff57513          	andi	a0,a0,511
    80000534:	050e                	slli	a0,a0,0x3
    80000536:	9526                	add	a0,a0,s1
}
    80000538:	70e2                	ld	ra,56(sp)
    8000053a:	7442                	ld	s0,48(sp)
    8000053c:	74a2                	ld	s1,40(sp)
    8000053e:	7902                	ld	s2,32(sp)
    80000540:	69e2                	ld	s3,24(sp)
    80000542:	6a42                	ld	s4,16(sp)
    80000544:	6aa2                	ld	s5,8(sp)
    80000546:	6b02                	ld	s6,0(sp)
    80000548:	6121                	addi	sp,sp,64
    8000054a:	8082                	ret
        return 0;
    8000054c:	4501                	li	a0,0
    8000054e:	b7ed                	j	80000538 <walk+0x8e>

0000000080000550 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000550:	57fd                	li	a5,-1
    80000552:	83e9                	srli	a5,a5,0x1a
    80000554:	00b7f463          	bgeu	a5,a1,8000055c <walkaddr+0xc>
    return 0;
    80000558:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000055a:	8082                	ret
{
    8000055c:	1141                	addi	sp,sp,-16
    8000055e:	e406                	sd	ra,8(sp)
    80000560:	e022                	sd	s0,0(sp)
    80000562:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000564:	4601                	li	a2,0
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	f44080e7          	jalr	-188(ra) # 800004aa <walk>
  if(pte == 0)
    8000056e:	c105                	beqz	a0,8000058e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000570:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000572:	0117f693          	andi	a3,a5,17
    80000576:	4745                	li	a4,17
    return 0;
    80000578:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000057a:	00e68663          	beq	a3,a4,80000586 <walkaddr+0x36>
}
    8000057e:	60a2                	ld	ra,8(sp)
    80000580:	6402                	ld	s0,0(sp)
    80000582:	0141                	addi	sp,sp,16
    80000584:	8082                	ret
  pa = PTE2PA(*pte);
    80000586:	00a7d513          	srli	a0,a5,0xa
    8000058a:	0532                	slli	a0,a0,0xc
  return pa;
    8000058c:	bfcd                	j	8000057e <walkaddr+0x2e>
    return 0;
    8000058e:	4501                	li	a0,0
    80000590:	b7fd                	j	8000057e <walkaddr+0x2e>

0000000080000592 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000592:	715d                	addi	sp,sp,-80
    80000594:	e486                	sd	ra,72(sp)
    80000596:	e0a2                	sd	s0,64(sp)
    80000598:	fc26                	sd	s1,56(sp)
    8000059a:	f84a                	sd	s2,48(sp)
    8000059c:	f44e                	sd	s3,40(sp)
    8000059e:	f052                	sd	s4,32(sp)
    800005a0:	ec56                	sd	s5,24(sp)
    800005a2:	e85a                	sd	s6,16(sp)
    800005a4:	e45e                	sd	s7,8(sp)
    800005a6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005a8:	c205                	beqz	a2,800005c8 <mappages+0x36>
    800005aa:	8aaa                	mv	s5,a0
    800005ac:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005ae:	77fd                	lui	a5,0xfffff
    800005b0:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800005b4:	15fd                	addi	a1,a1,-1
    800005b6:	00c589b3          	add	s3,a1,a2
    800005ba:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800005be:	8952                	mv	s2,s4
    800005c0:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005c4:	6b85                	lui	s7,0x1
    800005c6:	a015                	j	800005ea <mappages+0x58>
    panic("mappages: size");
    800005c8:	00008517          	auipc	a0,0x8
    800005cc:	a9050513          	addi	a0,a0,-1392 # 80008058 <etext+0x58>
    800005d0:	00005097          	auipc	ra,0x5
    800005d4:	698080e7          	jalr	1688(ra) # 80005c68 <panic>
      panic("mappages: remap");
    800005d8:	00008517          	auipc	a0,0x8
    800005dc:	a9050513          	addi	a0,a0,-1392 # 80008068 <etext+0x68>
    800005e0:	00005097          	auipc	ra,0x5
    800005e4:	688080e7          	jalr	1672(ra) # 80005c68 <panic>
    a += PGSIZE;
    800005e8:	995e                	add	s2,s2,s7
  for(;;){
    800005ea:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ee:	4605                	li	a2,1
    800005f0:	85ca                	mv	a1,s2
    800005f2:	8556                	mv	a0,s5
    800005f4:	00000097          	auipc	ra,0x0
    800005f8:	eb6080e7          	jalr	-330(ra) # 800004aa <walk>
    800005fc:	cd19                	beqz	a0,8000061a <mappages+0x88>
    if(*pte & PTE_V)
    800005fe:	611c                	ld	a5,0(a0)
    80000600:	8b85                	andi	a5,a5,1
    80000602:	fbf9                	bnez	a5,800005d8 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000604:	80b1                	srli	s1,s1,0xc
    80000606:	04aa                	slli	s1,s1,0xa
    80000608:	0164e4b3          	or	s1,s1,s6
    8000060c:	0014e493          	ori	s1,s1,1
    80000610:	e104                	sd	s1,0(a0)
    if(a == last)
    80000612:	fd391be3          	bne	s2,s3,800005e8 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    80000616:	4501                	li	a0,0
    80000618:	a011                	j	8000061c <mappages+0x8a>
      return -1;
    8000061a:	557d                	li	a0,-1
}
    8000061c:	60a6                	ld	ra,72(sp)
    8000061e:	6406                	ld	s0,64(sp)
    80000620:	74e2                	ld	s1,56(sp)
    80000622:	7942                	ld	s2,48(sp)
    80000624:	79a2                	ld	s3,40(sp)
    80000626:	7a02                	ld	s4,32(sp)
    80000628:	6ae2                	ld	s5,24(sp)
    8000062a:	6b42                	ld	s6,16(sp)
    8000062c:	6ba2                	ld	s7,8(sp)
    8000062e:	6161                	addi	sp,sp,80
    80000630:	8082                	ret

0000000080000632 <kvmmap>:
{
    80000632:	1141                	addi	sp,sp,-16
    80000634:	e406                	sd	ra,8(sp)
    80000636:	e022                	sd	s0,0(sp)
    80000638:	0800                	addi	s0,sp,16
    8000063a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000063c:	86b2                	mv	a3,a2
    8000063e:	863e                	mv	a2,a5
    80000640:	00000097          	auipc	ra,0x0
    80000644:	f52080e7          	jalr	-174(ra) # 80000592 <mappages>
    80000648:	e509                	bnez	a0,80000652 <kvmmap+0x20>
}
    8000064a:	60a2                	ld	ra,8(sp)
    8000064c:	6402                	ld	s0,0(sp)
    8000064e:	0141                	addi	sp,sp,16
    80000650:	8082                	ret
    panic("kvmmap");
    80000652:	00008517          	auipc	a0,0x8
    80000656:	a2650513          	addi	a0,a0,-1498 # 80008078 <etext+0x78>
    8000065a:	00005097          	auipc	ra,0x5
    8000065e:	60e080e7          	jalr	1550(ra) # 80005c68 <panic>

0000000080000662 <kvmmake>:
{
    80000662:	1101                	addi	sp,sp,-32
    80000664:	ec06                	sd	ra,24(sp)
    80000666:	e822                	sd	s0,16(sp)
    80000668:	e426                	sd	s1,8(sp)
    8000066a:	e04a                	sd	s2,0(sp)
    8000066c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	aaa080e7          	jalr	-1366(ra) # 80000118 <kalloc>
    80000676:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000678:	6605                	lui	a2,0x1
    8000067a:	4581                	li	a1,0
    8000067c:	00000097          	auipc	ra,0x0
    80000680:	b46080e7          	jalr	-1210(ra) # 800001c2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000684:	4719                	li	a4,6
    80000686:	6685                	lui	a3,0x1
    80000688:	10000637          	lui	a2,0x10000
    8000068c:	100005b7          	lui	a1,0x10000
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	fa0080e7          	jalr	-96(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	6685                	lui	a3,0x1
    8000069e:	10001637          	lui	a2,0x10001
    800006a2:	100015b7          	lui	a1,0x10001
    800006a6:	8526                	mv	a0,s1
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	f8a080e7          	jalr	-118(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006b0:	4719                	li	a4,6
    800006b2:	004006b7          	lui	a3,0x400
    800006b6:	0c000637          	lui	a2,0xc000
    800006ba:	0c0005b7          	lui	a1,0xc000
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f72080e7          	jalr	-142(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c8:	00008917          	auipc	s2,0x8
    800006cc:	93890913          	addi	s2,s2,-1736 # 80008000 <etext>
    800006d0:	4729                	li	a4,10
    800006d2:	80008697          	auipc	a3,0x80008
    800006d6:	92e68693          	addi	a3,a3,-1746 # 8000 <_entry-0x7fff8000>
    800006da:	4605                	li	a2,1
    800006dc:	067e                	slli	a2,a2,0x1f
    800006de:	85b2                	mv	a1,a2
    800006e0:	8526                	mv	a0,s1
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	f50080e7          	jalr	-176(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006ea:	4719                	li	a4,6
    800006ec:	46c5                	li	a3,17
    800006ee:	06ee                	slli	a3,a3,0x1b
    800006f0:	412686b3          	sub	a3,a3,s2
    800006f4:	864a                	mv	a2,s2
    800006f6:	85ca                	mv	a1,s2
    800006f8:	8526                	mv	a0,s1
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f38080e7          	jalr	-200(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000702:	4729                	li	a4,10
    80000704:	6685                	lui	a3,0x1
    80000706:	00007617          	auipc	a2,0x7
    8000070a:	8fa60613          	addi	a2,a2,-1798 # 80007000 <_trampoline>
    8000070e:	040005b7          	lui	a1,0x4000
    80000712:	15fd                	addi	a1,a1,-1
    80000714:	05b2                	slli	a1,a1,0xc
    80000716:	8526                	mv	a0,s1
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	f1a080e7          	jalr	-230(ra) # 80000632 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000720:	8526                	mv	a0,s1
    80000722:	00000097          	auipc	ra,0x0
    80000726:	5fe080e7          	jalr	1534(ra) # 80000d20 <proc_mapstacks>
}
    8000072a:	8526                	mv	a0,s1
    8000072c:	60e2                	ld	ra,24(sp)
    8000072e:	6442                	ld	s0,16(sp)
    80000730:	64a2                	ld	s1,8(sp)
    80000732:	6902                	ld	s2,0(sp)
    80000734:	6105                	addi	sp,sp,32
    80000736:	8082                	ret

0000000080000738 <kvminit>:
{
    80000738:	1141                	addi	sp,sp,-16
    8000073a:	e406                	sd	ra,8(sp)
    8000073c:	e022                	sd	s0,0(sp)
    8000073e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000740:	00000097          	auipc	ra,0x0
    80000744:	f22080e7          	jalr	-222(ra) # 80000662 <kvmmake>
    80000748:	00009797          	auipc	a5,0x9
    8000074c:	8ca7b023          	sd	a0,-1856(a5) # 80009008 <kernel_pagetable>
}
    80000750:	60a2                	ld	ra,8(sp)
    80000752:	6402                	ld	s0,0(sp)
    80000754:	0141                	addi	sp,sp,16
    80000756:	8082                	ret

0000000080000758 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000758:	715d                	addi	sp,sp,-80
    8000075a:	e486                	sd	ra,72(sp)
    8000075c:	e0a2                	sd	s0,64(sp)
    8000075e:	fc26                	sd	s1,56(sp)
    80000760:	f84a                	sd	s2,48(sp)
    80000762:	f44e                	sd	s3,40(sp)
    80000764:	f052                	sd	s4,32(sp)
    80000766:	ec56                	sd	s5,24(sp)
    80000768:	e85a                	sd	s6,16(sp)
    8000076a:	e45e                	sd	s7,8(sp)
    8000076c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000076e:	03459793          	slli	a5,a1,0x34
    80000772:	e795                	bnez	a5,8000079e <uvmunmap+0x46>
    80000774:	8a2a                	mv	s4,a0
    80000776:	892e                	mv	s2,a1
    80000778:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077a:	0632                	slli	a2,a2,0xc
    8000077c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000780:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000782:	6b05                	lui	s6,0x1
    80000784:	0735e863          	bltu	a1,s3,800007f4 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000788:	60a6                	ld	ra,72(sp)
    8000078a:	6406                	ld	s0,64(sp)
    8000078c:	74e2                	ld	s1,56(sp)
    8000078e:	7942                	ld	s2,48(sp)
    80000790:	79a2                	ld	s3,40(sp)
    80000792:	7a02                	ld	s4,32(sp)
    80000794:	6ae2                	ld	s5,24(sp)
    80000796:	6b42                	ld	s6,16(sp)
    80000798:	6ba2                	ld	s7,8(sp)
    8000079a:	6161                	addi	sp,sp,80
    8000079c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000079e:	00008517          	auipc	a0,0x8
    800007a2:	8e250513          	addi	a0,a0,-1822 # 80008080 <etext+0x80>
    800007a6:	00005097          	auipc	ra,0x5
    800007aa:	4c2080e7          	jalr	1218(ra) # 80005c68 <panic>
      panic("uvmunmap: walk");
    800007ae:	00008517          	auipc	a0,0x8
    800007b2:	8ea50513          	addi	a0,a0,-1814 # 80008098 <etext+0x98>
    800007b6:	00005097          	auipc	ra,0x5
    800007ba:	4b2080e7          	jalr	1202(ra) # 80005c68 <panic>
      panic("uvmunmap: not mapped");
    800007be:	00008517          	auipc	a0,0x8
    800007c2:	8ea50513          	addi	a0,a0,-1814 # 800080a8 <etext+0xa8>
    800007c6:	00005097          	auipc	ra,0x5
    800007ca:	4a2080e7          	jalr	1186(ra) # 80005c68 <panic>
      panic("uvmunmap: not a leaf");
    800007ce:	00008517          	auipc	a0,0x8
    800007d2:	8f250513          	addi	a0,a0,-1806 # 800080c0 <etext+0xc0>
    800007d6:	00005097          	auipc	ra,0x5
    800007da:	492080e7          	jalr	1170(ra) # 80005c68 <panic>
      uint64 pa = PTE2PA(*pte);
    800007de:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007e0:	0532                	slli	a0,a0,0xc
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	83a080e7          	jalr	-1990(ra) # 8000001c <kfree>
    *pte = 0;
    800007ea:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ee:	995a                	add	s2,s2,s6
    800007f0:	f9397ce3          	bgeu	s2,s3,80000788 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007f4:	4601                	li	a2,0
    800007f6:	85ca                	mv	a1,s2
    800007f8:	8552                	mv	a0,s4
    800007fa:	00000097          	auipc	ra,0x0
    800007fe:	cb0080e7          	jalr	-848(ra) # 800004aa <walk>
    80000802:	84aa                	mv	s1,a0
    80000804:	d54d                	beqz	a0,800007ae <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80000806:	6108                	ld	a0,0(a0)
    80000808:	00157793          	andi	a5,a0,1
    8000080c:	dbcd                	beqz	a5,800007be <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000080e:	3ff57793          	andi	a5,a0,1023
    80000812:	fb778ee3          	beq	a5,s7,800007ce <uvmunmap+0x76>
    if(do_free){
    80000816:	fc0a8ae3          	beqz	s5,800007ea <uvmunmap+0x92>
    8000081a:	b7d1                	j	800007de <uvmunmap+0x86>

000000008000081c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000081c:	1101                	addi	sp,sp,-32
    8000081e:	ec06                	sd	ra,24(sp)
    80000820:	e822                	sd	s0,16(sp)
    80000822:	e426                	sd	s1,8(sp)
    80000824:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	8f2080e7          	jalr	-1806(ra) # 80000118 <kalloc>
    8000082e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000830:	c519                	beqz	a0,8000083e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	98c080e7          	jalr	-1652(ra) # 800001c2 <memset>
  return pagetable;
}
    8000083e:	8526                	mv	a0,s1
    80000840:	60e2                	ld	ra,24(sp)
    80000842:	6442                	ld	s0,16(sp)
    80000844:	64a2                	ld	s1,8(sp)
    80000846:	6105                	addi	sp,sp,32
    80000848:	8082                	ret

000000008000084a <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000084a:	7179                	addi	sp,sp,-48
    8000084c:	f406                	sd	ra,40(sp)
    8000084e:	f022                	sd	s0,32(sp)
    80000850:	ec26                	sd	s1,24(sp)
    80000852:	e84a                	sd	s2,16(sp)
    80000854:	e44e                	sd	s3,8(sp)
    80000856:	e052                	sd	s4,0(sp)
    80000858:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000085a:	6785                	lui	a5,0x1
    8000085c:	04f67863          	bgeu	a2,a5,800008ac <uvminit+0x62>
    80000860:	8a2a                	mv	s4,a0
    80000862:	89ae                	mv	s3,a1
    80000864:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000866:	00000097          	auipc	ra,0x0
    8000086a:	8b2080e7          	jalr	-1870(ra) # 80000118 <kalloc>
    8000086e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000870:	6605                	lui	a2,0x1
    80000872:	4581                	li	a1,0
    80000874:	00000097          	auipc	ra,0x0
    80000878:	94e080e7          	jalr	-1714(ra) # 800001c2 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000087c:	4779                	li	a4,30
    8000087e:	86ca                	mv	a3,s2
    80000880:	6605                	lui	a2,0x1
    80000882:	4581                	li	a1,0
    80000884:	8552                	mv	a0,s4
    80000886:	00000097          	auipc	ra,0x0
    8000088a:	d0c080e7          	jalr	-756(ra) # 80000592 <mappages>
  memmove(mem, src, sz);
    8000088e:	8626                	mv	a2,s1
    80000890:	85ce                	mv	a1,s3
    80000892:	854a                	mv	a0,s2
    80000894:	00000097          	auipc	ra,0x0
    80000898:	98e080e7          	jalr	-1650(ra) # 80000222 <memmove>
}
    8000089c:	70a2                	ld	ra,40(sp)
    8000089e:	7402                	ld	s0,32(sp)
    800008a0:	64e2                	ld	s1,24(sp)
    800008a2:	6942                	ld	s2,16(sp)
    800008a4:	69a2                	ld	s3,8(sp)
    800008a6:	6a02                	ld	s4,0(sp)
    800008a8:	6145                	addi	sp,sp,48
    800008aa:	8082                	ret
    panic("inituvm: more than a page");
    800008ac:	00008517          	auipc	a0,0x8
    800008b0:	82c50513          	addi	a0,a0,-2004 # 800080d8 <etext+0xd8>
    800008b4:	00005097          	auipc	ra,0x5
    800008b8:	3b4080e7          	jalr	948(ra) # 80005c68 <panic>

00000000800008bc <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008bc:	1101                	addi	sp,sp,-32
    800008be:	ec06                	sd	ra,24(sp)
    800008c0:	e822                	sd	s0,16(sp)
    800008c2:	e426                	sd	s1,8(sp)
    800008c4:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008c8:	00b67d63          	bgeu	a2,a1,800008e2 <uvmdealloc+0x26>
    800008cc:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ce:	6785                	lui	a5,0x1
    800008d0:	17fd                	addi	a5,a5,-1
    800008d2:	00f60733          	add	a4,a2,a5
    800008d6:	767d                	lui	a2,0xfffff
    800008d8:	8f71                	and	a4,a4,a2
    800008da:	97ae                	add	a5,a5,a1
    800008dc:	8ff1                	and	a5,a5,a2
    800008de:	00f76863          	bltu	a4,a5,800008ee <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008e2:	8526                	mv	a0,s1
    800008e4:	60e2                	ld	ra,24(sp)
    800008e6:	6442                	ld	s0,16(sp)
    800008e8:	64a2                	ld	s1,8(sp)
    800008ea:	6105                	addi	sp,sp,32
    800008ec:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ee:	8f99                	sub	a5,a5,a4
    800008f0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008f2:	4685                	li	a3,1
    800008f4:	0007861b          	sext.w	a2,a5
    800008f8:	85ba                	mv	a1,a4
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	e5e080e7          	jalr	-418(ra) # 80000758 <uvmunmap>
    80000902:	b7c5                	j	800008e2 <uvmdealloc+0x26>

0000000080000904 <uvmalloc>:
  if(newsz < oldsz)
    80000904:	0ab66163          	bltu	a2,a1,800009a6 <uvmalloc+0xa2>
{
    80000908:	7139                	addi	sp,sp,-64
    8000090a:	fc06                	sd	ra,56(sp)
    8000090c:	f822                	sd	s0,48(sp)
    8000090e:	f426                	sd	s1,40(sp)
    80000910:	f04a                	sd	s2,32(sp)
    80000912:	ec4e                	sd	s3,24(sp)
    80000914:	e852                	sd	s4,16(sp)
    80000916:	e456                	sd	s5,8(sp)
    80000918:	0080                	addi	s0,sp,64
    8000091a:	8aaa                	mv	s5,a0
    8000091c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000091e:	6985                	lui	s3,0x1
    80000920:	19fd                	addi	s3,s3,-1
    80000922:	95ce                	add	a1,a1,s3
    80000924:	79fd                	lui	s3,0xfffff
    80000926:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000092a:	08c9f063          	bgeu	s3,a2,800009aa <uvmalloc+0xa6>
    8000092e:	894e                	mv	s2,s3
    mem = kalloc();
    80000930:	fffff097          	auipc	ra,0xfffff
    80000934:	7e8080e7          	jalr	2024(ra) # 80000118 <kalloc>
    80000938:	84aa                	mv	s1,a0
    if(mem == 0){
    8000093a:	c51d                	beqz	a0,80000968 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000093c:	6605                	lui	a2,0x1
    8000093e:	4581                	li	a1,0
    80000940:	00000097          	auipc	ra,0x0
    80000944:	882080e7          	jalr	-1918(ra) # 800001c2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000948:	4779                	li	a4,30
    8000094a:	86a6                	mv	a3,s1
    8000094c:	6605                	lui	a2,0x1
    8000094e:	85ca                	mv	a1,s2
    80000950:	8556                	mv	a0,s5
    80000952:	00000097          	auipc	ra,0x0
    80000956:	c40080e7          	jalr	-960(ra) # 80000592 <mappages>
    8000095a:	e905                	bnez	a0,8000098a <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000095c:	6785                	lui	a5,0x1
    8000095e:	993e                	add	s2,s2,a5
    80000960:	fd4968e3          	bltu	s2,s4,80000930 <uvmalloc+0x2c>
  return newsz;
    80000964:	8552                	mv	a0,s4
    80000966:	a809                	j	80000978 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000968:	864e                	mv	a2,s3
    8000096a:	85ca                	mv	a1,s2
    8000096c:	8556                	mv	a0,s5
    8000096e:	00000097          	auipc	ra,0x0
    80000972:	f4e080e7          	jalr	-178(ra) # 800008bc <uvmdealloc>
      return 0;
    80000976:	4501                	li	a0,0
}
    80000978:	70e2                	ld	ra,56(sp)
    8000097a:	7442                	ld	s0,48(sp)
    8000097c:	74a2                	ld	s1,40(sp)
    8000097e:	7902                	ld	s2,32(sp)
    80000980:	69e2                	ld	s3,24(sp)
    80000982:	6a42                	ld	s4,16(sp)
    80000984:	6aa2                	ld	s5,8(sp)
    80000986:	6121                	addi	sp,sp,64
    80000988:	8082                	ret
      kfree(mem);
    8000098a:	8526                	mv	a0,s1
    8000098c:	fffff097          	auipc	ra,0xfffff
    80000990:	690080e7          	jalr	1680(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000994:	864e                	mv	a2,s3
    80000996:	85ca                	mv	a1,s2
    80000998:	8556                	mv	a0,s5
    8000099a:	00000097          	auipc	ra,0x0
    8000099e:	f22080e7          	jalr	-222(ra) # 800008bc <uvmdealloc>
      return 0;
    800009a2:	4501                	li	a0,0
    800009a4:	bfd1                	j	80000978 <uvmalloc+0x74>
    return oldsz;
    800009a6:	852e                	mv	a0,a1
}
    800009a8:	8082                	ret
  return newsz;
    800009aa:	8532                	mv	a0,a2
    800009ac:	b7f1                	j	80000978 <uvmalloc+0x74>

00000000800009ae <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009ae:	7179                	addi	sp,sp,-48
    800009b0:	f406                	sd	ra,40(sp)
    800009b2:	f022                	sd	s0,32(sp)
    800009b4:	ec26                	sd	s1,24(sp)
    800009b6:	e84a                	sd	s2,16(sp)
    800009b8:	e44e                	sd	s3,8(sp)
    800009ba:	e052                	sd	s4,0(sp)
    800009bc:	1800                	addi	s0,sp,48
    800009be:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009c0:	84aa                	mv	s1,a0
    800009c2:	6905                	lui	s2,0x1
    800009c4:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c6:	4985                	li	s3,1
    800009c8:	a821                	j	800009e0 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009ca:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009cc:	0532                	slli	a0,a0,0xc
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	fe0080e7          	jalr	-32(ra) # 800009ae <freewalk>
      pagetable[i] = 0;
    800009d6:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009da:	04a1                	addi	s1,s1,8
    800009dc:	03248163          	beq	s1,s2,800009fe <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009e0:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009e2:	00f57793          	andi	a5,a0,15
    800009e6:	ff3782e3          	beq	a5,s3,800009ca <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ea:	8905                	andi	a0,a0,1
    800009ec:	d57d                	beqz	a0,800009da <freewalk+0x2c>
      panic("freewalk: leaf");
    800009ee:	00007517          	auipc	a0,0x7
    800009f2:	70a50513          	addi	a0,a0,1802 # 800080f8 <etext+0xf8>
    800009f6:	00005097          	auipc	ra,0x5
    800009fa:	272080e7          	jalr	626(ra) # 80005c68 <panic>
    }
  }
  kfree((void*)pagetable);
    800009fe:	8552                	mv	a0,s4
    80000a00:	fffff097          	auipc	ra,0xfffff
    80000a04:	61c080e7          	jalr	1564(ra) # 8000001c <kfree>
}
    80000a08:	70a2                	ld	ra,40(sp)
    80000a0a:	7402                	ld	s0,32(sp)
    80000a0c:	64e2                	ld	s1,24(sp)
    80000a0e:	6942                	ld	s2,16(sp)
    80000a10:	69a2                	ld	s3,8(sp)
    80000a12:	6a02                	ld	s4,0(sp)
    80000a14:	6145                	addi	sp,sp,48
    80000a16:	8082                	ret

0000000080000a18 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a18:	1101                	addi	sp,sp,-32
    80000a1a:	ec06                	sd	ra,24(sp)
    80000a1c:	e822                	sd	s0,16(sp)
    80000a1e:	e426                	sd	s1,8(sp)
    80000a20:	1000                	addi	s0,sp,32
    80000a22:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a24:	e999                	bnez	a1,80000a3a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a26:	8526                	mv	a0,s1
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	f86080e7          	jalr	-122(ra) # 800009ae <freewalk>
}
    80000a30:	60e2                	ld	ra,24(sp)
    80000a32:	6442                	ld	s0,16(sp)
    80000a34:	64a2                	ld	s1,8(sp)
    80000a36:	6105                	addi	sp,sp,32
    80000a38:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a3a:	6605                	lui	a2,0x1
    80000a3c:	167d                	addi	a2,a2,-1
    80000a3e:	962e                	add	a2,a2,a1
    80000a40:	4685                	li	a3,1
    80000a42:	8231                	srli	a2,a2,0xc
    80000a44:	4581                	li	a1,0
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	d12080e7          	jalr	-750(ra) # 80000758 <uvmunmap>
    80000a4e:	bfe1                	j	80000a26 <uvmfree+0xe>

0000000080000a50 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a50:	c679                	beqz	a2,80000b1e <uvmcopy+0xce>
{
    80000a52:	715d                	addi	sp,sp,-80
    80000a54:	e486                	sd	ra,72(sp)
    80000a56:	e0a2                	sd	s0,64(sp)
    80000a58:	fc26                	sd	s1,56(sp)
    80000a5a:	f84a                	sd	s2,48(sp)
    80000a5c:	f44e                	sd	s3,40(sp)
    80000a5e:	f052                	sd	s4,32(sp)
    80000a60:	ec56                	sd	s5,24(sp)
    80000a62:	e85a                	sd	s6,16(sp)
    80000a64:	e45e                	sd	s7,8(sp)
    80000a66:	0880                	addi	s0,sp,80
    80000a68:	8b2a                	mv	s6,a0
    80000a6a:	8aae                	mv	s5,a1
    80000a6c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a6e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a70:	4601                	li	a2,0
    80000a72:	85ce                	mv	a1,s3
    80000a74:	855a                	mv	a0,s6
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	a34080e7          	jalr	-1484(ra) # 800004aa <walk>
    80000a7e:	c531                	beqz	a0,80000aca <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a80:	6118                	ld	a4,0(a0)
    80000a82:	00177793          	andi	a5,a4,1
    80000a86:	cbb1                	beqz	a5,80000ada <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a88:	00a75593          	srli	a1,a4,0xa
    80000a8c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a90:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a94:	fffff097          	auipc	ra,0xfffff
    80000a98:	684080e7          	jalr	1668(ra) # 80000118 <kalloc>
    80000a9c:	892a                	mv	s2,a0
    80000a9e:	c939                	beqz	a0,80000af4 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aa0:	6605                	lui	a2,0x1
    80000aa2:	85de                	mv	a1,s7
    80000aa4:	fffff097          	auipc	ra,0xfffff
    80000aa8:	77e080e7          	jalr	1918(ra) # 80000222 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aac:	8726                	mv	a4,s1
    80000aae:	86ca                	mv	a3,s2
    80000ab0:	6605                	lui	a2,0x1
    80000ab2:	85ce                	mv	a1,s3
    80000ab4:	8556                	mv	a0,s5
    80000ab6:	00000097          	auipc	ra,0x0
    80000aba:	adc080e7          	jalr	-1316(ra) # 80000592 <mappages>
    80000abe:	e515                	bnez	a0,80000aea <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ac0:	6785                	lui	a5,0x1
    80000ac2:	99be                	add	s3,s3,a5
    80000ac4:	fb49e6e3          	bltu	s3,s4,80000a70 <uvmcopy+0x20>
    80000ac8:	a081                	j	80000b08 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aca:	00007517          	auipc	a0,0x7
    80000ace:	63e50513          	addi	a0,a0,1598 # 80008108 <etext+0x108>
    80000ad2:	00005097          	auipc	ra,0x5
    80000ad6:	196080e7          	jalr	406(ra) # 80005c68 <panic>
      panic("uvmcopy: page not present");
    80000ada:	00007517          	auipc	a0,0x7
    80000ade:	64e50513          	addi	a0,a0,1614 # 80008128 <etext+0x128>
    80000ae2:	00005097          	auipc	ra,0x5
    80000ae6:	186080e7          	jalr	390(ra) # 80005c68 <panic>
      kfree(mem);
    80000aea:	854a                	mv	a0,s2
    80000aec:	fffff097          	auipc	ra,0xfffff
    80000af0:	530080e7          	jalr	1328(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000af4:	4685                	li	a3,1
    80000af6:	00c9d613          	srli	a2,s3,0xc
    80000afa:	4581                	li	a1,0
    80000afc:	8556                	mv	a0,s5
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	c5a080e7          	jalr	-934(ra) # 80000758 <uvmunmap>
  return -1;
    80000b06:	557d                	li	a0,-1
}
    80000b08:	60a6                	ld	ra,72(sp)
    80000b0a:	6406                	ld	s0,64(sp)
    80000b0c:	74e2                	ld	s1,56(sp)
    80000b0e:	7942                	ld	s2,48(sp)
    80000b10:	79a2                	ld	s3,40(sp)
    80000b12:	7a02                	ld	s4,32(sp)
    80000b14:	6ae2                	ld	s5,24(sp)
    80000b16:	6b42                	ld	s6,16(sp)
    80000b18:	6ba2                	ld	s7,8(sp)
    80000b1a:	6161                	addi	sp,sp,80
    80000b1c:	8082                	ret
  return 0;
    80000b1e:	4501                	li	a0,0
}
    80000b20:	8082                	ret

0000000080000b22 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b22:	1141                	addi	sp,sp,-16
    80000b24:	e406                	sd	ra,8(sp)
    80000b26:	e022                	sd	s0,0(sp)
    80000b28:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b2a:	4601                	li	a2,0
    80000b2c:	00000097          	auipc	ra,0x0
    80000b30:	97e080e7          	jalr	-1666(ra) # 800004aa <walk>
  if(pte == 0)
    80000b34:	c901                	beqz	a0,80000b44 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b36:	611c                	ld	a5,0(a0)
    80000b38:	9bbd                	andi	a5,a5,-17
    80000b3a:	e11c                	sd	a5,0(a0)
}
    80000b3c:	60a2                	ld	ra,8(sp)
    80000b3e:	6402                	ld	s0,0(sp)
    80000b40:	0141                	addi	sp,sp,16
    80000b42:	8082                	ret
    panic("uvmclear");
    80000b44:	00007517          	auipc	a0,0x7
    80000b48:	60450513          	addi	a0,a0,1540 # 80008148 <etext+0x148>
    80000b4c:	00005097          	auipc	ra,0x5
    80000b50:	11c080e7          	jalr	284(ra) # 80005c68 <panic>

0000000080000b54 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b54:	c6bd                	beqz	a3,80000bc2 <copyout+0x6e>
{
    80000b56:	715d                	addi	sp,sp,-80
    80000b58:	e486                	sd	ra,72(sp)
    80000b5a:	e0a2                	sd	s0,64(sp)
    80000b5c:	fc26                	sd	s1,56(sp)
    80000b5e:	f84a                	sd	s2,48(sp)
    80000b60:	f44e                	sd	s3,40(sp)
    80000b62:	f052                	sd	s4,32(sp)
    80000b64:	ec56                	sd	s5,24(sp)
    80000b66:	e85a                	sd	s6,16(sp)
    80000b68:	e45e                	sd	s7,8(sp)
    80000b6a:	e062                	sd	s8,0(sp)
    80000b6c:	0880                	addi	s0,sp,80
    80000b6e:	8b2a                	mv	s6,a0
    80000b70:	8c2e                	mv	s8,a1
    80000b72:	8a32                	mv	s4,a2
    80000b74:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b76:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b78:	6a85                	lui	s5,0x1
    80000b7a:	a015                	j	80000b9e <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b7c:	9562                	add	a0,a0,s8
    80000b7e:	0004861b          	sext.w	a2,s1
    80000b82:	85d2                	mv	a1,s4
    80000b84:	41250533          	sub	a0,a0,s2
    80000b88:	fffff097          	auipc	ra,0xfffff
    80000b8c:	69a080e7          	jalr	1690(ra) # 80000222 <memmove>

    len -= n;
    80000b90:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b94:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b96:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b9a:	02098263          	beqz	s3,80000bbe <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b9e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ba2:	85ca                	mv	a1,s2
    80000ba4:	855a                	mv	a0,s6
    80000ba6:	00000097          	auipc	ra,0x0
    80000baa:	9aa080e7          	jalr	-1622(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000bae:	cd01                	beqz	a0,80000bc6 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bb0:	418904b3          	sub	s1,s2,s8
    80000bb4:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bb6:	fc99f3e3          	bgeu	s3,s1,80000b7c <copyout+0x28>
    80000bba:	84ce                	mv	s1,s3
    80000bbc:	b7c1                	j	80000b7c <copyout+0x28>
  }
  return 0;
    80000bbe:	4501                	li	a0,0
    80000bc0:	a021                	j	80000bc8 <copyout+0x74>
    80000bc2:	4501                	li	a0,0
}
    80000bc4:	8082                	ret
      return -1;
    80000bc6:	557d                	li	a0,-1
}
    80000bc8:	60a6                	ld	ra,72(sp)
    80000bca:	6406                	ld	s0,64(sp)
    80000bcc:	74e2                	ld	s1,56(sp)
    80000bce:	7942                	ld	s2,48(sp)
    80000bd0:	79a2                	ld	s3,40(sp)
    80000bd2:	7a02                	ld	s4,32(sp)
    80000bd4:	6ae2                	ld	s5,24(sp)
    80000bd6:	6b42                	ld	s6,16(sp)
    80000bd8:	6ba2                	ld	s7,8(sp)
    80000bda:	6c02                	ld	s8,0(sp)
    80000bdc:	6161                	addi	sp,sp,80
    80000bde:	8082                	ret

0000000080000be0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000be0:	c6bd                	beqz	a3,80000c4e <copyin+0x6e>
{
    80000be2:	715d                	addi	sp,sp,-80
    80000be4:	e486                	sd	ra,72(sp)
    80000be6:	e0a2                	sd	s0,64(sp)
    80000be8:	fc26                	sd	s1,56(sp)
    80000bea:	f84a                	sd	s2,48(sp)
    80000bec:	f44e                	sd	s3,40(sp)
    80000bee:	f052                	sd	s4,32(sp)
    80000bf0:	ec56                	sd	s5,24(sp)
    80000bf2:	e85a                	sd	s6,16(sp)
    80000bf4:	e45e                	sd	s7,8(sp)
    80000bf6:	e062                	sd	s8,0(sp)
    80000bf8:	0880                	addi	s0,sp,80
    80000bfa:	8b2a                	mv	s6,a0
    80000bfc:	8a2e                	mv	s4,a1
    80000bfe:	8c32                	mv	s8,a2
    80000c00:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c02:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c04:	6a85                	lui	s5,0x1
    80000c06:	a015                	j	80000c2a <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c08:	9562                	add	a0,a0,s8
    80000c0a:	0004861b          	sext.w	a2,s1
    80000c0e:	412505b3          	sub	a1,a0,s2
    80000c12:	8552                	mv	a0,s4
    80000c14:	fffff097          	auipc	ra,0xfffff
    80000c18:	60e080e7          	jalr	1550(ra) # 80000222 <memmove>

    len -= n;
    80000c1c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c20:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c22:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c26:	02098263          	beqz	s3,80000c4a <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c2a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c2e:	85ca                	mv	a1,s2
    80000c30:	855a                	mv	a0,s6
    80000c32:	00000097          	auipc	ra,0x0
    80000c36:	91e080e7          	jalr	-1762(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000c3a:	cd01                	beqz	a0,80000c52 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c3c:	418904b3          	sub	s1,s2,s8
    80000c40:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c42:	fc99f3e3          	bgeu	s3,s1,80000c08 <copyin+0x28>
    80000c46:	84ce                	mv	s1,s3
    80000c48:	b7c1                	j	80000c08 <copyin+0x28>
  }
  return 0;
    80000c4a:	4501                	li	a0,0
    80000c4c:	a021                	j	80000c54 <copyin+0x74>
    80000c4e:	4501                	li	a0,0
}
    80000c50:	8082                	ret
      return -1;
    80000c52:	557d                	li	a0,-1
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6c02                	ld	s8,0(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret

0000000080000c6c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c6c:	c6c5                	beqz	a3,80000d14 <copyinstr+0xa8>
{
    80000c6e:	715d                	addi	sp,sp,-80
    80000c70:	e486                	sd	ra,72(sp)
    80000c72:	e0a2                	sd	s0,64(sp)
    80000c74:	fc26                	sd	s1,56(sp)
    80000c76:	f84a                	sd	s2,48(sp)
    80000c78:	f44e                	sd	s3,40(sp)
    80000c7a:	f052                	sd	s4,32(sp)
    80000c7c:	ec56                	sd	s5,24(sp)
    80000c7e:	e85a                	sd	s6,16(sp)
    80000c80:	e45e                	sd	s7,8(sp)
    80000c82:	0880                	addi	s0,sp,80
    80000c84:	8a2a                	mv	s4,a0
    80000c86:	8b2e                	mv	s6,a1
    80000c88:	8bb2                	mv	s7,a2
    80000c8a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c8c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c8e:	6985                	lui	s3,0x1
    80000c90:	a035                	j	80000cbc <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c92:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c96:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c98:	0017b793          	seqz	a5,a5
    80000c9c:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ca0:	60a6                	ld	ra,72(sp)
    80000ca2:	6406                	ld	s0,64(sp)
    80000ca4:	74e2                	ld	s1,56(sp)
    80000ca6:	7942                	ld	s2,48(sp)
    80000ca8:	79a2                	ld	s3,40(sp)
    80000caa:	7a02                	ld	s4,32(sp)
    80000cac:	6ae2                	ld	s5,24(sp)
    80000cae:	6b42                	ld	s6,16(sp)
    80000cb0:	6ba2                	ld	s7,8(sp)
    80000cb2:	6161                	addi	sp,sp,80
    80000cb4:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cb6:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cba:	c8a9                	beqz	s1,80000d0c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cbc:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cc0:	85ca                	mv	a1,s2
    80000cc2:	8552                	mv	a0,s4
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	88c080e7          	jalr	-1908(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000ccc:	c131                	beqz	a0,80000d10 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000cce:	41790833          	sub	a6,s2,s7
    80000cd2:	984e                	add	a6,a6,s3
    if(n > max)
    80000cd4:	0104f363          	bgeu	s1,a6,80000cda <copyinstr+0x6e>
    80000cd8:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cda:	955e                	add	a0,a0,s7
    80000cdc:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ce0:	fc080be3          	beqz	a6,80000cb6 <copyinstr+0x4a>
    80000ce4:	985a                	add	a6,a6,s6
    80000ce6:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ce8:	41650633          	sub	a2,a0,s6
    80000cec:	14fd                	addi	s1,s1,-1
    80000cee:	9b26                	add	s6,s6,s1
    80000cf0:	00f60733          	add	a4,a2,a5
    80000cf4:	00074703          	lbu	a4,0(a4)
    80000cf8:	df49                	beqz	a4,80000c92 <copyinstr+0x26>
        *dst = *p;
    80000cfa:	00e78023          	sb	a4,0(a5)
      --max;
    80000cfe:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d02:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d04:	ff0796e3          	bne	a5,a6,80000cf0 <copyinstr+0x84>
      dst++;
    80000d08:	8b42                	mv	s6,a6
    80000d0a:	b775                	j	80000cb6 <copyinstr+0x4a>
    80000d0c:	4781                	li	a5,0
    80000d0e:	b769                	j	80000c98 <copyinstr+0x2c>
      return -1;
    80000d10:	557d                	li	a0,-1
    80000d12:	b779                	j	80000ca0 <copyinstr+0x34>
  int got_null = 0;
    80000d14:	4781                	li	a5,0
  if(got_null){
    80000d16:	0017b793          	seqz	a5,a5
    80000d1a:	40f00533          	neg	a0,a5
}
    80000d1e:	8082                	ret

0000000080000d20 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d20:	7139                	addi	sp,sp,-64
    80000d22:	fc06                	sd	ra,56(sp)
    80000d24:	f822                	sd	s0,48(sp)
    80000d26:	f426                	sd	s1,40(sp)
    80000d28:	f04a                	sd	s2,32(sp)
    80000d2a:	ec4e                	sd	s3,24(sp)
    80000d2c:	e852                	sd	s4,16(sp)
    80000d2e:	e456                	sd	s5,8(sp)
    80000d30:	e05a                	sd	s6,0(sp)
    80000d32:	0080                	addi	s0,sp,64
    80000d34:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d36:	00008497          	auipc	s1,0x8
    80000d3a:	74a48493          	addi	s1,s1,1866 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d3e:	8b26                	mv	s6,s1
    80000d40:	00007a97          	auipc	s5,0x7
    80000d44:	2c0a8a93          	addi	s5,s5,704 # 80008000 <etext>
    80000d48:	04000937          	lui	s2,0x4000
    80000d4c:	197d                	addi	s2,s2,-1
    80000d4e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d50:	0000ea17          	auipc	s4,0xe
    80000d54:	330a0a13          	addi	s4,s4,816 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000d58:	fffff097          	auipc	ra,0xfffff
    80000d5c:	3c0080e7          	jalr	960(ra) # 80000118 <kalloc>
    80000d60:	862a                	mv	a2,a0
    if(pa == 0)
    80000d62:	c131                	beqz	a0,80000da6 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d64:	416485b3          	sub	a1,s1,s6
    80000d68:	8591                	srai	a1,a1,0x4
    80000d6a:	000ab783          	ld	a5,0(s5)
    80000d6e:	02f585b3          	mul	a1,a1,a5
    80000d72:	2585                	addiw	a1,a1,1
    80000d74:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d78:	4719                	li	a4,6
    80000d7a:	6685                	lui	a3,0x1
    80000d7c:	40b905b3          	sub	a1,s2,a1
    80000d80:	854e                	mv	a0,s3
    80000d82:	00000097          	auipc	ra,0x0
    80000d86:	8b0080e7          	jalr	-1872(ra) # 80000632 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d8a:	17048493          	addi	s1,s1,368
    80000d8e:	fd4495e3          	bne	s1,s4,80000d58 <proc_mapstacks+0x38>
  }
}
    80000d92:	70e2                	ld	ra,56(sp)
    80000d94:	7442                	ld	s0,48(sp)
    80000d96:	74a2                	ld	s1,40(sp)
    80000d98:	7902                	ld	s2,32(sp)
    80000d9a:	69e2                	ld	s3,24(sp)
    80000d9c:	6a42                	ld	s4,16(sp)
    80000d9e:	6aa2                	ld	s5,8(sp)
    80000da0:	6b02                	ld	s6,0(sp)
    80000da2:	6121                	addi	sp,sp,64
    80000da4:	8082                	ret
      panic("kalloc");
    80000da6:	00007517          	auipc	a0,0x7
    80000daa:	3b250513          	addi	a0,a0,946 # 80008158 <etext+0x158>
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	eba080e7          	jalr	-326(ra) # 80005c68 <panic>

0000000080000db6 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000db6:	7139                	addi	sp,sp,-64
    80000db8:	fc06                	sd	ra,56(sp)
    80000dba:	f822                	sd	s0,48(sp)
    80000dbc:	f426                	sd	s1,40(sp)
    80000dbe:	f04a                	sd	s2,32(sp)
    80000dc0:	ec4e                	sd	s3,24(sp)
    80000dc2:	e852                	sd	s4,16(sp)
    80000dc4:	e456                	sd	s5,8(sp)
    80000dc6:	e05a                	sd	s6,0(sp)
    80000dc8:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dca:	00007597          	auipc	a1,0x7
    80000dce:	39658593          	addi	a1,a1,918 # 80008160 <etext+0x160>
    80000dd2:	00008517          	auipc	a0,0x8
    80000dd6:	27e50513          	addi	a0,a0,638 # 80009050 <pid_lock>
    80000dda:	00005097          	auipc	ra,0x5
    80000dde:	348080e7          	jalr	840(ra) # 80006122 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000de2:	00007597          	auipc	a1,0x7
    80000de6:	38658593          	addi	a1,a1,902 # 80008168 <etext+0x168>
    80000dea:	00008517          	auipc	a0,0x8
    80000dee:	27e50513          	addi	a0,a0,638 # 80009068 <wait_lock>
    80000df2:	00005097          	auipc	ra,0x5
    80000df6:	330080e7          	jalr	816(ra) # 80006122 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfa:	00008497          	auipc	s1,0x8
    80000dfe:	68648493          	addi	s1,s1,1670 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000e02:	00007b17          	auipc	s6,0x7
    80000e06:	376b0b13          	addi	s6,s6,886 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000e0a:	8aa6                	mv	s5,s1
    80000e0c:	00007a17          	auipc	s4,0x7
    80000e10:	1f4a0a13          	addi	s4,s4,500 # 80008000 <etext>
    80000e14:	04000937          	lui	s2,0x4000
    80000e18:	197d                	addi	s2,s2,-1
    80000e1a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e1c:	0000e997          	auipc	s3,0xe
    80000e20:	26498993          	addi	s3,s3,612 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000e24:	85da                	mv	a1,s6
    80000e26:	8526                	mv	a0,s1
    80000e28:	00005097          	auipc	ra,0x5
    80000e2c:	2fa080e7          	jalr	762(ra) # 80006122 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e30:	415487b3          	sub	a5,s1,s5
    80000e34:	8791                	srai	a5,a5,0x4
    80000e36:	000a3703          	ld	a4,0(s4)
    80000e3a:	02e787b3          	mul	a5,a5,a4
    80000e3e:	2785                	addiw	a5,a5,1
    80000e40:	00d7979b          	slliw	a5,a5,0xd
    80000e44:	40f907b3          	sub	a5,s2,a5
    80000e48:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e4a:	17048493          	addi	s1,s1,368
    80000e4e:	fd349be3          	bne	s1,s3,80000e24 <procinit+0x6e>
  }
}
    80000e52:	70e2                	ld	ra,56(sp)
    80000e54:	7442                	ld	s0,48(sp)
    80000e56:	74a2                	ld	s1,40(sp)
    80000e58:	7902                	ld	s2,32(sp)
    80000e5a:	69e2                	ld	s3,24(sp)
    80000e5c:	6a42                	ld	s4,16(sp)
    80000e5e:	6aa2                	ld	s5,8(sp)
    80000e60:	6b02                	ld	s6,0(sp)
    80000e62:	6121                	addi	sp,sp,64
    80000e64:	8082                	ret

0000000080000e66 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e66:	1141                	addi	sp,sp,-16
    80000e68:	e422                	sd	s0,8(sp)
    80000e6a:	0800                	addi	s0,sp,16
// read and write tp, the thread pointer, which holds
    80000e6c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e6e:	2501                	sext.w	a0,a0
    80000e70:	6422                	ld	s0,8(sp)
    80000e72:	0141                	addi	sp,sp,16
    80000e74:	8082                	ret

0000000080000e76 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e76:	1141                	addi	sp,sp,-16
    80000e78:	e422                	sd	s0,8(sp)
    80000e7a:	0800                	addi	s0,sp,16
    80000e7c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e7e:	2781                	sext.w	a5,a5
    80000e80:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e82:	00008517          	auipc	a0,0x8
    80000e86:	1fe50513          	addi	a0,a0,510 # 80009080 <cpus>
    80000e8a:	953e                	add	a0,a0,a5
    80000e8c:	6422                	ld	s0,8(sp)
    80000e8e:	0141                	addi	sp,sp,16
    80000e90:	8082                	ret

0000000080000e92 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e92:	1101                	addi	sp,sp,-32
    80000e94:	ec06                	sd	ra,24(sp)
    80000e96:	e822                	sd	s0,16(sp)
    80000e98:	e426                	sd	s1,8(sp)
    80000e9a:	1000                	addi	s0,sp,32
  push_off();
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	2ca080e7          	jalr	714(ra) # 80006166 <push_off>
    80000ea4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ea6:	2781                	sext.w	a5,a5
    80000ea8:	079e                	slli	a5,a5,0x7
    80000eaa:	00008717          	auipc	a4,0x8
    80000eae:	1a670713          	addi	a4,a4,422 # 80009050 <pid_lock>
    80000eb2:	97ba                	add	a5,a5,a4
    80000eb4:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eb6:	00005097          	auipc	ra,0x5
    80000eba:	350080e7          	jalr	848(ra) # 80006206 <pop_off>
  return p;
}
    80000ebe:	8526                	mv	a0,s1
    80000ec0:	60e2                	ld	ra,24(sp)
    80000ec2:	6442                	ld	s0,16(sp)
    80000ec4:	64a2                	ld	s1,8(sp)
    80000ec6:	6105                	addi	sp,sp,32
    80000ec8:	8082                	ret

0000000080000eca <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
    80000eca:	1141                	addi	sp,sp,-16
    80000ecc:	e406                	sd	ra,8(sp)
    80000ece:	e022                	sd	s0,0(sp)
    80000ed0:	0800                	addi	s0,sp,16
{
  static int first = 1;

  // Still holding p->lock from scheduler.
    80000ed2:	00000097          	auipc	ra,0x0
    80000ed6:	fc0080e7          	jalr	-64(ra) # 80000e92 <myproc>
    80000eda:	00005097          	auipc	ra,0x5
    80000ede:	38c080e7          	jalr	908(ra) # 80006266 <release>
  release(&myproc()->lock);

    80000ee2:	00008797          	auipc	a5,0x8
    80000ee6:	abe7a783          	lw	a5,-1346(a5) # 800089a0 <first.1678>
    80000eea:	eb89                	bnez	a5,80000efc <forkret+0x32>
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

    80000eec:	00001097          	auipc	ra,0x1
    80000ef0:	c40080e7          	jalr	-960(ra) # 80001b2c <usertrapret>
  usertrapret();
    80000ef4:	60a2                	ld	ra,8(sp)
    80000ef6:	6402                	ld	s0,0(sp)
    80000ef8:	0141                	addi	sp,sp,16
    80000efa:	8082                	ret
    // be run from main().
    80000efc:	00008797          	auipc	a5,0x8
    80000f00:	aa07a223          	sw	zero,-1372(a5) # 800089a0 <first.1678>
    first = 0;
    80000f04:	4505                	li	a0,1
    80000f06:	00002097          	auipc	ra,0x2
    80000f0a:	a3e080e7          	jalr	-1474(ra) # 80002944 <fsinit>
    80000f0e:	bff9                	j	80000eec <forkret+0x22>

0000000080000f10 <allocpid>:
allocpid() {
    80000f10:	1101                	addi	sp,sp,-32
    80000f12:	ec06                	sd	ra,24(sp)
    80000f14:	e822                	sd	s0,16(sp)
    80000f16:	e426                	sd	s1,8(sp)
    80000f18:	e04a                	sd	s2,0(sp)
    80000f1a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f1c:	00008917          	auipc	s2,0x8
    80000f20:	13490913          	addi	s2,s2,308 # 80009050 <pid_lock>
    80000f24:	854a                	mv	a0,s2
    80000f26:	00005097          	auipc	ra,0x5
    80000f2a:	28c080e7          	jalr	652(ra) # 800061b2 <acquire>
  pid = nextpid;
    80000f2e:	00008797          	auipc	a5,0x8
    80000f32:	a7678793          	addi	a5,a5,-1418 # 800089a4 <nextpid>
    80000f36:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f38:	0014871b          	addiw	a4,s1,1
    80000f3c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f3e:	854a                	mv	a0,s2
    80000f40:	00005097          	auipc	ra,0x5
    80000f44:	326080e7          	jalr	806(ra) # 80006266 <release>
}
    80000f48:	8526                	mv	a0,s1
    80000f4a:	60e2                	ld	ra,24(sp)
    80000f4c:	6442                	ld	s0,16(sp)
    80000f4e:	64a2                	ld	s1,8(sp)
    80000f50:	6902                	ld	s2,0(sp)
    80000f52:	6105                	addi	sp,sp,32
    80000f54:	8082                	ret

0000000080000f56 <proc_pagetable>:
// Create a user page table for a given process,
    80000f56:	1101                	addi	sp,sp,-32
    80000f58:	ec06                	sd	ra,24(sp)
    80000f5a:	e822                	sd	s0,16(sp)
    80000f5c:	e426                	sd	s1,8(sp)
    80000f5e:	e04a                	sd	s2,0(sp)
    80000f60:	1000                	addi	s0,sp,32
    80000f62:	892a                	mv	s2,a0
{
    80000f64:	00000097          	auipc	ra,0x0
    80000f68:	8b8080e7          	jalr	-1864(ra) # 8000081c <uvmcreate>
    80000f6c:	84aa                	mv	s1,a0
  pagetable_t pagetable;
    80000f6e:	c121                	beqz	a0,80000fae <proc_pagetable+0x58>
  // map the trampoline code (for system call return)
    80000f70:	4729                	li	a4,10
    80000f72:	00006697          	auipc	a3,0x6
    80000f76:	08e68693          	addi	a3,a3,142 # 80007000 <_trampoline>
    80000f7a:	6605                	lui	a2,0x1
    80000f7c:	040005b7          	lui	a1,0x4000
    80000f80:	15fd                	addi	a1,a1,-1
    80000f82:	05b2                	slli	a1,a1,0xc
    80000f84:	fffff097          	auipc	ra,0xfffff
    80000f88:	60e080e7          	jalr	1550(ra) # 80000592 <mappages>
    80000f8c:	02054863          	bltz	a0,80000fbc <proc_pagetable+0x66>
    return 0;
    80000f90:	4719                	li	a4,6
    80000f92:	06093683          	ld	a3,96(s2)
    80000f96:	6605                	lui	a2,0x1
    80000f98:	020005b7          	lui	a1,0x2000
    80000f9c:	15fd                	addi	a1,a1,-1
    80000f9e:	05b6                	slli	a1,a1,0xd
    80000fa0:	8526                	mv	a0,s1
    80000fa2:	fffff097          	auipc	ra,0xfffff
    80000fa6:	5f0080e7          	jalr	1520(ra) # 80000592 <mappages>
    80000faa:	02054163          	bltz	a0,80000fcc <proc_pagetable+0x76>
    return 0;
    80000fae:	8526                	mv	a0,s1
    80000fb0:	60e2                	ld	ra,24(sp)
    80000fb2:	6442                	ld	s0,16(sp)
    80000fb4:	64a2                	ld	s1,8(sp)
    80000fb6:	6902                	ld	s2,0(sp)
    80000fb8:	6105                	addi	sp,sp,32
    80000fba:	8082                	ret
  // only the supervisor uses it, on the way
    80000fbc:	4581                	li	a1,0
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	00000097          	auipc	ra,0x0
    80000fc4:	a58080e7          	jalr	-1448(ra) # 80000a18 <uvmfree>
  // to/from user space, so not PTE_U.
    80000fc8:	4481                	li	s1,0
    80000fca:	b7d5                	j	80000fae <proc_pagetable+0x58>

    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	040005b7          	lui	a1,0x4000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b2                	slli	a1,a1,0xc
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	77e080e7          	jalr	1918(ra) # 80000758 <uvmunmap>
  // map the trapframe just below TRAMPOLINE, for trampoline.S.
    80000fe2:	4581                	li	a1,0
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	a32080e7          	jalr	-1486(ra) # 80000a18 <uvmfree>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fee:	4481                	li	s1,0
    80000ff0:	bf7d                	j	80000fae <proc_pagetable+0x58>

0000000080000ff2 <proc_freepagetable>:
// Free a process's page table, and free the
    80000ff2:	1101                	addi	sp,sp,-32
    80000ff4:	ec06                	sd	ra,24(sp)
    80000ff6:	e822                	sd	s0,16(sp)
    80000ff8:	e426                	sd	s1,8(sp)
    80000ffa:	e04a                	sd	s2,0(sp)
    80000ffc:	1000                	addi	s0,sp,32
    80000ffe:	84aa                	mv	s1,a0
    80001000:	892e                	mv	s2,a1
// physical memory it refers to.
    80001002:	4681                	li	a3,0
    80001004:	4605                	li	a2,1
    80001006:	040005b7          	lui	a1,0x4000
    8000100a:	15fd                	addi	a1,a1,-1
    8000100c:	05b2                	slli	a1,a1,0xc
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	74a080e7          	jalr	1866(ra) # 80000758 <uvmunmap>
void
    80001016:	4681                	li	a3,0
    80001018:	4605                	li	a2,1
    8000101a:	020005b7          	lui	a1,0x2000
    8000101e:	15fd                	addi	a1,a1,-1
    80001020:	05b6                	slli	a1,a1,0xd
    80001022:	8526                	mv	a0,s1
    80001024:	fffff097          	auipc	ra,0xfffff
    80001028:	734080e7          	jalr	1844(ra) # 80000758 <uvmunmap>
proc_freepagetable(pagetable_t pagetable, uint64 sz)
    8000102c:	85ca                	mv	a1,s2
    8000102e:	8526                	mv	a0,s1
    80001030:	00000097          	auipc	ra,0x0
    80001034:	9e8080e7          	jalr	-1560(ra) # 80000a18 <uvmfree>
{
    80001038:	60e2                	ld	ra,24(sp)
    8000103a:	6442                	ld	s0,16(sp)
    8000103c:	64a2                	ld	s1,8(sp)
    8000103e:	6902                	ld	s2,0(sp)
    80001040:	6105                	addi	sp,sp,32
    80001042:	8082                	ret

0000000080001044 <freeproc>:
// including user pages.
    80001044:	1101                	addi	sp,sp,-32
    80001046:	ec06                	sd	ra,24(sp)
    80001048:	e822                	sd	s0,16(sp)
    8000104a:	e426                	sd	s1,8(sp)
    8000104c:	1000                	addi	s0,sp,32
    8000104e:	84aa                	mv	s1,a0
// p->lock must be held.
    80001050:	7128                	ld	a0,96(a0)
    80001052:	c509                	beqz	a0,8000105c <freeproc+0x18>
static void
    80001054:	fffff097          	auipc	ra,0xfffff
    80001058:	fc8080e7          	jalr	-56(ra) # 8000001c <kfree>
freeproc(struct proc *p)
    8000105c:	0604b023          	sd	zero,96(s1)
{
    80001060:	68a8                	ld	a0,80(s1)
    80001062:	c511                	beqz	a0,8000106e <freeproc+0x2a>
  if(p->trapframe)
    80001064:	64ac                	ld	a1,72(s1)
    80001066:	00000097          	auipc	ra,0x0
    8000106a:	f8c080e7          	jalr	-116(ra) # 80000ff2 <proc_freepagetable>
    kfree((void*)p->trapframe);
    8000106e:	0404b823          	sd	zero,80(s1)
  p->trapframe = 0;
    80001072:	0404b423          	sd	zero,72(s1)
  if(p->pagetable)
    80001076:	0204a823          	sw	zero,48(s1)
    proc_freepagetable(p->pagetable, p->sz);
    8000107a:	0204bc23          	sd	zero,56(s1)
  p->pagetable = 0;
    8000107e:	16048023          	sb	zero,352(s1)
  p->sz = 0;
    80001082:	0204b023          	sd	zero,32(s1)
  p->pid = 0;
    80001086:	0204a423          	sw	zero,40(s1)
  p->parent = 0;
    8000108a:	0204a623          	sw	zero,44(s1)
  p->name[0] = 0;
    8000108e:	0004ac23          	sw	zero,24(s1)
  p->chan = 0;
    80001092:	60e2                	ld	ra,24(sp)
    80001094:	6442                	ld	s0,16(sp)
    80001096:	64a2                	ld	s1,8(sp)
    80001098:	6105                	addi	sp,sp,32
    8000109a:	8082                	ret

000000008000109c <allocproc>:
{
    8000109c:	1101                	addi	sp,sp,-32
    8000109e:	ec06                	sd	ra,24(sp)
    800010a0:	e822                	sd	s0,16(sp)
    800010a2:	e426                	sd	s1,8(sp)
    800010a4:	e04a                	sd	s2,0(sp)
    800010a6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a8:	00008497          	auipc	s1,0x8
    800010ac:	3d848493          	addi	s1,s1,984 # 80009480 <proc>
    800010b0:	0000e917          	auipc	s2,0xe
    800010b4:	fd090913          	addi	s2,s2,-48 # 8000f080 <tickslock>
    acquire(&p->lock);
    800010b8:	8526                	mv	a0,s1
    800010ba:	00005097          	auipc	ra,0x5
    800010be:	0f8080e7          	jalr	248(ra) # 800061b2 <acquire>
    if(p->state == UNUSED) {
    800010c2:	4c9c                	lw	a5,24(s1)
    800010c4:	cf81                	beqz	a5,800010dc <allocproc+0x40>
      release(&p->lock);
    800010c6:	8526                	mv	a0,s1
    800010c8:	00005097          	auipc	ra,0x5
    800010cc:	19e080e7          	jalr	414(ra) # 80006266 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010d0:	17048493          	addi	s1,s1,368
    800010d4:	ff2492e3          	bne	s1,s2,800010b8 <allocproc+0x1c>
  return 0;
    800010d8:	4481                	li	s1,0
    800010da:	a889                	j	8000112c <allocproc+0x90>
  p->pid = allocpid();
    800010dc:	00000097          	auipc	ra,0x0
    800010e0:	e34080e7          	jalr	-460(ra) # 80000f10 <allocpid>
    800010e4:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010e6:	4785                	li	a5,1
    800010e8:	cc9c                	sw	a5,24(s1)
  p->handler = 0;
    800010ea:	fffff097          	auipc	ra,0xfffff
    800010ee:	02e080e7          	jalr	46(ra) # 80000118 <kalloc>
    800010f2:	892a                	mv	s2,a0
    800010f4:	f0a8                	sd	a0,96(s1)
    800010f6:	c131                	beqz	a0,8000113a <allocproc+0x9e>
    return 0;
    800010f8:	8526                	mv	a0,s1
    800010fa:	00000097          	auipc	ra,0x0
    800010fe:	e5c080e7          	jalr	-420(ra) # 80000f56 <proc_pagetable>
    80001102:	892a                	mv	s2,a0
    80001104:	e8a8                	sd	a0,80(s1)
  }
    80001106:	c531                	beqz	a0,80001152 <allocproc+0xb6>
  }
    80001108:	07000613          	li	a2,112
    8000110c:	4581                	li	a1,0
    8000110e:	06848513          	addi	a0,s1,104
    80001112:	fffff097          	auipc	ra,0xfffff
    80001116:	0b0080e7          	jalr	176(ra) # 800001c2 <memset>

    8000111a:	00000797          	auipc	a5,0x0
    8000111e:	db078793          	addi	a5,a5,-592 # 80000eca <forkret>
    80001122:	f4bc                	sd	a5,104(s1)
  // Set up new context to start executing at forkret,
    80001124:	60bc                	ld	a5,64(s1)
    80001126:	6705                	lui	a4,0x1
    80001128:	97ba                	add	a5,a5,a4
    8000112a:	f8bc                	sd	a5,112(s1)
  p->context.ra = (uint64)forkret;
    8000112c:	8526                	mv	a0,s1
    8000112e:	60e2                	ld	ra,24(sp)
    80001130:	6442                	ld	s0,16(sp)
    80001132:	64a2                	ld	s1,8(sp)
    80001134:	6902                	ld	s2,0(sp)
    80001136:	6105                	addi	sp,sp,32
    80001138:	8082                	ret
  p->handlerlock = 1;
    8000113a:	8526                	mv	a0,s1
    8000113c:	00000097          	auipc	ra,0x0
    80001140:	f08080e7          	jalr	-248(ra) # 80001044 <freeproc>

    80001144:	8526                	mv	a0,s1
    80001146:	00005097          	auipc	ra,0x5
    8000114a:	120080e7          	jalr	288(ra) # 80006266 <release>
  // Allocate a trapframe page.
    8000114e:	84ca                	mv	s1,s2
    80001150:	bff1                	j	8000112c <allocproc+0x90>

    80001152:	8526                	mv	a0,s1
    80001154:	00000097          	auipc	ra,0x0
    80001158:	ef0080e7          	jalr	-272(ra) # 80001044 <freeproc>
  // An empty user page table.
    8000115c:	8526                	mv	a0,s1
    8000115e:	00005097          	auipc	ra,0x5
    80001162:	108080e7          	jalr	264(ra) # 80006266 <release>
  p->pagetable = proc_pagetable(p);
    80001166:	84ca                	mv	s1,s2
    80001168:	b7d1                	j	8000112c <allocproc+0x90>

000000008000116a <userinit>:

    8000116a:	1101                	addi	sp,sp,-32
    8000116c:	ec06                	sd	ra,24(sp)
    8000116e:	e822                	sd	s0,16(sp)
    80001170:	e426                	sd	s1,8(sp)
    80001172:	1000                	addi	s0,sp,32
userinit(void)
    80001174:	00000097          	auipc	ra,0x0
    80001178:	f28080e7          	jalr	-216(ra) # 8000109c <allocproc>
    8000117c:	84aa                	mv	s1,a0
{
    8000117e:	00008797          	auipc	a5,0x8
    80001182:	e8a7b923          	sd	a0,-366(a5) # 80009010 <initproc>
  initproc = p;
    80001186:	03400613          	li	a2,52
    8000118a:	00008597          	auipc	a1,0x8
    8000118e:	82658593          	addi	a1,a1,-2010 # 800089b0 <initcode>
    80001192:	6928                	ld	a0,80(a0)
    80001194:	fffff097          	auipc	ra,0xfffff
    80001198:	6b6080e7          	jalr	1718(ra) # 8000084a <uvminit>
  
    8000119c:	6785                	lui	a5,0x1
    8000119e:	e4bc                	sd	a5,72(s1)
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800011a0:	70b8                	ld	a4,96(s1)
    800011a2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->sz = PGSIZE;
    800011a6:	70b8                	ld	a4,96(s1)
    800011a8:	fb1c                	sd	a5,48(a4)
  // prepare for the very first "return" from kernel to user.
    800011aa:	4641                	li	a2,16
    800011ac:	00007597          	auipc	a1,0x7
    800011b0:	fd458593          	addi	a1,a1,-44 # 80008180 <etext+0x180>
    800011b4:	16048513          	addi	a0,s1,352
    800011b8:	fffff097          	auipc	ra,0xfffff
    800011bc:	15c080e7          	jalr	348(ra) # 80000314 <safestrcpy>
  p->trapframe->epc = 0;      // user program counter
    800011c0:	00007517          	auipc	a0,0x7
    800011c4:	fd050513          	addi	a0,a0,-48 # 80008190 <etext+0x190>
    800011c8:	00002097          	auipc	ra,0x2
    800011cc:	1aa080e7          	jalr	426(ra) # 80003372 <namei>
    800011d0:	14a4bc23          	sd	a0,344(s1)

    800011d4:	478d                	li	a5,3
    800011d6:	cc9c                	sw	a5,24(s1)
  p->cwd = namei("/");
    800011d8:	8526                	mv	a0,s1
    800011da:	00005097          	auipc	ra,0x5
    800011de:	08c080e7          	jalr	140(ra) # 80006266 <release>

    800011e2:	60e2                	ld	ra,24(sp)
    800011e4:	6442                	ld	s0,16(sp)
    800011e6:	64a2                	ld	s1,8(sp)
    800011e8:	6105                	addi	sp,sp,32
    800011ea:	8082                	ret

00000000800011ec <growproc>:
// Grow or shrink user memory by n bytes.
    800011ec:	1101                	addi	sp,sp,-32
    800011ee:	ec06                	sd	ra,24(sp)
    800011f0:	e822                	sd	s0,16(sp)
    800011f2:	e426                	sd	s1,8(sp)
    800011f4:	e04a                	sd	s2,0(sp)
    800011f6:	1000                	addi	s0,sp,32
    800011f8:	84aa                	mv	s1,a0
int
    800011fa:	00000097          	auipc	ra,0x0
    800011fe:	c98080e7          	jalr	-872(ra) # 80000e92 <myproc>
    80001202:	892a                	mv	s2,a0
{
    80001204:	652c                	ld	a1,72(a0)
    80001206:	0005861b          	sext.w	a2,a1
  uint sz;
    8000120a:	00904f63          	bgtz	s1,80001228 <growproc+0x3c>
  if(n > 0){
    8000120e:	0204cc63          	bltz	s1,80001246 <growproc+0x5a>
    }
    80001212:	1602                	slli	a2,a2,0x20
    80001214:	9201                	srli	a2,a2,0x20
    80001216:	04c93423          	sd	a2,72(s2)
  } else if(n < 0){
    8000121a:	4501                	li	a0,0
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000121c:	60e2                	ld	ra,24(sp)
    8000121e:	6442                	ld	s0,16(sp)
    80001220:	64a2                	ld	s1,8(sp)
    80001222:	6902                	ld	s2,0(sp)
    80001224:	6105                	addi	sp,sp,32
    80001226:	8082                	ret
  struct proc *p = myproc();
    80001228:	9e25                	addw	a2,a2,s1
    8000122a:	1602                	slli	a2,a2,0x20
    8000122c:	9201                	srli	a2,a2,0x20
    8000122e:	1582                	slli	a1,a1,0x20
    80001230:	9181                	srli	a1,a1,0x20
    80001232:	6928                	ld	a0,80(a0)
    80001234:	fffff097          	auipc	ra,0xfffff
    80001238:	6d0080e7          	jalr	1744(ra) # 80000904 <uvmalloc>
    8000123c:	0005061b          	sext.w	a2,a0
    80001240:	fa69                	bnez	a2,80001212 <growproc+0x26>

    80001242:	557d                	li	a0,-1
    80001244:	bfe1                	j	8000121c <growproc+0x30>
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001246:	9e25                	addw	a2,a2,s1
    80001248:	1602                	slli	a2,a2,0x20
    8000124a:	9201                	srli	a2,a2,0x20
    8000124c:	1582                	slli	a1,a1,0x20
    8000124e:	9181                	srli	a1,a1,0x20
    80001250:	6928                	ld	a0,80(a0)
    80001252:	fffff097          	auipc	ra,0xfffff
    80001256:	66a080e7          	jalr	1642(ra) # 800008bc <uvmdealloc>
    8000125a:	0005061b          	sext.w	a2,a0
    8000125e:	bf55                	j	80001212 <growproc+0x26>

0000000080001260 <fork>:
// Create a new process, copying the parent.
    80001260:	7179                	addi	sp,sp,-48
    80001262:	f406                	sd	ra,40(sp)
    80001264:	f022                	sd	s0,32(sp)
    80001266:	ec26                	sd	s1,24(sp)
    80001268:	e84a                	sd	s2,16(sp)
    8000126a:	e44e                	sd	s3,8(sp)
    8000126c:	e052                	sd	s4,0(sp)
    8000126e:	1800                	addi	s0,sp,48
fork(void)
    80001270:	00000097          	auipc	ra,0x0
    80001274:	c22080e7          	jalr	-990(ra) # 80000e92 <myproc>
    80001278:	892a                	mv	s2,a0
  struct proc *np;
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	e22080e7          	jalr	-478(ra) # 8000109c <allocproc>
    80001282:	10050f63          	beqz	a0,800013a0 <fork+0x140>
    80001286:	89aa                	mv	s3,a0
    return -1;
    80001288:	04893603          	ld	a2,72(s2)
    8000128c:	692c                	ld	a1,80(a0)
    8000128e:	05093503          	ld	a0,80(s2)
    80001292:	fffff097          	auipc	ra,0xfffff
    80001296:	7be080e7          	jalr	1982(ra) # 80000a50 <uvmcopy>
    8000129a:	04054a63          	bltz	a0,800012ee <fork+0x8e>
    freeproc(np);
    8000129e:	04893783          	ld	a5,72(s2)
    800012a2:	04f9b423          	sd	a5,72(s3)
  }
    800012a6:	06093683          	ld	a3,96(s2)
    800012aa:	87b6                	mv	a5,a3
    800012ac:	0609b703          	ld	a4,96(s3)
    800012b0:	12068693          	addi	a3,a3,288
    800012b4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012b8:	6788                	ld	a0,8(a5)
    800012ba:	6b8c                	ld	a1,16(a5)
    800012bc:	6f90                	ld	a2,24(a5)
    800012be:	01073023          	sd	a6,0(a4)
    800012c2:	e708                	sd	a0,8(a4)
    800012c4:	eb0c                	sd	a1,16(a4)
    800012c6:	ef10                	sd	a2,24(a4)
    800012c8:	02078793          	addi	a5,a5,32
    800012cc:	02070713          	addi	a4,a4,32
    800012d0:	fed792e3          	bne	a5,a3,800012b4 <fork+0x54>
  // copy saved user registers.
    800012d4:	05892783          	lw	a5,88(s2)
    800012d8:	04f9ac23          	sw	a5,88(s3)
  // Cause fork to return 0 in the child.
    800012dc:	0609b783          	ld	a5,96(s3)
    800012e0:	0607b823          	sd	zero,112(a5)
    800012e4:	0d800493          	li	s1,216
  // increment reference counts on open file descriptors.
    800012e8:	15800a13          	li	s4,344
    800012ec:	a03d                	j	8000131a <fork+0xba>
  }
    800012ee:	854e                	mv	a0,s3
    800012f0:	00000097          	auipc	ra,0x0
    800012f4:	d54080e7          	jalr	-684(ra) # 80001044 <freeproc>

    800012f8:	854e                	mv	a0,s3
    800012fa:	00005097          	auipc	ra,0x5
    800012fe:	f6c080e7          	jalr	-148(ra) # 80006266 <release>
  // Copy user memory from parent to child.
    80001302:	5a7d                	li	s4,-1
    80001304:	a069                	j	8000138e <fork+0x12e>
    if(p->ofile[i])
    80001306:	00002097          	auipc	ra,0x2
    8000130a:	702080e7          	jalr	1794(ra) # 80003a08 <filedup>
    8000130e:	009987b3          	add	a5,s3,s1
    80001312:	e388                	sd	a0,0(a5)
  // increment reference counts on open file descriptors.
    80001314:	04a1                	addi	s1,s1,8
    80001316:	01448763          	beq	s1,s4,80001324 <fork+0xc4>
  for(i = 0; i < NOFILE; i++)
    8000131a:	009907b3          	add	a5,s2,s1
    8000131e:	6388                	ld	a0,0(a5)
    80001320:	f17d                	bnez	a0,80001306 <fork+0xa6>
    80001322:	bfcd                	j	80001314 <fork+0xb4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001324:	15893503          	ld	a0,344(s2)
    80001328:	00002097          	auipc	ra,0x2
    8000132c:	856080e7          	jalr	-1962(ra) # 80002b7e <idup>
    80001330:	14a9bc23          	sd	a0,344(s3)

    80001334:	4641                	li	a2,16
    80001336:	16090593          	addi	a1,s2,352
    8000133a:	16098513          	addi	a0,s3,352
    8000133e:	fffff097          	auipc	ra,0xfffff
    80001342:	fd6080e7          	jalr	-42(ra) # 80000314 <safestrcpy>

    80001346:	0309aa03          	lw	s4,48(s3)

    8000134a:	854e                	mv	a0,s3
    8000134c:	00005097          	auipc	ra,0x5
    80001350:	f1a080e7          	jalr	-230(ra) # 80006266 <release>

    80001354:	00008497          	auipc	s1,0x8
    80001358:	d1448493          	addi	s1,s1,-748 # 80009068 <wait_lock>
    8000135c:	8526                	mv	a0,s1
    8000135e:	00005097          	auipc	ra,0x5
    80001362:	e54080e7          	jalr	-428(ra) # 800061b2 <acquire>
  acquire(&wait_lock);
    80001366:	0329bc23          	sd	s2,56(s3)
  np->parent = p;
    8000136a:	8526                	mv	a0,s1
    8000136c:	00005097          	auipc	ra,0x5
    80001370:	efa080e7          	jalr	-262(ra) # 80006266 <release>

    80001374:	854e                	mv	a0,s3
    80001376:	00005097          	auipc	ra,0x5
    8000137a:	e3c080e7          	jalr	-452(ra) # 800061b2 <acquire>
  acquire(&np->lock);
    8000137e:	478d                	li	a5,3
    80001380:	00f9ac23          	sw	a5,24(s3)
  np->state = RUNNABLE;
    80001384:	854e                	mv	a0,s3
    80001386:	00005097          	auipc	ra,0x5
    8000138a:	ee0080e7          	jalr	-288(ra) # 80006266 <release>
  return pid;
    8000138e:	8552                	mv	a0,s4
    80001390:	70a2                	ld	ra,40(sp)
    80001392:	7402                	ld	s0,32(sp)
    80001394:	64e2                	ld	s1,24(sp)
    80001396:	6942                	ld	s2,16(sp)
    80001398:	69a2                	ld	s3,8(sp)
    8000139a:	6a02                	ld	s4,0(sp)
    8000139c:	6145                	addi	sp,sp,48
    8000139e:	8082                	ret
  struct proc *p = myproc();
    800013a0:	5a7d                	li	s4,-1
    800013a2:	b7f5                	j	8000138e <fork+0x12e>

00000000800013a4 <scheduler>:
scheduler(void)
    800013a4:	7139                	addi	sp,sp,-64
    800013a6:	fc06                	sd	ra,56(sp)
    800013a8:	f822                	sd	s0,48(sp)
    800013aa:	f426                	sd	s1,40(sp)
    800013ac:	f04a                	sd	s2,32(sp)
    800013ae:	ec4e                	sd	s3,24(sp)
    800013b0:	e852                	sd	s4,16(sp)
    800013b2:	e456                	sd	s5,8(sp)
    800013b4:	e05a                	sd	s6,0(sp)
    800013b6:	0080                	addi	s0,sp,64
    800013b8:	8792                	mv	a5,tp
  int id = r_tp();
    800013ba:	2781                	sext.w	a5,a5
  
    800013bc:	00779a93          	slli	s5,a5,0x7
    800013c0:	00008717          	auipc	a4,0x8
    800013c4:	c9070713          	addi	a4,a4,-880 # 80009050 <pid_lock>
    800013c8:	9756                	add	a4,a4,s5
    800013ca:	02073823          	sd	zero,48(a4)
        c->proc = p;
    800013ce:	00008717          	auipc	a4,0x8
    800013d2:	cba70713          	addi	a4,a4,-838 # 80009088 <cpus+0x8>
    800013d6:	9aba                	add	s5,s5,a4
      acquire(&p->lock);
    800013d8:	498d                	li	s3,3
        // before jumping back to us.
    800013da:	4b11                	li	s6,4
        p->state = RUNNING;
    800013dc:	079e                	slli	a5,a5,0x7
    800013de:	00008a17          	auipc	s4,0x8
    800013e2:	c72a0a13          	addi	s4,s4,-910 # 80009050 <pid_lock>
    800013e6:	9a3e                	add	s4,s4,a5

    800013e8:	0000e917          	auipc	s2,0xe
    800013ec:	c9890913          	addi	s2,s2,-872 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f0:	100027f3          	csrr	a5,sstatus
}
    800013f4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013f8:	10079073          	csrw	sstatus,a5
    800013fc:	00008497          	auipc	s1,0x8
    80001400:	08448493          	addi	s1,s1,132 # 80009480 <proc>
    80001404:	a03d                	j	80001432 <scheduler+0x8e>
        // before jumping back to us.
    80001406:	0164ac23          	sw	s6,24(s1)
        p->state = RUNNING;
    8000140a:	029a3823          	sd	s1,48(s4)
        c->proc = p;
    8000140e:	06848593          	addi	a1,s1,104
    80001412:	8556                	mv	a0,s5
    80001414:	00000097          	auipc	ra,0x0
    80001418:	66e080e7          	jalr	1646(ra) # 80001a82 <swtch>
        // It should have changed its p->state before coming back.
    8000141c:	020a3823          	sd	zero,48(s4)
      }
    80001420:	8526                	mv	a0,s1
    80001422:	00005097          	auipc	ra,0x5
    80001426:	e44080e7          	jalr	-444(ra) # 80006266 <release>

    8000142a:	17048493          	addi	s1,s1,368
    8000142e:	fd2481e3          	beq	s1,s2,800013f0 <scheduler+0x4c>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001432:	8526                	mv	a0,s1
    80001434:	00005097          	auipc	ra,0x5
    80001438:	d7e080e7          	jalr	-642(ra) # 800061b2 <acquire>
      acquire(&p->lock);
    8000143c:	4c9c                	lw	a5,24(s1)
    8000143e:	ff3791e3          	bne	a5,s3,80001420 <scheduler+0x7c>
    80001442:	b7d1                	j	80001406 <scheduler+0x62>

0000000080001444 <sched>:
sched(void)
    80001444:	7179                	addi	sp,sp,-48
    80001446:	f406                	sd	ra,40(sp)
    80001448:	f022                	sd	s0,32(sp)
    8000144a:	ec26                	sd	s1,24(sp)
    8000144c:	e84a                	sd	s2,16(sp)
    8000144e:	e44e                	sd	s3,8(sp)
    80001450:	1800                	addi	s0,sp,48
  int intena;
    80001452:	00000097          	auipc	ra,0x0
    80001456:	a40080e7          	jalr	-1472(ra) # 80000e92 <myproc>
    8000145a:	84aa                	mv	s1,a0

    8000145c:	00005097          	auipc	ra,0x5
    80001460:	cdc080e7          	jalr	-804(ra) # 80006138 <holding>
    80001464:	c93d                	beqz	a0,800014da <sched+0x96>
// read and write tp, the thread pointer, which holds
    80001466:	8792                	mv	a5,tp
    panic("sched p->lock");
    80001468:	2781                	sext.w	a5,a5
    8000146a:	079e                	slli	a5,a5,0x7
    8000146c:	00008717          	auipc	a4,0x8
    80001470:	be470713          	addi	a4,a4,-1052 # 80009050 <pid_lock>
    80001474:	97ba                	add	a5,a5,a4
    80001476:	0a87a703          	lw	a4,168(a5)
    8000147a:	4785                	li	a5,1
    8000147c:	06f71763          	bne	a4,a5,800014ea <sched+0xa6>
    panic("sched locks");
    80001480:	4c98                	lw	a4,24(s1)
    80001482:	4791                	li	a5,4
    80001484:	06f70b63          	beq	a4,a5,800014fa <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001488:	100027f3          	csrr	a5,sstatus

    8000148c:	8b89                	andi	a5,a5,2
    panic("sched running");
    8000148e:	efb5                	bnez	a5,8000150a <sched+0xc6>
// read and write tp, the thread pointer, which holds
    80001490:	8792                	mv	a5,tp

    80001492:	00008917          	auipc	s2,0x8
    80001496:	bbe90913          	addi	s2,s2,-1090 # 80009050 <pid_lock>
    8000149a:	2781                	sext.w	a5,a5
    8000149c:	079e                	slli	a5,a5,0x7
    8000149e:	97ca                	add	a5,a5,s2
    800014a0:	0ac7a983          	lw	s3,172(a5)
    800014a4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014a6:	2781                	sext.w	a5,a5
    800014a8:	079e                	slli	a5,a5,0x7
    800014aa:	00008597          	auipc	a1,0x8
    800014ae:	bde58593          	addi	a1,a1,-1058 # 80009088 <cpus+0x8>
    800014b2:	95be                	add	a1,a1,a5
    800014b4:	06848513          	addi	a0,s1,104
    800014b8:	00000097          	auipc	ra,0x0
    800014bc:	5ca080e7          	jalr	1482(ra) # 80001a82 <swtch>
    800014c0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014c2:	2781                	sext.w	a5,a5
    800014c4:	079e                	slli	a5,a5,0x7
    800014c6:	97ca                	add	a5,a5,s2
    800014c8:	0b37a623          	sw	s3,172(a5)
  mycpu()->intena = intena;
    800014cc:	70a2                	ld	ra,40(sp)
    800014ce:	7402                	ld	s0,32(sp)
    800014d0:	64e2                	ld	s1,24(sp)
    800014d2:	6942                	ld	s2,16(sp)
    800014d4:	69a2                	ld	s3,8(sp)
    800014d6:	6145                	addi	sp,sp,48
    800014d8:	8082                	ret
  if(!holding(&p->lock))
    800014da:	00007517          	auipc	a0,0x7
    800014de:	cbe50513          	addi	a0,a0,-834 # 80008198 <etext+0x198>
    800014e2:	00004097          	auipc	ra,0x4
    800014e6:	786080e7          	jalr	1926(ra) # 80005c68 <panic>
  if(mycpu()->noff != 1)
    800014ea:	00007517          	auipc	a0,0x7
    800014ee:	cbe50513          	addi	a0,a0,-834 # 800081a8 <etext+0x1a8>
    800014f2:	00004097          	auipc	ra,0x4
    800014f6:	776080e7          	jalr	1910(ra) # 80005c68 <panic>
  if(p->state == RUNNING)
    800014fa:	00007517          	auipc	a0,0x7
    800014fe:	cbe50513          	addi	a0,a0,-834 # 800081b8 <etext+0x1b8>
    80001502:	00004097          	auipc	ra,0x4
    80001506:	766080e7          	jalr	1894(ra) # 80005c68 <panic>
  if(intr_get())
    8000150a:	00007517          	auipc	a0,0x7
    8000150e:	cbe50513          	addi	a0,a0,-834 # 800081c8 <etext+0x1c8>
    80001512:	00004097          	auipc	ra,0x4
    80001516:	756080e7          	jalr	1878(ra) # 80005c68 <panic>

000000008000151a <yield>:
yield(void)
    8000151a:	1101                	addi	sp,sp,-32
    8000151c:	ec06                	sd	ra,24(sp)
    8000151e:	e822                	sd	s0,16(sp)
    80001520:	e426                	sd	s1,8(sp)
    80001522:	1000                	addi	s0,sp,32
{
    80001524:	00000097          	auipc	ra,0x0
    80001528:	96e080e7          	jalr	-1682(ra) # 80000e92 <myproc>
    8000152c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	c84080e7          	jalr	-892(ra) # 800061b2 <acquire>
  acquire(&p->lock);
    80001536:	478d                	li	a5,3
    80001538:	cc9c                	sw	a5,24(s1)
  p->state = RUNNABLE;
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	f0a080e7          	jalr	-246(ra) # 80001444 <sched>
  sched();
    80001542:	8526                	mv	a0,s1
    80001544:	00005097          	auipc	ra,0x5
    80001548:	d22080e7          	jalr	-734(ra) # 80006266 <release>
  release(&p->lock);
    8000154c:	60e2                	ld	ra,24(sp)
    8000154e:	6442                	ld	s0,16(sp)
    80001550:	64a2                	ld	s1,8(sp)
    80001552:	6105                	addi	sp,sp,32
    80001554:	8082                	ret

0000000080001556 <sleep>:
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
    80001556:	7179                	addi	sp,sp,-48
    80001558:	f406                	sd	ra,40(sp)
    8000155a:	f022                	sd	s0,32(sp)
    8000155c:	ec26                	sd	s1,24(sp)
    8000155e:	e84a                	sd	s2,16(sp)
    80001560:	e44e                	sd	s3,8(sp)
    80001562:	1800                	addi	s0,sp,48
    80001564:	89aa                	mv	s3,a0
    80001566:	892e                	mv	s2,a1
{
    80001568:	00000097          	auipc	ra,0x0
    8000156c:	92a080e7          	jalr	-1750(ra) # 80000e92 <myproc>
    80001570:	84aa                	mv	s1,a0
  // change p->state and then call sched.
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

    80001572:	00005097          	auipc	ra,0x5
    80001576:	c40080e7          	jalr	-960(ra) # 800061b2 <acquire>
  acquire(&p->lock);  //DOC: sleeplock1
    8000157a:	854a                	mv	a0,s2
    8000157c:	00005097          	auipc	ra,0x5
    80001580:	cea080e7          	jalr	-790(ra) # 80006266 <release>
  release(lk);

  // Go to sleep.
    80001584:	0334b023          	sd	s3,32(s1)
  p->chan = chan;
    80001588:	4789                	li	a5,2
    8000158a:	cc9c                	sw	a5,24(s1)
  p->state = SLEEPING;

    8000158c:	00000097          	auipc	ra,0x0
    80001590:	eb8080e7          	jalr	-328(ra) # 80001444 <sched>
  sched();

  // Tidy up.
    80001594:	0204b023          	sd	zero,32(s1)
  p->chan = 0;

  // Reacquire original lock.
    80001598:	8526                	mv	a0,s1
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	ccc080e7          	jalr	-820(ra) # 80006266 <release>
  release(&p->lock);
    800015a2:	854a                	mv	a0,s2
    800015a4:	00005097          	auipc	ra,0x5
    800015a8:	c0e080e7          	jalr	-1010(ra) # 800061b2 <acquire>
  acquire(lk);
    800015ac:	70a2                	ld	ra,40(sp)
    800015ae:	7402                	ld	s0,32(sp)
    800015b0:	64e2                	ld	s1,24(sp)
    800015b2:	6942                	ld	s2,16(sp)
    800015b4:	69a2                	ld	s3,8(sp)
    800015b6:	6145                	addi	sp,sp,48
    800015b8:	8082                	ret

00000000800015ba <wait>:
wait(uint64 addr)
    800015ba:	715d                	addi	sp,sp,-80
    800015bc:	e486                	sd	ra,72(sp)
    800015be:	e0a2                	sd	s0,64(sp)
    800015c0:	fc26                	sd	s1,56(sp)
    800015c2:	f84a                	sd	s2,48(sp)
    800015c4:	f44e                	sd	s3,40(sp)
    800015c6:	f052                	sd	s4,32(sp)
    800015c8:	ec56                	sd	s5,24(sp)
    800015ca:	e85a                	sd	s6,16(sp)
    800015cc:	e45e                	sd	s7,8(sp)
    800015ce:	e062                	sd	s8,0(sp)
    800015d0:	0880                	addi	s0,sp,80
    800015d2:	8b2a                	mv	s6,a0
  int havekids, pid;
    800015d4:	00000097          	auipc	ra,0x0
    800015d8:	8be080e7          	jalr	-1858(ra) # 80000e92 <myproc>
    800015dc:	892a                	mv	s2,a0

    800015de:	00008517          	auipc	a0,0x8
    800015e2:	a8a50513          	addi	a0,a0,-1398 # 80009068 <wait_lock>
    800015e6:	00005097          	auipc	ra,0x5
    800015ea:	bcc080e7          	jalr	-1076(ra) # 800061b2 <acquire>
    // Scan through table looking for exited children.
    800015ee:	4b81                	li	s7,0
        havekids = 1;
    800015f0:	4a15                	li	s4,5
    havekids = 0;
    800015f2:	0000e997          	auipc	s3,0xe
    800015f6:	a8e98993          	addi	s3,s3,-1394 # 8000f080 <tickslock>

    800015fa:	4a85                	li	s5,1
    // Wait for a child to exit.
    800015fc:	00008c17          	auipc	s8,0x8
    80001600:	a6cc0c13          	addi	s8,s8,-1428 # 80009068 <wait_lock>
    // Scan through table looking for exited children.
    80001604:	875e                	mv	a4,s7
    havekids = 0;
    80001606:	00008497          	auipc	s1,0x8
    8000160a:	e7a48493          	addi	s1,s1,-390 # 80009480 <proc>
    8000160e:	a0bd                	j	8000167c <wait+0xc2>
          // Found one.
    80001610:	0304a983          	lw	s3,48(s1)
          pid = np->pid;
    80001614:	000b0e63          	beqz	s6,80001630 <wait+0x76>
    80001618:	4691                	li	a3,4
    8000161a:	02c48613          	addi	a2,s1,44
    8000161e:	85da                	mv	a1,s6
    80001620:	05093503          	ld	a0,80(s2)
    80001624:	fffff097          	auipc	ra,0xfffff
    80001628:	530080e7          	jalr	1328(ra) # 80000b54 <copyout>
    8000162c:	02054563          	bltz	a0,80001656 <wait+0x9c>
          }
    80001630:	8526                	mv	a0,s1
    80001632:	00000097          	auipc	ra,0x0
    80001636:	a12080e7          	jalr	-1518(ra) # 80001044 <freeproc>
          freeproc(np);
    8000163a:	8526                	mv	a0,s1
    8000163c:	00005097          	auipc	ra,0x5
    80001640:	c2a080e7          	jalr	-982(ra) # 80006266 <release>
          release(&np->lock);
    80001644:	00008517          	auipc	a0,0x8
    80001648:	a2450513          	addi	a0,a0,-1500 # 80009068 <wait_lock>
    8000164c:	00005097          	auipc	ra,0x5
    80001650:	c1a080e7          	jalr	-998(ra) # 80006266 <release>
          release(&wait_lock);
    80001654:	a09d                	j	800016ba <wait+0x100>
                                  sizeof(np->xstate)) < 0) {
    80001656:	8526                	mv	a0,s1
    80001658:	00005097          	auipc	ra,0x5
    8000165c:	c0e080e7          	jalr	-1010(ra) # 80006266 <release>
            release(&np->lock);
    80001660:	00008517          	auipc	a0,0x8
    80001664:	a0850513          	addi	a0,a0,-1528 # 80009068 <wait_lock>
    80001668:	00005097          	auipc	ra,0x5
    8000166c:	bfe080e7          	jalr	-1026(ra) # 80006266 <release>
            release(&wait_lock);
    80001670:	59fd                	li	s3,-1
    80001672:	a0a1                	j	800016ba <wait+0x100>
    havekids = 0;
    80001674:	17048493          	addi	s1,s1,368
    80001678:	03348463          	beq	s1,s3,800016a0 <wait+0xe6>
    for(np = proc; np < &proc[NPROC]; np++){
    8000167c:	7c9c                	ld	a5,56(s1)
    8000167e:	ff279be3          	bne	a5,s2,80001674 <wait+0xba>
        // make sure the child isn't still in exit() or swtch().
    80001682:	8526                	mv	a0,s1
    80001684:	00005097          	auipc	ra,0x5
    80001688:	b2e080e7          	jalr	-1234(ra) # 800061b2 <acquire>
        havekids = 1;
    8000168c:	4c9c                	lw	a5,24(s1)
    8000168e:	f94781e3          	beq	a5,s4,80001610 <wait+0x56>
        }
    80001692:	8526                	mv	a0,s1
    80001694:	00005097          	auipc	ra,0x5
    80001698:	bd2080e7          	jalr	-1070(ra) # 80006266 <release>

    8000169c:	8756                	mv	a4,s5
    8000169e:	bfd9                	j	80001674 <wait+0xba>
    // No point waiting if we don't have any children.
    800016a0:	c701                	beqz	a4,800016a8 <wait+0xee>
    800016a2:	02892783          	lw	a5,40(s2)
    800016a6:	c79d                	beqz	a5,800016d4 <wait+0x11a>
    if(!havekids || p->killed){
    800016a8:	00008517          	auipc	a0,0x8
    800016ac:	9c050513          	addi	a0,a0,-1600 # 80009068 <wait_lock>
    800016b0:	00005097          	auipc	ra,0x5
    800016b4:	bb6080e7          	jalr	-1098(ra) # 80006266 <release>
      release(&wait_lock);
    800016b8:	59fd                	li	s3,-1
  }
    800016ba:	854e                	mv	a0,s3
    800016bc:	60a6                	ld	ra,72(sp)
    800016be:	6406                	ld	s0,64(sp)
    800016c0:	74e2                	ld	s1,56(sp)
    800016c2:	7942                	ld	s2,48(sp)
    800016c4:	79a2                	ld	s3,40(sp)
    800016c6:	7a02                	ld	s4,32(sp)
    800016c8:	6ae2                	ld	s5,24(sp)
    800016ca:	6b42                	ld	s6,16(sp)
    800016cc:	6ba2                	ld	s7,8(sp)
    800016ce:	6c02                	ld	s8,0(sp)
    800016d0:	6161                	addi	sp,sp,80
    800016d2:	8082                	ret
    // Wait for a child to exit.
    800016d4:	85e2                	mv	a1,s8
    800016d6:	854a                	mv	a0,s2
    800016d8:	00000097          	auipc	ra,0x0
    800016dc:	e7e080e7          	jalr	-386(ra) # 80001556 <sleep>
    // Scan through table looking for exited children.
    800016e0:	b715                	j	80001604 <wait+0x4a>

00000000800016e2 <wakeup>:
}

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
    800016e2:	7139                	addi	sp,sp,-64
    800016e4:	fc06                	sd	ra,56(sp)
    800016e6:	f822                	sd	s0,48(sp)
    800016e8:	f426                	sd	s1,40(sp)
    800016ea:	f04a                	sd	s2,32(sp)
    800016ec:	ec4e                	sd	s3,24(sp)
    800016ee:	e852                	sd	s4,16(sp)
    800016f0:	e456                	sd	s5,8(sp)
    800016f2:	0080                	addi	s0,sp,64
    800016f4:	8a2a                	mv	s4,a0
{
  struct proc *p;

    800016f6:	00008497          	auipc	s1,0x8
    800016fa:	d8a48493          	addi	s1,s1,-630 # 80009480 <proc>
  for(p = proc; p < &proc[NPROC]; p++) {
    if(p != myproc()){
      acquire(&p->lock);
    800016fe:	4989                	li	s3,2
      if(p->state == SLEEPING && p->chan == chan) {
    80001700:	4a8d                	li	s5,3

    80001702:	0000e917          	auipc	s2,0xe
    80001706:	97e90913          	addi	s2,s2,-1666 # 8000f080 <tickslock>
    8000170a:	a821                	j	80001722 <wakeup+0x40>
      if(p->state == SLEEPING && p->chan == chan) {
    8000170c:	0154ac23          	sw	s5,24(s1)
        p->state = RUNNABLE;
      }
    80001710:	8526                	mv	a0,s1
    80001712:	00005097          	auipc	ra,0x5
    80001716:	b54080e7          	jalr	-1196(ra) # 80006266 <release>

    8000171a:	17048493          	addi	s1,s1,368
    8000171e:	03248463          	beq	s1,s2,80001746 <wakeup+0x64>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001722:	fffff097          	auipc	ra,0xfffff
    80001726:	770080e7          	jalr	1904(ra) # 80000e92 <myproc>
    8000172a:	fea488e3          	beq	s1,a0,8000171a <wakeup+0x38>
    if(p != myproc()){
    8000172e:	8526                	mv	a0,s1
    80001730:	00005097          	auipc	ra,0x5
    80001734:	a82080e7          	jalr	-1406(ra) # 800061b2 <acquire>
      acquire(&p->lock);
    80001738:	4c9c                	lw	a5,24(s1)
    8000173a:	fd379be3          	bne	a5,s3,80001710 <wakeup+0x2e>
    8000173e:	709c                	ld	a5,32(s1)
    80001740:	fd4798e3          	bne	a5,s4,80001710 <wakeup+0x2e>
    80001744:	b7e1                	j	8000170c <wakeup+0x2a>
      release(&p->lock);
    }
  }
    80001746:	70e2                	ld	ra,56(sp)
    80001748:	7442                	ld	s0,48(sp)
    8000174a:	74a2                	ld	s1,40(sp)
    8000174c:	7902                	ld	s2,32(sp)
    8000174e:	69e2                	ld	s3,24(sp)
    80001750:	6a42                	ld	s4,16(sp)
    80001752:	6aa2                	ld	s5,8(sp)
    80001754:	6121                	addi	sp,sp,64
    80001756:	8082                	ret

0000000080001758 <reparent>:
reparent(struct proc *p)
    80001758:	7179                	addi	sp,sp,-48
    8000175a:	f406                	sd	ra,40(sp)
    8000175c:	f022                	sd	s0,32(sp)
    8000175e:	ec26                	sd	s1,24(sp)
    80001760:	e84a                	sd	s2,16(sp)
    80001762:	e44e                	sd	s3,8(sp)
    80001764:	e052                	sd	s4,0(sp)
    80001766:	1800                	addi	s0,sp,48
    80001768:	892a                	mv	s2,a0

    8000176a:	00008497          	auipc	s1,0x8
    8000176e:	d1648493          	addi	s1,s1,-746 # 80009480 <proc>
    if(pp->parent == p){
    80001772:	00008a17          	auipc	s4,0x8
    80001776:	89ea0a13          	addi	s4,s4,-1890 # 80009010 <initproc>

    8000177a:	0000e997          	auipc	s3,0xe
    8000177e:	90698993          	addi	s3,s3,-1786 # 8000f080 <tickslock>
    80001782:	a029                	j	8000178c <reparent+0x34>
    80001784:	17048493          	addi	s1,s1,368
    80001788:	01348d63          	beq	s1,s3,800017a2 <reparent+0x4a>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000178c:	7c9c                	ld	a5,56(s1)
    8000178e:	ff279be3          	bne	a5,s2,80001784 <reparent+0x2c>
    if(pp->parent == p){
    80001792:	000a3503          	ld	a0,0(s4)
    80001796:	fc88                	sd	a0,56(s1)
      pp->parent = initproc;
    80001798:	00000097          	auipc	ra,0x0
    8000179c:	f4a080e7          	jalr	-182(ra) # 800016e2 <wakeup>
    800017a0:	b7d5                	j	80001784 <reparent+0x2c>
  }
    800017a2:	70a2                	ld	ra,40(sp)
    800017a4:	7402                	ld	s0,32(sp)
    800017a6:	64e2                	ld	s1,24(sp)
    800017a8:	6942                	ld	s2,16(sp)
    800017aa:	69a2                	ld	s3,8(sp)
    800017ac:	6a02                	ld	s4,0(sp)
    800017ae:	6145                	addi	sp,sp,48
    800017b0:	8082                	ret

00000000800017b2 <exit>:
exit(int status)
    800017b2:	7179                	addi	sp,sp,-48
    800017b4:	f406                	sd	ra,40(sp)
    800017b6:	f022                	sd	s0,32(sp)
    800017b8:	ec26                	sd	s1,24(sp)
    800017ba:	e84a                	sd	s2,16(sp)
    800017bc:	e44e                	sd	s3,8(sp)
    800017be:	e052                	sd	s4,0(sp)
    800017c0:	1800                	addi	s0,sp,48
    800017c2:	8a2a                	mv	s4,a0
{
    800017c4:	fffff097          	auipc	ra,0xfffff
    800017c8:	6ce080e7          	jalr	1742(ra) # 80000e92 <myproc>
    800017cc:	89aa                	mv	s3,a0

    800017ce:	00008797          	auipc	a5,0x8
    800017d2:	8427b783          	ld	a5,-1982(a5) # 80009010 <initproc>
    800017d6:	0d850493          	addi	s1,a0,216
    800017da:	15850913          	addi	s2,a0,344
    800017de:	02a79363          	bne	a5,a0,80001804 <exit+0x52>
  if(p == initproc)
    800017e2:	00007517          	auipc	a0,0x7
    800017e6:	9fe50513          	addi	a0,a0,-1538 # 800081e0 <etext+0x1e0>
    800017ea:	00004097          	auipc	ra,0x4
    800017ee:	47e080e7          	jalr	1150(ra) # 80005c68 <panic>
      struct file *f = p->ofile[fd];
    800017f2:	00002097          	auipc	ra,0x2
    800017f6:	268080e7          	jalr	616(ra) # 80003a5a <fileclose>
      fileclose(f);
    800017fa:	0004b023          	sd	zero,0(s1)
  // Close all open files.
    800017fe:	04a1                	addi	s1,s1,8
    80001800:	01248563          	beq	s1,s2,8000180a <exit+0x58>
  for(int fd = 0; fd < NOFILE; fd++){
    80001804:	6088                	ld	a0,0(s1)
    80001806:	f575                	bnez	a0,800017f2 <exit+0x40>
    80001808:	bfdd                	j	800017fe <exit+0x4c>

    8000180a:	00002097          	auipc	ra,0x2
    8000180e:	d84080e7          	jalr	-636(ra) # 8000358e <begin_op>
  begin_op();
    80001812:	1589b503          	ld	a0,344(s3)
    80001816:	00001097          	auipc	ra,0x1
    8000181a:	560080e7          	jalr	1376(ra) # 80002d76 <iput>
  iput(p->cwd);
    8000181e:	00002097          	auipc	ra,0x2
    80001822:	df0080e7          	jalr	-528(ra) # 8000360e <end_op>
  end_op();
    80001826:	1409bc23          	sd	zero,344(s3)

    8000182a:	00008497          	auipc	s1,0x8
    8000182e:	83e48493          	addi	s1,s1,-1986 # 80009068 <wait_lock>
    80001832:	8526                	mv	a0,s1
    80001834:	00005097          	auipc	ra,0x5
    80001838:	97e080e7          	jalr	-1666(ra) # 800061b2 <acquire>
  // Give any children to init.
    8000183c:	854e                	mv	a0,s3
    8000183e:	00000097          	auipc	ra,0x0
    80001842:	f1a080e7          	jalr	-230(ra) # 80001758 <reparent>
  // Parent might be sleeping in wait().
    80001846:	0389b503          	ld	a0,56(s3)
    8000184a:	00000097          	auipc	ra,0x0
    8000184e:	e98080e7          	jalr	-360(ra) # 800016e2 <wakeup>
  
    80001852:	854e                	mv	a0,s3
    80001854:	00005097          	auipc	ra,0x5
    80001858:	95e080e7          	jalr	-1698(ra) # 800061b2 <acquire>

    8000185c:	0349a623          	sw	s4,44(s3)
  p->xstate = status;
    80001860:	4795                	li	a5,5
    80001862:	00f9ac23          	sw	a5,24(s3)

    80001866:	8526                	mv	a0,s1
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	9fe080e7          	jalr	-1538(ra) # 80006266 <release>
  // Jump into the scheduler, never to return.
    80001870:	00000097          	auipc	ra,0x0
    80001874:	bd4080e7          	jalr	-1068(ra) # 80001444 <sched>
  sched();
    80001878:	00007517          	auipc	a0,0x7
    8000187c:	97850513          	addi	a0,a0,-1672 # 800081f0 <etext+0x1f0>
    80001880:	00004097          	auipc	ra,0x4
    80001884:	3e8080e7          	jalr	1000(ra) # 80005c68 <panic>

0000000080001888 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
    80001888:	7179                	addi	sp,sp,-48
    8000188a:	f406                	sd	ra,40(sp)
    8000188c:	f022                	sd	s0,32(sp)
    8000188e:	ec26                	sd	s1,24(sp)
    80001890:	e84a                	sd	s2,16(sp)
    80001892:	e44e                	sd	s3,8(sp)
    80001894:	1800                	addi	s0,sp,48
    80001896:	892a                	mv	s2,a0
{
  struct proc *p;

    80001898:	00008497          	auipc	s1,0x8
    8000189c:	be848493          	addi	s1,s1,-1048 # 80009480 <proc>
    800018a0:	0000d997          	auipc	s3,0xd
    800018a4:	7e098993          	addi	s3,s3,2016 # 8000f080 <tickslock>
  for(p = proc; p < &proc[NPROC]; p++){
    800018a8:	8526                	mv	a0,s1
    800018aa:	00005097          	auipc	ra,0x5
    800018ae:	908080e7          	jalr	-1784(ra) # 800061b2 <acquire>
    acquire(&p->lock);
    800018b2:	589c                	lw	a5,48(s1)
    800018b4:	01278d63          	beq	a5,s2,800018ce <kill+0x46>
        // Wake process from sleep().
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    800018b8:	8526                	mv	a0,s1
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	9ac080e7          	jalr	-1620(ra) # 80006266 <release>

    800018c2:	17048493          	addi	s1,s1,368
    800018c6:	ff3491e3          	bne	s1,s3,800018a8 <kill+0x20>
    release(&p->lock);
  }
    800018ca:	557d                	li	a0,-1
    800018cc:	a829                	j	800018e6 <kill+0x5e>
    if(p->pid == pid){
    800018ce:	4785                	li	a5,1
    800018d0:	d49c                	sw	a5,40(s1)
      p->killed = 1;
    800018d2:	4c98                	lw	a4,24(s1)
    800018d4:	4789                	li	a5,2
    800018d6:	00f70f63          	beq	a4,a5,800018f4 <kill+0x6c>
      }
    800018da:	8526                	mv	a0,s1
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	98a080e7          	jalr	-1654(ra) # 80006266 <release>
      release(&p->lock);
    800018e4:	4501                	li	a0,0
  return -1;
    800018e6:	70a2                	ld	ra,40(sp)
    800018e8:	7402                	ld	s0,32(sp)
    800018ea:	64e2                	ld	s1,24(sp)
    800018ec:	6942                	ld	s2,16(sp)
    800018ee:	69a2                	ld	s3,8(sp)
    800018f0:	6145                	addi	sp,sp,48
    800018f2:	8082                	ret
        // Wake process from sleep().
    800018f4:	478d                	li	a5,3
    800018f6:	cc9c                	sw	a5,24(s1)
    800018f8:	b7cd                	j	800018da <kill+0x52>

00000000800018fa <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
    800018fa:	7179                	addi	sp,sp,-48
    800018fc:	f406                	sd	ra,40(sp)
    800018fe:	f022                	sd	s0,32(sp)
    80001900:	ec26                	sd	s1,24(sp)
    80001902:	e84a                	sd	s2,16(sp)
    80001904:	e44e                	sd	s3,8(sp)
    80001906:	e052                	sd	s4,0(sp)
    80001908:	1800                	addi	s0,sp,48
    8000190a:	84aa                	mv	s1,a0
    8000190c:	892e                	mv	s2,a1
    8000190e:	89b2                	mv	s3,a2
    80001910:	8a36                	mv	s4,a3
{
    80001912:	fffff097          	auipc	ra,0xfffff
    80001916:	580080e7          	jalr	1408(ra) # 80000e92 <myproc>
  struct proc *p = myproc();
    8000191a:	c08d                	beqz	s1,8000193c <either_copyout+0x42>
  if(user_dst){
    8000191c:	86d2                	mv	a3,s4
    8000191e:	864e                	mv	a2,s3
    80001920:	85ca                	mv	a1,s2
    80001922:	6928                	ld	a0,80(a0)
    80001924:	fffff097          	auipc	ra,0xfffff
    80001928:	230080e7          	jalr	560(ra) # 80000b54 <copyout>
    return copyout(p->pagetable, dst, src, len);
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
    8000192c:	70a2                	ld	ra,40(sp)
    8000192e:	7402                	ld	s0,32(sp)
    80001930:	64e2                	ld	s1,24(sp)
    80001932:	6942                	ld	s2,16(sp)
    80001934:	69a2                	ld	s3,8(sp)
    80001936:	6a02                	ld	s4,0(sp)
    80001938:	6145                	addi	sp,sp,48
    8000193a:	8082                	ret
  } else {
    8000193c:	000a061b          	sext.w	a2,s4
    80001940:	85ce                	mv	a1,s3
    80001942:	854a                	mv	a0,s2
    80001944:	fffff097          	auipc	ra,0xfffff
    80001948:	8de080e7          	jalr	-1826(ra) # 80000222 <memmove>
    memmove((char *)dst, src, len);
    8000194c:	8526                	mv	a0,s1
    8000194e:	bff9                	j	8000192c <either_copyout+0x32>

0000000080001950 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
    80001950:	7179                	addi	sp,sp,-48
    80001952:	f406                	sd	ra,40(sp)
    80001954:	f022                	sd	s0,32(sp)
    80001956:	ec26                	sd	s1,24(sp)
    80001958:	e84a                	sd	s2,16(sp)
    8000195a:	e44e                	sd	s3,8(sp)
    8000195c:	e052                	sd	s4,0(sp)
    8000195e:	1800                	addi	s0,sp,48
    80001960:	892a                	mv	s2,a0
    80001962:	84ae                	mv	s1,a1
    80001964:	89b2                	mv	s3,a2
    80001966:	8a36                	mv	s4,a3
{
    80001968:	fffff097          	auipc	ra,0xfffff
    8000196c:	52a080e7          	jalr	1322(ra) # 80000e92 <myproc>
  struct proc *p = myproc();
    80001970:	c08d                	beqz	s1,80001992 <either_copyin+0x42>
  if(user_src){
    80001972:	86d2                	mv	a3,s4
    80001974:	864e                	mv	a2,s3
    80001976:	85ca                	mv	a1,s2
    80001978:	6928                	ld	a0,80(a0)
    8000197a:	fffff097          	auipc	ra,0xfffff
    8000197e:	266080e7          	jalr	614(ra) # 80000be0 <copyin>
    return copyin(p->pagetable, dst, src, len);
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
    80001982:	70a2                	ld	ra,40(sp)
    80001984:	7402                	ld	s0,32(sp)
    80001986:	64e2                	ld	s1,24(sp)
    80001988:	6942                	ld	s2,16(sp)
    8000198a:	69a2                	ld	s3,8(sp)
    8000198c:	6a02                	ld	s4,0(sp)
    8000198e:	6145                	addi	sp,sp,48
    80001990:	8082                	ret
  } else {
    80001992:	000a061b          	sext.w	a2,s4
    80001996:	85ce                	mv	a1,s3
    80001998:	854a                	mv	a0,s2
    8000199a:	fffff097          	auipc	ra,0xfffff
    8000199e:	888080e7          	jalr	-1912(ra) # 80000222 <memmove>
    memmove(dst, (char*)src, len);
    800019a2:	8526                	mv	a0,s1
    800019a4:	bff9                	j	80001982 <either_copyin+0x32>

00000000800019a6 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
    800019a6:	715d                	addi	sp,sp,-80
    800019a8:	e486                	sd	ra,72(sp)
    800019aa:	e0a2                	sd	s0,64(sp)
    800019ac:	fc26                	sd	s1,56(sp)
    800019ae:	f84a                	sd	s2,48(sp)
    800019b0:	f44e                	sd	s3,40(sp)
    800019b2:	f052                	sd	s4,32(sp)
    800019b4:	ec56                	sd	s5,24(sp)
    800019b6:	e85a                	sd	s6,16(sp)
    800019b8:	e45e                	sd	s7,8(sp)
    800019ba:	0880                	addi	s0,sp,80
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

    800019bc:	00006517          	auipc	a0,0x6
    800019c0:	68c50513          	addi	a0,a0,1676 # 80008048 <etext+0x48>
    800019c4:	00004097          	auipc	ra,0x4
    800019c8:	2ee080e7          	jalr	750(ra) # 80005cb2 <printf>
  printf("\n");
    800019cc:	00008497          	auipc	s1,0x8
    800019d0:	c1448493          	addi	s1,s1,-1004 # 800095e0 <proc+0x160>
    800019d4:	0000e917          	auipc	s2,0xe
    800019d8:	80c90913          	addi	s2,s2,-2036 # 8000f1e0 <bcache+0x148>
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    800019dc:	4b15                	li	s6,5
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
    800019de:	00007997          	auipc	s3,0x7
    800019e2:	82298993          	addi	s3,s3,-2014 # 80008200 <etext+0x200>
      state = "???";
    800019e6:	00007a97          	auipc	s5,0x7
    800019ea:	822a8a93          	addi	s5,s5,-2014 # 80008208 <etext+0x208>
    printf("%d %s %s", p->pid, state, p->name);
    800019ee:	00006a17          	auipc	s4,0x6
    800019f2:	65aa0a13          	addi	s4,s4,1626 # 80008048 <etext+0x48>
      continue;
    800019f6:	00007b97          	auipc	s7,0x7
    800019fa:	84ab8b93          	addi	s7,s7,-1974 # 80008240 <states.1715>
    800019fe:	a00d                	j	80001a20 <procdump+0x7a>
      state = "???";
    80001a00:	ed06a583          	lw	a1,-304(a3)
    80001a04:	8556                	mv	a0,s5
    80001a06:	00004097          	auipc	ra,0x4
    80001a0a:	2ac080e7          	jalr	684(ra) # 80005cb2 <printf>
    printf("%d %s %s", p->pid, state, p->name);
    80001a0e:	8552                	mv	a0,s4
    80001a10:	00004097          	auipc	ra,0x4
    80001a14:	2a2080e7          	jalr	674(ra) # 80005cb2 <printf>
  printf("\n");
    80001a18:	17048493          	addi	s1,s1,368
    80001a1c:	03248163          	beq	s1,s2,80001a3e <procdump+0x98>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a20:	86a6                	mv	a3,s1
    80001a22:	eb84a783          	lw	a5,-328(s1)
    80001a26:	dbed                	beqz	a5,80001a18 <procdump+0x72>
    else
    80001a28:	864e                	mv	a2,s3
      continue;
    80001a2a:	fcfb6be3          	bltu	s6,a5,80001a00 <procdump+0x5a>
    80001a2e:	1782                	slli	a5,a5,0x20
    80001a30:	9381                	srli	a5,a5,0x20
    80001a32:	078e                	slli	a5,a5,0x3
    80001a34:	97de                	add	a5,a5,s7
    80001a36:	6390                	ld	a2,0(a5)
    80001a38:	f661                	bnez	a2,80001a00 <procdump+0x5a>
    else
    80001a3a:	864e                	mv	a2,s3
    80001a3c:	b7d1                	j	80001a00 <procdump+0x5a>
    printf("\n");
  }
    80001a3e:	60a6                	ld	ra,72(sp)
    80001a40:	6406                	ld	s0,64(sp)
    80001a42:	74e2                	ld	s1,56(sp)
    80001a44:	7942                	ld	s2,48(sp)
    80001a46:	79a2                	ld	s3,40(sp)
    80001a48:	7a02                	ld	s4,32(sp)
    80001a4a:	6ae2                	ld	s5,24(sp)
    80001a4c:	6b42                	ld	s6,16(sp)
    80001a4e:	6ba2                	ld	s7,8(sp)
    80001a50:	6161                	addi	sp,sp,80
    80001a52:	8082                	ret

0000000080001a54 <getnproc>:
}
    80001a54:	1141                	addi	sp,sp,-16
    80001a56:	e422                	sd	s0,8(sp)
    80001a58:	0800                	addi	s0,sp,16
    80001a5a:	4501                	li	a0,0
    80001a5c:	00008797          	auipc	a5,0x8
    80001a60:	a2478793          	addi	a5,a5,-1500 # 80009480 <proc>
    80001a64:	0000d697          	auipc	a3,0xd
    80001a68:	61c68693          	addi	a3,a3,1564 # 8000f080 <tickslock>
    80001a6c:	4f98                	lw	a4,24(a5)
    80001a6e:	00e03733          	snez	a4,a4
    80001a72:	953a                	add	a0,a0,a4
    80001a74:	17078793          	addi	a5,a5,368
    80001a78:	fed79ae3          	bne	a5,a3,80001a6c <getnproc+0x18>
    80001a7c:	6422                	ld	s0,8(sp)
    80001a7e:	0141                	addi	sp,sp,16
    80001a80:	8082                	ret

0000000080001a82 <swtch>:
    80001a82:	00153023          	sd	ra,0(a0)
    80001a86:	00253423          	sd	sp,8(a0)
    80001a8a:	e900                	sd	s0,16(a0)
    80001a8c:	ed04                	sd	s1,24(a0)
    80001a8e:	03253023          	sd	s2,32(a0)
    80001a92:	03353423          	sd	s3,40(a0)
    80001a96:	03453823          	sd	s4,48(a0)
    80001a9a:	03553c23          	sd	s5,56(a0)
    80001a9e:	05653023          	sd	s6,64(a0)
    80001aa2:	05753423          	sd	s7,72(a0)
    80001aa6:	05853823          	sd	s8,80(a0)
    80001aaa:	05953c23          	sd	s9,88(a0)
    80001aae:	07a53023          	sd	s10,96(a0)
    80001ab2:	07b53423          	sd	s11,104(a0)
    80001ab6:	0005b083          	ld	ra,0(a1)
    80001aba:	0085b103          	ld	sp,8(a1)
    80001abe:	6980                	ld	s0,16(a1)
    80001ac0:	6d84                	ld	s1,24(a1)
    80001ac2:	0205b903          	ld	s2,32(a1)
    80001ac6:	0285b983          	ld	s3,40(a1)
    80001aca:	0305ba03          	ld	s4,48(a1)
    80001ace:	0385ba83          	ld	s5,56(a1)
    80001ad2:	0405bb03          	ld	s6,64(a1)
    80001ad6:	0485bb83          	ld	s7,72(a1)
    80001ada:	0505bc03          	ld	s8,80(a1)
    80001ade:	0585bc83          	ld	s9,88(a1)
    80001ae2:	0605bd03          	ld	s10,96(a1)
    80001ae6:	0685bd83          	ld	s11,104(a1)
    80001aea:	8082                	ret

0000000080001aec <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001aec:	1141                	addi	sp,sp,-16
    80001aee:	e406                	sd	ra,8(sp)
    80001af0:	e022                	sd	s0,0(sp)
    80001af2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001af4:	00006597          	auipc	a1,0x6
    80001af8:	77c58593          	addi	a1,a1,1916 # 80008270 <states.1715+0x30>
    80001afc:	0000d517          	auipc	a0,0xd
    80001b00:	58450513          	addi	a0,a0,1412 # 8000f080 <tickslock>
    80001b04:	00004097          	auipc	ra,0x4
    80001b08:	61e080e7          	jalr	1566(ra) # 80006122 <initlock>
}
    80001b0c:	60a2                	ld	ra,8(sp)
    80001b0e:	6402                	ld	s0,0(sp)
    80001b10:	0141                	addi	sp,sp,16
    80001b12:	8082                	ret

0000000080001b14 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b14:	1141                	addi	sp,sp,-16
    80001b16:	e422                	sd	s0,8(sp)
    80001b18:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b1a:	00003797          	auipc	a5,0x3
    80001b1e:	55678793          	addi	a5,a5,1366 # 80005070 <kernelvec>
    80001b22:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b26:	6422                	ld	s0,8(sp)
    80001b28:	0141                	addi	sp,sp,16
    80001b2a:	8082                	ret

0000000080001b2c <usertrapret>:
                  p->trapframe->sa2 = p->trapframe->a2;
                  p->trapframe->sa3 = p->trapframe->a3;
                  p->trapframe->sa4 = p->trapframe->a4;
                  p->trapframe->sa5 = p->trapframe->a5;
                  p->trapframe->sa6 = p->trapframe->a6;
                  p->trapframe->sa7 = p->trapframe->a7;
    80001b2c:	1141                	addi	sp,sp,-16
    80001b2e:	e406                	sd	ra,8(sp)
    80001b30:	e022                	sd	s0,0(sp)
    80001b32:	0800                	addi	s0,sp,16
                  p->trapframe->ss2 = p->trapframe->s2;
    80001b34:	fffff097          	auipc	ra,0xfffff
    80001b38:	35e080e7          	jalr	862(ra) # 80000e92 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b3c:	100027f3          	csrr	a5,sstatus
}
    80001b40:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b42:	10079073          	csrw	sstatus,a5
                  p->trapframe->ss5 = p->trapframe->s5;
                  p->trapframe->ss6 = p->trapframe->s6;
                  p->trapframe->ss7 = p->trapframe->s7;
                  p->trapframe->ss8 = p->trapframe->s8;
                  p->trapframe->ss9 = p->trapframe->s9;
                  p->trapframe->ss10 = p->trapframe->s10;
    80001b46:	00005617          	auipc	a2,0x5
    80001b4a:	4ba60613          	addi	a2,a2,1210 # 80007000 <_trampoline>
    80001b4e:	00005697          	auipc	a3,0x5
    80001b52:	4b268693          	addi	a3,a3,1202 # 80007000 <_trampoline>
    80001b56:	8e91                	sub	a3,a3,a2
    80001b58:	040007b7          	lui	a5,0x4000
    80001b5c:	17fd                	addi	a5,a5,-1
    80001b5e:	07b2                	slli	a5,a5,0xc
    80001b60:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b62:	10569073          	csrw	stvec,a3
                  p->trapframe->ss11 = p->trapframe->s11;
                  p->trapframe->st3 = p->trapframe->t3;
                  p->trapframe->st4 = p->trapframe->t4;
                  p->trapframe->st5 = p->trapframe->t5;
    80001b66:	7138                	ld	a4,96(a0)
}
    80001b68:	180026f3          	csrr	a3,satp
    80001b6c:	e314                	sd	a3,0(a4)
                  p->trapframe->st6 = p->trapframe->t6;
    80001b6e:	7138                	ld	a4,96(a0)
    80001b70:	6134                	ld	a3,64(a0)
    80001b72:	6585                	lui	a1,0x1
    80001b74:	96ae                	add	a3,a3,a1
    80001b76:	e714                	sd	a3,8(a4)
                  p->trapframe->epc = p->handler;
    80001b78:	7138                	ld	a4,96(a0)
    80001b7a:	00000697          	auipc	a3,0x0
    80001b7e:	13868693          	addi	a3,a3,312 # 80001cb2 <usertrap>
    80001b82:	eb14                	sd	a3,16(a4)
              }
    80001b84:	7138                	ld	a4,96(a0)
// read and write tp, the thread pointer, which holds
    80001b86:	8692                	mv	a3,tp
    80001b88:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b8a:	100026f3          	csrr	a3,sstatus
      }
    // ok
  } else {
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    p->killed = 1;
    80001b8e:	eff6f693          	andi	a3,a3,-257
  }
    80001b92:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b96:	10069073          	csrw	sstatus,a3

  if(p->killed)
    exit(-1);

    80001b9a:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b9c:	6f18                	ld	a4,24(a4)
    80001b9e:	14171073          	csrw	sepc,a4
  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2)
    yield();
    80001ba2:	692c                	ld	a1,80(a0)
    80001ba4:	81b1                	srli	a1,a1,0xc

  usertrapret();
}

//
    80001ba6:	00005717          	auipc	a4,0x5
    80001baa:	4ea70713          	addi	a4,a4,1258 # 80007090 <userret>
    80001bae:	8f11                	sub	a4,a4,a2
    80001bb0:	97ba                	add	a5,a5,a4
// return to user space
    80001bb2:	577d                	li	a4,-1
    80001bb4:	177e                	slli	a4,a4,0x3f
    80001bb6:	8dd9                	or	a1,a1,a4
    80001bb8:	02000537          	lui	a0,0x2000
    80001bbc:	157d                	addi	a0,a0,-1
    80001bbe:	0536                	slli	a0,a0,0xd
    80001bc0:	9782                	jalr	a5
//
    80001bc2:	60a2                	ld	ra,8(sp)
    80001bc4:	6402                	ld	s0,0(sp)
    80001bc6:	0141                	addi	sp,sp,16
    80001bc8:	8082                	ret

0000000080001bca <clockintr>:
  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);

    80001bca:	1101                	addi	sp,sp,-32
    80001bcc:	ec06                	sd	ra,24(sp)
    80001bce:	e822                	sd	s0,16(sp)
    80001bd0:	e426                	sd	s1,8(sp)
    80001bd2:	1000                	addi	s0,sp,32
  // jump to trampoline.S at the top of memory, which 
    80001bd4:	0000d497          	auipc	s1,0xd
    80001bd8:	4ac48493          	addi	s1,s1,1196 # 8000f080 <tickslock>
    80001bdc:	8526                	mv	a0,s1
    80001bde:	00004097          	auipc	ra,0x4
    80001be2:	5d4080e7          	jalr	1492(ra) # 800061b2 <acquire>
  // switches to the user page table, restores user registers,
    80001be6:	00007517          	auipc	a0,0x7
    80001bea:	43250513          	addi	a0,a0,1074 # 80009018 <ticks>
    80001bee:	411c                	lw	a5,0(a0)
    80001bf0:	2785                	addiw	a5,a5,1
    80001bf2:	c11c                	sw	a5,0(a0)
  // and switches to user mode with sret.
    80001bf4:	00000097          	auipc	ra,0x0
    80001bf8:	aee080e7          	jalr	-1298(ra) # 800016e2 <wakeup>
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bfc:	8526                	mv	a0,s1
    80001bfe:	00004097          	auipc	ra,0x4
    80001c02:	668080e7          	jalr	1640(ra) # 80006266 <release>
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c06:	60e2                	ld	ra,24(sp)
    80001c08:	6442                	ld	s0,16(sp)
    80001c0a:	64a2                	ld	s1,8(sp)
    80001c0c:	6105                	addi	sp,sp,32
    80001c0e:	8082                	ret

0000000080001c10 <devintr>:
// on whatever the current kernel stack is.
void 
kerneltrap()
{
  int which_dev = 0;
  uint64 sepc = r_sepc();
    80001c10:	1101                	addi	sp,sp,-32
    80001c12:	ec06                	sd	ra,24(sp)
    80001c14:	e822                	sd	s0,16(sp)
    80001c16:	e426                	sd	s1,8(sp)
    80001c18:	1000                	addi	s0,sp,32

    80001c1a:	14202773          	csrr	a4,scause
  uint64 sstatus = r_sstatus();
  uint64 scause = r_scause();
  
    80001c1e:	00074d63          	bltz	a4,80001c38 <devintr+0x28>
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void
    80001c22:	57fd                	li	a5,-1
    80001c24:	17fe                	slli	a5,a5,0x3f
    80001c26:	0785                	addi	a5,a5,1
// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
    80001c28:	4501                	li	a0,0
void
    80001c2a:	06f70363          	beq	a4,a5,80001c90 <devintr+0x80>
devintr()
{
    80001c2e:	60e2                	ld	ra,24(sp)
    80001c30:	6442                	ld	s0,16(sp)
    80001c32:	64a2                	ld	s1,8(sp)
    80001c34:	6105                	addi	sp,sp,32
    80001c36:	8082                	ret
  if((sstatus & SSTATUS_SPP) == 0)
    80001c38:	0ff77793          	andi	a5,a4,255
  
    80001c3c:	46a5                	li	a3,9
    80001c3e:	fed792e3          	bne	a5,a3,80001c22 <devintr+0x12>

    80001c42:	00003097          	auipc	ra,0x3
    80001c46:	536080e7          	jalr	1334(ra) # 80005178 <plic_claim>
    80001c4a:	84aa                	mv	s1,a0
    printf("scause %p\n", scause);
    80001c4c:	47a9                	li	a5,10
    80001c4e:	02f50763          	beq	a0,a5,80001c7c <devintr+0x6c>
    panic("kerneltrap");
    80001c52:	4785                	li	a5,1
    80001c54:	02f50963          	beq	a0,a5,80001c86 <devintr+0x76>

    80001c58:	4505                	li	a0,1

    80001c5a:	d8f1                	beqz	s1,80001c2e <devintr+0x1e>
  // give up the CPU if this is a timer interrupt.
    80001c5c:	85a6                	mv	a1,s1
    80001c5e:	00006517          	auipc	a0,0x6
    80001c62:	61a50513          	addi	a0,a0,1562 # 80008278 <states.1715+0x38>
    80001c66:	00004097          	auipc	ra,0x4
    80001c6a:	04c080e7          	jalr	76(ra) # 80005cb2 <printf>
  w_sstatus(sstatus);
    80001c6e:	8526                	mv	a0,s1
    80001c70:	00003097          	auipc	ra,0x3
    80001c74:	52c080e7          	jalr	1324(ra) # 8000519c <plic_complete>

    80001c78:	4505                	li	a0,1
    80001c7a:	bf55                	j	80001c2e <devintr+0x1e>
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001c7c:	00004097          	auipc	ra,0x4
    80001c80:	456080e7          	jalr	1110(ra) # 800060d2 <uartintr>
    80001c84:	b7ed                	j	80001c6e <devintr+0x5e>
  }
    80001c86:	00004097          	auipc	ra,0x4
    80001c8a:	9f6080e7          	jalr	-1546(ra) # 8000567c <virtio_disk_intr>
    80001c8e:	b7c5                	j	80001c6e <devintr+0x5e>
  ticks++;
    80001c90:	fffff097          	auipc	ra,0xfffff
    80001c94:	1d6080e7          	jalr	470(ra) # 80000e66 <cpuid>
    80001c98:	c901                	beqz	a0,80001ca8 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c9a:	144027f3          	csrr	a5,sip
// and handle it.
    80001c9e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ca0:	14479073          	csrw	sip,a5
// 1 if other device,
    80001ca4:	4509                	li	a0,2
    80001ca6:	b761                	j	80001c2e <devintr+0x1e>
  wakeup(&ticks);
    80001ca8:	00000097          	auipc	ra,0x0
    80001cac:	f22080e7          	jalr	-222(ra) # 80001bca <clockintr>
    80001cb0:	b7ed                	j	80001c9a <devintr+0x8a>

0000000080001cb2 <usertrap>:
{
    80001cb2:	1101                	addi	sp,sp,-32
    80001cb4:	ec06                	sd	ra,24(sp)
    80001cb6:	e822                	sd	s0,16(sp)
    80001cb8:	e426                	sd	s1,8(sp)
    80001cba:	e04a                	sd	s2,0(sp)
    80001cbc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cbe:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cc2:	1007f793          	andi	a5,a5,256
    80001cc6:	e3ad                	bnez	a5,80001d28 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cc8:	00003797          	auipc	a5,0x3
    80001ccc:	3a878793          	addi	a5,a5,936 # 80005070 <kernelvec>
    80001cd0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cd4:	fffff097          	auipc	ra,0xfffff
    80001cd8:	1be080e7          	jalr	446(ra) # 80000e92 <myproc>
    80001cdc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cde:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ce0:	14102773          	csrr	a4,sepc
    80001ce4:	ef98                	sd	a4,24(a5)

    80001ce6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cea:	47a1                	li	a5,8
    80001cec:	04f71c63          	bne	a4,a5,80001d44 <usertrap+0x92>
    if(p->killed)
    80001cf0:	551c                	lw	a5,40(a0)
    80001cf2:	e3b9                	bnez	a5,80001d38 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001cf4:	70b8                	ld	a4,96(s1)
    80001cf6:	6f1c                	ld	a5,24(a4)
    80001cf8:	0791                	addi	a5,a5,4
    80001cfa:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cfc:	100027f3          	csrr	a5,sstatus
}
    80001d00:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d04:	10079073          	csrw	sstatus,a5
    syscall();
    80001d08:	00000097          	auipc	ra,0x0
    80001d0c:	2e0080e7          	jalr	736(ra) # 80001fe8 <syscall>
                  p->trapframe->ssp = p->trapframe->sp;
    80001d10:	549c                	lw	a5,40(s1)
    80001d12:	ebc1                	bnez	a5,80001da2 <usertrap+0xf0>
                  p->trapframe->ss1 = p->trapframe->s1;
    80001d14:	00000097          	auipc	ra,0x0
    80001d18:	e18080e7          	jalr	-488(ra) # 80001b2c <usertrapret>
                  p->trapframe->sa0 = p->trapframe->a0;
    80001d1c:	60e2                	ld	ra,24(sp)
    80001d1e:	6442                	ld	s0,16(sp)
    80001d20:	64a2                	ld	s1,8(sp)
    80001d22:	6902                	ld	s2,0(sp)
    80001d24:	6105                	addi	sp,sp,32
    80001d26:	8082                	ret
    panic("usertrap: not from user mode");
    80001d28:	00006517          	auipc	a0,0x6
    80001d2c:	57050513          	addi	a0,a0,1392 # 80008298 <states.1715+0x58>
    80001d30:	00004097          	auipc	ra,0x4
    80001d34:	f38080e7          	jalr	-200(ra) # 80005c68 <panic>
      exit(-1);
    80001d38:	557d                	li	a0,-1
    80001d3a:	00000097          	auipc	ra,0x0
    80001d3e:	a78080e7          	jalr	-1416(ra) # 800017b2 <exit>
    80001d42:	bf4d                	j	80001cf4 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d44:	00000097          	auipc	ra,0x0
    80001d48:	ecc080e7          	jalr	-308(ra) # 80001c10 <devintr>
    80001d4c:	892a                	mv	s2,a0
    80001d4e:	c501                	beqz	a0,80001d56 <usertrap+0xa4>
                  p->trapframe->ssp = p->trapframe->sp;
    80001d50:	549c                	lw	a5,40(s1)
    80001d52:	c3a1                	beqz	a5,80001d92 <usertrap+0xe0>
    80001d54:	a815                	j	80001d88 <usertrap+0xd6>

    80001d56:	142025f3          	csrr	a1,scause
              p->currticks++;
    80001d5a:	5890                	lw	a2,48(s1)
    80001d5c:	00006517          	auipc	a0,0x6
    80001d60:	55c50513          	addi	a0,a0,1372 # 800082b8 <states.1715+0x78>
    80001d64:	00004097          	auipc	ra,0x4
    80001d68:	f4e080e7          	jalr	-178(ra) # 80005cb2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d6c:	141025f3          	csrr	a1,sepc

    80001d70:	14302673          	csrr	a2,stval
              if(p->currticks % p->ticks == 0 && p->handlerlock){
    80001d74:	00006517          	auipc	a0,0x6
    80001d78:	57450513          	addi	a0,a0,1396 # 800082e8 <states.1715+0xa8>
    80001d7c:	00004097          	auipc	ra,0x4
    80001d80:	f36080e7          	jalr	-202(ra) # 80005cb2 <printf>
                  p->handlerlock = 0;
    80001d84:	4785                	li	a5,1
    80001d86:	d49c                	sw	a5,40(s1)
                  p->trapframe->sgp = p->trapframe->gp;
    80001d88:	557d                	li	a0,-1
    80001d8a:	00000097          	auipc	ra,0x0
    80001d8e:	a28080e7          	jalr	-1496(ra) # 800017b2 <exit>
                  p->trapframe->st1 = p->trapframe->t1;
    80001d92:	4789                	li	a5,2
    80001d94:	f8f910e3          	bne	s2,a5,80001d14 <usertrap+0x62>
                  p->trapframe->st2 = p->trapframe->t2;
    80001d98:	fffff097          	auipc	ra,0xfffff
    80001d9c:	782080e7          	jalr	1922(ra) # 8000151a <yield>
    80001da0:	bf95                	j	80001d14 <usertrap+0x62>
  int which_dev = 0;
    80001da2:	4901                	li	s2,0
    80001da4:	b7d5                	j	80001d88 <usertrap+0xd6>

0000000080001da6 <kerneltrap>:
  // we're about to switch the destination of traps from
    80001da6:	7179                	addi	sp,sp,-48
    80001da8:	f406                	sd	ra,40(sp)
    80001daa:	f022                	sd	s0,32(sp)
    80001dac:	ec26                	sd	s1,24(sp)
    80001dae:	e84a                	sd	s2,16(sp)
    80001db0:	e44e                	sd	s3,8(sp)
    80001db2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001db4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db8:	100024f3          	csrr	s1,sstatus

    80001dbc:	142029f3          	csrr	s3,scause
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001dc0:	1004f793          	andi	a5,s1,256
    80001dc4:	cb85                	beqz	a5,80001df4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dc6:	100027f3          	csrr	a5,sstatus

    80001dca:	8b89                	andi	a5,a5,2
  // set up trapframe values that uservec will need when
    80001dcc:	ef85                	bnez	a5,80001e04 <kerneltrap+0x5e>
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001dce:	00000097          	auipc	ra,0x0
    80001dd2:	e42080e7          	jalr	-446(ra) # 80001c10 <devintr>
    80001dd6:	cd1d                	beqz	a0,80001e14 <kerneltrap+0x6e>
  // set S Previous Privilege mode to User.
    80001dd8:	4789                	li	a5,2
    80001dda:	06f50a63          	beq	a0,a5,80001e4e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dde:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001de2:	10049073          	csrw	sstatus,s1
  w_sepc(p->trapframe->epc);
    80001de6:	70a2                	ld	ra,40(sp)
    80001de8:	7402                	ld	s0,32(sp)
    80001dea:	64e2                	ld	s1,24(sp)
    80001dec:	6942                	ld	s2,16(sp)
    80001dee:	69a2                	ld	s3,8(sp)
    80001df0:	6145                	addi	sp,sp,48
    80001df2:	8082                	ret

    80001df4:	00006517          	auipc	a0,0x6
    80001df8:	51450513          	addi	a0,a0,1300 # 80008308 <states.1715+0xc8>
    80001dfc:	00004097          	auipc	ra,0x4
    80001e00:	e6c080e7          	jalr	-404(ra) # 80005c68 <panic>
  // the process next re-enters the kernel.
    80001e04:	00006517          	auipc	a0,0x6
    80001e08:	52c50513          	addi	a0,a0,1324 # 80008330 <states.1715+0xf0>
    80001e0c:	00004097          	auipc	ra,0x4
    80001e10:	e5c080e7          	jalr	-420(ra) # 80005c68 <panic>
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001e14:	85ce                	mv	a1,s3
    80001e16:	00006517          	auipc	a0,0x6
    80001e1a:	53a50513          	addi	a0,a0,1338 # 80008350 <states.1715+0x110>
    80001e1e:	00004097          	auipc	ra,0x4
    80001e22:	e94080e7          	jalr	-364(ra) # 80005cb2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e26:	141025f3          	csrr	a1,sepc

    80001e2a:	14302673          	csrr	a2,stval
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001e2e:	00006517          	auipc	a0,0x6
    80001e32:	53250513          	addi	a0,a0,1330 # 80008360 <states.1715+0x120>
    80001e36:	00004097          	auipc	ra,0x4
    80001e3a:	e7c080e7          	jalr	-388(ra) # 80005cb2 <printf>

    80001e3e:	00006517          	auipc	a0,0x6
    80001e42:	53a50513          	addi	a0,a0,1338 # 80008378 <states.1715+0x138>
    80001e46:	00004097          	auipc	ra,0x4
    80001e4a:	e22080e7          	jalr	-478(ra) # 80005c68 <panic>
  // set S Previous Privilege mode to User.
    80001e4e:	fffff097          	auipc	ra,0xfffff
    80001e52:	044080e7          	jalr	68(ra) # 80000e92 <myproc>
    80001e56:	d541                	beqz	a0,80001dde <kerneltrap+0x38>
    80001e58:	fffff097          	auipc	ra,0xfffff
    80001e5c:	03a080e7          	jalr	58(ra) # 80000e92 <myproc>
    80001e60:	4d18                	lw	a4,24(a0)
    80001e62:	4791                	li	a5,4
    80001e64:	f6f71de3          	bne	a4,a5,80001dde <kerneltrap+0x38>
  unsigned long x = r_sstatus();
    80001e68:	fffff097          	auipc	ra,0xfffff
    80001e6c:	6b2080e7          	jalr	1714(ra) # 8000151a <yield>
    80001e70:	b7bd                	j	80001dde <kerneltrap+0x38>

0000000080001e72 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e72:	1101                	addi	sp,sp,-32
    80001e74:	ec06                	sd	ra,24(sp)
    80001e76:	e822                	sd	s0,16(sp)
    80001e78:	e426                	sd	s1,8(sp)
    80001e7a:	1000                	addi	s0,sp,32
    80001e7c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e7e:	fffff097          	auipc	ra,0xfffff
    80001e82:	014080e7          	jalr	20(ra) # 80000e92 <myproc>
  switch (n) {
    80001e86:	4795                	li	a5,5
    80001e88:	0497e163          	bltu	a5,s1,80001eca <argraw+0x58>
    80001e8c:	048a                	slli	s1,s1,0x2
    80001e8e:	00006717          	auipc	a4,0x6
    80001e92:	5ea70713          	addi	a4,a4,1514 # 80008478 <states.1715+0x238>
    80001e96:	94ba                	add	s1,s1,a4
    80001e98:	409c                	lw	a5,0(s1)
    80001e9a:	97ba                	add	a5,a5,a4
    80001e9c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e9e:	713c                	ld	a5,96(a0)
    80001ea0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ea2:	60e2                	ld	ra,24(sp)
    80001ea4:	6442                	ld	s0,16(sp)
    80001ea6:	64a2                	ld	s1,8(sp)
    80001ea8:	6105                	addi	sp,sp,32
    80001eaa:	8082                	ret
    return p->trapframe->a1;
    80001eac:	713c                	ld	a5,96(a0)
    80001eae:	7fa8                	ld	a0,120(a5)
    80001eb0:	bfcd                	j	80001ea2 <argraw+0x30>
    return p->trapframe->a2;
    80001eb2:	713c                	ld	a5,96(a0)
    80001eb4:	63c8                	ld	a0,128(a5)
    80001eb6:	b7f5                	j	80001ea2 <argraw+0x30>
    return p->trapframe->a3;
    80001eb8:	713c                	ld	a5,96(a0)
    80001eba:	67c8                	ld	a0,136(a5)
    80001ebc:	b7dd                	j	80001ea2 <argraw+0x30>
    return p->trapframe->a4;
    80001ebe:	713c                	ld	a5,96(a0)
    80001ec0:	6bc8                	ld	a0,144(a5)
    80001ec2:	b7c5                	j	80001ea2 <argraw+0x30>
    return p->trapframe->a5;
    80001ec4:	713c                	ld	a5,96(a0)
    80001ec6:	6fc8                	ld	a0,152(a5)
    80001ec8:	bfe9                	j	80001ea2 <argraw+0x30>
  panic("argraw");
    80001eca:	00006517          	auipc	a0,0x6
    80001ece:	4be50513          	addi	a0,a0,1214 # 80008388 <states.1715+0x148>
    80001ed2:	00004097          	auipc	ra,0x4
    80001ed6:	d96080e7          	jalr	-618(ra) # 80005c68 <panic>

0000000080001eda <fetchaddr>:
{
    80001eda:	1101                	addi	sp,sp,-32
    80001edc:	ec06                	sd	ra,24(sp)
    80001ede:	e822                	sd	s0,16(sp)
    80001ee0:	e426                	sd	s1,8(sp)
    80001ee2:	e04a                	sd	s2,0(sp)
    80001ee4:	1000                	addi	s0,sp,32
    80001ee6:	84aa                	mv	s1,a0
    80001ee8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001eea:	fffff097          	auipc	ra,0xfffff
    80001eee:	fa8080e7          	jalr	-88(ra) # 80000e92 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001ef2:	653c                	ld	a5,72(a0)
    80001ef4:	02f4f863          	bgeu	s1,a5,80001f24 <fetchaddr+0x4a>
    80001ef8:	00848713          	addi	a4,s1,8
    80001efc:	02e7e663          	bltu	a5,a4,80001f28 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f00:	46a1                	li	a3,8
    80001f02:	8626                	mv	a2,s1
    80001f04:	85ca                	mv	a1,s2
    80001f06:	6928                	ld	a0,80(a0)
    80001f08:	fffff097          	auipc	ra,0xfffff
    80001f0c:	cd8080e7          	jalr	-808(ra) # 80000be0 <copyin>
    80001f10:	00a03533          	snez	a0,a0
    80001f14:	40a00533          	neg	a0,a0
}
    80001f18:	60e2                	ld	ra,24(sp)
    80001f1a:	6442                	ld	s0,16(sp)
    80001f1c:	64a2                	ld	s1,8(sp)
    80001f1e:	6902                	ld	s2,0(sp)
    80001f20:	6105                	addi	sp,sp,32
    80001f22:	8082                	ret
    return -1;
    80001f24:	557d                	li	a0,-1
    80001f26:	bfcd                	j	80001f18 <fetchaddr+0x3e>
    80001f28:	557d                	li	a0,-1
    80001f2a:	b7fd                	j	80001f18 <fetchaddr+0x3e>

0000000080001f2c <fetchstr>:
{
    80001f2c:	7179                	addi	sp,sp,-48
    80001f2e:	f406                	sd	ra,40(sp)
    80001f30:	f022                	sd	s0,32(sp)
    80001f32:	ec26                	sd	s1,24(sp)
    80001f34:	e84a                	sd	s2,16(sp)
    80001f36:	e44e                	sd	s3,8(sp)
    80001f38:	1800                	addi	s0,sp,48
    80001f3a:	892a                	mv	s2,a0
    80001f3c:	84ae                	mv	s1,a1
    80001f3e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f40:	fffff097          	auipc	ra,0xfffff
    80001f44:	f52080e7          	jalr	-174(ra) # 80000e92 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f48:	86ce                	mv	a3,s3
    80001f4a:	864a                	mv	a2,s2
    80001f4c:	85a6                	mv	a1,s1
    80001f4e:	6928                	ld	a0,80(a0)
    80001f50:	fffff097          	auipc	ra,0xfffff
    80001f54:	d1c080e7          	jalr	-740(ra) # 80000c6c <copyinstr>
  if(err < 0)
    80001f58:	00054763          	bltz	a0,80001f66 <fetchstr+0x3a>
  return strlen(buf);
    80001f5c:	8526                	mv	a0,s1
    80001f5e:	ffffe097          	auipc	ra,0xffffe
    80001f62:	3e8080e7          	jalr	1000(ra) # 80000346 <strlen>
}
    80001f66:	70a2                	ld	ra,40(sp)
    80001f68:	7402                	ld	s0,32(sp)
    80001f6a:	64e2                	ld	s1,24(sp)
    80001f6c:	6942                	ld	s2,16(sp)
    80001f6e:	69a2                	ld	s3,8(sp)
    80001f70:	6145                	addi	sp,sp,48
    80001f72:	8082                	ret

0000000080001f74 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f74:	1101                	addi	sp,sp,-32
    80001f76:	ec06                	sd	ra,24(sp)
    80001f78:	e822                	sd	s0,16(sp)
    80001f7a:	e426                	sd	s1,8(sp)
    80001f7c:	1000                	addi	s0,sp,32
    80001f7e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f80:	00000097          	auipc	ra,0x0
    80001f84:	ef2080e7          	jalr	-270(ra) # 80001e72 <argraw>
    80001f88:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f8a:	4501                	li	a0,0
    80001f8c:	60e2                	ld	ra,24(sp)
    80001f8e:	6442                	ld	s0,16(sp)
    80001f90:	64a2                	ld	s1,8(sp)
    80001f92:	6105                	addi	sp,sp,32
    80001f94:	8082                	ret

0000000080001f96 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f96:	1101                	addi	sp,sp,-32
    80001f98:	ec06                	sd	ra,24(sp)
    80001f9a:	e822                	sd	s0,16(sp)
    80001f9c:	e426                	sd	s1,8(sp)
    80001f9e:	1000                	addi	s0,sp,32
    80001fa0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fa2:	00000097          	auipc	ra,0x0
    80001fa6:	ed0080e7          	jalr	-304(ra) # 80001e72 <argraw>
    80001faa:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fac:	4501                	li	a0,0
    80001fae:	60e2                	ld	ra,24(sp)
    80001fb0:	6442                	ld	s0,16(sp)
    80001fb2:	64a2                	ld	s1,8(sp)
    80001fb4:	6105                	addi	sp,sp,32
    80001fb6:	8082                	ret

0000000080001fb8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fb8:	1101                	addi	sp,sp,-32
    80001fba:	ec06                	sd	ra,24(sp)
    80001fbc:	e822                	sd	s0,16(sp)
    80001fbe:	e426                	sd	s1,8(sp)
    80001fc0:	e04a                	sd	s2,0(sp)
    80001fc2:	1000                	addi	s0,sp,32
    80001fc4:	84ae                	mv	s1,a1
    80001fc6:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fc8:	00000097          	auipc	ra,0x0
    80001fcc:	eaa080e7          	jalr	-342(ra) # 80001e72 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fd0:	864a                	mv	a2,s2
    80001fd2:	85a6                	mv	a1,s1
    80001fd4:	00000097          	auipc	ra,0x0
    80001fd8:	f58080e7          	jalr	-168(ra) # 80001f2c <fetchstr>
}
    80001fdc:	60e2                	ld	ra,24(sp)
    80001fde:	6442                	ld	s0,16(sp)
    80001fe0:	64a2                	ld	s1,8(sp)
    80001fe2:	6902                	ld	s2,0(sp)
    80001fe4:	6105                	addi	sp,sp,32
    80001fe6:	8082                	ret

0000000080001fe8 <syscall>:
    80001fe8:	7179                	addi	sp,sp,-48
    80001fea:	f406                	sd	ra,40(sp)
    80001fec:	f022                	sd	s0,32(sp)
    80001fee:	ec26                	sd	s1,24(sp)
    80001ff0:	e84a                	sd	s2,16(sp)
    80001ff2:	e44e                	sd	s3,8(sp)
    80001ff4:	1800                	addi	s0,sp,48
    80001ff6:	fffff097          	auipc	ra,0xfffff
    80001ffa:	e9c080e7          	jalr	-356(ra) # 80000e92 <myproc>
    80001ffe:	84aa                	mv	s1,a0
    80002000:	06053903          	ld	s2,96(a0)
    80002004:	0a893783          	ld	a5,168(s2)
    80002008:	0007899b          	sext.w	s3,a5
    8000200c:	37fd                	addiw	a5,a5,-1
    8000200e:	4759                	li	a4,22
    80002010:	04f76963          	bltu	a4,a5,80002062 <syscall+0x7a>
    80002014:	00399713          	slli	a4,s3,0x3
    80002018:	00006797          	auipc	a5,0x6
    8000201c:	47878793          	addi	a5,a5,1144 # 80008490 <syscalls>
    80002020:	97ba                	add	a5,a5,a4
    80002022:	639c                	ld	a5,0(a5)
    80002024:	cf9d                	beqz	a5,80002062 <syscall+0x7a>
    80002026:	9782                	jalr	a5
    80002028:	06a93823          	sd	a0,112(s2)
    8000202c:	4785                	li	a5,1
    8000202e:	0137973b          	sllw	a4,a5,s3
    80002032:	4cbc                	lw	a5,88(s1)
    80002034:	8ff9                	and	a5,a5,a4
    80002036:	2781                	sext.w	a5,a5
    80002038:	c7a1                	beqz	a5,80002080 <syscall+0x98>
    8000203a:	70b8                	ld	a4,96(s1)
    8000203c:	098e                	slli	s3,s3,0x3
    8000203e:	00006797          	auipc	a5,0x6
    80002042:	45278793          	addi	a5,a5,1106 # 80008490 <syscalls>
    80002046:	99be                	add	s3,s3,a5
    80002048:	7b34                	ld	a3,112(a4)
    8000204a:	0c09b603          	ld	a2,192(s3)
    8000204e:	588c                	lw	a1,48(s1)
    80002050:	00006517          	auipc	a0,0x6
    80002054:	34050513          	addi	a0,a0,832 # 80008390 <states.1715+0x150>
    80002058:	00004097          	auipc	ra,0x4
    8000205c:	c5a080e7          	jalr	-934(ra) # 80005cb2 <printf>
    80002060:	a005                	j	80002080 <syscall+0x98>
    80002062:	86ce                	mv	a3,s3
    80002064:	16048613          	addi	a2,s1,352
    80002068:	588c                	lw	a1,48(s1)
    8000206a:	00006517          	auipc	a0,0x6
    8000206e:	33e50513          	addi	a0,a0,830 # 800083a8 <states.1715+0x168>
    80002072:	00004097          	auipc	ra,0x4
    80002076:	c40080e7          	jalr	-960(ra) # 80005cb2 <printf>
    8000207a:	70bc                	ld	a5,96(s1)
    8000207c:	577d                	li	a4,-1
    8000207e:	fbb8                	sd	a4,112(a5)
    80002080:	70a2                	ld	ra,40(sp)
    80002082:	7402                	ld	s0,32(sp)
    80002084:	64e2                	ld	s1,24(sp)
    80002086:	6942                	ld	s2,16(sp)
    80002088:	69a2                	ld	s3,8(sp)
    8000208a:	6145                	addi	sp,sp,48
    8000208c:	8082                	ret

000000008000208e <sys_exit>:
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
    8000208e:	1101                	addi	sp,sp,-32
    80002090:	ec06                	sd	ra,24(sp)
    80002092:	e822                	sd	s0,16(sp)
    80002094:	1000                	addi	s0,sp,32
  if(argint(0, &n) < 0)
    return -1;
    80002096:	fec40593          	addi	a1,s0,-20
    8000209a:	4501                	li	a0,0
    8000209c:	00000097          	auipc	ra,0x0
    800020a0:	ed8080e7          	jalr	-296(ra) # 80001f74 <argint>
  exit(n);
    800020a4:	57fd                	li	a5,-1
    return -1;
    800020a6:	00054963          	bltz	a0,800020b8 <sys_exit+0x2a>
  return 0;  // not reached
    800020aa:	fec42503          	lw	a0,-20(s0)
    800020ae:	fffff097          	auipc	ra,0xfffff
    800020b2:	704080e7          	jalr	1796(ra) # 800017b2 <exit>
}
    800020b6:	4781                	li	a5,0

    800020b8:	853e                	mv	a0,a5
    800020ba:	60e2                	ld	ra,24(sp)
    800020bc:	6442                	ld	s0,16(sp)
    800020be:	6105                	addi	sp,sp,32
    800020c0:	8082                	ret

00000000800020c2 <sys_getpid>:
uint64
sys_getpid(void)
{
  return myproc()->pid;
    800020c2:	1141                	addi	sp,sp,-16
    800020c4:	e406                	sd	ra,8(sp)
    800020c6:	e022                	sd	s0,0(sp)
    800020c8:	0800                	addi	s0,sp,16
}
    800020ca:	fffff097          	auipc	ra,0xfffff
    800020ce:	dc8080e7          	jalr	-568(ra) # 80000e92 <myproc>

    800020d2:	5908                	lw	a0,48(a0)
    800020d4:	60a2                	ld	ra,8(sp)
    800020d6:	6402                	ld	s0,0(sp)
    800020d8:	0141                	addi	sp,sp,16
    800020da:	8082                	ret

00000000800020dc <sys_fork>:
uint64
sys_fork(void)
{
  return fork();
    800020dc:	1141                	addi	sp,sp,-16
    800020de:	e406                	sd	ra,8(sp)
    800020e0:	e022                	sd	s0,0(sp)
    800020e2:	0800                	addi	s0,sp,16
}
    800020e4:	fffff097          	auipc	ra,0xfffff
    800020e8:	17c080e7          	jalr	380(ra) # 80001260 <fork>

    800020ec:	60a2                	ld	ra,8(sp)
    800020ee:	6402                	ld	s0,0(sp)
    800020f0:	0141                	addi	sp,sp,16
    800020f2:	8082                	ret

00000000800020f4 <sys_wait>:
uint64
sys_wait(void)
{
  uint64 p;
    800020f4:	1101                	addi	sp,sp,-32
    800020f6:	ec06                	sd	ra,24(sp)
    800020f8:	e822                	sd	s0,16(sp)
    800020fa:	1000                	addi	s0,sp,32
  if(argaddr(0, &p) < 0)
    return -1;
    800020fc:	fe840593          	addi	a1,s0,-24
    80002100:	4501                	li	a0,0
    80002102:	00000097          	auipc	ra,0x0
    80002106:	e94080e7          	jalr	-364(ra) # 80001f96 <argaddr>
    8000210a:	87aa                	mv	a5,a0
  return wait(p);
    8000210c:	557d                	li	a0,-1
    return -1;
    8000210e:	0007c863          	bltz	a5,8000211e <sys_wait+0x2a>
}
    80002112:	fe843503          	ld	a0,-24(s0)
    80002116:	fffff097          	auipc	ra,0xfffff
    8000211a:	4a4080e7          	jalr	1188(ra) # 800015ba <wait>

    8000211e:	60e2                	ld	ra,24(sp)
    80002120:	6442                	ld	s0,16(sp)
    80002122:	6105                	addi	sp,sp,32
    80002124:	8082                	ret

0000000080002126 <sys_sbrk>:
uint64
sys_sbrk(void)
{
  int addr;
    80002126:	7179                	addi	sp,sp,-48
    80002128:	f406                	sd	ra,40(sp)
    8000212a:	f022                	sd	s0,32(sp)
    8000212c:	ec26                	sd	s1,24(sp)
    8000212e:	1800                	addi	s0,sp,48
  int n;

  if(argint(0, &n) < 0)
    return -1;
    80002130:	fdc40593          	addi	a1,s0,-36
    80002134:	4501                	li	a0,0
    80002136:	00000097          	auipc	ra,0x0
    8000213a:	e3e080e7          	jalr	-450(ra) # 80001f74 <argint>
    8000213e:	87aa                	mv	a5,a0
  addr = myproc()->sz;
    80002140:	557d                	li	a0,-1
    return -1;
    80002142:	0207c063          	bltz	a5,80002162 <sys_sbrk+0x3c>
  if(growproc(n) < 0)
    80002146:	fffff097          	auipc	ra,0xfffff
    8000214a:	d4c080e7          	jalr	-692(ra) # 80000e92 <myproc>
    8000214e:	4524                	lw	s1,72(a0)
    return -1;
    80002150:	fdc42503          	lw	a0,-36(s0)
    80002154:	fffff097          	auipc	ra,0xfffff
    80002158:	098080e7          	jalr	152(ra) # 800011ec <growproc>
    8000215c:	00054863          	bltz	a0,8000216c <sys_sbrk+0x46>
  return addr;
}
    80002160:	8526                	mv	a0,s1

    80002162:	70a2                	ld	ra,40(sp)
    80002164:	7402                	ld	s0,32(sp)
    80002166:	64e2                	ld	s1,24(sp)
    80002168:	6145                	addi	sp,sp,48
    8000216a:	8082                	ret
  return addr;
    8000216c:	557d                	li	a0,-1
    8000216e:	bfd5                	j	80002162 <sys_sbrk+0x3c>

0000000080002170 <sys_sleep>:
uint64
sys_sleep(void)
{
  int n;
    80002170:	7139                	addi	sp,sp,-64
    80002172:	fc06                	sd	ra,56(sp)
    80002174:	f822                	sd	s0,48(sp)
    80002176:	f426                	sd	s1,40(sp)
    80002178:	f04a                	sd	s2,32(sp)
    8000217a:	ec4e                	sd	s3,24(sp)
    8000217c:	0080                	addi	s0,sp,64
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
    8000217e:	fcc40593          	addi	a1,s0,-52
    80002182:	4501                	li	a0,0
    80002184:	00000097          	auipc	ra,0x0
    80002188:	df0080e7          	jalr	-528(ra) # 80001f74 <argint>
  acquire(&tickslock);
    8000218c:	57fd                	li	a5,-1
    return -1;
    8000218e:	06054563          	bltz	a0,800021f8 <sys_sleep+0x88>
  ticks0 = ticks;
    80002192:	0000d517          	auipc	a0,0xd
    80002196:	eee50513          	addi	a0,a0,-274 # 8000f080 <tickslock>
    8000219a:	00004097          	auipc	ra,0x4
    8000219e:	018080e7          	jalr	24(ra) # 800061b2 <acquire>
  while(ticks - ticks0 < n){
    800021a2:	00007917          	auipc	s2,0x7
    800021a6:	e7692903          	lw	s2,-394(s2) # 80009018 <ticks>
    if(myproc()->killed){
    800021aa:	fcc42783          	lw	a5,-52(s0)
    800021ae:	cf85                	beqz	a5,800021e6 <sys_sleep+0x76>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
    800021b0:	0000d997          	auipc	s3,0xd
    800021b4:	ed098993          	addi	s3,s3,-304 # 8000f080 <tickslock>
    800021b8:	00007497          	auipc	s1,0x7
    800021bc:	e6048493          	addi	s1,s1,-416 # 80009018 <ticks>
      release(&tickslock);
    800021c0:	fffff097          	auipc	ra,0xfffff
    800021c4:	cd2080e7          	jalr	-814(ra) # 80000e92 <myproc>
    800021c8:	551c                	lw	a5,40(a0)
    800021ca:	ef9d                	bnez	a5,80002208 <sys_sleep+0x98>
  }
    800021cc:	85ce                	mv	a1,s3
    800021ce:	8526                	mv	a0,s1
    800021d0:	fffff097          	auipc	ra,0xfffff
    800021d4:	386080e7          	jalr	902(ra) # 80001556 <sleep>
    if(myproc()->killed){
    800021d8:	409c                	lw	a5,0(s1)
    800021da:	412787bb          	subw	a5,a5,s2
    800021de:	fcc42703          	lw	a4,-52(s0)
    800021e2:	fce7efe3          	bltu	a5,a4,800021c0 <sys_sleep+0x50>
  release(&tickslock);
  backtrace();
    800021e6:	0000d517          	auipc	a0,0xd
    800021ea:	e9a50513          	addi	a0,a0,-358 # 8000f080 <tickslock>
    800021ee:	00004097          	auipc	ra,0x4
    800021f2:	078080e7          	jalr	120(ra) # 80006266 <release>
  return 0;
    800021f6:	4781                	li	a5,0
}
    800021f8:	853e                	mv	a0,a5
    800021fa:	70e2                	ld	ra,56(sp)
    800021fc:	7442                	ld	s0,48(sp)
    800021fe:	74a2                	ld	s1,40(sp)
    80002200:	7902                	ld	s2,32(sp)
    80002202:	69e2                	ld	s3,24(sp)
    80002204:	6121                	addi	sp,sp,64
    80002206:	8082                	ret
      return -1;
    80002208:	0000d517          	auipc	a0,0xd
    8000220c:	e7850513          	addi	a0,a0,-392 # 8000f080 <tickslock>
    80002210:	00004097          	auipc	ra,0x4
    80002214:	056080e7          	jalr	86(ra) # 80006266 <release>
    }
    80002218:	57fd                	li	a5,-1
    8000221a:	bff9                	j	800021f8 <sys_sleep+0x88>

000000008000221c <sys_kill>:

uint64
sys_kill(void)
{
    8000221c:	1101                	addi	sp,sp,-32
    8000221e:	ec06                	sd	ra,24(sp)
    80002220:	e822                	sd	s0,16(sp)
    80002222:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002224:	fec40593          	addi	a1,s0,-20
    80002228:	4501                	li	a0,0
    8000222a:	00000097          	auipc	ra,0x0
    8000222e:	d4a080e7          	jalr	-694(ra) # 80001f74 <argint>
    80002232:	87aa                	mv	a5,a0
    return -1;
    80002234:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002236:	0007c863          	bltz	a5,80002246 <sys_kill+0x2a>
  return kill(pid);
    8000223a:	fec42503          	lw	a0,-20(s0)
    8000223e:	fffff097          	auipc	ra,0xfffff
    80002242:	64a080e7          	jalr	1610(ra) # 80001888 <kill>
}
    80002246:	60e2                	ld	ra,24(sp)
    80002248:	6442                	ld	s0,16(sp)
    8000224a:	6105                	addi	sp,sp,32
    8000224c:	8082                	ret

000000008000224e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000224e:	1101                	addi	sp,sp,-32
    80002250:	ec06                	sd	ra,24(sp)
    80002252:	e822                	sd	s0,16(sp)
    80002254:	e426                	sd	s1,8(sp)
    80002256:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002258:	0000d517          	auipc	a0,0xd
    8000225c:	e2850513          	addi	a0,a0,-472 # 8000f080 <tickslock>
    80002260:	00004097          	auipc	ra,0x4
    80002264:	f52080e7          	jalr	-174(ra) # 800061b2 <acquire>
  xticks = ticks;
    80002268:	00007497          	auipc	s1,0x7
    8000226c:	db04a483          	lw	s1,-592(s1) # 80009018 <ticks>
  release(&tickslock);
    80002270:	0000d517          	auipc	a0,0xd
    80002274:	e1050513          	addi	a0,a0,-496 # 8000f080 <tickslock>
    80002278:	00004097          	auipc	ra,0x4
    8000227c:	fee080e7          	jalr	-18(ra) # 80006266 <release>
  return xticks;
}
    80002280:	02049513          	slli	a0,s1,0x20
    80002284:	9101                	srli	a0,a0,0x20
    80002286:	60e2                	ld	ra,24(sp)
    80002288:	6442                	ld	s0,16(sp)
    8000228a:	64a2                	ld	s1,8(sp)
    8000228c:	6105                	addi	sp,sp,32
    8000228e:	8082                	ret

0000000080002290 <sys_trace>:

uint64
sys_sigalarm(void){
    printf("sigalarm\n");
    80002290:	7179                	addi	sp,sp,-48
    80002292:	f406                	sd	ra,40(sp)
    80002294:	f022                	sd	s0,32(sp)
    80002296:	ec26                	sd	s1,24(sp)
    80002298:	1800                	addi	s0,sp,48
    int ticks;
    uint64 handler;
    8000229a:	fdc40593          	addi	a1,s0,-36
    8000229e:	4501                	li	a0,0
    800022a0:	00000097          	auipc	ra,0x0
    800022a4:	cd4080e7          	jalr	-812(ra) # 80001f74 <argint>
    if(argint(0,&ticks) < 0 || argaddr(1,&handler) < 0)
    800022a8:	57fd                	li	a5,-1
    uint64 handler;
    800022aa:	00054a63          	bltz	a0,800022be <sys_trace+0x2e>
        return -1;
    800022ae:	fdc42483          	lw	s1,-36(s0)
    800022b2:	fffff097          	auipc	ra,0xfffff
    800022b6:	be0080e7          	jalr	-1056(ra) # 80000e92 <myproc>
    800022ba:	cd24                	sw	s1,88(a0)
    myproc()->ticks = ticks;
    800022bc:	4781                	li	a5,0
    myproc()->handler = handler;
    800022be:	853e                	mv	a0,a5
    800022c0:	70a2                	ld	ra,40(sp)
    800022c2:	7402                	ld	s0,32(sp)
    800022c4:	64e2                	ld	s1,24(sp)
    800022c6:	6145                	addi	sp,sp,48
    800022c8:	8082                	ret

00000000800022ca <sys_sysinfo>:
    return 0;
}
uint64
sys_sigreturn(void){
    800022ca:	7139                	addi	sp,sp,-64
    800022cc:	fc06                	sd	ra,56(sp)
    800022ce:	f822                	sd	s0,48(sp)
    800022d0:	f426                	sd	s1,40(sp)
    800022d2:	0080                	addi	s0,sp,64
    printf("sigreturn\n");
    struct proc* p = myproc();
    800022d4:	fd840593          	addi	a1,s0,-40
    800022d8:	4501                	li	a0,0
    800022da:	00000097          	auipc	ra,0x0
    800022de:	cbc080e7          	jalr	-836(ra) # 80001f96 <argaddr>
    800022e2:	87aa                	mv	a5,a0
    p->handlerlock = 1;
    800022e4:	557d                	li	a0,-1
    struct proc* p = myproc();
    800022e6:	0207ce63          	bltz	a5,80002322 <sys_sysinfo+0x58>
    p->trapframe->epc = p->trapframe->sepc;
    p->trapframe->ra = p->trapframe->sra;
    800022ea:	fffff097          	auipc	ra,0xfffff
    800022ee:	ba8080e7          	jalr	-1112(ra) # 80000e92 <myproc>
    800022f2:	84aa                	mv	s1,a0
    p->trapframe->sp = p->trapframe->ssp;
    800022f4:	ffffe097          	auipc	ra,0xffffe
    800022f8:	e84080e7          	jalr	-380(ra) # 80000178 <getfreemem>
    800022fc:	fca43423          	sd	a0,-56(s0)
    p->trapframe->gp = p->trapframe->sgp;
    80002300:	fffff097          	auipc	ra,0xfffff
    80002304:	754080e7          	jalr	1876(ra) # 80001a54 <getnproc>
    80002308:	fca43823          	sd	a0,-48(s0)
    p->trapframe->tp = p->trapframe->stp;
    8000230c:	46c1                	li	a3,16
    8000230e:	fc840613          	addi	a2,s0,-56
    80002312:	fd843583          	ld	a1,-40(s0)
    80002316:	68a8                	ld	a0,80(s1)
    80002318:	fffff097          	auipc	ra,0xfffff
    8000231c:	83c080e7          	jalr	-1988(ra) # 80000b54 <copyout>
    80002320:	957d                	srai	a0,a0,0x3f
    p->trapframe->t0 = p->trapframe->st0;
    p->trapframe->t1 = p->trapframe->st1;
    p->trapframe->t2 = p->trapframe->st2;
    80002322:	70e2                	ld	ra,56(sp)
    80002324:	7442                	ld	s0,48(sp)
    80002326:	74a2                	ld	s1,40(sp)
    80002328:	6121                	addi	sp,sp,64
    8000232a:	8082                	ret

000000008000232c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000232c:	7179                	addi	sp,sp,-48
    8000232e:	f406                	sd	ra,40(sp)
    80002330:	f022                	sd	s0,32(sp)
    80002332:	ec26                	sd	s1,24(sp)
    80002334:	e84a                	sd	s2,16(sp)
    80002336:	e44e                	sd	s3,8(sp)
    80002338:	e052                	sd	s4,0(sp)
    8000233a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000233c:	00006597          	auipc	a1,0x6
    80002340:	2d458593          	addi	a1,a1,724 # 80008610 <syscall_name+0xc0>
    80002344:	0000d517          	auipc	a0,0xd
    80002348:	d5450513          	addi	a0,a0,-684 # 8000f098 <bcache>
    8000234c:	00004097          	auipc	ra,0x4
    80002350:	dd6080e7          	jalr	-554(ra) # 80006122 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002354:	00015797          	auipc	a5,0x15
    80002358:	d4478793          	addi	a5,a5,-700 # 80017098 <bcache+0x8000>
    8000235c:	00015717          	auipc	a4,0x15
    80002360:	fa470713          	addi	a4,a4,-92 # 80017300 <bcache+0x8268>
    80002364:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002368:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000236c:	0000d497          	auipc	s1,0xd
    80002370:	d4448493          	addi	s1,s1,-700 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002374:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002376:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002378:	00006a17          	auipc	s4,0x6
    8000237c:	2a0a0a13          	addi	s4,s4,672 # 80008618 <syscall_name+0xc8>
    b->next = bcache.head.next;
    80002380:	2b893783          	ld	a5,696(s2)
    80002384:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002386:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000238a:	85d2                	mv	a1,s4
    8000238c:	01048513          	addi	a0,s1,16
    80002390:	00001097          	auipc	ra,0x1
    80002394:	4bc080e7          	jalr	1212(ra) # 8000384c <initsleeplock>
    bcache.head.next->prev = b;
    80002398:	2b893783          	ld	a5,696(s2)
    8000239c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000239e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023a2:	45848493          	addi	s1,s1,1112
    800023a6:	fd349de3          	bne	s1,s3,80002380 <binit+0x54>
  }
}
    800023aa:	70a2                	ld	ra,40(sp)
    800023ac:	7402                	ld	s0,32(sp)
    800023ae:	64e2                	ld	s1,24(sp)
    800023b0:	6942                	ld	s2,16(sp)
    800023b2:	69a2                	ld	s3,8(sp)
    800023b4:	6a02                	ld	s4,0(sp)
    800023b6:	6145                	addi	sp,sp,48
    800023b8:	8082                	ret

00000000800023ba <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023ba:	7179                	addi	sp,sp,-48
    800023bc:	f406                	sd	ra,40(sp)
    800023be:	f022                	sd	s0,32(sp)
    800023c0:	ec26                	sd	s1,24(sp)
    800023c2:	e84a                	sd	s2,16(sp)
    800023c4:	e44e                	sd	s3,8(sp)
    800023c6:	1800                	addi	s0,sp,48
    800023c8:	89aa                	mv	s3,a0
    800023ca:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023cc:	0000d517          	auipc	a0,0xd
    800023d0:	ccc50513          	addi	a0,a0,-820 # 8000f098 <bcache>
    800023d4:	00004097          	auipc	ra,0x4
    800023d8:	dde080e7          	jalr	-546(ra) # 800061b2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023dc:	00015497          	auipc	s1,0x15
    800023e0:	f744b483          	ld	s1,-140(s1) # 80017350 <bcache+0x82b8>
    800023e4:	00015797          	auipc	a5,0x15
    800023e8:	f1c78793          	addi	a5,a5,-228 # 80017300 <bcache+0x8268>
    800023ec:	02f48f63          	beq	s1,a5,8000242a <bread+0x70>
    800023f0:	873e                	mv	a4,a5
    800023f2:	a021                	j	800023fa <bread+0x40>
    800023f4:	68a4                	ld	s1,80(s1)
    800023f6:	02e48a63          	beq	s1,a4,8000242a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023fa:	449c                	lw	a5,8(s1)
    800023fc:	ff379ce3          	bne	a5,s3,800023f4 <bread+0x3a>
    80002400:	44dc                	lw	a5,12(s1)
    80002402:	ff2799e3          	bne	a5,s2,800023f4 <bread+0x3a>
      b->refcnt++;
    80002406:	40bc                	lw	a5,64(s1)
    80002408:	2785                	addiw	a5,a5,1
    8000240a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000240c:	0000d517          	auipc	a0,0xd
    80002410:	c8c50513          	addi	a0,a0,-884 # 8000f098 <bcache>
    80002414:	00004097          	auipc	ra,0x4
    80002418:	e52080e7          	jalr	-430(ra) # 80006266 <release>
      acquiresleep(&b->lock);
    8000241c:	01048513          	addi	a0,s1,16
    80002420:	00001097          	auipc	ra,0x1
    80002424:	466080e7          	jalr	1126(ra) # 80003886 <acquiresleep>
      return b;
    80002428:	a8b9                	j	80002486 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000242a:	00015497          	auipc	s1,0x15
    8000242e:	f1e4b483          	ld	s1,-226(s1) # 80017348 <bcache+0x82b0>
    80002432:	00015797          	auipc	a5,0x15
    80002436:	ece78793          	addi	a5,a5,-306 # 80017300 <bcache+0x8268>
    8000243a:	00f48863          	beq	s1,a5,8000244a <bread+0x90>
    8000243e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002440:	40bc                	lw	a5,64(s1)
    80002442:	cf81                	beqz	a5,8000245a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002444:	64a4                	ld	s1,72(s1)
    80002446:	fee49de3          	bne	s1,a4,80002440 <bread+0x86>
  panic("bget: no buffers");
    8000244a:	00006517          	auipc	a0,0x6
    8000244e:	1d650513          	addi	a0,a0,470 # 80008620 <syscall_name+0xd0>
    80002452:	00004097          	auipc	ra,0x4
    80002456:	816080e7          	jalr	-2026(ra) # 80005c68 <panic>
      b->dev = dev;
    8000245a:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000245e:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002462:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002466:	4785                	li	a5,1
    80002468:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000246a:	0000d517          	auipc	a0,0xd
    8000246e:	c2e50513          	addi	a0,a0,-978 # 8000f098 <bcache>
    80002472:	00004097          	auipc	ra,0x4
    80002476:	df4080e7          	jalr	-524(ra) # 80006266 <release>
      acquiresleep(&b->lock);
    8000247a:	01048513          	addi	a0,s1,16
    8000247e:	00001097          	auipc	ra,0x1
    80002482:	408080e7          	jalr	1032(ra) # 80003886 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002486:	409c                	lw	a5,0(s1)
    80002488:	cb89                	beqz	a5,8000249a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000248a:	8526                	mv	a0,s1
    8000248c:	70a2                	ld	ra,40(sp)
    8000248e:	7402                	ld	s0,32(sp)
    80002490:	64e2                	ld	s1,24(sp)
    80002492:	6942                	ld	s2,16(sp)
    80002494:	69a2                	ld	s3,8(sp)
    80002496:	6145                	addi	sp,sp,48
    80002498:	8082                	ret
    virtio_disk_rw(b, 0);
    8000249a:	4581                	li	a1,0
    8000249c:	8526                	mv	a0,s1
    8000249e:	00003097          	auipc	ra,0x3
    800024a2:	f08080e7          	jalr	-248(ra) # 800053a6 <virtio_disk_rw>
    b->valid = 1;
    800024a6:	4785                	li	a5,1
    800024a8:	c09c                	sw	a5,0(s1)
  return b;
    800024aa:	b7c5                	j	8000248a <bread+0xd0>

00000000800024ac <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024ac:	1101                	addi	sp,sp,-32
    800024ae:	ec06                	sd	ra,24(sp)
    800024b0:	e822                	sd	s0,16(sp)
    800024b2:	e426                	sd	s1,8(sp)
    800024b4:	1000                	addi	s0,sp,32
    800024b6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024b8:	0541                	addi	a0,a0,16
    800024ba:	00001097          	auipc	ra,0x1
    800024be:	466080e7          	jalr	1126(ra) # 80003920 <holdingsleep>
    800024c2:	cd01                	beqz	a0,800024da <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024c4:	4585                	li	a1,1
    800024c6:	8526                	mv	a0,s1
    800024c8:	00003097          	auipc	ra,0x3
    800024cc:	ede080e7          	jalr	-290(ra) # 800053a6 <virtio_disk_rw>
}
    800024d0:	60e2                	ld	ra,24(sp)
    800024d2:	6442                	ld	s0,16(sp)
    800024d4:	64a2                	ld	s1,8(sp)
    800024d6:	6105                	addi	sp,sp,32
    800024d8:	8082                	ret
    panic("bwrite");
    800024da:	00006517          	auipc	a0,0x6
    800024de:	15e50513          	addi	a0,a0,350 # 80008638 <syscall_name+0xe8>
    800024e2:	00003097          	auipc	ra,0x3
    800024e6:	786080e7          	jalr	1926(ra) # 80005c68 <panic>

00000000800024ea <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024ea:	1101                	addi	sp,sp,-32
    800024ec:	ec06                	sd	ra,24(sp)
    800024ee:	e822                	sd	s0,16(sp)
    800024f0:	e426                	sd	s1,8(sp)
    800024f2:	e04a                	sd	s2,0(sp)
    800024f4:	1000                	addi	s0,sp,32
    800024f6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024f8:	01050913          	addi	s2,a0,16
    800024fc:	854a                	mv	a0,s2
    800024fe:	00001097          	auipc	ra,0x1
    80002502:	422080e7          	jalr	1058(ra) # 80003920 <holdingsleep>
    80002506:	c92d                	beqz	a0,80002578 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002508:	854a                	mv	a0,s2
    8000250a:	00001097          	auipc	ra,0x1
    8000250e:	3d2080e7          	jalr	978(ra) # 800038dc <releasesleep>

  acquire(&bcache.lock);
    80002512:	0000d517          	auipc	a0,0xd
    80002516:	b8650513          	addi	a0,a0,-1146 # 8000f098 <bcache>
    8000251a:	00004097          	auipc	ra,0x4
    8000251e:	c98080e7          	jalr	-872(ra) # 800061b2 <acquire>
  b->refcnt--;
    80002522:	40bc                	lw	a5,64(s1)
    80002524:	37fd                	addiw	a5,a5,-1
    80002526:	0007871b          	sext.w	a4,a5
    8000252a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000252c:	eb05                	bnez	a4,8000255c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000252e:	68bc                	ld	a5,80(s1)
    80002530:	64b8                	ld	a4,72(s1)
    80002532:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002534:	64bc                	ld	a5,72(s1)
    80002536:	68b8                	ld	a4,80(s1)
    80002538:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000253a:	00015797          	auipc	a5,0x15
    8000253e:	b5e78793          	addi	a5,a5,-1186 # 80017098 <bcache+0x8000>
    80002542:	2b87b703          	ld	a4,696(a5)
    80002546:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002548:	00015717          	auipc	a4,0x15
    8000254c:	db870713          	addi	a4,a4,-584 # 80017300 <bcache+0x8268>
    80002550:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002552:	2b87b703          	ld	a4,696(a5)
    80002556:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002558:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000255c:	0000d517          	auipc	a0,0xd
    80002560:	b3c50513          	addi	a0,a0,-1220 # 8000f098 <bcache>
    80002564:	00004097          	auipc	ra,0x4
    80002568:	d02080e7          	jalr	-766(ra) # 80006266 <release>
}
    8000256c:	60e2                	ld	ra,24(sp)
    8000256e:	6442                	ld	s0,16(sp)
    80002570:	64a2                	ld	s1,8(sp)
    80002572:	6902                	ld	s2,0(sp)
    80002574:	6105                	addi	sp,sp,32
    80002576:	8082                	ret
    panic("brelse");
    80002578:	00006517          	auipc	a0,0x6
    8000257c:	0c850513          	addi	a0,a0,200 # 80008640 <syscall_name+0xf0>
    80002580:	00003097          	auipc	ra,0x3
    80002584:	6e8080e7          	jalr	1768(ra) # 80005c68 <panic>

0000000080002588 <bpin>:

void
bpin(struct buf *b) {
    80002588:	1101                	addi	sp,sp,-32
    8000258a:	ec06                	sd	ra,24(sp)
    8000258c:	e822                	sd	s0,16(sp)
    8000258e:	e426                	sd	s1,8(sp)
    80002590:	1000                	addi	s0,sp,32
    80002592:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002594:	0000d517          	auipc	a0,0xd
    80002598:	b0450513          	addi	a0,a0,-1276 # 8000f098 <bcache>
    8000259c:	00004097          	auipc	ra,0x4
    800025a0:	c16080e7          	jalr	-1002(ra) # 800061b2 <acquire>
  b->refcnt++;
    800025a4:	40bc                	lw	a5,64(s1)
    800025a6:	2785                	addiw	a5,a5,1
    800025a8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025aa:	0000d517          	auipc	a0,0xd
    800025ae:	aee50513          	addi	a0,a0,-1298 # 8000f098 <bcache>
    800025b2:	00004097          	auipc	ra,0x4
    800025b6:	cb4080e7          	jalr	-844(ra) # 80006266 <release>
}
    800025ba:	60e2                	ld	ra,24(sp)
    800025bc:	6442                	ld	s0,16(sp)
    800025be:	64a2                	ld	s1,8(sp)
    800025c0:	6105                	addi	sp,sp,32
    800025c2:	8082                	ret

00000000800025c4 <bunpin>:

void
bunpin(struct buf *b) {
    800025c4:	1101                	addi	sp,sp,-32
    800025c6:	ec06                	sd	ra,24(sp)
    800025c8:	e822                	sd	s0,16(sp)
    800025ca:	e426                	sd	s1,8(sp)
    800025cc:	1000                	addi	s0,sp,32
    800025ce:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025d0:	0000d517          	auipc	a0,0xd
    800025d4:	ac850513          	addi	a0,a0,-1336 # 8000f098 <bcache>
    800025d8:	00004097          	auipc	ra,0x4
    800025dc:	bda080e7          	jalr	-1062(ra) # 800061b2 <acquire>
  b->refcnt--;
    800025e0:	40bc                	lw	a5,64(s1)
    800025e2:	37fd                	addiw	a5,a5,-1
    800025e4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025e6:	0000d517          	auipc	a0,0xd
    800025ea:	ab250513          	addi	a0,a0,-1358 # 8000f098 <bcache>
    800025ee:	00004097          	auipc	ra,0x4
    800025f2:	c78080e7          	jalr	-904(ra) # 80006266 <release>
}
    800025f6:	60e2                	ld	ra,24(sp)
    800025f8:	6442                	ld	s0,16(sp)
    800025fa:	64a2                	ld	s1,8(sp)
    800025fc:	6105                	addi	sp,sp,32
    800025fe:	8082                	ret

0000000080002600 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002600:	1101                	addi	sp,sp,-32
    80002602:	ec06                	sd	ra,24(sp)
    80002604:	e822                	sd	s0,16(sp)
    80002606:	e426                	sd	s1,8(sp)
    80002608:	e04a                	sd	s2,0(sp)
    8000260a:	1000                	addi	s0,sp,32
    8000260c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000260e:	00d5d59b          	srliw	a1,a1,0xd
    80002612:	00015797          	auipc	a5,0x15
    80002616:	1627a783          	lw	a5,354(a5) # 80017774 <sb+0x1c>
    8000261a:	9dbd                	addw	a1,a1,a5
    8000261c:	00000097          	auipc	ra,0x0
    80002620:	d9e080e7          	jalr	-610(ra) # 800023ba <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002624:	0074f713          	andi	a4,s1,7
    80002628:	4785                	li	a5,1
    8000262a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000262e:	14ce                	slli	s1,s1,0x33
    80002630:	90d9                	srli	s1,s1,0x36
    80002632:	00950733          	add	a4,a0,s1
    80002636:	05874703          	lbu	a4,88(a4)
    8000263a:	00e7f6b3          	and	a3,a5,a4
    8000263e:	c69d                	beqz	a3,8000266c <bfree+0x6c>
    80002640:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002642:	94aa                	add	s1,s1,a0
    80002644:	fff7c793          	not	a5,a5
    80002648:	8ff9                	and	a5,a5,a4
    8000264a:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000264e:	00001097          	auipc	ra,0x1
    80002652:	118080e7          	jalr	280(ra) # 80003766 <log_write>
  brelse(bp);
    80002656:	854a                	mv	a0,s2
    80002658:	00000097          	auipc	ra,0x0
    8000265c:	e92080e7          	jalr	-366(ra) # 800024ea <brelse>
}
    80002660:	60e2                	ld	ra,24(sp)
    80002662:	6442                	ld	s0,16(sp)
    80002664:	64a2                	ld	s1,8(sp)
    80002666:	6902                	ld	s2,0(sp)
    80002668:	6105                	addi	sp,sp,32
    8000266a:	8082                	ret
    panic("freeing free block");
    8000266c:	00006517          	auipc	a0,0x6
    80002670:	fdc50513          	addi	a0,a0,-36 # 80008648 <syscall_name+0xf8>
    80002674:	00003097          	auipc	ra,0x3
    80002678:	5f4080e7          	jalr	1524(ra) # 80005c68 <panic>

000000008000267c <balloc>:
{
    8000267c:	711d                	addi	sp,sp,-96
    8000267e:	ec86                	sd	ra,88(sp)
    80002680:	e8a2                	sd	s0,80(sp)
    80002682:	e4a6                	sd	s1,72(sp)
    80002684:	e0ca                	sd	s2,64(sp)
    80002686:	fc4e                	sd	s3,56(sp)
    80002688:	f852                	sd	s4,48(sp)
    8000268a:	f456                	sd	s5,40(sp)
    8000268c:	f05a                	sd	s6,32(sp)
    8000268e:	ec5e                	sd	s7,24(sp)
    80002690:	e862                	sd	s8,16(sp)
    80002692:	e466                	sd	s9,8(sp)
    80002694:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002696:	00015797          	auipc	a5,0x15
    8000269a:	0c67a783          	lw	a5,198(a5) # 8001775c <sb+0x4>
    8000269e:	cbd1                	beqz	a5,80002732 <balloc+0xb6>
    800026a0:	8baa                	mv	s7,a0
    800026a2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026a4:	00015b17          	auipc	s6,0x15
    800026a8:	0b4b0b13          	addi	s6,s6,180 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026ac:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026ae:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026b0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026b2:	6c89                	lui	s9,0x2
    800026b4:	a831                	j	800026d0 <balloc+0x54>
    brelse(bp);
    800026b6:	854a                	mv	a0,s2
    800026b8:	00000097          	auipc	ra,0x0
    800026bc:	e32080e7          	jalr	-462(ra) # 800024ea <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026c0:	015c87bb          	addw	a5,s9,s5
    800026c4:	00078a9b          	sext.w	s5,a5
    800026c8:	004b2703          	lw	a4,4(s6)
    800026cc:	06eaf363          	bgeu	s5,a4,80002732 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800026d0:	41fad79b          	sraiw	a5,s5,0x1f
    800026d4:	0137d79b          	srliw	a5,a5,0x13
    800026d8:	015787bb          	addw	a5,a5,s5
    800026dc:	40d7d79b          	sraiw	a5,a5,0xd
    800026e0:	01cb2583          	lw	a1,28(s6)
    800026e4:	9dbd                	addw	a1,a1,a5
    800026e6:	855e                	mv	a0,s7
    800026e8:	00000097          	auipc	ra,0x0
    800026ec:	cd2080e7          	jalr	-814(ra) # 800023ba <bread>
    800026f0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026f2:	004b2503          	lw	a0,4(s6)
    800026f6:	000a849b          	sext.w	s1,s5
    800026fa:	8662                	mv	a2,s8
    800026fc:	faa4fde3          	bgeu	s1,a0,800026b6 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002700:	41f6579b          	sraiw	a5,a2,0x1f
    80002704:	01d7d69b          	srliw	a3,a5,0x1d
    80002708:	00c6873b          	addw	a4,a3,a2
    8000270c:	00777793          	andi	a5,a4,7
    80002710:	9f95                	subw	a5,a5,a3
    80002712:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002716:	4037571b          	sraiw	a4,a4,0x3
    8000271a:	00e906b3          	add	a3,s2,a4
    8000271e:	0586c683          	lbu	a3,88(a3)
    80002722:	00d7f5b3          	and	a1,a5,a3
    80002726:	cd91                	beqz	a1,80002742 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002728:	2605                	addiw	a2,a2,1
    8000272a:	2485                	addiw	s1,s1,1
    8000272c:	fd4618e3          	bne	a2,s4,800026fc <balloc+0x80>
    80002730:	b759                	j	800026b6 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002732:	00006517          	auipc	a0,0x6
    80002736:	f2e50513          	addi	a0,a0,-210 # 80008660 <syscall_name+0x110>
    8000273a:	00003097          	auipc	ra,0x3
    8000273e:	52e080e7          	jalr	1326(ra) # 80005c68 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002742:	974a                	add	a4,a4,s2
    80002744:	8fd5                	or	a5,a5,a3
    80002746:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000274a:	854a                	mv	a0,s2
    8000274c:	00001097          	auipc	ra,0x1
    80002750:	01a080e7          	jalr	26(ra) # 80003766 <log_write>
        brelse(bp);
    80002754:	854a                	mv	a0,s2
    80002756:	00000097          	auipc	ra,0x0
    8000275a:	d94080e7          	jalr	-620(ra) # 800024ea <brelse>
  bp = bread(dev, bno);
    8000275e:	85a6                	mv	a1,s1
    80002760:	855e                	mv	a0,s7
    80002762:	00000097          	auipc	ra,0x0
    80002766:	c58080e7          	jalr	-936(ra) # 800023ba <bread>
    8000276a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000276c:	40000613          	li	a2,1024
    80002770:	4581                	li	a1,0
    80002772:	05850513          	addi	a0,a0,88
    80002776:	ffffe097          	auipc	ra,0xffffe
    8000277a:	a4c080e7          	jalr	-1460(ra) # 800001c2 <memset>
  log_write(bp);
    8000277e:	854a                	mv	a0,s2
    80002780:	00001097          	auipc	ra,0x1
    80002784:	fe6080e7          	jalr	-26(ra) # 80003766 <log_write>
  brelse(bp);
    80002788:	854a                	mv	a0,s2
    8000278a:	00000097          	auipc	ra,0x0
    8000278e:	d60080e7          	jalr	-672(ra) # 800024ea <brelse>
}
    80002792:	8526                	mv	a0,s1
    80002794:	60e6                	ld	ra,88(sp)
    80002796:	6446                	ld	s0,80(sp)
    80002798:	64a6                	ld	s1,72(sp)
    8000279a:	6906                	ld	s2,64(sp)
    8000279c:	79e2                	ld	s3,56(sp)
    8000279e:	7a42                	ld	s4,48(sp)
    800027a0:	7aa2                	ld	s5,40(sp)
    800027a2:	7b02                	ld	s6,32(sp)
    800027a4:	6be2                	ld	s7,24(sp)
    800027a6:	6c42                	ld	s8,16(sp)
    800027a8:	6ca2                	ld	s9,8(sp)
    800027aa:	6125                	addi	sp,sp,96
    800027ac:	8082                	ret

00000000800027ae <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027ae:	7179                	addi	sp,sp,-48
    800027b0:	f406                	sd	ra,40(sp)
    800027b2:	f022                	sd	s0,32(sp)
    800027b4:	ec26                	sd	s1,24(sp)
    800027b6:	e84a                	sd	s2,16(sp)
    800027b8:	e44e                	sd	s3,8(sp)
    800027ba:	e052                	sd	s4,0(sp)
    800027bc:	1800                	addi	s0,sp,48
    800027be:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027c0:	47ad                	li	a5,11
    800027c2:	04b7fe63          	bgeu	a5,a1,8000281e <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027c6:	ff45849b          	addiw	s1,a1,-12
    800027ca:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027ce:	0ff00793          	li	a5,255
    800027d2:	0ae7e363          	bltu	a5,a4,80002878 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027d6:	08052583          	lw	a1,128(a0)
    800027da:	c5ad                	beqz	a1,80002844 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027dc:	00092503          	lw	a0,0(s2)
    800027e0:	00000097          	auipc	ra,0x0
    800027e4:	bda080e7          	jalr	-1062(ra) # 800023ba <bread>
    800027e8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027ea:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027ee:	02049593          	slli	a1,s1,0x20
    800027f2:	9181                	srli	a1,a1,0x20
    800027f4:	058a                	slli	a1,a1,0x2
    800027f6:	00b784b3          	add	s1,a5,a1
    800027fa:	0004a983          	lw	s3,0(s1)
    800027fe:	04098d63          	beqz	s3,80002858 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002802:	8552                	mv	a0,s4
    80002804:	00000097          	auipc	ra,0x0
    80002808:	ce6080e7          	jalr	-794(ra) # 800024ea <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000280c:	854e                	mv	a0,s3
    8000280e:	70a2                	ld	ra,40(sp)
    80002810:	7402                	ld	s0,32(sp)
    80002812:	64e2                	ld	s1,24(sp)
    80002814:	6942                	ld	s2,16(sp)
    80002816:	69a2                	ld	s3,8(sp)
    80002818:	6a02                	ld	s4,0(sp)
    8000281a:	6145                	addi	sp,sp,48
    8000281c:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000281e:	02059493          	slli	s1,a1,0x20
    80002822:	9081                	srli	s1,s1,0x20
    80002824:	048a                	slli	s1,s1,0x2
    80002826:	94aa                	add	s1,s1,a0
    80002828:	0504a983          	lw	s3,80(s1)
    8000282c:	fe0990e3          	bnez	s3,8000280c <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002830:	4108                	lw	a0,0(a0)
    80002832:	00000097          	auipc	ra,0x0
    80002836:	e4a080e7          	jalr	-438(ra) # 8000267c <balloc>
    8000283a:	0005099b          	sext.w	s3,a0
    8000283e:	0534a823          	sw	s3,80(s1)
    80002842:	b7e9                	j	8000280c <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002844:	4108                	lw	a0,0(a0)
    80002846:	00000097          	auipc	ra,0x0
    8000284a:	e36080e7          	jalr	-458(ra) # 8000267c <balloc>
    8000284e:	0005059b          	sext.w	a1,a0
    80002852:	08b92023          	sw	a1,128(s2)
    80002856:	b759                	j	800027dc <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002858:	00092503          	lw	a0,0(s2)
    8000285c:	00000097          	auipc	ra,0x0
    80002860:	e20080e7          	jalr	-480(ra) # 8000267c <balloc>
    80002864:	0005099b          	sext.w	s3,a0
    80002868:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000286c:	8552                	mv	a0,s4
    8000286e:	00001097          	auipc	ra,0x1
    80002872:	ef8080e7          	jalr	-264(ra) # 80003766 <log_write>
    80002876:	b771                	j	80002802 <bmap+0x54>
  panic("bmap: out of range");
    80002878:	00006517          	auipc	a0,0x6
    8000287c:	e0050513          	addi	a0,a0,-512 # 80008678 <syscall_name+0x128>
    80002880:	00003097          	auipc	ra,0x3
    80002884:	3e8080e7          	jalr	1000(ra) # 80005c68 <panic>

0000000080002888 <iget>:
{
    80002888:	7179                	addi	sp,sp,-48
    8000288a:	f406                	sd	ra,40(sp)
    8000288c:	f022                	sd	s0,32(sp)
    8000288e:	ec26                	sd	s1,24(sp)
    80002890:	e84a                	sd	s2,16(sp)
    80002892:	e44e                	sd	s3,8(sp)
    80002894:	e052                	sd	s4,0(sp)
    80002896:	1800                	addi	s0,sp,48
    80002898:	89aa                	mv	s3,a0
    8000289a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000289c:	00015517          	auipc	a0,0x15
    800028a0:	edc50513          	addi	a0,a0,-292 # 80017778 <itable>
    800028a4:	00004097          	auipc	ra,0x4
    800028a8:	90e080e7          	jalr	-1778(ra) # 800061b2 <acquire>
  empty = 0;
    800028ac:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ae:	00015497          	auipc	s1,0x15
    800028b2:	ee248493          	addi	s1,s1,-286 # 80017790 <itable+0x18>
    800028b6:	00017697          	auipc	a3,0x17
    800028ba:	96a68693          	addi	a3,a3,-1686 # 80019220 <log>
    800028be:	a039                	j	800028cc <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028c0:	02090b63          	beqz	s2,800028f6 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028c4:	08848493          	addi	s1,s1,136
    800028c8:	02d48a63          	beq	s1,a3,800028fc <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028cc:	449c                	lw	a5,8(s1)
    800028ce:	fef059e3          	blez	a5,800028c0 <iget+0x38>
    800028d2:	4098                	lw	a4,0(s1)
    800028d4:	ff3716e3          	bne	a4,s3,800028c0 <iget+0x38>
    800028d8:	40d8                	lw	a4,4(s1)
    800028da:	ff4713e3          	bne	a4,s4,800028c0 <iget+0x38>
      ip->ref++;
    800028de:	2785                	addiw	a5,a5,1
    800028e0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028e2:	00015517          	auipc	a0,0x15
    800028e6:	e9650513          	addi	a0,a0,-362 # 80017778 <itable>
    800028ea:	00004097          	auipc	ra,0x4
    800028ee:	97c080e7          	jalr	-1668(ra) # 80006266 <release>
      return ip;
    800028f2:	8926                	mv	s2,s1
    800028f4:	a03d                	j	80002922 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028f6:	f7f9                	bnez	a5,800028c4 <iget+0x3c>
    800028f8:	8926                	mv	s2,s1
    800028fa:	b7e9                	j	800028c4 <iget+0x3c>
  if(empty == 0)
    800028fc:	02090c63          	beqz	s2,80002934 <iget+0xac>
  ip->dev = dev;
    80002900:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002904:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002908:	4785                	li	a5,1
    8000290a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000290e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002912:	00015517          	auipc	a0,0x15
    80002916:	e6650513          	addi	a0,a0,-410 # 80017778 <itable>
    8000291a:	00004097          	auipc	ra,0x4
    8000291e:	94c080e7          	jalr	-1716(ra) # 80006266 <release>
}
    80002922:	854a                	mv	a0,s2
    80002924:	70a2                	ld	ra,40(sp)
    80002926:	7402                	ld	s0,32(sp)
    80002928:	64e2                	ld	s1,24(sp)
    8000292a:	6942                	ld	s2,16(sp)
    8000292c:	69a2                	ld	s3,8(sp)
    8000292e:	6a02                	ld	s4,0(sp)
    80002930:	6145                	addi	sp,sp,48
    80002932:	8082                	ret
    panic("iget: no inodes");
    80002934:	00006517          	auipc	a0,0x6
    80002938:	d5c50513          	addi	a0,a0,-676 # 80008690 <syscall_name+0x140>
    8000293c:	00003097          	auipc	ra,0x3
    80002940:	32c080e7          	jalr	812(ra) # 80005c68 <panic>

0000000080002944 <fsinit>:
fsinit(int dev) {
    80002944:	7179                	addi	sp,sp,-48
    80002946:	f406                	sd	ra,40(sp)
    80002948:	f022                	sd	s0,32(sp)
    8000294a:	ec26                	sd	s1,24(sp)
    8000294c:	e84a                	sd	s2,16(sp)
    8000294e:	e44e                	sd	s3,8(sp)
    80002950:	1800                	addi	s0,sp,48
    80002952:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002954:	4585                	li	a1,1
    80002956:	00000097          	auipc	ra,0x0
    8000295a:	a64080e7          	jalr	-1436(ra) # 800023ba <bread>
    8000295e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002960:	00015997          	auipc	s3,0x15
    80002964:	df898993          	addi	s3,s3,-520 # 80017758 <sb>
    80002968:	02000613          	li	a2,32
    8000296c:	05850593          	addi	a1,a0,88
    80002970:	854e                	mv	a0,s3
    80002972:	ffffe097          	auipc	ra,0xffffe
    80002976:	8b0080e7          	jalr	-1872(ra) # 80000222 <memmove>
  brelse(bp);
    8000297a:	8526                	mv	a0,s1
    8000297c:	00000097          	auipc	ra,0x0
    80002980:	b6e080e7          	jalr	-1170(ra) # 800024ea <brelse>
  if(sb.magic != FSMAGIC)
    80002984:	0009a703          	lw	a4,0(s3)
    80002988:	102037b7          	lui	a5,0x10203
    8000298c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002990:	02f71263          	bne	a4,a5,800029b4 <fsinit+0x70>
  initlog(dev, &sb);
    80002994:	00015597          	auipc	a1,0x15
    80002998:	dc458593          	addi	a1,a1,-572 # 80017758 <sb>
    8000299c:	854a                	mv	a0,s2
    8000299e:	00001097          	auipc	ra,0x1
    800029a2:	b4c080e7          	jalr	-1204(ra) # 800034ea <initlog>
}
    800029a6:	70a2                	ld	ra,40(sp)
    800029a8:	7402                	ld	s0,32(sp)
    800029aa:	64e2                	ld	s1,24(sp)
    800029ac:	6942                	ld	s2,16(sp)
    800029ae:	69a2                	ld	s3,8(sp)
    800029b0:	6145                	addi	sp,sp,48
    800029b2:	8082                	ret
    panic("invalid file system");
    800029b4:	00006517          	auipc	a0,0x6
    800029b8:	cec50513          	addi	a0,a0,-788 # 800086a0 <syscall_name+0x150>
    800029bc:	00003097          	auipc	ra,0x3
    800029c0:	2ac080e7          	jalr	684(ra) # 80005c68 <panic>

00000000800029c4 <iinit>:
{
    800029c4:	7179                	addi	sp,sp,-48
    800029c6:	f406                	sd	ra,40(sp)
    800029c8:	f022                	sd	s0,32(sp)
    800029ca:	ec26                	sd	s1,24(sp)
    800029cc:	e84a                	sd	s2,16(sp)
    800029ce:	e44e                	sd	s3,8(sp)
    800029d0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029d2:	00006597          	auipc	a1,0x6
    800029d6:	ce658593          	addi	a1,a1,-794 # 800086b8 <syscall_name+0x168>
    800029da:	00015517          	auipc	a0,0x15
    800029de:	d9e50513          	addi	a0,a0,-610 # 80017778 <itable>
    800029e2:	00003097          	auipc	ra,0x3
    800029e6:	740080e7          	jalr	1856(ra) # 80006122 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029ea:	00015497          	auipc	s1,0x15
    800029ee:	db648493          	addi	s1,s1,-586 # 800177a0 <itable+0x28>
    800029f2:	00017997          	auipc	s3,0x17
    800029f6:	83e98993          	addi	s3,s3,-1986 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029fa:	00006917          	auipc	s2,0x6
    800029fe:	cc690913          	addi	s2,s2,-826 # 800086c0 <syscall_name+0x170>
    80002a02:	85ca                	mv	a1,s2
    80002a04:	8526                	mv	a0,s1
    80002a06:	00001097          	auipc	ra,0x1
    80002a0a:	e46080e7          	jalr	-442(ra) # 8000384c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a0e:	08848493          	addi	s1,s1,136
    80002a12:	ff3498e3          	bne	s1,s3,80002a02 <iinit+0x3e>
}
    80002a16:	70a2                	ld	ra,40(sp)
    80002a18:	7402                	ld	s0,32(sp)
    80002a1a:	64e2                	ld	s1,24(sp)
    80002a1c:	6942                	ld	s2,16(sp)
    80002a1e:	69a2                	ld	s3,8(sp)
    80002a20:	6145                	addi	sp,sp,48
    80002a22:	8082                	ret

0000000080002a24 <ialloc>:
{
    80002a24:	715d                	addi	sp,sp,-80
    80002a26:	e486                	sd	ra,72(sp)
    80002a28:	e0a2                	sd	s0,64(sp)
    80002a2a:	fc26                	sd	s1,56(sp)
    80002a2c:	f84a                	sd	s2,48(sp)
    80002a2e:	f44e                	sd	s3,40(sp)
    80002a30:	f052                	sd	s4,32(sp)
    80002a32:	ec56                	sd	s5,24(sp)
    80002a34:	e85a                	sd	s6,16(sp)
    80002a36:	e45e                	sd	s7,8(sp)
    80002a38:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a3a:	00015717          	auipc	a4,0x15
    80002a3e:	d2a72703          	lw	a4,-726(a4) # 80017764 <sb+0xc>
    80002a42:	4785                	li	a5,1
    80002a44:	04e7fa63          	bgeu	a5,a4,80002a98 <ialloc+0x74>
    80002a48:	8aaa                	mv	s5,a0
    80002a4a:	8bae                	mv	s7,a1
    80002a4c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a4e:	00015a17          	auipc	s4,0x15
    80002a52:	d0aa0a13          	addi	s4,s4,-758 # 80017758 <sb>
    80002a56:	00048b1b          	sext.w	s6,s1
    80002a5a:	0044d593          	srli	a1,s1,0x4
    80002a5e:	018a2783          	lw	a5,24(s4)
    80002a62:	9dbd                	addw	a1,a1,a5
    80002a64:	8556                	mv	a0,s5
    80002a66:	00000097          	auipc	ra,0x0
    80002a6a:	954080e7          	jalr	-1708(ra) # 800023ba <bread>
    80002a6e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a70:	05850993          	addi	s3,a0,88
    80002a74:	00f4f793          	andi	a5,s1,15
    80002a78:	079a                	slli	a5,a5,0x6
    80002a7a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a7c:	00099783          	lh	a5,0(s3)
    80002a80:	c785                	beqz	a5,80002aa8 <ialloc+0x84>
    brelse(bp);
    80002a82:	00000097          	auipc	ra,0x0
    80002a86:	a68080e7          	jalr	-1432(ra) # 800024ea <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a8a:	0485                	addi	s1,s1,1
    80002a8c:	00ca2703          	lw	a4,12(s4)
    80002a90:	0004879b          	sext.w	a5,s1
    80002a94:	fce7e1e3          	bltu	a5,a4,80002a56 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a98:	00006517          	auipc	a0,0x6
    80002a9c:	c3050513          	addi	a0,a0,-976 # 800086c8 <syscall_name+0x178>
    80002aa0:	00003097          	auipc	ra,0x3
    80002aa4:	1c8080e7          	jalr	456(ra) # 80005c68 <panic>
      memset(dip, 0, sizeof(*dip));
    80002aa8:	04000613          	li	a2,64
    80002aac:	4581                	li	a1,0
    80002aae:	854e                	mv	a0,s3
    80002ab0:	ffffd097          	auipc	ra,0xffffd
    80002ab4:	712080e7          	jalr	1810(ra) # 800001c2 <memset>
      dip->type = type;
    80002ab8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002abc:	854a                	mv	a0,s2
    80002abe:	00001097          	auipc	ra,0x1
    80002ac2:	ca8080e7          	jalr	-856(ra) # 80003766 <log_write>
      brelse(bp);
    80002ac6:	854a                	mv	a0,s2
    80002ac8:	00000097          	auipc	ra,0x0
    80002acc:	a22080e7          	jalr	-1502(ra) # 800024ea <brelse>
      return iget(dev, inum);
    80002ad0:	85da                	mv	a1,s6
    80002ad2:	8556                	mv	a0,s5
    80002ad4:	00000097          	auipc	ra,0x0
    80002ad8:	db4080e7          	jalr	-588(ra) # 80002888 <iget>
}
    80002adc:	60a6                	ld	ra,72(sp)
    80002ade:	6406                	ld	s0,64(sp)
    80002ae0:	74e2                	ld	s1,56(sp)
    80002ae2:	7942                	ld	s2,48(sp)
    80002ae4:	79a2                	ld	s3,40(sp)
    80002ae6:	7a02                	ld	s4,32(sp)
    80002ae8:	6ae2                	ld	s5,24(sp)
    80002aea:	6b42                	ld	s6,16(sp)
    80002aec:	6ba2                	ld	s7,8(sp)
    80002aee:	6161                	addi	sp,sp,80
    80002af0:	8082                	ret

0000000080002af2 <iupdate>:
{
    80002af2:	1101                	addi	sp,sp,-32
    80002af4:	ec06                	sd	ra,24(sp)
    80002af6:	e822                	sd	s0,16(sp)
    80002af8:	e426                	sd	s1,8(sp)
    80002afa:	e04a                	sd	s2,0(sp)
    80002afc:	1000                	addi	s0,sp,32
    80002afe:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b00:	415c                	lw	a5,4(a0)
    80002b02:	0047d79b          	srliw	a5,a5,0x4
    80002b06:	00015597          	auipc	a1,0x15
    80002b0a:	c6a5a583          	lw	a1,-918(a1) # 80017770 <sb+0x18>
    80002b0e:	9dbd                	addw	a1,a1,a5
    80002b10:	4108                	lw	a0,0(a0)
    80002b12:	00000097          	auipc	ra,0x0
    80002b16:	8a8080e7          	jalr	-1880(ra) # 800023ba <bread>
    80002b1a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b1c:	05850793          	addi	a5,a0,88
    80002b20:	40c8                	lw	a0,4(s1)
    80002b22:	893d                	andi	a0,a0,15
    80002b24:	051a                	slli	a0,a0,0x6
    80002b26:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b28:	04449703          	lh	a4,68(s1)
    80002b2c:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b30:	04649703          	lh	a4,70(s1)
    80002b34:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b38:	04849703          	lh	a4,72(s1)
    80002b3c:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b40:	04a49703          	lh	a4,74(s1)
    80002b44:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b48:	44f8                	lw	a4,76(s1)
    80002b4a:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b4c:	03400613          	li	a2,52
    80002b50:	05048593          	addi	a1,s1,80
    80002b54:	0531                	addi	a0,a0,12
    80002b56:	ffffd097          	auipc	ra,0xffffd
    80002b5a:	6cc080e7          	jalr	1740(ra) # 80000222 <memmove>
  log_write(bp);
    80002b5e:	854a                	mv	a0,s2
    80002b60:	00001097          	auipc	ra,0x1
    80002b64:	c06080e7          	jalr	-1018(ra) # 80003766 <log_write>
  brelse(bp);
    80002b68:	854a                	mv	a0,s2
    80002b6a:	00000097          	auipc	ra,0x0
    80002b6e:	980080e7          	jalr	-1664(ra) # 800024ea <brelse>
}
    80002b72:	60e2                	ld	ra,24(sp)
    80002b74:	6442                	ld	s0,16(sp)
    80002b76:	64a2                	ld	s1,8(sp)
    80002b78:	6902                	ld	s2,0(sp)
    80002b7a:	6105                	addi	sp,sp,32
    80002b7c:	8082                	ret

0000000080002b7e <idup>:
{
    80002b7e:	1101                	addi	sp,sp,-32
    80002b80:	ec06                	sd	ra,24(sp)
    80002b82:	e822                	sd	s0,16(sp)
    80002b84:	e426                	sd	s1,8(sp)
    80002b86:	1000                	addi	s0,sp,32
    80002b88:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b8a:	00015517          	auipc	a0,0x15
    80002b8e:	bee50513          	addi	a0,a0,-1042 # 80017778 <itable>
    80002b92:	00003097          	auipc	ra,0x3
    80002b96:	620080e7          	jalr	1568(ra) # 800061b2 <acquire>
  ip->ref++;
    80002b9a:	449c                	lw	a5,8(s1)
    80002b9c:	2785                	addiw	a5,a5,1
    80002b9e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ba0:	00015517          	auipc	a0,0x15
    80002ba4:	bd850513          	addi	a0,a0,-1064 # 80017778 <itable>
    80002ba8:	00003097          	auipc	ra,0x3
    80002bac:	6be080e7          	jalr	1726(ra) # 80006266 <release>
}
    80002bb0:	8526                	mv	a0,s1
    80002bb2:	60e2                	ld	ra,24(sp)
    80002bb4:	6442                	ld	s0,16(sp)
    80002bb6:	64a2                	ld	s1,8(sp)
    80002bb8:	6105                	addi	sp,sp,32
    80002bba:	8082                	ret

0000000080002bbc <ilock>:
{
    80002bbc:	1101                	addi	sp,sp,-32
    80002bbe:	ec06                	sd	ra,24(sp)
    80002bc0:	e822                	sd	s0,16(sp)
    80002bc2:	e426                	sd	s1,8(sp)
    80002bc4:	e04a                	sd	s2,0(sp)
    80002bc6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bc8:	c115                	beqz	a0,80002bec <ilock+0x30>
    80002bca:	84aa                	mv	s1,a0
    80002bcc:	451c                	lw	a5,8(a0)
    80002bce:	00f05f63          	blez	a5,80002bec <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bd2:	0541                	addi	a0,a0,16
    80002bd4:	00001097          	auipc	ra,0x1
    80002bd8:	cb2080e7          	jalr	-846(ra) # 80003886 <acquiresleep>
  if(ip->valid == 0){
    80002bdc:	40bc                	lw	a5,64(s1)
    80002bde:	cf99                	beqz	a5,80002bfc <ilock+0x40>
}
    80002be0:	60e2                	ld	ra,24(sp)
    80002be2:	6442                	ld	s0,16(sp)
    80002be4:	64a2                	ld	s1,8(sp)
    80002be6:	6902                	ld	s2,0(sp)
    80002be8:	6105                	addi	sp,sp,32
    80002bea:	8082                	ret
    panic("ilock");
    80002bec:	00006517          	auipc	a0,0x6
    80002bf0:	af450513          	addi	a0,a0,-1292 # 800086e0 <syscall_name+0x190>
    80002bf4:	00003097          	auipc	ra,0x3
    80002bf8:	074080e7          	jalr	116(ra) # 80005c68 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bfc:	40dc                	lw	a5,4(s1)
    80002bfe:	0047d79b          	srliw	a5,a5,0x4
    80002c02:	00015597          	auipc	a1,0x15
    80002c06:	b6e5a583          	lw	a1,-1170(a1) # 80017770 <sb+0x18>
    80002c0a:	9dbd                	addw	a1,a1,a5
    80002c0c:	4088                	lw	a0,0(s1)
    80002c0e:	fffff097          	auipc	ra,0xfffff
    80002c12:	7ac080e7          	jalr	1964(ra) # 800023ba <bread>
    80002c16:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c18:	05850593          	addi	a1,a0,88
    80002c1c:	40dc                	lw	a5,4(s1)
    80002c1e:	8bbd                	andi	a5,a5,15
    80002c20:	079a                	slli	a5,a5,0x6
    80002c22:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c24:	00059783          	lh	a5,0(a1)
    80002c28:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c2c:	00259783          	lh	a5,2(a1)
    80002c30:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c34:	00459783          	lh	a5,4(a1)
    80002c38:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c3c:	00659783          	lh	a5,6(a1)
    80002c40:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c44:	459c                	lw	a5,8(a1)
    80002c46:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c48:	03400613          	li	a2,52
    80002c4c:	05b1                	addi	a1,a1,12
    80002c4e:	05048513          	addi	a0,s1,80
    80002c52:	ffffd097          	auipc	ra,0xffffd
    80002c56:	5d0080e7          	jalr	1488(ra) # 80000222 <memmove>
    brelse(bp);
    80002c5a:	854a                	mv	a0,s2
    80002c5c:	00000097          	auipc	ra,0x0
    80002c60:	88e080e7          	jalr	-1906(ra) # 800024ea <brelse>
    ip->valid = 1;
    80002c64:	4785                	li	a5,1
    80002c66:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c68:	04449783          	lh	a5,68(s1)
    80002c6c:	fbb5                	bnez	a5,80002be0 <ilock+0x24>
      panic("ilock: no type");
    80002c6e:	00006517          	auipc	a0,0x6
    80002c72:	a7a50513          	addi	a0,a0,-1414 # 800086e8 <syscall_name+0x198>
    80002c76:	00003097          	auipc	ra,0x3
    80002c7a:	ff2080e7          	jalr	-14(ra) # 80005c68 <panic>

0000000080002c7e <iunlock>:
{
    80002c7e:	1101                	addi	sp,sp,-32
    80002c80:	ec06                	sd	ra,24(sp)
    80002c82:	e822                	sd	s0,16(sp)
    80002c84:	e426                	sd	s1,8(sp)
    80002c86:	e04a                	sd	s2,0(sp)
    80002c88:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c8a:	c905                	beqz	a0,80002cba <iunlock+0x3c>
    80002c8c:	84aa                	mv	s1,a0
    80002c8e:	01050913          	addi	s2,a0,16
    80002c92:	854a                	mv	a0,s2
    80002c94:	00001097          	auipc	ra,0x1
    80002c98:	c8c080e7          	jalr	-884(ra) # 80003920 <holdingsleep>
    80002c9c:	cd19                	beqz	a0,80002cba <iunlock+0x3c>
    80002c9e:	449c                	lw	a5,8(s1)
    80002ca0:	00f05d63          	blez	a5,80002cba <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ca4:	854a                	mv	a0,s2
    80002ca6:	00001097          	auipc	ra,0x1
    80002caa:	c36080e7          	jalr	-970(ra) # 800038dc <releasesleep>
}
    80002cae:	60e2                	ld	ra,24(sp)
    80002cb0:	6442                	ld	s0,16(sp)
    80002cb2:	64a2                	ld	s1,8(sp)
    80002cb4:	6902                	ld	s2,0(sp)
    80002cb6:	6105                	addi	sp,sp,32
    80002cb8:	8082                	ret
    panic("iunlock");
    80002cba:	00006517          	auipc	a0,0x6
    80002cbe:	a3e50513          	addi	a0,a0,-1474 # 800086f8 <syscall_name+0x1a8>
    80002cc2:	00003097          	auipc	ra,0x3
    80002cc6:	fa6080e7          	jalr	-90(ra) # 80005c68 <panic>

0000000080002cca <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cca:	7179                	addi	sp,sp,-48
    80002ccc:	f406                	sd	ra,40(sp)
    80002cce:	f022                	sd	s0,32(sp)
    80002cd0:	ec26                	sd	s1,24(sp)
    80002cd2:	e84a                	sd	s2,16(sp)
    80002cd4:	e44e                	sd	s3,8(sp)
    80002cd6:	e052                	sd	s4,0(sp)
    80002cd8:	1800                	addi	s0,sp,48
    80002cda:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cdc:	05050493          	addi	s1,a0,80
    80002ce0:	08050913          	addi	s2,a0,128
    80002ce4:	a021                	j	80002cec <itrunc+0x22>
    80002ce6:	0491                	addi	s1,s1,4
    80002ce8:	01248d63          	beq	s1,s2,80002d02 <itrunc+0x38>
    if(ip->addrs[i]){
    80002cec:	408c                	lw	a1,0(s1)
    80002cee:	dde5                	beqz	a1,80002ce6 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cf0:	0009a503          	lw	a0,0(s3)
    80002cf4:	00000097          	auipc	ra,0x0
    80002cf8:	90c080e7          	jalr	-1780(ra) # 80002600 <bfree>
      ip->addrs[i] = 0;
    80002cfc:	0004a023          	sw	zero,0(s1)
    80002d00:	b7dd                	j	80002ce6 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d02:	0809a583          	lw	a1,128(s3)
    80002d06:	e185                	bnez	a1,80002d26 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d08:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d0c:	854e                	mv	a0,s3
    80002d0e:	00000097          	auipc	ra,0x0
    80002d12:	de4080e7          	jalr	-540(ra) # 80002af2 <iupdate>
}
    80002d16:	70a2                	ld	ra,40(sp)
    80002d18:	7402                	ld	s0,32(sp)
    80002d1a:	64e2                	ld	s1,24(sp)
    80002d1c:	6942                	ld	s2,16(sp)
    80002d1e:	69a2                	ld	s3,8(sp)
    80002d20:	6a02                	ld	s4,0(sp)
    80002d22:	6145                	addi	sp,sp,48
    80002d24:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d26:	0009a503          	lw	a0,0(s3)
    80002d2a:	fffff097          	auipc	ra,0xfffff
    80002d2e:	690080e7          	jalr	1680(ra) # 800023ba <bread>
    80002d32:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d34:	05850493          	addi	s1,a0,88
    80002d38:	45850913          	addi	s2,a0,1112
    80002d3c:	a811                	j	80002d50 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d3e:	0009a503          	lw	a0,0(s3)
    80002d42:	00000097          	auipc	ra,0x0
    80002d46:	8be080e7          	jalr	-1858(ra) # 80002600 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d4a:	0491                	addi	s1,s1,4
    80002d4c:	01248563          	beq	s1,s2,80002d56 <itrunc+0x8c>
      if(a[j])
    80002d50:	408c                	lw	a1,0(s1)
    80002d52:	dde5                	beqz	a1,80002d4a <itrunc+0x80>
    80002d54:	b7ed                	j	80002d3e <itrunc+0x74>
    brelse(bp);
    80002d56:	8552                	mv	a0,s4
    80002d58:	fffff097          	auipc	ra,0xfffff
    80002d5c:	792080e7          	jalr	1938(ra) # 800024ea <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d60:	0809a583          	lw	a1,128(s3)
    80002d64:	0009a503          	lw	a0,0(s3)
    80002d68:	00000097          	auipc	ra,0x0
    80002d6c:	898080e7          	jalr	-1896(ra) # 80002600 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d70:	0809a023          	sw	zero,128(s3)
    80002d74:	bf51                	j	80002d08 <itrunc+0x3e>

0000000080002d76 <iput>:
{
    80002d76:	1101                	addi	sp,sp,-32
    80002d78:	ec06                	sd	ra,24(sp)
    80002d7a:	e822                	sd	s0,16(sp)
    80002d7c:	e426                	sd	s1,8(sp)
    80002d7e:	e04a                	sd	s2,0(sp)
    80002d80:	1000                	addi	s0,sp,32
    80002d82:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d84:	00015517          	auipc	a0,0x15
    80002d88:	9f450513          	addi	a0,a0,-1548 # 80017778 <itable>
    80002d8c:	00003097          	auipc	ra,0x3
    80002d90:	426080e7          	jalr	1062(ra) # 800061b2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d94:	4498                	lw	a4,8(s1)
    80002d96:	4785                	li	a5,1
    80002d98:	02f70363          	beq	a4,a5,80002dbe <iput+0x48>
  ip->ref--;
    80002d9c:	449c                	lw	a5,8(s1)
    80002d9e:	37fd                	addiw	a5,a5,-1
    80002da0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002da2:	00015517          	auipc	a0,0x15
    80002da6:	9d650513          	addi	a0,a0,-1578 # 80017778 <itable>
    80002daa:	00003097          	auipc	ra,0x3
    80002dae:	4bc080e7          	jalr	1212(ra) # 80006266 <release>
}
    80002db2:	60e2                	ld	ra,24(sp)
    80002db4:	6442                	ld	s0,16(sp)
    80002db6:	64a2                	ld	s1,8(sp)
    80002db8:	6902                	ld	s2,0(sp)
    80002dba:	6105                	addi	sp,sp,32
    80002dbc:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dbe:	40bc                	lw	a5,64(s1)
    80002dc0:	dff1                	beqz	a5,80002d9c <iput+0x26>
    80002dc2:	04a49783          	lh	a5,74(s1)
    80002dc6:	fbf9                	bnez	a5,80002d9c <iput+0x26>
    acquiresleep(&ip->lock);
    80002dc8:	01048913          	addi	s2,s1,16
    80002dcc:	854a                	mv	a0,s2
    80002dce:	00001097          	auipc	ra,0x1
    80002dd2:	ab8080e7          	jalr	-1352(ra) # 80003886 <acquiresleep>
    release(&itable.lock);
    80002dd6:	00015517          	auipc	a0,0x15
    80002dda:	9a250513          	addi	a0,a0,-1630 # 80017778 <itable>
    80002dde:	00003097          	auipc	ra,0x3
    80002de2:	488080e7          	jalr	1160(ra) # 80006266 <release>
    itrunc(ip);
    80002de6:	8526                	mv	a0,s1
    80002de8:	00000097          	auipc	ra,0x0
    80002dec:	ee2080e7          	jalr	-286(ra) # 80002cca <itrunc>
    ip->type = 0;
    80002df0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002df4:	8526                	mv	a0,s1
    80002df6:	00000097          	auipc	ra,0x0
    80002dfa:	cfc080e7          	jalr	-772(ra) # 80002af2 <iupdate>
    ip->valid = 0;
    80002dfe:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e02:	854a                	mv	a0,s2
    80002e04:	00001097          	auipc	ra,0x1
    80002e08:	ad8080e7          	jalr	-1320(ra) # 800038dc <releasesleep>
    acquire(&itable.lock);
    80002e0c:	00015517          	auipc	a0,0x15
    80002e10:	96c50513          	addi	a0,a0,-1684 # 80017778 <itable>
    80002e14:	00003097          	auipc	ra,0x3
    80002e18:	39e080e7          	jalr	926(ra) # 800061b2 <acquire>
    80002e1c:	b741                	j	80002d9c <iput+0x26>

0000000080002e1e <iunlockput>:
{
    80002e1e:	1101                	addi	sp,sp,-32
    80002e20:	ec06                	sd	ra,24(sp)
    80002e22:	e822                	sd	s0,16(sp)
    80002e24:	e426                	sd	s1,8(sp)
    80002e26:	1000                	addi	s0,sp,32
    80002e28:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e2a:	00000097          	auipc	ra,0x0
    80002e2e:	e54080e7          	jalr	-428(ra) # 80002c7e <iunlock>
  iput(ip);
    80002e32:	8526                	mv	a0,s1
    80002e34:	00000097          	auipc	ra,0x0
    80002e38:	f42080e7          	jalr	-190(ra) # 80002d76 <iput>
}
    80002e3c:	60e2                	ld	ra,24(sp)
    80002e3e:	6442                	ld	s0,16(sp)
    80002e40:	64a2                	ld	s1,8(sp)
    80002e42:	6105                	addi	sp,sp,32
    80002e44:	8082                	ret

0000000080002e46 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e46:	1141                	addi	sp,sp,-16
    80002e48:	e422                	sd	s0,8(sp)
    80002e4a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e4c:	411c                	lw	a5,0(a0)
    80002e4e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e50:	415c                	lw	a5,4(a0)
    80002e52:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e54:	04451783          	lh	a5,68(a0)
    80002e58:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e5c:	04a51783          	lh	a5,74(a0)
    80002e60:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e64:	04c56783          	lwu	a5,76(a0)
    80002e68:	e99c                	sd	a5,16(a1)
}
    80002e6a:	6422                	ld	s0,8(sp)
    80002e6c:	0141                	addi	sp,sp,16
    80002e6e:	8082                	ret

0000000080002e70 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e70:	457c                	lw	a5,76(a0)
    80002e72:	0ed7e963          	bltu	a5,a3,80002f64 <readi+0xf4>
{
    80002e76:	7159                	addi	sp,sp,-112
    80002e78:	f486                	sd	ra,104(sp)
    80002e7a:	f0a2                	sd	s0,96(sp)
    80002e7c:	eca6                	sd	s1,88(sp)
    80002e7e:	e8ca                	sd	s2,80(sp)
    80002e80:	e4ce                	sd	s3,72(sp)
    80002e82:	e0d2                	sd	s4,64(sp)
    80002e84:	fc56                	sd	s5,56(sp)
    80002e86:	f85a                	sd	s6,48(sp)
    80002e88:	f45e                	sd	s7,40(sp)
    80002e8a:	f062                	sd	s8,32(sp)
    80002e8c:	ec66                	sd	s9,24(sp)
    80002e8e:	e86a                	sd	s10,16(sp)
    80002e90:	e46e                	sd	s11,8(sp)
    80002e92:	1880                	addi	s0,sp,112
    80002e94:	8baa                	mv	s7,a0
    80002e96:	8c2e                	mv	s8,a1
    80002e98:	8ab2                	mv	s5,a2
    80002e9a:	84b6                	mv	s1,a3
    80002e9c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e9e:	9f35                	addw	a4,a4,a3
    return 0;
    80002ea0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ea2:	0ad76063          	bltu	a4,a3,80002f42 <readi+0xd2>
  if(off + n > ip->size)
    80002ea6:	00e7f463          	bgeu	a5,a4,80002eae <readi+0x3e>
    n = ip->size - off;
    80002eaa:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eae:	0a0b0963          	beqz	s6,80002f60 <readi+0xf0>
    80002eb2:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eb4:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002eb8:	5cfd                	li	s9,-1
    80002eba:	a82d                	j	80002ef4 <readi+0x84>
    80002ebc:	020a1d93          	slli	s11,s4,0x20
    80002ec0:	020ddd93          	srli	s11,s11,0x20
    80002ec4:	05890613          	addi	a2,s2,88
    80002ec8:	86ee                	mv	a3,s11
    80002eca:	963a                	add	a2,a2,a4
    80002ecc:	85d6                	mv	a1,s5
    80002ece:	8562                	mv	a0,s8
    80002ed0:	fffff097          	auipc	ra,0xfffff
    80002ed4:	a2a080e7          	jalr	-1494(ra) # 800018fa <either_copyout>
    80002ed8:	05950d63          	beq	a0,s9,80002f32 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002edc:	854a                	mv	a0,s2
    80002ede:	fffff097          	auipc	ra,0xfffff
    80002ee2:	60c080e7          	jalr	1548(ra) # 800024ea <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ee6:	013a09bb          	addw	s3,s4,s3
    80002eea:	009a04bb          	addw	s1,s4,s1
    80002eee:	9aee                	add	s5,s5,s11
    80002ef0:	0569f763          	bgeu	s3,s6,80002f3e <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ef4:	000ba903          	lw	s2,0(s7)
    80002ef8:	00a4d59b          	srliw	a1,s1,0xa
    80002efc:	855e                	mv	a0,s7
    80002efe:	00000097          	auipc	ra,0x0
    80002f02:	8b0080e7          	jalr	-1872(ra) # 800027ae <bmap>
    80002f06:	0005059b          	sext.w	a1,a0
    80002f0a:	854a                	mv	a0,s2
    80002f0c:	fffff097          	auipc	ra,0xfffff
    80002f10:	4ae080e7          	jalr	1198(ra) # 800023ba <bread>
    80002f14:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f16:	3ff4f713          	andi	a4,s1,1023
    80002f1a:	40ed07bb          	subw	a5,s10,a4
    80002f1e:	413b06bb          	subw	a3,s6,s3
    80002f22:	8a3e                	mv	s4,a5
    80002f24:	2781                	sext.w	a5,a5
    80002f26:	0006861b          	sext.w	a2,a3
    80002f2a:	f8f679e3          	bgeu	a2,a5,80002ebc <readi+0x4c>
    80002f2e:	8a36                	mv	s4,a3
    80002f30:	b771                	j	80002ebc <readi+0x4c>
      brelse(bp);
    80002f32:	854a                	mv	a0,s2
    80002f34:	fffff097          	auipc	ra,0xfffff
    80002f38:	5b6080e7          	jalr	1462(ra) # 800024ea <brelse>
      tot = -1;
    80002f3c:	59fd                	li	s3,-1
  }
  return tot;
    80002f3e:	0009851b          	sext.w	a0,s3
}
    80002f42:	70a6                	ld	ra,104(sp)
    80002f44:	7406                	ld	s0,96(sp)
    80002f46:	64e6                	ld	s1,88(sp)
    80002f48:	6946                	ld	s2,80(sp)
    80002f4a:	69a6                	ld	s3,72(sp)
    80002f4c:	6a06                	ld	s4,64(sp)
    80002f4e:	7ae2                	ld	s5,56(sp)
    80002f50:	7b42                	ld	s6,48(sp)
    80002f52:	7ba2                	ld	s7,40(sp)
    80002f54:	7c02                	ld	s8,32(sp)
    80002f56:	6ce2                	ld	s9,24(sp)
    80002f58:	6d42                	ld	s10,16(sp)
    80002f5a:	6da2                	ld	s11,8(sp)
    80002f5c:	6165                	addi	sp,sp,112
    80002f5e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f60:	89da                	mv	s3,s6
    80002f62:	bff1                	j	80002f3e <readi+0xce>
    return 0;
    80002f64:	4501                	li	a0,0
}
    80002f66:	8082                	ret

0000000080002f68 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f68:	457c                	lw	a5,76(a0)
    80002f6a:	10d7e863          	bltu	a5,a3,8000307a <writei+0x112>
{
    80002f6e:	7159                	addi	sp,sp,-112
    80002f70:	f486                	sd	ra,104(sp)
    80002f72:	f0a2                	sd	s0,96(sp)
    80002f74:	eca6                	sd	s1,88(sp)
    80002f76:	e8ca                	sd	s2,80(sp)
    80002f78:	e4ce                	sd	s3,72(sp)
    80002f7a:	e0d2                	sd	s4,64(sp)
    80002f7c:	fc56                	sd	s5,56(sp)
    80002f7e:	f85a                	sd	s6,48(sp)
    80002f80:	f45e                	sd	s7,40(sp)
    80002f82:	f062                	sd	s8,32(sp)
    80002f84:	ec66                	sd	s9,24(sp)
    80002f86:	e86a                	sd	s10,16(sp)
    80002f88:	e46e                	sd	s11,8(sp)
    80002f8a:	1880                	addi	s0,sp,112
    80002f8c:	8b2a                	mv	s6,a0
    80002f8e:	8c2e                	mv	s8,a1
    80002f90:	8ab2                	mv	s5,a2
    80002f92:	8936                	mv	s2,a3
    80002f94:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f96:	00e687bb          	addw	a5,a3,a4
    80002f9a:	0ed7e263          	bltu	a5,a3,8000307e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f9e:	00043737          	lui	a4,0x43
    80002fa2:	0ef76063          	bltu	a4,a5,80003082 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fa6:	0c0b8863          	beqz	s7,80003076 <writei+0x10e>
    80002faa:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fac:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fb0:	5cfd                	li	s9,-1
    80002fb2:	a091                	j	80002ff6 <writei+0x8e>
    80002fb4:	02099d93          	slli	s11,s3,0x20
    80002fb8:	020ddd93          	srli	s11,s11,0x20
    80002fbc:	05848513          	addi	a0,s1,88
    80002fc0:	86ee                	mv	a3,s11
    80002fc2:	8656                	mv	a2,s5
    80002fc4:	85e2                	mv	a1,s8
    80002fc6:	953a                	add	a0,a0,a4
    80002fc8:	fffff097          	auipc	ra,0xfffff
    80002fcc:	988080e7          	jalr	-1656(ra) # 80001950 <either_copyin>
    80002fd0:	07950263          	beq	a0,s9,80003034 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fd4:	8526                	mv	a0,s1
    80002fd6:	00000097          	auipc	ra,0x0
    80002fda:	790080e7          	jalr	1936(ra) # 80003766 <log_write>
    brelse(bp);
    80002fde:	8526                	mv	a0,s1
    80002fe0:	fffff097          	auipc	ra,0xfffff
    80002fe4:	50a080e7          	jalr	1290(ra) # 800024ea <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fe8:	01498a3b          	addw	s4,s3,s4
    80002fec:	0129893b          	addw	s2,s3,s2
    80002ff0:	9aee                	add	s5,s5,s11
    80002ff2:	057a7663          	bgeu	s4,s7,8000303e <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ff6:	000b2483          	lw	s1,0(s6)
    80002ffa:	00a9559b          	srliw	a1,s2,0xa
    80002ffe:	855a                	mv	a0,s6
    80003000:	fffff097          	auipc	ra,0xfffff
    80003004:	7ae080e7          	jalr	1966(ra) # 800027ae <bmap>
    80003008:	0005059b          	sext.w	a1,a0
    8000300c:	8526                	mv	a0,s1
    8000300e:	fffff097          	auipc	ra,0xfffff
    80003012:	3ac080e7          	jalr	940(ra) # 800023ba <bread>
    80003016:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003018:	3ff97713          	andi	a4,s2,1023
    8000301c:	40ed07bb          	subw	a5,s10,a4
    80003020:	414b86bb          	subw	a3,s7,s4
    80003024:	89be                	mv	s3,a5
    80003026:	2781                	sext.w	a5,a5
    80003028:	0006861b          	sext.w	a2,a3
    8000302c:	f8f674e3          	bgeu	a2,a5,80002fb4 <writei+0x4c>
    80003030:	89b6                	mv	s3,a3
    80003032:	b749                	j	80002fb4 <writei+0x4c>
      brelse(bp);
    80003034:	8526                	mv	a0,s1
    80003036:	fffff097          	auipc	ra,0xfffff
    8000303a:	4b4080e7          	jalr	1204(ra) # 800024ea <brelse>
  }

  if(off > ip->size)
    8000303e:	04cb2783          	lw	a5,76(s6)
    80003042:	0127f463          	bgeu	a5,s2,8000304a <writei+0xe2>
    ip->size = off;
    80003046:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000304a:	855a                	mv	a0,s6
    8000304c:	00000097          	auipc	ra,0x0
    80003050:	aa6080e7          	jalr	-1370(ra) # 80002af2 <iupdate>

  return tot;
    80003054:	000a051b          	sext.w	a0,s4
}
    80003058:	70a6                	ld	ra,104(sp)
    8000305a:	7406                	ld	s0,96(sp)
    8000305c:	64e6                	ld	s1,88(sp)
    8000305e:	6946                	ld	s2,80(sp)
    80003060:	69a6                	ld	s3,72(sp)
    80003062:	6a06                	ld	s4,64(sp)
    80003064:	7ae2                	ld	s5,56(sp)
    80003066:	7b42                	ld	s6,48(sp)
    80003068:	7ba2                	ld	s7,40(sp)
    8000306a:	7c02                	ld	s8,32(sp)
    8000306c:	6ce2                	ld	s9,24(sp)
    8000306e:	6d42                	ld	s10,16(sp)
    80003070:	6da2                	ld	s11,8(sp)
    80003072:	6165                	addi	sp,sp,112
    80003074:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003076:	8a5e                	mv	s4,s7
    80003078:	bfc9                	j	8000304a <writei+0xe2>
    return -1;
    8000307a:	557d                	li	a0,-1
}
    8000307c:	8082                	ret
    return -1;
    8000307e:	557d                	li	a0,-1
    80003080:	bfe1                	j	80003058 <writei+0xf0>
    return -1;
    80003082:	557d                	li	a0,-1
    80003084:	bfd1                	j	80003058 <writei+0xf0>

0000000080003086 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003086:	1141                	addi	sp,sp,-16
    80003088:	e406                	sd	ra,8(sp)
    8000308a:	e022                	sd	s0,0(sp)
    8000308c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000308e:	4639                	li	a2,14
    80003090:	ffffd097          	auipc	ra,0xffffd
    80003094:	20a080e7          	jalr	522(ra) # 8000029a <strncmp>
}
    80003098:	60a2                	ld	ra,8(sp)
    8000309a:	6402                	ld	s0,0(sp)
    8000309c:	0141                	addi	sp,sp,16
    8000309e:	8082                	ret

00000000800030a0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030a0:	7139                	addi	sp,sp,-64
    800030a2:	fc06                	sd	ra,56(sp)
    800030a4:	f822                	sd	s0,48(sp)
    800030a6:	f426                	sd	s1,40(sp)
    800030a8:	f04a                	sd	s2,32(sp)
    800030aa:	ec4e                	sd	s3,24(sp)
    800030ac:	e852                	sd	s4,16(sp)
    800030ae:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030b0:	04451703          	lh	a4,68(a0)
    800030b4:	4785                	li	a5,1
    800030b6:	00f71a63          	bne	a4,a5,800030ca <dirlookup+0x2a>
    800030ba:	892a                	mv	s2,a0
    800030bc:	89ae                	mv	s3,a1
    800030be:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030c0:	457c                	lw	a5,76(a0)
    800030c2:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030c4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030c6:	e79d                	bnez	a5,800030f4 <dirlookup+0x54>
    800030c8:	a8a5                	j	80003140 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030ca:	00005517          	auipc	a0,0x5
    800030ce:	63650513          	addi	a0,a0,1590 # 80008700 <syscall_name+0x1b0>
    800030d2:	00003097          	auipc	ra,0x3
    800030d6:	b96080e7          	jalr	-1130(ra) # 80005c68 <panic>
      panic("dirlookup read");
    800030da:	00005517          	auipc	a0,0x5
    800030de:	63e50513          	addi	a0,a0,1598 # 80008718 <syscall_name+0x1c8>
    800030e2:	00003097          	auipc	ra,0x3
    800030e6:	b86080e7          	jalr	-1146(ra) # 80005c68 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ea:	24c1                	addiw	s1,s1,16
    800030ec:	04c92783          	lw	a5,76(s2)
    800030f0:	04f4f763          	bgeu	s1,a5,8000313e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030f4:	4741                	li	a4,16
    800030f6:	86a6                	mv	a3,s1
    800030f8:	fc040613          	addi	a2,s0,-64
    800030fc:	4581                	li	a1,0
    800030fe:	854a                	mv	a0,s2
    80003100:	00000097          	auipc	ra,0x0
    80003104:	d70080e7          	jalr	-656(ra) # 80002e70 <readi>
    80003108:	47c1                	li	a5,16
    8000310a:	fcf518e3          	bne	a0,a5,800030da <dirlookup+0x3a>
    if(de.inum == 0)
    8000310e:	fc045783          	lhu	a5,-64(s0)
    80003112:	dfe1                	beqz	a5,800030ea <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003114:	fc240593          	addi	a1,s0,-62
    80003118:	854e                	mv	a0,s3
    8000311a:	00000097          	auipc	ra,0x0
    8000311e:	f6c080e7          	jalr	-148(ra) # 80003086 <namecmp>
    80003122:	f561                	bnez	a0,800030ea <dirlookup+0x4a>
      if(poff)
    80003124:	000a0463          	beqz	s4,8000312c <dirlookup+0x8c>
        *poff = off;
    80003128:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000312c:	fc045583          	lhu	a1,-64(s0)
    80003130:	00092503          	lw	a0,0(s2)
    80003134:	fffff097          	auipc	ra,0xfffff
    80003138:	754080e7          	jalr	1876(ra) # 80002888 <iget>
    8000313c:	a011                	j	80003140 <dirlookup+0xa0>
  return 0;
    8000313e:	4501                	li	a0,0
}
    80003140:	70e2                	ld	ra,56(sp)
    80003142:	7442                	ld	s0,48(sp)
    80003144:	74a2                	ld	s1,40(sp)
    80003146:	7902                	ld	s2,32(sp)
    80003148:	69e2                	ld	s3,24(sp)
    8000314a:	6a42                	ld	s4,16(sp)
    8000314c:	6121                	addi	sp,sp,64
    8000314e:	8082                	ret

0000000080003150 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003150:	711d                	addi	sp,sp,-96
    80003152:	ec86                	sd	ra,88(sp)
    80003154:	e8a2                	sd	s0,80(sp)
    80003156:	e4a6                	sd	s1,72(sp)
    80003158:	e0ca                	sd	s2,64(sp)
    8000315a:	fc4e                	sd	s3,56(sp)
    8000315c:	f852                	sd	s4,48(sp)
    8000315e:	f456                	sd	s5,40(sp)
    80003160:	f05a                	sd	s6,32(sp)
    80003162:	ec5e                	sd	s7,24(sp)
    80003164:	e862                	sd	s8,16(sp)
    80003166:	e466                	sd	s9,8(sp)
    80003168:	1080                	addi	s0,sp,96
    8000316a:	84aa                	mv	s1,a0
    8000316c:	8b2e                	mv	s6,a1
    8000316e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003170:	00054703          	lbu	a4,0(a0)
    80003174:	02f00793          	li	a5,47
    80003178:	02f70363          	beq	a4,a5,8000319e <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000317c:	ffffe097          	auipc	ra,0xffffe
    80003180:	d16080e7          	jalr	-746(ra) # 80000e92 <myproc>
    80003184:	15853503          	ld	a0,344(a0)
    80003188:	00000097          	auipc	ra,0x0
    8000318c:	9f6080e7          	jalr	-1546(ra) # 80002b7e <idup>
    80003190:	89aa                	mv	s3,a0
  while(*path == '/')
    80003192:	02f00913          	li	s2,47
  len = path - s;
    80003196:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003198:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000319a:	4c05                	li	s8,1
    8000319c:	a865                	j	80003254 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000319e:	4585                	li	a1,1
    800031a0:	4505                	li	a0,1
    800031a2:	fffff097          	auipc	ra,0xfffff
    800031a6:	6e6080e7          	jalr	1766(ra) # 80002888 <iget>
    800031aa:	89aa                	mv	s3,a0
    800031ac:	b7dd                	j	80003192 <namex+0x42>
      iunlockput(ip);
    800031ae:	854e                	mv	a0,s3
    800031b0:	00000097          	auipc	ra,0x0
    800031b4:	c6e080e7          	jalr	-914(ra) # 80002e1e <iunlockput>
      return 0;
    800031b8:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031ba:	854e                	mv	a0,s3
    800031bc:	60e6                	ld	ra,88(sp)
    800031be:	6446                	ld	s0,80(sp)
    800031c0:	64a6                	ld	s1,72(sp)
    800031c2:	6906                	ld	s2,64(sp)
    800031c4:	79e2                	ld	s3,56(sp)
    800031c6:	7a42                	ld	s4,48(sp)
    800031c8:	7aa2                	ld	s5,40(sp)
    800031ca:	7b02                	ld	s6,32(sp)
    800031cc:	6be2                	ld	s7,24(sp)
    800031ce:	6c42                	ld	s8,16(sp)
    800031d0:	6ca2                	ld	s9,8(sp)
    800031d2:	6125                	addi	sp,sp,96
    800031d4:	8082                	ret
      iunlock(ip);
    800031d6:	854e                	mv	a0,s3
    800031d8:	00000097          	auipc	ra,0x0
    800031dc:	aa6080e7          	jalr	-1370(ra) # 80002c7e <iunlock>
      return ip;
    800031e0:	bfe9                	j	800031ba <namex+0x6a>
      iunlockput(ip);
    800031e2:	854e                	mv	a0,s3
    800031e4:	00000097          	auipc	ra,0x0
    800031e8:	c3a080e7          	jalr	-966(ra) # 80002e1e <iunlockput>
      return 0;
    800031ec:	89d2                	mv	s3,s4
    800031ee:	b7f1                	j	800031ba <namex+0x6a>
  len = path - s;
    800031f0:	40b48633          	sub	a2,s1,a1
    800031f4:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800031f8:	094cd463          	bge	s9,s4,80003280 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800031fc:	4639                	li	a2,14
    800031fe:	8556                	mv	a0,s5
    80003200:	ffffd097          	auipc	ra,0xffffd
    80003204:	022080e7          	jalr	34(ra) # 80000222 <memmove>
  while(*path == '/')
    80003208:	0004c783          	lbu	a5,0(s1)
    8000320c:	01279763          	bne	a5,s2,8000321a <namex+0xca>
    path++;
    80003210:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003212:	0004c783          	lbu	a5,0(s1)
    80003216:	ff278de3          	beq	a5,s2,80003210 <namex+0xc0>
    ilock(ip);
    8000321a:	854e                	mv	a0,s3
    8000321c:	00000097          	auipc	ra,0x0
    80003220:	9a0080e7          	jalr	-1632(ra) # 80002bbc <ilock>
    if(ip->type != T_DIR){
    80003224:	04499783          	lh	a5,68(s3)
    80003228:	f98793e3          	bne	a5,s8,800031ae <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000322c:	000b0563          	beqz	s6,80003236 <namex+0xe6>
    80003230:	0004c783          	lbu	a5,0(s1)
    80003234:	d3cd                	beqz	a5,800031d6 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003236:	865e                	mv	a2,s7
    80003238:	85d6                	mv	a1,s5
    8000323a:	854e                	mv	a0,s3
    8000323c:	00000097          	auipc	ra,0x0
    80003240:	e64080e7          	jalr	-412(ra) # 800030a0 <dirlookup>
    80003244:	8a2a                	mv	s4,a0
    80003246:	dd51                	beqz	a0,800031e2 <namex+0x92>
    iunlockput(ip);
    80003248:	854e                	mv	a0,s3
    8000324a:	00000097          	auipc	ra,0x0
    8000324e:	bd4080e7          	jalr	-1068(ra) # 80002e1e <iunlockput>
    ip = next;
    80003252:	89d2                	mv	s3,s4
  while(*path == '/')
    80003254:	0004c783          	lbu	a5,0(s1)
    80003258:	05279763          	bne	a5,s2,800032a6 <namex+0x156>
    path++;
    8000325c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000325e:	0004c783          	lbu	a5,0(s1)
    80003262:	ff278de3          	beq	a5,s2,8000325c <namex+0x10c>
  if(*path == 0)
    80003266:	c79d                	beqz	a5,80003294 <namex+0x144>
    path++;
    80003268:	85a6                	mv	a1,s1
  len = path - s;
    8000326a:	8a5e                	mv	s4,s7
    8000326c:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000326e:	01278963          	beq	a5,s2,80003280 <namex+0x130>
    80003272:	dfbd                	beqz	a5,800031f0 <namex+0xa0>
    path++;
    80003274:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003276:	0004c783          	lbu	a5,0(s1)
    8000327a:	ff279ce3          	bne	a5,s2,80003272 <namex+0x122>
    8000327e:	bf8d                	j	800031f0 <namex+0xa0>
    memmove(name, s, len);
    80003280:	2601                	sext.w	a2,a2
    80003282:	8556                	mv	a0,s5
    80003284:	ffffd097          	auipc	ra,0xffffd
    80003288:	f9e080e7          	jalr	-98(ra) # 80000222 <memmove>
    name[len] = 0;
    8000328c:	9a56                	add	s4,s4,s5
    8000328e:	000a0023          	sb	zero,0(s4)
    80003292:	bf9d                	j	80003208 <namex+0xb8>
  if(nameiparent){
    80003294:	f20b03e3          	beqz	s6,800031ba <namex+0x6a>
    iput(ip);
    80003298:	854e                	mv	a0,s3
    8000329a:	00000097          	auipc	ra,0x0
    8000329e:	adc080e7          	jalr	-1316(ra) # 80002d76 <iput>
    return 0;
    800032a2:	4981                	li	s3,0
    800032a4:	bf19                	j	800031ba <namex+0x6a>
  if(*path == 0)
    800032a6:	d7fd                	beqz	a5,80003294 <namex+0x144>
  while(*path != '/' && *path != 0)
    800032a8:	0004c783          	lbu	a5,0(s1)
    800032ac:	85a6                	mv	a1,s1
    800032ae:	b7d1                	j	80003272 <namex+0x122>

00000000800032b0 <dirlink>:
{
    800032b0:	7139                	addi	sp,sp,-64
    800032b2:	fc06                	sd	ra,56(sp)
    800032b4:	f822                	sd	s0,48(sp)
    800032b6:	f426                	sd	s1,40(sp)
    800032b8:	f04a                	sd	s2,32(sp)
    800032ba:	ec4e                	sd	s3,24(sp)
    800032bc:	e852                	sd	s4,16(sp)
    800032be:	0080                	addi	s0,sp,64
    800032c0:	892a                	mv	s2,a0
    800032c2:	8a2e                	mv	s4,a1
    800032c4:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032c6:	4601                	li	a2,0
    800032c8:	00000097          	auipc	ra,0x0
    800032cc:	dd8080e7          	jalr	-552(ra) # 800030a0 <dirlookup>
    800032d0:	e93d                	bnez	a0,80003346 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032d2:	04c92483          	lw	s1,76(s2)
    800032d6:	c49d                	beqz	s1,80003304 <dirlink+0x54>
    800032d8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032da:	4741                	li	a4,16
    800032dc:	86a6                	mv	a3,s1
    800032de:	fc040613          	addi	a2,s0,-64
    800032e2:	4581                	li	a1,0
    800032e4:	854a                	mv	a0,s2
    800032e6:	00000097          	auipc	ra,0x0
    800032ea:	b8a080e7          	jalr	-1142(ra) # 80002e70 <readi>
    800032ee:	47c1                	li	a5,16
    800032f0:	06f51163          	bne	a0,a5,80003352 <dirlink+0xa2>
    if(de.inum == 0)
    800032f4:	fc045783          	lhu	a5,-64(s0)
    800032f8:	c791                	beqz	a5,80003304 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032fa:	24c1                	addiw	s1,s1,16
    800032fc:	04c92783          	lw	a5,76(s2)
    80003300:	fcf4ede3          	bltu	s1,a5,800032da <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003304:	4639                	li	a2,14
    80003306:	85d2                	mv	a1,s4
    80003308:	fc240513          	addi	a0,s0,-62
    8000330c:	ffffd097          	auipc	ra,0xffffd
    80003310:	fca080e7          	jalr	-54(ra) # 800002d6 <strncpy>
  de.inum = inum;
    80003314:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003318:	4741                	li	a4,16
    8000331a:	86a6                	mv	a3,s1
    8000331c:	fc040613          	addi	a2,s0,-64
    80003320:	4581                	li	a1,0
    80003322:	854a                	mv	a0,s2
    80003324:	00000097          	auipc	ra,0x0
    80003328:	c44080e7          	jalr	-956(ra) # 80002f68 <writei>
    8000332c:	872a                	mv	a4,a0
    8000332e:	47c1                	li	a5,16
  return 0;
    80003330:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003332:	02f71863          	bne	a4,a5,80003362 <dirlink+0xb2>
}
    80003336:	70e2                	ld	ra,56(sp)
    80003338:	7442                	ld	s0,48(sp)
    8000333a:	74a2                	ld	s1,40(sp)
    8000333c:	7902                	ld	s2,32(sp)
    8000333e:	69e2                	ld	s3,24(sp)
    80003340:	6a42                	ld	s4,16(sp)
    80003342:	6121                	addi	sp,sp,64
    80003344:	8082                	ret
    iput(ip);
    80003346:	00000097          	auipc	ra,0x0
    8000334a:	a30080e7          	jalr	-1488(ra) # 80002d76 <iput>
    return -1;
    8000334e:	557d                	li	a0,-1
    80003350:	b7dd                	j	80003336 <dirlink+0x86>
      panic("dirlink read");
    80003352:	00005517          	auipc	a0,0x5
    80003356:	3d650513          	addi	a0,a0,982 # 80008728 <syscall_name+0x1d8>
    8000335a:	00003097          	auipc	ra,0x3
    8000335e:	90e080e7          	jalr	-1778(ra) # 80005c68 <panic>
    panic("dirlink");
    80003362:	00005517          	auipc	a0,0x5
    80003366:	4ce50513          	addi	a0,a0,1230 # 80008830 <syscall_name+0x2e0>
    8000336a:	00003097          	auipc	ra,0x3
    8000336e:	8fe080e7          	jalr	-1794(ra) # 80005c68 <panic>

0000000080003372 <namei>:

struct inode*
namei(char *path)
{
    80003372:	1101                	addi	sp,sp,-32
    80003374:	ec06                	sd	ra,24(sp)
    80003376:	e822                	sd	s0,16(sp)
    80003378:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000337a:	fe040613          	addi	a2,s0,-32
    8000337e:	4581                	li	a1,0
    80003380:	00000097          	auipc	ra,0x0
    80003384:	dd0080e7          	jalr	-560(ra) # 80003150 <namex>
}
    80003388:	60e2                	ld	ra,24(sp)
    8000338a:	6442                	ld	s0,16(sp)
    8000338c:	6105                	addi	sp,sp,32
    8000338e:	8082                	ret

0000000080003390 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003390:	1141                	addi	sp,sp,-16
    80003392:	e406                	sd	ra,8(sp)
    80003394:	e022                	sd	s0,0(sp)
    80003396:	0800                	addi	s0,sp,16
    80003398:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000339a:	4585                	li	a1,1
    8000339c:	00000097          	auipc	ra,0x0
    800033a0:	db4080e7          	jalr	-588(ra) # 80003150 <namex>
}
    800033a4:	60a2                	ld	ra,8(sp)
    800033a6:	6402                	ld	s0,0(sp)
    800033a8:	0141                	addi	sp,sp,16
    800033aa:	8082                	ret

00000000800033ac <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033ac:	1101                	addi	sp,sp,-32
    800033ae:	ec06                	sd	ra,24(sp)
    800033b0:	e822                	sd	s0,16(sp)
    800033b2:	e426                	sd	s1,8(sp)
    800033b4:	e04a                	sd	s2,0(sp)
    800033b6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033b8:	00016917          	auipc	s2,0x16
    800033bc:	e6890913          	addi	s2,s2,-408 # 80019220 <log>
    800033c0:	01892583          	lw	a1,24(s2)
    800033c4:	02892503          	lw	a0,40(s2)
    800033c8:	fffff097          	auipc	ra,0xfffff
    800033cc:	ff2080e7          	jalr	-14(ra) # 800023ba <bread>
    800033d0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033d2:	02c92683          	lw	a3,44(s2)
    800033d6:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033d8:	02d05763          	blez	a3,80003406 <write_head+0x5a>
    800033dc:	00016797          	auipc	a5,0x16
    800033e0:	e7478793          	addi	a5,a5,-396 # 80019250 <log+0x30>
    800033e4:	05c50713          	addi	a4,a0,92
    800033e8:	36fd                	addiw	a3,a3,-1
    800033ea:	1682                	slli	a3,a3,0x20
    800033ec:	9281                	srli	a3,a3,0x20
    800033ee:	068a                	slli	a3,a3,0x2
    800033f0:	00016617          	auipc	a2,0x16
    800033f4:	e6460613          	addi	a2,a2,-412 # 80019254 <log+0x34>
    800033f8:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033fa:	4390                	lw	a2,0(a5)
    800033fc:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033fe:	0791                	addi	a5,a5,4
    80003400:	0711                	addi	a4,a4,4
    80003402:	fed79ce3          	bne	a5,a3,800033fa <write_head+0x4e>
  }
  bwrite(buf);
    80003406:	8526                	mv	a0,s1
    80003408:	fffff097          	auipc	ra,0xfffff
    8000340c:	0a4080e7          	jalr	164(ra) # 800024ac <bwrite>
  brelse(buf);
    80003410:	8526                	mv	a0,s1
    80003412:	fffff097          	auipc	ra,0xfffff
    80003416:	0d8080e7          	jalr	216(ra) # 800024ea <brelse>
}
    8000341a:	60e2                	ld	ra,24(sp)
    8000341c:	6442                	ld	s0,16(sp)
    8000341e:	64a2                	ld	s1,8(sp)
    80003420:	6902                	ld	s2,0(sp)
    80003422:	6105                	addi	sp,sp,32
    80003424:	8082                	ret

0000000080003426 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003426:	00016797          	auipc	a5,0x16
    8000342a:	e267a783          	lw	a5,-474(a5) # 8001924c <log+0x2c>
    8000342e:	0af05d63          	blez	a5,800034e8 <install_trans+0xc2>
{
    80003432:	7139                	addi	sp,sp,-64
    80003434:	fc06                	sd	ra,56(sp)
    80003436:	f822                	sd	s0,48(sp)
    80003438:	f426                	sd	s1,40(sp)
    8000343a:	f04a                	sd	s2,32(sp)
    8000343c:	ec4e                	sd	s3,24(sp)
    8000343e:	e852                	sd	s4,16(sp)
    80003440:	e456                	sd	s5,8(sp)
    80003442:	e05a                	sd	s6,0(sp)
    80003444:	0080                	addi	s0,sp,64
    80003446:	8b2a                	mv	s6,a0
    80003448:	00016a97          	auipc	s5,0x16
    8000344c:	e08a8a93          	addi	s5,s5,-504 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003450:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003452:	00016997          	auipc	s3,0x16
    80003456:	dce98993          	addi	s3,s3,-562 # 80019220 <log>
    8000345a:	a035                	j	80003486 <install_trans+0x60>
      bunpin(dbuf);
    8000345c:	8526                	mv	a0,s1
    8000345e:	fffff097          	auipc	ra,0xfffff
    80003462:	166080e7          	jalr	358(ra) # 800025c4 <bunpin>
    brelse(lbuf);
    80003466:	854a                	mv	a0,s2
    80003468:	fffff097          	auipc	ra,0xfffff
    8000346c:	082080e7          	jalr	130(ra) # 800024ea <brelse>
    brelse(dbuf);
    80003470:	8526                	mv	a0,s1
    80003472:	fffff097          	auipc	ra,0xfffff
    80003476:	078080e7          	jalr	120(ra) # 800024ea <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000347a:	2a05                	addiw	s4,s4,1
    8000347c:	0a91                	addi	s5,s5,4
    8000347e:	02c9a783          	lw	a5,44(s3)
    80003482:	04fa5963          	bge	s4,a5,800034d4 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003486:	0189a583          	lw	a1,24(s3)
    8000348a:	014585bb          	addw	a1,a1,s4
    8000348e:	2585                	addiw	a1,a1,1
    80003490:	0289a503          	lw	a0,40(s3)
    80003494:	fffff097          	auipc	ra,0xfffff
    80003498:	f26080e7          	jalr	-218(ra) # 800023ba <bread>
    8000349c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000349e:	000aa583          	lw	a1,0(s5)
    800034a2:	0289a503          	lw	a0,40(s3)
    800034a6:	fffff097          	auipc	ra,0xfffff
    800034aa:	f14080e7          	jalr	-236(ra) # 800023ba <bread>
    800034ae:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034b0:	40000613          	li	a2,1024
    800034b4:	05890593          	addi	a1,s2,88
    800034b8:	05850513          	addi	a0,a0,88
    800034bc:	ffffd097          	auipc	ra,0xffffd
    800034c0:	d66080e7          	jalr	-666(ra) # 80000222 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034c4:	8526                	mv	a0,s1
    800034c6:	fffff097          	auipc	ra,0xfffff
    800034ca:	fe6080e7          	jalr	-26(ra) # 800024ac <bwrite>
    if(recovering == 0)
    800034ce:	f80b1ce3          	bnez	s6,80003466 <install_trans+0x40>
    800034d2:	b769                	j	8000345c <install_trans+0x36>
}
    800034d4:	70e2                	ld	ra,56(sp)
    800034d6:	7442                	ld	s0,48(sp)
    800034d8:	74a2                	ld	s1,40(sp)
    800034da:	7902                	ld	s2,32(sp)
    800034dc:	69e2                	ld	s3,24(sp)
    800034de:	6a42                	ld	s4,16(sp)
    800034e0:	6aa2                	ld	s5,8(sp)
    800034e2:	6b02                	ld	s6,0(sp)
    800034e4:	6121                	addi	sp,sp,64
    800034e6:	8082                	ret
    800034e8:	8082                	ret

00000000800034ea <initlog>:
{
    800034ea:	7179                	addi	sp,sp,-48
    800034ec:	f406                	sd	ra,40(sp)
    800034ee:	f022                	sd	s0,32(sp)
    800034f0:	ec26                	sd	s1,24(sp)
    800034f2:	e84a                	sd	s2,16(sp)
    800034f4:	e44e                	sd	s3,8(sp)
    800034f6:	1800                	addi	s0,sp,48
    800034f8:	892a                	mv	s2,a0
    800034fa:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034fc:	00016497          	auipc	s1,0x16
    80003500:	d2448493          	addi	s1,s1,-732 # 80019220 <log>
    80003504:	00005597          	auipc	a1,0x5
    80003508:	23458593          	addi	a1,a1,564 # 80008738 <syscall_name+0x1e8>
    8000350c:	8526                	mv	a0,s1
    8000350e:	00003097          	auipc	ra,0x3
    80003512:	c14080e7          	jalr	-1004(ra) # 80006122 <initlock>
  log.start = sb->logstart;
    80003516:	0149a583          	lw	a1,20(s3)
    8000351a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000351c:	0109a783          	lw	a5,16(s3)
    80003520:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003522:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003526:	854a                	mv	a0,s2
    80003528:	fffff097          	auipc	ra,0xfffff
    8000352c:	e92080e7          	jalr	-366(ra) # 800023ba <bread>
  log.lh.n = lh->n;
    80003530:	4d3c                	lw	a5,88(a0)
    80003532:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003534:	02f05563          	blez	a5,8000355e <initlog+0x74>
    80003538:	05c50713          	addi	a4,a0,92
    8000353c:	00016697          	auipc	a3,0x16
    80003540:	d1468693          	addi	a3,a3,-748 # 80019250 <log+0x30>
    80003544:	37fd                	addiw	a5,a5,-1
    80003546:	1782                	slli	a5,a5,0x20
    80003548:	9381                	srli	a5,a5,0x20
    8000354a:	078a                	slli	a5,a5,0x2
    8000354c:	06050613          	addi	a2,a0,96
    80003550:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003552:	4310                	lw	a2,0(a4)
    80003554:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003556:	0711                	addi	a4,a4,4
    80003558:	0691                	addi	a3,a3,4
    8000355a:	fef71ce3          	bne	a4,a5,80003552 <initlog+0x68>
  brelse(buf);
    8000355e:	fffff097          	auipc	ra,0xfffff
    80003562:	f8c080e7          	jalr	-116(ra) # 800024ea <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003566:	4505                	li	a0,1
    80003568:	00000097          	auipc	ra,0x0
    8000356c:	ebe080e7          	jalr	-322(ra) # 80003426 <install_trans>
  log.lh.n = 0;
    80003570:	00016797          	auipc	a5,0x16
    80003574:	cc07ae23          	sw	zero,-804(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    80003578:	00000097          	auipc	ra,0x0
    8000357c:	e34080e7          	jalr	-460(ra) # 800033ac <write_head>
}
    80003580:	70a2                	ld	ra,40(sp)
    80003582:	7402                	ld	s0,32(sp)
    80003584:	64e2                	ld	s1,24(sp)
    80003586:	6942                	ld	s2,16(sp)
    80003588:	69a2                	ld	s3,8(sp)
    8000358a:	6145                	addi	sp,sp,48
    8000358c:	8082                	ret

000000008000358e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000358e:	1101                	addi	sp,sp,-32
    80003590:	ec06                	sd	ra,24(sp)
    80003592:	e822                	sd	s0,16(sp)
    80003594:	e426                	sd	s1,8(sp)
    80003596:	e04a                	sd	s2,0(sp)
    80003598:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000359a:	00016517          	auipc	a0,0x16
    8000359e:	c8650513          	addi	a0,a0,-890 # 80019220 <log>
    800035a2:	00003097          	auipc	ra,0x3
    800035a6:	c10080e7          	jalr	-1008(ra) # 800061b2 <acquire>
  while(1){
    if(log.committing){
    800035aa:	00016497          	auipc	s1,0x16
    800035ae:	c7648493          	addi	s1,s1,-906 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035b2:	4979                	li	s2,30
    800035b4:	a039                	j	800035c2 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035b6:	85a6                	mv	a1,s1
    800035b8:	8526                	mv	a0,s1
    800035ba:	ffffe097          	auipc	ra,0xffffe
    800035be:	f9c080e7          	jalr	-100(ra) # 80001556 <sleep>
    if(log.committing){
    800035c2:	50dc                	lw	a5,36(s1)
    800035c4:	fbed                	bnez	a5,800035b6 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035c6:	509c                	lw	a5,32(s1)
    800035c8:	0017871b          	addiw	a4,a5,1
    800035cc:	0007069b          	sext.w	a3,a4
    800035d0:	0027179b          	slliw	a5,a4,0x2
    800035d4:	9fb9                	addw	a5,a5,a4
    800035d6:	0017979b          	slliw	a5,a5,0x1
    800035da:	54d8                	lw	a4,44(s1)
    800035dc:	9fb9                	addw	a5,a5,a4
    800035de:	00f95963          	bge	s2,a5,800035f0 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035e2:	85a6                	mv	a1,s1
    800035e4:	8526                	mv	a0,s1
    800035e6:	ffffe097          	auipc	ra,0xffffe
    800035ea:	f70080e7          	jalr	-144(ra) # 80001556 <sleep>
    800035ee:	bfd1                	j	800035c2 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035f0:	00016517          	auipc	a0,0x16
    800035f4:	c3050513          	addi	a0,a0,-976 # 80019220 <log>
    800035f8:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035fa:	00003097          	auipc	ra,0x3
    800035fe:	c6c080e7          	jalr	-916(ra) # 80006266 <release>
      break;
    }
  }
}
    80003602:	60e2                	ld	ra,24(sp)
    80003604:	6442                	ld	s0,16(sp)
    80003606:	64a2                	ld	s1,8(sp)
    80003608:	6902                	ld	s2,0(sp)
    8000360a:	6105                	addi	sp,sp,32
    8000360c:	8082                	ret

000000008000360e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000360e:	7139                	addi	sp,sp,-64
    80003610:	fc06                	sd	ra,56(sp)
    80003612:	f822                	sd	s0,48(sp)
    80003614:	f426                	sd	s1,40(sp)
    80003616:	f04a                	sd	s2,32(sp)
    80003618:	ec4e                	sd	s3,24(sp)
    8000361a:	e852                	sd	s4,16(sp)
    8000361c:	e456                	sd	s5,8(sp)
    8000361e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003620:	00016497          	auipc	s1,0x16
    80003624:	c0048493          	addi	s1,s1,-1024 # 80019220 <log>
    80003628:	8526                	mv	a0,s1
    8000362a:	00003097          	auipc	ra,0x3
    8000362e:	b88080e7          	jalr	-1144(ra) # 800061b2 <acquire>
  log.outstanding -= 1;
    80003632:	509c                	lw	a5,32(s1)
    80003634:	37fd                	addiw	a5,a5,-1
    80003636:	0007891b          	sext.w	s2,a5
    8000363a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000363c:	50dc                	lw	a5,36(s1)
    8000363e:	efb9                	bnez	a5,8000369c <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003640:	06091663          	bnez	s2,800036ac <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003644:	00016497          	auipc	s1,0x16
    80003648:	bdc48493          	addi	s1,s1,-1060 # 80019220 <log>
    8000364c:	4785                	li	a5,1
    8000364e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003650:	8526                	mv	a0,s1
    80003652:	00003097          	auipc	ra,0x3
    80003656:	c14080e7          	jalr	-1004(ra) # 80006266 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000365a:	54dc                	lw	a5,44(s1)
    8000365c:	06f04763          	bgtz	a5,800036ca <end_op+0xbc>
    acquire(&log.lock);
    80003660:	00016497          	auipc	s1,0x16
    80003664:	bc048493          	addi	s1,s1,-1088 # 80019220 <log>
    80003668:	8526                	mv	a0,s1
    8000366a:	00003097          	auipc	ra,0x3
    8000366e:	b48080e7          	jalr	-1208(ra) # 800061b2 <acquire>
    log.committing = 0;
    80003672:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003676:	8526                	mv	a0,s1
    80003678:	ffffe097          	auipc	ra,0xffffe
    8000367c:	06a080e7          	jalr	106(ra) # 800016e2 <wakeup>
    release(&log.lock);
    80003680:	8526                	mv	a0,s1
    80003682:	00003097          	auipc	ra,0x3
    80003686:	be4080e7          	jalr	-1052(ra) # 80006266 <release>
}
    8000368a:	70e2                	ld	ra,56(sp)
    8000368c:	7442                	ld	s0,48(sp)
    8000368e:	74a2                	ld	s1,40(sp)
    80003690:	7902                	ld	s2,32(sp)
    80003692:	69e2                	ld	s3,24(sp)
    80003694:	6a42                	ld	s4,16(sp)
    80003696:	6aa2                	ld	s5,8(sp)
    80003698:	6121                	addi	sp,sp,64
    8000369a:	8082                	ret
    panic("log.committing");
    8000369c:	00005517          	auipc	a0,0x5
    800036a0:	0a450513          	addi	a0,a0,164 # 80008740 <syscall_name+0x1f0>
    800036a4:	00002097          	auipc	ra,0x2
    800036a8:	5c4080e7          	jalr	1476(ra) # 80005c68 <panic>
    wakeup(&log);
    800036ac:	00016497          	auipc	s1,0x16
    800036b0:	b7448493          	addi	s1,s1,-1164 # 80019220 <log>
    800036b4:	8526                	mv	a0,s1
    800036b6:	ffffe097          	auipc	ra,0xffffe
    800036ba:	02c080e7          	jalr	44(ra) # 800016e2 <wakeup>
  release(&log.lock);
    800036be:	8526                	mv	a0,s1
    800036c0:	00003097          	auipc	ra,0x3
    800036c4:	ba6080e7          	jalr	-1114(ra) # 80006266 <release>
  if(do_commit){
    800036c8:	b7c9                	j	8000368a <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036ca:	00016a97          	auipc	s5,0x16
    800036ce:	b86a8a93          	addi	s5,s5,-1146 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036d2:	00016a17          	auipc	s4,0x16
    800036d6:	b4ea0a13          	addi	s4,s4,-1202 # 80019220 <log>
    800036da:	018a2583          	lw	a1,24(s4)
    800036de:	012585bb          	addw	a1,a1,s2
    800036e2:	2585                	addiw	a1,a1,1
    800036e4:	028a2503          	lw	a0,40(s4)
    800036e8:	fffff097          	auipc	ra,0xfffff
    800036ec:	cd2080e7          	jalr	-814(ra) # 800023ba <bread>
    800036f0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036f2:	000aa583          	lw	a1,0(s5)
    800036f6:	028a2503          	lw	a0,40(s4)
    800036fa:	fffff097          	auipc	ra,0xfffff
    800036fe:	cc0080e7          	jalr	-832(ra) # 800023ba <bread>
    80003702:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003704:	40000613          	li	a2,1024
    80003708:	05850593          	addi	a1,a0,88
    8000370c:	05848513          	addi	a0,s1,88
    80003710:	ffffd097          	auipc	ra,0xffffd
    80003714:	b12080e7          	jalr	-1262(ra) # 80000222 <memmove>
    bwrite(to);  // write the log
    80003718:	8526                	mv	a0,s1
    8000371a:	fffff097          	auipc	ra,0xfffff
    8000371e:	d92080e7          	jalr	-622(ra) # 800024ac <bwrite>
    brelse(from);
    80003722:	854e                	mv	a0,s3
    80003724:	fffff097          	auipc	ra,0xfffff
    80003728:	dc6080e7          	jalr	-570(ra) # 800024ea <brelse>
    brelse(to);
    8000372c:	8526                	mv	a0,s1
    8000372e:	fffff097          	auipc	ra,0xfffff
    80003732:	dbc080e7          	jalr	-580(ra) # 800024ea <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003736:	2905                	addiw	s2,s2,1
    80003738:	0a91                	addi	s5,s5,4
    8000373a:	02ca2783          	lw	a5,44(s4)
    8000373e:	f8f94ee3          	blt	s2,a5,800036da <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003742:	00000097          	auipc	ra,0x0
    80003746:	c6a080e7          	jalr	-918(ra) # 800033ac <write_head>
    install_trans(0); // Now install writes to home locations
    8000374a:	4501                	li	a0,0
    8000374c:	00000097          	auipc	ra,0x0
    80003750:	cda080e7          	jalr	-806(ra) # 80003426 <install_trans>
    log.lh.n = 0;
    80003754:	00016797          	auipc	a5,0x16
    80003758:	ae07ac23          	sw	zero,-1288(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000375c:	00000097          	auipc	ra,0x0
    80003760:	c50080e7          	jalr	-944(ra) # 800033ac <write_head>
    80003764:	bdf5                	j	80003660 <end_op+0x52>

0000000080003766 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003766:	1101                	addi	sp,sp,-32
    80003768:	ec06                	sd	ra,24(sp)
    8000376a:	e822                	sd	s0,16(sp)
    8000376c:	e426                	sd	s1,8(sp)
    8000376e:	e04a                	sd	s2,0(sp)
    80003770:	1000                	addi	s0,sp,32
    80003772:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003774:	00016917          	auipc	s2,0x16
    80003778:	aac90913          	addi	s2,s2,-1364 # 80019220 <log>
    8000377c:	854a                	mv	a0,s2
    8000377e:	00003097          	auipc	ra,0x3
    80003782:	a34080e7          	jalr	-1484(ra) # 800061b2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003786:	02c92603          	lw	a2,44(s2)
    8000378a:	47f5                	li	a5,29
    8000378c:	06c7c563          	blt	a5,a2,800037f6 <log_write+0x90>
    80003790:	00016797          	auipc	a5,0x16
    80003794:	aac7a783          	lw	a5,-1364(a5) # 8001923c <log+0x1c>
    80003798:	37fd                	addiw	a5,a5,-1
    8000379a:	04f65e63          	bge	a2,a5,800037f6 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000379e:	00016797          	auipc	a5,0x16
    800037a2:	aa27a783          	lw	a5,-1374(a5) # 80019240 <log+0x20>
    800037a6:	06f05063          	blez	a5,80003806 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037aa:	4781                	li	a5,0
    800037ac:	06c05563          	blez	a2,80003816 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037b0:	44cc                	lw	a1,12(s1)
    800037b2:	00016717          	auipc	a4,0x16
    800037b6:	a9e70713          	addi	a4,a4,-1378 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037ba:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037bc:	4314                	lw	a3,0(a4)
    800037be:	04b68c63          	beq	a3,a1,80003816 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037c2:	2785                	addiw	a5,a5,1
    800037c4:	0711                	addi	a4,a4,4
    800037c6:	fef61be3          	bne	a2,a5,800037bc <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037ca:	0621                	addi	a2,a2,8
    800037cc:	060a                	slli	a2,a2,0x2
    800037ce:	00016797          	auipc	a5,0x16
    800037d2:	a5278793          	addi	a5,a5,-1454 # 80019220 <log>
    800037d6:	963e                	add	a2,a2,a5
    800037d8:	44dc                	lw	a5,12(s1)
    800037da:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037dc:	8526                	mv	a0,s1
    800037de:	fffff097          	auipc	ra,0xfffff
    800037e2:	daa080e7          	jalr	-598(ra) # 80002588 <bpin>
    log.lh.n++;
    800037e6:	00016717          	auipc	a4,0x16
    800037ea:	a3a70713          	addi	a4,a4,-1478 # 80019220 <log>
    800037ee:	575c                	lw	a5,44(a4)
    800037f0:	2785                	addiw	a5,a5,1
    800037f2:	d75c                	sw	a5,44(a4)
    800037f4:	a835                	j	80003830 <log_write+0xca>
    panic("too big a transaction");
    800037f6:	00005517          	auipc	a0,0x5
    800037fa:	f5a50513          	addi	a0,a0,-166 # 80008750 <syscall_name+0x200>
    800037fe:	00002097          	auipc	ra,0x2
    80003802:	46a080e7          	jalr	1130(ra) # 80005c68 <panic>
    panic("log_write outside of trans");
    80003806:	00005517          	auipc	a0,0x5
    8000380a:	f6250513          	addi	a0,a0,-158 # 80008768 <syscall_name+0x218>
    8000380e:	00002097          	auipc	ra,0x2
    80003812:	45a080e7          	jalr	1114(ra) # 80005c68 <panic>
  log.lh.block[i] = b->blockno;
    80003816:	00878713          	addi	a4,a5,8
    8000381a:	00271693          	slli	a3,a4,0x2
    8000381e:	00016717          	auipc	a4,0x16
    80003822:	a0270713          	addi	a4,a4,-1534 # 80019220 <log>
    80003826:	9736                	add	a4,a4,a3
    80003828:	44d4                	lw	a3,12(s1)
    8000382a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000382c:	faf608e3          	beq	a2,a5,800037dc <log_write+0x76>
  }
  release(&log.lock);
    80003830:	00016517          	auipc	a0,0x16
    80003834:	9f050513          	addi	a0,a0,-1552 # 80019220 <log>
    80003838:	00003097          	auipc	ra,0x3
    8000383c:	a2e080e7          	jalr	-1490(ra) # 80006266 <release>
}
    80003840:	60e2                	ld	ra,24(sp)
    80003842:	6442                	ld	s0,16(sp)
    80003844:	64a2                	ld	s1,8(sp)
    80003846:	6902                	ld	s2,0(sp)
    80003848:	6105                	addi	sp,sp,32
    8000384a:	8082                	ret

000000008000384c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000384c:	1101                	addi	sp,sp,-32
    8000384e:	ec06                	sd	ra,24(sp)
    80003850:	e822                	sd	s0,16(sp)
    80003852:	e426                	sd	s1,8(sp)
    80003854:	e04a                	sd	s2,0(sp)
    80003856:	1000                	addi	s0,sp,32
    80003858:	84aa                	mv	s1,a0
    8000385a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000385c:	00005597          	auipc	a1,0x5
    80003860:	f2c58593          	addi	a1,a1,-212 # 80008788 <syscall_name+0x238>
    80003864:	0521                	addi	a0,a0,8
    80003866:	00003097          	auipc	ra,0x3
    8000386a:	8bc080e7          	jalr	-1860(ra) # 80006122 <initlock>
  lk->name = name;
    8000386e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003872:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003876:	0204a423          	sw	zero,40(s1)
}
    8000387a:	60e2                	ld	ra,24(sp)
    8000387c:	6442                	ld	s0,16(sp)
    8000387e:	64a2                	ld	s1,8(sp)
    80003880:	6902                	ld	s2,0(sp)
    80003882:	6105                	addi	sp,sp,32
    80003884:	8082                	ret

0000000080003886 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003886:	1101                	addi	sp,sp,-32
    80003888:	ec06                	sd	ra,24(sp)
    8000388a:	e822                	sd	s0,16(sp)
    8000388c:	e426                	sd	s1,8(sp)
    8000388e:	e04a                	sd	s2,0(sp)
    80003890:	1000                	addi	s0,sp,32
    80003892:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003894:	00850913          	addi	s2,a0,8
    80003898:	854a                	mv	a0,s2
    8000389a:	00003097          	auipc	ra,0x3
    8000389e:	918080e7          	jalr	-1768(ra) # 800061b2 <acquire>
  while (lk->locked) {
    800038a2:	409c                	lw	a5,0(s1)
    800038a4:	cb89                	beqz	a5,800038b6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038a6:	85ca                	mv	a1,s2
    800038a8:	8526                	mv	a0,s1
    800038aa:	ffffe097          	auipc	ra,0xffffe
    800038ae:	cac080e7          	jalr	-852(ra) # 80001556 <sleep>
  while (lk->locked) {
    800038b2:	409c                	lw	a5,0(s1)
    800038b4:	fbed                	bnez	a5,800038a6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038b6:	4785                	li	a5,1
    800038b8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038ba:	ffffd097          	auipc	ra,0xffffd
    800038be:	5d8080e7          	jalr	1496(ra) # 80000e92 <myproc>
    800038c2:	591c                	lw	a5,48(a0)
    800038c4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038c6:	854a                	mv	a0,s2
    800038c8:	00003097          	auipc	ra,0x3
    800038cc:	99e080e7          	jalr	-1634(ra) # 80006266 <release>
}
    800038d0:	60e2                	ld	ra,24(sp)
    800038d2:	6442                	ld	s0,16(sp)
    800038d4:	64a2                	ld	s1,8(sp)
    800038d6:	6902                	ld	s2,0(sp)
    800038d8:	6105                	addi	sp,sp,32
    800038da:	8082                	ret

00000000800038dc <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038dc:	1101                	addi	sp,sp,-32
    800038de:	ec06                	sd	ra,24(sp)
    800038e0:	e822                	sd	s0,16(sp)
    800038e2:	e426                	sd	s1,8(sp)
    800038e4:	e04a                	sd	s2,0(sp)
    800038e6:	1000                	addi	s0,sp,32
    800038e8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038ea:	00850913          	addi	s2,a0,8
    800038ee:	854a                	mv	a0,s2
    800038f0:	00003097          	auipc	ra,0x3
    800038f4:	8c2080e7          	jalr	-1854(ra) # 800061b2 <acquire>
  lk->locked = 0;
    800038f8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038fc:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003900:	8526                	mv	a0,s1
    80003902:	ffffe097          	auipc	ra,0xffffe
    80003906:	de0080e7          	jalr	-544(ra) # 800016e2 <wakeup>
  release(&lk->lk);
    8000390a:	854a                	mv	a0,s2
    8000390c:	00003097          	auipc	ra,0x3
    80003910:	95a080e7          	jalr	-1702(ra) # 80006266 <release>
}
    80003914:	60e2                	ld	ra,24(sp)
    80003916:	6442                	ld	s0,16(sp)
    80003918:	64a2                	ld	s1,8(sp)
    8000391a:	6902                	ld	s2,0(sp)
    8000391c:	6105                	addi	sp,sp,32
    8000391e:	8082                	ret

0000000080003920 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003920:	7179                	addi	sp,sp,-48
    80003922:	f406                	sd	ra,40(sp)
    80003924:	f022                	sd	s0,32(sp)
    80003926:	ec26                	sd	s1,24(sp)
    80003928:	e84a                	sd	s2,16(sp)
    8000392a:	e44e                	sd	s3,8(sp)
    8000392c:	1800                	addi	s0,sp,48
    8000392e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003930:	00850913          	addi	s2,a0,8
    80003934:	854a                	mv	a0,s2
    80003936:	00003097          	auipc	ra,0x3
    8000393a:	87c080e7          	jalr	-1924(ra) # 800061b2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000393e:	409c                	lw	a5,0(s1)
    80003940:	ef99                	bnez	a5,8000395e <holdingsleep+0x3e>
    80003942:	4481                	li	s1,0
  release(&lk->lk);
    80003944:	854a                	mv	a0,s2
    80003946:	00003097          	auipc	ra,0x3
    8000394a:	920080e7          	jalr	-1760(ra) # 80006266 <release>
  return r;
}
    8000394e:	8526                	mv	a0,s1
    80003950:	70a2                	ld	ra,40(sp)
    80003952:	7402                	ld	s0,32(sp)
    80003954:	64e2                	ld	s1,24(sp)
    80003956:	6942                	ld	s2,16(sp)
    80003958:	69a2                	ld	s3,8(sp)
    8000395a:	6145                	addi	sp,sp,48
    8000395c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000395e:	0284a983          	lw	s3,40(s1)
    80003962:	ffffd097          	auipc	ra,0xffffd
    80003966:	530080e7          	jalr	1328(ra) # 80000e92 <myproc>
    8000396a:	5904                	lw	s1,48(a0)
    8000396c:	413484b3          	sub	s1,s1,s3
    80003970:	0014b493          	seqz	s1,s1
    80003974:	bfc1                	j	80003944 <holdingsleep+0x24>

0000000080003976 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003976:	1141                	addi	sp,sp,-16
    80003978:	e406                	sd	ra,8(sp)
    8000397a:	e022                	sd	s0,0(sp)
    8000397c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000397e:	00005597          	auipc	a1,0x5
    80003982:	e1a58593          	addi	a1,a1,-486 # 80008798 <syscall_name+0x248>
    80003986:	00016517          	auipc	a0,0x16
    8000398a:	9e250513          	addi	a0,a0,-1566 # 80019368 <ftable>
    8000398e:	00002097          	auipc	ra,0x2
    80003992:	794080e7          	jalr	1940(ra) # 80006122 <initlock>
}
    80003996:	60a2                	ld	ra,8(sp)
    80003998:	6402                	ld	s0,0(sp)
    8000399a:	0141                	addi	sp,sp,16
    8000399c:	8082                	ret

000000008000399e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000399e:	1101                	addi	sp,sp,-32
    800039a0:	ec06                	sd	ra,24(sp)
    800039a2:	e822                	sd	s0,16(sp)
    800039a4:	e426                	sd	s1,8(sp)
    800039a6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039a8:	00016517          	auipc	a0,0x16
    800039ac:	9c050513          	addi	a0,a0,-1600 # 80019368 <ftable>
    800039b0:	00003097          	auipc	ra,0x3
    800039b4:	802080e7          	jalr	-2046(ra) # 800061b2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039b8:	00016497          	auipc	s1,0x16
    800039bc:	9c848493          	addi	s1,s1,-1592 # 80019380 <ftable+0x18>
    800039c0:	00017717          	auipc	a4,0x17
    800039c4:	96070713          	addi	a4,a4,-1696 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    800039c8:	40dc                	lw	a5,4(s1)
    800039ca:	cf99                	beqz	a5,800039e8 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039cc:	02848493          	addi	s1,s1,40
    800039d0:	fee49ce3          	bne	s1,a4,800039c8 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039d4:	00016517          	auipc	a0,0x16
    800039d8:	99450513          	addi	a0,a0,-1644 # 80019368 <ftable>
    800039dc:	00003097          	auipc	ra,0x3
    800039e0:	88a080e7          	jalr	-1910(ra) # 80006266 <release>
  return 0;
    800039e4:	4481                	li	s1,0
    800039e6:	a819                	j	800039fc <filealloc+0x5e>
      f->ref = 1;
    800039e8:	4785                	li	a5,1
    800039ea:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039ec:	00016517          	auipc	a0,0x16
    800039f0:	97c50513          	addi	a0,a0,-1668 # 80019368 <ftable>
    800039f4:	00003097          	auipc	ra,0x3
    800039f8:	872080e7          	jalr	-1934(ra) # 80006266 <release>
}
    800039fc:	8526                	mv	a0,s1
    800039fe:	60e2                	ld	ra,24(sp)
    80003a00:	6442                	ld	s0,16(sp)
    80003a02:	64a2                	ld	s1,8(sp)
    80003a04:	6105                	addi	sp,sp,32
    80003a06:	8082                	ret

0000000080003a08 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a08:	1101                	addi	sp,sp,-32
    80003a0a:	ec06                	sd	ra,24(sp)
    80003a0c:	e822                	sd	s0,16(sp)
    80003a0e:	e426                	sd	s1,8(sp)
    80003a10:	1000                	addi	s0,sp,32
    80003a12:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a14:	00016517          	auipc	a0,0x16
    80003a18:	95450513          	addi	a0,a0,-1708 # 80019368 <ftable>
    80003a1c:	00002097          	auipc	ra,0x2
    80003a20:	796080e7          	jalr	1942(ra) # 800061b2 <acquire>
  if(f->ref < 1)
    80003a24:	40dc                	lw	a5,4(s1)
    80003a26:	02f05263          	blez	a5,80003a4a <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a2a:	2785                	addiw	a5,a5,1
    80003a2c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a2e:	00016517          	auipc	a0,0x16
    80003a32:	93a50513          	addi	a0,a0,-1734 # 80019368 <ftable>
    80003a36:	00003097          	auipc	ra,0x3
    80003a3a:	830080e7          	jalr	-2000(ra) # 80006266 <release>
  return f;
}
    80003a3e:	8526                	mv	a0,s1
    80003a40:	60e2                	ld	ra,24(sp)
    80003a42:	6442                	ld	s0,16(sp)
    80003a44:	64a2                	ld	s1,8(sp)
    80003a46:	6105                	addi	sp,sp,32
    80003a48:	8082                	ret
    panic("filedup");
    80003a4a:	00005517          	auipc	a0,0x5
    80003a4e:	d5650513          	addi	a0,a0,-682 # 800087a0 <syscall_name+0x250>
    80003a52:	00002097          	auipc	ra,0x2
    80003a56:	216080e7          	jalr	534(ra) # 80005c68 <panic>

0000000080003a5a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a5a:	7139                	addi	sp,sp,-64
    80003a5c:	fc06                	sd	ra,56(sp)
    80003a5e:	f822                	sd	s0,48(sp)
    80003a60:	f426                	sd	s1,40(sp)
    80003a62:	f04a                	sd	s2,32(sp)
    80003a64:	ec4e                	sd	s3,24(sp)
    80003a66:	e852                	sd	s4,16(sp)
    80003a68:	e456                	sd	s5,8(sp)
    80003a6a:	0080                	addi	s0,sp,64
    80003a6c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a6e:	00016517          	auipc	a0,0x16
    80003a72:	8fa50513          	addi	a0,a0,-1798 # 80019368 <ftable>
    80003a76:	00002097          	auipc	ra,0x2
    80003a7a:	73c080e7          	jalr	1852(ra) # 800061b2 <acquire>
  if(f->ref < 1)
    80003a7e:	40dc                	lw	a5,4(s1)
    80003a80:	06f05163          	blez	a5,80003ae2 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a84:	37fd                	addiw	a5,a5,-1
    80003a86:	0007871b          	sext.w	a4,a5
    80003a8a:	c0dc                	sw	a5,4(s1)
    80003a8c:	06e04363          	bgtz	a4,80003af2 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a90:	0004a903          	lw	s2,0(s1)
    80003a94:	0094ca83          	lbu	s5,9(s1)
    80003a98:	0104ba03          	ld	s4,16(s1)
    80003a9c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003aa0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003aa4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003aa8:	00016517          	auipc	a0,0x16
    80003aac:	8c050513          	addi	a0,a0,-1856 # 80019368 <ftable>
    80003ab0:	00002097          	auipc	ra,0x2
    80003ab4:	7b6080e7          	jalr	1974(ra) # 80006266 <release>

  if(ff.type == FD_PIPE){
    80003ab8:	4785                	li	a5,1
    80003aba:	04f90d63          	beq	s2,a5,80003b14 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003abe:	3979                	addiw	s2,s2,-2
    80003ac0:	4785                	li	a5,1
    80003ac2:	0527e063          	bltu	a5,s2,80003b02 <fileclose+0xa8>
    begin_op();
    80003ac6:	00000097          	auipc	ra,0x0
    80003aca:	ac8080e7          	jalr	-1336(ra) # 8000358e <begin_op>
    iput(ff.ip);
    80003ace:	854e                	mv	a0,s3
    80003ad0:	fffff097          	auipc	ra,0xfffff
    80003ad4:	2a6080e7          	jalr	678(ra) # 80002d76 <iput>
    end_op();
    80003ad8:	00000097          	auipc	ra,0x0
    80003adc:	b36080e7          	jalr	-1226(ra) # 8000360e <end_op>
    80003ae0:	a00d                	j	80003b02 <fileclose+0xa8>
    panic("fileclose");
    80003ae2:	00005517          	auipc	a0,0x5
    80003ae6:	cc650513          	addi	a0,a0,-826 # 800087a8 <syscall_name+0x258>
    80003aea:	00002097          	auipc	ra,0x2
    80003aee:	17e080e7          	jalr	382(ra) # 80005c68 <panic>
    release(&ftable.lock);
    80003af2:	00016517          	auipc	a0,0x16
    80003af6:	87650513          	addi	a0,a0,-1930 # 80019368 <ftable>
    80003afa:	00002097          	auipc	ra,0x2
    80003afe:	76c080e7          	jalr	1900(ra) # 80006266 <release>
  }
}
    80003b02:	70e2                	ld	ra,56(sp)
    80003b04:	7442                	ld	s0,48(sp)
    80003b06:	74a2                	ld	s1,40(sp)
    80003b08:	7902                	ld	s2,32(sp)
    80003b0a:	69e2                	ld	s3,24(sp)
    80003b0c:	6a42                	ld	s4,16(sp)
    80003b0e:	6aa2                	ld	s5,8(sp)
    80003b10:	6121                	addi	sp,sp,64
    80003b12:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b14:	85d6                	mv	a1,s5
    80003b16:	8552                	mv	a0,s4
    80003b18:	00000097          	auipc	ra,0x0
    80003b1c:	34c080e7          	jalr	844(ra) # 80003e64 <pipeclose>
    80003b20:	b7cd                	j	80003b02 <fileclose+0xa8>

0000000080003b22 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b22:	715d                	addi	sp,sp,-80
    80003b24:	e486                	sd	ra,72(sp)
    80003b26:	e0a2                	sd	s0,64(sp)
    80003b28:	fc26                	sd	s1,56(sp)
    80003b2a:	f84a                	sd	s2,48(sp)
    80003b2c:	f44e                	sd	s3,40(sp)
    80003b2e:	0880                	addi	s0,sp,80
    80003b30:	84aa                	mv	s1,a0
    80003b32:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b34:	ffffd097          	auipc	ra,0xffffd
    80003b38:	35e080e7          	jalr	862(ra) # 80000e92 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b3c:	409c                	lw	a5,0(s1)
    80003b3e:	37f9                	addiw	a5,a5,-2
    80003b40:	4705                	li	a4,1
    80003b42:	04f76763          	bltu	a4,a5,80003b90 <filestat+0x6e>
    80003b46:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b48:	6c88                	ld	a0,24(s1)
    80003b4a:	fffff097          	auipc	ra,0xfffff
    80003b4e:	072080e7          	jalr	114(ra) # 80002bbc <ilock>
    stati(f->ip, &st);
    80003b52:	fb840593          	addi	a1,s0,-72
    80003b56:	6c88                	ld	a0,24(s1)
    80003b58:	fffff097          	auipc	ra,0xfffff
    80003b5c:	2ee080e7          	jalr	750(ra) # 80002e46 <stati>
    iunlock(f->ip);
    80003b60:	6c88                	ld	a0,24(s1)
    80003b62:	fffff097          	auipc	ra,0xfffff
    80003b66:	11c080e7          	jalr	284(ra) # 80002c7e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b6a:	46e1                	li	a3,24
    80003b6c:	fb840613          	addi	a2,s0,-72
    80003b70:	85ce                	mv	a1,s3
    80003b72:	05093503          	ld	a0,80(s2)
    80003b76:	ffffd097          	auipc	ra,0xffffd
    80003b7a:	fde080e7          	jalr	-34(ra) # 80000b54 <copyout>
    80003b7e:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b82:	60a6                	ld	ra,72(sp)
    80003b84:	6406                	ld	s0,64(sp)
    80003b86:	74e2                	ld	s1,56(sp)
    80003b88:	7942                	ld	s2,48(sp)
    80003b8a:	79a2                	ld	s3,40(sp)
    80003b8c:	6161                	addi	sp,sp,80
    80003b8e:	8082                	ret
  return -1;
    80003b90:	557d                	li	a0,-1
    80003b92:	bfc5                	j	80003b82 <filestat+0x60>

0000000080003b94 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b94:	7179                	addi	sp,sp,-48
    80003b96:	f406                	sd	ra,40(sp)
    80003b98:	f022                	sd	s0,32(sp)
    80003b9a:	ec26                	sd	s1,24(sp)
    80003b9c:	e84a                	sd	s2,16(sp)
    80003b9e:	e44e                	sd	s3,8(sp)
    80003ba0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ba2:	00854783          	lbu	a5,8(a0)
    80003ba6:	c3d5                	beqz	a5,80003c4a <fileread+0xb6>
    80003ba8:	84aa                	mv	s1,a0
    80003baa:	89ae                	mv	s3,a1
    80003bac:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bae:	411c                	lw	a5,0(a0)
    80003bb0:	4705                	li	a4,1
    80003bb2:	04e78963          	beq	a5,a4,80003c04 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bb6:	470d                	li	a4,3
    80003bb8:	04e78d63          	beq	a5,a4,80003c12 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bbc:	4709                	li	a4,2
    80003bbe:	06e79e63          	bne	a5,a4,80003c3a <fileread+0xa6>
    ilock(f->ip);
    80003bc2:	6d08                	ld	a0,24(a0)
    80003bc4:	fffff097          	auipc	ra,0xfffff
    80003bc8:	ff8080e7          	jalr	-8(ra) # 80002bbc <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bcc:	874a                	mv	a4,s2
    80003bce:	5094                	lw	a3,32(s1)
    80003bd0:	864e                	mv	a2,s3
    80003bd2:	4585                	li	a1,1
    80003bd4:	6c88                	ld	a0,24(s1)
    80003bd6:	fffff097          	auipc	ra,0xfffff
    80003bda:	29a080e7          	jalr	666(ra) # 80002e70 <readi>
    80003bde:	892a                	mv	s2,a0
    80003be0:	00a05563          	blez	a0,80003bea <fileread+0x56>
      f->off += r;
    80003be4:	509c                	lw	a5,32(s1)
    80003be6:	9fa9                	addw	a5,a5,a0
    80003be8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bea:	6c88                	ld	a0,24(s1)
    80003bec:	fffff097          	auipc	ra,0xfffff
    80003bf0:	092080e7          	jalr	146(ra) # 80002c7e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bf4:	854a                	mv	a0,s2
    80003bf6:	70a2                	ld	ra,40(sp)
    80003bf8:	7402                	ld	s0,32(sp)
    80003bfa:	64e2                	ld	s1,24(sp)
    80003bfc:	6942                	ld	s2,16(sp)
    80003bfe:	69a2                	ld	s3,8(sp)
    80003c00:	6145                	addi	sp,sp,48
    80003c02:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c04:	6908                	ld	a0,16(a0)
    80003c06:	00000097          	auipc	ra,0x0
    80003c0a:	3c8080e7          	jalr	968(ra) # 80003fce <piperead>
    80003c0e:	892a                	mv	s2,a0
    80003c10:	b7d5                	j	80003bf4 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c12:	02451783          	lh	a5,36(a0)
    80003c16:	03079693          	slli	a3,a5,0x30
    80003c1a:	92c1                	srli	a3,a3,0x30
    80003c1c:	4725                	li	a4,9
    80003c1e:	02d76863          	bltu	a4,a3,80003c4e <fileread+0xba>
    80003c22:	0792                	slli	a5,a5,0x4
    80003c24:	00015717          	auipc	a4,0x15
    80003c28:	6a470713          	addi	a4,a4,1700 # 800192c8 <devsw>
    80003c2c:	97ba                	add	a5,a5,a4
    80003c2e:	639c                	ld	a5,0(a5)
    80003c30:	c38d                	beqz	a5,80003c52 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c32:	4505                	li	a0,1
    80003c34:	9782                	jalr	a5
    80003c36:	892a                	mv	s2,a0
    80003c38:	bf75                	j	80003bf4 <fileread+0x60>
    panic("fileread");
    80003c3a:	00005517          	auipc	a0,0x5
    80003c3e:	b7e50513          	addi	a0,a0,-1154 # 800087b8 <syscall_name+0x268>
    80003c42:	00002097          	auipc	ra,0x2
    80003c46:	026080e7          	jalr	38(ra) # 80005c68 <panic>
    return -1;
    80003c4a:	597d                	li	s2,-1
    80003c4c:	b765                	j	80003bf4 <fileread+0x60>
      return -1;
    80003c4e:	597d                	li	s2,-1
    80003c50:	b755                	j	80003bf4 <fileread+0x60>
    80003c52:	597d                	li	s2,-1
    80003c54:	b745                	j	80003bf4 <fileread+0x60>

0000000080003c56 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c56:	715d                	addi	sp,sp,-80
    80003c58:	e486                	sd	ra,72(sp)
    80003c5a:	e0a2                	sd	s0,64(sp)
    80003c5c:	fc26                	sd	s1,56(sp)
    80003c5e:	f84a                	sd	s2,48(sp)
    80003c60:	f44e                	sd	s3,40(sp)
    80003c62:	f052                	sd	s4,32(sp)
    80003c64:	ec56                	sd	s5,24(sp)
    80003c66:	e85a                	sd	s6,16(sp)
    80003c68:	e45e                	sd	s7,8(sp)
    80003c6a:	e062                	sd	s8,0(sp)
    80003c6c:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c6e:	00954783          	lbu	a5,9(a0)
    80003c72:	10078663          	beqz	a5,80003d7e <filewrite+0x128>
    80003c76:	892a                	mv	s2,a0
    80003c78:	8aae                	mv	s5,a1
    80003c7a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c7c:	411c                	lw	a5,0(a0)
    80003c7e:	4705                	li	a4,1
    80003c80:	02e78263          	beq	a5,a4,80003ca4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c84:	470d                	li	a4,3
    80003c86:	02e78663          	beq	a5,a4,80003cb2 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c8a:	4709                	li	a4,2
    80003c8c:	0ee79163          	bne	a5,a4,80003d6e <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c90:	0ac05d63          	blez	a2,80003d4a <filewrite+0xf4>
    int i = 0;
    80003c94:	4981                	li	s3,0
    80003c96:	6b05                	lui	s6,0x1
    80003c98:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c9c:	6b85                	lui	s7,0x1
    80003c9e:	c00b8b9b          	addiw	s7,s7,-1024
    80003ca2:	a861                	j	80003d3a <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003ca4:	6908                	ld	a0,16(a0)
    80003ca6:	00000097          	auipc	ra,0x0
    80003caa:	22e080e7          	jalr	558(ra) # 80003ed4 <pipewrite>
    80003cae:	8a2a                	mv	s4,a0
    80003cb0:	a045                	j	80003d50 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cb2:	02451783          	lh	a5,36(a0)
    80003cb6:	03079693          	slli	a3,a5,0x30
    80003cba:	92c1                	srli	a3,a3,0x30
    80003cbc:	4725                	li	a4,9
    80003cbe:	0cd76263          	bltu	a4,a3,80003d82 <filewrite+0x12c>
    80003cc2:	0792                	slli	a5,a5,0x4
    80003cc4:	00015717          	auipc	a4,0x15
    80003cc8:	60470713          	addi	a4,a4,1540 # 800192c8 <devsw>
    80003ccc:	97ba                	add	a5,a5,a4
    80003cce:	679c                	ld	a5,8(a5)
    80003cd0:	cbdd                	beqz	a5,80003d86 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cd2:	4505                	li	a0,1
    80003cd4:	9782                	jalr	a5
    80003cd6:	8a2a                	mv	s4,a0
    80003cd8:	a8a5                	j	80003d50 <filewrite+0xfa>
    80003cda:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cde:	00000097          	auipc	ra,0x0
    80003ce2:	8b0080e7          	jalr	-1872(ra) # 8000358e <begin_op>
      ilock(f->ip);
    80003ce6:	01893503          	ld	a0,24(s2)
    80003cea:	fffff097          	auipc	ra,0xfffff
    80003cee:	ed2080e7          	jalr	-302(ra) # 80002bbc <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cf2:	8762                	mv	a4,s8
    80003cf4:	02092683          	lw	a3,32(s2)
    80003cf8:	01598633          	add	a2,s3,s5
    80003cfc:	4585                	li	a1,1
    80003cfe:	01893503          	ld	a0,24(s2)
    80003d02:	fffff097          	auipc	ra,0xfffff
    80003d06:	266080e7          	jalr	614(ra) # 80002f68 <writei>
    80003d0a:	84aa                	mv	s1,a0
    80003d0c:	00a05763          	blez	a0,80003d1a <filewrite+0xc4>
        f->off += r;
    80003d10:	02092783          	lw	a5,32(s2)
    80003d14:	9fa9                	addw	a5,a5,a0
    80003d16:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d1a:	01893503          	ld	a0,24(s2)
    80003d1e:	fffff097          	auipc	ra,0xfffff
    80003d22:	f60080e7          	jalr	-160(ra) # 80002c7e <iunlock>
      end_op();
    80003d26:	00000097          	auipc	ra,0x0
    80003d2a:	8e8080e7          	jalr	-1816(ra) # 8000360e <end_op>

      if(r != n1){
    80003d2e:	009c1f63          	bne	s8,s1,80003d4c <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d32:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d36:	0149db63          	bge	s3,s4,80003d4c <filewrite+0xf6>
      int n1 = n - i;
    80003d3a:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d3e:	84be                	mv	s1,a5
    80003d40:	2781                	sext.w	a5,a5
    80003d42:	f8fb5ce3          	bge	s6,a5,80003cda <filewrite+0x84>
    80003d46:	84de                	mv	s1,s7
    80003d48:	bf49                	j	80003cda <filewrite+0x84>
    int i = 0;
    80003d4a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d4c:	013a1f63          	bne	s4,s3,80003d6a <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d50:	8552                	mv	a0,s4
    80003d52:	60a6                	ld	ra,72(sp)
    80003d54:	6406                	ld	s0,64(sp)
    80003d56:	74e2                	ld	s1,56(sp)
    80003d58:	7942                	ld	s2,48(sp)
    80003d5a:	79a2                	ld	s3,40(sp)
    80003d5c:	7a02                	ld	s4,32(sp)
    80003d5e:	6ae2                	ld	s5,24(sp)
    80003d60:	6b42                	ld	s6,16(sp)
    80003d62:	6ba2                	ld	s7,8(sp)
    80003d64:	6c02                	ld	s8,0(sp)
    80003d66:	6161                	addi	sp,sp,80
    80003d68:	8082                	ret
    ret = (i == n ? n : -1);
    80003d6a:	5a7d                	li	s4,-1
    80003d6c:	b7d5                	j	80003d50 <filewrite+0xfa>
    panic("filewrite");
    80003d6e:	00005517          	auipc	a0,0x5
    80003d72:	a5a50513          	addi	a0,a0,-1446 # 800087c8 <syscall_name+0x278>
    80003d76:	00002097          	auipc	ra,0x2
    80003d7a:	ef2080e7          	jalr	-270(ra) # 80005c68 <panic>
    return -1;
    80003d7e:	5a7d                	li	s4,-1
    80003d80:	bfc1                	j	80003d50 <filewrite+0xfa>
      return -1;
    80003d82:	5a7d                	li	s4,-1
    80003d84:	b7f1                	j	80003d50 <filewrite+0xfa>
    80003d86:	5a7d                	li	s4,-1
    80003d88:	b7e1                	j	80003d50 <filewrite+0xfa>

0000000080003d8a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d8a:	7179                	addi	sp,sp,-48
    80003d8c:	f406                	sd	ra,40(sp)
    80003d8e:	f022                	sd	s0,32(sp)
    80003d90:	ec26                	sd	s1,24(sp)
    80003d92:	e84a                	sd	s2,16(sp)
    80003d94:	e44e                	sd	s3,8(sp)
    80003d96:	e052                	sd	s4,0(sp)
    80003d98:	1800                	addi	s0,sp,48
    80003d9a:	84aa                	mv	s1,a0
    80003d9c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d9e:	0005b023          	sd	zero,0(a1)
    80003da2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003da6:	00000097          	auipc	ra,0x0
    80003daa:	bf8080e7          	jalr	-1032(ra) # 8000399e <filealloc>
    80003dae:	e088                	sd	a0,0(s1)
    80003db0:	c551                	beqz	a0,80003e3c <pipealloc+0xb2>
    80003db2:	00000097          	auipc	ra,0x0
    80003db6:	bec080e7          	jalr	-1044(ra) # 8000399e <filealloc>
    80003dba:	00aa3023          	sd	a0,0(s4)
    80003dbe:	c92d                	beqz	a0,80003e30 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dc0:	ffffc097          	auipc	ra,0xffffc
    80003dc4:	358080e7          	jalr	856(ra) # 80000118 <kalloc>
    80003dc8:	892a                	mv	s2,a0
    80003dca:	c125                	beqz	a0,80003e2a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003dcc:	4985                	li	s3,1
    80003dce:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dd2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dd6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dda:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dde:	00004597          	auipc	a1,0x4
    80003de2:	60258593          	addi	a1,a1,1538 # 800083e0 <states.1715+0x1a0>
    80003de6:	00002097          	auipc	ra,0x2
    80003dea:	33c080e7          	jalr	828(ra) # 80006122 <initlock>
  (*f0)->type = FD_PIPE;
    80003dee:	609c                	ld	a5,0(s1)
    80003df0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003df4:	609c                	ld	a5,0(s1)
    80003df6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003dfa:	609c                	ld	a5,0(s1)
    80003dfc:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e00:	609c                	ld	a5,0(s1)
    80003e02:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e06:	000a3783          	ld	a5,0(s4)
    80003e0a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e0e:	000a3783          	ld	a5,0(s4)
    80003e12:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e16:	000a3783          	ld	a5,0(s4)
    80003e1a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e1e:	000a3783          	ld	a5,0(s4)
    80003e22:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e26:	4501                	li	a0,0
    80003e28:	a025                	j	80003e50 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e2a:	6088                	ld	a0,0(s1)
    80003e2c:	e501                	bnez	a0,80003e34 <pipealloc+0xaa>
    80003e2e:	a039                	j	80003e3c <pipealloc+0xb2>
    80003e30:	6088                	ld	a0,0(s1)
    80003e32:	c51d                	beqz	a0,80003e60 <pipealloc+0xd6>
    fileclose(*f0);
    80003e34:	00000097          	auipc	ra,0x0
    80003e38:	c26080e7          	jalr	-986(ra) # 80003a5a <fileclose>
  if(*f1)
    80003e3c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e40:	557d                	li	a0,-1
  if(*f1)
    80003e42:	c799                	beqz	a5,80003e50 <pipealloc+0xc6>
    fileclose(*f1);
    80003e44:	853e                	mv	a0,a5
    80003e46:	00000097          	auipc	ra,0x0
    80003e4a:	c14080e7          	jalr	-1004(ra) # 80003a5a <fileclose>
  return -1;
    80003e4e:	557d                	li	a0,-1
}
    80003e50:	70a2                	ld	ra,40(sp)
    80003e52:	7402                	ld	s0,32(sp)
    80003e54:	64e2                	ld	s1,24(sp)
    80003e56:	6942                	ld	s2,16(sp)
    80003e58:	69a2                	ld	s3,8(sp)
    80003e5a:	6a02                	ld	s4,0(sp)
    80003e5c:	6145                	addi	sp,sp,48
    80003e5e:	8082                	ret
  return -1;
    80003e60:	557d                	li	a0,-1
    80003e62:	b7fd                	j	80003e50 <pipealloc+0xc6>

0000000080003e64 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e64:	1101                	addi	sp,sp,-32
    80003e66:	ec06                	sd	ra,24(sp)
    80003e68:	e822                	sd	s0,16(sp)
    80003e6a:	e426                	sd	s1,8(sp)
    80003e6c:	e04a                	sd	s2,0(sp)
    80003e6e:	1000                	addi	s0,sp,32
    80003e70:	84aa                	mv	s1,a0
    80003e72:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e74:	00002097          	auipc	ra,0x2
    80003e78:	33e080e7          	jalr	830(ra) # 800061b2 <acquire>
  if(writable){
    80003e7c:	02090d63          	beqz	s2,80003eb6 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e80:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e84:	21848513          	addi	a0,s1,536
    80003e88:	ffffe097          	auipc	ra,0xffffe
    80003e8c:	85a080e7          	jalr	-1958(ra) # 800016e2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e90:	2204b783          	ld	a5,544(s1)
    80003e94:	eb95                	bnez	a5,80003ec8 <pipeclose+0x64>
    release(&pi->lock);
    80003e96:	8526                	mv	a0,s1
    80003e98:	00002097          	auipc	ra,0x2
    80003e9c:	3ce080e7          	jalr	974(ra) # 80006266 <release>
    kfree((char*)pi);
    80003ea0:	8526                	mv	a0,s1
    80003ea2:	ffffc097          	auipc	ra,0xffffc
    80003ea6:	17a080e7          	jalr	378(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003eaa:	60e2                	ld	ra,24(sp)
    80003eac:	6442                	ld	s0,16(sp)
    80003eae:	64a2                	ld	s1,8(sp)
    80003eb0:	6902                	ld	s2,0(sp)
    80003eb2:	6105                	addi	sp,sp,32
    80003eb4:	8082                	ret
    pi->readopen = 0;
    80003eb6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003eba:	21c48513          	addi	a0,s1,540
    80003ebe:	ffffe097          	auipc	ra,0xffffe
    80003ec2:	824080e7          	jalr	-2012(ra) # 800016e2 <wakeup>
    80003ec6:	b7e9                	j	80003e90 <pipeclose+0x2c>
    release(&pi->lock);
    80003ec8:	8526                	mv	a0,s1
    80003eca:	00002097          	auipc	ra,0x2
    80003ece:	39c080e7          	jalr	924(ra) # 80006266 <release>
}
    80003ed2:	bfe1                	j	80003eaa <pipeclose+0x46>

0000000080003ed4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ed4:	7159                	addi	sp,sp,-112
    80003ed6:	f486                	sd	ra,104(sp)
    80003ed8:	f0a2                	sd	s0,96(sp)
    80003eda:	eca6                	sd	s1,88(sp)
    80003edc:	e8ca                	sd	s2,80(sp)
    80003ede:	e4ce                	sd	s3,72(sp)
    80003ee0:	e0d2                	sd	s4,64(sp)
    80003ee2:	fc56                	sd	s5,56(sp)
    80003ee4:	f85a                	sd	s6,48(sp)
    80003ee6:	f45e                	sd	s7,40(sp)
    80003ee8:	f062                	sd	s8,32(sp)
    80003eea:	ec66                	sd	s9,24(sp)
    80003eec:	1880                	addi	s0,sp,112
    80003eee:	84aa                	mv	s1,a0
    80003ef0:	8aae                	mv	s5,a1
    80003ef2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ef4:	ffffd097          	auipc	ra,0xffffd
    80003ef8:	f9e080e7          	jalr	-98(ra) # 80000e92 <myproc>
    80003efc:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003efe:	8526                	mv	a0,s1
    80003f00:	00002097          	auipc	ra,0x2
    80003f04:	2b2080e7          	jalr	690(ra) # 800061b2 <acquire>
  while(i < n){
    80003f08:	0d405163          	blez	s4,80003fca <pipewrite+0xf6>
    80003f0c:	8ba6                	mv	s7,s1
  int i = 0;
    80003f0e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f10:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f12:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f16:	21c48c13          	addi	s8,s1,540
    80003f1a:	a08d                	j	80003f7c <pipewrite+0xa8>
      release(&pi->lock);
    80003f1c:	8526                	mv	a0,s1
    80003f1e:	00002097          	auipc	ra,0x2
    80003f22:	348080e7          	jalr	840(ra) # 80006266 <release>
      return -1;
    80003f26:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f28:	854a                	mv	a0,s2
    80003f2a:	70a6                	ld	ra,104(sp)
    80003f2c:	7406                	ld	s0,96(sp)
    80003f2e:	64e6                	ld	s1,88(sp)
    80003f30:	6946                	ld	s2,80(sp)
    80003f32:	69a6                	ld	s3,72(sp)
    80003f34:	6a06                	ld	s4,64(sp)
    80003f36:	7ae2                	ld	s5,56(sp)
    80003f38:	7b42                	ld	s6,48(sp)
    80003f3a:	7ba2                	ld	s7,40(sp)
    80003f3c:	7c02                	ld	s8,32(sp)
    80003f3e:	6ce2                	ld	s9,24(sp)
    80003f40:	6165                	addi	sp,sp,112
    80003f42:	8082                	ret
      wakeup(&pi->nread);
    80003f44:	8566                	mv	a0,s9
    80003f46:	ffffd097          	auipc	ra,0xffffd
    80003f4a:	79c080e7          	jalr	1948(ra) # 800016e2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f4e:	85de                	mv	a1,s7
    80003f50:	8562                	mv	a0,s8
    80003f52:	ffffd097          	auipc	ra,0xffffd
    80003f56:	604080e7          	jalr	1540(ra) # 80001556 <sleep>
    80003f5a:	a839                	j	80003f78 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f5c:	21c4a783          	lw	a5,540(s1)
    80003f60:	0017871b          	addiw	a4,a5,1
    80003f64:	20e4ae23          	sw	a4,540(s1)
    80003f68:	1ff7f793          	andi	a5,a5,511
    80003f6c:	97a6                	add	a5,a5,s1
    80003f6e:	f9f44703          	lbu	a4,-97(s0)
    80003f72:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f76:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f78:	03495d63          	bge	s2,s4,80003fb2 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003f7c:	2204a783          	lw	a5,544(s1)
    80003f80:	dfd1                	beqz	a5,80003f1c <pipewrite+0x48>
    80003f82:	0289a783          	lw	a5,40(s3)
    80003f86:	fbd9                	bnez	a5,80003f1c <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f88:	2184a783          	lw	a5,536(s1)
    80003f8c:	21c4a703          	lw	a4,540(s1)
    80003f90:	2007879b          	addiw	a5,a5,512
    80003f94:	faf708e3          	beq	a4,a5,80003f44 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f98:	4685                	li	a3,1
    80003f9a:	01590633          	add	a2,s2,s5
    80003f9e:	f9f40593          	addi	a1,s0,-97
    80003fa2:	0509b503          	ld	a0,80(s3)
    80003fa6:	ffffd097          	auipc	ra,0xffffd
    80003faa:	c3a080e7          	jalr	-966(ra) # 80000be0 <copyin>
    80003fae:	fb6517e3          	bne	a0,s6,80003f5c <pipewrite+0x88>
  wakeup(&pi->nread);
    80003fb2:	21848513          	addi	a0,s1,536
    80003fb6:	ffffd097          	auipc	ra,0xffffd
    80003fba:	72c080e7          	jalr	1836(ra) # 800016e2 <wakeup>
  release(&pi->lock);
    80003fbe:	8526                	mv	a0,s1
    80003fc0:	00002097          	auipc	ra,0x2
    80003fc4:	2a6080e7          	jalr	678(ra) # 80006266 <release>
  return i;
    80003fc8:	b785                	j	80003f28 <pipewrite+0x54>
  int i = 0;
    80003fca:	4901                	li	s2,0
    80003fcc:	b7dd                	j	80003fb2 <pipewrite+0xde>

0000000080003fce <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fce:	715d                	addi	sp,sp,-80
    80003fd0:	e486                	sd	ra,72(sp)
    80003fd2:	e0a2                	sd	s0,64(sp)
    80003fd4:	fc26                	sd	s1,56(sp)
    80003fd6:	f84a                	sd	s2,48(sp)
    80003fd8:	f44e                	sd	s3,40(sp)
    80003fda:	f052                	sd	s4,32(sp)
    80003fdc:	ec56                	sd	s5,24(sp)
    80003fde:	e85a                	sd	s6,16(sp)
    80003fe0:	0880                	addi	s0,sp,80
    80003fe2:	84aa                	mv	s1,a0
    80003fe4:	892e                	mv	s2,a1
    80003fe6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fe8:	ffffd097          	auipc	ra,0xffffd
    80003fec:	eaa080e7          	jalr	-342(ra) # 80000e92 <myproc>
    80003ff0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003ff2:	8b26                	mv	s6,s1
    80003ff4:	8526                	mv	a0,s1
    80003ff6:	00002097          	auipc	ra,0x2
    80003ffa:	1bc080e7          	jalr	444(ra) # 800061b2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ffe:	2184a703          	lw	a4,536(s1)
    80004002:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004006:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000400a:	02f71463          	bne	a4,a5,80004032 <piperead+0x64>
    8000400e:	2244a783          	lw	a5,548(s1)
    80004012:	c385                	beqz	a5,80004032 <piperead+0x64>
    if(pr->killed){
    80004014:	028a2783          	lw	a5,40(s4)
    80004018:	ebc1                	bnez	a5,800040a8 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000401a:	85da                	mv	a1,s6
    8000401c:	854e                	mv	a0,s3
    8000401e:	ffffd097          	auipc	ra,0xffffd
    80004022:	538080e7          	jalr	1336(ra) # 80001556 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004026:	2184a703          	lw	a4,536(s1)
    8000402a:	21c4a783          	lw	a5,540(s1)
    8000402e:	fef700e3          	beq	a4,a5,8000400e <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004032:	09505263          	blez	s5,800040b6 <piperead+0xe8>
    80004036:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004038:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000403a:	2184a783          	lw	a5,536(s1)
    8000403e:	21c4a703          	lw	a4,540(s1)
    80004042:	02f70d63          	beq	a4,a5,8000407c <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004046:	0017871b          	addiw	a4,a5,1
    8000404a:	20e4ac23          	sw	a4,536(s1)
    8000404e:	1ff7f793          	andi	a5,a5,511
    80004052:	97a6                	add	a5,a5,s1
    80004054:	0187c783          	lbu	a5,24(a5)
    80004058:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000405c:	4685                	li	a3,1
    8000405e:	fbf40613          	addi	a2,s0,-65
    80004062:	85ca                	mv	a1,s2
    80004064:	050a3503          	ld	a0,80(s4)
    80004068:	ffffd097          	auipc	ra,0xffffd
    8000406c:	aec080e7          	jalr	-1300(ra) # 80000b54 <copyout>
    80004070:	01650663          	beq	a0,s6,8000407c <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004074:	2985                	addiw	s3,s3,1
    80004076:	0905                	addi	s2,s2,1
    80004078:	fd3a91e3          	bne	s5,s3,8000403a <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000407c:	21c48513          	addi	a0,s1,540
    80004080:	ffffd097          	auipc	ra,0xffffd
    80004084:	662080e7          	jalr	1634(ra) # 800016e2 <wakeup>
  release(&pi->lock);
    80004088:	8526                	mv	a0,s1
    8000408a:	00002097          	auipc	ra,0x2
    8000408e:	1dc080e7          	jalr	476(ra) # 80006266 <release>
  return i;
}
    80004092:	854e                	mv	a0,s3
    80004094:	60a6                	ld	ra,72(sp)
    80004096:	6406                	ld	s0,64(sp)
    80004098:	74e2                	ld	s1,56(sp)
    8000409a:	7942                	ld	s2,48(sp)
    8000409c:	79a2                	ld	s3,40(sp)
    8000409e:	7a02                	ld	s4,32(sp)
    800040a0:	6ae2                	ld	s5,24(sp)
    800040a2:	6b42                	ld	s6,16(sp)
    800040a4:	6161                	addi	sp,sp,80
    800040a6:	8082                	ret
      release(&pi->lock);
    800040a8:	8526                	mv	a0,s1
    800040aa:	00002097          	auipc	ra,0x2
    800040ae:	1bc080e7          	jalr	444(ra) # 80006266 <release>
      return -1;
    800040b2:	59fd                	li	s3,-1
    800040b4:	bff9                	j	80004092 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040b6:	4981                	li	s3,0
    800040b8:	b7d1                	j	8000407c <piperead+0xae>

00000000800040ba <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040ba:	df010113          	addi	sp,sp,-528
    800040be:	20113423          	sd	ra,520(sp)
    800040c2:	20813023          	sd	s0,512(sp)
    800040c6:	ffa6                	sd	s1,504(sp)
    800040c8:	fbca                	sd	s2,496(sp)
    800040ca:	f7ce                	sd	s3,488(sp)
    800040cc:	f3d2                	sd	s4,480(sp)
    800040ce:	efd6                	sd	s5,472(sp)
    800040d0:	ebda                	sd	s6,464(sp)
    800040d2:	e7de                	sd	s7,456(sp)
    800040d4:	e3e2                	sd	s8,448(sp)
    800040d6:	ff66                	sd	s9,440(sp)
    800040d8:	fb6a                	sd	s10,432(sp)
    800040da:	f76e                	sd	s11,424(sp)
    800040dc:	0c00                	addi	s0,sp,528
    800040de:	84aa                	mv	s1,a0
    800040e0:	dea43c23          	sd	a0,-520(s0)
    800040e4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040e8:	ffffd097          	auipc	ra,0xffffd
    800040ec:	daa080e7          	jalr	-598(ra) # 80000e92 <myproc>
    800040f0:	892a                	mv	s2,a0

  begin_op();
    800040f2:	fffff097          	auipc	ra,0xfffff
    800040f6:	49c080e7          	jalr	1180(ra) # 8000358e <begin_op>

  if((ip = namei(path)) == 0){
    800040fa:	8526                	mv	a0,s1
    800040fc:	fffff097          	auipc	ra,0xfffff
    80004100:	276080e7          	jalr	630(ra) # 80003372 <namei>
    80004104:	c92d                	beqz	a0,80004176 <exec+0xbc>
    80004106:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004108:	fffff097          	auipc	ra,0xfffff
    8000410c:	ab4080e7          	jalr	-1356(ra) # 80002bbc <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004110:	04000713          	li	a4,64
    80004114:	4681                	li	a3,0
    80004116:	e5040613          	addi	a2,s0,-432
    8000411a:	4581                	li	a1,0
    8000411c:	8526                	mv	a0,s1
    8000411e:	fffff097          	auipc	ra,0xfffff
    80004122:	d52080e7          	jalr	-686(ra) # 80002e70 <readi>
    80004126:	04000793          	li	a5,64
    8000412a:	00f51a63          	bne	a0,a5,8000413e <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000412e:	e5042703          	lw	a4,-432(s0)
    80004132:	464c47b7          	lui	a5,0x464c4
    80004136:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000413a:	04f70463          	beq	a4,a5,80004182 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000413e:	8526                	mv	a0,s1
    80004140:	fffff097          	auipc	ra,0xfffff
    80004144:	cde080e7          	jalr	-802(ra) # 80002e1e <iunlockput>
    end_op();
    80004148:	fffff097          	auipc	ra,0xfffff
    8000414c:	4c6080e7          	jalr	1222(ra) # 8000360e <end_op>
  }
  return -1;
    80004150:	557d                	li	a0,-1
}
    80004152:	20813083          	ld	ra,520(sp)
    80004156:	20013403          	ld	s0,512(sp)
    8000415a:	74fe                	ld	s1,504(sp)
    8000415c:	795e                	ld	s2,496(sp)
    8000415e:	79be                	ld	s3,488(sp)
    80004160:	7a1e                	ld	s4,480(sp)
    80004162:	6afe                	ld	s5,472(sp)
    80004164:	6b5e                	ld	s6,464(sp)
    80004166:	6bbe                	ld	s7,456(sp)
    80004168:	6c1e                	ld	s8,448(sp)
    8000416a:	7cfa                	ld	s9,440(sp)
    8000416c:	7d5a                	ld	s10,432(sp)
    8000416e:	7dba                	ld	s11,424(sp)
    80004170:	21010113          	addi	sp,sp,528
    80004174:	8082                	ret
    end_op();
    80004176:	fffff097          	auipc	ra,0xfffff
    8000417a:	498080e7          	jalr	1176(ra) # 8000360e <end_op>
    return -1;
    8000417e:	557d                	li	a0,-1
    80004180:	bfc9                	j	80004152 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004182:	854a                	mv	a0,s2
    80004184:	ffffd097          	auipc	ra,0xffffd
    80004188:	dd2080e7          	jalr	-558(ra) # 80000f56 <proc_pagetable>
    8000418c:	8baa                	mv	s7,a0
    8000418e:	d945                	beqz	a0,8000413e <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004190:	e7042983          	lw	s3,-400(s0)
    80004194:	e8845783          	lhu	a5,-376(s0)
    80004198:	c7ad                	beqz	a5,80004202 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000419a:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000419c:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    8000419e:	6c85                	lui	s9,0x1
    800041a0:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041a4:	def43823          	sd	a5,-528(s0)
    800041a8:	a42d                	j	800043d2 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041aa:	00004517          	auipc	a0,0x4
    800041ae:	62e50513          	addi	a0,a0,1582 # 800087d8 <syscall_name+0x288>
    800041b2:	00002097          	auipc	ra,0x2
    800041b6:	ab6080e7          	jalr	-1354(ra) # 80005c68 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041ba:	8756                	mv	a4,s5
    800041bc:	012d86bb          	addw	a3,s11,s2
    800041c0:	4581                	li	a1,0
    800041c2:	8526                	mv	a0,s1
    800041c4:	fffff097          	auipc	ra,0xfffff
    800041c8:	cac080e7          	jalr	-852(ra) # 80002e70 <readi>
    800041cc:	2501                	sext.w	a0,a0
    800041ce:	1aaa9963          	bne	s5,a0,80004380 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800041d2:	6785                	lui	a5,0x1
    800041d4:	0127893b          	addw	s2,a5,s2
    800041d8:	77fd                	lui	a5,0xfffff
    800041da:	01478a3b          	addw	s4,a5,s4
    800041de:	1f897163          	bgeu	s2,s8,800043c0 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800041e2:	02091593          	slli	a1,s2,0x20
    800041e6:	9181                	srli	a1,a1,0x20
    800041e8:	95ea                	add	a1,a1,s10
    800041ea:	855e                	mv	a0,s7
    800041ec:	ffffc097          	auipc	ra,0xffffc
    800041f0:	364080e7          	jalr	868(ra) # 80000550 <walkaddr>
    800041f4:	862a                	mv	a2,a0
    if(pa == 0)
    800041f6:	d955                	beqz	a0,800041aa <exec+0xf0>
      n = PGSIZE;
    800041f8:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800041fa:	fd9a70e3          	bgeu	s4,s9,800041ba <exec+0x100>
      n = sz - i;
    800041fe:	8ad2                	mv	s5,s4
    80004200:	bf6d                	j	800041ba <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004202:	4901                	li	s2,0
  iunlockput(ip);
    80004204:	8526                	mv	a0,s1
    80004206:	fffff097          	auipc	ra,0xfffff
    8000420a:	c18080e7          	jalr	-1000(ra) # 80002e1e <iunlockput>
  end_op();
    8000420e:	fffff097          	auipc	ra,0xfffff
    80004212:	400080e7          	jalr	1024(ra) # 8000360e <end_op>
  p = myproc();
    80004216:	ffffd097          	auipc	ra,0xffffd
    8000421a:	c7c080e7          	jalr	-900(ra) # 80000e92 <myproc>
    8000421e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004220:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004224:	6785                	lui	a5,0x1
    80004226:	17fd                	addi	a5,a5,-1
    80004228:	993e                	add	s2,s2,a5
    8000422a:	757d                	lui	a0,0xfffff
    8000422c:	00a977b3          	and	a5,s2,a0
    80004230:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004234:	6609                	lui	a2,0x2
    80004236:	963e                	add	a2,a2,a5
    80004238:	85be                	mv	a1,a5
    8000423a:	855e                	mv	a0,s7
    8000423c:	ffffc097          	auipc	ra,0xffffc
    80004240:	6c8080e7          	jalr	1736(ra) # 80000904 <uvmalloc>
    80004244:	8b2a                	mv	s6,a0
  ip = 0;
    80004246:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004248:	12050c63          	beqz	a0,80004380 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000424c:	75f9                	lui	a1,0xffffe
    8000424e:	95aa                	add	a1,a1,a0
    80004250:	855e                	mv	a0,s7
    80004252:	ffffd097          	auipc	ra,0xffffd
    80004256:	8d0080e7          	jalr	-1840(ra) # 80000b22 <uvmclear>
  stackbase = sp - PGSIZE;
    8000425a:	7c7d                	lui	s8,0xfffff
    8000425c:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000425e:	e0043783          	ld	a5,-512(s0)
    80004262:	6388                	ld	a0,0(a5)
    80004264:	c535                	beqz	a0,800042d0 <exec+0x216>
    80004266:	e9040993          	addi	s3,s0,-368
    8000426a:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000426e:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004270:	ffffc097          	auipc	ra,0xffffc
    80004274:	0d6080e7          	jalr	214(ra) # 80000346 <strlen>
    80004278:	2505                	addiw	a0,a0,1
    8000427a:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000427e:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004282:	13896363          	bltu	s2,s8,800043a8 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004286:	e0043d83          	ld	s11,-512(s0)
    8000428a:	000dba03          	ld	s4,0(s11)
    8000428e:	8552                	mv	a0,s4
    80004290:	ffffc097          	auipc	ra,0xffffc
    80004294:	0b6080e7          	jalr	182(ra) # 80000346 <strlen>
    80004298:	0015069b          	addiw	a3,a0,1
    8000429c:	8652                	mv	a2,s4
    8000429e:	85ca                	mv	a1,s2
    800042a0:	855e                	mv	a0,s7
    800042a2:	ffffd097          	auipc	ra,0xffffd
    800042a6:	8b2080e7          	jalr	-1870(ra) # 80000b54 <copyout>
    800042aa:	10054363          	bltz	a0,800043b0 <exec+0x2f6>
    ustack[argc] = sp;
    800042ae:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042b2:	0485                	addi	s1,s1,1
    800042b4:	008d8793          	addi	a5,s11,8
    800042b8:	e0f43023          	sd	a5,-512(s0)
    800042bc:	008db503          	ld	a0,8(s11)
    800042c0:	c911                	beqz	a0,800042d4 <exec+0x21a>
    if(argc >= MAXARG)
    800042c2:	09a1                	addi	s3,s3,8
    800042c4:	fb3c96e3          	bne	s9,s3,80004270 <exec+0x1b6>
  sz = sz1;
    800042c8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042cc:	4481                	li	s1,0
    800042ce:	a84d                	j	80004380 <exec+0x2c6>
  sp = sz;
    800042d0:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800042d2:	4481                	li	s1,0
  ustack[argc] = 0;
    800042d4:	00349793          	slli	a5,s1,0x3
    800042d8:	f9040713          	addi	a4,s0,-112
    800042dc:	97ba                	add	a5,a5,a4
    800042de:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800042e2:	00148693          	addi	a3,s1,1
    800042e6:	068e                	slli	a3,a3,0x3
    800042e8:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042ec:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042f0:	01897663          	bgeu	s2,s8,800042fc <exec+0x242>
  sz = sz1;
    800042f4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042f8:	4481                	li	s1,0
    800042fa:	a059                	j	80004380 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042fc:	e9040613          	addi	a2,s0,-368
    80004300:	85ca                	mv	a1,s2
    80004302:	855e                	mv	a0,s7
    80004304:	ffffd097          	auipc	ra,0xffffd
    80004308:	850080e7          	jalr	-1968(ra) # 80000b54 <copyout>
    8000430c:	0a054663          	bltz	a0,800043b8 <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004310:	060ab783          	ld	a5,96(s5)
    80004314:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004318:	df843783          	ld	a5,-520(s0)
    8000431c:	0007c703          	lbu	a4,0(a5)
    80004320:	cf11                	beqz	a4,8000433c <exec+0x282>
    80004322:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004324:	02f00693          	li	a3,47
    80004328:	a039                	j	80004336 <exec+0x27c>
      last = s+1;
    8000432a:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000432e:	0785                	addi	a5,a5,1
    80004330:	fff7c703          	lbu	a4,-1(a5)
    80004334:	c701                	beqz	a4,8000433c <exec+0x282>
    if(*s == '/')
    80004336:	fed71ce3          	bne	a4,a3,8000432e <exec+0x274>
    8000433a:	bfc5                	j	8000432a <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    8000433c:	4641                	li	a2,16
    8000433e:	df843583          	ld	a1,-520(s0)
    80004342:	160a8513          	addi	a0,s5,352
    80004346:	ffffc097          	auipc	ra,0xffffc
    8000434a:	fce080e7          	jalr	-50(ra) # 80000314 <safestrcpy>
  oldpagetable = p->pagetable;
    8000434e:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004352:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004356:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000435a:	060ab783          	ld	a5,96(s5)
    8000435e:	e6843703          	ld	a4,-408(s0)
    80004362:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004364:	060ab783          	ld	a5,96(s5)
    80004368:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000436c:	85ea                	mv	a1,s10
    8000436e:	ffffd097          	auipc	ra,0xffffd
    80004372:	c84080e7          	jalr	-892(ra) # 80000ff2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004376:	0004851b          	sext.w	a0,s1
    8000437a:	bbe1                	j	80004152 <exec+0x98>
    8000437c:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004380:	e0843583          	ld	a1,-504(s0)
    80004384:	855e                	mv	a0,s7
    80004386:	ffffd097          	auipc	ra,0xffffd
    8000438a:	c6c080e7          	jalr	-916(ra) # 80000ff2 <proc_freepagetable>
  if(ip){
    8000438e:	da0498e3          	bnez	s1,8000413e <exec+0x84>
  return -1;
    80004392:	557d                	li	a0,-1
    80004394:	bb7d                	j	80004152 <exec+0x98>
    80004396:	e1243423          	sd	s2,-504(s0)
    8000439a:	b7dd                	j	80004380 <exec+0x2c6>
    8000439c:	e1243423          	sd	s2,-504(s0)
    800043a0:	b7c5                	j	80004380 <exec+0x2c6>
    800043a2:	e1243423          	sd	s2,-504(s0)
    800043a6:	bfe9                	j	80004380 <exec+0x2c6>
  sz = sz1;
    800043a8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043ac:	4481                	li	s1,0
    800043ae:	bfc9                	j	80004380 <exec+0x2c6>
  sz = sz1;
    800043b0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043b4:	4481                	li	s1,0
    800043b6:	b7e9                	j	80004380 <exec+0x2c6>
  sz = sz1;
    800043b8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043bc:	4481                	li	s1,0
    800043be:	b7c9                	j	80004380 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043c0:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043c4:	2b05                	addiw	s6,s6,1
    800043c6:	0389899b          	addiw	s3,s3,56
    800043ca:	e8845783          	lhu	a5,-376(s0)
    800043ce:	e2fb5be3          	bge	s6,a5,80004204 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043d2:	2981                	sext.w	s3,s3
    800043d4:	03800713          	li	a4,56
    800043d8:	86ce                	mv	a3,s3
    800043da:	e1840613          	addi	a2,s0,-488
    800043de:	4581                	li	a1,0
    800043e0:	8526                	mv	a0,s1
    800043e2:	fffff097          	auipc	ra,0xfffff
    800043e6:	a8e080e7          	jalr	-1394(ra) # 80002e70 <readi>
    800043ea:	03800793          	li	a5,56
    800043ee:	f8f517e3          	bne	a0,a5,8000437c <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800043f2:	e1842783          	lw	a5,-488(s0)
    800043f6:	4705                	li	a4,1
    800043f8:	fce796e3          	bne	a5,a4,800043c4 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800043fc:	e4043603          	ld	a2,-448(s0)
    80004400:	e3843783          	ld	a5,-456(s0)
    80004404:	f8f669e3          	bltu	a2,a5,80004396 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004408:	e2843783          	ld	a5,-472(s0)
    8000440c:	963e                	add	a2,a2,a5
    8000440e:	f8f667e3          	bltu	a2,a5,8000439c <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004412:	85ca                	mv	a1,s2
    80004414:	855e                	mv	a0,s7
    80004416:	ffffc097          	auipc	ra,0xffffc
    8000441a:	4ee080e7          	jalr	1262(ra) # 80000904 <uvmalloc>
    8000441e:	e0a43423          	sd	a0,-504(s0)
    80004422:	d141                	beqz	a0,800043a2 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004424:	e2843d03          	ld	s10,-472(s0)
    80004428:	df043783          	ld	a5,-528(s0)
    8000442c:	00fd77b3          	and	a5,s10,a5
    80004430:	fba1                	bnez	a5,80004380 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004432:	e2042d83          	lw	s11,-480(s0)
    80004436:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000443a:	f80c03e3          	beqz	s8,800043c0 <exec+0x306>
    8000443e:	8a62                	mv	s4,s8
    80004440:	4901                	li	s2,0
    80004442:	b345                	j	800041e2 <exec+0x128>

0000000080004444 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004444:	7179                	addi	sp,sp,-48
    80004446:	f406                	sd	ra,40(sp)
    80004448:	f022                	sd	s0,32(sp)
    8000444a:	ec26                	sd	s1,24(sp)
    8000444c:	e84a                	sd	s2,16(sp)
    8000444e:	1800                	addi	s0,sp,48
    80004450:	892e                	mv	s2,a1
    80004452:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004454:	fdc40593          	addi	a1,s0,-36
    80004458:	ffffe097          	auipc	ra,0xffffe
    8000445c:	b1c080e7          	jalr	-1252(ra) # 80001f74 <argint>
    80004460:	04054063          	bltz	a0,800044a0 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004464:	fdc42703          	lw	a4,-36(s0)
    80004468:	47bd                	li	a5,15
    8000446a:	02e7ed63          	bltu	a5,a4,800044a4 <argfd+0x60>
    8000446e:	ffffd097          	auipc	ra,0xffffd
    80004472:	a24080e7          	jalr	-1500(ra) # 80000e92 <myproc>
    80004476:	fdc42703          	lw	a4,-36(s0)
    8000447a:	01a70793          	addi	a5,a4,26
    8000447e:	078e                	slli	a5,a5,0x3
    80004480:	953e                	add	a0,a0,a5
    80004482:	651c                	ld	a5,8(a0)
    80004484:	c395                	beqz	a5,800044a8 <argfd+0x64>
    return -1;
  if(pfd)
    80004486:	00090463          	beqz	s2,8000448e <argfd+0x4a>
    *pfd = fd;
    8000448a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000448e:	4501                	li	a0,0
  if(pf)
    80004490:	c091                	beqz	s1,80004494 <argfd+0x50>
    *pf = f;
    80004492:	e09c                	sd	a5,0(s1)
}
    80004494:	70a2                	ld	ra,40(sp)
    80004496:	7402                	ld	s0,32(sp)
    80004498:	64e2                	ld	s1,24(sp)
    8000449a:	6942                	ld	s2,16(sp)
    8000449c:	6145                	addi	sp,sp,48
    8000449e:	8082                	ret
    return -1;
    800044a0:	557d                	li	a0,-1
    800044a2:	bfcd                	j	80004494 <argfd+0x50>
    return -1;
    800044a4:	557d                	li	a0,-1
    800044a6:	b7fd                	j	80004494 <argfd+0x50>
    800044a8:	557d                	li	a0,-1
    800044aa:	b7ed                	j	80004494 <argfd+0x50>

00000000800044ac <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044ac:	1101                	addi	sp,sp,-32
    800044ae:	ec06                	sd	ra,24(sp)
    800044b0:	e822                	sd	s0,16(sp)
    800044b2:	e426                	sd	s1,8(sp)
    800044b4:	1000                	addi	s0,sp,32
    800044b6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044b8:	ffffd097          	auipc	ra,0xffffd
    800044bc:	9da080e7          	jalr	-1574(ra) # 80000e92 <myproc>
    800044c0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044c2:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd8e98>
    800044c6:	4501                	li	a0,0
    800044c8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044ca:	6398                	ld	a4,0(a5)
    800044cc:	cb19                	beqz	a4,800044e2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044ce:	2505                	addiw	a0,a0,1
    800044d0:	07a1                	addi	a5,a5,8
    800044d2:	fed51ce3          	bne	a0,a3,800044ca <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044d6:	557d                	li	a0,-1
}
    800044d8:	60e2                	ld	ra,24(sp)
    800044da:	6442                	ld	s0,16(sp)
    800044dc:	64a2                	ld	s1,8(sp)
    800044de:	6105                	addi	sp,sp,32
    800044e0:	8082                	ret
      p->ofile[fd] = f;
    800044e2:	01a50793          	addi	a5,a0,26
    800044e6:	078e                	slli	a5,a5,0x3
    800044e8:	963e                	add	a2,a2,a5
    800044ea:	e604                	sd	s1,8(a2)
      return fd;
    800044ec:	b7f5                	j	800044d8 <fdalloc+0x2c>

00000000800044ee <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044ee:	715d                	addi	sp,sp,-80
    800044f0:	e486                	sd	ra,72(sp)
    800044f2:	e0a2                	sd	s0,64(sp)
    800044f4:	fc26                	sd	s1,56(sp)
    800044f6:	f84a                	sd	s2,48(sp)
    800044f8:	f44e                	sd	s3,40(sp)
    800044fa:	f052                	sd	s4,32(sp)
    800044fc:	ec56                	sd	s5,24(sp)
    800044fe:	0880                	addi	s0,sp,80
    80004500:	89ae                	mv	s3,a1
    80004502:	8ab2                	mv	s5,a2
    80004504:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004506:	fb040593          	addi	a1,s0,-80
    8000450a:	fffff097          	auipc	ra,0xfffff
    8000450e:	e86080e7          	jalr	-378(ra) # 80003390 <nameiparent>
    80004512:	892a                	mv	s2,a0
    80004514:	12050f63          	beqz	a0,80004652 <create+0x164>
    return 0;

  ilock(dp);
    80004518:	ffffe097          	auipc	ra,0xffffe
    8000451c:	6a4080e7          	jalr	1700(ra) # 80002bbc <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004520:	4601                	li	a2,0
    80004522:	fb040593          	addi	a1,s0,-80
    80004526:	854a                	mv	a0,s2
    80004528:	fffff097          	auipc	ra,0xfffff
    8000452c:	b78080e7          	jalr	-1160(ra) # 800030a0 <dirlookup>
    80004530:	84aa                	mv	s1,a0
    80004532:	c921                	beqz	a0,80004582 <create+0x94>
    iunlockput(dp);
    80004534:	854a                	mv	a0,s2
    80004536:	fffff097          	auipc	ra,0xfffff
    8000453a:	8e8080e7          	jalr	-1816(ra) # 80002e1e <iunlockput>
    ilock(ip);
    8000453e:	8526                	mv	a0,s1
    80004540:	ffffe097          	auipc	ra,0xffffe
    80004544:	67c080e7          	jalr	1660(ra) # 80002bbc <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004548:	2981                	sext.w	s3,s3
    8000454a:	4789                	li	a5,2
    8000454c:	02f99463          	bne	s3,a5,80004574 <create+0x86>
    80004550:	0444d783          	lhu	a5,68(s1)
    80004554:	37f9                	addiw	a5,a5,-2
    80004556:	17c2                	slli	a5,a5,0x30
    80004558:	93c1                	srli	a5,a5,0x30
    8000455a:	4705                	li	a4,1
    8000455c:	00f76c63          	bltu	a4,a5,80004574 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004560:	8526                	mv	a0,s1
    80004562:	60a6                	ld	ra,72(sp)
    80004564:	6406                	ld	s0,64(sp)
    80004566:	74e2                	ld	s1,56(sp)
    80004568:	7942                	ld	s2,48(sp)
    8000456a:	79a2                	ld	s3,40(sp)
    8000456c:	7a02                	ld	s4,32(sp)
    8000456e:	6ae2                	ld	s5,24(sp)
    80004570:	6161                	addi	sp,sp,80
    80004572:	8082                	ret
    iunlockput(ip);
    80004574:	8526                	mv	a0,s1
    80004576:	fffff097          	auipc	ra,0xfffff
    8000457a:	8a8080e7          	jalr	-1880(ra) # 80002e1e <iunlockput>
    return 0;
    8000457e:	4481                	li	s1,0
    80004580:	b7c5                	j	80004560 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004582:	85ce                	mv	a1,s3
    80004584:	00092503          	lw	a0,0(s2)
    80004588:	ffffe097          	auipc	ra,0xffffe
    8000458c:	49c080e7          	jalr	1180(ra) # 80002a24 <ialloc>
    80004590:	84aa                	mv	s1,a0
    80004592:	c529                	beqz	a0,800045dc <create+0xee>
  ilock(ip);
    80004594:	ffffe097          	auipc	ra,0xffffe
    80004598:	628080e7          	jalr	1576(ra) # 80002bbc <ilock>
  ip->major = major;
    8000459c:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045a0:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045a4:	4785                	li	a5,1
    800045a6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800045aa:	8526                	mv	a0,s1
    800045ac:	ffffe097          	auipc	ra,0xffffe
    800045b0:	546080e7          	jalr	1350(ra) # 80002af2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045b4:	2981                	sext.w	s3,s3
    800045b6:	4785                	li	a5,1
    800045b8:	02f98a63          	beq	s3,a5,800045ec <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800045bc:	40d0                	lw	a2,4(s1)
    800045be:	fb040593          	addi	a1,s0,-80
    800045c2:	854a                	mv	a0,s2
    800045c4:	fffff097          	auipc	ra,0xfffff
    800045c8:	cec080e7          	jalr	-788(ra) # 800032b0 <dirlink>
    800045cc:	06054b63          	bltz	a0,80004642 <create+0x154>
  iunlockput(dp);
    800045d0:	854a                	mv	a0,s2
    800045d2:	fffff097          	auipc	ra,0xfffff
    800045d6:	84c080e7          	jalr	-1972(ra) # 80002e1e <iunlockput>
  return ip;
    800045da:	b759                	j	80004560 <create+0x72>
    panic("create: ialloc");
    800045dc:	00004517          	auipc	a0,0x4
    800045e0:	21c50513          	addi	a0,a0,540 # 800087f8 <syscall_name+0x2a8>
    800045e4:	00001097          	auipc	ra,0x1
    800045e8:	684080e7          	jalr	1668(ra) # 80005c68 <panic>
    dp->nlink++;  // for ".."
    800045ec:	04a95783          	lhu	a5,74(s2)
    800045f0:	2785                	addiw	a5,a5,1
    800045f2:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800045f6:	854a                	mv	a0,s2
    800045f8:	ffffe097          	auipc	ra,0xffffe
    800045fc:	4fa080e7          	jalr	1274(ra) # 80002af2 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004600:	40d0                	lw	a2,4(s1)
    80004602:	00004597          	auipc	a1,0x4
    80004606:	20658593          	addi	a1,a1,518 # 80008808 <syscall_name+0x2b8>
    8000460a:	8526                	mv	a0,s1
    8000460c:	fffff097          	auipc	ra,0xfffff
    80004610:	ca4080e7          	jalr	-860(ra) # 800032b0 <dirlink>
    80004614:	00054f63          	bltz	a0,80004632 <create+0x144>
    80004618:	00492603          	lw	a2,4(s2)
    8000461c:	00004597          	auipc	a1,0x4
    80004620:	1f458593          	addi	a1,a1,500 # 80008810 <syscall_name+0x2c0>
    80004624:	8526                	mv	a0,s1
    80004626:	fffff097          	auipc	ra,0xfffff
    8000462a:	c8a080e7          	jalr	-886(ra) # 800032b0 <dirlink>
    8000462e:	f80557e3          	bgez	a0,800045bc <create+0xce>
      panic("create dots");
    80004632:	00004517          	auipc	a0,0x4
    80004636:	1e650513          	addi	a0,a0,486 # 80008818 <syscall_name+0x2c8>
    8000463a:	00001097          	auipc	ra,0x1
    8000463e:	62e080e7          	jalr	1582(ra) # 80005c68 <panic>
    panic("create: dirlink");
    80004642:	00004517          	auipc	a0,0x4
    80004646:	1e650513          	addi	a0,a0,486 # 80008828 <syscall_name+0x2d8>
    8000464a:	00001097          	auipc	ra,0x1
    8000464e:	61e080e7          	jalr	1566(ra) # 80005c68 <panic>
    return 0;
    80004652:	84aa                	mv	s1,a0
    80004654:	b731                	j	80004560 <create+0x72>

0000000080004656 <sys_dup>:
{
    80004656:	7179                	addi	sp,sp,-48
    80004658:	f406                	sd	ra,40(sp)
    8000465a:	f022                	sd	s0,32(sp)
    8000465c:	ec26                	sd	s1,24(sp)
    8000465e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004660:	fd840613          	addi	a2,s0,-40
    80004664:	4581                	li	a1,0
    80004666:	4501                	li	a0,0
    80004668:	00000097          	auipc	ra,0x0
    8000466c:	ddc080e7          	jalr	-548(ra) # 80004444 <argfd>
    return -1;
    80004670:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004672:	02054363          	bltz	a0,80004698 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004676:	fd843503          	ld	a0,-40(s0)
    8000467a:	00000097          	auipc	ra,0x0
    8000467e:	e32080e7          	jalr	-462(ra) # 800044ac <fdalloc>
    80004682:	84aa                	mv	s1,a0
    return -1;
    80004684:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004686:	00054963          	bltz	a0,80004698 <sys_dup+0x42>
  filedup(f);
    8000468a:	fd843503          	ld	a0,-40(s0)
    8000468e:	fffff097          	auipc	ra,0xfffff
    80004692:	37a080e7          	jalr	890(ra) # 80003a08 <filedup>
  return fd;
    80004696:	87a6                	mv	a5,s1
}
    80004698:	853e                	mv	a0,a5
    8000469a:	70a2                	ld	ra,40(sp)
    8000469c:	7402                	ld	s0,32(sp)
    8000469e:	64e2                	ld	s1,24(sp)
    800046a0:	6145                	addi	sp,sp,48
    800046a2:	8082                	ret

00000000800046a4 <sys_read>:
{
    800046a4:	7179                	addi	sp,sp,-48
    800046a6:	f406                	sd	ra,40(sp)
    800046a8:	f022                	sd	s0,32(sp)
    800046aa:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ac:	fe840613          	addi	a2,s0,-24
    800046b0:	4581                	li	a1,0
    800046b2:	4501                	li	a0,0
    800046b4:	00000097          	auipc	ra,0x0
    800046b8:	d90080e7          	jalr	-624(ra) # 80004444 <argfd>
    return -1;
    800046bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046be:	04054163          	bltz	a0,80004700 <sys_read+0x5c>
    800046c2:	fe440593          	addi	a1,s0,-28
    800046c6:	4509                	li	a0,2
    800046c8:	ffffe097          	auipc	ra,0xffffe
    800046cc:	8ac080e7          	jalr	-1876(ra) # 80001f74 <argint>
    return -1;
    800046d0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046d2:	02054763          	bltz	a0,80004700 <sys_read+0x5c>
    800046d6:	fd840593          	addi	a1,s0,-40
    800046da:	4505                	li	a0,1
    800046dc:	ffffe097          	auipc	ra,0xffffe
    800046e0:	8ba080e7          	jalr	-1862(ra) # 80001f96 <argaddr>
    return -1;
    800046e4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046e6:	00054d63          	bltz	a0,80004700 <sys_read+0x5c>
  return fileread(f, p, n);
    800046ea:	fe442603          	lw	a2,-28(s0)
    800046ee:	fd843583          	ld	a1,-40(s0)
    800046f2:	fe843503          	ld	a0,-24(s0)
    800046f6:	fffff097          	auipc	ra,0xfffff
    800046fa:	49e080e7          	jalr	1182(ra) # 80003b94 <fileread>
    800046fe:	87aa                	mv	a5,a0
}
    80004700:	853e                	mv	a0,a5
    80004702:	70a2                	ld	ra,40(sp)
    80004704:	7402                	ld	s0,32(sp)
    80004706:	6145                	addi	sp,sp,48
    80004708:	8082                	ret

000000008000470a <sys_write>:
{
    8000470a:	7179                	addi	sp,sp,-48
    8000470c:	f406                	sd	ra,40(sp)
    8000470e:	f022                	sd	s0,32(sp)
    80004710:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004712:	fe840613          	addi	a2,s0,-24
    80004716:	4581                	li	a1,0
    80004718:	4501                	li	a0,0
    8000471a:	00000097          	auipc	ra,0x0
    8000471e:	d2a080e7          	jalr	-726(ra) # 80004444 <argfd>
    return -1;
    80004722:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004724:	04054163          	bltz	a0,80004766 <sys_write+0x5c>
    80004728:	fe440593          	addi	a1,s0,-28
    8000472c:	4509                	li	a0,2
    8000472e:	ffffe097          	auipc	ra,0xffffe
    80004732:	846080e7          	jalr	-1978(ra) # 80001f74 <argint>
    return -1;
    80004736:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004738:	02054763          	bltz	a0,80004766 <sys_write+0x5c>
    8000473c:	fd840593          	addi	a1,s0,-40
    80004740:	4505                	li	a0,1
    80004742:	ffffe097          	auipc	ra,0xffffe
    80004746:	854080e7          	jalr	-1964(ra) # 80001f96 <argaddr>
    return -1;
    8000474a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000474c:	00054d63          	bltz	a0,80004766 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004750:	fe442603          	lw	a2,-28(s0)
    80004754:	fd843583          	ld	a1,-40(s0)
    80004758:	fe843503          	ld	a0,-24(s0)
    8000475c:	fffff097          	auipc	ra,0xfffff
    80004760:	4fa080e7          	jalr	1274(ra) # 80003c56 <filewrite>
    80004764:	87aa                	mv	a5,a0
}
    80004766:	853e                	mv	a0,a5
    80004768:	70a2                	ld	ra,40(sp)
    8000476a:	7402                	ld	s0,32(sp)
    8000476c:	6145                	addi	sp,sp,48
    8000476e:	8082                	ret

0000000080004770 <sys_close>:
{
    80004770:	1101                	addi	sp,sp,-32
    80004772:	ec06                	sd	ra,24(sp)
    80004774:	e822                	sd	s0,16(sp)
    80004776:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004778:	fe040613          	addi	a2,s0,-32
    8000477c:	fec40593          	addi	a1,s0,-20
    80004780:	4501                	li	a0,0
    80004782:	00000097          	auipc	ra,0x0
    80004786:	cc2080e7          	jalr	-830(ra) # 80004444 <argfd>
    return -1;
    8000478a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000478c:	02054463          	bltz	a0,800047b4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004790:	ffffc097          	auipc	ra,0xffffc
    80004794:	702080e7          	jalr	1794(ra) # 80000e92 <myproc>
    80004798:	fec42783          	lw	a5,-20(s0)
    8000479c:	07e9                	addi	a5,a5,26
    8000479e:	078e                	slli	a5,a5,0x3
    800047a0:	97aa                	add	a5,a5,a0
    800047a2:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    800047a6:	fe043503          	ld	a0,-32(s0)
    800047aa:	fffff097          	auipc	ra,0xfffff
    800047ae:	2b0080e7          	jalr	688(ra) # 80003a5a <fileclose>
  return 0;
    800047b2:	4781                	li	a5,0
}
    800047b4:	853e                	mv	a0,a5
    800047b6:	60e2                	ld	ra,24(sp)
    800047b8:	6442                	ld	s0,16(sp)
    800047ba:	6105                	addi	sp,sp,32
    800047bc:	8082                	ret

00000000800047be <sys_fstat>:
{
    800047be:	1101                	addi	sp,sp,-32
    800047c0:	ec06                	sd	ra,24(sp)
    800047c2:	e822                	sd	s0,16(sp)
    800047c4:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047c6:	fe840613          	addi	a2,s0,-24
    800047ca:	4581                	li	a1,0
    800047cc:	4501                	li	a0,0
    800047ce:	00000097          	auipc	ra,0x0
    800047d2:	c76080e7          	jalr	-906(ra) # 80004444 <argfd>
    return -1;
    800047d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047d8:	02054563          	bltz	a0,80004802 <sys_fstat+0x44>
    800047dc:	fe040593          	addi	a1,s0,-32
    800047e0:	4505                	li	a0,1
    800047e2:	ffffd097          	auipc	ra,0xffffd
    800047e6:	7b4080e7          	jalr	1972(ra) # 80001f96 <argaddr>
    return -1;
    800047ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047ec:	00054b63          	bltz	a0,80004802 <sys_fstat+0x44>
  return filestat(f, st);
    800047f0:	fe043583          	ld	a1,-32(s0)
    800047f4:	fe843503          	ld	a0,-24(s0)
    800047f8:	fffff097          	auipc	ra,0xfffff
    800047fc:	32a080e7          	jalr	810(ra) # 80003b22 <filestat>
    80004800:	87aa                	mv	a5,a0
}
    80004802:	853e                	mv	a0,a5
    80004804:	60e2                	ld	ra,24(sp)
    80004806:	6442                	ld	s0,16(sp)
    80004808:	6105                	addi	sp,sp,32
    8000480a:	8082                	ret

000000008000480c <sys_link>:
{
    8000480c:	7169                	addi	sp,sp,-304
    8000480e:	f606                	sd	ra,296(sp)
    80004810:	f222                	sd	s0,288(sp)
    80004812:	ee26                	sd	s1,280(sp)
    80004814:	ea4a                	sd	s2,272(sp)
    80004816:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004818:	08000613          	li	a2,128
    8000481c:	ed040593          	addi	a1,s0,-304
    80004820:	4501                	li	a0,0
    80004822:	ffffd097          	auipc	ra,0xffffd
    80004826:	796080e7          	jalr	1942(ra) # 80001fb8 <argstr>
    return -1;
    8000482a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000482c:	10054e63          	bltz	a0,80004948 <sys_link+0x13c>
    80004830:	08000613          	li	a2,128
    80004834:	f5040593          	addi	a1,s0,-176
    80004838:	4505                	li	a0,1
    8000483a:	ffffd097          	auipc	ra,0xffffd
    8000483e:	77e080e7          	jalr	1918(ra) # 80001fb8 <argstr>
    return -1;
    80004842:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004844:	10054263          	bltz	a0,80004948 <sys_link+0x13c>
  begin_op();
    80004848:	fffff097          	auipc	ra,0xfffff
    8000484c:	d46080e7          	jalr	-698(ra) # 8000358e <begin_op>
  if((ip = namei(old)) == 0){
    80004850:	ed040513          	addi	a0,s0,-304
    80004854:	fffff097          	auipc	ra,0xfffff
    80004858:	b1e080e7          	jalr	-1250(ra) # 80003372 <namei>
    8000485c:	84aa                	mv	s1,a0
    8000485e:	c551                	beqz	a0,800048ea <sys_link+0xde>
  ilock(ip);
    80004860:	ffffe097          	auipc	ra,0xffffe
    80004864:	35c080e7          	jalr	860(ra) # 80002bbc <ilock>
  if(ip->type == T_DIR){
    80004868:	04449703          	lh	a4,68(s1)
    8000486c:	4785                	li	a5,1
    8000486e:	08f70463          	beq	a4,a5,800048f6 <sys_link+0xea>
  ip->nlink++;
    80004872:	04a4d783          	lhu	a5,74(s1)
    80004876:	2785                	addiw	a5,a5,1
    80004878:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000487c:	8526                	mv	a0,s1
    8000487e:	ffffe097          	auipc	ra,0xffffe
    80004882:	274080e7          	jalr	628(ra) # 80002af2 <iupdate>
  iunlock(ip);
    80004886:	8526                	mv	a0,s1
    80004888:	ffffe097          	auipc	ra,0xffffe
    8000488c:	3f6080e7          	jalr	1014(ra) # 80002c7e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004890:	fd040593          	addi	a1,s0,-48
    80004894:	f5040513          	addi	a0,s0,-176
    80004898:	fffff097          	auipc	ra,0xfffff
    8000489c:	af8080e7          	jalr	-1288(ra) # 80003390 <nameiparent>
    800048a0:	892a                	mv	s2,a0
    800048a2:	c935                	beqz	a0,80004916 <sys_link+0x10a>
  ilock(dp);
    800048a4:	ffffe097          	auipc	ra,0xffffe
    800048a8:	318080e7          	jalr	792(ra) # 80002bbc <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048ac:	00092703          	lw	a4,0(s2)
    800048b0:	409c                	lw	a5,0(s1)
    800048b2:	04f71d63          	bne	a4,a5,8000490c <sys_link+0x100>
    800048b6:	40d0                	lw	a2,4(s1)
    800048b8:	fd040593          	addi	a1,s0,-48
    800048bc:	854a                	mv	a0,s2
    800048be:	fffff097          	auipc	ra,0xfffff
    800048c2:	9f2080e7          	jalr	-1550(ra) # 800032b0 <dirlink>
    800048c6:	04054363          	bltz	a0,8000490c <sys_link+0x100>
  iunlockput(dp);
    800048ca:	854a                	mv	a0,s2
    800048cc:	ffffe097          	auipc	ra,0xffffe
    800048d0:	552080e7          	jalr	1362(ra) # 80002e1e <iunlockput>
  iput(ip);
    800048d4:	8526                	mv	a0,s1
    800048d6:	ffffe097          	auipc	ra,0xffffe
    800048da:	4a0080e7          	jalr	1184(ra) # 80002d76 <iput>
  end_op();
    800048de:	fffff097          	auipc	ra,0xfffff
    800048e2:	d30080e7          	jalr	-720(ra) # 8000360e <end_op>
  return 0;
    800048e6:	4781                	li	a5,0
    800048e8:	a085                	j	80004948 <sys_link+0x13c>
    end_op();
    800048ea:	fffff097          	auipc	ra,0xfffff
    800048ee:	d24080e7          	jalr	-732(ra) # 8000360e <end_op>
    return -1;
    800048f2:	57fd                	li	a5,-1
    800048f4:	a891                	j	80004948 <sys_link+0x13c>
    iunlockput(ip);
    800048f6:	8526                	mv	a0,s1
    800048f8:	ffffe097          	auipc	ra,0xffffe
    800048fc:	526080e7          	jalr	1318(ra) # 80002e1e <iunlockput>
    end_op();
    80004900:	fffff097          	auipc	ra,0xfffff
    80004904:	d0e080e7          	jalr	-754(ra) # 8000360e <end_op>
    return -1;
    80004908:	57fd                	li	a5,-1
    8000490a:	a83d                	j	80004948 <sys_link+0x13c>
    iunlockput(dp);
    8000490c:	854a                	mv	a0,s2
    8000490e:	ffffe097          	auipc	ra,0xffffe
    80004912:	510080e7          	jalr	1296(ra) # 80002e1e <iunlockput>
  ilock(ip);
    80004916:	8526                	mv	a0,s1
    80004918:	ffffe097          	auipc	ra,0xffffe
    8000491c:	2a4080e7          	jalr	676(ra) # 80002bbc <ilock>
  ip->nlink--;
    80004920:	04a4d783          	lhu	a5,74(s1)
    80004924:	37fd                	addiw	a5,a5,-1
    80004926:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000492a:	8526                	mv	a0,s1
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	1c6080e7          	jalr	454(ra) # 80002af2 <iupdate>
  iunlockput(ip);
    80004934:	8526                	mv	a0,s1
    80004936:	ffffe097          	auipc	ra,0xffffe
    8000493a:	4e8080e7          	jalr	1256(ra) # 80002e1e <iunlockput>
  end_op();
    8000493e:	fffff097          	auipc	ra,0xfffff
    80004942:	cd0080e7          	jalr	-816(ra) # 8000360e <end_op>
  return -1;
    80004946:	57fd                	li	a5,-1
}
    80004948:	853e                	mv	a0,a5
    8000494a:	70b2                	ld	ra,296(sp)
    8000494c:	7412                	ld	s0,288(sp)
    8000494e:	64f2                	ld	s1,280(sp)
    80004950:	6952                	ld	s2,272(sp)
    80004952:	6155                	addi	sp,sp,304
    80004954:	8082                	ret

0000000080004956 <sys_unlink>:
{
    80004956:	7151                	addi	sp,sp,-240
    80004958:	f586                	sd	ra,232(sp)
    8000495a:	f1a2                	sd	s0,224(sp)
    8000495c:	eda6                	sd	s1,216(sp)
    8000495e:	e9ca                	sd	s2,208(sp)
    80004960:	e5ce                	sd	s3,200(sp)
    80004962:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004964:	08000613          	li	a2,128
    80004968:	f3040593          	addi	a1,s0,-208
    8000496c:	4501                	li	a0,0
    8000496e:	ffffd097          	auipc	ra,0xffffd
    80004972:	64a080e7          	jalr	1610(ra) # 80001fb8 <argstr>
    80004976:	18054163          	bltz	a0,80004af8 <sys_unlink+0x1a2>
  begin_op();
    8000497a:	fffff097          	auipc	ra,0xfffff
    8000497e:	c14080e7          	jalr	-1004(ra) # 8000358e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004982:	fb040593          	addi	a1,s0,-80
    80004986:	f3040513          	addi	a0,s0,-208
    8000498a:	fffff097          	auipc	ra,0xfffff
    8000498e:	a06080e7          	jalr	-1530(ra) # 80003390 <nameiparent>
    80004992:	84aa                	mv	s1,a0
    80004994:	c979                	beqz	a0,80004a6a <sys_unlink+0x114>
  ilock(dp);
    80004996:	ffffe097          	auipc	ra,0xffffe
    8000499a:	226080e7          	jalr	550(ra) # 80002bbc <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000499e:	00004597          	auipc	a1,0x4
    800049a2:	e6a58593          	addi	a1,a1,-406 # 80008808 <syscall_name+0x2b8>
    800049a6:	fb040513          	addi	a0,s0,-80
    800049aa:	ffffe097          	auipc	ra,0xffffe
    800049ae:	6dc080e7          	jalr	1756(ra) # 80003086 <namecmp>
    800049b2:	14050a63          	beqz	a0,80004b06 <sys_unlink+0x1b0>
    800049b6:	00004597          	auipc	a1,0x4
    800049ba:	e5a58593          	addi	a1,a1,-422 # 80008810 <syscall_name+0x2c0>
    800049be:	fb040513          	addi	a0,s0,-80
    800049c2:	ffffe097          	auipc	ra,0xffffe
    800049c6:	6c4080e7          	jalr	1732(ra) # 80003086 <namecmp>
    800049ca:	12050e63          	beqz	a0,80004b06 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049ce:	f2c40613          	addi	a2,s0,-212
    800049d2:	fb040593          	addi	a1,s0,-80
    800049d6:	8526                	mv	a0,s1
    800049d8:	ffffe097          	auipc	ra,0xffffe
    800049dc:	6c8080e7          	jalr	1736(ra) # 800030a0 <dirlookup>
    800049e0:	892a                	mv	s2,a0
    800049e2:	12050263          	beqz	a0,80004b06 <sys_unlink+0x1b0>
  ilock(ip);
    800049e6:	ffffe097          	auipc	ra,0xffffe
    800049ea:	1d6080e7          	jalr	470(ra) # 80002bbc <ilock>
  if(ip->nlink < 1)
    800049ee:	04a91783          	lh	a5,74(s2)
    800049f2:	08f05263          	blez	a5,80004a76 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049f6:	04491703          	lh	a4,68(s2)
    800049fa:	4785                	li	a5,1
    800049fc:	08f70563          	beq	a4,a5,80004a86 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a00:	4641                	li	a2,16
    80004a02:	4581                	li	a1,0
    80004a04:	fc040513          	addi	a0,s0,-64
    80004a08:	ffffb097          	auipc	ra,0xffffb
    80004a0c:	7ba080e7          	jalr	1978(ra) # 800001c2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a10:	4741                	li	a4,16
    80004a12:	f2c42683          	lw	a3,-212(s0)
    80004a16:	fc040613          	addi	a2,s0,-64
    80004a1a:	4581                	li	a1,0
    80004a1c:	8526                	mv	a0,s1
    80004a1e:	ffffe097          	auipc	ra,0xffffe
    80004a22:	54a080e7          	jalr	1354(ra) # 80002f68 <writei>
    80004a26:	47c1                	li	a5,16
    80004a28:	0af51563          	bne	a0,a5,80004ad2 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a2c:	04491703          	lh	a4,68(s2)
    80004a30:	4785                	li	a5,1
    80004a32:	0af70863          	beq	a4,a5,80004ae2 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a36:	8526                	mv	a0,s1
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	3e6080e7          	jalr	998(ra) # 80002e1e <iunlockput>
  ip->nlink--;
    80004a40:	04a95783          	lhu	a5,74(s2)
    80004a44:	37fd                	addiw	a5,a5,-1
    80004a46:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a4a:	854a                	mv	a0,s2
    80004a4c:	ffffe097          	auipc	ra,0xffffe
    80004a50:	0a6080e7          	jalr	166(ra) # 80002af2 <iupdate>
  iunlockput(ip);
    80004a54:	854a                	mv	a0,s2
    80004a56:	ffffe097          	auipc	ra,0xffffe
    80004a5a:	3c8080e7          	jalr	968(ra) # 80002e1e <iunlockput>
  end_op();
    80004a5e:	fffff097          	auipc	ra,0xfffff
    80004a62:	bb0080e7          	jalr	-1104(ra) # 8000360e <end_op>
  return 0;
    80004a66:	4501                	li	a0,0
    80004a68:	a84d                	j	80004b1a <sys_unlink+0x1c4>
    end_op();
    80004a6a:	fffff097          	auipc	ra,0xfffff
    80004a6e:	ba4080e7          	jalr	-1116(ra) # 8000360e <end_op>
    return -1;
    80004a72:	557d                	li	a0,-1
    80004a74:	a05d                	j	80004b1a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a76:	00004517          	auipc	a0,0x4
    80004a7a:	dc250513          	addi	a0,a0,-574 # 80008838 <syscall_name+0x2e8>
    80004a7e:	00001097          	auipc	ra,0x1
    80004a82:	1ea080e7          	jalr	490(ra) # 80005c68 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a86:	04c92703          	lw	a4,76(s2)
    80004a8a:	02000793          	li	a5,32
    80004a8e:	f6e7f9e3          	bgeu	a5,a4,80004a00 <sys_unlink+0xaa>
    80004a92:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a96:	4741                	li	a4,16
    80004a98:	86ce                	mv	a3,s3
    80004a9a:	f1840613          	addi	a2,s0,-232
    80004a9e:	4581                	li	a1,0
    80004aa0:	854a                	mv	a0,s2
    80004aa2:	ffffe097          	auipc	ra,0xffffe
    80004aa6:	3ce080e7          	jalr	974(ra) # 80002e70 <readi>
    80004aaa:	47c1                	li	a5,16
    80004aac:	00f51b63          	bne	a0,a5,80004ac2 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ab0:	f1845783          	lhu	a5,-232(s0)
    80004ab4:	e7a1                	bnez	a5,80004afc <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ab6:	29c1                	addiw	s3,s3,16
    80004ab8:	04c92783          	lw	a5,76(s2)
    80004abc:	fcf9ede3          	bltu	s3,a5,80004a96 <sys_unlink+0x140>
    80004ac0:	b781                	j	80004a00 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ac2:	00004517          	auipc	a0,0x4
    80004ac6:	d8e50513          	addi	a0,a0,-626 # 80008850 <syscall_name+0x300>
    80004aca:	00001097          	auipc	ra,0x1
    80004ace:	19e080e7          	jalr	414(ra) # 80005c68 <panic>
    panic("unlink: writei");
    80004ad2:	00004517          	auipc	a0,0x4
    80004ad6:	d9650513          	addi	a0,a0,-618 # 80008868 <syscall_name+0x318>
    80004ada:	00001097          	auipc	ra,0x1
    80004ade:	18e080e7          	jalr	398(ra) # 80005c68 <panic>
    dp->nlink--;
    80004ae2:	04a4d783          	lhu	a5,74(s1)
    80004ae6:	37fd                	addiw	a5,a5,-1
    80004ae8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004aec:	8526                	mv	a0,s1
    80004aee:	ffffe097          	auipc	ra,0xffffe
    80004af2:	004080e7          	jalr	4(ra) # 80002af2 <iupdate>
    80004af6:	b781                	j	80004a36 <sys_unlink+0xe0>
    return -1;
    80004af8:	557d                	li	a0,-1
    80004afa:	a005                	j	80004b1a <sys_unlink+0x1c4>
    iunlockput(ip);
    80004afc:	854a                	mv	a0,s2
    80004afe:	ffffe097          	auipc	ra,0xffffe
    80004b02:	320080e7          	jalr	800(ra) # 80002e1e <iunlockput>
  iunlockput(dp);
    80004b06:	8526                	mv	a0,s1
    80004b08:	ffffe097          	auipc	ra,0xffffe
    80004b0c:	316080e7          	jalr	790(ra) # 80002e1e <iunlockput>
  end_op();
    80004b10:	fffff097          	auipc	ra,0xfffff
    80004b14:	afe080e7          	jalr	-1282(ra) # 8000360e <end_op>
  return -1;
    80004b18:	557d                	li	a0,-1
}
    80004b1a:	70ae                	ld	ra,232(sp)
    80004b1c:	740e                	ld	s0,224(sp)
    80004b1e:	64ee                	ld	s1,216(sp)
    80004b20:	694e                	ld	s2,208(sp)
    80004b22:	69ae                	ld	s3,200(sp)
    80004b24:	616d                	addi	sp,sp,240
    80004b26:	8082                	ret

0000000080004b28 <sys_open>:

uint64
sys_open(void)
{
    80004b28:	7131                	addi	sp,sp,-192
    80004b2a:	fd06                	sd	ra,184(sp)
    80004b2c:	f922                	sd	s0,176(sp)
    80004b2e:	f526                	sd	s1,168(sp)
    80004b30:	f14a                	sd	s2,160(sp)
    80004b32:	ed4e                	sd	s3,152(sp)
    80004b34:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b36:	08000613          	li	a2,128
    80004b3a:	f5040593          	addi	a1,s0,-176
    80004b3e:	4501                	li	a0,0
    80004b40:	ffffd097          	auipc	ra,0xffffd
    80004b44:	478080e7          	jalr	1144(ra) # 80001fb8 <argstr>
    return -1;
    80004b48:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b4a:	0c054163          	bltz	a0,80004c0c <sys_open+0xe4>
    80004b4e:	f4c40593          	addi	a1,s0,-180
    80004b52:	4505                	li	a0,1
    80004b54:	ffffd097          	auipc	ra,0xffffd
    80004b58:	420080e7          	jalr	1056(ra) # 80001f74 <argint>
    80004b5c:	0a054863          	bltz	a0,80004c0c <sys_open+0xe4>

  begin_op();
    80004b60:	fffff097          	auipc	ra,0xfffff
    80004b64:	a2e080e7          	jalr	-1490(ra) # 8000358e <begin_op>

  if(omode & O_CREATE){
    80004b68:	f4c42783          	lw	a5,-180(s0)
    80004b6c:	2007f793          	andi	a5,a5,512
    80004b70:	cbdd                	beqz	a5,80004c26 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b72:	4681                	li	a3,0
    80004b74:	4601                	li	a2,0
    80004b76:	4589                	li	a1,2
    80004b78:	f5040513          	addi	a0,s0,-176
    80004b7c:	00000097          	auipc	ra,0x0
    80004b80:	972080e7          	jalr	-1678(ra) # 800044ee <create>
    80004b84:	892a                	mv	s2,a0
    if(ip == 0){
    80004b86:	c959                	beqz	a0,80004c1c <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b88:	04491703          	lh	a4,68(s2)
    80004b8c:	478d                	li	a5,3
    80004b8e:	00f71763          	bne	a4,a5,80004b9c <sys_open+0x74>
    80004b92:	04695703          	lhu	a4,70(s2)
    80004b96:	47a5                	li	a5,9
    80004b98:	0ce7ec63          	bltu	a5,a4,80004c70 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b9c:	fffff097          	auipc	ra,0xfffff
    80004ba0:	e02080e7          	jalr	-510(ra) # 8000399e <filealloc>
    80004ba4:	89aa                	mv	s3,a0
    80004ba6:	10050263          	beqz	a0,80004caa <sys_open+0x182>
    80004baa:	00000097          	auipc	ra,0x0
    80004bae:	902080e7          	jalr	-1790(ra) # 800044ac <fdalloc>
    80004bb2:	84aa                	mv	s1,a0
    80004bb4:	0e054663          	bltz	a0,80004ca0 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bb8:	04491703          	lh	a4,68(s2)
    80004bbc:	478d                	li	a5,3
    80004bbe:	0cf70463          	beq	a4,a5,80004c86 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bc2:	4789                	li	a5,2
    80004bc4:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bc8:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bcc:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bd0:	f4c42783          	lw	a5,-180(s0)
    80004bd4:	0017c713          	xori	a4,a5,1
    80004bd8:	8b05                	andi	a4,a4,1
    80004bda:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bde:	0037f713          	andi	a4,a5,3
    80004be2:	00e03733          	snez	a4,a4
    80004be6:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bea:	4007f793          	andi	a5,a5,1024
    80004bee:	c791                	beqz	a5,80004bfa <sys_open+0xd2>
    80004bf0:	04491703          	lh	a4,68(s2)
    80004bf4:	4789                	li	a5,2
    80004bf6:	08f70f63          	beq	a4,a5,80004c94 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004bfa:	854a                	mv	a0,s2
    80004bfc:	ffffe097          	auipc	ra,0xffffe
    80004c00:	082080e7          	jalr	130(ra) # 80002c7e <iunlock>
  end_op();
    80004c04:	fffff097          	auipc	ra,0xfffff
    80004c08:	a0a080e7          	jalr	-1526(ra) # 8000360e <end_op>

  return fd;
}
    80004c0c:	8526                	mv	a0,s1
    80004c0e:	70ea                	ld	ra,184(sp)
    80004c10:	744a                	ld	s0,176(sp)
    80004c12:	74aa                	ld	s1,168(sp)
    80004c14:	790a                	ld	s2,160(sp)
    80004c16:	69ea                	ld	s3,152(sp)
    80004c18:	6129                	addi	sp,sp,192
    80004c1a:	8082                	ret
      end_op();
    80004c1c:	fffff097          	auipc	ra,0xfffff
    80004c20:	9f2080e7          	jalr	-1550(ra) # 8000360e <end_op>
      return -1;
    80004c24:	b7e5                	j	80004c0c <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c26:	f5040513          	addi	a0,s0,-176
    80004c2a:	ffffe097          	auipc	ra,0xffffe
    80004c2e:	748080e7          	jalr	1864(ra) # 80003372 <namei>
    80004c32:	892a                	mv	s2,a0
    80004c34:	c905                	beqz	a0,80004c64 <sys_open+0x13c>
    ilock(ip);
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	f86080e7          	jalr	-122(ra) # 80002bbc <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c3e:	04491703          	lh	a4,68(s2)
    80004c42:	4785                	li	a5,1
    80004c44:	f4f712e3          	bne	a4,a5,80004b88 <sys_open+0x60>
    80004c48:	f4c42783          	lw	a5,-180(s0)
    80004c4c:	dba1                	beqz	a5,80004b9c <sys_open+0x74>
      iunlockput(ip);
    80004c4e:	854a                	mv	a0,s2
    80004c50:	ffffe097          	auipc	ra,0xffffe
    80004c54:	1ce080e7          	jalr	462(ra) # 80002e1e <iunlockput>
      end_op();
    80004c58:	fffff097          	auipc	ra,0xfffff
    80004c5c:	9b6080e7          	jalr	-1610(ra) # 8000360e <end_op>
      return -1;
    80004c60:	54fd                	li	s1,-1
    80004c62:	b76d                	j	80004c0c <sys_open+0xe4>
      end_op();
    80004c64:	fffff097          	auipc	ra,0xfffff
    80004c68:	9aa080e7          	jalr	-1622(ra) # 8000360e <end_op>
      return -1;
    80004c6c:	54fd                	li	s1,-1
    80004c6e:	bf79                	j	80004c0c <sys_open+0xe4>
    iunlockput(ip);
    80004c70:	854a                	mv	a0,s2
    80004c72:	ffffe097          	auipc	ra,0xffffe
    80004c76:	1ac080e7          	jalr	428(ra) # 80002e1e <iunlockput>
    end_op();
    80004c7a:	fffff097          	auipc	ra,0xfffff
    80004c7e:	994080e7          	jalr	-1644(ra) # 8000360e <end_op>
    return -1;
    80004c82:	54fd                	li	s1,-1
    80004c84:	b761                	j	80004c0c <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c86:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c8a:	04691783          	lh	a5,70(s2)
    80004c8e:	02f99223          	sh	a5,36(s3)
    80004c92:	bf2d                	j	80004bcc <sys_open+0xa4>
    itrunc(ip);
    80004c94:	854a                	mv	a0,s2
    80004c96:	ffffe097          	auipc	ra,0xffffe
    80004c9a:	034080e7          	jalr	52(ra) # 80002cca <itrunc>
    80004c9e:	bfb1                	j	80004bfa <sys_open+0xd2>
      fileclose(f);
    80004ca0:	854e                	mv	a0,s3
    80004ca2:	fffff097          	auipc	ra,0xfffff
    80004ca6:	db8080e7          	jalr	-584(ra) # 80003a5a <fileclose>
    iunlockput(ip);
    80004caa:	854a                	mv	a0,s2
    80004cac:	ffffe097          	auipc	ra,0xffffe
    80004cb0:	172080e7          	jalr	370(ra) # 80002e1e <iunlockput>
    end_op();
    80004cb4:	fffff097          	auipc	ra,0xfffff
    80004cb8:	95a080e7          	jalr	-1702(ra) # 8000360e <end_op>
    return -1;
    80004cbc:	54fd                	li	s1,-1
    80004cbe:	b7b9                	j	80004c0c <sys_open+0xe4>

0000000080004cc0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cc0:	7175                	addi	sp,sp,-144
    80004cc2:	e506                	sd	ra,136(sp)
    80004cc4:	e122                	sd	s0,128(sp)
    80004cc6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cc8:	fffff097          	auipc	ra,0xfffff
    80004ccc:	8c6080e7          	jalr	-1850(ra) # 8000358e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cd0:	08000613          	li	a2,128
    80004cd4:	f7040593          	addi	a1,s0,-144
    80004cd8:	4501                	li	a0,0
    80004cda:	ffffd097          	auipc	ra,0xffffd
    80004cde:	2de080e7          	jalr	734(ra) # 80001fb8 <argstr>
    80004ce2:	02054963          	bltz	a0,80004d14 <sys_mkdir+0x54>
    80004ce6:	4681                	li	a3,0
    80004ce8:	4601                	li	a2,0
    80004cea:	4585                	li	a1,1
    80004cec:	f7040513          	addi	a0,s0,-144
    80004cf0:	fffff097          	auipc	ra,0xfffff
    80004cf4:	7fe080e7          	jalr	2046(ra) # 800044ee <create>
    80004cf8:	cd11                	beqz	a0,80004d14 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cfa:	ffffe097          	auipc	ra,0xffffe
    80004cfe:	124080e7          	jalr	292(ra) # 80002e1e <iunlockput>
  end_op();
    80004d02:	fffff097          	auipc	ra,0xfffff
    80004d06:	90c080e7          	jalr	-1780(ra) # 8000360e <end_op>
  return 0;
    80004d0a:	4501                	li	a0,0
}
    80004d0c:	60aa                	ld	ra,136(sp)
    80004d0e:	640a                	ld	s0,128(sp)
    80004d10:	6149                	addi	sp,sp,144
    80004d12:	8082                	ret
    end_op();
    80004d14:	fffff097          	auipc	ra,0xfffff
    80004d18:	8fa080e7          	jalr	-1798(ra) # 8000360e <end_op>
    return -1;
    80004d1c:	557d                	li	a0,-1
    80004d1e:	b7fd                	j	80004d0c <sys_mkdir+0x4c>

0000000080004d20 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d20:	7135                	addi	sp,sp,-160
    80004d22:	ed06                	sd	ra,152(sp)
    80004d24:	e922                	sd	s0,144(sp)
    80004d26:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d28:	fffff097          	auipc	ra,0xfffff
    80004d2c:	866080e7          	jalr	-1946(ra) # 8000358e <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d30:	08000613          	li	a2,128
    80004d34:	f7040593          	addi	a1,s0,-144
    80004d38:	4501                	li	a0,0
    80004d3a:	ffffd097          	auipc	ra,0xffffd
    80004d3e:	27e080e7          	jalr	638(ra) # 80001fb8 <argstr>
    80004d42:	04054a63          	bltz	a0,80004d96 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d46:	f6c40593          	addi	a1,s0,-148
    80004d4a:	4505                	li	a0,1
    80004d4c:	ffffd097          	auipc	ra,0xffffd
    80004d50:	228080e7          	jalr	552(ra) # 80001f74 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d54:	04054163          	bltz	a0,80004d96 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d58:	f6840593          	addi	a1,s0,-152
    80004d5c:	4509                	li	a0,2
    80004d5e:	ffffd097          	auipc	ra,0xffffd
    80004d62:	216080e7          	jalr	534(ra) # 80001f74 <argint>
     argint(1, &major) < 0 ||
    80004d66:	02054863          	bltz	a0,80004d96 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d6a:	f6841683          	lh	a3,-152(s0)
    80004d6e:	f6c41603          	lh	a2,-148(s0)
    80004d72:	458d                	li	a1,3
    80004d74:	f7040513          	addi	a0,s0,-144
    80004d78:	fffff097          	auipc	ra,0xfffff
    80004d7c:	776080e7          	jalr	1910(ra) # 800044ee <create>
     argint(2, &minor) < 0 ||
    80004d80:	c919                	beqz	a0,80004d96 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d82:	ffffe097          	auipc	ra,0xffffe
    80004d86:	09c080e7          	jalr	156(ra) # 80002e1e <iunlockput>
  end_op();
    80004d8a:	fffff097          	auipc	ra,0xfffff
    80004d8e:	884080e7          	jalr	-1916(ra) # 8000360e <end_op>
  return 0;
    80004d92:	4501                	li	a0,0
    80004d94:	a031                	j	80004da0 <sys_mknod+0x80>
    end_op();
    80004d96:	fffff097          	auipc	ra,0xfffff
    80004d9a:	878080e7          	jalr	-1928(ra) # 8000360e <end_op>
    return -1;
    80004d9e:	557d                	li	a0,-1
}
    80004da0:	60ea                	ld	ra,152(sp)
    80004da2:	644a                	ld	s0,144(sp)
    80004da4:	610d                	addi	sp,sp,160
    80004da6:	8082                	ret

0000000080004da8 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004da8:	7135                	addi	sp,sp,-160
    80004daa:	ed06                	sd	ra,152(sp)
    80004dac:	e922                	sd	s0,144(sp)
    80004dae:	e526                	sd	s1,136(sp)
    80004db0:	e14a                	sd	s2,128(sp)
    80004db2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004db4:	ffffc097          	auipc	ra,0xffffc
    80004db8:	0de080e7          	jalr	222(ra) # 80000e92 <myproc>
    80004dbc:	892a                	mv	s2,a0
  
  begin_op();
    80004dbe:	ffffe097          	auipc	ra,0xffffe
    80004dc2:	7d0080e7          	jalr	2000(ra) # 8000358e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dc6:	08000613          	li	a2,128
    80004dca:	f6040593          	addi	a1,s0,-160
    80004dce:	4501                	li	a0,0
    80004dd0:	ffffd097          	auipc	ra,0xffffd
    80004dd4:	1e8080e7          	jalr	488(ra) # 80001fb8 <argstr>
    80004dd8:	04054b63          	bltz	a0,80004e2e <sys_chdir+0x86>
    80004ddc:	f6040513          	addi	a0,s0,-160
    80004de0:	ffffe097          	auipc	ra,0xffffe
    80004de4:	592080e7          	jalr	1426(ra) # 80003372 <namei>
    80004de8:	84aa                	mv	s1,a0
    80004dea:	c131                	beqz	a0,80004e2e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004dec:	ffffe097          	auipc	ra,0xffffe
    80004df0:	dd0080e7          	jalr	-560(ra) # 80002bbc <ilock>
  if(ip->type != T_DIR){
    80004df4:	04449703          	lh	a4,68(s1)
    80004df8:	4785                	li	a5,1
    80004dfa:	04f71063          	bne	a4,a5,80004e3a <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004dfe:	8526                	mv	a0,s1
    80004e00:	ffffe097          	auipc	ra,0xffffe
    80004e04:	e7e080e7          	jalr	-386(ra) # 80002c7e <iunlock>
  iput(p->cwd);
    80004e08:	15893503          	ld	a0,344(s2)
    80004e0c:	ffffe097          	auipc	ra,0xffffe
    80004e10:	f6a080e7          	jalr	-150(ra) # 80002d76 <iput>
  end_op();
    80004e14:	ffffe097          	auipc	ra,0xffffe
    80004e18:	7fa080e7          	jalr	2042(ra) # 8000360e <end_op>
  p->cwd = ip;
    80004e1c:	14993c23          	sd	s1,344(s2)
  return 0;
    80004e20:	4501                	li	a0,0
}
    80004e22:	60ea                	ld	ra,152(sp)
    80004e24:	644a                	ld	s0,144(sp)
    80004e26:	64aa                	ld	s1,136(sp)
    80004e28:	690a                	ld	s2,128(sp)
    80004e2a:	610d                	addi	sp,sp,160
    80004e2c:	8082                	ret
    end_op();
    80004e2e:	ffffe097          	auipc	ra,0xffffe
    80004e32:	7e0080e7          	jalr	2016(ra) # 8000360e <end_op>
    return -1;
    80004e36:	557d                	li	a0,-1
    80004e38:	b7ed                	j	80004e22 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e3a:	8526                	mv	a0,s1
    80004e3c:	ffffe097          	auipc	ra,0xffffe
    80004e40:	fe2080e7          	jalr	-30(ra) # 80002e1e <iunlockput>
    end_op();
    80004e44:	ffffe097          	auipc	ra,0xffffe
    80004e48:	7ca080e7          	jalr	1994(ra) # 8000360e <end_op>
    return -1;
    80004e4c:	557d                	li	a0,-1
    80004e4e:	bfd1                	j	80004e22 <sys_chdir+0x7a>

0000000080004e50 <sys_exec>:

uint64
sys_exec(void)
{
    80004e50:	7145                	addi	sp,sp,-464
    80004e52:	e786                	sd	ra,456(sp)
    80004e54:	e3a2                	sd	s0,448(sp)
    80004e56:	ff26                	sd	s1,440(sp)
    80004e58:	fb4a                	sd	s2,432(sp)
    80004e5a:	f74e                	sd	s3,424(sp)
    80004e5c:	f352                	sd	s4,416(sp)
    80004e5e:	ef56                	sd	s5,408(sp)
    80004e60:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e62:	08000613          	li	a2,128
    80004e66:	f4040593          	addi	a1,s0,-192
    80004e6a:	4501                	li	a0,0
    80004e6c:	ffffd097          	auipc	ra,0xffffd
    80004e70:	14c080e7          	jalr	332(ra) # 80001fb8 <argstr>
    return -1;
    80004e74:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e76:	0c054a63          	bltz	a0,80004f4a <sys_exec+0xfa>
    80004e7a:	e3840593          	addi	a1,s0,-456
    80004e7e:	4505                	li	a0,1
    80004e80:	ffffd097          	auipc	ra,0xffffd
    80004e84:	116080e7          	jalr	278(ra) # 80001f96 <argaddr>
    80004e88:	0c054163          	bltz	a0,80004f4a <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e8c:	10000613          	li	a2,256
    80004e90:	4581                	li	a1,0
    80004e92:	e4040513          	addi	a0,s0,-448
    80004e96:	ffffb097          	auipc	ra,0xffffb
    80004e9a:	32c080e7          	jalr	812(ra) # 800001c2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e9e:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ea2:	89a6                	mv	s3,s1
    80004ea4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ea6:	02000a13          	li	s4,32
    80004eaa:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004eae:	00391513          	slli	a0,s2,0x3
    80004eb2:	e3040593          	addi	a1,s0,-464
    80004eb6:	e3843783          	ld	a5,-456(s0)
    80004eba:	953e                	add	a0,a0,a5
    80004ebc:	ffffd097          	auipc	ra,0xffffd
    80004ec0:	01e080e7          	jalr	30(ra) # 80001eda <fetchaddr>
    80004ec4:	02054a63          	bltz	a0,80004ef8 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004ec8:	e3043783          	ld	a5,-464(s0)
    80004ecc:	c3b9                	beqz	a5,80004f12 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ece:	ffffb097          	auipc	ra,0xffffb
    80004ed2:	24a080e7          	jalr	586(ra) # 80000118 <kalloc>
    80004ed6:	85aa                	mv	a1,a0
    80004ed8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004edc:	cd11                	beqz	a0,80004ef8 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ede:	6605                	lui	a2,0x1
    80004ee0:	e3043503          	ld	a0,-464(s0)
    80004ee4:	ffffd097          	auipc	ra,0xffffd
    80004ee8:	048080e7          	jalr	72(ra) # 80001f2c <fetchstr>
    80004eec:	00054663          	bltz	a0,80004ef8 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004ef0:	0905                	addi	s2,s2,1
    80004ef2:	09a1                	addi	s3,s3,8
    80004ef4:	fb491be3          	bne	s2,s4,80004eaa <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ef8:	10048913          	addi	s2,s1,256
    80004efc:	6088                	ld	a0,0(s1)
    80004efe:	c529                	beqz	a0,80004f48 <sys_exec+0xf8>
    kfree(argv[i]);
    80004f00:	ffffb097          	auipc	ra,0xffffb
    80004f04:	11c080e7          	jalr	284(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f08:	04a1                	addi	s1,s1,8
    80004f0a:	ff2499e3          	bne	s1,s2,80004efc <sys_exec+0xac>
  return -1;
    80004f0e:	597d                	li	s2,-1
    80004f10:	a82d                	j	80004f4a <sys_exec+0xfa>
      argv[i] = 0;
    80004f12:	0a8e                	slli	s5,s5,0x3
    80004f14:	fc040793          	addi	a5,s0,-64
    80004f18:	9abe                	add	s5,s5,a5
    80004f1a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f1e:	e4040593          	addi	a1,s0,-448
    80004f22:	f4040513          	addi	a0,s0,-192
    80004f26:	fffff097          	auipc	ra,0xfffff
    80004f2a:	194080e7          	jalr	404(ra) # 800040ba <exec>
    80004f2e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f30:	10048993          	addi	s3,s1,256
    80004f34:	6088                	ld	a0,0(s1)
    80004f36:	c911                	beqz	a0,80004f4a <sys_exec+0xfa>
    kfree(argv[i]);
    80004f38:	ffffb097          	auipc	ra,0xffffb
    80004f3c:	0e4080e7          	jalr	228(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f40:	04a1                	addi	s1,s1,8
    80004f42:	ff3499e3          	bne	s1,s3,80004f34 <sys_exec+0xe4>
    80004f46:	a011                	j	80004f4a <sys_exec+0xfa>
  return -1;
    80004f48:	597d                	li	s2,-1
}
    80004f4a:	854a                	mv	a0,s2
    80004f4c:	60be                	ld	ra,456(sp)
    80004f4e:	641e                	ld	s0,448(sp)
    80004f50:	74fa                	ld	s1,440(sp)
    80004f52:	795a                	ld	s2,432(sp)
    80004f54:	79ba                	ld	s3,424(sp)
    80004f56:	7a1a                	ld	s4,416(sp)
    80004f58:	6afa                	ld	s5,408(sp)
    80004f5a:	6179                	addi	sp,sp,464
    80004f5c:	8082                	ret

0000000080004f5e <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f5e:	7139                	addi	sp,sp,-64
    80004f60:	fc06                	sd	ra,56(sp)
    80004f62:	f822                	sd	s0,48(sp)
    80004f64:	f426                	sd	s1,40(sp)
    80004f66:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f68:	ffffc097          	auipc	ra,0xffffc
    80004f6c:	f2a080e7          	jalr	-214(ra) # 80000e92 <myproc>
    80004f70:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f72:	fd840593          	addi	a1,s0,-40
    80004f76:	4501                	li	a0,0
    80004f78:	ffffd097          	auipc	ra,0xffffd
    80004f7c:	01e080e7          	jalr	30(ra) # 80001f96 <argaddr>
    return -1;
    80004f80:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f82:	0e054063          	bltz	a0,80005062 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f86:	fc840593          	addi	a1,s0,-56
    80004f8a:	fd040513          	addi	a0,s0,-48
    80004f8e:	fffff097          	auipc	ra,0xfffff
    80004f92:	dfc080e7          	jalr	-516(ra) # 80003d8a <pipealloc>
    return -1;
    80004f96:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f98:	0c054563          	bltz	a0,80005062 <sys_pipe+0x104>
  fd0 = -1;
    80004f9c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fa0:	fd043503          	ld	a0,-48(s0)
    80004fa4:	fffff097          	auipc	ra,0xfffff
    80004fa8:	508080e7          	jalr	1288(ra) # 800044ac <fdalloc>
    80004fac:	fca42223          	sw	a0,-60(s0)
    80004fb0:	08054c63          	bltz	a0,80005048 <sys_pipe+0xea>
    80004fb4:	fc843503          	ld	a0,-56(s0)
    80004fb8:	fffff097          	auipc	ra,0xfffff
    80004fbc:	4f4080e7          	jalr	1268(ra) # 800044ac <fdalloc>
    80004fc0:	fca42023          	sw	a0,-64(s0)
    80004fc4:	06054863          	bltz	a0,80005034 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fc8:	4691                	li	a3,4
    80004fca:	fc440613          	addi	a2,s0,-60
    80004fce:	fd843583          	ld	a1,-40(s0)
    80004fd2:	68a8                	ld	a0,80(s1)
    80004fd4:	ffffc097          	auipc	ra,0xffffc
    80004fd8:	b80080e7          	jalr	-1152(ra) # 80000b54 <copyout>
    80004fdc:	02054063          	bltz	a0,80004ffc <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fe0:	4691                	li	a3,4
    80004fe2:	fc040613          	addi	a2,s0,-64
    80004fe6:	fd843583          	ld	a1,-40(s0)
    80004fea:	0591                	addi	a1,a1,4
    80004fec:	68a8                	ld	a0,80(s1)
    80004fee:	ffffc097          	auipc	ra,0xffffc
    80004ff2:	b66080e7          	jalr	-1178(ra) # 80000b54 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004ff6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004ff8:	06055563          	bgez	a0,80005062 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004ffc:	fc442783          	lw	a5,-60(s0)
    80005000:	07e9                	addi	a5,a5,26
    80005002:	078e                	slli	a5,a5,0x3
    80005004:	97a6                	add	a5,a5,s1
    80005006:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    8000500a:	fc042503          	lw	a0,-64(s0)
    8000500e:	0569                	addi	a0,a0,26
    80005010:	050e                	slli	a0,a0,0x3
    80005012:	9526                	add	a0,a0,s1
    80005014:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005018:	fd043503          	ld	a0,-48(s0)
    8000501c:	fffff097          	auipc	ra,0xfffff
    80005020:	a3e080e7          	jalr	-1474(ra) # 80003a5a <fileclose>
    fileclose(wf);
    80005024:	fc843503          	ld	a0,-56(s0)
    80005028:	fffff097          	auipc	ra,0xfffff
    8000502c:	a32080e7          	jalr	-1486(ra) # 80003a5a <fileclose>
    return -1;
    80005030:	57fd                	li	a5,-1
    80005032:	a805                	j	80005062 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005034:	fc442783          	lw	a5,-60(s0)
    80005038:	0007c863          	bltz	a5,80005048 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000503c:	01a78513          	addi	a0,a5,26
    80005040:	050e                	slli	a0,a0,0x3
    80005042:	9526                	add	a0,a0,s1
    80005044:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005048:	fd043503          	ld	a0,-48(s0)
    8000504c:	fffff097          	auipc	ra,0xfffff
    80005050:	a0e080e7          	jalr	-1522(ra) # 80003a5a <fileclose>
    fileclose(wf);
    80005054:	fc843503          	ld	a0,-56(s0)
    80005058:	fffff097          	auipc	ra,0xfffff
    8000505c:	a02080e7          	jalr	-1534(ra) # 80003a5a <fileclose>
    return -1;
    80005060:	57fd                	li	a5,-1
}
    80005062:	853e                	mv	a0,a5
    80005064:	70e2                	ld	ra,56(sp)
    80005066:	7442                	ld	s0,48(sp)
    80005068:	74a2                	ld	s1,40(sp)
    8000506a:	6121                	addi	sp,sp,64
    8000506c:	8082                	ret
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
    800050b0:	cf7fc0ef          	jal	ra,80001da6 <kerneltrap>
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
}
    8000513a:	6422                	ld	s0,8(sp)
    8000513c:	0141                	addi	sp,sp,16
    8000513e:	8082                	ret

0000000080005140 <plicinithart>:

void
plicinithart(void)
{
    80005140:	1141                	addi	sp,sp,-16
    80005142:	e406                	sd	ra,8(sp)
    80005144:	e022                	sd	s0,0(sp)
    80005146:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005148:	ffffc097          	auipc	ra,0xffffc
    8000514c:	d1e080e7          	jalr	-738(ra) # 80000e66 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005150:	0085171b          	slliw	a4,a0,0x8
    80005154:	0c0027b7          	lui	a5,0xc002
    80005158:	97ba                	add	a5,a5,a4
    8000515a:	40200713          	li	a4,1026
    8000515e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005162:	00d5151b          	slliw	a0,a0,0xd
    80005166:	0c2017b7          	lui	a5,0xc201
    8000516a:	953e                	add	a0,a0,a5
    8000516c:	00052023          	sw	zero,0(a0)
}
    80005170:	60a2                	ld	ra,8(sp)
    80005172:	6402                	ld	s0,0(sp)
    80005174:	0141                	addi	sp,sp,16
    80005176:	8082                	ret

0000000080005178 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005178:	1141                	addi	sp,sp,-16
    8000517a:	e406                	sd	ra,8(sp)
    8000517c:	e022                	sd	s0,0(sp)
    8000517e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005180:	ffffc097          	auipc	ra,0xffffc
    80005184:	ce6080e7          	jalr	-794(ra) # 80000e66 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005188:	00d5179b          	slliw	a5,a0,0xd
    8000518c:	0c201537          	lui	a0,0xc201
    80005190:	953e                	add	a0,a0,a5
  return irq;
}
    80005192:	4148                	lw	a0,4(a0)
    80005194:	60a2                	ld	ra,8(sp)
    80005196:	6402                	ld	s0,0(sp)
    80005198:	0141                	addi	sp,sp,16
    8000519a:	8082                	ret

000000008000519c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000519c:	1101                	addi	sp,sp,-32
    8000519e:	ec06                	sd	ra,24(sp)
    800051a0:	e822                	sd	s0,16(sp)
    800051a2:	e426                	sd	s1,8(sp)
    800051a4:	1000                	addi	s0,sp,32
    800051a6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051a8:	ffffc097          	auipc	ra,0xffffc
    800051ac:	cbe080e7          	jalr	-834(ra) # 80000e66 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051b0:	00d5151b          	slliw	a0,a0,0xd
    800051b4:	0c2017b7          	lui	a5,0xc201
    800051b8:	97aa                	add	a5,a5,a0
    800051ba:	c3c4                	sw	s1,4(a5)
}
    800051bc:	60e2                	ld	ra,24(sp)
    800051be:	6442                	ld	s0,16(sp)
    800051c0:	64a2                	ld	s1,8(sp)
    800051c2:	6105                	addi	sp,sp,32
    800051c4:	8082                	ret

00000000800051c6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051c6:	1141                	addi	sp,sp,-16
    800051c8:	e406                	sd	ra,8(sp)
    800051ca:	e022                	sd	s0,0(sp)
    800051cc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051ce:	479d                	li	a5,7
    800051d0:	06a7c963          	blt	a5,a0,80005242 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800051d4:	00016797          	auipc	a5,0x16
    800051d8:	e2c78793          	addi	a5,a5,-468 # 8001b000 <disk>
    800051dc:	00a78733          	add	a4,a5,a0
    800051e0:	6789                	lui	a5,0x2
    800051e2:	97ba                	add	a5,a5,a4
    800051e4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800051e8:	e7ad                	bnez	a5,80005252 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051ea:	00451793          	slli	a5,a0,0x4
    800051ee:	00018717          	auipc	a4,0x18
    800051f2:	e1270713          	addi	a4,a4,-494 # 8001d000 <disk+0x2000>
    800051f6:	6314                	ld	a3,0(a4)
    800051f8:	96be                	add	a3,a3,a5
    800051fa:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051fe:	6314                	ld	a3,0(a4)
    80005200:	96be                	add	a3,a3,a5
    80005202:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005206:	6314                	ld	a3,0(a4)
    80005208:	96be                	add	a3,a3,a5
    8000520a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000520e:	6318                	ld	a4,0(a4)
    80005210:	97ba                	add	a5,a5,a4
    80005212:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005216:	00016797          	auipc	a5,0x16
    8000521a:	dea78793          	addi	a5,a5,-534 # 8001b000 <disk>
    8000521e:	97aa                	add	a5,a5,a0
    80005220:	6509                	lui	a0,0x2
    80005222:	953e                	add	a0,a0,a5
    80005224:	4785                	li	a5,1
    80005226:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000522a:	00018517          	auipc	a0,0x18
    8000522e:	dee50513          	addi	a0,a0,-530 # 8001d018 <disk+0x2018>
    80005232:	ffffc097          	auipc	ra,0xffffc
    80005236:	4b0080e7          	jalr	1200(ra) # 800016e2 <wakeup>
}
    8000523a:	60a2                	ld	ra,8(sp)
    8000523c:	6402                	ld	s0,0(sp)
    8000523e:	0141                	addi	sp,sp,16
    80005240:	8082                	ret
    panic("free_desc 1");
    80005242:	00003517          	auipc	a0,0x3
    80005246:	63650513          	addi	a0,a0,1590 # 80008878 <syscall_name+0x328>
    8000524a:	00001097          	auipc	ra,0x1
    8000524e:	a1e080e7          	jalr	-1506(ra) # 80005c68 <panic>
    panic("free_desc 2");
    80005252:	00003517          	auipc	a0,0x3
    80005256:	63650513          	addi	a0,a0,1590 # 80008888 <syscall_name+0x338>
    8000525a:	00001097          	auipc	ra,0x1
    8000525e:	a0e080e7          	jalr	-1522(ra) # 80005c68 <panic>

0000000080005262 <virtio_disk_init>:
{
    80005262:	1101                	addi	sp,sp,-32
    80005264:	ec06                	sd	ra,24(sp)
    80005266:	e822                	sd	s0,16(sp)
    80005268:	e426                	sd	s1,8(sp)
    8000526a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000526c:	00003597          	auipc	a1,0x3
    80005270:	62c58593          	addi	a1,a1,1580 # 80008898 <syscall_name+0x348>
    80005274:	00018517          	auipc	a0,0x18
    80005278:	eb450513          	addi	a0,a0,-332 # 8001d128 <disk+0x2128>
    8000527c:	00001097          	auipc	ra,0x1
    80005280:	ea6080e7          	jalr	-346(ra) # 80006122 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005284:	100017b7          	lui	a5,0x10001
    80005288:	4398                	lw	a4,0(a5)
    8000528a:	2701                	sext.w	a4,a4
    8000528c:	747277b7          	lui	a5,0x74727
    80005290:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005294:	0ef71163          	bne	a4,a5,80005376 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005298:	100017b7          	lui	a5,0x10001
    8000529c:	43dc                	lw	a5,4(a5)
    8000529e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052a0:	4705                	li	a4,1
    800052a2:	0ce79a63          	bne	a5,a4,80005376 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052a6:	100017b7          	lui	a5,0x10001
    800052aa:	479c                	lw	a5,8(a5)
    800052ac:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052ae:	4709                	li	a4,2
    800052b0:	0ce79363          	bne	a5,a4,80005376 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052b4:	100017b7          	lui	a5,0x10001
    800052b8:	47d8                	lw	a4,12(a5)
    800052ba:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052bc:	554d47b7          	lui	a5,0x554d4
    800052c0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052c4:	0af71963          	bne	a4,a5,80005376 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052c8:	100017b7          	lui	a5,0x10001
    800052cc:	4705                	li	a4,1
    800052ce:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d0:	470d                	li	a4,3
    800052d2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052d4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052d6:	c7ffe737          	lui	a4,0xc7ffe
    800052da:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800052de:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052e0:	2701                	sext.w	a4,a4
    800052e2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052e4:	472d                	li	a4,11
    800052e6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052e8:	473d                	li	a4,15
    800052ea:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800052ec:	6705                	lui	a4,0x1
    800052ee:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052f0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052f4:	5bdc                	lw	a5,52(a5)
    800052f6:	2781                	sext.w	a5,a5
  if(max == 0)
    800052f8:	c7d9                	beqz	a5,80005386 <virtio_disk_init+0x124>
  if(max < NUM)
    800052fa:	471d                	li	a4,7
    800052fc:	08f77d63          	bgeu	a4,a5,80005396 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005300:	100014b7          	lui	s1,0x10001
    80005304:	47a1                	li	a5,8
    80005306:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005308:	6609                	lui	a2,0x2
    8000530a:	4581                	li	a1,0
    8000530c:	00016517          	auipc	a0,0x16
    80005310:	cf450513          	addi	a0,a0,-780 # 8001b000 <disk>
    80005314:	ffffb097          	auipc	ra,0xffffb
    80005318:	eae080e7          	jalr	-338(ra) # 800001c2 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000531c:	00016717          	auipc	a4,0x16
    80005320:	ce470713          	addi	a4,a4,-796 # 8001b000 <disk>
    80005324:	00c75793          	srli	a5,a4,0xc
    80005328:	2781                	sext.w	a5,a5
    8000532a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000532c:	00018797          	auipc	a5,0x18
    80005330:	cd478793          	addi	a5,a5,-812 # 8001d000 <disk+0x2000>
    80005334:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005336:	00016717          	auipc	a4,0x16
    8000533a:	d4a70713          	addi	a4,a4,-694 # 8001b080 <disk+0x80>
    8000533e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005340:	00017717          	auipc	a4,0x17
    80005344:	cc070713          	addi	a4,a4,-832 # 8001c000 <disk+0x1000>
    80005348:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000534a:	4705                	li	a4,1
    8000534c:	00e78c23          	sb	a4,24(a5)
    80005350:	00e78ca3          	sb	a4,25(a5)
    80005354:	00e78d23          	sb	a4,26(a5)
    80005358:	00e78da3          	sb	a4,27(a5)
    8000535c:	00e78e23          	sb	a4,28(a5)
    80005360:	00e78ea3          	sb	a4,29(a5)
    80005364:	00e78f23          	sb	a4,30(a5)
    80005368:	00e78fa3          	sb	a4,31(a5)
}
    8000536c:	60e2                	ld	ra,24(sp)
    8000536e:	6442                	ld	s0,16(sp)
    80005370:	64a2                	ld	s1,8(sp)
    80005372:	6105                	addi	sp,sp,32
    80005374:	8082                	ret
    panic("could not find virtio disk");
    80005376:	00003517          	auipc	a0,0x3
    8000537a:	53250513          	addi	a0,a0,1330 # 800088a8 <syscall_name+0x358>
    8000537e:	00001097          	auipc	ra,0x1
    80005382:	8ea080e7          	jalr	-1814(ra) # 80005c68 <panic>
    panic("virtio disk has no queue 0");
    80005386:	00003517          	auipc	a0,0x3
    8000538a:	54250513          	addi	a0,a0,1346 # 800088c8 <syscall_name+0x378>
    8000538e:	00001097          	auipc	ra,0x1
    80005392:	8da080e7          	jalr	-1830(ra) # 80005c68 <panic>
    panic("virtio disk max queue too short");
    80005396:	00003517          	auipc	a0,0x3
    8000539a:	55250513          	addi	a0,a0,1362 # 800088e8 <syscall_name+0x398>
    8000539e:	00001097          	auipc	ra,0x1
    800053a2:	8ca080e7          	jalr	-1846(ra) # 80005c68 <panic>

00000000800053a6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053a6:	7159                	addi	sp,sp,-112
    800053a8:	f486                	sd	ra,104(sp)
    800053aa:	f0a2                	sd	s0,96(sp)
    800053ac:	eca6                	sd	s1,88(sp)
    800053ae:	e8ca                	sd	s2,80(sp)
    800053b0:	e4ce                	sd	s3,72(sp)
    800053b2:	e0d2                	sd	s4,64(sp)
    800053b4:	fc56                	sd	s5,56(sp)
    800053b6:	f85a                	sd	s6,48(sp)
    800053b8:	f45e                	sd	s7,40(sp)
    800053ba:	f062                	sd	s8,32(sp)
    800053bc:	ec66                	sd	s9,24(sp)
    800053be:	e86a                	sd	s10,16(sp)
    800053c0:	1880                	addi	s0,sp,112
    800053c2:	892a                	mv	s2,a0
    800053c4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053c6:	00c52c83          	lw	s9,12(a0)
    800053ca:	001c9c9b          	slliw	s9,s9,0x1
    800053ce:	1c82                	slli	s9,s9,0x20
    800053d0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053d4:	00018517          	auipc	a0,0x18
    800053d8:	d5450513          	addi	a0,a0,-684 # 8001d128 <disk+0x2128>
    800053dc:	00001097          	auipc	ra,0x1
    800053e0:	dd6080e7          	jalr	-554(ra) # 800061b2 <acquire>
  for(int i = 0; i < 3; i++){
    800053e4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053e6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800053e8:	00016b97          	auipc	s7,0x16
    800053ec:	c18b8b93          	addi	s7,s7,-1000 # 8001b000 <disk>
    800053f0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800053f2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800053f4:	8a4e                	mv	s4,s3
    800053f6:	a051                	j	8000547a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800053f8:	00fb86b3          	add	a3,s7,a5
    800053fc:	96da                	add	a3,a3,s6
    800053fe:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005402:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005404:	0207c563          	bltz	a5,8000542e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005408:	2485                	addiw	s1,s1,1
    8000540a:	0711                	addi	a4,a4,4
    8000540c:	25548063          	beq	s1,s5,8000564c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005410:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005412:	00018697          	auipc	a3,0x18
    80005416:	c0668693          	addi	a3,a3,-1018 # 8001d018 <disk+0x2018>
    8000541a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000541c:	0006c583          	lbu	a1,0(a3)
    80005420:	fde1                	bnez	a1,800053f8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005422:	2785                	addiw	a5,a5,1
    80005424:	0685                	addi	a3,a3,1
    80005426:	ff879be3          	bne	a5,s8,8000541c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000542a:	57fd                	li	a5,-1
    8000542c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000542e:	02905a63          	blez	s1,80005462 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005432:	f9042503          	lw	a0,-112(s0)
    80005436:	00000097          	auipc	ra,0x0
    8000543a:	d90080e7          	jalr	-624(ra) # 800051c6 <free_desc>
      for(int j = 0; j < i; j++)
    8000543e:	4785                	li	a5,1
    80005440:	0297d163          	bge	a5,s1,80005462 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005444:	f9442503          	lw	a0,-108(s0)
    80005448:	00000097          	auipc	ra,0x0
    8000544c:	d7e080e7          	jalr	-642(ra) # 800051c6 <free_desc>
      for(int j = 0; j < i; j++)
    80005450:	4789                	li	a5,2
    80005452:	0097d863          	bge	a5,s1,80005462 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005456:	f9842503          	lw	a0,-104(s0)
    8000545a:	00000097          	auipc	ra,0x0
    8000545e:	d6c080e7          	jalr	-660(ra) # 800051c6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005462:	00018597          	auipc	a1,0x18
    80005466:	cc658593          	addi	a1,a1,-826 # 8001d128 <disk+0x2128>
    8000546a:	00018517          	auipc	a0,0x18
    8000546e:	bae50513          	addi	a0,a0,-1106 # 8001d018 <disk+0x2018>
    80005472:	ffffc097          	auipc	ra,0xffffc
    80005476:	0e4080e7          	jalr	228(ra) # 80001556 <sleep>
  for(int i = 0; i < 3; i++){
    8000547a:	f9040713          	addi	a4,s0,-112
    8000547e:	84ce                	mv	s1,s3
    80005480:	bf41                	j	80005410 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005482:	20058713          	addi	a4,a1,512
    80005486:	00471693          	slli	a3,a4,0x4
    8000548a:	00016717          	auipc	a4,0x16
    8000548e:	b7670713          	addi	a4,a4,-1162 # 8001b000 <disk>
    80005492:	9736                	add	a4,a4,a3
    80005494:	4685                	li	a3,1
    80005496:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000549a:	20058713          	addi	a4,a1,512
    8000549e:	00471693          	slli	a3,a4,0x4
    800054a2:	00016717          	auipc	a4,0x16
    800054a6:	b5e70713          	addi	a4,a4,-1186 # 8001b000 <disk>
    800054aa:	9736                	add	a4,a4,a3
    800054ac:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800054b0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054b4:	7679                	lui	a2,0xffffe
    800054b6:	963e                	add	a2,a2,a5
    800054b8:	00018697          	auipc	a3,0x18
    800054bc:	b4868693          	addi	a3,a3,-1208 # 8001d000 <disk+0x2000>
    800054c0:	6298                	ld	a4,0(a3)
    800054c2:	9732                	add	a4,a4,a2
    800054c4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054c6:	6298                	ld	a4,0(a3)
    800054c8:	9732                	add	a4,a4,a2
    800054ca:	4541                	li	a0,16
    800054cc:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054ce:	6298                	ld	a4,0(a3)
    800054d0:	9732                	add	a4,a4,a2
    800054d2:	4505                	li	a0,1
    800054d4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800054d8:	f9442703          	lw	a4,-108(s0)
    800054dc:	6288                	ld	a0,0(a3)
    800054de:	962a                	add	a2,a2,a0
    800054e0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054e4:	0712                	slli	a4,a4,0x4
    800054e6:	6290                	ld	a2,0(a3)
    800054e8:	963a                	add	a2,a2,a4
    800054ea:	05890513          	addi	a0,s2,88
    800054ee:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800054f0:	6294                	ld	a3,0(a3)
    800054f2:	96ba                	add	a3,a3,a4
    800054f4:	40000613          	li	a2,1024
    800054f8:	c690                	sw	a2,8(a3)
  if(write)
    800054fa:	140d0063          	beqz	s10,8000563a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800054fe:	00018697          	auipc	a3,0x18
    80005502:	b026b683          	ld	a3,-1278(a3) # 8001d000 <disk+0x2000>
    80005506:	96ba                	add	a3,a3,a4
    80005508:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000550c:	00016817          	auipc	a6,0x16
    80005510:	af480813          	addi	a6,a6,-1292 # 8001b000 <disk>
    80005514:	00018517          	auipc	a0,0x18
    80005518:	aec50513          	addi	a0,a0,-1300 # 8001d000 <disk+0x2000>
    8000551c:	6114                	ld	a3,0(a0)
    8000551e:	96ba                	add	a3,a3,a4
    80005520:	00c6d603          	lhu	a2,12(a3)
    80005524:	00166613          	ori	a2,a2,1
    80005528:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000552c:	f9842683          	lw	a3,-104(s0)
    80005530:	6110                	ld	a2,0(a0)
    80005532:	9732                	add	a4,a4,a2
    80005534:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005538:	20058613          	addi	a2,a1,512
    8000553c:	0612                	slli	a2,a2,0x4
    8000553e:	9642                	add	a2,a2,a6
    80005540:	577d                	li	a4,-1
    80005542:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005546:	00469713          	slli	a4,a3,0x4
    8000554a:	6114                	ld	a3,0(a0)
    8000554c:	96ba                	add	a3,a3,a4
    8000554e:	03078793          	addi	a5,a5,48
    80005552:	97c2                	add	a5,a5,a6
    80005554:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005556:	611c                	ld	a5,0(a0)
    80005558:	97ba                	add	a5,a5,a4
    8000555a:	4685                	li	a3,1
    8000555c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000555e:	611c                	ld	a5,0(a0)
    80005560:	97ba                	add	a5,a5,a4
    80005562:	4809                	li	a6,2
    80005564:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005568:	611c                	ld	a5,0(a0)
    8000556a:	973e                	add	a4,a4,a5
    8000556c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005570:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005574:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005578:	6518                	ld	a4,8(a0)
    8000557a:	00275783          	lhu	a5,2(a4)
    8000557e:	8b9d                	andi	a5,a5,7
    80005580:	0786                	slli	a5,a5,0x1
    80005582:	97ba                	add	a5,a5,a4
    80005584:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005588:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000558c:	6518                	ld	a4,8(a0)
    8000558e:	00275783          	lhu	a5,2(a4)
    80005592:	2785                	addiw	a5,a5,1
    80005594:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005598:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000559c:	100017b7          	lui	a5,0x10001
    800055a0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055a4:	00492703          	lw	a4,4(s2)
    800055a8:	4785                	li	a5,1
    800055aa:	02f71163          	bne	a4,a5,800055cc <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800055ae:	00018997          	auipc	s3,0x18
    800055b2:	b7a98993          	addi	s3,s3,-1158 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800055b6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800055b8:	85ce                	mv	a1,s3
    800055ba:	854a                	mv	a0,s2
    800055bc:	ffffc097          	auipc	ra,0xffffc
    800055c0:	f9a080e7          	jalr	-102(ra) # 80001556 <sleep>
  while(b->disk == 1) {
    800055c4:	00492783          	lw	a5,4(s2)
    800055c8:	fe9788e3          	beq	a5,s1,800055b8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800055cc:	f9042903          	lw	s2,-112(s0)
    800055d0:	20090793          	addi	a5,s2,512
    800055d4:	00479713          	slli	a4,a5,0x4
    800055d8:	00016797          	auipc	a5,0x16
    800055dc:	a2878793          	addi	a5,a5,-1496 # 8001b000 <disk>
    800055e0:	97ba                	add	a5,a5,a4
    800055e2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800055e6:	00018997          	auipc	s3,0x18
    800055ea:	a1a98993          	addi	s3,s3,-1510 # 8001d000 <disk+0x2000>
    800055ee:	00491713          	slli	a4,s2,0x4
    800055f2:	0009b783          	ld	a5,0(s3)
    800055f6:	97ba                	add	a5,a5,a4
    800055f8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055fc:	854a                	mv	a0,s2
    800055fe:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005602:	00000097          	auipc	ra,0x0
    80005606:	bc4080e7          	jalr	-1084(ra) # 800051c6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000560a:	8885                	andi	s1,s1,1
    8000560c:	f0ed                	bnez	s1,800055ee <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000560e:	00018517          	auipc	a0,0x18
    80005612:	b1a50513          	addi	a0,a0,-1254 # 8001d128 <disk+0x2128>
    80005616:	00001097          	auipc	ra,0x1
    8000561a:	c50080e7          	jalr	-944(ra) # 80006266 <release>
}
    8000561e:	70a6                	ld	ra,104(sp)
    80005620:	7406                	ld	s0,96(sp)
    80005622:	64e6                	ld	s1,88(sp)
    80005624:	6946                	ld	s2,80(sp)
    80005626:	69a6                	ld	s3,72(sp)
    80005628:	6a06                	ld	s4,64(sp)
    8000562a:	7ae2                	ld	s5,56(sp)
    8000562c:	7b42                	ld	s6,48(sp)
    8000562e:	7ba2                	ld	s7,40(sp)
    80005630:	7c02                	ld	s8,32(sp)
    80005632:	6ce2                	ld	s9,24(sp)
    80005634:	6d42                	ld	s10,16(sp)
    80005636:	6165                	addi	sp,sp,112
    80005638:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000563a:	00018697          	auipc	a3,0x18
    8000563e:	9c66b683          	ld	a3,-1594(a3) # 8001d000 <disk+0x2000>
    80005642:	96ba                	add	a3,a3,a4
    80005644:	4609                	li	a2,2
    80005646:	00c69623          	sh	a2,12(a3)
    8000564a:	b5c9                	j	8000550c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000564c:	f9042583          	lw	a1,-112(s0)
    80005650:	20058793          	addi	a5,a1,512
    80005654:	0792                	slli	a5,a5,0x4
    80005656:	00016517          	auipc	a0,0x16
    8000565a:	a5250513          	addi	a0,a0,-1454 # 8001b0a8 <disk+0xa8>
    8000565e:	953e                	add	a0,a0,a5
  if(write)
    80005660:	e20d11e3          	bnez	s10,80005482 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005664:	20058713          	addi	a4,a1,512
    80005668:	00471693          	slli	a3,a4,0x4
    8000566c:	00016717          	auipc	a4,0x16
    80005670:	99470713          	addi	a4,a4,-1644 # 8001b000 <disk>
    80005674:	9736                	add	a4,a4,a3
    80005676:	0a072423          	sw	zero,168(a4)
    8000567a:	b505                	j	8000549a <virtio_disk_rw+0xf4>

000000008000567c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000567c:	1101                	addi	sp,sp,-32
    8000567e:	ec06                	sd	ra,24(sp)
    80005680:	e822                	sd	s0,16(sp)
    80005682:	e426                	sd	s1,8(sp)
    80005684:	e04a                	sd	s2,0(sp)
    80005686:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005688:	00018517          	auipc	a0,0x18
    8000568c:	aa050513          	addi	a0,a0,-1376 # 8001d128 <disk+0x2128>
    80005690:	00001097          	auipc	ra,0x1
    80005694:	b22080e7          	jalr	-1246(ra) # 800061b2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005698:	10001737          	lui	a4,0x10001
    8000569c:	533c                	lw	a5,96(a4)
    8000569e:	8b8d                	andi	a5,a5,3
    800056a0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056a2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056a6:	00018797          	auipc	a5,0x18
    800056aa:	95a78793          	addi	a5,a5,-1702 # 8001d000 <disk+0x2000>
    800056ae:	6b94                	ld	a3,16(a5)
    800056b0:	0207d703          	lhu	a4,32(a5)
    800056b4:	0026d783          	lhu	a5,2(a3)
    800056b8:	06f70163          	beq	a4,a5,8000571a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056bc:	00016917          	auipc	s2,0x16
    800056c0:	94490913          	addi	s2,s2,-1724 # 8001b000 <disk>
    800056c4:	00018497          	auipc	s1,0x18
    800056c8:	93c48493          	addi	s1,s1,-1732 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800056cc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056d0:	6898                	ld	a4,16(s1)
    800056d2:	0204d783          	lhu	a5,32(s1)
    800056d6:	8b9d                	andi	a5,a5,7
    800056d8:	078e                	slli	a5,a5,0x3
    800056da:	97ba                	add	a5,a5,a4
    800056dc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056de:	20078713          	addi	a4,a5,512
    800056e2:	0712                	slli	a4,a4,0x4
    800056e4:	974a                	add	a4,a4,s2
    800056e6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056ea:	e731                	bnez	a4,80005736 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056ec:	20078793          	addi	a5,a5,512
    800056f0:	0792                	slli	a5,a5,0x4
    800056f2:	97ca                	add	a5,a5,s2
    800056f4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056f6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056fa:	ffffc097          	auipc	ra,0xffffc
    800056fe:	fe8080e7          	jalr	-24(ra) # 800016e2 <wakeup>

    disk.used_idx += 1;
    80005702:	0204d783          	lhu	a5,32(s1)
    80005706:	2785                	addiw	a5,a5,1
    80005708:	17c2                	slli	a5,a5,0x30
    8000570a:	93c1                	srli	a5,a5,0x30
    8000570c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005710:	6898                	ld	a4,16(s1)
    80005712:	00275703          	lhu	a4,2(a4)
    80005716:	faf71be3          	bne	a4,a5,800056cc <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000571a:	00018517          	auipc	a0,0x18
    8000571e:	a0e50513          	addi	a0,a0,-1522 # 8001d128 <disk+0x2128>
    80005722:	00001097          	auipc	ra,0x1
    80005726:	b44080e7          	jalr	-1212(ra) # 80006266 <release>
}
    8000572a:	60e2                	ld	ra,24(sp)
    8000572c:	6442                	ld	s0,16(sp)
    8000572e:	64a2                	ld	s1,8(sp)
    80005730:	6902                	ld	s2,0(sp)
    80005732:	6105                	addi	sp,sp,32
    80005734:	8082                	ret
      panic("virtio_disk_intr status");
    80005736:	00003517          	auipc	a0,0x3
    8000573a:	1d250513          	addi	a0,a0,466 # 80008908 <syscall_name+0x3b8>
    8000573e:	00000097          	auipc	ra,0x0
    80005742:	52a080e7          	jalr	1322(ra) # 80005c68 <panic>

0000000080005746 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005746:	1141                	addi	sp,sp,-16
    80005748:	e422                	sd	s0,8(sp)
    8000574a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000574c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005750:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005754:	0037979b          	slliw	a5,a5,0x3
    80005758:	02004737          	lui	a4,0x2004
    8000575c:	97ba                	add	a5,a5,a4
    8000575e:	0200c737          	lui	a4,0x200c
    80005762:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005766:	000f4637          	lui	a2,0xf4
    8000576a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000576e:	95b2                	add	a1,a1,a2
    80005770:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005772:	00269713          	slli	a4,a3,0x2
    80005776:	9736                	add	a4,a4,a3
    80005778:	00371693          	slli	a3,a4,0x3
    8000577c:	00019717          	auipc	a4,0x19
    80005780:	88470713          	addi	a4,a4,-1916 # 8001e000 <timer_scratch>
    80005784:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005786:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005788:	f310                	sd	a2,32(a4)
  asm volatile("csrw sscratch, %0" : : "r" (x));
    8000578a:	34071073          	csrw	mscratch,a4
  return x;
    8000578e:	00000797          	auipc	a5,0x0
    80005792:	97278793          	addi	a5,a5,-1678 # 80005100 <timervec>
    80005796:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000579a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000579e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057a6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057aa:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057ae:	30479073          	csrw	mie,a5
}
    800057b2:	6422                	ld	s0,8(sp)
    800057b4:	0141                	addi	sp,sp,16
    800057b6:	8082                	ret

00000000800057b8 <start>:
{
    800057b8:	1141                	addi	sp,sp,-16
    800057ba:	e406                	sd	ra,8(sp)
    800057bc:	e022                	sd	s0,0(sp)
    800057be:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057c0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057c4:	7779                	lui	a4,0xffffe
    800057c6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800057ca:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057cc:	6705                	lui	a4,0x1
    800057ce:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057d2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057d4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057d8:	ffffb797          	auipc	a5,0xffffb
    800057dc:	b9878793          	addi	a5,a5,-1128 # 80000370 <main>
    800057e0:	34179073          	csrw	mepc,a5

    800057e4:	4781                	li	a5,0
    800057e6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057ea:	67c1                	lui	a5,0x10
    800057ec:	17fd                	addi	a5,a5,-1
    800057ee:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057f2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057f6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057fa:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057fe:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005802:	57fd                	li	a5,-1
    80005804:	83a9                	srli	a5,a5,0xa
    80005806:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000580a:	47bd                	li	a5,15
    8000580c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005810:	00000097          	auipc	ra,0x0
    80005814:	f36080e7          	jalr	-202(ra) # 80005746 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005818:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000581c:	2781                	sext.w	a5,a5
  return x;
    8000581e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005820:	30200073          	mret
}
    80005824:	60a2                	ld	ra,8(sp)
    80005826:	6402                	ld	s0,0(sp)
    80005828:	0141                	addi	sp,sp,16
    8000582a:	8082                	ret

000000008000582c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000582c:	715d                	addi	sp,sp,-80
    8000582e:	e486                	sd	ra,72(sp)
    80005830:	e0a2                	sd	s0,64(sp)
    80005832:	fc26                	sd	s1,56(sp)
    80005834:	f84a                	sd	s2,48(sp)
    80005836:	f44e                	sd	s3,40(sp)
    80005838:	f052                	sd	s4,32(sp)
    8000583a:	ec56                	sd	s5,24(sp)
    8000583c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000583e:	04c05663          	blez	a2,8000588a <consolewrite+0x5e>
    80005842:	8a2a                	mv	s4,a0
    80005844:	84ae                	mv	s1,a1
    80005846:	89b2                	mv	s3,a2
    80005848:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000584a:	5afd                	li	s5,-1
    8000584c:	4685                	li	a3,1
    8000584e:	8626                	mv	a2,s1
    80005850:	85d2                	mv	a1,s4
    80005852:	fbf40513          	addi	a0,s0,-65
    80005856:	ffffc097          	auipc	ra,0xffffc
    8000585a:	0fa080e7          	jalr	250(ra) # 80001950 <either_copyin>
    8000585e:	01550c63          	beq	a0,s5,80005876 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005862:	fbf44503          	lbu	a0,-65(s0)
    80005866:	00000097          	auipc	ra,0x0
    8000586a:	78e080e7          	jalr	1934(ra) # 80005ff4 <uartputc>
  for(i = 0; i < n; i++){
    8000586e:	2905                	addiw	s2,s2,1
    80005870:	0485                	addi	s1,s1,1
    80005872:	fd299de3          	bne	s3,s2,8000584c <consolewrite+0x20>
  }

  return i;
}
    80005876:	854a                	mv	a0,s2
    80005878:	60a6                	ld	ra,72(sp)
    8000587a:	6406                	ld	s0,64(sp)
    8000587c:	74e2                	ld	s1,56(sp)
    8000587e:	7942                	ld	s2,48(sp)
    80005880:	79a2                	ld	s3,40(sp)
    80005882:	7a02                	ld	s4,32(sp)
    80005884:	6ae2                	ld	s5,24(sp)
    80005886:	6161                	addi	sp,sp,80
    80005888:	8082                	ret
  for(i = 0; i < n; i++){
    8000588a:	4901                	li	s2,0
    8000588c:	b7ed                	j	80005876 <consolewrite+0x4a>

000000008000588e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000588e:	7119                	addi	sp,sp,-128
    80005890:	fc86                	sd	ra,120(sp)
    80005892:	f8a2                	sd	s0,112(sp)
    80005894:	f4a6                	sd	s1,104(sp)
    80005896:	f0ca                	sd	s2,96(sp)
    80005898:	ecce                	sd	s3,88(sp)
    8000589a:	e8d2                	sd	s4,80(sp)
    8000589c:	e4d6                	sd	s5,72(sp)
    8000589e:	e0da                	sd	s6,64(sp)
    800058a0:	fc5e                	sd	s7,56(sp)
    800058a2:	f862                	sd	s8,48(sp)
    800058a4:	f466                	sd	s9,40(sp)
    800058a6:	f06a                	sd	s10,32(sp)
    800058a8:	ec6e                	sd	s11,24(sp)
    800058aa:	0100                	addi	s0,sp,128
    800058ac:	8b2a                	mv	s6,a0
    800058ae:	8aae                	mv	s5,a1
    800058b0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058b2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800058b6:	00021517          	auipc	a0,0x21
    800058ba:	88a50513          	addi	a0,a0,-1910 # 80026140 <cons>
    800058be:	00001097          	auipc	ra,0x1
    800058c2:	8f4080e7          	jalr	-1804(ra) # 800061b2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058c6:	00021497          	auipc	s1,0x21
    800058ca:	87a48493          	addi	s1,s1,-1926 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058ce:	89a6                	mv	s3,s1
    800058d0:	00021917          	auipc	s2,0x21
    800058d4:	90890913          	addi	s2,s2,-1784 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800058d8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058da:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058dc:	4da9                	li	s11,10
  while(n > 0){
    800058de:	07405863          	blez	s4,8000594e <consoleread+0xc0>
    while(cons.r == cons.w){
    800058e2:	0984a783          	lw	a5,152(s1)
    800058e6:	09c4a703          	lw	a4,156(s1)
    800058ea:	02f71463          	bne	a4,a5,80005912 <consoleread+0x84>
      if(myproc()->killed){
    800058ee:	ffffb097          	auipc	ra,0xffffb
    800058f2:	5a4080e7          	jalr	1444(ra) # 80000e92 <myproc>
    800058f6:	551c                	lw	a5,40(a0)
    800058f8:	e7b5                	bnez	a5,80005964 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800058fa:	85ce                	mv	a1,s3
    800058fc:	854a                	mv	a0,s2
    800058fe:	ffffc097          	auipc	ra,0xffffc
    80005902:	c58080e7          	jalr	-936(ra) # 80001556 <sleep>
    while(cons.r == cons.w){
    80005906:	0984a783          	lw	a5,152(s1)
    8000590a:	09c4a703          	lw	a4,156(s1)
    8000590e:	fef700e3          	beq	a4,a5,800058ee <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005912:	0017871b          	addiw	a4,a5,1
    80005916:	08e4ac23          	sw	a4,152(s1)
    8000591a:	07f7f713          	andi	a4,a5,127
    8000591e:	9726                	add	a4,a4,s1
    80005920:	01874703          	lbu	a4,24(a4)
    80005924:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005928:	079c0663          	beq	s8,s9,80005994 <consoleread+0x106>
    cbuf = c;
    8000592c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005930:	4685                	li	a3,1
    80005932:	f8f40613          	addi	a2,s0,-113
    80005936:	85d6                	mv	a1,s5
    80005938:	855a                	mv	a0,s6
    8000593a:	ffffc097          	auipc	ra,0xffffc
    8000593e:	fc0080e7          	jalr	-64(ra) # 800018fa <either_copyout>
    80005942:	01a50663          	beq	a0,s10,8000594e <consoleread+0xc0>
    dst++;
    80005946:	0a85                	addi	s5,s5,1
    --n;
    80005948:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000594a:	f9bc1ae3          	bne	s8,s11,800058de <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000594e:	00020517          	auipc	a0,0x20
    80005952:	7f250513          	addi	a0,a0,2034 # 80026140 <cons>
    80005956:	00001097          	auipc	ra,0x1
    8000595a:	910080e7          	jalr	-1776(ra) # 80006266 <release>

  return target - n;
    8000595e:	414b853b          	subw	a0,s7,s4
    80005962:	a811                	j	80005976 <consoleread+0xe8>
        release(&cons.lock);
    80005964:	00020517          	auipc	a0,0x20
    80005968:	7dc50513          	addi	a0,a0,2012 # 80026140 <cons>
    8000596c:	00001097          	auipc	ra,0x1
    80005970:	8fa080e7          	jalr	-1798(ra) # 80006266 <release>
        return -1;
    80005974:	557d                	li	a0,-1
}
    80005976:	70e6                	ld	ra,120(sp)
    80005978:	7446                	ld	s0,112(sp)
    8000597a:	74a6                	ld	s1,104(sp)
    8000597c:	7906                	ld	s2,96(sp)
    8000597e:	69e6                	ld	s3,88(sp)
    80005980:	6a46                	ld	s4,80(sp)
    80005982:	6aa6                	ld	s5,72(sp)
    80005984:	6b06                	ld	s6,64(sp)
    80005986:	7be2                	ld	s7,56(sp)
    80005988:	7c42                	ld	s8,48(sp)
    8000598a:	7ca2                	ld	s9,40(sp)
    8000598c:	7d02                	ld	s10,32(sp)
    8000598e:	6de2                	ld	s11,24(sp)
    80005990:	6109                	addi	sp,sp,128
    80005992:	8082                	ret
      if(n < target){
    80005994:	000a071b          	sext.w	a4,s4
    80005998:	fb777be3          	bgeu	a4,s7,8000594e <consoleread+0xc0>
        cons.r--;
    8000599c:	00021717          	auipc	a4,0x21
    800059a0:	82f72e23          	sw	a5,-1988(a4) # 800261d8 <cons+0x98>
    800059a4:	b76d                	j	8000594e <consoleread+0xc0>

00000000800059a6 <consputc>:
{
    800059a6:	1141                	addi	sp,sp,-16
    800059a8:	e406                	sd	ra,8(sp)
    800059aa:	e022                	sd	s0,0(sp)
    800059ac:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059ae:	10000793          	li	a5,256
    800059b2:	00f50a63          	beq	a0,a5,800059c6 <consputc+0x20>
    uartputc_sync(c);
    800059b6:	00000097          	auipc	ra,0x0
    800059ba:	564080e7          	jalr	1380(ra) # 80005f1a <uartputc_sync>
}
    800059be:	60a2                	ld	ra,8(sp)
    800059c0:	6402                	ld	s0,0(sp)
    800059c2:	0141                	addi	sp,sp,16
    800059c4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059c6:	4521                	li	a0,8
    800059c8:	00000097          	auipc	ra,0x0
    800059cc:	552080e7          	jalr	1362(ra) # 80005f1a <uartputc_sync>
    800059d0:	02000513          	li	a0,32
    800059d4:	00000097          	auipc	ra,0x0
    800059d8:	546080e7          	jalr	1350(ra) # 80005f1a <uartputc_sync>
    800059dc:	4521                	li	a0,8
    800059de:	00000097          	auipc	ra,0x0
    800059e2:	53c080e7          	jalr	1340(ra) # 80005f1a <uartputc_sync>
    800059e6:	bfe1                	j	800059be <consputc+0x18>

00000000800059e8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059e8:	1101                	addi	sp,sp,-32
    800059ea:	ec06                	sd	ra,24(sp)
    800059ec:	e822                	sd	s0,16(sp)
    800059ee:	e426                	sd	s1,8(sp)
    800059f0:	e04a                	sd	s2,0(sp)
    800059f2:	1000                	addi	s0,sp,32
    800059f4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059f6:	00020517          	auipc	a0,0x20
    800059fa:	74a50513          	addi	a0,a0,1866 # 80026140 <cons>
    800059fe:	00000097          	auipc	ra,0x0
    80005a02:	7b4080e7          	jalr	1972(ra) # 800061b2 <acquire>

  switch(c){
    80005a06:	47d5                	li	a5,21
    80005a08:	0af48663          	beq	s1,a5,80005ab4 <consoleintr+0xcc>
    80005a0c:	0297ca63          	blt	a5,s1,80005a40 <consoleintr+0x58>
    80005a10:	47a1                	li	a5,8
    80005a12:	0ef48763          	beq	s1,a5,80005b00 <consoleintr+0x118>
    80005a16:	47c1                	li	a5,16
    80005a18:	10f49a63          	bne	s1,a5,80005b2c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a1c:	ffffc097          	auipc	ra,0xffffc
    80005a20:	f8a080e7          	jalr	-118(ra) # 800019a6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a24:	00020517          	auipc	a0,0x20
    80005a28:	71c50513          	addi	a0,a0,1820 # 80026140 <cons>
    80005a2c:	00001097          	auipc	ra,0x1
    80005a30:	83a080e7          	jalr	-1990(ra) # 80006266 <release>
}
    80005a34:	60e2                	ld	ra,24(sp)
    80005a36:	6442                	ld	s0,16(sp)
    80005a38:	64a2                	ld	s1,8(sp)
    80005a3a:	6902                	ld	s2,0(sp)
    80005a3c:	6105                	addi	sp,sp,32
    80005a3e:	8082                	ret
  switch(c){
    80005a40:	07f00793          	li	a5,127
    80005a44:	0af48e63          	beq	s1,a5,80005b00 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a48:	00020717          	auipc	a4,0x20
    80005a4c:	6f870713          	addi	a4,a4,1784 # 80026140 <cons>
    80005a50:	0a072783          	lw	a5,160(a4)
    80005a54:	09872703          	lw	a4,152(a4)
    80005a58:	9f99                	subw	a5,a5,a4
    80005a5a:	07f00713          	li	a4,127
    80005a5e:	fcf763e3          	bltu	a4,a5,80005a24 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a62:	47b5                	li	a5,13
    80005a64:	0cf48763          	beq	s1,a5,80005b32 <consoleintr+0x14a>
      consputc(c);
    80005a68:	8526                	mv	a0,s1
    80005a6a:	00000097          	auipc	ra,0x0
    80005a6e:	f3c080e7          	jalr	-196(ra) # 800059a6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a72:	00020797          	auipc	a5,0x20
    80005a76:	6ce78793          	addi	a5,a5,1742 # 80026140 <cons>
    80005a7a:	0a07a703          	lw	a4,160(a5)
    80005a7e:	0017069b          	addiw	a3,a4,1
    80005a82:	0006861b          	sext.w	a2,a3
    80005a86:	0ad7a023          	sw	a3,160(a5)
    80005a8a:	07f77713          	andi	a4,a4,127
    80005a8e:	97ba                	add	a5,a5,a4
    80005a90:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a94:	47a9                	li	a5,10
    80005a96:	0cf48563          	beq	s1,a5,80005b60 <consoleintr+0x178>
    80005a9a:	4791                	li	a5,4
    80005a9c:	0cf48263          	beq	s1,a5,80005b60 <consoleintr+0x178>
    80005aa0:	00020797          	auipc	a5,0x20
    80005aa4:	7387a783          	lw	a5,1848(a5) # 800261d8 <cons+0x98>
    80005aa8:	0807879b          	addiw	a5,a5,128
    80005aac:	f6f61ce3          	bne	a2,a5,80005a24 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ab0:	863e                	mv	a2,a5
    80005ab2:	a07d                	j	80005b60 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ab4:	00020717          	auipc	a4,0x20
    80005ab8:	68c70713          	addi	a4,a4,1676 # 80026140 <cons>
    80005abc:	0a072783          	lw	a5,160(a4)
    80005ac0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ac4:	00020497          	auipc	s1,0x20
    80005ac8:	67c48493          	addi	s1,s1,1660 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005acc:	4929                	li	s2,10
    80005ace:	f4f70be3          	beq	a4,a5,80005a24 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ad2:	37fd                	addiw	a5,a5,-1
    80005ad4:	07f7f713          	andi	a4,a5,127
    80005ad8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ada:	01874703          	lbu	a4,24(a4)
    80005ade:	f52703e3          	beq	a4,s2,80005a24 <consoleintr+0x3c>
      cons.e--;
    80005ae2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ae6:	10000513          	li	a0,256
    80005aea:	00000097          	auipc	ra,0x0
    80005aee:	ebc080e7          	jalr	-324(ra) # 800059a6 <consputc>
    while(cons.e != cons.w &&
    80005af2:	0a04a783          	lw	a5,160(s1)
    80005af6:	09c4a703          	lw	a4,156(s1)
    80005afa:	fcf71ce3          	bne	a4,a5,80005ad2 <consoleintr+0xea>
    80005afe:	b71d                	j	80005a24 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b00:	00020717          	auipc	a4,0x20
    80005b04:	64070713          	addi	a4,a4,1600 # 80026140 <cons>
    80005b08:	0a072783          	lw	a5,160(a4)
    80005b0c:	09c72703          	lw	a4,156(a4)
    80005b10:	f0f70ae3          	beq	a4,a5,80005a24 <consoleintr+0x3c>
      cons.e--;
    80005b14:	37fd                	addiw	a5,a5,-1
    80005b16:	00020717          	auipc	a4,0x20
    80005b1a:	6cf72523          	sw	a5,1738(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b1e:	10000513          	li	a0,256
    80005b22:	00000097          	auipc	ra,0x0
    80005b26:	e84080e7          	jalr	-380(ra) # 800059a6 <consputc>
    80005b2a:	bded                	j	80005a24 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b2c:	ee048ce3          	beqz	s1,80005a24 <consoleintr+0x3c>
    80005b30:	bf21                	j	80005a48 <consoleintr+0x60>
      consputc(c);
    80005b32:	4529                	li	a0,10
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	e72080e7          	jalr	-398(ra) # 800059a6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b3c:	00020797          	auipc	a5,0x20
    80005b40:	60478793          	addi	a5,a5,1540 # 80026140 <cons>
    80005b44:	0a07a703          	lw	a4,160(a5)
    80005b48:	0017069b          	addiw	a3,a4,1
    80005b4c:	0006861b          	sext.w	a2,a3
    80005b50:	0ad7a023          	sw	a3,160(a5)
    80005b54:	07f77713          	andi	a4,a4,127
    80005b58:	97ba                	add	a5,a5,a4
    80005b5a:	4729                	li	a4,10
    80005b5c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b60:	00020797          	auipc	a5,0x20
    80005b64:	66c7ae23          	sw	a2,1660(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b68:	00020517          	auipc	a0,0x20
    80005b6c:	67050513          	addi	a0,a0,1648 # 800261d8 <cons+0x98>
    80005b70:	ffffc097          	auipc	ra,0xffffc
    80005b74:	b72080e7          	jalr	-1166(ra) # 800016e2 <wakeup>
    80005b78:	b575                	j	80005a24 <consoleintr+0x3c>

0000000080005b7a <consoleinit>:

void
consoleinit(void)
{
    80005b7a:	1141                	addi	sp,sp,-16
    80005b7c:	e406                	sd	ra,8(sp)
    80005b7e:	e022                	sd	s0,0(sp)
    80005b80:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b82:	00003597          	auipc	a1,0x3
    80005b86:	d9e58593          	addi	a1,a1,-610 # 80008920 <syscall_name+0x3d0>
    80005b8a:	00020517          	auipc	a0,0x20
    80005b8e:	5b650513          	addi	a0,a0,1462 # 80026140 <cons>
    80005b92:	00000097          	auipc	ra,0x0
    80005b96:	590080e7          	jalr	1424(ra) # 80006122 <initlock>

  uartinit();
    80005b9a:	00000097          	auipc	ra,0x0
    80005b9e:	330080e7          	jalr	816(ra) # 80005eca <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ba2:	00013797          	auipc	a5,0x13
    80005ba6:	72678793          	addi	a5,a5,1830 # 800192c8 <devsw>
    80005baa:	00000717          	auipc	a4,0x0
    80005bae:	ce470713          	addi	a4,a4,-796 # 8000588e <consoleread>
    80005bb2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bb4:	00000717          	auipc	a4,0x0
    80005bb8:	c7870713          	addi	a4,a4,-904 # 8000582c <consolewrite>
    80005bbc:	ef98                	sd	a4,24(a5)
}
    80005bbe:	60a2                	ld	ra,8(sp)
    80005bc0:	6402                	ld	s0,0(sp)
    80005bc2:	0141                	addi	sp,sp,16
    80005bc4:	8082                	ret

0000000080005bc6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bc6:	7179                	addi	sp,sp,-48
    80005bc8:	f406                	sd	ra,40(sp)
    80005bca:	f022                	sd	s0,32(sp)
    80005bcc:	ec26                	sd	s1,24(sp)
    80005bce:	e84a                	sd	s2,16(sp)
    80005bd0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bd2:	c219                	beqz	a2,80005bd8 <printint+0x12>
    80005bd4:	08054663          	bltz	a0,80005c60 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005bd8:	2501                	sext.w	a0,a0
    80005bda:	4881                	li	a7,0
    80005bdc:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005be0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005be2:	2581                	sext.w	a1,a1
    80005be4:	00003617          	auipc	a2,0x3
    80005be8:	d6c60613          	addi	a2,a2,-660 # 80008950 <digits>
    80005bec:	883a                	mv	a6,a4
    80005bee:	2705                	addiw	a4,a4,1
    80005bf0:	02b577bb          	remuw	a5,a0,a1
    80005bf4:	1782                	slli	a5,a5,0x20
    80005bf6:	9381                	srli	a5,a5,0x20
    80005bf8:	97b2                	add	a5,a5,a2
    80005bfa:	0007c783          	lbu	a5,0(a5)
    80005bfe:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c02:	0005079b          	sext.w	a5,a0
    80005c06:	02b5553b          	divuw	a0,a0,a1
    80005c0a:	0685                	addi	a3,a3,1
    80005c0c:	feb7f0e3          	bgeu	a5,a1,80005bec <printint+0x26>

  if(sign)
    80005c10:	00088b63          	beqz	a7,80005c26 <printint+0x60>
    buf[i++] = '-';
    80005c14:	fe040793          	addi	a5,s0,-32
    80005c18:	973e                	add	a4,a4,a5
    80005c1a:	02d00793          	li	a5,45
    80005c1e:	fef70823          	sb	a5,-16(a4)
    80005c22:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c26:	02e05763          	blez	a4,80005c54 <printint+0x8e>
    80005c2a:	fd040793          	addi	a5,s0,-48
    80005c2e:	00e784b3          	add	s1,a5,a4
    80005c32:	fff78913          	addi	s2,a5,-1
    80005c36:	993a                	add	s2,s2,a4
    80005c38:	377d                	addiw	a4,a4,-1
    80005c3a:	1702                	slli	a4,a4,0x20
    80005c3c:	9301                	srli	a4,a4,0x20
    80005c3e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c42:	fff4c503          	lbu	a0,-1(s1)
    80005c46:	00000097          	auipc	ra,0x0
    80005c4a:	d60080e7          	jalr	-672(ra) # 800059a6 <consputc>
  while(--i >= 0)
    80005c4e:	14fd                	addi	s1,s1,-1
    80005c50:	ff2499e3          	bne	s1,s2,80005c42 <printint+0x7c>
}
    80005c54:	70a2                	ld	ra,40(sp)
    80005c56:	7402                	ld	s0,32(sp)
    80005c58:	64e2                	ld	s1,24(sp)
    80005c5a:	6942                	ld	s2,16(sp)
    80005c5c:	6145                	addi	sp,sp,48
    80005c5e:	8082                	ret
    x = -xx;
    80005c60:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c64:	4885                	li	a7,1
    x = -xx;
    80005c66:	bf9d                	j	80005bdc <printint+0x16>

0000000080005c68 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c68:	1101                	addi	sp,sp,-32
    80005c6a:	ec06                	sd	ra,24(sp)
    80005c6c:	e822                	sd	s0,16(sp)
    80005c6e:	e426                	sd	s1,8(sp)
    80005c70:	1000                	addi	s0,sp,32
    80005c72:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c74:	00020797          	auipc	a5,0x20
    80005c78:	5807a623          	sw	zero,1420(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c7c:	00003517          	auipc	a0,0x3
    80005c80:	cac50513          	addi	a0,a0,-852 # 80008928 <syscall_name+0x3d8>
    80005c84:	00000097          	auipc	ra,0x0
    80005c88:	02e080e7          	jalr	46(ra) # 80005cb2 <printf>
  printf(s);
    80005c8c:	8526                	mv	a0,s1
    80005c8e:	00000097          	auipc	ra,0x0
    80005c92:	024080e7          	jalr	36(ra) # 80005cb2 <printf>
  printf("\n");
    80005c96:	00002517          	auipc	a0,0x2
    80005c9a:	3b250513          	addi	a0,a0,946 # 80008048 <etext+0x48>
    80005c9e:	00000097          	auipc	ra,0x0
    80005ca2:	014080e7          	jalr	20(ra) # 80005cb2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ca6:	4785                	li	a5,1
    80005ca8:	00003717          	auipc	a4,0x3
    80005cac:	36f72a23          	sw	a5,884(a4) # 8000901c <panicked>
  for(;;)
    80005cb0:	a001                	j	80005cb0 <panic+0x48>

0000000080005cb2 <printf>:
{
    80005cb2:	7131                	addi	sp,sp,-192
    80005cb4:	fc86                	sd	ra,120(sp)
    80005cb6:	f8a2                	sd	s0,112(sp)
    80005cb8:	f4a6                	sd	s1,104(sp)
    80005cba:	f0ca                	sd	s2,96(sp)
    80005cbc:	ecce                	sd	s3,88(sp)
    80005cbe:	e8d2                	sd	s4,80(sp)
    80005cc0:	e4d6                	sd	s5,72(sp)
    80005cc2:	e0da                	sd	s6,64(sp)
    80005cc4:	fc5e                	sd	s7,56(sp)
    80005cc6:	f862                	sd	s8,48(sp)
    80005cc8:	f466                	sd	s9,40(sp)
    80005cca:	f06a                	sd	s10,32(sp)
    80005ccc:	ec6e                	sd	s11,24(sp)
    80005cce:	0100                	addi	s0,sp,128
    80005cd0:	8a2a                	mv	s4,a0
    80005cd2:	e40c                	sd	a1,8(s0)
    80005cd4:	e810                	sd	a2,16(s0)
    80005cd6:	ec14                	sd	a3,24(s0)
    80005cd8:	f018                	sd	a4,32(s0)
    80005cda:	f41c                	sd	a5,40(s0)
    80005cdc:	03043823          	sd	a6,48(s0)
    80005ce0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005ce4:	00020d97          	auipc	s11,0x20
    80005ce8:	51cdad83          	lw	s11,1308(s11) # 80026200 <pr+0x18>
  if(locking)
    80005cec:	020d9b63          	bnez	s11,80005d22 <printf+0x70>
  if (fmt == 0)
    80005cf0:	040a0263          	beqz	s4,80005d34 <printf+0x82>
  va_start(ap, fmt);
    80005cf4:	00840793          	addi	a5,s0,8
    80005cf8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cfc:	000a4503          	lbu	a0,0(s4)
    80005d00:	16050263          	beqz	a0,80005e64 <printf+0x1b2>
    80005d04:	4481                	li	s1,0
    if(c != '%'){
    80005d06:	02500a93          	li	s5,37
    switch(c){
    80005d0a:	07000b13          	li	s6,112
  consputc('x');
    80005d0e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d10:	00003b97          	auipc	s7,0x3
    80005d14:	c40b8b93          	addi	s7,s7,-960 # 80008950 <digits>
    switch(c){
    80005d18:	07300c93          	li	s9,115
    80005d1c:	06400c13          	li	s8,100
    80005d20:	a82d                	j	80005d5a <printf+0xa8>
    acquire(&pr.lock);
    80005d22:	00020517          	auipc	a0,0x20
    80005d26:	4c650513          	addi	a0,a0,1222 # 800261e8 <pr>
    80005d2a:	00000097          	auipc	ra,0x0
    80005d2e:	488080e7          	jalr	1160(ra) # 800061b2 <acquire>
    80005d32:	bf7d                	j	80005cf0 <printf+0x3e>
    panic("null fmt");
    80005d34:	00003517          	auipc	a0,0x3
    80005d38:	c0450513          	addi	a0,a0,-1020 # 80008938 <syscall_name+0x3e8>
    80005d3c:	00000097          	auipc	ra,0x0
    80005d40:	f2c080e7          	jalr	-212(ra) # 80005c68 <panic>
      consputc(c);
    80005d44:	00000097          	auipc	ra,0x0
    80005d48:	c62080e7          	jalr	-926(ra) # 800059a6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d4c:	2485                	addiw	s1,s1,1
    80005d4e:	009a07b3          	add	a5,s4,s1
    80005d52:	0007c503          	lbu	a0,0(a5)
    80005d56:	10050763          	beqz	a0,80005e64 <printf+0x1b2>
    if(c != '%'){
    80005d5a:	ff5515e3          	bne	a0,s5,80005d44 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d5e:	2485                	addiw	s1,s1,1
    80005d60:	009a07b3          	add	a5,s4,s1
    80005d64:	0007c783          	lbu	a5,0(a5)
    80005d68:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005d6c:	cfe5                	beqz	a5,80005e64 <printf+0x1b2>
    switch(c){
    80005d6e:	05678a63          	beq	a5,s6,80005dc2 <printf+0x110>
    80005d72:	02fb7663          	bgeu	s6,a5,80005d9e <printf+0xec>
    80005d76:	09978963          	beq	a5,s9,80005e08 <printf+0x156>
    80005d7a:	07800713          	li	a4,120
    80005d7e:	0ce79863          	bne	a5,a4,80005e4e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005d82:	f8843783          	ld	a5,-120(s0)
    80005d86:	00878713          	addi	a4,a5,8
    80005d8a:	f8e43423          	sd	a4,-120(s0)
    80005d8e:	4605                	li	a2,1
    80005d90:	85ea                	mv	a1,s10
    80005d92:	4388                	lw	a0,0(a5)
    80005d94:	00000097          	auipc	ra,0x0
    80005d98:	e32080e7          	jalr	-462(ra) # 80005bc6 <printint>
      break;
    80005d9c:	bf45                	j	80005d4c <printf+0x9a>
    switch(c){
    80005d9e:	0b578263          	beq	a5,s5,80005e42 <printf+0x190>
    80005da2:	0b879663          	bne	a5,s8,80005e4e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005da6:	f8843783          	ld	a5,-120(s0)
    80005daa:	00878713          	addi	a4,a5,8
    80005dae:	f8e43423          	sd	a4,-120(s0)
    80005db2:	4605                	li	a2,1
    80005db4:	45a9                	li	a1,10
    80005db6:	4388                	lw	a0,0(a5)
    80005db8:	00000097          	auipc	ra,0x0
    80005dbc:	e0e080e7          	jalr	-498(ra) # 80005bc6 <printint>
      break;
    80005dc0:	b771                	j	80005d4c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005dc2:	f8843783          	ld	a5,-120(s0)
    80005dc6:	00878713          	addi	a4,a5,8
    80005dca:	f8e43423          	sd	a4,-120(s0)
    80005dce:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005dd2:	03000513          	li	a0,48
    80005dd6:	00000097          	auipc	ra,0x0
    80005dda:	bd0080e7          	jalr	-1072(ra) # 800059a6 <consputc>
  consputc('x');
    80005dde:	07800513          	li	a0,120
    80005de2:	00000097          	auipc	ra,0x0
    80005de6:	bc4080e7          	jalr	-1084(ra) # 800059a6 <consputc>
    80005dea:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dec:	03c9d793          	srli	a5,s3,0x3c
    80005df0:	97de                	add	a5,a5,s7
    80005df2:	0007c503          	lbu	a0,0(a5)
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	bb0080e7          	jalr	-1104(ra) # 800059a6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005dfe:	0992                	slli	s3,s3,0x4
    80005e00:	397d                	addiw	s2,s2,-1
    80005e02:	fe0915e3          	bnez	s2,80005dec <printf+0x13a>
    80005e06:	b799                	j	80005d4c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e08:	f8843783          	ld	a5,-120(s0)
    80005e0c:	00878713          	addi	a4,a5,8
    80005e10:	f8e43423          	sd	a4,-120(s0)
    80005e14:	0007b903          	ld	s2,0(a5)
    80005e18:	00090e63          	beqz	s2,80005e34 <printf+0x182>
      for(; *s; s++)
    80005e1c:	00094503          	lbu	a0,0(s2)
    80005e20:	d515                	beqz	a0,80005d4c <printf+0x9a>
        consputc(*s);
    80005e22:	00000097          	auipc	ra,0x0
    80005e26:	b84080e7          	jalr	-1148(ra) # 800059a6 <consputc>
      for(; *s; s++)
    80005e2a:	0905                	addi	s2,s2,1
    80005e2c:	00094503          	lbu	a0,0(s2)
    80005e30:	f96d                	bnez	a0,80005e22 <printf+0x170>
    80005e32:	bf29                	j	80005d4c <printf+0x9a>
        s = "(null)";
    80005e34:	00003917          	auipc	s2,0x3
    80005e38:	afc90913          	addi	s2,s2,-1284 # 80008930 <syscall_name+0x3e0>
      for(; *s; s++)
    80005e3c:	02800513          	li	a0,40
    80005e40:	b7cd                	j	80005e22 <printf+0x170>
      consputc('%');
    80005e42:	8556                	mv	a0,s5
    80005e44:	00000097          	auipc	ra,0x0
    80005e48:	b62080e7          	jalr	-1182(ra) # 800059a6 <consputc>
      break;
    80005e4c:	b701                	j	80005d4c <printf+0x9a>
      consputc('%');
    80005e4e:	8556                	mv	a0,s5
    80005e50:	00000097          	auipc	ra,0x0
    80005e54:	b56080e7          	jalr	-1194(ra) # 800059a6 <consputc>
      consputc(c);
    80005e58:	854a                	mv	a0,s2
    80005e5a:	00000097          	auipc	ra,0x0
    80005e5e:	b4c080e7          	jalr	-1204(ra) # 800059a6 <consputc>
      break;
    80005e62:	b5ed                	j	80005d4c <printf+0x9a>
  if(locking)
    80005e64:	020d9163          	bnez	s11,80005e86 <printf+0x1d4>
}
    80005e68:	70e6                	ld	ra,120(sp)
    80005e6a:	7446                	ld	s0,112(sp)
    80005e6c:	74a6                	ld	s1,104(sp)
    80005e6e:	7906                	ld	s2,96(sp)
    80005e70:	69e6                	ld	s3,88(sp)
    80005e72:	6a46                	ld	s4,80(sp)
    80005e74:	6aa6                	ld	s5,72(sp)
    80005e76:	6b06                	ld	s6,64(sp)
    80005e78:	7be2                	ld	s7,56(sp)
    80005e7a:	7c42                	ld	s8,48(sp)
    80005e7c:	7ca2                	ld	s9,40(sp)
    80005e7e:	7d02                	ld	s10,32(sp)
    80005e80:	6de2                	ld	s11,24(sp)
    80005e82:	6129                	addi	sp,sp,192
    80005e84:	8082                	ret
    release(&pr.lock);
    80005e86:	00020517          	auipc	a0,0x20
    80005e8a:	36250513          	addi	a0,a0,866 # 800261e8 <pr>
    80005e8e:	00000097          	auipc	ra,0x0
    80005e92:	3d8080e7          	jalr	984(ra) # 80006266 <release>
}
    80005e96:	bfc9                	j	80005e68 <printf+0x1b6>

0000000080005e98 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e98:	1101                	addi	sp,sp,-32
    80005e9a:	ec06                	sd	ra,24(sp)
    80005e9c:	e822                	sd	s0,16(sp)
    80005e9e:	e426                	sd	s1,8(sp)
    80005ea0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ea2:	00020497          	auipc	s1,0x20
    80005ea6:	34648493          	addi	s1,s1,838 # 800261e8 <pr>
    80005eaa:	00003597          	auipc	a1,0x3
    80005eae:	a9e58593          	addi	a1,a1,-1378 # 80008948 <syscall_name+0x3f8>
    80005eb2:	8526                	mv	a0,s1
    80005eb4:	00000097          	auipc	ra,0x0
    80005eb8:	26e080e7          	jalr	622(ra) # 80006122 <initlock>
  pr.locking = 1;
    80005ebc:	4785                	li	a5,1
    80005ebe:	cc9c                	sw	a5,24(s1)
}
    80005ec0:	60e2                	ld	ra,24(sp)
    80005ec2:	6442                	ld	s0,16(sp)
    80005ec4:	64a2                	ld	s1,8(sp)
    80005ec6:	6105                	addi	sp,sp,32
    80005ec8:	8082                	ret

0000000080005eca <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005eca:	1141                	addi	sp,sp,-16
    80005ecc:	e406                	sd	ra,8(sp)
    80005ece:	e022                	sd	s0,0(sp)
    80005ed0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ed2:	100007b7          	lui	a5,0x10000
    80005ed6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005eda:	f8000713          	li	a4,-128
    80005ede:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ee2:	470d                	li	a4,3
    80005ee4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005ee8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005eec:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ef0:	469d                	li	a3,7
    80005ef2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ef6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005efa:	00003597          	auipc	a1,0x3
    80005efe:	a6e58593          	addi	a1,a1,-1426 # 80008968 <digits+0x18>
    80005f02:	00020517          	auipc	a0,0x20
    80005f06:	30650513          	addi	a0,a0,774 # 80026208 <uart_tx_lock>
    80005f0a:	00000097          	auipc	ra,0x0
    80005f0e:	218080e7          	jalr	536(ra) # 80006122 <initlock>
}
    80005f12:	60a2                	ld	ra,8(sp)
    80005f14:	6402                	ld	s0,0(sp)
    80005f16:	0141                	addi	sp,sp,16
    80005f18:	8082                	ret

0000000080005f1a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f1a:	1101                	addi	sp,sp,-32
    80005f1c:	ec06                	sd	ra,24(sp)
    80005f1e:	e822                	sd	s0,16(sp)
    80005f20:	e426                	sd	s1,8(sp)
    80005f22:	1000                	addi	s0,sp,32
    80005f24:	84aa                	mv	s1,a0
  push_off();
    80005f26:	00000097          	auipc	ra,0x0
    80005f2a:	240080e7          	jalr	576(ra) # 80006166 <push_off>

  if(panicked){
    80005f2e:	00003797          	auipc	a5,0x3
    80005f32:	0ee7a783          	lw	a5,238(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f36:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f3a:	c391                	beqz	a5,80005f3e <uartputc_sync+0x24>
    for(;;)
    80005f3c:	a001                	j	80005f3c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f3e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f42:	0ff7f793          	andi	a5,a5,255
    80005f46:	0207f793          	andi	a5,a5,32
    80005f4a:	dbf5                	beqz	a5,80005f3e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f4c:	0ff4f793          	andi	a5,s1,255
    80005f50:	10000737          	lui	a4,0x10000
    80005f54:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f58:	00000097          	auipc	ra,0x0
    80005f5c:	2ae080e7          	jalr	686(ra) # 80006206 <pop_off>
}
    80005f60:	60e2                	ld	ra,24(sp)
    80005f62:	6442                	ld	s0,16(sp)
    80005f64:	64a2                	ld	s1,8(sp)
    80005f66:	6105                	addi	sp,sp,32
    80005f68:	8082                	ret

0000000080005f6a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f6a:	00003717          	auipc	a4,0x3
    80005f6e:	0b673703          	ld	a4,182(a4) # 80009020 <uart_tx_r>
    80005f72:	00003797          	auipc	a5,0x3
    80005f76:	0b67b783          	ld	a5,182(a5) # 80009028 <uart_tx_w>
    80005f7a:	06e78c63          	beq	a5,a4,80005ff2 <uartstart+0x88>
{
    80005f7e:	7139                	addi	sp,sp,-64
    80005f80:	fc06                	sd	ra,56(sp)
    80005f82:	f822                	sd	s0,48(sp)
    80005f84:	f426                	sd	s1,40(sp)
    80005f86:	f04a                	sd	s2,32(sp)
    80005f88:	ec4e                	sd	s3,24(sp)
    80005f8a:	e852                	sd	s4,16(sp)
    80005f8c:	e456                	sd	s5,8(sp)
    80005f8e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f90:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f94:	00020a17          	auipc	s4,0x20
    80005f98:	274a0a13          	addi	s4,s4,628 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005f9c:	00003497          	auipc	s1,0x3
    80005fa0:	08448493          	addi	s1,s1,132 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fa4:	00003997          	auipc	s3,0x3
    80005fa8:	08498993          	addi	s3,s3,132 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fac:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fb0:	0ff7f793          	andi	a5,a5,255
    80005fb4:	0207f793          	andi	a5,a5,32
    80005fb8:	c785                	beqz	a5,80005fe0 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fba:	01f77793          	andi	a5,a4,31
    80005fbe:	97d2                	add	a5,a5,s4
    80005fc0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005fc4:	0705                	addi	a4,a4,1
    80005fc6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fc8:	8526                	mv	a0,s1
    80005fca:	ffffb097          	auipc	ra,0xffffb
    80005fce:	718080e7          	jalr	1816(ra) # 800016e2 <wakeup>
    
    WriteReg(THR, c);
    80005fd2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fd6:	6098                	ld	a4,0(s1)
    80005fd8:	0009b783          	ld	a5,0(s3)
    80005fdc:	fce798e3          	bne	a5,a4,80005fac <uartstart+0x42>
  }
}
    80005fe0:	70e2                	ld	ra,56(sp)
    80005fe2:	7442                	ld	s0,48(sp)
    80005fe4:	74a2                	ld	s1,40(sp)
    80005fe6:	7902                	ld	s2,32(sp)
    80005fe8:	69e2                	ld	s3,24(sp)
    80005fea:	6a42                	ld	s4,16(sp)
    80005fec:	6aa2                	ld	s5,8(sp)
    80005fee:	6121                	addi	sp,sp,64
    80005ff0:	8082                	ret
    80005ff2:	8082                	ret

0000000080005ff4 <uartputc>:
{
    80005ff4:	7179                	addi	sp,sp,-48
    80005ff6:	f406                	sd	ra,40(sp)
    80005ff8:	f022                	sd	s0,32(sp)
    80005ffa:	ec26                	sd	s1,24(sp)
    80005ffc:	e84a                	sd	s2,16(sp)
    80005ffe:	e44e                	sd	s3,8(sp)
    80006000:	e052                	sd	s4,0(sp)
    80006002:	1800                	addi	s0,sp,48
    80006004:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006006:	00020517          	auipc	a0,0x20
    8000600a:	20250513          	addi	a0,a0,514 # 80026208 <uart_tx_lock>
    8000600e:	00000097          	auipc	ra,0x0
    80006012:	1a4080e7          	jalr	420(ra) # 800061b2 <acquire>
  if(panicked){
    80006016:	00003797          	auipc	a5,0x3
    8000601a:	0067a783          	lw	a5,6(a5) # 8000901c <panicked>
    8000601e:	c391                	beqz	a5,80006022 <uartputc+0x2e>
    for(;;)
    80006020:	a001                	j	80006020 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006022:	00003797          	auipc	a5,0x3
    80006026:	0067b783          	ld	a5,6(a5) # 80009028 <uart_tx_w>
    8000602a:	00003717          	auipc	a4,0x3
    8000602e:	ff673703          	ld	a4,-10(a4) # 80009020 <uart_tx_r>
    80006032:	02070713          	addi	a4,a4,32
    80006036:	02f71b63          	bne	a4,a5,8000606c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000603a:	00020a17          	auipc	s4,0x20
    8000603e:	1cea0a13          	addi	s4,s4,462 # 80026208 <uart_tx_lock>
    80006042:	00003497          	auipc	s1,0x3
    80006046:	fde48493          	addi	s1,s1,-34 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000604a:	00003917          	auipc	s2,0x3
    8000604e:	fde90913          	addi	s2,s2,-34 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006052:	85d2                	mv	a1,s4
    80006054:	8526                	mv	a0,s1
    80006056:	ffffb097          	auipc	ra,0xffffb
    8000605a:	500080e7          	jalr	1280(ra) # 80001556 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000605e:	00093783          	ld	a5,0(s2)
    80006062:	6098                	ld	a4,0(s1)
    80006064:	02070713          	addi	a4,a4,32
    80006068:	fef705e3          	beq	a4,a5,80006052 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000606c:	00020497          	auipc	s1,0x20
    80006070:	19c48493          	addi	s1,s1,412 # 80026208 <uart_tx_lock>
    80006074:	01f7f713          	andi	a4,a5,31
    80006078:	9726                	add	a4,a4,s1
    8000607a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000607e:	0785                	addi	a5,a5,1
    80006080:	00003717          	auipc	a4,0x3
    80006084:	faf73423          	sd	a5,-88(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006088:	00000097          	auipc	ra,0x0
    8000608c:	ee2080e7          	jalr	-286(ra) # 80005f6a <uartstart>
      release(&uart_tx_lock);
    80006090:	8526                	mv	a0,s1
    80006092:	00000097          	auipc	ra,0x0
    80006096:	1d4080e7          	jalr	468(ra) # 80006266 <release>
}
    8000609a:	70a2                	ld	ra,40(sp)
    8000609c:	7402                	ld	s0,32(sp)
    8000609e:	64e2                	ld	s1,24(sp)
    800060a0:	6942                	ld	s2,16(sp)
    800060a2:	69a2                	ld	s3,8(sp)
    800060a4:	6a02                	ld	s4,0(sp)
    800060a6:	6145                	addi	sp,sp,48
    800060a8:	8082                	ret

00000000800060aa <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060aa:	1141                	addi	sp,sp,-16
    800060ac:	e422                	sd	s0,8(sp)
    800060ae:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060b0:	100007b7          	lui	a5,0x10000
    800060b4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060b8:	8b85                	andi	a5,a5,1
    800060ba:	cb91                	beqz	a5,800060ce <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060bc:	100007b7          	lui	a5,0x10000
    800060c0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800060c4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800060c8:	6422                	ld	s0,8(sp)
    800060ca:	0141                	addi	sp,sp,16
    800060cc:	8082                	ret
    return -1;
    800060ce:	557d                	li	a0,-1
    800060d0:	bfe5                	j	800060c8 <uartgetc+0x1e>

00000000800060d2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800060d2:	1101                	addi	sp,sp,-32
    800060d4:	ec06                	sd	ra,24(sp)
    800060d6:	e822                	sd	s0,16(sp)
    800060d8:	e426                	sd	s1,8(sp)
    800060da:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060dc:	54fd                	li	s1,-1
    int c = uartgetc();
    800060de:	00000097          	auipc	ra,0x0
    800060e2:	fcc080e7          	jalr	-52(ra) # 800060aa <uartgetc>
    if(c == -1)
    800060e6:	00950763          	beq	a0,s1,800060f4 <uartintr+0x22>
      break;
    consoleintr(c);
    800060ea:	00000097          	auipc	ra,0x0
    800060ee:	8fe080e7          	jalr	-1794(ra) # 800059e8 <consoleintr>
  while(1){
    800060f2:	b7f5                	j	800060de <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060f4:	00020497          	auipc	s1,0x20
    800060f8:	11448493          	addi	s1,s1,276 # 80026208 <uart_tx_lock>
    800060fc:	8526                	mv	a0,s1
    800060fe:	00000097          	auipc	ra,0x0
    80006102:	0b4080e7          	jalr	180(ra) # 800061b2 <acquire>
  uartstart();
    80006106:	00000097          	auipc	ra,0x0
    8000610a:	e64080e7          	jalr	-412(ra) # 80005f6a <uartstart>
  release(&uart_tx_lock);
    8000610e:	8526                	mv	a0,s1
    80006110:	00000097          	auipc	ra,0x0
    80006114:	156080e7          	jalr	342(ra) # 80006266 <release>
}
    80006118:	60e2                	ld	ra,24(sp)
    8000611a:	6442                	ld	s0,16(sp)
    8000611c:	64a2                	ld	s1,8(sp)
    8000611e:	6105                	addi	sp,sp,32
    80006120:	8082                	ret

0000000080006122 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006122:	1141                	addi	sp,sp,-16
    80006124:	e422                	sd	s0,8(sp)
    80006126:	0800                	addi	s0,sp,16
  lk->name = name;
    80006128:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000612a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000612e:	00053823          	sd	zero,16(a0)
}
    80006132:	6422                	ld	s0,8(sp)
    80006134:	0141                	addi	sp,sp,16
    80006136:	8082                	ret

0000000080006138 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006138:	411c                	lw	a5,0(a0)
    8000613a:	e399                	bnez	a5,80006140 <holding+0x8>
    8000613c:	4501                	li	a0,0
  return r;
}
    8000613e:	8082                	ret
{
    80006140:	1101                	addi	sp,sp,-32
    80006142:	ec06                	sd	ra,24(sp)
    80006144:	e822                	sd	s0,16(sp)
    80006146:	e426                	sd	s1,8(sp)
    80006148:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000614a:	6904                	ld	s1,16(a0)
    8000614c:	ffffb097          	auipc	ra,0xffffb
    80006150:	d2a080e7          	jalr	-726(ra) # 80000e76 <mycpu>
    80006154:	40a48533          	sub	a0,s1,a0
    80006158:	00153513          	seqz	a0,a0
}
    8000615c:	60e2                	ld	ra,24(sp)
    8000615e:	6442                	ld	s0,16(sp)
    80006160:	64a2                	ld	s1,8(sp)
    80006162:	6105                	addi	sp,sp,32
    80006164:	8082                	ret

0000000080006166 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006166:	1101                	addi	sp,sp,-32
    80006168:	ec06                	sd	ra,24(sp)
    8000616a:	e822                	sd	s0,16(sp)
    8000616c:	e426                	sd	s1,8(sp)
    8000616e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006170:	100024f3          	csrr	s1,sstatus
    80006174:	100027f3          	csrr	a5,sstatus
}
    80006178:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000617a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000617e:	ffffb097          	auipc	ra,0xffffb
    80006182:	cf8080e7          	jalr	-776(ra) # 80000e76 <mycpu>
    80006186:	5d3c                	lw	a5,120(a0)
    80006188:	cf89                	beqz	a5,800061a2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000618a:	ffffb097          	auipc	ra,0xffffb
    8000618e:	cec080e7          	jalr	-788(ra) # 80000e76 <mycpu>
    80006192:	5d3c                	lw	a5,120(a0)
    80006194:	2785                	addiw	a5,a5,1
    80006196:	dd3c                	sw	a5,120(a0)
}
    80006198:	60e2                	ld	ra,24(sp)
    8000619a:	6442                	ld	s0,16(sp)
    8000619c:	64a2                	ld	s1,8(sp)
    8000619e:	6105                	addi	sp,sp,32
    800061a0:	8082                	ret
    mycpu()->intena = old;
    800061a2:	ffffb097          	auipc	ra,0xffffb
    800061a6:	cd4080e7          	jalr	-812(ra) # 80000e76 <mycpu>

    800061aa:	8085                	srli	s1,s1,0x1
    800061ac:	8885                	andi	s1,s1,1
    800061ae:	dd64                	sw	s1,124(a0)
    800061b0:	bfe9                	j	8000618a <push_off+0x24>

00000000800061b2 <acquire>:
{
    800061b2:	1101                	addi	sp,sp,-32
    800061b4:	ec06                	sd	ra,24(sp)
    800061b6:	e822                	sd	s0,16(sp)
    800061b8:	e426                	sd	s1,8(sp)
    800061ba:	1000                	addi	s0,sp,32
    800061bc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061be:	00000097          	auipc	ra,0x0
    800061c2:	fa8080e7          	jalr	-88(ra) # 80006166 <push_off>
  if(holding(lk))
    800061c6:	8526                	mv	a0,s1
    800061c8:	00000097          	auipc	ra,0x0
    800061cc:	f70080e7          	jalr	-144(ra) # 80006138 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061d0:	4705                	li	a4,1
  if(holding(lk))
    800061d2:	e115                	bnez	a0,800061f6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061d4:	87ba                	mv	a5,a4
    800061d6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061da:	2781                	sext.w	a5,a5
    800061dc:	ffe5                	bnez	a5,800061d4 <acquire+0x22>
  __sync_synchronize();
    800061de:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061e2:	ffffb097          	auipc	ra,0xffffb
    800061e6:	c94080e7          	jalr	-876(ra) # 80000e76 <mycpu>
    800061ea:	e888                	sd	a0,16(s1)
}
    800061ec:	60e2                	ld	ra,24(sp)
    800061ee:	6442                	ld	s0,16(sp)
    800061f0:	64a2                	ld	s1,8(sp)
    800061f2:	6105                	addi	sp,sp,32
    800061f4:	8082                	ret
    panic("acquire");
    800061f6:	00002517          	auipc	a0,0x2
    800061fa:	77a50513          	addi	a0,a0,1914 # 80008970 <digits+0x20>
    800061fe:	00000097          	auipc	ra,0x0
    80006202:	a6a080e7          	jalr	-1430(ra) # 80005c68 <panic>

0000000080006206 <pop_off>:

void
pop_off(void)
{
    80006206:	1141                	addi	sp,sp,-16
    80006208:	e406                	sd	ra,8(sp)
    8000620a:	e022                	sd	s0,0(sp)
    8000620c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000620e:	ffffb097          	auipc	ra,0xffffb
    80006212:	c68080e7          	jalr	-920(ra) # 80000e76 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006216:	100027f3          	csrr	a5,sstatus

    8000621a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000621c:	e78d                	bnez	a5,80006246 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000621e:	5d3c                	lw	a5,120(a0)
    80006220:	02f05b63          	blez	a5,80006256 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006224:	37fd                	addiw	a5,a5,-1
    80006226:	0007871b          	sext.w	a4,a5
    8000622a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000622c:	eb09                	bnez	a4,8000623e <pop_off+0x38>
    8000622e:	5d7c                	lw	a5,124(a0)
    80006230:	c799                	beqz	a5,8000623e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006232:	100027f3          	csrr	a5,sstatus
}
    80006236:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000623a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000623e:	60a2                	ld	ra,8(sp)
    80006240:	6402                	ld	s0,0(sp)
    80006242:	0141                	addi	sp,sp,16
    80006244:	8082                	ret
    panic("pop_off - interruptible");
    80006246:	00002517          	auipc	a0,0x2
    8000624a:	73250513          	addi	a0,a0,1842 # 80008978 <digits+0x28>
    8000624e:	00000097          	auipc	ra,0x0
    80006252:	a1a080e7          	jalr	-1510(ra) # 80005c68 <panic>
    panic("pop_off");
    80006256:	00002517          	auipc	a0,0x2
    8000625a:	73a50513          	addi	a0,a0,1850 # 80008990 <digits+0x40>
    8000625e:	00000097          	auipc	ra,0x0
    80006262:	a0a080e7          	jalr	-1526(ra) # 80005c68 <panic>

0000000080006266 <release>:
{
    80006266:	1101                	addi	sp,sp,-32
    80006268:	ec06                	sd	ra,24(sp)
    8000626a:	e822                	sd	s0,16(sp)
    8000626c:	e426                	sd	s1,8(sp)
    8000626e:	1000                	addi	s0,sp,32
    80006270:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006272:	00000097          	auipc	ra,0x0
    80006276:	ec6080e7          	jalr	-314(ra) # 80006138 <holding>
    8000627a:	c115                	beqz	a0,8000629e <release+0x38>
  lk->cpu = 0;
    8000627c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006280:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006284:	0f50000f          	fence	iorw,ow
    80006288:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000628c:	00000097          	auipc	ra,0x0
    80006290:	f7a080e7          	jalr	-134(ra) # 80006206 <pop_off>
}
    80006294:	60e2                	ld	ra,24(sp)
    80006296:	6442                	ld	s0,16(sp)
    80006298:	64a2                	ld	s1,8(sp)
    8000629a:	6105                	addi	sp,sp,32
    8000629c:	8082                	ret
    panic("release");
    8000629e:	00002517          	auipc	a0,0x2
    800062a2:	6fa50513          	addi	a0,a0,1786 # 80008998 <digits+0x48>
    800062a6:	00000097          	auipc	ra,0x0
    800062aa:	9c2080e7          	jalr	-1598(ra) # 80005c68 <panic>
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
