
user/_kalloctest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <ntas>:
  test2();
  exit(0);
}

int ntas(int print)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	892a                	mv	s2,a0
  int n;
  char *c;

  if (statistics(buf, SZ) <= 0) {
   e:	6585                	lui	a1,0x1
  10:	00001517          	auipc	a0,0x1
  14:	c9850513          	addi	a0,a0,-872 # ca8 <buf>
  18:	00001097          	auipc	ra,0x1
  1c:	a98080e7          	jalr	-1384(ra) # ab0 <statistics>
  20:	02a05b63          	blez	a0,56 <ntas+0x56>
    fprintf(2, "ntas: no stats\n");
  }
  c = strchr(buf, '=');
  24:	03d00593          	li	a1,61
  28:	00001517          	auipc	a0,0x1
  2c:	c8050513          	addi	a0,a0,-896 # ca8 <buf>
  30:	00000097          	auipc	ra,0x0
  34:	388080e7          	jalr	904(ra) # 3b8 <strchr>
  n = atoi(c+2);
  38:	0509                	addi	a0,a0,2
  3a:	00000097          	auipc	ra,0x0
  3e:	45c080e7          	jalr	1116(ra) # 496 <atoi>
  42:	84aa                	mv	s1,a0
  if(print)
  44:	02091363          	bnez	s2,6a <ntas+0x6a>
    printf("%s", buf);
  return n;
}
  48:	8526                	mv	a0,s1
  4a:	60e2                	ld	ra,24(sp)
  4c:	6442                	ld	s0,16(sp)
  4e:	64a2                	ld	s1,8(sp)
  50:	6902                	ld	s2,0(sp)
  52:	6105                	addi	sp,sp,32
  54:	8082                	ret
    fprintf(2, "ntas: no stats\n");
  56:	00001597          	auipc	a1,0x1
  5a:	ae258593          	addi	a1,a1,-1310 # b38 <statistics+0x88>
  5e:	4509                	li	a0,2
  60:	00001097          	auipc	ra,0x1
  64:	880080e7          	jalr	-1920(ra) # 8e0 <fprintf>
  68:	bf75                	j	24 <ntas+0x24>
    printf("%s", buf);
  6a:	00001597          	auipc	a1,0x1
  6e:	c3e58593          	addi	a1,a1,-962 # ca8 <buf>
  72:	00001517          	auipc	a0,0x1
  76:	ad650513          	addi	a0,a0,-1322 # b48 <statistics+0x98>
  7a:	00001097          	auipc	ra,0x1
  7e:	894080e7          	jalr	-1900(ra) # 90e <printf>
  82:	b7d9                	j	48 <ntas+0x48>

0000000000000084 <test1>:

