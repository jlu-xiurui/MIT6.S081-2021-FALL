
user/_call:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <g>:
#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int g(int x) {
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  return x+3;
}
   6:	250d                	addiw	a0,a0,3
   8:	6422                	ld	s0,8(sp)
   a:	0141                	addi	sp,sp,16
   c:	8082                	ret

000000000000000e <f>:

int f(int x) {
   e:	1141                	addi	sp,sp,-16
  10:	e422                	sd	s0,8(sp)
  12:	0800                	addi	s0,sp,16
  return g(x);
}
  14:	250d                	addiw	a0,a0,3
  16:	6422                	ld	s0,8(sp)
  18:	0141                	addi	sp,sp,16
  1a:	8082                	ret

000000000000001c <main>:

void main(void) {
  1c:	1141                	addi	sp,sp,-16
  1e:	e406                	sd	ra,8(sp)
  20:	e022                	sd	s0,0(sp)
  22:	0800                	addi	s0,sp,16
  printf("%d %d\n", f(8)+1, 13);
  24:	4635                	li	a2,13
  26:	45b1                	li	a1,12
  28:	00000517          	auipc	a0,0x0
  2c:	7c050513          	addi	a0,a0,1984 # 7e8 <malloc+0xea>
  30:	00000097          	auipc	ra,0x0
  34:	610080e7          	jalr	1552(ra) # 640 <printf>
  exit(0);
  38:	4501                	li	a0,0
  3a:	00000097          	auipc	ra,0x0
  3e:	27e080e7          	jalr	638(ra) # 2b8 <exit>

0000000000000042 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  42:	1141                	addi	sp,sp,-16
  44:	e422                	sd	s0,8(sp)
  46:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  48:	87aa                	mv	a5,a0
  4a:	0585                	addi	a1,a1,1
  4c:	0785                	addi	a5,a5,1
  4e:	fff5c703          	lbu	a4,-1(a1)
  52:	fee78fa3          	sb	a4,-1(a5)
  56:	fb75                	bnez	a4,4a <strcpy+0x8>
    ;
  return os;
}
  58:	6422                	ld	s0,8(sp)
  5a:	0141                	addi	sp,sp,16
  5c:	8082                	ret

000000000000005e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e422                	sd	s0,8(sp)
  62:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	cb91                	beqz	a5,7c <strcmp+0x1e>
  6a:	0005c703          	lbu	a4,0(a1)
  6e:	00f71763          	bne	a4,a5,7c <strcmp+0x1e>
    p++, q++;
  72:	0505                	addi	a0,a0,1
  74:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  76:	00054783          	lbu	a5,0(a0)
  7a:	fbe5                	bnez	a5,6a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7c:	0005c503          	lbu	a0,0(a1)
}
  80:	40a7853b          	subw	a0,a5,a0
  84:	6422                	ld	s0,8(sp)
  86:	0141                	addi	sp,sp,16
  88:	8082                	ret

000000000000008a <strlen>:

uint
strlen(const char *s)
{
  8a:	1141                	addi	sp,sp,-16
  8c:	e422                	sd	s0,8(sp)
  8e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  90:	00054783          	lbu	a5,0(a0)
  94:	cf91                	beqz	a5,b0 <strlen+0x26>
  96:	0505                	addi	a0,a0,1
  98:	87aa                	mv	a5,a0
  9a:	4685                	li	a3,1
  9c:	9e89                	subw	a3,a3,a0
  9e:	00f6853b          	addw	a0,a3,a5
  a2:	0785                	addi	a5,a5,1
  a4:	fff7c703          	lbu	a4,-1(a5)
  a8:	fb7d                	bnez	a4,9e <strlen+0x14>
    ;
  return n;
}
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret
  for(n = 0; s[n]; n++)
  b0:	4501                	li	a0,0
  b2:	bfe5                	j	aa <strlen+0x20>

00000000000000b4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e422                	sd	s0,8(sp)
  b8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ba:	ce09                	beqz	a2,d4 <memset+0x20>
  bc:	87aa                	mv	a5,a0
  be:	fff6071b          	addiw	a4,a2,-1
  c2:	1702                	slli	a4,a4,0x20
  c4:	9301                	srli	a4,a4,0x20
  c6:	0705                	addi	a4,a4,1
  c8:	972a                	add	a4,a4,a0
    cdst[i] = c;
  ca:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ce:	0785                	addi	a5,a5,1
  d0:	fee79de3          	bne	a5,a4,ca <memset+0x16>
  }
  return dst;
}
  d4:	6422                	ld	s0,8(sp)
  d6:	0141                	addi	sp,sp,16
  d8:	8082                	ret

00000000000000da <strchr>:

char*
strchr(const char *s, char c)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e422                	sd	s0,8(sp)
  de:	0800                	addi	s0,sp,16
  for(; *s; s++)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	cb99                	beqz	a5,fa <strchr+0x20>
    if(*s == c)
  e6:	00f58763          	beq	a1,a5,f4 <strchr+0x1a>
  for(; *s; s++)
  ea:	0505                	addi	a0,a0,1
  ec:	00054783          	lbu	a5,0(a0)
  f0:	fbfd                	bnez	a5,e6 <strchr+0xc>
      return (char*)s;
  return 0;
  f2:	4501                	li	a0,0
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret
  return 0;
  fa:	4501                	li	a0,0
  fc:	bfe5                	j	f4 <strchr+0x1a>

00000000000000fe <gets>:

char*
gets(char *buf, int max)
{
  fe:	711d                	addi	sp,sp,-96
 100:	ec86                	sd	ra,88(sp)
 102:	e8a2                	sd	s0,80(sp)
 104:	e4a6                	sd	s1,72(sp)
 106:	e0ca                	sd	s2,64(sp)
 108:	fc4e                	sd	s3,56(sp)
 10a:	f852                	sd	s4,48(sp)
 10c:	f456                	sd	s5,40(sp)
 10e:	f05a                	sd	s6,32(sp)
 110:	ec5e                	sd	s7,24(sp)
 112:	1080                	addi	s0,sp,96
 114:	8baa                	mv	s7,a0
 116:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 118:	892a                	mv	s2,a0
 11a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 11c:	4aa9                	li	s5,10
 11e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 120:	89a6                	mv	s3,s1
 122:	2485                	addiw	s1,s1,1
 124:	0344d863          	bge	s1,s4,154 <gets+0x56>
    cc = read(0, &c, 1);
 128:	4605                	li	a2,1
 12a:	faf40593          	addi	a1,s0,-81
 12e:	4501                	li	a0,0
 130:	00000097          	auipc	ra,0x0
 134:	1a0080e7          	jalr	416(ra) # 2d0 <read>
    if(cc < 1)
 138:	00a05e63          	blez	a0,154 <gets+0x56>
    buf[i++] = c;
 13c:	faf44783          	lbu	a5,-81(s0)
 140:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 144:	01578763          	beq	a5,s5,152 <gets+0x54>
 148:	0905                	addi	s2,s2,1
 14a:	fd679be3          	bne	a5,s6,120 <gets+0x22>
  for(i=0; i+1 < max; ){
 14e:	89a6                	mv	s3,s1
 150:	a011                	j	154 <gets+0x56>
 152:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 154:	99de                	add	s3,s3,s7
 156:	00098023          	sb	zero,0(s3)
  return buf;
}
 15a:	855e                	mv	a0,s7
 15c:	60e6                	ld	ra,88(sp)
 15e:	6446                	ld	s0,80(sp)
 160:	64a6                	ld	s1,72(sp)
 162:	6906                	ld	s2,64(sp)
 164:	79e2                	ld	s3,56(sp)
 166:	7a42                	ld	s4,48(sp)
 168:	7aa2                	ld	s5,40(sp)
 16a:	7b02                	ld	s6,32(sp)
 16c:	6be2                	ld	s7,24(sp)
 16e:	6125                	addi	sp,sp,96
 170:	8082                	ret

0000000000000172 <stat>:

int
stat(const char *n, struct stat *st)
{
 172:	1101                	addi	sp,sp,-32
 174:	ec06                	sd	ra,24(sp)
 176:	e822                	sd	s0,16(sp)
 178:	e426                	sd	s1,8(sp)
 17a:	e04a                	sd	s2,0(sp)
 17c:	1000                	addi	s0,sp,32
 17e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 180:	4581                	li	a1,0
 182:	00000097          	auipc	ra,0x0
 186:	176080e7          	jalr	374(ra) # 2f8 <open>
  if(fd < 0)
 18a:	02054563          	bltz	a0,1b4 <stat+0x42>
 18e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 190:	85ca                	mv	a1,s2
 192:	00000097          	auipc	ra,0x0
 196:	17e080e7          	jalr	382(ra) # 310 <fstat>
 19a:	892a                	mv	s2,a0
  close(fd);
 19c:	8526                	mv	a0,s1
 19e:	00000097          	auipc	ra,0x0
 1a2:	142080e7          	jalr	322(ra) # 2e0 <close>
  return r;
}
 1a6:	854a                	mv	a0,s2
 1a8:	60e2                	ld	ra,24(sp)
 1aa:	6442                	ld	s0,16(sp)
 1ac:	64a2                	ld	s1,8(sp)
 1ae:	6902                	ld	s2,0(sp)
 1b0:	6105                	addi	sp,sp,32
 1b2:	8082                	ret
    return -1;
 1b4:	597d                	li	s2,-1
 1b6:	bfc5                	j	1a6 <stat+0x34>

00000000000001b8 <atoi>:

int
atoi(const char *s)
{
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e422                	sd	s0,8(sp)
 1bc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1be:	00054603          	lbu	a2,0(a0)
 1c2:	fd06079b          	addiw	a5,a2,-48
 1c6:	0ff7f793          	andi	a5,a5,255
 1ca:	4725                	li	a4,9
 1cc:	02f76963          	bltu	a4,a5,1fe <atoi+0x46>
 1d0:	86aa                	mv	a3,a0
  n = 0;
 1d2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1d4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1d6:	0685                	addi	a3,a3,1
 1d8:	0025179b          	slliw	a5,a0,0x2
 1dc:	9fa9                	addw	a5,a5,a0
 1de:	0017979b          	slliw	a5,a5,0x1
 1e2:	9fb1                	addw	a5,a5,a2
 1e4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1e8:	0006c603          	lbu	a2,0(a3)
 1ec:	fd06071b          	addiw	a4,a2,-48
 1f0:	0ff77713          	andi	a4,a4,255
 1f4:	fee5f1e3          	bgeu	a1,a4,1d6 <atoi+0x1e>
  return n;
}
 1f8:	6422                	ld	s0,8(sp)
 1fa:	0141                	addi	sp,sp,16
 1fc:	8082                	ret
  n = 0;
 1fe:	4501                	li	a0,0
 200:	bfe5                	j	1f8 <atoi+0x40>

0000000000000202 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 208:	02b57663          	bgeu	a0,a1,234 <memmove+0x32>
    while(n-- > 0)
 20c:	02c05163          	blez	a2,22e <memmove+0x2c>
 210:	fff6079b          	addiw	a5,a2,-1
 214:	1782                	slli	a5,a5,0x20
 216:	9381                	srli	a5,a5,0x20
 218:	0785                	addi	a5,a5,1
 21a:	97aa                	add	a5,a5,a0
  dst = vdst;
 21c:	872a                	mv	a4,a0
      *dst++ = *src++;
 21e:	0585                	addi	a1,a1,1
 220:	0705                	addi	a4,a4,1
 222:	fff5c683          	lbu	a3,-1(a1)
 226:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 22a:	fee79ae3          	bne	a5,a4,21e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 22e:	6422                	ld	s0,8(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
    dst += n;
 234:	00c50733          	add	a4,a0,a2
    src += n;
 238:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 23a:	fec05ae3          	blez	a2,22e <memmove+0x2c>
 23e:	fff6079b          	addiw	a5,a2,-1
 242:	1782                	slli	a5,a5,0x20
 244:	9381                	srli	a5,a5,0x20
 246:	fff7c793          	not	a5,a5
 24a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 24c:	15fd                	addi	a1,a1,-1
 24e:	177d                	addi	a4,a4,-1
 250:	0005c683          	lbu	a3,0(a1)
 254:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 258:	fee79ae3          	bne	a5,a4,24c <memmove+0x4a>
 25c:	bfc9                	j	22e <memmove+0x2c>

000000000000025e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 264:	ca05                	beqz	a2,294 <memcmp+0x36>
 266:	fff6069b          	addiw	a3,a2,-1
 26a:	1682                	slli	a3,a3,0x20
 26c:	9281                	srli	a3,a3,0x20
 26e:	0685                	addi	a3,a3,1
 270:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 272:	00054783          	lbu	a5,0(a0)
 276:	0005c703          	lbu	a4,0(a1)
 27a:	00e79863          	bne	a5,a4,28a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 27e:	0505                	addi	a0,a0,1
    p2++;
 280:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 282:	fed518e3          	bne	a0,a3,272 <memcmp+0x14>
  }
  return 0;
 286:	4501                	li	a0,0
 288:	a019                	j	28e <memcmp+0x30>
      return *p1 - *p2;
 28a:	40e7853b          	subw	a0,a5,a4
}
 28e:	6422                	ld	s0,8(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
  return 0;
 294:	4501                	li	a0,0
 296:	bfe5                	j	28e <memcmp+0x30>

0000000000000298 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e406                	sd	ra,8(sp)
 29c:	e022                	sd	s0,0(sp)
 29e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2a0:	00000097          	auipc	ra,0x0
 2a4:	f62080e7          	jalr	-158(ra) # 202 <memmove>
}
 2a8:	60a2                	ld	ra,8(sp)
 2aa:	6402                	ld	s0,0(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret

00000000000002b0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b0:	4885                	li	a7,1
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2b8:	4889                	li	a7,2
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c0:	488d                	li	a7,3
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2c8:	4891                	li	a7,4
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <read>:
.global read
read:
 li a7, SYS_read
 2d0:	4895                	li	a7,5
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <write>:
.global write
write:
 li a7, SYS_write
 2d8:	48c1                	li	a7,16
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <close>:
.global close
close:
 li a7, SYS_close
 2e0:	48d5                	li	a7,21
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2e8:	4899                	li	a7,6
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f0:	489d                	li	a7,7
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <open>:
.global open
open:
 li a7, SYS_open
 2f8:	48bd                	li	a7,15
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 300:	48c5                	li	a7,17
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 308:	48c9                	li	a7,18
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 310:	48a1                	li	a7,8
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <link>:
.global link
link:
 li a7, SYS_link
 318:	48cd                	li	a7,19
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 320:	48d1                	li	a7,20
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 328:	48a5                	li	a7,9
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <dup>:
.global dup
dup:
 li a7, SYS_dup
 330:	48a9                	li	a7,10
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 338:	48ad                	li	a7,11
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 340:	48b1                	li	a7,12
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 348:	48b5                	li	a7,13
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 350:	48b9                	li	a7,14
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 358:	48d9                	li	a7,22
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 360:	48dd                	li	a7,23
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 368:	1101                	addi	sp,sp,-32
 36a:	ec06                	sd	ra,24(sp)
 36c:	e822                	sd	s0,16(sp)
 36e:	1000                	addi	s0,sp,32
 370:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 374:	4605                	li	a2,1
 376:	fef40593          	addi	a1,s0,-17
 37a:	00000097          	auipc	ra,0x0
 37e:	f5e080e7          	jalr	-162(ra) # 2d8 <write>
}
 382:	60e2                	ld	ra,24(sp)
 384:	6442                	ld	s0,16(sp)
 386:	6105                	addi	sp,sp,32
 388:	8082                	ret

