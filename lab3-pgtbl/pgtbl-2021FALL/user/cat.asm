
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	93890913          	addi	s2,s2,-1736 # 948 <buf>
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	3a2080e7          	jalr	930(ra) # 3c2 <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	396080e7          	jalr	918(ra) # 3ca <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	89858593          	addi	a1,a1,-1896 # 8d8 <malloc+0xe8>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	6ba080e7          	jalr	1722(ra) # 704 <fprintf>
      exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	356080e7          	jalr	854(ra) # 3aa <exit>
    }
  }
  if(n < 0){
  5c:	00054963          	bltz	a0,6e <cat+0x6e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	addi	sp,sp,48
  6c:	8082                	ret
    fprintf(2, "cat: read error\n");
  6e:	00001597          	auipc	a1,0x1
  72:	88258593          	addi	a1,a1,-1918 # 8f0 <malloc+0x100>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	68c080e7          	jalr	1676(ra) # 704 <fprintf>
    exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	328080e7          	jalr	808(ra) # 3aa <exit>

000000000000008a <main>:

int
main(int argc, char *argv[])
{
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	ec26                	sd	s1,24(sp)
  92:	e84a                	sd	s2,16(sp)
  94:	e44e                	sd	s3,8(sp)
  96:	e052                	sd	s4,0(sp)
  98:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  9a:	4785                	li	a5,1
  9c:	04a7d763          	bge	a5,a0,ea <main+0x60>
  a0:	00858913          	addi	s2,a1,8
  a4:	ffe5099b          	addiw	s3,a0,-2
  a8:	1982                	slli	s3,s3,0x20
  aa:	0209d993          	srli	s3,s3,0x20
  ae:	098e                	slli	s3,s3,0x3
  b0:	05c1                	addi	a1,a1,16
  b2:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  b4:	4581                	li	a1,0
  b6:	00093503          	ld	a0,0(s2)
  ba:	00000097          	auipc	ra,0x0
  be:	330080e7          	jalr	816(ra) # 3ea <open>
  c2:	84aa                	mv	s1,a0
  c4:	02054d63          	bltz	a0,fe <main+0x74>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  c8:	00000097          	auipc	ra,0x0
  cc:	f38080e7          	jalr	-200(ra) # 0 <cat>
    close(fd);
  d0:	8526                	mv	a0,s1
  d2:	00000097          	auipc	ra,0x0
  d6:	300080e7          	jalr	768(ra) # 3d2 <close>
  for(i = 1; i < argc; i++){
  da:	0921                	addi	s2,s2,8
  dc:	fd391ce3          	bne	s2,s3,b4 <main+0x2a>
  }
  exit(0);
  e0:	4501                	li	a0,0
  e2:	00000097          	auipc	ra,0x0
  e6:	2c8080e7          	jalr	712(ra) # 3aa <exit>
    cat(0);
  ea:	4501                	li	a0,0
  ec:	00000097          	auipc	ra,0x0
  f0:	f14080e7          	jalr	-236(ra) # 0 <cat>
    exit(0);
  f4:	4501                	li	a0,0
  f6:	00000097          	auipc	ra,0x0
  fa:	2b4080e7          	jalr	692(ra) # 3aa <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  fe:	00093603          	ld	a2,0(s2)
 102:	00001597          	auipc	a1,0x1
 106:	80658593          	addi	a1,a1,-2042 # 908 <malloc+0x118>
 10a:	4509                	li	a0,2
 10c:	00000097          	auipc	ra,0x0
 110:	5f8080e7          	jalr	1528(ra) # 704 <fprintf>
      exit(1);
 114:	4505                	li	a0,1
 116:	00000097          	auipc	ra,0x0
 11a:	294080e7          	jalr	660(ra) # 3aa <exit>

000000000000011e <strcpy>:



char*
strcpy(char *s, const char *t)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 124:	87aa                	mv	a5,a0
 126:	0585                	addi	a1,a1,1
 128:	0785                	addi	a5,a5,1
 12a:	fff5c703          	lbu	a4,-1(a1)
 12e:	fee78fa3          	sb	a4,-1(a5)
 132:	fb75                	bnez	a4,126 <strcpy+0x8>
    ;
  return os;
}
 134:	6422                	ld	s0,8(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret

000000000000013a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13a:	1141                	addi	sp,sp,-16
 13c:	e422                	sd	s0,8(sp)
 13e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	cb91                	beqz	a5,158 <strcmp+0x1e>
 146:	0005c703          	lbu	a4,0(a1)
 14a:	00f71763          	bne	a4,a5,158 <strcmp+0x1e>
    p++, q++;
 14e:	0505                	addi	a0,a0,1
 150:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 152:	00054783          	lbu	a5,0(a0)
 156:	fbe5                	bnez	a5,146 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 158:	0005c503          	lbu	a0,0(a1)
}
 15c:	40a7853b          	subw	a0,a5,a0
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret

0000000000000166 <strlen>:

uint
strlen(const char *s)
{
 166:	1141                	addi	sp,sp,-16
 168:	e422                	sd	s0,8(sp)
 16a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16c:	00054783          	lbu	a5,0(a0)
 170:	cf91                	beqz	a5,18c <strlen+0x26>
 172:	0505                	addi	a0,a0,1
 174:	87aa                	mv	a5,a0
 176:	4685                	li	a3,1
 178:	9e89                	subw	a3,a3,a0
 17a:	00f6853b          	addw	a0,a3,a5
 17e:	0785                	addi	a5,a5,1
 180:	fff7c703          	lbu	a4,-1(a5)
 184:	fb7d                	bnez	a4,17a <strlen+0x14>
    ;
  return n;
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
  for(n = 0; s[n]; n++)
 18c:	4501                	li	a0,0
 18e:	bfe5                	j	186 <strlen+0x20>

0000000000000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 196:	ce09                	beqz	a2,1b0 <memset+0x20>
 198:	87aa                	mv	a5,a0
 19a:	fff6071b          	addiw	a4,a2,-1
 19e:	1702                	slli	a4,a4,0x20
 1a0:	9301                	srli	a4,a4,0x20
 1a2:	0705                	addi	a4,a4,1
 1a4:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1a6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1aa:	0785                	addi	a5,a5,1
 1ac:	fee79de3          	bne	a5,a4,1a6 <memset+0x16>
  }
  return dst;
}
 1b0:	6422                	ld	s0,8(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <strchr>:

char*
strchr(const char *s, char c)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	cb99                	beqz	a5,1d6 <strchr+0x20>
    if(*s == c)
 1c2:	00f58763          	beq	a1,a5,1d0 <strchr+0x1a>
  for(; *s; s++)
 1c6:	0505                	addi	a0,a0,1
 1c8:	00054783          	lbu	a5,0(a0)
 1cc:	fbfd                	bnez	a5,1c2 <strchr+0xc>
      return (char*)s;
  return 0;
 1ce:	4501                	li	a0,0
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret
  return 0;
 1d6:	4501                	li	a0,0
 1d8:	bfe5                	j	1d0 <strchr+0x1a>

00000000000001da <gets>:

char*
gets(char *buf, int max)
{
 1da:	711d                	addi	sp,sp,-96
 1dc:	ec86                	sd	ra,88(sp)
 1de:	e8a2                	sd	s0,80(sp)
 1e0:	e4a6                	sd	s1,72(sp)
 1e2:	e0ca                	sd	s2,64(sp)
 1e4:	fc4e                	sd	s3,56(sp)
 1e6:	f852                	sd	s4,48(sp)
 1e8:	f456                	sd	s5,40(sp)
 1ea:	f05a                	sd	s6,32(sp)
 1ec:	ec5e                	sd	s7,24(sp)
 1ee:	1080                	addi	s0,sp,96
 1f0:	8baa                	mv	s7,a0
 1f2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f4:	892a                	mv	s2,a0
 1f6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f8:	4aa9                	li	s5,10
 1fa:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1fc:	89a6                	mv	s3,s1
 1fe:	2485                	addiw	s1,s1,1
 200:	0344d863          	bge	s1,s4,230 <gets+0x56>
    cc = read(0, &c, 1);
 204:	4605                	li	a2,1
 206:	faf40593          	addi	a1,s0,-81
 20a:	4501                	li	a0,0
 20c:	00000097          	auipc	ra,0x0
 210:	1b6080e7          	jalr	438(ra) # 3c2 <read>
    if(cc < 1)
 214:	00a05e63          	blez	a0,230 <gets+0x56>
    buf[i++] = c;
 218:	faf44783          	lbu	a5,-81(s0)
 21c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 220:	01578763          	beq	a5,s5,22e <gets+0x54>
 224:	0905                	addi	s2,s2,1
 226:	fd679be3          	bne	a5,s6,1fc <gets+0x22>
  for(i=0; i+1 < max; ){
 22a:	89a6                	mv	s3,s1
 22c:	a011                	j	230 <gets+0x56>
 22e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 230:	99de                	add	s3,s3,s7
 232:	00098023          	sb	zero,0(s3)
  return buf;
}
 236:	855e                	mv	a0,s7
 238:	60e6                	ld	ra,88(sp)
 23a:	6446                	ld	s0,80(sp)
 23c:	64a6                	ld	s1,72(sp)
 23e:	6906                	ld	s2,64(sp)
 240:	79e2                	ld	s3,56(sp)
 242:	7a42                	ld	s4,48(sp)
 244:	7aa2                	ld	s5,40(sp)
 246:	7b02                	ld	s6,32(sp)
 248:	6be2                	ld	s7,24(sp)
 24a:	6125                	addi	sp,sp,96
 24c:	8082                	ret

000000000000024e <stat>:

int
stat(const char *n, struct stat *st)
{
 24e:	1101                	addi	sp,sp,-32
 250:	ec06                	sd	ra,24(sp)
 252:	e822                	sd	s0,16(sp)
 254:	e426                	sd	s1,8(sp)
 256:	e04a                	sd	s2,0(sp)
 258:	1000                	addi	s0,sp,32
 25a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25c:	4581                	li	a1,0
 25e:	00000097          	auipc	ra,0x0
 262:	18c080e7          	jalr	396(ra) # 3ea <open>
  if(fd < 0)
 266:	02054563          	bltz	a0,290 <stat+0x42>
 26a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 26c:	85ca                	mv	a1,s2
 26e:	00000097          	auipc	ra,0x0
 272:	194080e7          	jalr	404(ra) # 402 <fstat>
 276:	892a                	mv	s2,a0
  close(fd);
 278:	8526                	mv	a0,s1
 27a:	00000097          	auipc	ra,0x0
 27e:	158080e7          	jalr	344(ra) # 3d2 <close>
  return r;
}
 282:	854a                	mv	a0,s2
 284:	60e2                	ld	ra,24(sp)
 286:	6442                	ld	s0,16(sp)
 288:	64a2                	ld	s1,8(sp)
 28a:	6902                	ld	s2,0(sp)
 28c:	6105                	addi	sp,sp,32
 28e:	8082                	ret
    return -1;
 290:	597d                	li	s2,-1
 292:	bfc5                	j	282 <stat+0x34>

0000000000000294 <atoi>:

int
atoi(const char *s)
{
 294:	1141                	addi	sp,sp,-16
 296:	e422                	sd	s0,8(sp)
 298:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29a:	00054603          	lbu	a2,0(a0)
 29e:	fd06079b          	addiw	a5,a2,-48
 2a2:	0ff7f793          	andi	a5,a5,255
 2a6:	4725                	li	a4,9
 2a8:	02f76963          	bltu	a4,a5,2da <atoi+0x46>
 2ac:	86aa                	mv	a3,a0
  n = 0;
 2ae:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2b0:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2b2:	0685                	addi	a3,a3,1
 2b4:	0025179b          	slliw	a5,a0,0x2
 2b8:	9fa9                	addw	a5,a5,a0
 2ba:	0017979b          	slliw	a5,a5,0x1
 2be:	9fb1                	addw	a5,a5,a2
 2c0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c4:	0006c603          	lbu	a2,0(a3)
 2c8:	fd06071b          	addiw	a4,a2,-48
 2cc:	0ff77713          	andi	a4,a4,255
 2d0:	fee5f1e3          	bgeu	a1,a4,2b2 <atoi+0x1e>
  return n;
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  n = 0;
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <atoi+0x40>

00000000000002de <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e4:	02b57663          	bgeu	a0,a1,310 <memmove+0x32>
    while(n-- > 0)
 2e8:	02c05163          	blez	a2,30a <memmove+0x2c>
 2ec:	fff6079b          	addiw	a5,a2,-1
 2f0:	1782                	slli	a5,a5,0x20
 2f2:	9381                	srli	a5,a5,0x20
 2f4:	0785                	addi	a5,a5,1
 2f6:	97aa                	add	a5,a5,a0
  dst = vdst;
 2f8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2fa:	0585                	addi	a1,a1,1
 2fc:	0705                	addi	a4,a4,1
 2fe:	fff5c683          	lbu	a3,-1(a1)
 302:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 306:	fee79ae3          	bne	a5,a4,2fa <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
    dst += n;
 310:	00c50733          	add	a4,a0,a2
    src += n;
 314:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 316:	fec05ae3          	blez	a2,30a <memmove+0x2c>
 31a:	fff6079b          	addiw	a5,a2,-1
 31e:	1782                	slli	a5,a5,0x20
 320:	9381                	srli	a5,a5,0x20
 322:	fff7c793          	not	a5,a5
 326:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 328:	15fd                	addi	a1,a1,-1
 32a:	177d                	addi	a4,a4,-1
 32c:	0005c683          	lbu	a3,0(a1)
 330:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 334:	fee79ae3          	bne	a5,a4,328 <memmove+0x4a>
 338:	bfc9                	j	30a <memmove+0x2c>

000000000000033a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e422                	sd	s0,8(sp)
 33e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 340:	ca05                	beqz	a2,370 <memcmp+0x36>
 342:	fff6069b          	addiw	a3,a2,-1
 346:	1682                	slli	a3,a3,0x20
 348:	9281                	srli	a3,a3,0x20
 34a:	0685                	addi	a3,a3,1
 34c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 34e:	00054783          	lbu	a5,0(a0)
 352:	0005c703          	lbu	a4,0(a1)
 356:	00e79863          	bne	a5,a4,366 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 35a:	0505                	addi	a0,a0,1
    p2++;
 35c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 35e:	fed518e3          	bne	a0,a3,34e <memcmp+0x14>
  }
  return 0;
 362:	4501                	li	a0,0
 364:	a019                	j	36a <memcmp+0x30>
      return *p1 - *p2;
 366:	40e7853b          	subw	a0,a5,a4
}
 36a:	6422                	ld	s0,8(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret
  return 0;
 370:	4501                	li	a0,0
 372:	bfe5                	j	36a <memcmp+0x30>

0000000000000374 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 374:	1141                	addi	sp,sp,-16
 376:	e406                	sd	ra,8(sp)
 378:	e022                	sd	s0,0(sp)
 37a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 37c:	00000097          	auipc	ra,0x0
 380:	f62080e7          	jalr	-158(ra) # 2de <memmove>
}
 384:	60a2                	ld	ra,8(sp)
 386:	6402                	ld	s0,0(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret

000000000000038c <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 38c:	1141                	addi	sp,sp,-16
 38e:	e422                	sd	s0,8(sp)
 390:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 392:	040007b7          	lui	a5,0x4000
}
 396:	17f5                	addi	a5,a5,-3
 398:	07b2                	slli	a5,a5,0xc
 39a:	4388                	lw	a0,0(a5)
 39c:	6422                	ld	s0,8(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret

00000000000003a2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a2:	4885                	li	a7,1
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <exit>:
.global exit
exit:
 li a7, SYS_exit
 3aa:	4889                	li	a7,2
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b2:	488d                	li	a7,3
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ba:	4891                	li	a7,4
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <read>:
.global read
read:
 li a7, SYS_read
 3c2:	4895                	li	a7,5
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <write>:
.global write
write:
 li a7, SYS_write
 3ca:	48c1                	li	a7,16
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <close>:
.global close
close:
 li a7, SYS_close
 3d2:	48d5                	li	a7,21
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <kill>:
.global kill
kill:
 li a7, SYS_kill
 3da:	4899                	li	a7,6
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e2:	489d                	li	a7,7
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <open>:
.global open
open:
 li a7, SYS_open
 3ea:	48bd                	li	a7,15
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f2:	48c5                	li	a7,17
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fa:	48c9                	li	a7,18
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 402:	48a1                	li	a7,8
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <link>:
.global link
link:
 li a7, SYS_link
 40a:	48cd                	li	a7,19
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 412:	48d1                	li	a7,20
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41a:	48a5                	li	a7,9
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <dup>:
.global dup
dup:
 li a7, SYS_dup
 422:	48a9                	li	a7,10
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42a:	48ad                	li	a7,11
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 432:	48b1                	li	a7,12
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 43a:	48b5                	li	a7,13
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 442:	48b9                	li	a7,14
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <connect>:
.global connect
connect:
 li a7, SYS_connect
 44a:	48f5                	li	a7,29
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 452:	48f9                	li	a7,30
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 45a:	1101                	addi	sp,sp,-32
 45c:	ec06                	sd	ra,24(sp)
 45e:	e822                	sd	s0,16(sp)
 460:	1000                	addi	s0,sp,32
 462:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 466:	4605                	li	a2,1
 468:	fef40593          	addi	a1,s0,-17
 46c:	00000097          	auipc	ra,0x0
 470:	f5e080e7          	jalr	-162(ra) # 3ca <write>
}
 474:	60e2                	ld	ra,24(sp)
 476:	6442                	ld	s0,16(sp)
 478:	6105                	addi	sp,sp,32
 47a:	8082                	ret

000000000000047c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 47c:	7139                	addi	sp,sp,-64
 47e:	fc06                	sd	ra,56(sp)
 480:	f822                	sd	s0,48(sp)
 482:	f426                	sd	s1,40(sp)
 484:	f04a                	sd	s2,32(sp)
 486:	ec4e                	sd	s3,24(sp)
 488:	0080                	addi	s0,sp,64
 48a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 48c:	c299                	beqz	a3,492 <printint+0x16>
 48e:	0805c863          	bltz	a1,51e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 492:	2581                	sext.w	a1,a1
  neg = 0;
 494:	4881                	li	a7,0
 496:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 49a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 49c:	2601                	sext.w	a2,a2
 49e:	00000517          	auipc	a0,0x0
 4a2:	48a50513          	addi	a0,a0,1162 # 928 <digits>
 4a6:	883a                	mv	a6,a4
 4a8:	2705                	addiw	a4,a4,1
 4aa:	02c5f7bb          	remuw	a5,a1,a2
 4ae:	1782                	slli	a5,a5,0x20
 4b0:	9381                	srli	a5,a5,0x20
 4b2:	97aa                	add	a5,a5,a0
 4b4:	0007c783          	lbu	a5,0(a5) # 4000000 <__global_pointer$+0x3ffeec7>
 4b8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4bc:	0005879b          	sext.w	a5,a1
 4c0:	02c5d5bb          	divuw	a1,a1,a2
 4c4:	0685                	addi	a3,a3,1
 4c6:	fec7f0e3          	bgeu	a5,a2,4a6 <printint+0x2a>
  if(neg)
 4ca:	00088b63          	beqz	a7,4e0 <printint+0x64>
    buf[i++] = '-';
 4ce:	fd040793          	addi	a5,s0,-48
 4d2:	973e                	add	a4,a4,a5
 4d4:	02d00793          	li	a5,45
 4d8:	fef70823          	sb	a5,-16(a4)
 4dc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4e0:	02e05863          	blez	a4,510 <printint+0x94>
 4e4:	fc040793          	addi	a5,s0,-64
 4e8:	00e78933          	add	s2,a5,a4
 4ec:	fff78993          	addi	s3,a5,-1
 4f0:	99ba                	add	s3,s3,a4
 4f2:	377d                	addiw	a4,a4,-1
 4f4:	1702                	slli	a4,a4,0x20
 4f6:	9301                	srli	a4,a4,0x20
 4f8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4fc:	fff94583          	lbu	a1,-1(s2)
 500:	8526                	mv	a0,s1
 502:	00000097          	auipc	ra,0x0
 506:	f58080e7          	jalr	-168(ra) # 45a <putc>
  while(--i >= 0)
 50a:	197d                	addi	s2,s2,-1
 50c:	ff3918e3          	bne	s2,s3,4fc <printint+0x80>
}
 510:	70e2                	ld	ra,56(sp)
 512:	7442                	ld	s0,48(sp)
 514:	74a2                	ld	s1,40(sp)
 516:	7902                	ld	s2,32(sp)
 518:	69e2                	ld	s3,24(sp)
 51a:	6121                	addi	sp,sp,64
 51c:	8082                	ret
    x = -xx;
 51e:	40b005bb          	negw	a1,a1
    neg = 1;
 522:	4885                	li	a7,1
    x = -xx;
 524:	bf8d                	j	496 <printint+0x1a>

