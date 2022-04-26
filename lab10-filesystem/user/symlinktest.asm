
user/_symlinktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <stat_slink>:
}

// stat a symbolic link using O_NOFOLLOW
static int
stat_slink(char *pn, struct stat *st)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84ae                	mv	s1,a1
  int fd = open(pn, O_RDONLY | O_NOFOLLOW);
   c:	4591                	li	a1,4
   e:	00001097          	auipc	ra,0x1
  12:	97a080e7          	jalr	-1670(ra) # 988 <open>
  if(fd < 0)
  16:	02054063          	bltz	a0,36 <stat_slink+0x36>
    return -1;
  if(fstat(fd, st) != 0)
  1a:	85a6                	mv	a1,s1
  1c:	00001097          	auipc	ra,0x1
  20:	984080e7          	jalr	-1660(ra) # 9a0 <fstat>
  24:	00a03533          	snez	a0,a0
  28:	40a00533          	neg	a0,a0
    return -1;
  return 0;
}
  2c:	60e2                	ld	ra,24(sp)
  2e:	6442                	ld	s0,16(sp)
  30:	64a2                	ld	s1,8(sp)
  32:	6105                	addi	sp,sp,32
  34:	8082                	ret
    return -1;
  36:	557d                	li	a0,-1
  38:	bfd5                	j	2c <stat_slink+0x2c>

