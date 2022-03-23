
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4981                	li	s3,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  2e:	00001d97          	auipc	s11,0x1
  32:	993d8d93          	addi	s11,s11,-1645 # 9c1 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	918a0a13          	addi	s4,s4,-1768 # 950 <malloc+0xe8>
        inword = 0;
  40:	4b01                	li	s6,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1e8080e7          	jalr	488(ra) # 22e <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	89da                	mv	s3,s6
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01248d63          	beq	s1,s2,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2b85                	addiw	s7,s7,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0997e3          	bnez	s3,52 <wc+0x52>
        w++;
  68:	2c05                	addiw	s8,s8,1
        inword = 1;
  6a:	4985                	li	s3,1
  6c:	b7dd                	j	52 <wc+0x52>
  6e:	01ac8cbb          	addw	s9,s9,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	00001597          	auipc	a1,0x1
  7a:	94a58593          	addi	a1,a1,-1718 # 9c0 <buf>
  7e:	f8843503          	ld	a0,-120(s0)
  82:	00000097          	auipc	ra,0x0
  86:	3b8080e7          	jalr	952(ra) # 43a <read>
  8a:	00a05f63          	blez	a0,a8 <wc+0xa8>
    for(i=0; i<n; i++){
  8e:	00001497          	auipc	s1,0x1
  92:	93248493          	addi	s1,s1,-1742 # 9c0 <buf>
  96:	00050d1b          	sext.w	s10,a0
  9a:	fff5091b          	addiw	s2,a0,-1
  9e:	1902                	slli	s2,s2,0x20
  a0:	02095913          	srli	s2,s2,0x20
  a4:	996e                	add	s2,s2,s11
  a6:	bf4d                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  a8:	02054e63          	bltz	a0,e4 <wc+0xe4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  ac:	f8043703          	ld	a4,-128(s0)
  b0:	86e6                	mv	a3,s9
  b2:	8662                	mv	a2,s8
  b4:	85de                	mv	a1,s7
  b6:	00001517          	auipc	a0,0x1
  ba:	8b250513          	addi	a0,a0,-1870 # 968 <malloc+0x100>
  be:	00000097          	auipc	ra,0x0
  c2:	6ec080e7          	jalr	1772(ra) # 7aa <printf>
}
  c6:	70e6                	ld	ra,120(sp)
  c8:	7446                	ld	s0,112(sp)
  ca:	74a6                	ld	s1,104(sp)
  cc:	7906                	ld	s2,96(sp)
  ce:	69e6                	ld	s3,88(sp)
  d0:	6a46                	ld	s4,80(sp)
  d2:	6aa6                	ld	s5,72(sp)
  d4:	6b06                	ld	s6,64(sp)
  d6:	7be2                	ld	s7,56(sp)
  d8:	7c42                	ld	s8,48(sp)
  da:	7ca2                	ld	s9,40(sp)
  dc:	7d02                	ld	s10,32(sp)
  de:	6de2                	ld	s11,24(sp)
  e0:	6109                	addi	sp,sp,128
  e2:	8082                	ret
    printf("wc: read error\n");
  e4:	00001517          	auipc	a0,0x1
  e8:	87450513          	addi	a0,a0,-1932 # 958 <malloc+0xf0>
  ec:	00000097          	auipc	ra,0x0
  f0:	6be080e7          	jalr	1726(ra) # 7aa <printf>
    exit(1);
  f4:	4505                	li	a0,1
  f6:	00000097          	auipc	ra,0x0
  fa:	32c080e7          	jalr	812(ra) # 422 <exit>

00000000000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	7179                	addi	sp,sp,-48
 100:	f406                	sd	ra,40(sp)
 102:	f022                	sd	s0,32(sp)
 104:	ec26                	sd	s1,24(sp)
 106:	e84a                	sd	s2,16(sp)
 108:	e44e                	sd	s3,8(sp)
 10a:	e052                	sd	s4,0(sp)
 10c:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
 10e:	4785                	li	a5,1
 110:	04a7d763          	bge	a5,a0,15e <main+0x60>
 114:	00858493          	addi	s1,a1,8
 118:	ffe5099b          	addiw	s3,a0,-2
 11c:	1982                	slli	s3,s3,0x20
 11e:	0209d993          	srli	s3,s3,0x20
 122:	098e                	slli	s3,s3,0x3
 124:	05c1                	addi	a1,a1,16
 126:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 128:	4581                	li	a1,0
 12a:	6088                	ld	a0,0(s1)
 12c:	00000097          	auipc	ra,0x0
 130:	336080e7          	jalr	822(ra) # 462 <open>
 134:	892a                	mv	s2,a0
 136:	04054263          	bltz	a0,17a <main+0x7c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 13a:	608c                	ld	a1,0(s1)
 13c:	00000097          	auipc	ra,0x0
 140:	ec4080e7          	jalr	-316(ra) # 0 <wc>
    close(fd);
 144:	854a                	mv	a0,s2
 146:	00000097          	auipc	ra,0x0
 14a:	304080e7          	jalr	772(ra) # 44a <close>
  for(i = 1; i < argc; i++){
 14e:	04a1                	addi	s1,s1,8
 150:	fd349ce3          	bne	s1,s3,128 <main+0x2a>
  }
  exit(0);
 154:	4501                	li	a0,0
 156:	00000097          	auipc	ra,0x0
 15a:	2cc080e7          	jalr	716(ra) # 422 <exit>
    wc(0, "");
 15e:	00001597          	auipc	a1,0x1
 162:	81a58593          	addi	a1,a1,-2022 # 978 <malloc+0x110>
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	e98080e7          	jalr	-360(ra) # 0 <wc>
    exit(0);
 170:	4501                	li	a0,0
 172:	00000097          	auipc	ra,0x0
 176:	2b0080e7          	jalr	688(ra) # 422 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 17a:	608c                	ld	a1,0(s1)
 17c:	00001517          	auipc	a0,0x1
 180:	80450513          	addi	a0,a0,-2044 # 980 <malloc+0x118>
 184:	00000097          	auipc	ra,0x0
 188:	626080e7          	jalr	1574(ra) # 7aa <printf>
      exit(1);
 18c:	4505                	li	a0,1
 18e:	00000097          	auipc	ra,0x0
 192:	294080e7          	jalr	660(ra) # 422 <exit>

