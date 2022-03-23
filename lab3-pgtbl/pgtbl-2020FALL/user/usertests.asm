
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
      10:	00005097          	auipc	ra,0x5
      14:	3b8080e7          	jalr	952(ra) # 53c8 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	3a6080e7          	jalr	934(ra) # 53c8 <open>
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
      42:	bea50513          	addi	a0,a0,-1046 # 5c28 <statistics+0x386>
      46:	00005097          	auipc	ra,0x5
      4a:	6ba080e7          	jalr	1722(ra) # 5700 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	338080e7          	jalr	824(ra) # 5388 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	09878793          	addi	a5,a5,152 # 90f0 <uninit>
      60:	0000b697          	auipc	a3,0xb
      64:	7a068693          	addi	a3,a3,1952 # b800 <buf>
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
      84:	bc850513          	addi	a0,a0,-1080 # 5c48 <statistics+0x3a6>
      88:	00005097          	auipc	ra,0x5
      8c:	678080e7          	jalr	1656(ra) # 5700 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	2f6080e7          	jalr	758(ra) # 5388 <exit>

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
      ac:	bb850513          	addi	a0,a0,-1096 # 5c60 <statistics+0x3be>
      b0:	00005097          	auipc	ra,0x5
      b4:	318080e7          	jalr	792(ra) # 53c8 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	2f4080e7          	jalr	756(ra) # 53b0 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	bba50513          	addi	a0,a0,-1094 # 5c80 <statistics+0x3de>
      ce:	00005097          	auipc	ra,0x5
      d2:	2fa080e7          	jalr	762(ra) # 53c8 <open>
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
      ea:	b8250513          	addi	a0,a0,-1150 # 5c68 <statistics+0x3c6>
      ee:	00005097          	auipc	ra,0x5
      f2:	612080e7          	jalr	1554(ra) # 5700 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	290080e7          	jalr	656(ra) # 5388 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	b8e50513          	addi	a0,a0,-1138 # 5c90 <statistics+0x3ee>
     10a:	00005097          	auipc	ra,0x5
     10e:	5f6080e7          	jalr	1526(ra) # 5700 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	274080e7          	jalr	628(ra) # 5388 <exit>

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
     130:	b8c50513          	addi	a0,a0,-1140 # 5cb8 <statistics+0x416>
     134:	00005097          	auipc	ra,0x5
     138:	2a4080e7          	jalr	676(ra) # 53d8 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	b7850513          	addi	a0,a0,-1160 # 5cb8 <statistics+0x416>
     148:	00005097          	auipc	ra,0x5
     14c:	280080e7          	jalr	640(ra) # 53c8 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	b7458593          	addi	a1,a1,-1164 # 5cc8 <statistics+0x426>
     15c:	00005097          	auipc	ra,0x5
     160:	24c080e7          	jalr	588(ra) # 53a8 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	b5050513          	addi	a0,a0,-1200 # 5cb8 <statistics+0x416>
     170:	00005097          	auipc	ra,0x5
     174:	258080e7          	jalr	600(ra) # 53c8 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	b5458593          	addi	a1,a1,-1196 # 5cd0 <statistics+0x42e>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	222080e7          	jalr	546(ra) # 53a8 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	b2450513          	addi	a0,a0,-1244 # 5cb8 <statistics+0x416>
     19c:	00005097          	auipc	ra,0x5
     1a0:	23c080e7          	jalr	572(ra) # 53d8 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	20a080e7          	jalr	522(ra) # 53b0 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	200080e7          	jalr	512(ra) # 53b0 <close>
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
     1ce:	b0e50513          	addi	a0,a0,-1266 # 5cd8 <statistics+0x436>
     1d2:	00005097          	auipc	ra,0x5
     1d6:	52e080e7          	jalr	1326(ra) # 5700 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	1ac080e7          	jalr	428(ra) # 5388 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	e44e                	sd	s3,8(sp)
     1f0:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f2:	00008797          	auipc	a5,0x8
     1f6:	de678793          	addi	a5,a5,-538 # 7fd8 <name>
     1fa:	06100713          	li	a4,97
     1fe:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     202:	00078123          	sb	zero,2(a5)
     206:	03000493          	li	s1,48
    name[1] = '0' + i;
     20a:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     20c:	06400993          	li	s3,100
    name[1] = '0' + i;
     210:	009900a3          	sb	s1,1(s2)
    fd = open(name, O_CREATE|O_RDWR);
     214:	20200593          	li	a1,514
     218:	854a                	mv	a0,s2
     21a:	00005097          	auipc	ra,0x5
     21e:	1ae080e7          	jalr	430(ra) # 53c8 <open>
    close(fd);
     222:	00005097          	auipc	ra,0x5
     226:	18e080e7          	jalr	398(ra) # 53b0 <close>
  for(i = 0; i < N; i++){
     22a:	2485                	addiw	s1,s1,1
     22c:	0ff4f493          	andi	s1,s1,255
     230:	ff3490e3          	bne	s1,s3,210 <createtest+0x2c>
  name[0] = 'a';
     234:	00008797          	auipc	a5,0x8
     238:	da478793          	addi	a5,a5,-604 # 7fd8 <name>
     23c:	06100713          	li	a4,97
     240:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     244:	00078123          	sb	zero,2(a5)
     248:	03000493          	li	s1,48
    name[1] = '0' + i;
     24c:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     24e:	06400993          	li	s3,100
    name[1] = '0' + i;
     252:	009900a3          	sb	s1,1(s2)
    unlink(name);
     256:	854a                	mv	a0,s2
     258:	00005097          	auipc	ra,0x5
     25c:	180080e7          	jalr	384(ra) # 53d8 <unlink>
  for(i = 0; i < N; i++){
     260:	2485                	addiw	s1,s1,1
     262:	0ff4f493          	andi	s1,s1,255
     266:	ff3496e3          	bne	s1,s3,252 <createtest+0x6e>
}
     26a:	70a2                	ld	ra,40(sp)
     26c:	7402                	ld	s0,32(sp)
     26e:	64e2                	ld	s1,24(sp)
     270:	6942                	ld	s2,16(sp)
     272:	69a2                	ld	s3,8(sp)
     274:	6145                	addi	sp,sp,48
     276:	8082                	ret

0000000000000278 <bigwrite>:
{
     278:	715d                	addi	sp,sp,-80
     27a:	e486                	sd	ra,72(sp)
     27c:	e0a2                	sd	s0,64(sp)
     27e:	fc26                	sd	s1,56(sp)
     280:	f84a                	sd	s2,48(sp)
     282:	f44e                	sd	s3,40(sp)
     284:	f052                	sd	s4,32(sp)
     286:	ec56                	sd	s5,24(sp)
     288:	e85a                	sd	s6,16(sp)
     28a:	e45e                	sd	s7,8(sp)
     28c:	0880                	addi	s0,sp,80
     28e:	8baa                	mv	s7,a0
  unlink("bigwrite");
     290:	00006517          	auipc	a0,0x6
     294:	84850513          	addi	a0,a0,-1976 # 5ad8 <statistics+0x236>
     298:	00005097          	auipc	ra,0x5
     29c:	140080e7          	jalr	320(ra) # 53d8 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a4:	00006a97          	auipc	s5,0x6
     2a8:	834a8a93          	addi	s5,s5,-1996 # 5ad8 <statistics+0x236>
      int cc = write(fd, buf, sz);
     2ac:	0000ba17          	auipc	s4,0xb
     2b0:	554a0a13          	addi	s4,s4,1364 # b800 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b4:	6b0d                	lui	s6,0x3
     2b6:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x4dd>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2ba:	20200593          	li	a1,514
     2be:	8556                	mv	a0,s5
     2c0:	00005097          	auipc	ra,0x5
     2c4:	108080e7          	jalr	264(ra) # 53c8 <open>
     2c8:	892a                	mv	s2,a0
    if(fd < 0){
     2ca:	04054d63          	bltz	a0,324 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ce:	8626                	mv	a2,s1
     2d0:	85d2                	mv	a1,s4
     2d2:	00005097          	auipc	ra,0x5
     2d6:	0d6080e7          	jalr	214(ra) # 53a8 <write>
     2da:	89aa                	mv	s3,a0
      if(cc != sz){
     2dc:	06a49463          	bne	s1,a0,344 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2e0:	8626                	mv	a2,s1
     2e2:	85d2                	mv	a1,s4
     2e4:	854a                	mv	a0,s2
     2e6:	00005097          	auipc	ra,0x5
     2ea:	0c2080e7          	jalr	194(ra) # 53a8 <write>
      if(cc != sz){
     2ee:	04951963          	bne	a0,s1,340 <bigwrite+0xc8>
    close(fd);
     2f2:	854a                	mv	a0,s2
     2f4:	00005097          	auipc	ra,0x5
     2f8:	0bc080e7          	jalr	188(ra) # 53b0 <close>
    unlink("bigwrite");
     2fc:	8556                	mv	a0,s5
     2fe:	00005097          	auipc	ra,0x5
     302:	0da080e7          	jalr	218(ra) # 53d8 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     306:	1d74849b          	addiw	s1,s1,471
     30a:	fb6498e3          	bne	s1,s6,2ba <bigwrite+0x42>
}
     30e:	60a6                	ld	ra,72(sp)
     310:	6406                	ld	s0,64(sp)
     312:	74e2                	ld	s1,56(sp)
     314:	7942                	ld	s2,48(sp)
     316:	79a2                	ld	s3,40(sp)
     318:	7a02                	ld	s4,32(sp)
     31a:	6ae2                	ld	s5,24(sp)
     31c:	6b42                	ld	s6,16(sp)
     31e:	6ba2                	ld	s7,8(sp)
     320:	6161                	addi	sp,sp,80
     322:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     324:	85de                	mv	a1,s7
     326:	00006517          	auipc	a0,0x6
     32a:	9da50513          	addi	a0,a0,-1574 # 5d00 <statistics+0x45e>
     32e:	00005097          	auipc	ra,0x5
     332:	3d2080e7          	jalr	978(ra) # 5700 <printf>
      exit(1);
     336:	4505                	li	a0,1
     338:	00005097          	auipc	ra,0x5
     33c:	050080e7          	jalr	80(ra) # 5388 <exit>
     340:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     342:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     344:	86ce                	mv	a3,s3
     346:	8626                	mv	a2,s1
     348:	85de                	mv	a1,s7
     34a:	00006517          	auipc	a0,0x6
     34e:	9d650513          	addi	a0,a0,-1578 # 5d20 <statistics+0x47e>
     352:	00005097          	auipc	ra,0x5
     356:	3ae080e7          	jalr	942(ra) # 5700 <printf>
        exit(1);
     35a:	4505                	li	a0,1
     35c:	00005097          	auipc	ra,0x5
     360:	02c080e7          	jalr	44(ra) # 5388 <exit>

0000000000000364 <copyin>:
{
     364:	715d                	addi	sp,sp,-80
     366:	e486                	sd	ra,72(sp)
     368:	e0a2                	sd	s0,64(sp)
     36a:	fc26                	sd	s1,56(sp)
     36c:	f84a                	sd	s2,48(sp)
     36e:	f44e                	sd	s3,40(sp)
     370:	f052                	sd	s4,32(sp)
     372:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     374:	4785                	li	a5,1
     376:	07fe                	slli	a5,a5,0x1f
     378:	fcf43023          	sd	a5,-64(s0)
     37c:	57fd                	li	a5,-1
     37e:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     382:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     386:	00006a17          	auipc	s4,0x6
     38a:	9b2a0a13          	addi	s4,s4,-1614 # 5d38 <statistics+0x496>
    uint64 addr = addrs[ai];
     38e:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     392:	20100593          	li	a1,513
     396:	8552                	mv	a0,s4
     398:	00005097          	auipc	ra,0x5
     39c:	030080e7          	jalr	48(ra) # 53c8 <open>
     3a0:	84aa                	mv	s1,a0
    if(fd < 0){
     3a2:	08054863          	bltz	a0,432 <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     3a6:	6609                	lui	a2,0x2
     3a8:	85ce                	mv	a1,s3
     3aa:	00005097          	auipc	ra,0x5
     3ae:	ffe080e7          	jalr	-2(ra) # 53a8 <write>
    if(n >= 0){
     3b2:	08055d63          	bgez	a0,44c <copyin+0xe8>
    close(fd);
     3b6:	8526                	mv	a0,s1
     3b8:	00005097          	auipc	ra,0x5
     3bc:	ff8080e7          	jalr	-8(ra) # 53b0 <close>
    unlink("copyin1");
     3c0:	8552                	mv	a0,s4
     3c2:	00005097          	auipc	ra,0x5
     3c6:	016080e7          	jalr	22(ra) # 53d8 <unlink>
    n = write(1, (char*)addr, 8192);
     3ca:	6609                	lui	a2,0x2
     3cc:	85ce                	mv	a1,s3
     3ce:	4505                	li	a0,1
     3d0:	00005097          	auipc	ra,0x5
     3d4:	fd8080e7          	jalr	-40(ra) # 53a8 <write>
    if(n > 0){
     3d8:	08a04963          	bgtz	a0,46a <copyin+0x106>
    if(pipe(fds) < 0){
     3dc:	fb840513          	addi	a0,s0,-72
     3e0:	00005097          	auipc	ra,0x5
     3e4:	fb8080e7          	jalr	-72(ra) # 5398 <pipe>
     3e8:	0a054063          	bltz	a0,488 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3ec:	6609                	lui	a2,0x2
     3ee:	85ce                	mv	a1,s3
     3f0:	fbc42503          	lw	a0,-68(s0)
     3f4:	00005097          	auipc	ra,0x5
     3f8:	fb4080e7          	jalr	-76(ra) # 53a8 <write>
    if(n > 0){
     3fc:	0aa04363          	bgtz	a0,4a2 <copyin+0x13e>
    close(fds[0]);
     400:	fb842503          	lw	a0,-72(s0)
     404:	00005097          	auipc	ra,0x5
     408:	fac080e7          	jalr	-84(ra) # 53b0 <close>
    close(fds[1]);
     40c:	fbc42503          	lw	a0,-68(s0)
     410:	00005097          	auipc	ra,0x5
     414:	fa0080e7          	jalr	-96(ra) # 53b0 <close>
  for(int ai = 0; ai < 2; ai++){
     418:	0921                	addi	s2,s2,8
     41a:	fd040793          	addi	a5,s0,-48
     41e:	f6f918e3          	bne	s2,a5,38e <copyin+0x2a>
}
     422:	60a6                	ld	ra,72(sp)
     424:	6406                	ld	s0,64(sp)
     426:	74e2                	ld	s1,56(sp)
     428:	7942                	ld	s2,48(sp)
     42a:	79a2                	ld	s3,40(sp)
     42c:	7a02                	ld	s4,32(sp)
     42e:	6161                	addi	sp,sp,80
     430:	8082                	ret
      printf("open(copyin1) failed\n");
     432:	00006517          	auipc	a0,0x6
     436:	90e50513          	addi	a0,a0,-1778 # 5d40 <statistics+0x49e>
     43a:	00005097          	auipc	ra,0x5
     43e:	2c6080e7          	jalr	710(ra) # 5700 <printf>
      exit(1);
     442:	4505                	li	a0,1
     444:	00005097          	auipc	ra,0x5
     448:	f44080e7          	jalr	-188(ra) # 5388 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     44c:	862a                	mv	a2,a0
     44e:	85ce                	mv	a1,s3
     450:	00006517          	auipc	a0,0x6
     454:	90850513          	addi	a0,a0,-1784 # 5d58 <statistics+0x4b6>
     458:	00005097          	auipc	ra,0x5
     45c:	2a8080e7          	jalr	680(ra) # 5700 <printf>
      exit(1);
     460:	4505                	li	a0,1
     462:	00005097          	auipc	ra,0x5
     466:	f26080e7          	jalr	-218(ra) # 5388 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     46a:	862a                	mv	a2,a0
     46c:	85ce                	mv	a1,s3
     46e:	00006517          	auipc	a0,0x6
     472:	91a50513          	addi	a0,a0,-1766 # 5d88 <statistics+0x4e6>
     476:	00005097          	auipc	ra,0x5
     47a:	28a080e7          	jalr	650(ra) # 5700 <printf>
      exit(1);
     47e:	4505                	li	a0,1
     480:	00005097          	auipc	ra,0x5
     484:	f08080e7          	jalr	-248(ra) # 5388 <exit>
      printf("pipe() failed\n");
     488:	00006517          	auipc	a0,0x6
     48c:	93050513          	addi	a0,a0,-1744 # 5db8 <statistics+0x516>
     490:	00005097          	auipc	ra,0x5
     494:	270080e7          	jalr	624(ra) # 5700 <printf>
      exit(1);
     498:	4505                	li	a0,1
     49a:	00005097          	auipc	ra,0x5
     49e:	eee080e7          	jalr	-274(ra) # 5388 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     4a2:	862a                	mv	a2,a0
     4a4:	85ce                	mv	a1,s3
     4a6:	00006517          	auipc	a0,0x6
     4aa:	92250513          	addi	a0,a0,-1758 # 5dc8 <statistics+0x526>
     4ae:	00005097          	auipc	ra,0x5
     4b2:	252080e7          	jalr	594(ra) # 5700 <printf>
      exit(1);
     4b6:	4505                	li	a0,1
     4b8:	00005097          	auipc	ra,0x5
     4bc:	ed0080e7          	jalr	-304(ra) # 5388 <exit>

00000000000004c0 <copyout>:
{
     4c0:	711d                	addi	sp,sp,-96
     4c2:	ec86                	sd	ra,88(sp)
     4c4:	e8a2                	sd	s0,80(sp)
     4c6:	e4a6                	sd	s1,72(sp)
     4c8:	e0ca                	sd	s2,64(sp)
     4ca:	fc4e                	sd	s3,56(sp)
     4cc:	f852                	sd	s4,48(sp)
     4ce:	f456                	sd	s5,40(sp)
     4d0:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4d2:	4785                	li	a5,1
     4d4:	07fe                	slli	a5,a5,0x1f
     4d6:	faf43823          	sd	a5,-80(s0)
     4da:	57fd                	li	a5,-1
     4dc:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4e0:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4e4:	00006a17          	auipc	s4,0x6
     4e8:	914a0a13          	addi	s4,s4,-1772 # 5df8 <statistics+0x556>
    n = write(fds[1], "x", 1);
     4ec:	00005a97          	auipc	s5,0x5
     4f0:	7e4a8a93          	addi	s5,s5,2020 # 5cd0 <statistics+0x42e>
    uint64 addr = addrs[ai];
     4f4:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4f8:	4581                	li	a1,0
     4fa:	8552                	mv	a0,s4
     4fc:	00005097          	auipc	ra,0x5
     500:	ecc080e7          	jalr	-308(ra) # 53c8 <open>
     504:	84aa                	mv	s1,a0
    if(fd < 0){
     506:	08054663          	bltz	a0,592 <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     50a:	6609                	lui	a2,0x2
     50c:	85ce                	mv	a1,s3
     50e:	00005097          	auipc	ra,0x5
     512:	e92080e7          	jalr	-366(ra) # 53a0 <read>
    if(n > 0){
     516:	08a04b63          	bgtz	a0,5ac <copyout+0xec>
    close(fd);
     51a:	8526                	mv	a0,s1
     51c:	00005097          	auipc	ra,0x5
     520:	e94080e7          	jalr	-364(ra) # 53b0 <close>
    if(pipe(fds) < 0){
     524:	fa840513          	addi	a0,s0,-88
     528:	00005097          	auipc	ra,0x5
     52c:	e70080e7          	jalr	-400(ra) # 5398 <pipe>
     530:	08054d63          	bltz	a0,5ca <copyout+0x10a>
    n = write(fds[1], "x", 1);
     534:	4605                	li	a2,1
     536:	85d6                	mv	a1,s5
     538:	fac42503          	lw	a0,-84(s0)
     53c:	00005097          	auipc	ra,0x5
     540:	e6c080e7          	jalr	-404(ra) # 53a8 <write>
    if(n != 1){
     544:	4785                	li	a5,1
     546:	08f51f63          	bne	a0,a5,5e4 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     54a:	6609                	lui	a2,0x2
     54c:	85ce                	mv	a1,s3
     54e:	fa842503          	lw	a0,-88(s0)
     552:	00005097          	auipc	ra,0x5
     556:	e4e080e7          	jalr	-434(ra) # 53a0 <read>
    if(n > 0){
     55a:	0aa04263          	bgtz	a0,5fe <copyout+0x13e>
    close(fds[0]);
     55e:	fa842503          	lw	a0,-88(s0)
     562:	00005097          	auipc	ra,0x5
     566:	e4e080e7          	jalr	-434(ra) # 53b0 <close>
    close(fds[1]);
     56a:	fac42503          	lw	a0,-84(s0)
     56e:	00005097          	auipc	ra,0x5
     572:	e42080e7          	jalr	-446(ra) # 53b0 <close>
  for(int ai = 0; ai < 2; ai++){
     576:	0921                	addi	s2,s2,8
     578:	fc040793          	addi	a5,s0,-64
     57c:	f6f91ce3          	bne	s2,a5,4f4 <copyout+0x34>
}
     580:	60e6                	ld	ra,88(sp)
     582:	6446                	ld	s0,80(sp)
     584:	64a6                	ld	s1,72(sp)
     586:	6906                	ld	s2,64(sp)
     588:	79e2                	ld	s3,56(sp)
     58a:	7a42                	ld	s4,48(sp)
     58c:	7aa2                	ld	s5,40(sp)
     58e:	6125                	addi	sp,sp,96
     590:	8082                	ret
      printf("open(README) failed\n");
     592:	00006517          	auipc	a0,0x6
     596:	86e50513          	addi	a0,a0,-1938 # 5e00 <statistics+0x55e>
     59a:	00005097          	auipc	ra,0x5
     59e:	166080e7          	jalr	358(ra) # 5700 <printf>
      exit(1);
     5a2:	4505                	li	a0,1
     5a4:	00005097          	auipc	ra,0x5
     5a8:	de4080e7          	jalr	-540(ra) # 5388 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5ac:	862a                	mv	a2,a0
     5ae:	85ce                	mv	a1,s3
     5b0:	00006517          	auipc	a0,0x6
     5b4:	86850513          	addi	a0,a0,-1944 # 5e18 <statistics+0x576>
     5b8:	00005097          	auipc	ra,0x5
     5bc:	148080e7          	jalr	328(ra) # 5700 <printf>
      exit(1);
     5c0:	4505                	li	a0,1
     5c2:	00005097          	auipc	ra,0x5
     5c6:	dc6080e7          	jalr	-570(ra) # 5388 <exit>
      printf("pipe() failed\n");
     5ca:	00005517          	auipc	a0,0x5
     5ce:	7ee50513          	addi	a0,a0,2030 # 5db8 <statistics+0x516>
     5d2:	00005097          	auipc	ra,0x5
     5d6:	12e080e7          	jalr	302(ra) # 5700 <printf>
      exit(1);
     5da:	4505                	li	a0,1
     5dc:	00005097          	auipc	ra,0x5
     5e0:	dac080e7          	jalr	-596(ra) # 5388 <exit>
      printf("pipe write failed\n");
     5e4:	00006517          	auipc	a0,0x6
     5e8:	86450513          	addi	a0,a0,-1948 # 5e48 <statistics+0x5a6>
     5ec:	00005097          	auipc	ra,0x5
     5f0:	114080e7          	jalr	276(ra) # 5700 <printf>
      exit(1);
     5f4:	4505                	li	a0,1
     5f6:	00005097          	auipc	ra,0x5
     5fa:	d92080e7          	jalr	-622(ra) # 5388 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5fe:	862a                	mv	a2,a0
     600:	85ce                	mv	a1,s3
     602:	00006517          	auipc	a0,0x6
     606:	85e50513          	addi	a0,a0,-1954 # 5e60 <statistics+0x5be>
     60a:	00005097          	auipc	ra,0x5
     60e:	0f6080e7          	jalr	246(ra) # 5700 <printf>
      exit(1);
     612:	4505                	li	a0,1
     614:	00005097          	auipc	ra,0x5
     618:	d74080e7          	jalr	-652(ra) # 5388 <exit>

000000000000061c <truncate1>:
{
     61c:	711d                	addi	sp,sp,-96
     61e:	ec86                	sd	ra,88(sp)
     620:	e8a2                	sd	s0,80(sp)
     622:	e4a6                	sd	s1,72(sp)
     624:	e0ca                	sd	s2,64(sp)
     626:	fc4e                	sd	s3,56(sp)
     628:	f852                	sd	s4,48(sp)
     62a:	f456                	sd	s5,40(sp)
     62c:	1080                	addi	s0,sp,96
     62e:	8aaa                	mv	s5,a0
  unlink("truncfile");
     630:	00005517          	auipc	a0,0x5
     634:	68850513          	addi	a0,a0,1672 # 5cb8 <statistics+0x416>
     638:	00005097          	auipc	ra,0x5
     63c:	da0080e7          	jalr	-608(ra) # 53d8 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     640:	60100593          	li	a1,1537
     644:	00005517          	auipc	a0,0x5
     648:	67450513          	addi	a0,a0,1652 # 5cb8 <statistics+0x416>
     64c:	00005097          	auipc	ra,0x5
     650:	d7c080e7          	jalr	-644(ra) # 53c8 <open>
     654:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     656:	4611                	li	a2,4
     658:	00005597          	auipc	a1,0x5
     65c:	67058593          	addi	a1,a1,1648 # 5cc8 <statistics+0x426>
     660:	00005097          	auipc	ra,0x5
     664:	d48080e7          	jalr	-696(ra) # 53a8 <write>
  close(fd1);
     668:	8526                	mv	a0,s1
     66a:	00005097          	auipc	ra,0x5
     66e:	d46080e7          	jalr	-698(ra) # 53b0 <close>
  int fd2 = open("truncfile", O_RDONLY);
     672:	4581                	li	a1,0
     674:	00005517          	auipc	a0,0x5
     678:	64450513          	addi	a0,a0,1604 # 5cb8 <statistics+0x416>
     67c:	00005097          	auipc	ra,0x5
     680:	d4c080e7          	jalr	-692(ra) # 53c8 <open>
     684:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     686:	02000613          	li	a2,32
     68a:	fa040593          	addi	a1,s0,-96
     68e:	00005097          	auipc	ra,0x5
     692:	d12080e7          	jalr	-750(ra) # 53a0 <read>
  if(n != 4){
     696:	4791                	li	a5,4
     698:	0cf51e63          	bne	a0,a5,774 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     69c:	40100593          	li	a1,1025
     6a0:	00005517          	auipc	a0,0x5
     6a4:	61850513          	addi	a0,a0,1560 # 5cb8 <statistics+0x416>
     6a8:	00005097          	auipc	ra,0x5
     6ac:	d20080e7          	jalr	-736(ra) # 53c8 <open>
     6b0:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     6b2:	4581                	li	a1,0
     6b4:	00005517          	auipc	a0,0x5
     6b8:	60450513          	addi	a0,a0,1540 # 5cb8 <statistics+0x416>
     6bc:	00005097          	auipc	ra,0x5
     6c0:	d0c080e7          	jalr	-756(ra) # 53c8 <open>
     6c4:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6c6:	02000613          	li	a2,32
     6ca:	fa040593          	addi	a1,s0,-96
     6ce:	00005097          	auipc	ra,0x5
     6d2:	cd2080e7          	jalr	-814(ra) # 53a0 <read>
     6d6:	8a2a                	mv	s4,a0
  if(n != 0){
     6d8:	ed4d                	bnez	a0,792 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6da:	02000613          	li	a2,32
     6de:	fa040593          	addi	a1,s0,-96
     6e2:	8526                	mv	a0,s1
     6e4:	00005097          	auipc	ra,0x5
     6e8:	cbc080e7          	jalr	-836(ra) # 53a0 <read>
     6ec:	8a2a                	mv	s4,a0
  if(n != 0){
     6ee:	e971                	bnez	a0,7c2 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6f0:	4619                	li	a2,6
     6f2:	00005597          	auipc	a1,0x5
     6f6:	7fe58593          	addi	a1,a1,2046 # 5ef0 <statistics+0x64e>
     6fa:	854e                	mv	a0,s3
     6fc:	00005097          	auipc	ra,0x5
     700:	cac080e7          	jalr	-852(ra) # 53a8 <write>
  n = read(fd3, buf, sizeof(buf));
     704:	02000613          	li	a2,32
     708:	fa040593          	addi	a1,s0,-96
     70c:	854a                	mv	a0,s2
     70e:	00005097          	auipc	ra,0x5
     712:	c92080e7          	jalr	-878(ra) # 53a0 <read>
  if(n != 6){
     716:	4799                	li	a5,6
     718:	0cf51d63          	bne	a0,a5,7f2 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     71c:	02000613          	li	a2,32
     720:	fa040593          	addi	a1,s0,-96
     724:	8526                	mv	a0,s1
     726:	00005097          	auipc	ra,0x5
     72a:	c7a080e7          	jalr	-902(ra) # 53a0 <read>
  if(n != 2){
     72e:	4789                	li	a5,2
     730:	0ef51063          	bne	a0,a5,810 <truncate1+0x1f4>
  unlink("truncfile");
     734:	00005517          	auipc	a0,0x5
     738:	58450513          	addi	a0,a0,1412 # 5cb8 <statistics+0x416>
     73c:	00005097          	auipc	ra,0x5
     740:	c9c080e7          	jalr	-868(ra) # 53d8 <unlink>
  close(fd1);
     744:	854e                	mv	a0,s3
     746:	00005097          	auipc	ra,0x5
     74a:	c6a080e7          	jalr	-918(ra) # 53b0 <close>
  close(fd2);
     74e:	8526                	mv	a0,s1
     750:	00005097          	auipc	ra,0x5
     754:	c60080e7          	jalr	-928(ra) # 53b0 <close>
  close(fd3);
     758:	854a                	mv	a0,s2
     75a:	00005097          	auipc	ra,0x5
     75e:	c56080e7          	jalr	-938(ra) # 53b0 <close>
}
     762:	60e6                	ld	ra,88(sp)
     764:	6446                	ld	s0,80(sp)
     766:	64a6                	ld	s1,72(sp)
     768:	6906                	ld	s2,64(sp)
     76a:	79e2                	ld	s3,56(sp)
     76c:	7a42                	ld	s4,48(sp)
     76e:	7aa2                	ld	s5,40(sp)
     770:	6125                	addi	sp,sp,96
     772:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     774:	862a                	mv	a2,a0
     776:	85d6                	mv	a1,s5
     778:	00005517          	auipc	a0,0x5
     77c:	71850513          	addi	a0,a0,1816 # 5e90 <statistics+0x5ee>
     780:	00005097          	auipc	ra,0x5
     784:	f80080e7          	jalr	-128(ra) # 5700 <printf>
    exit(1);
     788:	4505                	li	a0,1
     78a:	00005097          	auipc	ra,0x5
     78e:	bfe080e7          	jalr	-1026(ra) # 5388 <exit>
    printf("aaa fd3=%d\n", fd3);
     792:	85ca                	mv	a1,s2
     794:	00005517          	auipc	a0,0x5
     798:	71c50513          	addi	a0,a0,1820 # 5eb0 <statistics+0x60e>
     79c:	00005097          	auipc	ra,0x5
     7a0:	f64080e7          	jalr	-156(ra) # 5700 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7a4:	8652                	mv	a2,s4
     7a6:	85d6                	mv	a1,s5
     7a8:	00005517          	auipc	a0,0x5
     7ac:	71850513          	addi	a0,a0,1816 # 5ec0 <statistics+0x61e>
     7b0:	00005097          	auipc	ra,0x5
     7b4:	f50080e7          	jalr	-176(ra) # 5700 <printf>
    exit(1);
     7b8:	4505                	li	a0,1
     7ba:	00005097          	auipc	ra,0x5
     7be:	bce080e7          	jalr	-1074(ra) # 5388 <exit>
    printf("bbb fd2=%d\n", fd2);
     7c2:	85a6                	mv	a1,s1
     7c4:	00005517          	auipc	a0,0x5
     7c8:	71c50513          	addi	a0,a0,1820 # 5ee0 <statistics+0x63e>
     7cc:	00005097          	auipc	ra,0x5
     7d0:	f34080e7          	jalr	-204(ra) # 5700 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7d4:	8652                	mv	a2,s4
     7d6:	85d6                	mv	a1,s5
     7d8:	00005517          	auipc	a0,0x5
     7dc:	6e850513          	addi	a0,a0,1768 # 5ec0 <statistics+0x61e>
     7e0:	00005097          	auipc	ra,0x5
     7e4:	f20080e7          	jalr	-224(ra) # 5700 <printf>
    exit(1);
     7e8:	4505                	li	a0,1
     7ea:	00005097          	auipc	ra,0x5
     7ee:	b9e080e7          	jalr	-1122(ra) # 5388 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7f2:	862a                	mv	a2,a0
     7f4:	85d6                	mv	a1,s5
     7f6:	00005517          	auipc	a0,0x5
     7fa:	70250513          	addi	a0,a0,1794 # 5ef8 <statistics+0x656>
     7fe:	00005097          	auipc	ra,0x5
     802:	f02080e7          	jalr	-254(ra) # 5700 <printf>
    exit(1);
     806:	4505                	li	a0,1
     808:	00005097          	auipc	ra,0x5
     80c:	b80080e7          	jalr	-1152(ra) # 5388 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     810:	862a                	mv	a2,a0
     812:	85d6                	mv	a1,s5
     814:	00005517          	auipc	a0,0x5
     818:	70450513          	addi	a0,a0,1796 # 5f18 <statistics+0x676>
     81c:	00005097          	auipc	ra,0x5
     820:	ee4080e7          	jalr	-284(ra) # 5700 <printf>
    exit(1);
     824:	4505                	li	a0,1
     826:	00005097          	auipc	ra,0x5
     82a:	b62080e7          	jalr	-1182(ra) # 5388 <exit>

000000000000082e <writetest>:
{
     82e:	7139                	addi	sp,sp,-64
     830:	fc06                	sd	ra,56(sp)
     832:	f822                	sd	s0,48(sp)
     834:	f426                	sd	s1,40(sp)
     836:	f04a                	sd	s2,32(sp)
     838:	ec4e                	sd	s3,24(sp)
     83a:	e852                	sd	s4,16(sp)
     83c:	e456                	sd	s5,8(sp)
     83e:	e05a                	sd	s6,0(sp)
     840:	0080                	addi	s0,sp,64
     842:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     844:	20200593          	li	a1,514
     848:	00005517          	auipc	a0,0x5
     84c:	6f050513          	addi	a0,a0,1776 # 5f38 <statistics+0x696>
     850:	00005097          	auipc	ra,0x5
     854:	b78080e7          	jalr	-1160(ra) # 53c8 <open>
  if(fd < 0){
     858:	0a054d63          	bltz	a0,912 <writetest+0xe4>
     85c:	892a                	mv	s2,a0
     85e:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     860:	00005997          	auipc	s3,0x5
     864:	70098993          	addi	s3,s3,1792 # 5f60 <statistics+0x6be>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     868:	00005a97          	auipc	s5,0x5
     86c:	730a8a93          	addi	s5,s5,1840 # 5f98 <statistics+0x6f6>
  for(i = 0; i < N; i++){
     870:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     874:	4629                	li	a2,10
     876:	85ce                	mv	a1,s3
     878:	854a                	mv	a0,s2
     87a:	00005097          	auipc	ra,0x5
     87e:	b2e080e7          	jalr	-1234(ra) # 53a8 <write>
     882:	47a9                	li	a5,10
     884:	0af51563          	bne	a0,a5,92e <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     888:	4629                	li	a2,10
     88a:	85d6                	mv	a1,s5
     88c:	854a                	mv	a0,s2
     88e:	00005097          	auipc	ra,0x5
     892:	b1a080e7          	jalr	-1254(ra) # 53a8 <write>
     896:	47a9                	li	a5,10
     898:	0af51963          	bne	a0,a5,94a <writetest+0x11c>
  for(i = 0; i < N; i++){
     89c:	2485                	addiw	s1,s1,1
     89e:	fd449be3          	bne	s1,s4,874 <writetest+0x46>
  close(fd);
     8a2:	854a                	mv	a0,s2
     8a4:	00005097          	auipc	ra,0x5
     8a8:	b0c080e7          	jalr	-1268(ra) # 53b0 <close>
  fd = open("small", O_RDONLY);
     8ac:	4581                	li	a1,0
     8ae:	00005517          	auipc	a0,0x5
     8b2:	68a50513          	addi	a0,a0,1674 # 5f38 <statistics+0x696>
     8b6:	00005097          	auipc	ra,0x5
     8ba:	b12080e7          	jalr	-1262(ra) # 53c8 <open>
     8be:	84aa                	mv	s1,a0
  if(fd < 0){
     8c0:	0a054363          	bltz	a0,966 <writetest+0x138>
  i = read(fd, buf, N*SZ*2);
     8c4:	7d000613          	li	a2,2000
     8c8:	0000b597          	auipc	a1,0xb
     8cc:	f3858593          	addi	a1,a1,-200 # b800 <buf>
     8d0:	00005097          	auipc	ra,0x5
     8d4:	ad0080e7          	jalr	-1328(ra) # 53a0 <read>
  if(i != N*SZ*2){
     8d8:	7d000793          	li	a5,2000
     8dc:	0af51363          	bne	a0,a5,982 <writetest+0x154>
  close(fd);
     8e0:	8526                	mv	a0,s1
     8e2:	00005097          	auipc	ra,0x5
     8e6:	ace080e7          	jalr	-1330(ra) # 53b0 <close>
  if(unlink("small") < 0){
     8ea:	00005517          	auipc	a0,0x5
     8ee:	64e50513          	addi	a0,a0,1614 # 5f38 <statistics+0x696>
     8f2:	00005097          	auipc	ra,0x5
     8f6:	ae6080e7          	jalr	-1306(ra) # 53d8 <unlink>
     8fa:	0a054263          	bltz	a0,99e <writetest+0x170>
}
     8fe:	70e2                	ld	ra,56(sp)
     900:	7442                	ld	s0,48(sp)
     902:	74a2                	ld	s1,40(sp)
     904:	7902                	ld	s2,32(sp)
     906:	69e2                	ld	s3,24(sp)
     908:	6a42                	ld	s4,16(sp)
     90a:	6aa2                	ld	s5,8(sp)
     90c:	6b02                	ld	s6,0(sp)
     90e:	6121                	addi	sp,sp,64
     910:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     912:	85da                	mv	a1,s6
     914:	00005517          	auipc	a0,0x5
     918:	62c50513          	addi	a0,a0,1580 # 5f40 <statistics+0x69e>
     91c:	00005097          	auipc	ra,0x5
     920:	de4080e7          	jalr	-540(ra) # 5700 <printf>
    exit(1);
     924:	4505                	li	a0,1
     926:	00005097          	auipc	ra,0x5
     92a:	a62080e7          	jalr	-1438(ra) # 5388 <exit>
      printf("%s: error: write aa %d new file failed\n", i);
     92e:	85a6                	mv	a1,s1
     930:	00005517          	auipc	a0,0x5
     934:	64050513          	addi	a0,a0,1600 # 5f70 <statistics+0x6ce>
     938:	00005097          	auipc	ra,0x5
     93c:	dc8080e7          	jalr	-568(ra) # 5700 <printf>
      exit(1);
     940:	4505                	li	a0,1
     942:	00005097          	auipc	ra,0x5
     946:	a46080e7          	jalr	-1466(ra) # 5388 <exit>
      printf("%s: error: write bb %d new file failed\n", i);
     94a:	85a6                	mv	a1,s1
     94c:	00005517          	auipc	a0,0x5
     950:	65c50513          	addi	a0,a0,1628 # 5fa8 <statistics+0x706>
     954:	00005097          	auipc	ra,0x5
     958:	dac080e7          	jalr	-596(ra) # 5700 <printf>
      exit(1);
     95c:	4505                	li	a0,1
     95e:	00005097          	auipc	ra,0x5
     962:	a2a080e7          	jalr	-1494(ra) # 5388 <exit>
    printf("%s: error: open small failed!\n", s);
     966:	85da                	mv	a1,s6
     968:	00005517          	auipc	a0,0x5
     96c:	66850513          	addi	a0,a0,1640 # 5fd0 <statistics+0x72e>
     970:	00005097          	auipc	ra,0x5
     974:	d90080e7          	jalr	-624(ra) # 5700 <printf>
    exit(1);
     978:	4505                	li	a0,1
     97a:	00005097          	auipc	ra,0x5
     97e:	a0e080e7          	jalr	-1522(ra) # 5388 <exit>
    printf("%s: read failed\n", s);
     982:	85da                	mv	a1,s6
     984:	00005517          	auipc	a0,0x5
     988:	66c50513          	addi	a0,a0,1644 # 5ff0 <statistics+0x74e>
     98c:	00005097          	auipc	ra,0x5
     990:	d74080e7          	jalr	-652(ra) # 5700 <printf>
    exit(1);
     994:	4505                	li	a0,1
     996:	00005097          	auipc	ra,0x5
     99a:	9f2080e7          	jalr	-1550(ra) # 5388 <exit>
    printf("%s: unlink small failed\n", s);
     99e:	85da                	mv	a1,s6
     9a0:	00005517          	auipc	a0,0x5
     9a4:	66850513          	addi	a0,a0,1640 # 6008 <statistics+0x766>
     9a8:	00005097          	auipc	ra,0x5
     9ac:	d58080e7          	jalr	-680(ra) # 5700 <printf>
    exit(1);
     9b0:	4505                	li	a0,1
     9b2:	00005097          	auipc	ra,0x5
     9b6:	9d6080e7          	jalr	-1578(ra) # 5388 <exit>

00000000000009ba <writebig>:
{
     9ba:	7139                	addi	sp,sp,-64
     9bc:	fc06                	sd	ra,56(sp)
     9be:	f822                	sd	s0,48(sp)
     9c0:	f426                	sd	s1,40(sp)
     9c2:	f04a                	sd	s2,32(sp)
     9c4:	ec4e                	sd	s3,24(sp)
     9c6:	e852                	sd	s4,16(sp)
     9c8:	e456                	sd	s5,8(sp)
     9ca:	0080                	addi	s0,sp,64
     9cc:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9ce:	20200593          	li	a1,514
     9d2:	00005517          	auipc	a0,0x5
     9d6:	65650513          	addi	a0,a0,1622 # 6028 <statistics+0x786>
     9da:	00005097          	auipc	ra,0x5
     9de:	9ee080e7          	jalr	-1554(ra) # 53c8 <open>
     9e2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e6:	0000b917          	auipc	s2,0xb
     9ea:	e1a90913          	addi	s2,s2,-486 # b800 <buf>
  for(i = 0; i < MAXFILE; i++){
     9ee:	10c00a13          	li	s4,268
  if(fd < 0){
     9f2:	06054c63          	bltz	a0,a6a <writebig+0xb0>
    ((int*)buf)[0] = i;
     9f6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9fa:	40000613          	li	a2,1024
     9fe:	85ca                	mv	a1,s2
     a00:	854e                	mv	a0,s3
     a02:	00005097          	auipc	ra,0x5
     a06:	9a6080e7          	jalr	-1626(ra) # 53a8 <write>
     a0a:	40000793          	li	a5,1024
     a0e:	06f51c63          	bne	a0,a5,a86 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a12:	2485                	addiw	s1,s1,1
     a14:	ff4491e3          	bne	s1,s4,9f6 <writebig+0x3c>
  close(fd);
     a18:	854e                	mv	a0,s3
     a1a:	00005097          	auipc	ra,0x5
     a1e:	996080e7          	jalr	-1642(ra) # 53b0 <close>
  fd = open("big", O_RDONLY);
     a22:	4581                	li	a1,0
     a24:	00005517          	auipc	a0,0x5
     a28:	60450513          	addi	a0,a0,1540 # 6028 <statistics+0x786>
     a2c:	00005097          	auipc	ra,0x5
     a30:	99c080e7          	jalr	-1636(ra) # 53c8 <open>
     a34:	89aa                	mv	s3,a0
  n = 0;
     a36:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a38:	0000b917          	auipc	s2,0xb
     a3c:	dc890913          	addi	s2,s2,-568 # b800 <buf>
  if(fd < 0){
     a40:	06054163          	bltz	a0,aa2 <writebig+0xe8>
    i = read(fd, buf, BSIZE);
     a44:	40000613          	li	a2,1024
     a48:	85ca                	mv	a1,s2
     a4a:	854e                	mv	a0,s3
     a4c:	00005097          	auipc	ra,0x5
     a50:	954080e7          	jalr	-1708(ra) # 53a0 <read>
    if(i == 0){
     a54:	c52d                	beqz	a0,abe <writebig+0x104>
    } else if(i != BSIZE){
     a56:	40000793          	li	a5,1024
     a5a:	0af51d63          	bne	a0,a5,b14 <writebig+0x15a>
    if(((int*)buf)[0] != n){
     a5e:	00092603          	lw	a2,0(s2)
     a62:	0c961763          	bne	a2,s1,b30 <writebig+0x176>
    n++;
     a66:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a68:	bff1                	j	a44 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a6a:	85d6                	mv	a1,s5
     a6c:	00005517          	auipc	a0,0x5
     a70:	5c450513          	addi	a0,a0,1476 # 6030 <statistics+0x78e>
     a74:	00005097          	auipc	ra,0x5
     a78:	c8c080e7          	jalr	-884(ra) # 5700 <printf>
    exit(1);
     a7c:	4505                	li	a0,1
     a7e:	00005097          	auipc	ra,0x5
     a82:	90a080e7          	jalr	-1782(ra) # 5388 <exit>
      printf("%s: error: write big file failed\n", i);
     a86:	85a6                	mv	a1,s1
     a88:	00005517          	auipc	a0,0x5
     a8c:	5c850513          	addi	a0,a0,1480 # 6050 <statistics+0x7ae>
     a90:	00005097          	auipc	ra,0x5
     a94:	c70080e7          	jalr	-912(ra) # 5700 <printf>
      exit(1);
     a98:	4505                	li	a0,1
     a9a:	00005097          	auipc	ra,0x5
     a9e:	8ee080e7          	jalr	-1810(ra) # 5388 <exit>
    printf("%s: error: open big failed!\n", s);
     aa2:	85d6                	mv	a1,s5
     aa4:	00005517          	auipc	a0,0x5
     aa8:	5d450513          	addi	a0,a0,1492 # 6078 <statistics+0x7d6>
     aac:	00005097          	auipc	ra,0x5
     ab0:	c54080e7          	jalr	-940(ra) # 5700 <printf>
    exit(1);
     ab4:	4505                	li	a0,1
     ab6:	00005097          	auipc	ra,0x5
     aba:	8d2080e7          	jalr	-1838(ra) # 5388 <exit>
      if(n == MAXFILE - 1){
     abe:	10b00793          	li	a5,267
     ac2:	02f48a63          	beq	s1,a5,af6 <writebig+0x13c>
  close(fd);
     ac6:	854e                	mv	a0,s3
     ac8:	00005097          	auipc	ra,0x5
     acc:	8e8080e7          	jalr	-1816(ra) # 53b0 <close>
  if(unlink("big") < 0){
     ad0:	00005517          	auipc	a0,0x5
     ad4:	55850513          	addi	a0,a0,1368 # 6028 <statistics+0x786>
     ad8:	00005097          	auipc	ra,0x5
     adc:	900080e7          	jalr	-1792(ra) # 53d8 <unlink>
     ae0:	06054663          	bltz	a0,b4c <writebig+0x192>
}
     ae4:	70e2                	ld	ra,56(sp)
     ae6:	7442                	ld	s0,48(sp)
     ae8:	74a2                	ld	s1,40(sp)
     aea:	7902                	ld	s2,32(sp)
     aec:	69e2                	ld	s3,24(sp)
     aee:	6a42                	ld	s4,16(sp)
     af0:	6aa2                	ld	s5,8(sp)
     af2:	6121                	addi	sp,sp,64
     af4:	8082                	ret
        printf("%s: read only %d blocks from big", n);
     af6:	10b00593          	li	a1,267
     afa:	00005517          	auipc	a0,0x5
     afe:	59e50513          	addi	a0,a0,1438 # 6098 <statistics+0x7f6>
     b02:	00005097          	auipc	ra,0x5
     b06:	bfe080e7          	jalr	-1026(ra) # 5700 <printf>
        exit(1);
     b0a:	4505                	li	a0,1
     b0c:	00005097          	auipc	ra,0x5
     b10:	87c080e7          	jalr	-1924(ra) # 5388 <exit>
      printf("%s: read failed %d\n", i);
     b14:	85aa                	mv	a1,a0
     b16:	00005517          	auipc	a0,0x5
     b1a:	5aa50513          	addi	a0,a0,1450 # 60c0 <statistics+0x81e>
     b1e:	00005097          	auipc	ra,0x5
     b22:	be2080e7          	jalr	-1054(ra) # 5700 <printf>
      exit(1);
     b26:	4505                	li	a0,1
     b28:	00005097          	auipc	ra,0x5
     b2c:	860080e7          	jalr	-1952(ra) # 5388 <exit>
      printf("%s: read content of block %d is %d\n",
     b30:	85a6                	mv	a1,s1
     b32:	00005517          	auipc	a0,0x5
     b36:	5a650513          	addi	a0,a0,1446 # 60d8 <statistics+0x836>
     b3a:	00005097          	auipc	ra,0x5
     b3e:	bc6080e7          	jalr	-1082(ra) # 5700 <printf>
      exit(1);
     b42:	4505                	li	a0,1
     b44:	00005097          	auipc	ra,0x5
     b48:	844080e7          	jalr	-1980(ra) # 5388 <exit>
    printf("%s: unlink big failed\n", s);
     b4c:	85d6                	mv	a1,s5
     b4e:	00005517          	auipc	a0,0x5
     b52:	5b250513          	addi	a0,a0,1458 # 6100 <statistics+0x85e>
     b56:	00005097          	auipc	ra,0x5
     b5a:	baa080e7          	jalr	-1110(ra) # 5700 <printf>
    exit(1);
     b5e:	4505                	li	a0,1
     b60:	00005097          	auipc	ra,0x5
     b64:	828080e7          	jalr	-2008(ra) # 5388 <exit>

0000000000000b68 <unlinkread>:
{
     b68:	7179                	addi	sp,sp,-48
     b6a:	f406                	sd	ra,40(sp)
     b6c:	f022                	sd	s0,32(sp)
     b6e:	ec26                	sd	s1,24(sp)
     b70:	e84a                	sd	s2,16(sp)
     b72:	e44e                	sd	s3,8(sp)
     b74:	1800                	addi	s0,sp,48
     b76:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b78:	20200593          	li	a1,514
     b7c:	00005517          	auipc	a0,0x5
     b80:	ef450513          	addi	a0,a0,-268 # 5a70 <statistics+0x1ce>
     b84:	00005097          	auipc	ra,0x5
     b88:	844080e7          	jalr	-1980(ra) # 53c8 <open>
  if(fd < 0){
     b8c:	0e054563          	bltz	a0,c76 <unlinkread+0x10e>
     b90:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b92:	4615                	li	a2,5
     b94:	00005597          	auipc	a1,0x5
     b98:	5a458593          	addi	a1,a1,1444 # 6138 <statistics+0x896>
     b9c:	00005097          	auipc	ra,0x5
     ba0:	80c080e7          	jalr	-2036(ra) # 53a8 <write>
  close(fd);
     ba4:	8526                	mv	a0,s1
     ba6:	00005097          	auipc	ra,0x5
     baa:	80a080e7          	jalr	-2038(ra) # 53b0 <close>
  fd = open("unlinkread", O_RDWR);
     bae:	4589                	li	a1,2
     bb0:	00005517          	auipc	a0,0x5
     bb4:	ec050513          	addi	a0,a0,-320 # 5a70 <statistics+0x1ce>
     bb8:	00005097          	auipc	ra,0x5
     bbc:	810080e7          	jalr	-2032(ra) # 53c8 <open>
     bc0:	84aa                	mv	s1,a0
  if(fd < 0){
     bc2:	0c054863          	bltz	a0,c92 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bc6:	00005517          	auipc	a0,0x5
     bca:	eaa50513          	addi	a0,a0,-342 # 5a70 <statistics+0x1ce>
     bce:	00005097          	auipc	ra,0x5
     bd2:	80a080e7          	jalr	-2038(ra) # 53d8 <unlink>
     bd6:	ed61                	bnez	a0,cae <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd8:	20200593          	li	a1,514
     bdc:	00005517          	auipc	a0,0x5
     be0:	e9450513          	addi	a0,a0,-364 # 5a70 <statistics+0x1ce>
     be4:	00004097          	auipc	ra,0x4
     be8:	7e4080e7          	jalr	2020(ra) # 53c8 <open>
     bec:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     bee:	460d                	li	a2,3
     bf0:	00005597          	auipc	a1,0x5
     bf4:	59058593          	addi	a1,a1,1424 # 6180 <statistics+0x8de>
     bf8:	00004097          	auipc	ra,0x4
     bfc:	7b0080e7          	jalr	1968(ra) # 53a8 <write>
  close(fd1);
     c00:	854a                	mv	a0,s2
     c02:	00004097          	auipc	ra,0x4
     c06:	7ae080e7          	jalr	1966(ra) # 53b0 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c0a:	660d                	lui	a2,0x3
     c0c:	0000b597          	auipc	a1,0xb
     c10:	bf458593          	addi	a1,a1,-1036 # b800 <buf>
     c14:	8526                	mv	a0,s1
     c16:	00004097          	auipc	ra,0x4
     c1a:	78a080e7          	jalr	1930(ra) # 53a0 <read>
     c1e:	4795                	li	a5,5
     c20:	0af51563          	bne	a0,a5,cca <unlinkread+0x162>
  if(buf[0] != 'h'){
     c24:	0000b717          	auipc	a4,0xb
     c28:	bdc74703          	lbu	a4,-1060(a4) # b800 <buf>
     c2c:	06800793          	li	a5,104
     c30:	0af71b63          	bne	a4,a5,ce6 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c34:	4629                	li	a2,10
     c36:	0000b597          	auipc	a1,0xb
     c3a:	bca58593          	addi	a1,a1,-1078 # b800 <buf>
     c3e:	8526                	mv	a0,s1
     c40:	00004097          	auipc	ra,0x4
     c44:	768080e7          	jalr	1896(ra) # 53a8 <write>
     c48:	47a9                	li	a5,10
     c4a:	0af51c63          	bne	a0,a5,d02 <unlinkread+0x19a>
  close(fd);
     c4e:	8526                	mv	a0,s1
     c50:	00004097          	auipc	ra,0x4
     c54:	760080e7          	jalr	1888(ra) # 53b0 <close>
  unlink("unlinkread");
     c58:	00005517          	auipc	a0,0x5
     c5c:	e1850513          	addi	a0,a0,-488 # 5a70 <statistics+0x1ce>
     c60:	00004097          	auipc	ra,0x4
     c64:	778080e7          	jalr	1912(ra) # 53d8 <unlink>
}
     c68:	70a2                	ld	ra,40(sp)
     c6a:	7402                	ld	s0,32(sp)
     c6c:	64e2                	ld	s1,24(sp)
     c6e:	6942                	ld	s2,16(sp)
     c70:	69a2                	ld	s3,8(sp)
     c72:	6145                	addi	sp,sp,48
     c74:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c76:	85ce                	mv	a1,s3
     c78:	00005517          	auipc	a0,0x5
     c7c:	4a050513          	addi	a0,a0,1184 # 6118 <statistics+0x876>
     c80:	00005097          	auipc	ra,0x5
     c84:	a80080e7          	jalr	-1408(ra) # 5700 <printf>
    exit(1);
     c88:	4505                	li	a0,1
     c8a:	00004097          	auipc	ra,0x4
     c8e:	6fe080e7          	jalr	1790(ra) # 5388 <exit>
    printf("%s: open unlinkread failed\n", s);
     c92:	85ce                	mv	a1,s3
     c94:	00005517          	auipc	a0,0x5
     c98:	4ac50513          	addi	a0,a0,1196 # 6140 <statistics+0x89e>
     c9c:	00005097          	auipc	ra,0x5
     ca0:	a64080e7          	jalr	-1436(ra) # 5700 <printf>
    exit(1);
     ca4:	4505                	li	a0,1
     ca6:	00004097          	auipc	ra,0x4
     caa:	6e2080e7          	jalr	1762(ra) # 5388 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     cae:	85ce                	mv	a1,s3
     cb0:	00005517          	auipc	a0,0x5
     cb4:	4b050513          	addi	a0,a0,1200 # 6160 <statistics+0x8be>
     cb8:	00005097          	auipc	ra,0x5
     cbc:	a48080e7          	jalr	-1464(ra) # 5700 <printf>
    exit(1);
     cc0:	4505                	li	a0,1
     cc2:	00004097          	auipc	ra,0x4
     cc6:	6c6080e7          	jalr	1734(ra) # 5388 <exit>
    printf("%s: unlinkread read failed", s);
     cca:	85ce                	mv	a1,s3
     ccc:	00005517          	auipc	a0,0x5
     cd0:	4bc50513          	addi	a0,a0,1212 # 6188 <statistics+0x8e6>
     cd4:	00005097          	auipc	ra,0x5
     cd8:	a2c080e7          	jalr	-1492(ra) # 5700 <printf>
    exit(1);
     cdc:	4505                	li	a0,1
     cde:	00004097          	auipc	ra,0x4
     ce2:	6aa080e7          	jalr	1706(ra) # 5388 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ce6:	85ce                	mv	a1,s3
     ce8:	00005517          	auipc	a0,0x5
     cec:	4c050513          	addi	a0,a0,1216 # 61a8 <statistics+0x906>
     cf0:	00005097          	auipc	ra,0x5
     cf4:	a10080e7          	jalr	-1520(ra) # 5700 <printf>
    exit(1);
     cf8:	4505                	li	a0,1
     cfa:	00004097          	auipc	ra,0x4
     cfe:	68e080e7          	jalr	1678(ra) # 5388 <exit>
    printf("%s: unlinkread write failed\n", s);
     d02:	85ce                	mv	a1,s3
     d04:	00005517          	auipc	a0,0x5
     d08:	4c450513          	addi	a0,a0,1220 # 61c8 <statistics+0x926>
     d0c:	00005097          	auipc	ra,0x5
     d10:	9f4080e7          	jalr	-1548(ra) # 5700 <printf>
    exit(1);
     d14:	4505                	li	a0,1
     d16:	00004097          	auipc	ra,0x4
     d1a:	672080e7          	jalr	1650(ra) # 5388 <exit>

0000000000000d1e <linktest>:
{
     d1e:	1101                	addi	sp,sp,-32
     d20:	ec06                	sd	ra,24(sp)
     d22:	e822                	sd	s0,16(sp)
     d24:	e426                	sd	s1,8(sp)
     d26:	e04a                	sd	s2,0(sp)
     d28:	1000                	addi	s0,sp,32
     d2a:	892a                	mv	s2,a0
  unlink("lf1");
     d2c:	00005517          	auipc	a0,0x5
     d30:	4bc50513          	addi	a0,a0,1212 # 61e8 <statistics+0x946>
     d34:	00004097          	auipc	ra,0x4
     d38:	6a4080e7          	jalr	1700(ra) # 53d8 <unlink>
  unlink("lf2");
     d3c:	00005517          	auipc	a0,0x5
     d40:	4b450513          	addi	a0,a0,1204 # 61f0 <statistics+0x94e>
     d44:	00004097          	auipc	ra,0x4
     d48:	694080e7          	jalr	1684(ra) # 53d8 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d4c:	20200593          	li	a1,514
     d50:	00005517          	auipc	a0,0x5
     d54:	49850513          	addi	a0,a0,1176 # 61e8 <statistics+0x946>
     d58:	00004097          	auipc	ra,0x4
     d5c:	670080e7          	jalr	1648(ra) # 53c8 <open>
  if(fd < 0){
     d60:	10054763          	bltz	a0,e6e <linktest+0x150>
     d64:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d66:	4615                	li	a2,5
     d68:	00005597          	auipc	a1,0x5
     d6c:	3d058593          	addi	a1,a1,976 # 6138 <statistics+0x896>
     d70:	00004097          	auipc	ra,0x4
     d74:	638080e7          	jalr	1592(ra) # 53a8 <write>
     d78:	4795                	li	a5,5
     d7a:	10f51863          	bne	a0,a5,e8a <linktest+0x16c>
  close(fd);
     d7e:	8526                	mv	a0,s1
     d80:	00004097          	auipc	ra,0x4
     d84:	630080e7          	jalr	1584(ra) # 53b0 <close>
  if(link("lf1", "lf2") < 0){
     d88:	00005597          	auipc	a1,0x5
     d8c:	46858593          	addi	a1,a1,1128 # 61f0 <statistics+0x94e>
     d90:	00005517          	auipc	a0,0x5
     d94:	45850513          	addi	a0,a0,1112 # 61e8 <statistics+0x946>
     d98:	00004097          	auipc	ra,0x4
     d9c:	650080e7          	jalr	1616(ra) # 53e8 <link>
     da0:	10054363          	bltz	a0,ea6 <linktest+0x188>
  unlink("lf1");
     da4:	00005517          	auipc	a0,0x5
     da8:	44450513          	addi	a0,a0,1092 # 61e8 <statistics+0x946>
     dac:	00004097          	auipc	ra,0x4
     db0:	62c080e7          	jalr	1580(ra) # 53d8 <unlink>
  if(open("lf1", 0) >= 0){
     db4:	4581                	li	a1,0
     db6:	00005517          	auipc	a0,0x5
     dba:	43250513          	addi	a0,a0,1074 # 61e8 <statistics+0x946>
     dbe:	00004097          	auipc	ra,0x4
     dc2:	60a080e7          	jalr	1546(ra) # 53c8 <open>
     dc6:	0e055e63          	bgez	a0,ec2 <linktest+0x1a4>
  fd = open("lf2", 0);
     dca:	4581                	li	a1,0
     dcc:	00005517          	auipc	a0,0x5
     dd0:	42450513          	addi	a0,a0,1060 # 61f0 <statistics+0x94e>
     dd4:	00004097          	auipc	ra,0x4
     dd8:	5f4080e7          	jalr	1524(ra) # 53c8 <open>
     ddc:	84aa                	mv	s1,a0
  if(fd < 0){
     dde:	10054063          	bltz	a0,ede <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de2:	660d                	lui	a2,0x3
     de4:	0000b597          	auipc	a1,0xb
     de8:	a1c58593          	addi	a1,a1,-1508 # b800 <buf>
     dec:	00004097          	auipc	ra,0x4
     df0:	5b4080e7          	jalr	1460(ra) # 53a0 <read>
     df4:	4795                	li	a5,5
     df6:	10f51263          	bne	a0,a5,efa <linktest+0x1dc>
  close(fd);
     dfa:	8526                	mv	a0,s1
     dfc:	00004097          	auipc	ra,0x4
     e00:	5b4080e7          	jalr	1460(ra) # 53b0 <close>
  if(link("lf2", "lf2") >= 0){
     e04:	00005597          	auipc	a1,0x5
     e08:	3ec58593          	addi	a1,a1,1004 # 61f0 <statistics+0x94e>
     e0c:	852e                	mv	a0,a1
     e0e:	00004097          	auipc	ra,0x4
     e12:	5da080e7          	jalr	1498(ra) # 53e8 <link>
     e16:	10055063          	bgez	a0,f16 <linktest+0x1f8>
  unlink("lf2");
     e1a:	00005517          	auipc	a0,0x5
     e1e:	3d650513          	addi	a0,a0,982 # 61f0 <statistics+0x94e>
     e22:	00004097          	auipc	ra,0x4
     e26:	5b6080e7          	jalr	1462(ra) # 53d8 <unlink>
  if(link("lf2", "lf1") >= 0){
     e2a:	00005597          	auipc	a1,0x5
     e2e:	3be58593          	addi	a1,a1,958 # 61e8 <statistics+0x946>
     e32:	00005517          	auipc	a0,0x5
     e36:	3be50513          	addi	a0,a0,958 # 61f0 <statistics+0x94e>
     e3a:	00004097          	auipc	ra,0x4
     e3e:	5ae080e7          	jalr	1454(ra) # 53e8 <link>
     e42:	0e055863          	bgez	a0,f32 <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e46:	00005597          	auipc	a1,0x5
     e4a:	3a258593          	addi	a1,a1,930 # 61e8 <statistics+0x946>
     e4e:	00005517          	auipc	a0,0x5
     e52:	4aa50513          	addi	a0,a0,1194 # 62f8 <statistics+0xa56>
     e56:	00004097          	auipc	ra,0x4
     e5a:	592080e7          	jalr	1426(ra) # 53e8 <link>
     e5e:	0e055863          	bgez	a0,f4e <linktest+0x230>
}
     e62:	60e2                	ld	ra,24(sp)
     e64:	6442                	ld	s0,16(sp)
     e66:	64a2                	ld	s1,8(sp)
     e68:	6902                	ld	s2,0(sp)
     e6a:	6105                	addi	sp,sp,32
     e6c:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e6e:	85ca                	mv	a1,s2
     e70:	00005517          	auipc	a0,0x5
     e74:	38850513          	addi	a0,a0,904 # 61f8 <statistics+0x956>
     e78:	00005097          	auipc	ra,0x5
     e7c:	888080e7          	jalr	-1912(ra) # 5700 <printf>
    exit(1);
     e80:	4505                	li	a0,1
     e82:	00004097          	auipc	ra,0x4
     e86:	506080e7          	jalr	1286(ra) # 5388 <exit>
    printf("%s: write lf1 failed\n", s);
     e8a:	85ca                	mv	a1,s2
     e8c:	00005517          	auipc	a0,0x5
     e90:	38450513          	addi	a0,a0,900 # 6210 <statistics+0x96e>
     e94:	00005097          	auipc	ra,0x5
     e98:	86c080e7          	jalr	-1940(ra) # 5700 <printf>
    exit(1);
     e9c:	4505                	li	a0,1
     e9e:	00004097          	auipc	ra,0x4
     ea2:	4ea080e7          	jalr	1258(ra) # 5388 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     ea6:	85ca                	mv	a1,s2
     ea8:	00005517          	auipc	a0,0x5
     eac:	38050513          	addi	a0,a0,896 # 6228 <statistics+0x986>
     eb0:	00005097          	auipc	ra,0x5
     eb4:	850080e7          	jalr	-1968(ra) # 5700 <printf>
    exit(1);
     eb8:	4505                	li	a0,1
     eba:	00004097          	auipc	ra,0x4
     ebe:	4ce080e7          	jalr	1230(ra) # 5388 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     ec2:	85ca                	mv	a1,s2
     ec4:	00005517          	auipc	a0,0x5
     ec8:	38450513          	addi	a0,a0,900 # 6248 <statistics+0x9a6>
     ecc:	00005097          	auipc	ra,0x5
     ed0:	834080e7          	jalr	-1996(ra) # 5700 <printf>
    exit(1);
     ed4:	4505                	li	a0,1
     ed6:	00004097          	auipc	ra,0x4
     eda:	4b2080e7          	jalr	1202(ra) # 5388 <exit>
    printf("%s: open lf2 failed\n", s);
     ede:	85ca                	mv	a1,s2
     ee0:	00005517          	auipc	a0,0x5
     ee4:	39850513          	addi	a0,a0,920 # 6278 <statistics+0x9d6>
     ee8:	00005097          	auipc	ra,0x5
     eec:	818080e7          	jalr	-2024(ra) # 5700 <printf>
    exit(1);
     ef0:	4505                	li	a0,1
     ef2:	00004097          	auipc	ra,0x4
     ef6:	496080e7          	jalr	1174(ra) # 5388 <exit>
    printf("%s: read lf2 failed\n", s);
     efa:	85ca                	mv	a1,s2
     efc:	00005517          	auipc	a0,0x5
     f00:	39450513          	addi	a0,a0,916 # 6290 <statistics+0x9ee>
     f04:	00004097          	auipc	ra,0x4
     f08:	7fc080e7          	jalr	2044(ra) # 5700 <printf>
    exit(1);
     f0c:	4505                	li	a0,1
     f0e:	00004097          	auipc	ra,0x4
     f12:	47a080e7          	jalr	1146(ra) # 5388 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f16:	85ca                	mv	a1,s2
     f18:	00005517          	auipc	a0,0x5
     f1c:	39050513          	addi	a0,a0,912 # 62a8 <statistics+0xa06>
     f20:	00004097          	auipc	ra,0x4
     f24:	7e0080e7          	jalr	2016(ra) # 5700 <printf>
    exit(1);
     f28:	4505                	li	a0,1
     f2a:	00004097          	auipc	ra,0x4
     f2e:	45e080e7          	jalr	1118(ra) # 5388 <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f32:	85ca                	mv	a1,s2
     f34:	00005517          	auipc	a0,0x5
     f38:	39c50513          	addi	a0,a0,924 # 62d0 <statistics+0xa2e>
     f3c:	00004097          	auipc	ra,0x4
     f40:	7c4080e7          	jalr	1988(ra) # 5700 <printf>
    exit(1);
     f44:	4505                	li	a0,1
     f46:	00004097          	auipc	ra,0x4
     f4a:	442080e7          	jalr	1090(ra) # 5388 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f4e:	85ca                	mv	a1,s2
     f50:	00005517          	auipc	a0,0x5
     f54:	3b050513          	addi	a0,a0,944 # 6300 <statistics+0xa5e>
     f58:	00004097          	auipc	ra,0x4
     f5c:	7a8080e7          	jalr	1960(ra) # 5700 <printf>
    exit(1);
     f60:	4505                	li	a0,1
     f62:	00004097          	auipc	ra,0x4
     f66:	426080e7          	jalr	1062(ra) # 5388 <exit>

0000000000000f6a <bigdir>:
{
     f6a:	715d                	addi	sp,sp,-80
     f6c:	e486                	sd	ra,72(sp)
     f6e:	e0a2                	sd	s0,64(sp)
     f70:	fc26                	sd	s1,56(sp)
     f72:	f84a                	sd	s2,48(sp)
     f74:	f44e                	sd	s3,40(sp)
     f76:	f052                	sd	s4,32(sp)
     f78:	ec56                	sd	s5,24(sp)
     f7a:	e85a                	sd	s6,16(sp)
     f7c:	0880                	addi	s0,sp,80
     f7e:	89aa                	mv	s3,a0
  unlink("bd");
     f80:	00005517          	auipc	a0,0x5
     f84:	3a050513          	addi	a0,a0,928 # 6320 <statistics+0xa7e>
     f88:	00004097          	auipc	ra,0x4
     f8c:	450080e7          	jalr	1104(ra) # 53d8 <unlink>
  fd = open("bd", O_CREATE);
     f90:	20000593          	li	a1,512
     f94:	00005517          	auipc	a0,0x5
     f98:	38c50513          	addi	a0,a0,908 # 6320 <statistics+0xa7e>
     f9c:	00004097          	auipc	ra,0x4
     fa0:	42c080e7          	jalr	1068(ra) # 53c8 <open>
  if(fd < 0){
     fa4:	0c054963          	bltz	a0,1076 <bigdir+0x10c>
  close(fd);
     fa8:	00004097          	auipc	ra,0x4
     fac:	408080e7          	jalr	1032(ra) # 53b0 <close>
  for(i = 0; i < N; i++){
     fb0:	4901                	li	s2,0
    name[0] = 'x';
     fb2:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fb6:	00005a17          	auipc	s4,0x5
     fba:	36aa0a13          	addi	s4,s4,874 # 6320 <statistics+0xa7e>
  for(i = 0; i < N; i++){
     fbe:	1f400b13          	li	s6,500
    name[0] = 'x';
     fc2:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fc6:	41f9579b          	sraiw	a5,s2,0x1f
     fca:	01a7d71b          	srliw	a4,a5,0x1a
     fce:	012707bb          	addw	a5,a4,s2
     fd2:	4067d69b          	sraiw	a3,a5,0x6
     fd6:	0306869b          	addiw	a3,a3,48
     fda:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fde:	03f7f793          	andi	a5,a5,63
     fe2:	9f99                	subw	a5,a5,a4
     fe4:	0307879b          	addiw	a5,a5,48
     fe8:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fec:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     ff0:	fb040593          	addi	a1,s0,-80
     ff4:	8552                	mv	a0,s4
     ff6:	00004097          	auipc	ra,0x4
     ffa:	3f2080e7          	jalr	1010(ra) # 53e8 <link>
     ffe:	84aa                	mv	s1,a0
    1000:	e949                	bnez	a0,1092 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1002:	2905                	addiw	s2,s2,1
    1004:	fb691fe3          	bne	s2,s6,fc2 <bigdir+0x58>
  unlink("bd");
    1008:	00005517          	auipc	a0,0x5
    100c:	31850513          	addi	a0,a0,792 # 6320 <statistics+0xa7e>
    1010:	00004097          	auipc	ra,0x4
    1014:	3c8080e7          	jalr	968(ra) # 53d8 <unlink>
    name[0] = 'x';
    1018:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    101c:	1f400a13          	li	s4,500
    name[0] = 'x';
    1020:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1024:	41f4d79b          	sraiw	a5,s1,0x1f
    1028:	01a7d71b          	srliw	a4,a5,0x1a
    102c:	009707bb          	addw	a5,a4,s1
    1030:	4067d69b          	sraiw	a3,a5,0x6
    1034:	0306869b          	addiw	a3,a3,48
    1038:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    103c:	03f7f793          	andi	a5,a5,63
    1040:	9f99                	subw	a5,a5,a4
    1042:	0307879b          	addiw	a5,a5,48
    1046:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    104a:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    104e:	fb040513          	addi	a0,s0,-80
    1052:	00004097          	auipc	ra,0x4
    1056:	386080e7          	jalr	902(ra) # 53d8 <unlink>
    105a:	ed21                	bnez	a0,10b2 <bigdir+0x148>
  for(i = 0; i < N; i++){
    105c:	2485                	addiw	s1,s1,1
    105e:	fd4491e3          	bne	s1,s4,1020 <bigdir+0xb6>
}
    1062:	60a6                	ld	ra,72(sp)
    1064:	6406                	ld	s0,64(sp)
    1066:	74e2                	ld	s1,56(sp)
    1068:	7942                	ld	s2,48(sp)
    106a:	79a2                	ld	s3,40(sp)
    106c:	7a02                	ld	s4,32(sp)
    106e:	6ae2                	ld	s5,24(sp)
    1070:	6b42                	ld	s6,16(sp)
    1072:	6161                	addi	sp,sp,80
    1074:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1076:	85ce                	mv	a1,s3
    1078:	00005517          	auipc	a0,0x5
    107c:	2b050513          	addi	a0,a0,688 # 6328 <statistics+0xa86>
    1080:	00004097          	auipc	ra,0x4
    1084:	680080e7          	jalr	1664(ra) # 5700 <printf>
    exit(1);
    1088:	4505                	li	a0,1
    108a:	00004097          	auipc	ra,0x4
    108e:	2fe080e7          	jalr	766(ra) # 5388 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    1092:	fb040613          	addi	a2,s0,-80
    1096:	85ce                	mv	a1,s3
    1098:	00005517          	auipc	a0,0x5
    109c:	2b050513          	addi	a0,a0,688 # 6348 <statistics+0xaa6>
    10a0:	00004097          	auipc	ra,0x4
    10a4:	660080e7          	jalr	1632(ra) # 5700 <printf>
      exit(1);
    10a8:	4505                	li	a0,1
    10aa:	00004097          	auipc	ra,0x4
    10ae:	2de080e7          	jalr	734(ra) # 5388 <exit>
      printf("%s: bigdir unlink failed", s);
    10b2:	85ce                	mv	a1,s3
    10b4:	00005517          	auipc	a0,0x5
    10b8:	2b450513          	addi	a0,a0,692 # 6368 <statistics+0xac6>
    10bc:	00004097          	auipc	ra,0x4
    10c0:	644080e7          	jalr	1604(ra) # 5700 <printf>
      exit(1);
    10c4:	4505                	li	a0,1
    10c6:	00004097          	auipc	ra,0x4
    10ca:	2c2080e7          	jalr	706(ra) # 5388 <exit>

00000000000010ce <validatetest>:
{
    10ce:	7139                	addi	sp,sp,-64
    10d0:	fc06                	sd	ra,56(sp)
    10d2:	f822                	sd	s0,48(sp)
    10d4:	f426                	sd	s1,40(sp)
    10d6:	f04a                	sd	s2,32(sp)
    10d8:	ec4e                	sd	s3,24(sp)
    10da:	e852                	sd	s4,16(sp)
    10dc:	e456                	sd	s5,8(sp)
    10de:	e05a                	sd	s6,0(sp)
    10e0:	0080                	addi	s0,sp,64
    10e2:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10e4:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10e6:	00005997          	auipc	s3,0x5
    10ea:	2a298993          	addi	s3,s3,674 # 6388 <statistics+0xae6>
    10ee:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10f0:	6a85                	lui	s5,0x1
    10f2:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10f6:	85a6                	mv	a1,s1
    10f8:	854e                	mv	a0,s3
    10fa:	00004097          	auipc	ra,0x4
    10fe:	2ee080e7          	jalr	750(ra) # 53e8 <link>
    1102:	01251f63          	bne	a0,s2,1120 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1106:	94d6                	add	s1,s1,s5
    1108:	ff4497e3          	bne	s1,s4,10f6 <validatetest+0x28>
}
    110c:	70e2                	ld	ra,56(sp)
    110e:	7442                	ld	s0,48(sp)
    1110:	74a2                	ld	s1,40(sp)
    1112:	7902                	ld	s2,32(sp)
    1114:	69e2                	ld	s3,24(sp)
    1116:	6a42                	ld	s4,16(sp)
    1118:	6aa2                	ld	s5,8(sp)
    111a:	6b02                	ld	s6,0(sp)
    111c:	6121                	addi	sp,sp,64
    111e:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1120:	85da                	mv	a1,s6
    1122:	00005517          	auipc	a0,0x5
    1126:	27650513          	addi	a0,a0,630 # 6398 <statistics+0xaf6>
    112a:	00004097          	auipc	ra,0x4
    112e:	5d6080e7          	jalr	1494(ra) # 5700 <printf>
      exit(1);
    1132:	4505                	li	a0,1
    1134:	00004097          	auipc	ra,0x4
    1138:	254080e7          	jalr	596(ra) # 5388 <exit>

000000000000113c <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    113c:	7179                	addi	sp,sp,-48
    113e:	f406                	sd	ra,40(sp)
    1140:	f022                	sd	s0,32(sp)
    1142:	ec26                	sd	s1,24(sp)
    1144:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    1146:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    114a:	00007497          	auipc	s1,0x7
    114e:	e7e4b483          	ld	s1,-386(s1) # 7fc8 <__SDATA_BEGIN__>
    1152:	fd840593          	addi	a1,s0,-40
    1156:	8526                	mv	a0,s1
    1158:	00004097          	auipc	ra,0x4
    115c:	268080e7          	jalr	616(ra) # 53c0 <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1160:	8526                	mv	a0,s1
    1162:	00004097          	auipc	ra,0x4
    1166:	236080e7          	jalr	566(ra) # 5398 <pipe>

  exit(0);
    116a:	4501                	li	a0,0
    116c:	00004097          	auipc	ra,0x4
    1170:	21c080e7          	jalr	540(ra) # 5388 <exit>

0000000000001174 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1174:	7139                	addi	sp,sp,-64
    1176:	fc06                	sd	ra,56(sp)
    1178:	f822                	sd	s0,48(sp)
    117a:	f426                	sd	s1,40(sp)
    117c:	f04a                	sd	s2,32(sp)
    117e:	ec4e                	sd	s3,24(sp)
    1180:	0080                	addi	s0,sp,64
    1182:	64b1                	lui	s1,0xc
    1184:	35048493          	addi	s1,s1,848 # c350 <buf+0xb50>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1188:	597d                	li	s2,-1
    118a:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    118e:	00005997          	auipc	s3,0x5
    1192:	ad298993          	addi	s3,s3,-1326 # 5c60 <statistics+0x3be>
    argv[0] = (char*)0xffffffff;
    1196:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    119a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    119e:	fc040593          	addi	a1,s0,-64
    11a2:	854e                	mv	a0,s3
    11a4:	00004097          	auipc	ra,0x4
    11a8:	21c080e7          	jalr	540(ra) # 53c0 <exec>
  for(int i = 0; i < 50000; i++){
    11ac:	34fd                	addiw	s1,s1,-1
    11ae:	f4e5                	bnez	s1,1196 <badarg+0x22>
  }
  
  exit(0);
    11b0:	4501                	li	a0,0
    11b2:	00004097          	auipc	ra,0x4
    11b6:	1d6080e7          	jalr	470(ra) # 5388 <exit>

00000000000011ba <copyinstr2>:
{
    11ba:	7155                	addi	sp,sp,-208
    11bc:	e586                	sd	ra,200(sp)
    11be:	e1a2                	sd	s0,192(sp)
    11c0:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11c2:	f6840793          	addi	a5,s0,-152
    11c6:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11ca:	07800713          	li	a4,120
    11ce:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11d2:	0785                	addi	a5,a5,1
    11d4:	fed79de3          	bne	a5,a3,11ce <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11d8:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11dc:	f6840513          	addi	a0,s0,-152
    11e0:	00004097          	auipc	ra,0x4
    11e4:	1f8080e7          	jalr	504(ra) # 53d8 <unlink>
  if(ret != -1){
    11e8:	57fd                	li	a5,-1
    11ea:	0ef51063          	bne	a0,a5,12ca <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11ee:	20100593          	li	a1,513
    11f2:	f6840513          	addi	a0,s0,-152
    11f6:	00004097          	auipc	ra,0x4
    11fa:	1d2080e7          	jalr	466(ra) # 53c8 <open>
  if(fd != -1){
    11fe:	57fd                	li	a5,-1
    1200:	0ef51563          	bne	a0,a5,12ea <copyinstr2+0x130>
  ret = link(b, b);
    1204:	f6840593          	addi	a1,s0,-152
    1208:	852e                	mv	a0,a1
    120a:	00004097          	auipc	ra,0x4
    120e:	1de080e7          	jalr	478(ra) # 53e8 <link>
  if(ret != -1){
    1212:	57fd                	li	a5,-1
    1214:	0ef51b63          	bne	a0,a5,130a <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1218:	00006797          	auipc	a5,0x6
    121c:	25078793          	addi	a5,a5,592 # 7468 <statistics+0x1bc6>
    1220:	f4f43c23          	sd	a5,-168(s0)
    1224:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1228:	f5840593          	addi	a1,s0,-168
    122c:	f6840513          	addi	a0,s0,-152
    1230:	00004097          	auipc	ra,0x4
    1234:	190080e7          	jalr	400(ra) # 53c0 <exec>
  if(ret != -1){
    1238:	57fd                	li	a5,-1
    123a:	0ef51963          	bne	a0,a5,132c <copyinstr2+0x172>
  int pid = fork();
    123e:	00004097          	auipc	ra,0x4
    1242:	142080e7          	jalr	322(ra) # 5380 <fork>
  if(pid < 0){
    1246:	10054363          	bltz	a0,134c <copyinstr2+0x192>
  if(pid == 0){
    124a:	12051463          	bnez	a0,1372 <copyinstr2+0x1b8>
    124e:	00007797          	auipc	a5,0x7
    1252:	e9a78793          	addi	a5,a5,-358 # 80e8 <big.1269>
    1256:	00008697          	auipc	a3,0x8
    125a:	e9268693          	addi	a3,a3,-366 # 90e8 <__global_pointer$+0x920>
      big[i] = 'x';
    125e:	07800713          	li	a4,120
    1262:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1266:	0785                	addi	a5,a5,1
    1268:	fed79de3          	bne	a5,a3,1262 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    126c:	00008797          	auipc	a5,0x8
    1270:	e6078e23          	sb	zero,-388(a5) # 90e8 <__global_pointer$+0x920>
    char *args2[] = { big, big, big, 0 };
    1274:	00007797          	auipc	a5,0x7
    1278:	96c78793          	addi	a5,a5,-1684 # 7be0 <statistics+0x233e>
    127c:	6390                	ld	a2,0(a5)
    127e:	6794                	ld	a3,8(a5)
    1280:	6b98                	ld	a4,16(a5)
    1282:	6f9c                	ld	a5,24(a5)
    1284:	f2c43823          	sd	a2,-208(s0)
    1288:	f2d43c23          	sd	a3,-200(s0)
    128c:	f4e43023          	sd	a4,-192(s0)
    1290:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1294:	f3040593          	addi	a1,s0,-208
    1298:	00005517          	auipc	a0,0x5
    129c:	9c850513          	addi	a0,a0,-1592 # 5c60 <statistics+0x3be>
    12a0:	00004097          	auipc	ra,0x4
    12a4:	120080e7          	jalr	288(ra) # 53c0 <exec>
    if(ret != -1){
    12a8:	57fd                	li	a5,-1
    12aa:	0af50e63          	beq	a0,a5,1366 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12ae:	55fd                	li	a1,-1
    12b0:	00005517          	auipc	a0,0x5
    12b4:	19050513          	addi	a0,a0,400 # 6440 <statistics+0xb9e>
    12b8:	00004097          	auipc	ra,0x4
    12bc:	448080e7          	jalr	1096(ra) # 5700 <printf>
      exit(1);
    12c0:	4505                	li	a0,1
    12c2:	00004097          	auipc	ra,0x4
    12c6:	0c6080e7          	jalr	198(ra) # 5388 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12ca:	862a                	mv	a2,a0
    12cc:	f6840593          	addi	a1,s0,-152
    12d0:	00005517          	auipc	a0,0x5
    12d4:	0e850513          	addi	a0,a0,232 # 63b8 <statistics+0xb16>
    12d8:	00004097          	auipc	ra,0x4
    12dc:	428080e7          	jalr	1064(ra) # 5700 <printf>
    exit(1);
    12e0:	4505                	li	a0,1
    12e2:	00004097          	auipc	ra,0x4
    12e6:	0a6080e7          	jalr	166(ra) # 5388 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12ea:	862a                	mv	a2,a0
    12ec:	f6840593          	addi	a1,s0,-152
    12f0:	00005517          	auipc	a0,0x5
    12f4:	0e850513          	addi	a0,a0,232 # 63d8 <statistics+0xb36>
    12f8:	00004097          	auipc	ra,0x4
    12fc:	408080e7          	jalr	1032(ra) # 5700 <printf>
    exit(1);
    1300:	4505                	li	a0,1
    1302:	00004097          	auipc	ra,0x4
    1306:	086080e7          	jalr	134(ra) # 5388 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    130a:	86aa                	mv	a3,a0
    130c:	f6840613          	addi	a2,s0,-152
    1310:	85b2                	mv	a1,a2
    1312:	00005517          	auipc	a0,0x5
    1316:	0e650513          	addi	a0,a0,230 # 63f8 <statistics+0xb56>
    131a:	00004097          	auipc	ra,0x4
    131e:	3e6080e7          	jalr	998(ra) # 5700 <printf>
    exit(1);
    1322:	4505                	li	a0,1
    1324:	00004097          	auipc	ra,0x4
    1328:	064080e7          	jalr	100(ra) # 5388 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    132c:	567d                	li	a2,-1
    132e:	f6840593          	addi	a1,s0,-152
    1332:	00005517          	auipc	a0,0x5
    1336:	0ee50513          	addi	a0,a0,238 # 6420 <statistics+0xb7e>
    133a:	00004097          	auipc	ra,0x4
    133e:	3c6080e7          	jalr	966(ra) # 5700 <printf>
    exit(1);
    1342:	4505                	li	a0,1
    1344:	00004097          	auipc	ra,0x4
    1348:	044080e7          	jalr	68(ra) # 5388 <exit>
    printf("fork failed\n");
    134c:	00005517          	auipc	a0,0x5
    1350:	53c50513          	addi	a0,a0,1340 # 6888 <statistics+0xfe6>
    1354:	00004097          	auipc	ra,0x4
    1358:	3ac080e7          	jalr	940(ra) # 5700 <printf>
    exit(1);
    135c:	4505                	li	a0,1
    135e:	00004097          	auipc	ra,0x4
    1362:	02a080e7          	jalr	42(ra) # 5388 <exit>
    exit(747); // OK
    1366:	2eb00513          	li	a0,747
    136a:	00004097          	auipc	ra,0x4
    136e:	01e080e7          	jalr	30(ra) # 5388 <exit>
  int st = 0;
    1372:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1376:	f5440513          	addi	a0,s0,-172
    137a:	00004097          	auipc	ra,0x4
    137e:	016080e7          	jalr	22(ra) # 5390 <wait>
  if(st != 747){
    1382:	f5442703          	lw	a4,-172(s0)
    1386:	2eb00793          	li	a5,747
    138a:	00f71663          	bne	a4,a5,1396 <copyinstr2+0x1dc>
}
    138e:	60ae                	ld	ra,200(sp)
    1390:	640e                	ld	s0,192(sp)
    1392:	6169                	addi	sp,sp,208
    1394:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1396:	00005517          	auipc	a0,0x5
    139a:	0d250513          	addi	a0,a0,210 # 6468 <statistics+0xbc6>
    139e:	00004097          	auipc	ra,0x4
    13a2:	362080e7          	jalr	866(ra) # 5700 <printf>
    exit(1);
    13a6:	4505                	li	a0,1
    13a8:	00004097          	auipc	ra,0x4
    13ac:	fe0080e7          	jalr	-32(ra) # 5388 <exit>

00000000000013b0 <truncate3>:
{
    13b0:	7159                	addi	sp,sp,-112
    13b2:	f486                	sd	ra,104(sp)
    13b4:	f0a2                	sd	s0,96(sp)
    13b6:	eca6                	sd	s1,88(sp)
    13b8:	e8ca                	sd	s2,80(sp)
    13ba:	e4ce                	sd	s3,72(sp)
    13bc:	e0d2                	sd	s4,64(sp)
    13be:	fc56                	sd	s5,56(sp)
    13c0:	1880                	addi	s0,sp,112
    13c2:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13c4:	60100593          	li	a1,1537
    13c8:	00005517          	auipc	a0,0x5
    13cc:	8f050513          	addi	a0,a0,-1808 # 5cb8 <statistics+0x416>
    13d0:	00004097          	auipc	ra,0x4
    13d4:	ff8080e7          	jalr	-8(ra) # 53c8 <open>
    13d8:	00004097          	auipc	ra,0x4
    13dc:	fd8080e7          	jalr	-40(ra) # 53b0 <close>
  pid = fork();
    13e0:	00004097          	auipc	ra,0x4
    13e4:	fa0080e7          	jalr	-96(ra) # 5380 <fork>
  if(pid < 0){
    13e8:	08054063          	bltz	a0,1468 <truncate3+0xb8>
  if(pid == 0){
    13ec:	e969                	bnez	a0,14be <truncate3+0x10e>
    13ee:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13f2:	00005a17          	auipc	s4,0x5
    13f6:	8c6a0a13          	addi	s4,s4,-1850 # 5cb8 <statistics+0x416>
      int n = write(fd, "1234567890", 10);
    13fa:	00005a97          	auipc	s5,0x5
    13fe:	0cea8a93          	addi	s5,s5,206 # 64c8 <statistics+0xc26>
      int fd = open("truncfile", O_WRONLY);
    1402:	4585                	li	a1,1
    1404:	8552                	mv	a0,s4
    1406:	00004097          	auipc	ra,0x4
    140a:	fc2080e7          	jalr	-62(ra) # 53c8 <open>
    140e:	84aa                	mv	s1,a0
      if(fd < 0){
    1410:	06054a63          	bltz	a0,1484 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    1414:	4629                	li	a2,10
    1416:	85d6                	mv	a1,s5
    1418:	00004097          	auipc	ra,0x4
    141c:	f90080e7          	jalr	-112(ra) # 53a8 <write>
      if(n != 10){
    1420:	47a9                	li	a5,10
    1422:	06f51f63          	bne	a0,a5,14a0 <truncate3+0xf0>
      close(fd);
    1426:	8526                	mv	a0,s1
    1428:	00004097          	auipc	ra,0x4
    142c:	f88080e7          	jalr	-120(ra) # 53b0 <close>
      fd = open("truncfile", O_RDONLY);
    1430:	4581                	li	a1,0
    1432:	8552                	mv	a0,s4
    1434:	00004097          	auipc	ra,0x4
    1438:	f94080e7          	jalr	-108(ra) # 53c8 <open>
    143c:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    143e:	02000613          	li	a2,32
    1442:	f9840593          	addi	a1,s0,-104
    1446:	00004097          	auipc	ra,0x4
    144a:	f5a080e7          	jalr	-166(ra) # 53a0 <read>
      close(fd);
    144e:	8526                	mv	a0,s1
    1450:	00004097          	auipc	ra,0x4
    1454:	f60080e7          	jalr	-160(ra) # 53b0 <close>
    for(int i = 0; i < 100; i++){
    1458:	39fd                	addiw	s3,s3,-1
    145a:	fa0994e3          	bnez	s3,1402 <truncate3+0x52>
    exit(0);
    145e:	4501                	li	a0,0
    1460:	00004097          	auipc	ra,0x4
    1464:	f28080e7          	jalr	-216(ra) # 5388 <exit>
    printf("%s: fork failed\n", s);
    1468:	85ca                	mv	a1,s2
    146a:	00005517          	auipc	a0,0x5
    146e:	02e50513          	addi	a0,a0,46 # 6498 <statistics+0xbf6>
    1472:	00004097          	auipc	ra,0x4
    1476:	28e080e7          	jalr	654(ra) # 5700 <printf>
    exit(1);
    147a:	4505                	li	a0,1
    147c:	00004097          	auipc	ra,0x4
    1480:	f0c080e7          	jalr	-244(ra) # 5388 <exit>
        printf("%s: open failed\n", s);
    1484:	85ca                	mv	a1,s2
    1486:	00005517          	auipc	a0,0x5
    148a:	02a50513          	addi	a0,a0,42 # 64b0 <statistics+0xc0e>
    148e:	00004097          	auipc	ra,0x4
    1492:	272080e7          	jalr	626(ra) # 5700 <printf>
        exit(1);
    1496:	4505                	li	a0,1
    1498:	00004097          	auipc	ra,0x4
    149c:	ef0080e7          	jalr	-272(ra) # 5388 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    14a0:	862a                	mv	a2,a0
    14a2:	85ca                	mv	a1,s2
    14a4:	00005517          	auipc	a0,0x5
    14a8:	03450513          	addi	a0,a0,52 # 64d8 <statistics+0xc36>
    14ac:	00004097          	auipc	ra,0x4
    14b0:	254080e7          	jalr	596(ra) # 5700 <printf>
        exit(1);
    14b4:	4505                	li	a0,1
    14b6:	00004097          	auipc	ra,0x4
    14ba:	ed2080e7          	jalr	-302(ra) # 5388 <exit>
    14be:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14c2:	00004a17          	auipc	s4,0x4
    14c6:	7f6a0a13          	addi	s4,s4,2038 # 5cb8 <statistics+0x416>
    int n = write(fd, "xxx", 3);
    14ca:	00005a97          	auipc	s5,0x5
    14ce:	02ea8a93          	addi	s5,s5,46 # 64f8 <statistics+0xc56>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14d2:	60100593          	li	a1,1537
    14d6:	8552                	mv	a0,s4
    14d8:	00004097          	auipc	ra,0x4
    14dc:	ef0080e7          	jalr	-272(ra) # 53c8 <open>
    14e0:	84aa                	mv	s1,a0
    if(fd < 0){
    14e2:	04054763          	bltz	a0,1530 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14e6:	460d                	li	a2,3
    14e8:	85d6                	mv	a1,s5
    14ea:	00004097          	auipc	ra,0x4
    14ee:	ebe080e7          	jalr	-322(ra) # 53a8 <write>
    if(n != 3){
    14f2:	478d                	li	a5,3
    14f4:	04f51c63          	bne	a0,a5,154c <truncate3+0x19c>
    close(fd);
    14f8:	8526                	mv	a0,s1
    14fa:	00004097          	auipc	ra,0x4
    14fe:	eb6080e7          	jalr	-330(ra) # 53b0 <close>
  for(int i = 0; i < 150; i++){
    1502:	39fd                	addiw	s3,s3,-1
    1504:	fc0997e3          	bnez	s3,14d2 <truncate3+0x122>
  wait(&xstatus);
    1508:	fbc40513          	addi	a0,s0,-68
    150c:	00004097          	auipc	ra,0x4
    1510:	e84080e7          	jalr	-380(ra) # 5390 <wait>
  unlink("truncfile");
    1514:	00004517          	auipc	a0,0x4
    1518:	7a450513          	addi	a0,a0,1956 # 5cb8 <statistics+0x416>
    151c:	00004097          	auipc	ra,0x4
    1520:	ebc080e7          	jalr	-324(ra) # 53d8 <unlink>
  exit(xstatus);
    1524:	fbc42503          	lw	a0,-68(s0)
    1528:	00004097          	auipc	ra,0x4
    152c:	e60080e7          	jalr	-416(ra) # 5388 <exit>
      printf("%s: open failed\n", s);
    1530:	85ca                	mv	a1,s2
    1532:	00005517          	auipc	a0,0x5
    1536:	f7e50513          	addi	a0,a0,-130 # 64b0 <statistics+0xc0e>
    153a:	00004097          	auipc	ra,0x4
    153e:	1c6080e7          	jalr	454(ra) # 5700 <printf>
      exit(1);
    1542:	4505                	li	a0,1
    1544:	00004097          	auipc	ra,0x4
    1548:	e44080e7          	jalr	-444(ra) # 5388 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    154c:	862a                	mv	a2,a0
    154e:	85ca                	mv	a1,s2
    1550:	00005517          	auipc	a0,0x5
    1554:	fb050513          	addi	a0,a0,-80 # 6500 <statistics+0xc5e>
    1558:	00004097          	auipc	ra,0x4
    155c:	1a8080e7          	jalr	424(ra) # 5700 <printf>
      exit(1);
    1560:	4505                	li	a0,1
    1562:	00004097          	auipc	ra,0x4
    1566:	e26080e7          	jalr	-474(ra) # 5388 <exit>

000000000000156a <exectest>:
{
    156a:	715d                	addi	sp,sp,-80
    156c:	e486                	sd	ra,72(sp)
    156e:	e0a2                	sd	s0,64(sp)
    1570:	fc26                	sd	s1,56(sp)
    1572:	f84a                	sd	s2,48(sp)
    1574:	0880                	addi	s0,sp,80
    1576:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1578:	00004797          	auipc	a5,0x4
    157c:	6e878793          	addi	a5,a5,1768 # 5c60 <statistics+0x3be>
    1580:	fcf43023          	sd	a5,-64(s0)
    1584:	00005797          	auipc	a5,0x5
    1588:	f9c78793          	addi	a5,a5,-100 # 6520 <statistics+0xc7e>
    158c:	fcf43423          	sd	a5,-56(s0)
    1590:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1594:	00005517          	auipc	a0,0x5
    1598:	f9450513          	addi	a0,a0,-108 # 6528 <statistics+0xc86>
    159c:	00004097          	auipc	ra,0x4
    15a0:	e3c080e7          	jalr	-452(ra) # 53d8 <unlink>
  pid = fork();
    15a4:	00004097          	auipc	ra,0x4
    15a8:	ddc080e7          	jalr	-548(ra) # 5380 <fork>
  if(pid < 0) {
    15ac:	04054663          	bltz	a0,15f8 <exectest+0x8e>
    15b0:	84aa                	mv	s1,a0
  if(pid == 0) {
    15b2:	e959                	bnez	a0,1648 <exectest+0xde>
    close(1);
    15b4:	4505                	li	a0,1
    15b6:	00004097          	auipc	ra,0x4
    15ba:	dfa080e7          	jalr	-518(ra) # 53b0 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15be:	20100593          	li	a1,513
    15c2:	00005517          	auipc	a0,0x5
    15c6:	f6650513          	addi	a0,a0,-154 # 6528 <statistics+0xc86>
    15ca:	00004097          	auipc	ra,0x4
    15ce:	dfe080e7          	jalr	-514(ra) # 53c8 <open>
    if(fd < 0) {
    15d2:	04054163          	bltz	a0,1614 <exectest+0xaa>
    if(fd != 1) {
    15d6:	4785                	li	a5,1
    15d8:	04f50c63          	beq	a0,a5,1630 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15dc:	85ca                	mv	a1,s2
    15de:	00005517          	auipc	a0,0x5
    15e2:	f6a50513          	addi	a0,a0,-150 # 6548 <statistics+0xca6>
    15e6:	00004097          	auipc	ra,0x4
    15ea:	11a080e7          	jalr	282(ra) # 5700 <printf>
      exit(1);
    15ee:	4505                	li	a0,1
    15f0:	00004097          	auipc	ra,0x4
    15f4:	d98080e7          	jalr	-616(ra) # 5388 <exit>
     printf("%s: fork failed\n", s);
    15f8:	85ca                	mv	a1,s2
    15fa:	00005517          	auipc	a0,0x5
    15fe:	e9e50513          	addi	a0,a0,-354 # 6498 <statistics+0xbf6>
    1602:	00004097          	auipc	ra,0x4
    1606:	0fe080e7          	jalr	254(ra) # 5700 <printf>
     exit(1);
    160a:	4505                	li	a0,1
    160c:	00004097          	auipc	ra,0x4
    1610:	d7c080e7          	jalr	-644(ra) # 5388 <exit>
      printf("%s: create failed\n", s);
    1614:	85ca                	mv	a1,s2
    1616:	00005517          	auipc	a0,0x5
    161a:	f1a50513          	addi	a0,a0,-230 # 6530 <statistics+0xc8e>
    161e:	00004097          	auipc	ra,0x4
    1622:	0e2080e7          	jalr	226(ra) # 5700 <printf>
      exit(1);
    1626:	4505                	li	a0,1
    1628:	00004097          	auipc	ra,0x4
    162c:	d60080e7          	jalr	-672(ra) # 5388 <exit>
    if(exec("echo", echoargv) < 0){
    1630:	fc040593          	addi	a1,s0,-64
    1634:	00004517          	auipc	a0,0x4
    1638:	62c50513          	addi	a0,a0,1580 # 5c60 <statistics+0x3be>
    163c:	00004097          	auipc	ra,0x4
    1640:	d84080e7          	jalr	-636(ra) # 53c0 <exec>
    1644:	02054163          	bltz	a0,1666 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1648:	fdc40513          	addi	a0,s0,-36
    164c:	00004097          	auipc	ra,0x4
    1650:	d44080e7          	jalr	-700(ra) # 5390 <wait>
    1654:	02951763          	bne	a0,s1,1682 <exectest+0x118>
  if(xstatus != 0)
    1658:	fdc42503          	lw	a0,-36(s0)
    165c:	cd0d                	beqz	a0,1696 <exectest+0x12c>
    exit(xstatus);
    165e:	00004097          	auipc	ra,0x4
    1662:	d2a080e7          	jalr	-726(ra) # 5388 <exit>
      printf("%s: exec echo failed\n", s);
    1666:	85ca                	mv	a1,s2
    1668:	00005517          	auipc	a0,0x5
    166c:	ef050513          	addi	a0,a0,-272 # 6558 <statistics+0xcb6>
    1670:	00004097          	auipc	ra,0x4
    1674:	090080e7          	jalr	144(ra) # 5700 <printf>
      exit(1);
    1678:	4505                	li	a0,1
    167a:	00004097          	auipc	ra,0x4
    167e:	d0e080e7          	jalr	-754(ra) # 5388 <exit>
    printf("%s: wait failed!\n", s);
    1682:	85ca                	mv	a1,s2
    1684:	00005517          	auipc	a0,0x5
    1688:	eec50513          	addi	a0,a0,-276 # 6570 <statistics+0xcce>
    168c:	00004097          	auipc	ra,0x4
    1690:	074080e7          	jalr	116(ra) # 5700 <printf>
    1694:	b7d1                	j	1658 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1696:	4581                	li	a1,0
    1698:	00005517          	auipc	a0,0x5
    169c:	e9050513          	addi	a0,a0,-368 # 6528 <statistics+0xc86>
    16a0:	00004097          	auipc	ra,0x4
    16a4:	d28080e7          	jalr	-728(ra) # 53c8 <open>
  if(fd < 0) {
    16a8:	02054a63          	bltz	a0,16dc <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16ac:	4609                	li	a2,2
    16ae:	fb840593          	addi	a1,s0,-72
    16b2:	00004097          	auipc	ra,0x4
    16b6:	cee080e7          	jalr	-786(ra) # 53a0 <read>
    16ba:	4789                	li	a5,2
    16bc:	02f50e63          	beq	a0,a5,16f8 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16c0:	85ca                	mv	a1,s2
    16c2:	00005517          	auipc	a0,0x5
    16c6:	92e50513          	addi	a0,a0,-1746 # 5ff0 <statistics+0x74e>
    16ca:	00004097          	auipc	ra,0x4
    16ce:	036080e7          	jalr	54(ra) # 5700 <printf>
    exit(1);
    16d2:	4505                	li	a0,1
    16d4:	00004097          	auipc	ra,0x4
    16d8:	cb4080e7          	jalr	-844(ra) # 5388 <exit>
    printf("%s: open failed\n", s);
    16dc:	85ca                	mv	a1,s2
    16de:	00005517          	auipc	a0,0x5
    16e2:	dd250513          	addi	a0,a0,-558 # 64b0 <statistics+0xc0e>
    16e6:	00004097          	auipc	ra,0x4
    16ea:	01a080e7          	jalr	26(ra) # 5700 <printf>
    exit(1);
    16ee:	4505                	li	a0,1
    16f0:	00004097          	auipc	ra,0x4
    16f4:	c98080e7          	jalr	-872(ra) # 5388 <exit>
  unlink("echo-ok");
    16f8:	00005517          	auipc	a0,0x5
    16fc:	e3050513          	addi	a0,a0,-464 # 6528 <statistics+0xc86>
    1700:	00004097          	auipc	ra,0x4
    1704:	cd8080e7          	jalr	-808(ra) # 53d8 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1708:	fb844703          	lbu	a4,-72(s0)
    170c:	04f00793          	li	a5,79
    1710:	00f71863          	bne	a4,a5,1720 <exectest+0x1b6>
    1714:	fb944703          	lbu	a4,-71(s0)
    1718:	04b00793          	li	a5,75
    171c:	02f70063          	beq	a4,a5,173c <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1720:	85ca                	mv	a1,s2
    1722:	00005517          	auipc	a0,0x5
    1726:	e6650513          	addi	a0,a0,-410 # 6588 <statistics+0xce6>
    172a:	00004097          	auipc	ra,0x4
    172e:	fd6080e7          	jalr	-42(ra) # 5700 <printf>
    exit(1);
    1732:	4505                	li	a0,1
    1734:	00004097          	auipc	ra,0x4
    1738:	c54080e7          	jalr	-940(ra) # 5388 <exit>
    exit(0);
    173c:	4501                	li	a0,0
    173e:	00004097          	auipc	ra,0x4
    1742:	c4a080e7          	jalr	-950(ra) # 5388 <exit>

0000000000001746 <pipe1>:
{
    1746:	711d                	addi	sp,sp,-96
    1748:	ec86                	sd	ra,88(sp)
    174a:	e8a2                	sd	s0,80(sp)
    174c:	e4a6                	sd	s1,72(sp)
    174e:	e0ca                	sd	s2,64(sp)
    1750:	fc4e                	sd	s3,56(sp)
    1752:	f852                	sd	s4,48(sp)
    1754:	f456                	sd	s5,40(sp)
    1756:	f05a                	sd	s6,32(sp)
    1758:	ec5e                	sd	s7,24(sp)
    175a:	1080                	addi	s0,sp,96
    175c:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    175e:	fa840513          	addi	a0,s0,-88
    1762:	00004097          	auipc	ra,0x4
    1766:	c36080e7          	jalr	-970(ra) # 5398 <pipe>
    176a:	ed25                	bnez	a0,17e2 <pipe1+0x9c>
    176c:	84aa                	mv	s1,a0
  pid = fork();
    176e:	00004097          	auipc	ra,0x4
    1772:	c12080e7          	jalr	-1006(ra) # 5380 <fork>
    1776:	8a2a                	mv	s4,a0
  if(pid == 0){
    1778:	c159                	beqz	a0,17fe <pipe1+0xb8>
  } else if(pid > 0){
    177a:	16a05e63          	blez	a0,18f6 <pipe1+0x1b0>
    close(fds[1]);
    177e:	fac42503          	lw	a0,-84(s0)
    1782:	00004097          	auipc	ra,0x4
    1786:	c2e080e7          	jalr	-978(ra) # 53b0 <close>
    total = 0;
    178a:	8a26                	mv	s4,s1
    cc = 1;
    178c:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    178e:	0000aa97          	auipc	s5,0xa
    1792:	072a8a93          	addi	s5,s5,114 # b800 <buf>
      if(cc > sizeof(buf))
    1796:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1798:	864e                	mv	a2,s3
    179a:	85d6                	mv	a1,s5
    179c:	fa842503          	lw	a0,-88(s0)
    17a0:	00004097          	auipc	ra,0x4
    17a4:	c00080e7          	jalr	-1024(ra) # 53a0 <read>
    17a8:	10a05263          	blez	a0,18ac <pipe1+0x166>
      for(i = 0; i < n; i++){
    17ac:	0000a717          	auipc	a4,0xa
    17b0:	05470713          	addi	a4,a4,84 # b800 <buf>
    17b4:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17b8:	00074683          	lbu	a3,0(a4)
    17bc:	0ff4f793          	andi	a5,s1,255
    17c0:	2485                	addiw	s1,s1,1
    17c2:	0cf69163          	bne	a3,a5,1884 <pipe1+0x13e>
      for(i = 0; i < n; i++){
    17c6:	0705                	addi	a4,a4,1
    17c8:	fec498e3          	bne	s1,a2,17b8 <pipe1+0x72>
      total += n;
    17cc:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17d0:	0019979b          	slliw	a5,s3,0x1
    17d4:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17d8:	013b7363          	bgeu	s6,s3,17de <pipe1+0x98>
        cc = sizeof(buf);
    17dc:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17de:	84b2                	mv	s1,a2
    17e0:	bf65                	j	1798 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17e2:	85ca                	mv	a1,s2
    17e4:	00005517          	auipc	a0,0x5
    17e8:	dbc50513          	addi	a0,a0,-580 # 65a0 <statistics+0xcfe>
    17ec:	00004097          	auipc	ra,0x4
    17f0:	f14080e7          	jalr	-236(ra) # 5700 <printf>
    exit(1);
    17f4:	4505                	li	a0,1
    17f6:	00004097          	auipc	ra,0x4
    17fa:	b92080e7          	jalr	-1134(ra) # 5388 <exit>
    close(fds[0]);
    17fe:	fa842503          	lw	a0,-88(s0)
    1802:	00004097          	auipc	ra,0x4
    1806:	bae080e7          	jalr	-1106(ra) # 53b0 <close>
    for(n = 0; n < N; n++){
    180a:	0000ab17          	auipc	s6,0xa
    180e:	ff6b0b13          	addi	s6,s6,-10 # b800 <buf>
    1812:	416004bb          	negw	s1,s6
    1816:	0ff4f493          	andi	s1,s1,255
    181a:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    181e:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1820:	6a85                	lui	s5,0x1
    1822:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x7d>
{
    1826:	87da                	mv	a5,s6
        buf[i] = seq++;
    1828:	0097873b          	addw	a4,a5,s1
    182c:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1830:	0785                	addi	a5,a5,1
    1832:	fef99be3          	bne	s3,a5,1828 <pipe1+0xe2>
    1836:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    183a:	40900613          	li	a2,1033
    183e:	85de                	mv	a1,s7
    1840:	fac42503          	lw	a0,-84(s0)
    1844:	00004097          	auipc	ra,0x4
    1848:	b64080e7          	jalr	-1180(ra) # 53a8 <write>
    184c:	40900793          	li	a5,1033
    1850:	00f51c63          	bne	a0,a5,1868 <pipe1+0x122>
    for(n = 0; n < N; n++){
    1854:	24a5                	addiw	s1,s1,9
    1856:	0ff4f493          	andi	s1,s1,255
    185a:	fd5a16e3          	bne	s4,s5,1826 <pipe1+0xe0>
    exit(0);
    185e:	4501                	li	a0,0
    1860:	00004097          	auipc	ra,0x4
    1864:	b28080e7          	jalr	-1240(ra) # 5388 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1868:	85ca                	mv	a1,s2
    186a:	00005517          	auipc	a0,0x5
    186e:	d4e50513          	addi	a0,a0,-690 # 65b8 <statistics+0xd16>
    1872:	00004097          	auipc	ra,0x4
    1876:	e8e080e7          	jalr	-370(ra) # 5700 <printf>
        exit(1);
    187a:	4505                	li	a0,1
    187c:	00004097          	auipc	ra,0x4
    1880:	b0c080e7          	jalr	-1268(ra) # 5388 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1884:	85ca                	mv	a1,s2
    1886:	00005517          	auipc	a0,0x5
    188a:	d4a50513          	addi	a0,a0,-694 # 65d0 <statistics+0xd2e>
    188e:	00004097          	auipc	ra,0x4
    1892:	e72080e7          	jalr	-398(ra) # 5700 <printf>
}
    1896:	60e6                	ld	ra,88(sp)
    1898:	6446                	ld	s0,80(sp)
    189a:	64a6                	ld	s1,72(sp)
    189c:	6906                	ld	s2,64(sp)
    189e:	79e2                	ld	s3,56(sp)
    18a0:	7a42                	ld	s4,48(sp)
    18a2:	7aa2                	ld	s5,40(sp)
    18a4:	7b02                	ld	s6,32(sp)
    18a6:	6be2                	ld	s7,24(sp)
    18a8:	6125                	addi	sp,sp,96
    18aa:	8082                	ret
    if(total != N * SZ){
    18ac:	6785                	lui	a5,0x1
    18ae:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x7d>
    18b2:	02fa0063          	beq	s4,a5,18d2 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18b6:	85d2                	mv	a1,s4
    18b8:	00005517          	auipc	a0,0x5
    18bc:	d3050513          	addi	a0,a0,-720 # 65e8 <statistics+0xd46>
    18c0:	00004097          	auipc	ra,0x4
    18c4:	e40080e7          	jalr	-448(ra) # 5700 <printf>
      exit(1);
    18c8:	4505                	li	a0,1
    18ca:	00004097          	auipc	ra,0x4
    18ce:	abe080e7          	jalr	-1346(ra) # 5388 <exit>
    close(fds[0]);
    18d2:	fa842503          	lw	a0,-88(s0)
    18d6:	00004097          	auipc	ra,0x4
    18da:	ada080e7          	jalr	-1318(ra) # 53b0 <close>
    wait(&xstatus);
    18de:	fa440513          	addi	a0,s0,-92
    18e2:	00004097          	auipc	ra,0x4
    18e6:	aae080e7          	jalr	-1362(ra) # 5390 <wait>
    exit(xstatus);
    18ea:	fa442503          	lw	a0,-92(s0)
    18ee:	00004097          	auipc	ra,0x4
    18f2:	a9a080e7          	jalr	-1382(ra) # 5388 <exit>
    printf("%s: fork() failed\n", s);
    18f6:	85ca                	mv	a1,s2
    18f8:	00005517          	auipc	a0,0x5
    18fc:	d1050513          	addi	a0,a0,-752 # 6608 <statistics+0xd66>
    1900:	00004097          	auipc	ra,0x4
    1904:	e00080e7          	jalr	-512(ra) # 5700 <printf>
    exit(1);
    1908:	4505                	li	a0,1
    190a:	00004097          	auipc	ra,0x4
    190e:	a7e080e7          	jalr	-1410(ra) # 5388 <exit>

0000000000001912 <exitwait>:
{
    1912:	7139                	addi	sp,sp,-64
    1914:	fc06                	sd	ra,56(sp)
    1916:	f822                	sd	s0,48(sp)
    1918:	f426                	sd	s1,40(sp)
    191a:	f04a                	sd	s2,32(sp)
    191c:	ec4e                	sd	s3,24(sp)
    191e:	e852                	sd	s4,16(sp)
    1920:	0080                	addi	s0,sp,64
    1922:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1924:	4901                	li	s2,0
    1926:	06400993          	li	s3,100
    pid = fork();
    192a:	00004097          	auipc	ra,0x4
    192e:	a56080e7          	jalr	-1450(ra) # 5380 <fork>
    1932:	84aa                	mv	s1,a0
    if(pid < 0){
    1934:	02054a63          	bltz	a0,1968 <exitwait+0x56>
    if(pid){
    1938:	c151                	beqz	a0,19bc <exitwait+0xaa>
      if(wait(&xstate) != pid){
    193a:	fcc40513          	addi	a0,s0,-52
    193e:	00004097          	auipc	ra,0x4
    1942:	a52080e7          	jalr	-1454(ra) # 5390 <wait>
    1946:	02951f63          	bne	a0,s1,1984 <exitwait+0x72>
      if(i != xstate) {
    194a:	fcc42783          	lw	a5,-52(s0)
    194e:	05279963          	bne	a5,s2,19a0 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1952:	2905                	addiw	s2,s2,1
    1954:	fd391be3          	bne	s2,s3,192a <exitwait+0x18>
}
    1958:	70e2                	ld	ra,56(sp)
    195a:	7442                	ld	s0,48(sp)
    195c:	74a2                	ld	s1,40(sp)
    195e:	7902                	ld	s2,32(sp)
    1960:	69e2                	ld	s3,24(sp)
    1962:	6a42                	ld	s4,16(sp)
    1964:	6121                	addi	sp,sp,64
    1966:	8082                	ret
      printf("%s: fork failed\n", s);
    1968:	85d2                	mv	a1,s4
    196a:	00005517          	auipc	a0,0x5
    196e:	b2e50513          	addi	a0,a0,-1234 # 6498 <statistics+0xbf6>
    1972:	00004097          	auipc	ra,0x4
    1976:	d8e080e7          	jalr	-626(ra) # 5700 <printf>
      exit(1);
    197a:	4505                	li	a0,1
    197c:	00004097          	auipc	ra,0x4
    1980:	a0c080e7          	jalr	-1524(ra) # 5388 <exit>
        printf("%s: wait wrong pid\n", s);
    1984:	85d2                	mv	a1,s4
    1986:	00005517          	auipc	a0,0x5
    198a:	c9a50513          	addi	a0,a0,-870 # 6620 <statistics+0xd7e>
    198e:	00004097          	auipc	ra,0x4
    1992:	d72080e7          	jalr	-654(ra) # 5700 <printf>
        exit(1);
    1996:	4505                	li	a0,1
    1998:	00004097          	auipc	ra,0x4
    199c:	9f0080e7          	jalr	-1552(ra) # 5388 <exit>
        printf("%s: wait wrong exit status\n", s);
    19a0:	85d2                	mv	a1,s4
    19a2:	00005517          	auipc	a0,0x5
    19a6:	c9650513          	addi	a0,a0,-874 # 6638 <statistics+0xd96>
    19aa:	00004097          	auipc	ra,0x4
    19ae:	d56080e7          	jalr	-682(ra) # 5700 <printf>
        exit(1);
    19b2:	4505                	li	a0,1
    19b4:	00004097          	auipc	ra,0x4
    19b8:	9d4080e7          	jalr	-1580(ra) # 5388 <exit>
      exit(i);
    19bc:	854a                	mv	a0,s2
    19be:	00004097          	auipc	ra,0x4
    19c2:	9ca080e7          	jalr	-1590(ra) # 5388 <exit>

00000000000019c6 <twochildren>:
{
    19c6:	1101                	addi	sp,sp,-32
    19c8:	ec06                	sd	ra,24(sp)
    19ca:	e822                	sd	s0,16(sp)
    19cc:	e426                	sd	s1,8(sp)
    19ce:	e04a                	sd	s2,0(sp)
    19d0:	1000                	addi	s0,sp,32
    19d2:	892a                	mv	s2,a0
    19d4:	3e800493          	li	s1,1000
    int pid1 = fork();
    19d8:	00004097          	auipc	ra,0x4
    19dc:	9a8080e7          	jalr	-1624(ra) # 5380 <fork>
    if(pid1 < 0){
    19e0:	02054c63          	bltz	a0,1a18 <twochildren+0x52>
    if(pid1 == 0){
    19e4:	c921                	beqz	a0,1a34 <twochildren+0x6e>
      int pid2 = fork();
    19e6:	00004097          	auipc	ra,0x4
    19ea:	99a080e7          	jalr	-1638(ra) # 5380 <fork>
      if(pid2 < 0){
    19ee:	04054763          	bltz	a0,1a3c <twochildren+0x76>
      if(pid2 == 0){
    19f2:	c13d                	beqz	a0,1a58 <twochildren+0x92>
        wait(0);
    19f4:	4501                	li	a0,0
    19f6:	00004097          	auipc	ra,0x4
    19fa:	99a080e7          	jalr	-1638(ra) # 5390 <wait>
        wait(0);
    19fe:	4501                	li	a0,0
    1a00:	00004097          	auipc	ra,0x4
    1a04:	990080e7          	jalr	-1648(ra) # 5390 <wait>
  for(int i = 0; i < 1000; i++){
    1a08:	34fd                	addiw	s1,s1,-1
    1a0a:	f4f9                	bnez	s1,19d8 <twochildren+0x12>
}
    1a0c:	60e2                	ld	ra,24(sp)
    1a0e:	6442                	ld	s0,16(sp)
    1a10:	64a2                	ld	s1,8(sp)
    1a12:	6902                	ld	s2,0(sp)
    1a14:	6105                	addi	sp,sp,32
    1a16:	8082                	ret
      printf("%s: fork failed\n", s);
    1a18:	85ca                	mv	a1,s2
    1a1a:	00005517          	auipc	a0,0x5
    1a1e:	a7e50513          	addi	a0,a0,-1410 # 6498 <statistics+0xbf6>
    1a22:	00004097          	auipc	ra,0x4
    1a26:	cde080e7          	jalr	-802(ra) # 5700 <printf>
      exit(1);
    1a2a:	4505                	li	a0,1
    1a2c:	00004097          	auipc	ra,0x4
    1a30:	95c080e7          	jalr	-1700(ra) # 5388 <exit>
      exit(0);
    1a34:	00004097          	auipc	ra,0x4
    1a38:	954080e7          	jalr	-1708(ra) # 5388 <exit>
        printf("%s: fork failed\n", s);
    1a3c:	85ca                	mv	a1,s2
    1a3e:	00005517          	auipc	a0,0x5
    1a42:	a5a50513          	addi	a0,a0,-1446 # 6498 <statistics+0xbf6>
    1a46:	00004097          	auipc	ra,0x4
    1a4a:	cba080e7          	jalr	-838(ra) # 5700 <printf>
        exit(1);
    1a4e:	4505                	li	a0,1
    1a50:	00004097          	auipc	ra,0x4
    1a54:	938080e7          	jalr	-1736(ra) # 5388 <exit>
        exit(0);
    1a58:	00004097          	auipc	ra,0x4
    1a5c:	930080e7          	jalr	-1744(ra) # 5388 <exit>

0000000000001a60 <forkfork>:
{
    1a60:	7179                	addi	sp,sp,-48
    1a62:	f406                	sd	ra,40(sp)
    1a64:	f022                	sd	s0,32(sp)
    1a66:	ec26                	sd	s1,24(sp)
    1a68:	1800                	addi	s0,sp,48
    1a6a:	84aa                	mv	s1,a0
    int pid = fork();
    1a6c:	00004097          	auipc	ra,0x4
    1a70:	914080e7          	jalr	-1772(ra) # 5380 <fork>
    if(pid < 0){
    1a74:	04054163          	bltz	a0,1ab6 <forkfork+0x56>
    if(pid == 0){
    1a78:	cd29                	beqz	a0,1ad2 <forkfork+0x72>
    int pid = fork();
    1a7a:	00004097          	auipc	ra,0x4
    1a7e:	906080e7          	jalr	-1786(ra) # 5380 <fork>
    if(pid < 0){
    1a82:	02054a63          	bltz	a0,1ab6 <forkfork+0x56>
    if(pid == 0){
    1a86:	c531                	beqz	a0,1ad2 <forkfork+0x72>
    wait(&xstatus);
    1a88:	fdc40513          	addi	a0,s0,-36
    1a8c:	00004097          	auipc	ra,0x4
    1a90:	904080e7          	jalr	-1788(ra) # 5390 <wait>
    if(xstatus != 0) {
    1a94:	fdc42783          	lw	a5,-36(s0)
    1a98:	ebbd                	bnez	a5,1b0e <forkfork+0xae>
    wait(&xstatus);
    1a9a:	fdc40513          	addi	a0,s0,-36
    1a9e:	00004097          	auipc	ra,0x4
    1aa2:	8f2080e7          	jalr	-1806(ra) # 5390 <wait>
    if(xstatus != 0) {
    1aa6:	fdc42783          	lw	a5,-36(s0)
    1aaa:	e3b5                	bnez	a5,1b0e <forkfork+0xae>
}
    1aac:	70a2                	ld	ra,40(sp)
    1aae:	7402                	ld	s0,32(sp)
    1ab0:	64e2                	ld	s1,24(sp)
    1ab2:	6145                	addi	sp,sp,48
    1ab4:	8082                	ret
      printf("%s: fork failed", s);
    1ab6:	85a6                	mv	a1,s1
    1ab8:	00005517          	auipc	a0,0x5
    1abc:	ba050513          	addi	a0,a0,-1120 # 6658 <statistics+0xdb6>
    1ac0:	00004097          	auipc	ra,0x4
    1ac4:	c40080e7          	jalr	-960(ra) # 5700 <printf>
      exit(1);
    1ac8:	4505                	li	a0,1
    1aca:	00004097          	auipc	ra,0x4
    1ace:	8be080e7          	jalr	-1858(ra) # 5388 <exit>
{
    1ad2:	0c800493          	li	s1,200
        int pid1 = fork();
    1ad6:	00004097          	auipc	ra,0x4
    1ada:	8aa080e7          	jalr	-1878(ra) # 5380 <fork>
        if(pid1 < 0){
    1ade:	00054f63          	bltz	a0,1afc <forkfork+0x9c>
        if(pid1 == 0){
    1ae2:	c115                	beqz	a0,1b06 <forkfork+0xa6>
        wait(0);
    1ae4:	4501                	li	a0,0
    1ae6:	00004097          	auipc	ra,0x4
    1aea:	8aa080e7          	jalr	-1878(ra) # 5390 <wait>
      for(int j = 0; j < 200; j++){
    1aee:	34fd                	addiw	s1,s1,-1
    1af0:	f0fd                	bnez	s1,1ad6 <forkfork+0x76>
      exit(0);
    1af2:	4501                	li	a0,0
    1af4:	00004097          	auipc	ra,0x4
    1af8:	894080e7          	jalr	-1900(ra) # 5388 <exit>
          exit(1);
    1afc:	4505                	li	a0,1
    1afe:	00004097          	auipc	ra,0x4
    1b02:	88a080e7          	jalr	-1910(ra) # 5388 <exit>
          exit(0);
    1b06:	00004097          	auipc	ra,0x4
    1b0a:	882080e7          	jalr	-1918(ra) # 5388 <exit>
      printf("%s: fork in child failed", s);
    1b0e:	85a6                	mv	a1,s1
    1b10:	00005517          	auipc	a0,0x5
    1b14:	b5850513          	addi	a0,a0,-1192 # 6668 <statistics+0xdc6>
    1b18:	00004097          	auipc	ra,0x4
    1b1c:	be8080e7          	jalr	-1048(ra) # 5700 <printf>
      exit(1);
    1b20:	4505                	li	a0,1
    1b22:	00004097          	auipc	ra,0x4
    1b26:	866080e7          	jalr	-1946(ra) # 5388 <exit>

0000000000001b2a <reparent2>:
{
    1b2a:	1101                	addi	sp,sp,-32
    1b2c:	ec06                	sd	ra,24(sp)
    1b2e:	e822                	sd	s0,16(sp)
    1b30:	e426                	sd	s1,8(sp)
    1b32:	1000                	addi	s0,sp,32
    1b34:	32000493          	li	s1,800
    int pid1 = fork();
    1b38:	00004097          	auipc	ra,0x4
    1b3c:	848080e7          	jalr	-1976(ra) # 5380 <fork>
    if(pid1 < 0){
    1b40:	00054f63          	bltz	a0,1b5e <reparent2+0x34>
    if(pid1 == 0){
    1b44:	c915                	beqz	a0,1b78 <reparent2+0x4e>
    wait(0);
    1b46:	4501                	li	a0,0
    1b48:	00004097          	auipc	ra,0x4
    1b4c:	848080e7          	jalr	-1976(ra) # 5390 <wait>
  for(int i = 0; i < 800; i++){
    1b50:	34fd                	addiw	s1,s1,-1
    1b52:	f0fd                	bnez	s1,1b38 <reparent2+0xe>
  exit(0);
    1b54:	4501                	li	a0,0
    1b56:	00004097          	auipc	ra,0x4
    1b5a:	832080e7          	jalr	-1998(ra) # 5388 <exit>
      printf("fork failed\n");
    1b5e:	00005517          	auipc	a0,0x5
    1b62:	d2a50513          	addi	a0,a0,-726 # 6888 <statistics+0xfe6>
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	b9a080e7          	jalr	-1126(ra) # 5700 <printf>
      exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	00004097          	auipc	ra,0x4
    1b74:	818080e7          	jalr	-2024(ra) # 5388 <exit>
      fork();
    1b78:	00004097          	auipc	ra,0x4
    1b7c:	808080e7          	jalr	-2040(ra) # 5380 <fork>
      fork();
    1b80:	00004097          	auipc	ra,0x4
    1b84:	800080e7          	jalr	-2048(ra) # 5380 <fork>
      exit(0);
    1b88:	4501                	li	a0,0
    1b8a:	00003097          	auipc	ra,0x3
    1b8e:	7fe080e7          	jalr	2046(ra) # 5388 <exit>

0000000000001b92 <createdelete>:
{
    1b92:	7175                	addi	sp,sp,-144
    1b94:	e506                	sd	ra,136(sp)
    1b96:	e122                	sd	s0,128(sp)
    1b98:	fca6                	sd	s1,120(sp)
    1b9a:	f8ca                	sd	s2,112(sp)
    1b9c:	f4ce                	sd	s3,104(sp)
    1b9e:	f0d2                	sd	s4,96(sp)
    1ba0:	ecd6                	sd	s5,88(sp)
    1ba2:	e8da                	sd	s6,80(sp)
    1ba4:	e4de                	sd	s7,72(sp)
    1ba6:	e0e2                	sd	s8,64(sp)
    1ba8:	fc66                	sd	s9,56(sp)
    1baa:	0900                	addi	s0,sp,144
    1bac:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1bae:	4901                	li	s2,0
    1bb0:	4991                	li	s3,4
    pid = fork();
    1bb2:	00003097          	auipc	ra,0x3
    1bb6:	7ce080e7          	jalr	1998(ra) # 5380 <fork>
    1bba:	84aa                	mv	s1,a0
    if(pid < 0){
    1bbc:	02054f63          	bltz	a0,1bfa <createdelete+0x68>
    if(pid == 0){
    1bc0:	c939                	beqz	a0,1c16 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bc2:	2905                	addiw	s2,s2,1
    1bc4:	ff3917e3          	bne	s2,s3,1bb2 <createdelete+0x20>
    1bc8:	4491                	li	s1,4
    wait(&xstatus);
    1bca:	f7c40513          	addi	a0,s0,-132
    1bce:	00003097          	auipc	ra,0x3
    1bd2:	7c2080e7          	jalr	1986(ra) # 5390 <wait>
    if(xstatus != 0)
    1bd6:	f7c42903          	lw	s2,-132(s0)
    1bda:	0e091263          	bnez	s2,1cbe <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bde:	34fd                	addiw	s1,s1,-1
    1be0:	f4ed                	bnez	s1,1bca <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1be2:	f8040123          	sb	zero,-126(s0)
    1be6:	03000993          	li	s3,48
    1bea:	5a7d                	li	s4,-1
    1bec:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1bf0:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1bf2:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1bf4:	07400a93          	li	s5,116
    1bf8:	a29d                	j	1d5e <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bfa:	85e6                	mv	a1,s9
    1bfc:	00005517          	auipc	a0,0x5
    1c00:	c8c50513          	addi	a0,a0,-884 # 6888 <statistics+0xfe6>
    1c04:	00004097          	auipc	ra,0x4
    1c08:	afc080e7          	jalr	-1284(ra) # 5700 <printf>
      exit(1);
    1c0c:	4505                	li	a0,1
    1c0e:	00003097          	auipc	ra,0x3
    1c12:	77a080e7          	jalr	1914(ra) # 5388 <exit>
      name[0] = 'p' + pi;
    1c16:	0709091b          	addiw	s2,s2,112
    1c1a:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c1e:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c22:	4951                	li	s2,20
    1c24:	a015                	j	1c48 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c26:	85e6                	mv	a1,s9
    1c28:	00005517          	auipc	a0,0x5
    1c2c:	90850513          	addi	a0,a0,-1784 # 6530 <statistics+0xc8e>
    1c30:	00004097          	auipc	ra,0x4
    1c34:	ad0080e7          	jalr	-1328(ra) # 5700 <printf>
          exit(1);
    1c38:	4505                	li	a0,1
    1c3a:	00003097          	auipc	ra,0x3
    1c3e:	74e080e7          	jalr	1870(ra) # 5388 <exit>
      for(i = 0; i < N; i++){
    1c42:	2485                	addiw	s1,s1,1
    1c44:	07248863          	beq	s1,s2,1cb4 <createdelete+0x122>
        name[1] = '0' + i;
    1c48:	0304879b          	addiw	a5,s1,48
    1c4c:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c50:	20200593          	li	a1,514
    1c54:	f8040513          	addi	a0,s0,-128
    1c58:	00003097          	auipc	ra,0x3
    1c5c:	770080e7          	jalr	1904(ra) # 53c8 <open>
        if(fd < 0){
    1c60:	fc0543e3          	bltz	a0,1c26 <createdelete+0x94>
        close(fd);
    1c64:	00003097          	auipc	ra,0x3
    1c68:	74c080e7          	jalr	1868(ra) # 53b0 <close>
        if(i > 0 && (i % 2 ) == 0){
    1c6c:	fc905be3          	blez	s1,1c42 <createdelete+0xb0>
    1c70:	0014f793          	andi	a5,s1,1
    1c74:	f7f9                	bnez	a5,1c42 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c76:	01f4d79b          	srliw	a5,s1,0x1f
    1c7a:	9fa5                	addw	a5,a5,s1
    1c7c:	4017d79b          	sraiw	a5,a5,0x1
    1c80:	0307879b          	addiw	a5,a5,48
    1c84:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c88:	f8040513          	addi	a0,s0,-128
    1c8c:	00003097          	auipc	ra,0x3
    1c90:	74c080e7          	jalr	1868(ra) # 53d8 <unlink>
    1c94:	fa0557e3          	bgez	a0,1c42 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c98:	85e6                	mv	a1,s9
    1c9a:	00005517          	auipc	a0,0x5
    1c9e:	9ee50513          	addi	a0,a0,-1554 # 6688 <statistics+0xde6>
    1ca2:	00004097          	auipc	ra,0x4
    1ca6:	a5e080e7          	jalr	-1442(ra) # 5700 <printf>
            exit(1);
    1caa:	4505                	li	a0,1
    1cac:	00003097          	auipc	ra,0x3
    1cb0:	6dc080e7          	jalr	1756(ra) # 5388 <exit>
      exit(0);
    1cb4:	4501                	li	a0,0
    1cb6:	00003097          	auipc	ra,0x3
    1cba:	6d2080e7          	jalr	1746(ra) # 5388 <exit>
      exit(1);
    1cbe:	4505                	li	a0,1
    1cc0:	00003097          	auipc	ra,0x3
    1cc4:	6c8080e7          	jalr	1736(ra) # 5388 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cc8:	f8040613          	addi	a2,s0,-128
    1ccc:	85e6                	mv	a1,s9
    1cce:	00005517          	auipc	a0,0x5
    1cd2:	9d250513          	addi	a0,a0,-1582 # 66a0 <statistics+0xdfe>
    1cd6:	00004097          	auipc	ra,0x4
    1cda:	a2a080e7          	jalr	-1494(ra) # 5700 <printf>
        exit(1);
    1cde:	4505                	li	a0,1
    1ce0:	00003097          	auipc	ra,0x3
    1ce4:	6a8080e7          	jalr	1704(ra) # 5388 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ce8:	054b7163          	bgeu	s6,s4,1d2a <createdelete+0x198>
      if(fd >= 0)
    1cec:	02055a63          	bgez	a0,1d20 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1cf0:	2485                	addiw	s1,s1,1
    1cf2:	0ff4f493          	andi	s1,s1,255
    1cf6:	05548c63          	beq	s1,s5,1d4e <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cfa:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cfe:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1d02:	4581                	li	a1,0
    1d04:	f8040513          	addi	a0,s0,-128
    1d08:	00003097          	auipc	ra,0x3
    1d0c:	6c0080e7          	jalr	1728(ra) # 53c8 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d10:	00090463          	beqz	s2,1d18 <createdelete+0x186>
    1d14:	fd2bdae3          	bge	s7,s2,1ce8 <createdelete+0x156>
    1d18:	fa0548e3          	bltz	a0,1cc8 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d1c:	014b7963          	bgeu	s6,s4,1d2e <createdelete+0x19c>
        close(fd);
    1d20:	00003097          	auipc	ra,0x3
    1d24:	690080e7          	jalr	1680(ra) # 53b0 <close>
    1d28:	b7e1                	j	1cf0 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d2a:	fc0543e3          	bltz	a0,1cf0 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d2e:	f8040613          	addi	a2,s0,-128
    1d32:	85e6                	mv	a1,s9
    1d34:	00005517          	auipc	a0,0x5
    1d38:	99450513          	addi	a0,a0,-1644 # 66c8 <statistics+0xe26>
    1d3c:	00004097          	auipc	ra,0x4
    1d40:	9c4080e7          	jalr	-1596(ra) # 5700 <printf>
        exit(1);
    1d44:	4505                	li	a0,1
    1d46:	00003097          	auipc	ra,0x3
    1d4a:	642080e7          	jalr	1602(ra) # 5388 <exit>
  for(i = 0; i < N; i++){
    1d4e:	2905                	addiw	s2,s2,1
    1d50:	2a05                	addiw	s4,s4,1
    1d52:	2985                	addiw	s3,s3,1
    1d54:	0ff9f993          	andi	s3,s3,255
    1d58:	47d1                	li	a5,20
    1d5a:	02f90a63          	beq	s2,a5,1d8e <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d5e:	84e2                	mv	s1,s8
    1d60:	bf69                	j	1cfa <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d62:	2905                	addiw	s2,s2,1
    1d64:	0ff97913          	andi	s2,s2,255
    1d68:	2985                	addiw	s3,s3,1
    1d6a:	0ff9f993          	andi	s3,s3,255
    1d6e:	03490863          	beq	s2,s4,1d9e <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d72:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d74:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d78:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d7c:	f8040513          	addi	a0,s0,-128
    1d80:	00003097          	auipc	ra,0x3
    1d84:	658080e7          	jalr	1624(ra) # 53d8 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d88:	34fd                	addiw	s1,s1,-1
    1d8a:	f4ed                	bnez	s1,1d74 <createdelete+0x1e2>
    1d8c:	bfd9                	j	1d62 <createdelete+0x1d0>
    1d8e:	03000993          	li	s3,48
    1d92:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d96:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d98:	08400a13          	li	s4,132
    1d9c:	bfd9                	j	1d72 <createdelete+0x1e0>
}
    1d9e:	60aa                	ld	ra,136(sp)
    1da0:	640a                	ld	s0,128(sp)
    1da2:	74e6                	ld	s1,120(sp)
    1da4:	7946                	ld	s2,112(sp)
    1da6:	79a6                	ld	s3,104(sp)
    1da8:	7a06                	ld	s4,96(sp)
    1daa:	6ae6                	ld	s5,88(sp)
    1dac:	6b46                	ld	s6,80(sp)
    1dae:	6ba6                	ld	s7,72(sp)
    1db0:	6c06                	ld	s8,64(sp)
    1db2:	7ce2                	ld	s9,56(sp)
    1db4:	6149                	addi	sp,sp,144
    1db6:	8082                	ret

0000000000001db8 <linkunlink>:
{
    1db8:	711d                	addi	sp,sp,-96
    1dba:	ec86                	sd	ra,88(sp)
    1dbc:	e8a2                	sd	s0,80(sp)
    1dbe:	e4a6                	sd	s1,72(sp)
    1dc0:	e0ca                	sd	s2,64(sp)
    1dc2:	fc4e                	sd	s3,56(sp)
    1dc4:	f852                	sd	s4,48(sp)
    1dc6:	f456                	sd	s5,40(sp)
    1dc8:	f05a                	sd	s6,32(sp)
    1dca:	ec5e                	sd	s7,24(sp)
    1dcc:	e862                	sd	s8,16(sp)
    1dce:	e466                	sd	s9,8(sp)
    1dd0:	1080                	addi	s0,sp,96
    1dd2:	84aa                	mv	s1,a0
  unlink("x");
    1dd4:	00004517          	auipc	a0,0x4
    1dd8:	efc50513          	addi	a0,a0,-260 # 5cd0 <statistics+0x42e>
    1ddc:	00003097          	auipc	ra,0x3
    1de0:	5fc080e7          	jalr	1532(ra) # 53d8 <unlink>
  pid = fork();
    1de4:	00003097          	auipc	ra,0x3
    1de8:	59c080e7          	jalr	1436(ra) # 5380 <fork>
  if(pid < 0){
    1dec:	02054b63          	bltz	a0,1e22 <linkunlink+0x6a>
    1df0:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1df2:	4c85                	li	s9,1
    1df4:	e119                	bnez	a0,1dfa <linkunlink+0x42>
    1df6:	06100c93          	li	s9,97
    1dfa:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1dfe:	41c659b7          	lui	s3,0x41c65
    1e02:	e6d9899b          	addiw	s3,s3,-403
    1e06:	690d                	lui	s2,0x3
    1e08:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e0c:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e0e:	4b05                	li	s6,1
      unlink("x");
    1e10:	00004a97          	auipc	s5,0x4
    1e14:	ec0a8a93          	addi	s5,s5,-320 # 5cd0 <statistics+0x42e>
      link("cat", "x");
    1e18:	00005b97          	auipc	s7,0x5
    1e1c:	8d8b8b93          	addi	s7,s7,-1832 # 66f0 <statistics+0xe4e>
    1e20:	a091                	j	1e64 <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    1e22:	85a6                	mv	a1,s1
    1e24:	00004517          	auipc	a0,0x4
    1e28:	67450513          	addi	a0,a0,1652 # 6498 <statistics+0xbf6>
    1e2c:	00004097          	auipc	ra,0x4
    1e30:	8d4080e7          	jalr	-1836(ra) # 5700 <printf>
    exit(1);
    1e34:	4505                	li	a0,1
    1e36:	00003097          	auipc	ra,0x3
    1e3a:	552080e7          	jalr	1362(ra) # 5388 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e3e:	20200593          	li	a1,514
    1e42:	8556                	mv	a0,s5
    1e44:	00003097          	auipc	ra,0x3
    1e48:	584080e7          	jalr	1412(ra) # 53c8 <open>
    1e4c:	00003097          	auipc	ra,0x3
    1e50:	564080e7          	jalr	1380(ra) # 53b0 <close>
    1e54:	a031                	j	1e60 <linkunlink+0xa8>
      unlink("x");
    1e56:	8556                	mv	a0,s5
    1e58:	00003097          	auipc	ra,0x3
    1e5c:	580080e7          	jalr	1408(ra) # 53d8 <unlink>
  for(i = 0; i < 100; i++){
    1e60:	34fd                	addiw	s1,s1,-1
    1e62:	c09d                	beqz	s1,1e88 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e64:	033c87bb          	mulw	a5,s9,s3
    1e68:	012787bb          	addw	a5,a5,s2
    1e6c:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e70:	0347f7bb          	remuw	a5,a5,s4
    1e74:	d7e9                	beqz	a5,1e3e <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e76:	ff6790e3          	bne	a5,s6,1e56 <linkunlink+0x9e>
      link("cat", "x");
    1e7a:	85d6                	mv	a1,s5
    1e7c:	855e                	mv	a0,s7
    1e7e:	00003097          	auipc	ra,0x3
    1e82:	56a080e7          	jalr	1386(ra) # 53e8 <link>
    1e86:	bfe9                	j	1e60 <linkunlink+0xa8>
  if(pid)
    1e88:	020c0463          	beqz	s8,1eb0 <linkunlink+0xf8>
    wait(0);
    1e8c:	4501                	li	a0,0
    1e8e:	00003097          	auipc	ra,0x3
    1e92:	502080e7          	jalr	1282(ra) # 5390 <wait>
}
    1e96:	60e6                	ld	ra,88(sp)
    1e98:	6446                	ld	s0,80(sp)
    1e9a:	64a6                	ld	s1,72(sp)
    1e9c:	6906                	ld	s2,64(sp)
    1e9e:	79e2                	ld	s3,56(sp)
    1ea0:	7a42                	ld	s4,48(sp)
    1ea2:	7aa2                	ld	s5,40(sp)
    1ea4:	7b02                	ld	s6,32(sp)
    1ea6:	6be2                	ld	s7,24(sp)
    1ea8:	6c42                	ld	s8,16(sp)
    1eaa:	6ca2                	ld	s9,8(sp)
    1eac:	6125                	addi	sp,sp,96
    1eae:	8082                	ret
    exit(0);
    1eb0:	4501                	li	a0,0
    1eb2:	00003097          	auipc	ra,0x3
    1eb6:	4d6080e7          	jalr	1238(ra) # 5388 <exit>

0000000000001eba <forktest>:
{
    1eba:	7179                	addi	sp,sp,-48
    1ebc:	f406                	sd	ra,40(sp)
    1ebe:	f022                	sd	s0,32(sp)
    1ec0:	ec26                	sd	s1,24(sp)
    1ec2:	e84a                	sd	s2,16(sp)
    1ec4:	e44e                	sd	s3,8(sp)
    1ec6:	1800                	addi	s0,sp,48
    1ec8:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1eca:	4481                	li	s1,0
    1ecc:	3e800913          	li	s2,1000
    pid = fork();
    1ed0:	00003097          	auipc	ra,0x3
    1ed4:	4b0080e7          	jalr	1200(ra) # 5380 <fork>
    if(pid < 0)
    1ed8:	02054863          	bltz	a0,1f08 <forktest+0x4e>
    if(pid == 0)
    1edc:	c115                	beqz	a0,1f00 <forktest+0x46>
  for(n=0; n<N; n++){
    1ede:	2485                	addiw	s1,s1,1
    1ee0:	ff2498e3          	bne	s1,s2,1ed0 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1ee4:	85ce                	mv	a1,s3
    1ee6:	00005517          	auipc	a0,0x5
    1eea:	82a50513          	addi	a0,a0,-2006 # 6710 <statistics+0xe6e>
    1eee:	00004097          	auipc	ra,0x4
    1ef2:	812080e7          	jalr	-2030(ra) # 5700 <printf>
    exit(1);
    1ef6:	4505                	li	a0,1
    1ef8:	00003097          	auipc	ra,0x3
    1efc:	490080e7          	jalr	1168(ra) # 5388 <exit>
      exit(0);
    1f00:	00003097          	auipc	ra,0x3
    1f04:	488080e7          	jalr	1160(ra) # 5388 <exit>
  if (n == 0) {
    1f08:	cc9d                	beqz	s1,1f46 <forktest+0x8c>
  if(n == N){
    1f0a:	3e800793          	li	a5,1000
    1f0e:	fcf48be3          	beq	s1,a5,1ee4 <forktest+0x2a>
  for(; n > 0; n--){
    1f12:	00905b63          	blez	s1,1f28 <forktest+0x6e>
    if(wait(0) < 0){
    1f16:	4501                	li	a0,0
    1f18:	00003097          	auipc	ra,0x3
    1f1c:	478080e7          	jalr	1144(ra) # 5390 <wait>
    1f20:	04054163          	bltz	a0,1f62 <forktest+0xa8>
  for(; n > 0; n--){
    1f24:	34fd                	addiw	s1,s1,-1
    1f26:	f8e5                	bnez	s1,1f16 <forktest+0x5c>
  if(wait(0) != -1){
    1f28:	4501                	li	a0,0
    1f2a:	00003097          	auipc	ra,0x3
    1f2e:	466080e7          	jalr	1126(ra) # 5390 <wait>
    1f32:	57fd                	li	a5,-1
    1f34:	04f51563          	bne	a0,a5,1f7e <forktest+0xc4>
}
    1f38:	70a2                	ld	ra,40(sp)
    1f3a:	7402                	ld	s0,32(sp)
    1f3c:	64e2                	ld	s1,24(sp)
    1f3e:	6942                	ld	s2,16(sp)
    1f40:	69a2                	ld	s3,8(sp)
    1f42:	6145                	addi	sp,sp,48
    1f44:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1f46:	85ce                	mv	a1,s3
    1f48:	00004517          	auipc	a0,0x4
    1f4c:	7b050513          	addi	a0,a0,1968 # 66f8 <statistics+0xe56>
    1f50:	00003097          	auipc	ra,0x3
    1f54:	7b0080e7          	jalr	1968(ra) # 5700 <printf>
    exit(1);
    1f58:	4505                	li	a0,1
    1f5a:	00003097          	auipc	ra,0x3
    1f5e:	42e080e7          	jalr	1070(ra) # 5388 <exit>
      printf("%s: wait stopped early\n", s);
    1f62:	85ce                	mv	a1,s3
    1f64:	00004517          	auipc	a0,0x4
    1f68:	7d450513          	addi	a0,a0,2004 # 6738 <statistics+0xe96>
    1f6c:	00003097          	auipc	ra,0x3
    1f70:	794080e7          	jalr	1940(ra) # 5700 <printf>
      exit(1);
    1f74:	4505                	li	a0,1
    1f76:	00003097          	auipc	ra,0x3
    1f7a:	412080e7          	jalr	1042(ra) # 5388 <exit>
    printf("%s: wait got too many\n", s);
    1f7e:	85ce                	mv	a1,s3
    1f80:	00004517          	auipc	a0,0x4
    1f84:	7d050513          	addi	a0,a0,2000 # 6750 <statistics+0xeae>
    1f88:	00003097          	auipc	ra,0x3
    1f8c:	778080e7          	jalr	1912(ra) # 5700 <printf>
    exit(1);
    1f90:	4505                	li	a0,1
    1f92:	00003097          	auipc	ra,0x3
    1f96:	3f6080e7          	jalr	1014(ra) # 5388 <exit>

0000000000001f9a <kernmem>:
{
    1f9a:	715d                	addi	sp,sp,-80
    1f9c:	e486                	sd	ra,72(sp)
    1f9e:	e0a2                	sd	s0,64(sp)
    1fa0:	fc26                	sd	s1,56(sp)
    1fa2:	f84a                	sd	s2,48(sp)
    1fa4:	f44e                	sd	s3,40(sp)
    1fa6:	f052                	sd	s4,32(sp)
    1fa8:	ec56                	sd	s5,24(sp)
    1faa:	0880                	addi	s0,sp,80
    1fac:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fae:	4485                	li	s1,1
    1fb0:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1fb2:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fb4:	69b1                	lui	s3,0xc
    1fb6:	35098993          	addi	s3,s3,848 # c350 <buf+0xb50>
    1fba:	1003d937          	lui	s2,0x1003d
    1fbe:	090e                	slli	s2,s2,0x3
    1fc0:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002ec70>
    pid = fork();
    1fc4:	00003097          	auipc	ra,0x3
    1fc8:	3bc080e7          	jalr	956(ra) # 5380 <fork>
    if(pid < 0){
    1fcc:	02054963          	bltz	a0,1ffe <kernmem+0x64>
    if(pid == 0){
    1fd0:	c529                	beqz	a0,201a <kernmem+0x80>
    wait(&xstatus);
    1fd2:	fbc40513          	addi	a0,s0,-68
    1fd6:	00003097          	auipc	ra,0x3
    1fda:	3ba080e7          	jalr	954(ra) # 5390 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1fde:	fbc42783          	lw	a5,-68(s0)
    1fe2:	05579c63          	bne	a5,s5,203a <kernmem+0xa0>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fe6:	94ce                	add	s1,s1,s3
    1fe8:	fd249ee3          	bne	s1,s2,1fc4 <kernmem+0x2a>
}
    1fec:	60a6                	ld	ra,72(sp)
    1fee:	6406                	ld	s0,64(sp)
    1ff0:	74e2                	ld	s1,56(sp)
    1ff2:	7942                	ld	s2,48(sp)
    1ff4:	79a2                	ld	s3,40(sp)
    1ff6:	7a02                	ld	s4,32(sp)
    1ff8:	6ae2                	ld	s5,24(sp)
    1ffa:	6161                	addi	sp,sp,80
    1ffc:	8082                	ret
      printf("%s: fork failed\n", s);
    1ffe:	85d2                	mv	a1,s4
    2000:	00004517          	auipc	a0,0x4
    2004:	49850513          	addi	a0,a0,1176 # 6498 <statistics+0xbf6>
    2008:	00003097          	auipc	ra,0x3
    200c:	6f8080e7          	jalr	1784(ra) # 5700 <printf>
      exit(1);
    2010:	4505                	li	a0,1
    2012:	00003097          	auipc	ra,0x3
    2016:	376080e7          	jalr	886(ra) # 5388 <exit>
      printf("%s: oops could read %x = %x\n", a, *a);
    201a:	0004c603          	lbu	a2,0(s1)
    201e:	85a6                	mv	a1,s1
    2020:	00004517          	auipc	a0,0x4
    2024:	74850513          	addi	a0,a0,1864 # 6768 <statistics+0xec6>
    2028:	00003097          	auipc	ra,0x3
    202c:	6d8080e7          	jalr	1752(ra) # 5700 <printf>
      exit(1);
    2030:	4505                	li	a0,1
    2032:	00003097          	auipc	ra,0x3
    2036:	356080e7          	jalr	854(ra) # 5388 <exit>
      exit(1);
    203a:	4505                	li	a0,1
    203c:	00003097          	auipc	ra,0x3
    2040:	34c080e7          	jalr	844(ra) # 5388 <exit>

0000000000002044 <bigargtest>:
{
    2044:	7179                	addi	sp,sp,-48
    2046:	f406                	sd	ra,40(sp)
    2048:	f022                	sd	s0,32(sp)
    204a:	ec26                	sd	s1,24(sp)
    204c:	1800                	addi	s0,sp,48
    204e:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2050:	00004517          	auipc	a0,0x4
    2054:	73850513          	addi	a0,a0,1848 # 6788 <statistics+0xee6>
    2058:	00003097          	auipc	ra,0x3
    205c:	380080e7          	jalr	896(ra) # 53d8 <unlink>
  pid = fork();
    2060:	00003097          	auipc	ra,0x3
    2064:	320080e7          	jalr	800(ra) # 5380 <fork>
  if(pid == 0){
    2068:	c121                	beqz	a0,20a8 <bigargtest+0x64>
  } else if(pid < 0){
    206a:	0a054063          	bltz	a0,210a <bigargtest+0xc6>
  wait(&xstatus);
    206e:	fdc40513          	addi	a0,s0,-36
    2072:	00003097          	auipc	ra,0x3
    2076:	31e080e7          	jalr	798(ra) # 5390 <wait>
  if(xstatus != 0)
    207a:	fdc42503          	lw	a0,-36(s0)
    207e:	e545                	bnez	a0,2126 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2080:	4581                	li	a1,0
    2082:	00004517          	auipc	a0,0x4
    2086:	70650513          	addi	a0,a0,1798 # 6788 <statistics+0xee6>
    208a:	00003097          	auipc	ra,0x3
    208e:	33e080e7          	jalr	830(ra) # 53c8 <open>
  if(fd < 0){
    2092:	08054e63          	bltz	a0,212e <bigargtest+0xea>
  close(fd);
    2096:	00003097          	auipc	ra,0x3
    209a:	31a080e7          	jalr	794(ra) # 53b0 <close>
}
    209e:	70a2                	ld	ra,40(sp)
    20a0:	7402                	ld	s0,32(sp)
    20a2:	64e2                	ld	s1,24(sp)
    20a4:	6145                	addi	sp,sp,48
    20a6:	8082                	ret
    20a8:	00006797          	auipc	a5,0x6
    20ac:	f4078793          	addi	a5,a5,-192 # 7fe8 <args.1806>
    20b0:	00006697          	auipc	a3,0x6
    20b4:	03068693          	addi	a3,a3,48 # 80e0 <args.1806+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    20b8:	00004717          	auipc	a4,0x4
    20bc:	6e070713          	addi	a4,a4,1760 # 6798 <statistics+0xef6>
    20c0:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    20c2:	07a1                	addi	a5,a5,8
    20c4:	fed79ee3          	bne	a5,a3,20c0 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    20c8:	00006597          	auipc	a1,0x6
    20cc:	f2058593          	addi	a1,a1,-224 # 7fe8 <args.1806>
    20d0:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    20d4:	00004517          	auipc	a0,0x4
    20d8:	b8c50513          	addi	a0,a0,-1140 # 5c60 <statistics+0x3be>
    20dc:	00003097          	auipc	ra,0x3
    20e0:	2e4080e7          	jalr	740(ra) # 53c0 <exec>
    fd = open("bigarg-ok", O_CREATE);
    20e4:	20000593          	li	a1,512
    20e8:	00004517          	auipc	a0,0x4
    20ec:	6a050513          	addi	a0,a0,1696 # 6788 <statistics+0xee6>
    20f0:	00003097          	auipc	ra,0x3
    20f4:	2d8080e7          	jalr	728(ra) # 53c8 <open>
    close(fd);
    20f8:	00003097          	auipc	ra,0x3
    20fc:	2b8080e7          	jalr	696(ra) # 53b0 <close>
    exit(0);
    2100:	4501                	li	a0,0
    2102:	00003097          	auipc	ra,0x3
    2106:	286080e7          	jalr	646(ra) # 5388 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    210a:	85a6                	mv	a1,s1
    210c:	00004517          	auipc	a0,0x4
    2110:	76c50513          	addi	a0,a0,1900 # 6878 <statistics+0xfd6>
    2114:	00003097          	auipc	ra,0x3
    2118:	5ec080e7          	jalr	1516(ra) # 5700 <printf>
    exit(1);
    211c:	4505                	li	a0,1
    211e:	00003097          	auipc	ra,0x3
    2122:	26a080e7          	jalr	618(ra) # 5388 <exit>
    exit(xstatus);
    2126:	00003097          	auipc	ra,0x3
    212a:	262080e7          	jalr	610(ra) # 5388 <exit>
    printf("%s: bigarg test failed!\n", s);
    212e:	85a6                	mv	a1,s1
    2130:	00004517          	auipc	a0,0x4
    2134:	76850513          	addi	a0,a0,1896 # 6898 <statistics+0xff6>
    2138:	00003097          	auipc	ra,0x3
    213c:	5c8080e7          	jalr	1480(ra) # 5700 <printf>
    exit(1);
    2140:	4505                	li	a0,1
    2142:	00003097          	auipc	ra,0x3
    2146:	246080e7          	jalr	582(ra) # 5388 <exit>

000000000000214a <stacktest>:
{
    214a:	7179                	addi	sp,sp,-48
    214c:	f406                	sd	ra,40(sp)
    214e:	f022                	sd	s0,32(sp)
    2150:	ec26                	sd	s1,24(sp)
    2152:	1800                	addi	s0,sp,48
    2154:	84aa                	mv	s1,a0
  pid = fork();
    2156:	00003097          	auipc	ra,0x3
    215a:	22a080e7          	jalr	554(ra) # 5380 <fork>
  if(pid == 0) {
    215e:	c115                	beqz	a0,2182 <stacktest+0x38>
  } else if(pid < 0){
    2160:	04054363          	bltz	a0,21a6 <stacktest+0x5c>
  wait(&xstatus);
    2164:	fdc40513          	addi	a0,s0,-36
    2168:	00003097          	auipc	ra,0x3
    216c:	228080e7          	jalr	552(ra) # 5390 <wait>
  if(xstatus == -1)  // kernel killed child?
    2170:	fdc42503          	lw	a0,-36(s0)
    2174:	57fd                	li	a5,-1
    2176:	04f50663          	beq	a0,a5,21c2 <stacktest+0x78>
    exit(xstatus);
    217a:	00003097          	auipc	ra,0x3
    217e:	20e080e7          	jalr	526(ra) # 5388 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2182:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", *sp);
    2184:	77fd                	lui	a5,0xfffff
    2186:	97ba                	add	a5,a5,a4
    2188:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff07f0>
    218c:	00004517          	auipc	a0,0x4
    2190:	72c50513          	addi	a0,a0,1836 # 68b8 <statistics+0x1016>
    2194:	00003097          	auipc	ra,0x3
    2198:	56c080e7          	jalr	1388(ra) # 5700 <printf>
    exit(1);
    219c:	4505                	li	a0,1
    219e:	00003097          	auipc	ra,0x3
    21a2:	1ea080e7          	jalr	490(ra) # 5388 <exit>
    printf("%s: fork failed\n", s);
    21a6:	85a6                	mv	a1,s1
    21a8:	00004517          	auipc	a0,0x4
    21ac:	2f050513          	addi	a0,a0,752 # 6498 <statistics+0xbf6>
    21b0:	00003097          	auipc	ra,0x3
    21b4:	550080e7          	jalr	1360(ra) # 5700 <printf>
    exit(1);
    21b8:	4505                	li	a0,1
    21ba:	00003097          	auipc	ra,0x3
    21be:	1ce080e7          	jalr	462(ra) # 5388 <exit>
    exit(0);
    21c2:	4501                	li	a0,0
    21c4:	00003097          	auipc	ra,0x3
    21c8:	1c4080e7          	jalr	452(ra) # 5388 <exit>

00000000000021cc <copyinstr3>:
{
    21cc:	7179                	addi	sp,sp,-48
    21ce:	f406                	sd	ra,40(sp)
    21d0:	f022                	sd	s0,32(sp)
    21d2:	ec26                	sd	s1,24(sp)
    21d4:	1800                	addi	s0,sp,48
  sbrk(8192);
    21d6:	6509                	lui	a0,0x2
    21d8:	00003097          	auipc	ra,0x3
    21dc:	238080e7          	jalr	568(ra) # 5410 <sbrk>
  uint64 top = (uint64) sbrk(0);
    21e0:	4501                	li	a0,0
    21e2:	00003097          	auipc	ra,0x3
    21e6:	22e080e7          	jalr	558(ra) # 5410 <sbrk>
  if((top % PGSIZE) != 0){
    21ea:	03451793          	slli	a5,a0,0x34
    21ee:	e3c9                	bnez	a5,2270 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    21f0:	4501                	li	a0,0
    21f2:	00003097          	auipc	ra,0x3
    21f6:	21e080e7          	jalr	542(ra) # 5410 <sbrk>
  if(top % PGSIZE){
    21fa:	03451793          	slli	a5,a0,0x34
    21fe:	e3d9                	bnez	a5,2284 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2200:	fff50493          	addi	s1,a0,-1 # 1fff <kernmem+0x65>
  *b = 'x';
    2204:	07800793          	li	a5,120
    2208:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    220c:	8526                	mv	a0,s1
    220e:	00003097          	auipc	ra,0x3
    2212:	1ca080e7          	jalr	458(ra) # 53d8 <unlink>
  if(ret != -1){
    2216:	57fd                	li	a5,-1
    2218:	08f51363          	bne	a0,a5,229e <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    221c:	20100593          	li	a1,513
    2220:	8526                	mv	a0,s1
    2222:	00003097          	auipc	ra,0x3
    2226:	1a6080e7          	jalr	422(ra) # 53c8 <open>
  if(fd != -1){
    222a:	57fd                	li	a5,-1
    222c:	08f51863          	bne	a0,a5,22bc <copyinstr3+0xf0>
  ret = link(b, b);
    2230:	85a6                	mv	a1,s1
    2232:	8526                	mv	a0,s1
    2234:	00003097          	auipc	ra,0x3
    2238:	1b4080e7          	jalr	436(ra) # 53e8 <link>
  if(ret != -1){
    223c:	57fd                	li	a5,-1
    223e:	08f51e63          	bne	a0,a5,22da <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2242:	00005797          	auipc	a5,0x5
    2246:	22678793          	addi	a5,a5,550 # 7468 <statistics+0x1bc6>
    224a:	fcf43823          	sd	a5,-48(s0)
    224e:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2252:	fd040593          	addi	a1,s0,-48
    2256:	8526                	mv	a0,s1
    2258:	00003097          	auipc	ra,0x3
    225c:	168080e7          	jalr	360(ra) # 53c0 <exec>
  if(ret != -1){
    2260:	57fd                	li	a5,-1
    2262:	08f51c63          	bne	a0,a5,22fa <copyinstr3+0x12e>
}
    2266:	70a2                	ld	ra,40(sp)
    2268:	7402                	ld	s0,32(sp)
    226a:	64e2                	ld	s1,24(sp)
    226c:	6145                	addi	sp,sp,48
    226e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2270:	0347d513          	srli	a0,a5,0x34
    2274:	6785                	lui	a5,0x1
    2276:	40a7853b          	subw	a0,a5,a0
    227a:	00003097          	auipc	ra,0x3
    227e:	196080e7          	jalr	406(ra) # 5410 <sbrk>
    2282:	b7bd                	j	21f0 <copyinstr3+0x24>
    printf("oops\n");
    2284:	00004517          	auipc	a0,0x4
    2288:	65c50513          	addi	a0,a0,1628 # 68e0 <statistics+0x103e>
    228c:	00003097          	auipc	ra,0x3
    2290:	474080e7          	jalr	1140(ra) # 5700 <printf>
    exit(1);
    2294:	4505                	li	a0,1
    2296:	00003097          	auipc	ra,0x3
    229a:	0f2080e7          	jalr	242(ra) # 5388 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    229e:	862a                	mv	a2,a0
    22a0:	85a6                	mv	a1,s1
    22a2:	00004517          	auipc	a0,0x4
    22a6:	11650513          	addi	a0,a0,278 # 63b8 <statistics+0xb16>
    22aa:	00003097          	auipc	ra,0x3
    22ae:	456080e7          	jalr	1110(ra) # 5700 <printf>
    exit(1);
    22b2:	4505                	li	a0,1
    22b4:	00003097          	auipc	ra,0x3
    22b8:	0d4080e7          	jalr	212(ra) # 5388 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    22bc:	862a                	mv	a2,a0
    22be:	85a6                	mv	a1,s1
    22c0:	00004517          	auipc	a0,0x4
    22c4:	11850513          	addi	a0,a0,280 # 63d8 <statistics+0xb36>
    22c8:	00003097          	auipc	ra,0x3
    22cc:	438080e7          	jalr	1080(ra) # 5700 <printf>
    exit(1);
    22d0:	4505                	li	a0,1
    22d2:	00003097          	auipc	ra,0x3
    22d6:	0b6080e7          	jalr	182(ra) # 5388 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    22da:	86aa                	mv	a3,a0
    22dc:	8626                	mv	a2,s1
    22de:	85a6                	mv	a1,s1
    22e0:	00004517          	auipc	a0,0x4
    22e4:	11850513          	addi	a0,a0,280 # 63f8 <statistics+0xb56>
    22e8:	00003097          	auipc	ra,0x3
    22ec:	418080e7          	jalr	1048(ra) # 5700 <printf>
    exit(1);
    22f0:	4505                	li	a0,1
    22f2:	00003097          	auipc	ra,0x3
    22f6:	096080e7          	jalr	150(ra) # 5388 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    22fa:	567d                	li	a2,-1
    22fc:	85a6                	mv	a1,s1
    22fe:	00004517          	auipc	a0,0x4
    2302:	12250513          	addi	a0,a0,290 # 6420 <statistics+0xb7e>
    2306:	00003097          	auipc	ra,0x3
    230a:	3fa080e7          	jalr	1018(ra) # 5700 <printf>
    exit(1);
    230e:	4505                	li	a0,1
    2310:	00003097          	auipc	ra,0x3
    2314:	078080e7          	jalr	120(ra) # 5388 <exit>

0000000000002318 <sbrkbasic>:
{
    2318:	715d                	addi	sp,sp,-80
    231a:	e486                	sd	ra,72(sp)
    231c:	e0a2                	sd	s0,64(sp)
    231e:	fc26                	sd	s1,56(sp)
    2320:	f84a                	sd	s2,48(sp)
    2322:	f44e                	sd	s3,40(sp)
    2324:	f052                	sd	s4,32(sp)
    2326:	ec56                	sd	s5,24(sp)
    2328:	0880                	addi	s0,sp,80
    232a:	8a2a                	mv	s4,a0
  pid = fork();
    232c:	00003097          	auipc	ra,0x3
    2330:	054080e7          	jalr	84(ra) # 5380 <fork>
  if(pid < 0){
    2334:	02054c63          	bltz	a0,236c <sbrkbasic+0x54>
  if(pid == 0){
    2338:	ed21                	bnez	a0,2390 <sbrkbasic+0x78>
    a = sbrk(TOOMUCH);
    233a:	40000537          	lui	a0,0x40000
    233e:	00003097          	auipc	ra,0x3
    2342:	0d2080e7          	jalr	210(ra) # 5410 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2346:	57fd                	li	a5,-1
    2348:	02f50f63          	beq	a0,a5,2386 <sbrkbasic+0x6e>
    for(b = a; b < a+TOOMUCH; b += 4096){
    234c:	400007b7          	lui	a5,0x40000
    2350:	97aa                	add	a5,a5,a0
      *b = 99;
    2352:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2356:	6705                	lui	a4,0x1
      *b = 99;
    2358:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff17f0>
    for(b = a; b < a+TOOMUCH; b += 4096){
    235c:	953a                	add	a0,a0,a4
    235e:	fef51de3          	bne	a0,a5,2358 <sbrkbasic+0x40>
    exit(1);
    2362:	4505                	li	a0,1
    2364:	00003097          	auipc	ra,0x3
    2368:	024080e7          	jalr	36(ra) # 5388 <exit>
    printf("fork failed in sbrkbasic\n");
    236c:	00004517          	auipc	a0,0x4
    2370:	57c50513          	addi	a0,a0,1404 # 68e8 <statistics+0x1046>
    2374:	00003097          	auipc	ra,0x3
    2378:	38c080e7          	jalr	908(ra) # 5700 <printf>
    exit(1);
    237c:	4505                	li	a0,1
    237e:	00003097          	auipc	ra,0x3
    2382:	00a080e7          	jalr	10(ra) # 5388 <exit>
      exit(0);
    2386:	4501                	li	a0,0
    2388:	00003097          	auipc	ra,0x3
    238c:	000080e7          	jalr	ra # 5388 <exit>
  wait(&xstatus);
    2390:	fbc40513          	addi	a0,s0,-68
    2394:	00003097          	auipc	ra,0x3
    2398:	ffc080e7          	jalr	-4(ra) # 5390 <wait>
  if(xstatus == 1){
    239c:	fbc42703          	lw	a4,-68(s0)
    23a0:	4785                	li	a5,1
    23a2:	02f70663          	beq	a4,a5,23ce <sbrkbasic+0xb6>
  a = sbrk(0);
    23a6:	4501                	li	a0,0
    23a8:	00003097          	auipc	ra,0x3
    23ac:	068080e7          	jalr	104(ra) # 5410 <sbrk>
    23b0:	84aa                	mv	s1,a0
    printf("TOOMUCH PASS\n");
    23b2:	00004517          	auipc	a0,0x4
    23b6:	57650513          	addi	a0,a0,1398 # 6928 <statistics+0x1086>
    23ba:	00003097          	auipc	ra,0x3
    23be:	346080e7          	jalr	838(ra) # 5700 <printf>
  for(i = 0; i < 5000; i++){
    23c2:	4901                	li	s2,0
    *b = 1;
    23c4:	4a85                	li	s5,1
  for(i = 0; i < 5000; i++){
    23c6:	6985                	lui	s3,0x1
    23c8:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1ce>
    23cc:	a005                	j	23ec <sbrkbasic+0xd4>
    printf("%s: too much memory allocated!\n", s);
    23ce:	85d2                	mv	a1,s4
    23d0:	00004517          	auipc	a0,0x4
    23d4:	53850513          	addi	a0,a0,1336 # 6908 <statistics+0x1066>
    23d8:	00003097          	auipc	ra,0x3
    23dc:	328080e7          	jalr	808(ra) # 5700 <printf>
    exit(1);
    23e0:	4505                	li	a0,1
    23e2:	00003097          	auipc	ra,0x3
    23e6:	fa6080e7          	jalr	-90(ra) # 5388 <exit>
    a = b + 1;
    23ea:	84be                	mv	s1,a5
    b = sbrk(1);
    23ec:	4505                	li	a0,1
    23ee:	00003097          	auipc	ra,0x3
    23f2:	022080e7          	jalr	34(ra) # 5410 <sbrk>
    if(b != a){
    23f6:	04951b63          	bne	a0,s1,244c <sbrkbasic+0x134>
    *b = 1;
    23fa:	01548023          	sb	s5,0(s1)
    a = b + 1;
    23fe:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2402:	2905                	addiw	s2,s2,1
    2404:	ff3913e3          	bne	s2,s3,23ea <sbrkbasic+0xd2>
  pid = fork();
    2408:	00003097          	auipc	ra,0x3
    240c:	f78080e7          	jalr	-136(ra) # 5380 <fork>
    2410:	892a                	mv	s2,a0
  if(pid < 0){
    2412:	04054d63          	bltz	a0,246c <sbrkbasic+0x154>
  c = sbrk(1);
    2416:	4505                	li	a0,1
    2418:	00003097          	auipc	ra,0x3
    241c:	ff8080e7          	jalr	-8(ra) # 5410 <sbrk>
  c = sbrk(1);
    2420:	4505                	li	a0,1
    2422:	00003097          	auipc	ra,0x3
    2426:	fee080e7          	jalr	-18(ra) # 5410 <sbrk>
  if(c != a + 1){
    242a:	0489                	addi	s1,s1,2
    242c:	04a48e63          	beq	s1,a0,2488 <sbrkbasic+0x170>
    printf("%s: sbrk test failed post-fork\n", s);
    2430:	85d2                	mv	a1,s4
    2432:	00004517          	auipc	a0,0x4
    2436:	54650513          	addi	a0,a0,1350 # 6978 <statistics+0x10d6>
    243a:	00003097          	auipc	ra,0x3
    243e:	2c6080e7          	jalr	710(ra) # 5700 <printf>
    exit(1);
    2442:	4505                	li	a0,1
    2444:	00003097          	auipc	ra,0x3
    2448:	f44080e7          	jalr	-188(ra) # 5388 <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    244c:	86aa                	mv	a3,a0
    244e:	8626                	mv	a2,s1
    2450:	85ca                	mv	a1,s2
    2452:	00004517          	auipc	a0,0x4
    2456:	4e650513          	addi	a0,a0,1254 # 6938 <statistics+0x1096>
    245a:	00003097          	auipc	ra,0x3
    245e:	2a6080e7          	jalr	678(ra) # 5700 <printf>
      exit(1);
    2462:	4505                	li	a0,1
    2464:	00003097          	auipc	ra,0x3
    2468:	f24080e7          	jalr	-220(ra) # 5388 <exit>
    printf("%s: sbrk test fork failed\n", s);
    246c:	85d2                	mv	a1,s4
    246e:	00004517          	auipc	a0,0x4
    2472:	4ea50513          	addi	a0,a0,1258 # 6958 <statistics+0x10b6>
    2476:	00003097          	auipc	ra,0x3
    247a:	28a080e7          	jalr	650(ra) # 5700 <printf>
    exit(1);
    247e:	4505                	li	a0,1
    2480:	00003097          	auipc	ra,0x3
    2484:	f08080e7          	jalr	-248(ra) # 5388 <exit>
  if(pid == 0)
    2488:	00091763          	bnez	s2,2496 <sbrkbasic+0x17e>
    exit(0);
    248c:	4501                	li	a0,0
    248e:	00003097          	auipc	ra,0x3
    2492:	efa080e7          	jalr	-262(ra) # 5388 <exit>
  wait(&xstatus);
    2496:	fbc40513          	addi	a0,s0,-68
    249a:	00003097          	auipc	ra,0x3
    249e:	ef6080e7          	jalr	-266(ra) # 5390 <wait>
  exit(xstatus);
    24a2:	fbc42503          	lw	a0,-68(s0)
    24a6:	00003097          	auipc	ra,0x3
    24aa:	ee2080e7          	jalr	-286(ra) # 5388 <exit>

00000000000024ae <sbrkmuch>:
{
    24ae:	7179                	addi	sp,sp,-48
    24b0:	f406                	sd	ra,40(sp)
    24b2:	f022                	sd	s0,32(sp)
    24b4:	ec26                	sd	s1,24(sp)
    24b6:	e84a                	sd	s2,16(sp)
    24b8:	e44e                	sd	s3,8(sp)
    24ba:	e052                	sd	s4,0(sp)
    24bc:	1800                	addi	s0,sp,48
    24be:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    24c0:	4501                	li	a0,0
    24c2:	00003097          	auipc	ra,0x3
    24c6:	f4e080e7          	jalr	-178(ra) # 5410 <sbrk>
    24ca:	892a                	mv	s2,a0
  a = sbrk(0);
    24cc:	4501                	li	a0,0
    24ce:	00003097          	auipc	ra,0x3
    24d2:	f42080e7          	jalr	-190(ra) # 5410 <sbrk>
    24d6:	84aa                	mv	s1,a0
  p = sbrk(amt);
    24d8:	06400537          	lui	a0,0x6400
    24dc:	9d05                	subw	a0,a0,s1
    24de:	00003097          	auipc	ra,0x3
    24e2:	f32080e7          	jalr	-206(ra) # 5410 <sbrk>
  if (p != a) {
    24e6:	0ca49863          	bne	s1,a0,25b6 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    24ea:	4501                	li	a0,0
    24ec:	00003097          	auipc	ra,0x3
    24f0:	f24080e7          	jalr	-220(ra) # 5410 <sbrk>
    24f4:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    24f6:	00a4f963          	bgeu	s1,a0,2508 <sbrkmuch+0x5a>
    *pp = 1;
    24fa:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    24fc:	6705                	lui	a4,0x1
    *pp = 1;
    24fe:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2502:	94ba                	add	s1,s1,a4
    2504:	fef4ede3          	bltu	s1,a5,24fe <sbrkmuch+0x50>
  *lastaddr = 99;
    2508:	064007b7          	lui	a5,0x6400
    250c:	06300713          	li	a4,99
    2510:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f17ef>
  a = sbrk(0);
    2514:	4501                	li	a0,0
    2516:	00003097          	auipc	ra,0x3
    251a:	efa080e7          	jalr	-262(ra) # 5410 <sbrk>
    251e:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2520:	757d                	lui	a0,0xfffff
    2522:	00003097          	auipc	ra,0x3
    2526:	eee080e7          	jalr	-274(ra) # 5410 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    252a:	57fd                	li	a5,-1
    252c:	0af50363          	beq	a0,a5,25d2 <sbrkmuch+0x124>
  c = sbrk(0);
    2530:	4501                	li	a0,0
    2532:	00003097          	auipc	ra,0x3
    2536:	ede080e7          	jalr	-290(ra) # 5410 <sbrk>
  if(c != a - PGSIZE){
    253a:	77fd                	lui	a5,0xfffff
    253c:	97a6                	add	a5,a5,s1
    253e:	0af51863          	bne	a0,a5,25ee <sbrkmuch+0x140>
  a = sbrk(0);
    2542:	4501                	li	a0,0
    2544:	00003097          	auipc	ra,0x3
    2548:	ecc080e7          	jalr	-308(ra) # 5410 <sbrk>
    254c:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    254e:	6505                	lui	a0,0x1
    2550:	00003097          	auipc	ra,0x3
    2554:	ec0080e7          	jalr	-320(ra) # 5410 <sbrk>
    2558:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    255a:	0aa49963          	bne	s1,a0,260c <sbrkmuch+0x15e>
    255e:	4501                	li	a0,0
    2560:	00003097          	auipc	ra,0x3
    2564:	eb0080e7          	jalr	-336(ra) # 5410 <sbrk>
    2568:	6785                	lui	a5,0x1
    256a:	97a6                	add	a5,a5,s1
    256c:	0af51063          	bne	a0,a5,260c <sbrkmuch+0x15e>
  if(*lastaddr == 99){
    2570:	064007b7          	lui	a5,0x6400
    2574:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f17ef>
    2578:	06300793          	li	a5,99
    257c:	0af70763          	beq	a4,a5,262a <sbrkmuch+0x17c>
  a = sbrk(0);
    2580:	4501                	li	a0,0
    2582:	00003097          	auipc	ra,0x3
    2586:	e8e080e7          	jalr	-370(ra) # 5410 <sbrk>
    258a:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    258c:	4501                	li	a0,0
    258e:	00003097          	auipc	ra,0x3
    2592:	e82080e7          	jalr	-382(ra) # 5410 <sbrk>
    2596:	40a9053b          	subw	a0,s2,a0
    259a:	00003097          	auipc	ra,0x3
    259e:	e76080e7          	jalr	-394(ra) # 5410 <sbrk>
  if(c != a){
    25a2:	0aa49263          	bne	s1,a0,2646 <sbrkmuch+0x198>
}
    25a6:	70a2                	ld	ra,40(sp)
    25a8:	7402                	ld	s0,32(sp)
    25aa:	64e2                	ld	s1,24(sp)
    25ac:	6942                	ld	s2,16(sp)
    25ae:	69a2                	ld	s3,8(sp)
    25b0:	6a02                	ld	s4,0(sp)
    25b2:	6145                	addi	sp,sp,48
    25b4:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    25b6:	85ce                	mv	a1,s3
    25b8:	00004517          	auipc	a0,0x4
    25bc:	3e050513          	addi	a0,a0,992 # 6998 <statistics+0x10f6>
    25c0:	00003097          	auipc	ra,0x3
    25c4:	140080e7          	jalr	320(ra) # 5700 <printf>
    exit(1);
    25c8:	4505                	li	a0,1
    25ca:	00003097          	auipc	ra,0x3
    25ce:	dbe080e7          	jalr	-578(ra) # 5388 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    25d2:	85ce                	mv	a1,s3
    25d4:	00004517          	auipc	a0,0x4
    25d8:	40c50513          	addi	a0,a0,1036 # 69e0 <statistics+0x113e>
    25dc:	00003097          	auipc	ra,0x3
    25e0:	124080e7          	jalr	292(ra) # 5700 <printf>
    exit(1);
    25e4:	4505                	li	a0,1
    25e6:	00003097          	auipc	ra,0x3
    25ea:	da2080e7          	jalr	-606(ra) # 5388 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    25ee:	862a                	mv	a2,a0
    25f0:	85a6                	mv	a1,s1
    25f2:	00004517          	auipc	a0,0x4
    25f6:	40e50513          	addi	a0,a0,1038 # 6a00 <statistics+0x115e>
    25fa:	00003097          	auipc	ra,0x3
    25fe:	106080e7          	jalr	262(ra) # 5700 <printf>
    exit(1);
    2602:	4505                	li	a0,1
    2604:	00003097          	auipc	ra,0x3
    2608:	d84080e7          	jalr	-636(ra) # 5388 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", a, c);
    260c:	8652                	mv	a2,s4
    260e:	85a6                	mv	a1,s1
    2610:	00004517          	auipc	a0,0x4
    2614:	43050513          	addi	a0,a0,1072 # 6a40 <statistics+0x119e>
    2618:	00003097          	auipc	ra,0x3
    261c:	0e8080e7          	jalr	232(ra) # 5700 <printf>
    exit(1);
    2620:	4505                	li	a0,1
    2622:	00003097          	auipc	ra,0x3
    2626:	d66080e7          	jalr	-666(ra) # 5388 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    262a:	85ce                	mv	a1,s3
    262c:	00004517          	auipc	a0,0x4
    2630:	44450513          	addi	a0,a0,1092 # 6a70 <statistics+0x11ce>
    2634:	00003097          	auipc	ra,0x3
    2638:	0cc080e7          	jalr	204(ra) # 5700 <printf>
    exit(1);
    263c:	4505                	li	a0,1
    263e:	00003097          	auipc	ra,0x3
    2642:	d4a080e7          	jalr	-694(ra) # 5388 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", a, c);
    2646:	862a                	mv	a2,a0
    2648:	85a6                	mv	a1,s1
    264a:	00004517          	auipc	a0,0x4
    264e:	45e50513          	addi	a0,a0,1118 # 6aa8 <statistics+0x1206>
    2652:	00003097          	auipc	ra,0x3
    2656:	0ae080e7          	jalr	174(ra) # 5700 <printf>
    exit(1);
    265a:	4505                	li	a0,1
    265c:	00003097          	auipc	ra,0x3
    2660:	d2c080e7          	jalr	-724(ra) # 5388 <exit>

0000000000002664 <sbrkarg>:
{
    2664:	7179                	addi	sp,sp,-48
    2666:	f406                	sd	ra,40(sp)
    2668:	f022                	sd	s0,32(sp)
    266a:	ec26                	sd	s1,24(sp)
    266c:	e84a                	sd	s2,16(sp)
    266e:	e44e                	sd	s3,8(sp)
    2670:	1800                	addi	s0,sp,48
    2672:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2674:	6505                	lui	a0,0x1
    2676:	00003097          	auipc	ra,0x3
    267a:	d9a080e7          	jalr	-614(ra) # 5410 <sbrk>
    267e:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2680:	20100593          	li	a1,513
    2684:	00004517          	auipc	a0,0x4
    2688:	44c50513          	addi	a0,a0,1100 # 6ad0 <statistics+0x122e>
    268c:	00003097          	auipc	ra,0x3
    2690:	d3c080e7          	jalr	-708(ra) # 53c8 <open>
    2694:	84aa                	mv	s1,a0
  unlink("sbrk");
    2696:	00004517          	auipc	a0,0x4
    269a:	43a50513          	addi	a0,a0,1082 # 6ad0 <statistics+0x122e>
    269e:	00003097          	auipc	ra,0x3
    26a2:	d3a080e7          	jalr	-710(ra) # 53d8 <unlink>
  if(fd < 0)  {
    26a6:	0404c163          	bltz	s1,26e8 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    26aa:	6605                	lui	a2,0x1
    26ac:	85ca                	mv	a1,s2
    26ae:	8526                	mv	a0,s1
    26b0:	00003097          	auipc	ra,0x3
    26b4:	cf8080e7          	jalr	-776(ra) # 53a8 <write>
    26b8:	04054663          	bltz	a0,2704 <sbrkarg+0xa0>
  close(fd);
    26bc:	8526                	mv	a0,s1
    26be:	00003097          	auipc	ra,0x3
    26c2:	cf2080e7          	jalr	-782(ra) # 53b0 <close>
  a = sbrk(PGSIZE);
    26c6:	6505                	lui	a0,0x1
    26c8:	00003097          	auipc	ra,0x3
    26cc:	d48080e7          	jalr	-696(ra) # 5410 <sbrk>
  if(pipe((int *) a) != 0){
    26d0:	00003097          	auipc	ra,0x3
    26d4:	cc8080e7          	jalr	-824(ra) # 5398 <pipe>
    26d8:	e521                	bnez	a0,2720 <sbrkarg+0xbc>
}
    26da:	70a2                	ld	ra,40(sp)
    26dc:	7402                	ld	s0,32(sp)
    26de:	64e2                	ld	s1,24(sp)
    26e0:	6942                	ld	s2,16(sp)
    26e2:	69a2                	ld	s3,8(sp)
    26e4:	6145                	addi	sp,sp,48
    26e6:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    26e8:	85ce                	mv	a1,s3
    26ea:	00004517          	auipc	a0,0x4
    26ee:	3ee50513          	addi	a0,a0,1006 # 6ad8 <statistics+0x1236>
    26f2:	00003097          	auipc	ra,0x3
    26f6:	00e080e7          	jalr	14(ra) # 5700 <printf>
    exit(1);
    26fa:	4505                	li	a0,1
    26fc:	00003097          	auipc	ra,0x3
    2700:	c8c080e7          	jalr	-884(ra) # 5388 <exit>
    printf("%s: write sbrk failed\n", s);
    2704:	85ce                	mv	a1,s3
    2706:	00004517          	auipc	a0,0x4
    270a:	3ea50513          	addi	a0,a0,1002 # 6af0 <statistics+0x124e>
    270e:	00003097          	auipc	ra,0x3
    2712:	ff2080e7          	jalr	-14(ra) # 5700 <printf>
    exit(1);
    2716:	4505                	li	a0,1
    2718:	00003097          	auipc	ra,0x3
    271c:	c70080e7          	jalr	-912(ra) # 5388 <exit>
    printf("%s: pipe() failed\n", s);
    2720:	85ce                	mv	a1,s3
    2722:	00004517          	auipc	a0,0x4
    2726:	e7e50513          	addi	a0,a0,-386 # 65a0 <statistics+0xcfe>
    272a:	00003097          	auipc	ra,0x3
    272e:	fd6080e7          	jalr	-42(ra) # 5700 <printf>
    exit(1);
    2732:	4505                	li	a0,1
    2734:	00003097          	auipc	ra,0x3
    2738:	c54080e7          	jalr	-940(ra) # 5388 <exit>

000000000000273c <argptest>:
{
    273c:	1101                	addi	sp,sp,-32
    273e:	ec06                	sd	ra,24(sp)
    2740:	e822                	sd	s0,16(sp)
    2742:	e426                	sd	s1,8(sp)
    2744:	e04a                	sd	s2,0(sp)
    2746:	1000                	addi	s0,sp,32
    2748:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    274a:	4581                	li	a1,0
    274c:	00004517          	auipc	a0,0x4
    2750:	3bc50513          	addi	a0,a0,956 # 6b08 <statistics+0x1266>
    2754:	00003097          	auipc	ra,0x3
    2758:	c74080e7          	jalr	-908(ra) # 53c8 <open>
  if (fd < 0) {
    275c:	02054b63          	bltz	a0,2792 <argptest+0x56>
    2760:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2762:	4501                	li	a0,0
    2764:	00003097          	auipc	ra,0x3
    2768:	cac080e7          	jalr	-852(ra) # 5410 <sbrk>
    276c:	567d                	li	a2,-1
    276e:	fff50593          	addi	a1,a0,-1
    2772:	8526                	mv	a0,s1
    2774:	00003097          	auipc	ra,0x3
    2778:	c2c080e7          	jalr	-980(ra) # 53a0 <read>
  close(fd);
    277c:	8526                	mv	a0,s1
    277e:	00003097          	auipc	ra,0x3
    2782:	c32080e7          	jalr	-974(ra) # 53b0 <close>
}
    2786:	60e2                	ld	ra,24(sp)
    2788:	6442                	ld	s0,16(sp)
    278a:	64a2                	ld	s1,8(sp)
    278c:	6902                	ld	s2,0(sp)
    278e:	6105                	addi	sp,sp,32
    2790:	8082                	ret
    printf("%s: open failed\n", s);
    2792:	85ca                	mv	a1,s2
    2794:	00004517          	auipc	a0,0x4
    2798:	d1c50513          	addi	a0,a0,-740 # 64b0 <statistics+0xc0e>
    279c:	00003097          	auipc	ra,0x3
    27a0:	f64080e7          	jalr	-156(ra) # 5700 <printf>
    exit(1);
    27a4:	4505                	li	a0,1
    27a6:	00003097          	auipc	ra,0x3
    27aa:	be2080e7          	jalr	-1054(ra) # 5388 <exit>

00000000000027ae <sbrkbugs>:
{
    27ae:	1141                	addi	sp,sp,-16
    27b0:	e406                	sd	ra,8(sp)
    27b2:	e022                	sd	s0,0(sp)
    27b4:	0800                	addi	s0,sp,16
  int pid = fork();
    27b6:	00003097          	auipc	ra,0x3
    27ba:	bca080e7          	jalr	-1078(ra) # 5380 <fork>
  if(pid < 0){
    27be:	02054263          	bltz	a0,27e2 <sbrkbugs+0x34>
  if(pid == 0){
    27c2:	ed0d                	bnez	a0,27fc <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    27c4:	00003097          	auipc	ra,0x3
    27c8:	c4c080e7          	jalr	-948(ra) # 5410 <sbrk>
    sbrk(-sz);
    27cc:	40a0053b          	negw	a0,a0
    27d0:	00003097          	auipc	ra,0x3
    27d4:	c40080e7          	jalr	-960(ra) # 5410 <sbrk>
    exit(0);
    27d8:	4501                	li	a0,0
    27da:	00003097          	auipc	ra,0x3
    27de:	bae080e7          	jalr	-1106(ra) # 5388 <exit>
    printf("fork failed\n");
    27e2:	00004517          	auipc	a0,0x4
    27e6:	0a650513          	addi	a0,a0,166 # 6888 <statistics+0xfe6>
    27ea:	00003097          	auipc	ra,0x3
    27ee:	f16080e7          	jalr	-234(ra) # 5700 <printf>
    exit(1);
    27f2:	4505                	li	a0,1
    27f4:	00003097          	auipc	ra,0x3
    27f8:	b94080e7          	jalr	-1132(ra) # 5388 <exit>
  wait(0);
    27fc:	4501                	li	a0,0
    27fe:	00003097          	auipc	ra,0x3
    2802:	b92080e7          	jalr	-1134(ra) # 5390 <wait>
  pid = fork();
    2806:	00003097          	auipc	ra,0x3
    280a:	b7a080e7          	jalr	-1158(ra) # 5380 <fork>
  if(pid < 0){
    280e:	02054563          	bltz	a0,2838 <sbrkbugs+0x8a>
  if(pid == 0){
    2812:	e121                	bnez	a0,2852 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2814:	00003097          	auipc	ra,0x3
    2818:	bfc080e7          	jalr	-1028(ra) # 5410 <sbrk>
    sbrk(-(sz - 3500));
    281c:	6785                	lui	a5,0x1
    281e:	dac7879b          	addiw	a5,a5,-596
    2822:	40a7853b          	subw	a0,a5,a0
    2826:	00003097          	auipc	ra,0x3
    282a:	bea080e7          	jalr	-1046(ra) # 5410 <sbrk>
    exit(0);
    282e:	4501                	li	a0,0
    2830:	00003097          	auipc	ra,0x3
    2834:	b58080e7          	jalr	-1192(ra) # 5388 <exit>
    printf("fork failed\n");
    2838:	00004517          	auipc	a0,0x4
    283c:	05050513          	addi	a0,a0,80 # 6888 <statistics+0xfe6>
    2840:	00003097          	auipc	ra,0x3
    2844:	ec0080e7          	jalr	-320(ra) # 5700 <printf>
    exit(1);
    2848:	4505                	li	a0,1
    284a:	00003097          	auipc	ra,0x3
    284e:	b3e080e7          	jalr	-1218(ra) # 5388 <exit>
  wait(0);
    2852:	4501                	li	a0,0
    2854:	00003097          	auipc	ra,0x3
    2858:	b3c080e7          	jalr	-1220(ra) # 5390 <wait>
  pid = fork();
    285c:	00003097          	auipc	ra,0x3
    2860:	b24080e7          	jalr	-1244(ra) # 5380 <fork>
  if(pid < 0){
    2864:	02054a63          	bltz	a0,2898 <sbrkbugs+0xea>
  if(pid == 0){
    2868:	e529                	bnez	a0,28b2 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    286a:	00003097          	auipc	ra,0x3
    286e:	ba6080e7          	jalr	-1114(ra) # 5410 <sbrk>
    2872:	67ad                	lui	a5,0xb
    2874:	8007879b          	addiw	a5,a5,-2048
    2878:	40a7853b          	subw	a0,a5,a0
    287c:	00003097          	auipc	ra,0x3
    2880:	b94080e7          	jalr	-1132(ra) # 5410 <sbrk>
    sbrk(-10);
    2884:	5559                	li	a0,-10
    2886:	00003097          	auipc	ra,0x3
    288a:	b8a080e7          	jalr	-1142(ra) # 5410 <sbrk>
    exit(0);
    288e:	4501                	li	a0,0
    2890:	00003097          	auipc	ra,0x3
    2894:	af8080e7          	jalr	-1288(ra) # 5388 <exit>
    printf("fork failed\n");
    2898:	00004517          	auipc	a0,0x4
    289c:	ff050513          	addi	a0,a0,-16 # 6888 <statistics+0xfe6>
    28a0:	00003097          	auipc	ra,0x3
    28a4:	e60080e7          	jalr	-416(ra) # 5700 <printf>
    exit(1);
    28a8:	4505                	li	a0,1
    28aa:	00003097          	auipc	ra,0x3
    28ae:	ade080e7          	jalr	-1314(ra) # 5388 <exit>
  wait(0);
    28b2:	4501                	li	a0,0
    28b4:	00003097          	auipc	ra,0x3
    28b8:	adc080e7          	jalr	-1316(ra) # 5390 <wait>
  exit(0);
    28bc:	4501                	li	a0,0
    28be:	00003097          	auipc	ra,0x3
    28c2:	aca080e7          	jalr	-1334(ra) # 5388 <exit>

00000000000028c6 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    28c6:	715d                	addi	sp,sp,-80
    28c8:	e486                	sd	ra,72(sp)
    28ca:	e0a2                	sd	s0,64(sp)
    28cc:	fc26                	sd	s1,56(sp)
    28ce:	f84a                	sd	s2,48(sp)
    28d0:	f44e                	sd	s3,40(sp)
    28d2:	f052                	sd	s4,32(sp)
    28d4:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    28d6:	4901                	li	s2,0
    28d8:	49bd                	li	s3,15
    int pid = fork();
    28da:	00003097          	auipc	ra,0x3
    28de:	aa6080e7          	jalr	-1370(ra) # 5380 <fork>
    28e2:	84aa                	mv	s1,a0
    if(pid < 0){
    28e4:	02054063          	bltz	a0,2904 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    28e8:	c91d                	beqz	a0,291e <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    28ea:	4501                	li	a0,0
    28ec:	00003097          	auipc	ra,0x3
    28f0:	aa4080e7          	jalr	-1372(ra) # 5390 <wait>
  for(int avail = 0; avail < 15; avail++){
    28f4:	2905                	addiw	s2,s2,1
    28f6:	ff3912e3          	bne	s2,s3,28da <execout+0x14>
    }
  }

  exit(0);
    28fa:	4501                	li	a0,0
    28fc:	00003097          	auipc	ra,0x3
    2900:	a8c080e7          	jalr	-1396(ra) # 5388 <exit>
      printf("fork failed\n");
    2904:	00004517          	auipc	a0,0x4
    2908:	f8450513          	addi	a0,a0,-124 # 6888 <statistics+0xfe6>
    290c:	00003097          	auipc	ra,0x3
    2910:	df4080e7          	jalr	-524(ra) # 5700 <printf>
      exit(1);
    2914:	4505                	li	a0,1
    2916:	00003097          	auipc	ra,0x3
    291a:	a72080e7          	jalr	-1422(ra) # 5388 <exit>
        if(a == 0xffffffffffffffffLL)
    291e:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2920:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2922:	6505                	lui	a0,0x1
    2924:	00003097          	auipc	ra,0x3
    2928:	aec080e7          	jalr	-1300(ra) # 5410 <sbrk>
        if(a == 0xffffffffffffffffLL)
    292c:	01350763          	beq	a0,s3,293a <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2930:	6785                	lui	a5,0x1
    2932:	953e                	add	a0,a0,a5
    2934:	ff450fa3          	sb	s4,-1(a0) # fff <bigdir+0x95>
      while(1){
    2938:	b7ed                	j	2922 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    293a:	01205a63          	blez	s2,294e <execout+0x88>
        sbrk(-4096);
    293e:	757d                	lui	a0,0xfffff
    2940:	00003097          	auipc	ra,0x3
    2944:	ad0080e7          	jalr	-1328(ra) # 5410 <sbrk>
      for(int i = 0; i < avail; i++)
    2948:	2485                	addiw	s1,s1,1
    294a:	ff249ae3          	bne	s1,s2,293e <execout+0x78>
      close(1);
    294e:	4505                	li	a0,1
    2950:	00003097          	auipc	ra,0x3
    2954:	a60080e7          	jalr	-1440(ra) # 53b0 <close>
      char *args[] = { "echo", "x", 0 };
    2958:	00003517          	auipc	a0,0x3
    295c:	30850513          	addi	a0,a0,776 # 5c60 <statistics+0x3be>
    2960:	faa43c23          	sd	a0,-72(s0)
    2964:	00003797          	auipc	a5,0x3
    2968:	36c78793          	addi	a5,a5,876 # 5cd0 <statistics+0x42e>
    296c:	fcf43023          	sd	a5,-64(s0)
    2970:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2974:	fb840593          	addi	a1,s0,-72
    2978:	00003097          	auipc	ra,0x3
    297c:	a48080e7          	jalr	-1464(ra) # 53c0 <exec>
      exit(0);
    2980:	4501                	li	a0,0
    2982:	00003097          	auipc	ra,0x3
    2986:	a06080e7          	jalr	-1530(ra) # 5388 <exit>

000000000000298a <fourteen>:
{
    298a:	1101                	addi	sp,sp,-32
    298c:	ec06                	sd	ra,24(sp)
    298e:	e822                	sd	s0,16(sp)
    2990:	e426                	sd	s1,8(sp)
    2992:	1000                	addi	s0,sp,32
    2994:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2996:	00004517          	auipc	a0,0x4
    299a:	34a50513          	addi	a0,a0,842 # 6ce0 <statistics+0x143e>
    299e:	00003097          	auipc	ra,0x3
    29a2:	a52080e7          	jalr	-1454(ra) # 53f0 <mkdir>
    29a6:	e165                	bnez	a0,2a86 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    29a8:	00004517          	auipc	a0,0x4
    29ac:	19050513          	addi	a0,a0,400 # 6b38 <statistics+0x1296>
    29b0:	00003097          	auipc	ra,0x3
    29b4:	a40080e7          	jalr	-1472(ra) # 53f0 <mkdir>
    29b8:	e56d                	bnez	a0,2aa2 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    29ba:	20000593          	li	a1,512
    29be:	00004517          	auipc	a0,0x4
    29c2:	1d250513          	addi	a0,a0,466 # 6b90 <statistics+0x12ee>
    29c6:	00003097          	auipc	ra,0x3
    29ca:	a02080e7          	jalr	-1534(ra) # 53c8 <open>
  if(fd < 0){
    29ce:	0e054863          	bltz	a0,2abe <fourteen+0x134>
  close(fd);
    29d2:	00003097          	auipc	ra,0x3
    29d6:	9de080e7          	jalr	-1570(ra) # 53b0 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    29da:	4581                	li	a1,0
    29dc:	00004517          	auipc	a0,0x4
    29e0:	22c50513          	addi	a0,a0,556 # 6c08 <statistics+0x1366>
    29e4:	00003097          	auipc	ra,0x3
    29e8:	9e4080e7          	jalr	-1564(ra) # 53c8 <open>
  if(fd < 0){
    29ec:	0e054763          	bltz	a0,2ada <fourteen+0x150>
  close(fd);
    29f0:	00003097          	auipc	ra,0x3
    29f4:	9c0080e7          	jalr	-1600(ra) # 53b0 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    29f8:	00004517          	auipc	a0,0x4
    29fc:	28050513          	addi	a0,a0,640 # 6c78 <statistics+0x13d6>
    2a00:	00003097          	auipc	ra,0x3
    2a04:	9f0080e7          	jalr	-1552(ra) # 53f0 <mkdir>
    2a08:	c57d                	beqz	a0,2af6 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2a0a:	00004517          	auipc	a0,0x4
    2a0e:	2c650513          	addi	a0,a0,710 # 6cd0 <statistics+0x142e>
    2a12:	00003097          	auipc	ra,0x3
    2a16:	9de080e7          	jalr	-1570(ra) # 53f0 <mkdir>
    2a1a:	cd65                	beqz	a0,2b12 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2a1c:	00004517          	auipc	a0,0x4
    2a20:	2b450513          	addi	a0,a0,692 # 6cd0 <statistics+0x142e>
    2a24:	00003097          	auipc	ra,0x3
    2a28:	9b4080e7          	jalr	-1612(ra) # 53d8 <unlink>
  unlink("12345678901234/12345678901234");
    2a2c:	00004517          	auipc	a0,0x4
    2a30:	24c50513          	addi	a0,a0,588 # 6c78 <statistics+0x13d6>
    2a34:	00003097          	auipc	ra,0x3
    2a38:	9a4080e7          	jalr	-1628(ra) # 53d8 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2a3c:	00004517          	auipc	a0,0x4
    2a40:	1cc50513          	addi	a0,a0,460 # 6c08 <statistics+0x1366>
    2a44:	00003097          	auipc	ra,0x3
    2a48:	994080e7          	jalr	-1644(ra) # 53d8 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2a4c:	00004517          	auipc	a0,0x4
    2a50:	14450513          	addi	a0,a0,324 # 6b90 <statistics+0x12ee>
    2a54:	00003097          	auipc	ra,0x3
    2a58:	984080e7          	jalr	-1660(ra) # 53d8 <unlink>
  unlink("12345678901234/123456789012345");
    2a5c:	00004517          	auipc	a0,0x4
    2a60:	0dc50513          	addi	a0,a0,220 # 6b38 <statistics+0x1296>
    2a64:	00003097          	auipc	ra,0x3
    2a68:	974080e7          	jalr	-1676(ra) # 53d8 <unlink>
  unlink("12345678901234");
    2a6c:	00004517          	auipc	a0,0x4
    2a70:	27450513          	addi	a0,a0,628 # 6ce0 <statistics+0x143e>
    2a74:	00003097          	auipc	ra,0x3
    2a78:	964080e7          	jalr	-1692(ra) # 53d8 <unlink>
}
    2a7c:	60e2                	ld	ra,24(sp)
    2a7e:	6442                	ld	s0,16(sp)
    2a80:	64a2                	ld	s1,8(sp)
    2a82:	6105                	addi	sp,sp,32
    2a84:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2a86:	85a6                	mv	a1,s1
    2a88:	00004517          	auipc	a0,0x4
    2a8c:	08850513          	addi	a0,a0,136 # 6b10 <statistics+0x126e>
    2a90:	00003097          	auipc	ra,0x3
    2a94:	c70080e7          	jalr	-912(ra) # 5700 <printf>
    exit(1);
    2a98:	4505                	li	a0,1
    2a9a:	00003097          	auipc	ra,0x3
    2a9e:	8ee080e7          	jalr	-1810(ra) # 5388 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2aa2:	85a6                	mv	a1,s1
    2aa4:	00004517          	auipc	a0,0x4
    2aa8:	0b450513          	addi	a0,a0,180 # 6b58 <statistics+0x12b6>
    2aac:	00003097          	auipc	ra,0x3
    2ab0:	c54080e7          	jalr	-940(ra) # 5700 <printf>
    exit(1);
    2ab4:	4505                	li	a0,1
    2ab6:	00003097          	auipc	ra,0x3
    2aba:	8d2080e7          	jalr	-1838(ra) # 5388 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2abe:	85a6                	mv	a1,s1
    2ac0:	00004517          	auipc	a0,0x4
    2ac4:	10050513          	addi	a0,a0,256 # 6bc0 <statistics+0x131e>
    2ac8:	00003097          	auipc	ra,0x3
    2acc:	c38080e7          	jalr	-968(ra) # 5700 <printf>
    exit(1);
    2ad0:	4505                	li	a0,1
    2ad2:	00003097          	auipc	ra,0x3
    2ad6:	8b6080e7          	jalr	-1866(ra) # 5388 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2ada:	85a6                	mv	a1,s1
    2adc:	00004517          	auipc	a0,0x4
    2ae0:	15c50513          	addi	a0,a0,348 # 6c38 <statistics+0x1396>
    2ae4:	00003097          	auipc	ra,0x3
    2ae8:	c1c080e7          	jalr	-996(ra) # 5700 <printf>
    exit(1);
    2aec:	4505                	li	a0,1
    2aee:	00003097          	auipc	ra,0x3
    2af2:	89a080e7          	jalr	-1894(ra) # 5388 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2af6:	85a6                	mv	a1,s1
    2af8:	00004517          	auipc	a0,0x4
    2afc:	1a050513          	addi	a0,a0,416 # 6c98 <statistics+0x13f6>
    2b00:	00003097          	auipc	ra,0x3
    2b04:	c00080e7          	jalr	-1024(ra) # 5700 <printf>
    exit(1);
    2b08:	4505                	li	a0,1
    2b0a:	00003097          	auipc	ra,0x3
    2b0e:	87e080e7          	jalr	-1922(ra) # 5388 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2b12:	85a6                	mv	a1,s1
    2b14:	00004517          	auipc	a0,0x4
    2b18:	1dc50513          	addi	a0,a0,476 # 6cf0 <statistics+0x144e>
    2b1c:	00003097          	auipc	ra,0x3
    2b20:	be4080e7          	jalr	-1052(ra) # 5700 <printf>
    exit(1);
    2b24:	4505                	li	a0,1
    2b26:	00003097          	auipc	ra,0x3
    2b2a:	862080e7          	jalr	-1950(ra) # 5388 <exit>

0000000000002b2e <iputtest>:
{
    2b2e:	1101                	addi	sp,sp,-32
    2b30:	ec06                	sd	ra,24(sp)
    2b32:	e822                	sd	s0,16(sp)
    2b34:	e426                	sd	s1,8(sp)
    2b36:	1000                	addi	s0,sp,32
    2b38:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2b3a:	00004517          	auipc	a0,0x4
    2b3e:	1ee50513          	addi	a0,a0,494 # 6d28 <statistics+0x1486>
    2b42:	00003097          	auipc	ra,0x3
    2b46:	8ae080e7          	jalr	-1874(ra) # 53f0 <mkdir>
    2b4a:	04054563          	bltz	a0,2b94 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2b4e:	00004517          	auipc	a0,0x4
    2b52:	1da50513          	addi	a0,a0,474 # 6d28 <statistics+0x1486>
    2b56:	00003097          	auipc	ra,0x3
    2b5a:	8a2080e7          	jalr	-1886(ra) # 53f8 <chdir>
    2b5e:	04054963          	bltz	a0,2bb0 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2b62:	00004517          	auipc	a0,0x4
    2b66:	20650513          	addi	a0,a0,518 # 6d68 <statistics+0x14c6>
    2b6a:	00003097          	auipc	ra,0x3
    2b6e:	86e080e7          	jalr	-1938(ra) # 53d8 <unlink>
    2b72:	04054d63          	bltz	a0,2bcc <iputtest+0x9e>
  if(chdir("/") < 0){
    2b76:	00004517          	auipc	a0,0x4
    2b7a:	22250513          	addi	a0,a0,546 # 6d98 <statistics+0x14f6>
    2b7e:	00003097          	auipc	ra,0x3
    2b82:	87a080e7          	jalr	-1926(ra) # 53f8 <chdir>
    2b86:	06054163          	bltz	a0,2be8 <iputtest+0xba>
}
    2b8a:	60e2                	ld	ra,24(sp)
    2b8c:	6442                	ld	s0,16(sp)
    2b8e:	64a2                	ld	s1,8(sp)
    2b90:	6105                	addi	sp,sp,32
    2b92:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b94:	85a6                	mv	a1,s1
    2b96:	00004517          	auipc	a0,0x4
    2b9a:	19a50513          	addi	a0,a0,410 # 6d30 <statistics+0x148e>
    2b9e:	00003097          	auipc	ra,0x3
    2ba2:	b62080e7          	jalr	-1182(ra) # 5700 <printf>
    exit(1);
    2ba6:	4505                	li	a0,1
    2ba8:	00002097          	auipc	ra,0x2
    2bac:	7e0080e7          	jalr	2016(ra) # 5388 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2bb0:	85a6                	mv	a1,s1
    2bb2:	00004517          	auipc	a0,0x4
    2bb6:	19650513          	addi	a0,a0,406 # 6d48 <statistics+0x14a6>
    2bba:	00003097          	auipc	ra,0x3
    2bbe:	b46080e7          	jalr	-1210(ra) # 5700 <printf>
    exit(1);
    2bc2:	4505                	li	a0,1
    2bc4:	00002097          	auipc	ra,0x2
    2bc8:	7c4080e7          	jalr	1988(ra) # 5388 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2bcc:	85a6                	mv	a1,s1
    2bce:	00004517          	auipc	a0,0x4
    2bd2:	1aa50513          	addi	a0,a0,426 # 6d78 <statistics+0x14d6>
    2bd6:	00003097          	auipc	ra,0x3
    2bda:	b2a080e7          	jalr	-1238(ra) # 5700 <printf>
    exit(1);
    2bde:	4505                	li	a0,1
    2be0:	00002097          	auipc	ra,0x2
    2be4:	7a8080e7          	jalr	1960(ra) # 5388 <exit>
    printf("%s: chdir / failed\n", s);
    2be8:	85a6                	mv	a1,s1
    2bea:	00004517          	auipc	a0,0x4
    2bee:	1b650513          	addi	a0,a0,438 # 6da0 <statistics+0x14fe>
    2bf2:	00003097          	auipc	ra,0x3
    2bf6:	b0e080e7          	jalr	-1266(ra) # 5700 <printf>
    exit(1);
    2bfa:	4505                	li	a0,1
    2bfc:	00002097          	auipc	ra,0x2
    2c00:	78c080e7          	jalr	1932(ra) # 5388 <exit>

0000000000002c04 <exitiputtest>:
{
    2c04:	7179                	addi	sp,sp,-48
    2c06:	f406                	sd	ra,40(sp)
    2c08:	f022                	sd	s0,32(sp)
    2c0a:	ec26                	sd	s1,24(sp)
    2c0c:	1800                	addi	s0,sp,48
    2c0e:	84aa                	mv	s1,a0
  pid = fork();
    2c10:	00002097          	auipc	ra,0x2
    2c14:	770080e7          	jalr	1904(ra) # 5380 <fork>
  if(pid < 0){
    2c18:	04054663          	bltz	a0,2c64 <exitiputtest+0x60>
  if(pid == 0){
    2c1c:	ed45                	bnez	a0,2cd4 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2c1e:	00004517          	auipc	a0,0x4
    2c22:	10a50513          	addi	a0,a0,266 # 6d28 <statistics+0x1486>
    2c26:	00002097          	auipc	ra,0x2
    2c2a:	7ca080e7          	jalr	1994(ra) # 53f0 <mkdir>
    2c2e:	04054963          	bltz	a0,2c80 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2c32:	00004517          	auipc	a0,0x4
    2c36:	0f650513          	addi	a0,a0,246 # 6d28 <statistics+0x1486>
    2c3a:	00002097          	auipc	ra,0x2
    2c3e:	7be080e7          	jalr	1982(ra) # 53f8 <chdir>
    2c42:	04054d63          	bltz	a0,2c9c <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2c46:	00004517          	auipc	a0,0x4
    2c4a:	12250513          	addi	a0,a0,290 # 6d68 <statistics+0x14c6>
    2c4e:	00002097          	auipc	ra,0x2
    2c52:	78a080e7          	jalr	1930(ra) # 53d8 <unlink>
    2c56:	06054163          	bltz	a0,2cb8 <exitiputtest+0xb4>
    exit(0);
    2c5a:	4501                	li	a0,0
    2c5c:	00002097          	auipc	ra,0x2
    2c60:	72c080e7          	jalr	1836(ra) # 5388 <exit>
    printf("%s: fork failed\n", s);
    2c64:	85a6                	mv	a1,s1
    2c66:	00004517          	auipc	a0,0x4
    2c6a:	83250513          	addi	a0,a0,-1998 # 6498 <statistics+0xbf6>
    2c6e:	00003097          	auipc	ra,0x3
    2c72:	a92080e7          	jalr	-1390(ra) # 5700 <printf>
    exit(1);
    2c76:	4505                	li	a0,1
    2c78:	00002097          	auipc	ra,0x2
    2c7c:	710080e7          	jalr	1808(ra) # 5388 <exit>
      printf("%s: mkdir failed\n", s);
    2c80:	85a6                	mv	a1,s1
    2c82:	00004517          	auipc	a0,0x4
    2c86:	0ae50513          	addi	a0,a0,174 # 6d30 <statistics+0x148e>
    2c8a:	00003097          	auipc	ra,0x3
    2c8e:	a76080e7          	jalr	-1418(ra) # 5700 <printf>
      exit(1);
    2c92:	4505                	li	a0,1
    2c94:	00002097          	auipc	ra,0x2
    2c98:	6f4080e7          	jalr	1780(ra) # 5388 <exit>
      printf("%s: child chdir failed\n", s);
    2c9c:	85a6                	mv	a1,s1
    2c9e:	00004517          	auipc	a0,0x4
    2ca2:	11a50513          	addi	a0,a0,282 # 6db8 <statistics+0x1516>
    2ca6:	00003097          	auipc	ra,0x3
    2caa:	a5a080e7          	jalr	-1446(ra) # 5700 <printf>
      exit(1);
    2cae:	4505                	li	a0,1
    2cb0:	00002097          	auipc	ra,0x2
    2cb4:	6d8080e7          	jalr	1752(ra) # 5388 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2cb8:	85a6                	mv	a1,s1
    2cba:	00004517          	auipc	a0,0x4
    2cbe:	0be50513          	addi	a0,a0,190 # 6d78 <statistics+0x14d6>
    2cc2:	00003097          	auipc	ra,0x3
    2cc6:	a3e080e7          	jalr	-1474(ra) # 5700 <printf>
      exit(1);
    2cca:	4505                	li	a0,1
    2ccc:	00002097          	auipc	ra,0x2
    2cd0:	6bc080e7          	jalr	1724(ra) # 5388 <exit>
  wait(&xstatus);
    2cd4:	fdc40513          	addi	a0,s0,-36
    2cd8:	00002097          	auipc	ra,0x2
    2cdc:	6b8080e7          	jalr	1720(ra) # 5390 <wait>
  exit(xstatus);
    2ce0:	fdc42503          	lw	a0,-36(s0)
    2ce4:	00002097          	auipc	ra,0x2
    2ce8:	6a4080e7          	jalr	1700(ra) # 5388 <exit>

0000000000002cec <subdir>:
{
    2cec:	1101                	addi	sp,sp,-32
    2cee:	ec06                	sd	ra,24(sp)
    2cf0:	e822                	sd	s0,16(sp)
    2cf2:	e426                	sd	s1,8(sp)
    2cf4:	e04a                	sd	s2,0(sp)
    2cf6:	1000                	addi	s0,sp,32
    2cf8:	892a                	mv	s2,a0
  unlink("ff");
    2cfa:	00004517          	auipc	a0,0x4
    2cfe:	20650513          	addi	a0,a0,518 # 6f00 <statistics+0x165e>
    2d02:	00002097          	auipc	ra,0x2
    2d06:	6d6080e7          	jalr	1750(ra) # 53d8 <unlink>
  if(mkdir("dd") != 0){
    2d0a:	00004517          	auipc	a0,0x4
    2d0e:	0c650513          	addi	a0,a0,198 # 6dd0 <statistics+0x152e>
    2d12:	00002097          	auipc	ra,0x2
    2d16:	6de080e7          	jalr	1758(ra) # 53f0 <mkdir>
    2d1a:	38051663          	bnez	a0,30a6 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2d1e:	20200593          	li	a1,514
    2d22:	00004517          	auipc	a0,0x4
    2d26:	0ce50513          	addi	a0,a0,206 # 6df0 <statistics+0x154e>
    2d2a:	00002097          	auipc	ra,0x2
    2d2e:	69e080e7          	jalr	1694(ra) # 53c8 <open>
    2d32:	84aa                	mv	s1,a0
  if(fd < 0){
    2d34:	38054763          	bltz	a0,30c2 <subdir+0x3d6>
  write(fd, "ff", 2);
    2d38:	4609                	li	a2,2
    2d3a:	00004597          	auipc	a1,0x4
    2d3e:	1c658593          	addi	a1,a1,454 # 6f00 <statistics+0x165e>
    2d42:	00002097          	auipc	ra,0x2
    2d46:	666080e7          	jalr	1638(ra) # 53a8 <write>
  close(fd);
    2d4a:	8526                	mv	a0,s1
    2d4c:	00002097          	auipc	ra,0x2
    2d50:	664080e7          	jalr	1636(ra) # 53b0 <close>
  if(unlink("dd") >= 0){
    2d54:	00004517          	auipc	a0,0x4
    2d58:	07c50513          	addi	a0,a0,124 # 6dd0 <statistics+0x152e>
    2d5c:	00002097          	auipc	ra,0x2
    2d60:	67c080e7          	jalr	1660(ra) # 53d8 <unlink>
    2d64:	36055d63          	bgez	a0,30de <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    2d68:	00004517          	auipc	a0,0x4
    2d6c:	0e050513          	addi	a0,a0,224 # 6e48 <statistics+0x15a6>
    2d70:	00002097          	auipc	ra,0x2
    2d74:	680080e7          	jalr	1664(ra) # 53f0 <mkdir>
    2d78:	38051163          	bnez	a0,30fa <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2d7c:	20200593          	li	a1,514
    2d80:	00004517          	auipc	a0,0x4
    2d84:	0f050513          	addi	a0,a0,240 # 6e70 <statistics+0x15ce>
    2d88:	00002097          	auipc	ra,0x2
    2d8c:	640080e7          	jalr	1600(ra) # 53c8 <open>
    2d90:	84aa                	mv	s1,a0
  if(fd < 0){
    2d92:	38054263          	bltz	a0,3116 <subdir+0x42a>
  write(fd, "FF", 2);
    2d96:	4609                	li	a2,2
    2d98:	00004597          	auipc	a1,0x4
    2d9c:	10858593          	addi	a1,a1,264 # 6ea0 <statistics+0x15fe>
    2da0:	00002097          	auipc	ra,0x2
    2da4:	608080e7          	jalr	1544(ra) # 53a8 <write>
  close(fd);
    2da8:	8526                	mv	a0,s1
    2daa:	00002097          	auipc	ra,0x2
    2dae:	606080e7          	jalr	1542(ra) # 53b0 <close>
  fd = open("dd/dd/../ff", 0);
    2db2:	4581                	li	a1,0
    2db4:	00004517          	auipc	a0,0x4
    2db8:	0f450513          	addi	a0,a0,244 # 6ea8 <statistics+0x1606>
    2dbc:	00002097          	auipc	ra,0x2
    2dc0:	60c080e7          	jalr	1548(ra) # 53c8 <open>
    2dc4:	84aa                	mv	s1,a0
  if(fd < 0){
    2dc6:	36054663          	bltz	a0,3132 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    2dca:	660d                	lui	a2,0x3
    2dcc:	00009597          	auipc	a1,0x9
    2dd0:	a3458593          	addi	a1,a1,-1484 # b800 <buf>
    2dd4:	00002097          	auipc	ra,0x2
    2dd8:	5cc080e7          	jalr	1484(ra) # 53a0 <read>
  if(cc != 2 || buf[0] != 'f'){
    2ddc:	4789                	li	a5,2
    2dde:	36f51863          	bne	a0,a5,314e <subdir+0x462>
    2de2:	00009717          	auipc	a4,0x9
    2de6:	a1e74703          	lbu	a4,-1506(a4) # b800 <buf>
    2dea:	06600793          	li	a5,102
    2dee:	36f71063          	bne	a4,a5,314e <subdir+0x462>
  close(fd);
    2df2:	8526                	mv	a0,s1
    2df4:	00002097          	auipc	ra,0x2
    2df8:	5bc080e7          	jalr	1468(ra) # 53b0 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2dfc:	00004597          	auipc	a1,0x4
    2e00:	0fc58593          	addi	a1,a1,252 # 6ef8 <statistics+0x1656>
    2e04:	00004517          	auipc	a0,0x4
    2e08:	06c50513          	addi	a0,a0,108 # 6e70 <statistics+0x15ce>
    2e0c:	00002097          	auipc	ra,0x2
    2e10:	5dc080e7          	jalr	1500(ra) # 53e8 <link>
    2e14:	34051b63          	bnez	a0,316a <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    2e18:	00004517          	auipc	a0,0x4
    2e1c:	05850513          	addi	a0,a0,88 # 6e70 <statistics+0x15ce>
    2e20:	00002097          	auipc	ra,0x2
    2e24:	5b8080e7          	jalr	1464(ra) # 53d8 <unlink>
    2e28:	34051f63          	bnez	a0,3186 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e2c:	4581                	li	a1,0
    2e2e:	00004517          	auipc	a0,0x4
    2e32:	04250513          	addi	a0,a0,66 # 6e70 <statistics+0x15ce>
    2e36:	00002097          	auipc	ra,0x2
    2e3a:	592080e7          	jalr	1426(ra) # 53c8 <open>
    2e3e:	36055263          	bgez	a0,31a2 <subdir+0x4b6>
  if(chdir("dd") != 0){
    2e42:	00004517          	auipc	a0,0x4
    2e46:	f8e50513          	addi	a0,a0,-114 # 6dd0 <statistics+0x152e>
    2e4a:	00002097          	auipc	ra,0x2
    2e4e:	5ae080e7          	jalr	1454(ra) # 53f8 <chdir>
    2e52:	36051663          	bnez	a0,31be <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    2e56:	00004517          	auipc	a0,0x4
    2e5a:	13a50513          	addi	a0,a0,314 # 6f90 <statistics+0x16ee>
    2e5e:	00002097          	auipc	ra,0x2
    2e62:	59a080e7          	jalr	1434(ra) # 53f8 <chdir>
    2e66:	36051a63          	bnez	a0,31da <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    2e6a:	00004517          	auipc	a0,0x4
    2e6e:	15650513          	addi	a0,a0,342 # 6fc0 <statistics+0x171e>
    2e72:	00002097          	auipc	ra,0x2
    2e76:	586080e7          	jalr	1414(ra) # 53f8 <chdir>
    2e7a:	36051e63          	bnez	a0,31f6 <subdir+0x50a>
  if(chdir("./..") != 0){
    2e7e:	00004517          	auipc	a0,0x4
    2e82:	17250513          	addi	a0,a0,370 # 6ff0 <statistics+0x174e>
    2e86:	00002097          	auipc	ra,0x2
    2e8a:	572080e7          	jalr	1394(ra) # 53f8 <chdir>
    2e8e:	38051263          	bnez	a0,3212 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    2e92:	4581                	li	a1,0
    2e94:	00004517          	auipc	a0,0x4
    2e98:	06450513          	addi	a0,a0,100 # 6ef8 <statistics+0x1656>
    2e9c:	00002097          	auipc	ra,0x2
    2ea0:	52c080e7          	jalr	1324(ra) # 53c8 <open>
    2ea4:	84aa                	mv	s1,a0
  if(fd < 0){
    2ea6:	38054463          	bltz	a0,322e <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    2eaa:	660d                	lui	a2,0x3
    2eac:	00009597          	auipc	a1,0x9
    2eb0:	95458593          	addi	a1,a1,-1708 # b800 <buf>
    2eb4:	00002097          	auipc	ra,0x2
    2eb8:	4ec080e7          	jalr	1260(ra) # 53a0 <read>
    2ebc:	4789                	li	a5,2
    2ebe:	38f51663          	bne	a0,a5,324a <subdir+0x55e>
  close(fd);
    2ec2:	8526                	mv	a0,s1
    2ec4:	00002097          	auipc	ra,0x2
    2ec8:	4ec080e7          	jalr	1260(ra) # 53b0 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2ecc:	4581                	li	a1,0
    2ece:	00004517          	auipc	a0,0x4
    2ed2:	fa250513          	addi	a0,a0,-94 # 6e70 <statistics+0x15ce>
    2ed6:	00002097          	auipc	ra,0x2
    2eda:	4f2080e7          	jalr	1266(ra) # 53c8 <open>
    2ede:	38055463          	bgez	a0,3266 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2ee2:	20200593          	li	a1,514
    2ee6:	00004517          	auipc	a0,0x4
    2eea:	19a50513          	addi	a0,a0,410 # 7080 <statistics+0x17de>
    2eee:	00002097          	auipc	ra,0x2
    2ef2:	4da080e7          	jalr	1242(ra) # 53c8 <open>
    2ef6:	38055663          	bgez	a0,3282 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2efa:	20200593          	li	a1,514
    2efe:	00004517          	auipc	a0,0x4
    2f02:	1b250513          	addi	a0,a0,434 # 70b0 <statistics+0x180e>
    2f06:	00002097          	auipc	ra,0x2
    2f0a:	4c2080e7          	jalr	1218(ra) # 53c8 <open>
    2f0e:	38055863          	bgez	a0,329e <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    2f12:	20000593          	li	a1,512
    2f16:	00004517          	auipc	a0,0x4
    2f1a:	eba50513          	addi	a0,a0,-326 # 6dd0 <statistics+0x152e>
    2f1e:	00002097          	auipc	ra,0x2
    2f22:	4aa080e7          	jalr	1194(ra) # 53c8 <open>
    2f26:	38055a63          	bgez	a0,32ba <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    2f2a:	4589                	li	a1,2
    2f2c:	00004517          	auipc	a0,0x4
    2f30:	ea450513          	addi	a0,a0,-348 # 6dd0 <statistics+0x152e>
    2f34:	00002097          	auipc	ra,0x2
    2f38:	494080e7          	jalr	1172(ra) # 53c8 <open>
    2f3c:	38055d63          	bgez	a0,32d6 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    2f40:	4585                	li	a1,1
    2f42:	00004517          	auipc	a0,0x4
    2f46:	e8e50513          	addi	a0,a0,-370 # 6dd0 <statistics+0x152e>
    2f4a:	00002097          	auipc	ra,0x2
    2f4e:	47e080e7          	jalr	1150(ra) # 53c8 <open>
    2f52:	3a055063          	bgez	a0,32f2 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2f56:	00004597          	auipc	a1,0x4
    2f5a:	1ea58593          	addi	a1,a1,490 # 7140 <statistics+0x189e>
    2f5e:	00004517          	auipc	a0,0x4
    2f62:	12250513          	addi	a0,a0,290 # 7080 <statistics+0x17de>
    2f66:	00002097          	auipc	ra,0x2
    2f6a:	482080e7          	jalr	1154(ra) # 53e8 <link>
    2f6e:	3a050063          	beqz	a0,330e <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2f72:	00004597          	auipc	a1,0x4
    2f76:	1ce58593          	addi	a1,a1,462 # 7140 <statistics+0x189e>
    2f7a:	00004517          	auipc	a0,0x4
    2f7e:	13650513          	addi	a0,a0,310 # 70b0 <statistics+0x180e>
    2f82:	00002097          	auipc	ra,0x2
    2f86:	466080e7          	jalr	1126(ra) # 53e8 <link>
    2f8a:	3a050063          	beqz	a0,332a <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2f8e:	00004597          	auipc	a1,0x4
    2f92:	f6a58593          	addi	a1,a1,-150 # 6ef8 <statistics+0x1656>
    2f96:	00004517          	auipc	a0,0x4
    2f9a:	e5a50513          	addi	a0,a0,-422 # 6df0 <statistics+0x154e>
    2f9e:	00002097          	auipc	ra,0x2
    2fa2:	44a080e7          	jalr	1098(ra) # 53e8 <link>
    2fa6:	3a050063          	beqz	a0,3346 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    2faa:	00004517          	auipc	a0,0x4
    2fae:	0d650513          	addi	a0,a0,214 # 7080 <statistics+0x17de>
    2fb2:	00002097          	auipc	ra,0x2
    2fb6:	43e080e7          	jalr	1086(ra) # 53f0 <mkdir>
    2fba:	3a050463          	beqz	a0,3362 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    2fbe:	00004517          	auipc	a0,0x4
    2fc2:	0f250513          	addi	a0,a0,242 # 70b0 <statistics+0x180e>
    2fc6:	00002097          	auipc	ra,0x2
    2fca:	42a080e7          	jalr	1066(ra) # 53f0 <mkdir>
    2fce:	3a050863          	beqz	a0,337e <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    2fd2:	00004517          	auipc	a0,0x4
    2fd6:	f2650513          	addi	a0,a0,-218 # 6ef8 <statistics+0x1656>
    2fda:	00002097          	auipc	ra,0x2
    2fde:	416080e7          	jalr	1046(ra) # 53f0 <mkdir>
    2fe2:	3a050c63          	beqz	a0,339a <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    2fe6:	00004517          	auipc	a0,0x4
    2fea:	0ca50513          	addi	a0,a0,202 # 70b0 <statistics+0x180e>
    2fee:	00002097          	auipc	ra,0x2
    2ff2:	3ea080e7          	jalr	1002(ra) # 53d8 <unlink>
    2ff6:	3c050063          	beqz	a0,33b6 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    2ffa:	00004517          	auipc	a0,0x4
    2ffe:	08650513          	addi	a0,a0,134 # 7080 <statistics+0x17de>
    3002:	00002097          	auipc	ra,0x2
    3006:	3d6080e7          	jalr	982(ra) # 53d8 <unlink>
    300a:	3c050463          	beqz	a0,33d2 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    300e:	00004517          	auipc	a0,0x4
    3012:	de250513          	addi	a0,a0,-542 # 6df0 <statistics+0x154e>
    3016:	00002097          	auipc	ra,0x2
    301a:	3e2080e7          	jalr	994(ra) # 53f8 <chdir>
    301e:	3c050863          	beqz	a0,33ee <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3022:	00004517          	auipc	a0,0x4
    3026:	26e50513          	addi	a0,a0,622 # 7290 <statistics+0x19ee>
    302a:	00002097          	auipc	ra,0x2
    302e:	3ce080e7          	jalr	974(ra) # 53f8 <chdir>
    3032:	3c050c63          	beqz	a0,340a <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3036:	00004517          	auipc	a0,0x4
    303a:	ec250513          	addi	a0,a0,-318 # 6ef8 <statistics+0x1656>
    303e:	00002097          	auipc	ra,0x2
    3042:	39a080e7          	jalr	922(ra) # 53d8 <unlink>
    3046:	3e051063          	bnez	a0,3426 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    304a:	00004517          	auipc	a0,0x4
    304e:	da650513          	addi	a0,a0,-602 # 6df0 <statistics+0x154e>
    3052:	00002097          	auipc	ra,0x2
    3056:	386080e7          	jalr	902(ra) # 53d8 <unlink>
    305a:	3e051463          	bnez	a0,3442 <subdir+0x756>
  if(unlink("dd") == 0){
    305e:	00004517          	auipc	a0,0x4
    3062:	d7250513          	addi	a0,a0,-654 # 6dd0 <statistics+0x152e>
    3066:	00002097          	auipc	ra,0x2
    306a:	372080e7          	jalr	882(ra) # 53d8 <unlink>
    306e:	3e050863          	beqz	a0,345e <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3072:	00004517          	auipc	a0,0x4
    3076:	28e50513          	addi	a0,a0,654 # 7300 <statistics+0x1a5e>
    307a:	00002097          	auipc	ra,0x2
    307e:	35e080e7          	jalr	862(ra) # 53d8 <unlink>
    3082:	3e054c63          	bltz	a0,347a <subdir+0x78e>
  if(unlink("dd") < 0){
    3086:	00004517          	auipc	a0,0x4
    308a:	d4a50513          	addi	a0,a0,-694 # 6dd0 <statistics+0x152e>
    308e:	00002097          	auipc	ra,0x2
    3092:	34a080e7          	jalr	842(ra) # 53d8 <unlink>
    3096:	40054063          	bltz	a0,3496 <subdir+0x7aa>
}
    309a:	60e2                	ld	ra,24(sp)
    309c:	6442                	ld	s0,16(sp)
    309e:	64a2                	ld	s1,8(sp)
    30a0:	6902                	ld	s2,0(sp)
    30a2:	6105                	addi	sp,sp,32
    30a4:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    30a6:	85ca                	mv	a1,s2
    30a8:	00004517          	auipc	a0,0x4
    30ac:	d3050513          	addi	a0,a0,-720 # 6dd8 <statistics+0x1536>
    30b0:	00002097          	auipc	ra,0x2
    30b4:	650080e7          	jalr	1616(ra) # 5700 <printf>
    exit(1);
    30b8:	4505                	li	a0,1
    30ba:	00002097          	auipc	ra,0x2
    30be:	2ce080e7          	jalr	718(ra) # 5388 <exit>
    printf("%s: create dd/ff failed\n", s);
    30c2:	85ca                	mv	a1,s2
    30c4:	00004517          	auipc	a0,0x4
    30c8:	d3450513          	addi	a0,a0,-716 # 6df8 <statistics+0x1556>
    30cc:	00002097          	auipc	ra,0x2
    30d0:	634080e7          	jalr	1588(ra) # 5700 <printf>
    exit(1);
    30d4:	4505                	li	a0,1
    30d6:	00002097          	auipc	ra,0x2
    30da:	2b2080e7          	jalr	690(ra) # 5388 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    30de:	85ca                	mv	a1,s2
    30e0:	00004517          	auipc	a0,0x4
    30e4:	d3850513          	addi	a0,a0,-712 # 6e18 <statistics+0x1576>
    30e8:	00002097          	auipc	ra,0x2
    30ec:	618080e7          	jalr	1560(ra) # 5700 <printf>
    exit(1);
    30f0:	4505                	li	a0,1
    30f2:	00002097          	auipc	ra,0x2
    30f6:	296080e7          	jalr	662(ra) # 5388 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    30fa:	85ca                	mv	a1,s2
    30fc:	00004517          	auipc	a0,0x4
    3100:	d5450513          	addi	a0,a0,-684 # 6e50 <statistics+0x15ae>
    3104:	00002097          	auipc	ra,0x2
    3108:	5fc080e7          	jalr	1532(ra) # 5700 <printf>
    exit(1);
    310c:	4505                	li	a0,1
    310e:	00002097          	auipc	ra,0x2
    3112:	27a080e7          	jalr	634(ra) # 5388 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3116:	85ca                	mv	a1,s2
    3118:	00004517          	auipc	a0,0x4
    311c:	d6850513          	addi	a0,a0,-664 # 6e80 <statistics+0x15de>
    3120:	00002097          	auipc	ra,0x2
    3124:	5e0080e7          	jalr	1504(ra) # 5700 <printf>
    exit(1);
    3128:	4505                	li	a0,1
    312a:	00002097          	auipc	ra,0x2
    312e:	25e080e7          	jalr	606(ra) # 5388 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3132:	85ca                	mv	a1,s2
    3134:	00004517          	auipc	a0,0x4
    3138:	d8450513          	addi	a0,a0,-636 # 6eb8 <statistics+0x1616>
    313c:	00002097          	auipc	ra,0x2
    3140:	5c4080e7          	jalr	1476(ra) # 5700 <printf>
    exit(1);
    3144:	4505                	li	a0,1
    3146:	00002097          	auipc	ra,0x2
    314a:	242080e7          	jalr	578(ra) # 5388 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    314e:	85ca                	mv	a1,s2
    3150:	00004517          	auipc	a0,0x4
    3154:	d8850513          	addi	a0,a0,-632 # 6ed8 <statistics+0x1636>
    3158:	00002097          	auipc	ra,0x2
    315c:	5a8080e7          	jalr	1448(ra) # 5700 <printf>
    exit(1);
    3160:	4505                	li	a0,1
    3162:	00002097          	auipc	ra,0x2
    3166:	226080e7          	jalr	550(ra) # 5388 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    316a:	85ca                	mv	a1,s2
    316c:	00004517          	auipc	a0,0x4
    3170:	d9c50513          	addi	a0,a0,-612 # 6f08 <statistics+0x1666>
    3174:	00002097          	auipc	ra,0x2
    3178:	58c080e7          	jalr	1420(ra) # 5700 <printf>
    exit(1);
    317c:	4505                	li	a0,1
    317e:	00002097          	auipc	ra,0x2
    3182:	20a080e7          	jalr	522(ra) # 5388 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3186:	85ca                	mv	a1,s2
    3188:	00004517          	auipc	a0,0x4
    318c:	da850513          	addi	a0,a0,-600 # 6f30 <statistics+0x168e>
    3190:	00002097          	auipc	ra,0x2
    3194:	570080e7          	jalr	1392(ra) # 5700 <printf>
    exit(1);
    3198:	4505                	li	a0,1
    319a:	00002097          	auipc	ra,0x2
    319e:	1ee080e7          	jalr	494(ra) # 5388 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    31a2:	85ca                	mv	a1,s2
    31a4:	00004517          	auipc	a0,0x4
    31a8:	dac50513          	addi	a0,a0,-596 # 6f50 <statistics+0x16ae>
    31ac:	00002097          	auipc	ra,0x2
    31b0:	554080e7          	jalr	1364(ra) # 5700 <printf>
    exit(1);
    31b4:	4505                	li	a0,1
    31b6:	00002097          	auipc	ra,0x2
    31ba:	1d2080e7          	jalr	466(ra) # 5388 <exit>
    printf("%s: chdir dd failed\n", s);
    31be:	85ca                	mv	a1,s2
    31c0:	00004517          	auipc	a0,0x4
    31c4:	db850513          	addi	a0,a0,-584 # 6f78 <statistics+0x16d6>
    31c8:	00002097          	auipc	ra,0x2
    31cc:	538080e7          	jalr	1336(ra) # 5700 <printf>
    exit(1);
    31d0:	4505                	li	a0,1
    31d2:	00002097          	auipc	ra,0x2
    31d6:	1b6080e7          	jalr	438(ra) # 5388 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    31da:	85ca                	mv	a1,s2
    31dc:	00004517          	auipc	a0,0x4
    31e0:	dc450513          	addi	a0,a0,-572 # 6fa0 <statistics+0x16fe>
    31e4:	00002097          	auipc	ra,0x2
    31e8:	51c080e7          	jalr	1308(ra) # 5700 <printf>
    exit(1);
    31ec:	4505                	li	a0,1
    31ee:	00002097          	auipc	ra,0x2
    31f2:	19a080e7          	jalr	410(ra) # 5388 <exit>
    printf("chdir dd/../../dd failed\n", s);
    31f6:	85ca                	mv	a1,s2
    31f8:	00004517          	auipc	a0,0x4
    31fc:	dd850513          	addi	a0,a0,-552 # 6fd0 <statistics+0x172e>
    3200:	00002097          	auipc	ra,0x2
    3204:	500080e7          	jalr	1280(ra) # 5700 <printf>
    exit(1);
    3208:	4505                	li	a0,1
    320a:	00002097          	auipc	ra,0x2
    320e:	17e080e7          	jalr	382(ra) # 5388 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3212:	85ca                	mv	a1,s2
    3214:	00004517          	auipc	a0,0x4
    3218:	de450513          	addi	a0,a0,-540 # 6ff8 <statistics+0x1756>
    321c:	00002097          	auipc	ra,0x2
    3220:	4e4080e7          	jalr	1252(ra) # 5700 <printf>
    exit(1);
    3224:	4505                	li	a0,1
    3226:	00002097          	auipc	ra,0x2
    322a:	162080e7          	jalr	354(ra) # 5388 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    322e:	85ca                	mv	a1,s2
    3230:	00004517          	auipc	a0,0x4
    3234:	de050513          	addi	a0,a0,-544 # 7010 <statistics+0x176e>
    3238:	00002097          	auipc	ra,0x2
    323c:	4c8080e7          	jalr	1224(ra) # 5700 <printf>
    exit(1);
    3240:	4505                	li	a0,1
    3242:	00002097          	auipc	ra,0x2
    3246:	146080e7          	jalr	326(ra) # 5388 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    324a:	85ca                	mv	a1,s2
    324c:	00004517          	auipc	a0,0x4
    3250:	de450513          	addi	a0,a0,-540 # 7030 <statistics+0x178e>
    3254:	00002097          	auipc	ra,0x2
    3258:	4ac080e7          	jalr	1196(ra) # 5700 <printf>
    exit(1);
    325c:	4505                	li	a0,1
    325e:	00002097          	auipc	ra,0x2
    3262:	12a080e7          	jalr	298(ra) # 5388 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3266:	85ca                	mv	a1,s2
    3268:	00004517          	auipc	a0,0x4
    326c:	de850513          	addi	a0,a0,-536 # 7050 <statistics+0x17ae>
    3270:	00002097          	auipc	ra,0x2
    3274:	490080e7          	jalr	1168(ra) # 5700 <printf>
    exit(1);
    3278:	4505                	li	a0,1
    327a:	00002097          	auipc	ra,0x2
    327e:	10e080e7          	jalr	270(ra) # 5388 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3282:	85ca                	mv	a1,s2
    3284:	00004517          	auipc	a0,0x4
    3288:	e0c50513          	addi	a0,a0,-500 # 7090 <statistics+0x17ee>
    328c:	00002097          	auipc	ra,0x2
    3290:	474080e7          	jalr	1140(ra) # 5700 <printf>
    exit(1);
    3294:	4505                	li	a0,1
    3296:	00002097          	auipc	ra,0x2
    329a:	0f2080e7          	jalr	242(ra) # 5388 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    329e:	85ca                	mv	a1,s2
    32a0:	00004517          	auipc	a0,0x4
    32a4:	e2050513          	addi	a0,a0,-480 # 70c0 <statistics+0x181e>
    32a8:	00002097          	auipc	ra,0x2
    32ac:	458080e7          	jalr	1112(ra) # 5700 <printf>
    exit(1);
    32b0:	4505                	li	a0,1
    32b2:	00002097          	auipc	ra,0x2
    32b6:	0d6080e7          	jalr	214(ra) # 5388 <exit>
    printf("%s: create dd succeeded!\n", s);
    32ba:	85ca                	mv	a1,s2
    32bc:	00004517          	auipc	a0,0x4
    32c0:	e2450513          	addi	a0,a0,-476 # 70e0 <statistics+0x183e>
    32c4:	00002097          	auipc	ra,0x2
    32c8:	43c080e7          	jalr	1084(ra) # 5700 <printf>
    exit(1);
    32cc:	4505                	li	a0,1
    32ce:	00002097          	auipc	ra,0x2
    32d2:	0ba080e7          	jalr	186(ra) # 5388 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    32d6:	85ca                	mv	a1,s2
    32d8:	00004517          	auipc	a0,0x4
    32dc:	e2850513          	addi	a0,a0,-472 # 7100 <statistics+0x185e>
    32e0:	00002097          	auipc	ra,0x2
    32e4:	420080e7          	jalr	1056(ra) # 5700 <printf>
    exit(1);
    32e8:	4505                	li	a0,1
    32ea:	00002097          	auipc	ra,0x2
    32ee:	09e080e7          	jalr	158(ra) # 5388 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    32f2:	85ca                	mv	a1,s2
    32f4:	00004517          	auipc	a0,0x4
    32f8:	e2c50513          	addi	a0,a0,-468 # 7120 <statistics+0x187e>
    32fc:	00002097          	auipc	ra,0x2
    3300:	404080e7          	jalr	1028(ra) # 5700 <printf>
    exit(1);
    3304:	4505                	li	a0,1
    3306:	00002097          	auipc	ra,0x2
    330a:	082080e7          	jalr	130(ra) # 5388 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    330e:	85ca                	mv	a1,s2
    3310:	00004517          	auipc	a0,0x4
    3314:	e4050513          	addi	a0,a0,-448 # 7150 <statistics+0x18ae>
    3318:	00002097          	auipc	ra,0x2
    331c:	3e8080e7          	jalr	1000(ra) # 5700 <printf>
    exit(1);
    3320:	4505                	li	a0,1
    3322:	00002097          	auipc	ra,0x2
    3326:	066080e7          	jalr	102(ra) # 5388 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    332a:	85ca                	mv	a1,s2
    332c:	00004517          	auipc	a0,0x4
    3330:	e4c50513          	addi	a0,a0,-436 # 7178 <statistics+0x18d6>
    3334:	00002097          	auipc	ra,0x2
    3338:	3cc080e7          	jalr	972(ra) # 5700 <printf>
    exit(1);
    333c:	4505                	li	a0,1
    333e:	00002097          	auipc	ra,0x2
    3342:	04a080e7          	jalr	74(ra) # 5388 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3346:	85ca                	mv	a1,s2
    3348:	00004517          	auipc	a0,0x4
    334c:	e5850513          	addi	a0,a0,-424 # 71a0 <statistics+0x18fe>
    3350:	00002097          	auipc	ra,0x2
    3354:	3b0080e7          	jalr	944(ra) # 5700 <printf>
    exit(1);
    3358:	4505                	li	a0,1
    335a:	00002097          	auipc	ra,0x2
    335e:	02e080e7          	jalr	46(ra) # 5388 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3362:	85ca                	mv	a1,s2
    3364:	00004517          	auipc	a0,0x4
    3368:	e6450513          	addi	a0,a0,-412 # 71c8 <statistics+0x1926>
    336c:	00002097          	auipc	ra,0x2
    3370:	394080e7          	jalr	916(ra) # 5700 <printf>
    exit(1);
    3374:	4505                	li	a0,1
    3376:	00002097          	auipc	ra,0x2
    337a:	012080e7          	jalr	18(ra) # 5388 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    337e:	85ca                	mv	a1,s2
    3380:	00004517          	auipc	a0,0x4
    3384:	e6850513          	addi	a0,a0,-408 # 71e8 <statistics+0x1946>
    3388:	00002097          	auipc	ra,0x2
    338c:	378080e7          	jalr	888(ra) # 5700 <printf>
    exit(1);
    3390:	4505                	li	a0,1
    3392:	00002097          	auipc	ra,0x2
    3396:	ff6080e7          	jalr	-10(ra) # 5388 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    339a:	85ca                	mv	a1,s2
    339c:	00004517          	auipc	a0,0x4
    33a0:	e6c50513          	addi	a0,a0,-404 # 7208 <statistics+0x1966>
    33a4:	00002097          	auipc	ra,0x2
    33a8:	35c080e7          	jalr	860(ra) # 5700 <printf>
    exit(1);
    33ac:	4505                	li	a0,1
    33ae:	00002097          	auipc	ra,0x2
    33b2:	fda080e7          	jalr	-38(ra) # 5388 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    33b6:	85ca                	mv	a1,s2
    33b8:	00004517          	auipc	a0,0x4
    33bc:	e7850513          	addi	a0,a0,-392 # 7230 <statistics+0x198e>
    33c0:	00002097          	auipc	ra,0x2
    33c4:	340080e7          	jalr	832(ra) # 5700 <printf>
    exit(1);
    33c8:	4505                	li	a0,1
    33ca:	00002097          	auipc	ra,0x2
    33ce:	fbe080e7          	jalr	-66(ra) # 5388 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    33d2:	85ca                	mv	a1,s2
    33d4:	00004517          	auipc	a0,0x4
    33d8:	e7c50513          	addi	a0,a0,-388 # 7250 <statistics+0x19ae>
    33dc:	00002097          	auipc	ra,0x2
    33e0:	324080e7          	jalr	804(ra) # 5700 <printf>
    exit(1);
    33e4:	4505                	li	a0,1
    33e6:	00002097          	auipc	ra,0x2
    33ea:	fa2080e7          	jalr	-94(ra) # 5388 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    33ee:	85ca                	mv	a1,s2
    33f0:	00004517          	auipc	a0,0x4
    33f4:	e8050513          	addi	a0,a0,-384 # 7270 <statistics+0x19ce>
    33f8:	00002097          	auipc	ra,0x2
    33fc:	308080e7          	jalr	776(ra) # 5700 <printf>
    exit(1);
    3400:	4505                	li	a0,1
    3402:	00002097          	auipc	ra,0x2
    3406:	f86080e7          	jalr	-122(ra) # 5388 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    340a:	85ca                	mv	a1,s2
    340c:	00004517          	auipc	a0,0x4
    3410:	e8c50513          	addi	a0,a0,-372 # 7298 <statistics+0x19f6>
    3414:	00002097          	auipc	ra,0x2
    3418:	2ec080e7          	jalr	748(ra) # 5700 <printf>
    exit(1);
    341c:	4505                	li	a0,1
    341e:	00002097          	auipc	ra,0x2
    3422:	f6a080e7          	jalr	-150(ra) # 5388 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3426:	85ca                	mv	a1,s2
    3428:	00004517          	auipc	a0,0x4
    342c:	b0850513          	addi	a0,a0,-1272 # 6f30 <statistics+0x168e>
    3430:	00002097          	auipc	ra,0x2
    3434:	2d0080e7          	jalr	720(ra) # 5700 <printf>
    exit(1);
    3438:	4505                	li	a0,1
    343a:	00002097          	auipc	ra,0x2
    343e:	f4e080e7          	jalr	-178(ra) # 5388 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3442:	85ca                	mv	a1,s2
    3444:	00004517          	auipc	a0,0x4
    3448:	e7450513          	addi	a0,a0,-396 # 72b8 <statistics+0x1a16>
    344c:	00002097          	auipc	ra,0x2
    3450:	2b4080e7          	jalr	692(ra) # 5700 <printf>
    exit(1);
    3454:	4505                	li	a0,1
    3456:	00002097          	auipc	ra,0x2
    345a:	f32080e7          	jalr	-206(ra) # 5388 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    345e:	85ca                	mv	a1,s2
    3460:	00004517          	auipc	a0,0x4
    3464:	e7850513          	addi	a0,a0,-392 # 72d8 <statistics+0x1a36>
    3468:	00002097          	auipc	ra,0x2
    346c:	298080e7          	jalr	664(ra) # 5700 <printf>
    exit(1);
    3470:	4505                	li	a0,1
    3472:	00002097          	auipc	ra,0x2
    3476:	f16080e7          	jalr	-234(ra) # 5388 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    347a:	85ca                	mv	a1,s2
    347c:	00004517          	auipc	a0,0x4
    3480:	e8c50513          	addi	a0,a0,-372 # 7308 <statistics+0x1a66>
    3484:	00002097          	auipc	ra,0x2
    3488:	27c080e7          	jalr	636(ra) # 5700 <printf>
    exit(1);
    348c:	4505                	li	a0,1
    348e:	00002097          	auipc	ra,0x2
    3492:	efa080e7          	jalr	-262(ra) # 5388 <exit>
    printf("%s: unlink dd failed\n", s);
    3496:	85ca                	mv	a1,s2
    3498:	00004517          	auipc	a0,0x4
    349c:	e9050513          	addi	a0,a0,-368 # 7328 <statistics+0x1a86>
    34a0:	00002097          	auipc	ra,0x2
    34a4:	260080e7          	jalr	608(ra) # 5700 <printf>
    exit(1);
    34a8:	4505                	li	a0,1
    34aa:	00002097          	auipc	ra,0x2
    34ae:	ede080e7          	jalr	-290(ra) # 5388 <exit>

00000000000034b2 <rmdot>:
{
    34b2:	1101                	addi	sp,sp,-32
    34b4:	ec06                	sd	ra,24(sp)
    34b6:	e822                	sd	s0,16(sp)
    34b8:	e426                	sd	s1,8(sp)
    34ba:	1000                	addi	s0,sp,32
    34bc:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    34be:	00004517          	auipc	a0,0x4
    34c2:	e8250513          	addi	a0,a0,-382 # 7340 <statistics+0x1a9e>
    34c6:	00002097          	auipc	ra,0x2
    34ca:	f2a080e7          	jalr	-214(ra) # 53f0 <mkdir>
    34ce:	e549                	bnez	a0,3558 <rmdot+0xa6>
  if(chdir("dots") != 0){
    34d0:	00004517          	auipc	a0,0x4
    34d4:	e7050513          	addi	a0,a0,-400 # 7340 <statistics+0x1a9e>
    34d8:	00002097          	auipc	ra,0x2
    34dc:	f20080e7          	jalr	-224(ra) # 53f8 <chdir>
    34e0:	e951                	bnez	a0,3574 <rmdot+0xc2>
  if(unlink(".") == 0){
    34e2:	00003517          	auipc	a0,0x3
    34e6:	e1650513          	addi	a0,a0,-490 # 62f8 <statistics+0xa56>
    34ea:	00002097          	auipc	ra,0x2
    34ee:	eee080e7          	jalr	-274(ra) # 53d8 <unlink>
    34f2:	cd59                	beqz	a0,3590 <rmdot+0xde>
  if(unlink("..") == 0){
    34f4:	00004517          	auipc	a0,0x4
    34f8:	e9c50513          	addi	a0,a0,-356 # 7390 <statistics+0x1aee>
    34fc:	00002097          	auipc	ra,0x2
    3500:	edc080e7          	jalr	-292(ra) # 53d8 <unlink>
    3504:	c545                	beqz	a0,35ac <rmdot+0xfa>
  if(chdir("/") != 0){
    3506:	00004517          	auipc	a0,0x4
    350a:	89250513          	addi	a0,a0,-1902 # 6d98 <statistics+0x14f6>
    350e:	00002097          	auipc	ra,0x2
    3512:	eea080e7          	jalr	-278(ra) # 53f8 <chdir>
    3516:	e94d                	bnez	a0,35c8 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3518:	00004517          	auipc	a0,0x4
    351c:	e9850513          	addi	a0,a0,-360 # 73b0 <statistics+0x1b0e>
    3520:	00002097          	auipc	ra,0x2
    3524:	eb8080e7          	jalr	-328(ra) # 53d8 <unlink>
    3528:	cd55                	beqz	a0,35e4 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    352a:	00004517          	auipc	a0,0x4
    352e:	eae50513          	addi	a0,a0,-338 # 73d8 <statistics+0x1b36>
    3532:	00002097          	auipc	ra,0x2
    3536:	ea6080e7          	jalr	-346(ra) # 53d8 <unlink>
    353a:	c179                	beqz	a0,3600 <rmdot+0x14e>
  if(unlink("dots") != 0){
    353c:	00004517          	auipc	a0,0x4
    3540:	e0450513          	addi	a0,a0,-508 # 7340 <statistics+0x1a9e>
    3544:	00002097          	auipc	ra,0x2
    3548:	e94080e7          	jalr	-364(ra) # 53d8 <unlink>
    354c:	e961                	bnez	a0,361c <rmdot+0x16a>
}
    354e:	60e2                	ld	ra,24(sp)
    3550:	6442                	ld	s0,16(sp)
    3552:	64a2                	ld	s1,8(sp)
    3554:	6105                	addi	sp,sp,32
    3556:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3558:	85a6                	mv	a1,s1
    355a:	00004517          	auipc	a0,0x4
    355e:	dee50513          	addi	a0,a0,-530 # 7348 <statistics+0x1aa6>
    3562:	00002097          	auipc	ra,0x2
    3566:	19e080e7          	jalr	414(ra) # 5700 <printf>
    exit(1);
    356a:	4505                	li	a0,1
    356c:	00002097          	auipc	ra,0x2
    3570:	e1c080e7          	jalr	-484(ra) # 5388 <exit>
    printf("%s: chdir dots failed\n", s);
    3574:	85a6                	mv	a1,s1
    3576:	00004517          	auipc	a0,0x4
    357a:	dea50513          	addi	a0,a0,-534 # 7360 <statistics+0x1abe>
    357e:	00002097          	auipc	ra,0x2
    3582:	182080e7          	jalr	386(ra) # 5700 <printf>
    exit(1);
    3586:	4505                	li	a0,1
    3588:	00002097          	auipc	ra,0x2
    358c:	e00080e7          	jalr	-512(ra) # 5388 <exit>
    printf("%s: rm . worked!\n", s);
    3590:	85a6                	mv	a1,s1
    3592:	00004517          	auipc	a0,0x4
    3596:	de650513          	addi	a0,a0,-538 # 7378 <statistics+0x1ad6>
    359a:	00002097          	auipc	ra,0x2
    359e:	166080e7          	jalr	358(ra) # 5700 <printf>
    exit(1);
    35a2:	4505                	li	a0,1
    35a4:	00002097          	auipc	ra,0x2
    35a8:	de4080e7          	jalr	-540(ra) # 5388 <exit>
    printf("%s: rm .. worked!\n", s);
    35ac:	85a6                	mv	a1,s1
    35ae:	00004517          	auipc	a0,0x4
    35b2:	dea50513          	addi	a0,a0,-534 # 7398 <statistics+0x1af6>
    35b6:	00002097          	auipc	ra,0x2
    35ba:	14a080e7          	jalr	330(ra) # 5700 <printf>
    exit(1);
    35be:	4505                	li	a0,1
    35c0:	00002097          	auipc	ra,0x2
    35c4:	dc8080e7          	jalr	-568(ra) # 5388 <exit>
    printf("%s: chdir / failed\n", s);
    35c8:	85a6                	mv	a1,s1
    35ca:	00003517          	auipc	a0,0x3
    35ce:	7d650513          	addi	a0,a0,2006 # 6da0 <statistics+0x14fe>
    35d2:	00002097          	auipc	ra,0x2
    35d6:	12e080e7          	jalr	302(ra) # 5700 <printf>
    exit(1);
    35da:	4505                	li	a0,1
    35dc:	00002097          	auipc	ra,0x2
    35e0:	dac080e7          	jalr	-596(ra) # 5388 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    35e4:	85a6                	mv	a1,s1
    35e6:	00004517          	auipc	a0,0x4
    35ea:	dd250513          	addi	a0,a0,-558 # 73b8 <statistics+0x1b16>
    35ee:	00002097          	auipc	ra,0x2
    35f2:	112080e7          	jalr	274(ra) # 5700 <printf>
    exit(1);
    35f6:	4505                	li	a0,1
    35f8:	00002097          	auipc	ra,0x2
    35fc:	d90080e7          	jalr	-624(ra) # 5388 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3600:	85a6                	mv	a1,s1
    3602:	00004517          	auipc	a0,0x4
    3606:	dde50513          	addi	a0,a0,-546 # 73e0 <statistics+0x1b3e>
    360a:	00002097          	auipc	ra,0x2
    360e:	0f6080e7          	jalr	246(ra) # 5700 <printf>
    exit(1);
    3612:	4505                	li	a0,1
    3614:	00002097          	auipc	ra,0x2
    3618:	d74080e7          	jalr	-652(ra) # 5388 <exit>
    printf("%s: unlink dots failed!\n", s);
    361c:	85a6                	mv	a1,s1
    361e:	00004517          	auipc	a0,0x4
    3622:	de250513          	addi	a0,a0,-542 # 7400 <statistics+0x1b5e>
    3626:	00002097          	auipc	ra,0x2
    362a:	0da080e7          	jalr	218(ra) # 5700 <printf>
    exit(1);
    362e:	4505                	li	a0,1
    3630:	00002097          	auipc	ra,0x2
    3634:	d58080e7          	jalr	-680(ra) # 5388 <exit>

0000000000003638 <dirfile>:
{
    3638:	1101                	addi	sp,sp,-32
    363a:	ec06                	sd	ra,24(sp)
    363c:	e822                	sd	s0,16(sp)
    363e:	e426                	sd	s1,8(sp)
    3640:	e04a                	sd	s2,0(sp)
    3642:	1000                	addi	s0,sp,32
    3644:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3646:	20000593          	li	a1,512
    364a:	00002517          	auipc	a0,0x2
    364e:	5b650513          	addi	a0,a0,1462 # 5c00 <statistics+0x35e>
    3652:	00002097          	auipc	ra,0x2
    3656:	d76080e7          	jalr	-650(ra) # 53c8 <open>
  if(fd < 0){
    365a:	0e054d63          	bltz	a0,3754 <dirfile+0x11c>
  close(fd);
    365e:	00002097          	auipc	ra,0x2
    3662:	d52080e7          	jalr	-686(ra) # 53b0 <close>
  if(chdir("dirfile") == 0){
    3666:	00002517          	auipc	a0,0x2
    366a:	59a50513          	addi	a0,a0,1434 # 5c00 <statistics+0x35e>
    366e:	00002097          	auipc	ra,0x2
    3672:	d8a080e7          	jalr	-630(ra) # 53f8 <chdir>
    3676:	cd6d                	beqz	a0,3770 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3678:	4581                	li	a1,0
    367a:	00004517          	auipc	a0,0x4
    367e:	de650513          	addi	a0,a0,-538 # 7460 <statistics+0x1bbe>
    3682:	00002097          	auipc	ra,0x2
    3686:	d46080e7          	jalr	-698(ra) # 53c8 <open>
  if(fd >= 0){
    368a:	10055163          	bgez	a0,378c <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    368e:	20000593          	li	a1,512
    3692:	00004517          	auipc	a0,0x4
    3696:	dce50513          	addi	a0,a0,-562 # 7460 <statistics+0x1bbe>
    369a:	00002097          	auipc	ra,0x2
    369e:	d2e080e7          	jalr	-722(ra) # 53c8 <open>
  if(fd >= 0){
    36a2:	10055363          	bgez	a0,37a8 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    36a6:	00004517          	auipc	a0,0x4
    36aa:	dba50513          	addi	a0,a0,-582 # 7460 <statistics+0x1bbe>
    36ae:	00002097          	auipc	ra,0x2
    36b2:	d42080e7          	jalr	-702(ra) # 53f0 <mkdir>
    36b6:	10050763          	beqz	a0,37c4 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    36ba:	00004517          	auipc	a0,0x4
    36be:	da650513          	addi	a0,a0,-602 # 7460 <statistics+0x1bbe>
    36c2:	00002097          	auipc	ra,0x2
    36c6:	d16080e7          	jalr	-746(ra) # 53d8 <unlink>
    36ca:	10050b63          	beqz	a0,37e0 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    36ce:	00004597          	auipc	a1,0x4
    36d2:	d9258593          	addi	a1,a1,-622 # 7460 <statistics+0x1bbe>
    36d6:	00002517          	auipc	a0,0x2
    36da:	72250513          	addi	a0,a0,1826 # 5df8 <statistics+0x556>
    36de:	00002097          	auipc	ra,0x2
    36e2:	d0a080e7          	jalr	-758(ra) # 53e8 <link>
    36e6:	10050b63          	beqz	a0,37fc <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    36ea:	00002517          	auipc	a0,0x2
    36ee:	51650513          	addi	a0,a0,1302 # 5c00 <statistics+0x35e>
    36f2:	00002097          	auipc	ra,0x2
    36f6:	ce6080e7          	jalr	-794(ra) # 53d8 <unlink>
    36fa:	10051f63          	bnez	a0,3818 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    36fe:	4589                	li	a1,2
    3700:	00003517          	auipc	a0,0x3
    3704:	bf850513          	addi	a0,a0,-1032 # 62f8 <statistics+0xa56>
    3708:	00002097          	auipc	ra,0x2
    370c:	cc0080e7          	jalr	-832(ra) # 53c8 <open>
  if(fd >= 0){
    3710:	12055263          	bgez	a0,3834 <dirfile+0x1fc>
  fd = open(".", 0);
    3714:	4581                	li	a1,0
    3716:	00003517          	auipc	a0,0x3
    371a:	be250513          	addi	a0,a0,-1054 # 62f8 <statistics+0xa56>
    371e:	00002097          	auipc	ra,0x2
    3722:	caa080e7          	jalr	-854(ra) # 53c8 <open>
    3726:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3728:	4605                	li	a2,1
    372a:	00002597          	auipc	a1,0x2
    372e:	5a658593          	addi	a1,a1,1446 # 5cd0 <statistics+0x42e>
    3732:	00002097          	auipc	ra,0x2
    3736:	c76080e7          	jalr	-906(ra) # 53a8 <write>
    373a:	10a04b63          	bgtz	a0,3850 <dirfile+0x218>
  close(fd);
    373e:	8526                	mv	a0,s1
    3740:	00002097          	auipc	ra,0x2
    3744:	c70080e7          	jalr	-912(ra) # 53b0 <close>
}
    3748:	60e2                	ld	ra,24(sp)
    374a:	6442                	ld	s0,16(sp)
    374c:	64a2                	ld	s1,8(sp)
    374e:	6902                	ld	s2,0(sp)
    3750:	6105                	addi	sp,sp,32
    3752:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3754:	85ca                	mv	a1,s2
    3756:	00004517          	auipc	a0,0x4
    375a:	cca50513          	addi	a0,a0,-822 # 7420 <statistics+0x1b7e>
    375e:	00002097          	auipc	ra,0x2
    3762:	fa2080e7          	jalr	-94(ra) # 5700 <printf>
    exit(1);
    3766:	4505                	li	a0,1
    3768:	00002097          	auipc	ra,0x2
    376c:	c20080e7          	jalr	-992(ra) # 5388 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3770:	85ca                	mv	a1,s2
    3772:	00004517          	auipc	a0,0x4
    3776:	cce50513          	addi	a0,a0,-818 # 7440 <statistics+0x1b9e>
    377a:	00002097          	auipc	ra,0x2
    377e:	f86080e7          	jalr	-122(ra) # 5700 <printf>
    exit(1);
    3782:	4505                	li	a0,1
    3784:	00002097          	auipc	ra,0x2
    3788:	c04080e7          	jalr	-1020(ra) # 5388 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    378c:	85ca                	mv	a1,s2
    378e:	00004517          	auipc	a0,0x4
    3792:	ce250513          	addi	a0,a0,-798 # 7470 <statistics+0x1bce>
    3796:	00002097          	auipc	ra,0x2
    379a:	f6a080e7          	jalr	-150(ra) # 5700 <printf>
    exit(1);
    379e:	4505                	li	a0,1
    37a0:	00002097          	auipc	ra,0x2
    37a4:	be8080e7          	jalr	-1048(ra) # 5388 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    37a8:	85ca                	mv	a1,s2
    37aa:	00004517          	auipc	a0,0x4
    37ae:	cc650513          	addi	a0,a0,-826 # 7470 <statistics+0x1bce>
    37b2:	00002097          	auipc	ra,0x2
    37b6:	f4e080e7          	jalr	-178(ra) # 5700 <printf>
    exit(1);
    37ba:	4505                	li	a0,1
    37bc:	00002097          	auipc	ra,0x2
    37c0:	bcc080e7          	jalr	-1076(ra) # 5388 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    37c4:	85ca                	mv	a1,s2
    37c6:	00004517          	auipc	a0,0x4
    37ca:	cd250513          	addi	a0,a0,-814 # 7498 <statistics+0x1bf6>
    37ce:	00002097          	auipc	ra,0x2
    37d2:	f32080e7          	jalr	-206(ra) # 5700 <printf>
    exit(1);
    37d6:	4505                	li	a0,1
    37d8:	00002097          	auipc	ra,0x2
    37dc:	bb0080e7          	jalr	-1104(ra) # 5388 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    37e0:	85ca                	mv	a1,s2
    37e2:	00004517          	auipc	a0,0x4
    37e6:	cde50513          	addi	a0,a0,-802 # 74c0 <statistics+0x1c1e>
    37ea:	00002097          	auipc	ra,0x2
    37ee:	f16080e7          	jalr	-234(ra) # 5700 <printf>
    exit(1);
    37f2:	4505                	li	a0,1
    37f4:	00002097          	auipc	ra,0x2
    37f8:	b94080e7          	jalr	-1132(ra) # 5388 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    37fc:	85ca                	mv	a1,s2
    37fe:	00004517          	auipc	a0,0x4
    3802:	cea50513          	addi	a0,a0,-790 # 74e8 <statistics+0x1c46>
    3806:	00002097          	auipc	ra,0x2
    380a:	efa080e7          	jalr	-262(ra) # 5700 <printf>
    exit(1);
    380e:	4505                	li	a0,1
    3810:	00002097          	auipc	ra,0x2
    3814:	b78080e7          	jalr	-1160(ra) # 5388 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3818:	85ca                	mv	a1,s2
    381a:	00004517          	auipc	a0,0x4
    381e:	cf650513          	addi	a0,a0,-778 # 7510 <statistics+0x1c6e>
    3822:	00002097          	auipc	ra,0x2
    3826:	ede080e7          	jalr	-290(ra) # 5700 <printf>
    exit(1);
    382a:	4505                	li	a0,1
    382c:	00002097          	auipc	ra,0x2
    3830:	b5c080e7          	jalr	-1188(ra) # 5388 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3834:	85ca                	mv	a1,s2
    3836:	00004517          	auipc	a0,0x4
    383a:	cfa50513          	addi	a0,a0,-774 # 7530 <statistics+0x1c8e>
    383e:	00002097          	auipc	ra,0x2
    3842:	ec2080e7          	jalr	-318(ra) # 5700 <printf>
    exit(1);
    3846:	4505                	li	a0,1
    3848:	00002097          	auipc	ra,0x2
    384c:	b40080e7          	jalr	-1216(ra) # 5388 <exit>
    printf("%s: write . succeeded!\n", s);
    3850:	85ca                	mv	a1,s2
    3852:	00004517          	auipc	a0,0x4
    3856:	d0650513          	addi	a0,a0,-762 # 7558 <statistics+0x1cb6>
    385a:	00002097          	auipc	ra,0x2
    385e:	ea6080e7          	jalr	-346(ra) # 5700 <printf>
    exit(1);
    3862:	4505                	li	a0,1
    3864:	00002097          	auipc	ra,0x2
    3868:	b24080e7          	jalr	-1244(ra) # 5388 <exit>

000000000000386c <iref>:
{
    386c:	7139                	addi	sp,sp,-64
    386e:	fc06                	sd	ra,56(sp)
    3870:	f822                	sd	s0,48(sp)
    3872:	f426                	sd	s1,40(sp)
    3874:	f04a                	sd	s2,32(sp)
    3876:	ec4e                	sd	s3,24(sp)
    3878:	e852                	sd	s4,16(sp)
    387a:	e456                	sd	s5,8(sp)
    387c:	e05a                	sd	s6,0(sp)
    387e:	0080                	addi	s0,sp,64
    3880:	8b2a                	mv	s6,a0
    3882:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3886:	00004a17          	auipc	s4,0x4
    388a:	ceaa0a13          	addi	s4,s4,-790 # 7570 <statistics+0x1cce>
    mkdir("");
    388e:	00003497          	auipc	s1,0x3
    3892:	7ea48493          	addi	s1,s1,2026 # 7078 <statistics+0x17d6>
    link("README", "");
    3896:	00002a97          	auipc	s5,0x2
    389a:	562a8a93          	addi	s5,s5,1378 # 5df8 <statistics+0x556>
    fd = open("xx", O_CREATE);
    389e:	00004997          	auipc	s3,0x4
    38a2:	bca98993          	addi	s3,s3,-1078 # 7468 <statistics+0x1bc6>
    38a6:	a891                	j	38fa <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    38a8:	85da                	mv	a1,s6
    38aa:	00004517          	auipc	a0,0x4
    38ae:	cce50513          	addi	a0,a0,-818 # 7578 <statistics+0x1cd6>
    38b2:	00002097          	auipc	ra,0x2
    38b6:	e4e080e7          	jalr	-434(ra) # 5700 <printf>
      exit(1);
    38ba:	4505                	li	a0,1
    38bc:	00002097          	auipc	ra,0x2
    38c0:	acc080e7          	jalr	-1332(ra) # 5388 <exit>
      printf("%s: chdir irefd failed\n", s);
    38c4:	85da                	mv	a1,s6
    38c6:	00004517          	auipc	a0,0x4
    38ca:	cca50513          	addi	a0,a0,-822 # 7590 <statistics+0x1cee>
    38ce:	00002097          	auipc	ra,0x2
    38d2:	e32080e7          	jalr	-462(ra) # 5700 <printf>
      exit(1);
    38d6:	4505                	li	a0,1
    38d8:	00002097          	auipc	ra,0x2
    38dc:	ab0080e7          	jalr	-1360(ra) # 5388 <exit>
      close(fd);
    38e0:	00002097          	auipc	ra,0x2
    38e4:	ad0080e7          	jalr	-1328(ra) # 53b0 <close>
    38e8:	a889                	j	393a <iref+0xce>
    unlink("xx");
    38ea:	854e                	mv	a0,s3
    38ec:	00002097          	auipc	ra,0x2
    38f0:	aec080e7          	jalr	-1300(ra) # 53d8 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    38f4:	397d                	addiw	s2,s2,-1
    38f6:	06090063          	beqz	s2,3956 <iref+0xea>
    if(mkdir("irefd") != 0){
    38fa:	8552                	mv	a0,s4
    38fc:	00002097          	auipc	ra,0x2
    3900:	af4080e7          	jalr	-1292(ra) # 53f0 <mkdir>
    3904:	f155                	bnez	a0,38a8 <iref+0x3c>
    if(chdir("irefd") != 0){
    3906:	8552                	mv	a0,s4
    3908:	00002097          	auipc	ra,0x2
    390c:	af0080e7          	jalr	-1296(ra) # 53f8 <chdir>
    3910:	f955                	bnez	a0,38c4 <iref+0x58>
    mkdir("");
    3912:	8526                	mv	a0,s1
    3914:	00002097          	auipc	ra,0x2
    3918:	adc080e7          	jalr	-1316(ra) # 53f0 <mkdir>
    link("README", "");
    391c:	85a6                	mv	a1,s1
    391e:	8556                	mv	a0,s5
    3920:	00002097          	auipc	ra,0x2
    3924:	ac8080e7          	jalr	-1336(ra) # 53e8 <link>
    fd = open("", O_CREATE);
    3928:	20000593          	li	a1,512
    392c:	8526                	mv	a0,s1
    392e:	00002097          	auipc	ra,0x2
    3932:	a9a080e7          	jalr	-1382(ra) # 53c8 <open>
    if(fd >= 0)
    3936:	fa0555e3          	bgez	a0,38e0 <iref+0x74>
    fd = open("xx", O_CREATE);
    393a:	20000593          	li	a1,512
    393e:	854e                	mv	a0,s3
    3940:	00002097          	auipc	ra,0x2
    3944:	a88080e7          	jalr	-1400(ra) # 53c8 <open>
    if(fd >= 0)
    3948:	fa0541e3          	bltz	a0,38ea <iref+0x7e>
      close(fd);
    394c:	00002097          	auipc	ra,0x2
    3950:	a64080e7          	jalr	-1436(ra) # 53b0 <close>
    3954:	bf59                	j	38ea <iref+0x7e>
    3956:	03300493          	li	s1,51
    chdir("..");
    395a:	00004997          	auipc	s3,0x4
    395e:	a3698993          	addi	s3,s3,-1482 # 7390 <statistics+0x1aee>
    unlink("irefd");
    3962:	00004917          	auipc	s2,0x4
    3966:	c0e90913          	addi	s2,s2,-1010 # 7570 <statistics+0x1cce>
    chdir("..");
    396a:	854e                	mv	a0,s3
    396c:	00002097          	auipc	ra,0x2
    3970:	a8c080e7          	jalr	-1396(ra) # 53f8 <chdir>
    unlink("irefd");
    3974:	854a                	mv	a0,s2
    3976:	00002097          	auipc	ra,0x2
    397a:	a62080e7          	jalr	-1438(ra) # 53d8 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    397e:	34fd                	addiw	s1,s1,-1
    3980:	f4ed                	bnez	s1,396a <iref+0xfe>
  chdir("/");
    3982:	00003517          	auipc	a0,0x3
    3986:	41650513          	addi	a0,a0,1046 # 6d98 <statistics+0x14f6>
    398a:	00002097          	auipc	ra,0x2
    398e:	a6e080e7          	jalr	-1426(ra) # 53f8 <chdir>
}
    3992:	70e2                	ld	ra,56(sp)
    3994:	7442                	ld	s0,48(sp)
    3996:	74a2                	ld	s1,40(sp)
    3998:	7902                	ld	s2,32(sp)
    399a:	69e2                	ld	s3,24(sp)
    399c:	6a42                	ld	s4,16(sp)
    399e:	6aa2                	ld	s5,8(sp)
    39a0:	6b02                	ld	s6,0(sp)
    39a2:	6121                	addi	sp,sp,64
    39a4:	8082                	ret

00000000000039a6 <openiputtest>:
{
    39a6:	7179                	addi	sp,sp,-48
    39a8:	f406                	sd	ra,40(sp)
    39aa:	f022                	sd	s0,32(sp)
    39ac:	ec26                	sd	s1,24(sp)
    39ae:	1800                	addi	s0,sp,48
    39b0:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    39b2:	00004517          	auipc	a0,0x4
    39b6:	bf650513          	addi	a0,a0,-1034 # 75a8 <statistics+0x1d06>
    39ba:	00002097          	auipc	ra,0x2
    39be:	a36080e7          	jalr	-1482(ra) # 53f0 <mkdir>
    39c2:	04054263          	bltz	a0,3a06 <openiputtest+0x60>
  pid = fork();
    39c6:	00002097          	auipc	ra,0x2
    39ca:	9ba080e7          	jalr	-1606(ra) # 5380 <fork>
  if(pid < 0){
    39ce:	04054a63          	bltz	a0,3a22 <openiputtest+0x7c>
  if(pid == 0){
    39d2:	e93d                	bnez	a0,3a48 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    39d4:	4589                	li	a1,2
    39d6:	00004517          	auipc	a0,0x4
    39da:	bd250513          	addi	a0,a0,-1070 # 75a8 <statistics+0x1d06>
    39de:	00002097          	auipc	ra,0x2
    39e2:	9ea080e7          	jalr	-1558(ra) # 53c8 <open>
    if(fd >= 0){
    39e6:	04054c63          	bltz	a0,3a3e <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    39ea:	85a6                	mv	a1,s1
    39ec:	00004517          	auipc	a0,0x4
    39f0:	bdc50513          	addi	a0,a0,-1060 # 75c8 <statistics+0x1d26>
    39f4:	00002097          	auipc	ra,0x2
    39f8:	d0c080e7          	jalr	-756(ra) # 5700 <printf>
      exit(1);
    39fc:	4505                	li	a0,1
    39fe:	00002097          	auipc	ra,0x2
    3a02:	98a080e7          	jalr	-1654(ra) # 5388 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3a06:	85a6                	mv	a1,s1
    3a08:	00004517          	auipc	a0,0x4
    3a0c:	ba850513          	addi	a0,a0,-1112 # 75b0 <statistics+0x1d0e>
    3a10:	00002097          	auipc	ra,0x2
    3a14:	cf0080e7          	jalr	-784(ra) # 5700 <printf>
    exit(1);
    3a18:	4505                	li	a0,1
    3a1a:	00002097          	auipc	ra,0x2
    3a1e:	96e080e7          	jalr	-1682(ra) # 5388 <exit>
    printf("%s: fork failed\n", s);
    3a22:	85a6                	mv	a1,s1
    3a24:	00003517          	auipc	a0,0x3
    3a28:	a7450513          	addi	a0,a0,-1420 # 6498 <statistics+0xbf6>
    3a2c:	00002097          	auipc	ra,0x2
    3a30:	cd4080e7          	jalr	-812(ra) # 5700 <printf>
    exit(1);
    3a34:	4505                	li	a0,1
    3a36:	00002097          	auipc	ra,0x2
    3a3a:	952080e7          	jalr	-1710(ra) # 5388 <exit>
    exit(0);
    3a3e:	4501                	li	a0,0
    3a40:	00002097          	auipc	ra,0x2
    3a44:	948080e7          	jalr	-1720(ra) # 5388 <exit>
  sleep(1);
    3a48:	4505                	li	a0,1
    3a4a:	00002097          	auipc	ra,0x2
    3a4e:	9ce080e7          	jalr	-1586(ra) # 5418 <sleep>
  if(unlink("oidir") != 0){
    3a52:	00004517          	auipc	a0,0x4
    3a56:	b5650513          	addi	a0,a0,-1194 # 75a8 <statistics+0x1d06>
    3a5a:	00002097          	auipc	ra,0x2
    3a5e:	97e080e7          	jalr	-1666(ra) # 53d8 <unlink>
    3a62:	cd19                	beqz	a0,3a80 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3a64:	85a6                	mv	a1,s1
    3a66:	00003517          	auipc	a0,0x3
    3a6a:	c2250513          	addi	a0,a0,-990 # 6688 <statistics+0xde6>
    3a6e:	00002097          	auipc	ra,0x2
    3a72:	c92080e7          	jalr	-878(ra) # 5700 <printf>
    exit(1);
    3a76:	4505                	li	a0,1
    3a78:	00002097          	auipc	ra,0x2
    3a7c:	910080e7          	jalr	-1776(ra) # 5388 <exit>
  wait(&xstatus);
    3a80:	fdc40513          	addi	a0,s0,-36
    3a84:	00002097          	auipc	ra,0x2
    3a88:	90c080e7          	jalr	-1780(ra) # 5390 <wait>
  exit(xstatus);
    3a8c:	fdc42503          	lw	a0,-36(s0)
    3a90:	00002097          	auipc	ra,0x2
    3a94:	8f8080e7          	jalr	-1800(ra) # 5388 <exit>

0000000000003a98 <forkforkfork>:
{
    3a98:	1101                	addi	sp,sp,-32
    3a9a:	ec06                	sd	ra,24(sp)
    3a9c:	e822                	sd	s0,16(sp)
    3a9e:	e426                	sd	s1,8(sp)
    3aa0:	1000                	addi	s0,sp,32
    3aa2:	84aa                	mv	s1,a0
  unlink("stopforking");
    3aa4:	00004517          	auipc	a0,0x4
    3aa8:	b4c50513          	addi	a0,a0,-1204 # 75f0 <statistics+0x1d4e>
    3aac:	00002097          	auipc	ra,0x2
    3ab0:	92c080e7          	jalr	-1748(ra) # 53d8 <unlink>
  int pid = fork();
    3ab4:	00002097          	auipc	ra,0x2
    3ab8:	8cc080e7          	jalr	-1844(ra) # 5380 <fork>
  if(pid < 0){
    3abc:	04054563          	bltz	a0,3b06 <forkforkfork+0x6e>
  if(pid == 0){
    3ac0:	c12d                	beqz	a0,3b22 <forkforkfork+0x8a>
  sleep(20); // two seconds
    3ac2:	4551                	li	a0,20
    3ac4:	00002097          	auipc	ra,0x2
    3ac8:	954080e7          	jalr	-1708(ra) # 5418 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3acc:	20200593          	li	a1,514
    3ad0:	00004517          	auipc	a0,0x4
    3ad4:	b2050513          	addi	a0,a0,-1248 # 75f0 <statistics+0x1d4e>
    3ad8:	00002097          	auipc	ra,0x2
    3adc:	8f0080e7          	jalr	-1808(ra) # 53c8 <open>
    3ae0:	00002097          	auipc	ra,0x2
    3ae4:	8d0080e7          	jalr	-1840(ra) # 53b0 <close>
  wait(0);
    3ae8:	4501                	li	a0,0
    3aea:	00002097          	auipc	ra,0x2
    3aee:	8a6080e7          	jalr	-1882(ra) # 5390 <wait>
  sleep(10); // one second
    3af2:	4529                	li	a0,10
    3af4:	00002097          	auipc	ra,0x2
    3af8:	924080e7          	jalr	-1756(ra) # 5418 <sleep>
}
    3afc:	60e2                	ld	ra,24(sp)
    3afe:	6442                	ld	s0,16(sp)
    3b00:	64a2                	ld	s1,8(sp)
    3b02:	6105                	addi	sp,sp,32
    3b04:	8082                	ret
    printf("%s: fork failed", s);
    3b06:	85a6                	mv	a1,s1
    3b08:	00003517          	auipc	a0,0x3
    3b0c:	b5050513          	addi	a0,a0,-1200 # 6658 <statistics+0xdb6>
    3b10:	00002097          	auipc	ra,0x2
    3b14:	bf0080e7          	jalr	-1040(ra) # 5700 <printf>
    exit(1);
    3b18:	4505                	li	a0,1
    3b1a:	00002097          	auipc	ra,0x2
    3b1e:	86e080e7          	jalr	-1938(ra) # 5388 <exit>
      int fd = open("stopforking", 0);
    3b22:	00004497          	auipc	s1,0x4
    3b26:	ace48493          	addi	s1,s1,-1330 # 75f0 <statistics+0x1d4e>
    3b2a:	4581                	li	a1,0
    3b2c:	8526                	mv	a0,s1
    3b2e:	00002097          	auipc	ra,0x2
    3b32:	89a080e7          	jalr	-1894(ra) # 53c8 <open>
      if(fd >= 0){
    3b36:	02055463          	bgez	a0,3b5e <forkforkfork+0xc6>
      if(fork() < 0){
    3b3a:	00002097          	auipc	ra,0x2
    3b3e:	846080e7          	jalr	-1978(ra) # 5380 <fork>
    3b42:	fe0554e3          	bgez	a0,3b2a <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3b46:	20200593          	li	a1,514
    3b4a:	8526                	mv	a0,s1
    3b4c:	00002097          	auipc	ra,0x2
    3b50:	87c080e7          	jalr	-1924(ra) # 53c8 <open>
    3b54:	00002097          	auipc	ra,0x2
    3b58:	85c080e7          	jalr	-1956(ra) # 53b0 <close>
    3b5c:	b7f9                	j	3b2a <forkforkfork+0x92>
        exit(0);
    3b5e:	4501                	li	a0,0
    3b60:	00002097          	auipc	ra,0x2
    3b64:	828080e7          	jalr	-2008(ra) # 5388 <exit>

0000000000003b68 <preempt>:
{
    3b68:	7139                	addi	sp,sp,-64
    3b6a:	fc06                	sd	ra,56(sp)
    3b6c:	f822                	sd	s0,48(sp)
    3b6e:	f426                	sd	s1,40(sp)
    3b70:	f04a                	sd	s2,32(sp)
    3b72:	ec4e                	sd	s3,24(sp)
    3b74:	e852                	sd	s4,16(sp)
    3b76:	0080                	addi	s0,sp,64
    3b78:	8a2a                	mv	s4,a0
  pid1 = fork();
    3b7a:	00002097          	auipc	ra,0x2
    3b7e:	806080e7          	jalr	-2042(ra) # 5380 <fork>
  if(pid1 < 0) {
    3b82:	00054563          	bltz	a0,3b8c <preempt+0x24>
    3b86:	89aa                	mv	s3,a0
  if(pid1 == 0)
    3b88:	ed19                	bnez	a0,3ba6 <preempt+0x3e>
    for(;;)
    3b8a:	a001                	j	3b8a <preempt+0x22>
    printf("%s: fork failed");
    3b8c:	00003517          	auipc	a0,0x3
    3b90:	acc50513          	addi	a0,a0,-1332 # 6658 <statistics+0xdb6>
    3b94:	00002097          	auipc	ra,0x2
    3b98:	b6c080e7          	jalr	-1172(ra) # 5700 <printf>
    exit(1);
    3b9c:	4505                	li	a0,1
    3b9e:	00001097          	auipc	ra,0x1
    3ba2:	7ea080e7          	jalr	2026(ra) # 5388 <exit>
  pid2 = fork();
    3ba6:	00001097          	auipc	ra,0x1
    3baa:	7da080e7          	jalr	2010(ra) # 5380 <fork>
    3bae:	892a                	mv	s2,a0
  if(pid2 < 0) {
    3bb0:	00054463          	bltz	a0,3bb8 <preempt+0x50>
  if(pid2 == 0)
    3bb4:	e105                	bnez	a0,3bd4 <preempt+0x6c>
    for(;;)
    3bb6:	a001                	j	3bb6 <preempt+0x4e>
    printf("%s: fork failed\n", s);
    3bb8:	85d2                	mv	a1,s4
    3bba:	00003517          	auipc	a0,0x3
    3bbe:	8de50513          	addi	a0,a0,-1826 # 6498 <statistics+0xbf6>
    3bc2:	00002097          	auipc	ra,0x2
    3bc6:	b3e080e7          	jalr	-1218(ra) # 5700 <printf>
    exit(1);
    3bca:	4505                	li	a0,1
    3bcc:	00001097          	auipc	ra,0x1
    3bd0:	7bc080e7          	jalr	1980(ra) # 5388 <exit>
  pipe(pfds);
    3bd4:	fc840513          	addi	a0,s0,-56
    3bd8:	00001097          	auipc	ra,0x1
    3bdc:	7c0080e7          	jalr	1984(ra) # 5398 <pipe>
  pid3 = fork();
    3be0:	00001097          	auipc	ra,0x1
    3be4:	7a0080e7          	jalr	1952(ra) # 5380 <fork>
    3be8:	84aa                	mv	s1,a0
  if(pid3 < 0) {
    3bea:	02054e63          	bltz	a0,3c26 <preempt+0xbe>
  if(pid3 == 0){
    3bee:	e13d                	bnez	a0,3c54 <preempt+0xec>
    close(pfds[0]);
    3bf0:	fc842503          	lw	a0,-56(s0)
    3bf4:	00001097          	auipc	ra,0x1
    3bf8:	7bc080e7          	jalr	1980(ra) # 53b0 <close>
    if(write(pfds[1], "x", 1) != 1)
    3bfc:	4605                	li	a2,1
    3bfe:	00002597          	auipc	a1,0x2
    3c02:	0d258593          	addi	a1,a1,210 # 5cd0 <statistics+0x42e>
    3c06:	fcc42503          	lw	a0,-52(s0)
    3c0a:	00001097          	auipc	ra,0x1
    3c0e:	79e080e7          	jalr	1950(ra) # 53a8 <write>
    3c12:	4785                	li	a5,1
    3c14:	02f51763          	bne	a0,a5,3c42 <preempt+0xda>
    close(pfds[1]);
    3c18:	fcc42503          	lw	a0,-52(s0)
    3c1c:	00001097          	auipc	ra,0x1
    3c20:	794080e7          	jalr	1940(ra) # 53b0 <close>
    for(;;)
    3c24:	a001                	j	3c24 <preempt+0xbc>
     printf("%s: fork failed\n", s);
    3c26:	85d2                	mv	a1,s4
    3c28:	00003517          	auipc	a0,0x3
    3c2c:	87050513          	addi	a0,a0,-1936 # 6498 <statistics+0xbf6>
    3c30:	00002097          	auipc	ra,0x2
    3c34:	ad0080e7          	jalr	-1328(ra) # 5700 <printf>
     exit(1);
    3c38:	4505                	li	a0,1
    3c3a:	00001097          	auipc	ra,0x1
    3c3e:	74e080e7          	jalr	1870(ra) # 5388 <exit>
      printf("%s: preempt write error");
    3c42:	00004517          	auipc	a0,0x4
    3c46:	9be50513          	addi	a0,a0,-1602 # 7600 <statistics+0x1d5e>
    3c4a:	00002097          	auipc	ra,0x2
    3c4e:	ab6080e7          	jalr	-1354(ra) # 5700 <printf>
    3c52:	b7d9                	j	3c18 <preempt+0xb0>
  close(pfds[1]);
    3c54:	fcc42503          	lw	a0,-52(s0)
    3c58:	00001097          	auipc	ra,0x1
    3c5c:	758080e7          	jalr	1880(ra) # 53b0 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3c60:	660d                	lui	a2,0x3
    3c62:	00008597          	auipc	a1,0x8
    3c66:	b9e58593          	addi	a1,a1,-1122 # b800 <buf>
    3c6a:	fc842503          	lw	a0,-56(s0)
    3c6e:	00001097          	auipc	ra,0x1
    3c72:	732080e7          	jalr	1842(ra) # 53a0 <read>
    3c76:	4785                	li	a5,1
    3c78:	02f50263          	beq	a0,a5,3c9c <preempt+0x134>
    printf("%s: preempt read error");
    3c7c:	00004517          	auipc	a0,0x4
    3c80:	99c50513          	addi	a0,a0,-1636 # 7618 <statistics+0x1d76>
    3c84:	00002097          	auipc	ra,0x2
    3c88:	a7c080e7          	jalr	-1412(ra) # 5700 <printf>
}
    3c8c:	70e2                	ld	ra,56(sp)
    3c8e:	7442                	ld	s0,48(sp)
    3c90:	74a2                	ld	s1,40(sp)
    3c92:	7902                	ld	s2,32(sp)
    3c94:	69e2                	ld	s3,24(sp)
    3c96:	6a42                	ld	s4,16(sp)
    3c98:	6121                	addi	sp,sp,64
    3c9a:	8082                	ret
  close(pfds[0]);
    3c9c:	fc842503          	lw	a0,-56(s0)
    3ca0:	00001097          	auipc	ra,0x1
    3ca4:	710080e7          	jalr	1808(ra) # 53b0 <close>
  printf("kill... ");
    3ca8:	00004517          	auipc	a0,0x4
    3cac:	98850513          	addi	a0,a0,-1656 # 7630 <statistics+0x1d8e>
    3cb0:	00002097          	auipc	ra,0x2
    3cb4:	a50080e7          	jalr	-1456(ra) # 5700 <printf>
  kill(pid1);
    3cb8:	854e                	mv	a0,s3
    3cba:	00001097          	auipc	ra,0x1
    3cbe:	6fe080e7          	jalr	1790(ra) # 53b8 <kill>
  kill(pid2);
    3cc2:	854a                	mv	a0,s2
    3cc4:	00001097          	auipc	ra,0x1
    3cc8:	6f4080e7          	jalr	1780(ra) # 53b8 <kill>
  kill(pid3);
    3ccc:	8526                	mv	a0,s1
    3cce:	00001097          	auipc	ra,0x1
    3cd2:	6ea080e7          	jalr	1770(ra) # 53b8 <kill>
  printf("wait... ");
    3cd6:	00004517          	auipc	a0,0x4
    3cda:	96a50513          	addi	a0,a0,-1686 # 7640 <statistics+0x1d9e>
    3cde:	00002097          	auipc	ra,0x2
    3ce2:	a22080e7          	jalr	-1502(ra) # 5700 <printf>
  wait(0);
    3ce6:	4501                	li	a0,0
    3ce8:	00001097          	auipc	ra,0x1
    3cec:	6a8080e7          	jalr	1704(ra) # 5390 <wait>
  wait(0);
    3cf0:	4501                	li	a0,0
    3cf2:	00001097          	auipc	ra,0x1
    3cf6:	69e080e7          	jalr	1694(ra) # 5390 <wait>
  wait(0);
    3cfa:	4501                	li	a0,0
    3cfc:	00001097          	auipc	ra,0x1
    3d00:	694080e7          	jalr	1684(ra) # 5390 <wait>
    3d04:	b761                	j	3c8c <preempt+0x124>

0000000000003d06 <sbrkfail>:
{
    3d06:	7119                	addi	sp,sp,-128
    3d08:	fc86                	sd	ra,120(sp)
    3d0a:	f8a2                	sd	s0,112(sp)
    3d0c:	f4a6                	sd	s1,104(sp)
    3d0e:	f0ca                	sd	s2,96(sp)
    3d10:	ecce                	sd	s3,88(sp)
    3d12:	e8d2                	sd	s4,80(sp)
    3d14:	e4d6                	sd	s5,72(sp)
    3d16:	0100                	addi	s0,sp,128
    3d18:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    3d1a:	fb040513          	addi	a0,s0,-80
    3d1e:	00001097          	auipc	ra,0x1
    3d22:	67a080e7          	jalr	1658(ra) # 5398 <pipe>
    3d26:	e901                	bnez	a0,3d36 <sbrkfail+0x30>
    3d28:	f8040493          	addi	s1,s0,-128
    3d2c:	fa840a13          	addi	s4,s0,-88
    3d30:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    3d32:	5afd                	li	s5,-1
    3d34:	a08d                	j	3d96 <sbrkfail+0x90>
    printf("%s: pipe() failed\n", s);
    3d36:	85ca                	mv	a1,s2
    3d38:	00003517          	auipc	a0,0x3
    3d3c:	86850513          	addi	a0,a0,-1944 # 65a0 <statistics+0xcfe>
    3d40:	00002097          	auipc	ra,0x2
    3d44:	9c0080e7          	jalr	-1600(ra) # 5700 <printf>
    exit(1);
    3d48:	4505                	li	a0,1
    3d4a:	00001097          	auipc	ra,0x1
    3d4e:	63e080e7          	jalr	1598(ra) # 5388 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3d52:	4501                	li	a0,0
    3d54:	00001097          	auipc	ra,0x1
    3d58:	6bc080e7          	jalr	1724(ra) # 5410 <sbrk>
    3d5c:	064007b7          	lui	a5,0x6400
    3d60:	40a7853b          	subw	a0,a5,a0
    3d64:	00001097          	auipc	ra,0x1
    3d68:	6ac080e7          	jalr	1708(ra) # 5410 <sbrk>
      write(fds[1], "x", 1);
    3d6c:	4605                	li	a2,1
    3d6e:	00002597          	auipc	a1,0x2
    3d72:	f6258593          	addi	a1,a1,-158 # 5cd0 <statistics+0x42e>
    3d76:	fb442503          	lw	a0,-76(s0)
    3d7a:	00001097          	auipc	ra,0x1
    3d7e:	62e080e7          	jalr	1582(ra) # 53a8 <write>
      for(;;) sleep(1000);
    3d82:	3e800513          	li	a0,1000
    3d86:	00001097          	auipc	ra,0x1
    3d8a:	692080e7          	jalr	1682(ra) # 5418 <sleep>
    3d8e:	bfd5                	j	3d82 <sbrkfail+0x7c>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3d90:	0991                	addi	s3,s3,4
    3d92:	03498563          	beq	s3,s4,3dbc <sbrkfail+0xb6>
    if((pids[i] = fork()) == 0){
    3d96:	00001097          	auipc	ra,0x1
    3d9a:	5ea080e7          	jalr	1514(ra) # 5380 <fork>
    3d9e:	00a9a023          	sw	a0,0(s3)
    3da2:	d945                	beqz	a0,3d52 <sbrkfail+0x4c>
    if(pids[i] != -1)
    3da4:	ff5506e3          	beq	a0,s5,3d90 <sbrkfail+0x8a>
      read(fds[0], &scratch, 1);
    3da8:	4605                	li	a2,1
    3daa:	faf40593          	addi	a1,s0,-81
    3dae:	fb042503          	lw	a0,-80(s0)
    3db2:	00001097          	auipc	ra,0x1
    3db6:	5ee080e7          	jalr	1518(ra) # 53a0 <read>
    3dba:	bfd9                	j	3d90 <sbrkfail+0x8a>
  c = sbrk(PGSIZE);
    3dbc:	6505                	lui	a0,0x1
    3dbe:	00001097          	auipc	ra,0x1
    3dc2:	652080e7          	jalr	1618(ra) # 5410 <sbrk>
    3dc6:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    3dc8:	5afd                	li	s5,-1
    3dca:	a021                	j	3dd2 <sbrkfail+0xcc>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3dcc:	0491                	addi	s1,s1,4
    3dce:	01448f63          	beq	s1,s4,3dec <sbrkfail+0xe6>
    if(pids[i] == -1)
    3dd2:	4088                	lw	a0,0(s1)
    3dd4:	ff550ce3          	beq	a0,s5,3dcc <sbrkfail+0xc6>
    kill(pids[i]);
    3dd8:	00001097          	auipc	ra,0x1
    3ddc:	5e0080e7          	jalr	1504(ra) # 53b8 <kill>
    wait(0);
    3de0:	4501                	li	a0,0
    3de2:	00001097          	auipc	ra,0x1
    3de6:	5ae080e7          	jalr	1454(ra) # 5390 <wait>
    3dea:	b7cd                	j	3dcc <sbrkfail+0xc6>
  if(c == (char*)0xffffffffffffffffL){
    3dec:	57fd                	li	a5,-1
    3dee:	04f98163          	beq	s3,a5,3e30 <sbrkfail+0x12a>
  pid = fork();
    3df2:	00001097          	auipc	ra,0x1
    3df6:	58e080e7          	jalr	1422(ra) # 5380 <fork>
    3dfa:	84aa                	mv	s1,a0
  if(pid < 0){
    3dfc:	04054863          	bltz	a0,3e4c <sbrkfail+0x146>
  if(pid == 0){
    3e00:	c525                	beqz	a0,3e68 <sbrkfail+0x162>
  wait(&xstatus);
    3e02:	fbc40513          	addi	a0,s0,-68
    3e06:	00001097          	auipc	ra,0x1
    3e0a:	58a080e7          	jalr	1418(ra) # 5390 <wait>
  if(xstatus != -1 && xstatus != 2)
    3e0e:	fbc42783          	lw	a5,-68(s0)
    3e12:	577d                	li	a4,-1
    3e14:	00e78563          	beq	a5,a4,3e1e <sbrkfail+0x118>
    3e18:	4709                	li	a4,2
    3e1a:	08e79c63          	bne	a5,a4,3eb2 <sbrkfail+0x1ac>
}
    3e1e:	70e6                	ld	ra,120(sp)
    3e20:	7446                	ld	s0,112(sp)
    3e22:	74a6                	ld	s1,104(sp)
    3e24:	7906                	ld	s2,96(sp)
    3e26:	69e6                	ld	s3,88(sp)
    3e28:	6a46                	ld	s4,80(sp)
    3e2a:	6aa6                	ld	s5,72(sp)
    3e2c:	6109                	addi	sp,sp,128
    3e2e:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3e30:	85ca                	mv	a1,s2
    3e32:	00004517          	auipc	a0,0x4
    3e36:	81e50513          	addi	a0,a0,-2018 # 7650 <statistics+0x1dae>
    3e3a:	00002097          	auipc	ra,0x2
    3e3e:	8c6080e7          	jalr	-1850(ra) # 5700 <printf>
    exit(1);
    3e42:	4505                	li	a0,1
    3e44:	00001097          	auipc	ra,0x1
    3e48:	544080e7          	jalr	1348(ra) # 5388 <exit>
    printf("%s: fork failed\n", s);
    3e4c:	85ca                	mv	a1,s2
    3e4e:	00002517          	auipc	a0,0x2
    3e52:	64a50513          	addi	a0,a0,1610 # 6498 <statistics+0xbf6>
    3e56:	00002097          	auipc	ra,0x2
    3e5a:	8aa080e7          	jalr	-1878(ra) # 5700 <printf>
    exit(1);
    3e5e:	4505                	li	a0,1
    3e60:	00001097          	auipc	ra,0x1
    3e64:	528080e7          	jalr	1320(ra) # 5388 <exit>
    a = sbrk(0);
    3e68:	4501                	li	a0,0
    3e6a:	00001097          	auipc	ra,0x1
    3e6e:	5a6080e7          	jalr	1446(ra) # 5410 <sbrk>
    3e72:	892a                	mv	s2,a0
    sbrk(10*BIG);
    3e74:	3e800537          	lui	a0,0x3e800
    3e78:	00001097          	auipc	ra,0x1
    3e7c:	598080e7          	jalr	1432(ra) # 5410 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3e80:	874a                	mv	a4,s2
    3e82:	3e8007b7          	lui	a5,0x3e800
    3e86:	97ca                	add	a5,a5,s2
    3e88:	6685                	lui	a3,0x1
      n += *(a+i);
    3e8a:	00074603          	lbu	a2,0(a4)
    3e8e:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3e90:	9736                	add	a4,a4,a3
    3e92:	fef71ce3          	bne	a4,a5,3e8a <sbrkfail+0x184>
    printf("%s: allocate a lot of memory succeeded %d\n", n);
    3e96:	85a6                	mv	a1,s1
    3e98:	00003517          	auipc	a0,0x3
    3e9c:	7d850513          	addi	a0,a0,2008 # 7670 <statistics+0x1dce>
    3ea0:	00002097          	auipc	ra,0x2
    3ea4:	860080e7          	jalr	-1952(ra) # 5700 <printf>
    exit(1);
    3ea8:	4505                	li	a0,1
    3eaa:	00001097          	auipc	ra,0x1
    3eae:	4de080e7          	jalr	1246(ra) # 5388 <exit>
    exit(1);
    3eb2:	4505                	li	a0,1
    3eb4:	00001097          	auipc	ra,0x1
    3eb8:	4d4080e7          	jalr	1236(ra) # 5388 <exit>

0000000000003ebc <reparent>:
{
    3ebc:	7179                	addi	sp,sp,-48
    3ebe:	f406                	sd	ra,40(sp)
    3ec0:	f022                	sd	s0,32(sp)
    3ec2:	ec26                	sd	s1,24(sp)
    3ec4:	e84a                	sd	s2,16(sp)
    3ec6:	e44e                	sd	s3,8(sp)
    3ec8:	e052                	sd	s4,0(sp)
    3eca:	1800                	addi	s0,sp,48
    3ecc:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3ece:	00001097          	auipc	ra,0x1
    3ed2:	53a080e7          	jalr	1338(ra) # 5408 <getpid>
    3ed6:	8a2a                	mv	s4,a0
    3ed8:	0c800913          	li	s2,200
    int pid = fork();
    3edc:	00001097          	auipc	ra,0x1
    3ee0:	4a4080e7          	jalr	1188(ra) # 5380 <fork>
    3ee4:	84aa                	mv	s1,a0
    if(pid < 0){
    3ee6:	02054263          	bltz	a0,3f0a <reparent+0x4e>
    if(pid){
    3eea:	cd21                	beqz	a0,3f42 <reparent+0x86>
      if(wait(0) != pid){
    3eec:	4501                	li	a0,0
    3eee:	00001097          	auipc	ra,0x1
    3ef2:	4a2080e7          	jalr	1186(ra) # 5390 <wait>
    3ef6:	02951863          	bne	a0,s1,3f26 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    3efa:	397d                	addiw	s2,s2,-1
    3efc:	fe0910e3          	bnez	s2,3edc <reparent+0x20>
  exit(0);
    3f00:	4501                	li	a0,0
    3f02:	00001097          	auipc	ra,0x1
    3f06:	486080e7          	jalr	1158(ra) # 5388 <exit>
      printf("%s: fork failed\n", s);
    3f0a:	85ce                	mv	a1,s3
    3f0c:	00002517          	auipc	a0,0x2
    3f10:	58c50513          	addi	a0,a0,1420 # 6498 <statistics+0xbf6>
    3f14:	00001097          	auipc	ra,0x1
    3f18:	7ec080e7          	jalr	2028(ra) # 5700 <printf>
      exit(1);
    3f1c:	4505                	li	a0,1
    3f1e:	00001097          	auipc	ra,0x1
    3f22:	46a080e7          	jalr	1130(ra) # 5388 <exit>
        printf("%s: wait wrong pid\n", s);
    3f26:	85ce                	mv	a1,s3
    3f28:	00002517          	auipc	a0,0x2
    3f2c:	6f850513          	addi	a0,a0,1784 # 6620 <statistics+0xd7e>
    3f30:	00001097          	auipc	ra,0x1
    3f34:	7d0080e7          	jalr	2000(ra) # 5700 <printf>
        exit(1);
    3f38:	4505                	li	a0,1
    3f3a:	00001097          	auipc	ra,0x1
    3f3e:	44e080e7          	jalr	1102(ra) # 5388 <exit>
      int pid2 = fork();
    3f42:	00001097          	auipc	ra,0x1
    3f46:	43e080e7          	jalr	1086(ra) # 5380 <fork>
      if(pid2 < 0){
    3f4a:	00054763          	bltz	a0,3f58 <reparent+0x9c>
      exit(0);
    3f4e:	4501                	li	a0,0
    3f50:	00001097          	auipc	ra,0x1
    3f54:	438080e7          	jalr	1080(ra) # 5388 <exit>
        kill(master_pid);
    3f58:	8552                	mv	a0,s4
    3f5a:	00001097          	auipc	ra,0x1
    3f5e:	45e080e7          	jalr	1118(ra) # 53b8 <kill>
        exit(1);
    3f62:	4505                	li	a0,1
    3f64:	00001097          	auipc	ra,0x1
    3f68:	424080e7          	jalr	1060(ra) # 5388 <exit>

0000000000003f6c <mem>:
{
    3f6c:	7139                	addi	sp,sp,-64
    3f6e:	fc06                	sd	ra,56(sp)
    3f70:	f822                	sd	s0,48(sp)
    3f72:	f426                	sd	s1,40(sp)
    3f74:	f04a                	sd	s2,32(sp)
    3f76:	ec4e                	sd	s3,24(sp)
    3f78:	0080                	addi	s0,sp,64
    3f7a:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3f7c:	00001097          	auipc	ra,0x1
    3f80:	404080e7          	jalr	1028(ra) # 5380 <fork>
    m1 = 0;
    3f84:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3f86:	6909                	lui	s2,0x2
    3f88:	71190913          	addi	s2,s2,1809 # 2711 <sbrkarg+0xad>
  if((pid = fork()) == 0){
    3f8c:	ed39                	bnez	a0,3fea <mem+0x7e>
    while((m2 = malloc(10001)) != 0){
    3f8e:	854a                	mv	a0,s2
    3f90:	00002097          	auipc	ra,0x2
    3f94:	82e080e7          	jalr	-2002(ra) # 57be <malloc>
    3f98:	c501                	beqz	a0,3fa0 <mem+0x34>
      *(char**)m2 = m1;
    3f9a:	e104                	sd	s1,0(a0)
      m1 = m2;
    3f9c:	84aa                	mv	s1,a0
    3f9e:	bfc5                	j	3f8e <mem+0x22>
    while(m1){
    3fa0:	c881                	beqz	s1,3fb0 <mem+0x44>
      m2 = *(char**)m1;
    3fa2:	8526                	mv	a0,s1
    3fa4:	6084                	ld	s1,0(s1)
      free(m1);
    3fa6:	00001097          	auipc	ra,0x1
    3faa:	790080e7          	jalr	1936(ra) # 5736 <free>
    while(m1){
    3fae:	f8f5                	bnez	s1,3fa2 <mem+0x36>
    m1 = malloc(1024*20);
    3fb0:	6515                	lui	a0,0x5
    3fb2:	00002097          	auipc	ra,0x2
    3fb6:	80c080e7          	jalr	-2036(ra) # 57be <malloc>
    if(m1 == 0){
    3fba:	c911                	beqz	a0,3fce <mem+0x62>
    free(m1);
    3fbc:	00001097          	auipc	ra,0x1
    3fc0:	77a080e7          	jalr	1914(ra) # 5736 <free>
    exit(0);
    3fc4:	4501                	li	a0,0
    3fc6:	00001097          	auipc	ra,0x1
    3fca:	3c2080e7          	jalr	962(ra) # 5388 <exit>
      printf("couldn't allocate mem?!!\n", s);
    3fce:	85ce                	mv	a1,s3
    3fd0:	00003517          	auipc	a0,0x3
    3fd4:	6d050513          	addi	a0,a0,1744 # 76a0 <statistics+0x1dfe>
    3fd8:	00001097          	auipc	ra,0x1
    3fdc:	728080e7          	jalr	1832(ra) # 5700 <printf>
      exit(1);
    3fe0:	4505                	li	a0,1
    3fe2:	00001097          	auipc	ra,0x1
    3fe6:	3a6080e7          	jalr	934(ra) # 5388 <exit>
    wait(&xstatus);
    3fea:	fcc40513          	addi	a0,s0,-52
    3fee:	00001097          	auipc	ra,0x1
    3ff2:	3a2080e7          	jalr	930(ra) # 5390 <wait>
    if(xstatus == -1){
    3ff6:	fcc42503          	lw	a0,-52(s0)
    3ffa:	57fd                	li	a5,-1
    3ffc:	00f50663          	beq	a0,a5,4008 <mem+0x9c>
    exit(xstatus);
    4000:	00001097          	auipc	ra,0x1
    4004:	388080e7          	jalr	904(ra) # 5388 <exit>
      exit(0);
    4008:	4501                	li	a0,0
    400a:	00001097          	auipc	ra,0x1
    400e:	37e080e7          	jalr	894(ra) # 5388 <exit>

0000000000004012 <sharedfd>:
{
    4012:	7159                	addi	sp,sp,-112
    4014:	f486                	sd	ra,104(sp)
    4016:	f0a2                	sd	s0,96(sp)
    4018:	eca6                	sd	s1,88(sp)
    401a:	e8ca                	sd	s2,80(sp)
    401c:	e4ce                	sd	s3,72(sp)
    401e:	e0d2                	sd	s4,64(sp)
    4020:	fc56                	sd	s5,56(sp)
    4022:	f85a                	sd	s6,48(sp)
    4024:	f45e                	sd	s7,40(sp)
    4026:	1880                	addi	s0,sp,112
    4028:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    402a:	00002517          	auipc	a0,0x2
    402e:	a7e50513          	addi	a0,a0,-1410 # 5aa8 <statistics+0x206>
    4032:	00001097          	auipc	ra,0x1
    4036:	3a6080e7          	jalr	934(ra) # 53d8 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    403a:	20200593          	li	a1,514
    403e:	00002517          	auipc	a0,0x2
    4042:	a6a50513          	addi	a0,a0,-1430 # 5aa8 <statistics+0x206>
    4046:	00001097          	auipc	ra,0x1
    404a:	382080e7          	jalr	898(ra) # 53c8 <open>
  if(fd < 0){
    404e:	04054a63          	bltz	a0,40a2 <sharedfd+0x90>
    4052:	892a                	mv	s2,a0
  pid = fork();
    4054:	00001097          	auipc	ra,0x1
    4058:	32c080e7          	jalr	812(ra) # 5380 <fork>
    405c:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    405e:	06300593          	li	a1,99
    4062:	c119                	beqz	a0,4068 <sharedfd+0x56>
    4064:	07000593          	li	a1,112
    4068:	4629                	li	a2,10
    406a:	fa040513          	addi	a0,s0,-96
    406e:	00001097          	auipc	ra,0x1
    4072:	116080e7          	jalr	278(ra) # 5184 <memset>
    4076:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    407a:	4629                	li	a2,10
    407c:	fa040593          	addi	a1,s0,-96
    4080:	854a                	mv	a0,s2
    4082:	00001097          	auipc	ra,0x1
    4086:	326080e7          	jalr	806(ra) # 53a8 <write>
    408a:	47a9                	li	a5,10
    408c:	02f51963          	bne	a0,a5,40be <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4090:	34fd                	addiw	s1,s1,-1
    4092:	f4e5                	bnez	s1,407a <sharedfd+0x68>
  if(pid == 0) {
    4094:	04099363          	bnez	s3,40da <sharedfd+0xc8>
    exit(0);
    4098:	4501                	li	a0,0
    409a:	00001097          	auipc	ra,0x1
    409e:	2ee080e7          	jalr	750(ra) # 5388 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    40a2:	85d2                	mv	a1,s4
    40a4:	00003517          	auipc	a0,0x3
    40a8:	61c50513          	addi	a0,a0,1564 # 76c0 <statistics+0x1e1e>
    40ac:	00001097          	auipc	ra,0x1
    40b0:	654080e7          	jalr	1620(ra) # 5700 <printf>
    exit(1);
    40b4:	4505                	li	a0,1
    40b6:	00001097          	auipc	ra,0x1
    40ba:	2d2080e7          	jalr	722(ra) # 5388 <exit>
      printf("%s: write sharedfd failed\n", s);
    40be:	85d2                	mv	a1,s4
    40c0:	00003517          	auipc	a0,0x3
    40c4:	62850513          	addi	a0,a0,1576 # 76e8 <statistics+0x1e46>
    40c8:	00001097          	auipc	ra,0x1
    40cc:	638080e7          	jalr	1592(ra) # 5700 <printf>
      exit(1);
    40d0:	4505                	li	a0,1
    40d2:	00001097          	auipc	ra,0x1
    40d6:	2b6080e7          	jalr	694(ra) # 5388 <exit>
    wait(&xstatus);
    40da:	f9c40513          	addi	a0,s0,-100
    40de:	00001097          	auipc	ra,0x1
    40e2:	2b2080e7          	jalr	690(ra) # 5390 <wait>
    if(xstatus != 0)
    40e6:	f9c42983          	lw	s3,-100(s0)
    40ea:	00098763          	beqz	s3,40f8 <sharedfd+0xe6>
      exit(xstatus);
    40ee:	854e                	mv	a0,s3
    40f0:	00001097          	auipc	ra,0x1
    40f4:	298080e7          	jalr	664(ra) # 5388 <exit>
  close(fd);
    40f8:	854a                	mv	a0,s2
    40fa:	00001097          	auipc	ra,0x1
    40fe:	2b6080e7          	jalr	694(ra) # 53b0 <close>
  fd = open("sharedfd", 0);
    4102:	4581                	li	a1,0
    4104:	00002517          	auipc	a0,0x2
    4108:	9a450513          	addi	a0,a0,-1628 # 5aa8 <statistics+0x206>
    410c:	00001097          	auipc	ra,0x1
    4110:	2bc080e7          	jalr	700(ra) # 53c8 <open>
    4114:	8baa                	mv	s7,a0
  nc = np = 0;
    4116:	8ace                	mv	s5,s3
  if(fd < 0){
    4118:	02054563          	bltz	a0,4142 <sharedfd+0x130>
    411c:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4120:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4124:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4128:	4629                	li	a2,10
    412a:	fa040593          	addi	a1,s0,-96
    412e:	855e                	mv	a0,s7
    4130:	00001097          	auipc	ra,0x1
    4134:	270080e7          	jalr	624(ra) # 53a0 <read>
    4138:	02a05f63          	blez	a0,4176 <sharedfd+0x164>
    413c:	fa040793          	addi	a5,s0,-96
    4140:	a01d                	j	4166 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4142:	85d2                	mv	a1,s4
    4144:	00003517          	auipc	a0,0x3
    4148:	5c450513          	addi	a0,a0,1476 # 7708 <statistics+0x1e66>
    414c:	00001097          	auipc	ra,0x1
    4150:	5b4080e7          	jalr	1460(ra) # 5700 <printf>
    exit(1);
    4154:	4505                	li	a0,1
    4156:	00001097          	auipc	ra,0x1
    415a:	232080e7          	jalr	562(ra) # 5388 <exit>
        nc++;
    415e:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4160:	0785                	addi	a5,a5,1
    4162:	fd2783e3          	beq	a5,s2,4128 <sharedfd+0x116>
      if(buf[i] == 'c')
    4166:	0007c703          	lbu	a4,0(a5) # 3e800000 <__BSS_END__+0x3e7f17f0>
    416a:	fe970ae3          	beq	a4,s1,415e <sharedfd+0x14c>
      if(buf[i] == 'p')
    416e:	ff6719e3          	bne	a4,s6,4160 <sharedfd+0x14e>
        np++;
    4172:	2a85                	addiw	s5,s5,1
    4174:	b7f5                	j	4160 <sharedfd+0x14e>
  close(fd);
    4176:	855e                	mv	a0,s7
    4178:	00001097          	auipc	ra,0x1
    417c:	238080e7          	jalr	568(ra) # 53b0 <close>
  unlink("sharedfd");
    4180:	00002517          	auipc	a0,0x2
    4184:	92850513          	addi	a0,a0,-1752 # 5aa8 <statistics+0x206>
    4188:	00001097          	auipc	ra,0x1
    418c:	250080e7          	jalr	592(ra) # 53d8 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4190:	6789                	lui	a5,0x2
    4192:	71078793          	addi	a5,a5,1808 # 2710 <sbrkarg+0xac>
    4196:	00f99763          	bne	s3,a5,41a4 <sharedfd+0x192>
    419a:	6789                	lui	a5,0x2
    419c:	71078793          	addi	a5,a5,1808 # 2710 <sbrkarg+0xac>
    41a0:	02fa8063          	beq	s5,a5,41c0 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    41a4:	85d2                	mv	a1,s4
    41a6:	00003517          	auipc	a0,0x3
    41aa:	58a50513          	addi	a0,a0,1418 # 7730 <statistics+0x1e8e>
    41ae:	00001097          	auipc	ra,0x1
    41b2:	552080e7          	jalr	1362(ra) # 5700 <printf>
    exit(1);
    41b6:	4505                	li	a0,1
    41b8:	00001097          	auipc	ra,0x1
    41bc:	1d0080e7          	jalr	464(ra) # 5388 <exit>
    exit(0);
    41c0:	4501                	li	a0,0
    41c2:	00001097          	auipc	ra,0x1
    41c6:	1c6080e7          	jalr	454(ra) # 5388 <exit>

00000000000041ca <fourfiles>:
{
    41ca:	7171                	addi	sp,sp,-176
    41cc:	f506                	sd	ra,168(sp)
    41ce:	f122                	sd	s0,160(sp)
    41d0:	ed26                	sd	s1,152(sp)
    41d2:	e94a                	sd	s2,144(sp)
    41d4:	e54e                	sd	s3,136(sp)
    41d6:	e152                	sd	s4,128(sp)
    41d8:	fcd6                	sd	s5,120(sp)
    41da:	f8da                	sd	s6,112(sp)
    41dc:	f4de                	sd	s7,104(sp)
    41de:	f0e2                	sd	s8,96(sp)
    41e0:	ece6                	sd	s9,88(sp)
    41e2:	e8ea                	sd	s10,80(sp)
    41e4:	e4ee                	sd	s11,72(sp)
    41e6:	1900                	addi	s0,sp,176
    41e8:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    41ea:	00001797          	auipc	a5,0x1
    41ee:	73e78793          	addi	a5,a5,1854 # 5928 <statistics+0x86>
    41f2:	f6f43823          	sd	a5,-144(s0)
    41f6:	00001797          	auipc	a5,0x1
    41fa:	73a78793          	addi	a5,a5,1850 # 5930 <statistics+0x8e>
    41fe:	f6f43c23          	sd	a5,-136(s0)
    4202:	00001797          	auipc	a5,0x1
    4206:	73678793          	addi	a5,a5,1846 # 5938 <statistics+0x96>
    420a:	f8f43023          	sd	a5,-128(s0)
    420e:	00001797          	auipc	a5,0x1
    4212:	73278793          	addi	a5,a5,1842 # 5940 <statistics+0x9e>
    4216:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    421a:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    421e:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4220:	4481                	li	s1,0
    4222:	4a11                	li	s4,4
    fname = names[pi];
    4224:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4228:	854e                	mv	a0,s3
    422a:	00001097          	auipc	ra,0x1
    422e:	1ae080e7          	jalr	430(ra) # 53d8 <unlink>
    pid = fork();
    4232:	00001097          	auipc	ra,0x1
    4236:	14e080e7          	jalr	334(ra) # 5380 <fork>
    if(pid < 0){
    423a:	04054563          	bltz	a0,4284 <fourfiles+0xba>
    if(pid == 0){
    423e:	c12d                	beqz	a0,42a0 <fourfiles+0xd6>
  for(pi = 0; pi < NCHILD; pi++){
    4240:	2485                	addiw	s1,s1,1
    4242:	0921                	addi	s2,s2,8
    4244:	ff4490e3          	bne	s1,s4,4224 <fourfiles+0x5a>
    4248:	4491                	li	s1,4
    wait(&xstatus);
    424a:	f6c40513          	addi	a0,s0,-148
    424e:	00001097          	auipc	ra,0x1
    4252:	142080e7          	jalr	322(ra) # 5390 <wait>
    if(xstatus != 0)
    4256:	f6c42503          	lw	a0,-148(s0)
    425a:	ed69                	bnez	a0,4334 <fourfiles+0x16a>
  for(pi = 0; pi < NCHILD; pi++){
    425c:	34fd                	addiw	s1,s1,-1
    425e:	f4f5                	bnez	s1,424a <fourfiles+0x80>
    4260:	03000b13          	li	s6,48
    total = 0;
    4264:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4268:	00007a17          	auipc	s4,0x7
    426c:	598a0a13          	addi	s4,s4,1432 # b800 <buf>
    4270:	00007a97          	auipc	s5,0x7
    4274:	591a8a93          	addi	s5,s5,1425 # b801 <buf+0x1>
    if(total != N*SZ){
    4278:	6d05                	lui	s10,0x1
    427a:	770d0d13          	addi	s10,s10,1904 # 1770 <pipe1+0x2a>
  for(i = 0; i < NCHILD; i++){
    427e:	03400d93          	li	s11,52
    4282:	a23d                	j	43b0 <fourfiles+0x1e6>
      printf("fork failed\n", s);
    4284:	85e6                	mv	a1,s9
    4286:	00002517          	auipc	a0,0x2
    428a:	60250513          	addi	a0,a0,1538 # 6888 <statistics+0xfe6>
    428e:	00001097          	auipc	ra,0x1
    4292:	472080e7          	jalr	1138(ra) # 5700 <printf>
      exit(1);
    4296:	4505                	li	a0,1
    4298:	00001097          	auipc	ra,0x1
    429c:	0f0080e7          	jalr	240(ra) # 5388 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    42a0:	20200593          	li	a1,514
    42a4:	854e                	mv	a0,s3
    42a6:	00001097          	auipc	ra,0x1
    42aa:	122080e7          	jalr	290(ra) # 53c8 <open>
    42ae:	892a                	mv	s2,a0
      if(fd < 0){
    42b0:	04054763          	bltz	a0,42fe <fourfiles+0x134>
      memset(buf, '0'+pi, SZ);
    42b4:	1f400613          	li	a2,500
    42b8:	0304859b          	addiw	a1,s1,48
    42bc:	00007517          	auipc	a0,0x7
    42c0:	54450513          	addi	a0,a0,1348 # b800 <buf>
    42c4:	00001097          	auipc	ra,0x1
    42c8:	ec0080e7          	jalr	-320(ra) # 5184 <memset>
    42cc:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    42ce:	00007997          	auipc	s3,0x7
    42d2:	53298993          	addi	s3,s3,1330 # b800 <buf>
    42d6:	1f400613          	li	a2,500
    42da:	85ce                	mv	a1,s3
    42dc:	854a                	mv	a0,s2
    42de:	00001097          	auipc	ra,0x1
    42e2:	0ca080e7          	jalr	202(ra) # 53a8 <write>
    42e6:	85aa                	mv	a1,a0
    42e8:	1f400793          	li	a5,500
    42ec:	02f51763          	bne	a0,a5,431a <fourfiles+0x150>
      for(i = 0; i < N; i++){
    42f0:	34fd                	addiw	s1,s1,-1
    42f2:	f0f5                	bnez	s1,42d6 <fourfiles+0x10c>
      exit(0);
    42f4:	4501                	li	a0,0
    42f6:	00001097          	auipc	ra,0x1
    42fa:	092080e7          	jalr	146(ra) # 5388 <exit>
        printf("create failed\n", s);
    42fe:	85e6                	mv	a1,s9
    4300:	00003517          	auipc	a0,0x3
    4304:	44850513          	addi	a0,a0,1096 # 7748 <statistics+0x1ea6>
    4308:	00001097          	auipc	ra,0x1
    430c:	3f8080e7          	jalr	1016(ra) # 5700 <printf>
        exit(1);
    4310:	4505                	li	a0,1
    4312:	00001097          	auipc	ra,0x1
    4316:	076080e7          	jalr	118(ra) # 5388 <exit>
          printf("write failed %d\n", n);
    431a:	00003517          	auipc	a0,0x3
    431e:	43e50513          	addi	a0,a0,1086 # 7758 <statistics+0x1eb6>
    4322:	00001097          	auipc	ra,0x1
    4326:	3de080e7          	jalr	990(ra) # 5700 <printf>
          exit(1);
    432a:	4505                	li	a0,1
    432c:	00001097          	auipc	ra,0x1
    4330:	05c080e7          	jalr	92(ra) # 5388 <exit>
      exit(xstatus);
    4334:	00001097          	auipc	ra,0x1
    4338:	054080e7          	jalr	84(ra) # 5388 <exit>
          printf("wrong char\n", s);
    433c:	85e6                	mv	a1,s9
    433e:	00003517          	auipc	a0,0x3
    4342:	43250513          	addi	a0,a0,1074 # 7770 <statistics+0x1ece>
    4346:	00001097          	auipc	ra,0x1
    434a:	3ba080e7          	jalr	954(ra) # 5700 <printf>
          exit(1);
    434e:	4505                	li	a0,1
    4350:	00001097          	auipc	ra,0x1
    4354:	038080e7          	jalr	56(ra) # 5388 <exit>
      total += n;
    4358:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    435c:	660d                	lui	a2,0x3
    435e:	85d2                	mv	a1,s4
    4360:	854e                	mv	a0,s3
    4362:	00001097          	auipc	ra,0x1
    4366:	03e080e7          	jalr	62(ra) # 53a0 <read>
    436a:	02a05363          	blez	a0,4390 <fourfiles+0x1c6>
    436e:	00007797          	auipc	a5,0x7
    4372:	49278793          	addi	a5,a5,1170 # b800 <buf>
    4376:	fff5069b          	addiw	a3,a0,-1
    437a:	1682                	slli	a3,a3,0x20
    437c:	9281                	srli	a3,a3,0x20
    437e:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    4380:	0007c703          	lbu	a4,0(a5)
    4384:	fa971ce3          	bne	a4,s1,433c <fourfiles+0x172>
      for(j = 0; j < n; j++){
    4388:	0785                	addi	a5,a5,1
    438a:	fed79be3          	bne	a5,a3,4380 <fourfiles+0x1b6>
    438e:	b7e9                	j	4358 <fourfiles+0x18e>
    close(fd);
    4390:	854e                	mv	a0,s3
    4392:	00001097          	auipc	ra,0x1
    4396:	01e080e7          	jalr	30(ra) # 53b0 <close>
    if(total != N*SZ){
    439a:	03a91963          	bne	s2,s10,43cc <fourfiles+0x202>
    unlink(fname);
    439e:	8562                	mv	a0,s8
    43a0:	00001097          	auipc	ra,0x1
    43a4:	038080e7          	jalr	56(ra) # 53d8 <unlink>
  for(i = 0; i < NCHILD; i++){
    43a8:	0ba1                	addi	s7,s7,8
    43aa:	2b05                	addiw	s6,s6,1
    43ac:	03bb0e63          	beq	s6,s11,43e8 <fourfiles+0x21e>
    fname = names[i];
    43b0:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    43b4:	4581                	li	a1,0
    43b6:	8562                	mv	a0,s8
    43b8:	00001097          	auipc	ra,0x1
    43bc:	010080e7          	jalr	16(ra) # 53c8 <open>
    43c0:	89aa                	mv	s3,a0
    total = 0;
    43c2:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    43c6:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    43ca:	bf49                	j	435c <fourfiles+0x192>
      printf("wrong length %d\n", total);
    43cc:	85ca                	mv	a1,s2
    43ce:	00003517          	auipc	a0,0x3
    43d2:	3b250513          	addi	a0,a0,946 # 7780 <statistics+0x1ede>
    43d6:	00001097          	auipc	ra,0x1
    43da:	32a080e7          	jalr	810(ra) # 5700 <printf>
      exit(1);
    43de:	4505                	li	a0,1
    43e0:	00001097          	auipc	ra,0x1
    43e4:	fa8080e7          	jalr	-88(ra) # 5388 <exit>
}
    43e8:	70aa                	ld	ra,168(sp)
    43ea:	740a                	ld	s0,160(sp)
    43ec:	64ea                	ld	s1,152(sp)
    43ee:	694a                	ld	s2,144(sp)
    43f0:	69aa                	ld	s3,136(sp)
    43f2:	6a0a                	ld	s4,128(sp)
    43f4:	7ae6                	ld	s5,120(sp)
    43f6:	7b46                	ld	s6,112(sp)
    43f8:	7ba6                	ld	s7,104(sp)
    43fa:	7c06                	ld	s8,96(sp)
    43fc:	6ce6                	ld	s9,88(sp)
    43fe:	6d46                	ld	s10,80(sp)
    4400:	6da6                	ld	s11,72(sp)
    4402:	614d                	addi	sp,sp,176
    4404:	8082                	ret

0000000000004406 <concreate>:
{
    4406:	7135                	addi	sp,sp,-160
    4408:	ed06                	sd	ra,152(sp)
    440a:	e922                	sd	s0,144(sp)
    440c:	e526                	sd	s1,136(sp)
    440e:	e14a                	sd	s2,128(sp)
    4410:	fcce                	sd	s3,120(sp)
    4412:	f8d2                	sd	s4,112(sp)
    4414:	f4d6                	sd	s5,104(sp)
    4416:	f0da                	sd	s6,96(sp)
    4418:	ecde                	sd	s7,88(sp)
    441a:	1100                	addi	s0,sp,160
    441c:	89aa                	mv	s3,a0
  file[0] = 'C';
    441e:	04300793          	li	a5,67
    4422:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4426:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    442a:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    442c:	4b0d                	li	s6,3
    442e:	4a85                	li	s5,1
      link("C0", file);
    4430:	00003b97          	auipc	s7,0x3
    4434:	368b8b93          	addi	s7,s7,872 # 7798 <statistics+0x1ef6>
  for(i = 0; i < N; i++){
    4438:	02800a13          	li	s4,40
    443c:	acc1                	j	470c <concreate+0x306>
      link("C0", file);
    443e:	fa840593          	addi	a1,s0,-88
    4442:	855e                	mv	a0,s7
    4444:	00001097          	auipc	ra,0x1
    4448:	fa4080e7          	jalr	-92(ra) # 53e8 <link>
    if(pid == 0) {
    444c:	a45d                	j	46f2 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    444e:	4795                	li	a5,5
    4450:	02f9693b          	remw	s2,s2,a5
    4454:	4785                	li	a5,1
    4456:	02f90b63          	beq	s2,a5,448c <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    445a:	20200593          	li	a1,514
    445e:	fa840513          	addi	a0,s0,-88
    4462:	00001097          	auipc	ra,0x1
    4466:	f66080e7          	jalr	-154(ra) # 53c8 <open>
      if(fd < 0){
    446a:	26055b63          	bgez	a0,46e0 <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    446e:	fa840593          	addi	a1,s0,-88
    4472:	00003517          	auipc	a0,0x3
    4476:	32e50513          	addi	a0,a0,814 # 77a0 <statistics+0x1efe>
    447a:	00001097          	auipc	ra,0x1
    447e:	286080e7          	jalr	646(ra) # 5700 <printf>
        exit(1);
    4482:	4505                	li	a0,1
    4484:	00001097          	auipc	ra,0x1
    4488:	f04080e7          	jalr	-252(ra) # 5388 <exit>
      link("C0", file);
    448c:	fa840593          	addi	a1,s0,-88
    4490:	00003517          	auipc	a0,0x3
    4494:	30850513          	addi	a0,a0,776 # 7798 <statistics+0x1ef6>
    4498:	00001097          	auipc	ra,0x1
    449c:	f50080e7          	jalr	-176(ra) # 53e8 <link>
      exit(0);
    44a0:	4501                	li	a0,0
    44a2:	00001097          	auipc	ra,0x1
    44a6:	ee6080e7          	jalr	-282(ra) # 5388 <exit>
        exit(1);
    44aa:	4505                	li	a0,1
    44ac:	00001097          	auipc	ra,0x1
    44b0:	edc080e7          	jalr	-292(ra) # 5388 <exit>
  memset(fa, 0, sizeof(fa));
    44b4:	02800613          	li	a2,40
    44b8:	4581                	li	a1,0
    44ba:	f8040513          	addi	a0,s0,-128
    44be:	00001097          	auipc	ra,0x1
    44c2:	cc6080e7          	jalr	-826(ra) # 5184 <memset>
  fd = open(".", 0);
    44c6:	4581                	li	a1,0
    44c8:	00002517          	auipc	a0,0x2
    44cc:	e3050513          	addi	a0,a0,-464 # 62f8 <statistics+0xa56>
    44d0:	00001097          	auipc	ra,0x1
    44d4:	ef8080e7          	jalr	-264(ra) # 53c8 <open>
    44d8:	892a                	mv	s2,a0
  n = 0;
    44da:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    44dc:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    44e0:	02700b13          	li	s6,39
      fa[i] = 1;
    44e4:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    44e6:	a03d                	j	4514 <concreate+0x10e>
        printf("%s: concreate weird file %s\n", s, de.name);
    44e8:	f7240613          	addi	a2,s0,-142
    44ec:	85ce                	mv	a1,s3
    44ee:	00003517          	auipc	a0,0x3
    44f2:	2d250513          	addi	a0,a0,722 # 77c0 <statistics+0x1f1e>
    44f6:	00001097          	auipc	ra,0x1
    44fa:	20a080e7          	jalr	522(ra) # 5700 <printf>
        exit(1);
    44fe:	4505                	li	a0,1
    4500:	00001097          	auipc	ra,0x1
    4504:	e88080e7          	jalr	-376(ra) # 5388 <exit>
      fa[i] = 1;
    4508:	fb040793          	addi	a5,s0,-80
    450c:	973e                	add	a4,a4,a5
    450e:	fd770823          	sb	s7,-48(a4)
      n++;
    4512:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    4514:	4641                	li	a2,16
    4516:	f7040593          	addi	a1,s0,-144
    451a:	854a                	mv	a0,s2
    451c:	00001097          	auipc	ra,0x1
    4520:	e84080e7          	jalr	-380(ra) # 53a0 <read>
    4524:	04a05a63          	blez	a0,4578 <concreate+0x172>
    if(de.inum == 0)
    4528:	f7045783          	lhu	a5,-144(s0)
    452c:	d7e5                	beqz	a5,4514 <concreate+0x10e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    452e:	f7244783          	lbu	a5,-142(s0)
    4532:	ff4791e3          	bne	a5,s4,4514 <concreate+0x10e>
    4536:	f7444783          	lbu	a5,-140(s0)
    453a:	ffe9                	bnez	a5,4514 <concreate+0x10e>
      i = de.name[1] - '0';
    453c:	f7344783          	lbu	a5,-141(s0)
    4540:	fd07879b          	addiw	a5,a5,-48
    4544:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4548:	faeb60e3          	bltu	s6,a4,44e8 <concreate+0xe2>
      if(fa[i]){
    454c:	fb040793          	addi	a5,s0,-80
    4550:	97ba                	add	a5,a5,a4
    4552:	fd07c783          	lbu	a5,-48(a5)
    4556:	dbcd                	beqz	a5,4508 <concreate+0x102>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4558:	f7240613          	addi	a2,s0,-142
    455c:	85ce                	mv	a1,s3
    455e:	00003517          	auipc	a0,0x3
    4562:	28250513          	addi	a0,a0,642 # 77e0 <statistics+0x1f3e>
    4566:	00001097          	auipc	ra,0x1
    456a:	19a080e7          	jalr	410(ra) # 5700 <printf>
        exit(1);
    456e:	4505                	li	a0,1
    4570:	00001097          	auipc	ra,0x1
    4574:	e18080e7          	jalr	-488(ra) # 5388 <exit>
  close(fd);
    4578:	854a                	mv	a0,s2
    457a:	00001097          	auipc	ra,0x1
    457e:	e36080e7          	jalr	-458(ra) # 53b0 <close>
  if(n != N){
    4582:	02800793          	li	a5,40
    4586:	00fa9763          	bne	s5,a5,4594 <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    458a:	4a8d                	li	s5,3
    458c:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    458e:	02800a13          	li	s4,40
    4592:	a8c9                	j	4664 <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    4594:	85ce                	mv	a1,s3
    4596:	00003517          	auipc	a0,0x3
    459a:	27250513          	addi	a0,a0,626 # 7808 <statistics+0x1f66>
    459e:	00001097          	auipc	ra,0x1
    45a2:	162080e7          	jalr	354(ra) # 5700 <printf>
    exit(1);
    45a6:	4505                	li	a0,1
    45a8:	00001097          	auipc	ra,0x1
    45ac:	de0080e7          	jalr	-544(ra) # 5388 <exit>
      printf("%s: fork failed\n", s);
    45b0:	85ce                	mv	a1,s3
    45b2:	00002517          	auipc	a0,0x2
    45b6:	ee650513          	addi	a0,a0,-282 # 6498 <statistics+0xbf6>
    45ba:	00001097          	auipc	ra,0x1
    45be:	146080e7          	jalr	326(ra) # 5700 <printf>
      exit(1);
    45c2:	4505                	li	a0,1
    45c4:	00001097          	auipc	ra,0x1
    45c8:	dc4080e7          	jalr	-572(ra) # 5388 <exit>
      close(open(file, 0));
    45cc:	4581                	li	a1,0
    45ce:	fa840513          	addi	a0,s0,-88
    45d2:	00001097          	auipc	ra,0x1
    45d6:	df6080e7          	jalr	-522(ra) # 53c8 <open>
    45da:	00001097          	auipc	ra,0x1
    45de:	dd6080e7          	jalr	-554(ra) # 53b0 <close>
      close(open(file, 0));
    45e2:	4581                	li	a1,0
    45e4:	fa840513          	addi	a0,s0,-88
    45e8:	00001097          	auipc	ra,0x1
    45ec:	de0080e7          	jalr	-544(ra) # 53c8 <open>
    45f0:	00001097          	auipc	ra,0x1
    45f4:	dc0080e7          	jalr	-576(ra) # 53b0 <close>
      close(open(file, 0));
    45f8:	4581                	li	a1,0
    45fa:	fa840513          	addi	a0,s0,-88
    45fe:	00001097          	auipc	ra,0x1
    4602:	dca080e7          	jalr	-566(ra) # 53c8 <open>
    4606:	00001097          	auipc	ra,0x1
    460a:	daa080e7          	jalr	-598(ra) # 53b0 <close>
      close(open(file, 0));
    460e:	4581                	li	a1,0
    4610:	fa840513          	addi	a0,s0,-88
    4614:	00001097          	auipc	ra,0x1
    4618:	db4080e7          	jalr	-588(ra) # 53c8 <open>
    461c:	00001097          	auipc	ra,0x1
    4620:	d94080e7          	jalr	-620(ra) # 53b0 <close>
      close(open(file, 0));
    4624:	4581                	li	a1,0
    4626:	fa840513          	addi	a0,s0,-88
    462a:	00001097          	auipc	ra,0x1
    462e:	d9e080e7          	jalr	-610(ra) # 53c8 <open>
    4632:	00001097          	auipc	ra,0x1
    4636:	d7e080e7          	jalr	-642(ra) # 53b0 <close>
      close(open(file, 0));
    463a:	4581                	li	a1,0
    463c:	fa840513          	addi	a0,s0,-88
    4640:	00001097          	auipc	ra,0x1
    4644:	d88080e7          	jalr	-632(ra) # 53c8 <open>
    4648:	00001097          	auipc	ra,0x1
    464c:	d68080e7          	jalr	-664(ra) # 53b0 <close>
    if(pid == 0)
    4650:	08090363          	beqz	s2,46d6 <concreate+0x2d0>
      wait(0);
    4654:	4501                	li	a0,0
    4656:	00001097          	auipc	ra,0x1
    465a:	d3a080e7          	jalr	-710(ra) # 5390 <wait>
  for(i = 0; i < N; i++){
    465e:	2485                	addiw	s1,s1,1
    4660:	0f448563          	beq	s1,s4,474a <concreate+0x344>
    file[1] = '0' + i;
    4664:	0304879b          	addiw	a5,s1,48
    4668:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    466c:	00001097          	auipc	ra,0x1
    4670:	d14080e7          	jalr	-748(ra) # 5380 <fork>
    4674:	892a                	mv	s2,a0
    if(pid < 0){
    4676:	f2054de3          	bltz	a0,45b0 <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    467a:	0354e73b          	remw	a4,s1,s5
    467e:	00a767b3          	or	a5,a4,a0
    4682:	2781                	sext.w	a5,a5
    4684:	d7a1                	beqz	a5,45cc <concreate+0x1c6>
    4686:	01671363          	bne	a4,s6,468c <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    468a:	f129                	bnez	a0,45cc <concreate+0x1c6>
      unlink(file);
    468c:	fa840513          	addi	a0,s0,-88
    4690:	00001097          	auipc	ra,0x1
    4694:	d48080e7          	jalr	-696(ra) # 53d8 <unlink>
      unlink(file);
    4698:	fa840513          	addi	a0,s0,-88
    469c:	00001097          	auipc	ra,0x1
    46a0:	d3c080e7          	jalr	-708(ra) # 53d8 <unlink>
      unlink(file);
    46a4:	fa840513          	addi	a0,s0,-88
    46a8:	00001097          	auipc	ra,0x1
    46ac:	d30080e7          	jalr	-720(ra) # 53d8 <unlink>
      unlink(file);
    46b0:	fa840513          	addi	a0,s0,-88
    46b4:	00001097          	auipc	ra,0x1
    46b8:	d24080e7          	jalr	-732(ra) # 53d8 <unlink>
      unlink(file);
    46bc:	fa840513          	addi	a0,s0,-88
    46c0:	00001097          	auipc	ra,0x1
    46c4:	d18080e7          	jalr	-744(ra) # 53d8 <unlink>
      unlink(file);
    46c8:	fa840513          	addi	a0,s0,-88
    46cc:	00001097          	auipc	ra,0x1
    46d0:	d0c080e7          	jalr	-756(ra) # 53d8 <unlink>
    46d4:	bfb5                	j	4650 <concreate+0x24a>
      exit(0);
    46d6:	4501                	li	a0,0
    46d8:	00001097          	auipc	ra,0x1
    46dc:	cb0080e7          	jalr	-848(ra) # 5388 <exit>
      close(fd);
    46e0:	00001097          	auipc	ra,0x1
    46e4:	cd0080e7          	jalr	-816(ra) # 53b0 <close>
    if(pid == 0) {
    46e8:	bb65                	j	44a0 <concreate+0x9a>
      close(fd);
    46ea:	00001097          	auipc	ra,0x1
    46ee:	cc6080e7          	jalr	-826(ra) # 53b0 <close>
      wait(&xstatus);
    46f2:	f6c40513          	addi	a0,s0,-148
    46f6:	00001097          	auipc	ra,0x1
    46fa:	c9a080e7          	jalr	-870(ra) # 5390 <wait>
      if(xstatus != 0)
    46fe:	f6c42483          	lw	s1,-148(s0)
    4702:	da0494e3          	bnez	s1,44aa <concreate+0xa4>
  for(i = 0; i < N; i++){
    4706:	2905                	addiw	s2,s2,1
    4708:	db4906e3          	beq	s2,s4,44b4 <concreate+0xae>
    file[1] = '0' + i;
    470c:	0309079b          	addiw	a5,s2,48
    4710:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4714:	fa840513          	addi	a0,s0,-88
    4718:	00001097          	auipc	ra,0x1
    471c:	cc0080e7          	jalr	-832(ra) # 53d8 <unlink>
    pid = fork();
    4720:	00001097          	auipc	ra,0x1
    4724:	c60080e7          	jalr	-928(ra) # 5380 <fork>
    if(pid && (i % 3) == 1){
    4728:	d20503e3          	beqz	a0,444e <concreate+0x48>
    472c:	036967bb          	remw	a5,s2,s6
    4730:	d15787e3          	beq	a5,s5,443e <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4734:	20200593          	li	a1,514
    4738:	fa840513          	addi	a0,s0,-88
    473c:	00001097          	auipc	ra,0x1
    4740:	c8c080e7          	jalr	-884(ra) # 53c8 <open>
      if(fd < 0){
    4744:	fa0553e3          	bgez	a0,46ea <concreate+0x2e4>
    4748:	b31d                	j	446e <concreate+0x68>
}
    474a:	60ea                	ld	ra,152(sp)
    474c:	644a                	ld	s0,144(sp)
    474e:	64aa                	ld	s1,136(sp)
    4750:	690a                	ld	s2,128(sp)
    4752:	79e6                	ld	s3,120(sp)
    4754:	7a46                	ld	s4,112(sp)
    4756:	7aa6                	ld	s5,104(sp)
    4758:	7b06                	ld	s6,96(sp)
    475a:	6be6                	ld	s7,88(sp)
    475c:	610d                	addi	sp,sp,160
    475e:	8082                	ret

0000000000004760 <bigfile>:
{
    4760:	7139                	addi	sp,sp,-64
    4762:	fc06                	sd	ra,56(sp)
    4764:	f822                	sd	s0,48(sp)
    4766:	f426                	sd	s1,40(sp)
    4768:	f04a                	sd	s2,32(sp)
    476a:	ec4e                	sd	s3,24(sp)
    476c:	e852                	sd	s4,16(sp)
    476e:	e456                	sd	s5,8(sp)
    4770:	0080                	addi	s0,sp,64
    4772:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4774:	00003517          	auipc	a0,0x3
    4778:	0cc50513          	addi	a0,a0,204 # 7840 <statistics+0x1f9e>
    477c:	00001097          	auipc	ra,0x1
    4780:	c5c080e7          	jalr	-932(ra) # 53d8 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4784:	20200593          	li	a1,514
    4788:	00003517          	auipc	a0,0x3
    478c:	0b850513          	addi	a0,a0,184 # 7840 <statistics+0x1f9e>
    4790:	00001097          	auipc	ra,0x1
    4794:	c38080e7          	jalr	-968(ra) # 53c8 <open>
    4798:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    479a:	4481                	li	s1,0
    memset(buf, i, SZ);
    479c:	00007917          	auipc	s2,0x7
    47a0:	06490913          	addi	s2,s2,100 # b800 <buf>
  for(i = 0; i < N; i++){
    47a4:	4a51                	li	s4,20
  if(fd < 0){
    47a6:	0a054063          	bltz	a0,4846 <bigfile+0xe6>
    memset(buf, i, SZ);
    47aa:	25800613          	li	a2,600
    47ae:	85a6                	mv	a1,s1
    47b0:	854a                	mv	a0,s2
    47b2:	00001097          	auipc	ra,0x1
    47b6:	9d2080e7          	jalr	-1582(ra) # 5184 <memset>
    if(write(fd, buf, SZ) != SZ){
    47ba:	25800613          	li	a2,600
    47be:	85ca                	mv	a1,s2
    47c0:	854e                	mv	a0,s3
    47c2:	00001097          	auipc	ra,0x1
    47c6:	be6080e7          	jalr	-1050(ra) # 53a8 <write>
    47ca:	25800793          	li	a5,600
    47ce:	08f51a63          	bne	a0,a5,4862 <bigfile+0x102>
  for(i = 0; i < N; i++){
    47d2:	2485                	addiw	s1,s1,1
    47d4:	fd449be3          	bne	s1,s4,47aa <bigfile+0x4a>
  close(fd);
    47d8:	854e                	mv	a0,s3
    47da:	00001097          	auipc	ra,0x1
    47de:	bd6080e7          	jalr	-1066(ra) # 53b0 <close>
  fd = open("bigfile.dat", 0);
    47e2:	4581                	li	a1,0
    47e4:	00003517          	auipc	a0,0x3
    47e8:	05c50513          	addi	a0,a0,92 # 7840 <statistics+0x1f9e>
    47ec:	00001097          	auipc	ra,0x1
    47f0:	bdc080e7          	jalr	-1060(ra) # 53c8 <open>
    47f4:	8a2a                	mv	s4,a0
  total = 0;
    47f6:	4981                	li	s3,0
  for(i = 0; ; i++){
    47f8:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    47fa:	00007917          	auipc	s2,0x7
    47fe:	00690913          	addi	s2,s2,6 # b800 <buf>
  if(fd < 0){
    4802:	06054e63          	bltz	a0,487e <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4806:	12c00613          	li	a2,300
    480a:	85ca                	mv	a1,s2
    480c:	8552                	mv	a0,s4
    480e:	00001097          	auipc	ra,0x1
    4812:	b92080e7          	jalr	-1134(ra) # 53a0 <read>
    if(cc < 0){
    4816:	08054263          	bltz	a0,489a <bigfile+0x13a>
    if(cc == 0)
    481a:	c971                	beqz	a0,48ee <bigfile+0x18e>
    if(cc != SZ/2){
    481c:	12c00793          	li	a5,300
    4820:	08f51b63          	bne	a0,a5,48b6 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4824:	01f4d79b          	srliw	a5,s1,0x1f
    4828:	9fa5                	addw	a5,a5,s1
    482a:	4017d79b          	sraiw	a5,a5,0x1
    482e:	00094703          	lbu	a4,0(s2)
    4832:	0af71063          	bne	a4,a5,48d2 <bigfile+0x172>
    4836:	12b94703          	lbu	a4,299(s2)
    483a:	08f71c63          	bne	a4,a5,48d2 <bigfile+0x172>
    total += cc;
    483e:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4842:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4844:	b7c9                	j	4806 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4846:	85d6                	mv	a1,s5
    4848:	00003517          	auipc	a0,0x3
    484c:	00850513          	addi	a0,a0,8 # 7850 <statistics+0x1fae>
    4850:	00001097          	auipc	ra,0x1
    4854:	eb0080e7          	jalr	-336(ra) # 5700 <printf>
    exit(1);
    4858:	4505                	li	a0,1
    485a:	00001097          	auipc	ra,0x1
    485e:	b2e080e7          	jalr	-1234(ra) # 5388 <exit>
      printf("%s: write bigfile failed\n", s);
    4862:	85d6                	mv	a1,s5
    4864:	00003517          	auipc	a0,0x3
    4868:	00c50513          	addi	a0,a0,12 # 7870 <statistics+0x1fce>
    486c:	00001097          	auipc	ra,0x1
    4870:	e94080e7          	jalr	-364(ra) # 5700 <printf>
      exit(1);
    4874:	4505                	li	a0,1
    4876:	00001097          	auipc	ra,0x1
    487a:	b12080e7          	jalr	-1262(ra) # 5388 <exit>
    printf("%s: cannot open bigfile\n", s);
    487e:	85d6                	mv	a1,s5
    4880:	00003517          	auipc	a0,0x3
    4884:	01050513          	addi	a0,a0,16 # 7890 <statistics+0x1fee>
    4888:	00001097          	auipc	ra,0x1
    488c:	e78080e7          	jalr	-392(ra) # 5700 <printf>
    exit(1);
    4890:	4505                	li	a0,1
    4892:	00001097          	auipc	ra,0x1
    4896:	af6080e7          	jalr	-1290(ra) # 5388 <exit>
      printf("%s: read bigfile failed\n", s);
    489a:	85d6                	mv	a1,s5
    489c:	00003517          	auipc	a0,0x3
    48a0:	01450513          	addi	a0,a0,20 # 78b0 <statistics+0x200e>
    48a4:	00001097          	auipc	ra,0x1
    48a8:	e5c080e7          	jalr	-420(ra) # 5700 <printf>
      exit(1);
    48ac:	4505                	li	a0,1
    48ae:	00001097          	auipc	ra,0x1
    48b2:	ada080e7          	jalr	-1318(ra) # 5388 <exit>
      printf("%s: short read bigfile\n", s);
    48b6:	85d6                	mv	a1,s5
    48b8:	00003517          	auipc	a0,0x3
    48bc:	01850513          	addi	a0,a0,24 # 78d0 <statistics+0x202e>
    48c0:	00001097          	auipc	ra,0x1
    48c4:	e40080e7          	jalr	-448(ra) # 5700 <printf>
      exit(1);
    48c8:	4505                	li	a0,1
    48ca:	00001097          	auipc	ra,0x1
    48ce:	abe080e7          	jalr	-1346(ra) # 5388 <exit>
      printf("%s: read bigfile wrong data\n", s);
    48d2:	85d6                	mv	a1,s5
    48d4:	00003517          	auipc	a0,0x3
    48d8:	01450513          	addi	a0,a0,20 # 78e8 <statistics+0x2046>
    48dc:	00001097          	auipc	ra,0x1
    48e0:	e24080e7          	jalr	-476(ra) # 5700 <printf>
      exit(1);
    48e4:	4505                	li	a0,1
    48e6:	00001097          	auipc	ra,0x1
    48ea:	aa2080e7          	jalr	-1374(ra) # 5388 <exit>
  close(fd);
    48ee:	8552                	mv	a0,s4
    48f0:	00001097          	auipc	ra,0x1
    48f4:	ac0080e7          	jalr	-1344(ra) # 53b0 <close>
  if(total != N*SZ){
    48f8:	678d                	lui	a5,0x3
    48fa:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x1f4>
    48fe:	02f99363          	bne	s3,a5,4924 <bigfile+0x1c4>
  unlink("bigfile.dat");
    4902:	00003517          	auipc	a0,0x3
    4906:	f3e50513          	addi	a0,a0,-194 # 7840 <statistics+0x1f9e>
    490a:	00001097          	auipc	ra,0x1
    490e:	ace080e7          	jalr	-1330(ra) # 53d8 <unlink>
}
    4912:	70e2                	ld	ra,56(sp)
    4914:	7442                	ld	s0,48(sp)
    4916:	74a2                	ld	s1,40(sp)
    4918:	7902                	ld	s2,32(sp)
    491a:	69e2                	ld	s3,24(sp)
    491c:	6a42                	ld	s4,16(sp)
    491e:	6aa2                	ld	s5,8(sp)
    4920:	6121                	addi	sp,sp,64
    4922:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4924:	85d6                	mv	a1,s5
    4926:	00003517          	auipc	a0,0x3
    492a:	fe250513          	addi	a0,a0,-30 # 7908 <statistics+0x2066>
    492e:	00001097          	auipc	ra,0x1
    4932:	dd2080e7          	jalr	-558(ra) # 5700 <printf>
    exit(1);
    4936:	4505                	li	a0,1
    4938:	00001097          	auipc	ra,0x1
    493c:	a50080e7          	jalr	-1456(ra) # 5388 <exit>

0000000000004940 <dirtest>:
{
    4940:	1101                	addi	sp,sp,-32
    4942:	ec06                	sd	ra,24(sp)
    4944:	e822                	sd	s0,16(sp)
    4946:	e426                	sd	s1,8(sp)
    4948:	1000                	addi	s0,sp,32
    494a:	84aa                	mv	s1,a0
  printf("mkdir test\n");
    494c:	00003517          	auipc	a0,0x3
    4950:	fdc50513          	addi	a0,a0,-36 # 7928 <statistics+0x2086>
    4954:	00001097          	auipc	ra,0x1
    4958:	dac080e7          	jalr	-596(ra) # 5700 <printf>
  if(mkdir("dir0") < 0){
    495c:	00003517          	auipc	a0,0x3
    4960:	fdc50513          	addi	a0,a0,-36 # 7938 <statistics+0x2096>
    4964:	00001097          	auipc	ra,0x1
    4968:	a8c080e7          	jalr	-1396(ra) # 53f0 <mkdir>
    496c:	04054d63          	bltz	a0,49c6 <dirtest+0x86>
  if(chdir("dir0") < 0){
    4970:	00003517          	auipc	a0,0x3
    4974:	fc850513          	addi	a0,a0,-56 # 7938 <statistics+0x2096>
    4978:	00001097          	auipc	ra,0x1
    497c:	a80080e7          	jalr	-1408(ra) # 53f8 <chdir>
    4980:	06054163          	bltz	a0,49e2 <dirtest+0xa2>
  if(chdir("..") < 0){
    4984:	00003517          	auipc	a0,0x3
    4988:	a0c50513          	addi	a0,a0,-1524 # 7390 <statistics+0x1aee>
    498c:	00001097          	auipc	ra,0x1
    4990:	a6c080e7          	jalr	-1428(ra) # 53f8 <chdir>
    4994:	06054563          	bltz	a0,49fe <dirtest+0xbe>
  if(unlink("dir0") < 0){
    4998:	00003517          	auipc	a0,0x3
    499c:	fa050513          	addi	a0,a0,-96 # 7938 <statistics+0x2096>
    49a0:	00001097          	auipc	ra,0x1
    49a4:	a38080e7          	jalr	-1480(ra) # 53d8 <unlink>
    49a8:	06054963          	bltz	a0,4a1a <dirtest+0xda>
  printf("%s: mkdir test ok\n");
    49ac:	00003517          	auipc	a0,0x3
    49b0:	fdc50513          	addi	a0,a0,-36 # 7988 <statistics+0x20e6>
    49b4:	00001097          	auipc	ra,0x1
    49b8:	d4c080e7          	jalr	-692(ra) # 5700 <printf>
}
    49bc:	60e2                	ld	ra,24(sp)
    49be:	6442                	ld	s0,16(sp)
    49c0:	64a2                	ld	s1,8(sp)
    49c2:	6105                	addi	sp,sp,32
    49c4:	8082                	ret
    printf("%s: mkdir failed\n", s);
    49c6:	85a6                	mv	a1,s1
    49c8:	00002517          	auipc	a0,0x2
    49cc:	36850513          	addi	a0,a0,872 # 6d30 <statistics+0x148e>
    49d0:	00001097          	auipc	ra,0x1
    49d4:	d30080e7          	jalr	-720(ra) # 5700 <printf>
    exit(1);
    49d8:	4505                	li	a0,1
    49da:	00001097          	auipc	ra,0x1
    49de:	9ae080e7          	jalr	-1618(ra) # 5388 <exit>
    printf("%s: chdir dir0 failed\n", s);
    49e2:	85a6                	mv	a1,s1
    49e4:	00003517          	auipc	a0,0x3
    49e8:	f5c50513          	addi	a0,a0,-164 # 7940 <statistics+0x209e>
    49ec:	00001097          	auipc	ra,0x1
    49f0:	d14080e7          	jalr	-748(ra) # 5700 <printf>
    exit(1);
    49f4:	4505                	li	a0,1
    49f6:	00001097          	auipc	ra,0x1
    49fa:	992080e7          	jalr	-1646(ra) # 5388 <exit>
    printf("%s: chdir .. failed\n", s);
    49fe:	85a6                	mv	a1,s1
    4a00:	00003517          	auipc	a0,0x3
    4a04:	f5850513          	addi	a0,a0,-168 # 7958 <statistics+0x20b6>
    4a08:	00001097          	auipc	ra,0x1
    4a0c:	cf8080e7          	jalr	-776(ra) # 5700 <printf>
    exit(1);
    4a10:	4505                	li	a0,1
    4a12:	00001097          	auipc	ra,0x1
    4a16:	976080e7          	jalr	-1674(ra) # 5388 <exit>
    printf("%s: unlink dir0 failed\n", s);
    4a1a:	85a6                	mv	a1,s1
    4a1c:	00003517          	auipc	a0,0x3
    4a20:	f5450513          	addi	a0,a0,-172 # 7970 <statistics+0x20ce>
    4a24:	00001097          	auipc	ra,0x1
    4a28:	cdc080e7          	jalr	-804(ra) # 5700 <printf>
    exit(1);
    4a2c:	4505                	li	a0,1
    4a2e:	00001097          	auipc	ra,0x1
    4a32:	95a080e7          	jalr	-1702(ra) # 5388 <exit>

0000000000004a36 <fsfull>:
{
    4a36:	7171                	addi	sp,sp,-176
    4a38:	f506                	sd	ra,168(sp)
    4a3a:	f122                	sd	s0,160(sp)
    4a3c:	ed26                	sd	s1,152(sp)
    4a3e:	e94a                	sd	s2,144(sp)
    4a40:	e54e                	sd	s3,136(sp)
    4a42:	e152                	sd	s4,128(sp)
    4a44:	fcd6                	sd	s5,120(sp)
    4a46:	f8da                	sd	s6,112(sp)
    4a48:	f4de                	sd	s7,104(sp)
    4a4a:	f0e2                	sd	s8,96(sp)
    4a4c:	ece6                	sd	s9,88(sp)
    4a4e:	e8ea                	sd	s10,80(sp)
    4a50:	e4ee                	sd	s11,72(sp)
    4a52:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4a54:	00003517          	auipc	a0,0x3
    4a58:	f4c50513          	addi	a0,a0,-180 # 79a0 <statistics+0x20fe>
    4a5c:	00001097          	auipc	ra,0x1
    4a60:	ca4080e7          	jalr	-860(ra) # 5700 <printf>
  for(nfiles = 0; ; nfiles++){
    4a64:	4481                	li	s1,0
    name[0] = 'f';
    4a66:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4a6a:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4a6e:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4a72:	4b29                	li	s6,10
    printf("%s: writing %s\n", name);
    4a74:	00003c97          	auipc	s9,0x3
    4a78:	f3cc8c93          	addi	s9,s9,-196 # 79b0 <statistics+0x210e>
    int total = 0;
    4a7c:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4a7e:	00007a17          	auipc	s4,0x7
    4a82:	d82a0a13          	addi	s4,s4,-638 # b800 <buf>
    name[0] = 'f';
    4a86:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4a8a:	0384c7bb          	divw	a5,s1,s8
    4a8e:	0307879b          	addiw	a5,a5,48
    4a92:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4a96:	0384e7bb          	remw	a5,s1,s8
    4a9a:	0377c7bb          	divw	a5,a5,s7
    4a9e:	0307879b          	addiw	a5,a5,48
    4aa2:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4aa6:	0374e7bb          	remw	a5,s1,s7
    4aaa:	0367c7bb          	divw	a5,a5,s6
    4aae:	0307879b          	addiw	a5,a5,48
    4ab2:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4ab6:	0364e7bb          	remw	a5,s1,s6
    4aba:	0307879b          	addiw	a5,a5,48
    4abe:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4ac2:	f4040aa3          	sb	zero,-171(s0)
    printf("%s: writing %s\n", name);
    4ac6:	f5040593          	addi	a1,s0,-176
    4aca:	8566                	mv	a0,s9
    4acc:	00001097          	auipc	ra,0x1
    4ad0:	c34080e7          	jalr	-972(ra) # 5700 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4ad4:	20200593          	li	a1,514
    4ad8:	f5040513          	addi	a0,s0,-176
    4adc:	00001097          	auipc	ra,0x1
    4ae0:	8ec080e7          	jalr	-1812(ra) # 53c8 <open>
    4ae4:	892a                	mv	s2,a0
    if(fd < 0){
    4ae6:	0a055663          	bgez	a0,4b92 <fsfull+0x15c>
      printf("%s: open %s failed\n", name);
    4aea:	f5040593          	addi	a1,s0,-176
    4aee:	00003517          	auipc	a0,0x3
    4af2:	ed250513          	addi	a0,a0,-302 # 79c0 <statistics+0x211e>
    4af6:	00001097          	auipc	ra,0x1
    4afa:	c0a080e7          	jalr	-1014(ra) # 5700 <printf>
  while(nfiles >= 0){
    4afe:	0604c363          	bltz	s1,4b64 <fsfull+0x12e>
    name[0] = 'f';
    4b02:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4b06:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4b0a:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4b0e:	4929                	li	s2,10
  while(nfiles >= 0){
    4b10:	5afd                	li	s5,-1
    name[0] = 'f';
    4b12:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4b16:	0344c7bb          	divw	a5,s1,s4
    4b1a:	0307879b          	addiw	a5,a5,48
    4b1e:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4b22:	0344e7bb          	remw	a5,s1,s4
    4b26:	0337c7bb          	divw	a5,a5,s3
    4b2a:	0307879b          	addiw	a5,a5,48
    4b2e:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4b32:	0334e7bb          	remw	a5,s1,s3
    4b36:	0327c7bb          	divw	a5,a5,s2
    4b3a:	0307879b          	addiw	a5,a5,48
    4b3e:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4b42:	0324e7bb          	remw	a5,s1,s2
    4b46:	0307879b          	addiw	a5,a5,48
    4b4a:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4b4e:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4b52:	f5040513          	addi	a0,s0,-176
    4b56:	00001097          	auipc	ra,0x1
    4b5a:	882080e7          	jalr	-1918(ra) # 53d8 <unlink>
    nfiles--;
    4b5e:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4b60:	fb5499e3          	bne	s1,s5,4b12 <fsfull+0xdc>
  printf("fsfull test finished\n");
    4b64:	00003517          	auipc	a0,0x3
    4b68:	e8c50513          	addi	a0,a0,-372 # 79f0 <statistics+0x214e>
    4b6c:	00001097          	auipc	ra,0x1
    4b70:	b94080e7          	jalr	-1132(ra) # 5700 <printf>
}
    4b74:	70aa                	ld	ra,168(sp)
    4b76:	740a                	ld	s0,160(sp)
    4b78:	64ea                	ld	s1,152(sp)
    4b7a:	694a                	ld	s2,144(sp)
    4b7c:	69aa                	ld	s3,136(sp)
    4b7e:	6a0a                	ld	s4,128(sp)
    4b80:	7ae6                	ld	s5,120(sp)
    4b82:	7b46                	ld	s6,112(sp)
    4b84:	7ba6                	ld	s7,104(sp)
    4b86:	7c06                	ld	s8,96(sp)
    4b88:	6ce6                	ld	s9,88(sp)
    4b8a:	6d46                	ld	s10,80(sp)
    4b8c:	6da6                	ld	s11,72(sp)
    4b8e:	614d                	addi	sp,sp,176
    4b90:	8082                	ret
    int total = 0;
    4b92:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4b94:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4b98:	40000613          	li	a2,1024
    4b9c:	85d2                	mv	a1,s4
    4b9e:	854a                	mv	a0,s2
    4ba0:	00001097          	auipc	ra,0x1
    4ba4:	808080e7          	jalr	-2040(ra) # 53a8 <write>
      if(cc < BSIZE)
    4ba8:	00aad563          	bge	s5,a0,4bb2 <fsfull+0x17c>
      total += cc;
    4bac:	00a989bb          	addw	s3,s3,a0
    while(1){
    4bb0:	b7e5                	j	4b98 <fsfull+0x162>
    printf("%s: wrote %d bytes\n", total);
    4bb2:	85ce                	mv	a1,s3
    4bb4:	00003517          	auipc	a0,0x3
    4bb8:	e2450513          	addi	a0,a0,-476 # 79d8 <statistics+0x2136>
    4bbc:	00001097          	auipc	ra,0x1
    4bc0:	b44080e7          	jalr	-1212(ra) # 5700 <printf>
    close(fd);
    4bc4:	854a                	mv	a0,s2
    4bc6:	00000097          	auipc	ra,0x0
    4bca:	7ea080e7          	jalr	2026(ra) # 53b0 <close>
    if(total == 0)
    4bce:	f20988e3          	beqz	s3,4afe <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4bd2:	2485                	addiw	s1,s1,1
    4bd4:	bd4d                	j	4a86 <fsfull+0x50>

0000000000004bd6 <rand>:
{
    4bd6:	1141                	addi	sp,sp,-16
    4bd8:	e422                	sd	s0,8(sp)
    4bda:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4bdc:	00003717          	auipc	a4,0x3
    4be0:	3f470713          	addi	a4,a4,1012 # 7fd0 <randstate>
    4be4:	6308                	ld	a0,0(a4)
    4be6:	001967b7          	lui	a5,0x196
    4bea:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x187dfd>
    4bee:	02f50533          	mul	a0,a0,a5
    4bf2:	3c6ef7b7          	lui	a5,0x3c6ef
    4bf6:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e0b4f>
    4bfa:	953e                	add	a0,a0,a5
    4bfc:	e308                	sd	a0,0(a4)
}
    4bfe:	2501                	sext.w	a0,a0
    4c00:	6422                	ld	s0,8(sp)
    4c02:	0141                	addi	sp,sp,16
    4c04:	8082                	ret

0000000000004c06 <badwrite>:
{
    4c06:	7179                	addi	sp,sp,-48
    4c08:	f406                	sd	ra,40(sp)
    4c0a:	f022                	sd	s0,32(sp)
    4c0c:	ec26                	sd	s1,24(sp)
    4c0e:	e84a                	sd	s2,16(sp)
    4c10:	e44e                	sd	s3,8(sp)
    4c12:	e052                	sd	s4,0(sp)
    4c14:	1800                	addi	s0,sp,48
  unlink("junk");
    4c16:	00003517          	auipc	a0,0x3
    4c1a:	df250513          	addi	a0,a0,-526 # 7a08 <statistics+0x2166>
    4c1e:	00000097          	auipc	ra,0x0
    4c22:	7ba080e7          	jalr	1978(ra) # 53d8 <unlink>
    4c26:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4c2a:	00003997          	auipc	s3,0x3
    4c2e:	dde98993          	addi	s3,s3,-546 # 7a08 <statistics+0x2166>
    write(fd, (char*)0xffffffffffL, 1);
    4c32:	5a7d                	li	s4,-1
    4c34:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4c38:	20100593          	li	a1,513
    4c3c:	854e                	mv	a0,s3
    4c3e:	00000097          	auipc	ra,0x0
    4c42:	78a080e7          	jalr	1930(ra) # 53c8 <open>
    4c46:	84aa                	mv	s1,a0
    if(fd < 0){
    4c48:	06054b63          	bltz	a0,4cbe <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4c4c:	4605                	li	a2,1
    4c4e:	85d2                	mv	a1,s4
    4c50:	00000097          	auipc	ra,0x0
    4c54:	758080e7          	jalr	1880(ra) # 53a8 <write>
    close(fd);
    4c58:	8526                	mv	a0,s1
    4c5a:	00000097          	auipc	ra,0x0
    4c5e:	756080e7          	jalr	1878(ra) # 53b0 <close>
    unlink("junk");
    4c62:	854e                	mv	a0,s3
    4c64:	00000097          	auipc	ra,0x0
    4c68:	774080e7          	jalr	1908(ra) # 53d8 <unlink>
  for(int i = 0; i < assumed_free; i++){
    4c6c:	397d                	addiw	s2,s2,-1
    4c6e:	fc0915e3          	bnez	s2,4c38 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4c72:	20100593          	li	a1,513
    4c76:	00003517          	auipc	a0,0x3
    4c7a:	d9250513          	addi	a0,a0,-622 # 7a08 <statistics+0x2166>
    4c7e:	00000097          	auipc	ra,0x0
    4c82:	74a080e7          	jalr	1866(ra) # 53c8 <open>
    4c86:	84aa                	mv	s1,a0
  if(fd < 0){
    4c88:	04054863          	bltz	a0,4cd8 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4c8c:	4605                	li	a2,1
    4c8e:	00001597          	auipc	a1,0x1
    4c92:	04258593          	addi	a1,a1,66 # 5cd0 <statistics+0x42e>
    4c96:	00000097          	auipc	ra,0x0
    4c9a:	712080e7          	jalr	1810(ra) # 53a8 <write>
    4c9e:	4785                	li	a5,1
    4ca0:	04f50963          	beq	a0,a5,4cf2 <badwrite+0xec>
    printf("write failed\n");
    4ca4:	00003517          	auipc	a0,0x3
    4ca8:	d8450513          	addi	a0,a0,-636 # 7a28 <statistics+0x2186>
    4cac:	00001097          	auipc	ra,0x1
    4cb0:	a54080e7          	jalr	-1452(ra) # 5700 <printf>
    exit(1);
    4cb4:	4505                	li	a0,1
    4cb6:	00000097          	auipc	ra,0x0
    4cba:	6d2080e7          	jalr	1746(ra) # 5388 <exit>
      printf("open junk failed\n");
    4cbe:	00003517          	auipc	a0,0x3
    4cc2:	d5250513          	addi	a0,a0,-686 # 7a10 <statistics+0x216e>
    4cc6:	00001097          	auipc	ra,0x1
    4cca:	a3a080e7          	jalr	-1478(ra) # 5700 <printf>
      exit(1);
    4cce:	4505                	li	a0,1
    4cd0:	00000097          	auipc	ra,0x0
    4cd4:	6b8080e7          	jalr	1720(ra) # 5388 <exit>
    printf("open junk failed\n");
    4cd8:	00003517          	auipc	a0,0x3
    4cdc:	d3850513          	addi	a0,a0,-712 # 7a10 <statistics+0x216e>
    4ce0:	00001097          	auipc	ra,0x1
    4ce4:	a20080e7          	jalr	-1504(ra) # 5700 <printf>
    exit(1);
    4ce8:	4505                	li	a0,1
    4cea:	00000097          	auipc	ra,0x0
    4cee:	69e080e7          	jalr	1694(ra) # 5388 <exit>
  close(fd);
    4cf2:	8526                	mv	a0,s1
    4cf4:	00000097          	auipc	ra,0x0
    4cf8:	6bc080e7          	jalr	1724(ra) # 53b0 <close>
  unlink("junk");
    4cfc:	00003517          	auipc	a0,0x3
    4d00:	d0c50513          	addi	a0,a0,-756 # 7a08 <statistics+0x2166>
    4d04:	00000097          	auipc	ra,0x0
    4d08:	6d4080e7          	jalr	1748(ra) # 53d8 <unlink>
  exit(0);
    4d0c:	4501                	li	a0,0
    4d0e:	00000097          	auipc	ra,0x0
    4d12:	67a080e7          	jalr	1658(ra) # 5388 <exit>

0000000000004d16 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    4d16:	7139                	addi	sp,sp,-64
    4d18:	fc06                	sd	ra,56(sp)
    4d1a:	f822                	sd	s0,48(sp)
    4d1c:	f426                	sd	s1,40(sp)
    4d1e:	f04a                	sd	s2,32(sp)
    4d20:	ec4e                	sd	s3,24(sp)
    4d22:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    4d24:	fc840513          	addi	a0,s0,-56
    4d28:	00000097          	auipc	ra,0x0
    4d2c:	670080e7          	jalr	1648(ra) # 5398 <pipe>
    4d30:	06054863          	bltz	a0,4da0 <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    4d34:	00000097          	auipc	ra,0x0
    4d38:	64c080e7          	jalr	1612(ra) # 5380 <fork>

  if(pid < 0){
    4d3c:	06054f63          	bltz	a0,4dba <countfree+0xa4>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4d40:	ed59                	bnez	a0,4dde <countfree+0xc8>
    close(fds[0]);
    4d42:	fc842503          	lw	a0,-56(s0)
    4d46:	00000097          	auipc	ra,0x0
    4d4a:	66a080e7          	jalr	1642(ra) # 53b0 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    4d4e:	54fd                	li	s1,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4d50:	4985                	li	s3,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    4d52:	00001917          	auipc	s2,0x1
    4d56:	f7e90913          	addi	s2,s2,-130 # 5cd0 <statistics+0x42e>
      uint64 a = (uint64) sbrk(4096);
    4d5a:	6505                	lui	a0,0x1
    4d5c:	00000097          	auipc	ra,0x0
    4d60:	6b4080e7          	jalr	1716(ra) # 5410 <sbrk>
      if(a == 0xffffffffffffffff){
    4d64:	06950863          	beq	a0,s1,4dd4 <countfree+0xbe>
      *(char *)(a + 4096 - 1) = 1;
    4d68:	6785                	lui	a5,0x1
    4d6a:	953e                	add	a0,a0,a5
    4d6c:	ff350fa3          	sb	s3,-1(a0) # fff <bigdir+0x95>
      if(write(fds[1], "x", 1) != 1){
    4d70:	4605                	li	a2,1
    4d72:	85ca                	mv	a1,s2
    4d74:	fcc42503          	lw	a0,-52(s0)
    4d78:	00000097          	auipc	ra,0x0
    4d7c:	630080e7          	jalr	1584(ra) # 53a8 <write>
    4d80:	4785                	li	a5,1
    4d82:	fcf50ce3          	beq	a0,a5,4d5a <countfree+0x44>
        printf("write() failed in countfree()\n");
    4d86:	00003517          	auipc	a0,0x3
    4d8a:	cf250513          	addi	a0,a0,-782 # 7a78 <statistics+0x21d6>
    4d8e:	00001097          	auipc	ra,0x1
    4d92:	972080e7          	jalr	-1678(ra) # 5700 <printf>
        exit(1);
    4d96:	4505                	li	a0,1
    4d98:	00000097          	auipc	ra,0x0
    4d9c:	5f0080e7          	jalr	1520(ra) # 5388 <exit>
    printf("pipe() failed in countfree()\n");
    4da0:	00003517          	auipc	a0,0x3
    4da4:	c9850513          	addi	a0,a0,-872 # 7a38 <statistics+0x2196>
    4da8:	00001097          	auipc	ra,0x1
    4dac:	958080e7          	jalr	-1704(ra) # 5700 <printf>
    exit(1);
    4db0:	4505                	li	a0,1
    4db2:	00000097          	auipc	ra,0x0
    4db6:	5d6080e7          	jalr	1494(ra) # 5388 <exit>
    printf("fork failed in countfree()\n");
    4dba:	00003517          	auipc	a0,0x3
    4dbe:	c9e50513          	addi	a0,a0,-866 # 7a58 <statistics+0x21b6>
    4dc2:	00001097          	auipc	ra,0x1
    4dc6:	93e080e7          	jalr	-1730(ra) # 5700 <printf>
    exit(1);
    4dca:	4505                	li	a0,1
    4dcc:	00000097          	auipc	ra,0x0
    4dd0:	5bc080e7          	jalr	1468(ra) # 5388 <exit>
      }
    }

    exit(0);
    4dd4:	4501                	li	a0,0
    4dd6:	00000097          	auipc	ra,0x0
    4dda:	5b2080e7          	jalr	1458(ra) # 5388 <exit>
  }

  close(fds[1]);
    4dde:	fcc42503          	lw	a0,-52(s0)
    4de2:	00000097          	auipc	ra,0x0
    4de6:	5ce080e7          	jalr	1486(ra) # 53b0 <close>

  int n = 0;
    4dea:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    4dec:	4605                	li	a2,1
    4dee:	fc740593          	addi	a1,s0,-57
    4df2:	fc842503          	lw	a0,-56(s0)
    4df6:	00000097          	auipc	ra,0x0
    4dfa:	5aa080e7          	jalr	1450(ra) # 53a0 <read>
    if(cc < 0){
    4dfe:	00054563          	bltz	a0,4e08 <countfree+0xf2>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    4e02:	c105                	beqz	a0,4e22 <countfree+0x10c>
      break;
    n += 1;
    4e04:	2485                	addiw	s1,s1,1
  while(1){
    4e06:	b7dd                	j	4dec <countfree+0xd6>
      printf("read() failed in countfree()\n");
    4e08:	00003517          	auipc	a0,0x3
    4e0c:	c9050513          	addi	a0,a0,-880 # 7a98 <statistics+0x21f6>
    4e10:	00001097          	auipc	ra,0x1
    4e14:	8f0080e7          	jalr	-1808(ra) # 5700 <printf>
      exit(1);
    4e18:	4505                	li	a0,1
    4e1a:	00000097          	auipc	ra,0x0
    4e1e:	56e080e7          	jalr	1390(ra) # 5388 <exit>
  }

  close(fds[0]);
    4e22:	fc842503          	lw	a0,-56(s0)
    4e26:	00000097          	auipc	ra,0x0
    4e2a:	58a080e7          	jalr	1418(ra) # 53b0 <close>
  wait((int*)0);
    4e2e:	4501                	li	a0,0
    4e30:	00000097          	auipc	ra,0x0
    4e34:	560080e7          	jalr	1376(ra) # 5390 <wait>
  
  return n;
}
    4e38:	8526                	mv	a0,s1
    4e3a:	70e2                	ld	ra,56(sp)
    4e3c:	7442                	ld	s0,48(sp)
    4e3e:	74a2                	ld	s1,40(sp)
    4e40:	7902                	ld	s2,32(sp)
    4e42:	69e2                	ld	s3,24(sp)
    4e44:	6121                	addi	sp,sp,64
    4e46:	8082                	ret

0000000000004e48 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4e48:	7179                	addi	sp,sp,-48
    4e4a:	f406                	sd	ra,40(sp)
    4e4c:	f022                	sd	s0,32(sp)
    4e4e:	ec26                	sd	s1,24(sp)
    4e50:	e84a                	sd	s2,16(sp)
    4e52:	1800                	addi	s0,sp,48
    4e54:	84aa                	mv	s1,a0
    4e56:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4e58:	00003517          	auipc	a0,0x3
    4e5c:	c6050513          	addi	a0,a0,-928 # 7ab8 <statistics+0x2216>
    4e60:	00001097          	auipc	ra,0x1
    4e64:	8a0080e7          	jalr	-1888(ra) # 5700 <printf>
  if((pid = fork()) < 0) {
    4e68:	00000097          	auipc	ra,0x0
    4e6c:	518080e7          	jalr	1304(ra) # 5380 <fork>
    4e70:	02054e63          	bltz	a0,4eac <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4e74:	c929                	beqz	a0,4ec6 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4e76:	fdc40513          	addi	a0,s0,-36
    4e7a:	00000097          	auipc	ra,0x0
    4e7e:	516080e7          	jalr	1302(ra) # 5390 <wait>
    if(xstatus != 0) 
    4e82:	fdc42783          	lw	a5,-36(s0)
    4e86:	c7b9                	beqz	a5,4ed4 <run+0x8c>
      printf("FAILED\n");
    4e88:	00003517          	auipc	a0,0x3
    4e8c:	c5850513          	addi	a0,a0,-936 # 7ae0 <statistics+0x223e>
    4e90:	00001097          	auipc	ra,0x1
    4e94:	870080e7          	jalr	-1936(ra) # 5700 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4e98:	fdc42503          	lw	a0,-36(s0)
  }
}
    4e9c:	00153513          	seqz	a0,a0
    4ea0:	70a2                	ld	ra,40(sp)
    4ea2:	7402                	ld	s0,32(sp)
    4ea4:	64e2                	ld	s1,24(sp)
    4ea6:	6942                	ld	s2,16(sp)
    4ea8:	6145                	addi	sp,sp,48
    4eaa:	8082                	ret
    printf("runtest: fork error\n");
    4eac:	00003517          	auipc	a0,0x3
    4eb0:	c1c50513          	addi	a0,a0,-996 # 7ac8 <statistics+0x2226>
    4eb4:	00001097          	auipc	ra,0x1
    4eb8:	84c080e7          	jalr	-1972(ra) # 5700 <printf>
    exit(1);
    4ebc:	4505                	li	a0,1
    4ebe:	00000097          	auipc	ra,0x0
    4ec2:	4ca080e7          	jalr	1226(ra) # 5388 <exit>
    f(s);
    4ec6:	854a                	mv	a0,s2
    4ec8:	9482                	jalr	s1
    exit(0);
    4eca:	4501                	li	a0,0
    4ecc:	00000097          	auipc	ra,0x0
    4ed0:	4bc080e7          	jalr	1212(ra) # 5388 <exit>
      printf("OK\n");
    4ed4:	00003517          	auipc	a0,0x3
    4ed8:	c1450513          	addi	a0,a0,-1004 # 7ae8 <statistics+0x2246>
    4edc:	00001097          	auipc	ra,0x1
    4ee0:	824080e7          	jalr	-2012(ra) # 5700 <printf>
    4ee4:	bf55                	j	4e98 <run+0x50>

0000000000004ee6 <main>:

int
main(int argc, char *argv[])
{
    4ee6:	c4010113          	addi	sp,sp,-960
    4eea:	3a113c23          	sd	ra,952(sp)
    4eee:	3a813823          	sd	s0,944(sp)
    4ef2:	3a913423          	sd	s1,936(sp)
    4ef6:	3b213023          	sd	s2,928(sp)
    4efa:	39313c23          	sd	s3,920(sp)
    4efe:	39413823          	sd	s4,912(sp)
    4f02:	39513423          	sd	s5,904(sp)
    4f06:	39613023          	sd	s6,896(sp)
    4f0a:	0780                	addi	s0,sp,960
    4f0c:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4f0e:	4789                	li	a5,2
    4f10:	08f50763          	beq	a0,a5,4f9e <main+0xb8>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4f14:	4785                	li	a5,1
  char *justone = 0;
    4f16:	4901                	li	s2,0
  } else if(argc > 1){
    4f18:	0ca7c163          	blt	a5,a0,4fda <main+0xf4>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    4f1c:	00003797          	auipc	a5,0x3
    4f20:	ce478793          	addi	a5,a5,-796 # 7c00 <statistics+0x235e>
    4f24:	c4040713          	addi	a4,s0,-960
    4f28:	00003817          	auipc	a6,0x3
    4f2c:	05880813          	addi	a6,a6,88 # 7f80 <statistics+0x26de>
    4f30:	6388                	ld	a0,0(a5)
    4f32:	678c                	ld	a1,8(a5)
    4f34:	6b90                	ld	a2,16(a5)
    4f36:	6f94                	ld	a3,24(a5)
    4f38:	e308                	sd	a0,0(a4)
    4f3a:	e70c                	sd	a1,8(a4)
    4f3c:	eb10                	sd	a2,16(a4)
    4f3e:	ef14                	sd	a3,24(a4)
    4f40:	02078793          	addi	a5,a5,32
    4f44:	02070713          	addi	a4,a4,32
    4f48:	ff0794e3          	bne	a5,a6,4f30 <main+0x4a>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    4f4c:	00003517          	auipc	a0,0x3
    4f50:	c5450513          	addi	a0,a0,-940 # 7ba0 <statistics+0x22fe>
    4f54:	00000097          	auipc	ra,0x0
    4f58:	7ac080e7          	jalr	1964(ra) # 5700 <printf>
  int free0 = countfree();
    4f5c:	00000097          	auipc	ra,0x0
    4f60:	dba080e7          	jalr	-582(ra) # 4d16 <countfree>
    4f64:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    4f66:	c4843503          	ld	a0,-952(s0)
    4f6a:	c4040493          	addi	s1,s0,-960
  int fail = 0;
    4f6e:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    4f70:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    4f72:	e55d                	bnez	a0,5020 <main+0x13a>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    4f74:	00000097          	auipc	ra,0x0
    4f78:	da2080e7          	jalr	-606(ra) # 4d16 <countfree>
    4f7c:	85aa                	mv	a1,a0
    4f7e:	0f455163          	bge	a0,s4,5060 <main+0x17a>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4f82:	8652                	mv	a2,s4
    4f84:	00003517          	auipc	a0,0x3
    4f88:	bd450513          	addi	a0,a0,-1068 # 7b58 <statistics+0x22b6>
    4f8c:	00000097          	auipc	ra,0x0
    4f90:	774080e7          	jalr	1908(ra) # 5700 <printf>
    exit(1);
    4f94:	4505                	li	a0,1
    4f96:	00000097          	auipc	ra,0x0
    4f9a:	3f2080e7          	jalr	1010(ra) # 5388 <exit>
    4f9e:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4fa0:	00003597          	auipc	a1,0x3
    4fa4:	b5058593          	addi	a1,a1,-1200 # 7af0 <statistics+0x224e>
    4fa8:	6488                	ld	a0,8(s1)
    4faa:	00000097          	auipc	ra,0x0
    4fae:	184080e7          	jalr	388(ra) # 512e <strcmp>
    4fb2:	10050563          	beqz	a0,50bc <main+0x1d6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4fb6:	00003597          	auipc	a1,0x3
    4fba:	c2258593          	addi	a1,a1,-990 # 7bd8 <statistics+0x2336>
    4fbe:	6488                	ld	a0,8(s1)
    4fc0:	00000097          	auipc	ra,0x0
    4fc4:	16e080e7          	jalr	366(ra) # 512e <strcmp>
    4fc8:	c97d                	beqz	a0,50be <main+0x1d8>
  } else if(argc == 2 && argv[1][0] != '-'){
    4fca:	0084b903          	ld	s2,8(s1)
    4fce:	00094703          	lbu	a4,0(s2)
    4fd2:	02d00793          	li	a5,45
    4fd6:	f4f713e3          	bne	a4,a5,4f1c <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    4fda:	00003517          	auipc	a0,0x3
    4fde:	b1e50513          	addi	a0,a0,-1250 # 7af8 <statistics+0x2256>
    4fe2:	00000097          	auipc	ra,0x0
    4fe6:	71e080e7          	jalr	1822(ra) # 5700 <printf>
    exit(1);
    4fea:	4505                	li	a0,1
    4fec:	00000097          	auipc	ra,0x0
    4ff0:	39c080e7          	jalr	924(ra) # 5388 <exit>
          exit(1);
    4ff4:	4505                	li	a0,1
    4ff6:	00000097          	auipc	ra,0x0
    4ffa:	392080e7          	jalr	914(ra) # 5388 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    4ffe:	40a905bb          	subw	a1,s2,a0
    5002:	855a                	mv	a0,s6
    5004:	00000097          	auipc	ra,0x0
    5008:	6fc080e7          	jalr	1788(ra) # 5700 <printf>
        if(continuous != 2)
    500c:	09498463          	beq	s3,s4,5094 <main+0x1ae>
          exit(1);
    5010:	4505                	li	a0,1
    5012:	00000097          	auipc	ra,0x0
    5016:	376080e7          	jalr	886(ra) # 5388 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    501a:	04c1                	addi	s1,s1,16
    501c:	6488                	ld	a0,8(s1)
    501e:	c115                	beqz	a0,5042 <main+0x15c>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5020:	00090863          	beqz	s2,5030 <main+0x14a>
    5024:	85ca                	mv	a1,s2
    5026:	00000097          	auipc	ra,0x0
    502a:	108080e7          	jalr	264(ra) # 512e <strcmp>
    502e:	f575                	bnez	a0,501a <main+0x134>
      if(!run(t->f, t->s))
    5030:	648c                	ld	a1,8(s1)
    5032:	6088                	ld	a0,0(s1)
    5034:	00000097          	auipc	ra,0x0
    5038:	e14080e7          	jalr	-492(ra) # 4e48 <run>
    503c:	fd79                	bnez	a0,501a <main+0x134>
        fail = 1;
    503e:	89d6                	mv	s3,s5
    5040:	bfe9                	j	501a <main+0x134>
  if(fail){
    5042:	f20989e3          	beqz	s3,4f74 <main+0x8e>
    printf("SOME TESTS FAILED\n");
    5046:	00003517          	auipc	a0,0x3
    504a:	afa50513          	addi	a0,a0,-1286 # 7b40 <statistics+0x229e>
    504e:	00000097          	auipc	ra,0x0
    5052:	6b2080e7          	jalr	1714(ra) # 5700 <printf>
    exit(1);
    5056:	4505                	li	a0,1
    5058:	00000097          	auipc	ra,0x0
    505c:	330080e7          	jalr	816(ra) # 5388 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    5060:	00003517          	auipc	a0,0x3
    5064:	b2850513          	addi	a0,a0,-1240 # 7b88 <statistics+0x22e6>
    5068:	00000097          	auipc	ra,0x0
    506c:	698080e7          	jalr	1688(ra) # 5700 <printf>
    exit(0);
    5070:	4501                	li	a0,0
    5072:	00000097          	auipc	ra,0x0
    5076:	316080e7          	jalr	790(ra) # 5388 <exit>
        printf("SOME TESTS FAILED\n");
    507a:	8556                	mv	a0,s5
    507c:	00000097          	auipc	ra,0x0
    5080:	684080e7          	jalr	1668(ra) # 5700 <printf>
        if(continuous != 2)
    5084:	f74998e3          	bne	s3,s4,4ff4 <main+0x10e>
      int free1 = countfree();
    5088:	00000097          	auipc	ra,0x0
    508c:	c8e080e7          	jalr	-882(ra) # 4d16 <countfree>
      if(free1 < free0){
    5090:	f72547e3          	blt	a0,s2,4ffe <main+0x118>
      int free0 = countfree();
    5094:	00000097          	auipc	ra,0x0
    5098:	c82080e7          	jalr	-894(ra) # 4d16 <countfree>
    509c:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    509e:	c4843583          	ld	a1,-952(s0)
    50a2:	d1fd                	beqz	a1,5088 <main+0x1a2>
    50a4:	c4040493          	addi	s1,s0,-960
        if(!run(t->f, t->s)){
    50a8:	6088                	ld	a0,0(s1)
    50aa:	00000097          	auipc	ra,0x0
    50ae:	d9e080e7          	jalr	-610(ra) # 4e48 <run>
    50b2:	d561                	beqz	a0,507a <main+0x194>
      for (struct test *t = tests; t->s != 0; t++) {
    50b4:	04c1                	addi	s1,s1,16
    50b6:	648c                	ld	a1,8(s1)
    50b8:	f9e5                	bnez	a1,50a8 <main+0x1c2>
    50ba:	b7f9                	j	5088 <main+0x1a2>
    continuous = 1;
    50bc:	4985                	li	s3,1
  } tests[] = {
    50be:	00003797          	auipc	a5,0x3
    50c2:	b4278793          	addi	a5,a5,-1214 # 7c00 <statistics+0x235e>
    50c6:	c4040713          	addi	a4,s0,-960
    50ca:	00003817          	auipc	a6,0x3
    50ce:	eb680813          	addi	a6,a6,-330 # 7f80 <statistics+0x26de>
    50d2:	6388                	ld	a0,0(a5)
    50d4:	678c                	ld	a1,8(a5)
    50d6:	6b90                	ld	a2,16(a5)
    50d8:	6f94                	ld	a3,24(a5)
    50da:	e308                	sd	a0,0(a4)
    50dc:	e70c                	sd	a1,8(a4)
    50de:	eb10                	sd	a2,16(a4)
    50e0:	ef14                	sd	a3,24(a4)
    50e2:	02078793          	addi	a5,a5,32
    50e6:	02070713          	addi	a4,a4,32
    50ea:	ff0794e3          	bne	a5,a6,50d2 <main+0x1ec>
    printf("continuous usertests starting\n");
    50ee:	00003517          	auipc	a0,0x3
    50f2:	aca50513          	addi	a0,a0,-1334 # 7bb8 <statistics+0x2316>
    50f6:	00000097          	auipc	ra,0x0
    50fa:	60a080e7          	jalr	1546(ra) # 5700 <printf>
        printf("SOME TESTS FAILED\n");
    50fe:	00003a97          	auipc	s5,0x3
    5102:	a42a8a93          	addi	s5,s5,-1470 # 7b40 <statistics+0x229e>
        if(continuous != 2)
    5106:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5108:	00003b17          	auipc	s6,0x3
    510c:	a18b0b13          	addi	s6,s6,-1512 # 7b20 <statistics+0x227e>
    5110:	b751                	j	5094 <main+0x1ae>

0000000000005112 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    5112:	1141                	addi	sp,sp,-16
    5114:	e422                	sd	s0,8(sp)
    5116:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5118:	87aa                	mv	a5,a0
    511a:	0585                	addi	a1,a1,1
    511c:	0785                	addi	a5,a5,1
    511e:	fff5c703          	lbu	a4,-1(a1)
    5122:	fee78fa3          	sb	a4,-1(a5)
    5126:	fb75                	bnez	a4,511a <strcpy+0x8>
    ;
  return os;
}
    5128:	6422                	ld	s0,8(sp)
    512a:	0141                	addi	sp,sp,16
    512c:	8082                	ret

000000000000512e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    512e:	1141                	addi	sp,sp,-16
    5130:	e422                	sd	s0,8(sp)
    5132:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5134:	00054783          	lbu	a5,0(a0)
    5138:	cb91                	beqz	a5,514c <strcmp+0x1e>
    513a:	0005c703          	lbu	a4,0(a1)
    513e:	00f71763          	bne	a4,a5,514c <strcmp+0x1e>
    p++, q++;
    5142:	0505                	addi	a0,a0,1
    5144:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5146:	00054783          	lbu	a5,0(a0)
    514a:	fbe5                	bnez	a5,513a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    514c:	0005c503          	lbu	a0,0(a1)
}
    5150:	40a7853b          	subw	a0,a5,a0
    5154:	6422                	ld	s0,8(sp)
    5156:	0141                	addi	sp,sp,16
    5158:	8082                	ret

000000000000515a <strlen>:

uint
strlen(const char *s)
{
    515a:	1141                	addi	sp,sp,-16
    515c:	e422                	sd	s0,8(sp)
    515e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5160:	00054783          	lbu	a5,0(a0)
    5164:	cf91                	beqz	a5,5180 <strlen+0x26>
    5166:	0505                	addi	a0,a0,1
    5168:	87aa                	mv	a5,a0
    516a:	4685                	li	a3,1
    516c:	9e89                	subw	a3,a3,a0
    516e:	00f6853b          	addw	a0,a3,a5
    5172:	0785                	addi	a5,a5,1
    5174:	fff7c703          	lbu	a4,-1(a5)
    5178:	fb7d                	bnez	a4,516e <strlen+0x14>
    ;
  return n;
}
    517a:	6422                	ld	s0,8(sp)
    517c:	0141                	addi	sp,sp,16
    517e:	8082                	ret
  for(n = 0; s[n]; n++)
    5180:	4501                	li	a0,0
    5182:	bfe5                	j	517a <strlen+0x20>

0000000000005184 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5184:	1141                	addi	sp,sp,-16
    5186:	e422                	sd	s0,8(sp)
    5188:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    518a:	ce09                	beqz	a2,51a4 <memset+0x20>
    518c:	87aa                	mv	a5,a0
    518e:	fff6071b          	addiw	a4,a2,-1
    5192:	1702                	slli	a4,a4,0x20
    5194:	9301                	srli	a4,a4,0x20
    5196:	0705                	addi	a4,a4,1
    5198:	972a                	add	a4,a4,a0
    cdst[i] = c;
    519a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    519e:	0785                	addi	a5,a5,1
    51a0:	fee79de3          	bne	a5,a4,519a <memset+0x16>
  }
  return dst;
}
    51a4:	6422                	ld	s0,8(sp)
    51a6:	0141                	addi	sp,sp,16
    51a8:	8082                	ret

00000000000051aa <strchr>:

char*
strchr(const char *s, char c)
{
    51aa:	1141                	addi	sp,sp,-16
    51ac:	e422                	sd	s0,8(sp)
    51ae:	0800                	addi	s0,sp,16
  for(; *s; s++)
    51b0:	00054783          	lbu	a5,0(a0)
    51b4:	cb99                	beqz	a5,51ca <strchr+0x20>
    if(*s == c)
    51b6:	00f58763          	beq	a1,a5,51c4 <strchr+0x1a>
  for(; *s; s++)
    51ba:	0505                	addi	a0,a0,1
    51bc:	00054783          	lbu	a5,0(a0)
    51c0:	fbfd                	bnez	a5,51b6 <strchr+0xc>
      return (char*)s;
  return 0;
    51c2:	4501                	li	a0,0
}
    51c4:	6422                	ld	s0,8(sp)
    51c6:	0141                	addi	sp,sp,16
    51c8:	8082                	ret
  return 0;
    51ca:	4501                	li	a0,0
    51cc:	bfe5                	j	51c4 <strchr+0x1a>

00000000000051ce <gets>:

char*
gets(char *buf, int max)
{
    51ce:	711d                	addi	sp,sp,-96
    51d0:	ec86                	sd	ra,88(sp)
    51d2:	e8a2                	sd	s0,80(sp)
    51d4:	e4a6                	sd	s1,72(sp)
    51d6:	e0ca                	sd	s2,64(sp)
    51d8:	fc4e                	sd	s3,56(sp)
    51da:	f852                	sd	s4,48(sp)
    51dc:	f456                	sd	s5,40(sp)
    51de:	f05a                	sd	s6,32(sp)
    51e0:	ec5e                	sd	s7,24(sp)
    51e2:	1080                	addi	s0,sp,96
    51e4:	8baa                	mv	s7,a0
    51e6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    51e8:	892a                	mv	s2,a0
    51ea:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    51ec:	4aa9                	li	s5,10
    51ee:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    51f0:	89a6                	mv	s3,s1
    51f2:	2485                	addiw	s1,s1,1
    51f4:	0344d863          	bge	s1,s4,5224 <gets+0x56>
    cc = read(0, &c, 1);
    51f8:	4605                	li	a2,1
    51fa:	faf40593          	addi	a1,s0,-81
    51fe:	4501                	li	a0,0
    5200:	00000097          	auipc	ra,0x0
    5204:	1a0080e7          	jalr	416(ra) # 53a0 <read>
    if(cc < 1)
    5208:	00a05e63          	blez	a0,5224 <gets+0x56>
    buf[i++] = c;
    520c:	faf44783          	lbu	a5,-81(s0)
    5210:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5214:	01578763          	beq	a5,s5,5222 <gets+0x54>
    5218:	0905                	addi	s2,s2,1
    521a:	fd679be3          	bne	a5,s6,51f0 <gets+0x22>
  for(i=0; i+1 < max; ){
    521e:	89a6                	mv	s3,s1
    5220:	a011                	j	5224 <gets+0x56>
    5222:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5224:	99de                	add	s3,s3,s7
    5226:	00098023          	sb	zero,0(s3)
  return buf;
}
    522a:	855e                	mv	a0,s7
    522c:	60e6                	ld	ra,88(sp)
    522e:	6446                	ld	s0,80(sp)
    5230:	64a6                	ld	s1,72(sp)
    5232:	6906                	ld	s2,64(sp)
    5234:	79e2                	ld	s3,56(sp)
    5236:	7a42                	ld	s4,48(sp)
    5238:	7aa2                	ld	s5,40(sp)
    523a:	7b02                	ld	s6,32(sp)
    523c:	6be2                	ld	s7,24(sp)
    523e:	6125                	addi	sp,sp,96
    5240:	8082                	ret

0000000000005242 <stat>:

int
stat(const char *n, struct stat *st)
{
    5242:	1101                	addi	sp,sp,-32
    5244:	ec06                	sd	ra,24(sp)
    5246:	e822                	sd	s0,16(sp)
    5248:	e426                	sd	s1,8(sp)
    524a:	e04a                	sd	s2,0(sp)
    524c:	1000                	addi	s0,sp,32
    524e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5250:	4581                	li	a1,0
    5252:	00000097          	auipc	ra,0x0
    5256:	176080e7          	jalr	374(ra) # 53c8 <open>
  if(fd < 0)
    525a:	02054563          	bltz	a0,5284 <stat+0x42>
    525e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5260:	85ca                	mv	a1,s2
    5262:	00000097          	auipc	ra,0x0
    5266:	17e080e7          	jalr	382(ra) # 53e0 <fstat>
    526a:	892a                	mv	s2,a0
  close(fd);
    526c:	8526                	mv	a0,s1
    526e:	00000097          	auipc	ra,0x0
    5272:	142080e7          	jalr	322(ra) # 53b0 <close>
  return r;
}
    5276:	854a                	mv	a0,s2
    5278:	60e2                	ld	ra,24(sp)
    527a:	6442                	ld	s0,16(sp)
    527c:	64a2                	ld	s1,8(sp)
    527e:	6902                	ld	s2,0(sp)
    5280:	6105                	addi	sp,sp,32
    5282:	8082                	ret
    return -1;
    5284:	597d                	li	s2,-1
    5286:	bfc5                	j	5276 <stat+0x34>

0000000000005288 <atoi>:

int
atoi(const char *s)
{
    5288:	1141                	addi	sp,sp,-16
    528a:	e422                	sd	s0,8(sp)
    528c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    528e:	00054603          	lbu	a2,0(a0)
    5292:	fd06079b          	addiw	a5,a2,-48
    5296:	0ff7f793          	andi	a5,a5,255
    529a:	4725                	li	a4,9
    529c:	02f76963          	bltu	a4,a5,52ce <atoi+0x46>
    52a0:	86aa                	mv	a3,a0
  n = 0;
    52a2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    52a4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    52a6:	0685                	addi	a3,a3,1
    52a8:	0025179b          	slliw	a5,a0,0x2
    52ac:	9fa9                	addw	a5,a5,a0
    52ae:	0017979b          	slliw	a5,a5,0x1
    52b2:	9fb1                	addw	a5,a5,a2
    52b4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    52b8:	0006c603          	lbu	a2,0(a3) # 1000 <bigdir+0x96>
    52bc:	fd06071b          	addiw	a4,a2,-48
    52c0:	0ff77713          	andi	a4,a4,255
    52c4:	fee5f1e3          	bgeu	a1,a4,52a6 <atoi+0x1e>
  return n;
}
    52c8:	6422                	ld	s0,8(sp)
    52ca:	0141                	addi	sp,sp,16
    52cc:	8082                	ret
  n = 0;
    52ce:	4501                	li	a0,0
    52d0:	bfe5                	j	52c8 <atoi+0x40>

00000000000052d2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    52d2:	1141                	addi	sp,sp,-16
    52d4:	e422                	sd	s0,8(sp)
    52d6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    52d8:	02b57663          	bgeu	a0,a1,5304 <memmove+0x32>
    while(n-- > 0)
    52dc:	02c05163          	blez	a2,52fe <memmove+0x2c>
    52e0:	fff6079b          	addiw	a5,a2,-1
    52e4:	1782                	slli	a5,a5,0x20
    52e6:	9381                	srli	a5,a5,0x20
    52e8:	0785                	addi	a5,a5,1
    52ea:	97aa                	add	a5,a5,a0
  dst = vdst;
    52ec:	872a                	mv	a4,a0
      *dst++ = *src++;
    52ee:	0585                	addi	a1,a1,1
    52f0:	0705                	addi	a4,a4,1
    52f2:	fff5c683          	lbu	a3,-1(a1)
    52f6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    52fa:	fee79ae3          	bne	a5,a4,52ee <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    52fe:	6422                	ld	s0,8(sp)
    5300:	0141                	addi	sp,sp,16
    5302:	8082                	ret
    dst += n;
    5304:	00c50733          	add	a4,a0,a2
    src += n;
    5308:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    530a:	fec05ae3          	blez	a2,52fe <memmove+0x2c>
    530e:	fff6079b          	addiw	a5,a2,-1
    5312:	1782                	slli	a5,a5,0x20
    5314:	9381                	srli	a5,a5,0x20
    5316:	fff7c793          	not	a5,a5
    531a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    531c:	15fd                	addi	a1,a1,-1
    531e:	177d                	addi	a4,a4,-1
    5320:	0005c683          	lbu	a3,0(a1)
    5324:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5328:	fee79ae3          	bne	a5,a4,531c <memmove+0x4a>
    532c:	bfc9                	j	52fe <memmove+0x2c>

000000000000532e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    532e:	1141                	addi	sp,sp,-16
    5330:	e422                	sd	s0,8(sp)
    5332:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5334:	ca05                	beqz	a2,5364 <memcmp+0x36>
    5336:	fff6069b          	addiw	a3,a2,-1
    533a:	1682                	slli	a3,a3,0x20
    533c:	9281                	srli	a3,a3,0x20
    533e:	0685                	addi	a3,a3,1
    5340:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5342:	00054783          	lbu	a5,0(a0)
    5346:	0005c703          	lbu	a4,0(a1)
    534a:	00e79863          	bne	a5,a4,535a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    534e:	0505                	addi	a0,a0,1
    p2++;
    5350:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5352:	fed518e3          	bne	a0,a3,5342 <memcmp+0x14>
  }
  return 0;
    5356:	4501                	li	a0,0
    5358:	a019                	j	535e <memcmp+0x30>
      return *p1 - *p2;
    535a:	40e7853b          	subw	a0,a5,a4
}
    535e:	6422                	ld	s0,8(sp)
    5360:	0141                	addi	sp,sp,16
    5362:	8082                	ret
  return 0;
    5364:	4501                	li	a0,0
    5366:	bfe5                	j	535e <memcmp+0x30>

0000000000005368 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5368:	1141                	addi	sp,sp,-16
    536a:	e406                	sd	ra,8(sp)
    536c:	e022                	sd	s0,0(sp)
    536e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5370:	00000097          	auipc	ra,0x0
    5374:	f62080e7          	jalr	-158(ra) # 52d2 <memmove>
}
    5378:	60a2                	ld	ra,8(sp)
    537a:	6402                	ld	s0,0(sp)
    537c:	0141                	addi	sp,sp,16
    537e:	8082                	ret

0000000000005380 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5380:	4885                	li	a7,1
 ecall
    5382:	00000073          	ecall
 ret
    5386:	8082                	ret

0000000000005388 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5388:	4889                	li	a7,2
 ecall
    538a:	00000073          	ecall
 ret
    538e:	8082                	ret

0000000000005390 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5390:	488d                	li	a7,3
 ecall
    5392:	00000073          	ecall
 ret
    5396:	8082                	ret

0000000000005398 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5398:	4891                	li	a7,4
 ecall
    539a:	00000073          	ecall
 ret
    539e:	8082                	ret

00000000000053a0 <read>:
.global read
read:
 li a7, SYS_read
    53a0:	4895                	li	a7,5
 ecall
    53a2:	00000073          	ecall
 ret
    53a6:	8082                	ret

00000000000053a8 <write>:
.global write
write:
 li a7, SYS_write
    53a8:	48c1                	li	a7,16
 ecall
    53aa:	00000073          	ecall
 ret
    53ae:	8082                	ret

00000000000053b0 <close>:
.global close
close:
 li a7, SYS_close
    53b0:	48d5                	li	a7,21
 ecall
    53b2:	00000073          	ecall
 ret
    53b6:	8082                	ret

00000000000053b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
    53b8:	4899                	li	a7,6
 ecall
    53ba:	00000073          	ecall
 ret
    53be:	8082                	ret

00000000000053c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
    53c0:	489d                	li	a7,7
 ecall
    53c2:	00000073          	ecall
 ret
    53c6:	8082                	ret

00000000000053c8 <open>:
.global open
open:
 li a7, SYS_open
    53c8:	48bd                	li	a7,15
 ecall
    53ca:	00000073          	ecall
 ret
    53ce:	8082                	ret

00000000000053d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    53d0:	48c5                	li	a7,17
 ecall
    53d2:	00000073          	ecall
 ret
    53d6:	8082                	ret

00000000000053d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    53d8:	48c9                	li	a7,18
 ecall
    53da:	00000073          	ecall
 ret
    53de:	8082                	ret

00000000000053e0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    53e0:	48a1                	li	a7,8
 ecall
    53e2:	00000073          	ecall
 ret
    53e6:	8082                	ret

00000000000053e8 <link>:
.global link
link:
 li a7, SYS_link
    53e8:	48cd                	li	a7,19
 ecall
    53ea:	00000073          	ecall
 ret
    53ee:	8082                	ret

00000000000053f0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    53f0:	48d1                	li	a7,20
 ecall
    53f2:	00000073          	ecall
 ret
    53f6:	8082                	ret

00000000000053f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    53f8:	48a5                	li	a7,9
 ecall
    53fa:	00000073          	ecall
 ret
    53fe:	8082                	ret

0000000000005400 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5400:	48a9                	li	a7,10
 ecall
    5402:	00000073          	ecall
 ret
    5406:	8082                	ret

0000000000005408 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5408:	48ad                	li	a7,11
 ecall
    540a:	00000073          	ecall
 ret
    540e:	8082                	ret

0000000000005410 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5410:	48b1                	li	a7,12
 ecall
    5412:	00000073          	ecall
 ret
    5416:	8082                	ret

0000000000005418 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5418:	48b5                	li	a7,13
 ecall
    541a:	00000073          	ecall
 ret
    541e:	8082                	ret

0000000000005420 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5420:	48b9                	li	a7,14
 ecall
    5422:	00000073          	ecall
 ret
    5426:	8082                	ret

0000000000005428 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5428:	1101                	addi	sp,sp,-32
    542a:	ec06                	sd	ra,24(sp)
    542c:	e822                	sd	s0,16(sp)
    542e:	1000                	addi	s0,sp,32
    5430:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5434:	4605                	li	a2,1
    5436:	fef40593          	addi	a1,s0,-17
    543a:	00000097          	auipc	ra,0x0
    543e:	f6e080e7          	jalr	-146(ra) # 53a8 <write>
}
    5442:	60e2                	ld	ra,24(sp)
    5444:	6442                	ld	s0,16(sp)
    5446:	6105                	addi	sp,sp,32
    5448:	8082                	ret

000000000000544a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    544a:	7139                	addi	sp,sp,-64
    544c:	fc06                	sd	ra,56(sp)
    544e:	f822                	sd	s0,48(sp)
    5450:	f426                	sd	s1,40(sp)
    5452:	f04a                	sd	s2,32(sp)
    5454:	ec4e                	sd	s3,24(sp)
    5456:	0080                	addi	s0,sp,64
    5458:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    545a:	c299                	beqz	a3,5460 <printint+0x16>
    545c:	0805c863          	bltz	a1,54ec <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5460:	2581                	sext.w	a1,a1
  neg = 0;
    5462:	4881                	li	a7,0
    5464:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5468:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    546a:	2601                	sext.w	a2,a2
    546c:	00003517          	auipc	a0,0x3
    5470:	b1c50513          	addi	a0,a0,-1252 # 7f88 <digits>
    5474:	883a                	mv	a6,a4
    5476:	2705                	addiw	a4,a4,1
    5478:	02c5f7bb          	remuw	a5,a1,a2
    547c:	1782                	slli	a5,a5,0x20
    547e:	9381                	srli	a5,a5,0x20
    5480:	97aa                	add	a5,a5,a0
    5482:	0007c783          	lbu	a5,0(a5)
    5486:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    548a:	0005879b          	sext.w	a5,a1
    548e:	02c5d5bb          	divuw	a1,a1,a2
    5492:	0685                	addi	a3,a3,1
    5494:	fec7f0e3          	bgeu	a5,a2,5474 <printint+0x2a>
  if(neg)
    5498:	00088b63          	beqz	a7,54ae <printint+0x64>
    buf[i++] = '-';
    549c:	fd040793          	addi	a5,s0,-48
    54a0:	973e                	add	a4,a4,a5
    54a2:	02d00793          	li	a5,45
    54a6:	fef70823          	sb	a5,-16(a4)
    54aa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    54ae:	02e05863          	blez	a4,54de <printint+0x94>
    54b2:	fc040793          	addi	a5,s0,-64
    54b6:	00e78933          	add	s2,a5,a4
    54ba:	fff78993          	addi	s3,a5,-1
    54be:	99ba                	add	s3,s3,a4
    54c0:	377d                	addiw	a4,a4,-1
    54c2:	1702                	slli	a4,a4,0x20
    54c4:	9301                	srli	a4,a4,0x20
    54c6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    54ca:	fff94583          	lbu	a1,-1(s2)
    54ce:	8526                	mv	a0,s1
    54d0:	00000097          	auipc	ra,0x0
    54d4:	f58080e7          	jalr	-168(ra) # 5428 <putc>
  while(--i >= 0)
    54d8:	197d                	addi	s2,s2,-1
    54da:	ff3918e3          	bne	s2,s3,54ca <printint+0x80>
}
    54de:	70e2                	ld	ra,56(sp)
    54e0:	7442                	ld	s0,48(sp)
    54e2:	74a2                	ld	s1,40(sp)
    54e4:	7902                	ld	s2,32(sp)
    54e6:	69e2                	ld	s3,24(sp)
    54e8:	6121                	addi	sp,sp,64
    54ea:	8082                	ret
    x = -xx;
    54ec:	40b005bb          	negw	a1,a1
    neg = 1;
    54f0:	4885                	li	a7,1
    x = -xx;
    54f2:	bf8d                	j	5464 <printint+0x1a>

00000000000054f4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    54f4:	7119                	addi	sp,sp,-128
    54f6:	fc86                	sd	ra,120(sp)
    54f8:	f8a2                	sd	s0,112(sp)
    54fa:	f4a6                	sd	s1,104(sp)
    54fc:	f0ca                	sd	s2,96(sp)
    54fe:	ecce                	sd	s3,88(sp)
    5500:	e8d2                	sd	s4,80(sp)
    5502:	e4d6                	sd	s5,72(sp)
    5504:	e0da                	sd	s6,64(sp)
    5506:	fc5e                	sd	s7,56(sp)
    5508:	f862                	sd	s8,48(sp)
    550a:	f466                	sd	s9,40(sp)
    550c:	f06a                	sd	s10,32(sp)
    550e:	ec6e                	sd	s11,24(sp)
    5510:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5512:	0005c903          	lbu	s2,0(a1)
    5516:	18090f63          	beqz	s2,56b4 <vprintf+0x1c0>
    551a:	8aaa                	mv	s5,a0
    551c:	8b32                	mv	s6,a2
    551e:	00158493          	addi	s1,a1,1
  state = 0;
    5522:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5524:	02500a13          	li	s4,37
      if(c == 'd'){
    5528:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    552c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5530:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5534:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5538:	00003b97          	auipc	s7,0x3
    553c:	a50b8b93          	addi	s7,s7,-1456 # 7f88 <digits>
    5540:	a839                	j	555e <vprintf+0x6a>
        putc(fd, c);
    5542:	85ca                	mv	a1,s2
    5544:	8556                	mv	a0,s5
    5546:	00000097          	auipc	ra,0x0
    554a:	ee2080e7          	jalr	-286(ra) # 5428 <putc>
    554e:	a019                	j	5554 <vprintf+0x60>
    } else if(state == '%'){
    5550:	01498f63          	beq	s3,s4,556e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5554:	0485                	addi	s1,s1,1
    5556:	fff4c903          	lbu	s2,-1(s1)
    555a:	14090d63          	beqz	s2,56b4 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    555e:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5562:	fe0997e3          	bnez	s3,5550 <vprintf+0x5c>
      if(c == '%'){
    5566:	fd479ee3          	bne	a5,s4,5542 <vprintf+0x4e>
        state = '%';
    556a:	89be                	mv	s3,a5
    556c:	b7e5                	j	5554 <vprintf+0x60>
      if(c == 'd'){
    556e:	05878063          	beq	a5,s8,55ae <vprintf+0xba>
      } else if(c == 'l') {
    5572:	05978c63          	beq	a5,s9,55ca <vprintf+0xd6>
      } else if(c == 'x') {
    5576:	07a78863          	beq	a5,s10,55e6 <vprintf+0xf2>
      } else if(c == 'p') {
    557a:	09b78463          	beq	a5,s11,5602 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    557e:	07300713          	li	a4,115
    5582:	0ce78663          	beq	a5,a4,564e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5586:	06300713          	li	a4,99
    558a:	0ee78e63          	beq	a5,a4,5686 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    558e:	11478863          	beq	a5,s4,569e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5592:	85d2                	mv	a1,s4
    5594:	8556                	mv	a0,s5
    5596:	00000097          	auipc	ra,0x0
    559a:	e92080e7          	jalr	-366(ra) # 5428 <putc>
        putc(fd, c);
    559e:	85ca                	mv	a1,s2
    55a0:	8556                	mv	a0,s5
    55a2:	00000097          	auipc	ra,0x0
    55a6:	e86080e7          	jalr	-378(ra) # 5428 <putc>
      }
      state = 0;
    55aa:	4981                	li	s3,0
    55ac:	b765                	j	5554 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    55ae:	008b0913          	addi	s2,s6,8
    55b2:	4685                	li	a3,1
    55b4:	4629                	li	a2,10
    55b6:	000b2583          	lw	a1,0(s6)
    55ba:	8556                	mv	a0,s5
    55bc:	00000097          	auipc	ra,0x0
    55c0:	e8e080e7          	jalr	-370(ra) # 544a <printint>
    55c4:	8b4a                	mv	s6,s2
      state = 0;
    55c6:	4981                	li	s3,0
    55c8:	b771                	j	5554 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    55ca:	008b0913          	addi	s2,s6,8
    55ce:	4681                	li	a3,0
    55d0:	4629                	li	a2,10
    55d2:	000b2583          	lw	a1,0(s6)
    55d6:	8556                	mv	a0,s5
    55d8:	00000097          	auipc	ra,0x0
    55dc:	e72080e7          	jalr	-398(ra) # 544a <printint>
    55e0:	8b4a                	mv	s6,s2
      state = 0;
    55e2:	4981                	li	s3,0
    55e4:	bf85                	j	5554 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    55e6:	008b0913          	addi	s2,s6,8
    55ea:	4681                	li	a3,0
    55ec:	4641                	li	a2,16
    55ee:	000b2583          	lw	a1,0(s6)
    55f2:	8556                	mv	a0,s5
    55f4:	00000097          	auipc	ra,0x0
    55f8:	e56080e7          	jalr	-426(ra) # 544a <printint>
    55fc:	8b4a                	mv	s6,s2
      state = 0;
    55fe:	4981                	li	s3,0
    5600:	bf91                	j	5554 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5602:	008b0793          	addi	a5,s6,8
    5606:	f8f43423          	sd	a5,-120(s0)
    560a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    560e:	03000593          	li	a1,48
    5612:	8556                	mv	a0,s5
    5614:	00000097          	auipc	ra,0x0
    5618:	e14080e7          	jalr	-492(ra) # 5428 <putc>
  putc(fd, 'x');
    561c:	85ea                	mv	a1,s10
    561e:	8556                	mv	a0,s5
    5620:	00000097          	auipc	ra,0x0
    5624:	e08080e7          	jalr	-504(ra) # 5428 <putc>
    5628:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    562a:	03c9d793          	srli	a5,s3,0x3c
    562e:	97de                	add	a5,a5,s7
    5630:	0007c583          	lbu	a1,0(a5)
    5634:	8556                	mv	a0,s5
    5636:	00000097          	auipc	ra,0x0
    563a:	df2080e7          	jalr	-526(ra) # 5428 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    563e:	0992                	slli	s3,s3,0x4
    5640:	397d                	addiw	s2,s2,-1
    5642:	fe0914e3          	bnez	s2,562a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5646:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    564a:	4981                	li	s3,0
    564c:	b721                	j	5554 <vprintf+0x60>
        s = va_arg(ap, char*);
    564e:	008b0993          	addi	s3,s6,8
    5652:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5656:	02090163          	beqz	s2,5678 <vprintf+0x184>
        while(*s != 0){
    565a:	00094583          	lbu	a1,0(s2)
    565e:	c9a1                	beqz	a1,56ae <vprintf+0x1ba>
          putc(fd, *s);
    5660:	8556                	mv	a0,s5
    5662:	00000097          	auipc	ra,0x0
    5666:	dc6080e7          	jalr	-570(ra) # 5428 <putc>
          s++;
    566a:	0905                	addi	s2,s2,1
        while(*s != 0){
    566c:	00094583          	lbu	a1,0(s2)
    5670:	f9e5                	bnez	a1,5660 <vprintf+0x16c>
        s = va_arg(ap, char*);
    5672:	8b4e                	mv	s6,s3
      state = 0;
    5674:	4981                	li	s3,0
    5676:	bdf9                	j	5554 <vprintf+0x60>
          s = "(null)";
    5678:	00003917          	auipc	s2,0x3
    567c:	90890913          	addi	s2,s2,-1784 # 7f80 <statistics+0x26de>
        while(*s != 0){
    5680:	02800593          	li	a1,40
    5684:	bff1                	j	5660 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5686:	008b0913          	addi	s2,s6,8
    568a:	000b4583          	lbu	a1,0(s6)
    568e:	8556                	mv	a0,s5
    5690:	00000097          	auipc	ra,0x0
    5694:	d98080e7          	jalr	-616(ra) # 5428 <putc>
    5698:	8b4a                	mv	s6,s2
      state = 0;
    569a:	4981                	li	s3,0
    569c:	bd65                	j	5554 <vprintf+0x60>
        putc(fd, c);
    569e:	85d2                	mv	a1,s4
    56a0:	8556                	mv	a0,s5
    56a2:	00000097          	auipc	ra,0x0
    56a6:	d86080e7          	jalr	-634(ra) # 5428 <putc>
      state = 0;
    56aa:	4981                	li	s3,0
    56ac:	b565                	j	5554 <vprintf+0x60>
        s = va_arg(ap, char*);
    56ae:	8b4e                	mv	s6,s3
      state = 0;
    56b0:	4981                	li	s3,0
    56b2:	b54d                	j	5554 <vprintf+0x60>
    }
  }
}
    56b4:	70e6                	ld	ra,120(sp)
    56b6:	7446                	ld	s0,112(sp)
    56b8:	74a6                	ld	s1,104(sp)
    56ba:	7906                	ld	s2,96(sp)
    56bc:	69e6                	ld	s3,88(sp)
    56be:	6a46                	ld	s4,80(sp)
    56c0:	6aa6                	ld	s5,72(sp)
    56c2:	6b06                	ld	s6,64(sp)
    56c4:	7be2                	ld	s7,56(sp)
    56c6:	7c42                	ld	s8,48(sp)
    56c8:	7ca2                	ld	s9,40(sp)
    56ca:	7d02                	ld	s10,32(sp)
    56cc:	6de2                	ld	s11,24(sp)
    56ce:	6109                	addi	sp,sp,128
    56d0:	8082                	ret

00000000000056d2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    56d2:	715d                	addi	sp,sp,-80
    56d4:	ec06                	sd	ra,24(sp)
    56d6:	e822                	sd	s0,16(sp)
    56d8:	1000                	addi	s0,sp,32
    56da:	e010                	sd	a2,0(s0)
    56dc:	e414                	sd	a3,8(s0)
    56de:	e818                	sd	a4,16(s0)
    56e0:	ec1c                	sd	a5,24(s0)
    56e2:	03043023          	sd	a6,32(s0)
    56e6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    56ea:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    56ee:	8622                	mv	a2,s0
    56f0:	00000097          	auipc	ra,0x0
    56f4:	e04080e7          	jalr	-508(ra) # 54f4 <vprintf>
}
    56f8:	60e2                	ld	ra,24(sp)
    56fa:	6442                	ld	s0,16(sp)
    56fc:	6161                	addi	sp,sp,80
    56fe:	8082                	ret

0000000000005700 <printf>:

void
printf(const char *fmt, ...)
{
    5700:	711d                	addi	sp,sp,-96
    5702:	ec06                	sd	ra,24(sp)
    5704:	e822                	sd	s0,16(sp)
    5706:	1000                	addi	s0,sp,32
    5708:	e40c                	sd	a1,8(s0)
    570a:	e810                	sd	a2,16(s0)
    570c:	ec14                	sd	a3,24(s0)
    570e:	f018                	sd	a4,32(s0)
    5710:	f41c                	sd	a5,40(s0)
    5712:	03043823          	sd	a6,48(s0)
    5716:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    571a:	00840613          	addi	a2,s0,8
    571e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5722:	85aa                	mv	a1,a0
    5724:	4505                	li	a0,1
    5726:	00000097          	auipc	ra,0x0
    572a:	dce080e7          	jalr	-562(ra) # 54f4 <vprintf>
}
    572e:	60e2                	ld	ra,24(sp)
    5730:	6442                	ld	s0,16(sp)
    5732:	6125                	addi	sp,sp,96
    5734:	8082                	ret

0000000000005736 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5736:	1141                	addi	sp,sp,-16
    5738:	e422                	sd	s0,8(sp)
    573a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    573c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5740:	00003797          	auipc	a5,0x3
    5744:	8a07b783          	ld	a5,-1888(a5) # 7fe0 <freep>
    5748:	a805                	j	5778 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    574a:	4618                	lw	a4,8(a2)
    574c:	9db9                	addw	a1,a1,a4
    574e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5752:	6398                	ld	a4,0(a5)
    5754:	6318                	ld	a4,0(a4)
    5756:	fee53823          	sd	a4,-16(a0)
    575a:	a091                	j	579e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    575c:	ff852703          	lw	a4,-8(a0)
    5760:	9e39                	addw	a2,a2,a4
    5762:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5764:	ff053703          	ld	a4,-16(a0)
    5768:	e398                	sd	a4,0(a5)
    576a:	a099                	j	57b0 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    576c:	6398                	ld	a4,0(a5)
    576e:	00e7e463          	bltu	a5,a4,5776 <free+0x40>
    5772:	00e6ea63          	bltu	a3,a4,5786 <free+0x50>
{
    5776:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5778:	fed7fae3          	bgeu	a5,a3,576c <free+0x36>
    577c:	6398                	ld	a4,0(a5)
    577e:	00e6e463          	bltu	a3,a4,5786 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5782:	fee7eae3          	bltu	a5,a4,5776 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5786:	ff852583          	lw	a1,-8(a0)
    578a:	6390                	ld	a2,0(a5)
    578c:	02059713          	slli	a4,a1,0x20
    5790:	9301                	srli	a4,a4,0x20
    5792:	0712                	slli	a4,a4,0x4
    5794:	9736                	add	a4,a4,a3
    5796:	fae60ae3          	beq	a2,a4,574a <free+0x14>
    bp->s.ptr = p->s.ptr;
    579a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    579e:	4790                	lw	a2,8(a5)
    57a0:	02061713          	slli	a4,a2,0x20
    57a4:	9301                	srli	a4,a4,0x20
    57a6:	0712                	slli	a4,a4,0x4
    57a8:	973e                	add	a4,a4,a5
    57aa:	fae689e3          	beq	a3,a4,575c <free+0x26>
  } else
    p->s.ptr = bp;
    57ae:	e394                	sd	a3,0(a5)
  freep = p;
    57b0:	00003717          	auipc	a4,0x3
    57b4:	82f73823          	sd	a5,-2000(a4) # 7fe0 <freep>
}
    57b8:	6422                	ld	s0,8(sp)
    57ba:	0141                	addi	sp,sp,16
    57bc:	8082                	ret

00000000000057be <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    57be:	7139                	addi	sp,sp,-64
    57c0:	fc06                	sd	ra,56(sp)
    57c2:	f822                	sd	s0,48(sp)
    57c4:	f426                	sd	s1,40(sp)
    57c6:	f04a                	sd	s2,32(sp)
    57c8:	ec4e                	sd	s3,24(sp)
    57ca:	e852                	sd	s4,16(sp)
    57cc:	e456                	sd	s5,8(sp)
    57ce:	e05a                	sd	s6,0(sp)
    57d0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    57d2:	02051493          	slli	s1,a0,0x20
    57d6:	9081                	srli	s1,s1,0x20
    57d8:	04bd                	addi	s1,s1,15
    57da:	8091                	srli	s1,s1,0x4
    57dc:	0014899b          	addiw	s3,s1,1
    57e0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    57e2:	00002517          	auipc	a0,0x2
    57e6:	7fe53503          	ld	a0,2046(a0) # 7fe0 <freep>
    57ea:	c515                	beqz	a0,5816 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    57ec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    57ee:	4798                	lw	a4,8(a5)
    57f0:	02977f63          	bgeu	a4,s1,582e <malloc+0x70>
    57f4:	8a4e                	mv	s4,s3
    57f6:	0009871b          	sext.w	a4,s3
    57fa:	6685                	lui	a3,0x1
    57fc:	00d77363          	bgeu	a4,a3,5802 <malloc+0x44>
    5800:	6a05                	lui	s4,0x1
    5802:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5806:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    580a:	00002917          	auipc	s2,0x2
    580e:	7d690913          	addi	s2,s2,2006 # 7fe0 <freep>
  if(p == (char*)-1)
    5812:	5afd                	li	s5,-1
    5814:	a88d                	j	5886 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    5816:	00009797          	auipc	a5,0x9
    581a:	fea78793          	addi	a5,a5,-22 # e800 <base>
    581e:	00002717          	auipc	a4,0x2
    5822:	7cf73123          	sd	a5,1986(a4) # 7fe0 <freep>
    5826:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5828:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    582c:	b7e1                	j	57f4 <malloc+0x36>
      if(p->s.size == nunits)
    582e:	02e48b63          	beq	s1,a4,5864 <malloc+0xa6>
        p->s.size -= nunits;
    5832:	4137073b          	subw	a4,a4,s3
    5836:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5838:	1702                	slli	a4,a4,0x20
    583a:	9301                	srli	a4,a4,0x20
    583c:	0712                	slli	a4,a4,0x4
    583e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5840:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5844:	00002717          	auipc	a4,0x2
    5848:	78a73e23          	sd	a0,1948(a4) # 7fe0 <freep>
      return (void*)(p + 1);
    584c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5850:	70e2                	ld	ra,56(sp)
    5852:	7442                	ld	s0,48(sp)
    5854:	74a2                	ld	s1,40(sp)
    5856:	7902                	ld	s2,32(sp)
    5858:	69e2                	ld	s3,24(sp)
    585a:	6a42                	ld	s4,16(sp)
    585c:	6aa2                	ld	s5,8(sp)
    585e:	6b02                	ld	s6,0(sp)
    5860:	6121                	addi	sp,sp,64
    5862:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5864:	6398                	ld	a4,0(a5)
    5866:	e118                	sd	a4,0(a0)
    5868:	bff1                	j	5844 <malloc+0x86>
  hp->s.size = nu;
    586a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    586e:	0541                	addi	a0,a0,16
    5870:	00000097          	auipc	ra,0x0
    5874:	ec6080e7          	jalr	-314(ra) # 5736 <free>
  return freep;
    5878:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    587c:	d971                	beqz	a0,5850 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    587e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5880:	4798                	lw	a4,8(a5)
    5882:	fa9776e3          	bgeu	a4,s1,582e <malloc+0x70>
    if(p == freep)
    5886:	00093703          	ld	a4,0(s2)
    588a:	853e                	mv	a0,a5
    588c:	fef719e3          	bne	a4,a5,587e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    5890:	8552                	mv	a0,s4
    5892:	00000097          	auipc	ra,0x0
    5896:	b7e080e7          	jalr	-1154(ra) # 5410 <sbrk>
  if(p == (char*)-1)
    589a:	fd5518e3          	bne	a0,s5,586a <malloc+0xac>
        return 0;
    589e:	4501                	li	a0,0
    58a0:	bf45                	j	5850 <malloc+0x92>

00000000000058a2 <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
    58a2:	7179                	addi	sp,sp,-48
    58a4:	f406                	sd	ra,40(sp)
    58a6:	f022                	sd	s0,32(sp)
    58a8:	ec26                	sd	s1,24(sp)
    58aa:	e84a                	sd	s2,16(sp)
    58ac:	e44e                	sd	s3,8(sp)
    58ae:	e052                	sd	s4,0(sp)
    58b0:	1800                	addi	s0,sp,48
    58b2:	8a2a                	mv	s4,a0
    58b4:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
    58b6:	4581                	li	a1,0
    58b8:	00002517          	auipc	a0,0x2
    58bc:	6e850513          	addi	a0,a0,1768 # 7fa0 <digits+0x18>
    58c0:	00000097          	auipc	ra,0x0
    58c4:	b08080e7          	jalr	-1272(ra) # 53c8 <open>
  if(fd < 0) {
    58c8:	04054263          	bltz	a0,590c <statistics+0x6a>
    58cc:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
    58ce:	4481                	li	s1,0
    58d0:	03205063          	blez	s2,58f0 <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
    58d4:	4099063b          	subw	a2,s2,s1
    58d8:	009a05b3          	add	a1,s4,s1
    58dc:	854e                	mv	a0,s3
    58de:	00000097          	auipc	ra,0x0
    58e2:	ac2080e7          	jalr	-1342(ra) # 53a0 <read>
    58e6:	00054563          	bltz	a0,58f0 <statistics+0x4e>
      break;
    }
    i += n;
    58ea:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
    58ec:	ff24c4e3          	blt	s1,s2,58d4 <statistics+0x32>
  }
  close(fd);
    58f0:	854e                	mv	a0,s3
    58f2:	00000097          	auipc	ra,0x0
    58f6:	abe080e7          	jalr	-1346(ra) # 53b0 <close>
  return i;
}
    58fa:	8526                	mv	a0,s1
    58fc:	70a2                	ld	ra,40(sp)
    58fe:	7402                	ld	s0,32(sp)
    5900:	64e2                	ld	s1,24(sp)
    5902:	6942                	ld	s2,16(sp)
    5904:	69a2                	ld	s3,8(sp)
    5906:	6a02                	ld	s4,0(sp)
    5908:	6145                	addi	sp,sp,48
    590a:	8082                	ret
      fprintf(2, "stats: open failed\n");
    590c:	00002597          	auipc	a1,0x2
    5910:	6a458593          	addi	a1,a1,1700 # 7fb0 <digits+0x28>
    5914:	4509                	li	a0,2
    5916:	00000097          	auipc	ra,0x0
    591a:	dbc080e7          	jalr	-580(ra) # 56d2 <fprintf>
      exit(1);
    591e:	4505                	li	a0,1
    5920:	00000097          	auipc	ra,0x0
    5924:	a68080e7          	jalr	-1432(ra) # 5388 <exit>