000000000000003a <main>:
{
  3a:	7119                	addi	sp,sp,-128
  3c:	fc86                	sd	ra,120(sp)
  3e:	f8a2                	sd	s0,112(sp)
  40:	f4a6                	sd	s1,104(sp)
  42:	f0ca                	sd	s2,96(sp)
  44:	ecce                	sd	s3,88(sp)
  46:	e8d2                	sd	s4,80(sp)
  48:	e4d6                	sd	s5,72(sp)
  4a:	e0da                	sd	s6,64(sp)
  4c:	fc5e                	sd	s7,56(sp)
  4e:	f862                	sd	s8,48(sp)
  50:	0100                	addi	s0,sp,128
  unlink("/testsymlink/a");
  52:	00001517          	auipc	a0,0x1
  56:	e1e50513          	addi	a0,a0,-482 # e70 <malloc+0xea>
  5a:	00001097          	auipc	ra,0x1
  5e:	93e080e7          	jalr	-1730(ra) # 998 <unlink>
  unlink("/testsymlink/b");
  62:	00001517          	auipc	a0,0x1
  66:	e1e50513          	addi	a0,a0,-482 # e80 <malloc+0xfa>
  6a:	00001097          	auipc	ra,0x1
  6e:	92e080e7          	jalr	-1746(ra) # 998 <unlink>
  unlink("/testsymlink/c");
  72:	00001517          	auipc	a0,0x1
  76:	e1e50513          	addi	a0,a0,-482 # e90 <malloc+0x10a>
  7a:	00001097          	auipc	ra,0x1
  7e:	91e080e7          	jalr	-1762(ra) # 998 <unlink>
  unlink("/testsymlink/1");
  82:	00001517          	auipc	a0,0x1
  86:	e1e50513          	addi	a0,a0,-482 # ea0 <malloc+0x11a>
  8a:	00001097          	auipc	ra,0x1
  8e:	90e080e7          	jalr	-1778(ra) # 998 <unlink>
  unlink("/testsymlink/2");
  92:	00001517          	auipc	a0,0x1
  96:	e1e50513          	addi	a0,a0,-482 # eb0 <malloc+0x12a>
  9a:	00001097          	auipc	ra,0x1
  9e:	8fe080e7          	jalr	-1794(ra) # 998 <unlink>
  unlink("/testsymlink/3");
  a2:	00001517          	auipc	a0,0x1
  a6:	e1e50513          	addi	a0,a0,-482 # ec0 <malloc+0x13a>
  aa:	00001097          	auipc	ra,0x1
  ae:	8ee080e7          	jalr	-1810(ra) # 998 <unlink>
  unlink("/testsymlink/4");
  b2:	00001517          	auipc	a0,0x1
  b6:	e1e50513          	addi	a0,a0,-482 # ed0 <malloc+0x14a>
  ba:	00001097          	auipc	ra,0x1
  be:	8de080e7          	jalr	-1826(ra) # 998 <unlink>
  unlink("/testsymlink/z");
  c2:	00001517          	auipc	a0,0x1
  c6:	e1e50513          	addi	a0,a0,-482 # ee0 <malloc+0x15a>
  ca:	00001097          	auipc	ra,0x1
  ce:	8ce080e7          	jalr	-1842(ra) # 998 <unlink>
  unlink("/testsymlink/y");
  d2:	00001517          	auipc	a0,0x1
  d6:	e1e50513          	addi	a0,a0,-482 # ef0 <malloc+0x16a>
  da:	00001097          	auipc	ra,0x1
  de:	8be080e7          	jalr	-1858(ra) # 998 <unlink>
  unlink("/testsymlink");
  e2:	00001517          	auipc	a0,0x1
  e6:	e1e50513          	addi	a0,a0,-482 # f00 <malloc+0x17a>
  ea:	00001097          	auipc	ra,0x1
  ee:	8ae080e7          	jalr	-1874(ra) # 998 <unlink>

static void
testsymlink(void)
{
  int r, fd1 = -1, fd2 = -1;
  char buf[4] = {'a', 'b', 'c', 'd'};
  f2:	646367b7          	lui	a5,0x64636
  f6:	2617879b          	addiw	a5,a5,609
  fa:	f8f42823          	sw	a5,-112(s0)
  char c = 0, c2 = 0;
  fe:	f8040723          	sb	zero,-114(s0)
 102:	f80407a3          	sb	zero,-113(s0)
  struct stat st;
    
  printf("Start: test symlinks\n");
 106:	00001517          	auipc	a0,0x1
 10a:	e0a50513          	addi	a0,a0,-502 # f10 <malloc+0x18a>
 10e:	00001097          	auipc	ra,0x1
 112:	bba080e7          	jalr	-1094(ra) # cc8 <printf>

  mkdir("/testsymlink");
 116:	00001517          	auipc	a0,0x1
 11a:	dea50513          	addi	a0,a0,-534 # f00 <malloc+0x17a>
 11e:	00001097          	auipc	ra,0x1
 122:	892080e7          	jalr	-1902(ra) # 9b0 <mkdir>

  fd1 = open("/testsymlink/a", O_CREATE | O_RDWR);
 126:	20200593          	li	a1,514
 12a:	00001517          	auipc	a0,0x1
 12e:	d4650513          	addi	a0,a0,-698 # e70 <malloc+0xea>
 132:	00001097          	auipc	ra,0x1
 136:	856080e7          	jalr	-1962(ra) # 988 <open>
 13a:	84aa                	mv	s1,a0
  if(fd1 < 0) fail("failed to open a");
 13c:	0e054f63          	bltz	a0,23a <main+0x200>

  r = symlink("/testsymlink/a", "/testsymlink/b");
 140:	00001597          	auipc	a1,0x1
 144:	d4058593          	addi	a1,a1,-704 # e80 <malloc+0xfa>
 148:	00001517          	auipc	a0,0x1
 14c:	d2850513          	addi	a0,a0,-728 # e70 <malloc+0xea>
 150:	00001097          	auipc	ra,0x1
 154:	898080e7          	jalr	-1896(ra) # 9e8 <symlink>
  if(r < 0)
 158:	10054063          	bltz	a0,258 <main+0x21e>
    fail("symlink b -> a failed");

  if(write(fd1, buf, sizeof(buf)) != 4)
 15c:	4611                	li	a2,4
 15e:	f9040593          	addi	a1,s0,-112
 162:	8526                	mv	a0,s1
 164:	00001097          	auipc	ra,0x1
 168:	804080e7          	jalr	-2044(ra) # 968 <write>
 16c:	4791                	li	a5,4
 16e:	10f50463          	beq	a0,a5,276 <main+0x23c>
    fail("failed to write to a");
 172:	00001517          	auipc	a0,0x1
 176:	df650513          	addi	a0,a0,-522 # f68 <malloc+0x1e2>
 17a:	00001097          	auipc	ra,0x1
 17e:	b4e080e7          	jalr	-1202(ra) # cc8 <printf>
 182:	4785                	li	a5,1
 184:	00001717          	auipc	a4,0x1
 188:	1af72223          	sw	a5,420(a4) # 1328 <failed>
  int r, fd1 = -1, fd2 = -1;
 18c:	597d                	li	s2,-1
  if(c!=c2)
    fail("Value read from 4 differed from value written to 1\n");

  printf("test symlinks: ok\n");
done:
  close(fd1);
 18e:	8526                	mv	a0,s1
 190:	00000097          	auipc	ra,0x0
 194:	7e0080e7          	jalr	2016(ra) # 970 <close>
  close(fd2);
 198:	854a                	mv	a0,s2
 19a:	00000097          	auipc	ra,0x0
 19e:	7d6080e7          	jalr	2006(ra) # 970 <close>
  int pid, i;
  int fd;
  struct stat st;
  int nchild = 2;

  printf("Start: test concurrent symlinks\n");
 1a2:	00001517          	auipc	a0,0x1
 1a6:	0a650513          	addi	a0,a0,166 # 1248 <malloc+0x4c2>
 1aa:	00001097          	auipc	ra,0x1
 1ae:	b1e080e7          	jalr	-1250(ra) # cc8 <printf>
    
  fd = open("/testsymlink/z", O_CREATE | O_RDWR);
 1b2:	20200593          	li	a1,514
 1b6:	00001517          	auipc	a0,0x1
 1ba:	d2a50513          	addi	a0,a0,-726 # ee0 <malloc+0x15a>
 1be:	00000097          	auipc	ra,0x0
 1c2:	7ca080e7          	jalr	1994(ra) # 988 <open>
  if(fd < 0) {
 1c6:	42054263          	bltz	a0,5ea <main+0x5b0>
    printf("FAILED: open failed");
    exit(1);
  }
  close(fd);
 1ca:	00000097          	auipc	ra,0x0
 1ce:	7a6080e7          	jalr	1958(ra) # 970 <close>

  for(int j = 0; j < nchild; j++) {
    pid = fork();
 1d2:	00000097          	auipc	ra,0x0
 1d6:	76e080e7          	jalr	1902(ra) # 940 <fork>
    if(pid < 0){
 1da:	42054563          	bltz	a0,604 <main+0x5ca>
      printf("FAILED: fork failed\n");
      exit(1);
    }
    if(pid == 0) {
 1de:	44050063          	beqz	a0,61e <main+0x5e4>
    pid = fork();
 1e2:	00000097          	auipc	ra,0x0
 1e6:	75e080e7          	jalr	1886(ra) # 940 <fork>
    if(pid < 0){
 1ea:	40054d63          	bltz	a0,604 <main+0x5ca>
    if(pid == 0) {
 1ee:	42050863          	beqz	a0,61e <main+0x5e4>
    }
  }

  int r;
  for(int j = 0; j < nchild; j++) {
    wait(&r);
 1f2:	f9840513          	addi	a0,s0,-104
 1f6:	00000097          	auipc	ra,0x0
 1fa:	75a080e7          	jalr	1882(ra) # 950 <wait>
    if(r != 0) {
 1fe:	f9842783          	lw	a5,-104(s0)
 202:	4a079b63          	bnez	a5,6b8 <main+0x67e>
    wait(&r);
 206:	f9840513          	addi	a0,s0,-104
 20a:	00000097          	auipc	ra,0x0
 20e:	746080e7          	jalr	1862(ra) # 950 <wait>
    if(r != 0) {
 212:	f9842783          	lw	a5,-104(s0)
 216:	4a079163          	bnez	a5,6b8 <main+0x67e>
      printf("test concurrent symlinks: failed\n");
      exit(1);
    }
  }
  printf("test concurrent symlinks: ok\n");
 21a:	00001517          	auipc	a0,0x1
 21e:	0ce50513          	addi	a0,a0,206 # 12e8 <malloc+0x562>
 222:	00001097          	auipc	ra,0x1
 226:	aa6080e7          	jalr	-1370(ra) # cc8 <printf>
  exit(failed);
 22a:	00001517          	auipc	a0,0x1
 22e:	0fe52503          	lw	a0,254(a0) # 1328 <failed>
 232:	00000097          	auipc	ra,0x0
 236:	716080e7          	jalr	1814(ra) # 948 <exit>
  if(fd1 < 0) fail("failed to open a");
 23a:	00001517          	auipc	a0,0x1
 23e:	cee50513          	addi	a0,a0,-786 # f28 <malloc+0x1a2>
 242:	00001097          	auipc	ra,0x1
 246:	a86080e7          	jalr	-1402(ra) # cc8 <printf>
 24a:	4785                	li	a5,1
 24c:	00001717          	auipc	a4,0x1
 250:	0cf72e23          	sw	a5,220(a4) # 1328 <failed>
  int r, fd1 = -1, fd2 = -1;
 254:	597d                	li	s2,-1
  if(fd1 < 0) fail("failed to open a");
 256:	bf25                	j	18e <main+0x154>
    fail("symlink b -> a failed");
 258:	00001517          	auipc	a0,0x1
 25c:	cf050513          	addi	a0,a0,-784 # f48 <malloc+0x1c2>
 260:	00001097          	auipc	ra,0x1
 264:	a68080e7          	jalr	-1432(ra) # cc8 <printf>
 268:	4785                	li	a5,1
 26a:	00001717          	auipc	a4,0x1
 26e:	0af72f23          	sw	a5,190(a4) # 1328 <failed>
  int r, fd1 = -1, fd2 = -1;
 272:	597d                	li	s2,-1
    fail("symlink b -> a failed");
 274:	bf29                	j	18e <main+0x154>
  if (stat_slink("/testsymlink/b", &st) != 0)
 276:	f9840593          	addi	a1,s0,-104
 27a:	00001517          	auipc	a0,0x1
 27e:	c0650513          	addi	a0,a0,-1018 # e80 <malloc+0xfa>
 282:	00000097          	auipc	ra,0x0
 286:	d7e080e7          	jalr	-642(ra) # 0 <stat_slink>
 28a:	e50d                	bnez	a0,2b4 <main+0x27a>
  if(st.type != T_SYMLINK)
 28c:	fa041703          	lh	a4,-96(s0)
 290:	4791                	li	a5,4
 292:	04f70063          	beq	a4,a5,2d2 <main+0x298>
    fail("b isn't a symlink");
 296:	00001517          	auipc	a0,0x1
 29a:	d1250513          	addi	a0,a0,-750 # fa8 <malloc+0x222>
 29e:	00001097          	auipc	ra,0x1
 2a2:	a2a080e7          	jalr	-1494(ra) # cc8 <printf>
 2a6:	4785                	li	a5,1
 2a8:	00001717          	auipc	a4,0x1
 2ac:	08f72023          	sw	a5,128(a4) # 1328 <failed>
  int r, fd1 = -1, fd2 = -1;
 2b0:	597d                	li	s2,-1
    fail("b isn't a symlink");
 2b2:	bdf1                	j	18e <main+0x154>
    fail("failed to stat b");
 2b4:	00001517          	auipc	a0,0x1
 2b8:	cd450513          	addi	a0,a0,-812 # f88 <malloc+0x202>
 2bc:	00001097          	auipc	ra,0x1
 2c0:	a0c080e7          	jalr	-1524(ra) # cc8 <printf>
 2c4:	4785                	li	a5,1
 2c6:	00001717          	auipc	a4,0x1
 2ca:	06f72123          	sw	a5,98(a4) # 1328 <failed>
  int r, fd1 = -1, fd2 = -1;
 2ce:	597d                	li	s2,-1
    fail("failed to stat b");
 2d0:	bd7d                	j	18e <main+0x154>
  fd2 = open("/testsymlink/b", O_RDWR);
 2d2:	4589                	li	a1,2
 2d4:	00001517          	auipc	a0,0x1
 2d8:	bac50513          	addi	a0,a0,-1108 # e80 <malloc+0xfa>
 2dc:	00000097          	auipc	ra,0x0
 2e0:	6ac080e7          	jalr	1708(ra) # 988 <open>
 2e4:	892a                	mv	s2,a0
  if(fd2 < 0)
 2e6:	02054d63          	bltz	a0,320 <main+0x2e6>
  read(fd2, &c, 1);
 2ea:	4605                	li	a2,1
 2ec:	f8e40593          	addi	a1,s0,-114
 2f0:	00000097          	auipc	ra,0x0
 2f4:	670080e7          	jalr	1648(ra) # 960 <read>
  if (c != 'a')
 2f8:	f8e44703          	lbu	a4,-114(s0)
 2fc:	06100793          	li	a5,97
 300:	02f70e63          	beq	a4,a5,33c <main+0x302>
    fail("failed to read bytes from b");
 304:	00001517          	auipc	a0,0x1
 308:	ce450513          	addi	a0,a0,-796 # fe8 <malloc+0x262>
 30c:	00001097          	auipc	ra,0x1
 310:	9bc080e7          	jalr	-1604(ra) # cc8 <printf>
 314:	4785                	li	a5,1
 316:	00001717          	auipc	a4,0x1
 31a:	00f72923          	sw	a5,18(a4) # 1328 <failed>
 31e:	bd85                	j	18e <main+0x154>
    fail("failed to open b");
 320:	00001517          	auipc	a0,0x1
 324:	ca850513          	addi	a0,a0,-856 # fc8 <malloc+0x242>
 328:	00001097          	auipc	ra,0x1
 32c:	9a0080e7          	jalr	-1632(ra) # cc8 <printf>
 330:	4785                	li	a5,1
 332:	00001717          	auipc	a4,0x1
 336:	fef72b23          	sw	a5,-10(a4) # 1328 <failed>
 33a:	bd91                	j	18e <main+0x154>
  unlink("/testsymlink/a");
 33c:	00001517          	auipc	a0,0x1
 340:	b3450513          	addi	a0,a0,-1228 # e70 <malloc+0xea>
 344:	00000097          	auipc	ra,0x0
 348:	654080e7          	jalr	1620(ra) # 998 <unlink>
  if(open("/testsymlink/b", O_RDWR) >= 0)
 34c:	4589                	li	a1,2
 34e:	00001517          	auipc	a0,0x1
 352:	b3250513          	addi	a0,a0,-1230 # e80 <malloc+0xfa>
 356:	00000097          	auipc	ra,0x0
 35a:	632080e7          	jalr	1586(ra) # 988 <open>
 35e:	12055263          	bgez	a0,482 <main+0x448>
  r = symlink("/testsymlink/b", "/testsymlink/a");
 362:	00001597          	auipc	a1,0x1
 366:	b0e58593          	addi	a1,a1,-1266 # e70 <malloc+0xea>
 36a:	00001517          	auipc	a0,0x1
 36e:	b1650513          	addi	a0,a0,-1258 # e80 <malloc+0xfa>
 372:	00000097          	auipc	ra,0x0
 376:	676080e7          	jalr	1654(ra) # 9e8 <symlink>
  if(r < 0)
 37a:	12054263          	bltz	a0,49e <main+0x464>
  r = open("/testsymlink/b", O_RDWR);
 37e:	4589                	li	a1,2
 380:	00001517          	auipc	a0,0x1
 384:	b0050513          	addi	a0,a0,-1280 # e80 <malloc+0xfa>
 388:	00000097          	auipc	ra,0x0
 38c:	600080e7          	jalr	1536(ra) # 988 <open>
  if(r >= 0)
 390:	12055563          	bgez	a0,4ba <main+0x480>
  r = symlink("/testsymlink/nonexistent", "/testsymlink/c");
 394:	00001597          	auipc	a1,0x1
 398:	afc58593          	addi	a1,a1,-1284 # e90 <malloc+0x10a>
 39c:	00001517          	auipc	a0,0x1
 3a0:	d0c50513          	addi	a0,a0,-756 # 10a8 <malloc+0x322>
 3a4:	00000097          	auipc	ra,0x0
 3a8:	644080e7          	jalr	1604(ra) # 9e8 <symlink>
  if(r != 0)
 3ac:	12051563          	bnez	a0,4d6 <main+0x49c>
  r = symlink("/testsymlink/2", "/testsymlink/1");
 3b0:	00001597          	auipc	a1,0x1
 3b4:	af058593          	addi	a1,a1,-1296 # ea0 <malloc+0x11a>
 3b8:	00001517          	auipc	a0,0x1
 3bc:	af850513          	addi	a0,a0,-1288 # eb0 <malloc+0x12a>
 3c0:	00000097          	auipc	ra,0x0
 3c4:	628080e7          	jalr	1576(ra) # 9e8 <symlink>
  if(r) fail("Failed to link 1->2");
 3c8:	12051563          	bnez	a0,4f2 <main+0x4b8>
  r = symlink("/testsymlink/3", "/testsymlink/2");
 3cc:	00001597          	auipc	a1,0x1
 3d0:	ae458593          	addi	a1,a1,-1308 # eb0 <malloc+0x12a>
 3d4:	00001517          	auipc	a0,0x1
 3d8:	aec50513          	addi	a0,a0,-1300 # ec0 <malloc+0x13a>
 3dc:	00000097          	auipc	ra,0x0
 3e0:	60c080e7          	jalr	1548(ra) # 9e8 <symlink>
  if(r) fail("Failed to link 2->3");
 3e4:	12051563          	bnez	a0,50e <main+0x4d4>
  r = symlink("/testsymlink/4", "/testsymlink/3");
 3e8:	00001597          	auipc	a1,0x1
 3ec:	ad858593          	addi	a1,a1,-1320 # ec0 <malloc+0x13a>
 3f0:	00001517          	auipc	a0,0x1
 3f4:	ae050513          	addi	a0,a0,-1312 # ed0 <malloc+0x14a>
 3f8:	00000097          	auipc	ra,0x0
 3fc:	5f0080e7          	jalr	1520(ra) # 9e8 <symlink>
  if(r) fail("Failed to link 3->4");
 400:	12051563          	bnez	a0,52a <main+0x4f0>
  close(fd1);
 404:	8526                	mv	a0,s1
 406:	00000097          	auipc	ra,0x0
 40a:	56a080e7          	jalr	1386(ra) # 970 <close>
  close(fd2);
 40e:	854a                	mv	a0,s2
 410:	00000097          	auipc	ra,0x0
 414:	560080e7          	jalr	1376(ra) # 970 <close>
  fd1 = open("/testsymlink/4", O_CREATE | O_RDWR);
 418:	20200593          	li	a1,514
 41c:	00001517          	auipc	a0,0x1
 420:	ab450513          	addi	a0,a0,-1356 # ed0 <malloc+0x14a>
 424:	00000097          	auipc	ra,0x0
 428:	564080e7          	jalr	1380(ra) # 988 <open>
 42c:	84aa                	mv	s1,a0
  if(fd1<0) fail("Failed to create 4\n");
 42e:	10054c63          	bltz	a0,546 <main+0x50c>
  fd2 = open("/testsymlink/1", O_RDWR);
 432:	4589                	li	a1,2
 434:	00001517          	auipc	a0,0x1
 438:	a6c50513          	addi	a0,a0,-1428 # ea0 <malloc+0x11a>
 43c:	00000097          	auipc	ra,0x0
 440:	54c080e7          	jalr	1356(ra) # 988 <open>
 444:	892a                	mv	s2,a0
  if(fd2<0) fail("Failed to open 1\n");
 446:	10054e63          	bltz	a0,562 <main+0x528>
  c = '#';
 44a:	02300793          	li	a5,35
 44e:	f8f40723          	sb	a5,-114(s0)
  r = write(fd2, &c, 1);
 452:	4605                	li	a2,1
 454:	f8e40593          	addi	a1,s0,-114
 458:	00000097          	auipc	ra,0x0
 45c:	510080e7          	jalr	1296(ra) # 968 <write>
  if(r!=1) fail("Failed to write to 1\n");
 460:	4785                	li	a5,1
 462:	10f50e63          	beq	a0,a5,57e <main+0x544>
 466:	00001517          	auipc	a0,0x1
 46a:	d4250513          	addi	a0,a0,-702 # 11a8 <malloc+0x422>
 46e:	00001097          	auipc	ra,0x1
 472:	85a080e7          	jalr	-1958(ra) # cc8 <printf>
 476:	4785                	li	a5,1
 478:	00001717          	auipc	a4,0x1
 47c:	eaf72823          	sw	a5,-336(a4) # 1328 <failed>
 480:	b339                	j	18e <main+0x154>
    fail("Should not be able to open b after deleting a");
 482:	00001517          	auipc	a0,0x1
 486:	b8e50513          	addi	a0,a0,-1138 # 1010 <malloc+0x28a>
 48a:	00001097          	auipc	ra,0x1
 48e:	83e080e7          	jalr	-1986(ra) # cc8 <printf>
 492:	4785                	li	a5,1
 494:	00001717          	auipc	a4,0x1
 498:	e8f72a23          	sw	a5,-364(a4) # 1328 <failed>
 49c:	b9cd                	j	18e <main+0x154>
    fail("symlink a -> b failed");
 49e:	00001517          	auipc	a0,0x1
 4a2:	baa50513          	addi	a0,a0,-1110 # 1048 <malloc+0x2c2>
 4a6:	00001097          	auipc	ra,0x1
 4aa:	822080e7          	jalr	-2014(ra) # cc8 <printf>
 4ae:	4785                	li	a5,1
 4b0:	00001717          	auipc	a4,0x1
 4b4:	e6f72c23          	sw	a5,-392(a4) # 1328 <failed>
 4b8:	b9d9                	j	18e <main+0x154>
    fail("Should not be able to open b (cycle b->a->b->..)\n");
 4ba:	00001517          	auipc	a0,0x1
 4be:	bae50513          	addi	a0,a0,-1106 # 1068 <malloc+0x2e2>
 4c2:	00001097          	auipc	ra,0x1
 4c6:	806080e7          	jalr	-2042(ra) # cc8 <printf>
 4ca:	4785                	li	a5,1
 4cc:	00001717          	auipc	a4,0x1
 4d0:	e4f72e23          	sw	a5,-420(a4) # 1328 <failed>
 4d4:	b96d                	j	18e <main+0x154>
    fail("Symlinking to nonexistent file should succeed\n");
 4d6:	00001517          	auipc	a0,0x1
 4da:	bf250513          	addi	a0,a0,-1038 # 10c8 <malloc+0x342>
 4de:	00000097          	auipc	ra,0x0
 4e2:	7ea080e7          	jalr	2026(ra) # cc8 <printf>
 4e6:	4785                	li	a5,1
 4e8:	00001717          	auipc	a4,0x1
 4ec:	e4f72023          	sw	a5,-448(a4) # 1328 <failed>
 4f0:	b979                	j	18e <main+0x154>
  if(r) fail("Failed to link 1->2");
 4f2:	00001517          	auipc	a0,0x1
 4f6:	c1650513          	addi	a0,a0,-1002 # 1108 <malloc+0x382>
 4fa:	00000097          	auipc	ra,0x0
 4fe:	7ce080e7          	jalr	1998(ra) # cc8 <printf>
 502:	4785                	li	a5,1
 504:	00001717          	auipc	a4,0x1
 508:	e2f72223          	sw	a5,-476(a4) # 1328 <failed>
 50c:	b149                	j	18e <main+0x154>
  if(r) fail("Failed to link 2->3");
 50e:	00001517          	auipc	a0,0x1
 512:	c1a50513          	addi	a0,a0,-998 # 1128 <malloc+0x3a2>
 516:	00000097          	auipc	ra,0x0
 51a:	7b2080e7          	jalr	1970(ra) # cc8 <printf>
 51e:	4785                	li	a5,1
 520:	00001717          	auipc	a4,0x1
 524:	e0f72423          	sw	a5,-504(a4) # 1328 <failed>
 528:	b19d                	j	18e <main+0x154>
  if(r) fail("Failed to link 3->4");
 52a:	00001517          	auipc	a0,0x1
 52e:	c1e50513          	addi	a0,a0,-994 # 1148 <malloc+0x3c2>
 532:	00000097          	auipc	ra,0x0
 536:	796080e7          	jalr	1942(ra) # cc8 <printf>
 53a:	4785                	li	a5,1
 53c:	00001717          	auipc	a4,0x1
 540:	def72623          	sw	a5,-532(a4) # 1328 <failed>
 544:	b1a9                	j	18e <main+0x154>
  if(fd1<0) fail("Failed to create 4\n");
 546:	00001517          	auipc	a0,0x1
 54a:	c2250513          	addi	a0,a0,-990 # 1168 <malloc+0x3e2>
 54e:	00000097          	auipc	ra,0x0
 552:	77a080e7          	jalr	1914(ra) # cc8 <printf>
 556:	4785                	li	a5,1
 558:	00001717          	auipc	a4,0x1
 55c:	dcf72823          	sw	a5,-560(a4) # 1328 <failed>
 560:	b13d                	j	18e <main+0x154>
  if(fd2<0) fail("Failed to open 1\n");
 562:	00001517          	auipc	a0,0x1
 566:	c2650513          	addi	a0,a0,-986 # 1188 <malloc+0x402>
 56a:	00000097          	auipc	ra,0x0
 56e:	75e080e7          	jalr	1886(ra) # cc8 <printf>
 572:	4785                	li	a5,1
 574:	00001717          	auipc	a4,0x1
 578:	daf72a23          	sw	a5,-588(a4) # 1328 <failed>
 57c:	b909                	j	18e <main+0x154>
  r = read(fd1, &c2, 1);
 57e:	4605                	li	a2,1
 580:	f8f40593          	addi	a1,s0,-113
 584:	8526                	mv	a0,s1
 586:	00000097          	auipc	ra,0x0
 58a:	3da080e7          	jalr	986(ra) # 960 <read>
  if(r!=1) fail("Failed to read from 4\n");
 58e:	4785                	li	a5,1
 590:	02f51663          	bne	a0,a5,5bc <main+0x582>
  if(c!=c2)
 594:	f8e44703          	lbu	a4,-114(s0)
 598:	f8f44783          	lbu	a5,-113(s0)
 59c:	02f70e63          	beq	a4,a5,5d8 <main+0x59e>
    fail("Value read from 4 differed from value written to 1\n");
 5a0:	00001517          	auipc	a0,0x1
 5a4:	c5050513          	addi	a0,a0,-944 # 11f0 <malloc+0x46a>
 5a8:	00000097          	auipc	ra,0x0
 5ac:	720080e7          	jalr	1824(ra) # cc8 <printf>
 5b0:	4785                	li	a5,1
 5b2:	00001717          	auipc	a4,0x1
 5b6:	d6f72b23          	sw	a5,-650(a4) # 1328 <failed>
 5ba:	bed1                	j	18e <main+0x154>
  if(r!=1) fail("Failed to read from 4\n");
 5bc:	00001517          	auipc	a0,0x1
 5c0:	c0c50513          	addi	a0,a0,-1012 # 11c8 <malloc+0x442>
 5c4:	00000097          	auipc	ra,0x0
 5c8:	704080e7          	jalr	1796(ra) # cc8 <printf>
 5cc:	4785                	li	a5,1
 5ce:	00001717          	auipc	a4,0x1
 5d2:	d4f72d23          	sw	a5,-678(a4) # 1328 <failed>
 5d6:	be65                	j	18e <main+0x154>
  printf("test symlinks: ok\n");
 5d8:	00001517          	auipc	a0,0x1
 5dc:	c5850513          	addi	a0,a0,-936 # 1230 <malloc+0x4aa>
 5e0:	00000097          	auipc	ra,0x0
 5e4:	6e8080e7          	jalr	1768(ra) # cc8 <printf>
 5e8:	b65d                	j	18e <main+0x154>
    printf("FAILED: open failed");
 5ea:	00001517          	auipc	a0,0x1
 5ee:	c8650513          	addi	a0,a0,-890 # 1270 <malloc+0x4ea>
 5f2:	00000097          	auipc	ra,0x0
 5f6:	6d6080e7          	jalr	1750(ra) # cc8 <printf>
    exit(1);
 5fa:	4505                	li	a0,1
 5fc:	00000097          	auipc	ra,0x0
 600:	34c080e7          	jalr	844(ra) # 948 <exit>
      printf("FAILED: fork failed\n");
 604:	00001517          	auipc	a0,0x1
 608:	c8450513          	addi	a0,a0,-892 # 1288 <malloc+0x502>
 60c:	00000097          	auipc	ra,0x0
 610:	6bc080e7          	jalr	1724(ra) # cc8 <printf>
      exit(1);
 614:	4505                	li	a0,1
 616:	00000097          	auipc	ra,0x0
 61a:	332080e7          	jalr	818(ra) # 948 <exit>
  int r, fd1 = -1, fd2 = -1;
 61e:	06400913          	li	s2,100
      unsigned int x = (pid ? 1 : 97);
 622:	06100c13          	li	s8,97
        x = x * 1103515245 + 12345;
 626:	41c65a37          	lui	s4,0x41c65
 62a:	e6da0a1b          	addiw	s4,s4,-403
 62e:	698d                	lui	s3,0x3
 630:	0399899b          	addiw	s3,s3,57
        if((x % 3) == 0) {
 634:	4b8d                	li	s7,3
          unlink("/testsymlink/y");
 636:	00001497          	auipc	s1,0x1
 63a:	8ba48493          	addi	s1,s1,-1862 # ef0 <malloc+0x16a>
          symlink("/testsymlink/z", "/testsymlink/y");
 63e:	00001b17          	auipc	s6,0x1
 642:	8a2b0b13          	addi	s6,s6,-1886 # ee0 <malloc+0x15a>
            if(st.type != T_SYMLINK) {
 646:	4a91                	li	s5,4
 648:	a809                	j	65a <main+0x620>
          unlink("/testsymlink/y");
 64a:	8526                	mv	a0,s1
 64c:	00000097          	auipc	ra,0x0
 650:	34c080e7          	jalr	844(ra) # 998 <unlink>
      for(i = 0; i < 100; i++){
 654:	397d                	addiw	s2,s2,-1
 656:	04090c63          	beqz	s2,6ae <main+0x674>
        x = x * 1103515245 + 12345;
 65a:	034c07bb          	mulw	a5,s8,s4
 65e:	013787bb          	addw	a5,a5,s3
 662:	00078c1b          	sext.w	s8,a5
        if((x % 3) == 0) {
 666:	0377f7bb          	remuw	a5,a5,s7
 66a:	f3e5                	bnez	a5,64a <main+0x610>
          symlink("/testsymlink/z", "/testsymlink/y");
 66c:	85a6                	mv	a1,s1
 66e:	855a                	mv	a0,s6
 670:	00000097          	auipc	ra,0x0
 674:	378080e7          	jalr	888(ra) # 9e8 <symlink>
          if (stat_slink("/testsymlink/y", &st) == 0) {
 678:	f9840593          	addi	a1,s0,-104
 67c:	8526                	mv	a0,s1
 67e:	00000097          	auipc	ra,0x0
 682:	982080e7          	jalr	-1662(ra) # 0 <stat_slink>
 686:	f579                	bnez	a0,654 <main+0x61a>
            if(st.type != T_SYMLINK) {
 688:	fa041583          	lh	a1,-96(s0)
 68c:	0005879b          	sext.w	a5,a1
 690:	fd5782e3          	beq	a5,s5,654 <main+0x61a>
              printf("FAILED: not a symbolic link\n", st.type);
 694:	00001517          	auipc	a0,0x1
 698:	c0c50513          	addi	a0,a0,-1012 # 12a0 <malloc+0x51a>
 69c:	00000097          	auipc	ra,0x0
 6a0:	62c080e7          	jalr	1580(ra) # cc8 <printf>
              exit(1);
 6a4:	4505                	li	a0,1
 6a6:	00000097          	auipc	ra,0x0
 6aa:	2a2080e7          	jalr	674(ra) # 948 <exit>
      exit(0);
 6ae:	4501                	li	a0,0
 6b0:	00000097          	auipc	ra,0x0
 6b4:	298080e7          	jalr	664(ra) # 948 <exit>
      printf("test concurrent symlinks: failed\n");
 6b8:	00001517          	auipc	a0,0x1
 6bc:	c0850513          	addi	a0,a0,-1016 # 12c0 <malloc+0x53a>
 6c0:	00000097          	auipc	ra,0x0
 6c4:	608080e7          	jalr	1544(ra) # cc8 <printf>
      exit(1);
 6c8:	4505                	li	a0,1
 6ca:	00000097          	auipc	ra,0x0
 6ce:	27e080e7          	jalr	638(ra) # 948 <exit>

00000000000006d2 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 6d2:	1141                	addi	sp,sp,-16
 6d4:	e422                	sd	s0,8(sp)
 6d6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 6d8:	87aa                	mv	a5,a0
 6da:	0585                	addi	a1,a1,1
 6dc:	0785                	addi	a5,a5,1
 6de:	fff5c703          	lbu	a4,-1(a1)
 6e2:	fee78fa3          	sb	a4,-1(a5) # 64635fff <__global_pointer$+0x646344de>
 6e6:	fb75                	bnez	a4,6da <strcpy+0x8>
    ;
  return os;
}
 6e8:	6422                	ld	s0,8(sp)
 6ea:	0141                	addi	sp,sp,16
 6ec:	8082                	ret

00000000000006ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
 6ee:	1141                	addi	sp,sp,-16
 6f0:	e422                	sd	s0,8(sp)
 6f2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 6f4:	00054783          	lbu	a5,0(a0)
 6f8:	cb91                	beqz	a5,70c <strcmp+0x1e>
 6fa:	0005c703          	lbu	a4,0(a1)
 6fe:	00f71763          	bne	a4,a5,70c <strcmp+0x1e>
    p++, q++;
 702:	0505                	addi	a0,a0,1
 704:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 706:	00054783          	lbu	a5,0(a0)
 70a:	fbe5                	bnez	a5,6fa <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 70c:	0005c503          	lbu	a0,0(a1)
}
 710:	40a7853b          	subw	a0,a5,a0
 714:	6422                	ld	s0,8(sp)
 716:	0141                	addi	sp,sp,16
 718:	8082                	ret

000000000000071a <strlen>:

uint
strlen(const char *s)
{
 71a:	1141                	addi	sp,sp,-16
 71c:	e422                	sd	s0,8(sp)
 71e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 720:	00054783          	lbu	a5,0(a0)
 724:	cf91                	beqz	a5,740 <strlen+0x26>
 726:	0505                	addi	a0,a0,1
 728:	87aa                	mv	a5,a0
 72a:	4685                	li	a3,1
 72c:	9e89                	subw	a3,a3,a0
 72e:	00f6853b          	addw	a0,a3,a5
 732:	0785                	addi	a5,a5,1
 734:	fff7c703          	lbu	a4,-1(a5)
 738:	fb7d                	bnez	a4,72e <strlen+0x14>
    ;
  return n;
}
 73a:	6422                	ld	s0,8(sp)
 73c:	0141                	addi	sp,sp,16
 73e:	8082                	ret
  for(n = 0; s[n]; n++)
 740:	4501                	li	a0,0
 742:	bfe5                	j	73a <strlen+0x20>

0000000000000744 <memset>:

void*
memset(void *dst, int c, uint n)
{
 744:	1141                	addi	sp,sp,-16
 746:	e422                	sd	s0,8(sp)
 748:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 74a:	ce09                	beqz	a2,764 <memset+0x20>
 74c:	87aa                	mv	a5,a0
 74e:	fff6071b          	addiw	a4,a2,-1
 752:	1702                	slli	a4,a4,0x20
 754:	9301                	srli	a4,a4,0x20
 756:	0705                	addi	a4,a4,1
 758:	972a                	add	a4,a4,a0
    cdst[i] = c;
 75a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 75e:	0785                	addi	a5,a5,1
 760:	fee79de3          	bne	a5,a4,75a <memset+0x16>
  }
  return dst;
}
 764:	6422                	ld	s0,8(sp)
 766:	0141                	addi	sp,sp,16
 768:	8082                	ret

000000000000076a <strchr>:

char*
strchr(const char *s, char c)
{
 76a:	1141                	addi	sp,sp,-16
 76c:	e422                	sd	s0,8(sp)
 76e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 770:	00054783          	lbu	a5,0(a0)
 774:	cb99                	beqz	a5,78a <strchr+0x20>
    if(*s == c)
 776:	00f58763          	beq	a1,a5,784 <strchr+0x1a>
  for(; *s; s++)
 77a:	0505                	addi	a0,a0,1
 77c:	00054783          	lbu	a5,0(a0)
 780:	fbfd                	bnez	a5,776 <strchr+0xc>
      return (char*)s;
  return 0;
 782:	4501                	li	a0,0
}
 784:	6422                	ld	s0,8(sp)
 786:	0141                	addi	sp,sp,16
 788:	8082                	ret
  return 0;
 78a:	4501                	li	a0,0
 78c:	bfe5                	j	784 <strchr+0x1a>

000000000000078e <gets>:

char*
gets(char *buf, int max)
{
 78e:	711d                	addi	sp,sp,-96
 790:	ec86                	sd	ra,88(sp)
 792:	e8a2                	sd	s0,80(sp)
 794:	e4a6                	sd	s1,72(sp)
 796:	e0ca                	sd	s2,64(sp)
 798:	fc4e                	sd	s3,56(sp)
 79a:	f852                	sd	s4,48(sp)
 79c:	f456                	sd	s5,40(sp)
 79e:	f05a                	sd	s6,32(sp)
 7a0:	ec5e                	sd	s7,24(sp)
 7a2:	1080                	addi	s0,sp,96
 7a4:	8baa                	mv	s7,a0
 7a6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7a8:	892a                	mv	s2,a0
 7aa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 7ac:	4aa9                	li	s5,10
 7ae:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 7b0:	89a6                	mv	s3,s1
 7b2:	2485                	addiw	s1,s1,1
 7b4:	0344d863          	bge	s1,s4,7e4 <gets+0x56>
    cc = read(0, &c, 1);
 7b8:	4605                	li	a2,1
 7ba:	faf40593          	addi	a1,s0,-81
 7be:	4501                	li	a0,0
 7c0:	00000097          	auipc	ra,0x0
 7c4:	1a0080e7          	jalr	416(ra) # 960 <read>
    if(cc < 1)
 7c8:	00a05e63          	blez	a0,7e4 <gets+0x56>
    buf[i++] = c;
 7cc:	faf44783          	lbu	a5,-81(s0)
 7d0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 7d4:	01578763          	beq	a5,s5,7e2 <gets+0x54>
 7d8:	0905                	addi	s2,s2,1
 7da:	fd679be3          	bne	a5,s6,7b0 <gets+0x22>
  for(i=0; i+1 < max; ){
 7de:	89a6                	mv	s3,s1
 7e0:	a011                	j	7e4 <gets+0x56>
 7e2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 7e4:	99de                	add	s3,s3,s7
 7e6:	00098023          	sb	zero,0(s3) # 3000 <__global_pointer$+0x14df>
  return buf;
}
 7ea:	855e                	mv	a0,s7
 7ec:	60e6                	ld	ra,88(sp)
 7ee:	6446                	ld	s0,80(sp)
 7f0:	64a6                	ld	s1,72(sp)
 7f2:	6906                	ld	s2,64(sp)
 7f4:	79e2                	ld	s3,56(sp)
 7f6:	7a42                	ld	s4,48(sp)
 7f8:	7aa2                	ld	s5,40(sp)
 7fa:	7b02                	ld	s6,32(sp)
 7fc:	6be2                	ld	s7,24(sp)
 7fe:	6125                	addi	sp,sp,96
 800:	8082                	ret

0000000000000802 <stat>:

int
stat(const char *n, struct stat *st)
{
 802:	1101                	addi	sp,sp,-32
 804:	ec06                	sd	ra,24(sp)
 806:	e822                	sd	s0,16(sp)
 808:	e426                	sd	s1,8(sp)
 80a:	e04a                	sd	s2,0(sp)
 80c:	1000                	addi	s0,sp,32
 80e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 810:	4581                	li	a1,0
 812:	00000097          	auipc	ra,0x0
 816:	176080e7          	jalr	374(ra) # 988 <open>
  if(fd < 0)
 81a:	02054563          	bltz	a0,844 <stat+0x42>
 81e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 820:	85ca                	mv	a1,s2
 822:	00000097          	auipc	ra,0x0
 826:	17e080e7          	jalr	382(ra) # 9a0 <fstat>
 82a:	892a                	mv	s2,a0
  close(fd);
 82c:	8526                	mv	a0,s1
 82e:	00000097          	auipc	ra,0x0
 832:	142080e7          	jalr	322(ra) # 970 <close>
  return r;
}
 836:	854a                	mv	a0,s2
 838:	60e2                	ld	ra,24(sp)
 83a:	6442                	ld	s0,16(sp)
 83c:	64a2                	ld	s1,8(sp)
 83e:	6902                	ld	s2,0(sp)
 840:	6105                	addi	sp,sp,32
 842:	8082                	ret
    return -1;
 844:	597d                	li	s2,-1
 846:	bfc5                	j	836 <stat+0x34>

0000000000000848 <atoi>:

int
atoi(const char *s)
{
 848:	1141                	addi	sp,sp,-16
 84a:	e422                	sd	s0,8(sp)
 84c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 84e:	00054603          	lbu	a2,0(a0)
 852:	fd06079b          	addiw	a5,a2,-48
 856:	0ff7f793          	andi	a5,a5,255
 85a:	4725                	li	a4,9
 85c:	02f76963          	bltu	a4,a5,88e <atoi+0x46>
 860:	86aa                	mv	a3,a0
  n = 0;
 862:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 864:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 866:	0685                	addi	a3,a3,1
 868:	0025179b          	slliw	a5,a0,0x2
 86c:	9fa9                	addw	a5,a5,a0
 86e:	0017979b          	slliw	a5,a5,0x1
 872:	9fb1                	addw	a5,a5,a2
 874:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 878:	0006c603          	lbu	a2,0(a3)
 87c:	fd06071b          	addiw	a4,a2,-48
 880:	0ff77713          	andi	a4,a4,255
 884:	fee5f1e3          	bgeu	a1,a4,866 <atoi+0x1e>
  return n;
}
 888:	6422                	ld	s0,8(sp)
 88a:	0141                	addi	sp,sp,16
 88c:	8082                	ret
  n = 0;
 88e:	4501                	li	a0,0
 890:	bfe5                	j	888 <atoi+0x40>

0000000000000892 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 892:	1141                	addi	sp,sp,-16
 894:	e422                	sd	s0,8(sp)
 896:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 898:	02b57663          	bgeu	a0,a1,8c4 <memmove+0x32>
    while(n-- > 0)
 89c:	02c05163          	blez	a2,8be <memmove+0x2c>
 8a0:	fff6079b          	addiw	a5,a2,-1
 8a4:	1782                	slli	a5,a5,0x20
 8a6:	9381                	srli	a5,a5,0x20
 8a8:	0785                	addi	a5,a5,1
 8aa:	97aa                	add	a5,a5,a0
  dst = vdst;
 8ac:	872a                	mv	a4,a0
      *dst++ = *src++;
 8ae:	0585                	addi	a1,a1,1
 8b0:	0705                	addi	a4,a4,1
 8b2:	fff5c683          	lbu	a3,-1(a1)
 8b6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 8ba:	fee79ae3          	bne	a5,a4,8ae <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 8be:	6422                	ld	s0,8(sp)
 8c0:	0141                	addi	sp,sp,16
 8c2:	8082                	ret
    dst += n;
 8c4:	00c50733          	add	a4,a0,a2
    src += n;
 8c8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 8ca:	fec05ae3          	blez	a2,8be <memmove+0x2c>
 8ce:	fff6079b          	addiw	a5,a2,-1
 8d2:	1782                	slli	a5,a5,0x20
 8d4:	9381                	srli	a5,a5,0x20
 8d6:	fff7c793          	not	a5,a5
 8da:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 8dc:	15fd                	addi	a1,a1,-1
 8de:	177d                	addi	a4,a4,-1
 8e0:	0005c683          	lbu	a3,0(a1)
 8e4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 8e8:	fee79ae3          	bne	a5,a4,8dc <memmove+0x4a>
 8ec:	bfc9                	j	8be <memmove+0x2c>

00000000000008ee <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 8ee:	1141                	addi	sp,sp,-16
 8f0:	e422                	sd	s0,8(sp)
 8f2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 8f4:	ca05                	beqz	a2,924 <memcmp+0x36>
 8f6:	fff6069b          	addiw	a3,a2,-1
 8fa:	1682                	slli	a3,a3,0x20
 8fc:	9281                	srli	a3,a3,0x20
 8fe:	0685                	addi	a3,a3,1
 900:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 902:	00054783          	lbu	a5,0(a0)
 906:	0005c703          	lbu	a4,0(a1)
 90a:	00e79863          	bne	a5,a4,91a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 90e:	0505                	addi	a0,a0,1
    p2++;
 910:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 912:	fed518e3          	bne	a0,a3,902 <memcmp+0x14>
  }
  return 0;
 916:	4501                	li	a0,0
 918:	a019                	j	91e <memcmp+0x30>
      return *p1 - *p2;
 91a:	40e7853b          	subw	a0,a5,a4
}
 91e:	6422                	ld	s0,8(sp)
 920:	0141                	addi	sp,sp,16
 922:	8082                	ret
  return 0;
 924:	4501                	li	a0,0
 926:	bfe5                	j	91e <memcmp+0x30>

0000000000000928 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 928:	1141                	addi	sp,sp,-16
 92a:	e406                	sd	ra,8(sp)
 92c:	e022                	sd	s0,0(sp)
 92e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 930:	00000097          	auipc	ra,0x0
 934:	f62080e7          	jalr	-158(ra) # 892 <memmove>
}
 938:	60a2                	ld	ra,8(sp)
 93a:	6402                	ld	s0,0(sp)
 93c:	0141                	addi	sp,sp,16
 93e:	8082                	ret

0000000000000940 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 940:	4885                	li	a7,1
 ecall
 942:	00000073          	ecall
 ret
 946:	8082                	ret

0000000000000948 <exit>:
.global exit
exit:
 li a7, SYS_exit
 948:	4889                	li	a7,2
 ecall
 94a:	00000073          	ecall
 ret
 94e:	8082                	ret

0000000000000950 <wait>:
.global wait
wait:
 li a7, SYS_wait
 950:	488d                	li	a7,3
 ecall
 952:	00000073          	ecall
 ret
 956:	8082                	ret

0000000000000958 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 958:	4891                	li	a7,4
 ecall
 95a:	00000073          	ecall
 ret
 95e:	8082                	ret

0000000000000960 <read>:
.global read
read:
 li a7, SYS_read
 960:	4895                	li	a7,5
 ecall
 962:	00000073          	ecall
 ret
 966:	8082                	ret

0000000000000968 <write>:
.global write
write:
 li a7, SYS_write
 968:	48c1                	li	a7,16
 ecall
 96a:	00000073          	ecall
 ret
 96e:	8082                	ret

0000000000000970 <close>:
.global close
close:
 li a7, SYS_close
 970:	48d5                	li	a7,21
 ecall
 972:	00000073          	ecall
 ret
 976:	8082                	ret

0000000000000978 <kill>:
.global kill
kill:
 li a7, SYS_kill
 978:	4899                	li	a7,6
 ecall
 97a:	00000073          	ecall
 ret
 97e:	8082                	ret

0000000000000980 <exec>:
.global exec
exec:
 li a7, SYS_exec
 980:	489d                	li	a7,7
 ecall
 982:	00000073          	ecall
 ret
 986:	8082                	ret

0000000000000988 <open>:
.global open
open:
 li a7, SYS_open
 988:	48bd                	li	a7,15
 ecall
 98a:	00000073          	ecall
 ret
 98e:	8082                	ret

0000000000000990 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 990:	48c5                	li	a7,17
 ecall
 992:	00000073          	ecall
 ret
 996:	8082                	ret

0000000000000998 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 998:	48c9                	li	a7,18
 ecall
 99a:	00000073          	ecall
 ret
 99e:	8082                	ret

00000000000009a0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 9a0:	48a1                	li	a7,8
 ecall
 9a2:	00000073          	ecall
 ret
 9a6:	8082                	ret

00000000000009a8 <link>:
.global link
link:
 li a7, SYS_link
 9a8:	48cd                	li	a7,19
 ecall
 9aa:	00000073          	ecall
 ret
 9ae:	8082                	ret

00000000000009b0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 9b0:	48d1                	li	a7,20
 ecall
 9b2:	00000073          	ecall
 ret
 9b6:	8082                	ret

00000000000009b8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 9b8:	48a5                	li	a7,9
 ecall
 9ba:	00000073          	ecall
 ret
 9be:	8082                	ret

00000000000009c0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 9c0:	48a9                	li	a7,10
 ecall
 9c2:	00000073          	ecall
 ret
 9c6:	8082                	ret

00000000000009c8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 9c8:	48ad                	li	a7,11
 ecall
 9ca:	00000073          	ecall
 ret
 9ce:	8082                	ret

00000000000009d0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 9d0:	48b1                	li	a7,12
 ecall
 9d2:	00000073          	ecall
 ret
 9d6:	8082                	ret

00000000000009d8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 9d8:	48b5                	li	a7,13
 ecall
 9da:	00000073          	ecall
 ret
 9de:	8082                	ret

00000000000009e0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 9e0:	48b9                	li	a7,14
 ecall
 9e2:	00000073          	ecall
 ret
 9e6:	8082                	ret

00000000000009e8 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 9e8:	48d9                	li	a7,22
 ecall
 9ea:	00000073          	ecall
 ret
 9ee:	8082                	ret

00000000000009f0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 9f0:	1101                	addi	sp,sp,-32
 9f2:	ec06                	sd	ra,24(sp)
 9f4:	e822                	sd	s0,16(sp)
 9f6:	1000                	addi	s0,sp,32
 9f8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 9fc:	4605                	li	a2,1
 9fe:	fef40593          	addi	a1,s0,-17
 a02:	00000097          	auipc	ra,0x0
 a06:	f66080e7          	jalr	-154(ra) # 968 <write>
}
 a0a:	60e2                	ld	ra,24(sp)
 a0c:	6442                	ld	s0,16(sp)
 a0e:	6105                	addi	sp,sp,32
 a10:	8082                	ret

0000000000000a12 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a12:	7139                	addi	sp,sp,-64
 a14:	fc06                	sd	ra,56(sp)
 a16:	f822                	sd	s0,48(sp)
 a18:	f426                	sd	s1,40(sp)
 a1a:	f04a                	sd	s2,32(sp)
 a1c:	ec4e                	sd	s3,24(sp)
 a1e:	0080                	addi	s0,sp,64
 a20:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 a22:	c299                	beqz	a3,a28 <printint+0x16>
 a24:	0805c863          	bltz	a1,ab4 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 a28:	2581                	sext.w	a1,a1
  neg = 0;
 a2a:	4881                	li	a7,0
 a2c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 a30:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 a32:	2601                	sext.w	a2,a2
 a34:	00001517          	auipc	a0,0x1
 a38:	8dc50513          	addi	a0,a0,-1828 # 1310 <digits>
 a3c:	883a                	mv	a6,a4
 a3e:	2705                	addiw	a4,a4,1
 a40:	02c5f7bb          	remuw	a5,a1,a2
 a44:	1782                	slli	a5,a5,0x20
 a46:	9381                	srli	a5,a5,0x20
 a48:	97aa                	add	a5,a5,a0
 a4a:	0007c783          	lbu	a5,0(a5)
 a4e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 a52:	0005879b          	sext.w	a5,a1
 a56:	02c5d5bb          	divuw	a1,a1,a2
 a5a:	0685                	addi	a3,a3,1
 a5c:	fec7f0e3          	bgeu	a5,a2,a3c <printint+0x2a>
  if(neg)
 a60:	00088b63          	beqz	a7,a76 <printint+0x64>
    buf[i++] = '-';
 a64:	fd040793          	addi	a5,s0,-48
 a68:	973e                	add	a4,a4,a5
 a6a:	02d00793          	li	a5,45
 a6e:	fef70823          	sb	a5,-16(a4)
 a72:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 a76:	02e05863          	blez	a4,aa6 <printint+0x94>
 a7a:	fc040793          	addi	a5,s0,-64
 a7e:	00e78933          	add	s2,a5,a4
 a82:	fff78993          	addi	s3,a5,-1
 a86:	99ba                	add	s3,s3,a4
 a88:	377d                	addiw	a4,a4,-1
 a8a:	1702                	slli	a4,a4,0x20
 a8c:	9301                	srli	a4,a4,0x20
 a8e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 a92:	fff94583          	lbu	a1,-1(s2)
 a96:	8526                	mv	a0,s1
 a98:	00000097          	auipc	ra,0x0
 a9c:	f58080e7          	jalr	-168(ra) # 9f0 <putc>
  while(--i >= 0)
 aa0:	197d                	addi	s2,s2,-1
 aa2:	ff3918e3          	bne	s2,s3,a92 <printint+0x80>
}
 aa6:	70e2                	ld	ra,56(sp)
 aa8:	7442                	ld	s0,48(sp)
 aaa:	74a2                	ld	s1,40(sp)
 aac:	7902                	ld	s2,32(sp)
 aae:	69e2                	ld	s3,24(sp)
 ab0:	6121                	addi	sp,sp,64
 ab2:	8082                	ret
    x = -xx;
 ab4:	40b005bb          	negw	a1,a1
    neg = 1;
 ab8:	4885                	li	a7,1
    x = -xx;
 aba:	bf8d                	j	a2c <printint+0x1a>

0000000000000abc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 abc:	7119                	addi	sp,sp,-128
 abe:	fc86                	sd	ra,120(sp)
 ac0:	f8a2                	sd	s0,112(sp)
 ac2:	f4a6                	sd	s1,104(sp)
 ac4:	f0ca                	sd	s2,96(sp)
 ac6:	ecce                	sd	s3,88(sp)
 ac8:	e8d2                	sd	s4,80(sp)
 aca:	e4d6                	sd	s5,72(sp)
 acc:	e0da                	sd	s6,64(sp)
 ace:	fc5e                	sd	s7,56(sp)
 ad0:	f862                	sd	s8,48(sp)
 ad2:	f466                	sd	s9,40(sp)
 ad4:	f06a                	sd	s10,32(sp)
 ad6:	ec6e                	sd	s11,24(sp)
 ad8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 ada:	0005c903          	lbu	s2,0(a1)
 ade:	18090f63          	beqz	s2,c7c <vprintf+0x1c0>
 ae2:	8aaa                	mv	s5,a0
 ae4:	8b32                	mv	s6,a2
 ae6:	00158493          	addi	s1,a1,1
  state = 0;
 aea:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 aec:	02500a13          	li	s4,37
      if(c == 'd'){
 af0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 af4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 af8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 afc:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b00:	00001b97          	auipc	s7,0x1
 b04:	810b8b93          	addi	s7,s7,-2032 # 1310 <digits>
 b08:	a839                	j	b26 <vprintf+0x6a>
        putc(fd, c);
 b0a:	85ca                	mv	a1,s2
 b0c:	8556                	mv	a0,s5
 b0e:	00000097          	auipc	ra,0x0
 b12:	ee2080e7          	jalr	-286(ra) # 9f0 <putc>
 b16:	a019                	j	b1c <vprintf+0x60>
    } else if(state == '%'){
 b18:	01498f63          	beq	s3,s4,b36 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 b1c:	0485                	addi	s1,s1,1
 b1e:	fff4c903          	lbu	s2,-1(s1)
 b22:	14090d63          	beqz	s2,c7c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 b26:	0009079b          	sext.w	a5,s2
    if(state == 0){
 b2a:	fe0997e3          	bnez	s3,b18 <vprintf+0x5c>
      if(c == '%'){
 b2e:	fd479ee3          	bne	a5,s4,b0a <vprintf+0x4e>
        state = '%';
 b32:	89be                	mv	s3,a5
 b34:	b7e5                	j	b1c <vprintf+0x60>
      if(c == 'd'){
 b36:	05878063          	beq	a5,s8,b76 <vprintf+0xba>
      } else if(c == 'l') {
 b3a:	05978c63          	beq	a5,s9,b92 <vprintf+0xd6>
      } else if(c == 'x') {
 b3e:	07a78863          	beq	a5,s10,bae <vprintf+0xf2>
      } else if(c == 'p') {
 b42:	09b78463          	beq	a5,s11,bca <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 b46:	07300713          	li	a4,115
 b4a:	0ce78663          	beq	a5,a4,c16 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b4e:	06300713          	li	a4,99
 b52:	0ee78e63          	beq	a5,a4,c4e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 b56:	11478863          	beq	a5,s4,c66 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b5a:	85d2                	mv	a1,s4
 b5c:	8556                	mv	a0,s5
 b5e:	00000097          	auipc	ra,0x0
 b62:	e92080e7          	jalr	-366(ra) # 9f0 <putc>
        putc(fd, c);
 b66:	85ca                	mv	a1,s2
 b68:	8556                	mv	a0,s5
 b6a:	00000097          	auipc	ra,0x0
 b6e:	e86080e7          	jalr	-378(ra) # 9f0 <putc>
      }
      state = 0;
 b72:	4981                	li	s3,0
 b74:	b765                	j	b1c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 b76:	008b0913          	addi	s2,s6,8
 b7a:	4685                	li	a3,1
 b7c:	4629                	li	a2,10
 b7e:	000b2583          	lw	a1,0(s6)
 b82:	8556                	mv	a0,s5
 b84:	00000097          	auipc	ra,0x0
 b88:	e8e080e7          	jalr	-370(ra) # a12 <printint>
 b8c:	8b4a                	mv	s6,s2
      state = 0;
 b8e:	4981                	li	s3,0
 b90:	b771                	j	b1c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b92:	008b0913          	addi	s2,s6,8
 b96:	4681                	li	a3,0
 b98:	4629                	li	a2,10
 b9a:	000b2583          	lw	a1,0(s6)
 b9e:	8556                	mv	a0,s5
 ba0:	00000097          	auipc	ra,0x0
 ba4:	e72080e7          	jalr	-398(ra) # a12 <printint>
 ba8:	8b4a                	mv	s6,s2
      state = 0;
 baa:	4981                	li	s3,0
 bac:	bf85                	j	b1c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 bae:	008b0913          	addi	s2,s6,8
 bb2:	4681                	li	a3,0
 bb4:	4641                	li	a2,16
 bb6:	000b2583          	lw	a1,0(s6)
 bba:	8556                	mv	a0,s5
 bbc:	00000097          	auipc	ra,0x0
 bc0:	e56080e7          	jalr	-426(ra) # a12 <printint>
 bc4:	8b4a                	mv	s6,s2
      state = 0;
 bc6:	4981                	li	s3,0
 bc8:	bf91                	j	b1c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 bca:	008b0793          	addi	a5,s6,8
 bce:	f8f43423          	sd	a5,-120(s0)
 bd2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 bd6:	03000593          	li	a1,48
 bda:	8556                	mv	a0,s5
 bdc:	00000097          	auipc	ra,0x0
 be0:	e14080e7          	jalr	-492(ra) # 9f0 <putc>
  putc(fd, 'x');
 be4:	85ea                	mv	a1,s10
 be6:	8556                	mv	a0,s5
 be8:	00000097          	auipc	ra,0x0
 bec:	e08080e7          	jalr	-504(ra) # 9f0 <putc>
 bf0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 bf2:	03c9d793          	srli	a5,s3,0x3c
 bf6:	97de                	add	a5,a5,s7
 bf8:	0007c583          	lbu	a1,0(a5)
 bfc:	8556                	mv	a0,s5
 bfe:	00000097          	auipc	ra,0x0
 c02:	df2080e7          	jalr	-526(ra) # 9f0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 c06:	0992                	slli	s3,s3,0x4
 c08:	397d                	addiw	s2,s2,-1
 c0a:	fe0914e3          	bnez	s2,bf2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 c0e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 c12:	4981                	li	s3,0
 c14:	b721                	j	b1c <vprintf+0x60>
        s = va_arg(ap, char*);
 c16:	008b0993          	addi	s3,s6,8
 c1a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 c1e:	02090163          	beqz	s2,c40 <vprintf+0x184>
        while(*s != 0){
 c22:	00094583          	lbu	a1,0(s2)
 c26:	c9a1                	beqz	a1,c76 <vprintf+0x1ba>
          putc(fd, *s);
 c28:	8556                	mv	a0,s5
 c2a:	00000097          	auipc	ra,0x0
 c2e:	dc6080e7          	jalr	-570(ra) # 9f0 <putc>
          s++;
 c32:	0905                	addi	s2,s2,1
        while(*s != 0){
 c34:	00094583          	lbu	a1,0(s2)
 c38:	f9e5                	bnez	a1,c28 <vprintf+0x16c>
        s = va_arg(ap, char*);
 c3a:	8b4e                	mv	s6,s3
      state = 0;
 c3c:	4981                	li	s3,0
 c3e:	bdf9                	j	b1c <vprintf+0x60>
          s = "(null)";
 c40:	00000917          	auipc	s2,0x0
 c44:	6c890913          	addi	s2,s2,1736 # 1308 <malloc+0x582>
        while(*s != 0){
 c48:	02800593          	li	a1,40
 c4c:	bff1                	j	c28 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 c4e:	008b0913          	addi	s2,s6,8
 c52:	000b4583          	lbu	a1,0(s6)
 c56:	8556                	mv	a0,s5
 c58:	00000097          	auipc	ra,0x0
 c5c:	d98080e7          	jalr	-616(ra) # 9f0 <putc>
 c60:	8b4a                	mv	s6,s2
      state = 0;
 c62:	4981                	li	s3,0
 c64:	bd65                	j	b1c <vprintf+0x60>
        putc(fd, c);
 c66:	85d2                	mv	a1,s4
 c68:	8556                	mv	a0,s5
 c6a:	00000097          	auipc	ra,0x0
 c6e:	d86080e7          	jalr	-634(ra) # 9f0 <putc>
      state = 0;
 c72:	4981                	li	s3,0
 c74:	b565                	j	b1c <vprintf+0x60>
        s = va_arg(ap, char*);
 c76:	8b4e                	mv	s6,s3
      state = 0;
 c78:	4981                	li	s3,0
 c7a:	b54d                	j	b1c <vprintf+0x60>
    }
  }
}
 c7c:	70e6                	ld	ra,120(sp)
 c7e:	7446                	ld	s0,112(sp)
 c80:	74a6                	ld	s1,104(sp)
 c82:	7906                	ld	s2,96(sp)
 c84:	69e6                	ld	s3,88(sp)
 c86:	6a46                	ld	s4,80(sp)
 c88:	6aa6                	ld	s5,72(sp)
 c8a:	6b06                	ld	s6,64(sp)
 c8c:	7be2                	ld	s7,56(sp)
 c8e:	7c42                	ld	s8,48(sp)
 c90:	7ca2                	ld	s9,40(sp)
 c92:	7d02                	ld	s10,32(sp)
 c94:	6de2                	ld	s11,24(sp)
 c96:	6109                	addi	sp,sp,128
 c98:	8082                	ret

0000000000000c9a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c9a:	715d                	addi	sp,sp,-80
 c9c:	ec06                	sd	ra,24(sp)
 c9e:	e822                	sd	s0,16(sp)
 ca0:	1000                	addi	s0,sp,32
 ca2:	e010                	sd	a2,0(s0)
 ca4:	e414                	sd	a3,8(s0)
 ca6:	e818                	sd	a4,16(s0)
 ca8:	ec1c                	sd	a5,24(s0)
 caa:	03043023          	sd	a6,32(s0)
 cae:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 cb2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 cb6:	8622                	mv	a2,s0
 cb8:	00000097          	auipc	ra,0x0
 cbc:	e04080e7          	jalr	-508(ra) # abc <vprintf>
}
 cc0:	60e2                	ld	ra,24(sp)
 cc2:	6442                	ld	s0,16(sp)
 cc4:	6161                	addi	sp,sp,80
 cc6:	8082                	ret

0000000000000cc8 <printf>:

void
printf(const char *fmt, ...)
{
 cc8:	711d                	addi	sp,sp,-96
 cca:	ec06                	sd	ra,24(sp)
 ccc:	e822                	sd	s0,16(sp)
 cce:	1000                	addi	s0,sp,32
 cd0:	e40c                	sd	a1,8(s0)
 cd2:	e810                	sd	a2,16(s0)
 cd4:	ec14                	sd	a3,24(s0)
 cd6:	f018                	sd	a4,32(s0)
 cd8:	f41c                	sd	a5,40(s0)
 cda:	03043823          	sd	a6,48(s0)
 cde:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ce2:	00840613          	addi	a2,s0,8
 ce6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 cea:	85aa                	mv	a1,a0
 cec:	4505                	li	a0,1
 cee:	00000097          	auipc	ra,0x0
 cf2:	dce080e7          	jalr	-562(ra) # abc <vprintf>
}
 cf6:	60e2                	ld	ra,24(sp)
 cf8:	6442                	ld	s0,16(sp)
 cfa:	6125                	addi	sp,sp,96
 cfc:	8082                	ret

0000000000000cfe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 cfe:	1141                	addi	sp,sp,-16
 d00:	e422                	sd	s0,8(sp)
 d02:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 d04:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d08:	00000797          	auipc	a5,0x0
 d0c:	6287b783          	ld	a5,1576(a5) # 1330 <freep>
 d10:	a805                	j	d40 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 d12:	4618                	lw	a4,8(a2)
 d14:	9db9                	addw	a1,a1,a4
 d16:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 d1a:	6398                	ld	a4,0(a5)
 d1c:	6318                	ld	a4,0(a4)
 d1e:	fee53823          	sd	a4,-16(a0)
 d22:	a091                	j	d66 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 d24:	ff852703          	lw	a4,-8(a0)
 d28:	9e39                	addw	a2,a2,a4
 d2a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 d2c:	ff053703          	ld	a4,-16(a0)
 d30:	e398                	sd	a4,0(a5)
 d32:	a099                	j	d78 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d34:	6398                	ld	a4,0(a5)
 d36:	00e7e463          	bltu	a5,a4,d3e <free+0x40>
 d3a:	00e6ea63          	bltu	a3,a4,d4e <free+0x50>
{
 d3e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d40:	fed7fae3          	bgeu	a5,a3,d34 <free+0x36>
 d44:	6398                	ld	a4,0(a5)
 d46:	00e6e463          	bltu	a3,a4,d4e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d4a:	fee7eae3          	bltu	a5,a4,d3e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 d4e:	ff852583          	lw	a1,-8(a0)
 d52:	6390                	ld	a2,0(a5)
 d54:	02059713          	slli	a4,a1,0x20
 d58:	9301                	srli	a4,a4,0x20
 d5a:	0712                	slli	a4,a4,0x4
 d5c:	9736                	add	a4,a4,a3
 d5e:	fae60ae3          	beq	a2,a4,d12 <free+0x14>
    bp->s.ptr = p->s.ptr;
 d62:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d66:	4790                	lw	a2,8(a5)
 d68:	02061713          	slli	a4,a2,0x20
 d6c:	9301                	srli	a4,a4,0x20
 d6e:	0712                	slli	a4,a4,0x4
 d70:	973e                	add	a4,a4,a5
 d72:	fae689e3          	beq	a3,a4,d24 <free+0x26>
  } else
    p->s.ptr = bp;
 d76:	e394                	sd	a3,0(a5)
  freep = p;
 d78:	00000717          	auipc	a4,0x0
 d7c:	5af73c23          	sd	a5,1464(a4) # 1330 <freep>
}
 d80:	6422                	ld	s0,8(sp)
 d82:	0141                	addi	sp,sp,16
 d84:	8082                	ret

0000000000000d86 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d86:	7139                	addi	sp,sp,-64
 d88:	fc06                	sd	ra,56(sp)
 d8a:	f822                	sd	s0,48(sp)
 d8c:	f426                	sd	s1,40(sp)
 d8e:	f04a                	sd	s2,32(sp)
 d90:	ec4e                	sd	s3,24(sp)
 d92:	e852                	sd	s4,16(sp)
 d94:	e456                	sd	s5,8(sp)
 d96:	e05a                	sd	s6,0(sp)
 d98:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d9a:	02051493          	slli	s1,a0,0x20
 d9e:	9081                	srli	s1,s1,0x20
 da0:	04bd                	addi	s1,s1,15
 da2:	8091                	srli	s1,s1,0x4
 da4:	0014899b          	addiw	s3,s1,1
 da8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 daa:	00000517          	auipc	a0,0x0
 dae:	58653503          	ld	a0,1414(a0) # 1330 <freep>
 db2:	c515                	beqz	a0,dde <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 db4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 db6:	4798                	lw	a4,8(a5)
 db8:	02977f63          	bgeu	a4,s1,df6 <malloc+0x70>
 dbc:	8a4e                	mv	s4,s3
 dbe:	0009871b          	sext.w	a4,s3
 dc2:	6685                	lui	a3,0x1
 dc4:	00d77363          	bgeu	a4,a3,dca <malloc+0x44>
 dc8:	6a05                	lui	s4,0x1
 dca:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 dce:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 dd2:	00000917          	auipc	s2,0x0
 dd6:	55e90913          	addi	s2,s2,1374 # 1330 <freep>
  if(p == (char*)-1)
 dda:	5afd                	li	s5,-1
 ddc:	a88d                	j	e4e <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 dde:	00000797          	auipc	a5,0x0
 de2:	55a78793          	addi	a5,a5,1370 # 1338 <base>
 de6:	00000717          	auipc	a4,0x0
 dea:	54f73523          	sd	a5,1354(a4) # 1330 <freep>
 dee:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 df0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 df4:	b7e1                	j	dbc <malloc+0x36>
      if(p->s.size == nunits)
 df6:	02e48b63          	beq	s1,a4,e2c <malloc+0xa6>
        p->s.size -= nunits;
 dfa:	4137073b          	subw	a4,a4,s3
 dfe:	c798                	sw	a4,8(a5)
        p += p->s.size;
 e00:	1702                	slli	a4,a4,0x20
 e02:	9301                	srli	a4,a4,0x20
 e04:	0712                	slli	a4,a4,0x4
 e06:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 e08:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 e0c:	00000717          	auipc	a4,0x0
 e10:	52a73223          	sd	a0,1316(a4) # 1330 <freep>
      return (void*)(p + 1);
 e14:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 e18:	70e2                	ld	ra,56(sp)
 e1a:	7442                	ld	s0,48(sp)
 e1c:	74a2                	ld	s1,40(sp)
 e1e:	7902                	ld	s2,32(sp)
 e20:	69e2                	ld	s3,24(sp)
 e22:	6a42                	ld	s4,16(sp)
 e24:	6aa2                	ld	s5,8(sp)
 e26:	6b02                	ld	s6,0(sp)
 e28:	6121                	addi	sp,sp,64
 e2a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 e2c:	6398                	ld	a4,0(a5)
 e2e:	e118                	sd	a4,0(a0)
 e30:	bff1                	j	e0c <malloc+0x86>
  hp->s.size = nu;
 e32:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 e36:	0541                	addi	a0,a0,16
 e38:	00000097          	auipc	ra,0x0
 e3c:	ec6080e7          	jalr	-314(ra) # cfe <free>
  return freep;
 e40:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 e44:	d971                	beqz	a0,e18 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e46:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 e48:	4798                	lw	a4,8(a5)
 e4a:	fa9776e3          	bgeu	a4,s1,df6 <malloc+0x70>
    if(p == freep)
 e4e:	00093703          	ld	a4,0(s2)
 e52:	853e                	mv	a0,a5
 e54:	fef719e3          	bne	a4,a5,e46 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 e58:	8552                	mv	a0,s4
 e5a:	00000097          	auipc	ra,0x0
 e5e:	b76080e7          	jalr	-1162(ra) # 9d0 <sbrk>
  if(p == (char*)-1)
 e62:	fd5518e3          	bne	a0,s5,e32 <malloc+0xac>
        return 0;
 e66:	4501                	li	a0,0
 e68:	bf45                	j	e18 <malloc+0x92>