0000000000000196 <strcpy>:



char*
strcpy(char *s, const char *t)
{
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 19c:	87aa                	mv	a5,a0
 19e:	0585                	addi	a1,a1,1
 1a0:	0785                	addi	a5,a5,1
 1a2:	fff5c703          	lbu	a4,-1(a1)
 1a6:	fee78fa3          	sb	a4,-1(a5)
 1aa:	fb75                	bnez	a4,19e <strcpy+0x8>
    ;
  return os;
}
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	cb91                	beqz	a5,1d0 <strcmp+0x1e>
 1be:	0005c703          	lbu	a4,0(a1)
 1c2:	00f71763          	bne	a4,a5,1d0 <strcmp+0x1e>
    p++, q++;
 1c6:	0505                	addi	a0,a0,1
 1c8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	fbe5                	bnez	a5,1be <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1d0:	0005c503          	lbu	a0,0(a1)
}
 1d4:	40a7853b          	subw	a0,a5,a0
 1d8:	6422                	ld	s0,8(sp)
 1da:	0141                	addi	sp,sp,16
 1dc:	8082                	ret

00000000000001de <strlen>:

uint
strlen(const char *s)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e422                	sd	s0,8(sp)
 1e2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	cf91                	beqz	a5,204 <strlen+0x26>
 1ea:	0505                	addi	a0,a0,1
 1ec:	87aa                	mv	a5,a0
 1ee:	4685                	li	a3,1
 1f0:	9e89                	subw	a3,a3,a0
 1f2:	00f6853b          	addw	a0,a3,a5
 1f6:	0785                	addi	a5,a5,1
 1f8:	fff7c703          	lbu	a4,-1(a5)
 1fc:	fb7d                	bnez	a4,1f2 <strlen+0x14>
    ;
  return n;
}
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret
  for(n = 0; s[n]; n++)
 204:	4501                	li	a0,0
 206:	bfe5                	j	1fe <strlen+0x20>

0000000000000208 <memset>:

void*
memset(void *dst, int c, uint n)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 20e:	ce09                	beqz	a2,228 <memset+0x20>
 210:	87aa                	mv	a5,a0
 212:	fff6071b          	addiw	a4,a2,-1
 216:	1702                	slli	a4,a4,0x20
 218:	9301                	srli	a4,a4,0x20
 21a:	0705                	addi	a4,a4,1
 21c:	972a                	add	a4,a4,a0
    cdst[i] = c;
 21e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 222:	0785                	addi	a5,a5,1
 224:	fee79de3          	bne	a5,a4,21e <memset+0x16>
  }
  return dst;
}
 228:	6422                	ld	s0,8(sp)
 22a:	0141                	addi	sp,sp,16
 22c:	8082                	ret

000000000000022e <strchr>:

char*
strchr(const char *s, char c)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e422                	sd	s0,8(sp)
 232:	0800                	addi	s0,sp,16
  for(; *s; s++)
 234:	00054783          	lbu	a5,0(a0)
 238:	cb99                	beqz	a5,24e <strchr+0x20>
    if(*s == c)
 23a:	00f58763          	beq	a1,a5,248 <strchr+0x1a>
  for(; *s; s++)
 23e:	0505                	addi	a0,a0,1
 240:	00054783          	lbu	a5,0(a0)
 244:	fbfd                	bnez	a5,23a <strchr+0xc>
      return (char*)s;
  return 0;
 246:	4501                	li	a0,0
}
 248:	6422                	ld	s0,8(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret
  return 0;
 24e:	4501                	li	a0,0
 250:	bfe5                	j	248 <strchr+0x1a>

0000000000000252 <gets>:

char*
gets(char *buf, int max)
{
 252:	711d                	addi	sp,sp,-96
 254:	ec86                	sd	ra,88(sp)
 256:	e8a2                	sd	s0,80(sp)
 258:	e4a6                	sd	s1,72(sp)
 25a:	e0ca                	sd	s2,64(sp)
 25c:	fc4e                	sd	s3,56(sp)
 25e:	f852                	sd	s4,48(sp)
 260:	f456                	sd	s5,40(sp)
 262:	f05a                	sd	s6,32(sp)
 264:	ec5e                	sd	s7,24(sp)
 266:	1080                	addi	s0,sp,96
 268:	8baa                	mv	s7,a0
 26a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26c:	892a                	mv	s2,a0
 26e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 270:	4aa9                	li	s5,10
 272:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 274:	89a6                	mv	s3,s1
 276:	2485                	addiw	s1,s1,1
 278:	0344d863          	bge	s1,s4,2a8 <gets+0x56>
    cc = read(0, &c, 1);
 27c:	4605                	li	a2,1
 27e:	faf40593          	addi	a1,s0,-81
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	1b6080e7          	jalr	438(ra) # 43a <read>
    if(cc < 1)
 28c:	00a05e63          	blez	a0,2a8 <gets+0x56>
    buf[i++] = c;
 290:	faf44783          	lbu	a5,-81(s0)
 294:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 298:	01578763          	beq	a5,s5,2a6 <gets+0x54>
 29c:	0905                	addi	s2,s2,1
 29e:	fd679be3          	bne	a5,s6,274 <gets+0x22>
  for(i=0; i+1 < max; ){
 2a2:	89a6                	mv	s3,s1
 2a4:	a011                	j	2a8 <gets+0x56>
 2a6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2a8:	99de                	add	s3,s3,s7
 2aa:	00098023          	sb	zero,0(s3)
  return buf;
}
 2ae:	855e                	mv	a0,s7
 2b0:	60e6                	ld	ra,88(sp)
 2b2:	6446                	ld	s0,80(sp)
 2b4:	64a6                	ld	s1,72(sp)
 2b6:	6906                	ld	s2,64(sp)
 2b8:	79e2                	ld	s3,56(sp)
 2ba:	7a42                	ld	s4,48(sp)
 2bc:	7aa2                	ld	s5,40(sp)
 2be:	7b02                	ld	s6,32(sp)
 2c0:	6be2                	ld	s7,24(sp)
 2c2:	6125                	addi	sp,sp,96
 2c4:	8082                	ret

00000000000002c6 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c6:	1101                	addi	sp,sp,-32
 2c8:	ec06                	sd	ra,24(sp)
 2ca:	e822                	sd	s0,16(sp)
 2cc:	e426                	sd	s1,8(sp)
 2ce:	e04a                	sd	s2,0(sp)
 2d0:	1000                	addi	s0,sp,32
 2d2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d4:	4581                	li	a1,0
 2d6:	00000097          	auipc	ra,0x0
 2da:	18c080e7          	jalr	396(ra) # 462 <open>
  if(fd < 0)
 2de:	02054563          	bltz	a0,308 <stat+0x42>
 2e2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2e4:	85ca                	mv	a1,s2
 2e6:	00000097          	auipc	ra,0x0
 2ea:	194080e7          	jalr	404(ra) # 47a <fstat>
 2ee:	892a                	mv	s2,a0
  close(fd);
 2f0:	8526                	mv	a0,s1
 2f2:	00000097          	auipc	ra,0x0
 2f6:	158080e7          	jalr	344(ra) # 44a <close>
  return r;
}
 2fa:	854a                	mv	a0,s2
 2fc:	60e2                	ld	ra,24(sp)
 2fe:	6442                	ld	s0,16(sp)
 300:	64a2                	ld	s1,8(sp)
 302:	6902                	ld	s2,0(sp)
 304:	6105                	addi	sp,sp,32
 306:	8082                	ret
    return -1;
 308:	597d                	li	s2,-1
 30a:	bfc5                	j	2fa <stat+0x34>

000000000000030c <atoi>:

int
atoi(const char *s)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 312:	00054603          	lbu	a2,0(a0)
 316:	fd06079b          	addiw	a5,a2,-48
 31a:	0ff7f793          	andi	a5,a5,255
 31e:	4725                	li	a4,9
 320:	02f76963          	bltu	a4,a5,352 <atoi+0x46>
 324:	86aa                	mv	a3,a0
  n = 0;
 326:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 328:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 32a:	0685                	addi	a3,a3,1
 32c:	0025179b          	slliw	a5,a0,0x2
 330:	9fa9                	addw	a5,a5,a0
 332:	0017979b          	slliw	a5,a5,0x1
 336:	9fb1                	addw	a5,a5,a2
 338:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 33c:	0006c603          	lbu	a2,0(a3)
 340:	fd06071b          	addiw	a4,a2,-48
 344:	0ff77713          	andi	a4,a4,255
 348:	fee5f1e3          	bgeu	a1,a4,32a <atoi+0x1e>
  return n;
}
 34c:	6422                	ld	s0,8(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
  n = 0;
 352:	4501                	li	a0,0
 354:	bfe5                	j	34c <atoi+0x40>

0000000000000356 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 356:	1141                	addi	sp,sp,-16
 358:	e422                	sd	s0,8(sp)
 35a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 35c:	02b57663          	bgeu	a0,a1,388 <memmove+0x32>
    while(n-- > 0)
 360:	02c05163          	blez	a2,382 <memmove+0x2c>
 364:	fff6079b          	addiw	a5,a2,-1
 368:	1782                	slli	a5,a5,0x20
 36a:	9381                	srli	a5,a5,0x20
 36c:	0785                	addi	a5,a5,1
 36e:	97aa                	add	a5,a5,a0
  dst = vdst;
 370:	872a                	mv	a4,a0
      *dst++ = *src++;
 372:	0585                	addi	a1,a1,1
 374:	0705                	addi	a4,a4,1
 376:	fff5c683          	lbu	a3,-1(a1)
 37a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 37e:	fee79ae3          	bne	a5,a4,372 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 382:	6422                	ld	s0,8(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret
    dst += n;
 388:	00c50733          	add	a4,a0,a2
    src += n;
 38c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 38e:	fec05ae3          	blez	a2,382 <memmove+0x2c>
 392:	fff6079b          	addiw	a5,a2,-1
 396:	1782                	slli	a5,a5,0x20
 398:	9381                	srli	a5,a5,0x20
 39a:	fff7c793          	not	a5,a5
 39e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3a0:	15fd                	addi	a1,a1,-1
 3a2:	177d                	addi	a4,a4,-1
 3a4:	0005c683          	lbu	a3,0(a1)
 3a8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ac:	fee79ae3          	bne	a5,a4,3a0 <memmove+0x4a>
 3b0:	bfc9                	j	382 <memmove+0x2c>

00000000000003b2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3b2:	1141                	addi	sp,sp,-16
 3b4:	e422                	sd	s0,8(sp)
 3b6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3b8:	ca05                	beqz	a2,3e8 <memcmp+0x36>
 3ba:	fff6069b          	addiw	a3,a2,-1
 3be:	1682                	slli	a3,a3,0x20
 3c0:	9281                	srli	a3,a3,0x20
 3c2:	0685                	addi	a3,a3,1
 3c4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3c6:	00054783          	lbu	a5,0(a0)
 3ca:	0005c703          	lbu	a4,0(a1)
 3ce:	00e79863          	bne	a5,a4,3de <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3d2:	0505                	addi	a0,a0,1
    p2++;
 3d4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3d6:	fed518e3          	bne	a0,a3,3c6 <memcmp+0x14>
  }
  return 0;
 3da:	4501                	li	a0,0
 3dc:	a019                	j	3e2 <memcmp+0x30>
      return *p1 - *p2;
 3de:	40e7853b          	subw	a0,a5,a4
}
 3e2:	6422                	ld	s0,8(sp)
 3e4:	0141                	addi	sp,sp,16
 3e6:	8082                	ret
  return 0;
 3e8:	4501                	li	a0,0
 3ea:	bfe5                	j	3e2 <memcmp+0x30>

