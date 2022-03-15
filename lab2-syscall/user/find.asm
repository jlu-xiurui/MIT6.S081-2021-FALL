
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
static char target[DIRSIZ];
static char path[BUFSIZE];
static void search(void);

char* fmtname()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   e:	00001497          	auipc	s1,0x1
  12:	ab248493          	addi	s1,s1,-1358 # ac0 <path>
  16:	8526                	mv	a0,s1
  18:	00000097          	auipc	ra,0x0
  1c:	2c0080e7          	jalr	704(ra) # 2d8 <strlen>
  20:	1502                	slli	a0,a0,0x20
  22:	9101                	srli	a0,a0,0x20
  24:	9526                	add	a0,a0,s1
  26:	02f00713          	li	a4,47
  2a:	86a6                	mv	a3,s1
  2c:	00956963          	bltu	a0,s1,3e <fmtname+0x3e>
  30:	00054783          	lbu	a5,0(a0)
  34:	00e78563          	beq	a5,a4,3e <fmtname+0x3e>
  38:	157d                	addi	a0,a0,-1
  3a:	fed57be3          	bgeu	a0,a3,30 <fmtname+0x30>
    ;
  p++;
  3e:	00150493          	addi	s1,a0,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  42:	8526                	mv	a0,s1
  44:	00000097          	auipc	ra,0x0
  48:	294080e7          	jalr	660(ra) # 2d8 <strlen>
  4c:	2501                	sext.w	a0,a0
  4e:	47b5                	li	a5,13
  50:	00a7fa63          	bgeu	a5,a0,64 <fmtname+0x64>
	  return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), 0, DIRSIZ-strlen(p));
  return buf;
}
  54:	8526                	mv	a0,s1
  56:	70a2                	ld	ra,40(sp)
  58:	7402                	ld	s0,32(sp)
  5a:	64e2                	ld	s1,24(sp)
  5c:	6942                	ld	s2,16(sp)
  5e:	69a2                	ld	s3,8(sp)
  60:	6145                	addi	sp,sp,48
  62:	8082                	ret
  memmove(buf, p, strlen(p));
  64:	8526                	mv	a0,s1
  66:	00000097          	auipc	ra,0x0
  6a:	272080e7          	jalr	626(ra) # 2d8 <strlen>
  6e:	00001997          	auipc	s3,0x1
  72:	a4298993          	addi	s3,s3,-1470 # ab0 <buf.1115>
  76:	0005061b          	sext.w	a2,a0
  7a:	85a6                	mv	a1,s1
  7c:	854e                	mv	a0,s3
  7e:	00000097          	auipc	ra,0x0
  82:	3d2080e7          	jalr	978(ra) # 450 <memmove>
  memset(buf+strlen(p), 0, DIRSIZ-strlen(p));
  86:	8526                	mv	a0,s1
  88:	00000097          	auipc	ra,0x0
  8c:	250080e7          	jalr	592(ra) # 2d8 <strlen>
  90:	0005091b          	sext.w	s2,a0
  94:	8526                	mv	a0,s1
  96:	00000097          	auipc	ra,0x0
  9a:	242080e7          	jalr	578(ra) # 2d8 <strlen>
  9e:	1902                	slli	s2,s2,0x20
  a0:	02095913          	srli	s2,s2,0x20
  a4:	4639                	li	a2,14
  a6:	9e09                	subw	a2,a2,a0
  a8:	4581                	li	a1,0
  aa:	01298533          	add	a0,s3,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	254080e7          	jalr	596(ra) # 302 <memset>
  return buf;
  b6:	84ce                	mv	s1,s3
  b8:	bf71                	j	54 <fmtname+0x54>

