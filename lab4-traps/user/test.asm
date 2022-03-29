
user/_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
int main(){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    printf("x=%d,y=%d\n",3,44);
   8:	02c00613          	li	a2,44
   c:	458d                	li	a1,3
   e:	00000517          	auipc	a0,0x0
  12:	7ba50513          	addi	a0,a0,1978 # 7c8 <malloc+0xe4>
  16:	00000097          	auipc	ra,0x0
  1a:	610080e7          	jalr	1552(ra) # 626 <printf>
    return 0;
}
  1e:	4501                	li	a0,0
  20:	60a2                	ld	ra,8(sp)
  22:	6402                	ld	s0,0(sp)
  24:	0141                	addi	sp,sp,16
  26:	8082                	ret

0000000000000028 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  28:	1141                	addi	sp,sp,-16
  2a:	e422                	sd	s0,8(sp)
  2c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  2e:	87aa                	mv	a5,a0
  30:	0585                	addi	a1,a1,1
  32:	0785                	addi	a5,a5,1
  34:	fff5c703          	lbu	a4,-1(a1)
  38:	fee78fa3          	sb	a4,-1(a5)
  3c:	fb75                	bnez	a4,30 <strcpy+0x8>
    ;
  return os;
}
  3e:	6422                	ld	s0,8(sp)
  40:	0141                	addi	sp,sp,16
  42:	8082                	ret

0000000000000044 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  44:	1141                	addi	sp,sp,-16
  46:	e422                	sd	s0,8(sp)
  48:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4a:	00054783          	lbu	a5,0(a0)
  4e:	cb91                	beqz	a5,62 <strcmp+0x1e>
  50:	0005c703          	lbu	a4,0(a1)
  54:	00f71763          	bne	a4,a5,62 <strcmp+0x1e>
    p++, q++;
  58:	0505                	addi	a0,a0,1
  5a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5c:	00054783          	lbu	a5,0(a0)
  60:	fbe5                	bnez	a5,50 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  62:	0005c503          	lbu	a0,0(a1)
}
  66:	40a7853b          	subw	a0,a5,a0
  6a:	6422                	ld	s0,8(sp)
  6c:	0141                	addi	sp,sp,16
  6e:	8082                	ret

0000000000000070 <strlen>:

uint
strlen(const char *s)
{
  70:	1141                	addi	sp,sp,-16
  72:	e422                	sd	s0,8(sp)
  74:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  76:	00054783          	lbu	a5,0(a0)
  7a:	cf91                	beqz	a5,96 <strlen+0x26>
  7c:	0505                	addi	a0,a0,1
  7e:	87aa                	mv	a5,a0
  80:	4685                	li	a3,1
  82:	9e89                	subw	a3,a3,a0
  84:	00f6853b          	addw	a0,a3,a5
  88:	0785                	addi	a5,a5,1
  8a:	fff7c703          	lbu	a4,-1(a5)
  8e:	fb7d                	bnez	a4,84 <strlen+0x14>
    ;
  return n;
}
  90:	6422                	ld	s0,8(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret
  for(n = 0; s[n]; n++)
  96:	4501                	li	a0,0
  98:	bfe5                	j	90 <strlen+0x20>

000000000000009a <memset>:

void*
memset(void *dst, int c, uint n)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e422                	sd	s0,8(sp)
  9e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a0:	ce09                	beqz	a2,ba <memset+0x20>
  a2:	87aa                	mv	a5,a0
  a4:	fff6071b          	addiw	a4,a2,-1
  a8:	1702                	slli	a4,a4,0x20
  aa:	9301                	srli	a4,a4,0x20
  ac:	0705                	addi	a4,a4,1
  ae:	972a                	add	a4,a4,a0
    cdst[i] = c;
  b0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b4:	0785                	addi	a5,a5,1
  b6:	fee79de3          	bne	a5,a4,b0 <memset+0x16>
  }
  return dst;
}
  ba:	6422                	ld	s0,8(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret

00000000000000c0 <strchr>:

char*
strchr(const char *s, char c)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e422                	sd	s0,8(sp)
  c4:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	cb99                	beqz	a5,e0 <strchr+0x20>
    if(*s == c)
  cc:	00f58763          	beq	a1,a5,da <strchr+0x1a>
  for(; *s; s++)
  d0:	0505                	addi	a0,a0,1
  d2:	00054783          	lbu	a5,0(a0)
  d6:	fbfd                	bnez	a5,cc <strchr+0xc>
      return (char*)s;
  return 0;
  d8:	4501                	li	a0,0
}
  da:	6422                	ld	s0,8(sp)
  dc:	0141                	addi	sp,sp,16
  de:	8082                	ret
  return 0;
  e0:	4501                	li	a0,0
  e2:	bfe5                	j	da <strchr+0x1a>

