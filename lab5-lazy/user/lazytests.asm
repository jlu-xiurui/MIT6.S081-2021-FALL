
user/_lazytests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sparse_memory>:

#define REGION_SZ (1024 * 1024 * 1024)

void
sparse_memory(char *s)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  char *i, *prev_end, *new_end;  
  prev_end = sbrk(REGION_SZ);
   8:	40000537          	lui	a0,0x40000
   c:	00000097          	auipc	ra,0x0
  10:	614080e7          	jalr	1556(ra) # 620 <sbrk>
  if (prev_end == (char*)0xffffffffffffffffL) {
  14:	57fd                	li	a5,-1
  16:	04f50363          	beq	a0,a5,5c <sparse_memory+0x5c>
    printf("sbrk() failed\n");
    exit(1);
  }
  new_end = prev_end + REGION_SZ;

  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
  1a:	6605                	lui	a2,0x1
  1c:	962a                	add	a2,a2,a0
  1e:	40001737          	lui	a4,0x40001
  22:	972a                	add	a4,a4,a0
  24:	87b2                	mv	a5,a2
  26:	000406b7          	lui	a3,0x40
    *(char **)i = i;
  2a:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
  2c:	97b6                	add	a5,a5,a3
  2e:	fee79ee3          	bne	a5,a4,2a <sparse_memory+0x2a>

  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
  32:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
  36:	621c                	ld	a5,0(a2)
  38:	02c79f63          	bne	a5,a2,76 <sparse_memory+0x76>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
  3c:	9636                	add	a2,a2,a3
  3e:	fee61ce3          	bne	a2,a4,36 <sparse_memory+0x36>
      printf("failed to read value from memory\n");
      exit(1);
    }
  }

  printf("sbrk\n");
  42:	00001517          	auipc	a0,0x1
  46:	ade50513          	addi	a0,a0,-1314 # b20 <malloc+0x152>
  4a:	00001097          	auipc	ra,0x1
  4e:	8c6080e7          	jalr	-1850(ra) # 910 <printf>
  exit(0);
  52:	4501                	li	a0,0
  54:	00000097          	auipc	ra,0x0
  58:	544080e7          	jalr	1348(ra) # 598 <exit>
    printf("sbrk() failed\n");
  5c:	00001517          	auipc	a0,0x1
  60:	a8c50513          	addi	a0,a0,-1396 # ae8 <malloc+0x11a>
  64:	00001097          	auipc	ra,0x1
  68:	8ac080e7          	jalr	-1876(ra) # 910 <printf>
    exit(1);
  6c:	4505                	li	a0,1
  6e:	00000097          	auipc	ra,0x0
  72:	52a080e7          	jalr	1322(ra) # 598 <exit>
      printf("failed to read value from memory\n");
  76:	00001517          	auipc	a0,0x1
  7a:	a8250513          	addi	a0,a0,-1406 # af8 <malloc+0x12a>
  7e:	00001097          	auipc	ra,0x1
  82:	892080e7          	jalr	-1902(ra) # 910 <printf>
      exit(1);
  86:	4505                	li	a0,1
  88:	00000097          	auipc	ra,0x0
  8c:	510080e7          	jalr	1296(ra) # 598 <exit>

0000000000000090 <sparse_memory_unmap>:
}

void
sparse_memory_unmap(char *s)
{
  90:	7139                	addi	sp,sp,-64
  92:	fc06                	sd	ra,56(sp)
  94:	f822                	sd	s0,48(sp)
  96:	f426                	sd	s1,40(sp)
  98:	f04a                	sd	s2,32(sp)
  9a:	ec4e                	sd	s3,24(sp)
  9c:	0080                	addi	s0,sp,64
  int pid;
  char *i, *prev_end, *new_end;

  prev_end = sbrk(REGION_SZ);
  9e:	40000537          	lui	a0,0x40000
  a2:	00000097          	auipc	ra,0x0
  a6:	57e080e7          	jalr	1406(ra) # 620 <sbrk>
  if (prev_end == (char*)0xffffffffffffffffL) {
  aa:	57fd                	li	a5,-1
  ac:	04f50863          	beq	a0,a5,fc <sparse_memory_unmap+0x6c>
    printf("sbrk() failed\n");
    exit(1);
  }
  new_end = prev_end + REGION_SZ;

  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
  b0:	6905                	lui	s2,0x1
  b2:	992a                	add	s2,s2,a0
  b4:	400014b7          	lui	s1,0x40001
  b8:	94aa                	add	s1,s1,a0
  ba:	87ca                	mv	a5,s2
  bc:	01000737          	lui	a4,0x1000
    *(char **)i = i;
  c0:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
  c2:	97ba                	add	a5,a5,a4
  c4:	fef49ee3          	bne	s1,a5,c0 <sparse_memory_unmap+0x30>

  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
  c8:	010009b7          	lui	s3,0x1000
    pid = fork();
  cc:	00000097          	auipc	ra,0x0
  d0:	4c4080e7          	jalr	1220(ra) # 590 <fork>
    if (pid < 0) {
  d4:	04054163          	bltz	a0,116 <sparse_memory_unmap+0x86>
      printf("error forking\n");
      exit(1);
    } else if (pid == 0) {
  d8:	cd21                	beqz	a0,130 <sparse_memory_unmap+0xa0>
      sbrk(-1L * REGION_SZ);
      *(char **)i = i;
      exit(0);
    } else {
      int status;
      wait(&status);
  da:	fcc40513          	addi	a0,s0,-52
  de:	00000097          	auipc	ra,0x0
  e2:	4c2080e7          	jalr	1218(ra) # 5a0 <wait>
      if (status == 0) {
  e6:	fcc42783          	lw	a5,-52(s0)
  ea:	c3a5                	beqz	a5,14a <sparse_memory_unmap+0xba>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
  ec:	994e                	add	s2,s2,s3
  ee:	fd249fe3          	bne	s1,s2,cc <sparse_memory_unmap+0x3c>
        exit(1);
      }
    }
  }

  exit(0);
  f2:	4501                	li	a0,0
  f4:	00000097          	auipc	ra,0x0
  f8:	4a4080e7          	jalr	1188(ra) # 598 <exit>
    printf("sbrk() failed\n");
  fc:	00001517          	auipc	a0,0x1
 100:	9ec50513          	addi	a0,a0,-1556 # ae8 <malloc+0x11a>
 104:	00001097          	auipc	ra,0x1
 108:	80c080e7          	jalr	-2036(ra) # 910 <printf>
    exit(1);
 10c:	4505                	li	a0,1
 10e:	00000097          	auipc	ra,0x0
 112:	48a080e7          	jalr	1162(ra) # 598 <exit>
      printf("error forking\n");
 116:	00001517          	auipc	a0,0x1
 11a:	a1250513          	addi	a0,a0,-1518 # b28 <malloc+0x15a>
 11e:	00000097          	auipc	ra,0x0
 122:	7f2080e7          	jalr	2034(ra) # 910 <printf>
      exit(1);
 126:	4505                	li	a0,1
 128:	00000097          	auipc	ra,0x0
 12c:	470080e7          	jalr	1136(ra) # 598 <exit>
      sbrk(-1L * REGION_SZ);
 130:	c0000537          	lui	a0,0xc0000
 134:	00000097          	auipc	ra,0x0
 138:	4ec080e7          	jalr	1260(ra) # 620 <sbrk>
      *(char **)i = i;
 13c:	01293023          	sd	s2,0(s2) # 1000 <__BSS_END__+0x398>
      exit(0);
 140:	4501                	li	a0,0
 142:	00000097          	auipc	ra,0x0
 146:	456080e7          	jalr	1110(ra) # 598 <exit>
        printf("memory not unmapped\n");
 14a:	00001517          	auipc	a0,0x1
 14e:	9ee50513          	addi	a0,a0,-1554 # b38 <malloc+0x16a>
 152:	00000097          	auipc	ra,0x0
 156:	7be080e7          	jalr	1982(ra) # 910 <printf>
        exit(1);
 15a:	4505                	li	a0,1
 15c:	00000097          	auipc	ra,0x0
 160:	43c080e7          	jalr	1084(ra) # 598 <exit>

