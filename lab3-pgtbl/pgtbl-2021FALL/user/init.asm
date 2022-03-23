
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	8a250513          	addi	a0,a0,-1886 # 8b0 <malloc+0xe6>
  16:	00000097          	auipc	ra,0x0
  1a:	3ae080e7          	jalr	942(ra) # 3c4 <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	3d8080e7          	jalr	984(ra) # 3fc <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	3ce080e7          	jalr	974(ra) # 3fc <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	88290913          	addi	s2,s2,-1918 # 8b8 <malloc+0xee>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	6cc080e7          	jalr	1740(ra) # 70c <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	334080e7          	jalr	820(ra) # 37c <fork>
  50:	84aa                	mv	s1,a0
    if(pid < 0){
  52:	04054d63          	bltz	a0,ac <main+0xac>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  56:	c925                	beqz	a0,c6 <main+0xc6>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	332080e7          	jalr	818(ra) # 38c <wait>
      if(wpid == pid){
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	89e50513          	addi	a0,a0,-1890 # 908 <malloc+0x13e>
  72:	00000097          	auipc	ra,0x0
  76:	69a080e7          	jalr	1690(ra) # 70c <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	308080e7          	jalr	776(ra) # 384 <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	82850513          	addi	a0,a0,-2008 # 8b0 <malloc+0xe6>
  90:	00000097          	auipc	ra,0x0
  94:	33c080e7          	jalr	828(ra) # 3cc <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	81650513          	addi	a0,a0,-2026 # 8b0 <malloc+0xe6>
  a2:	00000097          	auipc	ra,0x0
  a6:	322080e7          	jalr	802(ra) # 3c4 <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	82450513          	addi	a0,a0,-2012 # 8d0 <malloc+0x106>
  b4:	00000097          	auipc	ra,0x0
  b8:	658080e7          	jalr	1624(ra) # 70c <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2c6080e7          	jalr	710(ra) # 384 <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	88258593          	addi	a1,a1,-1918 # 948 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	81a50513          	addi	a0,a0,-2022 # 8e8 <malloc+0x11e>
  d6:	00000097          	auipc	ra,0x0
  da:	2e6080e7          	jalr	742(ra) # 3bc <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	81250513          	addi	a0,a0,-2030 # 8f0 <malloc+0x126>
  e6:	00000097          	auipc	ra,0x0
  ea:	626080e7          	jalr	1574(ra) # 70c <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	294080e7          	jalr	660(ra) # 384 <exit>

00000000000000f8 <strcpy>:



char*
strcpy(char *s, const char *t)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fe:	87aa                	mv	a5,a0
 100:	0585                	addi	a1,a1,1
 102:	0785                	addi	a5,a5,1
 104:	fff5c703          	lbu	a4,-1(a1)
 108:	fee78fa3          	sb	a4,-1(a5)
 10c:	fb75                	bnez	a4,100 <strcpy+0x8>
    ;
  return os;
}
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret

0000000000000114 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 114:	1141                	addi	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cb91                	beqz	a5,132 <strcmp+0x1e>
 120:	0005c703          	lbu	a4,0(a1)
 124:	00f71763          	bne	a4,a5,132 <strcmp+0x1e>
    p++, q++;
 128:	0505                	addi	a0,a0,1
 12a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 12c:	00054783          	lbu	a5,0(a0)
 130:	fbe5                	bnez	a5,120 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 132:	0005c503          	lbu	a0,0(a1)
}
 136:	40a7853b          	subw	a0,a5,a0
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret

0000000000000140 <strlen>:

uint
strlen(const char *s)
{
 140:	1141                	addi	sp,sp,-16
 142:	e422                	sd	s0,8(sp)
 144:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 146:	00054783          	lbu	a5,0(a0)
 14a:	cf91                	beqz	a5,166 <strlen+0x26>
 14c:	0505                	addi	a0,a0,1
 14e:	87aa                	mv	a5,a0
 150:	4685                	li	a3,1
 152:	9e89                	subw	a3,a3,a0
 154:	00f6853b          	addw	a0,a3,a5
 158:	0785                	addi	a5,a5,1
 15a:	fff7c703          	lbu	a4,-1(a5)
 15e:	fb7d                	bnez	a4,154 <strlen+0x14>
    ;
  return n;
}
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret
  for(n = 0; s[n]; n++)
 166:	4501                	li	a0,0
 168:	bfe5                	j	160 <strlen+0x20>

000000000000016a <memset>:

void*
memset(void *dst, int c, uint n)
{
 16a:	1141                	addi	sp,sp,-16
 16c:	e422                	sd	s0,8(sp)
 16e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 170:	ce09                	beqz	a2,18a <memset+0x20>
 172:	87aa                	mv	a5,a0
 174:	fff6071b          	addiw	a4,a2,-1
 178:	1702                	slli	a4,a4,0x20
 17a:	9301                	srli	a4,a4,0x20
 17c:	0705                	addi	a4,a4,1
 17e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 180:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 184:	0785                	addi	a5,a5,1
 186:	fee79de3          	bne	a5,a4,180 <memset+0x16>
  }
  return dst;
}
 18a:	6422                	ld	s0,8(sp)
 18c:	0141                	addi	sp,sp,16
 18e:	8082                	ret

0000000000000190 <strchr>:

char*
strchr(const char *s, char c)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  for(; *s; s++)
 196:	00054783          	lbu	a5,0(a0)
 19a:	cb99                	beqz	a5,1b0 <strchr+0x20>
    if(*s == c)
 19c:	00f58763          	beq	a1,a5,1aa <strchr+0x1a>
  for(; *s; s++)
 1a0:	0505                	addi	a0,a0,1
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	fbfd                	bnez	a5,19c <strchr+0xc>
      return (char*)s;
  return 0;
 1a8:	4501                	li	a0,0
}
 1aa:	6422                	ld	s0,8(sp)
 1ac:	0141                	addi	sp,sp,16
 1ae:	8082                	ret
  return 0;
 1b0:	4501                	li	a0,0
 1b2:	bfe5                	j	1aa <strchr+0x1a>

00000000000001b4 <gets>:

char*
gets(char *buf, int max)
{
 1b4:	711d                	addi	sp,sp,-96
 1b6:	ec86                	sd	ra,88(sp)
 1b8:	e8a2                	sd	s0,80(sp)
 1ba:	e4a6                	sd	s1,72(sp)
 1bc:	e0ca                	sd	s2,64(sp)
 1be:	fc4e                	sd	s3,56(sp)
 1c0:	f852                	sd	s4,48(sp)
 1c2:	f456                	sd	s5,40(sp)
 1c4:	f05a                	sd	s6,32(sp)
 1c6:	ec5e                	sd	s7,24(sp)
 1c8:	1080                	addi	s0,sp,96
 1ca:	8baa                	mv	s7,a0
 1cc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ce:	892a                	mv	s2,a0
 1d0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1d2:	4aa9                	li	s5,10
 1d4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d6:	89a6                	mv	s3,s1
 1d8:	2485                	addiw	s1,s1,1
 1da:	0344d863          	bge	s1,s4,20a <gets+0x56>
    cc = read(0, &c, 1);
 1de:	4605                	li	a2,1
 1e0:	faf40593          	addi	a1,s0,-81
 1e4:	4501                	li	a0,0
 1e6:	00000097          	auipc	ra,0x0
 1ea:	1b6080e7          	jalr	438(ra) # 39c <read>
    if(cc < 1)
 1ee:	00a05e63          	blez	a0,20a <gets+0x56>
    buf[i++] = c;
 1f2:	faf44783          	lbu	a5,-81(s0)
 1f6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1fa:	01578763          	beq	a5,s5,208 <gets+0x54>
 1fe:	0905                	addi	s2,s2,1
 200:	fd679be3          	bne	a5,s6,1d6 <gets+0x22>
  for(i=0; i+1 < max; ){
 204:	89a6                	mv	s3,s1
 206:	a011                	j	20a <gets+0x56>
 208:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 20a:	99de                	add	s3,s3,s7
 20c:	00098023          	sb	zero,0(s3)
  return buf;
}
 210:	855e                	mv	a0,s7
 212:	60e6                	ld	ra,88(sp)
 214:	6446                	ld	s0,80(sp)
 216:	64a6                	ld	s1,72(sp)
 218:	6906                	ld	s2,64(sp)
 21a:	79e2                	ld	s3,56(sp)
 21c:	7a42                	ld	s4,48(sp)
 21e:	7aa2                	ld	s5,40(sp)
 220:	7b02                	ld	s6,32(sp)
 222:	6be2                	ld	s7,24(sp)
 224:	6125                	addi	sp,sp,96
 226:	8082                	ret

0000000000000228 <stat>:

int
stat(const char *n, struct stat *st)
{
 228:	1101                	addi	sp,sp,-32
 22a:	ec06                	sd	ra,24(sp)
 22c:	e822                	sd	s0,16(sp)
 22e:	e426                	sd	s1,8(sp)
 230:	e04a                	sd	s2,0(sp)
 232:	1000                	addi	s0,sp,32
 234:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 236:	4581                	li	a1,0
 238:	00000097          	auipc	ra,0x0
 23c:	18c080e7          	jalr	396(ra) # 3c4 <open>
  if(fd < 0)
 240:	02054563          	bltz	a0,26a <stat+0x42>
 244:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 246:	85ca                	mv	a1,s2
 248:	00000097          	auipc	ra,0x0
 24c:	194080e7          	jalr	404(ra) # 3dc <fstat>
 250:	892a                	mv	s2,a0
  close(fd);
 252:	8526                	mv	a0,s1
 254:	00000097          	auipc	ra,0x0
 258:	158080e7          	jalr	344(ra) # 3ac <close>
  return r;
}
 25c:	854a                	mv	a0,s2
 25e:	60e2                	ld	ra,24(sp)
 260:	6442                	ld	s0,16(sp)
 262:	64a2                	ld	s1,8(sp)
 264:	6902                	ld	s2,0(sp)
 266:	6105                	addi	sp,sp,32
 268:	8082                	ret
    return -1;
 26a:	597d                	li	s2,-1
 26c:	bfc5                	j	25c <stat+0x34>

000000000000026e <atoi>:

int
atoi(const char *s)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 274:	00054603          	lbu	a2,0(a0)
 278:	fd06079b          	addiw	a5,a2,-48
 27c:	0ff7f793          	andi	a5,a5,255
 280:	4725                	li	a4,9
 282:	02f76963          	bltu	a4,a5,2b4 <atoi+0x46>
 286:	86aa                	mv	a3,a0
  n = 0;
 288:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 28a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 28c:	0685                	addi	a3,a3,1
 28e:	0025179b          	slliw	a5,a0,0x2
 292:	9fa9                	addw	a5,a5,a0
 294:	0017979b          	slliw	a5,a5,0x1
 298:	9fb1                	addw	a5,a5,a2
 29a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 29e:	0006c603          	lbu	a2,0(a3)
 2a2:	fd06071b          	addiw	a4,a2,-48
 2a6:	0ff77713          	andi	a4,a4,255
 2aa:	fee5f1e3          	bgeu	a1,a4,28c <atoi+0x1e>
  return n;
}
 2ae:	6422                	ld	s0,8(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret
  n = 0;
 2b4:	4501                	li	a0,0
 2b6:	bfe5                	j	2ae <atoi+0x40>

00000000000002b8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e422                	sd	s0,8(sp)
 2bc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2be:	02b57663          	bgeu	a0,a1,2ea <memmove+0x32>
    while(n-- > 0)
 2c2:	02c05163          	blez	a2,2e4 <memmove+0x2c>
 2c6:	fff6079b          	addiw	a5,a2,-1
 2ca:	1782                	slli	a5,a5,0x20
 2cc:	9381                	srli	a5,a5,0x20
 2ce:	0785                	addi	a5,a5,1
 2d0:	97aa                	add	a5,a5,a0
  dst = vdst;
 2d2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2d4:	0585                	addi	a1,a1,1
 2d6:	0705                	addi	a4,a4,1
 2d8:	fff5c683          	lbu	a3,-1(a1)
 2dc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2e0:	fee79ae3          	bne	a5,a4,2d4 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2e4:	6422                	ld	s0,8(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret
    dst += n;
 2ea:	00c50733          	add	a4,a0,a2
    src += n;
 2ee:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2f0:	fec05ae3          	blez	a2,2e4 <memmove+0x2c>
 2f4:	fff6079b          	addiw	a5,a2,-1
 2f8:	1782                	slli	a5,a5,0x20
 2fa:	9381                	srli	a5,a5,0x20
 2fc:	fff7c793          	not	a5,a5
 300:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 302:	15fd                	addi	a1,a1,-1
 304:	177d                	addi	a4,a4,-1
 306:	0005c683          	lbu	a3,0(a1)
 30a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 30e:	fee79ae3          	bne	a5,a4,302 <memmove+0x4a>
 312:	bfc9                	j	2e4 <memmove+0x2c>

0000000000000314 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 314:	1141                	addi	sp,sp,-16
 316:	e422                	sd	s0,8(sp)
 318:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 31a:	ca05                	beqz	a2,34a <memcmp+0x36>
 31c:	fff6069b          	addiw	a3,a2,-1
 320:	1682                	slli	a3,a3,0x20
 322:	9281                	srli	a3,a3,0x20
 324:	0685                	addi	a3,a3,1
 326:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 328:	00054783          	lbu	a5,0(a0)
 32c:	0005c703          	lbu	a4,0(a1)
 330:	00e79863          	bne	a5,a4,340 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 334:	0505                	addi	a0,a0,1
    p2++;
 336:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 338:	fed518e3          	bne	a0,a3,328 <memcmp+0x14>
  }
  return 0;
 33c:	4501                	li	a0,0
 33e:	a019                	j	344 <memcmp+0x30>
      return *p1 - *p2;
 340:	40e7853b          	subw	a0,a5,a4
}
 344:	6422                	ld	s0,8(sp)
 346:	0141                	addi	sp,sp,16
 348:	8082                	ret
  return 0;
 34a:	4501                	li	a0,0
 34c:	bfe5                	j	344 <memcmp+0x30>