000000000000038a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38a:	7139                	addi	sp,sp,-64
 38c:	fc06                	sd	ra,56(sp)
 38e:	f822                	sd	s0,48(sp)
 390:	f426                	sd	s1,40(sp)
 392:	f04a                	sd	s2,32(sp)
 394:	ec4e                	sd	s3,24(sp)
 396:	0080                	addi	s0,sp,64
 398:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 39a:	c299                	beqz	a3,3a0 <printint+0x16>
 39c:	0805c863          	bltz	a1,42c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3a0:	2581                	sext.w	a1,a1
  neg = 0;
 3a2:	4881                	li	a7,0
 3a4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3a8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3aa:	2601                	sext.w	a2,a2
 3ac:	00000517          	auipc	a0,0x0
 3b0:	44c50513          	addi	a0,a0,1100 # 7f8 <digits>
 3b4:	883a                	mv	a6,a4
 3b6:	2705                	addiw	a4,a4,1
 3b8:	02c5f7bb          	remuw	a5,a1,a2
 3bc:	1782                	slli	a5,a5,0x20
 3be:	9381                	srli	a5,a5,0x20
 3c0:	97aa                	add	a5,a5,a0
 3c2:	0007c783          	lbu	a5,0(a5)
 3c6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ca:	0005879b          	sext.w	a5,a1
 3ce:	02c5d5bb          	divuw	a1,a1,a2
 3d2:	0685                	addi	a3,a3,1
 3d4:	fec7f0e3          	bgeu	a5,a2,3b4 <printint+0x2a>
  if(neg)
 3d8:	00088b63          	beqz	a7,3ee <printint+0x64>
    buf[i++] = '-';
 3dc:	fd040793          	addi	a5,s0,-48
 3e0:	973e                	add	a4,a4,a5
 3e2:	02d00793          	li	a5,45
 3e6:	fef70823          	sb	a5,-16(a4)
 3ea:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3ee:	02e05863          	blez	a4,41e <printint+0x94>
 3f2:	fc040793          	addi	a5,s0,-64
 3f6:	00e78933          	add	s2,a5,a4
 3fa:	fff78993          	addi	s3,a5,-1
 3fe:	99ba                	add	s3,s3,a4
 400:	377d                	addiw	a4,a4,-1
 402:	1702                	slli	a4,a4,0x20
 404:	9301                	srli	a4,a4,0x20
 406:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 40a:	fff94583          	lbu	a1,-1(s2)
 40e:	8526                	mv	a0,s1
 410:	00000097          	auipc	ra,0x0
 414:	f58080e7          	jalr	-168(ra) # 368 <putc>
  while(--i >= 0)
 418:	197d                	addi	s2,s2,-1
 41a:	ff3918e3          	bne	s2,s3,40a <printint+0x80>
}
 41e:	70e2                	ld	ra,56(sp)
 420:	7442                	ld	s0,48(sp)
 422:	74a2                	ld	s1,40(sp)
 424:	7902                	ld	s2,32(sp)
 426:	69e2                	ld	s3,24(sp)
 428:	6121                	addi	sp,sp,64
 42a:	8082                	ret
    x = -xx;
 42c:	40b005bb          	negw	a1,a1
    neg = 1;
 430:	4885                	li	a7,1
    x = -xx;
 432:	bf8d                	j	3a4 <printint+0x1a>