00000000000000e4 <gets>:

char*
gets(char *buf, int max)
{
  e4:	711d                	addi	sp,sp,-96
  e6:	ec86                	sd	ra,88(sp)
  e8:	e8a2                	sd	s0,80(sp)
  ea:	e4a6                	sd	s1,72(sp)
  ec:	e0ca                	sd	s2,64(sp)
  ee:	fc4e                	sd	s3,56(sp)
  f0:	f852                	sd	s4,48(sp)
  f2:	f456                	sd	s5,40(sp)
  f4:	f05a                	sd	s6,32(sp)
  f6:	ec5e                	sd	s7,24(sp)
  f8:	1080                	addi	s0,sp,96
  fa:	8baa                	mv	s7,a0
  fc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fe:	892a                	mv	s2,a0
 100:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 102:	4aa9                	li	s5,10
 104:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 106:	89a6                	mv	s3,s1
 108:	2485                	addiw	s1,s1,1
 10a:	0344d863          	bge	s1,s4,13a <gets+0x56>
    cc = read(0, &c, 1);
 10e:	4605                	li	a2,1
 110:	faf40593          	addi	a1,s0,-81
 114:	4501                	li	a0,0
 116:	00000097          	auipc	ra,0x0
 11a:	1a0080e7          	jalr	416(ra) # 2b6 <read>
    if(cc < 1)
 11e:	00a05e63          	blez	a0,13a <gets+0x56>
    buf[i++] = c;
 122:	faf44783          	lbu	a5,-81(s0)
 126:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12a:	01578763          	beq	a5,s5,138 <gets+0x54>
 12e:	0905                	addi	s2,s2,1
 130:	fd679be3          	bne	a5,s6,106 <gets+0x22>
  for(i=0; i+1 < max; ){
 134:	89a6                	mv	s3,s1
 136:	a011                	j	13a <gets+0x56>
 138:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13a:	99de                	add	s3,s3,s7
 13c:	00098023          	sb	zero,0(s3)
  return buf;
}
 140:	855e                	mv	a0,s7
 142:	60e6                	ld	ra,88(sp)
 144:	6446                	ld	s0,80(sp)
 146:	64a6                	ld	s1,72(sp)
 148:	6906                	ld	s2,64(sp)
 14a:	79e2                	ld	s3,56(sp)
 14c:	7a42                	ld	s4,48(sp)
 14e:	7aa2                	ld	s5,40(sp)
 150:	7b02                	ld	s6,32(sp)
 152:	6be2                	ld	s7,24(sp)
 154:	6125                	addi	sp,sp,96
 156:	8082                	ret

0000000000000158 <stat>:

int
stat(const char *n, struct stat *st)
{
 158:	1101                	addi	sp,sp,-32
 15a:	ec06                	sd	ra,24(sp)
 15c:	e822                	sd	s0,16(sp)
 15e:	e426                	sd	s1,8(sp)
 160:	e04a                	sd	s2,0(sp)
 162:	1000                	addi	s0,sp,32
 164:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 166:	4581                	li	a1,0
 168:	00000097          	auipc	ra,0x0
 16c:	176080e7          	jalr	374(ra) # 2de <open>
  if(fd < 0)
 170:	02054563          	bltz	a0,19a <stat+0x42>
 174:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 176:	85ca                	mv	a1,s2
 178:	00000097          	auipc	ra,0x0
 17c:	17e080e7          	jalr	382(ra) # 2f6 <fstat>
 180:	892a                	mv	s2,a0
  close(fd);
 182:	8526                	mv	a0,s1
 184:	00000097          	auipc	ra,0x0
 188:	142080e7          	jalr	322(ra) # 2c6 <close>
  return r;
}
 18c:	854a                	mv	a0,s2
 18e:	60e2                	ld	ra,24(sp)
 190:	6442                	ld	s0,16(sp)
 192:	64a2                	ld	s1,8(sp)
 194:	6902                	ld	s2,0(sp)
 196:	6105                	addi	sp,sp,32
 198:	8082                	ret
    return -1;
 19a:	597d                	li	s2,-1
 19c:	bfc5                	j	18c <stat+0x34>

000000000000019e <atoi>:

int
atoi(const char *s)
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e422                	sd	s0,8(sp)
 1a2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a4:	00054603          	lbu	a2,0(a0)
 1a8:	fd06079b          	addiw	a5,a2,-48
 1ac:	0ff7f793          	andi	a5,a5,255
 1b0:	4725                	li	a4,9
 1b2:	02f76963          	bltu	a4,a5,1e4 <atoi+0x46>
 1b6:	86aa                	mv	a3,a0
  n = 0;
 1b8:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1ba:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1bc:	0685                	addi	a3,a3,1
 1be:	0025179b          	slliw	a5,a0,0x2
 1c2:	9fa9                	addw	a5,a5,a0
 1c4:	0017979b          	slliw	a5,a5,0x1
 1c8:	9fb1                	addw	a5,a5,a2
 1ca:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ce:	0006c603          	lbu	a2,0(a3)
 1d2:	fd06071b          	addiw	a4,a2,-48
 1d6:	0ff77713          	andi	a4,a4,255
 1da:	fee5f1e3          	bgeu	a1,a4,1bc <atoi+0x1e>
  return n;
}
 1de:	6422                	ld	s0,8(sp)
 1e0:	0141                	addi	sp,sp,16
 1e2:	8082                	ret
  n = 0;
 1e4:	4501                	li	a0,0
 1e6:	bfe5                	j	1de <atoi+0x40>

