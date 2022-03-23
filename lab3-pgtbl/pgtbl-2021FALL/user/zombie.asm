
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	2a6080e7          	jalr	678(ra) # 2ae <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	2a0080e7          	jalr	672(ra) # 2b6 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	326080e7          	jalr	806(ra) # 346 <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <strcpy>:



char*
strcpy(char *s, const char *t)
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e422                	sd	s0,8(sp)
  2e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  30:	87aa                	mv	a5,a0
  32:	0585                	addi	a1,a1,1
  34:	0785                	addi	a5,a5,1
  36:	fff5c703          	lbu	a4,-1(a1)
  3a:	fee78fa3          	sb	a4,-1(a5)
  3e:	fb75                	bnez	a4,32 <strcpy+0x8>
    ;
  return os;
}
  40:	6422                	ld	s0,8(sp)
  42:	0141                	addi	sp,sp,16
  44:	8082                	ret

0000000000000046 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  46:	1141                	addi	sp,sp,-16
  48:	e422                	sd	s0,8(sp)
  4a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4c:	00054783          	lbu	a5,0(a0)
  50:	cb91                	beqz	a5,64 <strcmp+0x1e>
  52:	0005c703          	lbu	a4,0(a1)
  56:	00f71763          	bne	a4,a5,64 <strcmp+0x1e>
    p++, q++;
  5a:	0505                	addi	a0,a0,1
  5c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	fbe5                	bnez	a5,52 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  64:	0005c503          	lbu	a0,0(a1)
}
  68:	40a7853b          	subw	a0,a5,a0
  6c:	6422                	ld	s0,8(sp)
  6e:	0141                	addi	sp,sp,16
  70:	8082                	ret

0000000000000072 <strlen>:

uint
strlen(const char *s)
{
  72:	1141                	addi	sp,sp,-16
  74:	e422                	sd	s0,8(sp)
  76:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  78:	00054783          	lbu	a5,0(a0)
  7c:	cf91                	beqz	a5,98 <strlen+0x26>
  7e:	0505                	addi	a0,a0,1
  80:	87aa                	mv	a5,a0
  82:	4685                	li	a3,1
  84:	9e89                	subw	a3,a3,a0
  86:	00f6853b          	addw	a0,a3,a5
  8a:	0785                	addi	a5,a5,1
  8c:	fff7c703          	lbu	a4,-1(a5)
  90:	fb7d                	bnez	a4,86 <strlen+0x14>
    ;
  return n;
}
  92:	6422                	ld	s0,8(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret
  for(n = 0; s[n]; n++)
  98:	4501                	li	a0,0
  9a:	bfe5                	j	92 <strlen+0x20>

000000000000009c <memset>:

void*
memset(void *dst, int c, uint n)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a2:	ce09                	beqz	a2,bc <memset+0x20>
  a4:	87aa                	mv	a5,a0
  a6:	fff6071b          	addiw	a4,a2,-1
  aa:	1702                	slli	a4,a4,0x20
  ac:	9301                	srli	a4,a4,0x20
  ae:	0705                	addi	a4,a4,1
  b0:	972a                	add	a4,a4,a0
    cdst[i] = c;
  b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b6:	0785                	addi	a5,a5,1
  b8:	fee79de3          	bne	a5,a4,b2 <memset+0x16>
  }
  return dst;
}
  bc:	6422                	ld	s0,8(sp)
  be:	0141                	addi	sp,sp,16
  c0:	8082                	ret

00000000000000c2 <strchr>:

char*
strchr(const char *s, char c)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e422                	sd	s0,8(sp)
  c6:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	cb99                	beqz	a5,e2 <strchr+0x20>
    if(*s == c)
  ce:	00f58763          	beq	a1,a5,dc <strchr+0x1a>
  for(; *s; s++)
  d2:	0505                	addi	a0,a0,1
  d4:	00054783          	lbu	a5,0(a0)
  d8:	fbfd                	bnez	a5,ce <strchr+0xc>
      return (char*)s;
  return 0;
  da:	4501                	li	a0,0
}
  dc:	6422                	ld	s0,8(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret
  return 0;
  e2:	4501                	li	a0,0
  e4:	bfe5                	j	dc <strchr+0x1a>

00000000000000e6 <gets>:

char*
gets(char *buf, int max)
{
  e6:	711d                	addi	sp,sp,-96
  e8:	ec86                	sd	ra,88(sp)
  ea:	e8a2                	sd	s0,80(sp)
  ec:	e4a6                	sd	s1,72(sp)
  ee:	e0ca                	sd	s2,64(sp)
  f0:	fc4e                	sd	s3,56(sp)
  f2:	f852                	sd	s4,48(sp)
  f4:	f456                	sd	s5,40(sp)
  f6:	f05a                	sd	s6,32(sp)
  f8:	ec5e                	sd	s7,24(sp)
  fa:	1080                	addi	s0,sp,96
  fc:	8baa                	mv	s7,a0
  fe:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 100:	892a                	mv	s2,a0
 102:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 104:	4aa9                	li	s5,10
 106:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 108:	89a6                	mv	s3,s1
 10a:	2485                	addiw	s1,s1,1
 10c:	0344d863          	bge	s1,s4,13c <gets+0x56>
    cc = read(0, &c, 1);
 110:	4605                	li	a2,1
 112:	faf40593          	addi	a1,s0,-81
 116:	4501                	li	a0,0
 118:	00000097          	auipc	ra,0x0
 11c:	1b6080e7          	jalr	438(ra) # 2ce <read>
    if(cc < 1)
 120:	00a05e63          	blez	a0,13c <gets+0x56>
    buf[i++] = c;
 124:	faf44783          	lbu	a5,-81(s0)
 128:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12c:	01578763          	beq	a5,s5,13a <gets+0x54>
 130:	0905                	addi	s2,s2,1
 132:	fd679be3          	bne	a5,s6,108 <gets+0x22>
  for(i=0; i+1 < max; ){
 136:	89a6                	mv	s3,s1
 138:	a011                	j	13c <gets+0x56>
 13a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13c:	99de                	add	s3,s3,s7
 13e:	00098023          	sb	zero,0(s3)
  return buf;
}
 142:	855e                	mv	a0,s7
 144:	60e6                	ld	ra,88(sp)
 146:	6446                	ld	s0,80(sp)
 148:	64a6                	ld	s1,72(sp)
 14a:	6906                	ld	s2,64(sp)
 14c:	79e2                	ld	s3,56(sp)
 14e:	7a42                	ld	s4,48(sp)
 150:	7aa2                	ld	s5,40(sp)
 152:	7b02                	ld	s6,32(sp)
 154:	6be2                	ld	s7,24(sp)
 156:	6125                	addi	sp,sp,96
 158:	8082                	ret

000000000000015a <stat>:

int
stat(const char *n, struct stat *st)
{
 15a:	1101                	addi	sp,sp,-32
 15c:	ec06                	sd	ra,24(sp)
 15e:	e822                	sd	s0,16(sp)
 160:	e426                	sd	s1,8(sp)
 162:	e04a                	sd	s2,0(sp)
 164:	1000                	addi	s0,sp,32
 166:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 168:	4581                	li	a1,0
 16a:	00000097          	auipc	ra,0x0
 16e:	18c080e7          	jalr	396(ra) # 2f6 <open>
  if(fd < 0)
 172:	02054563          	bltz	a0,19c <stat+0x42>
 176:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 178:	85ca                	mv	a1,s2
 17a:	00000097          	auipc	ra,0x0
 17e:	194080e7          	jalr	404(ra) # 30e <fstat>
 182:	892a                	mv	s2,a0
  close(fd);
 184:	8526                	mv	a0,s1
 186:	00000097          	auipc	ra,0x0
 18a:	158080e7          	jalr	344(ra) # 2de <close>
  return r;
}
 18e:	854a                	mv	a0,s2
 190:	60e2                	ld	ra,24(sp)
 192:	6442                	ld	s0,16(sp)
 194:	64a2                	ld	s1,8(sp)
 196:	6902                	ld	s2,0(sp)
 198:	6105                	addi	sp,sp,32
 19a:	8082                	ret
    return -1;
 19c:	597d                	li	s2,-1
 19e:	bfc5                	j	18e <stat+0x34>

00000000000001a0 <atoi>:

int
atoi(const char *s)
{
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e422                	sd	s0,8(sp)
 1a4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a6:	00054603          	lbu	a2,0(a0)
 1aa:	fd06079b          	addiw	a5,a2,-48
 1ae:	0ff7f793          	andi	a5,a5,255
 1b2:	4725                	li	a4,9
 1b4:	02f76963          	bltu	a4,a5,1e6 <atoi+0x46>
 1b8:	86aa                	mv	a3,a0
  n = 0;
 1ba:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1bc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1be:	0685                	addi	a3,a3,1
 1c0:	0025179b          	slliw	a5,a0,0x2
 1c4:	9fa9                	addw	a5,a5,a0
 1c6:	0017979b          	slliw	a5,a5,0x1
 1ca:	9fb1                	addw	a5,a5,a2
 1cc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1d0:	0006c603          	lbu	a2,0(a3)
 1d4:	fd06071b          	addiw	a4,a2,-48
 1d8:	0ff77713          	andi	a4,a4,255
 1dc:	fee5f1e3          	bgeu	a1,a4,1be <atoi+0x1e>
  return n;
}
 1e0:	6422                	ld	s0,8(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret
  n = 0;
 1e6:	4501                	li	a0,0
 1e8:	bfe5                	j	1e0 <atoi+0x40>

00000000000001ea <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e422                	sd	s0,8(sp)
 1ee:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f0:	02b57663          	bgeu	a0,a1,21c <memmove+0x32>
    while(n-- > 0)
 1f4:	02c05163          	blez	a2,216 <memmove+0x2c>
 1f8:	fff6079b          	addiw	a5,a2,-1
 1fc:	1782                	slli	a5,a5,0x20
 1fe:	9381                	srli	a5,a5,0x20
 200:	0785                	addi	a5,a5,1
 202:	97aa                	add	a5,a5,a0
  dst = vdst;
 204:	872a                	mv	a4,a0
      *dst++ = *src++;
 206:	0585                	addi	a1,a1,1
 208:	0705                	addi	a4,a4,1
 20a:	fff5c683          	lbu	a3,-1(a1)
 20e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 212:	fee79ae3          	bne	a5,a4,206 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 216:	6422                	ld	s0,8(sp)
 218:	0141                	addi	sp,sp,16
 21a:	8082                	ret
    dst += n;
 21c:	00c50733          	add	a4,a0,a2
    src += n;
 220:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 222:	fec05ae3          	blez	a2,216 <memmove+0x2c>
 226:	fff6079b          	addiw	a5,a2,-1
 22a:	1782                	slli	a5,a5,0x20
 22c:	9381                	srli	a5,a5,0x20
 22e:	fff7c793          	not	a5,a5
 232:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 234:	15fd                	addi	a1,a1,-1
 236:	177d                	addi	a4,a4,-1
 238:	0005c683          	lbu	a3,0(a1)
 23c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 240:	fee79ae3          	bne	a5,a4,234 <memmove+0x4a>
 244:	bfc9                	j	216 <memmove+0x2c>

0000000000000246 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 246:	1141                	addi	sp,sp,-16
 248:	e422                	sd	s0,8(sp)
 24a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 24c:	ca05                	beqz	a2,27c <memcmp+0x36>
 24e:	fff6069b          	addiw	a3,a2,-1
 252:	1682                	slli	a3,a3,0x20
 254:	9281                	srli	a3,a3,0x20
 256:	0685                	addi	a3,a3,1
 258:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 25a:	00054783          	lbu	a5,0(a0)
 25e:	0005c703          	lbu	a4,0(a1)
 262:	00e79863          	bne	a5,a4,272 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 266:	0505                	addi	a0,a0,1
    p2++;
 268:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 26a:	fed518e3          	bne	a0,a3,25a <memcmp+0x14>
  }
  return 0;
 26e:	4501                	li	a0,0
 270:	a019                	j	276 <memcmp+0x30>
      return *p1 - *p2;
 272:	40e7853b          	subw	a0,a5,a4
}
 276:	6422                	ld	s0,8(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
  return 0;
 27c:	4501                	li	a0,0
 27e:	bfe5                	j	276 <memcmp+0x30>

0000000000000280 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 288:	00000097          	auipc	ra,0x0
 28c:	f62080e7          	jalr	-158(ra) # 1ea <memmove>
}
 290:	60a2                	ld	ra,8(sp)
 292:	6402                	ld	s0,0(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret

0000000000000298 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 29e:	040007b7          	lui	a5,0x4000
}
 2a2:	17f5                	addi	a5,a5,-3
 2a4:	07b2                	slli	a5,a5,0xc
 2a6:	4388                	lw	a0,0(a5)
 2a8:	6422                	ld	s0,8(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret

00000000000002ae <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ae:	4885                	li	a7,1
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b6:	4889                	li	a7,2
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <wait>:
.global wait
wait:
 li a7, SYS_wait
 2be:	488d                	li	a7,3
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c6:	4891                	li	a7,4
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <read>:
.global read
read:
 li a7, SYS_read
 2ce:	4895                	li	a7,5
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <write>:
.global write
write:
 li a7, SYS_write
 2d6:	48c1                	li	a7,16
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <close>:
.global close
close:
 li a7, SYS_close
 2de:	48d5                	li	a7,21
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e6:	4899                	li	a7,6
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <exec>:
.global exec
exec:
 li a7, SYS_exec
 2ee:	489d                	li	a7,7
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <open>:
.global open
open:
 li a7, SYS_open
 2f6:	48bd                	li	a7,15
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2fe:	48c5                	li	a7,17
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 306:	48c9                	li	a7,18
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 30e:	48a1                	li	a7,8
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <link>:
.global link
link:
 li a7, SYS_link
 316:	48cd                	li	a7,19
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 31e:	48d1                	li	a7,20
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 326:	48a5                	li	a7,9
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <dup>:
.global dup
dup:
 li a7, SYS_dup
 32e:	48a9                	li	a7,10
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 336:	48ad                	li	a7,11
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 33e:	48b1                	li	a7,12
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 346:	48b5                	li	a7,13
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 34e:	48b9                	li	a7,14
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <connect>:
.global connect
connect:
 li a7, SYS_connect
 356:	48f5                	li	a7,29
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 35e:	48f9                	li	a7,30
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 366:	1101                	addi	sp,sp,-32
 368:	ec06                	sd	ra,24(sp)
 36a:	e822                	sd	s0,16(sp)
 36c:	1000                	addi	s0,sp,32
 36e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 372:	4605                	li	a2,1
 374:	fef40593          	addi	a1,s0,-17
 378:	00000097          	auipc	ra,0x0
 37c:	f5e080e7          	jalr	-162(ra) # 2d6 <write>
}
 380:	60e2                	ld	ra,24(sp)
 382:	6442                	ld	s0,16(sp)
 384:	6105                	addi	sp,sp,32
 386:	8082                	ret

0000000000000388 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 388:	7139                	addi	sp,sp,-64
 38a:	fc06                	sd	ra,56(sp)
 38c:	f822                	sd	s0,48(sp)
 38e:	f426                	sd	s1,40(sp)
 390:	f04a                	sd	s2,32(sp)
 392:	ec4e                	sd	s3,24(sp)
 394:	0080                	addi	s0,sp,64
 396:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 398:	c299                	beqz	a3,39e <printint+0x16>
 39a:	0805c863          	bltz	a1,42a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 39e:	2581                	sext.w	a1,a1
  neg = 0;
 3a0:	4881                	li	a7,0
 3a2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3a6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a8:	2601                	sext.w	a2,a2
 3aa:	00000517          	auipc	a0,0x0
 3ae:	43e50513          	addi	a0,a0,1086 # 7e8 <digits>
 3b2:	883a                	mv	a6,a4
 3b4:	2705                	addiw	a4,a4,1
 3b6:	02c5f7bb          	remuw	a5,a1,a2
 3ba:	1782                	slli	a5,a5,0x20
 3bc:	9381                	srli	a5,a5,0x20
 3be:	97aa                	add	a5,a5,a0
 3c0:	0007c783          	lbu	a5,0(a5) # 4000000 <__global_pointer$+0x3fff007>
 3c4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c8:	0005879b          	sext.w	a5,a1
 3cc:	02c5d5bb          	divuw	a1,a1,a2
 3d0:	0685                	addi	a3,a3,1
 3d2:	fec7f0e3          	bgeu	a5,a2,3b2 <printint+0x2a>
  if(neg)
 3d6:	00088b63          	beqz	a7,3ec <printint+0x64>
    buf[i++] = '-';
 3da:	fd040793          	addi	a5,s0,-48
 3de:	973e                	add	a4,a4,a5
 3e0:	02d00793          	li	a5,45
 3e4:	fef70823          	sb	a5,-16(a4)
 3e8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3ec:	02e05863          	blez	a4,41c <printint+0x94>
 3f0:	fc040793          	addi	a5,s0,-64
 3f4:	00e78933          	add	s2,a5,a4
 3f8:	fff78993          	addi	s3,a5,-1
 3fc:	99ba                	add	s3,s3,a4
 3fe:	377d                	addiw	a4,a4,-1
 400:	1702                	slli	a4,a4,0x20
 402:	9301                	srli	a4,a4,0x20
 404:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 408:	fff94583          	lbu	a1,-1(s2)
 40c:	8526                	mv	a0,s1
 40e:	00000097          	auipc	ra,0x0
 412:	f58080e7          	jalr	-168(ra) # 366 <putc>
  while(--i >= 0)
 416:	197d                	addi	s2,s2,-1
 418:	ff3918e3          	bne	s2,s3,408 <printint+0x80>
}
 41c:	70e2                	ld	ra,56(sp)
 41e:	7442                	ld	s0,48(sp)
 420:	74a2                	ld	s1,40(sp)
 422:	7902                	ld	s2,32(sp)
 424:	69e2                	ld	s3,24(sp)
 426:	6121                	addi	sp,sp,64
 428:	8082                	ret
    x = -xx;
 42a:	40b005bb          	negw	a1,a1
    neg = 1;
 42e:	4885                	li	a7,1
    x = -xx;
 430:	bf8d                	j	3a2 <printint+0x1a>

