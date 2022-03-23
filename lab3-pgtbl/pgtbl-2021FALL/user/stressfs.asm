
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	8e278793          	addi	a5,a5,-1822 # 8f8 <malloc+0x11a>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	89c50513          	addi	a0,a0,-1892 # 8c8 <malloc+0xea>
  34:	00000097          	auipc	ra,0x0
  38:	6ec080e7          	jalr	1772(ra) # 720 <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	addi	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	136080e7          	jalr	310(ra) # 17e <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	00000097          	auipc	ra,0x0
  58:	33c080e7          	jalr	828(ra) # 390 <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for(i = 0; i < 4; i++)
  60:	2485                	addiw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	87850513          	addi	a0,a0,-1928 # 8e0 <malloc+0x102>
  70:	00000097          	auipc	ra,0x0
  74:	6b0080e7          	jalr	1712(ra) # 720 <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9cbd                	addw	s1,s1,a5
  7e:	fc940c23          	sb	s1,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	addi	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	34e080e7          	jalr	846(ra) # 3d8 <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	addi	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	318080e7          	jalr	792(ra) # 3b8 <write>
  for(i = 0; i < 20; i++)
  a8:	34fd                	addiw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	312080e7          	jalr	786(ra) # 3c0 <close>

  printf("read\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	83a50513          	addi	a0,a0,-1990 # 8f0 <malloc+0x112>
  be:	00000097          	auipc	ra,0x0
  c2:	662080e7          	jalr	1634(ra) # 720 <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	addi	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	30c080e7          	jalr	780(ra) # 3d8 <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	addi	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	2ce080e7          	jalr	718(ra) # 3b0 <read>
  for (i = 0; i < 20; i++)
  ea:	34fd                	addiw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	2d0080e7          	jalr	720(ra) # 3c0 <close>

  wait(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	2a6080e7          	jalr	678(ra) # 3a0 <wait>

  exit(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	294080e7          	jalr	660(ra) # 398 <exit>

000000000000010c <strcpy>:



char*
strcpy(char *s, const char *t)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 112:	87aa                	mv	a5,a0
 114:	0585                	addi	a1,a1,1
 116:	0785                	addi	a5,a5,1
 118:	fff5c703          	lbu	a4,-1(a1)
 11c:	fee78fa3          	sb	a4,-1(a5)
 120:	fb75                	bnez	a4,114 <strcpy+0x8>
    ;
  return os;
}
 122:	6422                	ld	s0,8(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret

0000000000000128 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e422                	sd	s0,8(sp)
 12c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cb91                	beqz	a5,146 <strcmp+0x1e>
 134:	0005c703          	lbu	a4,0(a1)
 138:	00f71763          	bne	a4,a5,146 <strcmp+0x1e>
    p++, q++;
 13c:	0505                	addi	a0,a0,1
 13e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	fbe5                	bnez	a5,134 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 146:	0005c503          	lbu	a0,0(a1)
}
 14a:	40a7853b          	subw	a0,a5,a0
 14e:	6422                	ld	s0,8(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret

0000000000000154 <strlen>:

uint
strlen(const char *s)
{
 154:	1141                	addi	sp,sp,-16
 156:	e422                	sd	s0,8(sp)
 158:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	cf91                	beqz	a5,17a <strlen+0x26>
 160:	0505                	addi	a0,a0,1
 162:	87aa                	mv	a5,a0
 164:	4685                	li	a3,1
 166:	9e89                	subw	a3,a3,a0
 168:	00f6853b          	addw	a0,a3,a5
 16c:	0785                	addi	a5,a5,1
 16e:	fff7c703          	lbu	a4,-1(a5)
 172:	fb7d                	bnez	a4,168 <strlen+0x14>
    ;
  return n;
}
 174:	6422                	ld	s0,8(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret
  for(n = 0; s[n]; n++)
 17a:	4501                	li	a0,0
 17c:	bfe5                	j	174 <strlen+0x20>

000000000000017e <memset>:

void*
memset(void *dst, int c, uint n)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 184:	ce09                	beqz	a2,19e <memset+0x20>
 186:	87aa                	mv	a5,a0
 188:	fff6071b          	addiw	a4,a2,-1
 18c:	1702                	slli	a4,a4,0x20
 18e:	9301                	srli	a4,a4,0x20
 190:	0705                	addi	a4,a4,1
 192:	972a                	add	a4,a4,a0
    cdst[i] = c;
 194:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 198:	0785                	addi	a5,a5,1
 19a:	fee79de3          	bne	a5,a4,194 <memset+0x16>
  }
  return dst;
}
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <strchr>:

char*
strchr(const char *s, char c)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	cb99                	beqz	a5,1c4 <strchr+0x20>
    if(*s == c)
 1b0:	00f58763          	beq	a1,a5,1be <strchr+0x1a>
  for(; *s; s++)
 1b4:	0505                	addi	a0,a0,1
 1b6:	00054783          	lbu	a5,0(a0)
 1ba:	fbfd                	bnez	a5,1b0 <strchr+0xc>
      return (char*)s;
  return 0;
 1bc:	4501                	li	a0,0
}
 1be:	6422                	ld	s0,8(sp)
 1c0:	0141                	addi	sp,sp,16
 1c2:	8082                	ret
  return 0;
 1c4:	4501                	li	a0,0
 1c6:	bfe5                	j	1be <strchr+0x1a>

00000000000001c8 <gets>:

char*
gets(char *buf, int max)
{
 1c8:	711d                	addi	sp,sp,-96
 1ca:	ec86                	sd	ra,88(sp)
 1cc:	e8a2                	sd	s0,80(sp)
 1ce:	e4a6                	sd	s1,72(sp)
 1d0:	e0ca                	sd	s2,64(sp)
 1d2:	fc4e                	sd	s3,56(sp)
 1d4:	f852                	sd	s4,48(sp)
 1d6:	f456                	sd	s5,40(sp)
 1d8:	f05a                	sd	s6,32(sp)
 1da:	ec5e                	sd	s7,24(sp)
 1dc:	1080                	addi	s0,sp,96
 1de:	8baa                	mv	s7,a0
 1e0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e2:	892a                	mv	s2,a0
 1e4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e6:	4aa9                	li	s5,10
 1e8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ea:	89a6                	mv	s3,s1
 1ec:	2485                	addiw	s1,s1,1
 1ee:	0344d863          	bge	s1,s4,21e <gets+0x56>
    cc = read(0, &c, 1);
 1f2:	4605                	li	a2,1
 1f4:	faf40593          	addi	a1,s0,-81
 1f8:	4501                	li	a0,0
 1fa:	00000097          	auipc	ra,0x0
 1fe:	1b6080e7          	jalr	438(ra) # 3b0 <read>
    if(cc < 1)
 202:	00a05e63          	blez	a0,21e <gets+0x56>
    buf[i++] = c;
 206:	faf44783          	lbu	a5,-81(s0)
 20a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 20e:	01578763          	beq	a5,s5,21c <gets+0x54>
 212:	0905                	addi	s2,s2,1
 214:	fd679be3          	bne	a5,s6,1ea <gets+0x22>
  for(i=0; i+1 < max; ){
 218:	89a6                	mv	s3,s1
 21a:	a011                	j	21e <gets+0x56>
 21c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 21e:	99de                	add	s3,s3,s7
 220:	00098023          	sb	zero,0(s3)
  return buf;
}
 224:	855e                	mv	a0,s7
 226:	60e6                	ld	ra,88(sp)
 228:	6446                	ld	s0,80(sp)
 22a:	64a6                	ld	s1,72(sp)
 22c:	6906                	ld	s2,64(sp)
 22e:	79e2                	ld	s3,56(sp)
 230:	7a42                	ld	s4,48(sp)
 232:	7aa2                	ld	s5,40(sp)
 234:	7b02                	ld	s6,32(sp)
 236:	6be2                	ld	s7,24(sp)
 238:	6125                	addi	sp,sp,96
 23a:	8082                	ret

000000000000023c <stat>:

int
stat(const char *n, struct stat *st)
{
 23c:	1101                	addi	sp,sp,-32
 23e:	ec06                	sd	ra,24(sp)
 240:	e822                	sd	s0,16(sp)
 242:	e426                	sd	s1,8(sp)
 244:	e04a                	sd	s2,0(sp)
 246:	1000                	addi	s0,sp,32
 248:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24a:	4581                	li	a1,0
 24c:	00000097          	auipc	ra,0x0
 250:	18c080e7          	jalr	396(ra) # 3d8 <open>
  if(fd < 0)
 254:	02054563          	bltz	a0,27e <stat+0x42>
 258:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 25a:	85ca                	mv	a1,s2
 25c:	00000097          	auipc	ra,0x0
 260:	194080e7          	jalr	404(ra) # 3f0 <fstat>
 264:	892a                	mv	s2,a0
  close(fd);
 266:	8526                	mv	a0,s1
 268:	00000097          	auipc	ra,0x0
 26c:	158080e7          	jalr	344(ra) # 3c0 <close>
  return r;
}
 270:	854a                	mv	a0,s2
 272:	60e2                	ld	ra,24(sp)
 274:	6442                	ld	s0,16(sp)
 276:	64a2                	ld	s1,8(sp)
 278:	6902                	ld	s2,0(sp)
 27a:	6105                	addi	sp,sp,32
 27c:	8082                	ret
    return -1;
 27e:	597d                	li	s2,-1
 280:	bfc5                	j	270 <stat+0x34>

0000000000000282 <atoi>:

int
atoi(const char *s)
{
 282:	1141                	addi	sp,sp,-16
 284:	e422                	sd	s0,8(sp)
 286:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 288:	00054603          	lbu	a2,0(a0)
 28c:	fd06079b          	addiw	a5,a2,-48
 290:	0ff7f793          	andi	a5,a5,255
 294:	4725                	li	a4,9
 296:	02f76963          	bltu	a4,a5,2c8 <atoi+0x46>
 29a:	86aa                	mv	a3,a0
  n = 0;
 29c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 29e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2a0:	0685                	addi	a3,a3,1
 2a2:	0025179b          	slliw	a5,a0,0x2
 2a6:	9fa9                	addw	a5,a5,a0
 2a8:	0017979b          	slliw	a5,a5,0x1
 2ac:	9fb1                	addw	a5,a5,a2
 2ae:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b2:	0006c603          	lbu	a2,0(a3)
 2b6:	fd06071b          	addiw	a4,a2,-48
 2ba:	0ff77713          	andi	a4,a4,255
 2be:	fee5f1e3          	bgeu	a1,a4,2a0 <atoi+0x1e>
  return n;
}
 2c2:	6422                	ld	s0,8(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
  n = 0;
 2c8:	4501                	li	a0,0
 2ca:	bfe5                	j	2c2 <atoi+0x40>

00000000000002cc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e422                	sd	s0,8(sp)
 2d0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d2:	02b57663          	bgeu	a0,a1,2fe <memmove+0x32>
    while(n-- > 0)
 2d6:	02c05163          	blez	a2,2f8 <memmove+0x2c>
 2da:	fff6079b          	addiw	a5,a2,-1
 2de:	1782                	slli	a5,a5,0x20
 2e0:	9381                	srli	a5,a5,0x20
 2e2:	0785                	addi	a5,a5,1
 2e4:	97aa                	add	a5,a5,a0
  dst = vdst;
 2e6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e8:	0585                	addi	a1,a1,1
 2ea:	0705                	addi	a4,a4,1
 2ec:	fff5c683          	lbu	a3,-1(a1)
 2f0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2f4:	fee79ae3          	bne	a5,a4,2e8 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f8:	6422                	ld	s0,8(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret
    dst += n;
 2fe:	00c50733          	add	a4,a0,a2
    src += n;
 302:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 304:	fec05ae3          	blez	a2,2f8 <memmove+0x2c>
 308:	fff6079b          	addiw	a5,a2,-1
 30c:	1782                	slli	a5,a5,0x20
 30e:	9381                	srli	a5,a5,0x20
 310:	fff7c793          	not	a5,a5
 314:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 316:	15fd                	addi	a1,a1,-1
 318:	177d                	addi	a4,a4,-1
 31a:	0005c683          	lbu	a3,0(a1)
 31e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 322:	fee79ae3          	bne	a5,a4,316 <memmove+0x4a>
 326:	bfc9                	j	2f8 <memmove+0x2c>

0000000000000328 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 328:	1141                	addi	sp,sp,-16
 32a:	e422                	sd	s0,8(sp)
 32c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 32e:	ca05                	beqz	a2,35e <memcmp+0x36>
 330:	fff6069b          	addiw	a3,a2,-1
 334:	1682                	slli	a3,a3,0x20
 336:	9281                	srli	a3,a3,0x20
 338:	0685                	addi	a3,a3,1
 33a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 33c:	00054783          	lbu	a5,0(a0)
 340:	0005c703          	lbu	a4,0(a1)
 344:	00e79863          	bne	a5,a4,354 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 348:	0505                	addi	a0,a0,1
    p2++;
 34a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 34c:	fed518e3          	bne	a0,a3,33c <memcmp+0x14>
  }
  return 0;
 350:	4501                	li	a0,0
 352:	a019                	j	358 <memcmp+0x30>
      return *p1 - *p2;
 354:	40e7853b          	subw	a0,a5,a4
}
 358:	6422                	ld	s0,8(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret
  return 0;
 35e:	4501                	li	a0,0
 360:	bfe5                	j	358 <memcmp+0x30>

0000000000000362 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 362:	1141                	addi	sp,sp,-16
 364:	e406                	sd	ra,8(sp)
 366:	e022                	sd	s0,0(sp)
 368:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 36a:	00000097          	auipc	ra,0x0
 36e:	f62080e7          	jalr	-158(ra) # 2cc <memmove>
}
 372:	60a2                	ld	ra,8(sp)
 374:	6402                	ld	s0,0(sp)
 376:	0141                	addi	sp,sp,16
 378:	8082                	ret

000000000000037a <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 37a:	1141                	addi	sp,sp,-16
 37c:	e422                	sd	s0,8(sp)
 37e:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 380:	040007b7          	lui	a5,0x4000
}
 384:	17f5                	addi	a5,a5,-3
 386:	07b2                	slli	a5,a5,0xc
 388:	4388                	lw	a0,0(a5)
 38a:	6422                	ld	s0,8(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret

0000000000000390 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 390:	4885                	li	a7,1
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <exit>:
.global exit
exit:
 li a7, SYS_exit
 398:	4889                	li	a7,2
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a0:	488d                	li	a7,3
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a8:	4891                	li	a7,4
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <read>:
.global read
read:
 li a7, SYS_read
 3b0:	4895                	li	a7,5
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <write>:
.global write
write:
 li a7, SYS_write
 3b8:	48c1                	li	a7,16
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <close>:
.global close
close:
 li a7, SYS_close
 3c0:	48d5                	li	a7,21
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c8:	4899                	li	a7,6
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d0:	489d                	li	a7,7
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <open>:
.global open
open:
 li a7, SYS_open
 3d8:	48bd                	li	a7,15
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e0:	48c5                	li	a7,17
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e8:	48c9                	li	a7,18
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f0:	48a1                	li	a7,8
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <link>:
.global link
link:
 li a7, SYS_link
 3f8:	48cd                	li	a7,19
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 400:	48d1                	li	a7,20
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 408:	48a5                	li	a7,9
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <dup>:
.global dup
dup:
 li a7, SYS_dup
 410:	48a9                	li	a7,10
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 418:	48ad                	li	a7,11
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 420:	48b1                	li	a7,12
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 428:	48b5                	li	a7,13
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 430:	48b9                	li	a7,14
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <connect>:
.global connect
connect:
 li a7, SYS_connect
 438:	48f5                	li	a7,29
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 440:	48f9                	li	a7,30
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 448:	1101                	addi	sp,sp,-32
 44a:	ec06                	sd	ra,24(sp)
 44c:	e822                	sd	s0,16(sp)
 44e:	1000                	addi	s0,sp,32
 450:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 454:	4605                	li	a2,1
 456:	fef40593          	addi	a1,s0,-17
 45a:	00000097          	auipc	ra,0x0
 45e:	f5e080e7          	jalr	-162(ra) # 3b8 <write>
}
 462:	60e2                	ld	ra,24(sp)
 464:	6442                	ld	s0,16(sp)
 466:	6105                	addi	sp,sp,32
 468:	8082                	ret

000000000000046a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 46a:	7139                	addi	sp,sp,-64
 46c:	fc06                	sd	ra,56(sp)
 46e:	f822                	sd	s0,48(sp)
 470:	f426                	sd	s1,40(sp)
 472:	f04a                	sd	s2,32(sp)
 474:	ec4e                	sd	s3,24(sp)
 476:	0080                	addi	s0,sp,64
 478:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 47a:	c299                	beqz	a3,480 <printint+0x16>
 47c:	0805c863          	bltz	a1,50c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 480:	2581                	sext.w	a1,a1
  neg = 0;
 482:	4881                	li	a7,0
 484:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 488:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 48a:	2601                	sext.w	a2,a2
 48c:	00000517          	auipc	a0,0x0
 490:	48450513          	addi	a0,a0,1156 # 910 <digits>
 494:	883a                	mv	a6,a4
 496:	2705                	addiw	a4,a4,1
 498:	02c5f7bb          	remuw	a5,a1,a2
 49c:	1782                	slli	a5,a5,0x20
 49e:	9381                	srli	a5,a5,0x20
 4a0:	97aa                	add	a5,a5,a0
 4a2:	0007c783          	lbu	a5,0(a5) # 4000000 <__global_pointer$+0x3ffeedf>
 4a6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4aa:	0005879b          	sext.w	a5,a1
 4ae:	02c5d5bb          	divuw	a1,a1,a2
 4b2:	0685                	addi	a3,a3,1
 4b4:	fec7f0e3          	bgeu	a5,a2,494 <printint+0x2a>
  if(neg)
 4b8:	00088b63          	beqz	a7,4ce <printint+0x64>
    buf[i++] = '-';
 4bc:	fd040793          	addi	a5,s0,-48
 4c0:	973e                	add	a4,a4,a5
 4c2:	02d00793          	li	a5,45
 4c6:	fef70823          	sb	a5,-16(a4)
 4ca:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4ce:	02e05863          	blez	a4,4fe <printint+0x94>
 4d2:	fc040793          	addi	a5,s0,-64
 4d6:	00e78933          	add	s2,a5,a4
 4da:	fff78993          	addi	s3,a5,-1
 4de:	99ba                	add	s3,s3,a4
 4e0:	377d                	addiw	a4,a4,-1
 4e2:	1702                	slli	a4,a4,0x20
 4e4:	9301                	srli	a4,a4,0x20
 4e6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ea:	fff94583          	lbu	a1,-1(s2)
 4ee:	8526                	mv	a0,s1
 4f0:	00000097          	auipc	ra,0x0
 4f4:	f58080e7          	jalr	-168(ra) # 448 <putc>
  while(--i >= 0)
 4f8:	197d                	addi	s2,s2,-1
 4fa:	ff3918e3          	bne	s2,s3,4ea <printint+0x80>
}
 4fe:	70e2                	ld	ra,56(sp)
 500:	7442                	ld	s0,48(sp)
 502:	74a2                	ld	s1,40(sp)
 504:	7902                	ld	s2,32(sp)
 506:	69e2                	ld	s3,24(sp)
 508:	6121                	addi	sp,sp,64
 50a:	8082                	ret
    x = -xx;
 50c:	40b005bb          	negw	a1,a1
    neg = 1;
 510:	4885                	li	a7,1
    x = -xx;
 512:	bf8d                	j	484 <printint+0x1a>