00000000000000ba <search>:
	strcpy(path,argv[1]);
	strcpy(target,argv[2]);
	search();
	exit(0);
}
static void search(void){
  ba:	7159                	addi	sp,sp,-112
  bc:	f486                	sd	ra,104(sp)
  be:	f0a2                	sd	s0,96(sp)
  c0:	eca6                	sd	s1,88(sp)
  c2:	e8ca                	sd	s2,80(sp)
  c4:	e4ce                	sd	s3,72(sp)
  c6:	e0d2                	sd	s4,64(sp)
  c8:	fc56                	sd	s5,56(sp)
  ca:	1880                	addi	s0,sp,112
	char* p;
	int fd;
	struct dirent de;
	struct stat st;
	if((fd = open(path,0)) < 0){
  cc:	4581                	li	a1,0
  ce:	00001517          	auipc	a0,0x1
  d2:	9f250513          	addi	a0,a0,-1550 # ac0 <path>
  d6:	00000097          	auipc	ra,0x0
  da:	470080e7          	jalr	1136(ra) # 546 <open>
  de:	06054163          	bltz	a0,140 <search+0x86>
  e2:	84aa                	mv	s1,a0
		fprintf(2,"open err\n");
		exit(1);
	}
	if(fstat(fd,&st) < 0){
  e4:	f9840593          	addi	a1,s0,-104
  e8:	00000097          	auipc	ra,0x0
  ec:	476080e7          	jalr	1142(ra) # 55e <fstat>
  f0:	06054663          	bltz	a0,15c <search+0xa2>
		fprintf(2,"fstat err\n");
		exit(1);
	}
	
	switch(st.type){
  f4:	fa041783          	lh	a5,-96(s0)
  f8:	0007869b          	sext.w	a3,a5
  fc:	4705                	li	a4,1
  fe:	08e68a63          	beq	a3,a4,192 <search+0xd8>
 102:	4709                	li	a4,2
 104:	02e69063          	bne	a3,a4,124 <search+0x6a>
	case T_FILE:
		if(!strcmp(target,fmtname())){
 108:	00000097          	auipc	ra,0x0
 10c:	ef8080e7          	jalr	-264(ra) # 0 <fmtname>
 110:	85aa                	mv	a1,a0
 112:	00001517          	auipc	a0,0x1
 116:	bae50513          	addi	a0,a0,-1106 # cc0 <target>
 11a:	00000097          	auipc	ra,0x0
 11e:	192080e7          	jalr	402(ra) # 2ac <strcmp>
 122:	c939                	beqz	a0,178 <search+0xbe>
			if(strcmp(p,".") && strcmp(p,".."))
				search();
			memset(p,0,DIRSIZ);
		}
	}
	close(fd);
 124:	8526                	mv	a0,s1
 126:	00000097          	auipc	ra,0x0
 12a:	408080e7          	jalr	1032(ra) # 52e <close>
}
 12e:	70a6                	ld	ra,104(sp)
 130:	7406                	ld	s0,96(sp)
 132:	64e6                	ld	s1,88(sp)
 134:	6946                	ld	s2,80(sp)
 136:	69a6                	ld	s3,72(sp)
 138:	6a06                	ld	s4,64(sp)
 13a:	7ae2                	ld	s5,56(sp)
 13c:	6165                	addi	sp,sp,112
 13e:	8082                	ret
		fprintf(2,"open err\n");
 140:	00001597          	auipc	a1,0x1
 144:	8f058593          	addi	a1,a1,-1808 # a30 <malloc+0xe4>
 148:	4509                	li	a0,2
 14a:	00000097          	auipc	ra,0x0
 14e:	716080e7          	jalr	1814(ra) # 860 <fprintf>
		exit(1);
 152:	4505                	li	a0,1
 154:	00000097          	auipc	ra,0x0
 158:	3b2080e7          	jalr	946(ra) # 506 <exit>
		fprintf(2,"fstat err\n");
 15c:	00001597          	auipc	a1,0x1
 160:	8e458593          	addi	a1,a1,-1820 # a40 <malloc+0xf4>
 164:	4509                	li	a0,2
 166:	00000097          	auipc	ra,0x0
 16a:	6fa080e7          	jalr	1786(ra) # 860 <fprintf>
		exit(1);
 16e:	4505                	li	a0,1
 170:	00000097          	auipc	ra,0x0
 174:	396080e7          	jalr	918(ra) # 506 <exit>
			printf("%s\n",path);
 178:	00001597          	auipc	a1,0x1
 17c:	94858593          	addi	a1,a1,-1720 # ac0 <path>
 180:	00001517          	auipc	a0,0x1
 184:	8d050513          	addi	a0,a0,-1840 # a50 <malloc+0x104>
 188:	00000097          	auipc	ra,0x0
 18c:	706080e7          	jalr	1798(ra) # 88e <printf>
 190:	bf51                	j	124 <search+0x6a>
		p = path + strlen(path);
 192:	00001917          	auipc	s2,0x1
 196:	92e90913          	addi	s2,s2,-1746 # ac0 <path>
 19a:	854a                	mv	a0,s2
 19c:	00000097          	auipc	ra,0x0
 1a0:	13c080e7          	jalr	316(ra) # 2d8 <strlen>
 1a4:	1502                	slli	a0,a0,0x20
 1a6:	9101                	srli	a0,a0,0x20
 1a8:	992a                	add	s2,s2,a0
		*p++ = '/';
 1aa:	00190993          	addi	s3,s2,1
 1ae:	02f00793          	li	a5,47
 1b2:	00f90023          	sb	a5,0(s2)
			if(strcmp(p,".") && strcmp(p,".."))
 1b6:	00001a17          	auipc	s4,0x1
 1ba:	8a2a0a13          	addi	s4,s4,-1886 # a58 <malloc+0x10c>
 1be:	00001a97          	auipc	s5,0x1
 1c2:	8a2a8a93          	addi	s5,s5,-1886 # a60 <malloc+0x114>
		while(read(fd,&de,sizeof(de)) == sizeof(de)){
 1c6:	a801                	j	1d6 <search+0x11c>
			memset(p,0,DIRSIZ);
 1c8:	4639                	li	a2,14
 1ca:	4581                	li	a1,0
 1cc:	854e                	mv	a0,s3
 1ce:	00000097          	auipc	ra,0x0
 1d2:	134080e7          	jalr	308(ra) # 302 <memset>
		while(read(fd,&de,sizeof(de)) == sizeof(de)){
 1d6:	4641                	li	a2,16
 1d8:	fb040593          	addi	a1,s0,-80
 1dc:	8526                	mv	a0,s1
 1de:	00000097          	auipc	ra,0x0
 1e2:	340080e7          	jalr	832(ra) # 51e <read>
 1e6:	47c1                	li	a5,16
 1e8:	f2f51ee3          	bne	a0,a5,124 <search+0x6a>
			if(de.inum == 0)
 1ec:	fb045783          	lhu	a5,-80(s0)
 1f0:	d3fd                	beqz	a5,1d6 <search+0x11c>
			memmove(p,de.name,DIRSIZ);
 1f2:	4639                	li	a2,14
 1f4:	fb240593          	addi	a1,s0,-78
 1f8:	854e                	mv	a0,s3
 1fa:	00000097          	auipc	ra,0x0
 1fe:	256080e7          	jalr	598(ra) # 450 <memmove>
			p[DIRSIZ] = 0;
 202:	000907a3          	sb	zero,15(s2)
			if(strcmp(p,".") && strcmp(p,".."))
 206:	85d2                	mv	a1,s4
 208:	854e                	mv	a0,s3
 20a:	00000097          	auipc	ra,0x0
 20e:	0a2080e7          	jalr	162(ra) # 2ac <strcmp>
 212:	d95d                	beqz	a0,1c8 <search+0x10e>
 214:	85d6                	mv	a1,s5
 216:	854e                	mv	a0,s3
 218:	00000097          	auipc	ra,0x0
 21c:	094080e7          	jalr	148(ra) # 2ac <strcmp>
 220:	d545                	beqz	a0,1c8 <search+0x10e>
				search();
 222:	00000097          	auipc	ra,0x0
 226:	e98080e7          	jalr	-360(ra) # ba <search>
 22a:	bf79                	j	1c8 <search+0x10e>

000000000000022c <main>:
int main(int argc,char* argv[]){
 22c:	1101                	addi	sp,sp,-32
 22e:	ec06                	sd	ra,24(sp)
 230:	e822                	sd	s0,16(sp)
 232:	e426                	sd	s1,8(sp)
 234:	1000                	addi	s0,sp,32
	if(argc != 3){
 236:	478d                	li	a5,3
 238:	02f50063          	beq	a0,a5,258 <main+0x2c>
		fprintf(2,"find <pathname> <filename>\n");
 23c:	00001597          	auipc	a1,0x1
 240:	82c58593          	addi	a1,a1,-2004 # a68 <malloc+0x11c>
 244:	4509                	li	a0,2
 246:	00000097          	auipc	ra,0x0
 24a:	61a080e7          	jalr	1562(ra) # 860 <fprintf>
		exit(1);
 24e:	4505                	li	a0,1
 250:	00000097          	auipc	ra,0x0
 254:	2b6080e7          	jalr	694(ra) # 506 <exit>
 258:	84ae                	mv	s1,a1
	strcpy(path,argv[1]);
 25a:	658c                	ld	a1,8(a1)
 25c:	00001517          	auipc	a0,0x1
 260:	86450513          	addi	a0,a0,-1948 # ac0 <path>
 264:	00000097          	auipc	ra,0x0
 268:	02c080e7          	jalr	44(ra) # 290 <strcpy>
	strcpy(target,argv[2]);
 26c:	688c                	ld	a1,16(s1)
 26e:	00001517          	auipc	a0,0x1
 272:	a5250513          	addi	a0,a0,-1454 # cc0 <target>
 276:	00000097          	auipc	ra,0x0
 27a:	01a080e7          	jalr	26(ra) # 290 <strcpy>
	search();
 27e:	00000097          	auipc	ra,0x0
 282:	e3c080e7          	jalr	-452(ra) # ba <search>
	exit(0);
 286:	4501                	li	a0,0
 288:	00000097          	auipc	ra,0x0
 28c:	27e080e7          	jalr	638(ra) # 506 <exit>

0000000000000290 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 296:	87aa                	mv	a5,a0
 298:	0585                	addi	a1,a1,1
 29a:	0785                	addi	a5,a5,1
 29c:	fff5c703          	lbu	a4,-1(a1)
 2a0:	fee78fa3          	sb	a4,-1(a5)
 2a4:	fb75                	bnez	a4,298 <strcpy+0x8>
    ;
  return os;
}
 2a6:	6422                	ld	s0,8(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret

00000000000002ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ac:	1141                	addi	sp,sp,-16
 2ae:	e422                	sd	s0,8(sp)
 2b0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2b2:	00054783          	lbu	a5,0(a0)
 2b6:	cb91                	beqz	a5,2ca <strcmp+0x1e>
 2b8:	0005c703          	lbu	a4,0(a1)
 2bc:	00f71763          	bne	a4,a5,2ca <strcmp+0x1e>
    p++, q++;
 2c0:	0505                	addi	a0,a0,1
 2c2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	fbe5                	bnez	a5,2b8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2ca:	0005c503          	lbu	a0,0(a1)
}
 2ce:	40a7853b          	subw	a0,a5,a0
 2d2:	6422                	ld	s0,8(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret

00000000000002d8 <strlen>:

uint
strlen(const char *s)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2de:	00054783          	lbu	a5,0(a0)
 2e2:	cf91                	beqz	a5,2fe <strlen+0x26>
 2e4:	0505                	addi	a0,a0,1
 2e6:	87aa                	mv	a5,a0
 2e8:	4685                	li	a3,1
 2ea:	9e89                	subw	a3,a3,a0
 2ec:	00f6853b          	addw	a0,a3,a5
 2f0:	0785                	addi	a5,a5,1
 2f2:	fff7c703          	lbu	a4,-1(a5)
 2f6:	fb7d                	bnez	a4,2ec <strlen+0x14>
    ;
  return n;
}
 2f8:	6422                	ld	s0,8(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret
  for(n = 0; s[n]; n++)
 2fe:	4501                	li	a0,0
 300:	bfe5                	j	2f8 <strlen+0x20>

0000000000000302 <memset>:

void*
memset(void *dst, int c, uint n)
{
 302:	1141                	addi	sp,sp,-16
 304:	e422                	sd	s0,8(sp)
 306:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 308:	ce09                	beqz	a2,322 <memset+0x20>
 30a:	87aa                	mv	a5,a0
 30c:	fff6071b          	addiw	a4,a2,-1
 310:	1702                	slli	a4,a4,0x20
 312:	9301                	srli	a4,a4,0x20
 314:	0705                	addi	a4,a4,1
 316:	972a                	add	a4,a4,a0
    cdst[i] = c;
 318:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 31c:	0785                	addi	a5,a5,1
 31e:	fee79de3          	bne	a5,a4,318 <memset+0x16>
  }
  return dst;
}
 322:	6422                	ld	s0,8(sp)
 324:	0141                	addi	sp,sp,16
 326:	8082                	ret

0000000000000328 <strchr>:

char*
strchr(const char *s, char c)
{
 328:	1141                	addi	sp,sp,-16
 32a:	e422                	sd	s0,8(sp)
 32c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 32e:	00054783          	lbu	a5,0(a0)
 332:	cb99                	beqz	a5,348 <strchr+0x20>
    if(*s == c)
 334:	00f58763          	beq	a1,a5,342 <strchr+0x1a>
  for(; *s; s++)
 338:	0505                	addi	a0,a0,1
 33a:	00054783          	lbu	a5,0(a0)
 33e:	fbfd                	bnez	a5,334 <strchr+0xc>
      return (char*)s;
  return 0;
 340:	4501                	li	a0,0
}
 342:	6422                	ld	s0,8(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret
  return 0;
 348:	4501                	li	a0,0
 34a:	bfe5                	j	342 <strchr+0x1a>

000000000000034c <gets>:

char*
gets(char *buf, int max)
{
 34c:	711d                	addi	sp,sp,-96
 34e:	ec86                	sd	ra,88(sp)
 350:	e8a2                	sd	s0,80(sp)
 352:	e4a6                	sd	s1,72(sp)
 354:	e0ca                	sd	s2,64(sp)
 356:	fc4e                	sd	s3,56(sp)
 358:	f852                	sd	s4,48(sp)
 35a:	f456                	sd	s5,40(sp)
 35c:	f05a                	sd	s6,32(sp)
 35e:	ec5e                	sd	s7,24(sp)
 360:	1080                	addi	s0,sp,96
 362:	8baa                	mv	s7,a0
 364:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 366:	892a                	mv	s2,a0
 368:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 36a:	4aa9                	li	s5,10
 36c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 36e:	89a6                	mv	s3,s1
 370:	2485                	addiw	s1,s1,1
 372:	0344d863          	bge	s1,s4,3a2 <gets+0x56>
    cc = read(0, &c, 1);
 376:	4605                	li	a2,1
 378:	faf40593          	addi	a1,s0,-81
 37c:	4501                	li	a0,0
 37e:	00000097          	auipc	ra,0x0
 382:	1a0080e7          	jalr	416(ra) # 51e <read>
    if(cc < 1)
 386:	00a05e63          	blez	a0,3a2 <gets+0x56>
    buf[i++] = c;
 38a:	faf44783          	lbu	a5,-81(s0)
 38e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 392:	01578763          	beq	a5,s5,3a0 <gets+0x54>
 396:	0905                	addi	s2,s2,1
 398:	fd679be3          	bne	a5,s6,36e <gets+0x22>
  for(i=0; i+1 < max; ){
 39c:	89a6                	mv	s3,s1
 39e:	a011                	j	3a2 <gets+0x56>
 3a0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3a2:	99de                	add	s3,s3,s7
 3a4:	00098023          	sb	zero,0(s3)
  return buf;
}
 3a8:	855e                	mv	a0,s7
 3aa:	60e6                	ld	ra,88(sp)
 3ac:	6446                	ld	s0,80(sp)
 3ae:	64a6                	ld	s1,72(sp)
 3b0:	6906                	ld	s2,64(sp)
 3b2:	79e2                	ld	s3,56(sp)
 3b4:	7a42                	ld	s4,48(sp)
 3b6:	7aa2                	ld	s5,40(sp)
 3b8:	7b02                	ld	s6,32(sp)
 3ba:	6be2                	ld	s7,24(sp)
 3bc:	6125                	addi	sp,sp,96
 3be:	8082                	ret

00000000000003c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3c0:	1101                	addi	sp,sp,-32
 3c2:	ec06                	sd	ra,24(sp)
 3c4:	e822                	sd	s0,16(sp)
 3c6:	e426                	sd	s1,8(sp)
 3c8:	e04a                	sd	s2,0(sp)
 3ca:	1000                	addi	s0,sp,32
 3cc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ce:	4581                	li	a1,0
 3d0:	00000097          	auipc	ra,0x0
 3d4:	176080e7          	jalr	374(ra) # 546 <open>
  if(fd < 0)
 3d8:	02054563          	bltz	a0,402 <stat+0x42>
 3dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3de:	85ca                	mv	a1,s2
 3e0:	00000097          	auipc	ra,0x0
 3e4:	17e080e7          	jalr	382(ra) # 55e <fstat>
 3e8:	892a                	mv	s2,a0
  close(fd);
 3ea:	8526                	mv	a0,s1
 3ec:	00000097          	auipc	ra,0x0
 3f0:	142080e7          	jalr	322(ra) # 52e <close>
  return r;
}
 3f4:	854a                	mv	a0,s2
 3f6:	60e2                	ld	ra,24(sp)
 3f8:	6442                	ld	s0,16(sp)
 3fa:	64a2                	ld	s1,8(sp)
 3fc:	6902                	ld	s2,0(sp)
 3fe:	6105                	addi	sp,sp,32
 400:	8082                	ret
    return -1;
 402:	597d                	li	s2,-1
 404:	bfc5                	j	3f4 <stat+0x34>

0000000000000406 <atoi>:

int
atoi(const char *s)
{
 406:	1141                	addi	sp,sp,-16
 408:	e422                	sd	s0,8(sp)
 40a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 40c:	00054603          	lbu	a2,0(a0)
 410:	fd06079b          	addiw	a5,a2,-48
 414:	0ff7f793          	andi	a5,a5,255
 418:	4725                	li	a4,9
 41a:	02f76963          	bltu	a4,a5,44c <atoi+0x46>
 41e:	86aa                	mv	a3,a0
  n = 0;
 420:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 422:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 424:	0685                	addi	a3,a3,1
 426:	0025179b          	slliw	a5,a0,0x2
 42a:	9fa9                	addw	a5,a5,a0
 42c:	0017979b          	slliw	a5,a5,0x1
 430:	9fb1                	addw	a5,a5,a2
 432:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 436:	0006c603          	lbu	a2,0(a3)
 43a:	fd06071b          	addiw	a4,a2,-48
 43e:	0ff77713          	andi	a4,a4,255
 442:	fee5f1e3          	bgeu	a1,a4,424 <atoi+0x1e>
  return n;
}
 446:	6422                	ld	s0,8(sp)
 448:	0141                	addi	sp,sp,16
 44a:	8082                	ret
  n = 0;
 44c:	4501                	li	a0,0
 44e:	bfe5                	j	446 <atoi+0x40>

0000000000000450 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 450:	1141                	addi	sp,sp,-16
 452:	e422                	sd	s0,8(sp)
 454:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 456:	02b57663          	bgeu	a0,a1,482 <memmove+0x32>
    while(n-- > 0)
 45a:	02c05163          	blez	a2,47c <memmove+0x2c>
 45e:	fff6079b          	addiw	a5,a2,-1
 462:	1782                	slli	a5,a5,0x20
 464:	9381                	srli	a5,a5,0x20
 466:	0785                	addi	a5,a5,1
 468:	97aa                	add	a5,a5,a0
  dst = vdst;
 46a:	872a                	mv	a4,a0
      *dst++ = *src++;
 46c:	0585                	addi	a1,a1,1
 46e:	0705                	addi	a4,a4,1
 470:	fff5c683          	lbu	a3,-1(a1)
 474:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 478:	fee79ae3          	bne	a5,a4,46c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 47c:	6422                	ld	s0,8(sp)
 47e:	0141                	addi	sp,sp,16
 480:	8082                	ret
    dst += n;
 482:	00c50733          	add	a4,a0,a2
    src += n;
 486:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 488:	fec05ae3          	blez	a2,47c <memmove+0x2c>
 48c:	fff6079b          	addiw	a5,a2,-1
 490:	1782                	slli	a5,a5,0x20
 492:	9381                	srli	a5,a5,0x20
 494:	fff7c793          	not	a5,a5
 498:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 49a:	15fd                	addi	a1,a1,-1
 49c:	177d                	addi	a4,a4,-1
 49e:	0005c683          	lbu	a3,0(a1)
 4a2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4a6:	fee79ae3          	bne	a5,a4,49a <memmove+0x4a>
 4aa:	bfc9                	j	47c <memmove+0x2c>

00000000000004ac <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4ac:	1141                	addi	sp,sp,-16
 4ae:	e422                	sd	s0,8(sp)
 4b0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4b2:	ca05                	beqz	a2,4e2 <memcmp+0x36>
 4b4:	fff6069b          	addiw	a3,a2,-1
 4b8:	1682                	slli	a3,a3,0x20
 4ba:	9281                	srli	a3,a3,0x20
 4bc:	0685                	addi	a3,a3,1
 4be:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4c0:	00054783          	lbu	a5,0(a0)
 4c4:	0005c703          	lbu	a4,0(a1)
 4c8:	00e79863          	bne	a5,a4,4d8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4cc:	0505                	addi	a0,a0,1
    p2++;
 4ce:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4d0:	fed518e3          	bne	a0,a3,4c0 <memcmp+0x14>
  }
  return 0;
 4d4:	4501                	li	a0,0
 4d6:	a019                	j	4dc <memcmp+0x30>
      return *p1 - *p2;
 4d8:	40e7853b          	subw	a0,a5,a4
}
 4dc:	6422                	ld	s0,8(sp)
 4de:	0141                	addi	sp,sp,16
 4e0:	8082                	ret
  return 0;
 4e2:	4501                	li	a0,0
 4e4:	bfe5                	j	4dc <memcmp+0x30>

00000000000004e6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4e6:	1141                	addi	sp,sp,-16
 4e8:	e406                	sd	ra,8(sp)
 4ea:	e022                	sd	s0,0(sp)
 4ec:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4ee:	00000097          	auipc	ra,0x0
 4f2:	f62080e7          	jalr	-158(ra) # 450 <memmove>
}
 4f6:	60a2                	ld	ra,8(sp)
 4f8:	6402                	ld	s0,0(sp)
 4fa:	0141                	addi	sp,sp,16
 4fc:	8082                	ret

00000000000004fe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4fe:	4885                	li	a7,1
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <exit>:
.global exit
exit:
 li a7, SYS_exit
 506:	4889                	li	a7,2
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <wait>:
.global wait
wait:
 li a7, SYS_wait
 50e:	488d                	li	a7,3
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 516:	4891                	li	a7,4
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <read>:
.global read
read:
 li a7, SYS_read
 51e:	4895                	li	a7,5
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <write>:
.global write
write:
 li a7, SYS_write
 526:	48c1                	li	a7,16
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <close>:
.global close
close:
 li a7, SYS_close
 52e:	48d5                	li	a7,21
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <kill>:
.global kill
kill:
 li a7, SYS_kill
 536:	4899                	li	a7,6
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <exec>:
.global exec
exec:
 li a7, SYS_exec
 53e:	489d                	li	a7,7
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <open>:
.global open
open:
 li a7, SYS_open
 546:	48bd                	li	a7,15
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 54e:	48c5                	li	a7,17
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 556:	48c9                	li	a7,18
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 55e:	48a1                	li	a7,8
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <link>:
.global link
link:
 li a7, SYS_link
 566:	48cd                	li	a7,19
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 56e:	48d1                	li	a7,20
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 576:	48a5                	li	a7,9
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <dup>:
.global dup
dup:
 li a7, SYS_dup
 57e:	48a9                	li	a7,10
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 586:	48ad                	li	a7,11
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 58e:	48b1                	li	a7,12
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 596:	48b5                	li	a7,13
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 59e:	48b9                	li	a7,14
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <trace>:
.global trace
trace:
 li a7, SYS_trace
 5a6:	48d9                	li	a7,22
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 5ae:	48dd                	li	a7,23
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5b6:	1101                	addi	sp,sp,-32
 5b8:	ec06                	sd	ra,24(sp)
 5ba:	e822                	sd	s0,16(sp)
 5bc:	1000                	addi	s0,sp,32
 5be:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5c2:	4605                	li	a2,1
 5c4:	fef40593          	addi	a1,s0,-17
 5c8:	00000097          	auipc	ra,0x0
 5cc:	f5e080e7          	jalr	-162(ra) # 526 <write>
}
 5d0:	60e2                	ld	ra,24(sp)
 5d2:	6442                	ld	s0,16(sp)
 5d4:	6105                	addi	sp,sp,32
 5d6:	8082                	ret