0000000000000432 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 432:	7119                	addi	sp,sp,-128
 434:	fc86                	sd	ra,120(sp)
 436:	f8a2                	sd	s0,112(sp)
 438:	f4a6                	sd	s1,104(sp)
 43a:	f0ca                	sd	s2,96(sp)
 43c:	ecce                	sd	s3,88(sp)
 43e:	e8d2                	sd	s4,80(sp)
 440:	e4d6                	sd	s5,72(sp)
 442:	e0da                	sd	s6,64(sp)
 444:	fc5e                	sd	s7,56(sp)
 446:	f862                	sd	s8,48(sp)
 448:	f466                	sd	s9,40(sp)
 44a:	f06a                	sd	s10,32(sp)
 44c:	ec6e                	sd	s11,24(sp)
 44e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 450:	0005c903          	lbu	s2,0(a1)
 454:	18090f63          	beqz	s2,5f2 <vprintf+0x1c0>
 458:	8aaa                	mv	s5,a0
 45a:	8b32                	mv	s6,a2
 45c:	00158493          	addi	s1,a1,1
  state = 0;
 460:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 462:	02500a13          	li	s4,37
      if(c == 'd'){
 466:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 46a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 46e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 472:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 476:	00000b97          	auipc	s7,0x0
 47a:	372b8b93          	addi	s7,s7,882 # 7e8 <digits>
 47e:	a839                	j	49c <vprintf+0x6a>
        putc(fd, c);
 480:	85ca                	mv	a1,s2
 482:	8556                	mv	a0,s5
 484:	00000097          	auipc	ra,0x0
 488:	ee2080e7          	jalr	-286(ra) # 366 <putc>
 48c:	a019                	j	492 <vprintf+0x60>
    } else if(state == '%'){
 48e:	01498f63          	beq	s3,s4,4ac <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 492:	0485                	addi	s1,s1,1
 494:	fff4c903          	lbu	s2,-1(s1)
 498:	14090d63          	beqz	s2,5f2 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 49c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4a0:	fe0997e3          	bnez	s3,48e <vprintf+0x5c>
      if(c == '%'){
 4a4:	fd479ee3          	bne	a5,s4,480 <vprintf+0x4e>
        state = '%';
 4a8:	89be                	mv	s3,a5
 4aa:	b7e5                	j	492 <vprintf+0x60>
      if(c == 'd'){
 4ac:	05878063          	beq	a5,s8,4ec <vprintf+0xba>
      } else if(c == 'l') {
 4b0:	05978c63          	beq	a5,s9,508 <vprintf+0xd6>
      } else if(c == 'x') {
 4b4:	07a78863          	beq	a5,s10,524 <vprintf+0xf2>
      } else if(c == 'p') {
 4b8:	09b78463          	beq	a5,s11,540 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4bc:	07300713          	li	a4,115
 4c0:	0ce78663          	beq	a5,a4,58c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4c4:	06300713          	li	a4,99
 4c8:	0ee78e63          	beq	a5,a4,5c4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4cc:	11478863          	beq	a5,s4,5dc <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4d0:	85d2                	mv	a1,s4
 4d2:	8556                	mv	a0,s5
 4d4:	00000097          	auipc	ra,0x0
 4d8:	e92080e7          	jalr	-366(ra) # 366 <putc>
        putc(fd, c);
 4dc:	85ca                	mv	a1,s2
 4de:	8556                	mv	a0,s5
 4e0:	00000097          	auipc	ra,0x0
 4e4:	e86080e7          	jalr	-378(ra) # 366 <putc>
      }
      state = 0;
 4e8:	4981                	li	s3,0
 4ea:	b765                	j	492 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 4ec:	008b0913          	addi	s2,s6,8
 4f0:	4685                	li	a3,1
 4f2:	4629                	li	a2,10
 4f4:	000b2583          	lw	a1,0(s6)
 4f8:	8556                	mv	a0,s5
 4fa:	00000097          	auipc	ra,0x0
 4fe:	e8e080e7          	jalr	-370(ra) # 388 <printint>
 502:	8b4a                	mv	s6,s2
      state = 0;
 504:	4981                	li	s3,0
 506:	b771                	j	492 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 508:	008b0913          	addi	s2,s6,8
 50c:	4681                	li	a3,0
 50e:	4629                	li	a2,10
 510:	000b2583          	lw	a1,0(s6)
 514:	8556                	mv	a0,s5
 516:	00000097          	auipc	ra,0x0
 51a:	e72080e7          	jalr	-398(ra) # 388 <printint>
 51e:	8b4a                	mv	s6,s2
      state = 0;
 520:	4981                	li	s3,0
 522:	bf85                	j	492 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 524:	008b0913          	addi	s2,s6,8
 528:	4681                	li	a3,0
 52a:	4641                	li	a2,16
 52c:	000b2583          	lw	a1,0(s6)
 530:	8556                	mv	a0,s5
 532:	00000097          	auipc	ra,0x0
 536:	e56080e7          	jalr	-426(ra) # 388 <printint>
 53a:	8b4a                	mv	s6,s2
      state = 0;
 53c:	4981                	li	s3,0
 53e:	bf91                	j	492 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 540:	008b0793          	addi	a5,s6,8
 544:	f8f43423          	sd	a5,-120(s0)
 548:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 54c:	03000593          	li	a1,48
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	e14080e7          	jalr	-492(ra) # 366 <putc>
  putc(fd, 'x');
 55a:	85ea                	mv	a1,s10
 55c:	8556                	mv	a0,s5
 55e:	00000097          	auipc	ra,0x0
 562:	e08080e7          	jalr	-504(ra) # 366 <putc>
 566:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 568:	03c9d793          	srli	a5,s3,0x3c
 56c:	97de                	add	a5,a5,s7
 56e:	0007c583          	lbu	a1,0(a5)
 572:	8556                	mv	a0,s5
 574:	00000097          	auipc	ra,0x0
 578:	df2080e7          	jalr	-526(ra) # 366 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 57c:	0992                	slli	s3,s3,0x4
 57e:	397d                	addiw	s2,s2,-1
 580:	fe0914e3          	bnez	s2,568 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 584:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 588:	4981                	li	s3,0
 58a:	b721                	j	492 <vprintf+0x60>
        s = va_arg(ap, char*);
 58c:	008b0993          	addi	s3,s6,8
 590:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 594:	02090163          	beqz	s2,5b6 <vprintf+0x184>
        while(*s != 0){
 598:	00094583          	lbu	a1,0(s2)
 59c:	c9a1                	beqz	a1,5ec <vprintf+0x1ba>
          putc(fd, *s);
 59e:	8556                	mv	a0,s5
 5a0:	00000097          	auipc	ra,0x0
 5a4:	dc6080e7          	jalr	-570(ra) # 366 <putc>
          s++;
 5a8:	0905                	addi	s2,s2,1
        while(*s != 0){
 5aa:	00094583          	lbu	a1,0(s2)
 5ae:	f9e5                	bnez	a1,59e <vprintf+0x16c>
        s = va_arg(ap, char*);
 5b0:	8b4e                	mv	s6,s3
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	bdf9                	j	492 <vprintf+0x60>
          s = "(null)";
 5b6:	00000917          	auipc	s2,0x0
 5ba:	22a90913          	addi	s2,s2,554 # 7e0 <malloc+0xe4>
        while(*s != 0){
 5be:	02800593          	li	a1,40
 5c2:	bff1                	j	59e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5c4:	008b0913          	addi	s2,s6,8
 5c8:	000b4583          	lbu	a1,0(s6)
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	d98080e7          	jalr	-616(ra) # 366 <putc>
 5d6:	8b4a                	mv	s6,s2
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	bd65                	j	492 <vprintf+0x60>
        putc(fd, c);
 5dc:	85d2                	mv	a1,s4
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	d86080e7          	jalr	-634(ra) # 366 <putc>
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	b565                	j	492 <vprintf+0x60>
        s = va_arg(ap, char*);
 5ec:	8b4e                	mv	s6,s3
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	b54d                	j	492 <vprintf+0x60>
    }
  }
}
 5f2:	70e6                	ld	ra,120(sp)
 5f4:	7446                	ld	s0,112(sp)
 5f6:	74a6                	ld	s1,104(sp)
 5f8:	7906                	ld	s2,96(sp)
 5fa:	69e6                	ld	s3,88(sp)
 5fc:	6a46                	ld	s4,80(sp)
 5fe:	6aa6                	ld	s5,72(sp)
 600:	6b06                	ld	s6,64(sp)
 602:	7be2                	ld	s7,56(sp)
 604:	7c42                	ld	s8,48(sp)
 606:	7ca2                	ld	s9,40(sp)
 608:	7d02                	ld	s10,32(sp)
 60a:	6de2                	ld	s11,24(sp)
 60c:	6109                	addi	sp,sp,128
 60e:	8082                	ret

0000000000000610 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 610:	715d                	addi	sp,sp,-80
 612:	ec06                	sd	ra,24(sp)
 614:	e822                	sd	s0,16(sp)
 616:	1000                	addi	s0,sp,32
 618:	e010                	sd	a2,0(s0)
 61a:	e414                	sd	a3,8(s0)
 61c:	e818                	sd	a4,16(s0)
 61e:	ec1c                	sd	a5,24(s0)
 620:	03043023          	sd	a6,32(s0)
 624:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 628:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 62c:	8622                	mv	a2,s0
 62e:	00000097          	auipc	ra,0x0
 632:	e04080e7          	jalr	-508(ra) # 432 <vprintf>
}
 636:	60e2                	ld	ra,24(sp)
 638:	6442                	ld	s0,16(sp)
 63a:	6161                	addi	sp,sp,80
 63c:	8082                	ret

000000000000063e <printf>:

void
printf(const char *fmt, ...)
{
 63e:	711d                	addi	sp,sp,-96
 640:	ec06                	sd	ra,24(sp)
 642:	e822                	sd	s0,16(sp)
 644:	1000                	addi	s0,sp,32
 646:	e40c                	sd	a1,8(s0)
 648:	e810                	sd	a2,16(s0)
 64a:	ec14                	sd	a3,24(s0)
 64c:	f018                	sd	a4,32(s0)
 64e:	f41c                	sd	a5,40(s0)
 650:	03043823          	sd	a6,48(s0)
 654:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 658:	00840613          	addi	a2,s0,8
 65c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 660:	85aa                	mv	a1,a0
 662:	4505                	li	a0,1
 664:	00000097          	auipc	ra,0x0
 668:	dce080e7          	jalr	-562(ra) # 432 <vprintf>
}
 66c:	60e2                	ld	ra,24(sp)
 66e:	6442                	ld	s0,16(sp)
 670:	6125                	addi	sp,sp,96
 672:	8082                	ret

0000000000000674 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 674:	1141                	addi	sp,sp,-16
 676:	e422                	sd	s0,8(sp)
 678:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 67a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67e:	00000797          	auipc	a5,0x0
 682:	1827b783          	ld	a5,386(a5) # 800 <freep>
 686:	a805                	j	6b6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 688:	4618                	lw	a4,8(a2)
 68a:	9db9                	addw	a1,a1,a4
 68c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 690:	6398                	ld	a4,0(a5)
 692:	6318                	ld	a4,0(a4)
 694:	fee53823          	sd	a4,-16(a0)
 698:	a091                	j	6dc <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 69a:	ff852703          	lw	a4,-8(a0)
 69e:	9e39                	addw	a2,a2,a4
 6a0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6a2:	ff053703          	ld	a4,-16(a0)
 6a6:	e398                	sd	a4,0(a5)
 6a8:	a099                	j	6ee <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6aa:	6398                	ld	a4,0(a5)
 6ac:	00e7e463          	bltu	a5,a4,6b4 <free+0x40>
 6b0:	00e6ea63          	bltu	a3,a4,6c4 <free+0x50>
{
 6b4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b6:	fed7fae3          	bgeu	a5,a3,6aa <free+0x36>
 6ba:	6398                	ld	a4,0(a5)
 6bc:	00e6e463          	bltu	a3,a4,6c4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c0:	fee7eae3          	bltu	a5,a4,6b4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6c4:	ff852583          	lw	a1,-8(a0)
 6c8:	6390                	ld	a2,0(a5)
 6ca:	02059713          	slli	a4,a1,0x20
 6ce:	9301                	srli	a4,a4,0x20
 6d0:	0712                	slli	a4,a4,0x4
 6d2:	9736                	add	a4,a4,a3
 6d4:	fae60ae3          	beq	a2,a4,688 <free+0x14>
    bp->s.ptr = p->s.ptr;
 6d8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6dc:	4790                	lw	a2,8(a5)
 6de:	02061713          	slli	a4,a2,0x20
 6e2:	9301                	srli	a4,a4,0x20
 6e4:	0712                	slli	a4,a4,0x4
 6e6:	973e                	add	a4,a4,a5
 6e8:	fae689e3          	beq	a3,a4,69a <free+0x26>
  } else
    p->s.ptr = bp;
 6ec:	e394                	sd	a3,0(a5)
  freep = p;
 6ee:	00000717          	auipc	a4,0x0
 6f2:	10f73923          	sd	a5,274(a4) # 800 <freep>
}
 6f6:	6422                	ld	s0,8(sp)
 6f8:	0141                	addi	sp,sp,16
 6fa:	8082                	ret