0000000000000164 <oom>:
}

void
oom(char *s)
{
 164:	7179                	addi	sp,sp,-48
 166:	f406                	sd	ra,40(sp)
 168:	f022                	sd	s0,32(sp)
 16a:	ec26                	sd	s1,24(sp)
 16c:	1800                	addi	s0,sp,48
  void *m1, *m2;
  int pid;

  if((pid = fork()) == 0){
 16e:	00000097          	auipc	ra,0x0
 172:	422080e7          	jalr	1058(ra) # 590 <fork>
    m1 = 0;
 176:	4481                	li	s1,0
  if((pid = fork()) == 0){
 178:	c10d                	beqz	a0,19a <oom+0x36>
      m1 = m2;
    }
    exit(0);
  } else {
    int xstatus;
    wait(&xstatus);
 17a:	fdc40513          	addi	a0,s0,-36
 17e:	00000097          	auipc	ra,0x0
 182:	422080e7          	jalr	1058(ra) # 5a0 <wait>
    exit(xstatus == 0);
 186:	fdc42503          	lw	a0,-36(s0)
 18a:	00153513          	seqz	a0,a0
 18e:	00000097          	auipc	ra,0x0
 192:	40a080e7          	jalr	1034(ra) # 598 <exit>
      *(char**)m2 = m1;
 196:	e104                	sd	s1,0(a0)
      m1 = m2;
 198:	84aa                	mv	s1,a0
    while((m2 = malloc(4096*4096)) != 0){
 19a:	01000537          	lui	a0,0x1000
 19e:	00001097          	auipc	ra,0x1
 1a2:	830080e7          	jalr	-2000(ra) # 9ce <malloc>
 1a6:	f965                	bnez	a0,196 <oom+0x32>
    exit(0);
 1a8:	00000097          	auipc	ra,0x0
 1ac:	3f0080e7          	jalr	1008(ra) # 598 <exit>

00000000000001b0 <run>:
}

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
 1b0:	7179                	addi	sp,sp,-48
 1b2:	f406                	sd	ra,40(sp)
 1b4:	f022                	sd	s0,32(sp)
 1b6:	ec26                	sd	s1,24(sp)
 1b8:	e84a                	sd	s2,16(sp)
 1ba:	1800                	addi	s0,sp,48
 1bc:	892a                	mv	s2,a0
 1be:	84ae                	mv	s1,a1
  int pid;
  int xstatus;
  
  printf("running test %s\n", s);
 1c0:	00001517          	auipc	a0,0x1
 1c4:	99050513          	addi	a0,a0,-1648 # b50 <malloc+0x182>
 1c8:	00000097          	auipc	ra,0x0
 1cc:	748080e7          	jalr	1864(ra) # 910 <printf>
  if((pid = fork()) < 0) {
 1d0:	00000097          	auipc	ra,0x0
 1d4:	3c0080e7          	jalr	960(ra) # 590 <fork>
 1d8:	02054f63          	bltz	a0,216 <run+0x66>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
 1dc:	c931                	beqz	a0,230 <run+0x80>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
 1de:	fdc40513          	addi	a0,s0,-36
 1e2:	00000097          	auipc	ra,0x0
 1e6:	3be080e7          	jalr	958(ra) # 5a0 <wait>
    if(xstatus != 0) 
 1ea:	fdc42783          	lw	a5,-36(s0)
 1ee:	cba1                	beqz	a5,23e <run+0x8e>
      printf("test %s: FAILED\n", s);
 1f0:	85a6                	mv	a1,s1
 1f2:	00001517          	auipc	a0,0x1
 1f6:	98e50513          	addi	a0,a0,-1650 # b80 <malloc+0x1b2>
 1fa:	00000097          	auipc	ra,0x0
 1fe:	716080e7          	jalr	1814(ra) # 910 <printf>
    else
      printf("test %s: OK\n", s);
    return xstatus == 0;
 202:	fdc42503          	lw	a0,-36(s0)
  }
}
 206:	00153513          	seqz	a0,a0
 20a:	70a2                	ld	ra,40(sp)
 20c:	7402                	ld	s0,32(sp)
 20e:	64e2                	ld	s1,24(sp)
 210:	6942                	ld	s2,16(sp)
 212:	6145                	addi	sp,sp,48
 214:	8082                	ret
    printf("runtest: fork error\n");
 216:	00001517          	auipc	a0,0x1
 21a:	95250513          	addi	a0,a0,-1710 # b68 <malloc+0x19a>
 21e:	00000097          	auipc	ra,0x0
 222:	6f2080e7          	jalr	1778(ra) # 910 <printf>
    exit(1);
 226:	4505                	li	a0,1
 228:	00000097          	auipc	ra,0x0
 22c:	370080e7          	jalr	880(ra) # 598 <exit>
    f(s);
 230:	8526                	mv	a0,s1
 232:	9902                	jalr	s2
    exit(0);
 234:	4501                	li	a0,0
 236:	00000097          	auipc	ra,0x0
 23a:	362080e7          	jalr	866(ra) # 598 <exit>
      printf("test %s: OK\n", s);
 23e:	85a6                	mv	a1,s1
 240:	00001517          	auipc	a0,0x1
 244:	95850513          	addi	a0,a0,-1704 # b98 <malloc+0x1ca>
 248:	00000097          	auipc	ra,0x0
 24c:	6c8080e7          	jalr	1736(ra) # 910 <printf>
 250:	bf4d                	j	202 <run+0x52>

0000000000000252 <main>:

int
main(int argc, char *argv[])
{
 252:	7159                	addi	sp,sp,-112
 254:	f486                	sd	ra,104(sp)
 256:	f0a2                	sd	s0,96(sp)
 258:	eca6                	sd	s1,88(sp)
 25a:	e8ca                	sd	s2,80(sp)
 25c:	e4ce                	sd	s3,72(sp)
 25e:	e0d2                	sd	s4,64(sp)
 260:	1880                	addi	s0,sp,112
  char *n = 0;
  if(argc > 1) {
 262:	4785                	li	a5,1
  char *n = 0;
 264:	4901                	li	s2,0
  if(argc > 1) {
 266:	00a7d463          	bge	a5,a0,26e <main+0x1c>
    n = argv[1];
 26a:	0085b903          	ld	s2,8(a1)
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
 26e:	00001797          	auipc	a5,0x1
 272:	98278793          	addi	a5,a5,-1662 # bf0 <malloc+0x222>
 276:	0007b883          	ld	a7,0(a5)
 27a:	0087b803          	ld	a6,8(a5)
 27e:	6b88                	ld	a0,16(a5)
 280:	6f8c                	ld	a1,24(a5)
 282:	7390                	ld	a2,32(a5)
 284:	7794                	ld	a3,40(a5)
 286:	7b98                	ld	a4,48(a5)
 288:	7f9c                	ld	a5,56(a5)
 28a:	f9143823          	sd	a7,-112(s0)
 28e:	f9043c23          	sd	a6,-104(s0)
 292:	faa43023          	sd	a0,-96(s0)
 296:	fab43423          	sd	a1,-88(s0)
 29a:	fac43823          	sd	a2,-80(s0)
 29e:	fad43c23          	sd	a3,-72(s0)
 2a2:	fce43023          	sd	a4,-64(s0)
 2a6:	fcf43423          	sd	a5,-56(s0)
    { sparse_memory_unmap, "lazy unmap"},
    { oom, "out of memory"},
    { 0, 0},
  };
    
  printf("lazytests starting\n");
 2aa:	00001517          	auipc	a0,0x1
 2ae:	8fe50513          	addi	a0,a0,-1794 # ba8 <malloc+0x1da>
 2b2:	00000097          	auipc	ra,0x0
 2b6:	65e080e7          	jalr	1630(ra) # 910 <printf>

  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
 2ba:	f9843503          	ld	a0,-104(s0)
 2be:	c529                	beqz	a0,308 <main+0xb6>
 2c0:	f9040493          	addi	s1,s0,-112
  int fail = 0;
 2c4:	4981                	li	s3,0
    if((n == 0) || strcmp(t->s, n) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
 2c6:	4a05                	li	s4,1
 2c8:	a021                	j	2d0 <main+0x7e>
  for (struct test *t = tests; t->s != 0; t++) {
 2ca:	04c1                	addi	s1,s1,16
 2cc:	6488                	ld	a0,8(s1)
 2ce:	c115                	beqz	a0,2f2 <main+0xa0>
    if((n == 0) || strcmp(t->s, n) == 0) {
 2d0:	00090863          	beqz	s2,2e0 <main+0x8e>
 2d4:	85ca                	mv	a1,s2
 2d6:	00000097          	auipc	ra,0x0
 2da:	068080e7          	jalr	104(ra) # 33e <strcmp>
 2de:	f575                	bnez	a0,2ca <main+0x78>
      if(!run(t->f, t->s))
 2e0:	648c                	ld	a1,8(s1)
 2e2:	6088                	ld	a0,0(s1)
 2e4:	00000097          	auipc	ra,0x0
 2e8:	ecc080e7          	jalr	-308(ra) # 1b0 <run>
 2ec:	fd79                	bnez	a0,2ca <main+0x78>
        fail = 1;
 2ee:	89d2                	mv	s3,s4
 2f0:	bfe9                	j	2ca <main+0x78>
    }
  }
  if(!fail)
 2f2:	00098b63          	beqz	s3,308 <main+0xb6>
    printf("ALL TESTS PASSED\n");
  else
    printf("SOME TESTS FAILED\n");
 2f6:	00001517          	auipc	a0,0x1
 2fa:	8e250513          	addi	a0,a0,-1822 # bd8 <malloc+0x20a>
 2fe:	00000097          	auipc	ra,0x0
 302:	612080e7          	jalr	1554(ra) # 910 <printf>
 306:	a809                	j	318 <main+0xc6>
    printf("ALL TESTS PASSED\n");
 308:	00001517          	auipc	a0,0x1
 30c:	8b850513          	addi	a0,a0,-1864 # bc0 <malloc+0x1f2>
 310:	00000097          	auipc	ra,0x0
 314:	600080e7          	jalr	1536(ra) # 910 <printf>
  exit(1);   // not reached.
 318:	4505                	li	a0,1
 31a:	00000097          	auipc	ra,0x0
 31e:	27e080e7          	jalr	638(ra) # 598 <exit>

0000000000000322 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 322:	1141                	addi	sp,sp,-16
 324:	e422                	sd	s0,8(sp)
 326:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 328:	87aa                	mv	a5,a0
 32a:	0585                	addi	a1,a1,1
 32c:	0785                	addi	a5,a5,1
 32e:	fff5c703          	lbu	a4,-1(a1)
 332:	fee78fa3          	sb	a4,-1(a5)
 336:	fb75                	bnez	a4,32a <strcpy+0x8>
    ;
  return os;
}
 338:	6422                	ld	s0,8(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret

000000000000033e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e422                	sd	s0,8(sp)
 342:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 344:	00054783          	lbu	a5,0(a0)
 348:	cb91                	beqz	a5,35c <strcmp+0x1e>
 34a:	0005c703          	lbu	a4,0(a1)
 34e:	00f71763          	bne	a4,a5,35c <strcmp+0x1e>
    p++, q++;
 352:	0505                	addi	a0,a0,1
 354:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 356:	00054783          	lbu	a5,0(a0)
 35a:	fbe5                	bnez	a5,34a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 35c:	0005c503          	lbu	a0,0(a1)
}
 360:	40a7853b          	subw	a0,a5,a0
 364:	6422                	ld	s0,8(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret

000000000000036a <strlen>:

uint
strlen(const char *s)
{
 36a:	1141                	addi	sp,sp,-16
 36c:	e422                	sd	s0,8(sp)
 36e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 370:	00054783          	lbu	a5,0(a0)
 374:	cf91                	beqz	a5,390 <strlen+0x26>
 376:	0505                	addi	a0,a0,1
 378:	87aa                	mv	a5,a0
 37a:	4685                	li	a3,1
 37c:	9e89                	subw	a3,a3,a0
 37e:	00f6853b          	addw	a0,a3,a5
 382:	0785                	addi	a5,a5,1
 384:	fff7c703          	lbu	a4,-1(a5)
 388:	fb7d                	bnez	a4,37e <strlen+0x14>
    ;
  return n;
}
 38a:	6422                	ld	s0,8(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret
  for(n = 0; s[n]; n++)
 390:	4501                	li	a0,0
 392:	bfe5                	j	38a <strlen+0x20>

0000000000000394 <memset>:

void*
memset(void *dst, int c, uint n)
{
 394:	1141                	addi	sp,sp,-16
 396:	e422                	sd	s0,8(sp)
 398:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 39a:	ce09                	beqz	a2,3b4 <memset+0x20>
 39c:	87aa                	mv	a5,a0
 39e:	fff6071b          	addiw	a4,a2,-1
 3a2:	1702                	slli	a4,a4,0x20
 3a4:	9301                	srli	a4,a4,0x20
 3a6:	0705                	addi	a4,a4,1
 3a8:	972a                	add	a4,a4,a0
    cdst[i] = c;
 3aa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3ae:	0785                	addi	a5,a5,1
 3b0:	fee79de3          	bne	a5,a4,3aa <memset+0x16>
  }
  return dst;
}
 3b4:	6422                	ld	s0,8(sp)
 3b6:	0141                	addi	sp,sp,16
 3b8:	8082                	ret

00000000000003ba <strchr>:

char*
strchr(const char *s, char c)
{
 3ba:	1141                	addi	sp,sp,-16
 3bc:	e422                	sd	s0,8(sp)
 3be:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3c0:	00054783          	lbu	a5,0(a0)
 3c4:	cb99                	beqz	a5,3da <strchr+0x20>
    if(*s == c)
 3c6:	00f58763          	beq	a1,a5,3d4 <strchr+0x1a>
  for(; *s; s++)
 3ca:	0505                	addi	a0,a0,1
 3cc:	00054783          	lbu	a5,0(a0)
 3d0:	fbfd                	bnez	a5,3c6 <strchr+0xc>
      return (char*)s;
  return 0;
 3d2:	4501                	li	a0,0
}
 3d4:	6422                	ld	s0,8(sp)
 3d6:	0141                	addi	sp,sp,16
 3d8:	8082                	ret
  return 0;
 3da:	4501                	li	a0,0
 3dc:	bfe5                	j	3d4 <strchr+0x1a>

00000000000003de <gets>:

char*
gets(char *buf, int max)
{
 3de:	711d                	addi	sp,sp,-96
 3e0:	ec86                	sd	ra,88(sp)
 3e2:	e8a2                	sd	s0,80(sp)
 3e4:	e4a6                	sd	s1,72(sp)
 3e6:	e0ca                	sd	s2,64(sp)
 3e8:	fc4e                	sd	s3,56(sp)
 3ea:	f852                	sd	s4,48(sp)
 3ec:	f456                	sd	s5,40(sp)
 3ee:	f05a                	sd	s6,32(sp)
 3f0:	ec5e                	sd	s7,24(sp)
 3f2:	1080                	addi	s0,sp,96
 3f4:	8baa                	mv	s7,a0
 3f6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f8:	892a                	mv	s2,a0
 3fa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3fc:	4aa9                	li	s5,10
 3fe:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 400:	89a6                	mv	s3,s1
 402:	2485                	addiw	s1,s1,1
 404:	0344d863          	bge	s1,s4,434 <gets+0x56>
    cc = read(0, &c, 1);
 408:	4605                	li	a2,1
 40a:	faf40593          	addi	a1,s0,-81
 40e:	4501                	li	a0,0
 410:	00000097          	auipc	ra,0x0
 414:	1a0080e7          	jalr	416(ra) # 5b0 <read>
    if(cc < 1)
 418:	00a05e63          	blez	a0,434 <gets+0x56>
    buf[i++] = c;
 41c:	faf44783          	lbu	a5,-81(s0)
 420:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 424:	01578763          	beq	a5,s5,432 <gets+0x54>
 428:	0905                	addi	s2,s2,1
 42a:	fd679be3          	bne	a5,s6,400 <gets+0x22>
  for(i=0; i+1 < max; ){
 42e:	89a6                	mv	s3,s1
 430:	a011                	j	434 <gets+0x56>
 432:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 434:	99de                	add	s3,s3,s7
 436:	00098023          	sb	zero,0(s3) # 1000000 <__global_pointer$+0xffebb7>
  return buf;
}
 43a:	855e                	mv	a0,s7
 43c:	60e6                	ld	ra,88(sp)
 43e:	6446                	ld	s0,80(sp)
 440:	64a6                	ld	s1,72(sp)
 442:	6906                	ld	s2,64(sp)
 444:	79e2                	ld	s3,56(sp)
 446:	7a42                	ld	s4,48(sp)
 448:	7aa2                	ld	s5,40(sp)
 44a:	7b02                	ld	s6,32(sp)
 44c:	6be2                	ld	s7,24(sp)
 44e:	6125                	addi	sp,sp,96
 450:	8082                	ret

0000000000000452 <stat>:

int
stat(const char *n, struct stat *st)
{
 452:	1101                	addi	sp,sp,-32
 454:	ec06                	sd	ra,24(sp)
 456:	e822                	sd	s0,16(sp)
 458:	e426                	sd	s1,8(sp)
 45a:	e04a                	sd	s2,0(sp)
 45c:	1000                	addi	s0,sp,32
 45e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 460:	4581                	li	a1,0
 462:	00000097          	auipc	ra,0x0
 466:	176080e7          	jalr	374(ra) # 5d8 <open>
  if(fd < 0)
 46a:	02054563          	bltz	a0,494 <stat+0x42>
 46e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 470:	85ca                	mv	a1,s2
 472:	00000097          	auipc	ra,0x0
 476:	17e080e7          	jalr	382(ra) # 5f0 <fstat>
 47a:	892a                	mv	s2,a0
  close(fd);
 47c:	8526                	mv	a0,s1
 47e:	00000097          	auipc	ra,0x0
 482:	142080e7          	jalr	322(ra) # 5c0 <close>
  return r;
}
 486:	854a                	mv	a0,s2
 488:	60e2                	ld	ra,24(sp)
 48a:	6442                	ld	s0,16(sp)
 48c:	64a2                	ld	s1,8(sp)
 48e:	6902                	ld	s2,0(sp)
 490:	6105                	addi	sp,sp,32
 492:	8082                	ret
    return -1;
 494:	597d                	li	s2,-1
 496:	bfc5                	j	486 <stat+0x34>

0000000000000498 <atoi>:

int
atoi(const char *s)
{
 498:	1141                	addi	sp,sp,-16
 49a:	e422                	sd	s0,8(sp)
 49c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 49e:	00054603          	lbu	a2,0(a0)
 4a2:	fd06079b          	addiw	a5,a2,-48
 4a6:	0ff7f793          	andi	a5,a5,255
 4aa:	4725                	li	a4,9
 4ac:	02f76963          	bltu	a4,a5,4de <atoi+0x46>
 4b0:	86aa                	mv	a3,a0
  n = 0;
 4b2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 4b4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 4b6:	0685                	addi	a3,a3,1
 4b8:	0025179b          	slliw	a5,a0,0x2
 4bc:	9fa9                	addw	a5,a5,a0
 4be:	0017979b          	slliw	a5,a5,0x1
 4c2:	9fb1                	addw	a5,a5,a2
 4c4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4c8:	0006c603          	lbu	a2,0(a3) # 40000 <__global_pointer$+0x3ebb7>
 4cc:	fd06071b          	addiw	a4,a2,-48
 4d0:	0ff77713          	andi	a4,a4,255
 4d4:	fee5f1e3          	bgeu	a1,a4,4b6 <atoi+0x1e>
  return n;
}
 4d8:	6422                	ld	s0,8(sp)
 4da:	0141                	addi	sp,sp,16
 4dc:	8082                	ret
  n = 0;
 4de:	4501                	li	a0,0
 4e0:	bfe5                	j	4d8 <atoi+0x40>

00000000000004e2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4e2:	1141                	addi	sp,sp,-16
 4e4:	e422                	sd	s0,8(sp)
 4e6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4e8:	02b57663          	bgeu	a0,a1,514 <memmove+0x32>
    while(n-- > 0)
 4ec:	02c05163          	blez	a2,50e <memmove+0x2c>
 4f0:	fff6079b          	addiw	a5,a2,-1
 4f4:	1782                	slli	a5,a5,0x20
 4f6:	9381                	srli	a5,a5,0x20
 4f8:	0785                	addi	a5,a5,1
 4fa:	97aa                	add	a5,a5,a0
  dst = vdst;
 4fc:	872a                	mv	a4,a0
      *dst++ = *src++;
 4fe:	0585                	addi	a1,a1,1
 500:	0705                	addi	a4,a4,1
 502:	fff5c683          	lbu	a3,-1(a1)
 506:	fed70fa3          	sb	a3,-1(a4) # ffffff <__global_pointer$+0xffebb6>
    while(n-- > 0)
 50a:	fee79ae3          	bne	a5,a4,4fe <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 50e:	6422                	ld	s0,8(sp)
 510:	0141                	addi	sp,sp,16
 512:	8082                	ret
    dst += n;
 514:	00c50733          	add	a4,a0,a2
    src += n;
 518:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 51a:	fec05ae3          	blez	a2,50e <memmove+0x2c>
 51e:	fff6079b          	addiw	a5,a2,-1
 522:	1782                	slli	a5,a5,0x20
 524:	9381                	srli	a5,a5,0x20
 526:	fff7c793          	not	a5,a5
 52a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 52c:	15fd                	addi	a1,a1,-1
 52e:	177d                	addi	a4,a4,-1
 530:	0005c683          	lbu	a3,0(a1)
 534:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 538:	fee79ae3          	bne	a5,a4,52c <memmove+0x4a>
 53c:	bfc9                	j	50e <memmove+0x2c>

000000000000053e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 53e:	1141                	addi	sp,sp,-16
 540:	e422                	sd	s0,8(sp)
 542:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 544:	ca05                	beqz	a2,574 <memcmp+0x36>
 546:	fff6069b          	addiw	a3,a2,-1
 54a:	1682                	slli	a3,a3,0x20
 54c:	9281                	srli	a3,a3,0x20
 54e:	0685                	addi	a3,a3,1
 550:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 552:	00054783          	lbu	a5,0(a0)
 556:	0005c703          	lbu	a4,0(a1)
 55a:	00e79863          	bne	a5,a4,56a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 55e:	0505                	addi	a0,a0,1
    p2++;
 560:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 562:	fed518e3          	bne	a0,a3,552 <memcmp+0x14>
  }
  return 0;
 566:	4501                	li	a0,0
 568:	a019                	j	56e <memcmp+0x30>
      return *p1 - *p2;
 56a:	40e7853b          	subw	a0,a5,a4
}
 56e:	6422                	ld	s0,8(sp)
 570:	0141                	addi	sp,sp,16
 572:	8082                	ret
  return 0;
 574:	4501                	li	a0,0
 576:	bfe5                	j	56e <memcmp+0x30>

0000000000000578 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 578:	1141                	addi	sp,sp,-16
 57a:	e406                	sd	ra,8(sp)
 57c:	e022                	sd	s0,0(sp)
 57e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 580:	00000097          	auipc	ra,0x0
 584:	f62080e7          	jalr	-158(ra) # 4e2 <memmove>
}
 588:	60a2                	ld	ra,8(sp)
 58a:	6402                	ld	s0,0(sp)
 58c:	0141                	addi	sp,sp,16
 58e:	8082                	ret

0000000000000590 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 590:	4885                	li	a7,1
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <exit>:
.global exit
exit:
 li a7, SYS_exit
 598:	4889                	li	a7,2
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5a0:	488d                	li	a7,3
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5a8:	4891                	li	a7,4
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <read>:
.global read
read:
 li a7, SYS_read
 5b0:	4895                	li	a7,5
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <write>:
.global write
write:
 li a7, SYS_write
 5b8:	48c1                	li	a7,16
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <close>:
.global close
close:
 li a7, SYS_close
 5c0:	48d5                	li	a7,21
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5c8:	4899                	li	a7,6
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5d0:	489d                	li	a7,7
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <open>:
.global open
open:
 li a7, SYS_open
 5d8:	48bd                	li	a7,15
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5e0:	48c5                	li	a7,17
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5e8:	48c9                	li	a7,18
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5f0:	48a1                	li	a7,8
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <link>:
.global link
link:
 li a7, SYS_link
 5f8:	48cd                	li	a7,19
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 600:	48d1                	li	a7,20
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 608:	48a5                	li	a7,9
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <dup>:
.global dup
dup:
 li a7, SYS_dup
 610:	48a9                	li	a7,10
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 618:	48ad                	li	a7,11
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 620:	48b1                	li	a7,12
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 628:	48b5                	li	a7,13
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 630:	48b9                	li	a7,14
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 638:	1101                	addi	sp,sp,-32
 63a:	ec06                	sd	ra,24(sp)
 63c:	e822                	sd	s0,16(sp)
 63e:	1000                	addi	s0,sp,32
 640:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 644:	4605                	li	a2,1
 646:	fef40593          	addi	a1,s0,-17
 64a:	00000097          	auipc	ra,0x0
 64e:	f6e080e7          	jalr	-146(ra) # 5b8 <write>
}
 652:	60e2                	ld	ra,24(sp)
 654:	6442                	ld	s0,16(sp)
 656:	6105                	addi	sp,sp,32
 658:	8082                	ret

000000000000065a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 65a:	7139                	addi	sp,sp,-64
 65c:	fc06                	sd	ra,56(sp)
 65e:	f822                	sd	s0,48(sp)
 660:	f426                	sd	s1,40(sp)
 662:	f04a                	sd	s2,32(sp)
 664:	ec4e                	sd	s3,24(sp)
 666:	0080                	addi	s0,sp,64
 668:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 66a:	c299                	beqz	a3,670 <printint+0x16>
 66c:	0805c863          	bltz	a1,6fc <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 670:	2581                	sext.w	a1,a1
  neg = 0;
 672:	4881                	li	a7,0
 674:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 678:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 67a:	2601                	sext.w	a2,a2
 67c:	00000517          	auipc	a0,0x0
 680:	5bc50513          	addi	a0,a0,1468 # c38 <digits>
 684:	883a                	mv	a6,a4
 686:	2705                	addiw	a4,a4,1
 688:	02c5f7bb          	remuw	a5,a1,a2
 68c:	1782                	slli	a5,a5,0x20
 68e:	9381                	srli	a5,a5,0x20
 690:	97aa                	add	a5,a5,a0
 692:	0007c783          	lbu	a5,0(a5)
 696:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 69a:	0005879b          	sext.w	a5,a1
 69e:	02c5d5bb          	divuw	a1,a1,a2
 6a2:	0685                	addi	a3,a3,1
 6a4:	fec7f0e3          	bgeu	a5,a2,684 <printint+0x2a>
  if(neg)
 6a8:	00088b63          	beqz	a7,6be <printint+0x64>
    buf[i++] = '-';
 6ac:	fd040793          	addi	a5,s0,-48
 6b0:	973e                	add	a4,a4,a5
 6b2:	02d00793          	li	a5,45
 6b6:	fef70823          	sb	a5,-16(a4)
 6ba:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6be:	02e05863          	blez	a4,6ee <printint+0x94>
 6c2:	fc040793          	addi	a5,s0,-64
 6c6:	00e78933          	add	s2,a5,a4
 6ca:	fff78993          	addi	s3,a5,-1
 6ce:	99ba                	add	s3,s3,a4
 6d0:	377d                	addiw	a4,a4,-1
 6d2:	1702                	slli	a4,a4,0x20
 6d4:	9301                	srli	a4,a4,0x20
 6d6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6da:	fff94583          	lbu	a1,-1(s2)
 6de:	8526                	mv	a0,s1
 6e0:	00000097          	auipc	ra,0x0
 6e4:	f58080e7          	jalr	-168(ra) # 638 <putc>
  while(--i >= 0)
 6e8:	197d                	addi	s2,s2,-1
 6ea:	ff3918e3          	bne	s2,s3,6da <printint+0x80>
}
 6ee:	70e2                	ld	ra,56(sp)
 6f0:	7442                	ld	s0,48(sp)
 6f2:	74a2                	ld	s1,40(sp)
 6f4:	7902                	ld	s2,32(sp)
 6f6:	69e2                	ld	s3,24(sp)
 6f8:	6121                	addi	sp,sp,64
 6fa:	8082                	ret
    x = -xx;
 6fc:	40b005bb          	negw	a1,a1
    neg = 1;
 700:	4885                	li	a7,1
    x = -xx;
 702:	bf8d                	j	674 <printint+0x1a>

