
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00023117          	auipc	sp,0x23
    80000004:	17010113          	addi	sp,sp,368 # 80023170 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	477050ef          	jal	ra,80005c8c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kinit>:
  struct run *freelist[NCPU];
} kmem;

void
kinit()
{
    8000001c:	7159                	addi	sp,sp,-112
    8000001e:	f486                	sd	ra,104(sp)
    80000020:	f0a2                	sd	s0,96(sp)
    80000022:	eca6                	sd	s1,88(sp)
    80000024:	e8ca                	sd	s2,80(sp)
    80000026:	e4ce                	sd	s3,72(sp)
    80000028:	e0d2                	sd	s4,64(sp)
    8000002a:	fc56                	sd	s5,56(sp)
    8000002c:	f85a                	sd	s6,48(sp)
    8000002e:	f45e                	sd	s7,40(sp)
    80000030:	f062                	sd	s8,32(sp)
    80000032:	ec66                	sd	s9,24(sp)
    80000034:	e86a                	sd	s10,16(sp)
    80000036:	e46e                	sd	s11,8(sp)
    80000038:	1880                	addi	s0,sp,112
    for(int i = 0; i < NCPU; i++){
    8000003a:	00009b97          	auipc	s7,0x9
    8000003e:	ff6b8b93          	addi	s7,s7,-10 # 80009030 <kmem>
    80000042:	00009997          	auipc	s3,0x9
    80000046:	0ee98993          	addi	s3,s3,238 # 80009130 <kmem+0x100>
{
    8000004a:	84de                	mv	s1,s7
        initlock(&kmem.lock[i], "kmem");
    8000004c:	00008917          	auipc	s2,0x8
    80000050:	fc490913          	addi	s2,s2,-60 # 80008010 <etext+0x10>
    80000054:	85ca                	mv	a1,s2
    80000056:	8526                	mv	a0,s1
    80000058:	00006097          	auipc	ra,0x6
    8000005c:	794080e7          	jalr	1940(ra) # 800067ec <initlock>
    for(int i = 0; i < NCPU; i++){
    80000060:	02048493          	addi	s1,s1,32
    80000064:	ff3498e3          	bne	s1,s3,80000054 <kinit+0x38>
    }
    //freerange(end,(char*)PHYSTOP);
    char *p = (char*)PGROUNDUP((uint64)end);
    80000068:	0002da17          	auipc	s4,0x2d
    8000006c:	1dfa0a13          	addi	s4,s4,479 # 8002d247 <end+0xfff>
    80000070:	7b7d                	lui	s6,0xfffff
    80000072:	016a7a33          	and	s4,s4,s6
    uint64 memsize = (uint64)PHYSTOP - (uint64)end;
    80000076:	0002c797          	auipc	a5,0x2c
    8000007a:	1d278793          	addi	a5,a5,466 # 8002c248 <end>
    8000007e:	4dc5                	li	s11,17
    80000080:	0dee                	slli	s11,s11,0x1b
    80000082:	40fd8db3          	sub	s11,s11,a5
    80000086:	895e                	mv	s2,s7
    80000088:	8c6e                	mv	s8,s11
    for(int i = 0; i < NCPU; i++){
        for(; p + PGSIZE <= end + memsize*(i+1)/NCPU; p += PGSIZE){
    8000008a:	6a85                	lui	s5,0x1
    8000008c:	7d7d                	lui	s10,0xfffff
    8000008e:	015a0cb3          	add	s9,s4,s5
    80000092:	003c5b13          	srli	s6,s8,0x3
    80000096:	0002c797          	auipc	a5,0x2c
    8000009a:	1b278793          	addi	a5,a5,434 # 8002c248 <end>
    8000009e:	9b3e                	add	s6,s6,a5
    800000a0:	059b6163          	bltu	s6,s9,800000e2 <kinit+0xc6>
            struct run *r = (struct run*)p;
            acquire(&kmem.lock[i]);
    800000a4:	89de                	mv	s3,s7
    800000a6:	84d2                	mv	s1,s4
    800000a8:	414d07b3          	sub	a5,s10,s4
    800000ac:	9b3e                	add	s6,s6,a5
    800000ae:	9a56                	add	s4,s4,s5
    800000b0:	01ab77b3          	and	a5,s6,s10
    800000b4:	9a3e                	add	s4,s4,a5
    800000b6:	854e                	mv	a0,s3
    800000b8:	00006097          	auipc	ra,0x6
    800000bc:	5b8080e7          	jalr	1464(ra) # 80006670 <acquire>
            r->next = kmem.freelist[i];
    800000c0:	10093783          	ld	a5,256(s2)
    800000c4:	e09c                	sd	a5,0(s1)
            kmem.freelist[i] = r;
    800000c6:	10993023          	sd	s1,256(s2)
            release(&kmem.lock[i]);
    800000ca:	854e                	mv	a0,s3
    800000cc:	00006097          	auipc	ra,0x6
    800000d0:	674080e7          	jalr	1652(ra) # 80006740 <release>
        for(; p + PGSIZE <= end + memsize*(i+1)/NCPU; p += PGSIZE){
    800000d4:	94d6                	add	s1,s1,s5
    800000d6:	ff4490e3          	bne	s1,s4,800000b6 <kinit+0x9a>
    800000da:	01ab7b33          	and	s6,s6,s10
    800000de:	016c8a33          	add	s4,s9,s6
    for(int i = 0; i < NCPU; i++){
    800000e2:	9c6e                	add	s8,s8,s11
    800000e4:	020b8b93          	addi	s7,s7,32
    800000e8:	0921                	addi	s2,s2,8
    800000ea:	00009797          	auipc	a5,0x9
    800000ee:	f8678793          	addi	a5,a5,-122 # 80009070 <kmem+0x40>
    800000f2:	f8f91ee3          	bne	s2,a5,8000008e <kinit+0x72>
        }
    }

}
    800000f6:	70a6                	ld	ra,104(sp)
    800000f8:	7406                	ld	s0,96(sp)
    800000fa:	64e6                	ld	s1,88(sp)
    800000fc:	6946                	ld	s2,80(sp)
    800000fe:	69a6                	ld	s3,72(sp)
    80000100:	6a06                	ld	s4,64(sp)
    80000102:	7ae2                	ld	s5,56(sp)
    80000104:	7b42                	ld	s6,48(sp)
    80000106:	7ba2                	ld	s7,40(sp)
    80000108:	7c02                	ld	s8,32(sp)
    8000010a:	6ce2                	ld	s9,24(sp)
    8000010c:	6d42                	ld	s10,16(sp)
    8000010e:	6da2                	ld	s11,8(sp)
    80000110:	6165                	addi	sp,sp,112
    80000112:	8082                	ret

0000000080000114 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000114:	7179                	addi	sp,sp,-48
    80000116:	f406                	sd	ra,40(sp)
    80000118:	f022                	sd	s0,32(sp)
    8000011a:	ec26                	sd	s1,24(sp)
    8000011c:	e84a                	sd	s2,16(sp)
    8000011e:	e44e                	sd	s3,8(sp)
    80000120:	e052                	sd	s4,0(sp)
    80000122:	1800                	addi	s0,sp,48
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000124:	03451793          	slli	a5,a0,0x34
    80000128:	ebad                	bnez	a5,8000019a <kfree+0x86>
    8000012a:	84aa                	mv	s1,a0
    8000012c:	0002c797          	auipc	a5,0x2c
    80000130:	11c78793          	addi	a5,a5,284 # 8002c248 <end>
    80000134:	06f56363          	bltu	a0,a5,8000019a <kfree+0x86>
    80000138:	47c5                	li	a5,17
    8000013a:	07ee                	slli	a5,a5,0x1b
    8000013c:	04f57f63          	bgeu	a0,a5,8000019a <kfree+0x86>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000140:	6605                	lui	a2,0x1
    80000142:	4585                	li	a1,1
    80000144:	00000097          	auipc	ra,0x0
    80000148:	1b0080e7          	jalr	432(ra) # 800002f4 <memset>

  r = (struct run*)pa;
  int CPU = cpuid();
    8000014c:	00001097          	auipc	ra,0x1
    80000150:	e5c080e7          	jalr	-420(ra) # 80000fa8 <cpuid>
    80000154:	892a                	mv	s2,a0
  acquire(&kmem.lock[CPU]);
    80000156:	00009997          	auipc	s3,0x9
    8000015a:	eda98993          	addi	s3,s3,-294 # 80009030 <kmem>
    8000015e:	00551a13          	slli	s4,a0,0x5
    80000162:	9a4e                	add	s4,s4,s3
    80000164:	8552                	mv	a0,s4
    80000166:	00006097          	auipc	ra,0x6
    8000016a:	50a080e7          	jalr	1290(ra) # 80006670 <acquire>
  r->next = kmem.freelist[CPU];
    8000016e:	02090913          	addi	s2,s2,32
    80000172:	090e                	slli	s2,s2,0x3
    80000174:	994e                	add	s2,s2,s3
    80000176:	00093783          	ld	a5,0(s2)
    8000017a:	e09c                	sd	a5,0(s1)
  kmem.freelist[CPU] = r;
    8000017c:	00993023          	sd	s1,0(s2)
  release(&kmem.lock[CPU]);
    80000180:	8552                	mv	a0,s4
    80000182:	00006097          	auipc	ra,0x6
    80000186:	5be080e7          	jalr	1470(ra) # 80006740 <release>
}
    8000018a:	70a2                	ld	ra,40(sp)
    8000018c:	7402                	ld	s0,32(sp)
    8000018e:	64e2                	ld	s1,24(sp)
    80000190:	6942                	ld	s2,16(sp)
    80000192:	69a2                	ld	s3,8(sp)
    80000194:	6a02                	ld	s4,0(sp)
    80000196:	6145                	addi	sp,sp,48
    80000198:	8082                	ret
    panic("kfree");
    8000019a:	00008517          	auipc	a0,0x8
    8000019e:	e7e50513          	addi	a0,a0,-386 # 80008018 <etext+0x18>
    800001a2:	00006097          	auipc	ra,0x6
    800001a6:	f9a080e7          	jalr	-102(ra) # 8000613c <panic>

00000000800001aa <freerange>:
{
    800001aa:	7179                	addi	sp,sp,-48
    800001ac:	f406                	sd	ra,40(sp)
    800001ae:	f022                	sd	s0,32(sp)
    800001b0:	ec26                	sd	s1,24(sp)
    800001b2:	e84a                	sd	s2,16(sp)
    800001b4:	e44e                	sd	s3,8(sp)
    800001b6:	e052                	sd	s4,0(sp)
    800001b8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800001ba:	6785                	lui	a5,0x1
    800001bc:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800001c0:	94aa                	add	s1,s1,a0
    800001c2:	757d                	lui	a0,0xfffff
    800001c4:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800001c6:	94be                	add	s1,s1,a5
    800001c8:	0095ee63          	bltu	a1,s1,800001e4 <freerange+0x3a>
    800001cc:	892e                	mv	s2,a1
    kfree(p);
    800001ce:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800001d0:	6985                	lui	s3,0x1
    kfree(p);
    800001d2:	01448533          	add	a0,s1,s4
    800001d6:	00000097          	auipc	ra,0x0
    800001da:	f3e080e7          	jalr	-194(ra) # 80000114 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800001de:	94ce                	add	s1,s1,s3
    800001e0:	fe9979e3          	bgeu	s2,s1,800001d2 <freerange+0x28>
}
    800001e4:	70a2                	ld	ra,40(sp)
    800001e6:	7402                	ld	s0,32(sp)
    800001e8:	64e2                	ld	s1,24(sp)
    800001ea:	6942                	ld	s2,16(sp)
    800001ec:	69a2                	ld	s3,8(sp)
    800001ee:	6a02                	ld	s4,0(sp)
    800001f0:	6145                	addi	sp,sp,48
    800001f2:	8082                	ret

00000000800001f4 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800001f4:	711d                	addi	sp,sp,-96
    800001f6:	ec86                	sd	ra,88(sp)
    800001f8:	e8a2                	sd	s0,80(sp)
    800001fa:	e4a6                	sd	s1,72(sp)
    800001fc:	e0ca                	sd	s2,64(sp)
    800001fe:	fc4e                	sd	s3,56(sp)
    80000200:	f852                	sd	s4,48(sp)
    80000202:	f456                	sd	s5,40(sp)
    80000204:	f05a                	sd	s6,32(sp)
    80000206:	ec5e                	sd	s7,24(sp)
    80000208:	e862                	sd	s8,16(sp)
    8000020a:	e466                	sd	s9,8(sp)
    8000020c:	1080                	addi	s0,sp,96
  struct run *r;
  int CPU = cpuid();
    8000020e:	00001097          	auipc	ra,0x1
    80000212:	d9a080e7          	jalr	-614(ra) # 80000fa8 <cpuid>
    80000216:	84aa                	mv	s1,a0
  acquire(&kmem.lock[CPU]);
    80000218:	00009917          	auipc	s2,0x9
    8000021c:	e1890913          	addi	s2,s2,-488 # 80009030 <kmem>
    80000220:	00551a93          	slli	s5,a0,0x5
    80000224:	9aca                	add	s5,s5,s2
    80000226:	8556                	mv	a0,s5
    80000228:	00006097          	auipc	ra,0x6
    8000022c:	448080e7          	jalr	1096(ra) # 80006670 <acquire>
  r = kmem.freelist[CPU];
    80000230:	02048793          	addi	a5,s1,32
    80000234:	078e                	slli	a5,a5,0x3
    80000236:	993e                	add	s2,s2,a5
    80000238:	00093b03          	ld	s6,0(s2)
  if(r)
    8000023c:	040b0063          	beqz	s6,8000027c <kalloc+0x88>
    kmem.freelist[CPU] = r->next;
    80000240:	000b3783          	ld	a5,0(s6) # fffffffffffff000 <end+0xffffffff7ffd2db8>
    80000244:	00f93023          	sd	a5,0(s2)
              }
              release(&kmem.lock[i]);
          }
      }
  }
  release(&kmem.lock[CPU]);
    80000248:	8556                	mv	a0,s5
    8000024a:	00006097          	auipc	ra,0x6
    8000024e:	4f6080e7          	jalr	1270(ra) # 80006740 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000252:	6605                	lui	a2,0x1
    80000254:	4595                	li	a1,5
    80000256:	855a                	mv	a0,s6
    80000258:	00000097          	auipc	ra,0x0
    8000025c:	09c080e7          	jalr	156(ra) # 800002f4 <memset>
  return (void*)r;
}
    80000260:	855a                	mv	a0,s6
    80000262:	60e6                	ld	ra,88(sp)
    80000264:	6446                	ld	s0,80(sp)
    80000266:	64a6                	ld	s1,72(sp)
    80000268:	6906                	ld	s2,64(sp)
    8000026a:	79e2                	ld	s3,56(sp)
    8000026c:	7a42                	ld	s4,48(sp)
    8000026e:	7aa2                	ld	s5,40(sp)
    80000270:	7b02                	ld	s6,32(sp)
    80000272:	6be2                	ld	s7,24(sp)
    80000274:	6c42                	ld	s8,16(sp)
    80000276:	6ca2                	ld	s9,8(sp)
    80000278:	6125                	addi	sp,sp,96
    8000027a:	8082                	ret
    8000027c:	00009997          	auipc	s3,0x9
    80000280:	db498993          	addi	s3,s3,-588 # 80009030 <kmem>
    80000284:	00299c93          	slli	s9,s3,0x2
    80000288:	41998cb3          	sub	s9,s3,s9
      for(int i = 0; i < NCPU; i++){
    8000028c:	4901                	li	s2,0
    8000028e:	4c21                	li	s8,8
    80000290:	a805                	j	800002c0 <kalloc+0xcc>
                  kmem.freelist[i] = r->next;
    80000292:	000bb703          	ld	a4,0(s7)
    80000296:	02090913          	addi	s2,s2,32
    8000029a:	090e                	slli	s2,s2,0x3
    8000029c:	00009797          	auipc	a5,0x9
    800002a0:	d9478793          	addi	a5,a5,-620 # 80009030 <kmem>
    800002a4:	993e                	add	s2,s2,a5
    800002a6:	00e93023          	sd	a4,0(s2)
                  release(&kmem.lock[i]);
    800002aa:	8552                	mv	a0,s4
    800002ac:	00006097          	auipc	ra,0x6
    800002b0:	494080e7          	jalr	1172(ra) # 80006740 <release>
              if(kmem.freelist[i]){
    800002b4:	8b5e                	mv	s6,s7
                  break;
    800002b6:	bf49                	j	80000248 <kalloc+0x54>
      for(int i = 0; i < NCPU; i++){
    800002b8:	2905                	addiw	s2,s2,1
    800002ba:	09a1                	addi	s3,s3,8
    800002bc:	03890663          	beq	s2,s8,800002e8 <kalloc+0xf4>
          if(i != CPU){
    800002c0:	ff248ce3          	beq	s1,s2,800002b8 <kalloc+0xc4>
              acquire(&kmem.lock[i]);
    800002c4:	00299a13          	slli	s4,s3,0x2
    800002c8:	9a66                	add	s4,s4,s9
    800002ca:	8552                	mv	a0,s4
    800002cc:	00006097          	auipc	ra,0x6
    800002d0:	3a4080e7          	jalr	932(ra) # 80006670 <acquire>
              if(kmem.freelist[i]){
    800002d4:	1009bb83          	ld	s7,256(s3)
    800002d8:	fa0b9de3          	bnez	s7,80000292 <kalloc+0x9e>
              release(&kmem.lock[i]);
    800002dc:	8552                	mv	a0,s4
    800002de:	00006097          	auipc	ra,0x6
    800002e2:	462080e7          	jalr	1122(ra) # 80006740 <release>
    800002e6:	bfc9                	j	800002b8 <kalloc+0xc4>
  release(&kmem.lock[CPU]);
    800002e8:	8556                	mv	a0,s5
    800002ea:	00006097          	auipc	ra,0x6
    800002ee:	456080e7          	jalr	1110(ra) # 80006740 <release>
  if(r)
    800002f2:	b7bd                	j	80000260 <kalloc+0x6c>

00000000800002f4 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800002f4:	1141                	addi	sp,sp,-16
    800002f6:	e422                	sd	s0,8(sp)
    800002f8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800002fa:	ce09                	beqz	a2,80000314 <memset+0x20>
    800002fc:	87aa                	mv	a5,a0
    800002fe:	fff6071b          	addiw	a4,a2,-1
    80000302:	1702                	slli	a4,a4,0x20
    80000304:	9301                	srli	a4,a4,0x20
    80000306:	0705                	addi	a4,a4,1
    80000308:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000030a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000030e:	0785                	addi	a5,a5,1
    80000310:	fee79de3          	bne	a5,a4,8000030a <memset+0x16>
  }
  return dst;
}
    80000314:	6422                	ld	s0,8(sp)
    80000316:	0141                	addi	sp,sp,16
    80000318:	8082                	ret

000000008000031a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000031a:	1141                	addi	sp,sp,-16
    8000031c:	e422                	sd	s0,8(sp)
    8000031e:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000320:	ca05                	beqz	a2,80000350 <memcmp+0x36>
    80000322:	fff6069b          	addiw	a3,a2,-1
    80000326:	1682                	slli	a3,a3,0x20
    80000328:	9281                	srli	a3,a3,0x20
    8000032a:	0685                	addi	a3,a3,1
    8000032c:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000032e:	00054783          	lbu	a5,0(a0) # fffffffffffff000 <end+0xffffffff7ffd2db8>
    80000332:	0005c703          	lbu	a4,0(a1)
    80000336:	00e79863          	bne	a5,a4,80000346 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    8000033a:	0505                	addi	a0,a0,1
    8000033c:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000033e:	fed518e3          	bne	a0,a3,8000032e <memcmp+0x14>
  }

  return 0;
    80000342:	4501                	li	a0,0
    80000344:	a019                	j	8000034a <memcmp+0x30>
      return *s1 - *s2;
    80000346:	40e7853b          	subw	a0,a5,a4
}
    8000034a:	6422                	ld	s0,8(sp)
    8000034c:	0141                	addi	sp,sp,16
    8000034e:	8082                	ret
  return 0;
    80000350:	4501                	li	a0,0
    80000352:	bfe5                	j	8000034a <memcmp+0x30>

0000000080000354 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000354:	1141                	addi	sp,sp,-16
    80000356:	e422                	sd	s0,8(sp)
    80000358:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    8000035a:	ca0d                	beqz	a2,8000038c <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000035c:	00a5f963          	bgeu	a1,a0,8000036e <memmove+0x1a>
    80000360:	02061693          	slli	a3,a2,0x20
    80000364:	9281                	srli	a3,a3,0x20
    80000366:	00d58733          	add	a4,a1,a3
    8000036a:	02e56463          	bltu	a0,a4,80000392 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000036e:	fff6079b          	addiw	a5,a2,-1
    80000372:	1782                	slli	a5,a5,0x20
    80000374:	9381                	srli	a5,a5,0x20
    80000376:	0785                	addi	a5,a5,1
    80000378:	97ae                	add	a5,a5,a1
    8000037a:	872a                	mv	a4,a0
      *d++ = *s++;
    8000037c:	0585                	addi	a1,a1,1
    8000037e:	0705                	addi	a4,a4,1
    80000380:	fff5c683          	lbu	a3,-1(a1)
    80000384:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000388:	fef59ae3          	bne	a1,a5,8000037c <memmove+0x28>

  return dst;
}
    8000038c:	6422                	ld	s0,8(sp)
    8000038e:	0141                	addi	sp,sp,16
    80000390:	8082                	ret
    d += n;
    80000392:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000394:	fff6079b          	addiw	a5,a2,-1
    80000398:	1782                	slli	a5,a5,0x20
    8000039a:	9381                	srli	a5,a5,0x20
    8000039c:	fff7c793          	not	a5,a5
    800003a0:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800003a2:	177d                	addi	a4,a4,-1
    800003a4:	16fd                	addi	a3,a3,-1
    800003a6:	00074603          	lbu	a2,0(a4)
    800003aa:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800003ae:	fef71ae3          	bne	a4,a5,800003a2 <memmove+0x4e>
    800003b2:	bfe9                	j	8000038c <memmove+0x38>

00000000800003b4 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800003b4:	1141                	addi	sp,sp,-16
    800003b6:	e406                	sd	ra,8(sp)
    800003b8:	e022                	sd	s0,0(sp)
    800003ba:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	f98080e7          	jalr	-104(ra) # 80000354 <memmove>
}
    800003c4:	60a2                	ld	ra,8(sp)
    800003c6:	6402                	ld	s0,0(sp)
    800003c8:	0141                	addi	sp,sp,16
    800003ca:	8082                	ret

00000000800003cc <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800003cc:	1141                	addi	sp,sp,-16
    800003ce:	e422                	sd	s0,8(sp)
    800003d0:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800003d2:	ce11                	beqz	a2,800003ee <strncmp+0x22>
    800003d4:	00054783          	lbu	a5,0(a0)
    800003d8:	cf89                	beqz	a5,800003f2 <strncmp+0x26>
    800003da:	0005c703          	lbu	a4,0(a1)
    800003de:	00f71a63          	bne	a4,a5,800003f2 <strncmp+0x26>
    n--, p++, q++;
    800003e2:	367d                	addiw	a2,a2,-1
    800003e4:	0505                	addi	a0,a0,1
    800003e6:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800003e8:	f675                	bnez	a2,800003d4 <strncmp+0x8>
  if(n == 0)
    return 0;
    800003ea:	4501                	li	a0,0
    800003ec:	a809                	j	800003fe <strncmp+0x32>
    800003ee:	4501                	li	a0,0
    800003f0:	a039                	j	800003fe <strncmp+0x32>
  if(n == 0)
    800003f2:	ca09                	beqz	a2,80000404 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800003f4:	00054503          	lbu	a0,0(a0)
    800003f8:	0005c783          	lbu	a5,0(a1)
    800003fc:	9d1d                	subw	a0,a0,a5
}
    800003fe:	6422                	ld	s0,8(sp)
    80000400:	0141                	addi	sp,sp,16
    80000402:	8082                	ret
    return 0;
    80000404:	4501                	li	a0,0
    80000406:	bfe5                	j	800003fe <strncmp+0x32>

0000000080000408 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000408:	1141                	addi	sp,sp,-16
    8000040a:	e422                	sd	s0,8(sp)
    8000040c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000040e:	872a                	mv	a4,a0
    80000410:	8832                	mv	a6,a2
    80000412:	367d                	addiw	a2,a2,-1
    80000414:	01005963          	blez	a6,80000426 <strncpy+0x1e>
    80000418:	0705                	addi	a4,a4,1
    8000041a:	0005c783          	lbu	a5,0(a1)
    8000041e:	fef70fa3          	sb	a5,-1(a4)
    80000422:	0585                	addi	a1,a1,1
    80000424:	f7f5                	bnez	a5,80000410 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000426:	00c05d63          	blez	a2,80000440 <strncpy+0x38>
    8000042a:	86ba                	mv	a3,a4
    *s++ = 0;
    8000042c:	0685                	addi	a3,a3,1
    8000042e:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000432:	fff6c793          	not	a5,a3
    80000436:	9fb9                	addw	a5,a5,a4
    80000438:	010787bb          	addw	a5,a5,a6
    8000043c:	fef048e3          	bgtz	a5,8000042c <strncpy+0x24>
  return os;
}
    80000440:	6422                	ld	s0,8(sp)
    80000442:	0141                	addi	sp,sp,16
    80000444:	8082                	ret

0000000080000446 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000446:	1141                	addi	sp,sp,-16
    80000448:	e422                	sd	s0,8(sp)
    8000044a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000044c:	02c05363          	blez	a2,80000472 <safestrcpy+0x2c>
    80000450:	fff6069b          	addiw	a3,a2,-1
    80000454:	1682                	slli	a3,a3,0x20
    80000456:	9281                	srli	a3,a3,0x20
    80000458:	96ae                	add	a3,a3,a1
    8000045a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000045c:	00d58963          	beq	a1,a3,8000046e <safestrcpy+0x28>
    80000460:	0585                	addi	a1,a1,1
    80000462:	0785                	addi	a5,a5,1
    80000464:	fff5c703          	lbu	a4,-1(a1)
    80000468:	fee78fa3          	sb	a4,-1(a5)
    8000046c:	fb65                	bnez	a4,8000045c <safestrcpy+0x16>
    ;
  *s = 0;
    8000046e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000472:	6422                	ld	s0,8(sp)
    80000474:	0141                	addi	sp,sp,16
    80000476:	8082                	ret

0000000080000478 <strlen>:

int
strlen(const char *s)
{
    80000478:	1141                	addi	sp,sp,-16
    8000047a:	e422                	sd	s0,8(sp)
    8000047c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000047e:	00054783          	lbu	a5,0(a0)
    80000482:	cf91                	beqz	a5,8000049e <strlen+0x26>
    80000484:	0505                	addi	a0,a0,1
    80000486:	87aa                	mv	a5,a0
    80000488:	4685                	li	a3,1
    8000048a:	9e89                	subw	a3,a3,a0
    8000048c:	00f6853b          	addw	a0,a3,a5
    80000490:	0785                	addi	a5,a5,1
    80000492:	fff7c703          	lbu	a4,-1(a5)
    80000496:	fb7d                	bnez	a4,8000048c <strlen+0x14>
    ;
  return n;
}
    80000498:	6422                	ld	s0,8(sp)
    8000049a:	0141                	addi	sp,sp,16
    8000049c:	8082                	ret
  for(n = 0; s[n]; n++)
    8000049e:	4501                	li	a0,0
    800004a0:	bfe5                	j	80000498 <strlen+0x20>

00000000800004a2 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800004a2:	1101                	addi	sp,sp,-32
    800004a4:	ec06                	sd	ra,24(sp)
    800004a6:	e822                	sd	s0,16(sp)
    800004a8:	e426                	sd	s1,8(sp)
    800004aa:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800004ac:	00001097          	auipc	ra,0x1
    800004b0:	afc080e7          	jalr	-1284(ra) # 80000fa8 <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    800004b4:	00009497          	auipc	s1,0x9
    800004b8:	b4c48493          	addi	s1,s1,-1204 # 80009000 <started>
  if(cpuid() == 0){
    800004bc:	c531                	beqz	a0,80000508 <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    800004be:	8526                	mv	a0,s1
    800004c0:	00006097          	auipc	ra,0x6
    800004c4:	3c2080e7          	jalr	962(ra) # 80006882 <lockfree_read4>
    800004c8:	d97d                	beqz	a0,800004be <main+0x1c>
      ;
    __sync_synchronize();
    800004ca:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800004ce:	00001097          	auipc	ra,0x1
    800004d2:	ada080e7          	jalr	-1318(ra) # 80000fa8 <cpuid>
    800004d6:	85aa                	mv	a1,a0
    800004d8:	00008517          	auipc	a0,0x8
    800004dc:	b6050513          	addi	a0,a0,-1184 # 80008038 <etext+0x38>
    800004e0:	00006097          	auipc	ra,0x6
    800004e4:	ca6080e7          	jalr	-858(ra) # 80006186 <printf>
    kvminithart();    // turn on paging
    800004e8:	00000097          	auipc	ra,0x0
    800004ec:	0e0080e7          	jalr	224(ra) # 800005c8 <kvminithart>
    trapinithart();   // install kernel trap vector
    800004f0:	00001097          	auipc	ra,0x1
    800004f4:	730080e7          	jalr	1840(ra) # 80001c20 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800004f8:	00005097          	auipc	ra,0x5
    800004fc:	de8080e7          	jalr	-536(ra) # 800052e0 <plicinithart>
  }

  scheduler();        
    80000500:	00001097          	auipc	ra,0x1
    80000504:	fde080e7          	jalr	-34(ra) # 800014de <scheduler>
    consoleinit();
    80000508:	00006097          	auipc	ra,0x6
    8000050c:	b46080e7          	jalr	-1210(ra) # 8000604e <consoleinit>
    statsinit();
    80000510:	00005097          	auipc	ra,0x5
    80000514:	4b6080e7          	jalr	1206(ra) # 800059c6 <statsinit>
    printfinit();
    80000518:	00006097          	auipc	ra,0x6
    8000051c:	e54080e7          	jalr	-428(ra) # 8000636c <printfinit>
    printf("\n");
    80000520:	00008517          	auipc	a0,0x8
    80000524:	35850513          	addi	a0,a0,856 # 80008878 <digits+0x88>
    80000528:	00006097          	auipc	ra,0x6
    8000052c:	c5e080e7          	jalr	-930(ra) # 80006186 <printf>
    printf("xv6 kernel is booting\n");
    80000530:	00008517          	auipc	a0,0x8
    80000534:	af050513          	addi	a0,a0,-1296 # 80008020 <etext+0x20>
    80000538:	00006097          	auipc	ra,0x6
    8000053c:	c4e080e7          	jalr	-946(ra) # 80006186 <printf>
    printf("\n");
    80000540:	00008517          	auipc	a0,0x8
    80000544:	33850513          	addi	a0,a0,824 # 80008878 <digits+0x88>
    80000548:	00006097          	auipc	ra,0x6
    8000054c:	c3e080e7          	jalr	-962(ra) # 80006186 <printf>
    kinit();         // physical page allocator
    80000550:	00000097          	auipc	ra,0x0
    80000554:	acc080e7          	jalr	-1332(ra) # 8000001c <kinit>
    kvminit();       // create kernel page table
    80000558:	00000097          	auipc	ra,0x0
    8000055c:	322080e7          	jalr	802(ra) # 8000087a <kvminit>
    kvminithart();   // turn on paging
    80000560:	00000097          	auipc	ra,0x0
    80000564:	068080e7          	jalr	104(ra) # 800005c8 <kvminithart>
    procinit();      // process table
    80000568:	00001097          	auipc	ra,0x1
    8000056c:	990080e7          	jalr	-1648(ra) # 80000ef8 <procinit>
    trapinit();      // trap vectors
    80000570:	00001097          	auipc	ra,0x1
    80000574:	688080e7          	jalr	1672(ra) # 80001bf8 <trapinit>
    trapinithart();  // install kernel trap vector
    80000578:	00001097          	auipc	ra,0x1
    8000057c:	6a8080e7          	jalr	1704(ra) # 80001c20 <trapinithart>
    plicinit();      // set up interrupt controller
    80000580:	00005097          	auipc	ra,0x5
    80000584:	d4a080e7          	jalr	-694(ra) # 800052ca <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000588:	00005097          	auipc	ra,0x5
    8000058c:	d58080e7          	jalr	-680(ra) # 800052e0 <plicinithart>
    binit();         // buffer cache
    80000590:	00002097          	auipc	ra,0x2
    80000594:	dd2080e7          	jalr	-558(ra) # 80002362 <binit>
    iinit();         // inode table
    80000598:	00002097          	auipc	ra,0x2
    8000059c:	5b6080e7          	jalr	1462(ra) # 80002b4e <iinit>
    fileinit();      // file table
    800005a0:	00003097          	auipc	ra,0x3
    800005a4:	560080e7          	jalr	1376(ra) # 80003b00 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800005a8:	00005097          	auipc	ra,0x5
    800005ac:	e5a080e7          	jalr	-422(ra) # 80005402 <virtio_disk_init>
    userinit();      // first user process
    800005b0:	00001097          	auipc	ra,0x1
    800005b4:	cfc080e7          	jalr	-772(ra) # 800012ac <userinit>
    __sync_synchronize();
    800005b8:	0ff0000f          	fence
    started = 1;
    800005bc:	4785                	li	a5,1
    800005be:	00009717          	auipc	a4,0x9
    800005c2:	a4f72123          	sw	a5,-1470(a4) # 80009000 <started>
    800005c6:	bf2d                	j	80000500 <main+0x5e>

00000000800005c8 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800005c8:	1141                	addi	sp,sp,-16
    800005ca:	e422                	sd	s0,8(sp)
    800005cc:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    800005ce:	00009797          	auipc	a5,0x9
    800005d2:	a3a7b783          	ld	a5,-1478(a5) # 80009008 <kernel_pagetable>
    800005d6:	83b1                	srli	a5,a5,0xc
    800005d8:	577d                	li	a4,-1
    800005da:	177e                	slli	a4,a4,0x3f
    800005dc:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    800005de:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800005e2:	12000073          	sfence.vma
  sfence_vma();
}
    800005e6:	6422                	ld	s0,8(sp)
    800005e8:	0141                	addi	sp,sp,16
    800005ea:	8082                	ret

00000000800005ec <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800005ec:	7139                	addi	sp,sp,-64
    800005ee:	fc06                	sd	ra,56(sp)
    800005f0:	f822                	sd	s0,48(sp)
    800005f2:	f426                	sd	s1,40(sp)
    800005f4:	f04a                	sd	s2,32(sp)
    800005f6:	ec4e                	sd	s3,24(sp)
    800005f8:	e852                	sd	s4,16(sp)
    800005fa:	e456                	sd	s5,8(sp)
    800005fc:	e05a                	sd	s6,0(sp)
    800005fe:	0080                	addi	s0,sp,64
    80000600:	84aa                	mv	s1,a0
    80000602:	89ae                	mv	s3,a1
    80000604:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000606:	57fd                	li	a5,-1
    80000608:	83e9                	srli	a5,a5,0x1a
    8000060a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000060c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000060e:	04b7f263          	bgeu	a5,a1,80000652 <walk+0x66>
    panic("walk");
    80000612:	00008517          	auipc	a0,0x8
    80000616:	a3e50513          	addi	a0,a0,-1474 # 80008050 <etext+0x50>
    8000061a:	00006097          	auipc	ra,0x6
    8000061e:	b22080e7          	jalr	-1246(ra) # 8000613c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000622:	060a8663          	beqz	s5,8000068e <walk+0xa2>
    80000626:	00000097          	auipc	ra,0x0
    8000062a:	bce080e7          	jalr	-1074(ra) # 800001f4 <kalloc>
    8000062e:	84aa                	mv	s1,a0
    80000630:	c529                	beqz	a0,8000067a <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000632:	6605                	lui	a2,0x1
    80000634:	4581                	li	a1,0
    80000636:	00000097          	auipc	ra,0x0
    8000063a:	cbe080e7          	jalr	-834(ra) # 800002f4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000063e:	00c4d793          	srli	a5,s1,0xc
    80000642:	07aa                	slli	a5,a5,0xa
    80000644:	0017e793          	ori	a5,a5,1
    80000648:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000064c:	3a5d                	addiw	s4,s4,-9
    8000064e:	036a0063          	beq	s4,s6,8000066e <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000652:	0149d933          	srl	s2,s3,s4
    80000656:	1ff97913          	andi	s2,s2,511
    8000065a:	090e                	slli	s2,s2,0x3
    8000065c:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000065e:	00093483          	ld	s1,0(s2)
    80000662:	0014f793          	andi	a5,s1,1
    80000666:	dfd5                	beqz	a5,80000622 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000668:	80a9                	srli	s1,s1,0xa
    8000066a:	04b2                	slli	s1,s1,0xc
    8000066c:	b7c5                	j	8000064c <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000066e:	00c9d513          	srli	a0,s3,0xc
    80000672:	1ff57513          	andi	a0,a0,511
    80000676:	050e                	slli	a0,a0,0x3
    80000678:	9526                	add	a0,a0,s1
}
    8000067a:	70e2                	ld	ra,56(sp)
    8000067c:	7442                	ld	s0,48(sp)
    8000067e:	74a2                	ld	s1,40(sp)
    80000680:	7902                	ld	s2,32(sp)
    80000682:	69e2                	ld	s3,24(sp)
    80000684:	6a42                	ld	s4,16(sp)
    80000686:	6aa2                	ld	s5,8(sp)
    80000688:	6b02                	ld	s6,0(sp)
    8000068a:	6121                	addi	sp,sp,64
    8000068c:	8082                	ret
        return 0;
    8000068e:	4501                	li	a0,0
    80000690:	b7ed                	j	8000067a <walk+0x8e>

0000000080000692 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000692:	57fd                	li	a5,-1
    80000694:	83e9                	srli	a5,a5,0x1a
    80000696:	00b7f463          	bgeu	a5,a1,8000069e <walkaddr+0xc>
    return 0;
    8000069a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000069c:	8082                	ret
{
    8000069e:	1141                	addi	sp,sp,-16
    800006a0:	e406                	sd	ra,8(sp)
    800006a2:	e022                	sd	s0,0(sp)
    800006a4:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800006a6:	4601                	li	a2,0
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	f44080e7          	jalr	-188(ra) # 800005ec <walk>
  if(pte == 0)
    800006b0:	c105                	beqz	a0,800006d0 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800006b2:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800006b4:	0117f693          	andi	a3,a5,17
    800006b8:	4745                	li	a4,17
    return 0;
    800006ba:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800006bc:	00e68663          	beq	a3,a4,800006c8 <walkaddr+0x36>
}
    800006c0:	60a2                	ld	ra,8(sp)
    800006c2:	6402                	ld	s0,0(sp)
    800006c4:	0141                	addi	sp,sp,16
    800006c6:	8082                	ret
  pa = PTE2PA(*pte);
    800006c8:	00a7d513          	srli	a0,a5,0xa
    800006cc:	0532                	slli	a0,a0,0xc
  return pa;
    800006ce:	bfcd                	j	800006c0 <walkaddr+0x2e>
    return 0;
    800006d0:	4501                	li	a0,0
    800006d2:	b7fd                	j	800006c0 <walkaddr+0x2e>

00000000800006d4 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800006d4:	715d                	addi	sp,sp,-80
    800006d6:	e486                	sd	ra,72(sp)
    800006d8:	e0a2                	sd	s0,64(sp)
    800006da:	fc26                	sd	s1,56(sp)
    800006dc:	f84a                	sd	s2,48(sp)
    800006de:	f44e                	sd	s3,40(sp)
    800006e0:	f052                	sd	s4,32(sp)
    800006e2:	ec56                	sd	s5,24(sp)
    800006e4:	e85a                	sd	s6,16(sp)
    800006e6:	e45e                	sd	s7,8(sp)
    800006e8:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800006ea:	c205                	beqz	a2,8000070a <mappages+0x36>
    800006ec:	8aaa                	mv	s5,a0
    800006ee:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800006f0:	77fd                	lui	a5,0xfffff
    800006f2:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800006f6:	15fd                	addi	a1,a1,-1
    800006f8:	00c589b3          	add	s3,a1,a2
    800006fc:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000700:	8952                	mv	s2,s4
    80000702:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000706:	6b85                	lui	s7,0x1
    80000708:	a015                	j	8000072c <mappages+0x58>
    panic("mappages: size");
    8000070a:	00008517          	auipc	a0,0x8
    8000070e:	94e50513          	addi	a0,a0,-1714 # 80008058 <etext+0x58>
    80000712:	00006097          	auipc	ra,0x6
    80000716:	a2a080e7          	jalr	-1494(ra) # 8000613c <panic>
      panic("mappages: remap");
    8000071a:	00008517          	auipc	a0,0x8
    8000071e:	94e50513          	addi	a0,a0,-1714 # 80008068 <etext+0x68>
    80000722:	00006097          	auipc	ra,0x6
    80000726:	a1a080e7          	jalr	-1510(ra) # 8000613c <panic>
    a += PGSIZE;
    8000072a:	995e                	add	s2,s2,s7
  for(;;){
    8000072c:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000730:	4605                	li	a2,1
    80000732:	85ca                	mv	a1,s2
    80000734:	8556                	mv	a0,s5
    80000736:	00000097          	auipc	ra,0x0
    8000073a:	eb6080e7          	jalr	-330(ra) # 800005ec <walk>
    8000073e:	cd19                	beqz	a0,8000075c <mappages+0x88>
    if(*pte & PTE_V)
    80000740:	611c                	ld	a5,0(a0)
    80000742:	8b85                	andi	a5,a5,1
    80000744:	fbf9                	bnez	a5,8000071a <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000746:	80b1                	srli	s1,s1,0xc
    80000748:	04aa                	slli	s1,s1,0xa
    8000074a:	0164e4b3          	or	s1,s1,s6
    8000074e:	0014e493          	ori	s1,s1,1
    80000752:	e104                	sd	s1,0(a0)
    if(a == last)
    80000754:	fd391be3          	bne	s2,s3,8000072a <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    80000758:	4501                	li	a0,0
    8000075a:	a011                	j	8000075e <mappages+0x8a>
      return -1;
    8000075c:	557d                	li	a0,-1
}
    8000075e:	60a6                	ld	ra,72(sp)
    80000760:	6406                	ld	s0,64(sp)
    80000762:	74e2                	ld	s1,56(sp)
    80000764:	7942                	ld	s2,48(sp)
    80000766:	79a2                	ld	s3,40(sp)
    80000768:	7a02                	ld	s4,32(sp)
    8000076a:	6ae2                	ld	s5,24(sp)
    8000076c:	6b42                	ld	s6,16(sp)
    8000076e:	6ba2                	ld	s7,8(sp)
    80000770:	6161                	addi	sp,sp,80
    80000772:	8082                	ret

0000000080000774 <kvmmap>:
{
    80000774:	1141                	addi	sp,sp,-16
    80000776:	e406                	sd	ra,8(sp)
    80000778:	e022                	sd	s0,0(sp)
    8000077a:	0800                	addi	s0,sp,16
    8000077c:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000077e:	86b2                	mv	a3,a2
    80000780:	863e                	mv	a2,a5
    80000782:	00000097          	auipc	ra,0x0
    80000786:	f52080e7          	jalr	-174(ra) # 800006d4 <mappages>
    8000078a:	e509                	bnez	a0,80000794 <kvmmap+0x20>
}
    8000078c:	60a2                	ld	ra,8(sp)
    8000078e:	6402                	ld	s0,0(sp)
    80000790:	0141                	addi	sp,sp,16
    80000792:	8082                	ret
    panic("kvmmap");
    80000794:	00008517          	auipc	a0,0x8
    80000798:	8e450513          	addi	a0,a0,-1820 # 80008078 <etext+0x78>
    8000079c:	00006097          	auipc	ra,0x6
    800007a0:	9a0080e7          	jalr	-1632(ra) # 8000613c <panic>

00000000800007a4 <kvmmake>:
{
    800007a4:	1101                	addi	sp,sp,-32
    800007a6:	ec06                	sd	ra,24(sp)
    800007a8:	e822                	sd	s0,16(sp)
    800007aa:	e426                	sd	s1,8(sp)
    800007ac:	e04a                	sd	s2,0(sp)
    800007ae:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	a44080e7          	jalr	-1468(ra) # 800001f4 <kalloc>
    800007b8:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800007ba:	6605                	lui	a2,0x1
    800007bc:	4581                	li	a1,0
    800007be:	00000097          	auipc	ra,0x0
    800007c2:	b36080e7          	jalr	-1226(ra) # 800002f4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800007c6:	4719                	li	a4,6
    800007c8:	6685                	lui	a3,0x1
    800007ca:	10000637          	lui	a2,0x10000
    800007ce:	100005b7          	lui	a1,0x10000
    800007d2:	8526                	mv	a0,s1
    800007d4:	00000097          	auipc	ra,0x0
    800007d8:	fa0080e7          	jalr	-96(ra) # 80000774 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800007dc:	4719                	li	a4,6
    800007de:	6685                	lui	a3,0x1
    800007e0:	10001637          	lui	a2,0x10001
    800007e4:	100015b7          	lui	a1,0x10001
    800007e8:	8526                	mv	a0,s1
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	f8a080e7          	jalr	-118(ra) # 80000774 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800007f2:	4719                	li	a4,6
    800007f4:	004006b7          	lui	a3,0x400
    800007f8:	0c000637          	lui	a2,0xc000
    800007fc:	0c0005b7          	lui	a1,0xc000
    80000800:	8526                	mv	a0,s1
    80000802:	00000097          	auipc	ra,0x0
    80000806:	f72080e7          	jalr	-142(ra) # 80000774 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000080a:	00007917          	auipc	s2,0x7
    8000080e:	7f690913          	addi	s2,s2,2038 # 80008000 <etext>
    80000812:	4729                	li	a4,10
    80000814:	80007697          	auipc	a3,0x80007
    80000818:	7ec68693          	addi	a3,a3,2028 # 8000 <_entry-0x7fff8000>
    8000081c:	4605                	li	a2,1
    8000081e:	067e                	slli	a2,a2,0x1f
    80000820:	85b2                	mv	a1,a2
    80000822:	8526                	mv	a0,s1
    80000824:	00000097          	auipc	ra,0x0
    80000828:	f50080e7          	jalr	-176(ra) # 80000774 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000082c:	4719                	li	a4,6
    8000082e:	46c5                	li	a3,17
    80000830:	06ee                	slli	a3,a3,0x1b
    80000832:	412686b3          	sub	a3,a3,s2
    80000836:	864a                	mv	a2,s2
    80000838:	85ca                	mv	a1,s2
    8000083a:	8526                	mv	a0,s1
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	f38080e7          	jalr	-200(ra) # 80000774 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000844:	4729                	li	a4,10
    80000846:	6685                	lui	a3,0x1
    80000848:	00006617          	auipc	a2,0x6
    8000084c:	7b860613          	addi	a2,a2,1976 # 80007000 <_trampoline>
    80000850:	040005b7          	lui	a1,0x4000
    80000854:	15fd                	addi	a1,a1,-1
    80000856:	05b2                	slli	a1,a1,0xc
    80000858:	8526                	mv	a0,s1
    8000085a:	00000097          	auipc	ra,0x0
    8000085e:	f1a080e7          	jalr	-230(ra) # 80000774 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000862:	8526                	mv	a0,s1
    80000864:	00000097          	auipc	ra,0x0
    80000868:	5fe080e7          	jalr	1534(ra) # 80000e62 <proc_mapstacks>
}
    8000086c:	8526                	mv	a0,s1
    8000086e:	60e2                	ld	ra,24(sp)
    80000870:	6442                	ld	s0,16(sp)
    80000872:	64a2                	ld	s1,8(sp)
    80000874:	6902                	ld	s2,0(sp)
    80000876:	6105                	addi	sp,sp,32
    80000878:	8082                	ret

000000008000087a <kvminit>:
{
    8000087a:	1141                	addi	sp,sp,-16
    8000087c:	e406                	sd	ra,8(sp)
    8000087e:	e022                	sd	s0,0(sp)
    80000880:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000882:	00000097          	auipc	ra,0x0
    80000886:	f22080e7          	jalr	-222(ra) # 800007a4 <kvmmake>
    8000088a:	00008797          	auipc	a5,0x8
    8000088e:	76a7bf23          	sd	a0,1918(a5) # 80009008 <kernel_pagetable>
}
    80000892:	60a2                	ld	ra,8(sp)
    80000894:	6402                	ld	s0,0(sp)
    80000896:	0141                	addi	sp,sp,16
    80000898:	8082                	ret

000000008000089a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000089a:	715d                	addi	sp,sp,-80
    8000089c:	e486                	sd	ra,72(sp)
    8000089e:	e0a2                	sd	s0,64(sp)
    800008a0:	fc26                	sd	s1,56(sp)
    800008a2:	f84a                	sd	s2,48(sp)
    800008a4:	f44e                	sd	s3,40(sp)
    800008a6:	f052                	sd	s4,32(sp)
    800008a8:	ec56                	sd	s5,24(sp)
    800008aa:	e85a                	sd	s6,16(sp)
    800008ac:	e45e                	sd	s7,8(sp)
    800008ae:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800008b0:	03459793          	slli	a5,a1,0x34
    800008b4:	e795                	bnez	a5,800008e0 <uvmunmap+0x46>
    800008b6:	8a2a                	mv	s4,a0
    800008b8:	892e                	mv	s2,a1
    800008ba:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008bc:	0632                	slli	a2,a2,0xc
    800008be:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800008c2:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008c4:	6b05                	lui	s6,0x1
    800008c6:	0735e863          	bltu	a1,s3,80000936 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800008ca:	60a6                	ld	ra,72(sp)
    800008cc:	6406                	ld	s0,64(sp)
    800008ce:	74e2                	ld	s1,56(sp)
    800008d0:	7942                	ld	s2,48(sp)
    800008d2:	79a2                	ld	s3,40(sp)
    800008d4:	7a02                	ld	s4,32(sp)
    800008d6:	6ae2                	ld	s5,24(sp)
    800008d8:	6b42                	ld	s6,16(sp)
    800008da:	6ba2                	ld	s7,8(sp)
    800008dc:	6161                	addi	sp,sp,80
    800008de:	8082                	ret
    panic("uvmunmap: not aligned");
    800008e0:	00007517          	auipc	a0,0x7
    800008e4:	7a050513          	addi	a0,a0,1952 # 80008080 <etext+0x80>
    800008e8:	00006097          	auipc	ra,0x6
    800008ec:	854080e7          	jalr	-1964(ra) # 8000613c <panic>
      panic("uvmunmap: walk");
    800008f0:	00007517          	auipc	a0,0x7
    800008f4:	7a850513          	addi	a0,a0,1960 # 80008098 <etext+0x98>
    800008f8:	00006097          	auipc	ra,0x6
    800008fc:	844080e7          	jalr	-1980(ra) # 8000613c <panic>
      panic("uvmunmap: not mapped");
    80000900:	00007517          	auipc	a0,0x7
    80000904:	7a850513          	addi	a0,a0,1960 # 800080a8 <etext+0xa8>
    80000908:	00006097          	auipc	ra,0x6
    8000090c:	834080e7          	jalr	-1996(ra) # 8000613c <panic>
      panic("uvmunmap: not a leaf");
    80000910:	00007517          	auipc	a0,0x7
    80000914:	7b050513          	addi	a0,a0,1968 # 800080c0 <etext+0xc0>
    80000918:	00006097          	auipc	ra,0x6
    8000091c:	824080e7          	jalr	-2012(ra) # 8000613c <panic>
      uint64 pa = PTE2PA(*pte);
    80000920:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000922:	0532                	slli	a0,a0,0xc
    80000924:	fffff097          	auipc	ra,0xfffff
    80000928:	7f0080e7          	jalr	2032(ra) # 80000114 <kfree>
    *pte = 0;
    8000092c:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000930:	995a                	add	s2,s2,s6
    80000932:	f9397ce3          	bgeu	s2,s3,800008ca <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000936:	4601                	li	a2,0
    80000938:	85ca                	mv	a1,s2
    8000093a:	8552                	mv	a0,s4
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	cb0080e7          	jalr	-848(ra) # 800005ec <walk>
    80000944:	84aa                	mv	s1,a0
    80000946:	d54d                	beqz	a0,800008f0 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80000948:	6108                	ld	a0,0(a0)
    8000094a:	00157793          	andi	a5,a0,1
    8000094e:	dbcd                	beqz	a5,80000900 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000950:	3ff57793          	andi	a5,a0,1023
    80000954:	fb778ee3          	beq	a5,s7,80000910 <uvmunmap+0x76>
    if(do_free){
    80000958:	fc0a8ae3          	beqz	s5,8000092c <uvmunmap+0x92>
    8000095c:	b7d1                	j	80000920 <uvmunmap+0x86>

000000008000095e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000095e:	1101                	addi	sp,sp,-32
    80000960:	ec06                	sd	ra,24(sp)
    80000962:	e822                	sd	s0,16(sp)
    80000964:	e426                	sd	s1,8(sp)
    80000966:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000968:	00000097          	auipc	ra,0x0
    8000096c:	88c080e7          	jalr	-1908(ra) # 800001f4 <kalloc>
    80000970:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000972:	c519                	beqz	a0,80000980 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000974:	6605                	lui	a2,0x1
    80000976:	4581                	li	a1,0
    80000978:	00000097          	auipc	ra,0x0
    8000097c:	97c080e7          	jalr	-1668(ra) # 800002f4 <memset>
  return pagetable;
}
    80000980:	8526                	mv	a0,s1
    80000982:	60e2                	ld	ra,24(sp)
    80000984:	6442                	ld	s0,16(sp)
    80000986:	64a2                	ld	s1,8(sp)
    80000988:	6105                	addi	sp,sp,32
    8000098a:	8082                	ret

000000008000098c <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000098c:	7179                	addi	sp,sp,-48
    8000098e:	f406                	sd	ra,40(sp)
    80000990:	f022                	sd	s0,32(sp)
    80000992:	ec26                	sd	s1,24(sp)
    80000994:	e84a                	sd	s2,16(sp)
    80000996:	e44e                	sd	s3,8(sp)
    80000998:	e052                	sd	s4,0(sp)
    8000099a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000099c:	6785                	lui	a5,0x1
    8000099e:	04f67863          	bgeu	a2,a5,800009ee <uvminit+0x62>
    800009a2:	8a2a                	mv	s4,a0
    800009a4:	89ae                	mv	s3,a1
    800009a6:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	84c080e7          	jalr	-1972(ra) # 800001f4 <kalloc>
    800009b0:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800009b2:	6605                	lui	a2,0x1
    800009b4:	4581                	li	a1,0
    800009b6:	00000097          	auipc	ra,0x0
    800009ba:	93e080e7          	jalr	-1730(ra) # 800002f4 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800009be:	4779                	li	a4,30
    800009c0:	86ca                	mv	a3,s2
    800009c2:	6605                	lui	a2,0x1
    800009c4:	4581                	li	a1,0
    800009c6:	8552                	mv	a0,s4
    800009c8:	00000097          	auipc	ra,0x0
    800009cc:	d0c080e7          	jalr	-756(ra) # 800006d4 <mappages>
  memmove(mem, src, sz);
    800009d0:	8626                	mv	a2,s1
    800009d2:	85ce                	mv	a1,s3
    800009d4:	854a                	mv	a0,s2
    800009d6:	00000097          	auipc	ra,0x0
    800009da:	97e080e7          	jalr	-1666(ra) # 80000354 <memmove>
}
    800009de:	70a2                	ld	ra,40(sp)
    800009e0:	7402                	ld	s0,32(sp)
    800009e2:	64e2                	ld	s1,24(sp)
    800009e4:	6942                	ld	s2,16(sp)
    800009e6:	69a2                	ld	s3,8(sp)
    800009e8:	6a02                	ld	s4,0(sp)
    800009ea:	6145                	addi	sp,sp,48
    800009ec:	8082                	ret
    panic("inituvm: more than a page");
    800009ee:	00007517          	auipc	a0,0x7
    800009f2:	6ea50513          	addi	a0,a0,1770 # 800080d8 <etext+0xd8>
    800009f6:	00005097          	auipc	ra,0x5
    800009fa:	746080e7          	jalr	1862(ra) # 8000613c <panic>

00000000800009fe <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800009fe:	1101                	addi	sp,sp,-32
    80000a00:	ec06                	sd	ra,24(sp)
    80000a02:	e822                	sd	s0,16(sp)
    80000a04:	e426                	sd	s1,8(sp)
    80000a06:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000a08:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000a0a:	00b67d63          	bgeu	a2,a1,80000a24 <uvmdealloc+0x26>
    80000a0e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000a10:	6785                	lui	a5,0x1
    80000a12:	17fd                	addi	a5,a5,-1
    80000a14:	00f60733          	add	a4,a2,a5
    80000a18:	767d                	lui	a2,0xfffff
    80000a1a:	8f71                	and	a4,a4,a2
    80000a1c:	97ae                	add	a5,a5,a1
    80000a1e:	8ff1                	and	a5,a5,a2
    80000a20:	00f76863          	bltu	a4,a5,80000a30 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000a24:	8526                	mv	a0,s1
    80000a26:	60e2                	ld	ra,24(sp)
    80000a28:	6442                	ld	s0,16(sp)
    80000a2a:	64a2                	ld	s1,8(sp)
    80000a2c:	6105                	addi	sp,sp,32
    80000a2e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000a30:	8f99                	sub	a5,a5,a4
    80000a32:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000a34:	4685                	li	a3,1
    80000a36:	0007861b          	sext.w	a2,a5
    80000a3a:	85ba                	mv	a1,a4
    80000a3c:	00000097          	auipc	ra,0x0
    80000a40:	e5e080e7          	jalr	-418(ra) # 8000089a <uvmunmap>
    80000a44:	b7c5                	j	80000a24 <uvmdealloc+0x26>

0000000080000a46 <uvmalloc>:
  if(newsz < oldsz)
    80000a46:	0ab66163          	bltu	a2,a1,80000ae8 <uvmalloc+0xa2>
{
    80000a4a:	7139                	addi	sp,sp,-64
    80000a4c:	fc06                	sd	ra,56(sp)
    80000a4e:	f822                	sd	s0,48(sp)
    80000a50:	f426                	sd	s1,40(sp)
    80000a52:	f04a                	sd	s2,32(sp)
    80000a54:	ec4e                	sd	s3,24(sp)
    80000a56:	e852                	sd	s4,16(sp)
    80000a58:	e456                	sd	s5,8(sp)
    80000a5a:	0080                	addi	s0,sp,64
    80000a5c:	8aaa                	mv	s5,a0
    80000a5e:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000a60:	6985                	lui	s3,0x1
    80000a62:	19fd                	addi	s3,s3,-1
    80000a64:	95ce                	add	a1,a1,s3
    80000a66:	79fd                	lui	s3,0xfffff
    80000a68:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a6c:	08c9f063          	bgeu	s3,a2,80000aec <uvmalloc+0xa6>
    80000a70:	894e                	mv	s2,s3
    mem = kalloc();
    80000a72:	fffff097          	auipc	ra,0xfffff
    80000a76:	782080e7          	jalr	1922(ra) # 800001f4 <kalloc>
    80000a7a:	84aa                	mv	s1,a0
    if(mem == 0){
    80000a7c:	c51d                	beqz	a0,80000aaa <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000a7e:	6605                	lui	a2,0x1
    80000a80:	4581                	li	a1,0
    80000a82:	00000097          	auipc	ra,0x0
    80000a86:	872080e7          	jalr	-1934(ra) # 800002f4 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000a8a:	4779                	li	a4,30
    80000a8c:	86a6                	mv	a3,s1
    80000a8e:	6605                	lui	a2,0x1
    80000a90:	85ca                	mv	a1,s2
    80000a92:	8556                	mv	a0,s5
    80000a94:	00000097          	auipc	ra,0x0
    80000a98:	c40080e7          	jalr	-960(ra) # 800006d4 <mappages>
    80000a9c:	e905                	bnez	a0,80000acc <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a9e:	6785                	lui	a5,0x1
    80000aa0:	993e                	add	s2,s2,a5
    80000aa2:	fd4968e3          	bltu	s2,s4,80000a72 <uvmalloc+0x2c>
  return newsz;
    80000aa6:	8552                	mv	a0,s4
    80000aa8:	a809                	j	80000aba <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000aaa:	864e                	mv	a2,s3
    80000aac:	85ca                	mv	a1,s2
    80000aae:	8556                	mv	a0,s5
    80000ab0:	00000097          	auipc	ra,0x0
    80000ab4:	f4e080e7          	jalr	-178(ra) # 800009fe <uvmdealloc>
      return 0;
    80000ab8:	4501                	li	a0,0
}
    80000aba:	70e2                	ld	ra,56(sp)
    80000abc:	7442                	ld	s0,48(sp)
    80000abe:	74a2                	ld	s1,40(sp)
    80000ac0:	7902                	ld	s2,32(sp)
    80000ac2:	69e2                	ld	s3,24(sp)
    80000ac4:	6a42                	ld	s4,16(sp)
    80000ac6:	6aa2                	ld	s5,8(sp)
    80000ac8:	6121                	addi	sp,sp,64
    80000aca:	8082                	ret
      kfree(mem);
    80000acc:	8526                	mv	a0,s1
    80000ace:	fffff097          	auipc	ra,0xfffff
    80000ad2:	646080e7          	jalr	1606(ra) # 80000114 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000ad6:	864e                	mv	a2,s3
    80000ad8:	85ca                	mv	a1,s2
    80000ada:	8556                	mv	a0,s5
    80000adc:	00000097          	auipc	ra,0x0
    80000ae0:	f22080e7          	jalr	-222(ra) # 800009fe <uvmdealloc>
      return 0;
    80000ae4:	4501                	li	a0,0
    80000ae6:	bfd1                	j	80000aba <uvmalloc+0x74>
    return oldsz;
    80000ae8:	852e                	mv	a0,a1
}
    80000aea:	8082                	ret
  return newsz;
    80000aec:	8532                	mv	a0,a2
    80000aee:	b7f1                	j	80000aba <uvmalloc+0x74>

0000000080000af0 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000af0:	7179                	addi	sp,sp,-48
    80000af2:	f406                	sd	ra,40(sp)
    80000af4:	f022                	sd	s0,32(sp)
    80000af6:	ec26                	sd	s1,24(sp)
    80000af8:	e84a                	sd	s2,16(sp)
    80000afa:	e44e                	sd	s3,8(sp)
    80000afc:	e052                	sd	s4,0(sp)
    80000afe:	1800                	addi	s0,sp,48
    80000b00:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000b02:	84aa                	mv	s1,a0
    80000b04:	6905                	lui	s2,0x1
    80000b06:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b08:	4985                	li	s3,1
    80000b0a:	a821                	j	80000b22 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000b0c:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000b0e:	0532                	slli	a0,a0,0xc
    80000b10:	00000097          	auipc	ra,0x0
    80000b14:	fe0080e7          	jalr	-32(ra) # 80000af0 <freewalk>
      pagetable[i] = 0;
    80000b18:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000b1c:	04a1                	addi	s1,s1,8
    80000b1e:	03248163          	beq	s1,s2,80000b40 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000b22:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b24:	00f57793          	andi	a5,a0,15
    80000b28:	ff3782e3          	beq	a5,s3,80000b0c <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000b2c:	8905                	andi	a0,a0,1
    80000b2e:	d57d                	beqz	a0,80000b1c <freewalk+0x2c>
      panic("freewalk: leaf");
    80000b30:	00007517          	auipc	a0,0x7
    80000b34:	5c850513          	addi	a0,a0,1480 # 800080f8 <etext+0xf8>
    80000b38:	00005097          	auipc	ra,0x5
    80000b3c:	604080e7          	jalr	1540(ra) # 8000613c <panic>
    }
  }
  kfree((void*)pagetable);
    80000b40:	8552                	mv	a0,s4
    80000b42:	fffff097          	auipc	ra,0xfffff
    80000b46:	5d2080e7          	jalr	1490(ra) # 80000114 <kfree>
}
    80000b4a:	70a2                	ld	ra,40(sp)
    80000b4c:	7402                	ld	s0,32(sp)
    80000b4e:	64e2                	ld	s1,24(sp)
    80000b50:	6942                	ld	s2,16(sp)
    80000b52:	69a2                	ld	s3,8(sp)
    80000b54:	6a02                	ld	s4,0(sp)
    80000b56:	6145                	addi	sp,sp,48
    80000b58:	8082                	ret

0000000080000b5a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000b5a:	1101                	addi	sp,sp,-32
    80000b5c:	ec06                	sd	ra,24(sp)
    80000b5e:	e822                	sd	s0,16(sp)
    80000b60:	e426                	sd	s1,8(sp)
    80000b62:	1000                	addi	s0,sp,32
    80000b64:	84aa                	mv	s1,a0
  if(sz > 0)
    80000b66:	e999                	bnez	a1,80000b7c <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000b68:	8526                	mv	a0,s1
    80000b6a:	00000097          	auipc	ra,0x0
    80000b6e:	f86080e7          	jalr	-122(ra) # 80000af0 <freewalk>
}
    80000b72:	60e2                	ld	ra,24(sp)
    80000b74:	6442                	ld	s0,16(sp)
    80000b76:	64a2                	ld	s1,8(sp)
    80000b78:	6105                	addi	sp,sp,32
    80000b7a:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b7c:	6605                	lui	a2,0x1
    80000b7e:	167d                	addi	a2,a2,-1
    80000b80:	962e                	add	a2,a2,a1
    80000b82:	4685                	li	a3,1
    80000b84:	8231                	srli	a2,a2,0xc
    80000b86:	4581                	li	a1,0
    80000b88:	00000097          	auipc	ra,0x0
    80000b8c:	d12080e7          	jalr	-750(ra) # 8000089a <uvmunmap>
    80000b90:	bfe1                	j	80000b68 <uvmfree+0xe>

0000000080000b92 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b92:	c679                	beqz	a2,80000c60 <uvmcopy+0xce>
{
    80000b94:	715d                	addi	sp,sp,-80
    80000b96:	e486                	sd	ra,72(sp)
    80000b98:	e0a2                	sd	s0,64(sp)
    80000b9a:	fc26                	sd	s1,56(sp)
    80000b9c:	f84a                	sd	s2,48(sp)
    80000b9e:	f44e                	sd	s3,40(sp)
    80000ba0:	f052                	sd	s4,32(sp)
    80000ba2:	ec56                	sd	s5,24(sp)
    80000ba4:	e85a                	sd	s6,16(sp)
    80000ba6:	e45e                	sd	s7,8(sp)
    80000ba8:	0880                	addi	s0,sp,80
    80000baa:	8b2a                	mv	s6,a0
    80000bac:	8aae                	mv	s5,a1
    80000bae:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000bb0:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000bb2:	4601                	li	a2,0
    80000bb4:	85ce                	mv	a1,s3
    80000bb6:	855a                	mv	a0,s6
    80000bb8:	00000097          	auipc	ra,0x0
    80000bbc:	a34080e7          	jalr	-1484(ra) # 800005ec <walk>
    80000bc0:	c531                	beqz	a0,80000c0c <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000bc2:	6118                	ld	a4,0(a0)
    80000bc4:	00177793          	andi	a5,a4,1
    80000bc8:	cbb1                	beqz	a5,80000c1c <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000bca:	00a75593          	srli	a1,a4,0xa
    80000bce:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000bd2:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000bd6:	fffff097          	auipc	ra,0xfffff
    80000bda:	61e080e7          	jalr	1566(ra) # 800001f4 <kalloc>
    80000bde:	892a                	mv	s2,a0
    80000be0:	c939                	beqz	a0,80000c36 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000be2:	6605                	lui	a2,0x1
    80000be4:	85de                	mv	a1,s7
    80000be6:	fffff097          	auipc	ra,0xfffff
    80000bea:	76e080e7          	jalr	1902(ra) # 80000354 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000bee:	8726                	mv	a4,s1
    80000bf0:	86ca                	mv	a3,s2
    80000bf2:	6605                	lui	a2,0x1
    80000bf4:	85ce                	mv	a1,s3
    80000bf6:	8556                	mv	a0,s5
    80000bf8:	00000097          	auipc	ra,0x0
    80000bfc:	adc080e7          	jalr	-1316(ra) # 800006d4 <mappages>
    80000c00:	e515                	bnez	a0,80000c2c <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000c02:	6785                	lui	a5,0x1
    80000c04:	99be                	add	s3,s3,a5
    80000c06:	fb49e6e3          	bltu	s3,s4,80000bb2 <uvmcopy+0x20>
    80000c0a:	a081                	j	80000c4a <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000c0c:	00007517          	auipc	a0,0x7
    80000c10:	4fc50513          	addi	a0,a0,1276 # 80008108 <etext+0x108>
    80000c14:	00005097          	auipc	ra,0x5
    80000c18:	528080e7          	jalr	1320(ra) # 8000613c <panic>
      panic("uvmcopy: page not present");
    80000c1c:	00007517          	auipc	a0,0x7
    80000c20:	50c50513          	addi	a0,a0,1292 # 80008128 <etext+0x128>
    80000c24:	00005097          	auipc	ra,0x5
    80000c28:	518080e7          	jalr	1304(ra) # 8000613c <panic>
      kfree(mem);
    80000c2c:	854a                	mv	a0,s2
    80000c2e:	fffff097          	auipc	ra,0xfffff
    80000c32:	4e6080e7          	jalr	1254(ra) # 80000114 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000c36:	4685                	li	a3,1
    80000c38:	00c9d613          	srli	a2,s3,0xc
    80000c3c:	4581                	li	a1,0
    80000c3e:	8556                	mv	a0,s5
    80000c40:	00000097          	auipc	ra,0x0
    80000c44:	c5a080e7          	jalr	-934(ra) # 8000089a <uvmunmap>
  return -1;
    80000c48:	557d                	li	a0,-1
}
    80000c4a:	60a6                	ld	ra,72(sp)
    80000c4c:	6406                	ld	s0,64(sp)
    80000c4e:	74e2                	ld	s1,56(sp)
    80000c50:	7942                	ld	s2,48(sp)
    80000c52:	79a2                	ld	s3,40(sp)
    80000c54:	7a02                	ld	s4,32(sp)
    80000c56:	6ae2                	ld	s5,24(sp)
    80000c58:	6b42                	ld	s6,16(sp)
    80000c5a:	6ba2                	ld	s7,8(sp)
    80000c5c:	6161                	addi	sp,sp,80
    80000c5e:	8082                	ret
  return 0;
    80000c60:	4501                	li	a0,0
}
    80000c62:	8082                	ret

0000000080000c64 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c64:	1141                	addi	sp,sp,-16
    80000c66:	e406                	sd	ra,8(sp)
    80000c68:	e022                	sd	s0,0(sp)
    80000c6a:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000c6c:	4601                	li	a2,0
    80000c6e:	00000097          	auipc	ra,0x0
    80000c72:	97e080e7          	jalr	-1666(ra) # 800005ec <walk>
  if(pte == 0)
    80000c76:	c901                	beqz	a0,80000c86 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c78:	611c                	ld	a5,0(a0)
    80000c7a:	9bbd                	andi	a5,a5,-17
    80000c7c:	e11c                	sd	a5,0(a0)
}
    80000c7e:	60a2                	ld	ra,8(sp)
    80000c80:	6402                	ld	s0,0(sp)
    80000c82:	0141                	addi	sp,sp,16
    80000c84:	8082                	ret
    panic("uvmclear");
    80000c86:	00007517          	auipc	a0,0x7
    80000c8a:	4c250513          	addi	a0,a0,1218 # 80008148 <etext+0x148>
    80000c8e:	00005097          	auipc	ra,0x5
    80000c92:	4ae080e7          	jalr	1198(ra) # 8000613c <panic>

0000000080000c96 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c96:	c6bd                	beqz	a3,80000d04 <copyout+0x6e>
{
    80000c98:	715d                	addi	sp,sp,-80
    80000c9a:	e486                	sd	ra,72(sp)
    80000c9c:	e0a2                	sd	s0,64(sp)
    80000c9e:	fc26                	sd	s1,56(sp)
    80000ca0:	f84a                	sd	s2,48(sp)
    80000ca2:	f44e                	sd	s3,40(sp)
    80000ca4:	f052                	sd	s4,32(sp)
    80000ca6:	ec56                	sd	s5,24(sp)
    80000ca8:	e85a                	sd	s6,16(sp)
    80000caa:	e45e                	sd	s7,8(sp)
    80000cac:	e062                	sd	s8,0(sp)
    80000cae:	0880                	addi	s0,sp,80
    80000cb0:	8b2a                	mv	s6,a0
    80000cb2:	8c2e                	mv	s8,a1
    80000cb4:	8a32                	mv	s4,a2
    80000cb6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000cb8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000cba:	6a85                	lui	s5,0x1
    80000cbc:	a015                	j	80000ce0 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000cbe:	9562                	add	a0,a0,s8
    80000cc0:	0004861b          	sext.w	a2,s1
    80000cc4:	85d2                	mv	a1,s4
    80000cc6:	41250533          	sub	a0,a0,s2
    80000cca:	fffff097          	auipc	ra,0xfffff
    80000cce:	68a080e7          	jalr	1674(ra) # 80000354 <memmove>

    len -= n;
    80000cd2:	409989b3          	sub	s3,s3,s1
    src += n;
    80000cd6:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000cd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000cdc:	02098263          	beqz	s3,80000d00 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000ce0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ce4:	85ca                	mv	a1,s2
    80000ce6:	855a                	mv	a0,s6
    80000ce8:	00000097          	auipc	ra,0x0
    80000cec:	9aa080e7          	jalr	-1622(ra) # 80000692 <walkaddr>
    if(pa0 == 0)
    80000cf0:	cd01                	beqz	a0,80000d08 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000cf2:	418904b3          	sub	s1,s2,s8
    80000cf6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000cf8:	fc99f3e3          	bgeu	s3,s1,80000cbe <copyout+0x28>
    80000cfc:	84ce                	mv	s1,s3
    80000cfe:	b7c1                	j	80000cbe <copyout+0x28>
  }
  return 0;
    80000d00:	4501                	li	a0,0
    80000d02:	a021                	j	80000d0a <copyout+0x74>
    80000d04:	4501                	li	a0,0
}
    80000d06:	8082                	ret
      return -1;
    80000d08:	557d                	li	a0,-1
}
    80000d0a:	60a6                	ld	ra,72(sp)
    80000d0c:	6406                	ld	s0,64(sp)
    80000d0e:	74e2                	ld	s1,56(sp)
    80000d10:	7942                	ld	s2,48(sp)
    80000d12:	79a2                	ld	s3,40(sp)
    80000d14:	7a02                	ld	s4,32(sp)
    80000d16:	6ae2                	ld	s5,24(sp)
    80000d18:	6b42                	ld	s6,16(sp)
    80000d1a:	6ba2                	ld	s7,8(sp)
    80000d1c:	6c02                	ld	s8,0(sp)
    80000d1e:	6161                	addi	sp,sp,80
    80000d20:	8082                	ret

0000000080000d22 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000d22:	c6bd                	beqz	a3,80000d90 <copyin+0x6e>
{
    80000d24:	715d                	addi	sp,sp,-80
    80000d26:	e486                	sd	ra,72(sp)
    80000d28:	e0a2                	sd	s0,64(sp)
    80000d2a:	fc26                	sd	s1,56(sp)
    80000d2c:	f84a                	sd	s2,48(sp)
    80000d2e:	f44e                	sd	s3,40(sp)
    80000d30:	f052                	sd	s4,32(sp)
    80000d32:	ec56                	sd	s5,24(sp)
    80000d34:	e85a                	sd	s6,16(sp)
    80000d36:	e45e                	sd	s7,8(sp)
    80000d38:	e062                	sd	s8,0(sp)
    80000d3a:	0880                	addi	s0,sp,80
    80000d3c:	8b2a                	mv	s6,a0
    80000d3e:	8a2e                	mv	s4,a1
    80000d40:	8c32                	mv	s8,a2
    80000d42:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000d44:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d46:	6a85                	lui	s5,0x1
    80000d48:	a015                	j	80000d6c <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d4a:	9562                	add	a0,a0,s8
    80000d4c:	0004861b          	sext.w	a2,s1
    80000d50:	412505b3          	sub	a1,a0,s2
    80000d54:	8552                	mv	a0,s4
    80000d56:	fffff097          	auipc	ra,0xfffff
    80000d5a:	5fe080e7          	jalr	1534(ra) # 80000354 <memmove>

    len -= n;
    80000d5e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d62:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d64:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d68:	02098263          	beqz	s3,80000d8c <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000d6c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d70:	85ca                	mv	a1,s2
    80000d72:	855a                	mv	a0,s6
    80000d74:	00000097          	auipc	ra,0x0
    80000d78:	91e080e7          	jalr	-1762(ra) # 80000692 <walkaddr>
    if(pa0 == 0)
    80000d7c:	cd01                	beqz	a0,80000d94 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000d7e:	418904b3          	sub	s1,s2,s8
    80000d82:	94d6                	add	s1,s1,s5
    if(n > len)
    80000d84:	fc99f3e3          	bgeu	s3,s1,80000d4a <copyin+0x28>
    80000d88:	84ce                	mv	s1,s3
    80000d8a:	b7c1                	j	80000d4a <copyin+0x28>
  }
  return 0;
    80000d8c:	4501                	li	a0,0
    80000d8e:	a021                	j	80000d96 <copyin+0x74>
    80000d90:	4501                	li	a0,0
}
    80000d92:	8082                	ret
      return -1;
    80000d94:	557d                	li	a0,-1
}
    80000d96:	60a6                	ld	ra,72(sp)
    80000d98:	6406                	ld	s0,64(sp)
    80000d9a:	74e2                	ld	s1,56(sp)
    80000d9c:	7942                	ld	s2,48(sp)
    80000d9e:	79a2                	ld	s3,40(sp)
    80000da0:	7a02                	ld	s4,32(sp)
    80000da2:	6ae2                	ld	s5,24(sp)
    80000da4:	6b42                	ld	s6,16(sp)
    80000da6:	6ba2                	ld	s7,8(sp)
    80000da8:	6c02                	ld	s8,0(sp)
    80000daa:	6161                	addi	sp,sp,80
    80000dac:	8082                	ret

0000000080000dae <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000dae:	c6c5                	beqz	a3,80000e56 <copyinstr+0xa8>
{
    80000db0:	715d                	addi	sp,sp,-80
    80000db2:	e486                	sd	ra,72(sp)
    80000db4:	e0a2                	sd	s0,64(sp)
    80000db6:	fc26                	sd	s1,56(sp)
    80000db8:	f84a                	sd	s2,48(sp)
    80000dba:	f44e                	sd	s3,40(sp)
    80000dbc:	f052                	sd	s4,32(sp)
    80000dbe:	ec56                	sd	s5,24(sp)
    80000dc0:	e85a                	sd	s6,16(sp)
    80000dc2:	e45e                	sd	s7,8(sp)
    80000dc4:	0880                	addi	s0,sp,80
    80000dc6:	8a2a                	mv	s4,a0
    80000dc8:	8b2e                	mv	s6,a1
    80000dca:	8bb2                	mv	s7,a2
    80000dcc:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000dce:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000dd0:	6985                	lui	s3,0x1
    80000dd2:	a035                	j	80000dfe <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000dd4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000dd8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000dda:	0017b793          	seqz	a5,a5
    80000dde:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000de2:	60a6                	ld	ra,72(sp)
    80000de4:	6406                	ld	s0,64(sp)
    80000de6:	74e2                	ld	s1,56(sp)
    80000de8:	7942                	ld	s2,48(sp)
    80000dea:	79a2                	ld	s3,40(sp)
    80000dec:	7a02                	ld	s4,32(sp)
    80000dee:	6ae2                	ld	s5,24(sp)
    80000df0:	6b42                	ld	s6,16(sp)
    80000df2:	6ba2                	ld	s7,8(sp)
    80000df4:	6161                	addi	sp,sp,80
    80000df6:	8082                	ret
    srcva = va0 + PGSIZE;
    80000df8:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000dfc:	c8a9                	beqz	s1,80000e4e <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000dfe:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000e02:	85ca                	mv	a1,s2
    80000e04:	8552                	mv	a0,s4
    80000e06:	00000097          	auipc	ra,0x0
    80000e0a:	88c080e7          	jalr	-1908(ra) # 80000692 <walkaddr>
    if(pa0 == 0)
    80000e0e:	c131                	beqz	a0,80000e52 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000e10:	41790833          	sub	a6,s2,s7
    80000e14:	984e                	add	a6,a6,s3
    if(n > max)
    80000e16:	0104f363          	bgeu	s1,a6,80000e1c <copyinstr+0x6e>
    80000e1a:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000e1c:	955e                	add	a0,a0,s7
    80000e1e:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000e22:	fc080be3          	beqz	a6,80000df8 <copyinstr+0x4a>
    80000e26:	985a                	add	a6,a6,s6
    80000e28:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000e2a:	41650633          	sub	a2,a0,s6
    80000e2e:	14fd                	addi	s1,s1,-1
    80000e30:	9b26                	add	s6,s6,s1
    80000e32:	00f60733          	add	a4,a2,a5
    80000e36:	00074703          	lbu	a4,0(a4)
    80000e3a:	df49                	beqz	a4,80000dd4 <copyinstr+0x26>
        *dst = *p;
    80000e3c:	00e78023          	sb	a4,0(a5)
      --max;
    80000e40:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000e44:	0785                	addi	a5,a5,1
    while(n > 0){
    80000e46:	ff0796e3          	bne	a5,a6,80000e32 <copyinstr+0x84>
      dst++;
    80000e4a:	8b42                	mv	s6,a6
    80000e4c:	b775                	j	80000df8 <copyinstr+0x4a>
    80000e4e:	4781                	li	a5,0
    80000e50:	b769                	j	80000dda <copyinstr+0x2c>
      return -1;
    80000e52:	557d                	li	a0,-1
    80000e54:	b779                	j	80000de2 <copyinstr+0x34>
  int got_null = 0;
    80000e56:	4781                	li	a5,0
  if(got_null){
    80000e58:	0017b793          	seqz	a5,a5
    80000e5c:	40f00533          	neg	a0,a5
}
    80000e60:	8082                	ret

0000000080000e62 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e62:	7139                	addi	sp,sp,-64
    80000e64:	fc06                	sd	ra,56(sp)
    80000e66:	f822                	sd	s0,48(sp)
    80000e68:	f426                	sd	s1,40(sp)
    80000e6a:	f04a                	sd	s2,32(sp)
    80000e6c:	ec4e                	sd	s3,24(sp)
    80000e6e:	e852                	sd	s4,16(sp)
    80000e70:	e456                	sd	s5,8(sp)
    80000e72:	e05a                	sd	s6,0(sp)
    80000e74:	0080                	addi	s0,sp,64
    80000e76:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e78:	00008497          	auipc	s1,0x8
    80000e7c:	73848493          	addi	s1,s1,1848 # 800095b0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e80:	8b26                	mv	s6,s1
    80000e82:	00007a97          	auipc	s5,0x7
    80000e86:	17ea8a93          	addi	s5,s5,382 # 80008000 <etext>
    80000e8a:	04000937          	lui	s2,0x4000
    80000e8e:	197d                	addi	s2,s2,-1
    80000e90:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e92:	0000ea17          	auipc	s4,0xe
    80000e96:	31ea0a13          	addi	s4,s4,798 # 8000f1b0 <tickslock>
    char *pa = kalloc();
    80000e9a:	fffff097          	auipc	ra,0xfffff
    80000e9e:	35a080e7          	jalr	858(ra) # 800001f4 <kalloc>
    80000ea2:	862a                	mv	a2,a0
    if(pa == 0)
    80000ea4:	c131                	beqz	a0,80000ee8 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000ea6:	416485b3          	sub	a1,s1,s6
    80000eaa:	8591                	srai	a1,a1,0x4
    80000eac:	000ab783          	ld	a5,0(s5)
    80000eb0:	02f585b3          	mul	a1,a1,a5
    80000eb4:	2585                	addiw	a1,a1,1
    80000eb6:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000eba:	4719                	li	a4,6
    80000ebc:	6685                	lui	a3,0x1
    80000ebe:	40b905b3          	sub	a1,s2,a1
    80000ec2:	854e                	mv	a0,s3
    80000ec4:	00000097          	auipc	ra,0x0
    80000ec8:	8b0080e7          	jalr	-1872(ra) # 80000774 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ecc:	17048493          	addi	s1,s1,368
    80000ed0:	fd4495e3          	bne	s1,s4,80000e9a <proc_mapstacks+0x38>
  }
}
    80000ed4:	70e2                	ld	ra,56(sp)
    80000ed6:	7442                	ld	s0,48(sp)
    80000ed8:	74a2                	ld	s1,40(sp)
    80000eda:	7902                	ld	s2,32(sp)
    80000edc:	69e2                	ld	s3,24(sp)
    80000ede:	6a42                	ld	s4,16(sp)
    80000ee0:	6aa2                	ld	s5,8(sp)
    80000ee2:	6b02                	ld	s6,0(sp)
    80000ee4:	6121                	addi	sp,sp,64
    80000ee6:	8082                	ret
      panic("kalloc");
    80000ee8:	00007517          	auipc	a0,0x7
    80000eec:	27050513          	addi	a0,a0,624 # 80008158 <etext+0x158>
    80000ef0:	00005097          	auipc	ra,0x5
    80000ef4:	24c080e7          	jalr	588(ra) # 8000613c <panic>

0000000080000ef8 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000ef8:	7139                	addi	sp,sp,-64
    80000efa:	fc06                	sd	ra,56(sp)
    80000efc:	f822                	sd	s0,48(sp)
    80000efe:	f426                	sd	s1,40(sp)
    80000f00:	f04a                	sd	s2,32(sp)
    80000f02:	ec4e                	sd	s3,24(sp)
    80000f04:	e852                	sd	s4,16(sp)
    80000f06:	e456                	sd	s5,8(sp)
    80000f08:	e05a                	sd	s6,0(sp)
    80000f0a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f0c:	00007597          	auipc	a1,0x7
    80000f10:	25458593          	addi	a1,a1,596 # 80008160 <etext+0x160>
    80000f14:	00008517          	auipc	a0,0x8
    80000f18:	25c50513          	addi	a0,a0,604 # 80009170 <pid_lock>
    80000f1c:	00006097          	auipc	ra,0x6
    80000f20:	8d0080e7          	jalr	-1840(ra) # 800067ec <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f24:	00007597          	auipc	a1,0x7
    80000f28:	24458593          	addi	a1,a1,580 # 80008168 <etext+0x168>
    80000f2c:	00008517          	auipc	a0,0x8
    80000f30:	26450513          	addi	a0,a0,612 # 80009190 <wait_lock>
    80000f34:	00006097          	auipc	ra,0x6
    80000f38:	8b8080e7          	jalr	-1864(ra) # 800067ec <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f3c:	00008497          	auipc	s1,0x8
    80000f40:	67448493          	addi	s1,s1,1652 # 800095b0 <proc>
      initlock(&p->lock, "proc");
    80000f44:	00007b17          	auipc	s6,0x7
    80000f48:	234b0b13          	addi	s6,s6,564 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000f4c:	8aa6                	mv	s5,s1
    80000f4e:	00007a17          	auipc	s4,0x7
    80000f52:	0b2a0a13          	addi	s4,s4,178 # 80008000 <etext>
    80000f56:	04000937          	lui	s2,0x4000
    80000f5a:	197d                	addi	s2,s2,-1
    80000f5c:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f5e:	0000e997          	auipc	s3,0xe
    80000f62:	25298993          	addi	s3,s3,594 # 8000f1b0 <tickslock>
      initlock(&p->lock, "proc");
    80000f66:	85da                	mv	a1,s6
    80000f68:	8526                	mv	a0,s1
    80000f6a:	00006097          	auipc	ra,0x6
    80000f6e:	882080e7          	jalr	-1918(ra) # 800067ec <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f72:	415487b3          	sub	a5,s1,s5
    80000f76:	8791                	srai	a5,a5,0x4
    80000f78:	000a3703          	ld	a4,0(s4)
    80000f7c:	02e787b3          	mul	a5,a5,a4
    80000f80:	2785                	addiw	a5,a5,1
    80000f82:	00d7979b          	slliw	a5,a5,0xd
    80000f86:	40f907b3          	sub	a5,s2,a5
    80000f8a:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f8c:	17048493          	addi	s1,s1,368
    80000f90:	fd349be3          	bne	s1,s3,80000f66 <procinit+0x6e>
  }
}
    80000f94:	70e2                	ld	ra,56(sp)
    80000f96:	7442                	ld	s0,48(sp)
    80000f98:	74a2                	ld	s1,40(sp)
    80000f9a:	7902                	ld	s2,32(sp)
    80000f9c:	69e2                	ld	s3,24(sp)
    80000f9e:	6a42                	ld	s4,16(sp)
    80000fa0:	6aa2                	ld	s5,8(sp)
    80000fa2:	6b02                	ld	s6,0(sp)
    80000fa4:	6121                	addi	sp,sp,64
    80000fa6:	8082                	ret

0000000080000fa8 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000fa8:	1141                	addi	sp,sp,-16
    80000faa:	e422                	sd	s0,8(sp)
    80000fac:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000fae:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000fb0:	2501                	sext.w	a0,a0
    80000fb2:	6422                	ld	s0,8(sp)
    80000fb4:	0141                	addi	sp,sp,16
    80000fb6:	8082                	ret

0000000080000fb8 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000fb8:	1141                	addi	sp,sp,-16
    80000fba:	e422                	sd	s0,8(sp)
    80000fbc:	0800                	addi	s0,sp,16
    80000fbe:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000fc0:	2781                	sext.w	a5,a5
    80000fc2:	079e                	slli	a5,a5,0x7
  return c;
}
    80000fc4:	00008517          	auipc	a0,0x8
    80000fc8:	1ec50513          	addi	a0,a0,492 # 800091b0 <cpus>
    80000fcc:	953e                	add	a0,a0,a5
    80000fce:	6422                	ld	s0,8(sp)
    80000fd0:	0141                	addi	sp,sp,16
    80000fd2:	8082                	ret

0000000080000fd4 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000fd4:	1101                	addi	sp,sp,-32
    80000fd6:	ec06                	sd	ra,24(sp)
    80000fd8:	e822                	sd	s0,16(sp)
    80000fda:	e426                	sd	s1,8(sp)
    80000fdc:	1000                	addi	s0,sp,32
  push_off();
    80000fde:	00005097          	auipc	ra,0x5
    80000fe2:	646080e7          	jalr	1606(ra) # 80006624 <push_off>
    80000fe6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000fe8:	2781                	sext.w	a5,a5
    80000fea:	079e                	slli	a5,a5,0x7
    80000fec:	00008717          	auipc	a4,0x8
    80000ff0:	18470713          	addi	a4,a4,388 # 80009170 <pid_lock>
    80000ff4:	97ba                	add	a5,a5,a4
    80000ff6:	63a4                	ld	s1,64(a5)
  pop_off();
    80000ff8:	00005097          	auipc	ra,0x5
    80000ffc:	6e8080e7          	jalr	1768(ra) # 800066e0 <pop_off>
  return p;
}
    80001000:	8526                	mv	a0,s1
    80001002:	60e2                	ld	ra,24(sp)
    80001004:	6442                	ld	s0,16(sp)
    80001006:	64a2                	ld	s1,8(sp)
    80001008:	6105                	addi	sp,sp,32
    8000100a:	8082                	ret

000000008000100c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000100c:	1141                	addi	sp,sp,-16
    8000100e:	e406                	sd	ra,8(sp)
    80001010:	e022                	sd	s0,0(sp)
    80001012:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001014:	00000097          	auipc	ra,0x0
    80001018:	fc0080e7          	jalr	-64(ra) # 80000fd4 <myproc>
    8000101c:	00005097          	auipc	ra,0x5
    80001020:	724080e7          	jalr	1828(ra) # 80006740 <release>

  if (first) {
    80001024:	00008797          	auipc	a5,0x8
    80001028:	8ac7a783          	lw	a5,-1876(a5) # 800088d0 <first.1688>
    8000102c:	eb89                	bnez	a5,8000103e <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    8000102e:	00001097          	auipc	ra,0x1
    80001032:	c0a080e7          	jalr	-1014(ra) # 80001c38 <usertrapret>
}
    80001036:	60a2                	ld	ra,8(sp)
    80001038:	6402                	ld	s0,0(sp)
    8000103a:	0141                	addi	sp,sp,16
    8000103c:	8082                	ret
    first = 0;
    8000103e:	00008797          	auipc	a5,0x8
    80001042:	8807a923          	sw	zero,-1902(a5) # 800088d0 <first.1688>
    fsinit(ROOTDEV);
    80001046:	4505                	li	a0,1
    80001048:	00002097          	auipc	ra,0x2
    8000104c:	a86080e7          	jalr	-1402(ra) # 80002ace <fsinit>
    80001050:	bff9                	j	8000102e <forkret+0x22>

0000000080001052 <allocpid>:
allocpid() {
    80001052:	1101                	addi	sp,sp,-32
    80001054:	ec06                	sd	ra,24(sp)
    80001056:	e822                	sd	s0,16(sp)
    80001058:	e426                	sd	s1,8(sp)
    8000105a:	e04a                	sd	s2,0(sp)
    8000105c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000105e:	00008917          	auipc	s2,0x8
    80001062:	11290913          	addi	s2,s2,274 # 80009170 <pid_lock>
    80001066:	854a                	mv	a0,s2
    80001068:	00005097          	auipc	ra,0x5
    8000106c:	608080e7          	jalr	1544(ra) # 80006670 <acquire>
  pid = nextpid;
    80001070:	00008797          	auipc	a5,0x8
    80001074:	86478793          	addi	a5,a5,-1948 # 800088d4 <nextpid>
    80001078:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000107a:	0014871b          	addiw	a4,s1,1
    8000107e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001080:	854a                	mv	a0,s2
    80001082:	00005097          	auipc	ra,0x5
    80001086:	6be080e7          	jalr	1726(ra) # 80006740 <release>
}
    8000108a:	8526                	mv	a0,s1
    8000108c:	60e2                	ld	ra,24(sp)
    8000108e:	6442                	ld	s0,16(sp)
    80001090:	64a2                	ld	s1,8(sp)
    80001092:	6902                	ld	s2,0(sp)
    80001094:	6105                	addi	sp,sp,32
    80001096:	8082                	ret

0000000080001098 <proc_pagetable>:
{
    80001098:	1101                	addi	sp,sp,-32
    8000109a:	ec06                	sd	ra,24(sp)
    8000109c:	e822                	sd	s0,16(sp)
    8000109e:	e426                	sd	s1,8(sp)
    800010a0:	e04a                	sd	s2,0(sp)
    800010a2:	1000                	addi	s0,sp,32
    800010a4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800010a6:	00000097          	auipc	ra,0x0
    800010aa:	8b8080e7          	jalr	-1864(ra) # 8000095e <uvmcreate>
    800010ae:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800010b0:	c121                	beqz	a0,800010f0 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800010b2:	4729                	li	a4,10
    800010b4:	00006697          	auipc	a3,0x6
    800010b8:	f4c68693          	addi	a3,a3,-180 # 80007000 <_trampoline>
    800010bc:	6605                	lui	a2,0x1
    800010be:	040005b7          	lui	a1,0x4000
    800010c2:	15fd                	addi	a1,a1,-1
    800010c4:	05b2                	slli	a1,a1,0xc
    800010c6:	fffff097          	auipc	ra,0xfffff
    800010ca:	60e080e7          	jalr	1550(ra) # 800006d4 <mappages>
    800010ce:	02054863          	bltz	a0,800010fe <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800010d2:	4719                	li	a4,6
    800010d4:	06093683          	ld	a3,96(s2)
    800010d8:	6605                	lui	a2,0x1
    800010da:	020005b7          	lui	a1,0x2000
    800010de:	15fd                	addi	a1,a1,-1
    800010e0:	05b6                	slli	a1,a1,0xd
    800010e2:	8526                	mv	a0,s1
    800010e4:	fffff097          	auipc	ra,0xfffff
    800010e8:	5f0080e7          	jalr	1520(ra) # 800006d4 <mappages>
    800010ec:	02054163          	bltz	a0,8000110e <proc_pagetable+0x76>
}
    800010f0:	8526                	mv	a0,s1
    800010f2:	60e2                	ld	ra,24(sp)
    800010f4:	6442                	ld	s0,16(sp)
    800010f6:	64a2                	ld	s1,8(sp)
    800010f8:	6902                	ld	s2,0(sp)
    800010fa:	6105                	addi	sp,sp,32
    800010fc:	8082                	ret
    uvmfree(pagetable, 0);
    800010fe:	4581                	li	a1,0
    80001100:	8526                	mv	a0,s1
    80001102:	00000097          	auipc	ra,0x0
    80001106:	a58080e7          	jalr	-1448(ra) # 80000b5a <uvmfree>
    return 0;
    8000110a:	4481                	li	s1,0
    8000110c:	b7d5                	j	800010f0 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000110e:	4681                	li	a3,0
    80001110:	4605                	li	a2,1
    80001112:	040005b7          	lui	a1,0x4000
    80001116:	15fd                	addi	a1,a1,-1
    80001118:	05b2                	slli	a1,a1,0xc
    8000111a:	8526                	mv	a0,s1
    8000111c:	fffff097          	auipc	ra,0xfffff
    80001120:	77e080e7          	jalr	1918(ra) # 8000089a <uvmunmap>
    uvmfree(pagetable, 0);
    80001124:	4581                	li	a1,0
    80001126:	8526                	mv	a0,s1
    80001128:	00000097          	auipc	ra,0x0
    8000112c:	a32080e7          	jalr	-1486(ra) # 80000b5a <uvmfree>
    return 0;
    80001130:	4481                	li	s1,0
    80001132:	bf7d                	j	800010f0 <proc_pagetable+0x58>

0000000080001134 <proc_freepagetable>:
{
    80001134:	1101                	addi	sp,sp,-32
    80001136:	ec06                	sd	ra,24(sp)
    80001138:	e822                	sd	s0,16(sp)
    8000113a:	e426                	sd	s1,8(sp)
    8000113c:	e04a                	sd	s2,0(sp)
    8000113e:	1000                	addi	s0,sp,32
    80001140:	84aa                	mv	s1,a0
    80001142:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001144:	4681                	li	a3,0
    80001146:	4605                	li	a2,1
    80001148:	040005b7          	lui	a1,0x4000
    8000114c:	15fd                	addi	a1,a1,-1
    8000114e:	05b2                	slli	a1,a1,0xc
    80001150:	fffff097          	auipc	ra,0xfffff
    80001154:	74a080e7          	jalr	1866(ra) # 8000089a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001158:	4681                	li	a3,0
    8000115a:	4605                	li	a2,1
    8000115c:	020005b7          	lui	a1,0x2000
    80001160:	15fd                	addi	a1,a1,-1
    80001162:	05b6                	slli	a1,a1,0xd
    80001164:	8526                	mv	a0,s1
    80001166:	fffff097          	auipc	ra,0xfffff
    8000116a:	734080e7          	jalr	1844(ra) # 8000089a <uvmunmap>
  uvmfree(pagetable, sz);
    8000116e:	85ca                	mv	a1,s2
    80001170:	8526                	mv	a0,s1
    80001172:	00000097          	auipc	ra,0x0
    80001176:	9e8080e7          	jalr	-1560(ra) # 80000b5a <uvmfree>
}
    8000117a:	60e2                	ld	ra,24(sp)
    8000117c:	6442                	ld	s0,16(sp)
    8000117e:	64a2                	ld	s1,8(sp)
    80001180:	6902                	ld	s2,0(sp)
    80001182:	6105                	addi	sp,sp,32
    80001184:	8082                	ret

0000000080001186 <freeproc>:
{
    80001186:	1101                	addi	sp,sp,-32
    80001188:	ec06                	sd	ra,24(sp)
    8000118a:	e822                	sd	s0,16(sp)
    8000118c:	e426                	sd	s1,8(sp)
    8000118e:	1000                	addi	s0,sp,32
    80001190:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001192:	7128                	ld	a0,96(a0)
    80001194:	c509                	beqz	a0,8000119e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001196:	fffff097          	auipc	ra,0xfffff
    8000119a:	f7e080e7          	jalr	-130(ra) # 80000114 <kfree>
  p->trapframe = 0;
    8000119e:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    800011a2:	6ca8                	ld	a0,88(s1)
    800011a4:	c511                	beqz	a0,800011b0 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800011a6:	68ac                	ld	a1,80(s1)
    800011a8:	00000097          	auipc	ra,0x0
    800011ac:	f8c080e7          	jalr	-116(ra) # 80001134 <proc_freepagetable>
  p->pagetable = 0;
    800011b0:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    800011b4:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    800011b8:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    800011bc:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    800011c0:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    800011c4:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    800011c8:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    800011cc:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    800011d0:	0204a023          	sw	zero,32(s1)
}
    800011d4:	60e2                	ld	ra,24(sp)
    800011d6:	6442                	ld	s0,16(sp)
    800011d8:	64a2                	ld	s1,8(sp)
    800011da:	6105                	addi	sp,sp,32
    800011dc:	8082                	ret

00000000800011de <allocproc>:
{
    800011de:	1101                	addi	sp,sp,-32
    800011e0:	ec06                	sd	ra,24(sp)
    800011e2:	e822                	sd	s0,16(sp)
    800011e4:	e426                	sd	s1,8(sp)
    800011e6:	e04a                	sd	s2,0(sp)
    800011e8:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011ea:	00008497          	auipc	s1,0x8
    800011ee:	3c648493          	addi	s1,s1,966 # 800095b0 <proc>
    800011f2:	0000e917          	auipc	s2,0xe
    800011f6:	fbe90913          	addi	s2,s2,-66 # 8000f1b0 <tickslock>
    acquire(&p->lock);
    800011fa:	8526                	mv	a0,s1
    800011fc:	00005097          	auipc	ra,0x5
    80001200:	474080e7          	jalr	1140(ra) # 80006670 <acquire>
    if(p->state == UNUSED) {
    80001204:	509c                	lw	a5,32(s1)
    80001206:	cf81                	beqz	a5,8000121e <allocproc+0x40>
      release(&p->lock);
    80001208:	8526                	mv	a0,s1
    8000120a:	00005097          	auipc	ra,0x5
    8000120e:	536080e7          	jalr	1334(ra) # 80006740 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001212:	17048493          	addi	s1,s1,368
    80001216:	ff2492e3          	bne	s1,s2,800011fa <allocproc+0x1c>
  return 0;
    8000121a:	4481                	li	s1,0
    8000121c:	a889                	j	8000126e <allocproc+0x90>
  p->pid = allocpid();
    8000121e:	00000097          	auipc	ra,0x0
    80001222:	e34080e7          	jalr	-460(ra) # 80001052 <allocpid>
    80001226:	dc88                	sw	a0,56(s1)
  p->state = USED;
    80001228:	4785                	li	a5,1
    8000122a:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000122c:	fffff097          	auipc	ra,0xfffff
    80001230:	fc8080e7          	jalr	-56(ra) # 800001f4 <kalloc>
    80001234:	892a                	mv	s2,a0
    80001236:	f0a8                	sd	a0,96(s1)
    80001238:	c131                	beqz	a0,8000127c <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000123a:	8526                	mv	a0,s1
    8000123c:	00000097          	auipc	ra,0x0
    80001240:	e5c080e7          	jalr	-420(ra) # 80001098 <proc_pagetable>
    80001244:	892a                	mv	s2,a0
    80001246:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    80001248:	c531                	beqz	a0,80001294 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000124a:	07000613          	li	a2,112
    8000124e:	4581                	li	a1,0
    80001250:	06848513          	addi	a0,s1,104
    80001254:	fffff097          	auipc	ra,0xfffff
    80001258:	0a0080e7          	jalr	160(ra) # 800002f4 <memset>
  p->context.ra = (uint64)forkret;
    8000125c:	00000797          	auipc	a5,0x0
    80001260:	db078793          	addi	a5,a5,-592 # 8000100c <forkret>
    80001264:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001266:	64bc                	ld	a5,72(s1)
    80001268:	6705                	lui	a4,0x1
    8000126a:	97ba                	add	a5,a5,a4
    8000126c:	f8bc                	sd	a5,112(s1)
}
    8000126e:	8526                	mv	a0,s1
    80001270:	60e2                	ld	ra,24(sp)
    80001272:	6442                	ld	s0,16(sp)
    80001274:	64a2                	ld	s1,8(sp)
    80001276:	6902                	ld	s2,0(sp)
    80001278:	6105                	addi	sp,sp,32
    8000127a:	8082                	ret
    freeproc(p);
    8000127c:	8526                	mv	a0,s1
    8000127e:	00000097          	auipc	ra,0x0
    80001282:	f08080e7          	jalr	-248(ra) # 80001186 <freeproc>
    release(&p->lock);
    80001286:	8526                	mv	a0,s1
    80001288:	00005097          	auipc	ra,0x5
    8000128c:	4b8080e7          	jalr	1208(ra) # 80006740 <release>
    return 0;
    80001290:	84ca                	mv	s1,s2
    80001292:	bff1                	j	8000126e <allocproc+0x90>
    freeproc(p);
    80001294:	8526                	mv	a0,s1
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	ef0080e7          	jalr	-272(ra) # 80001186 <freeproc>
    release(&p->lock);
    8000129e:	8526                	mv	a0,s1
    800012a0:	00005097          	auipc	ra,0x5
    800012a4:	4a0080e7          	jalr	1184(ra) # 80006740 <release>
    return 0;
    800012a8:	84ca                	mv	s1,s2
    800012aa:	b7d1                	j	8000126e <allocproc+0x90>

00000000800012ac <userinit>:
{
    800012ac:	1101                	addi	sp,sp,-32
    800012ae:	ec06                	sd	ra,24(sp)
    800012b0:	e822                	sd	s0,16(sp)
    800012b2:	e426                	sd	s1,8(sp)
    800012b4:	1000                	addi	s0,sp,32
  p = allocproc();
    800012b6:	00000097          	auipc	ra,0x0
    800012ba:	f28080e7          	jalr	-216(ra) # 800011de <allocproc>
    800012be:	84aa                	mv	s1,a0
  initproc = p;
    800012c0:	00008797          	auipc	a5,0x8
    800012c4:	d4a7b823          	sd	a0,-688(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800012c8:	03400613          	li	a2,52
    800012cc:	00007597          	auipc	a1,0x7
    800012d0:	61458593          	addi	a1,a1,1556 # 800088e0 <initcode>
    800012d4:	6d28                	ld	a0,88(a0)
    800012d6:	fffff097          	auipc	ra,0xfffff
    800012da:	6b6080e7          	jalr	1718(ra) # 8000098c <uvminit>
  p->sz = PGSIZE;
    800012de:	6785                	lui	a5,0x1
    800012e0:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    800012e2:	70b8                	ld	a4,96(s1)
    800012e4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012e8:	70b8                	ld	a4,96(s1)
    800012ea:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012ec:	4641                	li	a2,16
    800012ee:	00007597          	auipc	a1,0x7
    800012f2:	e9258593          	addi	a1,a1,-366 # 80008180 <etext+0x180>
    800012f6:	16048513          	addi	a0,s1,352
    800012fa:	fffff097          	auipc	ra,0xfffff
    800012fe:	14c080e7          	jalr	332(ra) # 80000446 <safestrcpy>
  p->cwd = namei("/");
    80001302:	00007517          	auipc	a0,0x7
    80001306:	e8e50513          	addi	a0,a0,-370 # 80008190 <etext+0x190>
    8000130a:	00002097          	auipc	ra,0x2
    8000130e:	1f2080e7          	jalr	498(ra) # 800034fc <namei>
    80001312:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001316:	478d                	li	a5,3
    80001318:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    8000131a:	8526                	mv	a0,s1
    8000131c:	00005097          	auipc	ra,0x5
    80001320:	424080e7          	jalr	1060(ra) # 80006740 <release>
}
    80001324:	60e2                	ld	ra,24(sp)
    80001326:	6442                	ld	s0,16(sp)
    80001328:	64a2                	ld	s1,8(sp)
    8000132a:	6105                	addi	sp,sp,32
    8000132c:	8082                	ret

000000008000132e <growproc>:
{
    8000132e:	1101                	addi	sp,sp,-32
    80001330:	ec06                	sd	ra,24(sp)
    80001332:	e822                	sd	s0,16(sp)
    80001334:	e426                	sd	s1,8(sp)
    80001336:	e04a                	sd	s2,0(sp)
    80001338:	1000                	addi	s0,sp,32
    8000133a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000133c:	00000097          	auipc	ra,0x0
    80001340:	c98080e7          	jalr	-872(ra) # 80000fd4 <myproc>
    80001344:	892a                	mv	s2,a0
  sz = p->sz;
    80001346:	692c                	ld	a1,80(a0)
    80001348:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000134c:	00904f63          	bgtz	s1,8000136a <growproc+0x3c>
  } else if(n < 0){
    80001350:	0204cc63          	bltz	s1,80001388 <growproc+0x5a>
  p->sz = sz;
    80001354:	1602                	slli	a2,a2,0x20
    80001356:	9201                	srli	a2,a2,0x20
    80001358:	04c93823          	sd	a2,80(s2)
  return 0;
    8000135c:	4501                	li	a0,0
}
    8000135e:	60e2                	ld	ra,24(sp)
    80001360:	6442                	ld	s0,16(sp)
    80001362:	64a2                	ld	s1,8(sp)
    80001364:	6902                	ld	s2,0(sp)
    80001366:	6105                	addi	sp,sp,32
    80001368:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000136a:	9e25                	addw	a2,a2,s1
    8000136c:	1602                	slli	a2,a2,0x20
    8000136e:	9201                	srli	a2,a2,0x20
    80001370:	1582                	slli	a1,a1,0x20
    80001372:	9181                	srli	a1,a1,0x20
    80001374:	6d28                	ld	a0,88(a0)
    80001376:	fffff097          	auipc	ra,0xfffff
    8000137a:	6d0080e7          	jalr	1744(ra) # 80000a46 <uvmalloc>
    8000137e:	0005061b          	sext.w	a2,a0
    80001382:	fa69                	bnez	a2,80001354 <growproc+0x26>
      return -1;
    80001384:	557d                	li	a0,-1
    80001386:	bfe1                	j	8000135e <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001388:	9e25                	addw	a2,a2,s1
    8000138a:	1602                	slli	a2,a2,0x20
    8000138c:	9201                	srli	a2,a2,0x20
    8000138e:	1582                	slli	a1,a1,0x20
    80001390:	9181                	srli	a1,a1,0x20
    80001392:	6d28                	ld	a0,88(a0)
    80001394:	fffff097          	auipc	ra,0xfffff
    80001398:	66a080e7          	jalr	1642(ra) # 800009fe <uvmdealloc>
    8000139c:	0005061b          	sext.w	a2,a0
    800013a0:	bf55                	j	80001354 <growproc+0x26>

00000000800013a2 <fork>:
{
    800013a2:	7179                	addi	sp,sp,-48
    800013a4:	f406                	sd	ra,40(sp)
    800013a6:	f022                	sd	s0,32(sp)
    800013a8:	ec26                	sd	s1,24(sp)
    800013aa:	e84a                	sd	s2,16(sp)
    800013ac:	e44e                	sd	s3,8(sp)
    800013ae:	e052                	sd	s4,0(sp)
    800013b0:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013b2:	00000097          	auipc	ra,0x0
    800013b6:	c22080e7          	jalr	-990(ra) # 80000fd4 <myproc>
    800013ba:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800013bc:	00000097          	auipc	ra,0x0
    800013c0:	e22080e7          	jalr	-478(ra) # 800011de <allocproc>
    800013c4:	10050b63          	beqz	a0,800014da <fork+0x138>
    800013c8:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013ca:	05093603          	ld	a2,80(s2)
    800013ce:	6d2c                	ld	a1,88(a0)
    800013d0:	05893503          	ld	a0,88(s2)
    800013d4:	fffff097          	auipc	ra,0xfffff
    800013d8:	7be080e7          	jalr	1982(ra) # 80000b92 <uvmcopy>
    800013dc:	04054663          	bltz	a0,80001428 <fork+0x86>
  np->sz = p->sz;
    800013e0:	05093783          	ld	a5,80(s2)
    800013e4:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    800013e8:	06093683          	ld	a3,96(s2)
    800013ec:	87b6                	mv	a5,a3
    800013ee:	0609b703          	ld	a4,96(s3)
    800013f2:	12068693          	addi	a3,a3,288
    800013f6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013fa:	6788                	ld	a0,8(a5)
    800013fc:	6b8c                	ld	a1,16(a5)
    800013fe:	6f90                	ld	a2,24(a5)
    80001400:	01073023          	sd	a6,0(a4)
    80001404:	e708                	sd	a0,8(a4)
    80001406:	eb0c                	sd	a1,16(a4)
    80001408:	ef10                	sd	a2,24(a4)
    8000140a:	02078793          	addi	a5,a5,32
    8000140e:	02070713          	addi	a4,a4,32
    80001412:	fed792e3          	bne	a5,a3,800013f6 <fork+0x54>
  np->trapframe->a0 = 0;
    80001416:	0609b783          	ld	a5,96(s3)
    8000141a:	0607b823          	sd	zero,112(a5)
    8000141e:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    80001422:	15800a13          	li	s4,344
    80001426:	a03d                	j	80001454 <fork+0xb2>
    freeproc(np);
    80001428:	854e                	mv	a0,s3
    8000142a:	00000097          	auipc	ra,0x0
    8000142e:	d5c080e7          	jalr	-676(ra) # 80001186 <freeproc>
    release(&np->lock);
    80001432:	854e                	mv	a0,s3
    80001434:	00005097          	auipc	ra,0x5
    80001438:	30c080e7          	jalr	780(ra) # 80006740 <release>
    return -1;
    8000143c:	5a7d                	li	s4,-1
    8000143e:	a069                	j	800014c8 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001440:	00002097          	auipc	ra,0x2
    80001444:	752080e7          	jalr	1874(ra) # 80003b92 <filedup>
    80001448:	009987b3          	add	a5,s3,s1
    8000144c:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000144e:	04a1                	addi	s1,s1,8
    80001450:	01448763          	beq	s1,s4,8000145e <fork+0xbc>
    if(p->ofile[i])
    80001454:	009907b3          	add	a5,s2,s1
    80001458:	6388                	ld	a0,0(a5)
    8000145a:	f17d                	bnez	a0,80001440 <fork+0x9e>
    8000145c:	bfcd                	j	8000144e <fork+0xac>
  np->cwd = idup(p->cwd);
    8000145e:	15893503          	ld	a0,344(s2)
    80001462:	00002097          	auipc	ra,0x2
    80001466:	8a6080e7          	jalr	-1882(ra) # 80002d08 <idup>
    8000146a:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000146e:	4641                	li	a2,16
    80001470:	16090593          	addi	a1,s2,352
    80001474:	16098513          	addi	a0,s3,352
    80001478:	fffff097          	auipc	ra,0xfffff
    8000147c:	fce080e7          	jalr	-50(ra) # 80000446 <safestrcpy>
  pid = np->pid;
    80001480:	0389aa03          	lw	s4,56(s3)
  release(&np->lock);
    80001484:	854e                	mv	a0,s3
    80001486:	00005097          	auipc	ra,0x5
    8000148a:	2ba080e7          	jalr	698(ra) # 80006740 <release>
  acquire(&wait_lock);
    8000148e:	00008497          	auipc	s1,0x8
    80001492:	d0248493          	addi	s1,s1,-766 # 80009190 <wait_lock>
    80001496:	8526                	mv	a0,s1
    80001498:	00005097          	auipc	ra,0x5
    8000149c:	1d8080e7          	jalr	472(ra) # 80006670 <acquire>
  np->parent = p;
    800014a0:	0529b023          	sd	s2,64(s3)
  release(&wait_lock);
    800014a4:	8526                	mv	a0,s1
    800014a6:	00005097          	auipc	ra,0x5
    800014aa:	29a080e7          	jalr	666(ra) # 80006740 <release>
  acquire(&np->lock);
    800014ae:	854e                	mv	a0,s3
    800014b0:	00005097          	auipc	ra,0x5
    800014b4:	1c0080e7          	jalr	448(ra) # 80006670 <acquire>
  np->state = RUNNABLE;
    800014b8:	478d                	li	a5,3
    800014ba:	02f9a023          	sw	a5,32(s3)
  release(&np->lock);
    800014be:	854e                	mv	a0,s3
    800014c0:	00005097          	auipc	ra,0x5
    800014c4:	280080e7          	jalr	640(ra) # 80006740 <release>
}
    800014c8:	8552                	mv	a0,s4
    800014ca:	70a2                	ld	ra,40(sp)
    800014cc:	7402                	ld	s0,32(sp)
    800014ce:	64e2                	ld	s1,24(sp)
    800014d0:	6942                	ld	s2,16(sp)
    800014d2:	69a2                	ld	s3,8(sp)
    800014d4:	6a02                	ld	s4,0(sp)
    800014d6:	6145                	addi	sp,sp,48
    800014d8:	8082                	ret
    return -1;
    800014da:	5a7d                	li	s4,-1
    800014dc:	b7f5                	j	800014c8 <fork+0x126>

00000000800014de <scheduler>:
{
    800014de:	7139                	addi	sp,sp,-64
    800014e0:	fc06                	sd	ra,56(sp)
    800014e2:	f822                	sd	s0,48(sp)
    800014e4:	f426                	sd	s1,40(sp)
    800014e6:	f04a                	sd	s2,32(sp)
    800014e8:	ec4e                	sd	s3,24(sp)
    800014ea:	e852                	sd	s4,16(sp)
    800014ec:	e456                	sd	s5,8(sp)
    800014ee:	e05a                	sd	s6,0(sp)
    800014f0:	0080                	addi	s0,sp,64
    800014f2:	8792                	mv	a5,tp
  int id = r_tp();
    800014f4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014f6:	00779a93          	slli	s5,a5,0x7
    800014fa:	00008717          	auipc	a4,0x8
    800014fe:	c7670713          	addi	a4,a4,-906 # 80009170 <pid_lock>
    80001502:	9756                	add	a4,a4,s5
    80001504:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &p->context);
    80001508:	00008717          	auipc	a4,0x8
    8000150c:	cb070713          	addi	a4,a4,-848 # 800091b8 <cpus+0x8>
    80001510:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001512:	498d                	li	s3,3
        p->state = RUNNING;
    80001514:	4b11                	li	s6,4
        c->proc = p;
    80001516:	079e                	slli	a5,a5,0x7
    80001518:	00008a17          	auipc	s4,0x8
    8000151c:	c58a0a13          	addi	s4,s4,-936 # 80009170 <pid_lock>
    80001520:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001522:	0000e917          	auipc	s2,0xe
    80001526:	c8e90913          	addi	s2,s2,-882 # 8000f1b0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000152a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000152e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001532:	10079073          	csrw	sstatus,a5
    80001536:	00008497          	auipc	s1,0x8
    8000153a:	07a48493          	addi	s1,s1,122 # 800095b0 <proc>
    8000153e:	a03d                	j	8000156c <scheduler+0x8e>
        p->state = RUNNING;
    80001540:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    80001544:	049a3023          	sd	s1,64(s4)
        swtch(&c->context, &p->context);
    80001548:	06848593          	addi	a1,s1,104
    8000154c:	8556                	mv	a0,s5
    8000154e:	00000097          	auipc	ra,0x0
    80001552:	640080e7          	jalr	1600(ra) # 80001b8e <swtch>
        c->proc = 0;
    80001556:	040a3023          	sd	zero,64(s4)
      release(&p->lock);
    8000155a:	8526                	mv	a0,s1
    8000155c:	00005097          	auipc	ra,0x5
    80001560:	1e4080e7          	jalr	484(ra) # 80006740 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001564:	17048493          	addi	s1,s1,368
    80001568:	fd2481e3          	beq	s1,s2,8000152a <scheduler+0x4c>
      acquire(&p->lock);
    8000156c:	8526                	mv	a0,s1
    8000156e:	00005097          	auipc	ra,0x5
    80001572:	102080e7          	jalr	258(ra) # 80006670 <acquire>
      if(p->state == RUNNABLE) {
    80001576:	509c                	lw	a5,32(s1)
    80001578:	ff3791e3          	bne	a5,s3,8000155a <scheduler+0x7c>
    8000157c:	b7d1                	j	80001540 <scheduler+0x62>

000000008000157e <sched>:
{
    8000157e:	7179                	addi	sp,sp,-48
    80001580:	f406                	sd	ra,40(sp)
    80001582:	f022                	sd	s0,32(sp)
    80001584:	ec26                	sd	s1,24(sp)
    80001586:	e84a                	sd	s2,16(sp)
    80001588:	e44e                	sd	s3,8(sp)
    8000158a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000158c:	00000097          	auipc	ra,0x0
    80001590:	a48080e7          	jalr	-1464(ra) # 80000fd4 <myproc>
    80001594:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001596:	00005097          	auipc	ra,0x5
    8000159a:	060080e7          	jalr	96(ra) # 800065f6 <holding>
    8000159e:	c93d                	beqz	a0,80001614 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015a0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015a2:	2781                	sext.w	a5,a5
    800015a4:	079e                	slli	a5,a5,0x7
    800015a6:	00008717          	auipc	a4,0x8
    800015aa:	bca70713          	addi	a4,a4,-1078 # 80009170 <pid_lock>
    800015ae:	97ba                	add	a5,a5,a4
    800015b0:	0b87a703          	lw	a4,184(a5)
    800015b4:	4785                	li	a5,1
    800015b6:	06f71763          	bne	a4,a5,80001624 <sched+0xa6>
  if(p->state == RUNNING)
    800015ba:	5098                	lw	a4,32(s1)
    800015bc:	4791                	li	a5,4
    800015be:	06f70b63          	beq	a4,a5,80001634 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015c2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015c6:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015c8:	efb5                	bnez	a5,80001644 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015ca:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015cc:	00008917          	auipc	s2,0x8
    800015d0:	ba490913          	addi	s2,s2,-1116 # 80009170 <pid_lock>
    800015d4:	2781                	sext.w	a5,a5
    800015d6:	079e                	slli	a5,a5,0x7
    800015d8:	97ca                	add	a5,a5,s2
    800015da:	0bc7a983          	lw	s3,188(a5)
    800015de:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015e0:	2781                	sext.w	a5,a5
    800015e2:	079e                	slli	a5,a5,0x7
    800015e4:	00008597          	auipc	a1,0x8
    800015e8:	bd458593          	addi	a1,a1,-1068 # 800091b8 <cpus+0x8>
    800015ec:	95be                	add	a1,a1,a5
    800015ee:	06848513          	addi	a0,s1,104
    800015f2:	00000097          	auipc	ra,0x0
    800015f6:	59c080e7          	jalr	1436(ra) # 80001b8e <swtch>
    800015fa:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015fc:	2781                	sext.w	a5,a5
    800015fe:	079e                	slli	a5,a5,0x7
    80001600:	97ca                	add	a5,a5,s2
    80001602:	0b37ae23          	sw	s3,188(a5)
}
    80001606:	70a2                	ld	ra,40(sp)
    80001608:	7402                	ld	s0,32(sp)
    8000160a:	64e2                	ld	s1,24(sp)
    8000160c:	6942                	ld	s2,16(sp)
    8000160e:	69a2                	ld	s3,8(sp)
    80001610:	6145                	addi	sp,sp,48
    80001612:	8082                	ret
    panic("sched p->lock");
    80001614:	00007517          	auipc	a0,0x7
    80001618:	b8450513          	addi	a0,a0,-1148 # 80008198 <etext+0x198>
    8000161c:	00005097          	auipc	ra,0x5
    80001620:	b20080e7          	jalr	-1248(ra) # 8000613c <panic>
    panic("sched locks");
    80001624:	00007517          	auipc	a0,0x7
    80001628:	b8450513          	addi	a0,a0,-1148 # 800081a8 <etext+0x1a8>
    8000162c:	00005097          	auipc	ra,0x5
    80001630:	b10080e7          	jalr	-1264(ra) # 8000613c <panic>
    panic("sched running");
    80001634:	00007517          	auipc	a0,0x7
    80001638:	b8450513          	addi	a0,a0,-1148 # 800081b8 <etext+0x1b8>
    8000163c:	00005097          	auipc	ra,0x5
    80001640:	b00080e7          	jalr	-1280(ra) # 8000613c <panic>
    panic("sched interruptible");
    80001644:	00007517          	auipc	a0,0x7
    80001648:	b8450513          	addi	a0,a0,-1148 # 800081c8 <etext+0x1c8>
    8000164c:	00005097          	auipc	ra,0x5
    80001650:	af0080e7          	jalr	-1296(ra) # 8000613c <panic>

0000000080001654 <yield>:
{
    80001654:	1101                	addi	sp,sp,-32
    80001656:	ec06                	sd	ra,24(sp)
    80001658:	e822                	sd	s0,16(sp)
    8000165a:	e426                	sd	s1,8(sp)
    8000165c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000165e:	00000097          	auipc	ra,0x0
    80001662:	976080e7          	jalr	-1674(ra) # 80000fd4 <myproc>
    80001666:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001668:	00005097          	auipc	ra,0x5
    8000166c:	008080e7          	jalr	8(ra) # 80006670 <acquire>
  p->state = RUNNABLE;
    80001670:	478d                	li	a5,3
    80001672:	d09c                	sw	a5,32(s1)
  sched();
    80001674:	00000097          	auipc	ra,0x0
    80001678:	f0a080e7          	jalr	-246(ra) # 8000157e <sched>
  release(&p->lock);
    8000167c:	8526                	mv	a0,s1
    8000167e:	00005097          	auipc	ra,0x5
    80001682:	0c2080e7          	jalr	194(ra) # 80006740 <release>
}
    80001686:	60e2                	ld	ra,24(sp)
    80001688:	6442                	ld	s0,16(sp)
    8000168a:	64a2                	ld	s1,8(sp)
    8000168c:	6105                	addi	sp,sp,32
    8000168e:	8082                	ret

0000000080001690 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001690:	7179                	addi	sp,sp,-48
    80001692:	f406                	sd	ra,40(sp)
    80001694:	f022                	sd	s0,32(sp)
    80001696:	ec26                	sd	s1,24(sp)
    80001698:	e84a                	sd	s2,16(sp)
    8000169a:	e44e                	sd	s3,8(sp)
    8000169c:	1800                	addi	s0,sp,48
    8000169e:	89aa                	mv	s3,a0
    800016a0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016a2:	00000097          	auipc	ra,0x0
    800016a6:	932080e7          	jalr	-1742(ra) # 80000fd4 <myproc>
    800016aa:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016ac:	00005097          	auipc	ra,0x5
    800016b0:	fc4080e7          	jalr	-60(ra) # 80006670 <acquire>
  release(lk);
    800016b4:	854a                	mv	a0,s2
    800016b6:	00005097          	auipc	ra,0x5
    800016ba:	08a080e7          	jalr	138(ra) # 80006740 <release>

  // Go to sleep.
  p->chan = chan;
    800016be:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800016c2:	4789                	li	a5,2
    800016c4:	d09c                	sw	a5,32(s1)

  sched();
    800016c6:	00000097          	auipc	ra,0x0
    800016ca:	eb8080e7          	jalr	-328(ra) # 8000157e <sched>

  // Tidy up.
  p->chan = 0;
    800016ce:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016d2:	8526                	mv	a0,s1
    800016d4:	00005097          	auipc	ra,0x5
    800016d8:	06c080e7          	jalr	108(ra) # 80006740 <release>
  acquire(lk);
    800016dc:	854a                	mv	a0,s2
    800016de:	00005097          	auipc	ra,0x5
    800016e2:	f92080e7          	jalr	-110(ra) # 80006670 <acquire>
}
    800016e6:	70a2                	ld	ra,40(sp)
    800016e8:	7402                	ld	s0,32(sp)
    800016ea:	64e2                	ld	s1,24(sp)
    800016ec:	6942                	ld	s2,16(sp)
    800016ee:	69a2                	ld	s3,8(sp)
    800016f0:	6145                	addi	sp,sp,48
    800016f2:	8082                	ret

00000000800016f4 <wait>:
{
    800016f4:	715d                	addi	sp,sp,-80
    800016f6:	e486                	sd	ra,72(sp)
    800016f8:	e0a2                	sd	s0,64(sp)
    800016fa:	fc26                	sd	s1,56(sp)
    800016fc:	f84a                	sd	s2,48(sp)
    800016fe:	f44e                	sd	s3,40(sp)
    80001700:	f052                	sd	s4,32(sp)
    80001702:	ec56                	sd	s5,24(sp)
    80001704:	e85a                	sd	s6,16(sp)
    80001706:	e45e                	sd	s7,8(sp)
    80001708:	e062                	sd	s8,0(sp)
    8000170a:	0880                	addi	s0,sp,80
    8000170c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000170e:	00000097          	auipc	ra,0x0
    80001712:	8c6080e7          	jalr	-1850(ra) # 80000fd4 <myproc>
    80001716:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001718:	00008517          	auipc	a0,0x8
    8000171c:	a7850513          	addi	a0,a0,-1416 # 80009190 <wait_lock>
    80001720:	00005097          	auipc	ra,0x5
    80001724:	f50080e7          	jalr	-176(ra) # 80006670 <acquire>
    havekids = 0;
    80001728:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000172a:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    8000172c:	0000e997          	auipc	s3,0xe
    80001730:	a8498993          	addi	s3,s3,-1404 # 8000f1b0 <tickslock>
        havekids = 1;
    80001734:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001736:	00008c17          	auipc	s8,0x8
    8000173a:	a5ac0c13          	addi	s8,s8,-1446 # 80009190 <wait_lock>
    havekids = 0;
    8000173e:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001740:	00008497          	auipc	s1,0x8
    80001744:	e7048493          	addi	s1,s1,-400 # 800095b0 <proc>
    80001748:	a0bd                	j	800017b6 <wait+0xc2>
          pid = np->pid;
    8000174a:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000174e:	000b0e63          	beqz	s6,8000176a <wait+0x76>
    80001752:	4691                	li	a3,4
    80001754:	03448613          	addi	a2,s1,52
    80001758:	85da                	mv	a1,s6
    8000175a:	05893503          	ld	a0,88(s2)
    8000175e:	fffff097          	auipc	ra,0xfffff
    80001762:	538080e7          	jalr	1336(ra) # 80000c96 <copyout>
    80001766:	02054563          	bltz	a0,80001790 <wait+0x9c>
          freeproc(np);
    8000176a:	8526                	mv	a0,s1
    8000176c:	00000097          	auipc	ra,0x0
    80001770:	a1a080e7          	jalr	-1510(ra) # 80001186 <freeproc>
          release(&np->lock);
    80001774:	8526                	mv	a0,s1
    80001776:	00005097          	auipc	ra,0x5
    8000177a:	fca080e7          	jalr	-54(ra) # 80006740 <release>
          release(&wait_lock);
    8000177e:	00008517          	auipc	a0,0x8
    80001782:	a1250513          	addi	a0,a0,-1518 # 80009190 <wait_lock>
    80001786:	00005097          	auipc	ra,0x5
    8000178a:	fba080e7          	jalr	-70(ra) # 80006740 <release>
          return pid;
    8000178e:	a09d                	j	800017f4 <wait+0x100>
            release(&np->lock);
    80001790:	8526                	mv	a0,s1
    80001792:	00005097          	auipc	ra,0x5
    80001796:	fae080e7          	jalr	-82(ra) # 80006740 <release>
            release(&wait_lock);
    8000179a:	00008517          	auipc	a0,0x8
    8000179e:	9f650513          	addi	a0,a0,-1546 # 80009190 <wait_lock>
    800017a2:	00005097          	auipc	ra,0x5
    800017a6:	f9e080e7          	jalr	-98(ra) # 80006740 <release>
            return -1;
    800017aa:	59fd                	li	s3,-1
    800017ac:	a0a1                	j	800017f4 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800017ae:	17048493          	addi	s1,s1,368
    800017b2:	03348463          	beq	s1,s3,800017da <wait+0xe6>
      if(np->parent == p){
    800017b6:	60bc                	ld	a5,64(s1)
    800017b8:	ff279be3          	bne	a5,s2,800017ae <wait+0xba>
        acquire(&np->lock);
    800017bc:	8526                	mv	a0,s1
    800017be:	00005097          	auipc	ra,0x5
    800017c2:	eb2080e7          	jalr	-334(ra) # 80006670 <acquire>
        if(np->state == ZOMBIE){
    800017c6:	509c                	lw	a5,32(s1)
    800017c8:	f94781e3          	beq	a5,s4,8000174a <wait+0x56>
        release(&np->lock);
    800017cc:	8526                	mv	a0,s1
    800017ce:	00005097          	auipc	ra,0x5
    800017d2:	f72080e7          	jalr	-142(ra) # 80006740 <release>
        havekids = 1;
    800017d6:	8756                	mv	a4,s5
    800017d8:	bfd9                	j	800017ae <wait+0xba>
    if(!havekids || p->killed){
    800017da:	c701                	beqz	a4,800017e2 <wait+0xee>
    800017dc:	03092783          	lw	a5,48(s2)
    800017e0:	c79d                	beqz	a5,8000180e <wait+0x11a>
      release(&wait_lock);
    800017e2:	00008517          	auipc	a0,0x8
    800017e6:	9ae50513          	addi	a0,a0,-1618 # 80009190 <wait_lock>
    800017ea:	00005097          	auipc	ra,0x5
    800017ee:	f56080e7          	jalr	-170(ra) # 80006740 <release>
      return -1;
    800017f2:	59fd                	li	s3,-1
}
    800017f4:	854e                	mv	a0,s3
    800017f6:	60a6                	ld	ra,72(sp)
    800017f8:	6406                	ld	s0,64(sp)
    800017fa:	74e2                	ld	s1,56(sp)
    800017fc:	7942                	ld	s2,48(sp)
    800017fe:	79a2                	ld	s3,40(sp)
    80001800:	7a02                	ld	s4,32(sp)
    80001802:	6ae2                	ld	s5,24(sp)
    80001804:	6b42                	ld	s6,16(sp)
    80001806:	6ba2                	ld	s7,8(sp)
    80001808:	6c02                	ld	s8,0(sp)
    8000180a:	6161                	addi	sp,sp,80
    8000180c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000180e:	85e2                	mv	a1,s8
    80001810:	854a                	mv	a0,s2
    80001812:	00000097          	auipc	ra,0x0
    80001816:	e7e080e7          	jalr	-386(ra) # 80001690 <sleep>
    havekids = 0;
    8000181a:	b715                	j	8000173e <wait+0x4a>

000000008000181c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000181c:	7139                	addi	sp,sp,-64
    8000181e:	fc06                	sd	ra,56(sp)
    80001820:	f822                	sd	s0,48(sp)
    80001822:	f426                	sd	s1,40(sp)
    80001824:	f04a                	sd	s2,32(sp)
    80001826:	ec4e                	sd	s3,24(sp)
    80001828:	e852                	sd	s4,16(sp)
    8000182a:	e456                	sd	s5,8(sp)
    8000182c:	0080                	addi	s0,sp,64
    8000182e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001830:	00008497          	auipc	s1,0x8
    80001834:	d8048493          	addi	s1,s1,-640 # 800095b0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001838:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000183a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000183c:	0000e917          	auipc	s2,0xe
    80001840:	97490913          	addi	s2,s2,-1676 # 8000f1b0 <tickslock>
    80001844:	a821                	j	8000185c <wakeup+0x40>
        p->state = RUNNABLE;
    80001846:	0354a023          	sw	s5,32(s1)
      }
      release(&p->lock);
    8000184a:	8526                	mv	a0,s1
    8000184c:	00005097          	auipc	ra,0x5
    80001850:	ef4080e7          	jalr	-268(ra) # 80006740 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001854:	17048493          	addi	s1,s1,368
    80001858:	03248463          	beq	s1,s2,80001880 <wakeup+0x64>
    if(p != myproc()){
    8000185c:	fffff097          	auipc	ra,0xfffff
    80001860:	778080e7          	jalr	1912(ra) # 80000fd4 <myproc>
    80001864:	fea488e3          	beq	s1,a0,80001854 <wakeup+0x38>
      acquire(&p->lock);
    80001868:	8526                	mv	a0,s1
    8000186a:	00005097          	auipc	ra,0x5
    8000186e:	e06080e7          	jalr	-506(ra) # 80006670 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001872:	509c                	lw	a5,32(s1)
    80001874:	fd379be3          	bne	a5,s3,8000184a <wakeup+0x2e>
    80001878:	749c                	ld	a5,40(s1)
    8000187a:	fd4798e3          	bne	a5,s4,8000184a <wakeup+0x2e>
    8000187e:	b7e1                	j	80001846 <wakeup+0x2a>
    }
  }
}
    80001880:	70e2                	ld	ra,56(sp)
    80001882:	7442                	ld	s0,48(sp)
    80001884:	74a2                	ld	s1,40(sp)
    80001886:	7902                	ld	s2,32(sp)
    80001888:	69e2                	ld	s3,24(sp)
    8000188a:	6a42                	ld	s4,16(sp)
    8000188c:	6aa2                	ld	s5,8(sp)
    8000188e:	6121                	addi	sp,sp,64
    80001890:	8082                	ret

0000000080001892 <reparent>:
{
    80001892:	7179                	addi	sp,sp,-48
    80001894:	f406                	sd	ra,40(sp)
    80001896:	f022                	sd	s0,32(sp)
    80001898:	ec26                	sd	s1,24(sp)
    8000189a:	e84a                	sd	s2,16(sp)
    8000189c:	e44e                	sd	s3,8(sp)
    8000189e:	e052                	sd	s4,0(sp)
    800018a0:	1800                	addi	s0,sp,48
    800018a2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018a4:	00008497          	auipc	s1,0x8
    800018a8:	d0c48493          	addi	s1,s1,-756 # 800095b0 <proc>
      pp->parent = initproc;
    800018ac:	00007a17          	auipc	s4,0x7
    800018b0:	764a0a13          	addi	s4,s4,1892 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018b4:	0000e997          	auipc	s3,0xe
    800018b8:	8fc98993          	addi	s3,s3,-1796 # 8000f1b0 <tickslock>
    800018bc:	a029                	j	800018c6 <reparent+0x34>
    800018be:	17048493          	addi	s1,s1,368
    800018c2:	01348d63          	beq	s1,s3,800018dc <reparent+0x4a>
    if(pp->parent == p){
    800018c6:	60bc                	ld	a5,64(s1)
    800018c8:	ff279be3          	bne	a5,s2,800018be <reparent+0x2c>
      pp->parent = initproc;
    800018cc:	000a3503          	ld	a0,0(s4)
    800018d0:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    800018d2:	00000097          	auipc	ra,0x0
    800018d6:	f4a080e7          	jalr	-182(ra) # 8000181c <wakeup>
    800018da:	b7d5                	j	800018be <reparent+0x2c>
}
    800018dc:	70a2                	ld	ra,40(sp)
    800018de:	7402                	ld	s0,32(sp)
    800018e0:	64e2                	ld	s1,24(sp)
    800018e2:	6942                	ld	s2,16(sp)
    800018e4:	69a2                	ld	s3,8(sp)
    800018e6:	6a02                	ld	s4,0(sp)
    800018e8:	6145                	addi	sp,sp,48
    800018ea:	8082                	ret

00000000800018ec <exit>:
{
    800018ec:	7179                	addi	sp,sp,-48
    800018ee:	f406                	sd	ra,40(sp)
    800018f0:	f022                	sd	s0,32(sp)
    800018f2:	ec26                	sd	s1,24(sp)
    800018f4:	e84a                	sd	s2,16(sp)
    800018f6:	e44e                	sd	s3,8(sp)
    800018f8:	e052                	sd	s4,0(sp)
    800018fa:	1800                	addi	s0,sp,48
    800018fc:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800018fe:	fffff097          	auipc	ra,0xfffff
    80001902:	6d6080e7          	jalr	1750(ra) # 80000fd4 <myproc>
    80001906:	89aa                	mv	s3,a0
  if(p == initproc)
    80001908:	00007797          	auipc	a5,0x7
    8000190c:	7087b783          	ld	a5,1800(a5) # 80009010 <initproc>
    80001910:	0d850493          	addi	s1,a0,216
    80001914:	15850913          	addi	s2,a0,344
    80001918:	02a79363          	bne	a5,a0,8000193e <exit+0x52>
    panic("init exiting");
    8000191c:	00007517          	auipc	a0,0x7
    80001920:	8c450513          	addi	a0,a0,-1852 # 800081e0 <etext+0x1e0>
    80001924:	00005097          	auipc	ra,0x5
    80001928:	818080e7          	jalr	-2024(ra) # 8000613c <panic>
      fileclose(f);
    8000192c:	00002097          	auipc	ra,0x2
    80001930:	2b8080e7          	jalr	696(ra) # 80003be4 <fileclose>
      p->ofile[fd] = 0;
    80001934:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001938:	04a1                	addi	s1,s1,8
    8000193a:	01248563          	beq	s1,s2,80001944 <exit+0x58>
    if(p->ofile[fd]){
    8000193e:	6088                	ld	a0,0(s1)
    80001940:	f575                	bnez	a0,8000192c <exit+0x40>
    80001942:	bfdd                	j	80001938 <exit+0x4c>
  begin_op();
    80001944:	00002097          	auipc	ra,0x2
    80001948:	dd4080e7          	jalr	-556(ra) # 80003718 <begin_op>
  iput(p->cwd);
    8000194c:	1589b503          	ld	a0,344(s3)
    80001950:	00001097          	auipc	ra,0x1
    80001954:	5b0080e7          	jalr	1456(ra) # 80002f00 <iput>
  end_op();
    80001958:	00002097          	auipc	ra,0x2
    8000195c:	e40080e7          	jalr	-448(ra) # 80003798 <end_op>
  p->cwd = 0;
    80001960:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001964:	00008497          	auipc	s1,0x8
    80001968:	82c48493          	addi	s1,s1,-2004 # 80009190 <wait_lock>
    8000196c:	8526                	mv	a0,s1
    8000196e:	00005097          	auipc	ra,0x5
    80001972:	d02080e7          	jalr	-766(ra) # 80006670 <acquire>
  reparent(p);
    80001976:	854e                	mv	a0,s3
    80001978:	00000097          	auipc	ra,0x0
    8000197c:	f1a080e7          	jalr	-230(ra) # 80001892 <reparent>
  wakeup(p->parent);
    80001980:	0409b503          	ld	a0,64(s3)
    80001984:	00000097          	auipc	ra,0x0
    80001988:	e98080e7          	jalr	-360(ra) # 8000181c <wakeup>
  acquire(&p->lock);
    8000198c:	854e                	mv	a0,s3
    8000198e:	00005097          	auipc	ra,0x5
    80001992:	ce2080e7          	jalr	-798(ra) # 80006670 <acquire>
  p->xstate = status;
    80001996:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000199a:	4795                	li	a5,5
    8000199c:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    800019a0:	8526                	mv	a0,s1
    800019a2:	00005097          	auipc	ra,0x5
    800019a6:	d9e080e7          	jalr	-610(ra) # 80006740 <release>
  sched();
    800019aa:	00000097          	auipc	ra,0x0
    800019ae:	bd4080e7          	jalr	-1068(ra) # 8000157e <sched>
  panic("zombie exit");
    800019b2:	00007517          	auipc	a0,0x7
    800019b6:	83e50513          	addi	a0,a0,-1986 # 800081f0 <etext+0x1f0>
    800019ba:	00004097          	auipc	ra,0x4
    800019be:	782080e7          	jalr	1922(ra) # 8000613c <panic>

00000000800019c2 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800019c2:	7179                	addi	sp,sp,-48
    800019c4:	f406                	sd	ra,40(sp)
    800019c6:	f022                	sd	s0,32(sp)
    800019c8:	ec26                	sd	s1,24(sp)
    800019ca:	e84a                	sd	s2,16(sp)
    800019cc:	e44e                	sd	s3,8(sp)
    800019ce:	1800                	addi	s0,sp,48
    800019d0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800019d2:	00008497          	auipc	s1,0x8
    800019d6:	bde48493          	addi	s1,s1,-1058 # 800095b0 <proc>
    800019da:	0000d997          	auipc	s3,0xd
    800019de:	7d698993          	addi	s3,s3,2006 # 8000f1b0 <tickslock>
    acquire(&p->lock);
    800019e2:	8526                	mv	a0,s1
    800019e4:	00005097          	auipc	ra,0x5
    800019e8:	c8c080e7          	jalr	-884(ra) # 80006670 <acquire>
    if(p->pid == pid){
    800019ec:	5c9c                	lw	a5,56(s1)
    800019ee:	01278d63          	beq	a5,s2,80001a08 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019f2:	8526                	mv	a0,s1
    800019f4:	00005097          	auipc	ra,0x5
    800019f8:	d4c080e7          	jalr	-692(ra) # 80006740 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800019fc:	17048493          	addi	s1,s1,368
    80001a00:	ff3491e3          	bne	s1,s3,800019e2 <kill+0x20>
  }
  return -1;
    80001a04:	557d                	li	a0,-1
    80001a06:	a829                	j	80001a20 <kill+0x5e>
      p->killed = 1;
    80001a08:	4785                	li	a5,1
    80001a0a:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80001a0c:	5098                	lw	a4,32(s1)
    80001a0e:	4789                	li	a5,2
    80001a10:	00f70f63          	beq	a4,a5,80001a2e <kill+0x6c>
      release(&p->lock);
    80001a14:	8526                	mv	a0,s1
    80001a16:	00005097          	auipc	ra,0x5
    80001a1a:	d2a080e7          	jalr	-726(ra) # 80006740 <release>
      return 0;
    80001a1e:	4501                	li	a0,0
}
    80001a20:	70a2                	ld	ra,40(sp)
    80001a22:	7402                	ld	s0,32(sp)
    80001a24:	64e2                	ld	s1,24(sp)
    80001a26:	6942                	ld	s2,16(sp)
    80001a28:	69a2                	ld	s3,8(sp)
    80001a2a:	6145                	addi	sp,sp,48
    80001a2c:	8082                	ret
        p->state = RUNNABLE;
    80001a2e:	478d                	li	a5,3
    80001a30:	d09c                	sw	a5,32(s1)
    80001a32:	b7cd                	j	80001a14 <kill+0x52>

0000000080001a34 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a34:	7179                	addi	sp,sp,-48
    80001a36:	f406                	sd	ra,40(sp)
    80001a38:	f022                	sd	s0,32(sp)
    80001a3a:	ec26                	sd	s1,24(sp)
    80001a3c:	e84a                	sd	s2,16(sp)
    80001a3e:	e44e                	sd	s3,8(sp)
    80001a40:	e052                	sd	s4,0(sp)
    80001a42:	1800                	addi	s0,sp,48
    80001a44:	84aa                	mv	s1,a0
    80001a46:	892e                	mv	s2,a1
    80001a48:	89b2                	mv	s3,a2
    80001a4a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a4c:	fffff097          	auipc	ra,0xfffff
    80001a50:	588080e7          	jalr	1416(ra) # 80000fd4 <myproc>
  if(user_dst){
    80001a54:	c08d                	beqz	s1,80001a76 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a56:	86d2                	mv	a3,s4
    80001a58:	864e                	mv	a2,s3
    80001a5a:	85ca                	mv	a1,s2
    80001a5c:	6d28                	ld	a0,88(a0)
    80001a5e:	fffff097          	auipc	ra,0xfffff
    80001a62:	238080e7          	jalr	568(ra) # 80000c96 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a66:	70a2                	ld	ra,40(sp)
    80001a68:	7402                	ld	s0,32(sp)
    80001a6a:	64e2                	ld	s1,24(sp)
    80001a6c:	6942                	ld	s2,16(sp)
    80001a6e:	69a2                	ld	s3,8(sp)
    80001a70:	6a02                	ld	s4,0(sp)
    80001a72:	6145                	addi	sp,sp,48
    80001a74:	8082                	ret
    memmove((char *)dst, src, len);
    80001a76:	000a061b          	sext.w	a2,s4
    80001a7a:	85ce                	mv	a1,s3
    80001a7c:	854a                	mv	a0,s2
    80001a7e:	fffff097          	auipc	ra,0xfffff
    80001a82:	8d6080e7          	jalr	-1834(ra) # 80000354 <memmove>
    return 0;
    80001a86:	8526                	mv	a0,s1
    80001a88:	bff9                	j	80001a66 <either_copyout+0x32>

0000000080001a8a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a8a:	7179                	addi	sp,sp,-48
    80001a8c:	f406                	sd	ra,40(sp)
    80001a8e:	f022                	sd	s0,32(sp)
    80001a90:	ec26                	sd	s1,24(sp)
    80001a92:	e84a                	sd	s2,16(sp)
    80001a94:	e44e                	sd	s3,8(sp)
    80001a96:	e052                	sd	s4,0(sp)
    80001a98:	1800                	addi	s0,sp,48
    80001a9a:	892a                	mv	s2,a0
    80001a9c:	84ae                	mv	s1,a1
    80001a9e:	89b2                	mv	s3,a2
    80001aa0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001aa2:	fffff097          	auipc	ra,0xfffff
    80001aa6:	532080e7          	jalr	1330(ra) # 80000fd4 <myproc>
  if(user_src){
    80001aaa:	c08d                	beqz	s1,80001acc <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001aac:	86d2                	mv	a3,s4
    80001aae:	864e                	mv	a2,s3
    80001ab0:	85ca                	mv	a1,s2
    80001ab2:	6d28                	ld	a0,88(a0)
    80001ab4:	fffff097          	auipc	ra,0xfffff
    80001ab8:	26e080e7          	jalr	622(ra) # 80000d22 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001abc:	70a2                	ld	ra,40(sp)
    80001abe:	7402                	ld	s0,32(sp)
    80001ac0:	64e2                	ld	s1,24(sp)
    80001ac2:	6942                	ld	s2,16(sp)
    80001ac4:	69a2                	ld	s3,8(sp)
    80001ac6:	6a02                	ld	s4,0(sp)
    80001ac8:	6145                	addi	sp,sp,48
    80001aca:	8082                	ret
    memmove(dst, (char*)src, len);
    80001acc:	000a061b          	sext.w	a2,s4
    80001ad0:	85ce                	mv	a1,s3
    80001ad2:	854a                	mv	a0,s2
    80001ad4:	fffff097          	auipc	ra,0xfffff
    80001ad8:	880080e7          	jalr	-1920(ra) # 80000354 <memmove>
    return 0;
    80001adc:	8526                	mv	a0,s1
    80001ade:	bff9                	j	80001abc <either_copyin+0x32>

0000000080001ae0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001ae0:	715d                	addi	sp,sp,-80
    80001ae2:	e486                	sd	ra,72(sp)
    80001ae4:	e0a2                	sd	s0,64(sp)
    80001ae6:	fc26                	sd	s1,56(sp)
    80001ae8:	f84a                	sd	s2,48(sp)
    80001aea:	f44e                	sd	s3,40(sp)
    80001aec:	f052                	sd	s4,32(sp)
    80001aee:	ec56                	sd	s5,24(sp)
    80001af0:	e85a                	sd	s6,16(sp)
    80001af2:	e45e                	sd	s7,8(sp)
    80001af4:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001af6:	00007517          	auipc	a0,0x7
    80001afa:	d8250513          	addi	a0,a0,-638 # 80008878 <digits+0x88>
    80001afe:	00004097          	auipc	ra,0x4
    80001b02:	688080e7          	jalr	1672(ra) # 80006186 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b06:	00008497          	auipc	s1,0x8
    80001b0a:	c0a48493          	addi	s1,s1,-1014 # 80009710 <proc+0x160>
    80001b0e:	0000e917          	auipc	s2,0xe
    80001b12:	80290913          	addi	s2,s2,-2046 # 8000f310 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b16:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b18:	00006997          	auipc	s3,0x6
    80001b1c:	6e898993          	addi	s3,s3,1768 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001b20:	00006a97          	auipc	s5,0x6
    80001b24:	6e8a8a93          	addi	s5,s5,1768 # 80008208 <etext+0x208>
    printf("\n");
    80001b28:	00007a17          	auipc	s4,0x7
    80001b2c:	d50a0a13          	addi	s4,s4,-688 # 80008878 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b30:	00006b97          	auipc	s7,0x6
    80001b34:	710b8b93          	addi	s7,s7,1808 # 80008240 <states.1725>
    80001b38:	a00d                	j	80001b5a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b3a:	ed86a583          	lw	a1,-296(a3)
    80001b3e:	8556                	mv	a0,s5
    80001b40:	00004097          	auipc	ra,0x4
    80001b44:	646080e7          	jalr	1606(ra) # 80006186 <printf>
    printf("\n");
    80001b48:	8552                	mv	a0,s4
    80001b4a:	00004097          	auipc	ra,0x4
    80001b4e:	63c080e7          	jalr	1596(ra) # 80006186 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b52:	17048493          	addi	s1,s1,368
    80001b56:	03248163          	beq	s1,s2,80001b78 <procdump+0x98>
    if(p->state == UNUSED)
    80001b5a:	86a6                	mv	a3,s1
    80001b5c:	ec04a783          	lw	a5,-320(s1)
    80001b60:	dbed                	beqz	a5,80001b52 <procdump+0x72>
      state = "???";
    80001b62:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b64:	fcfb6be3          	bltu	s6,a5,80001b3a <procdump+0x5a>
    80001b68:	1782                	slli	a5,a5,0x20
    80001b6a:	9381                	srli	a5,a5,0x20
    80001b6c:	078e                	slli	a5,a5,0x3
    80001b6e:	97de                	add	a5,a5,s7
    80001b70:	6390                	ld	a2,0(a5)
    80001b72:	f661                	bnez	a2,80001b3a <procdump+0x5a>
      state = "???";
    80001b74:	864e                	mv	a2,s3
    80001b76:	b7d1                	j	80001b3a <procdump+0x5a>
  }
}
    80001b78:	60a6                	ld	ra,72(sp)
    80001b7a:	6406                	ld	s0,64(sp)
    80001b7c:	74e2                	ld	s1,56(sp)
    80001b7e:	7942                	ld	s2,48(sp)
    80001b80:	79a2                	ld	s3,40(sp)
    80001b82:	7a02                	ld	s4,32(sp)
    80001b84:	6ae2                	ld	s5,24(sp)
    80001b86:	6b42                	ld	s6,16(sp)
    80001b88:	6ba2                	ld	s7,8(sp)
    80001b8a:	6161                	addi	sp,sp,80
    80001b8c:	8082                	ret

0000000080001b8e <swtch>:
    80001b8e:	00153023          	sd	ra,0(a0)
    80001b92:	00253423          	sd	sp,8(a0)
    80001b96:	e900                	sd	s0,16(a0)
    80001b98:	ed04                	sd	s1,24(a0)
    80001b9a:	03253023          	sd	s2,32(a0)
    80001b9e:	03353423          	sd	s3,40(a0)
    80001ba2:	03453823          	sd	s4,48(a0)
    80001ba6:	03553c23          	sd	s5,56(a0)
    80001baa:	05653023          	sd	s6,64(a0)
    80001bae:	05753423          	sd	s7,72(a0)
    80001bb2:	05853823          	sd	s8,80(a0)
    80001bb6:	05953c23          	sd	s9,88(a0)
    80001bba:	07a53023          	sd	s10,96(a0)
    80001bbe:	07b53423          	sd	s11,104(a0)
    80001bc2:	0005b083          	ld	ra,0(a1)
    80001bc6:	0085b103          	ld	sp,8(a1)
    80001bca:	6980                	ld	s0,16(a1)
    80001bcc:	6d84                	ld	s1,24(a1)
    80001bce:	0205b903          	ld	s2,32(a1)
    80001bd2:	0285b983          	ld	s3,40(a1)
    80001bd6:	0305ba03          	ld	s4,48(a1)
    80001bda:	0385ba83          	ld	s5,56(a1)
    80001bde:	0405bb03          	ld	s6,64(a1)
    80001be2:	0485bb83          	ld	s7,72(a1)
    80001be6:	0505bc03          	ld	s8,80(a1)
    80001bea:	0585bc83          	ld	s9,88(a1)
    80001bee:	0605bd03          	ld	s10,96(a1)
    80001bf2:	0685bd83          	ld	s11,104(a1)
    80001bf6:	8082                	ret

0000000080001bf8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001bf8:	1141                	addi	sp,sp,-16
    80001bfa:	e406                	sd	ra,8(sp)
    80001bfc:	e022                	sd	s0,0(sp)
    80001bfe:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c00:	00006597          	auipc	a1,0x6
    80001c04:	67058593          	addi	a1,a1,1648 # 80008270 <states.1725+0x30>
    80001c08:	0000d517          	auipc	a0,0xd
    80001c0c:	5a850513          	addi	a0,a0,1448 # 8000f1b0 <tickslock>
    80001c10:	00005097          	auipc	ra,0x5
    80001c14:	bdc080e7          	jalr	-1060(ra) # 800067ec <initlock>
}
    80001c18:	60a2                	ld	ra,8(sp)
    80001c1a:	6402                	ld	s0,0(sp)
    80001c1c:	0141                	addi	sp,sp,16
    80001c1e:	8082                	ret

0000000080001c20 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c20:	1141                	addi	sp,sp,-16
    80001c22:	e422                	sd	s0,8(sp)
    80001c24:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c26:	00003797          	auipc	a5,0x3
    80001c2a:	5ea78793          	addi	a5,a5,1514 # 80005210 <kernelvec>
    80001c2e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c32:	6422                	ld	s0,8(sp)
    80001c34:	0141                	addi	sp,sp,16
    80001c36:	8082                	ret

0000000080001c38 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c38:	1141                	addi	sp,sp,-16
    80001c3a:	e406                	sd	ra,8(sp)
    80001c3c:	e022                	sd	s0,0(sp)
    80001c3e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c40:	fffff097          	auipc	ra,0xfffff
    80001c44:	394080e7          	jalr	916(ra) # 80000fd4 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c48:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c4c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c4e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c52:	00005617          	auipc	a2,0x5
    80001c56:	3ae60613          	addi	a2,a2,942 # 80007000 <_trampoline>
    80001c5a:	00005697          	auipc	a3,0x5
    80001c5e:	3a668693          	addi	a3,a3,934 # 80007000 <_trampoline>
    80001c62:	8e91                	sub	a3,a3,a2
    80001c64:	040007b7          	lui	a5,0x4000
    80001c68:	17fd                	addi	a5,a5,-1
    80001c6a:	07b2                	slli	a5,a5,0xc
    80001c6c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c6e:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c72:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c74:	180026f3          	csrr	a3,satp
    80001c78:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c7a:	7138                	ld	a4,96(a0)
    80001c7c:	6534                	ld	a3,72(a0)
    80001c7e:	6585                	lui	a1,0x1
    80001c80:	96ae                	add	a3,a3,a1
    80001c82:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c84:	7138                	ld	a4,96(a0)
    80001c86:	00000697          	auipc	a3,0x0
    80001c8a:	13868693          	addi	a3,a3,312 # 80001dbe <usertrap>
    80001c8e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c90:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c92:	8692                	mv	a3,tp
    80001c94:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c96:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c9a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c9e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ca2:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001ca6:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ca8:	6f18                	ld	a4,24(a4)
    80001caa:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cae:	6d2c                	ld	a1,88(a0)
    80001cb0:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001cb2:	00005717          	auipc	a4,0x5
    80001cb6:	3de70713          	addi	a4,a4,990 # 80007090 <userret>
    80001cba:	8f11                	sub	a4,a4,a2
    80001cbc:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001cbe:	577d                	li	a4,-1
    80001cc0:	177e                	slli	a4,a4,0x3f
    80001cc2:	8dd9                	or	a1,a1,a4
    80001cc4:	02000537          	lui	a0,0x2000
    80001cc8:	157d                	addi	a0,a0,-1
    80001cca:	0536                	slli	a0,a0,0xd
    80001ccc:	9782                	jalr	a5
}
    80001cce:	60a2                	ld	ra,8(sp)
    80001cd0:	6402                	ld	s0,0(sp)
    80001cd2:	0141                	addi	sp,sp,16
    80001cd4:	8082                	ret

0000000080001cd6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001cd6:	1101                	addi	sp,sp,-32
    80001cd8:	ec06                	sd	ra,24(sp)
    80001cda:	e822                	sd	s0,16(sp)
    80001cdc:	e426                	sd	s1,8(sp)
    80001cde:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001ce0:	0000d497          	auipc	s1,0xd
    80001ce4:	4d048493          	addi	s1,s1,1232 # 8000f1b0 <tickslock>
    80001ce8:	8526                	mv	a0,s1
    80001cea:	00005097          	auipc	ra,0x5
    80001cee:	986080e7          	jalr	-1658(ra) # 80006670 <acquire>
  ticks++;
    80001cf2:	00007517          	auipc	a0,0x7
    80001cf6:	32650513          	addi	a0,a0,806 # 80009018 <ticks>
    80001cfa:	411c                	lw	a5,0(a0)
    80001cfc:	2785                	addiw	a5,a5,1
    80001cfe:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d00:	00000097          	auipc	ra,0x0
    80001d04:	b1c080e7          	jalr	-1252(ra) # 8000181c <wakeup>
  release(&tickslock);
    80001d08:	8526                	mv	a0,s1
    80001d0a:	00005097          	auipc	ra,0x5
    80001d0e:	a36080e7          	jalr	-1482(ra) # 80006740 <release>
}
    80001d12:	60e2                	ld	ra,24(sp)
    80001d14:	6442                	ld	s0,16(sp)
    80001d16:	64a2                	ld	s1,8(sp)
    80001d18:	6105                	addi	sp,sp,32
    80001d1a:	8082                	ret

0000000080001d1c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d1c:	1101                	addi	sp,sp,-32
    80001d1e:	ec06                	sd	ra,24(sp)
    80001d20:	e822                	sd	s0,16(sp)
    80001d22:	e426                	sd	s1,8(sp)
    80001d24:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d26:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d2a:	00074d63          	bltz	a4,80001d44 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d2e:	57fd                	li	a5,-1
    80001d30:	17fe                	slli	a5,a5,0x3f
    80001d32:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d34:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d36:	06f70363          	beq	a4,a5,80001d9c <devintr+0x80>
  }
}
    80001d3a:	60e2                	ld	ra,24(sp)
    80001d3c:	6442                	ld	s0,16(sp)
    80001d3e:	64a2                	ld	s1,8(sp)
    80001d40:	6105                	addi	sp,sp,32
    80001d42:	8082                	ret
     (scause & 0xff) == 9){
    80001d44:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001d48:	46a5                	li	a3,9
    80001d4a:	fed792e3          	bne	a5,a3,80001d2e <devintr+0x12>
    int irq = plic_claim();
    80001d4e:	00003097          	auipc	ra,0x3
    80001d52:	5ca080e7          	jalr	1482(ra) # 80005318 <plic_claim>
    80001d56:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d58:	47a9                	li	a5,10
    80001d5a:	02f50763          	beq	a0,a5,80001d88 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d5e:	4785                	li	a5,1
    80001d60:	02f50963          	beq	a0,a5,80001d92 <devintr+0x76>
    return 1;
    80001d64:	4505                	li	a0,1
    } else if(irq){
    80001d66:	d8f1                	beqz	s1,80001d3a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d68:	85a6                	mv	a1,s1
    80001d6a:	00006517          	auipc	a0,0x6
    80001d6e:	50e50513          	addi	a0,a0,1294 # 80008278 <states.1725+0x38>
    80001d72:	00004097          	auipc	ra,0x4
    80001d76:	414080e7          	jalr	1044(ra) # 80006186 <printf>
      plic_complete(irq);
    80001d7a:	8526                	mv	a0,s1
    80001d7c:	00003097          	auipc	ra,0x3
    80001d80:	5c0080e7          	jalr	1472(ra) # 8000533c <plic_complete>
    return 1;
    80001d84:	4505                	li	a0,1
    80001d86:	bf55                	j	80001d3a <devintr+0x1e>
      uartintr();
    80001d88:	00005097          	auipc	ra,0x5
    80001d8c:	81e080e7          	jalr	-2018(ra) # 800065a6 <uartintr>
    80001d90:	b7ed                	j	80001d7a <devintr+0x5e>
      virtio_disk_intr();
    80001d92:	00004097          	auipc	ra,0x4
    80001d96:	a8a080e7          	jalr	-1398(ra) # 8000581c <virtio_disk_intr>
    80001d9a:	b7c5                	j	80001d7a <devintr+0x5e>
    if(cpuid() == 0){
    80001d9c:	fffff097          	auipc	ra,0xfffff
    80001da0:	20c080e7          	jalr	524(ra) # 80000fa8 <cpuid>
    80001da4:	c901                	beqz	a0,80001db4 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001da6:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001daa:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001dac:	14479073          	csrw	sip,a5
    return 2;
    80001db0:	4509                	li	a0,2
    80001db2:	b761                	j	80001d3a <devintr+0x1e>
      clockintr();
    80001db4:	00000097          	auipc	ra,0x0
    80001db8:	f22080e7          	jalr	-222(ra) # 80001cd6 <clockintr>
    80001dbc:	b7ed                	j	80001da6 <devintr+0x8a>

0000000080001dbe <usertrap>:
{
    80001dbe:	1101                	addi	sp,sp,-32
    80001dc0:	ec06                	sd	ra,24(sp)
    80001dc2:	e822                	sd	s0,16(sp)
    80001dc4:	e426                	sd	s1,8(sp)
    80001dc6:	e04a                	sd	s2,0(sp)
    80001dc8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dca:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001dce:	1007f793          	andi	a5,a5,256
    80001dd2:	e3ad                	bnez	a5,80001e34 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001dd4:	00003797          	auipc	a5,0x3
    80001dd8:	43c78793          	addi	a5,a5,1084 # 80005210 <kernelvec>
    80001ddc:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001de0:	fffff097          	auipc	ra,0xfffff
    80001de4:	1f4080e7          	jalr	500(ra) # 80000fd4 <myproc>
    80001de8:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001dea:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dec:	14102773          	csrr	a4,sepc
    80001df0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001df2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001df6:	47a1                	li	a5,8
    80001df8:	04f71c63          	bne	a4,a5,80001e50 <usertrap+0x92>
    if(p->killed)
    80001dfc:	591c                	lw	a5,48(a0)
    80001dfe:	e3b9                	bnez	a5,80001e44 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e00:	70b8                	ld	a4,96(s1)
    80001e02:	6f1c                	ld	a5,24(a4)
    80001e04:	0791                	addi	a5,a5,4
    80001e06:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e08:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e0c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e10:	10079073          	csrw	sstatus,a5
    syscall();
    80001e14:	00000097          	auipc	ra,0x0
    80001e18:	2e0080e7          	jalr	736(ra) # 800020f4 <syscall>
  if(p->killed)
    80001e1c:	589c                	lw	a5,48(s1)
    80001e1e:	ebc1                	bnez	a5,80001eae <usertrap+0xf0>
  usertrapret();
    80001e20:	00000097          	auipc	ra,0x0
    80001e24:	e18080e7          	jalr	-488(ra) # 80001c38 <usertrapret>
}
    80001e28:	60e2                	ld	ra,24(sp)
    80001e2a:	6442                	ld	s0,16(sp)
    80001e2c:	64a2                	ld	s1,8(sp)
    80001e2e:	6902                	ld	s2,0(sp)
    80001e30:	6105                	addi	sp,sp,32
    80001e32:	8082                	ret
    panic("usertrap: not from user mode");
    80001e34:	00006517          	auipc	a0,0x6
    80001e38:	46450513          	addi	a0,a0,1124 # 80008298 <states.1725+0x58>
    80001e3c:	00004097          	auipc	ra,0x4
    80001e40:	300080e7          	jalr	768(ra) # 8000613c <panic>
      exit(-1);
    80001e44:	557d                	li	a0,-1
    80001e46:	00000097          	auipc	ra,0x0
    80001e4a:	aa6080e7          	jalr	-1370(ra) # 800018ec <exit>
    80001e4e:	bf4d                	j	80001e00 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e50:	00000097          	auipc	ra,0x0
    80001e54:	ecc080e7          	jalr	-308(ra) # 80001d1c <devintr>
    80001e58:	892a                	mv	s2,a0
    80001e5a:	c501                	beqz	a0,80001e62 <usertrap+0xa4>
  if(p->killed)
    80001e5c:	589c                	lw	a5,48(s1)
    80001e5e:	c3a1                	beqz	a5,80001e9e <usertrap+0xe0>
    80001e60:	a815                	j	80001e94 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e62:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e66:	5c90                	lw	a2,56(s1)
    80001e68:	00006517          	auipc	a0,0x6
    80001e6c:	45050513          	addi	a0,a0,1104 # 800082b8 <states.1725+0x78>
    80001e70:	00004097          	auipc	ra,0x4
    80001e74:	316080e7          	jalr	790(ra) # 80006186 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e78:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e7c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e80:	00006517          	auipc	a0,0x6
    80001e84:	46850513          	addi	a0,a0,1128 # 800082e8 <states.1725+0xa8>
    80001e88:	00004097          	auipc	ra,0x4
    80001e8c:	2fe080e7          	jalr	766(ra) # 80006186 <printf>
    p->killed = 1;
    80001e90:	4785                	li	a5,1
    80001e92:	d89c                	sw	a5,48(s1)
    exit(-1);
    80001e94:	557d                	li	a0,-1
    80001e96:	00000097          	auipc	ra,0x0
    80001e9a:	a56080e7          	jalr	-1450(ra) # 800018ec <exit>
  if(which_dev == 2)
    80001e9e:	4789                	li	a5,2
    80001ea0:	f8f910e3          	bne	s2,a5,80001e20 <usertrap+0x62>
    yield();
    80001ea4:	fffff097          	auipc	ra,0xfffff
    80001ea8:	7b0080e7          	jalr	1968(ra) # 80001654 <yield>
    80001eac:	bf95                	j	80001e20 <usertrap+0x62>
  int which_dev = 0;
    80001eae:	4901                	li	s2,0
    80001eb0:	b7d5                	j	80001e94 <usertrap+0xd6>

0000000080001eb2 <kerneltrap>:
{
    80001eb2:	7179                	addi	sp,sp,-48
    80001eb4:	f406                	sd	ra,40(sp)
    80001eb6:	f022                	sd	s0,32(sp)
    80001eb8:	ec26                	sd	s1,24(sp)
    80001eba:	e84a                	sd	s2,16(sp)
    80001ebc:	e44e                	sd	s3,8(sp)
    80001ebe:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ec0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ec4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ec8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001ecc:	1004f793          	andi	a5,s1,256
    80001ed0:	cb85                	beqz	a5,80001f00 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ed2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ed6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ed8:	ef85                	bnez	a5,80001f10 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001eda:	00000097          	auipc	ra,0x0
    80001ede:	e42080e7          	jalr	-446(ra) # 80001d1c <devintr>
    80001ee2:	cd1d                	beqz	a0,80001f20 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ee4:	4789                	li	a5,2
    80001ee6:	06f50a63          	beq	a0,a5,80001f5a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001eea:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eee:	10049073          	csrw	sstatus,s1
}
    80001ef2:	70a2                	ld	ra,40(sp)
    80001ef4:	7402                	ld	s0,32(sp)
    80001ef6:	64e2                	ld	s1,24(sp)
    80001ef8:	6942                	ld	s2,16(sp)
    80001efa:	69a2                	ld	s3,8(sp)
    80001efc:	6145                	addi	sp,sp,48
    80001efe:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f00:	00006517          	auipc	a0,0x6
    80001f04:	40850513          	addi	a0,a0,1032 # 80008308 <states.1725+0xc8>
    80001f08:	00004097          	auipc	ra,0x4
    80001f0c:	234080e7          	jalr	564(ra) # 8000613c <panic>
    panic("kerneltrap: interrupts enabled");
    80001f10:	00006517          	auipc	a0,0x6
    80001f14:	42050513          	addi	a0,a0,1056 # 80008330 <states.1725+0xf0>
    80001f18:	00004097          	auipc	ra,0x4
    80001f1c:	224080e7          	jalr	548(ra) # 8000613c <panic>
    printf("scause %p\n", scause);
    80001f20:	85ce                	mv	a1,s3
    80001f22:	00006517          	auipc	a0,0x6
    80001f26:	42e50513          	addi	a0,a0,1070 # 80008350 <states.1725+0x110>
    80001f2a:	00004097          	auipc	ra,0x4
    80001f2e:	25c080e7          	jalr	604(ra) # 80006186 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f32:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f36:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f3a:	00006517          	auipc	a0,0x6
    80001f3e:	42650513          	addi	a0,a0,1062 # 80008360 <states.1725+0x120>
    80001f42:	00004097          	auipc	ra,0x4
    80001f46:	244080e7          	jalr	580(ra) # 80006186 <printf>
    panic("kerneltrap");
    80001f4a:	00006517          	auipc	a0,0x6
    80001f4e:	42e50513          	addi	a0,a0,1070 # 80008378 <states.1725+0x138>
    80001f52:	00004097          	auipc	ra,0x4
    80001f56:	1ea080e7          	jalr	490(ra) # 8000613c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f5a:	fffff097          	auipc	ra,0xfffff
    80001f5e:	07a080e7          	jalr	122(ra) # 80000fd4 <myproc>
    80001f62:	d541                	beqz	a0,80001eea <kerneltrap+0x38>
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	070080e7          	jalr	112(ra) # 80000fd4 <myproc>
    80001f6c:	5118                	lw	a4,32(a0)
    80001f6e:	4791                	li	a5,4
    80001f70:	f6f71de3          	bne	a4,a5,80001eea <kerneltrap+0x38>
    yield();
    80001f74:	fffff097          	auipc	ra,0xfffff
    80001f78:	6e0080e7          	jalr	1760(ra) # 80001654 <yield>
    80001f7c:	b7bd                	j	80001eea <kerneltrap+0x38>

0000000080001f7e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f7e:	1101                	addi	sp,sp,-32
    80001f80:	ec06                	sd	ra,24(sp)
    80001f82:	e822                	sd	s0,16(sp)
    80001f84:	e426                	sd	s1,8(sp)
    80001f86:	1000                	addi	s0,sp,32
    80001f88:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f8a:	fffff097          	auipc	ra,0xfffff
    80001f8e:	04a080e7          	jalr	74(ra) # 80000fd4 <myproc>
  switch (n) {
    80001f92:	4795                	li	a5,5
    80001f94:	0497e163          	bltu	a5,s1,80001fd6 <argraw+0x58>
    80001f98:	048a                	slli	s1,s1,0x2
    80001f9a:	00006717          	auipc	a4,0x6
    80001f9e:	41670713          	addi	a4,a4,1046 # 800083b0 <states.1725+0x170>
    80001fa2:	94ba                	add	s1,s1,a4
    80001fa4:	409c                	lw	a5,0(s1)
    80001fa6:	97ba                	add	a5,a5,a4
    80001fa8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001faa:	713c                	ld	a5,96(a0)
    80001fac:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fae:	60e2                	ld	ra,24(sp)
    80001fb0:	6442                	ld	s0,16(sp)
    80001fb2:	64a2                	ld	s1,8(sp)
    80001fb4:	6105                	addi	sp,sp,32
    80001fb6:	8082                	ret
    return p->trapframe->a1;
    80001fb8:	713c                	ld	a5,96(a0)
    80001fba:	7fa8                	ld	a0,120(a5)
    80001fbc:	bfcd                	j	80001fae <argraw+0x30>
    return p->trapframe->a2;
    80001fbe:	713c                	ld	a5,96(a0)
    80001fc0:	63c8                	ld	a0,128(a5)
    80001fc2:	b7f5                	j	80001fae <argraw+0x30>
    return p->trapframe->a3;
    80001fc4:	713c                	ld	a5,96(a0)
    80001fc6:	67c8                	ld	a0,136(a5)
    80001fc8:	b7dd                	j	80001fae <argraw+0x30>
    return p->trapframe->a4;
    80001fca:	713c                	ld	a5,96(a0)
    80001fcc:	6bc8                	ld	a0,144(a5)
    80001fce:	b7c5                	j	80001fae <argraw+0x30>
    return p->trapframe->a5;
    80001fd0:	713c                	ld	a5,96(a0)
    80001fd2:	6fc8                	ld	a0,152(a5)
    80001fd4:	bfe9                	j	80001fae <argraw+0x30>
  panic("argraw");
    80001fd6:	00006517          	auipc	a0,0x6
    80001fda:	3b250513          	addi	a0,a0,946 # 80008388 <states.1725+0x148>
    80001fde:	00004097          	auipc	ra,0x4
    80001fe2:	15e080e7          	jalr	350(ra) # 8000613c <panic>

0000000080001fe6 <fetchaddr>:
{
    80001fe6:	1101                	addi	sp,sp,-32
    80001fe8:	ec06                	sd	ra,24(sp)
    80001fea:	e822                	sd	s0,16(sp)
    80001fec:	e426                	sd	s1,8(sp)
    80001fee:	e04a                	sd	s2,0(sp)
    80001ff0:	1000                	addi	s0,sp,32
    80001ff2:	84aa                	mv	s1,a0
    80001ff4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ff6:	fffff097          	auipc	ra,0xfffff
    80001ffa:	fde080e7          	jalr	-34(ra) # 80000fd4 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001ffe:	693c                	ld	a5,80(a0)
    80002000:	02f4f863          	bgeu	s1,a5,80002030 <fetchaddr+0x4a>
    80002004:	00848713          	addi	a4,s1,8
    80002008:	02e7e663          	bltu	a5,a4,80002034 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000200c:	46a1                	li	a3,8
    8000200e:	8626                	mv	a2,s1
    80002010:	85ca                	mv	a1,s2
    80002012:	6d28                	ld	a0,88(a0)
    80002014:	fffff097          	auipc	ra,0xfffff
    80002018:	d0e080e7          	jalr	-754(ra) # 80000d22 <copyin>
    8000201c:	00a03533          	snez	a0,a0
    80002020:	40a00533          	neg	a0,a0
}
    80002024:	60e2                	ld	ra,24(sp)
    80002026:	6442                	ld	s0,16(sp)
    80002028:	64a2                	ld	s1,8(sp)
    8000202a:	6902                	ld	s2,0(sp)
    8000202c:	6105                	addi	sp,sp,32
    8000202e:	8082                	ret
    return -1;
    80002030:	557d                	li	a0,-1
    80002032:	bfcd                	j	80002024 <fetchaddr+0x3e>
    80002034:	557d                	li	a0,-1
    80002036:	b7fd                	j	80002024 <fetchaddr+0x3e>

0000000080002038 <fetchstr>:
{
    80002038:	7179                	addi	sp,sp,-48
    8000203a:	f406                	sd	ra,40(sp)
    8000203c:	f022                	sd	s0,32(sp)
    8000203e:	ec26                	sd	s1,24(sp)
    80002040:	e84a                	sd	s2,16(sp)
    80002042:	e44e                	sd	s3,8(sp)
    80002044:	1800                	addi	s0,sp,48
    80002046:	892a                	mv	s2,a0
    80002048:	84ae                	mv	s1,a1
    8000204a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000204c:	fffff097          	auipc	ra,0xfffff
    80002050:	f88080e7          	jalr	-120(ra) # 80000fd4 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002054:	86ce                	mv	a3,s3
    80002056:	864a                	mv	a2,s2
    80002058:	85a6                	mv	a1,s1
    8000205a:	6d28                	ld	a0,88(a0)
    8000205c:	fffff097          	auipc	ra,0xfffff
    80002060:	d52080e7          	jalr	-686(ra) # 80000dae <copyinstr>
  if(err < 0)
    80002064:	00054763          	bltz	a0,80002072 <fetchstr+0x3a>
  return strlen(buf);
    80002068:	8526                	mv	a0,s1
    8000206a:	ffffe097          	auipc	ra,0xffffe
    8000206e:	40e080e7          	jalr	1038(ra) # 80000478 <strlen>
}
    80002072:	70a2                	ld	ra,40(sp)
    80002074:	7402                	ld	s0,32(sp)
    80002076:	64e2                	ld	s1,24(sp)
    80002078:	6942                	ld	s2,16(sp)
    8000207a:	69a2                	ld	s3,8(sp)
    8000207c:	6145                	addi	sp,sp,48
    8000207e:	8082                	ret

0000000080002080 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002080:	1101                	addi	sp,sp,-32
    80002082:	ec06                	sd	ra,24(sp)
    80002084:	e822                	sd	s0,16(sp)
    80002086:	e426                	sd	s1,8(sp)
    80002088:	1000                	addi	s0,sp,32
    8000208a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000208c:	00000097          	auipc	ra,0x0
    80002090:	ef2080e7          	jalr	-270(ra) # 80001f7e <argraw>
    80002094:	c088                	sw	a0,0(s1)
  return 0;
}
    80002096:	4501                	li	a0,0
    80002098:	60e2                	ld	ra,24(sp)
    8000209a:	6442                	ld	s0,16(sp)
    8000209c:	64a2                	ld	s1,8(sp)
    8000209e:	6105                	addi	sp,sp,32
    800020a0:	8082                	ret

00000000800020a2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020a2:	1101                	addi	sp,sp,-32
    800020a4:	ec06                	sd	ra,24(sp)
    800020a6:	e822                	sd	s0,16(sp)
    800020a8:	e426                	sd	s1,8(sp)
    800020aa:	1000                	addi	s0,sp,32
    800020ac:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020ae:	00000097          	auipc	ra,0x0
    800020b2:	ed0080e7          	jalr	-304(ra) # 80001f7e <argraw>
    800020b6:	e088                	sd	a0,0(s1)
  return 0;
}
    800020b8:	4501                	li	a0,0
    800020ba:	60e2                	ld	ra,24(sp)
    800020bc:	6442                	ld	s0,16(sp)
    800020be:	64a2                	ld	s1,8(sp)
    800020c0:	6105                	addi	sp,sp,32
    800020c2:	8082                	ret

00000000800020c4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020c4:	1101                	addi	sp,sp,-32
    800020c6:	ec06                	sd	ra,24(sp)
    800020c8:	e822                	sd	s0,16(sp)
    800020ca:	e426                	sd	s1,8(sp)
    800020cc:	e04a                	sd	s2,0(sp)
    800020ce:	1000                	addi	s0,sp,32
    800020d0:	84ae                	mv	s1,a1
    800020d2:	8932                	mv	s2,a2
  *ip = argraw(n);
    800020d4:	00000097          	auipc	ra,0x0
    800020d8:	eaa080e7          	jalr	-342(ra) # 80001f7e <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800020dc:	864a                	mv	a2,s2
    800020de:	85a6                	mv	a1,s1
    800020e0:	00000097          	auipc	ra,0x0
    800020e4:	f58080e7          	jalr	-168(ra) # 80002038 <fetchstr>
}
    800020e8:	60e2                	ld	ra,24(sp)
    800020ea:	6442                	ld	s0,16(sp)
    800020ec:	64a2                	ld	s1,8(sp)
    800020ee:	6902                	ld	s2,0(sp)
    800020f0:	6105                	addi	sp,sp,32
    800020f2:	8082                	ret

00000000800020f4 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800020f4:	1101                	addi	sp,sp,-32
    800020f6:	ec06                	sd	ra,24(sp)
    800020f8:	e822                	sd	s0,16(sp)
    800020fa:	e426                	sd	s1,8(sp)
    800020fc:	e04a                	sd	s2,0(sp)
    800020fe:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002100:	fffff097          	auipc	ra,0xfffff
    80002104:	ed4080e7          	jalr	-300(ra) # 80000fd4 <myproc>
    80002108:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000210a:	06053903          	ld	s2,96(a0)
    8000210e:	0a893783          	ld	a5,168(s2)
    80002112:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002116:	37fd                	addiw	a5,a5,-1
    80002118:	4751                	li	a4,20
    8000211a:	00f76f63          	bltu	a4,a5,80002138 <syscall+0x44>
    8000211e:	00369713          	slli	a4,a3,0x3
    80002122:	00006797          	auipc	a5,0x6
    80002126:	2a678793          	addi	a5,a5,678 # 800083c8 <syscalls>
    8000212a:	97ba                	add	a5,a5,a4
    8000212c:	639c                	ld	a5,0(a5)
    8000212e:	c789                	beqz	a5,80002138 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002130:	9782                	jalr	a5
    80002132:	06a93823          	sd	a0,112(s2)
    80002136:	a839                	j	80002154 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002138:	16048613          	addi	a2,s1,352
    8000213c:	5c8c                	lw	a1,56(s1)
    8000213e:	00006517          	auipc	a0,0x6
    80002142:	25250513          	addi	a0,a0,594 # 80008390 <states.1725+0x150>
    80002146:	00004097          	auipc	ra,0x4
    8000214a:	040080e7          	jalr	64(ra) # 80006186 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000214e:	70bc                	ld	a5,96(s1)
    80002150:	577d                	li	a4,-1
    80002152:	fbb8                	sd	a4,112(a5)
  }
}
    80002154:	60e2                	ld	ra,24(sp)
    80002156:	6442                	ld	s0,16(sp)
    80002158:	64a2                	ld	s1,8(sp)
    8000215a:	6902                	ld	s2,0(sp)
    8000215c:	6105                	addi	sp,sp,32
    8000215e:	8082                	ret

0000000080002160 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002160:	1101                	addi	sp,sp,-32
    80002162:	ec06                	sd	ra,24(sp)
    80002164:	e822                	sd	s0,16(sp)
    80002166:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002168:	fec40593          	addi	a1,s0,-20
    8000216c:	4501                	li	a0,0
    8000216e:	00000097          	auipc	ra,0x0
    80002172:	f12080e7          	jalr	-238(ra) # 80002080 <argint>
    return -1;
    80002176:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002178:	00054963          	bltz	a0,8000218a <sys_exit+0x2a>
  exit(n);
    8000217c:	fec42503          	lw	a0,-20(s0)
    80002180:	fffff097          	auipc	ra,0xfffff
    80002184:	76c080e7          	jalr	1900(ra) # 800018ec <exit>
  return 0;  // not reached
    80002188:	4781                	li	a5,0
}
    8000218a:	853e                	mv	a0,a5
    8000218c:	60e2                	ld	ra,24(sp)
    8000218e:	6442                	ld	s0,16(sp)
    80002190:	6105                	addi	sp,sp,32
    80002192:	8082                	ret

0000000080002194 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002194:	1141                	addi	sp,sp,-16
    80002196:	e406                	sd	ra,8(sp)
    80002198:	e022                	sd	s0,0(sp)
    8000219a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000219c:	fffff097          	auipc	ra,0xfffff
    800021a0:	e38080e7          	jalr	-456(ra) # 80000fd4 <myproc>
}
    800021a4:	5d08                	lw	a0,56(a0)
    800021a6:	60a2                	ld	ra,8(sp)
    800021a8:	6402                	ld	s0,0(sp)
    800021aa:	0141                	addi	sp,sp,16
    800021ac:	8082                	ret

00000000800021ae <sys_fork>:

uint64
sys_fork(void)
{
    800021ae:	1141                	addi	sp,sp,-16
    800021b0:	e406                	sd	ra,8(sp)
    800021b2:	e022                	sd	s0,0(sp)
    800021b4:	0800                	addi	s0,sp,16
  return fork();
    800021b6:	fffff097          	auipc	ra,0xfffff
    800021ba:	1ec080e7          	jalr	492(ra) # 800013a2 <fork>
}
    800021be:	60a2                	ld	ra,8(sp)
    800021c0:	6402                	ld	s0,0(sp)
    800021c2:	0141                	addi	sp,sp,16
    800021c4:	8082                	ret

00000000800021c6 <sys_wait>:

uint64
sys_wait(void)
{
    800021c6:	1101                	addi	sp,sp,-32
    800021c8:	ec06                	sd	ra,24(sp)
    800021ca:	e822                	sd	s0,16(sp)
    800021cc:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800021ce:	fe840593          	addi	a1,s0,-24
    800021d2:	4501                	li	a0,0
    800021d4:	00000097          	auipc	ra,0x0
    800021d8:	ece080e7          	jalr	-306(ra) # 800020a2 <argaddr>
    800021dc:	87aa                	mv	a5,a0
    return -1;
    800021de:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800021e0:	0007c863          	bltz	a5,800021f0 <sys_wait+0x2a>
  return wait(p);
    800021e4:	fe843503          	ld	a0,-24(s0)
    800021e8:	fffff097          	auipc	ra,0xfffff
    800021ec:	50c080e7          	jalr	1292(ra) # 800016f4 <wait>
}
    800021f0:	60e2                	ld	ra,24(sp)
    800021f2:	6442                	ld	s0,16(sp)
    800021f4:	6105                	addi	sp,sp,32
    800021f6:	8082                	ret

00000000800021f8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021f8:	7179                	addi	sp,sp,-48
    800021fa:	f406                	sd	ra,40(sp)
    800021fc:	f022                	sd	s0,32(sp)
    800021fe:	ec26                	sd	s1,24(sp)
    80002200:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002202:	fdc40593          	addi	a1,s0,-36
    80002206:	4501                	li	a0,0
    80002208:	00000097          	auipc	ra,0x0
    8000220c:	e78080e7          	jalr	-392(ra) # 80002080 <argint>
    80002210:	87aa                	mv	a5,a0
    return -1;
    80002212:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002214:	0207c063          	bltz	a5,80002234 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002218:	fffff097          	auipc	ra,0xfffff
    8000221c:	dbc080e7          	jalr	-580(ra) # 80000fd4 <myproc>
    80002220:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    80002222:	fdc42503          	lw	a0,-36(s0)
    80002226:	fffff097          	auipc	ra,0xfffff
    8000222a:	108080e7          	jalr	264(ra) # 8000132e <growproc>
    8000222e:	00054863          	bltz	a0,8000223e <sys_sbrk+0x46>
    return -1;
  return addr;
    80002232:	8526                	mv	a0,s1
}
    80002234:	70a2                	ld	ra,40(sp)
    80002236:	7402                	ld	s0,32(sp)
    80002238:	64e2                	ld	s1,24(sp)
    8000223a:	6145                	addi	sp,sp,48
    8000223c:	8082                	ret
    return -1;
    8000223e:	557d                	li	a0,-1
    80002240:	bfd5                	j	80002234 <sys_sbrk+0x3c>

0000000080002242 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002242:	7139                	addi	sp,sp,-64
    80002244:	fc06                	sd	ra,56(sp)
    80002246:	f822                	sd	s0,48(sp)
    80002248:	f426                	sd	s1,40(sp)
    8000224a:	f04a                	sd	s2,32(sp)
    8000224c:	ec4e                	sd	s3,24(sp)
    8000224e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002250:	fcc40593          	addi	a1,s0,-52
    80002254:	4501                	li	a0,0
    80002256:	00000097          	auipc	ra,0x0
    8000225a:	e2a080e7          	jalr	-470(ra) # 80002080 <argint>
    return -1;
    8000225e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002260:	06054563          	bltz	a0,800022ca <sys_sleep+0x88>
  acquire(&tickslock);
    80002264:	0000d517          	auipc	a0,0xd
    80002268:	f4c50513          	addi	a0,a0,-180 # 8000f1b0 <tickslock>
    8000226c:	00004097          	auipc	ra,0x4
    80002270:	404080e7          	jalr	1028(ra) # 80006670 <acquire>
  ticks0 = ticks;
    80002274:	00007917          	auipc	s2,0x7
    80002278:	da492903          	lw	s2,-604(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000227c:	fcc42783          	lw	a5,-52(s0)
    80002280:	cf85                	beqz	a5,800022b8 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002282:	0000d997          	auipc	s3,0xd
    80002286:	f2e98993          	addi	s3,s3,-210 # 8000f1b0 <tickslock>
    8000228a:	00007497          	auipc	s1,0x7
    8000228e:	d8e48493          	addi	s1,s1,-626 # 80009018 <ticks>
    if(myproc()->killed){
    80002292:	fffff097          	auipc	ra,0xfffff
    80002296:	d42080e7          	jalr	-702(ra) # 80000fd4 <myproc>
    8000229a:	591c                	lw	a5,48(a0)
    8000229c:	ef9d                	bnez	a5,800022da <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000229e:	85ce                	mv	a1,s3
    800022a0:	8526                	mv	a0,s1
    800022a2:	fffff097          	auipc	ra,0xfffff
    800022a6:	3ee080e7          	jalr	1006(ra) # 80001690 <sleep>
  while(ticks - ticks0 < n){
    800022aa:	409c                	lw	a5,0(s1)
    800022ac:	412787bb          	subw	a5,a5,s2
    800022b0:	fcc42703          	lw	a4,-52(s0)
    800022b4:	fce7efe3          	bltu	a5,a4,80002292 <sys_sleep+0x50>
  }
  release(&tickslock);
    800022b8:	0000d517          	auipc	a0,0xd
    800022bc:	ef850513          	addi	a0,a0,-264 # 8000f1b0 <tickslock>
    800022c0:	00004097          	auipc	ra,0x4
    800022c4:	480080e7          	jalr	1152(ra) # 80006740 <release>
  return 0;
    800022c8:	4781                	li	a5,0
}
    800022ca:	853e                	mv	a0,a5
    800022cc:	70e2                	ld	ra,56(sp)
    800022ce:	7442                	ld	s0,48(sp)
    800022d0:	74a2                	ld	s1,40(sp)
    800022d2:	7902                	ld	s2,32(sp)
    800022d4:	69e2                	ld	s3,24(sp)
    800022d6:	6121                	addi	sp,sp,64
    800022d8:	8082                	ret
      release(&tickslock);
    800022da:	0000d517          	auipc	a0,0xd
    800022de:	ed650513          	addi	a0,a0,-298 # 8000f1b0 <tickslock>
    800022e2:	00004097          	auipc	ra,0x4
    800022e6:	45e080e7          	jalr	1118(ra) # 80006740 <release>
      return -1;
    800022ea:	57fd                	li	a5,-1
    800022ec:	bff9                	j	800022ca <sys_sleep+0x88>

00000000800022ee <sys_kill>:

uint64
sys_kill(void)
{
    800022ee:	1101                	addi	sp,sp,-32
    800022f0:	ec06                	sd	ra,24(sp)
    800022f2:	e822                	sd	s0,16(sp)
    800022f4:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800022f6:	fec40593          	addi	a1,s0,-20
    800022fa:	4501                	li	a0,0
    800022fc:	00000097          	auipc	ra,0x0
    80002300:	d84080e7          	jalr	-636(ra) # 80002080 <argint>
    80002304:	87aa                	mv	a5,a0
    return -1;
    80002306:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002308:	0007c863          	bltz	a5,80002318 <sys_kill+0x2a>
  return kill(pid);
    8000230c:	fec42503          	lw	a0,-20(s0)
    80002310:	fffff097          	auipc	ra,0xfffff
    80002314:	6b2080e7          	jalr	1714(ra) # 800019c2 <kill>
}
    80002318:	60e2                	ld	ra,24(sp)
    8000231a:	6442                	ld	s0,16(sp)
    8000231c:	6105                	addi	sp,sp,32
    8000231e:	8082                	ret

0000000080002320 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002320:	1101                	addi	sp,sp,-32
    80002322:	ec06                	sd	ra,24(sp)
    80002324:	e822                	sd	s0,16(sp)
    80002326:	e426                	sd	s1,8(sp)
    80002328:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000232a:	0000d517          	auipc	a0,0xd
    8000232e:	e8650513          	addi	a0,a0,-378 # 8000f1b0 <tickslock>
    80002332:	00004097          	auipc	ra,0x4
    80002336:	33e080e7          	jalr	830(ra) # 80006670 <acquire>
  xticks = ticks;
    8000233a:	00007497          	auipc	s1,0x7
    8000233e:	cde4a483          	lw	s1,-802(s1) # 80009018 <ticks>
  release(&tickslock);
    80002342:	0000d517          	auipc	a0,0xd
    80002346:	e6e50513          	addi	a0,a0,-402 # 8000f1b0 <tickslock>
    8000234a:	00004097          	auipc	ra,0x4
    8000234e:	3f6080e7          	jalr	1014(ra) # 80006740 <release>
  return xticks;
}
    80002352:	02049513          	slli	a0,s1,0x20
    80002356:	9101                	srli	a0,a0,0x20
    80002358:	60e2                	ld	ra,24(sp)
    8000235a:	6442                	ld	s0,16(sp)
    8000235c:	64a2                	ld	s1,8(sp)
    8000235e:	6105                	addi	sp,sp,32
    80002360:	8082                	ret

0000000080002362 <binit>:
        }
    }
}
void
binit(void)
{
    80002362:	7179                	addi	sp,sp,-48
    80002364:	f406                	sd	ra,40(sp)
    80002366:	f022                	sd	s0,32(sp)
    80002368:	ec26                	sd	s1,24(sp)
    8000236a:	e84a                	sd	s2,16(sp)
    8000236c:	e44e                	sd	s3,8(sp)
    8000236e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002370:	00006597          	auipc	a1,0x6
    80002374:	10858593          	addi	a1,a1,264 # 80008478 <syscalls+0xb0>
    80002378:	0000d517          	auipc	a0,0xd
    8000237c:	e5850513          	addi	a0,a0,-424 # 8000f1d0 <bcache>
    80002380:	00004097          	auipc	ra,0x4
    80002384:	46c080e7          	jalr	1132(ra) # 800067ec <initlock>
  // Create linked list of buffers
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002388:	0000d497          	auipc	s1,0xd
    8000238c:	e7848493          	addi	s1,s1,-392 # 8000f200 <bcache+0x30>
    80002390:	00015997          	auipc	s3,0x15
    80002394:	0c098993          	addi	s3,s3,192 # 80017450 <bcache+0x8280>
    initsleeplock(&b->lock, "buffer");
    80002398:	00006917          	auipc	s2,0x6
    8000239c:	0e890913          	addi	s2,s2,232 # 80008480 <syscalls+0xb8>
    800023a0:	85ca                	mv	a1,s2
    800023a2:	8526                	mv	a0,s1
    800023a4:	00001097          	auipc	ra,0x1
    800023a8:	632080e7          	jalr	1586(ra) # 800039d6 <initsleeplock>
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023ac:	45848493          	addi	s1,s1,1112
    800023b0:	ff3498e3          	bne	s1,s3,800023a0 <binit+0x3e>
    800023b4:	00015497          	auipc	s1,0x15
    800023b8:	08c48493          	addi	s1,s1,140 # 80017440 <bcache+0x8270>
    800023bc:	0000d917          	auipc	s2,0xd
    800023c0:	e1490913          	addi	s2,s2,-492 # 8000f1d0 <bcache>
    800023c4:	67a1                	lui	a5,0x8
    800023c6:	49078793          	addi	a5,a5,1168 # 8490 <_entry-0x7fff7b70>
    800023ca:	993e                	add	s2,s2,a5
  }
  for(int i = 0; i < HASHSIZE; i++){
      initlock(&bcache.hashlock[i], "bcache_hash");
    800023cc:	00006997          	auipc	s3,0x6
    800023d0:	0bc98993          	addi	s3,s3,188 # 80008488 <syscalls+0xc0>
    800023d4:	85ce                	mv	a1,s3
    800023d6:	8526                	mv	a0,s1
    800023d8:	00004097          	auipc	ra,0x4
    800023dc:	414080e7          	jalr	1044(ra) # 800067ec <initlock>
  for(int i = 0; i < HASHSIZE; i++){
    800023e0:	02048493          	addi	s1,s1,32
    800023e4:	ff2498e3          	bne	s1,s2,800023d4 <binit+0x72>
  }
}
    800023e8:	70a2                	ld	ra,40(sp)
    800023ea:	7402                	ld	s0,32(sp)
    800023ec:	64e2                	ld	s1,24(sp)
    800023ee:	6942                	ld	s2,16(sp)
    800023f0:	69a2                	ld	s3,8(sp)
    800023f2:	6145                	addi	sp,sp,48
    800023f4:	8082                	ret

00000000800023f6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023f6:	7159                	addi	sp,sp,-112
    800023f8:	f486                	sd	ra,104(sp)
    800023fa:	f0a2                	sd	s0,96(sp)
    800023fc:	eca6                	sd	s1,88(sp)
    800023fe:	e8ca                	sd	s2,80(sp)
    80002400:	e4ce                	sd	s3,72(sp)
    80002402:	e0d2                	sd	s4,64(sp)
    80002404:	fc56                	sd	s5,56(sp)
    80002406:	f85a                	sd	s6,48(sp)
    80002408:	f45e                	sd	s7,40(sp)
    8000240a:	f062                	sd	s8,32(sp)
    8000240c:	ec66                	sd	s9,24(sp)
    8000240e:	e86a                	sd	s10,16(sp)
    80002410:	e46e                	sd	s11,8(sp)
    80002412:	1880                	addi	s0,sp,112
    80002414:	8baa                	mv	s7,a0
    80002416:	8c2e                	mv	s8,a1
    return (dev + blockno) % HASHSIZE;
    80002418:	00b509bb          	addw	s3,a0,a1
    8000241c:	47c5                	li	a5,17
    8000241e:	02f9f9bb          	remuw	s3,s3,a5
    acquire(&bcache.hashlock[idx]);
    80002422:	00599a13          	slli	s4,s3,0x5
    80002426:	67a1                	lui	a5,0x8
    80002428:	27078793          	addi	a5,a5,624 # 8270 <_entry-0x7fff7d90>
    8000242c:	9a3e                	add	s4,s4,a5
    8000242e:	0000d497          	auipc	s1,0xd
    80002432:	da248493          	addi	s1,s1,-606 # 8000f1d0 <bcache>
    80002436:	9a26                	add	s4,s4,s1
    80002438:	8552                	mv	a0,s4
    8000243a:	00004097          	auipc	ra,0x4
    8000243e:	236080e7          	jalr	566(ra) # 80006670 <acquire>
    for(b = bcache.buckets[idx].next; b != 0; b = b->next){
    80002442:	45800793          	li	a5,1112
    80002446:	02f987b3          	mul	a5,s3,a5
    8000244a:	94be                	add	s1,s1,a5
    8000244c:	67a5                	lui	a5,0x9
    8000244e:	94be                	add	s1,s1,a5
    80002450:	8e04b903          	ld	s2,-1824(s1)
    80002454:	02091463          	bnez	s2,8000247c <bread+0x86>
    80002458:	0000da97          	auipc	s5,0xd
    8000245c:	da0a8a93          	addi	s5,s5,-608 # 8000f1f8 <bcache+0x28>
{
    80002460:	4b01                	li	s6,0
    return (dev + blockno) % HASHSIZE;
    80002462:	4dc5                	li	s11,17
            acquire(&bcache.hashlock[bucket]);
    80002464:	6ca1                	lui	s9,0x8
    80002466:	270c8c93          	addi	s9,s9,624 # 8270 <_entry-0x7fff7d90>
    8000246a:	0000dd17          	auipc	s10,0xd
    8000246e:	d66d0d13          	addi	s10,s10,-666 # 8000f1d0 <bcache>
    80002472:	a0ad                	j	800024dc <bread+0xe6>
    for(b = bcache.buckets[idx].next; b != 0; b = b->next){
    80002474:	45093903          	ld	s2,1104(s2)
    80002478:	fe0900e3          	beqz	s2,80002458 <bread+0x62>
        if(b->dev == dev && b->blockno == blockno){
    8000247c:	00892783          	lw	a5,8(s2)
    80002480:	ff779ae3          	bne	a5,s7,80002474 <bread+0x7e>
    80002484:	00c92783          	lw	a5,12(s2)
    80002488:	ff8796e3          	bne	a5,s8,80002474 <bread+0x7e>
        b->refcnt++;
    8000248c:	04892783          	lw	a5,72(s2)
    80002490:	2785                	addiw	a5,a5,1
    80002492:	04f92423          	sw	a5,72(s2)
        release(&bcache.hashlock[idx]);
    80002496:	8552                	mv	a0,s4
    80002498:	00004097          	auipc	ra,0x4
    8000249c:	2a8080e7          	jalr	680(ra) # 80006740 <release>
        acquiresleep(&b->lock);
    800024a0:	01090513          	addi	a0,s2,16
    800024a4:	00001097          	auipc	ra,0x1
    800024a8:	56c080e7          	jalr	1388(ra) # 80003a10 <acquiresleep>
        return b;
    800024ac:	a209                	j	800025ae <bread+0x1b8>
            acquire(&bcache.hashlock[bucket]);
    800024ae:	00549913          	slli	s2,s1,0x5
    800024b2:	9966                	add	s2,s2,s9
    800024b4:	996a                	add	s2,s2,s10
    800024b6:	854a                	mv	a0,s2
    800024b8:	00004097          	auipc	ra,0x4
    800024bc:	1b8080e7          	jalr	440(ra) # 80006670 <acquire>
        if(b->refcnt == 0) {
    800024c0:	040aa783          	lw	a5,64(s5)
    800024c4:	cb85                	beqz	a5,800024f4 <bread+0xfe>
            release(&bcache.hashlock[bucket]);
    800024c6:	854a                	mv	a0,s2
    800024c8:	00004097          	auipc	ra,0x4
    800024cc:	278080e7          	jalr	632(ra) # 80006740 <release>
    for(int i = 0; i < NBUF; i++){
    800024d0:	2b05                	addiw	s6,s6,1
    800024d2:	458a8a93          	addi	s5,s5,1112
    800024d6:	47f9                	li	a5,30
    800024d8:	10fb0d63          	beq	s6,a5,800025f2 <bread+0x1fc>
    return (dev + blockno) % HASHSIZE;
    800024dc:	000aa483          	lw	s1,0(s5)
    800024e0:	004aa503          	lw	a0,4(s5)
    800024e4:	9ca9                	addw	s1,s1,a0
    800024e6:	03b4f4bb          	remuw	s1,s1,s11
        if(bucket != idx){
    800024ea:	fc9992e3          	bne	s3,s1,800024ae <bread+0xb8>
        if(b->refcnt == 0) {
    800024ee:	040aa783          	lw	a5,64(s5)
    800024f2:	fff9                	bnez	a5,800024d0 <bread+0xda>
            erase(b->dev,b->blockno);
    800024f4:	0000d697          	auipc	a3,0xd
    800024f8:	cdc68693          	addi	a3,a3,-804 # 8000f1d0 <bcache>
    800024fc:	45800513          	li	a0,1112
    80002500:	02ab0733          	mul	a4,s6,a0
    80002504:	9736                	add	a4,a4,a3
    80002506:	570c                	lw	a1,40(a4)
    80002508:	5750                	lw	a2,44(a4)
    return (dev + blockno) % HASHSIZE;
    8000250a:	00c587bb          	addw	a5,a1,a2
    8000250e:	4745                	li	a4,17
    80002510:	02e7f7bb          	remuw	a5,a5,a4
    for(b = &bcache.buckets[idx]; b->next != 0; b = b->next){
    80002514:	02a787b3          	mul	a5,a5,a0
    80002518:	6721                	lui	a4,0x8
    8000251a:	49070713          	addi	a4,a4,1168 # 8490 <_entry-0x7fff7b70>
    8000251e:	973e                	add	a4,a4,a5
    80002520:	9736                	add	a4,a4,a3
    80002522:	97b6                	add	a5,a5,a3
    80002524:	66a5                	lui	a3,0x9
    80002526:	97b6                	add	a5,a5,a3
    80002528:	8e07b783          	ld	a5,-1824(a5) # 88e0 <_entry-0x7fff7720>
    8000252c:	e799                	bnez	a5,8000253a <bread+0x144>
    8000252e:	a005                	j	8000254e <bread+0x158>
    80002530:	4507b683          	ld	a3,1104(a5)
    80002534:	873e                	mv	a4,a5
    80002536:	ce81                	beqz	a3,8000254e <bread+0x158>
    80002538:	87b6                	mv	a5,a3
        if(b->next->dev == dev && b->next->blockno == blockno){
    8000253a:	4794                	lw	a3,8(a5)
    8000253c:	feb69ae3          	bne	a3,a1,80002530 <bread+0x13a>
    80002540:	47d4                	lw	a3,12(a5)
    80002542:	fec697e3          	bne	a3,a2,80002530 <bread+0x13a>
            b->next = b->next->next;
    80002546:	4507b783          	ld	a5,1104(a5)
    8000254a:	44f73823          	sd	a5,1104(a4)
            return;
    8000254e:	45800693          	li	a3,1112
    80002552:	02db0b33          	mul	s6,s6,a3
        b = &bcache.buf[i];
    80002556:	020b0913          	addi	s2,s6,32
    8000255a:	0000d717          	auipc	a4,0xd
    8000255e:	c7670713          	addi	a4,a4,-906 # 8000f1d0 <bcache>
    80002562:	993a                	add	s2,s2,a4
            b->dev = dev;
    80002564:	016707b3          	add	a5,a4,s6
    80002568:	0377a423          	sw	s7,40(a5)
            b->blockno = blockno;
    8000256c:	0387a623          	sw	s8,44(a5)
            b->valid = 0;
    80002570:	0207a023          	sw	zero,32(a5)
            b->refcnt = 1;
    80002574:	4605                	li	a2,1
    80002576:	d7b0                	sw	a2,104(a5)
    buf->next = bcache.buckets[idx].next;
    80002578:	02d986b3          	mul	a3,s3,a3
    8000257c:	9736                	add	a4,a4,a3
    8000257e:	66a5                	lui	a3,0x9
    80002580:	9736                	add	a4,a4,a3
    80002582:	8e073683          	ld	a3,-1824(a4)
    80002586:	46d7b823          	sd	a3,1136(a5)
    bcache.buckets[idx].next = buf;
    8000258a:	8f273023          	sd	s2,-1824(a4)
            if(bucket != idx)
    8000258e:	04999363          	bne	s3,s1,800025d4 <bread+0x1de>
            release(&bcache.hashlock[idx]);
    80002592:	8552                	mv	a0,s4
    80002594:	00004097          	auipc	ra,0x4
    80002598:	1ac080e7          	jalr	428(ra) # 80006740 <release>
            acquiresleep(&b->lock);
    8000259c:	0000d517          	auipc	a0,0xd
    800025a0:	c6450513          	addi	a0,a0,-924 # 8000f200 <bcache+0x30>
    800025a4:	955a                	add	a0,a0,s6
    800025a6:	00001097          	auipc	ra,0x1
    800025aa:	46a080e7          	jalr	1130(ra) # 80003a10 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025ae:	00092783          	lw	a5,0(s2)
    800025b2:	cba1                	beqz	a5,80002602 <bread+0x20c>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025b4:	854a                	mv	a0,s2
    800025b6:	70a6                	ld	ra,104(sp)
    800025b8:	7406                	ld	s0,96(sp)
    800025ba:	64e6                	ld	s1,88(sp)
    800025bc:	6946                	ld	s2,80(sp)
    800025be:	69a6                	ld	s3,72(sp)
    800025c0:	6a06                	ld	s4,64(sp)
    800025c2:	7ae2                	ld	s5,56(sp)
    800025c4:	7b42                	ld	s6,48(sp)
    800025c6:	7ba2                	ld	s7,40(sp)
    800025c8:	7c02                	ld	s8,32(sp)
    800025ca:	6ce2                	ld	s9,24(sp)
    800025cc:	6d42                	ld	s10,16(sp)
    800025ce:	6da2                	ld	s11,8(sp)
    800025d0:	6165                	addi	sp,sp,112
    800025d2:	8082                	ret
                release(&bcache.hashlock[bucket]);
    800025d4:	0496                	slli	s1,s1,0x5
    800025d6:	6521                	lui	a0,0x8
    800025d8:	27050513          	addi	a0,a0,624 # 8270 <_entry-0x7fff7d90>
    800025dc:	94aa                	add	s1,s1,a0
    800025de:	0000d517          	auipc	a0,0xd
    800025e2:	bf250513          	addi	a0,a0,-1038 # 8000f1d0 <bcache>
    800025e6:	9526                	add	a0,a0,s1
    800025e8:	00004097          	auipc	ra,0x4
    800025ec:	158080e7          	jalr	344(ra) # 80006740 <release>
    800025f0:	b74d                	j	80002592 <bread+0x19c>
    panic("bget: no buffers");
    800025f2:	00006517          	auipc	a0,0x6
    800025f6:	ea650513          	addi	a0,a0,-346 # 80008498 <syscalls+0xd0>
    800025fa:	00004097          	auipc	ra,0x4
    800025fe:	b42080e7          	jalr	-1214(ra) # 8000613c <panic>
    virtio_disk_rw(b, 0);
    80002602:	4581                	li	a1,0
    80002604:	854a                	mv	a0,s2
    80002606:	00003097          	auipc	ra,0x3
    8000260a:	f40080e7          	jalr	-192(ra) # 80005546 <virtio_disk_rw>
    b->valid = 1;
    8000260e:	4785                	li	a5,1
    80002610:	00f92023          	sw	a5,0(s2)
  return b;
    80002614:	b745                	j	800025b4 <bread+0x1be>

0000000080002616 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002616:	1101                	addi	sp,sp,-32
    80002618:	ec06                	sd	ra,24(sp)
    8000261a:	e822                	sd	s0,16(sp)
    8000261c:	e426                	sd	s1,8(sp)
    8000261e:	1000                	addi	s0,sp,32
    80002620:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002622:	0541                	addi	a0,a0,16
    80002624:	00001097          	auipc	ra,0x1
    80002628:	486080e7          	jalr	1158(ra) # 80003aaa <holdingsleep>
    8000262c:	cd01                	beqz	a0,80002644 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000262e:	4585                	li	a1,1
    80002630:	8526                	mv	a0,s1
    80002632:	00003097          	auipc	ra,0x3
    80002636:	f14080e7          	jalr	-236(ra) # 80005546 <virtio_disk_rw>
}
    8000263a:	60e2                	ld	ra,24(sp)
    8000263c:	6442                	ld	s0,16(sp)
    8000263e:	64a2                	ld	s1,8(sp)
    80002640:	6105                	addi	sp,sp,32
    80002642:	8082                	ret
    panic("bwrite");
    80002644:	00006517          	auipc	a0,0x6
    80002648:	e6c50513          	addi	a0,a0,-404 # 800084b0 <syscalls+0xe8>
    8000264c:	00004097          	auipc	ra,0x4
    80002650:	af0080e7          	jalr	-1296(ra) # 8000613c <panic>

0000000080002654 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002654:	1101                	addi	sp,sp,-32
    80002656:	ec06                	sd	ra,24(sp)
    80002658:	e822                	sd	s0,16(sp)
    8000265a:	e426                	sd	s1,8(sp)
    8000265c:	e04a                	sd	s2,0(sp)
    8000265e:	1000                	addi	s0,sp,32
    80002660:	892a                	mv	s2,a0
  if(!holdingsleep(&b->lock))
    80002662:	01050493          	addi	s1,a0,16
    80002666:	8526                	mv	a0,s1
    80002668:	00001097          	auipc	ra,0x1
    8000266c:	442080e7          	jalr	1090(ra) # 80003aaa <holdingsleep>
    80002670:	cd29                	beqz	a0,800026ca <brelse+0x76>
    panic("brelse");

  releasesleep(&b->lock);
    80002672:	8526                	mv	a0,s1
    80002674:	00001097          	auipc	ra,0x1
    80002678:	3f2080e7          	jalr	1010(ra) # 80003a66 <releasesleep>
    return (dev + blockno) % HASHSIZE;
    8000267c:	00892483          	lw	s1,8(s2)
    80002680:	00c92783          	lw	a5,12(s2)
    80002684:	9cbd                	addw	s1,s1,a5
  int idx = hash(b->dev,b->blockno);
  acquire(&bcache.hashlock[idx]);
    80002686:	47c5                	li	a5,17
    80002688:	02f4f4bb          	remuw	s1,s1,a5
    8000268c:	0496                	slli	s1,s1,0x5
    8000268e:	67a1                	lui	a5,0x8
    80002690:	27078793          	addi	a5,a5,624 # 8270 <_entry-0x7fff7d90>
    80002694:	94be                	add	s1,s1,a5
    80002696:	0000d797          	auipc	a5,0xd
    8000269a:	b3a78793          	addi	a5,a5,-1222 # 8000f1d0 <bcache>
    8000269e:	94be                	add	s1,s1,a5
    800026a0:	8526                	mv	a0,s1
    800026a2:	00004097          	auipc	ra,0x4
    800026a6:	fce080e7          	jalr	-50(ra) # 80006670 <acquire>
  b->refcnt--;
    800026aa:	04892783          	lw	a5,72(s2)
    800026ae:	37fd                	addiw	a5,a5,-1
    800026b0:	04f92423          	sw	a5,72(s2)
  release(&bcache.hashlock[idx]);
    800026b4:	8526                	mv	a0,s1
    800026b6:	00004097          	auipc	ra,0x4
    800026ba:	08a080e7          	jalr	138(ra) # 80006740 <release>
}
    800026be:	60e2                	ld	ra,24(sp)
    800026c0:	6442                	ld	s0,16(sp)
    800026c2:	64a2                	ld	s1,8(sp)
    800026c4:	6902                	ld	s2,0(sp)
    800026c6:	6105                	addi	sp,sp,32
    800026c8:	8082                	ret
    panic("brelse");
    800026ca:	00006517          	auipc	a0,0x6
    800026ce:	dee50513          	addi	a0,a0,-530 # 800084b8 <syscalls+0xf0>
    800026d2:	00004097          	auipc	ra,0x4
    800026d6:	a6a080e7          	jalr	-1430(ra) # 8000613c <panic>

00000000800026da <bpin>:

void
bpin(struct buf *b) {
    800026da:	1101                	addi	sp,sp,-32
    800026dc:	ec06                	sd	ra,24(sp)
    800026de:	e822                	sd	s0,16(sp)
    800026e0:	e426                	sd	s1,8(sp)
    800026e2:	e04a                	sd	s2,0(sp)
    800026e4:	1000                	addi	s0,sp,32
    800026e6:	892a                	mv	s2,a0
    return (dev + blockno) % HASHSIZE;
    800026e8:	4504                	lw	s1,8(a0)
    800026ea:	455c                	lw	a5,12(a0)
    800026ec:	9cbd                	addw	s1,s1,a5
  int idx = hash(b->dev,b->blockno);
  acquire(&bcache.hashlock[idx]);
    800026ee:	47c5                	li	a5,17
    800026f0:	02f4f4bb          	remuw	s1,s1,a5
    800026f4:	0496                	slli	s1,s1,0x5
    800026f6:	67a1                	lui	a5,0x8
    800026f8:	27078793          	addi	a5,a5,624 # 8270 <_entry-0x7fff7d90>
    800026fc:	94be                	add	s1,s1,a5
    800026fe:	0000d797          	auipc	a5,0xd
    80002702:	ad278793          	addi	a5,a5,-1326 # 8000f1d0 <bcache>
    80002706:	94be                	add	s1,s1,a5
    80002708:	8526                	mv	a0,s1
    8000270a:	00004097          	auipc	ra,0x4
    8000270e:	f66080e7          	jalr	-154(ra) # 80006670 <acquire>
  b->refcnt++;
    80002712:	04892783          	lw	a5,72(s2)
    80002716:	2785                	addiw	a5,a5,1
    80002718:	04f92423          	sw	a5,72(s2)
  release(&bcache.hashlock[idx]);
    8000271c:	8526                	mv	a0,s1
    8000271e:	00004097          	auipc	ra,0x4
    80002722:	022080e7          	jalr	34(ra) # 80006740 <release>
}
    80002726:	60e2                	ld	ra,24(sp)
    80002728:	6442                	ld	s0,16(sp)
    8000272a:	64a2                	ld	s1,8(sp)
    8000272c:	6902                	ld	s2,0(sp)
    8000272e:	6105                	addi	sp,sp,32
    80002730:	8082                	ret

0000000080002732 <bunpin>:

void
bunpin(struct buf *b) {
    80002732:	1101                	addi	sp,sp,-32
    80002734:	ec06                	sd	ra,24(sp)
    80002736:	e822                	sd	s0,16(sp)
    80002738:	e426                	sd	s1,8(sp)
    8000273a:	e04a                	sd	s2,0(sp)
    8000273c:	1000                	addi	s0,sp,32
    8000273e:	892a                	mv	s2,a0
    return (dev + blockno) % HASHSIZE;
    80002740:	4504                	lw	s1,8(a0)
    80002742:	455c                	lw	a5,12(a0)
    80002744:	9cbd                	addw	s1,s1,a5
  int idx = hash(b->dev,b->blockno);
  acquire(&bcache.hashlock[idx]);
    80002746:	47c5                	li	a5,17
    80002748:	02f4f4bb          	remuw	s1,s1,a5
    8000274c:	0496                	slli	s1,s1,0x5
    8000274e:	67a1                	lui	a5,0x8
    80002750:	27078793          	addi	a5,a5,624 # 8270 <_entry-0x7fff7d90>
    80002754:	94be                	add	s1,s1,a5
    80002756:	0000d797          	auipc	a5,0xd
    8000275a:	a7a78793          	addi	a5,a5,-1414 # 8000f1d0 <bcache>
    8000275e:	94be                	add	s1,s1,a5
    80002760:	8526                	mv	a0,s1
    80002762:	00004097          	auipc	ra,0x4
    80002766:	f0e080e7          	jalr	-242(ra) # 80006670 <acquire>
  b->refcnt--;
    8000276a:	04892783          	lw	a5,72(s2)
    8000276e:	37fd                	addiw	a5,a5,-1
    80002770:	04f92423          	sw	a5,72(s2)
  release(&bcache.hashlock[idx]);
    80002774:	8526                	mv	a0,s1
    80002776:	00004097          	auipc	ra,0x4
    8000277a:	fca080e7          	jalr	-54(ra) # 80006740 <release>
}
    8000277e:	60e2                	ld	ra,24(sp)
    80002780:	6442                	ld	s0,16(sp)
    80002782:	64a2                	ld	s1,8(sp)
    80002784:	6902                	ld	s2,0(sp)
    80002786:	6105                	addi	sp,sp,32
    80002788:	8082                	ret

000000008000278a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000278a:	1101                	addi	sp,sp,-32
    8000278c:	ec06                	sd	ra,24(sp)
    8000278e:	e822                	sd	s0,16(sp)
    80002790:	e426                	sd	s1,8(sp)
    80002792:	e04a                	sd	s2,0(sp)
    80002794:	1000                	addi	s0,sp,32
    80002796:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002798:	00d5d59b          	srliw	a1,a1,0xd
    8000279c:	0001a797          	auipc	a5,0x1a
    800027a0:	8b87a783          	lw	a5,-1864(a5) # 8001c054 <sb+0x1c>
    800027a4:	9dbd                	addw	a1,a1,a5
    800027a6:	00000097          	auipc	ra,0x0
    800027aa:	c50080e7          	jalr	-944(ra) # 800023f6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027ae:	0074f713          	andi	a4,s1,7
    800027b2:	4785                	li	a5,1
    800027b4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027b8:	14ce                	slli	s1,s1,0x33
    800027ba:	90d9                	srli	s1,s1,0x36
    800027bc:	00950733          	add	a4,a0,s1
    800027c0:	05074703          	lbu	a4,80(a4)
    800027c4:	00e7f6b3          	and	a3,a5,a4
    800027c8:	c69d                	beqz	a3,800027f6 <bfree+0x6c>
    800027ca:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027cc:	94aa                	add	s1,s1,a0
    800027ce:	fff7c793          	not	a5,a5
    800027d2:	8ff9                	and	a5,a5,a4
    800027d4:	04f48823          	sb	a5,80(s1)
  log_write(bp);
    800027d8:	00001097          	auipc	ra,0x1
    800027dc:	118080e7          	jalr	280(ra) # 800038f0 <log_write>
  brelse(bp);
    800027e0:	854a                	mv	a0,s2
    800027e2:	00000097          	auipc	ra,0x0
    800027e6:	e72080e7          	jalr	-398(ra) # 80002654 <brelse>
}
    800027ea:	60e2                	ld	ra,24(sp)
    800027ec:	6442                	ld	s0,16(sp)
    800027ee:	64a2                	ld	s1,8(sp)
    800027f0:	6902                	ld	s2,0(sp)
    800027f2:	6105                	addi	sp,sp,32
    800027f4:	8082                	ret
    panic("freeing free block");
    800027f6:	00006517          	auipc	a0,0x6
    800027fa:	cca50513          	addi	a0,a0,-822 # 800084c0 <syscalls+0xf8>
    800027fe:	00004097          	auipc	ra,0x4
    80002802:	93e080e7          	jalr	-1730(ra) # 8000613c <panic>

0000000080002806 <balloc>:
{
    80002806:	711d                	addi	sp,sp,-96
    80002808:	ec86                	sd	ra,88(sp)
    8000280a:	e8a2                	sd	s0,80(sp)
    8000280c:	e4a6                	sd	s1,72(sp)
    8000280e:	e0ca                	sd	s2,64(sp)
    80002810:	fc4e                	sd	s3,56(sp)
    80002812:	f852                	sd	s4,48(sp)
    80002814:	f456                	sd	s5,40(sp)
    80002816:	f05a                	sd	s6,32(sp)
    80002818:	ec5e                	sd	s7,24(sp)
    8000281a:	e862                	sd	s8,16(sp)
    8000281c:	e466                	sd	s9,8(sp)
    8000281e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002820:	0001a797          	auipc	a5,0x1a
    80002824:	81c7a783          	lw	a5,-2020(a5) # 8001c03c <sb+0x4>
    80002828:	cbd1                	beqz	a5,800028bc <balloc+0xb6>
    8000282a:	8baa                	mv	s7,a0
    8000282c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000282e:	0001ab17          	auipc	s6,0x1a
    80002832:	80ab0b13          	addi	s6,s6,-2038 # 8001c038 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002836:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002838:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000283a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000283c:	6c89                	lui	s9,0x2
    8000283e:	a831                	j	8000285a <balloc+0x54>
    brelse(bp);
    80002840:	854a                	mv	a0,s2
    80002842:	00000097          	auipc	ra,0x0
    80002846:	e12080e7          	jalr	-494(ra) # 80002654 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000284a:	015c87bb          	addw	a5,s9,s5
    8000284e:	00078a9b          	sext.w	s5,a5
    80002852:	004b2703          	lw	a4,4(s6)
    80002856:	06eaf363          	bgeu	s5,a4,800028bc <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000285a:	41fad79b          	sraiw	a5,s5,0x1f
    8000285e:	0137d79b          	srliw	a5,a5,0x13
    80002862:	015787bb          	addw	a5,a5,s5
    80002866:	40d7d79b          	sraiw	a5,a5,0xd
    8000286a:	01cb2583          	lw	a1,28(s6)
    8000286e:	9dbd                	addw	a1,a1,a5
    80002870:	855e                	mv	a0,s7
    80002872:	00000097          	auipc	ra,0x0
    80002876:	b84080e7          	jalr	-1148(ra) # 800023f6 <bread>
    8000287a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000287c:	004b2503          	lw	a0,4(s6)
    80002880:	000a849b          	sext.w	s1,s5
    80002884:	8662                	mv	a2,s8
    80002886:	faa4fde3          	bgeu	s1,a0,80002840 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000288a:	41f6579b          	sraiw	a5,a2,0x1f
    8000288e:	01d7d69b          	srliw	a3,a5,0x1d
    80002892:	00c6873b          	addw	a4,a3,a2
    80002896:	00777793          	andi	a5,a4,7
    8000289a:	9f95                	subw	a5,a5,a3
    8000289c:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028a0:	4037571b          	sraiw	a4,a4,0x3
    800028a4:	00e906b3          	add	a3,s2,a4
    800028a8:	0506c683          	lbu	a3,80(a3) # 9050 <_entry-0x7fff6fb0>
    800028ac:	00d7f5b3          	and	a1,a5,a3
    800028b0:	cd91                	beqz	a1,800028cc <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028b2:	2605                	addiw	a2,a2,1
    800028b4:	2485                	addiw	s1,s1,1
    800028b6:	fd4618e3          	bne	a2,s4,80002886 <balloc+0x80>
    800028ba:	b759                	j	80002840 <balloc+0x3a>
  panic("balloc: out of blocks");
    800028bc:	00006517          	auipc	a0,0x6
    800028c0:	c1c50513          	addi	a0,a0,-996 # 800084d8 <syscalls+0x110>
    800028c4:	00004097          	auipc	ra,0x4
    800028c8:	878080e7          	jalr	-1928(ra) # 8000613c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028cc:	974a                	add	a4,a4,s2
    800028ce:	8fd5                	or	a5,a5,a3
    800028d0:	04f70823          	sb	a5,80(a4)
        log_write(bp);
    800028d4:	854a                	mv	a0,s2
    800028d6:	00001097          	auipc	ra,0x1
    800028da:	01a080e7          	jalr	26(ra) # 800038f0 <log_write>
        brelse(bp);
    800028de:	854a                	mv	a0,s2
    800028e0:	00000097          	auipc	ra,0x0
    800028e4:	d74080e7          	jalr	-652(ra) # 80002654 <brelse>
  bp = bread(dev, bno);
    800028e8:	85a6                	mv	a1,s1
    800028ea:	855e                	mv	a0,s7
    800028ec:	00000097          	auipc	ra,0x0
    800028f0:	b0a080e7          	jalr	-1270(ra) # 800023f6 <bread>
    800028f4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028f6:	40000613          	li	a2,1024
    800028fa:	4581                	li	a1,0
    800028fc:	05050513          	addi	a0,a0,80
    80002900:	ffffe097          	auipc	ra,0xffffe
    80002904:	9f4080e7          	jalr	-1548(ra) # 800002f4 <memset>
  log_write(bp);
    80002908:	854a                	mv	a0,s2
    8000290a:	00001097          	auipc	ra,0x1
    8000290e:	fe6080e7          	jalr	-26(ra) # 800038f0 <log_write>
  brelse(bp);
    80002912:	854a                	mv	a0,s2
    80002914:	00000097          	auipc	ra,0x0
    80002918:	d40080e7          	jalr	-704(ra) # 80002654 <brelse>
}
    8000291c:	8526                	mv	a0,s1
    8000291e:	60e6                	ld	ra,88(sp)
    80002920:	6446                	ld	s0,80(sp)
    80002922:	64a6                	ld	s1,72(sp)
    80002924:	6906                	ld	s2,64(sp)
    80002926:	79e2                	ld	s3,56(sp)
    80002928:	7a42                	ld	s4,48(sp)
    8000292a:	7aa2                	ld	s5,40(sp)
    8000292c:	7b02                	ld	s6,32(sp)
    8000292e:	6be2                	ld	s7,24(sp)
    80002930:	6c42                	ld	s8,16(sp)
    80002932:	6ca2                	ld	s9,8(sp)
    80002934:	6125                	addi	sp,sp,96
    80002936:	8082                	ret

0000000080002938 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002938:	7179                	addi	sp,sp,-48
    8000293a:	f406                	sd	ra,40(sp)
    8000293c:	f022                	sd	s0,32(sp)
    8000293e:	ec26                	sd	s1,24(sp)
    80002940:	e84a                	sd	s2,16(sp)
    80002942:	e44e                	sd	s3,8(sp)
    80002944:	e052                	sd	s4,0(sp)
    80002946:	1800                	addi	s0,sp,48
    80002948:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000294a:	47ad                	li	a5,11
    8000294c:	04b7fe63          	bgeu	a5,a1,800029a8 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002950:	ff45849b          	addiw	s1,a1,-12
    80002954:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002958:	0ff00793          	li	a5,255
    8000295c:	0ae7e363          	bltu	a5,a4,80002a02 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002960:	08852583          	lw	a1,136(a0)
    80002964:	c5ad                	beqz	a1,800029ce <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002966:	00092503          	lw	a0,0(s2)
    8000296a:	00000097          	auipc	ra,0x0
    8000296e:	a8c080e7          	jalr	-1396(ra) # 800023f6 <bread>
    80002972:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002974:	05050793          	addi	a5,a0,80
    if((addr = a[bn]) == 0){
    80002978:	02049593          	slli	a1,s1,0x20
    8000297c:	9181                	srli	a1,a1,0x20
    8000297e:	058a                	slli	a1,a1,0x2
    80002980:	00b784b3          	add	s1,a5,a1
    80002984:	0004a983          	lw	s3,0(s1)
    80002988:	04098d63          	beqz	s3,800029e2 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000298c:	8552                	mv	a0,s4
    8000298e:	00000097          	auipc	ra,0x0
    80002992:	cc6080e7          	jalr	-826(ra) # 80002654 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002996:	854e                	mv	a0,s3
    80002998:	70a2                	ld	ra,40(sp)
    8000299a:	7402                	ld	s0,32(sp)
    8000299c:	64e2                	ld	s1,24(sp)
    8000299e:	6942                	ld	s2,16(sp)
    800029a0:	69a2                	ld	s3,8(sp)
    800029a2:	6a02                	ld	s4,0(sp)
    800029a4:	6145                	addi	sp,sp,48
    800029a6:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800029a8:	02059493          	slli	s1,a1,0x20
    800029ac:	9081                	srli	s1,s1,0x20
    800029ae:	048a                	slli	s1,s1,0x2
    800029b0:	94aa                	add	s1,s1,a0
    800029b2:	0584a983          	lw	s3,88(s1)
    800029b6:	fe0990e3          	bnez	s3,80002996 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800029ba:	4108                	lw	a0,0(a0)
    800029bc:	00000097          	auipc	ra,0x0
    800029c0:	e4a080e7          	jalr	-438(ra) # 80002806 <balloc>
    800029c4:	0005099b          	sext.w	s3,a0
    800029c8:	0534ac23          	sw	s3,88(s1)
    800029cc:	b7e9                	j	80002996 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800029ce:	4108                	lw	a0,0(a0)
    800029d0:	00000097          	auipc	ra,0x0
    800029d4:	e36080e7          	jalr	-458(ra) # 80002806 <balloc>
    800029d8:	0005059b          	sext.w	a1,a0
    800029dc:	08b92423          	sw	a1,136(s2)
    800029e0:	b759                	j	80002966 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029e2:	00092503          	lw	a0,0(s2)
    800029e6:	00000097          	auipc	ra,0x0
    800029ea:	e20080e7          	jalr	-480(ra) # 80002806 <balloc>
    800029ee:	0005099b          	sext.w	s3,a0
    800029f2:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029f6:	8552                	mv	a0,s4
    800029f8:	00001097          	auipc	ra,0x1
    800029fc:	ef8080e7          	jalr	-264(ra) # 800038f0 <log_write>
    80002a00:	b771                	j	8000298c <bmap+0x54>
  panic("bmap: out of range");
    80002a02:	00006517          	auipc	a0,0x6
    80002a06:	aee50513          	addi	a0,a0,-1298 # 800084f0 <syscalls+0x128>
    80002a0a:	00003097          	auipc	ra,0x3
    80002a0e:	732080e7          	jalr	1842(ra) # 8000613c <panic>

0000000080002a12 <iget>:
{
    80002a12:	7179                	addi	sp,sp,-48
    80002a14:	f406                	sd	ra,40(sp)
    80002a16:	f022                	sd	s0,32(sp)
    80002a18:	ec26                	sd	s1,24(sp)
    80002a1a:	e84a                	sd	s2,16(sp)
    80002a1c:	e44e                	sd	s3,8(sp)
    80002a1e:	e052                	sd	s4,0(sp)
    80002a20:	1800                	addi	s0,sp,48
    80002a22:	89aa                	mv	s3,a0
    80002a24:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a26:	00019517          	auipc	a0,0x19
    80002a2a:	63250513          	addi	a0,a0,1586 # 8001c058 <itable>
    80002a2e:	00004097          	auipc	ra,0x4
    80002a32:	c42080e7          	jalr	-958(ra) # 80006670 <acquire>
  empty = 0;
    80002a36:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a38:	00019497          	auipc	s1,0x19
    80002a3c:	64048493          	addi	s1,s1,1600 # 8001c078 <itable+0x20>
    80002a40:	0001b697          	auipc	a3,0x1b
    80002a44:	25868693          	addi	a3,a3,600 # 8001dc98 <log>
    80002a48:	a039                	j	80002a56 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a4a:	02090b63          	beqz	s2,80002a80 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a4e:	09048493          	addi	s1,s1,144
    80002a52:	02d48a63          	beq	s1,a3,80002a86 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a56:	449c                	lw	a5,8(s1)
    80002a58:	fef059e3          	blez	a5,80002a4a <iget+0x38>
    80002a5c:	4098                	lw	a4,0(s1)
    80002a5e:	ff3716e3          	bne	a4,s3,80002a4a <iget+0x38>
    80002a62:	40d8                	lw	a4,4(s1)
    80002a64:	ff4713e3          	bne	a4,s4,80002a4a <iget+0x38>
      ip->ref++;
    80002a68:	2785                	addiw	a5,a5,1
    80002a6a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a6c:	00019517          	auipc	a0,0x19
    80002a70:	5ec50513          	addi	a0,a0,1516 # 8001c058 <itable>
    80002a74:	00004097          	auipc	ra,0x4
    80002a78:	ccc080e7          	jalr	-820(ra) # 80006740 <release>
      return ip;
    80002a7c:	8926                	mv	s2,s1
    80002a7e:	a03d                	j	80002aac <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a80:	f7f9                	bnez	a5,80002a4e <iget+0x3c>
    80002a82:	8926                	mv	s2,s1
    80002a84:	b7e9                	j	80002a4e <iget+0x3c>
  if(empty == 0)
    80002a86:	02090c63          	beqz	s2,80002abe <iget+0xac>
  ip->dev = dev;
    80002a8a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a8e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a92:	4785                	li	a5,1
    80002a94:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a98:	04092423          	sw	zero,72(s2)
  release(&itable.lock);
    80002a9c:	00019517          	auipc	a0,0x19
    80002aa0:	5bc50513          	addi	a0,a0,1468 # 8001c058 <itable>
    80002aa4:	00004097          	auipc	ra,0x4
    80002aa8:	c9c080e7          	jalr	-868(ra) # 80006740 <release>
}
    80002aac:	854a                	mv	a0,s2
    80002aae:	70a2                	ld	ra,40(sp)
    80002ab0:	7402                	ld	s0,32(sp)
    80002ab2:	64e2                	ld	s1,24(sp)
    80002ab4:	6942                	ld	s2,16(sp)
    80002ab6:	69a2                	ld	s3,8(sp)
    80002ab8:	6a02                	ld	s4,0(sp)
    80002aba:	6145                	addi	sp,sp,48
    80002abc:	8082                	ret
    panic("iget: no inodes");
    80002abe:	00006517          	auipc	a0,0x6
    80002ac2:	a4a50513          	addi	a0,a0,-1462 # 80008508 <syscalls+0x140>
    80002ac6:	00003097          	auipc	ra,0x3
    80002aca:	676080e7          	jalr	1654(ra) # 8000613c <panic>

0000000080002ace <fsinit>:
fsinit(int dev) {
    80002ace:	7179                	addi	sp,sp,-48
    80002ad0:	f406                	sd	ra,40(sp)
    80002ad2:	f022                	sd	s0,32(sp)
    80002ad4:	ec26                	sd	s1,24(sp)
    80002ad6:	e84a                	sd	s2,16(sp)
    80002ad8:	e44e                	sd	s3,8(sp)
    80002ada:	1800                	addi	s0,sp,48
    80002adc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002ade:	4585                	li	a1,1
    80002ae0:	00000097          	auipc	ra,0x0
    80002ae4:	916080e7          	jalr	-1770(ra) # 800023f6 <bread>
    80002ae8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002aea:	00019997          	auipc	s3,0x19
    80002aee:	54e98993          	addi	s3,s3,1358 # 8001c038 <sb>
    80002af2:	02000613          	li	a2,32
    80002af6:	05050593          	addi	a1,a0,80
    80002afa:	854e                	mv	a0,s3
    80002afc:	ffffe097          	auipc	ra,0xffffe
    80002b00:	858080e7          	jalr	-1960(ra) # 80000354 <memmove>
  brelse(bp);
    80002b04:	8526                	mv	a0,s1
    80002b06:	00000097          	auipc	ra,0x0
    80002b0a:	b4e080e7          	jalr	-1202(ra) # 80002654 <brelse>
  if(sb.magic != FSMAGIC)
    80002b0e:	0009a703          	lw	a4,0(s3)
    80002b12:	102037b7          	lui	a5,0x10203
    80002b16:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b1a:	02f71263          	bne	a4,a5,80002b3e <fsinit+0x70>
  initlog(dev, &sb);
    80002b1e:	00019597          	auipc	a1,0x19
    80002b22:	51a58593          	addi	a1,a1,1306 # 8001c038 <sb>
    80002b26:	854a                	mv	a0,s2
    80002b28:	00001097          	auipc	ra,0x1
    80002b2c:	b4c080e7          	jalr	-1204(ra) # 80003674 <initlog>
}
    80002b30:	70a2                	ld	ra,40(sp)
    80002b32:	7402                	ld	s0,32(sp)
    80002b34:	64e2                	ld	s1,24(sp)
    80002b36:	6942                	ld	s2,16(sp)
    80002b38:	69a2                	ld	s3,8(sp)
    80002b3a:	6145                	addi	sp,sp,48
    80002b3c:	8082                	ret
    panic("invalid file system");
    80002b3e:	00006517          	auipc	a0,0x6
    80002b42:	9da50513          	addi	a0,a0,-1574 # 80008518 <syscalls+0x150>
    80002b46:	00003097          	auipc	ra,0x3
    80002b4a:	5f6080e7          	jalr	1526(ra) # 8000613c <panic>

0000000080002b4e <iinit>:
{
    80002b4e:	7179                	addi	sp,sp,-48
    80002b50:	f406                	sd	ra,40(sp)
    80002b52:	f022                	sd	s0,32(sp)
    80002b54:	ec26                	sd	s1,24(sp)
    80002b56:	e84a                	sd	s2,16(sp)
    80002b58:	e44e                	sd	s3,8(sp)
    80002b5a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b5c:	00006597          	auipc	a1,0x6
    80002b60:	9d458593          	addi	a1,a1,-1580 # 80008530 <syscalls+0x168>
    80002b64:	00019517          	auipc	a0,0x19
    80002b68:	4f450513          	addi	a0,a0,1268 # 8001c058 <itable>
    80002b6c:	00004097          	auipc	ra,0x4
    80002b70:	c80080e7          	jalr	-896(ra) # 800067ec <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b74:	00019497          	auipc	s1,0x19
    80002b78:	51448493          	addi	s1,s1,1300 # 8001c088 <itable+0x30>
    80002b7c:	0001b997          	auipc	s3,0x1b
    80002b80:	12c98993          	addi	s3,s3,300 # 8001dca8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b84:	00006917          	auipc	s2,0x6
    80002b88:	9b490913          	addi	s2,s2,-1612 # 80008538 <syscalls+0x170>
    80002b8c:	85ca                	mv	a1,s2
    80002b8e:	8526                	mv	a0,s1
    80002b90:	00001097          	auipc	ra,0x1
    80002b94:	e46080e7          	jalr	-442(ra) # 800039d6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b98:	09048493          	addi	s1,s1,144
    80002b9c:	ff3498e3          	bne	s1,s3,80002b8c <iinit+0x3e>
}
    80002ba0:	70a2                	ld	ra,40(sp)
    80002ba2:	7402                	ld	s0,32(sp)
    80002ba4:	64e2                	ld	s1,24(sp)
    80002ba6:	6942                	ld	s2,16(sp)
    80002ba8:	69a2                	ld	s3,8(sp)
    80002baa:	6145                	addi	sp,sp,48
    80002bac:	8082                	ret

0000000080002bae <ialloc>:
{
    80002bae:	715d                	addi	sp,sp,-80
    80002bb0:	e486                	sd	ra,72(sp)
    80002bb2:	e0a2                	sd	s0,64(sp)
    80002bb4:	fc26                	sd	s1,56(sp)
    80002bb6:	f84a                	sd	s2,48(sp)
    80002bb8:	f44e                	sd	s3,40(sp)
    80002bba:	f052                	sd	s4,32(sp)
    80002bbc:	ec56                	sd	s5,24(sp)
    80002bbe:	e85a                	sd	s6,16(sp)
    80002bc0:	e45e                	sd	s7,8(sp)
    80002bc2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bc4:	00019717          	auipc	a4,0x19
    80002bc8:	48072703          	lw	a4,1152(a4) # 8001c044 <sb+0xc>
    80002bcc:	4785                	li	a5,1
    80002bce:	04e7fa63          	bgeu	a5,a4,80002c22 <ialloc+0x74>
    80002bd2:	8aaa                	mv	s5,a0
    80002bd4:	8bae                	mv	s7,a1
    80002bd6:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bd8:	00019a17          	auipc	s4,0x19
    80002bdc:	460a0a13          	addi	s4,s4,1120 # 8001c038 <sb>
    80002be0:	00048b1b          	sext.w	s6,s1
    80002be4:	0044d593          	srli	a1,s1,0x4
    80002be8:	018a2783          	lw	a5,24(s4)
    80002bec:	9dbd                	addw	a1,a1,a5
    80002bee:	8556                	mv	a0,s5
    80002bf0:	00000097          	auipc	ra,0x0
    80002bf4:	806080e7          	jalr	-2042(ra) # 800023f6 <bread>
    80002bf8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bfa:	05050993          	addi	s3,a0,80
    80002bfe:	00f4f793          	andi	a5,s1,15
    80002c02:	079a                	slli	a5,a5,0x6
    80002c04:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c06:	00099783          	lh	a5,0(s3)
    80002c0a:	c785                	beqz	a5,80002c32 <ialloc+0x84>
    brelse(bp);
    80002c0c:	00000097          	auipc	ra,0x0
    80002c10:	a48080e7          	jalr	-1464(ra) # 80002654 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c14:	0485                	addi	s1,s1,1
    80002c16:	00ca2703          	lw	a4,12(s4)
    80002c1a:	0004879b          	sext.w	a5,s1
    80002c1e:	fce7e1e3          	bltu	a5,a4,80002be0 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002c22:	00006517          	auipc	a0,0x6
    80002c26:	91e50513          	addi	a0,a0,-1762 # 80008540 <syscalls+0x178>
    80002c2a:	00003097          	auipc	ra,0x3
    80002c2e:	512080e7          	jalr	1298(ra) # 8000613c <panic>
      memset(dip, 0, sizeof(*dip));
    80002c32:	04000613          	li	a2,64
    80002c36:	4581                	li	a1,0
    80002c38:	854e                	mv	a0,s3
    80002c3a:	ffffd097          	auipc	ra,0xffffd
    80002c3e:	6ba080e7          	jalr	1722(ra) # 800002f4 <memset>
      dip->type = type;
    80002c42:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c46:	854a                	mv	a0,s2
    80002c48:	00001097          	auipc	ra,0x1
    80002c4c:	ca8080e7          	jalr	-856(ra) # 800038f0 <log_write>
      brelse(bp);
    80002c50:	854a                	mv	a0,s2
    80002c52:	00000097          	auipc	ra,0x0
    80002c56:	a02080e7          	jalr	-1534(ra) # 80002654 <brelse>
      return iget(dev, inum);
    80002c5a:	85da                	mv	a1,s6
    80002c5c:	8556                	mv	a0,s5
    80002c5e:	00000097          	auipc	ra,0x0
    80002c62:	db4080e7          	jalr	-588(ra) # 80002a12 <iget>
}
    80002c66:	60a6                	ld	ra,72(sp)
    80002c68:	6406                	ld	s0,64(sp)
    80002c6a:	74e2                	ld	s1,56(sp)
    80002c6c:	7942                	ld	s2,48(sp)
    80002c6e:	79a2                	ld	s3,40(sp)
    80002c70:	7a02                	ld	s4,32(sp)
    80002c72:	6ae2                	ld	s5,24(sp)
    80002c74:	6b42                	ld	s6,16(sp)
    80002c76:	6ba2                	ld	s7,8(sp)
    80002c78:	6161                	addi	sp,sp,80
    80002c7a:	8082                	ret

0000000080002c7c <iupdate>:
{
    80002c7c:	1101                	addi	sp,sp,-32
    80002c7e:	ec06                	sd	ra,24(sp)
    80002c80:	e822                	sd	s0,16(sp)
    80002c82:	e426                	sd	s1,8(sp)
    80002c84:	e04a                	sd	s2,0(sp)
    80002c86:	1000                	addi	s0,sp,32
    80002c88:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c8a:	415c                	lw	a5,4(a0)
    80002c8c:	0047d79b          	srliw	a5,a5,0x4
    80002c90:	00019597          	auipc	a1,0x19
    80002c94:	3c05a583          	lw	a1,960(a1) # 8001c050 <sb+0x18>
    80002c98:	9dbd                	addw	a1,a1,a5
    80002c9a:	4108                	lw	a0,0(a0)
    80002c9c:	fffff097          	auipc	ra,0xfffff
    80002ca0:	75a080e7          	jalr	1882(ra) # 800023f6 <bread>
    80002ca4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ca6:	05050793          	addi	a5,a0,80
    80002caa:	40c8                	lw	a0,4(s1)
    80002cac:	893d                	andi	a0,a0,15
    80002cae:	051a                	slli	a0,a0,0x6
    80002cb0:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002cb2:	04c49703          	lh	a4,76(s1)
    80002cb6:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002cba:	04e49703          	lh	a4,78(s1)
    80002cbe:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002cc2:	05049703          	lh	a4,80(s1)
    80002cc6:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002cca:	05249703          	lh	a4,82(s1)
    80002cce:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002cd2:	48f8                	lw	a4,84(s1)
    80002cd4:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002cd6:	03400613          	li	a2,52
    80002cda:	05848593          	addi	a1,s1,88
    80002cde:	0531                	addi	a0,a0,12
    80002ce0:	ffffd097          	auipc	ra,0xffffd
    80002ce4:	674080e7          	jalr	1652(ra) # 80000354 <memmove>
  log_write(bp);
    80002ce8:	854a                	mv	a0,s2
    80002cea:	00001097          	auipc	ra,0x1
    80002cee:	c06080e7          	jalr	-1018(ra) # 800038f0 <log_write>
  brelse(bp);
    80002cf2:	854a                	mv	a0,s2
    80002cf4:	00000097          	auipc	ra,0x0
    80002cf8:	960080e7          	jalr	-1696(ra) # 80002654 <brelse>
}
    80002cfc:	60e2                	ld	ra,24(sp)
    80002cfe:	6442                	ld	s0,16(sp)
    80002d00:	64a2                	ld	s1,8(sp)
    80002d02:	6902                	ld	s2,0(sp)
    80002d04:	6105                	addi	sp,sp,32
    80002d06:	8082                	ret

0000000080002d08 <idup>:
{
    80002d08:	1101                	addi	sp,sp,-32
    80002d0a:	ec06                	sd	ra,24(sp)
    80002d0c:	e822                	sd	s0,16(sp)
    80002d0e:	e426                	sd	s1,8(sp)
    80002d10:	1000                	addi	s0,sp,32
    80002d12:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d14:	00019517          	auipc	a0,0x19
    80002d18:	34450513          	addi	a0,a0,836 # 8001c058 <itable>
    80002d1c:	00004097          	auipc	ra,0x4
    80002d20:	954080e7          	jalr	-1708(ra) # 80006670 <acquire>
  ip->ref++;
    80002d24:	449c                	lw	a5,8(s1)
    80002d26:	2785                	addiw	a5,a5,1
    80002d28:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d2a:	00019517          	auipc	a0,0x19
    80002d2e:	32e50513          	addi	a0,a0,814 # 8001c058 <itable>
    80002d32:	00004097          	auipc	ra,0x4
    80002d36:	a0e080e7          	jalr	-1522(ra) # 80006740 <release>
}
    80002d3a:	8526                	mv	a0,s1
    80002d3c:	60e2                	ld	ra,24(sp)
    80002d3e:	6442                	ld	s0,16(sp)
    80002d40:	64a2                	ld	s1,8(sp)
    80002d42:	6105                	addi	sp,sp,32
    80002d44:	8082                	ret

0000000080002d46 <ilock>:
{
    80002d46:	1101                	addi	sp,sp,-32
    80002d48:	ec06                	sd	ra,24(sp)
    80002d4a:	e822                	sd	s0,16(sp)
    80002d4c:	e426                	sd	s1,8(sp)
    80002d4e:	e04a                	sd	s2,0(sp)
    80002d50:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d52:	c115                	beqz	a0,80002d76 <ilock+0x30>
    80002d54:	84aa                	mv	s1,a0
    80002d56:	451c                	lw	a5,8(a0)
    80002d58:	00f05f63          	blez	a5,80002d76 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d5c:	0541                	addi	a0,a0,16
    80002d5e:	00001097          	auipc	ra,0x1
    80002d62:	cb2080e7          	jalr	-846(ra) # 80003a10 <acquiresleep>
  if(ip->valid == 0){
    80002d66:	44bc                	lw	a5,72(s1)
    80002d68:	cf99                	beqz	a5,80002d86 <ilock+0x40>
}
    80002d6a:	60e2                	ld	ra,24(sp)
    80002d6c:	6442                	ld	s0,16(sp)
    80002d6e:	64a2                	ld	s1,8(sp)
    80002d70:	6902                	ld	s2,0(sp)
    80002d72:	6105                	addi	sp,sp,32
    80002d74:	8082                	ret
    panic("ilock");
    80002d76:	00005517          	auipc	a0,0x5
    80002d7a:	7e250513          	addi	a0,a0,2018 # 80008558 <syscalls+0x190>
    80002d7e:	00003097          	auipc	ra,0x3
    80002d82:	3be080e7          	jalr	958(ra) # 8000613c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d86:	40dc                	lw	a5,4(s1)
    80002d88:	0047d79b          	srliw	a5,a5,0x4
    80002d8c:	00019597          	auipc	a1,0x19
    80002d90:	2c45a583          	lw	a1,708(a1) # 8001c050 <sb+0x18>
    80002d94:	9dbd                	addw	a1,a1,a5
    80002d96:	4088                	lw	a0,0(s1)
    80002d98:	fffff097          	auipc	ra,0xfffff
    80002d9c:	65e080e7          	jalr	1630(ra) # 800023f6 <bread>
    80002da0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002da2:	05050593          	addi	a1,a0,80
    80002da6:	40dc                	lw	a5,4(s1)
    80002da8:	8bbd                	andi	a5,a5,15
    80002daa:	079a                	slli	a5,a5,0x6
    80002dac:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002dae:	00059783          	lh	a5,0(a1)
    80002db2:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80002db6:	00259783          	lh	a5,2(a1)
    80002dba:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80002dbe:	00459783          	lh	a5,4(a1)
    80002dc2:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80002dc6:	00659783          	lh	a5,6(a1)
    80002dca:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80002dce:	459c                	lw	a5,8(a1)
    80002dd0:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002dd2:	03400613          	li	a2,52
    80002dd6:	05b1                	addi	a1,a1,12
    80002dd8:	05848513          	addi	a0,s1,88
    80002ddc:	ffffd097          	auipc	ra,0xffffd
    80002de0:	578080e7          	jalr	1400(ra) # 80000354 <memmove>
    brelse(bp);
    80002de4:	854a                	mv	a0,s2
    80002de6:	00000097          	auipc	ra,0x0
    80002dea:	86e080e7          	jalr	-1938(ra) # 80002654 <brelse>
    ip->valid = 1;
    80002dee:	4785                	li	a5,1
    80002df0:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80002df2:	04c49783          	lh	a5,76(s1)
    80002df6:	fbb5                	bnez	a5,80002d6a <ilock+0x24>
      panic("ilock: no type");
    80002df8:	00005517          	auipc	a0,0x5
    80002dfc:	76850513          	addi	a0,a0,1896 # 80008560 <syscalls+0x198>
    80002e00:	00003097          	auipc	ra,0x3
    80002e04:	33c080e7          	jalr	828(ra) # 8000613c <panic>

0000000080002e08 <iunlock>:
{
    80002e08:	1101                	addi	sp,sp,-32
    80002e0a:	ec06                	sd	ra,24(sp)
    80002e0c:	e822                	sd	s0,16(sp)
    80002e0e:	e426                	sd	s1,8(sp)
    80002e10:	e04a                	sd	s2,0(sp)
    80002e12:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e14:	c905                	beqz	a0,80002e44 <iunlock+0x3c>
    80002e16:	84aa                	mv	s1,a0
    80002e18:	01050913          	addi	s2,a0,16
    80002e1c:	854a                	mv	a0,s2
    80002e1e:	00001097          	auipc	ra,0x1
    80002e22:	c8c080e7          	jalr	-884(ra) # 80003aaa <holdingsleep>
    80002e26:	cd19                	beqz	a0,80002e44 <iunlock+0x3c>
    80002e28:	449c                	lw	a5,8(s1)
    80002e2a:	00f05d63          	blez	a5,80002e44 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e2e:	854a                	mv	a0,s2
    80002e30:	00001097          	auipc	ra,0x1
    80002e34:	c36080e7          	jalr	-970(ra) # 80003a66 <releasesleep>
}
    80002e38:	60e2                	ld	ra,24(sp)
    80002e3a:	6442                	ld	s0,16(sp)
    80002e3c:	64a2                	ld	s1,8(sp)
    80002e3e:	6902                	ld	s2,0(sp)
    80002e40:	6105                	addi	sp,sp,32
    80002e42:	8082                	ret
    panic("iunlock");
    80002e44:	00005517          	auipc	a0,0x5
    80002e48:	72c50513          	addi	a0,a0,1836 # 80008570 <syscalls+0x1a8>
    80002e4c:	00003097          	auipc	ra,0x3
    80002e50:	2f0080e7          	jalr	752(ra) # 8000613c <panic>

0000000080002e54 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e54:	7179                	addi	sp,sp,-48
    80002e56:	f406                	sd	ra,40(sp)
    80002e58:	f022                	sd	s0,32(sp)
    80002e5a:	ec26                	sd	s1,24(sp)
    80002e5c:	e84a                	sd	s2,16(sp)
    80002e5e:	e44e                	sd	s3,8(sp)
    80002e60:	e052                	sd	s4,0(sp)
    80002e62:	1800                	addi	s0,sp,48
    80002e64:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e66:	05850493          	addi	s1,a0,88
    80002e6a:	08850913          	addi	s2,a0,136
    80002e6e:	a021                	j	80002e76 <itrunc+0x22>
    80002e70:	0491                	addi	s1,s1,4
    80002e72:	01248d63          	beq	s1,s2,80002e8c <itrunc+0x38>
    if(ip->addrs[i]){
    80002e76:	408c                	lw	a1,0(s1)
    80002e78:	dde5                	beqz	a1,80002e70 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e7a:	0009a503          	lw	a0,0(s3)
    80002e7e:	00000097          	auipc	ra,0x0
    80002e82:	90c080e7          	jalr	-1780(ra) # 8000278a <bfree>
      ip->addrs[i] = 0;
    80002e86:	0004a023          	sw	zero,0(s1)
    80002e8a:	b7dd                	j	80002e70 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e8c:	0889a583          	lw	a1,136(s3)
    80002e90:	e185                	bnez	a1,80002eb0 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e92:	0409aa23          	sw	zero,84(s3)
  iupdate(ip);
    80002e96:	854e                	mv	a0,s3
    80002e98:	00000097          	auipc	ra,0x0
    80002e9c:	de4080e7          	jalr	-540(ra) # 80002c7c <iupdate>
}
    80002ea0:	70a2                	ld	ra,40(sp)
    80002ea2:	7402                	ld	s0,32(sp)
    80002ea4:	64e2                	ld	s1,24(sp)
    80002ea6:	6942                	ld	s2,16(sp)
    80002ea8:	69a2                	ld	s3,8(sp)
    80002eaa:	6a02                	ld	s4,0(sp)
    80002eac:	6145                	addi	sp,sp,48
    80002eae:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002eb0:	0009a503          	lw	a0,0(s3)
    80002eb4:	fffff097          	auipc	ra,0xfffff
    80002eb8:	542080e7          	jalr	1346(ra) # 800023f6 <bread>
    80002ebc:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ebe:	05050493          	addi	s1,a0,80
    80002ec2:	45050913          	addi	s2,a0,1104
    80002ec6:	a811                	j	80002eda <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002ec8:	0009a503          	lw	a0,0(s3)
    80002ecc:	00000097          	auipc	ra,0x0
    80002ed0:	8be080e7          	jalr	-1858(ra) # 8000278a <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002ed4:	0491                	addi	s1,s1,4
    80002ed6:	01248563          	beq	s1,s2,80002ee0 <itrunc+0x8c>
      if(a[j])
    80002eda:	408c                	lw	a1,0(s1)
    80002edc:	dde5                	beqz	a1,80002ed4 <itrunc+0x80>
    80002ede:	b7ed                	j	80002ec8 <itrunc+0x74>
    brelse(bp);
    80002ee0:	8552                	mv	a0,s4
    80002ee2:	fffff097          	auipc	ra,0xfffff
    80002ee6:	772080e7          	jalr	1906(ra) # 80002654 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002eea:	0889a583          	lw	a1,136(s3)
    80002eee:	0009a503          	lw	a0,0(s3)
    80002ef2:	00000097          	auipc	ra,0x0
    80002ef6:	898080e7          	jalr	-1896(ra) # 8000278a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002efa:	0809a423          	sw	zero,136(s3)
    80002efe:	bf51                	j	80002e92 <itrunc+0x3e>

0000000080002f00 <iput>:
{
    80002f00:	1101                	addi	sp,sp,-32
    80002f02:	ec06                	sd	ra,24(sp)
    80002f04:	e822                	sd	s0,16(sp)
    80002f06:	e426                	sd	s1,8(sp)
    80002f08:	e04a                	sd	s2,0(sp)
    80002f0a:	1000                	addi	s0,sp,32
    80002f0c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f0e:	00019517          	auipc	a0,0x19
    80002f12:	14a50513          	addi	a0,a0,330 # 8001c058 <itable>
    80002f16:	00003097          	auipc	ra,0x3
    80002f1a:	75a080e7          	jalr	1882(ra) # 80006670 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f1e:	4498                	lw	a4,8(s1)
    80002f20:	4785                	li	a5,1
    80002f22:	02f70363          	beq	a4,a5,80002f48 <iput+0x48>
  ip->ref--;
    80002f26:	449c                	lw	a5,8(s1)
    80002f28:	37fd                	addiw	a5,a5,-1
    80002f2a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f2c:	00019517          	auipc	a0,0x19
    80002f30:	12c50513          	addi	a0,a0,300 # 8001c058 <itable>
    80002f34:	00004097          	auipc	ra,0x4
    80002f38:	80c080e7          	jalr	-2036(ra) # 80006740 <release>
}
    80002f3c:	60e2                	ld	ra,24(sp)
    80002f3e:	6442                	ld	s0,16(sp)
    80002f40:	64a2                	ld	s1,8(sp)
    80002f42:	6902                	ld	s2,0(sp)
    80002f44:	6105                	addi	sp,sp,32
    80002f46:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f48:	44bc                	lw	a5,72(s1)
    80002f4a:	dff1                	beqz	a5,80002f26 <iput+0x26>
    80002f4c:	05249783          	lh	a5,82(s1)
    80002f50:	fbf9                	bnez	a5,80002f26 <iput+0x26>
    acquiresleep(&ip->lock);
    80002f52:	01048913          	addi	s2,s1,16
    80002f56:	854a                	mv	a0,s2
    80002f58:	00001097          	auipc	ra,0x1
    80002f5c:	ab8080e7          	jalr	-1352(ra) # 80003a10 <acquiresleep>
    release(&itable.lock);
    80002f60:	00019517          	auipc	a0,0x19
    80002f64:	0f850513          	addi	a0,a0,248 # 8001c058 <itable>
    80002f68:	00003097          	auipc	ra,0x3
    80002f6c:	7d8080e7          	jalr	2008(ra) # 80006740 <release>
    itrunc(ip);
    80002f70:	8526                	mv	a0,s1
    80002f72:	00000097          	auipc	ra,0x0
    80002f76:	ee2080e7          	jalr	-286(ra) # 80002e54 <itrunc>
    ip->type = 0;
    80002f7a:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    80002f7e:	8526                	mv	a0,s1
    80002f80:	00000097          	auipc	ra,0x0
    80002f84:	cfc080e7          	jalr	-772(ra) # 80002c7c <iupdate>
    ip->valid = 0;
    80002f88:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    80002f8c:	854a                	mv	a0,s2
    80002f8e:	00001097          	auipc	ra,0x1
    80002f92:	ad8080e7          	jalr	-1320(ra) # 80003a66 <releasesleep>
    acquire(&itable.lock);
    80002f96:	00019517          	auipc	a0,0x19
    80002f9a:	0c250513          	addi	a0,a0,194 # 8001c058 <itable>
    80002f9e:	00003097          	auipc	ra,0x3
    80002fa2:	6d2080e7          	jalr	1746(ra) # 80006670 <acquire>
    80002fa6:	b741                	j	80002f26 <iput+0x26>

0000000080002fa8 <iunlockput>:
{
    80002fa8:	1101                	addi	sp,sp,-32
    80002faa:	ec06                	sd	ra,24(sp)
    80002fac:	e822                	sd	s0,16(sp)
    80002fae:	e426                	sd	s1,8(sp)
    80002fb0:	1000                	addi	s0,sp,32
    80002fb2:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fb4:	00000097          	auipc	ra,0x0
    80002fb8:	e54080e7          	jalr	-428(ra) # 80002e08 <iunlock>
  iput(ip);
    80002fbc:	8526                	mv	a0,s1
    80002fbe:	00000097          	auipc	ra,0x0
    80002fc2:	f42080e7          	jalr	-190(ra) # 80002f00 <iput>
}
    80002fc6:	60e2                	ld	ra,24(sp)
    80002fc8:	6442                	ld	s0,16(sp)
    80002fca:	64a2                	ld	s1,8(sp)
    80002fcc:	6105                	addi	sp,sp,32
    80002fce:	8082                	ret

0000000080002fd0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fd0:	1141                	addi	sp,sp,-16
    80002fd2:	e422                	sd	s0,8(sp)
    80002fd4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002fd6:	411c                	lw	a5,0(a0)
    80002fd8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fda:	415c                	lw	a5,4(a0)
    80002fdc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fde:	04c51783          	lh	a5,76(a0)
    80002fe2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fe6:	05251783          	lh	a5,82(a0)
    80002fea:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fee:	05456783          	lwu	a5,84(a0)
    80002ff2:	e99c                	sd	a5,16(a1)
}
    80002ff4:	6422                	ld	s0,8(sp)
    80002ff6:	0141                	addi	sp,sp,16
    80002ff8:	8082                	ret

0000000080002ffa <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ffa:	497c                	lw	a5,84(a0)
    80002ffc:	0ed7e963          	bltu	a5,a3,800030ee <readi+0xf4>
{
    80003000:	7159                	addi	sp,sp,-112
    80003002:	f486                	sd	ra,104(sp)
    80003004:	f0a2                	sd	s0,96(sp)
    80003006:	eca6                	sd	s1,88(sp)
    80003008:	e8ca                	sd	s2,80(sp)
    8000300a:	e4ce                	sd	s3,72(sp)
    8000300c:	e0d2                	sd	s4,64(sp)
    8000300e:	fc56                	sd	s5,56(sp)
    80003010:	f85a                	sd	s6,48(sp)
    80003012:	f45e                	sd	s7,40(sp)
    80003014:	f062                	sd	s8,32(sp)
    80003016:	ec66                	sd	s9,24(sp)
    80003018:	e86a                	sd	s10,16(sp)
    8000301a:	e46e                	sd	s11,8(sp)
    8000301c:	1880                	addi	s0,sp,112
    8000301e:	8baa                	mv	s7,a0
    80003020:	8c2e                	mv	s8,a1
    80003022:	8ab2                	mv	s5,a2
    80003024:	84b6                	mv	s1,a3
    80003026:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003028:	9f35                	addw	a4,a4,a3
    return 0;
    8000302a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000302c:	0ad76063          	bltu	a4,a3,800030cc <readi+0xd2>
  if(off + n > ip->size)
    80003030:	00e7f463          	bgeu	a5,a4,80003038 <readi+0x3e>
    n = ip->size - off;
    80003034:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003038:	0a0b0963          	beqz	s6,800030ea <readi+0xf0>
    8000303c:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000303e:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003042:	5cfd                	li	s9,-1
    80003044:	a82d                	j	8000307e <readi+0x84>
    80003046:	020a1d93          	slli	s11,s4,0x20
    8000304a:	020ddd93          	srli	s11,s11,0x20
    8000304e:	05090613          	addi	a2,s2,80
    80003052:	86ee                	mv	a3,s11
    80003054:	963a                	add	a2,a2,a4
    80003056:	85d6                	mv	a1,s5
    80003058:	8562                	mv	a0,s8
    8000305a:	fffff097          	auipc	ra,0xfffff
    8000305e:	9da080e7          	jalr	-1574(ra) # 80001a34 <either_copyout>
    80003062:	05950d63          	beq	a0,s9,800030bc <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003066:	854a                	mv	a0,s2
    80003068:	fffff097          	auipc	ra,0xfffff
    8000306c:	5ec080e7          	jalr	1516(ra) # 80002654 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003070:	013a09bb          	addw	s3,s4,s3
    80003074:	009a04bb          	addw	s1,s4,s1
    80003078:	9aee                	add	s5,s5,s11
    8000307a:	0569f763          	bgeu	s3,s6,800030c8 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000307e:	000ba903          	lw	s2,0(s7)
    80003082:	00a4d59b          	srliw	a1,s1,0xa
    80003086:	855e                	mv	a0,s7
    80003088:	00000097          	auipc	ra,0x0
    8000308c:	8b0080e7          	jalr	-1872(ra) # 80002938 <bmap>
    80003090:	0005059b          	sext.w	a1,a0
    80003094:	854a                	mv	a0,s2
    80003096:	fffff097          	auipc	ra,0xfffff
    8000309a:	360080e7          	jalr	864(ra) # 800023f6 <bread>
    8000309e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030a0:	3ff4f713          	andi	a4,s1,1023
    800030a4:	40ed07bb          	subw	a5,s10,a4
    800030a8:	413b06bb          	subw	a3,s6,s3
    800030ac:	8a3e                	mv	s4,a5
    800030ae:	2781                	sext.w	a5,a5
    800030b0:	0006861b          	sext.w	a2,a3
    800030b4:	f8f679e3          	bgeu	a2,a5,80003046 <readi+0x4c>
    800030b8:	8a36                	mv	s4,a3
    800030ba:	b771                	j	80003046 <readi+0x4c>
      brelse(bp);
    800030bc:	854a                	mv	a0,s2
    800030be:	fffff097          	auipc	ra,0xfffff
    800030c2:	596080e7          	jalr	1430(ra) # 80002654 <brelse>
      tot = -1;
    800030c6:	59fd                	li	s3,-1
  }
  return tot;
    800030c8:	0009851b          	sext.w	a0,s3
}
    800030cc:	70a6                	ld	ra,104(sp)
    800030ce:	7406                	ld	s0,96(sp)
    800030d0:	64e6                	ld	s1,88(sp)
    800030d2:	6946                	ld	s2,80(sp)
    800030d4:	69a6                	ld	s3,72(sp)
    800030d6:	6a06                	ld	s4,64(sp)
    800030d8:	7ae2                	ld	s5,56(sp)
    800030da:	7b42                	ld	s6,48(sp)
    800030dc:	7ba2                	ld	s7,40(sp)
    800030de:	7c02                	ld	s8,32(sp)
    800030e0:	6ce2                	ld	s9,24(sp)
    800030e2:	6d42                	ld	s10,16(sp)
    800030e4:	6da2                	ld	s11,8(sp)
    800030e6:	6165                	addi	sp,sp,112
    800030e8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030ea:	89da                	mv	s3,s6
    800030ec:	bff1                	j	800030c8 <readi+0xce>
    return 0;
    800030ee:	4501                	li	a0,0
}
    800030f0:	8082                	ret

00000000800030f2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030f2:	497c                	lw	a5,84(a0)
    800030f4:	10d7e863          	bltu	a5,a3,80003204 <writei+0x112>
{
    800030f8:	7159                	addi	sp,sp,-112
    800030fa:	f486                	sd	ra,104(sp)
    800030fc:	f0a2                	sd	s0,96(sp)
    800030fe:	eca6                	sd	s1,88(sp)
    80003100:	e8ca                	sd	s2,80(sp)
    80003102:	e4ce                	sd	s3,72(sp)
    80003104:	e0d2                	sd	s4,64(sp)
    80003106:	fc56                	sd	s5,56(sp)
    80003108:	f85a                	sd	s6,48(sp)
    8000310a:	f45e                	sd	s7,40(sp)
    8000310c:	f062                	sd	s8,32(sp)
    8000310e:	ec66                	sd	s9,24(sp)
    80003110:	e86a                	sd	s10,16(sp)
    80003112:	e46e                	sd	s11,8(sp)
    80003114:	1880                	addi	s0,sp,112
    80003116:	8b2a                	mv	s6,a0
    80003118:	8c2e                	mv	s8,a1
    8000311a:	8ab2                	mv	s5,a2
    8000311c:	8936                	mv	s2,a3
    8000311e:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003120:	00e687bb          	addw	a5,a3,a4
    80003124:	0ed7e263          	bltu	a5,a3,80003208 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003128:	00043737          	lui	a4,0x43
    8000312c:	0ef76063          	bltu	a4,a5,8000320c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003130:	0c0b8863          	beqz	s7,80003200 <writei+0x10e>
    80003134:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003136:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000313a:	5cfd                	li	s9,-1
    8000313c:	a091                	j	80003180 <writei+0x8e>
    8000313e:	02099d93          	slli	s11,s3,0x20
    80003142:	020ddd93          	srli	s11,s11,0x20
    80003146:	05048513          	addi	a0,s1,80
    8000314a:	86ee                	mv	a3,s11
    8000314c:	8656                	mv	a2,s5
    8000314e:	85e2                	mv	a1,s8
    80003150:	953a                	add	a0,a0,a4
    80003152:	fffff097          	auipc	ra,0xfffff
    80003156:	938080e7          	jalr	-1736(ra) # 80001a8a <either_copyin>
    8000315a:	07950263          	beq	a0,s9,800031be <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000315e:	8526                	mv	a0,s1
    80003160:	00000097          	auipc	ra,0x0
    80003164:	790080e7          	jalr	1936(ra) # 800038f0 <log_write>
    brelse(bp);
    80003168:	8526                	mv	a0,s1
    8000316a:	fffff097          	auipc	ra,0xfffff
    8000316e:	4ea080e7          	jalr	1258(ra) # 80002654 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003172:	01498a3b          	addw	s4,s3,s4
    80003176:	0129893b          	addw	s2,s3,s2
    8000317a:	9aee                	add	s5,s5,s11
    8000317c:	057a7663          	bgeu	s4,s7,800031c8 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003180:	000b2483          	lw	s1,0(s6)
    80003184:	00a9559b          	srliw	a1,s2,0xa
    80003188:	855a                	mv	a0,s6
    8000318a:	fffff097          	auipc	ra,0xfffff
    8000318e:	7ae080e7          	jalr	1966(ra) # 80002938 <bmap>
    80003192:	0005059b          	sext.w	a1,a0
    80003196:	8526                	mv	a0,s1
    80003198:	fffff097          	auipc	ra,0xfffff
    8000319c:	25e080e7          	jalr	606(ra) # 800023f6 <bread>
    800031a0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031a2:	3ff97713          	andi	a4,s2,1023
    800031a6:	40ed07bb          	subw	a5,s10,a4
    800031aa:	414b86bb          	subw	a3,s7,s4
    800031ae:	89be                	mv	s3,a5
    800031b0:	2781                	sext.w	a5,a5
    800031b2:	0006861b          	sext.w	a2,a3
    800031b6:	f8f674e3          	bgeu	a2,a5,8000313e <writei+0x4c>
    800031ba:	89b6                	mv	s3,a3
    800031bc:	b749                	j	8000313e <writei+0x4c>
      brelse(bp);
    800031be:	8526                	mv	a0,s1
    800031c0:	fffff097          	auipc	ra,0xfffff
    800031c4:	494080e7          	jalr	1172(ra) # 80002654 <brelse>
  }

  if(off > ip->size)
    800031c8:	054b2783          	lw	a5,84(s6)
    800031cc:	0127f463          	bgeu	a5,s2,800031d4 <writei+0xe2>
    ip->size = off;
    800031d0:	052b2a23          	sw	s2,84(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031d4:	855a                	mv	a0,s6
    800031d6:	00000097          	auipc	ra,0x0
    800031da:	aa6080e7          	jalr	-1370(ra) # 80002c7c <iupdate>

  return tot;
    800031de:	000a051b          	sext.w	a0,s4
}
    800031e2:	70a6                	ld	ra,104(sp)
    800031e4:	7406                	ld	s0,96(sp)
    800031e6:	64e6                	ld	s1,88(sp)
    800031e8:	6946                	ld	s2,80(sp)
    800031ea:	69a6                	ld	s3,72(sp)
    800031ec:	6a06                	ld	s4,64(sp)
    800031ee:	7ae2                	ld	s5,56(sp)
    800031f0:	7b42                	ld	s6,48(sp)
    800031f2:	7ba2                	ld	s7,40(sp)
    800031f4:	7c02                	ld	s8,32(sp)
    800031f6:	6ce2                	ld	s9,24(sp)
    800031f8:	6d42                	ld	s10,16(sp)
    800031fa:	6da2                	ld	s11,8(sp)
    800031fc:	6165                	addi	sp,sp,112
    800031fe:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003200:	8a5e                	mv	s4,s7
    80003202:	bfc9                	j	800031d4 <writei+0xe2>
    return -1;
    80003204:	557d                	li	a0,-1
}
    80003206:	8082                	ret
    return -1;
    80003208:	557d                	li	a0,-1
    8000320a:	bfe1                	j	800031e2 <writei+0xf0>
    return -1;
    8000320c:	557d                	li	a0,-1
    8000320e:	bfd1                	j	800031e2 <writei+0xf0>

0000000080003210 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003210:	1141                	addi	sp,sp,-16
    80003212:	e406                	sd	ra,8(sp)
    80003214:	e022                	sd	s0,0(sp)
    80003216:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003218:	4639                	li	a2,14
    8000321a:	ffffd097          	auipc	ra,0xffffd
    8000321e:	1b2080e7          	jalr	434(ra) # 800003cc <strncmp>
}
    80003222:	60a2                	ld	ra,8(sp)
    80003224:	6402                	ld	s0,0(sp)
    80003226:	0141                	addi	sp,sp,16
    80003228:	8082                	ret

000000008000322a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000322a:	7139                	addi	sp,sp,-64
    8000322c:	fc06                	sd	ra,56(sp)
    8000322e:	f822                	sd	s0,48(sp)
    80003230:	f426                	sd	s1,40(sp)
    80003232:	f04a                	sd	s2,32(sp)
    80003234:	ec4e                	sd	s3,24(sp)
    80003236:	e852                	sd	s4,16(sp)
    80003238:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000323a:	04c51703          	lh	a4,76(a0)
    8000323e:	4785                	li	a5,1
    80003240:	00f71a63          	bne	a4,a5,80003254 <dirlookup+0x2a>
    80003244:	892a                	mv	s2,a0
    80003246:	89ae                	mv	s3,a1
    80003248:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000324a:	497c                	lw	a5,84(a0)
    8000324c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000324e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003250:	e79d                	bnez	a5,8000327e <dirlookup+0x54>
    80003252:	a8a5                	j	800032ca <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003254:	00005517          	auipc	a0,0x5
    80003258:	32450513          	addi	a0,a0,804 # 80008578 <syscalls+0x1b0>
    8000325c:	00003097          	auipc	ra,0x3
    80003260:	ee0080e7          	jalr	-288(ra) # 8000613c <panic>
      panic("dirlookup read");
    80003264:	00005517          	auipc	a0,0x5
    80003268:	32c50513          	addi	a0,a0,812 # 80008590 <syscalls+0x1c8>
    8000326c:	00003097          	auipc	ra,0x3
    80003270:	ed0080e7          	jalr	-304(ra) # 8000613c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003274:	24c1                	addiw	s1,s1,16
    80003276:	05492783          	lw	a5,84(s2)
    8000327a:	04f4f763          	bgeu	s1,a5,800032c8 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000327e:	4741                	li	a4,16
    80003280:	86a6                	mv	a3,s1
    80003282:	fc040613          	addi	a2,s0,-64
    80003286:	4581                	li	a1,0
    80003288:	854a                	mv	a0,s2
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	d70080e7          	jalr	-656(ra) # 80002ffa <readi>
    80003292:	47c1                	li	a5,16
    80003294:	fcf518e3          	bne	a0,a5,80003264 <dirlookup+0x3a>
    if(de.inum == 0)
    80003298:	fc045783          	lhu	a5,-64(s0)
    8000329c:	dfe1                	beqz	a5,80003274 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000329e:	fc240593          	addi	a1,s0,-62
    800032a2:	854e                	mv	a0,s3
    800032a4:	00000097          	auipc	ra,0x0
    800032a8:	f6c080e7          	jalr	-148(ra) # 80003210 <namecmp>
    800032ac:	f561                	bnez	a0,80003274 <dirlookup+0x4a>
      if(poff)
    800032ae:	000a0463          	beqz	s4,800032b6 <dirlookup+0x8c>
        *poff = off;
    800032b2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032b6:	fc045583          	lhu	a1,-64(s0)
    800032ba:	00092503          	lw	a0,0(s2)
    800032be:	fffff097          	auipc	ra,0xfffff
    800032c2:	754080e7          	jalr	1876(ra) # 80002a12 <iget>
    800032c6:	a011                	j	800032ca <dirlookup+0xa0>
  return 0;
    800032c8:	4501                	li	a0,0
}
    800032ca:	70e2                	ld	ra,56(sp)
    800032cc:	7442                	ld	s0,48(sp)
    800032ce:	74a2                	ld	s1,40(sp)
    800032d0:	7902                	ld	s2,32(sp)
    800032d2:	69e2                	ld	s3,24(sp)
    800032d4:	6a42                	ld	s4,16(sp)
    800032d6:	6121                	addi	sp,sp,64
    800032d8:	8082                	ret

00000000800032da <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032da:	711d                	addi	sp,sp,-96
    800032dc:	ec86                	sd	ra,88(sp)
    800032de:	e8a2                	sd	s0,80(sp)
    800032e0:	e4a6                	sd	s1,72(sp)
    800032e2:	e0ca                	sd	s2,64(sp)
    800032e4:	fc4e                	sd	s3,56(sp)
    800032e6:	f852                	sd	s4,48(sp)
    800032e8:	f456                	sd	s5,40(sp)
    800032ea:	f05a                	sd	s6,32(sp)
    800032ec:	ec5e                	sd	s7,24(sp)
    800032ee:	e862                	sd	s8,16(sp)
    800032f0:	e466                	sd	s9,8(sp)
    800032f2:	1080                	addi	s0,sp,96
    800032f4:	84aa                	mv	s1,a0
    800032f6:	8b2e                	mv	s6,a1
    800032f8:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032fa:	00054703          	lbu	a4,0(a0)
    800032fe:	02f00793          	li	a5,47
    80003302:	02f70363          	beq	a4,a5,80003328 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003306:	ffffe097          	auipc	ra,0xffffe
    8000330a:	cce080e7          	jalr	-818(ra) # 80000fd4 <myproc>
    8000330e:	15853503          	ld	a0,344(a0)
    80003312:	00000097          	auipc	ra,0x0
    80003316:	9f6080e7          	jalr	-1546(ra) # 80002d08 <idup>
    8000331a:	89aa                	mv	s3,a0
  while(*path == '/')
    8000331c:	02f00913          	li	s2,47
  len = path - s;
    80003320:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003322:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003324:	4c05                	li	s8,1
    80003326:	a865                	j	800033de <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003328:	4585                	li	a1,1
    8000332a:	4505                	li	a0,1
    8000332c:	fffff097          	auipc	ra,0xfffff
    80003330:	6e6080e7          	jalr	1766(ra) # 80002a12 <iget>
    80003334:	89aa                	mv	s3,a0
    80003336:	b7dd                	j	8000331c <namex+0x42>
      iunlockput(ip);
    80003338:	854e                	mv	a0,s3
    8000333a:	00000097          	auipc	ra,0x0
    8000333e:	c6e080e7          	jalr	-914(ra) # 80002fa8 <iunlockput>
      return 0;
    80003342:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003344:	854e                	mv	a0,s3
    80003346:	60e6                	ld	ra,88(sp)
    80003348:	6446                	ld	s0,80(sp)
    8000334a:	64a6                	ld	s1,72(sp)
    8000334c:	6906                	ld	s2,64(sp)
    8000334e:	79e2                	ld	s3,56(sp)
    80003350:	7a42                	ld	s4,48(sp)
    80003352:	7aa2                	ld	s5,40(sp)
    80003354:	7b02                	ld	s6,32(sp)
    80003356:	6be2                	ld	s7,24(sp)
    80003358:	6c42                	ld	s8,16(sp)
    8000335a:	6ca2                	ld	s9,8(sp)
    8000335c:	6125                	addi	sp,sp,96
    8000335e:	8082                	ret
      iunlock(ip);
    80003360:	854e                	mv	a0,s3
    80003362:	00000097          	auipc	ra,0x0
    80003366:	aa6080e7          	jalr	-1370(ra) # 80002e08 <iunlock>
      return ip;
    8000336a:	bfe9                	j	80003344 <namex+0x6a>
      iunlockput(ip);
    8000336c:	854e                	mv	a0,s3
    8000336e:	00000097          	auipc	ra,0x0
    80003372:	c3a080e7          	jalr	-966(ra) # 80002fa8 <iunlockput>
      return 0;
    80003376:	89d2                	mv	s3,s4
    80003378:	b7f1                	j	80003344 <namex+0x6a>
  len = path - s;
    8000337a:	40b48633          	sub	a2,s1,a1
    8000337e:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003382:	094cd463          	bge	s9,s4,8000340a <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003386:	4639                	li	a2,14
    80003388:	8556                	mv	a0,s5
    8000338a:	ffffd097          	auipc	ra,0xffffd
    8000338e:	fca080e7          	jalr	-54(ra) # 80000354 <memmove>
  while(*path == '/')
    80003392:	0004c783          	lbu	a5,0(s1)
    80003396:	01279763          	bne	a5,s2,800033a4 <namex+0xca>
    path++;
    8000339a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000339c:	0004c783          	lbu	a5,0(s1)
    800033a0:	ff278de3          	beq	a5,s2,8000339a <namex+0xc0>
    ilock(ip);
    800033a4:	854e                	mv	a0,s3
    800033a6:	00000097          	auipc	ra,0x0
    800033aa:	9a0080e7          	jalr	-1632(ra) # 80002d46 <ilock>
    if(ip->type != T_DIR){
    800033ae:	04c99783          	lh	a5,76(s3)
    800033b2:	f98793e3          	bne	a5,s8,80003338 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800033b6:	000b0563          	beqz	s6,800033c0 <namex+0xe6>
    800033ba:	0004c783          	lbu	a5,0(s1)
    800033be:	d3cd                	beqz	a5,80003360 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033c0:	865e                	mv	a2,s7
    800033c2:	85d6                	mv	a1,s5
    800033c4:	854e                	mv	a0,s3
    800033c6:	00000097          	auipc	ra,0x0
    800033ca:	e64080e7          	jalr	-412(ra) # 8000322a <dirlookup>
    800033ce:	8a2a                	mv	s4,a0
    800033d0:	dd51                	beqz	a0,8000336c <namex+0x92>
    iunlockput(ip);
    800033d2:	854e                	mv	a0,s3
    800033d4:	00000097          	auipc	ra,0x0
    800033d8:	bd4080e7          	jalr	-1068(ra) # 80002fa8 <iunlockput>
    ip = next;
    800033dc:	89d2                	mv	s3,s4
  while(*path == '/')
    800033de:	0004c783          	lbu	a5,0(s1)
    800033e2:	05279763          	bne	a5,s2,80003430 <namex+0x156>
    path++;
    800033e6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033e8:	0004c783          	lbu	a5,0(s1)
    800033ec:	ff278de3          	beq	a5,s2,800033e6 <namex+0x10c>
  if(*path == 0)
    800033f0:	c79d                	beqz	a5,8000341e <namex+0x144>
    path++;
    800033f2:	85a6                	mv	a1,s1
  len = path - s;
    800033f4:	8a5e                	mv	s4,s7
    800033f6:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033f8:	01278963          	beq	a5,s2,8000340a <namex+0x130>
    800033fc:	dfbd                	beqz	a5,8000337a <namex+0xa0>
    path++;
    800033fe:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003400:	0004c783          	lbu	a5,0(s1)
    80003404:	ff279ce3          	bne	a5,s2,800033fc <namex+0x122>
    80003408:	bf8d                	j	8000337a <namex+0xa0>
    memmove(name, s, len);
    8000340a:	2601                	sext.w	a2,a2
    8000340c:	8556                	mv	a0,s5
    8000340e:	ffffd097          	auipc	ra,0xffffd
    80003412:	f46080e7          	jalr	-186(ra) # 80000354 <memmove>
    name[len] = 0;
    80003416:	9a56                	add	s4,s4,s5
    80003418:	000a0023          	sb	zero,0(s4)
    8000341c:	bf9d                	j	80003392 <namex+0xb8>
  if(nameiparent){
    8000341e:	f20b03e3          	beqz	s6,80003344 <namex+0x6a>
    iput(ip);
    80003422:	854e                	mv	a0,s3
    80003424:	00000097          	auipc	ra,0x0
    80003428:	adc080e7          	jalr	-1316(ra) # 80002f00 <iput>
    return 0;
    8000342c:	4981                	li	s3,0
    8000342e:	bf19                	j	80003344 <namex+0x6a>
  if(*path == 0)
    80003430:	d7fd                	beqz	a5,8000341e <namex+0x144>
  while(*path != '/' && *path != 0)
    80003432:	0004c783          	lbu	a5,0(s1)
    80003436:	85a6                	mv	a1,s1
    80003438:	b7d1                	j	800033fc <namex+0x122>

000000008000343a <dirlink>:
{
    8000343a:	7139                	addi	sp,sp,-64
    8000343c:	fc06                	sd	ra,56(sp)
    8000343e:	f822                	sd	s0,48(sp)
    80003440:	f426                	sd	s1,40(sp)
    80003442:	f04a                	sd	s2,32(sp)
    80003444:	ec4e                	sd	s3,24(sp)
    80003446:	e852                	sd	s4,16(sp)
    80003448:	0080                	addi	s0,sp,64
    8000344a:	892a                	mv	s2,a0
    8000344c:	8a2e                	mv	s4,a1
    8000344e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003450:	4601                	li	a2,0
    80003452:	00000097          	auipc	ra,0x0
    80003456:	dd8080e7          	jalr	-552(ra) # 8000322a <dirlookup>
    8000345a:	e93d                	bnez	a0,800034d0 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000345c:	05492483          	lw	s1,84(s2)
    80003460:	c49d                	beqz	s1,8000348e <dirlink+0x54>
    80003462:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003464:	4741                	li	a4,16
    80003466:	86a6                	mv	a3,s1
    80003468:	fc040613          	addi	a2,s0,-64
    8000346c:	4581                	li	a1,0
    8000346e:	854a                	mv	a0,s2
    80003470:	00000097          	auipc	ra,0x0
    80003474:	b8a080e7          	jalr	-1142(ra) # 80002ffa <readi>
    80003478:	47c1                	li	a5,16
    8000347a:	06f51163          	bne	a0,a5,800034dc <dirlink+0xa2>
    if(de.inum == 0)
    8000347e:	fc045783          	lhu	a5,-64(s0)
    80003482:	c791                	beqz	a5,8000348e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003484:	24c1                	addiw	s1,s1,16
    80003486:	05492783          	lw	a5,84(s2)
    8000348a:	fcf4ede3          	bltu	s1,a5,80003464 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000348e:	4639                	li	a2,14
    80003490:	85d2                	mv	a1,s4
    80003492:	fc240513          	addi	a0,s0,-62
    80003496:	ffffd097          	auipc	ra,0xffffd
    8000349a:	f72080e7          	jalr	-142(ra) # 80000408 <strncpy>
  de.inum = inum;
    8000349e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034a2:	4741                	li	a4,16
    800034a4:	86a6                	mv	a3,s1
    800034a6:	fc040613          	addi	a2,s0,-64
    800034aa:	4581                	li	a1,0
    800034ac:	854a                	mv	a0,s2
    800034ae:	00000097          	auipc	ra,0x0
    800034b2:	c44080e7          	jalr	-956(ra) # 800030f2 <writei>
    800034b6:	872a                	mv	a4,a0
    800034b8:	47c1                	li	a5,16
  return 0;
    800034ba:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034bc:	02f71863          	bne	a4,a5,800034ec <dirlink+0xb2>
}
    800034c0:	70e2                	ld	ra,56(sp)
    800034c2:	7442                	ld	s0,48(sp)
    800034c4:	74a2                	ld	s1,40(sp)
    800034c6:	7902                	ld	s2,32(sp)
    800034c8:	69e2                	ld	s3,24(sp)
    800034ca:	6a42                	ld	s4,16(sp)
    800034cc:	6121                	addi	sp,sp,64
    800034ce:	8082                	ret
    iput(ip);
    800034d0:	00000097          	auipc	ra,0x0
    800034d4:	a30080e7          	jalr	-1488(ra) # 80002f00 <iput>
    return -1;
    800034d8:	557d                	li	a0,-1
    800034da:	b7dd                	j	800034c0 <dirlink+0x86>
      panic("dirlink read");
    800034dc:	00005517          	auipc	a0,0x5
    800034e0:	0c450513          	addi	a0,a0,196 # 800085a0 <syscalls+0x1d8>
    800034e4:	00003097          	auipc	ra,0x3
    800034e8:	c58080e7          	jalr	-936(ra) # 8000613c <panic>
    panic("dirlink");
    800034ec:	00005517          	auipc	a0,0x5
    800034f0:	1c450513          	addi	a0,a0,452 # 800086b0 <syscalls+0x2e8>
    800034f4:	00003097          	auipc	ra,0x3
    800034f8:	c48080e7          	jalr	-952(ra) # 8000613c <panic>

00000000800034fc <namei>:

struct inode*
namei(char *path)
{
    800034fc:	1101                	addi	sp,sp,-32
    800034fe:	ec06                	sd	ra,24(sp)
    80003500:	e822                	sd	s0,16(sp)
    80003502:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003504:	fe040613          	addi	a2,s0,-32
    80003508:	4581                	li	a1,0
    8000350a:	00000097          	auipc	ra,0x0
    8000350e:	dd0080e7          	jalr	-560(ra) # 800032da <namex>
}
    80003512:	60e2                	ld	ra,24(sp)
    80003514:	6442                	ld	s0,16(sp)
    80003516:	6105                	addi	sp,sp,32
    80003518:	8082                	ret

000000008000351a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000351a:	1141                	addi	sp,sp,-16
    8000351c:	e406                	sd	ra,8(sp)
    8000351e:	e022                	sd	s0,0(sp)
    80003520:	0800                	addi	s0,sp,16
    80003522:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003524:	4585                	li	a1,1
    80003526:	00000097          	auipc	ra,0x0
    8000352a:	db4080e7          	jalr	-588(ra) # 800032da <namex>
}
    8000352e:	60a2                	ld	ra,8(sp)
    80003530:	6402                	ld	s0,0(sp)
    80003532:	0141                	addi	sp,sp,16
    80003534:	8082                	ret

0000000080003536 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003536:	1101                	addi	sp,sp,-32
    80003538:	ec06                	sd	ra,24(sp)
    8000353a:	e822                	sd	s0,16(sp)
    8000353c:	e426                	sd	s1,8(sp)
    8000353e:	e04a                	sd	s2,0(sp)
    80003540:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003542:	0001a917          	auipc	s2,0x1a
    80003546:	75690913          	addi	s2,s2,1878 # 8001dc98 <log>
    8000354a:	02092583          	lw	a1,32(s2)
    8000354e:	03092503          	lw	a0,48(s2)
    80003552:	fffff097          	auipc	ra,0xfffff
    80003556:	ea4080e7          	jalr	-348(ra) # 800023f6 <bread>
    8000355a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000355c:	03492683          	lw	a3,52(s2)
    80003560:	c934                	sw	a3,80(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003562:	02d05763          	blez	a3,80003590 <write_head+0x5a>
    80003566:	0001a797          	auipc	a5,0x1a
    8000356a:	76a78793          	addi	a5,a5,1898 # 8001dcd0 <log+0x38>
    8000356e:	05450713          	addi	a4,a0,84
    80003572:	36fd                	addiw	a3,a3,-1
    80003574:	1682                	slli	a3,a3,0x20
    80003576:	9281                	srli	a3,a3,0x20
    80003578:	068a                	slli	a3,a3,0x2
    8000357a:	0001a617          	auipc	a2,0x1a
    8000357e:	75a60613          	addi	a2,a2,1882 # 8001dcd4 <log+0x3c>
    80003582:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003584:	4390                	lw	a2,0(a5)
    80003586:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003588:	0791                	addi	a5,a5,4
    8000358a:	0711                	addi	a4,a4,4
    8000358c:	fed79ce3          	bne	a5,a3,80003584 <write_head+0x4e>
  }
  bwrite(buf);
    80003590:	8526                	mv	a0,s1
    80003592:	fffff097          	auipc	ra,0xfffff
    80003596:	084080e7          	jalr	132(ra) # 80002616 <bwrite>
  brelse(buf);
    8000359a:	8526                	mv	a0,s1
    8000359c:	fffff097          	auipc	ra,0xfffff
    800035a0:	0b8080e7          	jalr	184(ra) # 80002654 <brelse>
}
    800035a4:	60e2                	ld	ra,24(sp)
    800035a6:	6442                	ld	s0,16(sp)
    800035a8:	64a2                	ld	s1,8(sp)
    800035aa:	6902                	ld	s2,0(sp)
    800035ac:	6105                	addi	sp,sp,32
    800035ae:	8082                	ret

00000000800035b0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035b0:	0001a797          	auipc	a5,0x1a
    800035b4:	71c7a783          	lw	a5,1820(a5) # 8001dccc <log+0x34>
    800035b8:	0af05d63          	blez	a5,80003672 <install_trans+0xc2>
{
    800035bc:	7139                	addi	sp,sp,-64
    800035be:	fc06                	sd	ra,56(sp)
    800035c0:	f822                	sd	s0,48(sp)
    800035c2:	f426                	sd	s1,40(sp)
    800035c4:	f04a                	sd	s2,32(sp)
    800035c6:	ec4e                	sd	s3,24(sp)
    800035c8:	e852                	sd	s4,16(sp)
    800035ca:	e456                	sd	s5,8(sp)
    800035cc:	e05a                	sd	s6,0(sp)
    800035ce:	0080                	addi	s0,sp,64
    800035d0:	8b2a                	mv	s6,a0
    800035d2:	0001aa97          	auipc	s5,0x1a
    800035d6:	6fea8a93          	addi	s5,s5,1790 # 8001dcd0 <log+0x38>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035da:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035dc:	0001a997          	auipc	s3,0x1a
    800035e0:	6bc98993          	addi	s3,s3,1724 # 8001dc98 <log>
    800035e4:	a035                	j	80003610 <install_trans+0x60>
      bunpin(dbuf);
    800035e6:	8526                	mv	a0,s1
    800035e8:	fffff097          	auipc	ra,0xfffff
    800035ec:	14a080e7          	jalr	330(ra) # 80002732 <bunpin>
    brelse(lbuf);
    800035f0:	854a                	mv	a0,s2
    800035f2:	fffff097          	auipc	ra,0xfffff
    800035f6:	062080e7          	jalr	98(ra) # 80002654 <brelse>
    brelse(dbuf);
    800035fa:	8526                	mv	a0,s1
    800035fc:	fffff097          	auipc	ra,0xfffff
    80003600:	058080e7          	jalr	88(ra) # 80002654 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003604:	2a05                	addiw	s4,s4,1
    80003606:	0a91                	addi	s5,s5,4
    80003608:	0349a783          	lw	a5,52(s3)
    8000360c:	04fa5963          	bge	s4,a5,8000365e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003610:	0209a583          	lw	a1,32(s3)
    80003614:	014585bb          	addw	a1,a1,s4
    80003618:	2585                	addiw	a1,a1,1
    8000361a:	0309a503          	lw	a0,48(s3)
    8000361e:	fffff097          	auipc	ra,0xfffff
    80003622:	dd8080e7          	jalr	-552(ra) # 800023f6 <bread>
    80003626:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003628:	000aa583          	lw	a1,0(s5)
    8000362c:	0309a503          	lw	a0,48(s3)
    80003630:	fffff097          	auipc	ra,0xfffff
    80003634:	dc6080e7          	jalr	-570(ra) # 800023f6 <bread>
    80003638:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000363a:	40000613          	li	a2,1024
    8000363e:	05090593          	addi	a1,s2,80
    80003642:	05050513          	addi	a0,a0,80
    80003646:	ffffd097          	auipc	ra,0xffffd
    8000364a:	d0e080e7          	jalr	-754(ra) # 80000354 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000364e:	8526                	mv	a0,s1
    80003650:	fffff097          	auipc	ra,0xfffff
    80003654:	fc6080e7          	jalr	-58(ra) # 80002616 <bwrite>
    if(recovering == 0)
    80003658:	f80b1ce3          	bnez	s6,800035f0 <install_trans+0x40>
    8000365c:	b769                	j	800035e6 <install_trans+0x36>
}
    8000365e:	70e2                	ld	ra,56(sp)
    80003660:	7442                	ld	s0,48(sp)
    80003662:	74a2                	ld	s1,40(sp)
    80003664:	7902                	ld	s2,32(sp)
    80003666:	69e2                	ld	s3,24(sp)
    80003668:	6a42                	ld	s4,16(sp)
    8000366a:	6aa2                	ld	s5,8(sp)
    8000366c:	6b02                	ld	s6,0(sp)
    8000366e:	6121                	addi	sp,sp,64
    80003670:	8082                	ret
    80003672:	8082                	ret

0000000080003674 <initlog>:
{
    80003674:	7179                	addi	sp,sp,-48
    80003676:	f406                	sd	ra,40(sp)
    80003678:	f022                	sd	s0,32(sp)
    8000367a:	ec26                	sd	s1,24(sp)
    8000367c:	e84a                	sd	s2,16(sp)
    8000367e:	e44e                	sd	s3,8(sp)
    80003680:	1800                	addi	s0,sp,48
    80003682:	892a                	mv	s2,a0
    80003684:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003686:	0001a497          	auipc	s1,0x1a
    8000368a:	61248493          	addi	s1,s1,1554 # 8001dc98 <log>
    8000368e:	00005597          	auipc	a1,0x5
    80003692:	f2258593          	addi	a1,a1,-222 # 800085b0 <syscalls+0x1e8>
    80003696:	8526                	mv	a0,s1
    80003698:	00003097          	auipc	ra,0x3
    8000369c:	154080e7          	jalr	340(ra) # 800067ec <initlock>
  log.start = sb->logstart;
    800036a0:	0149a583          	lw	a1,20(s3)
    800036a4:	d08c                	sw	a1,32(s1)
  log.size = sb->nlog;
    800036a6:	0109a783          	lw	a5,16(s3)
    800036aa:	d0dc                	sw	a5,36(s1)
  log.dev = dev;
    800036ac:	0324a823          	sw	s2,48(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036b0:	854a                	mv	a0,s2
    800036b2:	fffff097          	auipc	ra,0xfffff
    800036b6:	d44080e7          	jalr	-700(ra) # 800023f6 <bread>
  log.lh.n = lh->n;
    800036ba:	493c                	lw	a5,80(a0)
    800036bc:	d8dc                	sw	a5,52(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036be:	02f05563          	blez	a5,800036e8 <initlog+0x74>
    800036c2:	05450713          	addi	a4,a0,84
    800036c6:	0001a697          	auipc	a3,0x1a
    800036ca:	60a68693          	addi	a3,a3,1546 # 8001dcd0 <log+0x38>
    800036ce:	37fd                	addiw	a5,a5,-1
    800036d0:	1782                	slli	a5,a5,0x20
    800036d2:	9381                	srli	a5,a5,0x20
    800036d4:	078a                	slli	a5,a5,0x2
    800036d6:	05850613          	addi	a2,a0,88
    800036da:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800036dc:	4310                	lw	a2,0(a4)
    800036de:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800036e0:	0711                	addi	a4,a4,4
    800036e2:	0691                	addi	a3,a3,4
    800036e4:	fef71ce3          	bne	a4,a5,800036dc <initlog+0x68>
  brelse(buf);
    800036e8:	fffff097          	auipc	ra,0xfffff
    800036ec:	f6c080e7          	jalr	-148(ra) # 80002654 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036f0:	4505                	li	a0,1
    800036f2:	00000097          	auipc	ra,0x0
    800036f6:	ebe080e7          	jalr	-322(ra) # 800035b0 <install_trans>
  log.lh.n = 0;
    800036fa:	0001a797          	auipc	a5,0x1a
    800036fe:	5c07a923          	sw	zero,1490(a5) # 8001dccc <log+0x34>
  write_head(); // clear the log
    80003702:	00000097          	auipc	ra,0x0
    80003706:	e34080e7          	jalr	-460(ra) # 80003536 <write_head>
}
    8000370a:	70a2                	ld	ra,40(sp)
    8000370c:	7402                	ld	s0,32(sp)
    8000370e:	64e2                	ld	s1,24(sp)
    80003710:	6942                	ld	s2,16(sp)
    80003712:	69a2                	ld	s3,8(sp)
    80003714:	6145                	addi	sp,sp,48
    80003716:	8082                	ret

0000000080003718 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003718:	1101                	addi	sp,sp,-32
    8000371a:	ec06                	sd	ra,24(sp)
    8000371c:	e822                	sd	s0,16(sp)
    8000371e:	e426                	sd	s1,8(sp)
    80003720:	e04a                	sd	s2,0(sp)
    80003722:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003724:	0001a517          	auipc	a0,0x1a
    80003728:	57450513          	addi	a0,a0,1396 # 8001dc98 <log>
    8000372c:	00003097          	auipc	ra,0x3
    80003730:	f44080e7          	jalr	-188(ra) # 80006670 <acquire>
  while(1){
    if(log.committing){
    80003734:	0001a497          	auipc	s1,0x1a
    80003738:	56448493          	addi	s1,s1,1380 # 8001dc98 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000373c:	4979                	li	s2,30
    8000373e:	a039                	j	8000374c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003740:	85a6                	mv	a1,s1
    80003742:	8526                	mv	a0,s1
    80003744:	ffffe097          	auipc	ra,0xffffe
    80003748:	f4c080e7          	jalr	-180(ra) # 80001690 <sleep>
    if(log.committing){
    8000374c:	54dc                	lw	a5,44(s1)
    8000374e:	fbed                	bnez	a5,80003740 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003750:	549c                	lw	a5,40(s1)
    80003752:	0017871b          	addiw	a4,a5,1
    80003756:	0007069b          	sext.w	a3,a4
    8000375a:	0027179b          	slliw	a5,a4,0x2
    8000375e:	9fb9                	addw	a5,a5,a4
    80003760:	0017979b          	slliw	a5,a5,0x1
    80003764:	58d8                	lw	a4,52(s1)
    80003766:	9fb9                	addw	a5,a5,a4
    80003768:	00f95963          	bge	s2,a5,8000377a <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000376c:	85a6                	mv	a1,s1
    8000376e:	8526                	mv	a0,s1
    80003770:	ffffe097          	auipc	ra,0xffffe
    80003774:	f20080e7          	jalr	-224(ra) # 80001690 <sleep>
    80003778:	bfd1                	j	8000374c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000377a:	0001a517          	auipc	a0,0x1a
    8000377e:	51e50513          	addi	a0,a0,1310 # 8001dc98 <log>
    80003782:	d514                	sw	a3,40(a0)
      release(&log.lock);
    80003784:	00003097          	auipc	ra,0x3
    80003788:	fbc080e7          	jalr	-68(ra) # 80006740 <release>
      break;
    }
  }
}
    8000378c:	60e2                	ld	ra,24(sp)
    8000378e:	6442                	ld	s0,16(sp)
    80003790:	64a2                	ld	s1,8(sp)
    80003792:	6902                	ld	s2,0(sp)
    80003794:	6105                	addi	sp,sp,32
    80003796:	8082                	ret

0000000080003798 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003798:	7139                	addi	sp,sp,-64
    8000379a:	fc06                	sd	ra,56(sp)
    8000379c:	f822                	sd	s0,48(sp)
    8000379e:	f426                	sd	s1,40(sp)
    800037a0:	f04a                	sd	s2,32(sp)
    800037a2:	ec4e                	sd	s3,24(sp)
    800037a4:	e852                	sd	s4,16(sp)
    800037a6:	e456                	sd	s5,8(sp)
    800037a8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037aa:	0001a497          	auipc	s1,0x1a
    800037ae:	4ee48493          	addi	s1,s1,1262 # 8001dc98 <log>
    800037b2:	8526                	mv	a0,s1
    800037b4:	00003097          	auipc	ra,0x3
    800037b8:	ebc080e7          	jalr	-324(ra) # 80006670 <acquire>
  log.outstanding -= 1;
    800037bc:	549c                	lw	a5,40(s1)
    800037be:	37fd                	addiw	a5,a5,-1
    800037c0:	0007891b          	sext.w	s2,a5
    800037c4:	d49c                	sw	a5,40(s1)
  if(log.committing)
    800037c6:	54dc                	lw	a5,44(s1)
    800037c8:	efb9                	bnez	a5,80003826 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037ca:	06091663          	bnez	s2,80003836 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800037ce:	0001a497          	auipc	s1,0x1a
    800037d2:	4ca48493          	addi	s1,s1,1226 # 8001dc98 <log>
    800037d6:	4785                	li	a5,1
    800037d8:	d4dc                	sw	a5,44(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037da:	8526                	mv	a0,s1
    800037dc:	00003097          	auipc	ra,0x3
    800037e0:	f64080e7          	jalr	-156(ra) # 80006740 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037e4:	58dc                	lw	a5,52(s1)
    800037e6:	06f04763          	bgtz	a5,80003854 <end_op+0xbc>
    acquire(&log.lock);
    800037ea:	0001a497          	auipc	s1,0x1a
    800037ee:	4ae48493          	addi	s1,s1,1198 # 8001dc98 <log>
    800037f2:	8526                	mv	a0,s1
    800037f4:	00003097          	auipc	ra,0x3
    800037f8:	e7c080e7          	jalr	-388(ra) # 80006670 <acquire>
    log.committing = 0;
    800037fc:	0204a623          	sw	zero,44(s1)
    wakeup(&log);
    80003800:	8526                	mv	a0,s1
    80003802:	ffffe097          	auipc	ra,0xffffe
    80003806:	01a080e7          	jalr	26(ra) # 8000181c <wakeup>
    release(&log.lock);
    8000380a:	8526                	mv	a0,s1
    8000380c:	00003097          	auipc	ra,0x3
    80003810:	f34080e7          	jalr	-204(ra) # 80006740 <release>
}
    80003814:	70e2                	ld	ra,56(sp)
    80003816:	7442                	ld	s0,48(sp)
    80003818:	74a2                	ld	s1,40(sp)
    8000381a:	7902                	ld	s2,32(sp)
    8000381c:	69e2                	ld	s3,24(sp)
    8000381e:	6a42                	ld	s4,16(sp)
    80003820:	6aa2                	ld	s5,8(sp)
    80003822:	6121                	addi	sp,sp,64
    80003824:	8082                	ret
    panic("log.committing");
    80003826:	00005517          	auipc	a0,0x5
    8000382a:	d9250513          	addi	a0,a0,-622 # 800085b8 <syscalls+0x1f0>
    8000382e:	00003097          	auipc	ra,0x3
    80003832:	90e080e7          	jalr	-1778(ra) # 8000613c <panic>
    wakeup(&log);
    80003836:	0001a497          	auipc	s1,0x1a
    8000383a:	46248493          	addi	s1,s1,1122 # 8001dc98 <log>
    8000383e:	8526                	mv	a0,s1
    80003840:	ffffe097          	auipc	ra,0xffffe
    80003844:	fdc080e7          	jalr	-36(ra) # 8000181c <wakeup>
  release(&log.lock);
    80003848:	8526                	mv	a0,s1
    8000384a:	00003097          	auipc	ra,0x3
    8000384e:	ef6080e7          	jalr	-266(ra) # 80006740 <release>
  if(do_commit){
    80003852:	b7c9                	j	80003814 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003854:	0001aa97          	auipc	s5,0x1a
    80003858:	47ca8a93          	addi	s5,s5,1148 # 8001dcd0 <log+0x38>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000385c:	0001aa17          	auipc	s4,0x1a
    80003860:	43ca0a13          	addi	s4,s4,1084 # 8001dc98 <log>
    80003864:	020a2583          	lw	a1,32(s4)
    80003868:	012585bb          	addw	a1,a1,s2
    8000386c:	2585                	addiw	a1,a1,1
    8000386e:	030a2503          	lw	a0,48(s4)
    80003872:	fffff097          	auipc	ra,0xfffff
    80003876:	b84080e7          	jalr	-1148(ra) # 800023f6 <bread>
    8000387a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000387c:	000aa583          	lw	a1,0(s5)
    80003880:	030a2503          	lw	a0,48(s4)
    80003884:	fffff097          	auipc	ra,0xfffff
    80003888:	b72080e7          	jalr	-1166(ra) # 800023f6 <bread>
    8000388c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000388e:	40000613          	li	a2,1024
    80003892:	05050593          	addi	a1,a0,80
    80003896:	05048513          	addi	a0,s1,80
    8000389a:	ffffd097          	auipc	ra,0xffffd
    8000389e:	aba080e7          	jalr	-1350(ra) # 80000354 <memmove>
    bwrite(to);  // write the log
    800038a2:	8526                	mv	a0,s1
    800038a4:	fffff097          	auipc	ra,0xfffff
    800038a8:	d72080e7          	jalr	-654(ra) # 80002616 <bwrite>
    brelse(from);
    800038ac:	854e                	mv	a0,s3
    800038ae:	fffff097          	auipc	ra,0xfffff
    800038b2:	da6080e7          	jalr	-602(ra) # 80002654 <brelse>
    brelse(to);
    800038b6:	8526                	mv	a0,s1
    800038b8:	fffff097          	auipc	ra,0xfffff
    800038bc:	d9c080e7          	jalr	-612(ra) # 80002654 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038c0:	2905                	addiw	s2,s2,1
    800038c2:	0a91                	addi	s5,s5,4
    800038c4:	034a2783          	lw	a5,52(s4)
    800038c8:	f8f94ee3          	blt	s2,a5,80003864 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038cc:	00000097          	auipc	ra,0x0
    800038d0:	c6a080e7          	jalr	-918(ra) # 80003536 <write_head>
    install_trans(0); // Now install writes to home locations
    800038d4:	4501                	li	a0,0
    800038d6:	00000097          	auipc	ra,0x0
    800038da:	cda080e7          	jalr	-806(ra) # 800035b0 <install_trans>
    log.lh.n = 0;
    800038de:	0001a797          	auipc	a5,0x1a
    800038e2:	3e07a723          	sw	zero,1006(a5) # 8001dccc <log+0x34>
    write_head();    // Erase the transaction from the log
    800038e6:	00000097          	auipc	ra,0x0
    800038ea:	c50080e7          	jalr	-944(ra) # 80003536 <write_head>
    800038ee:	bdf5                	j	800037ea <end_op+0x52>

00000000800038f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038f0:	1101                	addi	sp,sp,-32
    800038f2:	ec06                	sd	ra,24(sp)
    800038f4:	e822                	sd	s0,16(sp)
    800038f6:	e426                	sd	s1,8(sp)
    800038f8:	e04a                	sd	s2,0(sp)
    800038fa:	1000                	addi	s0,sp,32
    800038fc:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038fe:	0001a917          	auipc	s2,0x1a
    80003902:	39a90913          	addi	s2,s2,922 # 8001dc98 <log>
    80003906:	854a                	mv	a0,s2
    80003908:	00003097          	auipc	ra,0x3
    8000390c:	d68080e7          	jalr	-664(ra) # 80006670 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003910:	03492603          	lw	a2,52(s2)
    80003914:	47f5                	li	a5,29
    80003916:	06c7c563          	blt	a5,a2,80003980 <log_write+0x90>
    8000391a:	0001a797          	auipc	a5,0x1a
    8000391e:	3a27a783          	lw	a5,930(a5) # 8001dcbc <log+0x24>
    80003922:	37fd                	addiw	a5,a5,-1
    80003924:	04f65e63          	bge	a2,a5,80003980 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003928:	0001a797          	auipc	a5,0x1a
    8000392c:	3987a783          	lw	a5,920(a5) # 8001dcc0 <log+0x28>
    80003930:	06f05063          	blez	a5,80003990 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003934:	4781                	li	a5,0
    80003936:	06c05563          	blez	a2,800039a0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000393a:	44cc                	lw	a1,12(s1)
    8000393c:	0001a717          	auipc	a4,0x1a
    80003940:	39470713          	addi	a4,a4,916 # 8001dcd0 <log+0x38>
  for (i = 0; i < log.lh.n; i++) {
    80003944:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003946:	4314                	lw	a3,0(a4)
    80003948:	04b68c63          	beq	a3,a1,800039a0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000394c:	2785                	addiw	a5,a5,1
    8000394e:	0711                	addi	a4,a4,4
    80003950:	fef61be3          	bne	a2,a5,80003946 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003954:	0631                	addi	a2,a2,12
    80003956:	060a                	slli	a2,a2,0x2
    80003958:	0001a797          	auipc	a5,0x1a
    8000395c:	34078793          	addi	a5,a5,832 # 8001dc98 <log>
    80003960:	963e                	add	a2,a2,a5
    80003962:	44dc                	lw	a5,12(s1)
    80003964:	c61c                	sw	a5,8(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003966:	8526                	mv	a0,s1
    80003968:	fffff097          	auipc	ra,0xfffff
    8000396c:	d72080e7          	jalr	-654(ra) # 800026da <bpin>
    log.lh.n++;
    80003970:	0001a717          	auipc	a4,0x1a
    80003974:	32870713          	addi	a4,a4,808 # 8001dc98 <log>
    80003978:	5b5c                	lw	a5,52(a4)
    8000397a:	2785                	addiw	a5,a5,1
    8000397c:	db5c                	sw	a5,52(a4)
    8000397e:	a835                	j	800039ba <log_write+0xca>
    panic("too big a transaction");
    80003980:	00005517          	auipc	a0,0x5
    80003984:	c4850513          	addi	a0,a0,-952 # 800085c8 <syscalls+0x200>
    80003988:	00002097          	auipc	ra,0x2
    8000398c:	7b4080e7          	jalr	1972(ra) # 8000613c <panic>
    panic("log_write outside of trans");
    80003990:	00005517          	auipc	a0,0x5
    80003994:	c5050513          	addi	a0,a0,-944 # 800085e0 <syscalls+0x218>
    80003998:	00002097          	auipc	ra,0x2
    8000399c:	7a4080e7          	jalr	1956(ra) # 8000613c <panic>
  log.lh.block[i] = b->blockno;
    800039a0:	00c78713          	addi	a4,a5,12
    800039a4:	00271693          	slli	a3,a4,0x2
    800039a8:	0001a717          	auipc	a4,0x1a
    800039ac:	2f070713          	addi	a4,a4,752 # 8001dc98 <log>
    800039b0:	9736                	add	a4,a4,a3
    800039b2:	44d4                	lw	a3,12(s1)
    800039b4:	c714                	sw	a3,8(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039b6:	faf608e3          	beq	a2,a5,80003966 <log_write+0x76>
  }
  release(&log.lock);
    800039ba:	0001a517          	auipc	a0,0x1a
    800039be:	2de50513          	addi	a0,a0,734 # 8001dc98 <log>
    800039c2:	00003097          	auipc	ra,0x3
    800039c6:	d7e080e7          	jalr	-642(ra) # 80006740 <release>
}
    800039ca:	60e2                	ld	ra,24(sp)
    800039cc:	6442                	ld	s0,16(sp)
    800039ce:	64a2                	ld	s1,8(sp)
    800039d0:	6902                	ld	s2,0(sp)
    800039d2:	6105                	addi	sp,sp,32
    800039d4:	8082                	ret

00000000800039d6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039d6:	1101                	addi	sp,sp,-32
    800039d8:	ec06                	sd	ra,24(sp)
    800039da:	e822                	sd	s0,16(sp)
    800039dc:	e426                	sd	s1,8(sp)
    800039de:	e04a                	sd	s2,0(sp)
    800039e0:	1000                	addi	s0,sp,32
    800039e2:	84aa                	mv	s1,a0
    800039e4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039e6:	00005597          	auipc	a1,0x5
    800039ea:	c1a58593          	addi	a1,a1,-998 # 80008600 <syscalls+0x238>
    800039ee:	0521                	addi	a0,a0,8
    800039f0:	00003097          	auipc	ra,0x3
    800039f4:	dfc080e7          	jalr	-516(ra) # 800067ec <initlock>
  lk->name = name;
    800039f8:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    800039fc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a00:	0204a823          	sw	zero,48(s1)
}
    80003a04:	60e2                	ld	ra,24(sp)
    80003a06:	6442                	ld	s0,16(sp)
    80003a08:	64a2                	ld	s1,8(sp)
    80003a0a:	6902                	ld	s2,0(sp)
    80003a0c:	6105                	addi	sp,sp,32
    80003a0e:	8082                	ret

0000000080003a10 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a10:	1101                	addi	sp,sp,-32
    80003a12:	ec06                	sd	ra,24(sp)
    80003a14:	e822                	sd	s0,16(sp)
    80003a16:	e426                	sd	s1,8(sp)
    80003a18:	e04a                	sd	s2,0(sp)
    80003a1a:	1000                	addi	s0,sp,32
    80003a1c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a1e:	00850913          	addi	s2,a0,8
    80003a22:	854a                	mv	a0,s2
    80003a24:	00003097          	auipc	ra,0x3
    80003a28:	c4c080e7          	jalr	-948(ra) # 80006670 <acquire>
  while (lk->locked) {
    80003a2c:	409c                	lw	a5,0(s1)
    80003a2e:	cb89                	beqz	a5,80003a40 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a30:	85ca                	mv	a1,s2
    80003a32:	8526                	mv	a0,s1
    80003a34:	ffffe097          	auipc	ra,0xffffe
    80003a38:	c5c080e7          	jalr	-932(ra) # 80001690 <sleep>
  while (lk->locked) {
    80003a3c:	409c                	lw	a5,0(s1)
    80003a3e:	fbed                	bnez	a5,80003a30 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a40:	4785                	li	a5,1
    80003a42:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a44:	ffffd097          	auipc	ra,0xffffd
    80003a48:	590080e7          	jalr	1424(ra) # 80000fd4 <myproc>
    80003a4c:	5d1c                	lw	a5,56(a0)
    80003a4e:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    80003a50:	854a                	mv	a0,s2
    80003a52:	00003097          	auipc	ra,0x3
    80003a56:	cee080e7          	jalr	-786(ra) # 80006740 <release>
}
    80003a5a:	60e2                	ld	ra,24(sp)
    80003a5c:	6442                	ld	s0,16(sp)
    80003a5e:	64a2                	ld	s1,8(sp)
    80003a60:	6902                	ld	s2,0(sp)
    80003a62:	6105                	addi	sp,sp,32
    80003a64:	8082                	ret

0000000080003a66 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a66:	1101                	addi	sp,sp,-32
    80003a68:	ec06                	sd	ra,24(sp)
    80003a6a:	e822                	sd	s0,16(sp)
    80003a6c:	e426                	sd	s1,8(sp)
    80003a6e:	e04a                	sd	s2,0(sp)
    80003a70:	1000                	addi	s0,sp,32
    80003a72:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a74:	00850913          	addi	s2,a0,8
    80003a78:	854a                	mv	a0,s2
    80003a7a:	00003097          	auipc	ra,0x3
    80003a7e:	bf6080e7          	jalr	-1034(ra) # 80006670 <acquire>
  lk->locked = 0;
    80003a82:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a86:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    80003a8a:	8526                	mv	a0,s1
    80003a8c:	ffffe097          	auipc	ra,0xffffe
    80003a90:	d90080e7          	jalr	-624(ra) # 8000181c <wakeup>
  release(&lk->lk);
    80003a94:	854a                	mv	a0,s2
    80003a96:	00003097          	auipc	ra,0x3
    80003a9a:	caa080e7          	jalr	-854(ra) # 80006740 <release>
}
    80003a9e:	60e2                	ld	ra,24(sp)
    80003aa0:	6442                	ld	s0,16(sp)
    80003aa2:	64a2                	ld	s1,8(sp)
    80003aa4:	6902                	ld	s2,0(sp)
    80003aa6:	6105                	addi	sp,sp,32
    80003aa8:	8082                	ret

0000000080003aaa <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003aaa:	7179                	addi	sp,sp,-48
    80003aac:	f406                	sd	ra,40(sp)
    80003aae:	f022                	sd	s0,32(sp)
    80003ab0:	ec26                	sd	s1,24(sp)
    80003ab2:	e84a                	sd	s2,16(sp)
    80003ab4:	e44e                	sd	s3,8(sp)
    80003ab6:	1800                	addi	s0,sp,48
    80003ab8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003aba:	00850913          	addi	s2,a0,8
    80003abe:	854a                	mv	a0,s2
    80003ac0:	00003097          	auipc	ra,0x3
    80003ac4:	bb0080e7          	jalr	-1104(ra) # 80006670 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ac8:	409c                	lw	a5,0(s1)
    80003aca:	ef99                	bnez	a5,80003ae8 <holdingsleep+0x3e>
    80003acc:	4481                	li	s1,0
  release(&lk->lk);
    80003ace:	854a                	mv	a0,s2
    80003ad0:	00003097          	auipc	ra,0x3
    80003ad4:	c70080e7          	jalr	-912(ra) # 80006740 <release>
  return r;
}
    80003ad8:	8526                	mv	a0,s1
    80003ada:	70a2                	ld	ra,40(sp)
    80003adc:	7402                	ld	s0,32(sp)
    80003ade:	64e2                	ld	s1,24(sp)
    80003ae0:	6942                	ld	s2,16(sp)
    80003ae2:	69a2                	ld	s3,8(sp)
    80003ae4:	6145                	addi	sp,sp,48
    80003ae6:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ae8:	0304a983          	lw	s3,48(s1)
    80003aec:	ffffd097          	auipc	ra,0xffffd
    80003af0:	4e8080e7          	jalr	1256(ra) # 80000fd4 <myproc>
    80003af4:	5d04                	lw	s1,56(a0)
    80003af6:	413484b3          	sub	s1,s1,s3
    80003afa:	0014b493          	seqz	s1,s1
    80003afe:	bfc1                	j	80003ace <holdingsleep+0x24>

0000000080003b00 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b00:	1141                	addi	sp,sp,-16
    80003b02:	e406                	sd	ra,8(sp)
    80003b04:	e022                	sd	s0,0(sp)
    80003b06:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b08:	00005597          	auipc	a1,0x5
    80003b0c:	b0858593          	addi	a1,a1,-1272 # 80008610 <syscalls+0x248>
    80003b10:	0001a517          	auipc	a0,0x1a
    80003b14:	2d850513          	addi	a0,a0,728 # 8001dde8 <ftable>
    80003b18:	00003097          	auipc	ra,0x3
    80003b1c:	cd4080e7          	jalr	-812(ra) # 800067ec <initlock>
}
    80003b20:	60a2                	ld	ra,8(sp)
    80003b22:	6402                	ld	s0,0(sp)
    80003b24:	0141                	addi	sp,sp,16
    80003b26:	8082                	ret

0000000080003b28 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b28:	1101                	addi	sp,sp,-32
    80003b2a:	ec06                	sd	ra,24(sp)
    80003b2c:	e822                	sd	s0,16(sp)
    80003b2e:	e426                	sd	s1,8(sp)
    80003b30:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b32:	0001a517          	auipc	a0,0x1a
    80003b36:	2b650513          	addi	a0,a0,694 # 8001dde8 <ftable>
    80003b3a:	00003097          	auipc	ra,0x3
    80003b3e:	b36080e7          	jalr	-1226(ra) # 80006670 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b42:	0001a497          	auipc	s1,0x1a
    80003b46:	2c648493          	addi	s1,s1,710 # 8001de08 <ftable+0x20>
    80003b4a:	0001b717          	auipc	a4,0x1b
    80003b4e:	25e70713          	addi	a4,a4,606 # 8001eda8 <ftable+0xfc0>
    if(f->ref == 0){
    80003b52:	40dc                	lw	a5,4(s1)
    80003b54:	cf99                	beqz	a5,80003b72 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b56:	02848493          	addi	s1,s1,40
    80003b5a:	fee49ce3          	bne	s1,a4,80003b52 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b5e:	0001a517          	auipc	a0,0x1a
    80003b62:	28a50513          	addi	a0,a0,650 # 8001dde8 <ftable>
    80003b66:	00003097          	auipc	ra,0x3
    80003b6a:	bda080e7          	jalr	-1062(ra) # 80006740 <release>
  return 0;
    80003b6e:	4481                	li	s1,0
    80003b70:	a819                	j	80003b86 <filealloc+0x5e>
      f->ref = 1;
    80003b72:	4785                	li	a5,1
    80003b74:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b76:	0001a517          	auipc	a0,0x1a
    80003b7a:	27250513          	addi	a0,a0,626 # 8001dde8 <ftable>
    80003b7e:	00003097          	auipc	ra,0x3
    80003b82:	bc2080e7          	jalr	-1086(ra) # 80006740 <release>
}
    80003b86:	8526                	mv	a0,s1
    80003b88:	60e2                	ld	ra,24(sp)
    80003b8a:	6442                	ld	s0,16(sp)
    80003b8c:	64a2                	ld	s1,8(sp)
    80003b8e:	6105                	addi	sp,sp,32
    80003b90:	8082                	ret

0000000080003b92 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b92:	1101                	addi	sp,sp,-32
    80003b94:	ec06                	sd	ra,24(sp)
    80003b96:	e822                	sd	s0,16(sp)
    80003b98:	e426                	sd	s1,8(sp)
    80003b9a:	1000                	addi	s0,sp,32
    80003b9c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b9e:	0001a517          	auipc	a0,0x1a
    80003ba2:	24a50513          	addi	a0,a0,586 # 8001dde8 <ftable>
    80003ba6:	00003097          	auipc	ra,0x3
    80003baa:	aca080e7          	jalr	-1334(ra) # 80006670 <acquire>
  if(f->ref < 1)
    80003bae:	40dc                	lw	a5,4(s1)
    80003bb0:	02f05263          	blez	a5,80003bd4 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003bb4:	2785                	addiw	a5,a5,1
    80003bb6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003bb8:	0001a517          	auipc	a0,0x1a
    80003bbc:	23050513          	addi	a0,a0,560 # 8001dde8 <ftable>
    80003bc0:	00003097          	auipc	ra,0x3
    80003bc4:	b80080e7          	jalr	-1152(ra) # 80006740 <release>
  return f;
}
    80003bc8:	8526                	mv	a0,s1
    80003bca:	60e2                	ld	ra,24(sp)
    80003bcc:	6442                	ld	s0,16(sp)
    80003bce:	64a2                	ld	s1,8(sp)
    80003bd0:	6105                	addi	sp,sp,32
    80003bd2:	8082                	ret
    panic("filedup");
    80003bd4:	00005517          	auipc	a0,0x5
    80003bd8:	a4450513          	addi	a0,a0,-1468 # 80008618 <syscalls+0x250>
    80003bdc:	00002097          	auipc	ra,0x2
    80003be0:	560080e7          	jalr	1376(ra) # 8000613c <panic>

0000000080003be4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003be4:	7139                	addi	sp,sp,-64
    80003be6:	fc06                	sd	ra,56(sp)
    80003be8:	f822                	sd	s0,48(sp)
    80003bea:	f426                	sd	s1,40(sp)
    80003bec:	f04a                	sd	s2,32(sp)
    80003bee:	ec4e                	sd	s3,24(sp)
    80003bf0:	e852                	sd	s4,16(sp)
    80003bf2:	e456                	sd	s5,8(sp)
    80003bf4:	0080                	addi	s0,sp,64
    80003bf6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bf8:	0001a517          	auipc	a0,0x1a
    80003bfc:	1f050513          	addi	a0,a0,496 # 8001dde8 <ftable>
    80003c00:	00003097          	auipc	ra,0x3
    80003c04:	a70080e7          	jalr	-1424(ra) # 80006670 <acquire>
  if(f->ref < 1)
    80003c08:	40dc                	lw	a5,4(s1)
    80003c0a:	06f05163          	blez	a5,80003c6c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c0e:	37fd                	addiw	a5,a5,-1
    80003c10:	0007871b          	sext.w	a4,a5
    80003c14:	c0dc                	sw	a5,4(s1)
    80003c16:	06e04363          	bgtz	a4,80003c7c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c1a:	0004a903          	lw	s2,0(s1)
    80003c1e:	0094ca83          	lbu	s5,9(s1)
    80003c22:	0104ba03          	ld	s4,16(s1)
    80003c26:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c2a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c2e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c32:	0001a517          	auipc	a0,0x1a
    80003c36:	1b650513          	addi	a0,a0,438 # 8001dde8 <ftable>
    80003c3a:	00003097          	auipc	ra,0x3
    80003c3e:	b06080e7          	jalr	-1274(ra) # 80006740 <release>

  if(ff.type == FD_PIPE){
    80003c42:	4785                	li	a5,1
    80003c44:	04f90d63          	beq	s2,a5,80003c9e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c48:	3979                	addiw	s2,s2,-2
    80003c4a:	4785                	li	a5,1
    80003c4c:	0527e063          	bltu	a5,s2,80003c8c <fileclose+0xa8>
    begin_op();
    80003c50:	00000097          	auipc	ra,0x0
    80003c54:	ac8080e7          	jalr	-1336(ra) # 80003718 <begin_op>
    iput(ff.ip);
    80003c58:	854e                	mv	a0,s3
    80003c5a:	fffff097          	auipc	ra,0xfffff
    80003c5e:	2a6080e7          	jalr	678(ra) # 80002f00 <iput>
    end_op();
    80003c62:	00000097          	auipc	ra,0x0
    80003c66:	b36080e7          	jalr	-1226(ra) # 80003798 <end_op>
    80003c6a:	a00d                	j	80003c8c <fileclose+0xa8>
    panic("fileclose");
    80003c6c:	00005517          	auipc	a0,0x5
    80003c70:	9b450513          	addi	a0,a0,-1612 # 80008620 <syscalls+0x258>
    80003c74:	00002097          	auipc	ra,0x2
    80003c78:	4c8080e7          	jalr	1224(ra) # 8000613c <panic>
    release(&ftable.lock);
    80003c7c:	0001a517          	auipc	a0,0x1a
    80003c80:	16c50513          	addi	a0,a0,364 # 8001dde8 <ftable>
    80003c84:	00003097          	auipc	ra,0x3
    80003c88:	abc080e7          	jalr	-1348(ra) # 80006740 <release>
  }
}
    80003c8c:	70e2                	ld	ra,56(sp)
    80003c8e:	7442                	ld	s0,48(sp)
    80003c90:	74a2                	ld	s1,40(sp)
    80003c92:	7902                	ld	s2,32(sp)
    80003c94:	69e2                	ld	s3,24(sp)
    80003c96:	6a42                	ld	s4,16(sp)
    80003c98:	6aa2                	ld	s5,8(sp)
    80003c9a:	6121                	addi	sp,sp,64
    80003c9c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c9e:	85d6                	mv	a1,s5
    80003ca0:	8552                	mv	a0,s4
    80003ca2:	00000097          	auipc	ra,0x0
    80003ca6:	34c080e7          	jalr	844(ra) # 80003fee <pipeclose>
    80003caa:	b7cd                	j	80003c8c <fileclose+0xa8>

0000000080003cac <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003cac:	715d                	addi	sp,sp,-80
    80003cae:	e486                	sd	ra,72(sp)
    80003cb0:	e0a2                	sd	s0,64(sp)
    80003cb2:	fc26                	sd	s1,56(sp)
    80003cb4:	f84a                	sd	s2,48(sp)
    80003cb6:	f44e                	sd	s3,40(sp)
    80003cb8:	0880                	addi	s0,sp,80
    80003cba:	84aa                	mv	s1,a0
    80003cbc:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003cbe:	ffffd097          	auipc	ra,0xffffd
    80003cc2:	316080e7          	jalr	790(ra) # 80000fd4 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003cc6:	409c                	lw	a5,0(s1)
    80003cc8:	37f9                	addiw	a5,a5,-2
    80003cca:	4705                	li	a4,1
    80003ccc:	04f76763          	bltu	a4,a5,80003d1a <filestat+0x6e>
    80003cd0:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cd2:	6c88                	ld	a0,24(s1)
    80003cd4:	fffff097          	auipc	ra,0xfffff
    80003cd8:	072080e7          	jalr	114(ra) # 80002d46 <ilock>
    stati(f->ip, &st);
    80003cdc:	fb840593          	addi	a1,s0,-72
    80003ce0:	6c88                	ld	a0,24(s1)
    80003ce2:	fffff097          	auipc	ra,0xfffff
    80003ce6:	2ee080e7          	jalr	750(ra) # 80002fd0 <stati>
    iunlock(f->ip);
    80003cea:	6c88                	ld	a0,24(s1)
    80003cec:	fffff097          	auipc	ra,0xfffff
    80003cf0:	11c080e7          	jalr	284(ra) # 80002e08 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cf4:	46e1                	li	a3,24
    80003cf6:	fb840613          	addi	a2,s0,-72
    80003cfa:	85ce                	mv	a1,s3
    80003cfc:	05893503          	ld	a0,88(s2)
    80003d00:	ffffd097          	auipc	ra,0xffffd
    80003d04:	f96080e7          	jalr	-106(ra) # 80000c96 <copyout>
    80003d08:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d0c:	60a6                	ld	ra,72(sp)
    80003d0e:	6406                	ld	s0,64(sp)
    80003d10:	74e2                	ld	s1,56(sp)
    80003d12:	7942                	ld	s2,48(sp)
    80003d14:	79a2                	ld	s3,40(sp)
    80003d16:	6161                	addi	sp,sp,80
    80003d18:	8082                	ret
  return -1;
    80003d1a:	557d                	li	a0,-1
    80003d1c:	bfc5                	j	80003d0c <filestat+0x60>

0000000080003d1e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d1e:	7179                	addi	sp,sp,-48
    80003d20:	f406                	sd	ra,40(sp)
    80003d22:	f022                	sd	s0,32(sp)
    80003d24:	ec26                	sd	s1,24(sp)
    80003d26:	e84a                	sd	s2,16(sp)
    80003d28:	e44e                	sd	s3,8(sp)
    80003d2a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d2c:	00854783          	lbu	a5,8(a0)
    80003d30:	c3d5                	beqz	a5,80003dd4 <fileread+0xb6>
    80003d32:	84aa                	mv	s1,a0
    80003d34:	89ae                	mv	s3,a1
    80003d36:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d38:	411c                	lw	a5,0(a0)
    80003d3a:	4705                	li	a4,1
    80003d3c:	04e78963          	beq	a5,a4,80003d8e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d40:	470d                	li	a4,3
    80003d42:	04e78d63          	beq	a5,a4,80003d9c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d46:	4709                	li	a4,2
    80003d48:	06e79e63          	bne	a5,a4,80003dc4 <fileread+0xa6>
    ilock(f->ip);
    80003d4c:	6d08                	ld	a0,24(a0)
    80003d4e:	fffff097          	auipc	ra,0xfffff
    80003d52:	ff8080e7          	jalr	-8(ra) # 80002d46 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d56:	874a                	mv	a4,s2
    80003d58:	5094                	lw	a3,32(s1)
    80003d5a:	864e                	mv	a2,s3
    80003d5c:	4585                	li	a1,1
    80003d5e:	6c88                	ld	a0,24(s1)
    80003d60:	fffff097          	auipc	ra,0xfffff
    80003d64:	29a080e7          	jalr	666(ra) # 80002ffa <readi>
    80003d68:	892a                	mv	s2,a0
    80003d6a:	00a05563          	blez	a0,80003d74 <fileread+0x56>
      f->off += r;
    80003d6e:	509c                	lw	a5,32(s1)
    80003d70:	9fa9                	addw	a5,a5,a0
    80003d72:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d74:	6c88                	ld	a0,24(s1)
    80003d76:	fffff097          	auipc	ra,0xfffff
    80003d7a:	092080e7          	jalr	146(ra) # 80002e08 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d7e:	854a                	mv	a0,s2
    80003d80:	70a2                	ld	ra,40(sp)
    80003d82:	7402                	ld	s0,32(sp)
    80003d84:	64e2                	ld	s1,24(sp)
    80003d86:	6942                	ld	s2,16(sp)
    80003d88:	69a2                	ld	s3,8(sp)
    80003d8a:	6145                	addi	sp,sp,48
    80003d8c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d8e:	6908                	ld	a0,16(a0)
    80003d90:	00000097          	auipc	ra,0x0
    80003d94:	3d2080e7          	jalr	978(ra) # 80004162 <piperead>
    80003d98:	892a                	mv	s2,a0
    80003d9a:	b7d5                	j	80003d7e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d9c:	02451783          	lh	a5,36(a0)
    80003da0:	03079693          	slli	a3,a5,0x30
    80003da4:	92c1                	srli	a3,a3,0x30
    80003da6:	4725                	li	a4,9
    80003da8:	02d76863          	bltu	a4,a3,80003dd8 <fileread+0xba>
    80003dac:	0792                	slli	a5,a5,0x4
    80003dae:	0001a717          	auipc	a4,0x1a
    80003db2:	f9a70713          	addi	a4,a4,-102 # 8001dd48 <devsw>
    80003db6:	97ba                	add	a5,a5,a4
    80003db8:	639c                	ld	a5,0(a5)
    80003dba:	c38d                	beqz	a5,80003ddc <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003dbc:	4505                	li	a0,1
    80003dbe:	9782                	jalr	a5
    80003dc0:	892a                	mv	s2,a0
    80003dc2:	bf75                	j	80003d7e <fileread+0x60>
    panic("fileread");
    80003dc4:	00005517          	auipc	a0,0x5
    80003dc8:	86c50513          	addi	a0,a0,-1940 # 80008630 <syscalls+0x268>
    80003dcc:	00002097          	auipc	ra,0x2
    80003dd0:	370080e7          	jalr	880(ra) # 8000613c <panic>
    return -1;
    80003dd4:	597d                	li	s2,-1
    80003dd6:	b765                	j	80003d7e <fileread+0x60>
      return -1;
    80003dd8:	597d                	li	s2,-1
    80003dda:	b755                	j	80003d7e <fileread+0x60>
    80003ddc:	597d                	li	s2,-1
    80003dde:	b745                	j	80003d7e <fileread+0x60>

0000000080003de0 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003de0:	715d                	addi	sp,sp,-80
    80003de2:	e486                	sd	ra,72(sp)
    80003de4:	e0a2                	sd	s0,64(sp)
    80003de6:	fc26                	sd	s1,56(sp)
    80003de8:	f84a                	sd	s2,48(sp)
    80003dea:	f44e                	sd	s3,40(sp)
    80003dec:	f052                	sd	s4,32(sp)
    80003dee:	ec56                	sd	s5,24(sp)
    80003df0:	e85a                	sd	s6,16(sp)
    80003df2:	e45e                	sd	s7,8(sp)
    80003df4:	e062                	sd	s8,0(sp)
    80003df6:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003df8:	00954783          	lbu	a5,9(a0)
    80003dfc:	10078663          	beqz	a5,80003f08 <filewrite+0x128>
    80003e00:	892a                	mv	s2,a0
    80003e02:	8aae                	mv	s5,a1
    80003e04:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e06:	411c                	lw	a5,0(a0)
    80003e08:	4705                	li	a4,1
    80003e0a:	02e78263          	beq	a5,a4,80003e2e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e0e:	470d                	li	a4,3
    80003e10:	02e78663          	beq	a5,a4,80003e3c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e14:	4709                	li	a4,2
    80003e16:	0ee79163          	bne	a5,a4,80003ef8 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e1a:	0ac05d63          	blez	a2,80003ed4 <filewrite+0xf4>
    int i = 0;
    80003e1e:	4981                	li	s3,0
    80003e20:	6b05                	lui	s6,0x1
    80003e22:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003e26:	6b85                	lui	s7,0x1
    80003e28:	c00b8b9b          	addiw	s7,s7,-1024
    80003e2c:	a861                	j	80003ec4 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e2e:	6908                	ld	a0,16(a0)
    80003e30:	00000097          	auipc	ra,0x0
    80003e34:	238080e7          	jalr	568(ra) # 80004068 <pipewrite>
    80003e38:	8a2a                	mv	s4,a0
    80003e3a:	a045                	j	80003eda <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e3c:	02451783          	lh	a5,36(a0)
    80003e40:	03079693          	slli	a3,a5,0x30
    80003e44:	92c1                	srli	a3,a3,0x30
    80003e46:	4725                	li	a4,9
    80003e48:	0cd76263          	bltu	a4,a3,80003f0c <filewrite+0x12c>
    80003e4c:	0792                	slli	a5,a5,0x4
    80003e4e:	0001a717          	auipc	a4,0x1a
    80003e52:	efa70713          	addi	a4,a4,-262 # 8001dd48 <devsw>
    80003e56:	97ba                	add	a5,a5,a4
    80003e58:	679c                	ld	a5,8(a5)
    80003e5a:	cbdd                	beqz	a5,80003f10 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e5c:	4505                	li	a0,1
    80003e5e:	9782                	jalr	a5
    80003e60:	8a2a                	mv	s4,a0
    80003e62:	a8a5                	j	80003eda <filewrite+0xfa>
    80003e64:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e68:	00000097          	auipc	ra,0x0
    80003e6c:	8b0080e7          	jalr	-1872(ra) # 80003718 <begin_op>
      ilock(f->ip);
    80003e70:	01893503          	ld	a0,24(s2)
    80003e74:	fffff097          	auipc	ra,0xfffff
    80003e78:	ed2080e7          	jalr	-302(ra) # 80002d46 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e7c:	8762                	mv	a4,s8
    80003e7e:	02092683          	lw	a3,32(s2)
    80003e82:	01598633          	add	a2,s3,s5
    80003e86:	4585                	li	a1,1
    80003e88:	01893503          	ld	a0,24(s2)
    80003e8c:	fffff097          	auipc	ra,0xfffff
    80003e90:	266080e7          	jalr	614(ra) # 800030f2 <writei>
    80003e94:	84aa                	mv	s1,a0
    80003e96:	00a05763          	blez	a0,80003ea4 <filewrite+0xc4>
        f->off += r;
    80003e9a:	02092783          	lw	a5,32(s2)
    80003e9e:	9fa9                	addw	a5,a5,a0
    80003ea0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ea4:	01893503          	ld	a0,24(s2)
    80003ea8:	fffff097          	auipc	ra,0xfffff
    80003eac:	f60080e7          	jalr	-160(ra) # 80002e08 <iunlock>
      end_op();
    80003eb0:	00000097          	auipc	ra,0x0
    80003eb4:	8e8080e7          	jalr	-1816(ra) # 80003798 <end_op>

      if(r != n1){
    80003eb8:	009c1f63          	bne	s8,s1,80003ed6 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ebc:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ec0:	0149db63          	bge	s3,s4,80003ed6 <filewrite+0xf6>
      int n1 = n - i;
    80003ec4:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003ec8:	84be                	mv	s1,a5
    80003eca:	2781                	sext.w	a5,a5
    80003ecc:	f8fb5ce3          	bge	s6,a5,80003e64 <filewrite+0x84>
    80003ed0:	84de                	mv	s1,s7
    80003ed2:	bf49                	j	80003e64 <filewrite+0x84>
    int i = 0;
    80003ed4:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003ed6:	013a1f63          	bne	s4,s3,80003ef4 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003eda:	8552                	mv	a0,s4
    80003edc:	60a6                	ld	ra,72(sp)
    80003ede:	6406                	ld	s0,64(sp)
    80003ee0:	74e2                	ld	s1,56(sp)
    80003ee2:	7942                	ld	s2,48(sp)
    80003ee4:	79a2                	ld	s3,40(sp)
    80003ee6:	7a02                	ld	s4,32(sp)
    80003ee8:	6ae2                	ld	s5,24(sp)
    80003eea:	6b42                	ld	s6,16(sp)
    80003eec:	6ba2                	ld	s7,8(sp)
    80003eee:	6c02                	ld	s8,0(sp)
    80003ef0:	6161                	addi	sp,sp,80
    80003ef2:	8082                	ret
    ret = (i == n ? n : -1);
    80003ef4:	5a7d                	li	s4,-1
    80003ef6:	b7d5                	j	80003eda <filewrite+0xfa>
    panic("filewrite");
    80003ef8:	00004517          	auipc	a0,0x4
    80003efc:	74850513          	addi	a0,a0,1864 # 80008640 <syscalls+0x278>
    80003f00:	00002097          	auipc	ra,0x2
    80003f04:	23c080e7          	jalr	572(ra) # 8000613c <panic>
    return -1;
    80003f08:	5a7d                	li	s4,-1
    80003f0a:	bfc1                	j	80003eda <filewrite+0xfa>
      return -1;
    80003f0c:	5a7d                	li	s4,-1
    80003f0e:	b7f1                	j	80003eda <filewrite+0xfa>
    80003f10:	5a7d                	li	s4,-1
    80003f12:	b7e1                	j	80003eda <filewrite+0xfa>

0000000080003f14 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f14:	7179                	addi	sp,sp,-48
    80003f16:	f406                	sd	ra,40(sp)
    80003f18:	f022                	sd	s0,32(sp)
    80003f1a:	ec26                	sd	s1,24(sp)
    80003f1c:	e84a                	sd	s2,16(sp)
    80003f1e:	e44e                	sd	s3,8(sp)
    80003f20:	e052                	sd	s4,0(sp)
    80003f22:	1800                	addi	s0,sp,48
    80003f24:	84aa                	mv	s1,a0
    80003f26:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f28:	0005b023          	sd	zero,0(a1)
    80003f2c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f30:	00000097          	auipc	ra,0x0
    80003f34:	bf8080e7          	jalr	-1032(ra) # 80003b28 <filealloc>
    80003f38:	e088                	sd	a0,0(s1)
    80003f3a:	c551                	beqz	a0,80003fc6 <pipealloc+0xb2>
    80003f3c:	00000097          	auipc	ra,0x0
    80003f40:	bec080e7          	jalr	-1044(ra) # 80003b28 <filealloc>
    80003f44:	00aa3023          	sd	a0,0(s4)
    80003f48:	c92d                	beqz	a0,80003fba <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f4a:	ffffc097          	auipc	ra,0xffffc
    80003f4e:	2aa080e7          	jalr	682(ra) # 800001f4 <kalloc>
    80003f52:	892a                	mv	s2,a0
    80003f54:	c125                	beqz	a0,80003fb4 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f56:	4985                	li	s3,1
    80003f58:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    80003f5c:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80003f60:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80003f64:	22052023          	sw	zero,544(a0)
  initlock(&pi->lock, "pipe");
    80003f68:	00004597          	auipc	a1,0x4
    80003f6c:	6e858593          	addi	a1,a1,1768 # 80008650 <syscalls+0x288>
    80003f70:	00003097          	auipc	ra,0x3
    80003f74:	87c080e7          	jalr	-1924(ra) # 800067ec <initlock>
  (*f0)->type = FD_PIPE;
    80003f78:	609c                	ld	a5,0(s1)
    80003f7a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f7e:	609c                	ld	a5,0(s1)
    80003f80:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f84:	609c                	ld	a5,0(s1)
    80003f86:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f8a:	609c                	ld	a5,0(s1)
    80003f8c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f90:	000a3783          	ld	a5,0(s4)
    80003f94:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f98:	000a3783          	ld	a5,0(s4)
    80003f9c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003fa0:	000a3783          	ld	a5,0(s4)
    80003fa4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003fa8:	000a3783          	ld	a5,0(s4)
    80003fac:	0127b823          	sd	s2,16(a5)
  return 0;
    80003fb0:	4501                	li	a0,0
    80003fb2:	a025                	j	80003fda <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fb4:	6088                	ld	a0,0(s1)
    80003fb6:	e501                	bnez	a0,80003fbe <pipealloc+0xaa>
    80003fb8:	a039                	j	80003fc6 <pipealloc+0xb2>
    80003fba:	6088                	ld	a0,0(s1)
    80003fbc:	c51d                	beqz	a0,80003fea <pipealloc+0xd6>
    fileclose(*f0);
    80003fbe:	00000097          	auipc	ra,0x0
    80003fc2:	c26080e7          	jalr	-986(ra) # 80003be4 <fileclose>
  if(*f1)
    80003fc6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fca:	557d                	li	a0,-1
  if(*f1)
    80003fcc:	c799                	beqz	a5,80003fda <pipealloc+0xc6>
    fileclose(*f1);
    80003fce:	853e                	mv	a0,a5
    80003fd0:	00000097          	auipc	ra,0x0
    80003fd4:	c14080e7          	jalr	-1004(ra) # 80003be4 <fileclose>
  return -1;
    80003fd8:	557d                	li	a0,-1
}
    80003fda:	70a2                	ld	ra,40(sp)
    80003fdc:	7402                	ld	s0,32(sp)
    80003fde:	64e2                	ld	s1,24(sp)
    80003fe0:	6942                	ld	s2,16(sp)
    80003fe2:	69a2                	ld	s3,8(sp)
    80003fe4:	6a02                	ld	s4,0(sp)
    80003fe6:	6145                	addi	sp,sp,48
    80003fe8:	8082                	ret
  return -1;
    80003fea:	557d                	li	a0,-1
    80003fec:	b7fd                	j	80003fda <pipealloc+0xc6>

0000000080003fee <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fee:	1101                	addi	sp,sp,-32
    80003ff0:	ec06                	sd	ra,24(sp)
    80003ff2:	e822                	sd	s0,16(sp)
    80003ff4:	e426                	sd	s1,8(sp)
    80003ff6:	e04a                	sd	s2,0(sp)
    80003ff8:	1000                	addi	s0,sp,32
    80003ffa:	84aa                	mv	s1,a0
    80003ffc:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ffe:	00002097          	auipc	ra,0x2
    80004002:	672080e7          	jalr	1650(ra) # 80006670 <acquire>
  if(writable){
    80004006:	04090263          	beqz	s2,8000404a <pipeclose+0x5c>
    pi->writeopen = 0;
    8000400a:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    8000400e:	22048513          	addi	a0,s1,544
    80004012:	ffffe097          	auipc	ra,0xffffe
    80004016:	80a080e7          	jalr	-2038(ra) # 8000181c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000401a:	2284b783          	ld	a5,552(s1)
    8000401e:	ef9d                	bnez	a5,8000405c <pipeclose+0x6e>
    release(&pi->lock);
    80004020:	8526                	mv	a0,s1
    80004022:	00002097          	auipc	ra,0x2
    80004026:	71e080e7          	jalr	1822(ra) # 80006740 <release>
#ifdef LAB_LOCK
    freelock(&pi->lock);
    8000402a:	8526                	mv	a0,s1
    8000402c:	00002097          	auipc	ra,0x2
    80004030:	75c080e7          	jalr	1884(ra) # 80006788 <freelock>
#endif    
    kfree((char*)pi);
    80004034:	8526                	mv	a0,s1
    80004036:	ffffc097          	auipc	ra,0xffffc
    8000403a:	0de080e7          	jalr	222(ra) # 80000114 <kfree>
  } else
    release(&pi->lock);
}
    8000403e:	60e2                	ld	ra,24(sp)
    80004040:	6442                	ld	s0,16(sp)
    80004042:	64a2                	ld	s1,8(sp)
    80004044:	6902                	ld	s2,0(sp)
    80004046:	6105                	addi	sp,sp,32
    80004048:	8082                	ret
    pi->readopen = 0;
    8000404a:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    8000404e:	22448513          	addi	a0,s1,548
    80004052:	ffffd097          	auipc	ra,0xffffd
    80004056:	7ca080e7          	jalr	1994(ra) # 8000181c <wakeup>
    8000405a:	b7c1                	j	8000401a <pipeclose+0x2c>
    release(&pi->lock);
    8000405c:	8526                	mv	a0,s1
    8000405e:	00002097          	auipc	ra,0x2
    80004062:	6e2080e7          	jalr	1762(ra) # 80006740 <release>
}
    80004066:	bfe1                	j	8000403e <pipeclose+0x50>

0000000080004068 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004068:	7159                	addi	sp,sp,-112
    8000406a:	f486                	sd	ra,104(sp)
    8000406c:	f0a2                	sd	s0,96(sp)
    8000406e:	eca6                	sd	s1,88(sp)
    80004070:	e8ca                	sd	s2,80(sp)
    80004072:	e4ce                	sd	s3,72(sp)
    80004074:	e0d2                	sd	s4,64(sp)
    80004076:	fc56                	sd	s5,56(sp)
    80004078:	f85a                	sd	s6,48(sp)
    8000407a:	f45e                	sd	s7,40(sp)
    8000407c:	f062                	sd	s8,32(sp)
    8000407e:	ec66                	sd	s9,24(sp)
    80004080:	1880                	addi	s0,sp,112
    80004082:	84aa                	mv	s1,a0
    80004084:	8aae                	mv	s5,a1
    80004086:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004088:	ffffd097          	auipc	ra,0xffffd
    8000408c:	f4c080e7          	jalr	-180(ra) # 80000fd4 <myproc>
    80004090:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004092:	8526                	mv	a0,s1
    80004094:	00002097          	auipc	ra,0x2
    80004098:	5dc080e7          	jalr	1500(ra) # 80006670 <acquire>
  while(i < n){
    8000409c:	0d405163          	blez	s4,8000415e <pipewrite+0xf6>
    800040a0:	8ba6                	mv	s7,s1
  int i = 0;
    800040a2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040a4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040a6:	22048c93          	addi	s9,s1,544
      sleep(&pi->nwrite, &pi->lock);
    800040aa:	22448c13          	addi	s8,s1,548
    800040ae:	a08d                	j	80004110 <pipewrite+0xa8>
      release(&pi->lock);
    800040b0:	8526                	mv	a0,s1
    800040b2:	00002097          	auipc	ra,0x2
    800040b6:	68e080e7          	jalr	1678(ra) # 80006740 <release>
      return -1;
    800040ba:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040bc:	854a                	mv	a0,s2
    800040be:	70a6                	ld	ra,104(sp)
    800040c0:	7406                	ld	s0,96(sp)
    800040c2:	64e6                	ld	s1,88(sp)
    800040c4:	6946                	ld	s2,80(sp)
    800040c6:	69a6                	ld	s3,72(sp)
    800040c8:	6a06                	ld	s4,64(sp)
    800040ca:	7ae2                	ld	s5,56(sp)
    800040cc:	7b42                	ld	s6,48(sp)
    800040ce:	7ba2                	ld	s7,40(sp)
    800040d0:	7c02                	ld	s8,32(sp)
    800040d2:	6ce2                	ld	s9,24(sp)
    800040d4:	6165                	addi	sp,sp,112
    800040d6:	8082                	ret
      wakeup(&pi->nread);
    800040d8:	8566                	mv	a0,s9
    800040da:	ffffd097          	auipc	ra,0xffffd
    800040de:	742080e7          	jalr	1858(ra) # 8000181c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040e2:	85de                	mv	a1,s7
    800040e4:	8562                	mv	a0,s8
    800040e6:	ffffd097          	auipc	ra,0xffffd
    800040ea:	5aa080e7          	jalr	1450(ra) # 80001690 <sleep>
    800040ee:	a839                	j	8000410c <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040f0:	2244a783          	lw	a5,548(s1)
    800040f4:	0017871b          	addiw	a4,a5,1
    800040f8:	22e4a223          	sw	a4,548(s1)
    800040fc:	1ff7f793          	andi	a5,a5,511
    80004100:	97a6                	add	a5,a5,s1
    80004102:	f9f44703          	lbu	a4,-97(s0)
    80004106:	02e78023          	sb	a4,32(a5)
      i++;
    8000410a:	2905                	addiw	s2,s2,1
  while(i < n){
    8000410c:	03495d63          	bge	s2,s4,80004146 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80004110:	2284a783          	lw	a5,552(s1)
    80004114:	dfd1                	beqz	a5,800040b0 <pipewrite+0x48>
    80004116:	0309a783          	lw	a5,48(s3)
    8000411a:	fbd9                	bnez	a5,800040b0 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000411c:	2204a783          	lw	a5,544(s1)
    80004120:	2244a703          	lw	a4,548(s1)
    80004124:	2007879b          	addiw	a5,a5,512
    80004128:	faf708e3          	beq	a4,a5,800040d8 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000412c:	4685                	li	a3,1
    8000412e:	01590633          	add	a2,s2,s5
    80004132:	f9f40593          	addi	a1,s0,-97
    80004136:	0589b503          	ld	a0,88(s3)
    8000413a:	ffffd097          	auipc	ra,0xffffd
    8000413e:	be8080e7          	jalr	-1048(ra) # 80000d22 <copyin>
    80004142:	fb6517e3          	bne	a0,s6,800040f0 <pipewrite+0x88>
  wakeup(&pi->nread);
    80004146:	22048513          	addi	a0,s1,544
    8000414a:	ffffd097          	auipc	ra,0xffffd
    8000414e:	6d2080e7          	jalr	1746(ra) # 8000181c <wakeup>
  release(&pi->lock);
    80004152:	8526                	mv	a0,s1
    80004154:	00002097          	auipc	ra,0x2
    80004158:	5ec080e7          	jalr	1516(ra) # 80006740 <release>
  return i;
    8000415c:	b785                	j	800040bc <pipewrite+0x54>
  int i = 0;
    8000415e:	4901                	li	s2,0
    80004160:	b7dd                	j	80004146 <pipewrite+0xde>

0000000080004162 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004162:	715d                	addi	sp,sp,-80
    80004164:	e486                	sd	ra,72(sp)
    80004166:	e0a2                	sd	s0,64(sp)
    80004168:	fc26                	sd	s1,56(sp)
    8000416a:	f84a                	sd	s2,48(sp)
    8000416c:	f44e                	sd	s3,40(sp)
    8000416e:	f052                	sd	s4,32(sp)
    80004170:	ec56                	sd	s5,24(sp)
    80004172:	e85a                	sd	s6,16(sp)
    80004174:	0880                	addi	s0,sp,80
    80004176:	84aa                	mv	s1,a0
    80004178:	892e                	mv	s2,a1
    8000417a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000417c:	ffffd097          	auipc	ra,0xffffd
    80004180:	e58080e7          	jalr	-424(ra) # 80000fd4 <myproc>
    80004184:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004186:	8b26                	mv	s6,s1
    80004188:	8526                	mv	a0,s1
    8000418a:	00002097          	auipc	ra,0x2
    8000418e:	4e6080e7          	jalr	1254(ra) # 80006670 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004192:	2204a703          	lw	a4,544(s1)
    80004196:	2244a783          	lw	a5,548(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000419a:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000419e:	02f71463          	bne	a4,a5,800041c6 <piperead+0x64>
    800041a2:	22c4a783          	lw	a5,556(s1)
    800041a6:	c385                	beqz	a5,800041c6 <piperead+0x64>
    if(pr->killed){
    800041a8:	030a2783          	lw	a5,48(s4)
    800041ac:	ebc1                	bnez	a5,8000423c <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041ae:	85da                	mv	a1,s6
    800041b0:	854e                	mv	a0,s3
    800041b2:	ffffd097          	auipc	ra,0xffffd
    800041b6:	4de080e7          	jalr	1246(ra) # 80001690 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041ba:	2204a703          	lw	a4,544(s1)
    800041be:	2244a783          	lw	a5,548(s1)
    800041c2:	fef700e3          	beq	a4,a5,800041a2 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041c6:	09505263          	blez	s5,8000424a <piperead+0xe8>
    800041ca:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041cc:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800041ce:	2204a783          	lw	a5,544(s1)
    800041d2:	2244a703          	lw	a4,548(s1)
    800041d6:	02f70d63          	beq	a4,a5,80004210 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041da:	0017871b          	addiw	a4,a5,1
    800041de:	22e4a023          	sw	a4,544(s1)
    800041e2:	1ff7f793          	andi	a5,a5,511
    800041e6:	97a6                	add	a5,a5,s1
    800041e8:	0207c783          	lbu	a5,32(a5)
    800041ec:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041f0:	4685                	li	a3,1
    800041f2:	fbf40613          	addi	a2,s0,-65
    800041f6:	85ca                	mv	a1,s2
    800041f8:	058a3503          	ld	a0,88(s4)
    800041fc:	ffffd097          	auipc	ra,0xffffd
    80004200:	a9a080e7          	jalr	-1382(ra) # 80000c96 <copyout>
    80004204:	01650663          	beq	a0,s6,80004210 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004208:	2985                	addiw	s3,s3,1
    8000420a:	0905                	addi	s2,s2,1
    8000420c:	fd3a91e3          	bne	s5,s3,800041ce <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004210:	22448513          	addi	a0,s1,548
    80004214:	ffffd097          	auipc	ra,0xffffd
    80004218:	608080e7          	jalr	1544(ra) # 8000181c <wakeup>
  release(&pi->lock);
    8000421c:	8526                	mv	a0,s1
    8000421e:	00002097          	auipc	ra,0x2
    80004222:	522080e7          	jalr	1314(ra) # 80006740 <release>
  return i;
}
    80004226:	854e                	mv	a0,s3
    80004228:	60a6                	ld	ra,72(sp)
    8000422a:	6406                	ld	s0,64(sp)
    8000422c:	74e2                	ld	s1,56(sp)
    8000422e:	7942                	ld	s2,48(sp)
    80004230:	79a2                	ld	s3,40(sp)
    80004232:	7a02                	ld	s4,32(sp)
    80004234:	6ae2                	ld	s5,24(sp)
    80004236:	6b42                	ld	s6,16(sp)
    80004238:	6161                	addi	sp,sp,80
    8000423a:	8082                	ret
      release(&pi->lock);
    8000423c:	8526                	mv	a0,s1
    8000423e:	00002097          	auipc	ra,0x2
    80004242:	502080e7          	jalr	1282(ra) # 80006740 <release>
      return -1;
    80004246:	59fd                	li	s3,-1
    80004248:	bff9                	j	80004226 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000424a:	4981                	li	s3,0
    8000424c:	b7d1                	j	80004210 <piperead+0xae>

000000008000424e <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000424e:	df010113          	addi	sp,sp,-528
    80004252:	20113423          	sd	ra,520(sp)
    80004256:	20813023          	sd	s0,512(sp)
    8000425a:	ffa6                	sd	s1,504(sp)
    8000425c:	fbca                	sd	s2,496(sp)
    8000425e:	f7ce                	sd	s3,488(sp)
    80004260:	f3d2                	sd	s4,480(sp)
    80004262:	efd6                	sd	s5,472(sp)
    80004264:	ebda                	sd	s6,464(sp)
    80004266:	e7de                	sd	s7,456(sp)
    80004268:	e3e2                	sd	s8,448(sp)
    8000426a:	ff66                	sd	s9,440(sp)
    8000426c:	fb6a                	sd	s10,432(sp)
    8000426e:	f76e                	sd	s11,424(sp)
    80004270:	0c00                	addi	s0,sp,528
    80004272:	84aa                	mv	s1,a0
    80004274:	dea43c23          	sd	a0,-520(s0)
    80004278:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000427c:	ffffd097          	auipc	ra,0xffffd
    80004280:	d58080e7          	jalr	-680(ra) # 80000fd4 <myproc>
    80004284:	892a                	mv	s2,a0

  begin_op();
    80004286:	fffff097          	auipc	ra,0xfffff
    8000428a:	492080e7          	jalr	1170(ra) # 80003718 <begin_op>

  if((ip = namei(path)) == 0){
    8000428e:	8526                	mv	a0,s1
    80004290:	fffff097          	auipc	ra,0xfffff
    80004294:	26c080e7          	jalr	620(ra) # 800034fc <namei>
    80004298:	c92d                	beqz	a0,8000430a <exec+0xbc>
    8000429a:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000429c:	fffff097          	auipc	ra,0xfffff
    800042a0:	aaa080e7          	jalr	-1366(ra) # 80002d46 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042a4:	04000713          	li	a4,64
    800042a8:	4681                	li	a3,0
    800042aa:	e5040613          	addi	a2,s0,-432
    800042ae:	4581                	li	a1,0
    800042b0:	8526                	mv	a0,s1
    800042b2:	fffff097          	auipc	ra,0xfffff
    800042b6:	d48080e7          	jalr	-696(ra) # 80002ffa <readi>
    800042ba:	04000793          	li	a5,64
    800042be:	00f51a63          	bne	a0,a5,800042d2 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800042c2:	e5042703          	lw	a4,-432(s0)
    800042c6:	464c47b7          	lui	a5,0x464c4
    800042ca:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042ce:	04f70463          	beq	a4,a5,80004316 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042d2:	8526                	mv	a0,s1
    800042d4:	fffff097          	auipc	ra,0xfffff
    800042d8:	cd4080e7          	jalr	-812(ra) # 80002fa8 <iunlockput>
    end_op();
    800042dc:	fffff097          	auipc	ra,0xfffff
    800042e0:	4bc080e7          	jalr	1212(ra) # 80003798 <end_op>
  }
  return -1;
    800042e4:	557d                	li	a0,-1
}
    800042e6:	20813083          	ld	ra,520(sp)
    800042ea:	20013403          	ld	s0,512(sp)
    800042ee:	74fe                	ld	s1,504(sp)
    800042f0:	795e                	ld	s2,496(sp)
    800042f2:	79be                	ld	s3,488(sp)
    800042f4:	7a1e                	ld	s4,480(sp)
    800042f6:	6afe                	ld	s5,472(sp)
    800042f8:	6b5e                	ld	s6,464(sp)
    800042fa:	6bbe                	ld	s7,456(sp)
    800042fc:	6c1e                	ld	s8,448(sp)
    800042fe:	7cfa                	ld	s9,440(sp)
    80004300:	7d5a                	ld	s10,432(sp)
    80004302:	7dba                	ld	s11,424(sp)
    80004304:	21010113          	addi	sp,sp,528
    80004308:	8082                	ret
    end_op();
    8000430a:	fffff097          	auipc	ra,0xfffff
    8000430e:	48e080e7          	jalr	1166(ra) # 80003798 <end_op>
    return -1;
    80004312:	557d                	li	a0,-1
    80004314:	bfc9                	j	800042e6 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004316:	854a                	mv	a0,s2
    80004318:	ffffd097          	auipc	ra,0xffffd
    8000431c:	d80080e7          	jalr	-640(ra) # 80001098 <proc_pagetable>
    80004320:	8baa                	mv	s7,a0
    80004322:	d945                	beqz	a0,800042d2 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004324:	e7042983          	lw	s3,-400(s0)
    80004328:	e8845783          	lhu	a5,-376(s0)
    8000432c:	c7ad                	beqz	a5,80004396 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000432e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004330:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004332:	6c85                	lui	s9,0x1
    80004334:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004338:	def43823          	sd	a5,-528(s0)
    8000433c:	a42d                	j	80004566 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000433e:	00004517          	auipc	a0,0x4
    80004342:	31a50513          	addi	a0,a0,794 # 80008658 <syscalls+0x290>
    80004346:	00002097          	auipc	ra,0x2
    8000434a:	df6080e7          	jalr	-522(ra) # 8000613c <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000434e:	8756                	mv	a4,s5
    80004350:	012d86bb          	addw	a3,s11,s2
    80004354:	4581                	li	a1,0
    80004356:	8526                	mv	a0,s1
    80004358:	fffff097          	auipc	ra,0xfffff
    8000435c:	ca2080e7          	jalr	-862(ra) # 80002ffa <readi>
    80004360:	2501                	sext.w	a0,a0
    80004362:	1aaa9963          	bne	s5,a0,80004514 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004366:	6785                	lui	a5,0x1
    80004368:	0127893b          	addw	s2,a5,s2
    8000436c:	77fd                	lui	a5,0xfffff
    8000436e:	01478a3b          	addw	s4,a5,s4
    80004372:	1f897163          	bgeu	s2,s8,80004554 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004376:	02091593          	slli	a1,s2,0x20
    8000437a:	9181                	srli	a1,a1,0x20
    8000437c:	95ea                	add	a1,a1,s10
    8000437e:	855e                	mv	a0,s7
    80004380:	ffffc097          	auipc	ra,0xffffc
    80004384:	312080e7          	jalr	786(ra) # 80000692 <walkaddr>
    80004388:	862a                	mv	a2,a0
    if(pa == 0)
    8000438a:	d955                	beqz	a0,8000433e <exec+0xf0>
      n = PGSIZE;
    8000438c:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000438e:	fd9a70e3          	bgeu	s4,s9,8000434e <exec+0x100>
      n = sz - i;
    80004392:	8ad2                	mv	s5,s4
    80004394:	bf6d                	j	8000434e <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004396:	4901                	li	s2,0
  iunlockput(ip);
    80004398:	8526                	mv	a0,s1
    8000439a:	fffff097          	auipc	ra,0xfffff
    8000439e:	c0e080e7          	jalr	-1010(ra) # 80002fa8 <iunlockput>
  end_op();
    800043a2:	fffff097          	auipc	ra,0xfffff
    800043a6:	3f6080e7          	jalr	1014(ra) # 80003798 <end_op>
  p = myproc();
    800043aa:	ffffd097          	auipc	ra,0xffffd
    800043ae:	c2a080e7          	jalr	-982(ra) # 80000fd4 <myproc>
    800043b2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800043b4:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    800043b8:	6785                	lui	a5,0x1
    800043ba:	17fd                	addi	a5,a5,-1
    800043bc:	993e                	add	s2,s2,a5
    800043be:	757d                	lui	a0,0xfffff
    800043c0:	00a977b3          	and	a5,s2,a0
    800043c4:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043c8:	6609                	lui	a2,0x2
    800043ca:	963e                	add	a2,a2,a5
    800043cc:	85be                	mv	a1,a5
    800043ce:	855e                	mv	a0,s7
    800043d0:	ffffc097          	auipc	ra,0xffffc
    800043d4:	676080e7          	jalr	1654(ra) # 80000a46 <uvmalloc>
    800043d8:	8b2a                	mv	s6,a0
  ip = 0;
    800043da:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043dc:	12050c63          	beqz	a0,80004514 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800043e0:	75f9                	lui	a1,0xffffe
    800043e2:	95aa                	add	a1,a1,a0
    800043e4:	855e                	mv	a0,s7
    800043e6:	ffffd097          	auipc	ra,0xffffd
    800043ea:	87e080e7          	jalr	-1922(ra) # 80000c64 <uvmclear>
  stackbase = sp - PGSIZE;
    800043ee:	7c7d                	lui	s8,0xfffff
    800043f0:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800043f2:	e0043783          	ld	a5,-512(s0)
    800043f6:	6388                	ld	a0,0(a5)
    800043f8:	c535                	beqz	a0,80004464 <exec+0x216>
    800043fa:	e9040993          	addi	s3,s0,-368
    800043fe:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004402:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004404:	ffffc097          	auipc	ra,0xffffc
    80004408:	074080e7          	jalr	116(ra) # 80000478 <strlen>
    8000440c:	2505                	addiw	a0,a0,1
    8000440e:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004412:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004416:	13896363          	bltu	s2,s8,8000453c <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000441a:	e0043d83          	ld	s11,-512(s0)
    8000441e:	000dba03          	ld	s4,0(s11)
    80004422:	8552                	mv	a0,s4
    80004424:	ffffc097          	auipc	ra,0xffffc
    80004428:	054080e7          	jalr	84(ra) # 80000478 <strlen>
    8000442c:	0015069b          	addiw	a3,a0,1
    80004430:	8652                	mv	a2,s4
    80004432:	85ca                	mv	a1,s2
    80004434:	855e                	mv	a0,s7
    80004436:	ffffd097          	auipc	ra,0xffffd
    8000443a:	860080e7          	jalr	-1952(ra) # 80000c96 <copyout>
    8000443e:	10054363          	bltz	a0,80004544 <exec+0x2f6>
    ustack[argc] = sp;
    80004442:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004446:	0485                	addi	s1,s1,1
    80004448:	008d8793          	addi	a5,s11,8
    8000444c:	e0f43023          	sd	a5,-512(s0)
    80004450:	008db503          	ld	a0,8(s11)
    80004454:	c911                	beqz	a0,80004468 <exec+0x21a>
    if(argc >= MAXARG)
    80004456:	09a1                	addi	s3,s3,8
    80004458:	fb3c96e3          	bne	s9,s3,80004404 <exec+0x1b6>
  sz = sz1;
    8000445c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004460:	4481                	li	s1,0
    80004462:	a84d                	j	80004514 <exec+0x2c6>
  sp = sz;
    80004464:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004466:	4481                	li	s1,0
  ustack[argc] = 0;
    80004468:	00349793          	slli	a5,s1,0x3
    8000446c:	f9040713          	addi	a4,s0,-112
    80004470:	97ba                	add	a5,a5,a4
    80004472:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004476:	00148693          	addi	a3,s1,1
    8000447a:	068e                	slli	a3,a3,0x3
    8000447c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004480:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004484:	01897663          	bgeu	s2,s8,80004490 <exec+0x242>
  sz = sz1;
    80004488:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000448c:	4481                	li	s1,0
    8000448e:	a059                	j	80004514 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004490:	e9040613          	addi	a2,s0,-368
    80004494:	85ca                	mv	a1,s2
    80004496:	855e                	mv	a0,s7
    80004498:	ffffc097          	auipc	ra,0xffffc
    8000449c:	7fe080e7          	jalr	2046(ra) # 80000c96 <copyout>
    800044a0:	0a054663          	bltz	a0,8000454c <exec+0x2fe>
  p->trapframe->a1 = sp;
    800044a4:	060ab783          	ld	a5,96(s5)
    800044a8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044ac:	df843783          	ld	a5,-520(s0)
    800044b0:	0007c703          	lbu	a4,0(a5)
    800044b4:	cf11                	beqz	a4,800044d0 <exec+0x282>
    800044b6:	0785                	addi	a5,a5,1
    if(*s == '/')
    800044b8:	02f00693          	li	a3,47
    800044bc:	a039                	j	800044ca <exec+0x27c>
      last = s+1;
    800044be:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800044c2:	0785                	addi	a5,a5,1
    800044c4:	fff7c703          	lbu	a4,-1(a5)
    800044c8:	c701                	beqz	a4,800044d0 <exec+0x282>
    if(*s == '/')
    800044ca:	fed71ce3          	bne	a4,a3,800044c2 <exec+0x274>
    800044ce:	bfc5                	j	800044be <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800044d0:	4641                	li	a2,16
    800044d2:	df843583          	ld	a1,-520(s0)
    800044d6:	160a8513          	addi	a0,s5,352
    800044da:	ffffc097          	auipc	ra,0xffffc
    800044de:	f6c080e7          	jalr	-148(ra) # 80000446 <safestrcpy>
  oldpagetable = p->pagetable;
    800044e2:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    800044e6:	057abc23          	sd	s7,88(s5)
  p->sz = sz;
    800044ea:	056ab823          	sd	s6,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044ee:	060ab783          	ld	a5,96(s5)
    800044f2:	e6843703          	ld	a4,-408(s0)
    800044f6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044f8:	060ab783          	ld	a5,96(s5)
    800044fc:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004500:	85ea                	mv	a1,s10
    80004502:	ffffd097          	auipc	ra,0xffffd
    80004506:	c32080e7          	jalr	-974(ra) # 80001134 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000450a:	0004851b          	sext.w	a0,s1
    8000450e:	bbe1                	j	800042e6 <exec+0x98>
    80004510:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004514:	e0843583          	ld	a1,-504(s0)
    80004518:	855e                	mv	a0,s7
    8000451a:	ffffd097          	auipc	ra,0xffffd
    8000451e:	c1a080e7          	jalr	-998(ra) # 80001134 <proc_freepagetable>
  if(ip){
    80004522:	da0498e3          	bnez	s1,800042d2 <exec+0x84>
  return -1;
    80004526:	557d                	li	a0,-1
    80004528:	bb7d                	j	800042e6 <exec+0x98>
    8000452a:	e1243423          	sd	s2,-504(s0)
    8000452e:	b7dd                	j	80004514 <exec+0x2c6>
    80004530:	e1243423          	sd	s2,-504(s0)
    80004534:	b7c5                	j	80004514 <exec+0x2c6>
    80004536:	e1243423          	sd	s2,-504(s0)
    8000453a:	bfe9                	j	80004514 <exec+0x2c6>
  sz = sz1;
    8000453c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004540:	4481                	li	s1,0
    80004542:	bfc9                	j	80004514 <exec+0x2c6>
  sz = sz1;
    80004544:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004548:	4481                	li	s1,0
    8000454a:	b7e9                	j	80004514 <exec+0x2c6>
  sz = sz1;
    8000454c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004550:	4481                	li	s1,0
    80004552:	b7c9                	j	80004514 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004554:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004558:	2b05                	addiw	s6,s6,1
    8000455a:	0389899b          	addiw	s3,s3,56
    8000455e:	e8845783          	lhu	a5,-376(s0)
    80004562:	e2fb5be3          	bge	s6,a5,80004398 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004566:	2981                	sext.w	s3,s3
    80004568:	03800713          	li	a4,56
    8000456c:	86ce                	mv	a3,s3
    8000456e:	e1840613          	addi	a2,s0,-488
    80004572:	4581                	li	a1,0
    80004574:	8526                	mv	a0,s1
    80004576:	fffff097          	auipc	ra,0xfffff
    8000457a:	a84080e7          	jalr	-1404(ra) # 80002ffa <readi>
    8000457e:	03800793          	li	a5,56
    80004582:	f8f517e3          	bne	a0,a5,80004510 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004586:	e1842783          	lw	a5,-488(s0)
    8000458a:	4705                	li	a4,1
    8000458c:	fce796e3          	bne	a5,a4,80004558 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004590:	e4043603          	ld	a2,-448(s0)
    80004594:	e3843783          	ld	a5,-456(s0)
    80004598:	f8f669e3          	bltu	a2,a5,8000452a <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000459c:	e2843783          	ld	a5,-472(s0)
    800045a0:	963e                	add	a2,a2,a5
    800045a2:	f8f667e3          	bltu	a2,a5,80004530 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045a6:	85ca                	mv	a1,s2
    800045a8:	855e                	mv	a0,s7
    800045aa:	ffffc097          	auipc	ra,0xffffc
    800045ae:	49c080e7          	jalr	1180(ra) # 80000a46 <uvmalloc>
    800045b2:	e0a43423          	sd	a0,-504(s0)
    800045b6:	d141                	beqz	a0,80004536 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    800045b8:	e2843d03          	ld	s10,-472(s0)
    800045bc:	df043783          	ld	a5,-528(s0)
    800045c0:	00fd77b3          	and	a5,s10,a5
    800045c4:	fba1                	bnez	a5,80004514 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800045c6:	e2042d83          	lw	s11,-480(s0)
    800045ca:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045ce:	f80c03e3          	beqz	s8,80004554 <exec+0x306>
    800045d2:	8a62                	mv	s4,s8
    800045d4:	4901                	li	s2,0
    800045d6:	b345                	j	80004376 <exec+0x128>

00000000800045d8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045d8:	7179                	addi	sp,sp,-48
    800045da:	f406                	sd	ra,40(sp)
    800045dc:	f022                	sd	s0,32(sp)
    800045de:	ec26                	sd	s1,24(sp)
    800045e0:	e84a                	sd	s2,16(sp)
    800045e2:	1800                	addi	s0,sp,48
    800045e4:	892e                	mv	s2,a1
    800045e6:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800045e8:	fdc40593          	addi	a1,s0,-36
    800045ec:	ffffe097          	auipc	ra,0xffffe
    800045f0:	a94080e7          	jalr	-1388(ra) # 80002080 <argint>
    800045f4:	04054063          	bltz	a0,80004634 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045f8:	fdc42703          	lw	a4,-36(s0)
    800045fc:	47bd                	li	a5,15
    800045fe:	02e7ed63          	bltu	a5,a4,80004638 <argfd+0x60>
    80004602:	ffffd097          	auipc	ra,0xffffd
    80004606:	9d2080e7          	jalr	-1582(ra) # 80000fd4 <myproc>
    8000460a:	fdc42703          	lw	a4,-36(s0)
    8000460e:	01a70793          	addi	a5,a4,26
    80004612:	078e                	slli	a5,a5,0x3
    80004614:	953e                	add	a0,a0,a5
    80004616:	651c                	ld	a5,8(a0)
    80004618:	c395                	beqz	a5,8000463c <argfd+0x64>
    return -1;
  if(pfd)
    8000461a:	00090463          	beqz	s2,80004622 <argfd+0x4a>
    *pfd = fd;
    8000461e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004622:	4501                	li	a0,0
  if(pf)
    80004624:	c091                	beqz	s1,80004628 <argfd+0x50>
    *pf = f;
    80004626:	e09c                	sd	a5,0(s1)
}
    80004628:	70a2                	ld	ra,40(sp)
    8000462a:	7402                	ld	s0,32(sp)
    8000462c:	64e2                	ld	s1,24(sp)
    8000462e:	6942                	ld	s2,16(sp)
    80004630:	6145                	addi	sp,sp,48
    80004632:	8082                	ret
    return -1;
    80004634:	557d                	li	a0,-1
    80004636:	bfcd                	j	80004628 <argfd+0x50>
    return -1;
    80004638:	557d                	li	a0,-1
    8000463a:	b7fd                	j	80004628 <argfd+0x50>
    8000463c:	557d                	li	a0,-1
    8000463e:	b7ed                	j	80004628 <argfd+0x50>

0000000080004640 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004640:	1101                	addi	sp,sp,-32
    80004642:	ec06                	sd	ra,24(sp)
    80004644:	e822                	sd	s0,16(sp)
    80004646:	e426                	sd	s1,8(sp)
    80004648:	1000                	addi	s0,sp,32
    8000464a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000464c:	ffffd097          	auipc	ra,0xffffd
    80004650:	988080e7          	jalr	-1656(ra) # 80000fd4 <myproc>
    80004654:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004656:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd2e90>
    8000465a:	4501                	li	a0,0
    8000465c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000465e:	6398                	ld	a4,0(a5)
    80004660:	cb19                	beqz	a4,80004676 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004662:	2505                	addiw	a0,a0,1
    80004664:	07a1                	addi	a5,a5,8
    80004666:	fed51ce3          	bne	a0,a3,8000465e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000466a:	557d                	li	a0,-1
}
    8000466c:	60e2                	ld	ra,24(sp)
    8000466e:	6442                	ld	s0,16(sp)
    80004670:	64a2                	ld	s1,8(sp)
    80004672:	6105                	addi	sp,sp,32
    80004674:	8082                	ret
      p->ofile[fd] = f;
    80004676:	01a50793          	addi	a5,a0,26
    8000467a:	078e                	slli	a5,a5,0x3
    8000467c:	963e                	add	a2,a2,a5
    8000467e:	e604                	sd	s1,8(a2)
      return fd;
    80004680:	b7f5                	j	8000466c <fdalloc+0x2c>

0000000080004682 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004682:	715d                	addi	sp,sp,-80
    80004684:	e486                	sd	ra,72(sp)
    80004686:	e0a2                	sd	s0,64(sp)
    80004688:	fc26                	sd	s1,56(sp)
    8000468a:	f84a                	sd	s2,48(sp)
    8000468c:	f44e                	sd	s3,40(sp)
    8000468e:	f052                	sd	s4,32(sp)
    80004690:	ec56                	sd	s5,24(sp)
    80004692:	0880                	addi	s0,sp,80
    80004694:	89ae                	mv	s3,a1
    80004696:	8ab2                	mv	s5,a2
    80004698:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000469a:	fb040593          	addi	a1,s0,-80
    8000469e:	fffff097          	auipc	ra,0xfffff
    800046a2:	e7c080e7          	jalr	-388(ra) # 8000351a <nameiparent>
    800046a6:	892a                	mv	s2,a0
    800046a8:	12050f63          	beqz	a0,800047e6 <create+0x164>
    return 0;

  ilock(dp);
    800046ac:	ffffe097          	auipc	ra,0xffffe
    800046b0:	69a080e7          	jalr	1690(ra) # 80002d46 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046b4:	4601                	li	a2,0
    800046b6:	fb040593          	addi	a1,s0,-80
    800046ba:	854a                	mv	a0,s2
    800046bc:	fffff097          	auipc	ra,0xfffff
    800046c0:	b6e080e7          	jalr	-1170(ra) # 8000322a <dirlookup>
    800046c4:	84aa                	mv	s1,a0
    800046c6:	c921                	beqz	a0,80004716 <create+0x94>
    iunlockput(dp);
    800046c8:	854a                	mv	a0,s2
    800046ca:	fffff097          	auipc	ra,0xfffff
    800046ce:	8de080e7          	jalr	-1826(ra) # 80002fa8 <iunlockput>
    ilock(ip);
    800046d2:	8526                	mv	a0,s1
    800046d4:	ffffe097          	auipc	ra,0xffffe
    800046d8:	672080e7          	jalr	1650(ra) # 80002d46 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046dc:	2981                	sext.w	s3,s3
    800046de:	4789                	li	a5,2
    800046e0:	02f99463          	bne	s3,a5,80004708 <create+0x86>
    800046e4:	04c4d783          	lhu	a5,76(s1)
    800046e8:	37f9                	addiw	a5,a5,-2
    800046ea:	17c2                	slli	a5,a5,0x30
    800046ec:	93c1                	srli	a5,a5,0x30
    800046ee:	4705                	li	a4,1
    800046f0:	00f76c63          	bltu	a4,a5,80004708 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800046f4:	8526                	mv	a0,s1
    800046f6:	60a6                	ld	ra,72(sp)
    800046f8:	6406                	ld	s0,64(sp)
    800046fa:	74e2                	ld	s1,56(sp)
    800046fc:	7942                	ld	s2,48(sp)
    800046fe:	79a2                	ld	s3,40(sp)
    80004700:	7a02                	ld	s4,32(sp)
    80004702:	6ae2                	ld	s5,24(sp)
    80004704:	6161                	addi	sp,sp,80
    80004706:	8082                	ret
    iunlockput(ip);
    80004708:	8526                	mv	a0,s1
    8000470a:	fffff097          	auipc	ra,0xfffff
    8000470e:	89e080e7          	jalr	-1890(ra) # 80002fa8 <iunlockput>
    return 0;
    80004712:	4481                	li	s1,0
    80004714:	b7c5                	j	800046f4 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004716:	85ce                	mv	a1,s3
    80004718:	00092503          	lw	a0,0(s2)
    8000471c:	ffffe097          	auipc	ra,0xffffe
    80004720:	492080e7          	jalr	1170(ra) # 80002bae <ialloc>
    80004724:	84aa                	mv	s1,a0
    80004726:	c529                	beqz	a0,80004770 <create+0xee>
  ilock(ip);
    80004728:	ffffe097          	auipc	ra,0xffffe
    8000472c:	61e080e7          	jalr	1566(ra) # 80002d46 <ilock>
  ip->major = major;
    80004730:	05549723          	sh	s5,78(s1)
  ip->minor = minor;
    80004734:	05449823          	sh	s4,80(s1)
  ip->nlink = 1;
    80004738:	4785                	li	a5,1
    8000473a:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    8000473e:	8526                	mv	a0,s1
    80004740:	ffffe097          	auipc	ra,0xffffe
    80004744:	53c080e7          	jalr	1340(ra) # 80002c7c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004748:	2981                	sext.w	s3,s3
    8000474a:	4785                	li	a5,1
    8000474c:	02f98a63          	beq	s3,a5,80004780 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004750:	40d0                	lw	a2,4(s1)
    80004752:	fb040593          	addi	a1,s0,-80
    80004756:	854a                	mv	a0,s2
    80004758:	fffff097          	auipc	ra,0xfffff
    8000475c:	ce2080e7          	jalr	-798(ra) # 8000343a <dirlink>
    80004760:	06054b63          	bltz	a0,800047d6 <create+0x154>
  iunlockput(dp);
    80004764:	854a                	mv	a0,s2
    80004766:	fffff097          	auipc	ra,0xfffff
    8000476a:	842080e7          	jalr	-1982(ra) # 80002fa8 <iunlockput>
  return ip;
    8000476e:	b759                	j	800046f4 <create+0x72>
    panic("create: ialloc");
    80004770:	00004517          	auipc	a0,0x4
    80004774:	f0850513          	addi	a0,a0,-248 # 80008678 <syscalls+0x2b0>
    80004778:	00002097          	auipc	ra,0x2
    8000477c:	9c4080e7          	jalr	-1596(ra) # 8000613c <panic>
    dp->nlink++;  // for ".."
    80004780:	05295783          	lhu	a5,82(s2)
    80004784:	2785                	addiw	a5,a5,1
    80004786:	04f91923          	sh	a5,82(s2)
    iupdate(dp);
    8000478a:	854a                	mv	a0,s2
    8000478c:	ffffe097          	auipc	ra,0xffffe
    80004790:	4f0080e7          	jalr	1264(ra) # 80002c7c <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004794:	40d0                	lw	a2,4(s1)
    80004796:	00004597          	auipc	a1,0x4
    8000479a:	ef258593          	addi	a1,a1,-270 # 80008688 <syscalls+0x2c0>
    8000479e:	8526                	mv	a0,s1
    800047a0:	fffff097          	auipc	ra,0xfffff
    800047a4:	c9a080e7          	jalr	-870(ra) # 8000343a <dirlink>
    800047a8:	00054f63          	bltz	a0,800047c6 <create+0x144>
    800047ac:	00492603          	lw	a2,4(s2)
    800047b0:	00004597          	auipc	a1,0x4
    800047b4:	ee058593          	addi	a1,a1,-288 # 80008690 <syscalls+0x2c8>
    800047b8:	8526                	mv	a0,s1
    800047ba:	fffff097          	auipc	ra,0xfffff
    800047be:	c80080e7          	jalr	-896(ra) # 8000343a <dirlink>
    800047c2:	f80557e3          	bgez	a0,80004750 <create+0xce>
      panic("create dots");
    800047c6:	00004517          	auipc	a0,0x4
    800047ca:	ed250513          	addi	a0,a0,-302 # 80008698 <syscalls+0x2d0>
    800047ce:	00002097          	auipc	ra,0x2
    800047d2:	96e080e7          	jalr	-1682(ra) # 8000613c <panic>
    panic("create: dirlink");
    800047d6:	00004517          	auipc	a0,0x4
    800047da:	ed250513          	addi	a0,a0,-302 # 800086a8 <syscalls+0x2e0>
    800047de:	00002097          	auipc	ra,0x2
    800047e2:	95e080e7          	jalr	-1698(ra) # 8000613c <panic>
    return 0;
    800047e6:	84aa                	mv	s1,a0
    800047e8:	b731                	j	800046f4 <create+0x72>

00000000800047ea <sys_dup>:
{
    800047ea:	7179                	addi	sp,sp,-48
    800047ec:	f406                	sd	ra,40(sp)
    800047ee:	f022                	sd	s0,32(sp)
    800047f0:	ec26                	sd	s1,24(sp)
    800047f2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047f4:	fd840613          	addi	a2,s0,-40
    800047f8:	4581                	li	a1,0
    800047fa:	4501                	li	a0,0
    800047fc:	00000097          	auipc	ra,0x0
    80004800:	ddc080e7          	jalr	-548(ra) # 800045d8 <argfd>
    return -1;
    80004804:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004806:	02054363          	bltz	a0,8000482c <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000480a:	fd843503          	ld	a0,-40(s0)
    8000480e:	00000097          	auipc	ra,0x0
    80004812:	e32080e7          	jalr	-462(ra) # 80004640 <fdalloc>
    80004816:	84aa                	mv	s1,a0
    return -1;
    80004818:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000481a:	00054963          	bltz	a0,8000482c <sys_dup+0x42>
  filedup(f);
    8000481e:	fd843503          	ld	a0,-40(s0)
    80004822:	fffff097          	auipc	ra,0xfffff
    80004826:	370080e7          	jalr	880(ra) # 80003b92 <filedup>
  return fd;
    8000482a:	87a6                	mv	a5,s1
}
    8000482c:	853e                	mv	a0,a5
    8000482e:	70a2                	ld	ra,40(sp)
    80004830:	7402                	ld	s0,32(sp)
    80004832:	64e2                	ld	s1,24(sp)
    80004834:	6145                	addi	sp,sp,48
    80004836:	8082                	ret

0000000080004838 <sys_read>:
{
    80004838:	7179                	addi	sp,sp,-48
    8000483a:	f406                	sd	ra,40(sp)
    8000483c:	f022                	sd	s0,32(sp)
    8000483e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004840:	fe840613          	addi	a2,s0,-24
    80004844:	4581                	li	a1,0
    80004846:	4501                	li	a0,0
    80004848:	00000097          	auipc	ra,0x0
    8000484c:	d90080e7          	jalr	-624(ra) # 800045d8 <argfd>
    return -1;
    80004850:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004852:	04054163          	bltz	a0,80004894 <sys_read+0x5c>
    80004856:	fe440593          	addi	a1,s0,-28
    8000485a:	4509                	li	a0,2
    8000485c:	ffffe097          	auipc	ra,0xffffe
    80004860:	824080e7          	jalr	-2012(ra) # 80002080 <argint>
    return -1;
    80004864:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004866:	02054763          	bltz	a0,80004894 <sys_read+0x5c>
    8000486a:	fd840593          	addi	a1,s0,-40
    8000486e:	4505                	li	a0,1
    80004870:	ffffe097          	auipc	ra,0xffffe
    80004874:	832080e7          	jalr	-1998(ra) # 800020a2 <argaddr>
    return -1;
    80004878:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000487a:	00054d63          	bltz	a0,80004894 <sys_read+0x5c>
  return fileread(f, p, n);
    8000487e:	fe442603          	lw	a2,-28(s0)
    80004882:	fd843583          	ld	a1,-40(s0)
    80004886:	fe843503          	ld	a0,-24(s0)
    8000488a:	fffff097          	auipc	ra,0xfffff
    8000488e:	494080e7          	jalr	1172(ra) # 80003d1e <fileread>
    80004892:	87aa                	mv	a5,a0
}
    80004894:	853e                	mv	a0,a5
    80004896:	70a2                	ld	ra,40(sp)
    80004898:	7402                	ld	s0,32(sp)
    8000489a:	6145                	addi	sp,sp,48
    8000489c:	8082                	ret

000000008000489e <sys_write>:
{
    8000489e:	7179                	addi	sp,sp,-48
    800048a0:	f406                	sd	ra,40(sp)
    800048a2:	f022                	sd	s0,32(sp)
    800048a4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048a6:	fe840613          	addi	a2,s0,-24
    800048aa:	4581                	li	a1,0
    800048ac:	4501                	li	a0,0
    800048ae:	00000097          	auipc	ra,0x0
    800048b2:	d2a080e7          	jalr	-726(ra) # 800045d8 <argfd>
    return -1;
    800048b6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048b8:	04054163          	bltz	a0,800048fa <sys_write+0x5c>
    800048bc:	fe440593          	addi	a1,s0,-28
    800048c0:	4509                	li	a0,2
    800048c2:	ffffd097          	auipc	ra,0xffffd
    800048c6:	7be080e7          	jalr	1982(ra) # 80002080 <argint>
    return -1;
    800048ca:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048cc:	02054763          	bltz	a0,800048fa <sys_write+0x5c>
    800048d0:	fd840593          	addi	a1,s0,-40
    800048d4:	4505                	li	a0,1
    800048d6:	ffffd097          	auipc	ra,0xffffd
    800048da:	7cc080e7          	jalr	1996(ra) # 800020a2 <argaddr>
    return -1;
    800048de:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048e0:	00054d63          	bltz	a0,800048fa <sys_write+0x5c>
  return filewrite(f, p, n);
    800048e4:	fe442603          	lw	a2,-28(s0)
    800048e8:	fd843583          	ld	a1,-40(s0)
    800048ec:	fe843503          	ld	a0,-24(s0)
    800048f0:	fffff097          	auipc	ra,0xfffff
    800048f4:	4f0080e7          	jalr	1264(ra) # 80003de0 <filewrite>
    800048f8:	87aa                	mv	a5,a0
}
    800048fa:	853e                	mv	a0,a5
    800048fc:	70a2                	ld	ra,40(sp)
    800048fe:	7402                	ld	s0,32(sp)
    80004900:	6145                	addi	sp,sp,48
    80004902:	8082                	ret

0000000080004904 <sys_close>:
{
    80004904:	1101                	addi	sp,sp,-32
    80004906:	ec06                	sd	ra,24(sp)
    80004908:	e822                	sd	s0,16(sp)
    8000490a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000490c:	fe040613          	addi	a2,s0,-32
    80004910:	fec40593          	addi	a1,s0,-20
    80004914:	4501                	li	a0,0
    80004916:	00000097          	auipc	ra,0x0
    8000491a:	cc2080e7          	jalr	-830(ra) # 800045d8 <argfd>
    return -1;
    8000491e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004920:	02054463          	bltz	a0,80004948 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004924:	ffffc097          	auipc	ra,0xffffc
    80004928:	6b0080e7          	jalr	1712(ra) # 80000fd4 <myproc>
    8000492c:	fec42783          	lw	a5,-20(s0)
    80004930:	07e9                	addi	a5,a5,26
    80004932:	078e                	slli	a5,a5,0x3
    80004934:	97aa                	add	a5,a5,a0
    80004936:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    8000493a:	fe043503          	ld	a0,-32(s0)
    8000493e:	fffff097          	auipc	ra,0xfffff
    80004942:	2a6080e7          	jalr	678(ra) # 80003be4 <fileclose>
  return 0;
    80004946:	4781                	li	a5,0
}
    80004948:	853e                	mv	a0,a5
    8000494a:	60e2                	ld	ra,24(sp)
    8000494c:	6442                	ld	s0,16(sp)
    8000494e:	6105                	addi	sp,sp,32
    80004950:	8082                	ret

0000000080004952 <sys_fstat>:
{
    80004952:	1101                	addi	sp,sp,-32
    80004954:	ec06                	sd	ra,24(sp)
    80004956:	e822                	sd	s0,16(sp)
    80004958:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000495a:	fe840613          	addi	a2,s0,-24
    8000495e:	4581                	li	a1,0
    80004960:	4501                	li	a0,0
    80004962:	00000097          	auipc	ra,0x0
    80004966:	c76080e7          	jalr	-906(ra) # 800045d8 <argfd>
    return -1;
    8000496a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000496c:	02054563          	bltz	a0,80004996 <sys_fstat+0x44>
    80004970:	fe040593          	addi	a1,s0,-32
    80004974:	4505                	li	a0,1
    80004976:	ffffd097          	auipc	ra,0xffffd
    8000497a:	72c080e7          	jalr	1836(ra) # 800020a2 <argaddr>
    return -1;
    8000497e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004980:	00054b63          	bltz	a0,80004996 <sys_fstat+0x44>
  return filestat(f, st);
    80004984:	fe043583          	ld	a1,-32(s0)
    80004988:	fe843503          	ld	a0,-24(s0)
    8000498c:	fffff097          	auipc	ra,0xfffff
    80004990:	320080e7          	jalr	800(ra) # 80003cac <filestat>
    80004994:	87aa                	mv	a5,a0
}
    80004996:	853e                	mv	a0,a5
    80004998:	60e2                	ld	ra,24(sp)
    8000499a:	6442                	ld	s0,16(sp)
    8000499c:	6105                	addi	sp,sp,32
    8000499e:	8082                	ret

00000000800049a0 <sys_link>:
{
    800049a0:	7169                	addi	sp,sp,-304
    800049a2:	f606                	sd	ra,296(sp)
    800049a4:	f222                	sd	s0,288(sp)
    800049a6:	ee26                	sd	s1,280(sp)
    800049a8:	ea4a                	sd	s2,272(sp)
    800049aa:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ac:	08000613          	li	a2,128
    800049b0:	ed040593          	addi	a1,s0,-304
    800049b4:	4501                	li	a0,0
    800049b6:	ffffd097          	auipc	ra,0xffffd
    800049ba:	70e080e7          	jalr	1806(ra) # 800020c4 <argstr>
    return -1;
    800049be:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049c0:	10054e63          	bltz	a0,80004adc <sys_link+0x13c>
    800049c4:	08000613          	li	a2,128
    800049c8:	f5040593          	addi	a1,s0,-176
    800049cc:	4505                	li	a0,1
    800049ce:	ffffd097          	auipc	ra,0xffffd
    800049d2:	6f6080e7          	jalr	1782(ra) # 800020c4 <argstr>
    return -1;
    800049d6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049d8:	10054263          	bltz	a0,80004adc <sys_link+0x13c>
  begin_op();
    800049dc:	fffff097          	auipc	ra,0xfffff
    800049e0:	d3c080e7          	jalr	-708(ra) # 80003718 <begin_op>
  if((ip = namei(old)) == 0){
    800049e4:	ed040513          	addi	a0,s0,-304
    800049e8:	fffff097          	auipc	ra,0xfffff
    800049ec:	b14080e7          	jalr	-1260(ra) # 800034fc <namei>
    800049f0:	84aa                	mv	s1,a0
    800049f2:	c551                	beqz	a0,80004a7e <sys_link+0xde>
  ilock(ip);
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	352080e7          	jalr	850(ra) # 80002d46 <ilock>
  if(ip->type == T_DIR){
    800049fc:	04c49703          	lh	a4,76(s1)
    80004a00:	4785                	li	a5,1
    80004a02:	08f70463          	beq	a4,a5,80004a8a <sys_link+0xea>
  ip->nlink++;
    80004a06:	0524d783          	lhu	a5,82(s1)
    80004a0a:	2785                	addiw	a5,a5,1
    80004a0c:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004a10:	8526                	mv	a0,s1
    80004a12:	ffffe097          	auipc	ra,0xffffe
    80004a16:	26a080e7          	jalr	618(ra) # 80002c7c <iupdate>
  iunlock(ip);
    80004a1a:	8526                	mv	a0,s1
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	3ec080e7          	jalr	1004(ra) # 80002e08 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a24:	fd040593          	addi	a1,s0,-48
    80004a28:	f5040513          	addi	a0,s0,-176
    80004a2c:	fffff097          	auipc	ra,0xfffff
    80004a30:	aee080e7          	jalr	-1298(ra) # 8000351a <nameiparent>
    80004a34:	892a                	mv	s2,a0
    80004a36:	c935                	beqz	a0,80004aaa <sys_link+0x10a>
  ilock(dp);
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	30e080e7          	jalr	782(ra) # 80002d46 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a40:	00092703          	lw	a4,0(s2)
    80004a44:	409c                	lw	a5,0(s1)
    80004a46:	04f71d63          	bne	a4,a5,80004aa0 <sys_link+0x100>
    80004a4a:	40d0                	lw	a2,4(s1)
    80004a4c:	fd040593          	addi	a1,s0,-48
    80004a50:	854a                	mv	a0,s2
    80004a52:	fffff097          	auipc	ra,0xfffff
    80004a56:	9e8080e7          	jalr	-1560(ra) # 8000343a <dirlink>
    80004a5a:	04054363          	bltz	a0,80004aa0 <sys_link+0x100>
  iunlockput(dp);
    80004a5e:	854a                	mv	a0,s2
    80004a60:	ffffe097          	auipc	ra,0xffffe
    80004a64:	548080e7          	jalr	1352(ra) # 80002fa8 <iunlockput>
  iput(ip);
    80004a68:	8526                	mv	a0,s1
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	496080e7          	jalr	1174(ra) # 80002f00 <iput>
  end_op();
    80004a72:	fffff097          	auipc	ra,0xfffff
    80004a76:	d26080e7          	jalr	-730(ra) # 80003798 <end_op>
  return 0;
    80004a7a:	4781                	li	a5,0
    80004a7c:	a085                	j	80004adc <sys_link+0x13c>
    end_op();
    80004a7e:	fffff097          	auipc	ra,0xfffff
    80004a82:	d1a080e7          	jalr	-742(ra) # 80003798 <end_op>
    return -1;
    80004a86:	57fd                	li	a5,-1
    80004a88:	a891                	j	80004adc <sys_link+0x13c>
    iunlockput(ip);
    80004a8a:	8526                	mv	a0,s1
    80004a8c:	ffffe097          	auipc	ra,0xffffe
    80004a90:	51c080e7          	jalr	1308(ra) # 80002fa8 <iunlockput>
    end_op();
    80004a94:	fffff097          	auipc	ra,0xfffff
    80004a98:	d04080e7          	jalr	-764(ra) # 80003798 <end_op>
    return -1;
    80004a9c:	57fd                	li	a5,-1
    80004a9e:	a83d                	j	80004adc <sys_link+0x13c>
    iunlockput(dp);
    80004aa0:	854a                	mv	a0,s2
    80004aa2:	ffffe097          	auipc	ra,0xffffe
    80004aa6:	506080e7          	jalr	1286(ra) # 80002fa8 <iunlockput>
  ilock(ip);
    80004aaa:	8526                	mv	a0,s1
    80004aac:	ffffe097          	auipc	ra,0xffffe
    80004ab0:	29a080e7          	jalr	666(ra) # 80002d46 <ilock>
  ip->nlink--;
    80004ab4:	0524d783          	lhu	a5,82(s1)
    80004ab8:	37fd                	addiw	a5,a5,-1
    80004aba:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004abe:	8526                	mv	a0,s1
    80004ac0:	ffffe097          	auipc	ra,0xffffe
    80004ac4:	1bc080e7          	jalr	444(ra) # 80002c7c <iupdate>
  iunlockput(ip);
    80004ac8:	8526                	mv	a0,s1
    80004aca:	ffffe097          	auipc	ra,0xffffe
    80004ace:	4de080e7          	jalr	1246(ra) # 80002fa8 <iunlockput>
  end_op();
    80004ad2:	fffff097          	auipc	ra,0xfffff
    80004ad6:	cc6080e7          	jalr	-826(ra) # 80003798 <end_op>
  return -1;
    80004ada:	57fd                	li	a5,-1
}
    80004adc:	853e                	mv	a0,a5
    80004ade:	70b2                	ld	ra,296(sp)
    80004ae0:	7412                	ld	s0,288(sp)
    80004ae2:	64f2                	ld	s1,280(sp)
    80004ae4:	6952                	ld	s2,272(sp)
    80004ae6:	6155                	addi	sp,sp,304
    80004ae8:	8082                	ret

0000000080004aea <sys_unlink>:
{
    80004aea:	7151                	addi	sp,sp,-240
    80004aec:	f586                	sd	ra,232(sp)
    80004aee:	f1a2                	sd	s0,224(sp)
    80004af0:	eda6                	sd	s1,216(sp)
    80004af2:	e9ca                	sd	s2,208(sp)
    80004af4:	e5ce                	sd	s3,200(sp)
    80004af6:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004af8:	08000613          	li	a2,128
    80004afc:	f3040593          	addi	a1,s0,-208
    80004b00:	4501                	li	a0,0
    80004b02:	ffffd097          	auipc	ra,0xffffd
    80004b06:	5c2080e7          	jalr	1474(ra) # 800020c4 <argstr>
    80004b0a:	18054163          	bltz	a0,80004c8c <sys_unlink+0x1a2>
  begin_op();
    80004b0e:	fffff097          	auipc	ra,0xfffff
    80004b12:	c0a080e7          	jalr	-1014(ra) # 80003718 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b16:	fb040593          	addi	a1,s0,-80
    80004b1a:	f3040513          	addi	a0,s0,-208
    80004b1e:	fffff097          	auipc	ra,0xfffff
    80004b22:	9fc080e7          	jalr	-1540(ra) # 8000351a <nameiparent>
    80004b26:	84aa                	mv	s1,a0
    80004b28:	c979                	beqz	a0,80004bfe <sys_unlink+0x114>
  ilock(dp);
    80004b2a:	ffffe097          	auipc	ra,0xffffe
    80004b2e:	21c080e7          	jalr	540(ra) # 80002d46 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b32:	00004597          	auipc	a1,0x4
    80004b36:	b5658593          	addi	a1,a1,-1194 # 80008688 <syscalls+0x2c0>
    80004b3a:	fb040513          	addi	a0,s0,-80
    80004b3e:	ffffe097          	auipc	ra,0xffffe
    80004b42:	6d2080e7          	jalr	1746(ra) # 80003210 <namecmp>
    80004b46:	14050a63          	beqz	a0,80004c9a <sys_unlink+0x1b0>
    80004b4a:	00004597          	auipc	a1,0x4
    80004b4e:	b4658593          	addi	a1,a1,-1210 # 80008690 <syscalls+0x2c8>
    80004b52:	fb040513          	addi	a0,s0,-80
    80004b56:	ffffe097          	auipc	ra,0xffffe
    80004b5a:	6ba080e7          	jalr	1722(ra) # 80003210 <namecmp>
    80004b5e:	12050e63          	beqz	a0,80004c9a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b62:	f2c40613          	addi	a2,s0,-212
    80004b66:	fb040593          	addi	a1,s0,-80
    80004b6a:	8526                	mv	a0,s1
    80004b6c:	ffffe097          	auipc	ra,0xffffe
    80004b70:	6be080e7          	jalr	1726(ra) # 8000322a <dirlookup>
    80004b74:	892a                	mv	s2,a0
    80004b76:	12050263          	beqz	a0,80004c9a <sys_unlink+0x1b0>
  ilock(ip);
    80004b7a:	ffffe097          	auipc	ra,0xffffe
    80004b7e:	1cc080e7          	jalr	460(ra) # 80002d46 <ilock>
  if(ip->nlink < 1)
    80004b82:	05291783          	lh	a5,82(s2)
    80004b86:	08f05263          	blez	a5,80004c0a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b8a:	04c91703          	lh	a4,76(s2)
    80004b8e:	4785                	li	a5,1
    80004b90:	08f70563          	beq	a4,a5,80004c1a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b94:	4641                	li	a2,16
    80004b96:	4581                	li	a1,0
    80004b98:	fc040513          	addi	a0,s0,-64
    80004b9c:	ffffb097          	auipc	ra,0xffffb
    80004ba0:	758080e7          	jalr	1880(ra) # 800002f4 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ba4:	4741                	li	a4,16
    80004ba6:	f2c42683          	lw	a3,-212(s0)
    80004baa:	fc040613          	addi	a2,s0,-64
    80004bae:	4581                	li	a1,0
    80004bb0:	8526                	mv	a0,s1
    80004bb2:	ffffe097          	auipc	ra,0xffffe
    80004bb6:	540080e7          	jalr	1344(ra) # 800030f2 <writei>
    80004bba:	47c1                	li	a5,16
    80004bbc:	0af51563          	bne	a0,a5,80004c66 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004bc0:	04c91703          	lh	a4,76(s2)
    80004bc4:	4785                	li	a5,1
    80004bc6:	0af70863          	beq	a4,a5,80004c76 <sys_unlink+0x18c>
  iunlockput(dp);
    80004bca:	8526                	mv	a0,s1
    80004bcc:	ffffe097          	auipc	ra,0xffffe
    80004bd0:	3dc080e7          	jalr	988(ra) # 80002fa8 <iunlockput>
  ip->nlink--;
    80004bd4:	05295783          	lhu	a5,82(s2)
    80004bd8:	37fd                	addiw	a5,a5,-1
    80004bda:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    80004bde:	854a                	mv	a0,s2
    80004be0:	ffffe097          	auipc	ra,0xffffe
    80004be4:	09c080e7          	jalr	156(ra) # 80002c7c <iupdate>
  iunlockput(ip);
    80004be8:	854a                	mv	a0,s2
    80004bea:	ffffe097          	auipc	ra,0xffffe
    80004bee:	3be080e7          	jalr	958(ra) # 80002fa8 <iunlockput>
  end_op();
    80004bf2:	fffff097          	auipc	ra,0xfffff
    80004bf6:	ba6080e7          	jalr	-1114(ra) # 80003798 <end_op>
  return 0;
    80004bfa:	4501                	li	a0,0
    80004bfc:	a84d                	j	80004cae <sys_unlink+0x1c4>
    end_op();
    80004bfe:	fffff097          	auipc	ra,0xfffff
    80004c02:	b9a080e7          	jalr	-1126(ra) # 80003798 <end_op>
    return -1;
    80004c06:	557d                	li	a0,-1
    80004c08:	a05d                	j	80004cae <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c0a:	00004517          	auipc	a0,0x4
    80004c0e:	aae50513          	addi	a0,a0,-1362 # 800086b8 <syscalls+0x2f0>
    80004c12:	00001097          	auipc	ra,0x1
    80004c16:	52a080e7          	jalr	1322(ra) # 8000613c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c1a:	05492703          	lw	a4,84(s2)
    80004c1e:	02000793          	li	a5,32
    80004c22:	f6e7f9e3          	bgeu	a5,a4,80004b94 <sys_unlink+0xaa>
    80004c26:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c2a:	4741                	li	a4,16
    80004c2c:	86ce                	mv	a3,s3
    80004c2e:	f1840613          	addi	a2,s0,-232
    80004c32:	4581                	li	a1,0
    80004c34:	854a                	mv	a0,s2
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	3c4080e7          	jalr	964(ra) # 80002ffa <readi>
    80004c3e:	47c1                	li	a5,16
    80004c40:	00f51b63          	bne	a0,a5,80004c56 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c44:	f1845783          	lhu	a5,-232(s0)
    80004c48:	e7a1                	bnez	a5,80004c90 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c4a:	29c1                	addiw	s3,s3,16
    80004c4c:	05492783          	lw	a5,84(s2)
    80004c50:	fcf9ede3          	bltu	s3,a5,80004c2a <sys_unlink+0x140>
    80004c54:	b781                	j	80004b94 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c56:	00004517          	auipc	a0,0x4
    80004c5a:	a7a50513          	addi	a0,a0,-1414 # 800086d0 <syscalls+0x308>
    80004c5e:	00001097          	auipc	ra,0x1
    80004c62:	4de080e7          	jalr	1246(ra) # 8000613c <panic>
    panic("unlink: writei");
    80004c66:	00004517          	auipc	a0,0x4
    80004c6a:	a8250513          	addi	a0,a0,-1406 # 800086e8 <syscalls+0x320>
    80004c6e:	00001097          	auipc	ra,0x1
    80004c72:	4ce080e7          	jalr	1230(ra) # 8000613c <panic>
    dp->nlink--;
    80004c76:	0524d783          	lhu	a5,82(s1)
    80004c7a:	37fd                	addiw	a5,a5,-1
    80004c7c:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004c80:	8526                	mv	a0,s1
    80004c82:	ffffe097          	auipc	ra,0xffffe
    80004c86:	ffa080e7          	jalr	-6(ra) # 80002c7c <iupdate>
    80004c8a:	b781                	j	80004bca <sys_unlink+0xe0>
    return -1;
    80004c8c:	557d                	li	a0,-1
    80004c8e:	a005                	j	80004cae <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c90:	854a                	mv	a0,s2
    80004c92:	ffffe097          	auipc	ra,0xffffe
    80004c96:	316080e7          	jalr	790(ra) # 80002fa8 <iunlockput>
  iunlockput(dp);
    80004c9a:	8526                	mv	a0,s1
    80004c9c:	ffffe097          	auipc	ra,0xffffe
    80004ca0:	30c080e7          	jalr	780(ra) # 80002fa8 <iunlockput>
  end_op();
    80004ca4:	fffff097          	auipc	ra,0xfffff
    80004ca8:	af4080e7          	jalr	-1292(ra) # 80003798 <end_op>
  return -1;
    80004cac:	557d                	li	a0,-1
}
    80004cae:	70ae                	ld	ra,232(sp)
    80004cb0:	740e                	ld	s0,224(sp)
    80004cb2:	64ee                	ld	s1,216(sp)
    80004cb4:	694e                	ld	s2,208(sp)
    80004cb6:	69ae                	ld	s3,200(sp)
    80004cb8:	616d                	addi	sp,sp,240
    80004cba:	8082                	ret

0000000080004cbc <sys_open>:

uint64
sys_open(void)
{
    80004cbc:	7131                	addi	sp,sp,-192
    80004cbe:	fd06                	sd	ra,184(sp)
    80004cc0:	f922                	sd	s0,176(sp)
    80004cc2:	f526                	sd	s1,168(sp)
    80004cc4:	f14a                	sd	s2,160(sp)
    80004cc6:	ed4e                	sd	s3,152(sp)
    80004cc8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cca:	08000613          	li	a2,128
    80004cce:	f5040593          	addi	a1,s0,-176
    80004cd2:	4501                	li	a0,0
    80004cd4:	ffffd097          	auipc	ra,0xffffd
    80004cd8:	3f0080e7          	jalr	1008(ra) # 800020c4 <argstr>
    return -1;
    80004cdc:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cde:	0c054163          	bltz	a0,80004da0 <sys_open+0xe4>
    80004ce2:	f4c40593          	addi	a1,s0,-180
    80004ce6:	4505                	li	a0,1
    80004ce8:	ffffd097          	auipc	ra,0xffffd
    80004cec:	398080e7          	jalr	920(ra) # 80002080 <argint>
    80004cf0:	0a054863          	bltz	a0,80004da0 <sys_open+0xe4>

  begin_op();
    80004cf4:	fffff097          	auipc	ra,0xfffff
    80004cf8:	a24080e7          	jalr	-1500(ra) # 80003718 <begin_op>

  if(omode & O_CREATE){
    80004cfc:	f4c42783          	lw	a5,-180(s0)
    80004d00:	2007f793          	andi	a5,a5,512
    80004d04:	cbdd                	beqz	a5,80004dba <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d06:	4681                	li	a3,0
    80004d08:	4601                	li	a2,0
    80004d0a:	4589                	li	a1,2
    80004d0c:	f5040513          	addi	a0,s0,-176
    80004d10:	00000097          	auipc	ra,0x0
    80004d14:	972080e7          	jalr	-1678(ra) # 80004682 <create>
    80004d18:	892a                	mv	s2,a0
    if(ip == 0){
    80004d1a:	c959                	beqz	a0,80004db0 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d1c:	04c91703          	lh	a4,76(s2)
    80004d20:	478d                	li	a5,3
    80004d22:	00f71763          	bne	a4,a5,80004d30 <sys_open+0x74>
    80004d26:	04e95703          	lhu	a4,78(s2)
    80004d2a:	47a5                	li	a5,9
    80004d2c:	0ce7ec63          	bltu	a5,a4,80004e04 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d30:	fffff097          	auipc	ra,0xfffff
    80004d34:	df8080e7          	jalr	-520(ra) # 80003b28 <filealloc>
    80004d38:	89aa                	mv	s3,a0
    80004d3a:	10050263          	beqz	a0,80004e3e <sys_open+0x182>
    80004d3e:	00000097          	auipc	ra,0x0
    80004d42:	902080e7          	jalr	-1790(ra) # 80004640 <fdalloc>
    80004d46:	84aa                	mv	s1,a0
    80004d48:	0e054663          	bltz	a0,80004e34 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d4c:	04c91703          	lh	a4,76(s2)
    80004d50:	478d                	li	a5,3
    80004d52:	0cf70463          	beq	a4,a5,80004e1a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d56:	4789                	li	a5,2
    80004d58:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d5c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d60:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d64:	f4c42783          	lw	a5,-180(s0)
    80004d68:	0017c713          	xori	a4,a5,1
    80004d6c:	8b05                	andi	a4,a4,1
    80004d6e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d72:	0037f713          	andi	a4,a5,3
    80004d76:	00e03733          	snez	a4,a4
    80004d7a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d7e:	4007f793          	andi	a5,a5,1024
    80004d82:	c791                	beqz	a5,80004d8e <sys_open+0xd2>
    80004d84:	04c91703          	lh	a4,76(s2)
    80004d88:	4789                	li	a5,2
    80004d8a:	08f70f63          	beq	a4,a5,80004e28 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d8e:	854a                	mv	a0,s2
    80004d90:	ffffe097          	auipc	ra,0xffffe
    80004d94:	078080e7          	jalr	120(ra) # 80002e08 <iunlock>
  end_op();
    80004d98:	fffff097          	auipc	ra,0xfffff
    80004d9c:	a00080e7          	jalr	-1536(ra) # 80003798 <end_op>

  return fd;
}
    80004da0:	8526                	mv	a0,s1
    80004da2:	70ea                	ld	ra,184(sp)
    80004da4:	744a                	ld	s0,176(sp)
    80004da6:	74aa                	ld	s1,168(sp)
    80004da8:	790a                	ld	s2,160(sp)
    80004daa:	69ea                	ld	s3,152(sp)
    80004dac:	6129                	addi	sp,sp,192
    80004dae:	8082                	ret
      end_op();
    80004db0:	fffff097          	auipc	ra,0xfffff
    80004db4:	9e8080e7          	jalr	-1560(ra) # 80003798 <end_op>
      return -1;
    80004db8:	b7e5                	j	80004da0 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004dba:	f5040513          	addi	a0,s0,-176
    80004dbe:	ffffe097          	auipc	ra,0xffffe
    80004dc2:	73e080e7          	jalr	1854(ra) # 800034fc <namei>
    80004dc6:	892a                	mv	s2,a0
    80004dc8:	c905                	beqz	a0,80004df8 <sys_open+0x13c>
    ilock(ip);
    80004dca:	ffffe097          	auipc	ra,0xffffe
    80004dce:	f7c080e7          	jalr	-132(ra) # 80002d46 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004dd2:	04c91703          	lh	a4,76(s2)
    80004dd6:	4785                	li	a5,1
    80004dd8:	f4f712e3          	bne	a4,a5,80004d1c <sys_open+0x60>
    80004ddc:	f4c42783          	lw	a5,-180(s0)
    80004de0:	dba1                	beqz	a5,80004d30 <sys_open+0x74>
      iunlockput(ip);
    80004de2:	854a                	mv	a0,s2
    80004de4:	ffffe097          	auipc	ra,0xffffe
    80004de8:	1c4080e7          	jalr	452(ra) # 80002fa8 <iunlockput>
      end_op();
    80004dec:	fffff097          	auipc	ra,0xfffff
    80004df0:	9ac080e7          	jalr	-1620(ra) # 80003798 <end_op>
      return -1;
    80004df4:	54fd                	li	s1,-1
    80004df6:	b76d                	j	80004da0 <sys_open+0xe4>
      end_op();
    80004df8:	fffff097          	auipc	ra,0xfffff
    80004dfc:	9a0080e7          	jalr	-1632(ra) # 80003798 <end_op>
      return -1;
    80004e00:	54fd                	li	s1,-1
    80004e02:	bf79                	j	80004da0 <sys_open+0xe4>
    iunlockput(ip);
    80004e04:	854a                	mv	a0,s2
    80004e06:	ffffe097          	auipc	ra,0xffffe
    80004e0a:	1a2080e7          	jalr	418(ra) # 80002fa8 <iunlockput>
    end_op();
    80004e0e:	fffff097          	auipc	ra,0xfffff
    80004e12:	98a080e7          	jalr	-1654(ra) # 80003798 <end_op>
    return -1;
    80004e16:	54fd                	li	s1,-1
    80004e18:	b761                	j	80004da0 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e1a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e1e:	04e91783          	lh	a5,78(s2)
    80004e22:	02f99223          	sh	a5,36(s3)
    80004e26:	bf2d                	j	80004d60 <sys_open+0xa4>
    itrunc(ip);
    80004e28:	854a                	mv	a0,s2
    80004e2a:	ffffe097          	auipc	ra,0xffffe
    80004e2e:	02a080e7          	jalr	42(ra) # 80002e54 <itrunc>
    80004e32:	bfb1                	j	80004d8e <sys_open+0xd2>
      fileclose(f);
    80004e34:	854e                	mv	a0,s3
    80004e36:	fffff097          	auipc	ra,0xfffff
    80004e3a:	dae080e7          	jalr	-594(ra) # 80003be4 <fileclose>
    iunlockput(ip);
    80004e3e:	854a                	mv	a0,s2
    80004e40:	ffffe097          	auipc	ra,0xffffe
    80004e44:	168080e7          	jalr	360(ra) # 80002fa8 <iunlockput>
    end_op();
    80004e48:	fffff097          	auipc	ra,0xfffff
    80004e4c:	950080e7          	jalr	-1712(ra) # 80003798 <end_op>
    return -1;
    80004e50:	54fd                	li	s1,-1
    80004e52:	b7b9                	j	80004da0 <sys_open+0xe4>

0000000080004e54 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e54:	7175                	addi	sp,sp,-144
    80004e56:	e506                	sd	ra,136(sp)
    80004e58:	e122                	sd	s0,128(sp)
    80004e5a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e5c:	fffff097          	auipc	ra,0xfffff
    80004e60:	8bc080e7          	jalr	-1860(ra) # 80003718 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e64:	08000613          	li	a2,128
    80004e68:	f7040593          	addi	a1,s0,-144
    80004e6c:	4501                	li	a0,0
    80004e6e:	ffffd097          	auipc	ra,0xffffd
    80004e72:	256080e7          	jalr	598(ra) # 800020c4 <argstr>
    80004e76:	02054963          	bltz	a0,80004ea8 <sys_mkdir+0x54>
    80004e7a:	4681                	li	a3,0
    80004e7c:	4601                	li	a2,0
    80004e7e:	4585                	li	a1,1
    80004e80:	f7040513          	addi	a0,s0,-144
    80004e84:	fffff097          	auipc	ra,0xfffff
    80004e88:	7fe080e7          	jalr	2046(ra) # 80004682 <create>
    80004e8c:	cd11                	beqz	a0,80004ea8 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e8e:	ffffe097          	auipc	ra,0xffffe
    80004e92:	11a080e7          	jalr	282(ra) # 80002fa8 <iunlockput>
  end_op();
    80004e96:	fffff097          	auipc	ra,0xfffff
    80004e9a:	902080e7          	jalr	-1790(ra) # 80003798 <end_op>
  return 0;
    80004e9e:	4501                	li	a0,0
}
    80004ea0:	60aa                	ld	ra,136(sp)
    80004ea2:	640a                	ld	s0,128(sp)
    80004ea4:	6149                	addi	sp,sp,144
    80004ea6:	8082                	ret
    end_op();
    80004ea8:	fffff097          	auipc	ra,0xfffff
    80004eac:	8f0080e7          	jalr	-1808(ra) # 80003798 <end_op>
    return -1;
    80004eb0:	557d                	li	a0,-1
    80004eb2:	b7fd                	j	80004ea0 <sys_mkdir+0x4c>

0000000080004eb4 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004eb4:	7135                	addi	sp,sp,-160
    80004eb6:	ed06                	sd	ra,152(sp)
    80004eb8:	e922                	sd	s0,144(sp)
    80004eba:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004ebc:	fffff097          	auipc	ra,0xfffff
    80004ec0:	85c080e7          	jalr	-1956(ra) # 80003718 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ec4:	08000613          	li	a2,128
    80004ec8:	f7040593          	addi	a1,s0,-144
    80004ecc:	4501                	li	a0,0
    80004ece:	ffffd097          	auipc	ra,0xffffd
    80004ed2:	1f6080e7          	jalr	502(ra) # 800020c4 <argstr>
    80004ed6:	04054a63          	bltz	a0,80004f2a <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004eda:	f6c40593          	addi	a1,s0,-148
    80004ede:	4505                	li	a0,1
    80004ee0:	ffffd097          	auipc	ra,0xffffd
    80004ee4:	1a0080e7          	jalr	416(ra) # 80002080 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ee8:	04054163          	bltz	a0,80004f2a <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004eec:	f6840593          	addi	a1,s0,-152
    80004ef0:	4509                	li	a0,2
    80004ef2:	ffffd097          	auipc	ra,0xffffd
    80004ef6:	18e080e7          	jalr	398(ra) # 80002080 <argint>
     argint(1, &major) < 0 ||
    80004efa:	02054863          	bltz	a0,80004f2a <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004efe:	f6841683          	lh	a3,-152(s0)
    80004f02:	f6c41603          	lh	a2,-148(s0)
    80004f06:	458d                	li	a1,3
    80004f08:	f7040513          	addi	a0,s0,-144
    80004f0c:	fffff097          	auipc	ra,0xfffff
    80004f10:	776080e7          	jalr	1910(ra) # 80004682 <create>
     argint(2, &minor) < 0 ||
    80004f14:	c919                	beqz	a0,80004f2a <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f16:	ffffe097          	auipc	ra,0xffffe
    80004f1a:	092080e7          	jalr	146(ra) # 80002fa8 <iunlockput>
  end_op();
    80004f1e:	fffff097          	auipc	ra,0xfffff
    80004f22:	87a080e7          	jalr	-1926(ra) # 80003798 <end_op>
  return 0;
    80004f26:	4501                	li	a0,0
    80004f28:	a031                	j	80004f34 <sys_mknod+0x80>
    end_op();
    80004f2a:	fffff097          	auipc	ra,0xfffff
    80004f2e:	86e080e7          	jalr	-1938(ra) # 80003798 <end_op>
    return -1;
    80004f32:	557d                	li	a0,-1
}
    80004f34:	60ea                	ld	ra,152(sp)
    80004f36:	644a                	ld	s0,144(sp)
    80004f38:	610d                	addi	sp,sp,160
    80004f3a:	8082                	ret

0000000080004f3c <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f3c:	7135                	addi	sp,sp,-160
    80004f3e:	ed06                	sd	ra,152(sp)
    80004f40:	e922                	sd	s0,144(sp)
    80004f42:	e526                	sd	s1,136(sp)
    80004f44:	e14a                	sd	s2,128(sp)
    80004f46:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f48:	ffffc097          	auipc	ra,0xffffc
    80004f4c:	08c080e7          	jalr	140(ra) # 80000fd4 <myproc>
    80004f50:	892a                	mv	s2,a0
  
  begin_op();
    80004f52:	ffffe097          	auipc	ra,0xffffe
    80004f56:	7c6080e7          	jalr	1990(ra) # 80003718 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f5a:	08000613          	li	a2,128
    80004f5e:	f6040593          	addi	a1,s0,-160
    80004f62:	4501                	li	a0,0
    80004f64:	ffffd097          	auipc	ra,0xffffd
    80004f68:	160080e7          	jalr	352(ra) # 800020c4 <argstr>
    80004f6c:	04054b63          	bltz	a0,80004fc2 <sys_chdir+0x86>
    80004f70:	f6040513          	addi	a0,s0,-160
    80004f74:	ffffe097          	auipc	ra,0xffffe
    80004f78:	588080e7          	jalr	1416(ra) # 800034fc <namei>
    80004f7c:	84aa                	mv	s1,a0
    80004f7e:	c131                	beqz	a0,80004fc2 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f80:	ffffe097          	auipc	ra,0xffffe
    80004f84:	dc6080e7          	jalr	-570(ra) # 80002d46 <ilock>
  if(ip->type != T_DIR){
    80004f88:	04c49703          	lh	a4,76(s1)
    80004f8c:	4785                	li	a5,1
    80004f8e:	04f71063          	bne	a4,a5,80004fce <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f92:	8526                	mv	a0,s1
    80004f94:	ffffe097          	auipc	ra,0xffffe
    80004f98:	e74080e7          	jalr	-396(ra) # 80002e08 <iunlock>
  iput(p->cwd);
    80004f9c:	15893503          	ld	a0,344(s2)
    80004fa0:	ffffe097          	auipc	ra,0xffffe
    80004fa4:	f60080e7          	jalr	-160(ra) # 80002f00 <iput>
  end_op();
    80004fa8:	ffffe097          	auipc	ra,0xffffe
    80004fac:	7f0080e7          	jalr	2032(ra) # 80003798 <end_op>
  p->cwd = ip;
    80004fb0:	14993c23          	sd	s1,344(s2)
  return 0;
    80004fb4:	4501                	li	a0,0
}
    80004fb6:	60ea                	ld	ra,152(sp)
    80004fb8:	644a                	ld	s0,144(sp)
    80004fba:	64aa                	ld	s1,136(sp)
    80004fbc:	690a                	ld	s2,128(sp)
    80004fbe:	610d                	addi	sp,sp,160
    80004fc0:	8082                	ret
    end_op();
    80004fc2:	ffffe097          	auipc	ra,0xffffe
    80004fc6:	7d6080e7          	jalr	2006(ra) # 80003798 <end_op>
    return -1;
    80004fca:	557d                	li	a0,-1
    80004fcc:	b7ed                	j	80004fb6 <sys_chdir+0x7a>
    iunlockput(ip);
    80004fce:	8526                	mv	a0,s1
    80004fd0:	ffffe097          	auipc	ra,0xffffe
    80004fd4:	fd8080e7          	jalr	-40(ra) # 80002fa8 <iunlockput>
    end_op();
    80004fd8:	ffffe097          	auipc	ra,0xffffe
    80004fdc:	7c0080e7          	jalr	1984(ra) # 80003798 <end_op>
    return -1;
    80004fe0:	557d                	li	a0,-1
    80004fe2:	bfd1                	j	80004fb6 <sys_chdir+0x7a>

0000000080004fe4 <sys_exec>:

uint64
sys_exec(void)
{
    80004fe4:	7145                	addi	sp,sp,-464
    80004fe6:	e786                	sd	ra,456(sp)
    80004fe8:	e3a2                	sd	s0,448(sp)
    80004fea:	ff26                	sd	s1,440(sp)
    80004fec:	fb4a                	sd	s2,432(sp)
    80004fee:	f74e                	sd	s3,424(sp)
    80004ff0:	f352                	sd	s4,416(sp)
    80004ff2:	ef56                	sd	s5,408(sp)
    80004ff4:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004ff6:	08000613          	li	a2,128
    80004ffa:	f4040593          	addi	a1,s0,-192
    80004ffe:	4501                	li	a0,0
    80005000:	ffffd097          	auipc	ra,0xffffd
    80005004:	0c4080e7          	jalr	196(ra) # 800020c4 <argstr>
    return -1;
    80005008:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000500a:	0c054a63          	bltz	a0,800050de <sys_exec+0xfa>
    8000500e:	e3840593          	addi	a1,s0,-456
    80005012:	4505                	li	a0,1
    80005014:	ffffd097          	auipc	ra,0xffffd
    80005018:	08e080e7          	jalr	142(ra) # 800020a2 <argaddr>
    8000501c:	0c054163          	bltz	a0,800050de <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005020:	10000613          	li	a2,256
    80005024:	4581                	li	a1,0
    80005026:	e4040513          	addi	a0,s0,-448
    8000502a:	ffffb097          	auipc	ra,0xffffb
    8000502e:	2ca080e7          	jalr	714(ra) # 800002f4 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005032:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005036:	89a6                	mv	s3,s1
    80005038:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000503a:	02000a13          	li	s4,32
    8000503e:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005042:	00391513          	slli	a0,s2,0x3
    80005046:	e3040593          	addi	a1,s0,-464
    8000504a:	e3843783          	ld	a5,-456(s0)
    8000504e:	953e                	add	a0,a0,a5
    80005050:	ffffd097          	auipc	ra,0xffffd
    80005054:	f96080e7          	jalr	-106(ra) # 80001fe6 <fetchaddr>
    80005058:	02054a63          	bltz	a0,8000508c <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    8000505c:	e3043783          	ld	a5,-464(s0)
    80005060:	c3b9                	beqz	a5,800050a6 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005062:	ffffb097          	auipc	ra,0xffffb
    80005066:	192080e7          	jalr	402(ra) # 800001f4 <kalloc>
    8000506a:	85aa                	mv	a1,a0
    8000506c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005070:	cd11                	beqz	a0,8000508c <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005072:	6605                	lui	a2,0x1
    80005074:	e3043503          	ld	a0,-464(s0)
    80005078:	ffffd097          	auipc	ra,0xffffd
    8000507c:	fc0080e7          	jalr	-64(ra) # 80002038 <fetchstr>
    80005080:	00054663          	bltz	a0,8000508c <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005084:	0905                	addi	s2,s2,1
    80005086:	09a1                	addi	s3,s3,8
    80005088:	fb491be3          	bne	s2,s4,8000503e <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000508c:	10048913          	addi	s2,s1,256
    80005090:	6088                	ld	a0,0(s1)
    80005092:	c529                	beqz	a0,800050dc <sys_exec+0xf8>
    kfree(argv[i]);
    80005094:	ffffb097          	auipc	ra,0xffffb
    80005098:	080080e7          	jalr	128(ra) # 80000114 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000509c:	04a1                	addi	s1,s1,8
    8000509e:	ff2499e3          	bne	s1,s2,80005090 <sys_exec+0xac>
  return -1;
    800050a2:	597d                	li	s2,-1
    800050a4:	a82d                	j	800050de <sys_exec+0xfa>
      argv[i] = 0;
    800050a6:	0a8e                	slli	s5,s5,0x3
    800050a8:	fc040793          	addi	a5,s0,-64
    800050ac:	9abe                	add	s5,s5,a5
    800050ae:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800050b2:	e4040593          	addi	a1,s0,-448
    800050b6:	f4040513          	addi	a0,s0,-192
    800050ba:	fffff097          	auipc	ra,0xfffff
    800050be:	194080e7          	jalr	404(ra) # 8000424e <exec>
    800050c2:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050c4:	10048993          	addi	s3,s1,256
    800050c8:	6088                	ld	a0,0(s1)
    800050ca:	c911                	beqz	a0,800050de <sys_exec+0xfa>
    kfree(argv[i]);
    800050cc:	ffffb097          	auipc	ra,0xffffb
    800050d0:	048080e7          	jalr	72(ra) # 80000114 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050d4:	04a1                	addi	s1,s1,8
    800050d6:	ff3499e3          	bne	s1,s3,800050c8 <sys_exec+0xe4>
    800050da:	a011                	j	800050de <sys_exec+0xfa>
  return -1;
    800050dc:	597d                	li	s2,-1
}
    800050de:	854a                	mv	a0,s2
    800050e0:	60be                	ld	ra,456(sp)
    800050e2:	641e                	ld	s0,448(sp)
    800050e4:	74fa                	ld	s1,440(sp)
    800050e6:	795a                	ld	s2,432(sp)
    800050e8:	79ba                	ld	s3,424(sp)
    800050ea:	7a1a                	ld	s4,416(sp)
    800050ec:	6afa                	ld	s5,408(sp)
    800050ee:	6179                	addi	sp,sp,464
    800050f0:	8082                	ret

00000000800050f2 <sys_pipe>:

uint64
sys_pipe(void)
{
    800050f2:	7139                	addi	sp,sp,-64
    800050f4:	fc06                	sd	ra,56(sp)
    800050f6:	f822                	sd	s0,48(sp)
    800050f8:	f426                	sd	s1,40(sp)
    800050fa:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050fc:	ffffc097          	auipc	ra,0xffffc
    80005100:	ed8080e7          	jalr	-296(ra) # 80000fd4 <myproc>
    80005104:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005106:	fd840593          	addi	a1,s0,-40
    8000510a:	4501                	li	a0,0
    8000510c:	ffffd097          	auipc	ra,0xffffd
    80005110:	f96080e7          	jalr	-106(ra) # 800020a2 <argaddr>
    return -1;
    80005114:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005116:	0e054063          	bltz	a0,800051f6 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    8000511a:	fc840593          	addi	a1,s0,-56
    8000511e:	fd040513          	addi	a0,s0,-48
    80005122:	fffff097          	auipc	ra,0xfffff
    80005126:	df2080e7          	jalr	-526(ra) # 80003f14 <pipealloc>
    return -1;
    8000512a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000512c:	0c054563          	bltz	a0,800051f6 <sys_pipe+0x104>
  fd0 = -1;
    80005130:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005134:	fd043503          	ld	a0,-48(s0)
    80005138:	fffff097          	auipc	ra,0xfffff
    8000513c:	508080e7          	jalr	1288(ra) # 80004640 <fdalloc>
    80005140:	fca42223          	sw	a0,-60(s0)
    80005144:	08054c63          	bltz	a0,800051dc <sys_pipe+0xea>
    80005148:	fc843503          	ld	a0,-56(s0)
    8000514c:	fffff097          	auipc	ra,0xfffff
    80005150:	4f4080e7          	jalr	1268(ra) # 80004640 <fdalloc>
    80005154:	fca42023          	sw	a0,-64(s0)
    80005158:	06054863          	bltz	a0,800051c8 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000515c:	4691                	li	a3,4
    8000515e:	fc440613          	addi	a2,s0,-60
    80005162:	fd843583          	ld	a1,-40(s0)
    80005166:	6ca8                	ld	a0,88(s1)
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	b2e080e7          	jalr	-1234(ra) # 80000c96 <copyout>
    80005170:	02054063          	bltz	a0,80005190 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005174:	4691                	li	a3,4
    80005176:	fc040613          	addi	a2,s0,-64
    8000517a:	fd843583          	ld	a1,-40(s0)
    8000517e:	0591                	addi	a1,a1,4
    80005180:	6ca8                	ld	a0,88(s1)
    80005182:	ffffc097          	auipc	ra,0xffffc
    80005186:	b14080e7          	jalr	-1260(ra) # 80000c96 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000518a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000518c:	06055563          	bgez	a0,800051f6 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005190:	fc442783          	lw	a5,-60(s0)
    80005194:	07e9                	addi	a5,a5,26
    80005196:	078e                	slli	a5,a5,0x3
    80005198:	97a6                	add	a5,a5,s1
    8000519a:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    8000519e:	fc042503          	lw	a0,-64(s0)
    800051a2:	0569                	addi	a0,a0,26
    800051a4:	050e                	slli	a0,a0,0x3
    800051a6:	9526                	add	a0,a0,s1
    800051a8:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800051ac:	fd043503          	ld	a0,-48(s0)
    800051b0:	fffff097          	auipc	ra,0xfffff
    800051b4:	a34080e7          	jalr	-1484(ra) # 80003be4 <fileclose>
    fileclose(wf);
    800051b8:	fc843503          	ld	a0,-56(s0)
    800051bc:	fffff097          	auipc	ra,0xfffff
    800051c0:	a28080e7          	jalr	-1496(ra) # 80003be4 <fileclose>
    return -1;
    800051c4:	57fd                	li	a5,-1
    800051c6:	a805                	j	800051f6 <sys_pipe+0x104>
    if(fd0 >= 0)
    800051c8:	fc442783          	lw	a5,-60(s0)
    800051cc:	0007c863          	bltz	a5,800051dc <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800051d0:	01a78513          	addi	a0,a5,26
    800051d4:	050e                	slli	a0,a0,0x3
    800051d6:	9526                	add	a0,a0,s1
    800051d8:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800051dc:	fd043503          	ld	a0,-48(s0)
    800051e0:	fffff097          	auipc	ra,0xfffff
    800051e4:	a04080e7          	jalr	-1532(ra) # 80003be4 <fileclose>
    fileclose(wf);
    800051e8:	fc843503          	ld	a0,-56(s0)
    800051ec:	fffff097          	auipc	ra,0xfffff
    800051f0:	9f8080e7          	jalr	-1544(ra) # 80003be4 <fileclose>
    return -1;
    800051f4:	57fd                	li	a5,-1
}
    800051f6:	853e                	mv	a0,a5
    800051f8:	70e2                	ld	ra,56(sp)
    800051fa:	7442                	ld	s0,48(sp)
    800051fc:	74a2                	ld	s1,40(sp)
    800051fe:	6121                	addi	sp,sp,64
    80005200:	8082                	ret
	...

0000000080005210 <kernelvec>:
    80005210:	7111                	addi	sp,sp,-256
    80005212:	e006                	sd	ra,0(sp)
    80005214:	e40a                	sd	sp,8(sp)
    80005216:	e80e                	sd	gp,16(sp)
    80005218:	ec12                	sd	tp,24(sp)
    8000521a:	f016                	sd	t0,32(sp)
    8000521c:	f41a                	sd	t1,40(sp)
    8000521e:	f81e                	sd	t2,48(sp)
    80005220:	fc22                	sd	s0,56(sp)
    80005222:	e0a6                	sd	s1,64(sp)
    80005224:	e4aa                	sd	a0,72(sp)
    80005226:	e8ae                	sd	a1,80(sp)
    80005228:	ecb2                	sd	a2,88(sp)
    8000522a:	f0b6                	sd	a3,96(sp)
    8000522c:	f4ba                	sd	a4,104(sp)
    8000522e:	f8be                	sd	a5,112(sp)
    80005230:	fcc2                	sd	a6,120(sp)
    80005232:	e146                	sd	a7,128(sp)
    80005234:	e54a                	sd	s2,136(sp)
    80005236:	e94e                	sd	s3,144(sp)
    80005238:	ed52                	sd	s4,152(sp)
    8000523a:	f156                	sd	s5,160(sp)
    8000523c:	f55a                	sd	s6,168(sp)
    8000523e:	f95e                	sd	s7,176(sp)
    80005240:	fd62                	sd	s8,184(sp)
    80005242:	e1e6                	sd	s9,192(sp)
    80005244:	e5ea                	sd	s10,200(sp)
    80005246:	e9ee                	sd	s11,208(sp)
    80005248:	edf2                	sd	t3,216(sp)
    8000524a:	f1f6                	sd	t4,224(sp)
    8000524c:	f5fa                	sd	t5,232(sp)
    8000524e:	f9fe                	sd	t6,240(sp)
    80005250:	c63fc0ef          	jal	ra,80001eb2 <kerneltrap>
    80005254:	6082                	ld	ra,0(sp)
    80005256:	6122                	ld	sp,8(sp)
    80005258:	61c2                	ld	gp,16(sp)
    8000525a:	7282                	ld	t0,32(sp)
    8000525c:	7322                	ld	t1,40(sp)
    8000525e:	73c2                	ld	t2,48(sp)
    80005260:	7462                	ld	s0,56(sp)
    80005262:	6486                	ld	s1,64(sp)
    80005264:	6526                	ld	a0,72(sp)
    80005266:	65c6                	ld	a1,80(sp)
    80005268:	6666                	ld	a2,88(sp)
    8000526a:	7686                	ld	a3,96(sp)
    8000526c:	7726                	ld	a4,104(sp)
    8000526e:	77c6                	ld	a5,112(sp)
    80005270:	7866                	ld	a6,120(sp)
    80005272:	688a                	ld	a7,128(sp)
    80005274:	692a                	ld	s2,136(sp)
    80005276:	69ca                	ld	s3,144(sp)
    80005278:	6a6a                	ld	s4,152(sp)
    8000527a:	7a8a                	ld	s5,160(sp)
    8000527c:	7b2a                	ld	s6,168(sp)
    8000527e:	7bca                	ld	s7,176(sp)
    80005280:	7c6a                	ld	s8,184(sp)
    80005282:	6c8e                	ld	s9,192(sp)
    80005284:	6d2e                	ld	s10,200(sp)
    80005286:	6dce                	ld	s11,208(sp)
    80005288:	6e6e                	ld	t3,216(sp)
    8000528a:	7e8e                	ld	t4,224(sp)
    8000528c:	7f2e                	ld	t5,232(sp)
    8000528e:	7fce                	ld	t6,240(sp)
    80005290:	6111                	addi	sp,sp,256
    80005292:	10200073          	sret
    80005296:	00000013          	nop
    8000529a:	00000013          	nop
    8000529e:	0001                	nop

00000000800052a0 <timervec>:
    800052a0:	34051573          	csrrw	a0,mscratch,a0
    800052a4:	e10c                	sd	a1,0(a0)
    800052a6:	e510                	sd	a2,8(a0)
    800052a8:	e914                	sd	a3,16(a0)
    800052aa:	6d0c                	ld	a1,24(a0)
    800052ac:	7110                	ld	a2,32(a0)
    800052ae:	6194                	ld	a3,0(a1)
    800052b0:	96b2                	add	a3,a3,a2
    800052b2:	e194                	sd	a3,0(a1)
    800052b4:	4589                	li	a1,2
    800052b6:	14459073          	csrw	sip,a1
    800052ba:	6914                	ld	a3,16(a0)
    800052bc:	6510                	ld	a2,8(a0)
    800052be:	610c                	ld	a1,0(a0)
    800052c0:	34051573          	csrrw	a0,mscratch,a0
    800052c4:	30200073          	mret
	...

00000000800052ca <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052ca:	1141                	addi	sp,sp,-16
    800052cc:	e422                	sd	s0,8(sp)
    800052ce:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052d0:	0c0007b7          	lui	a5,0xc000
    800052d4:	4705                	li	a4,1
    800052d6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052d8:	c3d8                	sw	a4,4(a5)
}
    800052da:	6422                	ld	s0,8(sp)
    800052dc:	0141                	addi	sp,sp,16
    800052de:	8082                	ret

00000000800052e0 <plicinithart>:

void
plicinithart(void)
{
    800052e0:	1141                	addi	sp,sp,-16
    800052e2:	e406                	sd	ra,8(sp)
    800052e4:	e022                	sd	s0,0(sp)
    800052e6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052e8:	ffffc097          	auipc	ra,0xffffc
    800052ec:	cc0080e7          	jalr	-832(ra) # 80000fa8 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052f0:	0085171b          	slliw	a4,a0,0x8
    800052f4:	0c0027b7          	lui	a5,0xc002
    800052f8:	97ba                	add	a5,a5,a4
    800052fa:	40200713          	li	a4,1026
    800052fe:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005302:	00d5151b          	slliw	a0,a0,0xd
    80005306:	0c2017b7          	lui	a5,0xc201
    8000530a:	953e                	add	a0,a0,a5
    8000530c:	00052023          	sw	zero,0(a0)
}
    80005310:	60a2                	ld	ra,8(sp)
    80005312:	6402                	ld	s0,0(sp)
    80005314:	0141                	addi	sp,sp,16
    80005316:	8082                	ret

0000000080005318 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005318:	1141                	addi	sp,sp,-16
    8000531a:	e406                	sd	ra,8(sp)
    8000531c:	e022                	sd	s0,0(sp)
    8000531e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005320:	ffffc097          	auipc	ra,0xffffc
    80005324:	c88080e7          	jalr	-888(ra) # 80000fa8 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005328:	00d5179b          	slliw	a5,a0,0xd
    8000532c:	0c201537          	lui	a0,0xc201
    80005330:	953e                	add	a0,a0,a5
  return irq;
}
    80005332:	4148                	lw	a0,4(a0)
    80005334:	60a2                	ld	ra,8(sp)
    80005336:	6402                	ld	s0,0(sp)
    80005338:	0141                	addi	sp,sp,16
    8000533a:	8082                	ret

000000008000533c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000533c:	1101                	addi	sp,sp,-32
    8000533e:	ec06                	sd	ra,24(sp)
    80005340:	e822                	sd	s0,16(sp)
    80005342:	e426                	sd	s1,8(sp)
    80005344:	1000                	addi	s0,sp,32
    80005346:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005348:	ffffc097          	auipc	ra,0xffffc
    8000534c:	c60080e7          	jalr	-928(ra) # 80000fa8 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005350:	00d5151b          	slliw	a0,a0,0xd
    80005354:	0c2017b7          	lui	a5,0xc201
    80005358:	97aa                	add	a5,a5,a0
    8000535a:	c3c4                	sw	s1,4(a5)
}
    8000535c:	60e2                	ld	ra,24(sp)
    8000535e:	6442                	ld	s0,16(sp)
    80005360:	64a2                	ld	s1,8(sp)
    80005362:	6105                	addi	sp,sp,32
    80005364:	8082                	ret

0000000080005366 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005366:	1141                	addi	sp,sp,-16
    80005368:	e406                	sd	ra,8(sp)
    8000536a:	e022                	sd	s0,0(sp)
    8000536c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000536e:	479d                	li	a5,7
    80005370:	06a7c963          	blt	a5,a0,800053e2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005374:	0001a797          	auipc	a5,0x1a
    80005378:	c8c78793          	addi	a5,a5,-884 # 8001f000 <disk>
    8000537c:	00a78733          	add	a4,a5,a0
    80005380:	6789                	lui	a5,0x2
    80005382:	97ba                	add	a5,a5,a4
    80005384:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005388:	e7ad                	bnez	a5,800053f2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000538a:	00451793          	slli	a5,a0,0x4
    8000538e:	0001c717          	auipc	a4,0x1c
    80005392:	c7270713          	addi	a4,a4,-910 # 80021000 <disk+0x2000>
    80005396:	6314                	ld	a3,0(a4)
    80005398:	96be                	add	a3,a3,a5
    8000539a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000539e:	6314                	ld	a3,0(a4)
    800053a0:	96be                	add	a3,a3,a5
    800053a2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800053a6:	6314                	ld	a3,0(a4)
    800053a8:	96be                	add	a3,a3,a5
    800053aa:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800053ae:	6318                	ld	a4,0(a4)
    800053b0:	97ba                	add	a5,a5,a4
    800053b2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800053b6:	0001a797          	auipc	a5,0x1a
    800053ba:	c4a78793          	addi	a5,a5,-950 # 8001f000 <disk>
    800053be:	97aa                	add	a5,a5,a0
    800053c0:	6509                	lui	a0,0x2
    800053c2:	953e                	add	a0,a0,a5
    800053c4:	4785                	li	a5,1
    800053c6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800053ca:	0001c517          	auipc	a0,0x1c
    800053ce:	c4e50513          	addi	a0,a0,-946 # 80021018 <disk+0x2018>
    800053d2:	ffffc097          	auipc	ra,0xffffc
    800053d6:	44a080e7          	jalr	1098(ra) # 8000181c <wakeup>
}
    800053da:	60a2                	ld	ra,8(sp)
    800053dc:	6402                	ld	s0,0(sp)
    800053de:	0141                	addi	sp,sp,16
    800053e0:	8082                	ret
    panic("free_desc 1");
    800053e2:	00003517          	auipc	a0,0x3
    800053e6:	31650513          	addi	a0,a0,790 # 800086f8 <syscalls+0x330>
    800053ea:	00001097          	auipc	ra,0x1
    800053ee:	d52080e7          	jalr	-686(ra) # 8000613c <panic>
    panic("free_desc 2");
    800053f2:	00003517          	auipc	a0,0x3
    800053f6:	31650513          	addi	a0,a0,790 # 80008708 <syscalls+0x340>
    800053fa:	00001097          	auipc	ra,0x1
    800053fe:	d42080e7          	jalr	-702(ra) # 8000613c <panic>

0000000080005402 <virtio_disk_init>:
{
    80005402:	1101                	addi	sp,sp,-32
    80005404:	ec06                	sd	ra,24(sp)
    80005406:	e822                	sd	s0,16(sp)
    80005408:	e426                	sd	s1,8(sp)
    8000540a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000540c:	00003597          	auipc	a1,0x3
    80005410:	30c58593          	addi	a1,a1,780 # 80008718 <syscalls+0x350>
    80005414:	0001c517          	auipc	a0,0x1c
    80005418:	d1450513          	addi	a0,a0,-748 # 80021128 <disk+0x2128>
    8000541c:	00001097          	auipc	ra,0x1
    80005420:	3d0080e7          	jalr	976(ra) # 800067ec <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005424:	100017b7          	lui	a5,0x10001
    80005428:	4398                	lw	a4,0(a5)
    8000542a:	2701                	sext.w	a4,a4
    8000542c:	747277b7          	lui	a5,0x74727
    80005430:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005434:	0ef71163          	bne	a4,a5,80005516 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005438:	100017b7          	lui	a5,0x10001
    8000543c:	43dc                	lw	a5,4(a5)
    8000543e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005440:	4705                	li	a4,1
    80005442:	0ce79a63          	bne	a5,a4,80005516 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005446:	100017b7          	lui	a5,0x10001
    8000544a:	479c                	lw	a5,8(a5)
    8000544c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000544e:	4709                	li	a4,2
    80005450:	0ce79363          	bne	a5,a4,80005516 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005454:	100017b7          	lui	a5,0x10001
    80005458:	47d8                	lw	a4,12(a5)
    8000545a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000545c:	554d47b7          	lui	a5,0x554d4
    80005460:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005464:	0af71963          	bne	a4,a5,80005516 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005468:	100017b7          	lui	a5,0x10001
    8000546c:	4705                	li	a4,1
    8000546e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005470:	470d                	li	a4,3
    80005472:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005474:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005476:	c7ffe737          	lui	a4,0xc7ffe
    8000547a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd2517>
    8000547e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005480:	2701                	sext.w	a4,a4
    80005482:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005484:	472d                	li	a4,11
    80005486:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005488:	473d                	li	a4,15
    8000548a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000548c:	6705                	lui	a4,0x1
    8000548e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005490:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005494:	5bdc                	lw	a5,52(a5)
    80005496:	2781                	sext.w	a5,a5
  if(max == 0)
    80005498:	c7d9                	beqz	a5,80005526 <virtio_disk_init+0x124>
  if(max < NUM)
    8000549a:	471d                	li	a4,7
    8000549c:	08f77d63          	bgeu	a4,a5,80005536 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054a0:	100014b7          	lui	s1,0x10001
    800054a4:	47a1                	li	a5,8
    800054a6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800054a8:	6609                	lui	a2,0x2
    800054aa:	4581                	li	a1,0
    800054ac:	0001a517          	auipc	a0,0x1a
    800054b0:	b5450513          	addi	a0,a0,-1196 # 8001f000 <disk>
    800054b4:	ffffb097          	auipc	ra,0xffffb
    800054b8:	e40080e7          	jalr	-448(ra) # 800002f4 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800054bc:	0001a717          	auipc	a4,0x1a
    800054c0:	b4470713          	addi	a4,a4,-1212 # 8001f000 <disk>
    800054c4:	00c75793          	srli	a5,a4,0xc
    800054c8:	2781                	sext.w	a5,a5
    800054ca:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800054cc:	0001c797          	auipc	a5,0x1c
    800054d0:	b3478793          	addi	a5,a5,-1228 # 80021000 <disk+0x2000>
    800054d4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800054d6:	0001a717          	auipc	a4,0x1a
    800054da:	baa70713          	addi	a4,a4,-1110 # 8001f080 <disk+0x80>
    800054de:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800054e0:	0001b717          	auipc	a4,0x1b
    800054e4:	b2070713          	addi	a4,a4,-1248 # 80020000 <disk+0x1000>
    800054e8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054ea:	4705                	li	a4,1
    800054ec:	00e78c23          	sb	a4,24(a5)
    800054f0:	00e78ca3          	sb	a4,25(a5)
    800054f4:	00e78d23          	sb	a4,26(a5)
    800054f8:	00e78da3          	sb	a4,27(a5)
    800054fc:	00e78e23          	sb	a4,28(a5)
    80005500:	00e78ea3          	sb	a4,29(a5)
    80005504:	00e78f23          	sb	a4,30(a5)
    80005508:	00e78fa3          	sb	a4,31(a5)
}
    8000550c:	60e2                	ld	ra,24(sp)
    8000550e:	6442                	ld	s0,16(sp)
    80005510:	64a2                	ld	s1,8(sp)
    80005512:	6105                	addi	sp,sp,32
    80005514:	8082                	ret
    panic("could not find virtio disk");
    80005516:	00003517          	auipc	a0,0x3
    8000551a:	21250513          	addi	a0,a0,530 # 80008728 <syscalls+0x360>
    8000551e:	00001097          	auipc	ra,0x1
    80005522:	c1e080e7          	jalr	-994(ra) # 8000613c <panic>
    panic("virtio disk has no queue 0");
    80005526:	00003517          	auipc	a0,0x3
    8000552a:	22250513          	addi	a0,a0,546 # 80008748 <syscalls+0x380>
    8000552e:	00001097          	auipc	ra,0x1
    80005532:	c0e080e7          	jalr	-1010(ra) # 8000613c <panic>
    panic("virtio disk max queue too short");
    80005536:	00003517          	auipc	a0,0x3
    8000553a:	23250513          	addi	a0,a0,562 # 80008768 <syscalls+0x3a0>
    8000553e:	00001097          	auipc	ra,0x1
    80005542:	bfe080e7          	jalr	-1026(ra) # 8000613c <panic>

0000000080005546 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005546:	7159                	addi	sp,sp,-112
    80005548:	f486                	sd	ra,104(sp)
    8000554a:	f0a2                	sd	s0,96(sp)
    8000554c:	eca6                	sd	s1,88(sp)
    8000554e:	e8ca                	sd	s2,80(sp)
    80005550:	e4ce                	sd	s3,72(sp)
    80005552:	e0d2                	sd	s4,64(sp)
    80005554:	fc56                	sd	s5,56(sp)
    80005556:	f85a                	sd	s6,48(sp)
    80005558:	f45e                	sd	s7,40(sp)
    8000555a:	f062                	sd	s8,32(sp)
    8000555c:	ec66                	sd	s9,24(sp)
    8000555e:	e86a                	sd	s10,16(sp)
    80005560:	1880                	addi	s0,sp,112
    80005562:	892a                	mv	s2,a0
    80005564:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005566:	00c52c83          	lw	s9,12(a0)
    8000556a:	001c9c9b          	slliw	s9,s9,0x1
    8000556e:	1c82                	slli	s9,s9,0x20
    80005570:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005574:	0001c517          	auipc	a0,0x1c
    80005578:	bb450513          	addi	a0,a0,-1100 # 80021128 <disk+0x2128>
    8000557c:	00001097          	auipc	ra,0x1
    80005580:	0f4080e7          	jalr	244(ra) # 80006670 <acquire>
  for(int i = 0; i < 3; i++){
    80005584:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005586:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005588:	0001ab97          	auipc	s7,0x1a
    8000558c:	a78b8b93          	addi	s7,s7,-1416 # 8001f000 <disk>
    80005590:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005592:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005594:	8a4e                	mv	s4,s3
    80005596:	a051                	j	8000561a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005598:	00fb86b3          	add	a3,s7,a5
    8000559c:	96da                	add	a3,a3,s6
    8000559e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800055a2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800055a4:	0207c563          	bltz	a5,800055ce <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800055a8:	2485                	addiw	s1,s1,1
    800055aa:	0711                	addi	a4,a4,4
    800055ac:	25548063          	beq	s1,s5,800057ec <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800055b0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800055b2:	0001c697          	auipc	a3,0x1c
    800055b6:	a6668693          	addi	a3,a3,-1434 # 80021018 <disk+0x2018>
    800055ba:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800055bc:	0006c583          	lbu	a1,0(a3)
    800055c0:	fde1                	bnez	a1,80005598 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800055c2:	2785                	addiw	a5,a5,1
    800055c4:	0685                	addi	a3,a3,1
    800055c6:	ff879be3          	bne	a5,s8,800055bc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800055ca:	57fd                	li	a5,-1
    800055cc:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800055ce:	02905a63          	blez	s1,80005602 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055d2:	f9042503          	lw	a0,-112(s0)
    800055d6:	00000097          	auipc	ra,0x0
    800055da:	d90080e7          	jalr	-624(ra) # 80005366 <free_desc>
      for(int j = 0; j < i; j++)
    800055de:	4785                	li	a5,1
    800055e0:	0297d163          	bge	a5,s1,80005602 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055e4:	f9442503          	lw	a0,-108(s0)
    800055e8:	00000097          	auipc	ra,0x0
    800055ec:	d7e080e7          	jalr	-642(ra) # 80005366 <free_desc>
      for(int j = 0; j < i; j++)
    800055f0:	4789                	li	a5,2
    800055f2:	0097d863          	bge	a5,s1,80005602 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055f6:	f9842503          	lw	a0,-104(s0)
    800055fa:	00000097          	auipc	ra,0x0
    800055fe:	d6c080e7          	jalr	-660(ra) # 80005366 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005602:	0001c597          	auipc	a1,0x1c
    80005606:	b2658593          	addi	a1,a1,-1242 # 80021128 <disk+0x2128>
    8000560a:	0001c517          	auipc	a0,0x1c
    8000560e:	a0e50513          	addi	a0,a0,-1522 # 80021018 <disk+0x2018>
    80005612:	ffffc097          	auipc	ra,0xffffc
    80005616:	07e080e7          	jalr	126(ra) # 80001690 <sleep>
  for(int i = 0; i < 3; i++){
    8000561a:	f9040713          	addi	a4,s0,-112
    8000561e:	84ce                	mv	s1,s3
    80005620:	bf41                	j	800055b0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005622:	20058713          	addi	a4,a1,512
    80005626:	00471693          	slli	a3,a4,0x4
    8000562a:	0001a717          	auipc	a4,0x1a
    8000562e:	9d670713          	addi	a4,a4,-1578 # 8001f000 <disk>
    80005632:	9736                	add	a4,a4,a3
    80005634:	4685                	li	a3,1
    80005636:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000563a:	20058713          	addi	a4,a1,512
    8000563e:	00471693          	slli	a3,a4,0x4
    80005642:	0001a717          	auipc	a4,0x1a
    80005646:	9be70713          	addi	a4,a4,-1602 # 8001f000 <disk>
    8000564a:	9736                	add	a4,a4,a3
    8000564c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005650:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005654:	7679                	lui	a2,0xffffe
    80005656:	963e                	add	a2,a2,a5
    80005658:	0001c697          	auipc	a3,0x1c
    8000565c:	9a868693          	addi	a3,a3,-1624 # 80021000 <disk+0x2000>
    80005660:	6298                	ld	a4,0(a3)
    80005662:	9732                	add	a4,a4,a2
    80005664:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005666:	6298                	ld	a4,0(a3)
    80005668:	9732                	add	a4,a4,a2
    8000566a:	4541                	li	a0,16
    8000566c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000566e:	6298                	ld	a4,0(a3)
    80005670:	9732                	add	a4,a4,a2
    80005672:	4505                	li	a0,1
    80005674:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005678:	f9442703          	lw	a4,-108(s0)
    8000567c:	6288                	ld	a0,0(a3)
    8000567e:	962a                	add	a2,a2,a0
    80005680:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd1dc6>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005684:	0712                	slli	a4,a4,0x4
    80005686:	6290                	ld	a2,0(a3)
    80005688:	963a                	add	a2,a2,a4
    8000568a:	05090513          	addi	a0,s2,80
    8000568e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005690:	6294                	ld	a3,0(a3)
    80005692:	96ba                	add	a3,a3,a4
    80005694:	40000613          	li	a2,1024
    80005698:	c690                	sw	a2,8(a3)
  if(write)
    8000569a:	140d0063          	beqz	s10,800057da <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000569e:	0001c697          	auipc	a3,0x1c
    800056a2:	9626b683          	ld	a3,-1694(a3) # 80021000 <disk+0x2000>
    800056a6:	96ba                	add	a3,a3,a4
    800056a8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056ac:	0001a817          	auipc	a6,0x1a
    800056b0:	95480813          	addi	a6,a6,-1708 # 8001f000 <disk>
    800056b4:	0001c517          	auipc	a0,0x1c
    800056b8:	94c50513          	addi	a0,a0,-1716 # 80021000 <disk+0x2000>
    800056bc:	6114                	ld	a3,0(a0)
    800056be:	96ba                	add	a3,a3,a4
    800056c0:	00c6d603          	lhu	a2,12(a3)
    800056c4:	00166613          	ori	a2,a2,1
    800056c8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800056cc:	f9842683          	lw	a3,-104(s0)
    800056d0:	6110                	ld	a2,0(a0)
    800056d2:	9732                	add	a4,a4,a2
    800056d4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056d8:	20058613          	addi	a2,a1,512
    800056dc:	0612                	slli	a2,a2,0x4
    800056de:	9642                	add	a2,a2,a6
    800056e0:	577d                	li	a4,-1
    800056e2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056e6:	00469713          	slli	a4,a3,0x4
    800056ea:	6114                	ld	a3,0(a0)
    800056ec:	96ba                	add	a3,a3,a4
    800056ee:	03078793          	addi	a5,a5,48
    800056f2:	97c2                	add	a5,a5,a6
    800056f4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    800056f6:	611c                	ld	a5,0(a0)
    800056f8:	97ba                	add	a5,a5,a4
    800056fa:	4685                	li	a3,1
    800056fc:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056fe:	611c                	ld	a5,0(a0)
    80005700:	97ba                	add	a5,a5,a4
    80005702:	4809                	li	a6,2
    80005704:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005708:	611c                	ld	a5,0(a0)
    8000570a:	973e                	add	a4,a4,a5
    8000570c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005710:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005714:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005718:	6518                	ld	a4,8(a0)
    8000571a:	00275783          	lhu	a5,2(a4)
    8000571e:	8b9d                	andi	a5,a5,7
    80005720:	0786                	slli	a5,a5,0x1
    80005722:	97ba                	add	a5,a5,a4
    80005724:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005728:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000572c:	6518                	ld	a4,8(a0)
    8000572e:	00275783          	lhu	a5,2(a4)
    80005732:	2785                	addiw	a5,a5,1
    80005734:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005738:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000573c:	100017b7          	lui	a5,0x10001
    80005740:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005744:	00492703          	lw	a4,4(s2)
    80005748:	4785                	li	a5,1
    8000574a:	02f71163          	bne	a4,a5,8000576c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000574e:	0001c997          	auipc	s3,0x1c
    80005752:	9da98993          	addi	s3,s3,-1574 # 80021128 <disk+0x2128>
  while(b->disk == 1) {
    80005756:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005758:	85ce                	mv	a1,s3
    8000575a:	854a                	mv	a0,s2
    8000575c:	ffffc097          	auipc	ra,0xffffc
    80005760:	f34080e7          	jalr	-204(ra) # 80001690 <sleep>
  while(b->disk == 1) {
    80005764:	00492783          	lw	a5,4(s2)
    80005768:	fe9788e3          	beq	a5,s1,80005758 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000576c:	f9042903          	lw	s2,-112(s0)
    80005770:	20090793          	addi	a5,s2,512
    80005774:	00479713          	slli	a4,a5,0x4
    80005778:	0001a797          	auipc	a5,0x1a
    8000577c:	88878793          	addi	a5,a5,-1912 # 8001f000 <disk>
    80005780:	97ba                	add	a5,a5,a4
    80005782:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005786:	0001c997          	auipc	s3,0x1c
    8000578a:	87a98993          	addi	s3,s3,-1926 # 80021000 <disk+0x2000>
    8000578e:	00491713          	slli	a4,s2,0x4
    80005792:	0009b783          	ld	a5,0(s3)
    80005796:	97ba                	add	a5,a5,a4
    80005798:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000579c:	854a                	mv	a0,s2
    8000579e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057a2:	00000097          	auipc	ra,0x0
    800057a6:	bc4080e7          	jalr	-1084(ra) # 80005366 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057aa:	8885                	andi	s1,s1,1
    800057ac:	f0ed                	bnez	s1,8000578e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057ae:	0001c517          	auipc	a0,0x1c
    800057b2:	97a50513          	addi	a0,a0,-1670 # 80021128 <disk+0x2128>
    800057b6:	00001097          	auipc	ra,0x1
    800057ba:	f8a080e7          	jalr	-118(ra) # 80006740 <release>
}
    800057be:	70a6                	ld	ra,104(sp)
    800057c0:	7406                	ld	s0,96(sp)
    800057c2:	64e6                	ld	s1,88(sp)
    800057c4:	6946                	ld	s2,80(sp)
    800057c6:	69a6                	ld	s3,72(sp)
    800057c8:	6a06                	ld	s4,64(sp)
    800057ca:	7ae2                	ld	s5,56(sp)
    800057cc:	7b42                	ld	s6,48(sp)
    800057ce:	7ba2                	ld	s7,40(sp)
    800057d0:	7c02                	ld	s8,32(sp)
    800057d2:	6ce2                	ld	s9,24(sp)
    800057d4:	6d42                	ld	s10,16(sp)
    800057d6:	6165                	addi	sp,sp,112
    800057d8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800057da:	0001c697          	auipc	a3,0x1c
    800057de:	8266b683          	ld	a3,-2010(a3) # 80021000 <disk+0x2000>
    800057e2:	96ba                	add	a3,a3,a4
    800057e4:	4609                	li	a2,2
    800057e6:	00c69623          	sh	a2,12(a3)
    800057ea:	b5c9                	j	800056ac <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057ec:	f9042583          	lw	a1,-112(s0)
    800057f0:	20058793          	addi	a5,a1,512
    800057f4:	0792                	slli	a5,a5,0x4
    800057f6:	0001a517          	auipc	a0,0x1a
    800057fa:	8b250513          	addi	a0,a0,-1870 # 8001f0a8 <disk+0xa8>
    800057fe:	953e                	add	a0,a0,a5
  if(write)
    80005800:	e20d11e3          	bnez	s10,80005622 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005804:	20058713          	addi	a4,a1,512
    80005808:	00471693          	slli	a3,a4,0x4
    8000580c:	00019717          	auipc	a4,0x19
    80005810:	7f470713          	addi	a4,a4,2036 # 8001f000 <disk>
    80005814:	9736                	add	a4,a4,a3
    80005816:	0a072423          	sw	zero,168(a4)
    8000581a:	b505                	j	8000563a <virtio_disk_rw+0xf4>

000000008000581c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000581c:	1101                	addi	sp,sp,-32
    8000581e:	ec06                	sd	ra,24(sp)
    80005820:	e822                	sd	s0,16(sp)
    80005822:	e426                	sd	s1,8(sp)
    80005824:	e04a                	sd	s2,0(sp)
    80005826:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005828:	0001c517          	auipc	a0,0x1c
    8000582c:	90050513          	addi	a0,a0,-1792 # 80021128 <disk+0x2128>
    80005830:	00001097          	auipc	ra,0x1
    80005834:	e40080e7          	jalr	-448(ra) # 80006670 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005838:	10001737          	lui	a4,0x10001
    8000583c:	533c                	lw	a5,96(a4)
    8000583e:	8b8d                	andi	a5,a5,3
    80005840:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005842:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005846:	0001b797          	auipc	a5,0x1b
    8000584a:	7ba78793          	addi	a5,a5,1978 # 80021000 <disk+0x2000>
    8000584e:	6b94                	ld	a3,16(a5)
    80005850:	0207d703          	lhu	a4,32(a5)
    80005854:	0026d783          	lhu	a5,2(a3)
    80005858:	06f70163          	beq	a4,a5,800058ba <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000585c:	00019917          	auipc	s2,0x19
    80005860:	7a490913          	addi	s2,s2,1956 # 8001f000 <disk>
    80005864:	0001b497          	auipc	s1,0x1b
    80005868:	79c48493          	addi	s1,s1,1948 # 80021000 <disk+0x2000>
    __sync_synchronize();
    8000586c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005870:	6898                	ld	a4,16(s1)
    80005872:	0204d783          	lhu	a5,32(s1)
    80005876:	8b9d                	andi	a5,a5,7
    80005878:	078e                	slli	a5,a5,0x3
    8000587a:	97ba                	add	a5,a5,a4
    8000587c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000587e:	20078713          	addi	a4,a5,512
    80005882:	0712                	slli	a4,a4,0x4
    80005884:	974a                	add	a4,a4,s2
    80005886:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000588a:	e731                	bnez	a4,800058d6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000588c:	20078793          	addi	a5,a5,512
    80005890:	0792                	slli	a5,a5,0x4
    80005892:	97ca                	add	a5,a5,s2
    80005894:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005896:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000589a:	ffffc097          	auipc	ra,0xffffc
    8000589e:	f82080e7          	jalr	-126(ra) # 8000181c <wakeup>

    disk.used_idx += 1;
    800058a2:	0204d783          	lhu	a5,32(s1)
    800058a6:	2785                	addiw	a5,a5,1
    800058a8:	17c2                	slli	a5,a5,0x30
    800058aa:	93c1                	srli	a5,a5,0x30
    800058ac:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058b0:	6898                	ld	a4,16(s1)
    800058b2:	00275703          	lhu	a4,2(a4)
    800058b6:	faf71be3          	bne	a4,a5,8000586c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800058ba:	0001c517          	auipc	a0,0x1c
    800058be:	86e50513          	addi	a0,a0,-1938 # 80021128 <disk+0x2128>
    800058c2:	00001097          	auipc	ra,0x1
    800058c6:	e7e080e7          	jalr	-386(ra) # 80006740 <release>
}
    800058ca:	60e2                	ld	ra,24(sp)
    800058cc:	6442                	ld	s0,16(sp)
    800058ce:	64a2                	ld	s1,8(sp)
    800058d0:	6902                	ld	s2,0(sp)
    800058d2:	6105                	addi	sp,sp,32
    800058d4:	8082                	ret
      panic("virtio_disk_intr status");
    800058d6:	00003517          	auipc	a0,0x3
    800058da:	eb250513          	addi	a0,a0,-334 # 80008788 <syscalls+0x3c0>
    800058de:	00001097          	auipc	ra,0x1
    800058e2:	85e080e7          	jalr	-1954(ra) # 8000613c <panic>

00000000800058e6 <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    800058e6:	1141                	addi	sp,sp,-16
    800058e8:	e422                	sd	s0,8(sp)
    800058ea:	0800                	addi	s0,sp,16
  return -1;
}
    800058ec:	557d                	li	a0,-1
    800058ee:	6422                	ld	s0,8(sp)
    800058f0:	0141                	addi	sp,sp,16
    800058f2:	8082                	ret

00000000800058f4 <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    800058f4:	7179                	addi	sp,sp,-48
    800058f6:	f406                	sd	ra,40(sp)
    800058f8:	f022                	sd	s0,32(sp)
    800058fa:	ec26                	sd	s1,24(sp)
    800058fc:	e84a                	sd	s2,16(sp)
    800058fe:	e44e                	sd	s3,8(sp)
    80005900:	e052                	sd	s4,0(sp)
    80005902:	1800                	addi	s0,sp,48
    80005904:	892a                	mv	s2,a0
    80005906:	89ae                	mv	s3,a1
    80005908:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    8000590a:	0001c517          	auipc	a0,0x1c
    8000590e:	6f650513          	addi	a0,a0,1782 # 80022000 <stats>
    80005912:	00001097          	auipc	ra,0x1
    80005916:	d5e080e7          	jalr	-674(ra) # 80006670 <acquire>

  if(stats.sz == 0) {
    8000591a:	0001d797          	auipc	a5,0x1d
    8000591e:	7067a783          	lw	a5,1798(a5) # 80023020 <stats+0x1020>
    80005922:	cbb5                	beqz	a5,80005996 <statsread+0xa2>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    80005924:	0001d797          	auipc	a5,0x1d
    80005928:	6dc78793          	addi	a5,a5,1756 # 80023000 <stats+0x1000>
    8000592c:	53d8                	lw	a4,36(a5)
    8000592e:	539c                	lw	a5,32(a5)
    80005930:	9f99                	subw	a5,a5,a4
    80005932:	0007869b          	sext.w	a3,a5

  if (m > 0) {
    80005936:	06d05e63          	blez	a3,800059b2 <statsread+0xbe>
    if(m > n)
    8000593a:	8a3e                	mv	s4,a5
    8000593c:	00d4d363          	bge	s1,a3,80005942 <statsread+0x4e>
    80005940:	8a26                	mv	s4,s1
    80005942:	000a049b          	sext.w	s1,s4
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    80005946:	86a6                	mv	a3,s1
    80005948:	0001c617          	auipc	a2,0x1c
    8000594c:	6d860613          	addi	a2,a2,1752 # 80022020 <stats+0x20>
    80005950:	963a                	add	a2,a2,a4
    80005952:	85ce                	mv	a1,s3
    80005954:	854a                	mv	a0,s2
    80005956:	ffffc097          	auipc	ra,0xffffc
    8000595a:	0de080e7          	jalr	222(ra) # 80001a34 <either_copyout>
    8000595e:	57fd                	li	a5,-1
    80005960:	00f50a63          	beq	a0,a5,80005974 <statsread+0x80>
      stats.off += m;
    80005964:	0001d717          	auipc	a4,0x1d
    80005968:	69c70713          	addi	a4,a4,1692 # 80023000 <stats+0x1000>
    8000596c:	535c                	lw	a5,36(a4)
    8000596e:	014787bb          	addw	a5,a5,s4
    80005972:	d35c                	sw	a5,36(a4)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    80005974:	0001c517          	auipc	a0,0x1c
    80005978:	68c50513          	addi	a0,a0,1676 # 80022000 <stats>
    8000597c:	00001097          	auipc	ra,0x1
    80005980:	dc4080e7          	jalr	-572(ra) # 80006740 <release>
  return m;
}
    80005984:	8526                	mv	a0,s1
    80005986:	70a2                	ld	ra,40(sp)
    80005988:	7402                	ld	s0,32(sp)
    8000598a:	64e2                	ld	s1,24(sp)
    8000598c:	6942                	ld	s2,16(sp)
    8000598e:	69a2                	ld	s3,8(sp)
    80005990:	6a02                	ld	s4,0(sp)
    80005992:	6145                	addi	sp,sp,48
    80005994:	8082                	ret
    stats.sz = statslock(stats.buf, BUFSZ);
    80005996:	6585                	lui	a1,0x1
    80005998:	0001c517          	auipc	a0,0x1c
    8000599c:	68850513          	addi	a0,a0,1672 # 80022020 <stats+0x20>
    800059a0:	00001097          	auipc	ra,0x1
    800059a4:	f28080e7          	jalr	-216(ra) # 800068c8 <statslock>
    800059a8:	0001d797          	auipc	a5,0x1d
    800059ac:	66a7ac23          	sw	a0,1656(a5) # 80023020 <stats+0x1020>
    800059b0:	bf95                	j	80005924 <statsread+0x30>
    stats.sz = 0;
    800059b2:	0001d797          	auipc	a5,0x1d
    800059b6:	64e78793          	addi	a5,a5,1614 # 80023000 <stats+0x1000>
    800059ba:	0207a023          	sw	zero,32(a5)
    stats.off = 0;
    800059be:	0207a223          	sw	zero,36(a5)
    m = -1;
    800059c2:	54fd                	li	s1,-1
    800059c4:	bf45                	j	80005974 <statsread+0x80>

00000000800059c6 <statsinit>:

void
statsinit(void)
{
    800059c6:	1141                	addi	sp,sp,-16
    800059c8:	e406                	sd	ra,8(sp)
    800059ca:	e022                	sd	s0,0(sp)
    800059cc:	0800                	addi	s0,sp,16
  initlock(&stats.lock, "stats");
    800059ce:	00003597          	auipc	a1,0x3
    800059d2:	dd258593          	addi	a1,a1,-558 # 800087a0 <syscalls+0x3d8>
    800059d6:	0001c517          	auipc	a0,0x1c
    800059da:	62a50513          	addi	a0,a0,1578 # 80022000 <stats>
    800059de:	00001097          	auipc	ra,0x1
    800059e2:	e0e080e7          	jalr	-498(ra) # 800067ec <initlock>

  devsw[STATS].read = statsread;
    800059e6:	00018797          	auipc	a5,0x18
    800059ea:	36278793          	addi	a5,a5,866 # 8001dd48 <devsw>
    800059ee:	00000717          	auipc	a4,0x0
    800059f2:	f0670713          	addi	a4,a4,-250 # 800058f4 <statsread>
    800059f6:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    800059f8:	00000717          	auipc	a4,0x0
    800059fc:	eee70713          	addi	a4,a4,-274 # 800058e6 <statswrite>
    80005a00:	f798                	sd	a4,40(a5)
}
    80005a02:	60a2                	ld	ra,8(sp)
    80005a04:	6402                	ld	s0,0(sp)
    80005a06:	0141                	addi	sp,sp,16
    80005a08:	8082                	ret

0000000080005a0a <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    80005a0a:	1101                	addi	sp,sp,-32
    80005a0c:	ec22                	sd	s0,24(sp)
    80005a0e:	1000                	addi	s0,sp,32
    80005a10:	882a                	mv	a6,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    80005a12:	c299                	beqz	a3,80005a18 <sprintint+0xe>
    80005a14:	0805c163          	bltz	a1,80005a96 <sprintint+0x8c>
    x = -xx;
  else
    x = xx;
    80005a18:	2581                	sext.w	a1,a1
    80005a1a:	4301                	li	t1,0

  i = 0;
    80005a1c:	fe040713          	addi	a4,s0,-32
    80005a20:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    80005a22:	2601                	sext.w	a2,a2
    80005a24:	00003697          	auipc	a3,0x3
    80005a28:	d9c68693          	addi	a3,a3,-612 # 800087c0 <digits>
    80005a2c:	88aa                	mv	a7,a0
    80005a2e:	2505                	addiw	a0,a0,1
    80005a30:	02c5f7bb          	remuw	a5,a1,a2
    80005a34:	1782                	slli	a5,a5,0x20
    80005a36:	9381                	srli	a5,a5,0x20
    80005a38:	97b6                	add	a5,a5,a3
    80005a3a:	0007c783          	lbu	a5,0(a5)
    80005a3e:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80005a42:	0005879b          	sext.w	a5,a1
    80005a46:	02c5d5bb          	divuw	a1,a1,a2
    80005a4a:	0705                	addi	a4,a4,1
    80005a4c:	fec7f0e3          	bgeu	a5,a2,80005a2c <sprintint+0x22>

  if(sign)
    80005a50:	00030b63          	beqz	t1,80005a66 <sprintint+0x5c>
    buf[i++] = '-';
    80005a54:	ff040793          	addi	a5,s0,-16
    80005a58:	97aa                	add	a5,a5,a0
    80005a5a:	02d00713          	li	a4,45
    80005a5e:	fee78823          	sb	a4,-16(a5)
    80005a62:	0028851b          	addiw	a0,a7,2

  n = 0;
  while(--i >= 0)
    80005a66:	02a05c63          	blez	a0,80005a9e <sprintint+0x94>
    80005a6a:	fe040793          	addi	a5,s0,-32
    80005a6e:	00a78733          	add	a4,a5,a0
    80005a72:	87c2                	mv	a5,a6
    80005a74:	0805                	addi	a6,a6,1
    80005a76:	fff5061b          	addiw	a2,a0,-1
    80005a7a:	1602                	slli	a2,a2,0x20
    80005a7c:	9201                	srli	a2,a2,0x20
    80005a7e:	9642                	add	a2,a2,a6
  *s = c;
    80005a80:	fff74683          	lbu	a3,-1(a4)
    80005a84:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    80005a88:	177d                	addi	a4,a4,-1
    80005a8a:	0785                	addi	a5,a5,1
    80005a8c:	fec79ae3          	bne	a5,a2,80005a80 <sprintint+0x76>
    n += sputc(s+n, buf[i]);
  return n;
}
    80005a90:	6462                	ld	s0,24(sp)
    80005a92:	6105                	addi	sp,sp,32
    80005a94:	8082                	ret
    x = -xx;
    80005a96:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    80005a9a:	4305                	li	t1,1
    x = -xx;
    80005a9c:	b741                	j	80005a1c <sprintint+0x12>
  while(--i >= 0)
    80005a9e:	4501                	li	a0,0
    80005aa0:	bfc5                	j	80005a90 <sprintint+0x86>

0000000080005aa2 <snprintf>:

int
snprintf(char *buf, int sz, char *fmt, ...)
{
    80005aa2:	7171                	addi	sp,sp,-176
    80005aa4:	fc86                	sd	ra,120(sp)
    80005aa6:	f8a2                	sd	s0,112(sp)
    80005aa8:	f4a6                	sd	s1,104(sp)
    80005aaa:	f0ca                	sd	s2,96(sp)
    80005aac:	ecce                	sd	s3,88(sp)
    80005aae:	e8d2                	sd	s4,80(sp)
    80005ab0:	e4d6                	sd	s5,72(sp)
    80005ab2:	e0da                	sd	s6,64(sp)
    80005ab4:	fc5e                	sd	s7,56(sp)
    80005ab6:	f862                	sd	s8,48(sp)
    80005ab8:	f466                	sd	s9,40(sp)
    80005aba:	f06a                	sd	s10,32(sp)
    80005abc:	ec6e                	sd	s11,24(sp)
    80005abe:	0100                	addi	s0,sp,128
    80005ac0:	e414                	sd	a3,8(s0)
    80005ac2:	e818                	sd	a4,16(s0)
    80005ac4:	ec1c                	sd	a5,24(s0)
    80005ac6:	03043023          	sd	a6,32(s0)
    80005aca:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  if (fmt == 0)
    80005ace:	ca0d                	beqz	a2,80005b00 <snprintf+0x5e>
    80005ad0:	8baa                	mv	s7,a0
    80005ad2:	89ae                	mv	s3,a1
    80005ad4:	8a32                	mv	s4,a2
    panic("null fmt");

  va_start(ap, fmt);
    80005ad6:	00840793          	addi	a5,s0,8
    80005ada:	f8f43423          	sd	a5,-120(s0)
  int off = 0;
    80005ade:	4481                	li	s1,0
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005ae0:	4901                	li	s2,0
    80005ae2:	02b05763          	blez	a1,80005b10 <snprintf+0x6e>
    if(c != '%'){
    80005ae6:	02500a93          	li	s5,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    80005aea:	07300b13          	li	s6,115
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
      break;
    case 's':
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s && off < sz; s++)
    80005aee:	02800d93          	li	s11,40
  *s = c;
    80005af2:	02500d13          	li	s10,37
    switch(c){
    80005af6:	07800c93          	li	s9,120
    80005afa:	06400c13          	li	s8,100
    80005afe:	a01d                	j	80005b24 <snprintf+0x82>
    panic("null fmt");
    80005b00:	00003517          	auipc	a0,0x3
    80005b04:	cb050513          	addi	a0,a0,-848 # 800087b0 <syscalls+0x3e8>
    80005b08:	00000097          	auipc	ra,0x0
    80005b0c:	634080e7          	jalr	1588(ra) # 8000613c <panic>
  int off = 0;
    80005b10:	4481                	li	s1,0
    80005b12:	a86d                	j	80005bcc <snprintf+0x12a>
  *s = c;
    80005b14:	009b8733          	add	a4,s7,s1
    80005b18:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005b1c:	2485                	addiw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005b1e:	2905                	addiw	s2,s2,1
    80005b20:	0b34d663          	bge	s1,s3,80005bcc <snprintf+0x12a>
    80005b24:	012a07b3          	add	a5,s4,s2
    80005b28:	0007c783          	lbu	a5,0(a5)
    80005b2c:	0007871b          	sext.w	a4,a5
    80005b30:	cfd1                	beqz	a5,80005bcc <snprintf+0x12a>
    if(c != '%'){
    80005b32:	ff5711e3          	bne	a4,s5,80005b14 <snprintf+0x72>
    c = fmt[++i] & 0xff;
    80005b36:	2905                	addiw	s2,s2,1
    80005b38:	012a07b3          	add	a5,s4,s2
    80005b3c:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    80005b40:	c7d1                	beqz	a5,80005bcc <snprintf+0x12a>
    switch(c){
    80005b42:	05678c63          	beq	a5,s6,80005b9a <snprintf+0xf8>
    80005b46:	02fb6763          	bltu	s6,a5,80005b74 <snprintf+0xd2>
    80005b4a:	0b578763          	beq	a5,s5,80005bf8 <snprintf+0x156>
    80005b4e:	0b879b63          	bne	a5,s8,80005c04 <snprintf+0x162>
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    80005b52:	f8843783          	ld	a5,-120(s0)
    80005b56:	00878713          	addi	a4,a5,8
    80005b5a:	f8e43423          	sd	a4,-120(s0)
    80005b5e:	4685                	li	a3,1
    80005b60:	4629                	li	a2,10
    80005b62:	438c                	lw	a1,0(a5)
    80005b64:	009b8533          	add	a0,s7,s1
    80005b68:	00000097          	auipc	ra,0x0
    80005b6c:	ea2080e7          	jalr	-350(ra) # 80005a0a <sprintint>
    80005b70:	9ca9                	addw	s1,s1,a0
      break;
    80005b72:	b775                	j	80005b1e <snprintf+0x7c>
    switch(c){
    80005b74:	09979863          	bne	a5,s9,80005c04 <snprintf+0x162>
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    80005b78:	f8843783          	ld	a5,-120(s0)
    80005b7c:	00878713          	addi	a4,a5,8
    80005b80:	f8e43423          	sd	a4,-120(s0)
    80005b84:	4685                	li	a3,1
    80005b86:	4641                	li	a2,16
    80005b88:	438c                	lw	a1,0(a5)
    80005b8a:	009b8533          	add	a0,s7,s1
    80005b8e:	00000097          	auipc	ra,0x0
    80005b92:	e7c080e7          	jalr	-388(ra) # 80005a0a <sprintint>
    80005b96:	9ca9                	addw	s1,s1,a0
      break;
    80005b98:	b759                	j	80005b1e <snprintf+0x7c>
      if((s = va_arg(ap, char*)) == 0)
    80005b9a:	f8843783          	ld	a5,-120(s0)
    80005b9e:	00878713          	addi	a4,a5,8
    80005ba2:	f8e43423          	sd	a4,-120(s0)
    80005ba6:	639c                	ld	a5,0(a5)
    80005ba8:	c3b1                	beqz	a5,80005bec <snprintf+0x14a>
      for(; *s && off < sz; s++)
    80005baa:	0007c703          	lbu	a4,0(a5)
    80005bae:	db25                	beqz	a4,80005b1e <snprintf+0x7c>
    80005bb0:	0134de63          	bge	s1,s3,80005bcc <snprintf+0x12a>
    80005bb4:	009b86b3          	add	a3,s7,s1
  *s = c;
    80005bb8:	00e68023          	sb	a4,0(a3)
        off += sputc(buf+off, *s);
    80005bbc:	2485                	addiw	s1,s1,1
      for(; *s && off < sz; s++)
    80005bbe:	0785                	addi	a5,a5,1
    80005bc0:	0007c703          	lbu	a4,0(a5)
    80005bc4:	df29                	beqz	a4,80005b1e <snprintf+0x7c>
    80005bc6:	0685                	addi	a3,a3,1
    80005bc8:	fe9998e3          	bne	s3,s1,80005bb8 <snprintf+0x116>
      off += sputc(buf+off, c);
      break;
    }
  }
  return off;
}
    80005bcc:	8526                	mv	a0,s1
    80005bce:	70e6                	ld	ra,120(sp)
    80005bd0:	7446                	ld	s0,112(sp)
    80005bd2:	74a6                	ld	s1,104(sp)
    80005bd4:	7906                	ld	s2,96(sp)
    80005bd6:	69e6                	ld	s3,88(sp)
    80005bd8:	6a46                	ld	s4,80(sp)
    80005bda:	6aa6                	ld	s5,72(sp)
    80005bdc:	6b06                	ld	s6,64(sp)
    80005bde:	7be2                	ld	s7,56(sp)
    80005be0:	7c42                	ld	s8,48(sp)
    80005be2:	7ca2                	ld	s9,40(sp)
    80005be4:	7d02                	ld	s10,32(sp)
    80005be6:	6de2                	ld	s11,24(sp)
    80005be8:	614d                	addi	sp,sp,176
    80005bea:	8082                	ret
        s = "(null)";
    80005bec:	00003797          	auipc	a5,0x3
    80005bf0:	bbc78793          	addi	a5,a5,-1092 # 800087a8 <syscalls+0x3e0>
      for(; *s && off < sz; s++)
    80005bf4:	876e                	mv	a4,s11
    80005bf6:	bf6d                	j	80005bb0 <snprintf+0x10e>
  *s = c;
    80005bf8:	009b87b3          	add	a5,s7,s1
    80005bfc:	01a78023          	sb	s10,0(a5)
      off += sputc(buf+off, '%');
    80005c00:	2485                	addiw	s1,s1,1
      break;
    80005c02:	bf31                	j	80005b1e <snprintf+0x7c>
  *s = c;
    80005c04:	009b8733          	add	a4,s7,s1
    80005c08:	01a70023          	sb	s10,0(a4)
      off += sputc(buf+off, c);
    80005c0c:	0014871b          	addiw	a4,s1,1
  *s = c;
    80005c10:	975e                	add	a4,a4,s7
    80005c12:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005c16:	2489                	addiw	s1,s1,2
      break;
    80005c18:	b719                	j	80005b1e <snprintf+0x7c>

0000000080005c1a <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005c1a:	1141                	addi	sp,sp,-16
    80005c1c:	e422                	sd	s0,8(sp)
    80005c1e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005c20:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005c24:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005c28:	0037979b          	slliw	a5,a5,0x3
    80005c2c:	02004737          	lui	a4,0x2004
    80005c30:	97ba                	add	a5,a5,a4
    80005c32:	0200c737          	lui	a4,0x200c
    80005c36:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005c3a:	000f4637          	lui	a2,0xf4
    80005c3e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005c42:	95b2                	add	a1,a1,a2
    80005c44:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005c46:	00269713          	slli	a4,a3,0x2
    80005c4a:	9736                	add	a4,a4,a3
    80005c4c:	00371693          	slli	a3,a4,0x3
    80005c50:	0001d717          	auipc	a4,0x1d
    80005c54:	3e070713          	addi	a4,a4,992 # 80023030 <timer_scratch>
    80005c58:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005c5a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005c5c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005c5e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005c62:	fffff797          	auipc	a5,0xfffff
    80005c66:	63e78793          	addi	a5,a5,1598 # 800052a0 <timervec>
    80005c6a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c6e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005c72:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c76:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005c7a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005c7e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005c82:	30479073          	csrw	mie,a5
}
    80005c86:	6422                	ld	s0,8(sp)
    80005c88:	0141                	addi	sp,sp,16
    80005c8a:	8082                	ret

0000000080005c8c <start>:
{
    80005c8c:	1141                	addi	sp,sp,-16
    80005c8e:	e406                	sd	ra,8(sp)
    80005c90:	e022                	sd	s0,0(sp)
    80005c92:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c94:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005c98:	7779                	lui	a4,0xffffe
    80005c9a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd25b7>
    80005c9e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005ca0:	6705                	lui	a4,0x1
    80005ca2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005ca6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005ca8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005cac:	ffffa797          	auipc	a5,0xffffa
    80005cb0:	7f678793          	addi	a5,a5,2038 # 800004a2 <main>
    80005cb4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005cb8:	4781                	li	a5,0
    80005cba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005cbe:	67c1                	lui	a5,0x10
    80005cc0:	17fd                	addi	a5,a5,-1
    80005cc2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005cc6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005cca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005cce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005cd2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005cd6:	57fd                	li	a5,-1
    80005cd8:	83a9                	srli	a5,a5,0xa
    80005cda:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005cde:	47bd                	li	a5,15
    80005ce0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005ce4:	00000097          	auipc	ra,0x0
    80005ce8:	f36080e7          	jalr	-202(ra) # 80005c1a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005cec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005cf0:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005cf2:	823e                	mv	tp,a5
  asm volatile("mret");
    80005cf4:	30200073          	mret
}
    80005cf8:	60a2                	ld	ra,8(sp)
    80005cfa:	6402                	ld	s0,0(sp)
    80005cfc:	0141                	addi	sp,sp,16
    80005cfe:	8082                	ret

0000000080005d00 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005d00:	715d                	addi	sp,sp,-80
    80005d02:	e486                	sd	ra,72(sp)
    80005d04:	e0a2                	sd	s0,64(sp)
    80005d06:	fc26                	sd	s1,56(sp)
    80005d08:	f84a                	sd	s2,48(sp)
    80005d0a:	f44e                	sd	s3,40(sp)
    80005d0c:	f052                	sd	s4,32(sp)
    80005d0e:	ec56                	sd	s5,24(sp)
    80005d10:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005d12:	04c05663          	blez	a2,80005d5e <consolewrite+0x5e>
    80005d16:	8a2a                	mv	s4,a0
    80005d18:	84ae                	mv	s1,a1
    80005d1a:	89b2                	mv	s3,a2
    80005d1c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005d1e:	5afd                	li	s5,-1
    80005d20:	4685                	li	a3,1
    80005d22:	8626                	mv	a2,s1
    80005d24:	85d2                	mv	a1,s4
    80005d26:	fbf40513          	addi	a0,s0,-65
    80005d2a:	ffffc097          	auipc	ra,0xffffc
    80005d2e:	d60080e7          	jalr	-672(ra) # 80001a8a <either_copyin>
    80005d32:	01550c63          	beq	a0,s5,80005d4a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005d36:	fbf44503          	lbu	a0,-65(s0)
    80005d3a:	00000097          	auipc	ra,0x0
    80005d3e:	78e080e7          	jalr	1934(ra) # 800064c8 <uartputc>
  for(i = 0; i < n; i++){
    80005d42:	2905                	addiw	s2,s2,1
    80005d44:	0485                	addi	s1,s1,1
    80005d46:	fd299de3          	bne	s3,s2,80005d20 <consolewrite+0x20>
  }

  return i;
}
    80005d4a:	854a                	mv	a0,s2
    80005d4c:	60a6                	ld	ra,72(sp)
    80005d4e:	6406                	ld	s0,64(sp)
    80005d50:	74e2                	ld	s1,56(sp)
    80005d52:	7942                	ld	s2,48(sp)
    80005d54:	79a2                	ld	s3,40(sp)
    80005d56:	7a02                	ld	s4,32(sp)
    80005d58:	6ae2                	ld	s5,24(sp)
    80005d5a:	6161                	addi	sp,sp,80
    80005d5c:	8082                	ret
  for(i = 0; i < n; i++){
    80005d5e:	4901                	li	s2,0
    80005d60:	b7ed                	j	80005d4a <consolewrite+0x4a>

0000000080005d62 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005d62:	7119                	addi	sp,sp,-128
    80005d64:	fc86                	sd	ra,120(sp)
    80005d66:	f8a2                	sd	s0,112(sp)
    80005d68:	f4a6                	sd	s1,104(sp)
    80005d6a:	f0ca                	sd	s2,96(sp)
    80005d6c:	ecce                	sd	s3,88(sp)
    80005d6e:	e8d2                	sd	s4,80(sp)
    80005d70:	e4d6                	sd	s5,72(sp)
    80005d72:	e0da                	sd	s6,64(sp)
    80005d74:	fc5e                	sd	s7,56(sp)
    80005d76:	f862                	sd	s8,48(sp)
    80005d78:	f466                	sd	s9,40(sp)
    80005d7a:	f06a                	sd	s10,32(sp)
    80005d7c:	ec6e                	sd	s11,24(sp)
    80005d7e:	0100                	addi	s0,sp,128
    80005d80:	8b2a                	mv	s6,a0
    80005d82:	8aae                	mv	s5,a1
    80005d84:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005d86:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005d8a:	00025517          	auipc	a0,0x25
    80005d8e:	3e650513          	addi	a0,a0,998 # 8002b170 <cons>
    80005d92:	00001097          	auipc	ra,0x1
    80005d96:	8de080e7          	jalr	-1826(ra) # 80006670 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005d9a:	00025497          	auipc	s1,0x25
    80005d9e:	3d648493          	addi	s1,s1,982 # 8002b170 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005da2:	89a6                	mv	s3,s1
    80005da4:	00025917          	auipc	s2,0x25
    80005da8:	46c90913          	addi	s2,s2,1132 # 8002b210 <cons+0xa0>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005dac:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005dae:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005db0:	4da9                	li	s11,10
  while(n > 0){
    80005db2:	07405863          	blez	s4,80005e22 <consoleread+0xc0>
    while(cons.r == cons.w){
    80005db6:	0a04a783          	lw	a5,160(s1)
    80005dba:	0a44a703          	lw	a4,164(s1)
    80005dbe:	02f71463          	bne	a4,a5,80005de6 <consoleread+0x84>
      if(myproc()->killed){
    80005dc2:	ffffb097          	auipc	ra,0xffffb
    80005dc6:	212080e7          	jalr	530(ra) # 80000fd4 <myproc>
    80005dca:	591c                	lw	a5,48(a0)
    80005dcc:	e7b5                	bnez	a5,80005e38 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005dce:	85ce                	mv	a1,s3
    80005dd0:	854a                	mv	a0,s2
    80005dd2:	ffffc097          	auipc	ra,0xffffc
    80005dd6:	8be080e7          	jalr	-1858(ra) # 80001690 <sleep>
    while(cons.r == cons.w){
    80005dda:	0a04a783          	lw	a5,160(s1)
    80005dde:	0a44a703          	lw	a4,164(s1)
    80005de2:	fef700e3          	beq	a4,a5,80005dc2 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005de6:	0017871b          	addiw	a4,a5,1
    80005dea:	0ae4a023          	sw	a4,160(s1)
    80005dee:	07f7f713          	andi	a4,a5,127
    80005df2:	9726                	add	a4,a4,s1
    80005df4:	02074703          	lbu	a4,32(a4)
    80005df8:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005dfc:	079c0663          	beq	s8,s9,80005e68 <consoleread+0x106>
    cbuf = c;
    80005e00:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005e04:	4685                	li	a3,1
    80005e06:	f8f40613          	addi	a2,s0,-113
    80005e0a:	85d6                	mv	a1,s5
    80005e0c:	855a                	mv	a0,s6
    80005e0e:	ffffc097          	auipc	ra,0xffffc
    80005e12:	c26080e7          	jalr	-986(ra) # 80001a34 <either_copyout>
    80005e16:	01a50663          	beq	a0,s10,80005e22 <consoleread+0xc0>
    dst++;
    80005e1a:	0a85                	addi	s5,s5,1
    --n;
    80005e1c:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005e1e:	f9bc1ae3          	bne	s8,s11,80005db2 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005e22:	00025517          	auipc	a0,0x25
    80005e26:	34e50513          	addi	a0,a0,846 # 8002b170 <cons>
    80005e2a:	00001097          	auipc	ra,0x1
    80005e2e:	916080e7          	jalr	-1770(ra) # 80006740 <release>

  return target - n;
    80005e32:	414b853b          	subw	a0,s7,s4
    80005e36:	a811                	j	80005e4a <consoleread+0xe8>
        release(&cons.lock);
    80005e38:	00025517          	auipc	a0,0x25
    80005e3c:	33850513          	addi	a0,a0,824 # 8002b170 <cons>
    80005e40:	00001097          	auipc	ra,0x1
    80005e44:	900080e7          	jalr	-1792(ra) # 80006740 <release>
        return -1;
    80005e48:	557d                	li	a0,-1
}
    80005e4a:	70e6                	ld	ra,120(sp)
    80005e4c:	7446                	ld	s0,112(sp)
    80005e4e:	74a6                	ld	s1,104(sp)
    80005e50:	7906                	ld	s2,96(sp)
    80005e52:	69e6                	ld	s3,88(sp)
    80005e54:	6a46                	ld	s4,80(sp)
    80005e56:	6aa6                	ld	s5,72(sp)
    80005e58:	6b06                	ld	s6,64(sp)
    80005e5a:	7be2                	ld	s7,56(sp)
    80005e5c:	7c42                	ld	s8,48(sp)
    80005e5e:	7ca2                	ld	s9,40(sp)
    80005e60:	7d02                	ld	s10,32(sp)
    80005e62:	6de2                	ld	s11,24(sp)
    80005e64:	6109                	addi	sp,sp,128
    80005e66:	8082                	ret
      if(n < target){
    80005e68:	000a071b          	sext.w	a4,s4
    80005e6c:	fb777be3          	bgeu	a4,s7,80005e22 <consoleread+0xc0>
        cons.r--;
    80005e70:	00025717          	auipc	a4,0x25
    80005e74:	3af72023          	sw	a5,928(a4) # 8002b210 <cons+0xa0>
    80005e78:	b76d                	j	80005e22 <consoleread+0xc0>

0000000080005e7a <consputc>:
{
    80005e7a:	1141                	addi	sp,sp,-16
    80005e7c:	e406                	sd	ra,8(sp)
    80005e7e:	e022                	sd	s0,0(sp)
    80005e80:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005e82:	10000793          	li	a5,256
    80005e86:	00f50a63          	beq	a0,a5,80005e9a <consputc+0x20>
    uartputc_sync(c);
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	564080e7          	jalr	1380(ra) # 800063ee <uartputc_sync>
}
    80005e92:	60a2                	ld	ra,8(sp)
    80005e94:	6402                	ld	s0,0(sp)
    80005e96:	0141                	addi	sp,sp,16
    80005e98:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005e9a:	4521                	li	a0,8
    80005e9c:	00000097          	auipc	ra,0x0
    80005ea0:	552080e7          	jalr	1362(ra) # 800063ee <uartputc_sync>
    80005ea4:	02000513          	li	a0,32
    80005ea8:	00000097          	auipc	ra,0x0
    80005eac:	546080e7          	jalr	1350(ra) # 800063ee <uartputc_sync>
    80005eb0:	4521                	li	a0,8
    80005eb2:	00000097          	auipc	ra,0x0
    80005eb6:	53c080e7          	jalr	1340(ra) # 800063ee <uartputc_sync>
    80005eba:	bfe1                	j	80005e92 <consputc+0x18>

0000000080005ebc <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ebc:	1101                	addi	sp,sp,-32
    80005ebe:	ec06                	sd	ra,24(sp)
    80005ec0:	e822                	sd	s0,16(sp)
    80005ec2:	e426                	sd	s1,8(sp)
    80005ec4:	e04a                	sd	s2,0(sp)
    80005ec6:	1000                	addi	s0,sp,32
    80005ec8:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005eca:	00025517          	auipc	a0,0x25
    80005ece:	2a650513          	addi	a0,a0,678 # 8002b170 <cons>
    80005ed2:	00000097          	auipc	ra,0x0
    80005ed6:	79e080e7          	jalr	1950(ra) # 80006670 <acquire>

  switch(c){
    80005eda:	47d5                	li	a5,21
    80005edc:	0af48663          	beq	s1,a5,80005f88 <consoleintr+0xcc>
    80005ee0:	0297ca63          	blt	a5,s1,80005f14 <consoleintr+0x58>
    80005ee4:	47a1                	li	a5,8
    80005ee6:	0ef48763          	beq	s1,a5,80005fd4 <consoleintr+0x118>
    80005eea:	47c1                	li	a5,16
    80005eec:	10f49a63          	bne	s1,a5,80006000 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005ef0:	ffffc097          	auipc	ra,0xffffc
    80005ef4:	bf0080e7          	jalr	-1040(ra) # 80001ae0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005ef8:	00025517          	auipc	a0,0x25
    80005efc:	27850513          	addi	a0,a0,632 # 8002b170 <cons>
    80005f00:	00001097          	auipc	ra,0x1
    80005f04:	840080e7          	jalr	-1984(ra) # 80006740 <release>
}
    80005f08:	60e2                	ld	ra,24(sp)
    80005f0a:	6442                	ld	s0,16(sp)
    80005f0c:	64a2                	ld	s1,8(sp)
    80005f0e:	6902                	ld	s2,0(sp)
    80005f10:	6105                	addi	sp,sp,32
    80005f12:	8082                	ret
  switch(c){
    80005f14:	07f00793          	li	a5,127
    80005f18:	0af48e63          	beq	s1,a5,80005fd4 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005f1c:	00025717          	auipc	a4,0x25
    80005f20:	25470713          	addi	a4,a4,596 # 8002b170 <cons>
    80005f24:	0a872783          	lw	a5,168(a4)
    80005f28:	0a072703          	lw	a4,160(a4)
    80005f2c:	9f99                	subw	a5,a5,a4
    80005f2e:	07f00713          	li	a4,127
    80005f32:	fcf763e3          	bltu	a4,a5,80005ef8 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005f36:	47b5                	li	a5,13
    80005f38:	0cf48763          	beq	s1,a5,80006006 <consoleintr+0x14a>
      consputc(c);
    80005f3c:	8526                	mv	a0,s1
    80005f3e:	00000097          	auipc	ra,0x0
    80005f42:	f3c080e7          	jalr	-196(ra) # 80005e7a <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f46:	00025797          	auipc	a5,0x25
    80005f4a:	22a78793          	addi	a5,a5,554 # 8002b170 <cons>
    80005f4e:	0a87a703          	lw	a4,168(a5)
    80005f52:	0017069b          	addiw	a3,a4,1
    80005f56:	0006861b          	sext.w	a2,a3
    80005f5a:	0ad7a423          	sw	a3,168(a5)
    80005f5e:	07f77713          	andi	a4,a4,127
    80005f62:	97ba                	add	a5,a5,a4
    80005f64:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005f68:	47a9                	li	a5,10
    80005f6a:	0cf48563          	beq	s1,a5,80006034 <consoleintr+0x178>
    80005f6e:	4791                	li	a5,4
    80005f70:	0cf48263          	beq	s1,a5,80006034 <consoleintr+0x178>
    80005f74:	00025797          	auipc	a5,0x25
    80005f78:	29c7a783          	lw	a5,668(a5) # 8002b210 <cons+0xa0>
    80005f7c:	0807879b          	addiw	a5,a5,128
    80005f80:	f6f61ce3          	bne	a2,a5,80005ef8 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005f84:	863e                	mv	a2,a5
    80005f86:	a07d                	j	80006034 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005f88:	00025717          	auipc	a4,0x25
    80005f8c:	1e870713          	addi	a4,a4,488 # 8002b170 <cons>
    80005f90:	0a872783          	lw	a5,168(a4)
    80005f94:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005f98:	00025497          	auipc	s1,0x25
    80005f9c:	1d848493          	addi	s1,s1,472 # 8002b170 <cons>
    while(cons.e != cons.w &&
    80005fa0:	4929                	li	s2,10
    80005fa2:	f4f70be3          	beq	a4,a5,80005ef8 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005fa6:	37fd                	addiw	a5,a5,-1
    80005fa8:	07f7f713          	andi	a4,a5,127
    80005fac:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005fae:	02074703          	lbu	a4,32(a4)
    80005fb2:	f52703e3          	beq	a4,s2,80005ef8 <consoleintr+0x3c>
      cons.e--;
    80005fb6:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    80005fba:	10000513          	li	a0,256
    80005fbe:	00000097          	auipc	ra,0x0
    80005fc2:	ebc080e7          	jalr	-324(ra) # 80005e7a <consputc>
    while(cons.e != cons.w &&
    80005fc6:	0a84a783          	lw	a5,168(s1)
    80005fca:	0a44a703          	lw	a4,164(s1)
    80005fce:	fcf71ce3          	bne	a4,a5,80005fa6 <consoleintr+0xea>
    80005fd2:	b71d                	j	80005ef8 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005fd4:	00025717          	auipc	a4,0x25
    80005fd8:	19c70713          	addi	a4,a4,412 # 8002b170 <cons>
    80005fdc:	0a872783          	lw	a5,168(a4)
    80005fe0:	0a472703          	lw	a4,164(a4)
    80005fe4:	f0f70ae3          	beq	a4,a5,80005ef8 <consoleintr+0x3c>
      cons.e--;
    80005fe8:	37fd                	addiw	a5,a5,-1
    80005fea:	00025717          	auipc	a4,0x25
    80005fee:	22f72723          	sw	a5,558(a4) # 8002b218 <cons+0xa8>
      consputc(BACKSPACE);
    80005ff2:	10000513          	li	a0,256
    80005ff6:	00000097          	auipc	ra,0x0
    80005ffa:	e84080e7          	jalr	-380(ra) # 80005e7a <consputc>
    80005ffe:	bded                	j	80005ef8 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80006000:	ee048ce3          	beqz	s1,80005ef8 <consoleintr+0x3c>
    80006004:	bf21                	j	80005f1c <consoleintr+0x60>
      consputc(c);
    80006006:	4529                	li	a0,10
    80006008:	00000097          	auipc	ra,0x0
    8000600c:	e72080e7          	jalr	-398(ra) # 80005e7a <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006010:	00025797          	auipc	a5,0x25
    80006014:	16078793          	addi	a5,a5,352 # 8002b170 <cons>
    80006018:	0a87a703          	lw	a4,168(a5)
    8000601c:	0017069b          	addiw	a3,a4,1
    80006020:	0006861b          	sext.w	a2,a3
    80006024:	0ad7a423          	sw	a3,168(a5)
    80006028:	07f77713          	andi	a4,a4,127
    8000602c:	97ba                	add	a5,a5,a4
    8000602e:	4729                	li	a4,10
    80006030:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    80006034:	00025797          	auipc	a5,0x25
    80006038:	1ec7a023          	sw	a2,480(a5) # 8002b214 <cons+0xa4>
        wakeup(&cons.r);
    8000603c:	00025517          	auipc	a0,0x25
    80006040:	1d450513          	addi	a0,a0,468 # 8002b210 <cons+0xa0>
    80006044:	ffffb097          	auipc	ra,0xffffb
    80006048:	7d8080e7          	jalr	2008(ra) # 8000181c <wakeup>
    8000604c:	b575                	j	80005ef8 <consoleintr+0x3c>

000000008000604e <consoleinit>:

void
consoleinit(void)
{
    8000604e:	1141                	addi	sp,sp,-16
    80006050:	e406                	sd	ra,8(sp)
    80006052:	e022                	sd	s0,0(sp)
    80006054:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006056:	00002597          	auipc	a1,0x2
    8000605a:	78258593          	addi	a1,a1,1922 # 800087d8 <digits+0x18>
    8000605e:	00025517          	auipc	a0,0x25
    80006062:	11250513          	addi	a0,a0,274 # 8002b170 <cons>
    80006066:	00000097          	auipc	ra,0x0
    8000606a:	786080e7          	jalr	1926(ra) # 800067ec <initlock>

  uartinit();
    8000606e:	00000097          	auipc	ra,0x0
    80006072:	330080e7          	jalr	816(ra) # 8000639e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80006076:	00018797          	auipc	a5,0x18
    8000607a:	cd278793          	addi	a5,a5,-814 # 8001dd48 <devsw>
    8000607e:	00000717          	auipc	a4,0x0
    80006082:	ce470713          	addi	a4,a4,-796 # 80005d62 <consoleread>
    80006086:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006088:	00000717          	auipc	a4,0x0
    8000608c:	c7870713          	addi	a4,a4,-904 # 80005d00 <consolewrite>
    80006090:	ef98                	sd	a4,24(a5)
}
    80006092:	60a2                	ld	ra,8(sp)
    80006094:	6402                	ld	s0,0(sp)
    80006096:	0141                	addi	sp,sp,16
    80006098:	8082                	ret

000000008000609a <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000609a:	7179                	addi	sp,sp,-48
    8000609c:	f406                	sd	ra,40(sp)
    8000609e:	f022                	sd	s0,32(sp)
    800060a0:	ec26                	sd	s1,24(sp)
    800060a2:	e84a                	sd	s2,16(sp)
    800060a4:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800060a6:	c219                	beqz	a2,800060ac <printint+0x12>
    800060a8:	08054663          	bltz	a0,80006134 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800060ac:	2501                	sext.w	a0,a0
    800060ae:	4881                	li	a7,0
    800060b0:	fd040693          	addi	a3,s0,-48

  i = 0;
    800060b4:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800060b6:	2581                	sext.w	a1,a1
    800060b8:	00002617          	auipc	a2,0x2
    800060bc:	73860613          	addi	a2,a2,1848 # 800087f0 <digits>
    800060c0:	883a                	mv	a6,a4
    800060c2:	2705                	addiw	a4,a4,1
    800060c4:	02b577bb          	remuw	a5,a0,a1
    800060c8:	1782                	slli	a5,a5,0x20
    800060ca:	9381                	srli	a5,a5,0x20
    800060cc:	97b2                	add	a5,a5,a2
    800060ce:	0007c783          	lbu	a5,0(a5)
    800060d2:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800060d6:	0005079b          	sext.w	a5,a0
    800060da:	02b5553b          	divuw	a0,a0,a1
    800060de:	0685                	addi	a3,a3,1
    800060e0:	feb7f0e3          	bgeu	a5,a1,800060c0 <printint+0x26>

  if(sign)
    800060e4:	00088b63          	beqz	a7,800060fa <printint+0x60>
    buf[i++] = '-';
    800060e8:	fe040793          	addi	a5,s0,-32
    800060ec:	973e                	add	a4,a4,a5
    800060ee:	02d00793          	li	a5,45
    800060f2:	fef70823          	sb	a5,-16(a4)
    800060f6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800060fa:	02e05763          	blez	a4,80006128 <printint+0x8e>
    800060fe:	fd040793          	addi	a5,s0,-48
    80006102:	00e784b3          	add	s1,a5,a4
    80006106:	fff78913          	addi	s2,a5,-1
    8000610a:	993a                	add	s2,s2,a4
    8000610c:	377d                	addiw	a4,a4,-1
    8000610e:	1702                	slli	a4,a4,0x20
    80006110:	9301                	srli	a4,a4,0x20
    80006112:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006116:	fff4c503          	lbu	a0,-1(s1)
    8000611a:	00000097          	auipc	ra,0x0
    8000611e:	d60080e7          	jalr	-672(ra) # 80005e7a <consputc>
  while(--i >= 0)
    80006122:	14fd                	addi	s1,s1,-1
    80006124:	ff2499e3          	bne	s1,s2,80006116 <printint+0x7c>
}
    80006128:	70a2                	ld	ra,40(sp)
    8000612a:	7402                	ld	s0,32(sp)
    8000612c:	64e2                	ld	s1,24(sp)
    8000612e:	6942                	ld	s2,16(sp)
    80006130:	6145                	addi	sp,sp,48
    80006132:	8082                	ret
    x = -xx;
    80006134:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006138:	4885                	li	a7,1
    x = -xx;
    8000613a:	bf9d                	j	800060b0 <printint+0x16>

000000008000613c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000613c:	1101                	addi	sp,sp,-32
    8000613e:	ec06                	sd	ra,24(sp)
    80006140:	e822                	sd	s0,16(sp)
    80006142:	e426                	sd	s1,8(sp)
    80006144:	1000                	addi	s0,sp,32
    80006146:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006148:	00025797          	auipc	a5,0x25
    8000614c:	0e07ac23          	sw	zero,248(a5) # 8002b240 <pr+0x20>
  printf("panic: ");
    80006150:	00002517          	auipc	a0,0x2
    80006154:	69050513          	addi	a0,a0,1680 # 800087e0 <digits+0x20>
    80006158:	00000097          	auipc	ra,0x0
    8000615c:	02e080e7          	jalr	46(ra) # 80006186 <printf>
  printf(s);
    80006160:	8526                	mv	a0,s1
    80006162:	00000097          	auipc	ra,0x0
    80006166:	024080e7          	jalr	36(ra) # 80006186 <printf>
  printf("\n");
    8000616a:	00002517          	auipc	a0,0x2
    8000616e:	70e50513          	addi	a0,a0,1806 # 80008878 <digits+0x88>
    80006172:	00000097          	auipc	ra,0x0
    80006176:	014080e7          	jalr	20(ra) # 80006186 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000617a:	4785                	li	a5,1
    8000617c:	00003717          	auipc	a4,0x3
    80006180:	eaf72023          	sw	a5,-352(a4) # 8000901c <panicked>
  for(;;)
    80006184:	a001                	j	80006184 <panic+0x48>

0000000080006186 <printf>:
{
    80006186:	7131                	addi	sp,sp,-192
    80006188:	fc86                	sd	ra,120(sp)
    8000618a:	f8a2                	sd	s0,112(sp)
    8000618c:	f4a6                	sd	s1,104(sp)
    8000618e:	f0ca                	sd	s2,96(sp)
    80006190:	ecce                	sd	s3,88(sp)
    80006192:	e8d2                	sd	s4,80(sp)
    80006194:	e4d6                	sd	s5,72(sp)
    80006196:	e0da                	sd	s6,64(sp)
    80006198:	fc5e                	sd	s7,56(sp)
    8000619a:	f862                	sd	s8,48(sp)
    8000619c:	f466                	sd	s9,40(sp)
    8000619e:	f06a                	sd	s10,32(sp)
    800061a0:	ec6e                	sd	s11,24(sp)
    800061a2:	0100                	addi	s0,sp,128
    800061a4:	8a2a                	mv	s4,a0
    800061a6:	e40c                	sd	a1,8(s0)
    800061a8:	e810                	sd	a2,16(s0)
    800061aa:	ec14                	sd	a3,24(s0)
    800061ac:	f018                	sd	a4,32(s0)
    800061ae:	f41c                	sd	a5,40(s0)
    800061b0:	03043823          	sd	a6,48(s0)
    800061b4:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800061b8:	00025d97          	auipc	s11,0x25
    800061bc:	088dad83          	lw	s11,136(s11) # 8002b240 <pr+0x20>
  if(locking)
    800061c0:	020d9b63          	bnez	s11,800061f6 <printf+0x70>
  if (fmt == 0)
    800061c4:	040a0263          	beqz	s4,80006208 <printf+0x82>
  va_start(ap, fmt);
    800061c8:	00840793          	addi	a5,s0,8
    800061cc:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800061d0:	000a4503          	lbu	a0,0(s4)
    800061d4:	16050263          	beqz	a0,80006338 <printf+0x1b2>
    800061d8:	4481                	li	s1,0
    if(c != '%'){
    800061da:	02500a93          	li	s5,37
    switch(c){
    800061de:	07000b13          	li	s6,112
  consputc('x');
    800061e2:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800061e4:	00002b97          	auipc	s7,0x2
    800061e8:	60cb8b93          	addi	s7,s7,1548 # 800087f0 <digits>
    switch(c){
    800061ec:	07300c93          	li	s9,115
    800061f0:	06400c13          	li	s8,100
    800061f4:	a82d                	j	8000622e <printf+0xa8>
    acquire(&pr.lock);
    800061f6:	00025517          	auipc	a0,0x25
    800061fa:	02a50513          	addi	a0,a0,42 # 8002b220 <pr>
    800061fe:	00000097          	auipc	ra,0x0
    80006202:	472080e7          	jalr	1138(ra) # 80006670 <acquire>
    80006206:	bf7d                	j	800061c4 <printf+0x3e>
    panic("null fmt");
    80006208:	00002517          	auipc	a0,0x2
    8000620c:	5a850513          	addi	a0,a0,1448 # 800087b0 <syscalls+0x3e8>
    80006210:	00000097          	auipc	ra,0x0
    80006214:	f2c080e7          	jalr	-212(ra) # 8000613c <panic>
      consputc(c);
    80006218:	00000097          	auipc	ra,0x0
    8000621c:	c62080e7          	jalr	-926(ra) # 80005e7a <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006220:	2485                	addiw	s1,s1,1
    80006222:	009a07b3          	add	a5,s4,s1
    80006226:	0007c503          	lbu	a0,0(a5)
    8000622a:	10050763          	beqz	a0,80006338 <printf+0x1b2>
    if(c != '%'){
    8000622e:	ff5515e3          	bne	a0,s5,80006218 <printf+0x92>
    c = fmt[++i] & 0xff;
    80006232:	2485                	addiw	s1,s1,1
    80006234:	009a07b3          	add	a5,s4,s1
    80006238:	0007c783          	lbu	a5,0(a5)
    8000623c:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80006240:	cfe5                	beqz	a5,80006338 <printf+0x1b2>
    switch(c){
    80006242:	05678a63          	beq	a5,s6,80006296 <printf+0x110>
    80006246:	02fb7663          	bgeu	s6,a5,80006272 <printf+0xec>
    8000624a:	09978963          	beq	a5,s9,800062dc <printf+0x156>
    8000624e:	07800713          	li	a4,120
    80006252:	0ce79863          	bne	a5,a4,80006322 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80006256:	f8843783          	ld	a5,-120(s0)
    8000625a:	00878713          	addi	a4,a5,8
    8000625e:	f8e43423          	sd	a4,-120(s0)
    80006262:	4605                	li	a2,1
    80006264:	85ea                	mv	a1,s10
    80006266:	4388                	lw	a0,0(a5)
    80006268:	00000097          	auipc	ra,0x0
    8000626c:	e32080e7          	jalr	-462(ra) # 8000609a <printint>
      break;
    80006270:	bf45                	j	80006220 <printf+0x9a>
    switch(c){
    80006272:	0b578263          	beq	a5,s5,80006316 <printf+0x190>
    80006276:	0b879663          	bne	a5,s8,80006322 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    8000627a:	f8843783          	ld	a5,-120(s0)
    8000627e:	00878713          	addi	a4,a5,8
    80006282:	f8e43423          	sd	a4,-120(s0)
    80006286:	4605                	li	a2,1
    80006288:	45a9                	li	a1,10
    8000628a:	4388                	lw	a0,0(a5)
    8000628c:	00000097          	auipc	ra,0x0
    80006290:	e0e080e7          	jalr	-498(ra) # 8000609a <printint>
      break;
    80006294:	b771                	j	80006220 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006296:	f8843783          	ld	a5,-120(s0)
    8000629a:	00878713          	addi	a4,a5,8
    8000629e:	f8e43423          	sd	a4,-120(s0)
    800062a2:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800062a6:	03000513          	li	a0,48
    800062aa:	00000097          	auipc	ra,0x0
    800062ae:	bd0080e7          	jalr	-1072(ra) # 80005e7a <consputc>
  consputc('x');
    800062b2:	07800513          	li	a0,120
    800062b6:	00000097          	auipc	ra,0x0
    800062ba:	bc4080e7          	jalr	-1084(ra) # 80005e7a <consputc>
    800062be:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800062c0:	03c9d793          	srli	a5,s3,0x3c
    800062c4:	97de                	add	a5,a5,s7
    800062c6:	0007c503          	lbu	a0,0(a5)
    800062ca:	00000097          	auipc	ra,0x0
    800062ce:	bb0080e7          	jalr	-1104(ra) # 80005e7a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800062d2:	0992                	slli	s3,s3,0x4
    800062d4:	397d                	addiw	s2,s2,-1
    800062d6:	fe0915e3          	bnez	s2,800062c0 <printf+0x13a>
    800062da:	b799                	j	80006220 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800062dc:	f8843783          	ld	a5,-120(s0)
    800062e0:	00878713          	addi	a4,a5,8
    800062e4:	f8e43423          	sd	a4,-120(s0)
    800062e8:	0007b903          	ld	s2,0(a5)
    800062ec:	00090e63          	beqz	s2,80006308 <printf+0x182>
      for(; *s; s++)
    800062f0:	00094503          	lbu	a0,0(s2)
    800062f4:	d515                	beqz	a0,80006220 <printf+0x9a>
        consputc(*s);
    800062f6:	00000097          	auipc	ra,0x0
    800062fa:	b84080e7          	jalr	-1148(ra) # 80005e7a <consputc>
      for(; *s; s++)
    800062fe:	0905                	addi	s2,s2,1
    80006300:	00094503          	lbu	a0,0(s2)
    80006304:	f96d                	bnez	a0,800062f6 <printf+0x170>
    80006306:	bf29                	j	80006220 <printf+0x9a>
        s = "(null)";
    80006308:	00002917          	auipc	s2,0x2
    8000630c:	4a090913          	addi	s2,s2,1184 # 800087a8 <syscalls+0x3e0>
      for(; *s; s++)
    80006310:	02800513          	li	a0,40
    80006314:	b7cd                	j	800062f6 <printf+0x170>
      consputc('%');
    80006316:	8556                	mv	a0,s5
    80006318:	00000097          	auipc	ra,0x0
    8000631c:	b62080e7          	jalr	-1182(ra) # 80005e7a <consputc>
      break;
    80006320:	b701                	j	80006220 <printf+0x9a>
      consputc('%');
    80006322:	8556                	mv	a0,s5
    80006324:	00000097          	auipc	ra,0x0
    80006328:	b56080e7          	jalr	-1194(ra) # 80005e7a <consputc>
      consputc(c);
    8000632c:	854a                	mv	a0,s2
    8000632e:	00000097          	auipc	ra,0x0
    80006332:	b4c080e7          	jalr	-1204(ra) # 80005e7a <consputc>
      break;
    80006336:	b5ed                	j	80006220 <printf+0x9a>
  if(locking)
    80006338:	020d9163          	bnez	s11,8000635a <printf+0x1d4>
}
    8000633c:	70e6                	ld	ra,120(sp)
    8000633e:	7446                	ld	s0,112(sp)
    80006340:	74a6                	ld	s1,104(sp)
    80006342:	7906                	ld	s2,96(sp)
    80006344:	69e6                	ld	s3,88(sp)
    80006346:	6a46                	ld	s4,80(sp)
    80006348:	6aa6                	ld	s5,72(sp)
    8000634a:	6b06                	ld	s6,64(sp)
    8000634c:	7be2                	ld	s7,56(sp)
    8000634e:	7c42                	ld	s8,48(sp)
    80006350:	7ca2                	ld	s9,40(sp)
    80006352:	7d02                	ld	s10,32(sp)
    80006354:	6de2                	ld	s11,24(sp)
    80006356:	6129                	addi	sp,sp,192
    80006358:	8082                	ret
    release(&pr.lock);
    8000635a:	00025517          	auipc	a0,0x25
    8000635e:	ec650513          	addi	a0,a0,-314 # 8002b220 <pr>
    80006362:	00000097          	auipc	ra,0x0
    80006366:	3de080e7          	jalr	990(ra) # 80006740 <release>
}
    8000636a:	bfc9                	j	8000633c <printf+0x1b6>

000000008000636c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000636c:	1101                	addi	sp,sp,-32
    8000636e:	ec06                	sd	ra,24(sp)
    80006370:	e822                	sd	s0,16(sp)
    80006372:	e426                	sd	s1,8(sp)
    80006374:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006376:	00025497          	auipc	s1,0x25
    8000637a:	eaa48493          	addi	s1,s1,-342 # 8002b220 <pr>
    8000637e:	00002597          	auipc	a1,0x2
    80006382:	46a58593          	addi	a1,a1,1130 # 800087e8 <digits+0x28>
    80006386:	8526                	mv	a0,s1
    80006388:	00000097          	auipc	ra,0x0
    8000638c:	464080e7          	jalr	1124(ra) # 800067ec <initlock>
  pr.locking = 1;
    80006390:	4785                	li	a5,1
    80006392:	d09c                	sw	a5,32(s1)
}
    80006394:	60e2                	ld	ra,24(sp)
    80006396:	6442                	ld	s0,16(sp)
    80006398:	64a2                	ld	s1,8(sp)
    8000639a:	6105                	addi	sp,sp,32
    8000639c:	8082                	ret

000000008000639e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000639e:	1141                	addi	sp,sp,-16
    800063a0:	e406                	sd	ra,8(sp)
    800063a2:	e022                	sd	s0,0(sp)
    800063a4:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800063a6:	100007b7          	lui	a5,0x10000
    800063aa:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800063ae:	f8000713          	li	a4,-128
    800063b2:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800063b6:	470d                	li	a4,3
    800063b8:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800063bc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800063c0:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800063c4:	469d                	li	a3,7
    800063c6:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800063ca:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800063ce:	00002597          	auipc	a1,0x2
    800063d2:	43a58593          	addi	a1,a1,1082 # 80008808 <digits+0x18>
    800063d6:	00025517          	auipc	a0,0x25
    800063da:	e7250513          	addi	a0,a0,-398 # 8002b248 <uart_tx_lock>
    800063de:	00000097          	auipc	ra,0x0
    800063e2:	40e080e7          	jalr	1038(ra) # 800067ec <initlock>
}
    800063e6:	60a2                	ld	ra,8(sp)
    800063e8:	6402                	ld	s0,0(sp)
    800063ea:	0141                	addi	sp,sp,16
    800063ec:	8082                	ret

00000000800063ee <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800063ee:	1101                	addi	sp,sp,-32
    800063f0:	ec06                	sd	ra,24(sp)
    800063f2:	e822                	sd	s0,16(sp)
    800063f4:	e426                	sd	s1,8(sp)
    800063f6:	1000                	addi	s0,sp,32
    800063f8:	84aa                	mv	s1,a0
  push_off();
    800063fa:	00000097          	auipc	ra,0x0
    800063fe:	22a080e7          	jalr	554(ra) # 80006624 <push_off>

  if(panicked){
    80006402:	00003797          	auipc	a5,0x3
    80006406:	c1a7a783          	lw	a5,-998(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000640a:	10000737          	lui	a4,0x10000
  if(panicked){
    8000640e:	c391                	beqz	a5,80006412 <uartputc_sync+0x24>
    for(;;)
    80006410:	a001                	j	80006410 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006412:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006416:	0ff7f793          	andi	a5,a5,255
    8000641a:	0207f793          	andi	a5,a5,32
    8000641e:	dbf5                	beqz	a5,80006412 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006420:	0ff4f793          	andi	a5,s1,255
    80006424:	10000737          	lui	a4,0x10000
    80006428:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    8000642c:	00000097          	auipc	ra,0x0
    80006430:	2b4080e7          	jalr	692(ra) # 800066e0 <pop_off>
}
    80006434:	60e2                	ld	ra,24(sp)
    80006436:	6442                	ld	s0,16(sp)
    80006438:	64a2                	ld	s1,8(sp)
    8000643a:	6105                	addi	sp,sp,32
    8000643c:	8082                	ret

000000008000643e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000643e:	00003717          	auipc	a4,0x3
    80006442:	be273703          	ld	a4,-1054(a4) # 80009020 <uart_tx_r>
    80006446:	00003797          	auipc	a5,0x3
    8000644a:	be27b783          	ld	a5,-1054(a5) # 80009028 <uart_tx_w>
    8000644e:	06e78c63          	beq	a5,a4,800064c6 <uartstart+0x88>
{
    80006452:	7139                	addi	sp,sp,-64
    80006454:	fc06                	sd	ra,56(sp)
    80006456:	f822                	sd	s0,48(sp)
    80006458:	f426                	sd	s1,40(sp)
    8000645a:	f04a                	sd	s2,32(sp)
    8000645c:	ec4e                	sd	s3,24(sp)
    8000645e:	e852                	sd	s4,16(sp)
    80006460:	e456                	sd	s5,8(sp)
    80006462:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006464:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006468:	00025a17          	auipc	s4,0x25
    8000646c:	de0a0a13          	addi	s4,s4,-544 # 8002b248 <uart_tx_lock>
    uart_tx_r += 1;
    80006470:	00003497          	auipc	s1,0x3
    80006474:	bb048493          	addi	s1,s1,-1104 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006478:	00003997          	auipc	s3,0x3
    8000647c:	bb098993          	addi	s3,s3,-1104 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006480:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006484:	0ff7f793          	andi	a5,a5,255
    80006488:	0207f793          	andi	a5,a5,32
    8000648c:	c785                	beqz	a5,800064b4 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000648e:	01f77793          	andi	a5,a4,31
    80006492:	97d2                	add	a5,a5,s4
    80006494:	0207ca83          	lbu	s5,32(a5)
    uart_tx_r += 1;
    80006498:	0705                	addi	a4,a4,1
    8000649a:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000649c:	8526                	mv	a0,s1
    8000649e:	ffffb097          	auipc	ra,0xffffb
    800064a2:	37e080e7          	jalr	894(ra) # 8000181c <wakeup>
    
    WriteReg(THR, c);
    800064a6:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800064aa:	6098                	ld	a4,0(s1)
    800064ac:	0009b783          	ld	a5,0(s3)
    800064b0:	fce798e3          	bne	a5,a4,80006480 <uartstart+0x42>
  }
}
    800064b4:	70e2                	ld	ra,56(sp)
    800064b6:	7442                	ld	s0,48(sp)
    800064b8:	74a2                	ld	s1,40(sp)
    800064ba:	7902                	ld	s2,32(sp)
    800064bc:	69e2                	ld	s3,24(sp)
    800064be:	6a42                	ld	s4,16(sp)
    800064c0:	6aa2                	ld	s5,8(sp)
    800064c2:	6121                	addi	sp,sp,64
    800064c4:	8082                	ret
    800064c6:	8082                	ret

00000000800064c8 <uartputc>:
{
    800064c8:	7179                	addi	sp,sp,-48
    800064ca:	f406                	sd	ra,40(sp)
    800064cc:	f022                	sd	s0,32(sp)
    800064ce:	ec26                	sd	s1,24(sp)
    800064d0:	e84a                	sd	s2,16(sp)
    800064d2:	e44e                	sd	s3,8(sp)
    800064d4:	e052                	sd	s4,0(sp)
    800064d6:	1800                	addi	s0,sp,48
    800064d8:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800064da:	00025517          	auipc	a0,0x25
    800064de:	d6e50513          	addi	a0,a0,-658 # 8002b248 <uart_tx_lock>
    800064e2:	00000097          	auipc	ra,0x0
    800064e6:	18e080e7          	jalr	398(ra) # 80006670 <acquire>
  if(panicked){
    800064ea:	00003797          	auipc	a5,0x3
    800064ee:	b327a783          	lw	a5,-1230(a5) # 8000901c <panicked>
    800064f2:	c391                	beqz	a5,800064f6 <uartputc+0x2e>
    for(;;)
    800064f4:	a001                	j	800064f4 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800064f6:	00003797          	auipc	a5,0x3
    800064fa:	b327b783          	ld	a5,-1230(a5) # 80009028 <uart_tx_w>
    800064fe:	00003717          	auipc	a4,0x3
    80006502:	b2273703          	ld	a4,-1246(a4) # 80009020 <uart_tx_r>
    80006506:	02070713          	addi	a4,a4,32
    8000650a:	02f71b63          	bne	a4,a5,80006540 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000650e:	00025a17          	auipc	s4,0x25
    80006512:	d3aa0a13          	addi	s4,s4,-710 # 8002b248 <uart_tx_lock>
    80006516:	00003497          	auipc	s1,0x3
    8000651a:	b0a48493          	addi	s1,s1,-1270 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000651e:	00003917          	auipc	s2,0x3
    80006522:	b0a90913          	addi	s2,s2,-1270 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006526:	85d2                	mv	a1,s4
    80006528:	8526                	mv	a0,s1
    8000652a:	ffffb097          	auipc	ra,0xffffb
    8000652e:	166080e7          	jalr	358(ra) # 80001690 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006532:	00093783          	ld	a5,0(s2)
    80006536:	6098                	ld	a4,0(s1)
    80006538:	02070713          	addi	a4,a4,32
    8000653c:	fef705e3          	beq	a4,a5,80006526 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006540:	00025497          	auipc	s1,0x25
    80006544:	d0848493          	addi	s1,s1,-760 # 8002b248 <uart_tx_lock>
    80006548:	01f7f713          	andi	a4,a5,31
    8000654c:	9726                	add	a4,a4,s1
    8000654e:	03370023          	sb	s3,32(a4)
      uart_tx_w += 1;
    80006552:	0785                	addi	a5,a5,1
    80006554:	00003717          	auipc	a4,0x3
    80006558:	acf73a23          	sd	a5,-1324(a4) # 80009028 <uart_tx_w>
      uartstart();
    8000655c:	00000097          	auipc	ra,0x0
    80006560:	ee2080e7          	jalr	-286(ra) # 8000643e <uartstart>
      release(&uart_tx_lock);
    80006564:	8526                	mv	a0,s1
    80006566:	00000097          	auipc	ra,0x0
    8000656a:	1da080e7          	jalr	474(ra) # 80006740 <release>
}
    8000656e:	70a2                	ld	ra,40(sp)
    80006570:	7402                	ld	s0,32(sp)
    80006572:	64e2                	ld	s1,24(sp)
    80006574:	6942                	ld	s2,16(sp)
    80006576:	69a2                	ld	s3,8(sp)
    80006578:	6a02                	ld	s4,0(sp)
    8000657a:	6145                	addi	sp,sp,48
    8000657c:	8082                	ret

000000008000657e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000657e:	1141                	addi	sp,sp,-16
    80006580:	e422                	sd	s0,8(sp)
    80006582:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006584:	100007b7          	lui	a5,0x10000
    80006588:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000658c:	8b85                	andi	a5,a5,1
    8000658e:	cb91                	beqz	a5,800065a2 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006590:	100007b7          	lui	a5,0x10000
    80006594:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006598:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000659c:	6422                	ld	s0,8(sp)
    8000659e:	0141                	addi	sp,sp,16
    800065a0:	8082                	ret
    return -1;
    800065a2:	557d                	li	a0,-1
    800065a4:	bfe5                	j	8000659c <uartgetc+0x1e>

00000000800065a6 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800065a6:	1101                	addi	sp,sp,-32
    800065a8:	ec06                	sd	ra,24(sp)
    800065aa:	e822                	sd	s0,16(sp)
    800065ac:	e426                	sd	s1,8(sp)
    800065ae:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800065b0:	54fd                	li	s1,-1
    int c = uartgetc();
    800065b2:	00000097          	auipc	ra,0x0
    800065b6:	fcc080e7          	jalr	-52(ra) # 8000657e <uartgetc>
    if(c == -1)
    800065ba:	00950763          	beq	a0,s1,800065c8 <uartintr+0x22>
      break;
    consoleintr(c);
    800065be:	00000097          	auipc	ra,0x0
    800065c2:	8fe080e7          	jalr	-1794(ra) # 80005ebc <consoleintr>
  while(1){
    800065c6:	b7f5                	j	800065b2 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800065c8:	00025497          	auipc	s1,0x25
    800065cc:	c8048493          	addi	s1,s1,-896 # 8002b248 <uart_tx_lock>
    800065d0:	8526                	mv	a0,s1
    800065d2:	00000097          	auipc	ra,0x0
    800065d6:	09e080e7          	jalr	158(ra) # 80006670 <acquire>
  uartstart();
    800065da:	00000097          	auipc	ra,0x0
    800065de:	e64080e7          	jalr	-412(ra) # 8000643e <uartstart>
  release(&uart_tx_lock);
    800065e2:	8526                	mv	a0,s1
    800065e4:	00000097          	auipc	ra,0x0
    800065e8:	15c080e7          	jalr	348(ra) # 80006740 <release>
}
    800065ec:	60e2                	ld	ra,24(sp)
    800065ee:	6442                	ld	s0,16(sp)
    800065f0:	64a2                	ld	s1,8(sp)
    800065f2:	6105                	addi	sp,sp,32
    800065f4:	8082                	ret

00000000800065f6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800065f6:	411c                	lw	a5,0(a0)
    800065f8:	e399                	bnez	a5,800065fe <holding+0x8>
    800065fa:	4501                	li	a0,0
  return r;
}
    800065fc:	8082                	ret
{
    800065fe:	1101                	addi	sp,sp,-32
    80006600:	ec06                	sd	ra,24(sp)
    80006602:	e822                	sd	s0,16(sp)
    80006604:	e426                	sd	s1,8(sp)
    80006606:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006608:	6904                	ld	s1,16(a0)
    8000660a:	ffffb097          	auipc	ra,0xffffb
    8000660e:	9ae080e7          	jalr	-1618(ra) # 80000fb8 <mycpu>
    80006612:	40a48533          	sub	a0,s1,a0
    80006616:	00153513          	seqz	a0,a0
}
    8000661a:	60e2                	ld	ra,24(sp)
    8000661c:	6442                	ld	s0,16(sp)
    8000661e:	64a2                	ld	s1,8(sp)
    80006620:	6105                	addi	sp,sp,32
    80006622:	8082                	ret

0000000080006624 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006624:	1101                	addi	sp,sp,-32
    80006626:	ec06                	sd	ra,24(sp)
    80006628:	e822                	sd	s0,16(sp)
    8000662a:	e426                	sd	s1,8(sp)
    8000662c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000662e:	100024f3          	csrr	s1,sstatus
    80006632:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006636:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006638:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000663c:	ffffb097          	auipc	ra,0xffffb
    80006640:	97c080e7          	jalr	-1668(ra) # 80000fb8 <mycpu>
    80006644:	5d3c                	lw	a5,120(a0)
    80006646:	cf89                	beqz	a5,80006660 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006648:	ffffb097          	auipc	ra,0xffffb
    8000664c:	970080e7          	jalr	-1680(ra) # 80000fb8 <mycpu>
    80006650:	5d3c                	lw	a5,120(a0)
    80006652:	2785                	addiw	a5,a5,1
    80006654:	dd3c                	sw	a5,120(a0)
}
    80006656:	60e2                	ld	ra,24(sp)
    80006658:	6442                	ld	s0,16(sp)
    8000665a:	64a2                	ld	s1,8(sp)
    8000665c:	6105                	addi	sp,sp,32
    8000665e:	8082                	ret
    mycpu()->intena = old;
    80006660:	ffffb097          	auipc	ra,0xffffb
    80006664:	958080e7          	jalr	-1704(ra) # 80000fb8 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006668:	8085                	srli	s1,s1,0x1
    8000666a:	8885                	andi	s1,s1,1
    8000666c:	dd64                	sw	s1,124(a0)
    8000666e:	bfe9                	j	80006648 <push_off+0x24>

0000000080006670 <acquire>:
{
    80006670:	1101                	addi	sp,sp,-32
    80006672:	ec06                	sd	ra,24(sp)
    80006674:	e822                	sd	s0,16(sp)
    80006676:	e426                	sd	s1,8(sp)
    80006678:	1000                	addi	s0,sp,32
    8000667a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000667c:	00000097          	auipc	ra,0x0
    80006680:	fa8080e7          	jalr	-88(ra) # 80006624 <push_off>
  if(holding(lk))
    80006684:	8526                	mv	a0,s1
    80006686:	00000097          	auipc	ra,0x0
    8000668a:	f70080e7          	jalr	-144(ra) # 800065f6 <holding>
    8000668e:	e911                	bnez	a0,800066a2 <acquire+0x32>
    __sync_fetch_and_add(&(lk->n), 1);
    80006690:	4785                	li	a5,1
    80006692:	01c48713          	addi	a4,s1,28
    80006696:	0f50000f          	fence	iorw,ow
    8000669a:	04f7202f          	amoadd.w.aq	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    8000669e:	4705                	li	a4,1
    800066a0:	a839                	j	800066be <acquire+0x4e>
    panic("acquire");
    800066a2:	00002517          	auipc	a0,0x2
    800066a6:	16e50513          	addi	a0,a0,366 # 80008810 <digits+0x20>
    800066aa:	00000097          	auipc	ra,0x0
    800066ae:	a92080e7          	jalr	-1390(ra) # 8000613c <panic>
    __sync_fetch_and_add(&(lk->nts), 1);
    800066b2:	01848793          	addi	a5,s1,24
    800066b6:	0f50000f          	fence	iorw,ow
    800066ba:	04e7a02f          	amoadd.w.aq	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800066be:	87ba                	mv	a5,a4
    800066c0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800066c4:	2781                	sext.w	a5,a5
    800066c6:	f7f5                	bnez	a5,800066b2 <acquire+0x42>
  __sync_synchronize();
    800066c8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800066cc:	ffffb097          	auipc	ra,0xffffb
    800066d0:	8ec080e7          	jalr	-1812(ra) # 80000fb8 <mycpu>
    800066d4:	e888                	sd	a0,16(s1)
}
    800066d6:	60e2                	ld	ra,24(sp)
    800066d8:	6442                	ld	s0,16(sp)
    800066da:	64a2                	ld	s1,8(sp)
    800066dc:	6105                	addi	sp,sp,32
    800066de:	8082                	ret

00000000800066e0 <pop_off>:

void
pop_off(void)
{
    800066e0:	1141                	addi	sp,sp,-16
    800066e2:	e406                	sd	ra,8(sp)
    800066e4:	e022                	sd	s0,0(sp)
    800066e6:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800066e8:	ffffb097          	auipc	ra,0xffffb
    800066ec:	8d0080e7          	jalr	-1840(ra) # 80000fb8 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800066f0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800066f4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800066f6:	e78d                	bnez	a5,80006720 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800066f8:	5d3c                	lw	a5,120(a0)
    800066fa:	02f05b63          	blez	a5,80006730 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800066fe:	37fd                	addiw	a5,a5,-1
    80006700:	0007871b          	sext.w	a4,a5
    80006704:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006706:	eb09                	bnez	a4,80006718 <pop_off+0x38>
    80006708:	5d7c                	lw	a5,124(a0)
    8000670a:	c799                	beqz	a5,80006718 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000670c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006710:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006714:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006718:	60a2                	ld	ra,8(sp)
    8000671a:	6402                	ld	s0,0(sp)
    8000671c:	0141                	addi	sp,sp,16
    8000671e:	8082                	ret
    panic("pop_off - interruptible");
    80006720:	00002517          	auipc	a0,0x2
    80006724:	0f850513          	addi	a0,a0,248 # 80008818 <digits+0x28>
    80006728:	00000097          	auipc	ra,0x0
    8000672c:	a14080e7          	jalr	-1516(ra) # 8000613c <panic>
    panic("pop_off");
    80006730:	00002517          	auipc	a0,0x2
    80006734:	10050513          	addi	a0,a0,256 # 80008830 <digits+0x40>
    80006738:	00000097          	auipc	ra,0x0
    8000673c:	a04080e7          	jalr	-1532(ra) # 8000613c <panic>

0000000080006740 <release>:
{
    80006740:	1101                	addi	sp,sp,-32
    80006742:	ec06                	sd	ra,24(sp)
    80006744:	e822                	sd	s0,16(sp)
    80006746:	e426                	sd	s1,8(sp)
    80006748:	1000                	addi	s0,sp,32
    8000674a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000674c:	00000097          	auipc	ra,0x0
    80006750:	eaa080e7          	jalr	-342(ra) # 800065f6 <holding>
    80006754:	c115                	beqz	a0,80006778 <release+0x38>
  lk->cpu = 0;
    80006756:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000675a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000675e:	0f50000f          	fence	iorw,ow
    80006762:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006766:	00000097          	auipc	ra,0x0
    8000676a:	f7a080e7          	jalr	-134(ra) # 800066e0 <pop_off>
}
    8000676e:	60e2                	ld	ra,24(sp)
    80006770:	6442                	ld	s0,16(sp)
    80006772:	64a2                	ld	s1,8(sp)
    80006774:	6105                	addi	sp,sp,32
    80006776:	8082                	ret
    panic("release");
    80006778:	00002517          	auipc	a0,0x2
    8000677c:	0c050513          	addi	a0,a0,192 # 80008838 <digits+0x48>
    80006780:	00000097          	auipc	ra,0x0
    80006784:	9bc080e7          	jalr	-1604(ra) # 8000613c <panic>

0000000080006788 <freelock>:
{
    80006788:	1101                	addi	sp,sp,-32
    8000678a:	ec06                	sd	ra,24(sp)
    8000678c:	e822                	sd	s0,16(sp)
    8000678e:	e426                	sd	s1,8(sp)
    80006790:	1000                	addi	s0,sp,32
    80006792:	84aa                	mv	s1,a0
  acquire(&lock_locks);
    80006794:	00025517          	auipc	a0,0x25
    80006798:	af450513          	addi	a0,a0,-1292 # 8002b288 <lock_locks>
    8000679c:	00000097          	auipc	ra,0x0
    800067a0:	ed4080e7          	jalr	-300(ra) # 80006670 <acquire>
  for (i = 0; i < NLOCK; i++) {
    800067a4:	00025717          	auipc	a4,0x25
    800067a8:	b0470713          	addi	a4,a4,-1276 # 8002b2a8 <locks>
    800067ac:	4781                	li	a5,0
    800067ae:	1f400613          	li	a2,500
    if(locks[i] == lk) {
    800067b2:	6314                	ld	a3,0(a4)
    800067b4:	00968763          	beq	a3,s1,800067c2 <freelock+0x3a>
  for (i = 0; i < NLOCK; i++) {
    800067b8:	2785                	addiw	a5,a5,1
    800067ba:	0721                	addi	a4,a4,8
    800067bc:	fec79be3          	bne	a5,a2,800067b2 <freelock+0x2a>
    800067c0:	a809                	j	800067d2 <freelock+0x4a>
      locks[i] = 0;
    800067c2:	078e                	slli	a5,a5,0x3
    800067c4:	00025717          	auipc	a4,0x25
    800067c8:	ae470713          	addi	a4,a4,-1308 # 8002b2a8 <locks>
    800067cc:	97ba                	add	a5,a5,a4
    800067ce:	0007b023          	sd	zero,0(a5)
  release(&lock_locks);
    800067d2:	00025517          	auipc	a0,0x25
    800067d6:	ab650513          	addi	a0,a0,-1354 # 8002b288 <lock_locks>
    800067da:	00000097          	auipc	ra,0x0
    800067de:	f66080e7          	jalr	-154(ra) # 80006740 <release>
}
    800067e2:	60e2                	ld	ra,24(sp)
    800067e4:	6442                	ld	s0,16(sp)
    800067e6:	64a2                	ld	s1,8(sp)
    800067e8:	6105                	addi	sp,sp,32
    800067ea:	8082                	ret

00000000800067ec <initlock>:
{
    800067ec:	1101                	addi	sp,sp,-32
    800067ee:	ec06                	sd	ra,24(sp)
    800067f0:	e822                	sd	s0,16(sp)
    800067f2:	e426                	sd	s1,8(sp)
    800067f4:	1000                	addi	s0,sp,32
    800067f6:	84aa                	mv	s1,a0
  lk->name = name;
    800067f8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800067fa:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800067fe:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    80006802:	00052c23          	sw	zero,24(a0)
  lk->n = 0;
    80006806:	00052e23          	sw	zero,28(a0)
  acquire(&lock_locks);
    8000680a:	00025517          	auipc	a0,0x25
    8000680e:	a7e50513          	addi	a0,a0,-1410 # 8002b288 <lock_locks>
    80006812:	00000097          	auipc	ra,0x0
    80006816:	e5e080e7          	jalr	-418(ra) # 80006670 <acquire>
  for (i = 0; i < NLOCK; i++) {
    8000681a:	00025717          	auipc	a4,0x25
    8000681e:	a8e70713          	addi	a4,a4,-1394 # 8002b2a8 <locks>
    80006822:	4781                	li	a5,0
    80006824:	1f400693          	li	a3,500
    if(locks[i] == 0) {
    80006828:	6310                	ld	a2,0(a4)
    8000682a:	ce09                	beqz	a2,80006844 <initlock+0x58>
  for (i = 0; i < NLOCK; i++) {
    8000682c:	2785                	addiw	a5,a5,1
    8000682e:	0721                	addi	a4,a4,8
    80006830:	fed79ce3          	bne	a5,a3,80006828 <initlock+0x3c>
  panic("findslot");
    80006834:	00002517          	auipc	a0,0x2
    80006838:	00c50513          	addi	a0,a0,12 # 80008840 <digits+0x50>
    8000683c:	00000097          	auipc	ra,0x0
    80006840:	900080e7          	jalr	-1792(ra) # 8000613c <panic>
      locks[i] = lk;
    80006844:	078e                	slli	a5,a5,0x3
    80006846:	00025717          	auipc	a4,0x25
    8000684a:	a6270713          	addi	a4,a4,-1438 # 8002b2a8 <locks>
    8000684e:	97ba                	add	a5,a5,a4
    80006850:	e384                	sd	s1,0(a5)
      release(&lock_locks);
    80006852:	00025517          	auipc	a0,0x25
    80006856:	a3650513          	addi	a0,a0,-1482 # 8002b288 <lock_locks>
    8000685a:	00000097          	auipc	ra,0x0
    8000685e:	ee6080e7          	jalr	-282(ra) # 80006740 <release>
}
    80006862:	60e2                	ld	ra,24(sp)
    80006864:	6442                	ld	s0,16(sp)
    80006866:	64a2                	ld	s1,8(sp)
    80006868:	6105                	addi	sp,sp,32
    8000686a:	8082                	ret

000000008000686c <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    8000686c:	1141                	addi	sp,sp,-16
    8000686e:	e422                	sd	s0,8(sp)
    80006870:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80006872:	0ff0000f          	fence
    80006876:	6108                	ld	a0,0(a0)
    80006878:	0ff0000f          	fence
  return val;
}
    8000687c:	6422                	ld	s0,8(sp)
    8000687e:	0141                	addi	sp,sp,16
    80006880:	8082                	ret

0000000080006882 <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    80006882:	1141                	addi	sp,sp,-16
    80006884:	e422                	sd	s0,8(sp)
    80006886:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80006888:	0ff0000f          	fence
    8000688c:	4108                	lw	a0,0(a0)
    8000688e:	0ff0000f          	fence
  return val;
}
    80006892:	2501                	sext.w	a0,a0
    80006894:	6422                	ld	s0,8(sp)
    80006896:	0141                	addi	sp,sp,16
    80006898:	8082                	ret

000000008000689a <snprint_lock>:
#ifdef LAB_LOCK
int
snprint_lock(char *buf, int sz, struct spinlock *lk)
{
  int n = 0;
  if(lk->n > 0) {
    8000689a:	4e5c                	lw	a5,28(a2)
    8000689c:	00f04463          	bgtz	a5,800068a4 <snprint_lock+0xa>
  int n = 0;
    800068a0:	4501                	li	a0,0
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
                 lk->name, lk->nts, lk->n);
  }
  return n;
}
    800068a2:	8082                	ret
{
    800068a4:	1141                	addi	sp,sp,-16
    800068a6:	e406                	sd	ra,8(sp)
    800068a8:	e022                	sd	s0,0(sp)
    800068aa:	0800                	addi	s0,sp,16
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
    800068ac:	4e18                	lw	a4,24(a2)
    800068ae:	6614                	ld	a3,8(a2)
    800068b0:	00002617          	auipc	a2,0x2
    800068b4:	fa060613          	addi	a2,a2,-96 # 80008850 <digits+0x60>
    800068b8:	fffff097          	auipc	ra,0xfffff
    800068bc:	1ea080e7          	jalr	490(ra) # 80005aa2 <snprintf>
}
    800068c0:	60a2                	ld	ra,8(sp)
    800068c2:	6402                	ld	s0,0(sp)
    800068c4:	0141                	addi	sp,sp,16
    800068c6:	8082                	ret

00000000800068c8 <statslock>:

int
statslock(char *buf, int sz) {
    800068c8:	7159                	addi	sp,sp,-112
    800068ca:	f486                	sd	ra,104(sp)
    800068cc:	f0a2                	sd	s0,96(sp)
    800068ce:	eca6                	sd	s1,88(sp)
    800068d0:	e8ca                	sd	s2,80(sp)
    800068d2:	e4ce                	sd	s3,72(sp)
    800068d4:	e0d2                	sd	s4,64(sp)
    800068d6:	fc56                	sd	s5,56(sp)
    800068d8:	f85a                	sd	s6,48(sp)
    800068da:	f45e                	sd	s7,40(sp)
    800068dc:	f062                	sd	s8,32(sp)
    800068de:	ec66                	sd	s9,24(sp)
    800068e0:	e86a                	sd	s10,16(sp)
    800068e2:	e46e                	sd	s11,8(sp)
    800068e4:	1880                	addi	s0,sp,112
    800068e6:	8aaa                	mv	s5,a0
    800068e8:	8b2e                	mv	s6,a1
  int n;
  int tot = 0;

  acquire(&lock_locks);
    800068ea:	00025517          	auipc	a0,0x25
    800068ee:	99e50513          	addi	a0,a0,-1634 # 8002b288 <lock_locks>
    800068f2:	00000097          	auipc	ra,0x0
    800068f6:	d7e080e7          	jalr	-642(ra) # 80006670 <acquire>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    800068fa:	00002617          	auipc	a2,0x2
    800068fe:	f8660613          	addi	a2,a2,-122 # 80008880 <digits+0x90>
    80006902:	85da                	mv	a1,s6
    80006904:	8556                	mv	a0,s5
    80006906:	fffff097          	auipc	ra,0xfffff
    8000690a:	19c080e7          	jalr	412(ra) # 80005aa2 <snprintf>
    8000690e:	892a                	mv	s2,a0
  for(int i = 0; i < NLOCK; i++) {
    80006910:	00025c97          	auipc	s9,0x25
    80006914:	998c8c93          	addi	s9,s9,-1640 # 8002b2a8 <locks>
    80006918:	00026c17          	auipc	s8,0x26
    8000691c:	930c0c13          	addi	s8,s8,-1744 # 8002c248 <end>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    80006920:	84e6                	mv	s1,s9
  int tot = 0;
    80006922:	4a01                	li	s4,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006924:	00002b97          	auipc	s7,0x2
    80006928:	b54b8b93          	addi	s7,s7,-1196 # 80008478 <syscalls+0xb0>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    8000692c:	00001d17          	auipc	s10,0x1
    80006930:	6e4d0d13          	addi	s10,s10,1764 # 80008010 <etext+0x10>
    80006934:	a01d                	j	8000695a <statslock+0x92>
      tot += locks[i]->nts;
    80006936:	0009b603          	ld	a2,0(s3)
    8000693a:	4e1c                	lw	a5,24(a2)
    8000693c:	01478a3b          	addw	s4,a5,s4
      n += snprint_lock(buf +n, sz-n, locks[i]);
    80006940:	412b05bb          	subw	a1,s6,s2
    80006944:	012a8533          	add	a0,s5,s2
    80006948:	00000097          	auipc	ra,0x0
    8000694c:	f52080e7          	jalr	-174(ra) # 8000689a <snprint_lock>
    80006950:	0125093b          	addw	s2,a0,s2
  for(int i = 0; i < NLOCK; i++) {
    80006954:	04a1                	addi	s1,s1,8
    80006956:	05848763          	beq	s1,s8,800069a4 <statslock+0xdc>
    if(locks[i] == 0)
    8000695a:	89a6                	mv	s3,s1
    8000695c:	609c                	ld	a5,0(s1)
    8000695e:	c3b9                	beqz	a5,800069a4 <statslock+0xdc>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006960:	0087bd83          	ld	s11,8(a5)
    80006964:	855e                	mv	a0,s7
    80006966:	ffffa097          	auipc	ra,0xffffa
    8000696a:	b12080e7          	jalr	-1262(ra) # 80000478 <strlen>
    8000696e:	0005061b          	sext.w	a2,a0
    80006972:	85de                	mv	a1,s7
    80006974:	856e                	mv	a0,s11
    80006976:	ffffa097          	auipc	ra,0xffffa
    8000697a:	a56080e7          	jalr	-1450(ra) # 800003cc <strncmp>
    8000697e:	dd45                	beqz	a0,80006936 <statslock+0x6e>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006980:	609c                	ld	a5,0(s1)
    80006982:	0087bd83          	ld	s11,8(a5)
    80006986:	856a                	mv	a0,s10
    80006988:	ffffa097          	auipc	ra,0xffffa
    8000698c:	af0080e7          	jalr	-1296(ra) # 80000478 <strlen>
    80006990:	0005061b          	sext.w	a2,a0
    80006994:	85ea                	mv	a1,s10
    80006996:	856e                	mv	a0,s11
    80006998:	ffffa097          	auipc	ra,0xffffa
    8000699c:	a34080e7          	jalr	-1484(ra) # 800003cc <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    800069a0:	f955                	bnez	a0,80006954 <statslock+0x8c>
    800069a2:	bf51                	j	80006936 <statslock+0x6e>
    }
  }
  
  n += snprintf(buf+n, sz-n, "--- top 5 contended locks:\n");
    800069a4:	00002617          	auipc	a2,0x2
    800069a8:	efc60613          	addi	a2,a2,-260 # 800088a0 <digits+0xb0>
    800069ac:	412b05bb          	subw	a1,s6,s2
    800069b0:	012a8533          	add	a0,s5,s2
    800069b4:	fffff097          	auipc	ra,0xfffff
    800069b8:	0ee080e7          	jalr	238(ra) # 80005aa2 <snprintf>
    800069bc:	012509bb          	addw	s3,a0,s2
    800069c0:	4b95                	li	s7,5
  int last = 100000000;
    800069c2:	05f5e537          	lui	a0,0x5f5e
    800069c6:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t = 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    800069ca:	4c01                	li	s8,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    800069cc:	00025497          	auipc	s1,0x25
    800069d0:	8dc48493          	addi	s1,s1,-1828 # 8002b2a8 <locks>
    for(int i = 0; i < NLOCK; i++) {
    800069d4:	1f400913          	li	s2,500
    800069d8:	a881                	j	80006a28 <statslock+0x160>
    800069da:	2705                	addiw	a4,a4,1
    800069dc:	06a1                	addi	a3,a3,8
    800069de:	03270063          	beq	a4,s2,800069fe <statslock+0x136>
      if(locks[i] == 0)
    800069e2:	629c                	ld	a5,0(a3)
    800069e4:	cf89                	beqz	a5,800069fe <statslock+0x136>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    800069e6:	4f90                	lw	a2,24(a5)
    800069e8:	00359793          	slli	a5,a1,0x3
    800069ec:	97a6                	add	a5,a5,s1
    800069ee:	639c                	ld	a5,0(a5)
    800069f0:	4f9c                	lw	a5,24(a5)
    800069f2:	fec7d4e3          	bge	a5,a2,800069da <statslock+0x112>
    800069f6:	fea652e3          	bge	a2,a0,800069da <statslock+0x112>
    800069fa:	85ba                	mv	a1,a4
    800069fc:	bff9                	j	800069da <statslock+0x112>
        top = i;
      }
    }
    n += snprint_lock(buf+n, sz-n, locks[top]);
    800069fe:	058e                	slli	a1,a1,0x3
    80006a00:	00b48d33          	add	s10,s1,a1
    80006a04:	000d3603          	ld	a2,0(s10)
    80006a08:	413b05bb          	subw	a1,s6,s3
    80006a0c:	013a8533          	add	a0,s5,s3
    80006a10:	00000097          	auipc	ra,0x0
    80006a14:	e8a080e7          	jalr	-374(ra) # 8000689a <snprint_lock>
    80006a18:	013509bb          	addw	s3,a0,s3
    last = locks[top]->nts;
    80006a1c:	000d3783          	ld	a5,0(s10)
    80006a20:	4f88                	lw	a0,24(a5)
  for(int t = 0; t < 5; t++) {
    80006a22:	3bfd                	addiw	s7,s7,-1
    80006a24:	000b8663          	beqz	s7,80006a30 <statslock+0x168>
  int tot = 0;
    80006a28:	86e6                	mv	a3,s9
    for(int i = 0; i < NLOCK; i++) {
    80006a2a:	8762                	mv	a4,s8
    int top = 0;
    80006a2c:	85e2                	mv	a1,s8
    80006a2e:	bf55                	j	800069e2 <statslock+0x11a>
  }
  n += snprintf(buf+n, sz-n, "tot= %d\n", tot);
    80006a30:	86d2                	mv	a3,s4
    80006a32:	00002617          	auipc	a2,0x2
    80006a36:	e8e60613          	addi	a2,a2,-370 # 800088c0 <digits+0xd0>
    80006a3a:	413b05bb          	subw	a1,s6,s3
    80006a3e:	013a8533          	add	a0,s5,s3
    80006a42:	fffff097          	auipc	ra,0xfffff
    80006a46:	060080e7          	jalr	96(ra) # 80005aa2 <snprintf>
    80006a4a:	013509bb          	addw	s3,a0,s3
  release(&lock_locks);  
    80006a4e:	00025517          	auipc	a0,0x25
    80006a52:	83a50513          	addi	a0,a0,-1990 # 8002b288 <lock_locks>
    80006a56:	00000097          	auipc	ra,0x0
    80006a5a:	cea080e7          	jalr	-790(ra) # 80006740 <release>
  return n;
}
    80006a5e:	854e                	mv	a0,s3
    80006a60:	70a6                	ld	ra,104(sp)
    80006a62:	7406                	ld	s0,96(sp)
    80006a64:	64e6                	ld	s1,88(sp)
    80006a66:	6946                	ld	s2,80(sp)
    80006a68:	69a6                	ld	s3,72(sp)
    80006a6a:	6a06                	ld	s4,64(sp)
    80006a6c:	7ae2                	ld	s5,56(sp)
    80006a6e:	7b42                	ld	s6,48(sp)
    80006a70:	7ba2                	ld	s7,40(sp)
    80006a72:	7c02                	ld	s8,32(sp)
    80006a74:	6ce2                	ld	s9,24(sp)
    80006a76:	6d42                	ld	s10,16(sp)
    80006a78:	6da2                	ld	s11,8(sp)
    80006a7a:	6165                	addi	sp,sp,112
    80006a7c:	8082                	ret
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