00000000000001e8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e422                	sd	s0,8(sp)
 1ec:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1ee:	02b57663          	bgeu	a0,a1,21a <memmove+0x32>
    while(n-- > 0)
 1f2:	02c05163          	blez	a2,214 <memmove+0x2c>
 1f6:	fff6079b          	addiw	a5,a2,-1
 1fa:	1782                	slli	a5,a5,0x20
 1fc:	9381                	srli	a5,a5,0x20
 1fe:	0785                	addi	a5,a5,1
 200:	97aa                	add	a5,a5,a0
  dst = vdst;
 202:	872a                	mv	a4,a0
      *dst++ = *src++;
 204:	0585                	addi	a1,a1,1
 206:	0705                	addi	a4,a4,1
 208:	fff5c683          	lbu	a3,-1(a1)
 20c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 210:	fee79ae3          	bne	a5,a4,204 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 214:	6422                	ld	s0,8(sp)
 216:	0141                	addi	sp,sp,16
 218:	8082                	ret
    dst += n;
 21a:	00c50733          	add	a4,a0,a2
    src += n;
 21e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 220:	fec05ae3          	blez	a2,214 <memmove+0x2c>
 224:	fff6079b          	addiw	a5,a2,-1
 228:	1782                	slli	a5,a5,0x20
 22a:	9381                	srli	a5,a5,0x20
 22c:	fff7c793          	not	a5,a5
 230:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 232:	15fd                	addi	a1,a1,-1
 234:	177d                	addi	a4,a4,-1
 236:	0005c683          	lbu	a3,0(a1)
 23a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 23e:	fee79ae3          	bne	a5,a4,232 <memmove+0x4a>
 242:	bfc9                	j	214 <memmove+0x2c>

0000000000000244 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 244:	1141                	addi	sp,sp,-16
 246:	e422                	sd	s0,8(sp)
 248:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 24a:	ca05                	beqz	a2,27a <memcmp+0x36>
 24c:	fff6069b          	addiw	a3,a2,-1
 250:	1682                	slli	a3,a3,0x20
 252:	9281                	srli	a3,a3,0x20
 254:	0685                	addi	a3,a3,1
 256:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 258:	00054783          	lbu	a5,0(a0)
 25c:	0005c703          	lbu	a4,0(a1)
 260:	00e79863          	bne	a5,a4,270 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 264:	0505                	addi	a0,a0,1
    p2++;
 266:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 268:	fed518e3          	bne	a0,a3,258 <memcmp+0x14>
  }
  return 0;
 26c:	4501                	li	a0,0
 26e:	a019                	j	274 <memcmp+0x30>
      return *p1 - *p2;
 270:	40e7853b          	subw	a0,a5,a4
}
 274:	6422                	ld	s0,8(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret
  return 0;
 27a:	4501                	li	a0,0
 27c:	bfe5                	j	274 <memcmp+0x30>

000000000000027e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 27e:	1141                	addi	sp,sp,-16
 280:	e406                	sd	ra,8(sp)
 282:	e022                	sd	s0,0(sp)
 284:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 286:	00000097          	auipc	ra,0x0
 28a:	f62080e7          	jalr	-158(ra) # 1e8 <memmove>
}
 28e:	60a2                	ld	ra,8(sp)
 290:	6402                	ld	s0,0(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret

0000000000000296 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 296:	4885                	li	a7,1
 ecall
 298:	00000073          	ecall
 ret
 29c:	8082                	ret

000000000000029e <exit>:
.global exit
exit:
 li a7, SYS_exit
 29e:	4889                	li	a7,2
 ecall
 2a0:	00000073          	ecall
 ret
 2a4:	8082                	ret

00000000000002a6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2a6:	488d                	li	a7,3
 ecall
 2a8:	00000073          	ecall
 ret
 2ac:	8082                	ret

00000000000002ae <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ae:	4891                	li	a7,4
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <read>:
.global read
read:
 li a7, SYS_read
 2b6:	4895                	li	a7,5
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <write>:
.global write
write:
 li a7, SYS_write
 2be:	48c1                	li	a7,16
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <close>:
.global close
close:
 li a7, SYS_close
 2c6:	48d5                	li	a7,21
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ce:	4899                	li	a7,6
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2d6:	489d                	li	a7,7
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <open>:
.global open
open:
 li a7, SYS_open
 2de:	48bd                	li	a7,15
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2e6:	48c5                	li	a7,17
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2ee:	48c9                	li	a7,18
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2f6:	48a1                	li	a7,8
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <link>:
.global link
link:
 li a7, SYS_link
 2fe:	48cd                	li	a7,19
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 306:	48d1                	li	a7,20
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 30e:	48a5                	li	a7,9
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <dup>:
.global dup
dup:
 li a7, SYS_dup
 316:	48a9                	li	a7,10
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 31e:	48ad                	li	a7,11
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 326:	48b1                	li	a7,12
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 32e:	48b5                	li	a7,13
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 336:	48b9                	li	a7,14
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 33e:	48d9                	li	a7,22
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 346:	48dd                	li	a7,23
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 34e:	1101                	addi	sp,sp,-32
 350:	ec06                	sd	ra,24(sp)
 352:	e822                	sd	s0,16(sp)
 354:	1000                	addi	s0,sp,32
 356:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 35a:	4605                	li	a2,1
 35c:	fef40593          	addi	a1,s0,-17
 360:	00000097          	auipc	ra,0x0
 364:	f5e080e7          	jalr	-162(ra) # 2be <write>
}
 368:	60e2                	ld	ra,24(sp)
 36a:	6442                	ld	s0,16(sp)
 36c:	6105                	addi	sp,sp,32
 36e:	8082                	ret