0000000000000704 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 704:	7119                	addi	sp,sp,-128
 706:	fc86                	sd	ra,120(sp)
 708:	f8a2                	sd	s0,112(sp)
 70a:	f4a6                	sd	s1,104(sp)
 70c:	f0ca                	sd	s2,96(sp)
 70e:	ecce                	sd	s3,88(sp)
 710:	e8d2                	sd	s4,80(sp)
 712:	e4d6                	sd	s5,72(sp)
 714:	e0da                	sd	s6,64(sp)
 716:	fc5e                	sd	s7,56(sp)
 718:	f862                	sd	s8,48(sp)
 71a:	f466                	sd	s9,40(sp)
 71c:	f06a                	sd	s10,32(sp)
 71e:	ec6e                	sd	s11,24(sp)
 720:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 722:	0005c903          	lbu	s2,0(a1)
 726:	18090f63          	beqz	s2,8c4 <vprintf+0x1c0>
 72a:	8aaa                	mv	s5,a0
 72c:	8b32                	mv	s6,a2
 72e:	00158493          	addi	s1,a1,1
  state = 0;
 732:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 734:	02500a13          	li	s4,37
      if(c == 'd'){
 738:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 73c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 740:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 744:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 748:	00000b97          	auipc	s7,0x0
 74c:	4f0b8b93          	addi	s7,s7,1264 # c38 <digits>
 750:	a839                	j	76e <vprintf+0x6a>
        putc(fd, c);
 752:	85ca                	mv	a1,s2
 754:	8556                	mv	a0,s5
 756:	00000097          	auipc	ra,0x0
 75a:	ee2080e7          	jalr	-286(ra) # 638 <putc>
 75e:	a019                	j	764 <vprintf+0x60>
    } else if(state == '%'){
 760:	01498f63          	beq	s3,s4,77e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 764:	0485                	addi	s1,s1,1
 766:	fff4c903          	lbu	s2,-1(s1) # 40000fff <__global_pointer$+0x3ffffbb6>
 76a:	14090d63          	beqz	s2,8c4 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 76e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 772:	fe0997e3          	bnez	s3,760 <vprintf+0x5c>
      if(c == '%'){
 776:	fd479ee3          	bne	a5,s4,752 <vprintf+0x4e>
        state = '%';
 77a:	89be                	mv	s3,a5
 77c:	b7e5                	j	764 <vprintf+0x60>
      if(c == 'd'){
 77e:	05878063          	beq	a5,s8,7be <vprintf+0xba>
      } else if(c == 'l') {
 782:	05978c63          	beq	a5,s9,7da <vprintf+0xd6>
      } else if(c == 'x') {
 786:	07a78863          	beq	a5,s10,7f6 <vprintf+0xf2>
      } else if(c == 'p') {
 78a:	09b78463          	beq	a5,s11,812 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 78e:	07300713          	li	a4,115
 792:	0ce78663          	beq	a5,a4,85e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 796:	06300713          	li	a4,99
 79a:	0ee78e63          	beq	a5,a4,896 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 79e:	11478863          	beq	a5,s4,8ae <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7a2:	85d2                	mv	a1,s4
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	e92080e7          	jalr	-366(ra) # 638 <putc>
        putc(fd, c);
 7ae:	85ca                	mv	a1,s2
 7b0:	8556                	mv	a0,s5
 7b2:	00000097          	auipc	ra,0x0
 7b6:	e86080e7          	jalr	-378(ra) # 638 <putc>
      }
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	b765                	j	764 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7be:	008b0913          	addi	s2,s6,8
 7c2:	4685                	li	a3,1
 7c4:	4629                	li	a2,10
 7c6:	000b2583          	lw	a1,0(s6)
 7ca:	8556                	mv	a0,s5
 7cc:	00000097          	auipc	ra,0x0
 7d0:	e8e080e7          	jalr	-370(ra) # 65a <printint>
 7d4:	8b4a                	mv	s6,s2
      state = 0;
 7d6:	4981                	li	s3,0
 7d8:	b771                	j	764 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7da:	008b0913          	addi	s2,s6,8
 7de:	4681                	li	a3,0
 7e0:	4629                	li	a2,10
 7e2:	000b2583          	lw	a1,0(s6)
 7e6:	8556                	mv	a0,s5
 7e8:	00000097          	auipc	ra,0x0
 7ec:	e72080e7          	jalr	-398(ra) # 65a <printint>
 7f0:	8b4a                	mv	s6,s2
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	bf85                	j	764 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7f6:	008b0913          	addi	s2,s6,8
 7fa:	4681                	li	a3,0
 7fc:	4641                	li	a2,16
 7fe:	000b2583          	lw	a1,0(s6)
 802:	8556                	mv	a0,s5
 804:	00000097          	auipc	ra,0x0
 808:	e56080e7          	jalr	-426(ra) # 65a <printint>
 80c:	8b4a                	mv	s6,s2
      state = 0;
 80e:	4981                	li	s3,0
 810:	bf91                	j	764 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 812:	008b0793          	addi	a5,s6,8
 816:	f8f43423          	sd	a5,-120(s0)
 81a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 81e:	03000593          	li	a1,48
 822:	8556                	mv	a0,s5
 824:	00000097          	auipc	ra,0x0
 828:	e14080e7          	jalr	-492(ra) # 638 <putc>
  putc(fd, 'x');
 82c:	85ea                	mv	a1,s10
 82e:	8556                	mv	a0,s5
 830:	00000097          	auipc	ra,0x0
 834:	e08080e7          	jalr	-504(ra) # 638 <putc>
 838:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 83a:	03c9d793          	srli	a5,s3,0x3c
 83e:	97de                	add	a5,a5,s7
 840:	0007c583          	lbu	a1,0(a5)
 844:	8556                	mv	a0,s5
 846:	00000097          	auipc	ra,0x0
 84a:	df2080e7          	jalr	-526(ra) # 638 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 84e:	0992                	slli	s3,s3,0x4
 850:	397d                	addiw	s2,s2,-1
 852:	fe0914e3          	bnez	s2,83a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 856:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 85a:	4981                	li	s3,0
 85c:	b721                	j	764 <vprintf+0x60>
        s = va_arg(ap, char*);
 85e:	008b0993          	addi	s3,s6,8
 862:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 866:	02090163          	beqz	s2,888 <vprintf+0x184>
        while(*s != 0){
 86a:	00094583          	lbu	a1,0(s2)
 86e:	c9a1                	beqz	a1,8be <vprintf+0x1ba>
          putc(fd, *s);
 870:	8556                	mv	a0,s5
 872:	00000097          	auipc	ra,0x0
 876:	dc6080e7          	jalr	-570(ra) # 638 <putc>
          s++;
 87a:	0905                	addi	s2,s2,1
        while(*s != 0){
 87c:	00094583          	lbu	a1,0(s2)
 880:	f9e5                	bnez	a1,870 <vprintf+0x16c>
        s = va_arg(ap, char*);
 882:	8b4e                	mv	s6,s3
      state = 0;
 884:	4981                	li	s3,0
 886:	bdf9                	j	764 <vprintf+0x60>
          s = "(null)";
 888:	00000917          	auipc	s2,0x0
 88c:	3a890913          	addi	s2,s2,936 # c30 <malloc+0x262>
        while(*s != 0){
 890:	02800593          	li	a1,40
 894:	bff1                	j	870 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 896:	008b0913          	addi	s2,s6,8
 89a:	000b4583          	lbu	a1,0(s6)
 89e:	8556                	mv	a0,s5
 8a0:	00000097          	auipc	ra,0x0
 8a4:	d98080e7          	jalr	-616(ra) # 638 <putc>
 8a8:	8b4a                	mv	s6,s2
      state = 0;
 8aa:	4981                	li	s3,0
 8ac:	bd65                	j	764 <vprintf+0x60>
        putc(fd, c);
 8ae:	85d2                	mv	a1,s4
 8b0:	8556                	mv	a0,s5
 8b2:	00000097          	auipc	ra,0x0
 8b6:	d86080e7          	jalr	-634(ra) # 638 <putc>
      state = 0;
 8ba:	4981                	li	s3,0
 8bc:	b565                	j	764 <vprintf+0x60>
        s = va_arg(ap, char*);
 8be:	8b4e                	mv	s6,s3
      state = 0;
 8c0:	4981                	li	s3,0
 8c2:	b54d                	j	764 <vprintf+0x60>
    }
  }
}
 8c4:	70e6                	ld	ra,120(sp)
 8c6:	7446                	ld	s0,112(sp)
 8c8:	74a6                	ld	s1,104(sp)
 8ca:	7906                	ld	s2,96(sp)
 8cc:	69e6                	ld	s3,88(sp)
 8ce:	6a46                	ld	s4,80(sp)
 8d0:	6aa6                	ld	s5,72(sp)
 8d2:	6b06                	ld	s6,64(sp)
 8d4:	7be2                	ld	s7,56(sp)
 8d6:	7c42                	ld	s8,48(sp)
 8d8:	7ca2                	ld	s9,40(sp)
 8da:	7d02                	ld	s10,32(sp)
 8dc:	6de2                	ld	s11,24(sp)
 8de:	6109                	addi	sp,sp,128
 8e0:	8082                	ret

00000000000008e2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8e2:	715d                	addi	sp,sp,-80
 8e4:	ec06                	sd	ra,24(sp)
 8e6:	e822                	sd	s0,16(sp)
 8e8:	1000                	addi	s0,sp,32
 8ea:	e010                	sd	a2,0(s0)
 8ec:	e414                	sd	a3,8(s0)
 8ee:	e818                	sd	a4,16(s0)
 8f0:	ec1c                	sd	a5,24(s0)
 8f2:	03043023          	sd	a6,32(s0)
 8f6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8fa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8fe:	8622                	mv	a2,s0
 900:	00000097          	auipc	ra,0x0
 904:	e04080e7          	jalr	-508(ra) # 704 <vprintf>
}
 908:	60e2                	ld	ra,24(sp)
 90a:	6442                	ld	s0,16(sp)
 90c:	6161                	addi	sp,sp,80
 90e:	8082                	ret

0000000000000910 <printf>:

void
printf(const char *fmt, ...)
{
 910:	711d                	addi	sp,sp,-96
 912:	ec06                	sd	ra,24(sp)
 914:	e822                	sd	s0,16(sp)
 916:	1000                	addi	s0,sp,32
 918:	e40c                	sd	a1,8(s0)
 91a:	e810                	sd	a2,16(s0)
 91c:	ec14                	sd	a3,24(s0)
 91e:	f018                	sd	a4,32(s0)
 920:	f41c                	sd	a5,40(s0)
 922:	03043823          	sd	a6,48(s0)
 926:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 92a:	00840613          	addi	a2,s0,8
 92e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 932:	85aa                	mv	a1,a0
 934:	4505                	li	a0,1
 936:	00000097          	auipc	ra,0x0
 93a:	dce080e7          	jalr	-562(ra) # 704 <vprintf>
}
 93e:	60e2                	ld	ra,24(sp)
 940:	6442                	ld	s0,16(sp)
 942:	6125                	addi	sp,sp,96
 944:	8082                	ret

0000000000000946 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 946:	1141                	addi	sp,sp,-16
 948:	e422                	sd	s0,8(sp)
 94a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 94c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 950:	00000797          	auipc	a5,0x0
 954:	3007b783          	ld	a5,768(a5) # c50 <freep>
 958:	a805                	j	988 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 95a:	4618                	lw	a4,8(a2)
 95c:	9db9                	addw	a1,a1,a4
 95e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 962:	6398                	ld	a4,0(a5)
 964:	6318                	ld	a4,0(a4)
 966:	fee53823          	sd	a4,-16(a0)
 96a:	a091                	j	9ae <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 96c:	ff852703          	lw	a4,-8(a0)
 970:	9e39                	addw	a2,a2,a4
 972:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 974:	ff053703          	ld	a4,-16(a0)
 978:	e398                	sd	a4,0(a5)
 97a:	a099                	j	9c0 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 97c:	6398                	ld	a4,0(a5)
 97e:	00e7e463          	bltu	a5,a4,986 <free+0x40>
 982:	00e6ea63          	bltu	a3,a4,996 <free+0x50>
{
 986:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 988:	fed7fae3          	bgeu	a5,a3,97c <free+0x36>
 98c:	6398                	ld	a4,0(a5)
 98e:	00e6e463          	bltu	a3,a4,996 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 992:	fee7eae3          	bltu	a5,a4,986 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 996:	ff852583          	lw	a1,-8(a0)
 99a:	6390                	ld	a2,0(a5)
 99c:	02059713          	slli	a4,a1,0x20
 9a0:	9301                	srli	a4,a4,0x20
 9a2:	0712                	slli	a4,a4,0x4
 9a4:	9736                	add	a4,a4,a3
 9a6:	fae60ae3          	beq	a2,a4,95a <free+0x14>
    bp->s.ptr = p->s.ptr;
 9aa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9ae:	4790                	lw	a2,8(a5)
 9b0:	02061713          	slli	a4,a2,0x20
 9b4:	9301                	srli	a4,a4,0x20
 9b6:	0712                	slli	a4,a4,0x4
 9b8:	973e                	add	a4,a4,a5
 9ba:	fae689e3          	beq	a3,a4,96c <free+0x26>
  } else
    p->s.ptr = bp;
 9be:	e394                	sd	a3,0(a5)
  freep = p;
 9c0:	00000717          	auipc	a4,0x0
 9c4:	28f73823          	sd	a5,656(a4) # c50 <freep>
}
 9c8:	6422                	ld	s0,8(sp)
 9ca:	0141                	addi	sp,sp,16
 9cc:	8082                	ret