0000000000000514 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 514:	7119                	addi	sp,sp,-128
 516:	fc86                	sd	ra,120(sp)
 518:	f8a2                	sd	s0,112(sp)
 51a:	f4a6                	sd	s1,104(sp)
 51c:	f0ca                	sd	s2,96(sp)
 51e:	ecce                	sd	s3,88(sp)
 520:	e8d2                	sd	s4,80(sp)
 522:	e4d6                	sd	s5,72(sp)
 524:	e0da                	sd	s6,64(sp)
 526:	fc5e                	sd	s7,56(sp)
 528:	f862                	sd	s8,48(sp)
 52a:	f466                	sd	s9,40(sp)
 52c:	f06a                	sd	s10,32(sp)
 52e:	ec6e                	sd	s11,24(sp)
 530:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 532:	0005c903          	lbu	s2,0(a1)
 536:	18090f63          	beqz	s2,6d4 <vprintf+0x1c0>
 53a:	8aaa                	mv	s5,a0
 53c:	8b32                	mv	s6,a2
 53e:	00158493          	addi	s1,a1,1
  state = 0;
 542:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 544:	02500a13          	li	s4,37
      if(c == 'd'){
 548:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 54c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 550:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 554:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 558:	00000b97          	auipc	s7,0x0
 55c:	3b8b8b93          	addi	s7,s7,952 # 910 <digits>
 560:	a839                	j	57e <vprintf+0x6a>
        putc(fd, c);
 562:	85ca                	mv	a1,s2
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	ee2080e7          	jalr	-286(ra) # 448 <putc>
 56e:	a019                	j	574 <vprintf+0x60>
    } else if(state == '%'){
 570:	01498f63          	beq	s3,s4,58e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 574:	0485                	addi	s1,s1,1
 576:	fff4c903          	lbu	s2,-1(s1)
 57a:	14090d63          	beqz	s2,6d4 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 57e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 582:	fe0997e3          	bnez	s3,570 <vprintf+0x5c>
      if(c == '%'){
 586:	fd479ee3          	bne	a5,s4,562 <vprintf+0x4e>
        state = '%';
 58a:	89be                	mv	s3,a5
 58c:	b7e5                	j	574 <vprintf+0x60>
      if(c == 'd'){
 58e:	05878063          	beq	a5,s8,5ce <vprintf+0xba>
      } else if(c == 'l') {
 592:	05978c63          	beq	a5,s9,5ea <vprintf+0xd6>
      } else if(c == 'x') {
 596:	07a78863          	beq	a5,s10,606 <vprintf+0xf2>
      } else if(c == 'p') {
 59a:	09b78463          	beq	a5,s11,622 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 59e:	07300713          	li	a4,115
 5a2:	0ce78663          	beq	a5,a4,66e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5a6:	06300713          	li	a4,99
 5aa:	0ee78e63          	beq	a5,a4,6a6 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5ae:	11478863          	beq	a5,s4,6be <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5b2:	85d2                	mv	a1,s4
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	e92080e7          	jalr	-366(ra) # 448 <putc>
        putc(fd, c);
 5be:	85ca                	mv	a1,s2
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	e86080e7          	jalr	-378(ra) # 448 <putc>
      }
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	b765                	j	574 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5ce:	008b0913          	addi	s2,s6,8
 5d2:	4685                	li	a3,1
 5d4:	4629                	li	a2,10
 5d6:	000b2583          	lw	a1,0(s6)
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	e8e080e7          	jalr	-370(ra) # 46a <printint>
 5e4:	8b4a                	mv	s6,s2
      state = 0;
 5e6:	4981                	li	s3,0
 5e8:	b771                	j	574 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ea:	008b0913          	addi	s2,s6,8
 5ee:	4681                	li	a3,0
 5f0:	4629                	li	a2,10
 5f2:	000b2583          	lw	a1,0(s6)
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	e72080e7          	jalr	-398(ra) # 46a <printint>
 600:	8b4a                	mv	s6,s2
      state = 0;
 602:	4981                	li	s3,0
 604:	bf85                	j	574 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 606:	008b0913          	addi	s2,s6,8
 60a:	4681                	li	a3,0
 60c:	4641                	li	a2,16
 60e:	000b2583          	lw	a1,0(s6)
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	e56080e7          	jalr	-426(ra) # 46a <printint>
 61c:	8b4a                	mv	s6,s2
      state = 0;
 61e:	4981                	li	s3,0
 620:	bf91                	j	574 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 622:	008b0793          	addi	a5,s6,8
 626:	f8f43423          	sd	a5,-120(s0)
 62a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 62e:	03000593          	li	a1,48
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	e14080e7          	jalr	-492(ra) # 448 <putc>
  putc(fd, 'x');
 63c:	85ea                	mv	a1,s10
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	e08080e7          	jalr	-504(ra) # 448 <putc>
 648:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 64a:	03c9d793          	srli	a5,s3,0x3c
 64e:	97de                	add	a5,a5,s7
 650:	0007c583          	lbu	a1,0(a5)
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	df2080e7          	jalr	-526(ra) # 448 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 65e:	0992                	slli	s3,s3,0x4
 660:	397d                	addiw	s2,s2,-1
 662:	fe0914e3          	bnez	s2,64a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 666:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 66a:	4981                	li	s3,0
 66c:	b721                	j	574 <vprintf+0x60>
        s = va_arg(ap, char*);
 66e:	008b0993          	addi	s3,s6,8
 672:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 676:	02090163          	beqz	s2,698 <vprintf+0x184>
        while(*s != 0){
 67a:	00094583          	lbu	a1,0(s2)
 67e:	c9a1                	beqz	a1,6ce <vprintf+0x1ba>
          putc(fd, *s);
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	dc6080e7          	jalr	-570(ra) # 448 <putc>
          s++;
 68a:	0905                	addi	s2,s2,1
        while(*s != 0){
 68c:	00094583          	lbu	a1,0(s2)
 690:	f9e5                	bnez	a1,680 <vprintf+0x16c>
        s = va_arg(ap, char*);
 692:	8b4e                	mv	s6,s3
      state = 0;
 694:	4981                	li	s3,0
 696:	bdf9                	j	574 <vprintf+0x60>
          s = "(null)";
 698:	00000917          	auipc	s2,0x0
 69c:	27090913          	addi	s2,s2,624 # 908 <malloc+0x12a>
        while(*s != 0){
 6a0:	02800593          	li	a1,40
 6a4:	bff1                	j	680 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6a6:	008b0913          	addi	s2,s6,8
 6aa:	000b4583          	lbu	a1,0(s6)
 6ae:	8556                	mv	a0,s5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	d98080e7          	jalr	-616(ra) # 448 <putc>
 6b8:	8b4a                	mv	s6,s2
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	bd65                	j	574 <vprintf+0x60>
        putc(fd, c);
 6be:	85d2                	mv	a1,s4
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	d86080e7          	jalr	-634(ra) # 448 <putc>
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	b565                	j	574 <vprintf+0x60>
        s = va_arg(ap, char*);
 6ce:	8b4e                	mv	s6,s3
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	b54d                	j	574 <vprintf+0x60>
    }
  }
}
 6d4:	70e6                	ld	ra,120(sp)
 6d6:	7446                	ld	s0,112(sp)
 6d8:	74a6                	ld	s1,104(sp)
 6da:	7906                	ld	s2,96(sp)
 6dc:	69e6                	ld	s3,88(sp)
 6de:	6a46                	ld	s4,80(sp)
 6e0:	6aa6                	ld	s5,72(sp)
 6e2:	6b06                	ld	s6,64(sp)
 6e4:	7be2                	ld	s7,56(sp)
 6e6:	7c42                	ld	s8,48(sp)
 6e8:	7ca2                	ld	s9,40(sp)
 6ea:	7d02                	ld	s10,32(sp)
 6ec:	6de2                	ld	s11,24(sp)
 6ee:	6109                	addi	sp,sp,128
 6f0:	8082                	ret

00000000000006f2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f2:	715d                	addi	sp,sp,-80
 6f4:	ec06                	sd	ra,24(sp)
 6f6:	e822                	sd	s0,16(sp)
 6f8:	1000                	addi	s0,sp,32
 6fa:	e010                	sd	a2,0(s0)
 6fc:	e414                	sd	a3,8(s0)
 6fe:	e818                	sd	a4,16(s0)
 700:	ec1c                	sd	a5,24(s0)
 702:	03043023          	sd	a6,32(s0)
 706:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 70a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 70e:	8622                	mv	a2,s0
 710:	00000097          	auipc	ra,0x0
 714:	e04080e7          	jalr	-508(ra) # 514 <vprintf>
}
 718:	60e2                	ld	ra,24(sp)
 71a:	6442                	ld	s0,16(sp)
 71c:	6161                	addi	sp,sp,80
 71e:	8082                	ret

0000000000000720 <printf>:

void
printf(const char *fmt, ...)
{
 720:	711d                	addi	sp,sp,-96
 722:	ec06                	sd	ra,24(sp)
 724:	e822                	sd	s0,16(sp)
 726:	1000                	addi	s0,sp,32
 728:	e40c                	sd	a1,8(s0)
 72a:	e810                	sd	a2,16(s0)
 72c:	ec14                	sd	a3,24(s0)
 72e:	f018                	sd	a4,32(s0)
 730:	f41c                	sd	a5,40(s0)
 732:	03043823          	sd	a6,48(s0)
 736:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 73a:	00840613          	addi	a2,s0,8
 73e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 742:	85aa                	mv	a1,a0
 744:	4505                	li	a0,1
 746:	00000097          	auipc	ra,0x0
 74a:	dce080e7          	jalr	-562(ra) # 514 <vprintf>
}
 74e:	60e2                	ld	ra,24(sp)
 750:	6442                	ld	s0,16(sp)
 752:	6125                	addi	sp,sp,96
 754:	8082                	ret

0000000000000756 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 756:	1141                	addi	sp,sp,-16
 758:	e422                	sd	s0,8(sp)
 75a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 760:	00000797          	auipc	a5,0x0
 764:	1c87b783          	ld	a5,456(a5) # 928 <freep>
 768:	a805                	j	798 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 76a:	4618                	lw	a4,8(a2)
 76c:	9db9                	addw	a1,a1,a4
 76e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 772:	6398                	ld	a4,0(a5)
 774:	6318                	ld	a4,0(a4)
 776:	fee53823          	sd	a4,-16(a0)
 77a:	a091                	j	7be <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 77c:	ff852703          	lw	a4,-8(a0)
 780:	9e39                	addw	a2,a2,a4
 782:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 784:	ff053703          	ld	a4,-16(a0)
 788:	e398                	sd	a4,0(a5)
 78a:	a099                	j	7d0 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78c:	6398                	ld	a4,0(a5)
 78e:	00e7e463          	bltu	a5,a4,796 <free+0x40>
 792:	00e6ea63          	bltu	a3,a4,7a6 <free+0x50>
{
 796:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 798:	fed7fae3          	bgeu	a5,a3,78c <free+0x36>
 79c:	6398                	ld	a4,0(a5)
 79e:	00e6e463          	bltu	a3,a4,7a6 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a2:	fee7eae3          	bltu	a5,a4,796 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7a6:	ff852583          	lw	a1,-8(a0)
 7aa:	6390                	ld	a2,0(a5)
 7ac:	02059713          	slli	a4,a1,0x20
 7b0:	9301                	srli	a4,a4,0x20
 7b2:	0712                	slli	a4,a4,0x4
 7b4:	9736                	add	a4,a4,a3
 7b6:	fae60ae3          	beq	a2,a4,76a <free+0x14>
    bp->s.ptr = p->s.ptr;
 7ba:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7be:	4790                	lw	a2,8(a5)
 7c0:	02061713          	slli	a4,a2,0x20
 7c4:	9301                	srli	a4,a4,0x20
 7c6:	0712                	slli	a4,a4,0x4
 7c8:	973e                	add	a4,a4,a5
 7ca:	fae689e3          	beq	a3,a4,77c <free+0x26>
  } else
    p->s.ptr = bp;
 7ce:	e394                	sd	a3,0(a5)
  freep = p;
 7d0:	00000717          	auipc	a4,0x0
 7d4:	14f73c23          	sd	a5,344(a4) # 928 <freep>
}
 7d8:	6422                	ld	s0,8(sp)
 7da:	0141                	addi	sp,sp,16
 7dc:	8082                	ret