0000000000000370 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 370:	7139                	addi	sp,sp,-64
 372:	fc06                	sd	ra,56(sp)
 374:	f822                	sd	s0,48(sp)
 376:	f426                	sd	s1,40(sp)
 378:	f04a                	sd	s2,32(sp)
 37a:	ec4e                	sd	s3,24(sp)
 37c:	0080                	addi	s0,sp,64
 37e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 380:	c299                	beqz	a3,386 <printint+0x16>
 382:	0805c863          	bltz	a1,412 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 386:	2581                	sext.w	a1,a1
  neg = 0;
 388:	4881                	li	a7,0
 38a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 38e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 390:	2601                	sext.w	a2,a2
 392:	00000517          	auipc	a0,0x0
 396:	44e50513          	addi	a0,a0,1102 # 7e0 <digits>
 39a:	883a                	mv	a6,a4
 39c:	2705                	addiw	a4,a4,1
 39e:	02c5f7bb          	remuw	a5,a1,a2
 3a2:	1782                	slli	a5,a5,0x20
 3a4:	9381                	srli	a5,a5,0x20
 3a6:	97aa                	add	a5,a5,a0
 3a8:	0007c783          	lbu	a5,0(a5)
 3ac:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3b0:	0005879b          	sext.w	a5,a1
 3b4:	02c5d5bb          	divuw	a1,a1,a2
 3b8:	0685                	addi	a3,a3,1
 3ba:	fec7f0e3          	bgeu	a5,a2,39a <printint+0x2a>
  if(neg)
 3be:	00088b63          	beqz	a7,3d4 <printint+0x64>
    buf[i++] = '-';
 3c2:	fd040793          	addi	a5,s0,-48
 3c6:	973e                	add	a4,a4,a5
 3c8:	02d00793          	li	a5,45
 3cc:	fef70823          	sb	a5,-16(a4)
 3d0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3d4:	02e05863          	blez	a4,404 <printint+0x94>
 3d8:	fc040793          	addi	a5,s0,-64
 3dc:	00e78933          	add	s2,a5,a4
 3e0:	fff78993          	addi	s3,a5,-1
 3e4:	99ba                	add	s3,s3,a4
 3e6:	377d                	addiw	a4,a4,-1
 3e8:	1702                	slli	a4,a4,0x20
 3ea:	9301                	srli	a4,a4,0x20
 3ec:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3f0:	fff94583          	lbu	a1,-1(s2)
 3f4:	8526                	mv	a0,s1
 3f6:	00000097          	auipc	ra,0x0
 3fa:	f58080e7          	jalr	-168(ra) # 34e <putc>
  while(--i >= 0)
 3fe:	197d                	addi	s2,s2,-1
 400:	ff3918e3          	bne	s2,s3,3f0 <printint+0x80>
}
 404:	70e2                	ld	ra,56(sp)
 406:	7442                	ld	s0,48(sp)
 408:	74a2                	ld	s1,40(sp)
 40a:	7902                	ld	s2,32(sp)
 40c:	69e2                	ld	s3,24(sp)
 40e:	6121                	addi	sp,sp,64
 410:	8082                	ret
    x = -xx;
 412:	40b005bb          	negw	a1,a1
    neg = 1;
 416:	4885                	li	a7,1
    x = -xx;
 418:	bf8d                	j	38a <printint+0x1a>