00000000000006fc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6fc:	7139                	addi	sp,sp,-64
 6fe:	fc06                	sd	ra,56(sp)
 700:	f822                	sd	s0,48(sp)
 702:	f426                	sd	s1,40(sp)
 704:	f04a                	sd	s2,32(sp)
 706:	ec4e                	sd	s3,24(sp)
 708:	e852                	sd	s4,16(sp)
 70a:	e456                	sd	s5,8(sp)
 70c:	e05a                	sd	s6,0(sp)
 70e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 710:	02051493          	slli	s1,a0,0x20
 714:	9081                	srli	s1,s1,0x20
 716:	04bd                	addi	s1,s1,15
 718:	8091                	srli	s1,s1,0x4
 71a:	0014899b          	addiw	s3,s1,1
 71e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 720:	00000517          	auipc	a0,0x0
 724:	0e053503          	ld	a0,224(a0) # 800 <freep>
 728:	c515                	beqz	a0,754 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 72c:	4798                	lw	a4,8(a5)
 72e:	02977f63          	bgeu	a4,s1,76c <malloc+0x70>
 732:	8a4e                	mv	s4,s3
 734:	0009871b          	sext.w	a4,s3
 738:	6685                	lui	a3,0x1
 73a:	00d77363          	bgeu	a4,a3,740 <malloc+0x44>
 73e:	6a05                	lui	s4,0x1
 740:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 744:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 748:	00000917          	auipc	s2,0x0
 74c:	0b890913          	addi	s2,s2,184 # 800 <freep>
  if(p == (char*)-1)
 750:	5afd                	li	s5,-1
 752:	a88d                	j	7c4 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 754:	00000797          	auipc	a5,0x0
 758:	0b478793          	addi	a5,a5,180 # 808 <base>
 75c:	00000717          	auipc	a4,0x0
 760:	0af73223          	sd	a5,164(a4) # 800 <freep>
 764:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 766:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 76a:	b7e1                	j	732 <malloc+0x36>
      if(p->s.size == nunits)
 76c:	02e48b63          	beq	s1,a4,7a2 <malloc+0xa6>
        p->s.size -= nunits;
 770:	4137073b          	subw	a4,a4,s3
 774:	c798                	sw	a4,8(a5)
        p += p->s.size;
 776:	1702                	slli	a4,a4,0x20
 778:	9301                	srli	a4,a4,0x20
 77a:	0712                	slli	a4,a4,0x4
 77c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 77e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 782:	00000717          	auipc	a4,0x0
 786:	06a73f23          	sd	a0,126(a4) # 800 <freep>
      return (void*)(p + 1);
 78a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 78e:	70e2                	ld	ra,56(sp)
 790:	7442                	ld	s0,48(sp)
 792:	74a2                	ld	s1,40(sp)
 794:	7902                	ld	s2,32(sp)
 796:	69e2                	ld	s3,24(sp)
 798:	6a42                	ld	s4,16(sp)
 79a:	6aa2                	ld	s5,8(sp)
 79c:	6b02                	ld	s6,0(sp)
 79e:	6121                	addi	sp,sp,64
 7a0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7a2:	6398                	ld	a4,0(a5)
 7a4:	e118                	sd	a4,0(a0)
 7a6:	bff1                	j	782 <malloc+0x86>
  hp->s.size = nu;
 7a8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7ac:	0541                	addi	a0,a0,16
 7ae:	00000097          	auipc	ra,0x0
 7b2:	ec6080e7          	jalr	-314(ra) # 674 <free>
  return freep;
 7b6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7ba:	d971                	beqz	a0,78e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7bc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7be:	4798                	lw	a4,8(a5)
 7c0:	fa9776e3          	bgeu	a4,s1,76c <malloc+0x70>
    if(p == freep)
 7c4:	00093703          	ld	a4,0(s2)
 7c8:	853e                	mv	a0,a5
 7ca:	fef719e3          	bne	a4,a5,7bc <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7ce:	8552                	mv	a0,s4
 7d0:	00000097          	auipc	ra,0x0
 7d4:	b6e080e7          	jalr	-1170(ra) # 33e <sbrk>
  if(p == (char*)-1)
 7d8:	fd5518e3          	bne	a0,s5,7a8 <malloc+0xac>
        return 0;
 7dc:	4501                	li	a0,0
 7de:	bf45                	j	78e <malloc+0x92>