000000000000034e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 34e:	1141                	addi	sp,sp,-16
 350:	e406                	sd	ra,8(sp)
 352:	e022                	sd	s0,0(sp)
 354:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 356:	00000097          	auipc	ra,0x0
 35a:	f62080e7          	jalr	-158(ra) # 2b8 <memmove>
}
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret

0000000000000366 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 366:	1141                	addi	sp,sp,-16
 368:	e422                	sd	s0,8(sp)
 36a:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 36c:	040007b7          	lui	a5,0x4000
}
 370:	17f5                	addi	a5,a5,-3
 372:	07b2                	slli	a5,a5,0xc
 374:	4388                	lw	a0,0(a5)
 376:	6422                	ld	s0,8(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret

000000000000037c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 37c:	4885                	li	a7,1
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <exit>:
.global exit
exit:
 li a7, SYS_exit
 384:	4889                	li	a7,2
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <wait>:
.global wait
wait:
 li a7, SYS_wait
 38c:	488d                	li	a7,3
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 394:	4891                	li	a7,4
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <read>:
.global read
read:
 li a7, SYS_read
 39c:	4895                	li	a7,5
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <write>:
.global write
write:
 li a7, SYS_write
 3a4:	48c1                	li	a7,16
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <close>:
.global close
close:
 li a7, SYS_close
 3ac:	48d5                	li	a7,21
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3b4:	4899                	li	a7,6
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <exec>:
.global exec
exec:
 li a7, SYS_exec
 3bc:	489d                	li	a7,7
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <open>:
.global open
open:
 li a7, SYS_open
 3c4:	48bd                	li	a7,15
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3cc:	48c5                	li	a7,17
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3d4:	48c9                	li	a7,18
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3dc:	48a1                	li	a7,8
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <link>:
.global link
link:
 li a7, SYS_link
 3e4:	48cd                	li	a7,19
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3ec:	48d1                	li	a7,20
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3f4:	48a5                	li	a7,9
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <dup>:
.global dup
dup:
 li a7, SYS_dup
 3fc:	48a9                	li	a7,10
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 404:	48ad                	li	a7,11
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 40c:	48b1                	li	a7,12
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 414:	48b5                	li	a7,13
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 41c:	48b9                	li	a7,14
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <connect>:
.global connect
connect:
 li a7, SYS_connect
 424:	48f5                	li	a7,29
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 42c:	48f9                	li	a7,30
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 434:	1101                	addi	sp,sp,-32
 436:	ec06                	sd	ra,24(sp)
 438:	e822                	sd	s0,16(sp)
 43a:	1000                	addi	s0,sp,32
 43c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 440:	4605                	li	a2,1
 442:	fef40593          	addi	a1,s0,-17
 446:	00000097          	auipc	ra,0x0
 44a:	f5e080e7          	jalr	-162(ra) # 3a4 <write>
}
 44e:	60e2                	ld	ra,24(sp)
 450:	6442                	ld	s0,16(sp)
 452:	6105                	addi	sp,sp,32
 454:	8082                	ret