000000000000041a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 41a:	7119                	addi	sp,sp,-128
 41c:	fc86                	sd	ra,120(sp)
 41e:	f8a2                	sd	s0,112(sp)
 420:	f4a6                	sd	s1,104(sp)
 422:	f0ca                	sd	s2,96(sp)
 424:	ecce                	sd	s3,88(sp)
 426:	e8d2                	sd	s4,80(sp)
 428:	e4d6                	sd	s5,72(sp)
 42a:	e0da                	sd	s6,64(sp)
 42c:	fc5e                	sd	s7,56(sp)
 42e:	f862                	sd	s8,48(sp)
 430:	f466                	sd	s9,40(sp)
 432:	f06a                	sd	s10,32(sp)
 434:	ec6e                	sd	s11,24(sp)
 436:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 438:	0005c903          	lbu	s2,0(a1)
 43c:	18090f63          	beqz	s2,5da <vprintf+0x1c0>
 440:	8aaa                	mv	s5,a0
 442:	8b32                	mv	s6,a2
 444:	00158493          	addi	s1,a1,1
  state = 0;
 448:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 44a:	02500a13          	li	s4,37
      if(c == 'd'){
 44e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 452:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 456:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 45a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 45e:	00000b97          	auipc	s7,0x0
 462:	382b8b93          	addi	s7,s7,898 # 7e0 <digits>
 466:	a839                	j	484 <vprintf+0x6a>
        putc(fd, c);
 468:	85ca                	mv	a1,s2
 46a:	8556                	mv	a0,s5
 46c:	00000097          	auipc	ra,0x0
 470:	ee2080e7          	jalr	-286(ra) # 34e <putc>
 474:	a019                	j	47a <vprintf+0x60>
    } else if(state == '%'){
 476:	01498f63          	beq	s3,s4,494 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 47a:	0485                	addi	s1,s1,1
 47c:	fff4c903          	lbu	s2,-1(s1)
 480:	14090d63          	beqz	s2,5da <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 484:	0009079b          	sext.w	a5,s2
    if(state == 0){
 488:	fe0997e3          	bnez	s3,476 <vprintf+0x5c>
      if(c == '%'){
 48c:	fd479ee3          	bne	a5,s4,468 <vprintf+0x4e>
        state = '%';
 490:	89be                	mv	s3,a5
 492:	b7e5                	j	47a <vprintf+0x60>
      if(c == 'd'){
 494:	05878063          	beq	a5,s8,4d4 <vprintf+0xba>
      } else if(c == 'l') {
 498:	05978c63          	beq	a5,s9,4f0 <vprintf+0xd6>
      } else if(c == 'x') {
 49c:	07a78863          	beq	a5,s10,50c <vprintf+0xf2>
      } else if(c == 'p') {
 4a0:	09b78463          	beq	a5,s11,528 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4a4:	07300713          	li	a4,115
 4a8:	0ce78663          	beq	a5,a4,574 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4ac:	06300713          	li	a4,99
 4b0:	0ee78e63          	beq	a5,a4,5ac <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4b4:	11478863          	beq	a5,s4,5c4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4b8:	85d2                	mv	a1,s4
 4ba:	8556                	mv	a0,s5
 4bc:	00000097          	auipc	ra,0x0
 4c0:	e92080e7          	jalr	-366(ra) # 34e <putc>
        putc(fd, c);
 4c4:	85ca                	mv	a1,s2
 4c6:	8556                	mv	a0,s5
 4c8:	00000097          	auipc	ra,0x0
 4cc:	e86080e7          	jalr	-378(ra) # 34e <putc>
      }
      state = 0;
 4d0:	4981                	li	s3,0
 4d2:	b765                	j	47a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 4d4:	008b0913          	addi	s2,s6,8
 4d8:	4685                	li	a3,1
 4da:	4629                	li	a2,10
 4dc:	000b2583          	lw	a1,0(s6)
 4e0:	8556                	mv	a0,s5
 4e2:	00000097          	auipc	ra,0x0
 4e6:	e8e080e7          	jalr	-370(ra) # 370 <printint>
 4ea:	8b4a                	mv	s6,s2
      state = 0;
 4ec:	4981                	li	s3,0
 4ee:	b771                	j	47a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4f0:	008b0913          	addi	s2,s6,8
 4f4:	4681                	li	a3,0
 4f6:	4629                	li	a2,10
 4f8:	000b2583          	lw	a1,0(s6)
 4fc:	8556                	mv	a0,s5
 4fe:	00000097          	auipc	ra,0x0
 502:	e72080e7          	jalr	-398(ra) # 370 <printint>
 506:	8b4a                	mv	s6,s2
      state = 0;
 508:	4981                	li	s3,0
 50a:	bf85                	j	47a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 50c:	008b0913          	addi	s2,s6,8
 510:	4681                	li	a3,0
 512:	4641                	li	a2,16
 514:	000b2583          	lw	a1,0(s6)
 518:	8556                	mv	a0,s5
 51a:	00000097          	auipc	ra,0x0
 51e:	e56080e7          	jalr	-426(ra) # 370 <printint>
 522:	8b4a                	mv	s6,s2
      state = 0;
 524:	4981                	li	s3,0
 526:	bf91                	j	47a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 528:	008b0793          	addi	a5,s6,8
 52c:	f8f43423          	sd	a5,-120(s0)
 530:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 534:	03000593          	li	a1,48
 538:	8556                	mv	a0,s5
 53a:	00000097          	auipc	ra,0x0
 53e:	e14080e7          	jalr	-492(ra) # 34e <putc>
  putc(fd, 'x');
 542:	85ea                	mv	a1,s10
 544:	8556                	mv	a0,s5
 546:	00000097          	auipc	ra,0x0
 54a:	e08080e7          	jalr	-504(ra) # 34e <putc>
 54e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 550:	03c9d793          	srli	a5,s3,0x3c
 554:	97de                	add	a5,a5,s7
 556:	0007c583          	lbu	a1,0(a5)
 55a:	8556                	mv	a0,s5
 55c:	00000097          	auipc	ra,0x0
 560:	df2080e7          	jalr	-526(ra) # 34e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 564:	0992                	slli	s3,s3,0x4
 566:	397d                	addiw	s2,s2,-1
 568:	fe0914e3          	bnez	s2,550 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 56c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 570:	4981                	li	s3,0
 572:	b721                	j	47a <vprintf+0x60>
        s = va_arg(ap, char*);
 574:	008b0993          	addi	s3,s6,8
 578:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 57c:	02090163          	beqz	s2,59e <vprintf+0x184>
        while(*s != 0){
 580:	00094583          	lbu	a1,0(s2)
 584:	c9a1                	beqz	a1,5d4 <vprintf+0x1ba>
          putc(fd, *s);
 586:	8556                	mv	a0,s5
 588:	00000097          	auipc	ra,0x0
 58c:	dc6080e7          	jalr	-570(ra) # 34e <putc>
          s++;
 590:	0905                	addi	s2,s2,1
        while(*s != 0){
 592:	00094583          	lbu	a1,0(s2)
 596:	f9e5                	bnez	a1,586 <vprintf+0x16c>
        s = va_arg(ap, char*);
 598:	8b4e                	mv	s6,s3
      state = 0;
 59a:	4981                	li	s3,0
 59c:	bdf9                	j	47a <vprintf+0x60>
          s = "(null)";
 59e:	00000917          	auipc	s2,0x0
 5a2:	23a90913          	addi	s2,s2,570 # 7d8 <malloc+0xf4>
        while(*s != 0){
 5a6:	02800593          	li	a1,40
 5aa:	bff1                	j	586 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5ac:	008b0913          	addi	s2,s6,8
 5b0:	000b4583          	lbu	a1,0(s6)
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	d98080e7          	jalr	-616(ra) # 34e <putc>
 5be:	8b4a                	mv	s6,s2
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	bd65                	j	47a <vprintf+0x60>
        putc(fd, c);
 5c4:	85d2                	mv	a1,s4
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	d86080e7          	jalr	-634(ra) # 34e <putc>
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b565                	j	47a <vprintf+0x60>
        s = va_arg(ap, char*);
 5d4:	8b4e                	mv	s6,s3
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	b54d                	j	47a <vprintf+0x60>
    }
  }
}
 5da:	70e6                	ld	ra,120(sp)
 5dc:	7446                	ld	s0,112(sp)
 5de:	74a6                	ld	s1,104(sp)
 5e0:	7906                	ld	s2,96(sp)
 5e2:	69e6                	ld	s3,88(sp)
 5e4:	6a46                	ld	s4,80(sp)
 5e6:	6aa6                	ld	s5,72(sp)
 5e8:	6b06                	ld	s6,64(sp)
 5ea:	7be2                	ld	s7,56(sp)
 5ec:	7c42                	ld	s8,48(sp)
 5ee:	7ca2                	ld	s9,40(sp)
 5f0:	7d02                	ld	s10,32(sp)
 5f2:	6de2                	ld	s11,24(sp)
 5f4:	6109                	addi	sp,sp,128
 5f6:	8082                	ret

00000000000005f8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5f8:	715d                	addi	sp,sp,-80
 5fa:	ec06                	sd	ra,24(sp)
 5fc:	e822                	sd	s0,16(sp)
 5fe:	1000                	addi	s0,sp,32
 600:	e010                	sd	a2,0(s0)
 602:	e414                	sd	a3,8(s0)
 604:	e818                	sd	a4,16(s0)
 606:	ec1c                	sd	a5,24(s0)
 608:	03043023          	sd	a6,32(s0)
 60c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 610:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 614:	8622                	mv	a2,s0
 616:	00000097          	auipc	ra,0x0
 61a:	e04080e7          	jalr	-508(ra) # 41a <vprintf>
}
 61e:	60e2                	ld	ra,24(sp)
 620:	6442                	ld	s0,16(sp)
 622:	6161                	addi	sp,sp,80
 624:	8082                	ret

0000000000000626 <printf>:

void
printf(const char *fmt, ...)
{
 626:	711d                	addi	sp,sp,-96
 628:	ec06                	sd	ra,24(sp)
 62a:	e822                	sd	s0,16(sp)
 62c:	1000                	addi	s0,sp,32
 62e:	e40c                	sd	a1,8(s0)
 630:	e810                	sd	a2,16(s0)
 632:	ec14                	sd	a3,24(s0)
 634:	f018                	sd	a4,32(s0)
 636:	f41c                	sd	a5,40(s0)
 638:	03043823          	sd	a6,48(s0)
 63c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 640:	00840613          	addi	a2,s0,8
 644:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 648:	85aa                	mv	a1,a0
 64a:	4505                	li	a0,1
 64c:	00000097          	auipc	ra,0x0
 650:	dce080e7          	jalr	-562(ra) # 41a <vprintf>
}
 654:	60e2                	ld	ra,24(sp)
 656:	6442                	ld	s0,16(sp)
 658:	6125                	addi	sp,sp,96
 65a:	8082                	ret

000000000000065c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 65c:	1141                	addi	sp,sp,-16
 65e:	e422                	sd	s0,8(sp)
 660:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 662:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 666:	00000797          	auipc	a5,0x0
 66a:	1927b783          	ld	a5,402(a5) # 7f8 <freep>
 66e:	a805                	j	69e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 670:	4618                	lw	a4,8(a2)
 672:	9db9                	addw	a1,a1,a4
 674:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 678:	6398                	ld	a4,0(a5)
 67a:	6318                	ld	a4,0(a4)
 67c:	fee53823          	sd	a4,-16(a0)
 680:	a091                	j	6c4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 682:	ff852703          	lw	a4,-8(a0)
 686:	9e39                	addw	a2,a2,a4
 688:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 68a:	ff053703          	ld	a4,-16(a0)
 68e:	e398                	sd	a4,0(a5)
 690:	a099                	j	6d6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 692:	6398                	ld	a4,0(a5)
 694:	00e7e463          	bltu	a5,a4,69c <free+0x40>
 698:	00e6ea63          	bltu	a3,a4,6ac <free+0x50>
{
 69c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69e:	fed7fae3          	bgeu	a5,a3,692 <free+0x36>
 6a2:	6398                	ld	a4,0(a5)
 6a4:	00e6e463          	bltu	a3,a4,6ac <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a8:	fee7eae3          	bltu	a5,a4,69c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6ac:	ff852583          	lw	a1,-8(a0)
 6b0:	6390                	ld	a2,0(a5)
 6b2:	02059713          	slli	a4,a1,0x20
 6b6:	9301                	srli	a4,a4,0x20
 6b8:	0712                	slli	a4,a4,0x4
 6ba:	9736                	add	a4,a4,a3
 6bc:	fae60ae3          	beq	a2,a4,670 <free+0x14>
    bp->s.ptr = p->s.ptr;
 6c0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6c4:	4790                	lw	a2,8(a5)
 6c6:	02061713          	slli	a4,a2,0x20
 6ca:	9301                	srli	a4,a4,0x20
 6cc:	0712                	slli	a4,a4,0x4
 6ce:	973e                	add	a4,a4,a5
 6d0:	fae689e3          	beq	a3,a4,682 <free+0x26>
  } else
    p->s.ptr = bp;
 6d4:	e394                	sd	a3,0(a5)
  freep = p;
 6d6:	00000717          	auipc	a4,0x0
 6da:	12f73123          	sd	a5,290(a4) # 7f8 <freep>
}
 6de:	6422                	ld	s0,8(sp)
 6e0:	0141                	addi	sp,sp,16
 6e2:	8082                	ret

00000000000006e4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6e4:	7139                	addi	sp,sp,-64
 6e6:	fc06                	sd	ra,56(sp)
 6e8:	f822                	sd	s0,48(sp)
 6ea:	f426                	sd	s1,40(sp)
 6ec:	f04a                	sd	s2,32(sp)
 6ee:	ec4e                	sd	s3,24(sp)
 6f0:	e852                	sd	s4,16(sp)
 6f2:	e456                	sd	s5,8(sp)
 6f4:	e05a                	sd	s6,0(sp)
 6f6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f8:	02051493          	slli	s1,a0,0x20
 6fc:	9081                	srli	s1,s1,0x20
 6fe:	04bd                	addi	s1,s1,15
 700:	8091                	srli	s1,s1,0x4
 702:	0014899b          	addiw	s3,s1,1
 706:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 708:	00000517          	auipc	a0,0x0
 70c:	0f053503          	ld	a0,240(a0) # 7f8 <freep>
 710:	c515                	beqz	a0,73c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 712:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 714:	4798                	lw	a4,8(a5)
 716:	02977f63          	bgeu	a4,s1,754 <malloc+0x70>
 71a:	8a4e                	mv	s4,s3
 71c:	0009871b          	sext.w	a4,s3
 720:	6685                	lui	a3,0x1
 722:	00d77363          	bgeu	a4,a3,728 <malloc+0x44>
 726:	6a05                	lui	s4,0x1
 728:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 72c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 730:	00000917          	auipc	s2,0x0
 734:	0c890913          	addi	s2,s2,200 # 7f8 <freep>
  if(p == (char*)-1)
 738:	5afd                	li	s5,-1
 73a:	a88d                	j	7ac <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 73c:	00000797          	auipc	a5,0x0
 740:	0c478793          	addi	a5,a5,196 # 800 <base>
 744:	00000717          	auipc	a4,0x0
 748:	0af73a23          	sd	a5,180(a4) # 7f8 <freep>
 74c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 74e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 752:	b7e1                	j	71a <malloc+0x36>
      if(p->s.size == nunits)
 754:	02e48b63          	beq	s1,a4,78a <malloc+0xa6>
        p->s.size -= nunits;
 758:	4137073b          	subw	a4,a4,s3
 75c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 75e:	1702                	slli	a4,a4,0x20
 760:	9301                	srli	a4,a4,0x20
 762:	0712                	slli	a4,a4,0x4
 764:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 766:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 76a:	00000717          	auipc	a4,0x0
 76e:	08a73723          	sd	a0,142(a4) # 7f8 <freep>
      return (void*)(p + 1);
 772:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 776:	70e2                	ld	ra,56(sp)
 778:	7442                	ld	s0,48(sp)
 77a:	74a2                	ld	s1,40(sp)
 77c:	7902                	ld	s2,32(sp)
 77e:	69e2                	ld	s3,24(sp)
 780:	6a42                	ld	s4,16(sp)
 782:	6aa2                	ld	s5,8(sp)
 784:	6b02                	ld	s6,0(sp)
 786:	6121                	addi	sp,sp,64
 788:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 78a:	6398                	ld	a4,0(a5)
 78c:	e118                	sd	a4,0(a0)
 78e:	bff1                	j	76a <malloc+0x86>
  hp->s.size = nu;
 790:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 794:	0541                	addi	a0,a0,16
 796:	00000097          	auipc	ra,0x0
 79a:	ec6080e7          	jalr	-314(ra) # 65c <free>
  return freep;
 79e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7a2:	d971                	beqz	a0,776 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a6:	4798                	lw	a4,8(a5)
 7a8:	fa9776e3          	bgeu	a4,s1,754 <malloc+0x70>
    if(p == freep)
 7ac:	00093703          	ld	a4,0(s2)
 7b0:	853e                	mv	a0,a5
 7b2:	fef719e3          	bne	a4,a5,7a4 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7b6:	8552                	mv	a0,s4
 7b8:	00000097          	auipc	ra,0x0
 7bc:	b6e080e7          	jalr	-1170(ra) # 326 <sbrk>
  if(p == (char*)-1)
 7c0:	fd5518e3          	bne	a0,s5,790 <malloc+0xac>
        return 0;
 7c4:	4501                	li	a0,0
 7c6:	bf45                	j	776 <malloc+0x92>