00000000000003ec <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ec:	1141                	addi	sp,sp,-16
 3ee:	e406                	sd	ra,8(sp)
 3f0:	e022                	sd	s0,0(sp)
 3f2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3f4:	00000097          	auipc	ra,0x0
 3f8:	f62080e7          	jalr	-158(ra) # 356 <memmove>
}
 3fc:	60a2                	ld	ra,8(sp)
 3fe:	6402                	ld	s0,0(sp)
 400:	0141                	addi	sp,sp,16
 402:	8082                	ret

0000000000000404 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 404:	1141                	addi	sp,sp,-16
 406:	e422                	sd	s0,8(sp)
 408:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 40a:	040007b7          	lui	a5,0x4000
}
 40e:	17f5                	addi	a5,a5,-3
 410:	07b2                	slli	a5,a5,0xc
 412:	4388                	lw	a0,0(a5)
 414:	6422                	ld	s0,8(sp)
 416:	0141                	addi	sp,sp,16
 418:	8082                	ret

000000000000041a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 41a:	4885                	li	a7,1
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <exit>:
.global exit
exit:
 li a7, SYS_exit
 422:	4889                	li	a7,2
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <wait>:
.global wait
wait:
 li a7, SYS_wait
 42a:	488d                	li	a7,3
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 432:	4891                	li	a7,4
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <read>:
.global read
read:
 li a7, SYS_read
 43a:	4895                	li	a7,5
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <write>:
.global write
write:
 li a7, SYS_write
 442:	48c1                	li	a7,16
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <close>:
.global close
close:
 li a7, SYS_close
 44a:	48d5                	li	a7,21
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <kill>:
.global kill
kill:
 li a7, SYS_kill
 452:	4899                	li	a7,6
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <exec>:
.global exec
exec:
 li a7, SYS_exec
 45a:	489d                	li	a7,7
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <open>:
.global open
open:
 li a7, SYS_open
 462:	48bd                	li	a7,15
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 46a:	48c5                	li	a7,17
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 472:	48c9                	li	a7,18
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 47a:	48a1                	li	a7,8
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <link>:
.global link
link:
 li a7, SYS_link
 482:	48cd                	li	a7,19
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 48a:	48d1                	li	a7,20
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 492:	48a5                	li	a7,9
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <dup>:
.global dup
dup:
 li a7, SYS_dup
 49a:	48a9                	li	a7,10
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4a2:	48ad                	li	a7,11
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4aa:	48b1                	li	a7,12
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4b2:	48b5                	li	a7,13
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ba:	48b9                	li	a7,14
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <connect>:
.global connect
connect:
 li a7, SYS_connect
 4c2:	48f5                	li	a7,29
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 4ca:	48f9                	li	a7,30
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4d2:	1101                	addi	sp,sp,-32
 4d4:	ec06                	sd	ra,24(sp)
 4d6:	e822                	sd	s0,16(sp)
 4d8:	1000                	addi	s0,sp,32
 4da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4de:	4605                	li	a2,1
 4e0:	fef40593          	addi	a1,s0,-17
 4e4:	00000097          	auipc	ra,0x0
 4e8:	f5e080e7          	jalr	-162(ra) # 442 <write>
}
 4ec:	60e2                	ld	ra,24(sp)
 4ee:	6442                	ld	s0,16(sp)
 4f0:	6105                	addi	sp,sp,32
 4f2:	8082                	ret

