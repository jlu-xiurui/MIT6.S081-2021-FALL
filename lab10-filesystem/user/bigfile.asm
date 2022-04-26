
user/_bigfile:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fcntl.h"
#include "kernel/fs.h"

int
main()
{
   0:	bd010113          	addi	sp,sp,-1072
   4:	42113423          	sd	ra,1064(sp)
   8:	42813023          	sd	s0,1056(sp)
   c:	40913c23          	sd	s1,1048(sp)
  10:	41213823          	sd	s2,1040(sp)
  14:	41313423          	sd	s3,1032(sp)
  18:	41413023          	sd	s4,1024(sp)
  1c:	43010413          	addi	s0,sp,1072
  char buf[BSIZE];
  int fd, i, blocks;

  fd = open("big.file", O_CREATE | O_WRONLY);
  20:	20100593          	li	a1,513
  24:	00001517          	auipc	a0,0x1
  28:	8fc50513          	addi	a0,a0,-1796 # 920 <malloc+0xe4>
  2c:	00000097          	auipc	ra,0x0
  30:	412080e7          	jalr	1042(ra) # 43e <open>
  if(fd < 0){
  34:	00054b63          	bltz	a0,4a <main+0x4a>
  38:	892a                	mv	s2,a0
  3a:	4481                	li	s1,0
    *(int*)buf = blocks;
    int cc = write(fd, buf, sizeof(buf));
    if(cc <= 0)
      break;
    blocks++;
    if (blocks % 100 == 0)
  3c:	06400993          	li	s3,100
      printf(".");
  40:	00001a17          	auipc	s4,0x1
  44:	920a0a13          	addi	s4,s4,-1760 # 960 <malloc+0x124>
  48:	a01d                	j	6e <main+0x6e>
    printf("bigfile: cannot open big.file for writing\n");
  4a:	00001517          	auipc	a0,0x1
  4e:	8e650513          	addi	a0,a0,-1818 # 930 <malloc+0xf4>
  52:	00000097          	auipc	ra,0x0
  56:	72c080e7          	jalr	1836(ra) # 77e <printf>
    exit(-1);
  5a:	557d                	li	a0,-1
  5c:	00000097          	auipc	ra,0x0
  60:	3a2080e7          	jalr	930(ra) # 3fe <exit>
      printf(".");
  64:	8552                	mv	a0,s4
  66:	00000097          	auipc	ra,0x0
  6a:	718080e7          	jalr	1816(ra) # 77e <printf>
    *(int*)buf = blocks;
  6e:	bc942823          	sw	s1,-1072(s0)
    int cc = write(fd, buf, sizeof(buf));
  72:	40000613          	li	a2,1024
  76:	bd040593          	addi	a1,s0,-1072
  7a:	854a                	mv	a0,s2
  7c:	00000097          	auipc	ra,0x0
  80:	3a2080e7          	jalr	930(ra) # 41e <write>
    if(cc <= 0)
  84:	00a05a63          	blez	a0,98 <main+0x98>
    blocks++;
  88:	0014879b          	addiw	a5,s1,1
  8c:	0007849b          	sext.w	s1,a5
    if (blocks % 100 == 0)
  90:	0337e7bb          	remw	a5,a5,s3
  94:	ffe9                	bnez	a5,6e <main+0x6e>
  96:	b7f9                	j	64 <main+0x64>
  }

  printf("\nwrote %d blocks\n", blocks);
  98:	85a6                	mv	a1,s1
  9a:	00001517          	auipc	a0,0x1
  9e:	8ce50513          	addi	a0,a0,-1842 # 968 <malloc+0x12c>
  a2:	00000097          	auipc	ra,0x0
  a6:	6dc080e7          	jalr	1756(ra) # 77e <printf>
  if(blocks != 65803) {
  aa:	67c1                	lui	a5,0x10
  ac:	10b78793          	addi	a5,a5,267 # 1010b <__global_pointer$+0xeeb2>
  b0:	00f48f63          	beq	s1,a5,ce <main+0xce>
    printf("bigfile: file is too small\n");
  b4:	00001517          	auipc	a0,0x1
  b8:	8cc50513          	addi	a0,a0,-1844 # 980 <malloc+0x144>
  bc:	00000097          	auipc	ra,0x0
  c0:	6c2080e7          	jalr	1730(ra) # 77e <printf>
    exit(-1);
  c4:	557d                	li	a0,-1
  c6:	00000097          	auipc	ra,0x0
  ca:	338080e7          	jalr	824(ra) # 3fe <exit>
  }
  
  close(fd);
  ce:	854a                	mv	a0,s2
  d0:	00000097          	auipc	ra,0x0
  d4:	356080e7          	jalr	854(ra) # 426 <close>
  fd = open("big.file", O_RDONLY);
  d8:	4581                	li	a1,0
  da:	00001517          	auipc	a0,0x1
  de:	84650513          	addi	a0,a0,-1978 # 920 <malloc+0xe4>
  e2:	00000097          	auipc	ra,0x0
  e6:	35c080e7          	jalr	860(ra) # 43e <open>
  ea:	892a                	mv	s2,a0
  if(fd < 0){
    printf("bigfile: cannot re-open big.file for reading\n");
    exit(-1);
  }
  for(i = 0; i < blocks; i++){
  ec:	4481                	li	s1,0
  if(fd < 0){
  ee:	04054463          	bltz	a0,136 <main+0x136>
  for(i = 0; i < blocks; i++){
  f2:	69c1                	lui	s3,0x10
  f4:	10b98993          	addi	s3,s3,267 # 1010b <__global_pointer$+0xeeb2>
    int cc = read(fd, buf, sizeof(buf));
  f8:	40000613          	li	a2,1024
  fc:	bd040593          	addi	a1,s0,-1072
 100:	854a                	mv	a0,s2
 102:	00000097          	auipc	ra,0x0
 106:	314080e7          	jalr	788(ra) # 416 <read>
    if(cc <= 0){
 10a:	04a05363          	blez	a0,150 <main+0x150>
      printf("bigfile: read error at block %d\n", i);
      exit(-1);
    }
    if(*(int*)buf != i){
 10e:	bd042583          	lw	a1,-1072(s0)
 112:	04959d63          	bne	a1,s1,16c <main+0x16c>
  for(i = 0; i < blocks; i++){
 116:	2485                	addiw	s1,s1,1
 118:	ff3490e3          	bne	s1,s3,f8 <main+0xf8>
             *(int*)buf, i);
      exit(-1);
    }
  }

  printf("bigfile done; ok\n"); 
 11c:	00001517          	auipc	a0,0x1
 120:	90c50513          	addi	a0,a0,-1780 # a28 <malloc+0x1ec>
 124:	00000097          	auipc	ra,0x0
 128:	65a080e7          	jalr	1626(ra) # 77e <printf>

  exit(0);
 12c:	4501                	li	a0,0
 12e:	00000097          	auipc	ra,0x0
 132:	2d0080e7          	jalr	720(ra) # 3fe <exit>
    printf("bigfile: cannot re-open big.file for reading\n");
 136:	00001517          	auipc	a0,0x1
 13a:	86a50513          	addi	a0,a0,-1942 # 9a0 <malloc+0x164>
 13e:	00000097          	auipc	ra,0x0
 142:	640080e7          	jalr	1600(ra) # 77e <printf>
    exit(-1);
 146:	557d                	li	a0,-1
 148:	00000097          	auipc	ra,0x0
 14c:	2b6080e7          	jalr	694(ra) # 3fe <exit>
      printf("bigfile: read error at block %d\n", i);
 150:	85a6                	mv	a1,s1
 152:	00001517          	auipc	a0,0x1
 156:	87e50513          	addi	a0,a0,-1922 # 9d0 <malloc+0x194>
 15a:	00000097          	auipc	ra,0x0
 15e:	624080e7          	jalr	1572(ra) # 77e <printf>
      exit(-1);
 162:	557d                	li	a0,-1
 164:	00000097          	auipc	ra,0x0
 168:	29a080e7          	jalr	666(ra) # 3fe <exit>
      printf("bigfile: read the wrong data (%d) for block %d\n",
 16c:	8626                	mv	a2,s1
 16e:	00001517          	auipc	a0,0x1
 172:	88a50513          	addi	a0,a0,-1910 # 9f8 <malloc+0x1bc>
 176:	00000097          	auipc	ra,0x0
 17a:	608080e7          	jalr	1544(ra) # 77e <printf>
      exit(-1);
 17e:	557d                	li	a0,-1
 180:	00000097          	auipc	ra,0x0
 184:	27e080e7          	jalr	638(ra) # 3fe <exit>

0000000000000188 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 188:	1141                	addi	sp,sp,-16
 18a:	e422                	sd	s0,8(sp)
 18c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 18e:	87aa                	mv	a5,a0
 190:	0585                	addi	a1,a1,1
 192:	0785                	addi	a5,a5,1
 194:	fff5c703          	lbu	a4,-1(a1)
 198:	fee78fa3          	sb	a4,-1(a5)
 19c:	fb75                	bnez	a4,190 <strcpy+0x8>
    ;
  return os;
}
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	cb91                	beqz	a5,1c2 <strcmp+0x1e>
 1b0:	0005c703          	lbu	a4,0(a1)
 1b4:	00f71763          	bne	a4,a5,1c2 <strcmp+0x1e>
    p++, q++;
 1b8:	0505                	addi	a0,a0,1
 1ba:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	fbe5                	bnez	a5,1b0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1c2:	0005c503          	lbu	a0,0(a1)
}
 1c6:	40a7853b          	subw	a0,a5,a0
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	addi	sp,sp,16
 1ce:	8082                	ret

00000000000001d0 <strlen>:

uint
strlen(const char *s)
{
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e422                	sd	s0,8(sp)
 1d4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1d6:	00054783          	lbu	a5,0(a0)
 1da:	cf91                	beqz	a5,1f6 <strlen+0x26>
 1dc:	0505                	addi	a0,a0,1
 1de:	87aa                	mv	a5,a0
 1e0:	4685                	li	a3,1
 1e2:	9e89                	subw	a3,a3,a0
 1e4:	00f6853b          	addw	a0,a3,a5
 1e8:	0785                	addi	a5,a5,1
 1ea:	fff7c703          	lbu	a4,-1(a5)
 1ee:	fb7d                	bnez	a4,1e4 <strlen+0x14>
    ;
  return n;
}
 1f0:	6422                	ld	s0,8(sp)
 1f2:	0141                	addi	sp,sp,16
 1f4:	8082                	ret
  for(n = 0; s[n]; n++)
 1f6:	4501                	li	a0,0
 1f8:	bfe5                	j	1f0 <strlen+0x20>

00000000000001fa <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fa:	1141                	addi	sp,sp,-16
 1fc:	e422                	sd	s0,8(sp)
 1fe:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 200:	ce09                	beqz	a2,21a <memset+0x20>
 202:	87aa                	mv	a5,a0
 204:	fff6071b          	addiw	a4,a2,-1
 208:	1702                	slli	a4,a4,0x20
 20a:	9301                	srli	a4,a4,0x20
 20c:	0705                	addi	a4,a4,1
 20e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 210:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 214:	0785                	addi	a5,a5,1
 216:	fee79de3          	bne	a5,a4,210 <memset+0x16>
  }
  return dst;
}
 21a:	6422                	ld	s0,8(sp)
 21c:	0141                	addi	sp,sp,16
 21e:	8082                	ret

