
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
      14:	884080e7          	jalr	-1916(ra) # 5894 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	872080e7          	jalr	-1934(ra) # 5894 <open>
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
      42:	09a50513          	addi	a0,a0,154 # 60d8 <malloc+0x446>
      46:	00006097          	auipc	ra,0x6
      4a:	b8e080e7          	jalr	-1138(ra) # 5bd4 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	804080e7          	jalr	-2044(ra) # 5854 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	63078793          	addi	a5,a5,1584 # 9688 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	d3868693          	addi	a3,a3,-712 # bd98 <buf>
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
      84:	07850513          	addi	a0,a0,120 # 60f8 <malloc+0x466>
      88:	00006097          	auipc	ra,0x6
      8c:	b4c080e7          	jalr	-1204(ra) # 5bd4 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	7c2080e7          	jalr	1986(ra) # 5854 <exit>

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
      ac:	06850513          	addi	a0,a0,104 # 6110 <malloc+0x47e>
      b0:	00005097          	auipc	ra,0x5
      b4:	7e4080e7          	jalr	2020(ra) # 5894 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	7c0080e7          	jalr	1984(ra) # 587c <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	06a50513          	addi	a0,a0,106 # 6130 <malloc+0x49e>
      ce:	00005097          	auipc	ra,0x5
      d2:	7c6080e7          	jalr	1990(ra) # 5894 <open>
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
      ea:	03250513          	addi	a0,a0,50 # 6118 <malloc+0x486>
      ee:	00006097          	auipc	ra,0x6
      f2:	ae6080e7          	jalr	-1306(ra) # 5bd4 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	75c080e7          	jalr	1884(ra) # 5854 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	03e50513          	addi	a0,a0,62 # 6140 <malloc+0x4ae>
     10a:	00006097          	auipc	ra,0x6
     10e:	aca080e7          	jalr	-1334(ra) # 5bd4 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	740080e7          	jalr	1856(ra) # 5854 <exit>

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
     130:	03c50513          	addi	a0,a0,60 # 6168 <malloc+0x4d6>
     134:	00005097          	auipc	ra,0x5
     138:	770080e7          	jalr	1904(ra) # 58a4 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	02850513          	addi	a0,a0,40 # 6168 <malloc+0x4d6>
     148:	00005097          	auipc	ra,0x5
     14c:	74c080e7          	jalr	1868(ra) # 5894 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	02458593          	addi	a1,a1,36 # 6178 <malloc+0x4e6>
     15c:	00005097          	auipc	ra,0x5
     160:	718080e7          	jalr	1816(ra) # 5874 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	00050513          	mv	a0,a0
     170:	00005097          	auipc	ra,0x5
     174:	724080e7          	jalr	1828(ra) # 5894 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	00458593          	addi	a1,a1,4 # 6180 <malloc+0x4ee>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	6ee080e7          	jalr	1774(ra) # 5874 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	fd450513          	addi	a0,a0,-44 # 6168 <malloc+0x4d6>
     19c:	00005097          	auipc	ra,0x5
     1a0:	708080e7          	jalr	1800(ra) # 58a4 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	6d6080e7          	jalr	1750(ra) # 587c <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	6cc080e7          	jalr	1740(ra) # 587c <close>
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
     1ce:	fbe50513          	addi	a0,a0,-66 # 6188 <malloc+0x4f6>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	a02080e7          	jalr	-1534(ra) # 5bd4 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	678080e7          	jalr	1656(ra) # 5854 <exit>

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
     214:	684080e7          	jalr	1668(ra) # 5894 <open>
    close(fd);
     218:	00005097          	auipc	ra,0x5
     21c:	664080e7          	jalr	1636(ra) # 587c <close>
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
     24a:	65e080e7          	jalr	1630(ra) # 58a4 <unlink>
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
     280:	cdc50513          	addi	a0,a0,-804 # 5f58 <malloc+0x2c6>
     284:	00005097          	auipc	ra,0x5
     288:	620080e7          	jalr	1568(ra) # 58a4 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	cc8a8a93          	addi	s5,s5,-824 # 5f58 <malloc+0x2c6>
      int cc = write(fd, buf, sz);
     298:	0000ca17          	auipc	s4,0xc
     29c:	b00a0a13          	addi	s4,s4,-1280 # bd98 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <dirtest+0x8d>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00005097          	auipc	ra,0x5
     2b0:	5e8080e7          	jalr	1512(ra) # 5894 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00005097          	auipc	ra,0x5
     2c2:	5b6080e7          	jalr	1462(ra) # 5874 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49463          	bne	s1,a0,330 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00005097          	auipc	ra,0x5
     2d6:	5a2080e7          	jalr	1442(ra) # 5874 <write>
      if(cc != sz){
     2da:	04951963          	bne	a0,s1,32c <bigwrite+0xc8>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00005097          	auipc	ra,0x5
     2e4:	59c080e7          	jalr	1436(ra) # 587c <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00005097          	auipc	ra,0x5
     2ee:	5ba080e7          	jalr	1466(ra) # 58a4 <unlink>
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
     316:	e9e50513          	addi	a0,a0,-354 # 61b0 <malloc+0x51e>
     31a:	00006097          	auipc	ra,0x6
     31e:	8ba080e7          	jalr	-1862(ra) # 5bd4 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	530080e7          	jalr	1328(ra) # 5854 <exit>
     32c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     32e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     330:	86ce                	mv	a3,s3
     332:	8626                	mv	a2,s1
     334:	85de                	mv	a1,s7
     336:	00006517          	auipc	a0,0x6
     33a:	e9a50513          	addi	a0,a0,-358 # 61d0 <malloc+0x53e>
     33e:	00006097          	auipc	ra,0x6
     342:	896080e7          	jalr	-1898(ra) # 5bd4 <printf>
        exit(1);
     346:	4505                	li	a0,1
     348:	00005097          	auipc	ra,0x5
     34c:	50c080e7          	jalr	1292(ra) # 5854 <exit>

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
     376:	e76a0a13          	addi	s4,s4,-394 # 61e8 <malloc+0x556>
    uint64 addr = addrs[ai];
     37a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     37e:	20100593          	li	a1,513
     382:	8552                	mv	a0,s4
     384:	00005097          	auipc	ra,0x5
     388:	510080e7          	jalr	1296(ra) # 5894 <open>
     38c:	84aa                	mv	s1,a0
    if(fd < 0){
     38e:	08054863          	bltz	a0,41e <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     392:	6609                	lui	a2,0x2
     394:	85ce                	mv	a1,s3
     396:	00005097          	auipc	ra,0x5
     39a:	4de080e7          	jalr	1246(ra) # 5874 <write>
    if(n >= 0){
     39e:	08055d63          	bgez	a0,438 <copyin+0xe8>
    close(fd);
     3a2:	8526                	mv	a0,s1
     3a4:	00005097          	auipc	ra,0x5
     3a8:	4d8080e7          	jalr	1240(ra) # 587c <close>
    unlink("copyin1");
     3ac:	8552                	mv	a0,s4
     3ae:	00005097          	auipc	ra,0x5
     3b2:	4f6080e7          	jalr	1270(ra) # 58a4 <unlink>
    n = write(1, (char*)addr, 8192);
     3b6:	6609                	lui	a2,0x2
     3b8:	85ce                	mv	a1,s3
     3ba:	4505                	li	a0,1
     3bc:	00005097          	auipc	ra,0x5
     3c0:	4b8080e7          	jalr	1208(ra) # 5874 <write>
    if(n > 0){
     3c4:	08a04963          	bgtz	a0,456 <copyin+0x106>
    if(pipe(fds) < 0){
     3c8:	fb840513          	addi	a0,s0,-72
     3cc:	00005097          	auipc	ra,0x5
     3d0:	498080e7          	jalr	1176(ra) # 5864 <pipe>
     3d4:	0a054063          	bltz	a0,474 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3d8:	6609                	lui	a2,0x2
     3da:	85ce                	mv	a1,s3
     3dc:	fbc42503          	lw	a0,-68(s0)
     3e0:	00005097          	auipc	ra,0x5
     3e4:	494080e7          	jalr	1172(ra) # 5874 <write>
    if(n > 0){
     3e8:	0aa04363          	bgtz	a0,48e <copyin+0x13e>
    close(fds[0]);
     3ec:	fb842503          	lw	a0,-72(s0)
     3f0:	00005097          	auipc	ra,0x5
     3f4:	48c080e7          	jalr	1164(ra) # 587c <close>
    close(fds[1]);
     3f8:	fbc42503          	lw	a0,-68(s0)
     3fc:	00005097          	auipc	ra,0x5
     400:	480080e7          	jalr	1152(ra) # 587c <close>
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
     422:	dd250513          	addi	a0,a0,-558 # 61f0 <malloc+0x55e>
     426:	00005097          	auipc	ra,0x5
     42a:	7ae080e7          	jalr	1966(ra) # 5bd4 <printf>
      exit(1);
     42e:	4505                	li	a0,1
     430:	00005097          	auipc	ra,0x5
     434:	424080e7          	jalr	1060(ra) # 5854 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     438:	862a                	mv	a2,a0
     43a:	85ce                	mv	a1,s3
     43c:	00006517          	auipc	a0,0x6
     440:	dcc50513          	addi	a0,a0,-564 # 6208 <malloc+0x576>
     444:	00005097          	auipc	ra,0x5
     448:	790080e7          	jalr	1936(ra) # 5bd4 <printf>
      exit(1);
     44c:	4505                	li	a0,1
     44e:	00005097          	auipc	ra,0x5
     452:	406080e7          	jalr	1030(ra) # 5854 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     456:	862a                	mv	a2,a0
     458:	85ce                	mv	a1,s3
     45a:	00006517          	auipc	a0,0x6
     45e:	dde50513          	addi	a0,a0,-546 # 6238 <malloc+0x5a6>
     462:	00005097          	auipc	ra,0x5
     466:	772080e7          	jalr	1906(ra) # 5bd4 <printf>
      exit(1);
     46a:	4505                	li	a0,1
     46c:	00005097          	auipc	ra,0x5
     470:	3e8080e7          	jalr	1000(ra) # 5854 <exit>
      printf("pipe() failed\n");
     474:	00006517          	auipc	a0,0x6
     478:	df450513          	addi	a0,a0,-524 # 6268 <malloc+0x5d6>
     47c:	00005097          	auipc	ra,0x5
     480:	758080e7          	jalr	1880(ra) # 5bd4 <printf>
      exit(1);
     484:	4505                	li	a0,1
     486:	00005097          	auipc	ra,0x5
     48a:	3ce080e7          	jalr	974(ra) # 5854 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     48e:	862a                	mv	a2,a0
     490:	85ce                	mv	a1,s3
     492:	00006517          	auipc	a0,0x6
     496:	de650513          	addi	a0,a0,-538 # 6278 <malloc+0x5e6>
     49a:	00005097          	auipc	ra,0x5
     49e:	73a080e7          	jalr	1850(ra) # 5bd4 <printf>
      exit(1);
     4a2:	4505                	li	a0,1
     4a4:	00005097          	auipc	ra,0x5
     4a8:	3b0080e7          	jalr	944(ra) # 5854 <exit>

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
     4d4:	dd8a0a13          	addi	s4,s4,-552 # 62a8 <malloc+0x616>
    n = write(fds[1], "x", 1);
     4d8:	00006a97          	auipc	s5,0x6
     4dc:	ca8a8a93          	addi	s5,s5,-856 # 6180 <malloc+0x4ee>
    uint64 addr = addrs[ai];
     4e0:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4e4:	4581                	li	a1,0
     4e6:	8552                	mv	a0,s4
     4e8:	00005097          	auipc	ra,0x5
     4ec:	3ac080e7          	jalr	940(ra) # 5894 <open>
     4f0:	84aa                	mv	s1,a0
    if(fd < 0){
     4f2:	08054663          	bltz	a0,57e <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     4f6:	6609                	lui	a2,0x2
     4f8:	85ce                	mv	a1,s3
     4fa:	00005097          	auipc	ra,0x5
     4fe:	372080e7          	jalr	882(ra) # 586c <read>
    if(n > 0){
     502:	08a04b63          	bgtz	a0,598 <copyout+0xec>
    close(fd);
     506:	8526                	mv	a0,s1
     508:	00005097          	auipc	ra,0x5
     50c:	374080e7          	jalr	884(ra) # 587c <close>
    if(pipe(fds) < 0){
     510:	fa840513          	addi	a0,s0,-88
     514:	00005097          	auipc	ra,0x5
     518:	350080e7          	jalr	848(ra) # 5864 <pipe>
     51c:	08054d63          	bltz	a0,5b6 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     520:	4605                	li	a2,1
     522:	85d6                	mv	a1,s5
     524:	fac42503          	lw	a0,-84(s0)
     528:	00005097          	auipc	ra,0x5
     52c:	34c080e7          	jalr	844(ra) # 5874 <write>
    if(n != 1){
     530:	4785                	li	a5,1
     532:	08f51f63          	bne	a0,a5,5d0 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     536:	6609                	lui	a2,0x2
     538:	85ce                	mv	a1,s3
     53a:	fa842503          	lw	a0,-88(s0)
     53e:	00005097          	auipc	ra,0x5
     542:	32e080e7          	jalr	814(ra) # 586c <read>
    if(n > 0){
     546:	0aa04263          	bgtz	a0,5ea <copyout+0x13e>
    close(fds[0]);
     54a:	fa842503          	lw	a0,-88(s0)
     54e:	00005097          	auipc	ra,0x5
     552:	32e080e7          	jalr	814(ra) # 587c <close>
    close(fds[1]);
     556:	fac42503          	lw	a0,-84(s0)
     55a:	00005097          	auipc	ra,0x5
     55e:	322080e7          	jalr	802(ra) # 587c <close>
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
     582:	d3250513          	addi	a0,a0,-718 # 62b0 <malloc+0x61e>
     586:	00005097          	auipc	ra,0x5
     58a:	64e080e7          	jalr	1614(ra) # 5bd4 <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	00005097          	auipc	ra,0x5
     594:	2c4080e7          	jalr	708(ra) # 5854 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     598:	862a                	mv	a2,a0
     59a:	85ce                	mv	a1,s3
     59c:	00006517          	auipc	a0,0x6
     5a0:	d2c50513          	addi	a0,a0,-724 # 62c8 <malloc+0x636>
     5a4:	00005097          	auipc	ra,0x5
     5a8:	630080e7          	jalr	1584(ra) # 5bd4 <printf>
      exit(1);
     5ac:	4505                	li	a0,1
     5ae:	00005097          	auipc	ra,0x5
     5b2:	2a6080e7          	jalr	678(ra) # 5854 <exit>
      printf("pipe() failed\n");
     5b6:	00006517          	auipc	a0,0x6
     5ba:	cb250513          	addi	a0,a0,-846 # 6268 <malloc+0x5d6>
     5be:	00005097          	auipc	ra,0x5
     5c2:	616080e7          	jalr	1558(ra) # 5bd4 <printf>
      exit(1);
     5c6:	4505                	li	a0,1
     5c8:	00005097          	auipc	ra,0x5
     5cc:	28c080e7          	jalr	652(ra) # 5854 <exit>
      printf("pipe write failed\n");
     5d0:	00006517          	auipc	a0,0x6
     5d4:	d2850513          	addi	a0,a0,-728 # 62f8 <malloc+0x666>
     5d8:	00005097          	auipc	ra,0x5
     5dc:	5fc080e7          	jalr	1532(ra) # 5bd4 <printf>
      exit(1);
     5e0:	4505                	li	a0,1
     5e2:	00005097          	auipc	ra,0x5
     5e6:	272080e7          	jalr	626(ra) # 5854 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5ea:	862a                	mv	a2,a0
     5ec:	85ce                	mv	a1,s3
     5ee:	00006517          	auipc	a0,0x6
     5f2:	d2250513          	addi	a0,a0,-734 # 6310 <malloc+0x67e>
     5f6:	00005097          	auipc	ra,0x5
     5fa:	5de080e7          	jalr	1502(ra) # 5bd4 <printf>
      exit(1);
     5fe:	4505                	li	a0,1
     600:	00005097          	auipc	ra,0x5
     604:	254080e7          	jalr	596(ra) # 5854 <exit>

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
     620:	b4c50513          	addi	a0,a0,-1204 # 6168 <malloc+0x4d6>
     624:	00005097          	auipc	ra,0x5
     628:	280080e7          	jalr	640(ra) # 58a4 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     62c:	60100593          	li	a1,1537
     630:	00006517          	auipc	a0,0x6
     634:	b3850513          	addi	a0,a0,-1224 # 6168 <malloc+0x4d6>
     638:	00005097          	auipc	ra,0x5
     63c:	25c080e7          	jalr	604(ra) # 5894 <open>
     640:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     642:	4611                	li	a2,4
     644:	00006597          	auipc	a1,0x6
     648:	b3458593          	addi	a1,a1,-1228 # 6178 <malloc+0x4e6>
     64c:	00005097          	auipc	ra,0x5
     650:	228080e7          	jalr	552(ra) # 5874 <write>
  close(fd1);
     654:	8526                	mv	a0,s1
     656:	00005097          	auipc	ra,0x5
     65a:	226080e7          	jalr	550(ra) # 587c <close>
  int fd2 = open("truncfile", O_RDONLY);
     65e:	4581                	li	a1,0
     660:	00006517          	auipc	a0,0x6
     664:	b0850513          	addi	a0,a0,-1272 # 6168 <malloc+0x4d6>
     668:	00005097          	auipc	ra,0x5
     66c:	22c080e7          	jalr	556(ra) # 5894 <open>
     670:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     672:	02000613          	li	a2,32
     676:	fa040593          	addi	a1,s0,-96
     67a:	00005097          	auipc	ra,0x5
     67e:	1f2080e7          	jalr	498(ra) # 586c <read>
  if(n != 4){
     682:	4791                	li	a5,4
     684:	0cf51e63          	bne	a0,a5,760 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     688:	40100593          	li	a1,1025
     68c:	00006517          	auipc	a0,0x6
     690:	adc50513          	addi	a0,a0,-1316 # 6168 <malloc+0x4d6>
     694:	00005097          	auipc	ra,0x5
     698:	200080e7          	jalr	512(ra) # 5894 <open>
     69c:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     69e:	4581                	li	a1,0
     6a0:	00006517          	auipc	a0,0x6
     6a4:	ac850513          	addi	a0,a0,-1336 # 6168 <malloc+0x4d6>
     6a8:	00005097          	auipc	ra,0x5
     6ac:	1ec080e7          	jalr	492(ra) # 5894 <open>
     6b0:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6b2:	02000613          	li	a2,32
     6b6:	fa040593          	addi	a1,s0,-96
     6ba:	00005097          	auipc	ra,0x5
     6be:	1b2080e7          	jalr	434(ra) # 586c <read>
     6c2:	8a2a                	mv	s4,a0
  if(n != 0){
     6c4:	ed4d                	bnez	a0,77e <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6c6:	02000613          	li	a2,32
     6ca:	fa040593          	addi	a1,s0,-96
     6ce:	8526                	mv	a0,s1
     6d0:	00005097          	auipc	ra,0x5
     6d4:	19c080e7          	jalr	412(ra) # 586c <read>
     6d8:	8a2a                	mv	s4,a0
  if(n != 0){
     6da:	e971                	bnez	a0,7ae <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6dc:	4619                	li	a2,6
     6de:	00006597          	auipc	a1,0x6
     6e2:	cc258593          	addi	a1,a1,-830 # 63a0 <malloc+0x70e>
     6e6:	854e                	mv	a0,s3
     6e8:	00005097          	auipc	ra,0x5
     6ec:	18c080e7          	jalr	396(ra) # 5874 <write>
  n = read(fd3, buf, sizeof(buf));
     6f0:	02000613          	li	a2,32
     6f4:	fa040593          	addi	a1,s0,-96
     6f8:	854a                	mv	a0,s2
     6fa:	00005097          	auipc	ra,0x5
     6fe:	172080e7          	jalr	370(ra) # 586c <read>
  if(n != 6){
     702:	4799                	li	a5,6
     704:	0cf51d63          	bne	a0,a5,7de <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     708:	02000613          	li	a2,32
     70c:	fa040593          	addi	a1,s0,-96
     710:	8526                	mv	a0,s1
     712:	00005097          	auipc	ra,0x5
     716:	15a080e7          	jalr	346(ra) # 586c <read>
  if(n != 2){
     71a:	4789                	li	a5,2
     71c:	0ef51063          	bne	a0,a5,7fc <truncate1+0x1f4>
  unlink("truncfile");
     720:	00006517          	auipc	a0,0x6
     724:	a4850513          	addi	a0,a0,-1464 # 6168 <malloc+0x4d6>
     728:	00005097          	auipc	ra,0x5
     72c:	17c080e7          	jalr	380(ra) # 58a4 <unlink>
  close(fd1);
     730:	854e                	mv	a0,s3
     732:	00005097          	auipc	ra,0x5
     736:	14a080e7          	jalr	330(ra) # 587c <close>
  close(fd2);
     73a:	8526                	mv	a0,s1
     73c:	00005097          	auipc	ra,0x5
     740:	140080e7          	jalr	320(ra) # 587c <close>
  close(fd3);
     744:	854a                	mv	a0,s2
     746:	00005097          	auipc	ra,0x5
     74a:	136080e7          	jalr	310(ra) # 587c <close>
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
     768:	bdc50513          	addi	a0,a0,-1060 # 6340 <malloc+0x6ae>
     76c:	00005097          	auipc	ra,0x5
     770:	468080e7          	jalr	1128(ra) # 5bd4 <printf>
    exit(1);
     774:	4505                	li	a0,1
     776:	00005097          	auipc	ra,0x5
     77a:	0de080e7          	jalr	222(ra) # 5854 <exit>
    printf("aaa fd3=%d\n", fd3);
     77e:	85ca                	mv	a1,s2
     780:	00006517          	auipc	a0,0x6
     784:	be050513          	addi	a0,a0,-1056 # 6360 <malloc+0x6ce>
     788:	00005097          	auipc	ra,0x5
     78c:	44c080e7          	jalr	1100(ra) # 5bd4 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     790:	8652                	mv	a2,s4
     792:	85d6                	mv	a1,s5
     794:	00006517          	auipc	a0,0x6
     798:	bdc50513          	addi	a0,a0,-1060 # 6370 <malloc+0x6de>
     79c:	00005097          	auipc	ra,0x5
     7a0:	438080e7          	jalr	1080(ra) # 5bd4 <printf>
    exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	0ae080e7          	jalr	174(ra) # 5854 <exit>
    printf("bbb fd2=%d\n", fd2);
     7ae:	85a6                	mv	a1,s1
     7b0:	00006517          	auipc	a0,0x6
     7b4:	be050513          	addi	a0,a0,-1056 # 6390 <malloc+0x6fe>
     7b8:	00005097          	auipc	ra,0x5
     7bc:	41c080e7          	jalr	1052(ra) # 5bd4 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7c0:	8652                	mv	a2,s4
     7c2:	85d6                	mv	a1,s5
     7c4:	00006517          	auipc	a0,0x6
     7c8:	bac50513          	addi	a0,a0,-1108 # 6370 <malloc+0x6de>
     7cc:	00005097          	auipc	ra,0x5
     7d0:	408080e7          	jalr	1032(ra) # 5bd4 <printf>
    exit(1);
     7d4:	4505                	li	a0,1
     7d6:	00005097          	auipc	ra,0x5
     7da:	07e080e7          	jalr	126(ra) # 5854 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7de:	862a                	mv	a2,a0
     7e0:	85d6                	mv	a1,s5
     7e2:	00006517          	auipc	a0,0x6
     7e6:	bc650513          	addi	a0,a0,-1082 # 63a8 <malloc+0x716>
     7ea:	00005097          	auipc	ra,0x5
     7ee:	3ea080e7          	jalr	1002(ra) # 5bd4 <printf>
    exit(1);
     7f2:	4505                	li	a0,1
     7f4:	00005097          	auipc	ra,0x5
     7f8:	060080e7          	jalr	96(ra) # 5854 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     7fc:	862a                	mv	a2,a0
     7fe:	85d6                	mv	a1,s5
     800:	00006517          	auipc	a0,0x6
     804:	bc850513          	addi	a0,a0,-1080 # 63c8 <malloc+0x736>
     808:	00005097          	auipc	ra,0x5
     80c:	3cc080e7          	jalr	972(ra) # 5bd4 <printf>
    exit(1);
     810:	4505                	li	a0,1
     812:	00005097          	auipc	ra,0x5
     816:	042080e7          	jalr	66(ra) # 5854 <exit>

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
     838:	bb450513          	addi	a0,a0,-1100 # 63e8 <malloc+0x756>
     83c:	00005097          	auipc	ra,0x5
     840:	058080e7          	jalr	88(ra) # 5894 <open>
  if(fd < 0){
     844:	0a054d63          	bltz	a0,8fe <writetest+0xe4>
     848:	892a                	mv	s2,a0
     84a:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     84c:	00006997          	auipc	s3,0x6
     850:	bc498993          	addi	s3,s3,-1084 # 6410 <malloc+0x77e>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     854:	00006a97          	auipc	s5,0x6
     858:	bf4a8a93          	addi	s5,s5,-1036 # 6448 <malloc+0x7b6>
  for(i = 0; i < N; i++){
     85c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     860:	4629                	li	a2,10
     862:	85ce                	mv	a1,s3
     864:	854a                	mv	a0,s2
     866:	00005097          	auipc	ra,0x5
     86a:	00e080e7          	jalr	14(ra) # 5874 <write>
     86e:	47a9                	li	a5,10
     870:	0af51563          	bne	a0,a5,91a <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     874:	4629                	li	a2,10
     876:	85d6                	mv	a1,s5
     878:	854a                	mv	a0,s2
     87a:	00005097          	auipc	ra,0x5
     87e:	ffa080e7          	jalr	-6(ra) # 5874 <write>
     882:	47a9                	li	a5,10
     884:	0af51a63          	bne	a0,a5,938 <writetest+0x11e>
  for(i = 0; i < N; i++){
     888:	2485                	addiw	s1,s1,1
     88a:	fd449be3          	bne	s1,s4,860 <writetest+0x46>
  close(fd);
     88e:	854a                	mv	a0,s2
     890:	00005097          	auipc	ra,0x5
     894:	fec080e7          	jalr	-20(ra) # 587c <close>
  fd = open("small", O_RDONLY);
     898:	4581                	li	a1,0
     89a:	00006517          	auipc	a0,0x6
     89e:	b4e50513          	addi	a0,a0,-1202 # 63e8 <malloc+0x756>
     8a2:	00005097          	auipc	ra,0x5
     8a6:	ff2080e7          	jalr	-14(ra) # 5894 <open>
     8aa:	84aa                	mv	s1,a0
  if(fd < 0){
     8ac:	0a054563          	bltz	a0,956 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8b0:	7d000613          	li	a2,2000
     8b4:	0000b597          	auipc	a1,0xb
     8b8:	4e458593          	addi	a1,a1,1252 # bd98 <buf>
     8bc:	00005097          	auipc	ra,0x5
     8c0:	fb0080e7          	jalr	-80(ra) # 586c <read>
  if(i != N*SZ*2){
     8c4:	7d000793          	li	a5,2000
     8c8:	0af51563          	bne	a0,a5,972 <writetest+0x158>
  close(fd);
     8cc:	8526                	mv	a0,s1
     8ce:	00005097          	auipc	ra,0x5
     8d2:	fae080e7          	jalr	-82(ra) # 587c <close>
  if(unlink("small") < 0){
     8d6:	00006517          	auipc	a0,0x6
     8da:	b1250513          	addi	a0,a0,-1262 # 63e8 <malloc+0x756>
     8de:	00005097          	auipc	ra,0x5
     8e2:	fc6080e7          	jalr	-58(ra) # 58a4 <unlink>
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
     904:	af050513          	addi	a0,a0,-1296 # 63f0 <malloc+0x75e>
     908:	00005097          	auipc	ra,0x5
     90c:	2cc080e7          	jalr	716(ra) # 5bd4 <printf>
    exit(1);
     910:	4505                	li	a0,1
     912:	00005097          	auipc	ra,0x5
     916:	f42080e7          	jalr	-190(ra) # 5854 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     91a:	8626                	mv	a2,s1
     91c:	85da                	mv	a1,s6
     91e:	00006517          	auipc	a0,0x6
     922:	b0250513          	addi	a0,a0,-1278 # 6420 <malloc+0x78e>
     926:	00005097          	auipc	ra,0x5
     92a:	2ae080e7          	jalr	686(ra) # 5bd4 <printf>
      exit(1);
     92e:	4505                	li	a0,1
     930:	00005097          	auipc	ra,0x5
     934:	f24080e7          	jalr	-220(ra) # 5854 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     938:	8626                	mv	a2,s1
     93a:	85da                	mv	a1,s6
     93c:	00006517          	auipc	a0,0x6
     940:	b1c50513          	addi	a0,a0,-1252 # 6458 <malloc+0x7c6>
     944:	00005097          	auipc	ra,0x5
     948:	290080e7          	jalr	656(ra) # 5bd4 <printf>
      exit(1);
     94c:	4505                	li	a0,1
     94e:	00005097          	auipc	ra,0x5
     952:	f06080e7          	jalr	-250(ra) # 5854 <exit>
    printf("%s: error: open small failed!\n", s);
     956:	85da                	mv	a1,s6
     958:	00006517          	auipc	a0,0x6
     95c:	b2850513          	addi	a0,a0,-1240 # 6480 <malloc+0x7ee>
     960:	00005097          	auipc	ra,0x5
     964:	274080e7          	jalr	628(ra) # 5bd4 <printf>
    exit(1);
     968:	4505                	li	a0,1
     96a:	00005097          	auipc	ra,0x5
     96e:	eea080e7          	jalr	-278(ra) # 5854 <exit>
    printf("%s: read failed\n", s);
     972:	85da                	mv	a1,s6
     974:	00006517          	auipc	a0,0x6
     978:	b2c50513          	addi	a0,a0,-1236 # 64a0 <malloc+0x80e>
     97c:	00005097          	auipc	ra,0x5
     980:	258080e7          	jalr	600(ra) # 5bd4 <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00005097          	auipc	ra,0x5
     98a:	ece080e7          	jalr	-306(ra) # 5854 <exit>
    printf("%s: unlink small failed\n", s);
     98e:	85da                	mv	a1,s6
     990:	00006517          	auipc	a0,0x6
     994:	b2850513          	addi	a0,a0,-1240 # 64b8 <malloc+0x826>
     998:	00005097          	auipc	ra,0x5
     99c:	23c080e7          	jalr	572(ra) # 5bd4 <printf>
    exit(1);
     9a0:	4505                	li	a0,1
     9a2:	00005097          	auipc	ra,0x5
     9a6:	eb2080e7          	jalr	-334(ra) # 5854 <exit>

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
     9c6:	b1650513          	addi	a0,a0,-1258 # 64d8 <malloc+0x846>
     9ca:	00005097          	auipc	ra,0x5
     9ce:	eca080e7          	jalr	-310(ra) # 5894 <open>
  if(fd < 0){
     9d2:	08054563          	bltz	a0,a5c <writebig+0xb2>
     9d6:	89aa                	mv	s3,a0
     9d8:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9da:	0000b917          	auipc	s2,0xb
     9de:	3be90913          	addi	s2,s2,958 # bd98 <buf>
  for(i = 0; i < MAXFILE; i++){
     9e2:	6a41                	lui	s4,0x10
     9e4:	10ba0a13          	addi	s4,s4,267 # 1010b <__BSS_END__+0x1363>
    ((int*)buf)[0] = i;
     9e8:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9ec:	40000613          	li	a2,1024
     9f0:	85ca                	mv	a1,s2
     9f2:	854e                	mv	a0,s3
     9f4:	00005097          	auipc	ra,0x5
     9f8:	e80080e7          	jalr	-384(ra) # 5874 <write>
     9fc:	40000793          	li	a5,1024
     a00:	06f51c63          	bne	a0,a5,a78 <writebig+0xce>
  for(i = 0; i < MAXFILE; i++){
     a04:	2485                	addiw	s1,s1,1
     a06:	ff4491e3          	bne	s1,s4,9e8 <writebig+0x3e>
  close(fd);
     a0a:	854e                	mv	a0,s3
     a0c:	00005097          	auipc	ra,0x5
     a10:	e70080e7          	jalr	-400(ra) # 587c <close>
  fd = open("big", O_RDONLY);
     a14:	4581                	li	a1,0
     a16:	00006517          	auipc	a0,0x6
     a1a:	ac250513          	addi	a0,a0,-1342 # 64d8 <malloc+0x846>
     a1e:	00005097          	auipc	ra,0x5
     a22:	e76080e7          	jalr	-394(ra) # 5894 <open>
     a26:	89aa                	mv	s3,a0
  n = 0;
     a28:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a2a:	0000b917          	auipc	s2,0xb
     a2e:	36e90913          	addi	s2,s2,878 # bd98 <buf>
  if(fd < 0){
     a32:	06054263          	bltz	a0,a96 <writebig+0xec>
    i = read(fd, buf, BSIZE);
     a36:	40000613          	li	a2,1024
     a3a:	85ca                	mv	a1,s2
     a3c:	854e                	mv	a0,s3
     a3e:	00005097          	auipc	ra,0x5
     a42:	e2e080e7          	jalr	-466(ra) # 586c <read>
    if(i == 0){
     a46:	c535                	beqz	a0,ab2 <writebig+0x108>
    } else if(i != BSIZE){
     a48:	40000793          	li	a5,1024
     a4c:	0af51f63          	bne	a0,a5,b0a <writebig+0x160>
    if(((int*)buf)[0] != n){
     a50:	00092683          	lw	a3,0(s2)
     a54:	0c969a63          	bne	a3,s1,b28 <writebig+0x17e>
    n++;
     a58:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a5a:	bff1                	j	a36 <writebig+0x8c>
    printf("%s: error: creat big failed!\n", s);
     a5c:	85d6                	mv	a1,s5
     a5e:	00006517          	auipc	a0,0x6
     a62:	a8250513          	addi	a0,a0,-1406 # 64e0 <malloc+0x84e>
     a66:	00005097          	auipc	ra,0x5
     a6a:	16e080e7          	jalr	366(ra) # 5bd4 <printf>
    exit(1);
     a6e:	4505                	li	a0,1
     a70:	00005097          	auipc	ra,0x5
     a74:	de4080e7          	jalr	-540(ra) # 5854 <exit>
      printf("%s: error: write big file failed\n", s, i);
     a78:	8626                	mv	a2,s1
     a7a:	85d6                	mv	a1,s5
     a7c:	00006517          	auipc	a0,0x6
     a80:	a8450513          	addi	a0,a0,-1404 # 6500 <malloc+0x86e>
     a84:	00005097          	auipc	ra,0x5
     a88:	150080e7          	jalr	336(ra) # 5bd4 <printf>
      exit(1);
     a8c:	4505                	li	a0,1
     a8e:	00005097          	auipc	ra,0x5
     a92:	dc6080e7          	jalr	-570(ra) # 5854 <exit>
    printf("%s: error: open big failed!\n", s);
     a96:	85d6                	mv	a1,s5
     a98:	00006517          	auipc	a0,0x6
     a9c:	a9050513          	addi	a0,a0,-1392 # 6528 <malloc+0x896>
     aa0:	00005097          	auipc	ra,0x5
     aa4:	134080e7          	jalr	308(ra) # 5bd4 <printf>
    exit(1);
     aa8:	4505                	li	a0,1
     aaa:	00005097          	auipc	ra,0x5
     aae:	daa080e7          	jalr	-598(ra) # 5854 <exit>
      if(n == MAXFILE - 1){
     ab2:	67c1                	lui	a5,0x10
     ab4:	10a78793          	addi	a5,a5,266 # 1010a <__BSS_END__+0x1362>
     ab8:	02f48a63          	beq	s1,a5,aec <writebig+0x142>
  close(fd);
     abc:	854e                	mv	a0,s3
     abe:	00005097          	auipc	ra,0x5
     ac2:	dbe080e7          	jalr	-578(ra) # 587c <close>
  if(unlink("big") < 0){
     ac6:	00006517          	auipc	a0,0x6
     aca:	a1250513          	addi	a0,a0,-1518 # 64d8 <malloc+0x846>
     ace:	00005097          	auipc	ra,0x5
     ad2:	dd6080e7          	jalr	-554(ra) # 58a4 <unlink>
     ad6:	06054863          	bltz	a0,b46 <writebig+0x19c>
}
     ada:	70e2                	ld	ra,56(sp)
     adc:	7442                	ld	s0,48(sp)
     ade:	74a2                	ld	s1,40(sp)
     ae0:	7902                	ld	s2,32(sp)
     ae2:	69e2                	ld	s3,24(sp)
     ae4:	6a42                	ld	s4,16(sp)
     ae6:	6aa2                	ld	s5,8(sp)
     ae8:	6121                	addi	sp,sp,64
     aea:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     aec:	863e                	mv	a2,a5
     aee:	85d6                	mv	a1,s5
     af0:	00006517          	auipc	a0,0x6
     af4:	a5850513          	addi	a0,a0,-1448 # 6548 <malloc+0x8b6>
     af8:	00005097          	auipc	ra,0x5
     afc:	0dc080e7          	jalr	220(ra) # 5bd4 <printf>
        exit(1);
     b00:	4505                	li	a0,1
     b02:	00005097          	auipc	ra,0x5
     b06:	d52080e7          	jalr	-686(ra) # 5854 <exit>
      printf("%s: read failed %d\n", s, i);
     b0a:	862a                	mv	a2,a0
     b0c:	85d6                	mv	a1,s5
     b0e:	00006517          	auipc	a0,0x6
     b12:	a6250513          	addi	a0,a0,-1438 # 6570 <malloc+0x8de>
     b16:	00005097          	auipc	ra,0x5
     b1a:	0be080e7          	jalr	190(ra) # 5bd4 <printf>
      exit(1);
     b1e:	4505                	li	a0,1
     b20:	00005097          	auipc	ra,0x5
     b24:	d34080e7          	jalr	-716(ra) # 5854 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b28:	8626                	mv	a2,s1
     b2a:	85d6                	mv	a1,s5
     b2c:	00006517          	auipc	a0,0x6
     b30:	a5c50513          	addi	a0,a0,-1444 # 6588 <malloc+0x8f6>
     b34:	00005097          	auipc	ra,0x5
     b38:	0a0080e7          	jalr	160(ra) # 5bd4 <printf>
      exit(1);
     b3c:	4505                	li	a0,1
     b3e:	00005097          	auipc	ra,0x5
     b42:	d16080e7          	jalr	-746(ra) # 5854 <exit>
    printf("%s: unlink big failed\n", s);
     b46:	85d6                	mv	a1,s5
     b48:	00006517          	auipc	a0,0x6
     b4c:	a6850513          	addi	a0,a0,-1432 # 65b0 <malloc+0x91e>
     b50:	00005097          	auipc	ra,0x5
     b54:	084080e7          	jalr	132(ra) # 5bd4 <printf>
    exit(1);
     b58:	4505                	li	a0,1
     b5a:	00005097          	auipc	ra,0x5
     b5e:	cfa080e7          	jalr	-774(ra) # 5854 <exit>

0000000000000b62 <unlinkread>:
{
     b62:	7179                	addi	sp,sp,-48
     b64:	f406                	sd	ra,40(sp)
     b66:	f022                	sd	s0,32(sp)
     b68:	ec26                	sd	s1,24(sp)
     b6a:	e84a                	sd	s2,16(sp)
     b6c:	e44e                	sd	s3,8(sp)
     b6e:	1800                	addi	s0,sp,48
     b70:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b72:	20200593          	li	a1,514
     b76:	00005517          	auipc	a0,0x5
     b7a:	37250513          	addi	a0,a0,882 # 5ee8 <malloc+0x256>
     b7e:	00005097          	auipc	ra,0x5
     b82:	d16080e7          	jalr	-746(ra) # 5894 <open>
  if(fd < 0){
     b86:	0e054563          	bltz	a0,c70 <unlinkread+0x10e>
     b8a:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b8c:	4615                	li	a2,5
     b8e:	00006597          	auipc	a1,0x6
     b92:	a5a58593          	addi	a1,a1,-1446 # 65e8 <malloc+0x956>
     b96:	00005097          	auipc	ra,0x5
     b9a:	cde080e7          	jalr	-802(ra) # 5874 <write>
  close(fd);
     b9e:	8526                	mv	a0,s1
     ba0:	00005097          	auipc	ra,0x5
     ba4:	cdc080e7          	jalr	-804(ra) # 587c <close>
  fd = open("unlinkread", O_RDWR);
     ba8:	4589                	li	a1,2
     baa:	00005517          	auipc	a0,0x5
     bae:	33e50513          	addi	a0,a0,830 # 5ee8 <malloc+0x256>
     bb2:	00005097          	auipc	ra,0x5
     bb6:	ce2080e7          	jalr	-798(ra) # 5894 <open>
     bba:	84aa                	mv	s1,a0
  if(fd < 0){
     bbc:	0c054863          	bltz	a0,c8c <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bc0:	00005517          	auipc	a0,0x5
     bc4:	32850513          	addi	a0,a0,808 # 5ee8 <malloc+0x256>
     bc8:	00005097          	auipc	ra,0x5
     bcc:	cdc080e7          	jalr	-804(ra) # 58a4 <unlink>
     bd0:	ed61                	bnez	a0,ca8 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd2:	20200593          	li	a1,514
     bd6:	00005517          	auipc	a0,0x5
     bda:	31250513          	addi	a0,a0,786 # 5ee8 <malloc+0x256>
     bde:	00005097          	auipc	ra,0x5
     be2:	cb6080e7          	jalr	-842(ra) # 5894 <open>
     be6:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be8:	460d                	li	a2,3
     bea:	00006597          	auipc	a1,0x6
     bee:	a4658593          	addi	a1,a1,-1466 # 6630 <malloc+0x99e>
     bf2:	00005097          	auipc	ra,0x5
     bf6:	c82080e7          	jalr	-894(ra) # 5874 <write>
  close(fd1);
     bfa:	854a                	mv	a0,s2
     bfc:	00005097          	auipc	ra,0x5
     c00:	c80080e7          	jalr	-896(ra) # 587c <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c04:	660d                	lui	a2,0x3
     c06:	0000b597          	auipc	a1,0xb
     c0a:	19258593          	addi	a1,a1,402 # bd98 <buf>
     c0e:	8526                	mv	a0,s1
     c10:	00005097          	auipc	ra,0x5
     c14:	c5c080e7          	jalr	-932(ra) # 586c <read>
     c18:	4795                	li	a5,5
     c1a:	0af51563          	bne	a0,a5,cc4 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c1e:	0000b717          	auipc	a4,0xb
     c22:	17a74703          	lbu	a4,378(a4) # bd98 <buf>
     c26:	06800793          	li	a5,104
     c2a:	0af71b63          	bne	a4,a5,ce0 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c2e:	4629                	li	a2,10
     c30:	0000b597          	auipc	a1,0xb
     c34:	16858593          	addi	a1,a1,360 # bd98 <buf>
     c38:	8526                	mv	a0,s1
     c3a:	00005097          	auipc	ra,0x5
     c3e:	c3a080e7          	jalr	-966(ra) # 5874 <write>
     c42:	47a9                	li	a5,10
     c44:	0af51c63          	bne	a0,a5,cfc <unlinkread+0x19a>
  close(fd);
     c48:	8526                	mv	a0,s1
     c4a:	00005097          	auipc	ra,0x5
     c4e:	c32080e7          	jalr	-974(ra) # 587c <close>
  unlink("unlinkread");
     c52:	00005517          	auipc	a0,0x5
     c56:	29650513          	addi	a0,a0,662 # 5ee8 <malloc+0x256>
     c5a:	00005097          	auipc	ra,0x5
     c5e:	c4a080e7          	jalr	-950(ra) # 58a4 <unlink>
}
     c62:	70a2                	ld	ra,40(sp)
     c64:	7402                	ld	s0,32(sp)
     c66:	64e2                	ld	s1,24(sp)
     c68:	6942                	ld	s2,16(sp)
     c6a:	69a2                	ld	s3,8(sp)
     c6c:	6145                	addi	sp,sp,48
     c6e:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c70:	85ce                	mv	a1,s3
     c72:	00006517          	auipc	a0,0x6
     c76:	95650513          	addi	a0,a0,-1706 # 65c8 <malloc+0x936>
     c7a:	00005097          	auipc	ra,0x5
     c7e:	f5a080e7          	jalr	-166(ra) # 5bd4 <printf>
    exit(1);
     c82:	4505                	li	a0,1
     c84:	00005097          	auipc	ra,0x5
     c88:	bd0080e7          	jalr	-1072(ra) # 5854 <exit>
    printf("%s: open unlinkread failed\n", s);
     c8c:	85ce                	mv	a1,s3
     c8e:	00006517          	auipc	a0,0x6
     c92:	96250513          	addi	a0,a0,-1694 # 65f0 <malloc+0x95e>
     c96:	00005097          	auipc	ra,0x5
     c9a:	f3e080e7          	jalr	-194(ra) # 5bd4 <printf>
    exit(1);
     c9e:	4505                	li	a0,1
     ca0:	00005097          	auipc	ra,0x5
     ca4:	bb4080e7          	jalr	-1100(ra) # 5854 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ca8:	85ce                	mv	a1,s3
     caa:	00006517          	auipc	a0,0x6
     cae:	96650513          	addi	a0,a0,-1690 # 6610 <malloc+0x97e>
     cb2:	00005097          	auipc	ra,0x5
     cb6:	f22080e7          	jalr	-222(ra) # 5bd4 <printf>
    exit(1);
     cba:	4505                	li	a0,1
     cbc:	00005097          	auipc	ra,0x5
     cc0:	b98080e7          	jalr	-1128(ra) # 5854 <exit>
    printf("%s: unlinkread read failed", s);
     cc4:	85ce                	mv	a1,s3
     cc6:	00006517          	auipc	a0,0x6
     cca:	97250513          	addi	a0,a0,-1678 # 6638 <malloc+0x9a6>
     cce:	00005097          	auipc	ra,0x5
     cd2:	f06080e7          	jalr	-250(ra) # 5bd4 <printf>
    exit(1);
     cd6:	4505                	li	a0,1
     cd8:	00005097          	auipc	ra,0x5
     cdc:	b7c080e7          	jalr	-1156(ra) # 5854 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ce0:	85ce                	mv	a1,s3
     ce2:	00006517          	auipc	a0,0x6
     ce6:	97650513          	addi	a0,a0,-1674 # 6658 <malloc+0x9c6>
     cea:	00005097          	auipc	ra,0x5
     cee:	eea080e7          	jalr	-278(ra) # 5bd4 <printf>
    exit(1);
     cf2:	4505                	li	a0,1
     cf4:	00005097          	auipc	ra,0x5
     cf8:	b60080e7          	jalr	-1184(ra) # 5854 <exit>
    printf("%s: unlinkread write failed\n", s);
     cfc:	85ce                	mv	a1,s3
     cfe:	00006517          	auipc	a0,0x6
     d02:	97a50513          	addi	a0,a0,-1670 # 6678 <malloc+0x9e6>
     d06:	00005097          	auipc	ra,0x5
     d0a:	ece080e7          	jalr	-306(ra) # 5bd4 <printf>
    exit(1);
     d0e:	4505                	li	a0,1
     d10:	00005097          	auipc	ra,0x5
     d14:	b44080e7          	jalr	-1212(ra) # 5854 <exit>

0000000000000d18 <linktest>:
{
     d18:	1101                	addi	sp,sp,-32
     d1a:	ec06                	sd	ra,24(sp)
     d1c:	e822                	sd	s0,16(sp)
     d1e:	e426                	sd	s1,8(sp)
     d20:	e04a                	sd	s2,0(sp)
     d22:	1000                	addi	s0,sp,32
     d24:	892a                	mv	s2,a0
  unlink("lf1");
     d26:	00006517          	auipc	a0,0x6
     d2a:	97250513          	addi	a0,a0,-1678 # 6698 <malloc+0xa06>
     d2e:	00005097          	auipc	ra,0x5
     d32:	b76080e7          	jalr	-1162(ra) # 58a4 <unlink>
  unlink("lf2");
     d36:	00006517          	auipc	a0,0x6
     d3a:	96a50513          	addi	a0,a0,-1686 # 66a0 <malloc+0xa0e>
     d3e:	00005097          	auipc	ra,0x5
     d42:	b66080e7          	jalr	-1178(ra) # 58a4 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d46:	20200593          	li	a1,514
     d4a:	00006517          	auipc	a0,0x6
     d4e:	94e50513          	addi	a0,a0,-1714 # 6698 <malloc+0xa06>
     d52:	00005097          	auipc	ra,0x5
     d56:	b42080e7          	jalr	-1214(ra) # 5894 <open>
  if(fd < 0){
     d5a:	10054763          	bltz	a0,e68 <linktest+0x150>
     d5e:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d60:	4615                	li	a2,5
     d62:	00006597          	auipc	a1,0x6
     d66:	88658593          	addi	a1,a1,-1914 # 65e8 <malloc+0x956>
     d6a:	00005097          	auipc	ra,0x5
     d6e:	b0a080e7          	jalr	-1270(ra) # 5874 <write>
     d72:	4795                	li	a5,5
     d74:	10f51863          	bne	a0,a5,e84 <linktest+0x16c>
  close(fd);
     d78:	8526                	mv	a0,s1
     d7a:	00005097          	auipc	ra,0x5
     d7e:	b02080e7          	jalr	-1278(ra) # 587c <close>
  if(link("lf1", "lf2") < 0){
     d82:	00006597          	auipc	a1,0x6
     d86:	91e58593          	addi	a1,a1,-1762 # 66a0 <malloc+0xa0e>
     d8a:	00006517          	auipc	a0,0x6
     d8e:	90e50513          	addi	a0,a0,-1778 # 6698 <malloc+0xa06>
     d92:	00005097          	auipc	ra,0x5
     d96:	b22080e7          	jalr	-1246(ra) # 58b4 <link>
     d9a:	10054363          	bltz	a0,ea0 <linktest+0x188>
  unlink("lf1");
     d9e:	00006517          	auipc	a0,0x6
     da2:	8fa50513          	addi	a0,a0,-1798 # 6698 <malloc+0xa06>
     da6:	00005097          	auipc	ra,0x5
     daa:	afe080e7          	jalr	-1282(ra) # 58a4 <unlink>
  if(open("lf1", 0) >= 0){
     dae:	4581                	li	a1,0
     db0:	00006517          	auipc	a0,0x6
     db4:	8e850513          	addi	a0,a0,-1816 # 6698 <malloc+0xa06>
     db8:	00005097          	auipc	ra,0x5
     dbc:	adc080e7          	jalr	-1316(ra) # 5894 <open>
     dc0:	0e055e63          	bgez	a0,ebc <linktest+0x1a4>
  fd = open("lf2", 0);
     dc4:	4581                	li	a1,0
     dc6:	00006517          	auipc	a0,0x6
     dca:	8da50513          	addi	a0,a0,-1830 # 66a0 <malloc+0xa0e>
     dce:	00005097          	auipc	ra,0x5
     dd2:	ac6080e7          	jalr	-1338(ra) # 5894 <open>
     dd6:	84aa                	mv	s1,a0
  if(fd < 0){
     dd8:	10054063          	bltz	a0,ed8 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     ddc:	660d                	lui	a2,0x3
     dde:	0000b597          	auipc	a1,0xb
     de2:	fba58593          	addi	a1,a1,-70 # bd98 <buf>
     de6:	00005097          	auipc	ra,0x5
     dea:	a86080e7          	jalr	-1402(ra) # 586c <read>
     dee:	4795                	li	a5,5
     df0:	10f51263          	bne	a0,a5,ef4 <linktest+0x1dc>
  close(fd);
     df4:	8526                	mv	a0,s1
     df6:	00005097          	auipc	ra,0x5
     dfa:	a86080e7          	jalr	-1402(ra) # 587c <close>
  if(link("lf2", "lf2") >= 0){
     dfe:	00006597          	auipc	a1,0x6
     e02:	8a258593          	addi	a1,a1,-1886 # 66a0 <malloc+0xa0e>
     e06:	852e                	mv	a0,a1
     e08:	00005097          	auipc	ra,0x5
     e0c:	aac080e7          	jalr	-1364(ra) # 58b4 <link>
     e10:	10055063          	bgez	a0,f10 <linktest+0x1f8>
  unlink("lf2");
     e14:	00006517          	auipc	a0,0x6
     e18:	88c50513          	addi	a0,a0,-1908 # 66a0 <malloc+0xa0e>
     e1c:	00005097          	auipc	ra,0x5
     e20:	a88080e7          	jalr	-1400(ra) # 58a4 <unlink>
  if(link("lf2", "lf1") >= 0){
     e24:	00006597          	auipc	a1,0x6
     e28:	87458593          	addi	a1,a1,-1932 # 6698 <malloc+0xa06>
     e2c:	00006517          	auipc	a0,0x6
     e30:	87450513          	addi	a0,a0,-1932 # 66a0 <malloc+0xa0e>
     e34:	00005097          	auipc	ra,0x5
     e38:	a80080e7          	jalr	-1408(ra) # 58b4 <link>
     e3c:	0e055863          	bgez	a0,f2c <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e40:	00006597          	auipc	a1,0x6
     e44:	85858593          	addi	a1,a1,-1960 # 6698 <malloc+0xa06>
     e48:	00006517          	auipc	a0,0x6
     e4c:	96050513          	addi	a0,a0,-1696 # 67a8 <malloc+0xb16>
     e50:	00005097          	auipc	ra,0x5
     e54:	a64080e7          	jalr	-1436(ra) # 58b4 <link>
     e58:	0e055863          	bgez	a0,f48 <linktest+0x230>
}
     e5c:	60e2                	ld	ra,24(sp)
     e5e:	6442                	ld	s0,16(sp)
     e60:	64a2                	ld	s1,8(sp)
     e62:	6902                	ld	s2,0(sp)
     e64:	6105                	addi	sp,sp,32
     e66:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e68:	85ca                	mv	a1,s2
     e6a:	00006517          	auipc	a0,0x6
     e6e:	83e50513          	addi	a0,a0,-1986 # 66a8 <malloc+0xa16>
     e72:	00005097          	auipc	ra,0x5
     e76:	d62080e7          	jalr	-670(ra) # 5bd4 <printf>
    exit(1);
     e7a:	4505                	li	a0,1
     e7c:	00005097          	auipc	ra,0x5
     e80:	9d8080e7          	jalr	-1576(ra) # 5854 <exit>
    printf("%s: write lf1 failed\n", s);
     e84:	85ca                	mv	a1,s2
     e86:	00006517          	auipc	a0,0x6
     e8a:	83a50513          	addi	a0,a0,-1990 # 66c0 <malloc+0xa2e>
     e8e:	00005097          	auipc	ra,0x5
     e92:	d46080e7          	jalr	-698(ra) # 5bd4 <printf>
    exit(1);
     e96:	4505                	li	a0,1
     e98:	00005097          	auipc	ra,0x5
     e9c:	9bc080e7          	jalr	-1604(ra) # 5854 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     ea0:	85ca                	mv	a1,s2
     ea2:	00006517          	auipc	a0,0x6
     ea6:	83650513          	addi	a0,a0,-1994 # 66d8 <malloc+0xa46>
     eaa:	00005097          	auipc	ra,0x5
     eae:	d2a080e7          	jalr	-726(ra) # 5bd4 <printf>
    exit(1);
     eb2:	4505                	li	a0,1
     eb4:	00005097          	auipc	ra,0x5
     eb8:	9a0080e7          	jalr	-1632(ra) # 5854 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     ebc:	85ca                	mv	a1,s2
     ebe:	00006517          	auipc	a0,0x6
     ec2:	83a50513          	addi	a0,a0,-1990 # 66f8 <malloc+0xa66>
     ec6:	00005097          	auipc	ra,0x5
     eca:	d0e080e7          	jalr	-754(ra) # 5bd4 <printf>
    exit(1);
     ece:	4505                	li	a0,1
     ed0:	00005097          	auipc	ra,0x5
     ed4:	984080e7          	jalr	-1660(ra) # 5854 <exit>
    printf("%s: open lf2 failed\n", s);
     ed8:	85ca                	mv	a1,s2
     eda:	00006517          	auipc	a0,0x6
     ede:	84e50513          	addi	a0,a0,-1970 # 6728 <malloc+0xa96>
     ee2:	00005097          	auipc	ra,0x5
     ee6:	cf2080e7          	jalr	-782(ra) # 5bd4 <printf>
    exit(1);
     eea:	4505                	li	a0,1
     eec:	00005097          	auipc	ra,0x5
     ef0:	968080e7          	jalr	-1688(ra) # 5854 <exit>
    printf("%s: read lf2 failed\n", s);
     ef4:	85ca                	mv	a1,s2
     ef6:	00006517          	auipc	a0,0x6
     efa:	84a50513          	addi	a0,a0,-1974 # 6740 <malloc+0xaae>
     efe:	00005097          	auipc	ra,0x5
     f02:	cd6080e7          	jalr	-810(ra) # 5bd4 <printf>
    exit(1);
     f06:	4505                	li	a0,1
     f08:	00005097          	auipc	ra,0x5
     f0c:	94c080e7          	jalr	-1716(ra) # 5854 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f10:	85ca                	mv	a1,s2
     f12:	00006517          	auipc	a0,0x6
     f16:	84650513          	addi	a0,a0,-1978 # 6758 <malloc+0xac6>
     f1a:	00005097          	auipc	ra,0x5
     f1e:	cba080e7          	jalr	-838(ra) # 5bd4 <printf>
    exit(1);
     f22:	4505                	li	a0,1
     f24:	00005097          	auipc	ra,0x5
     f28:	930080e7          	jalr	-1744(ra) # 5854 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     f2c:	85ca                	mv	a1,s2
     f2e:	00006517          	auipc	a0,0x6
     f32:	85250513          	addi	a0,a0,-1966 # 6780 <malloc+0xaee>
     f36:	00005097          	auipc	ra,0x5
     f3a:	c9e080e7          	jalr	-866(ra) # 5bd4 <printf>
    exit(1);
     f3e:	4505                	li	a0,1
     f40:	00005097          	auipc	ra,0x5
     f44:	914080e7          	jalr	-1772(ra) # 5854 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f48:	85ca                	mv	a1,s2
     f4a:	00006517          	auipc	a0,0x6
     f4e:	86650513          	addi	a0,a0,-1946 # 67b0 <malloc+0xb1e>
     f52:	00005097          	auipc	ra,0x5
     f56:	c82080e7          	jalr	-894(ra) # 5bd4 <printf>
    exit(1);
     f5a:	4505                	li	a0,1
     f5c:	00005097          	auipc	ra,0x5
     f60:	8f8080e7          	jalr	-1800(ra) # 5854 <exit>

0000000000000f64 <bigdir>:
{
     f64:	715d                	addi	sp,sp,-80
     f66:	e486                	sd	ra,72(sp)
     f68:	e0a2                	sd	s0,64(sp)
     f6a:	fc26                	sd	s1,56(sp)
     f6c:	f84a                	sd	s2,48(sp)
     f6e:	f44e                	sd	s3,40(sp)
     f70:	f052                	sd	s4,32(sp)
     f72:	ec56                	sd	s5,24(sp)
     f74:	e85a                	sd	s6,16(sp)
     f76:	0880                	addi	s0,sp,80
     f78:	89aa                	mv	s3,a0
  unlink("bd");
     f7a:	00006517          	auipc	a0,0x6
     f7e:	85650513          	addi	a0,a0,-1962 # 67d0 <malloc+0xb3e>
     f82:	00005097          	auipc	ra,0x5
     f86:	922080e7          	jalr	-1758(ra) # 58a4 <unlink>
  fd = open("bd", O_CREATE);
     f8a:	20000593          	li	a1,512
     f8e:	00006517          	auipc	a0,0x6
     f92:	84250513          	addi	a0,a0,-1982 # 67d0 <malloc+0xb3e>
     f96:	00005097          	auipc	ra,0x5
     f9a:	8fe080e7          	jalr	-1794(ra) # 5894 <open>
  if(fd < 0){
     f9e:	0c054963          	bltz	a0,1070 <bigdir+0x10c>
  close(fd);
     fa2:	00005097          	auipc	ra,0x5
     fa6:	8da080e7          	jalr	-1830(ra) # 587c <close>
  for(i = 0; i < N; i++){
     faa:	4901                	li	s2,0
    name[0] = 'x';
     fac:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fb0:	00006a17          	auipc	s4,0x6
     fb4:	820a0a13          	addi	s4,s4,-2016 # 67d0 <malloc+0xb3e>
  for(i = 0; i < N; i++){
     fb8:	1f400b13          	li	s6,500
    name[0] = 'x';
     fbc:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fc0:	41f9579b          	sraiw	a5,s2,0x1f
     fc4:	01a7d71b          	srliw	a4,a5,0x1a
     fc8:	012707bb          	addw	a5,a4,s2
     fcc:	4067d69b          	sraiw	a3,a5,0x6
     fd0:	0306869b          	addiw	a3,a3,48
     fd4:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fd8:	03f7f793          	andi	a5,a5,63
     fdc:	9f99                	subw	a5,a5,a4
     fde:	0307879b          	addiw	a5,a5,48
     fe2:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fe6:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     fea:	fb040593          	addi	a1,s0,-80
     fee:	8552                	mv	a0,s4
     ff0:	00005097          	auipc	ra,0x5
     ff4:	8c4080e7          	jalr	-1852(ra) # 58b4 <link>
     ff8:	84aa                	mv	s1,a0
     ffa:	e949                	bnez	a0,108c <bigdir+0x128>
  for(i = 0; i < N; i++){
     ffc:	2905                	addiw	s2,s2,1
     ffe:	fb691fe3          	bne	s2,s6,fbc <bigdir+0x58>
  unlink("bd");
    1002:	00005517          	auipc	a0,0x5
    1006:	7ce50513          	addi	a0,a0,1998 # 67d0 <malloc+0xb3e>
    100a:	00005097          	auipc	ra,0x5
    100e:	89a080e7          	jalr	-1894(ra) # 58a4 <unlink>
    name[0] = 'x';
    1012:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1016:	1f400a13          	li	s4,500
    name[0] = 'x';
    101a:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    101e:	41f4d79b          	sraiw	a5,s1,0x1f
    1022:	01a7d71b          	srliw	a4,a5,0x1a
    1026:	009707bb          	addw	a5,a4,s1
    102a:	4067d69b          	sraiw	a3,a5,0x6
    102e:	0306869b          	addiw	a3,a3,48
    1032:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1036:	03f7f793          	andi	a5,a5,63
    103a:	9f99                	subw	a5,a5,a4
    103c:	0307879b          	addiw	a5,a5,48
    1040:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1044:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1048:	fb040513          	addi	a0,s0,-80
    104c:	00005097          	auipc	ra,0x5
    1050:	858080e7          	jalr	-1960(ra) # 58a4 <unlink>
    1054:	ed21                	bnez	a0,10ac <bigdir+0x148>
  for(i = 0; i < N; i++){
    1056:	2485                	addiw	s1,s1,1
    1058:	fd4491e3          	bne	s1,s4,101a <bigdir+0xb6>
}
    105c:	60a6                	ld	ra,72(sp)
    105e:	6406                	ld	s0,64(sp)
    1060:	74e2                	ld	s1,56(sp)
    1062:	7942                	ld	s2,48(sp)
    1064:	79a2                	ld	s3,40(sp)
    1066:	7a02                	ld	s4,32(sp)
    1068:	6ae2                	ld	s5,24(sp)
    106a:	6b42                	ld	s6,16(sp)
    106c:	6161                	addi	sp,sp,80
    106e:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1070:	85ce                	mv	a1,s3
    1072:	00005517          	auipc	a0,0x5
    1076:	76650513          	addi	a0,a0,1894 # 67d8 <malloc+0xb46>
    107a:	00005097          	auipc	ra,0x5
    107e:	b5a080e7          	jalr	-1190(ra) # 5bd4 <printf>
    exit(1);
    1082:	4505                	li	a0,1
    1084:	00004097          	auipc	ra,0x4
    1088:	7d0080e7          	jalr	2000(ra) # 5854 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    108c:	fb040613          	addi	a2,s0,-80
    1090:	85ce                	mv	a1,s3
    1092:	00005517          	auipc	a0,0x5
    1096:	76650513          	addi	a0,a0,1894 # 67f8 <malloc+0xb66>
    109a:	00005097          	auipc	ra,0x5
    109e:	b3a080e7          	jalr	-1222(ra) # 5bd4 <printf>
      exit(1);
    10a2:	4505                	li	a0,1
    10a4:	00004097          	auipc	ra,0x4
    10a8:	7b0080e7          	jalr	1968(ra) # 5854 <exit>
      printf("%s: bigdir unlink failed", s);
    10ac:	85ce                	mv	a1,s3
    10ae:	00005517          	auipc	a0,0x5
    10b2:	76a50513          	addi	a0,a0,1898 # 6818 <malloc+0xb86>
    10b6:	00005097          	auipc	ra,0x5
    10ba:	b1e080e7          	jalr	-1250(ra) # 5bd4 <printf>
      exit(1);
    10be:	4505                	li	a0,1
    10c0:	00004097          	auipc	ra,0x4
    10c4:	794080e7          	jalr	1940(ra) # 5854 <exit>

00000000000010c8 <validatetest>:
{
    10c8:	7139                	addi	sp,sp,-64
    10ca:	fc06                	sd	ra,56(sp)
    10cc:	f822                	sd	s0,48(sp)
    10ce:	f426                	sd	s1,40(sp)
    10d0:	f04a                	sd	s2,32(sp)
    10d2:	ec4e                	sd	s3,24(sp)
    10d4:	e852                	sd	s4,16(sp)
    10d6:	e456                	sd	s5,8(sp)
    10d8:	e05a                	sd	s6,0(sp)
    10da:	0080                	addi	s0,sp,64
    10dc:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10de:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10e0:	00005997          	auipc	s3,0x5
    10e4:	75898993          	addi	s3,s3,1880 # 6838 <malloc+0xba6>
    10e8:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10ea:	6a85                	lui	s5,0x1
    10ec:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10f0:	85a6                	mv	a1,s1
    10f2:	854e                	mv	a0,s3
    10f4:	00004097          	auipc	ra,0x4
    10f8:	7c0080e7          	jalr	1984(ra) # 58b4 <link>
    10fc:	01251f63          	bne	a0,s2,111a <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1100:	94d6                	add	s1,s1,s5
    1102:	ff4497e3          	bne	s1,s4,10f0 <validatetest+0x28>
}
    1106:	70e2                	ld	ra,56(sp)
    1108:	7442                	ld	s0,48(sp)
    110a:	74a2                	ld	s1,40(sp)
    110c:	7902                	ld	s2,32(sp)
    110e:	69e2                	ld	s3,24(sp)
    1110:	6a42                	ld	s4,16(sp)
    1112:	6aa2                	ld	s5,8(sp)
    1114:	6b02                	ld	s6,0(sp)
    1116:	6121                	addi	sp,sp,64
    1118:	8082                	ret
      printf("%s: link should not succeed\n", s);
    111a:	85da                	mv	a1,s6
    111c:	00005517          	auipc	a0,0x5
    1120:	72c50513          	addi	a0,a0,1836 # 6848 <malloc+0xbb6>
    1124:	00005097          	auipc	ra,0x5
    1128:	ab0080e7          	jalr	-1360(ra) # 5bd4 <printf>
      exit(1);
    112c:	4505                	li	a0,1
    112e:	00004097          	auipc	ra,0x4
    1132:	726080e7          	jalr	1830(ra) # 5854 <exit>

0000000000001136 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1136:	7179                	addi	sp,sp,-48
    1138:	f406                	sd	ra,40(sp)
    113a:	f022                	sd	s0,32(sp)
    113c:	ec26                	sd	s1,24(sp)
    113e:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    1140:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1144:	00007497          	auipc	s1,0x7
    1148:	42c4b483          	ld	s1,1068(s1) # 8570 <__SDATA_BEGIN__>
    114c:	fd840593          	addi	a1,s0,-40
    1150:	8526                	mv	a0,s1
    1152:	00004097          	auipc	ra,0x4
    1156:	73a080e7          	jalr	1850(ra) # 588c <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    115a:	8526                	mv	a0,s1
    115c:	00004097          	auipc	ra,0x4
    1160:	708080e7          	jalr	1800(ra) # 5864 <pipe>

  exit(0);
    1164:	4501                	li	a0,0
    1166:	00004097          	auipc	ra,0x4
    116a:	6ee080e7          	jalr	1774(ra) # 5854 <exit>

000000000000116e <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    116e:	7139                	addi	sp,sp,-64
    1170:	fc06                	sd	ra,56(sp)
    1172:	f822                	sd	s0,48(sp)
    1174:	f426                	sd	s1,40(sp)
    1176:	f04a                	sd	s2,32(sp)
    1178:	ec4e                	sd	s3,24(sp)
    117a:	0080                	addi	s0,sp,64
    117c:	64b1                	lui	s1,0xc
    117e:	35048493          	addi	s1,s1,848 # c350 <buf+0x5b8>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1182:	597d                	li	s2,-1
    1184:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    1188:	00005997          	auipc	s3,0x5
    118c:	f8898993          	addi	s3,s3,-120 # 6110 <malloc+0x47e>
    argv[0] = (char*)0xffffffff;
    1190:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1194:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1198:	fc040593          	addi	a1,s0,-64
    119c:	854e                	mv	a0,s3
    119e:	00004097          	auipc	ra,0x4
    11a2:	6ee080e7          	jalr	1774(ra) # 588c <exec>
  for(int i = 0; i < 50000; i++){
    11a6:	34fd                	addiw	s1,s1,-1
    11a8:	f4e5                	bnez	s1,1190 <badarg+0x22>
  }
  
  exit(0);
    11aa:	4501                	li	a0,0
    11ac:	00004097          	auipc	ra,0x4
    11b0:	6a8080e7          	jalr	1704(ra) # 5854 <exit>

00000000000011b4 <copyinstr2>:
{
    11b4:	7155                	addi	sp,sp,-208
    11b6:	e586                	sd	ra,200(sp)
    11b8:	e1a2                	sd	s0,192(sp)
    11ba:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11bc:	f6840793          	addi	a5,s0,-152
    11c0:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11c4:	07800713          	li	a4,120
    11c8:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11cc:	0785                	addi	a5,a5,1
    11ce:	fed79de3          	bne	a5,a3,11c8 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11d2:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11d6:	f6840513          	addi	a0,s0,-152
    11da:	00004097          	auipc	ra,0x4
    11de:	6ca080e7          	jalr	1738(ra) # 58a4 <unlink>
  if(ret != -1){
    11e2:	57fd                	li	a5,-1
    11e4:	0ef51063          	bne	a0,a5,12c4 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11e8:	20100593          	li	a1,513
    11ec:	f6840513          	addi	a0,s0,-152
    11f0:	00004097          	auipc	ra,0x4
    11f4:	6a4080e7          	jalr	1700(ra) # 5894 <open>
  if(fd != -1){
    11f8:	57fd                	li	a5,-1
    11fa:	0ef51563          	bne	a0,a5,12e4 <copyinstr2+0x130>
  ret = link(b, b);
    11fe:	f6840593          	addi	a1,s0,-152
    1202:	852e                	mv	a0,a1
    1204:	00004097          	auipc	ra,0x4
    1208:	6b0080e7          	jalr	1712(ra) # 58b4 <link>
  if(ret != -1){
    120c:	57fd                	li	a5,-1
    120e:	0ef51b63          	bne	a0,a5,1304 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1212:	00007797          	auipc	a5,0x7
    1216:	81e78793          	addi	a5,a5,-2018 # 7a30 <malloc+0x1d9e>
    121a:	f4f43c23          	sd	a5,-168(s0)
    121e:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1222:	f5840593          	addi	a1,s0,-168
    1226:	f6840513          	addi	a0,s0,-152
    122a:	00004097          	auipc	ra,0x4
    122e:	662080e7          	jalr	1634(ra) # 588c <exec>
  if(ret != -1){
    1232:	57fd                	li	a5,-1
    1234:	0ef51963          	bne	a0,a5,1326 <copyinstr2+0x172>
  int pid = fork();
    1238:	00004097          	auipc	ra,0x4
    123c:	614080e7          	jalr	1556(ra) # 584c <fork>
  if(pid < 0){
    1240:	10054363          	bltz	a0,1346 <copyinstr2+0x192>
  if(pid == 0){
    1244:	12051463          	bnez	a0,136c <copyinstr2+0x1b8>
    1248:	00007797          	auipc	a5,0x7
    124c:	43878793          	addi	a5,a5,1080 # 8680 <big.1273>
    1250:	00008697          	auipc	a3,0x8
    1254:	43068693          	addi	a3,a3,1072 # 9680 <__global_pointer$+0x910>
      big[i] = 'x';
    1258:	07800713          	li	a4,120
    125c:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1260:	0785                	addi	a5,a5,1
    1262:	fed79de3          	bne	a5,a3,125c <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1266:	00008797          	auipc	a5,0x8
    126a:	40078d23          	sb	zero,1050(a5) # 9680 <__global_pointer$+0x910>
    char *args2[] = { big, big, big, 0 };
    126e:	00007797          	auipc	a5,0x7
    1272:	ed278793          	addi	a5,a5,-302 # 8140 <malloc+0x24ae>
    1276:	6390                	ld	a2,0(a5)
    1278:	6794                	ld	a3,8(a5)
    127a:	6b98                	ld	a4,16(a5)
    127c:	6f9c                	ld	a5,24(a5)
    127e:	f2c43823          	sd	a2,-208(s0)
    1282:	f2d43c23          	sd	a3,-200(s0)
    1286:	f4e43023          	sd	a4,-192(s0)
    128a:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    128e:	f3040593          	addi	a1,s0,-208
    1292:	00005517          	auipc	a0,0x5
    1296:	e7e50513          	addi	a0,a0,-386 # 6110 <malloc+0x47e>
    129a:	00004097          	auipc	ra,0x4
    129e:	5f2080e7          	jalr	1522(ra) # 588c <exec>
    if(ret != -1){
    12a2:	57fd                	li	a5,-1
    12a4:	0af50e63          	beq	a0,a5,1360 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12a8:	55fd                	li	a1,-1
    12aa:	00005517          	auipc	a0,0x5
    12ae:	64650513          	addi	a0,a0,1606 # 68f0 <malloc+0xc5e>
    12b2:	00005097          	auipc	ra,0x5
    12b6:	922080e7          	jalr	-1758(ra) # 5bd4 <printf>
      exit(1);
    12ba:	4505                	li	a0,1
    12bc:	00004097          	auipc	ra,0x4
    12c0:	598080e7          	jalr	1432(ra) # 5854 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12c4:	862a                	mv	a2,a0
    12c6:	f6840593          	addi	a1,s0,-152
    12ca:	00005517          	auipc	a0,0x5
    12ce:	59e50513          	addi	a0,a0,1438 # 6868 <malloc+0xbd6>
    12d2:	00005097          	auipc	ra,0x5
    12d6:	902080e7          	jalr	-1790(ra) # 5bd4 <printf>
    exit(1);
    12da:	4505                	li	a0,1
    12dc:	00004097          	auipc	ra,0x4
    12e0:	578080e7          	jalr	1400(ra) # 5854 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12e4:	862a                	mv	a2,a0
    12e6:	f6840593          	addi	a1,s0,-152
    12ea:	00005517          	auipc	a0,0x5
    12ee:	59e50513          	addi	a0,a0,1438 # 6888 <malloc+0xbf6>
    12f2:	00005097          	auipc	ra,0x5
    12f6:	8e2080e7          	jalr	-1822(ra) # 5bd4 <printf>
    exit(1);
    12fa:	4505                	li	a0,1
    12fc:	00004097          	auipc	ra,0x4
    1300:	558080e7          	jalr	1368(ra) # 5854 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1304:	86aa                	mv	a3,a0
    1306:	f6840613          	addi	a2,s0,-152
    130a:	85b2                	mv	a1,a2
    130c:	00005517          	auipc	a0,0x5
    1310:	59c50513          	addi	a0,a0,1436 # 68a8 <malloc+0xc16>
    1314:	00005097          	auipc	ra,0x5
    1318:	8c0080e7          	jalr	-1856(ra) # 5bd4 <printf>
    exit(1);
    131c:	4505                	li	a0,1
    131e:	00004097          	auipc	ra,0x4
    1322:	536080e7          	jalr	1334(ra) # 5854 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1326:	567d                	li	a2,-1
    1328:	f6840593          	addi	a1,s0,-152
    132c:	00005517          	auipc	a0,0x5
    1330:	5a450513          	addi	a0,a0,1444 # 68d0 <malloc+0xc3e>
    1334:	00005097          	auipc	ra,0x5
    1338:	8a0080e7          	jalr	-1888(ra) # 5bd4 <printf>
    exit(1);
    133c:	4505                	li	a0,1
    133e:	00004097          	auipc	ra,0x4
    1342:	516080e7          	jalr	1302(ra) # 5854 <exit>
    printf("fork failed\n");
    1346:	00006517          	auipc	a0,0x6
    134a:	a2250513          	addi	a0,a0,-1502 # 6d68 <malloc+0x10d6>
    134e:	00005097          	auipc	ra,0x5
    1352:	886080e7          	jalr	-1914(ra) # 5bd4 <printf>
    exit(1);
    1356:	4505                	li	a0,1
    1358:	00004097          	auipc	ra,0x4
    135c:	4fc080e7          	jalr	1276(ra) # 5854 <exit>
    exit(747); // OK
    1360:	2eb00513          	li	a0,747
    1364:	00004097          	auipc	ra,0x4
    1368:	4f0080e7          	jalr	1264(ra) # 5854 <exit>
  int st = 0;
    136c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1370:	f5440513          	addi	a0,s0,-172
    1374:	00004097          	auipc	ra,0x4
    1378:	4e8080e7          	jalr	1256(ra) # 585c <wait>
  if(st != 747){
    137c:	f5442703          	lw	a4,-172(s0)
    1380:	2eb00793          	li	a5,747
    1384:	00f71663          	bne	a4,a5,1390 <copyinstr2+0x1dc>
}
    1388:	60ae                	ld	ra,200(sp)
    138a:	640e                	ld	s0,192(sp)
    138c:	6169                	addi	sp,sp,208
    138e:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1390:	00005517          	auipc	a0,0x5
    1394:	58850513          	addi	a0,a0,1416 # 6918 <malloc+0xc86>
    1398:	00005097          	auipc	ra,0x5
    139c:	83c080e7          	jalr	-1988(ra) # 5bd4 <printf>
    exit(1);
    13a0:	4505                	li	a0,1
    13a2:	00004097          	auipc	ra,0x4
    13a6:	4b2080e7          	jalr	1202(ra) # 5854 <exit>

00000000000013aa <truncate3>:
{
    13aa:	7159                	addi	sp,sp,-112
    13ac:	f486                	sd	ra,104(sp)
    13ae:	f0a2                	sd	s0,96(sp)
    13b0:	eca6                	sd	s1,88(sp)
    13b2:	e8ca                	sd	s2,80(sp)
    13b4:	e4ce                	sd	s3,72(sp)
    13b6:	e0d2                	sd	s4,64(sp)
    13b8:	fc56                	sd	s5,56(sp)
    13ba:	1880                	addi	s0,sp,112
    13bc:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13be:	60100593          	li	a1,1537
    13c2:	00005517          	auipc	a0,0x5
    13c6:	da650513          	addi	a0,a0,-602 # 6168 <malloc+0x4d6>
    13ca:	00004097          	auipc	ra,0x4
    13ce:	4ca080e7          	jalr	1226(ra) # 5894 <open>
    13d2:	00004097          	auipc	ra,0x4
    13d6:	4aa080e7          	jalr	1194(ra) # 587c <close>
  pid = fork();
    13da:	00004097          	auipc	ra,0x4
    13de:	472080e7          	jalr	1138(ra) # 584c <fork>
  if(pid < 0){
    13e2:	08054063          	bltz	a0,1462 <truncate3+0xb8>
  if(pid == 0){
    13e6:	e969                	bnez	a0,14b8 <truncate3+0x10e>
    13e8:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13ec:	00005a17          	auipc	s4,0x5
    13f0:	d7ca0a13          	addi	s4,s4,-644 # 6168 <malloc+0x4d6>
      int n = write(fd, "1234567890", 10);
    13f4:	00005a97          	auipc	s5,0x5
    13f8:	584a8a93          	addi	s5,s5,1412 # 6978 <malloc+0xce6>
      int fd = open("truncfile", O_WRONLY);
    13fc:	4585                	li	a1,1
    13fe:	8552                	mv	a0,s4
    1400:	00004097          	auipc	ra,0x4
    1404:	494080e7          	jalr	1172(ra) # 5894 <open>
    1408:	84aa                	mv	s1,a0
      if(fd < 0){
    140a:	06054a63          	bltz	a0,147e <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    140e:	4629                	li	a2,10
    1410:	85d6                	mv	a1,s5
    1412:	00004097          	auipc	ra,0x4
    1416:	462080e7          	jalr	1122(ra) # 5874 <write>
      if(n != 10){
    141a:	47a9                	li	a5,10
    141c:	06f51f63          	bne	a0,a5,149a <truncate3+0xf0>
      close(fd);
    1420:	8526                	mv	a0,s1
    1422:	00004097          	auipc	ra,0x4
    1426:	45a080e7          	jalr	1114(ra) # 587c <close>
      fd = open("truncfile", O_RDONLY);
    142a:	4581                	li	a1,0
    142c:	8552                	mv	a0,s4
    142e:	00004097          	auipc	ra,0x4
    1432:	466080e7          	jalr	1126(ra) # 5894 <open>
    1436:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1438:	02000613          	li	a2,32
    143c:	f9840593          	addi	a1,s0,-104
    1440:	00004097          	auipc	ra,0x4
    1444:	42c080e7          	jalr	1068(ra) # 586c <read>
      close(fd);
    1448:	8526                	mv	a0,s1
    144a:	00004097          	auipc	ra,0x4
    144e:	432080e7          	jalr	1074(ra) # 587c <close>
    for(int i = 0; i < 100; i++){
    1452:	39fd                	addiw	s3,s3,-1
    1454:	fa0994e3          	bnez	s3,13fc <truncate3+0x52>
    exit(0);
    1458:	4501                	li	a0,0
    145a:	00004097          	auipc	ra,0x4
    145e:	3fa080e7          	jalr	1018(ra) # 5854 <exit>
    printf("%s: fork failed\n", s);
    1462:	85ca                	mv	a1,s2
    1464:	00005517          	auipc	a0,0x5
    1468:	4e450513          	addi	a0,a0,1252 # 6948 <malloc+0xcb6>
    146c:	00004097          	auipc	ra,0x4
    1470:	768080e7          	jalr	1896(ra) # 5bd4 <printf>
    exit(1);
    1474:	4505                	li	a0,1
    1476:	00004097          	auipc	ra,0x4
    147a:	3de080e7          	jalr	990(ra) # 5854 <exit>
        printf("%s: open failed\n", s);
    147e:	85ca                	mv	a1,s2
    1480:	00005517          	auipc	a0,0x5
    1484:	4e050513          	addi	a0,a0,1248 # 6960 <malloc+0xcce>
    1488:	00004097          	auipc	ra,0x4
    148c:	74c080e7          	jalr	1868(ra) # 5bd4 <printf>
        exit(1);
    1490:	4505                	li	a0,1
    1492:	00004097          	auipc	ra,0x4
    1496:	3c2080e7          	jalr	962(ra) # 5854 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    149a:	862a                	mv	a2,a0
    149c:	85ca                	mv	a1,s2
    149e:	00005517          	auipc	a0,0x5
    14a2:	4ea50513          	addi	a0,a0,1258 # 6988 <malloc+0xcf6>
    14a6:	00004097          	auipc	ra,0x4
    14aa:	72e080e7          	jalr	1838(ra) # 5bd4 <printf>
        exit(1);
    14ae:	4505                	li	a0,1
    14b0:	00004097          	auipc	ra,0x4
    14b4:	3a4080e7          	jalr	932(ra) # 5854 <exit>
    14b8:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14bc:	00005a17          	auipc	s4,0x5
    14c0:	caca0a13          	addi	s4,s4,-852 # 6168 <malloc+0x4d6>
    int n = write(fd, "xxx", 3);
    14c4:	00005a97          	auipc	s5,0x5
    14c8:	4e4a8a93          	addi	s5,s5,1252 # 69a8 <malloc+0xd16>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14cc:	60100593          	li	a1,1537
    14d0:	8552                	mv	a0,s4
    14d2:	00004097          	auipc	ra,0x4
    14d6:	3c2080e7          	jalr	962(ra) # 5894 <open>
    14da:	84aa                	mv	s1,a0
    if(fd < 0){
    14dc:	04054763          	bltz	a0,152a <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14e0:	460d                	li	a2,3
    14e2:	85d6                	mv	a1,s5
    14e4:	00004097          	auipc	ra,0x4
    14e8:	390080e7          	jalr	912(ra) # 5874 <write>
    if(n != 3){
    14ec:	478d                	li	a5,3
    14ee:	04f51c63          	bne	a0,a5,1546 <truncate3+0x19c>
    close(fd);
    14f2:	8526                	mv	a0,s1
    14f4:	00004097          	auipc	ra,0x4
    14f8:	388080e7          	jalr	904(ra) # 587c <close>
  for(int i = 0; i < 150; i++){
    14fc:	39fd                	addiw	s3,s3,-1
    14fe:	fc0997e3          	bnez	s3,14cc <truncate3+0x122>
  wait(&xstatus);
    1502:	fbc40513          	addi	a0,s0,-68
    1506:	00004097          	auipc	ra,0x4
    150a:	356080e7          	jalr	854(ra) # 585c <wait>
  unlink("truncfile");
    150e:	00005517          	auipc	a0,0x5
    1512:	c5a50513          	addi	a0,a0,-934 # 6168 <malloc+0x4d6>
    1516:	00004097          	auipc	ra,0x4
    151a:	38e080e7          	jalr	910(ra) # 58a4 <unlink>
  exit(xstatus);
    151e:	fbc42503          	lw	a0,-68(s0)
    1522:	00004097          	auipc	ra,0x4
    1526:	332080e7          	jalr	818(ra) # 5854 <exit>
      printf("%s: open failed\n", s);
    152a:	85ca                	mv	a1,s2
    152c:	00005517          	auipc	a0,0x5
    1530:	43450513          	addi	a0,a0,1076 # 6960 <malloc+0xcce>
    1534:	00004097          	auipc	ra,0x4
    1538:	6a0080e7          	jalr	1696(ra) # 5bd4 <printf>
      exit(1);
    153c:	4505                	li	a0,1
    153e:	00004097          	auipc	ra,0x4
    1542:	316080e7          	jalr	790(ra) # 5854 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1546:	862a                	mv	a2,a0
    1548:	85ca                	mv	a1,s2
    154a:	00005517          	auipc	a0,0x5
    154e:	46650513          	addi	a0,a0,1126 # 69b0 <malloc+0xd1e>
    1552:	00004097          	auipc	ra,0x4
    1556:	682080e7          	jalr	1666(ra) # 5bd4 <printf>
      exit(1);
    155a:	4505                	li	a0,1
    155c:	00004097          	auipc	ra,0x4
    1560:	2f8080e7          	jalr	760(ra) # 5854 <exit>

0000000000001564 <exectest>:
{
    1564:	715d                	addi	sp,sp,-80
    1566:	e486                	sd	ra,72(sp)
    1568:	e0a2                	sd	s0,64(sp)
    156a:	fc26                	sd	s1,56(sp)
    156c:	f84a                	sd	s2,48(sp)
    156e:	0880                	addi	s0,sp,80
    1570:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1572:	00005797          	auipc	a5,0x5
    1576:	b9e78793          	addi	a5,a5,-1122 # 6110 <malloc+0x47e>
    157a:	fcf43023          	sd	a5,-64(s0)
    157e:	00005797          	auipc	a5,0x5
    1582:	45278793          	addi	a5,a5,1106 # 69d0 <malloc+0xd3e>
    1586:	fcf43423          	sd	a5,-56(s0)
    158a:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    158e:	00005517          	auipc	a0,0x5
    1592:	44a50513          	addi	a0,a0,1098 # 69d8 <malloc+0xd46>
    1596:	00004097          	auipc	ra,0x4
    159a:	30e080e7          	jalr	782(ra) # 58a4 <unlink>
  pid = fork();
    159e:	00004097          	auipc	ra,0x4
    15a2:	2ae080e7          	jalr	686(ra) # 584c <fork>
  if(pid < 0) {
    15a6:	04054663          	bltz	a0,15f2 <exectest+0x8e>
    15aa:	84aa                	mv	s1,a0
  if(pid == 0) {
    15ac:	e959                	bnez	a0,1642 <exectest+0xde>
    close(1);
    15ae:	4505                	li	a0,1
    15b0:	00004097          	auipc	ra,0x4
    15b4:	2cc080e7          	jalr	716(ra) # 587c <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15b8:	20100593          	li	a1,513
    15bc:	00005517          	auipc	a0,0x5
    15c0:	41c50513          	addi	a0,a0,1052 # 69d8 <malloc+0xd46>
    15c4:	00004097          	auipc	ra,0x4
    15c8:	2d0080e7          	jalr	720(ra) # 5894 <open>
    if(fd < 0) {
    15cc:	04054163          	bltz	a0,160e <exectest+0xaa>
    if(fd != 1) {
    15d0:	4785                	li	a5,1
    15d2:	04f50c63          	beq	a0,a5,162a <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15d6:	85ca                	mv	a1,s2
    15d8:	00005517          	auipc	a0,0x5
    15dc:	42050513          	addi	a0,a0,1056 # 69f8 <malloc+0xd66>
    15e0:	00004097          	auipc	ra,0x4
    15e4:	5f4080e7          	jalr	1524(ra) # 5bd4 <printf>
      exit(1);
    15e8:	4505                	li	a0,1
    15ea:	00004097          	auipc	ra,0x4
    15ee:	26a080e7          	jalr	618(ra) # 5854 <exit>
     printf("%s: fork failed\n", s);
    15f2:	85ca                	mv	a1,s2
    15f4:	00005517          	auipc	a0,0x5
    15f8:	35450513          	addi	a0,a0,852 # 6948 <malloc+0xcb6>
    15fc:	00004097          	auipc	ra,0x4
    1600:	5d8080e7          	jalr	1496(ra) # 5bd4 <printf>
     exit(1);
    1604:	4505                	li	a0,1
    1606:	00004097          	auipc	ra,0x4
    160a:	24e080e7          	jalr	590(ra) # 5854 <exit>
      printf("%s: create failed\n", s);
    160e:	85ca                	mv	a1,s2
    1610:	00005517          	auipc	a0,0x5
    1614:	3d050513          	addi	a0,a0,976 # 69e0 <malloc+0xd4e>
    1618:	00004097          	auipc	ra,0x4
    161c:	5bc080e7          	jalr	1468(ra) # 5bd4 <printf>
      exit(1);
    1620:	4505                	li	a0,1
    1622:	00004097          	auipc	ra,0x4
    1626:	232080e7          	jalr	562(ra) # 5854 <exit>
    if(exec("echo", echoargv) < 0){
    162a:	fc040593          	addi	a1,s0,-64
    162e:	00005517          	auipc	a0,0x5
    1632:	ae250513          	addi	a0,a0,-1310 # 6110 <malloc+0x47e>
    1636:	00004097          	auipc	ra,0x4
    163a:	256080e7          	jalr	598(ra) # 588c <exec>
    163e:	02054163          	bltz	a0,1660 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1642:	fdc40513          	addi	a0,s0,-36
    1646:	00004097          	auipc	ra,0x4
    164a:	216080e7          	jalr	534(ra) # 585c <wait>
    164e:	02951763          	bne	a0,s1,167c <exectest+0x118>
  if(xstatus != 0)
    1652:	fdc42503          	lw	a0,-36(s0)
    1656:	cd0d                	beqz	a0,1690 <exectest+0x12c>
    exit(xstatus);
    1658:	00004097          	auipc	ra,0x4
    165c:	1fc080e7          	jalr	508(ra) # 5854 <exit>
      printf("%s: exec echo failed\n", s);
    1660:	85ca                	mv	a1,s2
    1662:	00005517          	auipc	a0,0x5
    1666:	3a650513          	addi	a0,a0,934 # 6a08 <malloc+0xd76>
    166a:	00004097          	auipc	ra,0x4
    166e:	56a080e7          	jalr	1386(ra) # 5bd4 <printf>
      exit(1);
    1672:	4505                	li	a0,1
    1674:	00004097          	auipc	ra,0x4
    1678:	1e0080e7          	jalr	480(ra) # 5854 <exit>
    printf("%s: wait failed!\n", s);
    167c:	85ca                	mv	a1,s2
    167e:	00005517          	auipc	a0,0x5
    1682:	3a250513          	addi	a0,a0,930 # 6a20 <malloc+0xd8e>
    1686:	00004097          	auipc	ra,0x4
    168a:	54e080e7          	jalr	1358(ra) # 5bd4 <printf>
    168e:	b7d1                	j	1652 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1690:	4581                	li	a1,0
    1692:	00005517          	auipc	a0,0x5
    1696:	34650513          	addi	a0,a0,838 # 69d8 <malloc+0xd46>
    169a:	00004097          	auipc	ra,0x4
    169e:	1fa080e7          	jalr	506(ra) # 5894 <open>
  if(fd < 0) {
    16a2:	02054a63          	bltz	a0,16d6 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16a6:	4609                	li	a2,2
    16a8:	fb840593          	addi	a1,s0,-72
    16ac:	00004097          	auipc	ra,0x4
    16b0:	1c0080e7          	jalr	448(ra) # 586c <read>
    16b4:	4789                	li	a5,2
    16b6:	02f50e63          	beq	a0,a5,16f2 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16ba:	85ca                	mv	a1,s2
    16bc:	00005517          	auipc	a0,0x5
    16c0:	de450513          	addi	a0,a0,-540 # 64a0 <malloc+0x80e>
    16c4:	00004097          	auipc	ra,0x4
    16c8:	510080e7          	jalr	1296(ra) # 5bd4 <printf>
    exit(1);
    16cc:	4505                	li	a0,1
    16ce:	00004097          	auipc	ra,0x4
    16d2:	186080e7          	jalr	390(ra) # 5854 <exit>
    printf("%s: open failed\n", s);
    16d6:	85ca                	mv	a1,s2
    16d8:	00005517          	auipc	a0,0x5
    16dc:	28850513          	addi	a0,a0,648 # 6960 <malloc+0xcce>
    16e0:	00004097          	auipc	ra,0x4
    16e4:	4f4080e7          	jalr	1268(ra) # 5bd4 <printf>
    exit(1);
    16e8:	4505                	li	a0,1
    16ea:	00004097          	auipc	ra,0x4
    16ee:	16a080e7          	jalr	362(ra) # 5854 <exit>
  unlink("echo-ok");
    16f2:	00005517          	auipc	a0,0x5
    16f6:	2e650513          	addi	a0,a0,742 # 69d8 <malloc+0xd46>
    16fa:	00004097          	auipc	ra,0x4
    16fe:	1aa080e7          	jalr	426(ra) # 58a4 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1702:	fb844703          	lbu	a4,-72(s0)
    1706:	04f00793          	li	a5,79
    170a:	00f71863          	bne	a4,a5,171a <exectest+0x1b6>
    170e:	fb944703          	lbu	a4,-71(s0)
    1712:	04b00793          	li	a5,75
    1716:	02f70063          	beq	a4,a5,1736 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    171a:	85ca                	mv	a1,s2
    171c:	00005517          	auipc	a0,0x5
    1720:	31c50513          	addi	a0,a0,796 # 6a38 <malloc+0xda6>
    1724:	00004097          	auipc	ra,0x4
    1728:	4b0080e7          	jalr	1200(ra) # 5bd4 <printf>
    exit(1);
    172c:	4505                	li	a0,1
    172e:	00004097          	auipc	ra,0x4
    1732:	126080e7          	jalr	294(ra) # 5854 <exit>
    exit(0);
    1736:	4501                	li	a0,0
    1738:	00004097          	auipc	ra,0x4
    173c:	11c080e7          	jalr	284(ra) # 5854 <exit>

0000000000001740 <pipe1>:
{
    1740:	711d                	addi	sp,sp,-96
    1742:	ec86                	sd	ra,88(sp)
    1744:	e8a2                	sd	s0,80(sp)
    1746:	e4a6                	sd	s1,72(sp)
    1748:	e0ca                	sd	s2,64(sp)
    174a:	fc4e                	sd	s3,56(sp)
    174c:	f852                	sd	s4,48(sp)
    174e:	f456                	sd	s5,40(sp)
    1750:	f05a                	sd	s6,32(sp)
    1752:	ec5e                	sd	s7,24(sp)
    1754:	1080                	addi	s0,sp,96
    1756:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1758:	fa840513          	addi	a0,s0,-88
    175c:	00004097          	auipc	ra,0x4
    1760:	108080e7          	jalr	264(ra) # 5864 <pipe>
    1764:	ed25                	bnez	a0,17dc <pipe1+0x9c>
    1766:	84aa                	mv	s1,a0
  pid = fork();
    1768:	00004097          	auipc	ra,0x4
    176c:	0e4080e7          	jalr	228(ra) # 584c <fork>
    1770:	8a2a                	mv	s4,a0
  if(pid == 0){
    1772:	c159                	beqz	a0,17f8 <pipe1+0xb8>
  } else if(pid > 0){
    1774:	16a05e63          	blez	a0,18f0 <pipe1+0x1b0>
    close(fds[1]);
    1778:	fac42503          	lw	a0,-84(s0)
    177c:	00004097          	auipc	ra,0x4
    1780:	100080e7          	jalr	256(ra) # 587c <close>
    total = 0;
    1784:	8a26                	mv	s4,s1
    cc = 1;
    1786:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1788:	0000aa97          	auipc	s5,0xa
    178c:	610a8a93          	addi	s5,s5,1552 # bd98 <buf>
      if(cc > sizeof(buf))
    1790:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1792:	864e                	mv	a2,s3
    1794:	85d6                	mv	a1,s5
    1796:	fa842503          	lw	a0,-88(s0)
    179a:	00004097          	auipc	ra,0x4
    179e:	0d2080e7          	jalr	210(ra) # 586c <read>
    17a2:	10a05263          	blez	a0,18a6 <pipe1+0x166>
      for(i = 0; i < n; i++){
    17a6:	0000a717          	auipc	a4,0xa
    17aa:	5f270713          	addi	a4,a4,1522 # bd98 <buf>
    17ae:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17b2:	00074683          	lbu	a3,0(a4)
    17b6:	0ff4f793          	andi	a5,s1,255
    17ba:	2485                	addiw	s1,s1,1
    17bc:	0cf69163          	bne	a3,a5,187e <pipe1+0x13e>
      for(i = 0; i < n; i++){
    17c0:	0705                	addi	a4,a4,1
    17c2:	fec498e3          	bne	s1,a2,17b2 <pipe1+0x72>
      total += n;
    17c6:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17ca:	0019979b          	slliw	a5,s3,0x1
    17ce:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17d2:	013b7363          	bgeu	s6,s3,17d8 <pipe1+0x98>
        cc = sizeof(buf);
    17d6:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17d8:	84b2                	mv	s1,a2
    17da:	bf65                	j	1792 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17dc:	85ca                	mv	a1,s2
    17de:	00005517          	auipc	a0,0x5
    17e2:	27250513          	addi	a0,a0,626 # 6a50 <malloc+0xdbe>
    17e6:	00004097          	auipc	ra,0x4
    17ea:	3ee080e7          	jalr	1006(ra) # 5bd4 <printf>
    exit(1);
    17ee:	4505                	li	a0,1
    17f0:	00004097          	auipc	ra,0x4
    17f4:	064080e7          	jalr	100(ra) # 5854 <exit>
    close(fds[0]);
    17f8:	fa842503          	lw	a0,-88(s0)
    17fc:	00004097          	auipc	ra,0x4
    1800:	080080e7          	jalr	128(ra) # 587c <close>
    for(n = 0; n < N; n++){
    1804:	0000ab17          	auipc	s6,0xa
    1808:	594b0b13          	addi	s6,s6,1428 # bd98 <buf>
    180c:	416004bb          	negw	s1,s6
    1810:	0ff4f493          	andi	s1,s1,255
    1814:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1818:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    181a:	6a85                	lui	s5,0x1
    181c:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x83>
{
    1820:	87da                	mv	a5,s6
        buf[i] = seq++;
    1822:	0097873b          	addw	a4,a5,s1
    1826:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    182a:	0785                	addi	a5,a5,1
    182c:	fef99be3          	bne	s3,a5,1822 <pipe1+0xe2>
    1830:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1834:	40900613          	li	a2,1033
    1838:	85de                	mv	a1,s7
    183a:	fac42503          	lw	a0,-84(s0)
    183e:	00004097          	auipc	ra,0x4
    1842:	036080e7          	jalr	54(ra) # 5874 <write>
    1846:	40900793          	li	a5,1033
    184a:	00f51c63          	bne	a0,a5,1862 <pipe1+0x122>
    for(n = 0; n < N; n++){
    184e:	24a5                	addiw	s1,s1,9
    1850:	0ff4f493          	andi	s1,s1,255
    1854:	fd5a16e3          	bne	s4,s5,1820 <pipe1+0xe0>
    exit(0);
    1858:	4501                	li	a0,0
    185a:	00004097          	auipc	ra,0x4
    185e:	ffa080e7          	jalr	-6(ra) # 5854 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1862:	85ca                	mv	a1,s2
    1864:	00005517          	auipc	a0,0x5
    1868:	20450513          	addi	a0,a0,516 # 6a68 <malloc+0xdd6>
    186c:	00004097          	auipc	ra,0x4
    1870:	368080e7          	jalr	872(ra) # 5bd4 <printf>
        exit(1);
    1874:	4505                	li	a0,1
    1876:	00004097          	auipc	ra,0x4
    187a:	fde080e7          	jalr	-34(ra) # 5854 <exit>
          printf("%s: pipe1 oops 2\n", s);
    187e:	85ca                	mv	a1,s2
    1880:	00005517          	auipc	a0,0x5
    1884:	20050513          	addi	a0,a0,512 # 6a80 <malloc+0xdee>
    1888:	00004097          	auipc	ra,0x4
    188c:	34c080e7          	jalr	844(ra) # 5bd4 <printf>
}
    1890:	60e6                	ld	ra,88(sp)
    1892:	6446                	ld	s0,80(sp)
    1894:	64a6                	ld	s1,72(sp)
    1896:	6906                	ld	s2,64(sp)
    1898:	79e2                	ld	s3,56(sp)
    189a:	7a42                	ld	s4,48(sp)
    189c:	7aa2                	ld	s5,40(sp)
    189e:	7b02                	ld	s6,32(sp)
    18a0:	6be2                	ld	s7,24(sp)
    18a2:	6125                	addi	sp,sp,96
    18a4:	8082                	ret
    if(total != N * SZ){
    18a6:	6785                	lui	a5,0x1
    18a8:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x83>
    18ac:	02fa0063          	beq	s4,a5,18cc <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18b0:	85d2                	mv	a1,s4
    18b2:	00005517          	auipc	a0,0x5
    18b6:	1e650513          	addi	a0,a0,486 # 6a98 <malloc+0xe06>
    18ba:	00004097          	auipc	ra,0x4
    18be:	31a080e7          	jalr	794(ra) # 5bd4 <printf>
      exit(1);
    18c2:	4505                	li	a0,1
    18c4:	00004097          	auipc	ra,0x4
    18c8:	f90080e7          	jalr	-112(ra) # 5854 <exit>
    close(fds[0]);
    18cc:	fa842503          	lw	a0,-88(s0)
    18d0:	00004097          	auipc	ra,0x4
    18d4:	fac080e7          	jalr	-84(ra) # 587c <close>
    wait(&xstatus);
    18d8:	fa440513          	addi	a0,s0,-92
    18dc:	00004097          	auipc	ra,0x4
    18e0:	f80080e7          	jalr	-128(ra) # 585c <wait>
    exit(xstatus);
    18e4:	fa442503          	lw	a0,-92(s0)
    18e8:	00004097          	auipc	ra,0x4
    18ec:	f6c080e7          	jalr	-148(ra) # 5854 <exit>
    printf("%s: fork() failed\n", s);
    18f0:	85ca                	mv	a1,s2
    18f2:	00005517          	auipc	a0,0x5
    18f6:	1c650513          	addi	a0,a0,454 # 6ab8 <malloc+0xe26>
    18fa:	00004097          	auipc	ra,0x4
    18fe:	2da080e7          	jalr	730(ra) # 5bd4 <printf>
    exit(1);
    1902:	4505                	li	a0,1
    1904:	00004097          	auipc	ra,0x4
    1908:	f50080e7          	jalr	-176(ra) # 5854 <exit>

000000000000190c <exitwait>:
{
    190c:	7139                	addi	sp,sp,-64
    190e:	fc06                	sd	ra,56(sp)
    1910:	f822                	sd	s0,48(sp)
    1912:	f426                	sd	s1,40(sp)
    1914:	f04a                	sd	s2,32(sp)
    1916:	ec4e                	sd	s3,24(sp)
    1918:	e852                	sd	s4,16(sp)
    191a:	0080                	addi	s0,sp,64
    191c:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    191e:	4901                	li	s2,0
    1920:	06400993          	li	s3,100
    pid = fork();
    1924:	00004097          	auipc	ra,0x4
    1928:	f28080e7          	jalr	-216(ra) # 584c <fork>
    192c:	84aa                	mv	s1,a0
    if(pid < 0){
    192e:	02054a63          	bltz	a0,1962 <exitwait+0x56>
    if(pid){
    1932:	c151                	beqz	a0,19b6 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1934:	fcc40513          	addi	a0,s0,-52
    1938:	00004097          	auipc	ra,0x4
    193c:	f24080e7          	jalr	-220(ra) # 585c <wait>
    1940:	02951f63          	bne	a0,s1,197e <exitwait+0x72>
      if(i != xstate) {
    1944:	fcc42783          	lw	a5,-52(s0)
    1948:	05279963          	bne	a5,s2,199a <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    194c:	2905                	addiw	s2,s2,1
    194e:	fd391be3          	bne	s2,s3,1924 <exitwait+0x18>
}
    1952:	70e2                	ld	ra,56(sp)
    1954:	7442                	ld	s0,48(sp)
    1956:	74a2                	ld	s1,40(sp)
    1958:	7902                	ld	s2,32(sp)
    195a:	69e2                	ld	s3,24(sp)
    195c:	6a42                	ld	s4,16(sp)
    195e:	6121                	addi	sp,sp,64
    1960:	8082                	ret
      printf("%s: fork failed\n", s);
    1962:	85d2                	mv	a1,s4
    1964:	00005517          	auipc	a0,0x5
    1968:	fe450513          	addi	a0,a0,-28 # 6948 <malloc+0xcb6>
    196c:	00004097          	auipc	ra,0x4
    1970:	268080e7          	jalr	616(ra) # 5bd4 <printf>
      exit(1);
    1974:	4505                	li	a0,1
    1976:	00004097          	auipc	ra,0x4
    197a:	ede080e7          	jalr	-290(ra) # 5854 <exit>
        printf("%s: wait wrong pid\n", s);
    197e:	85d2                	mv	a1,s4
    1980:	00005517          	auipc	a0,0x5
    1984:	15050513          	addi	a0,a0,336 # 6ad0 <malloc+0xe3e>
    1988:	00004097          	auipc	ra,0x4
    198c:	24c080e7          	jalr	588(ra) # 5bd4 <printf>
        exit(1);
    1990:	4505                	li	a0,1
    1992:	00004097          	auipc	ra,0x4
    1996:	ec2080e7          	jalr	-318(ra) # 5854 <exit>
        printf("%s: wait wrong exit status\n", s);
    199a:	85d2                	mv	a1,s4
    199c:	00005517          	auipc	a0,0x5
    19a0:	14c50513          	addi	a0,a0,332 # 6ae8 <malloc+0xe56>
    19a4:	00004097          	auipc	ra,0x4
    19a8:	230080e7          	jalr	560(ra) # 5bd4 <printf>
        exit(1);
    19ac:	4505                	li	a0,1
    19ae:	00004097          	auipc	ra,0x4
    19b2:	ea6080e7          	jalr	-346(ra) # 5854 <exit>
      exit(i);
    19b6:	854a                	mv	a0,s2
    19b8:	00004097          	auipc	ra,0x4
    19bc:	e9c080e7          	jalr	-356(ra) # 5854 <exit>

00000000000019c0 <twochildren>:
{
    19c0:	1101                	addi	sp,sp,-32
    19c2:	ec06                	sd	ra,24(sp)
    19c4:	e822                	sd	s0,16(sp)
    19c6:	e426                	sd	s1,8(sp)
    19c8:	e04a                	sd	s2,0(sp)
    19ca:	1000                	addi	s0,sp,32
    19cc:	892a                	mv	s2,a0
    19ce:	3e800493          	li	s1,1000
    int pid1 = fork();
    19d2:	00004097          	auipc	ra,0x4
    19d6:	e7a080e7          	jalr	-390(ra) # 584c <fork>
    if(pid1 < 0){
    19da:	02054c63          	bltz	a0,1a12 <twochildren+0x52>
    if(pid1 == 0){
    19de:	c921                	beqz	a0,1a2e <twochildren+0x6e>
      int pid2 = fork();
    19e0:	00004097          	auipc	ra,0x4
    19e4:	e6c080e7          	jalr	-404(ra) # 584c <fork>
      if(pid2 < 0){
    19e8:	04054763          	bltz	a0,1a36 <twochildren+0x76>
      if(pid2 == 0){
    19ec:	c13d                	beqz	a0,1a52 <twochildren+0x92>
        wait(0);
    19ee:	4501                	li	a0,0
    19f0:	00004097          	auipc	ra,0x4
    19f4:	e6c080e7          	jalr	-404(ra) # 585c <wait>
        wait(0);
    19f8:	4501                	li	a0,0
    19fa:	00004097          	auipc	ra,0x4
    19fe:	e62080e7          	jalr	-414(ra) # 585c <wait>
  for(int i = 0; i < 1000; i++){
    1a02:	34fd                	addiw	s1,s1,-1
    1a04:	f4f9                	bnez	s1,19d2 <twochildren+0x12>
}
    1a06:	60e2                	ld	ra,24(sp)
    1a08:	6442                	ld	s0,16(sp)
    1a0a:	64a2                	ld	s1,8(sp)
    1a0c:	6902                	ld	s2,0(sp)
    1a0e:	6105                	addi	sp,sp,32
    1a10:	8082                	ret
      printf("%s: fork failed\n", s);
    1a12:	85ca                	mv	a1,s2
    1a14:	00005517          	auipc	a0,0x5
    1a18:	f3450513          	addi	a0,a0,-204 # 6948 <malloc+0xcb6>
    1a1c:	00004097          	auipc	ra,0x4
    1a20:	1b8080e7          	jalr	440(ra) # 5bd4 <printf>
      exit(1);
    1a24:	4505                	li	a0,1
    1a26:	00004097          	auipc	ra,0x4
    1a2a:	e2e080e7          	jalr	-466(ra) # 5854 <exit>
      exit(0);
    1a2e:	00004097          	auipc	ra,0x4
    1a32:	e26080e7          	jalr	-474(ra) # 5854 <exit>
        printf("%s: fork failed\n", s);
    1a36:	85ca                	mv	a1,s2
    1a38:	00005517          	auipc	a0,0x5
    1a3c:	f1050513          	addi	a0,a0,-240 # 6948 <malloc+0xcb6>
    1a40:	00004097          	auipc	ra,0x4
    1a44:	194080e7          	jalr	404(ra) # 5bd4 <printf>
        exit(1);
    1a48:	4505                	li	a0,1
    1a4a:	00004097          	auipc	ra,0x4
    1a4e:	e0a080e7          	jalr	-502(ra) # 5854 <exit>
        exit(0);
    1a52:	00004097          	auipc	ra,0x4
    1a56:	e02080e7          	jalr	-510(ra) # 5854 <exit>

0000000000001a5a <forkfork>:
{
    1a5a:	7179                	addi	sp,sp,-48
    1a5c:	f406                	sd	ra,40(sp)
    1a5e:	f022                	sd	s0,32(sp)
    1a60:	ec26                	sd	s1,24(sp)
    1a62:	1800                	addi	s0,sp,48
    1a64:	84aa                	mv	s1,a0
    int pid = fork();
    1a66:	00004097          	auipc	ra,0x4
    1a6a:	de6080e7          	jalr	-538(ra) # 584c <fork>
    if(pid < 0){
    1a6e:	04054163          	bltz	a0,1ab0 <forkfork+0x56>
    if(pid == 0){
    1a72:	cd29                	beqz	a0,1acc <forkfork+0x72>
    int pid = fork();
    1a74:	00004097          	auipc	ra,0x4
    1a78:	dd8080e7          	jalr	-552(ra) # 584c <fork>
    if(pid < 0){
    1a7c:	02054a63          	bltz	a0,1ab0 <forkfork+0x56>
    if(pid == 0){
    1a80:	c531                	beqz	a0,1acc <forkfork+0x72>
    wait(&xstatus);
    1a82:	fdc40513          	addi	a0,s0,-36
    1a86:	00004097          	auipc	ra,0x4
    1a8a:	dd6080e7          	jalr	-554(ra) # 585c <wait>
    if(xstatus != 0) {
    1a8e:	fdc42783          	lw	a5,-36(s0)
    1a92:	ebbd                	bnez	a5,1b08 <forkfork+0xae>
    wait(&xstatus);
    1a94:	fdc40513          	addi	a0,s0,-36
    1a98:	00004097          	auipc	ra,0x4
    1a9c:	dc4080e7          	jalr	-572(ra) # 585c <wait>
    if(xstatus != 0) {
    1aa0:	fdc42783          	lw	a5,-36(s0)
    1aa4:	e3b5                	bnez	a5,1b08 <forkfork+0xae>
}
    1aa6:	70a2                	ld	ra,40(sp)
    1aa8:	7402                	ld	s0,32(sp)
    1aaa:	64e2                	ld	s1,24(sp)
    1aac:	6145                	addi	sp,sp,48
    1aae:	8082                	ret
      printf("%s: fork failed", s);
    1ab0:	85a6                	mv	a1,s1
    1ab2:	00005517          	auipc	a0,0x5
    1ab6:	05650513          	addi	a0,a0,86 # 6b08 <malloc+0xe76>
    1aba:	00004097          	auipc	ra,0x4
    1abe:	11a080e7          	jalr	282(ra) # 5bd4 <printf>
      exit(1);
    1ac2:	4505                	li	a0,1
    1ac4:	00004097          	auipc	ra,0x4
    1ac8:	d90080e7          	jalr	-624(ra) # 5854 <exit>
{
    1acc:	0c800493          	li	s1,200
        int pid1 = fork();
    1ad0:	00004097          	auipc	ra,0x4
    1ad4:	d7c080e7          	jalr	-644(ra) # 584c <fork>
        if(pid1 < 0){
    1ad8:	00054f63          	bltz	a0,1af6 <forkfork+0x9c>
        if(pid1 == 0){
    1adc:	c115                	beqz	a0,1b00 <forkfork+0xa6>
        wait(0);
    1ade:	4501                	li	a0,0
    1ae0:	00004097          	auipc	ra,0x4
    1ae4:	d7c080e7          	jalr	-644(ra) # 585c <wait>
      for(int j = 0; j < 200; j++){
    1ae8:	34fd                	addiw	s1,s1,-1
    1aea:	f0fd                	bnez	s1,1ad0 <forkfork+0x76>
      exit(0);
    1aec:	4501                	li	a0,0
    1aee:	00004097          	auipc	ra,0x4
    1af2:	d66080e7          	jalr	-666(ra) # 5854 <exit>
          exit(1);
    1af6:	4505                	li	a0,1
    1af8:	00004097          	auipc	ra,0x4
    1afc:	d5c080e7          	jalr	-676(ra) # 5854 <exit>
          exit(0);
    1b00:	00004097          	auipc	ra,0x4
    1b04:	d54080e7          	jalr	-684(ra) # 5854 <exit>
      printf("%s: fork in child failed", s);
    1b08:	85a6                	mv	a1,s1
    1b0a:	00005517          	auipc	a0,0x5
    1b0e:	00e50513          	addi	a0,a0,14 # 6b18 <malloc+0xe86>
    1b12:	00004097          	auipc	ra,0x4
    1b16:	0c2080e7          	jalr	194(ra) # 5bd4 <printf>
      exit(1);
    1b1a:	4505                	li	a0,1
    1b1c:	00004097          	auipc	ra,0x4
    1b20:	d38080e7          	jalr	-712(ra) # 5854 <exit>

0000000000001b24 <reparent2>:
{
    1b24:	1101                	addi	sp,sp,-32
    1b26:	ec06                	sd	ra,24(sp)
    1b28:	e822                	sd	s0,16(sp)
    1b2a:	e426                	sd	s1,8(sp)
    1b2c:	1000                	addi	s0,sp,32
    1b2e:	32000493          	li	s1,800
    int pid1 = fork();
    1b32:	00004097          	auipc	ra,0x4
    1b36:	d1a080e7          	jalr	-742(ra) # 584c <fork>
    if(pid1 < 0){
    1b3a:	00054f63          	bltz	a0,1b58 <reparent2+0x34>
    if(pid1 == 0){
    1b3e:	c915                	beqz	a0,1b72 <reparent2+0x4e>
    wait(0);
    1b40:	4501                	li	a0,0
    1b42:	00004097          	auipc	ra,0x4
    1b46:	d1a080e7          	jalr	-742(ra) # 585c <wait>
  for(int i = 0; i < 800; i++){
    1b4a:	34fd                	addiw	s1,s1,-1
    1b4c:	f0fd                	bnez	s1,1b32 <reparent2+0xe>
  exit(0);
    1b4e:	4501                	li	a0,0
    1b50:	00004097          	auipc	ra,0x4
    1b54:	d04080e7          	jalr	-764(ra) # 5854 <exit>
      printf("fork failed\n");
    1b58:	00005517          	auipc	a0,0x5
    1b5c:	21050513          	addi	a0,a0,528 # 6d68 <malloc+0x10d6>
    1b60:	00004097          	auipc	ra,0x4
    1b64:	074080e7          	jalr	116(ra) # 5bd4 <printf>
      exit(1);
    1b68:	4505                	li	a0,1
    1b6a:	00004097          	auipc	ra,0x4
    1b6e:	cea080e7          	jalr	-790(ra) # 5854 <exit>
      fork();
    1b72:	00004097          	auipc	ra,0x4
    1b76:	cda080e7          	jalr	-806(ra) # 584c <fork>
      fork();
    1b7a:	00004097          	auipc	ra,0x4
    1b7e:	cd2080e7          	jalr	-814(ra) # 584c <fork>
      exit(0);
    1b82:	4501                	li	a0,0
    1b84:	00004097          	auipc	ra,0x4
    1b88:	cd0080e7          	jalr	-816(ra) # 5854 <exit>

0000000000001b8c <createdelete>:
{
    1b8c:	7175                	addi	sp,sp,-144
    1b8e:	e506                	sd	ra,136(sp)
    1b90:	e122                	sd	s0,128(sp)
    1b92:	fca6                	sd	s1,120(sp)
    1b94:	f8ca                	sd	s2,112(sp)
    1b96:	f4ce                	sd	s3,104(sp)
    1b98:	f0d2                	sd	s4,96(sp)
    1b9a:	ecd6                	sd	s5,88(sp)
    1b9c:	e8da                	sd	s6,80(sp)
    1b9e:	e4de                	sd	s7,72(sp)
    1ba0:	e0e2                	sd	s8,64(sp)
    1ba2:	fc66                	sd	s9,56(sp)
    1ba4:	0900                	addi	s0,sp,144
    1ba6:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1ba8:	4901                	li	s2,0
    1baa:	4991                	li	s3,4
    pid = fork();
    1bac:	00004097          	auipc	ra,0x4
    1bb0:	ca0080e7          	jalr	-864(ra) # 584c <fork>
    1bb4:	84aa                	mv	s1,a0
    if(pid < 0){
    1bb6:	02054f63          	bltz	a0,1bf4 <createdelete+0x68>
    if(pid == 0){
    1bba:	c939                	beqz	a0,1c10 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bbc:	2905                	addiw	s2,s2,1
    1bbe:	ff3917e3          	bne	s2,s3,1bac <createdelete+0x20>
    1bc2:	4491                	li	s1,4
    wait(&xstatus);
    1bc4:	f7c40513          	addi	a0,s0,-132
    1bc8:	00004097          	auipc	ra,0x4
    1bcc:	c94080e7          	jalr	-876(ra) # 585c <wait>
    if(xstatus != 0)
    1bd0:	f7c42903          	lw	s2,-132(s0)
    1bd4:	0e091263          	bnez	s2,1cb8 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bd8:	34fd                	addiw	s1,s1,-1
    1bda:	f4ed                	bnez	s1,1bc4 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bdc:	f8040123          	sb	zero,-126(s0)
    1be0:	03000993          	li	s3,48
    1be4:	5a7d                	li	s4,-1
    1be6:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1bea:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1bec:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1bee:	07400a93          	li	s5,116
    1bf2:	a29d                	j	1d58 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bf4:	85e6                	mv	a1,s9
    1bf6:	00005517          	auipc	a0,0x5
    1bfa:	17250513          	addi	a0,a0,370 # 6d68 <malloc+0x10d6>
    1bfe:	00004097          	auipc	ra,0x4
    1c02:	fd6080e7          	jalr	-42(ra) # 5bd4 <printf>
      exit(1);
    1c06:	4505                	li	a0,1
    1c08:	00004097          	auipc	ra,0x4
    1c0c:	c4c080e7          	jalr	-948(ra) # 5854 <exit>
      name[0] = 'p' + pi;
    1c10:	0709091b          	addiw	s2,s2,112
    1c14:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c18:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c1c:	4951                	li	s2,20
    1c1e:	a015                	j	1c42 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c20:	85e6                	mv	a1,s9
    1c22:	00005517          	auipc	a0,0x5
    1c26:	dbe50513          	addi	a0,a0,-578 # 69e0 <malloc+0xd4e>
    1c2a:	00004097          	auipc	ra,0x4
    1c2e:	faa080e7          	jalr	-86(ra) # 5bd4 <printf>
          exit(1);
    1c32:	4505                	li	a0,1
    1c34:	00004097          	auipc	ra,0x4
    1c38:	c20080e7          	jalr	-992(ra) # 5854 <exit>
      for(i = 0; i < N; i++){
    1c3c:	2485                	addiw	s1,s1,1
    1c3e:	07248863          	beq	s1,s2,1cae <createdelete+0x122>
        name[1] = '0' + i;
    1c42:	0304879b          	addiw	a5,s1,48
    1c46:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c4a:	20200593          	li	a1,514
    1c4e:	f8040513          	addi	a0,s0,-128
    1c52:	00004097          	auipc	ra,0x4
    1c56:	c42080e7          	jalr	-958(ra) # 5894 <open>
        if(fd < 0){
    1c5a:	fc0543e3          	bltz	a0,1c20 <createdelete+0x94>
        close(fd);
    1c5e:	00004097          	auipc	ra,0x4
    1c62:	c1e080e7          	jalr	-994(ra) # 587c <close>
        if(i > 0 && (i % 2 ) == 0){
    1c66:	fc905be3          	blez	s1,1c3c <createdelete+0xb0>
    1c6a:	0014f793          	andi	a5,s1,1
    1c6e:	f7f9                	bnez	a5,1c3c <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c70:	01f4d79b          	srliw	a5,s1,0x1f
    1c74:	9fa5                	addw	a5,a5,s1
    1c76:	4017d79b          	sraiw	a5,a5,0x1
    1c7a:	0307879b          	addiw	a5,a5,48
    1c7e:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c82:	f8040513          	addi	a0,s0,-128
    1c86:	00004097          	auipc	ra,0x4
    1c8a:	c1e080e7          	jalr	-994(ra) # 58a4 <unlink>
    1c8e:	fa0557e3          	bgez	a0,1c3c <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c92:	85e6                	mv	a1,s9
    1c94:	00005517          	auipc	a0,0x5
    1c98:	ea450513          	addi	a0,a0,-348 # 6b38 <malloc+0xea6>
    1c9c:	00004097          	auipc	ra,0x4
    1ca0:	f38080e7          	jalr	-200(ra) # 5bd4 <printf>
            exit(1);
    1ca4:	4505                	li	a0,1
    1ca6:	00004097          	auipc	ra,0x4
    1caa:	bae080e7          	jalr	-1106(ra) # 5854 <exit>
      exit(0);
    1cae:	4501                	li	a0,0
    1cb0:	00004097          	auipc	ra,0x4
    1cb4:	ba4080e7          	jalr	-1116(ra) # 5854 <exit>
      exit(1);
    1cb8:	4505                	li	a0,1
    1cba:	00004097          	auipc	ra,0x4
    1cbe:	b9a080e7          	jalr	-1126(ra) # 5854 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cc2:	f8040613          	addi	a2,s0,-128
    1cc6:	85e6                	mv	a1,s9
    1cc8:	00005517          	auipc	a0,0x5
    1ccc:	e8850513          	addi	a0,a0,-376 # 6b50 <malloc+0xebe>
    1cd0:	00004097          	auipc	ra,0x4
    1cd4:	f04080e7          	jalr	-252(ra) # 5bd4 <printf>
        exit(1);
    1cd8:	4505                	li	a0,1
    1cda:	00004097          	auipc	ra,0x4
    1cde:	b7a080e7          	jalr	-1158(ra) # 5854 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ce2:	054b7163          	bgeu	s6,s4,1d24 <createdelete+0x198>
      if(fd >= 0)
    1ce6:	02055a63          	bgez	a0,1d1a <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1cea:	2485                	addiw	s1,s1,1
    1cec:	0ff4f493          	andi	s1,s1,255
    1cf0:	05548c63          	beq	s1,s5,1d48 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cf4:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cf8:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1cfc:	4581                	li	a1,0
    1cfe:	f8040513          	addi	a0,s0,-128
    1d02:	00004097          	auipc	ra,0x4
    1d06:	b92080e7          	jalr	-1134(ra) # 5894 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d0a:	00090463          	beqz	s2,1d12 <createdelete+0x186>
    1d0e:	fd2bdae3          	bge	s7,s2,1ce2 <createdelete+0x156>
    1d12:	fa0548e3          	bltz	a0,1cc2 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d16:	014b7963          	bgeu	s6,s4,1d28 <createdelete+0x19c>
        close(fd);
    1d1a:	00004097          	auipc	ra,0x4
    1d1e:	b62080e7          	jalr	-1182(ra) # 587c <close>
    1d22:	b7e1                	j	1cea <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d24:	fc0543e3          	bltz	a0,1cea <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d28:	f8040613          	addi	a2,s0,-128
    1d2c:	85e6                	mv	a1,s9
    1d2e:	00005517          	auipc	a0,0x5
    1d32:	e4a50513          	addi	a0,a0,-438 # 6b78 <malloc+0xee6>
    1d36:	00004097          	auipc	ra,0x4
    1d3a:	e9e080e7          	jalr	-354(ra) # 5bd4 <printf>
        exit(1);
    1d3e:	4505                	li	a0,1
    1d40:	00004097          	auipc	ra,0x4
    1d44:	b14080e7          	jalr	-1260(ra) # 5854 <exit>
  for(i = 0; i < N; i++){
    1d48:	2905                	addiw	s2,s2,1
    1d4a:	2a05                	addiw	s4,s4,1
    1d4c:	2985                	addiw	s3,s3,1
    1d4e:	0ff9f993          	andi	s3,s3,255
    1d52:	47d1                	li	a5,20
    1d54:	02f90a63          	beq	s2,a5,1d88 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d58:	84e2                	mv	s1,s8
    1d5a:	bf69                	j	1cf4 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d5c:	2905                	addiw	s2,s2,1
    1d5e:	0ff97913          	andi	s2,s2,255
    1d62:	2985                	addiw	s3,s3,1
    1d64:	0ff9f993          	andi	s3,s3,255
    1d68:	03490863          	beq	s2,s4,1d98 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d6c:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d6e:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d72:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d76:	f8040513          	addi	a0,s0,-128
    1d7a:	00004097          	auipc	ra,0x4
    1d7e:	b2a080e7          	jalr	-1238(ra) # 58a4 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d82:	34fd                	addiw	s1,s1,-1
    1d84:	f4ed                	bnez	s1,1d6e <createdelete+0x1e2>
    1d86:	bfd9                	j	1d5c <createdelete+0x1d0>
    1d88:	03000993          	li	s3,48
    1d8c:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d90:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d92:	08400a13          	li	s4,132
    1d96:	bfd9                	j	1d6c <createdelete+0x1e0>
}
    1d98:	60aa                	ld	ra,136(sp)
    1d9a:	640a                	ld	s0,128(sp)
    1d9c:	74e6                	ld	s1,120(sp)
    1d9e:	7946                	ld	s2,112(sp)
    1da0:	79a6                	ld	s3,104(sp)
    1da2:	7a06                	ld	s4,96(sp)
    1da4:	6ae6                	ld	s5,88(sp)
    1da6:	6b46                	ld	s6,80(sp)
    1da8:	6ba6                	ld	s7,72(sp)
    1daa:	6c06                	ld	s8,64(sp)
    1dac:	7ce2                	ld	s9,56(sp)
    1dae:	6149                	addi	sp,sp,144
    1db0:	8082                	ret

0000000000001db2 <linkunlink>:
{
    1db2:	711d                	addi	sp,sp,-96
    1db4:	ec86                	sd	ra,88(sp)
    1db6:	e8a2                	sd	s0,80(sp)
    1db8:	e4a6                	sd	s1,72(sp)
    1dba:	e0ca                	sd	s2,64(sp)
    1dbc:	fc4e                	sd	s3,56(sp)
    1dbe:	f852                	sd	s4,48(sp)
    1dc0:	f456                	sd	s5,40(sp)
    1dc2:	f05a                	sd	s6,32(sp)
    1dc4:	ec5e                	sd	s7,24(sp)
    1dc6:	e862                	sd	s8,16(sp)
    1dc8:	e466                	sd	s9,8(sp)
    1dca:	1080                	addi	s0,sp,96
    1dcc:	84aa                	mv	s1,a0
  unlink("x");
    1dce:	00004517          	auipc	a0,0x4
    1dd2:	3b250513          	addi	a0,a0,946 # 6180 <malloc+0x4ee>
    1dd6:	00004097          	auipc	ra,0x4
    1dda:	ace080e7          	jalr	-1330(ra) # 58a4 <unlink>
  pid = fork();
    1dde:	00004097          	auipc	ra,0x4
    1de2:	a6e080e7          	jalr	-1426(ra) # 584c <fork>
  if(pid < 0){
    1de6:	02054b63          	bltz	a0,1e1c <linkunlink+0x6a>
    1dea:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1dec:	4c85                	li	s9,1
    1dee:	e119                	bnez	a0,1df4 <linkunlink+0x42>
    1df0:	06100c93          	li	s9,97
    1df4:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1df8:	41c659b7          	lui	s3,0x41c65
    1dfc:	e6d9899b          	addiw	s3,s3,-403
    1e00:	690d                	lui	s2,0x3
    1e02:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e06:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e08:	4b05                	li	s6,1
      unlink("x");
    1e0a:	00004a97          	auipc	s5,0x4
    1e0e:	376a8a93          	addi	s5,s5,886 # 6180 <malloc+0x4ee>
      link("cat", "x");
    1e12:	00005b97          	auipc	s7,0x5
    1e16:	d8eb8b93          	addi	s7,s7,-626 # 6ba0 <malloc+0xf0e>
    1e1a:	a091                	j	1e5e <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    1e1c:	85a6                	mv	a1,s1
    1e1e:	00005517          	auipc	a0,0x5
    1e22:	b2a50513          	addi	a0,a0,-1238 # 6948 <malloc+0xcb6>
    1e26:	00004097          	auipc	ra,0x4
    1e2a:	dae080e7          	jalr	-594(ra) # 5bd4 <printf>
    exit(1);
    1e2e:	4505                	li	a0,1
    1e30:	00004097          	auipc	ra,0x4
    1e34:	a24080e7          	jalr	-1500(ra) # 5854 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e38:	20200593          	li	a1,514
    1e3c:	8556                	mv	a0,s5
    1e3e:	00004097          	auipc	ra,0x4
    1e42:	a56080e7          	jalr	-1450(ra) # 5894 <open>
    1e46:	00004097          	auipc	ra,0x4
    1e4a:	a36080e7          	jalr	-1482(ra) # 587c <close>
    1e4e:	a031                	j	1e5a <linkunlink+0xa8>
      unlink("x");
    1e50:	8556                	mv	a0,s5
    1e52:	00004097          	auipc	ra,0x4
    1e56:	a52080e7          	jalr	-1454(ra) # 58a4 <unlink>
  for(i = 0; i < 100; i++){
    1e5a:	34fd                	addiw	s1,s1,-1
    1e5c:	c09d                	beqz	s1,1e82 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e5e:	033c87bb          	mulw	a5,s9,s3
    1e62:	012787bb          	addw	a5,a5,s2
    1e66:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e6a:	0347f7bb          	remuw	a5,a5,s4
    1e6e:	d7e9                	beqz	a5,1e38 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e70:	ff6790e3          	bne	a5,s6,1e50 <linkunlink+0x9e>
      link("cat", "x");
    1e74:	85d6                	mv	a1,s5
    1e76:	855e                	mv	a0,s7
    1e78:	00004097          	auipc	ra,0x4
    1e7c:	a3c080e7          	jalr	-1476(ra) # 58b4 <link>
    1e80:	bfe9                	j	1e5a <linkunlink+0xa8>
  if(pid)
    1e82:	020c0463          	beqz	s8,1eaa <linkunlink+0xf8>
    wait(0);
    1e86:	4501                	li	a0,0
    1e88:	00004097          	auipc	ra,0x4
    1e8c:	9d4080e7          	jalr	-1580(ra) # 585c <wait>
}
    1e90:	60e6                	ld	ra,88(sp)
    1e92:	6446                	ld	s0,80(sp)
    1e94:	64a6                	ld	s1,72(sp)
    1e96:	6906                	ld	s2,64(sp)
    1e98:	79e2                	ld	s3,56(sp)
    1e9a:	7a42                	ld	s4,48(sp)
    1e9c:	7aa2                	ld	s5,40(sp)
    1e9e:	7b02                	ld	s6,32(sp)
    1ea0:	6be2                	ld	s7,24(sp)
    1ea2:	6c42                	ld	s8,16(sp)
    1ea4:	6ca2                	ld	s9,8(sp)
    1ea6:	6125                	addi	sp,sp,96
    1ea8:	8082                	ret
    exit(0);
    1eaa:	4501                	li	a0,0
    1eac:	00004097          	auipc	ra,0x4
    1eb0:	9a8080e7          	jalr	-1624(ra) # 5854 <exit>

0000000000001eb4 <manywrites>:
{
    1eb4:	711d                	addi	sp,sp,-96
    1eb6:	ec86                	sd	ra,88(sp)
    1eb8:	e8a2                	sd	s0,80(sp)
    1eba:	e4a6                	sd	s1,72(sp)
    1ebc:	e0ca                	sd	s2,64(sp)
    1ebe:	fc4e                	sd	s3,56(sp)
    1ec0:	f852                	sd	s4,48(sp)
    1ec2:	f456                	sd	s5,40(sp)
    1ec4:	f05a                	sd	s6,32(sp)
    1ec6:	ec5e                	sd	s7,24(sp)
    1ec8:	1080                	addi	s0,sp,96
    1eca:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1ecc:	4901                	li	s2,0
    1ece:	4991                	li	s3,4
    int pid = fork();
    1ed0:	00004097          	auipc	ra,0x4
    1ed4:	97c080e7          	jalr	-1668(ra) # 584c <fork>
    1ed8:	84aa                	mv	s1,a0
    if(pid < 0){
    1eda:	02054963          	bltz	a0,1f0c <manywrites+0x58>
    if(pid == 0){
    1ede:	c521                	beqz	a0,1f26 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1ee0:	2905                	addiw	s2,s2,1
    1ee2:	ff3917e3          	bne	s2,s3,1ed0 <manywrites+0x1c>
    1ee6:	4491                	li	s1,4
    int st = 0;
    1ee8:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1eec:	fa840513          	addi	a0,s0,-88
    1ef0:	00004097          	auipc	ra,0x4
    1ef4:	96c080e7          	jalr	-1684(ra) # 585c <wait>
    if(st != 0)
    1ef8:	fa842503          	lw	a0,-88(s0)
    1efc:	ed6d                	bnez	a0,1ff6 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    1efe:	34fd                	addiw	s1,s1,-1
    1f00:	f4e5                	bnez	s1,1ee8 <manywrites+0x34>
  exit(0);
    1f02:	4501                	li	a0,0
    1f04:	00004097          	auipc	ra,0x4
    1f08:	950080e7          	jalr	-1712(ra) # 5854 <exit>
      printf("fork failed\n");
    1f0c:	00005517          	auipc	a0,0x5
    1f10:	e5c50513          	addi	a0,a0,-420 # 6d68 <malloc+0x10d6>
    1f14:	00004097          	auipc	ra,0x4
    1f18:	cc0080e7          	jalr	-832(ra) # 5bd4 <printf>
      exit(1);
    1f1c:	4505                	li	a0,1
    1f1e:	00004097          	auipc	ra,0x4
    1f22:	936080e7          	jalr	-1738(ra) # 5854 <exit>
      name[0] = 'b';
    1f26:	06200793          	li	a5,98
    1f2a:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f2e:	0619079b          	addiw	a5,s2,97
    1f32:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f36:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f3a:	fa840513          	addi	a0,s0,-88
    1f3e:	00004097          	auipc	ra,0x4
    1f42:	966080e7          	jalr	-1690(ra) # 58a4 <unlink>
    1f46:	4b79                	li	s6,30
          int cc = write(fd, buf, sz);
    1f48:	0000ab97          	auipc	s7,0xa
    1f4c:	e50b8b93          	addi	s7,s7,-432 # bd98 <buf>
        for(int i = 0; i < ci+1; i++){
    1f50:	8a26                	mv	s4,s1
    1f52:	02094e63          	bltz	s2,1f8e <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1f56:	20200593          	li	a1,514
    1f5a:	fa840513          	addi	a0,s0,-88
    1f5e:	00004097          	auipc	ra,0x4
    1f62:	936080e7          	jalr	-1738(ra) # 5894 <open>
    1f66:	89aa                	mv	s3,a0
          if(fd < 0){
    1f68:	04054763          	bltz	a0,1fb6 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1f6c:	660d                	lui	a2,0x3
    1f6e:	85de                	mv	a1,s7
    1f70:	00004097          	auipc	ra,0x4
    1f74:	904080e7          	jalr	-1788(ra) # 5874 <write>
          if(cc != sz){
    1f78:	678d                	lui	a5,0x3
    1f7a:	04f51e63          	bne	a0,a5,1fd6 <manywrites+0x122>
          close(fd);
    1f7e:	854e                	mv	a0,s3
    1f80:	00004097          	auipc	ra,0x4
    1f84:	8fc080e7          	jalr	-1796(ra) # 587c <close>
        for(int i = 0; i < ci+1; i++){
    1f88:	2a05                	addiw	s4,s4,1
    1f8a:	fd4956e3          	bge	s2,s4,1f56 <manywrites+0xa2>
        unlink(name);
    1f8e:	fa840513          	addi	a0,s0,-88
    1f92:	00004097          	auipc	ra,0x4
    1f96:	912080e7          	jalr	-1774(ra) # 58a4 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f9a:	3b7d                	addiw	s6,s6,-1
    1f9c:	fa0b1ae3          	bnez	s6,1f50 <manywrites+0x9c>
      unlink(name);
    1fa0:	fa840513          	addi	a0,s0,-88
    1fa4:	00004097          	auipc	ra,0x4
    1fa8:	900080e7          	jalr	-1792(ra) # 58a4 <unlink>
      exit(0);
    1fac:	4501                	li	a0,0
    1fae:	00004097          	auipc	ra,0x4
    1fb2:	8a6080e7          	jalr	-1882(ra) # 5854 <exit>
            printf("%s: cannot create %s\n", s, name);
    1fb6:	fa840613          	addi	a2,s0,-88
    1fba:	85d6                	mv	a1,s5
    1fbc:	00005517          	auipc	a0,0x5
    1fc0:	bec50513          	addi	a0,a0,-1044 # 6ba8 <malloc+0xf16>
    1fc4:	00004097          	auipc	ra,0x4
    1fc8:	c10080e7          	jalr	-1008(ra) # 5bd4 <printf>
            exit(1);
    1fcc:	4505                	li	a0,1
    1fce:	00004097          	auipc	ra,0x4
    1fd2:	886080e7          	jalr	-1914(ra) # 5854 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fd6:	86aa                	mv	a3,a0
    1fd8:	660d                	lui	a2,0x3
    1fda:	85d6                	mv	a1,s5
    1fdc:	00004517          	auipc	a0,0x4
    1fe0:	1f450513          	addi	a0,a0,500 # 61d0 <malloc+0x53e>
    1fe4:	00004097          	auipc	ra,0x4
    1fe8:	bf0080e7          	jalr	-1040(ra) # 5bd4 <printf>
            exit(1);
    1fec:	4505                	li	a0,1
    1fee:	00004097          	auipc	ra,0x4
    1ff2:	866080e7          	jalr	-1946(ra) # 5854 <exit>
      exit(st);
    1ff6:	00004097          	auipc	ra,0x4
    1ffa:	85e080e7          	jalr	-1954(ra) # 5854 <exit>

0000000000001ffe <forktest>:
{
    1ffe:	7179                	addi	sp,sp,-48
    2000:	f406                	sd	ra,40(sp)
    2002:	f022                	sd	s0,32(sp)
    2004:	ec26                	sd	s1,24(sp)
    2006:	e84a                	sd	s2,16(sp)
    2008:	e44e                	sd	s3,8(sp)
    200a:	1800                	addi	s0,sp,48
    200c:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    200e:	4481                	li	s1,0
    2010:	3e800913          	li	s2,1000
    pid = fork();
    2014:	00004097          	auipc	ra,0x4
    2018:	838080e7          	jalr	-1992(ra) # 584c <fork>
    if(pid < 0)
    201c:	02054863          	bltz	a0,204c <forktest+0x4e>
    if(pid == 0)
    2020:	c115                	beqz	a0,2044 <forktest+0x46>
  for(n=0; n<N; n++){
    2022:	2485                	addiw	s1,s1,1
    2024:	ff2498e3          	bne	s1,s2,2014 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2028:	85ce                	mv	a1,s3
    202a:	00005517          	auipc	a0,0x5
    202e:	bae50513          	addi	a0,a0,-1106 # 6bd8 <malloc+0xf46>
    2032:	00004097          	auipc	ra,0x4
    2036:	ba2080e7          	jalr	-1118(ra) # 5bd4 <printf>
    exit(1);
    203a:	4505                	li	a0,1
    203c:	00004097          	auipc	ra,0x4
    2040:	818080e7          	jalr	-2024(ra) # 5854 <exit>
      exit(0);
    2044:	00004097          	auipc	ra,0x4
    2048:	810080e7          	jalr	-2032(ra) # 5854 <exit>
  if (n == 0) {
    204c:	cc9d                	beqz	s1,208a <forktest+0x8c>
  if(n == N){
    204e:	3e800793          	li	a5,1000
    2052:	fcf48be3          	beq	s1,a5,2028 <forktest+0x2a>
  for(; n > 0; n--){
    2056:	00905b63          	blez	s1,206c <forktest+0x6e>
    if(wait(0) < 0){
    205a:	4501                	li	a0,0
    205c:	00004097          	auipc	ra,0x4
    2060:	800080e7          	jalr	-2048(ra) # 585c <wait>
    2064:	04054163          	bltz	a0,20a6 <forktest+0xa8>
  for(; n > 0; n--){
    2068:	34fd                	addiw	s1,s1,-1
    206a:	f8e5                	bnez	s1,205a <forktest+0x5c>
  if(wait(0) != -1){
    206c:	4501                	li	a0,0
    206e:	00003097          	auipc	ra,0x3
    2072:	7ee080e7          	jalr	2030(ra) # 585c <wait>
    2076:	57fd                	li	a5,-1
    2078:	04f51563          	bne	a0,a5,20c2 <forktest+0xc4>
}
    207c:	70a2                	ld	ra,40(sp)
    207e:	7402                	ld	s0,32(sp)
    2080:	64e2                	ld	s1,24(sp)
    2082:	6942                	ld	s2,16(sp)
    2084:	69a2                	ld	s3,8(sp)
    2086:	6145                	addi	sp,sp,48
    2088:	8082                	ret
    printf("%s: no fork at all!\n", s);
    208a:	85ce                	mv	a1,s3
    208c:	00005517          	auipc	a0,0x5
    2090:	b3450513          	addi	a0,a0,-1228 # 6bc0 <malloc+0xf2e>
    2094:	00004097          	auipc	ra,0x4
    2098:	b40080e7          	jalr	-1216(ra) # 5bd4 <printf>
    exit(1);
    209c:	4505                	li	a0,1
    209e:	00003097          	auipc	ra,0x3
    20a2:	7b6080e7          	jalr	1974(ra) # 5854 <exit>
      printf("%s: wait stopped early\n", s);
    20a6:	85ce                	mv	a1,s3
    20a8:	00005517          	auipc	a0,0x5
    20ac:	b5850513          	addi	a0,a0,-1192 # 6c00 <malloc+0xf6e>
    20b0:	00004097          	auipc	ra,0x4
    20b4:	b24080e7          	jalr	-1244(ra) # 5bd4 <printf>
      exit(1);
    20b8:	4505                	li	a0,1
    20ba:	00003097          	auipc	ra,0x3
    20be:	79a080e7          	jalr	1946(ra) # 5854 <exit>
    printf("%s: wait got too many\n", s);
    20c2:	85ce                	mv	a1,s3
    20c4:	00005517          	auipc	a0,0x5
    20c8:	b5450513          	addi	a0,a0,-1196 # 6c18 <malloc+0xf86>
    20cc:	00004097          	auipc	ra,0x4
    20d0:	b08080e7          	jalr	-1272(ra) # 5bd4 <printf>
    exit(1);
    20d4:	4505                	li	a0,1
    20d6:	00003097          	auipc	ra,0x3
    20da:	77e080e7          	jalr	1918(ra) # 5854 <exit>

00000000000020de <kernmem>:
{
    20de:	715d                	addi	sp,sp,-80
    20e0:	e486                	sd	ra,72(sp)
    20e2:	e0a2                	sd	s0,64(sp)
    20e4:	fc26                	sd	s1,56(sp)
    20e6:	f84a                	sd	s2,48(sp)
    20e8:	f44e                	sd	s3,40(sp)
    20ea:	f052                	sd	s4,32(sp)
    20ec:	ec56                	sd	s5,24(sp)
    20ee:	0880                	addi	s0,sp,80
    20f0:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f2:	4485                	li	s1,1
    20f4:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    20f6:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f8:	69b1                	lui	s3,0xc
    20fa:	35098993          	addi	s3,s3,848 # c350 <buf+0x5b8>
    20fe:	1003d937          	lui	s2,0x1003d
    2102:	090e                	slli	s2,s2,0x3
    2104:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e6d8>
    pid = fork();
    2108:	00003097          	auipc	ra,0x3
    210c:	744080e7          	jalr	1860(ra) # 584c <fork>
    if(pid < 0){
    2110:	02054963          	bltz	a0,2142 <kernmem+0x64>
    if(pid == 0){
    2114:	c529                	beqz	a0,215e <kernmem+0x80>
    wait(&xstatus);
    2116:	fbc40513          	addi	a0,s0,-68
    211a:	00003097          	auipc	ra,0x3
    211e:	742080e7          	jalr	1858(ra) # 585c <wait>
    if(xstatus != -1)  // did kernel kill child?
    2122:	fbc42783          	lw	a5,-68(s0)
    2126:	05579d63          	bne	a5,s5,2180 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    212a:	94ce                	add	s1,s1,s3
    212c:	fd249ee3          	bne	s1,s2,2108 <kernmem+0x2a>
}
    2130:	60a6                	ld	ra,72(sp)
    2132:	6406                	ld	s0,64(sp)
    2134:	74e2                	ld	s1,56(sp)
    2136:	7942                	ld	s2,48(sp)
    2138:	79a2                	ld	s3,40(sp)
    213a:	7a02                	ld	s4,32(sp)
    213c:	6ae2                	ld	s5,24(sp)
    213e:	6161                	addi	sp,sp,80
    2140:	8082                	ret
      printf("%s: fork failed\n", s);
    2142:	85d2                	mv	a1,s4
    2144:	00005517          	auipc	a0,0x5
    2148:	80450513          	addi	a0,a0,-2044 # 6948 <malloc+0xcb6>
    214c:	00004097          	auipc	ra,0x4
    2150:	a88080e7          	jalr	-1400(ra) # 5bd4 <printf>
      exit(1);
    2154:	4505                	li	a0,1
    2156:	00003097          	auipc	ra,0x3
    215a:	6fe080e7          	jalr	1790(ra) # 5854 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    215e:	0004c683          	lbu	a3,0(s1)
    2162:	8626                	mv	a2,s1
    2164:	85d2                	mv	a1,s4
    2166:	00005517          	auipc	a0,0x5
    216a:	aca50513          	addi	a0,a0,-1334 # 6c30 <malloc+0xf9e>
    216e:	00004097          	auipc	ra,0x4
    2172:	a66080e7          	jalr	-1434(ra) # 5bd4 <printf>
      exit(1);
    2176:	4505                	li	a0,1
    2178:	00003097          	auipc	ra,0x3
    217c:	6dc080e7          	jalr	1756(ra) # 5854 <exit>
      exit(1);
    2180:	4505                	li	a0,1
    2182:	00003097          	auipc	ra,0x3
    2186:	6d2080e7          	jalr	1746(ra) # 5854 <exit>

000000000000218a <MAXVAplus>:
{
    218a:	7179                	addi	sp,sp,-48
    218c:	f406                	sd	ra,40(sp)
    218e:	f022                	sd	s0,32(sp)
    2190:	ec26                	sd	s1,24(sp)
    2192:	e84a                	sd	s2,16(sp)
    2194:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    2196:	4785                	li	a5,1
    2198:	179a                	slli	a5,a5,0x26
    219a:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    219e:	fd843783          	ld	a5,-40(s0)
    21a2:	cf85                	beqz	a5,21da <MAXVAplus+0x50>
    21a4:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    21a6:	54fd                	li	s1,-1
    pid = fork();
    21a8:	00003097          	auipc	ra,0x3
    21ac:	6a4080e7          	jalr	1700(ra) # 584c <fork>
    if(pid < 0){
    21b0:	02054b63          	bltz	a0,21e6 <MAXVAplus+0x5c>
    if(pid == 0){
    21b4:	c539                	beqz	a0,2202 <MAXVAplus+0x78>
    wait(&xstatus);
    21b6:	fd440513          	addi	a0,s0,-44
    21ba:	00003097          	auipc	ra,0x3
    21be:	6a2080e7          	jalr	1698(ra) # 585c <wait>
    if(xstatus != -1)  // did kernel kill child?
    21c2:	fd442783          	lw	a5,-44(s0)
    21c6:	06979463          	bne	a5,s1,222e <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    21ca:	fd843783          	ld	a5,-40(s0)
    21ce:	0786                	slli	a5,a5,0x1
    21d0:	fcf43c23          	sd	a5,-40(s0)
    21d4:	fd843783          	ld	a5,-40(s0)
    21d8:	fbe1                	bnez	a5,21a8 <MAXVAplus+0x1e>
}
    21da:	70a2                	ld	ra,40(sp)
    21dc:	7402                	ld	s0,32(sp)
    21de:	64e2                	ld	s1,24(sp)
    21e0:	6942                	ld	s2,16(sp)
    21e2:	6145                	addi	sp,sp,48
    21e4:	8082                	ret
      printf("%s: fork failed\n", s);
    21e6:	85ca                	mv	a1,s2
    21e8:	00004517          	auipc	a0,0x4
    21ec:	76050513          	addi	a0,a0,1888 # 6948 <malloc+0xcb6>
    21f0:	00004097          	auipc	ra,0x4
    21f4:	9e4080e7          	jalr	-1564(ra) # 5bd4 <printf>
      exit(1);
    21f8:	4505                	li	a0,1
    21fa:	00003097          	auipc	ra,0x3
    21fe:	65a080e7          	jalr	1626(ra) # 5854 <exit>
      *(char*)a = 99;
    2202:	fd843783          	ld	a5,-40(s0)
    2206:	06300713          	li	a4,99
    220a:	00e78023          	sb	a4,0(a5) # 3000 <iputtest+0x82>
      printf("%s: oops wrote %x\n", s, a);
    220e:	fd843603          	ld	a2,-40(s0)
    2212:	85ca                	mv	a1,s2
    2214:	00005517          	auipc	a0,0x5
    2218:	a3c50513          	addi	a0,a0,-1476 # 6c50 <malloc+0xfbe>
    221c:	00004097          	auipc	ra,0x4
    2220:	9b8080e7          	jalr	-1608(ra) # 5bd4 <printf>
      exit(1);
    2224:	4505                	li	a0,1
    2226:	00003097          	auipc	ra,0x3
    222a:	62e080e7          	jalr	1582(ra) # 5854 <exit>
      exit(1);
    222e:	4505                	li	a0,1
    2230:	00003097          	auipc	ra,0x3
    2234:	624080e7          	jalr	1572(ra) # 5854 <exit>

0000000000002238 <bigargtest>:
{
    2238:	7179                	addi	sp,sp,-48
    223a:	f406                	sd	ra,40(sp)
    223c:	f022                	sd	s0,32(sp)
    223e:	ec26                	sd	s1,24(sp)
    2240:	1800                	addi	s0,sp,48
    2242:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2244:	00005517          	auipc	a0,0x5
    2248:	a2450513          	addi	a0,a0,-1500 # 6c68 <malloc+0xfd6>
    224c:	00003097          	auipc	ra,0x3
    2250:	658080e7          	jalr	1624(ra) # 58a4 <unlink>
  pid = fork();
    2254:	00003097          	auipc	ra,0x3
    2258:	5f8080e7          	jalr	1528(ra) # 584c <fork>
  if(pid == 0){
    225c:	c121                	beqz	a0,229c <bigargtest+0x64>
  } else if(pid < 0){
    225e:	0a054063          	bltz	a0,22fe <bigargtest+0xc6>
  wait(&xstatus);
    2262:	fdc40513          	addi	a0,s0,-36
    2266:	00003097          	auipc	ra,0x3
    226a:	5f6080e7          	jalr	1526(ra) # 585c <wait>
  if(xstatus != 0)
    226e:	fdc42503          	lw	a0,-36(s0)
    2272:	e545                	bnez	a0,231a <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2274:	4581                	li	a1,0
    2276:	00005517          	auipc	a0,0x5
    227a:	9f250513          	addi	a0,a0,-1550 # 6c68 <malloc+0xfd6>
    227e:	00003097          	auipc	ra,0x3
    2282:	616080e7          	jalr	1558(ra) # 5894 <open>
  if(fd < 0){
    2286:	08054e63          	bltz	a0,2322 <bigargtest+0xea>
  close(fd);
    228a:	00003097          	auipc	ra,0x3
    228e:	5f2080e7          	jalr	1522(ra) # 587c <close>
}
    2292:	70a2                	ld	ra,40(sp)
    2294:	7402                	ld	s0,32(sp)
    2296:	64e2                	ld	s1,24(sp)
    2298:	6145                	addi	sp,sp,48
    229a:	8082                	ret
    229c:	00006797          	auipc	a5,0x6
    22a0:	2e478793          	addi	a5,a5,740 # 8580 <args.1862>
    22a4:	00006697          	auipc	a3,0x6
    22a8:	3d468693          	addi	a3,a3,980 # 8678 <args.1862+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    22ac:	00005717          	auipc	a4,0x5
    22b0:	9cc70713          	addi	a4,a4,-1588 # 6c78 <malloc+0xfe6>
    22b4:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    22b6:	07a1                	addi	a5,a5,8
    22b8:	fed79ee3          	bne	a5,a3,22b4 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    22bc:	00006597          	auipc	a1,0x6
    22c0:	2c458593          	addi	a1,a1,708 # 8580 <args.1862>
    22c4:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    22c8:	00004517          	auipc	a0,0x4
    22cc:	e4850513          	addi	a0,a0,-440 # 6110 <malloc+0x47e>
    22d0:	00003097          	auipc	ra,0x3
    22d4:	5bc080e7          	jalr	1468(ra) # 588c <exec>
    fd = open("bigarg-ok", O_CREATE);
    22d8:	20000593          	li	a1,512
    22dc:	00005517          	auipc	a0,0x5
    22e0:	98c50513          	addi	a0,a0,-1652 # 6c68 <malloc+0xfd6>
    22e4:	00003097          	auipc	ra,0x3
    22e8:	5b0080e7          	jalr	1456(ra) # 5894 <open>
    close(fd);
    22ec:	00003097          	auipc	ra,0x3
    22f0:	590080e7          	jalr	1424(ra) # 587c <close>
    exit(0);
    22f4:	4501                	li	a0,0
    22f6:	00003097          	auipc	ra,0x3
    22fa:	55e080e7          	jalr	1374(ra) # 5854 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    22fe:	85a6                	mv	a1,s1
    2300:	00005517          	auipc	a0,0x5
    2304:	a5850513          	addi	a0,a0,-1448 # 6d58 <malloc+0x10c6>
    2308:	00004097          	auipc	ra,0x4
    230c:	8cc080e7          	jalr	-1844(ra) # 5bd4 <printf>
    exit(1);
    2310:	4505                	li	a0,1
    2312:	00003097          	auipc	ra,0x3
    2316:	542080e7          	jalr	1346(ra) # 5854 <exit>
    exit(xstatus);
    231a:	00003097          	auipc	ra,0x3
    231e:	53a080e7          	jalr	1338(ra) # 5854 <exit>
    printf("%s: bigarg test failed!\n", s);
    2322:	85a6                	mv	a1,s1
    2324:	00005517          	auipc	a0,0x5
    2328:	a5450513          	addi	a0,a0,-1452 # 6d78 <malloc+0x10e6>
    232c:	00004097          	auipc	ra,0x4
    2330:	8a8080e7          	jalr	-1880(ra) # 5bd4 <printf>
    exit(1);
    2334:	4505                	li	a0,1
    2336:	00003097          	auipc	ra,0x3
    233a:	51e080e7          	jalr	1310(ra) # 5854 <exit>

000000000000233e <stacktest>:
{
    233e:	7179                	addi	sp,sp,-48
    2340:	f406                	sd	ra,40(sp)
    2342:	f022                	sd	s0,32(sp)
    2344:	ec26                	sd	s1,24(sp)
    2346:	1800                	addi	s0,sp,48
    2348:	84aa                	mv	s1,a0
  pid = fork();
    234a:	00003097          	auipc	ra,0x3
    234e:	502080e7          	jalr	1282(ra) # 584c <fork>
  if(pid == 0) {
    2352:	c115                	beqz	a0,2376 <stacktest+0x38>
  } else if(pid < 0){
    2354:	04054463          	bltz	a0,239c <stacktest+0x5e>
  wait(&xstatus);
    2358:	fdc40513          	addi	a0,s0,-36
    235c:	00003097          	auipc	ra,0x3
    2360:	500080e7          	jalr	1280(ra) # 585c <wait>
  if(xstatus == -1)  // kernel killed child?
    2364:	fdc42503          	lw	a0,-36(s0)
    2368:	57fd                	li	a5,-1
    236a:	04f50763          	beq	a0,a5,23b8 <stacktest+0x7a>
    exit(xstatus);
    236e:	00003097          	auipc	ra,0x3
    2372:	4e6080e7          	jalr	1254(ra) # 5854 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2376:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2378:	77fd                	lui	a5,0xfffff
    237a:	97ba                	add	a5,a5,a4
    237c:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0258>
    2380:	85a6                	mv	a1,s1
    2382:	00005517          	auipc	a0,0x5
    2386:	a1650513          	addi	a0,a0,-1514 # 6d98 <malloc+0x1106>
    238a:	00004097          	auipc	ra,0x4
    238e:	84a080e7          	jalr	-1974(ra) # 5bd4 <printf>
    exit(1);
    2392:	4505                	li	a0,1
    2394:	00003097          	auipc	ra,0x3
    2398:	4c0080e7          	jalr	1216(ra) # 5854 <exit>
    printf("%s: fork failed\n", s);
    239c:	85a6                	mv	a1,s1
    239e:	00004517          	auipc	a0,0x4
    23a2:	5aa50513          	addi	a0,a0,1450 # 6948 <malloc+0xcb6>
    23a6:	00004097          	auipc	ra,0x4
    23aa:	82e080e7          	jalr	-2002(ra) # 5bd4 <printf>
    exit(1);
    23ae:	4505                	li	a0,1
    23b0:	00003097          	auipc	ra,0x3
    23b4:	4a4080e7          	jalr	1188(ra) # 5854 <exit>
    exit(0);
    23b8:	4501                	li	a0,0
    23ba:	00003097          	auipc	ra,0x3
    23be:	49a080e7          	jalr	1178(ra) # 5854 <exit>

00000000000023c2 <copyinstr3>:
{
    23c2:	7179                	addi	sp,sp,-48
    23c4:	f406                	sd	ra,40(sp)
    23c6:	f022                	sd	s0,32(sp)
    23c8:	ec26                	sd	s1,24(sp)
    23ca:	1800                	addi	s0,sp,48
  sbrk(8192);
    23cc:	6509                	lui	a0,0x2
    23ce:	00003097          	auipc	ra,0x3
    23d2:	50e080e7          	jalr	1294(ra) # 58dc <sbrk>
  uint64 top = (uint64) sbrk(0);
    23d6:	4501                	li	a0,0
    23d8:	00003097          	auipc	ra,0x3
    23dc:	504080e7          	jalr	1284(ra) # 58dc <sbrk>
  if((top % PGSIZE) != 0){
    23e0:	03451793          	slli	a5,a0,0x34
    23e4:	e3c9                	bnez	a5,2466 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    23e6:	4501                	li	a0,0
    23e8:	00003097          	auipc	ra,0x3
    23ec:	4f4080e7          	jalr	1268(ra) # 58dc <sbrk>
  if(top % PGSIZE){
    23f0:	03451793          	slli	a5,a0,0x34
    23f4:	e3d9                	bnez	a5,247a <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    23f6:	fff50493          	addi	s1,a0,-1 # 1fff <forktest+0x1>
  *b = 'x';
    23fa:	07800793          	li	a5,120
    23fe:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2402:	8526                	mv	a0,s1
    2404:	00003097          	auipc	ra,0x3
    2408:	4a0080e7          	jalr	1184(ra) # 58a4 <unlink>
  if(ret != -1){
    240c:	57fd                	li	a5,-1
    240e:	08f51363          	bne	a0,a5,2494 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2412:	20100593          	li	a1,513
    2416:	8526                	mv	a0,s1
    2418:	00003097          	auipc	ra,0x3
    241c:	47c080e7          	jalr	1148(ra) # 5894 <open>
  if(fd != -1){
    2420:	57fd                	li	a5,-1
    2422:	08f51863          	bne	a0,a5,24b2 <copyinstr3+0xf0>
  ret = link(b, b);
    2426:	85a6                	mv	a1,s1
    2428:	8526                	mv	a0,s1
    242a:	00003097          	auipc	ra,0x3
    242e:	48a080e7          	jalr	1162(ra) # 58b4 <link>
  if(ret != -1){
    2432:	57fd                	li	a5,-1
    2434:	08f51e63          	bne	a0,a5,24d0 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2438:	00005797          	auipc	a5,0x5
    243c:	5f878793          	addi	a5,a5,1528 # 7a30 <malloc+0x1d9e>
    2440:	fcf43823          	sd	a5,-48(s0)
    2444:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2448:	fd040593          	addi	a1,s0,-48
    244c:	8526                	mv	a0,s1
    244e:	00003097          	auipc	ra,0x3
    2452:	43e080e7          	jalr	1086(ra) # 588c <exec>
  if(ret != -1){
    2456:	57fd                	li	a5,-1
    2458:	08f51c63          	bne	a0,a5,24f0 <copyinstr3+0x12e>
}
    245c:	70a2                	ld	ra,40(sp)
    245e:	7402                	ld	s0,32(sp)
    2460:	64e2                	ld	s1,24(sp)
    2462:	6145                	addi	sp,sp,48
    2464:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2466:	0347d513          	srli	a0,a5,0x34
    246a:	6785                	lui	a5,0x1
    246c:	40a7853b          	subw	a0,a5,a0
    2470:	00003097          	auipc	ra,0x3
    2474:	46c080e7          	jalr	1132(ra) # 58dc <sbrk>
    2478:	b7bd                	j	23e6 <copyinstr3+0x24>
    printf("oops\n");
    247a:	00005517          	auipc	a0,0x5
    247e:	94650513          	addi	a0,a0,-1722 # 6dc0 <malloc+0x112e>
    2482:	00003097          	auipc	ra,0x3
    2486:	752080e7          	jalr	1874(ra) # 5bd4 <printf>
    exit(1);
    248a:	4505                	li	a0,1
    248c:	00003097          	auipc	ra,0x3
    2490:	3c8080e7          	jalr	968(ra) # 5854 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2494:	862a                	mv	a2,a0
    2496:	85a6                	mv	a1,s1
    2498:	00004517          	auipc	a0,0x4
    249c:	3d050513          	addi	a0,a0,976 # 6868 <malloc+0xbd6>
    24a0:	00003097          	auipc	ra,0x3
    24a4:	734080e7          	jalr	1844(ra) # 5bd4 <printf>
    exit(1);
    24a8:	4505                	li	a0,1
    24aa:	00003097          	auipc	ra,0x3
    24ae:	3aa080e7          	jalr	938(ra) # 5854 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    24b2:	862a                	mv	a2,a0
    24b4:	85a6                	mv	a1,s1
    24b6:	00004517          	auipc	a0,0x4
    24ba:	3d250513          	addi	a0,a0,978 # 6888 <malloc+0xbf6>
    24be:	00003097          	auipc	ra,0x3
    24c2:	716080e7          	jalr	1814(ra) # 5bd4 <printf>
    exit(1);
    24c6:	4505                	li	a0,1
    24c8:	00003097          	auipc	ra,0x3
    24cc:	38c080e7          	jalr	908(ra) # 5854 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    24d0:	86aa                	mv	a3,a0
    24d2:	8626                	mv	a2,s1
    24d4:	85a6                	mv	a1,s1
    24d6:	00004517          	auipc	a0,0x4
    24da:	3d250513          	addi	a0,a0,978 # 68a8 <malloc+0xc16>
    24de:	00003097          	auipc	ra,0x3
    24e2:	6f6080e7          	jalr	1782(ra) # 5bd4 <printf>
    exit(1);
    24e6:	4505                	li	a0,1
    24e8:	00003097          	auipc	ra,0x3
    24ec:	36c080e7          	jalr	876(ra) # 5854 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    24f0:	567d                	li	a2,-1
    24f2:	85a6                	mv	a1,s1
    24f4:	00004517          	auipc	a0,0x4
    24f8:	3dc50513          	addi	a0,a0,988 # 68d0 <malloc+0xc3e>
    24fc:	00003097          	auipc	ra,0x3
    2500:	6d8080e7          	jalr	1752(ra) # 5bd4 <printf>
    exit(1);
    2504:	4505                	li	a0,1
    2506:	00003097          	auipc	ra,0x3
    250a:	34e080e7          	jalr	846(ra) # 5854 <exit>

000000000000250e <rwsbrk>:
{
    250e:	1101                	addi	sp,sp,-32
    2510:	ec06                	sd	ra,24(sp)
    2512:	e822                	sd	s0,16(sp)
    2514:	e426                	sd	s1,8(sp)
    2516:	e04a                	sd	s2,0(sp)
    2518:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    251a:	6509                	lui	a0,0x2
    251c:	00003097          	auipc	ra,0x3
    2520:	3c0080e7          	jalr	960(ra) # 58dc <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2524:	57fd                	li	a5,-1
    2526:	06f50363          	beq	a0,a5,258c <rwsbrk+0x7e>
    252a:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    252c:	7579                	lui	a0,0xffffe
    252e:	00003097          	auipc	ra,0x3
    2532:	3ae080e7          	jalr	942(ra) # 58dc <sbrk>
    2536:	57fd                	li	a5,-1
    2538:	06f50763          	beq	a0,a5,25a6 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    253c:	20100593          	li	a1,513
    2540:	00004517          	auipc	a0,0x4
    2544:	8c050513          	addi	a0,a0,-1856 # 5e00 <malloc+0x16e>
    2548:	00003097          	auipc	ra,0x3
    254c:	34c080e7          	jalr	844(ra) # 5894 <open>
    2550:	892a                	mv	s2,a0
  if(fd < 0){
    2552:	06054763          	bltz	a0,25c0 <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    2556:	6505                	lui	a0,0x1
    2558:	94aa                	add	s1,s1,a0
    255a:	40000613          	li	a2,1024
    255e:	85a6                	mv	a1,s1
    2560:	854a                	mv	a0,s2
    2562:	00003097          	auipc	ra,0x3
    2566:	312080e7          	jalr	786(ra) # 5874 <write>
    256a:	862a                	mv	a2,a0
  if(n >= 0){
    256c:	06054763          	bltz	a0,25da <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    2570:	85a6                	mv	a1,s1
    2572:	00005517          	auipc	a0,0x5
    2576:	8a650513          	addi	a0,a0,-1882 # 6e18 <malloc+0x1186>
    257a:	00003097          	auipc	ra,0x3
    257e:	65a080e7          	jalr	1626(ra) # 5bd4 <printf>
    exit(1);
    2582:	4505                	li	a0,1
    2584:	00003097          	auipc	ra,0x3
    2588:	2d0080e7          	jalr	720(ra) # 5854 <exit>
    printf("sbrk(rwsbrk) failed\n");
    258c:	00005517          	auipc	a0,0x5
    2590:	83c50513          	addi	a0,a0,-1988 # 6dc8 <malloc+0x1136>
    2594:	00003097          	auipc	ra,0x3
    2598:	640080e7          	jalr	1600(ra) # 5bd4 <printf>
    exit(1);
    259c:	4505                	li	a0,1
    259e:	00003097          	auipc	ra,0x3
    25a2:	2b6080e7          	jalr	694(ra) # 5854 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    25a6:	00005517          	auipc	a0,0x5
    25aa:	83a50513          	addi	a0,a0,-1990 # 6de0 <malloc+0x114e>
    25ae:	00003097          	auipc	ra,0x3
    25b2:	626080e7          	jalr	1574(ra) # 5bd4 <printf>
    exit(1);
    25b6:	4505                	li	a0,1
    25b8:	00003097          	auipc	ra,0x3
    25bc:	29c080e7          	jalr	668(ra) # 5854 <exit>
    printf("open(rwsbrk) failed\n");
    25c0:	00005517          	auipc	a0,0x5
    25c4:	84050513          	addi	a0,a0,-1984 # 6e00 <malloc+0x116e>
    25c8:	00003097          	auipc	ra,0x3
    25cc:	60c080e7          	jalr	1548(ra) # 5bd4 <printf>
    exit(1);
    25d0:	4505                	li	a0,1
    25d2:	00003097          	auipc	ra,0x3
    25d6:	282080e7          	jalr	642(ra) # 5854 <exit>
  close(fd);
    25da:	854a                	mv	a0,s2
    25dc:	00003097          	auipc	ra,0x3
    25e0:	2a0080e7          	jalr	672(ra) # 587c <close>
  unlink("rwsbrk");
    25e4:	00004517          	auipc	a0,0x4
    25e8:	81c50513          	addi	a0,a0,-2020 # 5e00 <malloc+0x16e>
    25ec:	00003097          	auipc	ra,0x3
    25f0:	2b8080e7          	jalr	696(ra) # 58a4 <unlink>
  fd = open("README", O_RDONLY);
    25f4:	4581                	li	a1,0
    25f6:	00004517          	auipc	a0,0x4
    25fa:	cb250513          	addi	a0,a0,-846 # 62a8 <malloc+0x616>
    25fe:	00003097          	auipc	ra,0x3
    2602:	296080e7          	jalr	662(ra) # 5894 <open>
    2606:	892a                	mv	s2,a0
  if(fd < 0){
    2608:	02054963          	bltz	a0,263a <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    260c:	4629                	li	a2,10
    260e:	85a6                	mv	a1,s1
    2610:	00003097          	auipc	ra,0x3
    2614:	25c080e7          	jalr	604(ra) # 586c <read>
    2618:	862a                	mv	a2,a0
  if(n >= 0){
    261a:	02054d63          	bltz	a0,2654 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    261e:	85a6                	mv	a1,s1
    2620:	00005517          	auipc	a0,0x5
    2624:	82850513          	addi	a0,a0,-2008 # 6e48 <malloc+0x11b6>
    2628:	00003097          	auipc	ra,0x3
    262c:	5ac080e7          	jalr	1452(ra) # 5bd4 <printf>
    exit(1);
    2630:	4505                	li	a0,1
    2632:	00003097          	auipc	ra,0x3
    2636:	222080e7          	jalr	546(ra) # 5854 <exit>
    printf("open(rwsbrk) failed\n");
    263a:	00004517          	auipc	a0,0x4
    263e:	7c650513          	addi	a0,a0,1990 # 6e00 <malloc+0x116e>
    2642:	00003097          	auipc	ra,0x3
    2646:	592080e7          	jalr	1426(ra) # 5bd4 <printf>
    exit(1);
    264a:	4505                	li	a0,1
    264c:	00003097          	auipc	ra,0x3
    2650:	208080e7          	jalr	520(ra) # 5854 <exit>
  close(fd);
    2654:	854a                	mv	a0,s2
    2656:	00003097          	auipc	ra,0x3
    265a:	226080e7          	jalr	550(ra) # 587c <close>
  exit(0);
    265e:	4501                	li	a0,0
    2660:	00003097          	auipc	ra,0x3
    2664:	1f4080e7          	jalr	500(ra) # 5854 <exit>

0000000000002668 <sbrkbasic>:
{
    2668:	715d                	addi	sp,sp,-80
    266a:	e486                	sd	ra,72(sp)
    266c:	e0a2                	sd	s0,64(sp)
    266e:	fc26                	sd	s1,56(sp)
    2670:	f84a                	sd	s2,48(sp)
    2672:	f44e                	sd	s3,40(sp)
    2674:	f052                	sd	s4,32(sp)
    2676:	ec56                	sd	s5,24(sp)
    2678:	0880                	addi	s0,sp,80
    267a:	8a2a                	mv	s4,a0
  pid = fork();
    267c:	00003097          	auipc	ra,0x3
    2680:	1d0080e7          	jalr	464(ra) # 584c <fork>
  if(pid < 0){
    2684:	02054c63          	bltz	a0,26bc <sbrkbasic+0x54>
  if(pid == 0){
    2688:	ed21                	bnez	a0,26e0 <sbrkbasic+0x78>
    a = sbrk(TOOMUCH);
    268a:	40000537          	lui	a0,0x40000
    268e:	00003097          	auipc	ra,0x3
    2692:	24e080e7          	jalr	590(ra) # 58dc <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2696:	57fd                	li	a5,-1
    2698:	02f50f63          	beq	a0,a5,26d6 <sbrkbasic+0x6e>
    for(b = a; b < a+TOOMUCH; b += 4096){
    269c:	400007b7          	lui	a5,0x40000
    26a0:	97aa                	add	a5,a5,a0
      *b = 99;
    26a2:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    26a6:	6705                	lui	a4,0x1
      *b = 99;
    26a8:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1258>
    for(b = a; b < a+TOOMUCH; b += 4096){
    26ac:	953a                	add	a0,a0,a4
    26ae:	fef51de3          	bne	a0,a5,26a8 <sbrkbasic+0x40>
    exit(1);
    26b2:	4505                	li	a0,1
    26b4:	00003097          	auipc	ra,0x3
    26b8:	1a0080e7          	jalr	416(ra) # 5854 <exit>
    printf("fork failed in sbrkbasic\n");
    26bc:	00004517          	auipc	a0,0x4
    26c0:	7b450513          	addi	a0,a0,1972 # 6e70 <malloc+0x11de>
    26c4:	00003097          	auipc	ra,0x3
    26c8:	510080e7          	jalr	1296(ra) # 5bd4 <printf>
    exit(1);
    26cc:	4505                	li	a0,1
    26ce:	00003097          	auipc	ra,0x3
    26d2:	186080e7          	jalr	390(ra) # 5854 <exit>
      exit(0);
    26d6:	4501                	li	a0,0
    26d8:	00003097          	auipc	ra,0x3
    26dc:	17c080e7          	jalr	380(ra) # 5854 <exit>
  wait(&xstatus);
    26e0:	fbc40513          	addi	a0,s0,-68
    26e4:	00003097          	auipc	ra,0x3
    26e8:	178080e7          	jalr	376(ra) # 585c <wait>
  if(xstatus == 1){
    26ec:	fbc42703          	lw	a4,-68(s0)
    26f0:	4785                	li	a5,1
    26f2:	00f70e63          	beq	a4,a5,270e <sbrkbasic+0xa6>
  a = sbrk(0);
    26f6:	4501                	li	a0,0
    26f8:	00003097          	auipc	ra,0x3
    26fc:	1e4080e7          	jalr	484(ra) # 58dc <sbrk>
    2700:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2702:	4901                	li	s2,0
    *b = 1;
    2704:	4a85                	li	s5,1
  for(i = 0; i < 5000; i++){
    2706:	6985                	lui	s3,0x1
    2708:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1d4>
    270c:	a005                	j	272c <sbrkbasic+0xc4>
    printf("%s: too much memory allocated!\n", s);
    270e:	85d2                	mv	a1,s4
    2710:	00004517          	auipc	a0,0x4
    2714:	78050513          	addi	a0,a0,1920 # 6e90 <malloc+0x11fe>
    2718:	00003097          	auipc	ra,0x3
    271c:	4bc080e7          	jalr	1212(ra) # 5bd4 <printf>
    exit(1);
    2720:	4505                	li	a0,1
    2722:	00003097          	auipc	ra,0x3
    2726:	132080e7          	jalr	306(ra) # 5854 <exit>
    a = b + 1;
    272a:	84be                	mv	s1,a5
    b = sbrk(1);
    272c:	4505                	li	a0,1
    272e:	00003097          	auipc	ra,0x3
    2732:	1ae080e7          	jalr	430(ra) # 58dc <sbrk>
    if(b != a){
    2736:	04951b63          	bne	a0,s1,278c <sbrkbasic+0x124>
    *b = 1;
    273a:	01548023          	sb	s5,0(s1)
    a = b + 1;
    273e:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2742:	2905                	addiw	s2,s2,1
    2744:	ff3913e3          	bne	s2,s3,272a <sbrkbasic+0xc2>
  pid = fork();
    2748:	00003097          	auipc	ra,0x3
    274c:	104080e7          	jalr	260(ra) # 584c <fork>
    2750:	892a                	mv	s2,a0
  if(pid < 0){
    2752:	04054e63          	bltz	a0,27ae <sbrkbasic+0x146>
  c = sbrk(1);
    2756:	4505                	li	a0,1
    2758:	00003097          	auipc	ra,0x3
    275c:	184080e7          	jalr	388(ra) # 58dc <sbrk>
  c = sbrk(1);
    2760:	4505                	li	a0,1
    2762:	00003097          	auipc	ra,0x3
    2766:	17a080e7          	jalr	378(ra) # 58dc <sbrk>
  if(c != a + 1){
    276a:	0489                	addi	s1,s1,2
    276c:	04a48f63          	beq	s1,a0,27ca <sbrkbasic+0x162>
    printf("%s: sbrk test failed post-fork\n", s);
    2770:	85d2                	mv	a1,s4
    2772:	00004517          	auipc	a0,0x4
    2776:	77e50513          	addi	a0,a0,1918 # 6ef0 <malloc+0x125e>
    277a:	00003097          	auipc	ra,0x3
    277e:	45a080e7          	jalr	1114(ra) # 5bd4 <printf>
    exit(1);
    2782:	4505                	li	a0,1
    2784:	00003097          	auipc	ra,0x3
    2788:	0d0080e7          	jalr	208(ra) # 5854 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    278c:	872a                	mv	a4,a0
    278e:	86a6                	mv	a3,s1
    2790:	864a                	mv	a2,s2
    2792:	85d2                	mv	a1,s4
    2794:	00004517          	auipc	a0,0x4
    2798:	71c50513          	addi	a0,a0,1820 # 6eb0 <malloc+0x121e>
    279c:	00003097          	auipc	ra,0x3
    27a0:	438080e7          	jalr	1080(ra) # 5bd4 <printf>
      exit(1);
    27a4:	4505                	li	a0,1
    27a6:	00003097          	auipc	ra,0x3
    27aa:	0ae080e7          	jalr	174(ra) # 5854 <exit>
    printf("%s: sbrk test fork failed\n", s);
    27ae:	85d2                	mv	a1,s4
    27b0:	00004517          	auipc	a0,0x4
    27b4:	72050513          	addi	a0,a0,1824 # 6ed0 <malloc+0x123e>
    27b8:	00003097          	auipc	ra,0x3
    27bc:	41c080e7          	jalr	1052(ra) # 5bd4 <printf>
    exit(1);
    27c0:	4505                	li	a0,1
    27c2:	00003097          	auipc	ra,0x3
    27c6:	092080e7          	jalr	146(ra) # 5854 <exit>
  if(pid == 0)
    27ca:	00091763          	bnez	s2,27d8 <sbrkbasic+0x170>
    exit(0);
    27ce:	4501                	li	a0,0
    27d0:	00003097          	auipc	ra,0x3
    27d4:	084080e7          	jalr	132(ra) # 5854 <exit>
  wait(&xstatus);
    27d8:	fbc40513          	addi	a0,s0,-68
    27dc:	00003097          	auipc	ra,0x3
    27e0:	080080e7          	jalr	128(ra) # 585c <wait>
  exit(xstatus);
    27e4:	fbc42503          	lw	a0,-68(s0)
    27e8:	00003097          	auipc	ra,0x3
    27ec:	06c080e7          	jalr	108(ra) # 5854 <exit>

00000000000027f0 <sbrkmuch>:
{
    27f0:	7179                	addi	sp,sp,-48
    27f2:	f406                	sd	ra,40(sp)
    27f4:	f022                	sd	s0,32(sp)
    27f6:	ec26                	sd	s1,24(sp)
    27f8:	e84a                	sd	s2,16(sp)
    27fa:	e44e                	sd	s3,8(sp)
    27fc:	e052                	sd	s4,0(sp)
    27fe:	1800                	addi	s0,sp,48
    2800:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2802:	4501                	li	a0,0
    2804:	00003097          	auipc	ra,0x3
    2808:	0d8080e7          	jalr	216(ra) # 58dc <sbrk>
    280c:	892a                	mv	s2,a0
  a = sbrk(0);
    280e:	4501                	li	a0,0
    2810:	00003097          	auipc	ra,0x3
    2814:	0cc080e7          	jalr	204(ra) # 58dc <sbrk>
    2818:	84aa                	mv	s1,a0
  p = sbrk(amt);
    281a:	06400537          	lui	a0,0x6400
    281e:	9d05                	subw	a0,a0,s1
    2820:	00003097          	auipc	ra,0x3
    2824:	0bc080e7          	jalr	188(ra) # 58dc <sbrk>
  if (p != a) {
    2828:	0ca49863          	bne	s1,a0,28f8 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    282c:	4501                	li	a0,0
    282e:	00003097          	auipc	ra,0x3
    2832:	0ae080e7          	jalr	174(ra) # 58dc <sbrk>
    2836:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2838:	00a4f963          	bgeu	s1,a0,284a <sbrkmuch+0x5a>
    *pp = 1;
    283c:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    283e:	6705                	lui	a4,0x1
    *pp = 1;
    2840:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2844:	94ba                	add	s1,s1,a4
    2846:	fef4ede3          	bltu	s1,a5,2840 <sbrkmuch+0x50>
  *lastaddr = 99;
    284a:	064007b7          	lui	a5,0x6400
    284e:	06300713          	li	a4,99
    2852:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1257>
  a = sbrk(0);
    2856:	4501                	li	a0,0
    2858:	00003097          	auipc	ra,0x3
    285c:	084080e7          	jalr	132(ra) # 58dc <sbrk>
    2860:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2862:	757d                	lui	a0,0xfffff
    2864:	00003097          	auipc	ra,0x3
    2868:	078080e7          	jalr	120(ra) # 58dc <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    286c:	57fd                	li	a5,-1
    286e:	0af50363          	beq	a0,a5,2914 <sbrkmuch+0x124>
  c = sbrk(0);
    2872:	4501                	li	a0,0
    2874:	00003097          	auipc	ra,0x3
    2878:	068080e7          	jalr	104(ra) # 58dc <sbrk>
  if(c != a - PGSIZE){
    287c:	77fd                	lui	a5,0xfffff
    287e:	97a6                	add	a5,a5,s1
    2880:	0af51863          	bne	a0,a5,2930 <sbrkmuch+0x140>
  a = sbrk(0);
    2884:	4501                	li	a0,0
    2886:	00003097          	auipc	ra,0x3
    288a:	056080e7          	jalr	86(ra) # 58dc <sbrk>
    288e:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2890:	6505                	lui	a0,0x1
    2892:	00003097          	auipc	ra,0x3
    2896:	04a080e7          	jalr	74(ra) # 58dc <sbrk>
    289a:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    289c:	0aa49a63          	bne	s1,a0,2950 <sbrkmuch+0x160>
    28a0:	4501                	li	a0,0
    28a2:	00003097          	auipc	ra,0x3
    28a6:	03a080e7          	jalr	58(ra) # 58dc <sbrk>
    28aa:	6785                	lui	a5,0x1
    28ac:	97a6                	add	a5,a5,s1
    28ae:	0af51163          	bne	a0,a5,2950 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    28b2:	064007b7          	lui	a5,0x6400
    28b6:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1257>
    28ba:	06300793          	li	a5,99
    28be:	0af70963          	beq	a4,a5,2970 <sbrkmuch+0x180>
  a = sbrk(0);
    28c2:	4501                	li	a0,0
    28c4:	00003097          	auipc	ra,0x3
    28c8:	018080e7          	jalr	24(ra) # 58dc <sbrk>
    28cc:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    28ce:	4501                	li	a0,0
    28d0:	00003097          	auipc	ra,0x3
    28d4:	00c080e7          	jalr	12(ra) # 58dc <sbrk>
    28d8:	40a9053b          	subw	a0,s2,a0
    28dc:	00003097          	auipc	ra,0x3
    28e0:	000080e7          	jalr	ra # 58dc <sbrk>
  if(c != a){
    28e4:	0aa49463          	bne	s1,a0,298c <sbrkmuch+0x19c>
}
    28e8:	70a2                	ld	ra,40(sp)
    28ea:	7402                	ld	s0,32(sp)
    28ec:	64e2                	ld	s1,24(sp)
    28ee:	6942                	ld	s2,16(sp)
    28f0:	69a2                	ld	s3,8(sp)
    28f2:	6a02                	ld	s4,0(sp)
    28f4:	6145                	addi	sp,sp,48
    28f6:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    28f8:	85ce                	mv	a1,s3
    28fa:	00004517          	auipc	a0,0x4
    28fe:	61650513          	addi	a0,a0,1558 # 6f10 <malloc+0x127e>
    2902:	00003097          	auipc	ra,0x3
    2906:	2d2080e7          	jalr	722(ra) # 5bd4 <printf>
    exit(1);
    290a:	4505                	li	a0,1
    290c:	00003097          	auipc	ra,0x3
    2910:	f48080e7          	jalr	-184(ra) # 5854 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2914:	85ce                	mv	a1,s3
    2916:	00004517          	auipc	a0,0x4
    291a:	64250513          	addi	a0,a0,1602 # 6f58 <malloc+0x12c6>
    291e:	00003097          	auipc	ra,0x3
    2922:	2b6080e7          	jalr	694(ra) # 5bd4 <printf>
    exit(1);
    2926:	4505                	li	a0,1
    2928:	00003097          	auipc	ra,0x3
    292c:	f2c080e7          	jalr	-212(ra) # 5854 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2930:	86aa                	mv	a3,a0
    2932:	8626                	mv	a2,s1
    2934:	85ce                	mv	a1,s3
    2936:	00004517          	auipc	a0,0x4
    293a:	64250513          	addi	a0,a0,1602 # 6f78 <malloc+0x12e6>
    293e:	00003097          	auipc	ra,0x3
    2942:	296080e7          	jalr	662(ra) # 5bd4 <printf>
    exit(1);
    2946:	4505                	li	a0,1
    2948:	00003097          	auipc	ra,0x3
    294c:	f0c080e7          	jalr	-244(ra) # 5854 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2950:	86d2                	mv	a3,s4
    2952:	8626                	mv	a2,s1
    2954:	85ce                	mv	a1,s3
    2956:	00004517          	auipc	a0,0x4
    295a:	66250513          	addi	a0,a0,1634 # 6fb8 <malloc+0x1326>
    295e:	00003097          	auipc	ra,0x3
    2962:	276080e7          	jalr	630(ra) # 5bd4 <printf>
    exit(1);
    2966:	4505                	li	a0,1
    2968:	00003097          	auipc	ra,0x3
    296c:	eec080e7          	jalr	-276(ra) # 5854 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2970:	85ce                	mv	a1,s3
    2972:	00004517          	auipc	a0,0x4
    2976:	67650513          	addi	a0,a0,1654 # 6fe8 <malloc+0x1356>
    297a:	00003097          	auipc	ra,0x3
    297e:	25a080e7          	jalr	602(ra) # 5bd4 <printf>
    exit(1);
    2982:	4505                	li	a0,1
    2984:	00003097          	auipc	ra,0x3
    2988:	ed0080e7          	jalr	-304(ra) # 5854 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    298c:	86aa                	mv	a3,a0
    298e:	8626                	mv	a2,s1
    2990:	85ce                	mv	a1,s3
    2992:	00004517          	auipc	a0,0x4
    2996:	68e50513          	addi	a0,a0,1678 # 7020 <malloc+0x138e>
    299a:	00003097          	auipc	ra,0x3
    299e:	23a080e7          	jalr	570(ra) # 5bd4 <printf>
    exit(1);
    29a2:	4505                	li	a0,1
    29a4:	00003097          	auipc	ra,0x3
    29a8:	eb0080e7          	jalr	-336(ra) # 5854 <exit>

00000000000029ac <sbrkarg>:
{
    29ac:	7179                	addi	sp,sp,-48
    29ae:	f406                	sd	ra,40(sp)
    29b0:	f022                	sd	s0,32(sp)
    29b2:	ec26                	sd	s1,24(sp)
    29b4:	e84a                	sd	s2,16(sp)
    29b6:	e44e                	sd	s3,8(sp)
    29b8:	1800                	addi	s0,sp,48
    29ba:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    29bc:	6505                	lui	a0,0x1
    29be:	00003097          	auipc	ra,0x3
    29c2:	f1e080e7          	jalr	-226(ra) # 58dc <sbrk>
    29c6:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    29c8:	20100593          	li	a1,513
    29cc:	00004517          	auipc	a0,0x4
    29d0:	67c50513          	addi	a0,a0,1660 # 7048 <malloc+0x13b6>
    29d4:	00003097          	auipc	ra,0x3
    29d8:	ec0080e7          	jalr	-320(ra) # 5894 <open>
    29dc:	84aa                	mv	s1,a0
  unlink("sbrk");
    29de:	00004517          	auipc	a0,0x4
    29e2:	66a50513          	addi	a0,a0,1642 # 7048 <malloc+0x13b6>
    29e6:	00003097          	auipc	ra,0x3
    29ea:	ebe080e7          	jalr	-322(ra) # 58a4 <unlink>
  if(fd < 0)  {
    29ee:	0404c163          	bltz	s1,2a30 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    29f2:	6605                	lui	a2,0x1
    29f4:	85ca                	mv	a1,s2
    29f6:	8526                	mv	a0,s1
    29f8:	00003097          	auipc	ra,0x3
    29fc:	e7c080e7          	jalr	-388(ra) # 5874 <write>
    2a00:	04054663          	bltz	a0,2a4c <sbrkarg+0xa0>
  close(fd);
    2a04:	8526                	mv	a0,s1
    2a06:	00003097          	auipc	ra,0x3
    2a0a:	e76080e7          	jalr	-394(ra) # 587c <close>
  a = sbrk(PGSIZE);
    2a0e:	6505                	lui	a0,0x1
    2a10:	00003097          	auipc	ra,0x3
    2a14:	ecc080e7          	jalr	-308(ra) # 58dc <sbrk>
  if(pipe((int *) a) != 0){
    2a18:	00003097          	auipc	ra,0x3
    2a1c:	e4c080e7          	jalr	-436(ra) # 5864 <pipe>
    2a20:	e521                	bnez	a0,2a68 <sbrkarg+0xbc>
}
    2a22:	70a2                	ld	ra,40(sp)
    2a24:	7402                	ld	s0,32(sp)
    2a26:	64e2                	ld	s1,24(sp)
    2a28:	6942                	ld	s2,16(sp)
    2a2a:	69a2                	ld	s3,8(sp)
    2a2c:	6145                	addi	sp,sp,48
    2a2e:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2a30:	85ce                	mv	a1,s3
    2a32:	00004517          	auipc	a0,0x4
    2a36:	61e50513          	addi	a0,a0,1566 # 7050 <malloc+0x13be>
    2a3a:	00003097          	auipc	ra,0x3
    2a3e:	19a080e7          	jalr	410(ra) # 5bd4 <printf>
    exit(1);
    2a42:	4505                	li	a0,1
    2a44:	00003097          	auipc	ra,0x3
    2a48:	e10080e7          	jalr	-496(ra) # 5854 <exit>
    printf("%s: write sbrk failed\n", s);
    2a4c:	85ce                	mv	a1,s3
    2a4e:	00004517          	auipc	a0,0x4
    2a52:	61a50513          	addi	a0,a0,1562 # 7068 <malloc+0x13d6>
    2a56:	00003097          	auipc	ra,0x3
    2a5a:	17e080e7          	jalr	382(ra) # 5bd4 <printf>
    exit(1);
    2a5e:	4505                	li	a0,1
    2a60:	00003097          	auipc	ra,0x3
    2a64:	df4080e7          	jalr	-524(ra) # 5854 <exit>
    printf("%s: pipe() failed\n", s);
    2a68:	85ce                	mv	a1,s3
    2a6a:	00004517          	auipc	a0,0x4
    2a6e:	fe650513          	addi	a0,a0,-26 # 6a50 <malloc+0xdbe>
    2a72:	00003097          	auipc	ra,0x3
    2a76:	162080e7          	jalr	354(ra) # 5bd4 <printf>
    exit(1);
    2a7a:	4505                	li	a0,1
    2a7c:	00003097          	auipc	ra,0x3
    2a80:	dd8080e7          	jalr	-552(ra) # 5854 <exit>

0000000000002a84 <argptest>:
{
    2a84:	1101                	addi	sp,sp,-32
    2a86:	ec06                	sd	ra,24(sp)
    2a88:	e822                	sd	s0,16(sp)
    2a8a:	e426                	sd	s1,8(sp)
    2a8c:	e04a                	sd	s2,0(sp)
    2a8e:	1000                	addi	s0,sp,32
    2a90:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2a92:	4581                	li	a1,0
    2a94:	00004517          	auipc	a0,0x4
    2a98:	5ec50513          	addi	a0,a0,1516 # 7080 <malloc+0x13ee>
    2a9c:	00003097          	auipc	ra,0x3
    2aa0:	df8080e7          	jalr	-520(ra) # 5894 <open>
  if (fd < 0) {
    2aa4:	02054b63          	bltz	a0,2ada <argptest+0x56>
    2aa8:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2aaa:	4501                	li	a0,0
    2aac:	00003097          	auipc	ra,0x3
    2ab0:	e30080e7          	jalr	-464(ra) # 58dc <sbrk>
    2ab4:	567d                	li	a2,-1
    2ab6:	fff50593          	addi	a1,a0,-1
    2aba:	8526                	mv	a0,s1
    2abc:	00003097          	auipc	ra,0x3
    2ac0:	db0080e7          	jalr	-592(ra) # 586c <read>
  close(fd);
    2ac4:	8526                	mv	a0,s1
    2ac6:	00003097          	auipc	ra,0x3
    2aca:	db6080e7          	jalr	-586(ra) # 587c <close>
}
    2ace:	60e2                	ld	ra,24(sp)
    2ad0:	6442                	ld	s0,16(sp)
    2ad2:	64a2                	ld	s1,8(sp)
    2ad4:	6902                	ld	s2,0(sp)
    2ad6:	6105                	addi	sp,sp,32
    2ad8:	8082                	ret
    printf("%s: open failed\n", s);
    2ada:	85ca                	mv	a1,s2
    2adc:	00004517          	auipc	a0,0x4
    2ae0:	e8450513          	addi	a0,a0,-380 # 6960 <malloc+0xcce>
    2ae4:	00003097          	auipc	ra,0x3
    2ae8:	0f0080e7          	jalr	240(ra) # 5bd4 <printf>
    exit(1);
    2aec:	4505                	li	a0,1
    2aee:	00003097          	auipc	ra,0x3
    2af2:	d66080e7          	jalr	-666(ra) # 5854 <exit>

0000000000002af6 <sbrkbugs>:
{
    2af6:	1141                	addi	sp,sp,-16
    2af8:	e406                	sd	ra,8(sp)
    2afa:	e022                	sd	s0,0(sp)
    2afc:	0800                	addi	s0,sp,16
  int pid = fork();
    2afe:	00003097          	auipc	ra,0x3
    2b02:	d4e080e7          	jalr	-690(ra) # 584c <fork>
  if(pid < 0){
    2b06:	02054263          	bltz	a0,2b2a <sbrkbugs+0x34>
  if(pid == 0){
    2b0a:	ed0d                	bnez	a0,2b44 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2b0c:	00003097          	auipc	ra,0x3
    2b10:	dd0080e7          	jalr	-560(ra) # 58dc <sbrk>
    sbrk(-sz);
    2b14:	40a0053b          	negw	a0,a0
    2b18:	00003097          	auipc	ra,0x3
    2b1c:	dc4080e7          	jalr	-572(ra) # 58dc <sbrk>
    exit(0);
    2b20:	4501                	li	a0,0
    2b22:	00003097          	auipc	ra,0x3
    2b26:	d32080e7          	jalr	-718(ra) # 5854 <exit>
    printf("fork failed\n");
    2b2a:	00004517          	auipc	a0,0x4
    2b2e:	23e50513          	addi	a0,a0,574 # 6d68 <malloc+0x10d6>
    2b32:	00003097          	auipc	ra,0x3
    2b36:	0a2080e7          	jalr	162(ra) # 5bd4 <printf>
    exit(1);
    2b3a:	4505                	li	a0,1
    2b3c:	00003097          	auipc	ra,0x3
    2b40:	d18080e7          	jalr	-744(ra) # 5854 <exit>
  wait(0);
    2b44:	4501                	li	a0,0
    2b46:	00003097          	auipc	ra,0x3
    2b4a:	d16080e7          	jalr	-746(ra) # 585c <wait>
  pid = fork();
    2b4e:	00003097          	auipc	ra,0x3
    2b52:	cfe080e7          	jalr	-770(ra) # 584c <fork>
  if(pid < 0){
    2b56:	02054563          	bltz	a0,2b80 <sbrkbugs+0x8a>
  if(pid == 0){
    2b5a:	e121                	bnez	a0,2b9a <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2b5c:	00003097          	auipc	ra,0x3
    2b60:	d80080e7          	jalr	-640(ra) # 58dc <sbrk>
    sbrk(-(sz - 3500));
    2b64:	6785                	lui	a5,0x1
    2b66:	dac7879b          	addiw	a5,a5,-596
    2b6a:	40a7853b          	subw	a0,a5,a0
    2b6e:	00003097          	auipc	ra,0x3
    2b72:	d6e080e7          	jalr	-658(ra) # 58dc <sbrk>
    exit(0);
    2b76:	4501                	li	a0,0
    2b78:	00003097          	auipc	ra,0x3
    2b7c:	cdc080e7          	jalr	-804(ra) # 5854 <exit>
    printf("fork failed\n");
    2b80:	00004517          	auipc	a0,0x4
    2b84:	1e850513          	addi	a0,a0,488 # 6d68 <malloc+0x10d6>
    2b88:	00003097          	auipc	ra,0x3
    2b8c:	04c080e7          	jalr	76(ra) # 5bd4 <printf>
    exit(1);
    2b90:	4505                	li	a0,1
    2b92:	00003097          	auipc	ra,0x3
    2b96:	cc2080e7          	jalr	-830(ra) # 5854 <exit>
  wait(0);
    2b9a:	4501                	li	a0,0
    2b9c:	00003097          	auipc	ra,0x3
    2ba0:	cc0080e7          	jalr	-832(ra) # 585c <wait>
  pid = fork();
    2ba4:	00003097          	auipc	ra,0x3
    2ba8:	ca8080e7          	jalr	-856(ra) # 584c <fork>
  if(pid < 0){
    2bac:	02054a63          	bltz	a0,2be0 <sbrkbugs+0xea>
  if(pid == 0){
    2bb0:	e529                	bnez	a0,2bfa <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2bb2:	00003097          	auipc	ra,0x3
    2bb6:	d2a080e7          	jalr	-726(ra) # 58dc <sbrk>
    2bba:	67ad                	lui	a5,0xb
    2bbc:	8007879b          	addiw	a5,a5,-2048
    2bc0:	40a7853b          	subw	a0,a5,a0
    2bc4:	00003097          	auipc	ra,0x3
    2bc8:	d18080e7          	jalr	-744(ra) # 58dc <sbrk>
    sbrk(-10);
    2bcc:	5559                	li	a0,-10
    2bce:	00003097          	auipc	ra,0x3
    2bd2:	d0e080e7          	jalr	-754(ra) # 58dc <sbrk>
    exit(0);
    2bd6:	4501                	li	a0,0
    2bd8:	00003097          	auipc	ra,0x3
    2bdc:	c7c080e7          	jalr	-900(ra) # 5854 <exit>
    printf("fork failed\n");
    2be0:	00004517          	auipc	a0,0x4
    2be4:	18850513          	addi	a0,a0,392 # 6d68 <malloc+0x10d6>
    2be8:	00003097          	auipc	ra,0x3
    2bec:	fec080e7          	jalr	-20(ra) # 5bd4 <printf>
    exit(1);
    2bf0:	4505                	li	a0,1
    2bf2:	00003097          	auipc	ra,0x3
    2bf6:	c62080e7          	jalr	-926(ra) # 5854 <exit>
  wait(0);
    2bfa:	4501                	li	a0,0
    2bfc:	00003097          	auipc	ra,0x3
    2c00:	c60080e7          	jalr	-928(ra) # 585c <wait>
  exit(0);
    2c04:	4501                	li	a0,0
    2c06:	00003097          	auipc	ra,0x3
    2c0a:	c4e080e7          	jalr	-946(ra) # 5854 <exit>

0000000000002c0e <sbrklast>:
{
    2c0e:	7179                	addi	sp,sp,-48
    2c10:	f406                	sd	ra,40(sp)
    2c12:	f022                	sd	s0,32(sp)
    2c14:	ec26                	sd	s1,24(sp)
    2c16:	e84a                	sd	s2,16(sp)
    2c18:	e44e                	sd	s3,8(sp)
    2c1a:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2c1c:	4501                	li	a0,0
    2c1e:	00003097          	auipc	ra,0x3
    2c22:	cbe080e7          	jalr	-834(ra) # 58dc <sbrk>
  if((top % 4096) != 0)
    2c26:	03451793          	slli	a5,a0,0x34
    2c2a:	efc1                	bnez	a5,2cc2 <sbrklast+0xb4>
  sbrk(4096);
    2c2c:	6505                	lui	a0,0x1
    2c2e:	00003097          	auipc	ra,0x3
    2c32:	cae080e7          	jalr	-850(ra) # 58dc <sbrk>
  sbrk(10);
    2c36:	4529                	li	a0,10
    2c38:	00003097          	auipc	ra,0x3
    2c3c:	ca4080e7          	jalr	-860(ra) # 58dc <sbrk>
  sbrk(-20);
    2c40:	5531                	li	a0,-20
    2c42:	00003097          	auipc	ra,0x3
    2c46:	c9a080e7          	jalr	-870(ra) # 58dc <sbrk>
  top = (uint64) sbrk(0);
    2c4a:	4501                	li	a0,0
    2c4c:	00003097          	auipc	ra,0x3
    2c50:	c90080e7          	jalr	-880(ra) # 58dc <sbrk>
    2c54:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2c56:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x5c>
  p[0] = 'x';
    2c5a:	07800793          	li	a5,120
    2c5e:	fcf50023          	sb	a5,-64(a0)
  p[1] = '\0';
    2c62:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2c66:	20200593          	li	a1,514
    2c6a:	854a                	mv	a0,s2
    2c6c:	00003097          	auipc	ra,0x3
    2c70:	c28080e7          	jalr	-984(ra) # 5894 <open>
    2c74:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2c76:	4605                	li	a2,1
    2c78:	85ca                	mv	a1,s2
    2c7a:	00003097          	auipc	ra,0x3
    2c7e:	bfa080e7          	jalr	-1030(ra) # 5874 <write>
  close(fd);
    2c82:	854e                	mv	a0,s3
    2c84:	00003097          	auipc	ra,0x3
    2c88:	bf8080e7          	jalr	-1032(ra) # 587c <close>
  fd = open(p, O_RDWR);
    2c8c:	4589                	li	a1,2
    2c8e:	854a                	mv	a0,s2
    2c90:	00003097          	auipc	ra,0x3
    2c94:	c04080e7          	jalr	-1020(ra) # 5894 <open>
  p[0] = '\0';
    2c98:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2c9c:	4605                	li	a2,1
    2c9e:	85ca                	mv	a1,s2
    2ca0:	00003097          	auipc	ra,0x3
    2ca4:	bcc080e7          	jalr	-1076(ra) # 586c <read>
  if(p[0] != 'x')
    2ca8:	fc04c703          	lbu	a4,-64(s1)
    2cac:	07800793          	li	a5,120
    2cb0:	02f71363          	bne	a4,a5,2cd6 <sbrklast+0xc8>
}
    2cb4:	70a2                	ld	ra,40(sp)
    2cb6:	7402                	ld	s0,32(sp)
    2cb8:	64e2                	ld	s1,24(sp)
    2cba:	6942                	ld	s2,16(sp)
    2cbc:	69a2                	ld	s3,8(sp)
    2cbe:	6145                	addi	sp,sp,48
    2cc0:	8082                	ret
    sbrk(4096 - (top % 4096));
    2cc2:	0347d513          	srli	a0,a5,0x34
    2cc6:	6785                	lui	a5,0x1
    2cc8:	40a7853b          	subw	a0,a5,a0
    2ccc:	00003097          	auipc	ra,0x3
    2cd0:	c10080e7          	jalr	-1008(ra) # 58dc <sbrk>
    2cd4:	bfa1                	j	2c2c <sbrklast+0x1e>
    exit(1);
    2cd6:	4505                	li	a0,1
    2cd8:	00003097          	auipc	ra,0x3
    2cdc:	b7c080e7          	jalr	-1156(ra) # 5854 <exit>

0000000000002ce0 <sbrk8000>:
{
    2ce0:	1141                	addi	sp,sp,-16
    2ce2:	e406                	sd	ra,8(sp)
    2ce4:	e022                	sd	s0,0(sp)
    2ce6:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2ce8:	80000537          	lui	a0,0x80000
    2cec:	0511                	addi	a0,a0,4
    2cee:	00003097          	auipc	ra,0x3
    2cf2:	bee080e7          	jalr	-1042(ra) # 58dc <sbrk>
  volatile char *top = sbrk(0);
    2cf6:	4501                	li	a0,0
    2cf8:	00003097          	auipc	ra,0x3
    2cfc:	be4080e7          	jalr	-1052(ra) # 58dc <sbrk>
  *(top-1) = *(top-1) + 1;
    2d00:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <__BSS_END__+0xffffffff7fff1257>
    2d04:	0785                	addi	a5,a5,1
    2d06:	0ff7f793          	andi	a5,a5,255
    2d0a:	fef50fa3          	sb	a5,-1(a0)
}
    2d0e:	60a2                	ld	ra,8(sp)
    2d10:	6402                	ld	s0,0(sp)
    2d12:	0141                	addi	sp,sp,16
    2d14:	8082                	ret

0000000000002d16 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2d16:	715d                	addi	sp,sp,-80
    2d18:	e486                	sd	ra,72(sp)
    2d1a:	e0a2                	sd	s0,64(sp)
    2d1c:	fc26                	sd	s1,56(sp)
    2d1e:	f84a                	sd	s2,48(sp)
    2d20:	f44e                	sd	s3,40(sp)
    2d22:	f052                	sd	s4,32(sp)
    2d24:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2d26:	4901                	li	s2,0
    2d28:	49bd                	li	s3,15
    int pid = fork();
    2d2a:	00003097          	auipc	ra,0x3
    2d2e:	b22080e7          	jalr	-1246(ra) # 584c <fork>
    2d32:	84aa                	mv	s1,a0
    if(pid < 0){
    2d34:	02054063          	bltz	a0,2d54 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2d38:	c91d                	beqz	a0,2d6e <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2d3a:	4501                	li	a0,0
    2d3c:	00003097          	auipc	ra,0x3
    2d40:	b20080e7          	jalr	-1248(ra) # 585c <wait>
  for(int avail = 0; avail < 15; avail++){
    2d44:	2905                	addiw	s2,s2,1
    2d46:	ff3912e3          	bne	s2,s3,2d2a <execout+0x14>
    }
  }

  exit(0);
    2d4a:	4501                	li	a0,0
    2d4c:	00003097          	auipc	ra,0x3
    2d50:	b08080e7          	jalr	-1272(ra) # 5854 <exit>
      printf("fork failed\n");
    2d54:	00004517          	auipc	a0,0x4
    2d58:	01450513          	addi	a0,a0,20 # 6d68 <malloc+0x10d6>
    2d5c:	00003097          	auipc	ra,0x3
    2d60:	e78080e7          	jalr	-392(ra) # 5bd4 <printf>
      exit(1);
    2d64:	4505                	li	a0,1
    2d66:	00003097          	auipc	ra,0x3
    2d6a:	aee080e7          	jalr	-1298(ra) # 5854 <exit>
        if(a == 0xffffffffffffffffLL)
    2d6e:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2d70:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2d72:	6505                	lui	a0,0x1
    2d74:	00003097          	auipc	ra,0x3
    2d78:	b68080e7          	jalr	-1176(ra) # 58dc <sbrk>
        if(a == 0xffffffffffffffffLL)
    2d7c:	01350763          	beq	a0,s3,2d8a <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2d80:	6785                	lui	a5,0x1
    2d82:	953e                	add	a0,a0,a5
    2d84:	ff450fa3          	sb	s4,-1(a0) # fff <bigdir+0x9b>
      while(1){
    2d88:	b7ed                	j	2d72 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2d8a:	01205a63          	blez	s2,2d9e <execout+0x88>
        sbrk(-4096);
    2d8e:	757d                	lui	a0,0xfffff
    2d90:	00003097          	auipc	ra,0x3
    2d94:	b4c080e7          	jalr	-1204(ra) # 58dc <sbrk>
      for(int i = 0; i < avail; i++)
    2d98:	2485                	addiw	s1,s1,1
    2d9a:	ff249ae3          	bne	s1,s2,2d8e <execout+0x78>
      close(1);
    2d9e:	4505                	li	a0,1
    2da0:	00003097          	auipc	ra,0x3
    2da4:	adc080e7          	jalr	-1316(ra) # 587c <close>
      char *args[] = { "echo", "x", 0 };
    2da8:	00003517          	auipc	a0,0x3
    2dac:	36850513          	addi	a0,a0,872 # 6110 <malloc+0x47e>
    2db0:	faa43c23          	sd	a0,-72(s0)
    2db4:	00003797          	auipc	a5,0x3
    2db8:	3cc78793          	addi	a5,a5,972 # 6180 <malloc+0x4ee>
    2dbc:	fcf43023          	sd	a5,-64(s0)
    2dc0:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2dc4:	fb840593          	addi	a1,s0,-72
    2dc8:	00003097          	auipc	ra,0x3
    2dcc:	ac4080e7          	jalr	-1340(ra) # 588c <exec>
      exit(0);
    2dd0:	4501                	li	a0,0
    2dd2:	00003097          	auipc	ra,0x3
    2dd6:	a82080e7          	jalr	-1406(ra) # 5854 <exit>

0000000000002dda <fourteen>:
{
    2dda:	1101                	addi	sp,sp,-32
    2ddc:	ec06                	sd	ra,24(sp)
    2dde:	e822                	sd	s0,16(sp)
    2de0:	e426                	sd	s1,8(sp)
    2de2:	1000                	addi	s0,sp,32
    2de4:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2de6:	00004517          	auipc	a0,0x4
    2dea:	47250513          	addi	a0,a0,1138 # 7258 <malloc+0x15c6>
    2dee:	00003097          	auipc	ra,0x3
    2df2:	ace080e7          	jalr	-1330(ra) # 58bc <mkdir>
    2df6:	e165                	bnez	a0,2ed6 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2df8:	00004517          	auipc	a0,0x4
    2dfc:	2b850513          	addi	a0,a0,696 # 70b0 <malloc+0x141e>
    2e00:	00003097          	auipc	ra,0x3
    2e04:	abc080e7          	jalr	-1348(ra) # 58bc <mkdir>
    2e08:	e56d                	bnez	a0,2ef2 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2e0a:	20000593          	li	a1,512
    2e0e:	00004517          	auipc	a0,0x4
    2e12:	2fa50513          	addi	a0,a0,762 # 7108 <malloc+0x1476>
    2e16:	00003097          	auipc	ra,0x3
    2e1a:	a7e080e7          	jalr	-1410(ra) # 5894 <open>
  if(fd < 0){
    2e1e:	0e054863          	bltz	a0,2f0e <fourteen+0x134>
  close(fd);
    2e22:	00003097          	auipc	ra,0x3
    2e26:	a5a080e7          	jalr	-1446(ra) # 587c <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2e2a:	4581                	li	a1,0
    2e2c:	00004517          	auipc	a0,0x4
    2e30:	35450513          	addi	a0,a0,852 # 7180 <malloc+0x14ee>
    2e34:	00003097          	auipc	ra,0x3
    2e38:	a60080e7          	jalr	-1440(ra) # 5894 <open>
  if(fd < 0){
    2e3c:	0e054763          	bltz	a0,2f2a <fourteen+0x150>
  close(fd);
    2e40:	00003097          	auipc	ra,0x3
    2e44:	a3c080e7          	jalr	-1476(ra) # 587c <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2e48:	00004517          	auipc	a0,0x4
    2e4c:	3a850513          	addi	a0,a0,936 # 71f0 <malloc+0x155e>
    2e50:	00003097          	auipc	ra,0x3
    2e54:	a6c080e7          	jalr	-1428(ra) # 58bc <mkdir>
    2e58:	c57d                	beqz	a0,2f46 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2e5a:	00004517          	auipc	a0,0x4
    2e5e:	3ee50513          	addi	a0,a0,1006 # 7248 <malloc+0x15b6>
    2e62:	00003097          	auipc	ra,0x3
    2e66:	a5a080e7          	jalr	-1446(ra) # 58bc <mkdir>
    2e6a:	cd65                	beqz	a0,2f62 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2e6c:	00004517          	auipc	a0,0x4
    2e70:	3dc50513          	addi	a0,a0,988 # 7248 <malloc+0x15b6>
    2e74:	00003097          	auipc	ra,0x3
    2e78:	a30080e7          	jalr	-1488(ra) # 58a4 <unlink>
  unlink("12345678901234/12345678901234");
    2e7c:	00004517          	auipc	a0,0x4
    2e80:	37450513          	addi	a0,a0,884 # 71f0 <malloc+0x155e>
    2e84:	00003097          	auipc	ra,0x3
    2e88:	a20080e7          	jalr	-1504(ra) # 58a4 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2e8c:	00004517          	auipc	a0,0x4
    2e90:	2f450513          	addi	a0,a0,756 # 7180 <malloc+0x14ee>
    2e94:	00003097          	auipc	ra,0x3
    2e98:	a10080e7          	jalr	-1520(ra) # 58a4 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2e9c:	00004517          	auipc	a0,0x4
    2ea0:	26c50513          	addi	a0,a0,620 # 7108 <malloc+0x1476>
    2ea4:	00003097          	auipc	ra,0x3
    2ea8:	a00080e7          	jalr	-1536(ra) # 58a4 <unlink>
  unlink("12345678901234/123456789012345");
    2eac:	00004517          	auipc	a0,0x4
    2eb0:	20450513          	addi	a0,a0,516 # 70b0 <malloc+0x141e>
    2eb4:	00003097          	auipc	ra,0x3
    2eb8:	9f0080e7          	jalr	-1552(ra) # 58a4 <unlink>
  unlink("12345678901234");
    2ebc:	00004517          	auipc	a0,0x4
    2ec0:	39c50513          	addi	a0,a0,924 # 7258 <malloc+0x15c6>
    2ec4:	00003097          	auipc	ra,0x3
    2ec8:	9e0080e7          	jalr	-1568(ra) # 58a4 <unlink>
}
    2ecc:	60e2                	ld	ra,24(sp)
    2ece:	6442                	ld	s0,16(sp)
    2ed0:	64a2                	ld	s1,8(sp)
    2ed2:	6105                	addi	sp,sp,32
    2ed4:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2ed6:	85a6                	mv	a1,s1
    2ed8:	00004517          	auipc	a0,0x4
    2edc:	1b050513          	addi	a0,a0,432 # 7088 <malloc+0x13f6>
    2ee0:	00003097          	auipc	ra,0x3
    2ee4:	cf4080e7          	jalr	-780(ra) # 5bd4 <printf>
    exit(1);
    2ee8:	4505                	li	a0,1
    2eea:	00003097          	auipc	ra,0x3
    2eee:	96a080e7          	jalr	-1686(ra) # 5854 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2ef2:	85a6                	mv	a1,s1
    2ef4:	00004517          	auipc	a0,0x4
    2ef8:	1dc50513          	addi	a0,a0,476 # 70d0 <malloc+0x143e>
    2efc:	00003097          	auipc	ra,0x3
    2f00:	cd8080e7          	jalr	-808(ra) # 5bd4 <printf>
    exit(1);
    2f04:	4505                	li	a0,1
    2f06:	00003097          	auipc	ra,0x3
    2f0a:	94e080e7          	jalr	-1714(ra) # 5854 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2f0e:	85a6                	mv	a1,s1
    2f10:	00004517          	auipc	a0,0x4
    2f14:	22850513          	addi	a0,a0,552 # 7138 <malloc+0x14a6>
    2f18:	00003097          	auipc	ra,0x3
    2f1c:	cbc080e7          	jalr	-836(ra) # 5bd4 <printf>
    exit(1);
    2f20:	4505                	li	a0,1
    2f22:	00003097          	auipc	ra,0x3
    2f26:	932080e7          	jalr	-1742(ra) # 5854 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2f2a:	85a6                	mv	a1,s1
    2f2c:	00004517          	auipc	a0,0x4
    2f30:	28450513          	addi	a0,a0,644 # 71b0 <malloc+0x151e>
    2f34:	00003097          	auipc	ra,0x3
    2f38:	ca0080e7          	jalr	-864(ra) # 5bd4 <printf>
    exit(1);
    2f3c:	4505                	li	a0,1
    2f3e:	00003097          	auipc	ra,0x3
    2f42:	916080e7          	jalr	-1770(ra) # 5854 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2f46:	85a6                	mv	a1,s1
    2f48:	00004517          	auipc	a0,0x4
    2f4c:	2c850513          	addi	a0,a0,712 # 7210 <malloc+0x157e>
    2f50:	00003097          	auipc	ra,0x3
    2f54:	c84080e7          	jalr	-892(ra) # 5bd4 <printf>
    exit(1);
    2f58:	4505                	li	a0,1
    2f5a:	00003097          	auipc	ra,0x3
    2f5e:	8fa080e7          	jalr	-1798(ra) # 5854 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2f62:	85a6                	mv	a1,s1
    2f64:	00004517          	auipc	a0,0x4
    2f68:	30450513          	addi	a0,a0,772 # 7268 <malloc+0x15d6>
    2f6c:	00003097          	auipc	ra,0x3
    2f70:	c68080e7          	jalr	-920(ra) # 5bd4 <printf>
    exit(1);
    2f74:	4505                	li	a0,1
    2f76:	00003097          	auipc	ra,0x3
    2f7a:	8de080e7          	jalr	-1826(ra) # 5854 <exit>

0000000000002f7e <iputtest>:
{
    2f7e:	1101                	addi	sp,sp,-32
    2f80:	ec06                	sd	ra,24(sp)
    2f82:	e822                	sd	s0,16(sp)
    2f84:	e426                	sd	s1,8(sp)
    2f86:	1000                	addi	s0,sp,32
    2f88:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2f8a:	00004517          	auipc	a0,0x4
    2f8e:	31650513          	addi	a0,a0,790 # 72a0 <malloc+0x160e>
    2f92:	00003097          	auipc	ra,0x3
    2f96:	92a080e7          	jalr	-1750(ra) # 58bc <mkdir>
    2f9a:	04054563          	bltz	a0,2fe4 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2f9e:	00004517          	auipc	a0,0x4
    2fa2:	30250513          	addi	a0,a0,770 # 72a0 <malloc+0x160e>
    2fa6:	00003097          	auipc	ra,0x3
    2faa:	91e080e7          	jalr	-1762(ra) # 58c4 <chdir>
    2fae:	04054963          	bltz	a0,3000 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2fb2:	00004517          	auipc	a0,0x4
    2fb6:	32e50513          	addi	a0,a0,814 # 72e0 <malloc+0x164e>
    2fba:	00003097          	auipc	ra,0x3
    2fbe:	8ea080e7          	jalr	-1814(ra) # 58a4 <unlink>
    2fc2:	04054d63          	bltz	a0,301c <iputtest+0x9e>
  if(chdir("/") < 0){
    2fc6:	00004517          	auipc	a0,0x4
    2fca:	34a50513          	addi	a0,a0,842 # 7310 <malloc+0x167e>
    2fce:	00003097          	auipc	ra,0x3
    2fd2:	8f6080e7          	jalr	-1802(ra) # 58c4 <chdir>
    2fd6:	06054163          	bltz	a0,3038 <iputtest+0xba>
}
    2fda:	60e2                	ld	ra,24(sp)
    2fdc:	6442                	ld	s0,16(sp)
    2fde:	64a2                	ld	s1,8(sp)
    2fe0:	6105                	addi	sp,sp,32
    2fe2:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2fe4:	85a6                	mv	a1,s1
    2fe6:	00004517          	auipc	a0,0x4
    2fea:	2c250513          	addi	a0,a0,706 # 72a8 <malloc+0x1616>
    2fee:	00003097          	auipc	ra,0x3
    2ff2:	be6080e7          	jalr	-1050(ra) # 5bd4 <printf>
    exit(1);
    2ff6:	4505                	li	a0,1
    2ff8:	00003097          	auipc	ra,0x3
    2ffc:	85c080e7          	jalr	-1956(ra) # 5854 <exit>
    printf("%s: chdir iputdir failed\n", s);
    3000:	85a6                	mv	a1,s1
    3002:	00004517          	auipc	a0,0x4
    3006:	2be50513          	addi	a0,a0,702 # 72c0 <malloc+0x162e>
    300a:	00003097          	auipc	ra,0x3
    300e:	bca080e7          	jalr	-1078(ra) # 5bd4 <printf>
    exit(1);
    3012:	4505                	li	a0,1
    3014:	00003097          	auipc	ra,0x3
    3018:	840080e7          	jalr	-1984(ra) # 5854 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    301c:	85a6                	mv	a1,s1
    301e:	00004517          	auipc	a0,0x4
    3022:	2d250513          	addi	a0,a0,722 # 72f0 <malloc+0x165e>
    3026:	00003097          	auipc	ra,0x3
    302a:	bae080e7          	jalr	-1106(ra) # 5bd4 <printf>
    exit(1);
    302e:	4505                	li	a0,1
    3030:	00003097          	auipc	ra,0x3
    3034:	824080e7          	jalr	-2012(ra) # 5854 <exit>
    printf("%s: chdir / failed\n", s);
    3038:	85a6                	mv	a1,s1
    303a:	00004517          	auipc	a0,0x4
    303e:	2de50513          	addi	a0,a0,734 # 7318 <malloc+0x1686>
    3042:	00003097          	auipc	ra,0x3
    3046:	b92080e7          	jalr	-1134(ra) # 5bd4 <printf>
    exit(1);
    304a:	4505                	li	a0,1
    304c:	00003097          	auipc	ra,0x3
    3050:	808080e7          	jalr	-2040(ra) # 5854 <exit>

0000000000003054 <exitiputtest>:
{
    3054:	7179                	addi	sp,sp,-48
    3056:	f406                	sd	ra,40(sp)
    3058:	f022                	sd	s0,32(sp)
    305a:	ec26                	sd	s1,24(sp)
    305c:	1800                	addi	s0,sp,48
    305e:	84aa                	mv	s1,a0
  pid = fork();
    3060:	00002097          	auipc	ra,0x2
    3064:	7ec080e7          	jalr	2028(ra) # 584c <fork>
  if(pid < 0){
    3068:	04054663          	bltz	a0,30b4 <exitiputtest+0x60>
  if(pid == 0){
    306c:	ed45                	bnez	a0,3124 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    306e:	00004517          	auipc	a0,0x4
    3072:	23250513          	addi	a0,a0,562 # 72a0 <malloc+0x160e>
    3076:	00003097          	auipc	ra,0x3
    307a:	846080e7          	jalr	-1978(ra) # 58bc <mkdir>
    307e:	04054963          	bltz	a0,30d0 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    3082:	00004517          	auipc	a0,0x4
    3086:	21e50513          	addi	a0,a0,542 # 72a0 <malloc+0x160e>
    308a:	00003097          	auipc	ra,0x3
    308e:	83a080e7          	jalr	-1990(ra) # 58c4 <chdir>
    3092:	04054d63          	bltz	a0,30ec <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    3096:	00004517          	auipc	a0,0x4
    309a:	24a50513          	addi	a0,a0,586 # 72e0 <malloc+0x164e>
    309e:	00003097          	auipc	ra,0x3
    30a2:	806080e7          	jalr	-2042(ra) # 58a4 <unlink>
    30a6:	06054163          	bltz	a0,3108 <exitiputtest+0xb4>
    exit(0);
    30aa:	4501                	li	a0,0
    30ac:	00002097          	auipc	ra,0x2
    30b0:	7a8080e7          	jalr	1960(ra) # 5854 <exit>
    printf("%s: fork failed\n", s);
    30b4:	85a6                	mv	a1,s1
    30b6:	00004517          	auipc	a0,0x4
    30ba:	89250513          	addi	a0,a0,-1902 # 6948 <malloc+0xcb6>
    30be:	00003097          	auipc	ra,0x3
    30c2:	b16080e7          	jalr	-1258(ra) # 5bd4 <printf>
    exit(1);
    30c6:	4505                	li	a0,1
    30c8:	00002097          	auipc	ra,0x2
    30cc:	78c080e7          	jalr	1932(ra) # 5854 <exit>
      printf("%s: mkdir failed\n", s);
    30d0:	85a6                	mv	a1,s1
    30d2:	00004517          	auipc	a0,0x4
    30d6:	1d650513          	addi	a0,a0,470 # 72a8 <malloc+0x1616>
    30da:	00003097          	auipc	ra,0x3
    30de:	afa080e7          	jalr	-1286(ra) # 5bd4 <printf>
      exit(1);
    30e2:	4505                	li	a0,1
    30e4:	00002097          	auipc	ra,0x2
    30e8:	770080e7          	jalr	1904(ra) # 5854 <exit>
      printf("%s: child chdir failed\n", s);
    30ec:	85a6                	mv	a1,s1
    30ee:	00004517          	auipc	a0,0x4
    30f2:	24250513          	addi	a0,a0,578 # 7330 <malloc+0x169e>
    30f6:	00003097          	auipc	ra,0x3
    30fa:	ade080e7          	jalr	-1314(ra) # 5bd4 <printf>
      exit(1);
    30fe:	4505                	li	a0,1
    3100:	00002097          	auipc	ra,0x2
    3104:	754080e7          	jalr	1876(ra) # 5854 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3108:	85a6                	mv	a1,s1
    310a:	00004517          	auipc	a0,0x4
    310e:	1e650513          	addi	a0,a0,486 # 72f0 <malloc+0x165e>
    3112:	00003097          	auipc	ra,0x3
    3116:	ac2080e7          	jalr	-1342(ra) # 5bd4 <printf>
      exit(1);
    311a:	4505                	li	a0,1
    311c:	00002097          	auipc	ra,0x2
    3120:	738080e7          	jalr	1848(ra) # 5854 <exit>
  wait(&xstatus);
    3124:	fdc40513          	addi	a0,s0,-36
    3128:	00002097          	auipc	ra,0x2
    312c:	734080e7          	jalr	1844(ra) # 585c <wait>
  exit(xstatus);
    3130:	fdc42503          	lw	a0,-36(s0)
    3134:	00002097          	auipc	ra,0x2
    3138:	720080e7          	jalr	1824(ra) # 5854 <exit>

000000000000313c <dirtest>:
{
    313c:	1101                	addi	sp,sp,-32
    313e:	ec06                	sd	ra,24(sp)
    3140:	e822                	sd	s0,16(sp)
    3142:	e426                	sd	s1,8(sp)
    3144:	1000                	addi	s0,sp,32
    3146:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    3148:	00004517          	auipc	a0,0x4
    314c:	20050513          	addi	a0,a0,512 # 7348 <malloc+0x16b6>
    3150:	00002097          	auipc	ra,0x2
    3154:	76c080e7          	jalr	1900(ra) # 58bc <mkdir>
    3158:	04054563          	bltz	a0,31a2 <dirtest+0x66>
  if(chdir("dir0") < 0){
    315c:	00004517          	auipc	a0,0x4
    3160:	1ec50513          	addi	a0,a0,492 # 7348 <malloc+0x16b6>
    3164:	00002097          	auipc	ra,0x2
    3168:	760080e7          	jalr	1888(ra) # 58c4 <chdir>
    316c:	04054963          	bltz	a0,31be <dirtest+0x82>
  if(chdir("..") < 0){
    3170:	00004517          	auipc	a0,0x4
    3174:	1f850513          	addi	a0,a0,504 # 7368 <malloc+0x16d6>
    3178:	00002097          	auipc	ra,0x2
    317c:	74c080e7          	jalr	1868(ra) # 58c4 <chdir>
    3180:	04054d63          	bltz	a0,31da <dirtest+0x9e>
  if(unlink("dir0") < 0){
    3184:	00004517          	auipc	a0,0x4
    3188:	1c450513          	addi	a0,a0,452 # 7348 <malloc+0x16b6>
    318c:	00002097          	auipc	ra,0x2
    3190:	718080e7          	jalr	1816(ra) # 58a4 <unlink>
    3194:	06054163          	bltz	a0,31f6 <dirtest+0xba>
}
    3198:	60e2                	ld	ra,24(sp)
    319a:	6442                	ld	s0,16(sp)
    319c:	64a2                	ld	s1,8(sp)
    319e:	6105                	addi	sp,sp,32
    31a0:	8082                	ret
    printf("%s: mkdir failed\n", s);
    31a2:	85a6                	mv	a1,s1
    31a4:	00004517          	auipc	a0,0x4
    31a8:	10450513          	addi	a0,a0,260 # 72a8 <malloc+0x1616>
    31ac:	00003097          	auipc	ra,0x3
    31b0:	a28080e7          	jalr	-1496(ra) # 5bd4 <printf>
    exit(1);
    31b4:	4505                	li	a0,1
    31b6:	00002097          	auipc	ra,0x2
    31ba:	69e080e7          	jalr	1694(ra) # 5854 <exit>
    printf("%s: chdir dir0 failed\n", s);
    31be:	85a6                	mv	a1,s1
    31c0:	00004517          	auipc	a0,0x4
    31c4:	19050513          	addi	a0,a0,400 # 7350 <malloc+0x16be>
    31c8:	00003097          	auipc	ra,0x3
    31cc:	a0c080e7          	jalr	-1524(ra) # 5bd4 <printf>
    exit(1);
    31d0:	4505                	li	a0,1
    31d2:	00002097          	auipc	ra,0x2
    31d6:	682080e7          	jalr	1666(ra) # 5854 <exit>
    printf("%s: chdir .. failed\n", s);
    31da:	85a6                	mv	a1,s1
    31dc:	00004517          	auipc	a0,0x4
    31e0:	19450513          	addi	a0,a0,404 # 7370 <malloc+0x16de>
    31e4:	00003097          	auipc	ra,0x3
    31e8:	9f0080e7          	jalr	-1552(ra) # 5bd4 <printf>
    exit(1);
    31ec:	4505                	li	a0,1
    31ee:	00002097          	auipc	ra,0x2
    31f2:	666080e7          	jalr	1638(ra) # 5854 <exit>
    printf("%s: unlink dir0 failed\n", s);
    31f6:	85a6                	mv	a1,s1
    31f8:	00004517          	auipc	a0,0x4
    31fc:	19050513          	addi	a0,a0,400 # 7388 <malloc+0x16f6>
    3200:	00003097          	auipc	ra,0x3
    3204:	9d4080e7          	jalr	-1580(ra) # 5bd4 <printf>
    exit(1);
    3208:	4505                	li	a0,1
    320a:	00002097          	auipc	ra,0x2
    320e:	64a080e7          	jalr	1610(ra) # 5854 <exit>

0000000000003212 <subdir>:
{
    3212:	1101                	addi	sp,sp,-32
    3214:	ec06                	sd	ra,24(sp)
    3216:	e822                	sd	s0,16(sp)
    3218:	e426                	sd	s1,8(sp)
    321a:	e04a                	sd	s2,0(sp)
    321c:	1000                	addi	s0,sp,32
    321e:	892a                	mv	s2,a0
  unlink("ff");
    3220:	00004517          	auipc	a0,0x4
    3224:	2b050513          	addi	a0,a0,688 # 74d0 <malloc+0x183e>
    3228:	00002097          	auipc	ra,0x2
    322c:	67c080e7          	jalr	1660(ra) # 58a4 <unlink>
  if(mkdir("dd") != 0){
    3230:	00004517          	auipc	a0,0x4
    3234:	17050513          	addi	a0,a0,368 # 73a0 <malloc+0x170e>
    3238:	00002097          	auipc	ra,0x2
    323c:	684080e7          	jalr	1668(ra) # 58bc <mkdir>
    3240:	38051663          	bnez	a0,35cc <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3244:	20200593          	li	a1,514
    3248:	00004517          	auipc	a0,0x4
    324c:	17850513          	addi	a0,a0,376 # 73c0 <malloc+0x172e>
    3250:	00002097          	auipc	ra,0x2
    3254:	644080e7          	jalr	1604(ra) # 5894 <open>
    3258:	84aa                	mv	s1,a0
  if(fd < 0){
    325a:	38054763          	bltz	a0,35e8 <subdir+0x3d6>
  write(fd, "ff", 2);
    325e:	4609                	li	a2,2
    3260:	00004597          	auipc	a1,0x4
    3264:	27058593          	addi	a1,a1,624 # 74d0 <malloc+0x183e>
    3268:	00002097          	auipc	ra,0x2
    326c:	60c080e7          	jalr	1548(ra) # 5874 <write>
  close(fd);
    3270:	8526                	mv	a0,s1
    3272:	00002097          	auipc	ra,0x2
    3276:	60a080e7          	jalr	1546(ra) # 587c <close>
  if(unlink("dd") >= 0){
    327a:	00004517          	auipc	a0,0x4
    327e:	12650513          	addi	a0,a0,294 # 73a0 <malloc+0x170e>
    3282:	00002097          	auipc	ra,0x2
    3286:	622080e7          	jalr	1570(ra) # 58a4 <unlink>
    328a:	36055d63          	bgez	a0,3604 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    328e:	00004517          	auipc	a0,0x4
    3292:	18a50513          	addi	a0,a0,394 # 7418 <malloc+0x1786>
    3296:	00002097          	auipc	ra,0x2
    329a:	626080e7          	jalr	1574(ra) # 58bc <mkdir>
    329e:	38051163          	bnez	a0,3620 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    32a2:	20200593          	li	a1,514
    32a6:	00004517          	auipc	a0,0x4
    32aa:	19a50513          	addi	a0,a0,410 # 7440 <malloc+0x17ae>
    32ae:	00002097          	auipc	ra,0x2
    32b2:	5e6080e7          	jalr	1510(ra) # 5894 <open>
    32b6:	84aa                	mv	s1,a0
  if(fd < 0){
    32b8:	38054263          	bltz	a0,363c <subdir+0x42a>
  write(fd, "FF", 2);
    32bc:	4609                	li	a2,2
    32be:	00004597          	auipc	a1,0x4
    32c2:	1b258593          	addi	a1,a1,434 # 7470 <malloc+0x17de>
    32c6:	00002097          	auipc	ra,0x2
    32ca:	5ae080e7          	jalr	1454(ra) # 5874 <write>
  close(fd);
    32ce:	8526                	mv	a0,s1
    32d0:	00002097          	auipc	ra,0x2
    32d4:	5ac080e7          	jalr	1452(ra) # 587c <close>
  fd = open("dd/dd/../ff", 0);
    32d8:	4581                	li	a1,0
    32da:	00004517          	auipc	a0,0x4
    32de:	19e50513          	addi	a0,a0,414 # 7478 <malloc+0x17e6>
    32e2:	00002097          	auipc	ra,0x2
    32e6:	5b2080e7          	jalr	1458(ra) # 5894 <open>
    32ea:	84aa                	mv	s1,a0
  if(fd < 0){
    32ec:	36054663          	bltz	a0,3658 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    32f0:	660d                	lui	a2,0x3
    32f2:	00009597          	auipc	a1,0x9
    32f6:	aa658593          	addi	a1,a1,-1370 # bd98 <buf>
    32fa:	00002097          	auipc	ra,0x2
    32fe:	572080e7          	jalr	1394(ra) # 586c <read>
  if(cc != 2 || buf[0] != 'f'){
    3302:	4789                	li	a5,2
    3304:	36f51863          	bne	a0,a5,3674 <subdir+0x462>
    3308:	00009717          	auipc	a4,0x9
    330c:	a9074703          	lbu	a4,-1392(a4) # bd98 <buf>
    3310:	06600793          	li	a5,102
    3314:	36f71063          	bne	a4,a5,3674 <subdir+0x462>
  close(fd);
    3318:	8526                	mv	a0,s1
    331a:	00002097          	auipc	ra,0x2
    331e:	562080e7          	jalr	1378(ra) # 587c <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3322:	00004597          	auipc	a1,0x4
    3326:	1a658593          	addi	a1,a1,422 # 74c8 <malloc+0x1836>
    332a:	00004517          	auipc	a0,0x4
    332e:	11650513          	addi	a0,a0,278 # 7440 <malloc+0x17ae>
    3332:	00002097          	auipc	ra,0x2
    3336:	582080e7          	jalr	1410(ra) # 58b4 <link>
    333a:	34051b63          	bnez	a0,3690 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    333e:	00004517          	auipc	a0,0x4
    3342:	10250513          	addi	a0,a0,258 # 7440 <malloc+0x17ae>
    3346:	00002097          	auipc	ra,0x2
    334a:	55e080e7          	jalr	1374(ra) # 58a4 <unlink>
    334e:	34051f63          	bnez	a0,36ac <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3352:	4581                	li	a1,0
    3354:	00004517          	auipc	a0,0x4
    3358:	0ec50513          	addi	a0,a0,236 # 7440 <malloc+0x17ae>
    335c:	00002097          	auipc	ra,0x2
    3360:	538080e7          	jalr	1336(ra) # 5894 <open>
    3364:	36055263          	bgez	a0,36c8 <subdir+0x4b6>
  if(chdir("dd") != 0){
    3368:	00004517          	auipc	a0,0x4
    336c:	03850513          	addi	a0,a0,56 # 73a0 <malloc+0x170e>
    3370:	00002097          	auipc	ra,0x2
    3374:	554080e7          	jalr	1364(ra) # 58c4 <chdir>
    3378:	36051663          	bnez	a0,36e4 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    337c:	00004517          	auipc	a0,0x4
    3380:	1e450513          	addi	a0,a0,484 # 7560 <malloc+0x18ce>
    3384:	00002097          	auipc	ra,0x2
    3388:	540080e7          	jalr	1344(ra) # 58c4 <chdir>
    338c:	36051a63          	bnez	a0,3700 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    3390:	00004517          	auipc	a0,0x4
    3394:	20050513          	addi	a0,a0,512 # 7590 <malloc+0x18fe>
    3398:	00002097          	auipc	ra,0x2
    339c:	52c080e7          	jalr	1324(ra) # 58c4 <chdir>
    33a0:	36051e63          	bnez	a0,371c <subdir+0x50a>
  if(chdir("./..") != 0){
    33a4:	00004517          	auipc	a0,0x4
    33a8:	21c50513          	addi	a0,a0,540 # 75c0 <malloc+0x192e>
    33ac:	00002097          	auipc	ra,0x2
    33b0:	518080e7          	jalr	1304(ra) # 58c4 <chdir>
    33b4:	38051263          	bnez	a0,3738 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    33b8:	4581                	li	a1,0
    33ba:	00004517          	auipc	a0,0x4
    33be:	10e50513          	addi	a0,a0,270 # 74c8 <malloc+0x1836>
    33c2:	00002097          	auipc	ra,0x2
    33c6:	4d2080e7          	jalr	1234(ra) # 5894 <open>
    33ca:	84aa                	mv	s1,a0
  if(fd < 0){
    33cc:	38054463          	bltz	a0,3754 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    33d0:	660d                	lui	a2,0x3
    33d2:	00009597          	auipc	a1,0x9
    33d6:	9c658593          	addi	a1,a1,-1594 # bd98 <buf>
    33da:	00002097          	auipc	ra,0x2
    33de:	492080e7          	jalr	1170(ra) # 586c <read>
    33e2:	4789                	li	a5,2
    33e4:	38f51663          	bne	a0,a5,3770 <subdir+0x55e>
  close(fd);
    33e8:	8526                	mv	a0,s1
    33ea:	00002097          	auipc	ra,0x2
    33ee:	492080e7          	jalr	1170(ra) # 587c <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    33f2:	4581                	li	a1,0
    33f4:	00004517          	auipc	a0,0x4
    33f8:	04c50513          	addi	a0,a0,76 # 7440 <malloc+0x17ae>
    33fc:	00002097          	auipc	ra,0x2
    3400:	498080e7          	jalr	1176(ra) # 5894 <open>
    3404:	38055463          	bgez	a0,378c <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3408:	20200593          	li	a1,514
    340c:	00004517          	auipc	a0,0x4
    3410:	24450513          	addi	a0,a0,580 # 7650 <malloc+0x19be>
    3414:	00002097          	auipc	ra,0x2
    3418:	480080e7          	jalr	1152(ra) # 5894 <open>
    341c:	38055663          	bgez	a0,37a8 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3420:	20200593          	li	a1,514
    3424:	00004517          	auipc	a0,0x4
    3428:	25c50513          	addi	a0,a0,604 # 7680 <malloc+0x19ee>
    342c:	00002097          	auipc	ra,0x2
    3430:	468080e7          	jalr	1128(ra) # 5894 <open>
    3434:	38055863          	bgez	a0,37c4 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3438:	20000593          	li	a1,512
    343c:	00004517          	auipc	a0,0x4
    3440:	f6450513          	addi	a0,a0,-156 # 73a0 <malloc+0x170e>
    3444:	00002097          	auipc	ra,0x2
    3448:	450080e7          	jalr	1104(ra) # 5894 <open>
    344c:	38055a63          	bgez	a0,37e0 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3450:	4589                	li	a1,2
    3452:	00004517          	auipc	a0,0x4
    3456:	f4e50513          	addi	a0,a0,-178 # 73a0 <malloc+0x170e>
    345a:	00002097          	auipc	ra,0x2
    345e:	43a080e7          	jalr	1082(ra) # 5894 <open>
    3462:	38055d63          	bgez	a0,37fc <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    3466:	4585                	li	a1,1
    3468:	00004517          	auipc	a0,0x4
    346c:	f3850513          	addi	a0,a0,-200 # 73a0 <malloc+0x170e>
    3470:	00002097          	auipc	ra,0x2
    3474:	424080e7          	jalr	1060(ra) # 5894 <open>
    3478:	3a055063          	bgez	a0,3818 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    347c:	00004597          	auipc	a1,0x4
    3480:	29458593          	addi	a1,a1,660 # 7710 <malloc+0x1a7e>
    3484:	00004517          	auipc	a0,0x4
    3488:	1cc50513          	addi	a0,a0,460 # 7650 <malloc+0x19be>
    348c:	00002097          	auipc	ra,0x2
    3490:	428080e7          	jalr	1064(ra) # 58b4 <link>
    3494:	3a050063          	beqz	a0,3834 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3498:	00004597          	auipc	a1,0x4
    349c:	27858593          	addi	a1,a1,632 # 7710 <malloc+0x1a7e>
    34a0:	00004517          	auipc	a0,0x4
    34a4:	1e050513          	addi	a0,a0,480 # 7680 <malloc+0x19ee>
    34a8:	00002097          	auipc	ra,0x2
    34ac:	40c080e7          	jalr	1036(ra) # 58b4 <link>
    34b0:	3a050063          	beqz	a0,3850 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    34b4:	00004597          	auipc	a1,0x4
    34b8:	01458593          	addi	a1,a1,20 # 74c8 <malloc+0x1836>
    34bc:	00004517          	auipc	a0,0x4
    34c0:	f0450513          	addi	a0,a0,-252 # 73c0 <malloc+0x172e>
    34c4:	00002097          	auipc	ra,0x2
    34c8:	3f0080e7          	jalr	1008(ra) # 58b4 <link>
    34cc:	3a050063          	beqz	a0,386c <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    34d0:	00004517          	auipc	a0,0x4
    34d4:	18050513          	addi	a0,a0,384 # 7650 <malloc+0x19be>
    34d8:	00002097          	auipc	ra,0x2
    34dc:	3e4080e7          	jalr	996(ra) # 58bc <mkdir>
    34e0:	3a050463          	beqz	a0,3888 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    34e4:	00004517          	auipc	a0,0x4
    34e8:	19c50513          	addi	a0,a0,412 # 7680 <malloc+0x19ee>
    34ec:	00002097          	auipc	ra,0x2
    34f0:	3d0080e7          	jalr	976(ra) # 58bc <mkdir>
    34f4:	3a050863          	beqz	a0,38a4 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    34f8:	00004517          	auipc	a0,0x4
    34fc:	fd050513          	addi	a0,a0,-48 # 74c8 <malloc+0x1836>
    3500:	00002097          	auipc	ra,0x2
    3504:	3bc080e7          	jalr	956(ra) # 58bc <mkdir>
    3508:	3a050c63          	beqz	a0,38c0 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    350c:	00004517          	auipc	a0,0x4
    3510:	17450513          	addi	a0,a0,372 # 7680 <malloc+0x19ee>
    3514:	00002097          	auipc	ra,0x2
    3518:	390080e7          	jalr	912(ra) # 58a4 <unlink>
    351c:	3c050063          	beqz	a0,38dc <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3520:	00004517          	auipc	a0,0x4
    3524:	13050513          	addi	a0,a0,304 # 7650 <malloc+0x19be>
    3528:	00002097          	auipc	ra,0x2
    352c:	37c080e7          	jalr	892(ra) # 58a4 <unlink>
    3530:	3c050463          	beqz	a0,38f8 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3534:	00004517          	auipc	a0,0x4
    3538:	e8c50513          	addi	a0,a0,-372 # 73c0 <malloc+0x172e>
    353c:	00002097          	auipc	ra,0x2
    3540:	388080e7          	jalr	904(ra) # 58c4 <chdir>
    3544:	3c050863          	beqz	a0,3914 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3548:	00004517          	auipc	a0,0x4
    354c:	31850513          	addi	a0,a0,792 # 7860 <malloc+0x1bce>
    3550:	00002097          	auipc	ra,0x2
    3554:	374080e7          	jalr	884(ra) # 58c4 <chdir>
    3558:	3c050c63          	beqz	a0,3930 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    355c:	00004517          	auipc	a0,0x4
    3560:	f6c50513          	addi	a0,a0,-148 # 74c8 <malloc+0x1836>
    3564:	00002097          	auipc	ra,0x2
    3568:	340080e7          	jalr	832(ra) # 58a4 <unlink>
    356c:	3e051063          	bnez	a0,394c <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3570:	00004517          	auipc	a0,0x4
    3574:	e5050513          	addi	a0,a0,-432 # 73c0 <malloc+0x172e>
    3578:	00002097          	auipc	ra,0x2
    357c:	32c080e7          	jalr	812(ra) # 58a4 <unlink>
    3580:	3e051463          	bnez	a0,3968 <subdir+0x756>
  if(unlink("dd") == 0){
    3584:	00004517          	auipc	a0,0x4
    3588:	e1c50513          	addi	a0,a0,-484 # 73a0 <malloc+0x170e>
    358c:	00002097          	auipc	ra,0x2
    3590:	318080e7          	jalr	792(ra) # 58a4 <unlink>
    3594:	3e050863          	beqz	a0,3984 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3598:	00004517          	auipc	a0,0x4
    359c:	33850513          	addi	a0,a0,824 # 78d0 <malloc+0x1c3e>
    35a0:	00002097          	auipc	ra,0x2
    35a4:	304080e7          	jalr	772(ra) # 58a4 <unlink>
    35a8:	3e054c63          	bltz	a0,39a0 <subdir+0x78e>
  if(unlink("dd") < 0){
    35ac:	00004517          	auipc	a0,0x4
    35b0:	df450513          	addi	a0,a0,-524 # 73a0 <malloc+0x170e>
    35b4:	00002097          	auipc	ra,0x2
    35b8:	2f0080e7          	jalr	752(ra) # 58a4 <unlink>
    35bc:	40054063          	bltz	a0,39bc <subdir+0x7aa>
}
    35c0:	60e2                	ld	ra,24(sp)
    35c2:	6442                	ld	s0,16(sp)
    35c4:	64a2                	ld	s1,8(sp)
    35c6:	6902                	ld	s2,0(sp)
    35c8:	6105                	addi	sp,sp,32
    35ca:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    35cc:	85ca                	mv	a1,s2
    35ce:	00004517          	auipc	a0,0x4
    35d2:	dda50513          	addi	a0,a0,-550 # 73a8 <malloc+0x1716>
    35d6:	00002097          	auipc	ra,0x2
    35da:	5fe080e7          	jalr	1534(ra) # 5bd4 <printf>
    exit(1);
    35de:	4505                	li	a0,1
    35e0:	00002097          	auipc	ra,0x2
    35e4:	274080e7          	jalr	628(ra) # 5854 <exit>
    printf("%s: create dd/ff failed\n", s);
    35e8:	85ca                	mv	a1,s2
    35ea:	00004517          	auipc	a0,0x4
    35ee:	dde50513          	addi	a0,a0,-546 # 73c8 <malloc+0x1736>
    35f2:	00002097          	auipc	ra,0x2
    35f6:	5e2080e7          	jalr	1506(ra) # 5bd4 <printf>
    exit(1);
    35fa:	4505                	li	a0,1
    35fc:	00002097          	auipc	ra,0x2
    3600:	258080e7          	jalr	600(ra) # 5854 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3604:	85ca                	mv	a1,s2
    3606:	00004517          	auipc	a0,0x4
    360a:	de250513          	addi	a0,a0,-542 # 73e8 <malloc+0x1756>
    360e:	00002097          	auipc	ra,0x2
    3612:	5c6080e7          	jalr	1478(ra) # 5bd4 <printf>
    exit(1);
    3616:	4505                	li	a0,1
    3618:	00002097          	auipc	ra,0x2
    361c:	23c080e7          	jalr	572(ra) # 5854 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3620:	85ca                	mv	a1,s2
    3622:	00004517          	auipc	a0,0x4
    3626:	dfe50513          	addi	a0,a0,-514 # 7420 <malloc+0x178e>
    362a:	00002097          	auipc	ra,0x2
    362e:	5aa080e7          	jalr	1450(ra) # 5bd4 <printf>
    exit(1);
    3632:	4505                	li	a0,1
    3634:	00002097          	auipc	ra,0x2
    3638:	220080e7          	jalr	544(ra) # 5854 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    363c:	85ca                	mv	a1,s2
    363e:	00004517          	auipc	a0,0x4
    3642:	e1250513          	addi	a0,a0,-494 # 7450 <malloc+0x17be>
    3646:	00002097          	auipc	ra,0x2
    364a:	58e080e7          	jalr	1422(ra) # 5bd4 <printf>
    exit(1);
    364e:	4505                	li	a0,1
    3650:	00002097          	auipc	ra,0x2
    3654:	204080e7          	jalr	516(ra) # 5854 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3658:	85ca                	mv	a1,s2
    365a:	00004517          	auipc	a0,0x4
    365e:	e2e50513          	addi	a0,a0,-466 # 7488 <malloc+0x17f6>
    3662:	00002097          	auipc	ra,0x2
    3666:	572080e7          	jalr	1394(ra) # 5bd4 <printf>
    exit(1);
    366a:	4505                	li	a0,1
    366c:	00002097          	auipc	ra,0x2
    3670:	1e8080e7          	jalr	488(ra) # 5854 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3674:	85ca                	mv	a1,s2
    3676:	00004517          	auipc	a0,0x4
    367a:	e3250513          	addi	a0,a0,-462 # 74a8 <malloc+0x1816>
    367e:	00002097          	auipc	ra,0x2
    3682:	556080e7          	jalr	1366(ra) # 5bd4 <printf>
    exit(1);
    3686:	4505                	li	a0,1
    3688:	00002097          	auipc	ra,0x2
    368c:	1cc080e7          	jalr	460(ra) # 5854 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3690:	85ca                	mv	a1,s2
    3692:	00004517          	auipc	a0,0x4
    3696:	e4650513          	addi	a0,a0,-442 # 74d8 <malloc+0x1846>
    369a:	00002097          	auipc	ra,0x2
    369e:	53a080e7          	jalr	1338(ra) # 5bd4 <printf>
    exit(1);
    36a2:	4505                	li	a0,1
    36a4:	00002097          	auipc	ra,0x2
    36a8:	1b0080e7          	jalr	432(ra) # 5854 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    36ac:	85ca                	mv	a1,s2
    36ae:	00004517          	auipc	a0,0x4
    36b2:	e5250513          	addi	a0,a0,-430 # 7500 <malloc+0x186e>
    36b6:	00002097          	auipc	ra,0x2
    36ba:	51e080e7          	jalr	1310(ra) # 5bd4 <printf>
    exit(1);
    36be:	4505                	li	a0,1
    36c0:	00002097          	auipc	ra,0x2
    36c4:	194080e7          	jalr	404(ra) # 5854 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    36c8:	85ca                	mv	a1,s2
    36ca:	00004517          	auipc	a0,0x4
    36ce:	e5650513          	addi	a0,a0,-426 # 7520 <malloc+0x188e>
    36d2:	00002097          	auipc	ra,0x2
    36d6:	502080e7          	jalr	1282(ra) # 5bd4 <printf>
    exit(1);
    36da:	4505                	li	a0,1
    36dc:	00002097          	auipc	ra,0x2
    36e0:	178080e7          	jalr	376(ra) # 5854 <exit>
    printf("%s: chdir dd failed\n", s);
    36e4:	85ca                	mv	a1,s2
    36e6:	00004517          	auipc	a0,0x4
    36ea:	e6250513          	addi	a0,a0,-414 # 7548 <malloc+0x18b6>
    36ee:	00002097          	auipc	ra,0x2
    36f2:	4e6080e7          	jalr	1254(ra) # 5bd4 <printf>
    exit(1);
    36f6:	4505                	li	a0,1
    36f8:	00002097          	auipc	ra,0x2
    36fc:	15c080e7          	jalr	348(ra) # 5854 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3700:	85ca                	mv	a1,s2
    3702:	00004517          	auipc	a0,0x4
    3706:	e6e50513          	addi	a0,a0,-402 # 7570 <malloc+0x18de>
    370a:	00002097          	auipc	ra,0x2
    370e:	4ca080e7          	jalr	1226(ra) # 5bd4 <printf>
    exit(1);
    3712:	4505                	li	a0,1
    3714:	00002097          	auipc	ra,0x2
    3718:	140080e7          	jalr	320(ra) # 5854 <exit>
    printf("chdir dd/../../dd failed\n", s);
    371c:	85ca                	mv	a1,s2
    371e:	00004517          	auipc	a0,0x4
    3722:	e8250513          	addi	a0,a0,-382 # 75a0 <malloc+0x190e>
    3726:	00002097          	auipc	ra,0x2
    372a:	4ae080e7          	jalr	1198(ra) # 5bd4 <printf>
    exit(1);
    372e:	4505                	li	a0,1
    3730:	00002097          	auipc	ra,0x2
    3734:	124080e7          	jalr	292(ra) # 5854 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3738:	85ca                	mv	a1,s2
    373a:	00004517          	auipc	a0,0x4
    373e:	e8e50513          	addi	a0,a0,-370 # 75c8 <malloc+0x1936>
    3742:	00002097          	auipc	ra,0x2
    3746:	492080e7          	jalr	1170(ra) # 5bd4 <printf>
    exit(1);
    374a:	4505                	li	a0,1
    374c:	00002097          	auipc	ra,0x2
    3750:	108080e7          	jalr	264(ra) # 5854 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3754:	85ca                	mv	a1,s2
    3756:	00004517          	auipc	a0,0x4
    375a:	e8a50513          	addi	a0,a0,-374 # 75e0 <malloc+0x194e>
    375e:	00002097          	auipc	ra,0x2
    3762:	476080e7          	jalr	1142(ra) # 5bd4 <printf>
    exit(1);
    3766:	4505                	li	a0,1
    3768:	00002097          	auipc	ra,0x2
    376c:	0ec080e7          	jalr	236(ra) # 5854 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3770:	85ca                	mv	a1,s2
    3772:	00004517          	auipc	a0,0x4
    3776:	e8e50513          	addi	a0,a0,-370 # 7600 <malloc+0x196e>
    377a:	00002097          	auipc	ra,0x2
    377e:	45a080e7          	jalr	1114(ra) # 5bd4 <printf>
    exit(1);
    3782:	4505                	li	a0,1
    3784:	00002097          	auipc	ra,0x2
    3788:	0d0080e7          	jalr	208(ra) # 5854 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    378c:	85ca                	mv	a1,s2
    378e:	00004517          	auipc	a0,0x4
    3792:	e9250513          	addi	a0,a0,-366 # 7620 <malloc+0x198e>
    3796:	00002097          	auipc	ra,0x2
    379a:	43e080e7          	jalr	1086(ra) # 5bd4 <printf>
    exit(1);
    379e:	4505                	li	a0,1
    37a0:	00002097          	auipc	ra,0x2
    37a4:	0b4080e7          	jalr	180(ra) # 5854 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    37a8:	85ca                	mv	a1,s2
    37aa:	00004517          	auipc	a0,0x4
    37ae:	eb650513          	addi	a0,a0,-330 # 7660 <malloc+0x19ce>
    37b2:	00002097          	auipc	ra,0x2
    37b6:	422080e7          	jalr	1058(ra) # 5bd4 <printf>
    exit(1);
    37ba:	4505                	li	a0,1
    37bc:	00002097          	auipc	ra,0x2
    37c0:	098080e7          	jalr	152(ra) # 5854 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    37c4:	85ca                	mv	a1,s2
    37c6:	00004517          	auipc	a0,0x4
    37ca:	eca50513          	addi	a0,a0,-310 # 7690 <malloc+0x19fe>
    37ce:	00002097          	auipc	ra,0x2
    37d2:	406080e7          	jalr	1030(ra) # 5bd4 <printf>
    exit(1);
    37d6:	4505                	li	a0,1
    37d8:	00002097          	auipc	ra,0x2
    37dc:	07c080e7          	jalr	124(ra) # 5854 <exit>
    printf("%s: create dd succeeded!\n", s);
    37e0:	85ca                	mv	a1,s2
    37e2:	00004517          	auipc	a0,0x4
    37e6:	ece50513          	addi	a0,a0,-306 # 76b0 <malloc+0x1a1e>
    37ea:	00002097          	auipc	ra,0x2
    37ee:	3ea080e7          	jalr	1002(ra) # 5bd4 <printf>
    exit(1);
    37f2:	4505                	li	a0,1
    37f4:	00002097          	auipc	ra,0x2
    37f8:	060080e7          	jalr	96(ra) # 5854 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    37fc:	85ca                	mv	a1,s2
    37fe:	00004517          	auipc	a0,0x4
    3802:	ed250513          	addi	a0,a0,-302 # 76d0 <malloc+0x1a3e>
    3806:	00002097          	auipc	ra,0x2
    380a:	3ce080e7          	jalr	974(ra) # 5bd4 <printf>
    exit(1);
    380e:	4505                	li	a0,1
    3810:	00002097          	auipc	ra,0x2
    3814:	044080e7          	jalr	68(ra) # 5854 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3818:	85ca                	mv	a1,s2
    381a:	00004517          	auipc	a0,0x4
    381e:	ed650513          	addi	a0,a0,-298 # 76f0 <malloc+0x1a5e>
    3822:	00002097          	auipc	ra,0x2
    3826:	3b2080e7          	jalr	946(ra) # 5bd4 <printf>
    exit(1);
    382a:	4505                	li	a0,1
    382c:	00002097          	auipc	ra,0x2
    3830:	028080e7          	jalr	40(ra) # 5854 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3834:	85ca                	mv	a1,s2
    3836:	00004517          	auipc	a0,0x4
    383a:	eea50513          	addi	a0,a0,-278 # 7720 <malloc+0x1a8e>
    383e:	00002097          	auipc	ra,0x2
    3842:	396080e7          	jalr	918(ra) # 5bd4 <printf>
    exit(1);
    3846:	4505                	li	a0,1
    3848:	00002097          	auipc	ra,0x2
    384c:	00c080e7          	jalr	12(ra) # 5854 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3850:	85ca                	mv	a1,s2
    3852:	00004517          	auipc	a0,0x4
    3856:	ef650513          	addi	a0,a0,-266 # 7748 <malloc+0x1ab6>
    385a:	00002097          	auipc	ra,0x2
    385e:	37a080e7          	jalr	890(ra) # 5bd4 <printf>
    exit(1);
    3862:	4505                	li	a0,1
    3864:	00002097          	auipc	ra,0x2
    3868:	ff0080e7          	jalr	-16(ra) # 5854 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    386c:	85ca                	mv	a1,s2
    386e:	00004517          	auipc	a0,0x4
    3872:	f0250513          	addi	a0,a0,-254 # 7770 <malloc+0x1ade>
    3876:	00002097          	auipc	ra,0x2
    387a:	35e080e7          	jalr	862(ra) # 5bd4 <printf>
    exit(1);
    387e:	4505                	li	a0,1
    3880:	00002097          	auipc	ra,0x2
    3884:	fd4080e7          	jalr	-44(ra) # 5854 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3888:	85ca                	mv	a1,s2
    388a:	00004517          	auipc	a0,0x4
    388e:	f0e50513          	addi	a0,a0,-242 # 7798 <malloc+0x1b06>
    3892:	00002097          	auipc	ra,0x2
    3896:	342080e7          	jalr	834(ra) # 5bd4 <printf>
    exit(1);
    389a:	4505                	li	a0,1
    389c:	00002097          	auipc	ra,0x2
    38a0:	fb8080e7          	jalr	-72(ra) # 5854 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    38a4:	85ca                	mv	a1,s2
    38a6:	00004517          	auipc	a0,0x4
    38aa:	f1250513          	addi	a0,a0,-238 # 77b8 <malloc+0x1b26>
    38ae:	00002097          	auipc	ra,0x2
    38b2:	326080e7          	jalr	806(ra) # 5bd4 <printf>
    exit(1);
    38b6:	4505                	li	a0,1
    38b8:	00002097          	auipc	ra,0x2
    38bc:	f9c080e7          	jalr	-100(ra) # 5854 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    38c0:	85ca                	mv	a1,s2
    38c2:	00004517          	auipc	a0,0x4
    38c6:	f1650513          	addi	a0,a0,-234 # 77d8 <malloc+0x1b46>
    38ca:	00002097          	auipc	ra,0x2
    38ce:	30a080e7          	jalr	778(ra) # 5bd4 <printf>
    exit(1);
    38d2:	4505                	li	a0,1
    38d4:	00002097          	auipc	ra,0x2
    38d8:	f80080e7          	jalr	-128(ra) # 5854 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    38dc:	85ca                	mv	a1,s2
    38de:	00004517          	auipc	a0,0x4
    38e2:	f2250513          	addi	a0,a0,-222 # 7800 <malloc+0x1b6e>
    38e6:	00002097          	auipc	ra,0x2
    38ea:	2ee080e7          	jalr	750(ra) # 5bd4 <printf>
    exit(1);
    38ee:	4505                	li	a0,1
    38f0:	00002097          	auipc	ra,0x2
    38f4:	f64080e7          	jalr	-156(ra) # 5854 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    38f8:	85ca                	mv	a1,s2
    38fa:	00004517          	auipc	a0,0x4
    38fe:	f2650513          	addi	a0,a0,-218 # 7820 <malloc+0x1b8e>
    3902:	00002097          	auipc	ra,0x2
    3906:	2d2080e7          	jalr	722(ra) # 5bd4 <printf>
    exit(1);
    390a:	4505                	li	a0,1
    390c:	00002097          	auipc	ra,0x2
    3910:	f48080e7          	jalr	-184(ra) # 5854 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3914:	85ca                	mv	a1,s2
    3916:	00004517          	auipc	a0,0x4
    391a:	f2a50513          	addi	a0,a0,-214 # 7840 <malloc+0x1bae>
    391e:	00002097          	auipc	ra,0x2
    3922:	2b6080e7          	jalr	694(ra) # 5bd4 <printf>
    exit(1);
    3926:	4505                	li	a0,1
    3928:	00002097          	auipc	ra,0x2
    392c:	f2c080e7          	jalr	-212(ra) # 5854 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3930:	85ca                	mv	a1,s2
    3932:	00004517          	auipc	a0,0x4
    3936:	f3650513          	addi	a0,a0,-202 # 7868 <malloc+0x1bd6>
    393a:	00002097          	auipc	ra,0x2
    393e:	29a080e7          	jalr	666(ra) # 5bd4 <printf>
    exit(1);
    3942:	4505                	li	a0,1
    3944:	00002097          	auipc	ra,0x2
    3948:	f10080e7          	jalr	-240(ra) # 5854 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    394c:	85ca                	mv	a1,s2
    394e:	00004517          	auipc	a0,0x4
    3952:	bb250513          	addi	a0,a0,-1102 # 7500 <malloc+0x186e>
    3956:	00002097          	auipc	ra,0x2
    395a:	27e080e7          	jalr	638(ra) # 5bd4 <printf>
    exit(1);
    395e:	4505                	li	a0,1
    3960:	00002097          	auipc	ra,0x2
    3964:	ef4080e7          	jalr	-268(ra) # 5854 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3968:	85ca                	mv	a1,s2
    396a:	00004517          	auipc	a0,0x4
    396e:	f1e50513          	addi	a0,a0,-226 # 7888 <malloc+0x1bf6>
    3972:	00002097          	auipc	ra,0x2
    3976:	262080e7          	jalr	610(ra) # 5bd4 <printf>
    exit(1);
    397a:	4505                	li	a0,1
    397c:	00002097          	auipc	ra,0x2
    3980:	ed8080e7          	jalr	-296(ra) # 5854 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3984:	85ca                	mv	a1,s2
    3986:	00004517          	auipc	a0,0x4
    398a:	f2250513          	addi	a0,a0,-222 # 78a8 <malloc+0x1c16>
    398e:	00002097          	auipc	ra,0x2
    3992:	246080e7          	jalr	582(ra) # 5bd4 <printf>
    exit(1);
    3996:	4505                	li	a0,1
    3998:	00002097          	auipc	ra,0x2
    399c:	ebc080e7          	jalr	-324(ra) # 5854 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    39a0:	85ca                	mv	a1,s2
    39a2:	00004517          	auipc	a0,0x4
    39a6:	f3650513          	addi	a0,a0,-202 # 78d8 <malloc+0x1c46>
    39aa:	00002097          	auipc	ra,0x2
    39ae:	22a080e7          	jalr	554(ra) # 5bd4 <printf>
    exit(1);
    39b2:	4505                	li	a0,1
    39b4:	00002097          	auipc	ra,0x2
    39b8:	ea0080e7          	jalr	-352(ra) # 5854 <exit>
    printf("%s: unlink dd failed\n", s);
    39bc:	85ca                	mv	a1,s2
    39be:	00004517          	auipc	a0,0x4
    39c2:	f3a50513          	addi	a0,a0,-198 # 78f8 <malloc+0x1c66>
    39c6:	00002097          	auipc	ra,0x2
    39ca:	20e080e7          	jalr	526(ra) # 5bd4 <printf>
    exit(1);
    39ce:	4505                	li	a0,1
    39d0:	00002097          	auipc	ra,0x2
    39d4:	e84080e7          	jalr	-380(ra) # 5854 <exit>

00000000000039d8 <rmdot>:
{
    39d8:	1101                	addi	sp,sp,-32
    39da:	ec06                	sd	ra,24(sp)
    39dc:	e822                	sd	s0,16(sp)
    39de:	e426                	sd	s1,8(sp)
    39e0:	1000                	addi	s0,sp,32
    39e2:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    39e4:	00004517          	auipc	a0,0x4
    39e8:	f2c50513          	addi	a0,a0,-212 # 7910 <malloc+0x1c7e>
    39ec:	00002097          	auipc	ra,0x2
    39f0:	ed0080e7          	jalr	-304(ra) # 58bc <mkdir>
    39f4:	e549                	bnez	a0,3a7e <rmdot+0xa6>
  if(chdir("dots") != 0){
    39f6:	00004517          	auipc	a0,0x4
    39fa:	f1a50513          	addi	a0,a0,-230 # 7910 <malloc+0x1c7e>
    39fe:	00002097          	auipc	ra,0x2
    3a02:	ec6080e7          	jalr	-314(ra) # 58c4 <chdir>
    3a06:	e951                	bnez	a0,3a9a <rmdot+0xc2>
  if(unlink(".") == 0){
    3a08:	00003517          	auipc	a0,0x3
    3a0c:	da050513          	addi	a0,a0,-608 # 67a8 <malloc+0xb16>
    3a10:	00002097          	auipc	ra,0x2
    3a14:	e94080e7          	jalr	-364(ra) # 58a4 <unlink>
    3a18:	cd59                	beqz	a0,3ab6 <rmdot+0xde>
  if(unlink("..") == 0){
    3a1a:	00004517          	auipc	a0,0x4
    3a1e:	94e50513          	addi	a0,a0,-1714 # 7368 <malloc+0x16d6>
    3a22:	00002097          	auipc	ra,0x2
    3a26:	e82080e7          	jalr	-382(ra) # 58a4 <unlink>
    3a2a:	c545                	beqz	a0,3ad2 <rmdot+0xfa>
  if(chdir("/") != 0){
    3a2c:	00004517          	auipc	a0,0x4
    3a30:	8e450513          	addi	a0,a0,-1820 # 7310 <malloc+0x167e>
    3a34:	00002097          	auipc	ra,0x2
    3a38:	e90080e7          	jalr	-368(ra) # 58c4 <chdir>
    3a3c:	e94d                	bnez	a0,3aee <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3a3e:	00004517          	auipc	a0,0x4
    3a42:	f3a50513          	addi	a0,a0,-198 # 7978 <malloc+0x1ce6>
    3a46:	00002097          	auipc	ra,0x2
    3a4a:	e5e080e7          	jalr	-418(ra) # 58a4 <unlink>
    3a4e:	cd55                	beqz	a0,3b0a <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3a50:	00004517          	auipc	a0,0x4
    3a54:	f5050513          	addi	a0,a0,-176 # 79a0 <malloc+0x1d0e>
    3a58:	00002097          	auipc	ra,0x2
    3a5c:	e4c080e7          	jalr	-436(ra) # 58a4 <unlink>
    3a60:	c179                	beqz	a0,3b26 <rmdot+0x14e>
  if(unlink("dots") != 0){
    3a62:	00004517          	auipc	a0,0x4
    3a66:	eae50513          	addi	a0,a0,-338 # 7910 <malloc+0x1c7e>
    3a6a:	00002097          	auipc	ra,0x2
    3a6e:	e3a080e7          	jalr	-454(ra) # 58a4 <unlink>
    3a72:	e961                	bnez	a0,3b42 <rmdot+0x16a>
}
    3a74:	60e2                	ld	ra,24(sp)
    3a76:	6442                	ld	s0,16(sp)
    3a78:	64a2                	ld	s1,8(sp)
    3a7a:	6105                	addi	sp,sp,32
    3a7c:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3a7e:	85a6                	mv	a1,s1
    3a80:	00004517          	auipc	a0,0x4
    3a84:	e9850513          	addi	a0,a0,-360 # 7918 <malloc+0x1c86>
    3a88:	00002097          	auipc	ra,0x2
    3a8c:	14c080e7          	jalr	332(ra) # 5bd4 <printf>
    exit(1);
    3a90:	4505                	li	a0,1
    3a92:	00002097          	auipc	ra,0x2
    3a96:	dc2080e7          	jalr	-574(ra) # 5854 <exit>
    printf("%s: chdir dots failed\n", s);
    3a9a:	85a6                	mv	a1,s1
    3a9c:	00004517          	auipc	a0,0x4
    3aa0:	e9450513          	addi	a0,a0,-364 # 7930 <malloc+0x1c9e>
    3aa4:	00002097          	auipc	ra,0x2
    3aa8:	130080e7          	jalr	304(ra) # 5bd4 <printf>
    exit(1);
    3aac:	4505                	li	a0,1
    3aae:	00002097          	auipc	ra,0x2
    3ab2:	da6080e7          	jalr	-602(ra) # 5854 <exit>
    printf("%s: rm . worked!\n", s);
    3ab6:	85a6                	mv	a1,s1
    3ab8:	00004517          	auipc	a0,0x4
    3abc:	e9050513          	addi	a0,a0,-368 # 7948 <malloc+0x1cb6>
    3ac0:	00002097          	auipc	ra,0x2
    3ac4:	114080e7          	jalr	276(ra) # 5bd4 <printf>
    exit(1);
    3ac8:	4505                	li	a0,1
    3aca:	00002097          	auipc	ra,0x2
    3ace:	d8a080e7          	jalr	-630(ra) # 5854 <exit>
    printf("%s: rm .. worked!\n", s);
    3ad2:	85a6                	mv	a1,s1
    3ad4:	00004517          	auipc	a0,0x4
    3ad8:	e8c50513          	addi	a0,a0,-372 # 7960 <malloc+0x1cce>
    3adc:	00002097          	auipc	ra,0x2
    3ae0:	0f8080e7          	jalr	248(ra) # 5bd4 <printf>
    exit(1);
    3ae4:	4505                	li	a0,1
    3ae6:	00002097          	auipc	ra,0x2
    3aea:	d6e080e7          	jalr	-658(ra) # 5854 <exit>
    printf("%s: chdir / failed\n", s);
    3aee:	85a6                	mv	a1,s1
    3af0:	00004517          	auipc	a0,0x4
    3af4:	82850513          	addi	a0,a0,-2008 # 7318 <malloc+0x1686>
    3af8:	00002097          	auipc	ra,0x2
    3afc:	0dc080e7          	jalr	220(ra) # 5bd4 <printf>
    exit(1);
    3b00:	4505                	li	a0,1
    3b02:	00002097          	auipc	ra,0x2
    3b06:	d52080e7          	jalr	-686(ra) # 5854 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3b0a:	85a6                	mv	a1,s1
    3b0c:	00004517          	auipc	a0,0x4
    3b10:	e7450513          	addi	a0,a0,-396 # 7980 <malloc+0x1cee>
    3b14:	00002097          	auipc	ra,0x2
    3b18:	0c0080e7          	jalr	192(ra) # 5bd4 <printf>
    exit(1);
    3b1c:	4505                	li	a0,1
    3b1e:	00002097          	auipc	ra,0x2
    3b22:	d36080e7          	jalr	-714(ra) # 5854 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3b26:	85a6                	mv	a1,s1
    3b28:	00004517          	auipc	a0,0x4
    3b2c:	e8050513          	addi	a0,a0,-384 # 79a8 <malloc+0x1d16>
    3b30:	00002097          	auipc	ra,0x2
    3b34:	0a4080e7          	jalr	164(ra) # 5bd4 <printf>
    exit(1);
    3b38:	4505                	li	a0,1
    3b3a:	00002097          	auipc	ra,0x2
    3b3e:	d1a080e7          	jalr	-742(ra) # 5854 <exit>
    printf("%s: unlink dots failed!\n", s);
    3b42:	85a6                	mv	a1,s1
    3b44:	00004517          	auipc	a0,0x4
    3b48:	e8450513          	addi	a0,a0,-380 # 79c8 <malloc+0x1d36>
    3b4c:	00002097          	auipc	ra,0x2
    3b50:	088080e7          	jalr	136(ra) # 5bd4 <printf>
    exit(1);
    3b54:	4505                	li	a0,1
    3b56:	00002097          	auipc	ra,0x2
    3b5a:	cfe080e7          	jalr	-770(ra) # 5854 <exit>

0000000000003b5e <dirfile>:
{
    3b5e:	1101                	addi	sp,sp,-32
    3b60:	ec06                	sd	ra,24(sp)
    3b62:	e822                	sd	s0,16(sp)
    3b64:	e426                	sd	s1,8(sp)
    3b66:	e04a                	sd	s2,0(sp)
    3b68:	1000                	addi	s0,sp,32
    3b6a:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3b6c:	20000593          	li	a1,512
    3b70:	00002517          	auipc	a0,0x2
    3b74:	54050513          	addi	a0,a0,1344 # 60b0 <malloc+0x41e>
    3b78:	00002097          	auipc	ra,0x2
    3b7c:	d1c080e7          	jalr	-740(ra) # 5894 <open>
  if(fd < 0){
    3b80:	0e054d63          	bltz	a0,3c7a <dirfile+0x11c>
  close(fd);
    3b84:	00002097          	auipc	ra,0x2
    3b88:	cf8080e7          	jalr	-776(ra) # 587c <close>
  if(chdir("dirfile") == 0){
    3b8c:	00002517          	auipc	a0,0x2
    3b90:	52450513          	addi	a0,a0,1316 # 60b0 <malloc+0x41e>
    3b94:	00002097          	auipc	ra,0x2
    3b98:	d30080e7          	jalr	-720(ra) # 58c4 <chdir>
    3b9c:	cd6d                	beqz	a0,3c96 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3b9e:	4581                	li	a1,0
    3ba0:	00004517          	auipc	a0,0x4
    3ba4:	e8850513          	addi	a0,a0,-376 # 7a28 <malloc+0x1d96>
    3ba8:	00002097          	auipc	ra,0x2
    3bac:	cec080e7          	jalr	-788(ra) # 5894 <open>
  if(fd >= 0){
    3bb0:	10055163          	bgez	a0,3cb2 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3bb4:	20000593          	li	a1,512
    3bb8:	00004517          	auipc	a0,0x4
    3bbc:	e7050513          	addi	a0,a0,-400 # 7a28 <malloc+0x1d96>
    3bc0:	00002097          	auipc	ra,0x2
    3bc4:	cd4080e7          	jalr	-812(ra) # 5894 <open>
  if(fd >= 0){
    3bc8:	10055363          	bgez	a0,3cce <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3bcc:	00004517          	auipc	a0,0x4
    3bd0:	e5c50513          	addi	a0,a0,-420 # 7a28 <malloc+0x1d96>
    3bd4:	00002097          	auipc	ra,0x2
    3bd8:	ce8080e7          	jalr	-792(ra) # 58bc <mkdir>
    3bdc:	10050763          	beqz	a0,3cea <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3be0:	00004517          	auipc	a0,0x4
    3be4:	e4850513          	addi	a0,a0,-440 # 7a28 <malloc+0x1d96>
    3be8:	00002097          	auipc	ra,0x2
    3bec:	cbc080e7          	jalr	-836(ra) # 58a4 <unlink>
    3bf0:	10050b63          	beqz	a0,3d06 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3bf4:	00004597          	auipc	a1,0x4
    3bf8:	e3458593          	addi	a1,a1,-460 # 7a28 <malloc+0x1d96>
    3bfc:	00002517          	auipc	a0,0x2
    3c00:	6ac50513          	addi	a0,a0,1708 # 62a8 <malloc+0x616>
    3c04:	00002097          	auipc	ra,0x2
    3c08:	cb0080e7          	jalr	-848(ra) # 58b4 <link>
    3c0c:	10050b63          	beqz	a0,3d22 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3c10:	00002517          	auipc	a0,0x2
    3c14:	4a050513          	addi	a0,a0,1184 # 60b0 <malloc+0x41e>
    3c18:	00002097          	auipc	ra,0x2
    3c1c:	c8c080e7          	jalr	-884(ra) # 58a4 <unlink>
    3c20:	10051f63          	bnez	a0,3d3e <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3c24:	4589                	li	a1,2
    3c26:	00003517          	auipc	a0,0x3
    3c2a:	b8250513          	addi	a0,a0,-1150 # 67a8 <malloc+0xb16>
    3c2e:	00002097          	auipc	ra,0x2
    3c32:	c66080e7          	jalr	-922(ra) # 5894 <open>
  if(fd >= 0){
    3c36:	12055263          	bgez	a0,3d5a <dirfile+0x1fc>
  fd = open(".", 0);
    3c3a:	4581                	li	a1,0
    3c3c:	00003517          	auipc	a0,0x3
    3c40:	b6c50513          	addi	a0,a0,-1172 # 67a8 <malloc+0xb16>
    3c44:	00002097          	auipc	ra,0x2
    3c48:	c50080e7          	jalr	-944(ra) # 5894 <open>
    3c4c:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3c4e:	4605                	li	a2,1
    3c50:	00002597          	auipc	a1,0x2
    3c54:	53058593          	addi	a1,a1,1328 # 6180 <malloc+0x4ee>
    3c58:	00002097          	auipc	ra,0x2
    3c5c:	c1c080e7          	jalr	-996(ra) # 5874 <write>
    3c60:	10a04b63          	bgtz	a0,3d76 <dirfile+0x218>
  close(fd);
    3c64:	8526                	mv	a0,s1
    3c66:	00002097          	auipc	ra,0x2
    3c6a:	c16080e7          	jalr	-1002(ra) # 587c <close>
}
    3c6e:	60e2                	ld	ra,24(sp)
    3c70:	6442                	ld	s0,16(sp)
    3c72:	64a2                	ld	s1,8(sp)
    3c74:	6902                	ld	s2,0(sp)
    3c76:	6105                	addi	sp,sp,32
    3c78:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3c7a:	85ca                	mv	a1,s2
    3c7c:	00004517          	auipc	a0,0x4
    3c80:	d6c50513          	addi	a0,a0,-660 # 79e8 <malloc+0x1d56>
    3c84:	00002097          	auipc	ra,0x2
    3c88:	f50080e7          	jalr	-176(ra) # 5bd4 <printf>
    exit(1);
    3c8c:	4505                	li	a0,1
    3c8e:	00002097          	auipc	ra,0x2
    3c92:	bc6080e7          	jalr	-1082(ra) # 5854 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3c96:	85ca                	mv	a1,s2
    3c98:	00004517          	auipc	a0,0x4
    3c9c:	d7050513          	addi	a0,a0,-656 # 7a08 <malloc+0x1d76>
    3ca0:	00002097          	auipc	ra,0x2
    3ca4:	f34080e7          	jalr	-204(ra) # 5bd4 <printf>
    exit(1);
    3ca8:	4505                	li	a0,1
    3caa:	00002097          	auipc	ra,0x2
    3cae:	baa080e7          	jalr	-1110(ra) # 5854 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3cb2:	85ca                	mv	a1,s2
    3cb4:	00004517          	auipc	a0,0x4
    3cb8:	d8450513          	addi	a0,a0,-636 # 7a38 <malloc+0x1da6>
    3cbc:	00002097          	auipc	ra,0x2
    3cc0:	f18080e7          	jalr	-232(ra) # 5bd4 <printf>
    exit(1);
    3cc4:	4505                	li	a0,1
    3cc6:	00002097          	auipc	ra,0x2
    3cca:	b8e080e7          	jalr	-1138(ra) # 5854 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3cce:	85ca                	mv	a1,s2
    3cd0:	00004517          	auipc	a0,0x4
    3cd4:	d6850513          	addi	a0,a0,-664 # 7a38 <malloc+0x1da6>
    3cd8:	00002097          	auipc	ra,0x2
    3cdc:	efc080e7          	jalr	-260(ra) # 5bd4 <printf>
    exit(1);
    3ce0:	4505                	li	a0,1
    3ce2:	00002097          	auipc	ra,0x2
    3ce6:	b72080e7          	jalr	-1166(ra) # 5854 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3cea:	85ca                	mv	a1,s2
    3cec:	00004517          	auipc	a0,0x4
    3cf0:	d7450513          	addi	a0,a0,-652 # 7a60 <malloc+0x1dce>
    3cf4:	00002097          	auipc	ra,0x2
    3cf8:	ee0080e7          	jalr	-288(ra) # 5bd4 <printf>
    exit(1);
    3cfc:	4505                	li	a0,1
    3cfe:	00002097          	auipc	ra,0x2
    3d02:	b56080e7          	jalr	-1194(ra) # 5854 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3d06:	85ca                	mv	a1,s2
    3d08:	00004517          	auipc	a0,0x4
    3d0c:	d8050513          	addi	a0,a0,-640 # 7a88 <malloc+0x1df6>
    3d10:	00002097          	auipc	ra,0x2
    3d14:	ec4080e7          	jalr	-316(ra) # 5bd4 <printf>
    exit(1);
    3d18:	4505                	li	a0,1
    3d1a:	00002097          	auipc	ra,0x2
    3d1e:	b3a080e7          	jalr	-1222(ra) # 5854 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3d22:	85ca                	mv	a1,s2
    3d24:	00004517          	auipc	a0,0x4
    3d28:	d8c50513          	addi	a0,a0,-628 # 7ab0 <malloc+0x1e1e>
    3d2c:	00002097          	auipc	ra,0x2
    3d30:	ea8080e7          	jalr	-344(ra) # 5bd4 <printf>
    exit(1);
    3d34:	4505                	li	a0,1
    3d36:	00002097          	auipc	ra,0x2
    3d3a:	b1e080e7          	jalr	-1250(ra) # 5854 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3d3e:	85ca                	mv	a1,s2
    3d40:	00004517          	auipc	a0,0x4
    3d44:	d9850513          	addi	a0,a0,-616 # 7ad8 <malloc+0x1e46>
    3d48:	00002097          	auipc	ra,0x2
    3d4c:	e8c080e7          	jalr	-372(ra) # 5bd4 <printf>
    exit(1);
    3d50:	4505                	li	a0,1
    3d52:	00002097          	auipc	ra,0x2
    3d56:	b02080e7          	jalr	-1278(ra) # 5854 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3d5a:	85ca                	mv	a1,s2
    3d5c:	00004517          	auipc	a0,0x4
    3d60:	d9c50513          	addi	a0,a0,-612 # 7af8 <malloc+0x1e66>
    3d64:	00002097          	auipc	ra,0x2
    3d68:	e70080e7          	jalr	-400(ra) # 5bd4 <printf>
    exit(1);
    3d6c:	4505                	li	a0,1
    3d6e:	00002097          	auipc	ra,0x2
    3d72:	ae6080e7          	jalr	-1306(ra) # 5854 <exit>
    printf("%s: write . succeeded!\n", s);
    3d76:	85ca                	mv	a1,s2
    3d78:	00004517          	auipc	a0,0x4
    3d7c:	da850513          	addi	a0,a0,-600 # 7b20 <malloc+0x1e8e>
    3d80:	00002097          	auipc	ra,0x2
    3d84:	e54080e7          	jalr	-428(ra) # 5bd4 <printf>
    exit(1);
    3d88:	4505                	li	a0,1
    3d8a:	00002097          	auipc	ra,0x2
    3d8e:	aca080e7          	jalr	-1334(ra) # 5854 <exit>

0000000000003d92 <iref>:
{
    3d92:	7139                	addi	sp,sp,-64
    3d94:	fc06                	sd	ra,56(sp)
    3d96:	f822                	sd	s0,48(sp)
    3d98:	f426                	sd	s1,40(sp)
    3d9a:	f04a                	sd	s2,32(sp)
    3d9c:	ec4e                	sd	s3,24(sp)
    3d9e:	e852                	sd	s4,16(sp)
    3da0:	e456                	sd	s5,8(sp)
    3da2:	e05a                	sd	s6,0(sp)
    3da4:	0080                	addi	s0,sp,64
    3da6:	8b2a                	mv	s6,a0
    3da8:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3dac:	00004a17          	auipc	s4,0x4
    3db0:	d8ca0a13          	addi	s4,s4,-628 # 7b38 <malloc+0x1ea6>
    mkdir("");
    3db4:	00004497          	auipc	s1,0x4
    3db8:	89448493          	addi	s1,s1,-1900 # 7648 <malloc+0x19b6>
    link("README", "");
    3dbc:	00002a97          	auipc	s5,0x2
    3dc0:	4eca8a93          	addi	s5,s5,1260 # 62a8 <malloc+0x616>
    fd = open("xx", O_CREATE);
    3dc4:	00004997          	auipc	s3,0x4
    3dc8:	c6c98993          	addi	s3,s3,-916 # 7a30 <malloc+0x1d9e>
    3dcc:	a891                	j	3e20 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3dce:	85da                	mv	a1,s6
    3dd0:	00004517          	auipc	a0,0x4
    3dd4:	d7050513          	addi	a0,a0,-656 # 7b40 <malloc+0x1eae>
    3dd8:	00002097          	auipc	ra,0x2
    3ddc:	dfc080e7          	jalr	-516(ra) # 5bd4 <printf>
      exit(1);
    3de0:	4505                	li	a0,1
    3de2:	00002097          	auipc	ra,0x2
    3de6:	a72080e7          	jalr	-1422(ra) # 5854 <exit>
      printf("%s: chdir irefd failed\n", s);
    3dea:	85da                	mv	a1,s6
    3dec:	00004517          	auipc	a0,0x4
    3df0:	d6c50513          	addi	a0,a0,-660 # 7b58 <malloc+0x1ec6>
    3df4:	00002097          	auipc	ra,0x2
    3df8:	de0080e7          	jalr	-544(ra) # 5bd4 <printf>
      exit(1);
    3dfc:	4505                	li	a0,1
    3dfe:	00002097          	auipc	ra,0x2
    3e02:	a56080e7          	jalr	-1450(ra) # 5854 <exit>
      close(fd);
    3e06:	00002097          	auipc	ra,0x2
    3e0a:	a76080e7          	jalr	-1418(ra) # 587c <close>
    3e0e:	a889                	j	3e60 <iref+0xce>
    unlink("xx");
    3e10:	854e                	mv	a0,s3
    3e12:	00002097          	auipc	ra,0x2
    3e16:	a92080e7          	jalr	-1390(ra) # 58a4 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3e1a:	397d                	addiw	s2,s2,-1
    3e1c:	06090063          	beqz	s2,3e7c <iref+0xea>
    if(mkdir("irefd") != 0){
    3e20:	8552                	mv	a0,s4
    3e22:	00002097          	auipc	ra,0x2
    3e26:	a9a080e7          	jalr	-1382(ra) # 58bc <mkdir>
    3e2a:	f155                	bnez	a0,3dce <iref+0x3c>
    if(chdir("irefd") != 0){
    3e2c:	8552                	mv	a0,s4
    3e2e:	00002097          	auipc	ra,0x2
    3e32:	a96080e7          	jalr	-1386(ra) # 58c4 <chdir>
    3e36:	f955                	bnez	a0,3dea <iref+0x58>
    mkdir("");
    3e38:	8526                	mv	a0,s1
    3e3a:	00002097          	auipc	ra,0x2
    3e3e:	a82080e7          	jalr	-1406(ra) # 58bc <mkdir>
    link("README", "");
    3e42:	85a6                	mv	a1,s1
    3e44:	8556                	mv	a0,s5
    3e46:	00002097          	auipc	ra,0x2
    3e4a:	a6e080e7          	jalr	-1426(ra) # 58b4 <link>
    fd = open("", O_CREATE);
    3e4e:	20000593          	li	a1,512
    3e52:	8526                	mv	a0,s1
    3e54:	00002097          	auipc	ra,0x2
    3e58:	a40080e7          	jalr	-1472(ra) # 5894 <open>
    if(fd >= 0)
    3e5c:	fa0555e3          	bgez	a0,3e06 <iref+0x74>
    fd = open("xx", O_CREATE);
    3e60:	20000593          	li	a1,512
    3e64:	854e                	mv	a0,s3
    3e66:	00002097          	auipc	ra,0x2
    3e6a:	a2e080e7          	jalr	-1490(ra) # 5894 <open>
    if(fd >= 0)
    3e6e:	fa0541e3          	bltz	a0,3e10 <iref+0x7e>
      close(fd);
    3e72:	00002097          	auipc	ra,0x2
    3e76:	a0a080e7          	jalr	-1526(ra) # 587c <close>
    3e7a:	bf59                	j	3e10 <iref+0x7e>
    3e7c:	03300493          	li	s1,51
    chdir("..");
    3e80:	00003997          	auipc	s3,0x3
    3e84:	4e898993          	addi	s3,s3,1256 # 7368 <malloc+0x16d6>
    unlink("irefd");
    3e88:	00004917          	auipc	s2,0x4
    3e8c:	cb090913          	addi	s2,s2,-848 # 7b38 <malloc+0x1ea6>
    chdir("..");
    3e90:	854e                	mv	a0,s3
    3e92:	00002097          	auipc	ra,0x2
    3e96:	a32080e7          	jalr	-1486(ra) # 58c4 <chdir>
    unlink("irefd");
    3e9a:	854a                	mv	a0,s2
    3e9c:	00002097          	auipc	ra,0x2
    3ea0:	a08080e7          	jalr	-1528(ra) # 58a4 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3ea4:	34fd                	addiw	s1,s1,-1
    3ea6:	f4ed                	bnez	s1,3e90 <iref+0xfe>
  chdir("/");
    3ea8:	00003517          	auipc	a0,0x3
    3eac:	46850513          	addi	a0,a0,1128 # 7310 <malloc+0x167e>
    3eb0:	00002097          	auipc	ra,0x2
    3eb4:	a14080e7          	jalr	-1516(ra) # 58c4 <chdir>
}
    3eb8:	70e2                	ld	ra,56(sp)
    3eba:	7442                	ld	s0,48(sp)
    3ebc:	74a2                	ld	s1,40(sp)
    3ebe:	7902                	ld	s2,32(sp)
    3ec0:	69e2                	ld	s3,24(sp)
    3ec2:	6a42                	ld	s4,16(sp)
    3ec4:	6aa2                	ld	s5,8(sp)
    3ec6:	6b02                	ld	s6,0(sp)
    3ec8:	6121                	addi	sp,sp,64
    3eca:	8082                	ret

0000000000003ecc <openiputtest>:
{
    3ecc:	7179                	addi	sp,sp,-48
    3ece:	f406                	sd	ra,40(sp)
    3ed0:	f022                	sd	s0,32(sp)
    3ed2:	ec26                	sd	s1,24(sp)
    3ed4:	1800                	addi	s0,sp,48
    3ed6:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3ed8:	00004517          	auipc	a0,0x4
    3edc:	c9850513          	addi	a0,a0,-872 # 7b70 <malloc+0x1ede>
    3ee0:	00002097          	auipc	ra,0x2
    3ee4:	9dc080e7          	jalr	-1572(ra) # 58bc <mkdir>
    3ee8:	04054263          	bltz	a0,3f2c <openiputtest+0x60>
  pid = fork();
    3eec:	00002097          	auipc	ra,0x2
    3ef0:	960080e7          	jalr	-1696(ra) # 584c <fork>
  if(pid < 0){
    3ef4:	04054a63          	bltz	a0,3f48 <openiputtest+0x7c>
  if(pid == 0){
    3ef8:	e93d                	bnez	a0,3f6e <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3efa:	4589                	li	a1,2
    3efc:	00004517          	auipc	a0,0x4
    3f00:	c7450513          	addi	a0,a0,-908 # 7b70 <malloc+0x1ede>
    3f04:	00002097          	auipc	ra,0x2
    3f08:	990080e7          	jalr	-1648(ra) # 5894 <open>
    if(fd >= 0){
    3f0c:	04054c63          	bltz	a0,3f64 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3f10:	85a6                	mv	a1,s1
    3f12:	00004517          	auipc	a0,0x4
    3f16:	c7e50513          	addi	a0,a0,-898 # 7b90 <malloc+0x1efe>
    3f1a:	00002097          	auipc	ra,0x2
    3f1e:	cba080e7          	jalr	-838(ra) # 5bd4 <printf>
      exit(1);
    3f22:	4505                	li	a0,1
    3f24:	00002097          	auipc	ra,0x2
    3f28:	930080e7          	jalr	-1744(ra) # 5854 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3f2c:	85a6                	mv	a1,s1
    3f2e:	00004517          	auipc	a0,0x4
    3f32:	c4a50513          	addi	a0,a0,-950 # 7b78 <malloc+0x1ee6>
    3f36:	00002097          	auipc	ra,0x2
    3f3a:	c9e080e7          	jalr	-866(ra) # 5bd4 <printf>
    exit(1);
    3f3e:	4505                	li	a0,1
    3f40:	00002097          	auipc	ra,0x2
    3f44:	914080e7          	jalr	-1772(ra) # 5854 <exit>
    printf("%s: fork failed\n", s);
    3f48:	85a6                	mv	a1,s1
    3f4a:	00003517          	auipc	a0,0x3
    3f4e:	9fe50513          	addi	a0,a0,-1538 # 6948 <malloc+0xcb6>
    3f52:	00002097          	auipc	ra,0x2
    3f56:	c82080e7          	jalr	-894(ra) # 5bd4 <printf>
    exit(1);
    3f5a:	4505                	li	a0,1
    3f5c:	00002097          	auipc	ra,0x2
    3f60:	8f8080e7          	jalr	-1800(ra) # 5854 <exit>
    exit(0);
    3f64:	4501                	li	a0,0
    3f66:	00002097          	auipc	ra,0x2
    3f6a:	8ee080e7          	jalr	-1810(ra) # 5854 <exit>
  sleep(1);
    3f6e:	4505                	li	a0,1
    3f70:	00002097          	auipc	ra,0x2
    3f74:	974080e7          	jalr	-1676(ra) # 58e4 <sleep>
  if(unlink("oidir") != 0){
    3f78:	00004517          	auipc	a0,0x4
    3f7c:	bf850513          	addi	a0,a0,-1032 # 7b70 <malloc+0x1ede>
    3f80:	00002097          	auipc	ra,0x2
    3f84:	924080e7          	jalr	-1756(ra) # 58a4 <unlink>
    3f88:	cd19                	beqz	a0,3fa6 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3f8a:	85a6                	mv	a1,s1
    3f8c:	00003517          	auipc	a0,0x3
    3f90:	bac50513          	addi	a0,a0,-1108 # 6b38 <malloc+0xea6>
    3f94:	00002097          	auipc	ra,0x2
    3f98:	c40080e7          	jalr	-960(ra) # 5bd4 <printf>
    exit(1);
    3f9c:	4505                	li	a0,1
    3f9e:	00002097          	auipc	ra,0x2
    3fa2:	8b6080e7          	jalr	-1866(ra) # 5854 <exit>
  wait(&xstatus);
    3fa6:	fdc40513          	addi	a0,s0,-36
    3faa:	00002097          	auipc	ra,0x2
    3fae:	8b2080e7          	jalr	-1870(ra) # 585c <wait>
  exit(xstatus);
    3fb2:	fdc42503          	lw	a0,-36(s0)
    3fb6:	00002097          	auipc	ra,0x2
    3fba:	89e080e7          	jalr	-1890(ra) # 5854 <exit>

0000000000003fbe <forkforkfork>:
{
    3fbe:	1101                	addi	sp,sp,-32
    3fc0:	ec06                	sd	ra,24(sp)
    3fc2:	e822                	sd	s0,16(sp)
    3fc4:	e426                	sd	s1,8(sp)
    3fc6:	1000                	addi	s0,sp,32
    3fc8:	84aa                	mv	s1,a0
  unlink("stopforking");
    3fca:	00004517          	auipc	a0,0x4
    3fce:	bee50513          	addi	a0,a0,-1042 # 7bb8 <malloc+0x1f26>
    3fd2:	00002097          	auipc	ra,0x2
    3fd6:	8d2080e7          	jalr	-1838(ra) # 58a4 <unlink>
  int pid = fork();
    3fda:	00002097          	auipc	ra,0x2
    3fde:	872080e7          	jalr	-1934(ra) # 584c <fork>
  if(pid < 0){
    3fe2:	04054563          	bltz	a0,402c <forkforkfork+0x6e>
  if(pid == 0){
    3fe6:	c12d                	beqz	a0,4048 <forkforkfork+0x8a>
  sleep(20); // two seconds
    3fe8:	4551                	li	a0,20
    3fea:	00002097          	auipc	ra,0x2
    3fee:	8fa080e7          	jalr	-1798(ra) # 58e4 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3ff2:	20200593          	li	a1,514
    3ff6:	00004517          	auipc	a0,0x4
    3ffa:	bc250513          	addi	a0,a0,-1086 # 7bb8 <malloc+0x1f26>
    3ffe:	00002097          	auipc	ra,0x2
    4002:	896080e7          	jalr	-1898(ra) # 5894 <open>
    4006:	00002097          	auipc	ra,0x2
    400a:	876080e7          	jalr	-1930(ra) # 587c <close>
  wait(0);
    400e:	4501                	li	a0,0
    4010:	00002097          	auipc	ra,0x2
    4014:	84c080e7          	jalr	-1972(ra) # 585c <wait>
  sleep(10); // one second
    4018:	4529                	li	a0,10
    401a:	00002097          	auipc	ra,0x2
    401e:	8ca080e7          	jalr	-1846(ra) # 58e4 <sleep>
}
    4022:	60e2                	ld	ra,24(sp)
    4024:	6442                	ld	s0,16(sp)
    4026:	64a2                	ld	s1,8(sp)
    4028:	6105                	addi	sp,sp,32
    402a:	8082                	ret
    printf("%s: fork failed", s);
    402c:	85a6                	mv	a1,s1
    402e:	00003517          	auipc	a0,0x3
    4032:	ada50513          	addi	a0,a0,-1318 # 6b08 <malloc+0xe76>
    4036:	00002097          	auipc	ra,0x2
    403a:	b9e080e7          	jalr	-1122(ra) # 5bd4 <printf>
    exit(1);
    403e:	4505                	li	a0,1
    4040:	00002097          	auipc	ra,0x2
    4044:	814080e7          	jalr	-2028(ra) # 5854 <exit>
      int fd = open("stopforking", 0);
    4048:	00004497          	auipc	s1,0x4
    404c:	b7048493          	addi	s1,s1,-1168 # 7bb8 <malloc+0x1f26>
    4050:	4581                	li	a1,0
    4052:	8526                	mv	a0,s1
    4054:	00002097          	auipc	ra,0x2
    4058:	840080e7          	jalr	-1984(ra) # 5894 <open>
      if(fd >= 0){
    405c:	02055463          	bgez	a0,4084 <forkforkfork+0xc6>
      if(fork() < 0){
    4060:	00001097          	auipc	ra,0x1
    4064:	7ec080e7          	jalr	2028(ra) # 584c <fork>
    4068:	fe0554e3          	bgez	a0,4050 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    406c:	20200593          	li	a1,514
    4070:	8526                	mv	a0,s1
    4072:	00002097          	auipc	ra,0x2
    4076:	822080e7          	jalr	-2014(ra) # 5894 <open>
    407a:	00002097          	auipc	ra,0x2
    407e:	802080e7          	jalr	-2046(ra) # 587c <close>
    4082:	b7f9                	j	4050 <forkforkfork+0x92>
        exit(0);
    4084:	4501                	li	a0,0
    4086:	00001097          	auipc	ra,0x1
    408a:	7ce080e7          	jalr	1998(ra) # 5854 <exit>

000000000000408e <killstatus>:
{
    408e:	7139                	addi	sp,sp,-64
    4090:	fc06                	sd	ra,56(sp)
    4092:	f822                	sd	s0,48(sp)
    4094:	f426                	sd	s1,40(sp)
    4096:	f04a                	sd	s2,32(sp)
    4098:	ec4e                	sd	s3,24(sp)
    409a:	e852                	sd	s4,16(sp)
    409c:	0080                	addi	s0,sp,64
    409e:	8a2a                	mv	s4,a0
    40a0:	06400913          	li	s2,100
    if(xst != -1) {
    40a4:	59fd                	li	s3,-1
    int pid1 = fork();
    40a6:	00001097          	auipc	ra,0x1
    40aa:	7a6080e7          	jalr	1958(ra) # 584c <fork>
    40ae:	84aa                	mv	s1,a0
    if(pid1 < 0){
    40b0:	02054f63          	bltz	a0,40ee <killstatus+0x60>
    if(pid1 == 0){
    40b4:	c939                	beqz	a0,410a <killstatus+0x7c>
    sleep(1);
    40b6:	4505                	li	a0,1
    40b8:	00002097          	auipc	ra,0x2
    40bc:	82c080e7          	jalr	-2004(ra) # 58e4 <sleep>
    kill(pid1);
    40c0:	8526                	mv	a0,s1
    40c2:	00001097          	auipc	ra,0x1
    40c6:	7c2080e7          	jalr	1986(ra) # 5884 <kill>
    wait(&xst);
    40ca:	fcc40513          	addi	a0,s0,-52
    40ce:	00001097          	auipc	ra,0x1
    40d2:	78e080e7          	jalr	1934(ra) # 585c <wait>
    if(xst != -1) {
    40d6:	fcc42783          	lw	a5,-52(s0)
    40da:	03379d63          	bne	a5,s3,4114 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    40de:	397d                	addiw	s2,s2,-1
    40e0:	fc0913e3          	bnez	s2,40a6 <killstatus+0x18>
  exit(0);
    40e4:	4501                	li	a0,0
    40e6:	00001097          	auipc	ra,0x1
    40ea:	76e080e7          	jalr	1902(ra) # 5854 <exit>
      printf("%s: fork failed\n", s);
    40ee:	85d2                	mv	a1,s4
    40f0:	00003517          	auipc	a0,0x3
    40f4:	85850513          	addi	a0,a0,-1960 # 6948 <malloc+0xcb6>
    40f8:	00002097          	auipc	ra,0x2
    40fc:	adc080e7          	jalr	-1316(ra) # 5bd4 <printf>
      exit(1);
    4100:	4505                	li	a0,1
    4102:	00001097          	auipc	ra,0x1
    4106:	752080e7          	jalr	1874(ra) # 5854 <exit>
        getpid();
    410a:	00001097          	auipc	ra,0x1
    410e:	7ca080e7          	jalr	1994(ra) # 58d4 <getpid>
      while(1) {
    4112:	bfe5                	j	410a <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    4114:	85d2                	mv	a1,s4
    4116:	00004517          	auipc	a0,0x4
    411a:	ab250513          	addi	a0,a0,-1358 # 7bc8 <malloc+0x1f36>
    411e:	00002097          	auipc	ra,0x2
    4122:	ab6080e7          	jalr	-1354(ra) # 5bd4 <printf>
       exit(1);
    4126:	4505                	li	a0,1
    4128:	00001097          	auipc	ra,0x1
    412c:	72c080e7          	jalr	1836(ra) # 5854 <exit>

0000000000004130 <preempt>:
{
    4130:	7139                	addi	sp,sp,-64
    4132:	fc06                	sd	ra,56(sp)
    4134:	f822                	sd	s0,48(sp)
    4136:	f426                	sd	s1,40(sp)
    4138:	f04a                	sd	s2,32(sp)
    413a:	ec4e                	sd	s3,24(sp)
    413c:	e852                	sd	s4,16(sp)
    413e:	0080                	addi	s0,sp,64
    4140:	84aa                	mv	s1,a0
  pid1 = fork();
    4142:	00001097          	auipc	ra,0x1
    4146:	70a080e7          	jalr	1802(ra) # 584c <fork>
  if(pid1 < 0) {
    414a:	00054563          	bltz	a0,4154 <preempt+0x24>
    414e:	8a2a                	mv	s4,a0
  if(pid1 == 0)
    4150:	e105                	bnez	a0,4170 <preempt+0x40>
    for(;;)
    4152:	a001                	j	4152 <preempt+0x22>
    printf("%s: fork failed", s);
    4154:	85a6                	mv	a1,s1
    4156:	00003517          	auipc	a0,0x3
    415a:	9b250513          	addi	a0,a0,-1614 # 6b08 <malloc+0xe76>
    415e:	00002097          	auipc	ra,0x2
    4162:	a76080e7          	jalr	-1418(ra) # 5bd4 <printf>
    exit(1);
    4166:	4505                	li	a0,1
    4168:	00001097          	auipc	ra,0x1
    416c:	6ec080e7          	jalr	1772(ra) # 5854 <exit>
  pid2 = fork();
    4170:	00001097          	auipc	ra,0x1
    4174:	6dc080e7          	jalr	1756(ra) # 584c <fork>
    4178:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    417a:	00054463          	bltz	a0,4182 <preempt+0x52>
  if(pid2 == 0)
    417e:	e105                	bnez	a0,419e <preempt+0x6e>
    for(;;)
    4180:	a001                	j	4180 <preempt+0x50>
    printf("%s: fork failed\n", s);
    4182:	85a6                	mv	a1,s1
    4184:	00002517          	auipc	a0,0x2
    4188:	7c450513          	addi	a0,a0,1988 # 6948 <malloc+0xcb6>
    418c:	00002097          	auipc	ra,0x2
    4190:	a48080e7          	jalr	-1464(ra) # 5bd4 <printf>
    exit(1);
    4194:	4505                	li	a0,1
    4196:	00001097          	auipc	ra,0x1
    419a:	6be080e7          	jalr	1726(ra) # 5854 <exit>
  pipe(pfds);
    419e:	fc840513          	addi	a0,s0,-56
    41a2:	00001097          	auipc	ra,0x1
    41a6:	6c2080e7          	jalr	1730(ra) # 5864 <pipe>
  pid3 = fork();
    41aa:	00001097          	auipc	ra,0x1
    41ae:	6a2080e7          	jalr	1698(ra) # 584c <fork>
    41b2:	892a                	mv	s2,a0
  if(pid3 < 0) {
    41b4:	02054e63          	bltz	a0,41f0 <preempt+0xc0>
  if(pid3 == 0){
    41b8:	e525                	bnez	a0,4220 <preempt+0xf0>
    close(pfds[0]);
    41ba:	fc842503          	lw	a0,-56(s0)
    41be:	00001097          	auipc	ra,0x1
    41c2:	6be080e7          	jalr	1726(ra) # 587c <close>
    if(write(pfds[1], "x", 1) != 1)
    41c6:	4605                	li	a2,1
    41c8:	00002597          	auipc	a1,0x2
    41cc:	fb858593          	addi	a1,a1,-72 # 6180 <malloc+0x4ee>
    41d0:	fcc42503          	lw	a0,-52(s0)
    41d4:	00001097          	auipc	ra,0x1
    41d8:	6a0080e7          	jalr	1696(ra) # 5874 <write>
    41dc:	4785                	li	a5,1
    41de:	02f51763          	bne	a0,a5,420c <preempt+0xdc>
    close(pfds[1]);
    41e2:	fcc42503          	lw	a0,-52(s0)
    41e6:	00001097          	auipc	ra,0x1
    41ea:	696080e7          	jalr	1686(ra) # 587c <close>
    for(;;)
    41ee:	a001                	j	41ee <preempt+0xbe>
     printf("%s: fork failed\n", s);
    41f0:	85a6                	mv	a1,s1
    41f2:	00002517          	auipc	a0,0x2
    41f6:	75650513          	addi	a0,a0,1878 # 6948 <malloc+0xcb6>
    41fa:	00002097          	auipc	ra,0x2
    41fe:	9da080e7          	jalr	-1574(ra) # 5bd4 <printf>
     exit(1);
    4202:	4505                	li	a0,1
    4204:	00001097          	auipc	ra,0x1
    4208:	650080e7          	jalr	1616(ra) # 5854 <exit>
      printf("%s: preempt write error", s);
    420c:	85a6                	mv	a1,s1
    420e:	00004517          	auipc	a0,0x4
    4212:	9da50513          	addi	a0,a0,-1574 # 7be8 <malloc+0x1f56>
    4216:	00002097          	auipc	ra,0x2
    421a:	9be080e7          	jalr	-1602(ra) # 5bd4 <printf>
    421e:	b7d1                	j	41e2 <preempt+0xb2>
  close(pfds[1]);
    4220:	fcc42503          	lw	a0,-52(s0)
    4224:	00001097          	auipc	ra,0x1
    4228:	658080e7          	jalr	1624(ra) # 587c <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    422c:	660d                	lui	a2,0x3
    422e:	00008597          	auipc	a1,0x8
    4232:	b6a58593          	addi	a1,a1,-1174 # bd98 <buf>
    4236:	fc842503          	lw	a0,-56(s0)
    423a:	00001097          	auipc	ra,0x1
    423e:	632080e7          	jalr	1586(ra) # 586c <read>
    4242:	4785                	li	a5,1
    4244:	02f50363          	beq	a0,a5,426a <preempt+0x13a>
    printf("%s: preempt read error", s);
    4248:	85a6                	mv	a1,s1
    424a:	00004517          	auipc	a0,0x4
    424e:	9b650513          	addi	a0,a0,-1610 # 7c00 <malloc+0x1f6e>
    4252:	00002097          	auipc	ra,0x2
    4256:	982080e7          	jalr	-1662(ra) # 5bd4 <printf>
}
    425a:	70e2                	ld	ra,56(sp)
    425c:	7442                	ld	s0,48(sp)
    425e:	74a2                	ld	s1,40(sp)
    4260:	7902                	ld	s2,32(sp)
    4262:	69e2                	ld	s3,24(sp)
    4264:	6a42                	ld	s4,16(sp)
    4266:	6121                	addi	sp,sp,64
    4268:	8082                	ret
  close(pfds[0]);
    426a:	fc842503          	lw	a0,-56(s0)
    426e:	00001097          	auipc	ra,0x1
    4272:	60e080e7          	jalr	1550(ra) # 587c <close>
  printf("kill... ");
    4276:	00004517          	auipc	a0,0x4
    427a:	9a250513          	addi	a0,a0,-1630 # 7c18 <malloc+0x1f86>
    427e:	00002097          	auipc	ra,0x2
    4282:	956080e7          	jalr	-1706(ra) # 5bd4 <printf>
  kill(pid1);
    4286:	8552                	mv	a0,s4
    4288:	00001097          	auipc	ra,0x1
    428c:	5fc080e7          	jalr	1532(ra) # 5884 <kill>
  kill(pid2);
    4290:	854e                	mv	a0,s3
    4292:	00001097          	auipc	ra,0x1
    4296:	5f2080e7          	jalr	1522(ra) # 5884 <kill>
  kill(pid3);
    429a:	854a                	mv	a0,s2
    429c:	00001097          	auipc	ra,0x1
    42a0:	5e8080e7          	jalr	1512(ra) # 5884 <kill>
  printf("wait... ");
    42a4:	00004517          	auipc	a0,0x4
    42a8:	98450513          	addi	a0,a0,-1660 # 7c28 <malloc+0x1f96>
    42ac:	00002097          	auipc	ra,0x2
    42b0:	928080e7          	jalr	-1752(ra) # 5bd4 <printf>
  wait(0);
    42b4:	4501                	li	a0,0
    42b6:	00001097          	auipc	ra,0x1
    42ba:	5a6080e7          	jalr	1446(ra) # 585c <wait>
  wait(0);
    42be:	4501                	li	a0,0
    42c0:	00001097          	auipc	ra,0x1
    42c4:	59c080e7          	jalr	1436(ra) # 585c <wait>
  wait(0);
    42c8:	4501                	li	a0,0
    42ca:	00001097          	auipc	ra,0x1
    42ce:	592080e7          	jalr	1426(ra) # 585c <wait>
    42d2:	b761                	j	425a <preempt+0x12a>

00000000000042d4 <reparent>:
{
    42d4:	7179                	addi	sp,sp,-48
    42d6:	f406                	sd	ra,40(sp)
    42d8:	f022                	sd	s0,32(sp)
    42da:	ec26                	sd	s1,24(sp)
    42dc:	e84a                	sd	s2,16(sp)
    42de:	e44e                	sd	s3,8(sp)
    42e0:	e052                	sd	s4,0(sp)
    42e2:	1800                	addi	s0,sp,48
    42e4:	89aa                	mv	s3,a0
  int master_pid = getpid();
    42e6:	00001097          	auipc	ra,0x1
    42ea:	5ee080e7          	jalr	1518(ra) # 58d4 <getpid>
    42ee:	8a2a                	mv	s4,a0
    42f0:	0c800913          	li	s2,200
    int pid = fork();
    42f4:	00001097          	auipc	ra,0x1
    42f8:	558080e7          	jalr	1368(ra) # 584c <fork>
    42fc:	84aa                	mv	s1,a0
    if(pid < 0){
    42fe:	02054263          	bltz	a0,4322 <reparent+0x4e>
    if(pid){
    4302:	cd21                	beqz	a0,435a <reparent+0x86>
      if(wait(0) != pid){
    4304:	4501                	li	a0,0
    4306:	00001097          	auipc	ra,0x1
    430a:	556080e7          	jalr	1366(ra) # 585c <wait>
    430e:	02951863          	bne	a0,s1,433e <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4312:	397d                	addiw	s2,s2,-1
    4314:	fe0910e3          	bnez	s2,42f4 <reparent+0x20>
  exit(0);
    4318:	4501                	li	a0,0
    431a:	00001097          	auipc	ra,0x1
    431e:	53a080e7          	jalr	1338(ra) # 5854 <exit>
      printf("%s: fork failed\n", s);
    4322:	85ce                	mv	a1,s3
    4324:	00002517          	auipc	a0,0x2
    4328:	62450513          	addi	a0,a0,1572 # 6948 <malloc+0xcb6>
    432c:	00002097          	auipc	ra,0x2
    4330:	8a8080e7          	jalr	-1880(ra) # 5bd4 <printf>
      exit(1);
    4334:	4505                	li	a0,1
    4336:	00001097          	auipc	ra,0x1
    433a:	51e080e7          	jalr	1310(ra) # 5854 <exit>
        printf("%s: wait wrong pid\n", s);
    433e:	85ce                	mv	a1,s3
    4340:	00002517          	auipc	a0,0x2
    4344:	79050513          	addi	a0,a0,1936 # 6ad0 <malloc+0xe3e>
    4348:	00002097          	auipc	ra,0x2
    434c:	88c080e7          	jalr	-1908(ra) # 5bd4 <printf>
        exit(1);
    4350:	4505                	li	a0,1
    4352:	00001097          	auipc	ra,0x1
    4356:	502080e7          	jalr	1282(ra) # 5854 <exit>
      int pid2 = fork();
    435a:	00001097          	auipc	ra,0x1
    435e:	4f2080e7          	jalr	1266(ra) # 584c <fork>
      if(pid2 < 0){
    4362:	00054763          	bltz	a0,4370 <reparent+0x9c>
      exit(0);
    4366:	4501                	li	a0,0
    4368:	00001097          	auipc	ra,0x1
    436c:	4ec080e7          	jalr	1260(ra) # 5854 <exit>
        kill(master_pid);
    4370:	8552                	mv	a0,s4
    4372:	00001097          	auipc	ra,0x1
    4376:	512080e7          	jalr	1298(ra) # 5884 <kill>
        exit(1);
    437a:	4505                	li	a0,1
    437c:	00001097          	auipc	ra,0x1
    4380:	4d8080e7          	jalr	1240(ra) # 5854 <exit>

0000000000004384 <sbrkfail>:
{
    4384:	7119                	addi	sp,sp,-128
    4386:	fc86                	sd	ra,120(sp)
    4388:	f8a2                	sd	s0,112(sp)
    438a:	f4a6                	sd	s1,104(sp)
    438c:	f0ca                	sd	s2,96(sp)
    438e:	ecce                	sd	s3,88(sp)
    4390:	e8d2                	sd	s4,80(sp)
    4392:	e4d6                	sd	s5,72(sp)
    4394:	0100                	addi	s0,sp,128
    4396:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    4398:	fb040513          	addi	a0,s0,-80
    439c:	00001097          	auipc	ra,0x1
    43a0:	4c8080e7          	jalr	1224(ra) # 5864 <pipe>
    43a4:	e901                	bnez	a0,43b4 <sbrkfail+0x30>
    43a6:	f8040493          	addi	s1,s0,-128
    43aa:	fa840a13          	addi	s4,s0,-88
    43ae:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    43b0:	5afd                	li	s5,-1
    43b2:	a08d                	j	4414 <sbrkfail+0x90>
    printf("%s: pipe() failed\n", s);
    43b4:	85ca                	mv	a1,s2
    43b6:	00002517          	auipc	a0,0x2
    43ba:	69a50513          	addi	a0,a0,1690 # 6a50 <malloc+0xdbe>
    43be:	00002097          	auipc	ra,0x2
    43c2:	816080e7          	jalr	-2026(ra) # 5bd4 <printf>
    exit(1);
    43c6:	4505                	li	a0,1
    43c8:	00001097          	auipc	ra,0x1
    43cc:	48c080e7          	jalr	1164(ra) # 5854 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    43d0:	4501                	li	a0,0
    43d2:	00001097          	auipc	ra,0x1
    43d6:	50a080e7          	jalr	1290(ra) # 58dc <sbrk>
    43da:	064007b7          	lui	a5,0x6400
    43de:	40a7853b          	subw	a0,a5,a0
    43e2:	00001097          	auipc	ra,0x1
    43e6:	4fa080e7          	jalr	1274(ra) # 58dc <sbrk>
      write(fds[1], "x", 1);
    43ea:	4605                	li	a2,1
    43ec:	00002597          	auipc	a1,0x2
    43f0:	d9458593          	addi	a1,a1,-620 # 6180 <malloc+0x4ee>
    43f4:	fb442503          	lw	a0,-76(s0)
    43f8:	00001097          	auipc	ra,0x1
    43fc:	47c080e7          	jalr	1148(ra) # 5874 <write>
      for(;;) sleep(1000);
    4400:	3e800513          	li	a0,1000
    4404:	00001097          	auipc	ra,0x1
    4408:	4e0080e7          	jalr	1248(ra) # 58e4 <sleep>
    440c:	bfd5                	j	4400 <sbrkfail+0x7c>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    440e:	0991                	addi	s3,s3,4
    4410:	03498563          	beq	s3,s4,443a <sbrkfail+0xb6>
    if((pids[i] = fork()) == 0){
    4414:	00001097          	auipc	ra,0x1
    4418:	438080e7          	jalr	1080(ra) # 584c <fork>
    441c:	00a9a023          	sw	a0,0(s3)
    4420:	d945                	beqz	a0,43d0 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4422:	ff5506e3          	beq	a0,s5,440e <sbrkfail+0x8a>
      read(fds[0], &scratch, 1);
    4426:	4605                	li	a2,1
    4428:	faf40593          	addi	a1,s0,-81
    442c:	fb042503          	lw	a0,-80(s0)
    4430:	00001097          	auipc	ra,0x1
    4434:	43c080e7          	jalr	1084(ra) # 586c <read>
    4438:	bfd9                	j	440e <sbrkfail+0x8a>
  c = sbrk(PGSIZE);
    443a:	6505                	lui	a0,0x1
    443c:	00001097          	auipc	ra,0x1
    4440:	4a0080e7          	jalr	1184(ra) # 58dc <sbrk>
    4444:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    4446:	5afd                	li	s5,-1
    4448:	a021                	j	4450 <sbrkfail+0xcc>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    444a:	0491                	addi	s1,s1,4
    444c:	01448f63          	beq	s1,s4,446a <sbrkfail+0xe6>
    if(pids[i] == -1)
    4450:	4088                	lw	a0,0(s1)
    4452:	ff550ce3          	beq	a0,s5,444a <sbrkfail+0xc6>
    kill(pids[i]);
    4456:	00001097          	auipc	ra,0x1
    445a:	42e080e7          	jalr	1070(ra) # 5884 <kill>
    wait(0);
    445e:	4501                	li	a0,0
    4460:	00001097          	auipc	ra,0x1
    4464:	3fc080e7          	jalr	1020(ra) # 585c <wait>
    4468:	b7cd                	j	444a <sbrkfail+0xc6>
  if(c == (char*)0xffffffffffffffffL){
    446a:	57fd                	li	a5,-1
    446c:	04f98163          	beq	s3,a5,44ae <sbrkfail+0x12a>
  pid = fork();
    4470:	00001097          	auipc	ra,0x1
    4474:	3dc080e7          	jalr	988(ra) # 584c <fork>
    4478:	84aa                	mv	s1,a0
  if(pid < 0){
    447a:	04054863          	bltz	a0,44ca <sbrkfail+0x146>
  if(pid == 0){
    447e:	c525                	beqz	a0,44e6 <sbrkfail+0x162>
  wait(&xstatus);
    4480:	fbc40513          	addi	a0,s0,-68
    4484:	00001097          	auipc	ra,0x1
    4488:	3d8080e7          	jalr	984(ra) # 585c <wait>
  if(xstatus != -1 && xstatus != 2)
    448c:	fbc42783          	lw	a5,-68(s0)
    4490:	577d                	li	a4,-1
    4492:	00e78563          	beq	a5,a4,449c <sbrkfail+0x118>
    4496:	4709                	li	a4,2
    4498:	08e79d63          	bne	a5,a4,4532 <sbrkfail+0x1ae>
}
    449c:	70e6                	ld	ra,120(sp)
    449e:	7446                	ld	s0,112(sp)
    44a0:	74a6                	ld	s1,104(sp)
    44a2:	7906                	ld	s2,96(sp)
    44a4:	69e6                	ld	s3,88(sp)
    44a6:	6a46                	ld	s4,80(sp)
    44a8:	6aa6                	ld	s5,72(sp)
    44aa:	6109                	addi	sp,sp,128
    44ac:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    44ae:	85ca                	mv	a1,s2
    44b0:	00003517          	auipc	a0,0x3
    44b4:	78850513          	addi	a0,a0,1928 # 7c38 <malloc+0x1fa6>
    44b8:	00001097          	auipc	ra,0x1
    44bc:	71c080e7          	jalr	1820(ra) # 5bd4 <printf>
    exit(1);
    44c0:	4505                	li	a0,1
    44c2:	00001097          	auipc	ra,0x1
    44c6:	392080e7          	jalr	914(ra) # 5854 <exit>
    printf("%s: fork failed\n", s);
    44ca:	85ca                	mv	a1,s2
    44cc:	00002517          	auipc	a0,0x2
    44d0:	47c50513          	addi	a0,a0,1148 # 6948 <malloc+0xcb6>
    44d4:	00001097          	auipc	ra,0x1
    44d8:	700080e7          	jalr	1792(ra) # 5bd4 <printf>
    exit(1);
    44dc:	4505                	li	a0,1
    44de:	00001097          	auipc	ra,0x1
    44e2:	376080e7          	jalr	886(ra) # 5854 <exit>
    a = sbrk(0);
    44e6:	4501                	li	a0,0
    44e8:	00001097          	auipc	ra,0x1
    44ec:	3f4080e7          	jalr	1012(ra) # 58dc <sbrk>
    44f0:	89aa                	mv	s3,a0
    sbrk(10*BIG);
    44f2:	3e800537          	lui	a0,0x3e800
    44f6:	00001097          	auipc	ra,0x1
    44fa:	3e6080e7          	jalr	998(ra) # 58dc <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    44fe:	874e                	mv	a4,s3
    4500:	3e8007b7          	lui	a5,0x3e800
    4504:	97ce                	add	a5,a5,s3
    4506:	6685                	lui	a3,0x1
      n += *(a+i);
    4508:	00074603          	lbu	a2,0(a4)
    450c:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    450e:	9736                	add	a4,a4,a3
    4510:	fef71ce3          	bne	a4,a5,4508 <sbrkfail+0x184>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4514:	8626                	mv	a2,s1
    4516:	85ca                	mv	a1,s2
    4518:	00003517          	auipc	a0,0x3
    451c:	74050513          	addi	a0,a0,1856 # 7c58 <malloc+0x1fc6>
    4520:	00001097          	auipc	ra,0x1
    4524:	6b4080e7          	jalr	1716(ra) # 5bd4 <printf>
    exit(1);
    4528:	4505                	li	a0,1
    452a:	00001097          	auipc	ra,0x1
    452e:	32a080e7          	jalr	810(ra) # 5854 <exit>
    exit(1);
    4532:	4505                	li	a0,1
    4534:	00001097          	auipc	ra,0x1
    4538:	320080e7          	jalr	800(ra) # 5854 <exit>

000000000000453c <mem>:
{
    453c:	7139                	addi	sp,sp,-64
    453e:	fc06                	sd	ra,56(sp)
    4540:	f822                	sd	s0,48(sp)
    4542:	f426                	sd	s1,40(sp)
    4544:	f04a                	sd	s2,32(sp)
    4546:	ec4e                	sd	s3,24(sp)
    4548:	0080                	addi	s0,sp,64
    454a:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    454c:	00001097          	auipc	ra,0x1
    4550:	300080e7          	jalr	768(ra) # 584c <fork>
    m1 = 0;
    4554:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    4556:	6909                	lui	s2,0x2
    4558:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0xa9>
  if((pid = fork()) == 0){
    455c:	ed39                	bnez	a0,45ba <mem+0x7e>
    while((m2 = malloc(10001)) != 0){
    455e:	854a                	mv	a0,s2
    4560:	00001097          	auipc	ra,0x1
    4564:	732080e7          	jalr	1842(ra) # 5c92 <malloc>
    4568:	c501                	beqz	a0,4570 <mem+0x34>
      *(char**)m2 = m1;
    456a:	e104                	sd	s1,0(a0)
      m1 = m2;
    456c:	84aa                	mv	s1,a0
    456e:	bfc5                	j	455e <mem+0x22>
    while(m1){
    4570:	c881                	beqz	s1,4580 <mem+0x44>
      m2 = *(char**)m1;
    4572:	8526                	mv	a0,s1
    4574:	6084                	ld	s1,0(s1)
      free(m1);
    4576:	00001097          	auipc	ra,0x1
    457a:	694080e7          	jalr	1684(ra) # 5c0a <free>
    while(m1){
    457e:	f8f5                	bnez	s1,4572 <mem+0x36>
    m1 = malloc(1024*20);
    4580:	6515                	lui	a0,0x5
    4582:	00001097          	auipc	ra,0x1
    4586:	710080e7          	jalr	1808(ra) # 5c92 <malloc>
    if(m1 == 0){
    458a:	c911                	beqz	a0,459e <mem+0x62>
    free(m1);
    458c:	00001097          	auipc	ra,0x1
    4590:	67e080e7          	jalr	1662(ra) # 5c0a <free>
    exit(0);
    4594:	4501                	li	a0,0
    4596:	00001097          	auipc	ra,0x1
    459a:	2be080e7          	jalr	702(ra) # 5854 <exit>
      printf("couldn't allocate mem?!!\n", s);
    459e:	85ce                	mv	a1,s3
    45a0:	00003517          	auipc	a0,0x3
    45a4:	6e850513          	addi	a0,a0,1768 # 7c88 <malloc+0x1ff6>
    45a8:	00001097          	auipc	ra,0x1
    45ac:	62c080e7          	jalr	1580(ra) # 5bd4 <printf>
      exit(1);
    45b0:	4505                	li	a0,1
    45b2:	00001097          	auipc	ra,0x1
    45b6:	2a2080e7          	jalr	674(ra) # 5854 <exit>
    wait(&xstatus);
    45ba:	fcc40513          	addi	a0,s0,-52
    45be:	00001097          	auipc	ra,0x1
    45c2:	29e080e7          	jalr	670(ra) # 585c <wait>
    if(xstatus == -1){
    45c6:	fcc42503          	lw	a0,-52(s0)
    45ca:	57fd                	li	a5,-1
    45cc:	00f50663          	beq	a0,a5,45d8 <mem+0x9c>
    exit(xstatus);
    45d0:	00001097          	auipc	ra,0x1
    45d4:	284080e7          	jalr	644(ra) # 5854 <exit>
      exit(0);
    45d8:	4501                	li	a0,0
    45da:	00001097          	auipc	ra,0x1
    45de:	27a080e7          	jalr	634(ra) # 5854 <exit>

00000000000045e2 <sharedfd>:
{
    45e2:	7159                	addi	sp,sp,-112
    45e4:	f486                	sd	ra,104(sp)
    45e6:	f0a2                	sd	s0,96(sp)
    45e8:	eca6                	sd	s1,88(sp)
    45ea:	e8ca                	sd	s2,80(sp)
    45ec:	e4ce                	sd	s3,72(sp)
    45ee:	e0d2                	sd	s4,64(sp)
    45f0:	fc56                	sd	s5,56(sp)
    45f2:	f85a                	sd	s6,48(sp)
    45f4:	f45e                	sd	s7,40(sp)
    45f6:	1880                	addi	s0,sp,112
    45f8:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    45fa:	00002517          	auipc	a0,0x2
    45fe:	92650513          	addi	a0,a0,-1754 # 5f20 <malloc+0x28e>
    4602:	00001097          	auipc	ra,0x1
    4606:	2a2080e7          	jalr	674(ra) # 58a4 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    460a:	20200593          	li	a1,514
    460e:	00002517          	auipc	a0,0x2
    4612:	91250513          	addi	a0,a0,-1774 # 5f20 <malloc+0x28e>
    4616:	00001097          	auipc	ra,0x1
    461a:	27e080e7          	jalr	638(ra) # 5894 <open>
  if(fd < 0){
    461e:	04054a63          	bltz	a0,4672 <sharedfd+0x90>
    4622:	892a                	mv	s2,a0
  pid = fork();
    4624:	00001097          	auipc	ra,0x1
    4628:	228080e7          	jalr	552(ra) # 584c <fork>
    462c:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    462e:	06300593          	li	a1,99
    4632:	c119                	beqz	a0,4638 <sharedfd+0x56>
    4634:	07000593          	li	a1,112
    4638:	4629                	li	a2,10
    463a:	fa040513          	addi	a0,s0,-96
    463e:	00001097          	auipc	ra,0x1
    4642:	012080e7          	jalr	18(ra) # 5650 <memset>
    4646:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    464a:	4629                	li	a2,10
    464c:	fa040593          	addi	a1,s0,-96
    4650:	854a                	mv	a0,s2
    4652:	00001097          	auipc	ra,0x1
    4656:	222080e7          	jalr	546(ra) # 5874 <write>
    465a:	47a9                	li	a5,10
    465c:	02f51963          	bne	a0,a5,468e <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4660:	34fd                	addiw	s1,s1,-1
    4662:	f4e5                	bnez	s1,464a <sharedfd+0x68>
  if(pid == 0) {
    4664:	04099363          	bnez	s3,46aa <sharedfd+0xc8>
    exit(0);
    4668:	4501                	li	a0,0
    466a:	00001097          	auipc	ra,0x1
    466e:	1ea080e7          	jalr	490(ra) # 5854 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4672:	85d2                	mv	a1,s4
    4674:	00003517          	auipc	a0,0x3
    4678:	63450513          	addi	a0,a0,1588 # 7ca8 <malloc+0x2016>
    467c:	00001097          	auipc	ra,0x1
    4680:	558080e7          	jalr	1368(ra) # 5bd4 <printf>
    exit(1);
    4684:	4505                	li	a0,1
    4686:	00001097          	auipc	ra,0x1
    468a:	1ce080e7          	jalr	462(ra) # 5854 <exit>
      printf("%s: write sharedfd failed\n", s);
    468e:	85d2                	mv	a1,s4
    4690:	00003517          	auipc	a0,0x3
    4694:	64050513          	addi	a0,a0,1600 # 7cd0 <malloc+0x203e>
    4698:	00001097          	auipc	ra,0x1
    469c:	53c080e7          	jalr	1340(ra) # 5bd4 <printf>
      exit(1);
    46a0:	4505                	li	a0,1
    46a2:	00001097          	auipc	ra,0x1
    46a6:	1b2080e7          	jalr	434(ra) # 5854 <exit>
    wait(&xstatus);
    46aa:	f9c40513          	addi	a0,s0,-100
    46ae:	00001097          	auipc	ra,0x1
    46b2:	1ae080e7          	jalr	430(ra) # 585c <wait>
    if(xstatus != 0)
    46b6:	f9c42983          	lw	s3,-100(s0)
    46ba:	00098763          	beqz	s3,46c8 <sharedfd+0xe6>
      exit(xstatus);
    46be:	854e                	mv	a0,s3
    46c0:	00001097          	auipc	ra,0x1
    46c4:	194080e7          	jalr	404(ra) # 5854 <exit>
  close(fd);
    46c8:	854a                	mv	a0,s2
    46ca:	00001097          	auipc	ra,0x1
    46ce:	1b2080e7          	jalr	434(ra) # 587c <close>
  fd = open("sharedfd", 0);
    46d2:	4581                	li	a1,0
    46d4:	00002517          	auipc	a0,0x2
    46d8:	84c50513          	addi	a0,a0,-1972 # 5f20 <malloc+0x28e>
    46dc:	00001097          	auipc	ra,0x1
    46e0:	1b8080e7          	jalr	440(ra) # 5894 <open>
    46e4:	8baa                	mv	s7,a0
  nc = np = 0;
    46e6:	8ace                	mv	s5,s3
  if(fd < 0){
    46e8:	02054563          	bltz	a0,4712 <sharedfd+0x130>
    46ec:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    46f0:	06300493          	li	s1,99
      if(buf[i] == 'p')
    46f4:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    46f8:	4629                	li	a2,10
    46fa:	fa040593          	addi	a1,s0,-96
    46fe:	855e                	mv	a0,s7
    4700:	00001097          	auipc	ra,0x1
    4704:	16c080e7          	jalr	364(ra) # 586c <read>
    4708:	02a05f63          	blez	a0,4746 <sharedfd+0x164>
    470c:	fa040793          	addi	a5,s0,-96
    4710:	a01d                	j	4736 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4712:	85d2                	mv	a1,s4
    4714:	00003517          	auipc	a0,0x3
    4718:	5dc50513          	addi	a0,a0,1500 # 7cf0 <malloc+0x205e>
    471c:	00001097          	auipc	ra,0x1
    4720:	4b8080e7          	jalr	1208(ra) # 5bd4 <printf>
    exit(1);
    4724:	4505                	li	a0,1
    4726:	00001097          	auipc	ra,0x1
    472a:	12e080e7          	jalr	302(ra) # 5854 <exit>
        nc++;
    472e:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4730:	0785                	addi	a5,a5,1
    4732:	fd2783e3          	beq	a5,s2,46f8 <sharedfd+0x116>
      if(buf[i] == 'c')
    4736:	0007c703          	lbu	a4,0(a5) # 3e800000 <__BSS_END__+0x3e7f1258>
    473a:	fe970ae3          	beq	a4,s1,472e <sharedfd+0x14c>
      if(buf[i] == 'p')
    473e:	ff6719e3          	bne	a4,s6,4730 <sharedfd+0x14e>
        np++;
    4742:	2a85                	addiw	s5,s5,1
    4744:	b7f5                	j	4730 <sharedfd+0x14e>
  close(fd);
    4746:	855e                	mv	a0,s7
    4748:	00001097          	auipc	ra,0x1
    474c:	134080e7          	jalr	308(ra) # 587c <close>
  unlink("sharedfd");
    4750:	00001517          	auipc	a0,0x1
    4754:	7d050513          	addi	a0,a0,2000 # 5f20 <malloc+0x28e>
    4758:	00001097          	auipc	ra,0x1
    475c:	14c080e7          	jalr	332(ra) # 58a4 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4760:	6789                	lui	a5,0x2
    4762:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0xa8>
    4766:	00f99763          	bne	s3,a5,4774 <sharedfd+0x192>
    476a:	6789                	lui	a5,0x2
    476c:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0xa8>
    4770:	02fa8063          	beq	s5,a5,4790 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4774:	85d2                	mv	a1,s4
    4776:	00003517          	auipc	a0,0x3
    477a:	5a250513          	addi	a0,a0,1442 # 7d18 <malloc+0x2086>
    477e:	00001097          	auipc	ra,0x1
    4782:	456080e7          	jalr	1110(ra) # 5bd4 <printf>
    exit(1);
    4786:	4505                	li	a0,1
    4788:	00001097          	auipc	ra,0x1
    478c:	0cc080e7          	jalr	204(ra) # 5854 <exit>
    exit(0);
    4790:	4501                	li	a0,0
    4792:	00001097          	auipc	ra,0x1
    4796:	0c2080e7          	jalr	194(ra) # 5854 <exit>

000000000000479a <fourfiles>:
{
    479a:	7171                	addi	sp,sp,-176
    479c:	f506                	sd	ra,168(sp)
    479e:	f122                	sd	s0,160(sp)
    47a0:	ed26                	sd	s1,152(sp)
    47a2:	e94a                	sd	s2,144(sp)
    47a4:	e54e                	sd	s3,136(sp)
    47a6:	e152                	sd	s4,128(sp)
    47a8:	fcd6                	sd	s5,120(sp)
    47aa:	f8da                	sd	s6,112(sp)
    47ac:	f4de                	sd	s7,104(sp)
    47ae:	f0e2                	sd	s8,96(sp)
    47b0:	ece6                	sd	s9,88(sp)
    47b2:	e8ea                	sd	s10,80(sp)
    47b4:	e4ee                	sd	s11,72(sp)
    47b6:	1900                	addi	s0,sp,176
    47b8:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    47ba:	00001797          	auipc	a5,0x1
    47be:	5be78793          	addi	a5,a5,1470 # 5d78 <malloc+0xe6>
    47c2:	f6f43823          	sd	a5,-144(s0)
    47c6:	00001797          	auipc	a5,0x1
    47ca:	5ba78793          	addi	a5,a5,1466 # 5d80 <malloc+0xee>
    47ce:	f6f43c23          	sd	a5,-136(s0)
    47d2:	00001797          	auipc	a5,0x1
    47d6:	5b678793          	addi	a5,a5,1462 # 5d88 <malloc+0xf6>
    47da:	f8f43023          	sd	a5,-128(s0)
    47de:	00001797          	auipc	a5,0x1
    47e2:	5b278793          	addi	a5,a5,1458 # 5d90 <malloc+0xfe>
    47e6:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    47ea:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    47ee:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    47f0:	4481                	li	s1,0
    47f2:	4a11                	li	s4,4
    fname = names[pi];
    47f4:	00093983          	ld	s3,0(s2)
    unlink(fname);
    47f8:	854e                	mv	a0,s3
    47fa:	00001097          	auipc	ra,0x1
    47fe:	0aa080e7          	jalr	170(ra) # 58a4 <unlink>
    pid = fork();
    4802:	00001097          	auipc	ra,0x1
    4806:	04a080e7          	jalr	74(ra) # 584c <fork>
    if(pid < 0){
    480a:	04054563          	bltz	a0,4854 <fourfiles+0xba>
    if(pid == 0){
    480e:	c12d                	beqz	a0,4870 <fourfiles+0xd6>
  for(pi = 0; pi < NCHILD; pi++){
    4810:	2485                	addiw	s1,s1,1
    4812:	0921                	addi	s2,s2,8
    4814:	ff4490e3          	bne	s1,s4,47f4 <fourfiles+0x5a>
    4818:	4491                	li	s1,4
    wait(&xstatus);
    481a:	f6c40513          	addi	a0,s0,-148
    481e:	00001097          	auipc	ra,0x1
    4822:	03e080e7          	jalr	62(ra) # 585c <wait>
    if(xstatus != 0)
    4826:	f6c42503          	lw	a0,-148(s0)
    482a:	ed69                	bnez	a0,4904 <fourfiles+0x16a>
  for(pi = 0; pi < NCHILD; pi++){
    482c:	34fd                	addiw	s1,s1,-1
    482e:	f4f5                	bnez	s1,481a <fourfiles+0x80>
    4830:	03000b13          	li	s6,48
    total = 0;
    4834:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4838:	00007a17          	auipc	s4,0x7
    483c:	560a0a13          	addi	s4,s4,1376 # bd98 <buf>
    4840:	00007a97          	auipc	s5,0x7
    4844:	559a8a93          	addi	s5,s5,1369 # bd99 <buf+0x1>
    if(total != N*SZ){
    4848:	6d05                	lui	s10,0x1
    484a:	770d0d13          	addi	s10,s10,1904 # 1770 <pipe1+0x30>
  for(i = 0; i < NCHILD; i++){
    484e:	03400d93          	li	s11,52
    4852:	a23d                	j	4980 <fourfiles+0x1e6>
      printf("fork failed\n", s);
    4854:	85e6                	mv	a1,s9
    4856:	00002517          	auipc	a0,0x2
    485a:	51250513          	addi	a0,a0,1298 # 6d68 <malloc+0x10d6>
    485e:	00001097          	auipc	ra,0x1
    4862:	376080e7          	jalr	886(ra) # 5bd4 <printf>
      exit(1);
    4866:	4505                	li	a0,1
    4868:	00001097          	auipc	ra,0x1
    486c:	fec080e7          	jalr	-20(ra) # 5854 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4870:	20200593          	li	a1,514
    4874:	854e                	mv	a0,s3
    4876:	00001097          	auipc	ra,0x1
    487a:	01e080e7          	jalr	30(ra) # 5894 <open>
    487e:	892a                	mv	s2,a0
      if(fd < 0){
    4880:	04054763          	bltz	a0,48ce <fourfiles+0x134>
      memset(buf, '0'+pi, SZ);
    4884:	1f400613          	li	a2,500
    4888:	0304859b          	addiw	a1,s1,48
    488c:	00007517          	auipc	a0,0x7
    4890:	50c50513          	addi	a0,a0,1292 # bd98 <buf>
    4894:	00001097          	auipc	ra,0x1
    4898:	dbc080e7          	jalr	-580(ra) # 5650 <memset>
    489c:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    489e:	00007997          	auipc	s3,0x7
    48a2:	4fa98993          	addi	s3,s3,1274 # bd98 <buf>
    48a6:	1f400613          	li	a2,500
    48aa:	85ce                	mv	a1,s3
    48ac:	854a                	mv	a0,s2
    48ae:	00001097          	auipc	ra,0x1
    48b2:	fc6080e7          	jalr	-58(ra) # 5874 <write>
    48b6:	85aa                	mv	a1,a0
    48b8:	1f400793          	li	a5,500
    48bc:	02f51763          	bne	a0,a5,48ea <fourfiles+0x150>
      for(i = 0; i < N; i++){
    48c0:	34fd                	addiw	s1,s1,-1
    48c2:	f0f5                	bnez	s1,48a6 <fourfiles+0x10c>
      exit(0);
    48c4:	4501                	li	a0,0
    48c6:	00001097          	auipc	ra,0x1
    48ca:	f8e080e7          	jalr	-114(ra) # 5854 <exit>
        printf("create failed\n", s);
    48ce:	85e6                	mv	a1,s9
    48d0:	00003517          	auipc	a0,0x3
    48d4:	46050513          	addi	a0,a0,1120 # 7d30 <malloc+0x209e>
    48d8:	00001097          	auipc	ra,0x1
    48dc:	2fc080e7          	jalr	764(ra) # 5bd4 <printf>
        exit(1);
    48e0:	4505                	li	a0,1
    48e2:	00001097          	auipc	ra,0x1
    48e6:	f72080e7          	jalr	-142(ra) # 5854 <exit>
          printf("write failed %d\n", n);
    48ea:	00003517          	auipc	a0,0x3
    48ee:	45650513          	addi	a0,a0,1110 # 7d40 <malloc+0x20ae>
    48f2:	00001097          	auipc	ra,0x1
    48f6:	2e2080e7          	jalr	738(ra) # 5bd4 <printf>
          exit(1);
    48fa:	4505                	li	a0,1
    48fc:	00001097          	auipc	ra,0x1
    4900:	f58080e7          	jalr	-168(ra) # 5854 <exit>
      exit(xstatus);
    4904:	00001097          	auipc	ra,0x1
    4908:	f50080e7          	jalr	-176(ra) # 5854 <exit>
          printf("wrong char\n", s);
    490c:	85e6                	mv	a1,s9
    490e:	00003517          	auipc	a0,0x3
    4912:	44a50513          	addi	a0,a0,1098 # 7d58 <malloc+0x20c6>
    4916:	00001097          	auipc	ra,0x1
    491a:	2be080e7          	jalr	702(ra) # 5bd4 <printf>
          exit(1);
    491e:	4505                	li	a0,1
    4920:	00001097          	auipc	ra,0x1
    4924:	f34080e7          	jalr	-204(ra) # 5854 <exit>
      total += n;
    4928:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    492c:	660d                	lui	a2,0x3
    492e:	85d2                	mv	a1,s4
    4930:	854e                	mv	a0,s3
    4932:	00001097          	auipc	ra,0x1
    4936:	f3a080e7          	jalr	-198(ra) # 586c <read>
    493a:	02a05363          	blez	a0,4960 <fourfiles+0x1c6>
    493e:	00007797          	auipc	a5,0x7
    4942:	45a78793          	addi	a5,a5,1114 # bd98 <buf>
    4946:	fff5069b          	addiw	a3,a0,-1
    494a:	1682                	slli	a3,a3,0x20
    494c:	9281                	srli	a3,a3,0x20
    494e:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    4950:	0007c703          	lbu	a4,0(a5)
    4954:	fa971ce3          	bne	a4,s1,490c <fourfiles+0x172>
      for(j = 0; j < n; j++){
    4958:	0785                	addi	a5,a5,1
    495a:	fed79be3          	bne	a5,a3,4950 <fourfiles+0x1b6>
    495e:	b7e9                	j	4928 <fourfiles+0x18e>
    close(fd);
    4960:	854e                	mv	a0,s3
    4962:	00001097          	auipc	ra,0x1
    4966:	f1a080e7          	jalr	-230(ra) # 587c <close>
    if(total != N*SZ){
    496a:	03a91963          	bne	s2,s10,499c <fourfiles+0x202>
    unlink(fname);
    496e:	8562                	mv	a0,s8
    4970:	00001097          	auipc	ra,0x1
    4974:	f34080e7          	jalr	-204(ra) # 58a4 <unlink>
  for(i = 0; i < NCHILD; i++){
    4978:	0ba1                	addi	s7,s7,8
    497a:	2b05                	addiw	s6,s6,1
    497c:	03bb0e63          	beq	s6,s11,49b8 <fourfiles+0x21e>
    fname = names[i];
    4980:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4984:	4581                	li	a1,0
    4986:	8562                	mv	a0,s8
    4988:	00001097          	auipc	ra,0x1
    498c:	f0c080e7          	jalr	-244(ra) # 5894 <open>
    4990:	89aa                	mv	s3,a0
    total = 0;
    4992:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    4996:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    499a:	bf49                	j	492c <fourfiles+0x192>
      printf("wrong length %d\n", total);
    499c:	85ca                	mv	a1,s2
    499e:	00003517          	auipc	a0,0x3
    49a2:	3ca50513          	addi	a0,a0,970 # 7d68 <malloc+0x20d6>
    49a6:	00001097          	auipc	ra,0x1
    49aa:	22e080e7          	jalr	558(ra) # 5bd4 <printf>
      exit(1);
    49ae:	4505                	li	a0,1
    49b0:	00001097          	auipc	ra,0x1
    49b4:	ea4080e7          	jalr	-348(ra) # 5854 <exit>
}
    49b8:	70aa                	ld	ra,168(sp)
    49ba:	740a                	ld	s0,160(sp)
    49bc:	64ea                	ld	s1,152(sp)
    49be:	694a                	ld	s2,144(sp)
    49c0:	69aa                	ld	s3,136(sp)
    49c2:	6a0a                	ld	s4,128(sp)
    49c4:	7ae6                	ld	s5,120(sp)
    49c6:	7b46                	ld	s6,112(sp)
    49c8:	7ba6                	ld	s7,104(sp)
    49ca:	7c06                	ld	s8,96(sp)
    49cc:	6ce6                	ld	s9,88(sp)
    49ce:	6d46                	ld	s10,80(sp)
    49d0:	6da6                	ld	s11,72(sp)
    49d2:	614d                	addi	sp,sp,176
    49d4:	8082                	ret

00000000000049d6 <concreate>:
{
    49d6:	7135                	addi	sp,sp,-160
    49d8:	ed06                	sd	ra,152(sp)
    49da:	e922                	sd	s0,144(sp)
    49dc:	e526                	sd	s1,136(sp)
    49de:	e14a                	sd	s2,128(sp)
    49e0:	fcce                	sd	s3,120(sp)
    49e2:	f8d2                	sd	s4,112(sp)
    49e4:	f4d6                	sd	s5,104(sp)
    49e6:	f0da                	sd	s6,96(sp)
    49e8:	ecde                	sd	s7,88(sp)
    49ea:	1100                	addi	s0,sp,160
    49ec:	89aa                	mv	s3,a0
  file[0] = 'C';
    49ee:	04300793          	li	a5,67
    49f2:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    49f6:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    49fa:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    49fc:	4b0d                	li	s6,3
    49fe:	4a85                	li	s5,1
      link("C0", file);
    4a00:	00003b97          	auipc	s7,0x3
    4a04:	380b8b93          	addi	s7,s7,896 # 7d80 <malloc+0x20ee>
  for(i = 0; i < N; i++){
    4a08:	02800a13          	li	s4,40
    4a0c:	acc1                	j	4cdc <concreate+0x306>
      link("C0", file);
    4a0e:	fa840593          	addi	a1,s0,-88
    4a12:	855e                	mv	a0,s7
    4a14:	00001097          	auipc	ra,0x1
    4a18:	ea0080e7          	jalr	-352(ra) # 58b4 <link>
    if(pid == 0) {
    4a1c:	a45d                	j	4cc2 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4a1e:	4795                	li	a5,5
    4a20:	02f9693b          	remw	s2,s2,a5
    4a24:	4785                	li	a5,1
    4a26:	02f90b63          	beq	s2,a5,4a5c <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4a2a:	20200593          	li	a1,514
    4a2e:	fa840513          	addi	a0,s0,-88
    4a32:	00001097          	auipc	ra,0x1
    4a36:	e62080e7          	jalr	-414(ra) # 5894 <open>
      if(fd < 0){
    4a3a:	26055b63          	bgez	a0,4cb0 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4a3e:	fa840593          	addi	a1,s0,-88
    4a42:	00003517          	auipc	a0,0x3
    4a46:	34650513          	addi	a0,a0,838 # 7d88 <malloc+0x20f6>
    4a4a:	00001097          	auipc	ra,0x1
    4a4e:	18a080e7          	jalr	394(ra) # 5bd4 <printf>
        exit(1);
    4a52:	4505                	li	a0,1
    4a54:	00001097          	auipc	ra,0x1
    4a58:	e00080e7          	jalr	-512(ra) # 5854 <exit>
      link("C0", file);
    4a5c:	fa840593          	addi	a1,s0,-88
    4a60:	00003517          	auipc	a0,0x3
    4a64:	32050513          	addi	a0,a0,800 # 7d80 <malloc+0x20ee>
    4a68:	00001097          	auipc	ra,0x1
    4a6c:	e4c080e7          	jalr	-436(ra) # 58b4 <link>
      exit(0);
    4a70:	4501                	li	a0,0
    4a72:	00001097          	auipc	ra,0x1
    4a76:	de2080e7          	jalr	-542(ra) # 5854 <exit>
        exit(1);
    4a7a:	4505                	li	a0,1
    4a7c:	00001097          	auipc	ra,0x1
    4a80:	dd8080e7          	jalr	-552(ra) # 5854 <exit>
  memset(fa, 0, sizeof(fa));
    4a84:	02800613          	li	a2,40
    4a88:	4581                	li	a1,0
    4a8a:	f8040513          	addi	a0,s0,-128
    4a8e:	00001097          	auipc	ra,0x1
    4a92:	bc2080e7          	jalr	-1086(ra) # 5650 <memset>
  fd = open(".", 0);
    4a96:	4581                	li	a1,0
    4a98:	00002517          	auipc	a0,0x2
    4a9c:	d1050513          	addi	a0,a0,-752 # 67a8 <malloc+0xb16>
    4aa0:	00001097          	auipc	ra,0x1
    4aa4:	df4080e7          	jalr	-524(ra) # 5894 <open>
    4aa8:	892a                	mv	s2,a0
  n = 0;
    4aaa:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4aac:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4ab0:	02700b13          	li	s6,39
      fa[i] = 1;
    4ab4:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4ab6:	a03d                	j	4ae4 <concreate+0x10e>
        printf("%s: concreate weird file %s\n", s, de.name);
    4ab8:	f7240613          	addi	a2,s0,-142
    4abc:	85ce                	mv	a1,s3
    4abe:	00003517          	auipc	a0,0x3
    4ac2:	2ea50513          	addi	a0,a0,746 # 7da8 <malloc+0x2116>
    4ac6:	00001097          	auipc	ra,0x1
    4aca:	10e080e7          	jalr	270(ra) # 5bd4 <printf>
        exit(1);
    4ace:	4505                	li	a0,1
    4ad0:	00001097          	auipc	ra,0x1
    4ad4:	d84080e7          	jalr	-636(ra) # 5854 <exit>
      fa[i] = 1;
    4ad8:	fb040793          	addi	a5,s0,-80
    4adc:	973e                	add	a4,a4,a5
    4ade:	fd770823          	sb	s7,-48(a4)
      n++;
    4ae2:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    4ae4:	4641                	li	a2,16
    4ae6:	f7040593          	addi	a1,s0,-144
    4aea:	854a                	mv	a0,s2
    4aec:	00001097          	auipc	ra,0x1
    4af0:	d80080e7          	jalr	-640(ra) # 586c <read>
    4af4:	04a05a63          	blez	a0,4b48 <concreate+0x172>
    if(de.inum == 0)
    4af8:	f7045783          	lhu	a5,-144(s0)
    4afc:	d7e5                	beqz	a5,4ae4 <concreate+0x10e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4afe:	f7244783          	lbu	a5,-142(s0)
    4b02:	ff4791e3          	bne	a5,s4,4ae4 <concreate+0x10e>
    4b06:	f7444783          	lbu	a5,-140(s0)
    4b0a:	ffe9                	bnez	a5,4ae4 <concreate+0x10e>
      i = de.name[1] - '0';
    4b0c:	f7344783          	lbu	a5,-141(s0)
    4b10:	fd07879b          	addiw	a5,a5,-48
    4b14:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4b18:	faeb60e3          	bltu	s6,a4,4ab8 <concreate+0xe2>
      if(fa[i]){
    4b1c:	fb040793          	addi	a5,s0,-80
    4b20:	97ba                	add	a5,a5,a4
    4b22:	fd07c783          	lbu	a5,-48(a5)
    4b26:	dbcd                	beqz	a5,4ad8 <concreate+0x102>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4b28:	f7240613          	addi	a2,s0,-142
    4b2c:	85ce                	mv	a1,s3
    4b2e:	00003517          	auipc	a0,0x3
    4b32:	29a50513          	addi	a0,a0,666 # 7dc8 <malloc+0x2136>
    4b36:	00001097          	auipc	ra,0x1
    4b3a:	09e080e7          	jalr	158(ra) # 5bd4 <printf>
        exit(1);
    4b3e:	4505                	li	a0,1
    4b40:	00001097          	auipc	ra,0x1
    4b44:	d14080e7          	jalr	-748(ra) # 5854 <exit>
  close(fd);
    4b48:	854a                	mv	a0,s2
    4b4a:	00001097          	auipc	ra,0x1
    4b4e:	d32080e7          	jalr	-718(ra) # 587c <close>
  if(n != N){
    4b52:	02800793          	li	a5,40
    4b56:	00fa9763          	bne	s5,a5,4b64 <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    4b5a:	4a8d                	li	s5,3
    4b5c:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4b5e:	02800a13          	li	s4,40
    4b62:	a8c9                	j	4c34 <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    4b64:	85ce                	mv	a1,s3
    4b66:	00003517          	auipc	a0,0x3
    4b6a:	28a50513          	addi	a0,a0,650 # 7df0 <malloc+0x215e>
    4b6e:	00001097          	auipc	ra,0x1
    4b72:	066080e7          	jalr	102(ra) # 5bd4 <printf>
    exit(1);
    4b76:	4505                	li	a0,1
    4b78:	00001097          	auipc	ra,0x1
    4b7c:	cdc080e7          	jalr	-804(ra) # 5854 <exit>
      printf("%s: fork failed\n", s);
    4b80:	85ce                	mv	a1,s3
    4b82:	00002517          	auipc	a0,0x2
    4b86:	dc650513          	addi	a0,a0,-570 # 6948 <malloc+0xcb6>
    4b8a:	00001097          	auipc	ra,0x1
    4b8e:	04a080e7          	jalr	74(ra) # 5bd4 <printf>
      exit(1);
    4b92:	4505                	li	a0,1
    4b94:	00001097          	auipc	ra,0x1
    4b98:	cc0080e7          	jalr	-832(ra) # 5854 <exit>
      close(open(file, 0));
    4b9c:	4581                	li	a1,0
    4b9e:	fa840513          	addi	a0,s0,-88
    4ba2:	00001097          	auipc	ra,0x1
    4ba6:	cf2080e7          	jalr	-782(ra) # 5894 <open>
    4baa:	00001097          	auipc	ra,0x1
    4bae:	cd2080e7          	jalr	-814(ra) # 587c <close>
      close(open(file, 0));
    4bb2:	4581                	li	a1,0
    4bb4:	fa840513          	addi	a0,s0,-88
    4bb8:	00001097          	auipc	ra,0x1
    4bbc:	cdc080e7          	jalr	-804(ra) # 5894 <open>
    4bc0:	00001097          	auipc	ra,0x1
    4bc4:	cbc080e7          	jalr	-836(ra) # 587c <close>
      close(open(file, 0));
    4bc8:	4581                	li	a1,0
    4bca:	fa840513          	addi	a0,s0,-88
    4bce:	00001097          	auipc	ra,0x1
    4bd2:	cc6080e7          	jalr	-826(ra) # 5894 <open>
    4bd6:	00001097          	auipc	ra,0x1
    4bda:	ca6080e7          	jalr	-858(ra) # 587c <close>
      close(open(file, 0));
    4bde:	4581                	li	a1,0
    4be0:	fa840513          	addi	a0,s0,-88
    4be4:	00001097          	auipc	ra,0x1
    4be8:	cb0080e7          	jalr	-848(ra) # 5894 <open>
    4bec:	00001097          	auipc	ra,0x1
    4bf0:	c90080e7          	jalr	-880(ra) # 587c <close>
      close(open(file, 0));
    4bf4:	4581                	li	a1,0
    4bf6:	fa840513          	addi	a0,s0,-88
    4bfa:	00001097          	auipc	ra,0x1
    4bfe:	c9a080e7          	jalr	-870(ra) # 5894 <open>
    4c02:	00001097          	auipc	ra,0x1
    4c06:	c7a080e7          	jalr	-902(ra) # 587c <close>
      close(open(file, 0));
    4c0a:	4581                	li	a1,0
    4c0c:	fa840513          	addi	a0,s0,-88
    4c10:	00001097          	auipc	ra,0x1
    4c14:	c84080e7          	jalr	-892(ra) # 5894 <open>
    4c18:	00001097          	auipc	ra,0x1
    4c1c:	c64080e7          	jalr	-924(ra) # 587c <close>
    if(pid == 0)
    4c20:	08090363          	beqz	s2,4ca6 <concreate+0x2d0>
      wait(0);
    4c24:	4501                	li	a0,0
    4c26:	00001097          	auipc	ra,0x1
    4c2a:	c36080e7          	jalr	-970(ra) # 585c <wait>
  for(i = 0; i < N; i++){
    4c2e:	2485                	addiw	s1,s1,1
    4c30:	0f448563          	beq	s1,s4,4d1a <concreate+0x344>
    file[1] = '0' + i;
    4c34:	0304879b          	addiw	a5,s1,48
    4c38:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4c3c:	00001097          	auipc	ra,0x1
    4c40:	c10080e7          	jalr	-1008(ra) # 584c <fork>
    4c44:	892a                	mv	s2,a0
    if(pid < 0){
    4c46:	f2054de3          	bltz	a0,4b80 <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    4c4a:	0354e73b          	remw	a4,s1,s5
    4c4e:	00a767b3          	or	a5,a4,a0
    4c52:	2781                	sext.w	a5,a5
    4c54:	d7a1                	beqz	a5,4b9c <concreate+0x1c6>
    4c56:	01671363          	bne	a4,s6,4c5c <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    4c5a:	f129                	bnez	a0,4b9c <concreate+0x1c6>
      unlink(file);
    4c5c:	fa840513          	addi	a0,s0,-88
    4c60:	00001097          	auipc	ra,0x1
    4c64:	c44080e7          	jalr	-956(ra) # 58a4 <unlink>
      unlink(file);
    4c68:	fa840513          	addi	a0,s0,-88
    4c6c:	00001097          	auipc	ra,0x1
    4c70:	c38080e7          	jalr	-968(ra) # 58a4 <unlink>
      unlink(file);
    4c74:	fa840513          	addi	a0,s0,-88
    4c78:	00001097          	auipc	ra,0x1
    4c7c:	c2c080e7          	jalr	-980(ra) # 58a4 <unlink>
      unlink(file);
    4c80:	fa840513          	addi	a0,s0,-88
    4c84:	00001097          	auipc	ra,0x1
    4c88:	c20080e7          	jalr	-992(ra) # 58a4 <unlink>
      unlink(file);
    4c8c:	fa840513          	addi	a0,s0,-88
    4c90:	00001097          	auipc	ra,0x1
    4c94:	c14080e7          	jalr	-1004(ra) # 58a4 <unlink>
      unlink(file);
    4c98:	fa840513          	addi	a0,s0,-88
    4c9c:	00001097          	auipc	ra,0x1
    4ca0:	c08080e7          	jalr	-1016(ra) # 58a4 <unlink>
    4ca4:	bfb5                	j	4c20 <concreate+0x24a>
      exit(0);
    4ca6:	4501                	li	a0,0
    4ca8:	00001097          	auipc	ra,0x1
    4cac:	bac080e7          	jalr	-1108(ra) # 5854 <exit>
      close(fd);
    4cb0:	00001097          	auipc	ra,0x1
    4cb4:	bcc080e7          	jalr	-1076(ra) # 587c <close>
    if(pid == 0) {
    4cb8:	bb65                	j	4a70 <concreate+0x9a>
      close(fd);
    4cba:	00001097          	auipc	ra,0x1
    4cbe:	bc2080e7          	jalr	-1086(ra) # 587c <close>
      wait(&xstatus);
    4cc2:	f6c40513          	addi	a0,s0,-148
    4cc6:	00001097          	auipc	ra,0x1
    4cca:	b96080e7          	jalr	-1130(ra) # 585c <wait>
      if(xstatus != 0)
    4cce:	f6c42483          	lw	s1,-148(s0)
    4cd2:	da0494e3          	bnez	s1,4a7a <concreate+0xa4>
  for(i = 0; i < N; i++){
    4cd6:	2905                	addiw	s2,s2,1
    4cd8:	db4906e3          	beq	s2,s4,4a84 <concreate+0xae>
    file[1] = '0' + i;
    4cdc:	0309079b          	addiw	a5,s2,48
    4ce0:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4ce4:	fa840513          	addi	a0,s0,-88
    4ce8:	00001097          	auipc	ra,0x1
    4cec:	bbc080e7          	jalr	-1092(ra) # 58a4 <unlink>
    pid = fork();
    4cf0:	00001097          	auipc	ra,0x1
    4cf4:	b5c080e7          	jalr	-1188(ra) # 584c <fork>
    if(pid && (i % 3) == 1){
    4cf8:	d20503e3          	beqz	a0,4a1e <concreate+0x48>
    4cfc:	036967bb          	remw	a5,s2,s6
    4d00:	d15787e3          	beq	a5,s5,4a0e <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4d04:	20200593          	li	a1,514
    4d08:	fa840513          	addi	a0,s0,-88
    4d0c:	00001097          	auipc	ra,0x1
    4d10:	b88080e7          	jalr	-1144(ra) # 5894 <open>
      if(fd < 0){
    4d14:	fa0553e3          	bgez	a0,4cba <concreate+0x2e4>
    4d18:	b31d                	j	4a3e <concreate+0x68>
}
    4d1a:	60ea                	ld	ra,152(sp)
    4d1c:	644a                	ld	s0,144(sp)
    4d1e:	64aa                	ld	s1,136(sp)
    4d20:	690a                	ld	s2,128(sp)
    4d22:	79e6                	ld	s3,120(sp)
    4d24:	7a46                	ld	s4,112(sp)
    4d26:	7aa6                	ld	s5,104(sp)
    4d28:	7b06                	ld	s6,96(sp)
    4d2a:	6be6                	ld	s7,88(sp)
    4d2c:	610d                	addi	sp,sp,160
    4d2e:	8082                	ret

0000000000004d30 <bigfile>:
{
    4d30:	7139                	addi	sp,sp,-64
    4d32:	fc06                	sd	ra,56(sp)
    4d34:	f822                	sd	s0,48(sp)
    4d36:	f426                	sd	s1,40(sp)
    4d38:	f04a                	sd	s2,32(sp)
    4d3a:	ec4e                	sd	s3,24(sp)
    4d3c:	e852                	sd	s4,16(sp)
    4d3e:	e456                	sd	s5,8(sp)
    4d40:	0080                	addi	s0,sp,64
    4d42:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4d44:	00003517          	auipc	a0,0x3
    4d48:	0e450513          	addi	a0,a0,228 # 7e28 <malloc+0x2196>
    4d4c:	00001097          	auipc	ra,0x1
    4d50:	b58080e7          	jalr	-1192(ra) # 58a4 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4d54:	20200593          	li	a1,514
    4d58:	00003517          	auipc	a0,0x3
    4d5c:	0d050513          	addi	a0,a0,208 # 7e28 <malloc+0x2196>
    4d60:	00001097          	auipc	ra,0x1
    4d64:	b34080e7          	jalr	-1228(ra) # 5894 <open>
    4d68:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4d6a:	4481                	li	s1,0
    memset(buf, i, SZ);
    4d6c:	00007917          	auipc	s2,0x7
    4d70:	02c90913          	addi	s2,s2,44 # bd98 <buf>
  for(i = 0; i < N; i++){
    4d74:	4a51                	li	s4,20
  if(fd < 0){
    4d76:	0a054063          	bltz	a0,4e16 <bigfile+0xe6>
    memset(buf, i, SZ);
    4d7a:	25800613          	li	a2,600
    4d7e:	85a6                	mv	a1,s1
    4d80:	854a                	mv	a0,s2
    4d82:	00001097          	auipc	ra,0x1
    4d86:	8ce080e7          	jalr	-1842(ra) # 5650 <memset>
    if(write(fd, buf, SZ) != SZ){
    4d8a:	25800613          	li	a2,600
    4d8e:	85ca                	mv	a1,s2
    4d90:	854e                	mv	a0,s3
    4d92:	00001097          	auipc	ra,0x1
    4d96:	ae2080e7          	jalr	-1310(ra) # 5874 <write>
    4d9a:	25800793          	li	a5,600
    4d9e:	08f51a63          	bne	a0,a5,4e32 <bigfile+0x102>
  for(i = 0; i < N; i++){
    4da2:	2485                	addiw	s1,s1,1
    4da4:	fd449be3          	bne	s1,s4,4d7a <bigfile+0x4a>
  close(fd);
    4da8:	854e                	mv	a0,s3
    4daa:	00001097          	auipc	ra,0x1
    4dae:	ad2080e7          	jalr	-1326(ra) # 587c <close>
  fd = open("bigfile.dat", 0);
    4db2:	4581                	li	a1,0
    4db4:	00003517          	auipc	a0,0x3
    4db8:	07450513          	addi	a0,a0,116 # 7e28 <malloc+0x2196>
    4dbc:	00001097          	auipc	ra,0x1
    4dc0:	ad8080e7          	jalr	-1320(ra) # 5894 <open>
    4dc4:	8a2a                	mv	s4,a0
  total = 0;
    4dc6:	4981                	li	s3,0
  for(i = 0; ; i++){
    4dc8:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4dca:	00007917          	auipc	s2,0x7
    4dce:	fce90913          	addi	s2,s2,-50 # bd98 <buf>
  if(fd < 0){
    4dd2:	06054e63          	bltz	a0,4e4e <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4dd6:	12c00613          	li	a2,300
    4dda:	85ca                	mv	a1,s2
    4ddc:	8552                	mv	a0,s4
    4dde:	00001097          	auipc	ra,0x1
    4de2:	a8e080e7          	jalr	-1394(ra) # 586c <read>
    if(cc < 0){
    4de6:	08054263          	bltz	a0,4e6a <bigfile+0x13a>
    if(cc == 0)
    4dea:	c971                	beqz	a0,4ebe <bigfile+0x18e>
    if(cc != SZ/2){
    4dec:	12c00793          	li	a5,300
    4df0:	08f51b63          	bne	a0,a5,4e86 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4df4:	01f4d79b          	srliw	a5,s1,0x1f
    4df8:	9fa5                	addw	a5,a5,s1
    4dfa:	4017d79b          	sraiw	a5,a5,0x1
    4dfe:	00094703          	lbu	a4,0(s2)
    4e02:	0af71063          	bne	a4,a5,4ea2 <bigfile+0x172>
    4e06:	12b94703          	lbu	a4,299(s2)
    4e0a:	08f71c63          	bne	a4,a5,4ea2 <bigfile+0x172>
    total += cc;
    4e0e:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4e12:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4e14:	b7c9                	j	4dd6 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4e16:	85d6                	mv	a1,s5
    4e18:	00003517          	auipc	a0,0x3
    4e1c:	02050513          	addi	a0,a0,32 # 7e38 <malloc+0x21a6>
    4e20:	00001097          	auipc	ra,0x1
    4e24:	db4080e7          	jalr	-588(ra) # 5bd4 <printf>
    exit(1);
    4e28:	4505                	li	a0,1
    4e2a:	00001097          	auipc	ra,0x1
    4e2e:	a2a080e7          	jalr	-1494(ra) # 5854 <exit>
      printf("%s: write bigfile failed\n", s);
    4e32:	85d6                	mv	a1,s5
    4e34:	00003517          	auipc	a0,0x3
    4e38:	02450513          	addi	a0,a0,36 # 7e58 <malloc+0x21c6>
    4e3c:	00001097          	auipc	ra,0x1
    4e40:	d98080e7          	jalr	-616(ra) # 5bd4 <printf>
      exit(1);
    4e44:	4505                	li	a0,1
    4e46:	00001097          	auipc	ra,0x1
    4e4a:	a0e080e7          	jalr	-1522(ra) # 5854 <exit>
    printf("%s: cannot open bigfile\n", s);
    4e4e:	85d6                	mv	a1,s5
    4e50:	00003517          	auipc	a0,0x3
    4e54:	02850513          	addi	a0,a0,40 # 7e78 <malloc+0x21e6>
    4e58:	00001097          	auipc	ra,0x1
    4e5c:	d7c080e7          	jalr	-644(ra) # 5bd4 <printf>
    exit(1);
    4e60:	4505                	li	a0,1
    4e62:	00001097          	auipc	ra,0x1
    4e66:	9f2080e7          	jalr	-1550(ra) # 5854 <exit>
      printf("%s: read bigfile failed\n", s);
    4e6a:	85d6                	mv	a1,s5
    4e6c:	00003517          	auipc	a0,0x3
    4e70:	02c50513          	addi	a0,a0,44 # 7e98 <malloc+0x2206>
    4e74:	00001097          	auipc	ra,0x1
    4e78:	d60080e7          	jalr	-672(ra) # 5bd4 <printf>
      exit(1);
    4e7c:	4505                	li	a0,1
    4e7e:	00001097          	auipc	ra,0x1
    4e82:	9d6080e7          	jalr	-1578(ra) # 5854 <exit>
      printf("%s: short read bigfile\n", s);
    4e86:	85d6                	mv	a1,s5
    4e88:	00003517          	auipc	a0,0x3
    4e8c:	03050513          	addi	a0,a0,48 # 7eb8 <malloc+0x2226>
    4e90:	00001097          	auipc	ra,0x1
    4e94:	d44080e7          	jalr	-700(ra) # 5bd4 <printf>
      exit(1);
    4e98:	4505                	li	a0,1
    4e9a:	00001097          	auipc	ra,0x1
    4e9e:	9ba080e7          	jalr	-1606(ra) # 5854 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4ea2:	85d6                	mv	a1,s5
    4ea4:	00003517          	auipc	a0,0x3
    4ea8:	02c50513          	addi	a0,a0,44 # 7ed0 <malloc+0x223e>
    4eac:	00001097          	auipc	ra,0x1
    4eb0:	d28080e7          	jalr	-728(ra) # 5bd4 <printf>
      exit(1);
    4eb4:	4505                	li	a0,1
    4eb6:	00001097          	auipc	ra,0x1
    4eba:	99e080e7          	jalr	-1634(ra) # 5854 <exit>
  close(fd);
    4ebe:	8552                	mv	a0,s4
    4ec0:	00001097          	auipc	ra,0x1
    4ec4:	9bc080e7          	jalr	-1604(ra) # 587c <close>
  if(total != N*SZ){
    4ec8:	678d                	lui	a5,0x3
    4eca:	ee078793          	addi	a5,a5,-288 # 2ee0 <fourteen+0x106>
    4ece:	02f99363          	bne	s3,a5,4ef4 <bigfile+0x1c4>
  unlink("bigfile.dat");
    4ed2:	00003517          	auipc	a0,0x3
    4ed6:	f5650513          	addi	a0,a0,-170 # 7e28 <malloc+0x2196>
    4eda:	00001097          	auipc	ra,0x1
    4ede:	9ca080e7          	jalr	-1590(ra) # 58a4 <unlink>
}
    4ee2:	70e2                	ld	ra,56(sp)
    4ee4:	7442                	ld	s0,48(sp)
    4ee6:	74a2                	ld	s1,40(sp)
    4ee8:	7902                	ld	s2,32(sp)
    4eea:	69e2                	ld	s3,24(sp)
    4eec:	6a42                	ld	s4,16(sp)
    4eee:	6aa2                	ld	s5,8(sp)
    4ef0:	6121                	addi	sp,sp,64
    4ef2:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4ef4:	85d6                	mv	a1,s5
    4ef6:	00003517          	auipc	a0,0x3
    4efa:	ffa50513          	addi	a0,a0,-6 # 7ef0 <malloc+0x225e>
    4efe:	00001097          	auipc	ra,0x1
    4f02:	cd6080e7          	jalr	-810(ra) # 5bd4 <printf>
    exit(1);
    4f06:	4505                	li	a0,1
    4f08:	00001097          	auipc	ra,0x1
    4f0c:	94c080e7          	jalr	-1716(ra) # 5854 <exit>

0000000000004f10 <fsfull>:
{
    4f10:	7171                	addi	sp,sp,-176
    4f12:	f506                	sd	ra,168(sp)
    4f14:	f122                	sd	s0,160(sp)
    4f16:	ed26                	sd	s1,152(sp)
    4f18:	e94a                	sd	s2,144(sp)
    4f1a:	e54e                	sd	s3,136(sp)
    4f1c:	e152                	sd	s4,128(sp)
    4f1e:	fcd6                	sd	s5,120(sp)
    4f20:	f8da                	sd	s6,112(sp)
    4f22:	f4de                	sd	s7,104(sp)
    4f24:	f0e2                	sd	s8,96(sp)
    4f26:	ece6                	sd	s9,88(sp)
    4f28:	e8ea                	sd	s10,80(sp)
    4f2a:	e4ee                	sd	s11,72(sp)
    4f2c:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4f2e:	00003517          	auipc	a0,0x3
    4f32:	fe250513          	addi	a0,a0,-30 # 7f10 <malloc+0x227e>
    4f36:	00001097          	auipc	ra,0x1
    4f3a:	c9e080e7          	jalr	-866(ra) # 5bd4 <printf>
  for(nfiles = 0; ; nfiles++){
    4f3e:	4481                	li	s1,0
    name[0] = 'f';
    4f40:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4f44:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4f48:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4f4c:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4f4e:	00003c97          	auipc	s9,0x3
    4f52:	fd2c8c93          	addi	s9,s9,-46 # 7f20 <malloc+0x228e>
    int total = 0;
    4f56:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4f58:	00007a17          	auipc	s4,0x7
    4f5c:	e40a0a13          	addi	s4,s4,-448 # bd98 <buf>
    name[0] = 'f';
    4f60:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4f64:	0384c7bb          	divw	a5,s1,s8
    4f68:	0307879b          	addiw	a5,a5,48
    4f6c:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4f70:	0384e7bb          	remw	a5,s1,s8
    4f74:	0377c7bb          	divw	a5,a5,s7
    4f78:	0307879b          	addiw	a5,a5,48
    4f7c:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4f80:	0374e7bb          	remw	a5,s1,s7
    4f84:	0367c7bb          	divw	a5,a5,s6
    4f88:	0307879b          	addiw	a5,a5,48
    4f8c:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4f90:	0364e7bb          	remw	a5,s1,s6
    4f94:	0307879b          	addiw	a5,a5,48
    4f98:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4f9c:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4fa0:	f5040593          	addi	a1,s0,-176
    4fa4:	8566                	mv	a0,s9
    4fa6:	00001097          	auipc	ra,0x1
    4faa:	c2e080e7          	jalr	-978(ra) # 5bd4 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4fae:	20200593          	li	a1,514
    4fb2:	f5040513          	addi	a0,s0,-176
    4fb6:	00001097          	auipc	ra,0x1
    4fba:	8de080e7          	jalr	-1826(ra) # 5894 <open>
    4fbe:	892a                	mv	s2,a0
    if(fd < 0){
    4fc0:	0a055663          	bgez	a0,506c <fsfull+0x15c>
      printf("open %s failed\n", name);
    4fc4:	f5040593          	addi	a1,s0,-176
    4fc8:	00003517          	auipc	a0,0x3
    4fcc:	f6850513          	addi	a0,a0,-152 # 7f30 <malloc+0x229e>
    4fd0:	00001097          	auipc	ra,0x1
    4fd4:	c04080e7          	jalr	-1020(ra) # 5bd4 <printf>
  while(nfiles >= 0){
    4fd8:	0604c363          	bltz	s1,503e <fsfull+0x12e>
    name[0] = 'f';
    4fdc:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4fe0:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4fe4:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4fe8:	4929                	li	s2,10
  while(nfiles >= 0){
    4fea:	5afd                	li	s5,-1
    name[0] = 'f';
    4fec:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4ff0:	0344c7bb          	divw	a5,s1,s4
    4ff4:	0307879b          	addiw	a5,a5,48
    4ff8:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4ffc:	0344e7bb          	remw	a5,s1,s4
    5000:	0337c7bb          	divw	a5,a5,s3
    5004:	0307879b          	addiw	a5,a5,48
    5008:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    500c:	0334e7bb          	remw	a5,s1,s3
    5010:	0327c7bb          	divw	a5,a5,s2
    5014:	0307879b          	addiw	a5,a5,48
    5018:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    501c:	0324e7bb          	remw	a5,s1,s2
    5020:	0307879b          	addiw	a5,a5,48
    5024:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5028:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    502c:	f5040513          	addi	a0,s0,-176
    5030:	00001097          	auipc	ra,0x1
    5034:	874080e7          	jalr	-1932(ra) # 58a4 <unlink>
    nfiles--;
    5038:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    503a:	fb5499e3          	bne	s1,s5,4fec <fsfull+0xdc>
  printf("fsfull test finished\n");
    503e:	00003517          	auipc	a0,0x3
    5042:	f1250513          	addi	a0,a0,-238 # 7f50 <malloc+0x22be>
    5046:	00001097          	auipc	ra,0x1
    504a:	b8e080e7          	jalr	-1138(ra) # 5bd4 <printf>
}
    504e:	70aa                	ld	ra,168(sp)
    5050:	740a                	ld	s0,160(sp)
    5052:	64ea                	ld	s1,152(sp)
    5054:	694a                	ld	s2,144(sp)
    5056:	69aa                	ld	s3,136(sp)
    5058:	6a0a                	ld	s4,128(sp)
    505a:	7ae6                	ld	s5,120(sp)
    505c:	7b46                	ld	s6,112(sp)
    505e:	7ba6                	ld	s7,104(sp)
    5060:	7c06                	ld	s8,96(sp)
    5062:	6ce6                	ld	s9,88(sp)
    5064:	6d46                	ld	s10,80(sp)
    5066:	6da6                	ld	s11,72(sp)
    5068:	614d                	addi	sp,sp,176
    506a:	8082                	ret
    int total = 0;
    506c:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    506e:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    5072:	40000613          	li	a2,1024
    5076:	85d2                	mv	a1,s4
    5078:	854a                	mv	a0,s2
    507a:	00000097          	auipc	ra,0x0
    507e:	7fa080e7          	jalr	2042(ra) # 5874 <write>
      if(cc < BSIZE)
    5082:	00aad563          	bge	s5,a0,508c <fsfull+0x17c>
      total += cc;
    5086:	00a989bb          	addw	s3,s3,a0
    while(1){
    508a:	b7e5                	j	5072 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    508c:	85ce                	mv	a1,s3
    508e:	00003517          	auipc	a0,0x3
    5092:	eb250513          	addi	a0,a0,-334 # 7f40 <malloc+0x22ae>
    5096:	00001097          	auipc	ra,0x1
    509a:	b3e080e7          	jalr	-1218(ra) # 5bd4 <printf>
    close(fd);
    509e:	854a                	mv	a0,s2
    50a0:	00000097          	auipc	ra,0x0
    50a4:	7dc080e7          	jalr	2012(ra) # 587c <close>
    if(total == 0)
    50a8:	f20988e3          	beqz	s3,4fd8 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    50ac:	2485                	addiw	s1,s1,1
    50ae:	bd4d                	j	4f60 <fsfull+0x50>

00000000000050b0 <badwrite>:
{
    50b0:	7179                	addi	sp,sp,-48
    50b2:	f406                	sd	ra,40(sp)
    50b4:	f022                	sd	s0,32(sp)
    50b6:	ec26                	sd	s1,24(sp)
    50b8:	e84a                	sd	s2,16(sp)
    50ba:	e44e                	sd	s3,8(sp)
    50bc:	e052                	sd	s4,0(sp)
    50be:	1800                	addi	s0,sp,48
  unlink("junk");
    50c0:	00003517          	auipc	a0,0x3
    50c4:	ea850513          	addi	a0,a0,-344 # 7f68 <malloc+0x22d6>
    50c8:	00000097          	auipc	ra,0x0
    50cc:	7dc080e7          	jalr	2012(ra) # 58a4 <unlink>
    50d0:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    50d4:	00003997          	auipc	s3,0x3
    50d8:	e9498993          	addi	s3,s3,-364 # 7f68 <malloc+0x22d6>
    write(fd, (char*)0xffffffffffL, 1);
    50dc:	5a7d                	li	s4,-1
    50de:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    50e2:	20100593          	li	a1,513
    50e6:	854e                	mv	a0,s3
    50e8:	00000097          	auipc	ra,0x0
    50ec:	7ac080e7          	jalr	1964(ra) # 5894 <open>
    50f0:	84aa                	mv	s1,a0
    if(fd < 0){
    50f2:	06054b63          	bltz	a0,5168 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    50f6:	4605                	li	a2,1
    50f8:	85d2                	mv	a1,s4
    50fa:	00000097          	auipc	ra,0x0
    50fe:	77a080e7          	jalr	1914(ra) # 5874 <write>
    close(fd);
    5102:	8526                	mv	a0,s1
    5104:	00000097          	auipc	ra,0x0
    5108:	778080e7          	jalr	1912(ra) # 587c <close>
    unlink("junk");
    510c:	854e                	mv	a0,s3
    510e:	00000097          	auipc	ra,0x0
    5112:	796080e7          	jalr	1942(ra) # 58a4 <unlink>
  for(int i = 0; i < assumed_free; i++){
    5116:	397d                	addiw	s2,s2,-1
    5118:	fc0915e3          	bnez	s2,50e2 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    511c:	20100593          	li	a1,513
    5120:	00003517          	auipc	a0,0x3
    5124:	e4850513          	addi	a0,a0,-440 # 7f68 <malloc+0x22d6>
    5128:	00000097          	auipc	ra,0x0
    512c:	76c080e7          	jalr	1900(ra) # 5894 <open>
    5130:	84aa                	mv	s1,a0
  if(fd < 0){
    5132:	04054863          	bltz	a0,5182 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    5136:	4605                	li	a2,1
    5138:	00001597          	auipc	a1,0x1
    513c:	04858593          	addi	a1,a1,72 # 6180 <malloc+0x4ee>
    5140:	00000097          	auipc	ra,0x0
    5144:	734080e7          	jalr	1844(ra) # 5874 <write>
    5148:	4785                	li	a5,1
    514a:	04f50963          	beq	a0,a5,519c <badwrite+0xec>
    printf("write failed\n");
    514e:	00003517          	auipc	a0,0x3
    5152:	e3a50513          	addi	a0,a0,-454 # 7f88 <malloc+0x22f6>
    5156:	00001097          	auipc	ra,0x1
    515a:	a7e080e7          	jalr	-1410(ra) # 5bd4 <printf>
    exit(1);
    515e:	4505                	li	a0,1
    5160:	00000097          	auipc	ra,0x0
    5164:	6f4080e7          	jalr	1780(ra) # 5854 <exit>
      printf("open junk failed\n");
    5168:	00003517          	auipc	a0,0x3
    516c:	e0850513          	addi	a0,a0,-504 # 7f70 <malloc+0x22de>
    5170:	00001097          	auipc	ra,0x1
    5174:	a64080e7          	jalr	-1436(ra) # 5bd4 <printf>
      exit(1);
    5178:	4505                	li	a0,1
    517a:	00000097          	auipc	ra,0x0
    517e:	6da080e7          	jalr	1754(ra) # 5854 <exit>
    printf("open junk failed\n");
    5182:	00003517          	auipc	a0,0x3
    5186:	dee50513          	addi	a0,a0,-530 # 7f70 <malloc+0x22de>
    518a:	00001097          	auipc	ra,0x1
    518e:	a4a080e7          	jalr	-1462(ra) # 5bd4 <printf>
    exit(1);
    5192:	4505                	li	a0,1
    5194:	00000097          	auipc	ra,0x0
    5198:	6c0080e7          	jalr	1728(ra) # 5854 <exit>
  close(fd);
    519c:	8526                	mv	a0,s1
    519e:	00000097          	auipc	ra,0x0
    51a2:	6de080e7          	jalr	1758(ra) # 587c <close>
  unlink("junk");
    51a6:	00003517          	auipc	a0,0x3
    51aa:	dc250513          	addi	a0,a0,-574 # 7f68 <malloc+0x22d6>
    51ae:	00000097          	auipc	ra,0x0
    51b2:	6f6080e7          	jalr	1782(ra) # 58a4 <unlink>
  exit(0);
    51b6:	4501                	li	a0,0
    51b8:	00000097          	auipc	ra,0x0
    51bc:	69c080e7          	jalr	1692(ra) # 5854 <exit>

00000000000051c0 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    51c0:	7139                	addi	sp,sp,-64
    51c2:	fc06                	sd	ra,56(sp)
    51c4:	f822                	sd	s0,48(sp)
    51c6:	f426                	sd	s1,40(sp)
    51c8:	f04a                	sd	s2,32(sp)
    51ca:	ec4e                	sd	s3,24(sp)
    51cc:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    51ce:	fc840513          	addi	a0,s0,-56
    51d2:	00000097          	auipc	ra,0x0
    51d6:	692080e7          	jalr	1682(ra) # 5864 <pipe>
    51da:	06054863          	bltz	a0,524a <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    51de:	00000097          	auipc	ra,0x0
    51e2:	66e080e7          	jalr	1646(ra) # 584c <fork>

  if(pid < 0){
    51e6:	06054f63          	bltz	a0,5264 <countfree+0xa4>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    51ea:	ed59                	bnez	a0,5288 <countfree+0xc8>
    close(fds[0]);
    51ec:	fc842503          	lw	a0,-56(s0)
    51f0:	00000097          	auipc	ra,0x0
    51f4:	68c080e7          	jalr	1676(ra) # 587c <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    51f8:	54fd                	li	s1,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    51fa:	4985                	li	s3,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    51fc:	00001917          	auipc	s2,0x1
    5200:	f8490913          	addi	s2,s2,-124 # 6180 <malloc+0x4ee>
      uint64 a = (uint64) sbrk(4096);
    5204:	6505                	lui	a0,0x1
    5206:	00000097          	auipc	ra,0x0
    520a:	6d6080e7          	jalr	1750(ra) # 58dc <sbrk>
      if(a == 0xffffffffffffffff){
    520e:	06950863          	beq	a0,s1,527e <countfree+0xbe>
      *(char *)(a + 4096 - 1) = 1;
    5212:	6785                	lui	a5,0x1
    5214:	953e                	add	a0,a0,a5
    5216:	ff350fa3          	sb	s3,-1(a0) # fff <bigdir+0x9b>
      if(write(fds[1], "x", 1) != 1){
    521a:	4605                	li	a2,1
    521c:	85ca                	mv	a1,s2
    521e:	fcc42503          	lw	a0,-52(s0)
    5222:	00000097          	auipc	ra,0x0
    5226:	652080e7          	jalr	1618(ra) # 5874 <write>
    522a:	4785                	li	a5,1
    522c:	fcf50ce3          	beq	a0,a5,5204 <countfree+0x44>
        printf("write() failed in countfree()\n");
    5230:	00003517          	auipc	a0,0x3
    5234:	da850513          	addi	a0,a0,-600 # 7fd8 <malloc+0x2346>
    5238:	00001097          	auipc	ra,0x1
    523c:	99c080e7          	jalr	-1636(ra) # 5bd4 <printf>
        exit(1);
    5240:	4505                	li	a0,1
    5242:	00000097          	auipc	ra,0x0
    5246:	612080e7          	jalr	1554(ra) # 5854 <exit>
    printf("pipe() failed in countfree()\n");
    524a:	00003517          	auipc	a0,0x3
    524e:	d4e50513          	addi	a0,a0,-690 # 7f98 <malloc+0x2306>
    5252:	00001097          	auipc	ra,0x1
    5256:	982080e7          	jalr	-1662(ra) # 5bd4 <printf>
    exit(1);
    525a:	4505                	li	a0,1
    525c:	00000097          	auipc	ra,0x0
    5260:	5f8080e7          	jalr	1528(ra) # 5854 <exit>
    printf("fork failed in countfree()\n");
    5264:	00003517          	auipc	a0,0x3
    5268:	d5450513          	addi	a0,a0,-684 # 7fb8 <malloc+0x2326>
    526c:	00001097          	auipc	ra,0x1
    5270:	968080e7          	jalr	-1688(ra) # 5bd4 <printf>
    exit(1);
    5274:	4505                	li	a0,1
    5276:	00000097          	auipc	ra,0x0
    527a:	5de080e7          	jalr	1502(ra) # 5854 <exit>
      }
    }

    exit(0);
    527e:	4501                	li	a0,0
    5280:	00000097          	auipc	ra,0x0
    5284:	5d4080e7          	jalr	1492(ra) # 5854 <exit>
  }

  close(fds[1]);
    5288:	fcc42503          	lw	a0,-52(s0)
    528c:	00000097          	auipc	ra,0x0
    5290:	5f0080e7          	jalr	1520(ra) # 587c <close>

  int n = 0;
    5294:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    5296:	4605                	li	a2,1
    5298:	fc740593          	addi	a1,s0,-57
    529c:	fc842503          	lw	a0,-56(s0)
    52a0:	00000097          	auipc	ra,0x0
    52a4:	5cc080e7          	jalr	1484(ra) # 586c <read>
    if(cc < 0){
    52a8:	00054563          	bltz	a0,52b2 <countfree+0xf2>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    52ac:	c105                	beqz	a0,52cc <countfree+0x10c>
      break;
    n += 1;
    52ae:	2485                	addiw	s1,s1,1
  while(1){
    52b0:	b7dd                	j	5296 <countfree+0xd6>
      printf("read() failed in countfree()\n");
    52b2:	00003517          	auipc	a0,0x3
    52b6:	d4650513          	addi	a0,a0,-698 # 7ff8 <malloc+0x2366>
    52ba:	00001097          	auipc	ra,0x1
    52be:	91a080e7          	jalr	-1766(ra) # 5bd4 <printf>
      exit(1);
    52c2:	4505                	li	a0,1
    52c4:	00000097          	auipc	ra,0x0
    52c8:	590080e7          	jalr	1424(ra) # 5854 <exit>
  }

  close(fds[0]);
    52cc:	fc842503          	lw	a0,-56(s0)
    52d0:	00000097          	auipc	ra,0x0
    52d4:	5ac080e7          	jalr	1452(ra) # 587c <close>
  wait((int*)0);
    52d8:	4501                	li	a0,0
    52da:	00000097          	auipc	ra,0x0
    52de:	582080e7          	jalr	1410(ra) # 585c <wait>
  
  return n;
}
    52e2:	8526                	mv	a0,s1
    52e4:	70e2                	ld	ra,56(sp)
    52e6:	7442                	ld	s0,48(sp)
    52e8:	74a2                	ld	s1,40(sp)
    52ea:	7902                	ld	s2,32(sp)
    52ec:	69e2                	ld	s3,24(sp)
    52ee:	6121                	addi	sp,sp,64
    52f0:	8082                	ret

00000000000052f2 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    52f2:	7179                	addi	sp,sp,-48
    52f4:	f406                	sd	ra,40(sp)
    52f6:	f022                	sd	s0,32(sp)
    52f8:	ec26                	sd	s1,24(sp)
    52fa:	e84a                	sd	s2,16(sp)
    52fc:	1800                	addi	s0,sp,48
    52fe:	84aa                	mv	s1,a0
    5300:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5302:	00003517          	auipc	a0,0x3
    5306:	d1650513          	addi	a0,a0,-746 # 8018 <malloc+0x2386>
    530a:	00001097          	auipc	ra,0x1
    530e:	8ca080e7          	jalr	-1846(ra) # 5bd4 <printf>
  if((pid = fork()) < 0) {
    5312:	00000097          	auipc	ra,0x0
    5316:	53a080e7          	jalr	1338(ra) # 584c <fork>
    531a:	02054e63          	bltz	a0,5356 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    531e:	c929                	beqz	a0,5370 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5320:	fdc40513          	addi	a0,s0,-36
    5324:	00000097          	auipc	ra,0x0
    5328:	538080e7          	jalr	1336(ra) # 585c <wait>
    if(xstatus != 0) 
    532c:	fdc42783          	lw	a5,-36(s0)
    5330:	c7b9                	beqz	a5,537e <run+0x8c>
      printf("FAILED\n");
    5332:	00003517          	auipc	a0,0x3
    5336:	d0e50513          	addi	a0,a0,-754 # 8040 <malloc+0x23ae>
    533a:	00001097          	auipc	ra,0x1
    533e:	89a080e7          	jalr	-1894(ra) # 5bd4 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5342:	fdc42503          	lw	a0,-36(s0)
  }
}
    5346:	00153513          	seqz	a0,a0
    534a:	70a2                	ld	ra,40(sp)
    534c:	7402                	ld	s0,32(sp)
    534e:	64e2                	ld	s1,24(sp)
    5350:	6942                	ld	s2,16(sp)
    5352:	6145                	addi	sp,sp,48
    5354:	8082                	ret
    printf("runtest: fork error\n");
    5356:	00003517          	auipc	a0,0x3
    535a:	cd250513          	addi	a0,a0,-814 # 8028 <malloc+0x2396>
    535e:	00001097          	auipc	ra,0x1
    5362:	876080e7          	jalr	-1930(ra) # 5bd4 <printf>
    exit(1);
    5366:	4505                	li	a0,1
    5368:	00000097          	auipc	ra,0x0
    536c:	4ec080e7          	jalr	1260(ra) # 5854 <exit>
    f(s);
    5370:	854a                	mv	a0,s2
    5372:	9482                	jalr	s1
    exit(0);
    5374:	4501                	li	a0,0
    5376:	00000097          	auipc	ra,0x0
    537a:	4de080e7          	jalr	1246(ra) # 5854 <exit>
      printf("OK\n");
    537e:	00003517          	auipc	a0,0x3
    5382:	cca50513          	addi	a0,a0,-822 # 8048 <malloc+0x23b6>
    5386:	00001097          	auipc	ra,0x1
    538a:	84e080e7          	jalr	-1970(ra) # 5bd4 <printf>
    538e:	bf55                	j	5342 <run+0x50>

0000000000005390 <main>:

int
main(int argc, char *argv[])
{
    5390:	bd010113          	addi	sp,sp,-1072
    5394:	42113423          	sd	ra,1064(sp)
    5398:	42813023          	sd	s0,1056(sp)
    539c:	40913c23          	sd	s1,1048(sp)
    53a0:	41213823          	sd	s2,1040(sp)
    53a4:	41313423          	sd	s3,1032(sp)
    53a8:	41413023          	sd	s4,1024(sp)
    53ac:	3f513c23          	sd	s5,1016(sp)
    53b0:	3f613823          	sd	s6,1008(sp)
    53b4:	43010413          	addi	s0,sp,1072
    53b8:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    53ba:	4789                	li	a5,2
    53bc:	08f50f63          	beq	a0,a5,545a <main+0xca>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    53c0:	4785                	li	a5,1
  char *justone = 0;
    53c2:	4901                	li	s2,0
  } else if(argc > 1){
    53c4:	0ca7c963          	blt	a5,a0,5496 <main+0x106>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    53c8:	00003797          	auipc	a5,0x3
    53cc:	d9878793          	addi	a5,a5,-616 # 8160 <malloc+0x24ce>
    53d0:	bd040713          	addi	a4,s0,-1072
    53d4:	00003317          	auipc	t1,0x3
    53d8:	17c30313          	addi	t1,t1,380 # 8550 <malloc+0x28be>
    53dc:	0007b883          	ld	a7,0(a5)
    53e0:	0087b803          	ld	a6,8(a5)
    53e4:	6b88                	ld	a0,16(a5)
    53e6:	6f8c                	ld	a1,24(a5)
    53e8:	7390                	ld	a2,32(a5)
    53ea:	7794                	ld	a3,40(a5)
    53ec:	01173023          	sd	a7,0(a4)
    53f0:	01073423          	sd	a6,8(a4)
    53f4:	eb08                	sd	a0,16(a4)
    53f6:	ef0c                	sd	a1,24(a4)
    53f8:	f310                	sd	a2,32(a4)
    53fa:	f714                	sd	a3,40(a4)
    53fc:	03078793          	addi	a5,a5,48
    5400:	03070713          	addi	a4,a4,48
    5404:	fc679ce3          	bne	a5,t1,53dc <main+0x4c>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    5408:	00003517          	auipc	a0,0x3
    540c:	cf850513          	addi	a0,a0,-776 # 8100 <malloc+0x246e>
    5410:	00000097          	auipc	ra,0x0
    5414:	7c4080e7          	jalr	1988(ra) # 5bd4 <printf>
  int free0 = countfree();
    5418:	00000097          	auipc	ra,0x0
    541c:	da8080e7          	jalr	-600(ra) # 51c0 <countfree>
    5420:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    5422:	bd843503          	ld	a0,-1064(s0)
    5426:	bd040493          	addi	s1,s0,-1072
  int fail = 0;
    542a:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    542c:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    542e:	e55d                	bnez	a0,54dc <main+0x14c>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    5430:	00000097          	auipc	ra,0x0
    5434:	d90080e7          	jalr	-624(ra) # 51c0 <countfree>
    5438:	85aa                	mv	a1,a0
    543a:	0f455163          	bge	a0,s4,551c <main+0x18c>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    543e:	8652                	mv	a2,s4
    5440:	00003517          	auipc	a0,0x3
    5444:	c7850513          	addi	a0,a0,-904 # 80b8 <malloc+0x2426>
    5448:	00000097          	auipc	ra,0x0
    544c:	78c080e7          	jalr	1932(ra) # 5bd4 <printf>
    exit(1);
    5450:	4505                	li	a0,1
    5452:	00000097          	auipc	ra,0x0
    5456:	402080e7          	jalr	1026(ra) # 5854 <exit>
    545a:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    545c:	00003597          	auipc	a1,0x3
    5460:	bf458593          	addi	a1,a1,-1036 # 8050 <malloc+0x23be>
    5464:	6488                	ld	a0,8(s1)
    5466:	00000097          	auipc	ra,0x0
    546a:	194080e7          	jalr	404(ra) # 55fa <strcmp>
    546e:	10050563          	beqz	a0,5578 <main+0x1e8>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5472:	00003597          	auipc	a1,0x3
    5476:	cc658593          	addi	a1,a1,-826 # 8138 <malloc+0x24a6>
    547a:	6488                	ld	a0,8(s1)
    547c:	00000097          	auipc	ra,0x0
    5480:	17e080e7          	jalr	382(ra) # 55fa <strcmp>
    5484:	c97d                	beqz	a0,557a <main+0x1ea>
  } else if(argc == 2 && argv[1][0] != '-'){
    5486:	0084b903          	ld	s2,8(s1)
    548a:	00094703          	lbu	a4,0(s2)
    548e:	02d00793          	li	a5,45
    5492:	f2f71be3          	bne	a4,a5,53c8 <main+0x38>
    printf("Usage: usertests [-c] [testname]\n");
    5496:	00003517          	auipc	a0,0x3
    549a:	bc250513          	addi	a0,a0,-1086 # 8058 <malloc+0x23c6>
    549e:	00000097          	auipc	ra,0x0
    54a2:	736080e7          	jalr	1846(ra) # 5bd4 <printf>
    exit(1);
    54a6:	4505                	li	a0,1
    54a8:	00000097          	auipc	ra,0x0
    54ac:	3ac080e7          	jalr	940(ra) # 5854 <exit>
          exit(1);
    54b0:	4505                	li	a0,1
    54b2:	00000097          	auipc	ra,0x0
    54b6:	3a2080e7          	jalr	930(ra) # 5854 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    54ba:	40a905bb          	subw	a1,s2,a0
    54be:	855a                	mv	a0,s6
    54c0:	00000097          	auipc	ra,0x0
    54c4:	714080e7          	jalr	1812(ra) # 5bd4 <printf>
        if(continuous != 2)
    54c8:	09498463          	beq	s3,s4,5550 <main+0x1c0>
          exit(1);
    54cc:	4505                	li	a0,1
    54ce:	00000097          	auipc	ra,0x0
    54d2:	386080e7          	jalr	902(ra) # 5854 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    54d6:	04c1                	addi	s1,s1,16
    54d8:	6488                	ld	a0,8(s1)
    54da:	c115                	beqz	a0,54fe <main+0x16e>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    54dc:	00090863          	beqz	s2,54ec <main+0x15c>
    54e0:	85ca                	mv	a1,s2
    54e2:	00000097          	auipc	ra,0x0
    54e6:	118080e7          	jalr	280(ra) # 55fa <strcmp>
    54ea:	f575                	bnez	a0,54d6 <main+0x146>
      if(!run(t->f, t->s))
    54ec:	648c                	ld	a1,8(s1)
    54ee:	6088                	ld	a0,0(s1)
    54f0:	00000097          	auipc	ra,0x0
    54f4:	e02080e7          	jalr	-510(ra) # 52f2 <run>
    54f8:	fd79                	bnez	a0,54d6 <main+0x146>
        fail = 1;
    54fa:	89d6                	mv	s3,s5
    54fc:	bfe9                	j	54d6 <main+0x146>
  if(fail){
    54fe:	f20989e3          	beqz	s3,5430 <main+0xa0>
    printf("SOME TESTS FAILED\n");
    5502:	00003517          	auipc	a0,0x3
    5506:	b9e50513          	addi	a0,a0,-1122 # 80a0 <malloc+0x240e>
    550a:	00000097          	auipc	ra,0x0
    550e:	6ca080e7          	jalr	1738(ra) # 5bd4 <printf>
    exit(1);
    5512:	4505                	li	a0,1
    5514:	00000097          	auipc	ra,0x0
    5518:	340080e7          	jalr	832(ra) # 5854 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    551c:	00003517          	auipc	a0,0x3
    5520:	bcc50513          	addi	a0,a0,-1076 # 80e8 <malloc+0x2456>
    5524:	00000097          	auipc	ra,0x0
    5528:	6b0080e7          	jalr	1712(ra) # 5bd4 <printf>
    exit(0);
    552c:	4501                	li	a0,0
    552e:	00000097          	auipc	ra,0x0
    5532:	326080e7          	jalr	806(ra) # 5854 <exit>
        printf("SOME TESTS FAILED\n");
    5536:	8556                	mv	a0,s5
    5538:	00000097          	auipc	ra,0x0
    553c:	69c080e7          	jalr	1692(ra) # 5bd4 <printf>
        if(continuous != 2)
    5540:	f74998e3          	bne	s3,s4,54b0 <main+0x120>
      int free1 = countfree();
    5544:	00000097          	auipc	ra,0x0
    5548:	c7c080e7          	jalr	-900(ra) # 51c0 <countfree>
      if(free1 < free0){
    554c:	f72547e3          	blt	a0,s2,54ba <main+0x12a>
      int free0 = countfree();
    5550:	00000097          	auipc	ra,0x0
    5554:	c70080e7          	jalr	-912(ra) # 51c0 <countfree>
    5558:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    555a:	bd843583          	ld	a1,-1064(s0)
    555e:	d1fd                	beqz	a1,5544 <main+0x1b4>
    5560:	bd040493          	addi	s1,s0,-1072
        if(!run(t->f, t->s)){
    5564:	6088                	ld	a0,0(s1)
    5566:	00000097          	auipc	ra,0x0
    556a:	d8c080e7          	jalr	-628(ra) # 52f2 <run>
    556e:	d561                	beqz	a0,5536 <main+0x1a6>
      for (struct test *t = tests; t->s != 0; t++) {
    5570:	04c1                	addi	s1,s1,16
    5572:	648c                	ld	a1,8(s1)
    5574:	f9e5                	bnez	a1,5564 <main+0x1d4>
    5576:	b7f9                	j	5544 <main+0x1b4>
    continuous = 1;
    5578:	4985                	li	s3,1
  } tests[] = {
    557a:	00003797          	auipc	a5,0x3
    557e:	be678793          	addi	a5,a5,-1050 # 8160 <malloc+0x24ce>
    5582:	bd040713          	addi	a4,s0,-1072
    5586:	00003317          	auipc	t1,0x3
    558a:	fca30313          	addi	t1,t1,-54 # 8550 <malloc+0x28be>
    558e:	0007b883          	ld	a7,0(a5)
    5592:	0087b803          	ld	a6,8(a5)
    5596:	6b88                	ld	a0,16(a5)
    5598:	6f8c                	ld	a1,24(a5)
    559a:	7390                	ld	a2,32(a5)
    559c:	7794                	ld	a3,40(a5)
    559e:	01173023          	sd	a7,0(a4)
    55a2:	01073423          	sd	a6,8(a4)
    55a6:	eb08                	sd	a0,16(a4)
    55a8:	ef0c                	sd	a1,24(a4)
    55aa:	f310                	sd	a2,32(a4)
    55ac:	f714                	sd	a3,40(a4)
    55ae:	03078793          	addi	a5,a5,48
    55b2:	03070713          	addi	a4,a4,48
    55b6:	fc679ce3          	bne	a5,t1,558e <main+0x1fe>
    printf("continuous usertests starting\n");
    55ba:	00003517          	auipc	a0,0x3
    55be:	b5e50513          	addi	a0,a0,-1186 # 8118 <malloc+0x2486>
    55c2:	00000097          	auipc	ra,0x0
    55c6:	612080e7          	jalr	1554(ra) # 5bd4 <printf>
        printf("SOME TESTS FAILED\n");
    55ca:	00003a97          	auipc	s5,0x3
    55ce:	ad6a8a93          	addi	s5,s5,-1322 # 80a0 <malloc+0x240e>
        if(continuous != 2)
    55d2:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    55d4:	00003b17          	auipc	s6,0x3
    55d8:	aacb0b13          	addi	s6,s6,-1364 # 8080 <malloc+0x23ee>
    55dc:	bf95                	j	5550 <main+0x1c0>

00000000000055de <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    55de:	1141                	addi	sp,sp,-16
    55e0:	e422                	sd	s0,8(sp)
    55e2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    55e4:	87aa                	mv	a5,a0
    55e6:	0585                	addi	a1,a1,1
    55e8:	0785                	addi	a5,a5,1
    55ea:	fff5c703          	lbu	a4,-1(a1)
    55ee:	fee78fa3          	sb	a4,-1(a5)
    55f2:	fb75                	bnez	a4,55e6 <strcpy+0x8>
    ;
  return os;
}
    55f4:	6422                	ld	s0,8(sp)
    55f6:	0141                	addi	sp,sp,16
    55f8:	8082                	ret

00000000000055fa <strcmp>:

int
strcmp(const char *p, const char *q)
{
    55fa:	1141                	addi	sp,sp,-16
    55fc:	e422                	sd	s0,8(sp)
    55fe:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5600:	00054783          	lbu	a5,0(a0)
    5604:	cb91                	beqz	a5,5618 <strcmp+0x1e>
    5606:	0005c703          	lbu	a4,0(a1)
    560a:	00f71763          	bne	a4,a5,5618 <strcmp+0x1e>
    p++, q++;
    560e:	0505                	addi	a0,a0,1
    5610:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5612:	00054783          	lbu	a5,0(a0)
    5616:	fbe5                	bnez	a5,5606 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5618:	0005c503          	lbu	a0,0(a1)
}
    561c:	40a7853b          	subw	a0,a5,a0
    5620:	6422                	ld	s0,8(sp)
    5622:	0141                	addi	sp,sp,16
    5624:	8082                	ret

0000000000005626 <strlen>:

uint
strlen(const char *s)
{
    5626:	1141                	addi	sp,sp,-16
    5628:	e422                	sd	s0,8(sp)
    562a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    562c:	00054783          	lbu	a5,0(a0)
    5630:	cf91                	beqz	a5,564c <strlen+0x26>
    5632:	0505                	addi	a0,a0,1
    5634:	87aa                	mv	a5,a0
    5636:	4685                	li	a3,1
    5638:	9e89                	subw	a3,a3,a0
    563a:	00f6853b          	addw	a0,a3,a5
    563e:	0785                	addi	a5,a5,1
    5640:	fff7c703          	lbu	a4,-1(a5)
    5644:	fb7d                	bnez	a4,563a <strlen+0x14>
    ;
  return n;
}
    5646:	6422                	ld	s0,8(sp)
    5648:	0141                	addi	sp,sp,16
    564a:	8082                	ret
  for(n = 0; s[n]; n++)
    564c:	4501                	li	a0,0
    564e:	bfe5                	j	5646 <strlen+0x20>

0000000000005650 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5650:	1141                	addi	sp,sp,-16
    5652:	e422                	sd	s0,8(sp)
    5654:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5656:	ce09                	beqz	a2,5670 <memset+0x20>
    5658:	87aa                	mv	a5,a0
    565a:	fff6071b          	addiw	a4,a2,-1
    565e:	1702                	slli	a4,a4,0x20
    5660:	9301                	srli	a4,a4,0x20
    5662:	0705                	addi	a4,a4,1
    5664:	972a                	add	a4,a4,a0
    cdst[i] = c;
    5666:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    566a:	0785                	addi	a5,a5,1
    566c:	fee79de3          	bne	a5,a4,5666 <memset+0x16>
  }
  return dst;
}
    5670:	6422                	ld	s0,8(sp)
    5672:	0141                	addi	sp,sp,16
    5674:	8082                	ret

0000000000005676 <strchr>:

char*
strchr(const char *s, char c)
{
    5676:	1141                	addi	sp,sp,-16
    5678:	e422                	sd	s0,8(sp)
    567a:	0800                	addi	s0,sp,16
  for(; *s; s++)
    567c:	00054783          	lbu	a5,0(a0)
    5680:	cb99                	beqz	a5,5696 <strchr+0x20>
    if(*s == c)
    5682:	00f58763          	beq	a1,a5,5690 <strchr+0x1a>
  for(; *s; s++)
    5686:	0505                	addi	a0,a0,1
    5688:	00054783          	lbu	a5,0(a0)
    568c:	fbfd                	bnez	a5,5682 <strchr+0xc>
      return (char*)s;
  return 0;
    568e:	4501                	li	a0,0
}
    5690:	6422                	ld	s0,8(sp)
    5692:	0141                	addi	sp,sp,16
    5694:	8082                	ret
  return 0;
    5696:	4501                	li	a0,0
    5698:	bfe5                	j	5690 <strchr+0x1a>

000000000000569a <gets>:

char*
gets(char *buf, int max)
{
    569a:	711d                	addi	sp,sp,-96
    569c:	ec86                	sd	ra,88(sp)
    569e:	e8a2                	sd	s0,80(sp)
    56a0:	e4a6                	sd	s1,72(sp)
    56a2:	e0ca                	sd	s2,64(sp)
    56a4:	fc4e                	sd	s3,56(sp)
    56a6:	f852                	sd	s4,48(sp)
    56a8:	f456                	sd	s5,40(sp)
    56aa:	f05a                	sd	s6,32(sp)
    56ac:	ec5e                	sd	s7,24(sp)
    56ae:	1080                	addi	s0,sp,96
    56b0:	8baa                	mv	s7,a0
    56b2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    56b4:	892a                	mv	s2,a0
    56b6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    56b8:	4aa9                	li	s5,10
    56ba:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    56bc:	89a6                	mv	s3,s1
    56be:	2485                	addiw	s1,s1,1
    56c0:	0344d863          	bge	s1,s4,56f0 <gets+0x56>
    cc = read(0, &c, 1);
    56c4:	4605                	li	a2,1
    56c6:	faf40593          	addi	a1,s0,-81
    56ca:	4501                	li	a0,0
    56cc:	00000097          	auipc	ra,0x0
    56d0:	1a0080e7          	jalr	416(ra) # 586c <read>
    if(cc < 1)
    56d4:	00a05e63          	blez	a0,56f0 <gets+0x56>
    buf[i++] = c;
    56d8:	faf44783          	lbu	a5,-81(s0)
    56dc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    56e0:	01578763          	beq	a5,s5,56ee <gets+0x54>
    56e4:	0905                	addi	s2,s2,1
    56e6:	fd679be3          	bne	a5,s6,56bc <gets+0x22>
  for(i=0; i+1 < max; ){
    56ea:	89a6                	mv	s3,s1
    56ec:	a011                	j	56f0 <gets+0x56>
    56ee:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    56f0:	99de                	add	s3,s3,s7
    56f2:	00098023          	sb	zero,0(s3)
  return buf;
}
    56f6:	855e                	mv	a0,s7
    56f8:	60e6                	ld	ra,88(sp)
    56fa:	6446                	ld	s0,80(sp)
    56fc:	64a6                	ld	s1,72(sp)
    56fe:	6906                	ld	s2,64(sp)
    5700:	79e2                	ld	s3,56(sp)
    5702:	7a42                	ld	s4,48(sp)
    5704:	7aa2                	ld	s5,40(sp)
    5706:	7b02                	ld	s6,32(sp)
    5708:	6be2                	ld	s7,24(sp)
    570a:	6125                	addi	sp,sp,96
    570c:	8082                	ret

000000000000570e <stat>:

int
stat(const char *n, struct stat *st)
{
    570e:	1101                	addi	sp,sp,-32
    5710:	ec06                	sd	ra,24(sp)
    5712:	e822                	sd	s0,16(sp)
    5714:	e426                	sd	s1,8(sp)
    5716:	e04a                	sd	s2,0(sp)
    5718:	1000                	addi	s0,sp,32
    571a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    571c:	4581                	li	a1,0
    571e:	00000097          	auipc	ra,0x0
    5722:	176080e7          	jalr	374(ra) # 5894 <open>
  if(fd < 0)
    5726:	02054563          	bltz	a0,5750 <stat+0x42>
    572a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    572c:	85ca                	mv	a1,s2
    572e:	00000097          	auipc	ra,0x0
    5732:	17e080e7          	jalr	382(ra) # 58ac <fstat>
    5736:	892a                	mv	s2,a0
  close(fd);
    5738:	8526                	mv	a0,s1
    573a:	00000097          	auipc	ra,0x0
    573e:	142080e7          	jalr	322(ra) # 587c <close>
  return r;
}
    5742:	854a                	mv	a0,s2
    5744:	60e2                	ld	ra,24(sp)
    5746:	6442                	ld	s0,16(sp)
    5748:	64a2                	ld	s1,8(sp)
    574a:	6902                	ld	s2,0(sp)
    574c:	6105                	addi	sp,sp,32
    574e:	8082                	ret
    return -1;
    5750:	597d                	li	s2,-1
    5752:	bfc5                	j	5742 <stat+0x34>

0000000000005754 <atoi>:

int
atoi(const char *s)
{
    5754:	1141                	addi	sp,sp,-16
    5756:	e422                	sd	s0,8(sp)
    5758:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    575a:	00054603          	lbu	a2,0(a0)
    575e:	fd06079b          	addiw	a5,a2,-48
    5762:	0ff7f793          	andi	a5,a5,255
    5766:	4725                	li	a4,9
    5768:	02f76963          	bltu	a4,a5,579a <atoi+0x46>
    576c:	86aa                	mv	a3,a0
  n = 0;
    576e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    5770:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5772:	0685                	addi	a3,a3,1
    5774:	0025179b          	slliw	a5,a0,0x2
    5778:	9fa9                	addw	a5,a5,a0
    577a:	0017979b          	slliw	a5,a5,0x1
    577e:	9fb1                	addw	a5,a5,a2
    5780:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5784:	0006c603          	lbu	a2,0(a3) # 1000 <bigdir+0x9c>
    5788:	fd06071b          	addiw	a4,a2,-48
    578c:	0ff77713          	andi	a4,a4,255
    5790:	fee5f1e3          	bgeu	a1,a4,5772 <atoi+0x1e>
  return n;
}
    5794:	6422                	ld	s0,8(sp)
    5796:	0141                	addi	sp,sp,16
    5798:	8082                	ret
  n = 0;
    579a:	4501                	li	a0,0
    579c:	bfe5                	j	5794 <atoi+0x40>

000000000000579e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    579e:	1141                	addi	sp,sp,-16
    57a0:	e422                	sd	s0,8(sp)
    57a2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    57a4:	02b57663          	bgeu	a0,a1,57d0 <memmove+0x32>
    while(n-- > 0)
    57a8:	02c05163          	blez	a2,57ca <memmove+0x2c>
    57ac:	fff6079b          	addiw	a5,a2,-1
    57b0:	1782                	slli	a5,a5,0x20
    57b2:	9381                	srli	a5,a5,0x20
    57b4:	0785                	addi	a5,a5,1
    57b6:	97aa                	add	a5,a5,a0
  dst = vdst;
    57b8:	872a                	mv	a4,a0
      *dst++ = *src++;
    57ba:	0585                	addi	a1,a1,1
    57bc:	0705                	addi	a4,a4,1
    57be:	fff5c683          	lbu	a3,-1(a1)
    57c2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    57c6:	fee79ae3          	bne	a5,a4,57ba <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    57ca:	6422                	ld	s0,8(sp)
    57cc:	0141                	addi	sp,sp,16
    57ce:	8082                	ret
    dst += n;
    57d0:	00c50733          	add	a4,a0,a2
    src += n;
    57d4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    57d6:	fec05ae3          	blez	a2,57ca <memmove+0x2c>
    57da:	fff6079b          	addiw	a5,a2,-1
    57de:	1782                	slli	a5,a5,0x20
    57e0:	9381                	srli	a5,a5,0x20
    57e2:	fff7c793          	not	a5,a5
    57e6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    57e8:	15fd                	addi	a1,a1,-1
    57ea:	177d                	addi	a4,a4,-1
    57ec:	0005c683          	lbu	a3,0(a1)
    57f0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    57f4:	fee79ae3          	bne	a5,a4,57e8 <memmove+0x4a>
    57f8:	bfc9                	j	57ca <memmove+0x2c>

00000000000057fa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    57fa:	1141                	addi	sp,sp,-16
    57fc:	e422                	sd	s0,8(sp)
    57fe:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5800:	ca05                	beqz	a2,5830 <memcmp+0x36>
    5802:	fff6069b          	addiw	a3,a2,-1
    5806:	1682                	slli	a3,a3,0x20
    5808:	9281                	srli	a3,a3,0x20
    580a:	0685                	addi	a3,a3,1
    580c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    580e:	00054783          	lbu	a5,0(a0)
    5812:	0005c703          	lbu	a4,0(a1)
    5816:	00e79863          	bne	a5,a4,5826 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    581a:	0505                	addi	a0,a0,1
    p2++;
    581c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    581e:	fed518e3          	bne	a0,a3,580e <memcmp+0x14>
  }
  return 0;
    5822:	4501                	li	a0,0
    5824:	a019                	j	582a <memcmp+0x30>
      return *p1 - *p2;
    5826:	40e7853b          	subw	a0,a5,a4
}
    582a:	6422                	ld	s0,8(sp)
    582c:	0141                	addi	sp,sp,16
    582e:	8082                	ret
  return 0;
    5830:	4501                	li	a0,0
    5832:	bfe5                	j	582a <memcmp+0x30>

0000000000005834 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5834:	1141                	addi	sp,sp,-16
    5836:	e406                	sd	ra,8(sp)
    5838:	e022                	sd	s0,0(sp)
    583a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    583c:	00000097          	auipc	ra,0x0
    5840:	f62080e7          	jalr	-158(ra) # 579e <memmove>
}
    5844:	60a2                	ld	ra,8(sp)
    5846:	6402                	ld	s0,0(sp)
    5848:	0141                	addi	sp,sp,16
    584a:	8082                	ret

000000000000584c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    584c:	4885                	li	a7,1
 ecall
    584e:	00000073          	ecall
 ret
    5852:	8082                	ret

0000000000005854 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5854:	4889                	li	a7,2
 ecall
    5856:	00000073          	ecall
 ret
    585a:	8082                	ret

000000000000585c <wait>:
.global wait
wait:
 li a7, SYS_wait
    585c:	488d                	li	a7,3
 ecall
    585e:	00000073          	ecall
 ret
    5862:	8082                	ret

0000000000005864 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5864:	4891                	li	a7,4
 ecall
    5866:	00000073          	ecall
 ret
    586a:	8082                	ret

000000000000586c <read>:
.global read
read:
 li a7, SYS_read
    586c:	4895                	li	a7,5
 ecall
    586e:	00000073          	ecall
 ret
    5872:	8082                	ret

0000000000005874 <write>:
.global write
write:
 li a7, SYS_write
    5874:	48c1                	li	a7,16
 ecall
    5876:	00000073          	ecall
 ret
    587a:	8082                	ret

000000000000587c <close>:
.global close
close:
 li a7, SYS_close
    587c:	48d5                	li	a7,21
 ecall
    587e:	00000073          	ecall
 ret
    5882:	8082                	ret

0000000000005884 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5884:	4899                	li	a7,6
 ecall
    5886:	00000073          	ecall
 ret
    588a:	8082                	ret

000000000000588c <exec>:
.global exec
exec:
 li a7, SYS_exec
    588c:	489d                	li	a7,7
 ecall
    588e:	00000073          	ecall
 ret
    5892:	8082                	ret

0000000000005894 <open>:
.global open
open:
 li a7, SYS_open
    5894:	48bd                	li	a7,15
 ecall
    5896:	00000073          	ecall
 ret
    589a:	8082                	ret

000000000000589c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    589c:	48c5                	li	a7,17
 ecall
    589e:	00000073          	ecall
 ret
    58a2:	8082                	ret

00000000000058a4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    58a4:	48c9                	li	a7,18
 ecall
    58a6:	00000073          	ecall
 ret
    58aa:	8082                	ret

00000000000058ac <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    58ac:	48a1                	li	a7,8
 ecall
    58ae:	00000073          	ecall
 ret
    58b2:	8082                	ret

00000000000058b4 <link>:
.global link
link:
 li a7, SYS_link
    58b4:	48cd                	li	a7,19
 ecall
    58b6:	00000073          	ecall
 ret
    58ba:	8082                	ret

00000000000058bc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    58bc:	48d1                	li	a7,20
 ecall
    58be:	00000073          	ecall
 ret
    58c2:	8082                	ret

00000000000058c4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    58c4:	48a5                	li	a7,9
 ecall
    58c6:	00000073          	ecall
 ret
    58ca:	8082                	ret

00000000000058cc <dup>:
.global dup
dup:
 li a7, SYS_dup
    58cc:	48a9                	li	a7,10
 ecall
    58ce:	00000073          	ecall
 ret
    58d2:	8082                	ret

00000000000058d4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    58d4:	48ad                	li	a7,11
 ecall
    58d6:	00000073          	ecall
 ret
    58da:	8082                	ret

00000000000058dc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    58dc:	48b1                	li	a7,12
 ecall
    58de:	00000073          	ecall
 ret
    58e2:	8082                	ret

00000000000058e4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    58e4:	48b5                	li	a7,13
 ecall
    58e6:	00000073          	ecall
 ret
    58ea:	8082                	ret

00000000000058ec <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    58ec:	48b9                	li	a7,14
 ecall
    58ee:	00000073          	ecall
 ret
    58f2:	8082                	ret

00000000000058f4 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
    58f4:	48d9                	li	a7,22
 ecall
    58f6:	00000073          	ecall
 ret
    58fa:	8082                	ret

00000000000058fc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    58fc:	1101                	addi	sp,sp,-32
    58fe:	ec06                	sd	ra,24(sp)
    5900:	e822                	sd	s0,16(sp)
    5902:	1000                	addi	s0,sp,32
    5904:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5908:	4605                	li	a2,1
    590a:	fef40593          	addi	a1,s0,-17
    590e:	00000097          	auipc	ra,0x0
    5912:	f66080e7          	jalr	-154(ra) # 5874 <write>
}
    5916:	60e2                	ld	ra,24(sp)
    5918:	6442                	ld	s0,16(sp)
    591a:	6105                	addi	sp,sp,32
    591c:	8082                	ret

000000000000591e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    591e:	7139                	addi	sp,sp,-64
    5920:	fc06                	sd	ra,56(sp)
    5922:	f822                	sd	s0,48(sp)
    5924:	f426                	sd	s1,40(sp)
    5926:	f04a                	sd	s2,32(sp)
    5928:	ec4e                	sd	s3,24(sp)
    592a:	0080                	addi	s0,sp,64
    592c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    592e:	c299                	beqz	a3,5934 <printint+0x16>
    5930:	0805c863          	bltz	a1,59c0 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5934:	2581                	sext.w	a1,a1
  neg = 0;
    5936:	4881                	li	a7,0
    5938:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    593c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    593e:	2601                	sext.w	a2,a2
    5940:	00003517          	auipc	a0,0x3
    5944:	c1850513          	addi	a0,a0,-1000 # 8558 <digits>
    5948:	883a                	mv	a6,a4
    594a:	2705                	addiw	a4,a4,1
    594c:	02c5f7bb          	remuw	a5,a1,a2
    5950:	1782                	slli	a5,a5,0x20
    5952:	9381                	srli	a5,a5,0x20
    5954:	97aa                	add	a5,a5,a0
    5956:	0007c783          	lbu	a5,0(a5)
    595a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    595e:	0005879b          	sext.w	a5,a1
    5962:	02c5d5bb          	divuw	a1,a1,a2
    5966:	0685                	addi	a3,a3,1
    5968:	fec7f0e3          	bgeu	a5,a2,5948 <printint+0x2a>
  if(neg)
    596c:	00088b63          	beqz	a7,5982 <printint+0x64>
    buf[i++] = '-';
    5970:	fd040793          	addi	a5,s0,-48
    5974:	973e                	add	a4,a4,a5
    5976:	02d00793          	li	a5,45
    597a:	fef70823          	sb	a5,-16(a4)
    597e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5982:	02e05863          	blez	a4,59b2 <printint+0x94>
    5986:	fc040793          	addi	a5,s0,-64
    598a:	00e78933          	add	s2,a5,a4
    598e:	fff78993          	addi	s3,a5,-1
    5992:	99ba                	add	s3,s3,a4
    5994:	377d                	addiw	a4,a4,-1
    5996:	1702                	slli	a4,a4,0x20
    5998:	9301                	srli	a4,a4,0x20
    599a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    599e:	fff94583          	lbu	a1,-1(s2)
    59a2:	8526                	mv	a0,s1
    59a4:	00000097          	auipc	ra,0x0
    59a8:	f58080e7          	jalr	-168(ra) # 58fc <putc>
  while(--i >= 0)
    59ac:	197d                	addi	s2,s2,-1
    59ae:	ff3918e3          	bne	s2,s3,599e <printint+0x80>
}
    59b2:	70e2                	ld	ra,56(sp)
    59b4:	7442                	ld	s0,48(sp)
    59b6:	74a2                	ld	s1,40(sp)
    59b8:	7902                	ld	s2,32(sp)
    59ba:	69e2                	ld	s3,24(sp)
    59bc:	6121                	addi	sp,sp,64
    59be:	8082                	ret
    x = -xx;
    59c0:	40b005bb          	negw	a1,a1
    neg = 1;
    59c4:	4885                	li	a7,1
    x = -xx;
    59c6:	bf8d                	j	5938 <printint+0x1a>

00000000000059c8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    59c8:	7119                	addi	sp,sp,-128
    59ca:	fc86                	sd	ra,120(sp)
    59cc:	f8a2                	sd	s0,112(sp)
    59ce:	f4a6                	sd	s1,104(sp)
    59d0:	f0ca                	sd	s2,96(sp)
    59d2:	ecce                	sd	s3,88(sp)
    59d4:	e8d2                	sd	s4,80(sp)
    59d6:	e4d6                	sd	s5,72(sp)
    59d8:	e0da                	sd	s6,64(sp)
    59da:	fc5e                	sd	s7,56(sp)
    59dc:	f862                	sd	s8,48(sp)
    59de:	f466                	sd	s9,40(sp)
    59e0:	f06a                	sd	s10,32(sp)
    59e2:	ec6e                	sd	s11,24(sp)
    59e4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    59e6:	0005c903          	lbu	s2,0(a1)
    59ea:	18090f63          	beqz	s2,5b88 <vprintf+0x1c0>
    59ee:	8aaa                	mv	s5,a0
    59f0:	8b32                	mv	s6,a2
    59f2:	00158493          	addi	s1,a1,1
  state = 0;
    59f6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    59f8:	02500a13          	li	s4,37
      if(c == 'd'){
    59fc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5a00:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5a04:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5a08:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5a0c:	00003b97          	auipc	s7,0x3
    5a10:	b4cb8b93          	addi	s7,s7,-1204 # 8558 <digits>
    5a14:	a839                	j	5a32 <vprintf+0x6a>
        putc(fd, c);
    5a16:	85ca                	mv	a1,s2
    5a18:	8556                	mv	a0,s5
    5a1a:	00000097          	auipc	ra,0x0
    5a1e:	ee2080e7          	jalr	-286(ra) # 58fc <putc>
    5a22:	a019                	j	5a28 <vprintf+0x60>
    } else if(state == '%'){
    5a24:	01498f63          	beq	s3,s4,5a42 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5a28:	0485                	addi	s1,s1,1
    5a2a:	fff4c903          	lbu	s2,-1(s1)
    5a2e:	14090d63          	beqz	s2,5b88 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5a32:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5a36:	fe0997e3          	bnez	s3,5a24 <vprintf+0x5c>
      if(c == '%'){
    5a3a:	fd479ee3          	bne	a5,s4,5a16 <vprintf+0x4e>
        state = '%';
    5a3e:	89be                	mv	s3,a5
    5a40:	b7e5                	j	5a28 <vprintf+0x60>
      if(c == 'd'){
    5a42:	05878063          	beq	a5,s8,5a82 <vprintf+0xba>
      } else if(c == 'l') {
    5a46:	05978c63          	beq	a5,s9,5a9e <vprintf+0xd6>
      } else if(c == 'x') {
    5a4a:	07a78863          	beq	a5,s10,5aba <vprintf+0xf2>
      } else if(c == 'p') {
    5a4e:	09b78463          	beq	a5,s11,5ad6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    5a52:	07300713          	li	a4,115
    5a56:	0ce78663          	beq	a5,a4,5b22 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5a5a:	06300713          	li	a4,99
    5a5e:	0ee78e63          	beq	a5,a4,5b5a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5a62:	11478863          	beq	a5,s4,5b72 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5a66:	85d2                	mv	a1,s4
    5a68:	8556                	mv	a0,s5
    5a6a:	00000097          	auipc	ra,0x0
    5a6e:	e92080e7          	jalr	-366(ra) # 58fc <putc>
        putc(fd, c);
    5a72:	85ca                	mv	a1,s2
    5a74:	8556                	mv	a0,s5
    5a76:	00000097          	auipc	ra,0x0
    5a7a:	e86080e7          	jalr	-378(ra) # 58fc <putc>
      }
      state = 0;
    5a7e:	4981                	li	s3,0
    5a80:	b765                	j	5a28 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5a82:	008b0913          	addi	s2,s6,8
    5a86:	4685                	li	a3,1
    5a88:	4629                	li	a2,10
    5a8a:	000b2583          	lw	a1,0(s6)
    5a8e:	8556                	mv	a0,s5
    5a90:	00000097          	auipc	ra,0x0
    5a94:	e8e080e7          	jalr	-370(ra) # 591e <printint>
    5a98:	8b4a                	mv	s6,s2
      state = 0;
    5a9a:	4981                	li	s3,0
    5a9c:	b771                	j	5a28 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5a9e:	008b0913          	addi	s2,s6,8
    5aa2:	4681                	li	a3,0
    5aa4:	4629                	li	a2,10
    5aa6:	000b2583          	lw	a1,0(s6)
    5aaa:	8556                	mv	a0,s5
    5aac:	00000097          	auipc	ra,0x0
    5ab0:	e72080e7          	jalr	-398(ra) # 591e <printint>
    5ab4:	8b4a                	mv	s6,s2
      state = 0;
    5ab6:	4981                	li	s3,0
    5ab8:	bf85                	j	5a28 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5aba:	008b0913          	addi	s2,s6,8
    5abe:	4681                	li	a3,0
    5ac0:	4641                	li	a2,16
    5ac2:	000b2583          	lw	a1,0(s6)
    5ac6:	8556                	mv	a0,s5
    5ac8:	00000097          	auipc	ra,0x0
    5acc:	e56080e7          	jalr	-426(ra) # 591e <printint>
    5ad0:	8b4a                	mv	s6,s2
      state = 0;
    5ad2:	4981                	li	s3,0
    5ad4:	bf91                	j	5a28 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5ad6:	008b0793          	addi	a5,s6,8
    5ada:	f8f43423          	sd	a5,-120(s0)
    5ade:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5ae2:	03000593          	li	a1,48
    5ae6:	8556                	mv	a0,s5
    5ae8:	00000097          	auipc	ra,0x0
    5aec:	e14080e7          	jalr	-492(ra) # 58fc <putc>
  putc(fd, 'x');
    5af0:	85ea                	mv	a1,s10
    5af2:	8556                	mv	a0,s5
    5af4:	00000097          	auipc	ra,0x0
    5af8:	e08080e7          	jalr	-504(ra) # 58fc <putc>
    5afc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5afe:	03c9d793          	srli	a5,s3,0x3c
    5b02:	97de                	add	a5,a5,s7
    5b04:	0007c583          	lbu	a1,0(a5)
    5b08:	8556                	mv	a0,s5
    5b0a:	00000097          	auipc	ra,0x0
    5b0e:	df2080e7          	jalr	-526(ra) # 58fc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5b12:	0992                	slli	s3,s3,0x4
    5b14:	397d                	addiw	s2,s2,-1
    5b16:	fe0914e3          	bnez	s2,5afe <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5b1a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5b1e:	4981                	li	s3,0
    5b20:	b721                	j	5a28 <vprintf+0x60>
        s = va_arg(ap, char*);
    5b22:	008b0993          	addi	s3,s6,8
    5b26:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5b2a:	02090163          	beqz	s2,5b4c <vprintf+0x184>
        while(*s != 0){
    5b2e:	00094583          	lbu	a1,0(s2)
    5b32:	c9a1                	beqz	a1,5b82 <vprintf+0x1ba>
          putc(fd, *s);
    5b34:	8556                	mv	a0,s5
    5b36:	00000097          	auipc	ra,0x0
    5b3a:	dc6080e7          	jalr	-570(ra) # 58fc <putc>
          s++;
    5b3e:	0905                	addi	s2,s2,1
        while(*s != 0){
    5b40:	00094583          	lbu	a1,0(s2)
    5b44:	f9e5                	bnez	a1,5b34 <vprintf+0x16c>
        s = va_arg(ap, char*);
    5b46:	8b4e                	mv	s6,s3
      state = 0;
    5b48:	4981                	li	s3,0
    5b4a:	bdf9                	j	5a28 <vprintf+0x60>
          s = "(null)";
    5b4c:	00003917          	auipc	s2,0x3
    5b50:	a0490913          	addi	s2,s2,-1532 # 8550 <malloc+0x28be>
        while(*s != 0){
    5b54:	02800593          	li	a1,40
    5b58:	bff1                	j	5b34 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5b5a:	008b0913          	addi	s2,s6,8
    5b5e:	000b4583          	lbu	a1,0(s6)
    5b62:	8556                	mv	a0,s5
    5b64:	00000097          	auipc	ra,0x0
    5b68:	d98080e7          	jalr	-616(ra) # 58fc <putc>
    5b6c:	8b4a                	mv	s6,s2
      state = 0;
    5b6e:	4981                	li	s3,0
    5b70:	bd65                	j	5a28 <vprintf+0x60>
        putc(fd, c);
    5b72:	85d2                	mv	a1,s4
    5b74:	8556                	mv	a0,s5
    5b76:	00000097          	auipc	ra,0x0
    5b7a:	d86080e7          	jalr	-634(ra) # 58fc <putc>
      state = 0;
    5b7e:	4981                	li	s3,0
    5b80:	b565                	j	5a28 <vprintf+0x60>
        s = va_arg(ap, char*);
    5b82:	8b4e                	mv	s6,s3
      state = 0;
    5b84:	4981                	li	s3,0
    5b86:	b54d                	j	5a28 <vprintf+0x60>
    }
  }
}
    5b88:	70e6                	ld	ra,120(sp)
    5b8a:	7446                	ld	s0,112(sp)
    5b8c:	74a6                	ld	s1,104(sp)
    5b8e:	7906                	ld	s2,96(sp)
    5b90:	69e6                	ld	s3,88(sp)
    5b92:	6a46                	ld	s4,80(sp)
    5b94:	6aa6                	ld	s5,72(sp)
    5b96:	6b06                	ld	s6,64(sp)
    5b98:	7be2                	ld	s7,56(sp)
    5b9a:	7c42                	ld	s8,48(sp)
    5b9c:	7ca2                	ld	s9,40(sp)
    5b9e:	7d02                	ld	s10,32(sp)
    5ba0:	6de2                	ld	s11,24(sp)
    5ba2:	6109                	addi	sp,sp,128
    5ba4:	8082                	ret

0000000000005ba6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5ba6:	715d                	addi	sp,sp,-80
    5ba8:	ec06                	sd	ra,24(sp)
    5baa:	e822                	sd	s0,16(sp)
    5bac:	1000                	addi	s0,sp,32
    5bae:	e010                	sd	a2,0(s0)
    5bb0:	e414                	sd	a3,8(s0)
    5bb2:	e818                	sd	a4,16(s0)
    5bb4:	ec1c                	sd	a5,24(s0)
    5bb6:	03043023          	sd	a6,32(s0)
    5bba:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5bbe:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5bc2:	8622                	mv	a2,s0
    5bc4:	00000097          	auipc	ra,0x0
    5bc8:	e04080e7          	jalr	-508(ra) # 59c8 <vprintf>
}
    5bcc:	60e2                	ld	ra,24(sp)
    5bce:	6442                	ld	s0,16(sp)
    5bd0:	6161                	addi	sp,sp,80
    5bd2:	8082                	ret

0000000000005bd4 <printf>:

void
printf(const char *fmt, ...)
{
    5bd4:	711d                	addi	sp,sp,-96
    5bd6:	ec06                	sd	ra,24(sp)
    5bd8:	e822                	sd	s0,16(sp)
    5bda:	1000                	addi	s0,sp,32
    5bdc:	e40c                	sd	a1,8(s0)
    5bde:	e810                	sd	a2,16(s0)
    5be0:	ec14                	sd	a3,24(s0)
    5be2:	f018                	sd	a4,32(s0)
    5be4:	f41c                	sd	a5,40(s0)
    5be6:	03043823          	sd	a6,48(s0)
    5bea:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5bee:	00840613          	addi	a2,s0,8
    5bf2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5bf6:	85aa                	mv	a1,a0
    5bf8:	4505                	li	a0,1
    5bfa:	00000097          	auipc	ra,0x0
    5bfe:	dce080e7          	jalr	-562(ra) # 59c8 <vprintf>
}
    5c02:	60e2                	ld	ra,24(sp)
    5c04:	6442                	ld	s0,16(sp)
    5c06:	6125                	addi	sp,sp,96
    5c08:	8082                	ret

0000000000005c0a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5c0a:	1141                	addi	sp,sp,-16
    5c0c:	e422                	sd	s0,8(sp)
    5c0e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5c10:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5c14:	00003797          	auipc	a5,0x3
    5c18:	9647b783          	ld	a5,-1692(a5) # 8578 <freep>
    5c1c:	a805                	j	5c4c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5c1e:	4618                	lw	a4,8(a2)
    5c20:	9db9                	addw	a1,a1,a4
    5c22:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5c26:	6398                	ld	a4,0(a5)
    5c28:	6318                	ld	a4,0(a4)
    5c2a:	fee53823          	sd	a4,-16(a0)
    5c2e:	a091                	j	5c72 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5c30:	ff852703          	lw	a4,-8(a0)
    5c34:	9e39                	addw	a2,a2,a4
    5c36:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5c38:	ff053703          	ld	a4,-16(a0)
    5c3c:	e398                	sd	a4,0(a5)
    5c3e:	a099                	j	5c84 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5c40:	6398                	ld	a4,0(a5)
    5c42:	00e7e463          	bltu	a5,a4,5c4a <free+0x40>
    5c46:	00e6ea63          	bltu	a3,a4,5c5a <free+0x50>
{
    5c4a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5c4c:	fed7fae3          	bgeu	a5,a3,5c40 <free+0x36>
    5c50:	6398                	ld	a4,0(a5)
    5c52:	00e6e463          	bltu	a3,a4,5c5a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5c56:	fee7eae3          	bltu	a5,a4,5c4a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5c5a:	ff852583          	lw	a1,-8(a0)
    5c5e:	6390                	ld	a2,0(a5)
    5c60:	02059713          	slli	a4,a1,0x20
    5c64:	9301                	srli	a4,a4,0x20
    5c66:	0712                	slli	a4,a4,0x4
    5c68:	9736                	add	a4,a4,a3
    5c6a:	fae60ae3          	beq	a2,a4,5c1e <free+0x14>
    bp->s.ptr = p->s.ptr;
    5c6e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5c72:	4790                	lw	a2,8(a5)
    5c74:	02061713          	slli	a4,a2,0x20
    5c78:	9301                	srli	a4,a4,0x20
    5c7a:	0712                	slli	a4,a4,0x4
    5c7c:	973e                	add	a4,a4,a5
    5c7e:	fae689e3          	beq	a3,a4,5c30 <free+0x26>
  } else
    p->s.ptr = bp;
    5c82:	e394                	sd	a3,0(a5)
  freep = p;
    5c84:	00003717          	auipc	a4,0x3
    5c88:	8ef73a23          	sd	a5,-1804(a4) # 8578 <freep>
}
    5c8c:	6422                	ld	s0,8(sp)
    5c8e:	0141                	addi	sp,sp,16
    5c90:	8082                	ret

0000000000005c92 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5c92:	7139                	addi	sp,sp,-64
    5c94:	fc06                	sd	ra,56(sp)
    5c96:	f822                	sd	s0,48(sp)
    5c98:	f426                	sd	s1,40(sp)
    5c9a:	f04a                	sd	s2,32(sp)
    5c9c:	ec4e                	sd	s3,24(sp)
    5c9e:	e852                	sd	s4,16(sp)
    5ca0:	e456                	sd	s5,8(sp)
    5ca2:	e05a                	sd	s6,0(sp)
    5ca4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5ca6:	02051493          	slli	s1,a0,0x20
    5caa:	9081                	srli	s1,s1,0x20
    5cac:	04bd                	addi	s1,s1,15
    5cae:	8091                	srli	s1,s1,0x4
    5cb0:	0014899b          	addiw	s3,s1,1
    5cb4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5cb6:	00003517          	auipc	a0,0x3
    5cba:	8c253503          	ld	a0,-1854(a0) # 8578 <freep>
    5cbe:	c515                	beqz	a0,5cea <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5cc0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5cc2:	4798                	lw	a4,8(a5)
    5cc4:	02977f63          	bgeu	a4,s1,5d02 <malloc+0x70>
    5cc8:	8a4e                	mv	s4,s3
    5cca:	0009871b          	sext.w	a4,s3
    5cce:	6685                	lui	a3,0x1
    5cd0:	00d77363          	bgeu	a4,a3,5cd6 <malloc+0x44>
    5cd4:	6a05                	lui	s4,0x1
    5cd6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5cda:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5cde:	00003917          	auipc	s2,0x3
    5ce2:	89a90913          	addi	s2,s2,-1894 # 8578 <freep>
  if(p == (char*)-1)
    5ce6:	5afd                	li	s5,-1
    5ce8:	a88d                	j	5d5a <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    5cea:	00009797          	auipc	a5,0x9
    5cee:	0ae78793          	addi	a5,a5,174 # ed98 <base>
    5cf2:	00003717          	auipc	a4,0x3
    5cf6:	88f73323          	sd	a5,-1914(a4) # 8578 <freep>
    5cfa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5cfc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5d00:	b7e1                	j	5cc8 <malloc+0x36>
      if(p->s.size == nunits)
    5d02:	02e48b63          	beq	s1,a4,5d38 <malloc+0xa6>
        p->s.size -= nunits;
    5d06:	4137073b          	subw	a4,a4,s3
    5d0a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5d0c:	1702                	slli	a4,a4,0x20
    5d0e:	9301                	srli	a4,a4,0x20
    5d10:	0712                	slli	a4,a4,0x4
    5d12:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5d14:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5d18:	00003717          	auipc	a4,0x3
    5d1c:	86a73023          	sd	a0,-1952(a4) # 8578 <freep>
      return (void*)(p + 1);
    5d20:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5d24:	70e2                	ld	ra,56(sp)
    5d26:	7442                	ld	s0,48(sp)
    5d28:	74a2                	ld	s1,40(sp)
    5d2a:	7902                	ld	s2,32(sp)
    5d2c:	69e2                	ld	s3,24(sp)
    5d2e:	6a42                	ld	s4,16(sp)
    5d30:	6aa2                	ld	s5,8(sp)
    5d32:	6b02                	ld	s6,0(sp)
    5d34:	6121                	addi	sp,sp,64
    5d36:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5d38:	6398                	ld	a4,0(a5)
    5d3a:	e118                	sd	a4,0(a0)
    5d3c:	bff1                	j	5d18 <malloc+0x86>
  hp->s.size = nu;
    5d3e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5d42:	0541                	addi	a0,a0,16
    5d44:	00000097          	auipc	ra,0x0
    5d48:	ec6080e7          	jalr	-314(ra) # 5c0a <free>
  return freep;
    5d4c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5d50:	d971                	beqz	a0,5d24 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5d52:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5d54:	4798                	lw	a4,8(a5)
    5d56:	fa9776e3          	bgeu	a4,s1,5d02 <malloc+0x70>
    if(p == freep)
    5d5a:	00093703          	ld	a4,0(s2)
    5d5e:	853e                	mv	a0,a5
    5d60:	fef719e3          	bne	a4,a5,5d52 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    5d64:	8552                	mv	a0,s4
    5d66:	00000097          	auipc	ra,0x0
    5d6a:	b76080e7          	jalr	-1162(ra) # 58dc <sbrk>
  if(p == (char*)-1)
    5d6e:	fd5518e3          	bne	a0,s5,5d3e <malloc+0xac>
        return 0;
    5d72:	4501                	li	a0,0
    5d74:	bf45                	j	5d24 <malloc+0x92>