00000000000004f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f4:	7139                	addi	sp,sp,-64
 4f6:	fc06                	sd	ra,56(sp)
 4f8:	f822                	sd	s0,48(sp)
 4fa:	f426                	sd	s1,40(sp)
 4fc:	f04a                	sd	s2,32(sp)
 4fe:	ec4e                	sd	s3,24(sp)
 500:	0080                	addi	s0,sp,64
 502:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 504:	c299                	beqz	a3,50a <printint+0x16>
 506:	0805c863          	bltz	a1,596 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 50a:	2581                	sext.w	a1,a1
  neg = 0;
 50c:	4881                	li	a7,0
 50e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 512:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 514:	2601                	sext.w	a2,a2
 516:	00000517          	auipc	a0,0x0
 51a:	48a50513          	addi	a0,a0,1162 # 9a0 <digits>
 51e:	883a                	mv	a6,a4
 520:	2705                	addiw	a4,a4,1
 522:	02c5f7bb          	remuw	a5,a1,a2
 526:	1782                	slli	a5,a5,0x20
 528:	9381                	srli	a5,a5,0x20
 52a:	97aa                	add	a5,a5,a0
 52c:	0007c783          	lbu	a5,0(a5) # 4000000 <__global_pointer$+0x3ffee4f>
 530:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 534:	0005879b          	sext.w	a5,a1
 538:	02c5d5bb          	divuw	a1,a1,a2
 53c:	0685                	addi	a3,a3,1
 53e:	fec7f0e3          	bgeu	a5,a2,51e <printint+0x2a>
  if(neg)
 542:	00088b63          	beqz	a7,558 <printint+0x64>
    buf[i++] = '-';
 546:	fd040793          	addi	a5,s0,-48
 54a:	973e                	add	a4,a4,a5
 54c:	02d00793          	li	a5,45
 550:	fef70823          	sb	a5,-16(a4)
 554:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 558:	02e05863          	blez	a4,588 <printint+0x94>
 55c:	fc040793          	addi	a5,s0,-64
 560:	00e78933          	add	s2,a5,a4
 564:	fff78993          	addi	s3,a5,-1
 568:	99ba                	add	s3,s3,a4
 56a:	377d                	addiw	a4,a4,-1
 56c:	1702                	slli	a4,a4,0x20
 56e:	9301                	srli	a4,a4,0x20
 570:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 574:	fff94583          	lbu	a1,-1(s2)
 578:	8526                	mv	a0,s1
 57a:	00000097          	auipc	ra,0x0
 57e:	f58080e7          	jalr	-168(ra) # 4d2 <putc>
  while(--i >= 0)
 582:	197d                	addi	s2,s2,-1
 584:	ff3918e3          	bne	s2,s3,574 <printint+0x80>
}
 588:	70e2                	ld	ra,56(sp)
 58a:	7442                	ld	s0,48(sp)
 58c:	74a2                	ld	s1,40(sp)
 58e:	7902                	ld	s2,32(sp)
 590:	69e2                	ld	s3,24(sp)
 592:	6121                	addi	sp,sp,64
 594:	8082                	ret
    x = -xx;
 596:	40b005bb          	negw	a1,a1
    neg = 1;
 59a:	4885                	li	a7,1
    x = -xx;
 59c:	bf8d                	j	50e <printint+0x1a>