0000000000000220 <strchr>:

char*
strchr(const char *s, char c)
{
 220:	1141                	addi	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	addi	s0,sp,16
  for(; *s; s++)
 226:	00054783          	lbu	a5,0(a0)
 22a:	cb99                	beqz	a5,240 <strchr+0x20>
    if(*s == c)
 22c:	00f58763          	beq	a1,a5,23a <strchr+0x1a>
  for(; *s; s++)
 230:	0505                	addi	a0,a0,1
 232:	00054783          	lbu	a5,0(a0)
 236:	fbfd                	bnez	a5,22c <strchr+0xc>
      return (char*)s;
  return 0;
 238:	4501                	li	a0,0
}
 23a:	6422                	ld	s0,8(sp)
 23c:	0141                	addi	sp,sp,16
 23e:	8082                	ret
  return 0;
 240:	4501                	li	a0,0
 242:	bfe5                	j	23a <strchr+0x1a>

0000000000000244 <gets>:

char*
gets(char *buf, int max)
{
 244:	711d                	addi	sp,sp,-96
 246:	ec86                	sd	ra,88(sp)
 248:	e8a2                	sd	s0,80(sp)
 24a:	e4a6                	sd	s1,72(sp)
 24c:	e0ca                	sd	s2,64(sp)
 24e:	fc4e                	sd	s3,56(sp)
 250:	f852                	sd	s4,48(sp)
 252:	f456                	sd	s5,40(sp)
 254:	f05a                	sd	s6,32(sp)
 256:	ec5e                	sd	s7,24(sp)
 258:	1080                	addi	s0,sp,96
 25a:	8baa                	mv	s7,a0
 25c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25e:	892a                	mv	s2,a0
 260:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 262:	4aa9                	li	s5,10
 264:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 266:	89a6                	mv	s3,s1
 268:	2485                	addiw	s1,s1,1
 26a:	0344d863          	bge	s1,s4,29a <gets+0x56>
    cc = read(0, &c, 1);
 26e:	4605                	li	a2,1
 270:	faf40593          	addi	a1,s0,-81
 274:	4501                	li	a0,0
 276:	00000097          	auipc	ra,0x0
 27a:	1a0080e7          	jalr	416(ra) # 416 <read>
    if(cc < 1)
 27e:	00a05e63          	blez	a0,29a <gets+0x56>
    buf[i++] = c;
 282:	faf44783          	lbu	a5,-81(s0)
 286:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 28a:	01578763          	beq	a5,s5,298 <gets+0x54>
 28e:	0905                	addi	s2,s2,1
 290:	fd679be3          	bne	a5,s6,266 <gets+0x22>
  for(i=0; i+1 < max; ){
 294:	89a6                	mv	s3,s1
 296:	a011                	j	29a <gets+0x56>
 298:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 29a:	99de                	add	s3,s3,s7
 29c:	00098023          	sb	zero,0(s3)
  return buf;
}
 2a0:	855e                	mv	a0,s7
 2a2:	60e6                	ld	ra,88(sp)
 2a4:	6446                	ld	s0,80(sp)
 2a6:	64a6                	ld	s1,72(sp)
 2a8:	6906                	ld	s2,64(sp)
 2aa:	79e2                	ld	s3,56(sp)
 2ac:	7a42                	ld	s4,48(sp)
 2ae:	7aa2                	ld	s5,40(sp)
 2b0:	7b02                	ld	s6,32(sp)
 2b2:	6be2                	ld	s7,24(sp)
 2b4:	6125                	addi	sp,sp,96
 2b6:	8082                	ret

00000000000002b8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b8:	1101                	addi	sp,sp,-32
 2ba:	ec06                	sd	ra,24(sp)
 2bc:	e822                	sd	s0,16(sp)
 2be:	e426                	sd	s1,8(sp)
 2c0:	e04a                	sd	s2,0(sp)
 2c2:	1000                	addi	s0,sp,32
 2c4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c6:	4581                	li	a1,0
 2c8:	00000097          	auipc	ra,0x0
 2cc:	176080e7          	jalr	374(ra) # 43e <open>
  if(fd < 0)
 2d0:	02054563          	bltz	a0,2fa <stat+0x42>
 2d4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d6:	85ca                	mv	a1,s2
 2d8:	00000097          	auipc	ra,0x0
 2dc:	17e080e7          	jalr	382(ra) # 456 <fstat>
 2e0:	892a                	mv	s2,a0
  close(fd);
 2e2:	8526                	mv	a0,s1
 2e4:	00000097          	auipc	ra,0x0
 2e8:	142080e7          	jalr	322(ra) # 426 <close>
  return r;
}
 2ec:	854a                	mv	a0,s2
 2ee:	60e2                	ld	ra,24(sp)
 2f0:	6442                	ld	s0,16(sp)
 2f2:	64a2                	ld	s1,8(sp)
 2f4:	6902                	ld	s2,0(sp)
 2f6:	6105                	addi	sp,sp,32
 2f8:	8082                	ret
    return -1;
 2fa:	597d                	li	s2,-1
 2fc:	bfc5                	j	2ec <stat+0x34>