0000000000000456 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 456:	7139                	addi	sp,sp,-64
 458:	fc06                	sd	ra,56(sp)
 45a:	f822                	sd	s0,48(sp)
 45c:	f426                	sd	s1,40(sp)
 45e:	f04a                	sd	s2,32(sp)
 460:	ec4e                	sd	s3,24(sp)
 462:	0080                	addi	s0,sp,64
 464:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 466:	c299                	beqz	a3,46c <printint+0x16>
 468:	0805c863          	bltz	a1,4f8 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 46c:	2581                	sext.w	a1,a1
  neg = 0;
 46e:	4881                	li	a7,0
 470:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 474:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 476:	2601                	sext.w	a2,a2
 478:	00000517          	auipc	a0,0x0
 47c:	4b850513          	addi	a0,a0,1208 # 930 <digits>
 480:	883a                	mv	a6,a4
 482:	2705                	addiw	a4,a4,1
 484:	02c5f7bb          	remuw	a5,a1,a2
 488:	1782                	slli	a5,a5,0x20
 48a:	9381                	srli	a5,a5,0x20
 48c:	97aa                	add	a5,a5,a0
 48e:	0007c783          	lbu	a5,0(a5) # 4000000 <__global_pointer$+0x3ffeeb8>
 492:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 496:	0005879b          	sext.w	a5,a1
 49a:	02c5d5bb          	divuw	a1,a1,a2
 49e:	0685                	addi	a3,a3,1
 4a0:	fec7f0e3          	bgeu	a5,a2,480 <printint+0x2a>
  if(neg)
 4a4:	00088b63          	beqz	a7,4ba <printint+0x64>
    buf[i++] = '-';
 4a8:	fd040793          	addi	a5,s0,-48
 4ac:	973e                	add	a4,a4,a5
 4ae:	02d00793          	li	a5,45
 4b2:	fef70823          	sb	a5,-16(a4)
 4b6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4ba:	02e05863          	blez	a4,4ea <printint+0x94>
 4be:	fc040793          	addi	a5,s0,-64
 4c2:	00e78933          	add	s2,a5,a4
 4c6:	fff78993          	addi	s3,a5,-1
 4ca:	99ba                	add	s3,s3,a4
 4cc:	377d                	addiw	a4,a4,-1
 4ce:	1702                	slli	a4,a4,0x20
 4d0:	9301                	srli	a4,a4,0x20
 4d2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4d6:	fff94583          	lbu	a1,-1(s2)
 4da:	8526                	mv	a0,s1
 4dc:	00000097          	auipc	ra,0x0
 4e0:	f58080e7          	jalr	-168(ra) # 434 <putc>
  while(--i >= 0)
 4e4:	197d                	addi	s2,s2,-1
 4e6:	ff3918e3          	bne	s2,s3,4d6 <printint+0x80>
}
 4ea:	70e2                	ld	ra,56(sp)
 4ec:	7442                	ld	s0,48(sp)
 4ee:	74a2                	ld	s1,40(sp)
 4f0:	7902                	ld	s2,32(sp)
 4f2:	69e2                	ld	s3,24(sp)
 4f4:	6121                	addi	sp,sp,64
 4f6:	8082                	ret
    x = -xx;
 4f8:	40b005bb          	negw	a1,a1
    neg = 1;
 4fc:	4885                	li	a7,1
    x = -xx;
 4fe:	bf8d                	j	470 <printint+0x1a>

