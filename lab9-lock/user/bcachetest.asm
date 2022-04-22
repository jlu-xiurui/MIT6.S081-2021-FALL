
user/_bcachetest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <createfile>:
  exit(0);
}

void
createfile(char *file, int nblock)
{
   0:	bd010113          	addi	sp,sp,-1072
   4:	42113423          	sd	ra,1064(sp)
   8:	42813023          	sd	s0,1056(sp)
   c:	40913c23          	sd	s1,1048(sp)
  10:	41213823          	sd	s2,1040(sp)
  14:	41313423          	sd	s3,1032(sp)
  18:	41413023          	sd	s4,1024(sp)
  1c:	43010413          	addi	s0,sp,1072
  20:	8a2a                	mv	s4,a0
  22:	89ae                	mv	s3,a1
  int fd;
  char buf[BSIZE];
  int i;
  
  fd = open(file, O_CREATE | O_RDWR);
  24:	20200593          	li	a1,514
  28:	00000097          	auipc	ra,0x0
  2c:	7ec080e7          	jalr	2028(ra) # 814 <open>
  if(fd < 0){
  30:	04054a63          	bltz	a0,84 <createfile+0x84>
  34:	892a                	mv	s2,a0
    printf("createfile %s failed\n", file);
    exit(-1);
  }
  for(i = 0; i < nblock; i++) {
  36:	4481                	li	s1,0
  38:	03305263          	blez	s3,5c <createfile+0x5c>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)) {
  3c:	40000613          	li	a2,1024
  40:	bd040593          	addi	a1,s0,-1072
  44:	854a                	mv	a0,s2
  46:	00000097          	auipc	ra,0x0
  4a:	7ae080e7          	jalr	1966(ra) # 7f4 <write>
  4e:	40000793          	li	a5,1024
  52:	04f51763          	bne	a0,a5,a0 <createfile+0xa0>
  for(i = 0; i < nblock; i++) {
  56:	2485                	addiw	s1,s1,1
  58:	fe9992e3          	bne	s3,s1,3c <createfile+0x3c>
      printf("write %s failed\n", file);
      exit(-1);
    }
  }
  close(fd);
  5c:	854a                	mv	a0,s2
  5e:	00000097          	auipc	ra,0x0
  62:	79e080e7          	jalr	1950(ra) # 7fc <close>
}
  66:	42813083          	ld	ra,1064(sp)
  6a:	42013403          	ld	s0,1056(sp)
  6e:	41813483          	ld	s1,1048(sp)
  72:	41013903          	ld	s2,1040(sp)
  76:	40813983          	ld	s3,1032(sp)
  7a:	40013a03          	ld	s4,1024(sp)
  7e:	43010113          	addi	sp,sp,1072
  82:	8082                	ret
    printf("createfile %s failed\n", file);
  84:	85d2                	mv	a1,s4
  86:	00001517          	auipc	a0,0x1
  8a:	cf250513          	addi	a0,a0,-782 # d78 <statistics+0x8a>
  8e:	00001097          	auipc	ra,0x1
  92:	abe080e7          	jalr	-1346(ra) # b4c <printf>
    exit(-1);
  96:	557d                	li	a0,-1
  98:	00000097          	auipc	ra,0x0
  9c:	73c080e7          	jalr	1852(ra) # 7d4 <exit>
      printf("write %s failed\n", file);
  a0:	85d2                	mv	a1,s4
  a2:	00001517          	auipc	a0,0x1
  a6:	cee50513          	addi	a0,a0,-786 # d90 <statistics+0xa2>
  aa:	00001097          	auipc	ra,0x1
  ae:	aa2080e7          	jalr	-1374(ra) # b4c <printf>
      exit(-1);
  b2:	557d                	li	a0,-1
  b4:	00000097          	auipc	ra,0x0
  b8:	720080e7          	jalr	1824(ra) # 7d4 <exit>

00000000000000bc <readfile>:

void
readfile(char *file, int nbytes, int inc)
{
  bc:	bc010113          	addi	sp,sp,-1088
  c0:	42113c23          	sd	ra,1080(sp)
  c4:	42813823          	sd	s0,1072(sp)
  c8:	42913423          	sd	s1,1064(sp)
  cc:	43213023          	sd	s2,1056(sp)
  d0:	41313c23          	sd	s3,1048(sp)
  d4:	41413823          	sd	s4,1040(sp)
  d8:	41513423          	sd	s5,1032(sp)
  dc:	44010413          	addi	s0,sp,1088
  char buf[BSIZE];
  int fd;
  int i;

  if(inc > BSIZE) {
  e0:	40000793          	li	a5,1024
  e4:	06c7c463          	blt	a5,a2,14c <readfile+0x90>
  e8:	8aaa                	mv	s5,a0
  ea:	8a2e                	mv	s4,a1
  ec:	84b2                	mv	s1,a2
    printf("readfile: inc too large\n");
    exit(-1);
  }
  if ((fd = open(file, O_RDONLY)) < 0) {
  ee:	4581                	li	a1,0
  f0:	00000097          	auipc	ra,0x0
  f4:	724080e7          	jalr	1828(ra) # 814 <open>
  f8:	89aa                	mv	s3,a0
  fa:	06054663          	bltz	a0,166 <readfile+0xaa>
    printf("readfile open %s failed\n", file);
    exit(-1);
  }
  for (i = 0; i < nbytes; i += inc) {
  fe:	4901                	li	s2,0
 100:	03405063          	blez	s4,120 <readfile+0x64>
    if(read(fd, buf, inc) != inc) {
 104:	8626                	mv	a2,s1
 106:	bc040593          	addi	a1,s0,-1088
 10a:	854e                	mv	a0,s3
 10c:	00000097          	auipc	ra,0x0
 110:	6e0080e7          	jalr	1760(ra) # 7ec <read>
 114:	06951763          	bne	a0,s1,182 <readfile+0xc6>
  for (i = 0; i < nbytes; i += inc) {
 118:	0124893b          	addw	s2,s1,s2
 11c:	ff4944e3          	blt	s2,s4,104 <readfile+0x48>
      printf("read %s failed for block %d (%d)\n", file, i, nbytes);
      exit(-1);
    }
  }
  close(fd);
 120:	854e                	mv	a0,s3
 122:	00000097          	auipc	ra,0x0
 126:	6da080e7          	jalr	1754(ra) # 7fc <close>
}
 12a:	43813083          	ld	ra,1080(sp)
 12e:	43013403          	ld	s0,1072(sp)
 132:	42813483          	ld	s1,1064(sp)
 136:	42013903          	ld	s2,1056(sp)
 13a:	41813983          	ld	s3,1048(sp)
 13e:	41013a03          	ld	s4,1040(sp)
 142:	40813a83          	ld	s5,1032(sp)
 146:	44010113          	addi	sp,sp,1088
 14a:	8082                	ret
    printf("readfile: inc too large\n");
 14c:	00001517          	auipc	a0,0x1
 150:	c5c50513          	addi	a0,a0,-932 # da8 <statistics+0xba>
 154:	00001097          	auipc	ra,0x1
 158:	9f8080e7          	jalr	-1544(ra) # b4c <printf>
    exit(-1);
 15c:	557d                	li	a0,-1
 15e:	00000097          	auipc	ra,0x0
 162:	676080e7          	jalr	1654(ra) # 7d4 <exit>
    printf("readfile open %s failed\n", file);
 166:	85d6                	mv	a1,s5
 168:	00001517          	auipc	a0,0x1
 16c:	c6050513          	addi	a0,a0,-928 # dc8 <statistics+0xda>
 170:	00001097          	auipc	ra,0x1
 174:	9dc080e7          	jalr	-1572(ra) # b4c <printf>
    exit(-1);
 178:	557d                	li	a0,-1
 17a:	00000097          	auipc	ra,0x0
 17e:	65a080e7          	jalr	1626(ra) # 7d4 <exit>
      printf("read %s failed for block %d (%d)\n", file, i, nbytes);
 182:	86d2                	mv	a3,s4
 184:	864a                	mv	a2,s2
 186:	85d6                	mv	a1,s5
 188:	00001517          	auipc	a0,0x1
 18c:	c6050513          	addi	a0,a0,-928 # de8 <statistics+0xfa>
 190:	00001097          	auipc	ra,0x1
 194:	9bc080e7          	jalr	-1604(ra) # b4c <printf>
      exit(-1);
 198:	557d                	li	a0,-1
 19a:	00000097          	auipc	ra,0x0
 19e:	63a080e7          	jalr	1594(ra) # 7d4 <exit>

00000000000001a2 <ntas>:

int ntas(int print)
{
 1a2:	1101                	addi	sp,sp,-32
 1a4:	ec06                	sd	ra,24(sp)
 1a6:	e822                	sd	s0,16(sp)
 1a8:	e426                	sd	s1,8(sp)
 1aa:	e04a                	sd	s2,0(sp)
 1ac:	1000                	addi	s0,sp,32
 1ae:	892a                	mv	s2,a0
  int n;
  char *c;

  if (statistics(buf, SZ) <= 0) {
 1b0:	6585                	lui	a1,0x1
 1b2:	00001517          	auipc	a0,0x1
 1b6:	d4e50513          	addi	a0,a0,-690 # f00 <buf>
 1ba:	00001097          	auipc	ra,0x1
 1be:	b34080e7          	jalr	-1228(ra) # cee <statistics>
 1c2:	02a05b63          	blez	a0,1f8 <ntas+0x56>
    fprintf(2, "ntas: no stats\n");
  }
  c = strchr(buf, '=');
 1c6:	03d00593          	li	a1,61
 1ca:	00001517          	auipc	a0,0x1
 1ce:	d3650513          	addi	a0,a0,-714 # f00 <buf>
 1d2:	00000097          	auipc	ra,0x0
 1d6:	424080e7          	jalr	1060(ra) # 5f6 <strchr>
  n = atoi(c+2);
 1da:	0509                	addi	a0,a0,2
 1dc:	00000097          	auipc	ra,0x0
 1e0:	4f8080e7          	jalr	1272(ra) # 6d4 <atoi>
 1e4:	84aa                	mv	s1,a0
  if(print)
 1e6:	02091363          	bnez	s2,20c <ntas+0x6a>
    printf("%s", buf);
  return n;
}
 1ea:	8526                	mv	a0,s1
 1ec:	60e2                	ld	ra,24(sp)
 1ee:	6442                	ld	s0,16(sp)
 1f0:	64a2                	ld	s1,8(sp)
 1f2:	6902                	ld	s2,0(sp)
 1f4:	6105                	addi	sp,sp,32
 1f6:	8082                	ret
    fprintf(2, "ntas: no stats\n");
 1f8:	00001597          	auipc	a1,0x1
 1fc:	c1858593          	addi	a1,a1,-1000 # e10 <statistics+0x122>
 200:	4509                	li	a0,2
 202:	00001097          	auipc	ra,0x1
 206:	91c080e7          	jalr	-1764(ra) # b1e <fprintf>
 20a:	bf75                	j	1c6 <ntas+0x24>
    printf("%s", buf);
 20c:	00001597          	auipc	a1,0x1
 210:	cf458593          	addi	a1,a1,-780 # f00 <buf>
 214:	00001517          	auipc	a0,0x1
 218:	c0c50513          	addi	a0,a0,-1012 # e20 <statistics+0x132>
 21c:	00001097          	auipc	ra,0x1
 220:	930080e7          	jalr	-1744(ra) # b4c <printf>
 224:	b7d9                	j	1ea <ntas+0x48>

0000000000000226 <test0>:

void
test0()
{
 226:	7139                	addi	sp,sp,-64
 228:	fc06                	sd	ra,56(sp)
 22a:	f822                	sd	s0,48(sp)
 22c:	f426                	sd	s1,40(sp)
 22e:	f04a                	sd	s2,32(sp)
 230:	ec4e                	sd	s3,24(sp)
 232:	0080                	addi	s0,sp,64
  char file[2];
  char dir[2];
  enum { N = 10, NCHILD = 3 };
  int m, n;

  dir[0] = '0';
 234:	03000793          	li	a5,48
 238:	fcf40023          	sb	a5,-64(s0)
  dir[1] = '\0';
 23c:	fc0400a3          	sb	zero,-63(s0)
  file[0] = 'F';
 240:	04600793          	li	a5,70
 244:	fcf40423          	sb	a5,-56(s0)
  file[1] = '\0';
 248:	fc0404a3          	sb	zero,-55(s0)

  printf("start test0\n");
 24c:	00001517          	auipc	a0,0x1
 250:	bdc50513          	addi	a0,a0,-1060 # e28 <statistics+0x13a>
 254:	00001097          	auipc	ra,0x1
 258:	8f8080e7          	jalr	-1800(ra) # b4c <printf>
 25c:	03000493          	li	s1,48
      printf("chdir failed\n");
      exit(1);
    }
    unlink(file);
    createfile(file, N);
    if (chdir("..") < 0) {
 260:	00001997          	auipc	s3,0x1
 264:	be898993          	addi	s3,s3,-1048 # e48 <statistics+0x15a>
  for(int i = 0; i < NCHILD; i++){
 268:	03300913          	li	s2,51
    dir[0] = '0' + i;
 26c:	fc940023          	sb	s1,-64(s0)
    mkdir(dir);
 270:	fc040513          	addi	a0,s0,-64
 274:	00000097          	auipc	ra,0x0
 278:	5c8080e7          	jalr	1480(ra) # 83c <mkdir>
    if (chdir(dir) < 0) {
 27c:	fc040513          	addi	a0,s0,-64
 280:	00000097          	auipc	ra,0x0
 284:	5c4080e7          	jalr	1476(ra) # 844 <chdir>
 288:	0c054463          	bltz	a0,350 <test0+0x12a>
    unlink(file);
 28c:	fc840513          	addi	a0,s0,-56
 290:	00000097          	auipc	ra,0x0
 294:	594080e7          	jalr	1428(ra) # 824 <unlink>
    createfile(file, N);
 298:	45a9                	li	a1,10
 29a:	fc840513          	addi	a0,s0,-56
 29e:	00000097          	auipc	ra,0x0
 2a2:	d62080e7          	jalr	-670(ra) # 0 <createfile>
    if (chdir("..") < 0) {
 2a6:	854e                	mv	a0,s3
 2a8:	00000097          	auipc	ra,0x0
 2ac:	59c080e7          	jalr	1436(ra) # 844 <chdir>
 2b0:	0a054d63          	bltz	a0,36a <test0+0x144>
  for(int i = 0; i < NCHILD; i++){
 2b4:	2485                	addiw	s1,s1,1
 2b6:	0ff4f493          	andi	s1,s1,255
 2ba:	fb2499e3          	bne	s1,s2,26c <test0+0x46>
      printf("chdir failed\n");
      exit(1);
    }
  }
  m = ntas(0);
 2be:	4501                	li	a0,0
 2c0:	00000097          	auipc	ra,0x0
 2c4:	ee2080e7          	jalr	-286(ra) # 1a2 <ntas>
 2c8:	892a                	mv	s2,a0
 2ca:	03000493          	li	s1,48
  for(int i = 0; i < NCHILD; i++){
 2ce:	03300993          	li	s3,51
    dir[0] = '0' + i;
 2d2:	fc940023          	sb	s1,-64(s0)
    int pid = fork();
 2d6:	00000097          	auipc	ra,0x0
 2da:	4f6080e7          	jalr	1270(ra) # 7cc <fork>
    if(pid < 0){
 2de:	0a054363          	bltz	a0,384 <test0+0x15e>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 2e2:	cd55                	beqz	a0,39e <test0+0x178>
  for(int i = 0; i < NCHILD; i++){
 2e4:	2485                	addiw	s1,s1,1
 2e6:	0ff4f493          	andi	s1,s1,255
 2ea:	ff3494e3          	bne	s1,s3,2d2 <test0+0xac>
      exit(0);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
 2ee:	4501                	li	a0,0
 2f0:	00000097          	auipc	ra,0x0
 2f4:	4ec080e7          	jalr	1260(ra) # 7dc <wait>
 2f8:	4501                	li	a0,0
 2fa:	00000097          	auipc	ra,0x0
 2fe:	4e2080e7          	jalr	1250(ra) # 7dc <wait>
 302:	4501                	li	a0,0
 304:	00000097          	auipc	ra,0x0
 308:	4d8080e7          	jalr	1240(ra) # 7dc <wait>
  }
  printf("test0 results:\n");
 30c:	00001517          	auipc	a0,0x1
 310:	b5450513          	addi	a0,a0,-1196 # e60 <statistics+0x172>
 314:	00001097          	auipc	ra,0x1
 318:	838080e7          	jalr	-1992(ra) # b4c <printf>
  n = ntas(1);
 31c:	4505                	li	a0,1
 31e:	00000097          	auipc	ra,0x0
 322:	e84080e7          	jalr	-380(ra) # 1a2 <ntas>
  if (n-m < 500)
 326:	4125053b          	subw	a0,a0,s2
 32a:	1f300793          	li	a5,499
 32e:	0aa7cc63          	blt	a5,a0,3e6 <test0+0x1c0>
    printf("test0: OK\n");
 332:	00001517          	auipc	a0,0x1
 336:	b3e50513          	addi	a0,a0,-1218 # e70 <statistics+0x182>
 33a:	00001097          	auipc	ra,0x1
 33e:	812080e7          	jalr	-2030(ra) # b4c <printf>
  else
    printf("test0: FAIL\n");
}
 342:	70e2                	ld	ra,56(sp)
 344:	7442                	ld	s0,48(sp)
 346:	74a2                	ld	s1,40(sp)
 348:	7902                	ld	s2,32(sp)
 34a:	69e2                	ld	s3,24(sp)
 34c:	6121                	addi	sp,sp,64
 34e:	8082                	ret
      printf("chdir failed\n");
 350:	00001517          	auipc	a0,0x1
 354:	ae850513          	addi	a0,a0,-1304 # e38 <statistics+0x14a>
 358:	00000097          	auipc	ra,0x0
 35c:	7f4080e7          	jalr	2036(ra) # b4c <printf>
      exit(1);
 360:	4505                	li	a0,1
 362:	00000097          	auipc	ra,0x0
 366:	472080e7          	jalr	1138(ra) # 7d4 <exit>
      printf("chdir failed\n");
 36a:	00001517          	auipc	a0,0x1
 36e:	ace50513          	addi	a0,a0,-1330 # e38 <statistics+0x14a>
 372:	00000097          	auipc	ra,0x0
 376:	7da080e7          	jalr	2010(ra) # b4c <printf>
      exit(1);
 37a:	4505                	li	a0,1
 37c:	00000097          	auipc	ra,0x0
 380:	458080e7          	jalr	1112(ra) # 7d4 <exit>
      printf("fork failed");
 384:	00001517          	auipc	a0,0x1
 388:	acc50513          	addi	a0,a0,-1332 # e50 <statistics+0x162>
 38c:	00000097          	auipc	ra,0x0
 390:	7c0080e7          	jalr	1984(ra) # b4c <printf>
      exit(-1);
 394:	557d                	li	a0,-1
 396:	00000097          	auipc	ra,0x0
 39a:	43e080e7          	jalr	1086(ra) # 7d4 <exit>
      if (chdir(dir) < 0) {
 39e:	fc040513          	addi	a0,s0,-64
 3a2:	00000097          	auipc	ra,0x0
 3a6:	4a2080e7          	jalr	1186(ra) # 844 <chdir>
 3aa:	02054163          	bltz	a0,3cc <test0+0x1a6>
      readfile(file, N*BSIZE, 1);
 3ae:	4605                	li	a2,1
 3b0:	658d                	lui	a1,0x3
 3b2:	80058593          	addi	a1,a1,-2048 # 2800 <__BSS_END__+0x8f0>
 3b6:	fc840513          	addi	a0,s0,-56
 3ba:	00000097          	auipc	ra,0x0
 3be:	d02080e7          	jalr	-766(ra) # bc <readfile>
      exit(0);
 3c2:	4501                	li	a0,0
 3c4:	00000097          	auipc	ra,0x0
 3c8:	410080e7          	jalr	1040(ra) # 7d4 <exit>
        printf("chdir failed\n");
 3cc:	00001517          	auipc	a0,0x1
 3d0:	a6c50513          	addi	a0,a0,-1428 # e38 <statistics+0x14a>
 3d4:	00000097          	auipc	ra,0x0
 3d8:	778080e7          	jalr	1912(ra) # b4c <printf>
        exit(1);
 3dc:	4505                	li	a0,1
 3de:	00000097          	auipc	ra,0x0
 3e2:	3f6080e7          	jalr	1014(ra) # 7d4 <exit>
    printf("test0: FAIL\n");
 3e6:	00001517          	auipc	a0,0x1
 3ea:	a9a50513          	addi	a0,a0,-1382 # e80 <statistics+0x192>
 3ee:	00000097          	auipc	ra,0x0
 3f2:	75e080e7          	jalr	1886(ra) # b4c <printf>
}
 3f6:	b7b1                	j	342 <test0+0x11c>

00000000000003f8 <test1>:

void test1()
{
 3f8:	7179                	addi	sp,sp,-48
 3fa:	f406                	sd	ra,40(sp)
 3fc:	f022                	sd	s0,32(sp)
 3fe:	ec26                	sd	s1,24(sp)
 400:	e84a                	sd	s2,16(sp)
 402:	1800                	addi	s0,sp,48
  char file[3];
  enum { N = 100, BIG=100, NCHILD=2 };
  
  printf("start test1\n");
 404:	00001517          	auipc	a0,0x1
 408:	a8c50513          	addi	a0,a0,-1396 # e90 <statistics+0x1a2>
 40c:	00000097          	auipc	ra,0x0
 410:	740080e7          	jalr	1856(ra) # b4c <printf>
  file[0] = 'B';
 414:	04200793          	li	a5,66
 418:	fcf40c23          	sb	a5,-40(s0)
  file[2] = '\0';
 41c:	fc040d23          	sb	zero,-38(s0)
 420:	4485                	li	s1,1
  for(int i = 0; i < NCHILD; i++){
    file[1] = '0' + i;
    unlink(file);
    if (i == 0) {
 422:	4905                	li	s2,1
 424:	a811                	j	438 <test1+0x40>
      createfile(file, BIG);
 426:	06400593          	li	a1,100
 42a:	fd840513          	addi	a0,s0,-40
 42e:	00000097          	auipc	ra,0x0
 432:	bd2080e7          	jalr	-1070(ra) # 0 <createfile>
  for(int i = 0; i < NCHILD; i++){
 436:	2485                	addiw	s1,s1,1
    file[1] = '0' + i;
 438:	02f4879b          	addiw	a5,s1,47
 43c:	fcf40ca3          	sb	a5,-39(s0)
    unlink(file);
 440:	fd840513          	addi	a0,s0,-40
 444:	00000097          	auipc	ra,0x0
 448:	3e0080e7          	jalr	992(ra) # 824 <unlink>
    if (i == 0) {
 44c:	fd248de3          	beq	s1,s2,426 <test1+0x2e>
    } else {
      createfile(file, 1);
 450:	85ca                	mv	a1,s2
 452:	fd840513          	addi	a0,s0,-40
 456:	00000097          	auipc	ra,0x0
 45a:	baa080e7          	jalr	-1110(ra) # 0 <createfile>
  for(int i = 0; i < NCHILD; i++){
 45e:	0004879b          	sext.w	a5,s1
 462:	fcf95ae3          	bge	s2,a5,436 <test1+0x3e>
    }
  }
  for(int i = 0; i < NCHILD; i++){
    file[1] = '0' + i;
 466:	03000793          	li	a5,48
 46a:	fcf40ca3          	sb	a5,-39(s0)
    int pid = fork();
 46e:	00000097          	auipc	ra,0x0
 472:	35e080e7          	jalr	862(ra) # 7cc <fork>
    if(pid < 0){
 476:	04054663          	bltz	a0,4c2 <test1+0xca>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
 47a:	c12d                	beqz	a0,4dc <test1+0xe4>
    file[1] = '0' + i;
 47c:	03100793          	li	a5,49
 480:	fcf40ca3          	sb	a5,-39(s0)
    int pid = fork();
 484:	00000097          	auipc	ra,0x0
 488:	348080e7          	jalr	840(ra) # 7cc <fork>
    if(pid < 0){
 48c:	02054b63          	bltz	a0,4c2 <test1+0xca>
    if(pid == 0){
 490:	cd35                	beqz	a0,50c <test1+0x114>
      exit(0);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
 492:	4501                	li	a0,0
 494:	00000097          	auipc	ra,0x0
 498:	348080e7          	jalr	840(ra) # 7dc <wait>
 49c:	4501                	li	a0,0
 49e:	00000097          	auipc	ra,0x0
 4a2:	33e080e7          	jalr	830(ra) # 7dc <wait>
  }
  printf("test1 OK\n");
 4a6:	00001517          	auipc	a0,0x1
 4aa:	9fa50513          	addi	a0,a0,-1542 # ea0 <statistics+0x1b2>
 4ae:	00000097          	auipc	ra,0x0
 4b2:	69e080e7          	jalr	1694(ra) # b4c <printf>
}
 4b6:	70a2                	ld	ra,40(sp)
 4b8:	7402                	ld	s0,32(sp)
 4ba:	64e2                	ld	s1,24(sp)
 4bc:	6942                	ld	s2,16(sp)
 4be:	6145                	addi	sp,sp,48
 4c0:	8082                	ret
      printf("fork failed");
 4c2:	00001517          	auipc	a0,0x1
 4c6:	98e50513          	addi	a0,a0,-1650 # e50 <statistics+0x162>
 4ca:	00000097          	auipc	ra,0x0
 4ce:	682080e7          	jalr	1666(ra) # b4c <printf>
      exit(-1);
 4d2:	557d                	li	a0,-1
 4d4:	00000097          	auipc	ra,0x0
 4d8:	300080e7          	jalr	768(ra) # 7d4 <exit>
    if(pid == 0){
 4dc:	06400493          	li	s1,100
          readfile(file, BIG*BSIZE, BSIZE);
 4e0:	40000613          	li	a2,1024
 4e4:	65e5                	lui	a1,0x19
 4e6:	fd840513          	addi	a0,s0,-40
 4ea:	00000097          	auipc	ra,0x0
 4ee:	bd2080e7          	jalr	-1070(ra) # bc <readfile>
        for (i = 0; i < N; i++) {
 4f2:	34fd                	addiw	s1,s1,-1
 4f4:	f4f5                	bnez	s1,4e0 <test1+0xe8>
        unlink(file);
 4f6:	fd840513          	addi	a0,s0,-40
 4fa:	00000097          	auipc	ra,0x0
 4fe:	32a080e7          	jalr	810(ra) # 824 <unlink>
        exit(0);
 502:	4501                	li	a0,0
 504:	00000097          	auipc	ra,0x0
 508:	2d0080e7          	jalr	720(ra) # 7d4 <exit>
 50c:	06400493          	li	s1,100
          readfile(file, 1, BSIZE);
 510:	40000613          	li	a2,1024
 514:	4585                	li	a1,1
 516:	fd840513          	addi	a0,s0,-40
 51a:	00000097          	auipc	ra,0x0
 51e:	ba2080e7          	jalr	-1118(ra) # bc <readfile>
        for (i = 0; i < N; i++) {
 522:	34fd                	addiw	s1,s1,-1
 524:	f4f5                	bnez	s1,510 <test1+0x118>
        unlink(file);
 526:	fd840513          	addi	a0,s0,-40
 52a:	00000097          	auipc	ra,0x0
 52e:	2fa080e7          	jalr	762(ra) # 824 <unlink>
      exit(0);
 532:	4501                	li	a0,0
 534:	00000097          	auipc	ra,0x0
 538:	2a0080e7          	jalr	672(ra) # 7d4 <exit>

000000000000053c <main>:
{
 53c:	1141                	addi	sp,sp,-16
 53e:	e406                	sd	ra,8(sp)
 540:	e022                	sd	s0,0(sp)
 542:	0800                	addi	s0,sp,16
  test0();
 544:	00000097          	auipc	ra,0x0
 548:	ce2080e7          	jalr	-798(ra) # 226 <test0>
  test1();
 54c:	00000097          	auipc	ra,0x0
 550:	eac080e7          	jalr	-340(ra) # 3f8 <test1>
  exit(0);
 554:	4501                	li	a0,0
 556:	00000097          	auipc	ra,0x0
 55a:	27e080e7          	jalr	638(ra) # 7d4 <exit>

000000000000055e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 55e:	1141                	addi	sp,sp,-16
 560:	e422                	sd	s0,8(sp)
 562:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 564:	87aa                	mv	a5,a0
 566:	0585                	addi	a1,a1,1
 568:	0785                	addi	a5,a5,1
 56a:	fff5c703          	lbu	a4,-1(a1) # 18fff <__BSS_END__+0x170ef>
 56e:	fee78fa3          	sb	a4,-1(a5)
 572:	fb75                	bnez	a4,566 <strcpy+0x8>
    ;
  return os;
}
 574:	6422                	ld	s0,8(sp)
 576:	0141                	addi	sp,sp,16
 578:	8082                	ret

000000000000057a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 57a:	1141                	addi	sp,sp,-16
 57c:	e422                	sd	s0,8(sp)
 57e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 580:	00054783          	lbu	a5,0(a0)
 584:	cb91                	beqz	a5,598 <strcmp+0x1e>
 586:	0005c703          	lbu	a4,0(a1)
 58a:	00f71763          	bne	a4,a5,598 <strcmp+0x1e>
    p++, q++;
 58e:	0505                	addi	a0,a0,1
 590:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 592:	00054783          	lbu	a5,0(a0)
 596:	fbe5                	bnez	a5,586 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 598:	0005c503          	lbu	a0,0(a1)
}
 59c:	40a7853b          	subw	a0,a5,a0
 5a0:	6422                	ld	s0,8(sp)
 5a2:	0141                	addi	sp,sp,16
 5a4:	8082                	ret

00000000000005a6 <strlen>:

uint
strlen(const char *s)
{
 5a6:	1141                	addi	sp,sp,-16
 5a8:	e422                	sd	s0,8(sp)
 5aa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 5ac:	00054783          	lbu	a5,0(a0)
 5b0:	cf91                	beqz	a5,5cc <strlen+0x26>
 5b2:	0505                	addi	a0,a0,1
 5b4:	87aa                	mv	a5,a0
 5b6:	4685                	li	a3,1
 5b8:	9e89                	subw	a3,a3,a0
 5ba:	00f6853b          	addw	a0,a3,a5
 5be:	0785                	addi	a5,a5,1
 5c0:	fff7c703          	lbu	a4,-1(a5)
 5c4:	fb7d                	bnez	a4,5ba <strlen+0x14>
    ;
  return n;
}
 5c6:	6422                	ld	s0,8(sp)
 5c8:	0141                	addi	sp,sp,16
 5ca:	8082                	ret
  for(n = 0; s[n]; n++)
 5cc:	4501                	li	a0,0
 5ce:	bfe5                	j	5c6 <strlen+0x20>

00000000000005d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5d0:	1141                	addi	sp,sp,-16
 5d2:	e422                	sd	s0,8(sp)
 5d4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 5d6:	ce09                	beqz	a2,5f0 <memset+0x20>
 5d8:	87aa                	mv	a5,a0
 5da:	fff6071b          	addiw	a4,a2,-1
 5de:	1702                	slli	a4,a4,0x20
 5e0:	9301                	srli	a4,a4,0x20
 5e2:	0705                	addi	a4,a4,1
 5e4:	972a                	add	a4,a4,a0
    cdst[i] = c;
 5e6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5ea:	0785                	addi	a5,a5,1
 5ec:	fee79de3          	bne	a5,a4,5e6 <memset+0x16>
  }
  return dst;
}
 5f0:	6422                	ld	s0,8(sp)
 5f2:	0141                	addi	sp,sp,16
 5f4:	8082                	ret

00000000000005f6 <strchr>:

char*
strchr(const char *s, char c)
{
 5f6:	1141                	addi	sp,sp,-16
 5f8:	e422                	sd	s0,8(sp)
 5fa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 5fc:	00054783          	lbu	a5,0(a0)
 600:	cb99                	beqz	a5,616 <strchr+0x20>
    if(*s == c)
 602:	00f58763          	beq	a1,a5,610 <strchr+0x1a>
  for(; *s; s++)
 606:	0505                	addi	a0,a0,1
 608:	00054783          	lbu	a5,0(a0)
 60c:	fbfd                	bnez	a5,602 <strchr+0xc>
      return (char*)s;
  return 0;
 60e:	4501                	li	a0,0
}
 610:	6422                	ld	s0,8(sp)
 612:	0141                	addi	sp,sp,16
 614:	8082                	ret
  return 0;
 616:	4501                	li	a0,0
 618:	bfe5                	j	610 <strchr+0x1a>

000000000000061a <gets>:

char*
gets(char *buf, int max)
{
 61a:	711d                	addi	sp,sp,-96
 61c:	ec86                	sd	ra,88(sp)
 61e:	e8a2                	sd	s0,80(sp)
 620:	e4a6                	sd	s1,72(sp)
 622:	e0ca                	sd	s2,64(sp)
 624:	fc4e                	sd	s3,56(sp)
 626:	f852                	sd	s4,48(sp)
 628:	f456                	sd	s5,40(sp)
 62a:	f05a                	sd	s6,32(sp)
 62c:	ec5e                	sd	s7,24(sp)
 62e:	1080                	addi	s0,sp,96
 630:	8baa                	mv	s7,a0
 632:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 634:	892a                	mv	s2,a0
 636:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 638:	4aa9                	li	s5,10
 63a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 63c:	89a6                	mv	s3,s1
 63e:	2485                	addiw	s1,s1,1
 640:	0344d863          	bge	s1,s4,670 <gets+0x56>
    cc = read(0, &c, 1);
 644:	4605                	li	a2,1
 646:	faf40593          	addi	a1,s0,-81
 64a:	4501                	li	a0,0
 64c:	00000097          	auipc	ra,0x0
 650:	1a0080e7          	jalr	416(ra) # 7ec <read>
    if(cc < 1)
 654:	00a05e63          	blez	a0,670 <gets+0x56>
    buf[i++] = c;
 658:	faf44783          	lbu	a5,-81(s0)
 65c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 660:	01578763          	beq	a5,s5,66e <gets+0x54>
 664:	0905                	addi	s2,s2,1
 666:	fd679be3          	bne	a5,s6,63c <gets+0x22>
  for(i=0; i+1 < max; ){
 66a:	89a6                	mv	s3,s1
 66c:	a011                	j	670 <gets+0x56>
 66e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 670:	99de                	add	s3,s3,s7
 672:	00098023          	sb	zero,0(s3)
  return buf;
}
 676:	855e                	mv	a0,s7
 678:	60e6                	ld	ra,88(sp)
 67a:	6446                	ld	s0,80(sp)
 67c:	64a6                	ld	s1,72(sp)
 67e:	6906                	ld	s2,64(sp)
 680:	79e2                	ld	s3,56(sp)
 682:	7a42                	ld	s4,48(sp)
 684:	7aa2                	ld	s5,40(sp)
 686:	7b02                	ld	s6,32(sp)
 688:	6be2                	ld	s7,24(sp)
 68a:	6125                	addi	sp,sp,96
 68c:	8082                	ret

000000000000068e <stat>:

int
stat(const char *n, struct stat *st)
{
 68e:	1101                	addi	sp,sp,-32
 690:	ec06                	sd	ra,24(sp)
 692:	e822                	sd	s0,16(sp)
 694:	e426                	sd	s1,8(sp)
 696:	e04a                	sd	s2,0(sp)
 698:	1000                	addi	s0,sp,32
 69a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 69c:	4581                	li	a1,0
 69e:	00000097          	auipc	ra,0x0
 6a2:	176080e7          	jalr	374(ra) # 814 <open>
  if(fd < 0)
 6a6:	02054563          	bltz	a0,6d0 <stat+0x42>
 6aa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 6ac:	85ca                	mv	a1,s2
 6ae:	00000097          	auipc	ra,0x0
 6b2:	17e080e7          	jalr	382(ra) # 82c <fstat>
 6b6:	892a                	mv	s2,a0
  close(fd);
 6b8:	8526                	mv	a0,s1
 6ba:	00000097          	auipc	ra,0x0
 6be:	142080e7          	jalr	322(ra) # 7fc <close>
  return r;
}
 6c2:	854a                	mv	a0,s2
 6c4:	60e2                	ld	ra,24(sp)
 6c6:	6442                	ld	s0,16(sp)
 6c8:	64a2                	ld	s1,8(sp)
 6ca:	6902                	ld	s2,0(sp)
 6cc:	6105                	addi	sp,sp,32
 6ce:	8082                	ret
    return -1;
 6d0:	597d                	li	s2,-1
 6d2:	bfc5                	j	6c2 <stat+0x34>

00000000000006d4 <atoi>:

int
atoi(const char *s)
{
 6d4:	1141                	addi	sp,sp,-16
 6d6:	e422                	sd	s0,8(sp)
 6d8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6da:	00054603          	lbu	a2,0(a0)
 6de:	fd06079b          	addiw	a5,a2,-48
 6e2:	0ff7f793          	andi	a5,a5,255
 6e6:	4725                	li	a4,9
 6e8:	02f76963          	bltu	a4,a5,71a <atoi+0x46>
 6ec:	86aa                	mv	a3,a0
  n = 0;
 6ee:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 6f0:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 6f2:	0685                	addi	a3,a3,1
 6f4:	0025179b          	slliw	a5,a0,0x2
 6f8:	9fa9                	addw	a5,a5,a0
 6fa:	0017979b          	slliw	a5,a5,0x1
 6fe:	9fb1                	addw	a5,a5,a2
 700:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 704:	0006c603          	lbu	a2,0(a3)
 708:	fd06071b          	addiw	a4,a2,-48
 70c:	0ff77713          	andi	a4,a4,255
 710:	fee5f1e3          	bgeu	a1,a4,6f2 <atoi+0x1e>
  return n;
}
 714:	6422                	ld	s0,8(sp)
 716:	0141                	addi	sp,sp,16
 718:	8082                	ret
  n = 0;
 71a:	4501                	li	a0,0
 71c:	bfe5                	j	714 <atoi+0x40>

000000000000071e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 71e:	1141                	addi	sp,sp,-16
 720:	e422                	sd	s0,8(sp)
 722:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 724:	02b57663          	bgeu	a0,a1,750 <memmove+0x32>
    while(n-- > 0)
 728:	02c05163          	blez	a2,74a <memmove+0x2c>
 72c:	fff6079b          	addiw	a5,a2,-1
 730:	1782                	slli	a5,a5,0x20
 732:	9381                	srli	a5,a5,0x20
 734:	0785                	addi	a5,a5,1
 736:	97aa                	add	a5,a5,a0
  dst = vdst;
 738:	872a                	mv	a4,a0
      *dst++ = *src++;
 73a:	0585                	addi	a1,a1,1
 73c:	0705                	addi	a4,a4,1
 73e:	fff5c683          	lbu	a3,-1(a1)
 742:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 746:	fee79ae3          	bne	a5,a4,73a <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 74a:	6422                	ld	s0,8(sp)
 74c:	0141                	addi	sp,sp,16
 74e:	8082                	ret
    dst += n;
 750:	00c50733          	add	a4,a0,a2
    src += n;
 754:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 756:	fec05ae3          	blez	a2,74a <memmove+0x2c>
 75a:	fff6079b          	addiw	a5,a2,-1
 75e:	1782                	slli	a5,a5,0x20
 760:	9381                	srli	a5,a5,0x20
 762:	fff7c793          	not	a5,a5
 766:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 768:	15fd                	addi	a1,a1,-1
 76a:	177d                	addi	a4,a4,-1
 76c:	0005c683          	lbu	a3,0(a1)
 770:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 774:	fee79ae3          	bne	a5,a4,768 <memmove+0x4a>
 778:	bfc9                	j	74a <memmove+0x2c>

000000000000077a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 77a:	1141                	addi	sp,sp,-16
 77c:	e422                	sd	s0,8(sp)
 77e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 780:	ca05                	beqz	a2,7b0 <memcmp+0x36>
 782:	fff6069b          	addiw	a3,a2,-1
 786:	1682                	slli	a3,a3,0x20
 788:	9281                	srli	a3,a3,0x20
 78a:	0685                	addi	a3,a3,1
 78c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 78e:	00054783          	lbu	a5,0(a0)
 792:	0005c703          	lbu	a4,0(a1)
 796:	00e79863          	bne	a5,a4,7a6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 79a:	0505                	addi	a0,a0,1
    p2++;
 79c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 79e:	fed518e3          	bne	a0,a3,78e <memcmp+0x14>
  }
  return 0;
 7a2:	4501                	li	a0,0
 7a4:	a019                	j	7aa <memcmp+0x30>
      return *p1 - *p2;
 7a6:	40e7853b          	subw	a0,a5,a4
}
 7aa:	6422                	ld	s0,8(sp)
 7ac:	0141                	addi	sp,sp,16
 7ae:	8082                	ret
  return 0;
 7b0:	4501                	li	a0,0
 7b2:	bfe5                	j	7aa <memcmp+0x30>

00000000000007b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 7b4:	1141                	addi	sp,sp,-16
 7b6:	e406                	sd	ra,8(sp)
 7b8:	e022                	sd	s0,0(sp)
 7ba:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 7bc:	00000097          	auipc	ra,0x0
 7c0:	f62080e7          	jalr	-158(ra) # 71e <memmove>
}
 7c4:	60a2                	ld	ra,8(sp)
 7c6:	6402                	ld	s0,0(sp)
 7c8:	0141                	addi	sp,sp,16
 7ca:	8082                	ret

00000000000007cc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 7cc:	4885                	li	a7,1
 ecall
 7ce:	00000073          	ecall
 ret
 7d2:	8082                	ret

00000000000007d4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 7d4:	4889                	li	a7,2
 ecall
 7d6:	00000073          	ecall
 ret
 7da:	8082                	ret

00000000000007dc <wait>:
.global wait
wait:
 li a7, SYS_wait
 7dc:	488d                	li	a7,3
 ecall
 7de:	00000073          	ecall
 ret
 7e2:	8082                	ret

00000000000007e4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7e4:	4891                	li	a7,4
 ecall
 7e6:	00000073          	ecall
 ret
 7ea:	8082                	ret

00000000000007ec <read>:
.global read
read:
 li a7, SYS_read
 7ec:	4895                	li	a7,5
 ecall
 7ee:	00000073          	ecall
 ret
 7f2:	8082                	ret

00000000000007f4 <write>:
.global write
write:
 li a7, SYS_write
 7f4:	48c1                	li	a7,16
 ecall
 7f6:	00000073          	ecall
 ret
 7fa:	8082                	ret

00000000000007fc <close>:
.global close
close:
 li a7, SYS_close
 7fc:	48d5                	li	a7,21
 ecall
 7fe:	00000073          	ecall
 ret
 802:	8082                	ret

0000000000000804 <kill>:
.global kill
kill:
 li a7, SYS_kill
 804:	4899                	li	a7,6
 ecall
 806:	00000073          	ecall
 ret
 80a:	8082                	ret

000000000000080c <exec>:
.global exec
exec:
 li a7, SYS_exec
 80c:	489d                	li	a7,7
 ecall
 80e:	00000073          	ecall
 ret
 812:	8082                	ret

0000000000000814 <open>:
.global open
open:
 li a7, SYS_open
 814:	48bd                	li	a7,15
 ecall
 816:	00000073          	ecall
 ret
 81a:	8082                	ret

000000000000081c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 81c:	48c5                	li	a7,17
 ecall
 81e:	00000073          	ecall
 ret
 822:	8082                	ret

0000000000000824 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 824:	48c9                	li	a7,18
 ecall
 826:	00000073          	ecall
 ret
 82a:	8082                	ret

000000000000082c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 82c:	48a1                	li	a7,8
 ecall
 82e:	00000073          	ecall
 ret
 832:	8082                	ret

0000000000000834 <link>:
.global link
link:
 li a7, SYS_link
 834:	48cd                	li	a7,19
 ecall
 836:	00000073          	ecall
 ret
 83a:	8082                	ret

000000000000083c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 83c:	48d1                	li	a7,20
 ecall
 83e:	00000073          	ecall
 ret
 842:	8082                	ret

0000000000000844 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 844:	48a5                	li	a7,9
 ecall
 846:	00000073          	ecall
 ret
 84a:	8082                	ret

000000000000084c <dup>:
.global dup
dup:
 li a7, SYS_dup
 84c:	48a9                	li	a7,10
 ecall
 84e:	00000073          	ecall
 ret
 852:	8082                	ret

0000000000000854 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 854:	48ad                	li	a7,11
 ecall
 856:	00000073          	ecall
 ret
 85a:	8082                	ret

000000000000085c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 85c:	48b1                	li	a7,12
 ecall
 85e:	00000073          	ecall
 ret
 862:	8082                	ret

0000000000000864 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 864:	48b5                	li	a7,13
 ecall
 866:	00000073          	ecall
 ret
 86a:	8082                	ret

000000000000086c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 86c:	48b9                	li	a7,14
 ecall
 86e:	00000073          	ecall
 ret
 872:	8082                	ret

0000000000000874 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 874:	1101                	addi	sp,sp,-32
 876:	ec06                	sd	ra,24(sp)
 878:	e822                	sd	s0,16(sp)
 87a:	1000                	addi	s0,sp,32
 87c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 880:	4605                	li	a2,1
 882:	fef40593          	addi	a1,s0,-17
 886:	00000097          	auipc	ra,0x0
 88a:	f6e080e7          	jalr	-146(ra) # 7f4 <write>
}
 88e:	60e2                	ld	ra,24(sp)
 890:	6442                	ld	s0,16(sp)
 892:	6105                	addi	sp,sp,32
 894:	8082                	ret

0000000000000896 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 896:	7139                	addi	sp,sp,-64
 898:	fc06                	sd	ra,56(sp)
 89a:	f822                	sd	s0,48(sp)
 89c:	f426                	sd	s1,40(sp)
 89e:	f04a                	sd	s2,32(sp)
 8a0:	ec4e                	sd	s3,24(sp)
 8a2:	0080                	addi	s0,sp,64
 8a4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 8a6:	c299                	beqz	a3,8ac <printint+0x16>
 8a8:	0805c863          	bltz	a1,938 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 8ac:	2581                	sext.w	a1,a1
  neg = 0;
 8ae:	4881                	li	a7,0
 8b0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 8b4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 8b6:	2601                	sext.w	a2,a2
 8b8:	00000517          	auipc	a0,0x0
 8bc:	60050513          	addi	a0,a0,1536 # eb8 <digits>
 8c0:	883a                	mv	a6,a4
 8c2:	2705                	addiw	a4,a4,1
 8c4:	02c5f7bb          	remuw	a5,a1,a2
 8c8:	1782                	slli	a5,a5,0x20
 8ca:	9381                	srli	a5,a5,0x20
 8cc:	97aa                	add	a5,a5,a0
 8ce:	0007c783          	lbu	a5,0(a5)
 8d2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 8d6:	0005879b          	sext.w	a5,a1
 8da:	02c5d5bb          	divuw	a1,a1,a2
 8de:	0685                	addi	a3,a3,1
 8e0:	fec7f0e3          	bgeu	a5,a2,8c0 <printint+0x2a>
  if(neg)
 8e4:	00088b63          	beqz	a7,8fa <printint+0x64>
    buf[i++] = '-';
 8e8:	fd040793          	addi	a5,s0,-48
 8ec:	973e                	add	a4,a4,a5
 8ee:	02d00793          	li	a5,45
 8f2:	fef70823          	sb	a5,-16(a4)
 8f6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 8fa:	02e05863          	blez	a4,92a <printint+0x94>
 8fe:	fc040793          	addi	a5,s0,-64
 902:	00e78933          	add	s2,a5,a4
 906:	fff78993          	addi	s3,a5,-1
 90a:	99ba                	add	s3,s3,a4
 90c:	377d                	addiw	a4,a4,-1
 90e:	1702                	slli	a4,a4,0x20
 910:	9301                	srli	a4,a4,0x20
 912:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 916:	fff94583          	lbu	a1,-1(s2)
 91a:	8526                	mv	a0,s1
 91c:	00000097          	auipc	ra,0x0
 920:	f58080e7          	jalr	-168(ra) # 874 <putc>
  while(--i >= 0)
 924:	197d                	addi	s2,s2,-1
 926:	ff3918e3          	bne	s2,s3,916 <printint+0x80>
}
 92a:	70e2                	ld	ra,56(sp)
 92c:	7442                	ld	s0,48(sp)
 92e:	74a2                	ld	s1,40(sp)
 930:	7902                	ld	s2,32(sp)
 932:	69e2                	ld	s3,24(sp)
 934:	6121                	addi	sp,sp,64
 936:	8082                	ret
    x = -xx;
 938:	40b005bb          	negw	a1,a1
    neg = 1;
 93c:	4885                	li	a7,1
    x = -xx;
 93e:	bf8d                	j	8b0 <printint+0x1a>

0000000000000940 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 940:	7119                	addi	sp,sp,-128
 942:	fc86                	sd	ra,120(sp)
 944:	f8a2                	sd	s0,112(sp)
 946:	f4a6                	sd	s1,104(sp)
 948:	f0ca                	sd	s2,96(sp)
 94a:	ecce                	sd	s3,88(sp)
 94c:	e8d2                	sd	s4,80(sp)
 94e:	e4d6                	sd	s5,72(sp)
 950:	e0da                	sd	s6,64(sp)
 952:	fc5e                	sd	s7,56(sp)
 954:	f862                	sd	s8,48(sp)
 956:	f466                	sd	s9,40(sp)
 958:	f06a                	sd	s10,32(sp)
 95a:	ec6e                	sd	s11,24(sp)
 95c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 95e:	0005c903          	lbu	s2,0(a1)
 962:	18090f63          	beqz	s2,b00 <vprintf+0x1c0>
 966:	8aaa                	mv	s5,a0
 968:	8b32                	mv	s6,a2
 96a:	00158493          	addi	s1,a1,1
  state = 0;
 96e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 970:	02500a13          	li	s4,37
      if(c == 'd'){
 974:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 978:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 97c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 980:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 984:	00000b97          	auipc	s7,0x0
 988:	534b8b93          	addi	s7,s7,1332 # eb8 <digits>
 98c:	a839                	j	9aa <vprintf+0x6a>
        putc(fd, c);
 98e:	85ca                	mv	a1,s2
 990:	8556                	mv	a0,s5
 992:	00000097          	auipc	ra,0x0
 996:	ee2080e7          	jalr	-286(ra) # 874 <putc>
 99a:	a019                	j	9a0 <vprintf+0x60>
    } else if(state == '%'){
 99c:	01498f63          	beq	s3,s4,9ba <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 9a0:	0485                	addi	s1,s1,1
 9a2:	fff4c903          	lbu	s2,-1(s1)
 9a6:	14090d63          	beqz	s2,b00 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 9aa:	0009079b          	sext.w	a5,s2
    if(state == 0){
 9ae:	fe0997e3          	bnez	s3,99c <vprintf+0x5c>
      if(c == '%'){
 9b2:	fd479ee3          	bne	a5,s4,98e <vprintf+0x4e>
        state = '%';
 9b6:	89be                	mv	s3,a5
 9b8:	b7e5                	j	9a0 <vprintf+0x60>
      if(c == 'd'){
 9ba:	05878063          	beq	a5,s8,9fa <vprintf+0xba>
      } else if(c == 'l') {
 9be:	05978c63          	beq	a5,s9,a16 <vprintf+0xd6>
      } else if(c == 'x') {
 9c2:	07a78863          	beq	a5,s10,a32 <vprintf+0xf2>
      } else if(c == 'p') {
 9c6:	09b78463          	beq	a5,s11,a4e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 9ca:	07300713          	li	a4,115
 9ce:	0ce78663          	beq	a5,a4,a9a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9d2:	06300713          	li	a4,99
 9d6:	0ee78e63          	beq	a5,a4,ad2 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 9da:	11478863          	beq	a5,s4,aea <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9de:	85d2                	mv	a1,s4
 9e0:	8556                	mv	a0,s5
 9e2:	00000097          	auipc	ra,0x0
 9e6:	e92080e7          	jalr	-366(ra) # 874 <putc>
        putc(fd, c);
 9ea:	85ca                	mv	a1,s2
 9ec:	8556                	mv	a0,s5
 9ee:	00000097          	auipc	ra,0x0
 9f2:	e86080e7          	jalr	-378(ra) # 874 <putc>
      }
      state = 0;
 9f6:	4981                	li	s3,0
 9f8:	b765                	j	9a0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 9fa:	008b0913          	addi	s2,s6,8
 9fe:	4685                	li	a3,1
 a00:	4629                	li	a2,10
 a02:	000b2583          	lw	a1,0(s6)
 a06:	8556                	mv	a0,s5
 a08:	00000097          	auipc	ra,0x0
 a0c:	e8e080e7          	jalr	-370(ra) # 896 <printint>
 a10:	8b4a                	mv	s6,s2
      state = 0;
 a12:	4981                	li	s3,0
 a14:	b771                	j	9a0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a16:	008b0913          	addi	s2,s6,8
 a1a:	4681                	li	a3,0
 a1c:	4629                	li	a2,10
 a1e:	000b2583          	lw	a1,0(s6)
 a22:	8556                	mv	a0,s5
 a24:	00000097          	auipc	ra,0x0
 a28:	e72080e7          	jalr	-398(ra) # 896 <printint>
 a2c:	8b4a                	mv	s6,s2
      state = 0;
 a2e:	4981                	li	s3,0
 a30:	bf85                	j	9a0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 a32:	008b0913          	addi	s2,s6,8
 a36:	4681                	li	a3,0
 a38:	4641                	li	a2,16
 a3a:	000b2583          	lw	a1,0(s6)
 a3e:	8556                	mv	a0,s5
 a40:	00000097          	auipc	ra,0x0
 a44:	e56080e7          	jalr	-426(ra) # 896 <printint>
 a48:	8b4a                	mv	s6,s2
      state = 0;
 a4a:	4981                	li	s3,0
 a4c:	bf91                	j	9a0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 a4e:	008b0793          	addi	a5,s6,8
 a52:	f8f43423          	sd	a5,-120(s0)
 a56:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 a5a:	03000593          	li	a1,48
 a5e:	8556                	mv	a0,s5
 a60:	00000097          	auipc	ra,0x0
 a64:	e14080e7          	jalr	-492(ra) # 874 <putc>
  putc(fd, 'x');
 a68:	85ea                	mv	a1,s10
 a6a:	8556                	mv	a0,s5
 a6c:	00000097          	auipc	ra,0x0
 a70:	e08080e7          	jalr	-504(ra) # 874 <putc>
 a74:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a76:	03c9d793          	srli	a5,s3,0x3c
 a7a:	97de                	add	a5,a5,s7
 a7c:	0007c583          	lbu	a1,0(a5)
 a80:	8556                	mv	a0,s5
 a82:	00000097          	auipc	ra,0x0
 a86:	df2080e7          	jalr	-526(ra) # 874 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a8a:	0992                	slli	s3,s3,0x4
 a8c:	397d                	addiw	s2,s2,-1
 a8e:	fe0914e3          	bnez	s2,a76 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 a92:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 a96:	4981                	li	s3,0
 a98:	b721                	j	9a0 <vprintf+0x60>
        s = va_arg(ap, char*);
 a9a:	008b0993          	addi	s3,s6,8
 a9e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 aa2:	02090163          	beqz	s2,ac4 <vprintf+0x184>
        while(*s != 0){
 aa6:	00094583          	lbu	a1,0(s2)
 aaa:	c9a1                	beqz	a1,afa <vprintf+0x1ba>
          putc(fd, *s);
 aac:	8556                	mv	a0,s5
 aae:	00000097          	auipc	ra,0x0
 ab2:	dc6080e7          	jalr	-570(ra) # 874 <putc>
          s++;
 ab6:	0905                	addi	s2,s2,1
        while(*s != 0){
 ab8:	00094583          	lbu	a1,0(s2)
 abc:	f9e5                	bnez	a1,aac <vprintf+0x16c>
        s = va_arg(ap, char*);
 abe:	8b4e                	mv	s6,s3
      state = 0;
 ac0:	4981                	li	s3,0
 ac2:	bdf9                	j	9a0 <vprintf+0x60>
          s = "(null)";
 ac4:	00000917          	auipc	s2,0x0
 ac8:	3ec90913          	addi	s2,s2,1004 # eb0 <statistics+0x1c2>
        while(*s != 0){
 acc:	02800593          	li	a1,40
 ad0:	bff1                	j	aac <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 ad2:	008b0913          	addi	s2,s6,8
 ad6:	000b4583          	lbu	a1,0(s6)
 ada:	8556                	mv	a0,s5
 adc:	00000097          	auipc	ra,0x0
 ae0:	d98080e7          	jalr	-616(ra) # 874 <putc>
 ae4:	8b4a                	mv	s6,s2
      state = 0;
 ae6:	4981                	li	s3,0
 ae8:	bd65                	j	9a0 <vprintf+0x60>
        putc(fd, c);
 aea:	85d2                	mv	a1,s4
 aec:	8556                	mv	a0,s5
 aee:	00000097          	auipc	ra,0x0
 af2:	d86080e7          	jalr	-634(ra) # 874 <putc>
      state = 0;
 af6:	4981                	li	s3,0
 af8:	b565                	j	9a0 <vprintf+0x60>
        s = va_arg(ap, char*);
 afa:	8b4e                	mv	s6,s3
      state = 0;
 afc:	4981                	li	s3,0
 afe:	b54d                	j	9a0 <vprintf+0x60>
    }
  }
}
 b00:	70e6                	ld	ra,120(sp)
 b02:	7446                	ld	s0,112(sp)
 b04:	74a6                	ld	s1,104(sp)
 b06:	7906                	ld	s2,96(sp)
 b08:	69e6                	ld	s3,88(sp)
 b0a:	6a46                	ld	s4,80(sp)
 b0c:	6aa6                	ld	s5,72(sp)
 b0e:	6b06                	ld	s6,64(sp)
 b10:	7be2                	ld	s7,56(sp)
 b12:	7c42                	ld	s8,48(sp)
 b14:	7ca2                	ld	s9,40(sp)
 b16:	7d02                	ld	s10,32(sp)
 b18:	6de2                	ld	s11,24(sp)
 b1a:	6109                	addi	sp,sp,128
 b1c:	8082                	ret

0000000000000b1e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b1e:	715d                	addi	sp,sp,-80
 b20:	ec06                	sd	ra,24(sp)
 b22:	e822                	sd	s0,16(sp)
 b24:	1000                	addi	s0,sp,32
 b26:	e010                	sd	a2,0(s0)
 b28:	e414                	sd	a3,8(s0)
 b2a:	e818                	sd	a4,16(s0)
 b2c:	ec1c                	sd	a5,24(s0)
 b2e:	03043023          	sd	a6,32(s0)
 b32:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b36:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b3a:	8622                	mv	a2,s0
 b3c:	00000097          	auipc	ra,0x0
 b40:	e04080e7          	jalr	-508(ra) # 940 <vprintf>
}
 b44:	60e2                	ld	ra,24(sp)
 b46:	6442                	ld	s0,16(sp)
 b48:	6161                	addi	sp,sp,80
 b4a:	8082                	ret

0000000000000b4c <printf>:

void
printf(const char *fmt, ...)
{
 b4c:	711d                	addi	sp,sp,-96
 b4e:	ec06                	sd	ra,24(sp)
 b50:	e822                	sd	s0,16(sp)
 b52:	1000                	addi	s0,sp,32
 b54:	e40c                	sd	a1,8(s0)
 b56:	e810                	sd	a2,16(s0)
 b58:	ec14                	sd	a3,24(s0)
 b5a:	f018                	sd	a4,32(s0)
 b5c:	f41c                	sd	a5,40(s0)
 b5e:	03043823          	sd	a6,48(s0)
 b62:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b66:	00840613          	addi	a2,s0,8
 b6a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b6e:	85aa                	mv	a1,a0
 b70:	4505                	li	a0,1
 b72:	00000097          	auipc	ra,0x0
 b76:	dce080e7          	jalr	-562(ra) # 940 <vprintf>
}
 b7a:	60e2                	ld	ra,24(sp)
 b7c:	6442                	ld	s0,16(sp)
 b7e:	6125                	addi	sp,sp,96
 b80:	8082                	ret

0000000000000b82 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b82:	1141                	addi	sp,sp,-16
 b84:	e422                	sd	s0,8(sp)
 b86:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b88:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b8c:	00000797          	auipc	a5,0x0
 b90:	36c7b783          	ld	a5,876(a5) # ef8 <freep>
 b94:	a805                	j	bc4 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b96:	4618                	lw	a4,8(a2)
 b98:	9db9                	addw	a1,a1,a4
 b9a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b9e:	6398                	ld	a4,0(a5)
 ba0:	6318                	ld	a4,0(a4)
 ba2:	fee53823          	sd	a4,-16(a0)
 ba6:	a091                	j	bea <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ba8:	ff852703          	lw	a4,-8(a0)
 bac:	9e39                	addw	a2,a2,a4
 bae:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 bb0:	ff053703          	ld	a4,-16(a0)
 bb4:	e398                	sd	a4,0(a5)
 bb6:	a099                	j	bfc <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bb8:	6398                	ld	a4,0(a5)
 bba:	00e7e463          	bltu	a5,a4,bc2 <free+0x40>
 bbe:	00e6ea63          	bltu	a3,a4,bd2 <free+0x50>
{
 bc2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bc4:	fed7fae3          	bgeu	a5,a3,bb8 <free+0x36>
 bc8:	6398                	ld	a4,0(a5)
 bca:	00e6e463          	bltu	a3,a4,bd2 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bce:	fee7eae3          	bltu	a5,a4,bc2 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 bd2:	ff852583          	lw	a1,-8(a0)
 bd6:	6390                	ld	a2,0(a5)
 bd8:	02059713          	slli	a4,a1,0x20
 bdc:	9301                	srli	a4,a4,0x20
 bde:	0712                	slli	a4,a4,0x4
 be0:	9736                	add	a4,a4,a3
 be2:	fae60ae3          	beq	a2,a4,b96 <free+0x14>
    bp->s.ptr = p->s.ptr;
 be6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 bea:	4790                	lw	a2,8(a5)
 bec:	02061713          	slli	a4,a2,0x20
 bf0:	9301                	srli	a4,a4,0x20
 bf2:	0712                	slli	a4,a4,0x4
 bf4:	973e                	add	a4,a4,a5
 bf6:	fae689e3          	beq	a3,a4,ba8 <free+0x26>
  } else
    p->s.ptr = bp;
 bfa:	e394                	sd	a3,0(a5)
  freep = p;
 bfc:	00000717          	auipc	a4,0x0
 c00:	2ef73e23          	sd	a5,764(a4) # ef8 <freep>
}
 c04:	6422                	ld	s0,8(sp)
 c06:	0141                	addi	sp,sp,16
 c08:	8082                	ret

0000000000000c0a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c0a:	7139                	addi	sp,sp,-64
 c0c:	fc06                	sd	ra,56(sp)
 c0e:	f822                	sd	s0,48(sp)
 c10:	f426                	sd	s1,40(sp)
 c12:	f04a                	sd	s2,32(sp)
 c14:	ec4e                	sd	s3,24(sp)
 c16:	e852                	sd	s4,16(sp)
 c18:	e456                	sd	s5,8(sp)
 c1a:	e05a                	sd	s6,0(sp)
 c1c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c1e:	02051493          	slli	s1,a0,0x20
 c22:	9081                	srli	s1,s1,0x20
 c24:	04bd                	addi	s1,s1,15
 c26:	8091                	srli	s1,s1,0x4
 c28:	0014899b          	addiw	s3,s1,1
 c2c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 c2e:	00000517          	auipc	a0,0x0
 c32:	2ca53503          	ld	a0,714(a0) # ef8 <freep>
 c36:	c515                	beqz	a0,c62 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c38:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c3a:	4798                	lw	a4,8(a5)
 c3c:	02977f63          	bgeu	a4,s1,c7a <malloc+0x70>
 c40:	8a4e                	mv	s4,s3
 c42:	0009871b          	sext.w	a4,s3
 c46:	6685                	lui	a3,0x1
 c48:	00d77363          	bgeu	a4,a3,c4e <malloc+0x44>
 c4c:	6a05                	lui	s4,0x1
 c4e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c52:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c56:	00000917          	auipc	s2,0x0
 c5a:	2a290913          	addi	s2,s2,674 # ef8 <freep>
  if(p == (char*)-1)
 c5e:	5afd                	li	s5,-1
 c60:	a88d                	j	cd2 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 c62:	00001797          	auipc	a5,0x1
 c66:	29e78793          	addi	a5,a5,670 # 1f00 <base>
 c6a:	00000717          	auipc	a4,0x0
 c6e:	28f73723          	sd	a5,654(a4) # ef8 <freep>
 c72:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c74:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c78:	b7e1                	j	c40 <malloc+0x36>
      if(p->s.size == nunits)
 c7a:	02e48b63          	beq	s1,a4,cb0 <malloc+0xa6>
        p->s.size -= nunits;
 c7e:	4137073b          	subw	a4,a4,s3
 c82:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c84:	1702                	slli	a4,a4,0x20
 c86:	9301                	srli	a4,a4,0x20
 c88:	0712                	slli	a4,a4,0x4
 c8a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c8c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c90:	00000717          	auipc	a4,0x0
 c94:	26a73423          	sd	a0,616(a4) # ef8 <freep>
      return (void*)(p + 1);
 c98:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 c9c:	70e2                	ld	ra,56(sp)
 c9e:	7442                	ld	s0,48(sp)
 ca0:	74a2                	ld	s1,40(sp)
 ca2:	7902                	ld	s2,32(sp)
 ca4:	69e2                	ld	s3,24(sp)
 ca6:	6a42                	ld	s4,16(sp)
 ca8:	6aa2                	ld	s5,8(sp)
 caa:	6b02                	ld	s6,0(sp)
 cac:	6121                	addi	sp,sp,64
 cae:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 cb0:	6398                	ld	a4,0(a5)
 cb2:	e118                	sd	a4,0(a0)
 cb4:	bff1                	j	c90 <malloc+0x86>
  hp->s.size = nu;
 cb6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 cba:	0541                	addi	a0,a0,16
 cbc:	00000097          	auipc	ra,0x0
 cc0:	ec6080e7          	jalr	-314(ra) # b82 <free>
  return freep;
 cc4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 cc8:	d971                	beqz	a0,c9c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ccc:	4798                	lw	a4,8(a5)
 cce:	fa9776e3          	bgeu	a4,s1,c7a <malloc+0x70>
    if(p == freep)
 cd2:	00093703          	ld	a4,0(s2)
 cd6:	853e                	mv	a0,a5
 cd8:	fef719e3          	bne	a4,a5,cca <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 cdc:	8552                	mv	a0,s4
 cde:	00000097          	auipc	ra,0x0
 ce2:	b7e080e7          	jalr	-1154(ra) # 85c <sbrk>
  if(p == (char*)-1)
 ce6:	fd5518e3          	bne	a0,s5,cb6 <malloc+0xac>
        return 0;
 cea:	4501                	li	a0,0
 cec:	bf45                	j	c9c <malloc+0x92>

0000000000000cee <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 cee:	7179                	addi	sp,sp,-48
 cf0:	f406                	sd	ra,40(sp)
 cf2:	f022                	sd	s0,32(sp)
 cf4:	ec26                	sd	s1,24(sp)
 cf6:	e84a                	sd	s2,16(sp)
 cf8:	e44e                	sd	s3,8(sp)
 cfa:	e052                	sd	s4,0(sp)
 cfc:	1800                	addi	s0,sp,48
 cfe:	8a2a                	mv	s4,a0
 d00:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 d02:	4581                	li	a1,0
 d04:	00000517          	auipc	a0,0x0
 d08:	1cc50513          	addi	a0,a0,460 # ed0 <digits+0x18>
 d0c:	00000097          	auipc	ra,0x0
 d10:	b08080e7          	jalr	-1272(ra) # 814 <open>
  if(fd < 0) {
 d14:	04054263          	bltz	a0,d58 <statistics+0x6a>
 d18:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 d1a:	4481                	li	s1,0
 d1c:	03205063          	blez	s2,d3c <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 d20:	4099063b          	subw	a2,s2,s1
 d24:	009a05b3          	add	a1,s4,s1
 d28:	854e                	mv	a0,s3
 d2a:	00000097          	auipc	ra,0x0
 d2e:	ac2080e7          	jalr	-1342(ra) # 7ec <read>
 d32:	00054563          	bltz	a0,d3c <statistics+0x4e>
      break;
    }
    i += n;
 d36:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 d38:	ff24c4e3          	blt	s1,s2,d20 <statistics+0x32>
  }
  close(fd);
 d3c:	854e                	mv	a0,s3
 d3e:	00000097          	auipc	ra,0x0
 d42:	abe080e7          	jalr	-1346(ra) # 7fc <close>
  return i;
}
 d46:	8526                	mv	a0,s1
 d48:	70a2                	ld	ra,40(sp)
 d4a:	7402                	ld	s0,32(sp)
 d4c:	64e2                	ld	s1,24(sp)
 d4e:	6942                	ld	s2,16(sp)
 d50:	69a2                	ld	s3,8(sp)
 d52:	6a02                	ld	s4,0(sp)
 d54:	6145                	addi	sp,sp,48
 d56:	8082                	ret
      fprintf(2, "stats: open failed\n");
 d58:	00000597          	auipc	a1,0x0
 d5c:	18858593          	addi	a1,a1,392 # ee0 <digits+0x28>
 d60:	4509                	li	a0,2
 d62:	00000097          	auipc	ra,0x0
 d66:	dbc080e7          	jalr	-580(ra) # b1e <fprintf>
      exit(1);
 d6a:	4505                	li	a0,1
 d6c:	00000097          	auipc	ra,0x0
 d70:	a68080e7          	jalr	-1432(ra) # 7d4 <exit>