00000000000005d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d8:	7139                	addi	sp,sp,-64
 5da:	fc06                	sd	ra,56(sp)
 5dc:	f822                	sd	s0,48(sp)
 5de:	f426                	sd	s1,40(sp)
 5e0:	f04a                	sd	s2,32(sp)
 5e2:	ec4e                	sd	s3,24(sp)
 5e4:	0080                	addi	s0,sp,64
 5e6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5e8:	c299                	beqz	a3,5ee <printint+0x16>
 5ea:	0805c863          	bltz	a1,67a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5ee:	2581                	sext.w	a1,a1
  neg = 0;
 5f0:	4881                	li	a7,0
 5f2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5f6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5f8:	2601                	sext.w	a2,a2
 5fa:	00000517          	auipc	a0,0x0
 5fe:	49650513          	addi	a0,a0,1174 # a90 <digits>
 602:	883a                	mv	a6,a4
 604:	2705                	addiw	a4,a4,1
 606:	02c5f7bb          	remuw	a5,a1,a2
 60a:	1782                	slli	a5,a5,0x20
 60c:	9381                	srli	a5,a5,0x20
 60e:	97aa                	add	a5,a5,a0
 610:	0007c783          	lbu	a5,0(a5)
 614:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 618:	0005879b          	sext.w	a5,a1
 61c:	02c5d5bb          	divuw	a1,a1,a2
 620:	0685                	addi	a3,a3,1
 622:	fec7f0e3          	bgeu	a5,a2,602 <printint+0x2a>
  if(neg)
 626:	00088b63          	beqz	a7,63c <printint+0x64>
    buf[i++] = '-';
 62a:	fd040793          	addi	a5,s0,-48
 62e:	973e                	add	a4,a4,a5
 630:	02d00793          	li	a5,45
 634:	fef70823          	sb	a5,-16(a4)
 638:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 63c:	02e05863          	blez	a4,66c <printint+0x94>
 640:	fc040793          	addi	a5,s0,-64
 644:	00e78933          	add	s2,a5,a4
 648:	fff78993          	addi	s3,a5,-1
 64c:	99ba                	add	s3,s3,a4
 64e:	377d                	addiw	a4,a4,-1
 650:	1702                	slli	a4,a4,0x20
 652:	9301                	srli	a4,a4,0x20
 654:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 658:	fff94583          	lbu	a1,-1(s2)
 65c:	8526                	mv	a0,s1
 65e:	00000097          	auipc	ra,0x0
 662:	f58080e7          	jalr	-168(ra) # 5b6 <putc>
  while(--i >= 0)
 666:	197d                	addi	s2,s2,-1
 668:	ff3918e3          	bne	s2,s3,658 <printint+0x80>
}
 66c:	70e2                	ld	ra,56(sp)
 66e:	7442                	ld	s0,48(sp)
 670:	74a2                	ld	s1,40(sp)
 672:	7902                	ld	s2,32(sp)
 674:	69e2                	ld	s3,24(sp)
 676:	6121                	addi	sp,sp,64
 678:	8082                	ret
    x = -xx;
 67a:	40b005bb          	negw	a1,a1
    neg = 1;
 67e:	4885                	li	a7,1
    x = -xx;
 680:	bf8d                	j	5f2 <printint+0x1a>