00000000000002fe <atoi>:

int
atoi(const char *s)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e422                	sd	s0,8(sp)
 302:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 304:	00054603          	lbu	a2,0(a0)
 308:	fd06079b          	addiw	a5,a2,-48
 30c:	0ff7f793          	andi	a5,a5,255
 310:	4725                	li	a4,9
 312:	02f76963          	bltu	a4,a5,344 <atoi+0x46>
 316:	86aa                	mv	a3,a0
  n = 0;
 318:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 31a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 31c:	0685                	addi	a3,a3,1
 31e:	0025179b          	slliw	a5,a0,0x2
 322:	9fa9                	addw	a5,a5,a0
 324:	0017979b          	slliw	a5,a5,0x1
 328:	9fb1                	addw	a5,a5,a2
 32a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 32e:	0006c603          	lbu	a2,0(a3)
 332:	fd06071b          	addiw	a4,a2,-48
 336:	0ff77713          	andi	a4,a4,255
 33a:	fee5f1e3          	bgeu	a1,a4,31c <atoi+0x1e>
  return n;
}
 33e:	6422                	ld	s0,8(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret
  n = 0;
 344:	4501                	li	a0,0
 346:	bfe5                	j	33e <atoi+0x40>

0000000000000348 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 348:	1141                	addi	sp,sp,-16
 34a:	e422                	sd	s0,8(sp)
 34c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 34e:	02b57663          	bgeu	a0,a1,37a <memmove+0x32>
    while(n-- > 0)
 352:	02c05163          	blez	a2,374 <memmove+0x2c>
 356:	fff6079b          	addiw	a5,a2,-1
 35a:	1782                	slli	a5,a5,0x20
 35c:	9381                	srli	a5,a5,0x20
 35e:	0785                	addi	a5,a5,1
 360:	97aa                	add	a5,a5,a0
  dst = vdst;
 362:	872a                	mv	a4,a0
      *dst++ = *src++;
 364:	0585                	addi	a1,a1,1
 366:	0705                	addi	a4,a4,1
 368:	fff5c683          	lbu	a3,-1(a1)
 36c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 370:	fee79ae3          	bne	a5,a4,364 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 374:	6422                	ld	s0,8(sp)
 376:	0141                	addi	sp,sp,16
 378:	8082                	ret
    dst += n;
 37a:	00c50733          	add	a4,a0,a2
    src += n;
 37e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 380:	fec05ae3          	blez	a2,374 <memmove+0x2c>
 384:	fff6079b          	addiw	a5,a2,-1
 388:	1782                	slli	a5,a5,0x20
 38a:	9381                	srli	a5,a5,0x20
 38c:	fff7c793          	not	a5,a5
 390:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 392:	15fd                	addi	a1,a1,-1
 394:	177d                	addi	a4,a4,-1
 396:	0005c683          	lbu	a3,0(a1)
 39a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 39e:	fee79ae3          	bne	a5,a4,392 <memmove+0x4a>
 3a2:	bfc9                	j	374 <memmove+0x2c>

00000000000003a4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3a4:	1141                	addi	sp,sp,-16
 3a6:	e422                	sd	s0,8(sp)
 3a8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3aa:	ca05                	beqz	a2,3da <memcmp+0x36>
 3ac:	fff6069b          	addiw	a3,a2,-1
 3b0:	1682                	slli	a3,a3,0x20
 3b2:	9281                	srli	a3,a3,0x20
 3b4:	0685                	addi	a3,a3,1
 3b6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3b8:	00054783          	lbu	a5,0(a0)
 3bc:	0005c703          	lbu	a4,0(a1)
 3c0:	00e79863          	bne	a5,a4,3d0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3c4:	0505                	addi	a0,a0,1
    p2++;
 3c6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3c8:	fed518e3          	bne	a0,a3,3b8 <memcmp+0x14>
  }
  return 0;
 3cc:	4501                	li	a0,0
 3ce:	a019                	j	3d4 <memcmp+0x30>
      return *p1 - *p2;
 3d0:	40e7853b          	subw	a0,a5,a4
}
 3d4:	6422                	ld	s0,8(sp)
 3d6:	0141                	addi	sp,sp,16
 3d8:	8082                	ret
  return 0;
 3da:	4501                	li	a0,0
 3dc:	bfe5                	j	3d4 <memcmp+0x30>