0000000000000434 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 434:	7119                	addi	sp,sp,-128
 436:	fc86                	sd	ra,120(sp)
 438:	f8a2                	sd	s0,112(sp)
 43a:	f4a6                	sd	s1,104(sp)
 43c:	f0ca                	sd	s2,96(sp)
 43e:	ecce                	sd	s3,88(sp)
 440:	e8d2                	sd	s4,80(sp)
 442:	e4d6                	sd	s5,72(sp)
 444:	e0da                	sd	s6,64(sp)
 446:	fc5e                	sd	s7,56(sp)
 448:	f862                	sd	s8,48(sp)
 44a:	f466                	sd	s9,40(sp)
 44c:	f06a                	sd	s10,32(sp)
 44e:	ec6e                	sd	s11,24(sp)
 450:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 452:	0005c903          	lbu	s2,0(a1)
 456:	18090f63          	beqz	s2,5f4 <vprintf+0x1c0>
 45a:	8aaa                	mv	s5,a0
 45c:	8b32                	mv	s6,a2
 45e:	00158493          	addi	s1,a1,1
  state = 0;
 462:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 464:	02500a13          	li	s4,37
      if(c == 'd'){
 468:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 46c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 470:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 474:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 478:	00000b97          	auipc	s7,0x0
 47c:	380b8b93          	addi	s7,s7,896 # 7f8 <digits>
 480:	a839                	j	49e <vprintf+0x6a>
        putc(fd, c);
 482:	85ca                	mv	a1,s2
 484:	8556                	mv	a0,s5
 486:	00000097          	auipc	ra,0x0
 48a:	ee2080e7          	jalr	-286(ra) # 368 <putc>
 48e:	a019                	j	494 <vprintf+0x60>
    } else if(state == '%'){
 490:	01498f63          	beq	s3,s4,4ae <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 494:	0485                	addi	s1,s1,1
 496:	fff4c903          	lbu	s2,-1(s1)
 49a:	14090d63          	beqz	s2,5f4 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 49e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4a2:	fe0997e3          	bnez	s3,490 <vprintf+0x5c>
      if(c == '%'){
 4a6:	fd479ee3          	bne	a5,s4,482 <vprintf+0x4e>
        state = '%';
 4aa:	89be                	mv	s3,a5
 4ac:	b7e5                	j	494 <vprintf+0x60>
      if(c == 'd'){
 4ae:	05878063          	beq	a5,s8,4ee <vprintf+0xba>
      } else if(c == 'l') {
 4b2:	05978c63          	beq	a5,s9,50a <vprintf+0xd6>
      } else if(c == 'x') {
 4b6:	07a78863          	beq	a5,s10,526 <vprintf+0xf2>
      } else if(c == 'p') {
 4ba:	09b78463          	beq	a5,s11,542 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4be:	07300713          	li	a4,115
 4c2:	0ce78663          	beq	a5,a4,58e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4c6:	06300713          	li	a4,99
 4ca:	0ee78e63          	beq	a5,a4,5c6 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4ce:	11478863          	beq	a5,s4,5de <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4d2:	85d2                	mv	a1,s4
 4d4:	8556                	mv	a0,s5
 4d6:	00000097          	auipc	ra,0x0
 4da:	e92080e7          	jalr	-366(ra) # 368 <putc>
        putc(fd, c);
 4de:	85ca                	mv	a1,s2
 4e0:	8556                	mv	a0,s5
 4e2:	00000097          	auipc	ra,0x0
 4e6:	e86080e7          	jalr	-378(ra) # 368 <putc>
      }
      state = 0;
 4ea:	4981                	li	s3,0
 4ec:	b765                	j	494 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 4ee:	008b0913          	addi	s2,s6,8
 4f2:	4685                	li	a3,1
 4f4:	4629                	li	a2,10
 4f6:	000b2583          	lw	a1,0(s6)
 4fa:	8556                	mv	a0,s5
 4fc:	00000097          	auipc	ra,0x0
 500:	e8e080e7          	jalr	-370(ra) # 38a <printint>
 504:	8b4a                	mv	s6,s2
      state = 0;
 506:	4981                	li	s3,0
 508:	b771                	j	494 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 50a:	008b0913          	addi	s2,s6,8
 50e:	4681                	li	a3,0
 510:	4629                	li	a2,10
 512:	000b2583          	lw	a1,0(s6)
 516:	8556                	mv	a0,s5
 518:	00000097          	auipc	ra,0x0
 51c:	e72080e7          	jalr	-398(ra) # 38a <printint>
 520:	8b4a                	mv	s6,s2
      state = 0;
 522:	4981                	li	s3,0
 524:	bf85                	j	494 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 526:	008b0913          	addi	s2,s6,8
 52a:	4681                	li	a3,0
 52c:	4641                	li	a2,16
 52e:	000b2583          	lw	a1,0(s6)
 532:	8556                	mv	a0,s5
 534:	00000097          	auipc	ra,0x0
 538:	e56080e7          	jalr	-426(ra) # 38a <printint>
 53c:	8b4a                	mv	s6,s2
      state = 0;
 53e:	4981                	li	s3,0
 540:	bf91                	j	494 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 542:	008b0793          	addi	a5,s6,8
 546:	f8f43423          	sd	a5,-120(s0)
 54a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 54e:	03000593          	li	a1,48
 552:	8556                	mv	a0,s5
 554:	00000097          	auipc	ra,0x0
 558:	e14080e7          	jalr	-492(ra) # 368 <putc>
  putc(fd, 'x');
 55c:	85ea                	mv	a1,s10
 55e:	8556                	mv	a0,s5
 560:	00000097          	auipc	ra,0x0
 564:	e08080e7          	jalr	-504(ra) # 368 <putc>
 568:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 56a:	03c9d793          	srli	a5,s3,0x3c
 56e:	97de                	add	a5,a5,s7
 570:	0007c583          	lbu	a1,0(a5)
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	df2080e7          	jalr	-526(ra) # 368 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 57e:	0992                	slli	s3,s3,0x4
 580:	397d                	addiw	s2,s2,-1
 582:	fe0914e3          	bnez	s2,56a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 586:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 58a:	4981                	li	s3,0
 58c:	b721                	j	494 <vprintf+0x60>
        s = va_arg(ap, char*);
 58e:	008b0993          	addi	s3,s6,8
 592:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 596:	02090163          	beqz	s2,5b8 <vprintf+0x184>
        while(*s != 0){
 59a:	00094583          	lbu	a1,0(s2)
 59e:	c9a1                	beqz	a1,5ee <vprintf+0x1ba>
          putc(fd, *s);
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	dc6080e7          	jalr	-570(ra) # 368 <putc>
          s++;
 5aa:	0905                	addi	s2,s2,1
        while(*s != 0){
 5ac:	00094583          	lbu	a1,0(s2)
 5b0:	f9e5                	bnez	a1,5a0 <vprintf+0x16c>
        s = va_arg(ap, char*);
 5b2:	8b4e                	mv	s6,s3
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	bdf9                	j	494 <vprintf+0x60>
          s = "(null)";
 5b8:	00000917          	auipc	s2,0x0
 5bc:	23890913          	addi	s2,s2,568 # 7f0 <malloc+0xf2>
        while(*s != 0){
 5c0:	02800593          	li	a1,40
 5c4:	bff1                	j	5a0 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5c6:	008b0913          	addi	s2,s6,8
 5ca:	000b4583          	lbu	a1,0(s6)
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	d98080e7          	jalr	-616(ra) # 368 <putc>
 5d8:	8b4a                	mv	s6,s2
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	bd65                	j	494 <vprintf+0x60>
        putc(fd, c);
 5de:	85d2                	mv	a1,s4
 5e0:	8556                	mv	a0,s5
 5e2:	00000097          	auipc	ra,0x0
 5e6:	d86080e7          	jalr	-634(ra) # 368 <putc>
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	b565                	j	494 <vprintf+0x60>
        s = va_arg(ap, char*);
 5ee:	8b4e                	mv	s6,s3
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	b54d                	j	494 <vprintf+0x60>
    }
  }
}
 5f4:	70e6                	ld	ra,120(sp)
 5f6:	7446                	ld	s0,112(sp)
 5f8:	74a6                	ld	s1,104(sp)
 5fa:	7906                	ld	s2,96(sp)
 5fc:	69e6                	ld	s3,88(sp)
 5fe:	6a46                	ld	s4,80(sp)
 600:	6aa6                	ld	s5,72(sp)
 602:	6b06                	ld	s6,64(sp)
 604:	7be2                	ld	s7,56(sp)
 606:	7c42                	ld	s8,48(sp)
 608:	7ca2                	ld	s9,40(sp)
 60a:	7d02                	ld	s10,32(sp)
 60c:	6de2                	ld	s11,24(sp)
 60e:	6109                	addi	sp,sp,128
 610:	8082                	ret

0000000000000612 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 612:	715d                	addi	sp,sp,-80
 614:	ec06                	sd	ra,24(sp)
 616:	e822                	sd	s0,16(sp)
 618:	1000                	addi	s0,sp,32
 61a:	e010                	sd	a2,0(s0)
 61c:	e414                	sd	a3,8(s0)
 61e:	e818                	sd	a4,16(s0)
 620:	ec1c                	sd	a5,24(s0)
 622:	03043023          	sd	a6,32(s0)
 626:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 62a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 62e:	8622                	mv	a2,s0
 630:	00000097          	auipc	ra,0x0
 634:	e04080e7          	jalr	-508(ra) # 434 <vprintf>
}
 638:	60e2                	ld	ra,24(sp)
 63a:	6442                	ld	s0,16(sp)
 63c:	6161                	addi	sp,sp,80
 63e:	8082                	ret

0000000000000640 <printf>:

void
printf(const char *fmt, ...)
{
 640:	711d                	addi	sp,sp,-96
 642:	ec06                	sd	ra,24(sp)
 644:	e822                	sd	s0,16(sp)
 646:	1000                	addi	s0,sp,32
 648:	e40c                	sd	a1,8(s0)
 64a:	e810                	sd	a2,16(s0)
 64c:	ec14                	sd	a3,24(s0)
 64e:	f018                	sd	a4,32(s0)
 650:	f41c                	sd	a5,40(s0)
 652:	03043823          	sd	a6,48(s0)
 656:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 65a:	00840613          	addi	a2,s0,8
 65e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 662:	85aa                	mv	a1,a0
 664:	4505                	li	a0,1
 666:	00000097          	auipc	ra,0x0
 66a:	dce080e7          	jalr	-562(ra) # 434 <vprintf>
}
 66e:	60e2                	ld	ra,24(sp)
 670:	6442                	ld	s0,16(sp)
 672:	6125                	addi	sp,sp,96
 674:	8082                	ret

0000000000000676 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 676:	1141                	addi	sp,sp,-16
 678:	e422                	sd	s0,8(sp)
 67a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 67c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 680:	00000797          	auipc	a5,0x0
 684:	1907b783          	ld	a5,400(a5) # 810 <freep>
 688:	a805                	j	6b8 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 68a:	4618                	lw	a4,8(a2)
 68c:	9db9                	addw	a1,a1,a4
 68e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 692:	6398                	ld	a4,0(a5)
 694:	6318                	ld	a4,0(a4)
 696:	fee53823          	sd	a4,-16(a0)
 69a:	a091                	j	6de <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 69c:	ff852703          	lw	a4,-8(a0)
 6a0:	9e39                	addw	a2,a2,a4
 6a2:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6a4:	ff053703          	ld	a4,-16(a0)
 6a8:	e398                	sd	a4,0(a5)
 6aa:	a099                	j	6f0 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ac:	6398                	ld	a4,0(a5)
 6ae:	00e7e463          	bltu	a5,a4,6b6 <free+0x40>
 6b2:	00e6ea63          	bltu	a3,a4,6c6 <free+0x50>
{
 6b6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b8:	fed7fae3          	bgeu	a5,a3,6ac <free+0x36>
 6bc:	6398                	ld	a4,0(a5)
 6be:	00e6e463          	bltu	a3,a4,6c6 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c2:	fee7eae3          	bltu	a5,a4,6b6 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6c6:	ff852583          	lw	a1,-8(a0)
 6ca:	6390                	ld	a2,0(a5)
 6cc:	02059713          	slli	a4,a1,0x20
 6d0:	9301                	srli	a4,a4,0x20
 6d2:	0712                	slli	a4,a4,0x4
 6d4:	9736                	add	a4,a4,a3
 6d6:	fae60ae3          	beq	a2,a4,68a <free+0x14>
    bp->s.ptr = p->s.ptr;
 6da:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6de:	4790                	lw	a2,8(a5)
 6e0:	02061713          	slli	a4,a2,0x20
 6e4:	9301                	srli	a4,a4,0x20
 6e6:	0712                	slli	a4,a4,0x4
 6e8:	973e                	add	a4,a4,a5
 6ea:	fae689e3          	beq	a3,a4,69c <free+0x26>
  } else
    p->s.ptr = bp;
 6ee:	e394                	sd	a3,0(a5)
  freep = p;
 6f0:	00000717          	auipc	a4,0x0
 6f4:	12f73023          	sd	a5,288(a4) # 810 <freep>
}
 6f8:	6422                	ld	s0,8(sp)
 6fa:	0141                	addi	sp,sp,16
 6fc:	8082                	ret