void test1(void)
{
  84:	7179                	addi	sp,sp,-48
  86:	f406                	sd	ra,40(sp)
  88:	f022                	sd	s0,32(sp)
  8a:	ec26                	sd	s1,24(sp)
  8c:	e84a                	sd	s2,16(sp)
  8e:	e44e                	sd	s3,8(sp)
  90:	1800                	addi	s0,sp,48
  void *a, *a1;
  int n, m;
  printf("start test1\n");  
  92:	00001517          	auipc	a0,0x1
  96:	abe50513          	addi	a0,a0,-1346 # b50 <statistics+0xa0>
  9a:	00001097          	auipc	ra,0x1
  9e:	874080e7          	jalr	-1932(ra) # 90e <printf>
  m = ntas(0);
  a2:	4501                	li	a0,0
  a4:	00000097          	auipc	ra,0x0
  a8:	f5c080e7          	jalr	-164(ra) # 0 <ntas>
  ac:	84aa                	mv	s1,a0
  for(int i = 0; i < NCHILD; i++){
    int pid = fork();
  ae:	00000097          	auipc	ra,0x0
  b2:	4e0080e7          	jalr	1248(ra) # 58e <fork>
    if(pid < 0){
  b6:	06054463          	bltz	a0,11e <test1+0x9a>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
  ba:	cd3d                	beqz	a0,138 <test1+0xb4>
    int pid = fork();
  bc:	00000097          	auipc	ra,0x0
  c0:	4d2080e7          	jalr	1234(ra) # 58e <fork>
    if(pid < 0){
  c4:	04054d63          	bltz	a0,11e <test1+0x9a>
    if(pid == 0){
  c8:	c925                	beqz	a0,138 <test1+0xb4>
      exit(-1);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
  ca:	4501                	li	a0,0
  cc:	00000097          	auipc	ra,0x0
  d0:	4d2080e7          	jalr	1234(ra) # 59e <wait>
  d4:	4501                	li	a0,0
  d6:	00000097          	auipc	ra,0x0
  da:	4c8080e7          	jalr	1224(ra) # 59e <wait>
  }
  printf("test1 results:\n");
  de:	00001517          	auipc	a0,0x1
  e2:	aa250513          	addi	a0,a0,-1374 # b80 <statistics+0xd0>
  e6:	00001097          	auipc	ra,0x1
  ea:	828080e7          	jalr	-2008(ra) # 90e <printf>
  n = ntas(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	f10080e7          	jalr	-240(ra) # 0 <ntas>
  if(n-m < 10) 
  f8:	9d05                	subw	a0,a0,s1
  fa:	47a5                	li	a5,9
  fc:	08a7c863          	blt	a5,a0,18c <test1+0x108>
    printf("test1 OK\n");
 100:	00001517          	auipc	a0,0x1
 104:	a9050513          	addi	a0,a0,-1392 # b90 <statistics+0xe0>
 108:	00001097          	auipc	ra,0x1
 10c:	806080e7          	jalr	-2042(ra) # 90e <printf>
  else
    printf("test1 FAIL\n");
}
 110:	70a2                	ld	ra,40(sp)
 112:	7402                	ld	s0,32(sp)
 114:	64e2                	ld	s1,24(sp)
 116:	6942                	ld	s2,16(sp)
 118:	69a2                	ld	s3,8(sp)
 11a:	6145                	addi	sp,sp,48
 11c:	8082                	ret
      printf("fork failed");
 11e:	00001517          	auipc	a0,0x1
 122:	a4250513          	addi	a0,a0,-1470 # b60 <statistics+0xb0>
 126:	00000097          	auipc	ra,0x0
 12a:	7e8080e7          	jalr	2024(ra) # 90e <printf>
      exit(-1);
 12e:	557d                	li	a0,-1
 130:	00000097          	auipc	ra,0x0
 134:	466080e7          	jalr	1126(ra) # 596 <exit>
{
 138:	6961                	lui	s2,0x18
 13a:	6a090913          	addi	s2,s2,1696 # 186a0 <__BSS_END__+0x169e8>
        *(int *)(a+4) = 1;
 13e:	4985                	li	s3,1
        a = sbrk(4096);
 140:	6505                	lui	a0,0x1
 142:	00000097          	auipc	ra,0x0
 146:	4dc080e7          	jalr	1244(ra) # 61e <sbrk>
 14a:	84aa                	mv	s1,a0
        *(int *)(a+4) = 1;
 14c:	01352223          	sw	s3,4(a0) # 1004 <buf+0x35c>
        a1 = sbrk(-4096);
 150:	757d                	lui	a0,0xfffff
 152:	00000097          	auipc	ra,0x0
 156:	4cc080e7          	jalr	1228(ra) # 61e <sbrk>
        if (a1 != a + 4096) {
 15a:	6785                	lui	a5,0x1
 15c:	94be                	add	s1,s1,a5
 15e:	00951a63          	bne	a0,s1,172 <test1+0xee>
      for(i = 0; i < N; i++) {
 162:	397d                	addiw	s2,s2,-1
 164:	fc091ee3          	bnez	s2,140 <test1+0xbc>
      exit(-1);
 168:	557d                	li	a0,-1
 16a:	00000097          	auipc	ra,0x0
 16e:	42c080e7          	jalr	1068(ra) # 596 <exit>
          printf("wrong sbrk\n");
 172:	00001517          	auipc	a0,0x1
 176:	9fe50513          	addi	a0,a0,-1538 # b70 <statistics+0xc0>
 17a:	00000097          	auipc	ra,0x0
 17e:	794080e7          	jalr	1940(ra) # 90e <printf>
          exit(-1);
 182:	557d                	li	a0,-1
 184:	00000097          	auipc	ra,0x0
 188:	412080e7          	jalr	1042(ra) # 596 <exit>
    printf("test1 FAIL\n");
 18c:	00001517          	auipc	a0,0x1
 190:	a1450513          	addi	a0,a0,-1516 # ba0 <statistics+0xf0>
 194:	00000097          	auipc	ra,0x0
 198:	77a080e7          	jalr	1914(ra) # 90e <printf>
}
 19c:	bf95                	j	110 <test1+0x8c>

000000000000019e <countfree>:
//
// countfree() from usertests.c
//
int
countfree()
{
 19e:	7179                	addi	sp,sp,-48
 1a0:	f406                	sd	ra,40(sp)
 1a2:	f022                	sd	s0,32(sp)
 1a4:	ec26                	sd	s1,24(sp)
 1a6:	e84a                	sd	s2,16(sp)
 1a8:	e44e                	sd	s3,8(sp)
 1aa:	e052                	sd	s4,0(sp)
 1ac:	1800                	addi	s0,sp,48
  uint64 sz0 = (uint64)sbrk(0);
 1ae:	4501                	li	a0,0
 1b0:	00000097          	auipc	ra,0x0
 1b4:	46e080e7          	jalr	1134(ra) # 61e <sbrk>
 1b8:	8a2a                	mv	s4,a0
  int n = 0;
 1ba:	4481                	li	s1,0

  while(1){
    uint64 a = (uint64) sbrk(4096);
    if(a == 0xffffffffffffffff){
 1bc:	597d                	li	s2,-1
      break;
    }
    // modify the memory to make sure it's really allocated.
    *(char *)(a + 4096 - 1) = 1;
 1be:	4985                	li	s3,1
    uint64 a = (uint64) sbrk(4096);
 1c0:	6505                	lui	a0,0x1
 1c2:	00000097          	auipc	ra,0x0
 1c6:	45c080e7          	jalr	1116(ra) # 61e <sbrk>
    if(a == 0xffffffffffffffff){
 1ca:	01250863          	beq	a0,s2,1da <countfree+0x3c>
    *(char *)(a + 4096 - 1) = 1;
 1ce:	6785                	lui	a5,0x1
 1d0:	953e                	add	a0,a0,a5
 1d2:	ff350fa3          	sb	s3,-1(a0) # fff <buf+0x357>
    n += 1;
 1d6:	2485                	addiw	s1,s1,1
  while(1){
 1d8:	b7e5                	j	1c0 <countfree+0x22>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
 1da:	4501                	li	a0,0
 1dc:	00000097          	auipc	ra,0x0
 1e0:	442080e7          	jalr	1090(ra) # 61e <sbrk>
 1e4:	40aa053b          	subw	a0,s4,a0
 1e8:	00000097          	auipc	ra,0x0
 1ec:	436080e7          	jalr	1078(ra) # 61e <sbrk>
  return n;
}
 1f0:	8526                	mv	a0,s1
 1f2:	70a2                	ld	ra,40(sp)
 1f4:	7402                	ld	s0,32(sp)
 1f6:	64e2                	ld	s1,24(sp)
 1f8:	6942                	ld	s2,16(sp)
 1fa:	69a2                	ld	s3,8(sp)
 1fc:	6a02                	ld	s4,0(sp)
 1fe:	6145                	addi	sp,sp,48
 200:	8082                	ret

0000000000000202 <test2>:

void test2() {
 202:	715d                	addi	sp,sp,-80
 204:	e486                	sd	ra,72(sp)
 206:	e0a2                	sd	s0,64(sp)
 208:	fc26                	sd	s1,56(sp)
 20a:	f84a                	sd	s2,48(sp)
 20c:	f44e                	sd	s3,40(sp)
 20e:	f052                	sd	s4,32(sp)
 210:	ec56                	sd	s5,24(sp)
 212:	e85a                	sd	s6,16(sp)
 214:	e45e                	sd	s7,8(sp)
 216:	e062                	sd	s8,0(sp)
 218:	0880                	addi	s0,sp,80
  int free0 = countfree();
 21a:	00000097          	auipc	ra,0x0
 21e:	f84080e7          	jalr	-124(ra) # 19e <countfree>
 222:	8a2a                	mv	s4,a0
  int free1;
  int n = (PHYSTOP-KERNBASE)/PGSIZE;
  printf("start test2\n");  
 224:	00001517          	auipc	a0,0x1
 228:	98c50513          	addi	a0,a0,-1652 # bb0 <statistics+0x100>
 22c:	00000097          	auipc	ra,0x0
 230:	6e2080e7          	jalr	1762(ra) # 90e <printf>
  printf("total free number of pages: %d (out of %d)\n", free0, n);
 234:	6621                	lui	a2,0x8
 236:	85d2                	mv	a1,s4
 238:	00001517          	auipc	a0,0x1
 23c:	98850513          	addi	a0,a0,-1656 # bc0 <statistics+0x110>
 240:	00000097          	auipc	ra,0x0
 244:	6ce080e7          	jalr	1742(ra) # 90e <printf>
  if(n - free0 > 1000) {
 248:	67a1                	lui	a5,0x8
 24a:	414787bb          	subw	a5,a5,s4
 24e:	3e800713          	li	a4,1000
 252:	02f74163          	blt	a4,a5,274 <test2+0x72>
    printf("test2 FAILED: cannot allocate enough memory");
    exit(-1);
  }
  for (int i = 0; i < 50; i++) {
    free1 = countfree();
 256:	00000097          	auipc	ra,0x0
 25a:	f48080e7          	jalr	-184(ra) # 19e <countfree>
 25e:	892a                	mv	s2,a0
  for (int i = 0; i < 50; i++) {
 260:	4981                	li	s3,0
 262:	03200a93          	li	s5,50
    if(i % 10 == 9)
 266:	4ba9                	li	s7,10
 268:	4b25                	li	s6,9
      printf(".");
 26a:	00001c17          	auipc	s8,0x1
 26e:	9b6c0c13          	addi	s8,s8,-1610 # c20 <statistics+0x170>
 272:	a01d                	j	298 <test2+0x96>
    printf("test2 FAILED: cannot allocate enough memory");
 274:	00001517          	auipc	a0,0x1
 278:	97c50513          	addi	a0,a0,-1668 # bf0 <statistics+0x140>
 27c:	00000097          	auipc	ra,0x0
 280:	692080e7          	jalr	1682(ra) # 90e <printf>
    exit(-1);
 284:	557d                	li	a0,-1
 286:	00000097          	auipc	ra,0x0
 28a:	310080e7          	jalr	784(ra) # 596 <exit>
      printf(".");
 28e:	8562                	mv	a0,s8
 290:	00000097          	auipc	ra,0x0
 294:	67e080e7          	jalr	1662(ra) # 90e <printf>
    if(free1 != free0) {
 298:	032a1263          	bne	s4,s2,2bc <test2+0xba>
  for (int i = 0; i < 50; i++) {
 29c:	0019849b          	addiw	s1,s3,1
 2a0:	0004899b          	sext.w	s3,s1
 2a4:	03598963          	beq	s3,s5,2d6 <test2+0xd4>
    free1 = countfree();
 2a8:	00000097          	auipc	ra,0x0
 2ac:	ef6080e7          	jalr	-266(ra) # 19e <countfree>
 2b0:	892a                	mv	s2,a0
    if(i % 10 == 9)
 2b2:	0374e4bb          	remw	s1,s1,s7
 2b6:	ff6491e3          	bne	s1,s6,298 <test2+0x96>
 2ba:	bfd1                	j	28e <test2+0x8c>
      printf("test2 FAIL: losing pages\n");
 2bc:	00001517          	auipc	a0,0x1
 2c0:	96c50513          	addi	a0,a0,-1684 # c28 <statistics+0x178>
 2c4:	00000097          	auipc	ra,0x0
 2c8:	64a080e7          	jalr	1610(ra) # 90e <printf>
      exit(-1);
 2cc:	557d                	li	a0,-1
 2ce:	00000097          	auipc	ra,0x0
 2d2:	2c8080e7          	jalr	712(ra) # 596 <exit>
    }
  }
  printf("\ntest2 OK\n");  
 2d6:	00001517          	auipc	a0,0x1
 2da:	97250513          	addi	a0,a0,-1678 # c48 <statistics+0x198>
 2de:	00000097          	auipc	ra,0x0
 2e2:	630080e7          	jalr	1584(ra) # 90e <printf>
}
 2e6:	60a6                	ld	ra,72(sp)
 2e8:	6406                	ld	s0,64(sp)
 2ea:	74e2                	ld	s1,56(sp)
 2ec:	7942                	ld	s2,48(sp)
 2ee:	79a2                	ld	s3,40(sp)
 2f0:	7a02                	ld	s4,32(sp)
 2f2:	6ae2                	ld	s5,24(sp)
 2f4:	6b42                	ld	s6,16(sp)
 2f6:	6ba2                	ld	s7,8(sp)
 2f8:	6c02                	ld	s8,0(sp)
 2fa:	6161                	addi	sp,sp,80
 2fc:	8082                	ret

00000000000002fe <main>:
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  test1();
 306:	00000097          	auipc	ra,0x0
 30a:	d7e080e7          	jalr	-642(ra) # 84 <test1>
  test2();
 30e:	00000097          	auipc	ra,0x0
 312:	ef4080e7          	jalr	-268(ra) # 202 <test2>
  exit(0);
 316:	4501                	li	a0,0
 318:	00000097          	auipc	ra,0x0
 31c:	27e080e7          	jalr	638(ra) # 596 <exit>

0000000000000320 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 326:	87aa                	mv	a5,a0
 328:	0585                	addi	a1,a1,1
 32a:	0785                	addi	a5,a5,1
 32c:	fff5c703          	lbu	a4,-1(a1)
 330:	fee78fa3          	sb	a4,-1(a5) # 7fff <__BSS_END__+0x6347>
 334:	fb75                	bnez	a4,328 <strcpy+0x8>
    ;
  return os;
}
 336:	6422                	ld	s0,8(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret

000000000000033c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 33c:	1141                	addi	sp,sp,-16
 33e:	e422                	sd	s0,8(sp)
 340:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 342:	00054783          	lbu	a5,0(a0)
 346:	cb91                	beqz	a5,35a <strcmp+0x1e>
 348:	0005c703          	lbu	a4,0(a1)
 34c:	00f71763          	bne	a4,a5,35a <strcmp+0x1e>
    p++, q++;
 350:	0505                	addi	a0,a0,1
 352:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 354:	00054783          	lbu	a5,0(a0)
 358:	fbe5                	bnez	a5,348 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 35a:	0005c503          	lbu	a0,0(a1)
}
 35e:	40a7853b          	subw	a0,a5,a0
 362:	6422                	ld	s0,8(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret

0000000000000368 <strlen>:

uint
strlen(const char *s)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 36e:	00054783          	lbu	a5,0(a0)
 372:	cf91                	beqz	a5,38e <strlen+0x26>
 374:	0505                	addi	a0,a0,1
 376:	87aa                	mv	a5,a0
 378:	4685                	li	a3,1
 37a:	9e89                	subw	a3,a3,a0
 37c:	00f6853b          	addw	a0,a3,a5
 380:	0785                	addi	a5,a5,1
 382:	fff7c703          	lbu	a4,-1(a5)
 386:	fb7d                	bnez	a4,37c <strlen+0x14>
    ;
  return n;
}
 388:	6422                	ld	s0,8(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret
  for(n = 0; s[n]; n++)
 38e:	4501                	li	a0,0
 390:	bfe5                	j	388 <strlen+0x20>

0000000000000392 <memset>:

void*
memset(void *dst, int c, uint n)
{
 392:	1141                	addi	sp,sp,-16
 394:	e422                	sd	s0,8(sp)
 396:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 398:	ce09                	beqz	a2,3b2 <memset+0x20>
 39a:	87aa                	mv	a5,a0
 39c:	fff6071b          	addiw	a4,a2,-1
 3a0:	1702                	slli	a4,a4,0x20
 3a2:	9301                	srli	a4,a4,0x20
 3a4:	0705                	addi	a4,a4,1
 3a6:	972a                	add	a4,a4,a0
    cdst[i] = c;
 3a8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3ac:	0785                	addi	a5,a5,1
 3ae:	fee79de3          	bne	a5,a4,3a8 <memset+0x16>
  }
  return dst;
}
 3b2:	6422                	ld	s0,8(sp)
 3b4:	0141                	addi	sp,sp,16
 3b6:	8082                	ret

00000000000003b8 <strchr>:

char*
strchr(const char *s, char c)
{
 3b8:	1141                	addi	sp,sp,-16
 3ba:	e422                	sd	s0,8(sp)
 3bc:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3be:	00054783          	lbu	a5,0(a0)
 3c2:	cb99                	beqz	a5,3d8 <strchr+0x20>
    if(*s == c)
 3c4:	00f58763          	beq	a1,a5,3d2 <strchr+0x1a>
  for(; *s; s++)
 3c8:	0505                	addi	a0,a0,1
 3ca:	00054783          	lbu	a5,0(a0)
 3ce:	fbfd                	bnez	a5,3c4 <strchr+0xc>
      return (char*)s;
  return 0;
 3d0:	4501                	li	a0,0
}
 3d2:	6422                	ld	s0,8(sp)
 3d4:	0141                	addi	sp,sp,16
 3d6:	8082                	ret
  return 0;
 3d8:	4501                	li	a0,0
 3da:	bfe5                	j	3d2 <strchr+0x1a>

00000000000003dc <gets>:

char*
gets(char *buf, int max)
{
 3dc:	711d                	addi	sp,sp,-96
 3de:	ec86                	sd	ra,88(sp)
 3e0:	e8a2                	sd	s0,80(sp)
 3e2:	e4a6                	sd	s1,72(sp)
 3e4:	e0ca                	sd	s2,64(sp)
 3e6:	fc4e                	sd	s3,56(sp)
 3e8:	f852                	sd	s4,48(sp)
 3ea:	f456                	sd	s5,40(sp)
 3ec:	f05a                	sd	s6,32(sp)
 3ee:	ec5e                	sd	s7,24(sp)
 3f0:	1080                	addi	s0,sp,96
 3f2:	8baa                	mv	s7,a0
 3f4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f6:	892a                	mv	s2,a0
 3f8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3fa:	4aa9                	li	s5,10
 3fc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3fe:	89a6                	mv	s3,s1
 400:	2485                	addiw	s1,s1,1
 402:	0344d863          	bge	s1,s4,432 <gets+0x56>
    cc = read(0, &c, 1);
 406:	4605                	li	a2,1
 408:	faf40593          	addi	a1,s0,-81
 40c:	4501                	li	a0,0
 40e:	00000097          	auipc	ra,0x0
 412:	1a0080e7          	jalr	416(ra) # 5ae <read>
    if(cc < 1)
 416:	00a05e63          	blez	a0,432 <gets+0x56>
    buf[i++] = c;
 41a:	faf44783          	lbu	a5,-81(s0)
 41e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 422:	01578763          	beq	a5,s5,430 <gets+0x54>
 426:	0905                	addi	s2,s2,1
 428:	fd679be3          	bne	a5,s6,3fe <gets+0x22>
  for(i=0; i+1 < max; ){
 42c:	89a6                	mv	s3,s1
 42e:	a011                	j	432 <gets+0x56>
 430:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 432:	99de                	add	s3,s3,s7
 434:	00098023          	sb	zero,0(s3)
  return buf;
}
 438:	855e                	mv	a0,s7
 43a:	60e6                	ld	ra,88(sp)
 43c:	6446                	ld	s0,80(sp)
 43e:	64a6                	ld	s1,72(sp)
 440:	6906                	ld	s2,64(sp)
 442:	79e2                	ld	s3,56(sp)
 444:	7a42                	ld	s4,48(sp)
 446:	7aa2                	ld	s5,40(sp)
 448:	7b02                	ld	s6,32(sp)
 44a:	6be2                	ld	s7,24(sp)
 44c:	6125                	addi	sp,sp,96
 44e:	8082                	ret

0000000000000450 <stat>:

int
stat(const char *n, struct stat *st)
{
 450:	1101                	addi	sp,sp,-32
 452:	ec06                	sd	ra,24(sp)
 454:	e822                	sd	s0,16(sp)
 456:	e426                	sd	s1,8(sp)
 458:	e04a                	sd	s2,0(sp)
 45a:	1000                	addi	s0,sp,32
 45c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 45e:	4581                	li	a1,0
 460:	00000097          	auipc	ra,0x0
 464:	176080e7          	jalr	374(ra) # 5d6 <open>
  if(fd < 0)
 468:	02054563          	bltz	a0,492 <stat+0x42>
 46c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 46e:	85ca                	mv	a1,s2
 470:	00000097          	auipc	ra,0x0
 474:	17e080e7          	jalr	382(ra) # 5ee <fstat>
 478:	892a                	mv	s2,a0
  close(fd);
 47a:	8526                	mv	a0,s1
 47c:	00000097          	auipc	ra,0x0
 480:	142080e7          	jalr	322(ra) # 5be <close>
  return r;
}
 484:	854a                	mv	a0,s2
 486:	60e2                	ld	ra,24(sp)
 488:	6442                	ld	s0,16(sp)
 48a:	64a2                	ld	s1,8(sp)
 48c:	6902                	ld	s2,0(sp)
 48e:	6105                	addi	sp,sp,32
 490:	8082                	ret
    return -1;
 492:	597d                	li	s2,-1
 494:	bfc5                	j	484 <stat+0x34>

0000000000000496 <atoi>:

int
atoi(const char *s)
{
 496:	1141                	addi	sp,sp,-16
 498:	e422                	sd	s0,8(sp)
 49a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 49c:	00054603          	lbu	a2,0(a0)
 4a0:	fd06079b          	addiw	a5,a2,-48
 4a4:	0ff7f793          	andi	a5,a5,255
 4a8:	4725                	li	a4,9
 4aa:	02f76963          	bltu	a4,a5,4dc <atoi+0x46>
 4ae:	86aa                	mv	a3,a0
  n = 0;
 4b0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 4b2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 4b4:	0685                	addi	a3,a3,1
 4b6:	0025179b          	slliw	a5,a0,0x2
 4ba:	9fa9                	addw	a5,a5,a0
 4bc:	0017979b          	slliw	a5,a5,0x1
 4c0:	9fb1                	addw	a5,a5,a2
 4c2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4c6:	0006c603          	lbu	a2,0(a3)
 4ca:	fd06071b          	addiw	a4,a2,-48
 4ce:	0ff77713          	andi	a4,a4,255
 4d2:	fee5f1e3          	bgeu	a1,a4,4b4 <atoi+0x1e>
  return n;
}
 4d6:	6422                	ld	s0,8(sp)
 4d8:	0141                	addi	sp,sp,16
 4da:	8082                	ret
  n = 0;
 4dc:	4501                	li	a0,0
 4de:	bfe5                	j	4d6 <atoi+0x40>

00000000000004e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4e0:	1141                	addi	sp,sp,-16
 4e2:	e422                	sd	s0,8(sp)
 4e4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4e6:	02b57663          	bgeu	a0,a1,512 <memmove+0x32>
    while(n-- > 0)
 4ea:	02c05163          	blez	a2,50c <memmove+0x2c>
 4ee:	fff6079b          	addiw	a5,a2,-1
 4f2:	1782                	slli	a5,a5,0x20
 4f4:	9381                	srli	a5,a5,0x20
 4f6:	0785                	addi	a5,a5,1
 4f8:	97aa                	add	a5,a5,a0
  dst = vdst;
 4fa:	872a                	mv	a4,a0
      *dst++ = *src++;
 4fc:	0585                	addi	a1,a1,1
 4fe:	0705                	addi	a4,a4,1
 500:	fff5c683          	lbu	a3,-1(a1)
 504:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 508:	fee79ae3          	bne	a5,a4,4fc <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 50c:	6422                	ld	s0,8(sp)
 50e:	0141                	addi	sp,sp,16
 510:	8082                	ret
    dst += n;
 512:	00c50733          	add	a4,a0,a2
    src += n;
 516:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 518:	fec05ae3          	blez	a2,50c <memmove+0x2c>
 51c:	fff6079b          	addiw	a5,a2,-1
 520:	1782                	slli	a5,a5,0x20
 522:	9381                	srli	a5,a5,0x20
 524:	fff7c793          	not	a5,a5
 528:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 52a:	15fd                	addi	a1,a1,-1
 52c:	177d                	addi	a4,a4,-1
 52e:	0005c683          	lbu	a3,0(a1)
 532:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 536:	fee79ae3          	bne	a5,a4,52a <memmove+0x4a>
 53a:	bfc9                	j	50c <memmove+0x2c>

000000000000053c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 53c:	1141                	addi	sp,sp,-16
 53e:	e422                	sd	s0,8(sp)
 540:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 542:	ca05                	beqz	a2,572 <memcmp+0x36>
 544:	fff6069b          	addiw	a3,a2,-1
 548:	1682                	slli	a3,a3,0x20
 54a:	9281                	srli	a3,a3,0x20
 54c:	0685                	addi	a3,a3,1
 54e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 550:	00054783          	lbu	a5,0(a0)
 554:	0005c703          	lbu	a4,0(a1)
 558:	00e79863          	bne	a5,a4,568 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 55c:	0505                	addi	a0,a0,1
    p2++;
 55e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 560:	fed518e3          	bne	a0,a3,550 <memcmp+0x14>
  }
  return 0;
 564:	4501                	li	a0,0
 566:	a019                	j	56c <memcmp+0x30>
      return *p1 - *p2;
 568:	40e7853b          	subw	a0,a5,a4
}
 56c:	6422                	ld	s0,8(sp)
 56e:	0141                	addi	sp,sp,16
 570:	8082                	ret
  return 0;
 572:	4501                	li	a0,0
 574:	bfe5                	j	56c <memcmp+0x30>

0000000000000576 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 576:	1141                	addi	sp,sp,-16
 578:	e406                	sd	ra,8(sp)
 57a:	e022                	sd	s0,0(sp)
 57c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 57e:	00000097          	auipc	ra,0x0
 582:	f62080e7          	jalr	-158(ra) # 4e0 <memmove>
}
 586:	60a2                	ld	ra,8(sp)
 588:	6402                	ld	s0,0(sp)
 58a:	0141                	addi	sp,sp,16
 58c:	8082                	ret

000000000000058e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 58e:	4885                	li	a7,1
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <exit>:
.global exit
exit:
 li a7, SYS_exit
 596:	4889                	li	a7,2
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <wait>:
.global wait
wait:
 li a7, SYS_wait
 59e:	488d                	li	a7,3
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5a6:	4891                	li	a7,4
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <read>:
.global read
read:
 li a7, SYS_read
 5ae:	4895                	li	a7,5
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <write>:
.global write
write:
 li a7, SYS_write
 5b6:	48c1                	li	a7,16
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <close>:
.global close
close:
 li a7, SYS_close
 5be:	48d5                	li	a7,21
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5c6:	4899                	li	a7,6
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <exec>:
.global exec
exec:
 li a7, SYS_exec
 5ce:	489d                	li	a7,7
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <open>:
.global open
open:
 li a7, SYS_open
 5d6:	48bd                	li	a7,15
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5de:	48c5                	li	a7,17
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5e6:	48c9                	li	a7,18
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5ee:	48a1                	li	a7,8
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <link>:
.global link
link:
 li a7, SYS_link
 5f6:	48cd                	li	a7,19
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5fe:	48d1                	li	a7,20
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 606:	48a5                	li	a7,9
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <dup>:
.global dup
dup:
 li a7, SYS_dup
 60e:	48a9                	li	a7,10
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 616:	48ad                	li	a7,11
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 61e:	48b1                	li	a7,12
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 626:	48b5                	li	a7,13
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 62e:	48b9                	li	a7,14
 ecall
 630:	00000073          	ecall
 ret
 634:	8082                	ret

0000000000000636 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 636:	1101                	addi	sp,sp,-32
 638:	ec06                	sd	ra,24(sp)
 63a:	e822                	sd	s0,16(sp)
 63c:	1000                	addi	s0,sp,32
 63e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 642:	4605                	li	a2,1
 644:	fef40593          	addi	a1,s0,-17
 648:	00000097          	auipc	ra,0x0
 64c:	f6e080e7          	jalr	-146(ra) # 5b6 <write>
}
 650:	60e2                	ld	ra,24(sp)
 652:	6442                	ld	s0,16(sp)
 654:	6105                	addi	sp,sp,32
 656:	8082                	ret

0000000000000658 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 658:	7139                	addi	sp,sp,-64
 65a:	fc06                	sd	ra,56(sp)
 65c:	f822                	sd	s0,48(sp)
 65e:	f426                	sd	s1,40(sp)
 660:	f04a                	sd	s2,32(sp)
 662:	ec4e                	sd	s3,24(sp)
 664:	0080                	addi	s0,sp,64
 666:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 668:	c299                	beqz	a3,66e <printint+0x16>
 66a:	0805c863          	bltz	a1,6fa <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 66e:	2581                	sext.w	a1,a1
  neg = 0;
 670:	4881                	li	a7,0
 672:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 676:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 678:	2601                	sext.w	a2,a2
 67a:	00000517          	auipc	a0,0x0
 67e:	5e650513          	addi	a0,a0,1510 # c60 <digits>
 682:	883a                	mv	a6,a4
 684:	2705                	addiw	a4,a4,1
 686:	02c5f7bb          	remuw	a5,a1,a2
 68a:	1782                	slli	a5,a5,0x20
 68c:	9381                	srli	a5,a5,0x20
 68e:	97aa                	add	a5,a5,a0
 690:	0007c783          	lbu	a5,0(a5)
 694:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 698:	0005879b          	sext.w	a5,a1
 69c:	02c5d5bb          	divuw	a1,a1,a2
 6a0:	0685                	addi	a3,a3,1
 6a2:	fec7f0e3          	bgeu	a5,a2,682 <printint+0x2a>
  if(neg)
 6a6:	00088b63          	beqz	a7,6bc <printint+0x64>
    buf[i++] = '-';
 6aa:	fd040793          	addi	a5,s0,-48
 6ae:	973e                	add	a4,a4,a5
 6b0:	02d00793          	li	a5,45
 6b4:	fef70823          	sb	a5,-16(a4)
 6b8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6bc:	02e05863          	blez	a4,6ec <printint+0x94>
 6c0:	fc040793          	addi	a5,s0,-64
 6c4:	00e78933          	add	s2,a5,a4
 6c8:	fff78993          	addi	s3,a5,-1
 6cc:	99ba                	add	s3,s3,a4
 6ce:	377d                	addiw	a4,a4,-1
 6d0:	1702                	slli	a4,a4,0x20
 6d2:	9301                	srli	a4,a4,0x20
 6d4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6d8:	fff94583          	lbu	a1,-1(s2)
 6dc:	8526                	mv	a0,s1
 6de:	00000097          	auipc	ra,0x0
 6e2:	f58080e7          	jalr	-168(ra) # 636 <putc>
  while(--i >= 0)
 6e6:	197d                	addi	s2,s2,-1
 6e8:	ff3918e3          	bne	s2,s3,6d8 <printint+0x80>
}
 6ec:	70e2                	ld	ra,56(sp)
 6ee:	7442                	ld	s0,48(sp)
 6f0:	74a2                	ld	s1,40(sp)
 6f2:	7902                	ld	s2,32(sp)
 6f4:	69e2                	ld	s3,24(sp)
 6f6:	6121                	addi	sp,sp,64
 6f8:	8082                	ret
    x = -xx;
 6fa:	40b005bb          	negw	a1,a1
    neg = 1;
 6fe:	4885                	li	a7,1
    x = -xx;
 700:	bf8d                	j	672 <printint+0x1a>

0000000000000702 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 702:	7119                	addi	sp,sp,-128
 704:	fc86                	sd	ra,120(sp)
 706:	f8a2                	sd	s0,112(sp)
 708:	f4a6                	sd	s1,104(sp)
 70a:	f0ca                	sd	s2,96(sp)
 70c:	ecce                	sd	s3,88(sp)
 70e:	e8d2                	sd	s4,80(sp)
 710:	e4d6                	sd	s5,72(sp)
 712:	e0da                	sd	s6,64(sp)
 714:	fc5e                	sd	s7,56(sp)
 716:	f862                	sd	s8,48(sp)
 718:	f466                	sd	s9,40(sp)
 71a:	f06a                	sd	s10,32(sp)
 71c:	ec6e                	sd	s11,24(sp)
 71e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 720:	0005c903          	lbu	s2,0(a1)
 724:	18090f63          	beqz	s2,8c2 <vprintf+0x1c0>
 728:	8aaa                	mv	s5,a0
 72a:	8b32                	mv	s6,a2
 72c:	00158493          	addi	s1,a1,1
  state = 0;
 730:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 732:	02500a13          	li	s4,37
      if(c == 'd'){
 736:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 73a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 73e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 742:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 746:	00000b97          	auipc	s7,0x0
 74a:	51ab8b93          	addi	s7,s7,1306 # c60 <digits>
 74e:	a839                	j	76c <vprintf+0x6a>
        putc(fd, c);
 750:	85ca                	mv	a1,s2
 752:	8556                	mv	a0,s5
 754:	00000097          	auipc	ra,0x0
 758:	ee2080e7          	jalr	-286(ra) # 636 <putc>
 75c:	a019                	j	762 <vprintf+0x60>
    } else if(state == '%'){
 75e:	01498f63          	beq	s3,s4,77c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 762:	0485                	addi	s1,s1,1
 764:	fff4c903          	lbu	s2,-1(s1)
 768:	14090d63          	beqz	s2,8c2 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 76c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 770:	fe0997e3          	bnez	s3,75e <vprintf+0x5c>
      if(c == '%'){
 774:	fd479ee3          	bne	a5,s4,750 <vprintf+0x4e>
        state = '%';
 778:	89be                	mv	s3,a5
 77a:	b7e5                	j	762 <vprintf+0x60>
      if(c == 'd'){
 77c:	05878063          	beq	a5,s8,7bc <vprintf+0xba>
      } else if(c == 'l') {
 780:	05978c63          	beq	a5,s9,7d8 <vprintf+0xd6>
      } else if(c == 'x') {
 784:	07a78863          	beq	a5,s10,7f4 <vprintf+0xf2>
      } else if(c == 'p') {
 788:	09b78463          	beq	a5,s11,810 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 78c:	07300713          	li	a4,115
 790:	0ce78663          	beq	a5,a4,85c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 794:	06300713          	li	a4,99
 798:	0ee78e63          	beq	a5,a4,894 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 79c:	11478863          	beq	a5,s4,8ac <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7a0:	85d2                	mv	a1,s4
 7a2:	8556                	mv	a0,s5
 7a4:	00000097          	auipc	ra,0x0
 7a8:	e92080e7          	jalr	-366(ra) # 636 <putc>
        putc(fd, c);
 7ac:	85ca                	mv	a1,s2
 7ae:	8556                	mv	a0,s5
 7b0:	00000097          	auipc	ra,0x0
 7b4:	e86080e7          	jalr	-378(ra) # 636 <putc>
      }
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	b765                	j	762 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7bc:	008b0913          	addi	s2,s6,8
 7c0:	4685                	li	a3,1
 7c2:	4629                	li	a2,10
 7c4:	000b2583          	lw	a1,0(s6)
 7c8:	8556                	mv	a0,s5
 7ca:	00000097          	auipc	ra,0x0
 7ce:	e8e080e7          	jalr	-370(ra) # 658 <printint>
 7d2:	8b4a                	mv	s6,s2
      state = 0;
 7d4:	4981                	li	s3,0
 7d6:	b771                	j	762 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d8:	008b0913          	addi	s2,s6,8
 7dc:	4681                	li	a3,0
 7de:	4629                	li	a2,10
 7e0:	000b2583          	lw	a1,0(s6)
 7e4:	8556                	mv	a0,s5
 7e6:	00000097          	auipc	ra,0x0
 7ea:	e72080e7          	jalr	-398(ra) # 658 <printint>
 7ee:	8b4a                	mv	s6,s2
      state = 0;
 7f0:	4981                	li	s3,0
 7f2:	bf85                	j	762 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7f4:	008b0913          	addi	s2,s6,8
 7f8:	4681                	li	a3,0
 7fa:	4641                	li	a2,16
 7fc:	000b2583          	lw	a1,0(s6)
 800:	8556                	mv	a0,s5
 802:	00000097          	auipc	ra,0x0
 806:	e56080e7          	jalr	-426(ra) # 658 <printint>
 80a:	8b4a                	mv	s6,s2
      state = 0;
 80c:	4981                	li	s3,0
 80e:	bf91                	j	762 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 810:	008b0793          	addi	a5,s6,8
 814:	f8f43423          	sd	a5,-120(s0)
 818:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 81c:	03000593          	li	a1,48
 820:	8556                	mv	a0,s5
 822:	00000097          	auipc	ra,0x0
 826:	e14080e7          	jalr	-492(ra) # 636 <putc>
  putc(fd, 'x');
 82a:	85ea                	mv	a1,s10
 82c:	8556                	mv	a0,s5
 82e:	00000097          	auipc	ra,0x0
 832:	e08080e7          	jalr	-504(ra) # 636 <putc>
 836:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 838:	03c9d793          	srli	a5,s3,0x3c
 83c:	97de                	add	a5,a5,s7
 83e:	0007c583          	lbu	a1,0(a5)
 842:	8556                	mv	a0,s5
 844:	00000097          	auipc	ra,0x0
 848:	df2080e7          	jalr	-526(ra) # 636 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 84c:	0992                	slli	s3,s3,0x4
 84e:	397d                	addiw	s2,s2,-1
 850:	fe0914e3          	bnez	s2,838 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 854:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 858:	4981                	li	s3,0
 85a:	b721                	j	762 <vprintf+0x60>
        s = va_arg(ap, char*);
 85c:	008b0993          	addi	s3,s6,8
 860:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 864:	02090163          	beqz	s2,886 <vprintf+0x184>
        while(*s != 0){
 868:	00094583          	lbu	a1,0(s2)
 86c:	c9a1                	beqz	a1,8bc <vprintf+0x1ba>
          putc(fd, *s);
 86e:	8556                	mv	a0,s5
 870:	00000097          	auipc	ra,0x0
 874:	dc6080e7          	jalr	-570(ra) # 636 <putc>
          s++;
 878:	0905                	addi	s2,s2,1
        while(*s != 0){
 87a:	00094583          	lbu	a1,0(s2)
 87e:	f9e5                	bnez	a1,86e <vprintf+0x16c>
        s = va_arg(ap, char*);
 880:	8b4e                	mv	s6,s3
      state = 0;
 882:	4981                	li	s3,0
 884:	bdf9                	j	762 <vprintf+0x60>
          s = "(null)";
 886:	00000917          	auipc	s2,0x0
 88a:	3d290913          	addi	s2,s2,978 # c58 <statistics+0x1a8>
        while(*s != 0){
 88e:	02800593          	li	a1,40
 892:	bff1                	j	86e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 894:	008b0913          	addi	s2,s6,8
 898:	000b4583          	lbu	a1,0(s6)
 89c:	8556                	mv	a0,s5
 89e:	00000097          	auipc	ra,0x0
 8a2:	d98080e7          	jalr	-616(ra) # 636 <putc>
 8a6:	8b4a                	mv	s6,s2
      state = 0;
 8a8:	4981                	li	s3,0
 8aa:	bd65                	j	762 <vprintf+0x60>
        putc(fd, c);
 8ac:	85d2                	mv	a1,s4
 8ae:	8556                	mv	a0,s5
 8b0:	00000097          	auipc	ra,0x0
 8b4:	d86080e7          	jalr	-634(ra) # 636 <putc>
      state = 0;
 8b8:	4981                	li	s3,0
 8ba:	b565                	j	762 <vprintf+0x60>
        s = va_arg(ap, char*);
 8bc:	8b4e                	mv	s6,s3
      state = 0;
 8be:	4981                	li	s3,0
 8c0:	b54d                	j	762 <vprintf+0x60>
    }
  }
}
 8c2:	70e6                	ld	ra,120(sp)
 8c4:	7446                	ld	s0,112(sp)
 8c6:	74a6                	ld	s1,104(sp)
 8c8:	7906                	ld	s2,96(sp)
 8ca:	69e6                	ld	s3,88(sp)
 8cc:	6a46                	ld	s4,80(sp)
 8ce:	6aa6                	ld	s5,72(sp)
 8d0:	6b06                	ld	s6,64(sp)
 8d2:	7be2                	ld	s7,56(sp)
 8d4:	7c42                	ld	s8,48(sp)
 8d6:	7ca2                	ld	s9,40(sp)
 8d8:	7d02                	ld	s10,32(sp)
 8da:	6de2                	ld	s11,24(sp)
 8dc:	6109                	addi	sp,sp,128
 8de:	8082                	ret

00000000000008e0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8e0:	715d                	addi	sp,sp,-80
 8e2:	ec06                	sd	ra,24(sp)
 8e4:	e822                	sd	s0,16(sp)
 8e6:	1000                	addi	s0,sp,32
 8e8:	e010                	sd	a2,0(s0)
 8ea:	e414                	sd	a3,8(s0)
 8ec:	e818                	sd	a4,16(s0)
 8ee:	ec1c                	sd	a5,24(s0)
 8f0:	03043023          	sd	a6,32(s0)
 8f4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8f8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8fc:	8622                	mv	a2,s0
 8fe:	00000097          	auipc	ra,0x0
 902:	e04080e7          	jalr	-508(ra) # 702 <vprintf>
}
 906:	60e2                	ld	ra,24(sp)
 908:	6442                	ld	s0,16(sp)
 90a:	6161                	addi	sp,sp,80
 90c:	8082                	ret

000000000000090e <printf>:

void
printf(const char *fmt, ...)
{
 90e:	711d                	addi	sp,sp,-96
 910:	ec06                	sd	ra,24(sp)
 912:	e822                	sd	s0,16(sp)
 914:	1000                	addi	s0,sp,32
 916:	e40c                	sd	a1,8(s0)
 918:	e810                	sd	a2,16(s0)
 91a:	ec14                	sd	a3,24(s0)
 91c:	f018                	sd	a4,32(s0)
 91e:	f41c                	sd	a5,40(s0)
 920:	03043823          	sd	a6,48(s0)
 924:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 928:	00840613          	addi	a2,s0,8
 92c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 930:	85aa                	mv	a1,a0
 932:	4505                	li	a0,1
 934:	00000097          	auipc	ra,0x0
 938:	dce080e7          	jalr	-562(ra) # 702 <vprintf>
}
 93c:	60e2                	ld	ra,24(sp)
 93e:	6442                	ld	s0,16(sp)
 940:	6125                	addi	sp,sp,96
 942:	8082                	ret

0000000000000944 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 944:	1141                	addi	sp,sp,-16
 946:	e422                	sd	s0,8(sp)
 948:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 94a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94e:	00000797          	auipc	a5,0x0
 952:	3527b783          	ld	a5,850(a5) # ca0 <freep>
 956:	a805                	j	986 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 958:	4618                	lw	a4,8(a2)
 95a:	9db9                	addw	a1,a1,a4
 95c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 960:	6398                	ld	a4,0(a5)
 962:	6318                	ld	a4,0(a4)
 964:	fee53823          	sd	a4,-16(a0)
 968:	a091                	j	9ac <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 96a:	ff852703          	lw	a4,-8(a0)
 96e:	9e39                	addw	a2,a2,a4
 970:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 972:	ff053703          	ld	a4,-16(a0)
 976:	e398                	sd	a4,0(a5)
 978:	a099                	j	9be <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 97a:	6398                	ld	a4,0(a5)
 97c:	00e7e463          	bltu	a5,a4,984 <free+0x40>
 980:	00e6ea63          	bltu	a3,a4,994 <free+0x50>
{
 984:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 986:	fed7fae3          	bgeu	a5,a3,97a <free+0x36>
 98a:	6398                	ld	a4,0(a5)
 98c:	00e6e463          	bltu	a3,a4,994 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 990:	fee7eae3          	bltu	a5,a4,984 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 994:	ff852583          	lw	a1,-8(a0)
 998:	6390                	ld	a2,0(a5)
 99a:	02059713          	slli	a4,a1,0x20
 99e:	9301                	srli	a4,a4,0x20
 9a0:	0712                	slli	a4,a4,0x4
 9a2:	9736                	add	a4,a4,a3
 9a4:	fae60ae3          	beq	a2,a4,958 <free+0x14>
    bp->s.ptr = p->s.ptr;
 9a8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9ac:	4790                	lw	a2,8(a5)
 9ae:	02061713          	slli	a4,a2,0x20
 9b2:	9301                	srli	a4,a4,0x20
 9b4:	0712                	slli	a4,a4,0x4
 9b6:	973e                	add	a4,a4,a5
 9b8:	fae689e3          	beq	a3,a4,96a <free+0x26>
  } else
    p->s.ptr = bp;
 9bc:	e394                	sd	a3,0(a5)
  freep = p;
 9be:	00000717          	auipc	a4,0x0
 9c2:	2ef73123          	sd	a5,738(a4) # ca0 <freep>
}
 9c6:	6422                	ld	s0,8(sp)
 9c8:	0141                	addi	sp,sp,16
 9ca:	8082                	ret

00000000000009cc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9cc:	7139                	addi	sp,sp,-64
 9ce:	fc06                	sd	ra,56(sp)
 9d0:	f822                	sd	s0,48(sp)
 9d2:	f426                	sd	s1,40(sp)
 9d4:	f04a                	sd	s2,32(sp)
 9d6:	ec4e                	sd	s3,24(sp)
 9d8:	e852                	sd	s4,16(sp)
 9da:	e456                	sd	s5,8(sp)
 9dc:	e05a                	sd	s6,0(sp)
 9de:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e0:	02051493          	slli	s1,a0,0x20
 9e4:	9081                	srli	s1,s1,0x20
 9e6:	04bd                	addi	s1,s1,15
 9e8:	8091                	srli	s1,s1,0x4
 9ea:	0014899b          	addiw	s3,s1,1
 9ee:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9f0:	00000517          	auipc	a0,0x0
 9f4:	2b053503          	ld	a0,688(a0) # ca0 <freep>
 9f8:	c515                	beqz	a0,a24 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9fa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9fc:	4798                	lw	a4,8(a5)
 9fe:	02977f63          	bgeu	a4,s1,a3c <malloc+0x70>
 a02:	8a4e                	mv	s4,s3
 a04:	0009871b          	sext.w	a4,s3
 a08:	6685                	lui	a3,0x1
 a0a:	00d77363          	bgeu	a4,a3,a10 <malloc+0x44>
 a0e:	6a05                	lui	s4,0x1
 a10:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a14:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a18:	00000917          	auipc	s2,0x0
 a1c:	28890913          	addi	s2,s2,648 # ca0 <freep>
  if(p == (char*)-1)
 a20:	5afd                	li	s5,-1
 a22:	a88d                	j	a94 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a24:	00001797          	auipc	a5,0x1
 a28:	28478793          	addi	a5,a5,644 # 1ca8 <base>
 a2c:	00000717          	auipc	a4,0x0
 a30:	26f73a23          	sd	a5,628(a4) # ca0 <freep>
 a34:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a36:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a3a:	b7e1                	j	a02 <malloc+0x36>
      if(p->s.size == nunits)
 a3c:	02e48b63          	beq	s1,a4,a72 <malloc+0xa6>
        p->s.size -= nunits;
 a40:	4137073b          	subw	a4,a4,s3
 a44:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a46:	1702                	slli	a4,a4,0x20
 a48:	9301                	srli	a4,a4,0x20
 a4a:	0712                	slli	a4,a4,0x4
 a4c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a4e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a52:	00000717          	auipc	a4,0x0
 a56:	24a73723          	sd	a0,590(a4) # ca0 <freep>
      return (void*)(p + 1);
 a5a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a5e:	70e2                	ld	ra,56(sp)
 a60:	7442                	ld	s0,48(sp)
 a62:	74a2                	ld	s1,40(sp)
 a64:	7902                	ld	s2,32(sp)
 a66:	69e2                	ld	s3,24(sp)
 a68:	6a42                	ld	s4,16(sp)
 a6a:	6aa2                	ld	s5,8(sp)
 a6c:	6b02                	ld	s6,0(sp)
 a6e:	6121                	addi	sp,sp,64
 a70:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a72:	6398                	ld	a4,0(a5)
 a74:	e118                	sd	a4,0(a0)
 a76:	bff1                	j	a52 <malloc+0x86>
  hp->s.size = nu;
 a78:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a7c:	0541                	addi	a0,a0,16
 a7e:	00000097          	auipc	ra,0x0
 a82:	ec6080e7          	jalr	-314(ra) # 944 <free>
  return freep;
 a86:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a8a:	d971                	beqz	a0,a5e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a8c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a8e:	4798                	lw	a4,8(a5)
 a90:	fa9776e3          	bgeu	a4,s1,a3c <malloc+0x70>
    if(p == freep)
 a94:	00093703          	ld	a4,0(s2)
 a98:	853e                	mv	a0,a5
 a9a:	fef719e3          	bne	a4,a5,a8c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a9e:	8552                	mv	a0,s4
 aa0:	00000097          	auipc	ra,0x0
 aa4:	b7e080e7          	jalr	-1154(ra) # 61e <sbrk>
  if(p == (char*)-1)
 aa8:	fd5518e3          	bne	a0,s5,a78 <malloc+0xac>
        return 0;
 aac:	4501                	li	a0,0
 aae:	bf45                	j	a5e <malloc+0x92>

0000000000000ab0 <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 ab0:	7179                	addi	sp,sp,-48
 ab2:	f406                	sd	ra,40(sp)
 ab4:	f022                	sd	s0,32(sp)
 ab6:	ec26                	sd	s1,24(sp)
 ab8:	e84a                	sd	s2,16(sp)
 aba:	e44e                	sd	s3,8(sp)
 abc:	e052                	sd	s4,0(sp)
 abe:	1800                	addi	s0,sp,48
 ac0:	8a2a                	mv	s4,a0
 ac2:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 ac4:	4581                	li	a1,0
 ac6:	00000517          	auipc	a0,0x0
 aca:	1b250513          	addi	a0,a0,434 # c78 <digits+0x18>
 ace:	00000097          	auipc	ra,0x0
 ad2:	b08080e7          	jalr	-1272(ra) # 5d6 <open>
  if(fd < 0) {
 ad6:	04054263          	bltz	a0,b1a <statistics+0x6a>
 ada:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 adc:	4481                	li	s1,0
 ade:	03205063          	blez	s2,afe <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 ae2:	4099063b          	subw	a2,s2,s1
 ae6:	009a05b3          	add	a1,s4,s1
 aea:	854e                	mv	a0,s3
 aec:	00000097          	auipc	ra,0x0
 af0:	ac2080e7          	jalr	-1342(ra) # 5ae <read>
 af4:	00054563          	bltz	a0,afe <statistics+0x4e>
      break;
    }
    i += n;
 af8:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 afa:	ff24c4e3          	blt	s1,s2,ae2 <statistics+0x32>
  }
  close(fd);
 afe:	854e                	mv	a0,s3
 b00:	00000097          	auipc	ra,0x0
 b04:	abe080e7          	jalr	-1346(ra) # 5be <close>
  return i;
}
 b08:	8526                	mv	a0,s1
 b0a:	70a2                	ld	ra,40(sp)
 b0c:	7402                	ld	s0,32(sp)
 b0e:	64e2                	ld	s1,24(sp)
 b10:	6942                	ld	s2,16(sp)
 b12:	69a2                	ld	s3,8(sp)
 b14:	6a02                	ld	s4,0(sp)
 b16:	6145                	addi	sp,sp,48
 b18:	8082                	ret
      fprintf(2, "stats: open failed\n");
 b1a:	00000597          	auipc	a1,0x0
 b1e:	16e58593          	addi	a1,a1,366 # c88 <digits+0x28>
 b22:	4509                	li	a0,2
 b24:	00000097          	auipc	ra,0x0
 b28:	dbc080e7          	jalr	-580(ra) # 8e0 <fprintf>
      exit(1);
 b2c:	4505                	li	a0,1
 b2e:	00000097          	auipc	ra,0x0
 b32:	a68080e7          	jalr	-1432(ra) # 596 <exit>