00000000000007de <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7de:	7139                	addi	sp,sp,-64
 7e0:	fc06                	sd	ra,56(sp)
 7e2:	f822                	sd	s0,48(sp)
 7e4:	f426                	sd	s1,40(sp)
 7e6:	f04a                	sd	s2,32(sp)
 7e8:	ec4e                	sd	s3,24(sp)
 7ea:	e852                	sd	s4,16(sp)
 7ec:	e456                	sd	s5,8(sp)
 7ee:	e05a                	sd	s6,0(sp)
 7f0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f2:	02051493          	slli	s1,a0,0x20
 7f6:	9081                	srli	s1,s1,0x20
 7f8:	04bd                	addi	s1,s1,15
 7fa:	8091                	srli	s1,s1,0x4
 7fc:	0014899b          	addiw	s3,s1,1
 800:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 802:	00000517          	auipc	a0,0x0
 806:	12653503          	ld	a0,294(a0) # 928 <freep>
 80a:	c515                	beqz	a0,836 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80e:	4798                	lw	a4,8(a5)
 810:	02977f63          	bgeu	a4,s1,84e <malloc+0x70>
 814:	8a4e                	mv	s4,s3
 816:	0009871b          	sext.w	a4,s3
 81a:	6685                	lui	a3,0x1
 81c:	00d77363          	bgeu	a4,a3,822 <malloc+0x44>
 820:	6a05                	lui	s4,0x1
 822:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 826:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 82a:	00000917          	auipc	s2,0x0
 82e:	0fe90913          	addi	s2,s2,254 # 928 <freep>
  if(p == (char*)-1)
 832:	5afd                	li	s5,-1
 834:	a88d                	j	8a6 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 836:	00000797          	auipc	a5,0x0
 83a:	0fa78793          	addi	a5,a5,250 # 930 <base>
 83e:	00000717          	auipc	a4,0x0
 842:	0ef73523          	sd	a5,234(a4) # 928 <freep>
 846:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 848:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 84c:	b7e1                	j	814 <malloc+0x36>
      if(p->s.size == nunits)
 84e:	02e48b63          	beq	s1,a4,884 <malloc+0xa6>
        p->s.size -= nunits;
 852:	4137073b          	subw	a4,a4,s3
 856:	c798                	sw	a4,8(a5)
        p += p->s.size;
 858:	1702                	slli	a4,a4,0x20
 85a:	9301                	srli	a4,a4,0x20
 85c:	0712                	slli	a4,a4,0x4
 85e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 860:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 864:	00000717          	auipc	a4,0x0
 868:	0ca73223          	sd	a0,196(a4) # 928 <freep>
      return (void*)(p + 1);
 86c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 870:	70e2                	ld	ra,56(sp)
 872:	7442                	ld	s0,48(sp)
 874:	74a2                	ld	s1,40(sp)
 876:	7902                	ld	s2,32(sp)
 878:	69e2                	ld	s3,24(sp)
 87a:	6a42                	ld	s4,16(sp)
 87c:	6aa2                	ld	s5,8(sp)
 87e:	6b02                	ld	s6,0(sp)
 880:	6121                	addi	sp,sp,64
 882:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 884:	6398                	ld	a4,0(a5)
 886:	e118                	sd	a4,0(a0)
 888:	bff1                	j	864 <malloc+0x86>
  hp->s.size = nu;
 88a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 88e:	0541                	addi	a0,a0,16
 890:	00000097          	auipc	ra,0x0
 894:	ec6080e7          	jalr	-314(ra) # 756 <free>
  return freep;
 898:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 89c:	d971                	beqz	a0,870 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a0:	4798                	lw	a4,8(a5)
 8a2:	fa9776e3          	bgeu	a4,s1,84e <malloc+0x70>
    if(p == freep)
 8a6:	00093703          	ld	a4,0(s2)
 8aa:	853e                	mv	a0,a5
 8ac:	fef719e3          	bne	a4,a5,89e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8b0:	8552                	mv	a0,s4
 8b2:	00000097          	auipc	ra,0x0
 8b6:	b6e080e7          	jalr	-1170(ra) # 420 <sbrk>
  if(p == (char*)-1)
 8ba:	fd5518e3          	bne	a0,s5,88a <malloc+0xac>
        return 0;
 8be:	4501                	li	a0,0
 8c0:	bf45                	j	870 <malloc+0x92>