00000000000006fe <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6fe:	7139                	addi	sp,sp,-64
 700:	fc06                	sd	ra,56(sp)
 702:	f822                	sd	s0,48(sp)
 704:	f426                	sd	s1,40(sp)
 706:	f04a                	sd	s2,32(sp)
 708:	ec4e                	sd	s3,24(sp)
 70a:	e852                	sd	s4,16(sp)
 70c:	e456                	sd	s5,8(sp)
 70e:	e05a                	sd	s6,0(sp)
 710:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 712:	02051493          	slli	s1,a0,0x20
 716:	9081                	srli	s1,s1,0x20
 718:	04bd                	addi	s1,s1,15
 71a:	8091                	srli	s1,s1,0x4
 71c:	0014899b          	addiw	s3,s1,1
 720:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 722:	00000517          	auipc	a0,0x0
 726:	0ee53503          	ld	a0,238(a0) # 810 <freep>
 72a:	c515                	beqz	a0,756 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 72e:	4798                	lw	a4,8(a5)
 730:	02977f63          	bgeu	a4,s1,76e <malloc+0x70>
 734:	8a4e                	mv	s4,s3
 736:	0009871b          	sext.w	a4,s3
 73a:	6685                	lui	a3,0x1
 73c:	00d77363          	bgeu	a4,a3,742 <malloc+0x44>
 740:	6a05                	lui	s4,0x1
 742:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 746:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 74a:	00000917          	auipc	s2,0x0
 74e:	0c690913          	addi	s2,s2,198 # 810 <freep>
  if(p == (char*)-1)
 752:	5afd                	li	s5,-1
 754:	a88d                	j	7c6 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 756:	00000797          	auipc	a5,0x0
 75a:	0c278793          	addi	a5,a5,194 # 818 <base>
 75e:	00000717          	auipc	a4,0x0
 762:	0af73923          	sd	a5,178(a4) # 810 <freep>
 766:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 768:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 76c:	b7e1                	j	734 <malloc+0x36>
      if(p->s.size == nunits)
 76e:	02e48b63          	beq	s1,a4,7a4 <malloc+0xa6>
        p->s.size -= nunits;
 772:	4137073b          	subw	a4,a4,s3
 776:	c798                	sw	a4,8(a5)
        p += p->s.size;
 778:	1702                	slli	a4,a4,0x20
 77a:	9301                	srli	a4,a4,0x20
 77c:	0712                	slli	a4,a4,0x4
 77e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 780:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 784:	00000717          	auipc	a4,0x0
 788:	08a73623          	sd	a0,140(a4) # 810 <freep>
      return (void*)(p + 1);
 78c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 790:	70e2                	ld	ra,56(sp)
 792:	7442                	ld	s0,48(sp)
 794:	74a2                	ld	s1,40(sp)
 796:	7902                	ld	s2,32(sp)
 798:	69e2                	ld	s3,24(sp)
 79a:	6a42                	ld	s4,16(sp)
 79c:	6aa2                	ld	s5,8(sp)
 79e:	6b02                	ld	s6,0(sp)
 7a0:	6121                	addi	sp,sp,64
 7a2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7a4:	6398                	ld	a4,0(a5)
 7a6:	e118                	sd	a4,0(a0)
 7a8:	bff1                	j	784 <malloc+0x86>
  hp->s.size = nu;
 7aa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7ae:	0541                	addi	a0,a0,16
 7b0:	00000097          	auipc	ra,0x0
 7b4:	ec6080e7          	jalr	-314(ra) # 676 <free>
  return freep;
 7b8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7bc:	d971                	beqz	a0,790 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c0:	4798                	lw	a4,8(a5)
 7c2:	fa9776e3          	bgeu	a4,s1,76e <malloc+0x70>
    if(p == freep)
 7c6:	00093703          	ld	a4,0(s2)
 7ca:	853e                	mv	a0,a5
 7cc:	fef719e3          	bne	a4,a5,7be <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7d0:	8552                	mv	a0,s4
 7d2:	00000097          	auipc	ra,0x0
 7d6:	b6e080e7          	jalr	-1170(ra) # 340 <sbrk>
  if(p == (char*)-1)
 7da:	fd5518e3          	bne	a0,s5,7aa <malloc+0xac>
        return 0;
 7de:	4501                	li	a0,0
 7e0:	bf45                	j	790 <malloc+0x92>