0000000000000682 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 682:	7119                	addi	sp,sp,-128
 684:	fc86                	sd	ra,120(sp)
 686:	f8a2                	sd	s0,112(sp)
 688:	f4a6                	sd	s1,104(sp)
 68a:	f0ca                	sd	s2,96(sp)
 68c:	ecce                	sd	s3,88(sp)
 68e:	e8d2                	sd	s4,80(sp)
 690:	e4d6                	sd	s5,72(sp)
 692:	e0da                	sd	s6,64(sp)
 694:	fc5e                	sd	s7,56(sp)
 696:	f862                	sd	s8,48(sp)
 698:	f466                	sd	s9,40(sp)
 69a:	f06a                	sd	s10,32(sp)
 69c:	ec6e                	sd	s11,24(sp)
 69e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6a0:	0005c903          	lbu	s2,0(a1)
 6a4:	18090f63          	beqz	s2,842 <vprintf+0x1c0>
 6a8:	8aaa                	mv	s5,a0
 6aa:	8b32                	mv	s6,a2
 6ac:	00158493          	addi	s1,a1,1
  state = 0;
 6b0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6b2:	02500a13          	li	s4,37
      if(c == 'd'){
 6b6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6ba:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6be:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6c2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c6:	00000b97          	auipc	s7,0x0
 6ca:	3cab8b93          	addi	s7,s7,970 # a90 <digits>
 6ce:	a839                	j	6ec <vprintf+0x6a>
        putc(fd, c);
 6d0:	85ca                	mv	a1,s2
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	ee2080e7          	jalr	-286(ra) # 5b6 <putc>
 6dc:	a019                	j	6e2 <vprintf+0x60>
    } else if(state == '%'){
 6de:	01498f63          	beq	s3,s4,6fc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6e2:	0485                	addi	s1,s1,1
 6e4:	fff4c903          	lbu	s2,-1(s1)
 6e8:	14090d63          	beqz	s2,842 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6ec:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6f0:	fe0997e3          	bnez	s3,6de <vprintf+0x5c>
      if(c == '%'){
 6f4:	fd479ee3          	bne	a5,s4,6d0 <vprintf+0x4e>
        state = '%';
 6f8:	89be                	mv	s3,a5
 6fa:	b7e5                	j	6e2 <vprintf+0x60>
      if(c == 'd'){
 6fc:	05878063          	beq	a5,s8,73c <vprintf+0xba>
      } else if(c == 'l') {
 700:	05978c63          	beq	a5,s9,758 <vprintf+0xd6>
      } else if(c == 'x') {
 704:	07a78863          	beq	a5,s10,774 <vprintf+0xf2>
      } else if(c == 'p') {
 708:	09b78463          	beq	a5,s11,790 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 70c:	07300713          	li	a4,115
 710:	0ce78663          	beq	a5,a4,7dc <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 714:	06300713          	li	a4,99
 718:	0ee78e63          	beq	a5,a4,814 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 71c:	11478863          	beq	a5,s4,82c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 720:	85d2                	mv	a1,s4
 722:	8556                	mv	a0,s5
 724:	00000097          	auipc	ra,0x0
 728:	e92080e7          	jalr	-366(ra) # 5b6 <putc>
        putc(fd, c);
 72c:	85ca                	mv	a1,s2
 72e:	8556                	mv	a0,s5
 730:	00000097          	auipc	ra,0x0
 734:	e86080e7          	jalr	-378(ra) # 5b6 <putc>
      }
      state = 0;
 738:	4981                	li	s3,0
 73a:	b765                	j	6e2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 73c:	008b0913          	addi	s2,s6,8
 740:	4685                	li	a3,1
 742:	4629                	li	a2,10
 744:	000b2583          	lw	a1,0(s6)
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	e8e080e7          	jalr	-370(ra) # 5d8 <printint>
 752:	8b4a                	mv	s6,s2
      state = 0;
 754:	4981                	li	s3,0
 756:	b771                	j	6e2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 758:	008b0913          	addi	s2,s6,8
 75c:	4681                	li	a3,0
 75e:	4629                	li	a2,10
 760:	000b2583          	lw	a1,0(s6)
 764:	8556                	mv	a0,s5
 766:	00000097          	auipc	ra,0x0
 76a:	e72080e7          	jalr	-398(ra) # 5d8 <printint>
 76e:	8b4a                	mv	s6,s2
      state = 0;
 770:	4981                	li	s3,0
 772:	bf85                	j	6e2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 774:	008b0913          	addi	s2,s6,8
 778:	4681                	li	a3,0
 77a:	4641                	li	a2,16
 77c:	000b2583          	lw	a1,0(s6)
 780:	8556                	mv	a0,s5
 782:	00000097          	auipc	ra,0x0
 786:	e56080e7          	jalr	-426(ra) # 5d8 <printint>
 78a:	8b4a                	mv	s6,s2
      state = 0;
 78c:	4981                	li	s3,0
 78e:	bf91                	j	6e2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 790:	008b0793          	addi	a5,s6,8
 794:	f8f43423          	sd	a5,-120(s0)
 798:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 79c:	03000593          	li	a1,48
 7a0:	8556                	mv	a0,s5
 7a2:	00000097          	auipc	ra,0x0
 7a6:	e14080e7          	jalr	-492(ra) # 5b6 <putc>
  putc(fd, 'x');
 7aa:	85ea                	mv	a1,s10
 7ac:	8556                	mv	a0,s5
 7ae:	00000097          	auipc	ra,0x0
 7b2:	e08080e7          	jalr	-504(ra) # 5b6 <putc>
 7b6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7b8:	03c9d793          	srli	a5,s3,0x3c
 7bc:	97de                	add	a5,a5,s7
 7be:	0007c583          	lbu	a1,0(a5)
 7c2:	8556                	mv	a0,s5
 7c4:	00000097          	auipc	ra,0x0
 7c8:	df2080e7          	jalr	-526(ra) # 5b6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7cc:	0992                	slli	s3,s3,0x4
 7ce:	397d                	addiw	s2,s2,-1
 7d0:	fe0914e3          	bnez	s2,7b8 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7d4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7d8:	4981                	li	s3,0
 7da:	b721                	j	6e2 <vprintf+0x60>
        s = va_arg(ap, char*);
 7dc:	008b0993          	addi	s3,s6,8
 7e0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7e4:	02090163          	beqz	s2,806 <vprintf+0x184>
        while(*s != 0){
 7e8:	00094583          	lbu	a1,0(s2)
 7ec:	c9a1                	beqz	a1,83c <vprintf+0x1ba>
          putc(fd, *s);
 7ee:	8556                	mv	a0,s5
 7f0:	00000097          	auipc	ra,0x0
 7f4:	dc6080e7          	jalr	-570(ra) # 5b6 <putc>
          s++;
 7f8:	0905                	addi	s2,s2,1
        while(*s != 0){
 7fa:	00094583          	lbu	a1,0(s2)
 7fe:	f9e5                	bnez	a1,7ee <vprintf+0x16c>
        s = va_arg(ap, char*);
 800:	8b4e                	mv	s6,s3
      state = 0;
 802:	4981                	li	s3,0
 804:	bdf9                	j	6e2 <vprintf+0x60>
          s = "(null)";
 806:	00000917          	auipc	s2,0x0
 80a:	28290913          	addi	s2,s2,642 # a88 <malloc+0x13c>
        while(*s != 0){
 80e:	02800593          	li	a1,40
 812:	bff1                	j	7ee <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 814:	008b0913          	addi	s2,s6,8
 818:	000b4583          	lbu	a1,0(s6)
 81c:	8556                	mv	a0,s5
 81e:	00000097          	auipc	ra,0x0
 822:	d98080e7          	jalr	-616(ra) # 5b6 <putc>
 826:	8b4a                	mv	s6,s2
      state = 0;
 828:	4981                	li	s3,0
 82a:	bd65                	j	6e2 <vprintf+0x60>
        putc(fd, c);
 82c:	85d2                	mv	a1,s4
 82e:	8556                	mv	a0,s5
 830:	00000097          	auipc	ra,0x0
 834:	d86080e7          	jalr	-634(ra) # 5b6 <putc>
      state = 0;
 838:	4981                	li	s3,0
 83a:	b565                	j	6e2 <vprintf+0x60>
        s = va_arg(ap, char*);
 83c:	8b4e                	mv	s6,s3
      state = 0;
 83e:	4981                	li	s3,0
 840:	b54d                	j	6e2 <vprintf+0x60>
    }
  }
}
 842:	70e6                	ld	ra,120(sp)
 844:	7446                	ld	s0,112(sp)
 846:	74a6                	ld	s1,104(sp)
 848:	7906                	ld	s2,96(sp)
 84a:	69e6                	ld	s3,88(sp)
 84c:	6a46                	ld	s4,80(sp)
 84e:	6aa6                	ld	s5,72(sp)
 850:	6b06                	ld	s6,64(sp)
 852:	7be2                	ld	s7,56(sp)
 854:	7c42                	ld	s8,48(sp)
 856:	7ca2                	ld	s9,40(sp)
 858:	7d02                	ld	s10,32(sp)
 85a:	6de2                	ld	s11,24(sp)
 85c:	6109                	addi	sp,sp,128
 85e:	8082                	ret

0000000000000860 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 860:	715d                	addi	sp,sp,-80
 862:	ec06                	sd	ra,24(sp)
 864:	e822                	sd	s0,16(sp)
 866:	1000                	addi	s0,sp,32
 868:	e010                	sd	a2,0(s0)
 86a:	e414                	sd	a3,8(s0)
 86c:	e818                	sd	a4,16(s0)
 86e:	ec1c                	sd	a5,24(s0)
 870:	03043023          	sd	a6,32(s0)
 874:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 878:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 87c:	8622                	mv	a2,s0
 87e:	00000097          	auipc	ra,0x0
 882:	e04080e7          	jalr	-508(ra) # 682 <vprintf>
}
 886:	60e2                	ld	ra,24(sp)
 888:	6442                	ld	s0,16(sp)
 88a:	6161                	addi	sp,sp,80
 88c:	8082                	ret

000000000000088e <printf>:

void
printf(const char *fmt, ...)
{
 88e:	711d                	addi	sp,sp,-96
 890:	ec06                	sd	ra,24(sp)
 892:	e822                	sd	s0,16(sp)
 894:	1000                	addi	s0,sp,32
 896:	e40c                	sd	a1,8(s0)
 898:	e810                	sd	a2,16(s0)
 89a:	ec14                	sd	a3,24(s0)
 89c:	f018                	sd	a4,32(s0)
 89e:	f41c                	sd	a5,40(s0)
 8a0:	03043823          	sd	a6,48(s0)
 8a4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8a8:	00840613          	addi	a2,s0,8
 8ac:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8b0:	85aa                	mv	a1,a0
 8b2:	4505                	li	a0,1
 8b4:	00000097          	auipc	ra,0x0
 8b8:	dce080e7          	jalr	-562(ra) # 682 <vprintf>
}
 8bc:	60e2                	ld	ra,24(sp)
 8be:	6442                	ld	s0,16(sp)
 8c0:	6125                	addi	sp,sp,96
 8c2:	8082                	ret

00000000000008c4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8c4:	1141                	addi	sp,sp,-16
 8c6:	e422                	sd	s0,8(sp)
 8c8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ca:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ce:	00000797          	auipc	a5,0x0
 8d2:	1da7b783          	ld	a5,474(a5) # aa8 <freep>
 8d6:	a805                	j	906 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8d8:	4618                	lw	a4,8(a2)
 8da:	9db9                	addw	a1,a1,a4
 8dc:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8e0:	6398                	ld	a4,0(a5)
 8e2:	6318                	ld	a4,0(a4)
 8e4:	fee53823          	sd	a4,-16(a0)
 8e8:	a091                	j	92c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8ea:	ff852703          	lw	a4,-8(a0)
 8ee:	9e39                	addw	a2,a2,a4
 8f0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8f2:	ff053703          	ld	a4,-16(a0)
 8f6:	e398                	sd	a4,0(a5)
 8f8:	a099                	j	93e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fa:	6398                	ld	a4,0(a5)
 8fc:	00e7e463          	bltu	a5,a4,904 <free+0x40>
 900:	00e6ea63          	bltu	a3,a4,914 <free+0x50>
{
 904:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 906:	fed7fae3          	bgeu	a5,a3,8fa <free+0x36>
 90a:	6398                	ld	a4,0(a5)
 90c:	00e6e463          	bltu	a3,a4,914 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 910:	fee7eae3          	bltu	a5,a4,904 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 914:	ff852583          	lw	a1,-8(a0)
 918:	6390                	ld	a2,0(a5)
 91a:	02059713          	slli	a4,a1,0x20
 91e:	9301                	srli	a4,a4,0x20
 920:	0712                	slli	a4,a4,0x4
 922:	9736                	add	a4,a4,a3
 924:	fae60ae3          	beq	a2,a4,8d8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 928:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 92c:	4790                	lw	a2,8(a5)
 92e:	02061713          	slli	a4,a2,0x20
 932:	9301                	srli	a4,a4,0x20
 934:	0712                	slli	a4,a4,0x4
 936:	973e                	add	a4,a4,a5
 938:	fae689e3          	beq	a3,a4,8ea <free+0x26>
  } else
    p->s.ptr = bp;
 93c:	e394                	sd	a3,0(a5)
  freep = p;
 93e:	00000717          	auipc	a4,0x0
 942:	16f73523          	sd	a5,362(a4) # aa8 <freep>
}
 946:	6422                	ld	s0,8(sp)
 948:	0141                	addi	sp,sp,16
 94a:	8082                	ret