00000000000003de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3de:	1141                	addi	sp,sp,-16
 3e0:	e406                	sd	ra,8(sp)
 3e2:	e022                	sd	s0,0(sp)
 3e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3e6:	00000097          	auipc	ra,0x0
 3ea:	f62080e7          	jalr	-158(ra) # 348 <memmove>
}
 3ee:	60a2                	ld	ra,8(sp)
 3f0:	6402                	ld	s0,0(sp)
 3f2:	0141                	addi	sp,sp,16
 3f4:	8082                	ret

00000000000003f6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f6:	4885                	li	a7,1
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <exit>:
.global exit
exit:
 li a7, SYS_exit
 3fe:	4889                	li	a7,2
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <wait>:
.global wait
wait:
 li a7, SYS_wait
 406:	488d                	li	a7,3
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 40e:	4891                	li	a7,4
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <read>:
.global read
read:
 li a7, SYS_read
 416:	4895                	li	a7,5
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <write>:
.global write
write:
 li a7, SYS_write
 41e:	48c1                	li	a7,16
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <close>:
.global close
close:
 li a7, SYS_close
 426:	48d5                	li	a7,21
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <kill>:
.global kill
kill:
 li a7, SYS_kill
 42e:	4899                	li	a7,6
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <exec>:
.global exec
exec:
 li a7, SYS_exec
 436:	489d                	li	a7,7
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <open>:
.global open
open:
 li a7, SYS_open
 43e:	48bd                	li	a7,15
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 446:	48c5                	li	a7,17
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 44e:	48c9                	li	a7,18
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 456:	48a1                	li	a7,8
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <link>:
.global link
link:
 li a7, SYS_link
 45e:	48cd                	li	a7,19
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 466:	48d1                	li	a7,20
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 46e:	48a5                	li	a7,9
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <dup>:
.global dup
dup:
 li a7, SYS_dup
 476:	48a9                	li	a7,10
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 47e:	48ad                	li	a7,11
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 486:	48b1                	li	a7,12
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 48e:	48b5                	li	a7,13
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 496:	48b9                	li	a7,14
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 49e:	48d9                	li	a7,22
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4a6:	1101                	addi	sp,sp,-32
 4a8:	ec06                	sd	ra,24(sp)
 4aa:	e822                	sd	s0,16(sp)
 4ac:	1000                	addi	s0,sp,32
 4ae:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4b2:	4605                	li	a2,1
 4b4:	fef40593          	addi	a1,s0,-17
 4b8:	00000097          	auipc	ra,0x0
 4bc:	f66080e7          	jalr	-154(ra) # 41e <write>
}
 4c0:	60e2                	ld	ra,24(sp)
 4c2:	6442                	ld	s0,16(sp)
 4c4:	6105                	addi	sp,sp,32
 4c6:	8082                	ret