000000000000059e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 59e:	7119                	addi	sp,sp,-128
 5a0:	fc86                	sd	ra,120(sp)
 5a2:	f8a2                	sd	s0,112(sp)
 5a4:	f4a6                	sd	s1,104(sp)
 5a6:	f0ca                	sd	s2,96(sp)
 5a8:	ecce                	sd	s3,88(sp)
 5aa:	e8d2                	sd	s4,80(sp)
 5ac:	e4d6                	sd	s5,72(sp)
 5ae:	e0da                	sd	s6,64(sp)
 5b0:	fc5e                	sd	s7,56(sp)
 5b2:	f862                	sd	s8,48(sp)
 5b4:	f466                	sd	s9,40(sp)
 5b6:	f06a                	sd	s10,32(sp)
 5b8:	ec6e                	sd	s11,24(sp)
 5ba:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5bc:	0005c903          	lbu	s2,0(a1)
 5c0:	18090f63          	beqz	s2,75e <vprintf+0x1c0>
 5c4:	8aaa                	mv	s5,a0
 5c6:	8b32                	mv	s6,a2
 5c8:	00158493          	addi	s1,a1,1
  state = 0;
 5cc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5ce:	02500a13          	li	s4,37
      if(c == 'd'){
 5d2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5d6:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5da:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5de:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e2:	00000b97          	auipc	s7,0x0
 5e6:	3beb8b93          	addi	s7,s7,958 # 9a0 <digits>
 5ea:	a839                	j	608 <vprintf+0x6a>
        putc(fd, c);
 5ec:	85ca                	mv	a1,s2
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	ee2080e7          	jalr	-286(ra) # 4d2 <putc>
 5f8:	a019                	j	5fe <vprintf+0x60>
    } else if(state == '%'){
 5fa:	01498f63          	beq	s3,s4,618 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5fe:	0485                	addi	s1,s1,1
 600:	fff4c903          	lbu	s2,-1(s1)
 604:	14090d63          	beqz	s2,75e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 608:	0009079b          	sext.w	a5,s2
    if(state == 0){
 60c:	fe0997e3          	bnez	s3,5fa <vprintf+0x5c>
      if(c == '%'){
 610:	fd479ee3          	bne	a5,s4,5ec <vprintf+0x4e>
        state = '%';
 614:	89be                	mv	s3,a5
 616:	b7e5                	j	5fe <vprintf+0x60>
      if(c == 'd'){
 618:	05878063          	beq	a5,s8,658 <vprintf+0xba>
      } else if(c == 'l') {
 61c:	05978c63          	beq	a5,s9,674 <vprintf+0xd6>
      } else if(c == 'x') {
 620:	07a78863          	beq	a5,s10,690 <vprintf+0xf2>
      } else if(c == 'p') {
 624:	09b78463          	beq	a5,s11,6ac <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 628:	07300713          	li	a4,115
 62c:	0ce78663          	beq	a5,a4,6f8 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 630:	06300713          	li	a4,99
 634:	0ee78e63          	beq	a5,a4,730 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 638:	11478863          	beq	a5,s4,748 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 63c:	85d2                	mv	a1,s4
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	e92080e7          	jalr	-366(ra) # 4d2 <putc>
        putc(fd, c);
 648:	85ca                	mv	a1,s2
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	e86080e7          	jalr	-378(ra) # 4d2 <putc>
      }
      state = 0;
 654:	4981                	li	s3,0
 656:	b765                	j	5fe <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 658:	008b0913          	addi	s2,s6,8
 65c:	4685                	li	a3,1
 65e:	4629                	li	a2,10
 660:	000b2583          	lw	a1,0(s6)
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	e8e080e7          	jalr	-370(ra) # 4f4 <printint>
 66e:	8b4a                	mv	s6,s2
      state = 0;
 670:	4981                	li	s3,0
 672:	b771                	j	5fe <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 674:	008b0913          	addi	s2,s6,8
 678:	4681                	li	a3,0
 67a:	4629                	li	a2,10
 67c:	000b2583          	lw	a1,0(s6)
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	e72080e7          	jalr	-398(ra) # 4f4 <printint>
 68a:	8b4a                	mv	s6,s2
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bf85                	j	5fe <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 690:	008b0913          	addi	s2,s6,8
 694:	4681                	li	a3,0
 696:	4641                	li	a2,16
 698:	000b2583          	lw	a1,0(s6)
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	e56080e7          	jalr	-426(ra) # 4f4 <printint>
 6a6:	8b4a                	mv	s6,s2
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	bf91                	j	5fe <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6ac:	008b0793          	addi	a5,s6,8
 6b0:	f8f43423          	sd	a5,-120(s0)
 6b4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6b8:	03000593          	li	a1,48
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	e14080e7          	jalr	-492(ra) # 4d2 <putc>
  putc(fd, 'x');
 6c6:	85ea                	mv	a1,s10
 6c8:	8556                	mv	a0,s5
 6ca:	00000097          	auipc	ra,0x0
 6ce:	e08080e7          	jalr	-504(ra) # 4d2 <putc>
 6d2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d4:	03c9d793          	srli	a5,s3,0x3c
 6d8:	97de                	add	a5,a5,s7
 6da:	0007c583          	lbu	a1,0(a5)
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	df2080e7          	jalr	-526(ra) # 4d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e8:	0992                	slli	s3,s3,0x4
 6ea:	397d                	addiw	s2,s2,-1
 6ec:	fe0914e3          	bnez	s2,6d4 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6f0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b721                	j	5fe <vprintf+0x60>
        s = va_arg(ap, char*);
 6f8:	008b0993          	addi	s3,s6,8
 6fc:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 700:	02090163          	beqz	s2,722 <vprintf+0x184>
        while(*s != 0){
 704:	00094583          	lbu	a1,0(s2)
 708:	c9a1                	beqz	a1,758 <vprintf+0x1ba>
          putc(fd, *s);
 70a:	8556                	mv	a0,s5
 70c:	00000097          	auipc	ra,0x0
 710:	dc6080e7          	jalr	-570(ra) # 4d2 <putc>
          s++;
 714:	0905                	addi	s2,s2,1
        while(*s != 0){
 716:	00094583          	lbu	a1,0(s2)
 71a:	f9e5                	bnez	a1,70a <vprintf+0x16c>
        s = va_arg(ap, char*);
 71c:	8b4e                	mv	s6,s3
      state = 0;
 71e:	4981                	li	s3,0
 720:	bdf9                	j	5fe <vprintf+0x60>
          s = "(null)";
 722:	00000917          	auipc	s2,0x0
 726:	27690913          	addi	s2,s2,630 # 998 <malloc+0x130>
        while(*s != 0){
 72a:	02800593          	li	a1,40
 72e:	bff1                	j	70a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 730:	008b0913          	addi	s2,s6,8
 734:	000b4583          	lbu	a1,0(s6)
 738:	8556                	mv	a0,s5
 73a:	00000097          	auipc	ra,0x0
 73e:	d98080e7          	jalr	-616(ra) # 4d2 <putc>
 742:	8b4a                	mv	s6,s2
      state = 0;
 744:	4981                	li	s3,0
 746:	bd65                	j	5fe <vprintf+0x60>
        putc(fd, c);
 748:	85d2                	mv	a1,s4
 74a:	8556                	mv	a0,s5
 74c:	00000097          	auipc	ra,0x0
 750:	d86080e7          	jalr	-634(ra) # 4d2 <putc>
      state = 0;
 754:	4981                	li	s3,0
 756:	b565                	j	5fe <vprintf+0x60>
        s = va_arg(ap, char*);
 758:	8b4e                	mv	s6,s3
      state = 0;
 75a:	4981                	li	s3,0
 75c:	b54d                	j	5fe <vprintf+0x60>
    }
  }
}
 75e:	70e6                	ld	ra,120(sp)
 760:	7446                	ld	s0,112(sp)
 762:	74a6                	ld	s1,104(sp)
 764:	7906                	ld	s2,96(sp)
 766:	69e6                	ld	s3,88(sp)
 768:	6a46                	ld	s4,80(sp)
 76a:	6aa6                	ld	s5,72(sp)
 76c:	6b06                	ld	s6,64(sp)
 76e:	7be2                	ld	s7,56(sp)
 770:	7c42                	ld	s8,48(sp)
 772:	7ca2                	ld	s9,40(sp)
 774:	7d02                	ld	s10,32(sp)
 776:	6de2                	ld	s11,24(sp)
 778:	6109                	addi	sp,sp,128
 77a:	8082                	ret

000000000000077c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 77c:	715d                	addi	sp,sp,-80
 77e:	ec06                	sd	ra,24(sp)
 780:	e822                	sd	s0,16(sp)
 782:	1000                	addi	s0,sp,32
 784:	e010                	sd	a2,0(s0)
 786:	e414                	sd	a3,8(s0)
 788:	e818                	sd	a4,16(s0)
 78a:	ec1c                	sd	a5,24(s0)
 78c:	03043023          	sd	a6,32(s0)
 790:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 794:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 798:	8622                	mv	a2,s0
 79a:	00000097          	auipc	ra,0x0
 79e:	e04080e7          	jalr	-508(ra) # 59e <vprintf>
}
 7a2:	60e2                	ld	ra,24(sp)
 7a4:	6442                	ld	s0,16(sp)
 7a6:	6161                	addi	sp,sp,80
 7a8:	8082                	ret

00000000000007aa <printf>:

void
printf(const char *fmt, ...)
{
 7aa:	711d                	addi	sp,sp,-96
 7ac:	ec06                	sd	ra,24(sp)
 7ae:	e822                	sd	s0,16(sp)
 7b0:	1000                	addi	s0,sp,32
 7b2:	e40c                	sd	a1,8(s0)
 7b4:	e810                	sd	a2,16(s0)
 7b6:	ec14                	sd	a3,24(s0)
 7b8:	f018                	sd	a4,32(s0)
 7ba:	f41c                	sd	a5,40(s0)
 7bc:	03043823          	sd	a6,48(s0)
 7c0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c4:	00840613          	addi	a2,s0,8
 7c8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7cc:	85aa                	mv	a1,a0
 7ce:	4505                	li	a0,1
 7d0:	00000097          	auipc	ra,0x0
 7d4:	dce080e7          	jalr	-562(ra) # 59e <vprintf>
}
 7d8:	60e2                	ld	ra,24(sp)
 7da:	6442                	ld	s0,16(sp)
 7dc:	6125                	addi	sp,sp,96
 7de:	8082                	ret

00000000000007e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e0:	1141                	addi	sp,sp,-16
 7e2:	e422                	sd	s0,8(sp)
 7e4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ea:	00000797          	auipc	a5,0x0
 7ee:	1ce7b783          	ld	a5,462(a5) # 9b8 <freep>
 7f2:	a805                	j	822 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7f4:	4618                	lw	a4,8(a2)
 7f6:	9db9                	addw	a1,a1,a4
 7f8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7fc:	6398                	ld	a4,0(a5)
 7fe:	6318                	ld	a4,0(a4)
 800:	fee53823          	sd	a4,-16(a0)
 804:	a091                	j	848 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 806:	ff852703          	lw	a4,-8(a0)
 80a:	9e39                	addw	a2,a2,a4
 80c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 80e:	ff053703          	ld	a4,-16(a0)
 812:	e398                	sd	a4,0(a5)
 814:	a099                	j	85a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 816:	6398                	ld	a4,0(a5)
 818:	00e7e463          	bltu	a5,a4,820 <free+0x40>
 81c:	00e6ea63          	bltu	a3,a4,830 <free+0x50>
{
 820:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 822:	fed7fae3          	bgeu	a5,a3,816 <free+0x36>
 826:	6398                	ld	a4,0(a5)
 828:	00e6e463          	bltu	a3,a4,830 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82c:	fee7eae3          	bltu	a5,a4,820 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 830:	ff852583          	lw	a1,-8(a0)
 834:	6390                	ld	a2,0(a5)
 836:	02059713          	slli	a4,a1,0x20
 83a:	9301                	srli	a4,a4,0x20
 83c:	0712                	slli	a4,a4,0x4
 83e:	9736                	add	a4,a4,a3
 840:	fae60ae3          	beq	a2,a4,7f4 <free+0x14>
    bp->s.ptr = p->s.ptr;
 844:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 848:	4790                	lw	a2,8(a5)
 84a:	02061713          	slli	a4,a2,0x20
 84e:	9301                	srli	a4,a4,0x20
 850:	0712                	slli	a4,a4,0x4
 852:	973e                	add	a4,a4,a5
 854:	fae689e3          	beq	a3,a4,806 <free+0x26>
  } else
    p->s.ptr = bp;
 858:	e394                	sd	a3,0(a5)
  freep = p;
 85a:	00000717          	auipc	a4,0x0
 85e:	14f73f23          	sd	a5,350(a4) # 9b8 <freep>
}
 862:	6422                	ld	s0,8(sp)
 864:	0141                	addi	sp,sp,16
 866:	8082                	ret

0000000000000868 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 868:	7139                	addi	sp,sp,-64
 86a:	fc06                	sd	ra,56(sp)
 86c:	f822                	sd	s0,48(sp)
 86e:	f426                	sd	s1,40(sp)
 870:	f04a                	sd	s2,32(sp)
 872:	ec4e                	sd	s3,24(sp)
 874:	e852                	sd	s4,16(sp)
 876:	e456                	sd	s5,8(sp)
 878:	e05a                	sd	s6,0(sp)
 87a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87c:	02051493          	slli	s1,a0,0x20
 880:	9081                	srli	s1,s1,0x20
 882:	04bd                	addi	s1,s1,15
 884:	8091                	srli	s1,s1,0x4
 886:	0014899b          	addiw	s3,s1,1
 88a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 88c:	00000517          	auipc	a0,0x0
 890:	12c53503          	ld	a0,300(a0) # 9b8 <freep>
 894:	c515                	beqz	a0,8c0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 896:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 898:	4798                	lw	a4,8(a5)
 89a:	02977f63          	bgeu	a4,s1,8d8 <malloc+0x70>
 89e:	8a4e                	mv	s4,s3
 8a0:	0009871b          	sext.w	a4,s3
 8a4:	6685                	lui	a3,0x1
 8a6:	00d77363          	bgeu	a4,a3,8ac <malloc+0x44>
 8aa:	6a05                	lui	s4,0x1
 8ac:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b4:	00000917          	auipc	s2,0x0
 8b8:	10490913          	addi	s2,s2,260 # 9b8 <freep>
  if(p == (char*)-1)
 8bc:	5afd                	li	s5,-1
 8be:	a88d                	j	930 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8c0:	00000797          	auipc	a5,0x0
 8c4:	30078793          	addi	a5,a5,768 # bc0 <base>
 8c8:	00000717          	auipc	a4,0x0
 8cc:	0ef73823          	sd	a5,240(a4) # 9b8 <freep>
 8d0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8d6:	b7e1                	j	89e <malloc+0x36>
      if(p->s.size == nunits)
 8d8:	02e48b63          	beq	s1,a4,90e <malloc+0xa6>
        p->s.size -= nunits;
 8dc:	4137073b          	subw	a4,a4,s3
 8e0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e2:	1702                	slli	a4,a4,0x20
 8e4:	9301                	srli	a4,a4,0x20
 8e6:	0712                	slli	a4,a4,0x4
 8e8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ea:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ee:	00000717          	auipc	a4,0x0
 8f2:	0ca73523          	sd	a0,202(a4) # 9b8 <freep>
      return (void*)(p + 1);
 8f6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8fa:	70e2                	ld	ra,56(sp)
 8fc:	7442                	ld	s0,48(sp)
 8fe:	74a2                	ld	s1,40(sp)
 900:	7902                	ld	s2,32(sp)
 902:	69e2                	ld	s3,24(sp)
 904:	6a42                	ld	s4,16(sp)
 906:	6aa2                	ld	s5,8(sp)
 908:	6b02                	ld	s6,0(sp)
 90a:	6121                	addi	sp,sp,64
 90c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 90e:	6398                	ld	a4,0(a5)
 910:	e118                	sd	a4,0(a0)
 912:	bff1                	j	8ee <malloc+0x86>
  hp->s.size = nu;
 914:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 918:	0541                	addi	a0,a0,16
 91a:	00000097          	auipc	ra,0x0
 91e:	ec6080e7          	jalr	-314(ra) # 7e0 <free>
  return freep;
 922:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 926:	d971                	beqz	a0,8fa <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 928:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 92a:	4798                	lw	a4,8(a5)
 92c:	fa9776e3          	bgeu	a4,s1,8d8 <malloc+0x70>
    if(p == freep)
 930:	00093703          	ld	a4,0(s2)
 934:	853e                	mv	a0,a5
 936:	fef719e3          	bne	a4,a5,928 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 93a:	8552                	mv	a0,s4
 93c:	00000097          	auipc	ra,0x0
 940:	b6e080e7          	jalr	-1170(ra) # 4aa <sbrk>
  if(p == (char*)-1)
 944:	fd5518e3          	bne	a0,s5,914 <malloc+0xac>
        return 0;
 948:	4501                	li	a0,0
 94a:	bf45                	j	8fa <malloc+0x92>
