
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0003e117          	auipc	sp,0x3e
    80000004:	14010113          	addi	sp,sp,320 # 8003e140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	083050ef          	jal	ra,80005898 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <add_rc>:
static int reference_count[(PHYSTOP - 0x80000000) / PGSIZE];

static int idx_rc(uint64 pa){
    return (pa - 0x80000000) / PGSIZE;
}
void add_rc(uint64 pa){
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
    return (pa - 0x80000000) / PGSIZE;
    80000022:	800007b7          	lui	a5,0x80000
    80000026:	97aa                	add	a5,a5,a0
    80000028:	83b1                	srli	a5,a5,0xc
    8000002a:	2781                	sext.w	a5,a5
    reference_count[idx_rc(pa)]++;
    8000002c:	078a                	slli	a5,a5,0x2
    8000002e:	00009717          	auipc	a4,0x9
    80000032:	02270713          	addi	a4,a4,34 # 80009050 <reference_count>
    80000036:	97ba                	add	a5,a5,a4
    80000038:	4398                	lw	a4,0(a5)
    8000003a:	2705                	addiw	a4,a4,1
    8000003c:	c398                	sw	a4,0(a5)
    //printf("addrc,pa = %p,rc = %d\n",pa,reference_count[idx_rc(pa)]);
}
    8000003e:	6422                	ld	s0,8(sp)
    80000040:	0141                	addi	sp,sp,16
    80000042:	8082                	ret

0000000080000044 <sub_rc>:
void sub_rc(uint64 pa){
    80000044:	1141                	addi	sp,sp,-16
    80000046:	e422                	sd	s0,8(sp)
    80000048:	0800                	addi	s0,sp,16
    return (pa - 0x80000000) / PGSIZE;
    8000004a:	800007b7          	lui	a5,0x80000
    8000004e:	97aa                	add	a5,a5,a0
    80000050:	83b1                	srli	a5,a5,0xc
    80000052:	2781                	sext.w	a5,a5
    reference_count[idx_rc(pa)]--;
    80000054:	078a                	slli	a5,a5,0x2
    80000056:	00009717          	auipc	a4,0x9
    8000005a:	ffa70713          	addi	a4,a4,-6 # 80009050 <reference_count>
    8000005e:	97ba                	add	a5,a5,a4
    80000060:	4398                	lw	a4,0(a5)
    80000062:	377d                	addiw	a4,a4,-1
    80000064:	c398                	sw	a4,0(a5)
    //printf("subrc,pa = %p,rc = %d\n",pa,reference_count[idx_rc(pa)]);
}
    80000066:	6422                	ld	s0,8(sp)
    80000068:	0141                	addi	sp,sp,16
    8000006a:	8082                	ret

000000008000006c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000006c:	7179                	addi	sp,sp,-48
    8000006e:	f406                	sd	ra,40(sp)
    80000070:	f022                	sd	s0,32(sp)
    80000072:	ec26                	sd	s1,24(sp)
    80000074:	e84a                	sd	s2,16(sp)
    80000076:	e44e                	sd	s3,8(sp)
    80000078:	1800                	addi	s0,sp,48
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000007a:	03451793          	slli	a5,a0,0x34
    8000007e:	e7c9                	bnez	a5,80000108 <kfree+0x9c>
    80000080:	892a                	mv	s2,a0
    80000082:	00046797          	auipc	a5,0x46
    80000086:	1be78793          	addi	a5,a5,446 # 80046240 <end>
    8000008a:	06f56f63          	bltu	a0,a5,80000108 <kfree+0x9c>
    8000008e:	47c5                	li	a5,17
    80000090:	07ee                	slli	a5,a5,0x1b
    80000092:	06f57b63          	bgeu	a0,a5,80000108 <kfree+0x9c>
    return (pa - 0x80000000) / PGSIZE;
    80000096:	800004b7          	lui	s1,0x80000
    8000009a:	94aa                	add	s1,s1,a0
    8000009c:	80b1                	srli	s1,s1,0xc
    8000009e:	2481                	sext.w	s1,s1
    panic("kfree");
  if(reference_count[idx_rc((uint64)pa)] > 1){
    800000a0:	00249713          	slli	a4,s1,0x2
    800000a4:	00009797          	auipc	a5,0x9
    800000a8:	fac78793          	addi	a5,a5,-84 # 80009050 <reference_count>
    800000ac:	97ba                	add	a5,a5,a4
    800000ae:	4398                	lw	a4,0(a5)
    800000b0:	4785                	li	a5,1
    800000b2:	06e7c363          	blt	a5,a4,80000118 <kfree+0xac>
      //printf("kfree,pa = %p,rc = %d\n",(uint64)pa,reference_count[idx_rc((uint64)pa)]);
      sub_rc((uint64)pa);
      return;
  }
  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800000b6:	6605                	lui	a2,0x1
    800000b8:	4585                	li	a1,1
    800000ba:	00000097          	auipc	ra,0x0
    800000be:	190080e7          	jalr	400(ra) # 8000024a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    800000c2:	00009997          	auipc	s3,0x9
    800000c6:	f6e98993          	addi	s3,s3,-146 # 80009030 <kmem>
    800000ca:	854e                	mv	a0,s3
    800000cc:	00006097          	auipc	ra,0x6
    800000d0:	1c6080e7          	jalr	454(ra) # 80006292 <acquire>
  r->next = kmem.freelist;
    800000d4:	0189b783          	ld	a5,24(s3)
    800000d8:	00f93023          	sd	a5,0(s2)
  kmem.freelist = r;
    800000dc:	0129bc23          	sd	s2,24(s3)
  release(&kmem.lock);
    800000e0:	854e                	mv	a0,s3
    800000e2:	00006097          	auipc	ra,0x6
    800000e6:	264080e7          	jalr	612(ra) # 80006346 <release>
  reference_count[idx_rc((uint64)pa)] = 0;
    800000ea:	048a                	slli	s1,s1,0x2
    800000ec:	00009797          	auipc	a5,0x9
    800000f0:	f6478793          	addi	a5,a5,-156 # 80009050 <reference_count>
    800000f4:	94be                	add	s1,s1,a5
    800000f6:	0004a023          	sw	zero,0(s1) # ffffffff80000000 <end+0xfffffffefffb9dc0>
}
    800000fa:	70a2                	ld	ra,40(sp)
    800000fc:	7402                	ld	s0,32(sp)
    800000fe:	64e2                	ld	s1,24(sp)
    80000100:	6942                	ld	s2,16(sp)
    80000102:	69a2                	ld	s3,8(sp)
    80000104:	6145                	addi	sp,sp,48
    80000106:	8082                	ret
    panic("kfree");
    80000108:	00008517          	auipc	a0,0x8
    8000010c:	f0850513          	addi	a0,a0,-248 # 80008010 <etext+0x10>
    80000110:	00006097          	auipc	ra,0x6
    80000114:	c38080e7          	jalr	-968(ra) # 80005d48 <panic>
      sub_rc((uint64)pa);
    80000118:	00000097          	auipc	ra,0x0
    8000011c:	f2c080e7          	jalr	-212(ra) # 80000044 <sub_rc>
      return;
    80000120:	bfe9                	j	800000fa <kfree+0x8e>

0000000080000122 <freerange>:
{
    80000122:	7179                	addi	sp,sp,-48
    80000124:	f406                	sd	ra,40(sp)
    80000126:	f022                	sd	s0,32(sp)
    80000128:	ec26                	sd	s1,24(sp)
    8000012a:	e84a                	sd	s2,16(sp)
    8000012c:	e44e                	sd	s3,8(sp)
    8000012e:	e052                	sd	s4,0(sp)
    80000130:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000132:	6785                	lui	a5,0x1
    80000134:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000138:	94aa                	add	s1,s1,a0
    8000013a:	757d                	lui	a0,0xfffff
    8000013c:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000013e:	94be                	add	s1,s1,a5
    80000140:	0095ee63          	bltu	a1,s1,8000015c <freerange+0x3a>
    80000144:	892e                	mv	s2,a1
    kfree(p);
    80000146:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000148:	6985                	lui	s3,0x1
    kfree(p);
    8000014a:	01448533          	add	a0,s1,s4
    8000014e:	00000097          	auipc	ra,0x0
    80000152:	f1e080e7          	jalr	-226(ra) # 8000006c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000156:	94ce                	add	s1,s1,s3
    80000158:	fe9979e3          	bgeu	s2,s1,8000014a <freerange+0x28>
}
    8000015c:	70a2                	ld	ra,40(sp)
    8000015e:	7402                	ld	s0,32(sp)
    80000160:	64e2                	ld	s1,24(sp)
    80000162:	6942                	ld	s2,16(sp)
    80000164:	69a2                	ld	s3,8(sp)
    80000166:	6a02                	ld	s4,0(sp)
    80000168:	6145                	addi	sp,sp,48
    8000016a:	8082                	ret

000000008000016c <kinit>:
{
    8000016c:	1141                	addi	sp,sp,-16
    8000016e:	e406                	sd	ra,8(sp)
    80000170:	e022                	sd	s0,0(sp)
    80000172:	0800                	addi	s0,sp,16
    printf("idx max = %d",(PHYSTOP - 0X80000000) / PGSIZE);
    80000174:	65a1                	lui	a1,0x8
    80000176:	00008517          	auipc	a0,0x8
    8000017a:	ea250513          	addi	a0,a0,-350 # 80008018 <etext+0x18>
    8000017e:	00006097          	auipc	ra,0x6
    80000182:	c14080e7          	jalr	-1004(ra) # 80005d92 <printf>
  initlock(&kmem.lock, "kmem");
    80000186:	00008597          	auipc	a1,0x8
    8000018a:	ea258593          	addi	a1,a1,-350 # 80008028 <etext+0x28>
    8000018e:	00009517          	auipc	a0,0x9
    80000192:	ea250513          	addi	a0,a0,-350 # 80009030 <kmem>
    80000196:	00006097          	auipc	ra,0x6
    8000019a:	06c080e7          	jalr	108(ra) # 80006202 <initlock>
  memset(reference_count,0,sizeof(reference_count));
    8000019e:	00020637          	lui	a2,0x20
    800001a2:	4581                	li	a1,0
    800001a4:	00009517          	auipc	a0,0x9
    800001a8:	eac50513          	addi	a0,a0,-340 # 80009050 <reference_count>
    800001ac:	00000097          	auipc	ra,0x0
    800001b0:	09e080e7          	jalr	158(ra) # 8000024a <memset>
  freerange(end, (void*)PHYSTOP);
    800001b4:	45c5                	li	a1,17
    800001b6:	05ee                	slli	a1,a1,0x1b
    800001b8:	00046517          	auipc	a0,0x46
    800001bc:	08850513          	addi	a0,a0,136 # 80046240 <end>
    800001c0:	00000097          	auipc	ra,0x0
    800001c4:	f62080e7          	jalr	-158(ra) # 80000122 <freerange>
}
    800001c8:	60a2                	ld	ra,8(sp)
    800001ca:	6402                	ld	s0,0(sp)
    800001cc:	0141                	addi	sp,sp,16
    800001ce:	8082                	ret

00000000800001d0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800001d0:	1101                	addi	sp,sp,-32
    800001d2:	ec06                	sd	ra,24(sp)
    800001d4:	e822                	sd	s0,16(sp)
    800001d6:	e426                	sd	s1,8(sp)
    800001d8:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    800001da:	00009497          	auipc	s1,0x9
    800001de:	e5648493          	addi	s1,s1,-426 # 80009030 <kmem>
    800001e2:	8526                	mv	a0,s1
    800001e4:	00006097          	auipc	ra,0x6
    800001e8:	0ae080e7          	jalr	174(ra) # 80006292 <acquire>
  r = kmem.freelist;
    800001ec:	6c84                	ld	s1,24(s1)
  if(r)
    800001ee:	c4a9                	beqz	s1,80000238 <kalloc+0x68>
    kmem.freelist = r->next;
    800001f0:	609c                	ld	a5,0(s1)
    800001f2:	00009517          	auipc	a0,0x9
    800001f6:	e3e50513          	addi	a0,a0,-450 # 80009030 <kmem>
    800001fa:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    800001fc:	00006097          	auipc	ra,0x6
    80000200:	14a080e7          	jalr	330(ra) # 80006346 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000204:	6605                	lui	a2,0x1
    80000206:	4595                	li	a1,5
    80000208:	8526                	mv	a0,s1
    8000020a:	00000097          	auipc	ra,0x0
    8000020e:	040080e7          	jalr	64(ra) # 8000024a <memset>
    return (pa - 0x80000000) / PGSIZE;
    80000212:	800007b7          	lui	a5,0x80000
    80000216:	97a6                	add	a5,a5,s1
    80000218:	83b1                	srli	a5,a5,0xc

  //printf("kalloc,pa = %p,idx = %d\n",(uint64)r,idx_rc((uint64)r));
  if(r)
    reference_count[idx_rc((uint64)r)] = 1;
    8000021a:	2781                	sext.w	a5,a5
    8000021c:	078a                	slli	a5,a5,0x2
    8000021e:	00009717          	auipc	a4,0x9
    80000222:	e3270713          	addi	a4,a4,-462 # 80009050 <reference_count>
    80000226:	97ba                	add	a5,a5,a4
    80000228:	4705                	li	a4,1
    8000022a:	c398                	sw	a4,0(a5)
  return (void*)r;
}
    8000022c:	8526                	mv	a0,s1
    8000022e:	60e2                	ld	ra,24(sp)
    80000230:	6442                	ld	s0,16(sp)
    80000232:	64a2                	ld	s1,8(sp)
    80000234:	6105                	addi	sp,sp,32
    80000236:	8082                	ret
  release(&kmem.lock);
    80000238:	00009517          	auipc	a0,0x9
    8000023c:	df850513          	addi	a0,a0,-520 # 80009030 <kmem>
    80000240:	00006097          	auipc	ra,0x6
    80000244:	106080e7          	jalr	262(ra) # 80006346 <release>
  if(r)
    80000248:	b7d5                	j	8000022c <kalloc+0x5c>

000000008000024a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000250:	ce09                	beqz	a2,8000026a <memset+0x20>
    80000252:	87aa                	mv	a5,a0
    80000254:	fff6071b          	addiw	a4,a2,-1
    80000258:	1702                	slli	a4,a4,0x20
    8000025a:	9301                	srli	a4,a4,0x20
    8000025c:	0705                	addi	a4,a4,1
    8000025e:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000260:	00b78023          	sb	a1,0(a5) # ffffffff80000000 <end+0xfffffffefffb9dc0>
  for(i = 0; i < n; i++){
    80000264:	0785                	addi	a5,a5,1
    80000266:	fee79de3          	bne	a5,a4,80000260 <memset+0x16>
  }
  return dst;
}
    8000026a:	6422                	ld	s0,8(sp)
    8000026c:	0141                	addi	sp,sp,16
    8000026e:	8082                	ret

0000000080000270 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000270:	1141                	addi	sp,sp,-16
    80000272:	e422                	sd	s0,8(sp)
    80000274:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000276:	ca05                	beqz	a2,800002a6 <memcmp+0x36>
    80000278:	fff6069b          	addiw	a3,a2,-1
    8000027c:	1682                	slli	a3,a3,0x20
    8000027e:	9281                	srli	a3,a3,0x20
    80000280:	0685                	addi	a3,a3,1
    80000282:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000284:	00054783          	lbu	a5,0(a0)
    80000288:	0005c703          	lbu	a4,0(a1)
    8000028c:	00e79863          	bne	a5,a4,8000029c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000290:	0505                	addi	a0,a0,1
    80000292:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000294:	fed518e3          	bne	a0,a3,80000284 <memcmp+0x14>
  }

  return 0;
    80000298:	4501                	li	a0,0
    8000029a:	a019                	j	800002a0 <memcmp+0x30>
      return *s1 - *s2;
    8000029c:	40e7853b          	subw	a0,a5,a4
}
    800002a0:	6422                	ld	s0,8(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret
  return 0;
    800002a6:	4501                	li	a0,0
    800002a8:	bfe5                	j	800002a0 <memcmp+0x30>

00000000800002aa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002aa:	1141                	addi	sp,sp,-16
    800002ac:	e422                	sd	s0,8(sp)
    800002ae:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002b0:	ca0d                	beqz	a2,800002e2 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002b2:	00a5f963          	bgeu	a1,a0,800002c4 <memmove+0x1a>
    800002b6:	02061693          	slli	a3,a2,0x20
    800002ba:	9281                	srli	a3,a3,0x20
    800002bc:	00d58733          	add	a4,a1,a3
    800002c0:	02e56463          	bltu	a0,a4,800002e8 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800002c4:	fff6079b          	addiw	a5,a2,-1
    800002c8:	1782                	slli	a5,a5,0x20
    800002ca:	9381                	srli	a5,a5,0x20
    800002cc:	0785                	addi	a5,a5,1
    800002ce:	97ae                	add	a5,a5,a1
    800002d0:	872a                	mv	a4,a0
      *d++ = *s++;
    800002d2:	0585                	addi	a1,a1,1
    800002d4:	0705                	addi	a4,a4,1
    800002d6:	fff5c683          	lbu	a3,-1(a1)
    800002da:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800002de:	fef59ae3          	bne	a1,a5,800002d2 <memmove+0x28>

  return dst;
}
    800002e2:	6422                	ld	s0,8(sp)
    800002e4:	0141                	addi	sp,sp,16
    800002e6:	8082                	ret
    d += n;
    800002e8:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800002ea:	fff6079b          	addiw	a5,a2,-1
    800002ee:	1782                	slli	a5,a5,0x20
    800002f0:	9381                	srli	a5,a5,0x20
    800002f2:	fff7c793          	not	a5,a5
    800002f6:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800002f8:	177d                	addi	a4,a4,-1
    800002fa:	16fd                	addi	a3,a3,-1
    800002fc:	00074603          	lbu	a2,0(a4)
    80000300:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000304:	fef71ae3          	bne	a4,a5,800002f8 <memmove+0x4e>
    80000308:	bfe9                	j	800002e2 <memmove+0x38>

000000008000030a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000030a:	1141                	addi	sp,sp,-16
    8000030c:	e406                	sd	ra,8(sp)
    8000030e:	e022                	sd	s0,0(sp)
    80000310:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000312:	00000097          	auipc	ra,0x0
    80000316:	f98080e7          	jalr	-104(ra) # 800002aa <memmove>
}
    8000031a:	60a2                	ld	ra,8(sp)
    8000031c:	6402                	ld	s0,0(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret

0000000080000322 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000322:	1141                	addi	sp,sp,-16
    80000324:	e422                	sd	s0,8(sp)
    80000326:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000328:	ce11                	beqz	a2,80000344 <strncmp+0x22>
    8000032a:	00054783          	lbu	a5,0(a0)
    8000032e:	cf89                	beqz	a5,80000348 <strncmp+0x26>
    80000330:	0005c703          	lbu	a4,0(a1)
    80000334:	00f71a63          	bne	a4,a5,80000348 <strncmp+0x26>
    n--, p++, q++;
    80000338:	367d                	addiw	a2,a2,-1
    8000033a:	0505                	addi	a0,a0,1
    8000033c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000033e:	f675                	bnez	a2,8000032a <strncmp+0x8>
  if(n == 0)
    return 0;
    80000340:	4501                	li	a0,0
    80000342:	a809                	j	80000354 <strncmp+0x32>
    80000344:	4501                	li	a0,0
    80000346:	a039                	j	80000354 <strncmp+0x32>
  if(n == 0)
    80000348:	ca09                	beqz	a2,8000035a <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000034a:	00054503          	lbu	a0,0(a0)
    8000034e:	0005c783          	lbu	a5,0(a1)
    80000352:	9d1d                	subw	a0,a0,a5
}
    80000354:	6422                	ld	s0,8(sp)
    80000356:	0141                	addi	sp,sp,16
    80000358:	8082                	ret
    return 0;
    8000035a:	4501                	li	a0,0
    8000035c:	bfe5                	j	80000354 <strncmp+0x32>

000000008000035e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000035e:	1141                	addi	sp,sp,-16
    80000360:	e422                	sd	s0,8(sp)
    80000362:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000364:	872a                	mv	a4,a0
    80000366:	8832                	mv	a6,a2
    80000368:	367d                	addiw	a2,a2,-1
    8000036a:	01005963          	blez	a6,8000037c <strncpy+0x1e>
    8000036e:	0705                	addi	a4,a4,1
    80000370:	0005c783          	lbu	a5,0(a1)
    80000374:	fef70fa3          	sb	a5,-1(a4)
    80000378:	0585                	addi	a1,a1,1
    8000037a:	f7f5                	bnez	a5,80000366 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000037c:	00c05d63          	blez	a2,80000396 <strncpy+0x38>
    80000380:	86ba                	mv	a3,a4
    *s++ = 0;
    80000382:	0685                	addi	a3,a3,1
    80000384:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000388:	fff6c793          	not	a5,a3
    8000038c:	9fb9                	addw	a5,a5,a4
    8000038e:	010787bb          	addw	a5,a5,a6
    80000392:	fef048e3          	bgtz	a5,80000382 <strncpy+0x24>
  return os;
}
    80000396:	6422                	ld	s0,8(sp)
    80000398:	0141                	addi	sp,sp,16
    8000039a:	8082                	ret

000000008000039c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000039c:	1141                	addi	sp,sp,-16
    8000039e:	e422                	sd	s0,8(sp)
    800003a0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003a2:	02c05363          	blez	a2,800003c8 <safestrcpy+0x2c>
    800003a6:	fff6069b          	addiw	a3,a2,-1
    800003aa:	1682                	slli	a3,a3,0x20
    800003ac:	9281                	srli	a3,a3,0x20
    800003ae:	96ae                	add	a3,a3,a1
    800003b0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003b2:	00d58963          	beq	a1,a3,800003c4 <safestrcpy+0x28>
    800003b6:	0585                	addi	a1,a1,1
    800003b8:	0785                	addi	a5,a5,1
    800003ba:	fff5c703          	lbu	a4,-1(a1)
    800003be:	fee78fa3          	sb	a4,-1(a5)
    800003c2:	fb65                	bnez	a4,800003b2 <safestrcpy+0x16>
    ;
  *s = 0;
    800003c4:	00078023          	sb	zero,0(a5)
  return os;
}
    800003c8:	6422                	ld	s0,8(sp)
    800003ca:	0141                	addi	sp,sp,16
    800003cc:	8082                	ret

00000000800003ce <strlen>:

int
strlen(const char *s)
{
    800003ce:	1141                	addi	sp,sp,-16
    800003d0:	e422                	sd	s0,8(sp)
    800003d2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800003d4:	00054783          	lbu	a5,0(a0)
    800003d8:	cf91                	beqz	a5,800003f4 <strlen+0x26>
    800003da:	0505                	addi	a0,a0,1
    800003dc:	87aa                	mv	a5,a0
    800003de:	4685                	li	a3,1
    800003e0:	9e89                	subw	a3,a3,a0
    800003e2:	00f6853b          	addw	a0,a3,a5
    800003e6:	0785                	addi	a5,a5,1
    800003e8:	fff7c703          	lbu	a4,-1(a5)
    800003ec:	fb7d                	bnez	a4,800003e2 <strlen+0x14>
    ;
  return n;
}
    800003ee:	6422                	ld	s0,8(sp)
    800003f0:	0141                	addi	sp,sp,16
    800003f2:	8082                	ret
  for(n = 0; s[n]; n++)
    800003f4:	4501                	li	a0,0
    800003f6:	bfe5                	j	800003ee <strlen+0x20>

00000000800003f8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800003f8:	1141                	addi	sp,sp,-16
    800003fa:	e406                	sd	ra,8(sp)
    800003fc:	e022                	sd	s0,0(sp)
    800003fe:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000400:	00001097          	auipc	ra,0x1
    80000404:	b78080e7          	jalr	-1160(ra) # 80000f78 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000408:	00009717          	auipc	a4,0x9
    8000040c:	bf870713          	addi	a4,a4,-1032 # 80009000 <started>
  if(cpuid() == 0){
    80000410:	c139                	beqz	a0,80000456 <main+0x5e>
    while(started == 0)
    80000412:	431c                	lw	a5,0(a4)
    80000414:	2781                	sext.w	a5,a5
    80000416:	dff5                	beqz	a5,80000412 <main+0x1a>
      ;
    __sync_synchronize();
    80000418:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	b5c080e7          	jalr	-1188(ra) # 80000f78 <cpuid>
    80000424:	85aa                	mv	a1,a0
    80000426:	00008517          	auipc	a0,0x8
    8000042a:	c2250513          	addi	a0,a0,-990 # 80008048 <etext+0x48>
    8000042e:	00006097          	auipc	ra,0x6
    80000432:	964080e7          	jalr	-1692(ra) # 80005d92 <printf>
    kvminithart();    // turn on paging
    80000436:	00000097          	auipc	ra,0x0
    8000043a:	0d8080e7          	jalr	216(ra) # 8000050e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000043e:	00001097          	auipc	ra,0x1
    80000442:	7b2080e7          	jalr	1970(ra) # 80001bf0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000446:	00005097          	auipc	ra,0x5
    8000044a:	dda080e7          	jalr	-550(ra) # 80005220 <plicinithart>
  }

  scheduler();        
    8000044e:	00001097          	auipc	ra,0x1
    80000452:	060080e7          	jalr	96(ra) # 800014ae <scheduler>
    consoleinit();
    80000456:	00006097          	auipc	ra,0x6
    8000045a:	804080e7          	jalr	-2044(ra) # 80005c5a <consoleinit>
    printfinit();
    8000045e:	00006097          	auipc	ra,0x6
    80000462:	b1a080e7          	jalr	-1254(ra) # 80005f78 <printfinit>
    printf("\n");
    80000466:	00008517          	auipc	a0,0x8
    8000046a:	bf250513          	addi	a0,a0,-1038 # 80008058 <etext+0x58>
    8000046e:	00006097          	auipc	ra,0x6
    80000472:	924080e7          	jalr	-1756(ra) # 80005d92 <printf>
    printf("xv6 kernel is booting\n");
    80000476:	00008517          	auipc	a0,0x8
    8000047a:	bba50513          	addi	a0,a0,-1094 # 80008030 <etext+0x30>
    8000047e:	00006097          	auipc	ra,0x6
    80000482:	914080e7          	jalr	-1772(ra) # 80005d92 <printf>
    printf("\n");
    80000486:	00008517          	auipc	a0,0x8
    8000048a:	bd250513          	addi	a0,a0,-1070 # 80008058 <etext+0x58>
    8000048e:	00006097          	auipc	ra,0x6
    80000492:	904080e7          	jalr	-1788(ra) # 80005d92 <printf>
    kinit();         // physical page allocator
    80000496:	00000097          	auipc	ra,0x0
    8000049a:	cd6080e7          	jalr	-810(ra) # 8000016c <kinit>
    kvminit();       // create kernel page table
    8000049e:	00000097          	auipc	ra,0x0
    800004a2:	344080e7          	jalr	836(ra) # 800007e2 <kvminit>
    kvminithart();   // turn on paging
    800004a6:	00000097          	auipc	ra,0x0
    800004aa:	068080e7          	jalr	104(ra) # 8000050e <kvminithart>
    procinit();      // process table
    800004ae:	00001097          	auipc	ra,0x1
    800004b2:	a1a080e7          	jalr	-1510(ra) # 80000ec8 <procinit>
    trapinit();      // trap vectors
    800004b6:	00001097          	auipc	ra,0x1
    800004ba:	712080e7          	jalr	1810(ra) # 80001bc8 <trapinit>
    trapinithart();  // install kernel trap vector
    800004be:	00001097          	auipc	ra,0x1
    800004c2:	732080e7          	jalr	1842(ra) # 80001bf0 <trapinithart>
    plicinit();      // set up interrupt controller
    800004c6:	00005097          	auipc	ra,0x5
    800004ca:	d44080e7          	jalr	-700(ra) # 8000520a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800004ce:	00005097          	auipc	ra,0x5
    800004d2:	d52080e7          	jalr	-686(ra) # 80005220 <plicinithart>
    binit();         // buffer cache
    800004d6:	00002097          	auipc	ra,0x2
    800004da:	f30080e7          	jalr	-208(ra) # 80002406 <binit>
    iinit();         // inode table
    800004de:	00002097          	auipc	ra,0x2
    800004e2:	5c0080e7          	jalr	1472(ra) # 80002a9e <iinit>
    fileinit();      // file table
    800004e6:	00003097          	auipc	ra,0x3
    800004ea:	56a080e7          	jalr	1386(ra) # 80003a50 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800004ee:	00005097          	auipc	ra,0x5
    800004f2:	e54080e7          	jalr	-428(ra) # 80005342 <virtio_disk_init>
    userinit();      // first user process
    800004f6:	00001097          	auipc	ra,0x1
    800004fa:	d86080e7          	jalr	-634(ra) # 8000127c <userinit>
    __sync_synchronize();
    800004fe:	0ff0000f          	fence
    started = 1;
    80000502:	4785                	li	a5,1
    80000504:	00009717          	auipc	a4,0x9
    80000508:	aef72e23          	sw	a5,-1284(a4) # 80009000 <started>
    8000050c:	b789                	j	8000044e <main+0x56>

000000008000050e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000050e:	1141                	addi	sp,sp,-16
    80000510:	e422                	sd	s0,8(sp)
    80000512:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000514:	00009797          	auipc	a5,0x9
    80000518:	af47b783          	ld	a5,-1292(a5) # 80009008 <kernel_pagetable>
    8000051c:	83b1                	srli	a5,a5,0xc
    8000051e:	577d                	li	a4,-1
    80000520:	177e                	slli	a4,a4,0x3f
    80000522:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000524:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000528:	12000073          	sfence.vma
  sfence_vma();
}
    8000052c:	6422                	ld	s0,8(sp)
    8000052e:	0141                	addi	sp,sp,16
    80000530:	8082                	ret

0000000080000532 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000532:	7139                	addi	sp,sp,-64
    80000534:	fc06                	sd	ra,56(sp)
    80000536:	f822                	sd	s0,48(sp)
    80000538:	f426                	sd	s1,40(sp)
    8000053a:	f04a                	sd	s2,32(sp)
    8000053c:	ec4e                	sd	s3,24(sp)
    8000053e:	e852                	sd	s4,16(sp)
    80000540:	e456                	sd	s5,8(sp)
    80000542:	e05a                	sd	s6,0(sp)
    80000544:	0080                	addi	s0,sp,64
    80000546:	84aa                	mv	s1,a0
    80000548:	89ae                	mv	s3,a1
    8000054a:	8ab2                	mv	s5,a2
  if(va >= MAXVA){
    8000054c:	57fd                	li	a5,-1
    8000054e:	83e9                	srli	a5,a5,0x1a
    80000550:	4a79                	li	s4,30
    panic("walk");
  }

  for(int level = 2; level > 0; level--) {
    80000552:	4b31                	li	s6,12
  if(va >= MAXVA){
    80000554:	04b7f263          	bgeu	a5,a1,80000598 <walk+0x66>
    panic("walk");
    80000558:	00008517          	auipc	a0,0x8
    8000055c:	b0850513          	addi	a0,a0,-1272 # 80008060 <etext+0x60>
    80000560:	00005097          	auipc	ra,0x5
    80000564:	7e8080e7          	jalr	2024(ra) # 80005d48 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000568:	060a8663          	beqz	s5,800005d4 <walk+0xa2>
    8000056c:	00000097          	auipc	ra,0x0
    80000570:	c64080e7          	jalr	-924(ra) # 800001d0 <kalloc>
    80000574:	84aa                	mv	s1,a0
    80000576:	c529                	beqz	a0,800005c0 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000578:	6605                	lui	a2,0x1
    8000057a:	4581                	li	a1,0
    8000057c:	00000097          	auipc	ra,0x0
    80000580:	cce080e7          	jalr	-818(ra) # 8000024a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000584:	00c4d793          	srli	a5,s1,0xc
    80000588:	07aa                	slli	a5,a5,0xa
    8000058a:	0017e793          	ori	a5,a5,1
    8000058e:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000592:	3a5d                	addiw	s4,s4,-9
    80000594:	036a0063          	beq	s4,s6,800005b4 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000598:	0149d933          	srl	s2,s3,s4
    8000059c:	1ff97913          	andi	s2,s2,511
    800005a0:	090e                	slli	s2,s2,0x3
    800005a2:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005a4:	00093483          	ld	s1,0(s2)
    800005a8:	0014f793          	andi	a5,s1,1
    800005ac:	dfd5                	beqz	a5,80000568 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005ae:	80a9                	srli	s1,s1,0xa
    800005b0:	04b2                	slli	s1,s1,0xc
    800005b2:	b7c5                	j	80000592 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800005b4:	00c9d513          	srli	a0,s3,0xc
    800005b8:	1ff57513          	andi	a0,a0,511
    800005bc:	050e                	slli	a0,a0,0x3
    800005be:	9526                	add	a0,a0,s1
}
    800005c0:	70e2                	ld	ra,56(sp)
    800005c2:	7442                	ld	s0,48(sp)
    800005c4:	74a2                	ld	s1,40(sp)
    800005c6:	7902                	ld	s2,32(sp)
    800005c8:	69e2                	ld	s3,24(sp)
    800005ca:	6a42                	ld	s4,16(sp)
    800005cc:	6aa2                	ld	s5,8(sp)
    800005ce:	6b02                	ld	s6,0(sp)
    800005d0:	6121                	addi	sp,sp,64
    800005d2:	8082                	ret
        return 0;
    800005d4:	4501                	li	a0,0
    800005d6:	b7ed                	j	800005c0 <walk+0x8e>

00000000800005d8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800005d8:	57fd                	li	a5,-1
    800005da:	83e9                	srli	a5,a5,0x1a
    800005dc:	00b7f463          	bgeu	a5,a1,800005e4 <walkaddr+0xc>
    return 0;
    800005e0:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800005e2:	8082                	ret
{
    800005e4:	1141                	addi	sp,sp,-16
    800005e6:	e406                	sd	ra,8(sp)
    800005e8:	e022                	sd	s0,0(sp)
    800005ea:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800005ec:	4601                	li	a2,0
    800005ee:	00000097          	auipc	ra,0x0
    800005f2:	f44080e7          	jalr	-188(ra) # 80000532 <walk>
  if(pte == 0)
    800005f6:	c105                	beqz	a0,80000616 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800005f8:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800005fa:	0117f693          	andi	a3,a5,17
    800005fe:	4745                	li	a4,17
    return 0;
    80000600:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000602:	00e68663          	beq	a3,a4,8000060e <walkaddr+0x36>
}
    80000606:	60a2                	ld	ra,8(sp)
    80000608:	6402                	ld	s0,0(sp)
    8000060a:	0141                	addi	sp,sp,16
    8000060c:	8082                	ret
  pa = PTE2PA(*pte);
    8000060e:	00a7d513          	srli	a0,a5,0xa
    80000612:	0532                	slli	a0,a0,0xc
  return pa;
    80000614:	bfcd                	j	80000606 <walkaddr+0x2e>
    return 0;
    80000616:	4501                	li	a0,0
    80000618:	b7fd                	j	80000606 <walkaddr+0x2e>

000000008000061a <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000061a:	715d                	addi	sp,sp,-80
    8000061c:	e486                	sd	ra,72(sp)
    8000061e:	e0a2                	sd	s0,64(sp)
    80000620:	fc26                	sd	s1,56(sp)
    80000622:	f84a                	sd	s2,48(sp)
    80000624:	f44e                	sd	s3,40(sp)
    80000626:	f052                	sd	s4,32(sp)
    80000628:	ec56                	sd	s5,24(sp)
    8000062a:	e85a                	sd	s6,16(sp)
    8000062c:	e45e                	sd	s7,8(sp)
    8000062e:	e062                	sd	s8,0(sp)
    80000630:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000632:	c20d                	beqz	a2,80000654 <mappages+0x3a>
    80000634:	8aaa                	mv	s5,a0
    80000636:	8c2e                	mv	s8,a1
    80000638:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000063a:	77fd                	lui	a5,0xfffff
    8000063c:	00f5f9b3          	and	s3,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000640:	fff58a13          	addi	s4,a1,-1
    80000644:	9652                	add	a2,a2,s4
    80000646:	00f67a33          	and	s4,a2,a5
  a = PGROUNDDOWN(va);
    8000064a:	894e                	mv	s2,s3
    8000064c:	413689b3          	sub	s3,a3,s3
      panic("mappages: remap");
    }
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000650:	6b85                	lui	s7,0x1
    80000652:	a83d                	j	80000690 <mappages+0x76>
    panic("mappages: size");
    80000654:	00008517          	auipc	a0,0x8
    80000658:	a1450513          	addi	a0,a0,-1516 # 80008068 <etext+0x68>
    8000065c:	00005097          	auipc	ra,0x5
    80000660:	6ec080e7          	jalr	1772(ra) # 80005d48 <panic>
        printf("va = %p,pa = %p,oripa = %p\n",va,pa,PTE2PA(*pte));
    80000664:	83a9                	srli	a5,a5,0xa
    80000666:	00c79693          	slli	a3,a5,0xc
    8000066a:	8626                	mv	a2,s1
    8000066c:	85e2                	mv	a1,s8
    8000066e:	00008517          	auipc	a0,0x8
    80000672:	a0a50513          	addi	a0,a0,-1526 # 80008078 <etext+0x78>
    80000676:	00005097          	auipc	ra,0x5
    8000067a:	71c080e7          	jalr	1820(ra) # 80005d92 <printf>
      panic("mappages: remap");
    8000067e:	00008517          	auipc	a0,0x8
    80000682:	a1a50513          	addi	a0,a0,-1510 # 80008098 <etext+0x98>
    80000686:	00005097          	auipc	ra,0x5
    8000068a:	6c2080e7          	jalr	1730(ra) # 80005d48 <panic>
    a += PGSIZE;
    8000068e:	995e                	add	s2,s2,s7
  for(;;){
    80000690:	012984b3          	add	s1,s3,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000694:	4605                	li	a2,1
    80000696:	85ca                	mv	a1,s2
    80000698:	8556                	mv	a0,s5
    8000069a:	00000097          	auipc	ra,0x0
    8000069e:	e98080e7          	jalr	-360(ra) # 80000532 <walk>
    800006a2:	c105                	beqz	a0,800006c2 <mappages+0xa8>
    if(*pte & PTE_V){
    800006a4:	611c                	ld	a5,0(a0)
    800006a6:	0017f713          	andi	a4,a5,1
    800006aa:	ff4d                	bnez	a4,80000664 <mappages+0x4a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006ac:	80b1                	srli	s1,s1,0xc
    800006ae:	04aa                	slli	s1,s1,0xa
    800006b0:	0164e4b3          	or	s1,s1,s6
    800006b4:	0014e493          	ori	s1,s1,1
    800006b8:	e104                	sd	s1,0(a0)
    if(a == last)
    800006ba:	fd491ae3          	bne	s2,s4,8000068e <mappages+0x74>
    pa += PGSIZE;
  }
  return 0;
    800006be:	4501                	li	a0,0
    800006c0:	a011                	j	800006c4 <mappages+0xaa>
      return -1;
    800006c2:	557d                	li	a0,-1
}
    800006c4:	60a6                	ld	ra,72(sp)
    800006c6:	6406                	ld	s0,64(sp)
    800006c8:	74e2                	ld	s1,56(sp)
    800006ca:	7942                	ld	s2,48(sp)
    800006cc:	79a2                	ld	s3,40(sp)
    800006ce:	7a02                	ld	s4,32(sp)
    800006d0:	6ae2                	ld	s5,24(sp)
    800006d2:	6b42                	ld	s6,16(sp)
    800006d4:	6ba2                	ld	s7,8(sp)
    800006d6:	6c02                	ld	s8,0(sp)
    800006d8:	6161                	addi	sp,sp,80
    800006da:	8082                	ret

00000000800006dc <kvmmap>:
{
    800006dc:	1141                	addi	sp,sp,-16
    800006de:	e406                	sd	ra,8(sp)
    800006e0:	e022                	sd	s0,0(sp)
    800006e2:	0800                	addi	s0,sp,16
    800006e4:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800006e6:	86b2                	mv	a3,a2
    800006e8:	863e                	mv	a2,a5
    800006ea:	00000097          	auipc	ra,0x0
    800006ee:	f30080e7          	jalr	-208(ra) # 8000061a <mappages>
    800006f2:	e509                	bnez	a0,800006fc <kvmmap+0x20>
}
    800006f4:	60a2                	ld	ra,8(sp)
    800006f6:	6402                	ld	s0,0(sp)
    800006f8:	0141                	addi	sp,sp,16
    800006fa:	8082                	ret
    panic("kvmmap");
    800006fc:	00008517          	auipc	a0,0x8
    80000700:	9ac50513          	addi	a0,a0,-1620 # 800080a8 <etext+0xa8>
    80000704:	00005097          	auipc	ra,0x5
    80000708:	644080e7          	jalr	1604(ra) # 80005d48 <panic>

000000008000070c <kvmmake>:
{
    8000070c:	1101                	addi	sp,sp,-32
    8000070e:	ec06                	sd	ra,24(sp)
    80000710:	e822                	sd	s0,16(sp)
    80000712:	e426                	sd	s1,8(sp)
    80000714:	e04a                	sd	s2,0(sp)
    80000716:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	ab8080e7          	jalr	-1352(ra) # 800001d0 <kalloc>
    80000720:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000722:	6605                	lui	a2,0x1
    80000724:	4581                	li	a1,0
    80000726:	00000097          	auipc	ra,0x0
    8000072a:	b24080e7          	jalr	-1244(ra) # 8000024a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000072e:	4719                	li	a4,6
    80000730:	6685                	lui	a3,0x1
    80000732:	10000637          	lui	a2,0x10000
    80000736:	100005b7          	lui	a1,0x10000
    8000073a:	8526                	mv	a0,s1
    8000073c:	00000097          	auipc	ra,0x0
    80000740:	fa0080e7          	jalr	-96(ra) # 800006dc <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000744:	4719                	li	a4,6
    80000746:	6685                	lui	a3,0x1
    80000748:	10001637          	lui	a2,0x10001
    8000074c:	100015b7          	lui	a1,0x10001
    80000750:	8526                	mv	a0,s1
    80000752:	00000097          	auipc	ra,0x0
    80000756:	f8a080e7          	jalr	-118(ra) # 800006dc <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000075a:	4719                	li	a4,6
    8000075c:	004006b7          	lui	a3,0x400
    80000760:	0c000637          	lui	a2,0xc000
    80000764:	0c0005b7          	lui	a1,0xc000
    80000768:	8526                	mv	a0,s1
    8000076a:	00000097          	auipc	ra,0x0
    8000076e:	f72080e7          	jalr	-142(ra) # 800006dc <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000772:	00008917          	auipc	s2,0x8
    80000776:	88e90913          	addi	s2,s2,-1906 # 80008000 <etext>
    8000077a:	4729                	li	a4,10
    8000077c:	80008697          	auipc	a3,0x80008
    80000780:	88468693          	addi	a3,a3,-1916 # 8000 <_entry-0x7fff8000>
    80000784:	4605                	li	a2,1
    80000786:	067e                	slli	a2,a2,0x1f
    80000788:	85b2                	mv	a1,a2
    8000078a:	8526                	mv	a0,s1
    8000078c:	00000097          	auipc	ra,0x0
    80000790:	f50080e7          	jalr	-176(ra) # 800006dc <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000794:	4719                	li	a4,6
    80000796:	46c5                	li	a3,17
    80000798:	06ee                	slli	a3,a3,0x1b
    8000079a:	412686b3          	sub	a3,a3,s2
    8000079e:	864a                	mv	a2,s2
    800007a0:	85ca                	mv	a1,s2
    800007a2:	8526                	mv	a0,s1
    800007a4:	00000097          	auipc	ra,0x0
    800007a8:	f38080e7          	jalr	-200(ra) # 800006dc <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007ac:	4729                	li	a4,10
    800007ae:	6685                	lui	a3,0x1
    800007b0:	00007617          	auipc	a2,0x7
    800007b4:	85060613          	addi	a2,a2,-1968 # 80007000 <_trampoline>
    800007b8:	040005b7          	lui	a1,0x4000
    800007bc:	15fd                	addi	a1,a1,-1
    800007be:	05b2                	slli	a1,a1,0xc
    800007c0:	8526                	mv	a0,s1
    800007c2:	00000097          	auipc	ra,0x0
    800007c6:	f1a080e7          	jalr	-230(ra) # 800006dc <kvmmap>
  proc_mapstacks(kpgtbl);
    800007ca:	8526                	mv	a0,s1
    800007cc:	00000097          	auipc	ra,0x0
    800007d0:	666080e7          	jalr	1638(ra) # 80000e32 <proc_mapstacks>
}
    800007d4:	8526                	mv	a0,s1
    800007d6:	60e2                	ld	ra,24(sp)
    800007d8:	6442                	ld	s0,16(sp)
    800007da:	64a2                	ld	s1,8(sp)
    800007dc:	6902                	ld	s2,0(sp)
    800007de:	6105                	addi	sp,sp,32
    800007e0:	8082                	ret

00000000800007e2 <kvminit>:
{
    800007e2:	1141                	addi	sp,sp,-16
    800007e4:	e406                	sd	ra,8(sp)
    800007e6:	e022                	sd	s0,0(sp)
    800007e8:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	f22080e7          	jalr	-222(ra) # 8000070c <kvmmake>
    800007f2:	00009797          	auipc	a5,0x9
    800007f6:	80a7bb23          	sd	a0,-2026(a5) # 80009008 <kernel_pagetable>
}
    800007fa:	60a2                	ld	ra,8(sp)
    800007fc:	6402                	ld	s0,0(sp)
    800007fe:	0141                	addi	sp,sp,16
    80000800:	8082                	ret

0000000080000802 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000802:	715d                	addi	sp,sp,-80
    80000804:	e486                	sd	ra,72(sp)
    80000806:	e0a2                	sd	s0,64(sp)
    80000808:	fc26                	sd	s1,56(sp)
    8000080a:	f84a                	sd	s2,48(sp)
    8000080c:	f44e                	sd	s3,40(sp)
    8000080e:	f052                	sd	s4,32(sp)
    80000810:	ec56                	sd	s5,24(sp)
    80000812:	e85a                	sd	s6,16(sp)
    80000814:	e45e                	sd	s7,8(sp)
    80000816:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000818:	03459793          	slli	a5,a1,0x34
    8000081c:	e795                	bnez	a5,80000848 <uvmunmap+0x46>
    8000081e:	8a2a                	mv	s4,a0
    80000820:	892e                	mv	s2,a1
    80000822:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000824:	0632                	slli	a2,a2,0xc
    80000826:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000082a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000082c:	6b05                	lui	s6,0x1
    8000082e:	0735e863          	bltu	a1,s3,8000089e <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000832:	60a6                	ld	ra,72(sp)
    80000834:	6406                	ld	s0,64(sp)
    80000836:	74e2                	ld	s1,56(sp)
    80000838:	7942                	ld	s2,48(sp)
    8000083a:	79a2                	ld	s3,40(sp)
    8000083c:	7a02                	ld	s4,32(sp)
    8000083e:	6ae2                	ld	s5,24(sp)
    80000840:	6b42                	ld	s6,16(sp)
    80000842:	6ba2                	ld	s7,8(sp)
    80000844:	6161                	addi	sp,sp,80
    80000846:	8082                	ret
    panic("uvmunmap: not aligned");
    80000848:	00008517          	auipc	a0,0x8
    8000084c:	86850513          	addi	a0,a0,-1944 # 800080b0 <etext+0xb0>
    80000850:	00005097          	auipc	ra,0x5
    80000854:	4f8080e7          	jalr	1272(ra) # 80005d48 <panic>
      panic("uvmunmap: walk");
    80000858:	00008517          	auipc	a0,0x8
    8000085c:	87050513          	addi	a0,a0,-1936 # 800080c8 <etext+0xc8>
    80000860:	00005097          	auipc	ra,0x5
    80000864:	4e8080e7          	jalr	1256(ra) # 80005d48 <panic>
      panic("uvmunmap: not mapped");
    80000868:	00008517          	auipc	a0,0x8
    8000086c:	87050513          	addi	a0,a0,-1936 # 800080d8 <etext+0xd8>
    80000870:	00005097          	auipc	ra,0x5
    80000874:	4d8080e7          	jalr	1240(ra) # 80005d48 <panic>
      panic("uvmunmap: not a leaf");
    80000878:	00008517          	auipc	a0,0x8
    8000087c:	87850513          	addi	a0,a0,-1928 # 800080f0 <etext+0xf0>
    80000880:	00005097          	auipc	ra,0x5
    80000884:	4c8080e7          	jalr	1224(ra) # 80005d48 <panic>
      uint64 pa = PTE2PA(*pte);
    80000888:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000088a:	0532                	slli	a0,a0,0xc
    8000088c:	fffff097          	auipc	ra,0xfffff
    80000890:	7e0080e7          	jalr	2016(ra) # 8000006c <kfree>
    *pte = 0;
    80000894:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000898:	995a                	add	s2,s2,s6
    8000089a:	f9397ce3          	bgeu	s2,s3,80000832 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000089e:	4601                	li	a2,0
    800008a0:	85ca                	mv	a1,s2
    800008a2:	8552                	mv	a0,s4
    800008a4:	00000097          	auipc	ra,0x0
    800008a8:	c8e080e7          	jalr	-882(ra) # 80000532 <walk>
    800008ac:	84aa                	mv	s1,a0
    800008ae:	d54d                	beqz	a0,80000858 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800008b0:	6108                	ld	a0,0(a0)
    800008b2:	00157793          	andi	a5,a0,1
    800008b6:	dbcd                	beqz	a5,80000868 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800008b8:	3ff57793          	andi	a5,a0,1023
    800008bc:	fb778ee3          	beq	a5,s7,80000878 <uvmunmap+0x76>
    if(do_free){
    800008c0:	fc0a8ae3          	beqz	s5,80000894 <uvmunmap+0x92>
    800008c4:	b7d1                	j	80000888 <uvmunmap+0x86>

00000000800008c6 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008c6:	1101                	addi	sp,sp,-32
    800008c8:	ec06                	sd	ra,24(sp)
    800008ca:	e822                	sd	s0,16(sp)
    800008cc:	e426                	sd	s1,8(sp)
    800008ce:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800008d0:	00000097          	auipc	ra,0x0
    800008d4:	900080e7          	jalr	-1792(ra) # 800001d0 <kalloc>
    800008d8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800008da:	c519                	beqz	a0,800008e8 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800008dc:	6605                	lui	a2,0x1
    800008de:	4581                	li	a1,0
    800008e0:	00000097          	auipc	ra,0x0
    800008e4:	96a080e7          	jalr	-1686(ra) # 8000024a <memset>
  return pagetable;
}
    800008e8:	8526                	mv	a0,s1
    800008ea:	60e2                	ld	ra,24(sp)
    800008ec:	6442                	ld	s0,16(sp)
    800008ee:	64a2                	ld	s1,8(sp)
    800008f0:	6105                	addi	sp,sp,32
    800008f2:	8082                	ret

00000000800008f4 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800008f4:	7179                	addi	sp,sp,-48
    800008f6:	f406                	sd	ra,40(sp)
    800008f8:	f022                	sd	s0,32(sp)
    800008fa:	ec26                	sd	s1,24(sp)
    800008fc:	e84a                	sd	s2,16(sp)
    800008fe:	e44e                	sd	s3,8(sp)
    80000900:	e052                	sd	s4,0(sp)
    80000902:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000904:	6785                	lui	a5,0x1
    80000906:	04f67863          	bgeu	a2,a5,80000956 <uvminit+0x62>
    8000090a:	8a2a                	mv	s4,a0
    8000090c:	89ae                	mv	s3,a1
    8000090e:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000910:	00000097          	auipc	ra,0x0
    80000914:	8c0080e7          	jalr	-1856(ra) # 800001d0 <kalloc>
    80000918:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000091a:	6605                	lui	a2,0x1
    8000091c:	4581                	li	a1,0
    8000091e:	00000097          	auipc	ra,0x0
    80000922:	92c080e7          	jalr	-1748(ra) # 8000024a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000926:	4779                	li	a4,30
    80000928:	86ca                	mv	a3,s2
    8000092a:	6605                	lui	a2,0x1
    8000092c:	4581                	li	a1,0
    8000092e:	8552                	mv	a0,s4
    80000930:	00000097          	auipc	ra,0x0
    80000934:	cea080e7          	jalr	-790(ra) # 8000061a <mappages>
  memmove(mem, src, sz);
    80000938:	8626                	mv	a2,s1
    8000093a:	85ce                	mv	a1,s3
    8000093c:	854a                	mv	a0,s2
    8000093e:	00000097          	auipc	ra,0x0
    80000942:	96c080e7          	jalr	-1684(ra) # 800002aa <memmove>
}
    80000946:	70a2                	ld	ra,40(sp)
    80000948:	7402                	ld	s0,32(sp)
    8000094a:	64e2                	ld	s1,24(sp)
    8000094c:	6942                	ld	s2,16(sp)
    8000094e:	69a2                	ld	s3,8(sp)
    80000950:	6a02                	ld	s4,0(sp)
    80000952:	6145                	addi	sp,sp,48
    80000954:	8082                	ret
    panic("inituvm: more than a page");
    80000956:	00007517          	auipc	a0,0x7
    8000095a:	7b250513          	addi	a0,a0,1970 # 80008108 <etext+0x108>
    8000095e:	00005097          	auipc	ra,0x5
    80000962:	3ea080e7          	jalr	1002(ra) # 80005d48 <panic>

0000000080000966 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000966:	1101                	addi	sp,sp,-32
    80000968:	ec06                	sd	ra,24(sp)
    8000096a:	e822                	sd	s0,16(sp)
    8000096c:	e426                	sd	s1,8(sp)
    8000096e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000970:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000972:	00b67d63          	bgeu	a2,a1,8000098c <uvmdealloc+0x26>
    80000976:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000978:	6785                	lui	a5,0x1
    8000097a:	17fd                	addi	a5,a5,-1
    8000097c:	00f60733          	add	a4,a2,a5
    80000980:	767d                	lui	a2,0xfffff
    80000982:	8f71                	and	a4,a4,a2
    80000984:	97ae                	add	a5,a5,a1
    80000986:	8ff1                	and	a5,a5,a2
    80000988:	00f76863          	bltu	a4,a5,80000998 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000098c:	8526                	mv	a0,s1
    8000098e:	60e2                	ld	ra,24(sp)
    80000990:	6442                	ld	s0,16(sp)
    80000992:	64a2                	ld	s1,8(sp)
    80000994:	6105                	addi	sp,sp,32
    80000996:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000998:	8f99                	sub	a5,a5,a4
    8000099a:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000099c:	4685                	li	a3,1
    8000099e:	0007861b          	sext.w	a2,a5
    800009a2:	85ba                	mv	a1,a4
    800009a4:	00000097          	auipc	ra,0x0
    800009a8:	e5e080e7          	jalr	-418(ra) # 80000802 <uvmunmap>
    800009ac:	b7c5                	j	8000098c <uvmdealloc+0x26>

00000000800009ae <uvmalloc>:
  if(newsz < oldsz)
    800009ae:	0ab66163          	bltu	a2,a1,80000a50 <uvmalloc+0xa2>
{
    800009b2:	7139                	addi	sp,sp,-64
    800009b4:	fc06                	sd	ra,56(sp)
    800009b6:	f822                	sd	s0,48(sp)
    800009b8:	f426                	sd	s1,40(sp)
    800009ba:	f04a                	sd	s2,32(sp)
    800009bc:	ec4e                	sd	s3,24(sp)
    800009be:	e852                	sd	s4,16(sp)
    800009c0:	e456                	sd	s5,8(sp)
    800009c2:	0080                	addi	s0,sp,64
    800009c4:	8aaa                	mv	s5,a0
    800009c6:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009c8:	6985                	lui	s3,0x1
    800009ca:	19fd                	addi	s3,s3,-1
    800009cc:	95ce                	add	a1,a1,s3
    800009ce:	79fd                	lui	s3,0xfffff
    800009d0:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009d4:	08c9f063          	bgeu	s3,a2,80000a54 <uvmalloc+0xa6>
    800009d8:	894e                	mv	s2,s3
    mem = kalloc();
    800009da:	fffff097          	auipc	ra,0xfffff
    800009de:	7f6080e7          	jalr	2038(ra) # 800001d0 <kalloc>
    800009e2:	84aa                	mv	s1,a0
    if(mem == 0){
    800009e4:	c51d                	beqz	a0,80000a12 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800009e6:	6605                	lui	a2,0x1
    800009e8:	4581                	li	a1,0
    800009ea:	00000097          	auipc	ra,0x0
    800009ee:	860080e7          	jalr	-1952(ra) # 8000024a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800009f2:	4779                	li	a4,30
    800009f4:	86a6                	mv	a3,s1
    800009f6:	6605                	lui	a2,0x1
    800009f8:	85ca                	mv	a1,s2
    800009fa:	8556                	mv	a0,s5
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	c1e080e7          	jalr	-994(ra) # 8000061a <mappages>
    80000a04:	e905                	bnez	a0,80000a34 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a06:	6785                	lui	a5,0x1
    80000a08:	993e                	add	s2,s2,a5
    80000a0a:	fd4968e3          	bltu	s2,s4,800009da <uvmalloc+0x2c>
  return newsz;
    80000a0e:	8552                	mv	a0,s4
    80000a10:	a809                	j	80000a22 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000a12:	864e                	mv	a2,s3
    80000a14:	85ca                	mv	a1,s2
    80000a16:	8556                	mv	a0,s5
    80000a18:	00000097          	auipc	ra,0x0
    80000a1c:	f4e080e7          	jalr	-178(ra) # 80000966 <uvmdealloc>
      return 0;
    80000a20:	4501                	li	a0,0
}
    80000a22:	70e2                	ld	ra,56(sp)
    80000a24:	7442                	ld	s0,48(sp)
    80000a26:	74a2                	ld	s1,40(sp)
    80000a28:	7902                	ld	s2,32(sp)
    80000a2a:	69e2                	ld	s3,24(sp)
    80000a2c:	6a42                	ld	s4,16(sp)
    80000a2e:	6aa2                	ld	s5,8(sp)
    80000a30:	6121                	addi	sp,sp,64
    80000a32:	8082                	ret
      kfree(mem);
    80000a34:	8526                	mv	a0,s1
    80000a36:	fffff097          	auipc	ra,0xfffff
    80000a3a:	636080e7          	jalr	1590(ra) # 8000006c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a3e:	864e                	mv	a2,s3
    80000a40:	85ca                	mv	a1,s2
    80000a42:	8556                	mv	a0,s5
    80000a44:	00000097          	auipc	ra,0x0
    80000a48:	f22080e7          	jalr	-222(ra) # 80000966 <uvmdealloc>
      return 0;
    80000a4c:	4501                	li	a0,0
    80000a4e:	bfd1                	j	80000a22 <uvmalloc+0x74>
    return oldsz;
    80000a50:	852e                	mv	a0,a1
}
    80000a52:	8082                	ret
  return newsz;
    80000a54:	8532                	mv	a0,a2
    80000a56:	b7f1                	j	80000a22 <uvmalloc+0x74>

0000000080000a58 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a58:	7179                	addi	sp,sp,-48
    80000a5a:	f406                	sd	ra,40(sp)
    80000a5c:	f022                	sd	s0,32(sp)
    80000a5e:	ec26                	sd	s1,24(sp)
    80000a60:	e84a                	sd	s2,16(sp)
    80000a62:	e44e                	sd	s3,8(sp)
    80000a64:	e052                	sd	s4,0(sp)
    80000a66:	1800                	addi	s0,sp,48
    80000a68:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a6a:	84aa                	mv	s1,a0
    80000a6c:	6905                	lui	s2,0x1
    80000a6e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a70:	4985                	li	s3,1
    80000a72:	a821                	j	80000a8a <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a74:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000a76:	0532                	slli	a0,a0,0xc
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	fe0080e7          	jalr	-32(ra) # 80000a58 <freewalk>
      pagetable[i] = 0;
    80000a80:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a84:	04a1                	addi	s1,s1,8
    80000a86:	03248163          	beq	s1,s2,80000aa8 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000a8a:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a8c:	00f57793          	andi	a5,a0,15
    80000a90:	ff3782e3          	beq	a5,s3,80000a74 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a94:	8905                	andi	a0,a0,1
    80000a96:	d57d                	beqz	a0,80000a84 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000a98:	00007517          	auipc	a0,0x7
    80000a9c:	69050513          	addi	a0,a0,1680 # 80008128 <etext+0x128>
    80000aa0:	00005097          	auipc	ra,0x5
    80000aa4:	2a8080e7          	jalr	680(ra) # 80005d48 <panic>
    }
  }
  kfree((void*)pagetable);
    80000aa8:	8552                	mv	a0,s4
    80000aaa:	fffff097          	auipc	ra,0xfffff
    80000aae:	5c2080e7          	jalr	1474(ra) # 8000006c <kfree>
}
    80000ab2:	70a2                	ld	ra,40(sp)
    80000ab4:	7402                	ld	s0,32(sp)
    80000ab6:	64e2                	ld	s1,24(sp)
    80000ab8:	6942                	ld	s2,16(sp)
    80000aba:	69a2                	ld	s3,8(sp)
    80000abc:	6a02                	ld	s4,0(sp)
    80000abe:	6145                	addi	sp,sp,48
    80000ac0:	8082                	ret

0000000080000ac2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000ac2:	1101                	addi	sp,sp,-32
    80000ac4:	ec06                	sd	ra,24(sp)
    80000ac6:	e822                	sd	s0,16(sp)
    80000ac8:	e426                	sd	s1,8(sp)
    80000aca:	1000                	addi	s0,sp,32
    80000acc:	84aa                	mv	s1,a0
  if(sz > 0)
    80000ace:	e999                	bnez	a1,80000ae4 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000ad0:	8526                	mv	a0,s1
    80000ad2:	00000097          	auipc	ra,0x0
    80000ad6:	f86080e7          	jalr	-122(ra) # 80000a58 <freewalk>
}
    80000ada:	60e2                	ld	ra,24(sp)
    80000adc:	6442                	ld	s0,16(sp)
    80000ade:	64a2                	ld	s1,8(sp)
    80000ae0:	6105                	addi	sp,sp,32
    80000ae2:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000ae4:	6605                	lui	a2,0x1
    80000ae6:	167d                	addi	a2,a2,-1
    80000ae8:	962e                	add	a2,a2,a1
    80000aea:	4685                	li	a3,1
    80000aec:	8231                	srli	a2,a2,0xc
    80000aee:	4581                	li	a1,0
    80000af0:	00000097          	auipc	ra,0x0
    80000af4:	d12080e7          	jalr	-750(ra) # 80000802 <uvmunmap>
    80000af8:	bfe1                	j	80000ad0 <uvmfree+0xe>

0000000080000afa <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000afa:	7139                	addi	sp,sp,-64
    80000afc:	fc06                	sd	ra,56(sp)
    80000afe:	f822                	sd	s0,48(sp)
    80000b00:	f426                	sd	s1,40(sp)
    80000b02:	f04a                	sd	s2,32(sp)
    80000b04:	ec4e                	sd	s3,24(sp)
    80000b06:	e852                	sd	s4,16(sp)
    80000b08:	e456                	sd	s5,8(sp)
    80000b0a:	e05a                	sd	s6,0(sp)
    80000b0c:	0080                	addi	s0,sp,64
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    80000b0e:	c645                	beqz	a2,80000bb6 <uvmcopy+0xbc>
    80000b10:	8aaa                	mv	s5,a0
    80000b12:	8a2e                	mv	s4,a1
    80000b14:	89b2                	mv	s3,a2
    80000b16:	4481                	li	s1,0
    if((pte = walk(old, i, 0)) == 0)
    80000b18:	4601                	li	a2,0
    80000b1a:	85a6                	mv	a1,s1
    80000b1c:	8556                	mv	a0,s5
    80000b1e:	00000097          	auipc	ra,0x0
    80000b22:	a14080e7          	jalr	-1516(ra) # 80000532 <walk>
    80000b26:	c139                	beqz	a0,80000b6c <uvmcopy+0x72>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b28:	6118                	ld	a4,0(a0)
    80000b2a:	00177793          	andi	a5,a4,1
    80000b2e:	c7b9                	beqz	a5,80000b7c <uvmcopy+0x82>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000b30:	00a75913          	srli	s2,a4,0xa
    80000b34:	0932                	slli	s2,s2,0xc
    *pte = (*pte & ~PTE_W) | PTE_C;
    80000b36:	fdb77713          	andi	a4,a4,-37
    80000b3a:	02076713          	ori	a4,a4,32
    80000b3e:	e118                	sd	a4,0(a0)
    flags = PTE_FLAGS(*pte);
    if(mappages(new, i, PGSIZE,pa, flags) != 0){
    80000b40:	3fb77713          	andi	a4,a4,1019
    80000b44:	86ca                	mv	a3,s2
    80000b46:	6605                	lui	a2,0x1
    80000b48:	85a6                	mv	a1,s1
    80000b4a:	8552                	mv	a0,s4
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	ace080e7          	jalr	-1330(ra) # 8000061a <mappages>
    80000b54:	8b2a                	mv	s6,a0
    80000b56:	e91d                	bnez	a0,80000b8c <uvmcopy+0x92>
      goto err;
    }
    add_rc(pa);
    80000b58:	854a                	mv	a0,s2
    80000b5a:	fffff097          	auipc	ra,0xfffff
    80000b5e:	4c2080e7          	jalr	1218(ra) # 8000001c <add_rc>
  for(i = 0; i < sz; i += PGSIZE){
    80000b62:	6785                	lui	a5,0x1
    80000b64:	94be                	add	s1,s1,a5
    80000b66:	fb34e9e3          	bltu	s1,s3,80000b18 <uvmcopy+0x1e>
    80000b6a:	a81d                	j	80000ba0 <uvmcopy+0xa6>
      panic("uvmcopy: pte should exist");
    80000b6c:	00007517          	auipc	a0,0x7
    80000b70:	5cc50513          	addi	a0,a0,1484 # 80008138 <etext+0x138>
    80000b74:	00005097          	auipc	ra,0x5
    80000b78:	1d4080e7          	jalr	468(ra) # 80005d48 <panic>
      panic("uvmcopy: page not present");
    80000b7c:	00007517          	auipc	a0,0x7
    80000b80:	5dc50513          	addi	a0,a0,1500 # 80008158 <etext+0x158>
    80000b84:	00005097          	auipc	ra,0x5
    80000b88:	1c4080e7          	jalr	452(ra) # 80005d48 <panic>
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b8c:	4685                	li	a3,1
    80000b8e:	00c4d613          	srli	a2,s1,0xc
    80000b92:	4581                	li	a1,0
    80000b94:	8552                	mv	a0,s4
    80000b96:	00000097          	auipc	ra,0x0
    80000b9a:	c6c080e7          	jalr	-916(ra) # 80000802 <uvmunmap>
  return -1;
    80000b9e:	5b7d                	li	s6,-1
}
    80000ba0:	855a                	mv	a0,s6
    80000ba2:	70e2                	ld	ra,56(sp)
    80000ba4:	7442                	ld	s0,48(sp)
    80000ba6:	74a2                	ld	s1,40(sp)
    80000ba8:	7902                	ld	s2,32(sp)
    80000baa:	69e2                	ld	s3,24(sp)
    80000bac:	6a42                	ld	s4,16(sp)
    80000bae:	6aa2                	ld	s5,8(sp)
    80000bb0:	6b02                	ld	s6,0(sp)
    80000bb2:	6121                	addi	sp,sp,64
    80000bb4:	8082                	ret
  return 0;
    80000bb6:	4b01                	li	s6,0
    80000bb8:	b7e5                	j	80000ba0 <uvmcopy+0xa6>

0000000080000bba <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000bba:	1141                	addi	sp,sp,-16
    80000bbc:	e406                	sd	ra,8(sp)
    80000bbe:	e022                	sd	s0,0(sp)
    80000bc0:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000bc2:	4601                	li	a2,0
    80000bc4:	00000097          	auipc	ra,0x0
    80000bc8:	96e080e7          	jalr	-1682(ra) # 80000532 <walk>
  if(pte == 0)
    80000bcc:	c901                	beqz	a0,80000bdc <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000bce:	611c                	ld	a5,0(a0)
    80000bd0:	9bbd                	andi	a5,a5,-17
    80000bd2:	e11c                	sd	a5,0(a0)
}
    80000bd4:	60a2                	ld	ra,8(sp)
    80000bd6:	6402                	ld	s0,0(sp)
    80000bd8:	0141                	addi	sp,sp,16
    80000bda:	8082                	ret
    panic("uvmclear");
    80000bdc:	00007517          	auipc	a0,0x7
    80000be0:	59c50513          	addi	a0,a0,1436 # 80008178 <etext+0x178>
    80000be4:	00005097          	auipc	ra,0x5
    80000be8:	164080e7          	jalr	356(ra) # 80005d48 <panic>

0000000080000bec <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0, flag;
  pte_t* pte;
  while(len > 0){
    80000bec:	caf1                	beqz	a3,80000cc0 <copyout+0xd4>
{
    80000bee:	711d                	addi	sp,sp,-96
    80000bf0:	ec86                	sd	ra,88(sp)
    80000bf2:	e8a2                	sd	s0,80(sp)
    80000bf4:	e4a6                	sd	s1,72(sp)
    80000bf6:	e0ca                	sd	s2,64(sp)
    80000bf8:	fc4e                	sd	s3,56(sp)
    80000bfa:	f852                	sd	s4,48(sp)
    80000bfc:	f456                	sd	s5,40(sp)
    80000bfe:	f05a                	sd	s6,32(sp)
    80000c00:	ec5e                	sd	s7,24(sp)
    80000c02:	e862                	sd	s8,16(sp)
    80000c04:	e466                	sd	s9,8(sp)
    80000c06:	e06a                	sd	s10,0(sp)
    80000c08:	1080                	addi	s0,sp,96
    80000c0a:	8c2a                	mv	s8,a0
    80000c0c:	8b2e                	mv	s6,a1
    80000c0e:	8bb2                	mv	s7,a2
    80000c10:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    80000c12:	797d                	lui	s2,0xfffff
    80000c14:	0125f933          	and	s2,a1,s2
    if(va0 >= MAXVA)
    80000c18:	57fd                	li	a5,-1
    80000c1a:	83e9                	srli	a5,a5,0x1a
    80000c1c:	0b27e463          	bltu	a5,s2,80000cc4 <copyout+0xd8>
    80000c20:	8cbe                	mv	s9,a5
    80000c22:	a095                	j	80000c86 <copyout+0x9a>
    if(pte == 0)
        return -1;
    pa0 = PTE2PA(*pte);
    flag = PTE_FLAGS(*pte);
    if(flag & PTE_C){
        char* mem = kalloc();
    80000c24:	fffff097          	auipc	ra,0xfffff
    80000c28:	5ac080e7          	jalr	1452(ra) # 800001d0 <kalloc>
    80000c2c:	8a2a                	mv	s4,a0
        if(mem == 0){
    80000c2e:	cd55                	beqz	a0,80000cea <copyout+0xfe>
            return -1;
        }
        memmove(mem,(char*)pa0,PGSIZE);
    80000c30:	6605                	lui	a2,0x1
    80000c32:	85ce                	mv	a1,s3
    80000c34:	fffff097          	auipc	ra,0xfffff
    80000c38:	676080e7          	jalr	1654(ra) # 800002aa <memmove>
        kfree((char*)pa0);
    80000c3c:	854e                	mv	a0,s3
    80000c3e:	fffff097          	auipc	ra,0xfffff
    80000c42:	42e080e7          	jalr	1070(ra) # 8000006c <kfree>
        *pte = PA2PTE((uint64)mem) | (flag & ~PTE_C) | PTE_W;
    80000c46:	89d2                	mv	s3,s4
    80000c48:	00ca5a13          	srli	s4,s4,0xc
    80000c4c:	0a2a                	slli	s4,s4,0xa
    80000c4e:	3dfd7d13          	andi	s10,s10,991
    80000c52:	01aa6a33          	or	s4,s4,s10
    80000c56:	004a6a13          	ori	s4,s4,4
    80000c5a:	0144b023          	sd	s4,0(s1)
        pa0 = (uint64)mem;
    }
    if(pa0 == 0)
    80000c5e:	a0b9                	j	80000cac <copyout+0xc0>
      return -1;
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c60:	412b0533          	sub	a0,s6,s2
    80000c64:	000a061b          	sext.w	a2,s4
    80000c68:	85de                	mv	a1,s7
    80000c6a:	954e                	add	a0,a0,s3
    80000c6c:	fffff097          	auipc	ra,0xfffff
    80000c70:	63e080e7          	jalr	1598(ra) # 800002aa <memmove>

    len -= n;
    80000c74:	414a8ab3          	sub	s5,s5,s4
    src += n;
    80000c78:	9bd2                	add	s7,s7,s4
  while(len > 0){
    80000c7a:	040a8163          	beqz	s5,80000cbc <copyout+0xd0>
    if(va0 >= MAXVA)
    80000c7e:	049ce563          	bltu	s9,s1,80000cc8 <copyout+0xdc>
    va0 = PGROUNDDOWN(dstva);
    80000c82:	8926                	mv	s2,s1
    dstva = va0 + PGSIZE;
    80000c84:	8b26                	mv	s6,s1
    pte = walk(pagetable,va0,0);
    80000c86:	4601                	li	a2,0
    80000c88:	85ca                	mv	a1,s2
    80000c8a:	8562                	mv	a0,s8
    80000c8c:	00000097          	auipc	ra,0x0
    80000c90:	8a6080e7          	jalr	-1882(ra) # 80000532 <walk>
    80000c94:	84aa                	mv	s1,a0
    if(pte == 0)
    80000c96:	c91d                	beqz	a0,80000ccc <copyout+0xe0>
    pa0 = PTE2PA(*pte);
    80000c98:	00053d03          	ld	s10,0(a0)
    80000c9c:	00ad5993          	srli	s3,s10,0xa
    80000ca0:	09b2                	slli	s3,s3,0xc
    if(flag & PTE_C){
    80000ca2:	020d7793          	andi	a5,s10,32
    80000ca6:	ffbd                	bnez	a5,80000c24 <copyout+0x38>
    if(pa0 == 0)
    80000ca8:	04098363          	beqz	s3,80000cee <copyout+0x102>
    n = PGSIZE - (dstva - va0);
    80000cac:	6485                	lui	s1,0x1
    80000cae:	94ca                	add	s1,s1,s2
    80000cb0:	41648a33          	sub	s4,s1,s6
    if(n > len)
    80000cb4:	fb4af6e3          	bgeu	s5,s4,80000c60 <copyout+0x74>
    80000cb8:	8a56                	mv	s4,s5
    80000cba:	b75d                	j	80000c60 <copyout+0x74>
  }
  return 0;
    80000cbc:	4501                	li	a0,0
    80000cbe:	a801                	j	80000cce <copyout+0xe2>
    80000cc0:	4501                	li	a0,0
}
    80000cc2:	8082                	ret
        return -1;
    80000cc4:	557d                	li	a0,-1
    80000cc6:	a021                	j	80000cce <copyout+0xe2>
    80000cc8:	557d                	li	a0,-1
    80000cca:	a011                	j	80000cce <copyout+0xe2>
        return -1;
    80000ccc:	557d                	li	a0,-1
}
    80000cce:	60e6                	ld	ra,88(sp)
    80000cd0:	6446                	ld	s0,80(sp)
    80000cd2:	64a6                	ld	s1,72(sp)
    80000cd4:	6906                	ld	s2,64(sp)
    80000cd6:	79e2                	ld	s3,56(sp)
    80000cd8:	7a42                	ld	s4,48(sp)
    80000cda:	7aa2                	ld	s5,40(sp)
    80000cdc:	7b02                	ld	s6,32(sp)
    80000cde:	6be2                	ld	s7,24(sp)
    80000ce0:	6c42                	ld	s8,16(sp)
    80000ce2:	6ca2                	ld	s9,8(sp)
    80000ce4:	6d02                	ld	s10,0(sp)
    80000ce6:	6125                	addi	sp,sp,96
    80000ce8:	8082                	ret
            return -1;
    80000cea:	557d                	li	a0,-1
    80000cec:	b7cd                	j	80000cce <copyout+0xe2>
      return -1;
    80000cee:	557d                	li	a0,-1
    80000cf0:	bff9                	j	80000cce <copyout+0xe2>

0000000080000cf2 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000cf2:	c6bd                	beqz	a3,80000d60 <copyin+0x6e>
{
    80000cf4:	715d                	addi	sp,sp,-80
    80000cf6:	e486                	sd	ra,72(sp)
    80000cf8:	e0a2                	sd	s0,64(sp)
    80000cfa:	fc26                	sd	s1,56(sp)
    80000cfc:	f84a                	sd	s2,48(sp)
    80000cfe:	f44e                	sd	s3,40(sp)
    80000d00:	f052                	sd	s4,32(sp)
    80000d02:	ec56                	sd	s5,24(sp)
    80000d04:	e85a                	sd	s6,16(sp)
    80000d06:	e45e                	sd	s7,8(sp)
    80000d08:	e062                	sd	s8,0(sp)
    80000d0a:	0880                	addi	s0,sp,80
    80000d0c:	8b2a                	mv	s6,a0
    80000d0e:	8a2e                	mv	s4,a1
    80000d10:	8c32                	mv	s8,a2
    80000d12:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000d14:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d16:	6a85                	lui	s5,0x1
    80000d18:	a015                	j	80000d3c <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d1a:	9562                	add	a0,a0,s8
    80000d1c:	0004861b          	sext.w	a2,s1
    80000d20:	412505b3          	sub	a1,a0,s2
    80000d24:	8552                	mv	a0,s4
    80000d26:	fffff097          	auipc	ra,0xfffff
    80000d2a:	584080e7          	jalr	1412(ra) # 800002aa <memmove>

    len -= n;
    80000d2e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d32:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d34:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d38:	02098263          	beqz	s3,80000d5c <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000d3c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d40:	85ca                	mv	a1,s2
    80000d42:	855a                	mv	a0,s6
    80000d44:	00000097          	auipc	ra,0x0
    80000d48:	894080e7          	jalr	-1900(ra) # 800005d8 <walkaddr>
    if(pa0 == 0)
    80000d4c:	cd01                	beqz	a0,80000d64 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000d4e:	418904b3          	sub	s1,s2,s8
    80000d52:	94d6                	add	s1,s1,s5
    if(n > len)
    80000d54:	fc99f3e3          	bgeu	s3,s1,80000d1a <copyin+0x28>
    80000d58:	84ce                	mv	s1,s3
    80000d5a:	b7c1                	j	80000d1a <copyin+0x28>
  }
  return 0;
    80000d5c:	4501                	li	a0,0
    80000d5e:	a021                	j	80000d66 <copyin+0x74>
    80000d60:	4501                	li	a0,0
}
    80000d62:	8082                	ret
      return -1;
    80000d64:	557d                	li	a0,-1
}
    80000d66:	60a6                	ld	ra,72(sp)
    80000d68:	6406                	ld	s0,64(sp)
    80000d6a:	74e2                	ld	s1,56(sp)
    80000d6c:	7942                	ld	s2,48(sp)
    80000d6e:	79a2                	ld	s3,40(sp)
    80000d70:	7a02                	ld	s4,32(sp)
    80000d72:	6ae2                	ld	s5,24(sp)
    80000d74:	6b42                	ld	s6,16(sp)
    80000d76:	6ba2                	ld	s7,8(sp)
    80000d78:	6c02                	ld	s8,0(sp)
    80000d7a:	6161                	addi	sp,sp,80
    80000d7c:	8082                	ret

0000000080000d7e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d7e:	c6c5                	beqz	a3,80000e26 <copyinstr+0xa8>
{
    80000d80:	715d                	addi	sp,sp,-80
    80000d82:	e486                	sd	ra,72(sp)
    80000d84:	e0a2                	sd	s0,64(sp)
    80000d86:	fc26                	sd	s1,56(sp)
    80000d88:	f84a                	sd	s2,48(sp)
    80000d8a:	f44e                	sd	s3,40(sp)
    80000d8c:	f052                	sd	s4,32(sp)
    80000d8e:	ec56                	sd	s5,24(sp)
    80000d90:	e85a                	sd	s6,16(sp)
    80000d92:	e45e                	sd	s7,8(sp)
    80000d94:	0880                	addi	s0,sp,80
    80000d96:	8a2a                	mv	s4,a0
    80000d98:	8b2e                	mv	s6,a1
    80000d9a:	8bb2                	mv	s7,a2
    80000d9c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000d9e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000da0:	6985                	lui	s3,0x1
    80000da2:	a035                	j	80000dce <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000da4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000da8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000daa:	0017b793          	seqz	a5,a5
    80000dae:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000db2:	60a6                	ld	ra,72(sp)
    80000db4:	6406                	ld	s0,64(sp)
    80000db6:	74e2                	ld	s1,56(sp)
    80000db8:	7942                	ld	s2,48(sp)
    80000dba:	79a2                	ld	s3,40(sp)
    80000dbc:	7a02                	ld	s4,32(sp)
    80000dbe:	6ae2                	ld	s5,24(sp)
    80000dc0:	6b42                	ld	s6,16(sp)
    80000dc2:	6ba2                	ld	s7,8(sp)
    80000dc4:	6161                	addi	sp,sp,80
    80000dc6:	8082                	ret
    srcva = va0 + PGSIZE;
    80000dc8:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000dcc:	c8a9                	beqz	s1,80000e1e <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000dce:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000dd2:	85ca                	mv	a1,s2
    80000dd4:	8552                	mv	a0,s4
    80000dd6:	00000097          	auipc	ra,0x0
    80000dda:	802080e7          	jalr	-2046(ra) # 800005d8 <walkaddr>
    if(pa0 == 0)
    80000dde:	c131                	beqz	a0,80000e22 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000de0:	41790833          	sub	a6,s2,s7
    80000de4:	984e                	add	a6,a6,s3
    if(n > max)
    80000de6:	0104f363          	bgeu	s1,a6,80000dec <copyinstr+0x6e>
    80000dea:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000dec:	955e                	add	a0,a0,s7
    80000dee:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000df2:	fc080be3          	beqz	a6,80000dc8 <copyinstr+0x4a>
    80000df6:	985a                	add	a6,a6,s6
    80000df8:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000dfa:	41650633          	sub	a2,a0,s6
    80000dfe:	14fd                	addi	s1,s1,-1
    80000e00:	9b26                	add	s6,s6,s1
    80000e02:	00f60733          	add	a4,a2,a5
    80000e06:	00074703          	lbu	a4,0(a4)
    80000e0a:	df49                	beqz	a4,80000da4 <copyinstr+0x26>
        *dst = *p;
    80000e0c:	00e78023          	sb	a4,0(a5)
      --max;
    80000e10:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000e14:	0785                	addi	a5,a5,1
    while(n > 0){
    80000e16:	ff0796e3          	bne	a5,a6,80000e02 <copyinstr+0x84>
      dst++;
    80000e1a:	8b42                	mv	s6,a6
    80000e1c:	b775                	j	80000dc8 <copyinstr+0x4a>
    80000e1e:	4781                	li	a5,0
    80000e20:	b769                	j	80000daa <copyinstr+0x2c>
      return -1;
    80000e22:	557d                	li	a0,-1
    80000e24:	b779                	j	80000db2 <copyinstr+0x34>
  int got_null = 0;
    80000e26:	4781                	li	a5,0
  if(got_null){
    80000e28:	0017b793          	seqz	a5,a5
    80000e2c:	40f00533          	neg	a0,a5
}
    80000e30:	8082                	ret

0000000080000e32 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e32:	7139                	addi	sp,sp,-64
    80000e34:	fc06                	sd	ra,56(sp)
    80000e36:	f822                	sd	s0,48(sp)
    80000e38:	f426                	sd	s1,40(sp)
    80000e3a:	f04a                	sd	s2,32(sp)
    80000e3c:	ec4e                	sd	s3,24(sp)
    80000e3e:	e852                	sd	s4,16(sp)
    80000e40:	e456                	sd	s5,8(sp)
    80000e42:	e05a                	sd	s6,0(sp)
    80000e44:	0080                	addi	s0,sp,64
    80000e46:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e48:	00028497          	auipc	s1,0x28
    80000e4c:	63848493          	addi	s1,s1,1592 # 80029480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e50:	8b26                	mv	s6,s1
    80000e52:	00007a97          	auipc	s5,0x7
    80000e56:	1aea8a93          	addi	s5,s5,430 # 80008000 <etext>
    80000e5a:	04000937          	lui	s2,0x4000
    80000e5e:	197d                	addi	s2,s2,-1
    80000e60:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e62:	0002ea17          	auipc	s4,0x2e
    80000e66:	01ea0a13          	addi	s4,s4,30 # 8002ee80 <tickslock>
    char *pa = kalloc();
    80000e6a:	fffff097          	auipc	ra,0xfffff
    80000e6e:	366080e7          	jalr	870(ra) # 800001d0 <kalloc>
    80000e72:	862a                	mv	a2,a0
    if(pa == 0)
    80000e74:	c131                	beqz	a0,80000eb8 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000e76:	416485b3          	sub	a1,s1,s6
    80000e7a:	858d                	srai	a1,a1,0x3
    80000e7c:	000ab783          	ld	a5,0(s5)
    80000e80:	02f585b3          	mul	a1,a1,a5
    80000e84:	2585                	addiw	a1,a1,1
    80000e86:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e8a:	4719                	li	a4,6
    80000e8c:	6685                	lui	a3,0x1
    80000e8e:	40b905b3          	sub	a1,s2,a1
    80000e92:	854e                	mv	a0,s3
    80000e94:	00000097          	auipc	ra,0x0
    80000e98:	848080e7          	jalr	-1976(ra) # 800006dc <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e9c:	16848493          	addi	s1,s1,360
    80000ea0:	fd4495e3          	bne	s1,s4,80000e6a <proc_mapstacks+0x38>
  }
}
    80000ea4:	70e2                	ld	ra,56(sp)
    80000ea6:	7442                	ld	s0,48(sp)
    80000ea8:	74a2                	ld	s1,40(sp)
    80000eaa:	7902                	ld	s2,32(sp)
    80000eac:	69e2                	ld	s3,24(sp)
    80000eae:	6a42                	ld	s4,16(sp)
    80000eb0:	6aa2                	ld	s5,8(sp)
    80000eb2:	6b02                	ld	s6,0(sp)
    80000eb4:	6121                	addi	sp,sp,64
    80000eb6:	8082                	ret
      panic("kalloc");
    80000eb8:	00007517          	auipc	a0,0x7
    80000ebc:	2d050513          	addi	a0,a0,720 # 80008188 <etext+0x188>
    80000ec0:	00005097          	auipc	ra,0x5
    80000ec4:	e88080e7          	jalr	-376(ra) # 80005d48 <panic>

0000000080000ec8 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000ec8:	7139                	addi	sp,sp,-64
    80000eca:	fc06                	sd	ra,56(sp)
    80000ecc:	f822                	sd	s0,48(sp)
    80000ece:	f426                	sd	s1,40(sp)
    80000ed0:	f04a                	sd	s2,32(sp)
    80000ed2:	ec4e                	sd	s3,24(sp)
    80000ed4:	e852                	sd	s4,16(sp)
    80000ed6:	e456                	sd	s5,8(sp)
    80000ed8:	e05a                	sd	s6,0(sp)
    80000eda:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000edc:	00007597          	auipc	a1,0x7
    80000ee0:	2b458593          	addi	a1,a1,692 # 80008190 <etext+0x190>
    80000ee4:	00028517          	auipc	a0,0x28
    80000ee8:	16c50513          	addi	a0,a0,364 # 80029050 <pid_lock>
    80000eec:	00005097          	auipc	ra,0x5
    80000ef0:	316080e7          	jalr	790(ra) # 80006202 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ef4:	00007597          	auipc	a1,0x7
    80000ef8:	2a458593          	addi	a1,a1,676 # 80008198 <etext+0x198>
    80000efc:	00028517          	auipc	a0,0x28
    80000f00:	16c50513          	addi	a0,a0,364 # 80029068 <wait_lock>
    80000f04:	00005097          	auipc	ra,0x5
    80000f08:	2fe080e7          	jalr	766(ra) # 80006202 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f0c:	00028497          	auipc	s1,0x28
    80000f10:	57448493          	addi	s1,s1,1396 # 80029480 <proc>
      initlock(&p->lock, "proc");
    80000f14:	00007b17          	auipc	s6,0x7
    80000f18:	294b0b13          	addi	s6,s6,660 # 800081a8 <etext+0x1a8>
      p->kstack = KSTACK((int) (p - proc));
    80000f1c:	8aa6                	mv	s5,s1
    80000f1e:	00007a17          	auipc	s4,0x7
    80000f22:	0e2a0a13          	addi	s4,s4,226 # 80008000 <etext>
    80000f26:	04000937          	lui	s2,0x4000
    80000f2a:	197d                	addi	s2,s2,-1
    80000f2c:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f2e:	0002e997          	auipc	s3,0x2e
    80000f32:	f5298993          	addi	s3,s3,-174 # 8002ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000f36:	85da                	mv	a1,s6
    80000f38:	8526                	mv	a0,s1
    80000f3a:	00005097          	auipc	ra,0x5
    80000f3e:	2c8080e7          	jalr	712(ra) # 80006202 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f42:	415487b3          	sub	a5,s1,s5
    80000f46:	878d                	srai	a5,a5,0x3
    80000f48:	000a3703          	ld	a4,0(s4)
    80000f4c:	02e787b3          	mul	a5,a5,a4
    80000f50:	2785                	addiw	a5,a5,1
    80000f52:	00d7979b          	slliw	a5,a5,0xd
    80000f56:	40f907b3          	sub	a5,s2,a5
    80000f5a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f5c:	16848493          	addi	s1,s1,360
    80000f60:	fd349be3          	bne	s1,s3,80000f36 <procinit+0x6e>
  }
}
    80000f64:	70e2                	ld	ra,56(sp)
    80000f66:	7442                	ld	s0,48(sp)
    80000f68:	74a2                	ld	s1,40(sp)
    80000f6a:	7902                	ld	s2,32(sp)
    80000f6c:	69e2                	ld	s3,24(sp)
    80000f6e:	6a42                	ld	s4,16(sp)
    80000f70:	6aa2                	ld	s5,8(sp)
    80000f72:	6b02                	ld	s6,0(sp)
    80000f74:	6121                	addi	sp,sp,64
    80000f76:	8082                	ret

0000000080000f78 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f78:	1141                	addi	sp,sp,-16
    80000f7a:	e422                	sd	s0,8(sp)
    80000f7c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f7e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f80:	2501                	sext.w	a0,a0
    80000f82:	6422                	ld	s0,8(sp)
    80000f84:	0141                	addi	sp,sp,16
    80000f86:	8082                	ret

0000000080000f88 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f88:	1141                	addi	sp,sp,-16
    80000f8a:	e422                	sd	s0,8(sp)
    80000f8c:	0800                	addi	s0,sp,16
    80000f8e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f90:	2781                	sext.w	a5,a5
    80000f92:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f94:	00028517          	auipc	a0,0x28
    80000f98:	0ec50513          	addi	a0,a0,236 # 80029080 <cpus>
    80000f9c:	953e                	add	a0,a0,a5
    80000f9e:	6422                	ld	s0,8(sp)
    80000fa0:	0141                	addi	sp,sp,16
    80000fa2:	8082                	ret

0000000080000fa4 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000fa4:	1101                	addi	sp,sp,-32
    80000fa6:	ec06                	sd	ra,24(sp)
    80000fa8:	e822                	sd	s0,16(sp)
    80000faa:	e426                	sd	s1,8(sp)
    80000fac:	1000                	addi	s0,sp,32
  push_off();
    80000fae:	00005097          	auipc	ra,0x5
    80000fb2:	298080e7          	jalr	664(ra) # 80006246 <push_off>
    80000fb6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000fb8:	2781                	sext.w	a5,a5
    80000fba:	079e                	slli	a5,a5,0x7
    80000fbc:	00028717          	auipc	a4,0x28
    80000fc0:	09470713          	addi	a4,a4,148 # 80029050 <pid_lock>
    80000fc4:	97ba                	add	a5,a5,a4
    80000fc6:	7b84                	ld	s1,48(a5)
  pop_off();
    80000fc8:	00005097          	auipc	ra,0x5
    80000fcc:	31e080e7          	jalr	798(ra) # 800062e6 <pop_off>
  return p;
}
    80000fd0:	8526                	mv	a0,s1
    80000fd2:	60e2                	ld	ra,24(sp)
    80000fd4:	6442                	ld	s0,16(sp)
    80000fd6:	64a2                	ld	s1,8(sp)
    80000fd8:	6105                	addi	sp,sp,32
    80000fda:	8082                	ret

0000000080000fdc <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000fdc:	1141                	addi	sp,sp,-16
    80000fde:	e406                	sd	ra,8(sp)
    80000fe0:	e022                	sd	s0,0(sp)
    80000fe2:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fe4:	00000097          	auipc	ra,0x0
    80000fe8:	fc0080e7          	jalr	-64(ra) # 80000fa4 <myproc>
    80000fec:	00005097          	auipc	ra,0x5
    80000ff0:	35a080e7          	jalr	858(ra) # 80006346 <release>

  if (first) {
    80000ff4:	00008797          	auipc	a5,0x8
    80000ff8:	85c7a783          	lw	a5,-1956(a5) # 80008850 <first.1680>
    80000ffc:	eb89                	bnez	a5,8000100e <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ffe:	00001097          	auipc	ra,0x1
    80001002:	c0a080e7          	jalr	-1014(ra) # 80001c08 <usertrapret>
}
    80001006:	60a2                	ld	ra,8(sp)
    80001008:	6402                	ld	s0,0(sp)
    8000100a:	0141                	addi	sp,sp,16
    8000100c:	8082                	ret
    first = 0;
    8000100e:	00008797          	auipc	a5,0x8
    80001012:	8407a123          	sw	zero,-1982(a5) # 80008850 <first.1680>
    fsinit(ROOTDEV);
    80001016:	4505                	li	a0,1
    80001018:	00002097          	auipc	ra,0x2
    8000101c:	a06080e7          	jalr	-1530(ra) # 80002a1e <fsinit>
    80001020:	bff9                	j	80000ffe <forkret+0x22>

0000000080001022 <allocpid>:
allocpid() {
    80001022:	1101                	addi	sp,sp,-32
    80001024:	ec06                	sd	ra,24(sp)
    80001026:	e822                	sd	s0,16(sp)
    80001028:	e426                	sd	s1,8(sp)
    8000102a:	e04a                	sd	s2,0(sp)
    8000102c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000102e:	00028917          	auipc	s2,0x28
    80001032:	02290913          	addi	s2,s2,34 # 80029050 <pid_lock>
    80001036:	854a                	mv	a0,s2
    80001038:	00005097          	auipc	ra,0x5
    8000103c:	25a080e7          	jalr	602(ra) # 80006292 <acquire>
  pid = nextpid;
    80001040:	00008797          	auipc	a5,0x8
    80001044:	81478793          	addi	a5,a5,-2028 # 80008854 <nextpid>
    80001048:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000104a:	0014871b          	addiw	a4,s1,1
    8000104e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001050:	854a                	mv	a0,s2
    80001052:	00005097          	auipc	ra,0x5
    80001056:	2f4080e7          	jalr	756(ra) # 80006346 <release>
}
    8000105a:	8526                	mv	a0,s1
    8000105c:	60e2                	ld	ra,24(sp)
    8000105e:	6442                	ld	s0,16(sp)
    80001060:	64a2                	ld	s1,8(sp)
    80001062:	6902                	ld	s2,0(sp)
    80001064:	6105                	addi	sp,sp,32
    80001066:	8082                	ret

0000000080001068 <proc_pagetable>:
{
    80001068:	1101                	addi	sp,sp,-32
    8000106a:	ec06                	sd	ra,24(sp)
    8000106c:	e822                	sd	s0,16(sp)
    8000106e:	e426                	sd	s1,8(sp)
    80001070:	e04a                	sd	s2,0(sp)
    80001072:	1000                	addi	s0,sp,32
    80001074:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001076:	00000097          	auipc	ra,0x0
    8000107a:	850080e7          	jalr	-1968(ra) # 800008c6 <uvmcreate>
    8000107e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001080:	c121                	beqz	a0,800010c0 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001082:	4729                	li	a4,10
    80001084:	00006697          	auipc	a3,0x6
    80001088:	f7c68693          	addi	a3,a3,-132 # 80007000 <_trampoline>
    8000108c:	6605                	lui	a2,0x1
    8000108e:	040005b7          	lui	a1,0x4000
    80001092:	15fd                	addi	a1,a1,-1
    80001094:	05b2                	slli	a1,a1,0xc
    80001096:	fffff097          	auipc	ra,0xfffff
    8000109a:	584080e7          	jalr	1412(ra) # 8000061a <mappages>
    8000109e:	02054863          	bltz	a0,800010ce <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800010a2:	4719                	li	a4,6
    800010a4:	05893683          	ld	a3,88(s2)
    800010a8:	6605                	lui	a2,0x1
    800010aa:	020005b7          	lui	a1,0x2000
    800010ae:	15fd                	addi	a1,a1,-1
    800010b0:	05b6                	slli	a1,a1,0xd
    800010b2:	8526                	mv	a0,s1
    800010b4:	fffff097          	auipc	ra,0xfffff
    800010b8:	566080e7          	jalr	1382(ra) # 8000061a <mappages>
    800010bc:	02054163          	bltz	a0,800010de <proc_pagetable+0x76>
}
    800010c0:	8526                	mv	a0,s1
    800010c2:	60e2                	ld	ra,24(sp)
    800010c4:	6442                	ld	s0,16(sp)
    800010c6:	64a2                	ld	s1,8(sp)
    800010c8:	6902                	ld	s2,0(sp)
    800010ca:	6105                	addi	sp,sp,32
    800010cc:	8082                	ret
    uvmfree(pagetable, 0);
    800010ce:	4581                	li	a1,0
    800010d0:	8526                	mv	a0,s1
    800010d2:	00000097          	auipc	ra,0x0
    800010d6:	9f0080e7          	jalr	-1552(ra) # 80000ac2 <uvmfree>
    return 0;
    800010da:	4481                	li	s1,0
    800010dc:	b7d5                	j	800010c0 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010de:	4681                	li	a3,0
    800010e0:	4605                	li	a2,1
    800010e2:	040005b7          	lui	a1,0x4000
    800010e6:	15fd                	addi	a1,a1,-1
    800010e8:	05b2                	slli	a1,a1,0xc
    800010ea:	8526                	mv	a0,s1
    800010ec:	fffff097          	auipc	ra,0xfffff
    800010f0:	716080e7          	jalr	1814(ra) # 80000802 <uvmunmap>
    uvmfree(pagetable, 0);
    800010f4:	4581                	li	a1,0
    800010f6:	8526                	mv	a0,s1
    800010f8:	00000097          	auipc	ra,0x0
    800010fc:	9ca080e7          	jalr	-1590(ra) # 80000ac2 <uvmfree>
    return 0;
    80001100:	4481                	li	s1,0
    80001102:	bf7d                	j	800010c0 <proc_pagetable+0x58>

0000000080001104 <proc_freepagetable>:
{
    80001104:	1101                	addi	sp,sp,-32
    80001106:	ec06                	sd	ra,24(sp)
    80001108:	e822                	sd	s0,16(sp)
    8000110a:	e426                	sd	s1,8(sp)
    8000110c:	e04a                	sd	s2,0(sp)
    8000110e:	1000                	addi	s0,sp,32
    80001110:	84aa                	mv	s1,a0
    80001112:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001114:	4681                	li	a3,0
    80001116:	4605                	li	a2,1
    80001118:	040005b7          	lui	a1,0x4000
    8000111c:	15fd                	addi	a1,a1,-1
    8000111e:	05b2                	slli	a1,a1,0xc
    80001120:	fffff097          	auipc	ra,0xfffff
    80001124:	6e2080e7          	jalr	1762(ra) # 80000802 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001128:	4681                	li	a3,0
    8000112a:	4605                	li	a2,1
    8000112c:	020005b7          	lui	a1,0x2000
    80001130:	15fd                	addi	a1,a1,-1
    80001132:	05b6                	slli	a1,a1,0xd
    80001134:	8526                	mv	a0,s1
    80001136:	fffff097          	auipc	ra,0xfffff
    8000113a:	6cc080e7          	jalr	1740(ra) # 80000802 <uvmunmap>
  uvmfree(pagetable, sz);
    8000113e:	85ca                	mv	a1,s2
    80001140:	8526                	mv	a0,s1
    80001142:	00000097          	auipc	ra,0x0
    80001146:	980080e7          	jalr	-1664(ra) # 80000ac2 <uvmfree>
}
    8000114a:	60e2                	ld	ra,24(sp)
    8000114c:	6442                	ld	s0,16(sp)
    8000114e:	64a2                	ld	s1,8(sp)
    80001150:	6902                	ld	s2,0(sp)
    80001152:	6105                	addi	sp,sp,32
    80001154:	8082                	ret

0000000080001156 <freeproc>:
{
    80001156:	1101                	addi	sp,sp,-32
    80001158:	ec06                	sd	ra,24(sp)
    8000115a:	e822                	sd	s0,16(sp)
    8000115c:	e426                	sd	s1,8(sp)
    8000115e:	1000                	addi	s0,sp,32
    80001160:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001162:	6d28                	ld	a0,88(a0)
    80001164:	c509                	beqz	a0,8000116e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001166:	fffff097          	auipc	ra,0xfffff
    8000116a:	f06080e7          	jalr	-250(ra) # 8000006c <kfree>
  p->trapframe = 0;
    8000116e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001172:	68a8                	ld	a0,80(s1)
    80001174:	c511                	beqz	a0,80001180 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001176:	64ac                	ld	a1,72(s1)
    80001178:	00000097          	auipc	ra,0x0
    8000117c:	f8c080e7          	jalr	-116(ra) # 80001104 <proc_freepagetable>
  p->pagetable = 0;
    80001180:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001184:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001188:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000118c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001190:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001194:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001198:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000119c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011a0:	0004ac23          	sw	zero,24(s1)
}
    800011a4:	60e2                	ld	ra,24(sp)
    800011a6:	6442                	ld	s0,16(sp)
    800011a8:	64a2                	ld	s1,8(sp)
    800011aa:	6105                	addi	sp,sp,32
    800011ac:	8082                	ret

00000000800011ae <allocproc>:
{
    800011ae:	1101                	addi	sp,sp,-32
    800011b0:	ec06                	sd	ra,24(sp)
    800011b2:	e822                	sd	s0,16(sp)
    800011b4:	e426                	sd	s1,8(sp)
    800011b6:	e04a                	sd	s2,0(sp)
    800011b8:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011ba:	00028497          	auipc	s1,0x28
    800011be:	2c648493          	addi	s1,s1,710 # 80029480 <proc>
    800011c2:	0002e917          	auipc	s2,0x2e
    800011c6:	cbe90913          	addi	s2,s2,-834 # 8002ee80 <tickslock>
    acquire(&p->lock);
    800011ca:	8526                	mv	a0,s1
    800011cc:	00005097          	auipc	ra,0x5
    800011d0:	0c6080e7          	jalr	198(ra) # 80006292 <acquire>
    if(p->state == UNUSED) {
    800011d4:	4c9c                	lw	a5,24(s1)
    800011d6:	cf81                	beqz	a5,800011ee <allocproc+0x40>
      release(&p->lock);
    800011d8:	8526                	mv	a0,s1
    800011da:	00005097          	auipc	ra,0x5
    800011de:	16c080e7          	jalr	364(ra) # 80006346 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011e2:	16848493          	addi	s1,s1,360
    800011e6:	ff2492e3          	bne	s1,s2,800011ca <allocproc+0x1c>
  return 0;
    800011ea:	4481                	li	s1,0
    800011ec:	a889                	j	8000123e <allocproc+0x90>
  p->pid = allocpid();
    800011ee:	00000097          	auipc	ra,0x0
    800011f2:	e34080e7          	jalr	-460(ra) # 80001022 <allocpid>
    800011f6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800011f8:	4785                	li	a5,1
    800011fa:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011fc:	fffff097          	auipc	ra,0xfffff
    80001200:	fd4080e7          	jalr	-44(ra) # 800001d0 <kalloc>
    80001204:	892a                	mv	s2,a0
    80001206:	eca8                	sd	a0,88(s1)
    80001208:	c131                	beqz	a0,8000124c <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000120a:	8526                	mv	a0,s1
    8000120c:	00000097          	auipc	ra,0x0
    80001210:	e5c080e7          	jalr	-420(ra) # 80001068 <proc_pagetable>
    80001214:	892a                	mv	s2,a0
    80001216:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001218:	c531                	beqz	a0,80001264 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000121a:	07000613          	li	a2,112
    8000121e:	4581                	li	a1,0
    80001220:	06048513          	addi	a0,s1,96
    80001224:	fffff097          	auipc	ra,0xfffff
    80001228:	026080e7          	jalr	38(ra) # 8000024a <memset>
  p->context.ra = (uint64)forkret;
    8000122c:	00000797          	auipc	a5,0x0
    80001230:	db078793          	addi	a5,a5,-592 # 80000fdc <forkret>
    80001234:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001236:	60bc                	ld	a5,64(s1)
    80001238:	6705                	lui	a4,0x1
    8000123a:	97ba                	add	a5,a5,a4
    8000123c:	f4bc                	sd	a5,104(s1)
}
    8000123e:	8526                	mv	a0,s1
    80001240:	60e2                	ld	ra,24(sp)
    80001242:	6442                	ld	s0,16(sp)
    80001244:	64a2                	ld	s1,8(sp)
    80001246:	6902                	ld	s2,0(sp)
    80001248:	6105                	addi	sp,sp,32
    8000124a:	8082                	ret
    freeproc(p);
    8000124c:	8526                	mv	a0,s1
    8000124e:	00000097          	auipc	ra,0x0
    80001252:	f08080e7          	jalr	-248(ra) # 80001156 <freeproc>
    release(&p->lock);
    80001256:	8526                	mv	a0,s1
    80001258:	00005097          	auipc	ra,0x5
    8000125c:	0ee080e7          	jalr	238(ra) # 80006346 <release>
    return 0;
    80001260:	84ca                	mv	s1,s2
    80001262:	bff1                	j	8000123e <allocproc+0x90>
    freeproc(p);
    80001264:	8526                	mv	a0,s1
    80001266:	00000097          	auipc	ra,0x0
    8000126a:	ef0080e7          	jalr	-272(ra) # 80001156 <freeproc>
    release(&p->lock);
    8000126e:	8526                	mv	a0,s1
    80001270:	00005097          	auipc	ra,0x5
    80001274:	0d6080e7          	jalr	214(ra) # 80006346 <release>
    return 0;
    80001278:	84ca                	mv	s1,s2
    8000127a:	b7d1                	j	8000123e <allocproc+0x90>

000000008000127c <userinit>:
{
    8000127c:	1101                	addi	sp,sp,-32
    8000127e:	ec06                	sd	ra,24(sp)
    80001280:	e822                	sd	s0,16(sp)
    80001282:	e426                	sd	s1,8(sp)
    80001284:	1000                	addi	s0,sp,32
  p = allocproc();
    80001286:	00000097          	auipc	ra,0x0
    8000128a:	f28080e7          	jalr	-216(ra) # 800011ae <allocproc>
    8000128e:	84aa                	mv	s1,a0
  initproc = p;
    80001290:	00008797          	auipc	a5,0x8
    80001294:	d8a7b023          	sd	a0,-640(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001298:	03400613          	li	a2,52
    8000129c:	00007597          	auipc	a1,0x7
    800012a0:	5c458593          	addi	a1,a1,1476 # 80008860 <initcode>
    800012a4:	6928                	ld	a0,80(a0)
    800012a6:	fffff097          	auipc	ra,0xfffff
    800012aa:	64e080e7          	jalr	1614(ra) # 800008f4 <uvminit>
  p->sz = PGSIZE;
    800012ae:	6785                	lui	a5,0x1
    800012b0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800012b2:	6cb8                	ld	a4,88(s1)
    800012b4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012b8:	6cb8                	ld	a4,88(s1)
    800012ba:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012bc:	4641                	li	a2,16
    800012be:	00007597          	auipc	a1,0x7
    800012c2:	ef258593          	addi	a1,a1,-270 # 800081b0 <etext+0x1b0>
    800012c6:	15848513          	addi	a0,s1,344
    800012ca:	fffff097          	auipc	ra,0xfffff
    800012ce:	0d2080e7          	jalr	210(ra) # 8000039c <safestrcpy>
  p->cwd = namei("/");
    800012d2:	00007517          	auipc	a0,0x7
    800012d6:	eee50513          	addi	a0,a0,-274 # 800081c0 <etext+0x1c0>
    800012da:	00002097          	auipc	ra,0x2
    800012de:	172080e7          	jalr	370(ra) # 8000344c <namei>
    800012e2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800012e6:	478d                	li	a5,3
    800012e8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800012ea:	8526                	mv	a0,s1
    800012ec:	00005097          	auipc	ra,0x5
    800012f0:	05a080e7          	jalr	90(ra) # 80006346 <release>
}
    800012f4:	60e2                	ld	ra,24(sp)
    800012f6:	6442                	ld	s0,16(sp)
    800012f8:	64a2                	ld	s1,8(sp)
    800012fa:	6105                	addi	sp,sp,32
    800012fc:	8082                	ret

00000000800012fe <growproc>:
{
    800012fe:	1101                	addi	sp,sp,-32
    80001300:	ec06                	sd	ra,24(sp)
    80001302:	e822                	sd	s0,16(sp)
    80001304:	e426                	sd	s1,8(sp)
    80001306:	e04a                	sd	s2,0(sp)
    80001308:	1000                	addi	s0,sp,32
    8000130a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000130c:	00000097          	auipc	ra,0x0
    80001310:	c98080e7          	jalr	-872(ra) # 80000fa4 <myproc>
    80001314:	892a                	mv	s2,a0
  sz = p->sz;
    80001316:	652c                	ld	a1,72(a0)
    80001318:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000131c:	00904f63          	bgtz	s1,8000133a <growproc+0x3c>
  } else if(n < 0){
    80001320:	0204cc63          	bltz	s1,80001358 <growproc+0x5a>
  p->sz = sz;
    80001324:	1602                	slli	a2,a2,0x20
    80001326:	9201                	srli	a2,a2,0x20
    80001328:	04c93423          	sd	a2,72(s2)
  return 0;
    8000132c:	4501                	li	a0,0
}
    8000132e:	60e2                	ld	ra,24(sp)
    80001330:	6442                	ld	s0,16(sp)
    80001332:	64a2                	ld	s1,8(sp)
    80001334:	6902                	ld	s2,0(sp)
    80001336:	6105                	addi	sp,sp,32
    80001338:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000133a:	9e25                	addw	a2,a2,s1
    8000133c:	1602                	slli	a2,a2,0x20
    8000133e:	9201                	srli	a2,a2,0x20
    80001340:	1582                	slli	a1,a1,0x20
    80001342:	9181                	srli	a1,a1,0x20
    80001344:	6928                	ld	a0,80(a0)
    80001346:	fffff097          	auipc	ra,0xfffff
    8000134a:	668080e7          	jalr	1640(ra) # 800009ae <uvmalloc>
    8000134e:	0005061b          	sext.w	a2,a0
    80001352:	fa69                	bnez	a2,80001324 <growproc+0x26>
      return -1;
    80001354:	557d                	li	a0,-1
    80001356:	bfe1                	j	8000132e <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001358:	9e25                	addw	a2,a2,s1
    8000135a:	1602                	slli	a2,a2,0x20
    8000135c:	9201                	srli	a2,a2,0x20
    8000135e:	1582                	slli	a1,a1,0x20
    80001360:	9181                	srli	a1,a1,0x20
    80001362:	6928                	ld	a0,80(a0)
    80001364:	fffff097          	auipc	ra,0xfffff
    80001368:	602080e7          	jalr	1538(ra) # 80000966 <uvmdealloc>
    8000136c:	0005061b          	sext.w	a2,a0
    80001370:	bf55                	j	80001324 <growproc+0x26>

0000000080001372 <fork>:
{
    80001372:	7179                	addi	sp,sp,-48
    80001374:	f406                	sd	ra,40(sp)
    80001376:	f022                	sd	s0,32(sp)
    80001378:	ec26                	sd	s1,24(sp)
    8000137a:	e84a                	sd	s2,16(sp)
    8000137c:	e44e                	sd	s3,8(sp)
    8000137e:	e052                	sd	s4,0(sp)
    80001380:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001382:	00000097          	auipc	ra,0x0
    80001386:	c22080e7          	jalr	-990(ra) # 80000fa4 <myproc>
    8000138a:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000138c:	00000097          	auipc	ra,0x0
    80001390:	e22080e7          	jalr	-478(ra) # 800011ae <allocproc>
    80001394:	10050b63          	beqz	a0,800014aa <fork+0x138>
    80001398:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000139a:	04893603          	ld	a2,72(s2)
    8000139e:	692c                	ld	a1,80(a0)
    800013a0:	05093503          	ld	a0,80(s2)
    800013a4:	fffff097          	auipc	ra,0xfffff
    800013a8:	756080e7          	jalr	1878(ra) # 80000afa <uvmcopy>
    800013ac:	04054663          	bltz	a0,800013f8 <fork+0x86>
  np->sz = p->sz;
    800013b0:	04893783          	ld	a5,72(s2)
    800013b4:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800013b8:	05893683          	ld	a3,88(s2)
    800013bc:	87b6                	mv	a5,a3
    800013be:	0589b703          	ld	a4,88(s3)
    800013c2:	12068693          	addi	a3,a3,288
    800013c6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013ca:	6788                	ld	a0,8(a5)
    800013cc:	6b8c                	ld	a1,16(a5)
    800013ce:	6f90                	ld	a2,24(a5)
    800013d0:	01073023          	sd	a6,0(a4)
    800013d4:	e708                	sd	a0,8(a4)
    800013d6:	eb0c                	sd	a1,16(a4)
    800013d8:	ef10                	sd	a2,24(a4)
    800013da:	02078793          	addi	a5,a5,32
    800013de:	02070713          	addi	a4,a4,32
    800013e2:	fed792e3          	bne	a5,a3,800013c6 <fork+0x54>
  np->trapframe->a0 = 0;
    800013e6:	0589b783          	ld	a5,88(s3)
    800013ea:	0607b823          	sd	zero,112(a5)
    800013ee:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800013f2:	15000a13          	li	s4,336
    800013f6:	a03d                	j	80001424 <fork+0xb2>
    freeproc(np);
    800013f8:	854e                	mv	a0,s3
    800013fa:	00000097          	auipc	ra,0x0
    800013fe:	d5c080e7          	jalr	-676(ra) # 80001156 <freeproc>
    release(&np->lock);
    80001402:	854e                	mv	a0,s3
    80001404:	00005097          	auipc	ra,0x5
    80001408:	f42080e7          	jalr	-190(ra) # 80006346 <release>
    return -1;
    8000140c:	5a7d                	li	s4,-1
    8000140e:	a069                	j	80001498 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001410:	00002097          	auipc	ra,0x2
    80001414:	6d2080e7          	jalr	1746(ra) # 80003ae2 <filedup>
    80001418:	009987b3          	add	a5,s3,s1
    8000141c:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000141e:	04a1                	addi	s1,s1,8
    80001420:	01448763          	beq	s1,s4,8000142e <fork+0xbc>
    if(p->ofile[i])
    80001424:	009907b3          	add	a5,s2,s1
    80001428:	6388                	ld	a0,0(a5)
    8000142a:	f17d                	bnez	a0,80001410 <fork+0x9e>
    8000142c:	bfcd                	j	8000141e <fork+0xac>
  np->cwd = idup(p->cwd);
    8000142e:	15093503          	ld	a0,336(s2)
    80001432:	00002097          	auipc	ra,0x2
    80001436:	826080e7          	jalr	-2010(ra) # 80002c58 <idup>
    8000143a:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000143e:	4641                	li	a2,16
    80001440:	15890593          	addi	a1,s2,344
    80001444:	15898513          	addi	a0,s3,344
    80001448:	fffff097          	auipc	ra,0xfffff
    8000144c:	f54080e7          	jalr	-172(ra) # 8000039c <safestrcpy>
  pid = np->pid;
    80001450:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001454:	854e                	mv	a0,s3
    80001456:	00005097          	auipc	ra,0x5
    8000145a:	ef0080e7          	jalr	-272(ra) # 80006346 <release>
  acquire(&wait_lock);
    8000145e:	00028497          	auipc	s1,0x28
    80001462:	c0a48493          	addi	s1,s1,-1014 # 80029068 <wait_lock>
    80001466:	8526                	mv	a0,s1
    80001468:	00005097          	auipc	ra,0x5
    8000146c:	e2a080e7          	jalr	-470(ra) # 80006292 <acquire>
  np->parent = p;
    80001470:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001474:	8526                	mv	a0,s1
    80001476:	00005097          	auipc	ra,0x5
    8000147a:	ed0080e7          	jalr	-304(ra) # 80006346 <release>
  acquire(&np->lock);
    8000147e:	854e                	mv	a0,s3
    80001480:	00005097          	auipc	ra,0x5
    80001484:	e12080e7          	jalr	-494(ra) # 80006292 <acquire>
  np->state = RUNNABLE;
    80001488:	478d                	li	a5,3
    8000148a:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000148e:	854e                	mv	a0,s3
    80001490:	00005097          	auipc	ra,0x5
    80001494:	eb6080e7          	jalr	-330(ra) # 80006346 <release>
}
    80001498:	8552                	mv	a0,s4
    8000149a:	70a2                	ld	ra,40(sp)
    8000149c:	7402                	ld	s0,32(sp)
    8000149e:	64e2                	ld	s1,24(sp)
    800014a0:	6942                	ld	s2,16(sp)
    800014a2:	69a2                	ld	s3,8(sp)
    800014a4:	6a02                	ld	s4,0(sp)
    800014a6:	6145                	addi	sp,sp,48
    800014a8:	8082                	ret
    return -1;
    800014aa:	5a7d                	li	s4,-1
    800014ac:	b7f5                	j	80001498 <fork+0x126>

00000000800014ae <scheduler>:
{
    800014ae:	7139                	addi	sp,sp,-64
    800014b0:	fc06                	sd	ra,56(sp)
    800014b2:	f822                	sd	s0,48(sp)
    800014b4:	f426                	sd	s1,40(sp)
    800014b6:	f04a                	sd	s2,32(sp)
    800014b8:	ec4e                	sd	s3,24(sp)
    800014ba:	e852                	sd	s4,16(sp)
    800014bc:	e456                	sd	s5,8(sp)
    800014be:	e05a                	sd	s6,0(sp)
    800014c0:	0080                	addi	s0,sp,64
    800014c2:	8792                	mv	a5,tp
  int id = r_tp();
    800014c4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014c6:	00779a93          	slli	s5,a5,0x7
    800014ca:	00028717          	auipc	a4,0x28
    800014ce:	b8670713          	addi	a4,a4,-1146 # 80029050 <pid_lock>
    800014d2:	9756                	add	a4,a4,s5
    800014d4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800014d8:	00028717          	auipc	a4,0x28
    800014dc:	bb070713          	addi	a4,a4,-1104 # 80029088 <cpus+0x8>
    800014e0:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800014e2:	498d                	li	s3,3
        p->state = RUNNING;
    800014e4:	4b11                	li	s6,4
        c->proc = p;
    800014e6:	079e                	slli	a5,a5,0x7
    800014e8:	00028a17          	auipc	s4,0x28
    800014ec:	b68a0a13          	addi	s4,s4,-1176 # 80029050 <pid_lock>
    800014f0:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014f2:	0002e917          	auipc	s2,0x2e
    800014f6:	98e90913          	addi	s2,s2,-1650 # 8002ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014fa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014fe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001502:	10079073          	csrw	sstatus,a5
    80001506:	00028497          	auipc	s1,0x28
    8000150a:	f7a48493          	addi	s1,s1,-134 # 80029480 <proc>
    8000150e:	a03d                	j	8000153c <scheduler+0x8e>
        p->state = RUNNING;
    80001510:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001514:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001518:	06048593          	addi	a1,s1,96
    8000151c:	8556                	mv	a0,s5
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	640080e7          	jalr	1600(ra) # 80001b5e <swtch>
        c->proc = 0;
    80001526:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000152a:	8526                	mv	a0,s1
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	e1a080e7          	jalr	-486(ra) # 80006346 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001534:	16848493          	addi	s1,s1,360
    80001538:	fd2481e3          	beq	s1,s2,800014fa <scheduler+0x4c>
      acquire(&p->lock);
    8000153c:	8526                	mv	a0,s1
    8000153e:	00005097          	auipc	ra,0x5
    80001542:	d54080e7          	jalr	-684(ra) # 80006292 <acquire>
      if(p->state == RUNNABLE) {
    80001546:	4c9c                	lw	a5,24(s1)
    80001548:	ff3791e3          	bne	a5,s3,8000152a <scheduler+0x7c>
    8000154c:	b7d1                	j	80001510 <scheduler+0x62>

000000008000154e <sched>:
{
    8000154e:	7179                	addi	sp,sp,-48
    80001550:	f406                	sd	ra,40(sp)
    80001552:	f022                	sd	s0,32(sp)
    80001554:	ec26                	sd	s1,24(sp)
    80001556:	e84a                	sd	s2,16(sp)
    80001558:	e44e                	sd	s3,8(sp)
    8000155a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000155c:	00000097          	auipc	ra,0x0
    80001560:	a48080e7          	jalr	-1464(ra) # 80000fa4 <myproc>
    80001564:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001566:	00005097          	auipc	ra,0x5
    8000156a:	cb2080e7          	jalr	-846(ra) # 80006218 <holding>
    8000156e:	c93d                	beqz	a0,800015e4 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001570:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001572:	2781                	sext.w	a5,a5
    80001574:	079e                	slli	a5,a5,0x7
    80001576:	00028717          	auipc	a4,0x28
    8000157a:	ada70713          	addi	a4,a4,-1318 # 80029050 <pid_lock>
    8000157e:	97ba                	add	a5,a5,a4
    80001580:	0a87a703          	lw	a4,168(a5)
    80001584:	4785                	li	a5,1
    80001586:	06f71763          	bne	a4,a5,800015f4 <sched+0xa6>
  if(p->state == RUNNING)
    8000158a:	4c98                	lw	a4,24(s1)
    8000158c:	4791                	li	a5,4
    8000158e:	06f70b63          	beq	a4,a5,80001604 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001592:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001596:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001598:	efb5                	bnez	a5,80001614 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000159a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000159c:	00028917          	auipc	s2,0x28
    800015a0:	ab490913          	addi	s2,s2,-1356 # 80029050 <pid_lock>
    800015a4:	2781                	sext.w	a5,a5
    800015a6:	079e                	slli	a5,a5,0x7
    800015a8:	97ca                	add	a5,a5,s2
    800015aa:	0ac7a983          	lw	s3,172(a5)
    800015ae:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015b0:	2781                	sext.w	a5,a5
    800015b2:	079e                	slli	a5,a5,0x7
    800015b4:	00028597          	auipc	a1,0x28
    800015b8:	ad458593          	addi	a1,a1,-1324 # 80029088 <cpus+0x8>
    800015bc:	95be                	add	a1,a1,a5
    800015be:	06048513          	addi	a0,s1,96
    800015c2:	00000097          	auipc	ra,0x0
    800015c6:	59c080e7          	jalr	1436(ra) # 80001b5e <swtch>
    800015ca:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015cc:	2781                	sext.w	a5,a5
    800015ce:	079e                	slli	a5,a5,0x7
    800015d0:	97ca                	add	a5,a5,s2
    800015d2:	0b37a623          	sw	s3,172(a5)
}
    800015d6:	70a2                	ld	ra,40(sp)
    800015d8:	7402                	ld	s0,32(sp)
    800015da:	64e2                	ld	s1,24(sp)
    800015dc:	6942                	ld	s2,16(sp)
    800015de:	69a2                	ld	s3,8(sp)
    800015e0:	6145                	addi	sp,sp,48
    800015e2:	8082                	ret
    panic("sched p->lock");
    800015e4:	00007517          	auipc	a0,0x7
    800015e8:	be450513          	addi	a0,a0,-1052 # 800081c8 <etext+0x1c8>
    800015ec:	00004097          	auipc	ra,0x4
    800015f0:	75c080e7          	jalr	1884(ra) # 80005d48 <panic>
    panic("sched locks");
    800015f4:	00007517          	auipc	a0,0x7
    800015f8:	be450513          	addi	a0,a0,-1052 # 800081d8 <etext+0x1d8>
    800015fc:	00004097          	auipc	ra,0x4
    80001600:	74c080e7          	jalr	1868(ra) # 80005d48 <panic>
    panic("sched running");
    80001604:	00007517          	auipc	a0,0x7
    80001608:	be450513          	addi	a0,a0,-1052 # 800081e8 <etext+0x1e8>
    8000160c:	00004097          	auipc	ra,0x4
    80001610:	73c080e7          	jalr	1852(ra) # 80005d48 <panic>
    panic("sched interruptible");
    80001614:	00007517          	auipc	a0,0x7
    80001618:	be450513          	addi	a0,a0,-1052 # 800081f8 <etext+0x1f8>
    8000161c:	00004097          	auipc	ra,0x4
    80001620:	72c080e7          	jalr	1836(ra) # 80005d48 <panic>

0000000080001624 <yield>:
{
    80001624:	1101                	addi	sp,sp,-32
    80001626:	ec06                	sd	ra,24(sp)
    80001628:	e822                	sd	s0,16(sp)
    8000162a:	e426                	sd	s1,8(sp)
    8000162c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000162e:	00000097          	auipc	ra,0x0
    80001632:	976080e7          	jalr	-1674(ra) # 80000fa4 <myproc>
    80001636:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001638:	00005097          	auipc	ra,0x5
    8000163c:	c5a080e7          	jalr	-934(ra) # 80006292 <acquire>
  p->state = RUNNABLE;
    80001640:	478d                	li	a5,3
    80001642:	cc9c                	sw	a5,24(s1)
  sched();
    80001644:	00000097          	auipc	ra,0x0
    80001648:	f0a080e7          	jalr	-246(ra) # 8000154e <sched>
  release(&p->lock);
    8000164c:	8526                	mv	a0,s1
    8000164e:	00005097          	auipc	ra,0x5
    80001652:	cf8080e7          	jalr	-776(ra) # 80006346 <release>
}
    80001656:	60e2                	ld	ra,24(sp)
    80001658:	6442                	ld	s0,16(sp)
    8000165a:	64a2                	ld	s1,8(sp)
    8000165c:	6105                	addi	sp,sp,32
    8000165e:	8082                	ret

0000000080001660 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001660:	7179                	addi	sp,sp,-48
    80001662:	f406                	sd	ra,40(sp)
    80001664:	f022                	sd	s0,32(sp)
    80001666:	ec26                	sd	s1,24(sp)
    80001668:	e84a                	sd	s2,16(sp)
    8000166a:	e44e                	sd	s3,8(sp)
    8000166c:	1800                	addi	s0,sp,48
    8000166e:	89aa                	mv	s3,a0
    80001670:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001672:	00000097          	auipc	ra,0x0
    80001676:	932080e7          	jalr	-1742(ra) # 80000fa4 <myproc>
    8000167a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000167c:	00005097          	auipc	ra,0x5
    80001680:	c16080e7          	jalr	-1002(ra) # 80006292 <acquire>
  release(lk);
    80001684:	854a                	mv	a0,s2
    80001686:	00005097          	auipc	ra,0x5
    8000168a:	cc0080e7          	jalr	-832(ra) # 80006346 <release>

  // Go to sleep.
  p->chan = chan;
    8000168e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001692:	4789                	li	a5,2
    80001694:	cc9c                	sw	a5,24(s1)

  sched();
    80001696:	00000097          	auipc	ra,0x0
    8000169a:	eb8080e7          	jalr	-328(ra) # 8000154e <sched>

  // Tidy up.
  p->chan = 0;
    8000169e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016a2:	8526                	mv	a0,s1
    800016a4:	00005097          	auipc	ra,0x5
    800016a8:	ca2080e7          	jalr	-862(ra) # 80006346 <release>
  acquire(lk);
    800016ac:	854a                	mv	a0,s2
    800016ae:	00005097          	auipc	ra,0x5
    800016b2:	be4080e7          	jalr	-1052(ra) # 80006292 <acquire>
}
    800016b6:	70a2                	ld	ra,40(sp)
    800016b8:	7402                	ld	s0,32(sp)
    800016ba:	64e2                	ld	s1,24(sp)
    800016bc:	6942                	ld	s2,16(sp)
    800016be:	69a2                	ld	s3,8(sp)
    800016c0:	6145                	addi	sp,sp,48
    800016c2:	8082                	ret

00000000800016c4 <wait>:
{
    800016c4:	715d                	addi	sp,sp,-80
    800016c6:	e486                	sd	ra,72(sp)
    800016c8:	e0a2                	sd	s0,64(sp)
    800016ca:	fc26                	sd	s1,56(sp)
    800016cc:	f84a                	sd	s2,48(sp)
    800016ce:	f44e                	sd	s3,40(sp)
    800016d0:	f052                	sd	s4,32(sp)
    800016d2:	ec56                	sd	s5,24(sp)
    800016d4:	e85a                	sd	s6,16(sp)
    800016d6:	e45e                	sd	s7,8(sp)
    800016d8:	e062                	sd	s8,0(sp)
    800016da:	0880                	addi	s0,sp,80
    800016dc:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016de:	00000097          	auipc	ra,0x0
    800016e2:	8c6080e7          	jalr	-1850(ra) # 80000fa4 <myproc>
    800016e6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016e8:	00028517          	auipc	a0,0x28
    800016ec:	98050513          	addi	a0,a0,-1664 # 80029068 <wait_lock>
    800016f0:	00005097          	auipc	ra,0x5
    800016f4:	ba2080e7          	jalr	-1118(ra) # 80006292 <acquire>
    havekids = 0;
    800016f8:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800016fa:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800016fc:	0002d997          	auipc	s3,0x2d
    80001700:	78498993          	addi	s3,s3,1924 # 8002ee80 <tickslock>
        havekids = 1;
    80001704:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001706:	00028c17          	auipc	s8,0x28
    8000170a:	962c0c13          	addi	s8,s8,-1694 # 80029068 <wait_lock>
    havekids = 0;
    8000170e:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001710:	00028497          	auipc	s1,0x28
    80001714:	d7048493          	addi	s1,s1,-656 # 80029480 <proc>
    80001718:	a0bd                	j	80001786 <wait+0xc2>
          pid = np->pid;
    8000171a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000171e:	000b0e63          	beqz	s6,8000173a <wait+0x76>
    80001722:	4691                	li	a3,4
    80001724:	02c48613          	addi	a2,s1,44
    80001728:	85da                	mv	a1,s6
    8000172a:	05093503          	ld	a0,80(s2)
    8000172e:	fffff097          	auipc	ra,0xfffff
    80001732:	4be080e7          	jalr	1214(ra) # 80000bec <copyout>
    80001736:	02054563          	bltz	a0,80001760 <wait+0x9c>
          freeproc(np);
    8000173a:	8526                	mv	a0,s1
    8000173c:	00000097          	auipc	ra,0x0
    80001740:	a1a080e7          	jalr	-1510(ra) # 80001156 <freeproc>
          release(&np->lock);
    80001744:	8526                	mv	a0,s1
    80001746:	00005097          	auipc	ra,0x5
    8000174a:	c00080e7          	jalr	-1024(ra) # 80006346 <release>
          release(&wait_lock);
    8000174e:	00028517          	auipc	a0,0x28
    80001752:	91a50513          	addi	a0,a0,-1766 # 80029068 <wait_lock>
    80001756:	00005097          	auipc	ra,0x5
    8000175a:	bf0080e7          	jalr	-1040(ra) # 80006346 <release>
          return pid;
    8000175e:	a09d                	j	800017c4 <wait+0x100>
            release(&np->lock);
    80001760:	8526                	mv	a0,s1
    80001762:	00005097          	auipc	ra,0x5
    80001766:	be4080e7          	jalr	-1052(ra) # 80006346 <release>
            release(&wait_lock);
    8000176a:	00028517          	auipc	a0,0x28
    8000176e:	8fe50513          	addi	a0,a0,-1794 # 80029068 <wait_lock>
    80001772:	00005097          	auipc	ra,0x5
    80001776:	bd4080e7          	jalr	-1068(ra) # 80006346 <release>
            return -1;
    8000177a:	59fd                	li	s3,-1
    8000177c:	a0a1                	j	800017c4 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000177e:	16848493          	addi	s1,s1,360
    80001782:	03348463          	beq	s1,s3,800017aa <wait+0xe6>
      if(np->parent == p){
    80001786:	7c9c                	ld	a5,56(s1)
    80001788:	ff279be3          	bne	a5,s2,8000177e <wait+0xba>
        acquire(&np->lock);
    8000178c:	8526                	mv	a0,s1
    8000178e:	00005097          	auipc	ra,0x5
    80001792:	b04080e7          	jalr	-1276(ra) # 80006292 <acquire>
        if(np->state == ZOMBIE){
    80001796:	4c9c                	lw	a5,24(s1)
    80001798:	f94781e3          	beq	a5,s4,8000171a <wait+0x56>
        release(&np->lock);
    8000179c:	8526                	mv	a0,s1
    8000179e:	00005097          	auipc	ra,0x5
    800017a2:	ba8080e7          	jalr	-1112(ra) # 80006346 <release>
        havekids = 1;
    800017a6:	8756                	mv	a4,s5
    800017a8:	bfd9                	j	8000177e <wait+0xba>
    if(!havekids || p->killed){
    800017aa:	c701                	beqz	a4,800017b2 <wait+0xee>
    800017ac:	02892783          	lw	a5,40(s2)
    800017b0:	c79d                	beqz	a5,800017de <wait+0x11a>
      release(&wait_lock);
    800017b2:	00028517          	auipc	a0,0x28
    800017b6:	8b650513          	addi	a0,a0,-1866 # 80029068 <wait_lock>
    800017ba:	00005097          	auipc	ra,0x5
    800017be:	b8c080e7          	jalr	-1140(ra) # 80006346 <release>
      return -1;
    800017c2:	59fd                	li	s3,-1
}
    800017c4:	854e                	mv	a0,s3
    800017c6:	60a6                	ld	ra,72(sp)
    800017c8:	6406                	ld	s0,64(sp)
    800017ca:	74e2                	ld	s1,56(sp)
    800017cc:	7942                	ld	s2,48(sp)
    800017ce:	79a2                	ld	s3,40(sp)
    800017d0:	7a02                	ld	s4,32(sp)
    800017d2:	6ae2                	ld	s5,24(sp)
    800017d4:	6b42                	ld	s6,16(sp)
    800017d6:	6ba2                	ld	s7,8(sp)
    800017d8:	6c02                	ld	s8,0(sp)
    800017da:	6161                	addi	sp,sp,80
    800017dc:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017de:	85e2                	mv	a1,s8
    800017e0:	854a                	mv	a0,s2
    800017e2:	00000097          	auipc	ra,0x0
    800017e6:	e7e080e7          	jalr	-386(ra) # 80001660 <sleep>
    havekids = 0;
    800017ea:	b715                	j	8000170e <wait+0x4a>

00000000800017ec <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800017ec:	7139                	addi	sp,sp,-64
    800017ee:	fc06                	sd	ra,56(sp)
    800017f0:	f822                	sd	s0,48(sp)
    800017f2:	f426                	sd	s1,40(sp)
    800017f4:	f04a                	sd	s2,32(sp)
    800017f6:	ec4e                	sd	s3,24(sp)
    800017f8:	e852                	sd	s4,16(sp)
    800017fa:	e456                	sd	s5,8(sp)
    800017fc:	0080                	addi	s0,sp,64
    800017fe:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001800:	00028497          	auipc	s1,0x28
    80001804:	c8048493          	addi	s1,s1,-896 # 80029480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001808:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000180a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000180c:	0002d917          	auipc	s2,0x2d
    80001810:	67490913          	addi	s2,s2,1652 # 8002ee80 <tickslock>
    80001814:	a821                	j	8000182c <wakeup+0x40>
        p->state = RUNNABLE;
    80001816:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    8000181a:	8526                	mv	a0,s1
    8000181c:	00005097          	auipc	ra,0x5
    80001820:	b2a080e7          	jalr	-1238(ra) # 80006346 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001824:	16848493          	addi	s1,s1,360
    80001828:	03248463          	beq	s1,s2,80001850 <wakeup+0x64>
    if(p != myproc()){
    8000182c:	fffff097          	auipc	ra,0xfffff
    80001830:	778080e7          	jalr	1912(ra) # 80000fa4 <myproc>
    80001834:	fea488e3          	beq	s1,a0,80001824 <wakeup+0x38>
      acquire(&p->lock);
    80001838:	8526                	mv	a0,s1
    8000183a:	00005097          	auipc	ra,0x5
    8000183e:	a58080e7          	jalr	-1448(ra) # 80006292 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001842:	4c9c                	lw	a5,24(s1)
    80001844:	fd379be3          	bne	a5,s3,8000181a <wakeup+0x2e>
    80001848:	709c                	ld	a5,32(s1)
    8000184a:	fd4798e3          	bne	a5,s4,8000181a <wakeup+0x2e>
    8000184e:	b7e1                	j	80001816 <wakeup+0x2a>
    }
  }
}
    80001850:	70e2                	ld	ra,56(sp)
    80001852:	7442                	ld	s0,48(sp)
    80001854:	74a2                	ld	s1,40(sp)
    80001856:	7902                	ld	s2,32(sp)
    80001858:	69e2                	ld	s3,24(sp)
    8000185a:	6a42                	ld	s4,16(sp)
    8000185c:	6aa2                	ld	s5,8(sp)
    8000185e:	6121                	addi	sp,sp,64
    80001860:	8082                	ret

0000000080001862 <reparent>:
{
    80001862:	7179                	addi	sp,sp,-48
    80001864:	f406                	sd	ra,40(sp)
    80001866:	f022                	sd	s0,32(sp)
    80001868:	ec26                	sd	s1,24(sp)
    8000186a:	e84a                	sd	s2,16(sp)
    8000186c:	e44e                	sd	s3,8(sp)
    8000186e:	e052                	sd	s4,0(sp)
    80001870:	1800                	addi	s0,sp,48
    80001872:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001874:	00028497          	auipc	s1,0x28
    80001878:	c0c48493          	addi	s1,s1,-1012 # 80029480 <proc>
      pp->parent = initproc;
    8000187c:	00007a17          	auipc	s4,0x7
    80001880:	794a0a13          	addi	s4,s4,1940 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001884:	0002d997          	auipc	s3,0x2d
    80001888:	5fc98993          	addi	s3,s3,1532 # 8002ee80 <tickslock>
    8000188c:	a029                	j	80001896 <reparent+0x34>
    8000188e:	16848493          	addi	s1,s1,360
    80001892:	01348d63          	beq	s1,s3,800018ac <reparent+0x4a>
    if(pp->parent == p){
    80001896:	7c9c                	ld	a5,56(s1)
    80001898:	ff279be3          	bne	a5,s2,8000188e <reparent+0x2c>
      pp->parent = initproc;
    8000189c:	000a3503          	ld	a0,0(s4)
    800018a0:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800018a2:	00000097          	auipc	ra,0x0
    800018a6:	f4a080e7          	jalr	-182(ra) # 800017ec <wakeup>
    800018aa:	b7d5                	j	8000188e <reparent+0x2c>
}
    800018ac:	70a2                	ld	ra,40(sp)
    800018ae:	7402                	ld	s0,32(sp)
    800018b0:	64e2                	ld	s1,24(sp)
    800018b2:	6942                	ld	s2,16(sp)
    800018b4:	69a2                	ld	s3,8(sp)
    800018b6:	6a02                	ld	s4,0(sp)
    800018b8:	6145                	addi	sp,sp,48
    800018ba:	8082                	ret

00000000800018bc <exit>:
{
    800018bc:	7179                	addi	sp,sp,-48
    800018be:	f406                	sd	ra,40(sp)
    800018c0:	f022                	sd	s0,32(sp)
    800018c2:	ec26                	sd	s1,24(sp)
    800018c4:	e84a                	sd	s2,16(sp)
    800018c6:	e44e                	sd	s3,8(sp)
    800018c8:	e052                	sd	s4,0(sp)
    800018ca:	1800                	addi	s0,sp,48
    800018cc:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800018ce:	fffff097          	auipc	ra,0xfffff
    800018d2:	6d6080e7          	jalr	1750(ra) # 80000fa4 <myproc>
    800018d6:	89aa                	mv	s3,a0
  if(p == initproc)
    800018d8:	00007797          	auipc	a5,0x7
    800018dc:	7387b783          	ld	a5,1848(a5) # 80009010 <initproc>
    800018e0:	0d050493          	addi	s1,a0,208
    800018e4:	15050913          	addi	s2,a0,336
    800018e8:	02a79363          	bne	a5,a0,8000190e <exit+0x52>
    panic("init exiting");
    800018ec:	00007517          	auipc	a0,0x7
    800018f0:	92450513          	addi	a0,a0,-1756 # 80008210 <etext+0x210>
    800018f4:	00004097          	auipc	ra,0x4
    800018f8:	454080e7          	jalr	1108(ra) # 80005d48 <panic>
      fileclose(f);
    800018fc:	00002097          	auipc	ra,0x2
    80001900:	238080e7          	jalr	568(ra) # 80003b34 <fileclose>
      p->ofile[fd] = 0;
    80001904:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001908:	04a1                	addi	s1,s1,8
    8000190a:	01248563          	beq	s1,s2,80001914 <exit+0x58>
    if(p->ofile[fd]){
    8000190e:	6088                	ld	a0,0(s1)
    80001910:	f575                	bnez	a0,800018fc <exit+0x40>
    80001912:	bfdd                	j	80001908 <exit+0x4c>
  begin_op();
    80001914:	00002097          	auipc	ra,0x2
    80001918:	d54080e7          	jalr	-684(ra) # 80003668 <begin_op>
  iput(p->cwd);
    8000191c:	1509b503          	ld	a0,336(s3)
    80001920:	00001097          	auipc	ra,0x1
    80001924:	530080e7          	jalr	1328(ra) # 80002e50 <iput>
  end_op();
    80001928:	00002097          	auipc	ra,0x2
    8000192c:	dc0080e7          	jalr	-576(ra) # 800036e8 <end_op>
  p->cwd = 0;
    80001930:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001934:	00027497          	auipc	s1,0x27
    80001938:	73448493          	addi	s1,s1,1844 # 80029068 <wait_lock>
    8000193c:	8526                	mv	a0,s1
    8000193e:	00005097          	auipc	ra,0x5
    80001942:	954080e7          	jalr	-1708(ra) # 80006292 <acquire>
  reparent(p);
    80001946:	854e                	mv	a0,s3
    80001948:	00000097          	auipc	ra,0x0
    8000194c:	f1a080e7          	jalr	-230(ra) # 80001862 <reparent>
  wakeup(p->parent);
    80001950:	0389b503          	ld	a0,56(s3)
    80001954:	00000097          	auipc	ra,0x0
    80001958:	e98080e7          	jalr	-360(ra) # 800017ec <wakeup>
  acquire(&p->lock);
    8000195c:	854e                	mv	a0,s3
    8000195e:	00005097          	auipc	ra,0x5
    80001962:	934080e7          	jalr	-1740(ra) # 80006292 <acquire>
  p->xstate = status;
    80001966:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000196a:	4795                	li	a5,5
    8000196c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001970:	8526                	mv	a0,s1
    80001972:	00005097          	auipc	ra,0x5
    80001976:	9d4080e7          	jalr	-1580(ra) # 80006346 <release>
  sched();
    8000197a:	00000097          	auipc	ra,0x0
    8000197e:	bd4080e7          	jalr	-1068(ra) # 8000154e <sched>
  panic("zombie exit");
    80001982:	00007517          	auipc	a0,0x7
    80001986:	89e50513          	addi	a0,a0,-1890 # 80008220 <etext+0x220>
    8000198a:	00004097          	auipc	ra,0x4
    8000198e:	3be080e7          	jalr	958(ra) # 80005d48 <panic>

0000000080001992 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001992:	7179                	addi	sp,sp,-48
    80001994:	f406                	sd	ra,40(sp)
    80001996:	f022                	sd	s0,32(sp)
    80001998:	ec26                	sd	s1,24(sp)
    8000199a:	e84a                	sd	s2,16(sp)
    8000199c:	e44e                	sd	s3,8(sp)
    8000199e:	1800                	addi	s0,sp,48
    800019a0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800019a2:	00028497          	auipc	s1,0x28
    800019a6:	ade48493          	addi	s1,s1,-1314 # 80029480 <proc>
    800019aa:	0002d997          	auipc	s3,0x2d
    800019ae:	4d698993          	addi	s3,s3,1238 # 8002ee80 <tickslock>
    acquire(&p->lock);
    800019b2:	8526                	mv	a0,s1
    800019b4:	00005097          	auipc	ra,0x5
    800019b8:	8de080e7          	jalr	-1826(ra) # 80006292 <acquire>
    if(p->pid == pid){
    800019bc:	589c                	lw	a5,48(s1)
    800019be:	01278d63          	beq	a5,s2,800019d8 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019c2:	8526                	mv	a0,s1
    800019c4:	00005097          	auipc	ra,0x5
    800019c8:	982080e7          	jalr	-1662(ra) # 80006346 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800019cc:	16848493          	addi	s1,s1,360
    800019d0:	ff3491e3          	bne	s1,s3,800019b2 <kill+0x20>
  }
  return -1;
    800019d4:	557d                	li	a0,-1
    800019d6:	a829                	j	800019f0 <kill+0x5e>
      p->killed = 1;
    800019d8:	4785                	li	a5,1
    800019da:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800019dc:	4c98                	lw	a4,24(s1)
    800019de:	4789                	li	a5,2
    800019e0:	00f70f63          	beq	a4,a5,800019fe <kill+0x6c>
      release(&p->lock);
    800019e4:	8526                	mv	a0,s1
    800019e6:	00005097          	auipc	ra,0x5
    800019ea:	960080e7          	jalr	-1696(ra) # 80006346 <release>
      return 0;
    800019ee:	4501                	li	a0,0
}
    800019f0:	70a2                	ld	ra,40(sp)
    800019f2:	7402                	ld	s0,32(sp)
    800019f4:	64e2                	ld	s1,24(sp)
    800019f6:	6942                	ld	s2,16(sp)
    800019f8:	69a2                	ld	s3,8(sp)
    800019fa:	6145                	addi	sp,sp,48
    800019fc:	8082                	ret
        p->state = RUNNABLE;
    800019fe:	478d                	li	a5,3
    80001a00:	cc9c                	sw	a5,24(s1)
    80001a02:	b7cd                	j	800019e4 <kill+0x52>

0000000080001a04 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a04:	7179                	addi	sp,sp,-48
    80001a06:	f406                	sd	ra,40(sp)
    80001a08:	f022                	sd	s0,32(sp)
    80001a0a:	ec26                	sd	s1,24(sp)
    80001a0c:	e84a                	sd	s2,16(sp)
    80001a0e:	e44e                	sd	s3,8(sp)
    80001a10:	e052                	sd	s4,0(sp)
    80001a12:	1800                	addi	s0,sp,48
    80001a14:	84aa                	mv	s1,a0
    80001a16:	892e                	mv	s2,a1
    80001a18:	89b2                	mv	s3,a2
    80001a1a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a1c:	fffff097          	auipc	ra,0xfffff
    80001a20:	588080e7          	jalr	1416(ra) # 80000fa4 <myproc>
  if(user_dst){
    80001a24:	c08d                	beqz	s1,80001a46 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a26:	86d2                	mv	a3,s4
    80001a28:	864e                	mv	a2,s3
    80001a2a:	85ca                	mv	a1,s2
    80001a2c:	6928                	ld	a0,80(a0)
    80001a2e:	fffff097          	auipc	ra,0xfffff
    80001a32:	1be080e7          	jalr	446(ra) # 80000bec <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a36:	70a2                	ld	ra,40(sp)
    80001a38:	7402                	ld	s0,32(sp)
    80001a3a:	64e2                	ld	s1,24(sp)
    80001a3c:	6942                	ld	s2,16(sp)
    80001a3e:	69a2                	ld	s3,8(sp)
    80001a40:	6a02                	ld	s4,0(sp)
    80001a42:	6145                	addi	sp,sp,48
    80001a44:	8082                	ret
    memmove((char *)dst, src, len);
    80001a46:	000a061b          	sext.w	a2,s4
    80001a4a:	85ce                	mv	a1,s3
    80001a4c:	854a                	mv	a0,s2
    80001a4e:	fffff097          	auipc	ra,0xfffff
    80001a52:	85c080e7          	jalr	-1956(ra) # 800002aa <memmove>
    return 0;
    80001a56:	8526                	mv	a0,s1
    80001a58:	bff9                	j	80001a36 <either_copyout+0x32>

0000000080001a5a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a5a:	7179                	addi	sp,sp,-48
    80001a5c:	f406                	sd	ra,40(sp)
    80001a5e:	f022                	sd	s0,32(sp)
    80001a60:	ec26                	sd	s1,24(sp)
    80001a62:	e84a                	sd	s2,16(sp)
    80001a64:	e44e                	sd	s3,8(sp)
    80001a66:	e052                	sd	s4,0(sp)
    80001a68:	1800                	addi	s0,sp,48
    80001a6a:	892a                	mv	s2,a0
    80001a6c:	84ae                	mv	s1,a1
    80001a6e:	89b2                	mv	s3,a2
    80001a70:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a72:	fffff097          	auipc	ra,0xfffff
    80001a76:	532080e7          	jalr	1330(ra) # 80000fa4 <myproc>
  if(user_src){
    80001a7a:	c08d                	beqz	s1,80001a9c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a7c:	86d2                	mv	a3,s4
    80001a7e:	864e                	mv	a2,s3
    80001a80:	85ca                	mv	a1,s2
    80001a82:	6928                	ld	a0,80(a0)
    80001a84:	fffff097          	auipc	ra,0xfffff
    80001a88:	26e080e7          	jalr	622(ra) # 80000cf2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a8c:	70a2                	ld	ra,40(sp)
    80001a8e:	7402                	ld	s0,32(sp)
    80001a90:	64e2                	ld	s1,24(sp)
    80001a92:	6942                	ld	s2,16(sp)
    80001a94:	69a2                	ld	s3,8(sp)
    80001a96:	6a02                	ld	s4,0(sp)
    80001a98:	6145                	addi	sp,sp,48
    80001a9a:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a9c:	000a061b          	sext.w	a2,s4
    80001aa0:	85ce                	mv	a1,s3
    80001aa2:	854a                	mv	a0,s2
    80001aa4:	fffff097          	auipc	ra,0xfffff
    80001aa8:	806080e7          	jalr	-2042(ra) # 800002aa <memmove>
    return 0;
    80001aac:	8526                	mv	a0,s1
    80001aae:	bff9                	j	80001a8c <either_copyin+0x32>

0000000080001ab0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001ab0:	715d                	addi	sp,sp,-80
    80001ab2:	e486                	sd	ra,72(sp)
    80001ab4:	e0a2                	sd	s0,64(sp)
    80001ab6:	fc26                	sd	s1,56(sp)
    80001ab8:	f84a                	sd	s2,48(sp)
    80001aba:	f44e                	sd	s3,40(sp)
    80001abc:	f052                	sd	s4,32(sp)
    80001abe:	ec56                	sd	s5,24(sp)
    80001ac0:	e85a                	sd	s6,16(sp)
    80001ac2:	e45e                	sd	s7,8(sp)
    80001ac4:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001ac6:	00006517          	auipc	a0,0x6
    80001aca:	59250513          	addi	a0,a0,1426 # 80008058 <etext+0x58>
    80001ace:	00004097          	auipc	ra,0x4
    80001ad2:	2c4080e7          	jalr	708(ra) # 80005d92 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ad6:	00028497          	auipc	s1,0x28
    80001ada:	b0248493          	addi	s1,s1,-1278 # 800295d8 <proc+0x158>
    80001ade:	0002d917          	auipc	s2,0x2d
    80001ae2:	4fa90913          	addi	s2,s2,1274 # 8002efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ae6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001ae8:	00006997          	auipc	s3,0x6
    80001aec:	74898993          	addi	s3,s3,1864 # 80008230 <etext+0x230>
    printf("%d %s %s", p->pid, state, p->name);
    80001af0:	00006a97          	auipc	s5,0x6
    80001af4:	748a8a93          	addi	s5,s5,1864 # 80008238 <etext+0x238>
    printf("\n");
    80001af8:	00006a17          	auipc	s4,0x6
    80001afc:	560a0a13          	addi	s4,s4,1376 # 80008058 <etext+0x58>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b00:	00006b97          	auipc	s7,0x6
    80001b04:	770b8b93          	addi	s7,s7,1904 # 80008270 <states.1717>
    80001b08:	a00d                	j	80001b2a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b0a:	ed86a583          	lw	a1,-296(a3)
    80001b0e:	8556                	mv	a0,s5
    80001b10:	00004097          	auipc	ra,0x4
    80001b14:	282080e7          	jalr	642(ra) # 80005d92 <printf>
    printf("\n");
    80001b18:	8552                	mv	a0,s4
    80001b1a:	00004097          	auipc	ra,0x4
    80001b1e:	278080e7          	jalr	632(ra) # 80005d92 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b22:	16848493          	addi	s1,s1,360
    80001b26:	03248163          	beq	s1,s2,80001b48 <procdump+0x98>
    if(p->state == UNUSED)
    80001b2a:	86a6                	mv	a3,s1
    80001b2c:	ec04a783          	lw	a5,-320(s1)
    80001b30:	dbed                	beqz	a5,80001b22 <procdump+0x72>
      state = "???";
    80001b32:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b34:	fcfb6be3          	bltu	s6,a5,80001b0a <procdump+0x5a>
    80001b38:	1782                	slli	a5,a5,0x20
    80001b3a:	9381                	srli	a5,a5,0x20
    80001b3c:	078e                	slli	a5,a5,0x3
    80001b3e:	97de                	add	a5,a5,s7
    80001b40:	6390                	ld	a2,0(a5)
    80001b42:	f661                	bnez	a2,80001b0a <procdump+0x5a>
      state = "???";
    80001b44:	864e                	mv	a2,s3
    80001b46:	b7d1                	j	80001b0a <procdump+0x5a>
  }
}
    80001b48:	60a6                	ld	ra,72(sp)
    80001b4a:	6406                	ld	s0,64(sp)
    80001b4c:	74e2                	ld	s1,56(sp)
    80001b4e:	7942                	ld	s2,48(sp)
    80001b50:	79a2                	ld	s3,40(sp)
    80001b52:	7a02                	ld	s4,32(sp)
    80001b54:	6ae2                	ld	s5,24(sp)
    80001b56:	6b42                	ld	s6,16(sp)
    80001b58:	6ba2                	ld	s7,8(sp)
    80001b5a:	6161                	addi	sp,sp,80
    80001b5c:	8082                	ret

0000000080001b5e <swtch>:
    80001b5e:	00153023          	sd	ra,0(a0)
    80001b62:	00253423          	sd	sp,8(a0)
    80001b66:	e900                	sd	s0,16(a0)
    80001b68:	ed04                	sd	s1,24(a0)
    80001b6a:	03253023          	sd	s2,32(a0)
    80001b6e:	03353423          	sd	s3,40(a0)
    80001b72:	03453823          	sd	s4,48(a0)
    80001b76:	03553c23          	sd	s5,56(a0)
    80001b7a:	05653023          	sd	s6,64(a0)
    80001b7e:	05753423          	sd	s7,72(a0)
    80001b82:	05853823          	sd	s8,80(a0)
    80001b86:	05953c23          	sd	s9,88(a0)
    80001b8a:	07a53023          	sd	s10,96(a0)
    80001b8e:	07b53423          	sd	s11,104(a0)
    80001b92:	0005b083          	ld	ra,0(a1)
    80001b96:	0085b103          	ld	sp,8(a1)
    80001b9a:	6980                	ld	s0,16(a1)
    80001b9c:	6d84                	ld	s1,24(a1)
    80001b9e:	0205b903          	ld	s2,32(a1)
    80001ba2:	0285b983          	ld	s3,40(a1)
    80001ba6:	0305ba03          	ld	s4,48(a1)
    80001baa:	0385ba83          	ld	s5,56(a1)
    80001bae:	0405bb03          	ld	s6,64(a1)
    80001bb2:	0485bb83          	ld	s7,72(a1)
    80001bb6:	0505bc03          	ld	s8,80(a1)
    80001bba:	0585bc83          	ld	s9,88(a1)
    80001bbe:	0605bd03          	ld	s10,96(a1)
    80001bc2:	0685bd83          	ld	s11,104(a1)
    80001bc6:	8082                	ret

0000000080001bc8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001bc8:	1141                	addi	sp,sp,-16
    80001bca:	e406                	sd	ra,8(sp)
    80001bcc:	e022                	sd	s0,0(sp)
    80001bce:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bd0:	00006597          	auipc	a1,0x6
    80001bd4:	6d058593          	addi	a1,a1,1744 # 800082a0 <states.1717+0x30>
    80001bd8:	0002d517          	auipc	a0,0x2d
    80001bdc:	2a850513          	addi	a0,a0,680 # 8002ee80 <tickslock>
    80001be0:	00004097          	auipc	ra,0x4
    80001be4:	622080e7          	jalr	1570(ra) # 80006202 <initlock>
}
    80001be8:	60a2                	ld	ra,8(sp)
    80001bea:	6402                	ld	s0,0(sp)
    80001bec:	0141                	addi	sp,sp,16
    80001bee:	8082                	ret

0000000080001bf0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bf0:	1141                	addi	sp,sp,-16
    80001bf2:	e422                	sd	s0,8(sp)
    80001bf4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bf6:	00003797          	auipc	a5,0x3
    80001bfa:	55a78793          	addi	a5,a5,1370 # 80005150 <kernelvec>
    80001bfe:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c02:	6422                	ld	s0,8(sp)
    80001c04:	0141                	addi	sp,sp,16
    80001c06:	8082                	ret

0000000080001c08 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c08:	1141                	addi	sp,sp,-16
    80001c0a:	e406                	sd	ra,8(sp)
    80001c0c:	e022                	sd	s0,0(sp)
    80001c0e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c10:	fffff097          	auipc	ra,0xfffff
    80001c14:	394080e7          	jalr	916(ra) # 80000fa4 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c18:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c1c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c1e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c22:	00005617          	auipc	a2,0x5
    80001c26:	3de60613          	addi	a2,a2,990 # 80007000 <_trampoline>
    80001c2a:	00005697          	auipc	a3,0x5
    80001c2e:	3d668693          	addi	a3,a3,982 # 80007000 <_trampoline>
    80001c32:	8e91                	sub	a3,a3,a2
    80001c34:	040007b7          	lui	a5,0x4000
    80001c38:	17fd                	addi	a5,a5,-1
    80001c3a:	07b2                	slli	a5,a5,0xc
    80001c3c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c3e:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c42:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c44:	180026f3          	csrr	a3,satp
    80001c48:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c4a:	6d38                	ld	a4,88(a0)
    80001c4c:	6134                	ld	a3,64(a0)
    80001c4e:	6585                	lui	a1,0x1
    80001c50:	96ae                	add	a3,a3,a1
    80001c52:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c54:	6d38                	ld	a4,88(a0)
    80001c56:	00000697          	auipc	a3,0x0
    80001c5a:	13868693          	addi	a3,a3,312 # 80001d8e <usertrap>
    80001c5e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c60:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c62:	8692                	mv	a3,tp
    80001c64:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c66:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c6a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c6e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c72:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c76:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c78:	6f18                	ld	a4,24(a4)
    80001c7a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c7e:	692c                	ld	a1,80(a0)
    80001c80:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c82:	00005717          	auipc	a4,0x5
    80001c86:	40e70713          	addi	a4,a4,1038 # 80007090 <userret>
    80001c8a:	8f11                	sub	a4,a4,a2
    80001c8c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c8e:	577d                	li	a4,-1
    80001c90:	177e                	slli	a4,a4,0x3f
    80001c92:	8dd9                	or	a1,a1,a4
    80001c94:	02000537          	lui	a0,0x2000
    80001c98:	157d                	addi	a0,a0,-1
    80001c9a:	0536                	slli	a0,a0,0xd
    80001c9c:	9782                	jalr	a5
}
    80001c9e:	60a2                	ld	ra,8(sp)
    80001ca0:	6402                	ld	s0,0(sp)
    80001ca2:	0141                	addi	sp,sp,16
    80001ca4:	8082                	ret

0000000080001ca6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001ca6:	1101                	addi	sp,sp,-32
    80001ca8:	ec06                	sd	ra,24(sp)
    80001caa:	e822                	sd	s0,16(sp)
    80001cac:	e426                	sd	s1,8(sp)
    80001cae:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001cb0:	0002d497          	auipc	s1,0x2d
    80001cb4:	1d048493          	addi	s1,s1,464 # 8002ee80 <tickslock>
    80001cb8:	8526                	mv	a0,s1
    80001cba:	00004097          	auipc	ra,0x4
    80001cbe:	5d8080e7          	jalr	1496(ra) # 80006292 <acquire>
  ticks++;
    80001cc2:	00007517          	auipc	a0,0x7
    80001cc6:	35650513          	addi	a0,a0,854 # 80009018 <ticks>
    80001cca:	411c                	lw	a5,0(a0)
    80001ccc:	2785                	addiw	a5,a5,1
    80001cce:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001cd0:	00000097          	auipc	ra,0x0
    80001cd4:	b1c080e7          	jalr	-1252(ra) # 800017ec <wakeup>
  release(&tickslock);
    80001cd8:	8526                	mv	a0,s1
    80001cda:	00004097          	auipc	ra,0x4
    80001cde:	66c080e7          	jalr	1644(ra) # 80006346 <release>
}
    80001ce2:	60e2                	ld	ra,24(sp)
    80001ce4:	6442                	ld	s0,16(sp)
    80001ce6:	64a2                	ld	s1,8(sp)
    80001ce8:	6105                	addi	sp,sp,32
    80001cea:	8082                	ret

0000000080001cec <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001cec:	1101                	addi	sp,sp,-32
    80001cee:	ec06                	sd	ra,24(sp)
    80001cf0:	e822                	sd	s0,16(sp)
    80001cf2:	e426                	sd	s1,8(sp)
    80001cf4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cf6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001cfa:	00074d63          	bltz	a4,80001d14 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001cfe:	57fd                	li	a5,-1
    80001d00:	17fe                	slli	a5,a5,0x3f
    80001d02:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d04:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d06:	06f70363          	beq	a4,a5,80001d6c <devintr+0x80>
  }
}
    80001d0a:	60e2                	ld	ra,24(sp)
    80001d0c:	6442                	ld	s0,16(sp)
    80001d0e:	64a2                	ld	s1,8(sp)
    80001d10:	6105                	addi	sp,sp,32
    80001d12:	8082                	ret
     (scause & 0xff) == 9){
    80001d14:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001d18:	46a5                	li	a3,9
    80001d1a:	fed792e3          	bne	a5,a3,80001cfe <devintr+0x12>
    int irq = plic_claim();
    80001d1e:	00003097          	auipc	ra,0x3
    80001d22:	53a080e7          	jalr	1338(ra) # 80005258 <plic_claim>
    80001d26:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d28:	47a9                	li	a5,10
    80001d2a:	02f50763          	beq	a0,a5,80001d58 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d2e:	4785                	li	a5,1
    80001d30:	02f50963          	beq	a0,a5,80001d62 <devintr+0x76>
    return 1;
    80001d34:	4505                	li	a0,1
    } else if(irq){
    80001d36:	d8f1                	beqz	s1,80001d0a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d38:	85a6                	mv	a1,s1
    80001d3a:	00006517          	auipc	a0,0x6
    80001d3e:	56e50513          	addi	a0,a0,1390 # 800082a8 <states.1717+0x38>
    80001d42:	00004097          	auipc	ra,0x4
    80001d46:	050080e7          	jalr	80(ra) # 80005d92 <printf>
      plic_complete(irq);
    80001d4a:	8526                	mv	a0,s1
    80001d4c:	00003097          	auipc	ra,0x3
    80001d50:	530080e7          	jalr	1328(ra) # 8000527c <plic_complete>
    return 1;
    80001d54:	4505                	li	a0,1
    80001d56:	bf55                	j	80001d0a <devintr+0x1e>
      uartintr();
    80001d58:	00004097          	auipc	ra,0x4
    80001d5c:	45a080e7          	jalr	1114(ra) # 800061b2 <uartintr>
    80001d60:	b7ed                	j	80001d4a <devintr+0x5e>
      virtio_disk_intr();
    80001d62:	00004097          	auipc	ra,0x4
    80001d66:	9fa080e7          	jalr	-1542(ra) # 8000575c <virtio_disk_intr>
    80001d6a:	b7c5                	j	80001d4a <devintr+0x5e>
    if(cpuid() == 0){
    80001d6c:	fffff097          	auipc	ra,0xfffff
    80001d70:	20c080e7          	jalr	524(ra) # 80000f78 <cpuid>
    80001d74:	c901                	beqz	a0,80001d84 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d76:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d7a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d7c:	14479073          	csrw	sip,a5
    return 2;
    80001d80:	4509                	li	a0,2
    80001d82:	b761                	j	80001d0a <devintr+0x1e>
      clockintr();
    80001d84:	00000097          	auipc	ra,0x0
    80001d88:	f22080e7          	jalr	-222(ra) # 80001ca6 <clockintr>
    80001d8c:	b7ed                	j	80001d76 <devintr+0x8a>

0000000080001d8e <usertrap>:
{
    80001d8e:	7139                	addi	sp,sp,-64
    80001d90:	fc06                	sd	ra,56(sp)
    80001d92:	f822                	sd	s0,48(sp)
    80001d94:	f426                	sd	s1,40(sp)
    80001d96:	f04a                	sd	s2,32(sp)
    80001d98:	ec4e                	sd	s3,24(sp)
    80001d9a:	e852                	sd	s4,16(sp)
    80001d9c:	e456                	sd	s5,8(sp)
    80001d9e:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da0:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001da4:	1007f793          	andi	a5,a5,256
    80001da8:	e7ad                	bnez	a5,80001e12 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001daa:	00003797          	auipc	a5,0x3
    80001dae:	3a678793          	addi	a5,a5,934 # 80005150 <kernelvec>
    80001db2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001db6:	fffff097          	auipc	ra,0xfffff
    80001dba:	1ee080e7          	jalr	494(ra) # 80000fa4 <myproc>
    80001dbe:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001dc0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dc2:	14102773          	csrr	a4,sepc
    80001dc6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dc8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001dcc:	47a1                	li	a5,8
    80001dce:	06f71063          	bne	a4,a5,80001e2e <usertrap+0xa0>
    if(p->killed)
    80001dd2:	551c                	lw	a5,40(a0)
    80001dd4:	e7b9                	bnez	a5,80001e22 <usertrap+0x94>
    p->trapframe->epc += 4;
    80001dd6:	6cb8                	ld	a4,88(s1)
    80001dd8:	6f1c                	ld	a5,24(a4)
    80001dda:	0791                	addi	a5,a5,4
    80001ddc:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dde:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001de2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001de6:	10079073          	csrw	sstatus,a5
    syscall();
    80001dea:	00000097          	auipc	ra,0x0
    80001dee:	3ae080e7          	jalr	942(ra) # 80002198 <syscall>
  if(p->killed)
    80001df2:	549c                	lw	a5,40(s1)
    80001df4:	14079f63          	bnez	a5,80001f52 <usertrap+0x1c4>
  usertrapret();
    80001df8:	00000097          	auipc	ra,0x0
    80001dfc:	e10080e7          	jalr	-496(ra) # 80001c08 <usertrapret>
}
    80001e00:	70e2                	ld	ra,56(sp)
    80001e02:	7442                	ld	s0,48(sp)
    80001e04:	74a2                	ld	s1,40(sp)
    80001e06:	7902                	ld	s2,32(sp)
    80001e08:	69e2                	ld	s3,24(sp)
    80001e0a:	6a42                	ld	s4,16(sp)
    80001e0c:	6aa2                	ld	s5,8(sp)
    80001e0e:	6121                	addi	sp,sp,64
    80001e10:	8082                	ret
    panic("usertrap: not from user mode");
    80001e12:	00006517          	auipc	a0,0x6
    80001e16:	4b650513          	addi	a0,a0,1206 # 800082c8 <states.1717+0x58>
    80001e1a:	00004097          	auipc	ra,0x4
    80001e1e:	f2e080e7          	jalr	-210(ra) # 80005d48 <panic>
      exit(-1);
    80001e22:	557d                	li	a0,-1
    80001e24:	00000097          	auipc	ra,0x0
    80001e28:	a98080e7          	jalr	-1384(ra) # 800018bc <exit>
    80001e2c:	b76d                	j	80001dd6 <usertrap+0x48>
  } else if((which_dev = devintr()) != 0){
    80001e2e:	00000097          	auipc	ra,0x0
    80001e32:	ebe080e7          	jalr	-322(ra) # 80001cec <devintr>
    80001e36:	892a                	mv	s2,a0
    80001e38:	10051a63          	bnez	a0,80001f4c <usertrap+0x1be>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e3c:	143029f3          	csrr	s3,stval
      uint64 va = PGROUNDDOWN(r_stval());
    80001e40:	77fd                	lui	a5,0xfffff
    80001e42:	00f9f9b3          	and	s3,s3,a5
      if(va >= MAXVA){
    80001e46:	57fd                	li	a5,-1
    80001e48:	83e9                	srli	a5,a5,0x1a
    80001e4a:	0737eb63          	bltu	a5,s3,80001ec0 <usertrap+0x132>
      pte_t* pte = walk(p->pagetable,va,0);
    80001e4e:	4601                	li	a2,0
    80001e50:	85ce                	mv	a1,s3
    80001e52:	68a8                	ld	a0,80(s1)
    80001e54:	ffffe097          	auipc	ra,0xffffe
    80001e58:	6de080e7          	jalr	1758(ra) # 80000532 <walk>
    80001e5c:	89aa                	mv	s3,a0
      if(pte == 0){
    80001e5e:	c92d                	beqz	a0,80001ed0 <usertrap+0x142>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e60:	14202773          	csrr	a4,scause
      if((r_scause() == 13 || r_scause() == 15) && (flag & PTE_C) ){
    80001e64:	47b5                	li	a5,13
    80001e66:	06f70d63          	beq	a4,a5,80001ee0 <usertrap+0x152>
    80001e6a:	14202773          	csrr	a4,scause
    80001e6e:	47bd                	li	a5,15
    80001e70:	06f70863          	beq	a4,a5,80001ee0 <usertrap+0x152>
    80001e74:	142025f3          	csrr	a1,scause
          printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e78:	5890                	lw	a2,48(s1)
    80001e7a:	00006517          	auipc	a0,0x6
    80001e7e:	47650513          	addi	a0,a0,1142 # 800082f0 <states.1717+0x80>
    80001e82:	00004097          	auipc	ra,0x4
    80001e86:	f10080e7          	jalr	-240(ra) # 80005d92 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e8a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e8e:	14302673          	csrr	a2,stval
          printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e92:	00006517          	auipc	a0,0x6
    80001e96:	48e50513          	addi	a0,a0,1166 # 80008320 <states.1717+0xb0>
    80001e9a:	00004097          	auipc	ra,0x4
    80001e9e:	ef8080e7          	jalr	-264(ra) # 80005d92 <printf>
          p->killed = 1;
    80001ea2:	4785                	li	a5,1
    80001ea4:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001ea6:	557d                	li	a0,-1
    80001ea8:	00000097          	auipc	ra,0x0
    80001eac:	a14080e7          	jalr	-1516(ra) # 800018bc <exit>
  if(which_dev == 2)
    80001eb0:	4789                	li	a5,2
    80001eb2:	f4f913e3          	bne	s2,a5,80001df8 <usertrap+0x6a>
    yield();
    80001eb6:	fffff097          	auipc	ra,0xfffff
    80001eba:	76e080e7          	jalr	1902(ra) # 80001624 <yield>
    80001ebe:	bf2d                	j	80001df8 <usertrap+0x6a>
          p->killed = 1;
    80001ec0:	4785                	li	a5,1
    80001ec2:	d49c                	sw	a5,40(s1)
          exit(-1);
    80001ec4:	557d                	li	a0,-1
    80001ec6:	00000097          	auipc	ra,0x0
    80001eca:	9f6080e7          	jalr	-1546(ra) # 800018bc <exit>
    80001ece:	b741                	j	80001e4e <usertrap+0xc0>
          p->killed = 1;
    80001ed0:	4785                	li	a5,1
    80001ed2:	d49c                	sw	a5,40(s1)
          exit(-1);
    80001ed4:	557d                	li	a0,-1
    80001ed6:	00000097          	auipc	ra,0x0
    80001eda:	9e6080e7          	jalr	-1562(ra) # 800018bc <exit>
    80001ede:	b749                	j	80001e60 <usertrap+0xd2>
      uint64 pa = PTE2PA(*pte);
    80001ee0:	0009ba03          	ld	s4,0(s3)
      if((r_scause() == 13 || r_scause() == 15) && (flag & PTE_C) ){
    80001ee4:	020a7793          	andi	a5,s4,32
    80001ee8:	d7d1                	beqz	a5,80001e74 <usertrap+0xe6>
          char* mem = kalloc();
    80001eea:	ffffe097          	auipc	ra,0xffffe
    80001eee:	2e6080e7          	jalr	742(ra) # 800001d0 <kalloc>
    80001ef2:	892a                	mv	s2,a0
          if(mem == 0){
    80001ef4:	cd05                	beqz	a0,80001f2c <usertrap+0x19e>
      uint64 pa = PTE2PA(*pte);
    80001ef6:	00aa5a93          	srli	s5,s4,0xa
    80001efa:	0ab2                	slli	s5,s5,0xc
          memmove(mem,(char*)pa,PGSIZE);
    80001efc:	6605                	lui	a2,0x1
    80001efe:	85d6                	mv	a1,s5
    80001f00:	854a                	mv	a0,s2
    80001f02:	ffffe097          	auipc	ra,0xffffe
    80001f06:	3a8080e7          	jalr	936(ra) # 800002aa <memmove>
          kfree((char*)pa);
    80001f0a:	8556                	mv	a0,s5
    80001f0c:	ffffe097          	auipc	ra,0xffffe
    80001f10:	160080e7          	jalr	352(ra) # 8000006c <kfree>
          *pte = PA2PTE(mem) | (flag & ~PTE_C) | PTE_W;
    80001f14:	00c95793          	srli	a5,s2,0xc
    80001f18:	07aa                	slli	a5,a5,0xa
    80001f1a:	3dfa7a13          	andi	s4,s4,991
    80001f1e:	0147e7b3          	or	a5,a5,s4
    80001f22:	0047e793          	ori	a5,a5,4
    80001f26:	00f9b023          	sd	a5,0(s3)
      if((r_scause() == 13 || r_scause() == 15) && (flag & PTE_C) ){
    80001f2a:	b5e1                	j	80001df2 <usertrap+0x64>
              printf("here\n");
    80001f2c:	00006517          	auipc	a0,0x6
    80001f30:	3bc50513          	addi	a0,a0,956 # 800082e8 <states.1717+0x78>
    80001f34:	00004097          	auipc	ra,0x4
    80001f38:	e5e080e7          	jalr	-418(ra) # 80005d92 <printf>
              p->killed = 1;
    80001f3c:	4785                	li	a5,1
    80001f3e:	d49c                	sw	a5,40(s1)
              exit(-1);
    80001f40:	557d                	li	a0,-1
    80001f42:	00000097          	auipc	ra,0x0
    80001f46:	97a080e7          	jalr	-1670(ra) # 800018bc <exit>
    80001f4a:	b775                	j	80001ef6 <usertrap+0x168>
  if(p->killed)
    80001f4c:	549c                	lw	a5,40(s1)
    80001f4e:	d3ad                	beqz	a5,80001eb0 <usertrap+0x122>
    80001f50:	bf99                	j	80001ea6 <usertrap+0x118>
    80001f52:	4901                	li	s2,0
    80001f54:	bf89                	j	80001ea6 <usertrap+0x118>

0000000080001f56 <kerneltrap>:
{
    80001f56:	7179                	addi	sp,sp,-48
    80001f58:	f406                	sd	ra,40(sp)
    80001f5a:	f022                	sd	s0,32(sp)
    80001f5c:	ec26                	sd	s1,24(sp)
    80001f5e:	e84a                	sd	s2,16(sp)
    80001f60:	e44e                	sd	s3,8(sp)
    80001f62:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f64:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f68:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f6c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f70:	1004f793          	andi	a5,s1,256
    80001f74:	cb85                	beqz	a5,80001fa4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f76:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f7a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f7c:	ef85                	bnez	a5,80001fb4 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f7e:	00000097          	auipc	ra,0x0
    80001f82:	d6e080e7          	jalr	-658(ra) # 80001cec <devintr>
    80001f86:	cd1d                	beqz	a0,80001fc4 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f88:	4789                	li	a5,2
    80001f8a:	06f50a63          	beq	a0,a5,80001ffe <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f8e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f92:	10049073          	csrw	sstatus,s1
}
    80001f96:	70a2                	ld	ra,40(sp)
    80001f98:	7402                	ld	s0,32(sp)
    80001f9a:	64e2                	ld	s1,24(sp)
    80001f9c:	6942                	ld	s2,16(sp)
    80001f9e:	69a2                	ld	s3,8(sp)
    80001fa0:	6145                	addi	sp,sp,48
    80001fa2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001fa4:	00006517          	auipc	a0,0x6
    80001fa8:	39c50513          	addi	a0,a0,924 # 80008340 <states.1717+0xd0>
    80001fac:	00004097          	auipc	ra,0x4
    80001fb0:	d9c080e7          	jalr	-612(ra) # 80005d48 <panic>
    panic("kerneltrap: interrupts enabled");
    80001fb4:	00006517          	auipc	a0,0x6
    80001fb8:	3b450513          	addi	a0,a0,948 # 80008368 <states.1717+0xf8>
    80001fbc:	00004097          	auipc	ra,0x4
    80001fc0:	d8c080e7          	jalr	-628(ra) # 80005d48 <panic>
    printf("scause %p\n", scause);
    80001fc4:	85ce                	mv	a1,s3
    80001fc6:	00006517          	auipc	a0,0x6
    80001fca:	3c250513          	addi	a0,a0,962 # 80008388 <states.1717+0x118>
    80001fce:	00004097          	auipc	ra,0x4
    80001fd2:	dc4080e7          	jalr	-572(ra) # 80005d92 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fd6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fda:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fde:	00006517          	auipc	a0,0x6
    80001fe2:	3ba50513          	addi	a0,a0,954 # 80008398 <states.1717+0x128>
    80001fe6:	00004097          	auipc	ra,0x4
    80001fea:	dac080e7          	jalr	-596(ra) # 80005d92 <printf>
    panic("kerneltrap");
    80001fee:	00006517          	auipc	a0,0x6
    80001ff2:	3c250513          	addi	a0,a0,962 # 800083b0 <states.1717+0x140>
    80001ff6:	00004097          	auipc	ra,0x4
    80001ffa:	d52080e7          	jalr	-686(ra) # 80005d48 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ffe:	fffff097          	auipc	ra,0xfffff
    80002002:	fa6080e7          	jalr	-90(ra) # 80000fa4 <myproc>
    80002006:	d541                	beqz	a0,80001f8e <kerneltrap+0x38>
    80002008:	fffff097          	auipc	ra,0xfffff
    8000200c:	f9c080e7          	jalr	-100(ra) # 80000fa4 <myproc>
    80002010:	4d18                	lw	a4,24(a0)
    80002012:	4791                	li	a5,4
    80002014:	f6f71de3          	bne	a4,a5,80001f8e <kerneltrap+0x38>
    yield();
    80002018:	fffff097          	auipc	ra,0xfffff
    8000201c:	60c080e7          	jalr	1548(ra) # 80001624 <yield>
    80002020:	b7bd                	j	80001f8e <kerneltrap+0x38>

0000000080002022 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002022:	1101                	addi	sp,sp,-32
    80002024:	ec06                	sd	ra,24(sp)
    80002026:	e822                	sd	s0,16(sp)
    80002028:	e426                	sd	s1,8(sp)
    8000202a:	1000                	addi	s0,sp,32
    8000202c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000202e:	fffff097          	auipc	ra,0xfffff
    80002032:	f76080e7          	jalr	-138(ra) # 80000fa4 <myproc>
  switch (n) {
    80002036:	4795                	li	a5,5
    80002038:	0497e163          	bltu	a5,s1,8000207a <argraw+0x58>
    8000203c:	048a                	slli	s1,s1,0x2
    8000203e:	00006717          	auipc	a4,0x6
    80002042:	3aa70713          	addi	a4,a4,938 # 800083e8 <states.1717+0x178>
    80002046:	94ba                	add	s1,s1,a4
    80002048:	409c                	lw	a5,0(s1)
    8000204a:	97ba                	add	a5,a5,a4
    8000204c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000204e:	6d3c                	ld	a5,88(a0)
    80002050:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002052:	60e2                	ld	ra,24(sp)
    80002054:	6442                	ld	s0,16(sp)
    80002056:	64a2                	ld	s1,8(sp)
    80002058:	6105                	addi	sp,sp,32
    8000205a:	8082                	ret
    return p->trapframe->a1;
    8000205c:	6d3c                	ld	a5,88(a0)
    8000205e:	7fa8                	ld	a0,120(a5)
    80002060:	bfcd                	j	80002052 <argraw+0x30>
    return p->trapframe->a2;
    80002062:	6d3c                	ld	a5,88(a0)
    80002064:	63c8                	ld	a0,128(a5)
    80002066:	b7f5                	j	80002052 <argraw+0x30>
    return p->trapframe->a3;
    80002068:	6d3c                	ld	a5,88(a0)
    8000206a:	67c8                	ld	a0,136(a5)
    8000206c:	b7dd                	j	80002052 <argraw+0x30>
    return p->trapframe->a4;
    8000206e:	6d3c                	ld	a5,88(a0)
    80002070:	6bc8                	ld	a0,144(a5)
    80002072:	b7c5                	j	80002052 <argraw+0x30>
    return p->trapframe->a5;
    80002074:	6d3c                	ld	a5,88(a0)
    80002076:	6fc8                	ld	a0,152(a5)
    80002078:	bfe9                	j	80002052 <argraw+0x30>
  panic("argraw");
    8000207a:	00006517          	auipc	a0,0x6
    8000207e:	34650513          	addi	a0,a0,838 # 800083c0 <states.1717+0x150>
    80002082:	00004097          	auipc	ra,0x4
    80002086:	cc6080e7          	jalr	-826(ra) # 80005d48 <panic>

000000008000208a <fetchaddr>:
{
    8000208a:	1101                	addi	sp,sp,-32
    8000208c:	ec06                	sd	ra,24(sp)
    8000208e:	e822                	sd	s0,16(sp)
    80002090:	e426                	sd	s1,8(sp)
    80002092:	e04a                	sd	s2,0(sp)
    80002094:	1000                	addi	s0,sp,32
    80002096:	84aa                	mv	s1,a0
    80002098:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000209a:	fffff097          	auipc	ra,0xfffff
    8000209e:	f0a080e7          	jalr	-246(ra) # 80000fa4 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800020a2:	653c                	ld	a5,72(a0)
    800020a4:	02f4f863          	bgeu	s1,a5,800020d4 <fetchaddr+0x4a>
    800020a8:	00848713          	addi	a4,s1,8
    800020ac:	02e7e663          	bltu	a5,a4,800020d8 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020b0:	46a1                	li	a3,8
    800020b2:	8626                	mv	a2,s1
    800020b4:	85ca                	mv	a1,s2
    800020b6:	6928                	ld	a0,80(a0)
    800020b8:	fffff097          	auipc	ra,0xfffff
    800020bc:	c3a080e7          	jalr	-966(ra) # 80000cf2 <copyin>
    800020c0:	00a03533          	snez	a0,a0
    800020c4:	40a00533          	neg	a0,a0
}
    800020c8:	60e2                	ld	ra,24(sp)
    800020ca:	6442                	ld	s0,16(sp)
    800020cc:	64a2                	ld	s1,8(sp)
    800020ce:	6902                	ld	s2,0(sp)
    800020d0:	6105                	addi	sp,sp,32
    800020d2:	8082                	ret
    return -1;
    800020d4:	557d                	li	a0,-1
    800020d6:	bfcd                	j	800020c8 <fetchaddr+0x3e>
    800020d8:	557d                	li	a0,-1
    800020da:	b7fd                	j	800020c8 <fetchaddr+0x3e>

00000000800020dc <fetchstr>:
{
    800020dc:	7179                	addi	sp,sp,-48
    800020de:	f406                	sd	ra,40(sp)
    800020e0:	f022                	sd	s0,32(sp)
    800020e2:	ec26                	sd	s1,24(sp)
    800020e4:	e84a                	sd	s2,16(sp)
    800020e6:	e44e                	sd	s3,8(sp)
    800020e8:	1800                	addi	s0,sp,48
    800020ea:	892a                	mv	s2,a0
    800020ec:	84ae                	mv	s1,a1
    800020ee:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020f0:	fffff097          	auipc	ra,0xfffff
    800020f4:	eb4080e7          	jalr	-332(ra) # 80000fa4 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800020f8:	86ce                	mv	a3,s3
    800020fa:	864a                	mv	a2,s2
    800020fc:	85a6                	mv	a1,s1
    800020fe:	6928                	ld	a0,80(a0)
    80002100:	fffff097          	auipc	ra,0xfffff
    80002104:	c7e080e7          	jalr	-898(ra) # 80000d7e <copyinstr>
  if(err < 0)
    80002108:	00054763          	bltz	a0,80002116 <fetchstr+0x3a>
  return strlen(buf);
    8000210c:	8526                	mv	a0,s1
    8000210e:	ffffe097          	auipc	ra,0xffffe
    80002112:	2c0080e7          	jalr	704(ra) # 800003ce <strlen>
}
    80002116:	70a2                	ld	ra,40(sp)
    80002118:	7402                	ld	s0,32(sp)
    8000211a:	64e2                	ld	s1,24(sp)
    8000211c:	6942                	ld	s2,16(sp)
    8000211e:	69a2                	ld	s3,8(sp)
    80002120:	6145                	addi	sp,sp,48
    80002122:	8082                	ret

0000000080002124 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002124:	1101                	addi	sp,sp,-32
    80002126:	ec06                	sd	ra,24(sp)
    80002128:	e822                	sd	s0,16(sp)
    8000212a:	e426                	sd	s1,8(sp)
    8000212c:	1000                	addi	s0,sp,32
    8000212e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002130:	00000097          	auipc	ra,0x0
    80002134:	ef2080e7          	jalr	-270(ra) # 80002022 <argraw>
    80002138:	c088                	sw	a0,0(s1)
  return 0;
}
    8000213a:	4501                	li	a0,0
    8000213c:	60e2                	ld	ra,24(sp)
    8000213e:	6442                	ld	s0,16(sp)
    80002140:	64a2                	ld	s1,8(sp)
    80002142:	6105                	addi	sp,sp,32
    80002144:	8082                	ret

0000000080002146 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002146:	1101                	addi	sp,sp,-32
    80002148:	ec06                	sd	ra,24(sp)
    8000214a:	e822                	sd	s0,16(sp)
    8000214c:	e426                	sd	s1,8(sp)
    8000214e:	1000                	addi	s0,sp,32
    80002150:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002152:	00000097          	auipc	ra,0x0
    80002156:	ed0080e7          	jalr	-304(ra) # 80002022 <argraw>
    8000215a:	e088                	sd	a0,0(s1)
  return 0;
}
    8000215c:	4501                	li	a0,0
    8000215e:	60e2                	ld	ra,24(sp)
    80002160:	6442                	ld	s0,16(sp)
    80002162:	64a2                	ld	s1,8(sp)
    80002164:	6105                	addi	sp,sp,32
    80002166:	8082                	ret

0000000080002168 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002168:	1101                	addi	sp,sp,-32
    8000216a:	ec06                	sd	ra,24(sp)
    8000216c:	e822                	sd	s0,16(sp)
    8000216e:	e426                	sd	s1,8(sp)
    80002170:	e04a                	sd	s2,0(sp)
    80002172:	1000                	addi	s0,sp,32
    80002174:	84ae                	mv	s1,a1
    80002176:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002178:	00000097          	auipc	ra,0x0
    8000217c:	eaa080e7          	jalr	-342(ra) # 80002022 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002180:	864a                	mv	a2,s2
    80002182:	85a6                	mv	a1,s1
    80002184:	00000097          	auipc	ra,0x0
    80002188:	f58080e7          	jalr	-168(ra) # 800020dc <fetchstr>
}
    8000218c:	60e2                	ld	ra,24(sp)
    8000218e:	6442                	ld	s0,16(sp)
    80002190:	64a2                	ld	s1,8(sp)
    80002192:	6902                	ld	s2,0(sp)
    80002194:	6105                	addi	sp,sp,32
    80002196:	8082                	ret

0000000080002198 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002198:	1101                	addi	sp,sp,-32
    8000219a:	ec06                	sd	ra,24(sp)
    8000219c:	e822                	sd	s0,16(sp)
    8000219e:	e426                	sd	s1,8(sp)
    800021a0:	e04a                	sd	s2,0(sp)
    800021a2:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800021a4:	fffff097          	auipc	ra,0xfffff
    800021a8:	e00080e7          	jalr	-512(ra) # 80000fa4 <myproc>
    800021ac:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021ae:	05853903          	ld	s2,88(a0)
    800021b2:	0a893783          	ld	a5,168(s2)
    800021b6:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021ba:	37fd                	addiw	a5,a5,-1
    800021bc:	4751                	li	a4,20
    800021be:	00f76f63          	bltu	a4,a5,800021dc <syscall+0x44>
    800021c2:	00369713          	slli	a4,a3,0x3
    800021c6:	00006797          	auipc	a5,0x6
    800021ca:	23a78793          	addi	a5,a5,570 # 80008400 <syscalls>
    800021ce:	97ba                	add	a5,a5,a4
    800021d0:	639c                	ld	a5,0(a5)
    800021d2:	c789                	beqz	a5,800021dc <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800021d4:	9782                	jalr	a5
    800021d6:	06a93823          	sd	a0,112(s2)
    800021da:	a839                	j	800021f8 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021dc:	15848613          	addi	a2,s1,344
    800021e0:	588c                	lw	a1,48(s1)
    800021e2:	00006517          	auipc	a0,0x6
    800021e6:	1e650513          	addi	a0,a0,486 # 800083c8 <states.1717+0x158>
    800021ea:	00004097          	auipc	ra,0x4
    800021ee:	ba8080e7          	jalr	-1112(ra) # 80005d92 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021f2:	6cbc                	ld	a5,88(s1)
    800021f4:	577d                	li	a4,-1
    800021f6:	fbb8                	sd	a4,112(a5)
  }
}
    800021f8:	60e2                	ld	ra,24(sp)
    800021fa:	6442                	ld	s0,16(sp)
    800021fc:	64a2                	ld	s1,8(sp)
    800021fe:	6902                	ld	s2,0(sp)
    80002200:	6105                	addi	sp,sp,32
    80002202:	8082                	ret

0000000080002204 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002204:	1101                	addi	sp,sp,-32
    80002206:	ec06                	sd	ra,24(sp)
    80002208:	e822                	sd	s0,16(sp)
    8000220a:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000220c:	fec40593          	addi	a1,s0,-20
    80002210:	4501                	li	a0,0
    80002212:	00000097          	auipc	ra,0x0
    80002216:	f12080e7          	jalr	-238(ra) # 80002124 <argint>
    return -1;
    8000221a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000221c:	00054963          	bltz	a0,8000222e <sys_exit+0x2a>
  exit(n);
    80002220:	fec42503          	lw	a0,-20(s0)
    80002224:	fffff097          	auipc	ra,0xfffff
    80002228:	698080e7          	jalr	1688(ra) # 800018bc <exit>
  return 0;  // not reached
    8000222c:	4781                	li	a5,0
}
    8000222e:	853e                	mv	a0,a5
    80002230:	60e2                	ld	ra,24(sp)
    80002232:	6442                	ld	s0,16(sp)
    80002234:	6105                	addi	sp,sp,32
    80002236:	8082                	ret

0000000080002238 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002238:	1141                	addi	sp,sp,-16
    8000223a:	e406                	sd	ra,8(sp)
    8000223c:	e022                	sd	s0,0(sp)
    8000223e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002240:	fffff097          	auipc	ra,0xfffff
    80002244:	d64080e7          	jalr	-668(ra) # 80000fa4 <myproc>
}
    80002248:	5908                	lw	a0,48(a0)
    8000224a:	60a2                	ld	ra,8(sp)
    8000224c:	6402                	ld	s0,0(sp)
    8000224e:	0141                	addi	sp,sp,16
    80002250:	8082                	ret

0000000080002252 <sys_fork>:

uint64
sys_fork(void)
{
    80002252:	1141                	addi	sp,sp,-16
    80002254:	e406                	sd	ra,8(sp)
    80002256:	e022                	sd	s0,0(sp)
    80002258:	0800                	addi	s0,sp,16
  return fork();
    8000225a:	fffff097          	auipc	ra,0xfffff
    8000225e:	118080e7          	jalr	280(ra) # 80001372 <fork>
}
    80002262:	60a2                	ld	ra,8(sp)
    80002264:	6402                	ld	s0,0(sp)
    80002266:	0141                	addi	sp,sp,16
    80002268:	8082                	ret

000000008000226a <sys_wait>:

uint64
sys_wait(void)
{
    8000226a:	1101                	addi	sp,sp,-32
    8000226c:	ec06                	sd	ra,24(sp)
    8000226e:	e822                	sd	s0,16(sp)
    80002270:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002272:	fe840593          	addi	a1,s0,-24
    80002276:	4501                	li	a0,0
    80002278:	00000097          	auipc	ra,0x0
    8000227c:	ece080e7          	jalr	-306(ra) # 80002146 <argaddr>
    80002280:	87aa                	mv	a5,a0
    return -1;
    80002282:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002284:	0007c863          	bltz	a5,80002294 <sys_wait+0x2a>
  return wait(p);
    80002288:	fe843503          	ld	a0,-24(s0)
    8000228c:	fffff097          	auipc	ra,0xfffff
    80002290:	438080e7          	jalr	1080(ra) # 800016c4 <wait>
}
    80002294:	60e2                	ld	ra,24(sp)
    80002296:	6442                	ld	s0,16(sp)
    80002298:	6105                	addi	sp,sp,32
    8000229a:	8082                	ret

000000008000229c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000229c:	7179                	addi	sp,sp,-48
    8000229e:	f406                	sd	ra,40(sp)
    800022a0:	f022                	sd	s0,32(sp)
    800022a2:	ec26                	sd	s1,24(sp)
    800022a4:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800022a6:	fdc40593          	addi	a1,s0,-36
    800022aa:	4501                	li	a0,0
    800022ac:	00000097          	auipc	ra,0x0
    800022b0:	e78080e7          	jalr	-392(ra) # 80002124 <argint>
    800022b4:	87aa                	mv	a5,a0
    return -1;
    800022b6:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800022b8:	0207c063          	bltz	a5,800022d8 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800022bc:	fffff097          	auipc	ra,0xfffff
    800022c0:	ce8080e7          	jalr	-792(ra) # 80000fa4 <myproc>
    800022c4:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800022c6:	fdc42503          	lw	a0,-36(s0)
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	034080e7          	jalr	52(ra) # 800012fe <growproc>
    800022d2:	00054863          	bltz	a0,800022e2 <sys_sbrk+0x46>
    return -1;
  return addr;
    800022d6:	8526                	mv	a0,s1
}
    800022d8:	70a2                	ld	ra,40(sp)
    800022da:	7402                	ld	s0,32(sp)
    800022dc:	64e2                	ld	s1,24(sp)
    800022de:	6145                	addi	sp,sp,48
    800022e0:	8082                	ret
    return -1;
    800022e2:	557d                	li	a0,-1
    800022e4:	bfd5                	j	800022d8 <sys_sbrk+0x3c>

00000000800022e6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022e6:	7139                	addi	sp,sp,-64
    800022e8:	fc06                	sd	ra,56(sp)
    800022ea:	f822                	sd	s0,48(sp)
    800022ec:	f426                	sd	s1,40(sp)
    800022ee:	f04a                	sd	s2,32(sp)
    800022f0:	ec4e                	sd	s3,24(sp)
    800022f2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800022f4:	fcc40593          	addi	a1,s0,-52
    800022f8:	4501                	li	a0,0
    800022fa:	00000097          	auipc	ra,0x0
    800022fe:	e2a080e7          	jalr	-470(ra) # 80002124 <argint>
    return -1;
    80002302:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002304:	06054563          	bltz	a0,8000236e <sys_sleep+0x88>
  acquire(&tickslock);
    80002308:	0002d517          	auipc	a0,0x2d
    8000230c:	b7850513          	addi	a0,a0,-1160 # 8002ee80 <tickslock>
    80002310:	00004097          	auipc	ra,0x4
    80002314:	f82080e7          	jalr	-126(ra) # 80006292 <acquire>
  ticks0 = ticks;
    80002318:	00007917          	auipc	s2,0x7
    8000231c:	d0092903          	lw	s2,-768(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002320:	fcc42783          	lw	a5,-52(s0)
    80002324:	cf85                	beqz	a5,8000235c <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002326:	0002d997          	auipc	s3,0x2d
    8000232a:	b5a98993          	addi	s3,s3,-1190 # 8002ee80 <tickslock>
    8000232e:	00007497          	auipc	s1,0x7
    80002332:	cea48493          	addi	s1,s1,-790 # 80009018 <ticks>
    if(myproc()->killed){
    80002336:	fffff097          	auipc	ra,0xfffff
    8000233a:	c6e080e7          	jalr	-914(ra) # 80000fa4 <myproc>
    8000233e:	551c                	lw	a5,40(a0)
    80002340:	ef9d                	bnez	a5,8000237e <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002342:	85ce                	mv	a1,s3
    80002344:	8526                	mv	a0,s1
    80002346:	fffff097          	auipc	ra,0xfffff
    8000234a:	31a080e7          	jalr	794(ra) # 80001660 <sleep>
  while(ticks - ticks0 < n){
    8000234e:	409c                	lw	a5,0(s1)
    80002350:	412787bb          	subw	a5,a5,s2
    80002354:	fcc42703          	lw	a4,-52(s0)
    80002358:	fce7efe3          	bltu	a5,a4,80002336 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000235c:	0002d517          	auipc	a0,0x2d
    80002360:	b2450513          	addi	a0,a0,-1244 # 8002ee80 <tickslock>
    80002364:	00004097          	auipc	ra,0x4
    80002368:	fe2080e7          	jalr	-30(ra) # 80006346 <release>
  return 0;
    8000236c:	4781                	li	a5,0
}
    8000236e:	853e                	mv	a0,a5
    80002370:	70e2                	ld	ra,56(sp)
    80002372:	7442                	ld	s0,48(sp)
    80002374:	74a2                	ld	s1,40(sp)
    80002376:	7902                	ld	s2,32(sp)
    80002378:	69e2                	ld	s3,24(sp)
    8000237a:	6121                	addi	sp,sp,64
    8000237c:	8082                	ret
      release(&tickslock);
    8000237e:	0002d517          	auipc	a0,0x2d
    80002382:	b0250513          	addi	a0,a0,-1278 # 8002ee80 <tickslock>
    80002386:	00004097          	auipc	ra,0x4
    8000238a:	fc0080e7          	jalr	-64(ra) # 80006346 <release>
      return -1;
    8000238e:	57fd                	li	a5,-1
    80002390:	bff9                	j	8000236e <sys_sleep+0x88>

0000000080002392 <sys_kill>:

uint64
sys_kill(void)
{
    80002392:	1101                	addi	sp,sp,-32
    80002394:	ec06                	sd	ra,24(sp)
    80002396:	e822                	sd	s0,16(sp)
    80002398:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000239a:	fec40593          	addi	a1,s0,-20
    8000239e:	4501                	li	a0,0
    800023a0:	00000097          	auipc	ra,0x0
    800023a4:	d84080e7          	jalr	-636(ra) # 80002124 <argint>
    800023a8:	87aa                	mv	a5,a0
    return -1;
    800023aa:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800023ac:	0007c863          	bltz	a5,800023bc <sys_kill+0x2a>
  return kill(pid);
    800023b0:	fec42503          	lw	a0,-20(s0)
    800023b4:	fffff097          	auipc	ra,0xfffff
    800023b8:	5de080e7          	jalr	1502(ra) # 80001992 <kill>
}
    800023bc:	60e2                	ld	ra,24(sp)
    800023be:	6442                	ld	s0,16(sp)
    800023c0:	6105                	addi	sp,sp,32
    800023c2:	8082                	ret

00000000800023c4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800023c4:	1101                	addi	sp,sp,-32
    800023c6:	ec06                	sd	ra,24(sp)
    800023c8:	e822                	sd	s0,16(sp)
    800023ca:	e426                	sd	s1,8(sp)
    800023cc:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800023ce:	0002d517          	auipc	a0,0x2d
    800023d2:	ab250513          	addi	a0,a0,-1358 # 8002ee80 <tickslock>
    800023d6:	00004097          	auipc	ra,0x4
    800023da:	ebc080e7          	jalr	-324(ra) # 80006292 <acquire>
  xticks = ticks;
    800023de:	00007497          	auipc	s1,0x7
    800023e2:	c3a4a483          	lw	s1,-966(s1) # 80009018 <ticks>
  release(&tickslock);
    800023e6:	0002d517          	auipc	a0,0x2d
    800023ea:	a9a50513          	addi	a0,a0,-1382 # 8002ee80 <tickslock>
    800023ee:	00004097          	auipc	ra,0x4
    800023f2:	f58080e7          	jalr	-168(ra) # 80006346 <release>
  return xticks;
}
    800023f6:	02049513          	slli	a0,s1,0x20
    800023fa:	9101                	srli	a0,a0,0x20
    800023fc:	60e2                	ld	ra,24(sp)
    800023fe:	6442                	ld	s0,16(sp)
    80002400:	64a2                	ld	s1,8(sp)
    80002402:	6105                	addi	sp,sp,32
    80002404:	8082                	ret

0000000080002406 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002406:	7179                	addi	sp,sp,-48
    80002408:	f406                	sd	ra,40(sp)
    8000240a:	f022                	sd	s0,32(sp)
    8000240c:	ec26                	sd	s1,24(sp)
    8000240e:	e84a                	sd	s2,16(sp)
    80002410:	e44e                	sd	s3,8(sp)
    80002412:	e052                	sd	s4,0(sp)
    80002414:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002416:	00006597          	auipc	a1,0x6
    8000241a:	09a58593          	addi	a1,a1,154 # 800084b0 <syscalls+0xb0>
    8000241e:	0002d517          	auipc	a0,0x2d
    80002422:	a7a50513          	addi	a0,a0,-1414 # 8002ee98 <bcache>
    80002426:	00004097          	auipc	ra,0x4
    8000242a:	ddc080e7          	jalr	-548(ra) # 80006202 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000242e:	00035797          	auipc	a5,0x35
    80002432:	a6a78793          	addi	a5,a5,-1430 # 80036e98 <bcache+0x8000>
    80002436:	00035717          	auipc	a4,0x35
    8000243a:	cca70713          	addi	a4,a4,-822 # 80037100 <bcache+0x8268>
    8000243e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002442:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002446:	0002d497          	auipc	s1,0x2d
    8000244a:	a6a48493          	addi	s1,s1,-1430 # 8002eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    8000244e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002450:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002452:	00006a17          	auipc	s4,0x6
    80002456:	066a0a13          	addi	s4,s4,102 # 800084b8 <syscalls+0xb8>
    b->next = bcache.head.next;
    8000245a:	2b893783          	ld	a5,696(s2)
    8000245e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002460:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002464:	85d2                	mv	a1,s4
    80002466:	01048513          	addi	a0,s1,16
    8000246a:	00001097          	auipc	ra,0x1
    8000246e:	4bc080e7          	jalr	1212(ra) # 80003926 <initsleeplock>
    bcache.head.next->prev = b;
    80002472:	2b893783          	ld	a5,696(s2)
    80002476:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002478:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000247c:	45848493          	addi	s1,s1,1112
    80002480:	fd349de3          	bne	s1,s3,8000245a <binit+0x54>
  }
}
    80002484:	70a2                	ld	ra,40(sp)
    80002486:	7402                	ld	s0,32(sp)
    80002488:	64e2                	ld	s1,24(sp)
    8000248a:	6942                	ld	s2,16(sp)
    8000248c:	69a2                	ld	s3,8(sp)
    8000248e:	6a02                	ld	s4,0(sp)
    80002490:	6145                	addi	sp,sp,48
    80002492:	8082                	ret

0000000080002494 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002494:	7179                	addi	sp,sp,-48
    80002496:	f406                	sd	ra,40(sp)
    80002498:	f022                	sd	s0,32(sp)
    8000249a:	ec26                	sd	s1,24(sp)
    8000249c:	e84a                	sd	s2,16(sp)
    8000249e:	e44e                	sd	s3,8(sp)
    800024a0:	1800                	addi	s0,sp,48
    800024a2:	89aa                	mv	s3,a0
    800024a4:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800024a6:	0002d517          	auipc	a0,0x2d
    800024aa:	9f250513          	addi	a0,a0,-1550 # 8002ee98 <bcache>
    800024ae:	00004097          	auipc	ra,0x4
    800024b2:	de4080e7          	jalr	-540(ra) # 80006292 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800024b6:	00035497          	auipc	s1,0x35
    800024ba:	c9a4b483          	ld	s1,-870(s1) # 80037150 <bcache+0x82b8>
    800024be:	00035797          	auipc	a5,0x35
    800024c2:	c4278793          	addi	a5,a5,-958 # 80037100 <bcache+0x8268>
    800024c6:	02f48f63          	beq	s1,a5,80002504 <bread+0x70>
    800024ca:	873e                	mv	a4,a5
    800024cc:	a021                	j	800024d4 <bread+0x40>
    800024ce:	68a4                	ld	s1,80(s1)
    800024d0:	02e48a63          	beq	s1,a4,80002504 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024d4:	449c                	lw	a5,8(s1)
    800024d6:	ff379ce3          	bne	a5,s3,800024ce <bread+0x3a>
    800024da:	44dc                	lw	a5,12(s1)
    800024dc:	ff2799e3          	bne	a5,s2,800024ce <bread+0x3a>
      b->refcnt++;
    800024e0:	40bc                	lw	a5,64(s1)
    800024e2:	2785                	addiw	a5,a5,1
    800024e4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024e6:	0002d517          	auipc	a0,0x2d
    800024ea:	9b250513          	addi	a0,a0,-1614 # 8002ee98 <bcache>
    800024ee:	00004097          	auipc	ra,0x4
    800024f2:	e58080e7          	jalr	-424(ra) # 80006346 <release>
      acquiresleep(&b->lock);
    800024f6:	01048513          	addi	a0,s1,16
    800024fa:	00001097          	auipc	ra,0x1
    800024fe:	466080e7          	jalr	1126(ra) # 80003960 <acquiresleep>
      return b;
    80002502:	a8b9                	j	80002560 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002504:	00035497          	auipc	s1,0x35
    80002508:	c444b483          	ld	s1,-956(s1) # 80037148 <bcache+0x82b0>
    8000250c:	00035797          	auipc	a5,0x35
    80002510:	bf478793          	addi	a5,a5,-1036 # 80037100 <bcache+0x8268>
    80002514:	00f48863          	beq	s1,a5,80002524 <bread+0x90>
    80002518:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000251a:	40bc                	lw	a5,64(s1)
    8000251c:	cf81                	beqz	a5,80002534 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000251e:	64a4                	ld	s1,72(s1)
    80002520:	fee49de3          	bne	s1,a4,8000251a <bread+0x86>
  panic("bget: no buffers");
    80002524:	00006517          	auipc	a0,0x6
    80002528:	f9c50513          	addi	a0,a0,-100 # 800084c0 <syscalls+0xc0>
    8000252c:	00004097          	auipc	ra,0x4
    80002530:	81c080e7          	jalr	-2020(ra) # 80005d48 <panic>
      b->dev = dev;
    80002534:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002538:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000253c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002540:	4785                	li	a5,1
    80002542:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002544:	0002d517          	auipc	a0,0x2d
    80002548:	95450513          	addi	a0,a0,-1708 # 8002ee98 <bcache>
    8000254c:	00004097          	auipc	ra,0x4
    80002550:	dfa080e7          	jalr	-518(ra) # 80006346 <release>
      acquiresleep(&b->lock);
    80002554:	01048513          	addi	a0,s1,16
    80002558:	00001097          	auipc	ra,0x1
    8000255c:	408080e7          	jalr	1032(ra) # 80003960 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002560:	409c                	lw	a5,0(s1)
    80002562:	cb89                	beqz	a5,80002574 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002564:	8526                	mv	a0,s1
    80002566:	70a2                	ld	ra,40(sp)
    80002568:	7402                	ld	s0,32(sp)
    8000256a:	64e2                	ld	s1,24(sp)
    8000256c:	6942                	ld	s2,16(sp)
    8000256e:	69a2                	ld	s3,8(sp)
    80002570:	6145                	addi	sp,sp,48
    80002572:	8082                	ret
    virtio_disk_rw(b, 0);
    80002574:	4581                	li	a1,0
    80002576:	8526                	mv	a0,s1
    80002578:	00003097          	auipc	ra,0x3
    8000257c:	f0e080e7          	jalr	-242(ra) # 80005486 <virtio_disk_rw>
    b->valid = 1;
    80002580:	4785                	li	a5,1
    80002582:	c09c                	sw	a5,0(s1)
  return b;
    80002584:	b7c5                	j	80002564 <bread+0xd0>

0000000080002586 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002586:	1101                	addi	sp,sp,-32
    80002588:	ec06                	sd	ra,24(sp)
    8000258a:	e822                	sd	s0,16(sp)
    8000258c:	e426                	sd	s1,8(sp)
    8000258e:	1000                	addi	s0,sp,32
    80002590:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002592:	0541                	addi	a0,a0,16
    80002594:	00001097          	auipc	ra,0x1
    80002598:	466080e7          	jalr	1126(ra) # 800039fa <holdingsleep>
    8000259c:	cd01                	beqz	a0,800025b4 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000259e:	4585                	li	a1,1
    800025a0:	8526                	mv	a0,s1
    800025a2:	00003097          	auipc	ra,0x3
    800025a6:	ee4080e7          	jalr	-284(ra) # 80005486 <virtio_disk_rw>
}
    800025aa:	60e2                	ld	ra,24(sp)
    800025ac:	6442                	ld	s0,16(sp)
    800025ae:	64a2                	ld	s1,8(sp)
    800025b0:	6105                	addi	sp,sp,32
    800025b2:	8082                	ret
    panic("bwrite");
    800025b4:	00006517          	auipc	a0,0x6
    800025b8:	f2450513          	addi	a0,a0,-220 # 800084d8 <syscalls+0xd8>
    800025bc:	00003097          	auipc	ra,0x3
    800025c0:	78c080e7          	jalr	1932(ra) # 80005d48 <panic>

00000000800025c4 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800025c4:	1101                	addi	sp,sp,-32
    800025c6:	ec06                	sd	ra,24(sp)
    800025c8:	e822                	sd	s0,16(sp)
    800025ca:	e426                	sd	s1,8(sp)
    800025cc:	e04a                	sd	s2,0(sp)
    800025ce:	1000                	addi	s0,sp,32
    800025d0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025d2:	01050913          	addi	s2,a0,16
    800025d6:	854a                	mv	a0,s2
    800025d8:	00001097          	auipc	ra,0x1
    800025dc:	422080e7          	jalr	1058(ra) # 800039fa <holdingsleep>
    800025e0:	c92d                	beqz	a0,80002652 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800025e2:	854a                	mv	a0,s2
    800025e4:	00001097          	auipc	ra,0x1
    800025e8:	3d2080e7          	jalr	978(ra) # 800039b6 <releasesleep>

  acquire(&bcache.lock);
    800025ec:	0002d517          	auipc	a0,0x2d
    800025f0:	8ac50513          	addi	a0,a0,-1876 # 8002ee98 <bcache>
    800025f4:	00004097          	auipc	ra,0x4
    800025f8:	c9e080e7          	jalr	-866(ra) # 80006292 <acquire>
  b->refcnt--;
    800025fc:	40bc                	lw	a5,64(s1)
    800025fe:	37fd                	addiw	a5,a5,-1
    80002600:	0007871b          	sext.w	a4,a5
    80002604:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002606:	eb05                	bnez	a4,80002636 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002608:	68bc                	ld	a5,80(s1)
    8000260a:	64b8                	ld	a4,72(s1)
    8000260c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000260e:	64bc                	ld	a5,72(s1)
    80002610:	68b8                	ld	a4,80(s1)
    80002612:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002614:	00035797          	auipc	a5,0x35
    80002618:	88478793          	addi	a5,a5,-1916 # 80036e98 <bcache+0x8000>
    8000261c:	2b87b703          	ld	a4,696(a5)
    80002620:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002622:	00035717          	auipc	a4,0x35
    80002626:	ade70713          	addi	a4,a4,-1314 # 80037100 <bcache+0x8268>
    8000262a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000262c:	2b87b703          	ld	a4,696(a5)
    80002630:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002632:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002636:	0002d517          	auipc	a0,0x2d
    8000263a:	86250513          	addi	a0,a0,-1950 # 8002ee98 <bcache>
    8000263e:	00004097          	auipc	ra,0x4
    80002642:	d08080e7          	jalr	-760(ra) # 80006346 <release>
}
    80002646:	60e2                	ld	ra,24(sp)
    80002648:	6442                	ld	s0,16(sp)
    8000264a:	64a2                	ld	s1,8(sp)
    8000264c:	6902                	ld	s2,0(sp)
    8000264e:	6105                	addi	sp,sp,32
    80002650:	8082                	ret
    panic("brelse");
    80002652:	00006517          	auipc	a0,0x6
    80002656:	e8e50513          	addi	a0,a0,-370 # 800084e0 <syscalls+0xe0>
    8000265a:	00003097          	auipc	ra,0x3
    8000265e:	6ee080e7          	jalr	1774(ra) # 80005d48 <panic>

0000000080002662 <bpin>:

void
bpin(struct buf *b) {
    80002662:	1101                	addi	sp,sp,-32
    80002664:	ec06                	sd	ra,24(sp)
    80002666:	e822                	sd	s0,16(sp)
    80002668:	e426                	sd	s1,8(sp)
    8000266a:	1000                	addi	s0,sp,32
    8000266c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000266e:	0002d517          	auipc	a0,0x2d
    80002672:	82a50513          	addi	a0,a0,-2006 # 8002ee98 <bcache>
    80002676:	00004097          	auipc	ra,0x4
    8000267a:	c1c080e7          	jalr	-996(ra) # 80006292 <acquire>
  b->refcnt++;
    8000267e:	40bc                	lw	a5,64(s1)
    80002680:	2785                	addiw	a5,a5,1
    80002682:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002684:	0002d517          	auipc	a0,0x2d
    80002688:	81450513          	addi	a0,a0,-2028 # 8002ee98 <bcache>
    8000268c:	00004097          	auipc	ra,0x4
    80002690:	cba080e7          	jalr	-838(ra) # 80006346 <release>
}
    80002694:	60e2                	ld	ra,24(sp)
    80002696:	6442                	ld	s0,16(sp)
    80002698:	64a2                	ld	s1,8(sp)
    8000269a:	6105                	addi	sp,sp,32
    8000269c:	8082                	ret

000000008000269e <bunpin>:

void
bunpin(struct buf *b) {
    8000269e:	1101                	addi	sp,sp,-32
    800026a0:	ec06                	sd	ra,24(sp)
    800026a2:	e822                	sd	s0,16(sp)
    800026a4:	e426                	sd	s1,8(sp)
    800026a6:	1000                	addi	s0,sp,32
    800026a8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026aa:	0002c517          	auipc	a0,0x2c
    800026ae:	7ee50513          	addi	a0,a0,2030 # 8002ee98 <bcache>
    800026b2:	00004097          	auipc	ra,0x4
    800026b6:	be0080e7          	jalr	-1056(ra) # 80006292 <acquire>
  b->refcnt--;
    800026ba:	40bc                	lw	a5,64(s1)
    800026bc:	37fd                	addiw	a5,a5,-1
    800026be:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026c0:	0002c517          	auipc	a0,0x2c
    800026c4:	7d850513          	addi	a0,a0,2008 # 8002ee98 <bcache>
    800026c8:	00004097          	auipc	ra,0x4
    800026cc:	c7e080e7          	jalr	-898(ra) # 80006346 <release>
}
    800026d0:	60e2                	ld	ra,24(sp)
    800026d2:	6442                	ld	s0,16(sp)
    800026d4:	64a2                	ld	s1,8(sp)
    800026d6:	6105                	addi	sp,sp,32
    800026d8:	8082                	ret

00000000800026da <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026da:	1101                	addi	sp,sp,-32
    800026dc:	ec06                	sd	ra,24(sp)
    800026de:	e822                	sd	s0,16(sp)
    800026e0:	e426                	sd	s1,8(sp)
    800026e2:	e04a                	sd	s2,0(sp)
    800026e4:	1000                	addi	s0,sp,32
    800026e6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026e8:	00d5d59b          	srliw	a1,a1,0xd
    800026ec:	00035797          	auipc	a5,0x35
    800026f0:	e887a783          	lw	a5,-376(a5) # 80037574 <sb+0x1c>
    800026f4:	9dbd                	addw	a1,a1,a5
    800026f6:	00000097          	auipc	ra,0x0
    800026fa:	d9e080e7          	jalr	-610(ra) # 80002494 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026fe:	0074f713          	andi	a4,s1,7
    80002702:	4785                	li	a5,1
    80002704:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002708:	14ce                	slli	s1,s1,0x33
    8000270a:	90d9                	srli	s1,s1,0x36
    8000270c:	00950733          	add	a4,a0,s1
    80002710:	05874703          	lbu	a4,88(a4)
    80002714:	00e7f6b3          	and	a3,a5,a4
    80002718:	c69d                	beqz	a3,80002746 <bfree+0x6c>
    8000271a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000271c:	94aa                	add	s1,s1,a0
    8000271e:	fff7c793          	not	a5,a5
    80002722:	8ff9                	and	a5,a5,a4
    80002724:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002728:	00001097          	auipc	ra,0x1
    8000272c:	118080e7          	jalr	280(ra) # 80003840 <log_write>
  brelse(bp);
    80002730:	854a                	mv	a0,s2
    80002732:	00000097          	auipc	ra,0x0
    80002736:	e92080e7          	jalr	-366(ra) # 800025c4 <brelse>
}
    8000273a:	60e2                	ld	ra,24(sp)
    8000273c:	6442                	ld	s0,16(sp)
    8000273e:	64a2                	ld	s1,8(sp)
    80002740:	6902                	ld	s2,0(sp)
    80002742:	6105                	addi	sp,sp,32
    80002744:	8082                	ret
    panic("freeing free block");
    80002746:	00006517          	auipc	a0,0x6
    8000274a:	da250513          	addi	a0,a0,-606 # 800084e8 <syscalls+0xe8>
    8000274e:	00003097          	auipc	ra,0x3
    80002752:	5fa080e7          	jalr	1530(ra) # 80005d48 <panic>

0000000080002756 <balloc>:
{
    80002756:	711d                	addi	sp,sp,-96
    80002758:	ec86                	sd	ra,88(sp)
    8000275a:	e8a2                	sd	s0,80(sp)
    8000275c:	e4a6                	sd	s1,72(sp)
    8000275e:	e0ca                	sd	s2,64(sp)
    80002760:	fc4e                	sd	s3,56(sp)
    80002762:	f852                	sd	s4,48(sp)
    80002764:	f456                	sd	s5,40(sp)
    80002766:	f05a                	sd	s6,32(sp)
    80002768:	ec5e                	sd	s7,24(sp)
    8000276a:	e862                	sd	s8,16(sp)
    8000276c:	e466                	sd	s9,8(sp)
    8000276e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002770:	00035797          	auipc	a5,0x35
    80002774:	dec7a783          	lw	a5,-532(a5) # 8003755c <sb+0x4>
    80002778:	cbd1                	beqz	a5,8000280c <balloc+0xb6>
    8000277a:	8baa                	mv	s7,a0
    8000277c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000277e:	00035b17          	auipc	s6,0x35
    80002782:	ddab0b13          	addi	s6,s6,-550 # 80037558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002786:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002788:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000278a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000278c:	6c89                	lui	s9,0x2
    8000278e:	a831                	j	800027aa <balloc+0x54>
    brelse(bp);
    80002790:	854a                	mv	a0,s2
    80002792:	00000097          	auipc	ra,0x0
    80002796:	e32080e7          	jalr	-462(ra) # 800025c4 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000279a:	015c87bb          	addw	a5,s9,s5
    8000279e:	00078a9b          	sext.w	s5,a5
    800027a2:	004b2703          	lw	a4,4(s6)
    800027a6:	06eaf363          	bgeu	s5,a4,8000280c <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800027aa:	41fad79b          	sraiw	a5,s5,0x1f
    800027ae:	0137d79b          	srliw	a5,a5,0x13
    800027b2:	015787bb          	addw	a5,a5,s5
    800027b6:	40d7d79b          	sraiw	a5,a5,0xd
    800027ba:	01cb2583          	lw	a1,28(s6)
    800027be:	9dbd                	addw	a1,a1,a5
    800027c0:	855e                	mv	a0,s7
    800027c2:	00000097          	auipc	ra,0x0
    800027c6:	cd2080e7          	jalr	-814(ra) # 80002494 <bread>
    800027ca:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027cc:	004b2503          	lw	a0,4(s6)
    800027d0:	000a849b          	sext.w	s1,s5
    800027d4:	8662                	mv	a2,s8
    800027d6:	faa4fde3          	bgeu	s1,a0,80002790 <balloc+0x3a>
      m = 1 << (bi % 8);
    800027da:	41f6579b          	sraiw	a5,a2,0x1f
    800027de:	01d7d69b          	srliw	a3,a5,0x1d
    800027e2:	00c6873b          	addw	a4,a3,a2
    800027e6:	00777793          	andi	a5,a4,7
    800027ea:	9f95                	subw	a5,a5,a3
    800027ec:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027f0:	4037571b          	sraiw	a4,a4,0x3
    800027f4:	00e906b3          	add	a3,s2,a4
    800027f8:	0586c683          	lbu	a3,88(a3)
    800027fc:	00d7f5b3          	and	a1,a5,a3
    80002800:	cd91                	beqz	a1,8000281c <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002802:	2605                	addiw	a2,a2,1
    80002804:	2485                	addiw	s1,s1,1
    80002806:	fd4618e3          	bne	a2,s4,800027d6 <balloc+0x80>
    8000280a:	b759                	j	80002790 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000280c:	00006517          	auipc	a0,0x6
    80002810:	cf450513          	addi	a0,a0,-780 # 80008500 <syscalls+0x100>
    80002814:	00003097          	auipc	ra,0x3
    80002818:	534080e7          	jalr	1332(ra) # 80005d48 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000281c:	974a                	add	a4,a4,s2
    8000281e:	8fd5                	or	a5,a5,a3
    80002820:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002824:	854a                	mv	a0,s2
    80002826:	00001097          	auipc	ra,0x1
    8000282a:	01a080e7          	jalr	26(ra) # 80003840 <log_write>
        brelse(bp);
    8000282e:	854a                	mv	a0,s2
    80002830:	00000097          	auipc	ra,0x0
    80002834:	d94080e7          	jalr	-620(ra) # 800025c4 <brelse>
  bp = bread(dev, bno);
    80002838:	85a6                	mv	a1,s1
    8000283a:	855e                	mv	a0,s7
    8000283c:	00000097          	auipc	ra,0x0
    80002840:	c58080e7          	jalr	-936(ra) # 80002494 <bread>
    80002844:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002846:	40000613          	li	a2,1024
    8000284a:	4581                	li	a1,0
    8000284c:	05850513          	addi	a0,a0,88
    80002850:	ffffe097          	auipc	ra,0xffffe
    80002854:	9fa080e7          	jalr	-1542(ra) # 8000024a <memset>
  log_write(bp);
    80002858:	854a                	mv	a0,s2
    8000285a:	00001097          	auipc	ra,0x1
    8000285e:	fe6080e7          	jalr	-26(ra) # 80003840 <log_write>
  brelse(bp);
    80002862:	854a                	mv	a0,s2
    80002864:	00000097          	auipc	ra,0x0
    80002868:	d60080e7          	jalr	-672(ra) # 800025c4 <brelse>
}
    8000286c:	8526                	mv	a0,s1
    8000286e:	60e6                	ld	ra,88(sp)
    80002870:	6446                	ld	s0,80(sp)
    80002872:	64a6                	ld	s1,72(sp)
    80002874:	6906                	ld	s2,64(sp)
    80002876:	79e2                	ld	s3,56(sp)
    80002878:	7a42                	ld	s4,48(sp)
    8000287a:	7aa2                	ld	s5,40(sp)
    8000287c:	7b02                	ld	s6,32(sp)
    8000287e:	6be2                	ld	s7,24(sp)
    80002880:	6c42                	ld	s8,16(sp)
    80002882:	6ca2                	ld	s9,8(sp)
    80002884:	6125                	addi	sp,sp,96
    80002886:	8082                	ret

0000000080002888 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002888:	7179                	addi	sp,sp,-48
    8000288a:	f406                	sd	ra,40(sp)
    8000288c:	f022                	sd	s0,32(sp)
    8000288e:	ec26                	sd	s1,24(sp)
    80002890:	e84a                	sd	s2,16(sp)
    80002892:	e44e                	sd	s3,8(sp)
    80002894:	e052                	sd	s4,0(sp)
    80002896:	1800                	addi	s0,sp,48
    80002898:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000289a:	47ad                	li	a5,11
    8000289c:	04b7fe63          	bgeu	a5,a1,800028f8 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800028a0:	ff45849b          	addiw	s1,a1,-12
    800028a4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028a8:	0ff00793          	li	a5,255
    800028ac:	0ae7e363          	bltu	a5,a4,80002952 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800028b0:	08052583          	lw	a1,128(a0)
    800028b4:	c5ad                	beqz	a1,8000291e <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800028b6:	00092503          	lw	a0,0(s2)
    800028ba:	00000097          	auipc	ra,0x0
    800028be:	bda080e7          	jalr	-1062(ra) # 80002494 <bread>
    800028c2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028c4:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028c8:	02049593          	slli	a1,s1,0x20
    800028cc:	9181                	srli	a1,a1,0x20
    800028ce:	058a                	slli	a1,a1,0x2
    800028d0:	00b784b3          	add	s1,a5,a1
    800028d4:	0004a983          	lw	s3,0(s1)
    800028d8:	04098d63          	beqz	s3,80002932 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800028dc:	8552                	mv	a0,s4
    800028de:	00000097          	auipc	ra,0x0
    800028e2:	ce6080e7          	jalr	-794(ra) # 800025c4 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028e6:	854e                	mv	a0,s3
    800028e8:	70a2                	ld	ra,40(sp)
    800028ea:	7402                	ld	s0,32(sp)
    800028ec:	64e2                	ld	s1,24(sp)
    800028ee:	6942                	ld	s2,16(sp)
    800028f0:	69a2                	ld	s3,8(sp)
    800028f2:	6a02                	ld	s4,0(sp)
    800028f4:	6145                	addi	sp,sp,48
    800028f6:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800028f8:	02059493          	slli	s1,a1,0x20
    800028fc:	9081                	srli	s1,s1,0x20
    800028fe:	048a                	slli	s1,s1,0x2
    80002900:	94aa                	add	s1,s1,a0
    80002902:	0504a983          	lw	s3,80(s1)
    80002906:	fe0990e3          	bnez	s3,800028e6 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000290a:	4108                	lw	a0,0(a0)
    8000290c:	00000097          	auipc	ra,0x0
    80002910:	e4a080e7          	jalr	-438(ra) # 80002756 <balloc>
    80002914:	0005099b          	sext.w	s3,a0
    80002918:	0534a823          	sw	s3,80(s1)
    8000291c:	b7e9                	j	800028e6 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000291e:	4108                	lw	a0,0(a0)
    80002920:	00000097          	auipc	ra,0x0
    80002924:	e36080e7          	jalr	-458(ra) # 80002756 <balloc>
    80002928:	0005059b          	sext.w	a1,a0
    8000292c:	08b92023          	sw	a1,128(s2)
    80002930:	b759                	j	800028b6 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002932:	00092503          	lw	a0,0(s2)
    80002936:	00000097          	auipc	ra,0x0
    8000293a:	e20080e7          	jalr	-480(ra) # 80002756 <balloc>
    8000293e:	0005099b          	sext.w	s3,a0
    80002942:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002946:	8552                	mv	a0,s4
    80002948:	00001097          	auipc	ra,0x1
    8000294c:	ef8080e7          	jalr	-264(ra) # 80003840 <log_write>
    80002950:	b771                	j	800028dc <bmap+0x54>
  panic("bmap: out of range");
    80002952:	00006517          	auipc	a0,0x6
    80002956:	bc650513          	addi	a0,a0,-1082 # 80008518 <syscalls+0x118>
    8000295a:	00003097          	auipc	ra,0x3
    8000295e:	3ee080e7          	jalr	1006(ra) # 80005d48 <panic>

0000000080002962 <iget>:
{
    80002962:	7179                	addi	sp,sp,-48
    80002964:	f406                	sd	ra,40(sp)
    80002966:	f022                	sd	s0,32(sp)
    80002968:	ec26                	sd	s1,24(sp)
    8000296a:	e84a                	sd	s2,16(sp)
    8000296c:	e44e                	sd	s3,8(sp)
    8000296e:	e052                	sd	s4,0(sp)
    80002970:	1800                	addi	s0,sp,48
    80002972:	89aa                	mv	s3,a0
    80002974:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002976:	00035517          	auipc	a0,0x35
    8000297a:	c0250513          	addi	a0,a0,-1022 # 80037578 <itable>
    8000297e:	00004097          	auipc	ra,0x4
    80002982:	914080e7          	jalr	-1772(ra) # 80006292 <acquire>
  empty = 0;
    80002986:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002988:	00035497          	auipc	s1,0x35
    8000298c:	c0848493          	addi	s1,s1,-1016 # 80037590 <itable+0x18>
    80002990:	00036697          	auipc	a3,0x36
    80002994:	69068693          	addi	a3,a3,1680 # 80039020 <log>
    80002998:	a039                	j	800029a6 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000299a:	02090b63          	beqz	s2,800029d0 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000299e:	08848493          	addi	s1,s1,136
    800029a2:	02d48a63          	beq	s1,a3,800029d6 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029a6:	449c                	lw	a5,8(s1)
    800029a8:	fef059e3          	blez	a5,8000299a <iget+0x38>
    800029ac:	4098                	lw	a4,0(s1)
    800029ae:	ff3716e3          	bne	a4,s3,8000299a <iget+0x38>
    800029b2:	40d8                	lw	a4,4(s1)
    800029b4:	ff4713e3          	bne	a4,s4,8000299a <iget+0x38>
      ip->ref++;
    800029b8:	2785                	addiw	a5,a5,1
    800029ba:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029bc:	00035517          	auipc	a0,0x35
    800029c0:	bbc50513          	addi	a0,a0,-1092 # 80037578 <itable>
    800029c4:	00004097          	auipc	ra,0x4
    800029c8:	982080e7          	jalr	-1662(ra) # 80006346 <release>
      return ip;
    800029cc:	8926                	mv	s2,s1
    800029ce:	a03d                	j	800029fc <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029d0:	f7f9                	bnez	a5,8000299e <iget+0x3c>
    800029d2:	8926                	mv	s2,s1
    800029d4:	b7e9                	j	8000299e <iget+0x3c>
  if(empty == 0)
    800029d6:	02090c63          	beqz	s2,80002a0e <iget+0xac>
  ip->dev = dev;
    800029da:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029de:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029e2:	4785                	li	a5,1
    800029e4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029e8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029ec:	00035517          	auipc	a0,0x35
    800029f0:	b8c50513          	addi	a0,a0,-1140 # 80037578 <itable>
    800029f4:	00004097          	auipc	ra,0x4
    800029f8:	952080e7          	jalr	-1710(ra) # 80006346 <release>
}
    800029fc:	854a                	mv	a0,s2
    800029fe:	70a2                	ld	ra,40(sp)
    80002a00:	7402                	ld	s0,32(sp)
    80002a02:	64e2                	ld	s1,24(sp)
    80002a04:	6942                	ld	s2,16(sp)
    80002a06:	69a2                	ld	s3,8(sp)
    80002a08:	6a02                	ld	s4,0(sp)
    80002a0a:	6145                	addi	sp,sp,48
    80002a0c:	8082                	ret
    panic("iget: no inodes");
    80002a0e:	00006517          	auipc	a0,0x6
    80002a12:	b2250513          	addi	a0,a0,-1246 # 80008530 <syscalls+0x130>
    80002a16:	00003097          	auipc	ra,0x3
    80002a1a:	332080e7          	jalr	818(ra) # 80005d48 <panic>

0000000080002a1e <fsinit>:
fsinit(int dev) {
    80002a1e:	7179                	addi	sp,sp,-48
    80002a20:	f406                	sd	ra,40(sp)
    80002a22:	f022                	sd	s0,32(sp)
    80002a24:	ec26                	sd	s1,24(sp)
    80002a26:	e84a                	sd	s2,16(sp)
    80002a28:	e44e                	sd	s3,8(sp)
    80002a2a:	1800                	addi	s0,sp,48
    80002a2c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a2e:	4585                	li	a1,1
    80002a30:	00000097          	auipc	ra,0x0
    80002a34:	a64080e7          	jalr	-1436(ra) # 80002494 <bread>
    80002a38:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a3a:	00035997          	auipc	s3,0x35
    80002a3e:	b1e98993          	addi	s3,s3,-1250 # 80037558 <sb>
    80002a42:	02000613          	li	a2,32
    80002a46:	05850593          	addi	a1,a0,88
    80002a4a:	854e                	mv	a0,s3
    80002a4c:	ffffe097          	auipc	ra,0xffffe
    80002a50:	85e080e7          	jalr	-1954(ra) # 800002aa <memmove>
  brelse(bp);
    80002a54:	8526                	mv	a0,s1
    80002a56:	00000097          	auipc	ra,0x0
    80002a5a:	b6e080e7          	jalr	-1170(ra) # 800025c4 <brelse>
  if(sb.magic != FSMAGIC)
    80002a5e:	0009a703          	lw	a4,0(s3)
    80002a62:	102037b7          	lui	a5,0x10203
    80002a66:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a6a:	02f71263          	bne	a4,a5,80002a8e <fsinit+0x70>
  initlog(dev, &sb);
    80002a6e:	00035597          	auipc	a1,0x35
    80002a72:	aea58593          	addi	a1,a1,-1302 # 80037558 <sb>
    80002a76:	854a                	mv	a0,s2
    80002a78:	00001097          	auipc	ra,0x1
    80002a7c:	b4c080e7          	jalr	-1204(ra) # 800035c4 <initlog>
}
    80002a80:	70a2                	ld	ra,40(sp)
    80002a82:	7402                	ld	s0,32(sp)
    80002a84:	64e2                	ld	s1,24(sp)
    80002a86:	6942                	ld	s2,16(sp)
    80002a88:	69a2                	ld	s3,8(sp)
    80002a8a:	6145                	addi	sp,sp,48
    80002a8c:	8082                	ret
    panic("invalid file system");
    80002a8e:	00006517          	auipc	a0,0x6
    80002a92:	ab250513          	addi	a0,a0,-1358 # 80008540 <syscalls+0x140>
    80002a96:	00003097          	auipc	ra,0x3
    80002a9a:	2b2080e7          	jalr	690(ra) # 80005d48 <panic>

0000000080002a9e <iinit>:
{
    80002a9e:	7179                	addi	sp,sp,-48
    80002aa0:	f406                	sd	ra,40(sp)
    80002aa2:	f022                	sd	s0,32(sp)
    80002aa4:	ec26                	sd	s1,24(sp)
    80002aa6:	e84a                	sd	s2,16(sp)
    80002aa8:	e44e                	sd	s3,8(sp)
    80002aaa:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002aac:	00006597          	auipc	a1,0x6
    80002ab0:	aac58593          	addi	a1,a1,-1364 # 80008558 <syscalls+0x158>
    80002ab4:	00035517          	auipc	a0,0x35
    80002ab8:	ac450513          	addi	a0,a0,-1340 # 80037578 <itable>
    80002abc:	00003097          	auipc	ra,0x3
    80002ac0:	746080e7          	jalr	1862(ra) # 80006202 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ac4:	00035497          	auipc	s1,0x35
    80002ac8:	adc48493          	addi	s1,s1,-1316 # 800375a0 <itable+0x28>
    80002acc:	00036997          	auipc	s3,0x36
    80002ad0:	56498993          	addi	s3,s3,1380 # 80039030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002ad4:	00006917          	auipc	s2,0x6
    80002ad8:	a8c90913          	addi	s2,s2,-1396 # 80008560 <syscalls+0x160>
    80002adc:	85ca                	mv	a1,s2
    80002ade:	8526                	mv	a0,s1
    80002ae0:	00001097          	auipc	ra,0x1
    80002ae4:	e46080e7          	jalr	-442(ra) # 80003926 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ae8:	08848493          	addi	s1,s1,136
    80002aec:	ff3498e3          	bne	s1,s3,80002adc <iinit+0x3e>
}
    80002af0:	70a2                	ld	ra,40(sp)
    80002af2:	7402                	ld	s0,32(sp)
    80002af4:	64e2                	ld	s1,24(sp)
    80002af6:	6942                	ld	s2,16(sp)
    80002af8:	69a2                	ld	s3,8(sp)
    80002afa:	6145                	addi	sp,sp,48
    80002afc:	8082                	ret

0000000080002afe <ialloc>:
{
    80002afe:	715d                	addi	sp,sp,-80
    80002b00:	e486                	sd	ra,72(sp)
    80002b02:	e0a2                	sd	s0,64(sp)
    80002b04:	fc26                	sd	s1,56(sp)
    80002b06:	f84a                	sd	s2,48(sp)
    80002b08:	f44e                	sd	s3,40(sp)
    80002b0a:	f052                	sd	s4,32(sp)
    80002b0c:	ec56                	sd	s5,24(sp)
    80002b0e:	e85a                	sd	s6,16(sp)
    80002b10:	e45e                	sd	s7,8(sp)
    80002b12:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b14:	00035717          	auipc	a4,0x35
    80002b18:	a5072703          	lw	a4,-1456(a4) # 80037564 <sb+0xc>
    80002b1c:	4785                	li	a5,1
    80002b1e:	04e7fa63          	bgeu	a5,a4,80002b72 <ialloc+0x74>
    80002b22:	8aaa                	mv	s5,a0
    80002b24:	8bae                	mv	s7,a1
    80002b26:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b28:	00035a17          	auipc	s4,0x35
    80002b2c:	a30a0a13          	addi	s4,s4,-1488 # 80037558 <sb>
    80002b30:	00048b1b          	sext.w	s6,s1
    80002b34:	0044d593          	srli	a1,s1,0x4
    80002b38:	018a2783          	lw	a5,24(s4)
    80002b3c:	9dbd                	addw	a1,a1,a5
    80002b3e:	8556                	mv	a0,s5
    80002b40:	00000097          	auipc	ra,0x0
    80002b44:	954080e7          	jalr	-1708(ra) # 80002494 <bread>
    80002b48:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b4a:	05850993          	addi	s3,a0,88
    80002b4e:	00f4f793          	andi	a5,s1,15
    80002b52:	079a                	slli	a5,a5,0x6
    80002b54:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b56:	00099783          	lh	a5,0(s3)
    80002b5a:	c785                	beqz	a5,80002b82 <ialloc+0x84>
    brelse(bp);
    80002b5c:	00000097          	auipc	ra,0x0
    80002b60:	a68080e7          	jalr	-1432(ra) # 800025c4 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b64:	0485                	addi	s1,s1,1
    80002b66:	00ca2703          	lw	a4,12(s4)
    80002b6a:	0004879b          	sext.w	a5,s1
    80002b6e:	fce7e1e3          	bltu	a5,a4,80002b30 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002b72:	00006517          	auipc	a0,0x6
    80002b76:	9f650513          	addi	a0,a0,-1546 # 80008568 <syscalls+0x168>
    80002b7a:	00003097          	auipc	ra,0x3
    80002b7e:	1ce080e7          	jalr	462(ra) # 80005d48 <panic>
      memset(dip, 0, sizeof(*dip));
    80002b82:	04000613          	li	a2,64
    80002b86:	4581                	li	a1,0
    80002b88:	854e                	mv	a0,s3
    80002b8a:	ffffd097          	auipc	ra,0xffffd
    80002b8e:	6c0080e7          	jalr	1728(ra) # 8000024a <memset>
      dip->type = type;
    80002b92:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b96:	854a                	mv	a0,s2
    80002b98:	00001097          	auipc	ra,0x1
    80002b9c:	ca8080e7          	jalr	-856(ra) # 80003840 <log_write>
      brelse(bp);
    80002ba0:	854a                	mv	a0,s2
    80002ba2:	00000097          	auipc	ra,0x0
    80002ba6:	a22080e7          	jalr	-1502(ra) # 800025c4 <brelse>
      return iget(dev, inum);
    80002baa:	85da                	mv	a1,s6
    80002bac:	8556                	mv	a0,s5
    80002bae:	00000097          	auipc	ra,0x0
    80002bb2:	db4080e7          	jalr	-588(ra) # 80002962 <iget>
}
    80002bb6:	60a6                	ld	ra,72(sp)
    80002bb8:	6406                	ld	s0,64(sp)
    80002bba:	74e2                	ld	s1,56(sp)
    80002bbc:	7942                	ld	s2,48(sp)
    80002bbe:	79a2                	ld	s3,40(sp)
    80002bc0:	7a02                	ld	s4,32(sp)
    80002bc2:	6ae2                	ld	s5,24(sp)
    80002bc4:	6b42                	ld	s6,16(sp)
    80002bc6:	6ba2                	ld	s7,8(sp)
    80002bc8:	6161                	addi	sp,sp,80
    80002bca:	8082                	ret

0000000080002bcc <iupdate>:
{
    80002bcc:	1101                	addi	sp,sp,-32
    80002bce:	ec06                	sd	ra,24(sp)
    80002bd0:	e822                	sd	s0,16(sp)
    80002bd2:	e426                	sd	s1,8(sp)
    80002bd4:	e04a                	sd	s2,0(sp)
    80002bd6:	1000                	addi	s0,sp,32
    80002bd8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bda:	415c                	lw	a5,4(a0)
    80002bdc:	0047d79b          	srliw	a5,a5,0x4
    80002be0:	00035597          	auipc	a1,0x35
    80002be4:	9905a583          	lw	a1,-1648(a1) # 80037570 <sb+0x18>
    80002be8:	9dbd                	addw	a1,a1,a5
    80002bea:	4108                	lw	a0,0(a0)
    80002bec:	00000097          	auipc	ra,0x0
    80002bf0:	8a8080e7          	jalr	-1880(ra) # 80002494 <bread>
    80002bf4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bf6:	05850793          	addi	a5,a0,88
    80002bfa:	40c8                	lw	a0,4(s1)
    80002bfc:	893d                	andi	a0,a0,15
    80002bfe:	051a                	slli	a0,a0,0x6
    80002c00:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c02:	04449703          	lh	a4,68(s1)
    80002c06:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c0a:	04649703          	lh	a4,70(s1)
    80002c0e:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c12:	04849703          	lh	a4,72(s1)
    80002c16:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c1a:	04a49703          	lh	a4,74(s1)
    80002c1e:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c22:	44f8                	lw	a4,76(s1)
    80002c24:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c26:	03400613          	li	a2,52
    80002c2a:	05048593          	addi	a1,s1,80
    80002c2e:	0531                	addi	a0,a0,12
    80002c30:	ffffd097          	auipc	ra,0xffffd
    80002c34:	67a080e7          	jalr	1658(ra) # 800002aa <memmove>
  log_write(bp);
    80002c38:	854a                	mv	a0,s2
    80002c3a:	00001097          	auipc	ra,0x1
    80002c3e:	c06080e7          	jalr	-1018(ra) # 80003840 <log_write>
  brelse(bp);
    80002c42:	854a                	mv	a0,s2
    80002c44:	00000097          	auipc	ra,0x0
    80002c48:	980080e7          	jalr	-1664(ra) # 800025c4 <brelse>
}
    80002c4c:	60e2                	ld	ra,24(sp)
    80002c4e:	6442                	ld	s0,16(sp)
    80002c50:	64a2                	ld	s1,8(sp)
    80002c52:	6902                	ld	s2,0(sp)
    80002c54:	6105                	addi	sp,sp,32
    80002c56:	8082                	ret

0000000080002c58 <idup>:
{
    80002c58:	1101                	addi	sp,sp,-32
    80002c5a:	ec06                	sd	ra,24(sp)
    80002c5c:	e822                	sd	s0,16(sp)
    80002c5e:	e426                	sd	s1,8(sp)
    80002c60:	1000                	addi	s0,sp,32
    80002c62:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c64:	00035517          	auipc	a0,0x35
    80002c68:	91450513          	addi	a0,a0,-1772 # 80037578 <itable>
    80002c6c:	00003097          	auipc	ra,0x3
    80002c70:	626080e7          	jalr	1574(ra) # 80006292 <acquire>
  ip->ref++;
    80002c74:	449c                	lw	a5,8(s1)
    80002c76:	2785                	addiw	a5,a5,1
    80002c78:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c7a:	00035517          	auipc	a0,0x35
    80002c7e:	8fe50513          	addi	a0,a0,-1794 # 80037578 <itable>
    80002c82:	00003097          	auipc	ra,0x3
    80002c86:	6c4080e7          	jalr	1732(ra) # 80006346 <release>
}
    80002c8a:	8526                	mv	a0,s1
    80002c8c:	60e2                	ld	ra,24(sp)
    80002c8e:	6442                	ld	s0,16(sp)
    80002c90:	64a2                	ld	s1,8(sp)
    80002c92:	6105                	addi	sp,sp,32
    80002c94:	8082                	ret

0000000080002c96 <ilock>:
{
    80002c96:	1101                	addi	sp,sp,-32
    80002c98:	ec06                	sd	ra,24(sp)
    80002c9a:	e822                	sd	s0,16(sp)
    80002c9c:	e426                	sd	s1,8(sp)
    80002c9e:	e04a                	sd	s2,0(sp)
    80002ca0:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ca2:	c115                	beqz	a0,80002cc6 <ilock+0x30>
    80002ca4:	84aa                	mv	s1,a0
    80002ca6:	451c                	lw	a5,8(a0)
    80002ca8:	00f05f63          	blez	a5,80002cc6 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002cac:	0541                	addi	a0,a0,16
    80002cae:	00001097          	auipc	ra,0x1
    80002cb2:	cb2080e7          	jalr	-846(ra) # 80003960 <acquiresleep>
  if(ip->valid == 0){
    80002cb6:	40bc                	lw	a5,64(s1)
    80002cb8:	cf99                	beqz	a5,80002cd6 <ilock+0x40>
}
    80002cba:	60e2                	ld	ra,24(sp)
    80002cbc:	6442                	ld	s0,16(sp)
    80002cbe:	64a2                	ld	s1,8(sp)
    80002cc0:	6902                	ld	s2,0(sp)
    80002cc2:	6105                	addi	sp,sp,32
    80002cc4:	8082                	ret
    panic("ilock");
    80002cc6:	00006517          	auipc	a0,0x6
    80002cca:	8ba50513          	addi	a0,a0,-1862 # 80008580 <syscalls+0x180>
    80002cce:	00003097          	auipc	ra,0x3
    80002cd2:	07a080e7          	jalr	122(ra) # 80005d48 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cd6:	40dc                	lw	a5,4(s1)
    80002cd8:	0047d79b          	srliw	a5,a5,0x4
    80002cdc:	00035597          	auipc	a1,0x35
    80002ce0:	8945a583          	lw	a1,-1900(a1) # 80037570 <sb+0x18>
    80002ce4:	9dbd                	addw	a1,a1,a5
    80002ce6:	4088                	lw	a0,0(s1)
    80002ce8:	fffff097          	auipc	ra,0xfffff
    80002cec:	7ac080e7          	jalr	1964(ra) # 80002494 <bread>
    80002cf0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cf2:	05850593          	addi	a1,a0,88
    80002cf6:	40dc                	lw	a5,4(s1)
    80002cf8:	8bbd                	andi	a5,a5,15
    80002cfa:	079a                	slli	a5,a5,0x6
    80002cfc:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002cfe:	00059783          	lh	a5,0(a1)
    80002d02:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d06:	00259783          	lh	a5,2(a1)
    80002d0a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d0e:	00459783          	lh	a5,4(a1)
    80002d12:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d16:	00659783          	lh	a5,6(a1)
    80002d1a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d1e:	459c                	lw	a5,8(a1)
    80002d20:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d22:	03400613          	li	a2,52
    80002d26:	05b1                	addi	a1,a1,12
    80002d28:	05048513          	addi	a0,s1,80
    80002d2c:	ffffd097          	auipc	ra,0xffffd
    80002d30:	57e080e7          	jalr	1406(ra) # 800002aa <memmove>
    brelse(bp);
    80002d34:	854a                	mv	a0,s2
    80002d36:	00000097          	auipc	ra,0x0
    80002d3a:	88e080e7          	jalr	-1906(ra) # 800025c4 <brelse>
    ip->valid = 1;
    80002d3e:	4785                	li	a5,1
    80002d40:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d42:	04449783          	lh	a5,68(s1)
    80002d46:	fbb5                	bnez	a5,80002cba <ilock+0x24>
      panic("ilock: no type");
    80002d48:	00006517          	auipc	a0,0x6
    80002d4c:	84050513          	addi	a0,a0,-1984 # 80008588 <syscalls+0x188>
    80002d50:	00003097          	auipc	ra,0x3
    80002d54:	ff8080e7          	jalr	-8(ra) # 80005d48 <panic>

0000000080002d58 <iunlock>:
{
    80002d58:	1101                	addi	sp,sp,-32
    80002d5a:	ec06                	sd	ra,24(sp)
    80002d5c:	e822                	sd	s0,16(sp)
    80002d5e:	e426                	sd	s1,8(sp)
    80002d60:	e04a                	sd	s2,0(sp)
    80002d62:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d64:	c905                	beqz	a0,80002d94 <iunlock+0x3c>
    80002d66:	84aa                	mv	s1,a0
    80002d68:	01050913          	addi	s2,a0,16
    80002d6c:	854a                	mv	a0,s2
    80002d6e:	00001097          	auipc	ra,0x1
    80002d72:	c8c080e7          	jalr	-884(ra) # 800039fa <holdingsleep>
    80002d76:	cd19                	beqz	a0,80002d94 <iunlock+0x3c>
    80002d78:	449c                	lw	a5,8(s1)
    80002d7a:	00f05d63          	blez	a5,80002d94 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d7e:	854a                	mv	a0,s2
    80002d80:	00001097          	auipc	ra,0x1
    80002d84:	c36080e7          	jalr	-970(ra) # 800039b6 <releasesleep>
}
    80002d88:	60e2                	ld	ra,24(sp)
    80002d8a:	6442                	ld	s0,16(sp)
    80002d8c:	64a2                	ld	s1,8(sp)
    80002d8e:	6902                	ld	s2,0(sp)
    80002d90:	6105                	addi	sp,sp,32
    80002d92:	8082                	ret
    panic("iunlock");
    80002d94:	00006517          	auipc	a0,0x6
    80002d98:	80450513          	addi	a0,a0,-2044 # 80008598 <syscalls+0x198>
    80002d9c:	00003097          	auipc	ra,0x3
    80002da0:	fac080e7          	jalr	-84(ra) # 80005d48 <panic>

0000000080002da4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002da4:	7179                	addi	sp,sp,-48
    80002da6:	f406                	sd	ra,40(sp)
    80002da8:	f022                	sd	s0,32(sp)
    80002daa:	ec26                	sd	s1,24(sp)
    80002dac:	e84a                	sd	s2,16(sp)
    80002dae:	e44e                	sd	s3,8(sp)
    80002db0:	e052                	sd	s4,0(sp)
    80002db2:	1800                	addi	s0,sp,48
    80002db4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002db6:	05050493          	addi	s1,a0,80
    80002dba:	08050913          	addi	s2,a0,128
    80002dbe:	a021                	j	80002dc6 <itrunc+0x22>
    80002dc0:	0491                	addi	s1,s1,4
    80002dc2:	01248d63          	beq	s1,s2,80002ddc <itrunc+0x38>
    if(ip->addrs[i]){
    80002dc6:	408c                	lw	a1,0(s1)
    80002dc8:	dde5                	beqz	a1,80002dc0 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002dca:	0009a503          	lw	a0,0(s3)
    80002dce:	00000097          	auipc	ra,0x0
    80002dd2:	90c080e7          	jalr	-1780(ra) # 800026da <bfree>
      ip->addrs[i] = 0;
    80002dd6:	0004a023          	sw	zero,0(s1)
    80002dda:	b7dd                	j	80002dc0 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ddc:	0809a583          	lw	a1,128(s3)
    80002de0:	e185                	bnez	a1,80002e00 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002de2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002de6:	854e                	mv	a0,s3
    80002de8:	00000097          	auipc	ra,0x0
    80002dec:	de4080e7          	jalr	-540(ra) # 80002bcc <iupdate>
}
    80002df0:	70a2                	ld	ra,40(sp)
    80002df2:	7402                	ld	s0,32(sp)
    80002df4:	64e2                	ld	s1,24(sp)
    80002df6:	6942                	ld	s2,16(sp)
    80002df8:	69a2                	ld	s3,8(sp)
    80002dfa:	6a02                	ld	s4,0(sp)
    80002dfc:	6145                	addi	sp,sp,48
    80002dfe:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e00:	0009a503          	lw	a0,0(s3)
    80002e04:	fffff097          	auipc	ra,0xfffff
    80002e08:	690080e7          	jalr	1680(ra) # 80002494 <bread>
    80002e0c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e0e:	05850493          	addi	s1,a0,88
    80002e12:	45850913          	addi	s2,a0,1112
    80002e16:	a811                	j	80002e2a <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e18:	0009a503          	lw	a0,0(s3)
    80002e1c:	00000097          	auipc	ra,0x0
    80002e20:	8be080e7          	jalr	-1858(ra) # 800026da <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e24:	0491                	addi	s1,s1,4
    80002e26:	01248563          	beq	s1,s2,80002e30 <itrunc+0x8c>
      if(a[j])
    80002e2a:	408c                	lw	a1,0(s1)
    80002e2c:	dde5                	beqz	a1,80002e24 <itrunc+0x80>
    80002e2e:	b7ed                	j	80002e18 <itrunc+0x74>
    brelse(bp);
    80002e30:	8552                	mv	a0,s4
    80002e32:	fffff097          	auipc	ra,0xfffff
    80002e36:	792080e7          	jalr	1938(ra) # 800025c4 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e3a:	0809a583          	lw	a1,128(s3)
    80002e3e:	0009a503          	lw	a0,0(s3)
    80002e42:	00000097          	auipc	ra,0x0
    80002e46:	898080e7          	jalr	-1896(ra) # 800026da <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e4a:	0809a023          	sw	zero,128(s3)
    80002e4e:	bf51                	j	80002de2 <itrunc+0x3e>

0000000080002e50 <iput>:
{
    80002e50:	1101                	addi	sp,sp,-32
    80002e52:	ec06                	sd	ra,24(sp)
    80002e54:	e822                	sd	s0,16(sp)
    80002e56:	e426                	sd	s1,8(sp)
    80002e58:	e04a                	sd	s2,0(sp)
    80002e5a:	1000                	addi	s0,sp,32
    80002e5c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e5e:	00034517          	auipc	a0,0x34
    80002e62:	71a50513          	addi	a0,a0,1818 # 80037578 <itable>
    80002e66:	00003097          	auipc	ra,0x3
    80002e6a:	42c080e7          	jalr	1068(ra) # 80006292 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e6e:	4498                	lw	a4,8(s1)
    80002e70:	4785                	li	a5,1
    80002e72:	02f70363          	beq	a4,a5,80002e98 <iput+0x48>
  ip->ref--;
    80002e76:	449c                	lw	a5,8(s1)
    80002e78:	37fd                	addiw	a5,a5,-1
    80002e7a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e7c:	00034517          	auipc	a0,0x34
    80002e80:	6fc50513          	addi	a0,a0,1788 # 80037578 <itable>
    80002e84:	00003097          	auipc	ra,0x3
    80002e88:	4c2080e7          	jalr	1218(ra) # 80006346 <release>
}
    80002e8c:	60e2                	ld	ra,24(sp)
    80002e8e:	6442                	ld	s0,16(sp)
    80002e90:	64a2                	ld	s1,8(sp)
    80002e92:	6902                	ld	s2,0(sp)
    80002e94:	6105                	addi	sp,sp,32
    80002e96:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e98:	40bc                	lw	a5,64(s1)
    80002e9a:	dff1                	beqz	a5,80002e76 <iput+0x26>
    80002e9c:	04a49783          	lh	a5,74(s1)
    80002ea0:	fbf9                	bnez	a5,80002e76 <iput+0x26>
    acquiresleep(&ip->lock);
    80002ea2:	01048913          	addi	s2,s1,16
    80002ea6:	854a                	mv	a0,s2
    80002ea8:	00001097          	auipc	ra,0x1
    80002eac:	ab8080e7          	jalr	-1352(ra) # 80003960 <acquiresleep>
    release(&itable.lock);
    80002eb0:	00034517          	auipc	a0,0x34
    80002eb4:	6c850513          	addi	a0,a0,1736 # 80037578 <itable>
    80002eb8:	00003097          	auipc	ra,0x3
    80002ebc:	48e080e7          	jalr	1166(ra) # 80006346 <release>
    itrunc(ip);
    80002ec0:	8526                	mv	a0,s1
    80002ec2:	00000097          	auipc	ra,0x0
    80002ec6:	ee2080e7          	jalr	-286(ra) # 80002da4 <itrunc>
    ip->type = 0;
    80002eca:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ece:	8526                	mv	a0,s1
    80002ed0:	00000097          	auipc	ra,0x0
    80002ed4:	cfc080e7          	jalr	-772(ra) # 80002bcc <iupdate>
    ip->valid = 0;
    80002ed8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002edc:	854a                	mv	a0,s2
    80002ede:	00001097          	auipc	ra,0x1
    80002ee2:	ad8080e7          	jalr	-1320(ra) # 800039b6 <releasesleep>
    acquire(&itable.lock);
    80002ee6:	00034517          	auipc	a0,0x34
    80002eea:	69250513          	addi	a0,a0,1682 # 80037578 <itable>
    80002eee:	00003097          	auipc	ra,0x3
    80002ef2:	3a4080e7          	jalr	932(ra) # 80006292 <acquire>
    80002ef6:	b741                	j	80002e76 <iput+0x26>

0000000080002ef8 <iunlockput>:
{
    80002ef8:	1101                	addi	sp,sp,-32
    80002efa:	ec06                	sd	ra,24(sp)
    80002efc:	e822                	sd	s0,16(sp)
    80002efe:	e426                	sd	s1,8(sp)
    80002f00:	1000                	addi	s0,sp,32
    80002f02:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f04:	00000097          	auipc	ra,0x0
    80002f08:	e54080e7          	jalr	-428(ra) # 80002d58 <iunlock>
  iput(ip);
    80002f0c:	8526                	mv	a0,s1
    80002f0e:	00000097          	auipc	ra,0x0
    80002f12:	f42080e7          	jalr	-190(ra) # 80002e50 <iput>
}
    80002f16:	60e2                	ld	ra,24(sp)
    80002f18:	6442                	ld	s0,16(sp)
    80002f1a:	64a2                	ld	s1,8(sp)
    80002f1c:	6105                	addi	sp,sp,32
    80002f1e:	8082                	ret

0000000080002f20 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f20:	1141                	addi	sp,sp,-16
    80002f22:	e422                	sd	s0,8(sp)
    80002f24:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f26:	411c                	lw	a5,0(a0)
    80002f28:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f2a:	415c                	lw	a5,4(a0)
    80002f2c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f2e:	04451783          	lh	a5,68(a0)
    80002f32:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f36:	04a51783          	lh	a5,74(a0)
    80002f3a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f3e:	04c56783          	lwu	a5,76(a0)
    80002f42:	e99c                	sd	a5,16(a1)
}
    80002f44:	6422                	ld	s0,8(sp)
    80002f46:	0141                	addi	sp,sp,16
    80002f48:	8082                	ret

0000000080002f4a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f4a:	457c                	lw	a5,76(a0)
    80002f4c:	0ed7e963          	bltu	a5,a3,8000303e <readi+0xf4>
{
    80002f50:	7159                	addi	sp,sp,-112
    80002f52:	f486                	sd	ra,104(sp)
    80002f54:	f0a2                	sd	s0,96(sp)
    80002f56:	eca6                	sd	s1,88(sp)
    80002f58:	e8ca                	sd	s2,80(sp)
    80002f5a:	e4ce                	sd	s3,72(sp)
    80002f5c:	e0d2                	sd	s4,64(sp)
    80002f5e:	fc56                	sd	s5,56(sp)
    80002f60:	f85a                	sd	s6,48(sp)
    80002f62:	f45e                	sd	s7,40(sp)
    80002f64:	f062                	sd	s8,32(sp)
    80002f66:	ec66                	sd	s9,24(sp)
    80002f68:	e86a                	sd	s10,16(sp)
    80002f6a:	e46e                	sd	s11,8(sp)
    80002f6c:	1880                	addi	s0,sp,112
    80002f6e:	8baa                	mv	s7,a0
    80002f70:	8c2e                	mv	s8,a1
    80002f72:	8ab2                	mv	s5,a2
    80002f74:	84b6                	mv	s1,a3
    80002f76:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f78:	9f35                	addw	a4,a4,a3
    return 0;
    80002f7a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f7c:	0ad76063          	bltu	a4,a3,8000301c <readi+0xd2>
  if(off + n > ip->size)
    80002f80:	00e7f463          	bgeu	a5,a4,80002f88 <readi+0x3e>
    n = ip->size - off;
    80002f84:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f88:	0a0b0963          	beqz	s6,8000303a <readi+0xf0>
    80002f8c:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f8e:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f92:	5cfd                	li	s9,-1
    80002f94:	a82d                	j	80002fce <readi+0x84>
    80002f96:	020a1d93          	slli	s11,s4,0x20
    80002f9a:	020ddd93          	srli	s11,s11,0x20
    80002f9e:	05890613          	addi	a2,s2,88
    80002fa2:	86ee                	mv	a3,s11
    80002fa4:	963a                	add	a2,a2,a4
    80002fa6:	85d6                	mv	a1,s5
    80002fa8:	8562                	mv	a0,s8
    80002faa:	fffff097          	auipc	ra,0xfffff
    80002fae:	a5a080e7          	jalr	-1446(ra) # 80001a04 <either_copyout>
    80002fb2:	05950d63          	beq	a0,s9,8000300c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fb6:	854a                	mv	a0,s2
    80002fb8:	fffff097          	auipc	ra,0xfffff
    80002fbc:	60c080e7          	jalr	1548(ra) # 800025c4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fc0:	013a09bb          	addw	s3,s4,s3
    80002fc4:	009a04bb          	addw	s1,s4,s1
    80002fc8:	9aee                	add	s5,s5,s11
    80002fca:	0569f763          	bgeu	s3,s6,80003018 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fce:	000ba903          	lw	s2,0(s7)
    80002fd2:	00a4d59b          	srliw	a1,s1,0xa
    80002fd6:	855e                	mv	a0,s7
    80002fd8:	00000097          	auipc	ra,0x0
    80002fdc:	8b0080e7          	jalr	-1872(ra) # 80002888 <bmap>
    80002fe0:	0005059b          	sext.w	a1,a0
    80002fe4:	854a                	mv	a0,s2
    80002fe6:	fffff097          	auipc	ra,0xfffff
    80002fea:	4ae080e7          	jalr	1198(ra) # 80002494 <bread>
    80002fee:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ff0:	3ff4f713          	andi	a4,s1,1023
    80002ff4:	40ed07bb          	subw	a5,s10,a4
    80002ff8:	413b06bb          	subw	a3,s6,s3
    80002ffc:	8a3e                	mv	s4,a5
    80002ffe:	2781                	sext.w	a5,a5
    80003000:	0006861b          	sext.w	a2,a3
    80003004:	f8f679e3          	bgeu	a2,a5,80002f96 <readi+0x4c>
    80003008:	8a36                	mv	s4,a3
    8000300a:	b771                	j	80002f96 <readi+0x4c>
      brelse(bp);
    8000300c:	854a                	mv	a0,s2
    8000300e:	fffff097          	auipc	ra,0xfffff
    80003012:	5b6080e7          	jalr	1462(ra) # 800025c4 <brelse>
      tot = -1;
    80003016:	59fd                	li	s3,-1
  }
  return tot;
    80003018:	0009851b          	sext.w	a0,s3
}
    8000301c:	70a6                	ld	ra,104(sp)
    8000301e:	7406                	ld	s0,96(sp)
    80003020:	64e6                	ld	s1,88(sp)
    80003022:	6946                	ld	s2,80(sp)
    80003024:	69a6                	ld	s3,72(sp)
    80003026:	6a06                	ld	s4,64(sp)
    80003028:	7ae2                	ld	s5,56(sp)
    8000302a:	7b42                	ld	s6,48(sp)
    8000302c:	7ba2                	ld	s7,40(sp)
    8000302e:	7c02                	ld	s8,32(sp)
    80003030:	6ce2                	ld	s9,24(sp)
    80003032:	6d42                	ld	s10,16(sp)
    80003034:	6da2                	ld	s11,8(sp)
    80003036:	6165                	addi	sp,sp,112
    80003038:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000303a:	89da                	mv	s3,s6
    8000303c:	bff1                	j	80003018 <readi+0xce>
    return 0;
    8000303e:	4501                	li	a0,0
}
    80003040:	8082                	ret

0000000080003042 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003042:	457c                	lw	a5,76(a0)
    80003044:	10d7e863          	bltu	a5,a3,80003154 <writei+0x112>
{
    80003048:	7159                	addi	sp,sp,-112
    8000304a:	f486                	sd	ra,104(sp)
    8000304c:	f0a2                	sd	s0,96(sp)
    8000304e:	eca6                	sd	s1,88(sp)
    80003050:	e8ca                	sd	s2,80(sp)
    80003052:	e4ce                	sd	s3,72(sp)
    80003054:	e0d2                	sd	s4,64(sp)
    80003056:	fc56                	sd	s5,56(sp)
    80003058:	f85a                	sd	s6,48(sp)
    8000305a:	f45e                	sd	s7,40(sp)
    8000305c:	f062                	sd	s8,32(sp)
    8000305e:	ec66                	sd	s9,24(sp)
    80003060:	e86a                	sd	s10,16(sp)
    80003062:	e46e                	sd	s11,8(sp)
    80003064:	1880                	addi	s0,sp,112
    80003066:	8b2a                	mv	s6,a0
    80003068:	8c2e                	mv	s8,a1
    8000306a:	8ab2                	mv	s5,a2
    8000306c:	8936                	mv	s2,a3
    8000306e:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003070:	00e687bb          	addw	a5,a3,a4
    80003074:	0ed7e263          	bltu	a5,a3,80003158 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003078:	00043737          	lui	a4,0x43
    8000307c:	0ef76063          	bltu	a4,a5,8000315c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003080:	0c0b8863          	beqz	s7,80003150 <writei+0x10e>
    80003084:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003086:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000308a:	5cfd                	li	s9,-1
    8000308c:	a091                	j	800030d0 <writei+0x8e>
    8000308e:	02099d93          	slli	s11,s3,0x20
    80003092:	020ddd93          	srli	s11,s11,0x20
    80003096:	05848513          	addi	a0,s1,88
    8000309a:	86ee                	mv	a3,s11
    8000309c:	8656                	mv	a2,s5
    8000309e:	85e2                	mv	a1,s8
    800030a0:	953a                	add	a0,a0,a4
    800030a2:	fffff097          	auipc	ra,0xfffff
    800030a6:	9b8080e7          	jalr	-1608(ra) # 80001a5a <either_copyin>
    800030aa:	07950263          	beq	a0,s9,8000310e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030ae:	8526                	mv	a0,s1
    800030b0:	00000097          	auipc	ra,0x0
    800030b4:	790080e7          	jalr	1936(ra) # 80003840 <log_write>
    brelse(bp);
    800030b8:	8526                	mv	a0,s1
    800030ba:	fffff097          	auipc	ra,0xfffff
    800030be:	50a080e7          	jalr	1290(ra) # 800025c4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030c2:	01498a3b          	addw	s4,s3,s4
    800030c6:	0129893b          	addw	s2,s3,s2
    800030ca:	9aee                	add	s5,s5,s11
    800030cc:	057a7663          	bgeu	s4,s7,80003118 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030d0:	000b2483          	lw	s1,0(s6)
    800030d4:	00a9559b          	srliw	a1,s2,0xa
    800030d8:	855a                	mv	a0,s6
    800030da:	fffff097          	auipc	ra,0xfffff
    800030de:	7ae080e7          	jalr	1966(ra) # 80002888 <bmap>
    800030e2:	0005059b          	sext.w	a1,a0
    800030e6:	8526                	mv	a0,s1
    800030e8:	fffff097          	auipc	ra,0xfffff
    800030ec:	3ac080e7          	jalr	940(ra) # 80002494 <bread>
    800030f0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030f2:	3ff97713          	andi	a4,s2,1023
    800030f6:	40ed07bb          	subw	a5,s10,a4
    800030fa:	414b86bb          	subw	a3,s7,s4
    800030fe:	89be                	mv	s3,a5
    80003100:	2781                	sext.w	a5,a5
    80003102:	0006861b          	sext.w	a2,a3
    80003106:	f8f674e3          	bgeu	a2,a5,8000308e <writei+0x4c>
    8000310a:	89b6                	mv	s3,a3
    8000310c:	b749                	j	8000308e <writei+0x4c>
      brelse(bp);
    8000310e:	8526                	mv	a0,s1
    80003110:	fffff097          	auipc	ra,0xfffff
    80003114:	4b4080e7          	jalr	1204(ra) # 800025c4 <brelse>
  }

  if(off > ip->size)
    80003118:	04cb2783          	lw	a5,76(s6)
    8000311c:	0127f463          	bgeu	a5,s2,80003124 <writei+0xe2>
    ip->size = off;
    80003120:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003124:	855a                	mv	a0,s6
    80003126:	00000097          	auipc	ra,0x0
    8000312a:	aa6080e7          	jalr	-1370(ra) # 80002bcc <iupdate>

  return tot;
    8000312e:	000a051b          	sext.w	a0,s4
}
    80003132:	70a6                	ld	ra,104(sp)
    80003134:	7406                	ld	s0,96(sp)
    80003136:	64e6                	ld	s1,88(sp)
    80003138:	6946                	ld	s2,80(sp)
    8000313a:	69a6                	ld	s3,72(sp)
    8000313c:	6a06                	ld	s4,64(sp)
    8000313e:	7ae2                	ld	s5,56(sp)
    80003140:	7b42                	ld	s6,48(sp)
    80003142:	7ba2                	ld	s7,40(sp)
    80003144:	7c02                	ld	s8,32(sp)
    80003146:	6ce2                	ld	s9,24(sp)
    80003148:	6d42                	ld	s10,16(sp)
    8000314a:	6da2                	ld	s11,8(sp)
    8000314c:	6165                	addi	sp,sp,112
    8000314e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003150:	8a5e                	mv	s4,s7
    80003152:	bfc9                	j	80003124 <writei+0xe2>
    return -1;
    80003154:	557d                	li	a0,-1
}
    80003156:	8082                	ret
    return -1;
    80003158:	557d                	li	a0,-1
    8000315a:	bfe1                	j	80003132 <writei+0xf0>
    return -1;
    8000315c:	557d                	li	a0,-1
    8000315e:	bfd1                	j	80003132 <writei+0xf0>

0000000080003160 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003160:	1141                	addi	sp,sp,-16
    80003162:	e406                	sd	ra,8(sp)
    80003164:	e022                	sd	s0,0(sp)
    80003166:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003168:	4639                	li	a2,14
    8000316a:	ffffd097          	auipc	ra,0xffffd
    8000316e:	1b8080e7          	jalr	440(ra) # 80000322 <strncmp>
}
    80003172:	60a2                	ld	ra,8(sp)
    80003174:	6402                	ld	s0,0(sp)
    80003176:	0141                	addi	sp,sp,16
    80003178:	8082                	ret

000000008000317a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000317a:	7139                	addi	sp,sp,-64
    8000317c:	fc06                	sd	ra,56(sp)
    8000317e:	f822                	sd	s0,48(sp)
    80003180:	f426                	sd	s1,40(sp)
    80003182:	f04a                	sd	s2,32(sp)
    80003184:	ec4e                	sd	s3,24(sp)
    80003186:	e852                	sd	s4,16(sp)
    80003188:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000318a:	04451703          	lh	a4,68(a0)
    8000318e:	4785                	li	a5,1
    80003190:	00f71a63          	bne	a4,a5,800031a4 <dirlookup+0x2a>
    80003194:	892a                	mv	s2,a0
    80003196:	89ae                	mv	s3,a1
    80003198:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000319a:	457c                	lw	a5,76(a0)
    8000319c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000319e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031a0:	e79d                	bnez	a5,800031ce <dirlookup+0x54>
    800031a2:	a8a5                	j	8000321a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031a4:	00005517          	auipc	a0,0x5
    800031a8:	3fc50513          	addi	a0,a0,1020 # 800085a0 <syscalls+0x1a0>
    800031ac:	00003097          	auipc	ra,0x3
    800031b0:	b9c080e7          	jalr	-1124(ra) # 80005d48 <panic>
      panic("dirlookup read");
    800031b4:	00005517          	auipc	a0,0x5
    800031b8:	40450513          	addi	a0,a0,1028 # 800085b8 <syscalls+0x1b8>
    800031bc:	00003097          	auipc	ra,0x3
    800031c0:	b8c080e7          	jalr	-1140(ra) # 80005d48 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031c4:	24c1                	addiw	s1,s1,16
    800031c6:	04c92783          	lw	a5,76(s2)
    800031ca:	04f4f763          	bgeu	s1,a5,80003218 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031ce:	4741                	li	a4,16
    800031d0:	86a6                	mv	a3,s1
    800031d2:	fc040613          	addi	a2,s0,-64
    800031d6:	4581                	li	a1,0
    800031d8:	854a                	mv	a0,s2
    800031da:	00000097          	auipc	ra,0x0
    800031de:	d70080e7          	jalr	-656(ra) # 80002f4a <readi>
    800031e2:	47c1                	li	a5,16
    800031e4:	fcf518e3          	bne	a0,a5,800031b4 <dirlookup+0x3a>
    if(de.inum == 0)
    800031e8:	fc045783          	lhu	a5,-64(s0)
    800031ec:	dfe1                	beqz	a5,800031c4 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031ee:	fc240593          	addi	a1,s0,-62
    800031f2:	854e                	mv	a0,s3
    800031f4:	00000097          	auipc	ra,0x0
    800031f8:	f6c080e7          	jalr	-148(ra) # 80003160 <namecmp>
    800031fc:	f561                	bnez	a0,800031c4 <dirlookup+0x4a>
      if(poff)
    800031fe:	000a0463          	beqz	s4,80003206 <dirlookup+0x8c>
        *poff = off;
    80003202:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003206:	fc045583          	lhu	a1,-64(s0)
    8000320a:	00092503          	lw	a0,0(s2)
    8000320e:	fffff097          	auipc	ra,0xfffff
    80003212:	754080e7          	jalr	1876(ra) # 80002962 <iget>
    80003216:	a011                	j	8000321a <dirlookup+0xa0>
  return 0;
    80003218:	4501                	li	a0,0
}
    8000321a:	70e2                	ld	ra,56(sp)
    8000321c:	7442                	ld	s0,48(sp)
    8000321e:	74a2                	ld	s1,40(sp)
    80003220:	7902                	ld	s2,32(sp)
    80003222:	69e2                	ld	s3,24(sp)
    80003224:	6a42                	ld	s4,16(sp)
    80003226:	6121                	addi	sp,sp,64
    80003228:	8082                	ret

000000008000322a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000322a:	711d                	addi	sp,sp,-96
    8000322c:	ec86                	sd	ra,88(sp)
    8000322e:	e8a2                	sd	s0,80(sp)
    80003230:	e4a6                	sd	s1,72(sp)
    80003232:	e0ca                	sd	s2,64(sp)
    80003234:	fc4e                	sd	s3,56(sp)
    80003236:	f852                	sd	s4,48(sp)
    80003238:	f456                	sd	s5,40(sp)
    8000323a:	f05a                	sd	s6,32(sp)
    8000323c:	ec5e                	sd	s7,24(sp)
    8000323e:	e862                	sd	s8,16(sp)
    80003240:	e466                	sd	s9,8(sp)
    80003242:	1080                	addi	s0,sp,96
    80003244:	84aa                	mv	s1,a0
    80003246:	8b2e                	mv	s6,a1
    80003248:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000324a:	00054703          	lbu	a4,0(a0)
    8000324e:	02f00793          	li	a5,47
    80003252:	02f70363          	beq	a4,a5,80003278 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003256:	ffffe097          	auipc	ra,0xffffe
    8000325a:	d4e080e7          	jalr	-690(ra) # 80000fa4 <myproc>
    8000325e:	15053503          	ld	a0,336(a0)
    80003262:	00000097          	auipc	ra,0x0
    80003266:	9f6080e7          	jalr	-1546(ra) # 80002c58 <idup>
    8000326a:	89aa                	mv	s3,a0
  while(*path == '/')
    8000326c:	02f00913          	li	s2,47
  len = path - s;
    80003270:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003272:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003274:	4c05                	li	s8,1
    80003276:	a865                	j	8000332e <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003278:	4585                	li	a1,1
    8000327a:	4505                	li	a0,1
    8000327c:	fffff097          	auipc	ra,0xfffff
    80003280:	6e6080e7          	jalr	1766(ra) # 80002962 <iget>
    80003284:	89aa                	mv	s3,a0
    80003286:	b7dd                	j	8000326c <namex+0x42>
      iunlockput(ip);
    80003288:	854e                	mv	a0,s3
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	c6e080e7          	jalr	-914(ra) # 80002ef8 <iunlockput>
      return 0;
    80003292:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003294:	854e                	mv	a0,s3
    80003296:	60e6                	ld	ra,88(sp)
    80003298:	6446                	ld	s0,80(sp)
    8000329a:	64a6                	ld	s1,72(sp)
    8000329c:	6906                	ld	s2,64(sp)
    8000329e:	79e2                	ld	s3,56(sp)
    800032a0:	7a42                	ld	s4,48(sp)
    800032a2:	7aa2                	ld	s5,40(sp)
    800032a4:	7b02                	ld	s6,32(sp)
    800032a6:	6be2                	ld	s7,24(sp)
    800032a8:	6c42                	ld	s8,16(sp)
    800032aa:	6ca2                	ld	s9,8(sp)
    800032ac:	6125                	addi	sp,sp,96
    800032ae:	8082                	ret
      iunlock(ip);
    800032b0:	854e                	mv	a0,s3
    800032b2:	00000097          	auipc	ra,0x0
    800032b6:	aa6080e7          	jalr	-1370(ra) # 80002d58 <iunlock>
      return ip;
    800032ba:	bfe9                	j	80003294 <namex+0x6a>
      iunlockput(ip);
    800032bc:	854e                	mv	a0,s3
    800032be:	00000097          	auipc	ra,0x0
    800032c2:	c3a080e7          	jalr	-966(ra) # 80002ef8 <iunlockput>
      return 0;
    800032c6:	89d2                	mv	s3,s4
    800032c8:	b7f1                	j	80003294 <namex+0x6a>
  len = path - s;
    800032ca:	40b48633          	sub	a2,s1,a1
    800032ce:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800032d2:	094cd463          	bge	s9,s4,8000335a <namex+0x130>
    memmove(name, s, DIRSIZ);
    800032d6:	4639                	li	a2,14
    800032d8:	8556                	mv	a0,s5
    800032da:	ffffd097          	auipc	ra,0xffffd
    800032de:	fd0080e7          	jalr	-48(ra) # 800002aa <memmove>
  while(*path == '/')
    800032e2:	0004c783          	lbu	a5,0(s1)
    800032e6:	01279763          	bne	a5,s2,800032f4 <namex+0xca>
    path++;
    800032ea:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032ec:	0004c783          	lbu	a5,0(s1)
    800032f0:	ff278de3          	beq	a5,s2,800032ea <namex+0xc0>
    ilock(ip);
    800032f4:	854e                	mv	a0,s3
    800032f6:	00000097          	auipc	ra,0x0
    800032fa:	9a0080e7          	jalr	-1632(ra) # 80002c96 <ilock>
    if(ip->type != T_DIR){
    800032fe:	04499783          	lh	a5,68(s3)
    80003302:	f98793e3          	bne	a5,s8,80003288 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003306:	000b0563          	beqz	s6,80003310 <namex+0xe6>
    8000330a:	0004c783          	lbu	a5,0(s1)
    8000330e:	d3cd                	beqz	a5,800032b0 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003310:	865e                	mv	a2,s7
    80003312:	85d6                	mv	a1,s5
    80003314:	854e                	mv	a0,s3
    80003316:	00000097          	auipc	ra,0x0
    8000331a:	e64080e7          	jalr	-412(ra) # 8000317a <dirlookup>
    8000331e:	8a2a                	mv	s4,a0
    80003320:	dd51                	beqz	a0,800032bc <namex+0x92>
    iunlockput(ip);
    80003322:	854e                	mv	a0,s3
    80003324:	00000097          	auipc	ra,0x0
    80003328:	bd4080e7          	jalr	-1068(ra) # 80002ef8 <iunlockput>
    ip = next;
    8000332c:	89d2                	mv	s3,s4
  while(*path == '/')
    8000332e:	0004c783          	lbu	a5,0(s1)
    80003332:	05279763          	bne	a5,s2,80003380 <namex+0x156>
    path++;
    80003336:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003338:	0004c783          	lbu	a5,0(s1)
    8000333c:	ff278de3          	beq	a5,s2,80003336 <namex+0x10c>
  if(*path == 0)
    80003340:	c79d                	beqz	a5,8000336e <namex+0x144>
    path++;
    80003342:	85a6                	mv	a1,s1
  len = path - s;
    80003344:	8a5e                	mv	s4,s7
    80003346:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003348:	01278963          	beq	a5,s2,8000335a <namex+0x130>
    8000334c:	dfbd                	beqz	a5,800032ca <namex+0xa0>
    path++;
    8000334e:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003350:	0004c783          	lbu	a5,0(s1)
    80003354:	ff279ce3          	bne	a5,s2,8000334c <namex+0x122>
    80003358:	bf8d                	j	800032ca <namex+0xa0>
    memmove(name, s, len);
    8000335a:	2601                	sext.w	a2,a2
    8000335c:	8556                	mv	a0,s5
    8000335e:	ffffd097          	auipc	ra,0xffffd
    80003362:	f4c080e7          	jalr	-180(ra) # 800002aa <memmove>
    name[len] = 0;
    80003366:	9a56                	add	s4,s4,s5
    80003368:	000a0023          	sb	zero,0(s4)
    8000336c:	bf9d                	j	800032e2 <namex+0xb8>
  if(nameiparent){
    8000336e:	f20b03e3          	beqz	s6,80003294 <namex+0x6a>
    iput(ip);
    80003372:	854e                	mv	a0,s3
    80003374:	00000097          	auipc	ra,0x0
    80003378:	adc080e7          	jalr	-1316(ra) # 80002e50 <iput>
    return 0;
    8000337c:	4981                	li	s3,0
    8000337e:	bf19                	j	80003294 <namex+0x6a>
  if(*path == 0)
    80003380:	d7fd                	beqz	a5,8000336e <namex+0x144>
  while(*path != '/' && *path != 0)
    80003382:	0004c783          	lbu	a5,0(s1)
    80003386:	85a6                	mv	a1,s1
    80003388:	b7d1                	j	8000334c <namex+0x122>

000000008000338a <dirlink>:
{
    8000338a:	7139                	addi	sp,sp,-64
    8000338c:	fc06                	sd	ra,56(sp)
    8000338e:	f822                	sd	s0,48(sp)
    80003390:	f426                	sd	s1,40(sp)
    80003392:	f04a                	sd	s2,32(sp)
    80003394:	ec4e                	sd	s3,24(sp)
    80003396:	e852                	sd	s4,16(sp)
    80003398:	0080                	addi	s0,sp,64
    8000339a:	892a                	mv	s2,a0
    8000339c:	8a2e                	mv	s4,a1
    8000339e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033a0:	4601                	li	a2,0
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	dd8080e7          	jalr	-552(ra) # 8000317a <dirlookup>
    800033aa:	e93d                	bnez	a0,80003420 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033ac:	04c92483          	lw	s1,76(s2)
    800033b0:	c49d                	beqz	s1,800033de <dirlink+0x54>
    800033b2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033b4:	4741                	li	a4,16
    800033b6:	86a6                	mv	a3,s1
    800033b8:	fc040613          	addi	a2,s0,-64
    800033bc:	4581                	li	a1,0
    800033be:	854a                	mv	a0,s2
    800033c0:	00000097          	auipc	ra,0x0
    800033c4:	b8a080e7          	jalr	-1142(ra) # 80002f4a <readi>
    800033c8:	47c1                	li	a5,16
    800033ca:	06f51163          	bne	a0,a5,8000342c <dirlink+0xa2>
    if(de.inum == 0)
    800033ce:	fc045783          	lhu	a5,-64(s0)
    800033d2:	c791                	beqz	a5,800033de <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033d4:	24c1                	addiw	s1,s1,16
    800033d6:	04c92783          	lw	a5,76(s2)
    800033da:	fcf4ede3          	bltu	s1,a5,800033b4 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033de:	4639                	li	a2,14
    800033e0:	85d2                	mv	a1,s4
    800033e2:	fc240513          	addi	a0,s0,-62
    800033e6:	ffffd097          	auipc	ra,0xffffd
    800033ea:	f78080e7          	jalr	-136(ra) # 8000035e <strncpy>
  de.inum = inum;
    800033ee:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033f2:	4741                	li	a4,16
    800033f4:	86a6                	mv	a3,s1
    800033f6:	fc040613          	addi	a2,s0,-64
    800033fa:	4581                	li	a1,0
    800033fc:	854a                	mv	a0,s2
    800033fe:	00000097          	auipc	ra,0x0
    80003402:	c44080e7          	jalr	-956(ra) # 80003042 <writei>
    80003406:	872a                	mv	a4,a0
    80003408:	47c1                	li	a5,16
  return 0;
    8000340a:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000340c:	02f71863          	bne	a4,a5,8000343c <dirlink+0xb2>
}
    80003410:	70e2                	ld	ra,56(sp)
    80003412:	7442                	ld	s0,48(sp)
    80003414:	74a2                	ld	s1,40(sp)
    80003416:	7902                	ld	s2,32(sp)
    80003418:	69e2                	ld	s3,24(sp)
    8000341a:	6a42                	ld	s4,16(sp)
    8000341c:	6121                	addi	sp,sp,64
    8000341e:	8082                	ret
    iput(ip);
    80003420:	00000097          	auipc	ra,0x0
    80003424:	a30080e7          	jalr	-1488(ra) # 80002e50 <iput>
    return -1;
    80003428:	557d                	li	a0,-1
    8000342a:	b7dd                	j	80003410 <dirlink+0x86>
      panic("dirlink read");
    8000342c:	00005517          	auipc	a0,0x5
    80003430:	19c50513          	addi	a0,a0,412 # 800085c8 <syscalls+0x1c8>
    80003434:	00003097          	auipc	ra,0x3
    80003438:	914080e7          	jalr	-1772(ra) # 80005d48 <panic>
    panic("dirlink");
    8000343c:	00005517          	auipc	a0,0x5
    80003440:	29c50513          	addi	a0,a0,668 # 800086d8 <syscalls+0x2d8>
    80003444:	00003097          	auipc	ra,0x3
    80003448:	904080e7          	jalr	-1788(ra) # 80005d48 <panic>

000000008000344c <namei>:

struct inode*
namei(char *path)
{
    8000344c:	1101                	addi	sp,sp,-32
    8000344e:	ec06                	sd	ra,24(sp)
    80003450:	e822                	sd	s0,16(sp)
    80003452:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003454:	fe040613          	addi	a2,s0,-32
    80003458:	4581                	li	a1,0
    8000345a:	00000097          	auipc	ra,0x0
    8000345e:	dd0080e7          	jalr	-560(ra) # 8000322a <namex>
}
    80003462:	60e2                	ld	ra,24(sp)
    80003464:	6442                	ld	s0,16(sp)
    80003466:	6105                	addi	sp,sp,32
    80003468:	8082                	ret

000000008000346a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000346a:	1141                	addi	sp,sp,-16
    8000346c:	e406                	sd	ra,8(sp)
    8000346e:	e022                	sd	s0,0(sp)
    80003470:	0800                	addi	s0,sp,16
    80003472:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003474:	4585                	li	a1,1
    80003476:	00000097          	auipc	ra,0x0
    8000347a:	db4080e7          	jalr	-588(ra) # 8000322a <namex>
}
    8000347e:	60a2                	ld	ra,8(sp)
    80003480:	6402                	ld	s0,0(sp)
    80003482:	0141                	addi	sp,sp,16
    80003484:	8082                	ret

0000000080003486 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003486:	1101                	addi	sp,sp,-32
    80003488:	ec06                	sd	ra,24(sp)
    8000348a:	e822                	sd	s0,16(sp)
    8000348c:	e426                	sd	s1,8(sp)
    8000348e:	e04a                	sd	s2,0(sp)
    80003490:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003492:	00036917          	auipc	s2,0x36
    80003496:	b8e90913          	addi	s2,s2,-1138 # 80039020 <log>
    8000349a:	01892583          	lw	a1,24(s2)
    8000349e:	02892503          	lw	a0,40(s2)
    800034a2:	fffff097          	auipc	ra,0xfffff
    800034a6:	ff2080e7          	jalr	-14(ra) # 80002494 <bread>
    800034aa:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034ac:	02c92683          	lw	a3,44(s2)
    800034b0:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034b2:	02d05763          	blez	a3,800034e0 <write_head+0x5a>
    800034b6:	00036797          	auipc	a5,0x36
    800034ba:	b9a78793          	addi	a5,a5,-1126 # 80039050 <log+0x30>
    800034be:	05c50713          	addi	a4,a0,92
    800034c2:	36fd                	addiw	a3,a3,-1
    800034c4:	1682                	slli	a3,a3,0x20
    800034c6:	9281                	srli	a3,a3,0x20
    800034c8:	068a                	slli	a3,a3,0x2
    800034ca:	00036617          	auipc	a2,0x36
    800034ce:	b8a60613          	addi	a2,a2,-1142 # 80039054 <log+0x34>
    800034d2:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034d4:	4390                	lw	a2,0(a5)
    800034d6:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034d8:	0791                	addi	a5,a5,4
    800034da:	0711                	addi	a4,a4,4
    800034dc:	fed79ce3          	bne	a5,a3,800034d4 <write_head+0x4e>
  }
  bwrite(buf);
    800034e0:	8526                	mv	a0,s1
    800034e2:	fffff097          	auipc	ra,0xfffff
    800034e6:	0a4080e7          	jalr	164(ra) # 80002586 <bwrite>
  brelse(buf);
    800034ea:	8526                	mv	a0,s1
    800034ec:	fffff097          	auipc	ra,0xfffff
    800034f0:	0d8080e7          	jalr	216(ra) # 800025c4 <brelse>
}
    800034f4:	60e2                	ld	ra,24(sp)
    800034f6:	6442                	ld	s0,16(sp)
    800034f8:	64a2                	ld	s1,8(sp)
    800034fa:	6902                	ld	s2,0(sp)
    800034fc:	6105                	addi	sp,sp,32
    800034fe:	8082                	ret

0000000080003500 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003500:	00036797          	auipc	a5,0x36
    80003504:	b4c7a783          	lw	a5,-1204(a5) # 8003904c <log+0x2c>
    80003508:	0af05d63          	blez	a5,800035c2 <install_trans+0xc2>
{
    8000350c:	7139                	addi	sp,sp,-64
    8000350e:	fc06                	sd	ra,56(sp)
    80003510:	f822                	sd	s0,48(sp)
    80003512:	f426                	sd	s1,40(sp)
    80003514:	f04a                	sd	s2,32(sp)
    80003516:	ec4e                	sd	s3,24(sp)
    80003518:	e852                	sd	s4,16(sp)
    8000351a:	e456                	sd	s5,8(sp)
    8000351c:	e05a                	sd	s6,0(sp)
    8000351e:	0080                	addi	s0,sp,64
    80003520:	8b2a                	mv	s6,a0
    80003522:	00036a97          	auipc	s5,0x36
    80003526:	b2ea8a93          	addi	s5,s5,-1234 # 80039050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000352a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000352c:	00036997          	auipc	s3,0x36
    80003530:	af498993          	addi	s3,s3,-1292 # 80039020 <log>
    80003534:	a035                	j	80003560 <install_trans+0x60>
      bunpin(dbuf);
    80003536:	8526                	mv	a0,s1
    80003538:	fffff097          	auipc	ra,0xfffff
    8000353c:	166080e7          	jalr	358(ra) # 8000269e <bunpin>
    brelse(lbuf);
    80003540:	854a                	mv	a0,s2
    80003542:	fffff097          	auipc	ra,0xfffff
    80003546:	082080e7          	jalr	130(ra) # 800025c4 <brelse>
    brelse(dbuf);
    8000354a:	8526                	mv	a0,s1
    8000354c:	fffff097          	auipc	ra,0xfffff
    80003550:	078080e7          	jalr	120(ra) # 800025c4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003554:	2a05                	addiw	s4,s4,1
    80003556:	0a91                	addi	s5,s5,4
    80003558:	02c9a783          	lw	a5,44(s3)
    8000355c:	04fa5963          	bge	s4,a5,800035ae <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003560:	0189a583          	lw	a1,24(s3)
    80003564:	014585bb          	addw	a1,a1,s4
    80003568:	2585                	addiw	a1,a1,1
    8000356a:	0289a503          	lw	a0,40(s3)
    8000356e:	fffff097          	auipc	ra,0xfffff
    80003572:	f26080e7          	jalr	-218(ra) # 80002494 <bread>
    80003576:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003578:	000aa583          	lw	a1,0(s5)
    8000357c:	0289a503          	lw	a0,40(s3)
    80003580:	fffff097          	auipc	ra,0xfffff
    80003584:	f14080e7          	jalr	-236(ra) # 80002494 <bread>
    80003588:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000358a:	40000613          	li	a2,1024
    8000358e:	05890593          	addi	a1,s2,88
    80003592:	05850513          	addi	a0,a0,88
    80003596:	ffffd097          	auipc	ra,0xffffd
    8000359a:	d14080e7          	jalr	-748(ra) # 800002aa <memmove>
    bwrite(dbuf);  // write dst to disk
    8000359e:	8526                	mv	a0,s1
    800035a0:	fffff097          	auipc	ra,0xfffff
    800035a4:	fe6080e7          	jalr	-26(ra) # 80002586 <bwrite>
    if(recovering == 0)
    800035a8:	f80b1ce3          	bnez	s6,80003540 <install_trans+0x40>
    800035ac:	b769                	j	80003536 <install_trans+0x36>
}
    800035ae:	70e2                	ld	ra,56(sp)
    800035b0:	7442                	ld	s0,48(sp)
    800035b2:	74a2                	ld	s1,40(sp)
    800035b4:	7902                	ld	s2,32(sp)
    800035b6:	69e2                	ld	s3,24(sp)
    800035b8:	6a42                	ld	s4,16(sp)
    800035ba:	6aa2                	ld	s5,8(sp)
    800035bc:	6b02                	ld	s6,0(sp)
    800035be:	6121                	addi	sp,sp,64
    800035c0:	8082                	ret
    800035c2:	8082                	ret

00000000800035c4 <initlog>:
{
    800035c4:	7179                	addi	sp,sp,-48
    800035c6:	f406                	sd	ra,40(sp)
    800035c8:	f022                	sd	s0,32(sp)
    800035ca:	ec26                	sd	s1,24(sp)
    800035cc:	e84a                	sd	s2,16(sp)
    800035ce:	e44e                	sd	s3,8(sp)
    800035d0:	1800                	addi	s0,sp,48
    800035d2:	892a                	mv	s2,a0
    800035d4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035d6:	00036497          	auipc	s1,0x36
    800035da:	a4a48493          	addi	s1,s1,-1462 # 80039020 <log>
    800035de:	00005597          	auipc	a1,0x5
    800035e2:	ffa58593          	addi	a1,a1,-6 # 800085d8 <syscalls+0x1d8>
    800035e6:	8526                	mv	a0,s1
    800035e8:	00003097          	auipc	ra,0x3
    800035ec:	c1a080e7          	jalr	-998(ra) # 80006202 <initlock>
  log.start = sb->logstart;
    800035f0:	0149a583          	lw	a1,20(s3)
    800035f4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035f6:	0109a783          	lw	a5,16(s3)
    800035fa:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035fc:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003600:	854a                	mv	a0,s2
    80003602:	fffff097          	auipc	ra,0xfffff
    80003606:	e92080e7          	jalr	-366(ra) # 80002494 <bread>
  log.lh.n = lh->n;
    8000360a:	4d3c                	lw	a5,88(a0)
    8000360c:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000360e:	02f05563          	blez	a5,80003638 <initlog+0x74>
    80003612:	05c50713          	addi	a4,a0,92
    80003616:	00036697          	auipc	a3,0x36
    8000361a:	a3a68693          	addi	a3,a3,-1478 # 80039050 <log+0x30>
    8000361e:	37fd                	addiw	a5,a5,-1
    80003620:	1782                	slli	a5,a5,0x20
    80003622:	9381                	srli	a5,a5,0x20
    80003624:	078a                	slli	a5,a5,0x2
    80003626:	06050613          	addi	a2,a0,96
    8000362a:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000362c:	4310                	lw	a2,0(a4)
    8000362e:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003630:	0711                	addi	a4,a4,4
    80003632:	0691                	addi	a3,a3,4
    80003634:	fef71ce3          	bne	a4,a5,8000362c <initlog+0x68>
  brelse(buf);
    80003638:	fffff097          	auipc	ra,0xfffff
    8000363c:	f8c080e7          	jalr	-116(ra) # 800025c4 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003640:	4505                	li	a0,1
    80003642:	00000097          	auipc	ra,0x0
    80003646:	ebe080e7          	jalr	-322(ra) # 80003500 <install_trans>
  log.lh.n = 0;
    8000364a:	00036797          	auipc	a5,0x36
    8000364e:	a007a123          	sw	zero,-1534(a5) # 8003904c <log+0x2c>
  write_head(); // clear the log
    80003652:	00000097          	auipc	ra,0x0
    80003656:	e34080e7          	jalr	-460(ra) # 80003486 <write_head>
}
    8000365a:	70a2                	ld	ra,40(sp)
    8000365c:	7402                	ld	s0,32(sp)
    8000365e:	64e2                	ld	s1,24(sp)
    80003660:	6942                	ld	s2,16(sp)
    80003662:	69a2                	ld	s3,8(sp)
    80003664:	6145                	addi	sp,sp,48
    80003666:	8082                	ret

0000000080003668 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003668:	1101                	addi	sp,sp,-32
    8000366a:	ec06                	sd	ra,24(sp)
    8000366c:	e822                	sd	s0,16(sp)
    8000366e:	e426                	sd	s1,8(sp)
    80003670:	e04a                	sd	s2,0(sp)
    80003672:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003674:	00036517          	auipc	a0,0x36
    80003678:	9ac50513          	addi	a0,a0,-1620 # 80039020 <log>
    8000367c:	00003097          	auipc	ra,0x3
    80003680:	c16080e7          	jalr	-1002(ra) # 80006292 <acquire>
  while(1){
    if(log.committing){
    80003684:	00036497          	auipc	s1,0x36
    80003688:	99c48493          	addi	s1,s1,-1636 # 80039020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000368c:	4979                	li	s2,30
    8000368e:	a039                	j	8000369c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003690:	85a6                	mv	a1,s1
    80003692:	8526                	mv	a0,s1
    80003694:	ffffe097          	auipc	ra,0xffffe
    80003698:	fcc080e7          	jalr	-52(ra) # 80001660 <sleep>
    if(log.committing){
    8000369c:	50dc                	lw	a5,36(s1)
    8000369e:	fbed                	bnez	a5,80003690 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036a0:	509c                	lw	a5,32(s1)
    800036a2:	0017871b          	addiw	a4,a5,1
    800036a6:	0007069b          	sext.w	a3,a4
    800036aa:	0027179b          	slliw	a5,a4,0x2
    800036ae:	9fb9                	addw	a5,a5,a4
    800036b0:	0017979b          	slliw	a5,a5,0x1
    800036b4:	54d8                	lw	a4,44(s1)
    800036b6:	9fb9                	addw	a5,a5,a4
    800036b8:	00f95963          	bge	s2,a5,800036ca <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036bc:	85a6                	mv	a1,s1
    800036be:	8526                	mv	a0,s1
    800036c0:	ffffe097          	auipc	ra,0xffffe
    800036c4:	fa0080e7          	jalr	-96(ra) # 80001660 <sleep>
    800036c8:	bfd1                	j	8000369c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036ca:	00036517          	auipc	a0,0x36
    800036ce:	95650513          	addi	a0,a0,-1706 # 80039020 <log>
    800036d2:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036d4:	00003097          	auipc	ra,0x3
    800036d8:	c72080e7          	jalr	-910(ra) # 80006346 <release>
      break;
    }
  }
}
    800036dc:	60e2                	ld	ra,24(sp)
    800036de:	6442                	ld	s0,16(sp)
    800036e0:	64a2                	ld	s1,8(sp)
    800036e2:	6902                	ld	s2,0(sp)
    800036e4:	6105                	addi	sp,sp,32
    800036e6:	8082                	ret

00000000800036e8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036e8:	7139                	addi	sp,sp,-64
    800036ea:	fc06                	sd	ra,56(sp)
    800036ec:	f822                	sd	s0,48(sp)
    800036ee:	f426                	sd	s1,40(sp)
    800036f0:	f04a                	sd	s2,32(sp)
    800036f2:	ec4e                	sd	s3,24(sp)
    800036f4:	e852                	sd	s4,16(sp)
    800036f6:	e456                	sd	s5,8(sp)
    800036f8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036fa:	00036497          	auipc	s1,0x36
    800036fe:	92648493          	addi	s1,s1,-1754 # 80039020 <log>
    80003702:	8526                	mv	a0,s1
    80003704:	00003097          	auipc	ra,0x3
    80003708:	b8e080e7          	jalr	-1138(ra) # 80006292 <acquire>
  log.outstanding -= 1;
    8000370c:	509c                	lw	a5,32(s1)
    8000370e:	37fd                	addiw	a5,a5,-1
    80003710:	0007891b          	sext.w	s2,a5
    80003714:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003716:	50dc                	lw	a5,36(s1)
    80003718:	efb9                	bnez	a5,80003776 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000371a:	06091663          	bnez	s2,80003786 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000371e:	00036497          	auipc	s1,0x36
    80003722:	90248493          	addi	s1,s1,-1790 # 80039020 <log>
    80003726:	4785                	li	a5,1
    80003728:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000372a:	8526                	mv	a0,s1
    8000372c:	00003097          	auipc	ra,0x3
    80003730:	c1a080e7          	jalr	-998(ra) # 80006346 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003734:	54dc                	lw	a5,44(s1)
    80003736:	06f04763          	bgtz	a5,800037a4 <end_op+0xbc>
    acquire(&log.lock);
    8000373a:	00036497          	auipc	s1,0x36
    8000373e:	8e648493          	addi	s1,s1,-1818 # 80039020 <log>
    80003742:	8526                	mv	a0,s1
    80003744:	00003097          	auipc	ra,0x3
    80003748:	b4e080e7          	jalr	-1202(ra) # 80006292 <acquire>
    log.committing = 0;
    8000374c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003750:	8526                	mv	a0,s1
    80003752:	ffffe097          	auipc	ra,0xffffe
    80003756:	09a080e7          	jalr	154(ra) # 800017ec <wakeup>
    release(&log.lock);
    8000375a:	8526                	mv	a0,s1
    8000375c:	00003097          	auipc	ra,0x3
    80003760:	bea080e7          	jalr	-1046(ra) # 80006346 <release>
}
    80003764:	70e2                	ld	ra,56(sp)
    80003766:	7442                	ld	s0,48(sp)
    80003768:	74a2                	ld	s1,40(sp)
    8000376a:	7902                	ld	s2,32(sp)
    8000376c:	69e2                	ld	s3,24(sp)
    8000376e:	6a42                	ld	s4,16(sp)
    80003770:	6aa2                	ld	s5,8(sp)
    80003772:	6121                	addi	sp,sp,64
    80003774:	8082                	ret
    panic("log.committing");
    80003776:	00005517          	auipc	a0,0x5
    8000377a:	e6a50513          	addi	a0,a0,-406 # 800085e0 <syscalls+0x1e0>
    8000377e:	00002097          	auipc	ra,0x2
    80003782:	5ca080e7          	jalr	1482(ra) # 80005d48 <panic>
    wakeup(&log);
    80003786:	00036497          	auipc	s1,0x36
    8000378a:	89a48493          	addi	s1,s1,-1894 # 80039020 <log>
    8000378e:	8526                	mv	a0,s1
    80003790:	ffffe097          	auipc	ra,0xffffe
    80003794:	05c080e7          	jalr	92(ra) # 800017ec <wakeup>
  release(&log.lock);
    80003798:	8526                	mv	a0,s1
    8000379a:	00003097          	auipc	ra,0x3
    8000379e:	bac080e7          	jalr	-1108(ra) # 80006346 <release>
  if(do_commit){
    800037a2:	b7c9                	j	80003764 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037a4:	00036a97          	auipc	s5,0x36
    800037a8:	8aca8a93          	addi	s5,s5,-1876 # 80039050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037ac:	00036a17          	auipc	s4,0x36
    800037b0:	874a0a13          	addi	s4,s4,-1932 # 80039020 <log>
    800037b4:	018a2583          	lw	a1,24(s4)
    800037b8:	012585bb          	addw	a1,a1,s2
    800037bc:	2585                	addiw	a1,a1,1
    800037be:	028a2503          	lw	a0,40(s4)
    800037c2:	fffff097          	auipc	ra,0xfffff
    800037c6:	cd2080e7          	jalr	-814(ra) # 80002494 <bread>
    800037ca:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037cc:	000aa583          	lw	a1,0(s5)
    800037d0:	028a2503          	lw	a0,40(s4)
    800037d4:	fffff097          	auipc	ra,0xfffff
    800037d8:	cc0080e7          	jalr	-832(ra) # 80002494 <bread>
    800037dc:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037de:	40000613          	li	a2,1024
    800037e2:	05850593          	addi	a1,a0,88
    800037e6:	05848513          	addi	a0,s1,88
    800037ea:	ffffd097          	auipc	ra,0xffffd
    800037ee:	ac0080e7          	jalr	-1344(ra) # 800002aa <memmove>
    bwrite(to);  // write the log
    800037f2:	8526                	mv	a0,s1
    800037f4:	fffff097          	auipc	ra,0xfffff
    800037f8:	d92080e7          	jalr	-622(ra) # 80002586 <bwrite>
    brelse(from);
    800037fc:	854e                	mv	a0,s3
    800037fe:	fffff097          	auipc	ra,0xfffff
    80003802:	dc6080e7          	jalr	-570(ra) # 800025c4 <brelse>
    brelse(to);
    80003806:	8526                	mv	a0,s1
    80003808:	fffff097          	auipc	ra,0xfffff
    8000380c:	dbc080e7          	jalr	-580(ra) # 800025c4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003810:	2905                	addiw	s2,s2,1
    80003812:	0a91                	addi	s5,s5,4
    80003814:	02ca2783          	lw	a5,44(s4)
    80003818:	f8f94ee3          	blt	s2,a5,800037b4 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000381c:	00000097          	auipc	ra,0x0
    80003820:	c6a080e7          	jalr	-918(ra) # 80003486 <write_head>
    install_trans(0); // Now install writes to home locations
    80003824:	4501                	li	a0,0
    80003826:	00000097          	auipc	ra,0x0
    8000382a:	cda080e7          	jalr	-806(ra) # 80003500 <install_trans>
    log.lh.n = 0;
    8000382e:	00036797          	auipc	a5,0x36
    80003832:	8007af23          	sw	zero,-2018(a5) # 8003904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003836:	00000097          	auipc	ra,0x0
    8000383a:	c50080e7          	jalr	-944(ra) # 80003486 <write_head>
    8000383e:	bdf5                	j	8000373a <end_op+0x52>

0000000080003840 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003840:	1101                	addi	sp,sp,-32
    80003842:	ec06                	sd	ra,24(sp)
    80003844:	e822                	sd	s0,16(sp)
    80003846:	e426                	sd	s1,8(sp)
    80003848:	e04a                	sd	s2,0(sp)
    8000384a:	1000                	addi	s0,sp,32
    8000384c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000384e:	00035917          	auipc	s2,0x35
    80003852:	7d290913          	addi	s2,s2,2002 # 80039020 <log>
    80003856:	854a                	mv	a0,s2
    80003858:	00003097          	auipc	ra,0x3
    8000385c:	a3a080e7          	jalr	-1478(ra) # 80006292 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003860:	02c92603          	lw	a2,44(s2)
    80003864:	47f5                	li	a5,29
    80003866:	06c7c563          	blt	a5,a2,800038d0 <log_write+0x90>
    8000386a:	00035797          	auipc	a5,0x35
    8000386e:	7d27a783          	lw	a5,2002(a5) # 8003903c <log+0x1c>
    80003872:	37fd                	addiw	a5,a5,-1
    80003874:	04f65e63          	bge	a2,a5,800038d0 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003878:	00035797          	auipc	a5,0x35
    8000387c:	7c87a783          	lw	a5,1992(a5) # 80039040 <log+0x20>
    80003880:	06f05063          	blez	a5,800038e0 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003884:	4781                	li	a5,0
    80003886:	06c05563          	blez	a2,800038f0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000388a:	44cc                	lw	a1,12(s1)
    8000388c:	00035717          	auipc	a4,0x35
    80003890:	7c470713          	addi	a4,a4,1988 # 80039050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003894:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003896:	4314                	lw	a3,0(a4)
    80003898:	04b68c63          	beq	a3,a1,800038f0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000389c:	2785                	addiw	a5,a5,1
    8000389e:	0711                	addi	a4,a4,4
    800038a0:	fef61be3          	bne	a2,a5,80003896 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038a4:	0621                	addi	a2,a2,8
    800038a6:	060a                	slli	a2,a2,0x2
    800038a8:	00035797          	auipc	a5,0x35
    800038ac:	77878793          	addi	a5,a5,1912 # 80039020 <log>
    800038b0:	963e                	add	a2,a2,a5
    800038b2:	44dc                	lw	a5,12(s1)
    800038b4:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038b6:	8526                	mv	a0,s1
    800038b8:	fffff097          	auipc	ra,0xfffff
    800038bc:	daa080e7          	jalr	-598(ra) # 80002662 <bpin>
    log.lh.n++;
    800038c0:	00035717          	auipc	a4,0x35
    800038c4:	76070713          	addi	a4,a4,1888 # 80039020 <log>
    800038c8:	575c                	lw	a5,44(a4)
    800038ca:	2785                	addiw	a5,a5,1
    800038cc:	d75c                	sw	a5,44(a4)
    800038ce:	a835                	j	8000390a <log_write+0xca>
    panic("too big a transaction");
    800038d0:	00005517          	auipc	a0,0x5
    800038d4:	d2050513          	addi	a0,a0,-736 # 800085f0 <syscalls+0x1f0>
    800038d8:	00002097          	auipc	ra,0x2
    800038dc:	470080e7          	jalr	1136(ra) # 80005d48 <panic>
    panic("log_write outside of trans");
    800038e0:	00005517          	auipc	a0,0x5
    800038e4:	d2850513          	addi	a0,a0,-728 # 80008608 <syscalls+0x208>
    800038e8:	00002097          	auipc	ra,0x2
    800038ec:	460080e7          	jalr	1120(ra) # 80005d48 <panic>
  log.lh.block[i] = b->blockno;
    800038f0:	00878713          	addi	a4,a5,8
    800038f4:	00271693          	slli	a3,a4,0x2
    800038f8:	00035717          	auipc	a4,0x35
    800038fc:	72870713          	addi	a4,a4,1832 # 80039020 <log>
    80003900:	9736                	add	a4,a4,a3
    80003902:	44d4                	lw	a3,12(s1)
    80003904:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003906:	faf608e3          	beq	a2,a5,800038b6 <log_write+0x76>
  }
  release(&log.lock);
    8000390a:	00035517          	auipc	a0,0x35
    8000390e:	71650513          	addi	a0,a0,1814 # 80039020 <log>
    80003912:	00003097          	auipc	ra,0x3
    80003916:	a34080e7          	jalr	-1484(ra) # 80006346 <release>
}
    8000391a:	60e2                	ld	ra,24(sp)
    8000391c:	6442                	ld	s0,16(sp)
    8000391e:	64a2                	ld	s1,8(sp)
    80003920:	6902                	ld	s2,0(sp)
    80003922:	6105                	addi	sp,sp,32
    80003924:	8082                	ret

0000000080003926 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003926:	1101                	addi	sp,sp,-32
    80003928:	ec06                	sd	ra,24(sp)
    8000392a:	e822                	sd	s0,16(sp)
    8000392c:	e426                	sd	s1,8(sp)
    8000392e:	e04a                	sd	s2,0(sp)
    80003930:	1000                	addi	s0,sp,32
    80003932:	84aa                	mv	s1,a0
    80003934:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003936:	00005597          	auipc	a1,0x5
    8000393a:	cf258593          	addi	a1,a1,-782 # 80008628 <syscalls+0x228>
    8000393e:	0521                	addi	a0,a0,8
    80003940:	00003097          	auipc	ra,0x3
    80003944:	8c2080e7          	jalr	-1854(ra) # 80006202 <initlock>
  lk->name = name;
    80003948:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000394c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003950:	0204a423          	sw	zero,40(s1)
}
    80003954:	60e2                	ld	ra,24(sp)
    80003956:	6442                	ld	s0,16(sp)
    80003958:	64a2                	ld	s1,8(sp)
    8000395a:	6902                	ld	s2,0(sp)
    8000395c:	6105                	addi	sp,sp,32
    8000395e:	8082                	ret

0000000080003960 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003960:	1101                	addi	sp,sp,-32
    80003962:	ec06                	sd	ra,24(sp)
    80003964:	e822                	sd	s0,16(sp)
    80003966:	e426                	sd	s1,8(sp)
    80003968:	e04a                	sd	s2,0(sp)
    8000396a:	1000                	addi	s0,sp,32
    8000396c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000396e:	00850913          	addi	s2,a0,8
    80003972:	854a                	mv	a0,s2
    80003974:	00003097          	auipc	ra,0x3
    80003978:	91e080e7          	jalr	-1762(ra) # 80006292 <acquire>
  while (lk->locked) {
    8000397c:	409c                	lw	a5,0(s1)
    8000397e:	cb89                	beqz	a5,80003990 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003980:	85ca                	mv	a1,s2
    80003982:	8526                	mv	a0,s1
    80003984:	ffffe097          	auipc	ra,0xffffe
    80003988:	cdc080e7          	jalr	-804(ra) # 80001660 <sleep>
  while (lk->locked) {
    8000398c:	409c                	lw	a5,0(s1)
    8000398e:	fbed                	bnez	a5,80003980 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003990:	4785                	li	a5,1
    80003992:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003994:	ffffd097          	auipc	ra,0xffffd
    80003998:	610080e7          	jalr	1552(ra) # 80000fa4 <myproc>
    8000399c:	591c                	lw	a5,48(a0)
    8000399e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039a0:	854a                	mv	a0,s2
    800039a2:	00003097          	auipc	ra,0x3
    800039a6:	9a4080e7          	jalr	-1628(ra) # 80006346 <release>
}
    800039aa:	60e2                	ld	ra,24(sp)
    800039ac:	6442                	ld	s0,16(sp)
    800039ae:	64a2                	ld	s1,8(sp)
    800039b0:	6902                	ld	s2,0(sp)
    800039b2:	6105                	addi	sp,sp,32
    800039b4:	8082                	ret

00000000800039b6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039b6:	1101                	addi	sp,sp,-32
    800039b8:	ec06                	sd	ra,24(sp)
    800039ba:	e822                	sd	s0,16(sp)
    800039bc:	e426                	sd	s1,8(sp)
    800039be:	e04a                	sd	s2,0(sp)
    800039c0:	1000                	addi	s0,sp,32
    800039c2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039c4:	00850913          	addi	s2,a0,8
    800039c8:	854a                	mv	a0,s2
    800039ca:	00003097          	auipc	ra,0x3
    800039ce:	8c8080e7          	jalr	-1848(ra) # 80006292 <acquire>
  lk->locked = 0;
    800039d2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039d6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039da:	8526                	mv	a0,s1
    800039dc:	ffffe097          	auipc	ra,0xffffe
    800039e0:	e10080e7          	jalr	-496(ra) # 800017ec <wakeup>
  release(&lk->lk);
    800039e4:	854a                	mv	a0,s2
    800039e6:	00003097          	auipc	ra,0x3
    800039ea:	960080e7          	jalr	-1696(ra) # 80006346 <release>
}
    800039ee:	60e2                	ld	ra,24(sp)
    800039f0:	6442                	ld	s0,16(sp)
    800039f2:	64a2                	ld	s1,8(sp)
    800039f4:	6902                	ld	s2,0(sp)
    800039f6:	6105                	addi	sp,sp,32
    800039f8:	8082                	ret

00000000800039fa <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039fa:	7179                	addi	sp,sp,-48
    800039fc:	f406                	sd	ra,40(sp)
    800039fe:	f022                	sd	s0,32(sp)
    80003a00:	ec26                	sd	s1,24(sp)
    80003a02:	e84a                	sd	s2,16(sp)
    80003a04:	e44e                	sd	s3,8(sp)
    80003a06:	1800                	addi	s0,sp,48
    80003a08:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a0a:	00850913          	addi	s2,a0,8
    80003a0e:	854a                	mv	a0,s2
    80003a10:	00003097          	auipc	ra,0x3
    80003a14:	882080e7          	jalr	-1918(ra) # 80006292 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a18:	409c                	lw	a5,0(s1)
    80003a1a:	ef99                	bnez	a5,80003a38 <holdingsleep+0x3e>
    80003a1c:	4481                	li	s1,0
  release(&lk->lk);
    80003a1e:	854a                	mv	a0,s2
    80003a20:	00003097          	auipc	ra,0x3
    80003a24:	926080e7          	jalr	-1754(ra) # 80006346 <release>
  return r;
}
    80003a28:	8526                	mv	a0,s1
    80003a2a:	70a2                	ld	ra,40(sp)
    80003a2c:	7402                	ld	s0,32(sp)
    80003a2e:	64e2                	ld	s1,24(sp)
    80003a30:	6942                	ld	s2,16(sp)
    80003a32:	69a2                	ld	s3,8(sp)
    80003a34:	6145                	addi	sp,sp,48
    80003a36:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a38:	0284a983          	lw	s3,40(s1)
    80003a3c:	ffffd097          	auipc	ra,0xffffd
    80003a40:	568080e7          	jalr	1384(ra) # 80000fa4 <myproc>
    80003a44:	5904                	lw	s1,48(a0)
    80003a46:	413484b3          	sub	s1,s1,s3
    80003a4a:	0014b493          	seqz	s1,s1
    80003a4e:	bfc1                	j	80003a1e <holdingsleep+0x24>

0000000080003a50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a50:	1141                	addi	sp,sp,-16
    80003a52:	e406                	sd	ra,8(sp)
    80003a54:	e022                	sd	s0,0(sp)
    80003a56:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a58:	00005597          	auipc	a1,0x5
    80003a5c:	be058593          	addi	a1,a1,-1056 # 80008638 <syscalls+0x238>
    80003a60:	00035517          	auipc	a0,0x35
    80003a64:	70850513          	addi	a0,a0,1800 # 80039168 <ftable>
    80003a68:	00002097          	auipc	ra,0x2
    80003a6c:	79a080e7          	jalr	1946(ra) # 80006202 <initlock>
}
    80003a70:	60a2                	ld	ra,8(sp)
    80003a72:	6402                	ld	s0,0(sp)
    80003a74:	0141                	addi	sp,sp,16
    80003a76:	8082                	ret

0000000080003a78 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a78:	1101                	addi	sp,sp,-32
    80003a7a:	ec06                	sd	ra,24(sp)
    80003a7c:	e822                	sd	s0,16(sp)
    80003a7e:	e426                	sd	s1,8(sp)
    80003a80:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a82:	00035517          	auipc	a0,0x35
    80003a86:	6e650513          	addi	a0,a0,1766 # 80039168 <ftable>
    80003a8a:	00003097          	auipc	ra,0x3
    80003a8e:	808080e7          	jalr	-2040(ra) # 80006292 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a92:	00035497          	auipc	s1,0x35
    80003a96:	6ee48493          	addi	s1,s1,1774 # 80039180 <ftable+0x18>
    80003a9a:	00036717          	auipc	a4,0x36
    80003a9e:	68670713          	addi	a4,a4,1670 # 8003a120 <ftable+0xfb8>
    if(f->ref == 0){
    80003aa2:	40dc                	lw	a5,4(s1)
    80003aa4:	cf99                	beqz	a5,80003ac2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003aa6:	02848493          	addi	s1,s1,40
    80003aaa:	fee49ce3          	bne	s1,a4,80003aa2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003aae:	00035517          	auipc	a0,0x35
    80003ab2:	6ba50513          	addi	a0,a0,1722 # 80039168 <ftable>
    80003ab6:	00003097          	auipc	ra,0x3
    80003aba:	890080e7          	jalr	-1904(ra) # 80006346 <release>
  return 0;
    80003abe:	4481                	li	s1,0
    80003ac0:	a819                	j	80003ad6 <filealloc+0x5e>
      f->ref = 1;
    80003ac2:	4785                	li	a5,1
    80003ac4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003ac6:	00035517          	auipc	a0,0x35
    80003aca:	6a250513          	addi	a0,a0,1698 # 80039168 <ftable>
    80003ace:	00003097          	auipc	ra,0x3
    80003ad2:	878080e7          	jalr	-1928(ra) # 80006346 <release>
}
    80003ad6:	8526                	mv	a0,s1
    80003ad8:	60e2                	ld	ra,24(sp)
    80003ada:	6442                	ld	s0,16(sp)
    80003adc:	64a2                	ld	s1,8(sp)
    80003ade:	6105                	addi	sp,sp,32
    80003ae0:	8082                	ret

0000000080003ae2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003ae2:	1101                	addi	sp,sp,-32
    80003ae4:	ec06                	sd	ra,24(sp)
    80003ae6:	e822                	sd	s0,16(sp)
    80003ae8:	e426                	sd	s1,8(sp)
    80003aea:	1000                	addi	s0,sp,32
    80003aec:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003aee:	00035517          	auipc	a0,0x35
    80003af2:	67a50513          	addi	a0,a0,1658 # 80039168 <ftable>
    80003af6:	00002097          	auipc	ra,0x2
    80003afa:	79c080e7          	jalr	1948(ra) # 80006292 <acquire>
  if(f->ref < 1)
    80003afe:	40dc                	lw	a5,4(s1)
    80003b00:	02f05263          	blez	a5,80003b24 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b04:	2785                	addiw	a5,a5,1
    80003b06:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b08:	00035517          	auipc	a0,0x35
    80003b0c:	66050513          	addi	a0,a0,1632 # 80039168 <ftable>
    80003b10:	00003097          	auipc	ra,0x3
    80003b14:	836080e7          	jalr	-1994(ra) # 80006346 <release>
  return f;
}
    80003b18:	8526                	mv	a0,s1
    80003b1a:	60e2                	ld	ra,24(sp)
    80003b1c:	6442                	ld	s0,16(sp)
    80003b1e:	64a2                	ld	s1,8(sp)
    80003b20:	6105                	addi	sp,sp,32
    80003b22:	8082                	ret
    panic("filedup");
    80003b24:	00005517          	auipc	a0,0x5
    80003b28:	b1c50513          	addi	a0,a0,-1252 # 80008640 <syscalls+0x240>
    80003b2c:	00002097          	auipc	ra,0x2
    80003b30:	21c080e7          	jalr	540(ra) # 80005d48 <panic>

0000000080003b34 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b34:	7139                	addi	sp,sp,-64
    80003b36:	fc06                	sd	ra,56(sp)
    80003b38:	f822                	sd	s0,48(sp)
    80003b3a:	f426                	sd	s1,40(sp)
    80003b3c:	f04a                	sd	s2,32(sp)
    80003b3e:	ec4e                	sd	s3,24(sp)
    80003b40:	e852                	sd	s4,16(sp)
    80003b42:	e456                	sd	s5,8(sp)
    80003b44:	0080                	addi	s0,sp,64
    80003b46:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b48:	00035517          	auipc	a0,0x35
    80003b4c:	62050513          	addi	a0,a0,1568 # 80039168 <ftable>
    80003b50:	00002097          	auipc	ra,0x2
    80003b54:	742080e7          	jalr	1858(ra) # 80006292 <acquire>
  if(f->ref < 1)
    80003b58:	40dc                	lw	a5,4(s1)
    80003b5a:	06f05163          	blez	a5,80003bbc <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b5e:	37fd                	addiw	a5,a5,-1
    80003b60:	0007871b          	sext.w	a4,a5
    80003b64:	c0dc                	sw	a5,4(s1)
    80003b66:	06e04363          	bgtz	a4,80003bcc <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b6a:	0004a903          	lw	s2,0(s1)
    80003b6e:	0094ca83          	lbu	s5,9(s1)
    80003b72:	0104ba03          	ld	s4,16(s1)
    80003b76:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b7a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b7e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b82:	00035517          	auipc	a0,0x35
    80003b86:	5e650513          	addi	a0,a0,1510 # 80039168 <ftable>
    80003b8a:	00002097          	auipc	ra,0x2
    80003b8e:	7bc080e7          	jalr	1980(ra) # 80006346 <release>

  if(ff.type == FD_PIPE){
    80003b92:	4785                	li	a5,1
    80003b94:	04f90d63          	beq	s2,a5,80003bee <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b98:	3979                	addiw	s2,s2,-2
    80003b9a:	4785                	li	a5,1
    80003b9c:	0527e063          	bltu	a5,s2,80003bdc <fileclose+0xa8>
    begin_op();
    80003ba0:	00000097          	auipc	ra,0x0
    80003ba4:	ac8080e7          	jalr	-1336(ra) # 80003668 <begin_op>
    iput(ff.ip);
    80003ba8:	854e                	mv	a0,s3
    80003baa:	fffff097          	auipc	ra,0xfffff
    80003bae:	2a6080e7          	jalr	678(ra) # 80002e50 <iput>
    end_op();
    80003bb2:	00000097          	auipc	ra,0x0
    80003bb6:	b36080e7          	jalr	-1226(ra) # 800036e8 <end_op>
    80003bba:	a00d                	j	80003bdc <fileclose+0xa8>
    panic("fileclose");
    80003bbc:	00005517          	auipc	a0,0x5
    80003bc0:	a8c50513          	addi	a0,a0,-1396 # 80008648 <syscalls+0x248>
    80003bc4:	00002097          	auipc	ra,0x2
    80003bc8:	184080e7          	jalr	388(ra) # 80005d48 <panic>
    release(&ftable.lock);
    80003bcc:	00035517          	auipc	a0,0x35
    80003bd0:	59c50513          	addi	a0,a0,1436 # 80039168 <ftable>
    80003bd4:	00002097          	auipc	ra,0x2
    80003bd8:	772080e7          	jalr	1906(ra) # 80006346 <release>
  }
}
    80003bdc:	70e2                	ld	ra,56(sp)
    80003bde:	7442                	ld	s0,48(sp)
    80003be0:	74a2                	ld	s1,40(sp)
    80003be2:	7902                	ld	s2,32(sp)
    80003be4:	69e2                	ld	s3,24(sp)
    80003be6:	6a42                	ld	s4,16(sp)
    80003be8:	6aa2                	ld	s5,8(sp)
    80003bea:	6121                	addi	sp,sp,64
    80003bec:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003bee:	85d6                	mv	a1,s5
    80003bf0:	8552                	mv	a0,s4
    80003bf2:	00000097          	auipc	ra,0x0
    80003bf6:	34c080e7          	jalr	844(ra) # 80003f3e <pipeclose>
    80003bfa:	b7cd                	j	80003bdc <fileclose+0xa8>

0000000080003bfc <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bfc:	715d                	addi	sp,sp,-80
    80003bfe:	e486                	sd	ra,72(sp)
    80003c00:	e0a2                	sd	s0,64(sp)
    80003c02:	fc26                	sd	s1,56(sp)
    80003c04:	f84a                	sd	s2,48(sp)
    80003c06:	f44e                	sd	s3,40(sp)
    80003c08:	0880                	addi	s0,sp,80
    80003c0a:	84aa                	mv	s1,a0
    80003c0c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c0e:	ffffd097          	auipc	ra,0xffffd
    80003c12:	396080e7          	jalr	918(ra) # 80000fa4 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c16:	409c                	lw	a5,0(s1)
    80003c18:	37f9                	addiw	a5,a5,-2
    80003c1a:	4705                	li	a4,1
    80003c1c:	04f76763          	bltu	a4,a5,80003c6a <filestat+0x6e>
    80003c20:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c22:	6c88                	ld	a0,24(s1)
    80003c24:	fffff097          	auipc	ra,0xfffff
    80003c28:	072080e7          	jalr	114(ra) # 80002c96 <ilock>
    stati(f->ip, &st);
    80003c2c:	fb840593          	addi	a1,s0,-72
    80003c30:	6c88                	ld	a0,24(s1)
    80003c32:	fffff097          	auipc	ra,0xfffff
    80003c36:	2ee080e7          	jalr	750(ra) # 80002f20 <stati>
    iunlock(f->ip);
    80003c3a:	6c88                	ld	a0,24(s1)
    80003c3c:	fffff097          	auipc	ra,0xfffff
    80003c40:	11c080e7          	jalr	284(ra) # 80002d58 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c44:	46e1                	li	a3,24
    80003c46:	fb840613          	addi	a2,s0,-72
    80003c4a:	85ce                	mv	a1,s3
    80003c4c:	05093503          	ld	a0,80(s2)
    80003c50:	ffffd097          	auipc	ra,0xffffd
    80003c54:	f9c080e7          	jalr	-100(ra) # 80000bec <copyout>
    80003c58:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c5c:	60a6                	ld	ra,72(sp)
    80003c5e:	6406                	ld	s0,64(sp)
    80003c60:	74e2                	ld	s1,56(sp)
    80003c62:	7942                	ld	s2,48(sp)
    80003c64:	79a2                	ld	s3,40(sp)
    80003c66:	6161                	addi	sp,sp,80
    80003c68:	8082                	ret
  return -1;
    80003c6a:	557d                	li	a0,-1
    80003c6c:	bfc5                	j	80003c5c <filestat+0x60>

0000000080003c6e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c6e:	7179                	addi	sp,sp,-48
    80003c70:	f406                	sd	ra,40(sp)
    80003c72:	f022                	sd	s0,32(sp)
    80003c74:	ec26                	sd	s1,24(sp)
    80003c76:	e84a                	sd	s2,16(sp)
    80003c78:	e44e                	sd	s3,8(sp)
    80003c7a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c7c:	00854783          	lbu	a5,8(a0)
    80003c80:	c3d5                	beqz	a5,80003d24 <fileread+0xb6>
    80003c82:	84aa                	mv	s1,a0
    80003c84:	89ae                	mv	s3,a1
    80003c86:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c88:	411c                	lw	a5,0(a0)
    80003c8a:	4705                	li	a4,1
    80003c8c:	04e78963          	beq	a5,a4,80003cde <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c90:	470d                	li	a4,3
    80003c92:	04e78d63          	beq	a5,a4,80003cec <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c96:	4709                	li	a4,2
    80003c98:	06e79e63          	bne	a5,a4,80003d14 <fileread+0xa6>
    ilock(f->ip);
    80003c9c:	6d08                	ld	a0,24(a0)
    80003c9e:	fffff097          	auipc	ra,0xfffff
    80003ca2:	ff8080e7          	jalr	-8(ra) # 80002c96 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ca6:	874a                	mv	a4,s2
    80003ca8:	5094                	lw	a3,32(s1)
    80003caa:	864e                	mv	a2,s3
    80003cac:	4585                	li	a1,1
    80003cae:	6c88                	ld	a0,24(s1)
    80003cb0:	fffff097          	auipc	ra,0xfffff
    80003cb4:	29a080e7          	jalr	666(ra) # 80002f4a <readi>
    80003cb8:	892a                	mv	s2,a0
    80003cba:	00a05563          	blez	a0,80003cc4 <fileread+0x56>
      f->off += r;
    80003cbe:	509c                	lw	a5,32(s1)
    80003cc0:	9fa9                	addw	a5,a5,a0
    80003cc2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003cc4:	6c88                	ld	a0,24(s1)
    80003cc6:	fffff097          	auipc	ra,0xfffff
    80003cca:	092080e7          	jalr	146(ra) # 80002d58 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003cce:	854a                	mv	a0,s2
    80003cd0:	70a2                	ld	ra,40(sp)
    80003cd2:	7402                	ld	s0,32(sp)
    80003cd4:	64e2                	ld	s1,24(sp)
    80003cd6:	6942                	ld	s2,16(sp)
    80003cd8:	69a2                	ld	s3,8(sp)
    80003cda:	6145                	addi	sp,sp,48
    80003cdc:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cde:	6908                	ld	a0,16(a0)
    80003ce0:	00000097          	auipc	ra,0x0
    80003ce4:	3c8080e7          	jalr	968(ra) # 800040a8 <piperead>
    80003ce8:	892a                	mv	s2,a0
    80003cea:	b7d5                	j	80003cce <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cec:	02451783          	lh	a5,36(a0)
    80003cf0:	03079693          	slli	a3,a5,0x30
    80003cf4:	92c1                	srli	a3,a3,0x30
    80003cf6:	4725                	li	a4,9
    80003cf8:	02d76863          	bltu	a4,a3,80003d28 <fileread+0xba>
    80003cfc:	0792                	slli	a5,a5,0x4
    80003cfe:	00035717          	auipc	a4,0x35
    80003d02:	3ca70713          	addi	a4,a4,970 # 800390c8 <devsw>
    80003d06:	97ba                	add	a5,a5,a4
    80003d08:	639c                	ld	a5,0(a5)
    80003d0a:	c38d                	beqz	a5,80003d2c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d0c:	4505                	li	a0,1
    80003d0e:	9782                	jalr	a5
    80003d10:	892a                	mv	s2,a0
    80003d12:	bf75                	j	80003cce <fileread+0x60>
    panic("fileread");
    80003d14:	00005517          	auipc	a0,0x5
    80003d18:	94450513          	addi	a0,a0,-1724 # 80008658 <syscalls+0x258>
    80003d1c:	00002097          	auipc	ra,0x2
    80003d20:	02c080e7          	jalr	44(ra) # 80005d48 <panic>
    return -1;
    80003d24:	597d                	li	s2,-1
    80003d26:	b765                	j	80003cce <fileread+0x60>
      return -1;
    80003d28:	597d                	li	s2,-1
    80003d2a:	b755                	j	80003cce <fileread+0x60>
    80003d2c:	597d                	li	s2,-1
    80003d2e:	b745                	j	80003cce <fileread+0x60>

0000000080003d30 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d30:	715d                	addi	sp,sp,-80
    80003d32:	e486                	sd	ra,72(sp)
    80003d34:	e0a2                	sd	s0,64(sp)
    80003d36:	fc26                	sd	s1,56(sp)
    80003d38:	f84a                	sd	s2,48(sp)
    80003d3a:	f44e                	sd	s3,40(sp)
    80003d3c:	f052                	sd	s4,32(sp)
    80003d3e:	ec56                	sd	s5,24(sp)
    80003d40:	e85a                	sd	s6,16(sp)
    80003d42:	e45e                	sd	s7,8(sp)
    80003d44:	e062                	sd	s8,0(sp)
    80003d46:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d48:	00954783          	lbu	a5,9(a0)
    80003d4c:	10078663          	beqz	a5,80003e58 <filewrite+0x128>
    80003d50:	892a                	mv	s2,a0
    80003d52:	8aae                	mv	s5,a1
    80003d54:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d56:	411c                	lw	a5,0(a0)
    80003d58:	4705                	li	a4,1
    80003d5a:	02e78263          	beq	a5,a4,80003d7e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d5e:	470d                	li	a4,3
    80003d60:	02e78663          	beq	a5,a4,80003d8c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d64:	4709                	li	a4,2
    80003d66:	0ee79163          	bne	a5,a4,80003e48 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d6a:	0ac05d63          	blez	a2,80003e24 <filewrite+0xf4>
    int i = 0;
    80003d6e:	4981                	li	s3,0
    80003d70:	6b05                	lui	s6,0x1
    80003d72:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d76:	6b85                	lui	s7,0x1
    80003d78:	c00b8b9b          	addiw	s7,s7,-1024
    80003d7c:	a861                	j	80003e14 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d7e:	6908                	ld	a0,16(a0)
    80003d80:	00000097          	auipc	ra,0x0
    80003d84:	22e080e7          	jalr	558(ra) # 80003fae <pipewrite>
    80003d88:	8a2a                	mv	s4,a0
    80003d8a:	a045                	j	80003e2a <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d8c:	02451783          	lh	a5,36(a0)
    80003d90:	03079693          	slli	a3,a5,0x30
    80003d94:	92c1                	srli	a3,a3,0x30
    80003d96:	4725                	li	a4,9
    80003d98:	0cd76263          	bltu	a4,a3,80003e5c <filewrite+0x12c>
    80003d9c:	0792                	slli	a5,a5,0x4
    80003d9e:	00035717          	auipc	a4,0x35
    80003da2:	32a70713          	addi	a4,a4,810 # 800390c8 <devsw>
    80003da6:	97ba                	add	a5,a5,a4
    80003da8:	679c                	ld	a5,8(a5)
    80003daa:	cbdd                	beqz	a5,80003e60 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003dac:	4505                	li	a0,1
    80003dae:	9782                	jalr	a5
    80003db0:	8a2a                	mv	s4,a0
    80003db2:	a8a5                	j	80003e2a <filewrite+0xfa>
    80003db4:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003db8:	00000097          	auipc	ra,0x0
    80003dbc:	8b0080e7          	jalr	-1872(ra) # 80003668 <begin_op>
      ilock(f->ip);
    80003dc0:	01893503          	ld	a0,24(s2)
    80003dc4:	fffff097          	auipc	ra,0xfffff
    80003dc8:	ed2080e7          	jalr	-302(ra) # 80002c96 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003dcc:	8762                	mv	a4,s8
    80003dce:	02092683          	lw	a3,32(s2)
    80003dd2:	01598633          	add	a2,s3,s5
    80003dd6:	4585                	li	a1,1
    80003dd8:	01893503          	ld	a0,24(s2)
    80003ddc:	fffff097          	auipc	ra,0xfffff
    80003de0:	266080e7          	jalr	614(ra) # 80003042 <writei>
    80003de4:	84aa                	mv	s1,a0
    80003de6:	00a05763          	blez	a0,80003df4 <filewrite+0xc4>
        f->off += r;
    80003dea:	02092783          	lw	a5,32(s2)
    80003dee:	9fa9                	addw	a5,a5,a0
    80003df0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003df4:	01893503          	ld	a0,24(s2)
    80003df8:	fffff097          	auipc	ra,0xfffff
    80003dfc:	f60080e7          	jalr	-160(ra) # 80002d58 <iunlock>
      end_op();
    80003e00:	00000097          	auipc	ra,0x0
    80003e04:	8e8080e7          	jalr	-1816(ra) # 800036e8 <end_op>

      if(r != n1){
    80003e08:	009c1f63          	bne	s8,s1,80003e26 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e0c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e10:	0149db63          	bge	s3,s4,80003e26 <filewrite+0xf6>
      int n1 = n - i;
    80003e14:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e18:	84be                	mv	s1,a5
    80003e1a:	2781                	sext.w	a5,a5
    80003e1c:	f8fb5ce3          	bge	s6,a5,80003db4 <filewrite+0x84>
    80003e20:	84de                	mv	s1,s7
    80003e22:	bf49                	j	80003db4 <filewrite+0x84>
    int i = 0;
    80003e24:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e26:	013a1f63          	bne	s4,s3,80003e44 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e2a:	8552                	mv	a0,s4
    80003e2c:	60a6                	ld	ra,72(sp)
    80003e2e:	6406                	ld	s0,64(sp)
    80003e30:	74e2                	ld	s1,56(sp)
    80003e32:	7942                	ld	s2,48(sp)
    80003e34:	79a2                	ld	s3,40(sp)
    80003e36:	7a02                	ld	s4,32(sp)
    80003e38:	6ae2                	ld	s5,24(sp)
    80003e3a:	6b42                	ld	s6,16(sp)
    80003e3c:	6ba2                	ld	s7,8(sp)
    80003e3e:	6c02                	ld	s8,0(sp)
    80003e40:	6161                	addi	sp,sp,80
    80003e42:	8082                	ret
    ret = (i == n ? n : -1);
    80003e44:	5a7d                	li	s4,-1
    80003e46:	b7d5                	j	80003e2a <filewrite+0xfa>
    panic("filewrite");
    80003e48:	00005517          	auipc	a0,0x5
    80003e4c:	82050513          	addi	a0,a0,-2016 # 80008668 <syscalls+0x268>
    80003e50:	00002097          	auipc	ra,0x2
    80003e54:	ef8080e7          	jalr	-264(ra) # 80005d48 <panic>
    return -1;
    80003e58:	5a7d                	li	s4,-1
    80003e5a:	bfc1                	j	80003e2a <filewrite+0xfa>
      return -1;
    80003e5c:	5a7d                	li	s4,-1
    80003e5e:	b7f1                	j	80003e2a <filewrite+0xfa>
    80003e60:	5a7d                	li	s4,-1
    80003e62:	b7e1                	j	80003e2a <filewrite+0xfa>

0000000080003e64 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e64:	7179                	addi	sp,sp,-48
    80003e66:	f406                	sd	ra,40(sp)
    80003e68:	f022                	sd	s0,32(sp)
    80003e6a:	ec26                	sd	s1,24(sp)
    80003e6c:	e84a                	sd	s2,16(sp)
    80003e6e:	e44e                	sd	s3,8(sp)
    80003e70:	e052                	sd	s4,0(sp)
    80003e72:	1800                	addi	s0,sp,48
    80003e74:	84aa                	mv	s1,a0
    80003e76:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e78:	0005b023          	sd	zero,0(a1)
    80003e7c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e80:	00000097          	auipc	ra,0x0
    80003e84:	bf8080e7          	jalr	-1032(ra) # 80003a78 <filealloc>
    80003e88:	e088                	sd	a0,0(s1)
    80003e8a:	c551                	beqz	a0,80003f16 <pipealloc+0xb2>
    80003e8c:	00000097          	auipc	ra,0x0
    80003e90:	bec080e7          	jalr	-1044(ra) # 80003a78 <filealloc>
    80003e94:	00aa3023          	sd	a0,0(s4)
    80003e98:	c92d                	beqz	a0,80003f0a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e9a:	ffffc097          	auipc	ra,0xffffc
    80003e9e:	336080e7          	jalr	822(ra) # 800001d0 <kalloc>
    80003ea2:	892a                	mv	s2,a0
    80003ea4:	c125                	beqz	a0,80003f04 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ea6:	4985                	li	s3,1
    80003ea8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003eac:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003eb0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003eb4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003eb8:	00004597          	auipc	a1,0x4
    80003ebc:	7c058593          	addi	a1,a1,1984 # 80008678 <syscalls+0x278>
    80003ec0:	00002097          	auipc	ra,0x2
    80003ec4:	342080e7          	jalr	834(ra) # 80006202 <initlock>
  (*f0)->type = FD_PIPE;
    80003ec8:	609c                	ld	a5,0(s1)
    80003eca:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ece:	609c                	ld	a5,0(s1)
    80003ed0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ed4:	609c                	ld	a5,0(s1)
    80003ed6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003eda:	609c                	ld	a5,0(s1)
    80003edc:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ee0:	000a3783          	ld	a5,0(s4)
    80003ee4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ee8:	000a3783          	ld	a5,0(s4)
    80003eec:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ef0:	000a3783          	ld	a5,0(s4)
    80003ef4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ef8:	000a3783          	ld	a5,0(s4)
    80003efc:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f00:	4501                	li	a0,0
    80003f02:	a025                	j	80003f2a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f04:	6088                	ld	a0,0(s1)
    80003f06:	e501                	bnez	a0,80003f0e <pipealloc+0xaa>
    80003f08:	a039                	j	80003f16 <pipealloc+0xb2>
    80003f0a:	6088                	ld	a0,0(s1)
    80003f0c:	c51d                	beqz	a0,80003f3a <pipealloc+0xd6>
    fileclose(*f0);
    80003f0e:	00000097          	auipc	ra,0x0
    80003f12:	c26080e7          	jalr	-986(ra) # 80003b34 <fileclose>
  if(*f1)
    80003f16:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f1a:	557d                	li	a0,-1
  if(*f1)
    80003f1c:	c799                	beqz	a5,80003f2a <pipealloc+0xc6>
    fileclose(*f1);
    80003f1e:	853e                	mv	a0,a5
    80003f20:	00000097          	auipc	ra,0x0
    80003f24:	c14080e7          	jalr	-1004(ra) # 80003b34 <fileclose>
  return -1;
    80003f28:	557d                	li	a0,-1
}
    80003f2a:	70a2                	ld	ra,40(sp)
    80003f2c:	7402                	ld	s0,32(sp)
    80003f2e:	64e2                	ld	s1,24(sp)
    80003f30:	6942                	ld	s2,16(sp)
    80003f32:	69a2                	ld	s3,8(sp)
    80003f34:	6a02                	ld	s4,0(sp)
    80003f36:	6145                	addi	sp,sp,48
    80003f38:	8082                	ret
  return -1;
    80003f3a:	557d                	li	a0,-1
    80003f3c:	b7fd                	j	80003f2a <pipealloc+0xc6>

0000000080003f3e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f3e:	1101                	addi	sp,sp,-32
    80003f40:	ec06                	sd	ra,24(sp)
    80003f42:	e822                	sd	s0,16(sp)
    80003f44:	e426                	sd	s1,8(sp)
    80003f46:	e04a                	sd	s2,0(sp)
    80003f48:	1000                	addi	s0,sp,32
    80003f4a:	84aa                	mv	s1,a0
    80003f4c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f4e:	00002097          	auipc	ra,0x2
    80003f52:	344080e7          	jalr	836(ra) # 80006292 <acquire>
  if(writable){
    80003f56:	02090d63          	beqz	s2,80003f90 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f5a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f5e:	21848513          	addi	a0,s1,536
    80003f62:	ffffe097          	auipc	ra,0xffffe
    80003f66:	88a080e7          	jalr	-1910(ra) # 800017ec <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f6a:	2204b783          	ld	a5,544(s1)
    80003f6e:	eb95                	bnez	a5,80003fa2 <pipeclose+0x64>
    release(&pi->lock);
    80003f70:	8526                	mv	a0,s1
    80003f72:	00002097          	auipc	ra,0x2
    80003f76:	3d4080e7          	jalr	980(ra) # 80006346 <release>
    kfree((char*)pi);
    80003f7a:	8526                	mv	a0,s1
    80003f7c:	ffffc097          	auipc	ra,0xffffc
    80003f80:	0f0080e7          	jalr	240(ra) # 8000006c <kfree>
  } else
    release(&pi->lock);
}
    80003f84:	60e2                	ld	ra,24(sp)
    80003f86:	6442                	ld	s0,16(sp)
    80003f88:	64a2                	ld	s1,8(sp)
    80003f8a:	6902                	ld	s2,0(sp)
    80003f8c:	6105                	addi	sp,sp,32
    80003f8e:	8082                	ret
    pi->readopen = 0;
    80003f90:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f94:	21c48513          	addi	a0,s1,540
    80003f98:	ffffe097          	auipc	ra,0xffffe
    80003f9c:	854080e7          	jalr	-1964(ra) # 800017ec <wakeup>
    80003fa0:	b7e9                	j	80003f6a <pipeclose+0x2c>
    release(&pi->lock);
    80003fa2:	8526                	mv	a0,s1
    80003fa4:	00002097          	auipc	ra,0x2
    80003fa8:	3a2080e7          	jalr	930(ra) # 80006346 <release>
}
    80003fac:	bfe1                	j	80003f84 <pipeclose+0x46>

0000000080003fae <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fae:	7159                	addi	sp,sp,-112
    80003fb0:	f486                	sd	ra,104(sp)
    80003fb2:	f0a2                	sd	s0,96(sp)
    80003fb4:	eca6                	sd	s1,88(sp)
    80003fb6:	e8ca                	sd	s2,80(sp)
    80003fb8:	e4ce                	sd	s3,72(sp)
    80003fba:	e0d2                	sd	s4,64(sp)
    80003fbc:	fc56                	sd	s5,56(sp)
    80003fbe:	f85a                	sd	s6,48(sp)
    80003fc0:	f45e                	sd	s7,40(sp)
    80003fc2:	f062                	sd	s8,32(sp)
    80003fc4:	ec66                	sd	s9,24(sp)
    80003fc6:	1880                	addi	s0,sp,112
    80003fc8:	84aa                	mv	s1,a0
    80003fca:	8aae                	mv	s5,a1
    80003fcc:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fce:	ffffd097          	auipc	ra,0xffffd
    80003fd2:	fd6080e7          	jalr	-42(ra) # 80000fa4 <myproc>
    80003fd6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fd8:	8526                	mv	a0,s1
    80003fda:	00002097          	auipc	ra,0x2
    80003fde:	2b8080e7          	jalr	696(ra) # 80006292 <acquire>
  while(i < n){
    80003fe2:	0d405163          	blez	s4,800040a4 <pipewrite+0xf6>
    80003fe6:	8ba6                	mv	s7,s1
  int i = 0;
    80003fe8:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fea:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fec:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003ff0:	21c48c13          	addi	s8,s1,540
    80003ff4:	a08d                	j	80004056 <pipewrite+0xa8>
      release(&pi->lock);
    80003ff6:	8526                	mv	a0,s1
    80003ff8:	00002097          	auipc	ra,0x2
    80003ffc:	34e080e7          	jalr	846(ra) # 80006346 <release>
      return -1;
    80004000:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004002:	854a                	mv	a0,s2
    80004004:	70a6                	ld	ra,104(sp)
    80004006:	7406                	ld	s0,96(sp)
    80004008:	64e6                	ld	s1,88(sp)
    8000400a:	6946                	ld	s2,80(sp)
    8000400c:	69a6                	ld	s3,72(sp)
    8000400e:	6a06                	ld	s4,64(sp)
    80004010:	7ae2                	ld	s5,56(sp)
    80004012:	7b42                	ld	s6,48(sp)
    80004014:	7ba2                	ld	s7,40(sp)
    80004016:	7c02                	ld	s8,32(sp)
    80004018:	6ce2                	ld	s9,24(sp)
    8000401a:	6165                	addi	sp,sp,112
    8000401c:	8082                	ret
      wakeup(&pi->nread);
    8000401e:	8566                	mv	a0,s9
    80004020:	ffffd097          	auipc	ra,0xffffd
    80004024:	7cc080e7          	jalr	1996(ra) # 800017ec <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004028:	85de                	mv	a1,s7
    8000402a:	8562                	mv	a0,s8
    8000402c:	ffffd097          	auipc	ra,0xffffd
    80004030:	634080e7          	jalr	1588(ra) # 80001660 <sleep>
    80004034:	a839                	j	80004052 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004036:	21c4a783          	lw	a5,540(s1)
    8000403a:	0017871b          	addiw	a4,a5,1
    8000403e:	20e4ae23          	sw	a4,540(s1)
    80004042:	1ff7f793          	andi	a5,a5,511
    80004046:	97a6                	add	a5,a5,s1
    80004048:	f9f44703          	lbu	a4,-97(s0)
    8000404c:	00e78c23          	sb	a4,24(a5)
      i++;
    80004050:	2905                	addiw	s2,s2,1
  while(i < n){
    80004052:	03495d63          	bge	s2,s4,8000408c <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80004056:	2204a783          	lw	a5,544(s1)
    8000405a:	dfd1                	beqz	a5,80003ff6 <pipewrite+0x48>
    8000405c:	0289a783          	lw	a5,40(s3)
    80004060:	fbd9                	bnez	a5,80003ff6 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004062:	2184a783          	lw	a5,536(s1)
    80004066:	21c4a703          	lw	a4,540(s1)
    8000406a:	2007879b          	addiw	a5,a5,512
    8000406e:	faf708e3          	beq	a4,a5,8000401e <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004072:	4685                	li	a3,1
    80004074:	01590633          	add	a2,s2,s5
    80004078:	f9f40593          	addi	a1,s0,-97
    8000407c:	0509b503          	ld	a0,80(s3)
    80004080:	ffffd097          	auipc	ra,0xffffd
    80004084:	c72080e7          	jalr	-910(ra) # 80000cf2 <copyin>
    80004088:	fb6517e3          	bne	a0,s6,80004036 <pipewrite+0x88>
  wakeup(&pi->nread);
    8000408c:	21848513          	addi	a0,s1,536
    80004090:	ffffd097          	auipc	ra,0xffffd
    80004094:	75c080e7          	jalr	1884(ra) # 800017ec <wakeup>
  release(&pi->lock);
    80004098:	8526                	mv	a0,s1
    8000409a:	00002097          	auipc	ra,0x2
    8000409e:	2ac080e7          	jalr	684(ra) # 80006346 <release>
  return i;
    800040a2:	b785                	j	80004002 <pipewrite+0x54>
  int i = 0;
    800040a4:	4901                	li	s2,0
    800040a6:	b7dd                	j	8000408c <pipewrite+0xde>

00000000800040a8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040a8:	715d                	addi	sp,sp,-80
    800040aa:	e486                	sd	ra,72(sp)
    800040ac:	e0a2                	sd	s0,64(sp)
    800040ae:	fc26                	sd	s1,56(sp)
    800040b0:	f84a                	sd	s2,48(sp)
    800040b2:	f44e                	sd	s3,40(sp)
    800040b4:	f052                	sd	s4,32(sp)
    800040b6:	ec56                	sd	s5,24(sp)
    800040b8:	e85a                	sd	s6,16(sp)
    800040ba:	0880                	addi	s0,sp,80
    800040bc:	84aa                	mv	s1,a0
    800040be:	892e                	mv	s2,a1
    800040c0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040c2:	ffffd097          	auipc	ra,0xffffd
    800040c6:	ee2080e7          	jalr	-286(ra) # 80000fa4 <myproc>
    800040ca:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040cc:	8b26                	mv	s6,s1
    800040ce:	8526                	mv	a0,s1
    800040d0:	00002097          	auipc	ra,0x2
    800040d4:	1c2080e7          	jalr	450(ra) # 80006292 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040d8:	2184a703          	lw	a4,536(s1)
    800040dc:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040e0:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040e4:	02f71463          	bne	a4,a5,8000410c <piperead+0x64>
    800040e8:	2244a783          	lw	a5,548(s1)
    800040ec:	c385                	beqz	a5,8000410c <piperead+0x64>
    if(pr->killed){
    800040ee:	028a2783          	lw	a5,40(s4)
    800040f2:	ebc1                	bnez	a5,80004182 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040f4:	85da                	mv	a1,s6
    800040f6:	854e                	mv	a0,s3
    800040f8:	ffffd097          	auipc	ra,0xffffd
    800040fc:	568080e7          	jalr	1384(ra) # 80001660 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004100:	2184a703          	lw	a4,536(s1)
    80004104:	21c4a783          	lw	a5,540(s1)
    80004108:	fef700e3          	beq	a4,a5,800040e8 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000410c:	09505263          	blez	s5,80004190 <piperead+0xe8>
    80004110:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004112:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004114:	2184a783          	lw	a5,536(s1)
    80004118:	21c4a703          	lw	a4,540(s1)
    8000411c:	02f70d63          	beq	a4,a5,80004156 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004120:	0017871b          	addiw	a4,a5,1
    80004124:	20e4ac23          	sw	a4,536(s1)
    80004128:	1ff7f793          	andi	a5,a5,511
    8000412c:	97a6                	add	a5,a5,s1
    8000412e:	0187c783          	lbu	a5,24(a5)
    80004132:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004136:	4685                	li	a3,1
    80004138:	fbf40613          	addi	a2,s0,-65
    8000413c:	85ca                	mv	a1,s2
    8000413e:	050a3503          	ld	a0,80(s4)
    80004142:	ffffd097          	auipc	ra,0xffffd
    80004146:	aaa080e7          	jalr	-1366(ra) # 80000bec <copyout>
    8000414a:	01650663          	beq	a0,s6,80004156 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000414e:	2985                	addiw	s3,s3,1
    80004150:	0905                	addi	s2,s2,1
    80004152:	fd3a91e3          	bne	s5,s3,80004114 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004156:	21c48513          	addi	a0,s1,540
    8000415a:	ffffd097          	auipc	ra,0xffffd
    8000415e:	692080e7          	jalr	1682(ra) # 800017ec <wakeup>
  release(&pi->lock);
    80004162:	8526                	mv	a0,s1
    80004164:	00002097          	auipc	ra,0x2
    80004168:	1e2080e7          	jalr	482(ra) # 80006346 <release>
  return i;
}
    8000416c:	854e                	mv	a0,s3
    8000416e:	60a6                	ld	ra,72(sp)
    80004170:	6406                	ld	s0,64(sp)
    80004172:	74e2                	ld	s1,56(sp)
    80004174:	7942                	ld	s2,48(sp)
    80004176:	79a2                	ld	s3,40(sp)
    80004178:	7a02                	ld	s4,32(sp)
    8000417a:	6ae2                	ld	s5,24(sp)
    8000417c:	6b42                	ld	s6,16(sp)
    8000417e:	6161                	addi	sp,sp,80
    80004180:	8082                	ret
      release(&pi->lock);
    80004182:	8526                	mv	a0,s1
    80004184:	00002097          	auipc	ra,0x2
    80004188:	1c2080e7          	jalr	450(ra) # 80006346 <release>
      return -1;
    8000418c:	59fd                	li	s3,-1
    8000418e:	bff9                	j	8000416c <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004190:	4981                	li	s3,0
    80004192:	b7d1                	j	80004156 <piperead+0xae>

0000000080004194 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004194:	df010113          	addi	sp,sp,-528
    80004198:	20113423          	sd	ra,520(sp)
    8000419c:	20813023          	sd	s0,512(sp)
    800041a0:	ffa6                	sd	s1,504(sp)
    800041a2:	fbca                	sd	s2,496(sp)
    800041a4:	f7ce                	sd	s3,488(sp)
    800041a6:	f3d2                	sd	s4,480(sp)
    800041a8:	efd6                	sd	s5,472(sp)
    800041aa:	ebda                	sd	s6,464(sp)
    800041ac:	e7de                	sd	s7,456(sp)
    800041ae:	e3e2                	sd	s8,448(sp)
    800041b0:	ff66                	sd	s9,440(sp)
    800041b2:	fb6a                	sd	s10,432(sp)
    800041b4:	f76e                	sd	s11,424(sp)
    800041b6:	0c00                	addi	s0,sp,528
    800041b8:	84aa                	mv	s1,a0
    800041ba:	dea43c23          	sd	a0,-520(s0)
    800041be:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041c2:	ffffd097          	auipc	ra,0xffffd
    800041c6:	de2080e7          	jalr	-542(ra) # 80000fa4 <myproc>
    800041ca:	892a                	mv	s2,a0

  begin_op();
    800041cc:	fffff097          	auipc	ra,0xfffff
    800041d0:	49c080e7          	jalr	1180(ra) # 80003668 <begin_op>

  if((ip = namei(path)) == 0){
    800041d4:	8526                	mv	a0,s1
    800041d6:	fffff097          	auipc	ra,0xfffff
    800041da:	276080e7          	jalr	630(ra) # 8000344c <namei>
    800041de:	c92d                	beqz	a0,80004250 <exec+0xbc>
    800041e0:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041e2:	fffff097          	auipc	ra,0xfffff
    800041e6:	ab4080e7          	jalr	-1356(ra) # 80002c96 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041ea:	04000713          	li	a4,64
    800041ee:	4681                	li	a3,0
    800041f0:	e5040613          	addi	a2,s0,-432
    800041f4:	4581                	li	a1,0
    800041f6:	8526                	mv	a0,s1
    800041f8:	fffff097          	auipc	ra,0xfffff
    800041fc:	d52080e7          	jalr	-686(ra) # 80002f4a <readi>
    80004200:	04000793          	li	a5,64
    80004204:	00f51a63          	bne	a0,a5,80004218 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004208:	e5042703          	lw	a4,-432(s0)
    8000420c:	464c47b7          	lui	a5,0x464c4
    80004210:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004214:	04f70463          	beq	a4,a5,8000425c <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004218:	8526                	mv	a0,s1
    8000421a:	fffff097          	auipc	ra,0xfffff
    8000421e:	cde080e7          	jalr	-802(ra) # 80002ef8 <iunlockput>
    end_op();
    80004222:	fffff097          	auipc	ra,0xfffff
    80004226:	4c6080e7          	jalr	1222(ra) # 800036e8 <end_op>
  }
  return -1;
    8000422a:	557d                	li	a0,-1
}
    8000422c:	20813083          	ld	ra,520(sp)
    80004230:	20013403          	ld	s0,512(sp)
    80004234:	74fe                	ld	s1,504(sp)
    80004236:	795e                	ld	s2,496(sp)
    80004238:	79be                	ld	s3,488(sp)
    8000423a:	7a1e                	ld	s4,480(sp)
    8000423c:	6afe                	ld	s5,472(sp)
    8000423e:	6b5e                	ld	s6,464(sp)
    80004240:	6bbe                	ld	s7,456(sp)
    80004242:	6c1e                	ld	s8,448(sp)
    80004244:	7cfa                	ld	s9,440(sp)
    80004246:	7d5a                	ld	s10,432(sp)
    80004248:	7dba                	ld	s11,424(sp)
    8000424a:	21010113          	addi	sp,sp,528
    8000424e:	8082                	ret
    end_op();
    80004250:	fffff097          	auipc	ra,0xfffff
    80004254:	498080e7          	jalr	1176(ra) # 800036e8 <end_op>
    return -1;
    80004258:	557d                	li	a0,-1
    8000425a:	bfc9                	j	8000422c <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000425c:	854a                	mv	a0,s2
    8000425e:	ffffd097          	auipc	ra,0xffffd
    80004262:	e0a080e7          	jalr	-502(ra) # 80001068 <proc_pagetable>
    80004266:	8baa                	mv	s7,a0
    80004268:	d945                	beqz	a0,80004218 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000426a:	e7042983          	lw	s3,-400(s0)
    8000426e:	e8845783          	lhu	a5,-376(s0)
    80004272:	c7ad                	beqz	a5,800042dc <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004274:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004276:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004278:	6c85                	lui	s9,0x1
    8000427a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000427e:	def43823          	sd	a5,-528(s0)
    80004282:	a42d                	j	800044ac <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004284:	00004517          	auipc	a0,0x4
    80004288:	3fc50513          	addi	a0,a0,1020 # 80008680 <syscalls+0x280>
    8000428c:	00002097          	auipc	ra,0x2
    80004290:	abc080e7          	jalr	-1348(ra) # 80005d48 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004294:	8756                	mv	a4,s5
    80004296:	012d86bb          	addw	a3,s11,s2
    8000429a:	4581                	li	a1,0
    8000429c:	8526                	mv	a0,s1
    8000429e:	fffff097          	auipc	ra,0xfffff
    800042a2:	cac080e7          	jalr	-852(ra) # 80002f4a <readi>
    800042a6:	2501                	sext.w	a0,a0
    800042a8:	1aaa9963          	bne	s5,a0,8000445a <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800042ac:	6785                	lui	a5,0x1
    800042ae:	0127893b          	addw	s2,a5,s2
    800042b2:	77fd                	lui	a5,0xfffff
    800042b4:	01478a3b          	addw	s4,a5,s4
    800042b8:	1f897163          	bgeu	s2,s8,8000449a <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800042bc:	02091593          	slli	a1,s2,0x20
    800042c0:	9181                	srli	a1,a1,0x20
    800042c2:	95ea                	add	a1,a1,s10
    800042c4:	855e                	mv	a0,s7
    800042c6:	ffffc097          	auipc	ra,0xffffc
    800042ca:	312080e7          	jalr	786(ra) # 800005d8 <walkaddr>
    800042ce:	862a                	mv	a2,a0
    if(pa == 0)
    800042d0:	d955                	beqz	a0,80004284 <exec+0xf0>
      n = PGSIZE;
    800042d2:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800042d4:	fd9a70e3          	bgeu	s4,s9,80004294 <exec+0x100>
      n = sz - i;
    800042d8:	8ad2                	mv	s5,s4
    800042da:	bf6d                	j	80004294 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042dc:	4901                	li	s2,0
  iunlockput(ip);
    800042de:	8526                	mv	a0,s1
    800042e0:	fffff097          	auipc	ra,0xfffff
    800042e4:	c18080e7          	jalr	-1000(ra) # 80002ef8 <iunlockput>
  end_op();
    800042e8:	fffff097          	auipc	ra,0xfffff
    800042ec:	400080e7          	jalr	1024(ra) # 800036e8 <end_op>
  p = myproc();
    800042f0:	ffffd097          	auipc	ra,0xffffd
    800042f4:	cb4080e7          	jalr	-844(ra) # 80000fa4 <myproc>
    800042f8:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042fa:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042fe:	6785                	lui	a5,0x1
    80004300:	17fd                	addi	a5,a5,-1
    80004302:	993e                	add	s2,s2,a5
    80004304:	757d                	lui	a0,0xfffff
    80004306:	00a977b3          	and	a5,s2,a0
    8000430a:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000430e:	6609                	lui	a2,0x2
    80004310:	963e                	add	a2,a2,a5
    80004312:	85be                	mv	a1,a5
    80004314:	855e                	mv	a0,s7
    80004316:	ffffc097          	auipc	ra,0xffffc
    8000431a:	698080e7          	jalr	1688(ra) # 800009ae <uvmalloc>
    8000431e:	8b2a                	mv	s6,a0
  ip = 0;
    80004320:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004322:	12050c63          	beqz	a0,8000445a <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004326:	75f9                	lui	a1,0xffffe
    80004328:	95aa                	add	a1,a1,a0
    8000432a:	855e                	mv	a0,s7
    8000432c:	ffffd097          	auipc	ra,0xffffd
    80004330:	88e080e7          	jalr	-1906(ra) # 80000bba <uvmclear>
  stackbase = sp - PGSIZE;
    80004334:	7c7d                	lui	s8,0xfffff
    80004336:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004338:	e0043783          	ld	a5,-512(s0)
    8000433c:	6388                	ld	a0,0(a5)
    8000433e:	c535                	beqz	a0,800043aa <exec+0x216>
    80004340:	e9040993          	addi	s3,s0,-368
    80004344:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004348:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000434a:	ffffc097          	auipc	ra,0xffffc
    8000434e:	084080e7          	jalr	132(ra) # 800003ce <strlen>
    80004352:	2505                	addiw	a0,a0,1
    80004354:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004358:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000435c:	13896363          	bltu	s2,s8,80004482 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004360:	e0043d83          	ld	s11,-512(s0)
    80004364:	000dba03          	ld	s4,0(s11)
    80004368:	8552                	mv	a0,s4
    8000436a:	ffffc097          	auipc	ra,0xffffc
    8000436e:	064080e7          	jalr	100(ra) # 800003ce <strlen>
    80004372:	0015069b          	addiw	a3,a0,1
    80004376:	8652                	mv	a2,s4
    80004378:	85ca                	mv	a1,s2
    8000437a:	855e                	mv	a0,s7
    8000437c:	ffffd097          	auipc	ra,0xffffd
    80004380:	870080e7          	jalr	-1936(ra) # 80000bec <copyout>
    80004384:	10054363          	bltz	a0,8000448a <exec+0x2f6>
    ustack[argc] = sp;
    80004388:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000438c:	0485                	addi	s1,s1,1
    8000438e:	008d8793          	addi	a5,s11,8
    80004392:	e0f43023          	sd	a5,-512(s0)
    80004396:	008db503          	ld	a0,8(s11)
    8000439a:	c911                	beqz	a0,800043ae <exec+0x21a>
    if(argc >= MAXARG)
    8000439c:	09a1                	addi	s3,s3,8
    8000439e:	fb3c96e3          	bne	s9,s3,8000434a <exec+0x1b6>
  sz = sz1;
    800043a2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043a6:	4481                	li	s1,0
    800043a8:	a84d                	j	8000445a <exec+0x2c6>
  sp = sz;
    800043aa:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800043ac:	4481                	li	s1,0
  ustack[argc] = 0;
    800043ae:	00349793          	slli	a5,s1,0x3
    800043b2:	f9040713          	addi	a4,s0,-112
    800043b6:	97ba                	add	a5,a5,a4
    800043b8:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800043bc:	00148693          	addi	a3,s1,1
    800043c0:	068e                	slli	a3,a3,0x3
    800043c2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043c6:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043ca:	01897663          	bgeu	s2,s8,800043d6 <exec+0x242>
  sz = sz1;
    800043ce:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043d2:	4481                	li	s1,0
    800043d4:	a059                	j	8000445a <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043d6:	e9040613          	addi	a2,s0,-368
    800043da:	85ca                	mv	a1,s2
    800043dc:	855e                	mv	a0,s7
    800043de:	ffffd097          	auipc	ra,0xffffd
    800043e2:	80e080e7          	jalr	-2034(ra) # 80000bec <copyout>
    800043e6:	0a054663          	bltz	a0,80004492 <exec+0x2fe>
  p->trapframe->a1 = sp;
    800043ea:	058ab783          	ld	a5,88(s5)
    800043ee:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043f2:	df843783          	ld	a5,-520(s0)
    800043f6:	0007c703          	lbu	a4,0(a5)
    800043fa:	cf11                	beqz	a4,80004416 <exec+0x282>
    800043fc:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043fe:	02f00693          	li	a3,47
    80004402:	a039                	j	80004410 <exec+0x27c>
      last = s+1;
    80004404:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004408:	0785                	addi	a5,a5,1
    8000440a:	fff7c703          	lbu	a4,-1(a5)
    8000440e:	c701                	beqz	a4,80004416 <exec+0x282>
    if(*s == '/')
    80004410:	fed71ce3          	bne	a4,a3,80004408 <exec+0x274>
    80004414:	bfc5                	j	80004404 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004416:	4641                	li	a2,16
    80004418:	df843583          	ld	a1,-520(s0)
    8000441c:	158a8513          	addi	a0,s5,344
    80004420:	ffffc097          	auipc	ra,0xffffc
    80004424:	f7c080e7          	jalr	-132(ra) # 8000039c <safestrcpy>
  oldpagetable = p->pagetable;
    80004428:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000442c:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004430:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004434:	058ab783          	ld	a5,88(s5)
    80004438:	e6843703          	ld	a4,-408(s0)
    8000443c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000443e:	058ab783          	ld	a5,88(s5)
    80004442:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004446:	85ea                	mv	a1,s10
    80004448:	ffffd097          	auipc	ra,0xffffd
    8000444c:	cbc080e7          	jalr	-836(ra) # 80001104 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004450:	0004851b          	sext.w	a0,s1
    80004454:	bbe1                	j	8000422c <exec+0x98>
    80004456:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000445a:	e0843583          	ld	a1,-504(s0)
    8000445e:	855e                	mv	a0,s7
    80004460:	ffffd097          	auipc	ra,0xffffd
    80004464:	ca4080e7          	jalr	-860(ra) # 80001104 <proc_freepagetable>
  if(ip){
    80004468:	da0498e3          	bnez	s1,80004218 <exec+0x84>
  return -1;
    8000446c:	557d                	li	a0,-1
    8000446e:	bb7d                	j	8000422c <exec+0x98>
    80004470:	e1243423          	sd	s2,-504(s0)
    80004474:	b7dd                	j	8000445a <exec+0x2c6>
    80004476:	e1243423          	sd	s2,-504(s0)
    8000447a:	b7c5                	j	8000445a <exec+0x2c6>
    8000447c:	e1243423          	sd	s2,-504(s0)
    80004480:	bfe9                	j	8000445a <exec+0x2c6>
  sz = sz1;
    80004482:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004486:	4481                	li	s1,0
    80004488:	bfc9                	j	8000445a <exec+0x2c6>
  sz = sz1;
    8000448a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000448e:	4481                	li	s1,0
    80004490:	b7e9                	j	8000445a <exec+0x2c6>
  sz = sz1;
    80004492:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004496:	4481                	li	s1,0
    80004498:	b7c9                	j	8000445a <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000449a:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000449e:	2b05                	addiw	s6,s6,1
    800044a0:	0389899b          	addiw	s3,s3,56
    800044a4:	e8845783          	lhu	a5,-376(s0)
    800044a8:	e2fb5be3          	bge	s6,a5,800042de <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044ac:	2981                	sext.w	s3,s3
    800044ae:	03800713          	li	a4,56
    800044b2:	86ce                	mv	a3,s3
    800044b4:	e1840613          	addi	a2,s0,-488
    800044b8:	4581                	li	a1,0
    800044ba:	8526                	mv	a0,s1
    800044bc:	fffff097          	auipc	ra,0xfffff
    800044c0:	a8e080e7          	jalr	-1394(ra) # 80002f4a <readi>
    800044c4:	03800793          	li	a5,56
    800044c8:	f8f517e3          	bne	a0,a5,80004456 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800044cc:	e1842783          	lw	a5,-488(s0)
    800044d0:	4705                	li	a4,1
    800044d2:	fce796e3          	bne	a5,a4,8000449e <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800044d6:	e4043603          	ld	a2,-448(s0)
    800044da:	e3843783          	ld	a5,-456(s0)
    800044de:	f8f669e3          	bltu	a2,a5,80004470 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044e2:	e2843783          	ld	a5,-472(s0)
    800044e6:	963e                	add	a2,a2,a5
    800044e8:	f8f667e3          	bltu	a2,a5,80004476 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800044ec:	85ca                	mv	a1,s2
    800044ee:	855e                	mv	a0,s7
    800044f0:	ffffc097          	auipc	ra,0xffffc
    800044f4:	4be080e7          	jalr	1214(ra) # 800009ae <uvmalloc>
    800044f8:	e0a43423          	sd	a0,-504(s0)
    800044fc:	d141                	beqz	a0,8000447c <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    800044fe:	e2843d03          	ld	s10,-472(s0)
    80004502:	df043783          	ld	a5,-528(s0)
    80004506:	00fd77b3          	and	a5,s10,a5
    8000450a:	fba1                	bnez	a5,8000445a <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000450c:	e2042d83          	lw	s11,-480(s0)
    80004510:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004514:	f80c03e3          	beqz	s8,8000449a <exec+0x306>
    80004518:	8a62                	mv	s4,s8
    8000451a:	4901                	li	s2,0
    8000451c:	b345                	j	800042bc <exec+0x128>

000000008000451e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000451e:	7179                	addi	sp,sp,-48
    80004520:	f406                	sd	ra,40(sp)
    80004522:	f022                	sd	s0,32(sp)
    80004524:	ec26                	sd	s1,24(sp)
    80004526:	e84a                	sd	s2,16(sp)
    80004528:	1800                	addi	s0,sp,48
    8000452a:	892e                	mv	s2,a1
    8000452c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000452e:	fdc40593          	addi	a1,s0,-36
    80004532:	ffffe097          	auipc	ra,0xffffe
    80004536:	bf2080e7          	jalr	-1038(ra) # 80002124 <argint>
    8000453a:	04054063          	bltz	a0,8000457a <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000453e:	fdc42703          	lw	a4,-36(s0)
    80004542:	47bd                	li	a5,15
    80004544:	02e7ed63          	bltu	a5,a4,8000457e <argfd+0x60>
    80004548:	ffffd097          	auipc	ra,0xffffd
    8000454c:	a5c080e7          	jalr	-1444(ra) # 80000fa4 <myproc>
    80004550:	fdc42703          	lw	a4,-36(s0)
    80004554:	01a70793          	addi	a5,a4,26
    80004558:	078e                	slli	a5,a5,0x3
    8000455a:	953e                	add	a0,a0,a5
    8000455c:	611c                	ld	a5,0(a0)
    8000455e:	c395                	beqz	a5,80004582 <argfd+0x64>
    return -1;
  if(pfd)
    80004560:	00090463          	beqz	s2,80004568 <argfd+0x4a>
    *pfd = fd;
    80004564:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004568:	4501                	li	a0,0
  if(pf)
    8000456a:	c091                	beqz	s1,8000456e <argfd+0x50>
    *pf = f;
    8000456c:	e09c                	sd	a5,0(s1)
}
    8000456e:	70a2                	ld	ra,40(sp)
    80004570:	7402                	ld	s0,32(sp)
    80004572:	64e2                	ld	s1,24(sp)
    80004574:	6942                	ld	s2,16(sp)
    80004576:	6145                	addi	sp,sp,48
    80004578:	8082                	ret
    return -1;
    8000457a:	557d                	li	a0,-1
    8000457c:	bfcd                	j	8000456e <argfd+0x50>
    return -1;
    8000457e:	557d                	li	a0,-1
    80004580:	b7fd                	j	8000456e <argfd+0x50>
    80004582:	557d                	li	a0,-1
    80004584:	b7ed                	j	8000456e <argfd+0x50>

0000000080004586 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004586:	1101                	addi	sp,sp,-32
    80004588:	ec06                	sd	ra,24(sp)
    8000458a:	e822                	sd	s0,16(sp)
    8000458c:	e426                	sd	s1,8(sp)
    8000458e:	1000                	addi	s0,sp,32
    80004590:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004592:	ffffd097          	auipc	ra,0xffffd
    80004596:	a12080e7          	jalr	-1518(ra) # 80000fa4 <myproc>
    8000459a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000459c:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffb8e90>
    800045a0:	4501                	li	a0,0
    800045a2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045a4:	6398                	ld	a4,0(a5)
    800045a6:	cb19                	beqz	a4,800045bc <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045a8:	2505                	addiw	a0,a0,1
    800045aa:	07a1                	addi	a5,a5,8
    800045ac:	fed51ce3          	bne	a0,a3,800045a4 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045b0:	557d                	li	a0,-1
}
    800045b2:	60e2                	ld	ra,24(sp)
    800045b4:	6442                	ld	s0,16(sp)
    800045b6:	64a2                	ld	s1,8(sp)
    800045b8:	6105                	addi	sp,sp,32
    800045ba:	8082                	ret
      p->ofile[fd] = f;
    800045bc:	01a50793          	addi	a5,a0,26
    800045c0:	078e                	slli	a5,a5,0x3
    800045c2:	963e                	add	a2,a2,a5
    800045c4:	e204                	sd	s1,0(a2)
      return fd;
    800045c6:	b7f5                	j	800045b2 <fdalloc+0x2c>

00000000800045c8 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045c8:	715d                	addi	sp,sp,-80
    800045ca:	e486                	sd	ra,72(sp)
    800045cc:	e0a2                	sd	s0,64(sp)
    800045ce:	fc26                	sd	s1,56(sp)
    800045d0:	f84a                	sd	s2,48(sp)
    800045d2:	f44e                	sd	s3,40(sp)
    800045d4:	f052                	sd	s4,32(sp)
    800045d6:	ec56                	sd	s5,24(sp)
    800045d8:	0880                	addi	s0,sp,80
    800045da:	89ae                	mv	s3,a1
    800045dc:	8ab2                	mv	s5,a2
    800045de:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045e0:	fb040593          	addi	a1,s0,-80
    800045e4:	fffff097          	auipc	ra,0xfffff
    800045e8:	e86080e7          	jalr	-378(ra) # 8000346a <nameiparent>
    800045ec:	892a                	mv	s2,a0
    800045ee:	12050f63          	beqz	a0,8000472c <create+0x164>
    return 0;

  ilock(dp);
    800045f2:	ffffe097          	auipc	ra,0xffffe
    800045f6:	6a4080e7          	jalr	1700(ra) # 80002c96 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800045fa:	4601                	li	a2,0
    800045fc:	fb040593          	addi	a1,s0,-80
    80004600:	854a                	mv	a0,s2
    80004602:	fffff097          	auipc	ra,0xfffff
    80004606:	b78080e7          	jalr	-1160(ra) # 8000317a <dirlookup>
    8000460a:	84aa                	mv	s1,a0
    8000460c:	c921                	beqz	a0,8000465c <create+0x94>
    iunlockput(dp);
    8000460e:	854a                	mv	a0,s2
    80004610:	fffff097          	auipc	ra,0xfffff
    80004614:	8e8080e7          	jalr	-1816(ra) # 80002ef8 <iunlockput>
    ilock(ip);
    80004618:	8526                	mv	a0,s1
    8000461a:	ffffe097          	auipc	ra,0xffffe
    8000461e:	67c080e7          	jalr	1660(ra) # 80002c96 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004622:	2981                	sext.w	s3,s3
    80004624:	4789                	li	a5,2
    80004626:	02f99463          	bne	s3,a5,8000464e <create+0x86>
    8000462a:	0444d783          	lhu	a5,68(s1)
    8000462e:	37f9                	addiw	a5,a5,-2
    80004630:	17c2                	slli	a5,a5,0x30
    80004632:	93c1                	srli	a5,a5,0x30
    80004634:	4705                	li	a4,1
    80004636:	00f76c63          	bltu	a4,a5,8000464e <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000463a:	8526                	mv	a0,s1
    8000463c:	60a6                	ld	ra,72(sp)
    8000463e:	6406                	ld	s0,64(sp)
    80004640:	74e2                	ld	s1,56(sp)
    80004642:	7942                	ld	s2,48(sp)
    80004644:	79a2                	ld	s3,40(sp)
    80004646:	7a02                	ld	s4,32(sp)
    80004648:	6ae2                	ld	s5,24(sp)
    8000464a:	6161                	addi	sp,sp,80
    8000464c:	8082                	ret
    iunlockput(ip);
    8000464e:	8526                	mv	a0,s1
    80004650:	fffff097          	auipc	ra,0xfffff
    80004654:	8a8080e7          	jalr	-1880(ra) # 80002ef8 <iunlockput>
    return 0;
    80004658:	4481                	li	s1,0
    8000465a:	b7c5                	j	8000463a <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000465c:	85ce                	mv	a1,s3
    8000465e:	00092503          	lw	a0,0(s2)
    80004662:	ffffe097          	auipc	ra,0xffffe
    80004666:	49c080e7          	jalr	1180(ra) # 80002afe <ialloc>
    8000466a:	84aa                	mv	s1,a0
    8000466c:	c529                	beqz	a0,800046b6 <create+0xee>
  ilock(ip);
    8000466e:	ffffe097          	auipc	ra,0xffffe
    80004672:	628080e7          	jalr	1576(ra) # 80002c96 <ilock>
  ip->major = major;
    80004676:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000467a:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000467e:	4785                	li	a5,1
    80004680:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004684:	8526                	mv	a0,s1
    80004686:	ffffe097          	auipc	ra,0xffffe
    8000468a:	546080e7          	jalr	1350(ra) # 80002bcc <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000468e:	2981                	sext.w	s3,s3
    80004690:	4785                	li	a5,1
    80004692:	02f98a63          	beq	s3,a5,800046c6 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004696:	40d0                	lw	a2,4(s1)
    80004698:	fb040593          	addi	a1,s0,-80
    8000469c:	854a                	mv	a0,s2
    8000469e:	fffff097          	auipc	ra,0xfffff
    800046a2:	cec080e7          	jalr	-788(ra) # 8000338a <dirlink>
    800046a6:	06054b63          	bltz	a0,8000471c <create+0x154>
  iunlockput(dp);
    800046aa:	854a                	mv	a0,s2
    800046ac:	fffff097          	auipc	ra,0xfffff
    800046b0:	84c080e7          	jalr	-1972(ra) # 80002ef8 <iunlockput>
  return ip;
    800046b4:	b759                	j	8000463a <create+0x72>
    panic("create: ialloc");
    800046b6:	00004517          	auipc	a0,0x4
    800046ba:	fea50513          	addi	a0,a0,-22 # 800086a0 <syscalls+0x2a0>
    800046be:	00001097          	auipc	ra,0x1
    800046c2:	68a080e7          	jalr	1674(ra) # 80005d48 <panic>
    dp->nlink++;  // for ".."
    800046c6:	04a95783          	lhu	a5,74(s2)
    800046ca:	2785                	addiw	a5,a5,1
    800046cc:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800046d0:	854a                	mv	a0,s2
    800046d2:	ffffe097          	auipc	ra,0xffffe
    800046d6:	4fa080e7          	jalr	1274(ra) # 80002bcc <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046da:	40d0                	lw	a2,4(s1)
    800046dc:	00004597          	auipc	a1,0x4
    800046e0:	fd458593          	addi	a1,a1,-44 # 800086b0 <syscalls+0x2b0>
    800046e4:	8526                	mv	a0,s1
    800046e6:	fffff097          	auipc	ra,0xfffff
    800046ea:	ca4080e7          	jalr	-860(ra) # 8000338a <dirlink>
    800046ee:	00054f63          	bltz	a0,8000470c <create+0x144>
    800046f2:	00492603          	lw	a2,4(s2)
    800046f6:	00004597          	auipc	a1,0x4
    800046fa:	fc258593          	addi	a1,a1,-62 # 800086b8 <syscalls+0x2b8>
    800046fe:	8526                	mv	a0,s1
    80004700:	fffff097          	auipc	ra,0xfffff
    80004704:	c8a080e7          	jalr	-886(ra) # 8000338a <dirlink>
    80004708:	f80557e3          	bgez	a0,80004696 <create+0xce>
      panic("create dots");
    8000470c:	00004517          	auipc	a0,0x4
    80004710:	fb450513          	addi	a0,a0,-76 # 800086c0 <syscalls+0x2c0>
    80004714:	00001097          	auipc	ra,0x1
    80004718:	634080e7          	jalr	1588(ra) # 80005d48 <panic>
    panic("create: dirlink");
    8000471c:	00004517          	auipc	a0,0x4
    80004720:	fb450513          	addi	a0,a0,-76 # 800086d0 <syscalls+0x2d0>
    80004724:	00001097          	auipc	ra,0x1
    80004728:	624080e7          	jalr	1572(ra) # 80005d48 <panic>
    return 0;
    8000472c:	84aa                	mv	s1,a0
    8000472e:	b731                	j	8000463a <create+0x72>

0000000080004730 <sys_dup>:
{
    80004730:	7179                	addi	sp,sp,-48
    80004732:	f406                	sd	ra,40(sp)
    80004734:	f022                	sd	s0,32(sp)
    80004736:	ec26                	sd	s1,24(sp)
    80004738:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000473a:	fd840613          	addi	a2,s0,-40
    8000473e:	4581                	li	a1,0
    80004740:	4501                	li	a0,0
    80004742:	00000097          	auipc	ra,0x0
    80004746:	ddc080e7          	jalr	-548(ra) # 8000451e <argfd>
    return -1;
    8000474a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000474c:	02054363          	bltz	a0,80004772 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004750:	fd843503          	ld	a0,-40(s0)
    80004754:	00000097          	auipc	ra,0x0
    80004758:	e32080e7          	jalr	-462(ra) # 80004586 <fdalloc>
    8000475c:	84aa                	mv	s1,a0
    return -1;
    8000475e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004760:	00054963          	bltz	a0,80004772 <sys_dup+0x42>
  filedup(f);
    80004764:	fd843503          	ld	a0,-40(s0)
    80004768:	fffff097          	auipc	ra,0xfffff
    8000476c:	37a080e7          	jalr	890(ra) # 80003ae2 <filedup>
  return fd;
    80004770:	87a6                	mv	a5,s1
}
    80004772:	853e                	mv	a0,a5
    80004774:	70a2                	ld	ra,40(sp)
    80004776:	7402                	ld	s0,32(sp)
    80004778:	64e2                	ld	s1,24(sp)
    8000477a:	6145                	addi	sp,sp,48
    8000477c:	8082                	ret

000000008000477e <sys_read>:
{
    8000477e:	7179                	addi	sp,sp,-48
    80004780:	f406                	sd	ra,40(sp)
    80004782:	f022                	sd	s0,32(sp)
    80004784:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004786:	fe840613          	addi	a2,s0,-24
    8000478a:	4581                	li	a1,0
    8000478c:	4501                	li	a0,0
    8000478e:	00000097          	auipc	ra,0x0
    80004792:	d90080e7          	jalr	-624(ra) # 8000451e <argfd>
    return -1;
    80004796:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004798:	04054163          	bltz	a0,800047da <sys_read+0x5c>
    8000479c:	fe440593          	addi	a1,s0,-28
    800047a0:	4509                	li	a0,2
    800047a2:	ffffe097          	auipc	ra,0xffffe
    800047a6:	982080e7          	jalr	-1662(ra) # 80002124 <argint>
    return -1;
    800047aa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047ac:	02054763          	bltz	a0,800047da <sys_read+0x5c>
    800047b0:	fd840593          	addi	a1,s0,-40
    800047b4:	4505                	li	a0,1
    800047b6:	ffffe097          	auipc	ra,0xffffe
    800047ba:	990080e7          	jalr	-1648(ra) # 80002146 <argaddr>
    return -1;
    800047be:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047c0:	00054d63          	bltz	a0,800047da <sys_read+0x5c>
  return fileread(f, p, n);
    800047c4:	fe442603          	lw	a2,-28(s0)
    800047c8:	fd843583          	ld	a1,-40(s0)
    800047cc:	fe843503          	ld	a0,-24(s0)
    800047d0:	fffff097          	auipc	ra,0xfffff
    800047d4:	49e080e7          	jalr	1182(ra) # 80003c6e <fileread>
    800047d8:	87aa                	mv	a5,a0
}
    800047da:	853e                	mv	a0,a5
    800047dc:	70a2                	ld	ra,40(sp)
    800047de:	7402                	ld	s0,32(sp)
    800047e0:	6145                	addi	sp,sp,48
    800047e2:	8082                	ret

00000000800047e4 <sys_write>:
{
    800047e4:	7179                	addi	sp,sp,-48
    800047e6:	f406                	sd	ra,40(sp)
    800047e8:	f022                	sd	s0,32(sp)
    800047ea:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047ec:	fe840613          	addi	a2,s0,-24
    800047f0:	4581                	li	a1,0
    800047f2:	4501                	li	a0,0
    800047f4:	00000097          	auipc	ra,0x0
    800047f8:	d2a080e7          	jalr	-726(ra) # 8000451e <argfd>
    return -1;
    800047fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047fe:	04054163          	bltz	a0,80004840 <sys_write+0x5c>
    80004802:	fe440593          	addi	a1,s0,-28
    80004806:	4509                	li	a0,2
    80004808:	ffffe097          	auipc	ra,0xffffe
    8000480c:	91c080e7          	jalr	-1764(ra) # 80002124 <argint>
    return -1;
    80004810:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004812:	02054763          	bltz	a0,80004840 <sys_write+0x5c>
    80004816:	fd840593          	addi	a1,s0,-40
    8000481a:	4505                	li	a0,1
    8000481c:	ffffe097          	auipc	ra,0xffffe
    80004820:	92a080e7          	jalr	-1750(ra) # 80002146 <argaddr>
    return -1;
    80004824:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004826:	00054d63          	bltz	a0,80004840 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000482a:	fe442603          	lw	a2,-28(s0)
    8000482e:	fd843583          	ld	a1,-40(s0)
    80004832:	fe843503          	ld	a0,-24(s0)
    80004836:	fffff097          	auipc	ra,0xfffff
    8000483a:	4fa080e7          	jalr	1274(ra) # 80003d30 <filewrite>
    8000483e:	87aa                	mv	a5,a0
}
    80004840:	853e                	mv	a0,a5
    80004842:	70a2                	ld	ra,40(sp)
    80004844:	7402                	ld	s0,32(sp)
    80004846:	6145                	addi	sp,sp,48
    80004848:	8082                	ret

000000008000484a <sys_close>:
{
    8000484a:	1101                	addi	sp,sp,-32
    8000484c:	ec06                	sd	ra,24(sp)
    8000484e:	e822                	sd	s0,16(sp)
    80004850:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004852:	fe040613          	addi	a2,s0,-32
    80004856:	fec40593          	addi	a1,s0,-20
    8000485a:	4501                	li	a0,0
    8000485c:	00000097          	auipc	ra,0x0
    80004860:	cc2080e7          	jalr	-830(ra) # 8000451e <argfd>
    return -1;
    80004864:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004866:	02054463          	bltz	a0,8000488e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000486a:	ffffc097          	auipc	ra,0xffffc
    8000486e:	73a080e7          	jalr	1850(ra) # 80000fa4 <myproc>
    80004872:	fec42783          	lw	a5,-20(s0)
    80004876:	07e9                	addi	a5,a5,26
    80004878:	078e                	slli	a5,a5,0x3
    8000487a:	97aa                	add	a5,a5,a0
    8000487c:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004880:	fe043503          	ld	a0,-32(s0)
    80004884:	fffff097          	auipc	ra,0xfffff
    80004888:	2b0080e7          	jalr	688(ra) # 80003b34 <fileclose>
  return 0;
    8000488c:	4781                	li	a5,0
}
    8000488e:	853e                	mv	a0,a5
    80004890:	60e2                	ld	ra,24(sp)
    80004892:	6442                	ld	s0,16(sp)
    80004894:	6105                	addi	sp,sp,32
    80004896:	8082                	ret

0000000080004898 <sys_fstat>:
{
    80004898:	1101                	addi	sp,sp,-32
    8000489a:	ec06                	sd	ra,24(sp)
    8000489c:	e822                	sd	s0,16(sp)
    8000489e:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048a0:	fe840613          	addi	a2,s0,-24
    800048a4:	4581                	li	a1,0
    800048a6:	4501                	li	a0,0
    800048a8:	00000097          	auipc	ra,0x0
    800048ac:	c76080e7          	jalr	-906(ra) # 8000451e <argfd>
    return -1;
    800048b0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048b2:	02054563          	bltz	a0,800048dc <sys_fstat+0x44>
    800048b6:	fe040593          	addi	a1,s0,-32
    800048ba:	4505                	li	a0,1
    800048bc:	ffffe097          	auipc	ra,0xffffe
    800048c0:	88a080e7          	jalr	-1910(ra) # 80002146 <argaddr>
    return -1;
    800048c4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048c6:	00054b63          	bltz	a0,800048dc <sys_fstat+0x44>
  return filestat(f, st);
    800048ca:	fe043583          	ld	a1,-32(s0)
    800048ce:	fe843503          	ld	a0,-24(s0)
    800048d2:	fffff097          	auipc	ra,0xfffff
    800048d6:	32a080e7          	jalr	810(ra) # 80003bfc <filestat>
    800048da:	87aa                	mv	a5,a0
}
    800048dc:	853e                	mv	a0,a5
    800048de:	60e2                	ld	ra,24(sp)
    800048e0:	6442                	ld	s0,16(sp)
    800048e2:	6105                	addi	sp,sp,32
    800048e4:	8082                	ret

00000000800048e6 <sys_link>:
{
    800048e6:	7169                	addi	sp,sp,-304
    800048e8:	f606                	sd	ra,296(sp)
    800048ea:	f222                	sd	s0,288(sp)
    800048ec:	ee26                	sd	s1,280(sp)
    800048ee:	ea4a                	sd	s2,272(sp)
    800048f0:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048f2:	08000613          	li	a2,128
    800048f6:	ed040593          	addi	a1,s0,-304
    800048fa:	4501                	li	a0,0
    800048fc:	ffffe097          	auipc	ra,0xffffe
    80004900:	86c080e7          	jalr	-1940(ra) # 80002168 <argstr>
    return -1;
    80004904:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004906:	10054e63          	bltz	a0,80004a22 <sys_link+0x13c>
    8000490a:	08000613          	li	a2,128
    8000490e:	f5040593          	addi	a1,s0,-176
    80004912:	4505                	li	a0,1
    80004914:	ffffe097          	auipc	ra,0xffffe
    80004918:	854080e7          	jalr	-1964(ra) # 80002168 <argstr>
    return -1;
    8000491c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000491e:	10054263          	bltz	a0,80004a22 <sys_link+0x13c>
  begin_op();
    80004922:	fffff097          	auipc	ra,0xfffff
    80004926:	d46080e7          	jalr	-698(ra) # 80003668 <begin_op>
  if((ip = namei(old)) == 0){
    8000492a:	ed040513          	addi	a0,s0,-304
    8000492e:	fffff097          	auipc	ra,0xfffff
    80004932:	b1e080e7          	jalr	-1250(ra) # 8000344c <namei>
    80004936:	84aa                	mv	s1,a0
    80004938:	c551                	beqz	a0,800049c4 <sys_link+0xde>
  ilock(ip);
    8000493a:	ffffe097          	auipc	ra,0xffffe
    8000493e:	35c080e7          	jalr	860(ra) # 80002c96 <ilock>
  if(ip->type == T_DIR){
    80004942:	04449703          	lh	a4,68(s1)
    80004946:	4785                	li	a5,1
    80004948:	08f70463          	beq	a4,a5,800049d0 <sys_link+0xea>
  ip->nlink++;
    8000494c:	04a4d783          	lhu	a5,74(s1)
    80004950:	2785                	addiw	a5,a5,1
    80004952:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004956:	8526                	mv	a0,s1
    80004958:	ffffe097          	auipc	ra,0xffffe
    8000495c:	274080e7          	jalr	628(ra) # 80002bcc <iupdate>
  iunlock(ip);
    80004960:	8526                	mv	a0,s1
    80004962:	ffffe097          	auipc	ra,0xffffe
    80004966:	3f6080e7          	jalr	1014(ra) # 80002d58 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000496a:	fd040593          	addi	a1,s0,-48
    8000496e:	f5040513          	addi	a0,s0,-176
    80004972:	fffff097          	auipc	ra,0xfffff
    80004976:	af8080e7          	jalr	-1288(ra) # 8000346a <nameiparent>
    8000497a:	892a                	mv	s2,a0
    8000497c:	c935                	beqz	a0,800049f0 <sys_link+0x10a>
  ilock(dp);
    8000497e:	ffffe097          	auipc	ra,0xffffe
    80004982:	318080e7          	jalr	792(ra) # 80002c96 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004986:	00092703          	lw	a4,0(s2)
    8000498a:	409c                	lw	a5,0(s1)
    8000498c:	04f71d63          	bne	a4,a5,800049e6 <sys_link+0x100>
    80004990:	40d0                	lw	a2,4(s1)
    80004992:	fd040593          	addi	a1,s0,-48
    80004996:	854a                	mv	a0,s2
    80004998:	fffff097          	auipc	ra,0xfffff
    8000499c:	9f2080e7          	jalr	-1550(ra) # 8000338a <dirlink>
    800049a0:	04054363          	bltz	a0,800049e6 <sys_link+0x100>
  iunlockput(dp);
    800049a4:	854a                	mv	a0,s2
    800049a6:	ffffe097          	auipc	ra,0xffffe
    800049aa:	552080e7          	jalr	1362(ra) # 80002ef8 <iunlockput>
  iput(ip);
    800049ae:	8526                	mv	a0,s1
    800049b0:	ffffe097          	auipc	ra,0xffffe
    800049b4:	4a0080e7          	jalr	1184(ra) # 80002e50 <iput>
  end_op();
    800049b8:	fffff097          	auipc	ra,0xfffff
    800049bc:	d30080e7          	jalr	-720(ra) # 800036e8 <end_op>
  return 0;
    800049c0:	4781                	li	a5,0
    800049c2:	a085                	j	80004a22 <sys_link+0x13c>
    end_op();
    800049c4:	fffff097          	auipc	ra,0xfffff
    800049c8:	d24080e7          	jalr	-732(ra) # 800036e8 <end_op>
    return -1;
    800049cc:	57fd                	li	a5,-1
    800049ce:	a891                	j	80004a22 <sys_link+0x13c>
    iunlockput(ip);
    800049d0:	8526                	mv	a0,s1
    800049d2:	ffffe097          	auipc	ra,0xffffe
    800049d6:	526080e7          	jalr	1318(ra) # 80002ef8 <iunlockput>
    end_op();
    800049da:	fffff097          	auipc	ra,0xfffff
    800049de:	d0e080e7          	jalr	-754(ra) # 800036e8 <end_op>
    return -1;
    800049e2:	57fd                	li	a5,-1
    800049e4:	a83d                	j	80004a22 <sys_link+0x13c>
    iunlockput(dp);
    800049e6:	854a                	mv	a0,s2
    800049e8:	ffffe097          	auipc	ra,0xffffe
    800049ec:	510080e7          	jalr	1296(ra) # 80002ef8 <iunlockput>
  ilock(ip);
    800049f0:	8526                	mv	a0,s1
    800049f2:	ffffe097          	auipc	ra,0xffffe
    800049f6:	2a4080e7          	jalr	676(ra) # 80002c96 <ilock>
  ip->nlink--;
    800049fa:	04a4d783          	lhu	a5,74(s1)
    800049fe:	37fd                	addiw	a5,a5,-1
    80004a00:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a04:	8526                	mv	a0,s1
    80004a06:	ffffe097          	auipc	ra,0xffffe
    80004a0a:	1c6080e7          	jalr	454(ra) # 80002bcc <iupdate>
  iunlockput(ip);
    80004a0e:	8526                	mv	a0,s1
    80004a10:	ffffe097          	auipc	ra,0xffffe
    80004a14:	4e8080e7          	jalr	1256(ra) # 80002ef8 <iunlockput>
  end_op();
    80004a18:	fffff097          	auipc	ra,0xfffff
    80004a1c:	cd0080e7          	jalr	-816(ra) # 800036e8 <end_op>
  return -1;
    80004a20:	57fd                	li	a5,-1
}
    80004a22:	853e                	mv	a0,a5
    80004a24:	70b2                	ld	ra,296(sp)
    80004a26:	7412                	ld	s0,288(sp)
    80004a28:	64f2                	ld	s1,280(sp)
    80004a2a:	6952                	ld	s2,272(sp)
    80004a2c:	6155                	addi	sp,sp,304
    80004a2e:	8082                	ret

0000000080004a30 <sys_unlink>:
{
    80004a30:	7151                	addi	sp,sp,-240
    80004a32:	f586                	sd	ra,232(sp)
    80004a34:	f1a2                	sd	s0,224(sp)
    80004a36:	eda6                	sd	s1,216(sp)
    80004a38:	e9ca                	sd	s2,208(sp)
    80004a3a:	e5ce                	sd	s3,200(sp)
    80004a3c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a3e:	08000613          	li	a2,128
    80004a42:	f3040593          	addi	a1,s0,-208
    80004a46:	4501                	li	a0,0
    80004a48:	ffffd097          	auipc	ra,0xffffd
    80004a4c:	720080e7          	jalr	1824(ra) # 80002168 <argstr>
    80004a50:	18054163          	bltz	a0,80004bd2 <sys_unlink+0x1a2>
  begin_op();
    80004a54:	fffff097          	auipc	ra,0xfffff
    80004a58:	c14080e7          	jalr	-1004(ra) # 80003668 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a5c:	fb040593          	addi	a1,s0,-80
    80004a60:	f3040513          	addi	a0,s0,-208
    80004a64:	fffff097          	auipc	ra,0xfffff
    80004a68:	a06080e7          	jalr	-1530(ra) # 8000346a <nameiparent>
    80004a6c:	84aa                	mv	s1,a0
    80004a6e:	c979                	beqz	a0,80004b44 <sys_unlink+0x114>
  ilock(dp);
    80004a70:	ffffe097          	auipc	ra,0xffffe
    80004a74:	226080e7          	jalr	550(ra) # 80002c96 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a78:	00004597          	auipc	a1,0x4
    80004a7c:	c3858593          	addi	a1,a1,-968 # 800086b0 <syscalls+0x2b0>
    80004a80:	fb040513          	addi	a0,s0,-80
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	6dc080e7          	jalr	1756(ra) # 80003160 <namecmp>
    80004a8c:	14050a63          	beqz	a0,80004be0 <sys_unlink+0x1b0>
    80004a90:	00004597          	auipc	a1,0x4
    80004a94:	c2858593          	addi	a1,a1,-984 # 800086b8 <syscalls+0x2b8>
    80004a98:	fb040513          	addi	a0,s0,-80
    80004a9c:	ffffe097          	auipc	ra,0xffffe
    80004aa0:	6c4080e7          	jalr	1732(ra) # 80003160 <namecmp>
    80004aa4:	12050e63          	beqz	a0,80004be0 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004aa8:	f2c40613          	addi	a2,s0,-212
    80004aac:	fb040593          	addi	a1,s0,-80
    80004ab0:	8526                	mv	a0,s1
    80004ab2:	ffffe097          	auipc	ra,0xffffe
    80004ab6:	6c8080e7          	jalr	1736(ra) # 8000317a <dirlookup>
    80004aba:	892a                	mv	s2,a0
    80004abc:	12050263          	beqz	a0,80004be0 <sys_unlink+0x1b0>
  ilock(ip);
    80004ac0:	ffffe097          	auipc	ra,0xffffe
    80004ac4:	1d6080e7          	jalr	470(ra) # 80002c96 <ilock>
  if(ip->nlink < 1)
    80004ac8:	04a91783          	lh	a5,74(s2)
    80004acc:	08f05263          	blez	a5,80004b50 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ad0:	04491703          	lh	a4,68(s2)
    80004ad4:	4785                	li	a5,1
    80004ad6:	08f70563          	beq	a4,a5,80004b60 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004ada:	4641                	li	a2,16
    80004adc:	4581                	li	a1,0
    80004ade:	fc040513          	addi	a0,s0,-64
    80004ae2:	ffffb097          	auipc	ra,0xffffb
    80004ae6:	768080e7          	jalr	1896(ra) # 8000024a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004aea:	4741                	li	a4,16
    80004aec:	f2c42683          	lw	a3,-212(s0)
    80004af0:	fc040613          	addi	a2,s0,-64
    80004af4:	4581                	li	a1,0
    80004af6:	8526                	mv	a0,s1
    80004af8:	ffffe097          	auipc	ra,0xffffe
    80004afc:	54a080e7          	jalr	1354(ra) # 80003042 <writei>
    80004b00:	47c1                	li	a5,16
    80004b02:	0af51563          	bne	a0,a5,80004bac <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b06:	04491703          	lh	a4,68(s2)
    80004b0a:	4785                	li	a5,1
    80004b0c:	0af70863          	beq	a4,a5,80004bbc <sys_unlink+0x18c>
  iunlockput(dp);
    80004b10:	8526                	mv	a0,s1
    80004b12:	ffffe097          	auipc	ra,0xffffe
    80004b16:	3e6080e7          	jalr	998(ra) # 80002ef8 <iunlockput>
  ip->nlink--;
    80004b1a:	04a95783          	lhu	a5,74(s2)
    80004b1e:	37fd                	addiw	a5,a5,-1
    80004b20:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b24:	854a                	mv	a0,s2
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	0a6080e7          	jalr	166(ra) # 80002bcc <iupdate>
  iunlockput(ip);
    80004b2e:	854a                	mv	a0,s2
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	3c8080e7          	jalr	968(ra) # 80002ef8 <iunlockput>
  end_op();
    80004b38:	fffff097          	auipc	ra,0xfffff
    80004b3c:	bb0080e7          	jalr	-1104(ra) # 800036e8 <end_op>
  return 0;
    80004b40:	4501                	li	a0,0
    80004b42:	a84d                	j	80004bf4 <sys_unlink+0x1c4>
    end_op();
    80004b44:	fffff097          	auipc	ra,0xfffff
    80004b48:	ba4080e7          	jalr	-1116(ra) # 800036e8 <end_op>
    return -1;
    80004b4c:	557d                	li	a0,-1
    80004b4e:	a05d                	j	80004bf4 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b50:	00004517          	auipc	a0,0x4
    80004b54:	b9050513          	addi	a0,a0,-1136 # 800086e0 <syscalls+0x2e0>
    80004b58:	00001097          	auipc	ra,0x1
    80004b5c:	1f0080e7          	jalr	496(ra) # 80005d48 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b60:	04c92703          	lw	a4,76(s2)
    80004b64:	02000793          	li	a5,32
    80004b68:	f6e7f9e3          	bgeu	a5,a4,80004ada <sys_unlink+0xaa>
    80004b6c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b70:	4741                	li	a4,16
    80004b72:	86ce                	mv	a3,s3
    80004b74:	f1840613          	addi	a2,s0,-232
    80004b78:	4581                	li	a1,0
    80004b7a:	854a                	mv	a0,s2
    80004b7c:	ffffe097          	auipc	ra,0xffffe
    80004b80:	3ce080e7          	jalr	974(ra) # 80002f4a <readi>
    80004b84:	47c1                	li	a5,16
    80004b86:	00f51b63          	bne	a0,a5,80004b9c <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b8a:	f1845783          	lhu	a5,-232(s0)
    80004b8e:	e7a1                	bnez	a5,80004bd6 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b90:	29c1                	addiw	s3,s3,16
    80004b92:	04c92783          	lw	a5,76(s2)
    80004b96:	fcf9ede3          	bltu	s3,a5,80004b70 <sys_unlink+0x140>
    80004b9a:	b781                	j	80004ada <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b9c:	00004517          	auipc	a0,0x4
    80004ba0:	b5c50513          	addi	a0,a0,-1188 # 800086f8 <syscalls+0x2f8>
    80004ba4:	00001097          	auipc	ra,0x1
    80004ba8:	1a4080e7          	jalr	420(ra) # 80005d48 <panic>
    panic("unlink: writei");
    80004bac:	00004517          	auipc	a0,0x4
    80004bb0:	b6450513          	addi	a0,a0,-1180 # 80008710 <syscalls+0x310>
    80004bb4:	00001097          	auipc	ra,0x1
    80004bb8:	194080e7          	jalr	404(ra) # 80005d48 <panic>
    dp->nlink--;
    80004bbc:	04a4d783          	lhu	a5,74(s1)
    80004bc0:	37fd                	addiw	a5,a5,-1
    80004bc2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bc6:	8526                	mv	a0,s1
    80004bc8:	ffffe097          	auipc	ra,0xffffe
    80004bcc:	004080e7          	jalr	4(ra) # 80002bcc <iupdate>
    80004bd0:	b781                	j	80004b10 <sys_unlink+0xe0>
    return -1;
    80004bd2:	557d                	li	a0,-1
    80004bd4:	a005                	j	80004bf4 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004bd6:	854a                	mv	a0,s2
    80004bd8:	ffffe097          	auipc	ra,0xffffe
    80004bdc:	320080e7          	jalr	800(ra) # 80002ef8 <iunlockput>
  iunlockput(dp);
    80004be0:	8526                	mv	a0,s1
    80004be2:	ffffe097          	auipc	ra,0xffffe
    80004be6:	316080e7          	jalr	790(ra) # 80002ef8 <iunlockput>
  end_op();
    80004bea:	fffff097          	auipc	ra,0xfffff
    80004bee:	afe080e7          	jalr	-1282(ra) # 800036e8 <end_op>
  return -1;
    80004bf2:	557d                	li	a0,-1
}
    80004bf4:	70ae                	ld	ra,232(sp)
    80004bf6:	740e                	ld	s0,224(sp)
    80004bf8:	64ee                	ld	s1,216(sp)
    80004bfa:	694e                	ld	s2,208(sp)
    80004bfc:	69ae                	ld	s3,200(sp)
    80004bfe:	616d                	addi	sp,sp,240
    80004c00:	8082                	ret

0000000080004c02 <sys_open>:

uint64
sys_open(void)
{
    80004c02:	7131                	addi	sp,sp,-192
    80004c04:	fd06                	sd	ra,184(sp)
    80004c06:	f922                	sd	s0,176(sp)
    80004c08:	f526                	sd	s1,168(sp)
    80004c0a:	f14a                	sd	s2,160(sp)
    80004c0c:	ed4e                	sd	s3,152(sp)
    80004c0e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c10:	08000613          	li	a2,128
    80004c14:	f5040593          	addi	a1,s0,-176
    80004c18:	4501                	li	a0,0
    80004c1a:	ffffd097          	auipc	ra,0xffffd
    80004c1e:	54e080e7          	jalr	1358(ra) # 80002168 <argstr>
    return -1;
    80004c22:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c24:	0c054163          	bltz	a0,80004ce6 <sys_open+0xe4>
    80004c28:	f4c40593          	addi	a1,s0,-180
    80004c2c:	4505                	li	a0,1
    80004c2e:	ffffd097          	auipc	ra,0xffffd
    80004c32:	4f6080e7          	jalr	1270(ra) # 80002124 <argint>
    80004c36:	0a054863          	bltz	a0,80004ce6 <sys_open+0xe4>

  begin_op();
    80004c3a:	fffff097          	auipc	ra,0xfffff
    80004c3e:	a2e080e7          	jalr	-1490(ra) # 80003668 <begin_op>

  if(omode & O_CREATE){
    80004c42:	f4c42783          	lw	a5,-180(s0)
    80004c46:	2007f793          	andi	a5,a5,512
    80004c4a:	cbdd                	beqz	a5,80004d00 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c4c:	4681                	li	a3,0
    80004c4e:	4601                	li	a2,0
    80004c50:	4589                	li	a1,2
    80004c52:	f5040513          	addi	a0,s0,-176
    80004c56:	00000097          	auipc	ra,0x0
    80004c5a:	972080e7          	jalr	-1678(ra) # 800045c8 <create>
    80004c5e:	892a                	mv	s2,a0
    if(ip == 0){
    80004c60:	c959                	beqz	a0,80004cf6 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c62:	04491703          	lh	a4,68(s2)
    80004c66:	478d                	li	a5,3
    80004c68:	00f71763          	bne	a4,a5,80004c76 <sys_open+0x74>
    80004c6c:	04695703          	lhu	a4,70(s2)
    80004c70:	47a5                	li	a5,9
    80004c72:	0ce7ec63          	bltu	a5,a4,80004d4a <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c76:	fffff097          	auipc	ra,0xfffff
    80004c7a:	e02080e7          	jalr	-510(ra) # 80003a78 <filealloc>
    80004c7e:	89aa                	mv	s3,a0
    80004c80:	10050263          	beqz	a0,80004d84 <sys_open+0x182>
    80004c84:	00000097          	auipc	ra,0x0
    80004c88:	902080e7          	jalr	-1790(ra) # 80004586 <fdalloc>
    80004c8c:	84aa                	mv	s1,a0
    80004c8e:	0e054663          	bltz	a0,80004d7a <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c92:	04491703          	lh	a4,68(s2)
    80004c96:	478d                	li	a5,3
    80004c98:	0cf70463          	beq	a4,a5,80004d60 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c9c:	4789                	li	a5,2
    80004c9e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004ca2:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004ca6:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004caa:	f4c42783          	lw	a5,-180(s0)
    80004cae:	0017c713          	xori	a4,a5,1
    80004cb2:	8b05                	andi	a4,a4,1
    80004cb4:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cb8:	0037f713          	andi	a4,a5,3
    80004cbc:	00e03733          	snez	a4,a4
    80004cc0:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cc4:	4007f793          	andi	a5,a5,1024
    80004cc8:	c791                	beqz	a5,80004cd4 <sys_open+0xd2>
    80004cca:	04491703          	lh	a4,68(s2)
    80004cce:	4789                	li	a5,2
    80004cd0:	08f70f63          	beq	a4,a5,80004d6e <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004cd4:	854a                	mv	a0,s2
    80004cd6:	ffffe097          	auipc	ra,0xffffe
    80004cda:	082080e7          	jalr	130(ra) # 80002d58 <iunlock>
  end_op();
    80004cde:	fffff097          	auipc	ra,0xfffff
    80004ce2:	a0a080e7          	jalr	-1526(ra) # 800036e8 <end_op>

  return fd;
}
    80004ce6:	8526                	mv	a0,s1
    80004ce8:	70ea                	ld	ra,184(sp)
    80004cea:	744a                	ld	s0,176(sp)
    80004cec:	74aa                	ld	s1,168(sp)
    80004cee:	790a                	ld	s2,160(sp)
    80004cf0:	69ea                	ld	s3,152(sp)
    80004cf2:	6129                	addi	sp,sp,192
    80004cf4:	8082                	ret
      end_op();
    80004cf6:	fffff097          	auipc	ra,0xfffff
    80004cfa:	9f2080e7          	jalr	-1550(ra) # 800036e8 <end_op>
      return -1;
    80004cfe:	b7e5                	j	80004ce6 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d00:	f5040513          	addi	a0,s0,-176
    80004d04:	ffffe097          	auipc	ra,0xffffe
    80004d08:	748080e7          	jalr	1864(ra) # 8000344c <namei>
    80004d0c:	892a                	mv	s2,a0
    80004d0e:	c905                	beqz	a0,80004d3e <sys_open+0x13c>
    ilock(ip);
    80004d10:	ffffe097          	auipc	ra,0xffffe
    80004d14:	f86080e7          	jalr	-122(ra) # 80002c96 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d18:	04491703          	lh	a4,68(s2)
    80004d1c:	4785                	li	a5,1
    80004d1e:	f4f712e3          	bne	a4,a5,80004c62 <sys_open+0x60>
    80004d22:	f4c42783          	lw	a5,-180(s0)
    80004d26:	dba1                	beqz	a5,80004c76 <sys_open+0x74>
      iunlockput(ip);
    80004d28:	854a                	mv	a0,s2
    80004d2a:	ffffe097          	auipc	ra,0xffffe
    80004d2e:	1ce080e7          	jalr	462(ra) # 80002ef8 <iunlockput>
      end_op();
    80004d32:	fffff097          	auipc	ra,0xfffff
    80004d36:	9b6080e7          	jalr	-1610(ra) # 800036e8 <end_op>
      return -1;
    80004d3a:	54fd                	li	s1,-1
    80004d3c:	b76d                	j	80004ce6 <sys_open+0xe4>
      end_op();
    80004d3e:	fffff097          	auipc	ra,0xfffff
    80004d42:	9aa080e7          	jalr	-1622(ra) # 800036e8 <end_op>
      return -1;
    80004d46:	54fd                	li	s1,-1
    80004d48:	bf79                	j	80004ce6 <sys_open+0xe4>
    iunlockput(ip);
    80004d4a:	854a                	mv	a0,s2
    80004d4c:	ffffe097          	auipc	ra,0xffffe
    80004d50:	1ac080e7          	jalr	428(ra) # 80002ef8 <iunlockput>
    end_op();
    80004d54:	fffff097          	auipc	ra,0xfffff
    80004d58:	994080e7          	jalr	-1644(ra) # 800036e8 <end_op>
    return -1;
    80004d5c:	54fd                	li	s1,-1
    80004d5e:	b761                	j	80004ce6 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d60:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d64:	04691783          	lh	a5,70(s2)
    80004d68:	02f99223          	sh	a5,36(s3)
    80004d6c:	bf2d                	j	80004ca6 <sys_open+0xa4>
    itrunc(ip);
    80004d6e:	854a                	mv	a0,s2
    80004d70:	ffffe097          	auipc	ra,0xffffe
    80004d74:	034080e7          	jalr	52(ra) # 80002da4 <itrunc>
    80004d78:	bfb1                	j	80004cd4 <sys_open+0xd2>
      fileclose(f);
    80004d7a:	854e                	mv	a0,s3
    80004d7c:	fffff097          	auipc	ra,0xfffff
    80004d80:	db8080e7          	jalr	-584(ra) # 80003b34 <fileclose>
    iunlockput(ip);
    80004d84:	854a                	mv	a0,s2
    80004d86:	ffffe097          	auipc	ra,0xffffe
    80004d8a:	172080e7          	jalr	370(ra) # 80002ef8 <iunlockput>
    end_op();
    80004d8e:	fffff097          	auipc	ra,0xfffff
    80004d92:	95a080e7          	jalr	-1702(ra) # 800036e8 <end_op>
    return -1;
    80004d96:	54fd                	li	s1,-1
    80004d98:	b7b9                	j	80004ce6 <sys_open+0xe4>

0000000080004d9a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d9a:	7175                	addi	sp,sp,-144
    80004d9c:	e506                	sd	ra,136(sp)
    80004d9e:	e122                	sd	s0,128(sp)
    80004da0:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004da2:	fffff097          	auipc	ra,0xfffff
    80004da6:	8c6080e7          	jalr	-1850(ra) # 80003668 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004daa:	08000613          	li	a2,128
    80004dae:	f7040593          	addi	a1,s0,-144
    80004db2:	4501                	li	a0,0
    80004db4:	ffffd097          	auipc	ra,0xffffd
    80004db8:	3b4080e7          	jalr	948(ra) # 80002168 <argstr>
    80004dbc:	02054963          	bltz	a0,80004dee <sys_mkdir+0x54>
    80004dc0:	4681                	li	a3,0
    80004dc2:	4601                	li	a2,0
    80004dc4:	4585                	li	a1,1
    80004dc6:	f7040513          	addi	a0,s0,-144
    80004dca:	fffff097          	auipc	ra,0xfffff
    80004dce:	7fe080e7          	jalr	2046(ra) # 800045c8 <create>
    80004dd2:	cd11                	beqz	a0,80004dee <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dd4:	ffffe097          	auipc	ra,0xffffe
    80004dd8:	124080e7          	jalr	292(ra) # 80002ef8 <iunlockput>
  end_op();
    80004ddc:	fffff097          	auipc	ra,0xfffff
    80004de0:	90c080e7          	jalr	-1780(ra) # 800036e8 <end_op>
  return 0;
    80004de4:	4501                	li	a0,0
}
    80004de6:	60aa                	ld	ra,136(sp)
    80004de8:	640a                	ld	s0,128(sp)
    80004dea:	6149                	addi	sp,sp,144
    80004dec:	8082                	ret
    end_op();
    80004dee:	fffff097          	auipc	ra,0xfffff
    80004df2:	8fa080e7          	jalr	-1798(ra) # 800036e8 <end_op>
    return -1;
    80004df6:	557d                	li	a0,-1
    80004df8:	b7fd                	j	80004de6 <sys_mkdir+0x4c>

0000000080004dfa <sys_mknod>:

uint64
sys_mknod(void)
{
    80004dfa:	7135                	addi	sp,sp,-160
    80004dfc:	ed06                	sd	ra,152(sp)
    80004dfe:	e922                	sd	s0,144(sp)
    80004e00:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e02:	fffff097          	auipc	ra,0xfffff
    80004e06:	866080e7          	jalr	-1946(ra) # 80003668 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e0a:	08000613          	li	a2,128
    80004e0e:	f7040593          	addi	a1,s0,-144
    80004e12:	4501                	li	a0,0
    80004e14:	ffffd097          	auipc	ra,0xffffd
    80004e18:	354080e7          	jalr	852(ra) # 80002168 <argstr>
    80004e1c:	04054a63          	bltz	a0,80004e70 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e20:	f6c40593          	addi	a1,s0,-148
    80004e24:	4505                	li	a0,1
    80004e26:	ffffd097          	auipc	ra,0xffffd
    80004e2a:	2fe080e7          	jalr	766(ra) # 80002124 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e2e:	04054163          	bltz	a0,80004e70 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e32:	f6840593          	addi	a1,s0,-152
    80004e36:	4509                	li	a0,2
    80004e38:	ffffd097          	auipc	ra,0xffffd
    80004e3c:	2ec080e7          	jalr	748(ra) # 80002124 <argint>
     argint(1, &major) < 0 ||
    80004e40:	02054863          	bltz	a0,80004e70 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e44:	f6841683          	lh	a3,-152(s0)
    80004e48:	f6c41603          	lh	a2,-148(s0)
    80004e4c:	458d                	li	a1,3
    80004e4e:	f7040513          	addi	a0,s0,-144
    80004e52:	fffff097          	auipc	ra,0xfffff
    80004e56:	776080e7          	jalr	1910(ra) # 800045c8 <create>
     argint(2, &minor) < 0 ||
    80004e5a:	c919                	beqz	a0,80004e70 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e5c:	ffffe097          	auipc	ra,0xffffe
    80004e60:	09c080e7          	jalr	156(ra) # 80002ef8 <iunlockput>
  end_op();
    80004e64:	fffff097          	auipc	ra,0xfffff
    80004e68:	884080e7          	jalr	-1916(ra) # 800036e8 <end_op>
  return 0;
    80004e6c:	4501                	li	a0,0
    80004e6e:	a031                	j	80004e7a <sys_mknod+0x80>
    end_op();
    80004e70:	fffff097          	auipc	ra,0xfffff
    80004e74:	878080e7          	jalr	-1928(ra) # 800036e8 <end_op>
    return -1;
    80004e78:	557d                	li	a0,-1
}
    80004e7a:	60ea                	ld	ra,152(sp)
    80004e7c:	644a                	ld	s0,144(sp)
    80004e7e:	610d                	addi	sp,sp,160
    80004e80:	8082                	ret

0000000080004e82 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e82:	7135                	addi	sp,sp,-160
    80004e84:	ed06                	sd	ra,152(sp)
    80004e86:	e922                	sd	s0,144(sp)
    80004e88:	e526                	sd	s1,136(sp)
    80004e8a:	e14a                	sd	s2,128(sp)
    80004e8c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e8e:	ffffc097          	auipc	ra,0xffffc
    80004e92:	116080e7          	jalr	278(ra) # 80000fa4 <myproc>
    80004e96:	892a                	mv	s2,a0
  
  begin_op();
    80004e98:	ffffe097          	auipc	ra,0xffffe
    80004e9c:	7d0080e7          	jalr	2000(ra) # 80003668 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ea0:	08000613          	li	a2,128
    80004ea4:	f6040593          	addi	a1,s0,-160
    80004ea8:	4501                	li	a0,0
    80004eaa:	ffffd097          	auipc	ra,0xffffd
    80004eae:	2be080e7          	jalr	702(ra) # 80002168 <argstr>
    80004eb2:	04054b63          	bltz	a0,80004f08 <sys_chdir+0x86>
    80004eb6:	f6040513          	addi	a0,s0,-160
    80004eba:	ffffe097          	auipc	ra,0xffffe
    80004ebe:	592080e7          	jalr	1426(ra) # 8000344c <namei>
    80004ec2:	84aa                	mv	s1,a0
    80004ec4:	c131                	beqz	a0,80004f08 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ec6:	ffffe097          	auipc	ra,0xffffe
    80004eca:	dd0080e7          	jalr	-560(ra) # 80002c96 <ilock>
  if(ip->type != T_DIR){
    80004ece:	04449703          	lh	a4,68(s1)
    80004ed2:	4785                	li	a5,1
    80004ed4:	04f71063          	bne	a4,a5,80004f14 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ed8:	8526                	mv	a0,s1
    80004eda:	ffffe097          	auipc	ra,0xffffe
    80004ede:	e7e080e7          	jalr	-386(ra) # 80002d58 <iunlock>
  iput(p->cwd);
    80004ee2:	15093503          	ld	a0,336(s2)
    80004ee6:	ffffe097          	auipc	ra,0xffffe
    80004eea:	f6a080e7          	jalr	-150(ra) # 80002e50 <iput>
  end_op();
    80004eee:	ffffe097          	auipc	ra,0xffffe
    80004ef2:	7fa080e7          	jalr	2042(ra) # 800036e8 <end_op>
  p->cwd = ip;
    80004ef6:	14993823          	sd	s1,336(s2)
  return 0;
    80004efa:	4501                	li	a0,0
}
    80004efc:	60ea                	ld	ra,152(sp)
    80004efe:	644a                	ld	s0,144(sp)
    80004f00:	64aa                	ld	s1,136(sp)
    80004f02:	690a                	ld	s2,128(sp)
    80004f04:	610d                	addi	sp,sp,160
    80004f06:	8082                	ret
    end_op();
    80004f08:	ffffe097          	auipc	ra,0xffffe
    80004f0c:	7e0080e7          	jalr	2016(ra) # 800036e8 <end_op>
    return -1;
    80004f10:	557d                	li	a0,-1
    80004f12:	b7ed                	j	80004efc <sys_chdir+0x7a>
    iunlockput(ip);
    80004f14:	8526                	mv	a0,s1
    80004f16:	ffffe097          	auipc	ra,0xffffe
    80004f1a:	fe2080e7          	jalr	-30(ra) # 80002ef8 <iunlockput>
    end_op();
    80004f1e:	ffffe097          	auipc	ra,0xffffe
    80004f22:	7ca080e7          	jalr	1994(ra) # 800036e8 <end_op>
    return -1;
    80004f26:	557d                	li	a0,-1
    80004f28:	bfd1                	j	80004efc <sys_chdir+0x7a>

0000000080004f2a <sys_exec>:

uint64
sys_exec(void)
{
    80004f2a:	7145                	addi	sp,sp,-464
    80004f2c:	e786                	sd	ra,456(sp)
    80004f2e:	e3a2                	sd	s0,448(sp)
    80004f30:	ff26                	sd	s1,440(sp)
    80004f32:	fb4a                	sd	s2,432(sp)
    80004f34:	f74e                	sd	s3,424(sp)
    80004f36:	f352                	sd	s4,416(sp)
    80004f38:	ef56                	sd	s5,408(sp)
    80004f3a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f3c:	08000613          	li	a2,128
    80004f40:	f4040593          	addi	a1,s0,-192
    80004f44:	4501                	li	a0,0
    80004f46:	ffffd097          	auipc	ra,0xffffd
    80004f4a:	222080e7          	jalr	546(ra) # 80002168 <argstr>
    return -1;
    80004f4e:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f50:	0c054a63          	bltz	a0,80005024 <sys_exec+0xfa>
    80004f54:	e3840593          	addi	a1,s0,-456
    80004f58:	4505                	li	a0,1
    80004f5a:	ffffd097          	auipc	ra,0xffffd
    80004f5e:	1ec080e7          	jalr	492(ra) # 80002146 <argaddr>
    80004f62:	0c054163          	bltz	a0,80005024 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004f66:	10000613          	li	a2,256
    80004f6a:	4581                	li	a1,0
    80004f6c:	e4040513          	addi	a0,s0,-448
    80004f70:	ffffb097          	auipc	ra,0xffffb
    80004f74:	2da080e7          	jalr	730(ra) # 8000024a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f78:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f7c:	89a6                	mv	s3,s1
    80004f7e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f80:	02000a13          	li	s4,32
    80004f84:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f88:	00391513          	slli	a0,s2,0x3
    80004f8c:	e3040593          	addi	a1,s0,-464
    80004f90:	e3843783          	ld	a5,-456(s0)
    80004f94:	953e                	add	a0,a0,a5
    80004f96:	ffffd097          	auipc	ra,0xffffd
    80004f9a:	0f4080e7          	jalr	244(ra) # 8000208a <fetchaddr>
    80004f9e:	02054a63          	bltz	a0,80004fd2 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004fa2:	e3043783          	ld	a5,-464(s0)
    80004fa6:	c3b9                	beqz	a5,80004fec <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fa8:	ffffb097          	auipc	ra,0xffffb
    80004fac:	228080e7          	jalr	552(ra) # 800001d0 <kalloc>
    80004fb0:	85aa                	mv	a1,a0
    80004fb2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fb6:	cd11                	beqz	a0,80004fd2 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fb8:	6605                	lui	a2,0x1
    80004fba:	e3043503          	ld	a0,-464(s0)
    80004fbe:	ffffd097          	auipc	ra,0xffffd
    80004fc2:	11e080e7          	jalr	286(ra) # 800020dc <fetchstr>
    80004fc6:	00054663          	bltz	a0,80004fd2 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004fca:	0905                	addi	s2,s2,1
    80004fcc:	09a1                	addi	s3,s3,8
    80004fce:	fb491be3          	bne	s2,s4,80004f84 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fd2:	10048913          	addi	s2,s1,256
    80004fd6:	6088                	ld	a0,0(s1)
    80004fd8:	c529                	beqz	a0,80005022 <sys_exec+0xf8>
    kfree(argv[i]);
    80004fda:	ffffb097          	auipc	ra,0xffffb
    80004fde:	092080e7          	jalr	146(ra) # 8000006c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fe2:	04a1                	addi	s1,s1,8
    80004fe4:	ff2499e3          	bne	s1,s2,80004fd6 <sys_exec+0xac>
  return -1;
    80004fe8:	597d                	li	s2,-1
    80004fea:	a82d                	j	80005024 <sys_exec+0xfa>
      argv[i] = 0;
    80004fec:	0a8e                	slli	s5,s5,0x3
    80004fee:	fc040793          	addi	a5,s0,-64
    80004ff2:	9abe                	add	s5,s5,a5
    80004ff4:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004ff8:	e4040593          	addi	a1,s0,-448
    80004ffc:	f4040513          	addi	a0,s0,-192
    80005000:	fffff097          	auipc	ra,0xfffff
    80005004:	194080e7          	jalr	404(ra) # 80004194 <exec>
    80005008:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000500a:	10048993          	addi	s3,s1,256
    8000500e:	6088                	ld	a0,0(s1)
    80005010:	c911                	beqz	a0,80005024 <sys_exec+0xfa>
    kfree(argv[i]);
    80005012:	ffffb097          	auipc	ra,0xffffb
    80005016:	05a080e7          	jalr	90(ra) # 8000006c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000501a:	04a1                	addi	s1,s1,8
    8000501c:	ff3499e3          	bne	s1,s3,8000500e <sys_exec+0xe4>
    80005020:	a011                	j	80005024 <sys_exec+0xfa>
  return -1;
    80005022:	597d                	li	s2,-1
}
    80005024:	854a                	mv	a0,s2
    80005026:	60be                	ld	ra,456(sp)
    80005028:	641e                	ld	s0,448(sp)
    8000502a:	74fa                	ld	s1,440(sp)
    8000502c:	795a                	ld	s2,432(sp)
    8000502e:	79ba                	ld	s3,424(sp)
    80005030:	7a1a                	ld	s4,416(sp)
    80005032:	6afa                	ld	s5,408(sp)
    80005034:	6179                	addi	sp,sp,464
    80005036:	8082                	ret

0000000080005038 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005038:	7139                	addi	sp,sp,-64
    8000503a:	fc06                	sd	ra,56(sp)
    8000503c:	f822                	sd	s0,48(sp)
    8000503e:	f426                	sd	s1,40(sp)
    80005040:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005042:	ffffc097          	auipc	ra,0xffffc
    80005046:	f62080e7          	jalr	-158(ra) # 80000fa4 <myproc>
    8000504a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000504c:	fd840593          	addi	a1,s0,-40
    80005050:	4501                	li	a0,0
    80005052:	ffffd097          	auipc	ra,0xffffd
    80005056:	0f4080e7          	jalr	244(ra) # 80002146 <argaddr>
    return -1;
    8000505a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000505c:	0e054063          	bltz	a0,8000513c <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005060:	fc840593          	addi	a1,s0,-56
    80005064:	fd040513          	addi	a0,s0,-48
    80005068:	fffff097          	auipc	ra,0xfffff
    8000506c:	dfc080e7          	jalr	-516(ra) # 80003e64 <pipealloc>
    return -1;
    80005070:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005072:	0c054563          	bltz	a0,8000513c <sys_pipe+0x104>
  fd0 = -1;
    80005076:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000507a:	fd043503          	ld	a0,-48(s0)
    8000507e:	fffff097          	auipc	ra,0xfffff
    80005082:	508080e7          	jalr	1288(ra) # 80004586 <fdalloc>
    80005086:	fca42223          	sw	a0,-60(s0)
    8000508a:	08054c63          	bltz	a0,80005122 <sys_pipe+0xea>
    8000508e:	fc843503          	ld	a0,-56(s0)
    80005092:	fffff097          	auipc	ra,0xfffff
    80005096:	4f4080e7          	jalr	1268(ra) # 80004586 <fdalloc>
    8000509a:	fca42023          	sw	a0,-64(s0)
    8000509e:	06054863          	bltz	a0,8000510e <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050a2:	4691                	li	a3,4
    800050a4:	fc440613          	addi	a2,s0,-60
    800050a8:	fd843583          	ld	a1,-40(s0)
    800050ac:	68a8                	ld	a0,80(s1)
    800050ae:	ffffc097          	auipc	ra,0xffffc
    800050b2:	b3e080e7          	jalr	-1218(ra) # 80000bec <copyout>
    800050b6:	02054063          	bltz	a0,800050d6 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050ba:	4691                	li	a3,4
    800050bc:	fc040613          	addi	a2,s0,-64
    800050c0:	fd843583          	ld	a1,-40(s0)
    800050c4:	0591                	addi	a1,a1,4
    800050c6:	68a8                	ld	a0,80(s1)
    800050c8:	ffffc097          	auipc	ra,0xffffc
    800050cc:	b24080e7          	jalr	-1244(ra) # 80000bec <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050d0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050d2:	06055563          	bgez	a0,8000513c <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800050d6:	fc442783          	lw	a5,-60(s0)
    800050da:	07e9                	addi	a5,a5,26
    800050dc:	078e                	slli	a5,a5,0x3
    800050de:	97a6                	add	a5,a5,s1
    800050e0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050e4:	fc042503          	lw	a0,-64(s0)
    800050e8:	0569                	addi	a0,a0,26
    800050ea:	050e                	slli	a0,a0,0x3
    800050ec:	9526                	add	a0,a0,s1
    800050ee:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800050f2:	fd043503          	ld	a0,-48(s0)
    800050f6:	fffff097          	auipc	ra,0xfffff
    800050fa:	a3e080e7          	jalr	-1474(ra) # 80003b34 <fileclose>
    fileclose(wf);
    800050fe:	fc843503          	ld	a0,-56(s0)
    80005102:	fffff097          	auipc	ra,0xfffff
    80005106:	a32080e7          	jalr	-1486(ra) # 80003b34 <fileclose>
    return -1;
    8000510a:	57fd                	li	a5,-1
    8000510c:	a805                	j	8000513c <sys_pipe+0x104>
    if(fd0 >= 0)
    8000510e:	fc442783          	lw	a5,-60(s0)
    80005112:	0007c863          	bltz	a5,80005122 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005116:	01a78513          	addi	a0,a5,26
    8000511a:	050e                	slli	a0,a0,0x3
    8000511c:	9526                	add	a0,a0,s1
    8000511e:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005122:	fd043503          	ld	a0,-48(s0)
    80005126:	fffff097          	auipc	ra,0xfffff
    8000512a:	a0e080e7          	jalr	-1522(ra) # 80003b34 <fileclose>
    fileclose(wf);
    8000512e:	fc843503          	ld	a0,-56(s0)
    80005132:	fffff097          	auipc	ra,0xfffff
    80005136:	a02080e7          	jalr	-1534(ra) # 80003b34 <fileclose>
    return -1;
    8000513a:	57fd                	li	a5,-1
}
    8000513c:	853e                	mv	a0,a5
    8000513e:	70e2                	ld	ra,56(sp)
    80005140:	7442                	ld	s0,48(sp)
    80005142:	74a2                	ld	s1,40(sp)
    80005144:	6121                	addi	sp,sp,64
    80005146:	8082                	ret
	...

0000000080005150 <kernelvec>:
    80005150:	7111                	addi	sp,sp,-256
    80005152:	e006                	sd	ra,0(sp)
    80005154:	e40a                	sd	sp,8(sp)
    80005156:	e80e                	sd	gp,16(sp)
    80005158:	ec12                	sd	tp,24(sp)
    8000515a:	f016                	sd	t0,32(sp)
    8000515c:	f41a                	sd	t1,40(sp)
    8000515e:	f81e                	sd	t2,48(sp)
    80005160:	fc22                	sd	s0,56(sp)
    80005162:	e0a6                	sd	s1,64(sp)
    80005164:	e4aa                	sd	a0,72(sp)
    80005166:	e8ae                	sd	a1,80(sp)
    80005168:	ecb2                	sd	a2,88(sp)
    8000516a:	f0b6                	sd	a3,96(sp)
    8000516c:	f4ba                	sd	a4,104(sp)
    8000516e:	f8be                	sd	a5,112(sp)
    80005170:	fcc2                	sd	a6,120(sp)
    80005172:	e146                	sd	a7,128(sp)
    80005174:	e54a                	sd	s2,136(sp)
    80005176:	e94e                	sd	s3,144(sp)
    80005178:	ed52                	sd	s4,152(sp)
    8000517a:	f156                	sd	s5,160(sp)
    8000517c:	f55a                	sd	s6,168(sp)
    8000517e:	f95e                	sd	s7,176(sp)
    80005180:	fd62                	sd	s8,184(sp)
    80005182:	e1e6                	sd	s9,192(sp)
    80005184:	e5ea                	sd	s10,200(sp)
    80005186:	e9ee                	sd	s11,208(sp)
    80005188:	edf2                	sd	t3,216(sp)
    8000518a:	f1f6                	sd	t4,224(sp)
    8000518c:	f5fa                	sd	t5,232(sp)
    8000518e:	f9fe                	sd	t6,240(sp)
    80005190:	dc7fc0ef          	jal	ra,80001f56 <kerneltrap>
    80005194:	6082                	ld	ra,0(sp)
    80005196:	6122                	ld	sp,8(sp)
    80005198:	61c2                	ld	gp,16(sp)
    8000519a:	7282                	ld	t0,32(sp)
    8000519c:	7322                	ld	t1,40(sp)
    8000519e:	73c2                	ld	t2,48(sp)
    800051a0:	7462                	ld	s0,56(sp)
    800051a2:	6486                	ld	s1,64(sp)
    800051a4:	6526                	ld	a0,72(sp)
    800051a6:	65c6                	ld	a1,80(sp)
    800051a8:	6666                	ld	a2,88(sp)
    800051aa:	7686                	ld	a3,96(sp)
    800051ac:	7726                	ld	a4,104(sp)
    800051ae:	77c6                	ld	a5,112(sp)
    800051b0:	7866                	ld	a6,120(sp)
    800051b2:	688a                	ld	a7,128(sp)
    800051b4:	692a                	ld	s2,136(sp)
    800051b6:	69ca                	ld	s3,144(sp)
    800051b8:	6a6a                	ld	s4,152(sp)
    800051ba:	7a8a                	ld	s5,160(sp)
    800051bc:	7b2a                	ld	s6,168(sp)
    800051be:	7bca                	ld	s7,176(sp)
    800051c0:	7c6a                	ld	s8,184(sp)
    800051c2:	6c8e                	ld	s9,192(sp)
    800051c4:	6d2e                	ld	s10,200(sp)
    800051c6:	6dce                	ld	s11,208(sp)
    800051c8:	6e6e                	ld	t3,216(sp)
    800051ca:	7e8e                	ld	t4,224(sp)
    800051cc:	7f2e                	ld	t5,232(sp)
    800051ce:	7fce                	ld	t6,240(sp)
    800051d0:	6111                	addi	sp,sp,256
    800051d2:	10200073          	sret
    800051d6:	00000013          	nop
    800051da:	00000013          	nop
    800051de:	0001                	nop

00000000800051e0 <timervec>:
    800051e0:	34051573          	csrrw	a0,mscratch,a0
    800051e4:	e10c                	sd	a1,0(a0)
    800051e6:	e510                	sd	a2,8(a0)
    800051e8:	e914                	sd	a3,16(a0)
    800051ea:	6d0c                	ld	a1,24(a0)
    800051ec:	7110                	ld	a2,32(a0)
    800051ee:	6194                	ld	a3,0(a1)
    800051f0:	96b2                	add	a3,a3,a2
    800051f2:	e194                	sd	a3,0(a1)
    800051f4:	4589                	li	a1,2
    800051f6:	14459073          	csrw	sip,a1
    800051fa:	6914                	ld	a3,16(a0)
    800051fc:	6510                	ld	a2,8(a0)
    800051fe:	610c                	ld	a1,0(a0)
    80005200:	34051573          	csrrw	a0,mscratch,a0
    80005204:	30200073          	mret
	...

000000008000520a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000520a:	1141                	addi	sp,sp,-16
    8000520c:	e422                	sd	s0,8(sp)
    8000520e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005210:	0c0007b7          	lui	a5,0xc000
    80005214:	4705                	li	a4,1
    80005216:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005218:	c3d8                	sw	a4,4(a5)
}
    8000521a:	6422                	ld	s0,8(sp)
    8000521c:	0141                	addi	sp,sp,16
    8000521e:	8082                	ret

0000000080005220 <plicinithart>:

void
plicinithart(void)
{
    80005220:	1141                	addi	sp,sp,-16
    80005222:	e406                	sd	ra,8(sp)
    80005224:	e022                	sd	s0,0(sp)
    80005226:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005228:	ffffc097          	auipc	ra,0xffffc
    8000522c:	d50080e7          	jalr	-688(ra) # 80000f78 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005230:	0085171b          	slliw	a4,a0,0x8
    80005234:	0c0027b7          	lui	a5,0xc002
    80005238:	97ba                	add	a5,a5,a4
    8000523a:	40200713          	li	a4,1026
    8000523e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005242:	00d5151b          	slliw	a0,a0,0xd
    80005246:	0c2017b7          	lui	a5,0xc201
    8000524a:	953e                	add	a0,a0,a5
    8000524c:	00052023          	sw	zero,0(a0)
}
    80005250:	60a2                	ld	ra,8(sp)
    80005252:	6402                	ld	s0,0(sp)
    80005254:	0141                	addi	sp,sp,16
    80005256:	8082                	ret

0000000080005258 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005258:	1141                	addi	sp,sp,-16
    8000525a:	e406                	sd	ra,8(sp)
    8000525c:	e022                	sd	s0,0(sp)
    8000525e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005260:	ffffc097          	auipc	ra,0xffffc
    80005264:	d18080e7          	jalr	-744(ra) # 80000f78 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005268:	00d5179b          	slliw	a5,a0,0xd
    8000526c:	0c201537          	lui	a0,0xc201
    80005270:	953e                	add	a0,a0,a5
  return irq;
}
    80005272:	4148                	lw	a0,4(a0)
    80005274:	60a2                	ld	ra,8(sp)
    80005276:	6402                	ld	s0,0(sp)
    80005278:	0141                	addi	sp,sp,16
    8000527a:	8082                	ret

000000008000527c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000527c:	1101                	addi	sp,sp,-32
    8000527e:	ec06                	sd	ra,24(sp)
    80005280:	e822                	sd	s0,16(sp)
    80005282:	e426                	sd	s1,8(sp)
    80005284:	1000                	addi	s0,sp,32
    80005286:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005288:	ffffc097          	auipc	ra,0xffffc
    8000528c:	cf0080e7          	jalr	-784(ra) # 80000f78 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005290:	00d5151b          	slliw	a0,a0,0xd
    80005294:	0c2017b7          	lui	a5,0xc201
    80005298:	97aa                	add	a5,a5,a0
    8000529a:	c3c4                	sw	s1,4(a5)
}
    8000529c:	60e2                	ld	ra,24(sp)
    8000529e:	6442                	ld	s0,16(sp)
    800052a0:	64a2                	ld	s1,8(sp)
    800052a2:	6105                	addi	sp,sp,32
    800052a4:	8082                	ret

00000000800052a6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052a6:	1141                	addi	sp,sp,-16
    800052a8:	e406                	sd	ra,8(sp)
    800052aa:	e022                	sd	s0,0(sp)
    800052ac:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052ae:	479d                	li	a5,7
    800052b0:	06a7c963          	blt	a5,a0,80005322 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800052b4:	00036797          	auipc	a5,0x36
    800052b8:	d4c78793          	addi	a5,a5,-692 # 8003b000 <disk>
    800052bc:	00a78733          	add	a4,a5,a0
    800052c0:	6789                	lui	a5,0x2
    800052c2:	97ba                	add	a5,a5,a4
    800052c4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800052c8:	e7ad                	bnez	a5,80005332 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052ca:	00451793          	slli	a5,a0,0x4
    800052ce:	00038717          	auipc	a4,0x38
    800052d2:	d3270713          	addi	a4,a4,-718 # 8003d000 <disk+0x2000>
    800052d6:	6314                	ld	a3,0(a4)
    800052d8:	96be                	add	a3,a3,a5
    800052da:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800052de:	6314                	ld	a3,0(a4)
    800052e0:	96be                	add	a3,a3,a5
    800052e2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800052e6:	6314                	ld	a3,0(a4)
    800052e8:	96be                	add	a3,a3,a5
    800052ea:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800052ee:	6318                	ld	a4,0(a4)
    800052f0:	97ba                	add	a5,a5,a4
    800052f2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800052f6:	00036797          	auipc	a5,0x36
    800052fa:	d0a78793          	addi	a5,a5,-758 # 8003b000 <disk>
    800052fe:	97aa                	add	a5,a5,a0
    80005300:	6509                	lui	a0,0x2
    80005302:	953e                	add	a0,a0,a5
    80005304:	4785                	li	a5,1
    80005306:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000530a:	00038517          	auipc	a0,0x38
    8000530e:	d0e50513          	addi	a0,a0,-754 # 8003d018 <disk+0x2018>
    80005312:	ffffc097          	auipc	ra,0xffffc
    80005316:	4da080e7          	jalr	1242(ra) # 800017ec <wakeup>
}
    8000531a:	60a2                	ld	ra,8(sp)
    8000531c:	6402                	ld	s0,0(sp)
    8000531e:	0141                	addi	sp,sp,16
    80005320:	8082                	ret
    panic("free_desc 1");
    80005322:	00003517          	auipc	a0,0x3
    80005326:	3fe50513          	addi	a0,a0,1022 # 80008720 <syscalls+0x320>
    8000532a:	00001097          	auipc	ra,0x1
    8000532e:	a1e080e7          	jalr	-1506(ra) # 80005d48 <panic>
    panic("free_desc 2");
    80005332:	00003517          	auipc	a0,0x3
    80005336:	3fe50513          	addi	a0,a0,1022 # 80008730 <syscalls+0x330>
    8000533a:	00001097          	auipc	ra,0x1
    8000533e:	a0e080e7          	jalr	-1522(ra) # 80005d48 <panic>

0000000080005342 <virtio_disk_init>:
{
    80005342:	1101                	addi	sp,sp,-32
    80005344:	ec06                	sd	ra,24(sp)
    80005346:	e822                	sd	s0,16(sp)
    80005348:	e426                	sd	s1,8(sp)
    8000534a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000534c:	00003597          	auipc	a1,0x3
    80005350:	3f458593          	addi	a1,a1,1012 # 80008740 <syscalls+0x340>
    80005354:	00038517          	auipc	a0,0x38
    80005358:	dd450513          	addi	a0,a0,-556 # 8003d128 <disk+0x2128>
    8000535c:	00001097          	auipc	ra,0x1
    80005360:	ea6080e7          	jalr	-346(ra) # 80006202 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005364:	100017b7          	lui	a5,0x10001
    80005368:	4398                	lw	a4,0(a5)
    8000536a:	2701                	sext.w	a4,a4
    8000536c:	747277b7          	lui	a5,0x74727
    80005370:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005374:	0ef71163          	bne	a4,a5,80005456 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005378:	100017b7          	lui	a5,0x10001
    8000537c:	43dc                	lw	a5,4(a5)
    8000537e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005380:	4705                	li	a4,1
    80005382:	0ce79a63          	bne	a5,a4,80005456 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005386:	100017b7          	lui	a5,0x10001
    8000538a:	479c                	lw	a5,8(a5)
    8000538c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000538e:	4709                	li	a4,2
    80005390:	0ce79363          	bne	a5,a4,80005456 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005394:	100017b7          	lui	a5,0x10001
    80005398:	47d8                	lw	a4,12(a5)
    8000539a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000539c:	554d47b7          	lui	a5,0x554d4
    800053a0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053a4:	0af71963          	bne	a4,a5,80005456 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053a8:	100017b7          	lui	a5,0x10001
    800053ac:	4705                	li	a4,1
    800053ae:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053b0:	470d                	li	a4,3
    800053b2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053b4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053b6:	c7ffe737          	lui	a4,0xc7ffe
    800053ba:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fb851f>
    800053be:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053c0:	2701                	sext.w	a4,a4
    800053c2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053c4:	472d                	li	a4,11
    800053c6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053c8:	473d                	li	a4,15
    800053ca:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800053cc:	6705                	lui	a4,0x1
    800053ce:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053d0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053d4:	5bdc                	lw	a5,52(a5)
    800053d6:	2781                	sext.w	a5,a5
  if(max == 0)
    800053d8:	c7d9                	beqz	a5,80005466 <virtio_disk_init+0x124>
  if(max < NUM)
    800053da:	471d                	li	a4,7
    800053dc:	08f77d63          	bgeu	a4,a5,80005476 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053e0:	100014b7          	lui	s1,0x10001
    800053e4:	47a1                	li	a5,8
    800053e6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800053e8:	6609                	lui	a2,0x2
    800053ea:	4581                	li	a1,0
    800053ec:	00036517          	auipc	a0,0x36
    800053f0:	c1450513          	addi	a0,a0,-1004 # 8003b000 <disk>
    800053f4:	ffffb097          	auipc	ra,0xffffb
    800053f8:	e56080e7          	jalr	-426(ra) # 8000024a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800053fc:	00036717          	auipc	a4,0x36
    80005400:	c0470713          	addi	a4,a4,-1020 # 8003b000 <disk>
    80005404:	00c75793          	srli	a5,a4,0xc
    80005408:	2781                	sext.w	a5,a5
    8000540a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000540c:	00038797          	auipc	a5,0x38
    80005410:	bf478793          	addi	a5,a5,-1036 # 8003d000 <disk+0x2000>
    80005414:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005416:	00036717          	auipc	a4,0x36
    8000541a:	c6a70713          	addi	a4,a4,-918 # 8003b080 <disk+0x80>
    8000541e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005420:	00037717          	auipc	a4,0x37
    80005424:	be070713          	addi	a4,a4,-1056 # 8003c000 <disk+0x1000>
    80005428:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000542a:	4705                	li	a4,1
    8000542c:	00e78c23          	sb	a4,24(a5)
    80005430:	00e78ca3          	sb	a4,25(a5)
    80005434:	00e78d23          	sb	a4,26(a5)
    80005438:	00e78da3          	sb	a4,27(a5)
    8000543c:	00e78e23          	sb	a4,28(a5)
    80005440:	00e78ea3          	sb	a4,29(a5)
    80005444:	00e78f23          	sb	a4,30(a5)
    80005448:	00e78fa3          	sb	a4,31(a5)
}
    8000544c:	60e2                	ld	ra,24(sp)
    8000544e:	6442                	ld	s0,16(sp)
    80005450:	64a2                	ld	s1,8(sp)
    80005452:	6105                	addi	sp,sp,32
    80005454:	8082                	ret
    panic("could not find virtio disk");
    80005456:	00003517          	auipc	a0,0x3
    8000545a:	2fa50513          	addi	a0,a0,762 # 80008750 <syscalls+0x350>
    8000545e:	00001097          	auipc	ra,0x1
    80005462:	8ea080e7          	jalr	-1814(ra) # 80005d48 <panic>
    panic("virtio disk has no queue 0");
    80005466:	00003517          	auipc	a0,0x3
    8000546a:	30a50513          	addi	a0,a0,778 # 80008770 <syscalls+0x370>
    8000546e:	00001097          	auipc	ra,0x1
    80005472:	8da080e7          	jalr	-1830(ra) # 80005d48 <panic>
    panic("virtio disk max queue too short");
    80005476:	00003517          	auipc	a0,0x3
    8000547a:	31a50513          	addi	a0,a0,794 # 80008790 <syscalls+0x390>
    8000547e:	00001097          	auipc	ra,0x1
    80005482:	8ca080e7          	jalr	-1846(ra) # 80005d48 <panic>

0000000080005486 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005486:	7159                	addi	sp,sp,-112
    80005488:	f486                	sd	ra,104(sp)
    8000548a:	f0a2                	sd	s0,96(sp)
    8000548c:	eca6                	sd	s1,88(sp)
    8000548e:	e8ca                	sd	s2,80(sp)
    80005490:	e4ce                	sd	s3,72(sp)
    80005492:	e0d2                	sd	s4,64(sp)
    80005494:	fc56                	sd	s5,56(sp)
    80005496:	f85a                	sd	s6,48(sp)
    80005498:	f45e                	sd	s7,40(sp)
    8000549a:	f062                	sd	s8,32(sp)
    8000549c:	ec66                	sd	s9,24(sp)
    8000549e:	e86a                	sd	s10,16(sp)
    800054a0:	1880                	addi	s0,sp,112
    800054a2:	892a                	mv	s2,a0
    800054a4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054a6:	00c52c83          	lw	s9,12(a0)
    800054aa:	001c9c9b          	slliw	s9,s9,0x1
    800054ae:	1c82                	slli	s9,s9,0x20
    800054b0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800054b4:	00038517          	auipc	a0,0x38
    800054b8:	c7450513          	addi	a0,a0,-908 # 8003d128 <disk+0x2128>
    800054bc:	00001097          	auipc	ra,0x1
    800054c0:	dd6080e7          	jalr	-554(ra) # 80006292 <acquire>
  for(int i = 0; i < 3; i++){
    800054c4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800054c6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800054c8:	00036b97          	auipc	s7,0x36
    800054cc:	b38b8b93          	addi	s7,s7,-1224 # 8003b000 <disk>
    800054d0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800054d2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800054d4:	8a4e                	mv	s4,s3
    800054d6:	a051                	j	8000555a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800054d8:	00fb86b3          	add	a3,s7,a5
    800054dc:	96da                	add	a3,a3,s6
    800054de:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800054e2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800054e4:	0207c563          	bltz	a5,8000550e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800054e8:	2485                	addiw	s1,s1,1
    800054ea:	0711                	addi	a4,a4,4
    800054ec:	25548063          	beq	s1,s5,8000572c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800054f0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800054f2:	00038697          	auipc	a3,0x38
    800054f6:	b2668693          	addi	a3,a3,-1242 # 8003d018 <disk+0x2018>
    800054fa:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800054fc:	0006c583          	lbu	a1,0(a3)
    80005500:	fde1                	bnez	a1,800054d8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005502:	2785                	addiw	a5,a5,1
    80005504:	0685                	addi	a3,a3,1
    80005506:	ff879be3          	bne	a5,s8,800054fc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000550a:	57fd                	li	a5,-1
    8000550c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000550e:	02905a63          	blez	s1,80005542 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005512:	f9042503          	lw	a0,-112(s0)
    80005516:	00000097          	auipc	ra,0x0
    8000551a:	d90080e7          	jalr	-624(ra) # 800052a6 <free_desc>
      for(int j = 0; j < i; j++)
    8000551e:	4785                	li	a5,1
    80005520:	0297d163          	bge	a5,s1,80005542 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005524:	f9442503          	lw	a0,-108(s0)
    80005528:	00000097          	auipc	ra,0x0
    8000552c:	d7e080e7          	jalr	-642(ra) # 800052a6 <free_desc>
      for(int j = 0; j < i; j++)
    80005530:	4789                	li	a5,2
    80005532:	0097d863          	bge	a5,s1,80005542 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005536:	f9842503          	lw	a0,-104(s0)
    8000553a:	00000097          	auipc	ra,0x0
    8000553e:	d6c080e7          	jalr	-660(ra) # 800052a6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005542:	00038597          	auipc	a1,0x38
    80005546:	be658593          	addi	a1,a1,-1050 # 8003d128 <disk+0x2128>
    8000554a:	00038517          	auipc	a0,0x38
    8000554e:	ace50513          	addi	a0,a0,-1330 # 8003d018 <disk+0x2018>
    80005552:	ffffc097          	auipc	ra,0xffffc
    80005556:	10e080e7          	jalr	270(ra) # 80001660 <sleep>
  for(int i = 0; i < 3; i++){
    8000555a:	f9040713          	addi	a4,s0,-112
    8000555e:	84ce                	mv	s1,s3
    80005560:	bf41                	j	800054f0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005562:	20058713          	addi	a4,a1,512
    80005566:	00471693          	slli	a3,a4,0x4
    8000556a:	00036717          	auipc	a4,0x36
    8000556e:	a9670713          	addi	a4,a4,-1386 # 8003b000 <disk>
    80005572:	9736                	add	a4,a4,a3
    80005574:	4685                	li	a3,1
    80005576:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000557a:	20058713          	addi	a4,a1,512
    8000557e:	00471693          	slli	a3,a4,0x4
    80005582:	00036717          	auipc	a4,0x36
    80005586:	a7e70713          	addi	a4,a4,-1410 # 8003b000 <disk>
    8000558a:	9736                	add	a4,a4,a3
    8000558c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005590:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005594:	7679                	lui	a2,0xffffe
    80005596:	963e                	add	a2,a2,a5
    80005598:	00038697          	auipc	a3,0x38
    8000559c:	a6868693          	addi	a3,a3,-1432 # 8003d000 <disk+0x2000>
    800055a0:	6298                	ld	a4,0(a3)
    800055a2:	9732                	add	a4,a4,a2
    800055a4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055a6:	6298                	ld	a4,0(a3)
    800055a8:	9732                	add	a4,a4,a2
    800055aa:	4541                	li	a0,16
    800055ac:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055ae:	6298                	ld	a4,0(a3)
    800055b0:	9732                	add	a4,a4,a2
    800055b2:	4505                	li	a0,1
    800055b4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800055b8:	f9442703          	lw	a4,-108(s0)
    800055bc:	6288                	ld	a0,0(a3)
    800055be:	962a                	add	a2,a2,a0
    800055c0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffb7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800055c4:	0712                	slli	a4,a4,0x4
    800055c6:	6290                	ld	a2,0(a3)
    800055c8:	963a                	add	a2,a2,a4
    800055ca:	05890513          	addi	a0,s2,88
    800055ce:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800055d0:	6294                	ld	a3,0(a3)
    800055d2:	96ba                	add	a3,a3,a4
    800055d4:	40000613          	li	a2,1024
    800055d8:	c690                	sw	a2,8(a3)
  if(write)
    800055da:	140d0063          	beqz	s10,8000571a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055de:	00038697          	auipc	a3,0x38
    800055e2:	a226b683          	ld	a3,-1502(a3) # 8003d000 <disk+0x2000>
    800055e6:	96ba                	add	a3,a3,a4
    800055e8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055ec:	00036817          	auipc	a6,0x36
    800055f0:	a1480813          	addi	a6,a6,-1516 # 8003b000 <disk>
    800055f4:	00038517          	auipc	a0,0x38
    800055f8:	a0c50513          	addi	a0,a0,-1524 # 8003d000 <disk+0x2000>
    800055fc:	6114                	ld	a3,0(a0)
    800055fe:	96ba                	add	a3,a3,a4
    80005600:	00c6d603          	lhu	a2,12(a3)
    80005604:	00166613          	ori	a2,a2,1
    80005608:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000560c:	f9842683          	lw	a3,-104(s0)
    80005610:	6110                	ld	a2,0(a0)
    80005612:	9732                	add	a4,a4,a2
    80005614:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005618:	20058613          	addi	a2,a1,512
    8000561c:	0612                	slli	a2,a2,0x4
    8000561e:	9642                	add	a2,a2,a6
    80005620:	577d                	li	a4,-1
    80005622:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005626:	00469713          	slli	a4,a3,0x4
    8000562a:	6114                	ld	a3,0(a0)
    8000562c:	96ba                	add	a3,a3,a4
    8000562e:	03078793          	addi	a5,a5,48
    80005632:	97c2                	add	a5,a5,a6
    80005634:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005636:	611c                	ld	a5,0(a0)
    80005638:	97ba                	add	a5,a5,a4
    8000563a:	4685                	li	a3,1
    8000563c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000563e:	611c                	ld	a5,0(a0)
    80005640:	97ba                	add	a5,a5,a4
    80005642:	4809                	li	a6,2
    80005644:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005648:	611c                	ld	a5,0(a0)
    8000564a:	973e                	add	a4,a4,a5
    8000564c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005650:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005654:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005658:	6518                	ld	a4,8(a0)
    8000565a:	00275783          	lhu	a5,2(a4)
    8000565e:	8b9d                	andi	a5,a5,7
    80005660:	0786                	slli	a5,a5,0x1
    80005662:	97ba                	add	a5,a5,a4
    80005664:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005668:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000566c:	6518                	ld	a4,8(a0)
    8000566e:	00275783          	lhu	a5,2(a4)
    80005672:	2785                	addiw	a5,a5,1
    80005674:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005678:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000567c:	100017b7          	lui	a5,0x10001
    80005680:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005684:	00492703          	lw	a4,4(s2)
    80005688:	4785                	li	a5,1
    8000568a:	02f71163          	bne	a4,a5,800056ac <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000568e:	00038997          	auipc	s3,0x38
    80005692:	a9a98993          	addi	s3,s3,-1382 # 8003d128 <disk+0x2128>
  while(b->disk == 1) {
    80005696:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005698:	85ce                	mv	a1,s3
    8000569a:	854a                	mv	a0,s2
    8000569c:	ffffc097          	auipc	ra,0xffffc
    800056a0:	fc4080e7          	jalr	-60(ra) # 80001660 <sleep>
  while(b->disk == 1) {
    800056a4:	00492783          	lw	a5,4(s2)
    800056a8:	fe9788e3          	beq	a5,s1,80005698 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800056ac:	f9042903          	lw	s2,-112(s0)
    800056b0:	20090793          	addi	a5,s2,512
    800056b4:	00479713          	slli	a4,a5,0x4
    800056b8:	00036797          	auipc	a5,0x36
    800056bc:	94878793          	addi	a5,a5,-1720 # 8003b000 <disk>
    800056c0:	97ba                	add	a5,a5,a4
    800056c2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056c6:	00038997          	auipc	s3,0x38
    800056ca:	93a98993          	addi	s3,s3,-1734 # 8003d000 <disk+0x2000>
    800056ce:	00491713          	slli	a4,s2,0x4
    800056d2:	0009b783          	ld	a5,0(s3)
    800056d6:	97ba                	add	a5,a5,a4
    800056d8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056dc:	854a                	mv	a0,s2
    800056de:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056e2:	00000097          	auipc	ra,0x0
    800056e6:	bc4080e7          	jalr	-1084(ra) # 800052a6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056ea:	8885                	andi	s1,s1,1
    800056ec:	f0ed                	bnez	s1,800056ce <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056ee:	00038517          	auipc	a0,0x38
    800056f2:	a3a50513          	addi	a0,a0,-1478 # 8003d128 <disk+0x2128>
    800056f6:	00001097          	auipc	ra,0x1
    800056fa:	c50080e7          	jalr	-944(ra) # 80006346 <release>
}
    800056fe:	70a6                	ld	ra,104(sp)
    80005700:	7406                	ld	s0,96(sp)
    80005702:	64e6                	ld	s1,88(sp)
    80005704:	6946                	ld	s2,80(sp)
    80005706:	69a6                	ld	s3,72(sp)
    80005708:	6a06                	ld	s4,64(sp)
    8000570a:	7ae2                	ld	s5,56(sp)
    8000570c:	7b42                	ld	s6,48(sp)
    8000570e:	7ba2                	ld	s7,40(sp)
    80005710:	7c02                	ld	s8,32(sp)
    80005712:	6ce2                	ld	s9,24(sp)
    80005714:	6d42                	ld	s10,16(sp)
    80005716:	6165                	addi	sp,sp,112
    80005718:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000571a:	00038697          	auipc	a3,0x38
    8000571e:	8e66b683          	ld	a3,-1818(a3) # 8003d000 <disk+0x2000>
    80005722:	96ba                	add	a3,a3,a4
    80005724:	4609                	li	a2,2
    80005726:	00c69623          	sh	a2,12(a3)
    8000572a:	b5c9                	j	800055ec <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000572c:	f9042583          	lw	a1,-112(s0)
    80005730:	20058793          	addi	a5,a1,512
    80005734:	0792                	slli	a5,a5,0x4
    80005736:	00036517          	auipc	a0,0x36
    8000573a:	97250513          	addi	a0,a0,-1678 # 8003b0a8 <disk+0xa8>
    8000573e:	953e                	add	a0,a0,a5
  if(write)
    80005740:	e20d11e3          	bnez	s10,80005562 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005744:	20058713          	addi	a4,a1,512
    80005748:	00471693          	slli	a3,a4,0x4
    8000574c:	00036717          	auipc	a4,0x36
    80005750:	8b470713          	addi	a4,a4,-1868 # 8003b000 <disk>
    80005754:	9736                	add	a4,a4,a3
    80005756:	0a072423          	sw	zero,168(a4)
    8000575a:	b505                	j	8000557a <virtio_disk_rw+0xf4>

000000008000575c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000575c:	1101                	addi	sp,sp,-32
    8000575e:	ec06                	sd	ra,24(sp)
    80005760:	e822                	sd	s0,16(sp)
    80005762:	e426                	sd	s1,8(sp)
    80005764:	e04a                	sd	s2,0(sp)
    80005766:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005768:	00038517          	auipc	a0,0x38
    8000576c:	9c050513          	addi	a0,a0,-1600 # 8003d128 <disk+0x2128>
    80005770:	00001097          	auipc	ra,0x1
    80005774:	b22080e7          	jalr	-1246(ra) # 80006292 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005778:	10001737          	lui	a4,0x10001
    8000577c:	533c                	lw	a5,96(a4)
    8000577e:	8b8d                	andi	a5,a5,3
    80005780:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005782:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005786:	00038797          	auipc	a5,0x38
    8000578a:	87a78793          	addi	a5,a5,-1926 # 8003d000 <disk+0x2000>
    8000578e:	6b94                	ld	a3,16(a5)
    80005790:	0207d703          	lhu	a4,32(a5)
    80005794:	0026d783          	lhu	a5,2(a3)
    80005798:	06f70163          	beq	a4,a5,800057fa <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000579c:	00036917          	auipc	s2,0x36
    800057a0:	86490913          	addi	s2,s2,-1948 # 8003b000 <disk>
    800057a4:	00038497          	auipc	s1,0x38
    800057a8:	85c48493          	addi	s1,s1,-1956 # 8003d000 <disk+0x2000>
    __sync_synchronize();
    800057ac:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057b0:	6898                	ld	a4,16(s1)
    800057b2:	0204d783          	lhu	a5,32(s1)
    800057b6:	8b9d                	andi	a5,a5,7
    800057b8:	078e                	slli	a5,a5,0x3
    800057ba:	97ba                	add	a5,a5,a4
    800057bc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057be:	20078713          	addi	a4,a5,512
    800057c2:	0712                	slli	a4,a4,0x4
    800057c4:	974a                	add	a4,a4,s2
    800057c6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800057ca:	e731                	bnez	a4,80005816 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057cc:	20078793          	addi	a5,a5,512
    800057d0:	0792                	slli	a5,a5,0x4
    800057d2:	97ca                	add	a5,a5,s2
    800057d4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800057d6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057da:	ffffc097          	auipc	ra,0xffffc
    800057de:	012080e7          	jalr	18(ra) # 800017ec <wakeup>

    disk.used_idx += 1;
    800057e2:	0204d783          	lhu	a5,32(s1)
    800057e6:	2785                	addiw	a5,a5,1
    800057e8:	17c2                	slli	a5,a5,0x30
    800057ea:	93c1                	srli	a5,a5,0x30
    800057ec:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057f0:	6898                	ld	a4,16(s1)
    800057f2:	00275703          	lhu	a4,2(a4)
    800057f6:	faf71be3          	bne	a4,a5,800057ac <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800057fa:	00038517          	auipc	a0,0x38
    800057fe:	92e50513          	addi	a0,a0,-1746 # 8003d128 <disk+0x2128>
    80005802:	00001097          	auipc	ra,0x1
    80005806:	b44080e7          	jalr	-1212(ra) # 80006346 <release>
}
    8000580a:	60e2                	ld	ra,24(sp)
    8000580c:	6442                	ld	s0,16(sp)
    8000580e:	64a2                	ld	s1,8(sp)
    80005810:	6902                	ld	s2,0(sp)
    80005812:	6105                	addi	sp,sp,32
    80005814:	8082                	ret
      panic("virtio_disk_intr status");
    80005816:	00003517          	auipc	a0,0x3
    8000581a:	f9a50513          	addi	a0,a0,-102 # 800087b0 <syscalls+0x3b0>
    8000581e:	00000097          	auipc	ra,0x0
    80005822:	52a080e7          	jalr	1322(ra) # 80005d48 <panic>

0000000080005826 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005826:	1141                	addi	sp,sp,-16
    80005828:	e422                	sd	s0,8(sp)
    8000582a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000582c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005830:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005834:	0037979b          	slliw	a5,a5,0x3
    80005838:	02004737          	lui	a4,0x2004
    8000583c:	97ba                	add	a5,a5,a4
    8000583e:	0200c737          	lui	a4,0x200c
    80005842:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005846:	000f4637          	lui	a2,0xf4
    8000584a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000584e:	95b2                	add	a1,a1,a2
    80005850:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005852:	00269713          	slli	a4,a3,0x2
    80005856:	9736                	add	a4,a4,a3
    80005858:	00371693          	slli	a3,a4,0x3
    8000585c:	00038717          	auipc	a4,0x38
    80005860:	7a470713          	addi	a4,a4,1956 # 8003e000 <timer_scratch>
    80005864:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005866:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005868:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000586a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000586e:	00000797          	auipc	a5,0x0
    80005872:	97278793          	addi	a5,a5,-1678 # 800051e0 <timervec>
    80005876:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000587a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000587e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005882:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005886:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000588a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000588e:	30479073          	csrw	mie,a5
}
    80005892:	6422                	ld	s0,8(sp)
    80005894:	0141                	addi	sp,sp,16
    80005896:	8082                	ret

0000000080005898 <start>:
{
    80005898:	1141                	addi	sp,sp,-16
    8000589a:	e406                	sd	ra,8(sp)
    8000589c:	e022                	sd	s0,0(sp)
    8000589e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058a0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058a4:	7779                	lui	a4,0xffffe
    800058a6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffb85bf>
    800058aa:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058ac:	6705                	lui	a4,0x1
    800058ae:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058b2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058b4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058b8:	ffffb797          	auipc	a5,0xffffb
    800058bc:	b4078793          	addi	a5,a5,-1216 # 800003f8 <main>
    800058c0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058c4:	4781                	li	a5,0
    800058c6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058ca:	67c1                	lui	a5,0x10
    800058cc:	17fd                	addi	a5,a5,-1
    800058ce:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058d2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058d6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058da:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058de:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800058e2:	57fd                	li	a5,-1
    800058e4:	83a9                	srli	a5,a5,0xa
    800058e6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800058ea:	47bd                	li	a5,15
    800058ec:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800058f0:	00000097          	auipc	ra,0x0
    800058f4:	f36080e7          	jalr	-202(ra) # 80005826 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058f8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800058fc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800058fe:	823e                	mv	tp,a5
  asm volatile("mret");
    80005900:	30200073          	mret
}
    80005904:	60a2                	ld	ra,8(sp)
    80005906:	6402                	ld	s0,0(sp)
    80005908:	0141                	addi	sp,sp,16
    8000590a:	8082                	ret

000000008000590c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000590c:	715d                	addi	sp,sp,-80
    8000590e:	e486                	sd	ra,72(sp)
    80005910:	e0a2                	sd	s0,64(sp)
    80005912:	fc26                	sd	s1,56(sp)
    80005914:	f84a                	sd	s2,48(sp)
    80005916:	f44e                	sd	s3,40(sp)
    80005918:	f052                	sd	s4,32(sp)
    8000591a:	ec56                	sd	s5,24(sp)
    8000591c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000591e:	04c05663          	blez	a2,8000596a <consolewrite+0x5e>
    80005922:	8a2a                	mv	s4,a0
    80005924:	84ae                	mv	s1,a1
    80005926:	89b2                	mv	s3,a2
    80005928:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000592a:	5afd                	li	s5,-1
    8000592c:	4685                	li	a3,1
    8000592e:	8626                	mv	a2,s1
    80005930:	85d2                	mv	a1,s4
    80005932:	fbf40513          	addi	a0,s0,-65
    80005936:	ffffc097          	auipc	ra,0xffffc
    8000593a:	124080e7          	jalr	292(ra) # 80001a5a <either_copyin>
    8000593e:	01550c63          	beq	a0,s5,80005956 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005942:	fbf44503          	lbu	a0,-65(s0)
    80005946:	00000097          	auipc	ra,0x0
    8000594a:	78e080e7          	jalr	1934(ra) # 800060d4 <uartputc>
  for(i = 0; i < n; i++){
    8000594e:	2905                	addiw	s2,s2,1
    80005950:	0485                	addi	s1,s1,1
    80005952:	fd299de3          	bne	s3,s2,8000592c <consolewrite+0x20>
  }

  return i;
}
    80005956:	854a                	mv	a0,s2
    80005958:	60a6                	ld	ra,72(sp)
    8000595a:	6406                	ld	s0,64(sp)
    8000595c:	74e2                	ld	s1,56(sp)
    8000595e:	7942                	ld	s2,48(sp)
    80005960:	79a2                	ld	s3,40(sp)
    80005962:	7a02                	ld	s4,32(sp)
    80005964:	6ae2                	ld	s5,24(sp)
    80005966:	6161                	addi	sp,sp,80
    80005968:	8082                	ret
  for(i = 0; i < n; i++){
    8000596a:	4901                	li	s2,0
    8000596c:	b7ed                	j	80005956 <consolewrite+0x4a>

000000008000596e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000596e:	7119                	addi	sp,sp,-128
    80005970:	fc86                	sd	ra,120(sp)
    80005972:	f8a2                	sd	s0,112(sp)
    80005974:	f4a6                	sd	s1,104(sp)
    80005976:	f0ca                	sd	s2,96(sp)
    80005978:	ecce                	sd	s3,88(sp)
    8000597a:	e8d2                	sd	s4,80(sp)
    8000597c:	e4d6                	sd	s5,72(sp)
    8000597e:	e0da                	sd	s6,64(sp)
    80005980:	fc5e                	sd	s7,56(sp)
    80005982:	f862                	sd	s8,48(sp)
    80005984:	f466                	sd	s9,40(sp)
    80005986:	f06a                	sd	s10,32(sp)
    80005988:	ec6e                	sd	s11,24(sp)
    8000598a:	0100                	addi	s0,sp,128
    8000598c:	8b2a                	mv	s6,a0
    8000598e:	8aae                	mv	s5,a1
    80005990:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005992:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005996:	00040517          	auipc	a0,0x40
    8000599a:	7aa50513          	addi	a0,a0,1962 # 80046140 <cons>
    8000599e:	00001097          	auipc	ra,0x1
    800059a2:	8f4080e7          	jalr	-1804(ra) # 80006292 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059a6:	00040497          	auipc	s1,0x40
    800059aa:	79a48493          	addi	s1,s1,1946 # 80046140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059ae:	89a6                	mv	s3,s1
    800059b0:	00041917          	auipc	s2,0x41
    800059b4:	82890913          	addi	s2,s2,-2008 # 800461d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800059b8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059ba:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800059bc:	4da9                	li	s11,10
  while(n > 0){
    800059be:	07405863          	blez	s4,80005a2e <consoleread+0xc0>
    while(cons.r == cons.w){
    800059c2:	0984a783          	lw	a5,152(s1)
    800059c6:	09c4a703          	lw	a4,156(s1)
    800059ca:	02f71463          	bne	a4,a5,800059f2 <consoleread+0x84>
      if(myproc()->killed){
    800059ce:	ffffb097          	auipc	ra,0xffffb
    800059d2:	5d6080e7          	jalr	1494(ra) # 80000fa4 <myproc>
    800059d6:	551c                	lw	a5,40(a0)
    800059d8:	e7b5                	bnez	a5,80005a44 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800059da:	85ce                	mv	a1,s3
    800059dc:	854a                	mv	a0,s2
    800059de:	ffffc097          	auipc	ra,0xffffc
    800059e2:	c82080e7          	jalr	-894(ra) # 80001660 <sleep>
    while(cons.r == cons.w){
    800059e6:	0984a783          	lw	a5,152(s1)
    800059ea:	09c4a703          	lw	a4,156(s1)
    800059ee:	fef700e3          	beq	a4,a5,800059ce <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800059f2:	0017871b          	addiw	a4,a5,1
    800059f6:	08e4ac23          	sw	a4,152(s1)
    800059fa:	07f7f713          	andi	a4,a5,127
    800059fe:	9726                	add	a4,a4,s1
    80005a00:	01874703          	lbu	a4,24(a4)
    80005a04:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a08:	079c0663          	beq	s8,s9,80005a74 <consoleread+0x106>
    cbuf = c;
    80005a0c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a10:	4685                	li	a3,1
    80005a12:	f8f40613          	addi	a2,s0,-113
    80005a16:	85d6                	mv	a1,s5
    80005a18:	855a                	mv	a0,s6
    80005a1a:	ffffc097          	auipc	ra,0xffffc
    80005a1e:	fea080e7          	jalr	-22(ra) # 80001a04 <either_copyout>
    80005a22:	01a50663          	beq	a0,s10,80005a2e <consoleread+0xc0>
    dst++;
    80005a26:	0a85                	addi	s5,s5,1
    --n;
    80005a28:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005a2a:	f9bc1ae3          	bne	s8,s11,800059be <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a2e:	00040517          	auipc	a0,0x40
    80005a32:	71250513          	addi	a0,a0,1810 # 80046140 <cons>
    80005a36:	00001097          	auipc	ra,0x1
    80005a3a:	910080e7          	jalr	-1776(ra) # 80006346 <release>

  return target - n;
    80005a3e:	414b853b          	subw	a0,s7,s4
    80005a42:	a811                	j	80005a56 <consoleread+0xe8>
        release(&cons.lock);
    80005a44:	00040517          	auipc	a0,0x40
    80005a48:	6fc50513          	addi	a0,a0,1788 # 80046140 <cons>
    80005a4c:	00001097          	auipc	ra,0x1
    80005a50:	8fa080e7          	jalr	-1798(ra) # 80006346 <release>
        return -1;
    80005a54:	557d                	li	a0,-1
}
    80005a56:	70e6                	ld	ra,120(sp)
    80005a58:	7446                	ld	s0,112(sp)
    80005a5a:	74a6                	ld	s1,104(sp)
    80005a5c:	7906                	ld	s2,96(sp)
    80005a5e:	69e6                	ld	s3,88(sp)
    80005a60:	6a46                	ld	s4,80(sp)
    80005a62:	6aa6                	ld	s5,72(sp)
    80005a64:	6b06                	ld	s6,64(sp)
    80005a66:	7be2                	ld	s7,56(sp)
    80005a68:	7c42                	ld	s8,48(sp)
    80005a6a:	7ca2                	ld	s9,40(sp)
    80005a6c:	7d02                	ld	s10,32(sp)
    80005a6e:	6de2                	ld	s11,24(sp)
    80005a70:	6109                	addi	sp,sp,128
    80005a72:	8082                	ret
      if(n < target){
    80005a74:	000a071b          	sext.w	a4,s4
    80005a78:	fb777be3          	bgeu	a4,s7,80005a2e <consoleread+0xc0>
        cons.r--;
    80005a7c:	00040717          	auipc	a4,0x40
    80005a80:	74f72e23          	sw	a5,1884(a4) # 800461d8 <cons+0x98>
    80005a84:	b76d                	j	80005a2e <consoleread+0xc0>

0000000080005a86 <consputc>:
{
    80005a86:	1141                	addi	sp,sp,-16
    80005a88:	e406                	sd	ra,8(sp)
    80005a8a:	e022                	sd	s0,0(sp)
    80005a8c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a8e:	10000793          	li	a5,256
    80005a92:	00f50a63          	beq	a0,a5,80005aa6 <consputc+0x20>
    uartputc_sync(c);
    80005a96:	00000097          	auipc	ra,0x0
    80005a9a:	564080e7          	jalr	1380(ra) # 80005ffa <uartputc_sync>
}
    80005a9e:	60a2                	ld	ra,8(sp)
    80005aa0:	6402                	ld	s0,0(sp)
    80005aa2:	0141                	addi	sp,sp,16
    80005aa4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005aa6:	4521                	li	a0,8
    80005aa8:	00000097          	auipc	ra,0x0
    80005aac:	552080e7          	jalr	1362(ra) # 80005ffa <uartputc_sync>
    80005ab0:	02000513          	li	a0,32
    80005ab4:	00000097          	auipc	ra,0x0
    80005ab8:	546080e7          	jalr	1350(ra) # 80005ffa <uartputc_sync>
    80005abc:	4521                	li	a0,8
    80005abe:	00000097          	auipc	ra,0x0
    80005ac2:	53c080e7          	jalr	1340(ra) # 80005ffa <uartputc_sync>
    80005ac6:	bfe1                	j	80005a9e <consputc+0x18>

0000000080005ac8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ac8:	1101                	addi	sp,sp,-32
    80005aca:	ec06                	sd	ra,24(sp)
    80005acc:	e822                	sd	s0,16(sp)
    80005ace:	e426                	sd	s1,8(sp)
    80005ad0:	e04a                	sd	s2,0(sp)
    80005ad2:	1000                	addi	s0,sp,32
    80005ad4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005ad6:	00040517          	auipc	a0,0x40
    80005ada:	66a50513          	addi	a0,a0,1642 # 80046140 <cons>
    80005ade:	00000097          	auipc	ra,0x0
    80005ae2:	7b4080e7          	jalr	1972(ra) # 80006292 <acquire>

  switch(c){
    80005ae6:	47d5                	li	a5,21
    80005ae8:	0af48663          	beq	s1,a5,80005b94 <consoleintr+0xcc>
    80005aec:	0297ca63          	blt	a5,s1,80005b20 <consoleintr+0x58>
    80005af0:	47a1                	li	a5,8
    80005af2:	0ef48763          	beq	s1,a5,80005be0 <consoleintr+0x118>
    80005af6:	47c1                	li	a5,16
    80005af8:	10f49a63          	bne	s1,a5,80005c0c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005afc:	ffffc097          	auipc	ra,0xffffc
    80005b00:	fb4080e7          	jalr	-76(ra) # 80001ab0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b04:	00040517          	auipc	a0,0x40
    80005b08:	63c50513          	addi	a0,a0,1596 # 80046140 <cons>
    80005b0c:	00001097          	auipc	ra,0x1
    80005b10:	83a080e7          	jalr	-1990(ra) # 80006346 <release>
}
    80005b14:	60e2                	ld	ra,24(sp)
    80005b16:	6442                	ld	s0,16(sp)
    80005b18:	64a2                	ld	s1,8(sp)
    80005b1a:	6902                	ld	s2,0(sp)
    80005b1c:	6105                	addi	sp,sp,32
    80005b1e:	8082                	ret
  switch(c){
    80005b20:	07f00793          	li	a5,127
    80005b24:	0af48e63          	beq	s1,a5,80005be0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b28:	00040717          	auipc	a4,0x40
    80005b2c:	61870713          	addi	a4,a4,1560 # 80046140 <cons>
    80005b30:	0a072783          	lw	a5,160(a4)
    80005b34:	09872703          	lw	a4,152(a4)
    80005b38:	9f99                	subw	a5,a5,a4
    80005b3a:	07f00713          	li	a4,127
    80005b3e:	fcf763e3          	bltu	a4,a5,80005b04 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b42:	47b5                	li	a5,13
    80005b44:	0cf48763          	beq	s1,a5,80005c12 <consoleintr+0x14a>
      consputc(c);
    80005b48:	8526                	mv	a0,s1
    80005b4a:	00000097          	auipc	ra,0x0
    80005b4e:	f3c080e7          	jalr	-196(ra) # 80005a86 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b52:	00040797          	auipc	a5,0x40
    80005b56:	5ee78793          	addi	a5,a5,1518 # 80046140 <cons>
    80005b5a:	0a07a703          	lw	a4,160(a5)
    80005b5e:	0017069b          	addiw	a3,a4,1
    80005b62:	0006861b          	sext.w	a2,a3
    80005b66:	0ad7a023          	sw	a3,160(a5)
    80005b6a:	07f77713          	andi	a4,a4,127
    80005b6e:	97ba                	add	a5,a5,a4
    80005b70:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005b74:	47a9                	li	a5,10
    80005b76:	0cf48563          	beq	s1,a5,80005c40 <consoleintr+0x178>
    80005b7a:	4791                	li	a5,4
    80005b7c:	0cf48263          	beq	s1,a5,80005c40 <consoleintr+0x178>
    80005b80:	00040797          	auipc	a5,0x40
    80005b84:	6587a783          	lw	a5,1624(a5) # 800461d8 <cons+0x98>
    80005b88:	0807879b          	addiw	a5,a5,128
    80005b8c:	f6f61ce3          	bne	a2,a5,80005b04 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b90:	863e                	mv	a2,a5
    80005b92:	a07d                	j	80005c40 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b94:	00040717          	auipc	a4,0x40
    80005b98:	5ac70713          	addi	a4,a4,1452 # 80046140 <cons>
    80005b9c:	0a072783          	lw	a5,160(a4)
    80005ba0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ba4:	00040497          	auipc	s1,0x40
    80005ba8:	59c48493          	addi	s1,s1,1436 # 80046140 <cons>
    while(cons.e != cons.w &&
    80005bac:	4929                	li	s2,10
    80005bae:	f4f70be3          	beq	a4,a5,80005b04 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bb2:	37fd                	addiw	a5,a5,-1
    80005bb4:	07f7f713          	andi	a4,a5,127
    80005bb8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bba:	01874703          	lbu	a4,24(a4)
    80005bbe:	f52703e3          	beq	a4,s2,80005b04 <consoleintr+0x3c>
      cons.e--;
    80005bc2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005bc6:	10000513          	li	a0,256
    80005bca:	00000097          	auipc	ra,0x0
    80005bce:	ebc080e7          	jalr	-324(ra) # 80005a86 <consputc>
    while(cons.e != cons.w &&
    80005bd2:	0a04a783          	lw	a5,160(s1)
    80005bd6:	09c4a703          	lw	a4,156(s1)
    80005bda:	fcf71ce3          	bne	a4,a5,80005bb2 <consoleintr+0xea>
    80005bde:	b71d                	j	80005b04 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005be0:	00040717          	auipc	a4,0x40
    80005be4:	56070713          	addi	a4,a4,1376 # 80046140 <cons>
    80005be8:	0a072783          	lw	a5,160(a4)
    80005bec:	09c72703          	lw	a4,156(a4)
    80005bf0:	f0f70ae3          	beq	a4,a5,80005b04 <consoleintr+0x3c>
      cons.e--;
    80005bf4:	37fd                	addiw	a5,a5,-1
    80005bf6:	00040717          	auipc	a4,0x40
    80005bfa:	5ef72523          	sw	a5,1514(a4) # 800461e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005bfe:	10000513          	li	a0,256
    80005c02:	00000097          	auipc	ra,0x0
    80005c06:	e84080e7          	jalr	-380(ra) # 80005a86 <consputc>
    80005c0a:	bded                	j	80005b04 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c0c:	ee048ce3          	beqz	s1,80005b04 <consoleintr+0x3c>
    80005c10:	bf21                	j	80005b28 <consoleintr+0x60>
      consputc(c);
    80005c12:	4529                	li	a0,10
    80005c14:	00000097          	auipc	ra,0x0
    80005c18:	e72080e7          	jalr	-398(ra) # 80005a86 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c1c:	00040797          	auipc	a5,0x40
    80005c20:	52478793          	addi	a5,a5,1316 # 80046140 <cons>
    80005c24:	0a07a703          	lw	a4,160(a5)
    80005c28:	0017069b          	addiw	a3,a4,1
    80005c2c:	0006861b          	sext.w	a2,a3
    80005c30:	0ad7a023          	sw	a3,160(a5)
    80005c34:	07f77713          	andi	a4,a4,127
    80005c38:	97ba                	add	a5,a5,a4
    80005c3a:	4729                	li	a4,10
    80005c3c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c40:	00040797          	auipc	a5,0x40
    80005c44:	58c7ae23          	sw	a2,1436(a5) # 800461dc <cons+0x9c>
        wakeup(&cons.r);
    80005c48:	00040517          	auipc	a0,0x40
    80005c4c:	59050513          	addi	a0,a0,1424 # 800461d8 <cons+0x98>
    80005c50:	ffffc097          	auipc	ra,0xffffc
    80005c54:	b9c080e7          	jalr	-1124(ra) # 800017ec <wakeup>
    80005c58:	b575                	j	80005b04 <consoleintr+0x3c>

0000000080005c5a <consoleinit>:

void
consoleinit(void)
{
    80005c5a:	1141                	addi	sp,sp,-16
    80005c5c:	e406                	sd	ra,8(sp)
    80005c5e:	e022                	sd	s0,0(sp)
    80005c60:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c62:	00003597          	auipc	a1,0x3
    80005c66:	b6658593          	addi	a1,a1,-1178 # 800087c8 <syscalls+0x3c8>
    80005c6a:	00040517          	auipc	a0,0x40
    80005c6e:	4d650513          	addi	a0,a0,1238 # 80046140 <cons>
    80005c72:	00000097          	auipc	ra,0x0
    80005c76:	590080e7          	jalr	1424(ra) # 80006202 <initlock>

  uartinit();
    80005c7a:	00000097          	auipc	ra,0x0
    80005c7e:	330080e7          	jalr	816(ra) # 80005faa <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c82:	00033797          	auipc	a5,0x33
    80005c86:	44678793          	addi	a5,a5,1094 # 800390c8 <devsw>
    80005c8a:	00000717          	auipc	a4,0x0
    80005c8e:	ce470713          	addi	a4,a4,-796 # 8000596e <consoleread>
    80005c92:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c94:	00000717          	auipc	a4,0x0
    80005c98:	c7870713          	addi	a4,a4,-904 # 8000590c <consolewrite>
    80005c9c:	ef98                	sd	a4,24(a5)
}
    80005c9e:	60a2                	ld	ra,8(sp)
    80005ca0:	6402                	ld	s0,0(sp)
    80005ca2:	0141                	addi	sp,sp,16
    80005ca4:	8082                	ret

0000000080005ca6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005ca6:	7179                	addi	sp,sp,-48
    80005ca8:	f406                	sd	ra,40(sp)
    80005caa:	f022                	sd	s0,32(sp)
    80005cac:	ec26                	sd	s1,24(sp)
    80005cae:	e84a                	sd	s2,16(sp)
    80005cb0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cb2:	c219                	beqz	a2,80005cb8 <printint+0x12>
    80005cb4:	08054663          	bltz	a0,80005d40 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005cb8:	2501                	sext.w	a0,a0
    80005cba:	4881                	li	a7,0
    80005cbc:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005cc0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005cc2:	2581                	sext.w	a1,a1
    80005cc4:	00003617          	auipc	a2,0x3
    80005cc8:	b3460613          	addi	a2,a2,-1228 # 800087f8 <digits>
    80005ccc:	883a                	mv	a6,a4
    80005cce:	2705                	addiw	a4,a4,1
    80005cd0:	02b577bb          	remuw	a5,a0,a1
    80005cd4:	1782                	slli	a5,a5,0x20
    80005cd6:	9381                	srli	a5,a5,0x20
    80005cd8:	97b2                	add	a5,a5,a2
    80005cda:	0007c783          	lbu	a5,0(a5)
    80005cde:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005ce2:	0005079b          	sext.w	a5,a0
    80005ce6:	02b5553b          	divuw	a0,a0,a1
    80005cea:	0685                	addi	a3,a3,1
    80005cec:	feb7f0e3          	bgeu	a5,a1,80005ccc <printint+0x26>

  if(sign)
    80005cf0:	00088b63          	beqz	a7,80005d06 <printint+0x60>
    buf[i++] = '-';
    80005cf4:	fe040793          	addi	a5,s0,-32
    80005cf8:	973e                	add	a4,a4,a5
    80005cfa:	02d00793          	li	a5,45
    80005cfe:	fef70823          	sb	a5,-16(a4)
    80005d02:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d06:	02e05763          	blez	a4,80005d34 <printint+0x8e>
    80005d0a:	fd040793          	addi	a5,s0,-48
    80005d0e:	00e784b3          	add	s1,a5,a4
    80005d12:	fff78913          	addi	s2,a5,-1
    80005d16:	993a                	add	s2,s2,a4
    80005d18:	377d                	addiw	a4,a4,-1
    80005d1a:	1702                	slli	a4,a4,0x20
    80005d1c:	9301                	srli	a4,a4,0x20
    80005d1e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d22:	fff4c503          	lbu	a0,-1(s1)
    80005d26:	00000097          	auipc	ra,0x0
    80005d2a:	d60080e7          	jalr	-672(ra) # 80005a86 <consputc>
  while(--i >= 0)
    80005d2e:	14fd                	addi	s1,s1,-1
    80005d30:	ff2499e3          	bne	s1,s2,80005d22 <printint+0x7c>
}
    80005d34:	70a2                	ld	ra,40(sp)
    80005d36:	7402                	ld	s0,32(sp)
    80005d38:	64e2                	ld	s1,24(sp)
    80005d3a:	6942                	ld	s2,16(sp)
    80005d3c:	6145                	addi	sp,sp,48
    80005d3e:	8082                	ret
    x = -xx;
    80005d40:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d44:	4885                	li	a7,1
    x = -xx;
    80005d46:	bf9d                	j	80005cbc <printint+0x16>

0000000080005d48 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d48:	1101                	addi	sp,sp,-32
    80005d4a:	ec06                	sd	ra,24(sp)
    80005d4c:	e822                	sd	s0,16(sp)
    80005d4e:	e426                	sd	s1,8(sp)
    80005d50:	1000                	addi	s0,sp,32
    80005d52:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d54:	00040797          	auipc	a5,0x40
    80005d58:	4a07a623          	sw	zero,1196(a5) # 80046200 <pr+0x18>
  printf("panic: ");
    80005d5c:	00003517          	auipc	a0,0x3
    80005d60:	a7450513          	addi	a0,a0,-1420 # 800087d0 <syscalls+0x3d0>
    80005d64:	00000097          	auipc	ra,0x0
    80005d68:	02e080e7          	jalr	46(ra) # 80005d92 <printf>
  printf(s);
    80005d6c:	8526                	mv	a0,s1
    80005d6e:	00000097          	auipc	ra,0x0
    80005d72:	024080e7          	jalr	36(ra) # 80005d92 <printf>
  printf("\n");
    80005d76:	00002517          	auipc	a0,0x2
    80005d7a:	2e250513          	addi	a0,a0,738 # 80008058 <etext+0x58>
    80005d7e:	00000097          	auipc	ra,0x0
    80005d82:	014080e7          	jalr	20(ra) # 80005d92 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d86:	4785                	li	a5,1
    80005d88:	00003717          	auipc	a4,0x3
    80005d8c:	28f72a23          	sw	a5,660(a4) # 8000901c <panicked>
  for(;;)
    80005d90:	a001                	j	80005d90 <panic+0x48>

0000000080005d92 <printf>:
{
    80005d92:	7131                	addi	sp,sp,-192
    80005d94:	fc86                	sd	ra,120(sp)
    80005d96:	f8a2                	sd	s0,112(sp)
    80005d98:	f4a6                	sd	s1,104(sp)
    80005d9a:	f0ca                	sd	s2,96(sp)
    80005d9c:	ecce                	sd	s3,88(sp)
    80005d9e:	e8d2                	sd	s4,80(sp)
    80005da0:	e4d6                	sd	s5,72(sp)
    80005da2:	e0da                	sd	s6,64(sp)
    80005da4:	fc5e                	sd	s7,56(sp)
    80005da6:	f862                	sd	s8,48(sp)
    80005da8:	f466                	sd	s9,40(sp)
    80005daa:	f06a                	sd	s10,32(sp)
    80005dac:	ec6e                	sd	s11,24(sp)
    80005dae:	0100                	addi	s0,sp,128
    80005db0:	8a2a                	mv	s4,a0
    80005db2:	e40c                	sd	a1,8(s0)
    80005db4:	e810                	sd	a2,16(s0)
    80005db6:	ec14                	sd	a3,24(s0)
    80005db8:	f018                	sd	a4,32(s0)
    80005dba:	f41c                	sd	a5,40(s0)
    80005dbc:	03043823          	sd	a6,48(s0)
    80005dc0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005dc4:	00040d97          	auipc	s11,0x40
    80005dc8:	43cdad83          	lw	s11,1084(s11) # 80046200 <pr+0x18>
  if(locking)
    80005dcc:	020d9b63          	bnez	s11,80005e02 <printf+0x70>
  if (fmt == 0)
    80005dd0:	040a0263          	beqz	s4,80005e14 <printf+0x82>
  va_start(ap, fmt);
    80005dd4:	00840793          	addi	a5,s0,8
    80005dd8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ddc:	000a4503          	lbu	a0,0(s4)
    80005de0:	16050263          	beqz	a0,80005f44 <printf+0x1b2>
    80005de4:	4481                	li	s1,0
    if(c != '%'){
    80005de6:	02500a93          	li	s5,37
    switch(c){
    80005dea:	07000b13          	li	s6,112
  consputc('x');
    80005dee:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005df0:	00003b97          	auipc	s7,0x3
    80005df4:	a08b8b93          	addi	s7,s7,-1528 # 800087f8 <digits>
    switch(c){
    80005df8:	07300c93          	li	s9,115
    80005dfc:	06400c13          	li	s8,100
    80005e00:	a82d                	j	80005e3a <printf+0xa8>
    acquire(&pr.lock);
    80005e02:	00040517          	auipc	a0,0x40
    80005e06:	3e650513          	addi	a0,a0,998 # 800461e8 <pr>
    80005e0a:	00000097          	auipc	ra,0x0
    80005e0e:	488080e7          	jalr	1160(ra) # 80006292 <acquire>
    80005e12:	bf7d                	j	80005dd0 <printf+0x3e>
    panic("null fmt");
    80005e14:	00003517          	auipc	a0,0x3
    80005e18:	9cc50513          	addi	a0,a0,-1588 # 800087e0 <syscalls+0x3e0>
    80005e1c:	00000097          	auipc	ra,0x0
    80005e20:	f2c080e7          	jalr	-212(ra) # 80005d48 <panic>
      consputc(c);
    80005e24:	00000097          	auipc	ra,0x0
    80005e28:	c62080e7          	jalr	-926(ra) # 80005a86 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e2c:	2485                	addiw	s1,s1,1
    80005e2e:	009a07b3          	add	a5,s4,s1
    80005e32:	0007c503          	lbu	a0,0(a5)
    80005e36:	10050763          	beqz	a0,80005f44 <printf+0x1b2>
    if(c != '%'){
    80005e3a:	ff5515e3          	bne	a0,s5,80005e24 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e3e:	2485                	addiw	s1,s1,1
    80005e40:	009a07b3          	add	a5,s4,s1
    80005e44:	0007c783          	lbu	a5,0(a5)
    80005e48:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005e4c:	cfe5                	beqz	a5,80005f44 <printf+0x1b2>
    switch(c){
    80005e4e:	05678a63          	beq	a5,s6,80005ea2 <printf+0x110>
    80005e52:	02fb7663          	bgeu	s6,a5,80005e7e <printf+0xec>
    80005e56:	09978963          	beq	a5,s9,80005ee8 <printf+0x156>
    80005e5a:	07800713          	li	a4,120
    80005e5e:	0ce79863          	bne	a5,a4,80005f2e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005e62:	f8843783          	ld	a5,-120(s0)
    80005e66:	00878713          	addi	a4,a5,8
    80005e6a:	f8e43423          	sd	a4,-120(s0)
    80005e6e:	4605                	li	a2,1
    80005e70:	85ea                	mv	a1,s10
    80005e72:	4388                	lw	a0,0(a5)
    80005e74:	00000097          	auipc	ra,0x0
    80005e78:	e32080e7          	jalr	-462(ra) # 80005ca6 <printint>
      break;
    80005e7c:	bf45                	j	80005e2c <printf+0x9a>
    switch(c){
    80005e7e:	0b578263          	beq	a5,s5,80005f22 <printf+0x190>
    80005e82:	0b879663          	bne	a5,s8,80005f2e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005e86:	f8843783          	ld	a5,-120(s0)
    80005e8a:	00878713          	addi	a4,a5,8
    80005e8e:	f8e43423          	sd	a4,-120(s0)
    80005e92:	4605                	li	a2,1
    80005e94:	45a9                	li	a1,10
    80005e96:	4388                	lw	a0,0(a5)
    80005e98:	00000097          	auipc	ra,0x0
    80005e9c:	e0e080e7          	jalr	-498(ra) # 80005ca6 <printint>
      break;
    80005ea0:	b771                	j	80005e2c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005ea2:	f8843783          	ld	a5,-120(s0)
    80005ea6:	00878713          	addi	a4,a5,8
    80005eaa:	f8e43423          	sd	a4,-120(s0)
    80005eae:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005eb2:	03000513          	li	a0,48
    80005eb6:	00000097          	auipc	ra,0x0
    80005eba:	bd0080e7          	jalr	-1072(ra) # 80005a86 <consputc>
  consputc('x');
    80005ebe:	07800513          	li	a0,120
    80005ec2:	00000097          	auipc	ra,0x0
    80005ec6:	bc4080e7          	jalr	-1084(ra) # 80005a86 <consputc>
    80005eca:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ecc:	03c9d793          	srli	a5,s3,0x3c
    80005ed0:	97de                	add	a5,a5,s7
    80005ed2:	0007c503          	lbu	a0,0(a5)
    80005ed6:	00000097          	auipc	ra,0x0
    80005eda:	bb0080e7          	jalr	-1104(ra) # 80005a86 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005ede:	0992                	slli	s3,s3,0x4
    80005ee0:	397d                	addiw	s2,s2,-1
    80005ee2:	fe0915e3          	bnez	s2,80005ecc <printf+0x13a>
    80005ee6:	b799                	j	80005e2c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005ee8:	f8843783          	ld	a5,-120(s0)
    80005eec:	00878713          	addi	a4,a5,8
    80005ef0:	f8e43423          	sd	a4,-120(s0)
    80005ef4:	0007b903          	ld	s2,0(a5)
    80005ef8:	00090e63          	beqz	s2,80005f14 <printf+0x182>
      for(; *s; s++)
    80005efc:	00094503          	lbu	a0,0(s2)
    80005f00:	d515                	beqz	a0,80005e2c <printf+0x9a>
        consputc(*s);
    80005f02:	00000097          	auipc	ra,0x0
    80005f06:	b84080e7          	jalr	-1148(ra) # 80005a86 <consputc>
      for(; *s; s++)
    80005f0a:	0905                	addi	s2,s2,1
    80005f0c:	00094503          	lbu	a0,0(s2)
    80005f10:	f96d                	bnez	a0,80005f02 <printf+0x170>
    80005f12:	bf29                	j	80005e2c <printf+0x9a>
        s = "(null)";
    80005f14:	00003917          	auipc	s2,0x3
    80005f18:	8c490913          	addi	s2,s2,-1852 # 800087d8 <syscalls+0x3d8>
      for(; *s; s++)
    80005f1c:	02800513          	li	a0,40
    80005f20:	b7cd                	j	80005f02 <printf+0x170>
      consputc('%');
    80005f22:	8556                	mv	a0,s5
    80005f24:	00000097          	auipc	ra,0x0
    80005f28:	b62080e7          	jalr	-1182(ra) # 80005a86 <consputc>
      break;
    80005f2c:	b701                	j	80005e2c <printf+0x9a>
      consputc('%');
    80005f2e:	8556                	mv	a0,s5
    80005f30:	00000097          	auipc	ra,0x0
    80005f34:	b56080e7          	jalr	-1194(ra) # 80005a86 <consputc>
      consputc(c);
    80005f38:	854a                	mv	a0,s2
    80005f3a:	00000097          	auipc	ra,0x0
    80005f3e:	b4c080e7          	jalr	-1204(ra) # 80005a86 <consputc>
      break;
    80005f42:	b5ed                	j	80005e2c <printf+0x9a>
  if(locking)
    80005f44:	020d9163          	bnez	s11,80005f66 <printf+0x1d4>
}
    80005f48:	70e6                	ld	ra,120(sp)
    80005f4a:	7446                	ld	s0,112(sp)
    80005f4c:	74a6                	ld	s1,104(sp)
    80005f4e:	7906                	ld	s2,96(sp)
    80005f50:	69e6                	ld	s3,88(sp)
    80005f52:	6a46                	ld	s4,80(sp)
    80005f54:	6aa6                	ld	s5,72(sp)
    80005f56:	6b06                	ld	s6,64(sp)
    80005f58:	7be2                	ld	s7,56(sp)
    80005f5a:	7c42                	ld	s8,48(sp)
    80005f5c:	7ca2                	ld	s9,40(sp)
    80005f5e:	7d02                	ld	s10,32(sp)
    80005f60:	6de2                	ld	s11,24(sp)
    80005f62:	6129                	addi	sp,sp,192
    80005f64:	8082                	ret
    release(&pr.lock);
    80005f66:	00040517          	auipc	a0,0x40
    80005f6a:	28250513          	addi	a0,a0,642 # 800461e8 <pr>
    80005f6e:	00000097          	auipc	ra,0x0
    80005f72:	3d8080e7          	jalr	984(ra) # 80006346 <release>
}
    80005f76:	bfc9                	j	80005f48 <printf+0x1b6>

0000000080005f78 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f78:	1101                	addi	sp,sp,-32
    80005f7a:	ec06                	sd	ra,24(sp)
    80005f7c:	e822                	sd	s0,16(sp)
    80005f7e:	e426                	sd	s1,8(sp)
    80005f80:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f82:	00040497          	auipc	s1,0x40
    80005f86:	26648493          	addi	s1,s1,614 # 800461e8 <pr>
    80005f8a:	00003597          	auipc	a1,0x3
    80005f8e:	86658593          	addi	a1,a1,-1946 # 800087f0 <syscalls+0x3f0>
    80005f92:	8526                	mv	a0,s1
    80005f94:	00000097          	auipc	ra,0x0
    80005f98:	26e080e7          	jalr	622(ra) # 80006202 <initlock>
  pr.locking = 1;
    80005f9c:	4785                	li	a5,1
    80005f9e:	cc9c                	sw	a5,24(s1)
}
    80005fa0:	60e2                	ld	ra,24(sp)
    80005fa2:	6442                	ld	s0,16(sp)
    80005fa4:	64a2                	ld	s1,8(sp)
    80005fa6:	6105                	addi	sp,sp,32
    80005fa8:	8082                	ret

0000000080005faa <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005faa:	1141                	addi	sp,sp,-16
    80005fac:	e406                	sd	ra,8(sp)
    80005fae:	e022                	sd	s0,0(sp)
    80005fb0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005fb2:	100007b7          	lui	a5,0x10000
    80005fb6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005fba:	f8000713          	li	a4,-128
    80005fbe:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fc2:	470d                	li	a4,3
    80005fc4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005fc8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005fcc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005fd0:	469d                	li	a3,7
    80005fd2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005fd6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005fda:	00003597          	auipc	a1,0x3
    80005fde:	83658593          	addi	a1,a1,-1994 # 80008810 <digits+0x18>
    80005fe2:	00040517          	auipc	a0,0x40
    80005fe6:	22650513          	addi	a0,a0,550 # 80046208 <uart_tx_lock>
    80005fea:	00000097          	auipc	ra,0x0
    80005fee:	218080e7          	jalr	536(ra) # 80006202 <initlock>
}
    80005ff2:	60a2                	ld	ra,8(sp)
    80005ff4:	6402                	ld	s0,0(sp)
    80005ff6:	0141                	addi	sp,sp,16
    80005ff8:	8082                	ret

0000000080005ffa <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005ffa:	1101                	addi	sp,sp,-32
    80005ffc:	ec06                	sd	ra,24(sp)
    80005ffe:	e822                	sd	s0,16(sp)
    80006000:	e426                	sd	s1,8(sp)
    80006002:	1000                	addi	s0,sp,32
    80006004:	84aa                	mv	s1,a0
  push_off();
    80006006:	00000097          	auipc	ra,0x0
    8000600a:	240080e7          	jalr	576(ra) # 80006246 <push_off>

  if(panicked){
    8000600e:	00003797          	auipc	a5,0x3
    80006012:	00e7a783          	lw	a5,14(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006016:	10000737          	lui	a4,0x10000
  if(panicked){
    8000601a:	c391                	beqz	a5,8000601e <uartputc_sync+0x24>
    for(;;)
    8000601c:	a001                	j	8000601c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000601e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006022:	0ff7f793          	andi	a5,a5,255
    80006026:	0207f793          	andi	a5,a5,32
    8000602a:	dbf5                	beqz	a5,8000601e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000602c:	0ff4f793          	andi	a5,s1,255
    80006030:	10000737          	lui	a4,0x10000
    80006034:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006038:	00000097          	auipc	ra,0x0
    8000603c:	2ae080e7          	jalr	686(ra) # 800062e6 <pop_off>
}
    80006040:	60e2                	ld	ra,24(sp)
    80006042:	6442                	ld	s0,16(sp)
    80006044:	64a2                	ld	s1,8(sp)
    80006046:	6105                	addi	sp,sp,32
    80006048:	8082                	ret

000000008000604a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000604a:	00003717          	auipc	a4,0x3
    8000604e:	fd673703          	ld	a4,-42(a4) # 80009020 <uart_tx_r>
    80006052:	00003797          	auipc	a5,0x3
    80006056:	fd67b783          	ld	a5,-42(a5) # 80009028 <uart_tx_w>
    8000605a:	06e78c63          	beq	a5,a4,800060d2 <uartstart+0x88>
{
    8000605e:	7139                	addi	sp,sp,-64
    80006060:	fc06                	sd	ra,56(sp)
    80006062:	f822                	sd	s0,48(sp)
    80006064:	f426                	sd	s1,40(sp)
    80006066:	f04a                	sd	s2,32(sp)
    80006068:	ec4e                	sd	s3,24(sp)
    8000606a:	e852                	sd	s4,16(sp)
    8000606c:	e456                	sd	s5,8(sp)
    8000606e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006070:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006074:	00040a17          	auipc	s4,0x40
    80006078:	194a0a13          	addi	s4,s4,404 # 80046208 <uart_tx_lock>
    uart_tx_r += 1;
    8000607c:	00003497          	auipc	s1,0x3
    80006080:	fa448493          	addi	s1,s1,-92 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006084:	00003997          	auipc	s3,0x3
    80006088:	fa498993          	addi	s3,s3,-92 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000608c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006090:	0ff7f793          	andi	a5,a5,255
    80006094:	0207f793          	andi	a5,a5,32
    80006098:	c785                	beqz	a5,800060c0 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000609a:	01f77793          	andi	a5,a4,31
    8000609e:	97d2                	add	a5,a5,s4
    800060a0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800060a4:	0705                	addi	a4,a4,1
    800060a6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060a8:	8526                	mv	a0,s1
    800060aa:	ffffb097          	auipc	ra,0xffffb
    800060ae:	742080e7          	jalr	1858(ra) # 800017ec <wakeup>
    
    WriteReg(THR, c);
    800060b2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060b6:	6098                	ld	a4,0(s1)
    800060b8:	0009b783          	ld	a5,0(s3)
    800060bc:	fce798e3          	bne	a5,a4,8000608c <uartstart+0x42>
  }
}
    800060c0:	70e2                	ld	ra,56(sp)
    800060c2:	7442                	ld	s0,48(sp)
    800060c4:	74a2                	ld	s1,40(sp)
    800060c6:	7902                	ld	s2,32(sp)
    800060c8:	69e2                	ld	s3,24(sp)
    800060ca:	6a42                	ld	s4,16(sp)
    800060cc:	6aa2                	ld	s5,8(sp)
    800060ce:	6121                	addi	sp,sp,64
    800060d0:	8082                	ret
    800060d2:	8082                	ret

00000000800060d4 <uartputc>:
{
    800060d4:	7179                	addi	sp,sp,-48
    800060d6:	f406                	sd	ra,40(sp)
    800060d8:	f022                	sd	s0,32(sp)
    800060da:	ec26                	sd	s1,24(sp)
    800060dc:	e84a                	sd	s2,16(sp)
    800060de:	e44e                	sd	s3,8(sp)
    800060e0:	e052                	sd	s4,0(sp)
    800060e2:	1800                	addi	s0,sp,48
    800060e4:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800060e6:	00040517          	auipc	a0,0x40
    800060ea:	12250513          	addi	a0,a0,290 # 80046208 <uart_tx_lock>
    800060ee:	00000097          	auipc	ra,0x0
    800060f2:	1a4080e7          	jalr	420(ra) # 80006292 <acquire>
  if(panicked){
    800060f6:	00003797          	auipc	a5,0x3
    800060fa:	f267a783          	lw	a5,-218(a5) # 8000901c <panicked>
    800060fe:	c391                	beqz	a5,80006102 <uartputc+0x2e>
    for(;;)
    80006100:	a001                	j	80006100 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006102:	00003797          	auipc	a5,0x3
    80006106:	f267b783          	ld	a5,-218(a5) # 80009028 <uart_tx_w>
    8000610a:	00003717          	auipc	a4,0x3
    8000610e:	f1673703          	ld	a4,-234(a4) # 80009020 <uart_tx_r>
    80006112:	02070713          	addi	a4,a4,32
    80006116:	02f71b63          	bne	a4,a5,8000614c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000611a:	00040a17          	auipc	s4,0x40
    8000611e:	0eea0a13          	addi	s4,s4,238 # 80046208 <uart_tx_lock>
    80006122:	00003497          	auipc	s1,0x3
    80006126:	efe48493          	addi	s1,s1,-258 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000612a:	00003917          	auipc	s2,0x3
    8000612e:	efe90913          	addi	s2,s2,-258 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006132:	85d2                	mv	a1,s4
    80006134:	8526                	mv	a0,s1
    80006136:	ffffb097          	auipc	ra,0xffffb
    8000613a:	52a080e7          	jalr	1322(ra) # 80001660 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000613e:	00093783          	ld	a5,0(s2)
    80006142:	6098                	ld	a4,0(s1)
    80006144:	02070713          	addi	a4,a4,32
    80006148:	fef705e3          	beq	a4,a5,80006132 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000614c:	00040497          	auipc	s1,0x40
    80006150:	0bc48493          	addi	s1,s1,188 # 80046208 <uart_tx_lock>
    80006154:	01f7f713          	andi	a4,a5,31
    80006158:	9726                	add	a4,a4,s1
    8000615a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000615e:	0785                	addi	a5,a5,1
    80006160:	00003717          	auipc	a4,0x3
    80006164:	ecf73423          	sd	a5,-312(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006168:	00000097          	auipc	ra,0x0
    8000616c:	ee2080e7          	jalr	-286(ra) # 8000604a <uartstart>
      release(&uart_tx_lock);
    80006170:	8526                	mv	a0,s1
    80006172:	00000097          	auipc	ra,0x0
    80006176:	1d4080e7          	jalr	468(ra) # 80006346 <release>
}
    8000617a:	70a2                	ld	ra,40(sp)
    8000617c:	7402                	ld	s0,32(sp)
    8000617e:	64e2                	ld	s1,24(sp)
    80006180:	6942                	ld	s2,16(sp)
    80006182:	69a2                	ld	s3,8(sp)
    80006184:	6a02                	ld	s4,0(sp)
    80006186:	6145                	addi	sp,sp,48
    80006188:	8082                	ret

000000008000618a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000618a:	1141                	addi	sp,sp,-16
    8000618c:	e422                	sd	s0,8(sp)
    8000618e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006190:	100007b7          	lui	a5,0x10000
    80006194:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006198:	8b85                	andi	a5,a5,1
    8000619a:	cb91                	beqz	a5,800061ae <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000619c:	100007b7          	lui	a5,0x10000
    800061a0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800061a4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800061a8:	6422                	ld	s0,8(sp)
    800061aa:	0141                	addi	sp,sp,16
    800061ac:	8082                	ret
    return -1;
    800061ae:	557d                	li	a0,-1
    800061b0:	bfe5                	j	800061a8 <uartgetc+0x1e>

00000000800061b2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800061b2:	1101                	addi	sp,sp,-32
    800061b4:	ec06                	sd	ra,24(sp)
    800061b6:	e822                	sd	s0,16(sp)
    800061b8:	e426                	sd	s1,8(sp)
    800061ba:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061bc:	54fd                	li	s1,-1
    int c = uartgetc();
    800061be:	00000097          	auipc	ra,0x0
    800061c2:	fcc080e7          	jalr	-52(ra) # 8000618a <uartgetc>
    if(c == -1)
    800061c6:	00950763          	beq	a0,s1,800061d4 <uartintr+0x22>
      break;
    consoleintr(c);
    800061ca:	00000097          	auipc	ra,0x0
    800061ce:	8fe080e7          	jalr	-1794(ra) # 80005ac8 <consoleintr>
  while(1){
    800061d2:	b7f5                	j	800061be <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061d4:	00040497          	auipc	s1,0x40
    800061d8:	03448493          	addi	s1,s1,52 # 80046208 <uart_tx_lock>
    800061dc:	8526                	mv	a0,s1
    800061de:	00000097          	auipc	ra,0x0
    800061e2:	0b4080e7          	jalr	180(ra) # 80006292 <acquire>
  uartstart();
    800061e6:	00000097          	auipc	ra,0x0
    800061ea:	e64080e7          	jalr	-412(ra) # 8000604a <uartstart>
  release(&uart_tx_lock);
    800061ee:	8526                	mv	a0,s1
    800061f0:	00000097          	auipc	ra,0x0
    800061f4:	156080e7          	jalr	342(ra) # 80006346 <release>
}
    800061f8:	60e2                	ld	ra,24(sp)
    800061fa:	6442                	ld	s0,16(sp)
    800061fc:	64a2                	ld	s1,8(sp)
    800061fe:	6105                	addi	sp,sp,32
    80006200:	8082                	ret

0000000080006202 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006202:	1141                	addi	sp,sp,-16
    80006204:	e422                	sd	s0,8(sp)
    80006206:	0800                	addi	s0,sp,16
  lk->name = name;
    80006208:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000620a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000620e:	00053823          	sd	zero,16(a0)
}
    80006212:	6422                	ld	s0,8(sp)
    80006214:	0141                	addi	sp,sp,16
    80006216:	8082                	ret

0000000080006218 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006218:	411c                	lw	a5,0(a0)
    8000621a:	e399                	bnez	a5,80006220 <holding+0x8>
    8000621c:	4501                	li	a0,0
  return r;
}
    8000621e:	8082                	ret
{
    80006220:	1101                	addi	sp,sp,-32
    80006222:	ec06                	sd	ra,24(sp)
    80006224:	e822                	sd	s0,16(sp)
    80006226:	e426                	sd	s1,8(sp)
    80006228:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000622a:	6904                	ld	s1,16(a0)
    8000622c:	ffffb097          	auipc	ra,0xffffb
    80006230:	d5c080e7          	jalr	-676(ra) # 80000f88 <mycpu>
    80006234:	40a48533          	sub	a0,s1,a0
    80006238:	00153513          	seqz	a0,a0
}
    8000623c:	60e2                	ld	ra,24(sp)
    8000623e:	6442                	ld	s0,16(sp)
    80006240:	64a2                	ld	s1,8(sp)
    80006242:	6105                	addi	sp,sp,32
    80006244:	8082                	ret

0000000080006246 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006246:	1101                	addi	sp,sp,-32
    80006248:	ec06                	sd	ra,24(sp)
    8000624a:	e822                	sd	s0,16(sp)
    8000624c:	e426                	sd	s1,8(sp)
    8000624e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006250:	100024f3          	csrr	s1,sstatus
    80006254:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006258:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000625a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000625e:	ffffb097          	auipc	ra,0xffffb
    80006262:	d2a080e7          	jalr	-726(ra) # 80000f88 <mycpu>
    80006266:	5d3c                	lw	a5,120(a0)
    80006268:	cf89                	beqz	a5,80006282 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000626a:	ffffb097          	auipc	ra,0xffffb
    8000626e:	d1e080e7          	jalr	-738(ra) # 80000f88 <mycpu>
    80006272:	5d3c                	lw	a5,120(a0)
    80006274:	2785                	addiw	a5,a5,1
    80006276:	dd3c                	sw	a5,120(a0)
}
    80006278:	60e2                	ld	ra,24(sp)
    8000627a:	6442                	ld	s0,16(sp)
    8000627c:	64a2                	ld	s1,8(sp)
    8000627e:	6105                	addi	sp,sp,32
    80006280:	8082                	ret
    mycpu()->intena = old;
    80006282:	ffffb097          	auipc	ra,0xffffb
    80006286:	d06080e7          	jalr	-762(ra) # 80000f88 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000628a:	8085                	srli	s1,s1,0x1
    8000628c:	8885                	andi	s1,s1,1
    8000628e:	dd64                	sw	s1,124(a0)
    80006290:	bfe9                	j	8000626a <push_off+0x24>

0000000080006292 <acquire>:
{
    80006292:	1101                	addi	sp,sp,-32
    80006294:	ec06                	sd	ra,24(sp)
    80006296:	e822                	sd	s0,16(sp)
    80006298:	e426                	sd	s1,8(sp)
    8000629a:	1000                	addi	s0,sp,32
    8000629c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000629e:	00000097          	auipc	ra,0x0
    800062a2:	fa8080e7          	jalr	-88(ra) # 80006246 <push_off>
  if(holding(lk))
    800062a6:	8526                	mv	a0,s1
    800062a8:	00000097          	auipc	ra,0x0
    800062ac:	f70080e7          	jalr	-144(ra) # 80006218 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062b0:	4705                	li	a4,1
  if(holding(lk))
    800062b2:	e115                	bnez	a0,800062d6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062b4:	87ba                	mv	a5,a4
    800062b6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062ba:	2781                	sext.w	a5,a5
    800062bc:	ffe5                	bnez	a5,800062b4 <acquire+0x22>
  __sync_synchronize();
    800062be:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062c2:	ffffb097          	auipc	ra,0xffffb
    800062c6:	cc6080e7          	jalr	-826(ra) # 80000f88 <mycpu>
    800062ca:	e888                	sd	a0,16(s1)
}
    800062cc:	60e2                	ld	ra,24(sp)
    800062ce:	6442                	ld	s0,16(sp)
    800062d0:	64a2                	ld	s1,8(sp)
    800062d2:	6105                	addi	sp,sp,32
    800062d4:	8082                	ret
    panic("acquire");
    800062d6:	00002517          	auipc	a0,0x2
    800062da:	54250513          	addi	a0,a0,1346 # 80008818 <digits+0x20>
    800062de:	00000097          	auipc	ra,0x0
    800062e2:	a6a080e7          	jalr	-1430(ra) # 80005d48 <panic>

00000000800062e6 <pop_off>:

void
pop_off(void)
{
    800062e6:	1141                	addi	sp,sp,-16
    800062e8:	e406                	sd	ra,8(sp)
    800062ea:	e022                	sd	s0,0(sp)
    800062ec:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062ee:	ffffb097          	auipc	ra,0xffffb
    800062f2:	c9a080e7          	jalr	-870(ra) # 80000f88 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062f6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062fa:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062fc:	e78d                	bnez	a5,80006326 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800062fe:	5d3c                	lw	a5,120(a0)
    80006300:	02f05b63          	blez	a5,80006336 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006304:	37fd                	addiw	a5,a5,-1
    80006306:	0007871b          	sext.w	a4,a5
    8000630a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000630c:	eb09                	bnez	a4,8000631e <pop_off+0x38>
    8000630e:	5d7c                	lw	a5,124(a0)
    80006310:	c799                	beqz	a5,8000631e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006312:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006316:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000631a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000631e:	60a2                	ld	ra,8(sp)
    80006320:	6402                	ld	s0,0(sp)
    80006322:	0141                	addi	sp,sp,16
    80006324:	8082                	ret
    panic("pop_off - interruptible");
    80006326:	00002517          	auipc	a0,0x2
    8000632a:	4fa50513          	addi	a0,a0,1274 # 80008820 <digits+0x28>
    8000632e:	00000097          	auipc	ra,0x0
    80006332:	a1a080e7          	jalr	-1510(ra) # 80005d48 <panic>
    panic("pop_off");
    80006336:	00002517          	auipc	a0,0x2
    8000633a:	50250513          	addi	a0,a0,1282 # 80008838 <digits+0x40>
    8000633e:	00000097          	auipc	ra,0x0
    80006342:	a0a080e7          	jalr	-1526(ra) # 80005d48 <panic>

0000000080006346 <release>:
{
    80006346:	1101                	addi	sp,sp,-32
    80006348:	ec06                	sd	ra,24(sp)
    8000634a:	e822                	sd	s0,16(sp)
    8000634c:	e426                	sd	s1,8(sp)
    8000634e:	1000                	addi	s0,sp,32
    80006350:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006352:	00000097          	auipc	ra,0x0
    80006356:	ec6080e7          	jalr	-314(ra) # 80006218 <holding>
    8000635a:	c115                	beqz	a0,8000637e <release+0x38>
  lk->cpu = 0;
    8000635c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006360:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006364:	0f50000f          	fence	iorw,ow
    80006368:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000636c:	00000097          	auipc	ra,0x0
    80006370:	f7a080e7          	jalr	-134(ra) # 800062e6 <pop_off>
}
    80006374:	60e2                	ld	ra,24(sp)
    80006376:	6442                	ld	s0,16(sp)
    80006378:	64a2                	ld	s1,8(sp)
    8000637a:	6105                	addi	sp,sp,32
    8000637c:	8082                	ret
    panic("release");
    8000637e:	00002517          	auipc	a0,0x2
    80006382:	4c250513          	addi	a0,a0,1218 # 80008840 <digits+0x48>
    80006386:	00000097          	auipc	ra,0x0
    8000638a:	9c2080e7          	jalr	-1598(ra) # 80005d48 <panic>
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