00000000000004c8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c8:	7139                	addi	sp,sp,-64
 4ca:	fc06                	sd	ra,56(sp)
 4cc:	f822                	sd	s0,48(sp)
 4ce:	f426                	sd	s1,40(sp)
 4d0:	f04a                	sd	s2,32(sp)
 4d2:	ec4e                	sd	s3,24(sp)
 4d4:	0080                	addi	s0,sp,64
 4d6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4d8:	c299                	beqz	a3,4de <printint+0x16>
 4da:	0805c863          	bltz	a1,56a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4de:	2581                	sext.w	a1,a1
  neg = 0;
 4e0:	4881                	li	a7,0
 4e2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4e6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4e8:	2601                	sext.w	a2,a2
 4ea:	00000517          	auipc	a0,0x0
 4ee:	55e50513          	addi	a0,a0,1374 # a48 <digits>
 4f2:	883a                	mv	a6,a4
 4f4:	2705                	addiw	a4,a4,1
 4f6:	02c5f7bb          	remuw	a5,a1,a2
 4fa:	1782                	slli	a5,a5,0x20
 4fc:	9381                	srli	a5,a5,0x20
 4fe:	97aa                	add	a5,a5,a0
 500:	0007c783          	lbu	a5,0(a5)
 504:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 508:	0005879b          	sext.w	a5,a1
 50c:	02c5d5bb          	divuw	a1,a1,a2
 510:	0685                	addi	a3,a3,1
 512:	fec7f0e3          	bgeu	a5,a2,4f2 <printint+0x2a>
  if(neg)
 516:	00088b63          	beqz	a7,52c <printint+0x64>
    buf[i++] = '-';
 51a:	fd040793          	addi	a5,s0,-48
 51e:	973e                	add	a4,a4,a5
 520:	02d00793          	li	a5,45
 524:	fef70823          	sb	a5,-16(a4)
 528:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 52c:	02e05863          	blez	a4,55c <printint+0x94>
 530:	fc040793          	addi	a5,s0,-64
 534:	00e78933          	add	s2,a5,a4
 538:	fff78993          	addi	s3,a5,-1
 53c:	99ba                	add	s3,s3,a4
 53e:	377d                	addiw	a4,a4,-1
 540:	1702                	slli	a4,a4,0x20
 542:	9301                	srli	a4,a4,0x20
 544:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 548:	fff94583          	lbu	a1,-1(s2)
 54c:	8526                	mv	a0,s1
 54e:	00000097          	auipc	ra,0x0
 552:	f58080e7          	jalr	-168(ra) # 4a6 <putc>
  while(--i >= 0)
 556:	197d                	addi	s2,s2,-1
 558:	ff3918e3          	bne	s2,s3,548 <printint+0x80>
}
 55c:	70e2                	ld	ra,56(sp)
 55e:	7442                	ld	s0,48(sp)
 560:	74a2                	ld	s1,40(sp)
 562:	7902                	ld	s2,32(sp)
 564:	69e2                	ld	s3,24(sp)
 566:	6121                	addi	sp,sp,64
 568:	8082                	ret
    x = -xx;
 56a:	40b005bb          	negw	a1,a1
    neg = 1;
 56e:	4885                	li	a7,1
    x = -xx;
 570:	bf8d                	j	4e2 <printint+0x1a>

