
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	89c080e7          	jalr	-1892(ra) # 58ac <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	88a080e7          	jalr	-1910(ra) # 58ac <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	0b250513          	addi	a0,a0,178 # 60f0 <malloc+0x43e>
      46:	00006097          	auipc	ra,0x6
      4a:	bae080e7          	jalr	-1106(ra) # 5bf4 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	81c080e7          	jalr	-2020(ra) # 586c <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	64078793          	addi	a5,a5,1600 # 9698 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	d4868693          	addi	a3,a3,-696 # bda8 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	09050513          	addi	a0,a0,144 # 6110 <malloc+0x45e>
      88:	00006097          	auipc	ra,0x6
      8c:	b6c080e7          	jalr	-1172(ra) # 5bf4 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	7da080e7          	jalr	2010(ra) # 586c <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	08050513          	addi	a0,a0,128 # 6128 <malloc+0x476>
      b0:	00005097          	auipc	ra,0x5
      b4:	7fc080e7          	jalr	2044(ra) # 58ac <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	7d8080e7          	jalr	2008(ra) # 5894 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	08250513          	addi	a0,a0,130 # 6148 <malloc+0x496>
      ce:	00005097          	auipc	ra,0x5
      d2:	7de080e7          	jalr	2014(ra) # 58ac <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	04a50513          	addi	a0,a0,74 # 6130 <malloc+0x47e>
      ee:	00006097          	auipc	ra,0x6
      f2:	b06080e7          	jalr	-1274(ra) # 5bf4 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	774080e7          	jalr	1908(ra) # 586c <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	05650513          	addi	a0,a0,86 # 6158 <malloc+0x4a6>
     10a:	00006097          	auipc	ra,0x6
     10e:	aea080e7          	jalr	-1302(ra) # 5bf4 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	758080e7          	jalr	1880(ra) # 586c <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	05450513          	addi	a0,a0,84 # 6180 <malloc+0x4ce>
     134:	00005097          	auipc	ra,0x5
     138:	788080e7          	jalr	1928(ra) # 58bc <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	04050513          	addi	a0,a0,64 # 6180 <malloc+0x4ce>
     148:	00005097          	auipc	ra,0x5
     14c:	764080e7          	jalr	1892(ra) # 58ac <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	03c58593          	addi	a1,a1,60 # 6190 <malloc+0x4de>
     15c:	00005097          	auipc	ra,0x5
     160:	730080e7          	jalr	1840(ra) # 588c <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	01850513          	addi	a0,a0,24 # 6180 <malloc+0x4ce>
     170:	00005097          	auipc	ra,0x5
     174:	73c080e7          	jalr	1852(ra) # 58ac <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	01c58593          	addi	a1,a1,28 # 6198 <malloc+0x4e6>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	706080e7          	jalr	1798(ra) # 588c <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	fec50513          	addi	a0,a0,-20 # 6180 <malloc+0x4ce>
     19c:	00005097          	auipc	ra,0x5
     1a0:	720080e7          	jalr	1824(ra) # 58bc <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	6ee080e7          	jalr	1774(ra) # 5894 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	6e4080e7          	jalr	1764(ra) # 5894 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	fd650513          	addi	a0,a0,-42 # 61a0 <malloc+0x4ee>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	a22080e7          	jalr	-1502(ra) # 5bf4 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	690080e7          	jalr	1680(ra) # 586c <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00005097          	auipc	ra,0x5
     214:	69c080e7          	jalr	1692(ra) # 58ac <open>
    close(fd);
     218:	00005097          	auipc	ra,0x5
     21c:	67c080e7          	jalr	1660(ra) # 5894 <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	andi	s1,s1,255
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00005097          	auipc	ra,0x5
     24a:	676080e7          	jalr	1654(ra) # 58bc <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	andi	s1,s1,255
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	cfc50513          	addi	a0,a0,-772 # 5f78 <malloc+0x2c6>
     284:	00005097          	auipc	ra,0x5
     288:	638080e7          	jalr	1592(ra) # 58bc <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	ce8a8a93          	addi	s5,s5,-792 # 5f78 <malloc+0x2c6>
      int cc = write(fd, buf, sz);
     298:	0000ca17          	auipc	s4,0xc
     29c:	b10a0a13          	addi	s4,s4,-1264 # bda8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x11d>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00005097          	auipc	ra,0x5
     2b0:	600080e7          	jalr	1536(ra) # 58ac <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00005097          	auipc	ra,0x5
     2c2:	5ce080e7          	jalr	1486(ra) # 588c <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49463          	bne	s1,a0,330 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00005097          	auipc	ra,0x5
     2d6:	5ba080e7          	jalr	1466(ra) # 588c <write>
      if(cc != sz){
     2da:	04951963          	bne	a0,s1,32c <bigwrite+0xc8>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00005097          	auipc	ra,0x5
     2e4:	5b4080e7          	jalr	1460(ra) # 5894 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00005097          	auipc	ra,0x5
     2ee:	5d2080e7          	jalr	1490(ra) # 58bc <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	eb650513          	addi	a0,a0,-330 # 61c8 <malloc+0x516>
     31a:	00006097          	auipc	ra,0x6
     31e:	8da080e7          	jalr	-1830(ra) # 5bf4 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	548080e7          	jalr	1352(ra) # 586c <exit>
     32c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     32e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     330:	86ce                	mv	a3,s3
     332:	8626                	mv	a2,s1
     334:	85de                	mv	a1,s7
     336:	00006517          	auipc	a0,0x6
     33a:	eb250513          	addi	a0,a0,-334 # 61e8 <malloc+0x536>
     33e:	00006097          	auipc	ra,0x6
     342:	8b6080e7          	jalr	-1866(ra) # 5bf4 <printf>
        exit(1);
     346:	4505                	li	a0,1
     348:	00005097          	auipc	ra,0x5
     34c:	524080e7          	jalr	1316(ra) # 586c <exit>

0000000000000350 <copyin>:
{
     350:	715d                	addi	sp,sp,-80
     352:	e486                	sd	ra,72(sp)
     354:	e0a2                	sd	s0,64(sp)
     356:	fc26                	sd	s1,56(sp)
     358:	f84a                	sd	s2,48(sp)
     35a:	f44e                	sd	s3,40(sp)
     35c:	f052                	sd	s4,32(sp)
     35e:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     360:	4785                	li	a5,1
     362:	07fe                	slli	a5,a5,0x1f
     364:	fcf43023          	sd	a5,-64(s0)
     368:	57fd                	li	a5,-1
     36a:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     36e:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     372:	00006a17          	auipc	s4,0x6
     376:	e8ea0a13          	addi	s4,s4,-370 # 6200 <malloc+0x54e>
    uint64 addr = addrs[ai];
     37a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     37e:	20100593          	li	a1,513
     382:	8552                	mv	a0,s4
     384:	00005097          	auipc	ra,0x5
     388:	528080e7          	jalr	1320(ra) # 58ac <open>
     38c:	84aa                	mv	s1,a0
    if(fd < 0){
     38e:	08054863          	bltz	a0,41e <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     392:	6609                	lui	a2,0x2
     394:	85ce                	mv	a1,s3
     396:	00005097          	auipc	ra,0x5
     39a:	4f6080e7          	jalr	1270(ra) # 588c <write>
    if(n >= 0){
     39e:	08055d63          	bgez	a0,438 <copyin+0xe8>
    close(fd);
     3a2:	8526                	mv	a0,s1
     3a4:	00005097          	auipc	ra,0x5
     3a8:	4f0080e7          	jalr	1264(ra) # 5894 <close>
    unlink("copyin1");
     3ac:	8552                	mv	a0,s4
     3ae:	00005097          	auipc	ra,0x5
     3b2:	50e080e7          	jalr	1294(ra) # 58bc <unlink>
    n = write(1, (char*)addr, 8192);
     3b6:	6609                	lui	a2,0x2
     3b8:	85ce                	mv	a1,s3
     3ba:	4505                	li	a0,1
     3bc:	00005097          	auipc	ra,0x5
     3c0:	4d0080e7          	jalr	1232(ra) # 588c <write>
    if(n > 0){
     3c4:	08a04963          	bgtz	a0,456 <copyin+0x106>
    if(pipe(fds) < 0){
     3c8:	fb840513          	addi	a0,s0,-72
     3cc:	00005097          	auipc	ra,0x5
     3d0:	4b0080e7          	jalr	1200(ra) # 587c <pipe>
     3d4:	0a054063          	bltz	a0,474 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3d8:	6609                	lui	a2,0x2
     3da:	85ce                	mv	a1,s3
     3dc:	fbc42503          	lw	a0,-68(s0)
     3e0:	00005097          	auipc	ra,0x5
     3e4:	4ac080e7          	jalr	1196(ra) # 588c <write>
    if(n > 0){
     3e8:	0aa04363          	bgtz	a0,48e <copyin+0x13e>
    close(fds[0]);
     3ec:	fb842503          	lw	a0,-72(s0)
     3f0:	00005097          	auipc	ra,0x5
     3f4:	4a4080e7          	jalr	1188(ra) # 5894 <close>
    close(fds[1]);
     3f8:	fbc42503          	lw	a0,-68(s0)
     3fc:	00005097          	auipc	ra,0x5
     400:	498080e7          	jalr	1176(ra) # 5894 <close>
  for(int ai = 0; ai < 2; ai++){
     404:	0921                	addi	s2,s2,8
     406:	fd040793          	addi	a5,s0,-48
     40a:	f6f918e3          	bne	s2,a5,37a <copyin+0x2a>
}
     40e:	60a6                	ld	ra,72(sp)
     410:	6406                	ld	s0,64(sp)
     412:	74e2                	ld	s1,56(sp)
     414:	7942                	ld	s2,48(sp)
     416:	79a2                	ld	s3,40(sp)
     418:	7a02                	ld	s4,32(sp)
     41a:	6161                	addi	sp,sp,80
     41c:	8082                	ret
      printf("open(copyin1) failed\n");
     41e:	00006517          	auipc	a0,0x6
     422:	dea50513          	addi	a0,a0,-534 # 6208 <malloc+0x556>
     426:	00005097          	auipc	ra,0x5
     42a:	7ce080e7          	jalr	1998(ra) # 5bf4 <printf>
      exit(1);
     42e:	4505                	li	a0,1
     430:	00005097          	auipc	ra,0x5
     434:	43c080e7          	jalr	1084(ra) # 586c <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     438:	862a                	mv	a2,a0
     43a:	85ce                	mv	a1,s3
     43c:	00006517          	auipc	a0,0x6
     440:	de450513          	addi	a0,a0,-540 # 6220 <malloc+0x56e>
     444:	00005097          	auipc	ra,0x5
     448:	7b0080e7          	jalr	1968(ra) # 5bf4 <printf>
      exit(1);
     44c:	4505                	li	a0,1
     44e:	00005097          	auipc	ra,0x5
     452:	41e080e7          	jalr	1054(ra) # 586c <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     456:	862a                	mv	a2,a0
     458:	85ce                	mv	a1,s3
     45a:	00006517          	auipc	a0,0x6
     45e:	df650513          	addi	a0,a0,-522 # 6250 <malloc+0x59e>
     462:	00005097          	auipc	ra,0x5
     466:	792080e7          	jalr	1938(ra) # 5bf4 <printf>
      exit(1);
     46a:	4505                	li	a0,1
     46c:	00005097          	auipc	ra,0x5
     470:	400080e7          	jalr	1024(ra) # 586c <exit>
      printf("pipe() failed\n");
     474:	00006517          	auipc	a0,0x6
     478:	e0c50513          	addi	a0,a0,-500 # 6280 <malloc+0x5ce>
     47c:	00005097          	auipc	ra,0x5
     480:	778080e7          	jalr	1912(ra) # 5bf4 <printf>
      exit(1);
     484:	4505                	li	a0,1
     486:	00005097          	auipc	ra,0x5
     48a:	3e6080e7          	jalr	998(ra) # 586c <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     48e:	862a                	mv	a2,a0
     490:	85ce                	mv	a1,s3
     492:	00006517          	auipc	a0,0x6
     496:	dfe50513          	addi	a0,a0,-514 # 6290 <malloc+0x5de>
     49a:	00005097          	auipc	ra,0x5
     49e:	75a080e7          	jalr	1882(ra) # 5bf4 <printf>
      exit(1);
     4a2:	4505                	li	a0,1
     4a4:	00005097          	auipc	ra,0x5
     4a8:	3c8080e7          	jalr	968(ra) # 586c <exit>

00000000000004ac <copyout>:
{
     4ac:	711d                	addi	sp,sp,-96
     4ae:	ec86                	sd	ra,88(sp)
     4b0:	e8a2                	sd	s0,80(sp)
     4b2:	e4a6                	sd	s1,72(sp)
     4b4:	e0ca                	sd	s2,64(sp)
     4b6:	fc4e                	sd	s3,56(sp)
     4b8:	f852                	sd	s4,48(sp)
     4ba:	f456                	sd	s5,40(sp)
     4bc:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4be:	4785                	li	a5,1
     4c0:	07fe                	slli	a5,a5,0x1f
     4c2:	faf43823          	sd	a5,-80(s0)
     4c6:	57fd                	li	a5,-1
     4c8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4cc:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4d0:	00006a17          	auipc	s4,0x6
     4d4:	df0a0a13          	addi	s4,s4,-528 # 62c0 <malloc+0x60e>
    n = write(fds[1], "x", 1);
     4d8:	00006a97          	auipc	s5,0x6
     4dc:	cc0a8a93          	addi	s5,s5,-832 # 6198 <malloc+0x4e6>
    uint64 addr = addrs[ai];
     4e0:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4e4:	4581                	li	a1,0
     4e6:	8552                	mv	a0,s4
     4e8:	00005097          	auipc	ra,0x5
     4ec:	3c4080e7          	jalr	964(ra) # 58ac <open>
     4f0:	84aa                	mv	s1,a0
    if(fd < 0){
     4f2:	08054663          	bltz	a0,57e <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     4f6:	6609                	lui	a2,0x2
     4f8:	85ce                	mv	a1,s3
     4fa:	00005097          	auipc	ra,0x5
     4fe:	38a080e7          	jalr	906(ra) # 5884 <read>
    if(n > 0){
     502:	08a04b63          	bgtz	a0,598 <copyout+0xec>
    close(fd);
     506:	8526                	mv	a0,s1
     508:	00005097          	auipc	ra,0x5
     50c:	38c080e7          	jalr	908(ra) # 5894 <close>
    if(pipe(fds) < 0){
     510:	fa840513          	addi	a0,s0,-88
     514:	00005097          	auipc	ra,0x5
     518:	368080e7          	jalr	872(ra) # 587c <pipe>
     51c:	08054d63          	bltz	a0,5b6 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     520:	4605                	li	a2,1
     522:	85d6                	mv	a1,s5
     524:	fac42503          	lw	a0,-84(s0)
     528:	00005097          	auipc	ra,0x5
     52c:	364080e7          	jalr	868(ra) # 588c <write>
    if(n != 1){
     530:	4785                	li	a5,1
     532:	08f51f63          	bne	a0,a5,5d0 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     536:	6609                	lui	a2,0x2
     538:	85ce                	mv	a1,s3
     53a:	fa842503          	lw	a0,-88(s0)
     53e:	00005097          	auipc	ra,0x5
     542:	346080e7          	jalr	838(ra) # 5884 <read>
    if(n > 0){
     546:	0aa04263          	bgtz	a0,5ea <copyout+0x13e>
    close(fds[0]);
     54a:	fa842503          	lw	a0,-88(s0)
     54e:	00005097          	auipc	ra,0x5
     552:	346080e7          	jalr	838(ra) # 5894 <close>
    close(fds[1]);
     556:	fac42503          	lw	a0,-84(s0)
     55a:	00005097          	auipc	ra,0x5
     55e:	33a080e7          	jalr	826(ra) # 5894 <close>
  for(int ai = 0; ai < 2; ai++){
     562:	0921                	addi	s2,s2,8
     564:	fc040793          	addi	a5,s0,-64
     568:	f6f91ce3          	bne	s2,a5,4e0 <copyout+0x34>
}
     56c:	60e6                	ld	ra,88(sp)
     56e:	6446                	ld	s0,80(sp)
     570:	64a6                	ld	s1,72(sp)
     572:	6906                	ld	s2,64(sp)
     574:	79e2                	ld	s3,56(sp)
     576:	7a42                	ld	s4,48(sp)
     578:	7aa2                	ld	s5,40(sp)
     57a:	6125                	addi	sp,sp,96
     57c:	8082                	ret
      printf("open(README) failed\n");
     57e:	00006517          	auipc	a0,0x6
     582:	d4a50513          	addi	a0,a0,-694 # 62c8 <malloc+0x616>
     586:	00005097          	auipc	ra,0x5
     58a:	66e080e7          	jalr	1646(ra) # 5bf4 <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	00005097          	auipc	ra,0x5
     594:	2dc080e7          	jalr	732(ra) # 586c <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     598:	862a                	mv	a2,a0
     59a:	85ce                	mv	a1,s3
     59c:	00006517          	auipc	a0,0x6
     5a0:	d4450513          	addi	a0,a0,-700 # 62e0 <malloc+0x62e>
     5a4:	00005097          	auipc	ra,0x5
     5a8:	650080e7          	jalr	1616(ra) # 5bf4 <printf>
      exit(1);
     5ac:	4505                	li	a0,1
     5ae:	00005097          	auipc	ra,0x5
     5b2:	2be080e7          	jalr	702(ra) # 586c <exit>
      printf("pipe() failed\n");
     5b6:	00006517          	auipc	a0,0x6
     5ba:	cca50513          	addi	a0,a0,-822 # 6280 <malloc+0x5ce>
     5be:	00005097          	auipc	ra,0x5
     5c2:	636080e7          	jalr	1590(ra) # 5bf4 <printf>
      exit(1);
     5c6:	4505                	li	a0,1
     5c8:	00005097          	auipc	ra,0x5
     5cc:	2a4080e7          	jalr	676(ra) # 586c <exit>
      printf("pipe write failed\n");
     5d0:	00006517          	auipc	a0,0x6
     5d4:	d4050513          	addi	a0,a0,-704 # 6310 <malloc+0x65e>
     5d8:	00005097          	auipc	ra,0x5
     5dc:	61c080e7          	jalr	1564(ra) # 5bf4 <printf>
      exit(1);
     5e0:	4505                	li	a0,1
     5e2:	00005097          	auipc	ra,0x5
     5e6:	28a080e7          	jalr	650(ra) # 586c <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5ea:	862a                	mv	a2,a0
     5ec:	85ce                	mv	a1,s3
     5ee:	00006517          	auipc	a0,0x6
     5f2:	d3a50513          	addi	a0,a0,-710 # 6328 <malloc+0x676>
     5f6:	00005097          	auipc	ra,0x5
     5fa:	5fe080e7          	jalr	1534(ra) # 5bf4 <printf>
      exit(1);
     5fe:	4505                	li	a0,1
     600:	00005097          	auipc	ra,0x5
     604:	26c080e7          	jalr	620(ra) # 586c <exit>

0000000000000608 <truncate1>:
{
     608:	711d                	addi	sp,sp,-96
     60a:	ec86                	sd	ra,88(sp)
     60c:	e8a2                	sd	s0,80(sp)
     60e:	e4a6                	sd	s1,72(sp)
     610:	e0ca                	sd	s2,64(sp)
     612:	fc4e                	sd	s3,56(sp)
     614:	f852                	sd	s4,48(sp)
     616:	f456                	sd	s5,40(sp)
     618:	1080                	addi	s0,sp,96
     61a:	8aaa                	mv	s5,a0
  unlink("truncfile");
     61c:	00006517          	auipc	a0,0x6
     620:	b6450513          	addi	a0,a0,-1180 # 6180 <malloc+0x4ce>
     624:	00005097          	auipc	ra,0x5
     628:	298080e7          	jalr	664(ra) # 58bc <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     62c:	60100593          	li	a1,1537
     630:	00006517          	auipc	a0,0x6
     634:	b5050513          	addi	a0,a0,-1200 # 6180 <malloc+0x4ce>
     638:	00005097          	auipc	ra,0x5
     63c:	274080e7          	jalr	628(ra) # 58ac <open>
     640:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     642:	4611                	li	a2,4
     644:	00006597          	auipc	a1,0x6
     648:	b4c58593          	addi	a1,a1,-1204 # 6190 <malloc+0x4de>
     64c:	00005097          	auipc	ra,0x5
     650:	240080e7          	jalr	576(ra) # 588c <write>
  close(fd1);
     654:	8526                	mv	a0,s1
     656:	00005097          	auipc	ra,0x5
     65a:	23e080e7          	jalr	574(ra) # 5894 <close>
  int fd2 = open("truncfile", O_RDONLY);
     65e:	4581                	li	a1,0
     660:	00006517          	auipc	a0,0x6
     664:	b2050513          	addi	a0,a0,-1248 # 6180 <malloc+0x4ce>
     668:	00005097          	auipc	ra,0x5
     66c:	244080e7          	jalr	580(ra) # 58ac <open>
     670:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     672:	02000613          	li	a2,32
     676:	fa040593          	addi	a1,s0,-96
     67a:	00005097          	auipc	ra,0x5
     67e:	20a080e7          	jalr	522(ra) # 5884 <read>
  if(n != 4){
     682:	4791                	li	a5,4
     684:	0cf51e63          	bne	a0,a5,760 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     688:	40100593          	li	a1,1025
     68c:	00006517          	auipc	a0,0x6
     690:	af450513          	addi	a0,a0,-1292 # 6180 <malloc+0x4ce>
     694:	00005097          	auipc	ra,0x5
     698:	218080e7          	jalr	536(ra) # 58ac <open>
     69c:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     69e:	4581                	li	a1,0
     6a0:	00006517          	auipc	a0,0x6
     6a4:	ae050513          	addi	a0,a0,-1312 # 6180 <malloc+0x4ce>
     6a8:	00005097          	auipc	ra,0x5
     6ac:	204080e7          	jalr	516(ra) # 58ac <open>
     6b0:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6b2:	02000613          	li	a2,32
     6b6:	fa040593          	addi	a1,s0,-96
     6ba:	00005097          	auipc	ra,0x5
     6be:	1ca080e7          	jalr	458(ra) # 5884 <read>
     6c2:	8a2a                	mv	s4,a0
  if(n != 0){
     6c4:	ed4d                	bnez	a0,77e <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6c6:	02000613          	li	a2,32
     6ca:	fa040593          	addi	a1,s0,-96
     6ce:	8526                	mv	a0,s1
     6d0:	00005097          	auipc	ra,0x5
     6d4:	1b4080e7          	jalr	436(ra) # 5884 <read>
     6d8:	8a2a                	mv	s4,a0
  if(n != 0){
     6da:	e971                	bnez	a0,7ae <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6dc:	4619                	li	a2,6
     6de:	00006597          	auipc	a1,0x6
     6e2:	cda58593          	addi	a1,a1,-806 # 63b8 <malloc+0x706>
     6e6:	854e                	mv	a0,s3
     6e8:	00005097          	auipc	ra,0x5
     6ec:	1a4080e7          	jalr	420(ra) # 588c <write>
  n = read(fd3, buf, sizeof(buf));
     6f0:	02000613          	li	a2,32
     6f4:	fa040593          	addi	a1,s0,-96
     6f8:	854a                	mv	a0,s2
     6fa:	00005097          	auipc	ra,0x5
     6fe:	18a080e7          	jalr	394(ra) # 5884 <read>
  if(n != 6){
     702:	4799                	li	a5,6
     704:	0cf51d63          	bne	a0,a5,7de <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     708:	02000613          	li	a2,32
     70c:	fa040593          	addi	a1,s0,-96
     710:	8526                	mv	a0,s1
     712:	00005097          	auipc	ra,0x5
     716:	172080e7          	jalr	370(ra) # 5884 <read>
  if(n != 2){
     71a:	4789                	li	a5,2
     71c:	0ef51063          	bne	a0,a5,7fc <truncate1+0x1f4>
  unlink("truncfile");
     720:	00006517          	auipc	a0,0x6
     724:	a6050513          	addi	a0,a0,-1440 # 6180 <malloc+0x4ce>
     728:	00005097          	auipc	ra,0x5
     72c:	194080e7          	jalr	404(ra) # 58bc <unlink>
  close(fd1);
     730:	854e                	mv	a0,s3
     732:	00005097          	auipc	ra,0x5
     736:	162080e7          	jalr	354(ra) # 5894 <close>
  close(fd2);
     73a:	8526                	mv	a0,s1
     73c:	00005097          	auipc	ra,0x5
     740:	158080e7          	jalr	344(ra) # 5894 <close>
  close(fd3);
     744:	854a                	mv	a0,s2
     746:	00005097          	auipc	ra,0x5
     74a:	14e080e7          	jalr	334(ra) # 5894 <close>
}
     74e:	60e6                	ld	ra,88(sp)
     750:	6446                	ld	s0,80(sp)
     752:	64a6                	ld	s1,72(sp)
     754:	6906                	ld	s2,64(sp)
     756:	79e2                	ld	s3,56(sp)
     758:	7a42                	ld	s4,48(sp)
     75a:	7aa2                	ld	s5,40(sp)
     75c:	6125                	addi	sp,sp,96
     75e:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     760:	862a                	mv	a2,a0
     762:	85d6                	mv	a1,s5
     764:	00006517          	auipc	a0,0x6
     768:	bf450513          	addi	a0,a0,-1036 # 6358 <malloc+0x6a6>
     76c:	00005097          	auipc	ra,0x5
     770:	488080e7          	jalr	1160(ra) # 5bf4 <printf>
    exit(1);
     774:	4505                	li	a0,1
     776:	00005097          	auipc	ra,0x5
     77a:	0f6080e7          	jalr	246(ra) # 586c <exit>
    printf("aaa fd3=%d\n", fd3);
     77e:	85ca                	mv	a1,s2
     780:	00006517          	auipc	a0,0x6
     784:	bf850513          	addi	a0,a0,-1032 # 6378 <malloc+0x6c6>
     788:	00005097          	auipc	ra,0x5
     78c:	46c080e7          	jalr	1132(ra) # 5bf4 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     790:	8652                	mv	a2,s4
     792:	85d6                	mv	a1,s5
     794:	00006517          	auipc	a0,0x6
     798:	bf450513          	addi	a0,a0,-1036 # 6388 <malloc+0x6d6>
     79c:	00005097          	auipc	ra,0x5
     7a0:	458080e7          	jalr	1112(ra) # 5bf4 <printf>
    exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	0c6080e7          	jalr	198(ra) # 586c <exit>
    printf("bbb fd2=%d\n", fd2);
     7ae:	85a6                	mv	a1,s1
     7b0:	00006517          	auipc	a0,0x6
     7b4:	bf850513          	addi	a0,a0,-1032 # 63a8 <malloc+0x6f6>
     7b8:	00005097          	auipc	ra,0x5
     7bc:	43c080e7          	jalr	1084(ra) # 5bf4 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7c0:	8652                	mv	a2,s4
     7c2:	85d6                	mv	a1,s5
     7c4:	00006517          	auipc	a0,0x6
     7c8:	bc450513          	addi	a0,a0,-1084 # 6388 <malloc+0x6d6>
     7cc:	00005097          	auipc	ra,0x5
     7d0:	428080e7          	jalr	1064(ra) # 5bf4 <printf>
    exit(1);
     7d4:	4505                	li	a0,1
     7d6:	00005097          	auipc	ra,0x5
     7da:	096080e7          	jalr	150(ra) # 586c <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7de:	862a                	mv	a2,a0
     7e0:	85d6                	mv	a1,s5
     7e2:	00006517          	auipc	a0,0x6
     7e6:	bde50513          	addi	a0,a0,-1058 # 63c0 <malloc+0x70e>
     7ea:	00005097          	auipc	ra,0x5
     7ee:	40a080e7          	jalr	1034(ra) # 5bf4 <printf>
    exit(1);
     7f2:	4505                	li	a0,1
     7f4:	00005097          	auipc	ra,0x5
     7f8:	078080e7          	jalr	120(ra) # 586c <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     7fc:	862a                	mv	a2,a0
     7fe:	85d6                	mv	a1,s5
     800:	00006517          	auipc	a0,0x6
     804:	be050513          	addi	a0,a0,-1056 # 63e0 <malloc+0x72e>
     808:	00005097          	auipc	ra,0x5
     80c:	3ec080e7          	jalr	1004(ra) # 5bf4 <printf>
    exit(1);
     810:	4505                	li	a0,1
     812:	00005097          	auipc	ra,0x5
     816:	05a080e7          	jalr	90(ra) # 586c <exit>

000000000000081a <writetest>:
{
     81a:	7139                	addi	sp,sp,-64
     81c:	fc06                	sd	ra,56(sp)
     81e:	f822                	sd	s0,48(sp)
     820:	f426                	sd	s1,40(sp)
     822:	f04a                	sd	s2,32(sp)
     824:	ec4e                	sd	s3,24(sp)
     826:	e852                	sd	s4,16(sp)
     828:	e456                	sd	s5,8(sp)
     82a:	e05a                	sd	s6,0(sp)
     82c:	0080                	addi	s0,sp,64
     82e:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     830:	20200593          	li	a1,514
     834:	00006517          	auipc	a0,0x6
     838:	bcc50513          	addi	a0,a0,-1076 # 6400 <malloc+0x74e>
     83c:	00005097          	auipc	ra,0x5
     840:	070080e7          	jalr	112(ra) # 58ac <open>
  if(fd < 0){
     844:	0a054d63          	bltz	a0,8fe <writetest+0xe4>
     848:	892a                	mv	s2,a0
     84a:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     84c:	00006997          	auipc	s3,0x6
     850:	bdc98993          	addi	s3,s3,-1060 # 6428 <malloc+0x776>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     854:	00006a97          	auipc	s5,0x6
     858:	c0ca8a93          	addi	s5,s5,-1012 # 6460 <malloc+0x7ae>
  for(i = 0; i < N; i++){
     85c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     860:	4629                	li	a2,10
     862:	85ce                	mv	a1,s3
     864:	854a                	mv	a0,s2
     866:	00005097          	auipc	ra,0x5
     86a:	026080e7          	jalr	38(ra) # 588c <write>
     86e:	47a9                	li	a5,10
     870:	0af51563          	bne	a0,a5,91a <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     874:	4629                	li	a2,10
     876:	85d6                	mv	a1,s5
     878:	854a                	mv	a0,s2
     87a:	00005097          	auipc	ra,0x5
     87e:	012080e7          	jalr	18(ra) # 588c <write>
     882:	47a9                	li	a5,10
     884:	0af51a63          	bne	a0,a5,938 <writetest+0x11e>
  for(i = 0; i < N; i++){
     888:	2485                	addiw	s1,s1,1
     88a:	fd449be3          	bne	s1,s4,860 <writetest+0x46>
  close(fd);
     88e:	854a                	mv	a0,s2
     890:	00005097          	auipc	ra,0x5
     894:	004080e7          	jalr	4(ra) # 5894 <close>
  fd = open("small", O_RDONLY);
     898:	4581                	li	a1,0
     89a:	00006517          	auipc	a0,0x6
     89e:	b6650513          	addi	a0,a0,-1178 # 6400 <malloc+0x74e>
     8a2:	00005097          	auipc	ra,0x5
     8a6:	00a080e7          	jalr	10(ra) # 58ac <open>
     8aa:	84aa                	mv	s1,a0
  if(fd < 0){
     8ac:	0a054563          	bltz	a0,956 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8b0:	7d000613          	li	a2,2000
     8b4:	0000b597          	auipc	a1,0xb
     8b8:	4f458593          	addi	a1,a1,1268 # bda8 <buf>
     8bc:	00005097          	auipc	ra,0x5
     8c0:	fc8080e7          	jalr	-56(ra) # 5884 <read>
  if(i != N*SZ*2){
     8c4:	7d000793          	li	a5,2000
     8c8:	0af51563          	bne	a0,a5,972 <writetest+0x158>
  close(fd);
     8cc:	8526                	mv	a0,s1
     8ce:	00005097          	auipc	ra,0x5
     8d2:	fc6080e7          	jalr	-58(ra) # 5894 <close>
  if(unlink("small") < 0){
     8d6:	00006517          	auipc	a0,0x6
     8da:	b2a50513          	addi	a0,a0,-1238 # 6400 <malloc+0x74e>
     8de:	00005097          	auipc	ra,0x5
     8e2:	fde080e7          	jalr	-34(ra) # 58bc <unlink>
     8e6:	0a054463          	bltz	a0,98e <writetest+0x174>
}
     8ea:	70e2                	ld	ra,56(sp)
     8ec:	7442                	ld	s0,48(sp)
     8ee:	74a2                	ld	s1,40(sp)
     8f0:	7902                	ld	s2,32(sp)
     8f2:	69e2                	ld	s3,24(sp)
     8f4:	6a42                	ld	s4,16(sp)
     8f6:	6aa2                	ld	s5,8(sp)
     8f8:	6b02                	ld	s6,0(sp)
     8fa:	6121                	addi	sp,sp,64
     8fc:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     8fe:	85da                	mv	a1,s6
     900:	00006517          	auipc	a0,0x6
     904:	b0850513          	addi	a0,a0,-1272 # 6408 <malloc+0x756>
     908:	00005097          	auipc	ra,0x5
     90c:	2ec080e7          	jalr	748(ra) # 5bf4 <printf>
    exit(1);
     910:	4505                	li	a0,1
     912:	00005097          	auipc	ra,0x5
     916:	f5a080e7          	jalr	-166(ra) # 586c <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     91a:	8626                	mv	a2,s1
     91c:	85da                	mv	a1,s6
     91e:	00006517          	auipc	a0,0x6
     922:	b1a50513          	addi	a0,a0,-1254 # 6438 <malloc+0x786>
     926:	00005097          	auipc	ra,0x5
     92a:	2ce080e7          	jalr	718(ra) # 5bf4 <printf>
      exit(1);
     92e:	4505                	li	a0,1
     930:	00005097          	auipc	ra,0x5
     934:	f3c080e7          	jalr	-196(ra) # 586c <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     938:	8626                	mv	a2,s1
     93a:	85da                	mv	a1,s6
     93c:	00006517          	auipc	a0,0x6
     940:	b3450513          	addi	a0,a0,-1228 # 6470 <malloc+0x7be>
     944:	00005097          	auipc	ra,0x5
     948:	2b0080e7          	jalr	688(ra) # 5bf4 <printf>
      exit(1);
     94c:	4505                	li	a0,1
     94e:	00005097          	auipc	ra,0x5
     952:	f1e080e7          	jalr	-226(ra) # 586c <exit>
    printf("%s: error: open small failed!\n", s);
     956:	85da                	mv	a1,s6
     958:	00006517          	auipc	a0,0x6
     95c:	b4050513          	addi	a0,a0,-1216 # 6498 <malloc+0x7e6>
     960:	00005097          	auipc	ra,0x5
     964:	294080e7          	jalr	660(ra) # 5bf4 <printf>
    exit(1);
     968:	4505                	li	a0,1
     96a:	00005097          	auipc	ra,0x5
     96e:	f02080e7          	jalr	-254(ra) # 586c <exit>
    printf("%s: read failed\n", s);
     972:	85da                	mv	a1,s6
     974:	00006517          	auipc	a0,0x6
     978:	b4450513          	addi	a0,a0,-1212 # 64b8 <malloc+0x806>
     97c:	00005097          	auipc	ra,0x5
     980:	278080e7          	jalr	632(ra) # 5bf4 <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00005097          	auipc	ra,0x5
     98a:	ee6080e7          	jalr	-282(ra) # 586c <exit>
    printf("%s: unlink small failed\n", s);
     98e:	85da                	mv	a1,s6
     990:	00006517          	auipc	a0,0x6
     994:	b4050513          	addi	a0,a0,-1216 # 64d0 <malloc+0x81e>
     998:	00005097          	auipc	ra,0x5
     99c:	25c080e7          	jalr	604(ra) # 5bf4 <printf>
    exit(1);
     9a0:	4505                	li	a0,1
     9a2:	00005097          	auipc	ra,0x5
     9a6:	eca080e7          	jalr	-310(ra) # 586c <exit>

00000000000009aa <writebig>:
{
     9aa:	7139                	addi	sp,sp,-64
     9ac:	fc06                	sd	ra,56(sp)
     9ae:	f822                	sd	s0,48(sp)
     9b0:	f426                	sd	s1,40(sp)
     9b2:	f04a                	sd	s2,32(sp)
     9b4:	ec4e                	sd	s3,24(sp)
     9b6:	e852                	sd	s4,16(sp)
     9b8:	e456                	sd	s5,8(sp)
     9ba:	0080                	addi	s0,sp,64
     9bc:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9be:	20200593          	li	a1,514
     9c2:	00006517          	auipc	a0,0x6
     9c6:	b2e50513          	addi	a0,a0,-1234 # 64f0 <malloc+0x83e>
     9ca:	00005097          	auipc	ra,0x5
     9ce:	ee2080e7          	jalr	-286(ra) # 58ac <open>
     9d2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9d4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9d6:	0000b917          	auipc	s2,0xb
     9da:	3d290913          	addi	s2,s2,978 # bda8 <buf>
  for(i = 0; i < MAXFILE; i++){
     9de:	10c00a13          	li	s4,268
  if(fd < 0){
     9e2:	06054c63          	bltz	a0,a5a <writebig+0xb0>
    ((int*)buf)[0] = i;
     9e6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9ea:	40000613          	li	a2,1024
     9ee:	85ca                	mv	a1,s2
     9f0:	854e                	mv	a0,s3
     9f2:	00005097          	auipc	ra,0x5
     9f6:	e9a080e7          	jalr	-358(ra) # 588c <write>
     9fa:	40000793          	li	a5,1024
     9fe:	06f51c63          	bne	a0,a5,a76 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a02:	2485                	addiw	s1,s1,1
     a04:	ff4491e3          	bne	s1,s4,9e6 <writebig+0x3c>
  close(fd);
     a08:	854e                	mv	a0,s3
     a0a:	00005097          	auipc	ra,0x5
     a0e:	e8a080e7          	jalr	-374(ra) # 5894 <close>
  fd = open("big", O_RDONLY);
     a12:	4581                	li	a1,0
     a14:	00006517          	auipc	a0,0x6
     a18:	adc50513          	addi	a0,a0,-1316 # 64f0 <malloc+0x83e>
     a1c:	00005097          	auipc	ra,0x5
     a20:	e90080e7          	jalr	-368(ra) # 58ac <open>
     a24:	89aa                	mv	s3,a0
  n = 0;
     a26:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a28:	0000b917          	auipc	s2,0xb
     a2c:	38090913          	addi	s2,s2,896 # bda8 <buf>
  if(fd < 0){
     a30:	06054263          	bltz	a0,a94 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     a34:	40000613          	li	a2,1024
     a38:	85ca                	mv	a1,s2
     a3a:	854e                	mv	a0,s3
     a3c:	00005097          	auipc	ra,0x5
     a40:	e48080e7          	jalr	-440(ra) # 5884 <read>
    if(i == 0){
     a44:	c535                	beqz	a0,ab0 <writebig+0x106>
    } else if(i != BSIZE){
     a46:	40000793          	li	a5,1024
     a4a:	0af51f63          	bne	a0,a5,b08 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     a4e:	00092683          	lw	a3,0(s2)
     a52:	0c969a63          	bne	a3,s1,b26 <writebig+0x17c>
    n++;
     a56:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a58:	bff1                	j	a34 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a5a:	85d6                	mv	a1,s5
     a5c:	00006517          	auipc	a0,0x6
     a60:	a9c50513          	addi	a0,a0,-1380 # 64f8 <malloc+0x846>
     a64:	00005097          	auipc	ra,0x5
     a68:	190080e7          	jalr	400(ra) # 5bf4 <printf>
    exit(1);
     a6c:	4505                	li	a0,1
     a6e:	00005097          	auipc	ra,0x5
     a72:	dfe080e7          	jalr	-514(ra) # 586c <exit>
      printf("%s: error: write big file failed\n", s, i);
     a76:	8626                	mv	a2,s1
     a78:	85d6                	mv	a1,s5
     a7a:	00006517          	auipc	a0,0x6
     a7e:	a9e50513          	addi	a0,a0,-1378 # 6518 <malloc+0x866>
     a82:	00005097          	auipc	ra,0x5
     a86:	172080e7          	jalr	370(ra) # 5bf4 <printf>
      exit(1);
     a8a:	4505                	li	a0,1
     a8c:	00005097          	auipc	ra,0x5
     a90:	de0080e7          	jalr	-544(ra) # 586c <exit>
    printf("%s: error: open big failed!\n", s);
     a94:	85d6                	mv	a1,s5
     a96:	00006517          	auipc	a0,0x6
     a9a:	aaa50513          	addi	a0,a0,-1366 # 6540 <malloc+0x88e>
     a9e:	00005097          	auipc	ra,0x5
     aa2:	156080e7          	jalr	342(ra) # 5bf4 <printf>
    exit(1);
     aa6:	4505                	li	a0,1
     aa8:	00005097          	auipc	ra,0x5
     aac:	dc4080e7          	jalr	-572(ra) # 586c <exit>
      if(n == MAXFILE - 1){
     ab0:	10b00793          	li	a5,267
     ab4:	02f48a63          	beq	s1,a5,ae8 <writebig+0x13e>
  close(fd);
     ab8:	854e                	mv	a0,s3
     aba:	00005097          	auipc	ra,0x5
     abe:	dda080e7          	jalr	-550(ra) # 5894 <close>
  if(unlink("big") < 0){
     ac2:	00006517          	auipc	a0,0x6
     ac6:	a2e50513          	addi	a0,a0,-1490 # 64f0 <malloc+0x83e>
     aca:	00005097          	auipc	ra,0x5
     ace:	df2080e7          	jalr	-526(ra) # 58bc <unlink>
     ad2:	06054963          	bltz	a0,b44 <writebig+0x19a>
}
     ad6:	70e2                	ld	ra,56(sp)
     ad8:	7442                	ld	s0,48(sp)
     ada:	74a2                	ld	s1,40(sp)
     adc:	7902                	ld	s2,32(sp)
     ade:	69e2                	ld	s3,24(sp)
     ae0:	6a42                	ld	s4,16(sp)
     ae2:	6aa2                	ld	s5,8(sp)
     ae4:	6121                	addi	sp,sp,64
     ae6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ae8:	10b00613          	li	a2,267
     aec:	85d6                	mv	a1,s5
     aee:	00006517          	auipc	a0,0x6
     af2:	a7250513          	addi	a0,a0,-1422 # 6560 <malloc+0x8ae>
     af6:	00005097          	auipc	ra,0x5
     afa:	0fe080e7          	jalr	254(ra) # 5bf4 <printf>
        exit(1);
     afe:	4505                	li	a0,1
     b00:	00005097          	auipc	ra,0x5
     b04:	d6c080e7          	jalr	-660(ra) # 586c <exit>
      printf("%s: read failed %d\n", s, i);
     b08:	862a                	mv	a2,a0
     b0a:	85d6                	mv	a1,s5
     b0c:	00006517          	auipc	a0,0x6
     b10:	a7c50513          	addi	a0,a0,-1412 # 6588 <malloc+0x8d6>
     b14:	00005097          	auipc	ra,0x5
     b18:	0e0080e7          	jalr	224(ra) # 5bf4 <printf>
      exit(1);
     b1c:	4505                	li	a0,1
     b1e:	00005097          	auipc	ra,0x5
     b22:	d4e080e7          	jalr	-690(ra) # 586c <exit>
      printf("%s: read content of block %d is %d\n", s,
     b26:	8626                	mv	a2,s1
     b28:	85d6                	mv	a1,s5
     b2a:	00006517          	auipc	a0,0x6
     b2e:	a7650513          	addi	a0,a0,-1418 # 65a0 <malloc+0x8ee>
     b32:	00005097          	auipc	ra,0x5
     b36:	0c2080e7          	jalr	194(ra) # 5bf4 <printf>
      exit(1);
     b3a:	4505                	li	a0,1
     b3c:	00005097          	auipc	ra,0x5
     b40:	d30080e7          	jalr	-720(ra) # 586c <exit>
    printf("%s: unlink big failed\n", s);
     b44:	85d6                	mv	a1,s5
     b46:	00006517          	auipc	a0,0x6
     b4a:	a8250513          	addi	a0,a0,-1406 # 65c8 <malloc+0x916>
     b4e:	00005097          	auipc	ra,0x5
     b52:	0a6080e7          	jalr	166(ra) # 5bf4 <printf>
    exit(1);
     b56:	4505                	li	a0,1
     b58:	00005097          	auipc	ra,0x5
     b5c:	d14080e7          	jalr	-748(ra) # 586c <exit>

0000000000000b60 <unlinkread>:
{
     b60:	7179                	addi	sp,sp,-48
     b62:	f406                	sd	ra,40(sp)
     b64:	f022                	sd	s0,32(sp)
     b66:	ec26                	sd	s1,24(sp)
     b68:	e84a                	sd	s2,16(sp)
     b6a:	e44e                	sd	s3,8(sp)
     b6c:	1800                	addi	s0,sp,48
     b6e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b70:	20200593          	li	a1,514
     b74:	00005517          	auipc	a0,0x5
     b78:	39450513          	addi	a0,a0,916 # 5f08 <malloc+0x256>
     b7c:	00005097          	auipc	ra,0x5
     b80:	d30080e7          	jalr	-720(ra) # 58ac <open>
  if(fd < 0){
     b84:	0e054563          	bltz	a0,c6e <unlinkread+0x10e>
     b88:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b8a:	4615                	li	a2,5
     b8c:	00006597          	auipc	a1,0x6
     b90:	a7458593          	addi	a1,a1,-1420 # 6600 <malloc+0x94e>
     b94:	00005097          	auipc	ra,0x5
     b98:	cf8080e7          	jalr	-776(ra) # 588c <write>
  close(fd);
     b9c:	8526                	mv	a0,s1
     b9e:	00005097          	auipc	ra,0x5
     ba2:	cf6080e7          	jalr	-778(ra) # 5894 <close>
  fd = open("unlinkread", O_RDWR);
     ba6:	4589                	li	a1,2
     ba8:	00005517          	auipc	a0,0x5
     bac:	36050513          	addi	a0,a0,864 # 5f08 <malloc+0x256>
     bb0:	00005097          	auipc	ra,0x5
     bb4:	cfc080e7          	jalr	-772(ra) # 58ac <open>
     bb8:	84aa                	mv	s1,a0
  if(fd < 0){
     bba:	0c054863          	bltz	a0,c8a <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bbe:	00005517          	auipc	a0,0x5
     bc2:	34a50513          	addi	a0,a0,842 # 5f08 <malloc+0x256>
     bc6:	00005097          	auipc	ra,0x5
     bca:	cf6080e7          	jalr	-778(ra) # 58bc <unlink>
     bce:	ed61                	bnez	a0,ca6 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	33450513          	addi	a0,a0,820 # 5f08 <malloc+0x256>
     bdc:	00005097          	auipc	ra,0x5
     be0:	cd0080e7          	jalr	-816(ra) # 58ac <open>
     be4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be6:	460d                	li	a2,3
     be8:	00006597          	auipc	a1,0x6
     bec:	a6058593          	addi	a1,a1,-1440 # 6648 <malloc+0x996>
     bf0:	00005097          	auipc	ra,0x5
     bf4:	c9c080e7          	jalr	-868(ra) # 588c <write>
  close(fd1);
     bf8:	854a                	mv	a0,s2
     bfa:	00005097          	auipc	ra,0x5
     bfe:	c9a080e7          	jalr	-870(ra) # 5894 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c02:	660d                	lui	a2,0x3
     c04:	0000b597          	auipc	a1,0xb
     c08:	1a458593          	addi	a1,a1,420 # bda8 <buf>
     c0c:	8526                	mv	a0,s1
     c0e:	00005097          	auipc	ra,0x5
     c12:	c76080e7          	jalr	-906(ra) # 5884 <read>
     c16:	4795                	li	a5,5
     c18:	0af51563          	bne	a0,a5,cc2 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c1c:	0000b717          	auipc	a4,0xb
     c20:	18c74703          	lbu	a4,396(a4) # bda8 <buf>
     c24:	06800793          	li	a5,104
     c28:	0af71b63          	bne	a4,a5,cde <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c2c:	4629                	li	a2,10
     c2e:	0000b597          	auipc	a1,0xb
     c32:	17a58593          	addi	a1,a1,378 # bda8 <buf>
     c36:	8526                	mv	a0,s1
     c38:	00005097          	auipc	ra,0x5
     c3c:	c54080e7          	jalr	-940(ra) # 588c <write>
     c40:	47a9                	li	a5,10
     c42:	0af51c63          	bne	a0,a5,cfa <unlinkread+0x19a>
  close(fd);
     c46:	8526                	mv	a0,s1
     c48:	00005097          	auipc	ra,0x5
     c4c:	c4c080e7          	jalr	-948(ra) # 5894 <close>
  unlink("unlinkread");
     c50:	00005517          	auipc	a0,0x5
     c54:	2b850513          	addi	a0,a0,696 # 5f08 <malloc+0x256>
     c58:	00005097          	auipc	ra,0x5
     c5c:	c64080e7          	jalr	-924(ra) # 58bc <unlink>
}
     c60:	70a2                	ld	ra,40(sp)
     c62:	7402                	ld	s0,32(sp)
     c64:	64e2                	ld	s1,24(sp)
     c66:	6942                	ld	s2,16(sp)
     c68:	69a2                	ld	s3,8(sp)
     c6a:	6145                	addi	sp,sp,48
     c6c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c6e:	85ce                	mv	a1,s3
     c70:	00006517          	auipc	a0,0x6
     c74:	97050513          	addi	a0,a0,-1680 # 65e0 <malloc+0x92e>
     c78:	00005097          	auipc	ra,0x5
     c7c:	f7c080e7          	jalr	-132(ra) # 5bf4 <printf>
    exit(1);
     c80:	4505                	li	a0,1
     c82:	00005097          	auipc	ra,0x5
     c86:	bea080e7          	jalr	-1046(ra) # 586c <exit>
    printf("%s: open unlinkread failed\n", s);
     c8a:	85ce                	mv	a1,s3
     c8c:	00006517          	auipc	a0,0x6
     c90:	97c50513          	addi	a0,a0,-1668 # 6608 <malloc+0x956>
     c94:	00005097          	auipc	ra,0x5
     c98:	f60080e7          	jalr	-160(ra) # 5bf4 <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	00005097          	auipc	ra,0x5
     ca2:	bce080e7          	jalr	-1074(ra) # 586c <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ca6:	85ce                	mv	a1,s3
     ca8:	00006517          	auipc	a0,0x6
     cac:	98050513          	addi	a0,a0,-1664 # 6628 <malloc+0x976>
     cb0:	00005097          	auipc	ra,0x5
     cb4:	f44080e7          	jalr	-188(ra) # 5bf4 <printf>
    exit(1);
     cb8:	4505                	li	a0,1
     cba:	00005097          	auipc	ra,0x5
     cbe:	bb2080e7          	jalr	-1102(ra) # 586c <exit>
    printf("%s: unlinkread read failed", s);
     cc2:	85ce                	mv	a1,s3
     cc4:	00006517          	auipc	a0,0x6
     cc8:	98c50513          	addi	a0,a0,-1652 # 6650 <malloc+0x99e>
     ccc:	00005097          	auipc	ra,0x5
     cd0:	f28080e7          	jalr	-216(ra) # 5bf4 <printf>
    exit(1);
     cd4:	4505                	li	a0,1
     cd6:	00005097          	auipc	ra,0x5
     cda:	b96080e7          	jalr	-1130(ra) # 586c <exit>
    printf("%s: unlinkread wrong data\n", s);
     cde:	85ce                	mv	a1,s3
     ce0:	00006517          	auipc	a0,0x6
     ce4:	99050513          	addi	a0,a0,-1648 # 6670 <malloc+0x9be>
     ce8:	00005097          	auipc	ra,0x5
     cec:	f0c080e7          	jalr	-244(ra) # 5bf4 <printf>
    exit(1);
     cf0:	4505                	li	a0,1
     cf2:	00005097          	auipc	ra,0x5
     cf6:	b7a080e7          	jalr	-1158(ra) # 586c <exit>
    printf("%s: unlinkread write failed\n", s);
     cfa:	85ce                	mv	a1,s3
     cfc:	00006517          	auipc	a0,0x6
     d00:	99450513          	addi	a0,a0,-1644 # 6690 <malloc+0x9de>
     d04:	00005097          	auipc	ra,0x5
     d08:	ef0080e7          	jalr	-272(ra) # 5bf4 <printf>
    exit(1);
     d0c:	4505                	li	a0,1
     d0e:	00005097          	auipc	ra,0x5
     d12:	b5e080e7          	jalr	-1186(ra) # 586c <exit>

0000000000000d16 <linktest>:
{
     d16:	1101                	addi	sp,sp,-32
     d18:	ec06                	sd	ra,24(sp)
     d1a:	e822                	sd	s0,16(sp)
     d1c:	e426                	sd	s1,8(sp)
     d1e:	e04a                	sd	s2,0(sp)
     d20:	1000                	addi	s0,sp,32
     d22:	892a                	mv	s2,a0
  unlink("lf1");
     d24:	00006517          	auipc	a0,0x6
     d28:	98c50513          	addi	a0,a0,-1652 # 66b0 <malloc+0x9fe>
     d2c:	00005097          	auipc	ra,0x5
     d30:	b90080e7          	jalr	-1136(ra) # 58bc <unlink>
  unlink("lf2");
     d34:	00006517          	auipc	a0,0x6
     d38:	98450513          	addi	a0,a0,-1660 # 66b8 <malloc+0xa06>
     d3c:	00005097          	auipc	ra,0x5
     d40:	b80080e7          	jalr	-1152(ra) # 58bc <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d44:	20200593          	li	a1,514
     d48:	00006517          	auipc	a0,0x6
     d4c:	96850513          	addi	a0,a0,-1688 # 66b0 <malloc+0x9fe>
     d50:	00005097          	auipc	ra,0x5
     d54:	b5c080e7          	jalr	-1188(ra) # 58ac <open>
  if(fd < 0){
     d58:	10054763          	bltz	a0,e66 <linktest+0x150>
     d5c:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d5e:	4615                	li	a2,5
     d60:	00006597          	auipc	a1,0x6
     d64:	8a058593          	addi	a1,a1,-1888 # 6600 <malloc+0x94e>
     d68:	00005097          	auipc	ra,0x5
     d6c:	b24080e7          	jalr	-1244(ra) # 588c <write>
     d70:	4795                	li	a5,5
     d72:	10f51863          	bne	a0,a5,e82 <linktest+0x16c>
  close(fd);
     d76:	8526                	mv	a0,s1
     d78:	00005097          	auipc	ra,0x5
     d7c:	b1c080e7          	jalr	-1252(ra) # 5894 <close>
  if(link("lf1", "lf2") < 0){
     d80:	00006597          	auipc	a1,0x6
     d84:	93858593          	addi	a1,a1,-1736 # 66b8 <malloc+0xa06>
     d88:	00006517          	auipc	a0,0x6
     d8c:	92850513          	addi	a0,a0,-1752 # 66b0 <malloc+0x9fe>
     d90:	00005097          	auipc	ra,0x5
     d94:	b3c080e7          	jalr	-1220(ra) # 58cc <link>
     d98:	10054363          	bltz	a0,e9e <linktest+0x188>
  unlink("lf1");
     d9c:	00006517          	auipc	a0,0x6
     da0:	91450513          	addi	a0,a0,-1772 # 66b0 <malloc+0x9fe>
     da4:	00005097          	auipc	ra,0x5
     da8:	b18080e7          	jalr	-1256(ra) # 58bc <unlink>
  if(open("lf1", 0) >= 0){
     dac:	4581                	li	a1,0
     dae:	00006517          	auipc	a0,0x6
     db2:	90250513          	addi	a0,a0,-1790 # 66b0 <malloc+0x9fe>
     db6:	00005097          	auipc	ra,0x5
     dba:	af6080e7          	jalr	-1290(ra) # 58ac <open>
     dbe:	0e055e63          	bgez	a0,eba <linktest+0x1a4>
  fd = open("lf2", 0);
     dc2:	4581                	li	a1,0
     dc4:	00006517          	auipc	a0,0x6
     dc8:	8f450513          	addi	a0,a0,-1804 # 66b8 <malloc+0xa06>
     dcc:	00005097          	auipc	ra,0x5
     dd0:	ae0080e7          	jalr	-1312(ra) # 58ac <open>
     dd4:	84aa                	mv	s1,a0
  if(fd < 0){
     dd6:	10054063          	bltz	a0,ed6 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dda:	660d                	lui	a2,0x3
     ddc:	0000b597          	auipc	a1,0xb
     de0:	fcc58593          	addi	a1,a1,-52 # bda8 <buf>
     de4:	00005097          	auipc	ra,0x5
     de8:	aa0080e7          	jalr	-1376(ra) # 5884 <read>
     dec:	4795                	li	a5,5
     dee:	10f51263          	bne	a0,a5,ef2 <linktest+0x1dc>
  close(fd);
     df2:	8526                	mv	a0,s1
     df4:	00005097          	auipc	ra,0x5
     df8:	aa0080e7          	jalr	-1376(ra) # 5894 <close>
  if(link("lf2", "lf2") >= 0){
     dfc:	00006597          	auipc	a1,0x6
     e00:	8bc58593          	addi	a1,a1,-1860 # 66b8 <malloc+0xa06>
     e04:	852e                	mv	a0,a1
     e06:	00005097          	auipc	ra,0x5
     e0a:	ac6080e7          	jalr	-1338(ra) # 58cc <link>
     e0e:	10055063          	bgez	a0,f0e <linktest+0x1f8>
  unlink("lf2");
     e12:	00006517          	auipc	a0,0x6
     e16:	8a650513          	addi	a0,a0,-1882 # 66b8 <malloc+0xa06>
     e1a:	00005097          	auipc	ra,0x5
     e1e:	aa2080e7          	jalr	-1374(ra) # 58bc <unlink>
  if(link("lf2", "lf1") >= 0){
     e22:	00006597          	auipc	a1,0x6
     e26:	88e58593          	addi	a1,a1,-1906 # 66b0 <malloc+0x9fe>
     e2a:	00006517          	auipc	a0,0x6
     e2e:	88e50513          	addi	a0,a0,-1906 # 66b8 <malloc+0xa06>
     e32:	00005097          	auipc	ra,0x5
     e36:	a9a080e7          	jalr	-1382(ra) # 58cc <link>
     e3a:	0e055863          	bgez	a0,f2a <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e3e:	00006597          	auipc	a1,0x6
     e42:	87258593          	addi	a1,a1,-1934 # 66b0 <malloc+0x9fe>
     e46:	00006517          	auipc	a0,0x6
     e4a:	97a50513          	addi	a0,a0,-1670 # 67c0 <malloc+0xb0e>
     e4e:	00005097          	auipc	ra,0x5
     e52:	a7e080e7          	jalr	-1410(ra) # 58cc <link>
     e56:	0e055863          	bgez	a0,f46 <linktest+0x230>
}
     e5a:	60e2                	ld	ra,24(sp)
     e5c:	6442                	ld	s0,16(sp)
     e5e:	64a2                	ld	s1,8(sp)
     e60:	6902                	ld	s2,0(sp)
     e62:	6105                	addi	sp,sp,32
     e64:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e66:	85ca                	mv	a1,s2
     e68:	00006517          	auipc	a0,0x6
     e6c:	85850513          	addi	a0,a0,-1960 # 66c0 <malloc+0xa0e>
     e70:	00005097          	auipc	ra,0x5
     e74:	d84080e7          	jalr	-636(ra) # 5bf4 <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	00005097          	auipc	ra,0x5
     e7e:	9f2080e7          	jalr	-1550(ra) # 586c <exit>
    printf("%s: write lf1 failed\n", s);
     e82:	85ca                	mv	a1,s2
     e84:	00006517          	auipc	a0,0x6
     e88:	85450513          	addi	a0,a0,-1964 # 66d8 <malloc+0xa26>
     e8c:	00005097          	auipc	ra,0x5
     e90:	d68080e7          	jalr	-664(ra) # 5bf4 <printf>
    exit(1);
     e94:	4505                	li	a0,1
     e96:	00005097          	auipc	ra,0x5
     e9a:	9d6080e7          	jalr	-1578(ra) # 586c <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e9e:	85ca                	mv	a1,s2
     ea0:	00006517          	auipc	a0,0x6
     ea4:	85050513          	addi	a0,a0,-1968 # 66f0 <malloc+0xa3e>
     ea8:	00005097          	auipc	ra,0x5
     eac:	d4c080e7          	jalr	-692(ra) # 5bf4 <printf>
    exit(1);
     eb0:	4505                	li	a0,1
     eb2:	00005097          	auipc	ra,0x5
     eb6:	9ba080e7          	jalr	-1606(ra) # 586c <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     eba:	85ca                	mv	a1,s2
     ebc:	00006517          	auipc	a0,0x6
     ec0:	85450513          	addi	a0,a0,-1964 # 6710 <malloc+0xa5e>
     ec4:	00005097          	auipc	ra,0x5
     ec8:	d30080e7          	jalr	-720(ra) # 5bf4 <printf>
    exit(1);
     ecc:	4505                	li	a0,1
     ece:	00005097          	auipc	ra,0x5
     ed2:	99e080e7          	jalr	-1634(ra) # 586c <exit>
    printf("%s: open lf2 failed\n", s);
     ed6:	85ca                	mv	a1,s2
     ed8:	00006517          	auipc	a0,0x6
     edc:	86850513          	addi	a0,a0,-1944 # 6740 <malloc+0xa8e>
     ee0:	00005097          	auipc	ra,0x5
     ee4:	d14080e7          	jalr	-748(ra) # 5bf4 <printf>
    exit(1);
     ee8:	4505                	li	a0,1
     eea:	00005097          	auipc	ra,0x5
     eee:	982080e7          	jalr	-1662(ra) # 586c <exit>
    printf("%s: read lf2 failed\n", s);
     ef2:	85ca                	mv	a1,s2
     ef4:	00006517          	auipc	a0,0x6
     ef8:	86450513          	addi	a0,a0,-1948 # 6758 <malloc+0xaa6>
     efc:	00005097          	auipc	ra,0x5
     f00:	cf8080e7          	jalr	-776(ra) # 5bf4 <printf>
    exit(1);
     f04:	4505                	li	a0,1
     f06:	00005097          	auipc	ra,0x5
     f0a:	966080e7          	jalr	-1690(ra) # 586c <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f0e:	85ca                	mv	a1,s2
     f10:	00006517          	auipc	a0,0x6
     f14:	86050513          	addi	a0,a0,-1952 # 6770 <malloc+0xabe>
     f18:	00005097          	auipc	ra,0x5
     f1c:	cdc080e7          	jalr	-804(ra) # 5bf4 <printf>
    exit(1);
     f20:	4505                	li	a0,1
     f22:	00005097          	auipc	ra,0x5
     f26:	94a080e7          	jalr	-1718(ra) # 586c <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     f2a:	85ca                	mv	a1,s2
     f2c:	00006517          	auipc	a0,0x6
     f30:	86c50513          	addi	a0,a0,-1940 # 6798 <malloc+0xae6>
     f34:	00005097          	auipc	ra,0x5
     f38:	cc0080e7          	jalr	-832(ra) # 5bf4 <printf>
    exit(1);
     f3c:	4505                	li	a0,1
     f3e:	00005097          	auipc	ra,0x5
     f42:	92e080e7          	jalr	-1746(ra) # 586c <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f46:	85ca                	mv	a1,s2
     f48:	00006517          	auipc	a0,0x6
     f4c:	88050513          	addi	a0,a0,-1920 # 67c8 <malloc+0xb16>
     f50:	00005097          	auipc	ra,0x5
     f54:	ca4080e7          	jalr	-860(ra) # 5bf4 <printf>
    exit(1);
     f58:	4505                	li	a0,1
     f5a:	00005097          	auipc	ra,0x5
     f5e:	912080e7          	jalr	-1774(ra) # 586c <exit>

0000000000000f62 <validatetest>:
{
     f62:	7139                	addi	sp,sp,-64
     f64:	fc06                	sd	ra,56(sp)
     f66:	f822                	sd	s0,48(sp)
     f68:	f426                	sd	s1,40(sp)
     f6a:	f04a                	sd	s2,32(sp)
     f6c:	ec4e                	sd	s3,24(sp)
     f6e:	e852                	sd	s4,16(sp)
     f70:	e456                	sd	s5,8(sp)
     f72:	e05a                	sd	s6,0(sp)
     f74:	0080                	addi	s0,sp,64
     f76:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     f78:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     f7a:	00006997          	auipc	s3,0x6
     f7e:	86e98993          	addi	s3,s3,-1938 # 67e8 <malloc+0xb36>
     f82:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     f84:	6a85                	lui	s5,0x1
     f86:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     f8a:	85a6                	mv	a1,s1
     f8c:	854e                	mv	a0,s3
     f8e:	00005097          	auipc	ra,0x5
     f92:	93e080e7          	jalr	-1730(ra) # 58cc <link>
     f96:	01251f63          	bne	a0,s2,fb4 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     f9a:	94d6                	add	s1,s1,s5
     f9c:	ff4497e3          	bne	s1,s4,f8a <validatetest+0x28>
}
     fa0:	70e2                	ld	ra,56(sp)
     fa2:	7442                	ld	s0,48(sp)
     fa4:	74a2                	ld	s1,40(sp)
     fa6:	7902                	ld	s2,32(sp)
     fa8:	69e2                	ld	s3,24(sp)
     faa:	6a42                	ld	s4,16(sp)
     fac:	6aa2                	ld	s5,8(sp)
     fae:	6b02                	ld	s6,0(sp)
     fb0:	6121                	addi	sp,sp,64
     fb2:	8082                	ret
      printf("%s: link should not succeed\n", s);
     fb4:	85da                	mv	a1,s6
     fb6:	00006517          	auipc	a0,0x6
     fba:	84250513          	addi	a0,a0,-1982 # 67f8 <malloc+0xb46>
     fbe:	00005097          	auipc	ra,0x5
     fc2:	c36080e7          	jalr	-970(ra) # 5bf4 <printf>
      exit(1);
     fc6:	4505                	li	a0,1
     fc8:	00005097          	auipc	ra,0x5
     fcc:	8a4080e7          	jalr	-1884(ra) # 586c <exit>

0000000000000fd0 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
     fd0:	7179                	addi	sp,sp,-48
     fd2:	f406                	sd	ra,40(sp)
     fd4:	f022                	sd	s0,32(sp)
     fd6:	ec26                	sd	s1,24(sp)
     fd8:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
     fda:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
     fde:	00007497          	auipc	s1,0x7
     fe2:	5a24b483          	ld	s1,1442(s1) # 8580 <__SDATA_BEGIN__>
     fe6:	fd840593          	addi	a1,s0,-40
     fea:	8526                	mv	a0,s1
     fec:	00005097          	auipc	ra,0x5
     ff0:	8b8080e7          	jalr	-1864(ra) # 58a4 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
     ff4:	8526                	mv	a0,s1
     ff6:	00005097          	auipc	ra,0x5
     ffa:	886080e7          	jalr	-1914(ra) # 587c <pipe>

  exit(0);
     ffe:	4501                	li	a0,0
    1000:	00005097          	auipc	ra,0x5
    1004:	86c080e7          	jalr	-1940(ra) # 586c <exit>

0000000000001008 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1008:	7139                	addi	sp,sp,-64
    100a:	fc06                	sd	ra,56(sp)
    100c:	f822                	sd	s0,48(sp)
    100e:	f426                	sd	s1,40(sp)
    1010:	f04a                	sd	s2,32(sp)
    1012:	ec4e                	sd	s3,24(sp)
    1014:	0080                	addi	s0,sp,64
    1016:	64b1                	lui	s1,0xc
    1018:	35048493          	addi	s1,s1,848 # c350 <buf+0x5a8>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    101c:	597d                	li	s2,-1
    101e:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    1022:	00005997          	auipc	s3,0x5
    1026:	10698993          	addi	s3,s3,262 # 6128 <malloc+0x476>
    argv[0] = (char*)0xffffffff;
    102a:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    102e:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1032:	fc040593          	addi	a1,s0,-64
    1036:	854e                	mv	a0,s3
    1038:	00005097          	auipc	ra,0x5
    103c:	86c080e7          	jalr	-1940(ra) # 58a4 <exec>
  for(int i = 0; i < 50000; i++){
    1040:	34fd                	addiw	s1,s1,-1
    1042:	f4e5                	bnez	s1,102a <badarg+0x22>
  }
  
  exit(0);
    1044:	4501                	li	a0,0
    1046:	00005097          	auipc	ra,0x5
    104a:	826080e7          	jalr	-2010(ra) # 586c <exit>

000000000000104e <copyinstr2>:
{
    104e:	7155                	addi	sp,sp,-208
    1050:	e586                	sd	ra,200(sp)
    1052:	e1a2                	sd	s0,192(sp)
    1054:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1056:	f6840793          	addi	a5,s0,-152
    105a:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    105e:	07800713          	li	a4,120
    1062:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    1066:	0785                	addi	a5,a5,1
    1068:	fed79de3          	bne	a5,a3,1062 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    106c:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1070:	f6840513          	addi	a0,s0,-152
    1074:	00005097          	auipc	ra,0x5
    1078:	848080e7          	jalr	-1976(ra) # 58bc <unlink>
  if(ret != -1){
    107c:	57fd                	li	a5,-1
    107e:	0ef51063          	bne	a0,a5,115e <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    1082:	20100593          	li	a1,513
    1086:	f6840513          	addi	a0,s0,-152
    108a:	00005097          	auipc	ra,0x5
    108e:	822080e7          	jalr	-2014(ra) # 58ac <open>
  if(fd != -1){
    1092:	57fd                	li	a5,-1
    1094:	0ef51563          	bne	a0,a5,117e <copyinstr2+0x130>
  ret = link(b, b);
    1098:	f6840593          	addi	a1,s0,-152
    109c:	852e                	mv	a0,a1
    109e:	00005097          	auipc	ra,0x5
    10a2:	82e080e7          	jalr	-2002(ra) # 58cc <link>
  if(ret != -1){
    10a6:	57fd                	li	a5,-1
    10a8:	0ef51b63          	bne	a0,a5,119e <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    10ac:	00007797          	auipc	a5,0x7
    10b0:	93478793          	addi	a5,a5,-1740 # 79e0 <malloc+0x1d2e>
    10b4:	f4f43c23          	sd	a5,-168(s0)
    10b8:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    10bc:	f5840593          	addi	a1,s0,-168
    10c0:	f6840513          	addi	a0,s0,-152
    10c4:	00004097          	auipc	ra,0x4
    10c8:	7e0080e7          	jalr	2016(ra) # 58a4 <exec>
  if(ret != -1){
    10cc:	57fd                	li	a5,-1
    10ce:	0ef51963          	bne	a0,a5,11c0 <copyinstr2+0x172>
  int pid = fork();
    10d2:	00004097          	auipc	ra,0x4
    10d6:	792080e7          	jalr	1938(ra) # 5864 <fork>
  if(pid < 0){
    10da:	10054363          	bltz	a0,11e0 <copyinstr2+0x192>
  if(pid == 0){
    10de:	12051463          	bnez	a0,1206 <copyinstr2+0x1b8>
    10e2:	00007797          	auipc	a5,0x7
    10e6:	5ae78793          	addi	a5,a5,1454 # 8690 <big.1282>
    10ea:	00008697          	auipc	a3,0x8
    10ee:	5a668693          	addi	a3,a3,1446 # 9690 <__global_pointer$+0x910>
      big[i] = 'x';
    10f2:	07800713          	li	a4,120
    10f6:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    10fa:	0785                	addi	a5,a5,1
    10fc:	fed79de3          	bne	a5,a3,10f6 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1100:	00008797          	auipc	a5,0x8
    1104:	58078823          	sb	zero,1424(a5) # 9690 <__global_pointer$+0x910>
    char *args2[] = { big, big, big, 0 };
    1108:	00007797          	auipc	a5,0x7
    110c:	05878793          	addi	a5,a5,88 # 8160 <malloc+0x24ae>
    1110:	6390                	ld	a2,0(a5)
    1112:	6794                	ld	a3,8(a5)
    1114:	6b98                	ld	a4,16(a5)
    1116:	6f9c                	ld	a5,24(a5)
    1118:	f2c43823          	sd	a2,-208(s0)
    111c:	f2d43c23          	sd	a3,-200(s0)
    1120:	f4e43023          	sd	a4,-192(s0)
    1124:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1128:	f3040593          	addi	a1,s0,-208
    112c:	00005517          	auipc	a0,0x5
    1130:	ffc50513          	addi	a0,a0,-4 # 6128 <malloc+0x476>
    1134:	00004097          	auipc	ra,0x4
    1138:	770080e7          	jalr	1904(ra) # 58a4 <exec>
    if(ret != -1){
    113c:	57fd                	li	a5,-1
    113e:	0af50e63          	beq	a0,a5,11fa <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1142:	55fd                	li	a1,-1
    1144:	00005517          	auipc	a0,0x5
    1148:	75c50513          	addi	a0,a0,1884 # 68a0 <malloc+0xbee>
    114c:	00005097          	auipc	ra,0x5
    1150:	aa8080e7          	jalr	-1368(ra) # 5bf4 <printf>
      exit(1);
    1154:	4505                	li	a0,1
    1156:	00004097          	auipc	ra,0x4
    115a:	716080e7          	jalr	1814(ra) # 586c <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    115e:	862a                	mv	a2,a0
    1160:	f6840593          	addi	a1,s0,-152
    1164:	00005517          	auipc	a0,0x5
    1168:	6b450513          	addi	a0,a0,1716 # 6818 <malloc+0xb66>
    116c:	00005097          	auipc	ra,0x5
    1170:	a88080e7          	jalr	-1400(ra) # 5bf4 <printf>
    exit(1);
    1174:	4505                	li	a0,1
    1176:	00004097          	auipc	ra,0x4
    117a:	6f6080e7          	jalr	1782(ra) # 586c <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    117e:	862a                	mv	a2,a0
    1180:	f6840593          	addi	a1,s0,-152
    1184:	00005517          	auipc	a0,0x5
    1188:	6b450513          	addi	a0,a0,1716 # 6838 <malloc+0xb86>
    118c:	00005097          	auipc	ra,0x5
    1190:	a68080e7          	jalr	-1432(ra) # 5bf4 <printf>
    exit(1);
    1194:	4505                	li	a0,1
    1196:	00004097          	auipc	ra,0x4
    119a:	6d6080e7          	jalr	1750(ra) # 586c <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    119e:	86aa                	mv	a3,a0
    11a0:	f6840613          	addi	a2,s0,-152
    11a4:	85b2                	mv	a1,a2
    11a6:	00005517          	auipc	a0,0x5
    11aa:	6b250513          	addi	a0,a0,1714 # 6858 <malloc+0xba6>
    11ae:	00005097          	auipc	ra,0x5
    11b2:	a46080e7          	jalr	-1466(ra) # 5bf4 <printf>
    exit(1);
    11b6:	4505                	li	a0,1
    11b8:	00004097          	auipc	ra,0x4
    11bc:	6b4080e7          	jalr	1716(ra) # 586c <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    11c0:	567d                	li	a2,-1
    11c2:	f6840593          	addi	a1,s0,-152
    11c6:	00005517          	auipc	a0,0x5
    11ca:	6ba50513          	addi	a0,a0,1722 # 6880 <malloc+0xbce>
    11ce:	00005097          	auipc	ra,0x5
    11d2:	a26080e7          	jalr	-1498(ra) # 5bf4 <printf>
    exit(1);
    11d6:	4505                	li	a0,1
    11d8:	00004097          	auipc	ra,0x4
    11dc:	694080e7          	jalr	1684(ra) # 586c <exit>
    printf("fork failed\n");
    11e0:	00006517          	auipc	a0,0x6
    11e4:	b3850513          	addi	a0,a0,-1224 # 6d18 <malloc+0x1066>
    11e8:	00005097          	auipc	ra,0x5
    11ec:	a0c080e7          	jalr	-1524(ra) # 5bf4 <printf>
    exit(1);
    11f0:	4505                	li	a0,1
    11f2:	00004097          	auipc	ra,0x4
    11f6:	67a080e7          	jalr	1658(ra) # 586c <exit>
    exit(747); // OK
    11fa:	2eb00513          	li	a0,747
    11fe:	00004097          	auipc	ra,0x4
    1202:	66e080e7          	jalr	1646(ra) # 586c <exit>
  int st = 0;
    1206:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    120a:	f5440513          	addi	a0,s0,-172
    120e:	00004097          	auipc	ra,0x4
    1212:	666080e7          	jalr	1638(ra) # 5874 <wait>
  if(st != 747){
    1216:	f5442703          	lw	a4,-172(s0)
    121a:	2eb00793          	li	a5,747
    121e:	00f71663          	bne	a4,a5,122a <copyinstr2+0x1dc>
}
    1222:	60ae                	ld	ra,200(sp)
    1224:	640e                	ld	s0,192(sp)
    1226:	6169                	addi	sp,sp,208
    1228:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    122a:	00005517          	auipc	a0,0x5
    122e:	69e50513          	addi	a0,a0,1694 # 68c8 <malloc+0xc16>
    1232:	00005097          	auipc	ra,0x5
    1236:	9c2080e7          	jalr	-1598(ra) # 5bf4 <printf>
    exit(1);
    123a:	4505                	li	a0,1
    123c:	00004097          	auipc	ra,0x4
    1240:	630080e7          	jalr	1584(ra) # 586c <exit>

0000000000001244 <truncate3>:
{
    1244:	7159                	addi	sp,sp,-112
    1246:	f486                	sd	ra,104(sp)
    1248:	f0a2                	sd	s0,96(sp)
    124a:	eca6                	sd	s1,88(sp)
    124c:	e8ca                	sd	s2,80(sp)
    124e:	e4ce                	sd	s3,72(sp)
    1250:	e0d2                	sd	s4,64(sp)
    1252:	fc56                	sd	s5,56(sp)
    1254:	1880                	addi	s0,sp,112
    1256:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    1258:	60100593          	li	a1,1537
    125c:	00005517          	auipc	a0,0x5
    1260:	f2450513          	addi	a0,a0,-220 # 6180 <malloc+0x4ce>
    1264:	00004097          	auipc	ra,0x4
    1268:	648080e7          	jalr	1608(ra) # 58ac <open>
    126c:	00004097          	auipc	ra,0x4
    1270:	628080e7          	jalr	1576(ra) # 5894 <close>
  pid = fork();
    1274:	00004097          	auipc	ra,0x4
    1278:	5f0080e7          	jalr	1520(ra) # 5864 <fork>
  if(pid < 0){
    127c:	08054063          	bltz	a0,12fc <truncate3+0xb8>
  if(pid == 0){
    1280:	e969                	bnez	a0,1352 <truncate3+0x10e>
    1282:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    1286:	00005a17          	auipc	s4,0x5
    128a:	efaa0a13          	addi	s4,s4,-262 # 6180 <malloc+0x4ce>
      int n = write(fd, "1234567890", 10);
    128e:	00005a97          	auipc	s5,0x5
    1292:	69aa8a93          	addi	s5,s5,1690 # 6928 <malloc+0xc76>
      int fd = open("truncfile", O_WRONLY);
    1296:	4585                	li	a1,1
    1298:	8552                	mv	a0,s4
    129a:	00004097          	auipc	ra,0x4
    129e:	612080e7          	jalr	1554(ra) # 58ac <open>
    12a2:	84aa                	mv	s1,a0
      if(fd < 0){
    12a4:	06054a63          	bltz	a0,1318 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    12a8:	4629                	li	a2,10
    12aa:	85d6                	mv	a1,s5
    12ac:	00004097          	auipc	ra,0x4
    12b0:	5e0080e7          	jalr	1504(ra) # 588c <write>
      if(n != 10){
    12b4:	47a9                	li	a5,10
    12b6:	06f51f63          	bne	a0,a5,1334 <truncate3+0xf0>
      close(fd);
    12ba:	8526                	mv	a0,s1
    12bc:	00004097          	auipc	ra,0x4
    12c0:	5d8080e7          	jalr	1496(ra) # 5894 <close>
      fd = open("truncfile", O_RDONLY);
    12c4:	4581                	li	a1,0
    12c6:	8552                	mv	a0,s4
    12c8:	00004097          	auipc	ra,0x4
    12cc:	5e4080e7          	jalr	1508(ra) # 58ac <open>
    12d0:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    12d2:	02000613          	li	a2,32
    12d6:	f9840593          	addi	a1,s0,-104
    12da:	00004097          	auipc	ra,0x4
    12de:	5aa080e7          	jalr	1450(ra) # 5884 <read>
      close(fd);
    12e2:	8526                	mv	a0,s1
    12e4:	00004097          	auipc	ra,0x4
    12e8:	5b0080e7          	jalr	1456(ra) # 5894 <close>
    for(int i = 0; i < 100; i++){
    12ec:	39fd                	addiw	s3,s3,-1
    12ee:	fa0994e3          	bnez	s3,1296 <truncate3+0x52>
    exit(0);
    12f2:	4501                	li	a0,0
    12f4:	00004097          	auipc	ra,0x4
    12f8:	578080e7          	jalr	1400(ra) # 586c <exit>
    printf("%s: fork failed\n", s);
    12fc:	85ca                	mv	a1,s2
    12fe:	00005517          	auipc	a0,0x5
    1302:	5fa50513          	addi	a0,a0,1530 # 68f8 <malloc+0xc46>
    1306:	00005097          	auipc	ra,0x5
    130a:	8ee080e7          	jalr	-1810(ra) # 5bf4 <printf>
    exit(1);
    130e:	4505                	li	a0,1
    1310:	00004097          	auipc	ra,0x4
    1314:	55c080e7          	jalr	1372(ra) # 586c <exit>
        printf("%s: open failed\n", s);
    1318:	85ca                	mv	a1,s2
    131a:	00005517          	auipc	a0,0x5
    131e:	5f650513          	addi	a0,a0,1526 # 6910 <malloc+0xc5e>
    1322:	00005097          	auipc	ra,0x5
    1326:	8d2080e7          	jalr	-1838(ra) # 5bf4 <printf>
        exit(1);
    132a:	4505                	li	a0,1
    132c:	00004097          	auipc	ra,0x4
    1330:	540080e7          	jalr	1344(ra) # 586c <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1334:	862a                	mv	a2,a0
    1336:	85ca                	mv	a1,s2
    1338:	00005517          	auipc	a0,0x5
    133c:	60050513          	addi	a0,a0,1536 # 6938 <malloc+0xc86>
    1340:	00005097          	auipc	ra,0x5
    1344:	8b4080e7          	jalr	-1868(ra) # 5bf4 <printf>
        exit(1);
    1348:	4505                	li	a0,1
    134a:	00004097          	auipc	ra,0x4
    134e:	522080e7          	jalr	1314(ra) # 586c <exit>
    1352:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1356:	00005a17          	auipc	s4,0x5
    135a:	e2aa0a13          	addi	s4,s4,-470 # 6180 <malloc+0x4ce>
    int n = write(fd, "xxx", 3);
    135e:	00005a97          	auipc	s5,0x5
    1362:	5faa8a93          	addi	s5,s5,1530 # 6958 <malloc+0xca6>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1366:	60100593          	li	a1,1537
    136a:	8552                	mv	a0,s4
    136c:	00004097          	auipc	ra,0x4
    1370:	540080e7          	jalr	1344(ra) # 58ac <open>
    1374:	84aa                	mv	s1,a0
    if(fd < 0){
    1376:	04054763          	bltz	a0,13c4 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    137a:	460d                	li	a2,3
    137c:	85d6                	mv	a1,s5
    137e:	00004097          	auipc	ra,0x4
    1382:	50e080e7          	jalr	1294(ra) # 588c <write>
    if(n != 3){
    1386:	478d                	li	a5,3
    1388:	04f51c63          	bne	a0,a5,13e0 <truncate3+0x19c>
    close(fd);
    138c:	8526                	mv	a0,s1
    138e:	00004097          	auipc	ra,0x4
    1392:	506080e7          	jalr	1286(ra) # 5894 <close>
  for(int i = 0; i < 150; i++){
    1396:	39fd                	addiw	s3,s3,-1
    1398:	fc0997e3          	bnez	s3,1366 <truncate3+0x122>
  wait(&xstatus);
    139c:	fbc40513          	addi	a0,s0,-68
    13a0:	00004097          	auipc	ra,0x4
    13a4:	4d4080e7          	jalr	1236(ra) # 5874 <wait>
  unlink("truncfile");
    13a8:	00005517          	auipc	a0,0x5
    13ac:	dd850513          	addi	a0,a0,-552 # 6180 <malloc+0x4ce>
    13b0:	00004097          	auipc	ra,0x4
    13b4:	50c080e7          	jalr	1292(ra) # 58bc <unlink>
  exit(xstatus);
    13b8:	fbc42503          	lw	a0,-68(s0)
    13bc:	00004097          	auipc	ra,0x4
    13c0:	4b0080e7          	jalr	1200(ra) # 586c <exit>
      printf("%s: open failed\n", s);
    13c4:	85ca                	mv	a1,s2
    13c6:	00005517          	auipc	a0,0x5
    13ca:	54a50513          	addi	a0,a0,1354 # 6910 <malloc+0xc5e>
    13ce:	00005097          	auipc	ra,0x5
    13d2:	826080e7          	jalr	-2010(ra) # 5bf4 <printf>
      exit(1);
    13d6:	4505                	li	a0,1
    13d8:	00004097          	auipc	ra,0x4
    13dc:	494080e7          	jalr	1172(ra) # 586c <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    13e0:	862a                	mv	a2,a0
    13e2:	85ca                	mv	a1,s2
    13e4:	00005517          	auipc	a0,0x5
    13e8:	57c50513          	addi	a0,a0,1404 # 6960 <malloc+0xcae>
    13ec:	00005097          	auipc	ra,0x5
    13f0:	808080e7          	jalr	-2040(ra) # 5bf4 <printf>
      exit(1);
    13f4:	4505                	li	a0,1
    13f6:	00004097          	auipc	ra,0x4
    13fa:	476080e7          	jalr	1142(ra) # 586c <exit>

00000000000013fe <exectest>:
{
    13fe:	715d                	addi	sp,sp,-80
    1400:	e486                	sd	ra,72(sp)
    1402:	e0a2                	sd	s0,64(sp)
    1404:	fc26                	sd	s1,56(sp)
    1406:	f84a                	sd	s2,48(sp)
    1408:	0880                	addi	s0,sp,80
    140a:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    140c:	00005797          	auipc	a5,0x5
    1410:	d1c78793          	addi	a5,a5,-740 # 6128 <malloc+0x476>
    1414:	fcf43023          	sd	a5,-64(s0)
    1418:	00005797          	auipc	a5,0x5
    141c:	56878793          	addi	a5,a5,1384 # 6980 <malloc+0xcce>
    1420:	fcf43423          	sd	a5,-56(s0)
    1424:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1428:	00005517          	auipc	a0,0x5
    142c:	56050513          	addi	a0,a0,1376 # 6988 <malloc+0xcd6>
    1430:	00004097          	auipc	ra,0x4
    1434:	48c080e7          	jalr	1164(ra) # 58bc <unlink>
  pid = fork();
    1438:	00004097          	auipc	ra,0x4
    143c:	42c080e7          	jalr	1068(ra) # 5864 <fork>
  if(pid < 0) {
    1440:	04054663          	bltz	a0,148c <exectest+0x8e>
    1444:	84aa                	mv	s1,a0
  if(pid == 0) {
    1446:	e959                	bnez	a0,14dc <exectest+0xde>
    close(1);
    1448:	4505                	li	a0,1
    144a:	00004097          	auipc	ra,0x4
    144e:	44a080e7          	jalr	1098(ra) # 5894 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1452:	20100593          	li	a1,513
    1456:	00005517          	auipc	a0,0x5
    145a:	53250513          	addi	a0,a0,1330 # 6988 <malloc+0xcd6>
    145e:	00004097          	auipc	ra,0x4
    1462:	44e080e7          	jalr	1102(ra) # 58ac <open>
    if(fd < 0) {
    1466:	04054163          	bltz	a0,14a8 <exectest+0xaa>
    if(fd != 1) {
    146a:	4785                	li	a5,1
    146c:	04f50c63          	beq	a0,a5,14c4 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    1470:	85ca                	mv	a1,s2
    1472:	00005517          	auipc	a0,0x5
    1476:	53650513          	addi	a0,a0,1334 # 69a8 <malloc+0xcf6>
    147a:	00004097          	auipc	ra,0x4
    147e:	77a080e7          	jalr	1914(ra) # 5bf4 <printf>
      exit(1);
    1482:	4505                	li	a0,1
    1484:	00004097          	auipc	ra,0x4
    1488:	3e8080e7          	jalr	1000(ra) # 586c <exit>
     printf("%s: fork failed\n", s);
    148c:	85ca                	mv	a1,s2
    148e:	00005517          	auipc	a0,0x5
    1492:	46a50513          	addi	a0,a0,1130 # 68f8 <malloc+0xc46>
    1496:	00004097          	auipc	ra,0x4
    149a:	75e080e7          	jalr	1886(ra) # 5bf4 <printf>
     exit(1);
    149e:	4505                	li	a0,1
    14a0:	00004097          	auipc	ra,0x4
    14a4:	3cc080e7          	jalr	972(ra) # 586c <exit>
      printf("%s: create failed\n", s);
    14a8:	85ca                	mv	a1,s2
    14aa:	00005517          	auipc	a0,0x5
    14ae:	4e650513          	addi	a0,a0,1254 # 6990 <malloc+0xcde>
    14b2:	00004097          	auipc	ra,0x4
    14b6:	742080e7          	jalr	1858(ra) # 5bf4 <printf>
      exit(1);
    14ba:	4505                	li	a0,1
    14bc:	00004097          	auipc	ra,0x4
    14c0:	3b0080e7          	jalr	944(ra) # 586c <exit>
    if(exec("echo", echoargv) < 0){
    14c4:	fc040593          	addi	a1,s0,-64
    14c8:	00005517          	auipc	a0,0x5
    14cc:	c6050513          	addi	a0,a0,-928 # 6128 <malloc+0x476>
    14d0:	00004097          	auipc	ra,0x4
    14d4:	3d4080e7          	jalr	980(ra) # 58a4 <exec>
    14d8:	02054163          	bltz	a0,14fa <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    14dc:	fdc40513          	addi	a0,s0,-36
    14e0:	00004097          	auipc	ra,0x4
    14e4:	394080e7          	jalr	916(ra) # 5874 <wait>
    14e8:	02951763          	bne	a0,s1,1516 <exectest+0x118>
  if(xstatus != 0)
    14ec:	fdc42503          	lw	a0,-36(s0)
    14f0:	cd0d                	beqz	a0,152a <exectest+0x12c>
    exit(xstatus);
    14f2:	00004097          	auipc	ra,0x4
    14f6:	37a080e7          	jalr	890(ra) # 586c <exit>
      printf("%s: exec echo failed\n", s);
    14fa:	85ca                	mv	a1,s2
    14fc:	00005517          	auipc	a0,0x5
    1500:	4bc50513          	addi	a0,a0,1212 # 69b8 <malloc+0xd06>
    1504:	00004097          	auipc	ra,0x4
    1508:	6f0080e7          	jalr	1776(ra) # 5bf4 <printf>
      exit(1);
    150c:	4505                	li	a0,1
    150e:	00004097          	auipc	ra,0x4
    1512:	35e080e7          	jalr	862(ra) # 586c <exit>
    printf("%s: wait failed!\n", s);
    1516:	85ca                	mv	a1,s2
    1518:	00005517          	auipc	a0,0x5
    151c:	4b850513          	addi	a0,a0,1208 # 69d0 <malloc+0xd1e>
    1520:	00004097          	auipc	ra,0x4
    1524:	6d4080e7          	jalr	1748(ra) # 5bf4 <printf>
    1528:	b7d1                	j	14ec <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    152a:	4581                	li	a1,0
    152c:	00005517          	auipc	a0,0x5
    1530:	45c50513          	addi	a0,a0,1116 # 6988 <malloc+0xcd6>
    1534:	00004097          	auipc	ra,0x4
    1538:	378080e7          	jalr	888(ra) # 58ac <open>
  if(fd < 0) {
    153c:	02054a63          	bltz	a0,1570 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    1540:	4609                	li	a2,2
    1542:	fb840593          	addi	a1,s0,-72
    1546:	00004097          	auipc	ra,0x4
    154a:	33e080e7          	jalr	830(ra) # 5884 <read>
    154e:	4789                	li	a5,2
    1550:	02f50e63          	beq	a0,a5,158c <exectest+0x18e>
    printf("%s: read failed\n", s);
    1554:	85ca                	mv	a1,s2
    1556:	00005517          	auipc	a0,0x5
    155a:	f6250513          	addi	a0,a0,-158 # 64b8 <malloc+0x806>
    155e:	00004097          	auipc	ra,0x4
    1562:	696080e7          	jalr	1686(ra) # 5bf4 <printf>
    exit(1);
    1566:	4505                	li	a0,1
    1568:	00004097          	auipc	ra,0x4
    156c:	304080e7          	jalr	772(ra) # 586c <exit>
    printf("%s: open failed\n", s);
    1570:	85ca                	mv	a1,s2
    1572:	00005517          	auipc	a0,0x5
    1576:	39e50513          	addi	a0,a0,926 # 6910 <malloc+0xc5e>
    157a:	00004097          	auipc	ra,0x4
    157e:	67a080e7          	jalr	1658(ra) # 5bf4 <printf>
    exit(1);
    1582:	4505                	li	a0,1
    1584:	00004097          	auipc	ra,0x4
    1588:	2e8080e7          	jalr	744(ra) # 586c <exit>
  unlink("echo-ok");
    158c:	00005517          	auipc	a0,0x5
    1590:	3fc50513          	addi	a0,a0,1020 # 6988 <malloc+0xcd6>
    1594:	00004097          	auipc	ra,0x4
    1598:	328080e7          	jalr	808(ra) # 58bc <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    159c:	fb844703          	lbu	a4,-72(s0)
    15a0:	04f00793          	li	a5,79
    15a4:	00f71863          	bne	a4,a5,15b4 <exectest+0x1b6>
    15a8:	fb944703          	lbu	a4,-71(s0)
    15ac:	04b00793          	li	a5,75
    15b0:	02f70063          	beq	a4,a5,15d0 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    15b4:	85ca                	mv	a1,s2
    15b6:	00005517          	auipc	a0,0x5
    15ba:	43250513          	addi	a0,a0,1074 # 69e8 <malloc+0xd36>
    15be:	00004097          	auipc	ra,0x4
    15c2:	636080e7          	jalr	1590(ra) # 5bf4 <printf>
    exit(1);
    15c6:	4505                	li	a0,1
    15c8:	00004097          	auipc	ra,0x4
    15cc:	2a4080e7          	jalr	676(ra) # 586c <exit>
    exit(0);
    15d0:	4501                	li	a0,0
    15d2:	00004097          	auipc	ra,0x4
    15d6:	29a080e7          	jalr	666(ra) # 586c <exit>

00000000000015da <pipe1>:
{
    15da:	711d                	addi	sp,sp,-96
    15dc:	ec86                	sd	ra,88(sp)
    15de:	e8a2                	sd	s0,80(sp)
    15e0:	e4a6                	sd	s1,72(sp)
    15e2:	e0ca                	sd	s2,64(sp)
    15e4:	fc4e                	sd	s3,56(sp)
    15e6:	f852                	sd	s4,48(sp)
    15e8:	f456                	sd	s5,40(sp)
    15ea:	f05a                	sd	s6,32(sp)
    15ec:	ec5e                	sd	s7,24(sp)
    15ee:	1080                	addi	s0,sp,96
    15f0:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    15f2:	fa840513          	addi	a0,s0,-88
    15f6:	00004097          	auipc	ra,0x4
    15fa:	286080e7          	jalr	646(ra) # 587c <pipe>
    15fe:	ed25                	bnez	a0,1676 <pipe1+0x9c>
    1600:	84aa                	mv	s1,a0
  pid = fork();
    1602:	00004097          	auipc	ra,0x4
    1606:	262080e7          	jalr	610(ra) # 5864 <fork>
    160a:	8a2a                	mv	s4,a0
  if(pid == 0){
    160c:	c159                	beqz	a0,1692 <pipe1+0xb8>
  } else if(pid > 0){
    160e:	16a05e63          	blez	a0,178a <pipe1+0x1b0>
    close(fds[1]);
    1612:	fac42503          	lw	a0,-84(s0)
    1616:	00004097          	auipc	ra,0x4
    161a:	27e080e7          	jalr	638(ra) # 5894 <close>
    total = 0;
    161e:	8a26                	mv	s4,s1
    cc = 1;
    1620:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1622:	0000aa97          	auipc	s5,0xa
    1626:	786a8a93          	addi	s5,s5,1926 # bda8 <buf>
      if(cc > sizeof(buf))
    162a:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    162c:	864e                	mv	a2,s3
    162e:	85d6                	mv	a1,s5
    1630:	fa842503          	lw	a0,-88(s0)
    1634:	00004097          	auipc	ra,0x4
    1638:	250080e7          	jalr	592(ra) # 5884 <read>
    163c:	10a05263          	blez	a0,1740 <pipe1+0x166>
      for(i = 0; i < n; i++){
    1640:	0000a717          	auipc	a4,0xa
    1644:	76870713          	addi	a4,a4,1896 # bda8 <buf>
    1648:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    164c:	00074683          	lbu	a3,0(a4)
    1650:	0ff4f793          	andi	a5,s1,255
    1654:	2485                	addiw	s1,s1,1
    1656:	0cf69163          	bne	a3,a5,1718 <pipe1+0x13e>
      for(i = 0; i < n; i++){
    165a:	0705                	addi	a4,a4,1
    165c:	fec498e3          	bne	s1,a2,164c <pipe1+0x72>
      total += n;
    1660:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    1664:	0019979b          	slliw	a5,s3,0x1
    1668:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    166c:	013b7363          	bgeu	s6,s3,1672 <pipe1+0x98>
        cc = sizeof(buf);
    1670:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1672:	84b2                	mv	s1,a2
    1674:	bf65                	j	162c <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    1676:	85ca                	mv	a1,s2
    1678:	00005517          	auipc	a0,0x5
    167c:	38850513          	addi	a0,a0,904 # 6a00 <malloc+0xd4e>
    1680:	00004097          	auipc	ra,0x4
    1684:	574080e7          	jalr	1396(ra) # 5bf4 <printf>
    exit(1);
    1688:	4505                	li	a0,1
    168a:	00004097          	auipc	ra,0x4
    168e:	1e2080e7          	jalr	482(ra) # 586c <exit>
    close(fds[0]);
    1692:	fa842503          	lw	a0,-88(s0)
    1696:	00004097          	auipc	ra,0x4
    169a:	1fe080e7          	jalr	510(ra) # 5894 <close>
    for(n = 0; n < N; n++){
    169e:	0000ab17          	auipc	s6,0xa
    16a2:	70ab0b13          	addi	s6,s6,1802 # bda8 <buf>
    16a6:	416004bb          	negw	s1,s6
    16aa:	0ff4f493          	andi	s1,s1,255
    16ae:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    16b2:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    16b4:	6a85                	lui	s5,0x1
    16b6:	42da8a93          	addi	s5,s5,1069 # 142d <exectest+0x2f>
{
    16ba:	87da                	mv	a5,s6
        buf[i] = seq++;
    16bc:	0097873b          	addw	a4,a5,s1
    16c0:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    16c4:	0785                	addi	a5,a5,1
    16c6:	fef99be3          	bne	s3,a5,16bc <pipe1+0xe2>
    16ca:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    16ce:	40900613          	li	a2,1033
    16d2:	85de                	mv	a1,s7
    16d4:	fac42503          	lw	a0,-84(s0)
    16d8:	00004097          	auipc	ra,0x4
    16dc:	1b4080e7          	jalr	436(ra) # 588c <write>
    16e0:	40900793          	li	a5,1033
    16e4:	00f51c63          	bne	a0,a5,16fc <pipe1+0x122>
    for(n = 0; n < N; n++){
    16e8:	24a5                	addiw	s1,s1,9
    16ea:	0ff4f493          	andi	s1,s1,255
    16ee:	fd5a16e3          	bne	s4,s5,16ba <pipe1+0xe0>
    exit(0);
    16f2:	4501                	li	a0,0
    16f4:	00004097          	auipc	ra,0x4
    16f8:	178080e7          	jalr	376(ra) # 586c <exit>
        printf("%s: pipe1 oops 1\n", s);
    16fc:	85ca                	mv	a1,s2
    16fe:	00005517          	auipc	a0,0x5
    1702:	31a50513          	addi	a0,a0,794 # 6a18 <malloc+0xd66>
    1706:	00004097          	auipc	ra,0x4
    170a:	4ee080e7          	jalr	1262(ra) # 5bf4 <printf>
        exit(1);
    170e:	4505                	li	a0,1
    1710:	00004097          	auipc	ra,0x4
    1714:	15c080e7          	jalr	348(ra) # 586c <exit>
          printf("%s: pipe1 oops 2\n", s);
    1718:	85ca                	mv	a1,s2
    171a:	00005517          	auipc	a0,0x5
    171e:	31650513          	addi	a0,a0,790 # 6a30 <malloc+0xd7e>
    1722:	00004097          	auipc	ra,0x4
    1726:	4d2080e7          	jalr	1234(ra) # 5bf4 <printf>
}
    172a:	60e6                	ld	ra,88(sp)
    172c:	6446                	ld	s0,80(sp)
    172e:	64a6                	ld	s1,72(sp)
    1730:	6906                	ld	s2,64(sp)
    1732:	79e2                	ld	s3,56(sp)
    1734:	7a42                	ld	s4,48(sp)
    1736:	7aa2                	ld	s5,40(sp)
    1738:	7b02                	ld	s6,32(sp)
    173a:	6be2                	ld	s7,24(sp)
    173c:	6125                	addi	sp,sp,96
    173e:	8082                	ret
    if(total != N * SZ){
    1740:	6785                	lui	a5,0x1
    1742:	42d78793          	addi	a5,a5,1069 # 142d <exectest+0x2f>
    1746:	02fa0063          	beq	s4,a5,1766 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    174a:	85d2                	mv	a1,s4
    174c:	00005517          	auipc	a0,0x5
    1750:	2fc50513          	addi	a0,a0,764 # 6a48 <malloc+0xd96>
    1754:	00004097          	auipc	ra,0x4
    1758:	4a0080e7          	jalr	1184(ra) # 5bf4 <printf>
      exit(1);
    175c:	4505                	li	a0,1
    175e:	00004097          	auipc	ra,0x4
    1762:	10e080e7          	jalr	270(ra) # 586c <exit>
    close(fds[0]);
    1766:	fa842503          	lw	a0,-88(s0)
    176a:	00004097          	auipc	ra,0x4
    176e:	12a080e7          	jalr	298(ra) # 5894 <close>
    wait(&xstatus);
    1772:	fa440513          	addi	a0,s0,-92
    1776:	00004097          	auipc	ra,0x4
    177a:	0fe080e7          	jalr	254(ra) # 5874 <wait>
    exit(xstatus);
    177e:	fa442503          	lw	a0,-92(s0)
    1782:	00004097          	auipc	ra,0x4
    1786:	0ea080e7          	jalr	234(ra) # 586c <exit>
    printf("%s: fork() failed\n", s);
    178a:	85ca                	mv	a1,s2
    178c:	00005517          	auipc	a0,0x5
    1790:	2dc50513          	addi	a0,a0,732 # 6a68 <malloc+0xdb6>
    1794:	00004097          	auipc	ra,0x4
    1798:	460080e7          	jalr	1120(ra) # 5bf4 <printf>
    exit(1);
    179c:	4505                	li	a0,1
    179e:	00004097          	auipc	ra,0x4
    17a2:	0ce080e7          	jalr	206(ra) # 586c <exit>

00000000000017a6 <exitwait>:
{
    17a6:	7139                	addi	sp,sp,-64
    17a8:	fc06                	sd	ra,56(sp)
    17aa:	f822                	sd	s0,48(sp)
    17ac:	f426                	sd	s1,40(sp)
    17ae:	f04a                	sd	s2,32(sp)
    17b0:	ec4e                	sd	s3,24(sp)
    17b2:	e852                	sd	s4,16(sp)
    17b4:	0080                	addi	s0,sp,64
    17b6:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    17b8:	4901                	li	s2,0
    17ba:	06400993          	li	s3,100
    pid = fork();
    17be:	00004097          	auipc	ra,0x4
    17c2:	0a6080e7          	jalr	166(ra) # 5864 <fork>
    17c6:	84aa                	mv	s1,a0
    if(pid < 0){
    17c8:	02054a63          	bltz	a0,17fc <exitwait+0x56>
    if(pid){
    17cc:	c151                	beqz	a0,1850 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    17ce:	fcc40513          	addi	a0,s0,-52
    17d2:	00004097          	auipc	ra,0x4
    17d6:	0a2080e7          	jalr	162(ra) # 5874 <wait>
    17da:	02951f63          	bne	a0,s1,1818 <exitwait+0x72>
      if(i != xstate) {
    17de:	fcc42783          	lw	a5,-52(s0)
    17e2:	05279963          	bne	a5,s2,1834 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    17e6:	2905                	addiw	s2,s2,1
    17e8:	fd391be3          	bne	s2,s3,17be <exitwait+0x18>
}
    17ec:	70e2                	ld	ra,56(sp)
    17ee:	7442                	ld	s0,48(sp)
    17f0:	74a2                	ld	s1,40(sp)
    17f2:	7902                	ld	s2,32(sp)
    17f4:	69e2                	ld	s3,24(sp)
    17f6:	6a42                	ld	s4,16(sp)
    17f8:	6121                	addi	sp,sp,64
    17fa:	8082                	ret
      printf("%s: fork failed\n", s);
    17fc:	85d2                	mv	a1,s4
    17fe:	00005517          	auipc	a0,0x5
    1802:	0fa50513          	addi	a0,a0,250 # 68f8 <malloc+0xc46>
    1806:	00004097          	auipc	ra,0x4
    180a:	3ee080e7          	jalr	1006(ra) # 5bf4 <printf>
      exit(1);
    180e:	4505                	li	a0,1
    1810:	00004097          	auipc	ra,0x4
    1814:	05c080e7          	jalr	92(ra) # 586c <exit>
        printf("%s: wait wrong pid\n", s);
    1818:	85d2                	mv	a1,s4
    181a:	00005517          	auipc	a0,0x5
    181e:	26650513          	addi	a0,a0,614 # 6a80 <malloc+0xdce>
    1822:	00004097          	auipc	ra,0x4
    1826:	3d2080e7          	jalr	978(ra) # 5bf4 <printf>
        exit(1);
    182a:	4505                	li	a0,1
    182c:	00004097          	auipc	ra,0x4
    1830:	040080e7          	jalr	64(ra) # 586c <exit>
        printf("%s: wait wrong exit status\n", s);
    1834:	85d2                	mv	a1,s4
    1836:	00005517          	auipc	a0,0x5
    183a:	26250513          	addi	a0,a0,610 # 6a98 <malloc+0xde6>
    183e:	00004097          	auipc	ra,0x4
    1842:	3b6080e7          	jalr	950(ra) # 5bf4 <printf>
        exit(1);
    1846:	4505                	li	a0,1
    1848:	00004097          	auipc	ra,0x4
    184c:	024080e7          	jalr	36(ra) # 586c <exit>
      exit(i);
    1850:	854a                	mv	a0,s2
    1852:	00004097          	auipc	ra,0x4
    1856:	01a080e7          	jalr	26(ra) # 586c <exit>

000000000000185a <twochildren>:
{
    185a:	1101                	addi	sp,sp,-32
    185c:	ec06                	sd	ra,24(sp)
    185e:	e822                	sd	s0,16(sp)
    1860:	e426                	sd	s1,8(sp)
    1862:	e04a                	sd	s2,0(sp)
    1864:	1000                	addi	s0,sp,32
    1866:	892a                	mv	s2,a0
    1868:	3e800493          	li	s1,1000
    int pid1 = fork();
    186c:	00004097          	auipc	ra,0x4
    1870:	ff8080e7          	jalr	-8(ra) # 5864 <fork>
    if(pid1 < 0){
    1874:	02054c63          	bltz	a0,18ac <twochildren+0x52>
    if(pid1 == 0){
    1878:	c921                	beqz	a0,18c8 <twochildren+0x6e>
      int pid2 = fork();
    187a:	00004097          	auipc	ra,0x4
    187e:	fea080e7          	jalr	-22(ra) # 5864 <fork>
      if(pid2 < 0){
    1882:	04054763          	bltz	a0,18d0 <twochildren+0x76>
      if(pid2 == 0){
    1886:	c13d                	beqz	a0,18ec <twochildren+0x92>
        wait(0);
    1888:	4501                	li	a0,0
    188a:	00004097          	auipc	ra,0x4
    188e:	fea080e7          	jalr	-22(ra) # 5874 <wait>
        wait(0);
    1892:	4501                	li	a0,0
    1894:	00004097          	auipc	ra,0x4
    1898:	fe0080e7          	jalr	-32(ra) # 5874 <wait>
  for(int i = 0; i < 1000; i++){
    189c:	34fd                	addiw	s1,s1,-1
    189e:	f4f9                	bnez	s1,186c <twochildren+0x12>
}
    18a0:	60e2                	ld	ra,24(sp)
    18a2:	6442                	ld	s0,16(sp)
    18a4:	64a2                	ld	s1,8(sp)
    18a6:	6902                	ld	s2,0(sp)
    18a8:	6105                	addi	sp,sp,32
    18aa:	8082                	ret
      printf("%s: fork failed\n", s);
    18ac:	85ca                	mv	a1,s2
    18ae:	00005517          	auipc	a0,0x5
    18b2:	04a50513          	addi	a0,a0,74 # 68f8 <malloc+0xc46>
    18b6:	00004097          	auipc	ra,0x4
    18ba:	33e080e7          	jalr	830(ra) # 5bf4 <printf>
      exit(1);
    18be:	4505                	li	a0,1
    18c0:	00004097          	auipc	ra,0x4
    18c4:	fac080e7          	jalr	-84(ra) # 586c <exit>
      exit(0);
    18c8:	00004097          	auipc	ra,0x4
    18cc:	fa4080e7          	jalr	-92(ra) # 586c <exit>
        printf("%s: fork failed\n", s);
    18d0:	85ca                	mv	a1,s2
    18d2:	00005517          	auipc	a0,0x5
    18d6:	02650513          	addi	a0,a0,38 # 68f8 <malloc+0xc46>
    18da:	00004097          	auipc	ra,0x4
    18de:	31a080e7          	jalr	794(ra) # 5bf4 <printf>
        exit(1);
    18e2:	4505                	li	a0,1
    18e4:	00004097          	auipc	ra,0x4
    18e8:	f88080e7          	jalr	-120(ra) # 586c <exit>
        exit(0);
    18ec:	00004097          	auipc	ra,0x4
    18f0:	f80080e7          	jalr	-128(ra) # 586c <exit>

00000000000018f4 <forkfork>:
{
    18f4:	7179                	addi	sp,sp,-48
    18f6:	f406                	sd	ra,40(sp)
    18f8:	f022                	sd	s0,32(sp)
    18fa:	ec26                	sd	s1,24(sp)
    18fc:	1800                	addi	s0,sp,48
    18fe:	84aa                	mv	s1,a0
    int pid = fork();
    1900:	00004097          	auipc	ra,0x4
    1904:	f64080e7          	jalr	-156(ra) # 5864 <fork>
    if(pid < 0){
    1908:	04054163          	bltz	a0,194a <forkfork+0x56>
    if(pid == 0){
    190c:	cd29                	beqz	a0,1966 <forkfork+0x72>
    int pid = fork();
    190e:	00004097          	auipc	ra,0x4
    1912:	f56080e7          	jalr	-170(ra) # 5864 <fork>
    if(pid < 0){
    1916:	02054a63          	bltz	a0,194a <forkfork+0x56>
    if(pid == 0){
    191a:	c531                	beqz	a0,1966 <forkfork+0x72>
    wait(&xstatus);
    191c:	fdc40513          	addi	a0,s0,-36
    1920:	00004097          	auipc	ra,0x4
    1924:	f54080e7          	jalr	-172(ra) # 5874 <wait>
    if(xstatus != 0) {
    1928:	fdc42783          	lw	a5,-36(s0)
    192c:	ebbd                	bnez	a5,19a2 <forkfork+0xae>
    wait(&xstatus);
    192e:	fdc40513          	addi	a0,s0,-36
    1932:	00004097          	auipc	ra,0x4
    1936:	f42080e7          	jalr	-190(ra) # 5874 <wait>
    if(xstatus != 0) {
    193a:	fdc42783          	lw	a5,-36(s0)
    193e:	e3b5                	bnez	a5,19a2 <forkfork+0xae>
}
    1940:	70a2                	ld	ra,40(sp)
    1942:	7402                	ld	s0,32(sp)
    1944:	64e2                	ld	s1,24(sp)
    1946:	6145                	addi	sp,sp,48
    1948:	8082                	ret
      printf("%s: fork failed", s);
    194a:	85a6                	mv	a1,s1
    194c:	00005517          	auipc	a0,0x5
    1950:	16c50513          	addi	a0,a0,364 # 6ab8 <malloc+0xe06>
    1954:	00004097          	auipc	ra,0x4
    1958:	2a0080e7          	jalr	672(ra) # 5bf4 <printf>
      exit(1);
    195c:	4505                	li	a0,1
    195e:	00004097          	auipc	ra,0x4
    1962:	f0e080e7          	jalr	-242(ra) # 586c <exit>
{
    1966:	0c800493          	li	s1,200
        int pid1 = fork();
    196a:	00004097          	auipc	ra,0x4
    196e:	efa080e7          	jalr	-262(ra) # 5864 <fork>
        if(pid1 < 0){
    1972:	00054f63          	bltz	a0,1990 <forkfork+0x9c>
        if(pid1 == 0){
    1976:	c115                	beqz	a0,199a <forkfork+0xa6>
        wait(0);
    1978:	4501                	li	a0,0
    197a:	00004097          	auipc	ra,0x4
    197e:	efa080e7          	jalr	-262(ra) # 5874 <wait>
      for(int j = 0; j < 200; j++){
    1982:	34fd                	addiw	s1,s1,-1
    1984:	f0fd                	bnez	s1,196a <forkfork+0x76>
      exit(0);
    1986:	4501                	li	a0,0
    1988:	00004097          	auipc	ra,0x4
    198c:	ee4080e7          	jalr	-284(ra) # 586c <exit>
          exit(1);
    1990:	4505                	li	a0,1
    1992:	00004097          	auipc	ra,0x4
    1996:	eda080e7          	jalr	-294(ra) # 586c <exit>
          exit(0);
    199a:	00004097          	auipc	ra,0x4
    199e:	ed2080e7          	jalr	-302(ra) # 586c <exit>
      printf("%s: fork in child failed", s);
    19a2:	85a6                	mv	a1,s1
    19a4:	00005517          	auipc	a0,0x5
    19a8:	12450513          	addi	a0,a0,292 # 6ac8 <malloc+0xe16>
    19ac:	00004097          	auipc	ra,0x4
    19b0:	248080e7          	jalr	584(ra) # 5bf4 <printf>
      exit(1);
    19b4:	4505                	li	a0,1
    19b6:	00004097          	auipc	ra,0x4
    19ba:	eb6080e7          	jalr	-330(ra) # 586c <exit>

00000000000019be <reparent2>:
{
    19be:	1101                	addi	sp,sp,-32
    19c0:	ec06                	sd	ra,24(sp)
    19c2:	e822                	sd	s0,16(sp)
    19c4:	e426                	sd	s1,8(sp)
    19c6:	1000                	addi	s0,sp,32
    19c8:	32000493          	li	s1,800
    int pid1 = fork();
    19cc:	00004097          	auipc	ra,0x4
    19d0:	e98080e7          	jalr	-360(ra) # 5864 <fork>
    if(pid1 < 0){
    19d4:	00054f63          	bltz	a0,19f2 <reparent2+0x34>
    if(pid1 == 0){
    19d8:	c915                	beqz	a0,1a0c <reparent2+0x4e>
    wait(0);
    19da:	4501                	li	a0,0
    19dc:	00004097          	auipc	ra,0x4
    19e0:	e98080e7          	jalr	-360(ra) # 5874 <wait>
  for(int i = 0; i < 800; i++){
    19e4:	34fd                	addiw	s1,s1,-1
    19e6:	f0fd                	bnez	s1,19cc <reparent2+0xe>
  exit(0);
    19e8:	4501                	li	a0,0
    19ea:	00004097          	auipc	ra,0x4
    19ee:	e82080e7          	jalr	-382(ra) # 586c <exit>
      printf("fork failed\n");
    19f2:	00005517          	auipc	a0,0x5
    19f6:	32650513          	addi	a0,a0,806 # 6d18 <malloc+0x1066>
    19fa:	00004097          	auipc	ra,0x4
    19fe:	1fa080e7          	jalr	506(ra) # 5bf4 <printf>
      exit(1);
    1a02:	4505                	li	a0,1
    1a04:	00004097          	auipc	ra,0x4
    1a08:	e68080e7          	jalr	-408(ra) # 586c <exit>
      fork();
    1a0c:	00004097          	auipc	ra,0x4
    1a10:	e58080e7          	jalr	-424(ra) # 5864 <fork>
      fork();
    1a14:	00004097          	auipc	ra,0x4
    1a18:	e50080e7          	jalr	-432(ra) # 5864 <fork>
      exit(0);
    1a1c:	4501                	li	a0,0
    1a1e:	00004097          	auipc	ra,0x4
    1a22:	e4e080e7          	jalr	-434(ra) # 586c <exit>

0000000000001a26 <createdelete>:
{
    1a26:	7175                	addi	sp,sp,-144
    1a28:	e506                	sd	ra,136(sp)
    1a2a:	e122                	sd	s0,128(sp)
    1a2c:	fca6                	sd	s1,120(sp)
    1a2e:	f8ca                	sd	s2,112(sp)
    1a30:	f4ce                	sd	s3,104(sp)
    1a32:	f0d2                	sd	s4,96(sp)
    1a34:	ecd6                	sd	s5,88(sp)
    1a36:	e8da                	sd	s6,80(sp)
    1a38:	e4de                	sd	s7,72(sp)
    1a3a:	e0e2                	sd	s8,64(sp)
    1a3c:	fc66                	sd	s9,56(sp)
    1a3e:	0900                	addi	s0,sp,144
    1a40:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1a42:	4901                	li	s2,0
    1a44:	4991                	li	s3,4
    pid = fork();
    1a46:	00004097          	auipc	ra,0x4
    1a4a:	e1e080e7          	jalr	-482(ra) # 5864 <fork>
    1a4e:	84aa                	mv	s1,a0
    if(pid < 0){
    1a50:	02054f63          	bltz	a0,1a8e <createdelete+0x68>
    if(pid == 0){
    1a54:	c939                	beqz	a0,1aaa <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1a56:	2905                	addiw	s2,s2,1
    1a58:	ff3917e3          	bne	s2,s3,1a46 <createdelete+0x20>
    1a5c:	4491                	li	s1,4
    wait(&xstatus);
    1a5e:	f7c40513          	addi	a0,s0,-132
    1a62:	00004097          	auipc	ra,0x4
    1a66:	e12080e7          	jalr	-494(ra) # 5874 <wait>
    if(xstatus != 0)
    1a6a:	f7c42903          	lw	s2,-132(s0)
    1a6e:	0e091263          	bnez	s2,1b52 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1a72:	34fd                	addiw	s1,s1,-1
    1a74:	f4ed                	bnez	s1,1a5e <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1a76:	f8040123          	sb	zero,-126(s0)
    1a7a:	03000993          	li	s3,48
    1a7e:	5a7d                	li	s4,-1
    1a80:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1a84:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1a86:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1a88:	07400a93          	li	s5,116
    1a8c:	a29d                	j	1bf2 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1a8e:	85e6                	mv	a1,s9
    1a90:	00005517          	auipc	a0,0x5
    1a94:	28850513          	addi	a0,a0,648 # 6d18 <malloc+0x1066>
    1a98:	00004097          	auipc	ra,0x4
    1a9c:	15c080e7          	jalr	348(ra) # 5bf4 <printf>
      exit(1);
    1aa0:	4505                	li	a0,1
    1aa2:	00004097          	auipc	ra,0x4
    1aa6:	dca080e7          	jalr	-566(ra) # 586c <exit>
      name[0] = 'p' + pi;
    1aaa:	0709091b          	addiw	s2,s2,112
    1aae:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1ab2:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1ab6:	4951                	li	s2,20
    1ab8:	a015                	j	1adc <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1aba:	85e6                	mv	a1,s9
    1abc:	00005517          	auipc	a0,0x5
    1ac0:	ed450513          	addi	a0,a0,-300 # 6990 <malloc+0xcde>
    1ac4:	00004097          	auipc	ra,0x4
    1ac8:	130080e7          	jalr	304(ra) # 5bf4 <printf>
          exit(1);
    1acc:	4505                	li	a0,1
    1ace:	00004097          	auipc	ra,0x4
    1ad2:	d9e080e7          	jalr	-610(ra) # 586c <exit>
      for(i = 0; i < N; i++){
    1ad6:	2485                	addiw	s1,s1,1
    1ad8:	07248863          	beq	s1,s2,1b48 <createdelete+0x122>
        name[1] = '0' + i;
    1adc:	0304879b          	addiw	a5,s1,48
    1ae0:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1ae4:	20200593          	li	a1,514
    1ae8:	f8040513          	addi	a0,s0,-128
    1aec:	00004097          	auipc	ra,0x4
    1af0:	dc0080e7          	jalr	-576(ra) # 58ac <open>
        if(fd < 0){
    1af4:	fc0543e3          	bltz	a0,1aba <createdelete+0x94>
        close(fd);
    1af8:	00004097          	auipc	ra,0x4
    1afc:	d9c080e7          	jalr	-612(ra) # 5894 <close>
        if(i > 0 && (i % 2 ) == 0){
    1b00:	fc905be3          	blez	s1,1ad6 <createdelete+0xb0>
    1b04:	0014f793          	andi	a5,s1,1
    1b08:	f7f9                	bnez	a5,1ad6 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1b0a:	01f4d79b          	srliw	a5,s1,0x1f
    1b0e:	9fa5                	addw	a5,a5,s1
    1b10:	4017d79b          	sraiw	a5,a5,0x1
    1b14:	0307879b          	addiw	a5,a5,48
    1b18:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1b1c:	f8040513          	addi	a0,s0,-128
    1b20:	00004097          	auipc	ra,0x4
    1b24:	d9c080e7          	jalr	-612(ra) # 58bc <unlink>
    1b28:	fa0557e3          	bgez	a0,1ad6 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1b2c:	85e6                	mv	a1,s9
    1b2e:	00005517          	auipc	a0,0x5
    1b32:	fba50513          	addi	a0,a0,-70 # 6ae8 <malloc+0xe36>
    1b36:	00004097          	auipc	ra,0x4
    1b3a:	0be080e7          	jalr	190(ra) # 5bf4 <printf>
            exit(1);
    1b3e:	4505                	li	a0,1
    1b40:	00004097          	auipc	ra,0x4
    1b44:	d2c080e7          	jalr	-724(ra) # 586c <exit>
      exit(0);
    1b48:	4501                	li	a0,0
    1b4a:	00004097          	auipc	ra,0x4
    1b4e:	d22080e7          	jalr	-734(ra) # 586c <exit>
      exit(1);
    1b52:	4505                	li	a0,1
    1b54:	00004097          	auipc	ra,0x4
    1b58:	d18080e7          	jalr	-744(ra) # 586c <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1b5c:	f8040613          	addi	a2,s0,-128
    1b60:	85e6                	mv	a1,s9
    1b62:	00005517          	auipc	a0,0x5
    1b66:	f9e50513          	addi	a0,a0,-98 # 6b00 <malloc+0xe4e>
    1b6a:	00004097          	auipc	ra,0x4
    1b6e:	08a080e7          	jalr	138(ra) # 5bf4 <printf>
        exit(1);
    1b72:	4505                	li	a0,1
    1b74:	00004097          	auipc	ra,0x4
    1b78:	cf8080e7          	jalr	-776(ra) # 586c <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1b7c:	054b7163          	bgeu	s6,s4,1bbe <createdelete+0x198>
      if(fd >= 0)
    1b80:	02055a63          	bgez	a0,1bb4 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1b84:	2485                	addiw	s1,s1,1
    1b86:	0ff4f493          	andi	s1,s1,255
    1b8a:	05548c63          	beq	s1,s5,1be2 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1b8e:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1b92:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1b96:	4581                	li	a1,0
    1b98:	f8040513          	addi	a0,s0,-128
    1b9c:	00004097          	auipc	ra,0x4
    1ba0:	d10080e7          	jalr	-752(ra) # 58ac <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1ba4:	00090463          	beqz	s2,1bac <createdelete+0x186>
    1ba8:	fd2bdae3          	bge	s7,s2,1b7c <createdelete+0x156>
    1bac:	fa0548e3          	bltz	a0,1b5c <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1bb0:	014b7963          	bgeu	s6,s4,1bc2 <createdelete+0x19c>
        close(fd);
    1bb4:	00004097          	auipc	ra,0x4
    1bb8:	ce0080e7          	jalr	-800(ra) # 5894 <close>
    1bbc:	b7e1                	j	1b84 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1bbe:	fc0543e3          	bltz	a0,1b84 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1bc2:	f8040613          	addi	a2,s0,-128
    1bc6:	85e6                	mv	a1,s9
    1bc8:	00005517          	auipc	a0,0x5
    1bcc:	f6050513          	addi	a0,a0,-160 # 6b28 <malloc+0xe76>
    1bd0:	00004097          	auipc	ra,0x4
    1bd4:	024080e7          	jalr	36(ra) # 5bf4 <printf>
        exit(1);
    1bd8:	4505                	li	a0,1
    1bda:	00004097          	auipc	ra,0x4
    1bde:	c92080e7          	jalr	-878(ra) # 586c <exit>
  for(i = 0; i < N; i++){
    1be2:	2905                	addiw	s2,s2,1
    1be4:	2a05                	addiw	s4,s4,1
    1be6:	2985                	addiw	s3,s3,1
    1be8:	0ff9f993          	andi	s3,s3,255
    1bec:	47d1                	li	a5,20
    1bee:	02f90a63          	beq	s2,a5,1c22 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1bf2:	84e2                	mv	s1,s8
    1bf4:	bf69                	j	1b8e <createdelete+0x168>
  for(i = 0; i < N; i++){
    1bf6:	2905                	addiw	s2,s2,1
    1bf8:	0ff97913          	andi	s2,s2,255
    1bfc:	2985                	addiw	s3,s3,1
    1bfe:	0ff9f993          	andi	s3,s3,255
    1c02:	03490863          	beq	s2,s4,1c32 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1c06:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1c08:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1c0c:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1c10:	f8040513          	addi	a0,s0,-128
    1c14:	00004097          	auipc	ra,0x4
    1c18:	ca8080e7          	jalr	-856(ra) # 58bc <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1c1c:	34fd                	addiw	s1,s1,-1
    1c1e:	f4ed                	bnez	s1,1c08 <createdelete+0x1e2>
    1c20:	bfd9                	j	1bf6 <createdelete+0x1d0>
    1c22:	03000993          	li	s3,48
    1c26:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1c2a:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1c2c:	08400a13          	li	s4,132
    1c30:	bfd9                	j	1c06 <createdelete+0x1e0>
}
    1c32:	60aa                	ld	ra,136(sp)
    1c34:	640a                	ld	s0,128(sp)
    1c36:	74e6                	ld	s1,120(sp)
    1c38:	7946                	ld	s2,112(sp)
    1c3a:	79a6                	ld	s3,104(sp)
    1c3c:	7a06                	ld	s4,96(sp)
    1c3e:	6ae6                	ld	s5,88(sp)
    1c40:	6b46                	ld	s6,80(sp)
    1c42:	6ba6                	ld	s7,72(sp)
    1c44:	6c06                	ld	s8,64(sp)
    1c46:	7ce2                	ld	s9,56(sp)
    1c48:	6149                	addi	sp,sp,144
    1c4a:	8082                	ret

0000000000001c4c <linkunlink>:
{
    1c4c:	711d                	addi	sp,sp,-96
    1c4e:	ec86                	sd	ra,88(sp)
    1c50:	e8a2                	sd	s0,80(sp)
    1c52:	e4a6                	sd	s1,72(sp)
    1c54:	e0ca                	sd	s2,64(sp)
    1c56:	fc4e                	sd	s3,56(sp)
    1c58:	f852                	sd	s4,48(sp)
    1c5a:	f456                	sd	s5,40(sp)
    1c5c:	f05a                	sd	s6,32(sp)
    1c5e:	ec5e                	sd	s7,24(sp)
    1c60:	e862                	sd	s8,16(sp)
    1c62:	e466                	sd	s9,8(sp)
    1c64:	1080                	addi	s0,sp,96
    1c66:	84aa                	mv	s1,a0
  unlink("x");
    1c68:	00004517          	auipc	a0,0x4
    1c6c:	53050513          	addi	a0,a0,1328 # 6198 <malloc+0x4e6>
    1c70:	00004097          	auipc	ra,0x4
    1c74:	c4c080e7          	jalr	-948(ra) # 58bc <unlink>
  pid = fork();
    1c78:	00004097          	auipc	ra,0x4
    1c7c:	bec080e7          	jalr	-1044(ra) # 5864 <fork>
  if(pid < 0){
    1c80:	02054b63          	bltz	a0,1cb6 <linkunlink+0x6a>
    1c84:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1c86:	4c85                	li	s9,1
    1c88:	e119                	bnez	a0,1c8e <linkunlink+0x42>
    1c8a:	06100c93          	li	s9,97
    1c8e:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1c92:	41c659b7          	lui	s3,0x41c65
    1c96:	e6d9899b          	addiw	s3,s3,-403
    1c9a:	690d                	lui	s2,0x3
    1c9c:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1ca0:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1ca2:	4b05                	li	s6,1
      unlink("x");
    1ca4:	00004a97          	auipc	s5,0x4
    1ca8:	4f4a8a93          	addi	s5,s5,1268 # 6198 <malloc+0x4e6>
      link("cat", "x");
    1cac:	00005b97          	auipc	s7,0x5
    1cb0:	ea4b8b93          	addi	s7,s7,-348 # 6b50 <malloc+0xe9e>
    1cb4:	a091                	j	1cf8 <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    1cb6:	85a6                	mv	a1,s1
    1cb8:	00005517          	auipc	a0,0x5
    1cbc:	c4050513          	addi	a0,a0,-960 # 68f8 <malloc+0xc46>
    1cc0:	00004097          	auipc	ra,0x4
    1cc4:	f34080e7          	jalr	-204(ra) # 5bf4 <printf>
    exit(1);
    1cc8:	4505                	li	a0,1
    1cca:	00004097          	auipc	ra,0x4
    1cce:	ba2080e7          	jalr	-1118(ra) # 586c <exit>
      close(open("x", O_RDWR | O_CREATE));
    1cd2:	20200593          	li	a1,514
    1cd6:	8556                	mv	a0,s5
    1cd8:	00004097          	auipc	ra,0x4
    1cdc:	bd4080e7          	jalr	-1068(ra) # 58ac <open>
    1ce0:	00004097          	auipc	ra,0x4
    1ce4:	bb4080e7          	jalr	-1100(ra) # 5894 <close>
    1ce8:	a031                	j	1cf4 <linkunlink+0xa8>
      unlink("x");
    1cea:	8556                	mv	a0,s5
    1cec:	00004097          	auipc	ra,0x4
    1cf0:	bd0080e7          	jalr	-1072(ra) # 58bc <unlink>
  for(i = 0; i < 100; i++){
    1cf4:	34fd                	addiw	s1,s1,-1
    1cf6:	c09d                	beqz	s1,1d1c <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1cf8:	033c87bb          	mulw	a5,s9,s3
    1cfc:	012787bb          	addw	a5,a5,s2
    1d00:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1d04:	0347f7bb          	remuw	a5,a5,s4
    1d08:	d7e9                	beqz	a5,1cd2 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1d0a:	ff6790e3          	bne	a5,s6,1cea <linkunlink+0x9e>
      link("cat", "x");
    1d0e:	85d6                	mv	a1,s5
    1d10:	855e                	mv	a0,s7
    1d12:	00004097          	auipc	ra,0x4
    1d16:	bba080e7          	jalr	-1094(ra) # 58cc <link>
    1d1a:	bfe9                	j	1cf4 <linkunlink+0xa8>
  if(pid)
    1d1c:	020c0463          	beqz	s8,1d44 <linkunlink+0xf8>
    wait(0);
    1d20:	4501                	li	a0,0
    1d22:	00004097          	auipc	ra,0x4
    1d26:	b52080e7          	jalr	-1198(ra) # 5874 <wait>
}
    1d2a:	60e6                	ld	ra,88(sp)
    1d2c:	6446                	ld	s0,80(sp)
    1d2e:	64a6                	ld	s1,72(sp)
    1d30:	6906                	ld	s2,64(sp)
    1d32:	79e2                	ld	s3,56(sp)
    1d34:	7a42                	ld	s4,48(sp)
    1d36:	7aa2                	ld	s5,40(sp)
    1d38:	7b02                	ld	s6,32(sp)
    1d3a:	6be2                	ld	s7,24(sp)
    1d3c:	6c42                	ld	s8,16(sp)
    1d3e:	6ca2                	ld	s9,8(sp)
    1d40:	6125                	addi	sp,sp,96
    1d42:	8082                	ret
    exit(0);
    1d44:	4501                	li	a0,0
    1d46:	00004097          	auipc	ra,0x4
    1d4a:	b26080e7          	jalr	-1242(ra) # 586c <exit>

0000000000001d4e <manywrites>:
{
    1d4e:	711d                	addi	sp,sp,-96
    1d50:	ec86                	sd	ra,88(sp)
    1d52:	e8a2                	sd	s0,80(sp)
    1d54:	e4a6                	sd	s1,72(sp)
    1d56:	e0ca                	sd	s2,64(sp)
    1d58:	fc4e                	sd	s3,56(sp)
    1d5a:	f852                	sd	s4,48(sp)
    1d5c:	f456                	sd	s5,40(sp)
    1d5e:	f05a                	sd	s6,32(sp)
    1d60:	ec5e                	sd	s7,24(sp)
    1d62:	1080                	addi	s0,sp,96
    1d64:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1d66:	4901                	li	s2,0
    1d68:	4991                	li	s3,4
    int pid = fork();
    1d6a:	00004097          	auipc	ra,0x4
    1d6e:	afa080e7          	jalr	-1286(ra) # 5864 <fork>
    1d72:	84aa                	mv	s1,a0
    if(pid < 0){
    1d74:	02054963          	bltz	a0,1da6 <manywrites+0x58>
    if(pid == 0){
    1d78:	c521                	beqz	a0,1dc0 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1d7a:	2905                	addiw	s2,s2,1
    1d7c:	ff3917e3          	bne	s2,s3,1d6a <manywrites+0x1c>
    1d80:	4491                	li	s1,4
    int st = 0;
    1d82:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1d86:	fa840513          	addi	a0,s0,-88
    1d8a:	00004097          	auipc	ra,0x4
    1d8e:	aea080e7          	jalr	-1302(ra) # 5874 <wait>
    if(st != 0)
    1d92:	fa842503          	lw	a0,-88(s0)
    1d96:	ed6d                	bnez	a0,1e90 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    1d98:	34fd                	addiw	s1,s1,-1
    1d9a:	f4e5                	bnez	s1,1d82 <manywrites+0x34>
  exit(0);
    1d9c:	4501                	li	a0,0
    1d9e:	00004097          	auipc	ra,0x4
    1da2:	ace080e7          	jalr	-1330(ra) # 586c <exit>
      printf("fork failed\n");
    1da6:	00005517          	auipc	a0,0x5
    1daa:	f7250513          	addi	a0,a0,-142 # 6d18 <malloc+0x1066>
    1dae:	00004097          	auipc	ra,0x4
    1db2:	e46080e7          	jalr	-442(ra) # 5bf4 <printf>
      exit(1);
    1db6:	4505                	li	a0,1
    1db8:	00004097          	auipc	ra,0x4
    1dbc:	ab4080e7          	jalr	-1356(ra) # 586c <exit>
      name[0] = 'b';
    1dc0:	06200793          	li	a5,98
    1dc4:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1dc8:	0619079b          	addiw	a5,s2,97
    1dcc:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1dd0:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1dd4:	fa840513          	addi	a0,s0,-88
    1dd8:	00004097          	auipc	ra,0x4
    1ddc:	ae4080e7          	jalr	-1308(ra) # 58bc <unlink>
    1de0:	4b79                	li	s6,30
          int cc = write(fd, buf, sz);
    1de2:	0000ab97          	auipc	s7,0xa
    1de6:	fc6b8b93          	addi	s7,s7,-58 # bda8 <buf>
        for(int i = 0; i < ci+1; i++){
    1dea:	8a26                	mv	s4,s1
    1dec:	02094e63          	bltz	s2,1e28 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1df0:	20200593          	li	a1,514
    1df4:	fa840513          	addi	a0,s0,-88
    1df8:	00004097          	auipc	ra,0x4
    1dfc:	ab4080e7          	jalr	-1356(ra) # 58ac <open>
    1e00:	89aa                	mv	s3,a0
          if(fd < 0){
    1e02:	04054763          	bltz	a0,1e50 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1e06:	660d                	lui	a2,0x3
    1e08:	85de                	mv	a1,s7
    1e0a:	00004097          	auipc	ra,0x4
    1e0e:	a82080e7          	jalr	-1406(ra) # 588c <write>
          if(cc != sz){
    1e12:	678d                	lui	a5,0x3
    1e14:	04f51e63          	bne	a0,a5,1e70 <manywrites+0x122>
          close(fd);
    1e18:	854e                	mv	a0,s3
    1e1a:	00004097          	auipc	ra,0x4
    1e1e:	a7a080e7          	jalr	-1414(ra) # 5894 <close>
        for(int i = 0; i < ci+1; i++){
    1e22:	2a05                	addiw	s4,s4,1
    1e24:	fd4956e3          	bge	s2,s4,1df0 <manywrites+0xa2>
        unlink(name);
    1e28:	fa840513          	addi	a0,s0,-88
    1e2c:	00004097          	auipc	ra,0x4
    1e30:	a90080e7          	jalr	-1392(ra) # 58bc <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1e34:	3b7d                	addiw	s6,s6,-1
    1e36:	fa0b1ae3          	bnez	s6,1dea <manywrites+0x9c>
      unlink(name);
    1e3a:	fa840513          	addi	a0,s0,-88
    1e3e:	00004097          	auipc	ra,0x4
    1e42:	a7e080e7          	jalr	-1410(ra) # 58bc <unlink>
      exit(0);
    1e46:	4501                	li	a0,0
    1e48:	00004097          	auipc	ra,0x4
    1e4c:	a24080e7          	jalr	-1500(ra) # 586c <exit>
            printf("%s: cannot create %s\n", s, name);
    1e50:	fa840613          	addi	a2,s0,-88
    1e54:	85d6                	mv	a1,s5
    1e56:	00005517          	auipc	a0,0x5
    1e5a:	d0250513          	addi	a0,a0,-766 # 6b58 <malloc+0xea6>
    1e5e:	00004097          	auipc	ra,0x4
    1e62:	d96080e7          	jalr	-618(ra) # 5bf4 <printf>
            exit(1);
    1e66:	4505                	li	a0,1
    1e68:	00004097          	auipc	ra,0x4
    1e6c:	a04080e7          	jalr	-1532(ra) # 586c <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1e70:	86aa                	mv	a3,a0
    1e72:	660d                	lui	a2,0x3
    1e74:	85d6                	mv	a1,s5
    1e76:	00004517          	auipc	a0,0x4
    1e7a:	37250513          	addi	a0,a0,882 # 61e8 <malloc+0x536>
    1e7e:	00004097          	auipc	ra,0x4
    1e82:	d76080e7          	jalr	-650(ra) # 5bf4 <printf>
            exit(1);
    1e86:	4505                	li	a0,1
    1e88:	00004097          	auipc	ra,0x4
    1e8c:	9e4080e7          	jalr	-1564(ra) # 586c <exit>
      exit(st);
    1e90:	00004097          	auipc	ra,0x4
    1e94:	9dc080e7          	jalr	-1572(ra) # 586c <exit>

0000000000001e98 <forktest>:
{
    1e98:	7179                	addi	sp,sp,-48
    1e9a:	f406                	sd	ra,40(sp)
    1e9c:	f022                	sd	s0,32(sp)
    1e9e:	ec26                	sd	s1,24(sp)
    1ea0:	e84a                	sd	s2,16(sp)
    1ea2:	e44e                	sd	s3,8(sp)
    1ea4:	1800                	addi	s0,sp,48
    1ea6:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1ea8:	4481                	li	s1,0
    1eaa:	3e800913          	li	s2,1000
    pid = fork();
    1eae:	00004097          	auipc	ra,0x4
    1eb2:	9b6080e7          	jalr	-1610(ra) # 5864 <fork>
    if(pid < 0)
    1eb6:	02054863          	bltz	a0,1ee6 <forktest+0x4e>
    if(pid == 0)
    1eba:	c115                	beqz	a0,1ede <forktest+0x46>
  for(n=0; n<N; n++){
    1ebc:	2485                	addiw	s1,s1,1
    1ebe:	ff2498e3          	bne	s1,s2,1eae <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1ec2:	85ce                	mv	a1,s3
    1ec4:	00005517          	auipc	a0,0x5
    1ec8:	cc450513          	addi	a0,a0,-828 # 6b88 <malloc+0xed6>
    1ecc:	00004097          	auipc	ra,0x4
    1ed0:	d28080e7          	jalr	-728(ra) # 5bf4 <printf>
    exit(1);
    1ed4:	4505                	li	a0,1
    1ed6:	00004097          	auipc	ra,0x4
    1eda:	996080e7          	jalr	-1642(ra) # 586c <exit>
      exit(0);
    1ede:	00004097          	auipc	ra,0x4
    1ee2:	98e080e7          	jalr	-1650(ra) # 586c <exit>
  if (n == 0) {
    1ee6:	cc9d                	beqz	s1,1f24 <forktest+0x8c>
  if(n == N){
    1ee8:	3e800793          	li	a5,1000
    1eec:	fcf48be3          	beq	s1,a5,1ec2 <forktest+0x2a>
  for(; n > 0; n--){
    1ef0:	00905b63          	blez	s1,1f06 <forktest+0x6e>
    if(wait(0) < 0){
    1ef4:	4501                	li	a0,0
    1ef6:	00004097          	auipc	ra,0x4
    1efa:	97e080e7          	jalr	-1666(ra) # 5874 <wait>
    1efe:	04054163          	bltz	a0,1f40 <forktest+0xa8>
  for(; n > 0; n--){
    1f02:	34fd                	addiw	s1,s1,-1
    1f04:	f8e5                	bnez	s1,1ef4 <forktest+0x5c>
  if(wait(0) != -1){
    1f06:	4501                	li	a0,0
    1f08:	00004097          	auipc	ra,0x4
    1f0c:	96c080e7          	jalr	-1684(ra) # 5874 <wait>
    1f10:	57fd                	li	a5,-1
    1f12:	04f51563          	bne	a0,a5,1f5c <forktest+0xc4>
}
    1f16:	70a2                	ld	ra,40(sp)
    1f18:	7402                	ld	s0,32(sp)
    1f1a:	64e2                	ld	s1,24(sp)
    1f1c:	6942                	ld	s2,16(sp)
    1f1e:	69a2                	ld	s3,8(sp)
    1f20:	6145                	addi	sp,sp,48
    1f22:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1f24:	85ce                	mv	a1,s3
    1f26:	00005517          	auipc	a0,0x5
    1f2a:	c4a50513          	addi	a0,a0,-950 # 6b70 <malloc+0xebe>
    1f2e:	00004097          	auipc	ra,0x4
    1f32:	cc6080e7          	jalr	-826(ra) # 5bf4 <printf>
    exit(1);
    1f36:	4505                	li	a0,1
    1f38:	00004097          	auipc	ra,0x4
    1f3c:	934080e7          	jalr	-1740(ra) # 586c <exit>
      printf("%s: wait stopped early\n", s);
    1f40:	85ce                	mv	a1,s3
    1f42:	00005517          	auipc	a0,0x5
    1f46:	c6e50513          	addi	a0,a0,-914 # 6bb0 <malloc+0xefe>
    1f4a:	00004097          	auipc	ra,0x4
    1f4e:	caa080e7          	jalr	-854(ra) # 5bf4 <printf>
      exit(1);
    1f52:	4505                	li	a0,1
    1f54:	00004097          	auipc	ra,0x4
    1f58:	918080e7          	jalr	-1768(ra) # 586c <exit>
    printf("%s: wait got too many\n", s);
    1f5c:	85ce                	mv	a1,s3
    1f5e:	00005517          	auipc	a0,0x5
    1f62:	c6a50513          	addi	a0,a0,-918 # 6bc8 <malloc+0xf16>
    1f66:	00004097          	auipc	ra,0x4
    1f6a:	c8e080e7          	jalr	-882(ra) # 5bf4 <printf>
    exit(1);
    1f6e:	4505                	li	a0,1
    1f70:	00004097          	auipc	ra,0x4
    1f74:	8fc080e7          	jalr	-1796(ra) # 586c <exit>

0000000000001f78 <kernmem>:
{
    1f78:	715d                	addi	sp,sp,-80
    1f7a:	e486                	sd	ra,72(sp)
    1f7c:	e0a2                	sd	s0,64(sp)
    1f7e:	fc26                	sd	s1,56(sp)
    1f80:	f84a                	sd	s2,48(sp)
    1f82:	f44e                	sd	s3,40(sp)
    1f84:	f052                	sd	s4,32(sp)
    1f86:	ec56                	sd	s5,24(sp)
    1f88:	0880                	addi	s0,sp,80
    1f8a:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1f8c:	4485                	li	s1,1
    1f8e:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1f90:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1f92:	69b1                	lui	s3,0xc
    1f94:	35098993          	addi	s3,s3,848 # c350 <buf+0x5a8>
    1f98:	1003d937          	lui	s2,0x1003d
    1f9c:	090e                	slli	s2,s2,0x3
    1f9e:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e6c8>
    pid = fork();
    1fa2:	00004097          	auipc	ra,0x4
    1fa6:	8c2080e7          	jalr	-1854(ra) # 5864 <fork>
    if(pid < 0){
    1faa:	02054963          	bltz	a0,1fdc <kernmem+0x64>
    if(pid == 0){
    1fae:	c529                	beqz	a0,1ff8 <kernmem+0x80>
    wait(&xstatus);
    1fb0:	fbc40513          	addi	a0,s0,-68
    1fb4:	00004097          	auipc	ra,0x4
    1fb8:	8c0080e7          	jalr	-1856(ra) # 5874 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1fbc:	fbc42783          	lw	a5,-68(s0)
    1fc0:	05579d63          	bne	a5,s5,201a <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fc4:	94ce                	add	s1,s1,s3
    1fc6:	fd249ee3          	bne	s1,s2,1fa2 <kernmem+0x2a>
}
    1fca:	60a6                	ld	ra,72(sp)
    1fcc:	6406                	ld	s0,64(sp)
    1fce:	74e2                	ld	s1,56(sp)
    1fd0:	7942                	ld	s2,48(sp)
    1fd2:	79a2                	ld	s3,40(sp)
    1fd4:	7a02                	ld	s4,32(sp)
    1fd6:	6ae2                	ld	s5,24(sp)
    1fd8:	6161                	addi	sp,sp,80
    1fda:	8082                	ret
      printf("%s: fork failed\n", s);
    1fdc:	85d2                	mv	a1,s4
    1fde:	00005517          	auipc	a0,0x5
    1fe2:	91a50513          	addi	a0,a0,-1766 # 68f8 <malloc+0xc46>
    1fe6:	00004097          	auipc	ra,0x4
    1fea:	c0e080e7          	jalr	-1010(ra) # 5bf4 <printf>
      exit(1);
    1fee:	4505                	li	a0,1
    1ff0:	00004097          	auipc	ra,0x4
    1ff4:	87c080e7          	jalr	-1924(ra) # 586c <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    1ff8:	0004c683          	lbu	a3,0(s1)
    1ffc:	8626                	mv	a2,s1
    1ffe:	85d2                	mv	a1,s4
    2000:	00005517          	auipc	a0,0x5
    2004:	be050513          	addi	a0,a0,-1056 # 6be0 <malloc+0xf2e>
    2008:	00004097          	auipc	ra,0x4
    200c:	bec080e7          	jalr	-1044(ra) # 5bf4 <printf>
      exit(1);
    2010:	4505                	li	a0,1
    2012:	00004097          	auipc	ra,0x4
    2016:	85a080e7          	jalr	-1958(ra) # 586c <exit>
      exit(1);
    201a:	4505                	li	a0,1
    201c:	00004097          	auipc	ra,0x4
    2020:	850080e7          	jalr	-1968(ra) # 586c <exit>

0000000000002024 <MAXVAplus>:
{
    2024:	7179                	addi	sp,sp,-48
    2026:	f406                	sd	ra,40(sp)
    2028:	f022                	sd	s0,32(sp)
    202a:	ec26                	sd	s1,24(sp)
    202c:	e84a                	sd	s2,16(sp)
    202e:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    2030:	4785                	li	a5,1
    2032:	179a                	slli	a5,a5,0x26
    2034:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2038:	fd843783          	ld	a5,-40(s0)
    203c:	cf85                	beqz	a5,2074 <MAXVAplus+0x50>
    203e:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    2040:	54fd                	li	s1,-1
    pid = fork();
    2042:	00004097          	auipc	ra,0x4
    2046:	822080e7          	jalr	-2014(ra) # 5864 <fork>
    if(pid < 0){
    204a:	02054b63          	bltz	a0,2080 <MAXVAplus+0x5c>
    if(pid == 0){
    204e:	c539                	beqz	a0,209c <MAXVAplus+0x78>
    wait(&xstatus);
    2050:	fd440513          	addi	a0,s0,-44
    2054:	00004097          	auipc	ra,0x4
    2058:	820080e7          	jalr	-2016(ra) # 5874 <wait>
    if(xstatus != -1)  // did kernel kill child?
    205c:	fd442783          	lw	a5,-44(s0)
    2060:	06979463          	bne	a5,s1,20c8 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    2064:	fd843783          	ld	a5,-40(s0)
    2068:	0786                	slli	a5,a5,0x1
    206a:	fcf43c23          	sd	a5,-40(s0)
    206e:	fd843783          	ld	a5,-40(s0)
    2072:	fbe1                	bnez	a5,2042 <MAXVAplus+0x1e>
}
    2074:	70a2                	ld	ra,40(sp)
    2076:	7402                	ld	s0,32(sp)
    2078:	64e2                	ld	s1,24(sp)
    207a:	6942                	ld	s2,16(sp)
    207c:	6145                	addi	sp,sp,48
    207e:	8082                	ret
      printf("%s: fork failed\n", s);
    2080:	85ca                	mv	a1,s2
    2082:	00005517          	auipc	a0,0x5
    2086:	87650513          	addi	a0,a0,-1930 # 68f8 <malloc+0xc46>
    208a:	00004097          	auipc	ra,0x4
    208e:	b6a080e7          	jalr	-1174(ra) # 5bf4 <printf>
      exit(1);
    2092:	4505                	li	a0,1
    2094:	00003097          	auipc	ra,0x3
    2098:	7d8080e7          	jalr	2008(ra) # 586c <exit>
      *(char*)a = 99;
    209c:	fd843783          	ld	a5,-40(s0)
    20a0:	06300713          	li	a4,99
    20a4:	00e78023          	sb	a4,0(a5) # 3000 <dirtest+0x2a>
      printf("%s: oops wrote %x\n", s, a);
    20a8:	fd843603          	ld	a2,-40(s0)
    20ac:	85ca                	mv	a1,s2
    20ae:	00005517          	auipc	a0,0x5
    20b2:	b5250513          	addi	a0,a0,-1198 # 6c00 <malloc+0xf4e>
    20b6:	00004097          	auipc	ra,0x4
    20ba:	b3e080e7          	jalr	-1218(ra) # 5bf4 <printf>
      exit(1);
    20be:	4505                	li	a0,1
    20c0:	00003097          	auipc	ra,0x3
    20c4:	7ac080e7          	jalr	1964(ra) # 586c <exit>
      exit(1);
    20c8:	4505                	li	a0,1
    20ca:	00003097          	auipc	ra,0x3
    20ce:	7a2080e7          	jalr	1954(ra) # 586c <exit>

00000000000020d2 <bigargtest>:
{
    20d2:	7179                	addi	sp,sp,-48
    20d4:	f406                	sd	ra,40(sp)
    20d6:	f022                	sd	s0,32(sp)
    20d8:	ec26                	sd	s1,24(sp)
    20da:	1800                	addi	s0,sp,48
    20dc:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    20de:	00005517          	auipc	a0,0x5
    20e2:	b3a50513          	addi	a0,a0,-1222 # 6c18 <malloc+0xf66>
    20e6:	00003097          	auipc	ra,0x3
    20ea:	7d6080e7          	jalr	2006(ra) # 58bc <unlink>
  pid = fork();
    20ee:	00003097          	auipc	ra,0x3
    20f2:	776080e7          	jalr	1910(ra) # 5864 <fork>
  if(pid == 0){
    20f6:	c121                	beqz	a0,2136 <bigargtest+0x64>
  } else if(pid < 0){
    20f8:	0a054063          	bltz	a0,2198 <bigargtest+0xc6>
  wait(&xstatus);
    20fc:	fdc40513          	addi	a0,s0,-36
    2100:	00003097          	auipc	ra,0x3
    2104:	774080e7          	jalr	1908(ra) # 5874 <wait>
  if(xstatus != 0)
    2108:	fdc42503          	lw	a0,-36(s0)
    210c:	e545                	bnez	a0,21b4 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    210e:	4581                	li	a1,0
    2110:	00005517          	auipc	a0,0x5
    2114:	b0850513          	addi	a0,a0,-1272 # 6c18 <malloc+0xf66>
    2118:	00003097          	auipc	ra,0x3
    211c:	794080e7          	jalr	1940(ra) # 58ac <open>
  if(fd < 0){
    2120:	08054e63          	bltz	a0,21bc <bigargtest+0xea>
  close(fd);
    2124:	00003097          	auipc	ra,0x3
    2128:	770080e7          	jalr	1904(ra) # 5894 <close>
}
    212c:	70a2                	ld	ra,40(sp)
    212e:	7402                	ld	s0,32(sp)
    2130:	64e2                	ld	s1,24(sp)
    2132:	6145                	addi	sp,sp,48
    2134:	8082                	ret
    2136:	00006797          	auipc	a5,0x6
    213a:	45a78793          	addi	a5,a5,1114 # 8590 <args.1871>
    213e:	00006697          	auipc	a3,0x6
    2142:	54a68693          	addi	a3,a3,1354 # 8688 <args.1871+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2146:	00005717          	auipc	a4,0x5
    214a:	ae270713          	addi	a4,a4,-1310 # 6c28 <malloc+0xf76>
    214e:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2150:	07a1                	addi	a5,a5,8
    2152:	fed79ee3          	bne	a5,a3,214e <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2156:	00006597          	auipc	a1,0x6
    215a:	43a58593          	addi	a1,a1,1082 # 8590 <args.1871>
    215e:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2162:	00004517          	auipc	a0,0x4
    2166:	fc650513          	addi	a0,a0,-58 # 6128 <malloc+0x476>
    216a:	00003097          	auipc	ra,0x3
    216e:	73a080e7          	jalr	1850(ra) # 58a4 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2172:	20000593          	li	a1,512
    2176:	00005517          	auipc	a0,0x5
    217a:	aa250513          	addi	a0,a0,-1374 # 6c18 <malloc+0xf66>
    217e:	00003097          	auipc	ra,0x3
    2182:	72e080e7          	jalr	1838(ra) # 58ac <open>
    close(fd);
    2186:	00003097          	auipc	ra,0x3
    218a:	70e080e7          	jalr	1806(ra) # 5894 <close>
    exit(0);
    218e:	4501                	li	a0,0
    2190:	00003097          	auipc	ra,0x3
    2194:	6dc080e7          	jalr	1756(ra) # 586c <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2198:	85a6                	mv	a1,s1
    219a:	00005517          	auipc	a0,0x5
    219e:	b6e50513          	addi	a0,a0,-1170 # 6d08 <malloc+0x1056>
    21a2:	00004097          	auipc	ra,0x4
    21a6:	a52080e7          	jalr	-1454(ra) # 5bf4 <printf>
    exit(1);
    21aa:	4505                	li	a0,1
    21ac:	00003097          	auipc	ra,0x3
    21b0:	6c0080e7          	jalr	1728(ra) # 586c <exit>
    exit(xstatus);
    21b4:	00003097          	auipc	ra,0x3
    21b8:	6b8080e7          	jalr	1720(ra) # 586c <exit>
    printf("%s: bigarg test failed!\n", s);
    21bc:	85a6                	mv	a1,s1
    21be:	00005517          	auipc	a0,0x5
    21c2:	b6a50513          	addi	a0,a0,-1174 # 6d28 <malloc+0x1076>
    21c6:	00004097          	auipc	ra,0x4
    21ca:	a2e080e7          	jalr	-1490(ra) # 5bf4 <printf>
    exit(1);
    21ce:	4505                	li	a0,1
    21d0:	00003097          	auipc	ra,0x3
    21d4:	69c080e7          	jalr	1692(ra) # 586c <exit>

00000000000021d8 <stacktest>:
{
    21d8:	7179                	addi	sp,sp,-48
    21da:	f406                	sd	ra,40(sp)
    21dc:	f022                	sd	s0,32(sp)
    21de:	ec26                	sd	s1,24(sp)
    21e0:	1800                	addi	s0,sp,48
    21e2:	84aa                	mv	s1,a0
  pid = fork();
    21e4:	00003097          	auipc	ra,0x3
    21e8:	680080e7          	jalr	1664(ra) # 5864 <fork>
  if(pid == 0) {
    21ec:	c115                	beqz	a0,2210 <stacktest+0x38>
  } else if(pid < 0){
    21ee:	04054463          	bltz	a0,2236 <stacktest+0x5e>
  wait(&xstatus);
    21f2:	fdc40513          	addi	a0,s0,-36
    21f6:	00003097          	auipc	ra,0x3
    21fa:	67e080e7          	jalr	1662(ra) # 5874 <wait>
  if(xstatus == -1)  // kernel killed child?
    21fe:	fdc42503          	lw	a0,-36(s0)
    2202:	57fd                	li	a5,-1
    2204:	04f50763          	beq	a0,a5,2252 <stacktest+0x7a>
    exit(xstatus);
    2208:	00003097          	auipc	ra,0x3
    220c:	664080e7          	jalr	1636(ra) # 586c <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2210:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2212:	77fd                	lui	a5,0xfffff
    2214:	97ba                	add	a5,a5,a4
    2216:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0248>
    221a:	85a6                	mv	a1,s1
    221c:	00005517          	auipc	a0,0x5
    2220:	b2c50513          	addi	a0,a0,-1236 # 6d48 <malloc+0x1096>
    2224:	00004097          	auipc	ra,0x4
    2228:	9d0080e7          	jalr	-1584(ra) # 5bf4 <printf>
    exit(1);
    222c:	4505                	li	a0,1
    222e:	00003097          	auipc	ra,0x3
    2232:	63e080e7          	jalr	1598(ra) # 586c <exit>
    printf("%s: fork failed\n", s);
    2236:	85a6                	mv	a1,s1
    2238:	00004517          	auipc	a0,0x4
    223c:	6c050513          	addi	a0,a0,1728 # 68f8 <malloc+0xc46>
    2240:	00004097          	auipc	ra,0x4
    2244:	9b4080e7          	jalr	-1612(ra) # 5bf4 <printf>
    exit(1);
    2248:	4505                	li	a0,1
    224a:	00003097          	auipc	ra,0x3
    224e:	622080e7          	jalr	1570(ra) # 586c <exit>
    exit(0);
    2252:	4501                	li	a0,0
    2254:	00003097          	auipc	ra,0x3
    2258:	618080e7          	jalr	1560(ra) # 586c <exit>

000000000000225c <copyinstr3>:
{
    225c:	7179                	addi	sp,sp,-48
    225e:	f406                	sd	ra,40(sp)
    2260:	f022                	sd	s0,32(sp)
    2262:	ec26                	sd	s1,24(sp)
    2264:	1800                	addi	s0,sp,48
  sbrk(8192);
    2266:	6509                	lui	a0,0x2
    2268:	00003097          	auipc	ra,0x3
    226c:	68c080e7          	jalr	1676(ra) # 58f4 <sbrk>
  uint64 top = (uint64) sbrk(0);
    2270:	4501                	li	a0,0
    2272:	00003097          	auipc	ra,0x3
    2276:	682080e7          	jalr	1666(ra) # 58f4 <sbrk>
  if((top % PGSIZE) != 0){
    227a:	03451793          	slli	a5,a0,0x34
    227e:	e3c9                	bnez	a5,2300 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2280:	4501                	li	a0,0
    2282:	00003097          	auipc	ra,0x3
    2286:	672080e7          	jalr	1650(ra) # 58f4 <sbrk>
  if(top % PGSIZE){
    228a:	03451793          	slli	a5,a0,0x34
    228e:	e3d9                	bnez	a5,2314 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2290:	fff50493          	addi	s1,a0,-1 # 1fff <kernmem+0x87>
  *b = 'x';
    2294:	07800793          	li	a5,120
    2298:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    229c:	8526                	mv	a0,s1
    229e:	00003097          	auipc	ra,0x3
    22a2:	61e080e7          	jalr	1566(ra) # 58bc <unlink>
  if(ret != -1){
    22a6:	57fd                	li	a5,-1
    22a8:	08f51363          	bne	a0,a5,232e <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    22ac:	20100593          	li	a1,513
    22b0:	8526                	mv	a0,s1
    22b2:	00003097          	auipc	ra,0x3
    22b6:	5fa080e7          	jalr	1530(ra) # 58ac <open>
  if(fd != -1){
    22ba:	57fd                	li	a5,-1
    22bc:	08f51863          	bne	a0,a5,234c <copyinstr3+0xf0>
  ret = link(b, b);
    22c0:	85a6                	mv	a1,s1
    22c2:	8526                	mv	a0,s1
    22c4:	00003097          	auipc	ra,0x3
    22c8:	608080e7          	jalr	1544(ra) # 58cc <link>
  if(ret != -1){
    22cc:	57fd                	li	a5,-1
    22ce:	08f51e63          	bne	a0,a5,236a <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    22d2:	00005797          	auipc	a5,0x5
    22d6:	70e78793          	addi	a5,a5,1806 # 79e0 <malloc+0x1d2e>
    22da:	fcf43823          	sd	a5,-48(s0)
    22de:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    22e2:	fd040593          	addi	a1,s0,-48
    22e6:	8526                	mv	a0,s1
    22e8:	00003097          	auipc	ra,0x3
    22ec:	5bc080e7          	jalr	1468(ra) # 58a4 <exec>
  if(ret != -1){
    22f0:	57fd                	li	a5,-1
    22f2:	08f51c63          	bne	a0,a5,238a <copyinstr3+0x12e>
}
    22f6:	70a2                	ld	ra,40(sp)
    22f8:	7402                	ld	s0,32(sp)
    22fa:	64e2                	ld	s1,24(sp)
    22fc:	6145                	addi	sp,sp,48
    22fe:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2300:	0347d513          	srli	a0,a5,0x34
    2304:	6785                	lui	a5,0x1
    2306:	40a7853b          	subw	a0,a5,a0
    230a:	00003097          	auipc	ra,0x3
    230e:	5ea080e7          	jalr	1514(ra) # 58f4 <sbrk>
    2312:	b7bd                	j	2280 <copyinstr3+0x24>
    printf("oops\n");
    2314:	00005517          	auipc	a0,0x5
    2318:	a5c50513          	addi	a0,a0,-1444 # 6d70 <malloc+0x10be>
    231c:	00004097          	auipc	ra,0x4
    2320:	8d8080e7          	jalr	-1832(ra) # 5bf4 <printf>
    exit(1);
    2324:	4505                	li	a0,1
    2326:	00003097          	auipc	ra,0x3
    232a:	546080e7          	jalr	1350(ra) # 586c <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    232e:	862a                	mv	a2,a0
    2330:	85a6                	mv	a1,s1
    2332:	00004517          	auipc	a0,0x4
    2336:	4e650513          	addi	a0,a0,1254 # 6818 <malloc+0xb66>
    233a:	00004097          	auipc	ra,0x4
    233e:	8ba080e7          	jalr	-1862(ra) # 5bf4 <printf>
    exit(1);
    2342:	4505                	li	a0,1
    2344:	00003097          	auipc	ra,0x3
    2348:	528080e7          	jalr	1320(ra) # 586c <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    234c:	862a                	mv	a2,a0
    234e:	85a6                	mv	a1,s1
    2350:	00004517          	auipc	a0,0x4
    2354:	4e850513          	addi	a0,a0,1256 # 6838 <malloc+0xb86>
    2358:	00004097          	auipc	ra,0x4
    235c:	89c080e7          	jalr	-1892(ra) # 5bf4 <printf>
    exit(1);
    2360:	4505                	li	a0,1
    2362:	00003097          	auipc	ra,0x3
    2366:	50a080e7          	jalr	1290(ra) # 586c <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    236a:	86aa                	mv	a3,a0
    236c:	8626                	mv	a2,s1
    236e:	85a6                	mv	a1,s1
    2370:	00004517          	auipc	a0,0x4
    2374:	4e850513          	addi	a0,a0,1256 # 6858 <malloc+0xba6>
    2378:	00004097          	auipc	ra,0x4
    237c:	87c080e7          	jalr	-1924(ra) # 5bf4 <printf>
    exit(1);
    2380:	4505                	li	a0,1
    2382:	00003097          	auipc	ra,0x3
    2386:	4ea080e7          	jalr	1258(ra) # 586c <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    238a:	567d                	li	a2,-1
    238c:	85a6                	mv	a1,s1
    238e:	00004517          	auipc	a0,0x4
    2392:	4f250513          	addi	a0,a0,1266 # 6880 <malloc+0xbce>
    2396:	00004097          	auipc	ra,0x4
    239a:	85e080e7          	jalr	-1954(ra) # 5bf4 <printf>
    exit(1);
    239e:	4505                	li	a0,1
    23a0:	00003097          	auipc	ra,0x3
    23a4:	4cc080e7          	jalr	1228(ra) # 586c <exit>

00000000000023a8 <rwsbrk>:
{
    23a8:	1101                	addi	sp,sp,-32
    23aa:	ec06                	sd	ra,24(sp)
    23ac:	e822                	sd	s0,16(sp)
    23ae:	e426                	sd	s1,8(sp)
    23b0:	e04a                	sd	s2,0(sp)
    23b2:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    23b4:	6509                	lui	a0,0x2
    23b6:	00003097          	auipc	ra,0x3
    23ba:	53e080e7          	jalr	1342(ra) # 58f4 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    23be:	57fd                	li	a5,-1
    23c0:	06f50363          	beq	a0,a5,2426 <rwsbrk+0x7e>
    23c4:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    23c6:	7579                	lui	a0,0xffffe
    23c8:	00003097          	auipc	ra,0x3
    23cc:	52c080e7          	jalr	1324(ra) # 58f4 <sbrk>
    23d0:	57fd                	li	a5,-1
    23d2:	06f50763          	beq	a0,a5,2440 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    23d6:	20100593          	li	a1,513
    23da:	00004517          	auipc	a0,0x4
    23de:	a4650513          	addi	a0,a0,-1466 # 5e20 <malloc+0x16e>
    23e2:	00003097          	auipc	ra,0x3
    23e6:	4ca080e7          	jalr	1226(ra) # 58ac <open>
    23ea:	892a                	mv	s2,a0
  if(fd < 0){
    23ec:	06054763          	bltz	a0,245a <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    23f0:	6505                	lui	a0,0x1
    23f2:	94aa                	add	s1,s1,a0
    23f4:	40000613          	li	a2,1024
    23f8:	85a6                	mv	a1,s1
    23fa:	854a                	mv	a0,s2
    23fc:	00003097          	auipc	ra,0x3
    2400:	490080e7          	jalr	1168(ra) # 588c <write>
    2404:	862a                	mv	a2,a0
  if(n >= 0){
    2406:	06054763          	bltz	a0,2474 <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    240a:	85a6                	mv	a1,s1
    240c:	00005517          	auipc	a0,0x5
    2410:	9bc50513          	addi	a0,a0,-1604 # 6dc8 <malloc+0x1116>
    2414:	00003097          	auipc	ra,0x3
    2418:	7e0080e7          	jalr	2016(ra) # 5bf4 <printf>
    exit(1);
    241c:	4505                	li	a0,1
    241e:	00003097          	auipc	ra,0x3
    2422:	44e080e7          	jalr	1102(ra) # 586c <exit>
    printf("sbrk(rwsbrk) failed\n");
    2426:	00005517          	auipc	a0,0x5
    242a:	95250513          	addi	a0,a0,-1710 # 6d78 <malloc+0x10c6>
    242e:	00003097          	auipc	ra,0x3
    2432:	7c6080e7          	jalr	1990(ra) # 5bf4 <printf>
    exit(1);
    2436:	4505                	li	a0,1
    2438:	00003097          	auipc	ra,0x3
    243c:	434080e7          	jalr	1076(ra) # 586c <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    2440:	00005517          	auipc	a0,0x5
    2444:	95050513          	addi	a0,a0,-1712 # 6d90 <malloc+0x10de>
    2448:	00003097          	auipc	ra,0x3
    244c:	7ac080e7          	jalr	1964(ra) # 5bf4 <printf>
    exit(1);
    2450:	4505                	li	a0,1
    2452:	00003097          	auipc	ra,0x3
    2456:	41a080e7          	jalr	1050(ra) # 586c <exit>
    printf("open(rwsbrk) failed\n");
    245a:	00005517          	auipc	a0,0x5
    245e:	95650513          	addi	a0,a0,-1706 # 6db0 <malloc+0x10fe>
    2462:	00003097          	auipc	ra,0x3
    2466:	792080e7          	jalr	1938(ra) # 5bf4 <printf>
    exit(1);
    246a:	4505                	li	a0,1
    246c:	00003097          	auipc	ra,0x3
    2470:	400080e7          	jalr	1024(ra) # 586c <exit>
  close(fd);
    2474:	854a                	mv	a0,s2
    2476:	00003097          	auipc	ra,0x3
    247a:	41e080e7          	jalr	1054(ra) # 5894 <close>
  unlink("rwsbrk");
    247e:	00004517          	auipc	a0,0x4
    2482:	9a250513          	addi	a0,a0,-1630 # 5e20 <malloc+0x16e>
    2486:	00003097          	auipc	ra,0x3
    248a:	436080e7          	jalr	1078(ra) # 58bc <unlink>
  fd = open("README", O_RDONLY);
    248e:	4581                	li	a1,0
    2490:	00004517          	auipc	a0,0x4
    2494:	e3050513          	addi	a0,a0,-464 # 62c0 <malloc+0x60e>
    2498:	00003097          	auipc	ra,0x3
    249c:	414080e7          	jalr	1044(ra) # 58ac <open>
    24a0:	892a                	mv	s2,a0
  if(fd < 0){
    24a2:	02054963          	bltz	a0,24d4 <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    24a6:	4629                	li	a2,10
    24a8:	85a6                	mv	a1,s1
    24aa:	00003097          	auipc	ra,0x3
    24ae:	3da080e7          	jalr	986(ra) # 5884 <read>
    24b2:	862a                	mv	a2,a0
  if(n >= 0){
    24b4:	02054d63          	bltz	a0,24ee <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    24b8:	85a6                	mv	a1,s1
    24ba:	00005517          	auipc	a0,0x5
    24be:	93e50513          	addi	a0,a0,-1730 # 6df8 <malloc+0x1146>
    24c2:	00003097          	auipc	ra,0x3
    24c6:	732080e7          	jalr	1842(ra) # 5bf4 <printf>
    exit(1);
    24ca:	4505                	li	a0,1
    24cc:	00003097          	auipc	ra,0x3
    24d0:	3a0080e7          	jalr	928(ra) # 586c <exit>
    printf("open(rwsbrk) failed\n");
    24d4:	00005517          	auipc	a0,0x5
    24d8:	8dc50513          	addi	a0,a0,-1828 # 6db0 <malloc+0x10fe>
    24dc:	00003097          	auipc	ra,0x3
    24e0:	718080e7          	jalr	1816(ra) # 5bf4 <printf>
    exit(1);
    24e4:	4505                	li	a0,1
    24e6:	00003097          	auipc	ra,0x3
    24ea:	386080e7          	jalr	902(ra) # 586c <exit>
  close(fd);
    24ee:	854a                	mv	a0,s2
    24f0:	00003097          	auipc	ra,0x3
    24f4:	3a4080e7          	jalr	932(ra) # 5894 <close>
  exit(0);
    24f8:	4501                	li	a0,0
    24fa:	00003097          	auipc	ra,0x3
    24fe:	372080e7          	jalr	882(ra) # 586c <exit>

0000000000002502 <sbrkbasic>:
{
    2502:	715d                	addi	sp,sp,-80
    2504:	e486                	sd	ra,72(sp)
    2506:	e0a2                	sd	s0,64(sp)
    2508:	fc26                	sd	s1,56(sp)
    250a:	f84a                	sd	s2,48(sp)
    250c:	f44e                	sd	s3,40(sp)
    250e:	f052                	sd	s4,32(sp)
    2510:	ec56                	sd	s5,24(sp)
    2512:	0880                	addi	s0,sp,80
    2514:	8a2a                	mv	s4,a0
  pid = fork();
    2516:	00003097          	auipc	ra,0x3
    251a:	34e080e7          	jalr	846(ra) # 5864 <fork>
  if(pid < 0){
    251e:	02054c63          	bltz	a0,2556 <sbrkbasic+0x54>
  if(pid == 0){
    2522:	ed21                	bnez	a0,257a <sbrkbasic+0x78>
    a = sbrk(TOOMUCH);
    2524:	40000537          	lui	a0,0x40000
    2528:	00003097          	auipc	ra,0x3
    252c:	3cc080e7          	jalr	972(ra) # 58f4 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2530:	57fd                	li	a5,-1
    2532:	02f50f63          	beq	a0,a5,2570 <sbrkbasic+0x6e>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2536:	400007b7          	lui	a5,0x40000
    253a:	97aa                	add	a5,a5,a0
      *b = 99;
    253c:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2540:	6705                	lui	a4,0x1
      *b = 99;
    2542:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1248>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2546:	953a                	add	a0,a0,a4
    2548:	fef51de3          	bne	a0,a5,2542 <sbrkbasic+0x40>
    exit(1);
    254c:	4505                	li	a0,1
    254e:	00003097          	auipc	ra,0x3
    2552:	31e080e7          	jalr	798(ra) # 586c <exit>
    printf("fork failed in sbrkbasic\n");
    2556:	00005517          	auipc	a0,0x5
    255a:	8ca50513          	addi	a0,a0,-1846 # 6e20 <malloc+0x116e>
    255e:	00003097          	auipc	ra,0x3
    2562:	696080e7          	jalr	1686(ra) # 5bf4 <printf>
    exit(1);
    2566:	4505                	li	a0,1
    2568:	00003097          	auipc	ra,0x3
    256c:	304080e7          	jalr	772(ra) # 586c <exit>
      exit(0);
    2570:	4501                	li	a0,0
    2572:	00003097          	auipc	ra,0x3
    2576:	2fa080e7          	jalr	762(ra) # 586c <exit>
  wait(&xstatus);
    257a:	fbc40513          	addi	a0,s0,-68
    257e:	00003097          	auipc	ra,0x3
    2582:	2f6080e7          	jalr	758(ra) # 5874 <wait>
  if(xstatus == 1){
    2586:	fbc42703          	lw	a4,-68(s0)
    258a:	4785                	li	a5,1
    258c:	00f70e63          	beq	a4,a5,25a8 <sbrkbasic+0xa6>
  a = sbrk(0);
    2590:	4501                	li	a0,0
    2592:	00003097          	auipc	ra,0x3
    2596:	362080e7          	jalr	866(ra) # 58f4 <sbrk>
    259a:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    259c:	4901                	li	s2,0
    *b = 1;
    259e:	4a85                	li	s5,1
  for(i = 0; i < 5000; i++){
    25a0:	6985                	lui	s3,0x1
    25a2:	38898993          	addi	s3,s3,904 # 1388 <truncate3+0x144>
    25a6:	a005                	j	25c6 <sbrkbasic+0xc4>
    printf("%s: too much memory allocated!\n", s);
    25a8:	85d2                	mv	a1,s4
    25aa:	00005517          	auipc	a0,0x5
    25ae:	89650513          	addi	a0,a0,-1898 # 6e40 <malloc+0x118e>
    25b2:	00003097          	auipc	ra,0x3
    25b6:	642080e7          	jalr	1602(ra) # 5bf4 <printf>
    exit(1);
    25ba:	4505                	li	a0,1
    25bc:	00003097          	auipc	ra,0x3
    25c0:	2b0080e7          	jalr	688(ra) # 586c <exit>
    a = b + 1;
    25c4:	84be                	mv	s1,a5
    b = sbrk(1);
    25c6:	4505                	li	a0,1
    25c8:	00003097          	auipc	ra,0x3
    25cc:	32c080e7          	jalr	812(ra) # 58f4 <sbrk>
    if(b != a){
    25d0:	04951b63          	bne	a0,s1,2626 <sbrkbasic+0x124>
    *b = 1;
    25d4:	01548023          	sb	s5,0(s1)
    a = b + 1;
    25d8:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    25dc:	2905                	addiw	s2,s2,1
    25de:	ff3913e3          	bne	s2,s3,25c4 <sbrkbasic+0xc2>
  pid = fork();
    25e2:	00003097          	auipc	ra,0x3
    25e6:	282080e7          	jalr	642(ra) # 5864 <fork>
    25ea:	892a                	mv	s2,a0
  if(pid < 0){
    25ec:	04054e63          	bltz	a0,2648 <sbrkbasic+0x146>
  c = sbrk(1);
    25f0:	4505                	li	a0,1
    25f2:	00003097          	auipc	ra,0x3
    25f6:	302080e7          	jalr	770(ra) # 58f4 <sbrk>
  c = sbrk(1);
    25fa:	4505                	li	a0,1
    25fc:	00003097          	auipc	ra,0x3
    2600:	2f8080e7          	jalr	760(ra) # 58f4 <sbrk>
  if(c != a + 1){
    2604:	0489                	addi	s1,s1,2
    2606:	04a48f63          	beq	s1,a0,2664 <sbrkbasic+0x162>
    printf("%s: sbrk test failed post-fork\n", s);
    260a:	85d2                	mv	a1,s4
    260c:	00005517          	auipc	a0,0x5
    2610:	89450513          	addi	a0,a0,-1900 # 6ea0 <malloc+0x11ee>
    2614:	00003097          	auipc	ra,0x3
    2618:	5e0080e7          	jalr	1504(ra) # 5bf4 <printf>
    exit(1);
    261c:	4505                	li	a0,1
    261e:	00003097          	auipc	ra,0x3
    2622:	24e080e7          	jalr	590(ra) # 586c <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    2626:	872a                	mv	a4,a0
    2628:	86a6                	mv	a3,s1
    262a:	864a                	mv	a2,s2
    262c:	85d2                	mv	a1,s4
    262e:	00005517          	auipc	a0,0x5
    2632:	83250513          	addi	a0,a0,-1998 # 6e60 <malloc+0x11ae>
    2636:	00003097          	auipc	ra,0x3
    263a:	5be080e7          	jalr	1470(ra) # 5bf4 <printf>
      exit(1);
    263e:	4505                	li	a0,1
    2640:	00003097          	auipc	ra,0x3
    2644:	22c080e7          	jalr	556(ra) # 586c <exit>
    printf("%s: sbrk test fork failed\n", s);
    2648:	85d2                	mv	a1,s4
    264a:	00005517          	auipc	a0,0x5
    264e:	83650513          	addi	a0,a0,-1994 # 6e80 <malloc+0x11ce>
    2652:	00003097          	auipc	ra,0x3
    2656:	5a2080e7          	jalr	1442(ra) # 5bf4 <printf>
    exit(1);
    265a:	4505                	li	a0,1
    265c:	00003097          	auipc	ra,0x3
    2660:	210080e7          	jalr	528(ra) # 586c <exit>
  if(pid == 0)
    2664:	00091763          	bnez	s2,2672 <sbrkbasic+0x170>
    exit(0);
    2668:	4501                	li	a0,0
    266a:	00003097          	auipc	ra,0x3
    266e:	202080e7          	jalr	514(ra) # 586c <exit>
  wait(&xstatus);
    2672:	fbc40513          	addi	a0,s0,-68
    2676:	00003097          	auipc	ra,0x3
    267a:	1fe080e7          	jalr	510(ra) # 5874 <wait>
  exit(xstatus);
    267e:	fbc42503          	lw	a0,-68(s0)
    2682:	00003097          	auipc	ra,0x3
    2686:	1ea080e7          	jalr	490(ra) # 586c <exit>

000000000000268a <sbrkmuch>:
{
    268a:	7179                	addi	sp,sp,-48
    268c:	f406                	sd	ra,40(sp)
    268e:	f022                	sd	s0,32(sp)
    2690:	ec26                	sd	s1,24(sp)
    2692:	e84a                	sd	s2,16(sp)
    2694:	e44e                	sd	s3,8(sp)
    2696:	e052                	sd	s4,0(sp)
    2698:	1800                	addi	s0,sp,48
    269a:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    269c:	4501                	li	a0,0
    269e:	00003097          	auipc	ra,0x3
    26a2:	256080e7          	jalr	598(ra) # 58f4 <sbrk>
    26a6:	892a                	mv	s2,a0
  a = sbrk(0);
    26a8:	4501                	li	a0,0
    26aa:	00003097          	auipc	ra,0x3
    26ae:	24a080e7          	jalr	586(ra) # 58f4 <sbrk>
    26b2:	84aa                	mv	s1,a0
  p = sbrk(amt);
    26b4:	06400537          	lui	a0,0x6400
    26b8:	9d05                	subw	a0,a0,s1
    26ba:	00003097          	auipc	ra,0x3
    26be:	23a080e7          	jalr	570(ra) # 58f4 <sbrk>
  if (p != a) {
    26c2:	0ca49863          	bne	s1,a0,2792 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    26c6:	4501                	li	a0,0
    26c8:	00003097          	auipc	ra,0x3
    26cc:	22c080e7          	jalr	556(ra) # 58f4 <sbrk>
    26d0:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    26d2:	00a4f963          	bgeu	s1,a0,26e4 <sbrkmuch+0x5a>
    *pp = 1;
    26d6:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    26d8:	6705                	lui	a4,0x1
    *pp = 1;
    26da:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    26de:	94ba                	add	s1,s1,a4
    26e0:	fef4ede3          	bltu	s1,a5,26da <sbrkmuch+0x50>
  *lastaddr = 99;
    26e4:	064007b7          	lui	a5,0x6400
    26e8:	06300713          	li	a4,99
    26ec:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1247>
  a = sbrk(0);
    26f0:	4501                	li	a0,0
    26f2:	00003097          	auipc	ra,0x3
    26f6:	202080e7          	jalr	514(ra) # 58f4 <sbrk>
    26fa:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    26fc:	757d                	lui	a0,0xfffff
    26fe:	00003097          	auipc	ra,0x3
    2702:	1f6080e7          	jalr	502(ra) # 58f4 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2706:	57fd                	li	a5,-1
    2708:	0af50363          	beq	a0,a5,27ae <sbrkmuch+0x124>
  c = sbrk(0);
    270c:	4501                	li	a0,0
    270e:	00003097          	auipc	ra,0x3
    2712:	1e6080e7          	jalr	486(ra) # 58f4 <sbrk>
  if(c != a - PGSIZE){
    2716:	77fd                	lui	a5,0xfffff
    2718:	97a6                	add	a5,a5,s1
    271a:	0af51863          	bne	a0,a5,27ca <sbrkmuch+0x140>
  a = sbrk(0);
    271e:	4501                	li	a0,0
    2720:	00003097          	auipc	ra,0x3
    2724:	1d4080e7          	jalr	468(ra) # 58f4 <sbrk>
    2728:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    272a:	6505                	lui	a0,0x1
    272c:	00003097          	auipc	ra,0x3
    2730:	1c8080e7          	jalr	456(ra) # 58f4 <sbrk>
    2734:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2736:	0aa49a63          	bne	s1,a0,27ea <sbrkmuch+0x160>
    273a:	4501                	li	a0,0
    273c:	00003097          	auipc	ra,0x3
    2740:	1b8080e7          	jalr	440(ra) # 58f4 <sbrk>
    2744:	6785                	lui	a5,0x1
    2746:	97a6                	add	a5,a5,s1
    2748:	0af51163          	bne	a0,a5,27ea <sbrkmuch+0x160>
  if(*lastaddr == 99){
    274c:	064007b7          	lui	a5,0x6400
    2750:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1247>
    2754:	06300793          	li	a5,99
    2758:	0af70963          	beq	a4,a5,280a <sbrkmuch+0x180>
  a = sbrk(0);
    275c:	4501                	li	a0,0
    275e:	00003097          	auipc	ra,0x3
    2762:	196080e7          	jalr	406(ra) # 58f4 <sbrk>
    2766:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2768:	4501                	li	a0,0
    276a:	00003097          	auipc	ra,0x3
    276e:	18a080e7          	jalr	394(ra) # 58f4 <sbrk>
    2772:	40a9053b          	subw	a0,s2,a0
    2776:	00003097          	auipc	ra,0x3
    277a:	17e080e7          	jalr	382(ra) # 58f4 <sbrk>
  if(c != a){
    277e:	0aa49463          	bne	s1,a0,2826 <sbrkmuch+0x19c>
}
    2782:	70a2                	ld	ra,40(sp)
    2784:	7402                	ld	s0,32(sp)
    2786:	64e2                	ld	s1,24(sp)
    2788:	6942                	ld	s2,16(sp)
    278a:	69a2                	ld	s3,8(sp)
    278c:	6a02                	ld	s4,0(sp)
    278e:	6145                	addi	sp,sp,48
    2790:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2792:	85ce                	mv	a1,s3
    2794:	00004517          	auipc	a0,0x4
    2798:	72c50513          	addi	a0,a0,1836 # 6ec0 <malloc+0x120e>
    279c:	00003097          	auipc	ra,0x3
    27a0:	458080e7          	jalr	1112(ra) # 5bf4 <printf>
    exit(1);
    27a4:	4505                	li	a0,1
    27a6:	00003097          	auipc	ra,0x3
    27aa:	0c6080e7          	jalr	198(ra) # 586c <exit>
    printf("%s: sbrk could not deallocate\n", s);
    27ae:	85ce                	mv	a1,s3
    27b0:	00004517          	auipc	a0,0x4
    27b4:	75850513          	addi	a0,a0,1880 # 6f08 <malloc+0x1256>
    27b8:	00003097          	auipc	ra,0x3
    27bc:	43c080e7          	jalr	1084(ra) # 5bf4 <printf>
    exit(1);
    27c0:	4505                	li	a0,1
    27c2:	00003097          	auipc	ra,0x3
    27c6:	0aa080e7          	jalr	170(ra) # 586c <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    27ca:	86aa                	mv	a3,a0
    27cc:	8626                	mv	a2,s1
    27ce:	85ce                	mv	a1,s3
    27d0:	00004517          	auipc	a0,0x4
    27d4:	75850513          	addi	a0,a0,1880 # 6f28 <malloc+0x1276>
    27d8:	00003097          	auipc	ra,0x3
    27dc:	41c080e7          	jalr	1052(ra) # 5bf4 <printf>
    exit(1);
    27e0:	4505                	li	a0,1
    27e2:	00003097          	auipc	ra,0x3
    27e6:	08a080e7          	jalr	138(ra) # 586c <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    27ea:	86d2                	mv	a3,s4
    27ec:	8626                	mv	a2,s1
    27ee:	85ce                	mv	a1,s3
    27f0:	00004517          	auipc	a0,0x4
    27f4:	77850513          	addi	a0,a0,1912 # 6f68 <malloc+0x12b6>
    27f8:	00003097          	auipc	ra,0x3
    27fc:	3fc080e7          	jalr	1020(ra) # 5bf4 <printf>
    exit(1);
    2800:	4505                	li	a0,1
    2802:	00003097          	auipc	ra,0x3
    2806:	06a080e7          	jalr	106(ra) # 586c <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    280a:	85ce                	mv	a1,s3
    280c:	00004517          	auipc	a0,0x4
    2810:	78c50513          	addi	a0,a0,1932 # 6f98 <malloc+0x12e6>
    2814:	00003097          	auipc	ra,0x3
    2818:	3e0080e7          	jalr	992(ra) # 5bf4 <printf>
    exit(1);
    281c:	4505                	li	a0,1
    281e:	00003097          	auipc	ra,0x3
    2822:	04e080e7          	jalr	78(ra) # 586c <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2826:	86aa                	mv	a3,a0
    2828:	8626                	mv	a2,s1
    282a:	85ce                	mv	a1,s3
    282c:	00004517          	auipc	a0,0x4
    2830:	7a450513          	addi	a0,a0,1956 # 6fd0 <malloc+0x131e>
    2834:	00003097          	auipc	ra,0x3
    2838:	3c0080e7          	jalr	960(ra) # 5bf4 <printf>
    exit(1);
    283c:	4505                	li	a0,1
    283e:	00003097          	auipc	ra,0x3
    2842:	02e080e7          	jalr	46(ra) # 586c <exit>

0000000000002846 <sbrkarg>:
{
    2846:	7179                	addi	sp,sp,-48
    2848:	f406                	sd	ra,40(sp)
    284a:	f022                	sd	s0,32(sp)
    284c:	ec26                	sd	s1,24(sp)
    284e:	e84a                	sd	s2,16(sp)
    2850:	e44e                	sd	s3,8(sp)
    2852:	1800                	addi	s0,sp,48
    2854:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2856:	6505                	lui	a0,0x1
    2858:	00003097          	auipc	ra,0x3
    285c:	09c080e7          	jalr	156(ra) # 58f4 <sbrk>
    2860:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2862:	20100593          	li	a1,513
    2866:	00004517          	auipc	a0,0x4
    286a:	79250513          	addi	a0,a0,1938 # 6ff8 <malloc+0x1346>
    286e:	00003097          	auipc	ra,0x3
    2872:	03e080e7          	jalr	62(ra) # 58ac <open>
    2876:	84aa                	mv	s1,a0
  unlink("sbrk");
    2878:	00004517          	auipc	a0,0x4
    287c:	78050513          	addi	a0,a0,1920 # 6ff8 <malloc+0x1346>
    2880:	00003097          	auipc	ra,0x3
    2884:	03c080e7          	jalr	60(ra) # 58bc <unlink>
  if(fd < 0)  {
    2888:	0404c163          	bltz	s1,28ca <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    288c:	6605                	lui	a2,0x1
    288e:	85ca                	mv	a1,s2
    2890:	8526                	mv	a0,s1
    2892:	00003097          	auipc	ra,0x3
    2896:	ffa080e7          	jalr	-6(ra) # 588c <write>
    289a:	04054663          	bltz	a0,28e6 <sbrkarg+0xa0>
  close(fd);
    289e:	8526                	mv	a0,s1
    28a0:	00003097          	auipc	ra,0x3
    28a4:	ff4080e7          	jalr	-12(ra) # 5894 <close>
  a = sbrk(PGSIZE);
    28a8:	6505                	lui	a0,0x1
    28aa:	00003097          	auipc	ra,0x3
    28ae:	04a080e7          	jalr	74(ra) # 58f4 <sbrk>
  if(pipe((int *) a) != 0){
    28b2:	00003097          	auipc	ra,0x3
    28b6:	fca080e7          	jalr	-54(ra) # 587c <pipe>
    28ba:	e521                	bnez	a0,2902 <sbrkarg+0xbc>
}
    28bc:	70a2                	ld	ra,40(sp)
    28be:	7402                	ld	s0,32(sp)
    28c0:	64e2                	ld	s1,24(sp)
    28c2:	6942                	ld	s2,16(sp)
    28c4:	69a2                	ld	s3,8(sp)
    28c6:	6145                	addi	sp,sp,48
    28c8:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    28ca:	85ce                	mv	a1,s3
    28cc:	00004517          	auipc	a0,0x4
    28d0:	73450513          	addi	a0,a0,1844 # 7000 <malloc+0x134e>
    28d4:	00003097          	auipc	ra,0x3
    28d8:	320080e7          	jalr	800(ra) # 5bf4 <printf>
    exit(1);
    28dc:	4505                	li	a0,1
    28de:	00003097          	auipc	ra,0x3
    28e2:	f8e080e7          	jalr	-114(ra) # 586c <exit>
    printf("%s: write sbrk failed\n", s);
    28e6:	85ce                	mv	a1,s3
    28e8:	00004517          	auipc	a0,0x4
    28ec:	73050513          	addi	a0,a0,1840 # 7018 <malloc+0x1366>
    28f0:	00003097          	auipc	ra,0x3
    28f4:	304080e7          	jalr	772(ra) # 5bf4 <printf>
    exit(1);
    28f8:	4505                	li	a0,1
    28fa:	00003097          	auipc	ra,0x3
    28fe:	f72080e7          	jalr	-142(ra) # 586c <exit>
    printf("%s: pipe() failed\n", s);
    2902:	85ce                	mv	a1,s3
    2904:	00004517          	auipc	a0,0x4
    2908:	0fc50513          	addi	a0,a0,252 # 6a00 <malloc+0xd4e>
    290c:	00003097          	auipc	ra,0x3
    2910:	2e8080e7          	jalr	744(ra) # 5bf4 <printf>
    exit(1);
    2914:	4505                	li	a0,1
    2916:	00003097          	auipc	ra,0x3
    291a:	f56080e7          	jalr	-170(ra) # 586c <exit>

000000000000291e <argptest>:
{
    291e:	1101                	addi	sp,sp,-32
    2920:	ec06                	sd	ra,24(sp)
    2922:	e822                	sd	s0,16(sp)
    2924:	e426                	sd	s1,8(sp)
    2926:	e04a                	sd	s2,0(sp)
    2928:	1000                	addi	s0,sp,32
    292a:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    292c:	4581                	li	a1,0
    292e:	00004517          	auipc	a0,0x4
    2932:	70250513          	addi	a0,a0,1794 # 7030 <malloc+0x137e>
    2936:	00003097          	auipc	ra,0x3
    293a:	f76080e7          	jalr	-138(ra) # 58ac <open>
  if (fd < 0) {
    293e:	02054b63          	bltz	a0,2974 <argptest+0x56>
    2942:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2944:	4501                	li	a0,0
    2946:	00003097          	auipc	ra,0x3
    294a:	fae080e7          	jalr	-82(ra) # 58f4 <sbrk>
    294e:	567d                	li	a2,-1
    2950:	fff50593          	addi	a1,a0,-1
    2954:	8526                	mv	a0,s1
    2956:	00003097          	auipc	ra,0x3
    295a:	f2e080e7          	jalr	-210(ra) # 5884 <read>
  close(fd);
    295e:	8526                	mv	a0,s1
    2960:	00003097          	auipc	ra,0x3
    2964:	f34080e7          	jalr	-204(ra) # 5894 <close>
}
    2968:	60e2                	ld	ra,24(sp)
    296a:	6442                	ld	s0,16(sp)
    296c:	64a2                	ld	s1,8(sp)
    296e:	6902                	ld	s2,0(sp)
    2970:	6105                	addi	sp,sp,32
    2972:	8082                	ret
    printf("%s: open failed\n", s);
    2974:	85ca                	mv	a1,s2
    2976:	00004517          	auipc	a0,0x4
    297a:	f9a50513          	addi	a0,a0,-102 # 6910 <malloc+0xc5e>
    297e:	00003097          	auipc	ra,0x3
    2982:	276080e7          	jalr	630(ra) # 5bf4 <printf>
    exit(1);
    2986:	4505                	li	a0,1
    2988:	00003097          	auipc	ra,0x3
    298c:	ee4080e7          	jalr	-284(ra) # 586c <exit>

0000000000002990 <sbrkbugs>:
{
    2990:	1141                	addi	sp,sp,-16
    2992:	e406                	sd	ra,8(sp)
    2994:	e022                	sd	s0,0(sp)
    2996:	0800                	addi	s0,sp,16
  int pid = fork();
    2998:	00003097          	auipc	ra,0x3
    299c:	ecc080e7          	jalr	-308(ra) # 5864 <fork>
  if(pid < 0){
    29a0:	02054263          	bltz	a0,29c4 <sbrkbugs+0x34>
  if(pid == 0){
    29a4:	ed0d                	bnez	a0,29de <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    29a6:	00003097          	auipc	ra,0x3
    29aa:	f4e080e7          	jalr	-178(ra) # 58f4 <sbrk>
    sbrk(-sz);
    29ae:	40a0053b          	negw	a0,a0
    29b2:	00003097          	auipc	ra,0x3
    29b6:	f42080e7          	jalr	-190(ra) # 58f4 <sbrk>
    exit(0);
    29ba:	4501                	li	a0,0
    29bc:	00003097          	auipc	ra,0x3
    29c0:	eb0080e7          	jalr	-336(ra) # 586c <exit>
    printf("fork failed\n");
    29c4:	00004517          	auipc	a0,0x4
    29c8:	35450513          	addi	a0,a0,852 # 6d18 <malloc+0x1066>
    29cc:	00003097          	auipc	ra,0x3
    29d0:	228080e7          	jalr	552(ra) # 5bf4 <printf>
    exit(1);
    29d4:	4505                	li	a0,1
    29d6:	00003097          	auipc	ra,0x3
    29da:	e96080e7          	jalr	-362(ra) # 586c <exit>
  wait(0);
    29de:	4501                	li	a0,0
    29e0:	00003097          	auipc	ra,0x3
    29e4:	e94080e7          	jalr	-364(ra) # 5874 <wait>
  pid = fork();
    29e8:	00003097          	auipc	ra,0x3
    29ec:	e7c080e7          	jalr	-388(ra) # 5864 <fork>
  if(pid < 0){
    29f0:	02054563          	bltz	a0,2a1a <sbrkbugs+0x8a>
  if(pid == 0){
    29f4:	e121                	bnez	a0,2a34 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    29f6:	00003097          	auipc	ra,0x3
    29fa:	efe080e7          	jalr	-258(ra) # 58f4 <sbrk>
    sbrk(-(sz - 3500));
    29fe:	6785                	lui	a5,0x1
    2a00:	dac7879b          	addiw	a5,a5,-596
    2a04:	40a7853b          	subw	a0,a5,a0
    2a08:	00003097          	auipc	ra,0x3
    2a0c:	eec080e7          	jalr	-276(ra) # 58f4 <sbrk>
    exit(0);
    2a10:	4501                	li	a0,0
    2a12:	00003097          	auipc	ra,0x3
    2a16:	e5a080e7          	jalr	-422(ra) # 586c <exit>
    printf("fork failed\n");
    2a1a:	00004517          	auipc	a0,0x4
    2a1e:	2fe50513          	addi	a0,a0,766 # 6d18 <malloc+0x1066>
    2a22:	00003097          	auipc	ra,0x3
    2a26:	1d2080e7          	jalr	466(ra) # 5bf4 <printf>
    exit(1);
    2a2a:	4505                	li	a0,1
    2a2c:	00003097          	auipc	ra,0x3
    2a30:	e40080e7          	jalr	-448(ra) # 586c <exit>
  wait(0);
    2a34:	4501                	li	a0,0
    2a36:	00003097          	auipc	ra,0x3
    2a3a:	e3e080e7          	jalr	-450(ra) # 5874 <wait>
  pid = fork();
    2a3e:	00003097          	auipc	ra,0x3
    2a42:	e26080e7          	jalr	-474(ra) # 5864 <fork>
  if(pid < 0){
    2a46:	02054a63          	bltz	a0,2a7a <sbrkbugs+0xea>
  if(pid == 0){
    2a4a:	e529                	bnez	a0,2a94 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2a4c:	00003097          	auipc	ra,0x3
    2a50:	ea8080e7          	jalr	-344(ra) # 58f4 <sbrk>
    2a54:	67ad                	lui	a5,0xb
    2a56:	8007879b          	addiw	a5,a5,-2048
    2a5a:	40a7853b          	subw	a0,a5,a0
    2a5e:	00003097          	auipc	ra,0x3
    2a62:	e96080e7          	jalr	-362(ra) # 58f4 <sbrk>
    sbrk(-10);
    2a66:	5559                	li	a0,-10
    2a68:	00003097          	auipc	ra,0x3
    2a6c:	e8c080e7          	jalr	-372(ra) # 58f4 <sbrk>
    exit(0);
    2a70:	4501                	li	a0,0
    2a72:	00003097          	auipc	ra,0x3
    2a76:	dfa080e7          	jalr	-518(ra) # 586c <exit>
    printf("fork failed\n");
    2a7a:	00004517          	auipc	a0,0x4
    2a7e:	29e50513          	addi	a0,a0,670 # 6d18 <malloc+0x1066>
    2a82:	00003097          	auipc	ra,0x3
    2a86:	172080e7          	jalr	370(ra) # 5bf4 <printf>
    exit(1);
    2a8a:	4505                	li	a0,1
    2a8c:	00003097          	auipc	ra,0x3
    2a90:	de0080e7          	jalr	-544(ra) # 586c <exit>
  wait(0);
    2a94:	4501                	li	a0,0
    2a96:	00003097          	auipc	ra,0x3
    2a9a:	dde080e7          	jalr	-546(ra) # 5874 <wait>
  exit(0);
    2a9e:	4501                	li	a0,0
    2aa0:	00003097          	auipc	ra,0x3
    2aa4:	dcc080e7          	jalr	-564(ra) # 586c <exit>

0000000000002aa8 <sbrklast>:
{
    2aa8:	7179                	addi	sp,sp,-48
    2aaa:	f406                	sd	ra,40(sp)
    2aac:	f022                	sd	s0,32(sp)
    2aae:	ec26                	sd	s1,24(sp)
    2ab0:	e84a                	sd	s2,16(sp)
    2ab2:	e44e                	sd	s3,8(sp)
    2ab4:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2ab6:	4501                	li	a0,0
    2ab8:	00003097          	auipc	ra,0x3
    2abc:	e3c080e7          	jalr	-452(ra) # 58f4 <sbrk>
  if((top % 4096) != 0)
    2ac0:	03451793          	slli	a5,a0,0x34
    2ac4:	efc1                	bnez	a5,2b5c <sbrklast+0xb4>
  sbrk(4096);
    2ac6:	6505                	lui	a0,0x1
    2ac8:	00003097          	auipc	ra,0x3
    2acc:	e2c080e7          	jalr	-468(ra) # 58f4 <sbrk>
  sbrk(10);
    2ad0:	4529                	li	a0,10
    2ad2:	00003097          	auipc	ra,0x3
    2ad6:	e22080e7          	jalr	-478(ra) # 58f4 <sbrk>
  sbrk(-20);
    2ada:	5531                	li	a0,-20
    2adc:	00003097          	auipc	ra,0x3
    2ae0:	e18080e7          	jalr	-488(ra) # 58f4 <sbrk>
  top = (uint64) sbrk(0);
    2ae4:	4501                	li	a0,0
    2ae6:	00003097          	auipc	ra,0x3
    2aea:	e0e080e7          	jalr	-498(ra) # 58f4 <sbrk>
    2aee:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2af0:	fc050913          	addi	s2,a0,-64 # fc0 <validatetest+0x5e>
  p[0] = 'x';
    2af4:	07800793          	li	a5,120
    2af8:	fcf50023          	sb	a5,-64(a0)
  p[1] = '\0';
    2afc:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2b00:	20200593          	li	a1,514
    2b04:	854a                	mv	a0,s2
    2b06:	00003097          	auipc	ra,0x3
    2b0a:	da6080e7          	jalr	-602(ra) # 58ac <open>
    2b0e:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2b10:	4605                	li	a2,1
    2b12:	85ca                	mv	a1,s2
    2b14:	00003097          	auipc	ra,0x3
    2b18:	d78080e7          	jalr	-648(ra) # 588c <write>
  close(fd);
    2b1c:	854e                	mv	a0,s3
    2b1e:	00003097          	auipc	ra,0x3
    2b22:	d76080e7          	jalr	-650(ra) # 5894 <close>
  fd = open(p, O_RDWR);
    2b26:	4589                	li	a1,2
    2b28:	854a                	mv	a0,s2
    2b2a:	00003097          	auipc	ra,0x3
    2b2e:	d82080e7          	jalr	-638(ra) # 58ac <open>
  p[0] = '\0';
    2b32:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2b36:	4605                	li	a2,1
    2b38:	85ca                	mv	a1,s2
    2b3a:	00003097          	auipc	ra,0x3
    2b3e:	d4a080e7          	jalr	-694(ra) # 5884 <read>
  if(p[0] != 'x')
    2b42:	fc04c703          	lbu	a4,-64(s1)
    2b46:	07800793          	li	a5,120
    2b4a:	02f71363          	bne	a4,a5,2b70 <sbrklast+0xc8>
}
    2b4e:	70a2                	ld	ra,40(sp)
    2b50:	7402                	ld	s0,32(sp)
    2b52:	64e2                	ld	s1,24(sp)
    2b54:	6942                	ld	s2,16(sp)
    2b56:	69a2                	ld	s3,8(sp)
    2b58:	6145                	addi	sp,sp,48
    2b5a:	8082                	ret
    sbrk(4096 - (top % 4096));
    2b5c:	0347d513          	srli	a0,a5,0x34
    2b60:	6785                	lui	a5,0x1
    2b62:	40a7853b          	subw	a0,a5,a0
    2b66:	00003097          	auipc	ra,0x3
    2b6a:	d8e080e7          	jalr	-626(ra) # 58f4 <sbrk>
    2b6e:	bfa1                	j	2ac6 <sbrklast+0x1e>
    exit(1);
    2b70:	4505                	li	a0,1
    2b72:	00003097          	auipc	ra,0x3
    2b76:	cfa080e7          	jalr	-774(ra) # 586c <exit>

0000000000002b7a <sbrk8000>:
{
    2b7a:	1141                	addi	sp,sp,-16
    2b7c:	e406                	sd	ra,8(sp)
    2b7e:	e022                	sd	s0,0(sp)
    2b80:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2b82:	80000537          	lui	a0,0x80000
    2b86:	0511                	addi	a0,a0,4
    2b88:	00003097          	auipc	ra,0x3
    2b8c:	d6c080e7          	jalr	-660(ra) # 58f4 <sbrk>
  volatile char *top = sbrk(0);
    2b90:	4501                	li	a0,0
    2b92:	00003097          	auipc	ra,0x3
    2b96:	d62080e7          	jalr	-670(ra) # 58f4 <sbrk>
  *(top-1) = *(top-1) + 1;
    2b9a:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <__BSS_END__+0xffffffff7fff1247>
    2b9e:	0785                	addi	a5,a5,1
    2ba0:	0ff7f793          	andi	a5,a5,255
    2ba4:	fef50fa3          	sb	a5,-1(a0)
}
    2ba8:	60a2                	ld	ra,8(sp)
    2baa:	6402                	ld	s0,0(sp)
    2bac:	0141                	addi	sp,sp,16
    2bae:	8082                	ret

0000000000002bb0 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2bb0:	715d                	addi	sp,sp,-80
    2bb2:	e486                	sd	ra,72(sp)
    2bb4:	e0a2                	sd	s0,64(sp)
    2bb6:	fc26                	sd	s1,56(sp)
    2bb8:	f84a                	sd	s2,48(sp)
    2bba:	f44e                	sd	s3,40(sp)
    2bbc:	f052                	sd	s4,32(sp)
    2bbe:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2bc0:	4901                	li	s2,0
    2bc2:	49bd                	li	s3,15
    int pid = fork();
    2bc4:	00003097          	auipc	ra,0x3
    2bc8:	ca0080e7          	jalr	-864(ra) # 5864 <fork>
    2bcc:	84aa                	mv	s1,a0
    if(pid < 0){
    2bce:	02054063          	bltz	a0,2bee <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2bd2:	c91d                	beqz	a0,2c08 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2bd4:	4501                	li	a0,0
    2bd6:	00003097          	auipc	ra,0x3
    2bda:	c9e080e7          	jalr	-866(ra) # 5874 <wait>
  for(int avail = 0; avail < 15; avail++){
    2bde:	2905                	addiw	s2,s2,1
    2be0:	ff3912e3          	bne	s2,s3,2bc4 <execout+0x14>
    }
  }

  exit(0);
    2be4:	4501                	li	a0,0
    2be6:	00003097          	auipc	ra,0x3
    2bea:	c86080e7          	jalr	-890(ra) # 586c <exit>
      printf("fork failed\n");
    2bee:	00004517          	auipc	a0,0x4
    2bf2:	12a50513          	addi	a0,a0,298 # 6d18 <malloc+0x1066>
    2bf6:	00003097          	auipc	ra,0x3
    2bfa:	ffe080e7          	jalr	-2(ra) # 5bf4 <printf>
      exit(1);
    2bfe:	4505                	li	a0,1
    2c00:	00003097          	auipc	ra,0x3
    2c04:	c6c080e7          	jalr	-916(ra) # 586c <exit>
        if(a == 0xffffffffffffffffLL)
    2c08:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2c0a:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2c0c:	6505                	lui	a0,0x1
    2c0e:	00003097          	auipc	ra,0x3
    2c12:	ce6080e7          	jalr	-794(ra) # 58f4 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2c16:	01350763          	beq	a0,s3,2c24 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2c1a:	6785                	lui	a5,0x1
    2c1c:	953e                	add	a0,a0,a5
    2c1e:	ff450fa3          	sb	s4,-1(a0) # fff <pgbug+0x2f>
      while(1){
    2c22:	b7ed                	j	2c0c <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2c24:	01205a63          	blez	s2,2c38 <execout+0x88>
        sbrk(-4096);
    2c28:	757d                	lui	a0,0xfffff
    2c2a:	00003097          	auipc	ra,0x3
    2c2e:	cca080e7          	jalr	-822(ra) # 58f4 <sbrk>
      for(int i = 0; i < avail; i++)
    2c32:	2485                	addiw	s1,s1,1
    2c34:	ff249ae3          	bne	s1,s2,2c28 <execout+0x78>
      close(1);
    2c38:	4505                	li	a0,1
    2c3a:	00003097          	auipc	ra,0x3
    2c3e:	c5a080e7          	jalr	-934(ra) # 5894 <close>
      char *args[] = { "echo", "x", 0 };
    2c42:	00003517          	auipc	a0,0x3
    2c46:	4e650513          	addi	a0,a0,1254 # 6128 <malloc+0x476>
    2c4a:	faa43c23          	sd	a0,-72(s0)
    2c4e:	00003797          	auipc	a5,0x3
    2c52:	54a78793          	addi	a5,a5,1354 # 6198 <malloc+0x4e6>
    2c56:	fcf43023          	sd	a5,-64(s0)
    2c5a:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2c5e:	fb840593          	addi	a1,s0,-72
    2c62:	00003097          	auipc	ra,0x3
    2c66:	c42080e7          	jalr	-958(ra) # 58a4 <exec>
      exit(0);
    2c6a:	4501                	li	a0,0
    2c6c:	00003097          	auipc	ra,0x3
    2c70:	c00080e7          	jalr	-1024(ra) # 586c <exit>

0000000000002c74 <fourteen>:
{
    2c74:	1101                	addi	sp,sp,-32
    2c76:	ec06                	sd	ra,24(sp)
    2c78:	e822                	sd	s0,16(sp)
    2c7a:	e426                	sd	s1,8(sp)
    2c7c:	1000                	addi	s0,sp,32
    2c7e:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2c80:	00004517          	auipc	a0,0x4
    2c84:	58850513          	addi	a0,a0,1416 # 7208 <malloc+0x1556>
    2c88:	00003097          	auipc	ra,0x3
    2c8c:	c4c080e7          	jalr	-948(ra) # 58d4 <mkdir>
    2c90:	e165                	bnez	a0,2d70 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2c92:	00004517          	auipc	a0,0x4
    2c96:	3ce50513          	addi	a0,a0,974 # 7060 <malloc+0x13ae>
    2c9a:	00003097          	auipc	ra,0x3
    2c9e:	c3a080e7          	jalr	-966(ra) # 58d4 <mkdir>
    2ca2:	e56d                	bnez	a0,2d8c <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2ca4:	20000593          	li	a1,512
    2ca8:	00004517          	auipc	a0,0x4
    2cac:	41050513          	addi	a0,a0,1040 # 70b8 <malloc+0x1406>
    2cb0:	00003097          	auipc	ra,0x3
    2cb4:	bfc080e7          	jalr	-1028(ra) # 58ac <open>
  if(fd < 0){
    2cb8:	0e054863          	bltz	a0,2da8 <fourteen+0x134>
  close(fd);
    2cbc:	00003097          	auipc	ra,0x3
    2cc0:	bd8080e7          	jalr	-1064(ra) # 5894 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2cc4:	4581                	li	a1,0
    2cc6:	00004517          	auipc	a0,0x4
    2cca:	46a50513          	addi	a0,a0,1130 # 7130 <malloc+0x147e>
    2cce:	00003097          	auipc	ra,0x3
    2cd2:	bde080e7          	jalr	-1058(ra) # 58ac <open>
  if(fd < 0){
    2cd6:	0e054763          	bltz	a0,2dc4 <fourteen+0x150>
  close(fd);
    2cda:	00003097          	auipc	ra,0x3
    2cde:	bba080e7          	jalr	-1094(ra) # 5894 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2ce2:	00004517          	auipc	a0,0x4
    2ce6:	4be50513          	addi	a0,a0,1214 # 71a0 <malloc+0x14ee>
    2cea:	00003097          	auipc	ra,0x3
    2cee:	bea080e7          	jalr	-1046(ra) # 58d4 <mkdir>
    2cf2:	c57d                	beqz	a0,2de0 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2cf4:	00004517          	auipc	a0,0x4
    2cf8:	50450513          	addi	a0,a0,1284 # 71f8 <malloc+0x1546>
    2cfc:	00003097          	auipc	ra,0x3
    2d00:	bd8080e7          	jalr	-1064(ra) # 58d4 <mkdir>
    2d04:	cd65                	beqz	a0,2dfc <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2d06:	00004517          	auipc	a0,0x4
    2d0a:	4f250513          	addi	a0,a0,1266 # 71f8 <malloc+0x1546>
    2d0e:	00003097          	auipc	ra,0x3
    2d12:	bae080e7          	jalr	-1106(ra) # 58bc <unlink>
  unlink("12345678901234/12345678901234");
    2d16:	00004517          	auipc	a0,0x4
    2d1a:	48a50513          	addi	a0,a0,1162 # 71a0 <malloc+0x14ee>
    2d1e:	00003097          	auipc	ra,0x3
    2d22:	b9e080e7          	jalr	-1122(ra) # 58bc <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2d26:	00004517          	auipc	a0,0x4
    2d2a:	40a50513          	addi	a0,a0,1034 # 7130 <malloc+0x147e>
    2d2e:	00003097          	auipc	ra,0x3
    2d32:	b8e080e7          	jalr	-1138(ra) # 58bc <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2d36:	00004517          	auipc	a0,0x4
    2d3a:	38250513          	addi	a0,a0,898 # 70b8 <malloc+0x1406>
    2d3e:	00003097          	auipc	ra,0x3
    2d42:	b7e080e7          	jalr	-1154(ra) # 58bc <unlink>
  unlink("12345678901234/123456789012345");
    2d46:	00004517          	auipc	a0,0x4
    2d4a:	31a50513          	addi	a0,a0,794 # 7060 <malloc+0x13ae>
    2d4e:	00003097          	auipc	ra,0x3
    2d52:	b6e080e7          	jalr	-1170(ra) # 58bc <unlink>
  unlink("12345678901234");
    2d56:	00004517          	auipc	a0,0x4
    2d5a:	4b250513          	addi	a0,a0,1202 # 7208 <malloc+0x1556>
    2d5e:	00003097          	auipc	ra,0x3
    2d62:	b5e080e7          	jalr	-1186(ra) # 58bc <unlink>
}
    2d66:	60e2                	ld	ra,24(sp)
    2d68:	6442                	ld	s0,16(sp)
    2d6a:	64a2                	ld	s1,8(sp)
    2d6c:	6105                	addi	sp,sp,32
    2d6e:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2d70:	85a6                	mv	a1,s1
    2d72:	00004517          	auipc	a0,0x4
    2d76:	2c650513          	addi	a0,a0,710 # 7038 <malloc+0x1386>
    2d7a:	00003097          	auipc	ra,0x3
    2d7e:	e7a080e7          	jalr	-390(ra) # 5bf4 <printf>
    exit(1);
    2d82:	4505                	li	a0,1
    2d84:	00003097          	auipc	ra,0x3
    2d88:	ae8080e7          	jalr	-1304(ra) # 586c <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2d8c:	85a6                	mv	a1,s1
    2d8e:	00004517          	auipc	a0,0x4
    2d92:	2f250513          	addi	a0,a0,754 # 7080 <malloc+0x13ce>
    2d96:	00003097          	auipc	ra,0x3
    2d9a:	e5e080e7          	jalr	-418(ra) # 5bf4 <printf>
    exit(1);
    2d9e:	4505                	li	a0,1
    2da0:	00003097          	auipc	ra,0x3
    2da4:	acc080e7          	jalr	-1332(ra) # 586c <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2da8:	85a6                	mv	a1,s1
    2daa:	00004517          	auipc	a0,0x4
    2dae:	33e50513          	addi	a0,a0,830 # 70e8 <malloc+0x1436>
    2db2:	00003097          	auipc	ra,0x3
    2db6:	e42080e7          	jalr	-446(ra) # 5bf4 <printf>
    exit(1);
    2dba:	4505                	li	a0,1
    2dbc:	00003097          	auipc	ra,0x3
    2dc0:	ab0080e7          	jalr	-1360(ra) # 586c <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2dc4:	85a6                	mv	a1,s1
    2dc6:	00004517          	auipc	a0,0x4
    2dca:	39a50513          	addi	a0,a0,922 # 7160 <malloc+0x14ae>
    2dce:	00003097          	auipc	ra,0x3
    2dd2:	e26080e7          	jalr	-474(ra) # 5bf4 <printf>
    exit(1);
    2dd6:	4505                	li	a0,1
    2dd8:	00003097          	auipc	ra,0x3
    2ddc:	a94080e7          	jalr	-1388(ra) # 586c <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2de0:	85a6                	mv	a1,s1
    2de2:	00004517          	auipc	a0,0x4
    2de6:	3de50513          	addi	a0,a0,990 # 71c0 <malloc+0x150e>
    2dea:	00003097          	auipc	ra,0x3
    2dee:	e0a080e7          	jalr	-502(ra) # 5bf4 <printf>
    exit(1);
    2df2:	4505                	li	a0,1
    2df4:	00003097          	auipc	ra,0x3
    2df8:	a78080e7          	jalr	-1416(ra) # 586c <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2dfc:	85a6                	mv	a1,s1
    2dfe:	00004517          	auipc	a0,0x4
    2e02:	41a50513          	addi	a0,a0,1050 # 7218 <malloc+0x1566>
    2e06:	00003097          	auipc	ra,0x3
    2e0a:	dee080e7          	jalr	-530(ra) # 5bf4 <printf>
    exit(1);
    2e0e:	4505                	li	a0,1
    2e10:	00003097          	auipc	ra,0x3
    2e14:	a5c080e7          	jalr	-1444(ra) # 586c <exit>

0000000000002e18 <iputtest>:
{
    2e18:	1101                	addi	sp,sp,-32
    2e1a:	ec06                	sd	ra,24(sp)
    2e1c:	e822                	sd	s0,16(sp)
    2e1e:	e426                	sd	s1,8(sp)
    2e20:	1000                	addi	s0,sp,32
    2e22:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2e24:	00004517          	auipc	a0,0x4
    2e28:	42c50513          	addi	a0,a0,1068 # 7250 <malloc+0x159e>
    2e2c:	00003097          	auipc	ra,0x3
    2e30:	aa8080e7          	jalr	-1368(ra) # 58d4 <mkdir>
    2e34:	04054563          	bltz	a0,2e7e <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2e38:	00004517          	auipc	a0,0x4
    2e3c:	41850513          	addi	a0,a0,1048 # 7250 <malloc+0x159e>
    2e40:	00003097          	auipc	ra,0x3
    2e44:	a9c080e7          	jalr	-1380(ra) # 58dc <chdir>
    2e48:	04054963          	bltz	a0,2e9a <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2e4c:	00004517          	auipc	a0,0x4
    2e50:	44450513          	addi	a0,a0,1092 # 7290 <malloc+0x15de>
    2e54:	00003097          	auipc	ra,0x3
    2e58:	a68080e7          	jalr	-1432(ra) # 58bc <unlink>
    2e5c:	04054d63          	bltz	a0,2eb6 <iputtest+0x9e>
  if(chdir("/") < 0){
    2e60:	00004517          	auipc	a0,0x4
    2e64:	46050513          	addi	a0,a0,1120 # 72c0 <malloc+0x160e>
    2e68:	00003097          	auipc	ra,0x3
    2e6c:	a74080e7          	jalr	-1420(ra) # 58dc <chdir>
    2e70:	06054163          	bltz	a0,2ed2 <iputtest+0xba>
}
    2e74:	60e2                	ld	ra,24(sp)
    2e76:	6442                	ld	s0,16(sp)
    2e78:	64a2                	ld	s1,8(sp)
    2e7a:	6105                	addi	sp,sp,32
    2e7c:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2e7e:	85a6                	mv	a1,s1
    2e80:	00004517          	auipc	a0,0x4
    2e84:	3d850513          	addi	a0,a0,984 # 7258 <malloc+0x15a6>
    2e88:	00003097          	auipc	ra,0x3
    2e8c:	d6c080e7          	jalr	-660(ra) # 5bf4 <printf>
    exit(1);
    2e90:	4505                	li	a0,1
    2e92:	00003097          	auipc	ra,0x3
    2e96:	9da080e7          	jalr	-1574(ra) # 586c <exit>
    printf("%s: chdir iputdir failed\n", s);
    2e9a:	85a6                	mv	a1,s1
    2e9c:	00004517          	auipc	a0,0x4
    2ea0:	3d450513          	addi	a0,a0,980 # 7270 <malloc+0x15be>
    2ea4:	00003097          	auipc	ra,0x3
    2ea8:	d50080e7          	jalr	-688(ra) # 5bf4 <printf>
    exit(1);
    2eac:	4505                	li	a0,1
    2eae:	00003097          	auipc	ra,0x3
    2eb2:	9be080e7          	jalr	-1602(ra) # 586c <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2eb6:	85a6                	mv	a1,s1
    2eb8:	00004517          	auipc	a0,0x4
    2ebc:	3e850513          	addi	a0,a0,1000 # 72a0 <malloc+0x15ee>
    2ec0:	00003097          	auipc	ra,0x3
    2ec4:	d34080e7          	jalr	-716(ra) # 5bf4 <printf>
    exit(1);
    2ec8:	4505                	li	a0,1
    2eca:	00003097          	auipc	ra,0x3
    2ece:	9a2080e7          	jalr	-1630(ra) # 586c <exit>
    printf("%s: chdir / failed\n", s);
    2ed2:	85a6                	mv	a1,s1
    2ed4:	00004517          	auipc	a0,0x4
    2ed8:	3f450513          	addi	a0,a0,1012 # 72c8 <malloc+0x1616>
    2edc:	00003097          	auipc	ra,0x3
    2ee0:	d18080e7          	jalr	-744(ra) # 5bf4 <printf>
    exit(1);
    2ee4:	4505                	li	a0,1
    2ee6:	00003097          	auipc	ra,0x3
    2eea:	986080e7          	jalr	-1658(ra) # 586c <exit>

0000000000002eee <exitiputtest>:
{
    2eee:	7179                	addi	sp,sp,-48
    2ef0:	f406                	sd	ra,40(sp)
    2ef2:	f022                	sd	s0,32(sp)
    2ef4:	ec26                	sd	s1,24(sp)
    2ef6:	1800                	addi	s0,sp,48
    2ef8:	84aa                	mv	s1,a0
  pid = fork();
    2efa:	00003097          	auipc	ra,0x3
    2efe:	96a080e7          	jalr	-1686(ra) # 5864 <fork>
  if(pid < 0){
    2f02:	04054663          	bltz	a0,2f4e <exitiputtest+0x60>
  if(pid == 0){
    2f06:	ed45                	bnez	a0,2fbe <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2f08:	00004517          	auipc	a0,0x4
    2f0c:	34850513          	addi	a0,a0,840 # 7250 <malloc+0x159e>
    2f10:	00003097          	auipc	ra,0x3
    2f14:	9c4080e7          	jalr	-1596(ra) # 58d4 <mkdir>
    2f18:	04054963          	bltz	a0,2f6a <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2f1c:	00004517          	auipc	a0,0x4
    2f20:	33450513          	addi	a0,a0,820 # 7250 <malloc+0x159e>
    2f24:	00003097          	auipc	ra,0x3
    2f28:	9b8080e7          	jalr	-1608(ra) # 58dc <chdir>
    2f2c:	04054d63          	bltz	a0,2f86 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2f30:	00004517          	auipc	a0,0x4
    2f34:	36050513          	addi	a0,a0,864 # 7290 <malloc+0x15de>
    2f38:	00003097          	auipc	ra,0x3
    2f3c:	984080e7          	jalr	-1660(ra) # 58bc <unlink>
    2f40:	06054163          	bltz	a0,2fa2 <exitiputtest+0xb4>
    exit(0);
    2f44:	4501                	li	a0,0
    2f46:	00003097          	auipc	ra,0x3
    2f4a:	926080e7          	jalr	-1754(ra) # 586c <exit>
    printf("%s: fork failed\n", s);
    2f4e:	85a6                	mv	a1,s1
    2f50:	00004517          	auipc	a0,0x4
    2f54:	9a850513          	addi	a0,a0,-1624 # 68f8 <malloc+0xc46>
    2f58:	00003097          	auipc	ra,0x3
    2f5c:	c9c080e7          	jalr	-868(ra) # 5bf4 <printf>
    exit(1);
    2f60:	4505                	li	a0,1
    2f62:	00003097          	auipc	ra,0x3
    2f66:	90a080e7          	jalr	-1782(ra) # 586c <exit>
      printf("%s: mkdir failed\n", s);
    2f6a:	85a6                	mv	a1,s1
    2f6c:	00004517          	auipc	a0,0x4
    2f70:	2ec50513          	addi	a0,a0,748 # 7258 <malloc+0x15a6>
    2f74:	00003097          	auipc	ra,0x3
    2f78:	c80080e7          	jalr	-896(ra) # 5bf4 <printf>
      exit(1);
    2f7c:	4505                	li	a0,1
    2f7e:	00003097          	auipc	ra,0x3
    2f82:	8ee080e7          	jalr	-1810(ra) # 586c <exit>
      printf("%s: child chdir failed\n", s);
    2f86:	85a6                	mv	a1,s1
    2f88:	00004517          	auipc	a0,0x4
    2f8c:	35850513          	addi	a0,a0,856 # 72e0 <malloc+0x162e>
    2f90:	00003097          	auipc	ra,0x3
    2f94:	c64080e7          	jalr	-924(ra) # 5bf4 <printf>
      exit(1);
    2f98:	4505                	li	a0,1
    2f9a:	00003097          	auipc	ra,0x3
    2f9e:	8d2080e7          	jalr	-1838(ra) # 586c <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2fa2:	85a6                	mv	a1,s1
    2fa4:	00004517          	auipc	a0,0x4
    2fa8:	2fc50513          	addi	a0,a0,764 # 72a0 <malloc+0x15ee>
    2fac:	00003097          	auipc	ra,0x3
    2fb0:	c48080e7          	jalr	-952(ra) # 5bf4 <printf>
      exit(1);
    2fb4:	4505                	li	a0,1
    2fb6:	00003097          	auipc	ra,0x3
    2fba:	8b6080e7          	jalr	-1866(ra) # 586c <exit>
  wait(&xstatus);
    2fbe:	fdc40513          	addi	a0,s0,-36
    2fc2:	00003097          	auipc	ra,0x3
    2fc6:	8b2080e7          	jalr	-1870(ra) # 5874 <wait>
  exit(xstatus);
    2fca:	fdc42503          	lw	a0,-36(s0)
    2fce:	00003097          	auipc	ra,0x3
    2fd2:	89e080e7          	jalr	-1890(ra) # 586c <exit>

0000000000002fd6 <dirtest>:
{
    2fd6:	1101                	addi	sp,sp,-32
    2fd8:	ec06                	sd	ra,24(sp)
    2fda:	e822                	sd	s0,16(sp)
    2fdc:	e426                	sd	s1,8(sp)
    2fde:	1000                	addi	s0,sp,32
    2fe0:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2fe2:	00004517          	auipc	a0,0x4
    2fe6:	31650513          	addi	a0,a0,790 # 72f8 <malloc+0x1646>
    2fea:	00003097          	auipc	ra,0x3
    2fee:	8ea080e7          	jalr	-1814(ra) # 58d4 <mkdir>
    2ff2:	04054563          	bltz	a0,303c <dirtest+0x66>
  if(chdir("dir0") < 0){
    2ff6:	00004517          	auipc	a0,0x4
    2ffa:	30250513          	addi	a0,a0,770 # 72f8 <malloc+0x1646>
    2ffe:	00003097          	auipc	ra,0x3
    3002:	8de080e7          	jalr	-1826(ra) # 58dc <chdir>
    3006:	04054963          	bltz	a0,3058 <dirtest+0x82>
  if(chdir("..") < 0){
    300a:	00004517          	auipc	a0,0x4
    300e:	30e50513          	addi	a0,a0,782 # 7318 <malloc+0x1666>
    3012:	00003097          	auipc	ra,0x3
    3016:	8ca080e7          	jalr	-1846(ra) # 58dc <chdir>
    301a:	04054d63          	bltz	a0,3074 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    301e:	00004517          	auipc	a0,0x4
    3022:	2da50513          	addi	a0,a0,730 # 72f8 <malloc+0x1646>
    3026:	00003097          	auipc	ra,0x3
    302a:	896080e7          	jalr	-1898(ra) # 58bc <unlink>
    302e:	06054163          	bltz	a0,3090 <dirtest+0xba>
}
    3032:	60e2                	ld	ra,24(sp)
    3034:	6442                	ld	s0,16(sp)
    3036:	64a2                	ld	s1,8(sp)
    3038:	6105                	addi	sp,sp,32
    303a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    303c:	85a6                	mv	a1,s1
    303e:	00004517          	auipc	a0,0x4
    3042:	21a50513          	addi	a0,a0,538 # 7258 <malloc+0x15a6>
    3046:	00003097          	auipc	ra,0x3
    304a:	bae080e7          	jalr	-1106(ra) # 5bf4 <printf>
    exit(1);
    304e:	4505                	li	a0,1
    3050:	00003097          	auipc	ra,0x3
    3054:	81c080e7          	jalr	-2020(ra) # 586c <exit>
    printf("%s: chdir dir0 failed\n", s);
    3058:	85a6                	mv	a1,s1
    305a:	00004517          	auipc	a0,0x4
    305e:	2a650513          	addi	a0,a0,678 # 7300 <malloc+0x164e>
    3062:	00003097          	auipc	ra,0x3
    3066:	b92080e7          	jalr	-1134(ra) # 5bf4 <printf>
    exit(1);
    306a:	4505                	li	a0,1
    306c:	00003097          	auipc	ra,0x3
    3070:	800080e7          	jalr	-2048(ra) # 586c <exit>
    printf("%s: chdir .. failed\n", s);
    3074:	85a6                	mv	a1,s1
    3076:	00004517          	auipc	a0,0x4
    307a:	2aa50513          	addi	a0,a0,682 # 7320 <malloc+0x166e>
    307e:	00003097          	auipc	ra,0x3
    3082:	b76080e7          	jalr	-1162(ra) # 5bf4 <printf>
    exit(1);
    3086:	4505                	li	a0,1
    3088:	00002097          	auipc	ra,0x2
    308c:	7e4080e7          	jalr	2020(ra) # 586c <exit>
    printf("%s: unlink dir0 failed\n", s);
    3090:	85a6                	mv	a1,s1
    3092:	00004517          	auipc	a0,0x4
    3096:	2a650513          	addi	a0,a0,678 # 7338 <malloc+0x1686>
    309a:	00003097          	auipc	ra,0x3
    309e:	b5a080e7          	jalr	-1190(ra) # 5bf4 <printf>
    exit(1);
    30a2:	4505                	li	a0,1
    30a4:	00002097          	auipc	ra,0x2
    30a8:	7c8080e7          	jalr	1992(ra) # 586c <exit>

00000000000030ac <subdir>:
{
    30ac:	1101                	addi	sp,sp,-32
    30ae:	ec06                	sd	ra,24(sp)
    30b0:	e822                	sd	s0,16(sp)
    30b2:	e426                	sd	s1,8(sp)
    30b4:	e04a                	sd	s2,0(sp)
    30b6:	1000                	addi	s0,sp,32
    30b8:	892a                	mv	s2,a0
  unlink("ff");
    30ba:	00004517          	auipc	a0,0x4
    30be:	3c650513          	addi	a0,a0,966 # 7480 <malloc+0x17ce>
    30c2:	00002097          	auipc	ra,0x2
    30c6:	7fa080e7          	jalr	2042(ra) # 58bc <unlink>
  if(mkdir("dd") != 0){
    30ca:	00004517          	auipc	a0,0x4
    30ce:	28650513          	addi	a0,a0,646 # 7350 <malloc+0x169e>
    30d2:	00003097          	auipc	ra,0x3
    30d6:	802080e7          	jalr	-2046(ra) # 58d4 <mkdir>
    30da:	38051663          	bnez	a0,3466 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    30de:	20200593          	li	a1,514
    30e2:	00004517          	auipc	a0,0x4
    30e6:	28e50513          	addi	a0,a0,654 # 7370 <malloc+0x16be>
    30ea:	00002097          	auipc	ra,0x2
    30ee:	7c2080e7          	jalr	1986(ra) # 58ac <open>
    30f2:	84aa                	mv	s1,a0
  if(fd < 0){
    30f4:	38054763          	bltz	a0,3482 <subdir+0x3d6>
  write(fd, "ff", 2);
    30f8:	4609                	li	a2,2
    30fa:	00004597          	auipc	a1,0x4
    30fe:	38658593          	addi	a1,a1,902 # 7480 <malloc+0x17ce>
    3102:	00002097          	auipc	ra,0x2
    3106:	78a080e7          	jalr	1930(ra) # 588c <write>
  close(fd);
    310a:	8526                	mv	a0,s1
    310c:	00002097          	auipc	ra,0x2
    3110:	788080e7          	jalr	1928(ra) # 5894 <close>
  if(unlink("dd") >= 0){
    3114:	00004517          	auipc	a0,0x4
    3118:	23c50513          	addi	a0,a0,572 # 7350 <malloc+0x169e>
    311c:	00002097          	auipc	ra,0x2
    3120:	7a0080e7          	jalr	1952(ra) # 58bc <unlink>
    3124:	36055d63          	bgez	a0,349e <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    3128:	00004517          	auipc	a0,0x4
    312c:	2a050513          	addi	a0,a0,672 # 73c8 <malloc+0x1716>
    3130:	00002097          	auipc	ra,0x2
    3134:	7a4080e7          	jalr	1956(ra) # 58d4 <mkdir>
    3138:	38051163          	bnez	a0,34ba <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    313c:	20200593          	li	a1,514
    3140:	00004517          	auipc	a0,0x4
    3144:	2b050513          	addi	a0,a0,688 # 73f0 <malloc+0x173e>
    3148:	00002097          	auipc	ra,0x2
    314c:	764080e7          	jalr	1892(ra) # 58ac <open>
    3150:	84aa                	mv	s1,a0
  if(fd < 0){
    3152:	38054263          	bltz	a0,34d6 <subdir+0x42a>
  write(fd, "FF", 2);
    3156:	4609                	li	a2,2
    3158:	00004597          	auipc	a1,0x4
    315c:	2c858593          	addi	a1,a1,712 # 7420 <malloc+0x176e>
    3160:	00002097          	auipc	ra,0x2
    3164:	72c080e7          	jalr	1836(ra) # 588c <write>
  close(fd);
    3168:	8526                	mv	a0,s1
    316a:	00002097          	auipc	ra,0x2
    316e:	72a080e7          	jalr	1834(ra) # 5894 <close>
  fd = open("dd/dd/../ff", 0);
    3172:	4581                	li	a1,0
    3174:	00004517          	auipc	a0,0x4
    3178:	2b450513          	addi	a0,a0,692 # 7428 <malloc+0x1776>
    317c:	00002097          	auipc	ra,0x2
    3180:	730080e7          	jalr	1840(ra) # 58ac <open>
    3184:	84aa                	mv	s1,a0
  if(fd < 0){
    3186:	36054663          	bltz	a0,34f2 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    318a:	660d                	lui	a2,0x3
    318c:	00009597          	auipc	a1,0x9
    3190:	c1c58593          	addi	a1,a1,-996 # bda8 <buf>
    3194:	00002097          	auipc	ra,0x2
    3198:	6f0080e7          	jalr	1776(ra) # 5884 <read>
  if(cc != 2 || buf[0] != 'f'){
    319c:	4789                	li	a5,2
    319e:	36f51863          	bne	a0,a5,350e <subdir+0x462>
    31a2:	00009717          	auipc	a4,0x9
    31a6:	c0674703          	lbu	a4,-1018(a4) # bda8 <buf>
    31aa:	06600793          	li	a5,102
    31ae:	36f71063          	bne	a4,a5,350e <subdir+0x462>
  close(fd);
    31b2:	8526                	mv	a0,s1
    31b4:	00002097          	auipc	ra,0x2
    31b8:	6e0080e7          	jalr	1760(ra) # 5894 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    31bc:	00004597          	auipc	a1,0x4
    31c0:	2bc58593          	addi	a1,a1,700 # 7478 <malloc+0x17c6>
    31c4:	00004517          	auipc	a0,0x4
    31c8:	22c50513          	addi	a0,a0,556 # 73f0 <malloc+0x173e>
    31cc:	00002097          	auipc	ra,0x2
    31d0:	700080e7          	jalr	1792(ra) # 58cc <link>
    31d4:	34051b63          	bnez	a0,352a <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    31d8:	00004517          	auipc	a0,0x4
    31dc:	21850513          	addi	a0,a0,536 # 73f0 <malloc+0x173e>
    31e0:	00002097          	auipc	ra,0x2
    31e4:	6dc080e7          	jalr	1756(ra) # 58bc <unlink>
    31e8:	34051f63          	bnez	a0,3546 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    31ec:	4581                	li	a1,0
    31ee:	00004517          	auipc	a0,0x4
    31f2:	20250513          	addi	a0,a0,514 # 73f0 <malloc+0x173e>
    31f6:	00002097          	auipc	ra,0x2
    31fa:	6b6080e7          	jalr	1718(ra) # 58ac <open>
    31fe:	36055263          	bgez	a0,3562 <subdir+0x4b6>
  if(chdir("dd") != 0){
    3202:	00004517          	auipc	a0,0x4
    3206:	14e50513          	addi	a0,a0,334 # 7350 <malloc+0x169e>
    320a:	00002097          	auipc	ra,0x2
    320e:	6d2080e7          	jalr	1746(ra) # 58dc <chdir>
    3212:	36051663          	bnez	a0,357e <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3216:	00004517          	auipc	a0,0x4
    321a:	2fa50513          	addi	a0,a0,762 # 7510 <malloc+0x185e>
    321e:	00002097          	auipc	ra,0x2
    3222:	6be080e7          	jalr	1726(ra) # 58dc <chdir>
    3226:	36051a63          	bnez	a0,359a <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    322a:	00004517          	auipc	a0,0x4
    322e:	31650513          	addi	a0,a0,790 # 7540 <malloc+0x188e>
    3232:	00002097          	auipc	ra,0x2
    3236:	6aa080e7          	jalr	1706(ra) # 58dc <chdir>
    323a:	36051e63          	bnez	a0,35b6 <subdir+0x50a>
  if(chdir("./..") != 0){
    323e:	00004517          	auipc	a0,0x4
    3242:	33250513          	addi	a0,a0,818 # 7570 <malloc+0x18be>
    3246:	00002097          	auipc	ra,0x2
    324a:	696080e7          	jalr	1686(ra) # 58dc <chdir>
    324e:	38051263          	bnez	a0,35d2 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3252:	4581                	li	a1,0
    3254:	00004517          	auipc	a0,0x4
    3258:	22450513          	addi	a0,a0,548 # 7478 <malloc+0x17c6>
    325c:	00002097          	auipc	ra,0x2
    3260:	650080e7          	jalr	1616(ra) # 58ac <open>
    3264:	84aa                	mv	s1,a0
  if(fd < 0){
    3266:	38054463          	bltz	a0,35ee <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    326a:	660d                	lui	a2,0x3
    326c:	00009597          	auipc	a1,0x9
    3270:	b3c58593          	addi	a1,a1,-1220 # bda8 <buf>
    3274:	00002097          	auipc	ra,0x2
    3278:	610080e7          	jalr	1552(ra) # 5884 <read>
    327c:	4789                	li	a5,2
    327e:	38f51663          	bne	a0,a5,360a <subdir+0x55e>
  close(fd);
    3282:	8526                	mv	a0,s1
    3284:	00002097          	auipc	ra,0x2
    3288:	610080e7          	jalr	1552(ra) # 5894 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    328c:	4581                	li	a1,0
    328e:	00004517          	auipc	a0,0x4
    3292:	16250513          	addi	a0,a0,354 # 73f0 <malloc+0x173e>
    3296:	00002097          	auipc	ra,0x2
    329a:	616080e7          	jalr	1558(ra) # 58ac <open>
    329e:	38055463          	bgez	a0,3626 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    32a2:	20200593          	li	a1,514
    32a6:	00004517          	auipc	a0,0x4
    32aa:	35a50513          	addi	a0,a0,858 # 7600 <malloc+0x194e>
    32ae:	00002097          	auipc	ra,0x2
    32b2:	5fe080e7          	jalr	1534(ra) # 58ac <open>
    32b6:	38055663          	bgez	a0,3642 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    32ba:	20200593          	li	a1,514
    32be:	00004517          	auipc	a0,0x4
    32c2:	37250513          	addi	a0,a0,882 # 7630 <malloc+0x197e>
    32c6:	00002097          	auipc	ra,0x2
    32ca:	5e6080e7          	jalr	1510(ra) # 58ac <open>
    32ce:	38055863          	bgez	a0,365e <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    32d2:	20000593          	li	a1,512
    32d6:	00004517          	auipc	a0,0x4
    32da:	07a50513          	addi	a0,a0,122 # 7350 <malloc+0x169e>
    32de:	00002097          	auipc	ra,0x2
    32e2:	5ce080e7          	jalr	1486(ra) # 58ac <open>
    32e6:	38055a63          	bgez	a0,367a <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    32ea:	4589                	li	a1,2
    32ec:	00004517          	auipc	a0,0x4
    32f0:	06450513          	addi	a0,a0,100 # 7350 <malloc+0x169e>
    32f4:	00002097          	auipc	ra,0x2
    32f8:	5b8080e7          	jalr	1464(ra) # 58ac <open>
    32fc:	38055d63          	bgez	a0,3696 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    3300:	4585                	li	a1,1
    3302:	00004517          	auipc	a0,0x4
    3306:	04e50513          	addi	a0,a0,78 # 7350 <malloc+0x169e>
    330a:	00002097          	auipc	ra,0x2
    330e:	5a2080e7          	jalr	1442(ra) # 58ac <open>
    3312:	3a055063          	bgez	a0,36b2 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3316:	00004597          	auipc	a1,0x4
    331a:	3aa58593          	addi	a1,a1,938 # 76c0 <malloc+0x1a0e>
    331e:	00004517          	auipc	a0,0x4
    3322:	2e250513          	addi	a0,a0,738 # 7600 <malloc+0x194e>
    3326:	00002097          	auipc	ra,0x2
    332a:	5a6080e7          	jalr	1446(ra) # 58cc <link>
    332e:	3a050063          	beqz	a0,36ce <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3332:	00004597          	auipc	a1,0x4
    3336:	38e58593          	addi	a1,a1,910 # 76c0 <malloc+0x1a0e>
    333a:	00004517          	auipc	a0,0x4
    333e:	2f650513          	addi	a0,a0,758 # 7630 <malloc+0x197e>
    3342:	00002097          	auipc	ra,0x2
    3346:	58a080e7          	jalr	1418(ra) # 58cc <link>
    334a:	3a050063          	beqz	a0,36ea <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    334e:	00004597          	auipc	a1,0x4
    3352:	12a58593          	addi	a1,a1,298 # 7478 <malloc+0x17c6>
    3356:	00004517          	auipc	a0,0x4
    335a:	01a50513          	addi	a0,a0,26 # 7370 <malloc+0x16be>
    335e:	00002097          	auipc	ra,0x2
    3362:	56e080e7          	jalr	1390(ra) # 58cc <link>
    3366:	3a050063          	beqz	a0,3706 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    336a:	00004517          	auipc	a0,0x4
    336e:	29650513          	addi	a0,a0,662 # 7600 <malloc+0x194e>
    3372:	00002097          	auipc	ra,0x2
    3376:	562080e7          	jalr	1378(ra) # 58d4 <mkdir>
    337a:	3a050463          	beqz	a0,3722 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    337e:	00004517          	auipc	a0,0x4
    3382:	2b250513          	addi	a0,a0,690 # 7630 <malloc+0x197e>
    3386:	00002097          	auipc	ra,0x2
    338a:	54e080e7          	jalr	1358(ra) # 58d4 <mkdir>
    338e:	3a050863          	beqz	a0,373e <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3392:	00004517          	auipc	a0,0x4
    3396:	0e650513          	addi	a0,a0,230 # 7478 <malloc+0x17c6>
    339a:	00002097          	auipc	ra,0x2
    339e:	53a080e7          	jalr	1338(ra) # 58d4 <mkdir>
    33a2:	3a050c63          	beqz	a0,375a <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    33a6:	00004517          	auipc	a0,0x4
    33aa:	28a50513          	addi	a0,a0,650 # 7630 <malloc+0x197e>
    33ae:	00002097          	auipc	ra,0x2
    33b2:	50e080e7          	jalr	1294(ra) # 58bc <unlink>
    33b6:	3c050063          	beqz	a0,3776 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    33ba:	00004517          	auipc	a0,0x4
    33be:	24650513          	addi	a0,a0,582 # 7600 <malloc+0x194e>
    33c2:	00002097          	auipc	ra,0x2
    33c6:	4fa080e7          	jalr	1274(ra) # 58bc <unlink>
    33ca:	3c050463          	beqz	a0,3792 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    33ce:	00004517          	auipc	a0,0x4
    33d2:	fa250513          	addi	a0,a0,-94 # 7370 <malloc+0x16be>
    33d6:	00002097          	auipc	ra,0x2
    33da:	506080e7          	jalr	1286(ra) # 58dc <chdir>
    33de:	3c050863          	beqz	a0,37ae <subdir+0x702>
  if(chdir("dd/xx") == 0){
    33e2:	00004517          	auipc	a0,0x4
    33e6:	42e50513          	addi	a0,a0,1070 # 7810 <malloc+0x1b5e>
    33ea:	00002097          	auipc	ra,0x2
    33ee:	4f2080e7          	jalr	1266(ra) # 58dc <chdir>
    33f2:	3c050c63          	beqz	a0,37ca <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    33f6:	00004517          	auipc	a0,0x4
    33fa:	08250513          	addi	a0,a0,130 # 7478 <malloc+0x17c6>
    33fe:	00002097          	auipc	ra,0x2
    3402:	4be080e7          	jalr	1214(ra) # 58bc <unlink>
    3406:	3e051063          	bnez	a0,37e6 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    340a:	00004517          	auipc	a0,0x4
    340e:	f6650513          	addi	a0,a0,-154 # 7370 <malloc+0x16be>
    3412:	00002097          	auipc	ra,0x2
    3416:	4aa080e7          	jalr	1194(ra) # 58bc <unlink>
    341a:	3e051463          	bnez	a0,3802 <subdir+0x756>
  if(unlink("dd") == 0){
    341e:	00004517          	auipc	a0,0x4
    3422:	f3250513          	addi	a0,a0,-206 # 7350 <malloc+0x169e>
    3426:	00002097          	auipc	ra,0x2
    342a:	496080e7          	jalr	1174(ra) # 58bc <unlink>
    342e:	3e050863          	beqz	a0,381e <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3432:	00004517          	auipc	a0,0x4
    3436:	44e50513          	addi	a0,a0,1102 # 7880 <malloc+0x1bce>
    343a:	00002097          	auipc	ra,0x2
    343e:	482080e7          	jalr	1154(ra) # 58bc <unlink>
    3442:	3e054c63          	bltz	a0,383a <subdir+0x78e>
  if(unlink("dd") < 0){
    3446:	00004517          	auipc	a0,0x4
    344a:	f0a50513          	addi	a0,a0,-246 # 7350 <malloc+0x169e>
    344e:	00002097          	auipc	ra,0x2
    3452:	46e080e7          	jalr	1134(ra) # 58bc <unlink>
    3456:	40054063          	bltz	a0,3856 <subdir+0x7aa>
}
    345a:	60e2                	ld	ra,24(sp)
    345c:	6442                	ld	s0,16(sp)
    345e:	64a2                	ld	s1,8(sp)
    3460:	6902                	ld	s2,0(sp)
    3462:	6105                	addi	sp,sp,32
    3464:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3466:	85ca                	mv	a1,s2
    3468:	00004517          	auipc	a0,0x4
    346c:	ef050513          	addi	a0,a0,-272 # 7358 <malloc+0x16a6>
    3470:	00002097          	auipc	ra,0x2
    3474:	784080e7          	jalr	1924(ra) # 5bf4 <printf>
    exit(1);
    3478:	4505                	li	a0,1
    347a:	00002097          	auipc	ra,0x2
    347e:	3f2080e7          	jalr	1010(ra) # 586c <exit>
    printf("%s: create dd/ff failed\n", s);
    3482:	85ca                	mv	a1,s2
    3484:	00004517          	auipc	a0,0x4
    3488:	ef450513          	addi	a0,a0,-268 # 7378 <malloc+0x16c6>
    348c:	00002097          	auipc	ra,0x2
    3490:	768080e7          	jalr	1896(ra) # 5bf4 <printf>
    exit(1);
    3494:	4505                	li	a0,1
    3496:	00002097          	auipc	ra,0x2
    349a:	3d6080e7          	jalr	982(ra) # 586c <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    349e:	85ca                	mv	a1,s2
    34a0:	00004517          	auipc	a0,0x4
    34a4:	ef850513          	addi	a0,a0,-264 # 7398 <malloc+0x16e6>
    34a8:	00002097          	auipc	ra,0x2
    34ac:	74c080e7          	jalr	1868(ra) # 5bf4 <printf>
    exit(1);
    34b0:	4505                	li	a0,1
    34b2:	00002097          	auipc	ra,0x2
    34b6:	3ba080e7          	jalr	954(ra) # 586c <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    34ba:	85ca                	mv	a1,s2
    34bc:	00004517          	auipc	a0,0x4
    34c0:	f1450513          	addi	a0,a0,-236 # 73d0 <malloc+0x171e>
    34c4:	00002097          	auipc	ra,0x2
    34c8:	730080e7          	jalr	1840(ra) # 5bf4 <printf>
    exit(1);
    34cc:	4505                	li	a0,1
    34ce:	00002097          	auipc	ra,0x2
    34d2:	39e080e7          	jalr	926(ra) # 586c <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    34d6:	85ca                	mv	a1,s2
    34d8:	00004517          	auipc	a0,0x4
    34dc:	f2850513          	addi	a0,a0,-216 # 7400 <malloc+0x174e>
    34e0:	00002097          	auipc	ra,0x2
    34e4:	714080e7          	jalr	1812(ra) # 5bf4 <printf>
    exit(1);
    34e8:	4505                	li	a0,1
    34ea:	00002097          	auipc	ra,0x2
    34ee:	382080e7          	jalr	898(ra) # 586c <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    34f2:	85ca                	mv	a1,s2
    34f4:	00004517          	auipc	a0,0x4
    34f8:	f4450513          	addi	a0,a0,-188 # 7438 <malloc+0x1786>
    34fc:	00002097          	auipc	ra,0x2
    3500:	6f8080e7          	jalr	1784(ra) # 5bf4 <printf>
    exit(1);
    3504:	4505                	li	a0,1
    3506:	00002097          	auipc	ra,0x2
    350a:	366080e7          	jalr	870(ra) # 586c <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    350e:	85ca                	mv	a1,s2
    3510:	00004517          	auipc	a0,0x4
    3514:	f4850513          	addi	a0,a0,-184 # 7458 <malloc+0x17a6>
    3518:	00002097          	auipc	ra,0x2
    351c:	6dc080e7          	jalr	1756(ra) # 5bf4 <printf>
    exit(1);
    3520:	4505                	li	a0,1
    3522:	00002097          	auipc	ra,0x2
    3526:	34a080e7          	jalr	842(ra) # 586c <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    352a:	85ca                	mv	a1,s2
    352c:	00004517          	auipc	a0,0x4
    3530:	f5c50513          	addi	a0,a0,-164 # 7488 <malloc+0x17d6>
    3534:	00002097          	auipc	ra,0x2
    3538:	6c0080e7          	jalr	1728(ra) # 5bf4 <printf>
    exit(1);
    353c:	4505                	li	a0,1
    353e:	00002097          	auipc	ra,0x2
    3542:	32e080e7          	jalr	814(ra) # 586c <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3546:	85ca                	mv	a1,s2
    3548:	00004517          	auipc	a0,0x4
    354c:	f6850513          	addi	a0,a0,-152 # 74b0 <malloc+0x17fe>
    3550:	00002097          	auipc	ra,0x2
    3554:	6a4080e7          	jalr	1700(ra) # 5bf4 <printf>
    exit(1);
    3558:	4505                	li	a0,1
    355a:	00002097          	auipc	ra,0x2
    355e:	312080e7          	jalr	786(ra) # 586c <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3562:	85ca                	mv	a1,s2
    3564:	00004517          	auipc	a0,0x4
    3568:	f6c50513          	addi	a0,a0,-148 # 74d0 <malloc+0x181e>
    356c:	00002097          	auipc	ra,0x2
    3570:	688080e7          	jalr	1672(ra) # 5bf4 <printf>
    exit(1);
    3574:	4505                	li	a0,1
    3576:	00002097          	auipc	ra,0x2
    357a:	2f6080e7          	jalr	758(ra) # 586c <exit>
    printf("%s: chdir dd failed\n", s);
    357e:	85ca                	mv	a1,s2
    3580:	00004517          	auipc	a0,0x4
    3584:	f7850513          	addi	a0,a0,-136 # 74f8 <malloc+0x1846>
    3588:	00002097          	auipc	ra,0x2
    358c:	66c080e7          	jalr	1644(ra) # 5bf4 <printf>
    exit(1);
    3590:	4505                	li	a0,1
    3592:	00002097          	auipc	ra,0x2
    3596:	2da080e7          	jalr	730(ra) # 586c <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    359a:	85ca                	mv	a1,s2
    359c:	00004517          	auipc	a0,0x4
    35a0:	f8450513          	addi	a0,a0,-124 # 7520 <malloc+0x186e>
    35a4:	00002097          	auipc	ra,0x2
    35a8:	650080e7          	jalr	1616(ra) # 5bf4 <printf>
    exit(1);
    35ac:	4505                	li	a0,1
    35ae:	00002097          	auipc	ra,0x2
    35b2:	2be080e7          	jalr	702(ra) # 586c <exit>
    printf("chdir dd/../../dd failed\n", s);
    35b6:	85ca                	mv	a1,s2
    35b8:	00004517          	auipc	a0,0x4
    35bc:	f9850513          	addi	a0,a0,-104 # 7550 <malloc+0x189e>
    35c0:	00002097          	auipc	ra,0x2
    35c4:	634080e7          	jalr	1588(ra) # 5bf4 <printf>
    exit(1);
    35c8:	4505                	li	a0,1
    35ca:	00002097          	auipc	ra,0x2
    35ce:	2a2080e7          	jalr	674(ra) # 586c <exit>
    printf("%s: chdir ./.. failed\n", s);
    35d2:	85ca                	mv	a1,s2
    35d4:	00004517          	auipc	a0,0x4
    35d8:	fa450513          	addi	a0,a0,-92 # 7578 <malloc+0x18c6>
    35dc:	00002097          	auipc	ra,0x2
    35e0:	618080e7          	jalr	1560(ra) # 5bf4 <printf>
    exit(1);
    35e4:	4505                	li	a0,1
    35e6:	00002097          	auipc	ra,0x2
    35ea:	286080e7          	jalr	646(ra) # 586c <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    35ee:	85ca                	mv	a1,s2
    35f0:	00004517          	auipc	a0,0x4
    35f4:	fa050513          	addi	a0,a0,-96 # 7590 <malloc+0x18de>
    35f8:	00002097          	auipc	ra,0x2
    35fc:	5fc080e7          	jalr	1532(ra) # 5bf4 <printf>
    exit(1);
    3600:	4505                	li	a0,1
    3602:	00002097          	auipc	ra,0x2
    3606:	26a080e7          	jalr	618(ra) # 586c <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    360a:	85ca                	mv	a1,s2
    360c:	00004517          	auipc	a0,0x4
    3610:	fa450513          	addi	a0,a0,-92 # 75b0 <malloc+0x18fe>
    3614:	00002097          	auipc	ra,0x2
    3618:	5e0080e7          	jalr	1504(ra) # 5bf4 <printf>
    exit(1);
    361c:	4505                	li	a0,1
    361e:	00002097          	auipc	ra,0x2
    3622:	24e080e7          	jalr	590(ra) # 586c <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3626:	85ca                	mv	a1,s2
    3628:	00004517          	auipc	a0,0x4
    362c:	fa850513          	addi	a0,a0,-88 # 75d0 <malloc+0x191e>
    3630:	00002097          	auipc	ra,0x2
    3634:	5c4080e7          	jalr	1476(ra) # 5bf4 <printf>
    exit(1);
    3638:	4505                	li	a0,1
    363a:	00002097          	auipc	ra,0x2
    363e:	232080e7          	jalr	562(ra) # 586c <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3642:	85ca                	mv	a1,s2
    3644:	00004517          	auipc	a0,0x4
    3648:	fcc50513          	addi	a0,a0,-52 # 7610 <malloc+0x195e>
    364c:	00002097          	auipc	ra,0x2
    3650:	5a8080e7          	jalr	1448(ra) # 5bf4 <printf>
    exit(1);
    3654:	4505                	li	a0,1
    3656:	00002097          	auipc	ra,0x2
    365a:	216080e7          	jalr	534(ra) # 586c <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    365e:	85ca                	mv	a1,s2
    3660:	00004517          	auipc	a0,0x4
    3664:	fe050513          	addi	a0,a0,-32 # 7640 <malloc+0x198e>
    3668:	00002097          	auipc	ra,0x2
    366c:	58c080e7          	jalr	1420(ra) # 5bf4 <printf>
    exit(1);
    3670:	4505                	li	a0,1
    3672:	00002097          	auipc	ra,0x2
    3676:	1fa080e7          	jalr	506(ra) # 586c <exit>
    printf("%s: create dd succeeded!\n", s);
    367a:	85ca                	mv	a1,s2
    367c:	00004517          	auipc	a0,0x4
    3680:	fe450513          	addi	a0,a0,-28 # 7660 <malloc+0x19ae>
    3684:	00002097          	auipc	ra,0x2
    3688:	570080e7          	jalr	1392(ra) # 5bf4 <printf>
    exit(1);
    368c:	4505                	li	a0,1
    368e:	00002097          	auipc	ra,0x2
    3692:	1de080e7          	jalr	478(ra) # 586c <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3696:	85ca                	mv	a1,s2
    3698:	00004517          	auipc	a0,0x4
    369c:	fe850513          	addi	a0,a0,-24 # 7680 <malloc+0x19ce>
    36a0:	00002097          	auipc	ra,0x2
    36a4:	554080e7          	jalr	1364(ra) # 5bf4 <printf>
    exit(1);
    36a8:	4505                	li	a0,1
    36aa:	00002097          	auipc	ra,0x2
    36ae:	1c2080e7          	jalr	450(ra) # 586c <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    36b2:	85ca                	mv	a1,s2
    36b4:	00004517          	auipc	a0,0x4
    36b8:	fec50513          	addi	a0,a0,-20 # 76a0 <malloc+0x19ee>
    36bc:	00002097          	auipc	ra,0x2
    36c0:	538080e7          	jalr	1336(ra) # 5bf4 <printf>
    exit(1);
    36c4:	4505                	li	a0,1
    36c6:	00002097          	auipc	ra,0x2
    36ca:	1a6080e7          	jalr	422(ra) # 586c <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    36ce:	85ca                	mv	a1,s2
    36d0:	00004517          	auipc	a0,0x4
    36d4:	00050513          	mv	a0,a0
    36d8:	00002097          	auipc	ra,0x2
    36dc:	51c080e7          	jalr	1308(ra) # 5bf4 <printf>
    exit(1);
    36e0:	4505                	li	a0,1
    36e2:	00002097          	auipc	ra,0x2
    36e6:	18a080e7          	jalr	394(ra) # 586c <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    36ea:	85ca                	mv	a1,s2
    36ec:	00004517          	auipc	a0,0x4
    36f0:	00c50513          	addi	a0,a0,12 # 76f8 <malloc+0x1a46>
    36f4:	00002097          	auipc	ra,0x2
    36f8:	500080e7          	jalr	1280(ra) # 5bf4 <printf>
    exit(1);
    36fc:	4505                	li	a0,1
    36fe:	00002097          	auipc	ra,0x2
    3702:	16e080e7          	jalr	366(ra) # 586c <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3706:	85ca                	mv	a1,s2
    3708:	00004517          	auipc	a0,0x4
    370c:	01850513          	addi	a0,a0,24 # 7720 <malloc+0x1a6e>
    3710:	00002097          	auipc	ra,0x2
    3714:	4e4080e7          	jalr	1252(ra) # 5bf4 <printf>
    exit(1);
    3718:	4505                	li	a0,1
    371a:	00002097          	auipc	ra,0x2
    371e:	152080e7          	jalr	338(ra) # 586c <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3722:	85ca                	mv	a1,s2
    3724:	00004517          	auipc	a0,0x4
    3728:	02450513          	addi	a0,a0,36 # 7748 <malloc+0x1a96>
    372c:	00002097          	auipc	ra,0x2
    3730:	4c8080e7          	jalr	1224(ra) # 5bf4 <printf>
    exit(1);
    3734:	4505                	li	a0,1
    3736:	00002097          	auipc	ra,0x2
    373a:	136080e7          	jalr	310(ra) # 586c <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    373e:	85ca                	mv	a1,s2
    3740:	00004517          	auipc	a0,0x4
    3744:	02850513          	addi	a0,a0,40 # 7768 <malloc+0x1ab6>
    3748:	00002097          	auipc	ra,0x2
    374c:	4ac080e7          	jalr	1196(ra) # 5bf4 <printf>
    exit(1);
    3750:	4505                	li	a0,1
    3752:	00002097          	auipc	ra,0x2
    3756:	11a080e7          	jalr	282(ra) # 586c <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    375a:	85ca                	mv	a1,s2
    375c:	00004517          	auipc	a0,0x4
    3760:	02c50513          	addi	a0,a0,44 # 7788 <malloc+0x1ad6>
    3764:	00002097          	auipc	ra,0x2
    3768:	490080e7          	jalr	1168(ra) # 5bf4 <printf>
    exit(1);
    376c:	4505                	li	a0,1
    376e:	00002097          	auipc	ra,0x2
    3772:	0fe080e7          	jalr	254(ra) # 586c <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3776:	85ca                	mv	a1,s2
    3778:	00004517          	auipc	a0,0x4
    377c:	03850513          	addi	a0,a0,56 # 77b0 <malloc+0x1afe>
    3780:	00002097          	auipc	ra,0x2
    3784:	474080e7          	jalr	1140(ra) # 5bf4 <printf>
    exit(1);
    3788:	4505                	li	a0,1
    378a:	00002097          	auipc	ra,0x2
    378e:	0e2080e7          	jalr	226(ra) # 586c <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3792:	85ca                	mv	a1,s2
    3794:	00004517          	auipc	a0,0x4
    3798:	03c50513          	addi	a0,a0,60 # 77d0 <malloc+0x1b1e>
    379c:	00002097          	auipc	ra,0x2
    37a0:	458080e7          	jalr	1112(ra) # 5bf4 <printf>
    exit(1);
    37a4:	4505                	li	a0,1
    37a6:	00002097          	auipc	ra,0x2
    37aa:	0c6080e7          	jalr	198(ra) # 586c <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    37ae:	85ca                	mv	a1,s2
    37b0:	00004517          	auipc	a0,0x4
    37b4:	04050513          	addi	a0,a0,64 # 77f0 <malloc+0x1b3e>
    37b8:	00002097          	auipc	ra,0x2
    37bc:	43c080e7          	jalr	1084(ra) # 5bf4 <printf>
    exit(1);
    37c0:	4505                	li	a0,1
    37c2:	00002097          	auipc	ra,0x2
    37c6:	0aa080e7          	jalr	170(ra) # 586c <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    37ca:	85ca                	mv	a1,s2
    37cc:	00004517          	auipc	a0,0x4
    37d0:	04c50513          	addi	a0,a0,76 # 7818 <malloc+0x1b66>
    37d4:	00002097          	auipc	ra,0x2
    37d8:	420080e7          	jalr	1056(ra) # 5bf4 <printf>
    exit(1);
    37dc:	4505                	li	a0,1
    37de:	00002097          	auipc	ra,0x2
    37e2:	08e080e7          	jalr	142(ra) # 586c <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    37e6:	85ca                	mv	a1,s2
    37e8:	00004517          	auipc	a0,0x4
    37ec:	cc850513          	addi	a0,a0,-824 # 74b0 <malloc+0x17fe>
    37f0:	00002097          	auipc	ra,0x2
    37f4:	404080e7          	jalr	1028(ra) # 5bf4 <printf>
    exit(1);
    37f8:	4505                	li	a0,1
    37fa:	00002097          	auipc	ra,0x2
    37fe:	072080e7          	jalr	114(ra) # 586c <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3802:	85ca                	mv	a1,s2
    3804:	00004517          	auipc	a0,0x4
    3808:	03450513          	addi	a0,a0,52 # 7838 <malloc+0x1b86>
    380c:	00002097          	auipc	ra,0x2
    3810:	3e8080e7          	jalr	1000(ra) # 5bf4 <printf>
    exit(1);
    3814:	4505                	li	a0,1
    3816:	00002097          	auipc	ra,0x2
    381a:	056080e7          	jalr	86(ra) # 586c <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    381e:	85ca                	mv	a1,s2
    3820:	00004517          	auipc	a0,0x4
    3824:	03850513          	addi	a0,a0,56 # 7858 <malloc+0x1ba6>
    3828:	00002097          	auipc	ra,0x2
    382c:	3cc080e7          	jalr	972(ra) # 5bf4 <printf>
    exit(1);
    3830:	4505                	li	a0,1
    3832:	00002097          	auipc	ra,0x2
    3836:	03a080e7          	jalr	58(ra) # 586c <exit>
    printf("%s: unlink dd/dd failed\n", s);
    383a:	85ca                	mv	a1,s2
    383c:	00004517          	auipc	a0,0x4
    3840:	04c50513          	addi	a0,a0,76 # 7888 <malloc+0x1bd6>
    3844:	00002097          	auipc	ra,0x2
    3848:	3b0080e7          	jalr	944(ra) # 5bf4 <printf>
    exit(1);
    384c:	4505                	li	a0,1
    384e:	00002097          	auipc	ra,0x2
    3852:	01e080e7          	jalr	30(ra) # 586c <exit>
    printf("%s: unlink dd failed\n", s);
    3856:	85ca                	mv	a1,s2
    3858:	00004517          	auipc	a0,0x4
    385c:	05050513          	addi	a0,a0,80 # 78a8 <malloc+0x1bf6>
    3860:	00002097          	auipc	ra,0x2
    3864:	394080e7          	jalr	916(ra) # 5bf4 <printf>
    exit(1);
    3868:	4505                	li	a0,1
    386a:	00002097          	auipc	ra,0x2
    386e:	002080e7          	jalr	2(ra) # 586c <exit>

0000000000003872 <rmdot>:
{
    3872:	1101                	addi	sp,sp,-32
    3874:	ec06                	sd	ra,24(sp)
    3876:	e822                	sd	s0,16(sp)
    3878:	e426                	sd	s1,8(sp)
    387a:	1000                	addi	s0,sp,32
    387c:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    387e:	00004517          	auipc	a0,0x4
    3882:	04250513          	addi	a0,a0,66 # 78c0 <malloc+0x1c0e>
    3886:	00002097          	auipc	ra,0x2
    388a:	04e080e7          	jalr	78(ra) # 58d4 <mkdir>
    388e:	e549                	bnez	a0,3918 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3890:	00004517          	auipc	a0,0x4
    3894:	03050513          	addi	a0,a0,48 # 78c0 <malloc+0x1c0e>
    3898:	00002097          	auipc	ra,0x2
    389c:	044080e7          	jalr	68(ra) # 58dc <chdir>
    38a0:	e951                	bnez	a0,3934 <rmdot+0xc2>
  if(unlink(".") == 0){
    38a2:	00003517          	auipc	a0,0x3
    38a6:	f1e50513          	addi	a0,a0,-226 # 67c0 <malloc+0xb0e>
    38aa:	00002097          	auipc	ra,0x2
    38ae:	012080e7          	jalr	18(ra) # 58bc <unlink>
    38b2:	cd59                	beqz	a0,3950 <rmdot+0xde>
  if(unlink("..") == 0){
    38b4:	00004517          	auipc	a0,0x4
    38b8:	a6450513          	addi	a0,a0,-1436 # 7318 <malloc+0x1666>
    38bc:	00002097          	auipc	ra,0x2
    38c0:	000080e7          	jalr	ra # 58bc <unlink>
    38c4:	c545                	beqz	a0,396c <rmdot+0xfa>
  if(chdir("/") != 0){
    38c6:	00004517          	auipc	a0,0x4
    38ca:	9fa50513          	addi	a0,a0,-1542 # 72c0 <malloc+0x160e>
    38ce:	00002097          	auipc	ra,0x2
    38d2:	00e080e7          	jalr	14(ra) # 58dc <chdir>
    38d6:	e94d                	bnez	a0,3988 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    38d8:	00004517          	auipc	a0,0x4
    38dc:	05050513          	addi	a0,a0,80 # 7928 <malloc+0x1c76>
    38e0:	00002097          	auipc	ra,0x2
    38e4:	fdc080e7          	jalr	-36(ra) # 58bc <unlink>
    38e8:	cd55                	beqz	a0,39a4 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    38ea:	00004517          	auipc	a0,0x4
    38ee:	06650513          	addi	a0,a0,102 # 7950 <malloc+0x1c9e>
    38f2:	00002097          	auipc	ra,0x2
    38f6:	fca080e7          	jalr	-54(ra) # 58bc <unlink>
    38fa:	c179                	beqz	a0,39c0 <rmdot+0x14e>
  if(unlink("dots") != 0){
    38fc:	00004517          	auipc	a0,0x4
    3900:	fc450513          	addi	a0,a0,-60 # 78c0 <malloc+0x1c0e>
    3904:	00002097          	auipc	ra,0x2
    3908:	fb8080e7          	jalr	-72(ra) # 58bc <unlink>
    390c:	e961                	bnez	a0,39dc <rmdot+0x16a>
}
    390e:	60e2                	ld	ra,24(sp)
    3910:	6442                	ld	s0,16(sp)
    3912:	64a2                	ld	s1,8(sp)
    3914:	6105                	addi	sp,sp,32
    3916:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3918:	85a6                	mv	a1,s1
    391a:	00004517          	auipc	a0,0x4
    391e:	fae50513          	addi	a0,a0,-82 # 78c8 <malloc+0x1c16>
    3922:	00002097          	auipc	ra,0x2
    3926:	2d2080e7          	jalr	722(ra) # 5bf4 <printf>
    exit(1);
    392a:	4505                	li	a0,1
    392c:	00002097          	auipc	ra,0x2
    3930:	f40080e7          	jalr	-192(ra) # 586c <exit>
    printf("%s: chdir dots failed\n", s);
    3934:	85a6                	mv	a1,s1
    3936:	00004517          	auipc	a0,0x4
    393a:	faa50513          	addi	a0,a0,-86 # 78e0 <malloc+0x1c2e>
    393e:	00002097          	auipc	ra,0x2
    3942:	2b6080e7          	jalr	694(ra) # 5bf4 <printf>
    exit(1);
    3946:	4505                	li	a0,1
    3948:	00002097          	auipc	ra,0x2
    394c:	f24080e7          	jalr	-220(ra) # 586c <exit>
    printf("%s: rm . worked!\n", s);
    3950:	85a6                	mv	a1,s1
    3952:	00004517          	auipc	a0,0x4
    3956:	fa650513          	addi	a0,a0,-90 # 78f8 <malloc+0x1c46>
    395a:	00002097          	auipc	ra,0x2
    395e:	29a080e7          	jalr	666(ra) # 5bf4 <printf>
    exit(1);
    3962:	4505                	li	a0,1
    3964:	00002097          	auipc	ra,0x2
    3968:	f08080e7          	jalr	-248(ra) # 586c <exit>
    printf("%s: rm .. worked!\n", s);
    396c:	85a6                	mv	a1,s1
    396e:	00004517          	auipc	a0,0x4
    3972:	fa250513          	addi	a0,a0,-94 # 7910 <malloc+0x1c5e>
    3976:	00002097          	auipc	ra,0x2
    397a:	27e080e7          	jalr	638(ra) # 5bf4 <printf>
    exit(1);
    397e:	4505                	li	a0,1
    3980:	00002097          	auipc	ra,0x2
    3984:	eec080e7          	jalr	-276(ra) # 586c <exit>
    printf("%s: chdir / failed\n", s);
    3988:	85a6                	mv	a1,s1
    398a:	00004517          	auipc	a0,0x4
    398e:	93e50513          	addi	a0,a0,-1730 # 72c8 <malloc+0x1616>
    3992:	00002097          	auipc	ra,0x2
    3996:	262080e7          	jalr	610(ra) # 5bf4 <printf>
    exit(1);
    399a:	4505                	li	a0,1
    399c:	00002097          	auipc	ra,0x2
    39a0:	ed0080e7          	jalr	-304(ra) # 586c <exit>
    printf("%s: unlink dots/. worked!\n", s);
    39a4:	85a6                	mv	a1,s1
    39a6:	00004517          	auipc	a0,0x4
    39aa:	f8a50513          	addi	a0,a0,-118 # 7930 <malloc+0x1c7e>
    39ae:	00002097          	auipc	ra,0x2
    39b2:	246080e7          	jalr	582(ra) # 5bf4 <printf>
    exit(1);
    39b6:	4505                	li	a0,1
    39b8:	00002097          	auipc	ra,0x2
    39bc:	eb4080e7          	jalr	-332(ra) # 586c <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    39c0:	85a6                	mv	a1,s1
    39c2:	00004517          	auipc	a0,0x4
    39c6:	f9650513          	addi	a0,a0,-106 # 7958 <malloc+0x1ca6>
    39ca:	00002097          	auipc	ra,0x2
    39ce:	22a080e7          	jalr	554(ra) # 5bf4 <printf>
    exit(1);
    39d2:	4505                	li	a0,1
    39d4:	00002097          	auipc	ra,0x2
    39d8:	e98080e7          	jalr	-360(ra) # 586c <exit>
    printf("%s: unlink dots failed!\n", s);
    39dc:	85a6                	mv	a1,s1
    39de:	00004517          	auipc	a0,0x4
    39e2:	f9a50513          	addi	a0,a0,-102 # 7978 <malloc+0x1cc6>
    39e6:	00002097          	auipc	ra,0x2
    39ea:	20e080e7          	jalr	526(ra) # 5bf4 <printf>
    exit(1);
    39ee:	4505                	li	a0,1
    39f0:	00002097          	auipc	ra,0x2
    39f4:	e7c080e7          	jalr	-388(ra) # 586c <exit>

00000000000039f8 <dirfile>:
{
    39f8:	1101                	addi	sp,sp,-32
    39fa:	ec06                	sd	ra,24(sp)
    39fc:	e822                	sd	s0,16(sp)
    39fe:	e426                	sd	s1,8(sp)
    3a00:	e04a                	sd	s2,0(sp)
    3a02:	1000                	addi	s0,sp,32
    3a04:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3a06:	20000593          	li	a1,512
    3a0a:	00002517          	auipc	a0,0x2
    3a0e:	6c650513          	addi	a0,a0,1734 # 60d0 <malloc+0x41e>
    3a12:	00002097          	auipc	ra,0x2
    3a16:	e9a080e7          	jalr	-358(ra) # 58ac <open>
  if(fd < 0){
    3a1a:	0e054d63          	bltz	a0,3b14 <dirfile+0x11c>
  close(fd);
    3a1e:	00002097          	auipc	ra,0x2
    3a22:	e76080e7          	jalr	-394(ra) # 5894 <close>
  if(chdir("dirfile") == 0){
    3a26:	00002517          	auipc	a0,0x2
    3a2a:	6aa50513          	addi	a0,a0,1706 # 60d0 <malloc+0x41e>
    3a2e:	00002097          	auipc	ra,0x2
    3a32:	eae080e7          	jalr	-338(ra) # 58dc <chdir>
    3a36:	cd6d                	beqz	a0,3b30 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3a38:	4581                	li	a1,0
    3a3a:	00004517          	auipc	a0,0x4
    3a3e:	f9e50513          	addi	a0,a0,-98 # 79d8 <malloc+0x1d26>
    3a42:	00002097          	auipc	ra,0x2
    3a46:	e6a080e7          	jalr	-406(ra) # 58ac <open>
  if(fd >= 0){
    3a4a:	10055163          	bgez	a0,3b4c <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3a4e:	20000593          	li	a1,512
    3a52:	00004517          	auipc	a0,0x4
    3a56:	f8650513          	addi	a0,a0,-122 # 79d8 <malloc+0x1d26>
    3a5a:	00002097          	auipc	ra,0x2
    3a5e:	e52080e7          	jalr	-430(ra) # 58ac <open>
  if(fd >= 0){
    3a62:	10055363          	bgez	a0,3b68 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3a66:	00004517          	auipc	a0,0x4
    3a6a:	f7250513          	addi	a0,a0,-142 # 79d8 <malloc+0x1d26>
    3a6e:	00002097          	auipc	ra,0x2
    3a72:	e66080e7          	jalr	-410(ra) # 58d4 <mkdir>
    3a76:	10050763          	beqz	a0,3b84 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3a7a:	00004517          	auipc	a0,0x4
    3a7e:	f5e50513          	addi	a0,a0,-162 # 79d8 <malloc+0x1d26>
    3a82:	00002097          	auipc	ra,0x2
    3a86:	e3a080e7          	jalr	-454(ra) # 58bc <unlink>
    3a8a:	10050b63          	beqz	a0,3ba0 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3a8e:	00004597          	auipc	a1,0x4
    3a92:	f4a58593          	addi	a1,a1,-182 # 79d8 <malloc+0x1d26>
    3a96:	00003517          	auipc	a0,0x3
    3a9a:	82a50513          	addi	a0,a0,-2006 # 62c0 <malloc+0x60e>
    3a9e:	00002097          	auipc	ra,0x2
    3aa2:	e2e080e7          	jalr	-466(ra) # 58cc <link>
    3aa6:	10050b63          	beqz	a0,3bbc <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3aaa:	00002517          	auipc	a0,0x2
    3aae:	62650513          	addi	a0,a0,1574 # 60d0 <malloc+0x41e>
    3ab2:	00002097          	auipc	ra,0x2
    3ab6:	e0a080e7          	jalr	-502(ra) # 58bc <unlink>
    3aba:	10051f63          	bnez	a0,3bd8 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3abe:	4589                	li	a1,2
    3ac0:	00003517          	auipc	a0,0x3
    3ac4:	d0050513          	addi	a0,a0,-768 # 67c0 <malloc+0xb0e>
    3ac8:	00002097          	auipc	ra,0x2
    3acc:	de4080e7          	jalr	-540(ra) # 58ac <open>
  if(fd >= 0){
    3ad0:	12055263          	bgez	a0,3bf4 <dirfile+0x1fc>
  fd = open(".", 0);
    3ad4:	4581                	li	a1,0
    3ad6:	00003517          	auipc	a0,0x3
    3ada:	cea50513          	addi	a0,a0,-790 # 67c0 <malloc+0xb0e>
    3ade:	00002097          	auipc	ra,0x2
    3ae2:	dce080e7          	jalr	-562(ra) # 58ac <open>
    3ae6:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3ae8:	4605                	li	a2,1
    3aea:	00002597          	auipc	a1,0x2
    3aee:	6ae58593          	addi	a1,a1,1710 # 6198 <malloc+0x4e6>
    3af2:	00002097          	auipc	ra,0x2
    3af6:	d9a080e7          	jalr	-614(ra) # 588c <write>
    3afa:	10a04b63          	bgtz	a0,3c10 <dirfile+0x218>
  close(fd);
    3afe:	8526                	mv	a0,s1
    3b00:	00002097          	auipc	ra,0x2
    3b04:	d94080e7          	jalr	-620(ra) # 5894 <close>
}
    3b08:	60e2                	ld	ra,24(sp)
    3b0a:	6442                	ld	s0,16(sp)
    3b0c:	64a2                	ld	s1,8(sp)
    3b0e:	6902                	ld	s2,0(sp)
    3b10:	6105                	addi	sp,sp,32
    3b12:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3b14:	85ca                	mv	a1,s2
    3b16:	00004517          	auipc	a0,0x4
    3b1a:	e8250513          	addi	a0,a0,-382 # 7998 <malloc+0x1ce6>
    3b1e:	00002097          	auipc	ra,0x2
    3b22:	0d6080e7          	jalr	214(ra) # 5bf4 <printf>
    exit(1);
    3b26:	4505                	li	a0,1
    3b28:	00002097          	auipc	ra,0x2
    3b2c:	d44080e7          	jalr	-700(ra) # 586c <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3b30:	85ca                	mv	a1,s2
    3b32:	00004517          	auipc	a0,0x4
    3b36:	e8650513          	addi	a0,a0,-378 # 79b8 <malloc+0x1d06>
    3b3a:	00002097          	auipc	ra,0x2
    3b3e:	0ba080e7          	jalr	186(ra) # 5bf4 <printf>
    exit(1);
    3b42:	4505                	li	a0,1
    3b44:	00002097          	auipc	ra,0x2
    3b48:	d28080e7          	jalr	-728(ra) # 586c <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3b4c:	85ca                	mv	a1,s2
    3b4e:	00004517          	auipc	a0,0x4
    3b52:	e9a50513          	addi	a0,a0,-358 # 79e8 <malloc+0x1d36>
    3b56:	00002097          	auipc	ra,0x2
    3b5a:	09e080e7          	jalr	158(ra) # 5bf4 <printf>
    exit(1);
    3b5e:	4505                	li	a0,1
    3b60:	00002097          	auipc	ra,0x2
    3b64:	d0c080e7          	jalr	-756(ra) # 586c <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3b68:	85ca                	mv	a1,s2
    3b6a:	00004517          	auipc	a0,0x4
    3b6e:	e7e50513          	addi	a0,a0,-386 # 79e8 <malloc+0x1d36>
    3b72:	00002097          	auipc	ra,0x2
    3b76:	082080e7          	jalr	130(ra) # 5bf4 <printf>
    exit(1);
    3b7a:	4505                	li	a0,1
    3b7c:	00002097          	auipc	ra,0x2
    3b80:	cf0080e7          	jalr	-784(ra) # 586c <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3b84:	85ca                	mv	a1,s2
    3b86:	00004517          	auipc	a0,0x4
    3b8a:	e8a50513          	addi	a0,a0,-374 # 7a10 <malloc+0x1d5e>
    3b8e:	00002097          	auipc	ra,0x2
    3b92:	066080e7          	jalr	102(ra) # 5bf4 <printf>
    exit(1);
    3b96:	4505                	li	a0,1
    3b98:	00002097          	auipc	ra,0x2
    3b9c:	cd4080e7          	jalr	-812(ra) # 586c <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3ba0:	85ca                	mv	a1,s2
    3ba2:	00004517          	auipc	a0,0x4
    3ba6:	e9650513          	addi	a0,a0,-362 # 7a38 <malloc+0x1d86>
    3baa:	00002097          	auipc	ra,0x2
    3bae:	04a080e7          	jalr	74(ra) # 5bf4 <printf>
    exit(1);
    3bb2:	4505                	li	a0,1
    3bb4:	00002097          	auipc	ra,0x2
    3bb8:	cb8080e7          	jalr	-840(ra) # 586c <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3bbc:	85ca                	mv	a1,s2
    3bbe:	00004517          	auipc	a0,0x4
    3bc2:	ea250513          	addi	a0,a0,-350 # 7a60 <malloc+0x1dae>
    3bc6:	00002097          	auipc	ra,0x2
    3bca:	02e080e7          	jalr	46(ra) # 5bf4 <printf>
    exit(1);
    3bce:	4505                	li	a0,1
    3bd0:	00002097          	auipc	ra,0x2
    3bd4:	c9c080e7          	jalr	-868(ra) # 586c <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3bd8:	85ca                	mv	a1,s2
    3bda:	00004517          	auipc	a0,0x4
    3bde:	eae50513          	addi	a0,a0,-338 # 7a88 <malloc+0x1dd6>
    3be2:	00002097          	auipc	ra,0x2
    3be6:	012080e7          	jalr	18(ra) # 5bf4 <printf>
    exit(1);
    3bea:	4505                	li	a0,1
    3bec:	00002097          	auipc	ra,0x2
    3bf0:	c80080e7          	jalr	-896(ra) # 586c <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3bf4:	85ca                	mv	a1,s2
    3bf6:	00004517          	auipc	a0,0x4
    3bfa:	eb250513          	addi	a0,a0,-334 # 7aa8 <malloc+0x1df6>
    3bfe:	00002097          	auipc	ra,0x2
    3c02:	ff6080e7          	jalr	-10(ra) # 5bf4 <printf>
    exit(1);
    3c06:	4505                	li	a0,1
    3c08:	00002097          	auipc	ra,0x2
    3c0c:	c64080e7          	jalr	-924(ra) # 586c <exit>
    printf("%s: write . succeeded!\n", s);
    3c10:	85ca                	mv	a1,s2
    3c12:	00004517          	auipc	a0,0x4
    3c16:	ebe50513          	addi	a0,a0,-322 # 7ad0 <malloc+0x1e1e>
    3c1a:	00002097          	auipc	ra,0x2
    3c1e:	fda080e7          	jalr	-38(ra) # 5bf4 <printf>
    exit(1);
    3c22:	4505                	li	a0,1
    3c24:	00002097          	auipc	ra,0x2
    3c28:	c48080e7          	jalr	-952(ra) # 586c <exit>

0000000000003c2c <iref>:
{
    3c2c:	7139                	addi	sp,sp,-64
    3c2e:	fc06                	sd	ra,56(sp)
    3c30:	f822                	sd	s0,48(sp)
    3c32:	f426                	sd	s1,40(sp)
    3c34:	f04a                	sd	s2,32(sp)
    3c36:	ec4e                	sd	s3,24(sp)
    3c38:	e852                	sd	s4,16(sp)
    3c3a:	e456                	sd	s5,8(sp)
    3c3c:	e05a                	sd	s6,0(sp)
    3c3e:	0080                	addi	s0,sp,64
    3c40:	8b2a                	mv	s6,a0
    3c42:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3c46:	00004a17          	auipc	s4,0x4
    3c4a:	ea2a0a13          	addi	s4,s4,-350 # 7ae8 <malloc+0x1e36>
    mkdir("");
    3c4e:	00004497          	auipc	s1,0x4
    3c52:	9aa48493          	addi	s1,s1,-1622 # 75f8 <malloc+0x1946>
    link("README", "");
    3c56:	00002a97          	auipc	s5,0x2
    3c5a:	66aa8a93          	addi	s5,s5,1642 # 62c0 <malloc+0x60e>
    fd = open("xx", O_CREATE);
    3c5e:	00004997          	auipc	s3,0x4
    3c62:	d8298993          	addi	s3,s3,-638 # 79e0 <malloc+0x1d2e>
    3c66:	a891                	j	3cba <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3c68:	85da                	mv	a1,s6
    3c6a:	00004517          	auipc	a0,0x4
    3c6e:	e8650513          	addi	a0,a0,-378 # 7af0 <malloc+0x1e3e>
    3c72:	00002097          	auipc	ra,0x2
    3c76:	f82080e7          	jalr	-126(ra) # 5bf4 <printf>
      exit(1);
    3c7a:	4505                	li	a0,1
    3c7c:	00002097          	auipc	ra,0x2
    3c80:	bf0080e7          	jalr	-1040(ra) # 586c <exit>
      printf("%s: chdir irefd failed\n", s);
    3c84:	85da                	mv	a1,s6
    3c86:	00004517          	auipc	a0,0x4
    3c8a:	e8250513          	addi	a0,a0,-382 # 7b08 <malloc+0x1e56>
    3c8e:	00002097          	auipc	ra,0x2
    3c92:	f66080e7          	jalr	-154(ra) # 5bf4 <printf>
      exit(1);
    3c96:	4505                	li	a0,1
    3c98:	00002097          	auipc	ra,0x2
    3c9c:	bd4080e7          	jalr	-1068(ra) # 586c <exit>
      close(fd);
    3ca0:	00002097          	auipc	ra,0x2
    3ca4:	bf4080e7          	jalr	-1036(ra) # 5894 <close>
    3ca8:	a889                	j	3cfa <iref+0xce>
    unlink("xx");
    3caa:	854e                	mv	a0,s3
    3cac:	00002097          	auipc	ra,0x2
    3cb0:	c10080e7          	jalr	-1008(ra) # 58bc <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3cb4:	397d                	addiw	s2,s2,-1
    3cb6:	06090063          	beqz	s2,3d16 <iref+0xea>
    if(mkdir("irefd") != 0){
    3cba:	8552                	mv	a0,s4
    3cbc:	00002097          	auipc	ra,0x2
    3cc0:	c18080e7          	jalr	-1000(ra) # 58d4 <mkdir>
    3cc4:	f155                	bnez	a0,3c68 <iref+0x3c>
    if(chdir("irefd") != 0){
    3cc6:	8552                	mv	a0,s4
    3cc8:	00002097          	auipc	ra,0x2
    3ccc:	c14080e7          	jalr	-1004(ra) # 58dc <chdir>
    3cd0:	f955                	bnez	a0,3c84 <iref+0x58>
    mkdir("");
    3cd2:	8526                	mv	a0,s1
    3cd4:	00002097          	auipc	ra,0x2
    3cd8:	c00080e7          	jalr	-1024(ra) # 58d4 <mkdir>
    link("README", "");
    3cdc:	85a6                	mv	a1,s1
    3cde:	8556                	mv	a0,s5
    3ce0:	00002097          	auipc	ra,0x2
    3ce4:	bec080e7          	jalr	-1044(ra) # 58cc <link>
    fd = open("", O_CREATE);
    3ce8:	20000593          	li	a1,512
    3cec:	8526                	mv	a0,s1
    3cee:	00002097          	auipc	ra,0x2
    3cf2:	bbe080e7          	jalr	-1090(ra) # 58ac <open>
    if(fd >= 0)
    3cf6:	fa0555e3          	bgez	a0,3ca0 <iref+0x74>
    fd = open("xx", O_CREATE);
    3cfa:	20000593          	li	a1,512
    3cfe:	854e                	mv	a0,s3
    3d00:	00002097          	auipc	ra,0x2
    3d04:	bac080e7          	jalr	-1108(ra) # 58ac <open>
    if(fd >= 0)
    3d08:	fa0541e3          	bltz	a0,3caa <iref+0x7e>
      close(fd);
    3d0c:	00002097          	auipc	ra,0x2
    3d10:	b88080e7          	jalr	-1144(ra) # 5894 <close>
    3d14:	bf59                	j	3caa <iref+0x7e>
    3d16:	03300493          	li	s1,51
    chdir("..");
    3d1a:	00003997          	auipc	s3,0x3
    3d1e:	5fe98993          	addi	s3,s3,1534 # 7318 <malloc+0x1666>
    unlink("irefd");
    3d22:	00004917          	auipc	s2,0x4
    3d26:	dc690913          	addi	s2,s2,-570 # 7ae8 <malloc+0x1e36>
    chdir("..");
    3d2a:	854e                	mv	a0,s3
    3d2c:	00002097          	auipc	ra,0x2
    3d30:	bb0080e7          	jalr	-1104(ra) # 58dc <chdir>
    unlink("irefd");
    3d34:	854a                	mv	a0,s2
    3d36:	00002097          	auipc	ra,0x2
    3d3a:	b86080e7          	jalr	-1146(ra) # 58bc <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3d3e:	34fd                	addiw	s1,s1,-1
    3d40:	f4ed                	bnez	s1,3d2a <iref+0xfe>
  chdir("/");
    3d42:	00003517          	auipc	a0,0x3
    3d46:	57e50513          	addi	a0,a0,1406 # 72c0 <malloc+0x160e>
    3d4a:	00002097          	auipc	ra,0x2
    3d4e:	b92080e7          	jalr	-1134(ra) # 58dc <chdir>
}
    3d52:	70e2                	ld	ra,56(sp)
    3d54:	7442                	ld	s0,48(sp)
    3d56:	74a2                	ld	s1,40(sp)
    3d58:	7902                	ld	s2,32(sp)
    3d5a:	69e2                	ld	s3,24(sp)
    3d5c:	6a42                	ld	s4,16(sp)
    3d5e:	6aa2                	ld	s5,8(sp)
    3d60:	6b02                	ld	s6,0(sp)
    3d62:	6121                	addi	sp,sp,64
    3d64:	8082                	ret

0000000000003d66 <openiputtest>:
{
    3d66:	7179                	addi	sp,sp,-48
    3d68:	f406                	sd	ra,40(sp)
    3d6a:	f022                	sd	s0,32(sp)
    3d6c:	ec26                	sd	s1,24(sp)
    3d6e:	1800                	addi	s0,sp,48
    3d70:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3d72:	00004517          	auipc	a0,0x4
    3d76:	dae50513          	addi	a0,a0,-594 # 7b20 <malloc+0x1e6e>
    3d7a:	00002097          	auipc	ra,0x2
    3d7e:	b5a080e7          	jalr	-1190(ra) # 58d4 <mkdir>
    3d82:	04054263          	bltz	a0,3dc6 <openiputtest+0x60>
  pid = fork();
    3d86:	00002097          	auipc	ra,0x2
    3d8a:	ade080e7          	jalr	-1314(ra) # 5864 <fork>
  if(pid < 0){
    3d8e:	04054a63          	bltz	a0,3de2 <openiputtest+0x7c>
  if(pid == 0){
    3d92:	e93d                	bnez	a0,3e08 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3d94:	4589                	li	a1,2
    3d96:	00004517          	auipc	a0,0x4
    3d9a:	d8a50513          	addi	a0,a0,-630 # 7b20 <malloc+0x1e6e>
    3d9e:	00002097          	auipc	ra,0x2
    3da2:	b0e080e7          	jalr	-1266(ra) # 58ac <open>
    if(fd >= 0){
    3da6:	04054c63          	bltz	a0,3dfe <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3daa:	85a6                	mv	a1,s1
    3dac:	00004517          	auipc	a0,0x4
    3db0:	d9450513          	addi	a0,a0,-620 # 7b40 <malloc+0x1e8e>
    3db4:	00002097          	auipc	ra,0x2
    3db8:	e40080e7          	jalr	-448(ra) # 5bf4 <printf>
      exit(1);
    3dbc:	4505                	li	a0,1
    3dbe:	00002097          	auipc	ra,0x2
    3dc2:	aae080e7          	jalr	-1362(ra) # 586c <exit>
    printf("%s: mkdir oidir failed\n", s);
    3dc6:	85a6                	mv	a1,s1
    3dc8:	00004517          	auipc	a0,0x4
    3dcc:	d6050513          	addi	a0,a0,-672 # 7b28 <malloc+0x1e76>
    3dd0:	00002097          	auipc	ra,0x2
    3dd4:	e24080e7          	jalr	-476(ra) # 5bf4 <printf>
    exit(1);
    3dd8:	4505                	li	a0,1
    3dda:	00002097          	auipc	ra,0x2
    3dde:	a92080e7          	jalr	-1390(ra) # 586c <exit>
    printf("%s: fork failed\n", s);
    3de2:	85a6                	mv	a1,s1
    3de4:	00003517          	auipc	a0,0x3
    3de8:	b1450513          	addi	a0,a0,-1260 # 68f8 <malloc+0xc46>
    3dec:	00002097          	auipc	ra,0x2
    3df0:	e08080e7          	jalr	-504(ra) # 5bf4 <printf>
    exit(1);
    3df4:	4505                	li	a0,1
    3df6:	00002097          	auipc	ra,0x2
    3dfa:	a76080e7          	jalr	-1418(ra) # 586c <exit>
    exit(0);
    3dfe:	4501                	li	a0,0
    3e00:	00002097          	auipc	ra,0x2
    3e04:	a6c080e7          	jalr	-1428(ra) # 586c <exit>
  sleep(1);
    3e08:	4505                	li	a0,1
    3e0a:	00002097          	auipc	ra,0x2
    3e0e:	af2080e7          	jalr	-1294(ra) # 58fc <sleep>
  if(unlink("oidir") != 0){
    3e12:	00004517          	auipc	a0,0x4
    3e16:	d0e50513          	addi	a0,a0,-754 # 7b20 <malloc+0x1e6e>
    3e1a:	00002097          	auipc	ra,0x2
    3e1e:	aa2080e7          	jalr	-1374(ra) # 58bc <unlink>
    3e22:	cd19                	beqz	a0,3e40 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3e24:	85a6                	mv	a1,s1
    3e26:	00003517          	auipc	a0,0x3
    3e2a:	cc250513          	addi	a0,a0,-830 # 6ae8 <malloc+0xe36>
    3e2e:	00002097          	auipc	ra,0x2
    3e32:	dc6080e7          	jalr	-570(ra) # 5bf4 <printf>
    exit(1);
    3e36:	4505                	li	a0,1
    3e38:	00002097          	auipc	ra,0x2
    3e3c:	a34080e7          	jalr	-1484(ra) # 586c <exit>
  wait(&xstatus);
    3e40:	fdc40513          	addi	a0,s0,-36
    3e44:	00002097          	auipc	ra,0x2
    3e48:	a30080e7          	jalr	-1488(ra) # 5874 <wait>
  exit(xstatus);
    3e4c:	fdc42503          	lw	a0,-36(s0)
    3e50:	00002097          	auipc	ra,0x2
    3e54:	a1c080e7          	jalr	-1508(ra) # 586c <exit>

0000000000003e58 <forkforkfork>:
{
    3e58:	1101                	addi	sp,sp,-32
    3e5a:	ec06                	sd	ra,24(sp)
    3e5c:	e822                	sd	s0,16(sp)
    3e5e:	e426                	sd	s1,8(sp)
    3e60:	1000                	addi	s0,sp,32
    3e62:	84aa                	mv	s1,a0
  unlink("stopforking");
    3e64:	00004517          	auipc	a0,0x4
    3e68:	d0450513          	addi	a0,a0,-764 # 7b68 <malloc+0x1eb6>
    3e6c:	00002097          	auipc	ra,0x2
    3e70:	a50080e7          	jalr	-1456(ra) # 58bc <unlink>
  int pid = fork();
    3e74:	00002097          	auipc	ra,0x2
    3e78:	9f0080e7          	jalr	-1552(ra) # 5864 <fork>
  if(pid < 0){
    3e7c:	04054563          	bltz	a0,3ec6 <forkforkfork+0x6e>
  if(pid == 0){
    3e80:	c12d                	beqz	a0,3ee2 <forkforkfork+0x8a>
  sleep(20); // two seconds
    3e82:	4551                	li	a0,20
    3e84:	00002097          	auipc	ra,0x2
    3e88:	a78080e7          	jalr	-1416(ra) # 58fc <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3e8c:	20200593          	li	a1,514
    3e90:	00004517          	auipc	a0,0x4
    3e94:	cd850513          	addi	a0,a0,-808 # 7b68 <malloc+0x1eb6>
    3e98:	00002097          	auipc	ra,0x2
    3e9c:	a14080e7          	jalr	-1516(ra) # 58ac <open>
    3ea0:	00002097          	auipc	ra,0x2
    3ea4:	9f4080e7          	jalr	-1548(ra) # 5894 <close>
  wait(0);
    3ea8:	4501                	li	a0,0
    3eaa:	00002097          	auipc	ra,0x2
    3eae:	9ca080e7          	jalr	-1590(ra) # 5874 <wait>
  sleep(10); // one second
    3eb2:	4529                	li	a0,10
    3eb4:	00002097          	auipc	ra,0x2
    3eb8:	a48080e7          	jalr	-1464(ra) # 58fc <sleep>
}
    3ebc:	60e2                	ld	ra,24(sp)
    3ebe:	6442                	ld	s0,16(sp)
    3ec0:	64a2                	ld	s1,8(sp)
    3ec2:	6105                	addi	sp,sp,32
    3ec4:	8082                	ret
    printf("%s: fork failed", s);
    3ec6:	85a6                	mv	a1,s1
    3ec8:	00003517          	auipc	a0,0x3
    3ecc:	bf050513          	addi	a0,a0,-1040 # 6ab8 <malloc+0xe06>
    3ed0:	00002097          	auipc	ra,0x2
    3ed4:	d24080e7          	jalr	-732(ra) # 5bf4 <printf>
    exit(1);
    3ed8:	4505                	li	a0,1
    3eda:	00002097          	auipc	ra,0x2
    3ede:	992080e7          	jalr	-1646(ra) # 586c <exit>
      int fd = open("stopforking", 0);
    3ee2:	00004497          	auipc	s1,0x4
    3ee6:	c8648493          	addi	s1,s1,-890 # 7b68 <malloc+0x1eb6>
    3eea:	4581                	li	a1,0
    3eec:	8526                	mv	a0,s1
    3eee:	00002097          	auipc	ra,0x2
    3ef2:	9be080e7          	jalr	-1602(ra) # 58ac <open>
      if(fd >= 0){
    3ef6:	02055463          	bgez	a0,3f1e <forkforkfork+0xc6>
      if(fork() < 0){
    3efa:	00002097          	auipc	ra,0x2
    3efe:	96a080e7          	jalr	-1686(ra) # 5864 <fork>
    3f02:	fe0554e3          	bgez	a0,3eea <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3f06:	20200593          	li	a1,514
    3f0a:	8526                	mv	a0,s1
    3f0c:	00002097          	auipc	ra,0x2
    3f10:	9a0080e7          	jalr	-1632(ra) # 58ac <open>
    3f14:	00002097          	auipc	ra,0x2
    3f18:	980080e7          	jalr	-1664(ra) # 5894 <close>
    3f1c:	b7f9                	j	3eea <forkforkfork+0x92>
        exit(0);
    3f1e:	4501                	li	a0,0
    3f20:	00002097          	auipc	ra,0x2
    3f24:	94c080e7          	jalr	-1716(ra) # 586c <exit>

0000000000003f28 <killstatus>:
{
    3f28:	7139                	addi	sp,sp,-64
    3f2a:	fc06                	sd	ra,56(sp)
    3f2c:	f822                	sd	s0,48(sp)
    3f2e:	f426                	sd	s1,40(sp)
    3f30:	f04a                	sd	s2,32(sp)
    3f32:	ec4e                	sd	s3,24(sp)
    3f34:	e852                	sd	s4,16(sp)
    3f36:	0080                	addi	s0,sp,64
    3f38:	8a2a                	mv	s4,a0
    3f3a:	06400913          	li	s2,100
    if(xst != -1) {
    3f3e:	59fd                	li	s3,-1
    int pid1 = fork();
    3f40:	00002097          	auipc	ra,0x2
    3f44:	924080e7          	jalr	-1756(ra) # 5864 <fork>
    3f48:	84aa                	mv	s1,a0
    if(pid1 < 0){
    3f4a:	02054f63          	bltz	a0,3f88 <killstatus+0x60>
    if(pid1 == 0){
    3f4e:	c939                	beqz	a0,3fa4 <killstatus+0x7c>
    sleep(1);
    3f50:	4505                	li	a0,1
    3f52:	00002097          	auipc	ra,0x2
    3f56:	9aa080e7          	jalr	-1622(ra) # 58fc <sleep>
    kill(pid1);
    3f5a:	8526                	mv	a0,s1
    3f5c:	00002097          	auipc	ra,0x2
    3f60:	940080e7          	jalr	-1728(ra) # 589c <kill>
    wait(&xst);
    3f64:	fcc40513          	addi	a0,s0,-52
    3f68:	00002097          	auipc	ra,0x2
    3f6c:	90c080e7          	jalr	-1780(ra) # 5874 <wait>
    if(xst != -1) {
    3f70:	fcc42783          	lw	a5,-52(s0)
    3f74:	03379d63          	bne	a5,s3,3fae <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    3f78:	397d                	addiw	s2,s2,-1
    3f7a:	fc0913e3          	bnez	s2,3f40 <killstatus+0x18>
  exit(0);
    3f7e:	4501                	li	a0,0
    3f80:	00002097          	auipc	ra,0x2
    3f84:	8ec080e7          	jalr	-1812(ra) # 586c <exit>
      printf("%s: fork failed\n", s);
    3f88:	85d2                	mv	a1,s4
    3f8a:	00003517          	auipc	a0,0x3
    3f8e:	96e50513          	addi	a0,a0,-1682 # 68f8 <malloc+0xc46>
    3f92:	00002097          	auipc	ra,0x2
    3f96:	c62080e7          	jalr	-926(ra) # 5bf4 <printf>
      exit(1);
    3f9a:	4505                	li	a0,1
    3f9c:	00002097          	auipc	ra,0x2
    3fa0:	8d0080e7          	jalr	-1840(ra) # 586c <exit>
        getpid();
    3fa4:	00002097          	auipc	ra,0x2
    3fa8:	948080e7          	jalr	-1720(ra) # 58ec <getpid>
      while(1) {
    3fac:	bfe5                	j	3fa4 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    3fae:	85d2                	mv	a1,s4
    3fb0:	00004517          	auipc	a0,0x4
    3fb4:	bc850513          	addi	a0,a0,-1080 # 7b78 <malloc+0x1ec6>
    3fb8:	00002097          	auipc	ra,0x2
    3fbc:	c3c080e7          	jalr	-964(ra) # 5bf4 <printf>
       exit(1);
    3fc0:	4505                	li	a0,1
    3fc2:	00002097          	auipc	ra,0x2
    3fc6:	8aa080e7          	jalr	-1878(ra) # 586c <exit>

0000000000003fca <preempt>:
{
    3fca:	7139                	addi	sp,sp,-64
    3fcc:	fc06                	sd	ra,56(sp)
    3fce:	f822                	sd	s0,48(sp)
    3fd0:	f426                	sd	s1,40(sp)
    3fd2:	f04a                	sd	s2,32(sp)
    3fd4:	ec4e                	sd	s3,24(sp)
    3fd6:	e852                	sd	s4,16(sp)
    3fd8:	0080                	addi	s0,sp,64
    3fda:	84aa                	mv	s1,a0
  pid1 = fork();
    3fdc:	00002097          	auipc	ra,0x2
    3fe0:	888080e7          	jalr	-1912(ra) # 5864 <fork>
  if(pid1 < 0) {
    3fe4:	00054563          	bltz	a0,3fee <preempt+0x24>
    3fe8:	8a2a                	mv	s4,a0
  if(pid1 == 0)
    3fea:	e105                	bnez	a0,400a <preempt+0x40>
    for(;;)
    3fec:	a001                	j	3fec <preempt+0x22>
    printf("%s: fork failed", s);
    3fee:	85a6                	mv	a1,s1
    3ff0:	00003517          	auipc	a0,0x3
    3ff4:	ac850513          	addi	a0,a0,-1336 # 6ab8 <malloc+0xe06>
    3ff8:	00002097          	auipc	ra,0x2
    3ffc:	bfc080e7          	jalr	-1028(ra) # 5bf4 <printf>
    exit(1);
    4000:	4505                	li	a0,1
    4002:	00002097          	auipc	ra,0x2
    4006:	86a080e7          	jalr	-1942(ra) # 586c <exit>
  pid2 = fork();
    400a:	00002097          	auipc	ra,0x2
    400e:	85a080e7          	jalr	-1958(ra) # 5864 <fork>
    4012:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    4014:	00054463          	bltz	a0,401c <preempt+0x52>
  if(pid2 == 0)
    4018:	e105                	bnez	a0,4038 <preempt+0x6e>
    for(;;)
    401a:	a001                	j	401a <preempt+0x50>
    printf("%s: fork failed\n", s);
    401c:	85a6                	mv	a1,s1
    401e:	00003517          	auipc	a0,0x3
    4022:	8da50513          	addi	a0,a0,-1830 # 68f8 <malloc+0xc46>
    4026:	00002097          	auipc	ra,0x2
    402a:	bce080e7          	jalr	-1074(ra) # 5bf4 <printf>
    exit(1);
    402e:	4505                	li	a0,1
    4030:	00002097          	auipc	ra,0x2
    4034:	83c080e7          	jalr	-1988(ra) # 586c <exit>
  pipe(pfds);
    4038:	fc840513          	addi	a0,s0,-56
    403c:	00002097          	auipc	ra,0x2
    4040:	840080e7          	jalr	-1984(ra) # 587c <pipe>
  pid3 = fork();
    4044:	00002097          	auipc	ra,0x2
    4048:	820080e7          	jalr	-2016(ra) # 5864 <fork>
    404c:	892a                	mv	s2,a0
  if(pid3 < 0) {
    404e:	02054e63          	bltz	a0,408a <preempt+0xc0>
  if(pid3 == 0){
    4052:	e525                	bnez	a0,40ba <preempt+0xf0>
    close(pfds[0]);
    4054:	fc842503          	lw	a0,-56(s0)
    4058:	00002097          	auipc	ra,0x2
    405c:	83c080e7          	jalr	-1988(ra) # 5894 <close>
    if(write(pfds[1], "x", 1) != 1)
    4060:	4605                	li	a2,1
    4062:	00002597          	auipc	a1,0x2
    4066:	13658593          	addi	a1,a1,310 # 6198 <malloc+0x4e6>
    406a:	fcc42503          	lw	a0,-52(s0)
    406e:	00002097          	auipc	ra,0x2
    4072:	81e080e7          	jalr	-2018(ra) # 588c <write>
    4076:	4785                	li	a5,1
    4078:	02f51763          	bne	a0,a5,40a6 <preempt+0xdc>
    close(pfds[1]);
    407c:	fcc42503          	lw	a0,-52(s0)
    4080:	00002097          	auipc	ra,0x2
    4084:	814080e7          	jalr	-2028(ra) # 5894 <close>
    for(;;)
    4088:	a001                	j	4088 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    408a:	85a6                	mv	a1,s1
    408c:	00003517          	auipc	a0,0x3
    4090:	86c50513          	addi	a0,a0,-1940 # 68f8 <malloc+0xc46>
    4094:	00002097          	auipc	ra,0x2
    4098:	b60080e7          	jalr	-1184(ra) # 5bf4 <printf>
     exit(1);
    409c:	4505                	li	a0,1
    409e:	00001097          	auipc	ra,0x1
    40a2:	7ce080e7          	jalr	1998(ra) # 586c <exit>
      printf("%s: preempt write error", s);
    40a6:	85a6                	mv	a1,s1
    40a8:	00004517          	auipc	a0,0x4
    40ac:	af050513          	addi	a0,a0,-1296 # 7b98 <malloc+0x1ee6>
    40b0:	00002097          	auipc	ra,0x2
    40b4:	b44080e7          	jalr	-1212(ra) # 5bf4 <printf>
    40b8:	b7d1                	j	407c <preempt+0xb2>
  close(pfds[1]);
    40ba:	fcc42503          	lw	a0,-52(s0)
    40be:	00001097          	auipc	ra,0x1
    40c2:	7d6080e7          	jalr	2006(ra) # 5894 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    40c6:	660d                	lui	a2,0x3
    40c8:	00008597          	auipc	a1,0x8
    40cc:	ce058593          	addi	a1,a1,-800 # bda8 <buf>
    40d0:	fc842503          	lw	a0,-56(s0)
    40d4:	00001097          	auipc	ra,0x1
    40d8:	7b0080e7          	jalr	1968(ra) # 5884 <read>
    40dc:	4785                	li	a5,1
    40de:	02f50363          	beq	a0,a5,4104 <preempt+0x13a>
    printf("%s: preempt read error", s);
    40e2:	85a6                	mv	a1,s1
    40e4:	00004517          	auipc	a0,0x4
    40e8:	acc50513          	addi	a0,a0,-1332 # 7bb0 <malloc+0x1efe>
    40ec:	00002097          	auipc	ra,0x2
    40f0:	b08080e7          	jalr	-1272(ra) # 5bf4 <printf>
}
    40f4:	70e2                	ld	ra,56(sp)
    40f6:	7442                	ld	s0,48(sp)
    40f8:	74a2                	ld	s1,40(sp)
    40fa:	7902                	ld	s2,32(sp)
    40fc:	69e2                	ld	s3,24(sp)
    40fe:	6a42                	ld	s4,16(sp)
    4100:	6121                	addi	sp,sp,64
    4102:	8082                	ret
  close(pfds[0]);
    4104:	fc842503          	lw	a0,-56(s0)
    4108:	00001097          	auipc	ra,0x1
    410c:	78c080e7          	jalr	1932(ra) # 5894 <close>
  printf("kill... ");
    4110:	00004517          	auipc	a0,0x4
    4114:	ab850513          	addi	a0,a0,-1352 # 7bc8 <malloc+0x1f16>
    4118:	00002097          	auipc	ra,0x2
    411c:	adc080e7          	jalr	-1316(ra) # 5bf4 <printf>
  kill(pid1);
    4120:	8552                	mv	a0,s4
    4122:	00001097          	auipc	ra,0x1
    4126:	77a080e7          	jalr	1914(ra) # 589c <kill>
  kill(pid2);
    412a:	854e                	mv	a0,s3
    412c:	00001097          	auipc	ra,0x1
    4130:	770080e7          	jalr	1904(ra) # 589c <kill>
  kill(pid3);
    4134:	854a                	mv	a0,s2
    4136:	00001097          	auipc	ra,0x1
    413a:	766080e7          	jalr	1894(ra) # 589c <kill>
  printf("wait... ");
    413e:	00004517          	auipc	a0,0x4
    4142:	a9a50513          	addi	a0,a0,-1382 # 7bd8 <malloc+0x1f26>
    4146:	00002097          	auipc	ra,0x2
    414a:	aae080e7          	jalr	-1362(ra) # 5bf4 <printf>
  wait(0);
    414e:	4501                	li	a0,0
    4150:	00001097          	auipc	ra,0x1
    4154:	724080e7          	jalr	1828(ra) # 5874 <wait>
  wait(0);
    4158:	4501                	li	a0,0
    415a:	00001097          	auipc	ra,0x1
    415e:	71a080e7          	jalr	1818(ra) # 5874 <wait>
  wait(0);
    4162:	4501                	li	a0,0
    4164:	00001097          	auipc	ra,0x1
    4168:	710080e7          	jalr	1808(ra) # 5874 <wait>
    416c:	b761                	j	40f4 <preempt+0x12a>

000000000000416e <reparent>:
{
    416e:	7179                	addi	sp,sp,-48
    4170:	f406                	sd	ra,40(sp)
    4172:	f022                	sd	s0,32(sp)
    4174:	ec26                	sd	s1,24(sp)
    4176:	e84a                	sd	s2,16(sp)
    4178:	e44e                	sd	s3,8(sp)
    417a:	e052                	sd	s4,0(sp)
    417c:	1800                	addi	s0,sp,48
    417e:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4180:	00001097          	auipc	ra,0x1
    4184:	76c080e7          	jalr	1900(ra) # 58ec <getpid>
    4188:	8a2a                	mv	s4,a0
    418a:	0c800913          	li	s2,200
    int pid = fork();
    418e:	00001097          	auipc	ra,0x1
    4192:	6d6080e7          	jalr	1750(ra) # 5864 <fork>
    4196:	84aa                	mv	s1,a0
    if(pid < 0){
    4198:	02054263          	bltz	a0,41bc <reparent+0x4e>
    if(pid){
    419c:	cd21                	beqz	a0,41f4 <reparent+0x86>
      if(wait(0) != pid){
    419e:	4501                	li	a0,0
    41a0:	00001097          	auipc	ra,0x1
    41a4:	6d4080e7          	jalr	1748(ra) # 5874 <wait>
    41a8:	02951863          	bne	a0,s1,41d8 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    41ac:	397d                	addiw	s2,s2,-1
    41ae:	fe0910e3          	bnez	s2,418e <reparent+0x20>
  exit(0);
    41b2:	4501                	li	a0,0
    41b4:	00001097          	auipc	ra,0x1
    41b8:	6b8080e7          	jalr	1720(ra) # 586c <exit>
      printf("%s: fork failed\n", s);
    41bc:	85ce                	mv	a1,s3
    41be:	00002517          	auipc	a0,0x2
    41c2:	73a50513          	addi	a0,a0,1850 # 68f8 <malloc+0xc46>
    41c6:	00002097          	auipc	ra,0x2
    41ca:	a2e080e7          	jalr	-1490(ra) # 5bf4 <printf>
      exit(1);
    41ce:	4505                	li	a0,1
    41d0:	00001097          	auipc	ra,0x1
    41d4:	69c080e7          	jalr	1692(ra) # 586c <exit>
        printf("%s: wait wrong pid\n", s);
    41d8:	85ce                	mv	a1,s3
    41da:	00003517          	auipc	a0,0x3
    41de:	8a650513          	addi	a0,a0,-1882 # 6a80 <malloc+0xdce>
    41e2:	00002097          	auipc	ra,0x2
    41e6:	a12080e7          	jalr	-1518(ra) # 5bf4 <printf>
        exit(1);
    41ea:	4505                	li	a0,1
    41ec:	00001097          	auipc	ra,0x1
    41f0:	680080e7          	jalr	1664(ra) # 586c <exit>
      int pid2 = fork();
    41f4:	00001097          	auipc	ra,0x1
    41f8:	670080e7          	jalr	1648(ra) # 5864 <fork>
      if(pid2 < 0){
    41fc:	00054763          	bltz	a0,420a <reparent+0x9c>
      exit(0);
    4200:	4501                	li	a0,0
    4202:	00001097          	auipc	ra,0x1
    4206:	66a080e7          	jalr	1642(ra) # 586c <exit>
        kill(master_pid);
    420a:	8552                	mv	a0,s4
    420c:	00001097          	auipc	ra,0x1
    4210:	690080e7          	jalr	1680(ra) # 589c <kill>
        exit(1);
    4214:	4505                	li	a0,1
    4216:	00001097          	auipc	ra,0x1
    421a:	656080e7          	jalr	1622(ra) # 586c <exit>

000000000000421e <sbrkfail>:
{
    421e:	7119                	addi	sp,sp,-128
    4220:	fc86                	sd	ra,120(sp)
    4222:	f8a2                	sd	s0,112(sp)
    4224:	f4a6                	sd	s1,104(sp)
    4226:	f0ca                	sd	s2,96(sp)
    4228:	ecce                	sd	s3,88(sp)
    422a:	e8d2                	sd	s4,80(sp)
    422c:	e4d6                	sd	s5,72(sp)
    422e:	0100                	addi	s0,sp,128
    4230:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    4232:	fb040513          	addi	a0,s0,-80
    4236:	00001097          	auipc	ra,0x1
    423a:	646080e7          	jalr	1606(ra) # 587c <pipe>
    423e:	e901                	bnez	a0,424e <sbrkfail+0x30>
    4240:	f8040493          	addi	s1,s0,-128
    4244:	fa840a13          	addi	s4,s0,-88
    4248:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    424a:	5afd                	li	s5,-1
    424c:	a08d                	j	42ae <sbrkfail+0x90>
    printf("%s: pipe() failed\n", s);
    424e:	85ca                	mv	a1,s2
    4250:	00002517          	auipc	a0,0x2
    4254:	7b050513          	addi	a0,a0,1968 # 6a00 <malloc+0xd4e>
    4258:	00002097          	auipc	ra,0x2
    425c:	99c080e7          	jalr	-1636(ra) # 5bf4 <printf>
    exit(1);
    4260:	4505                	li	a0,1
    4262:	00001097          	auipc	ra,0x1
    4266:	60a080e7          	jalr	1546(ra) # 586c <exit>
      sbrk(BIG - (uint64)sbrk(0));
    426a:	4501                	li	a0,0
    426c:	00001097          	auipc	ra,0x1
    4270:	688080e7          	jalr	1672(ra) # 58f4 <sbrk>
    4274:	064007b7          	lui	a5,0x6400
    4278:	40a7853b          	subw	a0,a5,a0
    427c:	00001097          	auipc	ra,0x1
    4280:	678080e7          	jalr	1656(ra) # 58f4 <sbrk>
      write(fds[1], "x", 1);
    4284:	4605                	li	a2,1
    4286:	00002597          	auipc	a1,0x2
    428a:	f1258593          	addi	a1,a1,-238 # 6198 <malloc+0x4e6>
    428e:	fb442503          	lw	a0,-76(s0)
    4292:	00001097          	auipc	ra,0x1
    4296:	5fa080e7          	jalr	1530(ra) # 588c <write>
      for(;;) sleep(1000);
    429a:	3e800513          	li	a0,1000
    429e:	00001097          	auipc	ra,0x1
    42a2:	65e080e7          	jalr	1630(ra) # 58fc <sleep>
    42a6:	bfd5                	j	429a <sbrkfail+0x7c>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    42a8:	0991                	addi	s3,s3,4
    42aa:	03498563          	beq	s3,s4,42d4 <sbrkfail+0xb6>
    if((pids[i] = fork()) == 0){
    42ae:	00001097          	auipc	ra,0x1
    42b2:	5b6080e7          	jalr	1462(ra) # 5864 <fork>
    42b6:	00a9a023          	sw	a0,0(s3)
    42ba:	d945                	beqz	a0,426a <sbrkfail+0x4c>
    if(pids[i] != -1)
    42bc:	ff5506e3          	beq	a0,s5,42a8 <sbrkfail+0x8a>
      read(fds[0], &scratch, 1);
    42c0:	4605                	li	a2,1
    42c2:	faf40593          	addi	a1,s0,-81
    42c6:	fb042503          	lw	a0,-80(s0)
    42ca:	00001097          	auipc	ra,0x1
    42ce:	5ba080e7          	jalr	1466(ra) # 5884 <read>
    42d2:	bfd9                	j	42a8 <sbrkfail+0x8a>
  c = sbrk(PGSIZE);
    42d4:	6505                	lui	a0,0x1
    42d6:	00001097          	auipc	ra,0x1
    42da:	61e080e7          	jalr	1566(ra) # 58f4 <sbrk>
    42de:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    42e0:	5afd                	li	s5,-1
    42e2:	a021                	j	42ea <sbrkfail+0xcc>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    42e4:	0491                	addi	s1,s1,4
    42e6:	01448f63          	beq	s1,s4,4304 <sbrkfail+0xe6>
    if(pids[i] == -1)
    42ea:	4088                	lw	a0,0(s1)
    42ec:	ff550ce3          	beq	a0,s5,42e4 <sbrkfail+0xc6>
    kill(pids[i]);
    42f0:	00001097          	auipc	ra,0x1
    42f4:	5ac080e7          	jalr	1452(ra) # 589c <kill>
    wait(0);
    42f8:	4501                	li	a0,0
    42fa:	00001097          	auipc	ra,0x1
    42fe:	57a080e7          	jalr	1402(ra) # 5874 <wait>
    4302:	b7cd                	j	42e4 <sbrkfail+0xc6>
  if(c == (char*)0xffffffffffffffffL){
    4304:	57fd                	li	a5,-1
    4306:	04f98163          	beq	s3,a5,4348 <sbrkfail+0x12a>
  pid = fork();
    430a:	00001097          	auipc	ra,0x1
    430e:	55a080e7          	jalr	1370(ra) # 5864 <fork>
    4312:	84aa                	mv	s1,a0
  if(pid < 0){
    4314:	04054863          	bltz	a0,4364 <sbrkfail+0x146>
  if(pid == 0){
    4318:	c525                	beqz	a0,4380 <sbrkfail+0x162>
  wait(&xstatus);
    431a:	fbc40513          	addi	a0,s0,-68
    431e:	00001097          	auipc	ra,0x1
    4322:	556080e7          	jalr	1366(ra) # 5874 <wait>
  if(xstatus != -1 && xstatus != 2)
    4326:	fbc42783          	lw	a5,-68(s0)
    432a:	577d                	li	a4,-1
    432c:	00e78563          	beq	a5,a4,4336 <sbrkfail+0x118>
    4330:	4709                	li	a4,2
    4332:	08e79d63          	bne	a5,a4,43cc <sbrkfail+0x1ae>
}
    4336:	70e6                	ld	ra,120(sp)
    4338:	7446                	ld	s0,112(sp)
    433a:	74a6                	ld	s1,104(sp)
    433c:	7906                	ld	s2,96(sp)
    433e:	69e6                	ld	s3,88(sp)
    4340:	6a46                	ld	s4,80(sp)
    4342:	6aa6                	ld	s5,72(sp)
    4344:	6109                	addi	sp,sp,128
    4346:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4348:	85ca                	mv	a1,s2
    434a:	00004517          	auipc	a0,0x4
    434e:	89e50513          	addi	a0,a0,-1890 # 7be8 <malloc+0x1f36>
    4352:	00002097          	auipc	ra,0x2
    4356:	8a2080e7          	jalr	-1886(ra) # 5bf4 <printf>
    exit(1);
    435a:	4505                	li	a0,1
    435c:	00001097          	auipc	ra,0x1
    4360:	510080e7          	jalr	1296(ra) # 586c <exit>
    printf("%s: fork failed\n", s);
    4364:	85ca                	mv	a1,s2
    4366:	00002517          	auipc	a0,0x2
    436a:	59250513          	addi	a0,a0,1426 # 68f8 <malloc+0xc46>
    436e:	00002097          	auipc	ra,0x2
    4372:	886080e7          	jalr	-1914(ra) # 5bf4 <printf>
    exit(1);
    4376:	4505                	li	a0,1
    4378:	00001097          	auipc	ra,0x1
    437c:	4f4080e7          	jalr	1268(ra) # 586c <exit>
    a = sbrk(0);
    4380:	4501                	li	a0,0
    4382:	00001097          	auipc	ra,0x1
    4386:	572080e7          	jalr	1394(ra) # 58f4 <sbrk>
    438a:	89aa                	mv	s3,a0
    sbrk(10*BIG);
    438c:	3e800537          	lui	a0,0x3e800
    4390:	00001097          	auipc	ra,0x1
    4394:	564080e7          	jalr	1380(ra) # 58f4 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4398:	874e                	mv	a4,s3
    439a:	3e8007b7          	lui	a5,0x3e800
    439e:	97ce                	add	a5,a5,s3
    43a0:	6685                	lui	a3,0x1
      n += *(a+i);
    43a2:	00074603          	lbu	a2,0(a4)
    43a6:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    43a8:	9736                	add	a4,a4,a3
    43aa:	fef71ce3          	bne	a4,a5,43a2 <sbrkfail+0x184>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    43ae:	8626                	mv	a2,s1
    43b0:	85ca                	mv	a1,s2
    43b2:	00004517          	auipc	a0,0x4
    43b6:	85650513          	addi	a0,a0,-1962 # 7c08 <malloc+0x1f56>
    43ba:	00002097          	auipc	ra,0x2
    43be:	83a080e7          	jalr	-1990(ra) # 5bf4 <printf>
    exit(1);
    43c2:	4505                	li	a0,1
    43c4:	00001097          	auipc	ra,0x1
    43c8:	4a8080e7          	jalr	1192(ra) # 586c <exit>
    exit(1);
    43cc:	4505                	li	a0,1
    43ce:	00001097          	auipc	ra,0x1
    43d2:	49e080e7          	jalr	1182(ra) # 586c <exit>

00000000000043d6 <mem>:
{
    43d6:	7139                	addi	sp,sp,-64
    43d8:	fc06                	sd	ra,56(sp)
    43da:	f822                	sd	s0,48(sp)
    43dc:	f426                	sd	s1,40(sp)
    43de:	f04a                	sd	s2,32(sp)
    43e0:	ec4e                	sd	s3,24(sp)
    43e2:	0080                	addi	s0,sp,64
    43e4:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    43e6:	00001097          	auipc	ra,0x1
    43ea:	47e080e7          	jalr	1150(ra) # 5864 <fork>
    m1 = 0;
    43ee:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    43f0:	6909                	lui	s2,0x2
    43f2:	71190913          	addi	s2,s2,1809 # 2711 <sbrkmuch+0x87>
  if((pid = fork()) == 0){
    43f6:	ed39                	bnez	a0,4454 <mem+0x7e>
    while((m2 = malloc(10001)) != 0){
    43f8:	854a                	mv	a0,s2
    43fa:	00002097          	auipc	ra,0x2
    43fe:	8b8080e7          	jalr	-1864(ra) # 5cb2 <malloc>
    4402:	c501                	beqz	a0,440a <mem+0x34>
      *(char**)m2 = m1;
    4404:	e104                	sd	s1,0(a0)
      m1 = m2;
    4406:	84aa                	mv	s1,a0
    4408:	bfc5                	j	43f8 <mem+0x22>
    while(m1){
    440a:	c881                	beqz	s1,441a <mem+0x44>
      m2 = *(char**)m1;
    440c:	8526                	mv	a0,s1
    440e:	6084                	ld	s1,0(s1)
      free(m1);
    4410:	00002097          	auipc	ra,0x2
    4414:	81a080e7          	jalr	-2022(ra) # 5c2a <free>
    while(m1){
    4418:	f8f5                	bnez	s1,440c <mem+0x36>
    m1 = malloc(1024*20);
    441a:	6515                	lui	a0,0x5
    441c:	00002097          	auipc	ra,0x2
    4420:	896080e7          	jalr	-1898(ra) # 5cb2 <malloc>
    if(m1 == 0){
    4424:	c911                	beqz	a0,4438 <mem+0x62>
    free(m1);
    4426:	00002097          	auipc	ra,0x2
    442a:	804080e7          	jalr	-2044(ra) # 5c2a <free>
    exit(0);
    442e:	4501                	li	a0,0
    4430:	00001097          	auipc	ra,0x1
    4434:	43c080e7          	jalr	1084(ra) # 586c <exit>
      printf("couldn't allocate mem?!!\n", s);
    4438:	85ce                	mv	a1,s3
    443a:	00003517          	auipc	a0,0x3
    443e:	7fe50513          	addi	a0,a0,2046 # 7c38 <malloc+0x1f86>
    4442:	00001097          	auipc	ra,0x1
    4446:	7b2080e7          	jalr	1970(ra) # 5bf4 <printf>
      exit(1);
    444a:	4505                	li	a0,1
    444c:	00001097          	auipc	ra,0x1
    4450:	420080e7          	jalr	1056(ra) # 586c <exit>
    wait(&xstatus);
    4454:	fcc40513          	addi	a0,s0,-52
    4458:	00001097          	auipc	ra,0x1
    445c:	41c080e7          	jalr	1052(ra) # 5874 <wait>
    if(xstatus == -1){
    4460:	fcc42503          	lw	a0,-52(s0)
    4464:	57fd                	li	a5,-1
    4466:	00f50663          	beq	a0,a5,4472 <mem+0x9c>
    exit(xstatus);
    446a:	00001097          	auipc	ra,0x1
    446e:	402080e7          	jalr	1026(ra) # 586c <exit>
      exit(0);
    4472:	4501                	li	a0,0
    4474:	00001097          	auipc	ra,0x1
    4478:	3f8080e7          	jalr	1016(ra) # 586c <exit>

000000000000447c <sharedfd>:
{
    447c:	7159                	addi	sp,sp,-112
    447e:	f486                	sd	ra,104(sp)
    4480:	f0a2                	sd	s0,96(sp)
    4482:	eca6                	sd	s1,88(sp)
    4484:	e8ca                	sd	s2,80(sp)
    4486:	e4ce                	sd	s3,72(sp)
    4488:	e0d2                	sd	s4,64(sp)
    448a:	fc56                	sd	s5,56(sp)
    448c:	f85a                	sd	s6,48(sp)
    448e:	f45e                	sd	s7,40(sp)
    4490:	1880                	addi	s0,sp,112
    4492:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4494:	00002517          	auipc	a0,0x2
    4498:	aac50513          	addi	a0,a0,-1364 # 5f40 <malloc+0x28e>
    449c:	00001097          	auipc	ra,0x1
    44a0:	420080e7          	jalr	1056(ra) # 58bc <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    44a4:	20200593          	li	a1,514
    44a8:	00002517          	auipc	a0,0x2
    44ac:	a9850513          	addi	a0,a0,-1384 # 5f40 <malloc+0x28e>
    44b0:	00001097          	auipc	ra,0x1
    44b4:	3fc080e7          	jalr	1020(ra) # 58ac <open>
  if(fd < 0){
    44b8:	04054a63          	bltz	a0,450c <sharedfd+0x90>
    44bc:	892a                	mv	s2,a0
  pid = fork();
    44be:	00001097          	auipc	ra,0x1
    44c2:	3a6080e7          	jalr	934(ra) # 5864 <fork>
    44c6:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    44c8:	06300593          	li	a1,99
    44cc:	c119                	beqz	a0,44d2 <sharedfd+0x56>
    44ce:	07000593          	li	a1,112
    44d2:	4629                	li	a2,10
    44d4:	fa040513          	addi	a0,s0,-96
    44d8:	00001097          	auipc	ra,0x1
    44dc:	17a080e7          	jalr	378(ra) # 5652 <memset>
    44e0:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    44e4:	4629                	li	a2,10
    44e6:	fa040593          	addi	a1,s0,-96
    44ea:	854a                	mv	a0,s2
    44ec:	00001097          	auipc	ra,0x1
    44f0:	3a0080e7          	jalr	928(ra) # 588c <write>
    44f4:	47a9                	li	a5,10
    44f6:	02f51963          	bne	a0,a5,4528 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    44fa:	34fd                	addiw	s1,s1,-1
    44fc:	f4e5                	bnez	s1,44e4 <sharedfd+0x68>
  if(pid == 0) {
    44fe:	04099363          	bnez	s3,4544 <sharedfd+0xc8>
    exit(0);
    4502:	4501                	li	a0,0
    4504:	00001097          	auipc	ra,0x1
    4508:	368080e7          	jalr	872(ra) # 586c <exit>
    printf("%s: cannot open sharedfd for writing", s);
    450c:	85d2                	mv	a1,s4
    450e:	00003517          	auipc	a0,0x3
    4512:	74a50513          	addi	a0,a0,1866 # 7c58 <malloc+0x1fa6>
    4516:	00001097          	auipc	ra,0x1
    451a:	6de080e7          	jalr	1758(ra) # 5bf4 <printf>
    exit(1);
    451e:	4505                	li	a0,1
    4520:	00001097          	auipc	ra,0x1
    4524:	34c080e7          	jalr	844(ra) # 586c <exit>
      printf("%s: write sharedfd failed\n", s);
    4528:	85d2                	mv	a1,s4
    452a:	00003517          	auipc	a0,0x3
    452e:	75650513          	addi	a0,a0,1878 # 7c80 <malloc+0x1fce>
    4532:	00001097          	auipc	ra,0x1
    4536:	6c2080e7          	jalr	1730(ra) # 5bf4 <printf>
      exit(1);
    453a:	4505                	li	a0,1
    453c:	00001097          	auipc	ra,0x1
    4540:	330080e7          	jalr	816(ra) # 586c <exit>
    wait(&xstatus);
    4544:	f9c40513          	addi	a0,s0,-100
    4548:	00001097          	auipc	ra,0x1
    454c:	32c080e7          	jalr	812(ra) # 5874 <wait>
    if(xstatus != 0)
    4550:	f9c42983          	lw	s3,-100(s0)
    4554:	00098763          	beqz	s3,4562 <sharedfd+0xe6>
      exit(xstatus);
    4558:	854e                	mv	a0,s3
    455a:	00001097          	auipc	ra,0x1
    455e:	312080e7          	jalr	786(ra) # 586c <exit>
  close(fd);
    4562:	854a                	mv	a0,s2
    4564:	00001097          	auipc	ra,0x1
    4568:	330080e7          	jalr	816(ra) # 5894 <close>
  fd = open("sharedfd", 0);
    456c:	4581                	li	a1,0
    456e:	00002517          	auipc	a0,0x2
    4572:	9d250513          	addi	a0,a0,-1582 # 5f40 <malloc+0x28e>
    4576:	00001097          	auipc	ra,0x1
    457a:	336080e7          	jalr	822(ra) # 58ac <open>
    457e:	8baa                	mv	s7,a0
  nc = np = 0;
    4580:	8ace                	mv	s5,s3
  if(fd < 0){
    4582:	02054563          	bltz	a0,45ac <sharedfd+0x130>
    4586:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    458a:	06300493          	li	s1,99
      if(buf[i] == 'p')
    458e:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4592:	4629                	li	a2,10
    4594:	fa040593          	addi	a1,s0,-96
    4598:	855e                	mv	a0,s7
    459a:	00001097          	auipc	ra,0x1
    459e:	2ea080e7          	jalr	746(ra) # 5884 <read>
    45a2:	02a05f63          	blez	a0,45e0 <sharedfd+0x164>
    45a6:	fa040793          	addi	a5,s0,-96
    45aa:	a01d                	j	45d0 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    45ac:	85d2                	mv	a1,s4
    45ae:	00003517          	auipc	a0,0x3
    45b2:	6f250513          	addi	a0,a0,1778 # 7ca0 <malloc+0x1fee>
    45b6:	00001097          	auipc	ra,0x1
    45ba:	63e080e7          	jalr	1598(ra) # 5bf4 <printf>
    exit(1);
    45be:	4505                	li	a0,1
    45c0:	00001097          	auipc	ra,0x1
    45c4:	2ac080e7          	jalr	684(ra) # 586c <exit>
        nc++;
    45c8:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    45ca:	0785                	addi	a5,a5,1
    45cc:	fd2783e3          	beq	a5,s2,4592 <sharedfd+0x116>
      if(buf[i] == 'c')
    45d0:	0007c703          	lbu	a4,0(a5) # 3e800000 <__BSS_END__+0x3e7f1248>
    45d4:	fe970ae3          	beq	a4,s1,45c8 <sharedfd+0x14c>
      if(buf[i] == 'p')
    45d8:	ff6719e3          	bne	a4,s6,45ca <sharedfd+0x14e>
        np++;
    45dc:	2a85                	addiw	s5,s5,1
    45de:	b7f5                	j	45ca <sharedfd+0x14e>
  close(fd);
    45e0:	855e                	mv	a0,s7
    45e2:	00001097          	auipc	ra,0x1
    45e6:	2b2080e7          	jalr	690(ra) # 5894 <close>
  unlink("sharedfd");
    45ea:	00002517          	auipc	a0,0x2
    45ee:	95650513          	addi	a0,a0,-1706 # 5f40 <malloc+0x28e>
    45f2:	00001097          	auipc	ra,0x1
    45f6:	2ca080e7          	jalr	714(ra) # 58bc <unlink>
  if(nc == N*SZ && np == N*SZ){
    45fa:	6789                	lui	a5,0x2
    45fc:	71078793          	addi	a5,a5,1808 # 2710 <sbrkmuch+0x86>
    4600:	00f99763          	bne	s3,a5,460e <sharedfd+0x192>
    4604:	6789                	lui	a5,0x2
    4606:	71078793          	addi	a5,a5,1808 # 2710 <sbrkmuch+0x86>
    460a:	02fa8063          	beq	s5,a5,462a <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    460e:	85d2                	mv	a1,s4
    4610:	00003517          	auipc	a0,0x3
    4614:	6b850513          	addi	a0,a0,1720 # 7cc8 <malloc+0x2016>
    4618:	00001097          	auipc	ra,0x1
    461c:	5dc080e7          	jalr	1500(ra) # 5bf4 <printf>
    exit(1);
    4620:	4505                	li	a0,1
    4622:	00001097          	auipc	ra,0x1
    4626:	24a080e7          	jalr	586(ra) # 586c <exit>
    exit(0);
    462a:	4501                	li	a0,0
    462c:	00001097          	auipc	ra,0x1
    4630:	240080e7          	jalr	576(ra) # 586c <exit>

0000000000004634 <fourfiles>:
{
    4634:	7171                	addi	sp,sp,-176
    4636:	f506                	sd	ra,168(sp)
    4638:	f122                	sd	s0,160(sp)
    463a:	ed26                	sd	s1,152(sp)
    463c:	e94a                	sd	s2,144(sp)
    463e:	e54e                	sd	s3,136(sp)
    4640:	e152                	sd	s4,128(sp)
    4642:	fcd6                	sd	s5,120(sp)
    4644:	f8da                	sd	s6,112(sp)
    4646:	f4de                	sd	s7,104(sp)
    4648:	f0e2                	sd	s8,96(sp)
    464a:	ece6                	sd	s9,88(sp)
    464c:	e8ea                	sd	s10,80(sp)
    464e:	e4ee                	sd	s11,72(sp)
    4650:	1900                	addi	s0,sp,176
    4652:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4654:	00001797          	auipc	a5,0x1
    4658:	74478793          	addi	a5,a5,1860 # 5d98 <malloc+0xe6>
    465c:	f6f43823          	sd	a5,-144(s0)
    4660:	00001797          	auipc	a5,0x1
    4664:	74078793          	addi	a5,a5,1856 # 5da0 <malloc+0xee>
    4668:	f6f43c23          	sd	a5,-136(s0)
    466c:	00001797          	auipc	a5,0x1
    4670:	73c78793          	addi	a5,a5,1852 # 5da8 <malloc+0xf6>
    4674:	f8f43023          	sd	a5,-128(s0)
    4678:	00001797          	auipc	a5,0x1
    467c:	73878793          	addi	a5,a5,1848 # 5db0 <malloc+0xfe>
    4680:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4684:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4688:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    468a:	4481                	li	s1,0
    468c:	4a11                	li	s4,4
    fname = names[pi];
    468e:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4692:	854e                	mv	a0,s3
    4694:	00001097          	auipc	ra,0x1
    4698:	228080e7          	jalr	552(ra) # 58bc <unlink>
    pid = fork();
    469c:	00001097          	auipc	ra,0x1
    46a0:	1c8080e7          	jalr	456(ra) # 5864 <fork>
    if(pid < 0){
    46a4:	04054563          	bltz	a0,46ee <fourfiles+0xba>
    if(pid == 0){
    46a8:	c12d                	beqz	a0,470a <fourfiles+0xd6>
  for(pi = 0; pi < NCHILD; pi++){
    46aa:	2485                	addiw	s1,s1,1
    46ac:	0921                	addi	s2,s2,8
    46ae:	ff4490e3          	bne	s1,s4,468e <fourfiles+0x5a>
    46b2:	4491                	li	s1,4
    wait(&xstatus);
    46b4:	f6c40513          	addi	a0,s0,-148
    46b8:	00001097          	auipc	ra,0x1
    46bc:	1bc080e7          	jalr	444(ra) # 5874 <wait>
    if(xstatus != 0)
    46c0:	f6c42503          	lw	a0,-148(s0)
    46c4:	ed69                	bnez	a0,479e <fourfiles+0x16a>
  for(pi = 0; pi < NCHILD; pi++){
    46c6:	34fd                	addiw	s1,s1,-1
    46c8:	f4f5                	bnez	s1,46b4 <fourfiles+0x80>
    46ca:	03000b13          	li	s6,48
    total = 0;
    46ce:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    46d2:	00007a17          	auipc	s4,0x7
    46d6:	6d6a0a13          	addi	s4,s4,1750 # bda8 <buf>
    46da:	00007a97          	auipc	s5,0x7
    46de:	6cfa8a93          	addi	s5,s5,1743 # bda9 <buf+0x1>
    if(total != N*SZ){
    46e2:	6d05                	lui	s10,0x1
    46e4:	770d0d13          	addi	s10,s10,1904 # 1770 <pipe1+0x196>
  for(i = 0; i < NCHILD; i++){
    46e8:	03400d93          	li	s11,52
    46ec:	a23d                	j	481a <fourfiles+0x1e6>
      printf("fork failed\n", s);
    46ee:	85e6                	mv	a1,s9
    46f0:	00002517          	auipc	a0,0x2
    46f4:	62850513          	addi	a0,a0,1576 # 6d18 <malloc+0x1066>
    46f8:	00001097          	auipc	ra,0x1
    46fc:	4fc080e7          	jalr	1276(ra) # 5bf4 <printf>
      exit(1);
    4700:	4505                	li	a0,1
    4702:	00001097          	auipc	ra,0x1
    4706:	16a080e7          	jalr	362(ra) # 586c <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    470a:	20200593          	li	a1,514
    470e:	854e                	mv	a0,s3
    4710:	00001097          	auipc	ra,0x1
    4714:	19c080e7          	jalr	412(ra) # 58ac <open>
    4718:	892a                	mv	s2,a0
      if(fd < 0){
    471a:	04054763          	bltz	a0,4768 <fourfiles+0x134>
      memset(buf, '0'+pi, SZ);
    471e:	1f400613          	li	a2,500
    4722:	0304859b          	addiw	a1,s1,48
    4726:	00007517          	auipc	a0,0x7
    472a:	68250513          	addi	a0,a0,1666 # bda8 <buf>
    472e:	00001097          	auipc	ra,0x1
    4732:	f24080e7          	jalr	-220(ra) # 5652 <memset>
    4736:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4738:	00007997          	auipc	s3,0x7
    473c:	67098993          	addi	s3,s3,1648 # bda8 <buf>
    4740:	1f400613          	li	a2,500
    4744:	85ce                	mv	a1,s3
    4746:	854a                	mv	a0,s2
    4748:	00001097          	auipc	ra,0x1
    474c:	144080e7          	jalr	324(ra) # 588c <write>
    4750:	85aa                	mv	a1,a0
    4752:	1f400793          	li	a5,500
    4756:	02f51763          	bne	a0,a5,4784 <fourfiles+0x150>
      for(i = 0; i < N; i++){
    475a:	34fd                	addiw	s1,s1,-1
    475c:	f0f5                	bnez	s1,4740 <fourfiles+0x10c>
      exit(0);
    475e:	4501                	li	a0,0
    4760:	00001097          	auipc	ra,0x1
    4764:	10c080e7          	jalr	268(ra) # 586c <exit>
        printf("create failed\n", s);
    4768:	85e6                	mv	a1,s9
    476a:	00003517          	auipc	a0,0x3
    476e:	57650513          	addi	a0,a0,1398 # 7ce0 <malloc+0x202e>
    4772:	00001097          	auipc	ra,0x1
    4776:	482080e7          	jalr	1154(ra) # 5bf4 <printf>
        exit(1);
    477a:	4505                	li	a0,1
    477c:	00001097          	auipc	ra,0x1
    4780:	0f0080e7          	jalr	240(ra) # 586c <exit>
          printf("write failed %d\n", n);
    4784:	00003517          	auipc	a0,0x3
    4788:	56c50513          	addi	a0,a0,1388 # 7cf0 <malloc+0x203e>
    478c:	00001097          	auipc	ra,0x1
    4790:	468080e7          	jalr	1128(ra) # 5bf4 <printf>
          exit(1);
    4794:	4505                	li	a0,1
    4796:	00001097          	auipc	ra,0x1
    479a:	0d6080e7          	jalr	214(ra) # 586c <exit>
      exit(xstatus);
    479e:	00001097          	auipc	ra,0x1
    47a2:	0ce080e7          	jalr	206(ra) # 586c <exit>
          printf("wrong char\n", s);
    47a6:	85e6                	mv	a1,s9
    47a8:	00003517          	auipc	a0,0x3
    47ac:	56050513          	addi	a0,a0,1376 # 7d08 <malloc+0x2056>
    47b0:	00001097          	auipc	ra,0x1
    47b4:	444080e7          	jalr	1092(ra) # 5bf4 <printf>
          exit(1);
    47b8:	4505                	li	a0,1
    47ba:	00001097          	auipc	ra,0x1
    47be:	0b2080e7          	jalr	178(ra) # 586c <exit>
      total += n;
    47c2:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    47c6:	660d                	lui	a2,0x3
    47c8:	85d2                	mv	a1,s4
    47ca:	854e                	mv	a0,s3
    47cc:	00001097          	auipc	ra,0x1
    47d0:	0b8080e7          	jalr	184(ra) # 5884 <read>
    47d4:	02a05363          	blez	a0,47fa <fourfiles+0x1c6>
    47d8:	00007797          	auipc	a5,0x7
    47dc:	5d078793          	addi	a5,a5,1488 # bda8 <buf>
    47e0:	fff5069b          	addiw	a3,a0,-1
    47e4:	1682                	slli	a3,a3,0x20
    47e6:	9281                	srli	a3,a3,0x20
    47e8:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    47ea:	0007c703          	lbu	a4,0(a5)
    47ee:	fa971ce3          	bne	a4,s1,47a6 <fourfiles+0x172>
      for(j = 0; j < n; j++){
    47f2:	0785                	addi	a5,a5,1
    47f4:	fed79be3          	bne	a5,a3,47ea <fourfiles+0x1b6>
    47f8:	b7e9                	j	47c2 <fourfiles+0x18e>
    close(fd);
    47fa:	854e                	mv	a0,s3
    47fc:	00001097          	auipc	ra,0x1
    4800:	098080e7          	jalr	152(ra) # 5894 <close>
    if(total != N*SZ){
    4804:	03a91963          	bne	s2,s10,4836 <fourfiles+0x202>
    unlink(fname);
    4808:	8562                	mv	a0,s8
    480a:	00001097          	auipc	ra,0x1
    480e:	0b2080e7          	jalr	178(ra) # 58bc <unlink>
  for(i = 0; i < NCHILD; i++){
    4812:	0ba1                	addi	s7,s7,8
    4814:	2b05                	addiw	s6,s6,1
    4816:	03bb0e63          	beq	s6,s11,4852 <fourfiles+0x21e>
    fname = names[i];
    481a:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    481e:	4581                	li	a1,0
    4820:	8562                	mv	a0,s8
    4822:	00001097          	auipc	ra,0x1
    4826:	08a080e7          	jalr	138(ra) # 58ac <open>
    482a:	89aa                	mv	s3,a0
    total = 0;
    482c:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    4830:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4834:	bf49                	j	47c6 <fourfiles+0x192>
      printf("wrong length %d\n", total);
    4836:	85ca                	mv	a1,s2
    4838:	00003517          	auipc	a0,0x3
    483c:	4e050513          	addi	a0,a0,1248 # 7d18 <malloc+0x2066>
    4840:	00001097          	auipc	ra,0x1
    4844:	3b4080e7          	jalr	948(ra) # 5bf4 <printf>
      exit(1);
    4848:	4505                	li	a0,1
    484a:	00001097          	auipc	ra,0x1
    484e:	022080e7          	jalr	34(ra) # 586c <exit>
}
    4852:	70aa                	ld	ra,168(sp)
    4854:	740a                	ld	s0,160(sp)
    4856:	64ea                	ld	s1,152(sp)
    4858:	694a                	ld	s2,144(sp)
    485a:	69aa                	ld	s3,136(sp)
    485c:	6a0a                	ld	s4,128(sp)
    485e:	7ae6                	ld	s5,120(sp)
    4860:	7b46                	ld	s6,112(sp)
    4862:	7ba6                	ld	s7,104(sp)
    4864:	7c06                	ld	s8,96(sp)
    4866:	6ce6                	ld	s9,88(sp)
    4868:	6d46                	ld	s10,80(sp)
    486a:	6da6                	ld	s11,72(sp)
    486c:	614d                	addi	sp,sp,176
    486e:	8082                	ret

0000000000004870 <concreate>:
{
    4870:	7135                	addi	sp,sp,-160
    4872:	ed06                	sd	ra,152(sp)
    4874:	e922                	sd	s0,144(sp)
    4876:	e526                	sd	s1,136(sp)
    4878:	e14a                	sd	s2,128(sp)
    487a:	fcce                	sd	s3,120(sp)
    487c:	f8d2                	sd	s4,112(sp)
    487e:	f4d6                	sd	s5,104(sp)
    4880:	f0da                	sd	s6,96(sp)
    4882:	ecde                	sd	s7,88(sp)
    4884:	1100                	addi	s0,sp,160
    4886:	89aa                	mv	s3,a0
  file[0] = 'C';
    4888:	04300793          	li	a5,67
    488c:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4890:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4894:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4896:	4b0d                	li	s6,3
    4898:	4a85                	li	s5,1
      link("C0", file);
    489a:	00003b97          	auipc	s7,0x3
    489e:	496b8b93          	addi	s7,s7,1174 # 7d30 <malloc+0x207e>
  for(i = 0; i < N; i++){
    48a2:	02800a13          	li	s4,40
    48a6:	acc1                	j	4b76 <concreate+0x306>
      link("C0", file);
    48a8:	fa840593          	addi	a1,s0,-88
    48ac:	855e                	mv	a0,s7
    48ae:	00001097          	auipc	ra,0x1
    48b2:	01e080e7          	jalr	30(ra) # 58cc <link>
    if(pid == 0) {
    48b6:	a45d                	j	4b5c <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    48b8:	4795                	li	a5,5
    48ba:	02f9693b          	remw	s2,s2,a5
    48be:	4785                	li	a5,1
    48c0:	02f90b63          	beq	s2,a5,48f6 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    48c4:	20200593          	li	a1,514
    48c8:	fa840513          	addi	a0,s0,-88
    48cc:	00001097          	auipc	ra,0x1
    48d0:	fe0080e7          	jalr	-32(ra) # 58ac <open>
      if(fd < 0){
    48d4:	26055b63          	bgez	a0,4b4a <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    48d8:	fa840593          	addi	a1,s0,-88
    48dc:	00003517          	auipc	a0,0x3
    48e0:	45c50513          	addi	a0,a0,1116 # 7d38 <malloc+0x2086>
    48e4:	00001097          	auipc	ra,0x1
    48e8:	310080e7          	jalr	784(ra) # 5bf4 <printf>
        exit(1);
    48ec:	4505                	li	a0,1
    48ee:	00001097          	auipc	ra,0x1
    48f2:	f7e080e7          	jalr	-130(ra) # 586c <exit>
      link("C0", file);
    48f6:	fa840593          	addi	a1,s0,-88
    48fa:	00003517          	auipc	a0,0x3
    48fe:	43650513          	addi	a0,a0,1078 # 7d30 <malloc+0x207e>
    4902:	00001097          	auipc	ra,0x1
    4906:	fca080e7          	jalr	-54(ra) # 58cc <link>
      exit(0);
    490a:	4501                	li	a0,0
    490c:	00001097          	auipc	ra,0x1
    4910:	f60080e7          	jalr	-160(ra) # 586c <exit>
        exit(1);
    4914:	4505                	li	a0,1
    4916:	00001097          	auipc	ra,0x1
    491a:	f56080e7          	jalr	-170(ra) # 586c <exit>
  memset(fa, 0, sizeof(fa));
    491e:	02800613          	li	a2,40
    4922:	4581                	li	a1,0
    4924:	f8040513          	addi	a0,s0,-128
    4928:	00001097          	auipc	ra,0x1
    492c:	d2a080e7          	jalr	-726(ra) # 5652 <memset>
  fd = open(".", 0);
    4930:	4581                	li	a1,0
    4932:	00002517          	auipc	a0,0x2
    4936:	e8e50513          	addi	a0,a0,-370 # 67c0 <malloc+0xb0e>
    493a:	00001097          	auipc	ra,0x1
    493e:	f72080e7          	jalr	-142(ra) # 58ac <open>
    4942:	892a                	mv	s2,a0
  n = 0;
    4944:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4946:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    494a:	02700b13          	li	s6,39
      fa[i] = 1;
    494e:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4950:	a03d                	j	497e <concreate+0x10e>
        printf("%s: concreate weird file %s\n", s, de.name);
    4952:	f7240613          	addi	a2,s0,-142
    4956:	85ce                	mv	a1,s3
    4958:	00003517          	auipc	a0,0x3
    495c:	40050513          	addi	a0,a0,1024 # 7d58 <malloc+0x20a6>
    4960:	00001097          	auipc	ra,0x1
    4964:	294080e7          	jalr	660(ra) # 5bf4 <printf>
        exit(1);
    4968:	4505                	li	a0,1
    496a:	00001097          	auipc	ra,0x1
    496e:	f02080e7          	jalr	-254(ra) # 586c <exit>
      fa[i] = 1;
    4972:	fb040793          	addi	a5,s0,-80
    4976:	973e                	add	a4,a4,a5
    4978:	fd770823          	sb	s7,-48(a4)
      n++;
    497c:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    497e:	4641                	li	a2,16
    4980:	f7040593          	addi	a1,s0,-144
    4984:	854a                	mv	a0,s2
    4986:	00001097          	auipc	ra,0x1
    498a:	efe080e7          	jalr	-258(ra) # 5884 <read>
    498e:	04a05a63          	blez	a0,49e2 <concreate+0x172>
    if(de.inum == 0)
    4992:	f7045783          	lhu	a5,-144(s0)
    4996:	d7e5                	beqz	a5,497e <concreate+0x10e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4998:	f7244783          	lbu	a5,-142(s0)
    499c:	ff4791e3          	bne	a5,s4,497e <concreate+0x10e>
    49a0:	f7444783          	lbu	a5,-140(s0)
    49a4:	ffe9                	bnez	a5,497e <concreate+0x10e>
      i = de.name[1] - '0';
    49a6:	f7344783          	lbu	a5,-141(s0)
    49aa:	fd07879b          	addiw	a5,a5,-48
    49ae:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    49b2:	faeb60e3          	bltu	s6,a4,4952 <concreate+0xe2>
      if(fa[i]){
    49b6:	fb040793          	addi	a5,s0,-80
    49ba:	97ba                	add	a5,a5,a4
    49bc:	fd07c783          	lbu	a5,-48(a5)
    49c0:	dbcd                	beqz	a5,4972 <concreate+0x102>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    49c2:	f7240613          	addi	a2,s0,-142
    49c6:	85ce                	mv	a1,s3
    49c8:	00003517          	auipc	a0,0x3
    49cc:	3b050513          	addi	a0,a0,944 # 7d78 <malloc+0x20c6>
    49d0:	00001097          	auipc	ra,0x1
    49d4:	224080e7          	jalr	548(ra) # 5bf4 <printf>
        exit(1);
    49d8:	4505                	li	a0,1
    49da:	00001097          	auipc	ra,0x1
    49de:	e92080e7          	jalr	-366(ra) # 586c <exit>
  close(fd);
    49e2:	854a                	mv	a0,s2
    49e4:	00001097          	auipc	ra,0x1
    49e8:	eb0080e7          	jalr	-336(ra) # 5894 <close>
  if(n != N){
    49ec:	02800793          	li	a5,40
    49f0:	00fa9763          	bne	s5,a5,49fe <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    49f4:	4a8d                	li	s5,3
    49f6:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    49f8:	02800a13          	li	s4,40
    49fc:	a8c9                	j	4ace <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    49fe:	85ce                	mv	a1,s3
    4a00:	00003517          	auipc	a0,0x3
    4a04:	3a050513          	addi	a0,a0,928 # 7da0 <malloc+0x20ee>
    4a08:	00001097          	auipc	ra,0x1
    4a0c:	1ec080e7          	jalr	492(ra) # 5bf4 <printf>
    exit(1);
    4a10:	4505                	li	a0,1
    4a12:	00001097          	auipc	ra,0x1
    4a16:	e5a080e7          	jalr	-422(ra) # 586c <exit>
      printf("%s: fork failed\n", s);
    4a1a:	85ce                	mv	a1,s3
    4a1c:	00002517          	auipc	a0,0x2
    4a20:	edc50513          	addi	a0,a0,-292 # 68f8 <malloc+0xc46>
    4a24:	00001097          	auipc	ra,0x1
    4a28:	1d0080e7          	jalr	464(ra) # 5bf4 <printf>
      exit(1);
    4a2c:	4505                	li	a0,1
    4a2e:	00001097          	auipc	ra,0x1
    4a32:	e3e080e7          	jalr	-450(ra) # 586c <exit>
      close(open(file, 0));
    4a36:	4581                	li	a1,0
    4a38:	fa840513          	addi	a0,s0,-88
    4a3c:	00001097          	auipc	ra,0x1
    4a40:	e70080e7          	jalr	-400(ra) # 58ac <open>
    4a44:	00001097          	auipc	ra,0x1
    4a48:	e50080e7          	jalr	-432(ra) # 5894 <close>
      close(open(file, 0));
    4a4c:	4581                	li	a1,0
    4a4e:	fa840513          	addi	a0,s0,-88
    4a52:	00001097          	auipc	ra,0x1
    4a56:	e5a080e7          	jalr	-422(ra) # 58ac <open>
    4a5a:	00001097          	auipc	ra,0x1
    4a5e:	e3a080e7          	jalr	-454(ra) # 5894 <close>
      close(open(file, 0));
    4a62:	4581                	li	a1,0
    4a64:	fa840513          	addi	a0,s0,-88
    4a68:	00001097          	auipc	ra,0x1
    4a6c:	e44080e7          	jalr	-444(ra) # 58ac <open>
    4a70:	00001097          	auipc	ra,0x1
    4a74:	e24080e7          	jalr	-476(ra) # 5894 <close>
      close(open(file, 0));
    4a78:	4581                	li	a1,0
    4a7a:	fa840513          	addi	a0,s0,-88
    4a7e:	00001097          	auipc	ra,0x1
    4a82:	e2e080e7          	jalr	-466(ra) # 58ac <open>
    4a86:	00001097          	auipc	ra,0x1
    4a8a:	e0e080e7          	jalr	-498(ra) # 5894 <close>
      close(open(file, 0));
    4a8e:	4581                	li	a1,0
    4a90:	fa840513          	addi	a0,s0,-88
    4a94:	00001097          	auipc	ra,0x1
    4a98:	e18080e7          	jalr	-488(ra) # 58ac <open>
    4a9c:	00001097          	auipc	ra,0x1
    4aa0:	df8080e7          	jalr	-520(ra) # 5894 <close>
      close(open(file, 0));
    4aa4:	4581                	li	a1,0
    4aa6:	fa840513          	addi	a0,s0,-88
    4aaa:	00001097          	auipc	ra,0x1
    4aae:	e02080e7          	jalr	-510(ra) # 58ac <open>
    4ab2:	00001097          	auipc	ra,0x1
    4ab6:	de2080e7          	jalr	-542(ra) # 5894 <close>
    if(pid == 0)
    4aba:	08090363          	beqz	s2,4b40 <concreate+0x2d0>
      wait(0);
    4abe:	4501                	li	a0,0
    4ac0:	00001097          	auipc	ra,0x1
    4ac4:	db4080e7          	jalr	-588(ra) # 5874 <wait>
  for(i = 0; i < N; i++){
    4ac8:	2485                	addiw	s1,s1,1
    4aca:	0f448563          	beq	s1,s4,4bb4 <concreate+0x344>
    file[1] = '0' + i;
    4ace:	0304879b          	addiw	a5,s1,48
    4ad2:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4ad6:	00001097          	auipc	ra,0x1
    4ada:	d8e080e7          	jalr	-626(ra) # 5864 <fork>
    4ade:	892a                	mv	s2,a0
    if(pid < 0){
    4ae0:	f2054de3          	bltz	a0,4a1a <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    4ae4:	0354e73b          	remw	a4,s1,s5
    4ae8:	00a767b3          	or	a5,a4,a0
    4aec:	2781                	sext.w	a5,a5
    4aee:	d7a1                	beqz	a5,4a36 <concreate+0x1c6>
    4af0:	01671363          	bne	a4,s6,4af6 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    4af4:	f129                	bnez	a0,4a36 <concreate+0x1c6>
      unlink(file);
    4af6:	fa840513          	addi	a0,s0,-88
    4afa:	00001097          	auipc	ra,0x1
    4afe:	dc2080e7          	jalr	-574(ra) # 58bc <unlink>
      unlink(file);
    4b02:	fa840513          	addi	a0,s0,-88
    4b06:	00001097          	auipc	ra,0x1
    4b0a:	db6080e7          	jalr	-586(ra) # 58bc <unlink>
      unlink(file);
    4b0e:	fa840513          	addi	a0,s0,-88
    4b12:	00001097          	auipc	ra,0x1
    4b16:	daa080e7          	jalr	-598(ra) # 58bc <unlink>
      unlink(file);
    4b1a:	fa840513          	addi	a0,s0,-88
    4b1e:	00001097          	auipc	ra,0x1
    4b22:	d9e080e7          	jalr	-610(ra) # 58bc <unlink>
      unlink(file);
    4b26:	fa840513          	addi	a0,s0,-88
    4b2a:	00001097          	auipc	ra,0x1
    4b2e:	d92080e7          	jalr	-622(ra) # 58bc <unlink>
      unlink(file);
    4b32:	fa840513          	addi	a0,s0,-88
    4b36:	00001097          	auipc	ra,0x1
    4b3a:	d86080e7          	jalr	-634(ra) # 58bc <unlink>
    4b3e:	bfb5                	j	4aba <concreate+0x24a>
      exit(0);
    4b40:	4501                	li	a0,0
    4b42:	00001097          	auipc	ra,0x1
    4b46:	d2a080e7          	jalr	-726(ra) # 586c <exit>
      close(fd);
    4b4a:	00001097          	auipc	ra,0x1
    4b4e:	d4a080e7          	jalr	-694(ra) # 5894 <close>
    if(pid == 0) {
    4b52:	bb65                	j	490a <concreate+0x9a>
      close(fd);
    4b54:	00001097          	auipc	ra,0x1
    4b58:	d40080e7          	jalr	-704(ra) # 5894 <close>
      wait(&xstatus);
    4b5c:	f6c40513          	addi	a0,s0,-148
    4b60:	00001097          	auipc	ra,0x1
    4b64:	d14080e7          	jalr	-748(ra) # 5874 <wait>
      if(xstatus != 0)
    4b68:	f6c42483          	lw	s1,-148(s0)
    4b6c:	da0494e3          	bnez	s1,4914 <concreate+0xa4>
  for(i = 0; i < N; i++){
    4b70:	2905                	addiw	s2,s2,1
    4b72:	db4906e3          	beq	s2,s4,491e <concreate+0xae>
    file[1] = '0' + i;
    4b76:	0309079b          	addiw	a5,s2,48
    4b7a:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4b7e:	fa840513          	addi	a0,s0,-88
    4b82:	00001097          	auipc	ra,0x1
    4b86:	d3a080e7          	jalr	-710(ra) # 58bc <unlink>
    pid = fork();
    4b8a:	00001097          	auipc	ra,0x1
    4b8e:	cda080e7          	jalr	-806(ra) # 5864 <fork>
    if(pid && (i % 3) == 1){
    4b92:	d20503e3          	beqz	a0,48b8 <concreate+0x48>
    4b96:	036967bb          	remw	a5,s2,s6
    4b9a:	d15787e3          	beq	a5,s5,48a8 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4b9e:	20200593          	li	a1,514
    4ba2:	fa840513          	addi	a0,s0,-88
    4ba6:	00001097          	auipc	ra,0x1
    4baa:	d06080e7          	jalr	-762(ra) # 58ac <open>
      if(fd < 0){
    4bae:	fa0553e3          	bgez	a0,4b54 <concreate+0x2e4>
    4bb2:	b31d                	j	48d8 <concreate+0x68>
}
    4bb4:	60ea                	ld	ra,152(sp)
    4bb6:	644a                	ld	s0,144(sp)
    4bb8:	64aa                	ld	s1,136(sp)
    4bba:	690a                	ld	s2,128(sp)
    4bbc:	79e6                	ld	s3,120(sp)
    4bbe:	7a46                	ld	s4,112(sp)
    4bc0:	7aa6                	ld	s5,104(sp)
    4bc2:	7b06                	ld	s6,96(sp)
    4bc4:	6be6                	ld	s7,88(sp)
    4bc6:	610d                	addi	sp,sp,160
    4bc8:	8082                	ret

0000000000004bca <bigfile>:
{
    4bca:	7139                	addi	sp,sp,-64
    4bcc:	fc06                	sd	ra,56(sp)
    4bce:	f822                	sd	s0,48(sp)
    4bd0:	f426                	sd	s1,40(sp)
    4bd2:	f04a                	sd	s2,32(sp)
    4bd4:	ec4e                	sd	s3,24(sp)
    4bd6:	e852                	sd	s4,16(sp)
    4bd8:	e456                	sd	s5,8(sp)
    4bda:	0080                	addi	s0,sp,64
    4bdc:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4bde:	00003517          	auipc	a0,0x3
    4be2:	1fa50513          	addi	a0,a0,506 # 7dd8 <malloc+0x2126>
    4be6:	00001097          	auipc	ra,0x1
    4bea:	cd6080e7          	jalr	-810(ra) # 58bc <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4bee:	20200593          	li	a1,514
    4bf2:	00003517          	auipc	a0,0x3
    4bf6:	1e650513          	addi	a0,a0,486 # 7dd8 <malloc+0x2126>
    4bfa:	00001097          	auipc	ra,0x1
    4bfe:	cb2080e7          	jalr	-846(ra) # 58ac <open>
    4c02:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4c04:	4481                	li	s1,0
    memset(buf, i, SZ);
    4c06:	00007917          	auipc	s2,0x7
    4c0a:	1a290913          	addi	s2,s2,418 # bda8 <buf>
  for(i = 0; i < N; i++){
    4c0e:	4a51                	li	s4,20
  if(fd < 0){
    4c10:	0a054063          	bltz	a0,4cb0 <bigfile+0xe6>
    memset(buf, i, SZ);
    4c14:	25800613          	li	a2,600
    4c18:	85a6                	mv	a1,s1
    4c1a:	854a                	mv	a0,s2
    4c1c:	00001097          	auipc	ra,0x1
    4c20:	a36080e7          	jalr	-1482(ra) # 5652 <memset>
    if(write(fd, buf, SZ) != SZ){
    4c24:	25800613          	li	a2,600
    4c28:	85ca                	mv	a1,s2
    4c2a:	854e                	mv	a0,s3
    4c2c:	00001097          	auipc	ra,0x1
    4c30:	c60080e7          	jalr	-928(ra) # 588c <write>
    4c34:	25800793          	li	a5,600
    4c38:	08f51a63          	bne	a0,a5,4ccc <bigfile+0x102>
  for(i = 0; i < N; i++){
    4c3c:	2485                	addiw	s1,s1,1
    4c3e:	fd449be3          	bne	s1,s4,4c14 <bigfile+0x4a>
  close(fd);
    4c42:	854e                	mv	a0,s3
    4c44:	00001097          	auipc	ra,0x1
    4c48:	c50080e7          	jalr	-944(ra) # 5894 <close>
  fd = open("bigfile.dat", 0);
    4c4c:	4581                	li	a1,0
    4c4e:	00003517          	auipc	a0,0x3
    4c52:	18a50513          	addi	a0,a0,394 # 7dd8 <malloc+0x2126>
    4c56:	00001097          	auipc	ra,0x1
    4c5a:	c56080e7          	jalr	-938(ra) # 58ac <open>
    4c5e:	8a2a                	mv	s4,a0
  total = 0;
    4c60:	4981                	li	s3,0
  for(i = 0; ; i++){
    4c62:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4c64:	00007917          	auipc	s2,0x7
    4c68:	14490913          	addi	s2,s2,324 # bda8 <buf>
  if(fd < 0){
    4c6c:	06054e63          	bltz	a0,4ce8 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4c70:	12c00613          	li	a2,300
    4c74:	85ca                	mv	a1,s2
    4c76:	8552                	mv	a0,s4
    4c78:	00001097          	auipc	ra,0x1
    4c7c:	c0c080e7          	jalr	-1012(ra) # 5884 <read>
    if(cc < 0){
    4c80:	08054263          	bltz	a0,4d04 <bigfile+0x13a>
    if(cc == 0)
    4c84:	c971                	beqz	a0,4d58 <bigfile+0x18e>
    if(cc != SZ/2){
    4c86:	12c00793          	li	a5,300
    4c8a:	08f51b63          	bne	a0,a5,4d20 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4c8e:	01f4d79b          	srliw	a5,s1,0x1f
    4c92:	9fa5                	addw	a5,a5,s1
    4c94:	4017d79b          	sraiw	a5,a5,0x1
    4c98:	00094703          	lbu	a4,0(s2)
    4c9c:	0af71063          	bne	a4,a5,4d3c <bigfile+0x172>
    4ca0:	12b94703          	lbu	a4,299(s2)
    4ca4:	08f71c63          	bne	a4,a5,4d3c <bigfile+0x172>
    total += cc;
    4ca8:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4cac:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4cae:	b7c9                	j	4c70 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4cb0:	85d6                	mv	a1,s5
    4cb2:	00003517          	auipc	a0,0x3
    4cb6:	13650513          	addi	a0,a0,310 # 7de8 <malloc+0x2136>
    4cba:	00001097          	auipc	ra,0x1
    4cbe:	f3a080e7          	jalr	-198(ra) # 5bf4 <printf>
    exit(1);
    4cc2:	4505                	li	a0,1
    4cc4:	00001097          	auipc	ra,0x1
    4cc8:	ba8080e7          	jalr	-1112(ra) # 586c <exit>
      printf("%s: write bigfile failed\n", s);
    4ccc:	85d6                	mv	a1,s5
    4cce:	00003517          	auipc	a0,0x3
    4cd2:	13a50513          	addi	a0,a0,314 # 7e08 <malloc+0x2156>
    4cd6:	00001097          	auipc	ra,0x1
    4cda:	f1e080e7          	jalr	-226(ra) # 5bf4 <printf>
      exit(1);
    4cde:	4505                	li	a0,1
    4ce0:	00001097          	auipc	ra,0x1
    4ce4:	b8c080e7          	jalr	-1140(ra) # 586c <exit>
    printf("%s: cannot open bigfile\n", s);
    4ce8:	85d6                	mv	a1,s5
    4cea:	00003517          	auipc	a0,0x3
    4cee:	13e50513          	addi	a0,a0,318 # 7e28 <malloc+0x2176>
    4cf2:	00001097          	auipc	ra,0x1
    4cf6:	f02080e7          	jalr	-254(ra) # 5bf4 <printf>
    exit(1);
    4cfa:	4505                	li	a0,1
    4cfc:	00001097          	auipc	ra,0x1
    4d00:	b70080e7          	jalr	-1168(ra) # 586c <exit>
      printf("%s: read bigfile failed\n", s);
    4d04:	85d6                	mv	a1,s5
    4d06:	00003517          	auipc	a0,0x3
    4d0a:	14250513          	addi	a0,a0,322 # 7e48 <malloc+0x2196>
    4d0e:	00001097          	auipc	ra,0x1
    4d12:	ee6080e7          	jalr	-282(ra) # 5bf4 <printf>
      exit(1);
    4d16:	4505                	li	a0,1
    4d18:	00001097          	auipc	ra,0x1
    4d1c:	b54080e7          	jalr	-1196(ra) # 586c <exit>
      printf("%s: short read bigfile\n", s);
    4d20:	85d6                	mv	a1,s5
    4d22:	00003517          	auipc	a0,0x3
    4d26:	14650513          	addi	a0,a0,326 # 7e68 <malloc+0x21b6>
    4d2a:	00001097          	auipc	ra,0x1
    4d2e:	eca080e7          	jalr	-310(ra) # 5bf4 <printf>
      exit(1);
    4d32:	4505                	li	a0,1
    4d34:	00001097          	auipc	ra,0x1
    4d38:	b38080e7          	jalr	-1224(ra) # 586c <exit>
      printf("%s: read bigfile wrong data\n", s);
    4d3c:	85d6                	mv	a1,s5
    4d3e:	00003517          	auipc	a0,0x3
    4d42:	14250513          	addi	a0,a0,322 # 7e80 <malloc+0x21ce>
    4d46:	00001097          	auipc	ra,0x1
    4d4a:	eae080e7          	jalr	-338(ra) # 5bf4 <printf>
      exit(1);
    4d4e:	4505                	li	a0,1
    4d50:	00001097          	auipc	ra,0x1
    4d54:	b1c080e7          	jalr	-1252(ra) # 586c <exit>
  close(fd);
    4d58:	8552                	mv	a0,s4
    4d5a:	00001097          	auipc	ra,0x1
    4d5e:	b3a080e7          	jalr	-1222(ra) # 5894 <close>
  if(total != N*SZ){
    4d62:	678d                	lui	a5,0x3
    4d64:	ee078793          	addi	a5,a5,-288 # 2ee0 <iputtest+0xc8>
    4d68:	02f99363          	bne	s3,a5,4d8e <bigfile+0x1c4>
  unlink("bigfile.dat");
    4d6c:	00003517          	auipc	a0,0x3
    4d70:	06c50513          	addi	a0,a0,108 # 7dd8 <malloc+0x2126>
    4d74:	00001097          	auipc	ra,0x1
    4d78:	b48080e7          	jalr	-1208(ra) # 58bc <unlink>
}
    4d7c:	70e2                	ld	ra,56(sp)
    4d7e:	7442                	ld	s0,48(sp)
    4d80:	74a2                	ld	s1,40(sp)
    4d82:	7902                	ld	s2,32(sp)
    4d84:	69e2                	ld	s3,24(sp)
    4d86:	6a42                	ld	s4,16(sp)
    4d88:	6aa2                	ld	s5,8(sp)
    4d8a:	6121                	addi	sp,sp,64
    4d8c:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4d8e:	85d6                	mv	a1,s5
    4d90:	00003517          	auipc	a0,0x3
    4d94:	11050513          	addi	a0,a0,272 # 7ea0 <malloc+0x21ee>
    4d98:	00001097          	auipc	ra,0x1
    4d9c:	e5c080e7          	jalr	-420(ra) # 5bf4 <printf>
    exit(1);
    4da0:	4505                	li	a0,1
    4da2:	00001097          	auipc	ra,0x1
    4da6:	aca080e7          	jalr	-1334(ra) # 586c <exit>

0000000000004daa <bigdir>:
{
    4daa:	715d                	addi	sp,sp,-80
    4dac:	e486                	sd	ra,72(sp)
    4dae:	e0a2                	sd	s0,64(sp)
    4db0:	fc26                	sd	s1,56(sp)
    4db2:	f84a                	sd	s2,48(sp)
    4db4:	f44e                	sd	s3,40(sp)
    4db6:	f052                	sd	s4,32(sp)
    4db8:	ec56                	sd	s5,24(sp)
    4dba:	e85a                	sd	s6,16(sp)
    4dbc:	0880                	addi	s0,sp,80
    4dbe:	89aa                	mv	s3,a0
  unlink("bd");
    4dc0:	00003517          	auipc	a0,0x3
    4dc4:	10050513          	addi	a0,a0,256 # 7ec0 <malloc+0x220e>
    4dc8:	00001097          	auipc	ra,0x1
    4dcc:	af4080e7          	jalr	-1292(ra) # 58bc <unlink>
  fd = open("bd", O_CREATE);
    4dd0:	20000593          	li	a1,512
    4dd4:	00003517          	auipc	a0,0x3
    4dd8:	0ec50513          	addi	a0,a0,236 # 7ec0 <malloc+0x220e>
    4ddc:	00001097          	auipc	ra,0x1
    4de0:	ad0080e7          	jalr	-1328(ra) # 58ac <open>
  if(fd < 0){
    4de4:	0c054963          	bltz	a0,4eb6 <bigdir+0x10c>
  close(fd);
    4de8:	00001097          	auipc	ra,0x1
    4dec:	aac080e7          	jalr	-1364(ra) # 5894 <close>
  for(i = 0; i < N; i++){
    4df0:	4901                	li	s2,0
    name[0] = 'x';
    4df2:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    4df6:	00003a17          	auipc	s4,0x3
    4dfa:	0caa0a13          	addi	s4,s4,202 # 7ec0 <malloc+0x220e>
  for(i = 0; i < N; i++){
    4dfe:	1f400b13          	li	s6,500
    name[0] = 'x';
    4e02:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    4e06:	41f9579b          	sraiw	a5,s2,0x1f
    4e0a:	01a7d71b          	srliw	a4,a5,0x1a
    4e0e:	012707bb          	addw	a5,a4,s2
    4e12:	4067d69b          	sraiw	a3,a5,0x6
    4e16:	0306869b          	addiw	a3,a3,48
    4e1a:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    4e1e:	03f7f793          	andi	a5,a5,63
    4e22:	9f99                	subw	a5,a5,a4
    4e24:	0307879b          	addiw	a5,a5,48
    4e28:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    4e2c:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    4e30:	fb040593          	addi	a1,s0,-80
    4e34:	8552                	mv	a0,s4
    4e36:	00001097          	auipc	ra,0x1
    4e3a:	a96080e7          	jalr	-1386(ra) # 58cc <link>
    4e3e:	84aa                	mv	s1,a0
    4e40:	e949                	bnez	a0,4ed2 <bigdir+0x128>
  for(i = 0; i < N; i++){
    4e42:	2905                	addiw	s2,s2,1
    4e44:	fb691fe3          	bne	s2,s6,4e02 <bigdir+0x58>
  unlink("bd");
    4e48:	00003517          	auipc	a0,0x3
    4e4c:	07850513          	addi	a0,a0,120 # 7ec0 <malloc+0x220e>
    4e50:	00001097          	auipc	ra,0x1
    4e54:	a6c080e7          	jalr	-1428(ra) # 58bc <unlink>
    name[0] = 'x';
    4e58:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    4e5c:	1f400a13          	li	s4,500
    name[0] = 'x';
    4e60:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    4e64:	41f4d79b          	sraiw	a5,s1,0x1f
    4e68:	01a7d71b          	srliw	a4,a5,0x1a
    4e6c:	009707bb          	addw	a5,a4,s1
    4e70:	4067d69b          	sraiw	a3,a5,0x6
    4e74:	0306869b          	addiw	a3,a3,48
    4e78:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    4e7c:	03f7f793          	andi	a5,a5,63
    4e80:	9f99                	subw	a5,a5,a4
    4e82:	0307879b          	addiw	a5,a5,48
    4e86:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    4e8a:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    4e8e:	fb040513          	addi	a0,s0,-80
    4e92:	00001097          	auipc	ra,0x1
    4e96:	a2a080e7          	jalr	-1494(ra) # 58bc <unlink>
    4e9a:	ed21                	bnez	a0,4ef2 <bigdir+0x148>
  for(i = 0; i < N; i++){
    4e9c:	2485                	addiw	s1,s1,1
    4e9e:	fd4491e3          	bne	s1,s4,4e60 <bigdir+0xb6>
}
    4ea2:	60a6                	ld	ra,72(sp)
    4ea4:	6406                	ld	s0,64(sp)
    4ea6:	74e2                	ld	s1,56(sp)
    4ea8:	7942                	ld	s2,48(sp)
    4eaa:	79a2                	ld	s3,40(sp)
    4eac:	7a02                	ld	s4,32(sp)
    4eae:	6ae2                	ld	s5,24(sp)
    4eb0:	6b42                	ld	s6,16(sp)
    4eb2:	6161                	addi	sp,sp,80
    4eb4:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    4eb6:	85ce                	mv	a1,s3
    4eb8:	00003517          	auipc	a0,0x3
    4ebc:	01050513          	addi	a0,a0,16 # 7ec8 <malloc+0x2216>
    4ec0:	00001097          	auipc	ra,0x1
    4ec4:	d34080e7          	jalr	-716(ra) # 5bf4 <printf>
    exit(1);
    4ec8:	4505                	li	a0,1
    4eca:	00001097          	auipc	ra,0x1
    4ece:	9a2080e7          	jalr	-1630(ra) # 586c <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    4ed2:	fb040613          	addi	a2,s0,-80
    4ed6:	85ce                	mv	a1,s3
    4ed8:	00003517          	auipc	a0,0x3
    4edc:	01050513          	addi	a0,a0,16 # 7ee8 <malloc+0x2236>
    4ee0:	00001097          	auipc	ra,0x1
    4ee4:	d14080e7          	jalr	-748(ra) # 5bf4 <printf>
      exit(1);
    4ee8:	4505                	li	a0,1
    4eea:	00001097          	auipc	ra,0x1
    4eee:	982080e7          	jalr	-1662(ra) # 586c <exit>
      printf("%s: bigdir unlink failed", s);
    4ef2:	85ce                	mv	a1,s3
    4ef4:	00003517          	auipc	a0,0x3
    4ef8:	01450513          	addi	a0,a0,20 # 7f08 <malloc+0x2256>
    4efc:	00001097          	auipc	ra,0x1
    4f00:	cf8080e7          	jalr	-776(ra) # 5bf4 <printf>
      exit(1);
    4f04:	4505                	li	a0,1
    4f06:	00001097          	auipc	ra,0x1
    4f0a:	966080e7          	jalr	-1690(ra) # 586c <exit>

0000000000004f0e <fsfull>:
{
    4f0e:	7171                	addi	sp,sp,-176
    4f10:	f506                	sd	ra,168(sp)
    4f12:	f122                	sd	s0,160(sp)
    4f14:	ed26                	sd	s1,152(sp)
    4f16:	e94a                	sd	s2,144(sp)
    4f18:	e54e                	sd	s3,136(sp)
    4f1a:	e152                	sd	s4,128(sp)
    4f1c:	fcd6                	sd	s5,120(sp)
    4f1e:	f8da                	sd	s6,112(sp)
    4f20:	f4de                	sd	s7,104(sp)
    4f22:	f0e2                	sd	s8,96(sp)
    4f24:	ece6                	sd	s9,88(sp)
    4f26:	e8ea                	sd	s10,80(sp)
    4f28:	e4ee                	sd	s11,72(sp)
    4f2a:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4f2c:	00003517          	auipc	a0,0x3
    4f30:	ffc50513          	addi	a0,a0,-4 # 7f28 <malloc+0x2276>
    4f34:	00001097          	auipc	ra,0x1
    4f38:	cc0080e7          	jalr	-832(ra) # 5bf4 <printf>
  for(nfiles = 0; ; nfiles++){
    4f3c:	4481                	li	s1,0
    name[0] = 'f';
    4f3e:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4f42:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4f46:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4f4a:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4f4c:	00003c97          	auipc	s9,0x3
    4f50:	fecc8c93          	addi	s9,s9,-20 # 7f38 <malloc+0x2286>
    int total = 0;
    4f54:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4f56:	00007a17          	auipc	s4,0x7
    4f5a:	e52a0a13          	addi	s4,s4,-430 # bda8 <buf>
    name[0] = 'f';
    4f5e:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4f62:	0384c7bb          	divw	a5,s1,s8
    4f66:	0307879b          	addiw	a5,a5,48
    4f6a:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4f6e:	0384e7bb          	remw	a5,s1,s8
    4f72:	0377c7bb          	divw	a5,a5,s7
    4f76:	0307879b          	addiw	a5,a5,48
    4f7a:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4f7e:	0374e7bb          	remw	a5,s1,s7
    4f82:	0367c7bb          	divw	a5,a5,s6
    4f86:	0307879b          	addiw	a5,a5,48
    4f8a:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4f8e:	0364e7bb          	remw	a5,s1,s6
    4f92:	0307879b          	addiw	a5,a5,48
    4f96:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4f9a:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4f9e:	f5040593          	addi	a1,s0,-176
    4fa2:	8566                	mv	a0,s9
    4fa4:	00001097          	auipc	ra,0x1
    4fa8:	c50080e7          	jalr	-944(ra) # 5bf4 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4fac:	20200593          	li	a1,514
    4fb0:	f5040513          	addi	a0,s0,-176
    4fb4:	00001097          	auipc	ra,0x1
    4fb8:	8f8080e7          	jalr	-1800(ra) # 58ac <open>
    4fbc:	892a                	mv	s2,a0
    if(fd < 0){
    4fbe:	0a055663          	bgez	a0,506a <fsfull+0x15c>
      printf("open %s failed\n", name);
    4fc2:	f5040593          	addi	a1,s0,-176
    4fc6:	00003517          	auipc	a0,0x3
    4fca:	f8250513          	addi	a0,a0,-126 # 7f48 <malloc+0x2296>
    4fce:	00001097          	auipc	ra,0x1
    4fd2:	c26080e7          	jalr	-986(ra) # 5bf4 <printf>
  while(nfiles >= 0){
    4fd6:	0604c363          	bltz	s1,503c <fsfull+0x12e>
    name[0] = 'f';
    4fda:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4fde:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4fe2:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4fe6:	4929                	li	s2,10
  while(nfiles >= 0){
    4fe8:	5afd                	li	s5,-1
    name[0] = 'f';
    4fea:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4fee:	0344c7bb          	divw	a5,s1,s4
    4ff2:	0307879b          	addiw	a5,a5,48
    4ff6:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4ffa:	0344e7bb          	remw	a5,s1,s4
    4ffe:	0337c7bb          	divw	a5,a5,s3
    5002:	0307879b          	addiw	a5,a5,48
    5006:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    500a:	0334e7bb          	remw	a5,s1,s3
    500e:	0327c7bb          	divw	a5,a5,s2
    5012:	0307879b          	addiw	a5,a5,48
    5016:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    501a:	0324e7bb          	remw	a5,s1,s2
    501e:	0307879b          	addiw	a5,a5,48
    5022:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5026:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    502a:	f5040513          	addi	a0,s0,-176
    502e:	00001097          	auipc	ra,0x1
    5032:	88e080e7          	jalr	-1906(ra) # 58bc <unlink>
    nfiles--;
    5036:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    5038:	fb5499e3          	bne	s1,s5,4fea <fsfull+0xdc>
  printf("fsfull test finished\n");
    503c:	00003517          	auipc	a0,0x3
    5040:	f2c50513          	addi	a0,a0,-212 # 7f68 <malloc+0x22b6>
    5044:	00001097          	auipc	ra,0x1
    5048:	bb0080e7          	jalr	-1104(ra) # 5bf4 <printf>
}
    504c:	70aa                	ld	ra,168(sp)
    504e:	740a                	ld	s0,160(sp)
    5050:	64ea                	ld	s1,152(sp)
    5052:	694a                	ld	s2,144(sp)
    5054:	69aa                	ld	s3,136(sp)
    5056:	6a0a                	ld	s4,128(sp)
    5058:	7ae6                	ld	s5,120(sp)
    505a:	7b46                	ld	s6,112(sp)
    505c:	7ba6                	ld	s7,104(sp)
    505e:	7c06                	ld	s8,96(sp)
    5060:	6ce6                	ld	s9,88(sp)
    5062:	6d46                	ld	s10,80(sp)
    5064:	6da6                	ld	s11,72(sp)
    5066:	614d                	addi	sp,sp,176
    5068:	8082                	ret
    int total = 0;
    506a:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    506c:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    5070:	40000613          	li	a2,1024
    5074:	85d2                	mv	a1,s4
    5076:	854a                	mv	a0,s2
    5078:	00001097          	auipc	ra,0x1
    507c:	814080e7          	jalr	-2028(ra) # 588c <write>
      if(cc < BSIZE)
    5080:	00aad563          	bge	s5,a0,508a <fsfull+0x17c>
      total += cc;
    5084:	00a989bb          	addw	s3,s3,a0
    while(1){
    5088:	b7e5                	j	5070 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    508a:	85ce                	mv	a1,s3
    508c:	00003517          	auipc	a0,0x3
    5090:	ecc50513          	addi	a0,a0,-308 # 7f58 <malloc+0x22a6>
    5094:	00001097          	auipc	ra,0x1
    5098:	b60080e7          	jalr	-1184(ra) # 5bf4 <printf>
    close(fd);
    509c:	854a                	mv	a0,s2
    509e:	00000097          	auipc	ra,0x0
    50a2:	7f6080e7          	jalr	2038(ra) # 5894 <close>
    if(total == 0)
    50a6:	f20988e3          	beqz	s3,4fd6 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    50aa:	2485                	addiw	s1,s1,1
    50ac:	bd4d                	j	4f5e <fsfull+0x50>

00000000000050ae <badwrite>:
{
    50ae:	7179                	addi	sp,sp,-48
    50b0:	f406                	sd	ra,40(sp)
    50b2:	f022                	sd	s0,32(sp)
    50b4:	ec26                	sd	s1,24(sp)
    50b6:	e84a                	sd	s2,16(sp)
    50b8:	e44e                	sd	s3,8(sp)
    50ba:	e052                	sd	s4,0(sp)
    50bc:	1800                	addi	s0,sp,48
  unlink("junk");
    50be:	00003517          	auipc	a0,0x3
    50c2:	ec250513          	addi	a0,a0,-318 # 7f80 <malloc+0x22ce>
    50c6:	00000097          	auipc	ra,0x0
    50ca:	7f6080e7          	jalr	2038(ra) # 58bc <unlink>
    50ce:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    50d2:	00003997          	auipc	s3,0x3
    50d6:	eae98993          	addi	s3,s3,-338 # 7f80 <malloc+0x22ce>
    write(fd, (char*)0xffffffffffL, 1);
    50da:	5a7d                	li	s4,-1
    50dc:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    50e0:	20100593          	li	a1,513
    50e4:	854e                	mv	a0,s3
    50e6:	00000097          	auipc	ra,0x0
    50ea:	7c6080e7          	jalr	1990(ra) # 58ac <open>
    50ee:	84aa                	mv	s1,a0
    if(fd < 0){
    50f0:	06054b63          	bltz	a0,5166 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    50f4:	4605                	li	a2,1
    50f6:	85d2                	mv	a1,s4
    50f8:	00000097          	auipc	ra,0x0
    50fc:	794080e7          	jalr	1940(ra) # 588c <write>
    close(fd);
    5100:	8526                	mv	a0,s1
    5102:	00000097          	auipc	ra,0x0
    5106:	792080e7          	jalr	1938(ra) # 5894 <close>
    unlink("junk");
    510a:	854e                	mv	a0,s3
    510c:	00000097          	auipc	ra,0x0
    5110:	7b0080e7          	jalr	1968(ra) # 58bc <unlink>
  for(int i = 0; i < assumed_free; i++){
    5114:	397d                	addiw	s2,s2,-1
    5116:	fc0915e3          	bnez	s2,50e0 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    511a:	20100593          	li	a1,513
    511e:	00003517          	auipc	a0,0x3
    5122:	e6250513          	addi	a0,a0,-414 # 7f80 <malloc+0x22ce>
    5126:	00000097          	auipc	ra,0x0
    512a:	786080e7          	jalr	1926(ra) # 58ac <open>
    512e:	84aa                	mv	s1,a0
  if(fd < 0){
    5130:	04054863          	bltz	a0,5180 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    5134:	4605                	li	a2,1
    5136:	00001597          	auipc	a1,0x1
    513a:	06258593          	addi	a1,a1,98 # 6198 <malloc+0x4e6>
    513e:	00000097          	auipc	ra,0x0
    5142:	74e080e7          	jalr	1870(ra) # 588c <write>
    5146:	4785                	li	a5,1
    5148:	04f50963          	beq	a0,a5,519a <badwrite+0xec>
    printf("write failed\n");
    514c:	00003517          	auipc	a0,0x3
    5150:	e5450513          	addi	a0,a0,-428 # 7fa0 <malloc+0x22ee>
    5154:	00001097          	auipc	ra,0x1
    5158:	aa0080e7          	jalr	-1376(ra) # 5bf4 <printf>
    exit(1);
    515c:	4505                	li	a0,1
    515e:	00000097          	auipc	ra,0x0
    5162:	70e080e7          	jalr	1806(ra) # 586c <exit>
      printf("open junk failed\n");
    5166:	00003517          	auipc	a0,0x3
    516a:	e2250513          	addi	a0,a0,-478 # 7f88 <malloc+0x22d6>
    516e:	00001097          	auipc	ra,0x1
    5172:	a86080e7          	jalr	-1402(ra) # 5bf4 <printf>
      exit(1);
    5176:	4505                	li	a0,1
    5178:	00000097          	auipc	ra,0x0
    517c:	6f4080e7          	jalr	1780(ra) # 586c <exit>
    printf("open junk failed\n");
    5180:	00003517          	auipc	a0,0x3
    5184:	e0850513          	addi	a0,a0,-504 # 7f88 <malloc+0x22d6>
    5188:	00001097          	auipc	ra,0x1
    518c:	a6c080e7          	jalr	-1428(ra) # 5bf4 <printf>
    exit(1);
    5190:	4505                	li	a0,1
    5192:	00000097          	auipc	ra,0x0
    5196:	6da080e7          	jalr	1754(ra) # 586c <exit>
  close(fd);
    519a:	8526                	mv	a0,s1
    519c:	00000097          	auipc	ra,0x0
    51a0:	6f8080e7          	jalr	1784(ra) # 5894 <close>
  unlink("junk");
    51a4:	00003517          	auipc	a0,0x3
    51a8:	ddc50513          	addi	a0,a0,-548 # 7f80 <malloc+0x22ce>
    51ac:	00000097          	auipc	ra,0x0
    51b0:	710080e7          	jalr	1808(ra) # 58bc <unlink>
  exit(0);
    51b4:	4501                	li	a0,0
    51b6:	00000097          	auipc	ra,0x0
    51ba:	6b6080e7          	jalr	1718(ra) # 586c <exit>

00000000000051be <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    51be:	7139                	addi	sp,sp,-64
    51c0:	fc06                	sd	ra,56(sp)
    51c2:	f822                	sd	s0,48(sp)
    51c4:	f426                	sd	s1,40(sp)
    51c6:	f04a                	sd	s2,32(sp)
    51c8:	ec4e                	sd	s3,24(sp)
    51ca:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    51cc:	fc840513          	addi	a0,s0,-56
    51d0:	00000097          	auipc	ra,0x0
    51d4:	6ac080e7          	jalr	1708(ra) # 587c <pipe>
    51d8:	06054863          	bltz	a0,5248 <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    51dc:	00000097          	auipc	ra,0x0
    51e0:	688080e7          	jalr	1672(ra) # 5864 <fork>

  if(pid < 0){
    51e4:	06054f63          	bltz	a0,5262 <countfree+0xa4>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    51e8:	ed59                	bnez	a0,5286 <countfree+0xc8>
    close(fds[0]);
    51ea:	fc842503          	lw	a0,-56(s0)
    51ee:	00000097          	auipc	ra,0x0
    51f2:	6a6080e7          	jalr	1702(ra) # 5894 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    51f6:	54fd                	li	s1,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    51f8:	4985                	li	s3,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    51fa:	00001917          	auipc	s2,0x1
    51fe:	f9e90913          	addi	s2,s2,-98 # 6198 <malloc+0x4e6>
      uint64 a = (uint64) sbrk(4096);
    5202:	6505                	lui	a0,0x1
    5204:	00000097          	auipc	ra,0x0
    5208:	6f0080e7          	jalr	1776(ra) # 58f4 <sbrk>
      if(a == 0xffffffffffffffff){
    520c:	06950863          	beq	a0,s1,527c <countfree+0xbe>
      *(char *)(a + 4096 - 1) = 1;
    5210:	6785                	lui	a5,0x1
    5212:	953e                	add	a0,a0,a5
    5214:	ff350fa3          	sb	s3,-1(a0) # fff <pgbug+0x2f>
      if(write(fds[1], "x", 1) != 1){
    5218:	4605                	li	a2,1
    521a:	85ca                	mv	a1,s2
    521c:	fcc42503          	lw	a0,-52(s0)
    5220:	00000097          	auipc	ra,0x0
    5224:	66c080e7          	jalr	1644(ra) # 588c <write>
    5228:	4785                	li	a5,1
    522a:	fcf50ce3          	beq	a0,a5,5202 <countfree+0x44>
        printf("write() failed in countfree()\n");
    522e:	00003517          	auipc	a0,0x3
    5232:	dc250513          	addi	a0,a0,-574 # 7ff0 <malloc+0x233e>
    5236:	00001097          	auipc	ra,0x1
    523a:	9be080e7          	jalr	-1602(ra) # 5bf4 <printf>
        exit(1);
    523e:	4505                	li	a0,1
    5240:	00000097          	auipc	ra,0x0
    5244:	62c080e7          	jalr	1580(ra) # 586c <exit>
    printf("pipe() failed in countfree()\n");
    5248:	00003517          	auipc	a0,0x3
    524c:	d6850513          	addi	a0,a0,-664 # 7fb0 <malloc+0x22fe>
    5250:	00001097          	auipc	ra,0x1
    5254:	9a4080e7          	jalr	-1628(ra) # 5bf4 <printf>
    exit(1);
    5258:	4505                	li	a0,1
    525a:	00000097          	auipc	ra,0x0
    525e:	612080e7          	jalr	1554(ra) # 586c <exit>
    printf("fork failed in countfree()\n");
    5262:	00003517          	auipc	a0,0x3
    5266:	d6e50513          	addi	a0,a0,-658 # 7fd0 <malloc+0x231e>
    526a:	00001097          	auipc	ra,0x1
    526e:	98a080e7          	jalr	-1654(ra) # 5bf4 <printf>
    exit(1);
    5272:	4505                	li	a0,1
    5274:	00000097          	auipc	ra,0x0
    5278:	5f8080e7          	jalr	1528(ra) # 586c <exit>
      }
    }

    exit(0);
    527c:	4501                	li	a0,0
    527e:	00000097          	auipc	ra,0x0
    5282:	5ee080e7          	jalr	1518(ra) # 586c <exit>
  }

  close(fds[1]);
    5286:	fcc42503          	lw	a0,-52(s0)
    528a:	00000097          	auipc	ra,0x0
    528e:	60a080e7          	jalr	1546(ra) # 5894 <close>

  int n = 0;
    5292:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    5294:	4605                	li	a2,1
    5296:	fc740593          	addi	a1,s0,-57
    529a:	fc842503          	lw	a0,-56(s0)
    529e:	00000097          	auipc	ra,0x0
    52a2:	5e6080e7          	jalr	1510(ra) # 5884 <read>
    if(cc < 0){
    52a6:	00054563          	bltz	a0,52b0 <countfree+0xf2>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    52aa:	c105                	beqz	a0,52ca <countfree+0x10c>
      break;
    n += 1;
    52ac:	2485                	addiw	s1,s1,1
  while(1){
    52ae:	b7dd                	j	5294 <countfree+0xd6>
      printf("read() failed in countfree()\n");
    52b0:	00003517          	auipc	a0,0x3
    52b4:	d6050513          	addi	a0,a0,-672 # 8010 <malloc+0x235e>
    52b8:	00001097          	auipc	ra,0x1
    52bc:	93c080e7          	jalr	-1732(ra) # 5bf4 <printf>
      exit(1);
    52c0:	4505                	li	a0,1
    52c2:	00000097          	auipc	ra,0x0
    52c6:	5aa080e7          	jalr	1450(ra) # 586c <exit>
  }

  close(fds[0]);
    52ca:	fc842503          	lw	a0,-56(s0)
    52ce:	00000097          	auipc	ra,0x0
    52d2:	5c6080e7          	jalr	1478(ra) # 5894 <close>
  wait((int*)0);
    52d6:	4501                	li	a0,0
    52d8:	00000097          	auipc	ra,0x0
    52dc:	59c080e7          	jalr	1436(ra) # 5874 <wait>
  
  return n;
}
    52e0:	8526                	mv	a0,s1
    52e2:	70e2                	ld	ra,56(sp)
    52e4:	7442                	ld	s0,48(sp)
    52e6:	74a2                	ld	s1,40(sp)
    52e8:	7902                	ld	s2,32(sp)
    52ea:	69e2                	ld	s3,24(sp)
    52ec:	6121                	addi	sp,sp,64
    52ee:	8082                	ret

00000000000052f0 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    52f0:	7179                	addi	sp,sp,-48
    52f2:	f406                	sd	ra,40(sp)
    52f4:	f022                	sd	s0,32(sp)
    52f6:	ec26                	sd	s1,24(sp)
    52f8:	e84a                	sd	s2,16(sp)
    52fa:	1800                	addi	s0,sp,48
    52fc:	84aa                	mv	s1,a0
    52fe:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5300:	00003517          	auipc	a0,0x3
    5304:	d3050513          	addi	a0,a0,-720 # 8030 <malloc+0x237e>
    5308:	00001097          	auipc	ra,0x1
    530c:	8ec080e7          	jalr	-1812(ra) # 5bf4 <printf>
  if((pid = fork()) < 0) {
    5310:	00000097          	auipc	ra,0x0
    5314:	554080e7          	jalr	1364(ra) # 5864 <fork>
    5318:	02054e63          	bltz	a0,5354 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    531c:	c929                	beqz	a0,536e <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    531e:	fdc40513          	addi	a0,s0,-36
    5322:	00000097          	auipc	ra,0x0
    5326:	552080e7          	jalr	1362(ra) # 5874 <wait>
    if(xstatus != 0) 
    532a:	fdc42783          	lw	a5,-36(s0)
    532e:	c7b9                	beqz	a5,537c <run+0x8c>
      printf("FAILED\n");
    5330:	00003517          	auipc	a0,0x3
    5334:	d2850513          	addi	a0,a0,-728 # 8058 <malloc+0x23a6>
    5338:	00001097          	auipc	ra,0x1
    533c:	8bc080e7          	jalr	-1860(ra) # 5bf4 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5340:	fdc42503          	lw	a0,-36(s0)
  }
}
    5344:	00153513          	seqz	a0,a0
    5348:	70a2                	ld	ra,40(sp)
    534a:	7402                	ld	s0,32(sp)
    534c:	64e2                	ld	s1,24(sp)
    534e:	6942                	ld	s2,16(sp)
    5350:	6145                	addi	sp,sp,48
    5352:	8082                	ret
    printf("runtest: fork error\n");
    5354:	00003517          	auipc	a0,0x3
    5358:	cec50513          	addi	a0,a0,-788 # 8040 <malloc+0x238e>
    535c:	00001097          	auipc	ra,0x1
    5360:	898080e7          	jalr	-1896(ra) # 5bf4 <printf>
    exit(1);
    5364:	4505                	li	a0,1
    5366:	00000097          	auipc	ra,0x0
    536a:	506080e7          	jalr	1286(ra) # 586c <exit>
    f(s);
    536e:	854a                	mv	a0,s2
    5370:	9482                	jalr	s1
    exit(0);
    5372:	4501                	li	a0,0
    5374:	00000097          	auipc	ra,0x0
    5378:	4f8080e7          	jalr	1272(ra) # 586c <exit>
      printf("OK\n");
    537c:	00003517          	auipc	a0,0x3
    5380:	ce450513          	addi	a0,a0,-796 # 8060 <malloc+0x23ae>
    5384:	00001097          	auipc	ra,0x1
    5388:	870080e7          	jalr	-1936(ra) # 5bf4 <printf>
    538c:	bf55                	j	5340 <run+0x50>

000000000000538e <main>:

int
main(int argc, char *argv[])
{
    538e:	bd010113          	addi	sp,sp,-1072
    5392:	42113423          	sd	ra,1064(sp)
    5396:	42813023          	sd	s0,1056(sp)
    539a:	40913c23          	sd	s1,1048(sp)
    539e:	41213823          	sd	s2,1040(sp)
    53a2:	41313423          	sd	s3,1032(sp)
    53a6:	41413023          	sd	s4,1024(sp)
    53aa:	3f513c23          	sd	s5,1016(sp)
    53ae:	3f613823          	sd	s6,1008(sp)
    53b2:	3f713423          	sd	s7,1000(sp)
    53b6:	3f813023          	sd	s8,992(sp)
    53ba:	43010413          	addi	s0,sp,1072
    53be:	8aaa                	mv	s5,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    53c0:	4789                	li	a5,2
    53c2:	08f50763          	beq	a0,a5,5450 <main+0xc2>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    53c6:	4785                	li	a5,1
  char *justone = 0;
    53c8:	4901                	li	s2,0
  } else if(argc > 1){
    53ca:	0ca7c263          	blt	a5,a0,548e <main+0x100>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    53ce:	00003797          	auipc	a5,0x3
    53d2:	db278793          	addi	a5,a5,-590 # 8180 <malloc+0x24ce>
    53d6:	bd040713          	addi	a4,s0,-1072
    53da:	00003817          	auipc	a6,0x3
    53de:	18680813          	addi	a6,a6,390 # 8560 <malloc+0x28ae>
    53e2:	6388                	ld	a0,0(a5)
    53e4:	678c                	ld	a1,8(a5)
    53e6:	6b90                	ld	a2,16(a5)
    53e8:	6f94                	ld	a3,24(a5)
    53ea:	e308                	sd	a0,0(a4)
    53ec:	e70c                	sd	a1,8(a4)
    53ee:	eb10                	sd	a2,16(a4)
    53f0:	ef14                	sd	a3,24(a4)
    53f2:	02078793          	addi	a5,a5,32
    53f6:	02070713          	addi	a4,a4,32
    53fa:	ff0794e3          	bne	a5,a6,53e2 <main+0x54>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    53fe:	00003517          	auipc	a0,0x3
    5402:	d2250513          	addi	a0,a0,-734 # 8120 <malloc+0x246e>
    5406:	00000097          	auipc	ra,0x0
    540a:	7ee080e7          	jalr	2030(ra) # 5bf4 <printf>
  int free0 = countfree();
    540e:	00000097          	auipc	ra,0x0
    5412:	db0080e7          	jalr	-592(ra) # 51be <countfree>
    5416:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    5418:	bd843503          	ld	a0,-1064(s0)
    541c:	bd040493          	addi	s1,s0,-1072
  int fail = 0;
    5420:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    5422:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    5424:	e945                	bnez	a0,54d4 <main+0x146>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    5426:	00000097          	auipc	ra,0x0
    542a:	d98080e7          	jalr	-616(ra) # 51be <countfree>
    542e:	85aa                	mv	a1,a0
    5430:	0f455263          	bge	a0,s4,5514 <main+0x186>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5434:	8652                	mv	a2,s4
    5436:	00003517          	auipc	a0,0x3
    543a:	ca250513          	addi	a0,a0,-862 # 80d8 <malloc+0x2426>
    543e:	00000097          	auipc	ra,0x0
    5442:	7b6080e7          	jalr	1974(ra) # 5bf4 <printf>
    exit(1);
    5446:	4505                	li	a0,1
    5448:	00000097          	auipc	ra,0x0
    544c:	424080e7          	jalr	1060(ra) # 586c <exit>
    5450:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5452:	00003597          	auipc	a1,0x3
    5456:	c1658593          	addi	a1,a1,-1002 # 8068 <malloc+0x23b6>
    545a:	6488                	ld	a0,8(s1)
    545c:	00000097          	auipc	ra,0x0
    5460:	1a0080e7          	jalr	416(ra) # 55fc <strcmp>
    5464:	10050f63          	beqz	a0,5582 <main+0x1f4>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5468:	00003597          	auipc	a1,0x3
    546c:	cf058593          	addi	a1,a1,-784 # 8158 <malloc+0x24a6>
    5470:	6488                	ld	a0,8(s1)
    5472:	00000097          	auipc	ra,0x0
    5476:	18a080e7          	jalr	394(ra) # 55fc <strcmp>
    547a:	10050563          	beqz	a0,5584 <main+0x1f6>
  } else if(argc == 2 && argv[1][0] != '-'){
    547e:	0084b903          	ld	s2,8(s1)
    5482:	00094703          	lbu	a4,0(s2)
    5486:	02d00793          	li	a5,45
    548a:	f4f712e3          	bne	a4,a5,53ce <main+0x40>
    printf("Usage: usertests [-c] [testname]\n");
    548e:	00003517          	auipc	a0,0x3
    5492:	be250513          	addi	a0,a0,-1054 # 8070 <malloc+0x23be>
    5496:	00000097          	auipc	ra,0x0
    549a:	75e080e7          	jalr	1886(ra) # 5bf4 <printf>
    exit(1);
    549e:	4505                	li	a0,1
    54a0:	00000097          	auipc	ra,0x0
    54a4:	3cc080e7          	jalr	972(ra) # 586c <exit>
          exit(1);
    54a8:	4505                	li	a0,1
    54aa:	00000097          	auipc	ra,0x0
    54ae:	3c2080e7          	jalr	962(ra) # 586c <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    54b2:	40aa05bb          	subw	a1,s4,a0
    54b6:	8562                	mv	a0,s8
    54b8:	00000097          	auipc	ra,0x0
    54bc:	73c080e7          	jalr	1852(ra) # 5bf4 <printf>
        if(continuous != 2)
    54c0:	096a8463          	beq	s5,s6,5548 <main+0x1ba>
          exit(1);
    54c4:	4505                	li	a0,1
    54c6:	00000097          	auipc	ra,0x0
    54ca:	3a6080e7          	jalr	934(ra) # 586c <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    54ce:	04c1                	addi	s1,s1,16
    54d0:	6488                	ld	a0,8(s1)
    54d2:	c115                	beqz	a0,54f6 <main+0x168>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    54d4:	00090863          	beqz	s2,54e4 <main+0x156>
    54d8:	85ca                	mv	a1,s2
    54da:	00000097          	auipc	ra,0x0
    54de:	122080e7          	jalr	290(ra) # 55fc <strcmp>
    54e2:	f575                	bnez	a0,54ce <main+0x140>
      if(!run(t->f, t->s))
    54e4:	648c                	ld	a1,8(s1)
    54e6:	6088                	ld	a0,0(s1)
    54e8:	00000097          	auipc	ra,0x0
    54ec:	e08080e7          	jalr	-504(ra) # 52f0 <run>
    54f0:	fd79                	bnez	a0,54ce <main+0x140>
        fail = 1;
    54f2:	89d6                	mv	s3,s5
    54f4:	bfe9                	j	54ce <main+0x140>
  if(fail){
    54f6:	f20988e3          	beqz	s3,5426 <main+0x98>
    printf("SOME TESTS FAILED\n");
    54fa:	00003517          	auipc	a0,0x3
    54fe:	bc650513          	addi	a0,a0,-1082 # 80c0 <malloc+0x240e>
    5502:	00000097          	auipc	ra,0x0
    5506:	6f2080e7          	jalr	1778(ra) # 5bf4 <printf>
    exit(1);
    550a:	4505                	li	a0,1
    550c:	00000097          	auipc	ra,0x0
    5510:	360080e7          	jalr	864(ra) # 586c <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    5514:	00003517          	auipc	a0,0x3
    5518:	bf450513          	addi	a0,a0,-1036 # 8108 <malloc+0x2456>
    551c:	00000097          	auipc	ra,0x0
    5520:	6d8080e7          	jalr	1752(ra) # 5bf4 <printf>
    exit(0);
    5524:	4501                	li	a0,0
    5526:	00000097          	auipc	ra,0x0
    552a:	346080e7          	jalr	838(ra) # 586c <exit>
        printf("SOME TESTS FAILED\n");
    552e:	855e                	mv	a0,s7
    5530:	00000097          	auipc	ra,0x0
    5534:	6c4080e7          	jalr	1732(ra) # 5bf4 <printf>
        if(continuous != 2)
    5538:	f76a98e3          	bne	s5,s6,54a8 <main+0x11a>
      int free1 = countfree();
    553c:	00000097          	auipc	ra,0x0
    5540:	c82080e7          	jalr	-894(ra) # 51be <countfree>
      if(free1 < free0){
    5544:	f74547e3          	blt	a0,s4,54b2 <main+0x124>
      int free0 = countfree();
    5548:	00000097          	auipc	ra,0x0
    554c:	c76080e7          	jalr	-906(ra) # 51be <countfree>
    5550:	8a2a                	mv	s4,a0
      for (struct test *t = tests; t->s != 0; t++) {
    5552:	bd843483          	ld	s1,-1064(s0)
    5556:	d0fd                	beqz	s1,553c <main+0x1ae>
    5558:	bd040913          	addi	s2,s0,-1072
        if(!run(t->f, t->s)){
    555c:	85a6                	mv	a1,s1
    555e:	00093503          	ld	a0,0(s2)
    5562:	00000097          	auipc	ra,0x0
    5566:	d8e080e7          	jalr	-626(ra) # 52f0 <run>
    556a:	d171                	beqz	a0,552e <main+0x1a0>
        printf("%s ok\n",t->s);
    556c:	85a6                	mv	a1,s1
    556e:	854e                	mv	a0,s3
    5570:	00000097          	auipc	ra,0x0
    5574:	684080e7          	jalr	1668(ra) # 5bf4 <printf>
      for (struct test *t = tests; t->s != 0; t++) {
    5578:	0941                	addi	s2,s2,16
    557a:	00893483          	ld	s1,8(s2)
    557e:	fcf9                	bnez	s1,555c <main+0x1ce>
    5580:	bf75                	j	553c <main+0x1ae>
    continuous = 1;
    5582:	4a85                	li	s5,1
  } tests[] = {
    5584:	00003797          	auipc	a5,0x3
    5588:	bfc78793          	addi	a5,a5,-1028 # 8180 <malloc+0x24ce>
    558c:	bd040713          	addi	a4,s0,-1072
    5590:	00003817          	auipc	a6,0x3
    5594:	fd080813          	addi	a6,a6,-48 # 8560 <malloc+0x28ae>
    5598:	6388                	ld	a0,0(a5)
    559a:	678c                	ld	a1,8(a5)
    559c:	6b90                	ld	a2,16(a5)
    559e:	6f94                	ld	a3,24(a5)
    55a0:	e308                	sd	a0,0(a4)
    55a2:	e70c                	sd	a1,8(a4)
    55a4:	eb10                	sd	a2,16(a4)
    55a6:	ef14                	sd	a3,24(a4)
    55a8:	02078793          	addi	a5,a5,32
    55ac:	02070713          	addi	a4,a4,32
    55b0:	ff0794e3          	bne	a5,a6,5598 <main+0x20a>
    printf("continuous usertests starting\n");
    55b4:	00003517          	auipc	a0,0x3
    55b8:	b8450513          	addi	a0,a0,-1148 # 8138 <malloc+0x2486>
    55bc:	00000097          	auipc	ra,0x0
    55c0:	638080e7          	jalr	1592(ra) # 5bf4 <printf>
        printf("SOME TESTS FAILED\n");
    55c4:	00003b97          	auipc	s7,0x3
    55c8:	afcb8b93          	addi	s7,s7,-1284 # 80c0 <malloc+0x240e>
        if(continuous != 2)
    55cc:	4b09                	li	s6,2
        printf("%s ok\n",t->s);
    55ce:	00003997          	auipc	s3,0x3
    55d2:	aca98993          	addi	s3,s3,-1334 # 8098 <malloc+0x23e6>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    55d6:	00003c17          	auipc	s8,0x3
    55da:	acac0c13          	addi	s8,s8,-1334 # 80a0 <malloc+0x23ee>
    55de:	b7ad                	j	5548 <main+0x1ba>

00000000000055e0 <strcpy>:



char*
strcpy(char *s, const char *t)
{
    55e0:	1141                	addi	sp,sp,-16
    55e2:	e422                	sd	s0,8(sp)
    55e4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    55e6:	87aa                	mv	a5,a0
    55e8:	0585                	addi	a1,a1,1
    55ea:	0785                	addi	a5,a5,1
    55ec:	fff5c703          	lbu	a4,-1(a1)
    55f0:	fee78fa3          	sb	a4,-1(a5)
    55f4:	fb75                	bnez	a4,55e8 <strcpy+0x8>
    ;
  return os;
}
    55f6:	6422                	ld	s0,8(sp)
    55f8:	0141                	addi	sp,sp,16
    55fa:	8082                	ret

00000000000055fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
    55fc:	1141                	addi	sp,sp,-16
    55fe:	e422                	sd	s0,8(sp)
    5600:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5602:	00054783          	lbu	a5,0(a0)
    5606:	cb91                	beqz	a5,561a <strcmp+0x1e>
    5608:	0005c703          	lbu	a4,0(a1)
    560c:	00f71763          	bne	a4,a5,561a <strcmp+0x1e>
    p++, q++;
    5610:	0505                	addi	a0,a0,1
    5612:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5614:	00054783          	lbu	a5,0(a0)
    5618:	fbe5                	bnez	a5,5608 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    561a:	0005c503          	lbu	a0,0(a1)
}
    561e:	40a7853b          	subw	a0,a5,a0
    5622:	6422                	ld	s0,8(sp)
    5624:	0141                	addi	sp,sp,16
    5626:	8082                	ret

0000000000005628 <strlen>:

uint
strlen(const char *s)
{
    5628:	1141                	addi	sp,sp,-16
    562a:	e422                	sd	s0,8(sp)
    562c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    562e:	00054783          	lbu	a5,0(a0)
    5632:	cf91                	beqz	a5,564e <strlen+0x26>
    5634:	0505                	addi	a0,a0,1
    5636:	87aa                	mv	a5,a0
    5638:	4685                	li	a3,1
    563a:	9e89                	subw	a3,a3,a0
    563c:	00f6853b          	addw	a0,a3,a5
    5640:	0785                	addi	a5,a5,1
    5642:	fff7c703          	lbu	a4,-1(a5)
    5646:	fb7d                	bnez	a4,563c <strlen+0x14>
    ;
  return n;
}
    5648:	6422                	ld	s0,8(sp)
    564a:	0141                	addi	sp,sp,16
    564c:	8082                	ret
  for(n = 0; s[n]; n++)
    564e:	4501                	li	a0,0
    5650:	bfe5                	j	5648 <strlen+0x20>

0000000000005652 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5652:	1141                	addi	sp,sp,-16
    5654:	e422                	sd	s0,8(sp)
    5656:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5658:	ce09                	beqz	a2,5672 <memset+0x20>
    565a:	87aa                	mv	a5,a0
    565c:	fff6071b          	addiw	a4,a2,-1
    5660:	1702                	slli	a4,a4,0x20
    5662:	9301                	srli	a4,a4,0x20
    5664:	0705                	addi	a4,a4,1
    5666:	972a                	add	a4,a4,a0
    cdst[i] = c;
    5668:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    566c:	0785                	addi	a5,a5,1
    566e:	fee79de3          	bne	a5,a4,5668 <memset+0x16>
  }
  return dst;
}
    5672:	6422                	ld	s0,8(sp)
    5674:	0141                	addi	sp,sp,16
    5676:	8082                	ret

0000000000005678 <strchr>:

char*
strchr(const char *s, char c)
{
    5678:	1141                	addi	sp,sp,-16
    567a:	e422                	sd	s0,8(sp)
    567c:	0800                	addi	s0,sp,16
  for(; *s; s++)
    567e:	00054783          	lbu	a5,0(a0)
    5682:	cb99                	beqz	a5,5698 <strchr+0x20>
    if(*s == c)
    5684:	00f58763          	beq	a1,a5,5692 <strchr+0x1a>
  for(; *s; s++)
    5688:	0505                	addi	a0,a0,1
    568a:	00054783          	lbu	a5,0(a0)
    568e:	fbfd                	bnez	a5,5684 <strchr+0xc>
      return (char*)s;
  return 0;
    5690:	4501                	li	a0,0
}
    5692:	6422                	ld	s0,8(sp)
    5694:	0141                	addi	sp,sp,16
    5696:	8082                	ret
  return 0;
    5698:	4501                	li	a0,0
    569a:	bfe5                	j	5692 <strchr+0x1a>

000000000000569c <gets>:

char*
gets(char *buf, int max)
{
    569c:	711d                	addi	sp,sp,-96
    569e:	ec86                	sd	ra,88(sp)
    56a0:	e8a2                	sd	s0,80(sp)
    56a2:	e4a6                	sd	s1,72(sp)
    56a4:	e0ca                	sd	s2,64(sp)
    56a6:	fc4e                	sd	s3,56(sp)
    56a8:	f852                	sd	s4,48(sp)
    56aa:	f456                	sd	s5,40(sp)
    56ac:	f05a                	sd	s6,32(sp)
    56ae:	ec5e                	sd	s7,24(sp)
    56b0:	1080                	addi	s0,sp,96
    56b2:	8baa                	mv	s7,a0
    56b4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    56b6:	892a                	mv	s2,a0
    56b8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    56ba:	4aa9                	li	s5,10
    56bc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    56be:	89a6                	mv	s3,s1
    56c0:	2485                	addiw	s1,s1,1
    56c2:	0344d863          	bge	s1,s4,56f2 <gets+0x56>
    cc = read(0, &c, 1);
    56c6:	4605                	li	a2,1
    56c8:	faf40593          	addi	a1,s0,-81
    56cc:	4501                	li	a0,0
    56ce:	00000097          	auipc	ra,0x0
    56d2:	1b6080e7          	jalr	438(ra) # 5884 <read>
    if(cc < 1)
    56d6:	00a05e63          	blez	a0,56f2 <gets+0x56>
    buf[i++] = c;
    56da:	faf44783          	lbu	a5,-81(s0)
    56de:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    56e2:	01578763          	beq	a5,s5,56f0 <gets+0x54>
    56e6:	0905                	addi	s2,s2,1
    56e8:	fd679be3          	bne	a5,s6,56be <gets+0x22>
  for(i=0; i+1 < max; ){
    56ec:	89a6                	mv	s3,s1
    56ee:	a011                	j	56f2 <gets+0x56>
    56f0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    56f2:	99de                	add	s3,s3,s7
    56f4:	00098023          	sb	zero,0(s3)
  return buf;
}
    56f8:	855e                	mv	a0,s7
    56fa:	60e6                	ld	ra,88(sp)
    56fc:	6446                	ld	s0,80(sp)
    56fe:	64a6                	ld	s1,72(sp)
    5700:	6906                	ld	s2,64(sp)
    5702:	79e2                	ld	s3,56(sp)
    5704:	7a42                	ld	s4,48(sp)
    5706:	7aa2                	ld	s5,40(sp)
    5708:	7b02                	ld	s6,32(sp)
    570a:	6be2                	ld	s7,24(sp)
    570c:	6125                	addi	sp,sp,96
    570e:	8082                	ret

0000000000005710 <stat>:

int
stat(const char *n, struct stat *st)
{
    5710:	1101                	addi	sp,sp,-32
    5712:	ec06                	sd	ra,24(sp)
    5714:	e822                	sd	s0,16(sp)
    5716:	e426                	sd	s1,8(sp)
    5718:	e04a                	sd	s2,0(sp)
    571a:	1000                	addi	s0,sp,32
    571c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    571e:	4581                	li	a1,0
    5720:	00000097          	auipc	ra,0x0
    5724:	18c080e7          	jalr	396(ra) # 58ac <open>
  if(fd < 0)
    5728:	02054563          	bltz	a0,5752 <stat+0x42>
    572c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    572e:	85ca                	mv	a1,s2
    5730:	00000097          	auipc	ra,0x0
    5734:	194080e7          	jalr	404(ra) # 58c4 <fstat>
    5738:	892a                	mv	s2,a0
  close(fd);
    573a:	8526                	mv	a0,s1
    573c:	00000097          	auipc	ra,0x0
    5740:	158080e7          	jalr	344(ra) # 5894 <close>
  return r;
}
    5744:	854a                	mv	a0,s2
    5746:	60e2                	ld	ra,24(sp)
    5748:	6442                	ld	s0,16(sp)
    574a:	64a2                	ld	s1,8(sp)
    574c:	6902                	ld	s2,0(sp)
    574e:	6105                	addi	sp,sp,32
    5750:	8082                	ret
    return -1;
    5752:	597d                	li	s2,-1
    5754:	bfc5                	j	5744 <stat+0x34>

0000000000005756 <atoi>:

int
atoi(const char *s)
{
    5756:	1141                	addi	sp,sp,-16
    5758:	e422                	sd	s0,8(sp)
    575a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    575c:	00054603          	lbu	a2,0(a0)
    5760:	fd06079b          	addiw	a5,a2,-48
    5764:	0ff7f793          	andi	a5,a5,255
    5768:	4725                	li	a4,9
    576a:	02f76963          	bltu	a4,a5,579c <atoi+0x46>
    576e:	86aa                	mv	a3,a0
  n = 0;
    5770:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    5772:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5774:	0685                	addi	a3,a3,1
    5776:	0025179b          	slliw	a5,a0,0x2
    577a:	9fa9                	addw	a5,a5,a0
    577c:	0017979b          	slliw	a5,a5,0x1
    5780:	9fb1                	addw	a5,a5,a2
    5782:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5786:	0006c603          	lbu	a2,0(a3) # 1000 <pgbug+0x30>
    578a:	fd06071b          	addiw	a4,a2,-48
    578e:	0ff77713          	andi	a4,a4,255
    5792:	fee5f1e3          	bgeu	a1,a4,5774 <atoi+0x1e>
  return n;
}
    5796:	6422                	ld	s0,8(sp)
    5798:	0141                	addi	sp,sp,16
    579a:	8082                	ret
  n = 0;
    579c:	4501                	li	a0,0
    579e:	bfe5                	j	5796 <atoi+0x40>

00000000000057a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    57a0:	1141                	addi	sp,sp,-16
    57a2:	e422                	sd	s0,8(sp)
    57a4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    57a6:	02b57663          	bgeu	a0,a1,57d2 <memmove+0x32>
    while(n-- > 0)
    57aa:	02c05163          	blez	a2,57cc <memmove+0x2c>
    57ae:	fff6079b          	addiw	a5,a2,-1
    57b2:	1782                	slli	a5,a5,0x20
    57b4:	9381                	srli	a5,a5,0x20
    57b6:	0785                	addi	a5,a5,1
    57b8:	97aa                	add	a5,a5,a0
  dst = vdst;
    57ba:	872a                	mv	a4,a0
      *dst++ = *src++;
    57bc:	0585                	addi	a1,a1,1
    57be:	0705                	addi	a4,a4,1
    57c0:	fff5c683          	lbu	a3,-1(a1)
    57c4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    57c8:	fee79ae3          	bne	a5,a4,57bc <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    57cc:	6422                	ld	s0,8(sp)
    57ce:	0141                	addi	sp,sp,16
    57d0:	8082                	ret
    dst += n;
    57d2:	00c50733          	add	a4,a0,a2
    src += n;
    57d6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    57d8:	fec05ae3          	blez	a2,57cc <memmove+0x2c>
    57dc:	fff6079b          	addiw	a5,a2,-1
    57e0:	1782                	slli	a5,a5,0x20
    57e2:	9381                	srli	a5,a5,0x20
    57e4:	fff7c793          	not	a5,a5
    57e8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    57ea:	15fd                	addi	a1,a1,-1
    57ec:	177d                	addi	a4,a4,-1
    57ee:	0005c683          	lbu	a3,0(a1)
    57f2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    57f6:	fee79ae3          	bne	a5,a4,57ea <memmove+0x4a>
    57fa:	bfc9                	j	57cc <memmove+0x2c>

00000000000057fc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    57fc:	1141                	addi	sp,sp,-16
    57fe:	e422                	sd	s0,8(sp)
    5800:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5802:	ca05                	beqz	a2,5832 <memcmp+0x36>
    5804:	fff6069b          	addiw	a3,a2,-1
    5808:	1682                	slli	a3,a3,0x20
    580a:	9281                	srli	a3,a3,0x20
    580c:	0685                	addi	a3,a3,1
    580e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5810:	00054783          	lbu	a5,0(a0)
    5814:	0005c703          	lbu	a4,0(a1)
    5818:	00e79863          	bne	a5,a4,5828 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    581c:	0505                	addi	a0,a0,1
    p2++;
    581e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5820:	fed518e3          	bne	a0,a3,5810 <memcmp+0x14>
  }
  return 0;
    5824:	4501                	li	a0,0
    5826:	a019                	j	582c <memcmp+0x30>
      return *p1 - *p2;
    5828:	40e7853b          	subw	a0,a5,a4
}
    582c:	6422                	ld	s0,8(sp)
    582e:	0141                	addi	sp,sp,16
    5830:	8082                	ret
  return 0;
    5832:	4501                	li	a0,0
    5834:	bfe5                	j	582c <memcmp+0x30>

0000000000005836 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5836:	1141                	addi	sp,sp,-16
    5838:	e406                	sd	ra,8(sp)
    583a:	e022                	sd	s0,0(sp)
    583c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    583e:	00000097          	auipc	ra,0x0
    5842:	f62080e7          	jalr	-158(ra) # 57a0 <memmove>
}
    5846:	60a2                	ld	ra,8(sp)
    5848:	6402                	ld	s0,0(sp)
    584a:	0141                	addi	sp,sp,16
    584c:	8082                	ret

000000000000584e <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
    584e:	1141                	addi	sp,sp,-16
    5850:	e422                	sd	s0,8(sp)
    5852:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
    5854:	040007b7          	lui	a5,0x4000
}
    5858:	17f5                	addi	a5,a5,-3
    585a:	07b2                	slli	a5,a5,0xc
    585c:	4388                	lw	a0,0(a5)
    585e:	6422                	ld	s0,8(sp)
    5860:	0141                	addi	sp,sp,16
    5862:	8082                	ret

0000000000005864 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5864:	4885                	li	a7,1
 ecall
    5866:	00000073          	ecall
 ret
    586a:	8082                	ret

000000000000586c <exit>:
.global exit
exit:
 li a7, SYS_exit
    586c:	4889                	li	a7,2
 ecall
    586e:	00000073          	ecall
 ret
    5872:	8082                	ret

0000000000005874 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5874:	488d                	li	a7,3
 ecall
    5876:	00000073          	ecall
 ret
    587a:	8082                	ret

000000000000587c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    587c:	4891                	li	a7,4
 ecall
    587e:	00000073          	ecall
 ret
    5882:	8082                	ret

0000000000005884 <read>:
.global read
read:
 li a7, SYS_read
    5884:	4895                	li	a7,5
 ecall
    5886:	00000073          	ecall
 ret
    588a:	8082                	ret

000000000000588c <write>:
.global write
write:
 li a7, SYS_write
    588c:	48c1                	li	a7,16
 ecall
    588e:	00000073          	ecall
 ret
    5892:	8082                	ret

0000000000005894 <close>:
.global close
close:
 li a7, SYS_close
    5894:	48d5                	li	a7,21
 ecall
    5896:	00000073          	ecall
 ret
    589a:	8082                	ret

000000000000589c <kill>:
.global kill
kill:
 li a7, SYS_kill
    589c:	4899                	li	a7,6
 ecall
    589e:	00000073          	ecall
 ret
    58a2:	8082                	ret

00000000000058a4 <exec>:
.global exec
exec:
 li a7, SYS_exec
    58a4:	489d                	li	a7,7
 ecall
    58a6:	00000073          	ecall
 ret
    58aa:	8082                	ret

00000000000058ac <open>:
.global open
open:
 li a7, SYS_open
    58ac:	48bd                	li	a7,15
 ecall
    58ae:	00000073          	ecall
 ret
    58b2:	8082                	ret

00000000000058b4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    58b4:	48c5                	li	a7,17
 ecall
    58b6:	00000073          	ecall
 ret
    58ba:	8082                	ret

00000000000058bc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    58bc:	48c9                	li	a7,18
 ecall
    58be:	00000073          	ecall
 ret
    58c2:	8082                	ret

00000000000058c4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    58c4:	48a1                	li	a7,8
 ecall
    58c6:	00000073          	ecall
 ret
    58ca:	8082                	ret

00000000000058cc <link>:
.global link
link:
 li a7, SYS_link
    58cc:	48cd                	li	a7,19
 ecall
    58ce:	00000073          	ecall
 ret
    58d2:	8082                	ret

00000000000058d4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    58d4:	48d1                	li	a7,20
 ecall
    58d6:	00000073          	ecall
 ret
    58da:	8082                	ret

00000000000058dc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    58dc:	48a5                	li	a7,9
 ecall
    58de:	00000073          	ecall
 ret
    58e2:	8082                	ret

00000000000058e4 <dup>:
.global dup
dup:
 li a7, SYS_dup
    58e4:	48a9                	li	a7,10
 ecall
    58e6:	00000073          	ecall
 ret
    58ea:	8082                	ret

00000000000058ec <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    58ec:	48ad                	li	a7,11
 ecall
    58ee:	00000073          	ecall
 ret
    58f2:	8082                	ret

00000000000058f4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    58f4:	48b1                	li	a7,12
 ecall
    58f6:	00000073          	ecall
 ret
    58fa:	8082                	ret

00000000000058fc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    58fc:	48b5                	li	a7,13
 ecall
    58fe:	00000073          	ecall
 ret
    5902:	8082                	ret

0000000000005904 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5904:	48b9                	li	a7,14
 ecall
    5906:	00000073          	ecall
 ret
    590a:	8082                	ret

000000000000590c <connect>:
.global connect
connect:
 li a7, SYS_connect
    590c:	48f5                	li	a7,29
 ecall
    590e:	00000073          	ecall
 ret
    5912:	8082                	ret

0000000000005914 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
    5914:	48f9                	li	a7,30
 ecall
    5916:	00000073          	ecall
 ret
    591a:	8082                	ret

000000000000591c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    591c:	1101                	addi	sp,sp,-32
    591e:	ec06                	sd	ra,24(sp)
    5920:	e822                	sd	s0,16(sp)
    5922:	1000                	addi	s0,sp,32
    5924:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5928:	4605                	li	a2,1
    592a:	fef40593          	addi	a1,s0,-17
    592e:	00000097          	auipc	ra,0x0
    5932:	f5e080e7          	jalr	-162(ra) # 588c <write>
}
    5936:	60e2                	ld	ra,24(sp)
    5938:	6442                	ld	s0,16(sp)
    593a:	6105                	addi	sp,sp,32
    593c:	8082                	ret

000000000000593e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    593e:	7139                	addi	sp,sp,-64
    5940:	fc06                	sd	ra,56(sp)
    5942:	f822                	sd	s0,48(sp)
    5944:	f426                	sd	s1,40(sp)
    5946:	f04a                	sd	s2,32(sp)
    5948:	ec4e                	sd	s3,24(sp)
    594a:	0080                	addi	s0,sp,64
    594c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    594e:	c299                	beqz	a3,5954 <printint+0x16>
    5950:	0805c863          	bltz	a1,59e0 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5954:	2581                	sext.w	a1,a1
  neg = 0;
    5956:	4881                	li	a7,0
    5958:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    595c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    595e:	2601                	sext.w	a2,a2
    5960:	00003517          	auipc	a0,0x3
    5964:	c0850513          	addi	a0,a0,-1016 # 8568 <digits>
    5968:	883a                	mv	a6,a4
    596a:	2705                	addiw	a4,a4,1
    596c:	02c5f7bb          	remuw	a5,a1,a2
    5970:	1782                	slli	a5,a5,0x20
    5972:	9381                	srli	a5,a5,0x20
    5974:	97aa                	add	a5,a5,a0
    5976:	0007c783          	lbu	a5,0(a5) # 4000000 <__BSS_END__+0x3ff1248>
    597a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    597e:	0005879b          	sext.w	a5,a1
    5982:	02c5d5bb          	divuw	a1,a1,a2
    5986:	0685                	addi	a3,a3,1
    5988:	fec7f0e3          	bgeu	a5,a2,5968 <printint+0x2a>
  if(neg)
    598c:	00088b63          	beqz	a7,59a2 <printint+0x64>
    buf[i++] = '-';
    5990:	fd040793          	addi	a5,s0,-48
    5994:	973e                	add	a4,a4,a5
    5996:	02d00793          	li	a5,45
    599a:	fef70823          	sb	a5,-16(a4)
    599e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    59a2:	02e05863          	blez	a4,59d2 <printint+0x94>
    59a6:	fc040793          	addi	a5,s0,-64
    59aa:	00e78933          	add	s2,a5,a4
    59ae:	fff78993          	addi	s3,a5,-1
    59b2:	99ba                	add	s3,s3,a4
    59b4:	377d                	addiw	a4,a4,-1
    59b6:	1702                	slli	a4,a4,0x20
    59b8:	9301                	srli	a4,a4,0x20
    59ba:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    59be:	fff94583          	lbu	a1,-1(s2)
    59c2:	8526                	mv	a0,s1
    59c4:	00000097          	auipc	ra,0x0
    59c8:	f58080e7          	jalr	-168(ra) # 591c <putc>
  while(--i >= 0)
    59cc:	197d                	addi	s2,s2,-1
    59ce:	ff3918e3          	bne	s2,s3,59be <printint+0x80>
}
    59d2:	70e2                	ld	ra,56(sp)
    59d4:	7442                	ld	s0,48(sp)
    59d6:	74a2                	ld	s1,40(sp)
    59d8:	7902                	ld	s2,32(sp)
    59da:	69e2                	ld	s3,24(sp)
    59dc:	6121                	addi	sp,sp,64
    59de:	8082                	ret
    x = -xx;
    59e0:	40b005bb          	negw	a1,a1
    neg = 1;
    59e4:	4885                	li	a7,1
    x = -xx;
    59e6:	bf8d                	j	5958 <printint+0x1a>

00000000000059e8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    59e8:	7119                	addi	sp,sp,-128
    59ea:	fc86                	sd	ra,120(sp)
    59ec:	f8a2                	sd	s0,112(sp)
    59ee:	f4a6                	sd	s1,104(sp)
    59f0:	f0ca                	sd	s2,96(sp)
    59f2:	ecce                	sd	s3,88(sp)
    59f4:	e8d2                	sd	s4,80(sp)
    59f6:	e4d6                	sd	s5,72(sp)
    59f8:	e0da                	sd	s6,64(sp)
    59fa:	fc5e                	sd	s7,56(sp)
    59fc:	f862                	sd	s8,48(sp)
    59fe:	f466                	sd	s9,40(sp)
    5a00:	f06a                	sd	s10,32(sp)
    5a02:	ec6e                	sd	s11,24(sp)
    5a04:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5a06:	0005c903          	lbu	s2,0(a1)
    5a0a:	18090f63          	beqz	s2,5ba8 <vprintf+0x1c0>
    5a0e:	8aaa                	mv	s5,a0
    5a10:	8b32                	mv	s6,a2
    5a12:	00158493          	addi	s1,a1,1
  state = 0;
    5a16:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5a18:	02500a13          	li	s4,37
      if(c == 'd'){
    5a1c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5a20:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5a24:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5a28:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5a2c:	00003b97          	auipc	s7,0x3
    5a30:	b3cb8b93          	addi	s7,s7,-1220 # 8568 <digits>
    5a34:	a839                	j	5a52 <vprintf+0x6a>
        putc(fd, c);
    5a36:	85ca                	mv	a1,s2
    5a38:	8556                	mv	a0,s5
    5a3a:	00000097          	auipc	ra,0x0
    5a3e:	ee2080e7          	jalr	-286(ra) # 591c <putc>
    5a42:	a019                	j	5a48 <vprintf+0x60>
    } else if(state == '%'){
    5a44:	01498f63          	beq	s3,s4,5a62 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5a48:	0485                	addi	s1,s1,1
    5a4a:	fff4c903          	lbu	s2,-1(s1)
    5a4e:	14090d63          	beqz	s2,5ba8 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5a52:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5a56:	fe0997e3          	bnez	s3,5a44 <vprintf+0x5c>
      if(c == '%'){
    5a5a:	fd479ee3          	bne	a5,s4,5a36 <vprintf+0x4e>
        state = '%';
    5a5e:	89be                	mv	s3,a5
    5a60:	b7e5                	j	5a48 <vprintf+0x60>
      if(c == 'd'){
    5a62:	05878063          	beq	a5,s8,5aa2 <vprintf+0xba>
      } else if(c == 'l') {
    5a66:	05978c63          	beq	a5,s9,5abe <vprintf+0xd6>
      } else if(c == 'x') {
    5a6a:	07a78863          	beq	a5,s10,5ada <vprintf+0xf2>
      } else if(c == 'p') {
    5a6e:	09b78463          	beq	a5,s11,5af6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    5a72:	07300713          	li	a4,115
    5a76:	0ce78663          	beq	a5,a4,5b42 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5a7a:	06300713          	li	a4,99
    5a7e:	0ee78e63          	beq	a5,a4,5b7a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5a82:	11478863          	beq	a5,s4,5b92 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5a86:	85d2                	mv	a1,s4
    5a88:	8556                	mv	a0,s5
    5a8a:	00000097          	auipc	ra,0x0
    5a8e:	e92080e7          	jalr	-366(ra) # 591c <putc>
        putc(fd, c);
    5a92:	85ca                	mv	a1,s2
    5a94:	8556                	mv	a0,s5
    5a96:	00000097          	auipc	ra,0x0
    5a9a:	e86080e7          	jalr	-378(ra) # 591c <putc>
      }
      state = 0;
    5a9e:	4981                	li	s3,0
    5aa0:	b765                	j	5a48 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5aa2:	008b0913          	addi	s2,s6,8
    5aa6:	4685                	li	a3,1
    5aa8:	4629                	li	a2,10
    5aaa:	000b2583          	lw	a1,0(s6)
    5aae:	8556                	mv	a0,s5
    5ab0:	00000097          	auipc	ra,0x0
    5ab4:	e8e080e7          	jalr	-370(ra) # 593e <printint>
    5ab8:	8b4a                	mv	s6,s2
      state = 0;
    5aba:	4981                	li	s3,0
    5abc:	b771                	j	5a48 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5abe:	008b0913          	addi	s2,s6,8
    5ac2:	4681                	li	a3,0
    5ac4:	4629                	li	a2,10
    5ac6:	000b2583          	lw	a1,0(s6)
    5aca:	8556                	mv	a0,s5
    5acc:	00000097          	auipc	ra,0x0
    5ad0:	e72080e7          	jalr	-398(ra) # 593e <printint>
    5ad4:	8b4a                	mv	s6,s2
      state = 0;
    5ad6:	4981                	li	s3,0
    5ad8:	bf85                	j	5a48 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5ada:	008b0913          	addi	s2,s6,8
    5ade:	4681                	li	a3,0
    5ae0:	4641                	li	a2,16
    5ae2:	000b2583          	lw	a1,0(s6)
    5ae6:	8556                	mv	a0,s5
    5ae8:	00000097          	auipc	ra,0x0
    5aec:	e56080e7          	jalr	-426(ra) # 593e <printint>
    5af0:	8b4a                	mv	s6,s2
      state = 0;
    5af2:	4981                	li	s3,0
    5af4:	bf91                	j	5a48 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5af6:	008b0793          	addi	a5,s6,8
    5afa:	f8f43423          	sd	a5,-120(s0)
    5afe:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5b02:	03000593          	li	a1,48
    5b06:	8556                	mv	a0,s5
    5b08:	00000097          	auipc	ra,0x0
    5b0c:	e14080e7          	jalr	-492(ra) # 591c <putc>
  putc(fd, 'x');
    5b10:	85ea                	mv	a1,s10
    5b12:	8556                	mv	a0,s5
    5b14:	00000097          	auipc	ra,0x0
    5b18:	e08080e7          	jalr	-504(ra) # 591c <putc>
    5b1c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5b1e:	03c9d793          	srli	a5,s3,0x3c
    5b22:	97de                	add	a5,a5,s7
    5b24:	0007c583          	lbu	a1,0(a5)
    5b28:	8556                	mv	a0,s5
    5b2a:	00000097          	auipc	ra,0x0
    5b2e:	df2080e7          	jalr	-526(ra) # 591c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5b32:	0992                	slli	s3,s3,0x4
    5b34:	397d                	addiw	s2,s2,-1
    5b36:	fe0914e3          	bnez	s2,5b1e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5b3a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5b3e:	4981                	li	s3,0
    5b40:	b721                	j	5a48 <vprintf+0x60>
        s = va_arg(ap, char*);
    5b42:	008b0993          	addi	s3,s6,8
    5b46:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5b4a:	02090163          	beqz	s2,5b6c <vprintf+0x184>
        while(*s != 0){
    5b4e:	00094583          	lbu	a1,0(s2)
    5b52:	c9a1                	beqz	a1,5ba2 <vprintf+0x1ba>
          putc(fd, *s);
    5b54:	8556                	mv	a0,s5
    5b56:	00000097          	auipc	ra,0x0
    5b5a:	dc6080e7          	jalr	-570(ra) # 591c <putc>
          s++;
    5b5e:	0905                	addi	s2,s2,1
        while(*s != 0){
    5b60:	00094583          	lbu	a1,0(s2)
    5b64:	f9e5                	bnez	a1,5b54 <vprintf+0x16c>
        s = va_arg(ap, char*);
    5b66:	8b4e                	mv	s6,s3
      state = 0;
    5b68:	4981                	li	s3,0
    5b6a:	bdf9                	j	5a48 <vprintf+0x60>
          s = "(null)";
    5b6c:	00003917          	auipc	s2,0x3
    5b70:	9f490913          	addi	s2,s2,-1548 # 8560 <malloc+0x28ae>
        while(*s != 0){
    5b74:	02800593          	li	a1,40
    5b78:	bff1                	j	5b54 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5b7a:	008b0913          	addi	s2,s6,8
    5b7e:	000b4583          	lbu	a1,0(s6)
    5b82:	8556                	mv	a0,s5
    5b84:	00000097          	auipc	ra,0x0
    5b88:	d98080e7          	jalr	-616(ra) # 591c <putc>
    5b8c:	8b4a                	mv	s6,s2
      state = 0;
    5b8e:	4981                	li	s3,0
    5b90:	bd65                	j	5a48 <vprintf+0x60>
        putc(fd, c);
    5b92:	85d2                	mv	a1,s4
    5b94:	8556                	mv	a0,s5
    5b96:	00000097          	auipc	ra,0x0
    5b9a:	d86080e7          	jalr	-634(ra) # 591c <putc>
      state = 0;
    5b9e:	4981                	li	s3,0
    5ba0:	b565                	j	5a48 <vprintf+0x60>
        s = va_arg(ap, char*);
    5ba2:	8b4e                	mv	s6,s3
      state = 0;
    5ba4:	4981                	li	s3,0
    5ba6:	b54d                	j	5a48 <vprintf+0x60>
    }
  }
}
    5ba8:	70e6                	ld	ra,120(sp)
    5baa:	7446                	ld	s0,112(sp)
    5bac:	74a6                	ld	s1,104(sp)
    5bae:	7906                	ld	s2,96(sp)
    5bb0:	69e6                	ld	s3,88(sp)
    5bb2:	6a46                	ld	s4,80(sp)
    5bb4:	6aa6                	ld	s5,72(sp)
    5bb6:	6b06                	ld	s6,64(sp)
    5bb8:	7be2                	ld	s7,56(sp)
    5bba:	7c42                	ld	s8,48(sp)
    5bbc:	7ca2                	ld	s9,40(sp)
    5bbe:	7d02                	ld	s10,32(sp)
    5bc0:	6de2                	ld	s11,24(sp)
    5bc2:	6109                	addi	sp,sp,128
    5bc4:	8082                	ret

0000000000005bc6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5bc6:	715d                	addi	sp,sp,-80
    5bc8:	ec06                	sd	ra,24(sp)
    5bca:	e822                	sd	s0,16(sp)
    5bcc:	1000                	addi	s0,sp,32
    5bce:	e010                	sd	a2,0(s0)
    5bd0:	e414                	sd	a3,8(s0)
    5bd2:	e818                	sd	a4,16(s0)
    5bd4:	ec1c                	sd	a5,24(s0)
    5bd6:	03043023          	sd	a6,32(s0)
    5bda:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5bde:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5be2:	8622                	mv	a2,s0
    5be4:	00000097          	auipc	ra,0x0
    5be8:	e04080e7          	jalr	-508(ra) # 59e8 <vprintf>
}
    5bec:	60e2                	ld	ra,24(sp)
    5bee:	6442                	ld	s0,16(sp)
    5bf0:	6161                	addi	sp,sp,80
    5bf2:	8082                	ret

0000000000005bf4 <printf>:

void
printf(const char *fmt, ...)
{
    5bf4:	711d                	addi	sp,sp,-96
    5bf6:	ec06                	sd	ra,24(sp)
    5bf8:	e822                	sd	s0,16(sp)
    5bfa:	1000                	addi	s0,sp,32
    5bfc:	e40c                	sd	a1,8(s0)
    5bfe:	e810                	sd	a2,16(s0)
    5c00:	ec14                	sd	a3,24(s0)
    5c02:	f018                	sd	a4,32(s0)
    5c04:	f41c                	sd	a5,40(s0)
    5c06:	03043823          	sd	a6,48(s0)
    5c0a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5c0e:	00840613          	addi	a2,s0,8
    5c12:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5c16:	85aa                	mv	a1,a0
    5c18:	4505                	li	a0,1
    5c1a:	00000097          	auipc	ra,0x0
    5c1e:	dce080e7          	jalr	-562(ra) # 59e8 <vprintf>
}
    5c22:	60e2                	ld	ra,24(sp)
    5c24:	6442                	ld	s0,16(sp)
    5c26:	6125                	addi	sp,sp,96
    5c28:	8082                	ret

0000000000005c2a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5c2a:	1141                	addi	sp,sp,-16
    5c2c:	e422                	sd	s0,8(sp)
    5c2e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5c30:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5c34:	00003797          	auipc	a5,0x3
    5c38:	9547b783          	ld	a5,-1708(a5) # 8588 <freep>
    5c3c:	a805                	j	5c6c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5c3e:	4618                	lw	a4,8(a2)
    5c40:	9db9                	addw	a1,a1,a4
    5c42:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5c46:	6398                	ld	a4,0(a5)
    5c48:	6318                	ld	a4,0(a4)
    5c4a:	fee53823          	sd	a4,-16(a0)
    5c4e:	a091                	j	5c92 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5c50:	ff852703          	lw	a4,-8(a0)
    5c54:	9e39                	addw	a2,a2,a4
    5c56:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5c58:	ff053703          	ld	a4,-16(a0)
    5c5c:	e398                	sd	a4,0(a5)
    5c5e:	a099                	j	5ca4 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5c60:	6398                	ld	a4,0(a5)
    5c62:	00e7e463          	bltu	a5,a4,5c6a <free+0x40>
    5c66:	00e6ea63          	bltu	a3,a4,5c7a <free+0x50>
{
    5c6a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5c6c:	fed7fae3          	bgeu	a5,a3,5c60 <free+0x36>
    5c70:	6398                	ld	a4,0(a5)
    5c72:	00e6e463          	bltu	a3,a4,5c7a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5c76:	fee7eae3          	bltu	a5,a4,5c6a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5c7a:	ff852583          	lw	a1,-8(a0)
    5c7e:	6390                	ld	a2,0(a5)
    5c80:	02059713          	slli	a4,a1,0x20
    5c84:	9301                	srli	a4,a4,0x20
    5c86:	0712                	slli	a4,a4,0x4
    5c88:	9736                	add	a4,a4,a3
    5c8a:	fae60ae3          	beq	a2,a4,5c3e <free+0x14>
    bp->s.ptr = p->s.ptr;
    5c8e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5c92:	4790                	lw	a2,8(a5)
    5c94:	02061713          	slli	a4,a2,0x20
    5c98:	9301                	srli	a4,a4,0x20
    5c9a:	0712                	slli	a4,a4,0x4
    5c9c:	973e                	add	a4,a4,a5
    5c9e:	fae689e3          	beq	a3,a4,5c50 <free+0x26>
  } else
    p->s.ptr = bp;
    5ca2:	e394                	sd	a3,0(a5)
  freep = p;
    5ca4:	00003717          	auipc	a4,0x3
    5ca8:	8ef73223          	sd	a5,-1820(a4) # 8588 <freep>
}
    5cac:	6422                	ld	s0,8(sp)
    5cae:	0141                	addi	sp,sp,16
    5cb0:	8082                	ret

0000000000005cb2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5cb2:	7139                	addi	sp,sp,-64
    5cb4:	fc06                	sd	ra,56(sp)
    5cb6:	f822                	sd	s0,48(sp)
    5cb8:	f426                	sd	s1,40(sp)
    5cba:	f04a                	sd	s2,32(sp)
    5cbc:	ec4e                	sd	s3,24(sp)
    5cbe:	e852                	sd	s4,16(sp)
    5cc0:	e456                	sd	s5,8(sp)
    5cc2:	e05a                	sd	s6,0(sp)
    5cc4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5cc6:	02051493          	slli	s1,a0,0x20
    5cca:	9081                	srli	s1,s1,0x20
    5ccc:	04bd                	addi	s1,s1,15
    5cce:	8091                	srli	s1,s1,0x4
    5cd0:	0014899b          	addiw	s3,s1,1
    5cd4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5cd6:	00003517          	auipc	a0,0x3
    5cda:	8b253503          	ld	a0,-1870(a0) # 8588 <freep>
    5cde:	c515                	beqz	a0,5d0a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5ce0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5ce2:	4798                	lw	a4,8(a5)
    5ce4:	02977f63          	bgeu	a4,s1,5d22 <malloc+0x70>
    5ce8:	8a4e                	mv	s4,s3
    5cea:	0009871b          	sext.w	a4,s3
    5cee:	6685                	lui	a3,0x1
    5cf0:	00d77363          	bgeu	a4,a3,5cf6 <malloc+0x44>
    5cf4:	6a05                	lui	s4,0x1
    5cf6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5cfa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5cfe:	00003917          	auipc	s2,0x3
    5d02:	88a90913          	addi	s2,s2,-1910 # 8588 <freep>
  if(p == (char*)-1)
    5d06:	5afd                	li	s5,-1
    5d08:	a88d                	j	5d7a <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    5d0a:	00009797          	auipc	a5,0x9
    5d0e:	09e78793          	addi	a5,a5,158 # eda8 <base>
    5d12:	00003717          	auipc	a4,0x3
    5d16:	86f73b23          	sd	a5,-1930(a4) # 8588 <freep>
    5d1a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5d1c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5d20:	b7e1                	j	5ce8 <malloc+0x36>
      if(p->s.size == nunits)
    5d22:	02e48b63          	beq	s1,a4,5d58 <malloc+0xa6>
        p->s.size -= nunits;
    5d26:	4137073b          	subw	a4,a4,s3
    5d2a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5d2c:	1702                	slli	a4,a4,0x20
    5d2e:	9301                	srli	a4,a4,0x20
    5d30:	0712                	slli	a4,a4,0x4
    5d32:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5d34:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5d38:	00003717          	auipc	a4,0x3
    5d3c:	84a73823          	sd	a0,-1968(a4) # 8588 <freep>
      return (void*)(p + 1);
    5d40:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5d44:	70e2                	ld	ra,56(sp)
    5d46:	7442                	ld	s0,48(sp)
    5d48:	74a2                	ld	s1,40(sp)
    5d4a:	7902                	ld	s2,32(sp)
    5d4c:	69e2                	ld	s3,24(sp)
    5d4e:	6a42                	ld	s4,16(sp)
    5d50:	6aa2                	ld	s5,8(sp)
    5d52:	6b02                	ld	s6,0(sp)
    5d54:	6121                	addi	sp,sp,64
    5d56:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5d58:	6398                	ld	a4,0(a5)
    5d5a:	e118                	sd	a4,0(a0)
    5d5c:	bff1                	j	5d38 <malloc+0x86>
  hp->s.size = nu;
    5d5e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5d62:	0541                	addi	a0,a0,16
    5d64:	00000097          	auipc	ra,0x0
    5d68:	ec6080e7          	jalr	-314(ra) # 5c2a <free>
  return freep;
    5d6c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5d70:	d971                	beqz	a0,5d44 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5d72:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5d74:	4798                	lw	a4,8(a5)
    5d76:	fa9776e3          	bgeu	a4,s1,5d22 <malloc+0x70>
    if(p == freep)
    5d7a:	00093703          	ld	a4,0(s2)
    5d7e:	853e                	mv	a0,a5
    5d80:	fef719e3          	bne	a4,a5,5d72 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    5d84:	8552                	mv	a0,s4
    5d86:	00000097          	auipc	ra,0x0
    5d8a:	b6e080e7          	jalr	-1170(ra) # 58f4 <sbrk>
  if(p == (char*)-1)
    5d8e:	fd5518e3          	bne	a0,s5,5d5e <malloc+0xac>
        return 0;
    5d92:	4501                	li	a0,0
    5d94:	bf45                	j	5d44 <malloc+0x92>