0000000000000526 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 526:	7119                	addi	sp,sp,-128
 528:	fc86                	sd	ra,120(sp)
 52a:	f8a2                	sd	s0,112(sp)
 52c:	f4a6                	sd	s1,104(sp)
 52e:	f0ca                	sd	s2,96(sp)
 530:	ecce                	sd	s3,88(sp)
 532:	e8d2                	sd	s4,80(sp)
 534:	e4d6                	sd	s5,72(sp)
 536:	e0da                	sd	s6,64(sp)
 538:	fc5e                	sd	s7,56(sp)
 53a:	f862                	sd	s8,48(sp)
 53c:	f466                	sd	s9,40(sp)
 53e:	f06a                	sd	s10,32(sp)
 540:	ec6e                	sd	s11,24(sp)
 542:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 544:	0005c903          	lbu	s2,0(a1)
 548:	18090f63          	beqz	s2,6e6 <vprintf+0x1c0>
 54c:	8aaa                	mv	s5,a0
 54e:	8b32                	mv	s6,a2
 550:	00158493          	addi	s1,a1,1
  state = 0;
 554:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 556:	02500a13          	li	s4,37
      if(c == 'd'){
 55a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 55e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 562:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 566:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 56a:	00000b97          	auipc	s7,0x0
 56e:	3beb8b93          	addi	s7,s7,958 # 928 <digits>
 572:	a839                	j	590 <vprintf+0x6a>
        putc(fd, c);
 574:	85ca                	mv	a1,s2
 576:	8556                	mv	a0,s5
 578:	00000097          	auipc	ra,0x0
 57c:	ee2080e7          	jalr	-286(ra) # 45a <putc>
 580:	a019                	j	586 <vprintf+0x60>
    } else if(state == '%'){
 582:	01498f63          	beq	s3,s4,5a0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 586:	0485                	addi	s1,s1,1
 588:	fff4c903          	lbu	s2,-1(s1)
 58c:	14090d63          	beqz	s2,6e6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 590:	0009079b          	sext.w	a5,s2
    if(state == 0){
 594:	fe0997e3          	bnez	s3,582 <vprintf+0x5c>
      if(c == '%'){
 598:	fd479ee3          	bne	a5,s4,574 <vprintf+0x4e>
        state = '%';
 59c:	89be                	mv	s3,a5
 59e:	b7e5                	j	586 <vprintf+0x60>
      if(c == 'd'){
 5a0:	05878063          	beq	a5,s8,5e0 <vprintf+0xba>
      } else if(c == 'l') {
 5a4:	05978c63          	beq	a5,s9,5fc <vprintf+0xd6>
      } else if(c == 'x') {
 5a8:	07a78863          	beq	a5,s10,618 <vprintf+0xf2>
      } else if(c == 'p') {
 5ac:	09b78463          	beq	a5,s11,634 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5b0:	07300713          	li	a4,115
 5b4:	0ce78663          	beq	a5,a4,680 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5b8:	06300713          	li	a4,99
 5bc:	0ee78e63          	beq	a5,a4,6b8 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5c0:	11478863          	beq	a5,s4,6d0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5c4:	85d2                	mv	a1,s4
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	e92080e7          	jalr	-366(ra) # 45a <putc>
        putc(fd, c);
 5d0:	85ca                	mv	a1,s2
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	e86080e7          	jalr	-378(ra) # 45a <putc>
      }
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b765                	j	586 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5e0:	008b0913          	addi	s2,s6,8
 5e4:	4685                	li	a3,1
 5e6:	4629                	li	a2,10
 5e8:	000b2583          	lw	a1,0(s6)
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	e8e080e7          	jalr	-370(ra) # 47c <printint>
 5f6:	8b4a                	mv	s6,s2
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	b771                	j	586 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fc:	008b0913          	addi	s2,s6,8
 600:	4681                	li	a3,0
 602:	4629                	li	a2,10
 604:	000b2583          	lw	a1,0(s6)
 608:	8556                	mv	a0,s5
 60a:	00000097          	auipc	ra,0x0
 60e:	e72080e7          	jalr	-398(ra) # 47c <printint>
 612:	8b4a                	mv	s6,s2
      state = 0;
 614:	4981                	li	s3,0
 616:	bf85                	j	586 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 618:	008b0913          	addi	s2,s6,8
 61c:	4681                	li	a3,0
 61e:	4641                	li	a2,16
 620:	000b2583          	lw	a1,0(s6)
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	e56080e7          	jalr	-426(ra) # 47c <printint>
 62e:	8b4a                	mv	s6,s2
      state = 0;
 630:	4981                	li	s3,0
 632:	bf91                	j	586 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 634:	008b0793          	addi	a5,s6,8
 638:	f8f43423          	sd	a5,-120(s0)
 63c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 640:	03000593          	li	a1,48
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	e14080e7          	jalr	-492(ra) # 45a <putc>
  putc(fd, 'x');
 64e:	85ea                	mv	a1,s10
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	e08080e7          	jalr	-504(ra) # 45a <putc>
 65a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 65c:	03c9d793          	srli	a5,s3,0x3c
 660:	97de                	add	a5,a5,s7
 662:	0007c583          	lbu	a1,0(a5)
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	df2080e7          	jalr	-526(ra) # 45a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 670:	0992                	slli	s3,s3,0x4
 672:	397d                	addiw	s2,s2,-1
 674:	fe0914e3          	bnez	s2,65c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 678:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 67c:	4981                	li	s3,0
 67e:	b721                	j	586 <vprintf+0x60>
        s = va_arg(ap, char*);
 680:	008b0993          	addi	s3,s6,8
 684:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 688:	02090163          	beqz	s2,6aa <vprintf+0x184>
        while(*s != 0){
 68c:	00094583          	lbu	a1,0(s2)
 690:	c9a1                	beqz	a1,6e0 <vprintf+0x1ba>
          putc(fd, *s);
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	dc6080e7          	jalr	-570(ra) # 45a <putc>
          s++;
 69c:	0905                	addi	s2,s2,1
        while(*s != 0){
 69e:	00094583          	lbu	a1,0(s2)
 6a2:	f9e5                	bnez	a1,692 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6a4:	8b4e                	mv	s6,s3
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	bdf9                	j	586 <vprintf+0x60>
          s = "(null)";
 6aa:	00000917          	auipc	s2,0x0
 6ae:	27690913          	addi	s2,s2,630 # 920 <malloc+0x130>
        while(*s != 0){
 6b2:	02800593          	li	a1,40
 6b6:	bff1                	j	692 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6b8:	008b0913          	addi	s2,s6,8
 6bc:	000b4583          	lbu	a1,0(s6)
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	d98080e7          	jalr	-616(ra) # 45a <putc>
 6ca:	8b4a                	mv	s6,s2
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	bd65                	j	586 <vprintf+0x60>
        putc(fd, c);
 6d0:	85d2                	mv	a1,s4
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	d86080e7          	jalr	-634(ra) # 45a <putc>
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	b565                	j	586 <vprintf+0x60>
        s = va_arg(ap, char*);
 6e0:	8b4e                	mv	s6,s3
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	b54d                	j	586 <vprintf+0x60>
    }
  }
}
 6e6:	70e6                	ld	ra,120(sp)
 6e8:	7446                	ld	s0,112(sp)
 6ea:	74a6                	ld	s1,104(sp)
 6ec:	7906                	ld	s2,96(sp)
 6ee:	69e6                	ld	s3,88(sp)
 6f0:	6a46                	ld	s4,80(sp)
 6f2:	6aa6                	ld	s5,72(sp)
 6f4:	6b06                	ld	s6,64(sp)
 6f6:	7be2                	ld	s7,56(sp)
 6f8:	7c42                	ld	s8,48(sp)
 6fa:	7ca2                	ld	s9,40(sp)
 6fc:	7d02                	ld	s10,32(sp)
 6fe:	6de2                	ld	s11,24(sp)
 700:	6109                	addi	sp,sp,128
 702:	8082                	ret

0000000000000704 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 704:	715d                	addi	sp,sp,-80
 706:	ec06                	sd	ra,24(sp)
 708:	e822                	sd	s0,16(sp)
 70a:	1000                	addi	s0,sp,32
 70c:	e010                	sd	a2,0(s0)
 70e:	e414                	sd	a3,8(s0)
 710:	e818                	sd	a4,16(s0)
 712:	ec1c                	sd	a5,24(s0)
 714:	03043023          	sd	a6,32(s0)
 718:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 71c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 720:	8622                	mv	a2,s0
 722:	00000097          	auipc	ra,0x0
 726:	e04080e7          	jalr	-508(ra) # 526 <vprintf>
}
 72a:	60e2                	ld	ra,24(sp)
 72c:	6442                	ld	s0,16(sp)
 72e:	6161                	addi	sp,sp,80
 730:	8082                	ret

0000000000000732 <printf>:

void
printf(const char *fmt, ...)
{
 732:	711d                	addi	sp,sp,-96
 734:	ec06                	sd	ra,24(sp)
 736:	e822                	sd	s0,16(sp)
 738:	1000                	addi	s0,sp,32
 73a:	e40c                	sd	a1,8(s0)
 73c:	e810                	sd	a2,16(s0)
 73e:	ec14                	sd	a3,24(s0)
 740:	f018                	sd	a4,32(s0)
 742:	f41c                	sd	a5,40(s0)
 744:	03043823          	sd	a6,48(s0)
 748:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 74c:	00840613          	addi	a2,s0,8
 750:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 754:	85aa                	mv	a1,a0
 756:	4505                	li	a0,1
 758:	00000097          	auipc	ra,0x0
 75c:	dce080e7          	jalr	-562(ra) # 526 <vprintf>
}
 760:	60e2                	ld	ra,24(sp)
 762:	6442                	ld	s0,16(sp)
 764:	6125                	addi	sp,sp,96
 766:	8082                	ret

0000000000000768 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 768:	1141                	addi	sp,sp,-16
 76a:	e422                	sd	s0,8(sp)
 76c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 76e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 772:	00000797          	auipc	a5,0x0
 776:	1ce7b783          	ld	a5,462(a5) # 940 <freep>
 77a:	a805                	j	7aa <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 77c:	4618                	lw	a4,8(a2)
 77e:	9db9                	addw	a1,a1,a4
 780:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 784:	6398                	ld	a4,0(a5)
 786:	6318                	ld	a4,0(a4)
 788:	fee53823          	sd	a4,-16(a0)
 78c:	a091                	j	7d0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 78e:	ff852703          	lw	a4,-8(a0)
 792:	9e39                	addw	a2,a2,a4
 794:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 796:	ff053703          	ld	a4,-16(a0)
 79a:	e398                	sd	a4,0(a5)
 79c:	a099                	j	7e2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79e:	6398                	ld	a4,0(a5)
 7a0:	00e7e463          	bltu	a5,a4,7a8 <free+0x40>
 7a4:	00e6ea63          	bltu	a3,a4,7b8 <free+0x50>
{
 7a8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7aa:	fed7fae3          	bgeu	a5,a3,79e <free+0x36>
 7ae:	6398                	ld	a4,0(a5)
 7b0:	00e6e463          	bltu	a3,a4,7b8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b4:	fee7eae3          	bltu	a5,a4,7a8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7b8:	ff852583          	lw	a1,-8(a0)
 7bc:	6390                	ld	a2,0(a5)
 7be:	02059713          	slli	a4,a1,0x20
 7c2:	9301                	srli	a4,a4,0x20
 7c4:	0712                	slli	a4,a4,0x4
 7c6:	9736                	add	a4,a4,a3
 7c8:	fae60ae3          	beq	a2,a4,77c <free+0x14>
    bp->s.ptr = p->s.ptr;
 7cc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7d0:	4790                	lw	a2,8(a5)
 7d2:	02061713          	slli	a4,a2,0x20
 7d6:	9301                	srli	a4,a4,0x20
 7d8:	0712                	slli	a4,a4,0x4
 7da:	973e                	add	a4,a4,a5
 7dc:	fae689e3          	beq	a3,a4,78e <free+0x26>
  } else
    p->s.ptr = bp;
 7e0:	e394                	sd	a3,0(a5)
  freep = p;
 7e2:	00000717          	auipc	a4,0x0
 7e6:	14f73f23          	sd	a5,350(a4) # 940 <freep>
}
 7ea:	6422                	ld	s0,8(sp)
 7ec:	0141                	addi	sp,sp,16
 7ee:	8082                	ret

00000000000007f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f0:	7139                	addi	sp,sp,-64
 7f2:	fc06                	sd	ra,56(sp)
 7f4:	f822                	sd	s0,48(sp)
 7f6:	f426                	sd	s1,40(sp)
 7f8:	f04a                	sd	s2,32(sp)
 7fa:	ec4e                	sd	s3,24(sp)
 7fc:	e852                	sd	s4,16(sp)
 7fe:	e456                	sd	s5,8(sp)
 800:	e05a                	sd	s6,0(sp)
 802:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 804:	02051493          	slli	s1,a0,0x20
 808:	9081                	srli	s1,s1,0x20
 80a:	04bd                	addi	s1,s1,15
 80c:	8091                	srli	s1,s1,0x4
 80e:	0014899b          	addiw	s3,s1,1
 812:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 814:	00000517          	auipc	a0,0x0
 818:	12c53503          	ld	a0,300(a0) # 940 <freep>
 81c:	c515                	beqz	a0,848 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 820:	4798                	lw	a4,8(a5)
 822:	02977f63          	bgeu	a4,s1,860 <malloc+0x70>
 826:	8a4e                	mv	s4,s3
 828:	0009871b          	sext.w	a4,s3
 82c:	6685                	lui	a3,0x1
 82e:	00d77363          	bgeu	a4,a3,834 <malloc+0x44>
 832:	6a05                	lui	s4,0x1
 834:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 838:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 83c:	00000917          	auipc	s2,0x0
 840:	10490913          	addi	s2,s2,260 # 940 <freep>
  if(p == (char*)-1)
 844:	5afd                	li	s5,-1
 846:	a88d                	j	8b8 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 848:	00000797          	auipc	a5,0x0
 84c:	30078793          	addi	a5,a5,768 # b48 <base>
 850:	00000717          	auipc	a4,0x0
 854:	0ef73823          	sd	a5,240(a4) # 940 <freep>
 858:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 85a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 85e:	b7e1                	j	826 <malloc+0x36>
      if(p->s.size == nunits)
 860:	02e48b63          	beq	s1,a4,896 <malloc+0xa6>
        p->s.size -= nunits;
 864:	4137073b          	subw	a4,a4,s3
 868:	c798                	sw	a4,8(a5)
        p += p->s.size;
 86a:	1702                	slli	a4,a4,0x20
 86c:	9301                	srli	a4,a4,0x20
 86e:	0712                	slli	a4,a4,0x4
 870:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 872:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 876:	00000717          	auipc	a4,0x0
 87a:	0ca73523          	sd	a0,202(a4) # 940 <freep>
      return (void*)(p + 1);
 87e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 882:	70e2                	ld	ra,56(sp)
 884:	7442                	ld	s0,48(sp)
 886:	74a2                	ld	s1,40(sp)
 888:	7902                	ld	s2,32(sp)
 88a:	69e2                	ld	s3,24(sp)
 88c:	6a42                	ld	s4,16(sp)
 88e:	6aa2                	ld	s5,8(sp)
 890:	6b02                	ld	s6,0(sp)
 892:	6121                	addi	sp,sp,64
 894:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 896:	6398                	ld	a4,0(a5)
 898:	e118                	sd	a4,0(a0)
 89a:	bff1                	j	876 <malloc+0x86>
  hp->s.size = nu;
 89c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8a0:	0541                	addi	a0,a0,16
 8a2:	00000097          	auipc	ra,0x0
 8a6:	ec6080e7          	jalr	-314(ra) # 768 <free>
  return freep;
 8aa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8ae:	d971                	beqz	a0,882 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b2:	4798                	lw	a4,8(a5)
 8b4:	fa9776e3          	bgeu	a4,s1,860 <malloc+0x70>
    if(p == freep)
 8b8:	00093703          	ld	a4,0(s2)
 8bc:	853e                	mv	a0,a5
 8be:	fef719e3          	bne	a4,a5,8b0 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8c2:	8552                	mv	a0,s4
 8c4:	00000097          	auipc	ra,0x0
 8c8:	b6e080e7          	jalr	-1170(ra) # 432 <sbrk>
  if(p == (char*)-1)
 8cc:	fd5518e3          	bne	a0,s5,89c <malloc+0xac>
        return 0;
 8d0:	4501                	li	a0,0
 8d2:	bf45                	j	882 <malloc+0x92>