0000000000000572 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 572:	7119                	addi	sp,sp,-128
 574:	fc86                	sd	ra,120(sp)
 576:	f8a2                	sd	s0,112(sp)
 578:	f4a6                	sd	s1,104(sp)
 57a:	f0ca                	sd	s2,96(sp)
 57c:	ecce                	sd	s3,88(sp)
 57e:	e8d2                	sd	s4,80(sp)
 580:	e4d6                	sd	s5,72(sp)
 582:	e0da                	sd	s6,64(sp)
 584:	fc5e                	sd	s7,56(sp)
 586:	f862                	sd	s8,48(sp)
 588:	f466                	sd	s9,40(sp)
 58a:	f06a                	sd	s10,32(sp)
 58c:	ec6e                	sd	s11,24(sp)
 58e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 590:	0005c903          	lbu	s2,0(a1)
 594:	18090f63          	beqz	s2,732 <vprintf+0x1c0>
 598:	8aaa                	mv	s5,a0
 59a:	8b32                	mv	s6,a2
 59c:	00158493          	addi	s1,a1,1
  state = 0;
 5a0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5a2:	02500a13          	li	s4,37
      if(c == 'd'){
 5a6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5aa:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5ae:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5b2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5b6:	00000b97          	auipc	s7,0x0
 5ba:	492b8b93          	addi	s7,s7,1170 # a48 <digits>
 5be:	a839                	j	5dc <vprintf+0x6a>
        putc(fd, c);
 5c0:	85ca                	mv	a1,s2
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	ee2080e7          	jalr	-286(ra) # 4a6 <putc>
 5cc:	a019                	j	5d2 <vprintf+0x60>
    } else if(state == '%'){
 5ce:	01498f63          	beq	s3,s4,5ec <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5d2:	0485                	addi	s1,s1,1
 5d4:	fff4c903          	lbu	s2,-1(s1)
 5d8:	14090d63          	beqz	s2,732 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5dc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5e0:	fe0997e3          	bnez	s3,5ce <vprintf+0x5c>
      if(c == '%'){
 5e4:	fd479ee3          	bne	a5,s4,5c0 <vprintf+0x4e>
        state = '%';
 5e8:	89be                	mv	s3,a5
 5ea:	b7e5                	j	5d2 <vprintf+0x60>
      if(c == 'd'){
 5ec:	05878063          	beq	a5,s8,62c <vprintf+0xba>
      } else if(c == 'l') {
 5f0:	05978c63          	beq	a5,s9,648 <vprintf+0xd6>
      } else if(c == 'x') {
 5f4:	07a78863          	beq	a5,s10,664 <vprintf+0xf2>
      } else if(c == 'p') {
 5f8:	09b78463          	beq	a5,s11,680 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5fc:	07300713          	li	a4,115
 600:	0ce78663          	beq	a5,a4,6cc <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 604:	06300713          	li	a4,99
 608:	0ee78e63          	beq	a5,a4,704 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 60c:	11478863          	beq	a5,s4,71c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 610:	85d2                	mv	a1,s4
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	e92080e7          	jalr	-366(ra) # 4a6 <putc>
        putc(fd, c);
 61c:	85ca                	mv	a1,s2
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	e86080e7          	jalr	-378(ra) # 4a6 <putc>
      }
      state = 0;
 628:	4981                	li	s3,0
 62a:	b765                	j	5d2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 62c:	008b0913          	addi	s2,s6,8
 630:	4685                	li	a3,1
 632:	4629                	li	a2,10
 634:	000b2583          	lw	a1,0(s6)
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	e8e080e7          	jalr	-370(ra) # 4c8 <printint>
 642:	8b4a                	mv	s6,s2
      state = 0;
 644:	4981                	li	s3,0
 646:	b771                	j	5d2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 648:	008b0913          	addi	s2,s6,8
 64c:	4681                	li	a3,0
 64e:	4629                	li	a2,10
 650:	000b2583          	lw	a1,0(s6)
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	e72080e7          	jalr	-398(ra) # 4c8 <printint>
 65e:	8b4a                	mv	s6,s2
      state = 0;
 660:	4981                	li	s3,0
 662:	bf85                	j	5d2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 664:	008b0913          	addi	s2,s6,8
 668:	4681                	li	a3,0
 66a:	4641                	li	a2,16
 66c:	000b2583          	lw	a1,0(s6)
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	e56080e7          	jalr	-426(ra) # 4c8 <printint>
 67a:	8b4a                	mv	s6,s2
      state = 0;
 67c:	4981                	li	s3,0
 67e:	bf91                	j	5d2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 680:	008b0793          	addi	a5,s6,8
 684:	f8f43423          	sd	a5,-120(s0)
 688:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 68c:	03000593          	li	a1,48
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	e14080e7          	jalr	-492(ra) # 4a6 <putc>
  putc(fd, 'x');
 69a:	85ea                	mv	a1,s10
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	e08080e7          	jalr	-504(ra) # 4a6 <putc>
 6a6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a8:	03c9d793          	srli	a5,s3,0x3c
 6ac:	97de                	add	a5,a5,s7
 6ae:	0007c583          	lbu	a1,0(a5)
 6b2:	8556                	mv	a0,s5
 6b4:	00000097          	auipc	ra,0x0
 6b8:	df2080e7          	jalr	-526(ra) # 4a6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6bc:	0992                	slli	s3,s3,0x4
 6be:	397d                	addiw	s2,s2,-1
 6c0:	fe0914e3          	bnez	s2,6a8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6c4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	b721                	j	5d2 <vprintf+0x60>
        s = va_arg(ap, char*);
 6cc:	008b0993          	addi	s3,s6,8
 6d0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6d4:	02090163          	beqz	s2,6f6 <vprintf+0x184>
        while(*s != 0){
 6d8:	00094583          	lbu	a1,0(s2)
 6dc:	c9a1                	beqz	a1,72c <vprintf+0x1ba>
          putc(fd, *s);
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	dc6080e7          	jalr	-570(ra) # 4a6 <putc>
          s++;
 6e8:	0905                	addi	s2,s2,1
        while(*s != 0){
 6ea:	00094583          	lbu	a1,0(s2)
 6ee:	f9e5                	bnez	a1,6de <vprintf+0x16c>
        s = va_arg(ap, char*);
 6f0:	8b4e                	mv	s6,s3
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	bdf9                	j	5d2 <vprintf+0x60>
          s = "(null)";
 6f6:	00000917          	auipc	s2,0x0
 6fa:	34a90913          	addi	s2,s2,842 # a40 <malloc+0x204>
        while(*s != 0){
 6fe:	02800593          	li	a1,40
 702:	bff1                	j	6de <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 704:	008b0913          	addi	s2,s6,8
 708:	000b4583          	lbu	a1,0(s6)
 70c:	8556                	mv	a0,s5
 70e:	00000097          	auipc	ra,0x0
 712:	d98080e7          	jalr	-616(ra) # 4a6 <putc>
 716:	8b4a                	mv	s6,s2
      state = 0;
 718:	4981                	li	s3,0
 71a:	bd65                	j	5d2 <vprintf+0x60>
        putc(fd, c);
 71c:	85d2                	mv	a1,s4
 71e:	8556                	mv	a0,s5
 720:	00000097          	auipc	ra,0x0
 724:	d86080e7          	jalr	-634(ra) # 4a6 <putc>
      state = 0;
 728:	4981                	li	s3,0
 72a:	b565                	j	5d2 <vprintf+0x60>
        s = va_arg(ap, char*);
 72c:	8b4e                	mv	s6,s3
      state = 0;
 72e:	4981                	li	s3,0
 730:	b54d                	j	5d2 <vprintf+0x60>
    }
  }
}
 732:	70e6                	ld	ra,120(sp)
 734:	7446                	ld	s0,112(sp)
 736:	74a6                	ld	s1,104(sp)
 738:	7906                	ld	s2,96(sp)
 73a:	69e6                	ld	s3,88(sp)
 73c:	6a46                	ld	s4,80(sp)
 73e:	6aa6                	ld	s5,72(sp)
 740:	6b06                	ld	s6,64(sp)
 742:	7be2                	ld	s7,56(sp)
 744:	7c42                	ld	s8,48(sp)
 746:	7ca2                	ld	s9,40(sp)
 748:	7d02                	ld	s10,32(sp)
 74a:	6de2                	ld	s11,24(sp)
 74c:	6109                	addi	sp,sp,128
 74e:	8082                	ret

0000000000000750 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 750:	715d                	addi	sp,sp,-80
 752:	ec06                	sd	ra,24(sp)
 754:	e822                	sd	s0,16(sp)
 756:	1000                	addi	s0,sp,32
 758:	e010                	sd	a2,0(s0)
 75a:	e414                	sd	a3,8(s0)
 75c:	e818                	sd	a4,16(s0)
 75e:	ec1c                	sd	a5,24(s0)
 760:	03043023          	sd	a6,32(s0)
 764:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 768:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 76c:	8622                	mv	a2,s0
 76e:	00000097          	auipc	ra,0x0
 772:	e04080e7          	jalr	-508(ra) # 572 <vprintf>
}
 776:	60e2                	ld	ra,24(sp)
 778:	6442                	ld	s0,16(sp)
 77a:	6161                	addi	sp,sp,80
 77c:	8082                	ret

000000000000077e <printf>:

void
printf(const char *fmt, ...)
{
 77e:	711d                	addi	sp,sp,-96
 780:	ec06                	sd	ra,24(sp)
 782:	e822                	sd	s0,16(sp)
 784:	1000                	addi	s0,sp,32
 786:	e40c                	sd	a1,8(s0)
 788:	e810                	sd	a2,16(s0)
 78a:	ec14                	sd	a3,24(s0)
 78c:	f018                	sd	a4,32(s0)
 78e:	f41c                	sd	a5,40(s0)
 790:	03043823          	sd	a6,48(s0)
 794:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 798:	00840613          	addi	a2,s0,8
 79c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a0:	85aa                	mv	a1,a0
 7a2:	4505                	li	a0,1
 7a4:	00000097          	auipc	ra,0x0
 7a8:	dce080e7          	jalr	-562(ra) # 572 <vprintf>
}
 7ac:	60e2                	ld	ra,24(sp)
 7ae:	6442                	ld	s0,16(sp)
 7b0:	6125                	addi	sp,sp,96
 7b2:	8082                	ret

00000000000007b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b4:	1141                	addi	sp,sp,-16
 7b6:	e422                	sd	s0,8(sp)
 7b8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ba:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7be:	00000797          	auipc	a5,0x0
 7c2:	2a27b783          	ld	a5,674(a5) # a60 <freep>
 7c6:	a805                	j	7f6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c8:	4618                	lw	a4,8(a2)
 7ca:	9db9                	addw	a1,a1,a4
 7cc:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d0:	6398                	ld	a4,0(a5)
 7d2:	6318                	ld	a4,0(a4)
 7d4:	fee53823          	sd	a4,-16(a0)
 7d8:	a091                	j	81c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7da:	ff852703          	lw	a4,-8(a0)
 7de:	9e39                	addw	a2,a2,a4
 7e0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7e2:	ff053703          	ld	a4,-16(a0)
 7e6:	e398                	sd	a4,0(a5)
 7e8:	a099                	j	82e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ea:	6398                	ld	a4,0(a5)
 7ec:	00e7e463          	bltu	a5,a4,7f4 <free+0x40>
 7f0:	00e6ea63          	bltu	a3,a4,804 <free+0x50>
{
 7f4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f6:	fed7fae3          	bgeu	a5,a3,7ea <free+0x36>
 7fa:	6398                	ld	a4,0(a5)
 7fc:	00e6e463          	bltu	a3,a4,804 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 800:	fee7eae3          	bltu	a5,a4,7f4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 804:	ff852583          	lw	a1,-8(a0)
 808:	6390                	ld	a2,0(a5)
 80a:	02059713          	slli	a4,a1,0x20
 80e:	9301                	srli	a4,a4,0x20
 810:	0712                	slli	a4,a4,0x4
 812:	9736                	add	a4,a4,a3
 814:	fae60ae3          	beq	a2,a4,7c8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 818:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 81c:	4790                	lw	a2,8(a5)
 81e:	02061713          	slli	a4,a2,0x20
 822:	9301                	srli	a4,a4,0x20
 824:	0712                	slli	a4,a4,0x4
 826:	973e                	add	a4,a4,a5
 828:	fae689e3          	beq	a3,a4,7da <free+0x26>
  } else
    p->s.ptr = bp;
 82c:	e394                	sd	a3,0(a5)
  freep = p;
 82e:	00000717          	auipc	a4,0x0
 832:	22f73923          	sd	a5,562(a4) # a60 <freep>
}
 836:	6422                	ld	s0,8(sp)
 838:	0141                	addi	sp,sp,16
 83a:	8082                	ret