0000000000000500 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 500:	7119                	addi	sp,sp,-128
 502:	fc86                	sd	ra,120(sp)
 504:	f8a2                	sd	s0,112(sp)
 506:	f4a6                	sd	s1,104(sp)
 508:	f0ca                	sd	s2,96(sp)
 50a:	ecce                	sd	s3,88(sp)
 50c:	e8d2                	sd	s4,80(sp)
 50e:	e4d6                	sd	s5,72(sp)
 510:	e0da                	sd	s6,64(sp)
 512:	fc5e                	sd	s7,56(sp)
 514:	f862                	sd	s8,48(sp)
 516:	f466                	sd	s9,40(sp)
 518:	f06a                	sd	s10,32(sp)
 51a:	ec6e                	sd	s11,24(sp)
 51c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 51e:	0005c903          	lbu	s2,0(a1)
 522:	18090f63          	beqz	s2,6c0 <vprintf+0x1c0>
 526:	8aaa                	mv	s5,a0
 528:	8b32                	mv	s6,a2
 52a:	00158493          	addi	s1,a1,1
  state = 0;
 52e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 530:	02500a13          	li	s4,37
      if(c == 'd'){
 534:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 538:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 53c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 540:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 544:	00000b97          	auipc	s7,0x0
 548:	3ecb8b93          	addi	s7,s7,1004 # 930 <digits>
 54c:	a839                	j	56a <vprintf+0x6a>
        putc(fd, c);
 54e:	85ca                	mv	a1,s2
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	ee2080e7          	jalr	-286(ra) # 434 <putc>
 55a:	a019                	j	560 <vprintf+0x60>
    } else if(state == '%'){
 55c:	01498f63          	beq	s3,s4,57a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 560:	0485                	addi	s1,s1,1
 562:	fff4c903          	lbu	s2,-1(s1)
 566:	14090d63          	beqz	s2,6c0 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 56a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 56e:	fe0997e3          	bnez	s3,55c <vprintf+0x5c>
      if(c == '%'){
 572:	fd479ee3          	bne	a5,s4,54e <vprintf+0x4e>
        state = '%';
 576:	89be                	mv	s3,a5
 578:	b7e5                	j	560 <vprintf+0x60>
      if(c == 'd'){
 57a:	05878063          	beq	a5,s8,5ba <vprintf+0xba>
      } else if(c == 'l') {
 57e:	05978c63          	beq	a5,s9,5d6 <vprintf+0xd6>
      } else if(c == 'x') {
 582:	07a78863          	beq	a5,s10,5f2 <vprintf+0xf2>
      } else if(c == 'p') {
 586:	09b78463          	beq	a5,s11,60e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 58a:	07300713          	li	a4,115
 58e:	0ce78663          	beq	a5,a4,65a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 592:	06300713          	li	a4,99
 596:	0ee78e63          	beq	a5,a4,692 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 59a:	11478863          	beq	a5,s4,6aa <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 59e:	85d2                	mv	a1,s4
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	e92080e7          	jalr	-366(ra) # 434 <putc>
        putc(fd, c);
 5aa:	85ca                	mv	a1,s2
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	e86080e7          	jalr	-378(ra) # 434 <putc>
      }
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	b765                	j	560 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5ba:	008b0913          	addi	s2,s6,8
 5be:	4685                	li	a3,1
 5c0:	4629                	li	a2,10
 5c2:	000b2583          	lw	a1,0(s6)
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	e8e080e7          	jalr	-370(ra) # 456 <printint>
 5d0:	8b4a                	mv	s6,s2
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	b771                	j	560 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d6:	008b0913          	addi	s2,s6,8
 5da:	4681                	li	a3,0
 5dc:	4629                	li	a2,10
 5de:	000b2583          	lw	a1,0(s6)
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	e72080e7          	jalr	-398(ra) # 456 <printint>
 5ec:	8b4a                	mv	s6,s2
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	bf85                	j	560 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5f2:	008b0913          	addi	s2,s6,8
 5f6:	4681                	li	a3,0
 5f8:	4641                	li	a2,16
 5fa:	000b2583          	lw	a1,0(s6)
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	e56080e7          	jalr	-426(ra) # 456 <printint>
 608:	8b4a                	mv	s6,s2
      state = 0;
 60a:	4981                	li	s3,0
 60c:	bf91                	j	560 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 60e:	008b0793          	addi	a5,s6,8
 612:	f8f43423          	sd	a5,-120(s0)
 616:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 61a:	03000593          	li	a1,48
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	e14080e7          	jalr	-492(ra) # 434 <putc>
  putc(fd, 'x');
 628:	85ea                	mv	a1,s10
 62a:	8556                	mv	a0,s5
 62c:	00000097          	auipc	ra,0x0
 630:	e08080e7          	jalr	-504(ra) # 434 <putc>
 634:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 636:	03c9d793          	srli	a5,s3,0x3c
 63a:	97de                	add	a5,a5,s7
 63c:	0007c583          	lbu	a1,0(a5)
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	df2080e7          	jalr	-526(ra) # 434 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 64a:	0992                	slli	s3,s3,0x4
 64c:	397d                	addiw	s2,s2,-1
 64e:	fe0914e3          	bnez	s2,636 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 652:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 656:	4981                	li	s3,0
 658:	b721                	j	560 <vprintf+0x60>
        s = va_arg(ap, char*);
 65a:	008b0993          	addi	s3,s6,8
 65e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 662:	02090163          	beqz	s2,684 <vprintf+0x184>
        while(*s != 0){
 666:	00094583          	lbu	a1,0(s2)
 66a:	c9a1                	beqz	a1,6ba <vprintf+0x1ba>
          putc(fd, *s);
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	dc6080e7          	jalr	-570(ra) # 434 <putc>
          s++;
 676:	0905                	addi	s2,s2,1
        while(*s != 0){
 678:	00094583          	lbu	a1,0(s2)
 67c:	f9e5                	bnez	a1,66c <vprintf+0x16c>
        s = va_arg(ap, char*);
 67e:	8b4e                	mv	s6,s3
      state = 0;
 680:	4981                	li	s3,0
 682:	bdf9                	j	560 <vprintf+0x60>
          s = "(null)";
 684:	00000917          	auipc	s2,0x0
 688:	2a490913          	addi	s2,s2,676 # 928 <malloc+0x15e>
        while(*s != 0){
 68c:	02800593          	li	a1,40
 690:	bff1                	j	66c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 692:	008b0913          	addi	s2,s6,8
 696:	000b4583          	lbu	a1,0(s6)
 69a:	8556                	mv	a0,s5
 69c:	00000097          	auipc	ra,0x0
 6a0:	d98080e7          	jalr	-616(ra) # 434 <putc>
 6a4:	8b4a                	mv	s6,s2
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	bd65                	j	560 <vprintf+0x60>
        putc(fd, c);
 6aa:	85d2                	mv	a1,s4
 6ac:	8556                	mv	a0,s5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	d86080e7          	jalr	-634(ra) # 434 <putc>
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	b565                	j	560 <vprintf+0x60>
        s = va_arg(ap, char*);
 6ba:	8b4e                	mv	s6,s3
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	b54d                	j	560 <vprintf+0x60>
    }
  }
}
 6c0:	70e6                	ld	ra,120(sp)
 6c2:	7446                	ld	s0,112(sp)
 6c4:	74a6                	ld	s1,104(sp)
 6c6:	7906                	ld	s2,96(sp)
 6c8:	69e6                	ld	s3,88(sp)
 6ca:	6a46                	ld	s4,80(sp)
 6cc:	6aa6                	ld	s5,72(sp)
 6ce:	6b06                	ld	s6,64(sp)
 6d0:	7be2                	ld	s7,56(sp)
 6d2:	7c42                	ld	s8,48(sp)
 6d4:	7ca2                	ld	s9,40(sp)
 6d6:	7d02                	ld	s10,32(sp)
 6d8:	6de2                	ld	s11,24(sp)
 6da:	6109                	addi	sp,sp,128
 6dc:	8082                	ret

00000000000006de <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6de:	715d                	addi	sp,sp,-80
 6e0:	ec06                	sd	ra,24(sp)
 6e2:	e822                	sd	s0,16(sp)
 6e4:	1000                	addi	s0,sp,32
 6e6:	e010                	sd	a2,0(s0)
 6e8:	e414                	sd	a3,8(s0)
 6ea:	e818                	sd	a4,16(s0)
 6ec:	ec1c                	sd	a5,24(s0)
 6ee:	03043023          	sd	a6,32(s0)
 6f2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6f6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6fa:	8622                	mv	a2,s0
 6fc:	00000097          	auipc	ra,0x0
 700:	e04080e7          	jalr	-508(ra) # 500 <vprintf>
}
 704:	60e2                	ld	ra,24(sp)
 706:	6442                	ld	s0,16(sp)
 708:	6161                	addi	sp,sp,80
 70a:	8082                	ret

000000000000070c <printf>:

void
printf(const char *fmt, ...)
{
 70c:	711d                	addi	sp,sp,-96
 70e:	ec06                	sd	ra,24(sp)
 710:	e822                	sd	s0,16(sp)
 712:	1000                	addi	s0,sp,32
 714:	e40c                	sd	a1,8(s0)
 716:	e810                	sd	a2,16(s0)
 718:	ec14                	sd	a3,24(s0)
 71a:	f018                	sd	a4,32(s0)
 71c:	f41c                	sd	a5,40(s0)
 71e:	03043823          	sd	a6,48(s0)
 722:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 726:	00840613          	addi	a2,s0,8
 72a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 72e:	85aa                	mv	a1,a0
 730:	4505                	li	a0,1
 732:	00000097          	auipc	ra,0x0
 736:	dce080e7          	jalr	-562(ra) # 500 <vprintf>
}
 73a:	60e2                	ld	ra,24(sp)
 73c:	6442                	ld	s0,16(sp)
 73e:	6125                	addi	sp,sp,96
 740:	8082                	ret

0000000000000742 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 742:	1141                	addi	sp,sp,-16
 744:	e422                	sd	s0,8(sp)
 746:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 748:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74c:	00000797          	auipc	a5,0x0
 750:	20c7b783          	ld	a5,524(a5) # 958 <freep>
 754:	a805                	j	784 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 756:	4618                	lw	a4,8(a2)
 758:	9db9                	addw	a1,a1,a4
 75a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 75e:	6398                	ld	a4,0(a5)
 760:	6318                	ld	a4,0(a4)
 762:	fee53823          	sd	a4,-16(a0)
 766:	a091                	j	7aa <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 768:	ff852703          	lw	a4,-8(a0)
 76c:	9e39                	addw	a2,a2,a4
 76e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 770:	ff053703          	ld	a4,-16(a0)
 774:	e398                	sd	a4,0(a5)
 776:	a099                	j	7bc <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 778:	6398                	ld	a4,0(a5)
 77a:	00e7e463          	bltu	a5,a4,782 <free+0x40>
 77e:	00e6ea63          	bltu	a3,a4,792 <free+0x50>
{
 782:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 784:	fed7fae3          	bgeu	a5,a3,778 <free+0x36>
 788:	6398                	ld	a4,0(a5)
 78a:	00e6e463          	bltu	a3,a4,792 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78e:	fee7eae3          	bltu	a5,a4,782 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 792:	ff852583          	lw	a1,-8(a0)
 796:	6390                	ld	a2,0(a5)
 798:	02059713          	slli	a4,a1,0x20
 79c:	9301                	srli	a4,a4,0x20
 79e:	0712                	slli	a4,a4,0x4
 7a0:	9736                	add	a4,a4,a3
 7a2:	fae60ae3          	beq	a2,a4,756 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7a6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7aa:	4790                	lw	a2,8(a5)
 7ac:	02061713          	slli	a4,a2,0x20
 7b0:	9301                	srli	a4,a4,0x20
 7b2:	0712                	slli	a4,a4,0x4
 7b4:	973e                	add	a4,a4,a5
 7b6:	fae689e3          	beq	a3,a4,768 <free+0x26>
  } else
    p->s.ptr = bp;
 7ba:	e394                	sd	a3,0(a5)
  freep = p;
 7bc:	00000717          	auipc	a4,0x0
 7c0:	18f73e23          	sd	a5,412(a4) # 958 <freep>
}
 7c4:	6422                	ld	s0,8(sp)
 7c6:	0141                	addi	sp,sp,16
 7c8:	8082                	ret

