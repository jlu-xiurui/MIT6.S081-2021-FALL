
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
      14:	89a080e7          	jalr	-1894(ra) # 58aa <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	888080e7          	jalr	-1912(ra) # 58aa <open>
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
      42:	0aa50513          	addi	a0,a0,170 # 60e8 <malloc+0x448>
      46:	00006097          	auipc	ra,0x6
      4a:	b9c080e7          	jalr	-1124(ra) # 5be2 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	81a080e7          	jalr	-2022(ra) # 586a <exit>

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
      84:	08850513          	addi	a0,a0,136 # 6108 <malloc+0x468>
      88:	00006097          	auipc	ra,0x6
      8c:	b5a080e7          	jalr	-1190(ra) # 5be2 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	7d8080e7          	jalr	2008(ra) # 586a <exit>

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
      ac:	07850513          	addi	a0,a0,120 # 6120 <malloc+0x480>
      b0:	00005097          	auipc	ra,0x5
      b4:	7fa080e7          	jalr	2042(ra) # 58aa <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	7d6080e7          	jalr	2006(ra) # 5892 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	07a50513          	addi	a0,a0,122 # 6140 <malloc+0x4a0>
      ce:	00005097          	auipc	ra,0x5
      d2:	7dc080e7          	jalr	2012(ra) # 58aa <open>
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
      ea:	04250513          	addi	a0,a0,66 # 6128 <malloc+0x488>
      ee:	00006097          	auipc	ra,0x6
      f2:	af4080e7          	jalr	-1292(ra) # 5be2 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	772080e7          	jalr	1906(ra) # 586a <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	04e50513          	addi	a0,a0,78 # 6150 <malloc+0x4b0>
     10a:	00006097          	auipc	ra,0x6
     10e:	ad8080e7          	jalr	-1320(ra) # 5be2 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	756080e7          	jalr	1878(ra) # 586a <exit>

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
     130:	04c50513          	addi	a0,a0,76 # 6178 <malloc+0x4d8>
     134:	00005097          	auipc	ra,0x5
     138:	786080e7          	jalr	1926(ra) # 58ba <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	03850513          	addi	a0,a0,56 # 6178 <malloc+0x4d8>
     148:	00005097          	auipc	ra,0x5
     14c:	762080e7          	jalr	1890(ra) # 58aa <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	03458593          	addi	a1,a1,52 # 6188 <malloc+0x4e8>
     15c:	00005097          	auipc	ra,0x5
     160:	72e080e7          	jalr	1838(ra) # 588a <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	01050513          	addi	a0,a0,16 # 6178 <malloc+0x4d8>
     170:	00005097          	auipc	ra,0x5
     174:	73a080e7          	jalr	1850(ra) # 58aa <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	01458593          	addi	a1,a1,20 # 6190 <malloc+0x4f0>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	704080e7          	jalr	1796(ra) # 588a <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	fe450513          	addi	a0,a0,-28 # 6178 <malloc+0x4d8>
     19c:	00005097          	auipc	ra,0x5
     1a0:	71e080e7          	jalr	1822(ra) # 58ba <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	6ec080e7          	jalr	1772(ra) # 5892 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	6e2080e7          	jalr	1762(ra) # 5892 <close>
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
     1ce:	fce50513          	addi	a0,a0,-50 # 6198 <malloc+0x4f8>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	a10080e7          	jalr	-1520(ra) # 5be2 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	68e080e7          	jalr	1678(ra) # 586a <exit>

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
     214:	69a080e7          	jalr	1690(ra) # 58aa <open>
    close(fd);
     218:	00005097          	auipc	ra,0x5
     21c:	67a080e7          	jalr	1658(ra) # 5892 <close>
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
     24a:	674080e7          	jalr	1652(ra) # 58ba <unlink>
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
     280:	cec50513          	addi	a0,a0,-788 # 5f68 <malloc+0x2c8>
     284:	00005097          	auipc	ra,0x5
     288:	636080e7          	jalr	1590(ra) # 58ba <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	cd8a8a93          	addi	s5,s5,-808 # 5f68 <malloc+0x2c8>
      int cc = write(fd, buf, sz);
     298:	0000ca17          	auipc	s4,0xc
     29c:	b10a0a13          	addi	s4,s4,-1264 # bda8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <dirtest+0x77>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00005097          	auipc	ra,0x5
     2b0:	5fe080e7          	jalr	1534(ra) # 58aa <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00005097          	auipc	ra,0x5
     2c2:	5cc080e7          	jalr	1484(ra) # 588a <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49463          	bne	s1,a0,330 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00005097          	auipc	ra,0x5
     2d6:	5b8080e7          	jalr	1464(ra) # 588a <write>
      if(cc != sz){
     2da:	04951963          	bne	a0,s1,32c <bigwrite+0xc8>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00005097          	auipc	ra,0x5
     2e4:	5b2080e7          	jalr	1458(ra) # 5892 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00005097          	auipc	ra,0x5
     2ee:	5d0080e7          	jalr	1488(ra) # 58ba <unlink>
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
     316:	eae50513          	addi	a0,a0,-338 # 61c0 <malloc+0x520>
     31a:	00006097          	auipc	ra,0x6
     31e:	8c8080e7          	jalr	-1848(ra) # 5be2 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	546080e7          	jalr	1350(ra) # 586a <exit>
     32c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     32e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     330:	86ce                	mv	a3,s3
     332:	8626                	mv	a2,s1
     334:	85de                	mv	a1,s7
     336:	00006517          	auipc	a0,0x6
     33a:	eaa50513          	addi	a0,a0,-342 # 61e0 <malloc+0x540>
     33e:	00006097          	auipc	ra,0x6
     342:	8a4080e7          	jalr	-1884(ra) # 5be2 <printf>
        exit(1);
     346:	4505                	li	a0,1
     348:	00005097          	auipc	ra,0x5
     34c:	522080e7          	jalr	1314(ra) # 586a <exit>

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
     376:	e86a0a13          	addi	s4,s4,-378 # 61f8 <malloc+0x558>
    uint64 addr = addrs[ai];
     37a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     37e:	20100593          	li	a1,513
     382:	8552                	mv	a0,s4
     384:	00005097          	auipc	ra,0x5
     388:	526080e7          	jalr	1318(ra) # 58aa <open>
     38c:	84aa                	mv	s1,a0
    if(fd < 0){
     38e:	08054863          	bltz	a0,41e <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     392:	6609                	lui	a2,0x2
     394:	85ce                	mv	a1,s3
     396:	00005097          	auipc	ra,0x5
     39a:	4f4080e7          	jalr	1268(ra) # 588a <write>
    if(n >= 0){
     39e:	08055d63          	bgez	a0,438 <copyin+0xe8>
    close(fd);
     3a2:	8526                	mv	a0,s1
     3a4:	00005097          	auipc	ra,0x5
     3a8:	4ee080e7          	jalr	1262(ra) # 5892 <close>
    unlink("copyin1");
     3ac:	8552                	mv	a0,s4
     3ae:	00005097          	auipc	ra,0x5
     3b2:	50c080e7          	jalr	1292(ra) # 58ba <unlink>
    n = write(1, (char*)addr, 8192);
     3b6:	6609                	lui	a2,0x2
     3b8:	85ce                	mv	a1,s3
     3ba:	4505                	li	a0,1
     3bc:	00005097          	auipc	ra,0x5
     3c0:	4ce080e7          	jalr	1230(ra) # 588a <write>
    if(n > 0){
     3c4:	08a04963          	bgtz	a0,456 <copyin+0x106>
    if(pipe(fds) < 0){
     3c8:	fb840513          	addi	a0,s0,-72
     3cc:	00005097          	auipc	ra,0x5
     3d0:	4ae080e7          	jalr	1198(ra) # 587a <pipe>
     3d4:	0a054063          	bltz	a0,474 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3d8:	6609                	lui	a2,0x2
     3da:	85ce                	mv	a1,s3
     3dc:	fbc42503          	lw	a0,-68(s0)
     3e0:	00005097          	auipc	ra,0x5
     3e4:	4aa080e7          	jalr	1194(ra) # 588a <write>
    if(n > 0){
     3e8:	0aa04363          	bgtz	a0,48e <copyin+0x13e>
    close(fds[0]);
     3ec:	fb842503          	lw	a0,-72(s0)
     3f0:	00005097          	auipc	ra,0x5
     3f4:	4a2080e7          	jalr	1186(ra) # 5892 <close>
    close(fds[1]);
     3f8:	fbc42503          	lw	a0,-68(s0)
     3fc:	00005097          	auipc	ra,0x5
     400:	496080e7          	jalr	1174(ra) # 5892 <close>
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
     422:	de250513          	addi	a0,a0,-542 # 6200 <malloc+0x560>
     426:	00005097          	auipc	ra,0x5
     42a:	7bc080e7          	jalr	1980(ra) # 5be2 <printf>
      exit(1);
     42e:	4505                	li	a0,1
     430:	00005097          	auipc	ra,0x5
     434:	43a080e7          	jalr	1082(ra) # 586a <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     438:	862a                	mv	a2,a0
     43a:	85ce                	mv	a1,s3
     43c:	00006517          	auipc	a0,0x6
     440:	ddc50513          	addi	a0,a0,-548 # 6218 <malloc+0x578>
     444:	00005097          	auipc	ra,0x5
     448:	79e080e7          	jalr	1950(ra) # 5be2 <printf>
      exit(1);
     44c:	4505                	li	a0,1
     44e:	00005097          	auipc	ra,0x5
     452:	41c080e7          	jalr	1052(ra) # 586a <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     456:	862a                	mv	a2,a0
     458:	85ce                	mv	a1,s3
     45a:	00006517          	auipc	a0,0x6
     45e:	dee50513          	addi	a0,a0,-530 # 6248 <malloc+0x5a8>
     462:	00005097          	auipc	ra,0x5
     466:	780080e7          	jalr	1920(ra) # 5be2 <printf>
      exit(1);
     46a:	4505                	li	a0,1
     46c:	00005097          	auipc	ra,0x5
     470:	3fe080e7          	jalr	1022(ra) # 586a <exit>
      printf("pipe() failed\n");
     474:	00006517          	auipc	a0,0x6
     478:	e0450513          	addi	a0,a0,-508 # 6278 <malloc+0x5d8>
     47c:	00005097          	auipc	ra,0x5
     480:	766080e7          	jalr	1894(ra) # 5be2 <printf>
      exit(1);
     484:	4505                	li	a0,1
     486:	00005097          	auipc	ra,0x5
     48a:	3e4080e7          	jalr	996(ra) # 586a <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     48e:	862a                	mv	a2,a0
     490:	85ce                	mv	a1,s3
     492:	00006517          	auipc	a0,0x6
     496:	df650513          	addi	a0,a0,-522 # 6288 <malloc+0x5e8>
     49a:	00005097          	auipc	ra,0x5
     49e:	748080e7          	jalr	1864(ra) # 5be2 <printf>
      exit(1);
     4a2:	4505                	li	a0,1
     4a4:	00005097          	auipc	ra,0x5
     4a8:	3c6080e7          	jalr	966(ra) # 586a <exit>

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
     4bc:	f05a                	sd	s6,32(sp)
     4be:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4c0:	4785                	li	a5,1
     4c2:	07fe                	slli	a5,a5,0x1f
     4c4:	faf43823          	sd	a5,-80(s0)
     4c8:	57fd                	li	a5,-1
     4ca:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4ce:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4d2:	00006a97          	auipc	s5,0x6
     4d6:	de6a8a93          	addi	s5,s5,-538 # 62b8 <malloc+0x618>
    printf("%p\n",addr);
     4da:	00007a17          	auipc	s4,0x7
     4de:	8eea0a13          	addi	s4,s4,-1810 # 6dc8 <malloc+0x1128>
    n = write(fds[1], "x", 1);
     4e2:	00006b17          	auipc	s6,0x6
     4e6:	caeb0b13          	addi	s6,s6,-850 # 6190 <malloc+0x4f0>
    uint64 addr = addrs[ai];
     4ea:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4ee:	4581                	li	a1,0
     4f0:	8556                	mv	a0,s5
     4f2:	00005097          	auipc	ra,0x5
     4f6:	3b8080e7          	jalr	952(ra) # 58aa <open>
     4fa:	84aa                	mv	s1,a0
    if(fd < 0){
     4fc:	08054d63          	bltz	a0,596 <copyout+0xea>
    int n = read(fd, (void*)addr, 8192);
     500:	6609                	lui	a2,0x2
     502:	85ce                	mv	a1,s3
     504:	00005097          	auipc	ra,0x5
     508:	37e080e7          	jalr	894(ra) # 5882 <read>
    if(n > 0){
     50c:	0aa04263          	bgtz	a0,5b0 <copyout+0x104>
    printf("%p\n",addr);
     510:	85ce                	mv	a1,s3
     512:	8552                	mv	a0,s4
     514:	00005097          	auipc	ra,0x5
     518:	6ce080e7          	jalr	1742(ra) # 5be2 <printf>
    close(fd);
     51c:	8526                	mv	a0,s1
     51e:	00005097          	auipc	ra,0x5
     522:	374080e7          	jalr	884(ra) # 5892 <close>
    if(pipe(fds) < 0){
     526:	fa840513          	addi	a0,s0,-88
     52a:	00005097          	auipc	ra,0x5
     52e:	350080e7          	jalr	848(ra) # 587a <pipe>
     532:	08054e63          	bltz	a0,5ce <copyout+0x122>
    n = write(fds[1], "x", 1);
     536:	4605                	li	a2,1
     538:	85da                	mv	a1,s6
     53a:	fac42503          	lw	a0,-84(s0)
     53e:	00005097          	auipc	ra,0x5
     542:	34c080e7          	jalr	844(ra) # 588a <write>
    if(n != 1){
     546:	4785                	li	a5,1
     548:	0af51063          	bne	a0,a5,5e8 <copyout+0x13c>
    n = read(fds[0], (void*)addr, 8192);
     54c:	6609                	lui	a2,0x2
     54e:	85ce                	mv	a1,s3
     550:	fa842503          	lw	a0,-88(s0)
     554:	00005097          	auipc	ra,0x5
     558:	32e080e7          	jalr	814(ra) # 5882 <read>
    if(n > 0){
     55c:	0aa04363          	bgtz	a0,602 <copyout+0x156>
    close(fds[0]);
     560:	fa842503          	lw	a0,-88(s0)
     564:	00005097          	auipc	ra,0x5
     568:	32e080e7          	jalr	814(ra) # 5892 <close>
    close(fds[1]);
     56c:	fac42503          	lw	a0,-84(s0)
     570:	00005097          	auipc	ra,0x5
     574:	322080e7          	jalr	802(ra) # 5892 <close>
  for(int ai = 0; ai < 2; ai++){
     578:	0921                	addi	s2,s2,8
     57a:	fc040793          	addi	a5,s0,-64
     57e:	f6f916e3          	bne	s2,a5,4ea <copyout+0x3e>
}
     582:	60e6                	ld	ra,88(sp)
     584:	6446                	ld	s0,80(sp)
     586:	64a6                	ld	s1,72(sp)
     588:	6906                	ld	s2,64(sp)
     58a:	79e2                	ld	s3,56(sp)
     58c:	7a42                	ld	s4,48(sp)
     58e:	7aa2                	ld	s5,40(sp)
     590:	7b02                	ld	s6,32(sp)
     592:	6125                	addi	sp,sp,96
     594:	8082                	ret
      printf("open(README) failed\n");
     596:	00006517          	auipc	a0,0x6
     59a:	d2a50513          	addi	a0,a0,-726 # 62c0 <malloc+0x620>
     59e:	00005097          	auipc	ra,0x5
     5a2:	644080e7          	jalr	1604(ra) # 5be2 <printf>
      exit(1);
     5a6:	4505                	li	a0,1
     5a8:	00005097          	auipc	ra,0x5
     5ac:	2c2080e7          	jalr	706(ra) # 586a <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5b0:	862a                	mv	a2,a0
     5b2:	85ce                	mv	a1,s3
     5b4:	00006517          	auipc	a0,0x6
     5b8:	d2450513          	addi	a0,a0,-732 # 62d8 <malloc+0x638>
     5bc:	00005097          	auipc	ra,0x5
     5c0:	626080e7          	jalr	1574(ra) # 5be2 <printf>
      exit(1);
     5c4:	4505                	li	a0,1
     5c6:	00005097          	auipc	ra,0x5
     5ca:	2a4080e7          	jalr	676(ra) # 586a <exit>
      printf("pipe() failed\n");
     5ce:	00006517          	auipc	a0,0x6
     5d2:	caa50513          	addi	a0,a0,-854 # 6278 <malloc+0x5d8>
     5d6:	00005097          	auipc	ra,0x5
     5da:	60c080e7          	jalr	1548(ra) # 5be2 <printf>
      exit(1);
     5de:	4505                	li	a0,1
     5e0:	00005097          	auipc	ra,0x5
     5e4:	28a080e7          	jalr	650(ra) # 586a <exit>
      printf("pipe write failed\n");
     5e8:	00006517          	auipc	a0,0x6
     5ec:	d2050513          	addi	a0,a0,-736 # 6308 <malloc+0x668>
     5f0:	00005097          	auipc	ra,0x5
     5f4:	5f2080e7          	jalr	1522(ra) # 5be2 <printf>
      exit(1);
     5f8:	4505                	li	a0,1
     5fa:	00005097          	auipc	ra,0x5
     5fe:	270080e7          	jalr	624(ra) # 586a <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     602:	862a                	mv	a2,a0
     604:	85ce                	mv	a1,s3
     606:	00006517          	auipc	a0,0x6
     60a:	d1a50513          	addi	a0,a0,-742 # 6320 <malloc+0x680>
     60e:	00005097          	auipc	ra,0x5
     612:	5d4080e7          	jalr	1492(ra) # 5be2 <printf>
      exit(1);
     616:	4505                	li	a0,1
     618:	00005097          	auipc	ra,0x5
     61c:	252080e7          	jalr	594(ra) # 586a <exit>

0000000000000620 <truncate1>:
{
     620:	711d                	addi	sp,sp,-96
     622:	ec86                	sd	ra,88(sp)
     624:	e8a2                	sd	s0,80(sp)
     626:	e4a6                	sd	s1,72(sp)
     628:	e0ca                	sd	s2,64(sp)
     62a:	fc4e                	sd	s3,56(sp)
     62c:	f852                	sd	s4,48(sp)
     62e:	f456                	sd	s5,40(sp)
     630:	1080                	addi	s0,sp,96
     632:	8aaa                	mv	s5,a0
  unlink("truncfile");
     634:	00006517          	auipc	a0,0x6
     638:	b4450513          	addi	a0,a0,-1212 # 6178 <malloc+0x4d8>
     63c:	00005097          	auipc	ra,0x5
     640:	27e080e7          	jalr	638(ra) # 58ba <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     644:	60100593          	li	a1,1537
     648:	00006517          	auipc	a0,0x6
     64c:	b3050513          	addi	a0,a0,-1232 # 6178 <malloc+0x4d8>
     650:	00005097          	auipc	ra,0x5
     654:	25a080e7          	jalr	602(ra) # 58aa <open>
     658:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     65a:	4611                	li	a2,4
     65c:	00006597          	auipc	a1,0x6
     660:	b2c58593          	addi	a1,a1,-1236 # 6188 <malloc+0x4e8>
     664:	00005097          	auipc	ra,0x5
     668:	226080e7          	jalr	550(ra) # 588a <write>
  close(fd1);
     66c:	8526                	mv	a0,s1
     66e:	00005097          	auipc	ra,0x5
     672:	224080e7          	jalr	548(ra) # 5892 <close>
  int fd2 = open("truncfile", O_RDONLY);
     676:	4581                	li	a1,0
     678:	00006517          	auipc	a0,0x6
     67c:	b0050513          	addi	a0,a0,-1280 # 6178 <malloc+0x4d8>
     680:	00005097          	auipc	ra,0x5
     684:	22a080e7          	jalr	554(ra) # 58aa <open>
     688:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     68a:	02000613          	li	a2,32
     68e:	fa040593          	addi	a1,s0,-96
     692:	00005097          	auipc	ra,0x5
     696:	1f0080e7          	jalr	496(ra) # 5882 <read>
  if(n != 4){
     69a:	4791                	li	a5,4
     69c:	0cf51e63          	bne	a0,a5,778 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     6a0:	40100593          	li	a1,1025
     6a4:	00006517          	auipc	a0,0x6
     6a8:	ad450513          	addi	a0,a0,-1324 # 6178 <malloc+0x4d8>
     6ac:	00005097          	auipc	ra,0x5
     6b0:	1fe080e7          	jalr	510(ra) # 58aa <open>
     6b4:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     6b6:	4581                	li	a1,0
     6b8:	00006517          	auipc	a0,0x6
     6bc:	ac050513          	addi	a0,a0,-1344 # 6178 <malloc+0x4d8>
     6c0:	00005097          	auipc	ra,0x5
     6c4:	1ea080e7          	jalr	490(ra) # 58aa <open>
     6c8:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6ca:	02000613          	li	a2,32
     6ce:	fa040593          	addi	a1,s0,-96
     6d2:	00005097          	auipc	ra,0x5
     6d6:	1b0080e7          	jalr	432(ra) # 5882 <read>
     6da:	8a2a                	mv	s4,a0
  if(n != 0){
     6dc:	ed4d                	bnez	a0,796 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6de:	02000613          	li	a2,32
     6e2:	fa040593          	addi	a1,s0,-96
     6e6:	8526                	mv	a0,s1
     6e8:	00005097          	auipc	ra,0x5
     6ec:	19a080e7          	jalr	410(ra) # 5882 <read>
     6f0:	8a2a                	mv	s4,a0
  if(n != 0){
     6f2:	e971                	bnez	a0,7c6 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6f4:	4619                	li	a2,6
     6f6:	00006597          	auipc	a1,0x6
     6fa:	cba58593          	addi	a1,a1,-838 # 63b0 <malloc+0x710>
     6fe:	854e                	mv	a0,s3
     700:	00005097          	auipc	ra,0x5
     704:	18a080e7          	jalr	394(ra) # 588a <write>
  n = read(fd3, buf, sizeof(buf));
     708:	02000613          	li	a2,32
     70c:	fa040593          	addi	a1,s0,-96
     710:	854a                	mv	a0,s2
     712:	00005097          	auipc	ra,0x5
     716:	170080e7          	jalr	368(ra) # 5882 <read>
  if(n != 6){
     71a:	4799                	li	a5,6
     71c:	0cf51d63          	bne	a0,a5,7f6 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     720:	02000613          	li	a2,32
     724:	fa040593          	addi	a1,s0,-96
     728:	8526                	mv	a0,s1
     72a:	00005097          	auipc	ra,0x5
     72e:	158080e7          	jalr	344(ra) # 5882 <read>
  if(n != 2){
     732:	4789                	li	a5,2
     734:	0ef51063          	bne	a0,a5,814 <truncate1+0x1f4>
  unlink("truncfile");
     738:	00006517          	auipc	a0,0x6
     73c:	a4050513          	addi	a0,a0,-1472 # 6178 <malloc+0x4d8>
     740:	00005097          	auipc	ra,0x5
     744:	17a080e7          	jalr	378(ra) # 58ba <unlink>
  close(fd1);
     748:	854e                	mv	a0,s3
     74a:	00005097          	auipc	ra,0x5
     74e:	148080e7          	jalr	328(ra) # 5892 <close>
  close(fd2);
     752:	8526                	mv	a0,s1
     754:	00005097          	auipc	ra,0x5
     758:	13e080e7          	jalr	318(ra) # 5892 <close>
  close(fd3);
     75c:	854a                	mv	a0,s2
     75e:	00005097          	auipc	ra,0x5
     762:	134080e7          	jalr	308(ra) # 5892 <close>
}
     766:	60e6                	ld	ra,88(sp)
     768:	6446                	ld	s0,80(sp)
     76a:	64a6                	ld	s1,72(sp)
     76c:	6906                	ld	s2,64(sp)
     76e:	79e2                	ld	s3,56(sp)
     770:	7a42                	ld	s4,48(sp)
     772:	7aa2                	ld	s5,40(sp)
     774:	6125                	addi	sp,sp,96
     776:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     778:	862a                	mv	a2,a0
     77a:	85d6                	mv	a1,s5
     77c:	00006517          	auipc	a0,0x6
     780:	bd450513          	addi	a0,a0,-1068 # 6350 <malloc+0x6b0>
     784:	00005097          	auipc	ra,0x5
     788:	45e080e7          	jalr	1118(ra) # 5be2 <printf>
    exit(1);
     78c:	4505                	li	a0,1
     78e:	00005097          	auipc	ra,0x5
     792:	0dc080e7          	jalr	220(ra) # 586a <exit>
    printf("aaa fd3=%d\n", fd3);
     796:	85ca                	mv	a1,s2
     798:	00006517          	auipc	a0,0x6
     79c:	bd850513          	addi	a0,a0,-1064 # 6370 <malloc+0x6d0>
     7a0:	00005097          	auipc	ra,0x5
     7a4:	442080e7          	jalr	1090(ra) # 5be2 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7a8:	8652                	mv	a2,s4
     7aa:	85d6                	mv	a1,s5
     7ac:	00006517          	auipc	a0,0x6
     7b0:	bd450513          	addi	a0,a0,-1068 # 6380 <malloc+0x6e0>
     7b4:	00005097          	auipc	ra,0x5
     7b8:	42e080e7          	jalr	1070(ra) # 5be2 <printf>
    exit(1);
     7bc:	4505                	li	a0,1
     7be:	00005097          	auipc	ra,0x5
     7c2:	0ac080e7          	jalr	172(ra) # 586a <exit>
    printf("bbb fd2=%d\n", fd2);
     7c6:	85a6                	mv	a1,s1
     7c8:	00006517          	auipc	a0,0x6
     7cc:	bd850513          	addi	a0,a0,-1064 # 63a0 <malloc+0x700>
     7d0:	00005097          	auipc	ra,0x5
     7d4:	412080e7          	jalr	1042(ra) # 5be2 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7d8:	8652                	mv	a2,s4
     7da:	85d6                	mv	a1,s5
     7dc:	00006517          	auipc	a0,0x6
     7e0:	ba450513          	addi	a0,a0,-1116 # 6380 <malloc+0x6e0>
     7e4:	00005097          	auipc	ra,0x5
     7e8:	3fe080e7          	jalr	1022(ra) # 5be2 <printf>
    exit(1);
     7ec:	4505                	li	a0,1
     7ee:	00005097          	auipc	ra,0x5
     7f2:	07c080e7          	jalr	124(ra) # 586a <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7f6:	862a                	mv	a2,a0
     7f8:	85d6                	mv	a1,s5
     7fa:	00006517          	auipc	a0,0x6
     7fe:	bbe50513          	addi	a0,a0,-1090 # 63b8 <malloc+0x718>
     802:	00005097          	auipc	ra,0x5
     806:	3e0080e7          	jalr	992(ra) # 5be2 <printf>
    exit(1);
     80a:	4505                	li	a0,1
     80c:	00005097          	auipc	ra,0x5
     810:	05e080e7          	jalr	94(ra) # 586a <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     814:	862a                	mv	a2,a0
     816:	85d6                	mv	a1,s5
     818:	00006517          	auipc	a0,0x6
     81c:	bc050513          	addi	a0,a0,-1088 # 63d8 <malloc+0x738>
     820:	00005097          	auipc	ra,0x5
     824:	3c2080e7          	jalr	962(ra) # 5be2 <printf>
    exit(1);
     828:	4505                	li	a0,1
     82a:	00005097          	auipc	ra,0x5
     82e:	040080e7          	jalr	64(ra) # 586a <exit>

0000000000000832 <writetest>:
{
     832:	7139                	addi	sp,sp,-64
     834:	fc06                	sd	ra,56(sp)
     836:	f822                	sd	s0,48(sp)
     838:	f426                	sd	s1,40(sp)
     83a:	f04a                	sd	s2,32(sp)
     83c:	ec4e                	sd	s3,24(sp)
     83e:	e852                	sd	s4,16(sp)
     840:	e456                	sd	s5,8(sp)
     842:	e05a                	sd	s6,0(sp)
     844:	0080                	addi	s0,sp,64
     846:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     848:	20200593          	li	a1,514
     84c:	00006517          	auipc	a0,0x6
     850:	bac50513          	addi	a0,a0,-1108 # 63f8 <malloc+0x758>
     854:	00005097          	auipc	ra,0x5
     858:	056080e7          	jalr	86(ra) # 58aa <open>
  if(fd < 0){
     85c:	0a054d63          	bltz	a0,916 <writetest+0xe4>
     860:	892a                	mv	s2,a0
     862:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     864:	00006997          	auipc	s3,0x6
     868:	bbc98993          	addi	s3,s3,-1092 # 6420 <malloc+0x780>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     86c:	00006a97          	auipc	s5,0x6
     870:	beca8a93          	addi	s5,s5,-1044 # 6458 <malloc+0x7b8>
  for(i = 0; i < N; i++){
     874:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     878:	4629                	li	a2,10
     87a:	85ce                	mv	a1,s3
     87c:	854a                	mv	a0,s2
     87e:	00005097          	auipc	ra,0x5
     882:	00c080e7          	jalr	12(ra) # 588a <write>
     886:	47a9                	li	a5,10
     888:	0af51563          	bne	a0,a5,932 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     88c:	4629                	li	a2,10
     88e:	85d6                	mv	a1,s5
     890:	854a                	mv	a0,s2
     892:	00005097          	auipc	ra,0x5
     896:	ff8080e7          	jalr	-8(ra) # 588a <write>
     89a:	47a9                	li	a5,10
     89c:	0af51a63          	bne	a0,a5,950 <writetest+0x11e>
  for(i = 0; i < N; i++){
     8a0:	2485                	addiw	s1,s1,1
     8a2:	fd449be3          	bne	s1,s4,878 <writetest+0x46>
  close(fd);
     8a6:	854a                	mv	a0,s2
     8a8:	00005097          	auipc	ra,0x5
     8ac:	fea080e7          	jalr	-22(ra) # 5892 <close>
  fd = open("small", O_RDONLY);
     8b0:	4581                	li	a1,0
     8b2:	00006517          	auipc	a0,0x6
     8b6:	b4650513          	addi	a0,a0,-1210 # 63f8 <malloc+0x758>
     8ba:	00005097          	auipc	ra,0x5
     8be:	ff0080e7          	jalr	-16(ra) # 58aa <open>
     8c2:	84aa                	mv	s1,a0
  if(fd < 0){
     8c4:	0a054563          	bltz	a0,96e <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8c8:	7d000613          	li	a2,2000
     8cc:	0000b597          	auipc	a1,0xb
     8d0:	4dc58593          	addi	a1,a1,1244 # bda8 <buf>
     8d4:	00005097          	auipc	ra,0x5
     8d8:	fae080e7          	jalr	-82(ra) # 5882 <read>
  if(i != N*SZ*2){
     8dc:	7d000793          	li	a5,2000
     8e0:	0af51563          	bne	a0,a5,98a <writetest+0x158>
  close(fd);
     8e4:	8526                	mv	a0,s1
     8e6:	00005097          	auipc	ra,0x5
     8ea:	fac080e7          	jalr	-84(ra) # 5892 <close>
  if(unlink("small") < 0){
     8ee:	00006517          	auipc	a0,0x6
     8f2:	b0a50513          	addi	a0,a0,-1270 # 63f8 <malloc+0x758>
     8f6:	00005097          	auipc	ra,0x5
     8fa:	fc4080e7          	jalr	-60(ra) # 58ba <unlink>
     8fe:	0a054463          	bltz	a0,9a6 <writetest+0x174>
}
     902:	70e2                	ld	ra,56(sp)
     904:	7442                	ld	s0,48(sp)
     906:	74a2                	ld	s1,40(sp)
     908:	7902                	ld	s2,32(sp)
     90a:	69e2                	ld	s3,24(sp)
     90c:	6a42                	ld	s4,16(sp)
     90e:	6aa2                	ld	s5,8(sp)
     910:	6b02                	ld	s6,0(sp)
     912:	6121                	addi	sp,sp,64
     914:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     916:	85da                	mv	a1,s6
     918:	00006517          	auipc	a0,0x6
     91c:	ae850513          	addi	a0,a0,-1304 # 6400 <malloc+0x760>
     920:	00005097          	auipc	ra,0x5
     924:	2c2080e7          	jalr	706(ra) # 5be2 <printf>
    exit(1);
     928:	4505                	li	a0,1
     92a:	00005097          	auipc	ra,0x5
     92e:	f40080e7          	jalr	-192(ra) # 586a <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     932:	8626                	mv	a2,s1
     934:	85da                	mv	a1,s6
     936:	00006517          	auipc	a0,0x6
     93a:	afa50513          	addi	a0,a0,-1286 # 6430 <malloc+0x790>
     93e:	00005097          	auipc	ra,0x5
     942:	2a4080e7          	jalr	676(ra) # 5be2 <printf>
      exit(1);
     946:	4505                	li	a0,1
     948:	00005097          	auipc	ra,0x5
     94c:	f22080e7          	jalr	-222(ra) # 586a <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     950:	8626                	mv	a2,s1
     952:	85da                	mv	a1,s6
     954:	00006517          	auipc	a0,0x6
     958:	b1450513          	addi	a0,a0,-1260 # 6468 <malloc+0x7c8>
     95c:	00005097          	auipc	ra,0x5
     960:	286080e7          	jalr	646(ra) # 5be2 <printf>
      exit(1);
     964:	4505                	li	a0,1
     966:	00005097          	auipc	ra,0x5
     96a:	f04080e7          	jalr	-252(ra) # 586a <exit>
    printf("%s: error: open small failed!\n", s);
     96e:	85da                	mv	a1,s6
     970:	00006517          	auipc	a0,0x6
     974:	b2050513          	addi	a0,a0,-1248 # 6490 <malloc+0x7f0>
     978:	00005097          	auipc	ra,0x5
     97c:	26a080e7          	jalr	618(ra) # 5be2 <printf>
    exit(1);
     980:	4505                	li	a0,1
     982:	00005097          	auipc	ra,0x5
     986:	ee8080e7          	jalr	-280(ra) # 586a <exit>
    printf("%s: read failed\n", s);
     98a:	85da                	mv	a1,s6
     98c:	00006517          	auipc	a0,0x6
     990:	b2450513          	addi	a0,a0,-1244 # 64b0 <malloc+0x810>
     994:	00005097          	auipc	ra,0x5
     998:	24e080e7          	jalr	590(ra) # 5be2 <printf>
    exit(1);
     99c:	4505                	li	a0,1
     99e:	00005097          	auipc	ra,0x5
     9a2:	ecc080e7          	jalr	-308(ra) # 586a <exit>
    printf("%s: unlink small failed\n", s);
     9a6:	85da                	mv	a1,s6
     9a8:	00006517          	auipc	a0,0x6
     9ac:	b2050513          	addi	a0,a0,-1248 # 64c8 <malloc+0x828>
     9b0:	00005097          	auipc	ra,0x5
     9b4:	232080e7          	jalr	562(ra) # 5be2 <printf>
    exit(1);
     9b8:	4505                	li	a0,1
     9ba:	00005097          	auipc	ra,0x5
     9be:	eb0080e7          	jalr	-336(ra) # 586a <exit>

00000000000009c2 <writebig>:
{
     9c2:	7139                	addi	sp,sp,-64
     9c4:	fc06                	sd	ra,56(sp)
     9c6:	f822                	sd	s0,48(sp)
     9c8:	f426                	sd	s1,40(sp)
     9ca:	f04a                	sd	s2,32(sp)
     9cc:	ec4e                	sd	s3,24(sp)
     9ce:	e852                	sd	s4,16(sp)
     9d0:	e456                	sd	s5,8(sp)
     9d2:	0080                	addi	s0,sp,64
     9d4:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9d6:	20200593          	li	a1,514
     9da:	00006517          	auipc	a0,0x6
     9de:	b0e50513          	addi	a0,a0,-1266 # 64e8 <malloc+0x848>
     9e2:	00005097          	auipc	ra,0x5
     9e6:	ec8080e7          	jalr	-312(ra) # 58aa <open>
     9ea:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9ec:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9ee:	0000b917          	auipc	s2,0xb
     9f2:	3ba90913          	addi	s2,s2,954 # bda8 <buf>
  for(i = 0; i < MAXFILE; i++){
     9f6:	10c00a13          	li	s4,268
  if(fd < 0){
     9fa:	06054c63          	bltz	a0,a72 <writebig+0xb0>
    ((int*)buf)[0] = i;
     9fe:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     a02:	40000613          	li	a2,1024
     a06:	85ca                	mv	a1,s2
     a08:	854e                	mv	a0,s3
     a0a:	00005097          	auipc	ra,0x5
     a0e:	e80080e7          	jalr	-384(ra) # 588a <write>
     a12:	40000793          	li	a5,1024
     a16:	06f51c63          	bne	a0,a5,a8e <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a1a:	2485                	addiw	s1,s1,1
     a1c:	ff4491e3          	bne	s1,s4,9fe <writebig+0x3c>
  close(fd);
     a20:	854e                	mv	a0,s3
     a22:	00005097          	auipc	ra,0x5
     a26:	e70080e7          	jalr	-400(ra) # 5892 <close>
  fd = open("big", O_RDONLY);
     a2a:	4581                	li	a1,0
     a2c:	00006517          	auipc	a0,0x6
     a30:	abc50513          	addi	a0,a0,-1348 # 64e8 <malloc+0x848>
     a34:	00005097          	auipc	ra,0x5
     a38:	e76080e7          	jalr	-394(ra) # 58aa <open>
     a3c:	89aa                	mv	s3,a0
  n = 0;
     a3e:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a40:	0000b917          	auipc	s2,0xb
     a44:	36890913          	addi	s2,s2,872 # bda8 <buf>
  if(fd < 0){
     a48:	06054263          	bltz	a0,aac <writebig+0xea>
    i = read(fd, buf, BSIZE);
     a4c:	40000613          	li	a2,1024
     a50:	85ca                	mv	a1,s2
     a52:	854e                	mv	a0,s3
     a54:	00005097          	auipc	ra,0x5
     a58:	e2e080e7          	jalr	-466(ra) # 5882 <read>
    if(i == 0){
     a5c:	c535                	beqz	a0,ac8 <writebig+0x106>
    } else if(i != BSIZE){
     a5e:	40000793          	li	a5,1024
     a62:	0af51f63          	bne	a0,a5,b20 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     a66:	00092683          	lw	a3,0(s2)
     a6a:	0c969a63          	bne	a3,s1,b3e <writebig+0x17c>
    n++;
     a6e:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a70:	bff1                	j	a4c <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a72:	85d6                	mv	a1,s5
     a74:	00006517          	auipc	a0,0x6
     a78:	a7c50513          	addi	a0,a0,-1412 # 64f0 <malloc+0x850>
     a7c:	00005097          	auipc	ra,0x5
     a80:	166080e7          	jalr	358(ra) # 5be2 <printf>
    exit(1);
     a84:	4505                	li	a0,1
     a86:	00005097          	auipc	ra,0x5
     a8a:	de4080e7          	jalr	-540(ra) # 586a <exit>
      printf("%s: error: write big file failed\n", s, i);
     a8e:	8626                	mv	a2,s1
     a90:	85d6                	mv	a1,s5
     a92:	00006517          	auipc	a0,0x6
     a96:	a7e50513          	addi	a0,a0,-1410 # 6510 <malloc+0x870>
     a9a:	00005097          	auipc	ra,0x5
     a9e:	148080e7          	jalr	328(ra) # 5be2 <printf>
      exit(1);
     aa2:	4505                	li	a0,1
     aa4:	00005097          	auipc	ra,0x5
     aa8:	dc6080e7          	jalr	-570(ra) # 586a <exit>
    printf("%s: error: open big failed!\n", s);
     aac:	85d6                	mv	a1,s5
     aae:	00006517          	auipc	a0,0x6
     ab2:	a8a50513          	addi	a0,a0,-1398 # 6538 <malloc+0x898>
     ab6:	00005097          	auipc	ra,0x5
     aba:	12c080e7          	jalr	300(ra) # 5be2 <printf>
    exit(1);
     abe:	4505                	li	a0,1
     ac0:	00005097          	auipc	ra,0x5
     ac4:	daa080e7          	jalr	-598(ra) # 586a <exit>
      if(n == MAXFILE - 1){
     ac8:	10b00793          	li	a5,267
     acc:	02f48a63          	beq	s1,a5,b00 <writebig+0x13e>
  close(fd);
     ad0:	854e                	mv	a0,s3
     ad2:	00005097          	auipc	ra,0x5
     ad6:	dc0080e7          	jalr	-576(ra) # 5892 <close>
  if(unlink("big") < 0){
     ada:	00006517          	auipc	a0,0x6
     ade:	a0e50513          	addi	a0,a0,-1522 # 64e8 <malloc+0x848>
     ae2:	00005097          	auipc	ra,0x5
     ae6:	dd8080e7          	jalr	-552(ra) # 58ba <unlink>
     aea:	06054963          	bltz	a0,b5c <writebig+0x19a>
}
     aee:	70e2                	ld	ra,56(sp)
     af0:	7442                	ld	s0,48(sp)
     af2:	74a2                	ld	s1,40(sp)
     af4:	7902                	ld	s2,32(sp)
     af6:	69e2                	ld	s3,24(sp)
     af8:	6a42                	ld	s4,16(sp)
     afa:	6aa2                	ld	s5,8(sp)
     afc:	6121                	addi	sp,sp,64
     afe:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     b00:	10b00613          	li	a2,267
     b04:	85d6                	mv	a1,s5
     b06:	00006517          	auipc	a0,0x6
     b0a:	a5250513          	addi	a0,a0,-1454 # 6558 <malloc+0x8b8>
     b0e:	00005097          	auipc	ra,0x5
     b12:	0d4080e7          	jalr	212(ra) # 5be2 <printf>
        exit(1);
     b16:	4505                	li	a0,1
     b18:	00005097          	auipc	ra,0x5
     b1c:	d52080e7          	jalr	-686(ra) # 586a <exit>
      printf("%s: read failed %d\n", s, i);
     b20:	862a                	mv	a2,a0
     b22:	85d6                	mv	a1,s5
     b24:	00006517          	auipc	a0,0x6
     b28:	a5c50513          	addi	a0,a0,-1444 # 6580 <malloc+0x8e0>
     b2c:	00005097          	auipc	ra,0x5
     b30:	0b6080e7          	jalr	182(ra) # 5be2 <printf>
      exit(1);
     b34:	4505                	li	a0,1
     b36:	00005097          	auipc	ra,0x5
     b3a:	d34080e7          	jalr	-716(ra) # 586a <exit>
      printf("%s: read content of block %d is %d\n", s,
     b3e:	8626                	mv	a2,s1
     b40:	85d6                	mv	a1,s5
     b42:	00006517          	auipc	a0,0x6
     b46:	a5650513          	addi	a0,a0,-1450 # 6598 <malloc+0x8f8>
     b4a:	00005097          	auipc	ra,0x5
     b4e:	098080e7          	jalr	152(ra) # 5be2 <printf>
      exit(1);
     b52:	4505                	li	a0,1
     b54:	00005097          	auipc	ra,0x5
     b58:	d16080e7          	jalr	-746(ra) # 586a <exit>
    printf("%s: unlink big failed\n", s);
     b5c:	85d6                	mv	a1,s5
     b5e:	00006517          	auipc	a0,0x6
     b62:	a6250513          	addi	a0,a0,-1438 # 65c0 <malloc+0x920>
     b66:	00005097          	auipc	ra,0x5
     b6a:	07c080e7          	jalr	124(ra) # 5be2 <printf>
    exit(1);
     b6e:	4505                	li	a0,1
     b70:	00005097          	auipc	ra,0x5
     b74:	cfa080e7          	jalr	-774(ra) # 586a <exit>

0000000000000b78 <unlinkread>:
{
     b78:	7179                	addi	sp,sp,-48
     b7a:	f406                	sd	ra,40(sp)
     b7c:	f022                	sd	s0,32(sp)
     b7e:	ec26                	sd	s1,24(sp)
     b80:	e84a                	sd	s2,16(sp)
     b82:	e44e                	sd	s3,8(sp)
     b84:	1800                	addi	s0,sp,48
     b86:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b88:	20200593          	li	a1,514
     b8c:	00005517          	auipc	a0,0x5
     b90:	36c50513          	addi	a0,a0,876 # 5ef8 <malloc+0x258>
     b94:	00005097          	auipc	ra,0x5
     b98:	d16080e7          	jalr	-746(ra) # 58aa <open>
  if(fd < 0){
     b9c:	0e054563          	bltz	a0,c86 <unlinkread+0x10e>
     ba0:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     ba2:	4615                	li	a2,5
     ba4:	00006597          	auipc	a1,0x6
     ba8:	a5458593          	addi	a1,a1,-1452 # 65f8 <malloc+0x958>
     bac:	00005097          	auipc	ra,0x5
     bb0:	cde080e7          	jalr	-802(ra) # 588a <write>
  close(fd);
     bb4:	8526                	mv	a0,s1
     bb6:	00005097          	auipc	ra,0x5
     bba:	cdc080e7          	jalr	-804(ra) # 5892 <close>
  fd = open("unlinkread", O_RDWR);
     bbe:	4589                	li	a1,2
     bc0:	00005517          	auipc	a0,0x5
     bc4:	33850513          	addi	a0,a0,824 # 5ef8 <malloc+0x258>
     bc8:	00005097          	auipc	ra,0x5
     bcc:	ce2080e7          	jalr	-798(ra) # 58aa <open>
     bd0:	84aa                	mv	s1,a0
  if(fd < 0){
     bd2:	0c054863          	bltz	a0,ca2 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bd6:	00005517          	auipc	a0,0x5
     bda:	32250513          	addi	a0,a0,802 # 5ef8 <malloc+0x258>
     bde:	00005097          	auipc	ra,0x5
     be2:	cdc080e7          	jalr	-804(ra) # 58ba <unlink>
     be6:	ed61                	bnez	a0,cbe <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     be8:	20200593          	li	a1,514
     bec:	00005517          	auipc	a0,0x5
     bf0:	30c50513          	addi	a0,a0,780 # 5ef8 <malloc+0x258>
     bf4:	00005097          	auipc	ra,0x5
     bf8:	cb6080e7          	jalr	-842(ra) # 58aa <open>
     bfc:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     bfe:	460d                	li	a2,3
     c00:	00006597          	auipc	a1,0x6
     c04:	a4058593          	addi	a1,a1,-1472 # 6640 <malloc+0x9a0>
     c08:	00005097          	auipc	ra,0x5
     c0c:	c82080e7          	jalr	-894(ra) # 588a <write>
  close(fd1);
     c10:	854a                	mv	a0,s2
     c12:	00005097          	auipc	ra,0x5
     c16:	c80080e7          	jalr	-896(ra) # 5892 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c1a:	660d                	lui	a2,0x3
     c1c:	0000b597          	auipc	a1,0xb
     c20:	18c58593          	addi	a1,a1,396 # bda8 <buf>
     c24:	8526                	mv	a0,s1
     c26:	00005097          	auipc	ra,0x5
     c2a:	c5c080e7          	jalr	-932(ra) # 5882 <read>
     c2e:	4795                	li	a5,5
     c30:	0af51563          	bne	a0,a5,cda <unlinkread+0x162>
  if(buf[0] != 'h'){
     c34:	0000b717          	auipc	a4,0xb
     c38:	17474703          	lbu	a4,372(a4) # bda8 <buf>
     c3c:	06800793          	li	a5,104
     c40:	0af71b63          	bne	a4,a5,cf6 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c44:	4629                	li	a2,10
     c46:	0000b597          	auipc	a1,0xb
     c4a:	16258593          	addi	a1,a1,354 # bda8 <buf>
     c4e:	8526                	mv	a0,s1
     c50:	00005097          	auipc	ra,0x5
     c54:	c3a080e7          	jalr	-966(ra) # 588a <write>
     c58:	47a9                	li	a5,10
     c5a:	0af51c63          	bne	a0,a5,d12 <unlinkread+0x19a>
  close(fd);
     c5e:	8526                	mv	a0,s1
     c60:	00005097          	auipc	ra,0x5
     c64:	c32080e7          	jalr	-974(ra) # 5892 <close>
  unlink("unlinkread");
     c68:	00005517          	auipc	a0,0x5
     c6c:	29050513          	addi	a0,a0,656 # 5ef8 <malloc+0x258>
     c70:	00005097          	auipc	ra,0x5
     c74:	c4a080e7          	jalr	-950(ra) # 58ba <unlink>
}
     c78:	70a2                	ld	ra,40(sp)
     c7a:	7402                	ld	s0,32(sp)
     c7c:	64e2                	ld	s1,24(sp)
     c7e:	6942                	ld	s2,16(sp)
     c80:	69a2                	ld	s3,8(sp)
     c82:	6145                	addi	sp,sp,48
     c84:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c86:	85ce                	mv	a1,s3
     c88:	00006517          	auipc	a0,0x6
     c8c:	95050513          	addi	a0,a0,-1712 # 65d8 <malloc+0x938>
     c90:	00005097          	auipc	ra,0x5
     c94:	f52080e7          	jalr	-174(ra) # 5be2 <printf>
    exit(1);
     c98:	4505                	li	a0,1
     c9a:	00005097          	auipc	ra,0x5
     c9e:	bd0080e7          	jalr	-1072(ra) # 586a <exit>
    printf("%s: open unlinkread failed\n", s);
     ca2:	85ce                	mv	a1,s3
     ca4:	00006517          	auipc	a0,0x6
     ca8:	95c50513          	addi	a0,a0,-1700 # 6600 <malloc+0x960>
     cac:	00005097          	auipc	ra,0x5
     cb0:	f36080e7          	jalr	-202(ra) # 5be2 <printf>
    exit(1);
     cb4:	4505                	li	a0,1
     cb6:	00005097          	auipc	ra,0x5
     cba:	bb4080e7          	jalr	-1100(ra) # 586a <exit>
    printf("%s: unlink unlinkread failed\n", s);
     cbe:	85ce                	mv	a1,s3
     cc0:	00006517          	auipc	a0,0x6
     cc4:	96050513          	addi	a0,a0,-1696 # 6620 <malloc+0x980>
     cc8:	00005097          	auipc	ra,0x5
     ccc:	f1a080e7          	jalr	-230(ra) # 5be2 <printf>
    exit(1);
     cd0:	4505                	li	a0,1
     cd2:	00005097          	auipc	ra,0x5
     cd6:	b98080e7          	jalr	-1128(ra) # 586a <exit>
    printf("%s: unlinkread read failed", s);
     cda:	85ce                	mv	a1,s3
     cdc:	00006517          	auipc	a0,0x6
     ce0:	96c50513          	addi	a0,a0,-1684 # 6648 <malloc+0x9a8>
     ce4:	00005097          	auipc	ra,0x5
     ce8:	efe080e7          	jalr	-258(ra) # 5be2 <printf>
    exit(1);
     cec:	4505                	li	a0,1
     cee:	00005097          	auipc	ra,0x5
     cf2:	b7c080e7          	jalr	-1156(ra) # 586a <exit>
    printf("%s: unlinkread wrong data\n", s);
     cf6:	85ce                	mv	a1,s3
     cf8:	00006517          	auipc	a0,0x6
     cfc:	97050513          	addi	a0,a0,-1680 # 6668 <malloc+0x9c8>
     d00:	00005097          	auipc	ra,0x5
     d04:	ee2080e7          	jalr	-286(ra) # 5be2 <printf>
    exit(1);
     d08:	4505                	li	a0,1
     d0a:	00005097          	auipc	ra,0x5
     d0e:	b60080e7          	jalr	-1184(ra) # 586a <exit>
    printf("%s: unlinkread write failed\n", s);
     d12:	85ce                	mv	a1,s3
     d14:	00006517          	auipc	a0,0x6
     d18:	97450513          	addi	a0,a0,-1676 # 6688 <malloc+0x9e8>
     d1c:	00005097          	auipc	ra,0x5
     d20:	ec6080e7          	jalr	-314(ra) # 5be2 <printf>
    exit(1);
     d24:	4505                	li	a0,1
     d26:	00005097          	auipc	ra,0x5
     d2a:	b44080e7          	jalr	-1212(ra) # 586a <exit>

0000000000000d2e <linktest>:
{
     d2e:	1101                	addi	sp,sp,-32
     d30:	ec06                	sd	ra,24(sp)
     d32:	e822                	sd	s0,16(sp)
     d34:	e426                	sd	s1,8(sp)
     d36:	e04a                	sd	s2,0(sp)
     d38:	1000                	addi	s0,sp,32
     d3a:	892a                	mv	s2,a0
  unlink("lf1");
     d3c:	00006517          	auipc	a0,0x6
     d40:	96c50513          	addi	a0,a0,-1684 # 66a8 <malloc+0xa08>
     d44:	00005097          	auipc	ra,0x5
     d48:	b76080e7          	jalr	-1162(ra) # 58ba <unlink>
  unlink("lf2");
     d4c:	00006517          	auipc	a0,0x6
     d50:	96450513          	addi	a0,a0,-1692 # 66b0 <malloc+0xa10>
     d54:	00005097          	auipc	ra,0x5
     d58:	b66080e7          	jalr	-1178(ra) # 58ba <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d5c:	20200593          	li	a1,514
     d60:	00006517          	auipc	a0,0x6
     d64:	94850513          	addi	a0,a0,-1720 # 66a8 <malloc+0xa08>
     d68:	00005097          	auipc	ra,0x5
     d6c:	b42080e7          	jalr	-1214(ra) # 58aa <open>
  if(fd < 0){
     d70:	10054763          	bltz	a0,e7e <linktest+0x150>
     d74:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d76:	4615                	li	a2,5
     d78:	00006597          	auipc	a1,0x6
     d7c:	88058593          	addi	a1,a1,-1920 # 65f8 <malloc+0x958>
     d80:	00005097          	auipc	ra,0x5
     d84:	b0a080e7          	jalr	-1270(ra) # 588a <write>
     d88:	4795                	li	a5,5
     d8a:	10f51863          	bne	a0,a5,e9a <linktest+0x16c>
  close(fd);
     d8e:	8526                	mv	a0,s1
     d90:	00005097          	auipc	ra,0x5
     d94:	b02080e7          	jalr	-1278(ra) # 5892 <close>
  if(link("lf1", "lf2") < 0){
     d98:	00006597          	auipc	a1,0x6
     d9c:	91858593          	addi	a1,a1,-1768 # 66b0 <malloc+0xa10>
     da0:	00006517          	auipc	a0,0x6
     da4:	90850513          	addi	a0,a0,-1784 # 66a8 <malloc+0xa08>
     da8:	00005097          	auipc	ra,0x5
     dac:	b22080e7          	jalr	-1246(ra) # 58ca <link>
     db0:	10054363          	bltz	a0,eb6 <linktest+0x188>
  unlink("lf1");
     db4:	00006517          	auipc	a0,0x6
     db8:	8f450513          	addi	a0,a0,-1804 # 66a8 <malloc+0xa08>
     dbc:	00005097          	auipc	ra,0x5
     dc0:	afe080e7          	jalr	-1282(ra) # 58ba <unlink>
  if(open("lf1", 0) >= 0){
     dc4:	4581                	li	a1,0
     dc6:	00006517          	auipc	a0,0x6
     dca:	8e250513          	addi	a0,a0,-1822 # 66a8 <malloc+0xa08>
     dce:	00005097          	auipc	ra,0x5
     dd2:	adc080e7          	jalr	-1316(ra) # 58aa <open>
     dd6:	0e055e63          	bgez	a0,ed2 <linktest+0x1a4>
  fd = open("lf2", 0);
     dda:	4581                	li	a1,0
     ddc:	00006517          	auipc	a0,0x6
     de0:	8d450513          	addi	a0,a0,-1836 # 66b0 <malloc+0xa10>
     de4:	00005097          	auipc	ra,0x5
     de8:	ac6080e7          	jalr	-1338(ra) # 58aa <open>
     dec:	84aa                	mv	s1,a0
  if(fd < 0){
     dee:	10054063          	bltz	a0,eee <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     df2:	660d                	lui	a2,0x3
     df4:	0000b597          	auipc	a1,0xb
     df8:	fb458593          	addi	a1,a1,-76 # bda8 <buf>
     dfc:	00005097          	auipc	ra,0x5
     e00:	a86080e7          	jalr	-1402(ra) # 5882 <read>
     e04:	4795                	li	a5,5
     e06:	10f51263          	bne	a0,a5,f0a <linktest+0x1dc>
  close(fd);
     e0a:	8526                	mv	a0,s1
     e0c:	00005097          	auipc	ra,0x5
     e10:	a86080e7          	jalr	-1402(ra) # 5892 <close>
  if(link("lf2", "lf2") >= 0){
     e14:	00006597          	auipc	a1,0x6
     e18:	89c58593          	addi	a1,a1,-1892 # 66b0 <malloc+0xa10>
     e1c:	852e                	mv	a0,a1
     e1e:	00005097          	auipc	ra,0x5
     e22:	aac080e7          	jalr	-1364(ra) # 58ca <link>
     e26:	10055063          	bgez	a0,f26 <linktest+0x1f8>
  unlink("lf2");
     e2a:	00006517          	auipc	a0,0x6
     e2e:	88650513          	addi	a0,a0,-1914 # 66b0 <malloc+0xa10>
     e32:	00005097          	auipc	ra,0x5
     e36:	a88080e7          	jalr	-1400(ra) # 58ba <unlink>
  if(link("lf2", "lf1") >= 0){
     e3a:	00006597          	auipc	a1,0x6
     e3e:	86e58593          	addi	a1,a1,-1938 # 66a8 <malloc+0xa08>
     e42:	00006517          	auipc	a0,0x6
     e46:	86e50513          	addi	a0,a0,-1938 # 66b0 <malloc+0xa10>
     e4a:	00005097          	auipc	ra,0x5
     e4e:	a80080e7          	jalr	-1408(ra) # 58ca <link>
     e52:	0e055863          	bgez	a0,f42 <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e56:	00006597          	auipc	a1,0x6
     e5a:	85258593          	addi	a1,a1,-1966 # 66a8 <malloc+0xa08>
     e5e:	00006517          	auipc	a0,0x6
     e62:	95a50513          	addi	a0,a0,-1702 # 67b8 <malloc+0xb18>
     e66:	00005097          	auipc	ra,0x5
     e6a:	a64080e7          	jalr	-1436(ra) # 58ca <link>
     e6e:	0e055863          	bgez	a0,f5e <linktest+0x230>
}
     e72:	60e2                	ld	ra,24(sp)
     e74:	6442                	ld	s0,16(sp)
     e76:	64a2                	ld	s1,8(sp)
     e78:	6902                	ld	s2,0(sp)
     e7a:	6105                	addi	sp,sp,32
     e7c:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e7e:	85ca                	mv	a1,s2
     e80:	00006517          	auipc	a0,0x6
     e84:	83850513          	addi	a0,a0,-1992 # 66b8 <malloc+0xa18>
     e88:	00005097          	auipc	ra,0x5
     e8c:	d5a080e7          	jalr	-678(ra) # 5be2 <printf>
    exit(1);
     e90:	4505                	li	a0,1
     e92:	00005097          	auipc	ra,0x5
     e96:	9d8080e7          	jalr	-1576(ra) # 586a <exit>
    printf("%s: write lf1 failed\n", s);
     e9a:	85ca                	mv	a1,s2
     e9c:	00006517          	auipc	a0,0x6
     ea0:	83450513          	addi	a0,a0,-1996 # 66d0 <malloc+0xa30>
     ea4:	00005097          	auipc	ra,0x5
     ea8:	d3e080e7          	jalr	-706(ra) # 5be2 <printf>
    exit(1);
     eac:	4505                	li	a0,1
     eae:	00005097          	auipc	ra,0x5
     eb2:	9bc080e7          	jalr	-1604(ra) # 586a <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     eb6:	85ca                	mv	a1,s2
     eb8:	00006517          	auipc	a0,0x6
     ebc:	83050513          	addi	a0,a0,-2000 # 66e8 <malloc+0xa48>
     ec0:	00005097          	auipc	ra,0x5
     ec4:	d22080e7          	jalr	-734(ra) # 5be2 <printf>
    exit(1);
     ec8:	4505                	li	a0,1
     eca:	00005097          	auipc	ra,0x5
     ece:	9a0080e7          	jalr	-1632(ra) # 586a <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     ed2:	85ca                	mv	a1,s2
     ed4:	00006517          	auipc	a0,0x6
     ed8:	83450513          	addi	a0,a0,-1996 # 6708 <malloc+0xa68>
     edc:	00005097          	auipc	ra,0x5
     ee0:	d06080e7          	jalr	-762(ra) # 5be2 <printf>
    exit(1);
     ee4:	4505                	li	a0,1
     ee6:	00005097          	auipc	ra,0x5
     eea:	984080e7          	jalr	-1660(ra) # 586a <exit>
    printf("%s: open lf2 failed\n", s);
     eee:	85ca                	mv	a1,s2
     ef0:	00006517          	auipc	a0,0x6
     ef4:	84850513          	addi	a0,a0,-1976 # 6738 <malloc+0xa98>
     ef8:	00005097          	auipc	ra,0x5
     efc:	cea080e7          	jalr	-790(ra) # 5be2 <printf>
    exit(1);
     f00:	4505                	li	a0,1
     f02:	00005097          	auipc	ra,0x5
     f06:	968080e7          	jalr	-1688(ra) # 586a <exit>
    printf("%s: read lf2 failed\n", s);
     f0a:	85ca                	mv	a1,s2
     f0c:	00006517          	auipc	a0,0x6
     f10:	84450513          	addi	a0,a0,-1980 # 6750 <malloc+0xab0>
     f14:	00005097          	auipc	ra,0x5
     f18:	cce080e7          	jalr	-818(ra) # 5be2 <printf>
    exit(1);
     f1c:	4505                	li	a0,1
     f1e:	00005097          	auipc	ra,0x5
     f22:	94c080e7          	jalr	-1716(ra) # 586a <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f26:	85ca                	mv	a1,s2
     f28:	00006517          	auipc	a0,0x6
     f2c:	84050513          	addi	a0,a0,-1984 # 6768 <malloc+0xac8>
     f30:	00005097          	auipc	ra,0x5
     f34:	cb2080e7          	jalr	-846(ra) # 5be2 <printf>
    exit(1);
     f38:	4505                	li	a0,1
     f3a:	00005097          	auipc	ra,0x5
     f3e:	930080e7          	jalr	-1744(ra) # 586a <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     f42:	85ca                	mv	a1,s2
     f44:	00006517          	auipc	a0,0x6
     f48:	84c50513          	addi	a0,a0,-1972 # 6790 <malloc+0xaf0>
     f4c:	00005097          	auipc	ra,0x5
     f50:	c96080e7          	jalr	-874(ra) # 5be2 <printf>
    exit(1);
     f54:	4505                	li	a0,1
     f56:	00005097          	auipc	ra,0x5
     f5a:	914080e7          	jalr	-1772(ra) # 586a <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f5e:	85ca                	mv	a1,s2
     f60:	00006517          	auipc	a0,0x6
     f64:	86050513          	addi	a0,a0,-1952 # 67c0 <malloc+0xb20>
     f68:	00005097          	auipc	ra,0x5
     f6c:	c7a080e7          	jalr	-902(ra) # 5be2 <printf>
    exit(1);
     f70:	4505                	li	a0,1
     f72:	00005097          	auipc	ra,0x5
     f76:	8f8080e7          	jalr	-1800(ra) # 586a <exit>

0000000000000f7a <bigdir>:
{
     f7a:	715d                	addi	sp,sp,-80
     f7c:	e486                	sd	ra,72(sp)
     f7e:	e0a2                	sd	s0,64(sp)
     f80:	fc26                	sd	s1,56(sp)
     f82:	f84a                	sd	s2,48(sp)
     f84:	f44e                	sd	s3,40(sp)
     f86:	f052                	sd	s4,32(sp)
     f88:	ec56                	sd	s5,24(sp)
     f8a:	e85a                	sd	s6,16(sp)
     f8c:	0880                	addi	s0,sp,80
     f8e:	89aa                	mv	s3,a0
  unlink("bd");
     f90:	00006517          	auipc	a0,0x6
     f94:	85050513          	addi	a0,a0,-1968 # 67e0 <malloc+0xb40>
     f98:	00005097          	auipc	ra,0x5
     f9c:	922080e7          	jalr	-1758(ra) # 58ba <unlink>
  fd = open("bd", O_CREATE);
     fa0:	20000593          	li	a1,512
     fa4:	00006517          	auipc	a0,0x6
     fa8:	83c50513          	addi	a0,a0,-1988 # 67e0 <malloc+0xb40>
     fac:	00005097          	auipc	ra,0x5
     fb0:	8fe080e7          	jalr	-1794(ra) # 58aa <open>
  if(fd < 0){
     fb4:	0c054963          	bltz	a0,1086 <bigdir+0x10c>
  close(fd);
     fb8:	00005097          	auipc	ra,0x5
     fbc:	8da080e7          	jalr	-1830(ra) # 5892 <close>
  for(i = 0; i < N; i++){
     fc0:	4901                	li	s2,0
    name[0] = 'x';
     fc2:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fc6:	00006a17          	auipc	s4,0x6
     fca:	81aa0a13          	addi	s4,s4,-2022 # 67e0 <malloc+0xb40>
  for(i = 0; i < N; i++){
     fce:	1f400b13          	li	s6,500
    name[0] = 'x';
     fd2:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fd6:	41f9579b          	sraiw	a5,s2,0x1f
     fda:	01a7d71b          	srliw	a4,a5,0x1a
     fde:	012707bb          	addw	a5,a4,s2
     fe2:	4067d69b          	sraiw	a3,a5,0x6
     fe6:	0306869b          	addiw	a3,a3,48
     fea:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fee:	03f7f793          	andi	a5,a5,63
     ff2:	9f99                	subw	a5,a5,a4
     ff4:	0307879b          	addiw	a5,a5,48
     ff8:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     ffc:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1000:	fb040593          	addi	a1,s0,-80
    1004:	8552                	mv	a0,s4
    1006:	00005097          	auipc	ra,0x5
    100a:	8c4080e7          	jalr	-1852(ra) # 58ca <link>
    100e:	84aa                	mv	s1,a0
    1010:	e949                	bnez	a0,10a2 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1012:	2905                	addiw	s2,s2,1
    1014:	fb691fe3          	bne	s2,s6,fd2 <bigdir+0x58>
  unlink("bd");
    1018:	00005517          	auipc	a0,0x5
    101c:	7c850513          	addi	a0,a0,1992 # 67e0 <malloc+0xb40>
    1020:	00005097          	auipc	ra,0x5
    1024:	89a080e7          	jalr	-1894(ra) # 58ba <unlink>
    name[0] = 'x';
    1028:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    102c:	1f400a13          	li	s4,500
    name[0] = 'x';
    1030:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1034:	41f4d79b          	sraiw	a5,s1,0x1f
    1038:	01a7d71b          	srliw	a4,a5,0x1a
    103c:	009707bb          	addw	a5,a4,s1
    1040:	4067d69b          	sraiw	a3,a5,0x6
    1044:	0306869b          	addiw	a3,a3,48
    1048:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    104c:	03f7f793          	andi	a5,a5,63
    1050:	9f99                	subw	a5,a5,a4
    1052:	0307879b          	addiw	a5,a5,48
    1056:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    105a:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    105e:	fb040513          	addi	a0,s0,-80
    1062:	00005097          	auipc	ra,0x5
    1066:	858080e7          	jalr	-1960(ra) # 58ba <unlink>
    106a:	ed21                	bnez	a0,10c2 <bigdir+0x148>
  for(i = 0; i < N; i++){
    106c:	2485                	addiw	s1,s1,1
    106e:	fd4491e3          	bne	s1,s4,1030 <bigdir+0xb6>
}
    1072:	60a6                	ld	ra,72(sp)
    1074:	6406                	ld	s0,64(sp)
    1076:	74e2                	ld	s1,56(sp)
    1078:	7942                	ld	s2,48(sp)
    107a:	79a2                	ld	s3,40(sp)
    107c:	7a02                	ld	s4,32(sp)
    107e:	6ae2                	ld	s5,24(sp)
    1080:	6b42                	ld	s6,16(sp)
    1082:	6161                	addi	sp,sp,80
    1084:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1086:	85ce                	mv	a1,s3
    1088:	00005517          	auipc	a0,0x5
    108c:	76050513          	addi	a0,a0,1888 # 67e8 <malloc+0xb48>
    1090:	00005097          	auipc	ra,0x5
    1094:	b52080e7          	jalr	-1198(ra) # 5be2 <printf>
    exit(1);
    1098:	4505                	li	a0,1
    109a:	00004097          	auipc	ra,0x4
    109e:	7d0080e7          	jalr	2000(ra) # 586a <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    10a2:	fb040613          	addi	a2,s0,-80
    10a6:	85ce                	mv	a1,s3
    10a8:	00005517          	auipc	a0,0x5
    10ac:	76050513          	addi	a0,a0,1888 # 6808 <malloc+0xb68>
    10b0:	00005097          	auipc	ra,0x5
    10b4:	b32080e7          	jalr	-1230(ra) # 5be2 <printf>
      exit(1);
    10b8:	4505                	li	a0,1
    10ba:	00004097          	auipc	ra,0x4
    10be:	7b0080e7          	jalr	1968(ra) # 586a <exit>
      printf("%s: bigdir unlink failed", s);
    10c2:	85ce                	mv	a1,s3
    10c4:	00005517          	auipc	a0,0x5
    10c8:	76450513          	addi	a0,a0,1892 # 6828 <malloc+0xb88>
    10cc:	00005097          	auipc	ra,0x5
    10d0:	b16080e7          	jalr	-1258(ra) # 5be2 <printf>
      exit(1);
    10d4:	4505                	li	a0,1
    10d6:	00004097          	auipc	ra,0x4
    10da:	794080e7          	jalr	1940(ra) # 586a <exit>

00000000000010de <validatetest>:
{
    10de:	7139                	addi	sp,sp,-64
    10e0:	fc06                	sd	ra,56(sp)
    10e2:	f822                	sd	s0,48(sp)
    10e4:	f426                	sd	s1,40(sp)
    10e6:	f04a                	sd	s2,32(sp)
    10e8:	ec4e                	sd	s3,24(sp)
    10ea:	e852                	sd	s4,16(sp)
    10ec:	e456                	sd	s5,8(sp)
    10ee:	e05a                	sd	s6,0(sp)
    10f0:	0080                	addi	s0,sp,64
    10f2:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10f4:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10f6:	00005997          	auipc	s3,0x5
    10fa:	75298993          	addi	s3,s3,1874 # 6848 <malloc+0xba8>
    10fe:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1100:	6a85                	lui	s5,0x1
    1102:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1106:	85a6                	mv	a1,s1
    1108:	854e                	mv	a0,s3
    110a:	00004097          	auipc	ra,0x4
    110e:	7c0080e7          	jalr	1984(ra) # 58ca <link>
    1112:	01251f63          	bne	a0,s2,1130 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1116:	94d6                	add	s1,s1,s5
    1118:	ff4497e3          	bne	s1,s4,1106 <validatetest+0x28>
}
    111c:	70e2                	ld	ra,56(sp)
    111e:	7442                	ld	s0,48(sp)
    1120:	74a2                	ld	s1,40(sp)
    1122:	7902                	ld	s2,32(sp)
    1124:	69e2                	ld	s3,24(sp)
    1126:	6a42                	ld	s4,16(sp)
    1128:	6aa2                	ld	s5,8(sp)
    112a:	6b02                	ld	s6,0(sp)
    112c:	6121                	addi	sp,sp,64
    112e:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1130:	85da                	mv	a1,s6
    1132:	00005517          	auipc	a0,0x5
    1136:	72650513          	addi	a0,a0,1830 # 6858 <malloc+0xbb8>
    113a:	00005097          	auipc	ra,0x5
    113e:	aa8080e7          	jalr	-1368(ra) # 5be2 <printf>
      exit(1);
    1142:	4505                	li	a0,1
    1144:	00004097          	auipc	ra,0x4
    1148:	726080e7          	jalr	1830(ra) # 586a <exit>

000000000000114c <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    114c:	7179                	addi	sp,sp,-48
    114e:	f406                	sd	ra,40(sp)
    1150:	f022                	sd	s0,32(sp)
    1152:	ec26                	sd	s1,24(sp)
    1154:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    1156:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    115a:	00007497          	auipc	s1,0x7
    115e:	4264b483          	ld	s1,1062(s1) # 8580 <__SDATA_BEGIN__>
    1162:	fd840593          	addi	a1,s0,-40
    1166:	8526                	mv	a0,s1
    1168:	00004097          	auipc	ra,0x4
    116c:	73a080e7          	jalr	1850(ra) # 58a2 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1170:	8526                	mv	a0,s1
    1172:	00004097          	auipc	ra,0x4
    1176:	708080e7          	jalr	1800(ra) # 587a <pipe>

  exit(0);
    117a:	4501                	li	a0,0
    117c:	00004097          	auipc	ra,0x4
    1180:	6ee080e7          	jalr	1774(ra) # 586a <exit>

0000000000001184 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1184:	7139                	addi	sp,sp,-64
    1186:	fc06                	sd	ra,56(sp)
    1188:	f822                	sd	s0,48(sp)
    118a:	f426                	sd	s1,40(sp)
    118c:	f04a                	sd	s2,32(sp)
    118e:	ec4e                	sd	s3,24(sp)
    1190:	0080                	addi	s0,sp,64
    1192:	64b1                	lui	s1,0xc
    1194:	35048493          	addi	s1,s1,848 # c350 <buf+0x5a8>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1198:	597d                	li	s2,-1
    119a:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    119e:	00005997          	auipc	s3,0x5
    11a2:	f8298993          	addi	s3,s3,-126 # 6120 <malloc+0x480>
    argv[0] = (char*)0xffffffff;
    11a6:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    11aa:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    11ae:	fc040593          	addi	a1,s0,-64
    11b2:	854e                	mv	a0,s3
    11b4:	00004097          	auipc	ra,0x4
    11b8:	6ee080e7          	jalr	1774(ra) # 58a2 <exec>
  for(int i = 0; i < 50000; i++){
    11bc:	34fd                	addiw	s1,s1,-1
    11be:	f4e5                	bnez	s1,11a6 <badarg+0x22>
  }
  
  exit(0);
    11c0:	4501                	li	a0,0
    11c2:	00004097          	auipc	ra,0x4
    11c6:	6a8080e7          	jalr	1704(ra) # 586a <exit>

00000000000011ca <copyinstr2>:
{
    11ca:	7155                	addi	sp,sp,-208
    11cc:	e586                	sd	ra,200(sp)
    11ce:	e1a2                	sd	s0,192(sp)
    11d0:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11d2:	f6840793          	addi	a5,s0,-152
    11d6:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11da:	07800713          	li	a4,120
    11de:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11e2:	0785                	addi	a5,a5,1
    11e4:	fed79de3          	bne	a5,a3,11de <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11e8:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11ec:	f6840513          	addi	a0,s0,-152
    11f0:	00004097          	auipc	ra,0x4
    11f4:	6ca080e7          	jalr	1738(ra) # 58ba <unlink>
  if(ret != -1){
    11f8:	57fd                	li	a5,-1
    11fa:	0ef51063          	bne	a0,a5,12da <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11fe:	20100593          	li	a1,513
    1202:	f6840513          	addi	a0,s0,-152
    1206:	00004097          	auipc	ra,0x4
    120a:	6a4080e7          	jalr	1700(ra) # 58aa <open>
  if(fd != -1){
    120e:	57fd                	li	a5,-1
    1210:	0ef51563          	bne	a0,a5,12fa <copyinstr2+0x130>
  ret = link(b, b);
    1214:	f6840593          	addi	a1,s0,-152
    1218:	852e                	mv	a0,a1
    121a:	00004097          	auipc	ra,0x4
    121e:	6b0080e7          	jalr	1712(ra) # 58ca <link>
  if(ret != -1){
    1222:	57fd                	li	a5,-1
    1224:	0ef51b63          	bne	a0,a5,131a <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1228:	00007797          	auipc	a5,0x7
    122c:	81878793          	addi	a5,a5,-2024 # 7a40 <malloc+0x1da0>
    1230:	f4f43c23          	sd	a5,-168(s0)
    1234:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1238:	f5840593          	addi	a1,s0,-168
    123c:	f6840513          	addi	a0,s0,-152
    1240:	00004097          	auipc	ra,0x4
    1244:	662080e7          	jalr	1634(ra) # 58a2 <exec>
  if(ret != -1){
    1248:	57fd                	li	a5,-1
    124a:	0ef51963          	bne	a0,a5,133c <copyinstr2+0x172>
  int pid = fork();
    124e:	00004097          	auipc	ra,0x4
    1252:	614080e7          	jalr	1556(ra) # 5862 <fork>
  if(pid < 0){
    1256:	10054363          	bltz	a0,135c <copyinstr2+0x192>
  if(pid == 0){
    125a:	12051463          	bnez	a0,1382 <copyinstr2+0x1b8>
    125e:	00007797          	auipc	a5,0x7
    1262:	43278793          	addi	a5,a5,1074 # 8690 <big.1270>
    1266:	00008697          	auipc	a3,0x8
    126a:	42a68693          	addi	a3,a3,1066 # 9690 <__global_pointer$+0x910>
      big[i] = 'x';
    126e:	07800713          	li	a4,120
    1272:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1276:	0785                	addi	a5,a5,1
    1278:	fed79de3          	bne	a5,a3,1272 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    127c:	00008797          	auipc	a5,0x8
    1280:	40078a23          	sb	zero,1044(a5) # 9690 <__global_pointer$+0x910>
    char *args2[] = { big, big, big, 0 };
    1284:	00007797          	auipc	a5,0x7
    1288:	ecc78793          	addi	a5,a5,-308 # 8150 <malloc+0x24b0>
    128c:	6390                	ld	a2,0(a5)
    128e:	6794                	ld	a3,8(a5)
    1290:	6b98                	ld	a4,16(a5)
    1292:	6f9c                	ld	a5,24(a5)
    1294:	f2c43823          	sd	a2,-208(s0)
    1298:	f2d43c23          	sd	a3,-200(s0)
    129c:	f4e43023          	sd	a4,-192(s0)
    12a0:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    12a4:	f3040593          	addi	a1,s0,-208
    12a8:	00005517          	auipc	a0,0x5
    12ac:	e7850513          	addi	a0,a0,-392 # 6120 <malloc+0x480>
    12b0:	00004097          	auipc	ra,0x4
    12b4:	5f2080e7          	jalr	1522(ra) # 58a2 <exec>
    if(ret != -1){
    12b8:	57fd                	li	a5,-1
    12ba:	0af50e63          	beq	a0,a5,1376 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12be:	55fd                	li	a1,-1
    12c0:	00005517          	auipc	a0,0x5
    12c4:	64050513          	addi	a0,a0,1600 # 6900 <malloc+0xc60>
    12c8:	00005097          	auipc	ra,0x5
    12cc:	91a080e7          	jalr	-1766(ra) # 5be2 <printf>
      exit(1);
    12d0:	4505                	li	a0,1
    12d2:	00004097          	auipc	ra,0x4
    12d6:	598080e7          	jalr	1432(ra) # 586a <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12da:	862a                	mv	a2,a0
    12dc:	f6840593          	addi	a1,s0,-152
    12e0:	00005517          	auipc	a0,0x5
    12e4:	59850513          	addi	a0,a0,1432 # 6878 <malloc+0xbd8>
    12e8:	00005097          	auipc	ra,0x5
    12ec:	8fa080e7          	jalr	-1798(ra) # 5be2 <printf>
    exit(1);
    12f0:	4505                	li	a0,1
    12f2:	00004097          	auipc	ra,0x4
    12f6:	578080e7          	jalr	1400(ra) # 586a <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12fa:	862a                	mv	a2,a0
    12fc:	f6840593          	addi	a1,s0,-152
    1300:	00005517          	auipc	a0,0x5
    1304:	59850513          	addi	a0,a0,1432 # 6898 <malloc+0xbf8>
    1308:	00005097          	auipc	ra,0x5
    130c:	8da080e7          	jalr	-1830(ra) # 5be2 <printf>
    exit(1);
    1310:	4505                	li	a0,1
    1312:	00004097          	auipc	ra,0x4
    1316:	558080e7          	jalr	1368(ra) # 586a <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    131a:	86aa                	mv	a3,a0
    131c:	f6840613          	addi	a2,s0,-152
    1320:	85b2                	mv	a1,a2
    1322:	00005517          	auipc	a0,0x5
    1326:	59650513          	addi	a0,a0,1430 # 68b8 <malloc+0xc18>
    132a:	00005097          	auipc	ra,0x5
    132e:	8b8080e7          	jalr	-1864(ra) # 5be2 <printf>
    exit(1);
    1332:	4505                	li	a0,1
    1334:	00004097          	auipc	ra,0x4
    1338:	536080e7          	jalr	1334(ra) # 586a <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    133c:	567d                	li	a2,-1
    133e:	f6840593          	addi	a1,s0,-152
    1342:	00005517          	auipc	a0,0x5
    1346:	59e50513          	addi	a0,a0,1438 # 68e0 <malloc+0xc40>
    134a:	00005097          	auipc	ra,0x5
    134e:	898080e7          	jalr	-1896(ra) # 5be2 <printf>
    exit(1);
    1352:	4505                	li	a0,1
    1354:	00004097          	auipc	ra,0x4
    1358:	516080e7          	jalr	1302(ra) # 586a <exit>
    printf("fork failed\n");
    135c:	00006517          	auipc	a0,0x6
    1360:	a1c50513          	addi	a0,a0,-1508 # 6d78 <malloc+0x10d8>
    1364:	00005097          	auipc	ra,0x5
    1368:	87e080e7          	jalr	-1922(ra) # 5be2 <printf>
    exit(1);
    136c:	4505                	li	a0,1
    136e:	00004097          	auipc	ra,0x4
    1372:	4fc080e7          	jalr	1276(ra) # 586a <exit>
    exit(747); // OK
    1376:	2eb00513          	li	a0,747
    137a:	00004097          	auipc	ra,0x4
    137e:	4f0080e7          	jalr	1264(ra) # 586a <exit>
  int st = 0;
    1382:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1386:	f5440513          	addi	a0,s0,-172
    138a:	00004097          	auipc	ra,0x4
    138e:	4e8080e7          	jalr	1256(ra) # 5872 <wait>
  if(st != 747){
    1392:	f5442703          	lw	a4,-172(s0)
    1396:	2eb00793          	li	a5,747
    139a:	00f71663          	bne	a4,a5,13a6 <copyinstr2+0x1dc>
}
    139e:	60ae                	ld	ra,200(sp)
    13a0:	640e                	ld	s0,192(sp)
    13a2:	6169                	addi	sp,sp,208
    13a4:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    13a6:	00005517          	auipc	a0,0x5
    13aa:	58250513          	addi	a0,a0,1410 # 6928 <malloc+0xc88>
    13ae:	00005097          	auipc	ra,0x5
    13b2:	834080e7          	jalr	-1996(ra) # 5be2 <printf>
    exit(1);
    13b6:	4505                	li	a0,1
    13b8:	00004097          	auipc	ra,0x4
    13bc:	4b2080e7          	jalr	1202(ra) # 586a <exit>

00000000000013c0 <truncate3>:
{
    13c0:	7159                	addi	sp,sp,-112
    13c2:	f486                	sd	ra,104(sp)
    13c4:	f0a2                	sd	s0,96(sp)
    13c6:	eca6                	sd	s1,88(sp)
    13c8:	e8ca                	sd	s2,80(sp)
    13ca:	e4ce                	sd	s3,72(sp)
    13cc:	e0d2                	sd	s4,64(sp)
    13ce:	fc56                	sd	s5,56(sp)
    13d0:	1880                	addi	s0,sp,112
    13d2:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13d4:	60100593          	li	a1,1537
    13d8:	00005517          	auipc	a0,0x5
    13dc:	da050513          	addi	a0,a0,-608 # 6178 <malloc+0x4d8>
    13e0:	00004097          	auipc	ra,0x4
    13e4:	4ca080e7          	jalr	1226(ra) # 58aa <open>
    13e8:	00004097          	auipc	ra,0x4
    13ec:	4aa080e7          	jalr	1194(ra) # 5892 <close>
  pid = fork();
    13f0:	00004097          	auipc	ra,0x4
    13f4:	472080e7          	jalr	1138(ra) # 5862 <fork>
  if(pid < 0){
    13f8:	08054063          	bltz	a0,1478 <truncate3+0xb8>
  if(pid == 0){
    13fc:	e969                	bnez	a0,14ce <truncate3+0x10e>
    13fe:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    1402:	00005a17          	auipc	s4,0x5
    1406:	d76a0a13          	addi	s4,s4,-650 # 6178 <malloc+0x4d8>
      int n = write(fd, "1234567890", 10);
    140a:	00005a97          	auipc	s5,0x5
    140e:	57ea8a93          	addi	s5,s5,1406 # 6988 <malloc+0xce8>
      int fd = open("truncfile", O_WRONLY);
    1412:	4585                	li	a1,1
    1414:	8552                	mv	a0,s4
    1416:	00004097          	auipc	ra,0x4
    141a:	494080e7          	jalr	1172(ra) # 58aa <open>
    141e:	84aa                	mv	s1,a0
      if(fd < 0){
    1420:	06054a63          	bltz	a0,1494 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    1424:	4629                	li	a2,10
    1426:	85d6                	mv	a1,s5
    1428:	00004097          	auipc	ra,0x4
    142c:	462080e7          	jalr	1122(ra) # 588a <write>
      if(n != 10){
    1430:	47a9                	li	a5,10
    1432:	06f51f63          	bne	a0,a5,14b0 <truncate3+0xf0>
      close(fd);
    1436:	8526                	mv	a0,s1
    1438:	00004097          	auipc	ra,0x4
    143c:	45a080e7          	jalr	1114(ra) # 5892 <close>
      fd = open("truncfile", O_RDONLY);
    1440:	4581                	li	a1,0
    1442:	8552                	mv	a0,s4
    1444:	00004097          	auipc	ra,0x4
    1448:	466080e7          	jalr	1126(ra) # 58aa <open>
    144c:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    144e:	02000613          	li	a2,32
    1452:	f9840593          	addi	a1,s0,-104
    1456:	00004097          	auipc	ra,0x4
    145a:	42c080e7          	jalr	1068(ra) # 5882 <read>
      close(fd);
    145e:	8526                	mv	a0,s1
    1460:	00004097          	auipc	ra,0x4
    1464:	432080e7          	jalr	1074(ra) # 5892 <close>
    for(int i = 0; i < 100; i++){
    1468:	39fd                	addiw	s3,s3,-1
    146a:	fa0994e3          	bnez	s3,1412 <truncate3+0x52>
    exit(0);
    146e:	4501                	li	a0,0
    1470:	00004097          	auipc	ra,0x4
    1474:	3fa080e7          	jalr	1018(ra) # 586a <exit>
    printf("%s: fork failed\n", s);
    1478:	85ca                	mv	a1,s2
    147a:	00005517          	auipc	a0,0x5
    147e:	4de50513          	addi	a0,a0,1246 # 6958 <malloc+0xcb8>
    1482:	00004097          	auipc	ra,0x4
    1486:	760080e7          	jalr	1888(ra) # 5be2 <printf>
    exit(1);
    148a:	4505                	li	a0,1
    148c:	00004097          	auipc	ra,0x4
    1490:	3de080e7          	jalr	990(ra) # 586a <exit>
        printf("%s: open failed\n", s);
    1494:	85ca                	mv	a1,s2
    1496:	00005517          	auipc	a0,0x5
    149a:	4da50513          	addi	a0,a0,1242 # 6970 <malloc+0xcd0>
    149e:	00004097          	auipc	ra,0x4
    14a2:	744080e7          	jalr	1860(ra) # 5be2 <printf>
        exit(1);
    14a6:	4505                	li	a0,1
    14a8:	00004097          	auipc	ra,0x4
    14ac:	3c2080e7          	jalr	962(ra) # 586a <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    14b0:	862a                	mv	a2,a0
    14b2:	85ca                	mv	a1,s2
    14b4:	00005517          	auipc	a0,0x5
    14b8:	4e450513          	addi	a0,a0,1252 # 6998 <malloc+0xcf8>
    14bc:	00004097          	auipc	ra,0x4
    14c0:	726080e7          	jalr	1830(ra) # 5be2 <printf>
        exit(1);
    14c4:	4505                	li	a0,1
    14c6:	00004097          	auipc	ra,0x4
    14ca:	3a4080e7          	jalr	932(ra) # 586a <exit>
    14ce:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14d2:	00005a17          	auipc	s4,0x5
    14d6:	ca6a0a13          	addi	s4,s4,-858 # 6178 <malloc+0x4d8>
    int n = write(fd, "xxx", 3);
    14da:	00005a97          	auipc	s5,0x5
    14de:	4dea8a93          	addi	s5,s5,1246 # 69b8 <malloc+0xd18>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14e2:	60100593          	li	a1,1537
    14e6:	8552                	mv	a0,s4
    14e8:	00004097          	auipc	ra,0x4
    14ec:	3c2080e7          	jalr	962(ra) # 58aa <open>
    14f0:	84aa                	mv	s1,a0
    if(fd < 0){
    14f2:	04054763          	bltz	a0,1540 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14f6:	460d                	li	a2,3
    14f8:	85d6                	mv	a1,s5
    14fa:	00004097          	auipc	ra,0x4
    14fe:	390080e7          	jalr	912(ra) # 588a <write>
    if(n != 3){
    1502:	478d                	li	a5,3
    1504:	04f51c63          	bne	a0,a5,155c <truncate3+0x19c>
    close(fd);
    1508:	8526                	mv	a0,s1
    150a:	00004097          	auipc	ra,0x4
    150e:	388080e7          	jalr	904(ra) # 5892 <close>
  for(int i = 0; i < 150; i++){
    1512:	39fd                	addiw	s3,s3,-1
    1514:	fc0997e3          	bnez	s3,14e2 <truncate3+0x122>
  wait(&xstatus);
    1518:	fbc40513          	addi	a0,s0,-68
    151c:	00004097          	auipc	ra,0x4
    1520:	356080e7          	jalr	854(ra) # 5872 <wait>
  unlink("truncfile");
    1524:	00005517          	auipc	a0,0x5
    1528:	c5450513          	addi	a0,a0,-940 # 6178 <malloc+0x4d8>
    152c:	00004097          	auipc	ra,0x4
    1530:	38e080e7          	jalr	910(ra) # 58ba <unlink>
  exit(xstatus);
    1534:	fbc42503          	lw	a0,-68(s0)
    1538:	00004097          	auipc	ra,0x4
    153c:	332080e7          	jalr	818(ra) # 586a <exit>
      printf("%s: open failed\n", s);
    1540:	85ca                	mv	a1,s2
    1542:	00005517          	auipc	a0,0x5
    1546:	42e50513          	addi	a0,a0,1070 # 6970 <malloc+0xcd0>
    154a:	00004097          	auipc	ra,0x4
    154e:	698080e7          	jalr	1688(ra) # 5be2 <printf>
      exit(1);
    1552:	4505                	li	a0,1
    1554:	00004097          	auipc	ra,0x4
    1558:	316080e7          	jalr	790(ra) # 586a <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    155c:	862a                	mv	a2,a0
    155e:	85ca                	mv	a1,s2
    1560:	00005517          	auipc	a0,0x5
    1564:	46050513          	addi	a0,a0,1120 # 69c0 <malloc+0xd20>
    1568:	00004097          	auipc	ra,0x4
    156c:	67a080e7          	jalr	1658(ra) # 5be2 <printf>
      exit(1);
    1570:	4505                	li	a0,1
    1572:	00004097          	auipc	ra,0x4
    1576:	2f8080e7          	jalr	760(ra) # 586a <exit>

000000000000157a <exectest>:
{
    157a:	715d                	addi	sp,sp,-80
    157c:	e486                	sd	ra,72(sp)
    157e:	e0a2                	sd	s0,64(sp)
    1580:	fc26                	sd	s1,56(sp)
    1582:	f84a                	sd	s2,48(sp)
    1584:	0880                	addi	s0,sp,80
    1586:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1588:	00005797          	auipc	a5,0x5
    158c:	b9878793          	addi	a5,a5,-1128 # 6120 <malloc+0x480>
    1590:	fcf43023          	sd	a5,-64(s0)
    1594:	00005797          	auipc	a5,0x5
    1598:	44c78793          	addi	a5,a5,1100 # 69e0 <malloc+0xd40>
    159c:	fcf43423          	sd	a5,-56(s0)
    15a0:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    15a4:	00005517          	auipc	a0,0x5
    15a8:	44450513          	addi	a0,a0,1092 # 69e8 <malloc+0xd48>
    15ac:	00004097          	auipc	ra,0x4
    15b0:	30e080e7          	jalr	782(ra) # 58ba <unlink>
  pid = fork();
    15b4:	00004097          	auipc	ra,0x4
    15b8:	2ae080e7          	jalr	686(ra) # 5862 <fork>
  if(pid < 0) {
    15bc:	04054663          	bltz	a0,1608 <exectest+0x8e>
    15c0:	84aa                	mv	s1,a0
  if(pid == 0) {
    15c2:	e959                	bnez	a0,1658 <exectest+0xde>
    close(1);
    15c4:	4505                	li	a0,1
    15c6:	00004097          	auipc	ra,0x4
    15ca:	2cc080e7          	jalr	716(ra) # 5892 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15ce:	20100593          	li	a1,513
    15d2:	00005517          	auipc	a0,0x5
    15d6:	41650513          	addi	a0,a0,1046 # 69e8 <malloc+0xd48>
    15da:	00004097          	auipc	ra,0x4
    15de:	2d0080e7          	jalr	720(ra) # 58aa <open>
    if(fd < 0) {
    15e2:	04054163          	bltz	a0,1624 <exectest+0xaa>
    if(fd != 1) {
    15e6:	4785                	li	a5,1
    15e8:	04f50c63          	beq	a0,a5,1640 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15ec:	85ca                	mv	a1,s2
    15ee:	00005517          	auipc	a0,0x5
    15f2:	41a50513          	addi	a0,a0,1050 # 6a08 <malloc+0xd68>
    15f6:	00004097          	auipc	ra,0x4
    15fa:	5ec080e7          	jalr	1516(ra) # 5be2 <printf>
      exit(1);
    15fe:	4505                	li	a0,1
    1600:	00004097          	auipc	ra,0x4
    1604:	26a080e7          	jalr	618(ra) # 586a <exit>
     printf("%s: fork failed\n", s);
    1608:	85ca                	mv	a1,s2
    160a:	00005517          	auipc	a0,0x5
    160e:	34e50513          	addi	a0,a0,846 # 6958 <malloc+0xcb8>
    1612:	00004097          	auipc	ra,0x4
    1616:	5d0080e7          	jalr	1488(ra) # 5be2 <printf>
     exit(1);
    161a:	4505                	li	a0,1
    161c:	00004097          	auipc	ra,0x4
    1620:	24e080e7          	jalr	590(ra) # 586a <exit>
      printf("%s: create failed\n", s);
    1624:	85ca                	mv	a1,s2
    1626:	00005517          	auipc	a0,0x5
    162a:	3ca50513          	addi	a0,a0,970 # 69f0 <malloc+0xd50>
    162e:	00004097          	auipc	ra,0x4
    1632:	5b4080e7          	jalr	1460(ra) # 5be2 <printf>
      exit(1);
    1636:	4505                	li	a0,1
    1638:	00004097          	auipc	ra,0x4
    163c:	232080e7          	jalr	562(ra) # 586a <exit>
    if(exec("echo", echoargv) < 0){
    1640:	fc040593          	addi	a1,s0,-64
    1644:	00005517          	auipc	a0,0x5
    1648:	adc50513          	addi	a0,a0,-1316 # 6120 <malloc+0x480>
    164c:	00004097          	auipc	ra,0x4
    1650:	256080e7          	jalr	598(ra) # 58a2 <exec>
    1654:	02054163          	bltz	a0,1676 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1658:	fdc40513          	addi	a0,s0,-36
    165c:	00004097          	auipc	ra,0x4
    1660:	216080e7          	jalr	534(ra) # 5872 <wait>
    1664:	02951763          	bne	a0,s1,1692 <exectest+0x118>
  if(xstatus != 0)
    1668:	fdc42503          	lw	a0,-36(s0)
    166c:	cd0d                	beqz	a0,16a6 <exectest+0x12c>
    exit(xstatus);
    166e:	00004097          	auipc	ra,0x4
    1672:	1fc080e7          	jalr	508(ra) # 586a <exit>
      printf("%s: exec echo failed\n", s);
    1676:	85ca                	mv	a1,s2
    1678:	00005517          	auipc	a0,0x5
    167c:	3a050513          	addi	a0,a0,928 # 6a18 <malloc+0xd78>
    1680:	00004097          	auipc	ra,0x4
    1684:	562080e7          	jalr	1378(ra) # 5be2 <printf>
      exit(1);
    1688:	4505                	li	a0,1
    168a:	00004097          	auipc	ra,0x4
    168e:	1e0080e7          	jalr	480(ra) # 586a <exit>
    printf("%s: wait failed!\n", s);
    1692:	85ca                	mv	a1,s2
    1694:	00005517          	auipc	a0,0x5
    1698:	39c50513          	addi	a0,a0,924 # 6a30 <malloc+0xd90>
    169c:	00004097          	auipc	ra,0x4
    16a0:	546080e7          	jalr	1350(ra) # 5be2 <printf>
    16a4:	b7d1                	j	1668 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    16a6:	4581                	li	a1,0
    16a8:	00005517          	auipc	a0,0x5
    16ac:	34050513          	addi	a0,a0,832 # 69e8 <malloc+0xd48>
    16b0:	00004097          	auipc	ra,0x4
    16b4:	1fa080e7          	jalr	506(ra) # 58aa <open>
  if(fd < 0) {
    16b8:	02054a63          	bltz	a0,16ec <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16bc:	4609                	li	a2,2
    16be:	fb840593          	addi	a1,s0,-72
    16c2:	00004097          	auipc	ra,0x4
    16c6:	1c0080e7          	jalr	448(ra) # 5882 <read>
    16ca:	4789                	li	a5,2
    16cc:	02f50e63          	beq	a0,a5,1708 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16d0:	85ca                	mv	a1,s2
    16d2:	00005517          	auipc	a0,0x5
    16d6:	dde50513          	addi	a0,a0,-546 # 64b0 <malloc+0x810>
    16da:	00004097          	auipc	ra,0x4
    16de:	508080e7          	jalr	1288(ra) # 5be2 <printf>
    exit(1);
    16e2:	4505                	li	a0,1
    16e4:	00004097          	auipc	ra,0x4
    16e8:	186080e7          	jalr	390(ra) # 586a <exit>
    printf("%s: open failed\n", s);
    16ec:	85ca                	mv	a1,s2
    16ee:	00005517          	auipc	a0,0x5
    16f2:	28250513          	addi	a0,a0,642 # 6970 <malloc+0xcd0>
    16f6:	00004097          	auipc	ra,0x4
    16fa:	4ec080e7          	jalr	1260(ra) # 5be2 <printf>
    exit(1);
    16fe:	4505                	li	a0,1
    1700:	00004097          	auipc	ra,0x4
    1704:	16a080e7          	jalr	362(ra) # 586a <exit>
  unlink("echo-ok");
    1708:	00005517          	auipc	a0,0x5
    170c:	2e050513          	addi	a0,a0,736 # 69e8 <malloc+0xd48>
    1710:	00004097          	auipc	ra,0x4
    1714:	1aa080e7          	jalr	426(ra) # 58ba <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1718:	fb844703          	lbu	a4,-72(s0)
    171c:	04f00793          	li	a5,79
    1720:	00f71863          	bne	a4,a5,1730 <exectest+0x1b6>
    1724:	fb944703          	lbu	a4,-71(s0)
    1728:	04b00793          	li	a5,75
    172c:	02f70063          	beq	a4,a5,174c <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1730:	85ca                	mv	a1,s2
    1732:	00005517          	auipc	a0,0x5
    1736:	31650513          	addi	a0,a0,790 # 6a48 <malloc+0xda8>
    173a:	00004097          	auipc	ra,0x4
    173e:	4a8080e7          	jalr	1192(ra) # 5be2 <printf>
    exit(1);
    1742:	4505                	li	a0,1
    1744:	00004097          	auipc	ra,0x4
    1748:	126080e7          	jalr	294(ra) # 586a <exit>
    exit(0);
    174c:	4501                	li	a0,0
    174e:	00004097          	auipc	ra,0x4
    1752:	11c080e7          	jalr	284(ra) # 586a <exit>

0000000000001756 <pipe1>:
{
    1756:	711d                	addi	sp,sp,-96
    1758:	ec86                	sd	ra,88(sp)
    175a:	e8a2                	sd	s0,80(sp)
    175c:	e4a6                	sd	s1,72(sp)
    175e:	e0ca                	sd	s2,64(sp)
    1760:	fc4e                	sd	s3,56(sp)
    1762:	f852                	sd	s4,48(sp)
    1764:	f456                	sd	s5,40(sp)
    1766:	f05a                	sd	s6,32(sp)
    1768:	ec5e                	sd	s7,24(sp)
    176a:	1080                	addi	s0,sp,96
    176c:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    176e:	fa840513          	addi	a0,s0,-88
    1772:	00004097          	auipc	ra,0x4
    1776:	108080e7          	jalr	264(ra) # 587a <pipe>
    177a:	ed25                	bnez	a0,17f2 <pipe1+0x9c>
    177c:	84aa                	mv	s1,a0
  pid = fork();
    177e:	00004097          	auipc	ra,0x4
    1782:	0e4080e7          	jalr	228(ra) # 5862 <fork>
    1786:	8a2a                	mv	s4,a0
  if(pid == 0){
    1788:	c159                	beqz	a0,180e <pipe1+0xb8>
  } else if(pid > 0){
    178a:	16a05e63          	blez	a0,1906 <pipe1+0x1b0>
    close(fds[1]);
    178e:	fac42503          	lw	a0,-84(s0)
    1792:	00004097          	auipc	ra,0x4
    1796:	100080e7          	jalr	256(ra) # 5892 <close>
    total = 0;
    179a:	8a26                	mv	s4,s1
    cc = 1;
    179c:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    179e:	0000aa97          	auipc	s5,0xa
    17a2:	60aa8a93          	addi	s5,s5,1546 # bda8 <buf>
      if(cc > sizeof(buf))
    17a6:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    17a8:	864e                	mv	a2,s3
    17aa:	85d6                	mv	a1,s5
    17ac:	fa842503          	lw	a0,-88(s0)
    17b0:	00004097          	auipc	ra,0x4
    17b4:	0d2080e7          	jalr	210(ra) # 5882 <read>
    17b8:	10a05263          	blez	a0,18bc <pipe1+0x166>
      for(i = 0; i < n; i++){
    17bc:	0000a717          	auipc	a4,0xa
    17c0:	5ec70713          	addi	a4,a4,1516 # bda8 <buf>
    17c4:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17c8:	00074683          	lbu	a3,0(a4)
    17cc:	0ff4f793          	andi	a5,s1,255
    17d0:	2485                	addiw	s1,s1,1
    17d2:	0cf69163          	bne	a3,a5,1894 <pipe1+0x13e>
      for(i = 0; i < n; i++){
    17d6:	0705                	addi	a4,a4,1
    17d8:	fec498e3          	bne	s1,a2,17c8 <pipe1+0x72>
      total += n;
    17dc:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17e0:	0019979b          	slliw	a5,s3,0x1
    17e4:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17e8:	013b7363          	bgeu	s6,s3,17ee <pipe1+0x98>
        cc = sizeof(buf);
    17ec:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17ee:	84b2                	mv	s1,a2
    17f0:	bf65                	j	17a8 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17f2:	85ca                	mv	a1,s2
    17f4:	00005517          	auipc	a0,0x5
    17f8:	26c50513          	addi	a0,a0,620 # 6a60 <malloc+0xdc0>
    17fc:	00004097          	auipc	ra,0x4
    1800:	3e6080e7          	jalr	998(ra) # 5be2 <printf>
    exit(1);
    1804:	4505                	li	a0,1
    1806:	00004097          	auipc	ra,0x4
    180a:	064080e7          	jalr	100(ra) # 586a <exit>
    close(fds[0]);
    180e:	fa842503          	lw	a0,-88(s0)
    1812:	00004097          	auipc	ra,0x4
    1816:	080080e7          	jalr	128(ra) # 5892 <close>
    for(n = 0; n < N; n++){
    181a:	0000ab17          	auipc	s6,0xa
    181e:	58eb0b13          	addi	s6,s6,1422 # bda8 <buf>
    1822:	416004bb          	negw	s1,s6
    1826:	0ff4f493          	andi	s1,s1,255
    182a:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    182e:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1830:	6a85                	lui	s5,0x1
    1832:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x6d>
{
    1836:	87da                	mv	a5,s6
        buf[i] = seq++;
    1838:	0097873b          	addw	a4,a5,s1
    183c:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1840:	0785                	addi	a5,a5,1
    1842:	fef99be3          	bne	s3,a5,1838 <pipe1+0xe2>
    1846:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    184a:	40900613          	li	a2,1033
    184e:	85de                	mv	a1,s7
    1850:	fac42503          	lw	a0,-84(s0)
    1854:	00004097          	auipc	ra,0x4
    1858:	036080e7          	jalr	54(ra) # 588a <write>
    185c:	40900793          	li	a5,1033
    1860:	00f51c63          	bne	a0,a5,1878 <pipe1+0x122>
    for(n = 0; n < N; n++){
    1864:	24a5                	addiw	s1,s1,9
    1866:	0ff4f493          	andi	s1,s1,255
    186a:	fd5a16e3          	bne	s4,s5,1836 <pipe1+0xe0>
    exit(0);
    186e:	4501                	li	a0,0
    1870:	00004097          	auipc	ra,0x4
    1874:	ffa080e7          	jalr	-6(ra) # 586a <exit>
        printf("%s: pipe1 oops 1\n", s);
    1878:	85ca                	mv	a1,s2
    187a:	00005517          	auipc	a0,0x5
    187e:	1fe50513          	addi	a0,a0,510 # 6a78 <malloc+0xdd8>
    1882:	00004097          	auipc	ra,0x4
    1886:	360080e7          	jalr	864(ra) # 5be2 <printf>
        exit(1);
    188a:	4505                	li	a0,1
    188c:	00004097          	auipc	ra,0x4
    1890:	fde080e7          	jalr	-34(ra) # 586a <exit>
          printf("%s: pipe1 oops 2\n", s);
    1894:	85ca                	mv	a1,s2
    1896:	00005517          	auipc	a0,0x5
    189a:	1fa50513          	addi	a0,a0,506 # 6a90 <malloc+0xdf0>
    189e:	00004097          	auipc	ra,0x4
    18a2:	344080e7          	jalr	836(ra) # 5be2 <printf>
}
    18a6:	60e6                	ld	ra,88(sp)
    18a8:	6446                	ld	s0,80(sp)
    18aa:	64a6                	ld	s1,72(sp)
    18ac:	6906                	ld	s2,64(sp)
    18ae:	79e2                	ld	s3,56(sp)
    18b0:	7a42                	ld	s4,48(sp)
    18b2:	7aa2                	ld	s5,40(sp)
    18b4:	7b02                	ld	s6,32(sp)
    18b6:	6be2                	ld	s7,24(sp)
    18b8:	6125                	addi	sp,sp,96
    18ba:	8082                	ret
    if(total != N * SZ){
    18bc:	6785                	lui	a5,0x1
    18be:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x6d>
    18c2:	02fa0063          	beq	s4,a5,18e2 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18c6:	85d2                	mv	a1,s4
    18c8:	00005517          	auipc	a0,0x5
    18cc:	1e050513          	addi	a0,a0,480 # 6aa8 <malloc+0xe08>
    18d0:	00004097          	auipc	ra,0x4
    18d4:	312080e7          	jalr	786(ra) # 5be2 <printf>
      exit(1);
    18d8:	4505                	li	a0,1
    18da:	00004097          	auipc	ra,0x4
    18de:	f90080e7          	jalr	-112(ra) # 586a <exit>
    close(fds[0]);
    18e2:	fa842503          	lw	a0,-88(s0)
    18e6:	00004097          	auipc	ra,0x4
    18ea:	fac080e7          	jalr	-84(ra) # 5892 <close>
    wait(&xstatus);
    18ee:	fa440513          	addi	a0,s0,-92
    18f2:	00004097          	auipc	ra,0x4
    18f6:	f80080e7          	jalr	-128(ra) # 5872 <wait>
    exit(xstatus);
    18fa:	fa442503          	lw	a0,-92(s0)
    18fe:	00004097          	auipc	ra,0x4
    1902:	f6c080e7          	jalr	-148(ra) # 586a <exit>
    printf("%s: fork() failed\n", s);
    1906:	85ca                	mv	a1,s2
    1908:	00005517          	auipc	a0,0x5
    190c:	1c050513          	addi	a0,a0,448 # 6ac8 <malloc+0xe28>
    1910:	00004097          	auipc	ra,0x4
    1914:	2d2080e7          	jalr	722(ra) # 5be2 <printf>
    exit(1);
    1918:	4505                	li	a0,1
    191a:	00004097          	auipc	ra,0x4
    191e:	f50080e7          	jalr	-176(ra) # 586a <exit>

0000000000001922 <exitwait>:
{
    1922:	7139                	addi	sp,sp,-64
    1924:	fc06                	sd	ra,56(sp)
    1926:	f822                	sd	s0,48(sp)
    1928:	f426                	sd	s1,40(sp)
    192a:	f04a                	sd	s2,32(sp)
    192c:	ec4e                	sd	s3,24(sp)
    192e:	e852                	sd	s4,16(sp)
    1930:	0080                	addi	s0,sp,64
    1932:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1934:	4901                	li	s2,0
    1936:	06400993          	li	s3,100
    pid = fork();
    193a:	00004097          	auipc	ra,0x4
    193e:	f28080e7          	jalr	-216(ra) # 5862 <fork>
    1942:	84aa                	mv	s1,a0
    if(pid < 0){
    1944:	02054a63          	bltz	a0,1978 <exitwait+0x56>
    if(pid){
    1948:	c151                	beqz	a0,19cc <exitwait+0xaa>
      if(wait(&xstate) != pid){
    194a:	fcc40513          	addi	a0,s0,-52
    194e:	00004097          	auipc	ra,0x4
    1952:	f24080e7          	jalr	-220(ra) # 5872 <wait>
    1956:	02951f63          	bne	a0,s1,1994 <exitwait+0x72>
      if(i != xstate) {
    195a:	fcc42783          	lw	a5,-52(s0)
    195e:	05279963          	bne	a5,s2,19b0 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1962:	2905                	addiw	s2,s2,1
    1964:	fd391be3          	bne	s2,s3,193a <exitwait+0x18>
}
    1968:	70e2                	ld	ra,56(sp)
    196a:	7442                	ld	s0,48(sp)
    196c:	74a2                	ld	s1,40(sp)
    196e:	7902                	ld	s2,32(sp)
    1970:	69e2                	ld	s3,24(sp)
    1972:	6a42                	ld	s4,16(sp)
    1974:	6121                	addi	sp,sp,64
    1976:	8082                	ret
      printf("%s: fork failed\n", s);
    1978:	85d2                	mv	a1,s4
    197a:	00005517          	auipc	a0,0x5
    197e:	fde50513          	addi	a0,a0,-34 # 6958 <malloc+0xcb8>
    1982:	00004097          	auipc	ra,0x4
    1986:	260080e7          	jalr	608(ra) # 5be2 <printf>
      exit(1);
    198a:	4505                	li	a0,1
    198c:	00004097          	auipc	ra,0x4
    1990:	ede080e7          	jalr	-290(ra) # 586a <exit>
        printf("%s: wait wrong pid\n", s);
    1994:	85d2                	mv	a1,s4
    1996:	00005517          	auipc	a0,0x5
    199a:	14a50513          	addi	a0,a0,330 # 6ae0 <malloc+0xe40>
    199e:	00004097          	auipc	ra,0x4
    19a2:	244080e7          	jalr	580(ra) # 5be2 <printf>
        exit(1);
    19a6:	4505                	li	a0,1
    19a8:	00004097          	auipc	ra,0x4
    19ac:	ec2080e7          	jalr	-318(ra) # 586a <exit>
        printf("%s: wait wrong exit status\n", s);
    19b0:	85d2                	mv	a1,s4
    19b2:	00005517          	auipc	a0,0x5
    19b6:	14650513          	addi	a0,a0,326 # 6af8 <malloc+0xe58>
    19ba:	00004097          	auipc	ra,0x4
    19be:	228080e7          	jalr	552(ra) # 5be2 <printf>
        exit(1);
    19c2:	4505                	li	a0,1
    19c4:	00004097          	auipc	ra,0x4
    19c8:	ea6080e7          	jalr	-346(ra) # 586a <exit>
      exit(i);
    19cc:	854a                	mv	a0,s2
    19ce:	00004097          	auipc	ra,0x4
    19d2:	e9c080e7          	jalr	-356(ra) # 586a <exit>

00000000000019d6 <twochildren>:
{
    19d6:	1101                	addi	sp,sp,-32
    19d8:	ec06                	sd	ra,24(sp)
    19da:	e822                	sd	s0,16(sp)
    19dc:	e426                	sd	s1,8(sp)
    19de:	e04a                	sd	s2,0(sp)
    19e0:	1000                	addi	s0,sp,32
    19e2:	892a                	mv	s2,a0
    19e4:	3e800493          	li	s1,1000
    int pid1 = fork();
    19e8:	00004097          	auipc	ra,0x4
    19ec:	e7a080e7          	jalr	-390(ra) # 5862 <fork>
    if(pid1 < 0){
    19f0:	02054c63          	bltz	a0,1a28 <twochildren+0x52>
    if(pid1 == 0){
    19f4:	c921                	beqz	a0,1a44 <twochildren+0x6e>
      int pid2 = fork();
    19f6:	00004097          	auipc	ra,0x4
    19fa:	e6c080e7          	jalr	-404(ra) # 5862 <fork>
      if(pid2 < 0){
    19fe:	04054763          	bltz	a0,1a4c <twochildren+0x76>
      if(pid2 == 0){
    1a02:	c13d                	beqz	a0,1a68 <twochildren+0x92>
        wait(0);
    1a04:	4501                	li	a0,0
    1a06:	00004097          	auipc	ra,0x4
    1a0a:	e6c080e7          	jalr	-404(ra) # 5872 <wait>
        wait(0);
    1a0e:	4501                	li	a0,0
    1a10:	00004097          	auipc	ra,0x4
    1a14:	e62080e7          	jalr	-414(ra) # 5872 <wait>
  for(int i = 0; i < 1000; i++){
    1a18:	34fd                	addiw	s1,s1,-1
    1a1a:	f4f9                	bnez	s1,19e8 <twochildren+0x12>
}
    1a1c:	60e2                	ld	ra,24(sp)
    1a1e:	6442                	ld	s0,16(sp)
    1a20:	64a2                	ld	s1,8(sp)
    1a22:	6902                	ld	s2,0(sp)
    1a24:	6105                	addi	sp,sp,32
    1a26:	8082                	ret
      printf("%s: fork failed\n", s);
    1a28:	85ca                	mv	a1,s2
    1a2a:	00005517          	auipc	a0,0x5
    1a2e:	f2e50513          	addi	a0,a0,-210 # 6958 <malloc+0xcb8>
    1a32:	00004097          	auipc	ra,0x4
    1a36:	1b0080e7          	jalr	432(ra) # 5be2 <printf>
      exit(1);
    1a3a:	4505                	li	a0,1
    1a3c:	00004097          	auipc	ra,0x4
    1a40:	e2e080e7          	jalr	-466(ra) # 586a <exit>
      exit(0);
    1a44:	00004097          	auipc	ra,0x4
    1a48:	e26080e7          	jalr	-474(ra) # 586a <exit>
        printf("%s: fork failed\n", s);
    1a4c:	85ca                	mv	a1,s2
    1a4e:	00005517          	auipc	a0,0x5
    1a52:	f0a50513          	addi	a0,a0,-246 # 6958 <malloc+0xcb8>
    1a56:	00004097          	auipc	ra,0x4
    1a5a:	18c080e7          	jalr	396(ra) # 5be2 <printf>
        exit(1);
    1a5e:	4505                	li	a0,1
    1a60:	00004097          	auipc	ra,0x4
    1a64:	e0a080e7          	jalr	-502(ra) # 586a <exit>
        exit(0);
    1a68:	00004097          	auipc	ra,0x4
    1a6c:	e02080e7          	jalr	-510(ra) # 586a <exit>

0000000000001a70 <forkfork>:
{
    1a70:	7179                	addi	sp,sp,-48
    1a72:	f406                	sd	ra,40(sp)
    1a74:	f022                	sd	s0,32(sp)
    1a76:	ec26                	sd	s1,24(sp)
    1a78:	1800                	addi	s0,sp,48
    1a7a:	84aa                	mv	s1,a0
    int pid = fork();
    1a7c:	00004097          	auipc	ra,0x4
    1a80:	de6080e7          	jalr	-538(ra) # 5862 <fork>
    if(pid < 0){
    1a84:	04054163          	bltz	a0,1ac6 <forkfork+0x56>
    if(pid == 0){
    1a88:	cd29                	beqz	a0,1ae2 <forkfork+0x72>
    int pid = fork();
    1a8a:	00004097          	auipc	ra,0x4
    1a8e:	dd8080e7          	jalr	-552(ra) # 5862 <fork>
    if(pid < 0){
    1a92:	02054a63          	bltz	a0,1ac6 <forkfork+0x56>
    if(pid == 0){
    1a96:	c531                	beqz	a0,1ae2 <forkfork+0x72>
    wait(&xstatus);
    1a98:	fdc40513          	addi	a0,s0,-36
    1a9c:	00004097          	auipc	ra,0x4
    1aa0:	dd6080e7          	jalr	-554(ra) # 5872 <wait>
    if(xstatus != 0) {
    1aa4:	fdc42783          	lw	a5,-36(s0)
    1aa8:	ebbd                	bnez	a5,1b1e <forkfork+0xae>
    wait(&xstatus);
    1aaa:	fdc40513          	addi	a0,s0,-36
    1aae:	00004097          	auipc	ra,0x4
    1ab2:	dc4080e7          	jalr	-572(ra) # 5872 <wait>
    if(xstatus != 0) {
    1ab6:	fdc42783          	lw	a5,-36(s0)
    1aba:	e3b5                	bnez	a5,1b1e <forkfork+0xae>
}
    1abc:	70a2                	ld	ra,40(sp)
    1abe:	7402                	ld	s0,32(sp)
    1ac0:	64e2                	ld	s1,24(sp)
    1ac2:	6145                	addi	sp,sp,48
    1ac4:	8082                	ret
      printf("%s: fork failed", s);
    1ac6:	85a6                	mv	a1,s1
    1ac8:	00005517          	auipc	a0,0x5
    1acc:	05050513          	addi	a0,a0,80 # 6b18 <malloc+0xe78>
    1ad0:	00004097          	auipc	ra,0x4
    1ad4:	112080e7          	jalr	274(ra) # 5be2 <printf>
      exit(1);
    1ad8:	4505                	li	a0,1
    1ada:	00004097          	auipc	ra,0x4
    1ade:	d90080e7          	jalr	-624(ra) # 586a <exit>
{
    1ae2:	0c800493          	li	s1,200
        int pid1 = fork();
    1ae6:	00004097          	auipc	ra,0x4
    1aea:	d7c080e7          	jalr	-644(ra) # 5862 <fork>
        if(pid1 < 0){
    1aee:	00054f63          	bltz	a0,1b0c <forkfork+0x9c>
        if(pid1 == 0){
    1af2:	c115                	beqz	a0,1b16 <forkfork+0xa6>
        wait(0);
    1af4:	4501                	li	a0,0
    1af6:	00004097          	auipc	ra,0x4
    1afa:	d7c080e7          	jalr	-644(ra) # 5872 <wait>
      for(int j = 0; j < 200; j++){
    1afe:	34fd                	addiw	s1,s1,-1
    1b00:	f0fd                	bnez	s1,1ae6 <forkfork+0x76>
      exit(0);
    1b02:	4501                	li	a0,0
    1b04:	00004097          	auipc	ra,0x4
    1b08:	d66080e7          	jalr	-666(ra) # 586a <exit>
          exit(1);
    1b0c:	4505                	li	a0,1
    1b0e:	00004097          	auipc	ra,0x4
    1b12:	d5c080e7          	jalr	-676(ra) # 586a <exit>
          exit(0);
    1b16:	00004097          	auipc	ra,0x4
    1b1a:	d54080e7          	jalr	-684(ra) # 586a <exit>
      printf("%s: fork in child failed", s);
    1b1e:	85a6                	mv	a1,s1
    1b20:	00005517          	auipc	a0,0x5
    1b24:	00850513          	addi	a0,a0,8 # 6b28 <malloc+0xe88>
    1b28:	00004097          	auipc	ra,0x4
    1b2c:	0ba080e7          	jalr	186(ra) # 5be2 <printf>
      exit(1);
    1b30:	4505                	li	a0,1
    1b32:	00004097          	auipc	ra,0x4
    1b36:	d38080e7          	jalr	-712(ra) # 586a <exit>

0000000000001b3a <reparent2>:
{
    1b3a:	1101                	addi	sp,sp,-32
    1b3c:	ec06                	sd	ra,24(sp)
    1b3e:	e822                	sd	s0,16(sp)
    1b40:	e426                	sd	s1,8(sp)
    1b42:	1000                	addi	s0,sp,32
    1b44:	32000493          	li	s1,800
    int pid1 = fork();
    1b48:	00004097          	auipc	ra,0x4
    1b4c:	d1a080e7          	jalr	-742(ra) # 5862 <fork>
    if(pid1 < 0){
    1b50:	00054f63          	bltz	a0,1b6e <reparent2+0x34>
    if(pid1 == 0){
    1b54:	c915                	beqz	a0,1b88 <reparent2+0x4e>
    wait(0);
    1b56:	4501                	li	a0,0
    1b58:	00004097          	auipc	ra,0x4
    1b5c:	d1a080e7          	jalr	-742(ra) # 5872 <wait>
  for(int i = 0; i < 800; i++){
    1b60:	34fd                	addiw	s1,s1,-1
    1b62:	f0fd                	bnez	s1,1b48 <reparent2+0xe>
  exit(0);
    1b64:	4501                	li	a0,0
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	d04080e7          	jalr	-764(ra) # 586a <exit>
      printf("fork failed\n");
    1b6e:	00005517          	auipc	a0,0x5
    1b72:	20a50513          	addi	a0,a0,522 # 6d78 <malloc+0x10d8>
    1b76:	00004097          	auipc	ra,0x4
    1b7a:	06c080e7          	jalr	108(ra) # 5be2 <printf>
      exit(1);
    1b7e:	4505                	li	a0,1
    1b80:	00004097          	auipc	ra,0x4
    1b84:	cea080e7          	jalr	-790(ra) # 586a <exit>
      fork();
    1b88:	00004097          	auipc	ra,0x4
    1b8c:	cda080e7          	jalr	-806(ra) # 5862 <fork>
      fork();
    1b90:	00004097          	auipc	ra,0x4
    1b94:	cd2080e7          	jalr	-814(ra) # 5862 <fork>
      exit(0);
    1b98:	4501                	li	a0,0
    1b9a:	00004097          	auipc	ra,0x4
    1b9e:	cd0080e7          	jalr	-816(ra) # 586a <exit>

0000000000001ba2 <createdelete>:
{
    1ba2:	7175                	addi	sp,sp,-144
    1ba4:	e506                	sd	ra,136(sp)
    1ba6:	e122                	sd	s0,128(sp)
    1ba8:	fca6                	sd	s1,120(sp)
    1baa:	f8ca                	sd	s2,112(sp)
    1bac:	f4ce                	sd	s3,104(sp)
    1bae:	f0d2                	sd	s4,96(sp)
    1bb0:	ecd6                	sd	s5,88(sp)
    1bb2:	e8da                	sd	s6,80(sp)
    1bb4:	e4de                	sd	s7,72(sp)
    1bb6:	e0e2                	sd	s8,64(sp)
    1bb8:	fc66                	sd	s9,56(sp)
    1bba:	0900                	addi	s0,sp,144
    1bbc:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1bbe:	4901                	li	s2,0
    1bc0:	4991                	li	s3,4
    pid = fork();
    1bc2:	00004097          	auipc	ra,0x4
    1bc6:	ca0080e7          	jalr	-864(ra) # 5862 <fork>
    1bca:	84aa                	mv	s1,a0
    if(pid < 0){
    1bcc:	02054f63          	bltz	a0,1c0a <createdelete+0x68>
    if(pid == 0){
    1bd0:	c939                	beqz	a0,1c26 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bd2:	2905                	addiw	s2,s2,1
    1bd4:	ff3917e3          	bne	s2,s3,1bc2 <createdelete+0x20>
    1bd8:	4491                	li	s1,4
    wait(&xstatus);
    1bda:	f7c40513          	addi	a0,s0,-132
    1bde:	00004097          	auipc	ra,0x4
    1be2:	c94080e7          	jalr	-876(ra) # 5872 <wait>
    if(xstatus != 0)
    1be6:	f7c42903          	lw	s2,-132(s0)
    1bea:	0e091263          	bnez	s2,1cce <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bee:	34fd                	addiw	s1,s1,-1
    1bf0:	f4ed                	bnez	s1,1bda <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bf2:	f8040123          	sb	zero,-126(s0)
    1bf6:	03000993          	li	s3,48
    1bfa:	5a7d                	li	s4,-1
    1bfc:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1c00:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1c02:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1c04:	07400a93          	li	s5,116
    1c08:	a29d                	j	1d6e <createdelete+0x1cc>
      printf("fork failed\n", s);
    1c0a:	85e6                	mv	a1,s9
    1c0c:	00005517          	auipc	a0,0x5
    1c10:	16c50513          	addi	a0,a0,364 # 6d78 <malloc+0x10d8>
    1c14:	00004097          	auipc	ra,0x4
    1c18:	fce080e7          	jalr	-50(ra) # 5be2 <printf>
      exit(1);
    1c1c:	4505                	li	a0,1
    1c1e:	00004097          	auipc	ra,0x4
    1c22:	c4c080e7          	jalr	-948(ra) # 586a <exit>
      name[0] = 'p' + pi;
    1c26:	0709091b          	addiw	s2,s2,112
    1c2a:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c2e:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c32:	4951                	li	s2,20
    1c34:	a015                	j	1c58 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c36:	85e6                	mv	a1,s9
    1c38:	00005517          	auipc	a0,0x5
    1c3c:	db850513          	addi	a0,a0,-584 # 69f0 <malloc+0xd50>
    1c40:	00004097          	auipc	ra,0x4
    1c44:	fa2080e7          	jalr	-94(ra) # 5be2 <printf>
          exit(1);
    1c48:	4505                	li	a0,1
    1c4a:	00004097          	auipc	ra,0x4
    1c4e:	c20080e7          	jalr	-992(ra) # 586a <exit>
      for(i = 0; i < N; i++){
    1c52:	2485                	addiw	s1,s1,1
    1c54:	07248863          	beq	s1,s2,1cc4 <createdelete+0x122>
        name[1] = '0' + i;
    1c58:	0304879b          	addiw	a5,s1,48
    1c5c:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c60:	20200593          	li	a1,514
    1c64:	f8040513          	addi	a0,s0,-128
    1c68:	00004097          	auipc	ra,0x4
    1c6c:	c42080e7          	jalr	-958(ra) # 58aa <open>
        if(fd < 0){
    1c70:	fc0543e3          	bltz	a0,1c36 <createdelete+0x94>
        close(fd);
    1c74:	00004097          	auipc	ra,0x4
    1c78:	c1e080e7          	jalr	-994(ra) # 5892 <close>
        if(i > 0 && (i % 2 ) == 0){
    1c7c:	fc905be3          	blez	s1,1c52 <createdelete+0xb0>
    1c80:	0014f793          	andi	a5,s1,1
    1c84:	f7f9                	bnez	a5,1c52 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c86:	01f4d79b          	srliw	a5,s1,0x1f
    1c8a:	9fa5                	addw	a5,a5,s1
    1c8c:	4017d79b          	sraiw	a5,a5,0x1
    1c90:	0307879b          	addiw	a5,a5,48
    1c94:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c98:	f8040513          	addi	a0,s0,-128
    1c9c:	00004097          	auipc	ra,0x4
    1ca0:	c1e080e7          	jalr	-994(ra) # 58ba <unlink>
    1ca4:	fa0557e3          	bgez	a0,1c52 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1ca8:	85e6                	mv	a1,s9
    1caa:	00005517          	auipc	a0,0x5
    1cae:	e9e50513          	addi	a0,a0,-354 # 6b48 <malloc+0xea8>
    1cb2:	00004097          	auipc	ra,0x4
    1cb6:	f30080e7          	jalr	-208(ra) # 5be2 <printf>
            exit(1);
    1cba:	4505                	li	a0,1
    1cbc:	00004097          	auipc	ra,0x4
    1cc0:	bae080e7          	jalr	-1106(ra) # 586a <exit>
      exit(0);
    1cc4:	4501                	li	a0,0
    1cc6:	00004097          	auipc	ra,0x4
    1cca:	ba4080e7          	jalr	-1116(ra) # 586a <exit>
      exit(1);
    1cce:	4505                	li	a0,1
    1cd0:	00004097          	auipc	ra,0x4
    1cd4:	b9a080e7          	jalr	-1126(ra) # 586a <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cd8:	f8040613          	addi	a2,s0,-128
    1cdc:	85e6                	mv	a1,s9
    1cde:	00005517          	auipc	a0,0x5
    1ce2:	e8250513          	addi	a0,a0,-382 # 6b60 <malloc+0xec0>
    1ce6:	00004097          	auipc	ra,0x4
    1cea:	efc080e7          	jalr	-260(ra) # 5be2 <printf>
        exit(1);
    1cee:	4505                	li	a0,1
    1cf0:	00004097          	auipc	ra,0x4
    1cf4:	b7a080e7          	jalr	-1158(ra) # 586a <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1cf8:	054b7163          	bgeu	s6,s4,1d3a <createdelete+0x198>
      if(fd >= 0)
    1cfc:	02055a63          	bgez	a0,1d30 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1d00:	2485                	addiw	s1,s1,1
    1d02:	0ff4f493          	andi	s1,s1,255
    1d06:	05548c63          	beq	s1,s5,1d5e <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1d0a:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1d0e:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1d12:	4581                	li	a1,0
    1d14:	f8040513          	addi	a0,s0,-128
    1d18:	00004097          	auipc	ra,0x4
    1d1c:	b92080e7          	jalr	-1134(ra) # 58aa <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d20:	00090463          	beqz	s2,1d28 <createdelete+0x186>
    1d24:	fd2bdae3          	bge	s7,s2,1cf8 <createdelete+0x156>
    1d28:	fa0548e3          	bltz	a0,1cd8 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d2c:	014b7963          	bgeu	s6,s4,1d3e <createdelete+0x19c>
        close(fd);
    1d30:	00004097          	auipc	ra,0x4
    1d34:	b62080e7          	jalr	-1182(ra) # 5892 <close>
    1d38:	b7e1                	j	1d00 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d3a:	fc0543e3          	bltz	a0,1d00 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d3e:	f8040613          	addi	a2,s0,-128
    1d42:	85e6                	mv	a1,s9
    1d44:	00005517          	auipc	a0,0x5
    1d48:	e4450513          	addi	a0,a0,-444 # 6b88 <malloc+0xee8>
    1d4c:	00004097          	auipc	ra,0x4
    1d50:	e96080e7          	jalr	-362(ra) # 5be2 <printf>
        exit(1);
    1d54:	4505                	li	a0,1
    1d56:	00004097          	auipc	ra,0x4
    1d5a:	b14080e7          	jalr	-1260(ra) # 586a <exit>
  for(i = 0; i < N; i++){
    1d5e:	2905                	addiw	s2,s2,1
    1d60:	2a05                	addiw	s4,s4,1
    1d62:	2985                	addiw	s3,s3,1
    1d64:	0ff9f993          	andi	s3,s3,255
    1d68:	47d1                	li	a5,20
    1d6a:	02f90a63          	beq	s2,a5,1d9e <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d6e:	84e2                	mv	s1,s8
    1d70:	bf69                	j	1d0a <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d72:	2905                	addiw	s2,s2,1
    1d74:	0ff97913          	andi	s2,s2,255
    1d78:	2985                	addiw	s3,s3,1
    1d7a:	0ff9f993          	andi	s3,s3,255
    1d7e:	03490863          	beq	s2,s4,1dae <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d82:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d84:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d88:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d8c:	f8040513          	addi	a0,s0,-128
    1d90:	00004097          	auipc	ra,0x4
    1d94:	b2a080e7          	jalr	-1238(ra) # 58ba <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d98:	34fd                	addiw	s1,s1,-1
    1d9a:	f4ed                	bnez	s1,1d84 <createdelete+0x1e2>
    1d9c:	bfd9                	j	1d72 <createdelete+0x1d0>
    1d9e:	03000993          	li	s3,48
    1da2:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1da6:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1da8:	08400a13          	li	s4,132
    1dac:	bfd9                	j	1d82 <createdelete+0x1e0>
}
    1dae:	60aa                	ld	ra,136(sp)
    1db0:	640a                	ld	s0,128(sp)
    1db2:	74e6                	ld	s1,120(sp)
    1db4:	7946                	ld	s2,112(sp)
    1db6:	79a6                	ld	s3,104(sp)
    1db8:	7a06                	ld	s4,96(sp)
    1dba:	6ae6                	ld	s5,88(sp)
    1dbc:	6b46                	ld	s6,80(sp)
    1dbe:	6ba6                	ld	s7,72(sp)
    1dc0:	6c06                	ld	s8,64(sp)
    1dc2:	7ce2                	ld	s9,56(sp)
    1dc4:	6149                	addi	sp,sp,144
    1dc6:	8082                	ret

0000000000001dc8 <linkunlink>:
{
    1dc8:	711d                	addi	sp,sp,-96
    1dca:	ec86                	sd	ra,88(sp)
    1dcc:	e8a2                	sd	s0,80(sp)
    1dce:	e4a6                	sd	s1,72(sp)
    1dd0:	e0ca                	sd	s2,64(sp)
    1dd2:	fc4e                	sd	s3,56(sp)
    1dd4:	f852                	sd	s4,48(sp)
    1dd6:	f456                	sd	s5,40(sp)
    1dd8:	f05a                	sd	s6,32(sp)
    1dda:	ec5e                	sd	s7,24(sp)
    1ddc:	e862                	sd	s8,16(sp)
    1dde:	e466                	sd	s9,8(sp)
    1de0:	1080                	addi	s0,sp,96
    1de2:	84aa                	mv	s1,a0
  unlink("x");
    1de4:	00004517          	auipc	a0,0x4
    1de8:	3ac50513          	addi	a0,a0,940 # 6190 <malloc+0x4f0>
    1dec:	00004097          	auipc	ra,0x4
    1df0:	ace080e7          	jalr	-1330(ra) # 58ba <unlink>
  pid = fork();
    1df4:	00004097          	auipc	ra,0x4
    1df8:	a6e080e7          	jalr	-1426(ra) # 5862 <fork>
  if(pid < 0){
    1dfc:	02054b63          	bltz	a0,1e32 <linkunlink+0x6a>
    1e00:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1e02:	4c85                	li	s9,1
    1e04:	e119                	bnez	a0,1e0a <linkunlink+0x42>
    1e06:	06100c93          	li	s9,97
    1e0a:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1e0e:	41c659b7          	lui	s3,0x41c65
    1e12:	e6d9899b          	addiw	s3,s3,-403
    1e16:	690d                	lui	s2,0x3
    1e18:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e1c:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e1e:	4b05                	li	s6,1
      unlink("x");
    1e20:	00004a97          	auipc	s5,0x4
    1e24:	370a8a93          	addi	s5,s5,880 # 6190 <malloc+0x4f0>
      link("cat", "x");
    1e28:	00005b97          	auipc	s7,0x5
    1e2c:	d88b8b93          	addi	s7,s7,-632 # 6bb0 <malloc+0xf10>
    1e30:	a091                	j	1e74 <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    1e32:	85a6                	mv	a1,s1
    1e34:	00005517          	auipc	a0,0x5
    1e38:	b2450513          	addi	a0,a0,-1244 # 6958 <malloc+0xcb8>
    1e3c:	00004097          	auipc	ra,0x4
    1e40:	da6080e7          	jalr	-602(ra) # 5be2 <printf>
    exit(1);
    1e44:	4505                	li	a0,1
    1e46:	00004097          	auipc	ra,0x4
    1e4a:	a24080e7          	jalr	-1500(ra) # 586a <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e4e:	20200593          	li	a1,514
    1e52:	8556                	mv	a0,s5
    1e54:	00004097          	auipc	ra,0x4
    1e58:	a56080e7          	jalr	-1450(ra) # 58aa <open>
    1e5c:	00004097          	auipc	ra,0x4
    1e60:	a36080e7          	jalr	-1482(ra) # 5892 <close>
    1e64:	a031                	j	1e70 <linkunlink+0xa8>
      unlink("x");
    1e66:	8556                	mv	a0,s5
    1e68:	00004097          	auipc	ra,0x4
    1e6c:	a52080e7          	jalr	-1454(ra) # 58ba <unlink>
  for(i = 0; i < 100; i++){
    1e70:	34fd                	addiw	s1,s1,-1
    1e72:	c09d                	beqz	s1,1e98 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e74:	033c87bb          	mulw	a5,s9,s3
    1e78:	012787bb          	addw	a5,a5,s2
    1e7c:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e80:	0347f7bb          	remuw	a5,a5,s4
    1e84:	d7e9                	beqz	a5,1e4e <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e86:	ff6790e3          	bne	a5,s6,1e66 <linkunlink+0x9e>
      link("cat", "x");
    1e8a:	85d6                	mv	a1,s5
    1e8c:	855e                	mv	a0,s7
    1e8e:	00004097          	auipc	ra,0x4
    1e92:	a3c080e7          	jalr	-1476(ra) # 58ca <link>
    1e96:	bfe9                	j	1e70 <linkunlink+0xa8>
  if(pid)
    1e98:	020c0463          	beqz	s8,1ec0 <linkunlink+0xf8>
    wait(0);
    1e9c:	4501                	li	a0,0
    1e9e:	00004097          	auipc	ra,0x4
    1ea2:	9d4080e7          	jalr	-1580(ra) # 5872 <wait>
}
    1ea6:	60e6                	ld	ra,88(sp)
    1ea8:	6446                	ld	s0,80(sp)
    1eaa:	64a6                	ld	s1,72(sp)
    1eac:	6906                	ld	s2,64(sp)
    1eae:	79e2                	ld	s3,56(sp)
    1eb0:	7a42                	ld	s4,48(sp)
    1eb2:	7aa2                	ld	s5,40(sp)
    1eb4:	7b02                	ld	s6,32(sp)
    1eb6:	6be2                	ld	s7,24(sp)
    1eb8:	6c42                	ld	s8,16(sp)
    1eba:	6ca2                	ld	s9,8(sp)
    1ebc:	6125                	addi	sp,sp,96
    1ebe:	8082                	ret
    exit(0);
    1ec0:	4501                	li	a0,0
    1ec2:	00004097          	auipc	ra,0x4
    1ec6:	9a8080e7          	jalr	-1624(ra) # 586a <exit>

0000000000001eca <manywrites>:
{
    1eca:	711d                	addi	sp,sp,-96
    1ecc:	ec86                	sd	ra,88(sp)
    1ece:	e8a2                	sd	s0,80(sp)
    1ed0:	e4a6                	sd	s1,72(sp)
    1ed2:	e0ca                	sd	s2,64(sp)
    1ed4:	fc4e                	sd	s3,56(sp)
    1ed6:	f852                	sd	s4,48(sp)
    1ed8:	f456                	sd	s5,40(sp)
    1eda:	f05a                	sd	s6,32(sp)
    1edc:	ec5e                	sd	s7,24(sp)
    1ede:	1080                	addi	s0,sp,96
    1ee0:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1ee2:	4901                	li	s2,0
    1ee4:	4991                	li	s3,4
    int pid = fork();
    1ee6:	00004097          	auipc	ra,0x4
    1eea:	97c080e7          	jalr	-1668(ra) # 5862 <fork>
    1eee:	84aa                	mv	s1,a0
    if(pid < 0){
    1ef0:	02054963          	bltz	a0,1f22 <manywrites+0x58>
    if(pid == 0){
    1ef4:	c521                	beqz	a0,1f3c <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1ef6:	2905                	addiw	s2,s2,1
    1ef8:	ff3917e3          	bne	s2,s3,1ee6 <manywrites+0x1c>
    1efc:	4491                	li	s1,4
    int st = 0;
    1efe:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1f02:	fa840513          	addi	a0,s0,-88
    1f06:	00004097          	auipc	ra,0x4
    1f0a:	96c080e7          	jalr	-1684(ra) # 5872 <wait>
    if(st != 0)
    1f0e:	fa842503          	lw	a0,-88(s0)
    1f12:	ed6d                	bnez	a0,200c <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    1f14:	34fd                	addiw	s1,s1,-1
    1f16:	f4e5                	bnez	s1,1efe <manywrites+0x34>
  exit(0);
    1f18:	4501                	li	a0,0
    1f1a:	00004097          	auipc	ra,0x4
    1f1e:	950080e7          	jalr	-1712(ra) # 586a <exit>
      printf("fork failed\n");
    1f22:	00005517          	auipc	a0,0x5
    1f26:	e5650513          	addi	a0,a0,-426 # 6d78 <malloc+0x10d8>
    1f2a:	00004097          	auipc	ra,0x4
    1f2e:	cb8080e7          	jalr	-840(ra) # 5be2 <printf>
      exit(1);
    1f32:	4505                	li	a0,1
    1f34:	00004097          	auipc	ra,0x4
    1f38:	936080e7          	jalr	-1738(ra) # 586a <exit>
      name[0] = 'b';
    1f3c:	06200793          	li	a5,98
    1f40:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f44:	0619079b          	addiw	a5,s2,97
    1f48:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f4c:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f50:	fa840513          	addi	a0,s0,-88
    1f54:	00004097          	auipc	ra,0x4
    1f58:	966080e7          	jalr	-1690(ra) # 58ba <unlink>
    1f5c:	4b79                	li	s6,30
          int cc = write(fd, buf, sz);
    1f5e:	0000ab97          	auipc	s7,0xa
    1f62:	e4ab8b93          	addi	s7,s7,-438 # bda8 <buf>
        for(int i = 0; i < ci+1; i++){
    1f66:	8a26                	mv	s4,s1
    1f68:	02094e63          	bltz	s2,1fa4 <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1f6c:	20200593          	li	a1,514
    1f70:	fa840513          	addi	a0,s0,-88
    1f74:	00004097          	auipc	ra,0x4
    1f78:	936080e7          	jalr	-1738(ra) # 58aa <open>
    1f7c:	89aa                	mv	s3,a0
          if(fd < 0){
    1f7e:	04054763          	bltz	a0,1fcc <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1f82:	660d                	lui	a2,0x3
    1f84:	85de                	mv	a1,s7
    1f86:	00004097          	auipc	ra,0x4
    1f8a:	904080e7          	jalr	-1788(ra) # 588a <write>
          if(cc != sz){
    1f8e:	678d                	lui	a5,0x3
    1f90:	04f51e63          	bne	a0,a5,1fec <manywrites+0x122>
          close(fd);
    1f94:	854e                	mv	a0,s3
    1f96:	00004097          	auipc	ra,0x4
    1f9a:	8fc080e7          	jalr	-1796(ra) # 5892 <close>
        for(int i = 0; i < ci+1; i++){
    1f9e:	2a05                	addiw	s4,s4,1
    1fa0:	fd4956e3          	bge	s2,s4,1f6c <manywrites+0xa2>
        unlink(name);
    1fa4:	fa840513          	addi	a0,s0,-88
    1fa8:	00004097          	auipc	ra,0x4
    1fac:	912080e7          	jalr	-1774(ra) # 58ba <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1fb0:	3b7d                	addiw	s6,s6,-1
    1fb2:	fa0b1ae3          	bnez	s6,1f66 <manywrites+0x9c>
      unlink(name);
    1fb6:	fa840513          	addi	a0,s0,-88
    1fba:	00004097          	auipc	ra,0x4
    1fbe:	900080e7          	jalr	-1792(ra) # 58ba <unlink>
      exit(0);
    1fc2:	4501                	li	a0,0
    1fc4:	00004097          	auipc	ra,0x4
    1fc8:	8a6080e7          	jalr	-1882(ra) # 586a <exit>
            printf("%s: cannot create %s\n", s, name);
    1fcc:	fa840613          	addi	a2,s0,-88
    1fd0:	85d6                	mv	a1,s5
    1fd2:	00005517          	auipc	a0,0x5
    1fd6:	be650513          	addi	a0,a0,-1050 # 6bb8 <malloc+0xf18>
    1fda:	00004097          	auipc	ra,0x4
    1fde:	c08080e7          	jalr	-1016(ra) # 5be2 <printf>
            exit(1);
    1fe2:	4505                	li	a0,1
    1fe4:	00004097          	auipc	ra,0x4
    1fe8:	886080e7          	jalr	-1914(ra) # 586a <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fec:	86aa                	mv	a3,a0
    1fee:	660d                	lui	a2,0x3
    1ff0:	85d6                	mv	a1,s5
    1ff2:	00004517          	auipc	a0,0x4
    1ff6:	1ee50513          	addi	a0,a0,494 # 61e0 <malloc+0x540>
    1ffa:	00004097          	auipc	ra,0x4
    1ffe:	be8080e7          	jalr	-1048(ra) # 5be2 <printf>
            exit(1);
    2002:	4505                	li	a0,1
    2004:	00004097          	auipc	ra,0x4
    2008:	866080e7          	jalr	-1946(ra) # 586a <exit>
      exit(st);
    200c:	00004097          	auipc	ra,0x4
    2010:	85e080e7          	jalr	-1954(ra) # 586a <exit>

0000000000002014 <forktest>:
{
    2014:	7179                	addi	sp,sp,-48
    2016:	f406                	sd	ra,40(sp)
    2018:	f022                	sd	s0,32(sp)
    201a:	ec26                	sd	s1,24(sp)
    201c:	e84a                	sd	s2,16(sp)
    201e:	e44e                	sd	s3,8(sp)
    2020:	1800                	addi	s0,sp,48
    2022:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    2024:	4481                	li	s1,0
    2026:	3e800913          	li	s2,1000
    pid = fork();
    202a:	00004097          	auipc	ra,0x4
    202e:	838080e7          	jalr	-1992(ra) # 5862 <fork>
    if(pid < 0)
    2032:	02054863          	bltz	a0,2062 <forktest+0x4e>
    if(pid == 0)
    2036:	c115                	beqz	a0,205a <forktest+0x46>
  for(n=0; n<N; n++){
    2038:	2485                	addiw	s1,s1,1
    203a:	ff2498e3          	bne	s1,s2,202a <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    203e:	85ce                	mv	a1,s3
    2040:	00005517          	auipc	a0,0x5
    2044:	ba850513          	addi	a0,a0,-1112 # 6be8 <malloc+0xf48>
    2048:	00004097          	auipc	ra,0x4
    204c:	b9a080e7          	jalr	-1126(ra) # 5be2 <printf>
    exit(1);
    2050:	4505                	li	a0,1
    2052:	00004097          	auipc	ra,0x4
    2056:	818080e7          	jalr	-2024(ra) # 586a <exit>
      exit(0);
    205a:	00004097          	auipc	ra,0x4
    205e:	810080e7          	jalr	-2032(ra) # 586a <exit>
  if (n == 0) {
    2062:	cc9d                	beqz	s1,20a0 <forktest+0x8c>
  if(n == N){
    2064:	3e800793          	li	a5,1000
    2068:	fcf48be3          	beq	s1,a5,203e <forktest+0x2a>
  for(; n > 0; n--){
    206c:	00905b63          	blez	s1,2082 <forktest+0x6e>
    if(wait(0) < 0){
    2070:	4501                	li	a0,0
    2072:	00004097          	auipc	ra,0x4
    2076:	800080e7          	jalr	-2048(ra) # 5872 <wait>
    207a:	04054163          	bltz	a0,20bc <forktest+0xa8>
  for(; n > 0; n--){
    207e:	34fd                	addiw	s1,s1,-1
    2080:	f8e5                	bnez	s1,2070 <forktest+0x5c>
  if(wait(0) != -1){
    2082:	4501                	li	a0,0
    2084:	00003097          	auipc	ra,0x3
    2088:	7ee080e7          	jalr	2030(ra) # 5872 <wait>
    208c:	57fd                	li	a5,-1
    208e:	04f51563          	bne	a0,a5,20d8 <forktest+0xc4>
}
    2092:	70a2                	ld	ra,40(sp)
    2094:	7402                	ld	s0,32(sp)
    2096:	64e2                	ld	s1,24(sp)
    2098:	6942                	ld	s2,16(sp)
    209a:	69a2                	ld	s3,8(sp)
    209c:	6145                	addi	sp,sp,48
    209e:	8082                	ret
    printf("%s: no fork at all!\n", s);
    20a0:	85ce                	mv	a1,s3
    20a2:	00005517          	auipc	a0,0x5
    20a6:	b2e50513          	addi	a0,a0,-1234 # 6bd0 <malloc+0xf30>
    20aa:	00004097          	auipc	ra,0x4
    20ae:	b38080e7          	jalr	-1224(ra) # 5be2 <printf>
    exit(1);
    20b2:	4505                	li	a0,1
    20b4:	00003097          	auipc	ra,0x3
    20b8:	7b6080e7          	jalr	1974(ra) # 586a <exit>
      printf("%s: wait stopped early\n", s);
    20bc:	85ce                	mv	a1,s3
    20be:	00005517          	auipc	a0,0x5
    20c2:	b5250513          	addi	a0,a0,-1198 # 6c10 <malloc+0xf70>
    20c6:	00004097          	auipc	ra,0x4
    20ca:	b1c080e7          	jalr	-1252(ra) # 5be2 <printf>
      exit(1);
    20ce:	4505                	li	a0,1
    20d0:	00003097          	auipc	ra,0x3
    20d4:	79a080e7          	jalr	1946(ra) # 586a <exit>
    printf("%s: wait got too many\n", s);
    20d8:	85ce                	mv	a1,s3
    20da:	00005517          	auipc	a0,0x5
    20de:	b4e50513          	addi	a0,a0,-1202 # 6c28 <malloc+0xf88>
    20e2:	00004097          	auipc	ra,0x4
    20e6:	b00080e7          	jalr	-1280(ra) # 5be2 <printf>
    exit(1);
    20ea:	4505                	li	a0,1
    20ec:	00003097          	auipc	ra,0x3
    20f0:	77e080e7          	jalr	1918(ra) # 586a <exit>

00000000000020f4 <kernmem>:
{
    20f4:	715d                	addi	sp,sp,-80
    20f6:	e486                	sd	ra,72(sp)
    20f8:	e0a2                	sd	s0,64(sp)
    20fa:	fc26                	sd	s1,56(sp)
    20fc:	f84a                	sd	s2,48(sp)
    20fe:	f44e                	sd	s3,40(sp)
    2100:	f052                	sd	s4,32(sp)
    2102:	ec56                	sd	s5,24(sp)
    2104:	0880                	addi	s0,sp,80
    2106:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2108:	4485                	li	s1,1
    210a:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    210c:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    210e:	69b1                	lui	s3,0xc
    2110:	35098993          	addi	s3,s3,848 # c350 <buf+0x5a8>
    2114:	1003d937          	lui	s2,0x1003d
    2118:	090e                	slli	s2,s2,0x3
    211a:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e6c8>
    pid = fork();
    211e:	00003097          	auipc	ra,0x3
    2122:	744080e7          	jalr	1860(ra) # 5862 <fork>
    if(pid < 0){
    2126:	02054963          	bltz	a0,2158 <kernmem+0x64>
    if(pid == 0){
    212a:	c529                	beqz	a0,2174 <kernmem+0x80>
    wait(&xstatus);
    212c:	fbc40513          	addi	a0,s0,-68
    2130:	00003097          	auipc	ra,0x3
    2134:	742080e7          	jalr	1858(ra) # 5872 <wait>
    if(xstatus != -1)  // did kernel kill child?
    2138:	fbc42783          	lw	a5,-68(s0)
    213c:	05579d63          	bne	a5,s5,2196 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2140:	94ce                	add	s1,s1,s3
    2142:	fd249ee3          	bne	s1,s2,211e <kernmem+0x2a>
}
    2146:	60a6                	ld	ra,72(sp)
    2148:	6406                	ld	s0,64(sp)
    214a:	74e2                	ld	s1,56(sp)
    214c:	7942                	ld	s2,48(sp)
    214e:	79a2                	ld	s3,40(sp)
    2150:	7a02                	ld	s4,32(sp)
    2152:	6ae2                	ld	s5,24(sp)
    2154:	6161                	addi	sp,sp,80
    2156:	8082                	ret
      printf("%s: fork failed\n", s);
    2158:	85d2                	mv	a1,s4
    215a:	00004517          	auipc	a0,0x4
    215e:	7fe50513          	addi	a0,a0,2046 # 6958 <malloc+0xcb8>
    2162:	00004097          	auipc	ra,0x4
    2166:	a80080e7          	jalr	-1408(ra) # 5be2 <printf>
      exit(1);
    216a:	4505                	li	a0,1
    216c:	00003097          	auipc	ra,0x3
    2170:	6fe080e7          	jalr	1790(ra) # 586a <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2174:	0004c683          	lbu	a3,0(s1)
    2178:	8626                	mv	a2,s1
    217a:	85d2                	mv	a1,s4
    217c:	00005517          	auipc	a0,0x5
    2180:	ac450513          	addi	a0,a0,-1340 # 6c40 <malloc+0xfa0>
    2184:	00004097          	auipc	ra,0x4
    2188:	a5e080e7          	jalr	-1442(ra) # 5be2 <printf>
      exit(1);
    218c:	4505                	li	a0,1
    218e:	00003097          	auipc	ra,0x3
    2192:	6dc080e7          	jalr	1756(ra) # 586a <exit>
      exit(1);
    2196:	4505                	li	a0,1
    2198:	00003097          	auipc	ra,0x3
    219c:	6d2080e7          	jalr	1746(ra) # 586a <exit>

00000000000021a0 <MAXVAplus>:
{
    21a0:	7179                	addi	sp,sp,-48
    21a2:	f406                	sd	ra,40(sp)
    21a4:	f022                	sd	s0,32(sp)
    21a6:	ec26                	sd	s1,24(sp)
    21a8:	e84a                	sd	s2,16(sp)
    21aa:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    21ac:	4785                	li	a5,1
    21ae:	179a                	slli	a5,a5,0x26
    21b0:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    21b4:	fd843783          	ld	a5,-40(s0)
    21b8:	cf85                	beqz	a5,21f0 <MAXVAplus+0x50>
    21ba:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    21bc:	54fd                	li	s1,-1
    pid = fork();
    21be:	00003097          	auipc	ra,0x3
    21c2:	6a4080e7          	jalr	1700(ra) # 5862 <fork>
    if(pid < 0){
    21c6:	02054b63          	bltz	a0,21fc <MAXVAplus+0x5c>
    if(pid == 0){
    21ca:	c539                	beqz	a0,2218 <MAXVAplus+0x78>
    wait(&xstatus);
    21cc:	fd440513          	addi	a0,s0,-44
    21d0:	00003097          	auipc	ra,0x3
    21d4:	6a2080e7          	jalr	1698(ra) # 5872 <wait>
    if(xstatus != -1)  // did kernel kill child?
    21d8:	fd442783          	lw	a5,-44(s0)
    21dc:	06979463          	bne	a5,s1,2244 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    21e0:	fd843783          	ld	a5,-40(s0)
    21e4:	0786                	slli	a5,a5,0x1
    21e6:	fcf43c23          	sd	a5,-40(s0)
    21ea:	fd843783          	ld	a5,-40(s0)
    21ee:	fbe1                	bnez	a5,21be <MAXVAplus+0x1e>
}
    21f0:	70a2                	ld	ra,40(sp)
    21f2:	7402                	ld	s0,32(sp)
    21f4:	64e2                	ld	s1,24(sp)
    21f6:	6942                	ld	s2,16(sp)
    21f8:	6145                	addi	sp,sp,48
    21fa:	8082                	ret
      printf("%s: fork failed\n", s);
    21fc:	85ca                	mv	a1,s2
    21fe:	00004517          	auipc	a0,0x4
    2202:	75a50513          	addi	a0,a0,1882 # 6958 <malloc+0xcb8>
    2206:	00004097          	auipc	ra,0x4
    220a:	9dc080e7          	jalr	-1572(ra) # 5be2 <printf>
      exit(1);
    220e:	4505                	li	a0,1
    2210:	00003097          	auipc	ra,0x3
    2214:	65a080e7          	jalr	1626(ra) # 586a <exit>
      *(char*)a = 99;
    2218:	fd843783          	ld	a5,-40(s0)
    221c:	06300713          	li	a4,99
    2220:	00e78023          	sb	a4,0(a5) # 3000 <iputtest+0x6c>
      printf("%s: oops wrote %x\n", s, a);
    2224:	fd843603          	ld	a2,-40(s0)
    2228:	85ca                	mv	a1,s2
    222a:	00005517          	auipc	a0,0x5
    222e:	a3650513          	addi	a0,a0,-1482 # 6c60 <malloc+0xfc0>
    2232:	00004097          	auipc	ra,0x4
    2236:	9b0080e7          	jalr	-1616(ra) # 5be2 <printf>
      exit(1);
    223a:	4505                	li	a0,1
    223c:	00003097          	auipc	ra,0x3
    2240:	62e080e7          	jalr	1582(ra) # 586a <exit>
      exit(1);
    2244:	4505                	li	a0,1
    2246:	00003097          	auipc	ra,0x3
    224a:	624080e7          	jalr	1572(ra) # 586a <exit>

000000000000224e <bigargtest>:
{
    224e:	7179                	addi	sp,sp,-48
    2250:	f406                	sd	ra,40(sp)
    2252:	f022                	sd	s0,32(sp)
    2254:	ec26                	sd	s1,24(sp)
    2256:	1800                	addi	s0,sp,48
    2258:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    225a:	00005517          	auipc	a0,0x5
    225e:	a1e50513          	addi	a0,a0,-1506 # 6c78 <malloc+0xfd8>
    2262:	00003097          	auipc	ra,0x3
    2266:	658080e7          	jalr	1624(ra) # 58ba <unlink>
  pid = fork();
    226a:	00003097          	auipc	ra,0x3
    226e:	5f8080e7          	jalr	1528(ra) # 5862 <fork>
  if(pid == 0){
    2272:	c121                	beqz	a0,22b2 <bigargtest+0x64>
  } else if(pid < 0){
    2274:	0a054063          	bltz	a0,2314 <bigargtest+0xc6>
  wait(&xstatus);
    2278:	fdc40513          	addi	a0,s0,-36
    227c:	00003097          	auipc	ra,0x3
    2280:	5f6080e7          	jalr	1526(ra) # 5872 <wait>
  if(xstatus != 0)
    2284:	fdc42503          	lw	a0,-36(s0)
    2288:	e545                	bnez	a0,2330 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    228a:	4581                	li	a1,0
    228c:	00005517          	auipc	a0,0x5
    2290:	9ec50513          	addi	a0,a0,-1556 # 6c78 <malloc+0xfd8>
    2294:	00003097          	auipc	ra,0x3
    2298:	616080e7          	jalr	1558(ra) # 58aa <open>
  if(fd < 0){
    229c:	08054e63          	bltz	a0,2338 <bigargtest+0xea>
  close(fd);
    22a0:	00003097          	auipc	ra,0x3
    22a4:	5f2080e7          	jalr	1522(ra) # 5892 <close>
}
    22a8:	70a2                	ld	ra,40(sp)
    22aa:	7402                	ld	s0,32(sp)
    22ac:	64e2                	ld	s1,24(sp)
    22ae:	6145                	addi	sp,sp,48
    22b0:	8082                	ret
    22b2:	00006797          	auipc	a5,0x6
    22b6:	2de78793          	addi	a5,a5,734 # 8590 <args.1859>
    22ba:	00006697          	auipc	a3,0x6
    22be:	3ce68693          	addi	a3,a3,974 # 8688 <args.1859+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    22c2:	00005717          	auipc	a4,0x5
    22c6:	9c670713          	addi	a4,a4,-1594 # 6c88 <malloc+0xfe8>
    22ca:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    22cc:	07a1                	addi	a5,a5,8
    22ce:	fed79ee3          	bne	a5,a3,22ca <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    22d2:	00006597          	auipc	a1,0x6
    22d6:	2be58593          	addi	a1,a1,702 # 8590 <args.1859>
    22da:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    22de:	00004517          	auipc	a0,0x4
    22e2:	e4250513          	addi	a0,a0,-446 # 6120 <malloc+0x480>
    22e6:	00003097          	auipc	ra,0x3
    22ea:	5bc080e7          	jalr	1468(ra) # 58a2 <exec>
    fd = open("bigarg-ok", O_CREATE);
    22ee:	20000593          	li	a1,512
    22f2:	00005517          	auipc	a0,0x5
    22f6:	98650513          	addi	a0,a0,-1658 # 6c78 <malloc+0xfd8>
    22fa:	00003097          	auipc	ra,0x3
    22fe:	5b0080e7          	jalr	1456(ra) # 58aa <open>
    close(fd);
    2302:	00003097          	auipc	ra,0x3
    2306:	590080e7          	jalr	1424(ra) # 5892 <close>
    exit(0);
    230a:	4501                	li	a0,0
    230c:	00003097          	auipc	ra,0x3
    2310:	55e080e7          	jalr	1374(ra) # 586a <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2314:	85a6                	mv	a1,s1
    2316:	00005517          	auipc	a0,0x5
    231a:	a5250513          	addi	a0,a0,-1454 # 6d68 <malloc+0x10c8>
    231e:	00004097          	auipc	ra,0x4
    2322:	8c4080e7          	jalr	-1852(ra) # 5be2 <printf>
    exit(1);
    2326:	4505                	li	a0,1
    2328:	00003097          	auipc	ra,0x3
    232c:	542080e7          	jalr	1346(ra) # 586a <exit>
    exit(xstatus);
    2330:	00003097          	auipc	ra,0x3
    2334:	53a080e7          	jalr	1338(ra) # 586a <exit>
    printf("%s: bigarg test failed!\n", s);
    2338:	85a6                	mv	a1,s1
    233a:	00005517          	auipc	a0,0x5
    233e:	a4e50513          	addi	a0,a0,-1458 # 6d88 <malloc+0x10e8>
    2342:	00004097          	auipc	ra,0x4
    2346:	8a0080e7          	jalr	-1888(ra) # 5be2 <printf>
    exit(1);
    234a:	4505                	li	a0,1
    234c:	00003097          	auipc	ra,0x3
    2350:	51e080e7          	jalr	1310(ra) # 586a <exit>

0000000000002354 <stacktest>:
{
    2354:	7179                	addi	sp,sp,-48
    2356:	f406                	sd	ra,40(sp)
    2358:	f022                	sd	s0,32(sp)
    235a:	ec26                	sd	s1,24(sp)
    235c:	1800                	addi	s0,sp,48
    235e:	84aa                	mv	s1,a0
  pid = fork();
    2360:	00003097          	auipc	ra,0x3
    2364:	502080e7          	jalr	1282(ra) # 5862 <fork>
  if(pid == 0) {
    2368:	c115                	beqz	a0,238c <stacktest+0x38>
  } else if(pid < 0){
    236a:	04054463          	bltz	a0,23b2 <stacktest+0x5e>
  wait(&xstatus);
    236e:	fdc40513          	addi	a0,s0,-36
    2372:	00003097          	auipc	ra,0x3
    2376:	500080e7          	jalr	1280(ra) # 5872 <wait>
  if(xstatus == -1)  // kernel killed child?
    237a:	fdc42503          	lw	a0,-36(s0)
    237e:	57fd                	li	a5,-1
    2380:	04f50763          	beq	a0,a5,23ce <stacktest+0x7a>
    exit(xstatus);
    2384:	00003097          	auipc	ra,0x3
    2388:	4e6080e7          	jalr	1254(ra) # 586a <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    238c:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    238e:	77fd                	lui	a5,0xfffff
    2390:	97ba                	add	a5,a5,a4
    2392:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0248>
    2396:	85a6                	mv	a1,s1
    2398:	00005517          	auipc	a0,0x5
    239c:	a1050513          	addi	a0,a0,-1520 # 6da8 <malloc+0x1108>
    23a0:	00004097          	auipc	ra,0x4
    23a4:	842080e7          	jalr	-1982(ra) # 5be2 <printf>
    exit(1);
    23a8:	4505                	li	a0,1
    23aa:	00003097          	auipc	ra,0x3
    23ae:	4c0080e7          	jalr	1216(ra) # 586a <exit>
    printf("%s: fork failed\n", s);
    23b2:	85a6                	mv	a1,s1
    23b4:	00004517          	auipc	a0,0x4
    23b8:	5a450513          	addi	a0,a0,1444 # 6958 <malloc+0xcb8>
    23bc:	00004097          	auipc	ra,0x4
    23c0:	826080e7          	jalr	-2010(ra) # 5be2 <printf>
    exit(1);
    23c4:	4505                	li	a0,1
    23c6:	00003097          	auipc	ra,0x3
    23ca:	4a4080e7          	jalr	1188(ra) # 586a <exit>
    exit(0);
    23ce:	4501                	li	a0,0
    23d0:	00003097          	auipc	ra,0x3
    23d4:	49a080e7          	jalr	1178(ra) # 586a <exit>

00000000000023d8 <copyinstr3>:
{
    23d8:	7179                	addi	sp,sp,-48
    23da:	f406                	sd	ra,40(sp)
    23dc:	f022                	sd	s0,32(sp)
    23de:	ec26                	sd	s1,24(sp)
    23e0:	1800                	addi	s0,sp,48
  sbrk(8192);
    23e2:	6509                	lui	a0,0x2
    23e4:	00003097          	auipc	ra,0x3
    23e8:	50e080e7          	jalr	1294(ra) # 58f2 <sbrk>
  uint64 top = (uint64) sbrk(0);
    23ec:	4501                	li	a0,0
    23ee:	00003097          	auipc	ra,0x3
    23f2:	504080e7          	jalr	1284(ra) # 58f2 <sbrk>
  if((top % PGSIZE) != 0){
    23f6:	03451793          	slli	a5,a0,0x34
    23fa:	e3c9                	bnez	a5,247c <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    23fc:	4501                	li	a0,0
    23fe:	00003097          	auipc	ra,0x3
    2402:	4f4080e7          	jalr	1268(ra) # 58f2 <sbrk>
  if(top % PGSIZE){
    2406:	03451793          	slli	a5,a0,0x34
    240a:	e3d9                	bnez	a5,2490 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    240c:	fff50493          	addi	s1,a0,-1 # 1fff <manywrites+0x135>
  *b = 'x';
    2410:	07800793          	li	a5,120
    2414:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2418:	8526                	mv	a0,s1
    241a:	00003097          	auipc	ra,0x3
    241e:	4a0080e7          	jalr	1184(ra) # 58ba <unlink>
  if(ret != -1){
    2422:	57fd                	li	a5,-1
    2424:	08f51363          	bne	a0,a5,24aa <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2428:	20100593          	li	a1,513
    242c:	8526                	mv	a0,s1
    242e:	00003097          	auipc	ra,0x3
    2432:	47c080e7          	jalr	1148(ra) # 58aa <open>
  if(fd != -1){
    2436:	57fd                	li	a5,-1
    2438:	08f51863          	bne	a0,a5,24c8 <copyinstr3+0xf0>
  ret = link(b, b);
    243c:	85a6                	mv	a1,s1
    243e:	8526                	mv	a0,s1
    2440:	00003097          	auipc	ra,0x3
    2444:	48a080e7          	jalr	1162(ra) # 58ca <link>
  if(ret != -1){
    2448:	57fd                	li	a5,-1
    244a:	08f51e63          	bne	a0,a5,24e6 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    244e:	00005797          	auipc	a5,0x5
    2452:	5f278793          	addi	a5,a5,1522 # 7a40 <malloc+0x1da0>
    2456:	fcf43823          	sd	a5,-48(s0)
    245a:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    245e:	fd040593          	addi	a1,s0,-48
    2462:	8526                	mv	a0,s1
    2464:	00003097          	auipc	ra,0x3
    2468:	43e080e7          	jalr	1086(ra) # 58a2 <exec>
  if(ret != -1){
    246c:	57fd                	li	a5,-1
    246e:	08f51c63          	bne	a0,a5,2506 <copyinstr3+0x12e>
}
    2472:	70a2                	ld	ra,40(sp)
    2474:	7402                	ld	s0,32(sp)
    2476:	64e2                	ld	s1,24(sp)
    2478:	6145                	addi	sp,sp,48
    247a:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    247c:	0347d513          	srli	a0,a5,0x34
    2480:	6785                	lui	a5,0x1
    2482:	40a7853b          	subw	a0,a5,a0
    2486:	00003097          	auipc	ra,0x3
    248a:	46c080e7          	jalr	1132(ra) # 58f2 <sbrk>
    248e:	b7bd                	j	23fc <copyinstr3+0x24>
    printf("oops\n");
    2490:	00005517          	auipc	a0,0x5
    2494:	94050513          	addi	a0,a0,-1728 # 6dd0 <malloc+0x1130>
    2498:	00003097          	auipc	ra,0x3
    249c:	74a080e7          	jalr	1866(ra) # 5be2 <printf>
    exit(1);
    24a0:	4505                	li	a0,1
    24a2:	00003097          	auipc	ra,0x3
    24a6:	3c8080e7          	jalr	968(ra) # 586a <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    24aa:	862a                	mv	a2,a0
    24ac:	85a6                	mv	a1,s1
    24ae:	00004517          	auipc	a0,0x4
    24b2:	3ca50513          	addi	a0,a0,970 # 6878 <malloc+0xbd8>
    24b6:	00003097          	auipc	ra,0x3
    24ba:	72c080e7          	jalr	1836(ra) # 5be2 <printf>
    exit(1);
    24be:	4505                	li	a0,1
    24c0:	00003097          	auipc	ra,0x3
    24c4:	3aa080e7          	jalr	938(ra) # 586a <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    24c8:	862a                	mv	a2,a0
    24ca:	85a6                	mv	a1,s1
    24cc:	00004517          	auipc	a0,0x4
    24d0:	3cc50513          	addi	a0,a0,972 # 6898 <malloc+0xbf8>
    24d4:	00003097          	auipc	ra,0x3
    24d8:	70e080e7          	jalr	1806(ra) # 5be2 <printf>
    exit(1);
    24dc:	4505                	li	a0,1
    24de:	00003097          	auipc	ra,0x3
    24e2:	38c080e7          	jalr	908(ra) # 586a <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    24e6:	86aa                	mv	a3,a0
    24e8:	8626                	mv	a2,s1
    24ea:	85a6                	mv	a1,s1
    24ec:	00004517          	auipc	a0,0x4
    24f0:	3cc50513          	addi	a0,a0,972 # 68b8 <malloc+0xc18>
    24f4:	00003097          	auipc	ra,0x3
    24f8:	6ee080e7          	jalr	1774(ra) # 5be2 <printf>
    exit(1);
    24fc:	4505                	li	a0,1
    24fe:	00003097          	auipc	ra,0x3
    2502:	36c080e7          	jalr	876(ra) # 586a <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2506:	567d                	li	a2,-1
    2508:	85a6                	mv	a1,s1
    250a:	00004517          	auipc	a0,0x4
    250e:	3d650513          	addi	a0,a0,982 # 68e0 <malloc+0xc40>
    2512:	00003097          	auipc	ra,0x3
    2516:	6d0080e7          	jalr	1744(ra) # 5be2 <printf>
    exit(1);
    251a:	4505                	li	a0,1
    251c:	00003097          	auipc	ra,0x3
    2520:	34e080e7          	jalr	846(ra) # 586a <exit>

0000000000002524 <rwsbrk>:
{
    2524:	1101                	addi	sp,sp,-32
    2526:	ec06                	sd	ra,24(sp)
    2528:	e822                	sd	s0,16(sp)
    252a:	e426                	sd	s1,8(sp)
    252c:	e04a                	sd	s2,0(sp)
    252e:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2530:	6509                	lui	a0,0x2
    2532:	00003097          	auipc	ra,0x3
    2536:	3c0080e7          	jalr	960(ra) # 58f2 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    253a:	57fd                	li	a5,-1
    253c:	06f50363          	beq	a0,a5,25a2 <rwsbrk+0x7e>
    2540:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2542:	7579                	lui	a0,0xffffe
    2544:	00003097          	auipc	ra,0x3
    2548:	3ae080e7          	jalr	942(ra) # 58f2 <sbrk>
    254c:	57fd                	li	a5,-1
    254e:	06f50763          	beq	a0,a5,25bc <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2552:	20100593          	li	a1,513
    2556:	00004517          	auipc	a0,0x4
    255a:	8ba50513          	addi	a0,a0,-1862 # 5e10 <malloc+0x170>
    255e:	00003097          	auipc	ra,0x3
    2562:	34c080e7          	jalr	844(ra) # 58aa <open>
    2566:	892a                	mv	s2,a0
  if(fd < 0){
    2568:	06054763          	bltz	a0,25d6 <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    256c:	6505                	lui	a0,0x1
    256e:	94aa                	add	s1,s1,a0
    2570:	40000613          	li	a2,1024
    2574:	85a6                	mv	a1,s1
    2576:	854a                	mv	a0,s2
    2578:	00003097          	auipc	ra,0x3
    257c:	312080e7          	jalr	786(ra) # 588a <write>
    2580:	862a                	mv	a2,a0
  if(n >= 0){
    2582:	06054763          	bltz	a0,25f0 <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    2586:	85a6                	mv	a1,s1
    2588:	00005517          	auipc	a0,0x5
    258c:	8a050513          	addi	a0,a0,-1888 # 6e28 <malloc+0x1188>
    2590:	00003097          	auipc	ra,0x3
    2594:	652080e7          	jalr	1618(ra) # 5be2 <printf>
    exit(1);
    2598:	4505                	li	a0,1
    259a:	00003097          	auipc	ra,0x3
    259e:	2d0080e7          	jalr	720(ra) # 586a <exit>
    printf("sbrk(rwsbrk) failed\n");
    25a2:	00005517          	auipc	a0,0x5
    25a6:	83650513          	addi	a0,a0,-1994 # 6dd8 <malloc+0x1138>
    25aa:	00003097          	auipc	ra,0x3
    25ae:	638080e7          	jalr	1592(ra) # 5be2 <printf>
    exit(1);
    25b2:	4505                	li	a0,1
    25b4:	00003097          	auipc	ra,0x3
    25b8:	2b6080e7          	jalr	694(ra) # 586a <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    25bc:	00005517          	auipc	a0,0x5
    25c0:	83450513          	addi	a0,a0,-1996 # 6df0 <malloc+0x1150>
    25c4:	00003097          	auipc	ra,0x3
    25c8:	61e080e7          	jalr	1566(ra) # 5be2 <printf>
    exit(1);
    25cc:	4505                	li	a0,1
    25ce:	00003097          	auipc	ra,0x3
    25d2:	29c080e7          	jalr	668(ra) # 586a <exit>
    printf("open(rwsbrk) failed\n");
    25d6:	00005517          	auipc	a0,0x5
    25da:	83a50513          	addi	a0,a0,-1990 # 6e10 <malloc+0x1170>
    25de:	00003097          	auipc	ra,0x3
    25e2:	604080e7          	jalr	1540(ra) # 5be2 <printf>
    exit(1);
    25e6:	4505                	li	a0,1
    25e8:	00003097          	auipc	ra,0x3
    25ec:	282080e7          	jalr	642(ra) # 586a <exit>
  close(fd);
    25f0:	854a                	mv	a0,s2
    25f2:	00003097          	auipc	ra,0x3
    25f6:	2a0080e7          	jalr	672(ra) # 5892 <close>
  unlink("rwsbrk");
    25fa:	00004517          	auipc	a0,0x4
    25fe:	81650513          	addi	a0,a0,-2026 # 5e10 <malloc+0x170>
    2602:	00003097          	auipc	ra,0x3
    2606:	2b8080e7          	jalr	696(ra) # 58ba <unlink>
  fd = open("README", O_RDONLY);
    260a:	4581                	li	a1,0
    260c:	00004517          	auipc	a0,0x4
    2610:	cac50513          	addi	a0,a0,-852 # 62b8 <malloc+0x618>
    2614:	00003097          	auipc	ra,0x3
    2618:	296080e7          	jalr	662(ra) # 58aa <open>
    261c:	892a                	mv	s2,a0
  if(fd < 0){
    261e:	02054963          	bltz	a0,2650 <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    2622:	4629                	li	a2,10
    2624:	85a6                	mv	a1,s1
    2626:	00003097          	auipc	ra,0x3
    262a:	25c080e7          	jalr	604(ra) # 5882 <read>
    262e:	862a                	mv	a2,a0
  if(n >= 0){
    2630:	02054d63          	bltz	a0,266a <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2634:	85a6                	mv	a1,s1
    2636:	00005517          	auipc	a0,0x5
    263a:	82250513          	addi	a0,a0,-2014 # 6e58 <malloc+0x11b8>
    263e:	00003097          	auipc	ra,0x3
    2642:	5a4080e7          	jalr	1444(ra) # 5be2 <printf>
    exit(1);
    2646:	4505                	li	a0,1
    2648:	00003097          	auipc	ra,0x3
    264c:	222080e7          	jalr	546(ra) # 586a <exit>
    printf("open(rwsbrk) failed\n");
    2650:	00004517          	auipc	a0,0x4
    2654:	7c050513          	addi	a0,a0,1984 # 6e10 <malloc+0x1170>
    2658:	00003097          	auipc	ra,0x3
    265c:	58a080e7          	jalr	1418(ra) # 5be2 <printf>
    exit(1);
    2660:	4505                	li	a0,1
    2662:	00003097          	auipc	ra,0x3
    2666:	208080e7          	jalr	520(ra) # 586a <exit>
  close(fd);
    266a:	854a                	mv	a0,s2
    266c:	00003097          	auipc	ra,0x3
    2670:	226080e7          	jalr	550(ra) # 5892 <close>
  exit(0);
    2674:	4501                	li	a0,0
    2676:	00003097          	auipc	ra,0x3
    267a:	1f4080e7          	jalr	500(ra) # 586a <exit>

000000000000267e <sbrkbasic>:
{
    267e:	715d                	addi	sp,sp,-80
    2680:	e486                	sd	ra,72(sp)
    2682:	e0a2                	sd	s0,64(sp)
    2684:	fc26                	sd	s1,56(sp)
    2686:	f84a                	sd	s2,48(sp)
    2688:	f44e                	sd	s3,40(sp)
    268a:	f052                	sd	s4,32(sp)
    268c:	ec56                	sd	s5,24(sp)
    268e:	0880                	addi	s0,sp,80
    2690:	8a2a                	mv	s4,a0
  pid = fork();
    2692:	00003097          	auipc	ra,0x3
    2696:	1d0080e7          	jalr	464(ra) # 5862 <fork>
  if(pid < 0){
    269a:	02054c63          	bltz	a0,26d2 <sbrkbasic+0x54>
  if(pid == 0){
    269e:	ed21                	bnez	a0,26f6 <sbrkbasic+0x78>
    a = sbrk(TOOMUCH);
    26a0:	40000537          	lui	a0,0x40000
    26a4:	00003097          	auipc	ra,0x3
    26a8:	24e080e7          	jalr	590(ra) # 58f2 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    26ac:	57fd                	li	a5,-1
    26ae:	02f50f63          	beq	a0,a5,26ec <sbrkbasic+0x6e>
    for(b = a; b < a+TOOMUCH; b += 4096){
    26b2:	400007b7          	lui	a5,0x40000
    26b6:	97aa                	add	a5,a5,a0
      *b = 99;
    26b8:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    26bc:	6705                	lui	a4,0x1
      *b = 99;
    26be:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1248>
    for(b = a; b < a+TOOMUCH; b += 4096){
    26c2:	953a                	add	a0,a0,a4
    26c4:	fef51de3          	bne	a0,a5,26be <sbrkbasic+0x40>
    exit(1);
    26c8:	4505                	li	a0,1
    26ca:	00003097          	auipc	ra,0x3
    26ce:	1a0080e7          	jalr	416(ra) # 586a <exit>
    printf("fork failed in sbrkbasic\n");
    26d2:	00004517          	auipc	a0,0x4
    26d6:	7ae50513          	addi	a0,a0,1966 # 6e80 <malloc+0x11e0>
    26da:	00003097          	auipc	ra,0x3
    26de:	508080e7          	jalr	1288(ra) # 5be2 <printf>
    exit(1);
    26e2:	4505                	li	a0,1
    26e4:	00003097          	auipc	ra,0x3
    26e8:	186080e7          	jalr	390(ra) # 586a <exit>
      exit(0);
    26ec:	4501                	li	a0,0
    26ee:	00003097          	auipc	ra,0x3
    26f2:	17c080e7          	jalr	380(ra) # 586a <exit>
  wait(&xstatus);
    26f6:	fbc40513          	addi	a0,s0,-68
    26fa:	00003097          	auipc	ra,0x3
    26fe:	178080e7          	jalr	376(ra) # 5872 <wait>
  if(xstatus == 1){
    2702:	fbc42703          	lw	a4,-68(s0)
    2706:	4785                	li	a5,1
    2708:	00f70e63          	beq	a4,a5,2724 <sbrkbasic+0xa6>
  a = sbrk(0);
    270c:	4501                	li	a0,0
    270e:	00003097          	auipc	ra,0x3
    2712:	1e4080e7          	jalr	484(ra) # 58f2 <sbrk>
    2716:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2718:	4901                	li	s2,0
    *b = 1;
    271a:	4a85                	li	s5,1
  for(i = 0; i < 5000; i++){
    271c:	6985                	lui	s3,0x1
    271e:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1be>
    2722:	a005                	j	2742 <sbrkbasic+0xc4>
    printf("%s: too much memory allocated!\n", s);
    2724:	85d2                	mv	a1,s4
    2726:	00004517          	auipc	a0,0x4
    272a:	77a50513          	addi	a0,a0,1914 # 6ea0 <malloc+0x1200>
    272e:	00003097          	auipc	ra,0x3
    2732:	4b4080e7          	jalr	1204(ra) # 5be2 <printf>
    exit(1);
    2736:	4505                	li	a0,1
    2738:	00003097          	auipc	ra,0x3
    273c:	132080e7          	jalr	306(ra) # 586a <exit>
    a = b + 1;
    2740:	84be                	mv	s1,a5
    b = sbrk(1);
    2742:	4505                	li	a0,1
    2744:	00003097          	auipc	ra,0x3
    2748:	1ae080e7          	jalr	430(ra) # 58f2 <sbrk>
    if(b != a){
    274c:	04951b63          	bne	a0,s1,27a2 <sbrkbasic+0x124>
    *b = 1;
    2750:	01548023          	sb	s5,0(s1)
    a = b + 1;
    2754:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2758:	2905                	addiw	s2,s2,1
    275a:	ff3913e3          	bne	s2,s3,2740 <sbrkbasic+0xc2>
  pid = fork();
    275e:	00003097          	auipc	ra,0x3
    2762:	104080e7          	jalr	260(ra) # 5862 <fork>
    2766:	892a                	mv	s2,a0
  if(pid < 0){
    2768:	04054e63          	bltz	a0,27c4 <sbrkbasic+0x146>
  c = sbrk(1);
    276c:	4505                	li	a0,1
    276e:	00003097          	auipc	ra,0x3
    2772:	184080e7          	jalr	388(ra) # 58f2 <sbrk>
  c = sbrk(1);
    2776:	4505                	li	a0,1
    2778:	00003097          	auipc	ra,0x3
    277c:	17a080e7          	jalr	378(ra) # 58f2 <sbrk>
  if(c != a + 1){
    2780:	0489                	addi	s1,s1,2
    2782:	04a48f63          	beq	s1,a0,27e0 <sbrkbasic+0x162>
    printf("%s: sbrk test failed post-fork\n", s);
    2786:	85d2                	mv	a1,s4
    2788:	00004517          	auipc	a0,0x4
    278c:	77850513          	addi	a0,a0,1912 # 6f00 <malloc+0x1260>
    2790:	00003097          	auipc	ra,0x3
    2794:	452080e7          	jalr	1106(ra) # 5be2 <printf>
    exit(1);
    2798:	4505                	li	a0,1
    279a:	00003097          	auipc	ra,0x3
    279e:	0d0080e7          	jalr	208(ra) # 586a <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    27a2:	872a                	mv	a4,a0
    27a4:	86a6                	mv	a3,s1
    27a6:	864a                	mv	a2,s2
    27a8:	85d2                	mv	a1,s4
    27aa:	00004517          	auipc	a0,0x4
    27ae:	71650513          	addi	a0,a0,1814 # 6ec0 <malloc+0x1220>
    27b2:	00003097          	auipc	ra,0x3
    27b6:	430080e7          	jalr	1072(ra) # 5be2 <printf>
      exit(1);
    27ba:	4505                	li	a0,1
    27bc:	00003097          	auipc	ra,0x3
    27c0:	0ae080e7          	jalr	174(ra) # 586a <exit>
    printf("%s: sbrk test fork failed\n", s);
    27c4:	85d2                	mv	a1,s4
    27c6:	00004517          	auipc	a0,0x4
    27ca:	71a50513          	addi	a0,a0,1818 # 6ee0 <malloc+0x1240>
    27ce:	00003097          	auipc	ra,0x3
    27d2:	414080e7          	jalr	1044(ra) # 5be2 <printf>
    exit(1);
    27d6:	4505                	li	a0,1
    27d8:	00003097          	auipc	ra,0x3
    27dc:	092080e7          	jalr	146(ra) # 586a <exit>
  if(pid == 0)
    27e0:	00091763          	bnez	s2,27ee <sbrkbasic+0x170>
    exit(0);
    27e4:	4501                	li	a0,0
    27e6:	00003097          	auipc	ra,0x3
    27ea:	084080e7          	jalr	132(ra) # 586a <exit>
  wait(&xstatus);
    27ee:	fbc40513          	addi	a0,s0,-68
    27f2:	00003097          	auipc	ra,0x3
    27f6:	080080e7          	jalr	128(ra) # 5872 <wait>
  exit(xstatus);
    27fa:	fbc42503          	lw	a0,-68(s0)
    27fe:	00003097          	auipc	ra,0x3
    2802:	06c080e7          	jalr	108(ra) # 586a <exit>

0000000000002806 <sbrkmuch>:
{
    2806:	7179                	addi	sp,sp,-48
    2808:	f406                	sd	ra,40(sp)
    280a:	f022                	sd	s0,32(sp)
    280c:	ec26                	sd	s1,24(sp)
    280e:	e84a                	sd	s2,16(sp)
    2810:	e44e                	sd	s3,8(sp)
    2812:	e052                	sd	s4,0(sp)
    2814:	1800                	addi	s0,sp,48
    2816:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2818:	4501                	li	a0,0
    281a:	00003097          	auipc	ra,0x3
    281e:	0d8080e7          	jalr	216(ra) # 58f2 <sbrk>
    2822:	892a                	mv	s2,a0
  a = sbrk(0);
    2824:	4501                	li	a0,0
    2826:	00003097          	auipc	ra,0x3
    282a:	0cc080e7          	jalr	204(ra) # 58f2 <sbrk>
    282e:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2830:	06400537          	lui	a0,0x6400
    2834:	9d05                	subw	a0,a0,s1
    2836:	00003097          	auipc	ra,0x3
    283a:	0bc080e7          	jalr	188(ra) # 58f2 <sbrk>
  if (p != a) {
    283e:	0ca49863          	bne	s1,a0,290e <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2842:	4501                	li	a0,0
    2844:	00003097          	auipc	ra,0x3
    2848:	0ae080e7          	jalr	174(ra) # 58f2 <sbrk>
    284c:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    284e:	00a4f963          	bgeu	s1,a0,2860 <sbrkmuch+0x5a>
    *pp = 1;
    2852:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2854:	6705                	lui	a4,0x1
    *pp = 1;
    2856:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    285a:	94ba                	add	s1,s1,a4
    285c:	fef4ede3          	bltu	s1,a5,2856 <sbrkmuch+0x50>
  *lastaddr = 99;
    2860:	064007b7          	lui	a5,0x6400
    2864:	06300713          	li	a4,99
    2868:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1247>
  a = sbrk(0);
    286c:	4501                	li	a0,0
    286e:	00003097          	auipc	ra,0x3
    2872:	084080e7          	jalr	132(ra) # 58f2 <sbrk>
    2876:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2878:	757d                	lui	a0,0xfffff
    287a:	00003097          	auipc	ra,0x3
    287e:	078080e7          	jalr	120(ra) # 58f2 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2882:	57fd                	li	a5,-1
    2884:	0af50363          	beq	a0,a5,292a <sbrkmuch+0x124>
  c = sbrk(0);
    2888:	4501                	li	a0,0
    288a:	00003097          	auipc	ra,0x3
    288e:	068080e7          	jalr	104(ra) # 58f2 <sbrk>
  if(c != a - PGSIZE){
    2892:	77fd                	lui	a5,0xfffff
    2894:	97a6                	add	a5,a5,s1
    2896:	0af51863          	bne	a0,a5,2946 <sbrkmuch+0x140>
  a = sbrk(0);
    289a:	4501                	li	a0,0
    289c:	00003097          	auipc	ra,0x3
    28a0:	056080e7          	jalr	86(ra) # 58f2 <sbrk>
    28a4:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    28a6:	6505                	lui	a0,0x1
    28a8:	00003097          	auipc	ra,0x3
    28ac:	04a080e7          	jalr	74(ra) # 58f2 <sbrk>
    28b0:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    28b2:	0aa49a63          	bne	s1,a0,2966 <sbrkmuch+0x160>
    28b6:	4501                	li	a0,0
    28b8:	00003097          	auipc	ra,0x3
    28bc:	03a080e7          	jalr	58(ra) # 58f2 <sbrk>
    28c0:	6785                	lui	a5,0x1
    28c2:	97a6                	add	a5,a5,s1
    28c4:	0af51163          	bne	a0,a5,2966 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    28c8:	064007b7          	lui	a5,0x6400
    28cc:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1247>
    28d0:	06300793          	li	a5,99
    28d4:	0af70963          	beq	a4,a5,2986 <sbrkmuch+0x180>
  a = sbrk(0);
    28d8:	4501                	li	a0,0
    28da:	00003097          	auipc	ra,0x3
    28de:	018080e7          	jalr	24(ra) # 58f2 <sbrk>
    28e2:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    28e4:	4501                	li	a0,0
    28e6:	00003097          	auipc	ra,0x3
    28ea:	00c080e7          	jalr	12(ra) # 58f2 <sbrk>
    28ee:	40a9053b          	subw	a0,s2,a0
    28f2:	00003097          	auipc	ra,0x3
    28f6:	000080e7          	jalr	ra # 58f2 <sbrk>
  if(c != a){
    28fa:	0aa49463          	bne	s1,a0,29a2 <sbrkmuch+0x19c>
}
    28fe:	70a2                	ld	ra,40(sp)
    2900:	7402                	ld	s0,32(sp)
    2902:	64e2                	ld	s1,24(sp)
    2904:	6942                	ld	s2,16(sp)
    2906:	69a2                	ld	s3,8(sp)
    2908:	6a02                	ld	s4,0(sp)
    290a:	6145                	addi	sp,sp,48
    290c:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    290e:	85ce                	mv	a1,s3
    2910:	00004517          	auipc	a0,0x4
    2914:	61050513          	addi	a0,a0,1552 # 6f20 <malloc+0x1280>
    2918:	00003097          	auipc	ra,0x3
    291c:	2ca080e7          	jalr	714(ra) # 5be2 <printf>
    exit(1);
    2920:	4505                	li	a0,1
    2922:	00003097          	auipc	ra,0x3
    2926:	f48080e7          	jalr	-184(ra) # 586a <exit>
    printf("%s: sbrk could not deallocate\n", s);
    292a:	85ce                	mv	a1,s3
    292c:	00004517          	auipc	a0,0x4
    2930:	63c50513          	addi	a0,a0,1596 # 6f68 <malloc+0x12c8>
    2934:	00003097          	auipc	ra,0x3
    2938:	2ae080e7          	jalr	686(ra) # 5be2 <printf>
    exit(1);
    293c:	4505                	li	a0,1
    293e:	00003097          	auipc	ra,0x3
    2942:	f2c080e7          	jalr	-212(ra) # 586a <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2946:	86aa                	mv	a3,a0
    2948:	8626                	mv	a2,s1
    294a:	85ce                	mv	a1,s3
    294c:	00004517          	auipc	a0,0x4
    2950:	63c50513          	addi	a0,a0,1596 # 6f88 <malloc+0x12e8>
    2954:	00003097          	auipc	ra,0x3
    2958:	28e080e7          	jalr	654(ra) # 5be2 <printf>
    exit(1);
    295c:	4505                	li	a0,1
    295e:	00003097          	auipc	ra,0x3
    2962:	f0c080e7          	jalr	-244(ra) # 586a <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2966:	86d2                	mv	a3,s4
    2968:	8626                	mv	a2,s1
    296a:	85ce                	mv	a1,s3
    296c:	00004517          	auipc	a0,0x4
    2970:	65c50513          	addi	a0,a0,1628 # 6fc8 <malloc+0x1328>
    2974:	00003097          	auipc	ra,0x3
    2978:	26e080e7          	jalr	622(ra) # 5be2 <printf>
    exit(1);
    297c:	4505                	li	a0,1
    297e:	00003097          	auipc	ra,0x3
    2982:	eec080e7          	jalr	-276(ra) # 586a <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2986:	85ce                	mv	a1,s3
    2988:	00004517          	auipc	a0,0x4
    298c:	67050513          	addi	a0,a0,1648 # 6ff8 <malloc+0x1358>
    2990:	00003097          	auipc	ra,0x3
    2994:	252080e7          	jalr	594(ra) # 5be2 <printf>
    exit(1);
    2998:	4505                	li	a0,1
    299a:	00003097          	auipc	ra,0x3
    299e:	ed0080e7          	jalr	-304(ra) # 586a <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    29a2:	86aa                	mv	a3,a0
    29a4:	8626                	mv	a2,s1
    29a6:	85ce                	mv	a1,s3
    29a8:	00004517          	auipc	a0,0x4
    29ac:	68850513          	addi	a0,a0,1672 # 7030 <malloc+0x1390>
    29b0:	00003097          	auipc	ra,0x3
    29b4:	232080e7          	jalr	562(ra) # 5be2 <printf>
    exit(1);
    29b8:	4505                	li	a0,1
    29ba:	00003097          	auipc	ra,0x3
    29be:	eb0080e7          	jalr	-336(ra) # 586a <exit>

00000000000029c2 <sbrkarg>:
{
    29c2:	7179                	addi	sp,sp,-48
    29c4:	f406                	sd	ra,40(sp)
    29c6:	f022                	sd	s0,32(sp)
    29c8:	ec26                	sd	s1,24(sp)
    29ca:	e84a                	sd	s2,16(sp)
    29cc:	e44e                	sd	s3,8(sp)
    29ce:	1800                	addi	s0,sp,48
    29d0:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    29d2:	6505                	lui	a0,0x1
    29d4:	00003097          	auipc	ra,0x3
    29d8:	f1e080e7          	jalr	-226(ra) # 58f2 <sbrk>
    29dc:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    29de:	20100593          	li	a1,513
    29e2:	00004517          	auipc	a0,0x4
    29e6:	67650513          	addi	a0,a0,1654 # 7058 <malloc+0x13b8>
    29ea:	00003097          	auipc	ra,0x3
    29ee:	ec0080e7          	jalr	-320(ra) # 58aa <open>
    29f2:	84aa                	mv	s1,a0
  unlink("sbrk");
    29f4:	00004517          	auipc	a0,0x4
    29f8:	66450513          	addi	a0,a0,1636 # 7058 <malloc+0x13b8>
    29fc:	00003097          	auipc	ra,0x3
    2a00:	ebe080e7          	jalr	-322(ra) # 58ba <unlink>
  if(fd < 0)  {
    2a04:	0404c163          	bltz	s1,2a46 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2a08:	6605                	lui	a2,0x1
    2a0a:	85ca                	mv	a1,s2
    2a0c:	8526                	mv	a0,s1
    2a0e:	00003097          	auipc	ra,0x3
    2a12:	e7c080e7          	jalr	-388(ra) # 588a <write>
    2a16:	04054663          	bltz	a0,2a62 <sbrkarg+0xa0>
  close(fd);
    2a1a:	8526                	mv	a0,s1
    2a1c:	00003097          	auipc	ra,0x3
    2a20:	e76080e7          	jalr	-394(ra) # 5892 <close>
  a = sbrk(PGSIZE);
    2a24:	6505                	lui	a0,0x1
    2a26:	00003097          	auipc	ra,0x3
    2a2a:	ecc080e7          	jalr	-308(ra) # 58f2 <sbrk>
  if(pipe((int *) a) != 0){
    2a2e:	00003097          	auipc	ra,0x3
    2a32:	e4c080e7          	jalr	-436(ra) # 587a <pipe>
    2a36:	e521                	bnez	a0,2a7e <sbrkarg+0xbc>
}
    2a38:	70a2                	ld	ra,40(sp)
    2a3a:	7402                	ld	s0,32(sp)
    2a3c:	64e2                	ld	s1,24(sp)
    2a3e:	6942                	ld	s2,16(sp)
    2a40:	69a2                	ld	s3,8(sp)
    2a42:	6145                	addi	sp,sp,48
    2a44:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2a46:	85ce                	mv	a1,s3
    2a48:	00004517          	auipc	a0,0x4
    2a4c:	61850513          	addi	a0,a0,1560 # 7060 <malloc+0x13c0>
    2a50:	00003097          	auipc	ra,0x3
    2a54:	192080e7          	jalr	402(ra) # 5be2 <printf>
    exit(1);
    2a58:	4505                	li	a0,1
    2a5a:	00003097          	auipc	ra,0x3
    2a5e:	e10080e7          	jalr	-496(ra) # 586a <exit>
    printf("%s: write sbrk failed\n", s);
    2a62:	85ce                	mv	a1,s3
    2a64:	00004517          	auipc	a0,0x4
    2a68:	61450513          	addi	a0,a0,1556 # 7078 <malloc+0x13d8>
    2a6c:	00003097          	auipc	ra,0x3
    2a70:	176080e7          	jalr	374(ra) # 5be2 <printf>
    exit(1);
    2a74:	4505                	li	a0,1
    2a76:	00003097          	auipc	ra,0x3
    2a7a:	df4080e7          	jalr	-524(ra) # 586a <exit>
    printf("%s: pipe() failed\n", s);
    2a7e:	85ce                	mv	a1,s3
    2a80:	00004517          	auipc	a0,0x4
    2a84:	fe050513          	addi	a0,a0,-32 # 6a60 <malloc+0xdc0>
    2a88:	00003097          	auipc	ra,0x3
    2a8c:	15a080e7          	jalr	346(ra) # 5be2 <printf>
    exit(1);
    2a90:	4505                	li	a0,1
    2a92:	00003097          	auipc	ra,0x3
    2a96:	dd8080e7          	jalr	-552(ra) # 586a <exit>

0000000000002a9a <argptest>:
{
    2a9a:	1101                	addi	sp,sp,-32
    2a9c:	ec06                	sd	ra,24(sp)
    2a9e:	e822                	sd	s0,16(sp)
    2aa0:	e426                	sd	s1,8(sp)
    2aa2:	e04a                	sd	s2,0(sp)
    2aa4:	1000                	addi	s0,sp,32
    2aa6:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2aa8:	4581                	li	a1,0
    2aaa:	00004517          	auipc	a0,0x4
    2aae:	5e650513          	addi	a0,a0,1510 # 7090 <malloc+0x13f0>
    2ab2:	00003097          	auipc	ra,0x3
    2ab6:	df8080e7          	jalr	-520(ra) # 58aa <open>
  if (fd < 0) {
    2aba:	02054b63          	bltz	a0,2af0 <argptest+0x56>
    2abe:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2ac0:	4501                	li	a0,0
    2ac2:	00003097          	auipc	ra,0x3
    2ac6:	e30080e7          	jalr	-464(ra) # 58f2 <sbrk>
    2aca:	567d                	li	a2,-1
    2acc:	fff50593          	addi	a1,a0,-1
    2ad0:	8526                	mv	a0,s1
    2ad2:	00003097          	auipc	ra,0x3
    2ad6:	db0080e7          	jalr	-592(ra) # 5882 <read>
  close(fd);
    2ada:	8526                	mv	a0,s1
    2adc:	00003097          	auipc	ra,0x3
    2ae0:	db6080e7          	jalr	-586(ra) # 5892 <close>
}
    2ae4:	60e2                	ld	ra,24(sp)
    2ae6:	6442                	ld	s0,16(sp)
    2ae8:	64a2                	ld	s1,8(sp)
    2aea:	6902                	ld	s2,0(sp)
    2aec:	6105                	addi	sp,sp,32
    2aee:	8082                	ret
    printf("%s: open failed\n", s);
    2af0:	85ca                	mv	a1,s2
    2af2:	00004517          	auipc	a0,0x4
    2af6:	e7e50513          	addi	a0,a0,-386 # 6970 <malloc+0xcd0>
    2afa:	00003097          	auipc	ra,0x3
    2afe:	0e8080e7          	jalr	232(ra) # 5be2 <printf>
    exit(1);
    2b02:	4505                	li	a0,1
    2b04:	00003097          	auipc	ra,0x3
    2b08:	d66080e7          	jalr	-666(ra) # 586a <exit>

0000000000002b0c <sbrkbugs>:
{
    2b0c:	1141                	addi	sp,sp,-16
    2b0e:	e406                	sd	ra,8(sp)
    2b10:	e022                	sd	s0,0(sp)
    2b12:	0800                	addi	s0,sp,16
  int pid = fork();
    2b14:	00003097          	auipc	ra,0x3
    2b18:	d4e080e7          	jalr	-690(ra) # 5862 <fork>
  if(pid < 0){
    2b1c:	02054263          	bltz	a0,2b40 <sbrkbugs+0x34>
  if(pid == 0){
    2b20:	ed0d                	bnez	a0,2b5a <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2b22:	00003097          	auipc	ra,0x3
    2b26:	dd0080e7          	jalr	-560(ra) # 58f2 <sbrk>
    sbrk(-sz);
    2b2a:	40a0053b          	negw	a0,a0
    2b2e:	00003097          	auipc	ra,0x3
    2b32:	dc4080e7          	jalr	-572(ra) # 58f2 <sbrk>
    exit(0);
    2b36:	4501                	li	a0,0
    2b38:	00003097          	auipc	ra,0x3
    2b3c:	d32080e7          	jalr	-718(ra) # 586a <exit>
    printf("fork failed\n");
    2b40:	00004517          	auipc	a0,0x4
    2b44:	23850513          	addi	a0,a0,568 # 6d78 <malloc+0x10d8>
    2b48:	00003097          	auipc	ra,0x3
    2b4c:	09a080e7          	jalr	154(ra) # 5be2 <printf>
    exit(1);
    2b50:	4505                	li	a0,1
    2b52:	00003097          	auipc	ra,0x3
    2b56:	d18080e7          	jalr	-744(ra) # 586a <exit>
  wait(0);
    2b5a:	4501                	li	a0,0
    2b5c:	00003097          	auipc	ra,0x3
    2b60:	d16080e7          	jalr	-746(ra) # 5872 <wait>
  pid = fork();
    2b64:	00003097          	auipc	ra,0x3
    2b68:	cfe080e7          	jalr	-770(ra) # 5862 <fork>
  if(pid < 0){
    2b6c:	02054563          	bltz	a0,2b96 <sbrkbugs+0x8a>
  if(pid == 0){
    2b70:	e121                	bnez	a0,2bb0 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2b72:	00003097          	auipc	ra,0x3
    2b76:	d80080e7          	jalr	-640(ra) # 58f2 <sbrk>
    sbrk(-(sz - 3500));
    2b7a:	6785                	lui	a5,0x1
    2b7c:	dac7879b          	addiw	a5,a5,-596
    2b80:	40a7853b          	subw	a0,a5,a0
    2b84:	00003097          	auipc	ra,0x3
    2b88:	d6e080e7          	jalr	-658(ra) # 58f2 <sbrk>
    exit(0);
    2b8c:	4501                	li	a0,0
    2b8e:	00003097          	auipc	ra,0x3
    2b92:	cdc080e7          	jalr	-804(ra) # 586a <exit>
    printf("fork failed\n");
    2b96:	00004517          	auipc	a0,0x4
    2b9a:	1e250513          	addi	a0,a0,482 # 6d78 <malloc+0x10d8>
    2b9e:	00003097          	auipc	ra,0x3
    2ba2:	044080e7          	jalr	68(ra) # 5be2 <printf>
    exit(1);
    2ba6:	4505                	li	a0,1
    2ba8:	00003097          	auipc	ra,0x3
    2bac:	cc2080e7          	jalr	-830(ra) # 586a <exit>
  wait(0);
    2bb0:	4501                	li	a0,0
    2bb2:	00003097          	auipc	ra,0x3
    2bb6:	cc0080e7          	jalr	-832(ra) # 5872 <wait>
  pid = fork();
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	ca8080e7          	jalr	-856(ra) # 5862 <fork>
  if(pid < 0){
    2bc2:	02054a63          	bltz	a0,2bf6 <sbrkbugs+0xea>
  if(pid == 0){
    2bc6:	e529                	bnez	a0,2c10 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2bc8:	00003097          	auipc	ra,0x3
    2bcc:	d2a080e7          	jalr	-726(ra) # 58f2 <sbrk>
    2bd0:	67ad                	lui	a5,0xb
    2bd2:	8007879b          	addiw	a5,a5,-2048
    2bd6:	40a7853b          	subw	a0,a5,a0
    2bda:	00003097          	auipc	ra,0x3
    2bde:	d18080e7          	jalr	-744(ra) # 58f2 <sbrk>
    sbrk(-10);
    2be2:	5559                	li	a0,-10
    2be4:	00003097          	auipc	ra,0x3
    2be8:	d0e080e7          	jalr	-754(ra) # 58f2 <sbrk>
    exit(0);
    2bec:	4501                	li	a0,0
    2bee:	00003097          	auipc	ra,0x3
    2bf2:	c7c080e7          	jalr	-900(ra) # 586a <exit>
    printf("fork failed\n");
    2bf6:	00004517          	auipc	a0,0x4
    2bfa:	18250513          	addi	a0,a0,386 # 6d78 <malloc+0x10d8>
    2bfe:	00003097          	auipc	ra,0x3
    2c02:	fe4080e7          	jalr	-28(ra) # 5be2 <printf>
    exit(1);
    2c06:	4505                	li	a0,1
    2c08:	00003097          	auipc	ra,0x3
    2c0c:	c62080e7          	jalr	-926(ra) # 586a <exit>
  wait(0);
    2c10:	4501                	li	a0,0
    2c12:	00003097          	auipc	ra,0x3
    2c16:	c60080e7          	jalr	-928(ra) # 5872 <wait>
  exit(0);
    2c1a:	4501                	li	a0,0
    2c1c:	00003097          	auipc	ra,0x3
    2c20:	c4e080e7          	jalr	-946(ra) # 586a <exit>

0000000000002c24 <sbrklast>:
{
    2c24:	7179                	addi	sp,sp,-48
    2c26:	f406                	sd	ra,40(sp)
    2c28:	f022                	sd	s0,32(sp)
    2c2a:	ec26                	sd	s1,24(sp)
    2c2c:	e84a                	sd	s2,16(sp)
    2c2e:	e44e                	sd	s3,8(sp)
    2c30:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2c32:	4501                	li	a0,0
    2c34:	00003097          	auipc	ra,0x3
    2c38:	cbe080e7          	jalr	-834(ra) # 58f2 <sbrk>
  if((top % 4096) != 0)
    2c3c:	03451793          	slli	a5,a0,0x34
    2c40:	efc1                	bnez	a5,2cd8 <sbrklast+0xb4>
  sbrk(4096);
    2c42:	6505                	lui	a0,0x1
    2c44:	00003097          	auipc	ra,0x3
    2c48:	cae080e7          	jalr	-850(ra) # 58f2 <sbrk>
  sbrk(10);
    2c4c:	4529                	li	a0,10
    2c4e:	00003097          	auipc	ra,0x3
    2c52:	ca4080e7          	jalr	-860(ra) # 58f2 <sbrk>
  sbrk(-20);
    2c56:	5531                	li	a0,-20
    2c58:	00003097          	auipc	ra,0x3
    2c5c:	c9a080e7          	jalr	-870(ra) # 58f2 <sbrk>
  top = (uint64) sbrk(0);
    2c60:	4501                	li	a0,0
    2c62:	00003097          	auipc	ra,0x3
    2c66:	c90080e7          	jalr	-880(ra) # 58f2 <sbrk>
    2c6a:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2c6c:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x46>
  p[0] = 'x';
    2c70:	07800793          	li	a5,120
    2c74:	fcf50023          	sb	a5,-64(a0)
  p[1] = '\0';
    2c78:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2c7c:	20200593          	li	a1,514
    2c80:	854a                	mv	a0,s2
    2c82:	00003097          	auipc	ra,0x3
    2c86:	c28080e7          	jalr	-984(ra) # 58aa <open>
    2c8a:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2c8c:	4605                	li	a2,1
    2c8e:	85ca                	mv	a1,s2
    2c90:	00003097          	auipc	ra,0x3
    2c94:	bfa080e7          	jalr	-1030(ra) # 588a <write>
  close(fd);
    2c98:	854e                	mv	a0,s3
    2c9a:	00003097          	auipc	ra,0x3
    2c9e:	bf8080e7          	jalr	-1032(ra) # 5892 <close>
  fd = open(p, O_RDWR);
    2ca2:	4589                	li	a1,2
    2ca4:	854a                	mv	a0,s2
    2ca6:	00003097          	auipc	ra,0x3
    2caa:	c04080e7          	jalr	-1020(ra) # 58aa <open>
  p[0] = '\0';
    2cae:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2cb2:	4605                	li	a2,1
    2cb4:	85ca                	mv	a1,s2
    2cb6:	00003097          	auipc	ra,0x3
    2cba:	bcc080e7          	jalr	-1076(ra) # 5882 <read>
  if(p[0] != 'x')
    2cbe:	fc04c703          	lbu	a4,-64(s1)
    2cc2:	07800793          	li	a5,120
    2cc6:	02f71363          	bne	a4,a5,2cec <sbrklast+0xc8>
}
    2cca:	70a2                	ld	ra,40(sp)
    2ccc:	7402                	ld	s0,32(sp)
    2cce:	64e2                	ld	s1,24(sp)
    2cd0:	6942                	ld	s2,16(sp)
    2cd2:	69a2                	ld	s3,8(sp)
    2cd4:	6145                	addi	sp,sp,48
    2cd6:	8082                	ret
    sbrk(4096 - (top % 4096));
    2cd8:	0347d513          	srli	a0,a5,0x34
    2cdc:	6785                	lui	a5,0x1
    2cde:	40a7853b          	subw	a0,a5,a0
    2ce2:	00003097          	auipc	ra,0x3
    2ce6:	c10080e7          	jalr	-1008(ra) # 58f2 <sbrk>
    2cea:	bfa1                	j	2c42 <sbrklast+0x1e>
    exit(1);
    2cec:	4505                	li	a0,1
    2cee:	00003097          	auipc	ra,0x3
    2cf2:	b7c080e7          	jalr	-1156(ra) # 586a <exit>

0000000000002cf6 <sbrk8000>:
{
    2cf6:	1141                	addi	sp,sp,-16
    2cf8:	e406                	sd	ra,8(sp)
    2cfa:	e022                	sd	s0,0(sp)
    2cfc:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2cfe:	80000537          	lui	a0,0x80000
    2d02:	0511                	addi	a0,a0,4
    2d04:	00003097          	auipc	ra,0x3
    2d08:	bee080e7          	jalr	-1042(ra) # 58f2 <sbrk>
  volatile char *top = sbrk(0);
    2d0c:	4501                	li	a0,0
    2d0e:	00003097          	auipc	ra,0x3
    2d12:	be4080e7          	jalr	-1052(ra) # 58f2 <sbrk>
  *(top-1) = *(top-1) + 1;
    2d16:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <__BSS_END__+0xffffffff7fff1247>
    2d1a:	0785                	addi	a5,a5,1
    2d1c:	0ff7f793          	andi	a5,a5,255
    2d20:	fef50fa3          	sb	a5,-1(a0)
}
    2d24:	60a2                	ld	ra,8(sp)
    2d26:	6402                	ld	s0,0(sp)
    2d28:	0141                	addi	sp,sp,16
    2d2a:	8082                	ret

0000000000002d2c <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2d2c:	715d                	addi	sp,sp,-80
    2d2e:	e486                	sd	ra,72(sp)
    2d30:	e0a2                	sd	s0,64(sp)
    2d32:	fc26                	sd	s1,56(sp)
    2d34:	f84a                	sd	s2,48(sp)
    2d36:	f44e                	sd	s3,40(sp)
    2d38:	f052                	sd	s4,32(sp)
    2d3a:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2d3c:	4901                	li	s2,0
    2d3e:	49bd                	li	s3,15
    int pid = fork();
    2d40:	00003097          	auipc	ra,0x3
    2d44:	b22080e7          	jalr	-1246(ra) # 5862 <fork>
    2d48:	84aa                	mv	s1,a0
    if(pid < 0){
    2d4a:	02054063          	bltz	a0,2d6a <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2d4e:	c91d                	beqz	a0,2d84 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2d50:	4501                	li	a0,0
    2d52:	00003097          	auipc	ra,0x3
    2d56:	b20080e7          	jalr	-1248(ra) # 5872 <wait>
  for(int avail = 0; avail < 15; avail++){
    2d5a:	2905                	addiw	s2,s2,1
    2d5c:	ff3912e3          	bne	s2,s3,2d40 <execout+0x14>
    }
  }

  exit(0);
    2d60:	4501                	li	a0,0
    2d62:	00003097          	auipc	ra,0x3
    2d66:	b08080e7          	jalr	-1272(ra) # 586a <exit>
      printf("fork failed\n");
    2d6a:	00004517          	auipc	a0,0x4
    2d6e:	00e50513          	addi	a0,a0,14 # 6d78 <malloc+0x10d8>
    2d72:	00003097          	auipc	ra,0x3
    2d76:	e70080e7          	jalr	-400(ra) # 5be2 <printf>
      exit(1);
    2d7a:	4505                	li	a0,1
    2d7c:	00003097          	auipc	ra,0x3
    2d80:	aee080e7          	jalr	-1298(ra) # 586a <exit>
        if(a == 0xffffffffffffffffLL)
    2d84:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2d86:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2d88:	6505                	lui	a0,0x1
    2d8a:	00003097          	auipc	ra,0x3
    2d8e:	b68080e7          	jalr	-1176(ra) # 58f2 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2d92:	01350763          	beq	a0,s3,2da0 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2d96:	6785                	lui	a5,0x1
    2d98:	953e                	add	a0,a0,a5
    2d9a:	ff450fa3          	sb	s4,-1(a0) # fff <bigdir+0x85>
      while(1){
    2d9e:	b7ed                	j	2d88 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2da0:	01205a63          	blez	s2,2db4 <execout+0x88>
        sbrk(-4096);
    2da4:	757d                	lui	a0,0xfffff
    2da6:	00003097          	auipc	ra,0x3
    2daa:	b4c080e7          	jalr	-1204(ra) # 58f2 <sbrk>
      for(int i = 0; i < avail; i++)
    2dae:	2485                	addiw	s1,s1,1
    2db0:	ff249ae3          	bne	s1,s2,2da4 <execout+0x78>
      close(1);
    2db4:	4505                	li	a0,1
    2db6:	00003097          	auipc	ra,0x3
    2dba:	adc080e7          	jalr	-1316(ra) # 5892 <close>
      char *args[] = { "echo", "x", 0 };
    2dbe:	00003517          	auipc	a0,0x3
    2dc2:	36250513          	addi	a0,a0,866 # 6120 <malloc+0x480>
    2dc6:	faa43c23          	sd	a0,-72(s0)
    2dca:	00003797          	auipc	a5,0x3
    2dce:	3c678793          	addi	a5,a5,966 # 6190 <malloc+0x4f0>
    2dd2:	fcf43023          	sd	a5,-64(s0)
    2dd6:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2dda:	fb840593          	addi	a1,s0,-72
    2dde:	00003097          	auipc	ra,0x3
    2de2:	ac4080e7          	jalr	-1340(ra) # 58a2 <exec>
      exit(0);
    2de6:	4501                	li	a0,0
    2de8:	00003097          	auipc	ra,0x3
    2dec:	a82080e7          	jalr	-1406(ra) # 586a <exit>

0000000000002df0 <fourteen>:
{
    2df0:	1101                	addi	sp,sp,-32
    2df2:	ec06                	sd	ra,24(sp)
    2df4:	e822                	sd	s0,16(sp)
    2df6:	e426                	sd	s1,8(sp)
    2df8:	1000                	addi	s0,sp,32
    2dfa:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2dfc:	00004517          	auipc	a0,0x4
    2e00:	46c50513          	addi	a0,a0,1132 # 7268 <malloc+0x15c8>
    2e04:	00003097          	auipc	ra,0x3
    2e08:	ace080e7          	jalr	-1330(ra) # 58d2 <mkdir>
    2e0c:	e165                	bnez	a0,2eec <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2e0e:	00004517          	auipc	a0,0x4
    2e12:	2b250513          	addi	a0,a0,690 # 70c0 <malloc+0x1420>
    2e16:	00003097          	auipc	ra,0x3
    2e1a:	abc080e7          	jalr	-1348(ra) # 58d2 <mkdir>
    2e1e:	e56d                	bnez	a0,2f08 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2e20:	20000593          	li	a1,512
    2e24:	00004517          	auipc	a0,0x4
    2e28:	2f450513          	addi	a0,a0,756 # 7118 <malloc+0x1478>
    2e2c:	00003097          	auipc	ra,0x3
    2e30:	a7e080e7          	jalr	-1410(ra) # 58aa <open>
  if(fd < 0){
    2e34:	0e054863          	bltz	a0,2f24 <fourteen+0x134>
  close(fd);
    2e38:	00003097          	auipc	ra,0x3
    2e3c:	a5a080e7          	jalr	-1446(ra) # 5892 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2e40:	4581                	li	a1,0
    2e42:	00004517          	auipc	a0,0x4
    2e46:	34e50513          	addi	a0,a0,846 # 7190 <malloc+0x14f0>
    2e4a:	00003097          	auipc	ra,0x3
    2e4e:	a60080e7          	jalr	-1440(ra) # 58aa <open>
  if(fd < 0){
    2e52:	0e054763          	bltz	a0,2f40 <fourteen+0x150>
  close(fd);
    2e56:	00003097          	auipc	ra,0x3
    2e5a:	a3c080e7          	jalr	-1476(ra) # 5892 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2e5e:	00004517          	auipc	a0,0x4
    2e62:	3a250513          	addi	a0,a0,930 # 7200 <malloc+0x1560>
    2e66:	00003097          	auipc	ra,0x3
    2e6a:	a6c080e7          	jalr	-1428(ra) # 58d2 <mkdir>
    2e6e:	c57d                	beqz	a0,2f5c <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2e70:	00004517          	auipc	a0,0x4
    2e74:	3e850513          	addi	a0,a0,1000 # 7258 <malloc+0x15b8>
    2e78:	00003097          	auipc	ra,0x3
    2e7c:	a5a080e7          	jalr	-1446(ra) # 58d2 <mkdir>
    2e80:	cd65                	beqz	a0,2f78 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2e82:	00004517          	auipc	a0,0x4
    2e86:	3d650513          	addi	a0,a0,982 # 7258 <malloc+0x15b8>
    2e8a:	00003097          	auipc	ra,0x3
    2e8e:	a30080e7          	jalr	-1488(ra) # 58ba <unlink>
  unlink("12345678901234/12345678901234");
    2e92:	00004517          	auipc	a0,0x4
    2e96:	36e50513          	addi	a0,a0,878 # 7200 <malloc+0x1560>
    2e9a:	00003097          	auipc	ra,0x3
    2e9e:	a20080e7          	jalr	-1504(ra) # 58ba <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2ea2:	00004517          	auipc	a0,0x4
    2ea6:	2ee50513          	addi	a0,a0,750 # 7190 <malloc+0x14f0>
    2eaa:	00003097          	auipc	ra,0x3
    2eae:	a10080e7          	jalr	-1520(ra) # 58ba <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2eb2:	00004517          	auipc	a0,0x4
    2eb6:	26650513          	addi	a0,a0,614 # 7118 <malloc+0x1478>
    2eba:	00003097          	auipc	ra,0x3
    2ebe:	a00080e7          	jalr	-1536(ra) # 58ba <unlink>
  unlink("12345678901234/123456789012345");
    2ec2:	00004517          	auipc	a0,0x4
    2ec6:	1fe50513          	addi	a0,a0,510 # 70c0 <malloc+0x1420>
    2eca:	00003097          	auipc	ra,0x3
    2ece:	9f0080e7          	jalr	-1552(ra) # 58ba <unlink>
  unlink("12345678901234");
    2ed2:	00004517          	auipc	a0,0x4
    2ed6:	39650513          	addi	a0,a0,918 # 7268 <malloc+0x15c8>
    2eda:	00003097          	auipc	ra,0x3
    2ede:	9e0080e7          	jalr	-1568(ra) # 58ba <unlink>
}
    2ee2:	60e2                	ld	ra,24(sp)
    2ee4:	6442                	ld	s0,16(sp)
    2ee6:	64a2                	ld	s1,8(sp)
    2ee8:	6105                	addi	sp,sp,32
    2eea:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2eec:	85a6                	mv	a1,s1
    2eee:	00004517          	auipc	a0,0x4
    2ef2:	1aa50513          	addi	a0,a0,426 # 7098 <malloc+0x13f8>
    2ef6:	00003097          	auipc	ra,0x3
    2efa:	cec080e7          	jalr	-788(ra) # 5be2 <printf>
    exit(1);
    2efe:	4505                	li	a0,1
    2f00:	00003097          	auipc	ra,0x3
    2f04:	96a080e7          	jalr	-1686(ra) # 586a <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2f08:	85a6                	mv	a1,s1
    2f0a:	00004517          	auipc	a0,0x4
    2f0e:	1d650513          	addi	a0,a0,470 # 70e0 <malloc+0x1440>
    2f12:	00003097          	auipc	ra,0x3
    2f16:	cd0080e7          	jalr	-816(ra) # 5be2 <printf>
    exit(1);
    2f1a:	4505                	li	a0,1
    2f1c:	00003097          	auipc	ra,0x3
    2f20:	94e080e7          	jalr	-1714(ra) # 586a <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2f24:	85a6                	mv	a1,s1
    2f26:	00004517          	auipc	a0,0x4
    2f2a:	22250513          	addi	a0,a0,546 # 7148 <malloc+0x14a8>
    2f2e:	00003097          	auipc	ra,0x3
    2f32:	cb4080e7          	jalr	-844(ra) # 5be2 <printf>
    exit(1);
    2f36:	4505                	li	a0,1
    2f38:	00003097          	auipc	ra,0x3
    2f3c:	932080e7          	jalr	-1742(ra) # 586a <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2f40:	85a6                	mv	a1,s1
    2f42:	00004517          	auipc	a0,0x4
    2f46:	27e50513          	addi	a0,a0,638 # 71c0 <malloc+0x1520>
    2f4a:	00003097          	auipc	ra,0x3
    2f4e:	c98080e7          	jalr	-872(ra) # 5be2 <printf>
    exit(1);
    2f52:	4505                	li	a0,1
    2f54:	00003097          	auipc	ra,0x3
    2f58:	916080e7          	jalr	-1770(ra) # 586a <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2f5c:	85a6                	mv	a1,s1
    2f5e:	00004517          	auipc	a0,0x4
    2f62:	2c250513          	addi	a0,a0,706 # 7220 <malloc+0x1580>
    2f66:	00003097          	auipc	ra,0x3
    2f6a:	c7c080e7          	jalr	-900(ra) # 5be2 <printf>
    exit(1);
    2f6e:	4505                	li	a0,1
    2f70:	00003097          	auipc	ra,0x3
    2f74:	8fa080e7          	jalr	-1798(ra) # 586a <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2f78:	85a6                	mv	a1,s1
    2f7a:	00004517          	auipc	a0,0x4
    2f7e:	2fe50513          	addi	a0,a0,766 # 7278 <malloc+0x15d8>
    2f82:	00003097          	auipc	ra,0x3
    2f86:	c60080e7          	jalr	-928(ra) # 5be2 <printf>
    exit(1);
    2f8a:	4505                	li	a0,1
    2f8c:	00003097          	auipc	ra,0x3
    2f90:	8de080e7          	jalr	-1826(ra) # 586a <exit>

0000000000002f94 <iputtest>:
{
    2f94:	1101                	addi	sp,sp,-32
    2f96:	ec06                	sd	ra,24(sp)
    2f98:	e822                	sd	s0,16(sp)
    2f9a:	e426                	sd	s1,8(sp)
    2f9c:	1000                	addi	s0,sp,32
    2f9e:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2fa0:	00004517          	auipc	a0,0x4
    2fa4:	31050513          	addi	a0,a0,784 # 72b0 <malloc+0x1610>
    2fa8:	00003097          	auipc	ra,0x3
    2fac:	92a080e7          	jalr	-1750(ra) # 58d2 <mkdir>
    2fb0:	04054563          	bltz	a0,2ffa <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2fb4:	00004517          	auipc	a0,0x4
    2fb8:	2fc50513          	addi	a0,a0,764 # 72b0 <malloc+0x1610>
    2fbc:	00003097          	auipc	ra,0x3
    2fc0:	91e080e7          	jalr	-1762(ra) # 58da <chdir>
    2fc4:	04054963          	bltz	a0,3016 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2fc8:	00004517          	auipc	a0,0x4
    2fcc:	32850513          	addi	a0,a0,808 # 72f0 <malloc+0x1650>
    2fd0:	00003097          	auipc	ra,0x3
    2fd4:	8ea080e7          	jalr	-1814(ra) # 58ba <unlink>
    2fd8:	04054d63          	bltz	a0,3032 <iputtest+0x9e>
  if(chdir("/") < 0){
    2fdc:	00004517          	auipc	a0,0x4
    2fe0:	34450513          	addi	a0,a0,836 # 7320 <malloc+0x1680>
    2fe4:	00003097          	auipc	ra,0x3
    2fe8:	8f6080e7          	jalr	-1802(ra) # 58da <chdir>
    2fec:	06054163          	bltz	a0,304e <iputtest+0xba>
}
    2ff0:	60e2                	ld	ra,24(sp)
    2ff2:	6442                	ld	s0,16(sp)
    2ff4:	64a2                	ld	s1,8(sp)
    2ff6:	6105                	addi	sp,sp,32
    2ff8:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2ffa:	85a6                	mv	a1,s1
    2ffc:	00004517          	auipc	a0,0x4
    3000:	2bc50513          	addi	a0,a0,700 # 72b8 <malloc+0x1618>
    3004:	00003097          	auipc	ra,0x3
    3008:	bde080e7          	jalr	-1058(ra) # 5be2 <printf>
    exit(1);
    300c:	4505                	li	a0,1
    300e:	00003097          	auipc	ra,0x3
    3012:	85c080e7          	jalr	-1956(ra) # 586a <exit>
    printf("%s: chdir iputdir failed\n", s);
    3016:	85a6                	mv	a1,s1
    3018:	00004517          	auipc	a0,0x4
    301c:	2b850513          	addi	a0,a0,696 # 72d0 <malloc+0x1630>
    3020:	00003097          	auipc	ra,0x3
    3024:	bc2080e7          	jalr	-1086(ra) # 5be2 <printf>
    exit(1);
    3028:	4505                	li	a0,1
    302a:	00003097          	auipc	ra,0x3
    302e:	840080e7          	jalr	-1984(ra) # 586a <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3032:	85a6                	mv	a1,s1
    3034:	00004517          	auipc	a0,0x4
    3038:	2cc50513          	addi	a0,a0,716 # 7300 <malloc+0x1660>
    303c:	00003097          	auipc	ra,0x3
    3040:	ba6080e7          	jalr	-1114(ra) # 5be2 <printf>
    exit(1);
    3044:	4505                	li	a0,1
    3046:	00003097          	auipc	ra,0x3
    304a:	824080e7          	jalr	-2012(ra) # 586a <exit>
    printf("%s: chdir / failed\n", s);
    304e:	85a6                	mv	a1,s1
    3050:	00004517          	auipc	a0,0x4
    3054:	2d850513          	addi	a0,a0,728 # 7328 <malloc+0x1688>
    3058:	00003097          	auipc	ra,0x3
    305c:	b8a080e7          	jalr	-1142(ra) # 5be2 <printf>
    exit(1);
    3060:	4505                	li	a0,1
    3062:	00003097          	auipc	ra,0x3
    3066:	808080e7          	jalr	-2040(ra) # 586a <exit>

000000000000306a <exitiputtest>:
{
    306a:	7179                	addi	sp,sp,-48
    306c:	f406                	sd	ra,40(sp)
    306e:	f022                	sd	s0,32(sp)
    3070:	ec26                	sd	s1,24(sp)
    3072:	1800                	addi	s0,sp,48
    3074:	84aa                	mv	s1,a0
  pid = fork();
    3076:	00002097          	auipc	ra,0x2
    307a:	7ec080e7          	jalr	2028(ra) # 5862 <fork>
  if(pid < 0){
    307e:	04054663          	bltz	a0,30ca <exitiputtest+0x60>
  if(pid == 0){
    3082:	ed45                	bnez	a0,313a <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    3084:	00004517          	auipc	a0,0x4
    3088:	22c50513          	addi	a0,a0,556 # 72b0 <malloc+0x1610>
    308c:	00003097          	auipc	ra,0x3
    3090:	846080e7          	jalr	-1978(ra) # 58d2 <mkdir>
    3094:	04054963          	bltz	a0,30e6 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    3098:	00004517          	auipc	a0,0x4
    309c:	21850513          	addi	a0,a0,536 # 72b0 <malloc+0x1610>
    30a0:	00003097          	auipc	ra,0x3
    30a4:	83a080e7          	jalr	-1990(ra) # 58da <chdir>
    30a8:	04054d63          	bltz	a0,3102 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    30ac:	00004517          	auipc	a0,0x4
    30b0:	24450513          	addi	a0,a0,580 # 72f0 <malloc+0x1650>
    30b4:	00003097          	auipc	ra,0x3
    30b8:	806080e7          	jalr	-2042(ra) # 58ba <unlink>
    30bc:	06054163          	bltz	a0,311e <exitiputtest+0xb4>
    exit(0);
    30c0:	4501                	li	a0,0
    30c2:	00002097          	auipc	ra,0x2
    30c6:	7a8080e7          	jalr	1960(ra) # 586a <exit>
    printf("%s: fork failed\n", s);
    30ca:	85a6                	mv	a1,s1
    30cc:	00004517          	auipc	a0,0x4
    30d0:	88c50513          	addi	a0,a0,-1908 # 6958 <malloc+0xcb8>
    30d4:	00003097          	auipc	ra,0x3
    30d8:	b0e080e7          	jalr	-1266(ra) # 5be2 <printf>
    exit(1);
    30dc:	4505                	li	a0,1
    30de:	00002097          	auipc	ra,0x2
    30e2:	78c080e7          	jalr	1932(ra) # 586a <exit>
      printf("%s: mkdir failed\n", s);
    30e6:	85a6                	mv	a1,s1
    30e8:	00004517          	auipc	a0,0x4
    30ec:	1d050513          	addi	a0,a0,464 # 72b8 <malloc+0x1618>
    30f0:	00003097          	auipc	ra,0x3
    30f4:	af2080e7          	jalr	-1294(ra) # 5be2 <printf>
      exit(1);
    30f8:	4505                	li	a0,1
    30fa:	00002097          	auipc	ra,0x2
    30fe:	770080e7          	jalr	1904(ra) # 586a <exit>
      printf("%s: child chdir failed\n", s);
    3102:	85a6                	mv	a1,s1
    3104:	00004517          	auipc	a0,0x4
    3108:	23c50513          	addi	a0,a0,572 # 7340 <malloc+0x16a0>
    310c:	00003097          	auipc	ra,0x3
    3110:	ad6080e7          	jalr	-1322(ra) # 5be2 <printf>
      exit(1);
    3114:	4505                	li	a0,1
    3116:	00002097          	auipc	ra,0x2
    311a:	754080e7          	jalr	1876(ra) # 586a <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    311e:	85a6                	mv	a1,s1
    3120:	00004517          	auipc	a0,0x4
    3124:	1e050513          	addi	a0,a0,480 # 7300 <malloc+0x1660>
    3128:	00003097          	auipc	ra,0x3
    312c:	aba080e7          	jalr	-1350(ra) # 5be2 <printf>
      exit(1);
    3130:	4505                	li	a0,1
    3132:	00002097          	auipc	ra,0x2
    3136:	738080e7          	jalr	1848(ra) # 586a <exit>
  wait(&xstatus);
    313a:	fdc40513          	addi	a0,s0,-36
    313e:	00002097          	auipc	ra,0x2
    3142:	734080e7          	jalr	1844(ra) # 5872 <wait>
  exit(xstatus);
    3146:	fdc42503          	lw	a0,-36(s0)
    314a:	00002097          	auipc	ra,0x2
    314e:	720080e7          	jalr	1824(ra) # 586a <exit>

0000000000003152 <dirtest>:
{
    3152:	1101                	addi	sp,sp,-32
    3154:	ec06                	sd	ra,24(sp)
    3156:	e822                	sd	s0,16(sp)
    3158:	e426                	sd	s1,8(sp)
    315a:	1000                	addi	s0,sp,32
    315c:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    315e:	00004517          	auipc	a0,0x4
    3162:	1fa50513          	addi	a0,a0,506 # 7358 <malloc+0x16b8>
    3166:	00002097          	auipc	ra,0x2
    316a:	76c080e7          	jalr	1900(ra) # 58d2 <mkdir>
    316e:	04054563          	bltz	a0,31b8 <dirtest+0x66>
  if(chdir("dir0") < 0){
    3172:	00004517          	auipc	a0,0x4
    3176:	1e650513          	addi	a0,a0,486 # 7358 <malloc+0x16b8>
    317a:	00002097          	auipc	ra,0x2
    317e:	760080e7          	jalr	1888(ra) # 58da <chdir>
    3182:	04054963          	bltz	a0,31d4 <dirtest+0x82>
  if(chdir("..") < 0){
    3186:	00004517          	auipc	a0,0x4
    318a:	1f250513          	addi	a0,a0,498 # 7378 <malloc+0x16d8>
    318e:	00002097          	auipc	ra,0x2
    3192:	74c080e7          	jalr	1868(ra) # 58da <chdir>
    3196:	04054d63          	bltz	a0,31f0 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    319a:	00004517          	auipc	a0,0x4
    319e:	1be50513          	addi	a0,a0,446 # 7358 <malloc+0x16b8>
    31a2:	00002097          	auipc	ra,0x2
    31a6:	718080e7          	jalr	1816(ra) # 58ba <unlink>
    31aa:	06054163          	bltz	a0,320c <dirtest+0xba>
}
    31ae:	60e2                	ld	ra,24(sp)
    31b0:	6442                	ld	s0,16(sp)
    31b2:	64a2                	ld	s1,8(sp)
    31b4:	6105                	addi	sp,sp,32
    31b6:	8082                	ret
    printf("%s: mkdir failed\n", s);
    31b8:	85a6                	mv	a1,s1
    31ba:	00004517          	auipc	a0,0x4
    31be:	0fe50513          	addi	a0,a0,254 # 72b8 <malloc+0x1618>
    31c2:	00003097          	auipc	ra,0x3
    31c6:	a20080e7          	jalr	-1504(ra) # 5be2 <printf>
    exit(1);
    31ca:	4505                	li	a0,1
    31cc:	00002097          	auipc	ra,0x2
    31d0:	69e080e7          	jalr	1694(ra) # 586a <exit>
    printf("%s: chdir dir0 failed\n", s);
    31d4:	85a6                	mv	a1,s1
    31d6:	00004517          	auipc	a0,0x4
    31da:	18a50513          	addi	a0,a0,394 # 7360 <malloc+0x16c0>
    31de:	00003097          	auipc	ra,0x3
    31e2:	a04080e7          	jalr	-1532(ra) # 5be2 <printf>
    exit(1);
    31e6:	4505                	li	a0,1
    31e8:	00002097          	auipc	ra,0x2
    31ec:	682080e7          	jalr	1666(ra) # 586a <exit>
    printf("%s: chdir .. failed\n", s);
    31f0:	85a6                	mv	a1,s1
    31f2:	00004517          	auipc	a0,0x4
    31f6:	18e50513          	addi	a0,a0,398 # 7380 <malloc+0x16e0>
    31fa:	00003097          	auipc	ra,0x3
    31fe:	9e8080e7          	jalr	-1560(ra) # 5be2 <printf>
    exit(1);
    3202:	4505                	li	a0,1
    3204:	00002097          	auipc	ra,0x2
    3208:	666080e7          	jalr	1638(ra) # 586a <exit>
    printf("%s: unlink dir0 failed\n", s);
    320c:	85a6                	mv	a1,s1
    320e:	00004517          	auipc	a0,0x4
    3212:	18a50513          	addi	a0,a0,394 # 7398 <malloc+0x16f8>
    3216:	00003097          	auipc	ra,0x3
    321a:	9cc080e7          	jalr	-1588(ra) # 5be2 <printf>
    exit(1);
    321e:	4505                	li	a0,1
    3220:	00002097          	auipc	ra,0x2
    3224:	64a080e7          	jalr	1610(ra) # 586a <exit>

0000000000003228 <subdir>:
{
    3228:	1101                	addi	sp,sp,-32
    322a:	ec06                	sd	ra,24(sp)
    322c:	e822                	sd	s0,16(sp)
    322e:	e426                	sd	s1,8(sp)
    3230:	e04a                	sd	s2,0(sp)
    3232:	1000                	addi	s0,sp,32
    3234:	892a                	mv	s2,a0
  unlink("ff");
    3236:	00004517          	auipc	a0,0x4
    323a:	2aa50513          	addi	a0,a0,682 # 74e0 <malloc+0x1840>
    323e:	00002097          	auipc	ra,0x2
    3242:	67c080e7          	jalr	1660(ra) # 58ba <unlink>
  if(mkdir("dd") != 0){
    3246:	00004517          	auipc	a0,0x4
    324a:	16a50513          	addi	a0,a0,362 # 73b0 <malloc+0x1710>
    324e:	00002097          	auipc	ra,0x2
    3252:	684080e7          	jalr	1668(ra) # 58d2 <mkdir>
    3256:	38051663          	bnez	a0,35e2 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    325a:	20200593          	li	a1,514
    325e:	00004517          	auipc	a0,0x4
    3262:	17250513          	addi	a0,a0,370 # 73d0 <malloc+0x1730>
    3266:	00002097          	auipc	ra,0x2
    326a:	644080e7          	jalr	1604(ra) # 58aa <open>
    326e:	84aa                	mv	s1,a0
  if(fd < 0){
    3270:	38054763          	bltz	a0,35fe <subdir+0x3d6>
  write(fd, "ff", 2);
    3274:	4609                	li	a2,2
    3276:	00004597          	auipc	a1,0x4
    327a:	26a58593          	addi	a1,a1,618 # 74e0 <malloc+0x1840>
    327e:	00002097          	auipc	ra,0x2
    3282:	60c080e7          	jalr	1548(ra) # 588a <write>
  close(fd);
    3286:	8526                	mv	a0,s1
    3288:	00002097          	auipc	ra,0x2
    328c:	60a080e7          	jalr	1546(ra) # 5892 <close>
  if(unlink("dd") >= 0){
    3290:	00004517          	auipc	a0,0x4
    3294:	12050513          	addi	a0,a0,288 # 73b0 <malloc+0x1710>
    3298:	00002097          	auipc	ra,0x2
    329c:	622080e7          	jalr	1570(ra) # 58ba <unlink>
    32a0:	36055d63          	bgez	a0,361a <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    32a4:	00004517          	auipc	a0,0x4
    32a8:	18450513          	addi	a0,a0,388 # 7428 <malloc+0x1788>
    32ac:	00002097          	auipc	ra,0x2
    32b0:	626080e7          	jalr	1574(ra) # 58d2 <mkdir>
    32b4:	38051163          	bnez	a0,3636 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    32b8:	20200593          	li	a1,514
    32bc:	00004517          	auipc	a0,0x4
    32c0:	19450513          	addi	a0,a0,404 # 7450 <malloc+0x17b0>
    32c4:	00002097          	auipc	ra,0x2
    32c8:	5e6080e7          	jalr	1510(ra) # 58aa <open>
    32cc:	84aa                	mv	s1,a0
  if(fd < 0){
    32ce:	38054263          	bltz	a0,3652 <subdir+0x42a>
  write(fd, "FF", 2);
    32d2:	4609                	li	a2,2
    32d4:	00004597          	auipc	a1,0x4
    32d8:	1ac58593          	addi	a1,a1,428 # 7480 <malloc+0x17e0>
    32dc:	00002097          	auipc	ra,0x2
    32e0:	5ae080e7          	jalr	1454(ra) # 588a <write>
  close(fd);
    32e4:	8526                	mv	a0,s1
    32e6:	00002097          	auipc	ra,0x2
    32ea:	5ac080e7          	jalr	1452(ra) # 5892 <close>
  fd = open("dd/dd/../ff", 0);
    32ee:	4581                	li	a1,0
    32f0:	00004517          	auipc	a0,0x4
    32f4:	19850513          	addi	a0,a0,408 # 7488 <malloc+0x17e8>
    32f8:	00002097          	auipc	ra,0x2
    32fc:	5b2080e7          	jalr	1458(ra) # 58aa <open>
    3300:	84aa                	mv	s1,a0
  if(fd < 0){
    3302:	36054663          	bltz	a0,366e <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3306:	660d                	lui	a2,0x3
    3308:	00009597          	auipc	a1,0x9
    330c:	aa058593          	addi	a1,a1,-1376 # bda8 <buf>
    3310:	00002097          	auipc	ra,0x2
    3314:	572080e7          	jalr	1394(ra) # 5882 <read>
  if(cc != 2 || buf[0] != 'f'){
    3318:	4789                	li	a5,2
    331a:	36f51863          	bne	a0,a5,368a <subdir+0x462>
    331e:	00009717          	auipc	a4,0x9
    3322:	a8a74703          	lbu	a4,-1398(a4) # bda8 <buf>
    3326:	06600793          	li	a5,102
    332a:	36f71063          	bne	a4,a5,368a <subdir+0x462>
  close(fd);
    332e:	8526                	mv	a0,s1
    3330:	00002097          	auipc	ra,0x2
    3334:	562080e7          	jalr	1378(ra) # 5892 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3338:	00004597          	auipc	a1,0x4
    333c:	1a058593          	addi	a1,a1,416 # 74d8 <malloc+0x1838>
    3340:	00004517          	auipc	a0,0x4
    3344:	11050513          	addi	a0,a0,272 # 7450 <malloc+0x17b0>
    3348:	00002097          	auipc	ra,0x2
    334c:	582080e7          	jalr	1410(ra) # 58ca <link>
    3350:	34051b63          	bnez	a0,36a6 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3354:	00004517          	auipc	a0,0x4
    3358:	0fc50513          	addi	a0,a0,252 # 7450 <malloc+0x17b0>
    335c:	00002097          	auipc	ra,0x2
    3360:	55e080e7          	jalr	1374(ra) # 58ba <unlink>
    3364:	34051f63          	bnez	a0,36c2 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3368:	4581                	li	a1,0
    336a:	00004517          	auipc	a0,0x4
    336e:	0e650513          	addi	a0,a0,230 # 7450 <malloc+0x17b0>
    3372:	00002097          	auipc	ra,0x2
    3376:	538080e7          	jalr	1336(ra) # 58aa <open>
    337a:	36055263          	bgez	a0,36de <subdir+0x4b6>
  if(chdir("dd") != 0){
    337e:	00004517          	auipc	a0,0x4
    3382:	03250513          	addi	a0,a0,50 # 73b0 <malloc+0x1710>
    3386:	00002097          	auipc	ra,0x2
    338a:	554080e7          	jalr	1364(ra) # 58da <chdir>
    338e:	36051663          	bnez	a0,36fa <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3392:	00004517          	auipc	a0,0x4
    3396:	1de50513          	addi	a0,a0,478 # 7570 <malloc+0x18d0>
    339a:	00002097          	auipc	ra,0x2
    339e:	540080e7          	jalr	1344(ra) # 58da <chdir>
    33a2:	36051a63          	bnez	a0,3716 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    33a6:	00004517          	auipc	a0,0x4
    33aa:	1fa50513          	addi	a0,a0,506 # 75a0 <malloc+0x1900>
    33ae:	00002097          	auipc	ra,0x2
    33b2:	52c080e7          	jalr	1324(ra) # 58da <chdir>
    33b6:	36051e63          	bnez	a0,3732 <subdir+0x50a>
  if(chdir("./..") != 0){
    33ba:	00004517          	auipc	a0,0x4
    33be:	21650513          	addi	a0,a0,534 # 75d0 <malloc+0x1930>
    33c2:	00002097          	auipc	ra,0x2
    33c6:	518080e7          	jalr	1304(ra) # 58da <chdir>
    33ca:	38051263          	bnez	a0,374e <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    33ce:	4581                	li	a1,0
    33d0:	00004517          	auipc	a0,0x4
    33d4:	10850513          	addi	a0,a0,264 # 74d8 <malloc+0x1838>
    33d8:	00002097          	auipc	ra,0x2
    33dc:	4d2080e7          	jalr	1234(ra) # 58aa <open>
    33e0:	84aa                	mv	s1,a0
  if(fd < 0){
    33e2:	38054463          	bltz	a0,376a <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    33e6:	660d                	lui	a2,0x3
    33e8:	00009597          	auipc	a1,0x9
    33ec:	9c058593          	addi	a1,a1,-1600 # bda8 <buf>
    33f0:	00002097          	auipc	ra,0x2
    33f4:	492080e7          	jalr	1170(ra) # 5882 <read>
    33f8:	4789                	li	a5,2
    33fa:	38f51663          	bne	a0,a5,3786 <subdir+0x55e>
  close(fd);
    33fe:	8526                	mv	a0,s1
    3400:	00002097          	auipc	ra,0x2
    3404:	492080e7          	jalr	1170(ra) # 5892 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3408:	4581                	li	a1,0
    340a:	00004517          	auipc	a0,0x4
    340e:	04650513          	addi	a0,a0,70 # 7450 <malloc+0x17b0>
    3412:	00002097          	auipc	ra,0x2
    3416:	498080e7          	jalr	1176(ra) # 58aa <open>
    341a:	38055463          	bgez	a0,37a2 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    341e:	20200593          	li	a1,514
    3422:	00004517          	auipc	a0,0x4
    3426:	23e50513          	addi	a0,a0,574 # 7660 <malloc+0x19c0>
    342a:	00002097          	auipc	ra,0x2
    342e:	480080e7          	jalr	1152(ra) # 58aa <open>
    3432:	38055663          	bgez	a0,37be <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3436:	20200593          	li	a1,514
    343a:	00004517          	auipc	a0,0x4
    343e:	25650513          	addi	a0,a0,598 # 7690 <malloc+0x19f0>
    3442:	00002097          	auipc	ra,0x2
    3446:	468080e7          	jalr	1128(ra) # 58aa <open>
    344a:	38055863          	bgez	a0,37da <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    344e:	20000593          	li	a1,512
    3452:	00004517          	auipc	a0,0x4
    3456:	f5e50513          	addi	a0,a0,-162 # 73b0 <malloc+0x1710>
    345a:	00002097          	auipc	ra,0x2
    345e:	450080e7          	jalr	1104(ra) # 58aa <open>
    3462:	38055a63          	bgez	a0,37f6 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3466:	4589                	li	a1,2
    3468:	00004517          	auipc	a0,0x4
    346c:	f4850513          	addi	a0,a0,-184 # 73b0 <malloc+0x1710>
    3470:	00002097          	auipc	ra,0x2
    3474:	43a080e7          	jalr	1082(ra) # 58aa <open>
    3478:	38055d63          	bgez	a0,3812 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    347c:	4585                	li	a1,1
    347e:	00004517          	auipc	a0,0x4
    3482:	f3250513          	addi	a0,a0,-206 # 73b0 <malloc+0x1710>
    3486:	00002097          	auipc	ra,0x2
    348a:	424080e7          	jalr	1060(ra) # 58aa <open>
    348e:	3a055063          	bgez	a0,382e <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3492:	00004597          	auipc	a1,0x4
    3496:	28e58593          	addi	a1,a1,654 # 7720 <malloc+0x1a80>
    349a:	00004517          	auipc	a0,0x4
    349e:	1c650513          	addi	a0,a0,454 # 7660 <malloc+0x19c0>
    34a2:	00002097          	auipc	ra,0x2
    34a6:	428080e7          	jalr	1064(ra) # 58ca <link>
    34aa:	3a050063          	beqz	a0,384a <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    34ae:	00004597          	auipc	a1,0x4
    34b2:	27258593          	addi	a1,a1,626 # 7720 <malloc+0x1a80>
    34b6:	00004517          	auipc	a0,0x4
    34ba:	1da50513          	addi	a0,a0,474 # 7690 <malloc+0x19f0>
    34be:	00002097          	auipc	ra,0x2
    34c2:	40c080e7          	jalr	1036(ra) # 58ca <link>
    34c6:	3a050063          	beqz	a0,3866 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    34ca:	00004597          	auipc	a1,0x4
    34ce:	00e58593          	addi	a1,a1,14 # 74d8 <malloc+0x1838>
    34d2:	00004517          	auipc	a0,0x4
    34d6:	efe50513          	addi	a0,a0,-258 # 73d0 <malloc+0x1730>
    34da:	00002097          	auipc	ra,0x2
    34de:	3f0080e7          	jalr	1008(ra) # 58ca <link>
    34e2:	3a050063          	beqz	a0,3882 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    34e6:	00004517          	auipc	a0,0x4
    34ea:	17a50513          	addi	a0,a0,378 # 7660 <malloc+0x19c0>
    34ee:	00002097          	auipc	ra,0x2
    34f2:	3e4080e7          	jalr	996(ra) # 58d2 <mkdir>
    34f6:	3a050463          	beqz	a0,389e <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    34fa:	00004517          	auipc	a0,0x4
    34fe:	19650513          	addi	a0,a0,406 # 7690 <malloc+0x19f0>
    3502:	00002097          	auipc	ra,0x2
    3506:	3d0080e7          	jalr	976(ra) # 58d2 <mkdir>
    350a:	3a050863          	beqz	a0,38ba <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    350e:	00004517          	auipc	a0,0x4
    3512:	fca50513          	addi	a0,a0,-54 # 74d8 <malloc+0x1838>
    3516:	00002097          	auipc	ra,0x2
    351a:	3bc080e7          	jalr	956(ra) # 58d2 <mkdir>
    351e:	3a050c63          	beqz	a0,38d6 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3522:	00004517          	auipc	a0,0x4
    3526:	16e50513          	addi	a0,a0,366 # 7690 <malloc+0x19f0>
    352a:	00002097          	auipc	ra,0x2
    352e:	390080e7          	jalr	912(ra) # 58ba <unlink>
    3532:	3c050063          	beqz	a0,38f2 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3536:	00004517          	auipc	a0,0x4
    353a:	12a50513          	addi	a0,a0,298 # 7660 <malloc+0x19c0>
    353e:	00002097          	auipc	ra,0x2
    3542:	37c080e7          	jalr	892(ra) # 58ba <unlink>
    3546:	3c050463          	beqz	a0,390e <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    354a:	00004517          	auipc	a0,0x4
    354e:	e8650513          	addi	a0,a0,-378 # 73d0 <malloc+0x1730>
    3552:	00002097          	auipc	ra,0x2
    3556:	388080e7          	jalr	904(ra) # 58da <chdir>
    355a:	3c050863          	beqz	a0,392a <subdir+0x702>
  if(chdir("dd/xx") == 0){
    355e:	00004517          	auipc	a0,0x4
    3562:	31250513          	addi	a0,a0,786 # 7870 <malloc+0x1bd0>
    3566:	00002097          	auipc	ra,0x2
    356a:	374080e7          	jalr	884(ra) # 58da <chdir>
    356e:	3c050c63          	beqz	a0,3946 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3572:	00004517          	auipc	a0,0x4
    3576:	f6650513          	addi	a0,a0,-154 # 74d8 <malloc+0x1838>
    357a:	00002097          	auipc	ra,0x2
    357e:	340080e7          	jalr	832(ra) # 58ba <unlink>
    3582:	3e051063          	bnez	a0,3962 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3586:	00004517          	auipc	a0,0x4
    358a:	e4a50513          	addi	a0,a0,-438 # 73d0 <malloc+0x1730>
    358e:	00002097          	auipc	ra,0x2
    3592:	32c080e7          	jalr	812(ra) # 58ba <unlink>
    3596:	3e051463          	bnez	a0,397e <subdir+0x756>
  if(unlink("dd") == 0){
    359a:	00004517          	auipc	a0,0x4
    359e:	e1650513          	addi	a0,a0,-490 # 73b0 <malloc+0x1710>
    35a2:	00002097          	auipc	ra,0x2
    35a6:	318080e7          	jalr	792(ra) # 58ba <unlink>
    35aa:	3e050863          	beqz	a0,399a <subdir+0x772>
  if(unlink("dd/dd") < 0){
    35ae:	00004517          	auipc	a0,0x4
    35b2:	33250513          	addi	a0,a0,818 # 78e0 <malloc+0x1c40>
    35b6:	00002097          	auipc	ra,0x2
    35ba:	304080e7          	jalr	772(ra) # 58ba <unlink>
    35be:	3e054c63          	bltz	a0,39b6 <subdir+0x78e>
  if(unlink("dd") < 0){
    35c2:	00004517          	auipc	a0,0x4
    35c6:	dee50513          	addi	a0,a0,-530 # 73b0 <malloc+0x1710>
    35ca:	00002097          	auipc	ra,0x2
    35ce:	2f0080e7          	jalr	752(ra) # 58ba <unlink>
    35d2:	40054063          	bltz	a0,39d2 <subdir+0x7aa>
}
    35d6:	60e2                	ld	ra,24(sp)
    35d8:	6442                	ld	s0,16(sp)
    35da:	64a2                	ld	s1,8(sp)
    35dc:	6902                	ld	s2,0(sp)
    35de:	6105                	addi	sp,sp,32
    35e0:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    35e2:	85ca                	mv	a1,s2
    35e4:	00004517          	auipc	a0,0x4
    35e8:	dd450513          	addi	a0,a0,-556 # 73b8 <malloc+0x1718>
    35ec:	00002097          	auipc	ra,0x2
    35f0:	5f6080e7          	jalr	1526(ra) # 5be2 <printf>
    exit(1);
    35f4:	4505                	li	a0,1
    35f6:	00002097          	auipc	ra,0x2
    35fa:	274080e7          	jalr	628(ra) # 586a <exit>
    printf("%s: create dd/ff failed\n", s);
    35fe:	85ca                	mv	a1,s2
    3600:	00004517          	auipc	a0,0x4
    3604:	dd850513          	addi	a0,a0,-552 # 73d8 <malloc+0x1738>
    3608:	00002097          	auipc	ra,0x2
    360c:	5da080e7          	jalr	1498(ra) # 5be2 <printf>
    exit(1);
    3610:	4505                	li	a0,1
    3612:	00002097          	auipc	ra,0x2
    3616:	258080e7          	jalr	600(ra) # 586a <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    361a:	85ca                	mv	a1,s2
    361c:	00004517          	auipc	a0,0x4
    3620:	ddc50513          	addi	a0,a0,-548 # 73f8 <malloc+0x1758>
    3624:	00002097          	auipc	ra,0x2
    3628:	5be080e7          	jalr	1470(ra) # 5be2 <printf>
    exit(1);
    362c:	4505                	li	a0,1
    362e:	00002097          	auipc	ra,0x2
    3632:	23c080e7          	jalr	572(ra) # 586a <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3636:	85ca                	mv	a1,s2
    3638:	00004517          	auipc	a0,0x4
    363c:	df850513          	addi	a0,a0,-520 # 7430 <malloc+0x1790>
    3640:	00002097          	auipc	ra,0x2
    3644:	5a2080e7          	jalr	1442(ra) # 5be2 <printf>
    exit(1);
    3648:	4505                	li	a0,1
    364a:	00002097          	auipc	ra,0x2
    364e:	220080e7          	jalr	544(ra) # 586a <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3652:	85ca                	mv	a1,s2
    3654:	00004517          	auipc	a0,0x4
    3658:	e0c50513          	addi	a0,a0,-500 # 7460 <malloc+0x17c0>
    365c:	00002097          	auipc	ra,0x2
    3660:	586080e7          	jalr	1414(ra) # 5be2 <printf>
    exit(1);
    3664:	4505                	li	a0,1
    3666:	00002097          	auipc	ra,0x2
    366a:	204080e7          	jalr	516(ra) # 586a <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    366e:	85ca                	mv	a1,s2
    3670:	00004517          	auipc	a0,0x4
    3674:	e2850513          	addi	a0,a0,-472 # 7498 <malloc+0x17f8>
    3678:	00002097          	auipc	ra,0x2
    367c:	56a080e7          	jalr	1386(ra) # 5be2 <printf>
    exit(1);
    3680:	4505                	li	a0,1
    3682:	00002097          	auipc	ra,0x2
    3686:	1e8080e7          	jalr	488(ra) # 586a <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    368a:	85ca                	mv	a1,s2
    368c:	00004517          	auipc	a0,0x4
    3690:	e2c50513          	addi	a0,a0,-468 # 74b8 <malloc+0x1818>
    3694:	00002097          	auipc	ra,0x2
    3698:	54e080e7          	jalr	1358(ra) # 5be2 <printf>
    exit(1);
    369c:	4505                	li	a0,1
    369e:	00002097          	auipc	ra,0x2
    36a2:	1cc080e7          	jalr	460(ra) # 586a <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    36a6:	85ca                	mv	a1,s2
    36a8:	00004517          	auipc	a0,0x4
    36ac:	e4050513          	addi	a0,a0,-448 # 74e8 <malloc+0x1848>
    36b0:	00002097          	auipc	ra,0x2
    36b4:	532080e7          	jalr	1330(ra) # 5be2 <printf>
    exit(1);
    36b8:	4505                	li	a0,1
    36ba:	00002097          	auipc	ra,0x2
    36be:	1b0080e7          	jalr	432(ra) # 586a <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    36c2:	85ca                	mv	a1,s2
    36c4:	00004517          	auipc	a0,0x4
    36c8:	e4c50513          	addi	a0,a0,-436 # 7510 <malloc+0x1870>
    36cc:	00002097          	auipc	ra,0x2
    36d0:	516080e7          	jalr	1302(ra) # 5be2 <printf>
    exit(1);
    36d4:	4505                	li	a0,1
    36d6:	00002097          	auipc	ra,0x2
    36da:	194080e7          	jalr	404(ra) # 586a <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    36de:	85ca                	mv	a1,s2
    36e0:	00004517          	auipc	a0,0x4
    36e4:	e5050513          	addi	a0,a0,-432 # 7530 <malloc+0x1890>
    36e8:	00002097          	auipc	ra,0x2
    36ec:	4fa080e7          	jalr	1274(ra) # 5be2 <printf>
    exit(1);
    36f0:	4505                	li	a0,1
    36f2:	00002097          	auipc	ra,0x2
    36f6:	178080e7          	jalr	376(ra) # 586a <exit>
    printf("%s: chdir dd failed\n", s);
    36fa:	85ca                	mv	a1,s2
    36fc:	00004517          	auipc	a0,0x4
    3700:	e5c50513          	addi	a0,a0,-420 # 7558 <malloc+0x18b8>
    3704:	00002097          	auipc	ra,0x2
    3708:	4de080e7          	jalr	1246(ra) # 5be2 <printf>
    exit(1);
    370c:	4505                	li	a0,1
    370e:	00002097          	auipc	ra,0x2
    3712:	15c080e7          	jalr	348(ra) # 586a <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3716:	85ca                	mv	a1,s2
    3718:	00004517          	auipc	a0,0x4
    371c:	e6850513          	addi	a0,a0,-408 # 7580 <malloc+0x18e0>
    3720:	00002097          	auipc	ra,0x2
    3724:	4c2080e7          	jalr	1218(ra) # 5be2 <printf>
    exit(1);
    3728:	4505                	li	a0,1
    372a:	00002097          	auipc	ra,0x2
    372e:	140080e7          	jalr	320(ra) # 586a <exit>
    printf("chdir dd/../../dd failed\n", s);
    3732:	85ca                	mv	a1,s2
    3734:	00004517          	auipc	a0,0x4
    3738:	e7c50513          	addi	a0,a0,-388 # 75b0 <malloc+0x1910>
    373c:	00002097          	auipc	ra,0x2
    3740:	4a6080e7          	jalr	1190(ra) # 5be2 <printf>
    exit(1);
    3744:	4505                	li	a0,1
    3746:	00002097          	auipc	ra,0x2
    374a:	124080e7          	jalr	292(ra) # 586a <exit>
    printf("%s: chdir ./.. failed\n", s);
    374e:	85ca                	mv	a1,s2
    3750:	00004517          	auipc	a0,0x4
    3754:	e8850513          	addi	a0,a0,-376 # 75d8 <malloc+0x1938>
    3758:	00002097          	auipc	ra,0x2
    375c:	48a080e7          	jalr	1162(ra) # 5be2 <printf>
    exit(1);
    3760:	4505                	li	a0,1
    3762:	00002097          	auipc	ra,0x2
    3766:	108080e7          	jalr	264(ra) # 586a <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    376a:	85ca                	mv	a1,s2
    376c:	00004517          	auipc	a0,0x4
    3770:	e8450513          	addi	a0,a0,-380 # 75f0 <malloc+0x1950>
    3774:	00002097          	auipc	ra,0x2
    3778:	46e080e7          	jalr	1134(ra) # 5be2 <printf>
    exit(1);
    377c:	4505                	li	a0,1
    377e:	00002097          	auipc	ra,0x2
    3782:	0ec080e7          	jalr	236(ra) # 586a <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3786:	85ca                	mv	a1,s2
    3788:	00004517          	auipc	a0,0x4
    378c:	e8850513          	addi	a0,a0,-376 # 7610 <malloc+0x1970>
    3790:	00002097          	auipc	ra,0x2
    3794:	452080e7          	jalr	1106(ra) # 5be2 <printf>
    exit(1);
    3798:	4505                	li	a0,1
    379a:	00002097          	auipc	ra,0x2
    379e:	0d0080e7          	jalr	208(ra) # 586a <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    37a2:	85ca                	mv	a1,s2
    37a4:	00004517          	auipc	a0,0x4
    37a8:	e8c50513          	addi	a0,a0,-372 # 7630 <malloc+0x1990>
    37ac:	00002097          	auipc	ra,0x2
    37b0:	436080e7          	jalr	1078(ra) # 5be2 <printf>
    exit(1);
    37b4:	4505                	li	a0,1
    37b6:	00002097          	auipc	ra,0x2
    37ba:	0b4080e7          	jalr	180(ra) # 586a <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    37be:	85ca                	mv	a1,s2
    37c0:	00004517          	auipc	a0,0x4
    37c4:	eb050513          	addi	a0,a0,-336 # 7670 <malloc+0x19d0>
    37c8:	00002097          	auipc	ra,0x2
    37cc:	41a080e7          	jalr	1050(ra) # 5be2 <printf>
    exit(1);
    37d0:	4505                	li	a0,1
    37d2:	00002097          	auipc	ra,0x2
    37d6:	098080e7          	jalr	152(ra) # 586a <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    37da:	85ca                	mv	a1,s2
    37dc:	00004517          	auipc	a0,0x4
    37e0:	ec450513          	addi	a0,a0,-316 # 76a0 <malloc+0x1a00>
    37e4:	00002097          	auipc	ra,0x2
    37e8:	3fe080e7          	jalr	1022(ra) # 5be2 <printf>
    exit(1);
    37ec:	4505                	li	a0,1
    37ee:	00002097          	auipc	ra,0x2
    37f2:	07c080e7          	jalr	124(ra) # 586a <exit>
    printf("%s: create dd succeeded!\n", s);
    37f6:	85ca                	mv	a1,s2
    37f8:	00004517          	auipc	a0,0x4
    37fc:	ec850513          	addi	a0,a0,-312 # 76c0 <malloc+0x1a20>
    3800:	00002097          	auipc	ra,0x2
    3804:	3e2080e7          	jalr	994(ra) # 5be2 <printf>
    exit(1);
    3808:	4505                	li	a0,1
    380a:	00002097          	auipc	ra,0x2
    380e:	060080e7          	jalr	96(ra) # 586a <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3812:	85ca                	mv	a1,s2
    3814:	00004517          	auipc	a0,0x4
    3818:	ecc50513          	addi	a0,a0,-308 # 76e0 <malloc+0x1a40>
    381c:	00002097          	auipc	ra,0x2
    3820:	3c6080e7          	jalr	966(ra) # 5be2 <printf>
    exit(1);
    3824:	4505                	li	a0,1
    3826:	00002097          	auipc	ra,0x2
    382a:	044080e7          	jalr	68(ra) # 586a <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    382e:	85ca                	mv	a1,s2
    3830:	00004517          	auipc	a0,0x4
    3834:	ed050513          	addi	a0,a0,-304 # 7700 <malloc+0x1a60>
    3838:	00002097          	auipc	ra,0x2
    383c:	3aa080e7          	jalr	938(ra) # 5be2 <printf>
    exit(1);
    3840:	4505                	li	a0,1
    3842:	00002097          	auipc	ra,0x2
    3846:	028080e7          	jalr	40(ra) # 586a <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    384a:	85ca                	mv	a1,s2
    384c:	00004517          	auipc	a0,0x4
    3850:	ee450513          	addi	a0,a0,-284 # 7730 <malloc+0x1a90>
    3854:	00002097          	auipc	ra,0x2
    3858:	38e080e7          	jalr	910(ra) # 5be2 <printf>
    exit(1);
    385c:	4505                	li	a0,1
    385e:	00002097          	auipc	ra,0x2
    3862:	00c080e7          	jalr	12(ra) # 586a <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3866:	85ca                	mv	a1,s2
    3868:	00004517          	auipc	a0,0x4
    386c:	ef050513          	addi	a0,a0,-272 # 7758 <malloc+0x1ab8>
    3870:	00002097          	auipc	ra,0x2
    3874:	372080e7          	jalr	882(ra) # 5be2 <printf>
    exit(1);
    3878:	4505                	li	a0,1
    387a:	00002097          	auipc	ra,0x2
    387e:	ff0080e7          	jalr	-16(ra) # 586a <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3882:	85ca                	mv	a1,s2
    3884:	00004517          	auipc	a0,0x4
    3888:	efc50513          	addi	a0,a0,-260 # 7780 <malloc+0x1ae0>
    388c:	00002097          	auipc	ra,0x2
    3890:	356080e7          	jalr	854(ra) # 5be2 <printf>
    exit(1);
    3894:	4505                	li	a0,1
    3896:	00002097          	auipc	ra,0x2
    389a:	fd4080e7          	jalr	-44(ra) # 586a <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    389e:	85ca                	mv	a1,s2
    38a0:	00004517          	auipc	a0,0x4
    38a4:	f0850513          	addi	a0,a0,-248 # 77a8 <malloc+0x1b08>
    38a8:	00002097          	auipc	ra,0x2
    38ac:	33a080e7          	jalr	826(ra) # 5be2 <printf>
    exit(1);
    38b0:	4505                	li	a0,1
    38b2:	00002097          	auipc	ra,0x2
    38b6:	fb8080e7          	jalr	-72(ra) # 586a <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    38ba:	85ca                	mv	a1,s2
    38bc:	00004517          	auipc	a0,0x4
    38c0:	f0c50513          	addi	a0,a0,-244 # 77c8 <malloc+0x1b28>
    38c4:	00002097          	auipc	ra,0x2
    38c8:	31e080e7          	jalr	798(ra) # 5be2 <printf>
    exit(1);
    38cc:	4505                	li	a0,1
    38ce:	00002097          	auipc	ra,0x2
    38d2:	f9c080e7          	jalr	-100(ra) # 586a <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    38d6:	85ca                	mv	a1,s2
    38d8:	00004517          	auipc	a0,0x4
    38dc:	f1050513          	addi	a0,a0,-240 # 77e8 <malloc+0x1b48>
    38e0:	00002097          	auipc	ra,0x2
    38e4:	302080e7          	jalr	770(ra) # 5be2 <printf>
    exit(1);
    38e8:	4505                	li	a0,1
    38ea:	00002097          	auipc	ra,0x2
    38ee:	f80080e7          	jalr	-128(ra) # 586a <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    38f2:	85ca                	mv	a1,s2
    38f4:	00004517          	auipc	a0,0x4
    38f8:	f1c50513          	addi	a0,a0,-228 # 7810 <malloc+0x1b70>
    38fc:	00002097          	auipc	ra,0x2
    3900:	2e6080e7          	jalr	742(ra) # 5be2 <printf>
    exit(1);
    3904:	4505                	li	a0,1
    3906:	00002097          	auipc	ra,0x2
    390a:	f64080e7          	jalr	-156(ra) # 586a <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    390e:	85ca                	mv	a1,s2
    3910:	00004517          	auipc	a0,0x4
    3914:	f2050513          	addi	a0,a0,-224 # 7830 <malloc+0x1b90>
    3918:	00002097          	auipc	ra,0x2
    391c:	2ca080e7          	jalr	714(ra) # 5be2 <printf>
    exit(1);
    3920:	4505                	li	a0,1
    3922:	00002097          	auipc	ra,0x2
    3926:	f48080e7          	jalr	-184(ra) # 586a <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    392a:	85ca                	mv	a1,s2
    392c:	00004517          	auipc	a0,0x4
    3930:	f2450513          	addi	a0,a0,-220 # 7850 <malloc+0x1bb0>
    3934:	00002097          	auipc	ra,0x2
    3938:	2ae080e7          	jalr	686(ra) # 5be2 <printf>
    exit(1);
    393c:	4505                	li	a0,1
    393e:	00002097          	auipc	ra,0x2
    3942:	f2c080e7          	jalr	-212(ra) # 586a <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3946:	85ca                	mv	a1,s2
    3948:	00004517          	auipc	a0,0x4
    394c:	f3050513          	addi	a0,a0,-208 # 7878 <malloc+0x1bd8>
    3950:	00002097          	auipc	ra,0x2
    3954:	292080e7          	jalr	658(ra) # 5be2 <printf>
    exit(1);
    3958:	4505                	li	a0,1
    395a:	00002097          	auipc	ra,0x2
    395e:	f10080e7          	jalr	-240(ra) # 586a <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3962:	85ca                	mv	a1,s2
    3964:	00004517          	auipc	a0,0x4
    3968:	bac50513          	addi	a0,a0,-1108 # 7510 <malloc+0x1870>
    396c:	00002097          	auipc	ra,0x2
    3970:	276080e7          	jalr	630(ra) # 5be2 <printf>
    exit(1);
    3974:	4505                	li	a0,1
    3976:	00002097          	auipc	ra,0x2
    397a:	ef4080e7          	jalr	-268(ra) # 586a <exit>
    printf("%s: unlink dd/ff failed\n", s);
    397e:	85ca                	mv	a1,s2
    3980:	00004517          	auipc	a0,0x4
    3984:	f1850513          	addi	a0,a0,-232 # 7898 <malloc+0x1bf8>
    3988:	00002097          	auipc	ra,0x2
    398c:	25a080e7          	jalr	602(ra) # 5be2 <printf>
    exit(1);
    3990:	4505                	li	a0,1
    3992:	00002097          	auipc	ra,0x2
    3996:	ed8080e7          	jalr	-296(ra) # 586a <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    399a:	85ca                	mv	a1,s2
    399c:	00004517          	auipc	a0,0x4
    39a0:	f1c50513          	addi	a0,a0,-228 # 78b8 <malloc+0x1c18>
    39a4:	00002097          	auipc	ra,0x2
    39a8:	23e080e7          	jalr	574(ra) # 5be2 <printf>
    exit(1);
    39ac:	4505                	li	a0,1
    39ae:	00002097          	auipc	ra,0x2
    39b2:	ebc080e7          	jalr	-324(ra) # 586a <exit>
    printf("%s: unlink dd/dd failed\n", s);
    39b6:	85ca                	mv	a1,s2
    39b8:	00004517          	auipc	a0,0x4
    39bc:	f3050513          	addi	a0,a0,-208 # 78e8 <malloc+0x1c48>
    39c0:	00002097          	auipc	ra,0x2
    39c4:	222080e7          	jalr	546(ra) # 5be2 <printf>
    exit(1);
    39c8:	4505                	li	a0,1
    39ca:	00002097          	auipc	ra,0x2
    39ce:	ea0080e7          	jalr	-352(ra) # 586a <exit>
    printf("%s: unlink dd failed\n", s);
    39d2:	85ca                	mv	a1,s2
    39d4:	00004517          	auipc	a0,0x4
    39d8:	f3450513          	addi	a0,a0,-204 # 7908 <malloc+0x1c68>
    39dc:	00002097          	auipc	ra,0x2
    39e0:	206080e7          	jalr	518(ra) # 5be2 <printf>
    exit(1);
    39e4:	4505                	li	a0,1
    39e6:	00002097          	auipc	ra,0x2
    39ea:	e84080e7          	jalr	-380(ra) # 586a <exit>

00000000000039ee <rmdot>:
{
    39ee:	1101                	addi	sp,sp,-32
    39f0:	ec06                	sd	ra,24(sp)
    39f2:	e822                	sd	s0,16(sp)
    39f4:	e426                	sd	s1,8(sp)
    39f6:	1000                	addi	s0,sp,32
    39f8:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    39fa:	00004517          	auipc	a0,0x4
    39fe:	f2650513          	addi	a0,a0,-218 # 7920 <malloc+0x1c80>
    3a02:	00002097          	auipc	ra,0x2
    3a06:	ed0080e7          	jalr	-304(ra) # 58d2 <mkdir>
    3a0a:	e549                	bnez	a0,3a94 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3a0c:	00004517          	auipc	a0,0x4
    3a10:	f1450513          	addi	a0,a0,-236 # 7920 <malloc+0x1c80>
    3a14:	00002097          	auipc	ra,0x2
    3a18:	ec6080e7          	jalr	-314(ra) # 58da <chdir>
    3a1c:	e951                	bnez	a0,3ab0 <rmdot+0xc2>
  if(unlink(".") == 0){
    3a1e:	00003517          	auipc	a0,0x3
    3a22:	d9a50513          	addi	a0,a0,-614 # 67b8 <malloc+0xb18>
    3a26:	00002097          	auipc	ra,0x2
    3a2a:	e94080e7          	jalr	-364(ra) # 58ba <unlink>
    3a2e:	cd59                	beqz	a0,3acc <rmdot+0xde>
  if(unlink("..") == 0){
    3a30:	00004517          	auipc	a0,0x4
    3a34:	94850513          	addi	a0,a0,-1720 # 7378 <malloc+0x16d8>
    3a38:	00002097          	auipc	ra,0x2
    3a3c:	e82080e7          	jalr	-382(ra) # 58ba <unlink>
    3a40:	c545                	beqz	a0,3ae8 <rmdot+0xfa>
  if(chdir("/") != 0){
    3a42:	00004517          	auipc	a0,0x4
    3a46:	8de50513          	addi	a0,a0,-1826 # 7320 <malloc+0x1680>
    3a4a:	00002097          	auipc	ra,0x2
    3a4e:	e90080e7          	jalr	-368(ra) # 58da <chdir>
    3a52:	e94d                	bnez	a0,3b04 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3a54:	00004517          	auipc	a0,0x4
    3a58:	f3450513          	addi	a0,a0,-204 # 7988 <malloc+0x1ce8>
    3a5c:	00002097          	auipc	ra,0x2
    3a60:	e5e080e7          	jalr	-418(ra) # 58ba <unlink>
    3a64:	cd55                	beqz	a0,3b20 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3a66:	00004517          	auipc	a0,0x4
    3a6a:	f4a50513          	addi	a0,a0,-182 # 79b0 <malloc+0x1d10>
    3a6e:	00002097          	auipc	ra,0x2
    3a72:	e4c080e7          	jalr	-436(ra) # 58ba <unlink>
    3a76:	c179                	beqz	a0,3b3c <rmdot+0x14e>
  if(unlink("dots") != 0){
    3a78:	00004517          	auipc	a0,0x4
    3a7c:	ea850513          	addi	a0,a0,-344 # 7920 <malloc+0x1c80>
    3a80:	00002097          	auipc	ra,0x2
    3a84:	e3a080e7          	jalr	-454(ra) # 58ba <unlink>
    3a88:	e961                	bnez	a0,3b58 <rmdot+0x16a>
}
    3a8a:	60e2                	ld	ra,24(sp)
    3a8c:	6442                	ld	s0,16(sp)
    3a8e:	64a2                	ld	s1,8(sp)
    3a90:	6105                	addi	sp,sp,32
    3a92:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3a94:	85a6                	mv	a1,s1
    3a96:	00004517          	auipc	a0,0x4
    3a9a:	e9250513          	addi	a0,a0,-366 # 7928 <malloc+0x1c88>
    3a9e:	00002097          	auipc	ra,0x2
    3aa2:	144080e7          	jalr	324(ra) # 5be2 <printf>
    exit(1);
    3aa6:	4505                	li	a0,1
    3aa8:	00002097          	auipc	ra,0x2
    3aac:	dc2080e7          	jalr	-574(ra) # 586a <exit>
    printf("%s: chdir dots failed\n", s);
    3ab0:	85a6                	mv	a1,s1
    3ab2:	00004517          	auipc	a0,0x4
    3ab6:	e8e50513          	addi	a0,a0,-370 # 7940 <malloc+0x1ca0>
    3aba:	00002097          	auipc	ra,0x2
    3abe:	128080e7          	jalr	296(ra) # 5be2 <printf>
    exit(1);
    3ac2:	4505                	li	a0,1
    3ac4:	00002097          	auipc	ra,0x2
    3ac8:	da6080e7          	jalr	-602(ra) # 586a <exit>
    printf("%s: rm . worked!\n", s);
    3acc:	85a6                	mv	a1,s1
    3ace:	00004517          	auipc	a0,0x4
    3ad2:	e8a50513          	addi	a0,a0,-374 # 7958 <malloc+0x1cb8>
    3ad6:	00002097          	auipc	ra,0x2
    3ada:	10c080e7          	jalr	268(ra) # 5be2 <printf>
    exit(1);
    3ade:	4505                	li	a0,1
    3ae0:	00002097          	auipc	ra,0x2
    3ae4:	d8a080e7          	jalr	-630(ra) # 586a <exit>
    printf("%s: rm .. worked!\n", s);
    3ae8:	85a6                	mv	a1,s1
    3aea:	00004517          	auipc	a0,0x4
    3aee:	e8650513          	addi	a0,a0,-378 # 7970 <malloc+0x1cd0>
    3af2:	00002097          	auipc	ra,0x2
    3af6:	0f0080e7          	jalr	240(ra) # 5be2 <printf>
    exit(1);
    3afa:	4505                	li	a0,1
    3afc:	00002097          	auipc	ra,0x2
    3b00:	d6e080e7          	jalr	-658(ra) # 586a <exit>
    printf("%s: chdir / failed\n", s);
    3b04:	85a6                	mv	a1,s1
    3b06:	00004517          	auipc	a0,0x4
    3b0a:	82250513          	addi	a0,a0,-2014 # 7328 <malloc+0x1688>
    3b0e:	00002097          	auipc	ra,0x2
    3b12:	0d4080e7          	jalr	212(ra) # 5be2 <printf>
    exit(1);
    3b16:	4505                	li	a0,1
    3b18:	00002097          	auipc	ra,0x2
    3b1c:	d52080e7          	jalr	-686(ra) # 586a <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3b20:	85a6                	mv	a1,s1
    3b22:	00004517          	auipc	a0,0x4
    3b26:	e6e50513          	addi	a0,a0,-402 # 7990 <malloc+0x1cf0>
    3b2a:	00002097          	auipc	ra,0x2
    3b2e:	0b8080e7          	jalr	184(ra) # 5be2 <printf>
    exit(1);
    3b32:	4505                	li	a0,1
    3b34:	00002097          	auipc	ra,0x2
    3b38:	d36080e7          	jalr	-714(ra) # 586a <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3b3c:	85a6                	mv	a1,s1
    3b3e:	00004517          	auipc	a0,0x4
    3b42:	e7a50513          	addi	a0,a0,-390 # 79b8 <malloc+0x1d18>
    3b46:	00002097          	auipc	ra,0x2
    3b4a:	09c080e7          	jalr	156(ra) # 5be2 <printf>
    exit(1);
    3b4e:	4505                	li	a0,1
    3b50:	00002097          	auipc	ra,0x2
    3b54:	d1a080e7          	jalr	-742(ra) # 586a <exit>
    printf("%s: unlink dots failed!\n", s);
    3b58:	85a6                	mv	a1,s1
    3b5a:	00004517          	auipc	a0,0x4
    3b5e:	e7e50513          	addi	a0,a0,-386 # 79d8 <malloc+0x1d38>
    3b62:	00002097          	auipc	ra,0x2
    3b66:	080080e7          	jalr	128(ra) # 5be2 <printf>
    exit(1);
    3b6a:	4505                	li	a0,1
    3b6c:	00002097          	auipc	ra,0x2
    3b70:	cfe080e7          	jalr	-770(ra) # 586a <exit>

0000000000003b74 <dirfile>:
{
    3b74:	1101                	addi	sp,sp,-32
    3b76:	ec06                	sd	ra,24(sp)
    3b78:	e822                	sd	s0,16(sp)
    3b7a:	e426                	sd	s1,8(sp)
    3b7c:	e04a                	sd	s2,0(sp)
    3b7e:	1000                	addi	s0,sp,32
    3b80:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3b82:	20000593          	li	a1,512
    3b86:	00002517          	auipc	a0,0x2
    3b8a:	53a50513          	addi	a0,a0,1338 # 60c0 <malloc+0x420>
    3b8e:	00002097          	auipc	ra,0x2
    3b92:	d1c080e7          	jalr	-740(ra) # 58aa <open>
  if(fd < 0){
    3b96:	0e054d63          	bltz	a0,3c90 <dirfile+0x11c>
  close(fd);
    3b9a:	00002097          	auipc	ra,0x2
    3b9e:	cf8080e7          	jalr	-776(ra) # 5892 <close>
  if(chdir("dirfile") == 0){
    3ba2:	00002517          	auipc	a0,0x2
    3ba6:	51e50513          	addi	a0,a0,1310 # 60c0 <malloc+0x420>
    3baa:	00002097          	auipc	ra,0x2
    3bae:	d30080e7          	jalr	-720(ra) # 58da <chdir>
    3bb2:	cd6d                	beqz	a0,3cac <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3bb4:	4581                	li	a1,0
    3bb6:	00004517          	auipc	a0,0x4
    3bba:	e8250513          	addi	a0,a0,-382 # 7a38 <malloc+0x1d98>
    3bbe:	00002097          	auipc	ra,0x2
    3bc2:	cec080e7          	jalr	-788(ra) # 58aa <open>
  if(fd >= 0){
    3bc6:	10055163          	bgez	a0,3cc8 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3bca:	20000593          	li	a1,512
    3bce:	00004517          	auipc	a0,0x4
    3bd2:	e6a50513          	addi	a0,a0,-406 # 7a38 <malloc+0x1d98>
    3bd6:	00002097          	auipc	ra,0x2
    3bda:	cd4080e7          	jalr	-812(ra) # 58aa <open>
  if(fd >= 0){
    3bde:	10055363          	bgez	a0,3ce4 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3be2:	00004517          	auipc	a0,0x4
    3be6:	e5650513          	addi	a0,a0,-426 # 7a38 <malloc+0x1d98>
    3bea:	00002097          	auipc	ra,0x2
    3bee:	ce8080e7          	jalr	-792(ra) # 58d2 <mkdir>
    3bf2:	10050763          	beqz	a0,3d00 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3bf6:	00004517          	auipc	a0,0x4
    3bfa:	e4250513          	addi	a0,a0,-446 # 7a38 <malloc+0x1d98>
    3bfe:	00002097          	auipc	ra,0x2
    3c02:	cbc080e7          	jalr	-836(ra) # 58ba <unlink>
    3c06:	10050b63          	beqz	a0,3d1c <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3c0a:	00004597          	auipc	a1,0x4
    3c0e:	e2e58593          	addi	a1,a1,-466 # 7a38 <malloc+0x1d98>
    3c12:	00002517          	auipc	a0,0x2
    3c16:	6a650513          	addi	a0,a0,1702 # 62b8 <malloc+0x618>
    3c1a:	00002097          	auipc	ra,0x2
    3c1e:	cb0080e7          	jalr	-848(ra) # 58ca <link>
    3c22:	10050b63          	beqz	a0,3d38 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3c26:	00002517          	auipc	a0,0x2
    3c2a:	49a50513          	addi	a0,a0,1178 # 60c0 <malloc+0x420>
    3c2e:	00002097          	auipc	ra,0x2
    3c32:	c8c080e7          	jalr	-884(ra) # 58ba <unlink>
    3c36:	10051f63          	bnez	a0,3d54 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3c3a:	4589                	li	a1,2
    3c3c:	00003517          	auipc	a0,0x3
    3c40:	b7c50513          	addi	a0,a0,-1156 # 67b8 <malloc+0xb18>
    3c44:	00002097          	auipc	ra,0x2
    3c48:	c66080e7          	jalr	-922(ra) # 58aa <open>
  if(fd >= 0){
    3c4c:	12055263          	bgez	a0,3d70 <dirfile+0x1fc>
  fd = open(".", 0);
    3c50:	4581                	li	a1,0
    3c52:	00003517          	auipc	a0,0x3
    3c56:	b6650513          	addi	a0,a0,-1178 # 67b8 <malloc+0xb18>
    3c5a:	00002097          	auipc	ra,0x2
    3c5e:	c50080e7          	jalr	-944(ra) # 58aa <open>
    3c62:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3c64:	4605                	li	a2,1
    3c66:	00002597          	auipc	a1,0x2
    3c6a:	52a58593          	addi	a1,a1,1322 # 6190 <malloc+0x4f0>
    3c6e:	00002097          	auipc	ra,0x2
    3c72:	c1c080e7          	jalr	-996(ra) # 588a <write>
    3c76:	10a04b63          	bgtz	a0,3d8c <dirfile+0x218>
  close(fd);
    3c7a:	8526                	mv	a0,s1
    3c7c:	00002097          	auipc	ra,0x2
    3c80:	c16080e7          	jalr	-1002(ra) # 5892 <close>
}
    3c84:	60e2                	ld	ra,24(sp)
    3c86:	6442                	ld	s0,16(sp)
    3c88:	64a2                	ld	s1,8(sp)
    3c8a:	6902                	ld	s2,0(sp)
    3c8c:	6105                	addi	sp,sp,32
    3c8e:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3c90:	85ca                	mv	a1,s2
    3c92:	00004517          	auipc	a0,0x4
    3c96:	d6650513          	addi	a0,a0,-666 # 79f8 <malloc+0x1d58>
    3c9a:	00002097          	auipc	ra,0x2
    3c9e:	f48080e7          	jalr	-184(ra) # 5be2 <printf>
    exit(1);
    3ca2:	4505                	li	a0,1
    3ca4:	00002097          	auipc	ra,0x2
    3ca8:	bc6080e7          	jalr	-1082(ra) # 586a <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3cac:	85ca                	mv	a1,s2
    3cae:	00004517          	auipc	a0,0x4
    3cb2:	d6a50513          	addi	a0,a0,-662 # 7a18 <malloc+0x1d78>
    3cb6:	00002097          	auipc	ra,0x2
    3cba:	f2c080e7          	jalr	-212(ra) # 5be2 <printf>
    exit(1);
    3cbe:	4505                	li	a0,1
    3cc0:	00002097          	auipc	ra,0x2
    3cc4:	baa080e7          	jalr	-1110(ra) # 586a <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3cc8:	85ca                	mv	a1,s2
    3cca:	00004517          	auipc	a0,0x4
    3cce:	d7e50513          	addi	a0,a0,-642 # 7a48 <malloc+0x1da8>
    3cd2:	00002097          	auipc	ra,0x2
    3cd6:	f10080e7          	jalr	-240(ra) # 5be2 <printf>
    exit(1);
    3cda:	4505                	li	a0,1
    3cdc:	00002097          	auipc	ra,0x2
    3ce0:	b8e080e7          	jalr	-1138(ra) # 586a <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3ce4:	85ca                	mv	a1,s2
    3ce6:	00004517          	auipc	a0,0x4
    3cea:	d6250513          	addi	a0,a0,-670 # 7a48 <malloc+0x1da8>
    3cee:	00002097          	auipc	ra,0x2
    3cf2:	ef4080e7          	jalr	-268(ra) # 5be2 <printf>
    exit(1);
    3cf6:	4505                	li	a0,1
    3cf8:	00002097          	auipc	ra,0x2
    3cfc:	b72080e7          	jalr	-1166(ra) # 586a <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3d00:	85ca                	mv	a1,s2
    3d02:	00004517          	auipc	a0,0x4
    3d06:	d6e50513          	addi	a0,a0,-658 # 7a70 <malloc+0x1dd0>
    3d0a:	00002097          	auipc	ra,0x2
    3d0e:	ed8080e7          	jalr	-296(ra) # 5be2 <printf>
    exit(1);
    3d12:	4505                	li	a0,1
    3d14:	00002097          	auipc	ra,0x2
    3d18:	b56080e7          	jalr	-1194(ra) # 586a <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3d1c:	85ca                	mv	a1,s2
    3d1e:	00004517          	auipc	a0,0x4
    3d22:	d7a50513          	addi	a0,a0,-646 # 7a98 <malloc+0x1df8>
    3d26:	00002097          	auipc	ra,0x2
    3d2a:	ebc080e7          	jalr	-324(ra) # 5be2 <printf>
    exit(1);
    3d2e:	4505                	li	a0,1
    3d30:	00002097          	auipc	ra,0x2
    3d34:	b3a080e7          	jalr	-1222(ra) # 586a <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3d38:	85ca                	mv	a1,s2
    3d3a:	00004517          	auipc	a0,0x4
    3d3e:	d8650513          	addi	a0,a0,-634 # 7ac0 <malloc+0x1e20>
    3d42:	00002097          	auipc	ra,0x2
    3d46:	ea0080e7          	jalr	-352(ra) # 5be2 <printf>
    exit(1);
    3d4a:	4505                	li	a0,1
    3d4c:	00002097          	auipc	ra,0x2
    3d50:	b1e080e7          	jalr	-1250(ra) # 586a <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3d54:	85ca                	mv	a1,s2
    3d56:	00004517          	auipc	a0,0x4
    3d5a:	d9250513          	addi	a0,a0,-622 # 7ae8 <malloc+0x1e48>
    3d5e:	00002097          	auipc	ra,0x2
    3d62:	e84080e7          	jalr	-380(ra) # 5be2 <printf>
    exit(1);
    3d66:	4505                	li	a0,1
    3d68:	00002097          	auipc	ra,0x2
    3d6c:	b02080e7          	jalr	-1278(ra) # 586a <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3d70:	85ca                	mv	a1,s2
    3d72:	00004517          	auipc	a0,0x4
    3d76:	d9650513          	addi	a0,a0,-618 # 7b08 <malloc+0x1e68>
    3d7a:	00002097          	auipc	ra,0x2
    3d7e:	e68080e7          	jalr	-408(ra) # 5be2 <printf>
    exit(1);
    3d82:	4505                	li	a0,1
    3d84:	00002097          	auipc	ra,0x2
    3d88:	ae6080e7          	jalr	-1306(ra) # 586a <exit>
    printf("%s: write . succeeded!\n", s);
    3d8c:	85ca                	mv	a1,s2
    3d8e:	00004517          	auipc	a0,0x4
    3d92:	da250513          	addi	a0,a0,-606 # 7b30 <malloc+0x1e90>
    3d96:	00002097          	auipc	ra,0x2
    3d9a:	e4c080e7          	jalr	-436(ra) # 5be2 <printf>
    exit(1);
    3d9e:	4505                	li	a0,1
    3da0:	00002097          	auipc	ra,0x2
    3da4:	aca080e7          	jalr	-1334(ra) # 586a <exit>

0000000000003da8 <iref>:
{
    3da8:	7139                	addi	sp,sp,-64
    3daa:	fc06                	sd	ra,56(sp)
    3dac:	f822                	sd	s0,48(sp)
    3dae:	f426                	sd	s1,40(sp)
    3db0:	f04a                	sd	s2,32(sp)
    3db2:	ec4e                	sd	s3,24(sp)
    3db4:	e852                	sd	s4,16(sp)
    3db6:	e456                	sd	s5,8(sp)
    3db8:	e05a                	sd	s6,0(sp)
    3dba:	0080                	addi	s0,sp,64
    3dbc:	8b2a                	mv	s6,a0
    3dbe:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3dc2:	00004a17          	auipc	s4,0x4
    3dc6:	d86a0a13          	addi	s4,s4,-634 # 7b48 <malloc+0x1ea8>
    mkdir("");
    3dca:	00004497          	auipc	s1,0x4
    3dce:	88e48493          	addi	s1,s1,-1906 # 7658 <malloc+0x19b8>
    link("README", "");
    3dd2:	00002a97          	auipc	s5,0x2
    3dd6:	4e6a8a93          	addi	s5,s5,1254 # 62b8 <malloc+0x618>
    fd = open("xx", O_CREATE);
    3dda:	00004997          	auipc	s3,0x4
    3dde:	c6698993          	addi	s3,s3,-922 # 7a40 <malloc+0x1da0>
    3de2:	a891                	j	3e36 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3de4:	85da                	mv	a1,s6
    3de6:	00004517          	auipc	a0,0x4
    3dea:	d6a50513          	addi	a0,a0,-662 # 7b50 <malloc+0x1eb0>
    3dee:	00002097          	auipc	ra,0x2
    3df2:	df4080e7          	jalr	-524(ra) # 5be2 <printf>
      exit(1);
    3df6:	4505                	li	a0,1
    3df8:	00002097          	auipc	ra,0x2
    3dfc:	a72080e7          	jalr	-1422(ra) # 586a <exit>
      printf("%s: chdir irefd failed\n", s);
    3e00:	85da                	mv	a1,s6
    3e02:	00004517          	auipc	a0,0x4
    3e06:	d6650513          	addi	a0,a0,-666 # 7b68 <malloc+0x1ec8>
    3e0a:	00002097          	auipc	ra,0x2
    3e0e:	dd8080e7          	jalr	-552(ra) # 5be2 <printf>
      exit(1);
    3e12:	4505                	li	a0,1
    3e14:	00002097          	auipc	ra,0x2
    3e18:	a56080e7          	jalr	-1450(ra) # 586a <exit>
      close(fd);
    3e1c:	00002097          	auipc	ra,0x2
    3e20:	a76080e7          	jalr	-1418(ra) # 5892 <close>
    3e24:	a889                	j	3e76 <iref+0xce>
    unlink("xx");
    3e26:	854e                	mv	a0,s3
    3e28:	00002097          	auipc	ra,0x2
    3e2c:	a92080e7          	jalr	-1390(ra) # 58ba <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3e30:	397d                	addiw	s2,s2,-1
    3e32:	06090063          	beqz	s2,3e92 <iref+0xea>
    if(mkdir("irefd") != 0){
    3e36:	8552                	mv	a0,s4
    3e38:	00002097          	auipc	ra,0x2
    3e3c:	a9a080e7          	jalr	-1382(ra) # 58d2 <mkdir>
    3e40:	f155                	bnez	a0,3de4 <iref+0x3c>
    if(chdir("irefd") != 0){
    3e42:	8552                	mv	a0,s4
    3e44:	00002097          	auipc	ra,0x2
    3e48:	a96080e7          	jalr	-1386(ra) # 58da <chdir>
    3e4c:	f955                	bnez	a0,3e00 <iref+0x58>
    mkdir("");
    3e4e:	8526                	mv	a0,s1
    3e50:	00002097          	auipc	ra,0x2
    3e54:	a82080e7          	jalr	-1406(ra) # 58d2 <mkdir>
    link("README", "");
    3e58:	85a6                	mv	a1,s1
    3e5a:	8556                	mv	a0,s5
    3e5c:	00002097          	auipc	ra,0x2
    3e60:	a6e080e7          	jalr	-1426(ra) # 58ca <link>
    fd = open("", O_CREATE);
    3e64:	20000593          	li	a1,512
    3e68:	8526                	mv	a0,s1
    3e6a:	00002097          	auipc	ra,0x2
    3e6e:	a40080e7          	jalr	-1472(ra) # 58aa <open>
    if(fd >= 0)
    3e72:	fa0555e3          	bgez	a0,3e1c <iref+0x74>
    fd = open("xx", O_CREATE);
    3e76:	20000593          	li	a1,512
    3e7a:	854e                	mv	a0,s3
    3e7c:	00002097          	auipc	ra,0x2
    3e80:	a2e080e7          	jalr	-1490(ra) # 58aa <open>
    if(fd >= 0)
    3e84:	fa0541e3          	bltz	a0,3e26 <iref+0x7e>
      close(fd);
    3e88:	00002097          	auipc	ra,0x2
    3e8c:	a0a080e7          	jalr	-1526(ra) # 5892 <close>
    3e90:	bf59                	j	3e26 <iref+0x7e>
    3e92:	03300493          	li	s1,51
    chdir("..");
    3e96:	00003997          	auipc	s3,0x3
    3e9a:	4e298993          	addi	s3,s3,1250 # 7378 <malloc+0x16d8>
    unlink("irefd");
    3e9e:	00004917          	auipc	s2,0x4
    3ea2:	caa90913          	addi	s2,s2,-854 # 7b48 <malloc+0x1ea8>
    chdir("..");
    3ea6:	854e                	mv	a0,s3
    3ea8:	00002097          	auipc	ra,0x2
    3eac:	a32080e7          	jalr	-1486(ra) # 58da <chdir>
    unlink("irefd");
    3eb0:	854a                	mv	a0,s2
    3eb2:	00002097          	auipc	ra,0x2
    3eb6:	a08080e7          	jalr	-1528(ra) # 58ba <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3eba:	34fd                	addiw	s1,s1,-1
    3ebc:	f4ed                	bnez	s1,3ea6 <iref+0xfe>
  chdir("/");
    3ebe:	00003517          	auipc	a0,0x3
    3ec2:	46250513          	addi	a0,a0,1122 # 7320 <malloc+0x1680>
    3ec6:	00002097          	auipc	ra,0x2
    3eca:	a14080e7          	jalr	-1516(ra) # 58da <chdir>
}
    3ece:	70e2                	ld	ra,56(sp)
    3ed0:	7442                	ld	s0,48(sp)
    3ed2:	74a2                	ld	s1,40(sp)
    3ed4:	7902                	ld	s2,32(sp)
    3ed6:	69e2                	ld	s3,24(sp)
    3ed8:	6a42                	ld	s4,16(sp)
    3eda:	6aa2                	ld	s5,8(sp)
    3edc:	6b02                	ld	s6,0(sp)
    3ede:	6121                	addi	sp,sp,64
    3ee0:	8082                	ret

0000000000003ee2 <openiputtest>:
{
    3ee2:	7179                	addi	sp,sp,-48
    3ee4:	f406                	sd	ra,40(sp)
    3ee6:	f022                	sd	s0,32(sp)
    3ee8:	ec26                	sd	s1,24(sp)
    3eea:	1800                	addi	s0,sp,48
    3eec:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3eee:	00004517          	auipc	a0,0x4
    3ef2:	c9250513          	addi	a0,a0,-878 # 7b80 <malloc+0x1ee0>
    3ef6:	00002097          	auipc	ra,0x2
    3efa:	9dc080e7          	jalr	-1572(ra) # 58d2 <mkdir>
    3efe:	04054263          	bltz	a0,3f42 <openiputtest+0x60>
  pid = fork();
    3f02:	00002097          	auipc	ra,0x2
    3f06:	960080e7          	jalr	-1696(ra) # 5862 <fork>
  if(pid < 0){
    3f0a:	04054a63          	bltz	a0,3f5e <openiputtest+0x7c>
  if(pid == 0){
    3f0e:	e93d                	bnez	a0,3f84 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3f10:	4589                	li	a1,2
    3f12:	00004517          	auipc	a0,0x4
    3f16:	c6e50513          	addi	a0,a0,-914 # 7b80 <malloc+0x1ee0>
    3f1a:	00002097          	auipc	ra,0x2
    3f1e:	990080e7          	jalr	-1648(ra) # 58aa <open>
    if(fd >= 0){
    3f22:	04054c63          	bltz	a0,3f7a <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3f26:	85a6                	mv	a1,s1
    3f28:	00004517          	auipc	a0,0x4
    3f2c:	c7850513          	addi	a0,a0,-904 # 7ba0 <malloc+0x1f00>
    3f30:	00002097          	auipc	ra,0x2
    3f34:	cb2080e7          	jalr	-846(ra) # 5be2 <printf>
      exit(1);
    3f38:	4505                	li	a0,1
    3f3a:	00002097          	auipc	ra,0x2
    3f3e:	930080e7          	jalr	-1744(ra) # 586a <exit>
    printf("%s: mkdir oidir failed\n", s);
    3f42:	85a6                	mv	a1,s1
    3f44:	00004517          	auipc	a0,0x4
    3f48:	c4450513          	addi	a0,a0,-956 # 7b88 <malloc+0x1ee8>
    3f4c:	00002097          	auipc	ra,0x2
    3f50:	c96080e7          	jalr	-874(ra) # 5be2 <printf>
    exit(1);
    3f54:	4505                	li	a0,1
    3f56:	00002097          	auipc	ra,0x2
    3f5a:	914080e7          	jalr	-1772(ra) # 586a <exit>
    printf("%s: fork failed\n", s);
    3f5e:	85a6                	mv	a1,s1
    3f60:	00003517          	auipc	a0,0x3
    3f64:	9f850513          	addi	a0,a0,-1544 # 6958 <malloc+0xcb8>
    3f68:	00002097          	auipc	ra,0x2
    3f6c:	c7a080e7          	jalr	-902(ra) # 5be2 <printf>
    exit(1);
    3f70:	4505                	li	a0,1
    3f72:	00002097          	auipc	ra,0x2
    3f76:	8f8080e7          	jalr	-1800(ra) # 586a <exit>
    exit(0);
    3f7a:	4501                	li	a0,0
    3f7c:	00002097          	auipc	ra,0x2
    3f80:	8ee080e7          	jalr	-1810(ra) # 586a <exit>
  sleep(1);
    3f84:	4505                	li	a0,1
    3f86:	00002097          	auipc	ra,0x2
    3f8a:	974080e7          	jalr	-1676(ra) # 58fa <sleep>
  if(unlink("oidir") != 0){
    3f8e:	00004517          	auipc	a0,0x4
    3f92:	bf250513          	addi	a0,a0,-1038 # 7b80 <malloc+0x1ee0>
    3f96:	00002097          	auipc	ra,0x2
    3f9a:	924080e7          	jalr	-1756(ra) # 58ba <unlink>
    3f9e:	cd19                	beqz	a0,3fbc <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3fa0:	85a6                	mv	a1,s1
    3fa2:	00003517          	auipc	a0,0x3
    3fa6:	ba650513          	addi	a0,a0,-1114 # 6b48 <malloc+0xea8>
    3faa:	00002097          	auipc	ra,0x2
    3fae:	c38080e7          	jalr	-968(ra) # 5be2 <printf>
    exit(1);
    3fb2:	4505                	li	a0,1
    3fb4:	00002097          	auipc	ra,0x2
    3fb8:	8b6080e7          	jalr	-1866(ra) # 586a <exit>
  wait(&xstatus);
    3fbc:	fdc40513          	addi	a0,s0,-36
    3fc0:	00002097          	auipc	ra,0x2
    3fc4:	8b2080e7          	jalr	-1870(ra) # 5872 <wait>
  exit(xstatus);
    3fc8:	fdc42503          	lw	a0,-36(s0)
    3fcc:	00002097          	auipc	ra,0x2
    3fd0:	89e080e7          	jalr	-1890(ra) # 586a <exit>

0000000000003fd4 <forkforkfork>:
{
    3fd4:	1101                	addi	sp,sp,-32
    3fd6:	ec06                	sd	ra,24(sp)
    3fd8:	e822                	sd	s0,16(sp)
    3fda:	e426                	sd	s1,8(sp)
    3fdc:	1000                	addi	s0,sp,32
    3fde:	84aa                	mv	s1,a0
  unlink("stopforking");
    3fe0:	00004517          	auipc	a0,0x4
    3fe4:	be850513          	addi	a0,a0,-1048 # 7bc8 <malloc+0x1f28>
    3fe8:	00002097          	auipc	ra,0x2
    3fec:	8d2080e7          	jalr	-1838(ra) # 58ba <unlink>
  int pid = fork();
    3ff0:	00002097          	auipc	ra,0x2
    3ff4:	872080e7          	jalr	-1934(ra) # 5862 <fork>
  if(pid < 0){
    3ff8:	04054563          	bltz	a0,4042 <forkforkfork+0x6e>
  if(pid == 0){
    3ffc:	c12d                	beqz	a0,405e <forkforkfork+0x8a>
  sleep(20); // two seconds
    3ffe:	4551                	li	a0,20
    4000:	00002097          	auipc	ra,0x2
    4004:	8fa080e7          	jalr	-1798(ra) # 58fa <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    4008:	20200593          	li	a1,514
    400c:	00004517          	auipc	a0,0x4
    4010:	bbc50513          	addi	a0,a0,-1092 # 7bc8 <malloc+0x1f28>
    4014:	00002097          	auipc	ra,0x2
    4018:	896080e7          	jalr	-1898(ra) # 58aa <open>
    401c:	00002097          	auipc	ra,0x2
    4020:	876080e7          	jalr	-1930(ra) # 5892 <close>
  wait(0);
    4024:	4501                	li	a0,0
    4026:	00002097          	auipc	ra,0x2
    402a:	84c080e7          	jalr	-1972(ra) # 5872 <wait>
  sleep(10); // one second
    402e:	4529                	li	a0,10
    4030:	00002097          	auipc	ra,0x2
    4034:	8ca080e7          	jalr	-1846(ra) # 58fa <sleep>
}
    4038:	60e2                	ld	ra,24(sp)
    403a:	6442                	ld	s0,16(sp)
    403c:	64a2                	ld	s1,8(sp)
    403e:	6105                	addi	sp,sp,32
    4040:	8082                	ret
    printf("%s: fork failed", s);
    4042:	85a6                	mv	a1,s1
    4044:	00003517          	auipc	a0,0x3
    4048:	ad450513          	addi	a0,a0,-1324 # 6b18 <malloc+0xe78>
    404c:	00002097          	auipc	ra,0x2
    4050:	b96080e7          	jalr	-1130(ra) # 5be2 <printf>
    exit(1);
    4054:	4505                	li	a0,1
    4056:	00002097          	auipc	ra,0x2
    405a:	814080e7          	jalr	-2028(ra) # 586a <exit>
      int fd = open("stopforking", 0);
    405e:	00004497          	auipc	s1,0x4
    4062:	b6a48493          	addi	s1,s1,-1174 # 7bc8 <malloc+0x1f28>
    4066:	4581                	li	a1,0
    4068:	8526                	mv	a0,s1
    406a:	00002097          	auipc	ra,0x2
    406e:	840080e7          	jalr	-1984(ra) # 58aa <open>
      if(fd >= 0){
    4072:	02055463          	bgez	a0,409a <forkforkfork+0xc6>
      if(fork() < 0){
    4076:	00001097          	auipc	ra,0x1
    407a:	7ec080e7          	jalr	2028(ra) # 5862 <fork>
    407e:	fe0554e3          	bgez	a0,4066 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    4082:	20200593          	li	a1,514
    4086:	8526                	mv	a0,s1
    4088:	00002097          	auipc	ra,0x2
    408c:	822080e7          	jalr	-2014(ra) # 58aa <open>
    4090:	00002097          	auipc	ra,0x2
    4094:	802080e7          	jalr	-2046(ra) # 5892 <close>
    4098:	b7f9                	j	4066 <forkforkfork+0x92>
        exit(0);
    409a:	4501                	li	a0,0
    409c:	00001097          	auipc	ra,0x1
    40a0:	7ce080e7          	jalr	1998(ra) # 586a <exit>

00000000000040a4 <killstatus>:
{
    40a4:	7139                	addi	sp,sp,-64
    40a6:	fc06                	sd	ra,56(sp)
    40a8:	f822                	sd	s0,48(sp)
    40aa:	f426                	sd	s1,40(sp)
    40ac:	f04a                	sd	s2,32(sp)
    40ae:	ec4e                	sd	s3,24(sp)
    40b0:	e852                	sd	s4,16(sp)
    40b2:	0080                	addi	s0,sp,64
    40b4:	8a2a                	mv	s4,a0
    40b6:	06400913          	li	s2,100
    if(xst != -1) {
    40ba:	59fd                	li	s3,-1
    int pid1 = fork();
    40bc:	00001097          	auipc	ra,0x1
    40c0:	7a6080e7          	jalr	1958(ra) # 5862 <fork>
    40c4:	84aa                	mv	s1,a0
    if(pid1 < 0){
    40c6:	02054f63          	bltz	a0,4104 <killstatus+0x60>
    if(pid1 == 0){
    40ca:	c939                	beqz	a0,4120 <killstatus+0x7c>
    sleep(1);
    40cc:	4505                	li	a0,1
    40ce:	00002097          	auipc	ra,0x2
    40d2:	82c080e7          	jalr	-2004(ra) # 58fa <sleep>
    kill(pid1);
    40d6:	8526                	mv	a0,s1
    40d8:	00001097          	auipc	ra,0x1
    40dc:	7c2080e7          	jalr	1986(ra) # 589a <kill>
    wait(&xst);
    40e0:	fcc40513          	addi	a0,s0,-52
    40e4:	00001097          	auipc	ra,0x1
    40e8:	78e080e7          	jalr	1934(ra) # 5872 <wait>
    if(xst != -1) {
    40ec:	fcc42783          	lw	a5,-52(s0)
    40f0:	03379d63          	bne	a5,s3,412a <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    40f4:	397d                	addiw	s2,s2,-1
    40f6:	fc0913e3          	bnez	s2,40bc <killstatus+0x18>
  exit(0);
    40fa:	4501                	li	a0,0
    40fc:	00001097          	auipc	ra,0x1
    4100:	76e080e7          	jalr	1902(ra) # 586a <exit>
      printf("%s: fork failed\n", s);
    4104:	85d2                	mv	a1,s4
    4106:	00003517          	auipc	a0,0x3
    410a:	85250513          	addi	a0,a0,-1966 # 6958 <malloc+0xcb8>
    410e:	00002097          	auipc	ra,0x2
    4112:	ad4080e7          	jalr	-1324(ra) # 5be2 <printf>
      exit(1);
    4116:	4505                	li	a0,1
    4118:	00001097          	auipc	ra,0x1
    411c:	752080e7          	jalr	1874(ra) # 586a <exit>
        getpid();
    4120:	00001097          	auipc	ra,0x1
    4124:	7ca080e7          	jalr	1994(ra) # 58ea <getpid>
      while(1) {
    4128:	bfe5                	j	4120 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    412a:	85d2                	mv	a1,s4
    412c:	00004517          	auipc	a0,0x4
    4130:	aac50513          	addi	a0,a0,-1364 # 7bd8 <malloc+0x1f38>
    4134:	00002097          	auipc	ra,0x2
    4138:	aae080e7          	jalr	-1362(ra) # 5be2 <printf>
       exit(1);
    413c:	4505                	li	a0,1
    413e:	00001097          	auipc	ra,0x1
    4142:	72c080e7          	jalr	1836(ra) # 586a <exit>

0000000000004146 <preempt>:
{
    4146:	7139                	addi	sp,sp,-64
    4148:	fc06                	sd	ra,56(sp)
    414a:	f822                	sd	s0,48(sp)
    414c:	f426                	sd	s1,40(sp)
    414e:	f04a                	sd	s2,32(sp)
    4150:	ec4e                	sd	s3,24(sp)
    4152:	e852                	sd	s4,16(sp)
    4154:	0080                	addi	s0,sp,64
    4156:	84aa                	mv	s1,a0
  pid1 = fork();
    4158:	00001097          	auipc	ra,0x1
    415c:	70a080e7          	jalr	1802(ra) # 5862 <fork>
  if(pid1 < 0) {
    4160:	00054563          	bltz	a0,416a <preempt+0x24>
    4164:	8a2a                	mv	s4,a0
  if(pid1 == 0)
    4166:	e105                	bnez	a0,4186 <preempt+0x40>
    for(;;)
    4168:	a001                	j	4168 <preempt+0x22>
    printf("%s: fork failed", s);
    416a:	85a6                	mv	a1,s1
    416c:	00003517          	auipc	a0,0x3
    4170:	9ac50513          	addi	a0,a0,-1620 # 6b18 <malloc+0xe78>
    4174:	00002097          	auipc	ra,0x2
    4178:	a6e080e7          	jalr	-1426(ra) # 5be2 <printf>
    exit(1);
    417c:	4505                	li	a0,1
    417e:	00001097          	auipc	ra,0x1
    4182:	6ec080e7          	jalr	1772(ra) # 586a <exit>
  pid2 = fork();
    4186:	00001097          	auipc	ra,0x1
    418a:	6dc080e7          	jalr	1756(ra) # 5862 <fork>
    418e:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    4190:	00054463          	bltz	a0,4198 <preempt+0x52>
  if(pid2 == 0)
    4194:	e105                	bnez	a0,41b4 <preempt+0x6e>
    for(;;)
    4196:	a001                	j	4196 <preempt+0x50>
    printf("%s: fork failed\n", s);
    4198:	85a6                	mv	a1,s1
    419a:	00002517          	auipc	a0,0x2
    419e:	7be50513          	addi	a0,a0,1982 # 6958 <malloc+0xcb8>
    41a2:	00002097          	auipc	ra,0x2
    41a6:	a40080e7          	jalr	-1472(ra) # 5be2 <printf>
    exit(1);
    41aa:	4505                	li	a0,1
    41ac:	00001097          	auipc	ra,0x1
    41b0:	6be080e7          	jalr	1726(ra) # 586a <exit>
  pipe(pfds);
    41b4:	fc840513          	addi	a0,s0,-56
    41b8:	00001097          	auipc	ra,0x1
    41bc:	6c2080e7          	jalr	1730(ra) # 587a <pipe>
  pid3 = fork();
    41c0:	00001097          	auipc	ra,0x1
    41c4:	6a2080e7          	jalr	1698(ra) # 5862 <fork>
    41c8:	892a                	mv	s2,a0
  if(pid3 < 0) {
    41ca:	02054e63          	bltz	a0,4206 <preempt+0xc0>
  if(pid3 == 0){
    41ce:	e525                	bnez	a0,4236 <preempt+0xf0>
    close(pfds[0]);
    41d0:	fc842503          	lw	a0,-56(s0)
    41d4:	00001097          	auipc	ra,0x1
    41d8:	6be080e7          	jalr	1726(ra) # 5892 <close>
    if(write(pfds[1], "x", 1) != 1)
    41dc:	4605                	li	a2,1
    41de:	00002597          	auipc	a1,0x2
    41e2:	fb258593          	addi	a1,a1,-78 # 6190 <malloc+0x4f0>
    41e6:	fcc42503          	lw	a0,-52(s0)
    41ea:	00001097          	auipc	ra,0x1
    41ee:	6a0080e7          	jalr	1696(ra) # 588a <write>
    41f2:	4785                	li	a5,1
    41f4:	02f51763          	bne	a0,a5,4222 <preempt+0xdc>
    close(pfds[1]);
    41f8:	fcc42503          	lw	a0,-52(s0)
    41fc:	00001097          	auipc	ra,0x1
    4200:	696080e7          	jalr	1686(ra) # 5892 <close>
    for(;;)
    4204:	a001                	j	4204 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4206:	85a6                	mv	a1,s1
    4208:	00002517          	auipc	a0,0x2
    420c:	75050513          	addi	a0,a0,1872 # 6958 <malloc+0xcb8>
    4210:	00002097          	auipc	ra,0x2
    4214:	9d2080e7          	jalr	-1582(ra) # 5be2 <printf>
     exit(1);
    4218:	4505                	li	a0,1
    421a:	00001097          	auipc	ra,0x1
    421e:	650080e7          	jalr	1616(ra) # 586a <exit>
      printf("%s: preempt write error", s);
    4222:	85a6                	mv	a1,s1
    4224:	00004517          	auipc	a0,0x4
    4228:	9d450513          	addi	a0,a0,-1580 # 7bf8 <malloc+0x1f58>
    422c:	00002097          	auipc	ra,0x2
    4230:	9b6080e7          	jalr	-1610(ra) # 5be2 <printf>
    4234:	b7d1                	j	41f8 <preempt+0xb2>
  close(pfds[1]);
    4236:	fcc42503          	lw	a0,-52(s0)
    423a:	00001097          	auipc	ra,0x1
    423e:	658080e7          	jalr	1624(ra) # 5892 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4242:	660d                	lui	a2,0x3
    4244:	00008597          	auipc	a1,0x8
    4248:	b6458593          	addi	a1,a1,-1180 # bda8 <buf>
    424c:	fc842503          	lw	a0,-56(s0)
    4250:	00001097          	auipc	ra,0x1
    4254:	632080e7          	jalr	1586(ra) # 5882 <read>
    4258:	4785                	li	a5,1
    425a:	02f50363          	beq	a0,a5,4280 <preempt+0x13a>
    printf("%s: preempt read error", s);
    425e:	85a6                	mv	a1,s1
    4260:	00004517          	auipc	a0,0x4
    4264:	9b050513          	addi	a0,a0,-1616 # 7c10 <malloc+0x1f70>
    4268:	00002097          	auipc	ra,0x2
    426c:	97a080e7          	jalr	-1670(ra) # 5be2 <printf>
}
    4270:	70e2                	ld	ra,56(sp)
    4272:	7442                	ld	s0,48(sp)
    4274:	74a2                	ld	s1,40(sp)
    4276:	7902                	ld	s2,32(sp)
    4278:	69e2                	ld	s3,24(sp)
    427a:	6a42                	ld	s4,16(sp)
    427c:	6121                	addi	sp,sp,64
    427e:	8082                	ret
  close(pfds[0]);
    4280:	fc842503          	lw	a0,-56(s0)
    4284:	00001097          	auipc	ra,0x1
    4288:	60e080e7          	jalr	1550(ra) # 5892 <close>
  printf("kill... ");
    428c:	00004517          	auipc	a0,0x4
    4290:	99c50513          	addi	a0,a0,-1636 # 7c28 <malloc+0x1f88>
    4294:	00002097          	auipc	ra,0x2
    4298:	94e080e7          	jalr	-1714(ra) # 5be2 <printf>
  kill(pid1);
    429c:	8552                	mv	a0,s4
    429e:	00001097          	auipc	ra,0x1
    42a2:	5fc080e7          	jalr	1532(ra) # 589a <kill>
  kill(pid2);
    42a6:	854e                	mv	a0,s3
    42a8:	00001097          	auipc	ra,0x1
    42ac:	5f2080e7          	jalr	1522(ra) # 589a <kill>
  kill(pid3);
    42b0:	854a                	mv	a0,s2
    42b2:	00001097          	auipc	ra,0x1
    42b6:	5e8080e7          	jalr	1512(ra) # 589a <kill>
  printf("wait... ");
    42ba:	00004517          	auipc	a0,0x4
    42be:	97e50513          	addi	a0,a0,-1666 # 7c38 <malloc+0x1f98>
    42c2:	00002097          	auipc	ra,0x2
    42c6:	920080e7          	jalr	-1760(ra) # 5be2 <printf>
  wait(0);
    42ca:	4501                	li	a0,0
    42cc:	00001097          	auipc	ra,0x1
    42d0:	5a6080e7          	jalr	1446(ra) # 5872 <wait>
  wait(0);
    42d4:	4501                	li	a0,0
    42d6:	00001097          	auipc	ra,0x1
    42da:	59c080e7          	jalr	1436(ra) # 5872 <wait>
  wait(0);
    42de:	4501                	li	a0,0
    42e0:	00001097          	auipc	ra,0x1
    42e4:	592080e7          	jalr	1426(ra) # 5872 <wait>
    42e8:	b761                	j	4270 <preempt+0x12a>

00000000000042ea <reparent>:
{
    42ea:	7179                	addi	sp,sp,-48
    42ec:	f406                	sd	ra,40(sp)
    42ee:	f022                	sd	s0,32(sp)
    42f0:	ec26                	sd	s1,24(sp)
    42f2:	e84a                	sd	s2,16(sp)
    42f4:	e44e                	sd	s3,8(sp)
    42f6:	e052                	sd	s4,0(sp)
    42f8:	1800                	addi	s0,sp,48
    42fa:	89aa                	mv	s3,a0
  int master_pid = getpid();
    42fc:	00001097          	auipc	ra,0x1
    4300:	5ee080e7          	jalr	1518(ra) # 58ea <getpid>
    4304:	8a2a                	mv	s4,a0
    4306:	0c800913          	li	s2,200
    int pid = fork();
    430a:	00001097          	auipc	ra,0x1
    430e:	558080e7          	jalr	1368(ra) # 5862 <fork>
    4312:	84aa                	mv	s1,a0
    if(pid < 0){
    4314:	02054263          	bltz	a0,4338 <reparent+0x4e>
    if(pid){
    4318:	cd21                	beqz	a0,4370 <reparent+0x86>
      if(wait(0) != pid){
    431a:	4501                	li	a0,0
    431c:	00001097          	auipc	ra,0x1
    4320:	556080e7          	jalr	1366(ra) # 5872 <wait>
    4324:	02951863          	bne	a0,s1,4354 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4328:	397d                	addiw	s2,s2,-1
    432a:	fe0910e3          	bnez	s2,430a <reparent+0x20>
  exit(0);
    432e:	4501                	li	a0,0
    4330:	00001097          	auipc	ra,0x1
    4334:	53a080e7          	jalr	1338(ra) # 586a <exit>
      printf("%s: fork failed\n", s);
    4338:	85ce                	mv	a1,s3
    433a:	00002517          	auipc	a0,0x2
    433e:	61e50513          	addi	a0,a0,1566 # 6958 <malloc+0xcb8>
    4342:	00002097          	auipc	ra,0x2
    4346:	8a0080e7          	jalr	-1888(ra) # 5be2 <printf>
      exit(1);
    434a:	4505                	li	a0,1
    434c:	00001097          	auipc	ra,0x1
    4350:	51e080e7          	jalr	1310(ra) # 586a <exit>
        printf("%s: wait wrong pid\n", s);
    4354:	85ce                	mv	a1,s3
    4356:	00002517          	auipc	a0,0x2
    435a:	78a50513          	addi	a0,a0,1930 # 6ae0 <malloc+0xe40>
    435e:	00002097          	auipc	ra,0x2
    4362:	884080e7          	jalr	-1916(ra) # 5be2 <printf>
        exit(1);
    4366:	4505                	li	a0,1
    4368:	00001097          	auipc	ra,0x1
    436c:	502080e7          	jalr	1282(ra) # 586a <exit>
      int pid2 = fork();
    4370:	00001097          	auipc	ra,0x1
    4374:	4f2080e7          	jalr	1266(ra) # 5862 <fork>
      if(pid2 < 0){
    4378:	00054763          	bltz	a0,4386 <reparent+0x9c>
      exit(0);
    437c:	4501                	li	a0,0
    437e:	00001097          	auipc	ra,0x1
    4382:	4ec080e7          	jalr	1260(ra) # 586a <exit>
        kill(master_pid);
    4386:	8552                	mv	a0,s4
    4388:	00001097          	auipc	ra,0x1
    438c:	512080e7          	jalr	1298(ra) # 589a <kill>
        exit(1);
    4390:	4505                	li	a0,1
    4392:	00001097          	auipc	ra,0x1
    4396:	4d8080e7          	jalr	1240(ra) # 586a <exit>

000000000000439a <sbrkfail>:
{
    439a:	7119                	addi	sp,sp,-128
    439c:	fc86                	sd	ra,120(sp)
    439e:	f8a2                	sd	s0,112(sp)
    43a0:	f4a6                	sd	s1,104(sp)
    43a2:	f0ca                	sd	s2,96(sp)
    43a4:	ecce                	sd	s3,88(sp)
    43a6:	e8d2                	sd	s4,80(sp)
    43a8:	e4d6                	sd	s5,72(sp)
    43aa:	0100                	addi	s0,sp,128
    43ac:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    43ae:	fb040513          	addi	a0,s0,-80
    43b2:	00001097          	auipc	ra,0x1
    43b6:	4c8080e7          	jalr	1224(ra) # 587a <pipe>
    43ba:	e901                	bnez	a0,43ca <sbrkfail+0x30>
    43bc:	f8040493          	addi	s1,s0,-128
    43c0:	fa840a13          	addi	s4,s0,-88
    43c4:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    43c6:	5afd                	li	s5,-1
    43c8:	a08d                	j	442a <sbrkfail+0x90>
    printf("%s: pipe() failed\n", s);
    43ca:	85ca                	mv	a1,s2
    43cc:	00002517          	auipc	a0,0x2
    43d0:	69450513          	addi	a0,a0,1684 # 6a60 <malloc+0xdc0>
    43d4:	00002097          	auipc	ra,0x2
    43d8:	80e080e7          	jalr	-2034(ra) # 5be2 <printf>
    exit(1);
    43dc:	4505                	li	a0,1
    43de:	00001097          	auipc	ra,0x1
    43e2:	48c080e7          	jalr	1164(ra) # 586a <exit>
      sbrk(BIG - (uint64)sbrk(0));
    43e6:	4501                	li	a0,0
    43e8:	00001097          	auipc	ra,0x1
    43ec:	50a080e7          	jalr	1290(ra) # 58f2 <sbrk>
    43f0:	064007b7          	lui	a5,0x6400
    43f4:	40a7853b          	subw	a0,a5,a0
    43f8:	00001097          	auipc	ra,0x1
    43fc:	4fa080e7          	jalr	1274(ra) # 58f2 <sbrk>
      write(fds[1], "x", 1);
    4400:	4605                	li	a2,1
    4402:	00002597          	auipc	a1,0x2
    4406:	d8e58593          	addi	a1,a1,-626 # 6190 <malloc+0x4f0>
    440a:	fb442503          	lw	a0,-76(s0)
    440e:	00001097          	auipc	ra,0x1
    4412:	47c080e7          	jalr	1148(ra) # 588a <write>
      for(;;) sleep(1000);
    4416:	3e800513          	li	a0,1000
    441a:	00001097          	auipc	ra,0x1
    441e:	4e0080e7          	jalr	1248(ra) # 58fa <sleep>
    4422:	bfd5                	j	4416 <sbrkfail+0x7c>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4424:	0991                	addi	s3,s3,4
    4426:	03498563          	beq	s3,s4,4450 <sbrkfail+0xb6>
    if((pids[i] = fork()) == 0){
    442a:	00001097          	auipc	ra,0x1
    442e:	438080e7          	jalr	1080(ra) # 5862 <fork>
    4432:	00a9a023          	sw	a0,0(s3)
    4436:	d945                	beqz	a0,43e6 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4438:	ff5506e3          	beq	a0,s5,4424 <sbrkfail+0x8a>
      read(fds[0], &scratch, 1);
    443c:	4605                	li	a2,1
    443e:	faf40593          	addi	a1,s0,-81
    4442:	fb042503          	lw	a0,-80(s0)
    4446:	00001097          	auipc	ra,0x1
    444a:	43c080e7          	jalr	1084(ra) # 5882 <read>
    444e:	bfd9                	j	4424 <sbrkfail+0x8a>
  c = sbrk(PGSIZE);
    4450:	6505                	lui	a0,0x1
    4452:	00001097          	auipc	ra,0x1
    4456:	4a0080e7          	jalr	1184(ra) # 58f2 <sbrk>
    445a:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    445c:	5afd                	li	s5,-1
    445e:	a021                	j	4466 <sbrkfail+0xcc>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4460:	0491                	addi	s1,s1,4
    4462:	01448f63          	beq	s1,s4,4480 <sbrkfail+0xe6>
    if(pids[i] == -1)
    4466:	4088                	lw	a0,0(s1)
    4468:	ff550ce3          	beq	a0,s5,4460 <sbrkfail+0xc6>
    kill(pids[i]);
    446c:	00001097          	auipc	ra,0x1
    4470:	42e080e7          	jalr	1070(ra) # 589a <kill>
    wait(0);
    4474:	4501                	li	a0,0
    4476:	00001097          	auipc	ra,0x1
    447a:	3fc080e7          	jalr	1020(ra) # 5872 <wait>
    447e:	b7cd                	j	4460 <sbrkfail+0xc6>
  if(c == (char*)0xffffffffffffffffL){
    4480:	57fd                	li	a5,-1
    4482:	04f98163          	beq	s3,a5,44c4 <sbrkfail+0x12a>
  pid = fork();
    4486:	00001097          	auipc	ra,0x1
    448a:	3dc080e7          	jalr	988(ra) # 5862 <fork>
    448e:	84aa                	mv	s1,a0
  if(pid < 0){
    4490:	04054863          	bltz	a0,44e0 <sbrkfail+0x146>
  if(pid == 0){
    4494:	c525                	beqz	a0,44fc <sbrkfail+0x162>
  wait(&xstatus);
    4496:	fbc40513          	addi	a0,s0,-68
    449a:	00001097          	auipc	ra,0x1
    449e:	3d8080e7          	jalr	984(ra) # 5872 <wait>
  if(xstatus != -1 && xstatus != 2)
    44a2:	fbc42783          	lw	a5,-68(s0)
    44a6:	577d                	li	a4,-1
    44a8:	00e78563          	beq	a5,a4,44b2 <sbrkfail+0x118>
    44ac:	4709                	li	a4,2
    44ae:	08e79d63          	bne	a5,a4,4548 <sbrkfail+0x1ae>
}
    44b2:	70e6                	ld	ra,120(sp)
    44b4:	7446                	ld	s0,112(sp)
    44b6:	74a6                	ld	s1,104(sp)
    44b8:	7906                	ld	s2,96(sp)
    44ba:	69e6                	ld	s3,88(sp)
    44bc:	6a46                	ld	s4,80(sp)
    44be:	6aa6                	ld	s5,72(sp)
    44c0:	6109                	addi	sp,sp,128
    44c2:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    44c4:	85ca                	mv	a1,s2
    44c6:	00003517          	auipc	a0,0x3
    44ca:	78250513          	addi	a0,a0,1922 # 7c48 <malloc+0x1fa8>
    44ce:	00001097          	auipc	ra,0x1
    44d2:	714080e7          	jalr	1812(ra) # 5be2 <printf>
    exit(1);
    44d6:	4505                	li	a0,1
    44d8:	00001097          	auipc	ra,0x1
    44dc:	392080e7          	jalr	914(ra) # 586a <exit>
    printf("%s: fork failed\n", s);
    44e0:	85ca                	mv	a1,s2
    44e2:	00002517          	auipc	a0,0x2
    44e6:	47650513          	addi	a0,a0,1142 # 6958 <malloc+0xcb8>
    44ea:	00001097          	auipc	ra,0x1
    44ee:	6f8080e7          	jalr	1784(ra) # 5be2 <printf>
    exit(1);
    44f2:	4505                	li	a0,1
    44f4:	00001097          	auipc	ra,0x1
    44f8:	376080e7          	jalr	886(ra) # 586a <exit>
    a = sbrk(0);
    44fc:	4501                	li	a0,0
    44fe:	00001097          	auipc	ra,0x1
    4502:	3f4080e7          	jalr	1012(ra) # 58f2 <sbrk>
    4506:	89aa                	mv	s3,a0
    sbrk(10*BIG);
    4508:	3e800537          	lui	a0,0x3e800
    450c:	00001097          	auipc	ra,0x1
    4510:	3e6080e7          	jalr	998(ra) # 58f2 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4514:	874e                	mv	a4,s3
    4516:	3e8007b7          	lui	a5,0x3e800
    451a:	97ce                	add	a5,a5,s3
    451c:	6685                	lui	a3,0x1
      n += *(a+i);
    451e:	00074603          	lbu	a2,0(a4)
    4522:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4524:	9736                	add	a4,a4,a3
    4526:	fef71ce3          	bne	a4,a5,451e <sbrkfail+0x184>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    452a:	8626                	mv	a2,s1
    452c:	85ca                	mv	a1,s2
    452e:	00003517          	auipc	a0,0x3
    4532:	73a50513          	addi	a0,a0,1850 # 7c68 <malloc+0x1fc8>
    4536:	00001097          	auipc	ra,0x1
    453a:	6ac080e7          	jalr	1708(ra) # 5be2 <printf>
    exit(1);
    453e:	4505                	li	a0,1
    4540:	00001097          	auipc	ra,0x1
    4544:	32a080e7          	jalr	810(ra) # 586a <exit>
    exit(1);
    4548:	4505                	li	a0,1
    454a:	00001097          	auipc	ra,0x1
    454e:	320080e7          	jalr	800(ra) # 586a <exit>

0000000000004552 <mem>:
{
    4552:	7139                	addi	sp,sp,-64
    4554:	fc06                	sd	ra,56(sp)
    4556:	f822                	sd	s0,48(sp)
    4558:	f426                	sd	s1,40(sp)
    455a:	f04a                	sd	s2,32(sp)
    455c:	ec4e                	sd	s3,24(sp)
    455e:	0080                	addi	s0,sp,64
    4560:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4562:	00001097          	auipc	ra,0x1
    4566:	300080e7          	jalr	768(ra) # 5862 <fork>
    m1 = 0;
    456a:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    456c:	6909                	lui	s2,0x2
    456e:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0x93>
  if((pid = fork()) == 0){
    4572:	ed39                	bnez	a0,45d0 <mem+0x7e>
    while((m2 = malloc(10001)) != 0){
    4574:	854a                	mv	a0,s2
    4576:	00001097          	auipc	ra,0x1
    457a:	72a080e7          	jalr	1834(ra) # 5ca0 <malloc>
    457e:	c501                	beqz	a0,4586 <mem+0x34>
      *(char**)m2 = m1;
    4580:	e104                	sd	s1,0(a0)
      m1 = m2;
    4582:	84aa                	mv	s1,a0
    4584:	bfc5                	j	4574 <mem+0x22>
    while(m1){
    4586:	c881                	beqz	s1,4596 <mem+0x44>
      m2 = *(char**)m1;
    4588:	8526                	mv	a0,s1
    458a:	6084                	ld	s1,0(s1)
      free(m1);
    458c:	00001097          	auipc	ra,0x1
    4590:	68c080e7          	jalr	1676(ra) # 5c18 <free>
    while(m1){
    4594:	f8f5                	bnez	s1,4588 <mem+0x36>
    m1 = malloc(1024*20);
    4596:	6515                	lui	a0,0x5
    4598:	00001097          	auipc	ra,0x1
    459c:	708080e7          	jalr	1800(ra) # 5ca0 <malloc>
    if(m1 == 0){
    45a0:	c911                	beqz	a0,45b4 <mem+0x62>
    free(m1);
    45a2:	00001097          	auipc	ra,0x1
    45a6:	676080e7          	jalr	1654(ra) # 5c18 <free>
    exit(0);
    45aa:	4501                	li	a0,0
    45ac:	00001097          	auipc	ra,0x1
    45b0:	2be080e7          	jalr	702(ra) # 586a <exit>
      printf("couldn't allocate mem?!!\n", s);
    45b4:	85ce                	mv	a1,s3
    45b6:	00003517          	auipc	a0,0x3
    45ba:	6e250513          	addi	a0,a0,1762 # 7c98 <malloc+0x1ff8>
    45be:	00001097          	auipc	ra,0x1
    45c2:	624080e7          	jalr	1572(ra) # 5be2 <printf>
      exit(1);
    45c6:	4505                	li	a0,1
    45c8:	00001097          	auipc	ra,0x1
    45cc:	2a2080e7          	jalr	674(ra) # 586a <exit>
    wait(&xstatus);
    45d0:	fcc40513          	addi	a0,s0,-52
    45d4:	00001097          	auipc	ra,0x1
    45d8:	29e080e7          	jalr	670(ra) # 5872 <wait>
    if(xstatus == -1){
    45dc:	fcc42503          	lw	a0,-52(s0)
    45e0:	57fd                	li	a5,-1
    45e2:	00f50663          	beq	a0,a5,45ee <mem+0x9c>
    exit(xstatus);
    45e6:	00001097          	auipc	ra,0x1
    45ea:	284080e7          	jalr	644(ra) # 586a <exit>
      exit(0);
    45ee:	4501                	li	a0,0
    45f0:	00001097          	auipc	ra,0x1
    45f4:	27a080e7          	jalr	634(ra) # 586a <exit>

00000000000045f8 <sharedfd>:
{
    45f8:	7159                	addi	sp,sp,-112
    45fa:	f486                	sd	ra,104(sp)
    45fc:	f0a2                	sd	s0,96(sp)
    45fe:	eca6                	sd	s1,88(sp)
    4600:	e8ca                	sd	s2,80(sp)
    4602:	e4ce                	sd	s3,72(sp)
    4604:	e0d2                	sd	s4,64(sp)
    4606:	fc56                	sd	s5,56(sp)
    4608:	f85a                	sd	s6,48(sp)
    460a:	f45e                	sd	s7,40(sp)
    460c:	1880                	addi	s0,sp,112
    460e:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4610:	00002517          	auipc	a0,0x2
    4614:	92050513          	addi	a0,a0,-1760 # 5f30 <malloc+0x290>
    4618:	00001097          	auipc	ra,0x1
    461c:	2a2080e7          	jalr	674(ra) # 58ba <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4620:	20200593          	li	a1,514
    4624:	00002517          	auipc	a0,0x2
    4628:	90c50513          	addi	a0,a0,-1780 # 5f30 <malloc+0x290>
    462c:	00001097          	auipc	ra,0x1
    4630:	27e080e7          	jalr	638(ra) # 58aa <open>
  if(fd < 0){
    4634:	04054a63          	bltz	a0,4688 <sharedfd+0x90>
    4638:	892a                	mv	s2,a0
  pid = fork();
    463a:	00001097          	auipc	ra,0x1
    463e:	228080e7          	jalr	552(ra) # 5862 <fork>
    4642:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4644:	06300593          	li	a1,99
    4648:	c119                	beqz	a0,464e <sharedfd+0x56>
    464a:	07000593          	li	a1,112
    464e:	4629                	li	a2,10
    4650:	fa040513          	addi	a0,s0,-96
    4654:	00001097          	auipc	ra,0x1
    4658:	012080e7          	jalr	18(ra) # 5666 <memset>
    465c:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4660:	4629                	li	a2,10
    4662:	fa040593          	addi	a1,s0,-96
    4666:	854a                	mv	a0,s2
    4668:	00001097          	auipc	ra,0x1
    466c:	222080e7          	jalr	546(ra) # 588a <write>
    4670:	47a9                	li	a5,10
    4672:	02f51963          	bne	a0,a5,46a4 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4676:	34fd                	addiw	s1,s1,-1
    4678:	f4e5                	bnez	s1,4660 <sharedfd+0x68>
  if(pid == 0) {
    467a:	04099363          	bnez	s3,46c0 <sharedfd+0xc8>
    exit(0);
    467e:	4501                	li	a0,0
    4680:	00001097          	auipc	ra,0x1
    4684:	1ea080e7          	jalr	490(ra) # 586a <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4688:	85d2                	mv	a1,s4
    468a:	00003517          	auipc	a0,0x3
    468e:	62e50513          	addi	a0,a0,1582 # 7cb8 <malloc+0x2018>
    4692:	00001097          	auipc	ra,0x1
    4696:	550080e7          	jalr	1360(ra) # 5be2 <printf>
    exit(1);
    469a:	4505                	li	a0,1
    469c:	00001097          	auipc	ra,0x1
    46a0:	1ce080e7          	jalr	462(ra) # 586a <exit>
      printf("%s: write sharedfd failed\n", s);
    46a4:	85d2                	mv	a1,s4
    46a6:	00003517          	auipc	a0,0x3
    46aa:	63a50513          	addi	a0,a0,1594 # 7ce0 <malloc+0x2040>
    46ae:	00001097          	auipc	ra,0x1
    46b2:	534080e7          	jalr	1332(ra) # 5be2 <printf>
      exit(1);
    46b6:	4505                	li	a0,1
    46b8:	00001097          	auipc	ra,0x1
    46bc:	1b2080e7          	jalr	434(ra) # 586a <exit>
    wait(&xstatus);
    46c0:	f9c40513          	addi	a0,s0,-100
    46c4:	00001097          	auipc	ra,0x1
    46c8:	1ae080e7          	jalr	430(ra) # 5872 <wait>
    if(xstatus != 0)
    46cc:	f9c42983          	lw	s3,-100(s0)
    46d0:	00098763          	beqz	s3,46de <sharedfd+0xe6>
      exit(xstatus);
    46d4:	854e                	mv	a0,s3
    46d6:	00001097          	auipc	ra,0x1
    46da:	194080e7          	jalr	404(ra) # 586a <exit>
  close(fd);
    46de:	854a                	mv	a0,s2
    46e0:	00001097          	auipc	ra,0x1
    46e4:	1b2080e7          	jalr	434(ra) # 5892 <close>
  fd = open("sharedfd", 0);
    46e8:	4581                	li	a1,0
    46ea:	00002517          	auipc	a0,0x2
    46ee:	84650513          	addi	a0,a0,-1978 # 5f30 <malloc+0x290>
    46f2:	00001097          	auipc	ra,0x1
    46f6:	1b8080e7          	jalr	440(ra) # 58aa <open>
    46fa:	8baa                	mv	s7,a0
  nc = np = 0;
    46fc:	8ace                	mv	s5,s3
  if(fd < 0){
    46fe:	02054563          	bltz	a0,4728 <sharedfd+0x130>
    4702:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4706:	06300493          	li	s1,99
      if(buf[i] == 'p')
    470a:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    470e:	4629                	li	a2,10
    4710:	fa040593          	addi	a1,s0,-96
    4714:	855e                	mv	a0,s7
    4716:	00001097          	auipc	ra,0x1
    471a:	16c080e7          	jalr	364(ra) # 5882 <read>
    471e:	02a05f63          	blez	a0,475c <sharedfd+0x164>
    4722:	fa040793          	addi	a5,s0,-96
    4726:	a01d                	j	474c <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4728:	85d2                	mv	a1,s4
    472a:	00003517          	auipc	a0,0x3
    472e:	5d650513          	addi	a0,a0,1494 # 7d00 <malloc+0x2060>
    4732:	00001097          	auipc	ra,0x1
    4736:	4b0080e7          	jalr	1200(ra) # 5be2 <printf>
    exit(1);
    473a:	4505                	li	a0,1
    473c:	00001097          	auipc	ra,0x1
    4740:	12e080e7          	jalr	302(ra) # 586a <exit>
        nc++;
    4744:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4746:	0785                	addi	a5,a5,1
    4748:	fd2783e3          	beq	a5,s2,470e <sharedfd+0x116>
      if(buf[i] == 'c')
    474c:	0007c703          	lbu	a4,0(a5) # 3e800000 <__BSS_END__+0x3e7f1248>
    4750:	fe970ae3          	beq	a4,s1,4744 <sharedfd+0x14c>
      if(buf[i] == 'p')
    4754:	ff6719e3          	bne	a4,s6,4746 <sharedfd+0x14e>
        np++;
    4758:	2a85                	addiw	s5,s5,1
    475a:	b7f5                	j	4746 <sharedfd+0x14e>
  close(fd);
    475c:	855e                	mv	a0,s7
    475e:	00001097          	auipc	ra,0x1
    4762:	134080e7          	jalr	308(ra) # 5892 <close>
  unlink("sharedfd");
    4766:	00001517          	auipc	a0,0x1
    476a:	7ca50513          	addi	a0,a0,1994 # 5f30 <malloc+0x290>
    476e:	00001097          	auipc	ra,0x1
    4772:	14c080e7          	jalr	332(ra) # 58ba <unlink>
  if(nc == N*SZ && np == N*SZ){
    4776:	6789                	lui	a5,0x2
    4778:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x92>
    477c:	00f99763          	bne	s3,a5,478a <sharedfd+0x192>
    4780:	6789                	lui	a5,0x2
    4782:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x92>
    4786:	02fa8063          	beq	s5,a5,47a6 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    478a:	85d2                	mv	a1,s4
    478c:	00003517          	auipc	a0,0x3
    4790:	59c50513          	addi	a0,a0,1436 # 7d28 <malloc+0x2088>
    4794:	00001097          	auipc	ra,0x1
    4798:	44e080e7          	jalr	1102(ra) # 5be2 <printf>
    exit(1);
    479c:	4505                	li	a0,1
    479e:	00001097          	auipc	ra,0x1
    47a2:	0cc080e7          	jalr	204(ra) # 586a <exit>
    exit(0);
    47a6:	4501                	li	a0,0
    47a8:	00001097          	auipc	ra,0x1
    47ac:	0c2080e7          	jalr	194(ra) # 586a <exit>

00000000000047b0 <fourfiles>:
{
    47b0:	7171                	addi	sp,sp,-176
    47b2:	f506                	sd	ra,168(sp)
    47b4:	f122                	sd	s0,160(sp)
    47b6:	ed26                	sd	s1,152(sp)
    47b8:	e94a                	sd	s2,144(sp)
    47ba:	e54e                	sd	s3,136(sp)
    47bc:	e152                	sd	s4,128(sp)
    47be:	fcd6                	sd	s5,120(sp)
    47c0:	f8da                	sd	s6,112(sp)
    47c2:	f4de                	sd	s7,104(sp)
    47c4:	f0e2                	sd	s8,96(sp)
    47c6:	ece6                	sd	s9,88(sp)
    47c8:	e8ea                	sd	s10,80(sp)
    47ca:	e4ee                	sd	s11,72(sp)
    47cc:	1900                	addi	s0,sp,176
    47ce:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    47d0:	00001797          	auipc	a5,0x1
    47d4:	5b878793          	addi	a5,a5,1464 # 5d88 <malloc+0xe8>
    47d8:	f6f43823          	sd	a5,-144(s0)
    47dc:	00001797          	auipc	a5,0x1
    47e0:	5b478793          	addi	a5,a5,1460 # 5d90 <malloc+0xf0>
    47e4:	f6f43c23          	sd	a5,-136(s0)
    47e8:	00001797          	auipc	a5,0x1
    47ec:	5b078793          	addi	a5,a5,1456 # 5d98 <malloc+0xf8>
    47f0:	f8f43023          	sd	a5,-128(s0)
    47f4:	00001797          	auipc	a5,0x1
    47f8:	5ac78793          	addi	a5,a5,1452 # 5da0 <malloc+0x100>
    47fc:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4800:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4804:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4806:	4481                	li	s1,0
    4808:	4a11                	li	s4,4
    fname = names[pi];
    480a:	00093983          	ld	s3,0(s2)
    unlink(fname);
    480e:	854e                	mv	a0,s3
    4810:	00001097          	auipc	ra,0x1
    4814:	0aa080e7          	jalr	170(ra) # 58ba <unlink>
    pid = fork();
    4818:	00001097          	auipc	ra,0x1
    481c:	04a080e7          	jalr	74(ra) # 5862 <fork>
    if(pid < 0){
    4820:	04054563          	bltz	a0,486a <fourfiles+0xba>
    if(pid == 0){
    4824:	c12d                	beqz	a0,4886 <fourfiles+0xd6>
  for(pi = 0; pi < NCHILD; pi++){
    4826:	2485                	addiw	s1,s1,1
    4828:	0921                	addi	s2,s2,8
    482a:	ff4490e3          	bne	s1,s4,480a <fourfiles+0x5a>
    482e:	4491                	li	s1,4
    wait(&xstatus);
    4830:	f6c40513          	addi	a0,s0,-148
    4834:	00001097          	auipc	ra,0x1
    4838:	03e080e7          	jalr	62(ra) # 5872 <wait>
    if(xstatus != 0)
    483c:	f6c42503          	lw	a0,-148(s0)
    4840:	ed69                	bnez	a0,491a <fourfiles+0x16a>
  for(pi = 0; pi < NCHILD; pi++){
    4842:	34fd                	addiw	s1,s1,-1
    4844:	f4f5                	bnez	s1,4830 <fourfiles+0x80>
    4846:	03000b13          	li	s6,48
    total = 0;
    484a:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    484e:	00007a17          	auipc	s4,0x7
    4852:	55aa0a13          	addi	s4,s4,1370 # bda8 <buf>
    4856:	00007a97          	auipc	s5,0x7
    485a:	553a8a93          	addi	s5,s5,1363 # bda9 <buf+0x1>
    if(total != N*SZ){
    485e:	6d05                	lui	s10,0x1
    4860:	770d0d13          	addi	s10,s10,1904 # 1770 <pipe1+0x1a>
  for(i = 0; i < NCHILD; i++){
    4864:	03400d93          	li	s11,52
    4868:	a23d                	j	4996 <fourfiles+0x1e6>
      printf("fork failed\n", s);
    486a:	85e6                	mv	a1,s9
    486c:	00002517          	auipc	a0,0x2
    4870:	50c50513          	addi	a0,a0,1292 # 6d78 <malloc+0x10d8>
    4874:	00001097          	auipc	ra,0x1
    4878:	36e080e7          	jalr	878(ra) # 5be2 <printf>
      exit(1);
    487c:	4505                	li	a0,1
    487e:	00001097          	auipc	ra,0x1
    4882:	fec080e7          	jalr	-20(ra) # 586a <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4886:	20200593          	li	a1,514
    488a:	854e                	mv	a0,s3
    488c:	00001097          	auipc	ra,0x1
    4890:	01e080e7          	jalr	30(ra) # 58aa <open>
    4894:	892a                	mv	s2,a0
      if(fd < 0){
    4896:	04054763          	bltz	a0,48e4 <fourfiles+0x134>
      memset(buf, '0'+pi, SZ);
    489a:	1f400613          	li	a2,500
    489e:	0304859b          	addiw	a1,s1,48
    48a2:	00007517          	auipc	a0,0x7
    48a6:	50650513          	addi	a0,a0,1286 # bda8 <buf>
    48aa:	00001097          	auipc	ra,0x1
    48ae:	dbc080e7          	jalr	-580(ra) # 5666 <memset>
    48b2:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    48b4:	00007997          	auipc	s3,0x7
    48b8:	4f498993          	addi	s3,s3,1268 # bda8 <buf>
    48bc:	1f400613          	li	a2,500
    48c0:	85ce                	mv	a1,s3
    48c2:	854a                	mv	a0,s2
    48c4:	00001097          	auipc	ra,0x1
    48c8:	fc6080e7          	jalr	-58(ra) # 588a <write>
    48cc:	85aa                	mv	a1,a0
    48ce:	1f400793          	li	a5,500
    48d2:	02f51763          	bne	a0,a5,4900 <fourfiles+0x150>
      for(i = 0; i < N; i++){
    48d6:	34fd                	addiw	s1,s1,-1
    48d8:	f0f5                	bnez	s1,48bc <fourfiles+0x10c>
      exit(0);
    48da:	4501                	li	a0,0
    48dc:	00001097          	auipc	ra,0x1
    48e0:	f8e080e7          	jalr	-114(ra) # 586a <exit>
        printf("create failed\n", s);
    48e4:	85e6                	mv	a1,s9
    48e6:	00003517          	auipc	a0,0x3
    48ea:	45a50513          	addi	a0,a0,1114 # 7d40 <malloc+0x20a0>
    48ee:	00001097          	auipc	ra,0x1
    48f2:	2f4080e7          	jalr	756(ra) # 5be2 <printf>
        exit(1);
    48f6:	4505                	li	a0,1
    48f8:	00001097          	auipc	ra,0x1
    48fc:	f72080e7          	jalr	-142(ra) # 586a <exit>
          printf("write failed %d\n", n);
    4900:	00003517          	auipc	a0,0x3
    4904:	45050513          	addi	a0,a0,1104 # 7d50 <malloc+0x20b0>
    4908:	00001097          	auipc	ra,0x1
    490c:	2da080e7          	jalr	730(ra) # 5be2 <printf>
          exit(1);
    4910:	4505                	li	a0,1
    4912:	00001097          	auipc	ra,0x1
    4916:	f58080e7          	jalr	-168(ra) # 586a <exit>
      exit(xstatus);
    491a:	00001097          	auipc	ra,0x1
    491e:	f50080e7          	jalr	-176(ra) # 586a <exit>
          printf("wrong char\n", s);
    4922:	85e6                	mv	a1,s9
    4924:	00003517          	auipc	a0,0x3
    4928:	44450513          	addi	a0,a0,1092 # 7d68 <malloc+0x20c8>
    492c:	00001097          	auipc	ra,0x1
    4930:	2b6080e7          	jalr	694(ra) # 5be2 <printf>
          exit(1);
    4934:	4505                	li	a0,1
    4936:	00001097          	auipc	ra,0x1
    493a:	f34080e7          	jalr	-204(ra) # 586a <exit>
      total += n;
    493e:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4942:	660d                	lui	a2,0x3
    4944:	85d2                	mv	a1,s4
    4946:	854e                	mv	a0,s3
    4948:	00001097          	auipc	ra,0x1
    494c:	f3a080e7          	jalr	-198(ra) # 5882 <read>
    4950:	02a05363          	blez	a0,4976 <fourfiles+0x1c6>
    4954:	00007797          	auipc	a5,0x7
    4958:	45478793          	addi	a5,a5,1108 # bda8 <buf>
    495c:	fff5069b          	addiw	a3,a0,-1
    4960:	1682                	slli	a3,a3,0x20
    4962:	9281                	srli	a3,a3,0x20
    4964:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    4966:	0007c703          	lbu	a4,0(a5)
    496a:	fa971ce3          	bne	a4,s1,4922 <fourfiles+0x172>
      for(j = 0; j < n; j++){
    496e:	0785                	addi	a5,a5,1
    4970:	fed79be3          	bne	a5,a3,4966 <fourfiles+0x1b6>
    4974:	b7e9                	j	493e <fourfiles+0x18e>
    close(fd);
    4976:	854e                	mv	a0,s3
    4978:	00001097          	auipc	ra,0x1
    497c:	f1a080e7          	jalr	-230(ra) # 5892 <close>
    if(total != N*SZ){
    4980:	03a91963          	bne	s2,s10,49b2 <fourfiles+0x202>
    unlink(fname);
    4984:	8562                	mv	a0,s8
    4986:	00001097          	auipc	ra,0x1
    498a:	f34080e7          	jalr	-204(ra) # 58ba <unlink>
  for(i = 0; i < NCHILD; i++){
    498e:	0ba1                	addi	s7,s7,8
    4990:	2b05                	addiw	s6,s6,1
    4992:	03bb0e63          	beq	s6,s11,49ce <fourfiles+0x21e>
    fname = names[i];
    4996:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    499a:	4581                	li	a1,0
    499c:	8562                	mv	a0,s8
    499e:	00001097          	auipc	ra,0x1
    49a2:	f0c080e7          	jalr	-244(ra) # 58aa <open>
    49a6:	89aa                	mv	s3,a0
    total = 0;
    49a8:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    49ac:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    49b0:	bf49                	j	4942 <fourfiles+0x192>
      printf("wrong length %d\n", total);
    49b2:	85ca                	mv	a1,s2
    49b4:	00003517          	auipc	a0,0x3
    49b8:	3c450513          	addi	a0,a0,964 # 7d78 <malloc+0x20d8>
    49bc:	00001097          	auipc	ra,0x1
    49c0:	226080e7          	jalr	550(ra) # 5be2 <printf>
      exit(1);
    49c4:	4505                	li	a0,1
    49c6:	00001097          	auipc	ra,0x1
    49ca:	ea4080e7          	jalr	-348(ra) # 586a <exit>
}
    49ce:	70aa                	ld	ra,168(sp)
    49d0:	740a                	ld	s0,160(sp)
    49d2:	64ea                	ld	s1,152(sp)
    49d4:	694a                	ld	s2,144(sp)
    49d6:	69aa                	ld	s3,136(sp)
    49d8:	6a0a                	ld	s4,128(sp)
    49da:	7ae6                	ld	s5,120(sp)
    49dc:	7b46                	ld	s6,112(sp)
    49de:	7ba6                	ld	s7,104(sp)
    49e0:	7c06                	ld	s8,96(sp)
    49e2:	6ce6                	ld	s9,88(sp)
    49e4:	6d46                	ld	s10,80(sp)
    49e6:	6da6                	ld	s11,72(sp)
    49e8:	614d                	addi	sp,sp,176
    49ea:	8082                	ret

00000000000049ec <concreate>:
{
    49ec:	7135                	addi	sp,sp,-160
    49ee:	ed06                	sd	ra,152(sp)
    49f0:	e922                	sd	s0,144(sp)
    49f2:	e526                	sd	s1,136(sp)
    49f4:	e14a                	sd	s2,128(sp)
    49f6:	fcce                	sd	s3,120(sp)
    49f8:	f8d2                	sd	s4,112(sp)
    49fa:	f4d6                	sd	s5,104(sp)
    49fc:	f0da                	sd	s6,96(sp)
    49fe:	ecde                	sd	s7,88(sp)
    4a00:	1100                	addi	s0,sp,160
    4a02:	89aa                	mv	s3,a0
  file[0] = 'C';
    4a04:	04300793          	li	a5,67
    4a08:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4a0c:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4a10:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4a12:	4b0d                	li	s6,3
    4a14:	4a85                	li	s5,1
      link("C0", file);
    4a16:	00003b97          	auipc	s7,0x3
    4a1a:	37ab8b93          	addi	s7,s7,890 # 7d90 <malloc+0x20f0>
  for(i = 0; i < N; i++){
    4a1e:	02800a13          	li	s4,40
    4a22:	acc1                	j	4cf2 <concreate+0x306>
      link("C0", file);
    4a24:	fa840593          	addi	a1,s0,-88
    4a28:	855e                	mv	a0,s7
    4a2a:	00001097          	auipc	ra,0x1
    4a2e:	ea0080e7          	jalr	-352(ra) # 58ca <link>
    if(pid == 0) {
    4a32:	a45d                	j	4cd8 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4a34:	4795                	li	a5,5
    4a36:	02f9693b          	remw	s2,s2,a5
    4a3a:	4785                	li	a5,1
    4a3c:	02f90b63          	beq	s2,a5,4a72 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4a40:	20200593          	li	a1,514
    4a44:	fa840513          	addi	a0,s0,-88
    4a48:	00001097          	auipc	ra,0x1
    4a4c:	e62080e7          	jalr	-414(ra) # 58aa <open>
      if(fd < 0){
    4a50:	26055b63          	bgez	a0,4cc6 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4a54:	fa840593          	addi	a1,s0,-88
    4a58:	00003517          	auipc	a0,0x3
    4a5c:	34050513          	addi	a0,a0,832 # 7d98 <malloc+0x20f8>
    4a60:	00001097          	auipc	ra,0x1
    4a64:	182080e7          	jalr	386(ra) # 5be2 <printf>
        exit(1);
    4a68:	4505                	li	a0,1
    4a6a:	00001097          	auipc	ra,0x1
    4a6e:	e00080e7          	jalr	-512(ra) # 586a <exit>
      link("C0", file);
    4a72:	fa840593          	addi	a1,s0,-88
    4a76:	00003517          	auipc	a0,0x3
    4a7a:	31a50513          	addi	a0,a0,794 # 7d90 <malloc+0x20f0>
    4a7e:	00001097          	auipc	ra,0x1
    4a82:	e4c080e7          	jalr	-436(ra) # 58ca <link>
      exit(0);
    4a86:	4501                	li	a0,0
    4a88:	00001097          	auipc	ra,0x1
    4a8c:	de2080e7          	jalr	-542(ra) # 586a <exit>
        exit(1);
    4a90:	4505                	li	a0,1
    4a92:	00001097          	auipc	ra,0x1
    4a96:	dd8080e7          	jalr	-552(ra) # 586a <exit>
  memset(fa, 0, sizeof(fa));
    4a9a:	02800613          	li	a2,40
    4a9e:	4581                	li	a1,0
    4aa0:	f8040513          	addi	a0,s0,-128
    4aa4:	00001097          	auipc	ra,0x1
    4aa8:	bc2080e7          	jalr	-1086(ra) # 5666 <memset>
  fd = open(".", 0);
    4aac:	4581                	li	a1,0
    4aae:	00002517          	auipc	a0,0x2
    4ab2:	d0a50513          	addi	a0,a0,-758 # 67b8 <malloc+0xb18>
    4ab6:	00001097          	auipc	ra,0x1
    4aba:	df4080e7          	jalr	-524(ra) # 58aa <open>
    4abe:	892a                	mv	s2,a0
  n = 0;
    4ac0:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4ac2:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4ac6:	02700b13          	li	s6,39
      fa[i] = 1;
    4aca:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4acc:	a03d                	j	4afa <concreate+0x10e>
        printf("%s: concreate weird file %s\n", s, de.name);
    4ace:	f7240613          	addi	a2,s0,-142
    4ad2:	85ce                	mv	a1,s3
    4ad4:	00003517          	auipc	a0,0x3
    4ad8:	2e450513          	addi	a0,a0,740 # 7db8 <malloc+0x2118>
    4adc:	00001097          	auipc	ra,0x1
    4ae0:	106080e7          	jalr	262(ra) # 5be2 <printf>
        exit(1);
    4ae4:	4505                	li	a0,1
    4ae6:	00001097          	auipc	ra,0x1
    4aea:	d84080e7          	jalr	-636(ra) # 586a <exit>
      fa[i] = 1;
    4aee:	fb040793          	addi	a5,s0,-80
    4af2:	973e                	add	a4,a4,a5
    4af4:	fd770823          	sb	s7,-48(a4)
      n++;
    4af8:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    4afa:	4641                	li	a2,16
    4afc:	f7040593          	addi	a1,s0,-144
    4b00:	854a                	mv	a0,s2
    4b02:	00001097          	auipc	ra,0x1
    4b06:	d80080e7          	jalr	-640(ra) # 5882 <read>
    4b0a:	04a05a63          	blez	a0,4b5e <concreate+0x172>
    if(de.inum == 0)
    4b0e:	f7045783          	lhu	a5,-144(s0)
    4b12:	d7e5                	beqz	a5,4afa <concreate+0x10e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4b14:	f7244783          	lbu	a5,-142(s0)
    4b18:	ff4791e3          	bne	a5,s4,4afa <concreate+0x10e>
    4b1c:	f7444783          	lbu	a5,-140(s0)
    4b20:	ffe9                	bnez	a5,4afa <concreate+0x10e>
      i = de.name[1] - '0';
    4b22:	f7344783          	lbu	a5,-141(s0)
    4b26:	fd07879b          	addiw	a5,a5,-48
    4b2a:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4b2e:	faeb60e3          	bltu	s6,a4,4ace <concreate+0xe2>
      if(fa[i]){
    4b32:	fb040793          	addi	a5,s0,-80
    4b36:	97ba                	add	a5,a5,a4
    4b38:	fd07c783          	lbu	a5,-48(a5)
    4b3c:	dbcd                	beqz	a5,4aee <concreate+0x102>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4b3e:	f7240613          	addi	a2,s0,-142
    4b42:	85ce                	mv	a1,s3
    4b44:	00003517          	auipc	a0,0x3
    4b48:	29450513          	addi	a0,a0,660 # 7dd8 <malloc+0x2138>
    4b4c:	00001097          	auipc	ra,0x1
    4b50:	096080e7          	jalr	150(ra) # 5be2 <printf>
        exit(1);
    4b54:	4505                	li	a0,1
    4b56:	00001097          	auipc	ra,0x1
    4b5a:	d14080e7          	jalr	-748(ra) # 586a <exit>
  close(fd);
    4b5e:	854a                	mv	a0,s2
    4b60:	00001097          	auipc	ra,0x1
    4b64:	d32080e7          	jalr	-718(ra) # 5892 <close>
  if(n != N){
    4b68:	02800793          	li	a5,40
    4b6c:	00fa9763          	bne	s5,a5,4b7a <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    4b70:	4a8d                	li	s5,3
    4b72:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4b74:	02800a13          	li	s4,40
    4b78:	a8c9                	j	4c4a <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    4b7a:	85ce                	mv	a1,s3
    4b7c:	00003517          	auipc	a0,0x3
    4b80:	28450513          	addi	a0,a0,644 # 7e00 <malloc+0x2160>
    4b84:	00001097          	auipc	ra,0x1
    4b88:	05e080e7          	jalr	94(ra) # 5be2 <printf>
    exit(1);
    4b8c:	4505                	li	a0,1
    4b8e:	00001097          	auipc	ra,0x1
    4b92:	cdc080e7          	jalr	-804(ra) # 586a <exit>
      printf("%s: fork failed\n", s);
    4b96:	85ce                	mv	a1,s3
    4b98:	00002517          	auipc	a0,0x2
    4b9c:	dc050513          	addi	a0,a0,-576 # 6958 <malloc+0xcb8>
    4ba0:	00001097          	auipc	ra,0x1
    4ba4:	042080e7          	jalr	66(ra) # 5be2 <printf>
      exit(1);
    4ba8:	4505                	li	a0,1
    4baa:	00001097          	auipc	ra,0x1
    4bae:	cc0080e7          	jalr	-832(ra) # 586a <exit>
      close(open(file, 0));
    4bb2:	4581                	li	a1,0
    4bb4:	fa840513          	addi	a0,s0,-88
    4bb8:	00001097          	auipc	ra,0x1
    4bbc:	cf2080e7          	jalr	-782(ra) # 58aa <open>
    4bc0:	00001097          	auipc	ra,0x1
    4bc4:	cd2080e7          	jalr	-814(ra) # 5892 <close>
      close(open(file, 0));
    4bc8:	4581                	li	a1,0
    4bca:	fa840513          	addi	a0,s0,-88
    4bce:	00001097          	auipc	ra,0x1
    4bd2:	cdc080e7          	jalr	-804(ra) # 58aa <open>
    4bd6:	00001097          	auipc	ra,0x1
    4bda:	cbc080e7          	jalr	-836(ra) # 5892 <close>
      close(open(file, 0));
    4bde:	4581                	li	a1,0
    4be0:	fa840513          	addi	a0,s0,-88
    4be4:	00001097          	auipc	ra,0x1
    4be8:	cc6080e7          	jalr	-826(ra) # 58aa <open>
    4bec:	00001097          	auipc	ra,0x1
    4bf0:	ca6080e7          	jalr	-858(ra) # 5892 <close>
      close(open(file, 0));
    4bf4:	4581                	li	a1,0
    4bf6:	fa840513          	addi	a0,s0,-88
    4bfa:	00001097          	auipc	ra,0x1
    4bfe:	cb0080e7          	jalr	-848(ra) # 58aa <open>
    4c02:	00001097          	auipc	ra,0x1
    4c06:	c90080e7          	jalr	-880(ra) # 5892 <close>
      close(open(file, 0));
    4c0a:	4581                	li	a1,0
    4c0c:	fa840513          	addi	a0,s0,-88
    4c10:	00001097          	auipc	ra,0x1
    4c14:	c9a080e7          	jalr	-870(ra) # 58aa <open>
    4c18:	00001097          	auipc	ra,0x1
    4c1c:	c7a080e7          	jalr	-902(ra) # 5892 <close>
      close(open(file, 0));
    4c20:	4581                	li	a1,0
    4c22:	fa840513          	addi	a0,s0,-88
    4c26:	00001097          	auipc	ra,0x1
    4c2a:	c84080e7          	jalr	-892(ra) # 58aa <open>
    4c2e:	00001097          	auipc	ra,0x1
    4c32:	c64080e7          	jalr	-924(ra) # 5892 <close>
    if(pid == 0)
    4c36:	08090363          	beqz	s2,4cbc <concreate+0x2d0>
      wait(0);
    4c3a:	4501                	li	a0,0
    4c3c:	00001097          	auipc	ra,0x1
    4c40:	c36080e7          	jalr	-970(ra) # 5872 <wait>
  for(i = 0; i < N; i++){
    4c44:	2485                	addiw	s1,s1,1
    4c46:	0f448563          	beq	s1,s4,4d30 <concreate+0x344>
    file[1] = '0' + i;
    4c4a:	0304879b          	addiw	a5,s1,48
    4c4e:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4c52:	00001097          	auipc	ra,0x1
    4c56:	c10080e7          	jalr	-1008(ra) # 5862 <fork>
    4c5a:	892a                	mv	s2,a0
    if(pid < 0){
    4c5c:	f2054de3          	bltz	a0,4b96 <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    4c60:	0354e73b          	remw	a4,s1,s5
    4c64:	00a767b3          	or	a5,a4,a0
    4c68:	2781                	sext.w	a5,a5
    4c6a:	d7a1                	beqz	a5,4bb2 <concreate+0x1c6>
    4c6c:	01671363          	bne	a4,s6,4c72 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    4c70:	f129                	bnez	a0,4bb2 <concreate+0x1c6>
      unlink(file);
    4c72:	fa840513          	addi	a0,s0,-88
    4c76:	00001097          	auipc	ra,0x1
    4c7a:	c44080e7          	jalr	-956(ra) # 58ba <unlink>
      unlink(file);
    4c7e:	fa840513          	addi	a0,s0,-88
    4c82:	00001097          	auipc	ra,0x1
    4c86:	c38080e7          	jalr	-968(ra) # 58ba <unlink>
      unlink(file);
    4c8a:	fa840513          	addi	a0,s0,-88
    4c8e:	00001097          	auipc	ra,0x1
    4c92:	c2c080e7          	jalr	-980(ra) # 58ba <unlink>
      unlink(file);
    4c96:	fa840513          	addi	a0,s0,-88
    4c9a:	00001097          	auipc	ra,0x1
    4c9e:	c20080e7          	jalr	-992(ra) # 58ba <unlink>
      unlink(file);
    4ca2:	fa840513          	addi	a0,s0,-88
    4ca6:	00001097          	auipc	ra,0x1
    4caa:	c14080e7          	jalr	-1004(ra) # 58ba <unlink>
      unlink(file);
    4cae:	fa840513          	addi	a0,s0,-88
    4cb2:	00001097          	auipc	ra,0x1
    4cb6:	c08080e7          	jalr	-1016(ra) # 58ba <unlink>
    4cba:	bfb5                	j	4c36 <concreate+0x24a>
      exit(0);
    4cbc:	4501                	li	a0,0
    4cbe:	00001097          	auipc	ra,0x1
    4cc2:	bac080e7          	jalr	-1108(ra) # 586a <exit>
      close(fd);
    4cc6:	00001097          	auipc	ra,0x1
    4cca:	bcc080e7          	jalr	-1076(ra) # 5892 <close>
    if(pid == 0) {
    4cce:	bb65                	j	4a86 <concreate+0x9a>
      close(fd);
    4cd0:	00001097          	auipc	ra,0x1
    4cd4:	bc2080e7          	jalr	-1086(ra) # 5892 <close>
      wait(&xstatus);
    4cd8:	f6c40513          	addi	a0,s0,-148
    4cdc:	00001097          	auipc	ra,0x1
    4ce0:	b96080e7          	jalr	-1130(ra) # 5872 <wait>
      if(xstatus != 0)
    4ce4:	f6c42483          	lw	s1,-148(s0)
    4ce8:	da0494e3          	bnez	s1,4a90 <concreate+0xa4>
  for(i = 0; i < N; i++){
    4cec:	2905                	addiw	s2,s2,1
    4cee:	db4906e3          	beq	s2,s4,4a9a <concreate+0xae>
    file[1] = '0' + i;
    4cf2:	0309079b          	addiw	a5,s2,48
    4cf6:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4cfa:	fa840513          	addi	a0,s0,-88
    4cfe:	00001097          	auipc	ra,0x1
    4d02:	bbc080e7          	jalr	-1092(ra) # 58ba <unlink>
    pid = fork();
    4d06:	00001097          	auipc	ra,0x1
    4d0a:	b5c080e7          	jalr	-1188(ra) # 5862 <fork>
    if(pid && (i % 3) == 1){
    4d0e:	d20503e3          	beqz	a0,4a34 <concreate+0x48>
    4d12:	036967bb          	remw	a5,s2,s6
    4d16:	d15787e3          	beq	a5,s5,4a24 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4d1a:	20200593          	li	a1,514
    4d1e:	fa840513          	addi	a0,s0,-88
    4d22:	00001097          	auipc	ra,0x1
    4d26:	b88080e7          	jalr	-1144(ra) # 58aa <open>
      if(fd < 0){
    4d2a:	fa0553e3          	bgez	a0,4cd0 <concreate+0x2e4>
    4d2e:	b31d                	j	4a54 <concreate+0x68>
}
    4d30:	60ea                	ld	ra,152(sp)
    4d32:	644a                	ld	s0,144(sp)
    4d34:	64aa                	ld	s1,136(sp)
    4d36:	690a                	ld	s2,128(sp)
    4d38:	79e6                	ld	s3,120(sp)
    4d3a:	7a46                	ld	s4,112(sp)
    4d3c:	7aa6                	ld	s5,104(sp)
    4d3e:	7b06                	ld	s6,96(sp)
    4d40:	6be6                	ld	s7,88(sp)
    4d42:	610d                	addi	sp,sp,160
    4d44:	8082                	ret

0000000000004d46 <bigfile>:
{
    4d46:	7139                	addi	sp,sp,-64
    4d48:	fc06                	sd	ra,56(sp)
    4d4a:	f822                	sd	s0,48(sp)
    4d4c:	f426                	sd	s1,40(sp)
    4d4e:	f04a                	sd	s2,32(sp)
    4d50:	ec4e                	sd	s3,24(sp)
    4d52:	e852                	sd	s4,16(sp)
    4d54:	e456                	sd	s5,8(sp)
    4d56:	0080                	addi	s0,sp,64
    4d58:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4d5a:	00003517          	auipc	a0,0x3
    4d5e:	0de50513          	addi	a0,a0,222 # 7e38 <malloc+0x2198>
    4d62:	00001097          	auipc	ra,0x1
    4d66:	b58080e7          	jalr	-1192(ra) # 58ba <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4d6a:	20200593          	li	a1,514
    4d6e:	00003517          	auipc	a0,0x3
    4d72:	0ca50513          	addi	a0,a0,202 # 7e38 <malloc+0x2198>
    4d76:	00001097          	auipc	ra,0x1
    4d7a:	b34080e7          	jalr	-1228(ra) # 58aa <open>
    4d7e:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4d80:	4481                	li	s1,0
    memset(buf, i, SZ);
    4d82:	00007917          	auipc	s2,0x7
    4d86:	02690913          	addi	s2,s2,38 # bda8 <buf>
  for(i = 0; i < N; i++){
    4d8a:	4a51                	li	s4,20
  if(fd < 0){
    4d8c:	0a054063          	bltz	a0,4e2c <bigfile+0xe6>
    memset(buf, i, SZ);
    4d90:	25800613          	li	a2,600
    4d94:	85a6                	mv	a1,s1
    4d96:	854a                	mv	a0,s2
    4d98:	00001097          	auipc	ra,0x1
    4d9c:	8ce080e7          	jalr	-1842(ra) # 5666 <memset>
    if(write(fd, buf, SZ) != SZ){
    4da0:	25800613          	li	a2,600
    4da4:	85ca                	mv	a1,s2
    4da6:	854e                	mv	a0,s3
    4da8:	00001097          	auipc	ra,0x1
    4dac:	ae2080e7          	jalr	-1310(ra) # 588a <write>
    4db0:	25800793          	li	a5,600
    4db4:	08f51a63          	bne	a0,a5,4e48 <bigfile+0x102>
  for(i = 0; i < N; i++){
    4db8:	2485                	addiw	s1,s1,1
    4dba:	fd449be3          	bne	s1,s4,4d90 <bigfile+0x4a>
  close(fd);
    4dbe:	854e                	mv	a0,s3
    4dc0:	00001097          	auipc	ra,0x1
    4dc4:	ad2080e7          	jalr	-1326(ra) # 5892 <close>
  fd = open("bigfile.dat", 0);
    4dc8:	4581                	li	a1,0
    4dca:	00003517          	auipc	a0,0x3
    4dce:	06e50513          	addi	a0,a0,110 # 7e38 <malloc+0x2198>
    4dd2:	00001097          	auipc	ra,0x1
    4dd6:	ad8080e7          	jalr	-1320(ra) # 58aa <open>
    4dda:	8a2a                	mv	s4,a0
  total = 0;
    4ddc:	4981                	li	s3,0
  for(i = 0; ; i++){
    4dde:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4de0:	00007917          	auipc	s2,0x7
    4de4:	fc890913          	addi	s2,s2,-56 # bda8 <buf>
  if(fd < 0){
    4de8:	06054e63          	bltz	a0,4e64 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4dec:	12c00613          	li	a2,300
    4df0:	85ca                	mv	a1,s2
    4df2:	8552                	mv	a0,s4
    4df4:	00001097          	auipc	ra,0x1
    4df8:	a8e080e7          	jalr	-1394(ra) # 5882 <read>
    if(cc < 0){
    4dfc:	08054263          	bltz	a0,4e80 <bigfile+0x13a>
    if(cc == 0)
    4e00:	c971                	beqz	a0,4ed4 <bigfile+0x18e>
    if(cc != SZ/2){
    4e02:	12c00793          	li	a5,300
    4e06:	08f51b63          	bne	a0,a5,4e9c <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4e0a:	01f4d79b          	srliw	a5,s1,0x1f
    4e0e:	9fa5                	addw	a5,a5,s1
    4e10:	4017d79b          	sraiw	a5,a5,0x1
    4e14:	00094703          	lbu	a4,0(s2)
    4e18:	0af71063          	bne	a4,a5,4eb8 <bigfile+0x172>
    4e1c:	12b94703          	lbu	a4,299(s2)
    4e20:	08f71c63          	bne	a4,a5,4eb8 <bigfile+0x172>
    total += cc;
    4e24:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4e28:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4e2a:	b7c9                	j	4dec <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4e2c:	85d6                	mv	a1,s5
    4e2e:	00003517          	auipc	a0,0x3
    4e32:	01a50513          	addi	a0,a0,26 # 7e48 <malloc+0x21a8>
    4e36:	00001097          	auipc	ra,0x1
    4e3a:	dac080e7          	jalr	-596(ra) # 5be2 <printf>
    exit(1);
    4e3e:	4505                	li	a0,1
    4e40:	00001097          	auipc	ra,0x1
    4e44:	a2a080e7          	jalr	-1494(ra) # 586a <exit>
      printf("%s: write bigfile failed\n", s);
    4e48:	85d6                	mv	a1,s5
    4e4a:	00003517          	auipc	a0,0x3
    4e4e:	01e50513          	addi	a0,a0,30 # 7e68 <malloc+0x21c8>
    4e52:	00001097          	auipc	ra,0x1
    4e56:	d90080e7          	jalr	-624(ra) # 5be2 <printf>
      exit(1);
    4e5a:	4505                	li	a0,1
    4e5c:	00001097          	auipc	ra,0x1
    4e60:	a0e080e7          	jalr	-1522(ra) # 586a <exit>
    printf("%s: cannot open bigfile\n", s);
    4e64:	85d6                	mv	a1,s5
    4e66:	00003517          	auipc	a0,0x3
    4e6a:	02250513          	addi	a0,a0,34 # 7e88 <malloc+0x21e8>
    4e6e:	00001097          	auipc	ra,0x1
    4e72:	d74080e7          	jalr	-652(ra) # 5be2 <printf>
    exit(1);
    4e76:	4505                	li	a0,1
    4e78:	00001097          	auipc	ra,0x1
    4e7c:	9f2080e7          	jalr	-1550(ra) # 586a <exit>
      printf("%s: read bigfile failed\n", s);
    4e80:	85d6                	mv	a1,s5
    4e82:	00003517          	auipc	a0,0x3
    4e86:	02650513          	addi	a0,a0,38 # 7ea8 <malloc+0x2208>
    4e8a:	00001097          	auipc	ra,0x1
    4e8e:	d58080e7          	jalr	-680(ra) # 5be2 <printf>
      exit(1);
    4e92:	4505                	li	a0,1
    4e94:	00001097          	auipc	ra,0x1
    4e98:	9d6080e7          	jalr	-1578(ra) # 586a <exit>
      printf("%s: short read bigfile\n", s);
    4e9c:	85d6                	mv	a1,s5
    4e9e:	00003517          	auipc	a0,0x3
    4ea2:	02a50513          	addi	a0,a0,42 # 7ec8 <malloc+0x2228>
    4ea6:	00001097          	auipc	ra,0x1
    4eaa:	d3c080e7          	jalr	-708(ra) # 5be2 <printf>
      exit(1);
    4eae:	4505                	li	a0,1
    4eb0:	00001097          	auipc	ra,0x1
    4eb4:	9ba080e7          	jalr	-1606(ra) # 586a <exit>
      printf("%s: read bigfile wrong data\n", s);
    4eb8:	85d6                	mv	a1,s5
    4eba:	00003517          	auipc	a0,0x3
    4ebe:	02650513          	addi	a0,a0,38 # 7ee0 <malloc+0x2240>
    4ec2:	00001097          	auipc	ra,0x1
    4ec6:	d20080e7          	jalr	-736(ra) # 5be2 <printf>
      exit(1);
    4eca:	4505                	li	a0,1
    4ecc:	00001097          	auipc	ra,0x1
    4ed0:	99e080e7          	jalr	-1634(ra) # 586a <exit>
  close(fd);
    4ed4:	8552                	mv	a0,s4
    4ed6:	00001097          	auipc	ra,0x1
    4eda:	9bc080e7          	jalr	-1604(ra) # 5892 <close>
  if(total != N*SZ){
    4ede:	678d                	lui	a5,0x3
    4ee0:	ee078793          	addi	a5,a5,-288 # 2ee0 <fourteen+0xf0>
    4ee4:	02f99363          	bne	s3,a5,4f0a <bigfile+0x1c4>
  unlink("bigfile.dat");
    4ee8:	00003517          	auipc	a0,0x3
    4eec:	f5050513          	addi	a0,a0,-176 # 7e38 <malloc+0x2198>
    4ef0:	00001097          	auipc	ra,0x1
    4ef4:	9ca080e7          	jalr	-1590(ra) # 58ba <unlink>
}
    4ef8:	70e2                	ld	ra,56(sp)
    4efa:	7442                	ld	s0,48(sp)
    4efc:	74a2                	ld	s1,40(sp)
    4efe:	7902                	ld	s2,32(sp)
    4f00:	69e2                	ld	s3,24(sp)
    4f02:	6a42                	ld	s4,16(sp)
    4f04:	6aa2                	ld	s5,8(sp)
    4f06:	6121                	addi	sp,sp,64
    4f08:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4f0a:	85d6                	mv	a1,s5
    4f0c:	00003517          	auipc	a0,0x3
    4f10:	ff450513          	addi	a0,a0,-12 # 7f00 <malloc+0x2260>
    4f14:	00001097          	auipc	ra,0x1
    4f18:	cce080e7          	jalr	-818(ra) # 5be2 <printf>
    exit(1);
    4f1c:	4505                	li	a0,1
    4f1e:	00001097          	auipc	ra,0x1
    4f22:	94c080e7          	jalr	-1716(ra) # 586a <exit>

0000000000004f26 <fsfull>:
{
    4f26:	7171                	addi	sp,sp,-176
    4f28:	f506                	sd	ra,168(sp)
    4f2a:	f122                	sd	s0,160(sp)
    4f2c:	ed26                	sd	s1,152(sp)
    4f2e:	e94a                	sd	s2,144(sp)
    4f30:	e54e                	sd	s3,136(sp)
    4f32:	e152                	sd	s4,128(sp)
    4f34:	fcd6                	sd	s5,120(sp)
    4f36:	f8da                	sd	s6,112(sp)
    4f38:	f4de                	sd	s7,104(sp)
    4f3a:	f0e2                	sd	s8,96(sp)
    4f3c:	ece6                	sd	s9,88(sp)
    4f3e:	e8ea                	sd	s10,80(sp)
    4f40:	e4ee                	sd	s11,72(sp)
    4f42:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4f44:	00003517          	auipc	a0,0x3
    4f48:	fdc50513          	addi	a0,a0,-36 # 7f20 <malloc+0x2280>
    4f4c:	00001097          	auipc	ra,0x1
    4f50:	c96080e7          	jalr	-874(ra) # 5be2 <printf>
  for(nfiles = 0; ; nfiles++){
    4f54:	4481                	li	s1,0
    name[0] = 'f';
    4f56:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4f5a:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4f5e:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4f62:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4f64:	00003c97          	auipc	s9,0x3
    4f68:	fccc8c93          	addi	s9,s9,-52 # 7f30 <malloc+0x2290>
    int total = 0;
    4f6c:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4f6e:	00007a17          	auipc	s4,0x7
    4f72:	e3aa0a13          	addi	s4,s4,-454 # bda8 <buf>
    name[0] = 'f';
    4f76:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4f7a:	0384c7bb          	divw	a5,s1,s8
    4f7e:	0307879b          	addiw	a5,a5,48
    4f82:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4f86:	0384e7bb          	remw	a5,s1,s8
    4f8a:	0377c7bb          	divw	a5,a5,s7
    4f8e:	0307879b          	addiw	a5,a5,48
    4f92:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4f96:	0374e7bb          	remw	a5,s1,s7
    4f9a:	0367c7bb          	divw	a5,a5,s6
    4f9e:	0307879b          	addiw	a5,a5,48
    4fa2:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4fa6:	0364e7bb          	remw	a5,s1,s6
    4faa:	0307879b          	addiw	a5,a5,48
    4fae:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4fb2:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4fb6:	f5040593          	addi	a1,s0,-176
    4fba:	8566                	mv	a0,s9
    4fbc:	00001097          	auipc	ra,0x1
    4fc0:	c26080e7          	jalr	-986(ra) # 5be2 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4fc4:	20200593          	li	a1,514
    4fc8:	f5040513          	addi	a0,s0,-176
    4fcc:	00001097          	auipc	ra,0x1
    4fd0:	8de080e7          	jalr	-1826(ra) # 58aa <open>
    4fd4:	892a                	mv	s2,a0
    if(fd < 0){
    4fd6:	0a055663          	bgez	a0,5082 <fsfull+0x15c>
      printf("open %s failed\n", name);
    4fda:	f5040593          	addi	a1,s0,-176
    4fde:	00003517          	auipc	a0,0x3
    4fe2:	f6250513          	addi	a0,a0,-158 # 7f40 <malloc+0x22a0>
    4fe6:	00001097          	auipc	ra,0x1
    4fea:	bfc080e7          	jalr	-1028(ra) # 5be2 <printf>
  while(nfiles >= 0){
    4fee:	0604c363          	bltz	s1,5054 <fsfull+0x12e>
    name[0] = 'f';
    4ff2:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4ff6:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4ffa:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4ffe:	4929                	li	s2,10
  while(nfiles >= 0){
    5000:	5afd                	li	s5,-1
    name[0] = 'f';
    5002:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    5006:	0344c7bb          	divw	a5,s1,s4
    500a:	0307879b          	addiw	a5,a5,48
    500e:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5012:	0344e7bb          	remw	a5,s1,s4
    5016:	0337c7bb          	divw	a5,a5,s3
    501a:	0307879b          	addiw	a5,a5,48
    501e:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5022:	0334e7bb          	remw	a5,s1,s3
    5026:	0327c7bb          	divw	a5,a5,s2
    502a:	0307879b          	addiw	a5,a5,48
    502e:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5032:	0324e7bb          	remw	a5,s1,s2
    5036:	0307879b          	addiw	a5,a5,48
    503a:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    503e:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    5042:	f5040513          	addi	a0,s0,-176
    5046:	00001097          	auipc	ra,0x1
    504a:	874080e7          	jalr	-1932(ra) # 58ba <unlink>
    nfiles--;
    504e:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    5050:	fb5499e3          	bne	s1,s5,5002 <fsfull+0xdc>
  printf("fsfull test finished\n");
    5054:	00003517          	auipc	a0,0x3
    5058:	f0c50513          	addi	a0,a0,-244 # 7f60 <malloc+0x22c0>
    505c:	00001097          	auipc	ra,0x1
    5060:	b86080e7          	jalr	-1146(ra) # 5be2 <printf>
}
    5064:	70aa                	ld	ra,168(sp)
    5066:	740a                	ld	s0,160(sp)
    5068:	64ea                	ld	s1,152(sp)
    506a:	694a                	ld	s2,144(sp)
    506c:	69aa                	ld	s3,136(sp)
    506e:	6a0a                	ld	s4,128(sp)
    5070:	7ae6                	ld	s5,120(sp)
    5072:	7b46                	ld	s6,112(sp)
    5074:	7ba6                	ld	s7,104(sp)
    5076:	7c06                	ld	s8,96(sp)
    5078:	6ce6                	ld	s9,88(sp)
    507a:	6d46                	ld	s10,80(sp)
    507c:	6da6                	ld	s11,72(sp)
    507e:	614d                	addi	sp,sp,176
    5080:	8082                	ret
    int total = 0;
    5082:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    5084:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    5088:	40000613          	li	a2,1024
    508c:	85d2                	mv	a1,s4
    508e:	854a                	mv	a0,s2
    5090:	00000097          	auipc	ra,0x0
    5094:	7fa080e7          	jalr	2042(ra) # 588a <write>
      if(cc < BSIZE)
    5098:	00aad563          	bge	s5,a0,50a2 <fsfull+0x17c>
      total += cc;
    509c:	00a989bb          	addw	s3,s3,a0
    while(1){
    50a0:	b7e5                	j	5088 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    50a2:	85ce                	mv	a1,s3
    50a4:	00003517          	auipc	a0,0x3
    50a8:	eac50513          	addi	a0,a0,-340 # 7f50 <malloc+0x22b0>
    50ac:	00001097          	auipc	ra,0x1
    50b0:	b36080e7          	jalr	-1226(ra) # 5be2 <printf>
    close(fd);
    50b4:	854a                	mv	a0,s2
    50b6:	00000097          	auipc	ra,0x0
    50ba:	7dc080e7          	jalr	2012(ra) # 5892 <close>
    if(total == 0)
    50be:	f20988e3          	beqz	s3,4fee <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    50c2:	2485                	addiw	s1,s1,1
    50c4:	bd4d                	j	4f76 <fsfull+0x50>

00000000000050c6 <badwrite>:
{
    50c6:	7179                	addi	sp,sp,-48
    50c8:	f406                	sd	ra,40(sp)
    50ca:	f022                	sd	s0,32(sp)
    50cc:	ec26                	sd	s1,24(sp)
    50ce:	e84a                	sd	s2,16(sp)
    50d0:	e44e                	sd	s3,8(sp)
    50d2:	e052                	sd	s4,0(sp)
    50d4:	1800                	addi	s0,sp,48
  unlink("junk");
    50d6:	00003517          	auipc	a0,0x3
    50da:	ea250513          	addi	a0,a0,-350 # 7f78 <malloc+0x22d8>
    50de:	00000097          	auipc	ra,0x0
    50e2:	7dc080e7          	jalr	2012(ra) # 58ba <unlink>
    50e6:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    50ea:	00003997          	auipc	s3,0x3
    50ee:	e8e98993          	addi	s3,s3,-370 # 7f78 <malloc+0x22d8>
    write(fd, (char*)0xffffffffffL, 1);
    50f2:	5a7d                	li	s4,-1
    50f4:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    50f8:	20100593          	li	a1,513
    50fc:	854e                	mv	a0,s3
    50fe:	00000097          	auipc	ra,0x0
    5102:	7ac080e7          	jalr	1964(ra) # 58aa <open>
    5106:	84aa                	mv	s1,a0
    if(fd < 0){
    5108:	06054b63          	bltz	a0,517e <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    510c:	4605                	li	a2,1
    510e:	85d2                	mv	a1,s4
    5110:	00000097          	auipc	ra,0x0
    5114:	77a080e7          	jalr	1914(ra) # 588a <write>
    close(fd);
    5118:	8526                	mv	a0,s1
    511a:	00000097          	auipc	ra,0x0
    511e:	778080e7          	jalr	1912(ra) # 5892 <close>
    unlink("junk");
    5122:	854e                	mv	a0,s3
    5124:	00000097          	auipc	ra,0x0
    5128:	796080e7          	jalr	1942(ra) # 58ba <unlink>
  for(int i = 0; i < assumed_free; i++){
    512c:	397d                	addiw	s2,s2,-1
    512e:	fc0915e3          	bnez	s2,50f8 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    5132:	20100593          	li	a1,513
    5136:	00003517          	auipc	a0,0x3
    513a:	e4250513          	addi	a0,a0,-446 # 7f78 <malloc+0x22d8>
    513e:	00000097          	auipc	ra,0x0
    5142:	76c080e7          	jalr	1900(ra) # 58aa <open>
    5146:	84aa                	mv	s1,a0
  if(fd < 0){
    5148:	04054863          	bltz	a0,5198 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    514c:	4605                	li	a2,1
    514e:	00001597          	auipc	a1,0x1
    5152:	04258593          	addi	a1,a1,66 # 6190 <malloc+0x4f0>
    5156:	00000097          	auipc	ra,0x0
    515a:	734080e7          	jalr	1844(ra) # 588a <write>
    515e:	4785                	li	a5,1
    5160:	04f50963          	beq	a0,a5,51b2 <badwrite+0xec>
    printf("write failed\n");
    5164:	00003517          	auipc	a0,0x3
    5168:	e3450513          	addi	a0,a0,-460 # 7f98 <malloc+0x22f8>
    516c:	00001097          	auipc	ra,0x1
    5170:	a76080e7          	jalr	-1418(ra) # 5be2 <printf>
    exit(1);
    5174:	4505                	li	a0,1
    5176:	00000097          	auipc	ra,0x0
    517a:	6f4080e7          	jalr	1780(ra) # 586a <exit>
      printf("open junk failed\n");
    517e:	00003517          	auipc	a0,0x3
    5182:	e0250513          	addi	a0,a0,-510 # 7f80 <malloc+0x22e0>
    5186:	00001097          	auipc	ra,0x1
    518a:	a5c080e7          	jalr	-1444(ra) # 5be2 <printf>
      exit(1);
    518e:	4505                	li	a0,1
    5190:	00000097          	auipc	ra,0x0
    5194:	6da080e7          	jalr	1754(ra) # 586a <exit>
    printf("open junk failed\n");
    5198:	00003517          	auipc	a0,0x3
    519c:	de850513          	addi	a0,a0,-536 # 7f80 <malloc+0x22e0>
    51a0:	00001097          	auipc	ra,0x1
    51a4:	a42080e7          	jalr	-1470(ra) # 5be2 <printf>
    exit(1);
    51a8:	4505                	li	a0,1
    51aa:	00000097          	auipc	ra,0x0
    51ae:	6c0080e7          	jalr	1728(ra) # 586a <exit>
  close(fd);
    51b2:	8526                	mv	a0,s1
    51b4:	00000097          	auipc	ra,0x0
    51b8:	6de080e7          	jalr	1758(ra) # 5892 <close>
  unlink("junk");
    51bc:	00003517          	auipc	a0,0x3
    51c0:	dbc50513          	addi	a0,a0,-580 # 7f78 <malloc+0x22d8>
    51c4:	00000097          	auipc	ra,0x0
    51c8:	6f6080e7          	jalr	1782(ra) # 58ba <unlink>
  exit(0);
    51cc:	4501                	li	a0,0
    51ce:	00000097          	auipc	ra,0x0
    51d2:	69c080e7          	jalr	1692(ra) # 586a <exit>

00000000000051d6 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    51d6:	7139                	addi	sp,sp,-64
    51d8:	fc06                	sd	ra,56(sp)
    51da:	f822                	sd	s0,48(sp)
    51dc:	f426                	sd	s1,40(sp)
    51de:	f04a                	sd	s2,32(sp)
    51e0:	ec4e                	sd	s3,24(sp)
    51e2:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    51e4:	fc840513          	addi	a0,s0,-56
    51e8:	00000097          	auipc	ra,0x0
    51ec:	692080e7          	jalr	1682(ra) # 587a <pipe>
    51f0:	06054863          	bltz	a0,5260 <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    51f4:	00000097          	auipc	ra,0x0
    51f8:	66e080e7          	jalr	1646(ra) # 5862 <fork>

  if(pid < 0){
    51fc:	06054f63          	bltz	a0,527a <countfree+0xa4>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5200:	ed59                	bnez	a0,529e <countfree+0xc8>
    close(fds[0]);
    5202:	fc842503          	lw	a0,-56(s0)
    5206:	00000097          	auipc	ra,0x0
    520a:	68c080e7          	jalr	1676(ra) # 5892 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    520e:	54fd                	li	s1,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5210:	4985                	li	s3,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5212:	00001917          	auipc	s2,0x1
    5216:	f7e90913          	addi	s2,s2,-130 # 6190 <malloc+0x4f0>
      uint64 a = (uint64) sbrk(4096);
    521a:	6505                	lui	a0,0x1
    521c:	00000097          	auipc	ra,0x0
    5220:	6d6080e7          	jalr	1750(ra) # 58f2 <sbrk>
      if(a == 0xffffffffffffffff){
    5224:	06950863          	beq	a0,s1,5294 <countfree+0xbe>
      *(char *)(a + 4096 - 1) = 1;
    5228:	6785                	lui	a5,0x1
    522a:	953e                	add	a0,a0,a5
    522c:	ff350fa3          	sb	s3,-1(a0) # fff <bigdir+0x85>
      if(write(fds[1], "x", 1) != 1){
    5230:	4605                	li	a2,1
    5232:	85ca                	mv	a1,s2
    5234:	fcc42503          	lw	a0,-52(s0)
    5238:	00000097          	auipc	ra,0x0
    523c:	652080e7          	jalr	1618(ra) # 588a <write>
    5240:	4785                	li	a5,1
    5242:	fcf50ce3          	beq	a0,a5,521a <countfree+0x44>
        printf("write() failed in countfree()\n");
    5246:	00003517          	auipc	a0,0x3
    524a:	da250513          	addi	a0,a0,-606 # 7fe8 <malloc+0x2348>
    524e:	00001097          	auipc	ra,0x1
    5252:	994080e7          	jalr	-1644(ra) # 5be2 <printf>
        exit(1);
    5256:	4505                	li	a0,1
    5258:	00000097          	auipc	ra,0x0
    525c:	612080e7          	jalr	1554(ra) # 586a <exit>
    printf("pipe() failed in countfree()\n");
    5260:	00003517          	auipc	a0,0x3
    5264:	d4850513          	addi	a0,a0,-696 # 7fa8 <malloc+0x2308>
    5268:	00001097          	auipc	ra,0x1
    526c:	97a080e7          	jalr	-1670(ra) # 5be2 <printf>
    exit(1);
    5270:	4505                	li	a0,1
    5272:	00000097          	auipc	ra,0x0
    5276:	5f8080e7          	jalr	1528(ra) # 586a <exit>
    printf("fork failed in countfree()\n");
    527a:	00003517          	auipc	a0,0x3
    527e:	d4e50513          	addi	a0,a0,-690 # 7fc8 <malloc+0x2328>
    5282:	00001097          	auipc	ra,0x1
    5286:	960080e7          	jalr	-1696(ra) # 5be2 <printf>
    exit(1);
    528a:	4505                	li	a0,1
    528c:	00000097          	auipc	ra,0x0
    5290:	5de080e7          	jalr	1502(ra) # 586a <exit>
      }
    }

    exit(0);
    5294:	4501                	li	a0,0
    5296:	00000097          	auipc	ra,0x0
    529a:	5d4080e7          	jalr	1492(ra) # 586a <exit>
  }

  close(fds[1]);
    529e:	fcc42503          	lw	a0,-52(s0)
    52a2:	00000097          	auipc	ra,0x0
    52a6:	5f0080e7          	jalr	1520(ra) # 5892 <close>

  int n = 0;
    52aa:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    52ac:	4605                	li	a2,1
    52ae:	fc740593          	addi	a1,s0,-57
    52b2:	fc842503          	lw	a0,-56(s0)
    52b6:	00000097          	auipc	ra,0x0
    52ba:	5cc080e7          	jalr	1484(ra) # 5882 <read>
    if(cc < 0){
    52be:	00054563          	bltz	a0,52c8 <countfree+0xf2>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    52c2:	c105                	beqz	a0,52e2 <countfree+0x10c>
      break;
    n += 1;
    52c4:	2485                	addiw	s1,s1,1
  while(1){
    52c6:	b7dd                	j	52ac <countfree+0xd6>
      printf("read() failed in countfree()\n");
    52c8:	00003517          	auipc	a0,0x3
    52cc:	d4050513          	addi	a0,a0,-704 # 8008 <malloc+0x2368>
    52d0:	00001097          	auipc	ra,0x1
    52d4:	912080e7          	jalr	-1774(ra) # 5be2 <printf>
      exit(1);
    52d8:	4505                	li	a0,1
    52da:	00000097          	auipc	ra,0x0
    52de:	590080e7          	jalr	1424(ra) # 586a <exit>
  }

  close(fds[0]);
    52e2:	fc842503          	lw	a0,-56(s0)
    52e6:	00000097          	auipc	ra,0x0
    52ea:	5ac080e7          	jalr	1452(ra) # 5892 <close>
  wait((int*)0);
    52ee:	4501                	li	a0,0
    52f0:	00000097          	auipc	ra,0x0
    52f4:	582080e7          	jalr	1410(ra) # 5872 <wait>
  
  return n;
}
    52f8:	8526                	mv	a0,s1
    52fa:	70e2                	ld	ra,56(sp)
    52fc:	7442                	ld	s0,48(sp)
    52fe:	74a2                	ld	s1,40(sp)
    5300:	7902                	ld	s2,32(sp)
    5302:	69e2                	ld	s3,24(sp)
    5304:	6121                	addi	sp,sp,64
    5306:	8082                	ret

0000000000005308 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5308:	7179                	addi	sp,sp,-48
    530a:	f406                	sd	ra,40(sp)
    530c:	f022                	sd	s0,32(sp)
    530e:	ec26                	sd	s1,24(sp)
    5310:	e84a                	sd	s2,16(sp)
    5312:	1800                	addi	s0,sp,48
    5314:	84aa                	mv	s1,a0
    5316:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5318:	00003517          	auipc	a0,0x3
    531c:	d1050513          	addi	a0,a0,-752 # 8028 <malloc+0x2388>
    5320:	00001097          	auipc	ra,0x1
    5324:	8c2080e7          	jalr	-1854(ra) # 5be2 <printf>
  if((pid = fork()) < 0) {
    5328:	00000097          	auipc	ra,0x0
    532c:	53a080e7          	jalr	1338(ra) # 5862 <fork>
    5330:	02054e63          	bltz	a0,536c <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5334:	c929                	beqz	a0,5386 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5336:	fdc40513          	addi	a0,s0,-36
    533a:	00000097          	auipc	ra,0x0
    533e:	538080e7          	jalr	1336(ra) # 5872 <wait>
    if(xstatus != 0) 
    5342:	fdc42783          	lw	a5,-36(s0)
    5346:	c7b9                	beqz	a5,5394 <run+0x8c>
      printf("FAILED\n");
    5348:	00003517          	auipc	a0,0x3
    534c:	d0850513          	addi	a0,a0,-760 # 8050 <malloc+0x23b0>
    5350:	00001097          	auipc	ra,0x1
    5354:	892080e7          	jalr	-1902(ra) # 5be2 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5358:	fdc42503          	lw	a0,-36(s0)
  }
}
    535c:	00153513          	seqz	a0,a0
    5360:	70a2                	ld	ra,40(sp)
    5362:	7402                	ld	s0,32(sp)
    5364:	64e2                	ld	s1,24(sp)
    5366:	6942                	ld	s2,16(sp)
    5368:	6145                	addi	sp,sp,48
    536a:	8082                	ret
    printf("runtest: fork error\n");
    536c:	00003517          	auipc	a0,0x3
    5370:	ccc50513          	addi	a0,a0,-820 # 8038 <malloc+0x2398>
    5374:	00001097          	auipc	ra,0x1
    5378:	86e080e7          	jalr	-1938(ra) # 5be2 <printf>
    exit(1);
    537c:	4505                	li	a0,1
    537e:	00000097          	auipc	ra,0x0
    5382:	4ec080e7          	jalr	1260(ra) # 586a <exit>
    f(s);
    5386:	854a                	mv	a0,s2
    5388:	9482                	jalr	s1
    exit(0);
    538a:	4501                	li	a0,0
    538c:	00000097          	auipc	ra,0x0
    5390:	4de080e7          	jalr	1246(ra) # 586a <exit>
      printf("OK\n");
    5394:	00003517          	auipc	a0,0x3
    5398:	cc450513          	addi	a0,a0,-828 # 8058 <malloc+0x23b8>
    539c:	00001097          	auipc	ra,0x1
    53a0:	846080e7          	jalr	-1978(ra) # 5be2 <printf>
    53a4:	bf55                	j	5358 <run+0x50>

00000000000053a6 <main>:

int
main(int argc, char *argv[])
{
    53a6:	bd010113          	addi	sp,sp,-1072
    53aa:	42113423          	sd	ra,1064(sp)
    53ae:	42813023          	sd	s0,1056(sp)
    53b2:	40913c23          	sd	s1,1048(sp)
    53b6:	41213823          	sd	s2,1040(sp)
    53ba:	41313423          	sd	s3,1032(sp)
    53be:	41413023          	sd	s4,1024(sp)
    53c2:	3f513c23          	sd	s5,1016(sp)
    53c6:	3f613823          	sd	s6,1008(sp)
    53ca:	43010413          	addi	s0,sp,1072
    53ce:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    53d0:	4789                	li	a5,2
    53d2:	08f50f63          	beq	a0,a5,5470 <main+0xca>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    53d6:	4785                	li	a5,1
  char *justone = 0;
    53d8:	4901                	li	s2,0
  } else if(argc > 1){
    53da:	0ca7c963          	blt	a5,a0,54ac <main+0x106>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    53de:	00003797          	auipc	a5,0x3
    53e2:	d9278793          	addi	a5,a5,-622 # 8170 <malloc+0x24d0>
    53e6:	bd040713          	addi	a4,s0,-1072
    53ea:	00003317          	auipc	t1,0x3
    53ee:	17630313          	addi	t1,t1,374 # 8560 <malloc+0x28c0>
    53f2:	0007b883          	ld	a7,0(a5)
    53f6:	0087b803          	ld	a6,8(a5)
    53fa:	6b88                	ld	a0,16(a5)
    53fc:	6f8c                	ld	a1,24(a5)
    53fe:	7390                	ld	a2,32(a5)
    5400:	7794                	ld	a3,40(a5)
    5402:	01173023          	sd	a7,0(a4)
    5406:	01073423          	sd	a6,8(a4)
    540a:	eb08                	sd	a0,16(a4)
    540c:	ef0c                	sd	a1,24(a4)
    540e:	f310                	sd	a2,32(a4)
    5410:	f714                	sd	a3,40(a4)
    5412:	03078793          	addi	a5,a5,48
    5416:	03070713          	addi	a4,a4,48
    541a:	fc679ce3          	bne	a5,t1,53f2 <main+0x4c>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    541e:	00003517          	auipc	a0,0x3
    5422:	cf250513          	addi	a0,a0,-782 # 8110 <malloc+0x2470>
    5426:	00000097          	auipc	ra,0x0
    542a:	7bc080e7          	jalr	1980(ra) # 5be2 <printf>
  int free0 = countfree();
    542e:	00000097          	auipc	ra,0x0
    5432:	da8080e7          	jalr	-600(ra) # 51d6 <countfree>
    5436:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    5438:	bd843503          	ld	a0,-1064(s0)
    543c:	bd040493          	addi	s1,s0,-1072
  int fail = 0;
    5440:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    5442:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    5444:	e55d                	bnez	a0,54f2 <main+0x14c>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    5446:	00000097          	auipc	ra,0x0
    544a:	d90080e7          	jalr	-624(ra) # 51d6 <countfree>
    544e:	85aa                	mv	a1,a0
    5450:	0f455163          	bge	a0,s4,5532 <main+0x18c>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5454:	8652                	mv	a2,s4
    5456:	00003517          	auipc	a0,0x3
    545a:	c7250513          	addi	a0,a0,-910 # 80c8 <malloc+0x2428>
    545e:	00000097          	auipc	ra,0x0
    5462:	784080e7          	jalr	1924(ra) # 5be2 <printf>
    exit(1);
    5466:	4505                	li	a0,1
    5468:	00000097          	auipc	ra,0x0
    546c:	402080e7          	jalr	1026(ra) # 586a <exit>
    5470:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5472:	00003597          	auipc	a1,0x3
    5476:	bee58593          	addi	a1,a1,-1042 # 8060 <malloc+0x23c0>
    547a:	6488                	ld	a0,8(s1)
    547c:	00000097          	auipc	ra,0x0
    5480:	194080e7          	jalr	404(ra) # 5610 <strcmp>
    5484:	10050563          	beqz	a0,558e <main+0x1e8>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5488:	00003597          	auipc	a1,0x3
    548c:	cc058593          	addi	a1,a1,-832 # 8148 <malloc+0x24a8>
    5490:	6488                	ld	a0,8(s1)
    5492:	00000097          	auipc	ra,0x0
    5496:	17e080e7          	jalr	382(ra) # 5610 <strcmp>
    549a:	c97d                	beqz	a0,5590 <main+0x1ea>
  } else if(argc == 2 && argv[1][0] != '-'){
    549c:	0084b903          	ld	s2,8(s1)
    54a0:	00094703          	lbu	a4,0(s2)
    54a4:	02d00793          	li	a5,45
    54a8:	f2f71be3          	bne	a4,a5,53de <main+0x38>
    printf("Usage: usertests [-c] [testname]\n");
    54ac:	00003517          	auipc	a0,0x3
    54b0:	bbc50513          	addi	a0,a0,-1092 # 8068 <malloc+0x23c8>
    54b4:	00000097          	auipc	ra,0x0
    54b8:	72e080e7          	jalr	1838(ra) # 5be2 <printf>
    exit(1);
    54bc:	4505                	li	a0,1
    54be:	00000097          	auipc	ra,0x0
    54c2:	3ac080e7          	jalr	940(ra) # 586a <exit>
          exit(1);
    54c6:	4505                	li	a0,1
    54c8:	00000097          	auipc	ra,0x0
    54cc:	3a2080e7          	jalr	930(ra) # 586a <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    54d0:	40a905bb          	subw	a1,s2,a0
    54d4:	855a                	mv	a0,s6
    54d6:	00000097          	auipc	ra,0x0
    54da:	70c080e7          	jalr	1804(ra) # 5be2 <printf>
        if(continuous != 2)
    54de:	09498463          	beq	s3,s4,5566 <main+0x1c0>
          exit(1);
    54e2:	4505                	li	a0,1
    54e4:	00000097          	auipc	ra,0x0
    54e8:	386080e7          	jalr	902(ra) # 586a <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    54ec:	04c1                	addi	s1,s1,16
    54ee:	6488                	ld	a0,8(s1)
    54f0:	c115                	beqz	a0,5514 <main+0x16e>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    54f2:	00090863          	beqz	s2,5502 <main+0x15c>
    54f6:	85ca                	mv	a1,s2
    54f8:	00000097          	auipc	ra,0x0
    54fc:	118080e7          	jalr	280(ra) # 5610 <strcmp>
    5500:	f575                	bnez	a0,54ec <main+0x146>
      if(!run(t->f, t->s))
    5502:	648c                	ld	a1,8(s1)
    5504:	6088                	ld	a0,0(s1)
    5506:	00000097          	auipc	ra,0x0
    550a:	e02080e7          	jalr	-510(ra) # 5308 <run>
    550e:	fd79                	bnez	a0,54ec <main+0x146>
        fail = 1;
    5510:	89d6                	mv	s3,s5
    5512:	bfe9                	j	54ec <main+0x146>
  if(fail){
    5514:	f20989e3          	beqz	s3,5446 <main+0xa0>
    printf("SOME TESTS FAILED\n");
    5518:	00003517          	auipc	a0,0x3
    551c:	b9850513          	addi	a0,a0,-1128 # 80b0 <malloc+0x2410>
    5520:	00000097          	auipc	ra,0x0
    5524:	6c2080e7          	jalr	1730(ra) # 5be2 <printf>
    exit(1);
    5528:	4505                	li	a0,1
    552a:	00000097          	auipc	ra,0x0
    552e:	340080e7          	jalr	832(ra) # 586a <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    5532:	00003517          	auipc	a0,0x3
    5536:	bc650513          	addi	a0,a0,-1082 # 80f8 <malloc+0x2458>
    553a:	00000097          	auipc	ra,0x0
    553e:	6a8080e7          	jalr	1704(ra) # 5be2 <printf>
    exit(0);
    5542:	4501                	li	a0,0
    5544:	00000097          	auipc	ra,0x0
    5548:	326080e7          	jalr	806(ra) # 586a <exit>
        printf("SOME TESTS FAILED\n");
    554c:	8556                	mv	a0,s5
    554e:	00000097          	auipc	ra,0x0
    5552:	694080e7          	jalr	1684(ra) # 5be2 <printf>
        if(continuous != 2)
    5556:	f74998e3          	bne	s3,s4,54c6 <main+0x120>
      int free1 = countfree();
    555a:	00000097          	auipc	ra,0x0
    555e:	c7c080e7          	jalr	-900(ra) # 51d6 <countfree>
      if(free1 < free0){
    5562:	f72547e3          	blt	a0,s2,54d0 <main+0x12a>
      int free0 = countfree();
    5566:	00000097          	auipc	ra,0x0
    556a:	c70080e7          	jalr	-912(ra) # 51d6 <countfree>
    556e:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    5570:	bd843583          	ld	a1,-1064(s0)
    5574:	d1fd                	beqz	a1,555a <main+0x1b4>
    5576:	bd040493          	addi	s1,s0,-1072
        if(!run(t->f, t->s)){
    557a:	6088                	ld	a0,0(s1)
    557c:	00000097          	auipc	ra,0x0
    5580:	d8c080e7          	jalr	-628(ra) # 5308 <run>
    5584:	d561                	beqz	a0,554c <main+0x1a6>
      for (struct test *t = tests; t->s != 0; t++) {
    5586:	04c1                	addi	s1,s1,16
    5588:	648c                	ld	a1,8(s1)
    558a:	f9e5                	bnez	a1,557a <main+0x1d4>
    558c:	b7f9                	j	555a <main+0x1b4>
    continuous = 1;
    558e:	4985                	li	s3,1
  } tests[] = {
    5590:	00003797          	auipc	a5,0x3
    5594:	be078793          	addi	a5,a5,-1056 # 8170 <malloc+0x24d0>
    5598:	bd040713          	addi	a4,s0,-1072
    559c:	00003317          	auipc	t1,0x3
    55a0:	fc430313          	addi	t1,t1,-60 # 8560 <malloc+0x28c0>
    55a4:	0007b883          	ld	a7,0(a5)
    55a8:	0087b803          	ld	a6,8(a5)
    55ac:	6b88                	ld	a0,16(a5)
    55ae:	6f8c                	ld	a1,24(a5)
    55b0:	7390                	ld	a2,32(a5)
    55b2:	7794                	ld	a3,40(a5)
    55b4:	01173023          	sd	a7,0(a4)
    55b8:	01073423          	sd	a6,8(a4)
    55bc:	eb08                	sd	a0,16(a4)
    55be:	ef0c                	sd	a1,24(a4)
    55c0:	f310                	sd	a2,32(a4)
    55c2:	f714                	sd	a3,40(a4)
    55c4:	03078793          	addi	a5,a5,48
    55c8:	03070713          	addi	a4,a4,48
    55cc:	fc679ce3          	bne	a5,t1,55a4 <main+0x1fe>
    printf("continuous usertests starting\n");
    55d0:	00003517          	auipc	a0,0x3
    55d4:	b5850513          	addi	a0,a0,-1192 # 8128 <malloc+0x2488>
    55d8:	00000097          	auipc	ra,0x0
    55dc:	60a080e7          	jalr	1546(ra) # 5be2 <printf>
        printf("SOME TESTS FAILED\n");
    55e0:	00003a97          	auipc	s5,0x3
    55e4:	ad0a8a93          	addi	s5,s5,-1328 # 80b0 <malloc+0x2410>
        if(continuous != 2)
    55e8:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    55ea:	00003b17          	auipc	s6,0x3
    55ee:	aa6b0b13          	addi	s6,s6,-1370 # 8090 <malloc+0x23f0>
    55f2:	bf95                	j	5566 <main+0x1c0>

00000000000055f4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    55f4:	1141                	addi	sp,sp,-16
    55f6:	e422                	sd	s0,8(sp)
    55f8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    55fa:	87aa                	mv	a5,a0
    55fc:	0585                	addi	a1,a1,1
    55fe:	0785                	addi	a5,a5,1
    5600:	fff5c703          	lbu	a4,-1(a1)
    5604:	fee78fa3          	sb	a4,-1(a5)
    5608:	fb75                	bnez	a4,55fc <strcpy+0x8>
    ;
  return os;
}
    560a:	6422                	ld	s0,8(sp)
    560c:	0141                	addi	sp,sp,16
    560e:	8082                	ret

0000000000005610 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5610:	1141                	addi	sp,sp,-16
    5612:	e422                	sd	s0,8(sp)
    5614:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5616:	00054783          	lbu	a5,0(a0)
    561a:	cb91                	beqz	a5,562e <strcmp+0x1e>
    561c:	0005c703          	lbu	a4,0(a1)
    5620:	00f71763          	bne	a4,a5,562e <strcmp+0x1e>
    p++, q++;
    5624:	0505                	addi	a0,a0,1
    5626:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5628:	00054783          	lbu	a5,0(a0)
    562c:	fbe5                	bnez	a5,561c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    562e:	0005c503          	lbu	a0,0(a1)
}
    5632:	40a7853b          	subw	a0,a5,a0
    5636:	6422                	ld	s0,8(sp)
    5638:	0141                	addi	sp,sp,16
    563a:	8082                	ret

000000000000563c <strlen>:

uint
strlen(const char *s)
{
    563c:	1141                	addi	sp,sp,-16
    563e:	e422                	sd	s0,8(sp)
    5640:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5642:	00054783          	lbu	a5,0(a0)
    5646:	cf91                	beqz	a5,5662 <strlen+0x26>
    5648:	0505                	addi	a0,a0,1
    564a:	87aa                	mv	a5,a0
    564c:	4685                	li	a3,1
    564e:	9e89                	subw	a3,a3,a0
    5650:	00f6853b          	addw	a0,a3,a5
    5654:	0785                	addi	a5,a5,1
    5656:	fff7c703          	lbu	a4,-1(a5)
    565a:	fb7d                	bnez	a4,5650 <strlen+0x14>
    ;
  return n;
}
    565c:	6422                	ld	s0,8(sp)
    565e:	0141                	addi	sp,sp,16
    5660:	8082                	ret
  for(n = 0; s[n]; n++)
    5662:	4501                	li	a0,0
    5664:	bfe5                	j	565c <strlen+0x20>

0000000000005666 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5666:	1141                	addi	sp,sp,-16
    5668:	e422                	sd	s0,8(sp)
    566a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    566c:	ce09                	beqz	a2,5686 <memset+0x20>
    566e:	87aa                	mv	a5,a0
    5670:	fff6071b          	addiw	a4,a2,-1
    5674:	1702                	slli	a4,a4,0x20
    5676:	9301                	srli	a4,a4,0x20
    5678:	0705                	addi	a4,a4,1
    567a:	972a                	add	a4,a4,a0
    cdst[i] = c;
    567c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5680:	0785                	addi	a5,a5,1
    5682:	fee79de3          	bne	a5,a4,567c <memset+0x16>
  }
  return dst;
}
    5686:	6422                	ld	s0,8(sp)
    5688:	0141                	addi	sp,sp,16
    568a:	8082                	ret

000000000000568c <strchr>:

char*
strchr(const char *s, char c)
{
    568c:	1141                	addi	sp,sp,-16
    568e:	e422                	sd	s0,8(sp)
    5690:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5692:	00054783          	lbu	a5,0(a0)
    5696:	cb99                	beqz	a5,56ac <strchr+0x20>
    if(*s == c)
    5698:	00f58763          	beq	a1,a5,56a6 <strchr+0x1a>
  for(; *s; s++)
    569c:	0505                	addi	a0,a0,1
    569e:	00054783          	lbu	a5,0(a0)
    56a2:	fbfd                	bnez	a5,5698 <strchr+0xc>
      return (char*)s;
  return 0;
    56a4:	4501                	li	a0,0
}
    56a6:	6422                	ld	s0,8(sp)
    56a8:	0141                	addi	sp,sp,16
    56aa:	8082                	ret
  return 0;
    56ac:	4501                	li	a0,0
    56ae:	bfe5                	j	56a6 <strchr+0x1a>

00000000000056b0 <gets>:

char*
gets(char *buf, int max)
{
    56b0:	711d                	addi	sp,sp,-96
    56b2:	ec86                	sd	ra,88(sp)
    56b4:	e8a2                	sd	s0,80(sp)
    56b6:	e4a6                	sd	s1,72(sp)
    56b8:	e0ca                	sd	s2,64(sp)
    56ba:	fc4e                	sd	s3,56(sp)
    56bc:	f852                	sd	s4,48(sp)
    56be:	f456                	sd	s5,40(sp)
    56c0:	f05a                	sd	s6,32(sp)
    56c2:	ec5e                	sd	s7,24(sp)
    56c4:	1080                	addi	s0,sp,96
    56c6:	8baa                	mv	s7,a0
    56c8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    56ca:	892a                	mv	s2,a0
    56cc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    56ce:	4aa9                	li	s5,10
    56d0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    56d2:	89a6                	mv	s3,s1
    56d4:	2485                	addiw	s1,s1,1
    56d6:	0344d863          	bge	s1,s4,5706 <gets+0x56>
    cc = read(0, &c, 1);
    56da:	4605                	li	a2,1
    56dc:	faf40593          	addi	a1,s0,-81
    56e0:	4501                	li	a0,0
    56e2:	00000097          	auipc	ra,0x0
    56e6:	1a0080e7          	jalr	416(ra) # 5882 <read>
    if(cc < 1)
    56ea:	00a05e63          	blez	a0,5706 <gets+0x56>
    buf[i++] = c;
    56ee:	faf44783          	lbu	a5,-81(s0)
    56f2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    56f6:	01578763          	beq	a5,s5,5704 <gets+0x54>
    56fa:	0905                	addi	s2,s2,1
    56fc:	fd679be3          	bne	a5,s6,56d2 <gets+0x22>
  for(i=0; i+1 < max; ){
    5700:	89a6                	mv	s3,s1
    5702:	a011                	j	5706 <gets+0x56>
    5704:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5706:	99de                	add	s3,s3,s7
    5708:	00098023          	sb	zero,0(s3)
  return buf;
}
    570c:	855e                	mv	a0,s7
    570e:	60e6                	ld	ra,88(sp)
    5710:	6446                	ld	s0,80(sp)
    5712:	64a6                	ld	s1,72(sp)
    5714:	6906                	ld	s2,64(sp)
    5716:	79e2                	ld	s3,56(sp)
    5718:	7a42                	ld	s4,48(sp)
    571a:	7aa2                	ld	s5,40(sp)
    571c:	7b02                	ld	s6,32(sp)
    571e:	6be2                	ld	s7,24(sp)
    5720:	6125                	addi	sp,sp,96
    5722:	8082                	ret

0000000000005724 <stat>:

int
stat(const char *n, struct stat *st)
{
    5724:	1101                	addi	sp,sp,-32
    5726:	ec06                	sd	ra,24(sp)
    5728:	e822                	sd	s0,16(sp)
    572a:	e426                	sd	s1,8(sp)
    572c:	e04a                	sd	s2,0(sp)
    572e:	1000                	addi	s0,sp,32
    5730:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5732:	4581                	li	a1,0
    5734:	00000097          	auipc	ra,0x0
    5738:	176080e7          	jalr	374(ra) # 58aa <open>
  if(fd < 0)
    573c:	02054563          	bltz	a0,5766 <stat+0x42>
    5740:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5742:	85ca                	mv	a1,s2
    5744:	00000097          	auipc	ra,0x0
    5748:	17e080e7          	jalr	382(ra) # 58c2 <fstat>
    574c:	892a                	mv	s2,a0
  close(fd);
    574e:	8526                	mv	a0,s1
    5750:	00000097          	auipc	ra,0x0
    5754:	142080e7          	jalr	322(ra) # 5892 <close>
  return r;
}
    5758:	854a                	mv	a0,s2
    575a:	60e2                	ld	ra,24(sp)
    575c:	6442                	ld	s0,16(sp)
    575e:	64a2                	ld	s1,8(sp)
    5760:	6902                	ld	s2,0(sp)
    5762:	6105                	addi	sp,sp,32
    5764:	8082                	ret
    return -1;
    5766:	597d                	li	s2,-1
    5768:	bfc5                	j	5758 <stat+0x34>

000000000000576a <atoi>:

int
atoi(const char *s)
{
    576a:	1141                	addi	sp,sp,-16
    576c:	e422                	sd	s0,8(sp)
    576e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5770:	00054603          	lbu	a2,0(a0)
    5774:	fd06079b          	addiw	a5,a2,-48
    5778:	0ff7f793          	andi	a5,a5,255
    577c:	4725                	li	a4,9
    577e:	02f76963          	bltu	a4,a5,57b0 <atoi+0x46>
    5782:	86aa                	mv	a3,a0
  n = 0;
    5784:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    5786:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5788:	0685                	addi	a3,a3,1
    578a:	0025179b          	slliw	a5,a0,0x2
    578e:	9fa9                	addw	a5,a5,a0
    5790:	0017979b          	slliw	a5,a5,0x1
    5794:	9fb1                	addw	a5,a5,a2
    5796:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    579a:	0006c603          	lbu	a2,0(a3) # 1000 <bigdir+0x86>
    579e:	fd06071b          	addiw	a4,a2,-48
    57a2:	0ff77713          	andi	a4,a4,255
    57a6:	fee5f1e3          	bgeu	a1,a4,5788 <atoi+0x1e>
  return n;
}
    57aa:	6422                	ld	s0,8(sp)
    57ac:	0141                	addi	sp,sp,16
    57ae:	8082                	ret
  n = 0;
    57b0:	4501                	li	a0,0
    57b2:	bfe5                	j	57aa <atoi+0x40>

00000000000057b4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    57b4:	1141                	addi	sp,sp,-16
    57b6:	e422                	sd	s0,8(sp)
    57b8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    57ba:	02b57663          	bgeu	a0,a1,57e6 <memmove+0x32>
    while(n-- > 0)
    57be:	02c05163          	blez	a2,57e0 <memmove+0x2c>
    57c2:	fff6079b          	addiw	a5,a2,-1
    57c6:	1782                	slli	a5,a5,0x20
    57c8:	9381                	srli	a5,a5,0x20
    57ca:	0785                	addi	a5,a5,1
    57cc:	97aa                	add	a5,a5,a0
  dst = vdst;
    57ce:	872a                	mv	a4,a0
      *dst++ = *src++;
    57d0:	0585                	addi	a1,a1,1
    57d2:	0705                	addi	a4,a4,1
    57d4:	fff5c683          	lbu	a3,-1(a1)
    57d8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    57dc:	fee79ae3          	bne	a5,a4,57d0 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    57e0:	6422                	ld	s0,8(sp)
    57e2:	0141                	addi	sp,sp,16
    57e4:	8082                	ret
    dst += n;
    57e6:	00c50733          	add	a4,a0,a2
    src += n;
    57ea:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    57ec:	fec05ae3          	blez	a2,57e0 <memmove+0x2c>
    57f0:	fff6079b          	addiw	a5,a2,-1
    57f4:	1782                	slli	a5,a5,0x20
    57f6:	9381                	srli	a5,a5,0x20
    57f8:	fff7c793          	not	a5,a5
    57fc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    57fe:	15fd                	addi	a1,a1,-1
    5800:	177d                	addi	a4,a4,-1
    5802:	0005c683          	lbu	a3,0(a1)
    5806:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    580a:	fee79ae3          	bne	a5,a4,57fe <memmove+0x4a>
    580e:	bfc9                	j	57e0 <memmove+0x2c>

0000000000005810 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5810:	1141                	addi	sp,sp,-16
    5812:	e422                	sd	s0,8(sp)
    5814:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5816:	ca05                	beqz	a2,5846 <memcmp+0x36>
    5818:	fff6069b          	addiw	a3,a2,-1
    581c:	1682                	slli	a3,a3,0x20
    581e:	9281                	srli	a3,a3,0x20
    5820:	0685                	addi	a3,a3,1
    5822:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5824:	00054783          	lbu	a5,0(a0)
    5828:	0005c703          	lbu	a4,0(a1)
    582c:	00e79863          	bne	a5,a4,583c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5830:	0505                	addi	a0,a0,1
    p2++;
    5832:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5834:	fed518e3          	bne	a0,a3,5824 <memcmp+0x14>
  }
  return 0;
    5838:	4501                	li	a0,0
    583a:	a019                	j	5840 <memcmp+0x30>
      return *p1 - *p2;
    583c:	40e7853b          	subw	a0,a5,a4
}
    5840:	6422                	ld	s0,8(sp)
    5842:	0141                	addi	sp,sp,16
    5844:	8082                	ret
  return 0;
    5846:	4501                	li	a0,0
    5848:	bfe5                	j	5840 <memcmp+0x30>

000000000000584a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    584a:	1141                	addi	sp,sp,-16
    584c:	e406                	sd	ra,8(sp)
    584e:	e022                	sd	s0,0(sp)
    5850:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5852:	00000097          	auipc	ra,0x0
    5856:	f62080e7          	jalr	-158(ra) # 57b4 <memmove>
}
    585a:	60a2                	ld	ra,8(sp)
    585c:	6402                	ld	s0,0(sp)
    585e:	0141                	addi	sp,sp,16
    5860:	8082                	ret

0000000000005862 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5862:	4885                	li	a7,1
 ecall
    5864:	00000073          	ecall
 ret
    5868:	8082                	ret

000000000000586a <exit>:
.global exit
exit:
 li a7, SYS_exit
    586a:	4889                	li	a7,2
 ecall
    586c:	00000073          	ecall
 ret
    5870:	8082                	ret

0000000000005872 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5872:	488d                	li	a7,3
 ecall
    5874:	00000073          	ecall
 ret
    5878:	8082                	ret

000000000000587a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    587a:	4891                	li	a7,4
 ecall
    587c:	00000073          	ecall
 ret
    5880:	8082                	ret

0000000000005882 <read>:
.global read
read:
 li a7, SYS_read
    5882:	4895                	li	a7,5
 ecall
    5884:	00000073          	ecall
 ret
    5888:	8082                	ret

000000000000588a <write>:
.global write
write:
 li a7, SYS_write
    588a:	48c1                	li	a7,16
 ecall
    588c:	00000073          	ecall
 ret
    5890:	8082                	ret

0000000000005892 <close>:
.global close
close:
 li a7, SYS_close
    5892:	48d5                	li	a7,21
 ecall
    5894:	00000073          	ecall
 ret
    5898:	8082                	ret

000000000000589a <kill>:
.global kill
kill:
 li a7, SYS_kill
    589a:	4899                	li	a7,6
 ecall
    589c:	00000073          	ecall
 ret
    58a0:	8082                	ret

00000000000058a2 <exec>:
.global exec
exec:
 li a7, SYS_exec
    58a2:	489d                	li	a7,7
 ecall
    58a4:	00000073          	ecall
 ret
    58a8:	8082                	ret

00000000000058aa <open>:
.global open
open:
 li a7, SYS_open
    58aa:	48bd                	li	a7,15
 ecall
    58ac:	00000073          	ecall
 ret
    58b0:	8082                	ret

00000000000058b2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    58b2:	48c5                	li	a7,17
 ecall
    58b4:	00000073          	ecall
 ret
    58b8:	8082                	ret

00000000000058ba <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    58ba:	48c9                	li	a7,18
 ecall
    58bc:	00000073          	ecall
 ret
    58c0:	8082                	ret

00000000000058c2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    58c2:	48a1                	li	a7,8
 ecall
    58c4:	00000073          	ecall
 ret
    58c8:	8082                	ret

00000000000058ca <link>:
.global link
link:
 li a7, SYS_link
    58ca:	48cd                	li	a7,19
 ecall
    58cc:	00000073          	ecall
 ret
    58d0:	8082                	ret

00000000000058d2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    58d2:	48d1                	li	a7,20
 ecall
    58d4:	00000073          	ecall
 ret
    58d8:	8082                	ret

00000000000058da <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    58da:	48a5                	li	a7,9
 ecall
    58dc:	00000073          	ecall
 ret
    58e0:	8082                	ret

00000000000058e2 <dup>:
.global dup
dup:
 li a7, SYS_dup
    58e2:	48a9                	li	a7,10
 ecall
    58e4:	00000073          	ecall
 ret
    58e8:	8082                	ret

00000000000058ea <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    58ea:	48ad                	li	a7,11
 ecall
    58ec:	00000073          	ecall
 ret
    58f0:	8082                	ret

00000000000058f2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    58f2:	48b1                	li	a7,12
 ecall
    58f4:	00000073          	ecall
 ret
    58f8:	8082                	ret

00000000000058fa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    58fa:	48b5                	li	a7,13
 ecall
    58fc:	00000073          	ecall
 ret
    5900:	8082                	ret

0000000000005902 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5902:	48b9                	li	a7,14
 ecall
    5904:	00000073          	ecall
 ret
    5908:	8082                	ret

000000000000590a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    590a:	1101                	addi	sp,sp,-32
    590c:	ec06                	sd	ra,24(sp)
    590e:	e822                	sd	s0,16(sp)
    5910:	1000                	addi	s0,sp,32
    5912:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5916:	4605                	li	a2,1
    5918:	fef40593          	addi	a1,s0,-17
    591c:	00000097          	auipc	ra,0x0
    5920:	f6e080e7          	jalr	-146(ra) # 588a <write>
}
    5924:	60e2                	ld	ra,24(sp)
    5926:	6442                	ld	s0,16(sp)
    5928:	6105                	addi	sp,sp,32
    592a:	8082                	ret

000000000000592c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    592c:	7139                	addi	sp,sp,-64
    592e:	fc06                	sd	ra,56(sp)
    5930:	f822                	sd	s0,48(sp)
    5932:	f426                	sd	s1,40(sp)
    5934:	f04a                	sd	s2,32(sp)
    5936:	ec4e                	sd	s3,24(sp)
    5938:	0080                	addi	s0,sp,64
    593a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    593c:	c299                	beqz	a3,5942 <printint+0x16>
    593e:	0805c863          	bltz	a1,59ce <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5942:	2581                	sext.w	a1,a1
  neg = 0;
    5944:	4881                	li	a7,0
    5946:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    594a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    594c:	2601                	sext.w	a2,a2
    594e:	00003517          	auipc	a0,0x3
    5952:	c1a50513          	addi	a0,a0,-998 # 8568 <digits>
    5956:	883a                	mv	a6,a4
    5958:	2705                	addiw	a4,a4,1
    595a:	02c5f7bb          	remuw	a5,a1,a2
    595e:	1782                	slli	a5,a5,0x20
    5960:	9381                	srli	a5,a5,0x20
    5962:	97aa                	add	a5,a5,a0
    5964:	0007c783          	lbu	a5,0(a5)
    5968:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    596c:	0005879b          	sext.w	a5,a1
    5970:	02c5d5bb          	divuw	a1,a1,a2
    5974:	0685                	addi	a3,a3,1
    5976:	fec7f0e3          	bgeu	a5,a2,5956 <printint+0x2a>
  if(neg)
    597a:	00088b63          	beqz	a7,5990 <printint+0x64>
    buf[i++] = '-';
    597e:	fd040793          	addi	a5,s0,-48
    5982:	973e                	add	a4,a4,a5
    5984:	02d00793          	li	a5,45
    5988:	fef70823          	sb	a5,-16(a4)
    598c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5990:	02e05863          	blez	a4,59c0 <printint+0x94>
    5994:	fc040793          	addi	a5,s0,-64
    5998:	00e78933          	add	s2,a5,a4
    599c:	fff78993          	addi	s3,a5,-1
    59a0:	99ba                	add	s3,s3,a4
    59a2:	377d                	addiw	a4,a4,-1
    59a4:	1702                	slli	a4,a4,0x20
    59a6:	9301                	srli	a4,a4,0x20
    59a8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    59ac:	fff94583          	lbu	a1,-1(s2)
    59b0:	8526                	mv	a0,s1
    59b2:	00000097          	auipc	ra,0x0
    59b6:	f58080e7          	jalr	-168(ra) # 590a <putc>
  while(--i >= 0)
    59ba:	197d                	addi	s2,s2,-1
    59bc:	ff3918e3          	bne	s2,s3,59ac <printint+0x80>
}
    59c0:	70e2                	ld	ra,56(sp)
    59c2:	7442                	ld	s0,48(sp)
    59c4:	74a2                	ld	s1,40(sp)
    59c6:	7902                	ld	s2,32(sp)
    59c8:	69e2                	ld	s3,24(sp)
    59ca:	6121                	addi	sp,sp,64
    59cc:	8082                	ret
    x = -xx;
    59ce:	40b005bb          	negw	a1,a1
    neg = 1;
    59d2:	4885                	li	a7,1
    x = -xx;
    59d4:	bf8d                	j	5946 <printint+0x1a>

00000000000059d6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    59d6:	7119                	addi	sp,sp,-128
    59d8:	fc86                	sd	ra,120(sp)
    59da:	f8a2                	sd	s0,112(sp)
    59dc:	f4a6                	sd	s1,104(sp)
    59de:	f0ca                	sd	s2,96(sp)
    59e0:	ecce                	sd	s3,88(sp)
    59e2:	e8d2                	sd	s4,80(sp)
    59e4:	e4d6                	sd	s5,72(sp)
    59e6:	e0da                	sd	s6,64(sp)
    59e8:	fc5e                	sd	s7,56(sp)
    59ea:	f862                	sd	s8,48(sp)
    59ec:	f466                	sd	s9,40(sp)
    59ee:	f06a                	sd	s10,32(sp)
    59f0:	ec6e                	sd	s11,24(sp)
    59f2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    59f4:	0005c903          	lbu	s2,0(a1)
    59f8:	18090f63          	beqz	s2,5b96 <vprintf+0x1c0>
    59fc:	8aaa                	mv	s5,a0
    59fe:	8b32                	mv	s6,a2
    5a00:	00158493          	addi	s1,a1,1
  state = 0;
    5a04:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5a06:	02500a13          	li	s4,37
      if(c == 'd'){
    5a0a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5a0e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5a12:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5a16:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5a1a:	00003b97          	auipc	s7,0x3
    5a1e:	b4eb8b93          	addi	s7,s7,-1202 # 8568 <digits>
    5a22:	a839                	j	5a40 <vprintf+0x6a>
        putc(fd, c);
    5a24:	85ca                	mv	a1,s2
    5a26:	8556                	mv	a0,s5
    5a28:	00000097          	auipc	ra,0x0
    5a2c:	ee2080e7          	jalr	-286(ra) # 590a <putc>
    5a30:	a019                	j	5a36 <vprintf+0x60>
    } else if(state == '%'){
    5a32:	01498f63          	beq	s3,s4,5a50 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5a36:	0485                	addi	s1,s1,1
    5a38:	fff4c903          	lbu	s2,-1(s1)
    5a3c:	14090d63          	beqz	s2,5b96 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5a40:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5a44:	fe0997e3          	bnez	s3,5a32 <vprintf+0x5c>
      if(c == '%'){
    5a48:	fd479ee3          	bne	a5,s4,5a24 <vprintf+0x4e>
        state = '%';
    5a4c:	89be                	mv	s3,a5
    5a4e:	b7e5                	j	5a36 <vprintf+0x60>
      if(c == 'd'){
    5a50:	05878063          	beq	a5,s8,5a90 <vprintf+0xba>
      } else if(c == 'l') {
    5a54:	05978c63          	beq	a5,s9,5aac <vprintf+0xd6>
      } else if(c == 'x') {
    5a58:	07a78863          	beq	a5,s10,5ac8 <vprintf+0xf2>
      } else if(c == 'p') {
    5a5c:	09b78463          	beq	a5,s11,5ae4 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    5a60:	07300713          	li	a4,115
    5a64:	0ce78663          	beq	a5,a4,5b30 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5a68:	06300713          	li	a4,99
    5a6c:	0ee78e63          	beq	a5,a4,5b68 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5a70:	11478863          	beq	a5,s4,5b80 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5a74:	85d2                	mv	a1,s4
    5a76:	8556                	mv	a0,s5
    5a78:	00000097          	auipc	ra,0x0
    5a7c:	e92080e7          	jalr	-366(ra) # 590a <putc>
        putc(fd, c);
    5a80:	85ca                	mv	a1,s2
    5a82:	8556                	mv	a0,s5
    5a84:	00000097          	auipc	ra,0x0
    5a88:	e86080e7          	jalr	-378(ra) # 590a <putc>
      }
      state = 0;
    5a8c:	4981                	li	s3,0
    5a8e:	b765                	j	5a36 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5a90:	008b0913          	addi	s2,s6,8
    5a94:	4685                	li	a3,1
    5a96:	4629                	li	a2,10
    5a98:	000b2583          	lw	a1,0(s6)
    5a9c:	8556                	mv	a0,s5
    5a9e:	00000097          	auipc	ra,0x0
    5aa2:	e8e080e7          	jalr	-370(ra) # 592c <printint>
    5aa6:	8b4a                	mv	s6,s2
      state = 0;
    5aa8:	4981                	li	s3,0
    5aaa:	b771                	j	5a36 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5aac:	008b0913          	addi	s2,s6,8
    5ab0:	4681                	li	a3,0
    5ab2:	4629                	li	a2,10
    5ab4:	000b2583          	lw	a1,0(s6)
    5ab8:	8556                	mv	a0,s5
    5aba:	00000097          	auipc	ra,0x0
    5abe:	e72080e7          	jalr	-398(ra) # 592c <printint>
    5ac2:	8b4a                	mv	s6,s2
      state = 0;
    5ac4:	4981                	li	s3,0
    5ac6:	bf85                	j	5a36 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5ac8:	008b0913          	addi	s2,s6,8
    5acc:	4681                	li	a3,0
    5ace:	4641                	li	a2,16
    5ad0:	000b2583          	lw	a1,0(s6)
    5ad4:	8556                	mv	a0,s5
    5ad6:	00000097          	auipc	ra,0x0
    5ada:	e56080e7          	jalr	-426(ra) # 592c <printint>
    5ade:	8b4a                	mv	s6,s2
      state = 0;
    5ae0:	4981                	li	s3,0
    5ae2:	bf91                	j	5a36 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5ae4:	008b0793          	addi	a5,s6,8
    5ae8:	f8f43423          	sd	a5,-120(s0)
    5aec:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5af0:	03000593          	li	a1,48
    5af4:	8556                	mv	a0,s5
    5af6:	00000097          	auipc	ra,0x0
    5afa:	e14080e7          	jalr	-492(ra) # 590a <putc>
  putc(fd, 'x');
    5afe:	85ea                	mv	a1,s10
    5b00:	8556                	mv	a0,s5
    5b02:	00000097          	auipc	ra,0x0
    5b06:	e08080e7          	jalr	-504(ra) # 590a <putc>
    5b0a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5b0c:	03c9d793          	srli	a5,s3,0x3c
    5b10:	97de                	add	a5,a5,s7
    5b12:	0007c583          	lbu	a1,0(a5)
    5b16:	8556                	mv	a0,s5
    5b18:	00000097          	auipc	ra,0x0
    5b1c:	df2080e7          	jalr	-526(ra) # 590a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5b20:	0992                	slli	s3,s3,0x4
    5b22:	397d                	addiw	s2,s2,-1
    5b24:	fe0914e3          	bnez	s2,5b0c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5b28:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5b2c:	4981                	li	s3,0
    5b2e:	b721                	j	5a36 <vprintf+0x60>
        s = va_arg(ap, char*);
    5b30:	008b0993          	addi	s3,s6,8
    5b34:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5b38:	02090163          	beqz	s2,5b5a <vprintf+0x184>
        while(*s != 0){
    5b3c:	00094583          	lbu	a1,0(s2)
    5b40:	c9a1                	beqz	a1,5b90 <vprintf+0x1ba>
          putc(fd, *s);
    5b42:	8556                	mv	a0,s5
    5b44:	00000097          	auipc	ra,0x0
    5b48:	dc6080e7          	jalr	-570(ra) # 590a <putc>
          s++;
    5b4c:	0905                	addi	s2,s2,1
        while(*s != 0){
    5b4e:	00094583          	lbu	a1,0(s2)
    5b52:	f9e5                	bnez	a1,5b42 <vprintf+0x16c>
        s = va_arg(ap, char*);
    5b54:	8b4e                	mv	s6,s3
      state = 0;
    5b56:	4981                	li	s3,0
    5b58:	bdf9                	j	5a36 <vprintf+0x60>
          s = "(null)";
    5b5a:	00003917          	auipc	s2,0x3
    5b5e:	a0690913          	addi	s2,s2,-1530 # 8560 <malloc+0x28c0>
        while(*s != 0){
    5b62:	02800593          	li	a1,40
    5b66:	bff1                	j	5b42 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5b68:	008b0913          	addi	s2,s6,8
    5b6c:	000b4583          	lbu	a1,0(s6)
    5b70:	8556                	mv	a0,s5
    5b72:	00000097          	auipc	ra,0x0
    5b76:	d98080e7          	jalr	-616(ra) # 590a <putc>
    5b7a:	8b4a                	mv	s6,s2
      state = 0;
    5b7c:	4981                	li	s3,0
    5b7e:	bd65                	j	5a36 <vprintf+0x60>
        putc(fd, c);
    5b80:	85d2                	mv	a1,s4
    5b82:	8556                	mv	a0,s5
    5b84:	00000097          	auipc	ra,0x0
    5b88:	d86080e7          	jalr	-634(ra) # 590a <putc>
      state = 0;
    5b8c:	4981                	li	s3,0
    5b8e:	b565                	j	5a36 <vprintf+0x60>
        s = va_arg(ap, char*);
    5b90:	8b4e                	mv	s6,s3
      state = 0;
    5b92:	4981                	li	s3,0
    5b94:	b54d                	j	5a36 <vprintf+0x60>
    }
  }
}
    5b96:	70e6                	ld	ra,120(sp)
    5b98:	7446                	ld	s0,112(sp)
    5b9a:	74a6                	ld	s1,104(sp)
    5b9c:	7906                	ld	s2,96(sp)
    5b9e:	69e6                	ld	s3,88(sp)
    5ba0:	6a46                	ld	s4,80(sp)
    5ba2:	6aa6                	ld	s5,72(sp)
    5ba4:	6b06                	ld	s6,64(sp)
    5ba6:	7be2                	ld	s7,56(sp)
    5ba8:	7c42                	ld	s8,48(sp)
    5baa:	7ca2                	ld	s9,40(sp)
    5bac:	7d02                	ld	s10,32(sp)
    5bae:	6de2                	ld	s11,24(sp)
    5bb0:	6109                	addi	sp,sp,128
    5bb2:	8082                	ret

0000000000005bb4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5bb4:	715d                	addi	sp,sp,-80
    5bb6:	ec06                	sd	ra,24(sp)
    5bb8:	e822                	sd	s0,16(sp)
    5bba:	1000                	addi	s0,sp,32
    5bbc:	e010                	sd	a2,0(s0)
    5bbe:	e414                	sd	a3,8(s0)
    5bc0:	e818                	sd	a4,16(s0)
    5bc2:	ec1c                	sd	a5,24(s0)
    5bc4:	03043023          	sd	a6,32(s0)
    5bc8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5bcc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5bd0:	8622                	mv	a2,s0
    5bd2:	00000097          	auipc	ra,0x0
    5bd6:	e04080e7          	jalr	-508(ra) # 59d6 <vprintf>
}
    5bda:	60e2                	ld	ra,24(sp)
    5bdc:	6442                	ld	s0,16(sp)
    5bde:	6161                	addi	sp,sp,80
    5be0:	8082                	ret

0000000000005be2 <printf>:

void
printf(const char *fmt, ...)
{
    5be2:	711d                	addi	sp,sp,-96
    5be4:	ec06                	sd	ra,24(sp)
    5be6:	e822                	sd	s0,16(sp)
    5be8:	1000                	addi	s0,sp,32
    5bea:	e40c                	sd	a1,8(s0)
    5bec:	e810                	sd	a2,16(s0)
    5bee:	ec14                	sd	a3,24(s0)
    5bf0:	f018                	sd	a4,32(s0)
    5bf2:	f41c                	sd	a5,40(s0)
    5bf4:	03043823          	sd	a6,48(s0)
    5bf8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5bfc:	00840613          	addi	a2,s0,8
    5c00:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5c04:	85aa                	mv	a1,a0
    5c06:	4505                	li	a0,1
    5c08:	00000097          	auipc	ra,0x0
    5c0c:	dce080e7          	jalr	-562(ra) # 59d6 <vprintf>
}
    5c10:	60e2                	ld	ra,24(sp)
    5c12:	6442                	ld	s0,16(sp)
    5c14:	6125                	addi	sp,sp,96
    5c16:	8082                	ret

0000000000005c18 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5c18:	1141                	addi	sp,sp,-16
    5c1a:	e422                	sd	s0,8(sp)
    5c1c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5c1e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5c22:	00003797          	auipc	a5,0x3
    5c26:	9667b783          	ld	a5,-1690(a5) # 8588 <freep>
    5c2a:	a805                	j	5c5a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5c2c:	4618                	lw	a4,8(a2)
    5c2e:	9db9                	addw	a1,a1,a4
    5c30:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5c34:	6398                	ld	a4,0(a5)
    5c36:	6318                	ld	a4,0(a4)
    5c38:	fee53823          	sd	a4,-16(a0)
    5c3c:	a091                	j	5c80 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5c3e:	ff852703          	lw	a4,-8(a0)
    5c42:	9e39                	addw	a2,a2,a4
    5c44:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5c46:	ff053703          	ld	a4,-16(a0)
    5c4a:	e398                	sd	a4,0(a5)
    5c4c:	a099                	j	5c92 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5c4e:	6398                	ld	a4,0(a5)
    5c50:	00e7e463          	bltu	a5,a4,5c58 <free+0x40>
    5c54:	00e6ea63          	bltu	a3,a4,5c68 <free+0x50>
{
    5c58:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5c5a:	fed7fae3          	bgeu	a5,a3,5c4e <free+0x36>
    5c5e:	6398                	ld	a4,0(a5)
    5c60:	00e6e463          	bltu	a3,a4,5c68 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5c64:	fee7eae3          	bltu	a5,a4,5c58 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5c68:	ff852583          	lw	a1,-8(a0)
    5c6c:	6390                	ld	a2,0(a5)
    5c6e:	02059713          	slli	a4,a1,0x20
    5c72:	9301                	srli	a4,a4,0x20
    5c74:	0712                	slli	a4,a4,0x4
    5c76:	9736                	add	a4,a4,a3
    5c78:	fae60ae3          	beq	a2,a4,5c2c <free+0x14>
    bp->s.ptr = p->s.ptr;
    5c7c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5c80:	4790                	lw	a2,8(a5)
    5c82:	02061713          	slli	a4,a2,0x20
    5c86:	9301                	srli	a4,a4,0x20
    5c88:	0712                	slli	a4,a4,0x4
    5c8a:	973e                	add	a4,a4,a5
    5c8c:	fae689e3          	beq	a3,a4,5c3e <free+0x26>
  } else
    p->s.ptr = bp;
    5c90:	e394                	sd	a3,0(a5)
  freep = p;
    5c92:	00003717          	auipc	a4,0x3
    5c96:	8ef73b23          	sd	a5,-1802(a4) # 8588 <freep>
}
    5c9a:	6422                	ld	s0,8(sp)
    5c9c:	0141                	addi	sp,sp,16
    5c9e:	8082                	ret

0000000000005ca0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5ca0:	7139                	addi	sp,sp,-64
    5ca2:	fc06                	sd	ra,56(sp)
    5ca4:	f822                	sd	s0,48(sp)
    5ca6:	f426                	sd	s1,40(sp)
    5ca8:	f04a                	sd	s2,32(sp)
    5caa:	ec4e                	sd	s3,24(sp)
    5cac:	e852                	sd	s4,16(sp)
    5cae:	e456                	sd	s5,8(sp)
    5cb0:	e05a                	sd	s6,0(sp)
    5cb2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5cb4:	02051493          	slli	s1,a0,0x20
    5cb8:	9081                	srli	s1,s1,0x20
    5cba:	04bd                	addi	s1,s1,15
    5cbc:	8091                	srli	s1,s1,0x4
    5cbe:	0014899b          	addiw	s3,s1,1
    5cc2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5cc4:	00003517          	auipc	a0,0x3
    5cc8:	8c453503          	ld	a0,-1852(a0) # 8588 <freep>
    5ccc:	c515                	beqz	a0,5cf8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5cce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5cd0:	4798                	lw	a4,8(a5)
    5cd2:	02977f63          	bgeu	a4,s1,5d10 <malloc+0x70>
    5cd6:	8a4e                	mv	s4,s3
    5cd8:	0009871b          	sext.w	a4,s3
    5cdc:	6685                	lui	a3,0x1
    5cde:	00d77363          	bgeu	a4,a3,5ce4 <malloc+0x44>
    5ce2:	6a05                	lui	s4,0x1
    5ce4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5ce8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5cec:	00003917          	auipc	s2,0x3
    5cf0:	89c90913          	addi	s2,s2,-1892 # 8588 <freep>
  if(p == (char*)-1)
    5cf4:	5afd                	li	s5,-1
    5cf6:	a88d                	j	5d68 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    5cf8:	00009797          	auipc	a5,0x9
    5cfc:	0b078793          	addi	a5,a5,176 # eda8 <base>
    5d00:	00003717          	auipc	a4,0x3
    5d04:	88f73423          	sd	a5,-1912(a4) # 8588 <freep>
    5d08:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5d0a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5d0e:	b7e1                	j	5cd6 <malloc+0x36>
      if(p->s.size == nunits)
    5d10:	02e48b63          	beq	s1,a4,5d46 <malloc+0xa6>
        p->s.size -= nunits;
    5d14:	4137073b          	subw	a4,a4,s3
    5d18:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5d1a:	1702                	slli	a4,a4,0x20
    5d1c:	9301                	srli	a4,a4,0x20
    5d1e:	0712                	slli	a4,a4,0x4
    5d20:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5d22:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5d26:	00003717          	auipc	a4,0x3
    5d2a:	86a73123          	sd	a0,-1950(a4) # 8588 <freep>
      return (void*)(p + 1);
    5d2e:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5d32:	70e2                	ld	ra,56(sp)
    5d34:	7442                	ld	s0,48(sp)
    5d36:	74a2                	ld	s1,40(sp)
    5d38:	7902                	ld	s2,32(sp)
    5d3a:	69e2                	ld	s3,24(sp)
    5d3c:	6a42                	ld	s4,16(sp)
    5d3e:	6aa2                	ld	s5,8(sp)
    5d40:	6b02                	ld	s6,0(sp)
    5d42:	6121                	addi	sp,sp,64
    5d44:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5d46:	6398                	ld	a4,0(a5)
    5d48:	e118                	sd	a4,0(a0)
    5d4a:	bff1                	j	5d26 <malloc+0x86>
  hp->s.size = nu;
    5d4c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5d50:	0541                	addi	a0,a0,16
    5d52:	00000097          	auipc	ra,0x0
    5d56:	ec6080e7          	jalr	-314(ra) # 5c18 <free>
  return freep;
    5d5a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5d5e:	d971                	beqz	a0,5d32 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5d60:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5d62:	4798                	lw	a4,8(a5)
    5d64:	fa9776e3          	bgeu	a4,s1,5d10 <malloc+0x70>
    if(p == freep)
    5d68:	00093703          	ld	a4,0(s2)
    5d6c:	853e                	mv	a0,a5
    5d6e:	fef719e3          	bne	a4,a5,5d60 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    5d72:	8552                	mv	a0,s4
    5d74:	00000097          	auipc	ra,0x0
    5d78:	b7e080e7          	jalr	-1154(ra) # 58f2 <sbrk>
  if(p == (char*)-1)
    5d7c:	fd5518e3          	bne	a0,s5,5d4c <malloc+0xac>
        return 0;
    5d80:	4501                	li	a0,0
    5d82:	bf45                	j	5d32 <malloc+0x92>