000000000000083c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 83c:	7139                	addi	sp,sp,-64
 83e:	fc06                	sd	ra,56(sp)
 840:	f822                	sd	s0,48(sp)
 842:	f426                	sd	s1,40(sp)
 844:	f04a                	sd	s2,32(sp)
 846:	ec4e                	sd	s3,24(sp)
 848:	e852                	sd	s4,16(sp)
 84a:	e456                	sd	s5,8(sp)
 84c:	e05a                	sd	s6,0(sp)
 84e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 850:	02051493          	slli	s1,a0,0x20
 854:	9081                	srli	s1,s1,0x20
 856:	04bd                	addi	s1,s1,15
 858:	8091                	srli	s1,s1,0x4
 85a:	0014899b          	addiw	s3,s1,1
 85e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 860:	00000517          	auipc	a0,0x0
 864:	20053503          	ld	a0,512(a0) # a60 <freep>
 868:	c515                	beqz	a0,894 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86c:	4798                	lw	a4,8(a5)
 86e:	02977f63          	bgeu	a4,s1,8ac <malloc+0x70>
 872:	8a4e                	mv	s4,s3
 874:	0009871b          	sext.w	a4,s3
 878:	6685                	lui	a3,0x1
 87a:	00d77363          	bgeu	a4,a3,880 <malloc+0x44>
 87e:	6a05                	lui	s4,0x1
 880:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 884:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 888:	00000917          	auipc	s2,0x0
 88c:	1d890913          	addi	s2,s2,472 # a60 <freep>
  if(p == (char*)-1)
 890:	5afd                	li	s5,-1
 892:	a88d                	j	904 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 894:	00000797          	auipc	a5,0x0
 898:	1d478793          	addi	a5,a5,468 # a68 <base>
 89c:	00000717          	auipc	a4,0x0
 8a0:	1cf73223          	sd	a5,452(a4) # a60 <freep>
 8a4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8aa:	b7e1                	j	872 <malloc+0x36>
      if(p->s.size == nunits)
 8ac:	02e48b63          	beq	s1,a4,8e2 <malloc+0xa6>
        p->s.size -= nunits;
 8b0:	4137073b          	subw	a4,a4,s3
 8b4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8b6:	1702                	slli	a4,a4,0x20
 8b8:	9301                	srli	a4,a4,0x20
 8ba:	0712                	slli	a4,a4,0x4
 8bc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8be:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8c2:	00000717          	auipc	a4,0x0
 8c6:	18a73f23          	sd	a0,414(a4) # a60 <freep>
      return (void*)(p + 1);
 8ca:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8ce:	70e2                	ld	ra,56(sp)
 8d0:	7442                	ld	s0,48(sp)
 8d2:	74a2                	ld	s1,40(sp)
 8d4:	7902                	ld	s2,32(sp)
 8d6:	69e2                	ld	s3,24(sp)
 8d8:	6a42                	ld	s4,16(sp)
 8da:	6aa2                	ld	s5,8(sp)
 8dc:	6b02                	ld	s6,0(sp)
 8de:	6121                	addi	sp,sp,64
 8e0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8e2:	6398                	ld	a4,0(a5)
 8e4:	e118                	sd	a4,0(a0)
 8e6:	bff1                	j	8c2 <malloc+0x86>
  hp->s.size = nu;
 8e8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ec:	0541                	addi	a0,a0,16
 8ee:	00000097          	auipc	ra,0x0
 8f2:	ec6080e7          	jalr	-314(ra) # 7b4 <free>
  return freep;
 8f6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8fa:	d971                	beqz	a0,8ce <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8fe:	4798                	lw	a4,8(a5)
 900:	fa9776e3          	bgeu	a4,s1,8ac <malloc+0x70>
    if(p == freep)
 904:	00093703          	ld	a4,0(s2)
 908:	853e                	mv	a0,a5
 90a:	fef719e3          	bne	a4,a5,8fc <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 90e:	8552                	mv	a0,s4
 910:	00000097          	auipc	ra,0x0
 914:	b76080e7          	jalr	-1162(ra) # 486 <sbrk>
  if(p == (char*)-1)
 918:	fd5518e3          	bne	a0,s5,8e8 <malloc+0xac>
        return 0;
 91c:	4501                	li	a0,0
 91e:	bf45                	j	8ce <malloc+0x92>