000000000000094c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 94c:	7139                	addi	sp,sp,-64
 94e:	fc06                	sd	ra,56(sp)
 950:	f822                	sd	s0,48(sp)
 952:	f426                	sd	s1,40(sp)
 954:	f04a                	sd	s2,32(sp)
 956:	ec4e                	sd	s3,24(sp)
 958:	e852                	sd	s4,16(sp)
 95a:	e456                	sd	s5,8(sp)
 95c:	e05a                	sd	s6,0(sp)
 95e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 960:	02051493          	slli	s1,a0,0x20
 964:	9081                	srli	s1,s1,0x20
 966:	04bd                	addi	s1,s1,15
 968:	8091                	srli	s1,s1,0x4
 96a:	0014899b          	addiw	s3,s1,1
 96e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 970:	00000517          	auipc	a0,0x0
 974:	13853503          	ld	a0,312(a0) # aa8 <freep>
 978:	c515                	beqz	a0,9a4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 97c:	4798                	lw	a4,8(a5)
 97e:	02977f63          	bgeu	a4,s1,9bc <malloc+0x70>
 982:	8a4e                	mv	s4,s3
 984:	0009871b          	sext.w	a4,s3
 988:	6685                	lui	a3,0x1
 98a:	00d77363          	bgeu	a4,a3,990 <malloc+0x44>
 98e:	6a05                	lui	s4,0x1
 990:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 994:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 998:	00000917          	auipc	s2,0x0
 99c:	11090913          	addi	s2,s2,272 # aa8 <freep>
  if(p == (char*)-1)
 9a0:	5afd                	li	s5,-1
 9a2:	a88d                	j	a14 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 9a4:	00000797          	auipc	a5,0x0
 9a8:	32c78793          	addi	a5,a5,812 # cd0 <base>
 9ac:	00000717          	auipc	a4,0x0
 9b0:	0ef73e23          	sd	a5,252(a4) # aa8 <freep>
 9b4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9b6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ba:	b7e1                	j	982 <malloc+0x36>
      if(p->s.size == nunits)
 9bc:	02e48b63          	beq	s1,a4,9f2 <malloc+0xa6>
        p->s.size -= nunits;
 9c0:	4137073b          	subw	a4,a4,s3
 9c4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9c6:	1702                	slli	a4,a4,0x20
 9c8:	9301                	srli	a4,a4,0x20
 9ca:	0712                	slli	a4,a4,0x4
 9cc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ce:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9d2:	00000717          	auipc	a4,0x0
 9d6:	0ca73b23          	sd	a0,214(a4) # aa8 <freep>
      return (void*)(p + 1);
 9da:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9de:	70e2                	ld	ra,56(sp)
 9e0:	7442                	ld	s0,48(sp)
 9e2:	74a2                	ld	s1,40(sp)
 9e4:	7902                	ld	s2,32(sp)
 9e6:	69e2                	ld	s3,24(sp)
 9e8:	6a42                	ld	s4,16(sp)
 9ea:	6aa2                	ld	s5,8(sp)
 9ec:	6b02                	ld	s6,0(sp)
 9ee:	6121                	addi	sp,sp,64
 9f0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9f2:	6398                	ld	a4,0(a5)
 9f4:	e118                	sd	a4,0(a0)
 9f6:	bff1                	j	9d2 <malloc+0x86>
  hp->s.size = nu;
 9f8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9fc:	0541                	addi	a0,a0,16
 9fe:	00000097          	auipc	ra,0x0
 a02:	ec6080e7          	jalr	-314(ra) # 8c4 <free>
  return freep;
 a06:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a0a:	d971                	beqz	a0,9de <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a0e:	4798                	lw	a4,8(a5)
 a10:	fa9776e3          	bgeu	a4,s1,9bc <malloc+0x70>
    if(p == freep)
 a14:	00093703          	ld	a4,0(s2)
 a18:	853e                	mv	a0,a5
 a1a:	fef719e3          	bne	a4,a5,a0c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a1e:	8552                	mv	a0,s4
 a20:	00000097          	auipc	ra,0x0
 a24:	b6e080e7          	jalr	-1170(ra) # 58e <sbrk>
  if(p == (char*)-1)
 a28:	fd5518e3          	bne	a0,s5,9f8 <malloc+0xac>
        return 0;
 a2c:	4501                	li	a0,0
 a2e:	bf45                	j	9de <malloc+0x92>