00000000000009ce <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ce:	7139                	addi	sp,sp,-64
 9d0:	fc06                	sd	ra,56(sp)
 9d2:	f822                	sd	s0,48(sp)
 9d4:	f426                	sd	s1,40(sp)
 9d6:	f04a                	sd	s2,32(sp)
 9d8:	ec4e                	sd	s3,24(sp)
 9da:	e852                	sd	s4,16(sp)
 9dc:	e456                	sd	s5,8(sp)
 9de:	e05a                	sd	s6,0(sp)
 9e0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e2:	02051493          	slli	s1,a0,0x20
 9e6:	9081                	srli	s1,s1,0x20
 9e8:	04bd                	addi	s1,s1,15
 9ea:	8091                	srli	s1,s1,0x4
 9ec:	0014899b          	addiw	s3,s1,1
 9f0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9f2:	00000517          	auipc	a0,0x0
 9f6:	25e53503          	ld	a0,606(a0) # c50 <freep>
 9fa:	c515                	beqz	a0,a26 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9fe:	4798                	lw	a4,8(a5)
 a00:	02977f63          	bgeu	a4,s1,a3e <malloc+0x70>
 a04:	8a4e                	mv	s4,s3
 a06:	0009871b          	sext.w	a4,s3
 a0a:	6685                	lui	a3,0x1
 a0c:	00d77363          	bgeu	a4,a3,a12 <malloc+0x44>
 a10:	6a05                	lui	s4,0x1
 a12:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a16:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a1a:	00000917          	auipc	s2,0x0
 a1e:	23690913          	addi	s2,s2,566 # c50 <freep>
  if(p == (char*)-1)
 a22:	5afd                	li	s5,-1
 a24:	a88d                	j	a96 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a26:	00000797          	auipc	a5,0x0
 a2a:	23278793          	addi	a5,a5,562 # c58 <base>
 a2e:	00000717          	auipc	a4,0x0
 a32:	22f73123          	sd	a5,546(a4) # c50 <freep>
 a36:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a38:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a3c:	b7e1                	j	a04 <malloc+0x36>
      if(p->s.size == nunits)
 a3e:	02e48b63          	beq	s1,a4,a74 <malloc+0xa6>
        p->s.size -= nunits;
 a42:	4137073b          	subw	a4,a4,s3
 a46:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a48:	1702                	slli	a4,a4,0x20
 a4a:	9301                	srli	a4,a4,0x20
 a4c:	0712                	slli	a4,a4,0x4
 a4e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a50:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a54:	00000717          	auipc	a4,0x0
 a58:	1ea73e23          	sd	a0,508(a4) # c50 <freep>
      return (void*)(p + 1);
 a5c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a60:	70e2                	ld	ra,56(sp)
 a62:	7442                	ld	s0,48(sp)
 a64:	74a2                	ld	s1,40(sp)
 a66:	7902                	ld	s2,32(sp)
 a68:	69e2                	ld	s3,24(sp)
 a6a:	6a42                	ld	s4,16(sp)
 a6c:	6aa2                	ld	s5,8(sp)
 a6e:	6b02                	ld	s6,0(sp)
 a70:	6121                	addi	sp,sp,64
 a72:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a74:	6398                	ld	a4,0(a5)
 a76:	e118                	sd	a4,0(a0)
 a78:	bff1                	j	a54 <malloc+0x86>
  hp->s.size = nu;
 a7a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a7e:	0541                	addi	a0,a0,16
 a80:	00000097          	auipc	ra,0x0
 a84:	ec6080e7          	jalr	-314(ra) # 946 <free>
  return freep;
 a88:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a8c:	d971                	beqz	a0,a60 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a8e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a90:	4798                	lw	a4,8(a5)
 a92:	fa9776e3          	bgeu	a4,s1,a3e <malloc+0x70>
    if(p == freep)
 a96:	00093703          	ld	a4,0(s2)
 a9a:	853e                	mv	a0,a5
 a9c:	fef719e3          	bne	a4,a5,a8e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 aa0:	8552                	mv	a0,s4
 aa2:	00000097          	auipc	ra,0x0
 aa6:	b7e080e7          	jalr	-1154(ra) # 620 <sbrk>
  if(p == (char*)-1)
 aaa:	fd5518e3          	bne	a0,s5,a7a <malloc+0xac>
        return 0;
 aae:	4501                	li	a0,0
 ab0:	bf45                	j	a60 <malloc+0x92>
