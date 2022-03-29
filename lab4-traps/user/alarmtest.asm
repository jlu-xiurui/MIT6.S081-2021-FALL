
user/_alarmtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <periodic>:

volatile static int count;

void
periodic()
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  count = count + 1;
   8:	00001797          	auipc	a5,0x1
   c:	d187a783          	lw	a5,-744(a5) # d20 <count>
  10:	2785                	addiw	a5,a5,1
  12:	00001717          	auipc	a4,0x1
  16:	d0f72723          	sw	a5,-754(a4) # d20 <count>
  printf("alarm!\n");
  1a:	00001517          	auipc	a0,0x1
  1e:	b4e50513          	addi	a0,a0,-1202 # b68 <malloc+0xe6>
  22:	00001097          	auipc	ra,0x1
  26:	9a2080e7          	jalr	-1630(ra) # 9c4 <printf>
  sigreturn();
  2a:	00000097          	auipc	ra,0x0
  2e:	6ba080e7          	jalr	1722(ra) # 6e4 <sigreturn>
}
  32:	60a2                	ld	ra,8(sp)
  34:	6402                	ld	s0,0(sp)
  36:	0141                	addi	sp,sp,16
  38:	8082                	ret

000000000000003a <slow_handler>:
  }
}

void
slow_handler()
{
  3a:	1101                	addi	sp,sp,-32
  3c:	ec06                	sd	ra,24(sp)
  3e:	e822                	sd	s0,16(sp)
  40:	e426                	sd	s1,8(sp)
  42:	1000                	addi	s0,sp,32
  count++;
  44:	00001497          	auipc	s1,0x1
  48:	cdc48493          	addi	s1,s1,-804 # d20 <count>
  4c:	00001797          	auipc	a5,0x1
  50:	cd47a783          	lw	a5,-812(a5) # d20 <count>
  54:	2785                	addiw	a5,a5,1
  56:	c09c                	sw	a5,0(s1)
  printf("alarm!\n");
  58:	00001517          	auipc	a0,0x1
  5c:	b1050513          	addi	a0,a0,-1264 # b68 <malloc+0xe6>
  60:	00001097          	auipc	ra,0x1
  64:	964080e7          	jalr	-1692(ra) # 9c4 <printf>
  if (count > 1) {
  68:	4098                	lw	a4,0(s1)
  6a:	2701                	sext.w	a4,a4
  6c:	4685                	li	a3,1
  6e:	1dcd67b7          	lui	a5,0x1dcd6
  72:	50078793          	addi	a5,a5,1280 # 1dcd6500 <__global_pointer$+0x1dcd4fe7>
  76:	02e6c463          	blt	a3,a4,9e <slow_handler+0x64>
    printf("test2 failed: alarm handler called more than once\n");
    exit(1);
  }
  for (int i = 0; i < 1000*500000; i++) {
    asm volatile("nop"); // avoid compiler optimizing away loop
  7a:	0001                	nop
  for (int i = 0; i < 1000*500000; i++) {
  7c:	37fd                	addiw	a5,a5,-1
  7e:	fff5                	bnez	a5,7a <slow_handler+0x40>
  }
  sigalarm(0, 0);
  80:	4581                	li	a1,0
  82:	4501                	li	a0,0
  84:	00000097          	auipc	ra,0x0
  88:	658080e7          	jalr	1624(ra) # 6dc <sigalarm>
  sigreturn();
  8c:	00000097          	auipc	ra,0x0
  90:	658080e7          	jalr	1624(ra) # 6e4 <sigreturn>
}
  94:	60e2                	ld	ra,24(sp)
  96:	6442                	ld	s0,16(sp)
  98:	64a2                	ld	s1,8(sp)
  9a:	6105                	addi	sp,sp,32
  9c:	8082                	ret
    printf("test2 failed: alarm handler called more than once\n");
  9e:	00001517          	auipc	a0,0x1
  a2:	ad250513          	addi	a0,a0,-1326 # b70 <malloc+0xee>
  a6:	00001097          	auipc	ra,0x1
  aa:	91e080e7          	jalr	-1762(ra) # 9c4 <printf>
    exit(1);
  ae:	4505                	li	a0,1
  b0:	00000097          	auipc	ra,0x0
  b4:	58c080e7          	jalr	1420(ra) # 63c <exit>

00000000000000b8 <test0>:
{
  b8:	7139                	addi	sp,sp,-64
  ba:	fc06                	sd	ra,56(sp)
  bc:	f822                	sd	s0,48(sp)
  be:	f426                	sd	s1,40(sp)
  c0:	f04a                	sd	s2,32(sp)
  c2:	ec4e                	sd	s3,24(sp)
  c4:	e852                	sd	s4,16(sp)
  c6:	e456                	sd	s5,8(sp)
  c8:	0080                	addi	s0,sp,64
  printf("test0 start\n");
  ca:	00001517          	auipc	a0,0x1
  ce:	ade50513          	addi	a0,a0,-1314 # ba8 <malloc+0x126>
  d2:	00001097          	auipc	ra,0x1
  d6:	8f2080e7          	jalr	-1806(ra) # 9c4 <printf>
  count = 0;
  da:	00001797          	auipc	a5,0x1
  de:	c407a323          	sw	zero,-954(a5) # d20 <count>
  sigalarm(2, periodic);
  e2:	00000597          	auipc	a1,0x0
  e6:	f1e58593          	addi	a1,a1,-226 # 0 <periodic>
  ea:	4509                	li	a0,2
  ec:	00000097          	auipc	ra,0x0
  f0:	5f0080e7          	jalr	1520(ra) # 6dc <sigalarm>
  for(i = 0; i < 1000*500000; i++){
  f4:	4481                	li	s1,0
    if((i % 1000000) == 0)
  f6:	000f4937          	lui	s2,0xf4
  fa:	2409091b          	addiw	s2,s2,576
      write(2, ".", 1);
  fe:	00001a97          	auipc	s5,0x1
 102:	abaa8a93          	addi	s5,s5,-1350 # bb8 <malloc+0x136>
    if(count > 0)
 106:	00001a17          	auipc	s4,0x1
 10a:	c1aa0a13          	addi	s4,s4,-998 # d20 <count>
  for(i = 0; i < 1000*500000; i++){
 10e:	1dcd69b7          	lui	s3,0x1dcd6
 112:	50098993          	addi	s3,s3,1280 # 1dcd6500 <__global_pointer$+0x1dcd4fe7>
 116:	a005                	j	136 <test0+0x7e>
      write(2, ".", 1);
 118:	4605                	li	a2,1
 11a:	85d6                	mv	a1,s5
 11c:	4509                	li	a0,2
 11e:	00000097          	auipc	ra,0x0
 122:	53e080e7          	jalr	1342(ra) # 65c <write>
    if(count > 0)
 126:	000a2783          	lw	a5,0(s4)
 12a:	2781                	sext.w	a5,a5
 12c:	00f04963          	bgtz	a5,13e <test0+0x86>
  for(i = 0; i < 1000*500000; i++){
 130:	2485                	addiw	s1,s1,1
 132:	01348663          	beq	s1,s3,13e <test0+0x86>
    if((i % 1000000) == 0)
 136:	0324e7bb          	remw	a5,s1,s2
 13a:	f7f5                	bnez	a5,126 <test0+0x6e>
 13c:	bff1                	j	118 <test0+0x60>
  sigalarm(0, 0);
 13e:	4581                	li	a1,0
 140:	4501                	li	a0,0
 142:	00000097          	auipc	ra,0x0
 146:	59a080e7          	jalr	1434(ra) # 6dc <sigalarm>
  if(count > 0){
 14a:	00001797          	auipc	a5,0x1
 14e:	bd67a783          	lw	a5,-1066(a5) # d20 <count>
 152:	02f05363          	blez	a5,178 <test0+0xc0>
    printf("test0 passed\n");
 156:	00001517          	auipc	a0,0x1
 15a:	a6a50513          	addi	a0,a0,-1430 # bc0 <malloc+0x13e>
 15e:	00001097          	auipc	ra,0x1
 162:	866080e7          	jalr	-1946(ra) # 9c4 <printf>
}
 166:	70e2                	ld	ra,56(sp)
 168:	7442                	ld	s0,48(sp)
 16a:	74a2                	ld	s1,40(sp)
 16c:	7902                	ld	s2,32(sp)
 16e:	69e2                	ld	s3,24(sp)
 170:	6a42                	ld	s4,16(sp)
 172:	6aa2                	ld	s5,8(sp)
 174:	6121                	addi	sp,sp,64
 176:	8082                	ret
    printf("\ntest0 failed: the kernel never called the alarm handler\n");
 178:	00001517          	auipc	a0,0x1
 17c:	a5850513          	addi	a0,a0,-1448 # bd0 <malloc+0x14e>
 180:	00001097          	auipc	ra,0x1
 184:	844080e7          	jalr	-1980(ra) # 9c4 <printf>
}
 188:	bff9                	j	166 <test0+0xae>

000000000000018a <foo>:
void __attribute__ ((noinline)) foo(int i, int *j) {
 18a:	1101                	addi	sp,sp,-32
 18c:	ec06                	sd	ra,24(sp)
 18e:	e822                	sd	s0,16(sp)
 190:	e426                	sd	s1,8(sp)
 192:	1000                	addi	s0,sp,32
 194:	84ae                	mv	s1,a1
  if((i % 2500000) == 0) {
 196:	002627b7          	lui	a5,0x262
 19a:	5a07879b          	addiw	a5,a5,1440
 19e:	02f5653b          	remw	a0,a0,a5
 1a2:	c909                	beqz	a0,1b4 <foo+0x2a>
  *j += 1;
 1a4:	409c                	lw	a5,0(s1)
 1a6:	2785                	addiw	a5,a5,1
 1a8:	c09c                	sw	a5,0(s1)
}
 1aa:	60e2                	ld	ra,24(sp)
 1ac:	6442                	ld	s0,16(sp)
 1ae:	64a2                	ld	s1,8(sp)
 1b0:	6105                	addi	sp,sp,32
 1b2:	8082                	ret
    write(2, ".", 1);
 1b4:	4605                	li	a2,1
 1b6:	00001597          	auipc	a1,0x1
 1ba:	a0258593          	addi	a1,a1,-1534 # bb8 <malloc+0x136>
 1be:	4509                	li	a0,2
 1c0:	00000097          	auipc	ra,0x0
 1c4:	49c080e7          	jalr	1180(ra) # 65c <write>
 1c8:	bff1                	j	1a4 <foo+0x1a>

00000000000001ca <test1>:
{
 1ca:	7139                	addi	sp,sp,-64
 1cc:	fc06                	sd	ra,56(sp)
 1ce:	f822                	sd	s0,48(sp)
 1d0:	f426                	sd	s1,40(sp)
 1d2:	f04a                	sd	s2,32(sp)
 1d4:	ec4e                	sd	s3,24(sp)
 1d6:	e852                	sd	s4,16(sp)
 1d8:	0080                	addi	s0,sp,64
  printf("test1 start\n");
 1da:	00001517          	auipc	a0,0x1
 1de:	a3650513          	addi	a0,a0,-1482 # c10 <malloc+0x18e>
 1e2:	00000097          	auipc	ra,0x0
 1e6:	7e2080e7          	jalr	2018(ra) # 9c4 <printf>
  count = 0;
 1ea:	00001797          	auipc	a5,0x1
 1ee:	b207ab23          	sw	zero,-1226(a5) # d20 <count>
  j = 0;
 1f2:	fc042623          	sw	zero,-52(s0)
  sigalarm(2, periodic);
 1f6:	00000597          	auipc	a1,0x0
 1fa:	e0a58593          	addi	a1,a1,-502 # 0 <periodic>
 1fe:	4509                	li	a0,2
 200:	00000097          	auipc	ra,0x0
 204:	4dc080e7          	jalr	1244(ra) # 6dc <sigalarm>
  for(i = 0; i < 500000000; i++){
 208:	4481                	li	s1,0
    if(count >= 10)
 20a:	00001a17          	auipc	s4,0x1
 20e:	b16a0a13          	addi	s4,s4,-1258 # d20 <count>
 212:	49a5                	li	s3,9
  for(i = 0; i < 500000000; i++){
 214:	1dcd6937          	lui	s2,0x1dcd6
 218:	50090913          	addi	s2,s2,1280 # 1dcd6500 <__global_pointer$+0x1dcd4fe7>
    if(count >= 10)
 21c:	000a2783          	lw	a5,0(s4)
 220:	2781                	sext.w	a5,a5
 222:	00f9cc63          	blt	s3,a5,23a <test1+0x70>
    foo(i, &j);
 226:	fcc40593          	addi	a1,s0,-52
 22a:	8526                	mv	a0,s1
 22c:	00000097          	auipc	ra,0x0
 230:	f5e080e7          	jalr	-162(ra) # 18a <foo>
  for(i = 0; i < 500000000; i++){
 234:	2485                	addiw	s1,s1,1
 236:	ff2493e3          	bne	s1,s2,21c <test1+0x52>
  if(count < 10){
 23a:	00001717          	auipc	a4,0x1
 23e:	ae672703          	lw	a4,-1306(a4) # d20 <count>
 242:	47a5                	li	a5,9
 244:	02e7d663          	bge	a5,a4,270 <test1+0xa6>
  } else if(i != j){
 248:	fcc42783          	lw	a5,-52(s0)
 24c:	02978b63          	beq	a5,s1,282 <test1+0xb8>
    printf("\ntest1 failed: foo() executed fewer times than it was called\n");
 250:	00001517          	auipc	a0,0x1
 254:	a0050513          	addi	a0,a0,-1536 # c50 <malloc+0x1ce>
 258:	00000097          	auipc	ra,0x0
 25c:	76c080e7          	jalr	1900(ra) # 9c4 <printf>
}
 260:	70e2                	ld	ra,56(sp)
 262:	7442                	ld	s0,48(sp)
 264:	74a2                	ld	s1,40(sp)
 266:	7902                	ld	s2,32(sp)
 268:	69e2                	ld	s3,24(sp)
 26a:	6a42                	ld	s4,16(sp)
 26c:	6121                	addi	sp,sp,64
 26e:	8082                	ret
    printf("\ntest1 failed: too few calls to the handler\n");
 270:	00001517          	auipc	a0,0x1
 274:	9b050513          	addi	a0,a0,-1616 # c20 <malloc+0x19e>
 278:	00000097          	auipc	ra,0x0
 27c:	74c080e7          	jalr	1868(ra) # 9c4 <printf>
 280:	b7c5                	j	260 <test1+0x96>
    printf("test1 passed\n");
 282:	00001517          	auipc	a0,0x1
 286:	a0e50513          	addi	a0,a0,-1522 # c90 <malloc+0x20e>
 28a:	00000097          	auipc	ra,0x0
 28e:	73a080e7          	jalr	1850(ra) # 9c4 <printf>
}
 292:	b7f9                	j	260 <test1+0x96>

0000000000000294 <test2>:
{
 294:	715d                	addi	sp,sp,-80
 296:	e486                	sd	ra,72(sp)
 298:	e0a2                	sd	s0,64(sp)
 29a:	fc26                	sd	s1,56(sp)
 29c:	f84a                	sd	s2,48(sp)
 29e:	f44e                	sd	s3,40(sp)
 2a0:	f052                	sd	s4,32(sp)
 2a2:	ec56                	sd	s5,24(sp)
 2a4:	0880                	addi	s0,sp,80
  printf("test2 start\n");
 2a6:	00001517          	auipc	a0,0x1
 2aa:	9fa50513          	addi	a0,a0,-1542 # ca0 <malloc+0x21e>
 2ae:	00000097          	auipc	ra,0x0
 2b2:	716080e7          	jalr	1814(ra) # 9c4 <printf>
  if ((pid = fork()) < 0) {
 2b6:	00000097          	auipc	ra,0x0
 2ba:	37e080e7          	jalr	894(ra) # 634 <fork>
 2be:	04054263          	bltz	a0,302 <test2+0x6e>
 2c2:	84aa                	mv	s1,a0
  if (pid == 0) {
 2c4:	e539                	bnez	a0,312 <test2+0x7e>
    count = 0;
 2c6:	00001797          	auipc	a5,0x1
 2ca:	a407ad23          	sw	zero,-1446(a5) # d20 <count>
    sigalarm(2, slow_handler);
 2ce:	00000597          	auipc	a1,0x0
 2d2:	d6c58593          	addi	a1,a1,-660 # 3a <slow_handler>
 2d6:	4509                	li	a0,2
 2d8:	00000097          	auipc	ra,0x0
 2dc:	404080e7          	jalr	1028(ra) # 6dc <sigalarm>
      if((i % 1000000) == 0)
 2e0:	000f4937          	lui	s2,0xf4
 2e4:	2409091b          	addiw	s2,s2,576
        write(2, ".", 1);
 2e8:	00001a97          	auipc	s5,0x1
 2ec:	8d0a8a93          	addi	s5,s5,-1840 # bb8 <malloc+0x136>
      if(count > 0)
 2f0:	00001a17          	auipc	s4,0x1
 2f4:	a30a0a13          	addi	s4,s4,-1488 # d20 <count>
    for(i = 0; i < 1000*500000; i++){
 2f8:	1dcd69b7          	lui	s3,0x1dcd6
 2fc:	50098993          	addi	s3,s3,1280 # 1dcd6500 <__global_pointer$+0x1dcd4fe7>
 300:	a891                	j	354 <test2+0xc0>
    printf("test2: fork failed\n");
 302:	00001517          	auipc	a0,0x1
 306:	9ae50513          	addi	a0,a0,-1618 # cb0 <malloc+0x22e>
 30a:	00000097          	auipc	ra,0x0
 30e:	6ba080e7          	jalr	1722(ra) # 9c4 <printf>
  wait(&status);
 312:	fbc40513          	addi	a0,s0,-68
 316:	00000097          	auipc	ra,0x0
 31a:	32e080e7          	jalr	814(ra) # 644 <wait>
  if (status == 0) {
 31e:	fbc42783          	lw	a5,-68(s0)
 322:	c7a5                	beqz	a5,38a <test2+0xf6>
}
 324:	60a6                	ld	ra,72(sp)
 326:	6406                	ld	s0,64(sp)
 328:	74e2                	ld	s1,56(sp)
 32a:	7942                	ld	s2,48(sp)
 32c:	79a2                	ld	s3,40(sp)
 32e:	7a02                	ld	s4,32(sp)
 330:	6ae2                	ld	s5,24(sp)
 332:	6161                	addi	sp,sp,80
 334:	8082                	ret
        write(2, ".", 1);
 336:	4605                	li	a2,1
 338:	85d6                	mv	a1,s5
 33a:	4509                	li	a0,2
 33c:	00000097          	auipc	ra,0x0
 340:	320080e7          	jalr	800(ra) # 65c <write>
      if(count > 0)
 344:	000a2783          	lw	a5,0(s4)
 348:	2781                	sext.w	a5,a5
 34a:	00f04963          	bgtz	a5,35c <test2+0xc8>
    for(i = 0; i < 1000*500000; i++){
 34e:	2485                	addiw	s1,s1,1
 350:	01348663          	beq	s1,s3,35c <test2+0xc8>
      if((i % 1000000) == 0)
 354:	0324e7bb          	remw	a5,s1,s2
 358:	f7f5                	bnez	a5,344 <test2+0xb0>
 35a:	bff1                	j	336 <test2+0xa2>
    if (count == 0) {
 35c:	00001797          	auipc	a5,0x1
 360:	9c47a783          	lw	a5,-1596(a5) # d20 <count>
 364:	ef91                	bnez	a5,380 <test2+0xec>
      printf("\ntest2 failed: alarm not called\n");
 366:	00001517          	auipc	a0,0x1
 36a:	96250513          	addi	a0,a0,-1694 # cc8 <malloc+0x246>
 36e:	00000097          	auipc	ra,0x0
 372:	656080e7          	jalr	1622(ra) # 9c4 <printf>
      exit(1);
 376:	4505                	li	a0,1
 378:	00000097          	auipc	ra,0x0
 37c:	2c4080e7          	jalr	708(ra) # 63c <exit>
    exit(0);
 380:	4501                	li	a0,0
 382:	00000097          	auipc	ra,0x0
 386:	2ba080e7          	jalr	698(ra) # 63c <exit>
    printf("test2 passed\n");
 38a:	00001517          	auipc	a0,0x1
 38e:	96650513          	addi	a0,a0,-1690 # cf0 <malloc+0x26e>
 392:	00000097          	auipc	ra,0x0
 396:	632080e7          	jalr	1586(ra) # 9c4 <printf>
}
 39a:	b769                	j	324 <test2+0x90>

000000000000039c <main>:
{
 39c:	1141                	addi	sp,sp,-16
 39e:	e406                	sd	ra,8(sp)
 3a0:	e022                	sd	s0,0(sp)
 3a2:	0800                	addi	s0,sp,16
  test0();
 3a4:	00000097          	auipc	ra,0x0
 3a8:	d14080e7          	jalr	-748(ra) # b8 <test0>
  test1();
 3ac:	00000097          	auipc	ra,0x0
 3b0:	e1e080e7          	jalr	-482(ra) # 1ca <test1>
  test2();
 3b4:	00000097          	auipc	ra,0x0
 3b8:	ee0080e7          	jalr	-288(ra) # 294 <test2>
  exit(0);
 3bc:	4501                	li	a0,0
 3be:	00000097          	auipc	ra,0x0
 3c2:	27e080e7          	jalr	638(ra) # 63c <exit>

00000000000003c6 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 3c6:	1141                	addi	sp,sp,-16
 3c8:	e422                	sd	s0,8(sp)
 3ca:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3cc:	87aa                	mv	a5,a0
 3ce:	0585                	addi	a1,a1,1
 3d0:	0785                	addi	a5,a5,1
 3d2:	fff5c703          	lbu	a4,-1(a1)
 3d6:	fee78fa3          	sb	a4,-1(a5)
 3da:	fb75                	bnez	a4,3ce <strcpy+0x8>
    ;
  return os;
}
 3dc:	6422                	ld	s0,8(sp)
 3de:	0141                	addi	sp,sp,16
 3e0:	8082                	ret

00000000000003e2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3e2:	1141                	addi	sp,sp,-16
 3e4:	e422                	sd	s0,8(sp)
 3e6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3e8:	00054783          	lbu	a5,0(a0)
 3ec:	cb91                	beqz	a5,400 <strcmp+0x1e>
 3ee:	0005c703          	lbu	a4,0(a1)
 3f2:	00f71763          	bne	a4,a5,400 <strcmp+0x1e>
    p++, q++;
 3f6:	0505                	addi	a0,a0,1
 3f8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 3fa:	00054783          	lbu	a5,0(a0)
 3fe:	fbe5                	bnez	a5,3ee <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 400:	0005c503          	lbu	a0,0(a1)
}
 404:	40a7853b          	subw	a0,a5,a0
 408:	6422                	ld	s0,8(sp)
 40a:	0141                	addi	sp,sp,16
 40c:	8082                	ret

000000000000040e <strlen>:

uint
strlen(const char *s)
{
 40e:	1141                	addi	sp,sp,-16
 410:	e422                	sd	s0,8(sp)
 412:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 414:	00054783          	lbu	a5,0(a0)
 418:	cf91                	beqz	a5,434 <strlen+0x26>
 41a:	0505                	addi	a0,a0,1
 41c:	87aa                	mv	a5,a0
 41e:	4685                	li	a3,1
 420:	9e89                	subw	a3,a3,a0
 422:	00f6853b          	addw	a0,a3,a5
 426:	0785                	addi	a5,a5,1
 428:	fff7c703          	lbu	a4,-1(a5)
 42c:	fb7d                	bnez	a4,422 <strlen+0x14>
    ;
  return n;
}
 42e:	6422                	ld	s0,8(sp)
 430:	0141                	addi	sp,sp,16
 432:	8082                	ret
  for(n = 0; s[n]; n++)
 434:	4501                	li	a0,0
 436:	bfe5                	j	42e <strlen+0x20>

0000000000000438 <memset>:

void*
memset(void *dst, int c, uint n)
{
 438:	1141                	addi	sp,sp,-16
 43a:	e422                	sd	s0,8(sp)
 43c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 43e:	ce09                	beqz	a2,458 <memset+0x20>
 440:	87aa                	mv	a5,a0
 442:	fff6071b          	addiw	a4,a2,-1
 446:	1702                	slli	a4,a4,0x20
 448:	9301                	srli	a4,a4,0x20
 44a:	0705                	addi	a4,a4,1
 44c:	972a                	add	a4,a4,a0
    cdst[i] = c;
 44e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 452:	0785                	addi	a5,a5,1
 454:	fee79de3          	bne	a5,a4,44e <memset+0x16>
  }
  return dst;
}
 458:	6422                	ld	s0,8(sp)
 45a:	0141                	addi	sp,sp,16
 45c:	8082                	ret

000000000000045e <strchr>:

char*
strchr(const char *s, char c)
{
 45e:	1141                	addi	sp,sp,-16
 460:	e422                	sd	s0,8(sp)
 462:	0800                	addi	s0,sp,16
  for(; *s; s++)
 464:	00054783          	lbu	a5,0(a0)
 468:	cb99                	beqz	a5,47e <strchr+0x20>
    if(*s == c)
 46a:	00f58763          	beq	a1,a5,478 <strchr+0x1a>
  for(; *s; s++)
 46e:	0505                	addi	a0,a0,1
 470:	00054783          	lbu	a5,0(a0)
 474:	fbfd                	bnez	a5,46a <strchr+0xc>
      return (char*)s;
  return 0;
 476:	4501                	li	a0,0
}
 478:	6422                	ld	s0,8(sp)
 47a:	0141                	addi	sp,sp,16
 47c:	8082                	ret
  return 0;
 47e:	4501                	li	a0,0
 480:	bfe5                	j	478 <strchr+0x1a>

0000000000000482 <gets>:

char*
gets(char *buf, int max)
{
 482:	711d                	addi	sp,sp,-96
 484:	ec86                	sd	ra,88(sp)
 486:	e8a2                	sd	s0,80(sp)
 488:	e4a6                	sd	s1,72(sp)
 48a:	e0ca                	sd	s2,64(sp)
 48c:	fc4e                	sd	s3,56(sp)
 48e:	f852                	sd	s4,48(sp)
 490:	f456                	sd	s5,40(sp)
 492:	f05a                	sd	s6,32(sp)
 494:	ec5e                	sd	s7,24(sp)
 496:	1080                	addi	s0,sp,96
 498:	8baa                	mv	s7,a0
 49a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 49c:	892a                	mv	s2,a0
 49e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4a0:	4aa9                	li	s5,10
 4a2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4a4:	89a6                	mv	s3,s1
 4a6:	2485                	addiw	s1,s1,1
 4a8:	0344d863          	bge	s1,s4,4d8 <gets+0x56>
    cc = read(0, &c, 1);
 4ac:	4605                	li	a2,1
 4ae:	faf40593          	addi	a1,s0,-81
 4b2:	4501                	li	a0,0
 4b4:	00000097          	auipc	ra,0x0
 4b8:	1a0080e7          	jalr	416(ra) # 654 <read>
    if(cc < 1)
 4bc:	00a05e63          	blez	a0,4d8 <gets+0x56>
    buf[i++] = c;
 4c0:	faf44783          	lbu	a5,-81(s0)
 4c4:	00f90023          	sb	a5,0(s2) # f4000 <__global_pointer$+0xf2ae7>
    if(c == '\n' || c == '\r')
 4c8:	01578763          	beq	a5,s5,4d6 <gets+0x54>
 4cc:	0905                	addi	s2,s2,1
 4ce:	fd679be3          	bne	a5,s6,4a4 <gets+0x22>
  for(i=0; i+1 < max; ){
 4d2:	89a6                	mv	s3,s1
 4d4:	a011                	j	4d8 <gets+0x56>
 4d6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4d8:	99de                	add	s3,s3,s7
 4da:	00098023          	sb	zero,0(s3)
  return buf;
}
 4de:	855e                	mv	a0,s7
 4e0:	60e6                	ld	ra,88(sp)
 4e2:	6446                	ld	s0,80(sp)
 4e4:	64a6                	ld	s1,72(sp)
 4e6:	6906                	ld	s2,64(sp)
 4e8:	79e2                	ld	s3,56(sp)
 4ea:	7a42                	ld	s4,48(sp)
 4ec:	7aa2                	ld	s5,40(sp)
 4ee:	7b02                	ld	s6,32(sp)
 4f0:	6be2                	ld	s7,24(sp)
 4f2:	6125                	addi	sp,sp,96
 4f4:	8082                	ret

00000000000004f6 <stat>:

int
stat(const char *n, struct stat *st)
{
 4f6:	1101                	addi	sp,sp,-32
 4f8:	ec06                	sd	ra,24(sp)
 4fa:	e822                	sd	s0,16(sp)
 4fc:	e426                	sd	s1,8(sp)
 4fe:	e04a                	sd	s2,0(sp)
 500:	1000                	addi	s0,sp,32
 502:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 504:	4581                	li	a1,0
 506:	00000097          	auipc	ra,0x0
 50a:	176080e7          	jalr	374(ra) # 67c <open>
  if(fd < 0)
 50e:	02054563          	bltz	a0,538 <stat+0x42>
 512:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 514:	85ca                	mv	a1,s2
 516:	00000097          	auipc	ra,0x0
 51a:	17e080e7          	jalr	382(ra) # 694 <fstat>
 51e:	892a                	mv	s2,a0
  close(fd);
 520:	8526                	mv	a0,s1
 522:	00000097          	auipc	ra,0x0
 526:	142080e7          	jalr	322(ra) # 664 <close>
  return r;
}
 52a:	854a                	mv	a0,s2
 52c:	60e2                	ld	ra,24(sp)
 52e:	6442                	ld	s0,16(sp)
 530:	64a2                	ld	s1,8(sp)
 532:	6902                	ld	s2,0(sp)
 534:	6105                	addi	sp,sp,32
 536:	8082                	ret
    return -1;
 538:	597d                	li	s2,-1
 53a:	bfc5                	j	52a <stat+0x34>

000000000000053c <atoi>:

int
atoi(const char *s)
{
 53c:	1141                	addi	sp,sp,-16
 53e:	e422                	sd	s0,8(sp)
 540:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 542:	00054603          	lbu	a2,0(a0)
 546:	fd06079b          	addiw	a5,a2,-48
 54a:	0ff7f793          	andi	a5,a5,255
 54e:	4725                	li	a4,9
 550:	02f76963          	bltu	a4,a5,582 <atoi+0x46>
 554:	86aa                	mv	a3,a0
  n = 0;
 556:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 558:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 55a:	0685                	addi	a3,a3,1
 55c:	0025179b          	slliw	a5,a0,0x2
 560:	9fa9                	addw	a5,a5,a0
 562:	0017979b          	slliw	a5,a5,0x1
 566:	9fb1                	addw	a5,a5,a2
 568:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 56c:	0006c603          	lbu	a2,0(a3)
 570:	fd06071b          	addiw	a4,a2,-48
 574:	0ff77713          	andi	a4,a4,255
 578:	fee5f1e3          	bgeu	a1,a4,55a <atoi+0x1e>
  return n;
}
 57c:	6422                	ld	s0,8(sp)
 57e:	0141                	addi	sp,sp,16
 580:	8082                	ret
  n = 0;
 582:	4501                	li	a0,0
 584:	bfe5                	j	57c <atoi+0x40>

0000000000000586 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 586:	1141                	addi	sp,sp,-16
 588:	e422                	sd	s0,8(sp)
 58a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 58c:	02b57663          	bgeu	a0,a1,5b8 <memmove+0x32>
    while(n-- > 0)
 590:	02c05163          	blez	a2,5b2 <memmove+0x2c>
 594:	fff6079b          	addiw	a5,a2,-1
 598:	1782                	slli	a5,a5,0x20
 59a:	9381                	srli	a5,a5,0x20
 59c:	0785                	addi	a5,a5,1
 59e:	97aa                	add	a5,a5,a0
  dst = vdst;
 5a0:	872a                	mv	a4,a0
      *dst++ = *src++;
 5a2:	0585                	addi	a1,a1,1
 5a4:	0705                	addi	a4,a4,1
 5a6:	fff5c683          	lbu	a3,-1(a1)
 5aa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5ae:	fee79ae3          	bne	a5,a4,5a2 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5b2:	6422                	ld	s0,8(sp)
 5b4:	0141                	addi	sp,sp,16
 5b6:	8082                	ret
    dst += n;
 5b8:	00c50733          	add	a4,a0,a2
    src += n;
 5bc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5be:	fec05ae3          	blez	a2,5b2 <memmove+0x2c>
 5c2:	fff6079b          	addiw	a5,a2,-1
 5c6:	1782                	slli	a5,a5,0x20
 5c8:	9381                	srli	a5,a5,0x20
 5ca:	fff7c793          	not	a5,a5
 5ce:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5d0:	15fd                	addi	a1,a1,-1
 5d2:	177d                	addi	a4,a4,-1
 5d4:	0005c683          	lbu	a3,0(a1)
 5d8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5dc:	fee79ae3          	bne	a5,a4,5d0 <memmove+0x4a>
 5e0:	bfc9                	j	5b2 <memmove+0x2c>

00000000000005e2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5e2:	1141                	addi	sp,sp,-16
 5e4:	e422                	sd	s0,8(sp)
 5e6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5e8:	ca05                	beqz	a2,618 <memcmp+0x36>
 5ea:	fff6069b          	addiw	a3,a2,-1
 5ee:	1682                	slli	a3,a3,0x20
 5f0:	9281                	srli	a3,a3,0x20
 5f2:	0685                	addi	a3,a3,1
 5f4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5f6:	00054783          	lbu	a5,0(a0)
 5fa:	0005c703          	lbu	a4,0(a1)
 5fe:	00e79863          	bne	a5,a4,60e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 602:	0505                	addi	a0,a0,1
    p2++;
 604:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 606:	fed518e3          	bne	a0,a3,5f6 <memcmp+0x14>
  }
  return 0;
 60a:	4501                	li	a0,0
 60c:	a019                	j	612 <memcmp+0x30>
      return *p1 - *p2;
 60e:	40e7853b          	subw	a0,a5,a4
}
 612:	6422                	ld	s0,8(sp)
 614:	0141                	addi	sp,sp,16
 616:	8082                	ret
  return 0;
 618:	4501                	li	a0,0
 61a:	bfe5                	j	612 <memcmp+0x30>

000000000000061c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 61c:	1141                	addi	sp,sp,-16
 61e:	e406                	sd	ra,8(sp)
 620:	e022                	sd	s0,0(sp)
 622:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 624:	00000097          	auipc	ra,0x0
 628:	f62080e7          	jalr	-158(ra) # 586 <memmove>
}
 62c:	60a2                	ld	ra,8(sp)
 62e:	6402                	ld	s0,0(sp)
 630:	0141                	addi	sp,sp,16
 632:	8082                	ret

0000000000000634 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 634:	4885                	li	a7,1
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <exit>:
.global exit
exit:
 li a7, SYS_exit
 63c:	4889                	li	a7,2
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <wait>:
.global wait
wait:
 li a7, SYS_wait
 644:	488d                	li	a7,3
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 64c:	4891                	li	a7,4
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <read>:
.global read
read:
 li a7, SYS_read
 654:	4895                	li	a7,5
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <write>:
.global write
write:
 li a7, SYS_write
 65c:	48c1                	li	a7,16
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <close>:
.global close
close:
 li a7, SYS_close
 664:	48d5                	li	a7,21
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <kill>:
.global kill
kill:
 li a7, SYS_kill
 66c:	4899                	li	a7,6
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <exec>:
.global exec
exec:
 li a7, SYS_exec
 674:	489d                	li	a7,7
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <open>:
.global open
open:
 li a7, SYS_open
 67c:	48bd                	li	a7,15
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 684:	48c5                	li	a7,17
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 68c:	48c9                	li	a7,18
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 694:	48a1                	li	a7,8
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <link>:
.global link
link:
 li a7, SYS_link
 69c:	48cd                	li	a7,19
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6a4:	48d1                	li	a7,20
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6ac:	48a5                	li	a7,9
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6b4:	48a9                	li	a7,10
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6bc:	48ad                	li	a7,11
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6c4:	48b1                	li	a7,12
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6cc:	48b5                	li	a7,13
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6d4:	48b9                	li	a7,14
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 6dc:	48d9                	li	a7,22
 ecall
 6de:	00000073          	ecall
 ret
 6e2:	8082                	ret

00000000000006e4 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 6e4:	48dd                	li	a7,23
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6ec:	1101                	addi	sp,sp,-32
 6ee:	ec06                	sd	ra,24(sp)
 6f0:	e822                	sd	s0,16(sp)
 6f2:	1000                	addi	s0,sp,32
 6f4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6f8:	4605                	li	a2,1
 6fa:	fef40593          	addi	a1,s0,-17
 6fe:	00000097          	auipc	ra,0x0
 702:	f5e080e7          	jalr	-162(ra) # 65c <write>
}
 706:	60e2                	ld	ra,24(sp)
 708:	6442                	ld	s0,16(sp)
 70a:	6105                	addi	sp,sp,32
 70c:	8082                	ret

000000000000070e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 70e:	7139                	addi	sp,sp,-64
 710:	fc06                	sd	ra,56(sp)
 712:	f822                	sd	s0,48(sp)
 714:	f426                	sd	s1,40(sp)
 716:	f04a                	sd	s2,32(sp)
 718:	ec4e                	sd	s3,24(sp)
 71a:	0080                	addi	s0,sp,64
 71c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 71e:	c299                	beqz	a3,724 <printint+0x16>
 720:	0805c863          	bltz	a1,7b0 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 724:	2581                	sext.w	a1,a1
  neg = 0;
 726:	4881                	li	a7,0
 728:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 72c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 72e:	2601                	sext.w	a2,a2
 730:	00000517          	auipc	a0,0x0
 734:	5d850513          	addi	a0,a0,1496 # d08 <digits>
 738:	883a                	mv	a6,a4
 73a:	2705                	addiw	a4,a4,1
 73c:	02c5f7bb          	remuw	a5,a1,a2
 740:	1782                	slli	a5,a5,0x20
 742:	9381                	srli	a5,a5,0x20
 744:	97aa                	add	a5,a5,a0
 746:	0007c783          	lbu	a5,0(a5)
 74a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 74e:	0005879b          	sext.w	a5,a1
 752:	02c5d5bb          	divuw	a1,a1,a2
 756:	0685                	addi	a3,a3,1
 758:	fec7f0e3          	bgeu	a5,a2,738 <printint+0x2a>
  if(neg)
 75c:	00088b63          	beqz	a7,772 <printint+0x64>
    buf[i++] = '-';
 760:	fd040793          	addi	a5,s0,-48
 764:	973e                	add	a4,a4,a5
 766:	02d00793          	li	a5,45
 76a:	fef70823          	sb	a5,-16(a4)
 76e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 772:	02e05863          	blez	a4,7a2 <printint+0x94>
 776:	fc040793          	addi	a5,s0,-64
 77a:	00e78933          	add	s2,a5,a4
 77e:	fff78993          	addi	s3,a5,-1
 782:	99ba                	add	s3,s3,a4
 784:	377d                	addiw	a4,a4,-1
 786:	1702                	slli	a4,a4,0x20
 788:	9301                	srli	a4,a4,0x20
 78a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 78e:	fff94583          	lbu	a1,-1(s2)
 792:	8526                	mv	a0,s1
 794:	00000097          	auipc	ra,0x0
 798:	f58080e7          	jalr	-168(ra) # 6ec <putc>
  while(--i >= 0)
 79c:	197d                	addi	s2,s2,-1
 79e:	ff3918e3          	bne	s2,s3,78e <printint+0x80>
}
 7a2:	70e2                	ld	ra,56(sp)
 7a4:	7442                	ld	s0,48(sp)
 7a6:	74a2                	ld	s1,40(sp)
 7a8:	7902                	ld	s2,32(sp)
 7aa:	69e2                	ld	s3,24(sp)
 7ac:	6121                	addi	sp,sp,64
 7ae:	8082                	ret
    x = -xx;
 7b0:	40b005bb          	negw	a1,a1
    neg = 1;
 7b4:	4885                	li	a7,1
    x = -xx;
 7b6:	bf8d                	j	728 <printint+0x1a>

00000000000007b8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7b8:	7119                	addi	sp,sp,-128
 7ba:	fc86                	sd	ra,120(sp)
 7bc:	f8a2                	sd	s0,112(sp)
 7be:	f4a6                	sd	s1,104(sp)
 7c0:	f0ca                	sd	s2,96(sp)
 7c2:	ecce                	sd	s3,88(sp)
 7c4:	e8d2                	sd	s4,80(sp)
 7c6:	e4d6                	sd	s5,72(sp)
 7c8:	e0da                	sd	s6,64(sp)
 7ca:	fc5e                	sd	s7,56(sp)
 7cc:	f862                	sd	s8,48(sp)
 7ce:	f466                	sd	s9,40(sp)
 7d0:	f06a                	sd	s10,32(sp)
 7d2:	ec6e                	sd	s11,24(sp)
 7d4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7d6:	0005c903          	lbu	s2,0(a1)
 7da:	18090f63          	beqz	s2,978 <vprintf+0x1c0>
 7de:	8aaa                	mv	s5,a0
 7e0:	8b32                	mv	s6,a2
 7e2:	00158493          	addi	s1,a1,1
  state = 0;
 7e6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7e8:	02500a13          	li	s4,37
      if(c == 'd'){
 7ec:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 7f0:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 7f4:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 7f8:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7fc:	00000b97          	auipc	s7,0x0
 800:	50cb8b93          	addi	s7,s7,1292 # d08 <digits>
 804:	a839                	j	822 <vprintf+0x6a>
        putc(fd, c);
 806:	85ca                	mv	a1,s2
 808:	8556                	mv	a0,s5
 80a:	00000097          	auipc	ra,0x0
 80e:	ee2080e7          	jalr	-286(ra) # 6ec <putc>
 812:	a019                	j	818 <vprintf+0x60>
    } else if(state == '%'){
 814:	01498f63          	beq	s3,s4,832 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 818:	0485                	addi	s1,s1,1
 81a:	fff4c903          	lbu	s2,-1(s1)
 81e:	14090d63          	beqz	s2,978 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 822:	0009079b          	sext.w	a5,s2
    if(state == 0){
 826:	fe0997e3          	bnez	s3,814 <vprintf+0x5c>
      if(c == '%'){
 82a:	fd479ee3          	bne	a5,s4,806 <vprintf+0x4e>
        state = '%';
 82e:	89be                	mv	s3,a5
 830:	b7e5                	j	818 <vprintf+0x60>
      if(c == 'd'){
 832:	05878063          	beq	a5,s8,872 <vprintf+0xba>
      } else if(c == 'l') {
 836:	05978c63          	beq	a5,s9,88e <vprintf+0xd6>
      } else if(c == 'x') {
 83a:	07a78863          	beq	a5,s10,8aa <vprintf+0xf2>
      } else if(c == 'p') {
 83e:	09b78463          	beq	a5,s11,8c6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 842:	07300713          	li	a4,115
 846:	0ce78663          	beq	a5,a4,912 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 84a:	06300713          	li	a4,99
 84e:	0ee78e63          	beq	a5,a4,94a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 852:	11478863          	beq	a5,s4,962 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 856:	85d2                	mv	a1,s4
 858:	8556                	mv	a0,s5
 85a:	00000097          	auipc	ra,0x0
 85e:	e92080e7          	jalr	-366(ra) # 6ec <putc>
        putc(fd, c);
 862:	85ca                	mv	a1,s2
 864:	8556                	mv	a0,s5
 866:	00000097          	auipc	ra,0x0
 86a:	e86080e7          	jalr	-378(ra) # 6ec <putc>
      }
      state = 0;
 86e:	4981                	li	s3,0
 870:	b765                	j	818 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 872:	008b0913          	addi	s2,s6,8
 876:	4685                	li	a3,1
 878:	4629                	li	a2,10
 87a:	000b2583          	lw	a1,0(s6)
 87e:	8556                	mv	a0,s5
 880:	00000097          	auipc	ra,0x0
 884:	e8e080e7          	jalr	-370(ra) # 70e <printint>
 888:	8b4a                	mv	s6,s2
      state = 0;
 88a:	4981                	li	s3,0
 88c:	b771                	j	818 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 88e:	008b0913          	addi	s2,s6,8
 892:	4681                	li	a3,0
 894:	4629                	li	a2,10
 896:	000b2583          	lw	a1,0(s6)
 89a:	8556                	mv	a0,s5
 89c:	00000097          	auipc	ra,0x0
 8a0:	e72080e7          	jalr	-398(ra) # 70e <printint>
 8a4:	8b4a                	mv	s6,s2
      state = 0;
 8a6:	4981                	li	s3,0
 8a8:	bf85                	j	818 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 8aa:	008b0913          	addi	s2,s6,8
 8ae:	4681                	li	a3,0
 8b0:	4641                	li	a2,16
 8b2:	000b2583          	lw	a1,0(s6)
 8b6:	8556                	mv	a0,s5
 8b8:	00000097          	auipc	ra,0x0
 8bc:	e56080e7          	jalr	-426(ra) # 70e <printint>
 8c0:	8b4a                	mv	s6,s2
      state = 0;
 8c2:	4981                	li	s3,0
 8c4:	bf91                	j	818 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8c6:	008b0793          	addi	a5,s6,8
 8ca:	f8f43423          	sd	a5,-120(s0)
 8ce:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8d2:	03000593          	li	a1,48
 8d6:	8556                	mv	a0,s5
 8d8:	00000097          	auipc	ra,0x0
 8dc:	e14080e7          	jalr	-492(ra) # 6ec <putc>
  putc(fd, 'x');
 8e0:	85ea                	mv	a1,s10
 8e2:	8556                	mv	a0,s5
 8e4:	00000097          	auipc	ra,0x0
 8e8:	e08080e7          	jalr	-504(ra) # 6ec <putc>
 8ec:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8ee:	03c9d793          	srli	a5,s3,0x3c
 8f2:	97de                	add	a5,a5,s7
 8f4:	0007c583          	lbu	a1,0(a5)
 8f8:	8556                	mv	a0,s5
 8fa:	00000097          	auipc	ra,0x0
 8fe:	df2080e7          	jalr	-526(ra) # 6ec <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 902:	0992                	slli	s3,s3,0x4
 904:	397d                	addiw	s2,s2,-1
 906:	fe0914e3          	bnez	s2,8ee <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 90a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 90e:	4981                	li	s3,0
 910:	b721                	j	818 <vprintf+0x60>
        s = va_arg(ap, char*);
 912:	008b0993          	addi	s3,s6,8
 916:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 91a:	02090163          	beqz	s2,93c <vprintf+0x184>
        while(*s != 0){
 91e:	00094583          	lbu	a1,0(s2)
 922:	c9a1                	beqz	a1,972 <vprintf+0x1ba>
          putc(fd, *s);
 924:	8556                	mv	a0,s5
 926:	00000097          	auipc	ra,0x0
 92a:	dc6080e7          	jalr	-570(ra) # 6ec <putc>
          s++;
 92e:	0905                	addi	s2,s2,1
        while(*s != 0){
 930:	00094583          	lbu	a1,0(s2)
 934:	f9e5                	bnez	a1,924 <vprintf+0x16c>
        s = va_arg(ap, char*);
 936:	8b4e                	mv	s6,s3
      state = 0;
 938:	4981                	li	s3,0
 93a:	bdf9                	j	818 <vprintf+0x60>
          s = "(null)";
 93c:	00000917          	auipc	s2,0x0
 940:	3c490913          	addi	s2,s2,964 # d00 <malloc+0x27e>
        while(*s != 0){
 944:	02800593          	li	a1,40
 948:	bff1                	j	924 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 94a:	008b0913          	addi	s2,s6,8
 94e:	000b4583          	lbu	a1,0(s6)
 952:	8556                	mv	a0,s5
 954:	00000097          	auipc	ra,0x0
 958:	d98080e7          	jalr	-616(ra) # 6ec <putc>
 95c:	8b4a                	mv	s6,s2
      state = 0;
 95e:	4981                	li	s3,0
 960:	bd65                	j	818 <vprintf+0x60>
        putc(fd, c);
 962:	85d2                	mv	a1,s4
 964:	8556                	mv	a0,s5
 966:	00000097          	auipc	ra,0x0
 96a:	d86080e7          	jalr	-634(ra) # 6ec <putc>
      state = 0;
 96e:	4981                	li	s3,0
 970:	b565                	j	818 <vprintf+0x60>
        s = va_arg(ap, char*);
 972:	8b4e                	mv	s6,s3
      state = 0;
 974:	4981                	li	s3,0
 976:	b54d                	j	818 <vprintf+0x60>
    }
  }
}
 978:	70e6                	ld	ra,120(sp)
 97a:	7446                	ld	s0,112(sp)
 97c:	74a6                	ld	s1,104(sp)
 97e:	7906                	ld	s2,96(sp)
 980:	69e6                	ld	s3,88(sp)
 982:	6a46                	ld	s4,80(sp)
 984:	6aa6                	ld	s5,72(sp)
 986:	6b06                	ld	s6,64(sp)
 988:	7be2                	ld	s7,56(sp)
 98a:	7c42                	ld	s8,48(sp)
 98c:	7ca2                	ld	s9,40(sp)
 98e:	7d02                	ld	s10,32(sp)
 990:	6de2                	ld	s11,24(sp)
 992:	6109                	addi	sp,sp,128
 994:	8082                	ret

0000000000000996 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 996:	715d                	addi	sp,sp,-80
 998:	ec06                	sd	ra,24(sp)
 99a:	e822                	sd	s0,16(sp)
 99c:	1000                	addi	s0,sp,32
 99e:	e010                	sd	a2,0(s0)
 9a0:	e414                	sd	a3,8(s0)
 9a2:	e818                	sd	a4,16(s0)
 9a4:	ec1c                	sd	a5,24(s0)
 9a6:	03043023          	sd	a6,32(s0)
 9aa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9ae:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9b2:	8622                	mv	a2,s0
 9b4:	00000097          	auipc	ra,0x0
 9b8:	e04080e7          	jalr	-508(ra) # 7b8 <vprintf>
}
 9bc:	60e2                	ld	ra,24(sp)
 9be:	6442                	ld	s0,16(sp)
 9c0:	6161                	addi	sp,sp,80
 9c2:	8082                	ret

00000000000009c4 <printf>:

void
printf(const char *fmt, ...)
{
 9c4:	711d                	addi	sp,sp,-96
 9c6:	ec06                	sd	ra,24(sp)
 9c8:	e822                	sd	s0,16(sp)
 9ca:	1000                	addi	s0,sp,32
 9cc:	e40c                	sd	a1,8(s0)
 9ce:	e810                	sd	a2,16(s0)
 9d0:	ec14                	sd	a3,24(s0)
 9d2:	f018                	sd	a4,32(s0)
 9d4:	f41c                	sd	a5,40(s0)
 9d6:	03043823          	sd	a6,48(s0)
 9da:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9de:	00840613          	addi	a2,s0,8
 9e2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9e6:	85aa                	mv	a1,a0
 9e8:	4505                	li	a0,1
 9ea:	00000097          	auipc	ra,0x0
 9ee:	dce080e7          	jalr	-562(ra) # 7b8 <vprintf>
}
 9f2:	60e2                	ld	ra,24(sp)
 9f4:	6442                	ld	s0,16(sp)
 9f6:	6125                	addi	sp,sp,96
 9f8:	8082                	ret

00000000000009fa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9fa:	1141                	addi	sp,sp,-16
 9fc:	e422                	sd	s0,8(sp)
 9fe:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a00:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a04:	00000797          	auipc	a5,0x0
 a08:	3247b783          	ld	a5,804(a5) # d28 <freep>
 a0c:	a805                	j	a3c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a0e:	4618                	lw	a4,8(a2)
 a10:	9db9                	addw	a1,a1,a4
 a12:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a16:	6398                	ld	a4,0(a5)
 a18:	6318                	ld	a4,0(a4)
 a1a:	fee53823          	sd	a4,-16(a0)
 a1e:	a091                	j	a62 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a20:	ff852703          	lw	a4,-8(a0)
 a24:	9e39                	addw	a2,a2,a4
 a26:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 a28:	ff053703          	ld	a4,-16(a0)
 a2c:	e398                	sd	a4,0(a5)
 a2e:	a099                	j	a74 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a30:	6398                	ld	a4,0(a5)
 a32:	00e7e463          	bltu	a5,a4,a3a <free+0x40>
 a36:	00e6ea63          	bltu	a3,a4,a4a <free+0x50>
{
 a3a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a3c:	fed7fae3          	bgeu	a5,a3,a30 <free+0x36>
 a40:	6398                	ld	a4,0(a5)
 a42:	00e6e463          	bltu	a3,a4,a4a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a46:	fee7eae3          	bltu	a5,a4,a3a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 a4a:	ff852583          	lw	a1,-8(a0)
 a4e:	6390                	ld	a2,0(a5)
 a50:	02059713          	slli	a4,a1,0x20
 a54:	9301                	srli	a4,a4,0x20
 a56:	0712                	slli	a4,a4,0x4
 a58:	9736                	add	a4,a4,a3
 a5a:	fae60ae3          	beq	a2,a4,a0e <free+0x14>
    bp->s.ptr = p->s.ptr;
 a5e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a62:	4790                	lw	a2,8(a5)
 a64:	02061713          	slli	a4,a2,0x20
 a68:	9301                	srli	a4,a4,0x20
 a6a:	0712                	slli	a4,a4,0x4
 a6c:	973e                	add	a4,a4,a5
 a6e:	fae689e3          	beq	a3,a4,a20 <free+0x26>
  } else
    p->s.ptr = bp;
 a72:	e394                	sd	a3,0(a5)
  freep = p;
 a74:	00000717          	auipc	a4,0x0
 a78:	2af73a23          	sd	a5,692(a4) # d28 <freep>
}
 a7c:	6422                	ld	s0,8(sp)
 a7e:	0141                	addi	sp,sp,16
 a80:	8082                	ret

0000000000000a82 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a82:	7139                	addi	sp,sp,-64
 a84:	fc06                	sd	ra,56(sp)
 a86:	f822                	sd	s0,48(sp)
 a88:	f426                	sd	s1,40(sp)
 a8a:	f04a                	sd	s2,32(sp)
 a8c:	ec4e                	sd	s3,24(sp)
 a8e:	e852                	sd	s4,16(sp)
 a90:	e456                	sd	s5,8(sp)
 a92:	e05a                	sd	s6,0(sp)
 a94:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a96:	02051493          	slli	s1,a0,0x20
 a9a:	9081                	srli	s1,s1,0x20
 a9c:	04bd                	addi	s1,s1,15
 a9e:	8091                	srli	s1,s1,0x4
 aa0:	0014899b          	addiw	s3,s1,1
 aa4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 aa6:	00000517          	auipc	a0,0x0
 aaa:	28253503          	ld	a0,642(a0) # d28 <freep>
 aae:	c515                	beqz	a0,ada <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ab2:	4798                	lw	a4,8(a5)
 ab4:	02977f63          	bgeu	a4,s1,af2 <malloc+0x70>
 ab8:	8a4e                	mv	s4,s3
 aba:	0009871b          	sext.w	a4,s3
 abe:	6685                	lui	a3,0x1
 ac0:	00d77363          	bgeu	a4,a3,ac6 <malloc+0x44>
 ac4:	6a05                	lui	s4,0x1
 ac6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 aca:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ace:	00000917          	auipc	s2,0x0
 ad2:	25a90913          	addi	s2,s2,602 # d28 <freep>
  if(p == (char*)-1)
 ad6:	5afd                	li	s5,-1
 ad8:	a88d                	j	b4a <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 ada:	00000797          	auipc	a5,0x0
 ade:	25678793          	addi	a5,a5,598 # d30 <base>
 ae2:	00000717          	auipc	a4,0x0
 ae6:	24f73323          	sd	a5,582(a4) # d28 <freep>
 aea:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 aec:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 af0:	b7e1                	j	ab8 <malloc+0x36>
      if(p->s.size == nunits)
 af2:	02e48b63          	beq	s1,a4,b28 <malloc+0xa6>
        p->s.size -= nunits;
 af6:	4137073b          	subw	a4,a4,s3
 afa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 afc:	1702                	slli	a4,a4,0x20
 afe:	9301                	srli	a4,a4,0x20
 b00:	0712                	slli	a4,a4,0x4
 b02:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b04:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b08:	00000717          	auipc	a4,0x0
 b0c:	22a73023          	sd	a0,544(a4) # d28 <freep>
      return (void*)(p + 1);
 b10:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b14:	70e2                	ld	ra,56(sp)
 b16:	7442                	ld	s0,48(sp)
 b18:	74a2                	ld	s1,40(sp)
 b1a:	7902                	ld	s2,32(sp)
 b1c:	69e2                	ld	s3,24(sp)
 b1e:	6a42                	ld	s4,16(sp)
 b20:	6aa2                	ld	s5,8(sp)
 b22:	6b02                	ld	s6,0(sp)
 b24:	6121                	addi	sp,sp,64
 b26:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b28:	6398                	ld	a4,0(a5)
 b2a:	e118                	sd	a4,0(a0)
 b2c:	bff1                	j	b08 <malloc+0x86>
  hp->s.size = nu;
 b2e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b32:	0541                	addi	a0,a0,16
 b34:	00000097          	auipc	ra,0x0
 b38:	ec6080e7          	jalr	-314(ra) # 9fa <free>
  return freep;
 b3c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b40:	d971                	beqz	a0,b14 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b42:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b44:	4798                	lw	a4,8(a5)
 b46:	fa9776e3          	bgeu	a4,s1,af2 <malloc+0x70>
    if(p == freep)
 b4a:	00093703          	ld	a4,0(s2)
 b4e:	853e                	mv	a0,a5
 b50:	fef719e3          	bne	a4,a5,b42 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 b54:	8552                	mv	a0,s4
 b56:	00000097          	auipc	ra,0x0
 b5a:	b6e080e7          	jalr	-1170(ra) # 6c4 <sbrk>
  if(p == (char*)-1)
 b5e:	fd5518e3          	bne	a0,s5,b2e <malloc+0xac>
        return 0;
 b62:	4501                	li	a0,0
 b64:	bf45                	j	b14 <malloc+0x92>