00000000000007ca <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ca:	7139                	addi	sp,sp,-64
 7cc:	fc06                	sd	ra,56(sp)
 7ce:	f822                	sd	s0,48(sp)
 7d0:	f426                	sd	s1,40(sp)
 7d2:	f04a                	sd	s2,32(sp)
 7d4:	ec4e                	sd	s3,24(sp)
 7d6:	e852                	sd	s4,16(sp)
 7d8:	e456                	sd	s5,8(sp)
 7da:	e05a                	sd	s6,0(sp)
 7dc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7de:	02051493          	slli	s1,a0,0x20
 7e2:	9081                	srli	s1,s1,0x20
 7e4:	04bd                	addi	s1,s1,15
 7e6:	8091                	srli	s1,s1,0x4
 7e8:	0014899b          	addiw	s3,s1,1
 7ec:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7ee:	00000517          	auipc	a0,0x0
 7f2:	16a53503          	ld	a0,362(a0) # 958 <freep>
 7f6:	c515                	beqz	a0,822 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7fa:	4798                	lw	a4,8(a5)
 7fc:	02977f63          	bgeu	a4,s1,83a <malloc+0x70>
 800:	8a4e                	mv	s4,s3
 802:	0009871b          	sext.w	a4,s3
 806:	6685                	lui	a3,0x1
 808:	00d77363          	bgeu	a4,a3,80e <malloc+0x44>
 80c:	6a05                	lui	s4,0x1
 80e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 812:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 816:	00000917          	auipc	s2,0x0
 81a:	14290913          	addi	s2,s2,322 # 958 <freep>
  if(p == (char*)-1)
 81e:	5afd                	li	s5,-1
 820:	a88d                	j	892 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 822:	00000797          	auipc	a5,0x0
 826:	13e78793          	addi	a5,a5,318 # 960 <base>
 82a:	00000717          	auipc	a4,0x0
 82e:	12f73723          	sd	a5,302(a4) # 958 <freep>
 832:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 834:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 838:	b7e1                	j	800 <malloc+0x36>
      if(p->s.size == nunits)
 83a:	02e48b63          	beq	s1,a4,870 <malloc+0xa6>
        p->s.size -= nunits;
 83e:	4137073b          	subw	a4,a4,s3
 842:	c798                	sw	a4,8(a5)
        p += p->s.size;
 844:	1702                	slli	a4,a4,0x20
 846:	9301                	srli	a4,a4,0x20
 848:	0712                	slli	a4,a4,0x4
 84a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 84c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 850:	00000717          	auipc	a4,0x0
 854:	10a73423          	sd	a0,264(a4) # 958 <freep>
      return (void*)(p + 1);
 858:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 85c:	70e2                	ld	ra,56(sp)
 85e:	7442                	ld	s0,48(sp)
 860:	74a2                	ld	s1,40(sp)
 862:	7902                	ld	s2,32(sp)
 864:	69e2                	ld	s3,24(sp)
 866:	6a42                	ld	s4,16(sp)
 868:	6aa2                	ld	s5,8(sp)
 86a:	6b02                	ld	s6,0(sp)
 86c:	6121                	addi	sp,sp,64
 86e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 870:	6398                	ld	a4,0(a5)
 872:	e118                	sd	a4,0(a0)
 874:	bff1                	j	850 <malloc+0x86>
  hp->s.size = nu;
 876:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 87a:	0541                	addi	a0,a0,16
 87c:	00000097          	auipc	ra,0x0
 880:	ec6080e7          	jalr	-314(ra) # 742 <free>
  return freep;
 884:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 888:	d971                	beqz	a0,85c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 88c:	4798                	lw	a4,8(a5)
 88e:	fa9776e3          	bgeu	a4,s1,83a <malloc+0x70>
    if(p == freep)
 892:	00093703          	ld	a4,0(s2)
 896:	853e                	mv	a0,a5
 898:	fef719e3          	bne	a4,a5,88a <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 89c:	8552                	mv	a0,s4
 89e:	00000097          	auipc	ra,0x0
 8a2:	b6e080e7          	jalr	-1170(ra) # 40c <sbrk>
  if(p == (char*)-1)
 8a6:	fd5518e3          	bne	a0,s5,876 <malloc+0xac>
        return 0;
 8aa:	4501                	li	a0,0
 8ac:	bf45                	j	85c <malloc+0x92>
