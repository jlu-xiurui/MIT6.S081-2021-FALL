
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
      14:	522080e7          	jalr	1314(ra) # 5532 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	510080e7          	jalr	1296(ra) # 5532 <open>
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
      42:	cda50513          	addi	a0,a0,-806 # 5d18 <malloc+0x3f0>
      46:	00006097          	auipc	ra,0x6
      4a:	824080e7          	jalr	-2012(ra) # 586a <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	4a2080e7          	jalr	1186(ra) # 54f2 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	20878793          	addi	a5,a5,520 # 9260 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	91068693          	addi	a3,a3,-1776 # b970 <buf>
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
      84:	cb850513          	addi	a0,a0,-840 # 5d38 <malloc+0x410>
      88:	00005097          	auipc	ra,0x5
      8c:	7e2080e7          	jalr	2018(ra) # 586a <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	460080e7          	jalr	1120(ra) # 54f2 <exit>

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
      ac:	ca850513          	addi	a0,a0,-856 # 5d50 <malloc+0x428>
      b0:	00005097          	auipc	ra,0x5
      b4:	482080e7          	jalr	1154(ra) # 5532 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	45e080e7          	jalr	1118(ra) # 551a <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	caa50513          	addi	a0,a0,-854 # 5d70 <malloc+0x448>
      ce:	00005097          	auipc	ra,0x5
      d2:	464080e7          	jalr	1124(ra) # 5532 <open>
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
      ea:	c7250513          	addi	a0,a0,-910 # 5d58 <malloc+0x430>
      ee:	00005097          	auipc	ra,0x5
      f2:	77c080e7          	jalr	1916(ra) # 586a <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	3fa080e7          	jalr	1018(ra) # 54f2 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	c7e50513          	addi	a0,a0,-898 # 5d80 <malloc+0x458>
     10a:	00005097          	auipc	ra,0x5
     10e:	760080e7          	jalr	1888(ra) # 586a <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	3de080e7          	jalr	990(ra) # 54f2 <exit>

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
     130:	c7c50513          	addi	a0,a0,-900 # 5da8 <malloc+0x480>
     134:	00005097          	auipc	ra,0x5
     138:	40e080e7          	jalr	1038(ra) # 5542 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	c6850513          	addi	a0,a0,-920 # 5da8 <malloc+0x480>
     148:	00005097          	auipc	ra,0x5
     14c:	3ea080e7          	jalr	1002(ra) # 5532 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	c6458593          	addi	a1,a1,-924 # 5db8 <malloc+0x490>
     15c:	00005097          	auipc	ra,0x5
     160:	3b6080e7          	jalr	950(ra) # 5512 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	c4050513          	addi	a0,a0,-960 # 5da8 <malloc+0x480>
     170:	00005097          	auipc	ra,0x5
     174:	3c2080e7          	jalr	962(ra) # 5532 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	c4458593          	addi	a1,a1,-956 # 5dc0 <malloc+0x498>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	38c080e7          	jalr	908(ra) # 5512 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	c1450513          	addi	a0,a0,-1004 # 5da8 <malloc+0x480>
     19c:	00005097          	auipc	ra,0x5
     1a0:	3a6080e7          	jalr	934(ra) # 5542 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	374080e7          	jalr	884(ra) # 551a <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	36a080e7          	jalr	874(ra) # 551a <close>
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
     1ce:	bfe50513          	addi	a0,a0,-1026 # 5dc8 <malloc+0x4a0>
     1d2:	00005097          	auipc	ra,0x5
     1d6:	698080e7          	jalr	1688(ra) # 586a <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	316080e7          	jalr	790(ra) # 54f2 <exit>

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
     1f6:	f5678793          	addi	a5,a5,-170 # 8148 <name>
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
     21e:	318080e7          	jalr	792(ra) # 5532 <open>
    close(fd);
     222:	00005097          	auipc	ra,0x5
     226:	2f8080e7          	jalr	760(ra) # 551a <close>
  for(i = 0; i < N; i++){
     22a:	2485                	addiw	s1,s1,1
     22c:	0ff4f493          	andi	s1,s1,255
     230:	ff3490e3          	bne	s1,s3,210 <createtest+0x2c>
  name[0] = 'a';
     234:	00008797          	auipc	a5,0x8
     238:	f1478793          	addi	a5,a5,-236 # 8148 <name>
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
     25c:	2ea080e7          	jalr	746(ra) # 5542 <unlink>
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
     294:	93850513          	addi	a0,a0,-1736 # 5bc8 <malloc+0x2a0>
     298:	00005097          	auipc	ra,0x5
     29c:	2aa080e7          	jalr	682(ra) # 5542 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a4:	00006a97          	auipc	s5,0x6
     2a8:	924a8a93          	addi	s5,s5,-1756 # 5bc8 <malloc+0x2a0>
      int cc = write(fd, buf, sz);
     2ac:	0000ba17          	auipc	s4,0xb
     2b0:	6c4a0a13          	addi	s4,s4,1732 # b970 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b4:	6b0d                	lui	s6,0x3
     2b6:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x393>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2ba:	20200593          	li	a1,514
     2be:	8556                	mv	a0,s5
     2c0:	00005097          	auipc	ra,0x5
     2c4:	272080e7          	jalr	626(ra) # 5532 <open>
     2c8:	892a                	mv	s2,a0
    if(fd < 0){
     2ca:	04054d63          	bltz	a0,324 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ce:	8626                	mv	a2,s1
     2d0:	85d2                	mv	a1,s4
     2d2:	00005097          	auipc	ra,0x5
     2d6:	240080e7          	jalr	576(ra) # 5512 <write>
     2da:	89aa                	mv	s3,a0
      if(cc != sz){
     2dc:	06a49463          	bne	s1,a0,344 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2e0:	8626                	mv	a2,s1
     2e2:	85d2                	mv	a1,s4
     2e4:	854a                	mv	a0,s2
     2e6:	00005097          	auipc	ra,0x5
     2ea:	22c080e7          	jalr	556(ra) # 5512 <write>
      if(cc != sz){
     2ee:	04951963          	bne	a0,s1,340 <bigwrite+0xc8>
    close(fd);
     2f2:	854a                	mv	a0,s2
     2f4:	00005097          	auipc	ra,0x5
     2f8:	226080e7          	jalr	550(ra) # 551a <close>
    unlink("bigwrite");
     2fc:	8556                	mv	a0,s5
     2fe:	00005097          	auipc	ra,0x5
     302:	244080e7          	jalr	580(ra) # 5542 <unlink>
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
     32a:	aca50513          	addi	a0,a0,-1334 # 5df0 <malloc+0x4c8>
     32e:	00005097          	auipc	ra,0x5
     332:	53c080e7          	jalr	1340(ra) # 586a <printf>
      exit(1);
     336:	4505                	li	a0,1
     338:	00005097          	auipc	ra,0x5
     33c:	1ba080e7          	jalr	442(ra) # 54f2 <exit>
     340:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     342:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     344:	86ce                	mv	a3,s3
     346:	8626                	mv	a2,s1
     348:	85de                	mv	a1,s7
     34a:	00006517          	auipc	a0,0x6
     34e:	ac650513          	addi	a0,a0,-1338 # 5e10 <malloc+0x4e8>
     352:	00005097          	auipc	ra,0x5
     356:	518080e7          	jalr	1304(ra) # 586a <printf>
        exit(1);
     35a:	4505                	li	a0,1
     35c:	00005097          	auipc	ra,0x5
     360:	196080e7          	jalr	406(ra) # 54f2 <exit>

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
     38a:	aa2a0a13          	addi	s4,s4,-1374 # 5e28 <malloc+0x500>
    uint64 addr = addrs[ai];
     38e:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     392:	20100593          	li	a1,513
     396:	8552                	mv	a0,s4
     398:	00005097          	auipc	ra,0x5
     39c:	19a080e7          	jalr	410(ra) # 5532 <open>
     3a0:	84aa                	mv	s1,a0
    if(fd < 0){
     3a2:	08054863          	bltz	a0,432 <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     3a6:	6609                	lui	a2,0x2
     3a8:	85ce                	mv	a1,s3
     3aa:	00005097          	auipc	ra,0x5
     3ae:	168080e7          	jalr	360(ra) # 5512 <write>
    if(n >= 0){
     3b2:	08055d63          	bgez	a0,44c <copyin+0xe8>
    close(fd);
     3b6:	8526                	mv	a0,s1
     3b8:	00005097          	auipc	ra,0x5
     3bc:	162080e7          	jalr	354(ra) # 551a <close>
    unlink("copyin1");
     3c0:	8552                	mv	a0,s4
     3c2:	00005097          	auipc	ra,0x5
     3c6:	180080e7          	jalr	384(ra) # 5542 <unlink>
    n = write(1, (char*)addr, 8192);
     3ca:	6609                	lui	a2,0x2
     3cc:	85ce                	mv	a1,s3
     3ce:	4505                	li	a0,1
     3d0:	00005097          	auipc	ra,0x5
     3d4:	142080e7          	jalr	322(ra) # 5512 <write>
    if(n > 0){
     3d8:	08a04963          	bgtz	a0,46a <copyin+0x106>
    if(pipe(fds) < 0){
     3dc:	fb840513          	addi	a0,s0,-72
     3e0:	00005097          	auipc	ra,0x5
     3e4:	122080e7          	jalr	290(ra) # 5502 <pipe>
     3e8:	0a054063          	bltz	a0,488 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3ec:	6609                	lui	a2,0x2
     3ee:	85ce                	mv	a1,s3
     3f0:	fbc42503          	lw	a0,-68(s0)
     3f4:	00005097          	auipc	ra,0x5
     3f8:	11e080e7          	jalr	286(ra) # 5512 <write>
    if(n > 0){
     3fc:	0aa04363          	bgtz	a0,4a2 <copyin+0x13e>
    close(fds[0]);
     400:	fb842503          	lw	a0,-72(s0)
     404:	00005097          	auipc	ra,0x5
     408:	116080e7          	jalr	278(ra) # 551a <close>
    close(fds[1]);
     40c:	fbc42503          	lw	a0,-68(s0)
     410:	00005097          	auipc	ra,0x5
     414:	10a080e7          	jalr	266(ra) # 551a <close>
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
     436:	9fe50513          	addi	a0,a0,-1538 # 5e30 <malloc+0x508>
     43a:	00005097          	auipc	ra,0x5
     43e:	430080e7          	jalr	1072(ra) # 586a <printf>
      exit(1);
     442:	4505                	li	a0,1
     444:	00005097          	auipc	ra,0x5
     448:	0ae080e7          	jalr	174(ra) # 54f2 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     44c:	862a                	mv	a2,a0
     44e:	85ce                	mv	a1,s3
     450:	00006517          	auipc	a0,0x6
     454:	9f850513          	addi	a0,a0,-1544 # 5e48 <malloc+0x520>
     458:	00005097          	auipc	ra,0x5
     45c:	412080e7          	jalr	1042(ra) # 586a <printf>
      exit(1);
     460:	4505                	li	a0,1
     462:	00005097          	auipc	ra,0x5
     466:	090080e7          	jalr	144(ra) # 54f2 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     46a:	862a                	mv	a2,a0
     46c:	85ce                	mv	a1,s3
     46e:	00006517          	auipc	a0,0x6
     472:	a0a50513          	addi	a0,a0,-1526 # 5e78 <malloc+0x550>
     476:	00005097          	auipc	ra,0x5
     47a:	3f4080e7          	jalr	1012(ra) # 586a <printf>
      exit(1);
     47e:	4505                	li	a0,1
     480:	00005097          	auipc	ra,0x5
     484:	072080e7          	jalr	114(ra) # 54f2 <exit>
      printf("pipe() failed\n");
     488:	00006517          	auipc	a0,0x6
     48c:	a2050513          	addi	a0,a0,-1504 # 5ea8 <malloc+0x580>
     490:	00005097          	auipc	ra,0x5
     494:	3da080e7          	jalr	986(ra) # 586a <printf>
      exit(1);
     498:	4505                	li	a0,1
     49a:	00005097          	auipc	ra,0x5
     49e:	058080e7          	jalr	88(ra) # 54f2 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     4a2:	862a                	mv	a2,a0
     4a4:	85ce                	mv	a1,s3
     4a6:	00006517          	auipc	a0,0x6
     4aa:	a1250513          	addi	a0,a0,-1518 # 5eb8 <malloc+0x590>
     4ae:	00005097          	auipc	ra,0x5
     4b2:	3bc080e7          	jalr	956(ra) # 586a <printf>
      exit(1);
     4b6:	4505                	li	a0,1
     4b8:	00005097          	auipc	ra,0x5
     4bc:	03a080e7          	jalr	58(ra) # 54f2 <exit>

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
     4e8:	a04a0a13          	addi	s4,s4,-1532 # 5ee8 <malloc+0x5c0>
    n = write(fds[1], "x", 1);
     4ec:	00006a97          	auipc	s5,0x6
     4f0:	8d4a8a93          	addi	s5,s5,-1836 # 5dc0 <malloc+0x498>
    uint64 addr = addrs[ai];
     4f4:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4f8:	4581                	li	a1,0
     4fa:	8552                	mv	a0,s4
     4fc:	00005097          	auipc	ra,0x5
     500:	036080e7          	jalr	54(ra) # 5532 <open>
     504:	84aa                	mv	s1,a0
    if(fd < 0){
     506:	08054663          	bltz	a0,592 <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     50a:	6609                	lui	a2,0x2
     50c:	85ce                	mv	a1,s3
     50e:	00005097          	auipc	ra,0x5
     512:	ffc080e7          	jalr	-4(ra) # 550a <read>
    if(n > 0){
     516:	08a04b63          	bgtz	a0,5ac <copyout+0xec>
    close(fd);
     51a:	8526                	mv	a0,s1
     51c:	00005097          	auipc	ra,0x5
     520:	ffe080e7          	jalr	-2(ra) # 551a <close>
    if(pipe(fds) < 0){
     524:	fa840513          	addi	a0,s0,-88
     528:	00005097          	auipc	ra,0x5
     52c:	fda080e7          	jalr	-38(ra) # 5502 <pipe>
     530:	08054d63          	bltz	a0,5ca <copyout+0x10a>
    n = write(fds[1], "x", 1);
     534:	4605                	li	a2,1
     536:	85d6                	mv	a1,s5
     538:	fac42503          	lw	a0,-84(s0)
     53c:	00005097          	auipc	ra,0x5
     540:	fd6080e7          	jalr	-42(ra) # 5512 <write>
    if(n != 1){
     544:	4785                	li	a5,1
     546:	08f51f63          	bne	a0,a5,5e4 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     54a:	6609                	lui	a2,0x2
     54c:	85ce                	mv	a1,s3
     54e:	fa842503          	lw	a0,-88(s0)
     552:	00005097          	auipc	ra,0x5
     556:	fb8080e7          	jalr	-72(ra) # 550a <read>
    if(n > 0){
     55a:	0aa04263          	bgtz	a0,5fe <copyout+0x13e>
    close(fds[0]);
     55e:	fa842503          	lw	a0,-88(s0)
     562:	00005097          	auipc	ra,0x5
     566:	fb8080e7          	jalr	-72(ra) # 551a <close>
    close(fds[1]);
     56a:	fac42503          	lw	a0,-84(s0)
     56e:	00005097          	auipc	ra,0x5
     572:	fac080e7          	jalr	-84(ra) # 551a <close>
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
     596:	95e50513          	addi	a0,a0,-1698 # 5ef0 <malloc+0x5c8>
     59a:	00005097          	auipc	ra,0x5
     59e:	2d0080e7          	jalr	720(ra) # 586a <printf>
      exit(1);
     5a2:	4505                	li	a0,1
     5a4:	00005097          	auipc	ra,0x5
     5a8:	f4e080e7          	jalr	-178(ra) # 54f2 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5ac:	862a                	mv	a2,a0
     5ae:	85ce                	mv	a1,s3
     5b0:	00006517          	auipc	a0,0x6
     5b4:	95850513          	addi	a0,a0,-1704 # 5f08 <malloc+0x5e0>
     5b8:	00005097          	auipc	ra,0x5
     5bc:	2b2080e7          	jalr	690(ra) # 586a <printf>
      exit(1);
     5c0:	4505                	li	a0,1
     5c2:	00005097          	auipc	ra,0x5
     5c6:	f30080e7          	jalr	-208(ra) # 54f2 <exit>
      printf("pipe() failed\n");
     5ca:	00006517          	auipc	a0,0x6
     5ce:	8de50513          	addi	a0,a0,-1826 # 5ea8 <malloc+0x580>
     5d2:	00005097          	auipc	ra,0x5
     5d6:	298080e7          	jalr	664(ra) # 586a <printf>
      exit(1);
     5da:	4505                	li	a0,1
     5dc:	00005097          	auipc	ra,0x5
     5e0:	f16080e7          	jalr	-234(ra) # 54f2 <exit>
      printf("pipe write failed\n");
     5e4:	00006517          	auipc	a0,0x6
     5e8:	95450513          	addi	a0,a0,-1708 # 5f38 <malloc+0x610>
     5ec:	00005097          	auipc	ra,0x5
     5f0:	27e080e7          	jalr	638(ra) # 586a <printf>
      exit(1);
     5f4:	4505                	li	a0,1
     5f6:	00005097          	auipc	ra,0x5
     5fa:	efc080e7          	jalr	-260(ra) # 54f2 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5fe:	862a                	mv	a2,a0
     600:	85ce                	mv	a1,s3
     602:	00006517          	auipc	a0,0x6
     606:	94e50513          	addi	a0,a0,-1714 # 5f50 <malloc+0x628>
     60a:	00005097          	auipc	ra,0x5
     60e:	260080e7          	jalr	608(ra) # 586a <printf>
      exit(1);
     612:	4505                	li	a0,1
     614:	00005097          	auipc	ra,0x5
     618:	ede080e7          	jalr	-290(ra) # 54f2 <exit>

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
     634:	77850513          	addi	a0,a0,1912 # 5da8 <malloc+0x480>
     638:	00005097          	auipc	ra,0x5
     63c:	f0a080e7          	jalr	-246(ra) # 5542 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     640:	60100593          	li	a1,1537
     644:	00005517          	auipc	a0,0x5
     648:	76450513          	addi	a0,a0,1892 # 5da8 <malloc+0x480>
     64c:	00005097          	auipc	ra,0x5
     650:	ee6080e7          	jalr	-282(ra) # 5532 <open>
     654:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     656:	4611                	li	a2,4
     658:	00005597          	auipc	a1,0x5
     65c:	76058593          	addi	a1,a1,1888 # 5db8 <malloc+0x490>
     660:	00005097          	auipc	ra,0x5
     664:	eb2080e7          	jalr	-334(ra) # 5512 <write>
  close(fd1);
     668:	8526                	mv	a0,s1
     66a:	00005097          	auipc	ra,0x5
     66e:	eb0080e7          	jalr	-336(ra) # 551a <close>
  int fd2 = open("truncfile", O_RDONLY);
     672:	4581                	li	a1,0
     674:	00005517          	auipc	a0,0x5
     678:	73450513          	addi	a0,a0,1844 # 5da8 <malloc+0x480>
     67c:	00005097          	auipc	ra,0x5
     680:	eb6080e7          	jalr	-330(ra) # 5532 <open>
     684:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     686:	02000613          	li	a2,32
     68a:	fa040593          	addi	a1,s0,-96
     68e:	00005097          	auipc	ra,0x5
     692:	e7c080e7          	jalr	-388(ra) # 550a <read>
  if(n != 4){
     696:	4791                	li	a5,4
     698:	0cf51e63          	bne	a0,a5,774 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     69c:	40100593          	li	a1,1025
     6a0:	00005517          	auipc	a0,0x5
     6a4:	70850513          	addi	a0,a0,1800 # 5da8 <malloc+0x480>
     6a8:	00005097          	auipc	ra,0x5
     6ac:	e8a080e7          	jalr	-374(ra) # 5532 <open>
     6b0:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     6b2:	4581                	li	a1,0
     6b4:	00005517          	auipc	a0,0x5
     6b8:	6f450513          	addi	a0,a0,1780 # 5da8 <malloc+0x480>
     6bc:	00005097          	auipc	ra,0x5
     6c0:	e76080e7          	jalr	-394(ra) # 5532 <open>
     6c4:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6c6:	02000613          	li	a2,32
     6ca:	fa040593          	addi	a1,s0,-96
     6ce:	00005097          	auipc	ra,0x5
     6d2:	e3c080e7          	jalr	-452(ra) # 550a <read>
     6d6:	8a2a                	mv	s4,a0
  if(n != 0){
     6d8:	ed4d                	bnez	a0,792 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6da:	02000613          	li	a2,32
     6de:	fa040593          	addi	a1,s0,-96
     6e2:	8526                	mv	a0,s1
     6e4:	00005097          	auipc	ra,0x5
     6e8:	e26080e7          	jalr	-474(ra) # 550a <read>
     6ec:	8a2a                	mv	s4,a0
  if(n != 0){
     6ee:	e971                	bnez	a0,7c2 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6f0:	4619                	li	a2,6
     6f2:	00006597          	auipc	a1,0x6
     6f6:	8ee58593          	addi	a1,a1,-1810 # 5fe0 <malloc+0x6b8>
     6fa:	854e                	mv	a0,s3
     6fc:	00005097          	auipc	ra,0x5
     700:	e16080e7          	jalr	-490(ra) # 5512 <write>
  n = read(fd3, buf, sizeof(buf));
     704:	02000613          	li	a2,32
     708:	fa040593          	addi	a1,s0,-96
     70c:	854a                	mv	a0,s2
     70e:	00005097          	auipc	ra,0x5
     712:	dfc080e7          	jalr	-516(ra) # 550a <read>
  if(n != 6){
     716:	4799                	li	a5,6
     718:	0cf51d63          	bne	a0,a5,7f2 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     71c:	02000613          	li	a2,32
     720:	fa040593          	addi	a1,s0,-96
     724:	8526                	mv	a0,s1
     726:	00005097          	auipc	ra,0x5
     72a:	de4080e7          	jalr	-540(ra) # 550a <read>
  if(n != 2){
     72e:	4789                	li	a5,2
     730:	0ef51063          	bne	a0,a5,810 <truncate1+0x1f4>
  unlink("truncfile");
     734:	00005517          	auipc	a0,0x5
     738:	67450513          	addi	a0,a0,1652 # 5da8 <malloc+0x480>
     73c:	00005097          	auipc	ra,0x5
     740:	e06080e7          	jalr	-506(ra) # 5542 <unlink>
  close(fd1);
     744:	854e                	mv	a0,s3
     746:	00005097          	auipc	ra,0x5
     74a:	dd4080e7          	jalr	-556(ra) # 551a <close>
  close(fd2);
     74e:	8526                	mv	a0,s1
     750:	00005097          	auipc	ra,0x5
     754:	dca080e7          	jalr	-566(ra) # 551a <close>
  close(fd3);
     758:	854a                	mv	a0,s2
     75a:	00005097          	auipc	ra,0x5
     75e:	dc0080e7          	jalr	-576(ra) # 551a <close>
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
     778:	00006517          	auipc	a0,0x6
     77c:	80850513          	addi	a0,a0,-2040 # 5f80 <malloc+0x658>
     780:	00005097          	auipc	ra,0x5
     784:	0ea080e7          	jalr	234(ra) # 586a <printf>
    exit(1);
     788:	4505                	li	a0,1
     78a:	00005097          	auipc	ra,0x5
     78e:	d68080e7          	jalr	-664(ra) # 54f2 <exit>
    printf("aaa fd3=%d\n", fd3);
     792:	85ca                	mv	a1,s2
     794:	00006517          	auipc	a0,0x6
     798:	80c50513          	addi	a0,a0,-2036 # 5fa0 <malloc+0x678>
     79c:	00005097          	auipc	ra,0x5
     7a0:	0ce080e7          	jalr	206(ra) # 586a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7a4:	8652                	mv	a2,s4
     7a6:	85d6                	mv	a1,s5
     7a8:	00006517          	auipc	a0,0x6
     7ac:	80850513          	addi	a0,a0,-2040 # 5fb0 <malloc+0x688>
     7b0:	00005097          	auipc	ra,0x5
     7b4:	0ba080e7          	jalr	186(ra) # 586a <printf>
    exit(1);
     7b8:	4505                	li	a0,1
     7ba:	00005097          	auipc	ra,0x5
     7be:	d38080e7          	jalr	-712(ra) # 54f2 <exit>
    printf("bbb fd2=%d\n", fd2);
     7c2:	85a6                	mv	a1,s1
     7c4:	00006517          	auipc	a0,0x6
     7c8:	80c50513          	addi	a0,a0,-2036 # 5fd0 <malloc+0x6a8>
     7cc:	00005097          	auipc	ra,0x5
     7d0:	09e080e7          	jalr	158(ra) # 586a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7d4:	8652                	mv	a2,s4
     7d6:	85d6                	mv	a1,s5
     7d8:	00005517          	auipc	a0,0x5
     7dc:	7d850513          	addi	a0,a0,2008 # 5fb0 <malloc+0x688>
     7e0:	00005097          	auipc	ra,0x5
     7e4:	08a080e7          	jalr	138(ra) # 586a <printf>
    exit(1);
     7e8:	4505                	li	a0,1
     7ea:	00005097          	auipc	ra,0x5
     7ee:	d08080e7          	jalr	-760(ra) # 54f2 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7f2:	862a                	mv	a2,a0
     7f4:	85d6                	mv	a1,s5
     7f6:	00005517          	auipc	a0,0x5
     7fa:	7f250513          	addi	a0,a0,2034 # 5fe8 <malloc+0x6c0>
     7fe:	00005097          	auipc	ra,0x5
     802:	06c080e7          	jalr	108(ra) # 586a <printf>
    exit(1);
     806:	4505                	li	a0,1
     808:	00005097          	auipc	ra,0x5
     80c:	cea080e7          	jalr	-790(ra) # 54f2 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     810:	862a                	mv	a2,a0
     812:	85d6                	mv	a1,s5
     814:	00005517          	auipc	a0,0x5
     818:	7f450513          	addi	a0,a0,2036 # 6008 <malloc+0x6e0>
     81c:	00005097          	auipc	ra,0x5
     820:	04e080e7          	jalr	78(ra) # 586a <printf>
    exit(1);
     824:	4505                	li	a0,1
     826:	00005097          	auipc	ra,0x5
     82a:	ccc080e7          	jalr	-820(ra) # 54f2 <exit>

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
     84c:	7e050513          	addi	a0,a0,2016 # 6028 <malloc+0x700>
     850:	00005097          	auipc	ra,0x5
     854:	ce2080e7          	jalr	-798(ra) # 5532 <open>
  if(fd < 0){
     858:	0a054d63          	bltz	a0,912 <writetest+0xe4>
     85c:	892a                	mv	s2,a0
     85e:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     860:	00005997          	auipc	s3,0x5
     864:	7f098993          	addi	s3,s3,2032 # 6050 <malloc+0x728>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     868:	00006a97          	auipc	s5,0x6
     86c:	820a8a93          	addi	s5,s5,-2016 # 6088 <malloc+0x760>
  for(i = 0; i < N; i++){
     870:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     874:	4629                	li	a2,10
     876:	85ce                	mv	a1,s3
     878:	854a                	mv	a0,s2
     87a:	00005097          	auipc	ra,0x5
     87e:	c98080e7          	jalr	-872(ra) # 5512 <write>
     882:	47a9                	li	a5,10
     884:	0af51563          	bne	a0,a5,92e <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     888:	4629                	li	a2,10
     88a:	85d6                	mv	a1,s5
     88c:	854a                	mv	a0,s2
     88e:	00005097          	auipc	ra,0x5
     892:	c84080e7          	jalr	-892(ra) # 5512 <write>
     896:	47a9                	li	a5,10
     898:	0af51963          	bne	a0,a5,94a <writetest+0x11c>
  for(i = 0; i < N; i++){
     89c:	2485                	addiw	s1,s1,1
     89e:	fd449be3          	bne	s1,s4,874 <writetest+0x46>
  close(fd);
     8a2:	854a                	mv	a0,s2
     8a4:	00005097          	auipc	ra,0x5
     8a8:	c76080e7          	jalr	-906(ra) # 551a <close>
  fd = open("small", O_RDONLY);
     8ac:	4581                	li	a1,0
     8ae:	00005517          	auipc	a0,0x5
     8b2:	77a50513          	addi	a0,a0,1914 # 6028 <malloc+0x700>
     8b6:	00005097          	auipc	ra,0x5
     8ba:	c7c080e7          	jalr	-900(ra) # 5532 <open>
     8be:	84aa                	mv	s1,a0
  if(fd < 0){
     8c0:	0a054363          	bltz	a0,966 <writetest+0x138>
  i = read(fd, buf, N*SZ*2);
     8c4:	7d000613          	li	a2,2000
     8c8:	0000b597          	auipc	a1,0xb
     8cc:	0a858593          	addi	a1,a1,168 # b970 <buf>
     8d0:	00005097          	auipc	ra,0x5
     8d4:	c3a080e7          	jalr	-966(ra) # 550a <read>
  if(i != N*SZ*2){
     8d8:	7d000793          	li	a5,2000
     8dc:	0af51363          	bne	a0,a5,982 <writetest+0x154>
  close(fd);
     8e0:	8526                	mv	a0,s1
     8e2:	00005097          	auipc	ra,0x5
     8e6:	c38080e7          	jalr	-968(ra) # 551a <close>
  if(unlink("small") < 0){
     8ea:	00005517          	auipc	a0,0x5
     8ee:	73e50513          	addi	a0,a0,1854 # 6028 <malloc+0x700>
     8f2:	00005097          	auipc	ra,0x5
     8f6:	c50080e7          	jalr	-944(ra) # 5542 <unlink>
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
     918:	71c50513          	addi	a0,a0,1820 # 6030 <malloc+0x708>
     91c:	00005097          	auipc	ra,0x5
     920:	f4e080e7          	jalr	-178(ra) # 586a <printf>
    exit(1);
     924:	4505                	li	a0,1
     926:	00005097          	auipc	ra,0x5
     92a:	bcc080e7          	jalr	-1076(ra) # 54f2 <exit>
      printf("%s: error: write aa %d new file failed\n", i);
     92e:	85a6                	mv	a1,s1
     930:	00005517          	auipc	a0,0x5
     934:	73050513          	addi	a0,a0,1840 # 6060 <malloc+0x738>
     938:	00005097          	auipc	ra,0x5
     93c:	f32080e7          	jalr	-206(ra) # 586a <printf>
      exit(1);
     940:	4505                	li	a0,1
     942:	00005097          	auipc	ra,0x5
     946:	bb0080e7          	jalr	-1104(ra) # 54f2 <exit>
      printf("%s: error: write bb %d new file failed\n", i);
     94a:	85a6                	mv	a1,s1
     94c:	00005517          	auipc	a0,0x5
     950:	74c50513          	addi	a0,a0,1868 # 6098 <malloc+0x770>
     954:	00005097          	auipc	ra,0x5
     958:	f16080e7          	jalr	-234(ra) # 586a <printf>
      exit(1);
     95c:	4505                	li	a0,1
     95e:	00005097          	auipc	ra,0x5
     962:	b94080e7          	jalr	-1132(ra) # 54f2 <exit>
    printf("%s: error: open small failed!\n", s);
     966:	85da                	mv	a1,s6
     968:	00005517          	auipc	a0,0x5
     96c:	75850513          	addi	a0,a0,1880 # 60c0 <malloc+0x798>
     970:	00005097          	auipc	ra,0x5
     974:	efa080e7          	jalr	-262(ra) # 586a <printf>
    exit(1);
     978:	4505                	li	a0,1
     97a:	00005097          	auipc	ra,0x5
     97e:	b78080e7          	jalr	-1160(ra) # 54f2 <exit>
    printf("%s: read failed\n", s);
     982:	85da                	mv	a1,s6
     984:	00005517          	auipc	a0,0x5
     988:	75c50513          	addi	a0,a0,1884 # 60e0 <malloc+0x7b8>
     98c:	00005097          	auipc	ra,0x5
     990:	ede080e7          	jalr	-290(ra) # 586a <printf>
    exit(1);
     994:	4505                	li	a0,1
     996:	00005097          	auipc	ra,0x5
     99a:	b5c080e7          	jalr	-1188(ra) # 54f2 <exit>
    printf("%s: unlink small failed\n", s);
     99e:	85da                	mv	a1,s6
     9a0:	00005517          	auipc	a0,0x5
     9a4:	75850513          	addi	a0,a0,1880 # 60f8 <malloc+0x7d0>
     9a8:	00005097          	auipc	ra,0x5
     9ac:	ec2080e7          	jalr	-318(ra) # 586a <printf>
    exit(1);
     9b0:	4505                	li	a0,1
     9b2:	00005097          	auipc	ra,0x5
     9b6:	b40080e7          	jalr	-1216(ra) # 54f2 <exit>

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
     9d6:	74650513          	addi	a0,a0,1862 # 6118 <malloc+0x7f0>
     9da:	00005097          	auipc	ra,0x5
     9de:	b58080e7          	jalr	-1192(ra) # 5532 <open>
     9e2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e6:	0000b917          	auipc	s2,0xb
     9ea:	f8a90913          	addi	s2,s2,-118 # b970 <buf>
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
     a06:	b10080e7          	jalr	-1264(ra) # 5512 <write>
     a0a:	40000793          	li	a5,1024
     a0e:	06f51c63          	bne	a0,a5,a86 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a12:	2485                	addiw	s1,s1,1
     a14:	ff4491e3          	bne	s1,s4,9f6 <writebig+0x3c>
  close(fd);
     a18:	854e                	mv	a0,s3
     a1a:	00005097          	auipc	ra,0x5
     a1e:	b00080e7          	jalr	-1280(ra) # 551a <close>
  fd = open("big", O_RDONLY);
     a22:	4581                	li	a1,0
     a24:	00005517          	auipc	a0,0x5
     a28:	6f450513          	addi	a0,a0,1780 # 6118 <malloc+0x7f0>
     a2c:	00005097          	auipc	ra,0x5
     a30:	b06080e7          	jalr	-1274(ra) # 5532 <open>
     a34:	89aa                	mv	s3,a0
  n = 0;
     a36:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a38:	0000b917          	auipc	s2,0xb
     a3c:	f3890913          	addi	s2,s2,-200 # b970 <buf>
  if(fd < 0){
     a40:	06054163          	bltz	a0,aa2 <writebig+0xe8>
    i = read(fd, buf, BSIZE);
     a44:	40000613          	li	a2,1024
     a48:	85ca                	mv	a1,s2
     a4a:	854e                	mv	a0,s3
     a4c:	00005097          	auipc	ra,0x5
     a50:	abe080e7          	jalr	-1346(ra) # 550a <read>
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
     a70:	6b450513          	addi	a0,a0,1716 # 6120 <malloc+0x7f8>
     a74:	00005097          	auipc	ra,0x5
     a78:	df6080e7          	jalr	-522(ra) # 586a <printf>
    exit(1);
     a7c:	4505                	li	a0,1
     a7e:	00005097          	auipc	ra,0x5
     a82:	a74080e7          	jalr	-1420(ra) # 54f2 <exit>
      printf("%s: error: write big file failed\n", i);
     a86:	85a6                	mv	a1,s1
     a88:	00005517          	auipc	a0,0x5
     a8c:	6b850513          	addi	a0,a0,1720 # 6140 <malloc+0x818>
     a90:	00005097          	auipc	ra,0x5
     a94:	dda080e7          	jalr	-550(ra) # 586a <printf>
      exit(1);
     a98:	4505                	li	a0,1
     a9a:	00005097          	auipc	ra,0x5
     a9e:	a58080e7          	jalr	-1448(ra) # 54f2 <exit>
    printf("%s: error: open big failed!\n", s);
     aa2:	85d6                	mv	a1,s5
     aa4:	00005517          	auipc	a0,0x5
     aa8:	6c450513          	addi	a0,a0,1732 # 6168 <malloc+0x840>
     aac:	00005097          	auipc	ra,0x5
     ab0:	dbe080e7          	jalr	-578(ra) # 586a <printf>
    exit(1);
     ab4:	4505                	li	a0,1
     ab6:	00005097          	auipc	ra,0x5
     aba:	a3c080e7          	jalr	-1476(ra) # 54f2 <exit>
      if(n == MAXFILE - 1){
     abe:	10b00793          	li	a5,267
     ac2:	02f48a63          	beq	s1,a5,af6 <writebig+0x13c>
  close(fd);
     ac6:	854e                	mv	a0,s3
     ac8:	00005097          	auipc	ra,0x5
     acc:	a52080e7          	jalr	-1454(ra) # 551a <close>
  if(unlink("big") < 0){
     ad0:	00005517          	auipc	a0,0x5
     ad4:	64850513          	addi	a0,a0,1608 # 6118 <malloc+0x7f0>
     ad8:	00005097          	auipc	ra,0x5
     adc:	a6a080e7          	jalr	-1430(ra) # 5542 <unlink>
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
     afe:	68e50513          	addi	a0,a0,1678 # 6188 <malloc+0x860>
     b02:	00005097          	auipc	ra,0x5
     b06:	d68080e7          	jalr	-664(ra) # 586a <printf>
        exit(1);
     b0a:	4505                	li	a0,1
     b0c:	00005097          	auipc	ra,0x5
     b10:	9e6080e7          	jalr	-1562(ra) # 54f2 <exit>
      printf("%s: read failed %d\n", i);
     b14:	85aa                	mv	a1,a0
     b16:	00005517          	auipc	a0,0x5
     b1a:	69a50513          	addi	a0,a0,1690 # 61b0 <malloc+0x888>
     b1e:	00005097          	auipc	ra,0x5
     b22:	d4c080e7          	jalr	-692(ra) # 586a <printf>
      exit(1);
     b26:	4505                	li	a0,1
     b28:	00005097          	auipc	ra,0x5
     b2c:	9ca080e7          	jalr	-1590(ra) # 54f2 <exit>
      printf("%s: read content of block %d is %d\n",
     b30:	85a6                	mv	a1,s1
     b32:	00005517          	auipc	a0,0x5
     b36:	69650513          	addi	a0,a0,1686 # 61c8 <malloc+0x8a0>
     b3a:	00005097          	auipc	ra,0x5
     b3e:	d30080e7          	jalr	-720(ra) # 586a <printf>
      exit(1);
     b42:	4505                	li	a0,1
     b44:	00005097          	auipc	ra,0x5
     b48:	9ae080e7          	jalr	-1618(ra) # 54f2 <exit>
    printf("%s: unlink big failed\n", s);
     b4c:	85d6                	mv	a1,s5
     b4e:	00005517          	auipc	a0,0x5
     b52:	6a250513          	addi	a0,a0,1698 # 61f0 <malloc+0x8c8>
     b56:	00005097          	auipc	ra,0x5
     b5a:	d14080e7          	jalr	-748(ra) # 586a <printf>
    exit(1);
     b5e:	4505                	li	a0,1
     b60:	00005097          	auipc	ra,0x5
     b64:	992080e7          	jalr	-1646(ra) # 54f2 <exit>

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
     b80:	fe450513          	addi	a0,a0,-28 # 5b60 <malloc+0x238>
     b84:	00005097          	auipc	ra,0x5
     b88:	9ae080e7          	jalr	-1618(ra) # 5532 <open>
  if(fd < 0){
     b8c:	0e054563          	bltz	a0,c76 <unlinkread+0x10e>
     b90:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b92:	4615                	li	a2,5
     b94:	00005597          	auipc	a1,0x5
     b98:	69458593          	addi	a1,a1,1684 # 6228 <malloc+0x900>
     b9c:	00005097          	auipc	ra,0x5
     ba0:	976080e7          	jalr	-1674(ra) # 5512 <write>
  close(fd);
     ba4:	8526                	mv	a0,s1
     ba6:	00005097          	auipc	ra,0x5
     baa:	974080e7          	jalr	-1676(ra) # 551a <close>
  fd = open("unlinkread", O_RDWR);
     bae:	4589                	li	a1,2
     bb0:	00005517          	auipc	a0,0x5
     bb4:	fb050513          	addi	a0,a0,-80 # 5b60 <malloc+0x238>
     bb8:	00005097          	auipc	ra,0x5
     bbc:	97a080e7          	jalr	-1670(ra) # 5532 <open>
     bc0:	84aa                	mv	s1,a0
  if(fd < 0){
     bc2:	0c054863          	bltz	a0,c92 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bc6:	00005517          	auipc	a0,0x5
     bca:	f9a50513          	addi	a0,a0,-102 # 5b60 <malloc+0x238>
     bce:	00005097          	auipc	ra,0x5
     bd2:	974080e7          	jalr	-1676(ra) # 5542 <unlink>
     bd6:	ed61                	bnez	a0,cae <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd8:	20200593          	li	a1,514
     bdc:	00005517          	auipc	a0,0x5
     be0:	f8450513          	addi	a0,a0,-124 # 5b60 <malloc+0x238>
     be4:	00005097          	auipc	ra,0x5
     be8:	94e080e7          	jalr	-1714(ra) # 5532 <open>
     bec:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     bee:	460d                	li	a2,3
     bf0:	00005597          	auipc	a1,0x5
     bf4:	68058593          	addi	a1,a1,1664 # 6270 <malloc+0x948>
     bf8:	00005097          	auipc	ra,0x5
     bfc:	91a080e7          	jalr	-1766(ra) # 5512 <write>
  close(fd1);
     c00:	854a                	mv	a0,s2
     c02:	00005097          	auipc	ra,0x5
     c06:	918080e7          	jalr	-1768(ra) # 551a <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c0a:	660d                	lui	a2,0x3
     c0c:	0000b597          	auipc	a1,0xb
     c10:	d6458593          	addi	a1,a1,-668 # b970 <buf>
     c14:	8526                	mv	a0,s1
     c16:	00005097          	auipc	ra,0x5
     c1a:	8f4080e7          	jalr	-1804(ra) # 550a <read>
     c1e:	4795                	li	a5,5
     c20:	0af51563          	bne	a0,a5,cca <unlinkread+0x162>
  if(buf[0] != 'h'){
     c24:	0000b717          	auipc	a4,0xb
     c28:	d4c74703          	lbu	a4,-692(a4) # b970 <buf>
     c2c:	06800793          	li	a5,104
     c30:	0af71b63          	bne	a4,a5,ce6 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c34:	4629                	li	a2,10
     c36:	0000b597          	auipc	a1,0xb
     c3a:	d3a58593          	addi	a1,a1,-710 # b970 <buf>
     c3e:	8526                	mv	a0,s1
     c40:	00005097          	auipc	ra,0x5
     c44:	8d2080e7          	jalr	-1838(ra) # 5512 <write>
     c48:	47a9                	li	a5,10
     c4a:	0af51c63          	bne	a0,a5,d02 <unlinkread+0x19a>
  close(fd);
     c4e:	8526                	mv	a0,s1
     c50:	00005097          	auipc	ra,0x5
     c54:	8ca080e7          	jalr	-1846(ra) # 551a <close>
  unlink("unlinkread");
     c58:	00005517          	auipc	a0,0x5
     c5c:	f0850513          	addi	a0,a0,-248 # 5b60 <malloc+0x238>
     c60:	00005097          	auipc	ra,0x5
     c64:	8e2080e7          	jalr	-1822(ra) # 5542 <unlink>
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
     c7c:	59050513          	addi	a0,a0,1424 # 6208 <malloc+0x8e0>
     c80:	00005097          	auipc	ra,0x5
     c84:	bea080e7          	jalr	-1046(ra) # 586a <printf>
    exit(1);
     c88:	4505                	li	a0,1
     c8a:	00005097          	auipc	ra,0x5
     c8e:	868080e7          	jalr	-1944(ra) # 54f2 <exit>
    printf("%s: open unlinkread failed\n", s);
     c92:	85ce                	mv	a1,s3
     c94:	00005517          	auipc	a0,0x5
     c98:	59c50513          	addi	a0,a0,1436 # 6230 <malloc+0x908>
     c9c:	00005097          	auipc	ra,0x5
     ca0:	bce080e7          	jalr	-1074(ra) # 586a <printf>
    exit(1);
     ca4:	4505                	li	a0,1
     ca6:	00005097          	auipc	ra,0x5
     caa:	84c080e7          	jalr	-1972(ra) # 54f2 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     cae:	85ce                	mv	a1,s3
     cb0:	00005517          	auipc	a0,0x5
     cb4:	5a050513          	addi	a0,a0,1440 # 6250 <malloc+0x928>
     cb8:	00005097          	auipc	ra,0x5
     cbc:	bb2080e7          	jalr	-1102(ra) # 586a <printf>
    exit(1);
     cc0:	4505                	li	a0,1
     cc2:	00005097          	auipc	ra,0x5
     cc6:	830080e7          	jalr	-2000(ra) # 54f2 <exit>
    printf("%s: unlinkread read failed", s);
     cca:	85ce                	mv	a1,s3
     ccc:	00005517          	auipc	a0,0x5
     cd0:	5ac50513          	addi	a0,a0,1452 # 6278 <malloc+0x950>
     cd4:	00005097          	auipc	ra,0x5
     cd8:	b96080e7          	jalr	-1130(ra) # 586a <printf>
    exit(1);
     cdc:	4505                	li	a0,1
     cde:	00005097          	auipc	ra,0x5
     ce2:	814080e7          	jalr	-2028(ra) # 54f2 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ce6:	85ce                	mv	a1,s3
     ce8:	00005517          	auipc	a0,0x5
     cec:	5b050513          	addi	a0,a0,1456 # 6298 <malloc+0x970>
     cf0:	00005097          	auipc	ra,0x5
     cf4:	b7a080e7          	jalr	-1158(ra) # 586a <printf>
    exit(1);
     cf8:	4505                	li	a0,1
     cfa:	00004097          	auipc	ra,0x4
     cfe:	7f8080e7          	jalr	2040(ra) # 54f2 <exit>
    printf("%s: unlinkread write failed\n", s);
     d02:	85ce                	mv	a1,s3
     d04:	00005517          	auipc	a0,0x5
     d08:	5b450513          	addi	a0,a0,1460 # 62b8 <malloc+0x990>
     d0c:	00005097          	auipc	ra,0x5
     d10:	b5e080e7          	jalr	-1186(ra) # 586a <printf>
    exit(1);
     d14:	4505                	li	a0,1
     d16:	00004097          	auipc	ra,0x4
     d1a:	7dc080e7          	jalr	2012(ra) # 54f2 <exit>

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
     d30:	5ac50513          	addi	a0,a0,1452 # 62d8 <malloc+0x9b0>
     d34:	00005097          	auipc	ra,0x5
     d38:	80e080e7          	jalr	-2034(ra) # 5542 <unlink>
  unlink("lf2");
     d3c:	00005517          	auipc	a0,0x5
     d40:	5a450513          	addi	a0,a0,1444 # 62e0 <malloc+0x9b8>
     d44:	00004097          	auipc	ra,0x4
     d48:	7fe080e7          	jalr	2046(ra) # 5542 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d4c:	20200593          	li	a1,514
     d50:	00005517          	auipc	a0,0x5
     d54:	58850513          	addi	a0,a0,1416 # 62d8 <malloc+0x9b0>
     d58:	00004097          	auipc	ra,0x4
     d5c:	7da080e7          	jalr	2010(ra) # 5532 <open>
  if(fd < 0){
     d60:	10054763          	bltz	a0,e6e <linktest+0x150>
     d64:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d66:	4615                	li	a2,5
     d68:	00005597          	auipc	a1,0x5
     d6c:	4c058593          	addi	a1,a1,1216 # 6228 <malloc+0x900>
     d70:	00004097          	auipc	ra,0x4
     d74:	7a2080e7          	jalr	1954(ra) # 5512 <write>
     d78:	4795                	li	a5,5
     d7a:	10f51863          	bne	a0,a5,e8a <linktest+0x16c>
  close(fd);
     d7e:	8526                	mv	a0,s1
     d80:	00004097          	auipc	ra,0x4
     d84:	79a080e7          	jalr	1946(ra) # 551a <close>
  if(link("lf1", "lf2") < 0){
     d88:	00005597          	auipc	a1,0x5
     d8c:	55858593          	addi	a1,a1,1368 # 62e0 <malloc+0x9b8>
     d90:	00005517          	auipc	a0,0x5
     d94:	54850513          	addi	a0,a0,1352 # 62d8 <malloc+0x9b0>
     d98:	00004097          	auipc	ra,0x4
     d9c:	7ba080e7          	jalr	1978(ra) # 5552 <link>
     da0:	10054363          	bltz	a0,ea6 <linktest+0x188>
  unlink("lf1");
     da4:	00005517          	auipc	a0,0x5
     da8:	53450513          	addi	a0,a0,1332 # 62d8 <malloc+0x9b0>
     dac:	00004097          	auipc	ra,0x4
     db0:	796080e7          	jalr	1942(ra) # 5542 <unlink>
  if(open("lf1", 0) >= 0){
     db4:	4581                	li	a1,0
     db6:	00005517          	auipc	a0,0x5
     dba:	52250513          	addi	a0,a0,1314 # 62d8 <malloc+0x9b0>
     dbe:	00004097          	auipc	ra,0x4
     dc2:	774080e7          	jalr	1908(ra) # 5532 <open>
     dc6:	0e055e63          	bgez	a0,ec2 <linktest+0x1a4>
  fd = open("lf2", 0);
     dca:	4581                	li	a1,0
     dcc:	00005517          	auipc	a0,0x5
     dd0:	51450513          	addi	a0,a0,1300 # 62e0 <malloc+0x9b8>
     dd4:	00004097          	auipc	ra,0x4
     dd8:	75e080e7          	jalr	1886(ra) # 5532 <open>
     ddc:	84aa                	mv	s1,a0
  if(fd < 0){
     dde:	10054063          	bltz	a0,ede <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de2:	660d                	lui	a2,0x3
     de4:	0000b597          	auipc	a1,0xb
     de8:	b8c58593          	addi	a1,a1,-1140 # b970 <buf>
     dec:	00004097          	auipc	ra,0x4
     df0:	71e080e7          	jalr	1822(ra) # 550a <read>
     df4:	4795                	li	a5,5
     df6:	10f51263          	bne	a0,a5,efa <linktest+0x1dc>
  close(fd);
     dfa:	8526                	mv	a0,s1
     dfc:	00004097          	auipc	ra,0x4
     e00:	71e080e7          	jalr	1822(ra) # 551a <close>
  if(link("lf2", "lf2") >= 0){
     e04:	00005597          	auipc	a1,0x5
     e08:	4dc58593          	addi	a1,a1,1244 # 62e0 <malloc+0x9b8>
     e0c:	852e                	mv	a0,a1
     e0e:	00004097          	auipc	ra,0x4
     e12:	744080e7          	jalr	1860(ra) # 5552 <link>
     e16:	10055063          	bgez	a0,f16 <linktest+0x1f8>
  unlink("lf2");
     e1a:	00005517          	auipc	a0,0x5
     e1e:	4c650513          	addi	a0,a0,1222 # 62e0 <malloc+0x9b8>
     e22:	00004097          	auipc	ra,0x4
     e26:	720080e7          	jalr	1824(ra) # 5542 <unlink>
  if(link("lf2", "lf1") >= 0){
     e2a:	00005597          	auipc	a1,0x5
     e2e:	4ae58593          	addi	a1,a1,1198 # 62d8 <malloc+0x9b0>
     e32:	00005517          	auipc	a0,0x5
     e36:	4ae50513          	addi	a0,a0,1198 # 62e0 <malloc+0x9b8>
     e3a:	00004097          	auipc	ra,0x4
     e3e:	718080e7          	jalr	1816(ra) # 5552 <link>
     e42:	0e055863          	bgez	a0,f32 <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e46:	00005597          	auipc	a1,0x5
     e4a:	49258593          	addi	a1,a1,1170 # 62d8 <malloc+0x9b0>
     e4e:	00005517          	auipc	a0,0x5
     e52:	59a50513          	addi	a0,a0,1434 # 63e8 <malloc+0xac0>
     e56:	00004097          	auipc	ra,0x4
     e5a:	6fc080e7          	jalr	1788(ra) # 5552 <link>
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
     e74:	47850513          	addi	a0,a0,1144 # 62e8 <malloc+0x9c0>
     e78:	00005097          	auipc	ra,0x5
     e7c:	9f2080e7          	jalr	-1550(ra) # 586a <printf>
    exit(1);
     e80:	4505                	li	a0,1
     e82:	00004097          	auipc	ra,0x4
     e86:	670080e7          	jalr	1648(ra) # 54f2 <exit>
    printf("%s: write lf1 failed\n", s);
     e8a:	85ca                	mv	a1,s2
     e8c:	00005517          	auipc	a0,0x5
     e90:	47450513          	addi	a0,a0,1140 # 6300 <malloc+0x9d8>
     e94:	00005097          	auipc	ra,0x5
     e98:	9d6080e7          	jalr	-1578(ra) # 586a <printf>
    exit(1);
     e9c:	4505                	li	a0,1
     e9e:	00004097          	auipc	ra,0x4
     ea2:	654080e7          	jalr	1620(ra) # 54f2 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     ea6:	85ca                	mv	a1,s2
     ea8:	00005517          	auipc	a0,0x5
     eac:	47050513          	addi	a0,a0,1136 # 6318 <malloc+0x9f0>
     eb0:	00005097          	auipc	ra,0x5
     eb4:	9ba080e7          	jalr	-1606(ra) # 586a <printf>
    exit(1);
     eb8:	4505                	li	a0,1
     eba:	00004097          	auipc	ra,0x4
     ebe:	638080e7          	jalr	1592(ra) # 54f2 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     ec2:	85ca                	mv	a1,s2
     ec4:	00005517          	auipc	a0,0x5
     ec8:	47450513          	addi	a0,a0,1140 # 6338 <malloc+0xa10>
     ecc:	00005097          	auipc	ra,0x5
     ed0:	99e080e7          	jalr	-1634(ra) # 586a <printf>
    exit(1);
     ed4:	4505                	li	a0,1
     ed6:	00004097          	auipc	ra,0x4
     eda:	61c080e7          	jalr	1564(ra) # 54f2 <exit>
    printf("%s: open lf2 failed\n", s);
     ede:	85ca                	mv	a1,s2
     ee0:	00005517          	auipc	a0,0x5
     ee4:	48850513          	addi	a0,a0,1160 # 6368 <malloc+0xa40>
     ee8:	00005097          	auipc	ra,0x5
     eec:	982080e7          	jalr	-1662(ra) # 586a <printf>
    exit(1);
     ef0:	4505                	li	a0,1
     ef2:	00004097          	auipc	ra,0x4
     ef6:	600080e7          	jalr	1536(ra) # 54f2 <exit>
    printf("%s: read lf2 failed\n", s);
     efa:	85ca                	mv	a1,s2
     efc:	00005517          	auipc	a0,0x5
     f00:	48450513          	addi	a0,a0,1156 # 6380 <malloc+0xa58>
     f04:	00005097          	auipc	ra,0x5
     f08:	966080e7          	jalr	-1690(ra) # 586a <printf>
    exit(1);
     f0c:	4505                	li	a0,1
     f0e:	00004097          	auipc	ra,0x4
     f12:	5e4080e7          	jalr	1508(ra) # 54f2 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f16:	85ca                	mv	a1,s2
     f18:	00005517          	auipc	a0,0x5
     f1c:	48050513          	addi	a0,a0,1152 # 6398 <malloc+0xa70>
     f20:	00005097          	auipc	ra,0x5
     f24:	94a080e7          	jalr	-1718(ra) # 586a <printf>
    exit(1);
     f28:	4505                	li	a0,1
     f2a:	00004097          	auipc	ra,0x4
     f2e:	5c8080e7          	jalr	1480(ra) # 54f2 <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f32:	85ca                	mv	a1,s2
     f34:	00005517          	auipc	a0,0x5
     f38:	48c50513          	addi	a0,a0,1164 # 63c0 <malloc+0xa98>
     f3c:	00005097          	auipc	ra,0x5
     f40:	92e080e7          	jalr	-1746(ra) # 586a <printf>
    exit(1);
     f44:	4505                	li	a0,1
     f46:	00004097          	auipc	ra,0x4
     f4a:	5ac080e7          	jalr	1452(ra) # 54f2 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f4e:	85ca                	mv	a1,s2
     f50:	00005517          	auipc	a0,0x5
     f54:	4a050513          	addi	a0,a0,1184 # 63f0 <malloc+0xac8>
     f58:	00005097          	auipc	ra,0x5
     f5c:	912080e7          	jalr	-1774(ra) # 586a <printf>
    exit(1);
     f60:	4505                	li	a0,1
     f62:	00004097          	auipc	ra,0x4
     f66:	590080e7          	jalr	1424(ra) # 54f2 <exit>

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
     f84:	49050513          	addi	a0,a0,1168 # 6410 <malloc+0xae8>
     f88:	00004097          	auipc	ra,0x4
     f8c:	5ba080e7          	jalr	1466(ra) # 5542 <unlink>
  fd = open("bd", O_CREATE);
     f90:	20000593          	li	a1,512
     f94:	00005517          	auipc	a0,0x5
     f98:	47c50513          	addi	a0,a0,1148 # 6410 <malloc+0xae8>
     f9c:	00004097          	auipc	ra,0x4
     fa0:	596080e7          	jalr	1430(ra) # 5532 <open>
  if(fd < 0){
     fa4:	0c054963          	bltz	a0,1076 <bigdir+0x10c>
  close(fd);
     fa8:	00004097          	auipc	ra,0x4
     fac:	572080e7          	jalr	1394(ra) # 551a <close>
  for(i = 0; i < N; i++){
     fb0:	4901                	li	s2,0
    name[0] = 'x';
     fb2:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fb6:	00005a17          	auipc	s4,0x5
     fba:	45aa0a13          	addi	s4,s4,1114 # 6410 <malloc+0xae8>
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
     ffa:	55c080e7          	jalr	1372(ra) # 5552 <link>
     ffe:	84aa                	mv	s1,a0
    1000:	e949                	bnez	a0,1092 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1002:	2905                	addiw	s2,s2,1
    1004:	fb691fe3          	bne	s2,s6,fc2 <bigdir+0x58>
  unlink("bd");
    1008:	00005517          	auipc	a0,0x5
    100c:	40850513          	addi	a0,a0,1032 # 6410 <malloc+0xae8>
    1010:	00004097          	auipc	ra,0x4
    1014:	532080e7          	jalr	1330(ra) # 5542 <unlink>
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
    1056:	4f0080e7          	jalr	1264(ra) # 5542 <unlink>
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
    107c:	3a050513          	addi	a0,a0,928 # 6418 <malloc+0xaf0>
    1080:	00004097          	auipc	ra,0x4
    1084:	7ea080e7          	jalr	2026(ra) # 586a <printf>
    exit(1);
    1088:	4505                	li	a0,1
    108a:	00004097          	auipc	ra,0x4
    108e:	468080e7          	jalr	1128(ra) # 54f2 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    1092:	fb040613          	addi	a2,s0,-80
    1096:	85ce                	mv	a1,s3
    1098:	00005517          	auipc	a0,0x5
    109c:	3a050513          	addi	a0,a0,928 # 6438 <malloc+0xb10>
    10a0:	00004097          	auipc	ra,0x4
    10a4:	7ca080e7          	jalr	1994(ra) # 586a <printf>
      exit(1);
    10a8:	4505                	li	a0,1
    10aa:	00004097          	auipc	ra,0x4
    10ae:	448080e7          	jalr	1096(ra) # 54f2 <exit>
      printf("%s: bigdir unlink failed", s);
    10b2:	85ce                	mv	a1,s3
    10b4:	00005517          	auipc	a0,0x5
    10b8:	3a450513          	addi	a0,a0,932 # 6458 <malloc+0xb30>
    10bc:	00004097          	auipc	ra,0x4
    10c0:	7ae080e7          	jalr	1966(ra) # 586a <printf>
      exit(1);
    10c4:	4505                	li	a0,1
    10c6:	00004097          	auipc	ra,0x4
    10ca:	42c080e7          	jalr	1068(ra) # 54f2 <exit>

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
    10ea:	39298993          	addi	s3,s3,914 # 6478 <malloc+0xb50>
    10ee:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10f0:	6a85                	lui	s5,0x1
    10f2:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10f6:	85a6                	mv	a1,s1
    10f8:	854e                	mv	a0,s3
    10fa:	00004097          	auipc	ra,0x4
    10fe:	458080e7          	jalr	1112(ra) # 5552 <link>
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
    1126:	36650513          	addi	a0,a0,870 # 6488 <malloc+0xb60>
    112a:	00004097          	auipc	ra,0x4
    112e:	740080e7          	jalr	1856(ra) # 586a <printf>
      exit(1);
    1132:	4505                	li	a0,1
    1134:	00004097          	auipc	ra,0x4
    1138:	3be080e7          	jalr	958(ra) # 54f2 <exit>

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
    114e:	fee4b483          	ld	s1,-18(s1) # 8138 <__SDATA_BEGIN__>
    1152:	fd840593          	addi	a1,s0,-40
    1156:	8526                	mv	a0,s1
    1158:	00004097          	auipc	ra,0x4
    115c:	3d2080e7          	jalr	978(ra) # 552a <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1160:	8526                	mv	a0,s1
    1162:	00004097          	auipc	ra,0x4
    1166:	3a0080e7          	jalr	928(ra) # 5502 <pipe>

  exit(0);
    116a:	4501                	li	a0,0
    116c:	00004097          	auipc	ra,0x4
    1170:	386080e7          	jalr	902(ra) # 54f2 <exit>

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
    1184:	35048493          	addi	s1,s1,848 # c350 <buf+0x9e0>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1188:	597d                	li	s2,-1
    118a:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    118e:	00005997          	auipc	s3,0x5
    1192:	bc298993          	addi	s3,s3,-1086 # 5d50 <malloc+0x428>
    argv[0] = (char*)0xffffffff;
    1196:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    119a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    119e:	fc040593          	addi	a1,s0,-64
    11a2:	854e                	mv	a0,s3
    11a4:	00004097          	auipc	ra,0x4
    11a8:	386080e7          	jalr	902(ra) # 552a <exec>
  for(int i = 0; i < 50000; i++){
    11ac:	34fd                	addiw	s1,s1,-1
    11ae:	f4e5                	bnez	s1,1196 <badarg+0x22>
  }
  
  exit(0);
    11b0:	4501                	li	a0,0
    11b2:	00004097          	auipc	ra,0x4
    11b6:	340080e7          	jalr	832(ra) # 54f2 <exit>

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
    11e4:	362080e7          	jalr	866(ra) # 5542 <unlink>
  if(ret != -1){
    11e8:	57fd                	li	a5,-1
    11ea:	0ef51063          	bne	a0,a5,12ca <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11ee:	20100593          	li	a1,513
    11f2:	f6840513          	addi	a0,s0,-152
    11f6:	00004097          	auipc	ra,0x4
    11fa:	33c080e7          	jalr	828(ra) # 5532 <open>
  if(fd != -1){
    11fe:	57fd                	li	a5,-1
    1200:	0ef51563          	bne	a0,a5,12ea <copyinstr2+0x130>
  ret = link(b, b);
    1204:	f6840593          	addi	a1,s0,-152
    1208:	852e                	mv	a0,a1
    120a:	00004097          	auipc	ra,0x4
    120e:	348080e7          	jalr	840(ra) # 5552 <link>
  if(ret != -1){
    1212:	57fd                	li	a5,-1
    1214:	0ef51b63          	bne	a0,a5,130a <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1218:	00006797          	auipc	a5,0x6
    121c:	3d878793          	addi	a5,a5,984 # 75f0 <malloc+0x1cc8>
    1220:	f4f43c23          	sd	a5,-168(s0)
    1224:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1228:	f5840593          	addi	a1,s0,-168
    122c:	f6840513          	addi	a0,s0,-152
    1230:	00004097          	auipc	ra,0x4
    1234:	2fa080e7          	jalr	762(ra) # 552a <exec>
  if(ret != -1){
    1238:	57fd                	li	a5,-1
    123a:	0ef51963          	bne	a0,a5,132c <copyinstr2+0x172>
  int pid = fork();
    123e:	00004097          	auipc	ra,0x4
    1242:	2ac080e7          	jalr	684(ra) # 54ea <fork>
  if(pid < 0){
    1246:	10054363          	bltz	a0,134c <copyinstr2+0x192>
  if(pid == 0){
    124a:	12051463          	bnez	a0,1372 <copyinstr2+0x1b8>
    124e:	00007797          	auipc	a5,0x7
    1252:	00a78793          	addi	a5,a5,10 # 8258 <big.1265>
    1256:	00008697          	auipc	a3,0x8
    125a:	00268693          	addi	a3,a3,2 # 9258 <__global_pointer$+0x920>
      big[i] = 'x';
    125e:	07800713          	li	a4,120
    1262:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1266:	0785                	addi	a5,a5,1
    1268:	fed79de3          	bne	a5,a3,1262 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    126c:	00008797          	auipc	a5,0x8
    1270:	fe078623          	sb	zero,-20(a5) # 9258 <__global_pointer$+0x920>
    char *args2[] = { big, big, big, 0 };
    1274:	00007797          	auipc	a5,0x7
    1278:	af478793          	addi	a5,a5,-1292 # 7d68 <malloc+0x2440>
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
    129c:	ab850513          	addi	a0,a0,-1352 # 5d50 <malloc+0x428>
    12a0:	00004097          	auipc	ra,0x4
    12a4:	28a080e7          	jalr	650(ra) # 552a <exec>
    if(ret != -1){
    12a8:	57fd                	li	a5,-1
    12aa:	0af50e63          	beq	a0,a5,1366 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12ae:	55fd                	li	a1,-1
    12b0:	00005517          	auipc	a0,0x5
    12b4:	28050513          	addi	a0,a0,640 # 6530 <malloc+0xc08>
    12b8:	00004097          	auipc	ra,0x4
    12bc:	5b2080e7          	jalr	1458(ra) # 586a <printf>
      exit(1);
    12c0:	4505                	li	a0,1
    12c2:	00004097          	auipc	ra,0x4
    12c6:	230080e7          	jalr	560(ra) # 54f2 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12ca:	862a                	mv	a2,a0
    12cc:	f6840593          	addi	a1,s0,-152
    12d0:	00005517          	auipc	a0,0x5
    12d4:	1d850513          	addi	a0,a0,472 # 64a8 <malloc+0xb80>
    12d8:	00004097          	auipc	ra,0x4
    12dc:	592080e7          	jalr	1426(ra) # 586a <printf>
    exit(1);
    12e0:	4505                	li	a0,1
    12e2:	00004097          	auipc	ra,0x4
    12e6:	210080e7          	jalr	528(ra) # 54f2 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12ea:	862a                	mv	a2,a0
    12ec:	f6840593          	addi	a1,s0,-152
    12f0:	00005517          	auipc	a0,0x5
    12f4:	1d850513          	addi	a0,a0,472 # 64c8 <malloc+0xba0>
    12f8:	00004097          	auipc	ra,0x4
    12fc:	572080e7          	jalr	1394(ra) # 586a <printf>
    exit(1);
    1300:	4505                	li	a0,1
    1302:	00004097          	auipc	ra,0x4
    1306:	1f0080e7          	jalr	496(ra) # 54f2 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    130a:	86aa                	mv	a3,a0
    130c:	f6840613          	addi	a2,s0,-152
    1310:	85b2                	mv	a1,a2
    1312:	00005517          	auipc	a0,0x5
    1316:	1d650513          	addi	a0,a0,470 # 64e8 <malloc+0xbc0>
    131a:	00004097          	auipc	ra,0x4
    131e:	550080e7          	jalr	1360(ra) # 586a <printf>
    exit(1);
    1322:	4505                	li	a0,1
    1324:	00004097          	auipc	ra,0x4
    1328:	1ce080e7          	jalr	462(ra) # 54f2 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    132c:	567d                	li	a2,-1
    132e:	f6840593          	addi	a1,s0,-152
    1332:	00005517          	auipc	a0,0x5
    1336:	1de50513          	addi	a0,a0,478 # 6510 <malloc+0xbe8>
    133a:	00004097          	auipc	ra,0x4
    133e:	530080e7          	jalr	1328(ra) # 586a <printf>
    exit(1);
    1342:	4505                	li	a0,1
    1344:	00004097          	auipc	ra,0x4
    1348:	1ae080e7          	jalr	430(ra) # 54f2 <exit>
    printf("fork failed\n");
    134c:	00005517          	auipc	a0,0x5
    1350:	62c50513          	addi	a0,a0,1580 # 6978 <malloc+0x1050>
    1354:	00004097          	auipc	ra,0x4
    1358:	516080e7          	jalr	1302(ra) # 586a <printf>
    exit(1);
    135c:	4505                	li	a0,1
    135e:	00004097          	auipc	ra,0x4
    1362:	194080e7          	jalr	404(ra) # 54f2 <exit>
    exit(747); // OK
    1366:	2eb00513          	li	a0,747
    136a:	00004097          	auipc	ra,0x4
    136e:	188080e7          	jalr	392(ra) # 54f2 <exit>
  int st = 0;
    1372:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1376:	f5440513          	addi	a0,s0,-172
    137a:	00004097          	auipc	ra,0x4
    137e:	180080e7          	jalr	384(ra) # 54fa <wait>
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
    139a:	1c250513          	addi	a0,a0,450 # 6558 <malloc+0xc30>
    139e:	00004097          	auipc	ra,0x4
    13a2:	4cc080e7          	jalr	1228(ra) # 586a <printf>
    exit(1);
    13a6:	4505                	li	a0,1
    13a8:	00004097          	auipc	ra,0x4
    13ac:	14a080e7          	jalr	330(ra) # 54f2 <exit>

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
    13cc:	9e050513          	addi	a0,a0,-1568 # 5da8 <malloc+0x480>
    13d0:	00004097          	auipc	ra,0x4
    13d4:	162080e7          	jalr	354(ra) # 5532 <open>
    13d8:	00004097          	auipc	ra,0x4
    13dc:	142080e7          	jalr	322(ra) # 551a <close>
  pid = fork();
    13e0:	00004097          	auipc	ra,0x4
    13e4:	10a080e7          	jalr	266(ra) # 54ea <fork>
  if(pid < 0){
    13e8:	08054063          	bltz	a0,1468 <truncate3+0xb8>
  if(pid == 0){
    13ec:	e969                	bnez	a0,14be <truncate3+0x10e>
    13ee:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13f2:	00005a17          	auipc	s4,0x5
    13f6:	9b6a0a13          	addi	s4,s4,-1610 # 5da8 <malloc+0x480>
      int n = write(fd, "1234567890", 10);
    13fa:	00005a97          	auipc	s5,0x5
    13fe:	1bea8a93          	addi	s5,s5,446 # 65b8 <malloc+0xc90>
      int fd = open("truncfile", O_WRONLY);
    1402:	4585                	li	a1,1
    1404:	8552                	mv	a0,s4
    1406:	00004097          	auipc	ra,0x4
    140a:	12c080e7          	jalr	300(ra) # 5532 <open>
    140e:	84aa                	mv	s1,a0
      if(fd < 0){
    1410:	06054a63          	bltz	a0,1484 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    1414:	4629                	li	a2,10
    1416:	85d6                	mv	a1,s5
    1418:	00004097          	auipc	ra,0x4
    141c:	0fa080e7          	jalr	250(ra) # 5512 <write>
      if(n != 10){
    1420:	47a9                	li	a5,10
    1422:	06f51f63          	bne	a0,a5,14a0 <truncate3+0xf0>
      close(fd);
    1426:	8526                	mv	a0,s1
    1428:	00004097          	auipc	ra,0x4
    142c:	0f2080e7          	jalr	242(ra) # 551a <close>
      fd = open("truncfile", O_RDONLY);
    1430:	4581                	li	a1,0
    1432:	8552                	mv	a0,s4
    1434:	00004097          	auipc	ra,0x4
    1438:	0fe080e7          	jalr	254(ra) # 5532 <open>
    143c:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    143e:	02000613          	li	a2,32
    1442:	f9840593          	addi	a1,s0,-104
    1446:	00004097          	auipc	ra,0x4
    144a:	0c4080e7          	jalr	196(ra) # 550a <read>
      close(fd);
    144e:	8526                	mv	a0,s1
    1450:	00004097          	auipc	ra,0x4
    1454:	0ca080e7          	jalr	202(ra) # 551a <close>
    for(int i = 0; i < 100; i++){
    1458:	39fd                	addiw	s3,s3,-1
    145a:	fa0994e3          	bnez	s3,1402 <truncate3+0x52>
    exit(0);
    145e:	4501                	li	a0,0
    1460:	00004097          	auipc	ra,0x4
    1464:	092080e7          	jalr	146(ra) # 54f2 <exit>
    printf("%s: fork failed\n", s);
    1468:	85ca                	mv	a1,s2
    146a:	00005517          	auipc	a0,0x5
    146e:	11e50513          	addi	a0,a0,286 # 6588 <malloc+0xc60>
    1472:	00004097          	auipc	ra,0x4
    1476:	3f8080e7          	jalr	1016(ra) # 586a <printf>
    exit(1);
    147a:	4505                	li	a0,1
    147c:	00004097          	auipc	ra,0x4
    1480:	076080e7          	jalr	118(ra) # 54f2 <exit>
        printf("%s: open failed\n", s);
    1484:	85ca                	mv	a1,s2
    1486:	00005517          	auipc	a0,0x5
    148a:	11a50513          	addi	a0,a0,282 # 65a0 <malloc+0xc78>
    148e:	00004097          	auipc	ra,0x4
    1492:	3dc080e7          	jalr	988(ra) # 586a <printf>
        exit(1);
    1496:	4505                	li	a0,1
    1498:	00004097          	auipc	ra,0x4
    149c:	05a080e7          	jalr	90(ra) # 54f2 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    14a0:	862a                	mv	a2,a0
    14a2:	85ca                	mv	a1,s2
    14a4:	00005517          	auipc	a0,0x5
    14a8:	12450513          	addi	a0,a0,292 # 65c8 <malloc+0xca0>
    14ac:	00004097          	auipc	ra,0x4
    14b0:	3be080e7          	jalr	958(ra) # 586a <printf>
        exit(1);
    14b4:	4505                	li	a0,1
    14b6:	00004097          	auipc	ra,0x4
    14ba:	03c080e7          	jalr	60(ra) # 54f2 <exit>
    14be:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14c2:	00005a17          	auipc	s4,0x5
    14c6:	8e6a0a13          	addi	s4,s4,-1818 # 5da8 <malloc+0x480>
    int n = write(fd, "xxx", 3);
    14ca:	00005a97          	auipc	s5,0x5
    14ce:	11ea8a93          	addi	s5,s5,286 # 65e8 <malloc+0xcc0>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14d2:	60100593          	li	a1,1537
    14d6:	8552                	mv	a0,s4
    14d8:	00004097          	auipc	ra,0x4
    14dc:	05a080e7          	jalr	90(ra) # 5532 <open>
    14e0:	84aa                	mv	s1,a0
    if(fd < 0){
    14e2:	04054763          	bltz	a0,1530 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14e6:	460d                	li	a2,3
    14e8:	85d6                	mv	a1,s5
    14ea:	00004097          	auipc	ra,0x4
    14ee:	028080e7          	jalr	40(ra) # 5512 <write>
    if(n != 3){
    14f2:	478d                	li	a5,3
    14f4:	04f51c63          	bne	a0,a5,154c <truncate3+0x19c>
    close(fd);
    14f8:	8526                	mv	a0,s1
    14fa:	00004097          	auipc	ra,0x4
    14fe:	020080e7          	jalr	32(ra) # 551a <close>
  for(int i = 0; i < 150; i++){
    1502:	39fd                	addiw	s3,s3,-1
    1504:	fc0997e3          	bnez	s3,14d2 <truncate3+0x122>
  wait(&xstatus);
    1508:	fbc40513          	addi	a0,s0,-68
    150c:	00004097          	auipc	ra,0x4
    1510:	fee080e7          	jalr	-18(ra) # 54fa <wait>
  unlink("truncfile");
    1514:	00005517          	auipc	a0,0x5
    1518:	89450513          	addi	a0,a0,-1900 # 5da8 <malloc+0x480>
    151c:	00004097          	auipc	ra,0x4
    1520:	026080e7          	jalr	38(ra) # 5542 <unlink>
  exit(xstatus);
    1524:	fbc42503          	lw	a0,-68(s0)
    1528:	00004097          	auipc	ra,0x4
    152c:	fca080e7          	jalr	-54(ra) # 54f2 <exit>
      printf("%s: open failed\n", s);
    1530:	85ca                	mv	a1,s2
    1532:	00005517          	auipc	a0,0x5
    1536:	06e50513          	addi	a0,a0,110 # 65a0 <malloc+0xc78>
    153a:	00004097          	auipc	ra,0x4
    153e:	330080e7          	jalr	816(ra) # 586a <printf>
      exit(1);
    1542:	4505                	li	a0,1
    1544:	00004097          	auipc	ra,0x4
    1548:	fae080e7          	jalr	-82(ra) # 54f2 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    154c:	862a                	mv	a2,a0
    154e:	85ca                	mv	a1,s2
    1550:	00005517          	auipc	a0,0x5
    1554:	0a050513          	addi	a0,a0,160 # 65f0 <malloc+0xcc8>
    1558:	00004097          	auipc	ra,0x4
    155c:	312080e7          	jalr	786(ra) # 586a <printf>
      exit(1);
    1560:	4505                	li	a0,1
    1562:	00004097          	auipc	ra,0x4
    1566:	f90080e7          	jalr	-112(ra) # 54f2 <exit>

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
    157c:	7d878793          	addi	a5,a5,2008 # 5d50 <malloc+0x428>
    1580:	fcf43023          	sd	a5,-64(s0)
    1584:	00005797          	auipc	a5,0x5
    1588:	08c78793          	addi	a5,a5,140 # 6610 <malloc+0xce8>
    158c:	fcf43423          	sd	a5,-56(s0)
    1590:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1594:	00005517          	auipc	a0,0x5
    1598:	08450513          	addi	a0,a0,132 # 6618 <malloc+0xcf0>
    159c:	00004097          	auipc	ra,0x4
    15a0:	fa6080e7          	jalr	-90(ra) # 5542 <unlink>
  pid = fork();
    15a4:	00004097          	auipc	ra,0x4
    15a8:	f46080e7          	jalr	-186(ra) # 54ea <fork>
  if(pid < 0) {
    15ac:	04054663          	bltz	a0,15f8 <exectest+0x8e>
    15b0:	84aa                	mv	s1,a0
  if(pid == 0) {
    15b2:	e959                	bnez	a0,1648 <exectest+0xde>
    close(1);
    15b4:	4505                	li	a0,1
    15b6:	00004097          	auipc	ra,0x4
    15ba:	f64080e7          	jalr	-156(ra) # 551a <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15be:	20100593          	li	a1,513
    15c2:	00005517          	auipc	a0,0x5
    15c6:	05650513          	addi	a0,a0,86 # 6618 <malloc+0xcf0>
    15ca:	00004097          	auipc	ra,0x4
    15ce:	f68080e7          	jalr	-152(ra) # 5532 <open>
    if(fd < 0) {
    15d2:	04054163          	bltz	a0,1614 <exectest+0xaa>
    if(fd != 1) {
    15d6:	4785                	li	a5,1
    15d8:	04f50c63          	beq	a0,a5,1630 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15dc:	85ca                	mv	a1,s2
    15de:	00005517          	auipc	a0,0x5
    15e2:	05a50513          	addi	a0,a0,90 # 6638 <malloc+0xd10>
    15e6:	00004097          	auipc	ra,0x4
    15ea:	284080e7          	jalr	644(ra) # 586a <printf>
      exit(1);
    15ee:	4505                	li	a0,1
    15f0:	00004097          	auipc	ra,0x4
    15f4:	f02080e7          	jalr	-254(ra) # 54f2 <exit>
     printf("%s: fork failed\n", s);
    15f8:	85ca                	mv	a1,s2
    15fa:	00005517          	auipc	a0,0x5
    15fe:	f8e50513          	addi	a0,a0,-114 # 6588 <malloc+0xc60>
    1602:	00004097          	auipc	ra,0x4
    1606:	268080e7          	jalr	616(ra) # 586a <printf>
     exit(1);
    160a:	4505                	li	a0,1
    160c:	00004097          	auipc	ra,0x4
    1610:	ee6080e7          	jalr	-282(ra) # 54f2 <exit>
      printf("%s: create failed\n", s);
    1614:	85ca                	mv	a1,s2
    1616:	00005517          	auipc	a0,0x5
    161a:	00a50513          	addi	a0,a0,10 # 6620 <malloc+0xcf8>
    161e:	00004097          	auipc	ra,0x4
    1622:	24c080e7          	jalr	588(ra) # 586a <printf>
      exit(1);
    1626:	4505                	li	a0,1
    1628:	00004097          	auipc	ra,0x4
    162c:	eca080e7          	jalr	-310(ra) # 54f2 <exit>
    if(exec("echo", echoargv) < 0){
    1630:	fc040593          	addi	a1,s0,-64
    1634:	00004517          	auipc	a0,0x4
    1638:	71c50513          	addi	a0,a0,1820 # 5d50 <malloc+0x428>
    163c:	00004097          	auipc	ra,0x4
    1640:	eee080e7          	jalr	-274(ra) # 552a <exec>
    1644:	02054163          	bltz	a0,1666 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1648:	fdc40513          	addi	a0,s0,-36
    164c:	00004097          	auipc	ra,0x4
    1650:	eae080e7          	jalr	-338(ra) # 54fa <wait>
    1654:	02951763          	bne	a0,s1,1682 <exectest+0x118>
  if(xstatus != 0)
    1658:	fdc42503          	lw	a0,-36(s0)
    165c:	cd0d                	beqz	a0,1696 <exectest+0x12c>
    exit(xstatus);
    165e:	00004097          	auipc	ra,0x4
    1662:	e94080e7          	jalr	-364(ra) # 54f2 <exit>
      printf("%s: exec echo failed\n", s);
    1666:	85ca                	mv	a1,s2
    1668:	00005517          	auipc	a0,0x5
    166c:	fe050513          	addi	a0,a0,-32 # 6648 <malloc+0xd20>
    1670:	00004097          	auipc	ra,0x4
    1674:	1fa080e7          	jalr	506(ra) # 586a <printf>
      exit(1);
    1678:	4505                	li	a0,1
    167a:	00004097          	auipc	ra,0x4
    167e:	e78080e7          	jalr	-392(ra) # 54f2 <exit>
    printf("%s: wait failed!\n", s);
    1682:	85ca                	mv	a1,s2
    1684:	00005517          	auipc	a0,0x5
    1688:	fdc50513          	addi	a0,a0,-36 # 6660 <malloc+0xd38>
    168c:	00004097          	auipc	ra,0x4
    1690:	1de080e7          	jalr	478(ra) # 586a <printf>
    1694:	b7d1                	j	1658 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1696:	4581                	li	a1,0
    1698:	00005517          	auipc	a0,0x5
    169c:	f8050513          	addi	a0,a0,-128 # 6618 <malloc+0xcf0>
    16a0:	00004097          	auipc	ra,0x4
    16a4:	e92080e7          	jalr	-366(ra) # 5532 <open>
  if(fd < 0) {
    16a8:	02054a63          	bltz	a0,16dc <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16ac:	4609                	li	a2,2
    16ae:	fb840593          	addi	a1,s0,-72
    16b2:	00004097          	auipc	ra,0x4
    16b6:	e58080e7          	jalr	-424(ra) # 550a <read>
    16ba:	4789                	li	a5,2
    16bc:	02f50e63          	beq	a0,a5,16f8 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16c0:	85ca                	mv	a1,s2
    16c2:	00005517          	auipc	a0,0x5
    16c6:	a1e50513          	addi	a0,a0,-1506 # 60e0 <malloc+0x7b8>
    16ca:	00004097          	auipc	ra,0x4
    16ce:	1a0080e7          	jalr	416(ra) # 586a <printf>
    exit(1);
    16d2:	4505                	li	a0,1
    16d4:	00004097          	auipc	ra,0x4
    16d8:	e1e080e7          	jalr	-482(ra) # 54f2 <exit>
    printf("%s: open failed\n", s);
    16dc:	85ca                	mv	a1,s2
    16de:	00005517          	auipc	a0,0x5
    16e2:	ec250513          	addi	a0,a0,-318 # 65a0 <malloc+0xc78>
    16e6:	00004097          	auipc	ra,0x4
    16ea:	184080e7          	jalr	388(ra) # 586a <printf>
    exit(1);
    16ee:	4505                	li	a0,1
    16f0:	00004097          	auipc	ra,0x4
    16f4:	e02080e7          	jalr	-510(ra) # 54f2 <exit>
  unlink("echo-ok");
    16f8:	00005517          	auipc	a0,0x5
    16fc:	f2050513          	addi	a0,a0,-224 # 6618 <malloc+0xcf0>
    1700:	00004097          	auipc	ra,0x4
    1704:	e42080e7          	jalr	-446(ra) # 5542 <unlink>
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
    1726:	f5650513          	addi	a0,a0,-170 # 6678 <malloc+0xd50>
    172a:	00004097          	auipc	ra,0x4
    172e:	140080e7          	jalr	320(ra) # 586a <printf>
    exit(1);
    1732:	4505                	li	a0,1
    1734:	00004097          	auipc	ra,0x4
    1738:	dbe080e7          	jalr	-578(ra) # 54f2 <exit>
    exit(0);
    173c:	4501                	li	a0,0
    173e:	00004097          	auipc	ra,0x4
    1742:	db4080e7          	jalr	-588(ra) # 54f2 <exit>

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
    1766:	da0080e7          	jalr	-608(ra) # 5502 <pipe>
    176a:	ed25                	bnez	a0,17e2 <pipe1+0x9c>
    176c:	84aa                	mv	s1,a0
  pid = fork();
    176e:	00004097          	auipc	ra,0x4
    1772:	d7c080e7          	jalr	-644(ra) # 54ea <fork>
    1776:	8a2a                	mv	s4,a0
  if(pid == 0){
    1778:	c159                	beqz	a0,17fe <pipe1+0xb8>
  } else if(pid > 0){
    177a:	16a05e63          	blez	a0,18f6 <pipe1+0x1b0>
    close(fds[1]);
    177e:	fac42503          	lw	a0,-84(s0)
    1782:	00004097          	auipc	ra,0x4
    1786:	d98080e7          	jalr	-616(ra) # 551a <close>
    total = 0;
    178a:	8a26                	mv	s4,s1
    cc = 1;
    178c:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    178e:	0000aa97          	auipc	s5,0xa
    1792:	1e2a8a93          	addi	s5,s5,482 # b970 <buf>
      if(cc > sizeof(buf))
    1796:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1798:	864e                	mv	a2,s3
    179a:	85d6                	mv	a1,s5
    179c:	fa842503          	lw	a0,-88(s0)
    17a0:	00004097          	auipc	ra,0x4
    17a4:	d6a080e7          	jalr	-662(ra) # 550a <read>
    17a8:	10a05263          	blez	a0,18ac <pipe1+0x166>
      for(i = 0; i < n; i++){
    17ac:	0000a717          	auipc	a4,0xa
    17b0:	1c470713          	addi	a4,a4,452 # b970 <buf>
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
    17e8:	eac50513          	addi	a0,a0,-340 # 6690 <malloc+0xd68>
    17ec:	00004097          	auipc	ra,0x4
    17f0:	07e080e7          	jalr	126(ra) # 586a <printf>
    exit(1);
    17f4:	4505                	li	a0,1
    17f6:	00004097          	auipc	ra,0x4
    17fa:	cfc080e7          	jalr	-772(ra) # 54f2 <exit>
    close(fds[0]);
    17fe:	fa842503          	lw	a0,-88(s0)
    1802:	00004097          	auipc	ra,0x4
    1806:	d18080e7          	jalr	-744(ra) # 551a <close>
    for(n = 0; n < N; n++){
    180a:	0000ab17          	auipc	s6,0xa
    180e:	166b0b13          	addi	s6,s6,358 # b970 <buf>
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
    1848:	cce080e7          	jalr	-818(ra) # 5512 <write>
    184c:	40900793          	li	a5,1033
    1850:	00f51c63          	bne	a0,a5,1868 <pipe1+0x122>
    for(n = 0; n < N; n++){
    1854:	24a5                	addiw	s1,s1,9
    1856:	0ff4f493          	andi	s1,s1,255
    185a:	fd5a16e3          	bne	s4,s5,1826 <pipe1+0xe0>
    exit(0);
    185e:	4501                	li	a0,0
    1860:	00004097          	auipc	ra,0x4
    1864:	c92080e7          	jalr	-878(ra) # 54f2 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1868:	85ca                	mv	a1,s2
    186a:	00005517          	auipc	a0,0x5
    186e:	e3e50513          	addi	a0,a0,-450 # 66a8 <malloc+0xd80>
    1872:	00004097          	auipc	ra,0x4
    1876:	ff8080e7          	jalr	-8(ra) # 586a <printf>
        exit(1);
    187a:	4505                	li	a0,1
    187c:	00004097          	auipc	ra,0x4
    1880:	c76080e7          	jalr	-906(ra) # 54f2 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1884:	85ca                	mv	a1,s2
    1886:	00005517          	auipc	a0,0x5
    188a:	e3a50513          	addi	a0,a0,-454 # 66c0 <malloc+0xd98>
    188e:	00004097          	auipc	ra,0x4
    1892:	fdc080e7          	jalr	-36(ra) # 586a <printf>
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
    18bc:	e2050513          	addi	a0,a0,-480 # 66d8 <malloc+0xdb0>
    18c0:	00004097          	auipc	ra,0x4
    18c4:	faa080e7          	jalr	-86(ra) # 586a <printf>
      exit(1);
    18c8:	4505                	li	a0,1
    18ca:	00004097          	auipc	ra,0x4
    18ce:	c28080e7          	jalr	-984(ra) # 54f2 <exit>
    close(fds[0]);
    18d2:	fa842503          	lw	a0,-88(s0)
    18d6:	00004097          	auipc	ra,0x4
    18da:	c44080e7          	jalr	-956(ra) # 551a <close>
    wait(&xstatus);
    18de:	fa440513          	addi	a0,s0,-92
    18e2:	00004097          	auipc	ra,0x4
    18e6:	c18080e7          	jalr	-1000(ra) # 54fa <wait>
    exit(xstatus);
    18ea:	fa442503          	lw	a0,-92(s0)
    18ee:	00004097          	auipc	ra,0x4
    18f2:	c04080e7          	jalr	-1020(ra) # 54f2 <exit>
    printf("%s: fork() failed\n", s);
    18f6:	85ca                	mv	a1,s2
    18f8:	00005517          	auipc	a0,0x5
    18fc:	e0050513          	addi	a0,a0,-512 # 66f8 <malloc+0xdd0>
    1900:	00004097          	auipc	ra,0x4
    1904:	f6a080e7          	jalr	-150(ra) # 586a <printf>
    exit(1);
    1908:	4505                	li	a0,1
    190a:	00004097          	auipc	ra,0x4
    190e:	be8080e7          	jalr	-1048(ra) # 54f2 <exit>

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
    192e:	bc0080e7          	jalr	-1088(ra) # 54ea <fork>
    1932:	84aa                	mv	s1,a0
    if(pid < 0){
    1934:	02054a63          	bltz	a0,1968 <exitwait+0x56>
    if(pid){
    1938:	c151                	beqz	a0,19bc <exitwait+0xaa>
      if(wait(&xstate) != pid){
    193a:	fcc40513          	addi	a0,s0,-52
    193e:	00004097          	auipc	ra,0x4
    1942:	bbc080e7          	jalr	-1092(ra) # 54fa <wait>
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
    196e:	c1e50513          	addi	a0,a0,-994 # 6588 <malloc+0xc60>
    1972:	00004097          	auipc	ra,0x4
    1976:	ef8080e7          	jalr	-264(ra) # 586a <printf>
      exit(1);
    197a:	4505                	li	a0,1
    197c:	00004097          	auipc	ra,0x4
    1980:	b76080e7          	jalr	-1162(ra) # 54f2 <exit>
        printf("%s: wait wrong pid\n", s);
    1984:	85d2                	mv	a1,s4
    1986:	00005517          	auipc	a0,0x5
    198a:	d8a50513          	addi	a0,a0,-630 # 6710 <malloc+0xde8>
    198e:	00004097          	auipc	ra,0x4
    1992:	edc080e7          	jalr	-292(ra) # 586a <printf>
        exit(1);
    1996:	4505                	li	a0,1
    1998:	00004097          	auipc	ra,0x4
    199c:	b5a080e7          	jalr	-1190(ra) # 54f2 <exit>
        printf("%s: wait wrong exit status\n", s);
    19a0:	85d2                	mv	a1,s4
    19a2:	00005517          	auipc	a0,0x5
    19a6:	d8650513          	addi	a0,a0,-634 # 6728 <malloc+0xe00>
    19aa:	00004097          	auipc	ra,0x4
    19ae:	ec0080e7          	jalr	-320(ra) # 586a <printf>
        exit(1);
    19b2:	4505                	li	a0,1
    19b4:	00004097          	auipc	ra,0x4
    19b8:	b3e080e7          	jalr	-1218(ra) # 54f2 <exit>
      exit(i);
    19bc:	854a                	mv	a0,s2
    19be:	00004097          	auipc	ra,0x4
    19c2:	b34080e7          	jalr	-1228(ra) # 54f2 <exit>

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
    19dc:	b12080e7          	jalr	-1262(ra) # 54ea <fork>
    if(pid1 < 0){
    19e0:	02054c63          	bltz	a0,1a18 <twochildren+0x52>
    if(pid1 == 0){
    19e4:	c921                	beqz	a0,1a34 <twochildren+0x6e>
      int pid2 = fork();
    19e6:	00004097          	auipc	ra,0x4
    19ea:	b04080e7          	jalr	-1276(ra) # 54ea <fork>
      if(pid2 < 0){
    19ee:	04054763          	bltz	a0,1a3c <twochildren+0x76>
      if(pid2 == 0){
    19f2:	c13d                	beqz	a0,1a58 <twochildren+0x92>
        wait(0);
    19f4:	4501                	li	a0,0
    19f6:	00004097          	auipc	ra,0x4
    19fa:	b04080e7          	jalr	-1276(ra) # 54fa <wait>
        wait(0);
    19fe:	4501                	li	a0,0
    1a00:	00004097          	auipc	ra,0x4
    1a04:	afa080e7          	jalr	-1286(ra) # 54fa <wait>
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
    1a1e:	b6e50513          	addi	a0,a0,-1170 # 6588 <malloc+0xc60>
    1a22:	00004097          	auipc	ra,0x4
    1a26:	e48080e7          	jalr	-440(ra) # 586a <printf>
      exit(1);
    1a2a:	4505                	li	a0,1
    1a2c:	00004097          	auipc	ra,0x4
    1a30:	ac6080e7          	jalr	-1338(ra) # 54f2 <exit>
      exit(0);
    1a34:	00004097          	auipc	ra,0x4
    1a38:	abe080e7          	jalr	-1346(ra) # 54f2 <exit>
        printf("%s: fork failed\n", s);
    1a3c:	85ca                	mv	a1,s2
    1a3e:	00005517          	auipc	a0,0x5
    1a42:	b4a50513          	addi	a0,a0,-1206 # 6588 <malloc+0xc60>
    1a46:	00004097          	auipc	ra,0x4
    1a4a:	e24080e7          	jalr	-476(ra) # 586a <printf>
        exit(1);
    1a4e:	4505                	li	a0,1
    1a50:	00004097          	auipc	ra,0x4
    1a54:	aa2080e7          	jalr	-1374(ra) # 54f2 <exit>
        exit(0);
    1a58:	00004097          	auipc	ra,0x4
    1a5c:	a9a080e7          	jalr	-1382(ra) # 54f2 <exit>

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
    1a70:	a7e080e7          	jalr	-1410(ra) # 54ea <fork>
    if(pid < 0){
    1a74:	04054163          	bltz	a0,1ab6 <forkfork+0x56>
    if(pid == 0){
    1a78:	cd29                	beqz	a0,1ad2 <forkfork+0x72>
    int pid = fork();
    1a7a:	00004097          	auipc	ra,0x4
    1a7e:	a70080e7          	jalr	-1424(ra) # 54ea <fork>
    if(pid < 0){
    1a82:	02054a63          	bltz	a0,1ab6 <forkfork+0x56>
    if(pid == 0){
    1a86:	c531                	beqz	a0,1ad2 <forkfork+0x72>
    wait(&xstatus);
    1a88:	fdc40513          	addi	a0,s0,-36
    1a8c:	00004097          	auipc	ra,0x4
    1a90:	a6e080e7          	jalr	-1426(ra) # 54fa <wait>
    if(xstatus != 0) {
    1a94:	fdc42783          	lw	a5,-36(s0)
    1a98:	ebbd                	bnez	a5,1b0e <forkfork+0xae>
    wait(&xstatus);
    1a9a:	fdc40513          	addi	a0,s0,-36
    1a9e:	00004097          	auipc	ra,0x4
    1aa2:	a5c080e7          	jalr	-1444(ra) # 54fa <wait>
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
    1abc:	c9050513          	addi	a0,a0,-880 # 6748 <malloc+0xe20>
    1ac0:	00004097          	auipc	ra,0x4
    1ac4:	daa080e7          	jalr	-598(ra) # 586a <printf>
      exit(1);
    1ac8:	4505                	li	a0,1
    1aca:	00004097          	auipc	ra,0x4
    1ace:	a28080e7          	jalr	-1496(ra) # 54f2 <exit>
{
    1ad2:	0c800493          	li	s1,200
        int pid1 = fork();
    1ad6:	00004097          	auipc	ra,0x4
    1ada:	a14080e7          	jalr	-1516(ra) # 54ea <fork>
        if(pid1 < 0){
    1ade:	00054f63          	bltz	a0,1afc <forkfork+0x9c>
        if(pid1 == 0){
    1ae2:	c115                	beqz	a0,1b06 <forkfork+0xa6>
        wait(0);
    1ae4:	4501                	li	a0,0
    1ae6:	00004097          	auipc	ra,0x4
    1aea:	a14080e7          	jalr	-1516(ra) # 54fa <wait>
      for(int j = 0; j < 200; j++){
    1aee:	34fd                	addiw	s1,s1,-1
    1af0:	f0fd                	bnez	s1,1ad6 <forkfork+0x76>
      exit(0);
    1af2:	4501                	li	a0,0
    1af4:	00004097          	auipc	ra,0x4
    1af8:	9fe080e7          	jalr	-1538(ra) # 54f2 <exit>
          exit(1);
    1afc:	4505                	li	a0,1
    1afe:	00004097          	auipc	ra,0x4
    1b02:	9f4080e7          	jalr	-1548(ra) # 54f2 <exit>
          exit(0);
    1b06:	00004097          	auipc	ra,0x4
    1b0a:	9ec080e7          	jalr	-1556(ra) # 54f2 <exit>
      printf("%s: fork in child failed", s);
    1b0e:	85a6                	mv	a1,s1
    1b10:	00005517          	auipc	a0,0x5
    1b14:	c4850513          	addi	a0,a0,-952 # 6758 <malloc+0xe30>
    1b18:	00004097          	auipc	ra,0x4
    1b1c:	d52080e7          	jalr	-686(ra) # 586a <printf>
      exit(1);
    1b20:	4505                	li	a0,1
    1b22:	00004097          	auipc	ra,0x4
    1b26:	9d0080e7          	jalr	-1584(ra) # 54f2 <exit>

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
    1b3c:	9b2080e7          	jalr	-1614(ra) # 54ea <fork>
    if(pid1 < 0){
    1b40:	00054f63          	bltz	a0,1b5e <reparent2+0x34>
    if(pid1 == 0){
    1b44:	c915                	beqz	a0,1b78 <reparent2+0x4e>
    wait(0);
    1b46:	4501                	li	a0,0
    1b48:	00004097          	auipc	ra,0x4
    1b4c:	9b2080e7          	jalr	-1614(ra) # 54fa <wait>
  for(int i = 0; i < 800; i++){
    1b50:	34fd                	addiw	s1,s1,-1
    1b52:	f0fd                	bnez	s1,1b38 <reparent2+0xe>
  exit(0);
    1b54:	4501                	li	a0,0
    1b56:	00004097          	auipc	ra,0x4
    1b5a:	99c080e7          	jalr	-1636(ra) # 54f2 <exit>
      printf("fork failed\n");
    1b5e:	00005517          	auipc	a0,0x5
    1b62:	e1a50513          	addi	a0,a0,-486 # 6978 <malloc+0x1050>
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	d04080e7          	jalr	-764(ra) # 586a <printf>
      exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	00004097          	auipc	ra,0x4
    1b74:	982080e7          	jalr	-1662(ra) # 54f2 <exit>
      fork();
    1b78:	00004097          	auipc	ra,0x4
    1b7c:	972080e7          	jalr	-1678(ra) # 54ea <fork>
      fork();
    1b80:	00004097          	auipc	ra,0x4
    1b84:	96a080e7          	jalr	-1686(ra) # 54ea <fork>
      exit(0);
    1b88:	4501                	li	a0,0
    1b8a:	00004097          	auipc	ra,0x4
    1b8e:	968080e7          	jalr	-1688(ra) # 54f2 <exit>

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
    1bb2:	00004097          	auipc	ra,0x4
    1bb6:	938080e7          	jalr	-1736(ra) # 54ea <fork>
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
    1bce:	00004097          	auipc	ra,0x4
    1bd2:	92c080e7          	jalr	-1748(ra) # 54fa <wait>
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
    1c00:	d7c50513          	addi	a0,a0,-644 # 6978 <malloc+0x1050>
    1c04:	00004097          	auipc	ra,0x4
    1c08:	c66080e7          	jalr	-922(ra) # 586a <printf>
      exit(1);
    1c0c:	4505                	li	a0,1
    1c0e:	00004097          	auipc	ra,0x4
    1c12:	8e4080e7          	jalr	-1820(ra) # 54f2 <exit>
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
    1c2c:	9f850513          	addi	a0,a0,-1544 # 6620 <malloc+0xcf8>
    1c30:	00004097          	auipc	ra,0x4
    1c34:	c3a080e7          	jalr	-966(ra) # 586a <printf>
          exit(1);
    1c38:	4505                	li	a0,1
    1c3a:	00004097          	auipc	ra,0x4
    1c3e:	8b8080e7          	jalr	-1864(ra) # 54f2 <exit>
      for(i = 0; i < N; i++){
    1c42:	2485                	addiw	s1,s1,1
    1c44:	07248863          	beq	s1,s2,1cb4 <createdelete+0x122>
        name[1] = '0' + i;
    1c48:	0304879b          	addiw	a5,s1,48
    1c4c:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c50:	20200593          	li	a1,514
    1c54:	f8040513          	addi	a0,s0,-128
    1c58:	00004097          	auipc	ra,0x4
    1c5c:	8da080e7          	jalr	-1830(ra) # 5532 <open>
        if(fd < 0){
    1c60:	fc0543e3          	bltz	a0,1c26 <createdelete+0x94>
        close(fd);
    1c64:	00004097          	auipc	ra,0x4
    1c68:	8b6080e7          	jalr	-1866(ra) # 551a <close>
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
    1c8c:	00004097          	auipc	ra,0x4
    1c90:	8b6080e7          	jalr	-1866(ra) # 5542 <unlink>
    1c94:	fa0557e3          	bgez	a0,1c42 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c98:	85e6                	mv	a1,s9
    1c9a:	00005517          	auipc	a0,0x5
    1c9e:	ade50513          	addi	a0,a0,-1314 # 6778 <malloc+0xe50>
    1ca2:	00004097          	auipc	ra,0x4
    1ca6:	bc8080e7          	jalr	-1080(ra) # 586a <printf>
            exit(1);
    1caa:	4505                	li	a0,1
    1cac:	00004097          	auipc	ra,0x4
    1cb0:	846080e7          	jalr	-1978(ra) # 54f2 <exit>
      exit(0);
    1cb4:	4501                	li	a0,0
    1cb6:	00004097          	auipc	ra,0x4
    1cba:	83c080e7          	jalr	-1988(ra) # 54f2 <exit>
      exit(1);
    1cbe:	4505                	li	a0,1
    1cc0:	00004097          	auipc	ra,0x4
    1cc4:	832080e7          	jalr	-1998(ra) # 54f2 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cc8:	f8040613          	addi	a2,s0,-128
    1ccc:	85e6                	mv	a1,s9
    1cce:	00005517          	auipc	a0,0x5
    1cd2:	ac250513          	addi	a0,a0,-1342 # 6790 <malloc+0xe68>
    1cd6:	00004097          	auipc	ra,0x4
    1cda:	b94080e7          	jalr	-1132(ra) # 586a <printf>
        exit(1);
    1cde:	4505                	li	a0,1
    1ce0:	00004097          	auipc	ra,0x4
    1ce4:	812080e7          	jalr	-2030(ra) # 54f2 <exit>
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
    1d08:	00004097          	auipc	ra,0x4
    1d0c:	82a080e7          	jalr	-2006(ra) # 5532 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d10:	00090463          	beqz	s2,1d18 <createdelete+0x186>
    1d14:	fd2bdae3          	bge	s7,s2,1ce8 <createdelete+0x156>
    1d18:	fa0548e3          	bltz	a0,1cc8 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d1c:	014b7963          	bgeu	s6,s4,1d2e <createdelete+0x19c>
        close(fd);
    1d20:	00003097          	auipc	ra,0x3
    1d24:	7fa080e7          	jalr	2042(ra) # 551a <close>
    1d28:	b7e1                	j	1cf0 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d2a:	fc0543e3          	bltz	a0,1cf0 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d2e:	f8040613          	addi	a2,s0,-128
    1d32:	85e6                	mv	a1,s9
    1d34:	00005517          	auipc	a0,0x5
    1d38:	a8450513          	addi	a0,a0,-1404 # 67b8 <malloc+0xe90>
    1d3c:	00004097          	auipc	ra,0x4
    1d40:	b2e080e7          	jalr	-1234(ra) # 586a <printf>
        exit(1);
    1d44:	4505                	li	a0,1
    1d46:	00003097          	auipc	ra,0x3
    1d4a:	7ac080e7          	jalr	1964(ra) # 54f2 <exit>
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
    1d84:	7c2080e7          	jalr	1986(ra) # 5542 <unlink>
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
    1dd8:	fec50513          	addi	a0,a0,-20 # 5dc0 <malloc+0x498>
    1ddc:	00003097          	auipc	ra,0x3
    1de0:	766080e7          	jalr	1894(ra) # 5542 <unlink>
  pid = fork();
    1de4:	00003097          	auipc	ra,0x3
    1de8:	706080e7          	jalr	1798(ra) # 54ea <fork>
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
    1e14:	fb0a8a93          	addi	s5,s5,-80 # 5dc0 <malloc+0x498>
      link("cat", "x");
    1e18:	00005b97          	auipc	s7,0x5
    1e1c:	9c8b8b93          	addi	s7,s7,-1592 # 67e0 <malloc+0xeb8>
    1e20:	a091                	j	1e64 <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    1e22:	85a6                	mv	a1,s1
    1e24:	00004517          	auipc	a0,0x4
    1e28:	76450513          	addi	a0,a0,1892 # 6588 <malloc+0xc60>
    1e2c:	00004097          	auipc	ra,0x4
    1e30:	a3e080e7          	jalr	-1474(ra) # 586a <printf>
    exit(1);
    1e34:	4505                	li	a0,1
    1e36:	00003097          	auipc	ra,0x3
    1e3a:	6bc080e7          	jalr	1724(ra) # 54f2 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e3e:	20200593          	li	a1,514
    1e42:	8556                	mv	a0,s5
    1e44:	00003097          	auipc	ra,0x3
    1e48:	6ee080e7          	jalr	1774(ra) # 5532 <open>
    1e4c:	00003097          	auipc	ra,0x3
    1e50:	6ce080e7          	jalr	1742(ra) # 551a <close>
    1e54:	a031                	j	1e60 <linkunlink+0xa8>
      unlink("x");
    1e56:	8556                	mv	a0,s5
    1e58:	00003097          	auipc	ra,0x3
    1e5c:	6ea080e7          	jalr	1770(ra) # 5542 <unlink>
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
    1e82:	6d4080e7          	jalr	1748(ra) # 5552 <link>
    1e86:	bfe9                	j	1e60 <linkunlink+0xa8>
  if(pid)
    1e88:	020c0463          	beqz	s8,1eb0 <linkunlink+0xf8>
    wait(0);
    1e8c:	4501                	li	a0,0
    1e8e:	00003097          	auipc	ra,0x3
    1e92:	66c080e7          	jalr	1644(ra) # 54fa <wait>
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
    1eb6:	640080e7          	jalr	1600(ra) # 54f2 <exit>

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
    1ed4:	61a080e7          	jalr	1562(ra) # 54ea <fork>
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
    1eea:	91a50513          	addi	a0,a0,-1766 # 6800 <malloc+0xed8>
    1eee:	00004097          	auipc	ra,0x4
    1ef2:	97c080e7          	jalr	-1668(ra) # 586a <printf>
    exit(1);
    1ef6:	4505                	li	a0,1
    1ef8:	00003097          	auipc	ra,0x3
    1efc:	5fa080e7          	jalr	1530(ra) # 54f2 <exit>
      exit(0);
    1f00:	00003097          	auipc	ra,0x3
    1f04:	5f2080e7          	jalr	1522(ra) # 54f2 <exit>
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
    1f1c:	5e2080e7          	jalr	1506(ra) # 54fa <wait>
    1f20:	04054163          	bltz	a0,1f62 <forktest+0xa8>
  for(; n > 0; n--){
    1f24:	34fd                	addiw	s1,s1,-1
    1f26:	f8e5                	bnez	s1,1f16 <forktest+0x5c>
  if(wait(0) != -1){
    1f28:	4501                	li	a0,0
    1f2a:	00003097          	auipc	ra,0x3
    1f2e:	5d0080e7          	jalr	1488(ra) # 54fa <wait>
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
    1f48:	00005517          	auipc	a0,0x5
    1f4c:	8a050513          	addi	a0,a0,-1888 # 67e8 <malloc+0xec0>
    1f50:	00004097          	auipc	ra,0x4
    1f54:	91a080e7          	jalr	-1766(ra) # 586a <printf>
    exit(1);
    1f58:	4505                	li	a0,1
    1f5a:	00003097          	auipc	ra,0x3
    1f5e:	598080e7          	jalr	1432(ra) # 54f2 <exit>
      printf("%s: wait stopped early\n", s);
    1f62:	85ce                	mv	a1,s3
    1f64:	00005517          	auipc	a0,0x5
    1f68:	8c450513          	addi	a0,a0,-1852 # 6828 <malloc+0xf00>
    1f6c:	00004097          	auipc	ra,0x4
    1f70:	8fe080e7          	jalr	-1794(ra) # 586a <printf>
      exit(1);
    1f74:	4505                	li	a0,1
    1f76:	00003097          	auipc	ra,0x3
    1f7a:	57c080e7          	jalr	1404(ra) # 54f2 <exit>
    printf("%s: wait got too many\n", s);
    1f7e:	85ce                	mv	a1,s3
    1f80:	00005517          	auipc	a0,0x5
    1f84:	8c050513          	addi	a0,a0,-1856 # 6840 <malloc+0xf18>
    1f88:	00004097          	auipc	ra,0x4
    1f8c:	8e2080e7          	jalr	-1822(ra) # 586a <printf>
    exit(1);
    1f90:	4505                	li	a0,1
    1f92:	00003097          	auipc	ra,0x3
    1f96:	560080e7          	jalr	1376(ra) # 54f2 <exit>

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
    1fb6:	35098993          	addi	s3,s3,848 # c350 <buf+0x9e0>
    1fba:	1003d937          	lui	s2,0x1003d
    1fbe:	090e                	slli	s2,s2,0x3
    1fc0:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002eb00>
    pid = fork();
    1fc4:	00003097          	auipc	ra,0x3
    1fc8:	526080e7          	jalr	1318(ra) # 54ea <fork>
    if(pid < 0){
    1fcc:	02054963          	bltz	a0,1ffe <kernmem+0x64>
    if(pid == 0){
    1fd0:	c529                	beqz	a0,201a <kernmem+0x80>
    wait(&xstatus);
    1fd2:	fbc40513          	addi	a0,s0,-68
    1fd6:	00003097          	auipc	ra,0x3
    1fda:	524080e7          	jalr	1316(ra) # 54fa <wait>
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
    2004:	58850513          	addi	a0,a0,1416 # 6588 <malloc+0xc60>
    2008:	00004097          	auipc	ra,0x4
    200c:	862080e7          	jalr	-1950(ra) # 586a <printf>
      exit(1);
    2010:	4505                	li	a0,1
    2012:	00003097          	auipc	ra,0x3
    2016:	4e0080e7          	jalr	1248(ra) # 54f2 <exit>
      printf("%s: oops could read %x = %x\n", a, *a);
    201a:	0004c603          	lbu	a2,0(s1)
    201e:	85a6                	mv	a1,s1
    2020:	00005517          	auipc	a0,0x5
    2024:	83850513          	addi	a0,a0,-1992 # 6858 <malloc+0xf30>
    2028:	00004097          	auipc	ra,0x4
    202c:	842080e7          	jalr	-1982(ra) # 586a <printf>
      exit(1);
    2030:	4505                	li	a0,1
    2032:	00003097          	auipc	ra,0x3
    2036:	4c0080e7          	jalr	1216(ra) # 54f2 <exit>
      exit(1);
    203a:	4505                	li	a0,1
    203c:	00003097          	auipc	ra,0x3
    2040:	4b6080e7          	jalr	1206(ra) # 54f2 <exit>

0000000000002044 <bigargtest>:
{
    2044:	7179                	addi	sp,sp,-48
    2046:	f406                	sd	ra,40(sp)
    2048:	f022                	sd	s0,32(sp)
    204a:	ec26                	sd	s1,24(sp)
    204c:	1800                	addi	s0,sp,48
    204e:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2050:	00005517          	auipc	a0,0x5
    2054:	82850513          	addi	a0,a0,-2008 # 6878 <malloc+0xf50>
    2058:	00003097          	auipc	ra,0x3
    205c:	4ea080e7          	jalr	1258(ra) # 5542 <unlink>
  pid = fork();
    2060:	00003097          	auipc	ra,0x3
    2064:	48a080e7          	jalr	1162(ra) # 54ea <fork>
  if(pid == 0){
    2068:	c121                	beqz	a0,20a8 <bigargtest+0x64>
  } else if(pid < 0){
    206a:	0a054063          	bltz	a0,210a <bigargtest+0xc6>
  wait(&xstatus);
    206e:	fdc40513          	addi	a0,s0,-36
    2072:	00003097          	auipc	ra,0x3
    2076:	488080e7          	jalr	1160(ra) # 54fa <wait>
  if(xstatus != 0)
    207a:	fdc42503          	lw	a0,-36(s0)
    207e:	e545                	bnez	a0,2126 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2080:	4581                	li	a1,0
    2082:	00004517          	auipc	a0,0x4
    2086:	7f650513          	addi	a0,a0,2038 # 6878 <malloc+0xf50>
    208a:	00003097          	auipc	ra,0x3
    208e:	4a8080e7          	jalr	1192(ra) # 5532 <open>
  if(fd < 0){
    2092:	08054e63          	bltz	a0,212e <bigargtest+0xea>
  close(fd);
    2096:	00003097          	auipc	ra,0x3
    209a:	484080e7          	jalr	1156(ra) # 551a <close>
}
    209e:	70a2                	ld	ra,40(sp)
    20a0:	7402                	ld	s0,32(sp)
    20a2:	64e2                	ld	s1,24(sp)
    20a4:	6145                	addi	sp,sp,48
    20a6:	8082                	ret
    20a8:	00006797          	auipc	a5,0x6
    20ac:	0b078793          	addi	a5,a5,176 # 8158 <args.1807>
    20b0:	00006697          	auipc	a3,0x6
    20b4:	1a068693          	addi	a3,a3,416 # 8250 <args.1807+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    20b8:	00004717          	auipc	a4,0x4
    20bc:	7d070713          	addi	a4,a4,2000 # 6888 <malloc+0xf60>
    20c0:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    20c2:	07a1                	addi	a5,a5,8
    20c4:	fed79ee3          	bne	a5,a3,20c0 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    20c8:	00006597          	auipc	a1,0x6
    20cc:	09058593          	addi	a1,a1,144 # 8158 <args.1807>
    20d0:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    20d4:	00004517          	auipc	a0,0x4
    20d8:	c7c50513          	addi	a0,a0,-900 # 5d50 <malloc+0x428>
    20dc:	00003097          	auipc	ra,0x3
    20e0:	44e080e7          	jalr	1102(ra) # 552a <exec>
    fd = open("bigarg-ok", O_CREATE);
    20e4:	20000593          	li	a1,512
    20e8:	00004517          	auipc	a0,0x4
    20ec:	79050513          	addi	a0,a0,1936 # 6878 <malloc+0xf50>
    20f0:	00003097          	auipc	ra,0x3
    20f4:	442080e7          	jalr	1090(ra) # 5532 <open>
    close(fd);
    20f8:	00003097          	auipc	ra,0x3
    20fc:	422080e7          	jalr	1058(ra) # 551a <close>
    exit(0);
    2100:	4501                	li	a0,0
    2102:	00003097          	auipc	ra,0x3
    2106:	3f0080e7          	jalr	1008(ra) # 54f2 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    210a:	85a6                	mv	a1,s1
    210c:	00005517          	auipc	a0,0x5
    2110:	85c50513          	addi	a0,a0,-1956 # 6968 <malloc+0x1040>
    2114:	00003097          	auipc	ra,0x3
    2118:	756080e7          	jalr	1878(ra) # 586a <printf>
    exit(1);
    211c:	4505                	li	a0,1
    211e:	00003097          	auipc	ra,0x3
    2122:	3d4080e7          	jalr	980(ra) # 54f2 <exit>
    exit(xstatus);
    2126:	00003097          	auipc	ra,0x3
    212a:	3cc080e7          	jalr	972(ra) # 54f2 <exit>
    printf("%s: bigarg test failed!\n", s);
    212e:	85a6                	mv	a1,s1
    2130:	00005517          	auipc	a0,0x5
    2134:	85850513          	addi	a0,a0,-1960 # 6988 <malloc+0x1060>
    2138:	00003097          	auipc	ra,0x3
    213c:	732080e7          	jalr	1842(ra) # 586a <printf>
    exit(1);
    2140:	4505                	li	a0,1
    2142:	00003097          	auipc	ra,0x3
    2146:	3b0080e7          	jalr	944(ra) # 54f2 <exit>

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
    215a:	394080e7          	jalr	916(ra) # 54ea <fork>
  if(pid == 0) {
    215e:	c115                	beqz	a0,2182 <stacktest+0x38>
  } else if(pid < 0){
    2160:	04054363          	bltz	a0,21a6 <stacktest+0x5c>
  wait(&xstatus);
    2164:	fdc40513          	addi	a0,s0,-36
    2168:	00003097          	auipc	ra,0x3
    216c:	392080e7          	jalr	914(ra) # 54fa <wait>
  if(xstatus == -1)  // kernel killed child?
    2170:	fdc42503          	lw	a0,-36(s0)
    2174:	57fd                	li	a5,-1
    2176:	04f50663          	beq	a0,a5,21c2 <stacktest+0x78>
    exit(xstatus);
    217a:	00003097          	auipc	ra,0x3
    217e:	378080e7          	jalr	888(ra) # 54f2 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2182:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", *sp);
    2184:	77fd                	lui	a5,0xfffff
    2186:	97ba                	add	a5,a5,a4
    2188:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0680>
    218c:	00005517          	auipc	a0,0x5
    2190:	81c50513          	addi	a0,a0,-2020 # 69a8 <malloc+0x1080>
    2194:	00003097          	auipc	ra,0x3
    2198:	6d6080e7          	jalr	1750(ra) # 586a <printf>
    exit(1);
    219c:	4505                	li	a0,1
    219e:	00003097          	auipc	ra,0x3
    21a2:	354080e7          	jalr	852(ra) # 54f2 <exit>
    printf("%s: fork failed\n", s);
    21a6:	85a6                	mv	a1,s1
    21a8:	00004517          	auipc	a0,0x4
    21ac:	3e050513          	addi	a0,a0,992 # 6588 <malloc+0xc60>
    21b0:	00003097          	auipc	ra,0x3
    21b4:	6ba080e7          	jalr	1722(ra) # 586a <printf>
    exit(1);
    21b8:	4505                	li	a0,1
    21ba:	00003097          	auipc	ra,0x3
    21be:	338080e7          	jalr	824(ra) # 54f2 <exit>
    exit(0);
    21c2:	4501                	li	a0,0
    21c4:	00003097          	auipc	ra,0x3
    21c8:	32e080e7          	jalr	814(ra) # 54f2 <exit>

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
    21dc:	3a2080e7          	jalr	930(ra) # 557a <sbrk>
  uint64 top = (uint64) sbrk(0);
    21e0:	4501                	li	a0,0
    21e2:	00003097          	auipc	ra,0x3
    21e6:	398080e7          	jalr	920(ra) # 557a <sbrk>
  if((top % PGSIZE) != 0){
    21ea:	03451793          	slli	a5,a0,0x34
    21ee:	e3c9                	bnez	a5,2270 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    21f0:	4501                	li	a0,0
    21f2:	00003097          	auipc	ra,0x3
    21f6:	388080e7          	jalr	904(ra) # 557a <sbrk>
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
    2212:	334080e7          	jalr	820(ra) # 5542 <unlink>
  if(ret != -1){
    2216:	57fd                	li	a5,-1
    2218:	08f51363          	bne	a0,a5,229e <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    221c:	20100593          	li	a1,513
    2220:	8526                	mv	a0,s1
    2222:	00003097          	auipc	ra,0x3
    2226:	310080e7          	jalr	784(ra) # 5532 <open>
  if(fd != -1){
    222a:	57fd                	li	a5,-1
    222c:	08f51863          	bne	a0,a5,22bc <copyinstr3+0xf0>
  ret = link(b, b);
    2230:	85a6                	mv	a1,s1
    2232:	8526                	mv	a0,s1
    2234:	00003097          	auipc	ra,0x3
    2238:	31e080e7          	jalr	798(ra) # 5552 <link>
  if(ret != -1){
    223c:	57fd                	li	a5,-1
    223e:	08f51e63          	bne	a0,a5,22da <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2242:	00005797          	auipc	a5,0x5
    2246:	3ae78793          	addi	a5,a5,942 # 75f0 <malloc+0x1cc8>
    224a:	fcf43823          	sd	a5,-48(s0)
    224e:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2252:	fd040593          	addi	a1,s0,-48
    2256:	8526                	mv	a0,s1
    2258:	00003097          	auipc	ra,0x3
    225c:	2d2080e7          	jalr	722(ra) # 552a <exec>
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
    227e:	300080e7          	jalr	768(ra) # 557a <sbrk>
    2282:	b7bd                	j	21f0 <copyinstr3+0x24>
    printf("oops\n");
    2284:	00004517          	auipc	a0,0x4
    2288:	74c50513          	addi	a0,a0,1868 # 69d0 <malloc+0x10a8>
    228c:	00003097          	auipc	ra,0x3
    2290:	5de080e7          	jalr	1502(ra) # 586a <printf>
    exit(1);
    2294:	4505                	li	a0,1
    2296:	00003097          	auipc	ra,0x3
    229a:	25c080e7          	jalr	604(ra) # 54f2 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    229e:	862a                	mv	a2,a0
    22a0:	85a6                	mv	a1,s1
    22a2:	00004517          	auipc	a0,0x4
    22a6:	20650513          	addi	a0,a0,518 # 64a8 <malloc+0xb80>
    22aa:	00003097          	auipc	ra,0x3
    22ae:	5c0080e7          	jalr	1472(ra) # 586a <printf>
    exit(1);
    22b2:	4505                	li	a0,1
    22b4:	00003097          	auipc	ra,0x3
    22b8:	23e080e7          	jalr	574(ra) # 54f2 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    22bc:	862a                	mv	a2,a0
    22be:	85a6                	mv	a1,s1
    22c0:	00004517          	auipc	a0,0x4
    22c4:	20850513          	addi	a0,a0,520 # 64c8 <malloc+0xba0>
    22c8:	00003097          	auipc	ra,0x3
    22cc:	5a2080e7          	jalr	1442(ra) # 586a <printf>
    exit(1);
    22d0:	4505                	li	a0,1
    22d2:	00003097          	auipc	ra,0x3
    22d6:	220080e7          	jalr	544(ra) # 54f2 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    22da:	86aa                	mv	a3,a0
    22dc:	8626                	mv	a2,s1
    22de:	85a6                	mv	a1,s1
    22e0:	00004517          	auipc	a0,0x4
    22e4:	20850513          	addi	a0,a0,520 # 64e8 <malloc+0xbc0>
    22e8:	00003097          	auipc	ra,0x3
    22ec:	582080e7          	jalr	1410(ra) # 586a <printf>
    exit(1);
    22f0:	4505                	li	a0,1
    22f2:	00003097          	auipc	ra,0x3
    22f6:	200080e7          	jalr	512(ra) # 54f2 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    22fa:	567d                	li	a2,-1
    22fc:	85a6                	mv	a1,s1
    22fe:	00004517          	auipc	a0,0x4
    2302:	21250513          	addi	a0,a0,530 # 6510 <malloc+0xbe8>
    2306:	00003097          	auipc	ra,0x3
    230a:	564080e7          	jalr	1380(ra) # 586a <printf>
    exit(1);
    230e:	4505                	li	a0,1
    2310:	00003097          	auipc	ra,0x3
    2314:	1e2080e7          	jalr	482(ra) # 54f2 <exit>

0000000000002318 <rwsbrk>:
{
    2318:	1101                	addi	sp,sp,-32
    231a:	ec06                	sd	ra,24(sp)
    231c:	e822                	sd	s0,16(sp)
    231e:	e426                	sd	s1,8(sp)
    2320:	e04a                	sd	s2,0(sp)
    2322:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2324:	6509                	lui	a0,0x2
    2326:	00003097          	auipc	ra,0x3
    232a:	254080e7          	jalr	596(ra) # 557a <sbrk>
  if(a == 0xffffffffffffffffLL) {
    232e:	57fd                	li	a5,-1
    2330:	06f50363          	beq	a0,a5,2396 <rwsbrk+0x7e>
    2334:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2336:	7579                	lui	a0,0xffffe
    2338:	00003097          	auipc	ra,0x3
    233c:	242080e7          	jalr	578(ra) # 557a <sbrk>
    2340:	57fd                	li	a5,-1
    2342:	06f50763          	beq	a0,a5,23b0 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2346:	20100593          	li	a1,513
    234a:	00003517          	auipc	a0,0x3
    234e:	72e50513          	addi	a0,a0,1838 # 5a78 <malloc+0x150>
    2352:	00003097          	auipc	ra,0x3
    2356:	1e0080e7          	jalr	480(ra) # 5532 <open>
    235a:	892a                	mv	s2,a0
  if(fd < 0){
    235c:	06054763          	bltz	a0,23ca <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    2360:	6505                	lui	a0,0x1
    2362:	94aa                	add	s1,s1,a0
    2364:	40000613          	li	a2,1024
    2368:	85a6                	mv	a1,s1
    236a:	854a                	mv	a0,s2
    236c:	00003097          	auipc	ra,0x3
    2370:	1a6080e7          	jalr	422(ra) # 5512 <write>
    2374:	862a                	mv	a2,a0
  if(n >= 0){
    2376:	06054763          	bltz	a0,23e4 <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    237a:	85a6                	mv	a1,s1
    237c:	00004517          	auipc	a0,0x4
    2380:	6ac50513          	addi	a0,a0,1708 # 6a28 <malloc+0x1100>
    2384:	00003097          	auipc	ra,0x3
    2388:	4e6080e7          	jalr	1254(ra) # 586a <printf>
    exit(1);
    238c:	4505                	li	a0,1
    238e:	00003097          	auipc	ra,0x3
    2392:	164080e7          	jalr	356(ra) # 54f2 <exit>
    printf("sbrk(rwsbrk) failed\n");
    2396:	00004517          	auipc	a0,0x4
    239a:	64250513          	addi	a0,a0,1602 # 69d8 <malloc+0x10b0>
    239e:	00003097          	auipc	ra,0x3
    23a2:	4cc080e7          	jalr	1228(ra) # 586a <printf>
    exit(1);
    23a6:	4505                	li	a0,1
    23a8:	00003097          	auipc	ra,0x3
    23ac:	14a080e7          	jalr	330(ra) # 54f2 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    23b0:	00004517          	auipc	a0,0x4
    23b4:	64050513          	addi	a0,a0,1600 # 69f0 <malloc+0x10c8>
    23b8:	00003097          	auipc	ra,0x3
    23bc:	4b2080e7          	jalr	1202(ra) # 586a <printf>
    exit(1);
    23c0:	4505                	li	a0,1
    23c2:	00003097          	auipc	ra,0x3
    23c6:	130080e7          	jalr	304(ra) # 54f2 <exit>
    printf("open(rwsbrk) failed\n");
    23ca:	00004517          	auipc	a0,0x4
    23ce:	64650513          	addi	a0,a0,1606 # 6a10 <malloc+0x10e8>
    23d2:	00003097          	auipc	ra,0x3
    23d6:	498080e7          	jalr	1176(ra) # 586a <printf>
    exit(1);
    23da:	4505                	li	a0,1
    23dc:	00003097          	auipc	ra,0x3
    23e0:	116080e7          	jalr	278(ra) # 54f2 <exit>
  close(fd);
    23e4:	854a                	mv	a0,s2
    23e6:	00003097          	auipc	ra,0x3
    23ea:	134080e7          	jalr	308(ra) # 551a <close>
  unlink("rwsbrk");
    23ee:	00003517          	auipc	a0,0x3
    23f2:	68a50513          	addi	a0,a0,1674 # 5a78 <malloc+0x150>
    23f6:	00003097          	auipc	ra,0x3
    23fa:	14c080e7          	jalr	332(ra) # 5542 <unlink>
  fd = open("README", O_RDONLY);
    23fe:	4581                	li	a1,0
    2400:	00004517          	auipc	a0,0x4
    2404:	ae850513          	addi	a0,a0,-1304 # 5ee8 <malloc+0x5c0>
    2408:	00003097          	auipc	ra,0x3
    240c:	12a080e7          	jalr	298(ra) # 5532 <open>
    2410:	892a                	mv	s2,a0
  if(fd < 0){
    2412:	02054963          	bltz	a0,2444 <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    2416:	4629                	li	a2,10
    2418:	85a6                	mv	a1,s1
    241a:	00003097          	auipc	ra,0x3
    241e:	0f0080e7          	jalr	240(ra) # 550a <read>
    2422:	862a                	mv	a2,a0
  if(n >= 0){
    2424:	02054d63          	bltz	a0,245e <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2428:	85a6                	mv	a1,s1
    242a:	00004517          	auipc	a0,0x4
    242e:	62e50513          	addi	a0,a0,1582 # 6a58 <malloc+0x1130>
    2432:	00003097          	auipc	ra,0x3
    2436:	438080e7          	jalr	1080(ra) # 586a <printf>
    exit(1);
    243a:	4505                	li	a0,1
    243c:	00003097          	auipc	ra,0x3
    2440:	0b6080e7          	jalr	182(ra) # 54f2 <exit>
    printf("open(rwsbrk) failed\n");
    2444:	00004517          	auipc	a0,0x4
    2448:	5cc50513          	addi	a0,a0,1484 # 6a10 <malloc+0x10e8>
    244c:	00003097          	auipc	ra,0x3
    2450:	41e080e7          	jalr	1054(ra) # 586a <printf>
    exit(1);
    2454:	4505                	li	a0,1
    2456:	00003097          	auipc	ra,0x3
    245a:	09c080e7          	jalr	156(ra) # 54f2 <exit>
  close(fd);
    245e:	854a                	mv	a0,s2
    2460:	00003097          	auipc	ra,0x3
    2464:	0ba080e7          	jalr	186(ra) # 551a <close>
  exit(0);
    2468:	4501                	li	a0,0
    246a:	00003097          	auipc	ra,0x3
    246e:	088080e7          	jalr	136(ra) # 54f2 <exit>

0000000000002472 <sbrkbasic>:
{
    2472:	715d                	addi	sp,sp,-80
    2474:	e486                	sd	ra,72(sp)
    2476:	e0a2                	sd	s0,64(sp)
    2478:	fc26                	sd	s1,56(sp)
    247a:	f84a                	sd	s2,48(sp)
    247c:	f44e                	sd	s3,40(sp)
    247e:	f052                	sd	s4,32(sp)
    2480:	ec56                	sd	s5,24(sp)
    2482:	0880                	addi	s0,sp,80
    2484:	8a2a                	mv	s4,a0
  pid = fork();
    2486:	00003097          	auipc	ra,0x3
    248a:	064080e7          	jalr	100(ra) # 54ea <fork>
  if(pid < 0){
    248e:	02054c63          	bltz	a0,24c6 <sbrkbasic+0x54>
  if(pid == 0){
    2492:	ed21                	bnez	a0,24ea <sbrkbasic+0x78>
    a = sbrk(TOOMUCH);
    2494:	40000537          	lui	a0,0x40000
    2498:	00003097          	auipc	ra,0x3
    249c:	0e2080e7          	jalr	226(ra) # 557a <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    24a0:	57fd                	li	a5,-1
    24a2:	02f50f63          	beq	a0,a5,24e0 <sbrkbasic+0x6e>
    for(b = a; b < a+TOOMUCH; b += 4096){
    24a6:	400007b7          	lui	a5,0x40000
    24aa:	97aa                	add	a5,a5,a0
      *b = 99;
    24ac:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    24b0:	6705                	lui	a4,0x1
      *b = 99;
    24b2:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1680>
    for(b = a; b < a+TOOMUCH; b += 4096){
    24b6:	953a                	add	a0,a0,a4
    24b8:	fef51de3          	bne	a0,a5,24b2 <sbrkbasic+0x40>
    exit(1);
    24bc:	4505                	li	a0,1
    24be:	00003097          	auipc	ra,0x3
    24c2:	034080e7          	jalr	52(ra) # 54f2 <exit>
    printf("fork failed in sbrkbasic\n");
    24c6:	00004517          	auipc	a0,0x4
    24ca:	5ba50513          	addi	a0,a0,1466 # 6a80 <malloc+0x1158>
    24ce:	00003097          	auipc	ra,0x3
    24d2:	39c080e7          	jalr	924(ra) # 586a <printf>
    exit(1);
    24d6:	4505                	li	a0,1
    24d8:	00003097          	auipc	ra,0x3
    24dc:	01a080e7          	jalr	26(ra) # 54f2 <exit>
      exit(0);
    24e0:	4501                	li	a0,0
    24e2:	00003097          	auipc	ra,0x3
    24e6:	010080e7          	jalr	16(ra) # 54f2 <exit>
  wait(&xstatus);
    24ea:	fbc40513          	addi	a0,s0,-68
    24ee:	00003097          	auipc	ra,0x3
    24f2:	00c080e7          	jalr	12(ra) # 54fa <wait>
  if(xstatus == 1){
    24f6:	fbc42703          	lw	a4,-68(s0)
    24fa:	4785                	li	a5,1
    24fc:	00f70e63          	beq	a4,a5,2518 <sbrkbasic+0xa6>
  a = sbrk(0);
    2500:	4501                	li	a0,0
    2502:	00003097          	auipc	ra,0x3
    2506:	078080e7          	jalr	120(ra) # 557a <sbrk>
    250a:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    250c:	4901                	li	s2,0
    *b = 1;
    250e:	4a85                	li	s5,1
  for(i = 0; i < 5000; i++){
    2510:	6985                	lui	s3,0x1
    2512:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1ce>
    2516:	a005                	j	2536 <sbrkbasic+0xc4>
    printf("%s: too much memory allocated!\n", s);
    2518:	85d2                	mv	a1,s4
    251a:	00004517          	auipc	a0,0x4
    251e:	58650513          	addi	a0,a0,1414 # 6aa0 <malloc+0x1178>
    2522:	00003097          	auipc	ra,0x3
    2526:	348080e7          	jalr	840(ra) # 586a <printf>
    exit(1);
    252a:	4505                	li	a0,1
    252c:	00003097          	auipc	ra,0x3
    2530:	fc6080e7          	jalr	-58(ra) # 54f2 <exit>
    a = b + 1;
    2534:	84be                	mv	s1,a5
    b = sbrk(1);
    2536:	4505                	li	a0,1
    2538:	00003097          	auipc	ra,0x3
    253c:	042080e7          	jalr	66(ra) # 557a <sbrk>
    if(b != a){
    2540:	04951b63          	bne	a0,s1,2596 <sbrkbasic+0x124>
    *b = 1;
    2544:	01548023          	sb	s5,0(s1)
    a = b + 1;
    2548:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    254c:	2905                	addiw	s2,s2,1
    254e:	ff3913e3          	bne	s2,s3,2534 <sbrkbasic+0xc2>
  pid = fork();
    2552:	00003097          	auipc	ra,0x3
    2556:	f98080e7          	jalr	-104(ra) # 54ea <fork>
    255a:	892a                	mv	s2,a0
  if(pid < 0){
    255c:	04054d63          	bltz	a0,25b6 <sbrkbasic+0x144>
  c = sbrk(1);
    2560:	4505                	li	a0,1
    2562:	00003097          	auipc	ra,0x3
    2566:	018080e7          	jalr	24(ra) # 557a <sbrk>
  c = sbrk(1);
    256a:	4505                	li	a0,1
    256c:	00003097          	auipc	ra,0x3
    2570:	00e080e7          	jalr	14(ra) # 557a <sbrk>
  if(c != a + 1){
    2574:	0489                	addi	s1,s1,2
    2576:	04a48e63          	beq	s1,a0,25d2 <sbrkbasic+0x160>
    printf("%s: sbrk test failed post-fork\n", s);
    257a:	85d2                	mv	a1,s4
    257c:	00004517          	auipc	a0,0x4
    2580:	58450513          	addi	a0,a0,1412 # 6b00 <malloc+0x11d8>
    2584:	00003097          	auipc	ra,0x3
    2588:	2e6080e7          	jalr	742(ra) # 586a <printf>
    exit(1);
    258c:	4505                	li	a0,1
    258e:	00003097          	auipc	ra,0x3
    2592:	f64080e7          	jalr	-156(ra) # 54f2 <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    2596:	86aa                	mv	a3,a0
    2598:	8626                	mv	a2,s1
    259a:	85ca                	mv	a1,s2
    259c:	00004517          	auipc	a0,0x4
    25a0:	52450513          	addi	a0,a0,1316 # 6ac0 <malloc+0x1198>
    25a4:	00003097          	auipc	ra,0x3
    25a8:	2c6080e7          	jalr	710(ra) # 586a <printf>
      exit(1);
    25ac:	4505                	li	a0,1
    25ae:	00003097          	auipc	ra,0x3
    25b2:	f44080e7          	jalr	-188(ra) # 54f2 <exit>
    printf("%s: sbrk test fork failed\n", s);
    25b6:	85d2                	mv	a1,s4
    25b8:	00004517          	auipc	a0,0x4
    25bc:	52850513          	addi	a0,a0,1320 # 6ae0 <malloc+0x11b8>
    25c0:	00003097          	auipc	ra,0x3
    25c4:	2aa080e7          	jalr	682(ra) # 586a <printf>
    exit(1);
    25c8:	4505                	li	a0,1
    25ca:	00003097          	auipc	ra,0x3
    25ce:	f28080e7          	jalr	-216(ra) # 54f2 <exit>
  if(pid == 0)
    25d2:	00091763          	bnez	s2,25e0 <sbrkbasic+0x16e>
    exit(0);
    25d6:	4501                	li	a0,0
    25d8:	00003097          	auipc	ra,0x3
    25dc:	f1a080e7          	jalr	-230(ra) # 54f2 <exit>
  wait(&xstatus);
    25e0:	fbc40513          	addi	a0,s0,-68
    25e4:	00003097          	auipc	ra,0x3
    25e8:	f16080e7          	jalr	-234(ra) # 54fa <wait>
  exit(xstatus);
    25ec:	fbc42503          	lw	a0,-68(s0)
    25f0:	00003097          	auipc	ra,0x3
    25f4:	f02080e7          	jalr	-254(ra) # 54f2 <exit>

00000000000025f8 <sbrkmuch>:
{
    25f8:	7179                	addi	sp,sp,-48
    25fa:	f406                	sd	ra,40(sp)
    25fc:	f022                	sd	s0,32(sp)
    25fe:	ec26                	sd	s1,24(sp)
    2600:	e84a                	sd	s2,16(sp)
    2602:	e44e                	sd	s3,8(sp)
    2604:	e052                	sd	s4,0(sp)
    2606:	1800                	addi	s0,sp,48
    2608:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    260a:	4501                	li	a0,0
    260c:	00003097          	auipc	ra,0x3
    2610:	f6e080e7          	jalr	-146(ra) # 557a <sbrk>
    2614:	892a                	mv	s2,a0
  a = sbrk(0);
    2616:	4501                	li	a0,0
    2618:	00003097          	auipc	ra,0x3
    261c:	f62080e7          	jalr	-158(ra) # 557a <sbrk>
    2620:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2622:	06400537          	lui	a0,0x6400
    2626:	9d05                	subw	a0,a0,s1
    2628:	00003097          	auipc	ra,0x3
    262c:	f52080e7          	jalr	-174(ra) # 557a <sbrk>
  if (p != a) {
    2630:	0ca49863          	bne	s1,a0,2700 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2634:	4501                	li	a0,0
    2636:	00003097          	auipc	ra,0x3
    263a:	f44080e7          	jalr	-188(ra) # 557a <sbrk>
    263e:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2640:	00a4f963          	bgeu	s1,a0,2652 <sbrkmuch+0x5a>
    *pp = 1;
    2644:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2646:	6705                	lui	a4,0x1
    *pp = 1;
    2648:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    264c:	94ba                	add	s1,s1,a4
    264e:	fef4ede3          	bltu	s1,a5,2648 <sbrkmuch+0x50>
  *lastaddr = 99;
    2652:	064007b7          	lui	a5,0x6400
    2656:	06300713          	li	a4,99
    265a:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f167f>
  a = sbrk(0);
    265e:	4501                	li	a0,0
    2660:	00003097          	auipc	ra,0x3
    2664:	f1a080e7          	jalr	-230(ra) # 557a <sbrk>
    2668:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    266a:	757d                	lui	a0,0xfffff
    266c:	00003097          	auipc	ra,0x3
    2670:	f0e080e7          	jalr	-242(ra) # 557a <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2674:	57fd                	li	a5,-1
    2676:	0af50363          	beq	a0,a5,271c <sbrkmuch+0x124>
  c = sbrk(0);
    267a:	4501                	li	a0,0
    267c:	00003097          	auipc	ra,0x3
    2680:	efe080e7          	jalr	-258(ra) # 557a <sbrk>
  if(c != a - PGSIZE){
    2684:	77fd                	lui	a5,0xfffff
    2686:	97a6                	add	a5,a5,s1
    2688:	0af51863          	bne	a0,a5,2738 <sbrkmuch+0x140>
  a = sbrk(0);
    268c:	4501                	li	a0,0
    268e:	00003097          	auipc	ra,0x3
    2692:	eec080e7          	jalr	-276(ra) # 557a <sbrk>
    2696:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2698:	6505                	lui	a0,0x1
    269a:	00003097          	auipc	ra,0x3
    269e:	ee0080e7          	jalr	-288(ra) # 557a <sbrk>
    26a2:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    26a4:	0aa49963          	bne	s1,a0,2756 <sbrkmuch+0x15e>
    26a8:	4501                	li	a0,0
    26aa:	00003097          	auipc	ra,0x3
    26ae:	ed0080e7          	jalr	-304(ra) # 557a <sbrk>
    26b2:	6785                	lui	a5,0x1
    26b4:	97a6                	add	a5,a5,s1
    26b6:	0af51063          	bne	a0,a5,2756 <sbrkmuch+0x15e>
  if(*lastaddr == 99){
    26ba:	064007b7          	lui	a5,0x6400
    26be:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f167f>
    26c2:	06300793          	li	a5,99
    26c6:	0af70763          	beq	a4,a5,2774 <sbrkmuch+0x17c>
  a = sbrk(0);
    26ca:	4501                	li	a0,0
    26cc:	00003097          	auipc	ra,0x3
    26d0:	eae080e7          	jalr	-338(ra) # 557a <sbrk>
    26d4:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    26d6:	4501                	li	a0,0
    26d8:	00003097          	auipc	ra,0x3
    26dc:	ea2080e7          	jalr	-350(ra) # 557a <sbrk>
    26e0:	40a9053b          	subw	a0,s2,a0
    26e4:	00003097          	auipc	ra,0x3
    26e8:	e96080e7          	jalr	-362(ra) # 557a <sbrk>
  if(c != a){
    26ec:	0aa49263          	bne	s1,a0,2790 <sbrkmuch+0x198>
}
    26f0:	70a2                	ld	ra,40(sp)
    26f2:	7402                	ld	s0,32(sp)
    26f4:	64e2                	ld	s1,24(sp)
    26f6:	6942                	ld	s2,16(sp)
    26f8:	69a2                	ld	s3,8(sp)
    26fa:	6a02                	ld	s4,0(sp)
    26fc:	6145                	addi	sp,sp,48
    26fe:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2700:	85ce                	mv	a1,s3
    2702:	00004517          	auipc	a0,0x4
    2706:	41e50513          	addi	a0,a0,1054 # 6b20 <malloc+0x11f8>
    270a:	00003097          	auipc	ra,0x3
    270e:	160080e7          	jalr	352(ra) # 586a <printf>
    exit(1);
    2712:	4505                	li	a0,1
    2714:	00003097          	auipc	ra,0x3
    2718:	dde080e7          	jalr	-546(ra) # 54f2 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    271c:	85ce                	mv	a1,s3
    271e:	00004517          	auipc	a0,0x4
    2722:	44a50513          	addi	a0,a0,1098 # 6b68 <malloc+0x1240>
    2726:	00003097          	auipc	ra,0x3
    272a:	144080e7          	jalr	324(ra) # 586a <printf>
    exit(1);
    272e:	4505                	li	a0,1
    2730:	00003097          	auipc	ra,0x3
    2734:	dc2080e7          	jalr	-574(ra) # 54f2 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    2738:	862a                	mv	a2,a0
    273a:	85a6                	mv	a1,s1
    273c:	00004517          	auipc	a0,0x4
    2740:	44c50513          	addi	a0,a0,1100 # 6b88 <malloc+0x1260>
    2744:	00003097          	auipc	ra,0x3
    2748:	126080e7          	jalr	294(ra) # 586a <printf>
    exit(1);
    274c:	4505                	li	a0,1
    274e:	00003097          	auipc	ra,0x3
    2752:	da4080e7          	jalr	-604(ra) # 54f2 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", a, c);
    2756:	8652                	mv	a2,s4
    2758:	85a6                	mv	a1,s1
    275a:	00004517          	auipc	a0,0x4
    275e:	46e50513          	addi	a0,a0,1134 # 6bc8 <malloc+0x12a0>
    2762:	00003097          	auipc	ra,0x3
    2766:	108080e7          	jalr	264(ra) # 586a <printf>
    exit(1);
    276a:	4505                	li	a0,1
    276c:	00003097          	auipc	ra,0x3
    2770:	d86080e7          	jalr	-634(ra) # 54f2 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2774:	85ce                	mv	a1,s3
    2776:	00004517          	auipc	a0,0x4
    277a:	48250513          	addi	a0,a0,1154 # 6bf8 <malloc+0x12d0>
    277e:	00003097          	auipc	ra,0x3
    2782:	0ec080e7          	jalr	236(ra) # 586a <printf>
    exit(1);
    2786:	4505                	li	a0,1
    2788:	00003097          	auipc	ra,0x3
    278c:	d6a080e7          	jalr	-662(ra) # 54f2 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", a, c);
    2790:	862a                	mv	a2,a0
    2792:	85a6                	mv	a1,s1
    2794:	00004517          	auipc	a0,0x4
    2798:	49c50513          	addi	a0,a0,1180 # 6c30 <malloc+0x1308>
    279c:	00003097          	auipc	ra,0x3
    27a0:	0ce080e7          	jalr	206(ra) # 586a <printf>
    exit(1);
    27a4:	4505                	li	a0,1
    27a6:	00003097          	auipc	ra,0x3
    27aa:	d4c080e7          	jalr	-692(ra) # 54f2 <exit>

00000000000027ae <sbrkarg>:
{
    27ae:	7179                	addi	sp,sp,-48
    27b0:	f406                	sd	ra,40(sp)
    27b2:	f022                	sd	s0,32(sp)
    27b4:	ec26                	sd	s1,24(sp)
    27b6:	e84a                	sd	s2,16(sp)
    27b8:	e44e                	sd	s3,8(sp)
    27ba:	1800                	addi	s0,sp,48
    27bc:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    27be:	6505                	lui	a0,0x1
    27c0:	00003097          	auipc	ra,0x3
    27c4:	dba080e7          	jalr	-582(ra) # 557a <sbrk>
    27c8:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    27ca:	20100593          	li	a1,513
    27ce:	00004517          	auipc	a0,0x4
    27d2:	48a50513          	addi	a0,a0,1162 # 6c58 <malloc+0x1330>
    27d6:	00003097          	auipc	ra,0x3
    27da:	d5c080e7          	jalr	-676(ra) # 5532 <open>
    27de:	84aa                	mv	s1,a0
  unlink("sbrk");
    27e0:	00004517          	auipc	a0,0x4
    27e4:	47850513          	addi	a0,a0,1144 # 6c58 <malloc+0x1330>
    27e8:	00003097          	auipc	ra,0x3
    27ec:	d5a080e7          	jalr	-678(ra) # 5542 <unlink>
  if(fd < 0)  {
    27f0:	0404c163          	bltz	s1,2832 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    27f4:	6605                	lui	a2,0x1
    27f6:	85ca                	mv	a1,s2
    27f8:	8526                	mv	a0,s1
    27fa:	00003097          	auipc	ra,0x3
    27fe:	d18080e7          	jalr	-744(ra) # 5512 <write>
    2802:	04054663          	bltz	a0,284e <sbrkarg+0xa0>
  close(fd);
    2806:	8526                	mv	a0,s1
    2808:	00003097          	auipc	ra,0x3
    280c:	d12080e7          	jalr	-750(ra) # 551a <close>
  a = sbrk(PGSIZE);
    2810:	6505                	lui	a0,0x1
    2812:	00003097          	auipc	ra,0x3
    2816:	d68080e7          	jalr	-664(ra) # 557a <sbrk>
  if(pipe((int *) a) != 0){
    281a:	00003097          	auipc	ra,0x3
    281e:	ce8080e7          	jalr	-792(ra) # 5502 <pipe>
    2822:	e521                	bnez	a0,286a <sbrkarg+0xbc>
}
    2824:	70a2                	ld	ra,40(sp)
    2826:	7402                	ld	s0,32(sp)
    2828:	64e2                	ld	s1,24(sp)
    282a:	6942                	ld	s2,16(sp)
    282c:	69a2                	ld	s3,8(sp)
    282e:	6145                	addi	sp,sp,48
    2830:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2832:	85ce                	mv	a1,s3
    2834:	00004517          	auipc	a0,0x4
    2838:	42c50513          	addi	a0,a0,1068 # 6c60 <malloc+0x1338>
    283c:	00003097          	auipc	ra,0x3
    2840:	02e080e7          	jalr	46(ra) # 586a <printf>
    exit(1);
    2844:	4505                	li	a0,1
    2846:	00003097          	auipc	ra,0x3
    284a:	cac080e7          	jalr	-852(ra) # 54f2 <exit>
    printf("%s: write sbrk failed\n", s);
    284e:	85ce                	mv	a1,s3
    2850:	00004517          	auipc	a0,0x4
    2854:	42850513          	addi	a0,a0,1064 # 6c78 <malloc+0x1350>
    2858:	00003097          	auipc	ra,0x3
    285c:	012080e7          	jalr	18(ra) # 586a <printf>
    exit(1);
    2860:	4505                	li	a0,1
    2862:	00003097          	auipc	ra,0x3
    2866:	c90080e7          	jalr	-880(ra) # 54f2 <exit>
    printf("%s: pipe() failed\n", s);
    286a:	85ce                	mv	a1,s3
    286c:	00004517          	auipc	a0,0x4
    2870:	e2450513          	addi	a0,a0,-476 # 6690 <malloc+0xd68>
    2874:	00003097          	auipc	ra,0x3
    2878:	ff6080e7          	jalr	-10(ra) # 586a <printf>
    exit(1);
    287c:	4505                	li	a0,1
    287e:	00003097          	auipc	ra,0x3
    2882:	c74080e7          	jalr	-908(ra) # 54f2 <exit>

0000000000002886 <argptest>:
{
    2886:	1101                	addi	sp,sp,-32
    2888:	ec06                	sd	ra,24(sp)
    288a:	e822                	sd	s0,16(sp)
    288c:	e426                	sd	s1,8(sp)
    288e:	e04a                	sd	s2,0(sp)
    2890:	1000                	addi	s0,sp,32
    2892:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2894:	4581                	li	a1,0
    2896:	00004517          	auipc	a0,0x4
    289a:	3fa50513          	addi	a0,a0,1018 # 6c90 <malloc+0x1368>
    289e:	00003097          	auipc	ra,0x3
    28a2:	c94080e7          	jalr	-876(ra) # 5532 <open>
  if (fd < 0) {
    28a6:	02054b63          	bltz	a0,28dc <argptest+0x56>
    28aa:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    28ac:	4501                	li	a0,0
    28ae:	00003097          	auipc	ra,0x3
    28b2:	ccc080e7          	jalr	-820(ra) # 557a <sbrk>
    28b6:	567d                	li	a2,-1
    28b8:	fff50593          	addi	a1,a0,-1
    28bc:	8526                	mv	a0,s1
    28be:	00003097          	auipc	ra,0x3
    28c2:	c4c080e7          	jalr	-948(ra) # 550a <read>
  close(fd);
    28c6:	8526                	mv	a0,s1
    28c8:	00003097          	auipc	ra,0x3
    28cc:	c52080e7          	jalr	-942(ra) # 551a <close>
}
    28d0:	60e2                	ld	ra,24(sp)
    28d2:	6442                	ld	s0,16(sp)
    28d4:	64a2                	ld	s1,8(sp)
    28d6:	6902                	ld	s2,0(sp)
    28d8:	6105                	addi	sp,sp,32
    28da:	8082                	ret
    printf("%s: open failed\n", s);
    28dc:	85ca                	mv	a1,s2
    28de:	00004517          	auipc	a0,0x4
    28e2:	cc250513          	addi	a0,a0,-830 # 65a0 <malloc+0xc78>
    28e6:	00003097          	auipc	ra,0x3
    28ea:	f84080e7          	jalr	-124(ra) # 586a <printf>
    exit(1);
    28ee:	4505                	li	a0,1
    28f0:	00003097          	auipc	ra,0x3
    28f4:	c02080e7          	jalr	-1022(ra) # 54f2 <exit>

00000000000028f8 <sbrkbugs>:
{
    28f8:	1141                	addi	sp,sp,-16
    28fa:	e406                	sd	ra,8(sp)
    28fc:	e022                	sd	s0,0(sp)
    28fe:	0800                	addi	s0,sp,16
  int pid = fork();
    2900:	00003097          	auipc	ra,0x3
    2904:	bea080e7          	jalr	-1046(ra) # 54ea <fork>
  if(pid < 0){
    2908:	02054263          	bltz	a0,292c <sbrkbugs+0x34>
  if(pid == 0){
    290c:	ed0d                	bnez	a0,2946 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    290e:	00003097          	auipc	ra,0x3
    2912:	c6c080e7          	jalr	-916(ra) # 557a <sbrk>
    sbrk(-sz);
    2916:	40a0053b          	negw	a0,a0
    291a:	00003097          	auipc	ra,0x3
    291e:	c60080e7          	jalr	-928(ra) # 557a <sbrk>
    exit(0);
    2922:	4501                	li	a0,0
    2924:	00003097          	auipc	ra,0x3
    2928:	bce080e7          	jalr	-1074(ra) # 54f2 <exit>
    printf("fork failed\n");
    292c:	00004517          	auipc	a0,0x4
    2930:	04c50513          	addi	a0,a0,76 # 6978 <malloc+0x1050>
    2934:	00003097          	auipc	ra,0x3
    2938:	f36080e7          	jalr	-202(ra) # 586a <printf>
    exit(1);
    293c:	4505                	li	a0,1
    293e:	00003097          	auipc	ra,0x3
    2942:	bb4080e7          	jalr	-1100(ra) # 54f2 <exit>
  wait(0);
    2946:	4501                	li	a0,0
    2948:	00003097          	auipc	ra,0x3
    294c:	bb2080e7          	jalr	-1102(ra) # 54fa <wait>
  pid = fork();
    2950:	00003097          	auipc	ra,0x3
    2954:	b9a080e7          	jalr	-1126(ra) # 54ea <fork>
  if(pid < 0){
    2958:	02054563          	bltz	a0,2982 <sbrkbugs+0x8a>
  if(pid == 0){
    295c:	e121                	bnez	a0,299c <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    295e:	00003097          	auipc	ra,0x3
    2962:	c1c080e7          	jalr	-996(ra) # 557a <sbrk>
    sbrk(-(sz - 3500));
    2966:	6785                	lui	a5,0x1
    2968:	dac7879b          	addiw	a5,a5,-596
    296c:	40a7853b          	subw	a0,a5,a0
    2970:	00003097          	auipc	ra,0x3
    2974:	c0a080e7          	jalr	-1014(ra) # 557a <sbrk>
    exit(0);
    2978:	4501                	li	a0,0
    297a:	00003097          	auipc	ra,0x3
    297e:	b78080e7          	jalr	-1160(ra) # 54f2 <exit>
    printf("fork failed\n");
    2982:	00004517          	auipc	a0,0x4
    2986:	ff650513          	addi	a0,a0,-10 # 6978 <malloc+0x1050>
    298a:	00003097          	auipc	ra,0x3
    298e:	ee0080e7          	jalr	-288(ra) # 586a <printf>
    exit(1);
    2992:	4505                	li	a0,1
    2994:	00003097          	auipc	ra,0x3
    2998:	b5e080e7          	jalr	-1186(ra) # 54f2 <exit>
  wait(0);
    299c:	4501                	li	a0,0
    299e:	00003097          	auipc	ra,0x3
    29a2:	b5c080e7          	jalr	-1188(ra) # 54fa <wait>
  pid = fork();
    29a6:	00003097          	auipc	ra,0x3
    29aa:	b44080e7          	jalr	-1212(ra) # 54ea <fork>
  if(pid < 0){
    29ae:	02054a63          	bltz	a0,29e2 <sbrkbugs+0xea>
  if(pid == 0){
    29b2:	e529                	bnez	a0,29fc <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    29b4:	00003097          	auipc	ra,0x3
    29b8:	bc6080e7          	jalr	-1082(ra) # 557a <sbrk>
    29bc:	67ad                	lui	a5,0xb
    29be:	8007879b          	addiw	a5,a5,-2048
    29c2:	40a7853b          	subw	a0,a5,a0
    29c6:	00003097          	auipc	ra,0x3
    29ca:	bb4080e7          	jalr	-1100(ra) # 557a <sbrk>
    sbrk(-10);
    29ce:	5559                	li	a0,-10
    29d0:	00003097          	auipc	ra,0x3
    29d4:	baa080e7          	jalr	-1110(ra) # 557a <sbrk>
    exit(0);
    29d8:	4501                	li	a0,0
    29da:	00003097          	auipc	ra,0x3
    29de:	b18080e7          	jalr	-1256(ra) # 54f2 <exit>
    printf("fork failed\n");
    29e2:	00004517          	auipc	a0,0x4
    29e6:	f9650513          	addi	a0,a0,-106 # 6978 <malloc+0x1050>
    29ea:	00003097          	auipc	ra,0x3
    29ee:	e80080e7          	jalr	-384(ra) # 586a <printf>
    exit(1);
    29f2:	4505                	li	a0,1
    29f4:	00003097          	auipc	ra,0x3
    29f8:	afe080e7          	jalr	-1282(ra) # 54f2 <exit>
  wait(0);
    29fc:	4501                	li	a0,0
    29fe:	00003097          	auipc	ra,0x3
    2a02:	afc080e7          	jalr	-1284(ra) # 54fa <wait>
  exit(0);
    2a06:	4501                	li	a0,0
    2a08:	00003097          	auipc	ra,0x3
    2a0c:	aea080e7          	jalr	-1302(ra) # 54f2 <exit>

0000000000002a10 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2a10:	715d                	addi	sp,sp,-80
    2a12:	e486                	sd	ra,72(sp)
    2a14:	e0a2                	sd	s0,64(sp)
    2a16:	fc26                	sd	s1,56(sp)
    2a18:	f84a                	sd	s2,48(sp)
    2a1a:	f44e                	sd	s3,40(sp)
    2a1c:	f052                	sd	s4,32(sp)
    2a1e:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2a20:	4901                	li	s2,0
    2a22:	49bd                	li	s3,15
    int pid = fork();
    2a24:	00003097          	auipc	ra,0x3
    2a28:	ac6080e7          	jalr	-1338(ra) # 54ea <fork>
    2a2c:	84aa                	mv	s1,a0
    if(pid < 0){
    2a2e:	02054063          	bltz	a0,2a4e <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2a32:	c91d                	beqz	a0,2a68 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2a34:	4501                	li	a0,0
    2a36:	00003097          	auipc	ra,0x3
    2a3a:	ac4080e7          	jalr	-1340(ra) # 54fa <wait>
  for(int avail = 0; avail < 15; avail++){
    2a3e:	2905                	addiw	s2,s2,1
    2a40:	ff3912e3          	bne	s2,s3,2a24 <execout+0x14>
    }
  }

  exit(0);
    2a44:	4501                	li	a0,0
    2a46:	00003097          	auipc	ra,0x3
    2a4a:	aac080e7          	jalr	-1364(ra) # 54f2 <exit>
      printf("fork failed\n");
    2a4e:	00004517          	auipc	a0,0x4
    2a52:	f2a50513          	addi	a0,a0,-214 # 6978 <malloc+0x1050>
    2a56:	00003097          	auipc	ra,0x3
    2a5a:	e14080e7          	jalr	-492(ra) # 586a <printf>
      exit(1);
    2a5e:	4505                	li	a0,1
    2a60:	00003097          	auipc	ra,0x3
    2a64:	a92080e7          	jalr	-1390(ra) # 54f2 <exit>
        if(a == 0xffffffffffffffffLL)
    2a68:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2a6a:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2a6c:	6505                	lui	a0,0x1
    2a6e:	00003097          	auipc	ra,0x3
    2a72:	b0c080e7          	jalr	-1268(ra) # 557a <sbrk>
        if(a == 0xffffffffffffffffLL)
    2a76:	01350763          	beq	a0,s3,2a84 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2a7a:	6785                	lui	a5,0x1
    2a7c:	953e                	add	a0,a0,a5
    2a7e:	ff450fa3          	sb	s4,-1(a0) # fff <bigdir+0x95>
      while(1){
    2a82:	b7ed                	j	2a6c <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2a84:	01205a63          	blez	s2,2a98 <execout+0x88>
        sbrk(-4096);
    2a88:	757d                	lui	a0,0xfffff
    2a8a:	00003097          	auipc	ra,0x3
    2a8e:	af0080e7          	jalr	-1296(ra) # 557a <sbrk>
      for(int i = 0; i < avail; i++)
    2a92:	2485                	addiw	s1,s1,1
    2a94:	ff249ae3          	bne	s1,s2,2a88 <execout+0x78>
      close(1);
    2a98:	4505                	li	a0,1
    2a9a:	00003097          	auipc	ra,0x3
    2a9e:	a80080e7          	jalr	-1408(ra) # 551a <close>
      char *args[] = { "echo", "x", 0 };
    2aa2:	00003517          	auipc	a0,0x3
    2aa6:	2ae50513          	addi	a0,a0,686 # 5d50 <malloc+0x428>
    2aaa:	faa43c23          	sd	a0,-72(s0)
    2aae:	00003797          	auipc	a5,0x3
    2ab2:	31278793          	addi	a5,a5,786 # 5dc0 <malloc+0x498>
    2ab6:	fcf43023          	sd	a5,-64(s0)
    2aba:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2abe:	fb840593          	addi	a1,s0,-72
    2ac2:	00003097          	auipc	ra,0x3
    2ac6:	a68080e7          	jalr	-1432(ra) # 552a <exec>
      exit(0);
    2aca:	4501                	li	a0,0
    2acc:	00003097          	auipc	ra,0x3
    2ad0:	a26080e7          	jalr	-1498(ra) # 54f2 <exit>

0000000000002ad4 <fourteen>:
{
    2ad4:	1101                	addi	sp,sp,-32
    2ad6:	ec06                	sd	ra,24(sp)
    2ad8:	e822                	sd	s0,16(sp)
    2ada:	e426                	sd	s1,8(sp)
    2adc:	1000                	addi	s0,sp,32
    2ade:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2ae0:	00004517          	auipc	a0,0x4
    2ae4:	38850513          	addi	a0,a0,904 # 6e68 <malloc+0x1540>
    2ae8:	00003097          	auipc	ra,0x3
    2aec:	a72080e7          	jalr	-1422(ra) # 555a <mkdir>
    2af0:	e165                	bnez	a0,2bd0 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2af2:	00004517          	auipc	a0,0x4
    2af6:	1ce50513          	addi	a0,a0,462 # 6cc0 <malloc+0x1398>
    2afa:	00003097          	auipc	ra,0x3
    2afe:	a60080e7          	jalr	-1440(ra) # 555a <mkdir>
    2b02:	e56d                	bnez	a0,2bec <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2b04:	20000593          	li	a1,512
    2b08:	00004517          	auipc	a0,0x4
    2b0c:	21050513          	addi	a0,a0,528 # 6d18 <malloc+0x13f0>
    2b10:	00003097          	auipc	ra,0x3
    2b14:	a22080e7          	jalr	-1502(ra) # 5532 <open>
  if(fd < 0){
    2b18:	0e054863          	bltz	a0,2c08 <fourteen+0x134>
  close(fd);
    2b1c:	00003097          	auipc	ra,0x3
    2b20:	9fe080e7          	jalr	-1538(ra) # 551a <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2b24:	4581                	li	a1,0
    2b26:	00004517          	auipc	a0,0x4
    2b2a:	26a50513          	addi	a0,a0,618 # 6d90 <malloc+0x1468>
    2b2e:	00003097          	auipc	ra,0x3
    2b32:	a04080e7          	jalr	-1532(ra) # 5532 <open>
  if(fd < 0){
    2b36:	0e054763          	bltz	a0,2c24 <fourteen+0x150>
  close(fd);
    2b3a:	00003097          	auipc	ra,0x3
    2b3e:	9e0080e7          	jalr	-1568(ra) # 551a <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2b42:	00004517          	auipc	a0,0x4
    2b46:	2be50513          	addi	a0,a0,702 # 6e00 <malloc+0x14d8>
    2b4a:	00003097          	auipc	ra,0x3
    2b4e:	a10080e7          	jalr	-1520(ra) # 555a <mkdir>
    2b52:	c57d                	beqz	a0,2c40 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2b54:	00004517          	auipc	a0,0x4
    2b58:	30450513          	addi	a0,a0,772 # 6e58 <malloc+0x1530>
    2b5c:	00003097          	auipc	ra,0x3
    2b60:	9fe080e7          	jalr	-1538(ra) # 555a <mkdir>
    2b64:	cd65                	beqz	a0,2c5c <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2b66:	00004517          	auipc	a0,0x4
    2b6a:	2f250513          	addi	a0,a0,754 # 6e58 <malloc+0x1530>
    2b6e:	00003097          	auipc	ra,0x3
    2b72:	9d4080e7          	jalr	-1580(ra) # 5542 <unlink>
  unlink("12345678901234/12345678901234");
    2b76:	00004517          	auipc	a0,0x4
    2b7a:	28a50513          	addi	a0,a0,650 # 6e00 <malloc+0x14d8>
    2b7e:	00003097          	auipc	ra,0x3
    2b82:	9c4080e7          	jalr	-1596(ra) # 5542 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2b86:	00004517          	auipc	a0,0x4
    2b8a:	20a50513          	addi	a0,a0,522 # 6d90 <malloc+0x1468>
    2b8e:	00003097          	auipc	ra,0x3
    2b92:	9b4080e7          	jalr	-1612(ra) # 5542 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2b96:	00004517          	auipc	a0,0x4
    2b9a:	18250513          	addi	a0,a0,386 # 6d18 <malloc+0x13f0>
    2b9e:	00003097          	auipc	ra,0x3
    2ba2:	9a4080e7          	jalr	-1628(ra) # 5542 <unlink>
  unlink("12345678901234/123456789012345");
    2ba6:	00004517          	auipc	a0,0x4
    2baa:	11a50513          	addi	a0,a0,282 # 6cc0 <malloc+0x1398>
    2bae:	00003097          	auipc	ra,0x3
    2bb2:	994080e7          	jalr	-1644(ra) # 5542 <unlink>
  unlink("12345678901234");
    2bb6:	00004517          	auipc	a0,0x4
    2bba:	2b250513          	addi	a0,a0,690 # 6e68 <malloc+0x1540>
    2bbe:	00003097          	auipc	ra,0x3
    2bc2:	984080e7          	jalr	-1660(ra) # 5542 <unlink>
}
    2bc6:	60e2                	ld	ra,24(sp)
    2bc8:	6442                	ld	s0,16(sp)
    2bca:	64a2                	ld	s1,8(sp)
    2bcc:	6105                	addi	sp,sp,32
    2bce:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2bd0:	85a6                	mv	a1,s1
    2bd2:	00004517          	auipc	a0,0x4
    2bd6:	0c650513          	addi	a0,a0,198 # 6c98 <malloc+0x1370>
    2bda:	00003097          	auipc	ra,0x3
    2bde:	c90080e7          	jalr	-880(ra) # 586a <printf>
    exit(1);
    2be2:	4505                	li	a0,1
    2be4:	00003097          	auipc	ra,0x3
    2be8:	90e080e7          	jalr	-1778(ra) # 54f2 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2bec:	85a6                	mv	a1,s1
    2bee:	00004517          	auipc	a0,0x4
    2bf2:	0f250513          	addi	a0,a0,242 # 6ce0 <malloc+0x13b8>
    2bf6:	00003097          	auipc	ra,0x3
    2bfa:	c74080e7          	jalr	-908(ra) # 586a <printf>
    exit(1);
    2bfe:	4505                	li	a0,1
    2c00:	00003097          	auipc	ra,0x3
    2c04:	8f2080e7          	jalr	-1806(ra) # 54f2 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2c08:	85a6                	mv	a1,s1
    2c0a:	00004517          	auipc	a0,0x4
    2c0e:	13e50513          	addi	a0,a0,318 # 6d48 <malloc+0x1420>
    2c12:	00003097          	auipc	ra,0x3
    2c16:	c58080e7          	jalr	-936(ra) # 586a <printf>
    exit(1);
    2c1a:	4505                	li	a0,1
    2c1c:	00003097          	auipc	ra,0x3
    2c20:	8d6080e7          	jalr	-1834(ra) # 54f2 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2c24:	85a6                	mv	a1,s1
    2c26:	00004517          	auipc	a0,0x4
    2c2a:	19a50513          	addi	a0,a0,410 # 6dc0 <malloc+0x1498>
    2c2e:	00003097          	auipc	ra,0x3
    2c32:	c3c080e7          	jalr	-964(ra) # 586a <printf>
    exit(1);
    2c36:	4505                	li	a0,1
    2c38:	00003097          	auipc	ra,0x3
    2c3c:	8ba080e7          	jalr	-1862(ra) # 54f2 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2c40:	85a6                	mv	a1,s1
    2c42:	00004517          	auipc	a0,0x4
    2c46:	1de50513          	addi	a0,a0,478 # 6e20 <malloc+0x14f8>
    2c4a:	00003097          	auipc	ra,0x3
    2c4e:	c20080e7          	jalr	-992(ra) # 586a <printf>
    exit(1);
    2c52:	4505                	li	a0,1
    2c54:	00003097          	auipc	ra,0x3
    2c58:	89e080e7          	jalr	-1890(ra) # 54f2 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2c5c:	85a6                	mv	a1,s1
    2c5e:	00004517          	auipc	a0,0x4
    2c62:	21a50513          	addi	a0,a0,538 # 6e78 <malloc+0x1550>
    2c66:	00003097          	auipc	ra,0x3
    2c6a:	c04080e7          	jalr	-1020(ra) # 586a <printf>
    exit(1);
    2c6e:	4505                	li	a0,1
    2c70:	00003097          	auipc	ra,0x3
    2c74:	882080e7          	jalr	-1918(ra) # 54f2 <exit>

0000000000002c78 <iputtest>:
{
    2c78:	1101                	addi	sp,sp,-32
    2c7a:	ec06                	sd	ra,24(sp)
    2c7c:	e822                	sd	s0,16(sp)
    2c7e:	e426                	sd	s1,8(sp)
    2c80:	1000                	addi	s0,sp,32
    2c82:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2c84:	00004517          	auipc	a0,0x4
    2c88:	22c50513          	addi	a0,a0,556 # 6eb0 <malloc+0x1588>
    2c8c:	00003097          	auipc	ra,0x3
    2c90:	8ce080e7          	jalr	-1842(ra) # 555a <mkdir>
    2c94:	04054563          	bltz	a0,2cde <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2c98:	00004517          	auipc	a0,0x4
    2c9c:	21850513          	addi	a0,a0,536 # 6eb0 <malloc+0x1588>
    2ca0:	00003097          	auipc	ra,0x3
    2ca4:	8c2080e7          	jalr	-1854(ra) # 5562 <chdir>
    2ca8:	04054963          	bltz	a0,2cfa <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2cac:	00004517          	auipc	a0,0x4
    2cb0:	24450513          	addi	a0,a0,580 # 6ef0 <malloc+0x15c8>
    2cb4:	00003097          	auipc	ra,0x3
    2cb8:	88e080e7          	jalr	-1906(ra) # 5542 <unlink>
    2cbc:	04054d63          	bltz	a0,2d16 <iputtest+0x9e>
  if(chdir("/") < 0){
    2cc0:	00004517          	auipc	a0,0x4
    2cc4:	26050513          	addi	a0,a0,608 # 6f20 <malloc+0x15f8>
    2cc8:	00003097          	auipc	ra,0x3
    2ccc:	89a080e7          	jalr	-1894(ra) # 5562 <chdir>
    2cd0:	06054163          	bltz	a0,2d32 <iputtest+0xba>
}
    2cd4:	60e2                	ld	ra,24(sp)
    2cd6:	6442                	ld	s0,16(sp)
    2cd8:	64a2                	ld	s1,8(sp)
    2cda:	6105                	addi	sp,sp,32
    2cdc:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2cde:	85a6                	mv	a1,s1
    2ce0:	00004517          	auipc	a0,0x4
    2ce4:	1d850513          	addi	a0,a0,472 # 6eb8 <malloc+0x1590>
    2ce8:	00003097          	auipc	ra,0x3
    2cec:	b82080e7          	jalr	-1150(ra) # 586a <printf>
    exit(1);
    2cf0:	4505                	li	a0,1
    2cf2:	00003097          	auipc	ra,0x3
    2cf6:	800080e7          	jalr	-2048(ra) # 54f2 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2cfa:	85a6                	mv	a1,s1
    2cfc:	00004517          	auipc	a0,0x4
    2d00:	1d450513          	addi	a0,a0,468 # 6ed0 <malloc+0x15a8>
    2d04:	00003097          	auipc	ra,0x3
    2d08:	b66080e7          	jalr	-1178(ra) # 586a <printf>
    exit(1);
    2d0c:	4505                	li	a0,1
    2d0e:	00002097          	auipc	ra,0x2
    2d12:	7e4080e7          	jalr	2020(ra) # 54f2 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2d16:	85a6                	mv	a1,s1
    2d18:	00004517          	auipc	a0,0x4
    2d1c:	1e850513          	addi	a0,a0,488 # 6f00 <malloc+0x15d8>
    2d20:	00003097          	auipc	ra,0x3
    2d24:	b4a080e7          	jalr	-1206(ra) # 586a <printf>
    exit(1);
    2d28:	4505                	li	a0,1
    2d2a:	00002097          	auipc	ra,0x2
    2d2e:	7c8080e7          	jalr	1992(ra) # 54f2 <exit>
    printf("%s: chdir / failed\n", s);
    2d32:	85a6                	mv	a1,s1
    2d34:	00004517          	auipc	a0,0x4
    2d38:	1f450513          	addi	a0,a0,500 # 6f28 <malloc+0x1600>
    2d3c:	00003097          	auipc	ra,0x3
    2d40:	b2e080e7          	jalr	-1234(ra) # 586a <printf>
    exit(1);
    2d44:	4505                	li	a0,1
    2d46:	00002097          	auipc	ra,0x2
    2d4a:	7ac080e7          	jalr	1964(ra) # 54f2 <exit>

0000000000002d4e <exitiputtest>:
{
    2d4e:	7179                	addi	sp,sp,-48
    2d50:	f406                	sd	ra,40(sp)
    2d52:	f022                	sd	s0,32(sp)
    2d54:	ec26                	sd	s1,24(sp)
    2d56:	1800                	addi	s0,sp,48
    2d58:	84aa                	mv	s1,a0
  pid = fork();
    2d5a:	00002097          	auipc	ra,0x2
    2d5e:	790080e7          	jalr	1936(ra) # 54ea <fork>
  if(pid < 0){
    2d62:	04054663          	bltz	a0,2dae <exitiputtest+0x60>
  if(pid == 0){
    2d66:	ed45                	bnez	a0,2e1e <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2d68:	00004517          	auipc	a0,0x4
    2d6c:	14850513          	addi	a0,a0,328 # 6eb0 <malloc+0x1588>
    2d70:	00002097          	auipc	ra,0x2
    2d74:	7ea080e7          	jalr	2026(ra) # 555a <mkdir>
    2d78:	04054963          	bltz	a0,2dca <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2d7c:	00004517          	auipc	a0,0x4
    2d80:	13450513          	addi	a0,a0,308 # 6eb0 <malloc+0x1588>
    2d84:	00002097          	auipc	ra,0x2
    2d88:	7de080e7          	jalr	2014(ra) # 5562 <chdir>
    2d8c:	04054d63          	bltz	a0,2de6 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2d90:	00004517          	auipc	a0,0x4
    2d94:	16050513          	addi	a0,a0,352 # 6ef0 <malloc+0x15c8>
    2d98:	00002097          	auipc	ra,0x2
    2d9c:	7aa080e7          	jalr	1962(ra) # 5542 <unlink>
    2da0:	06054163          	bltz	a0,2e02 <exitiputtest+0xb4>
    exit(0);
    2da4:	4501                	li	a0,0
    2da6:	00002097          	auipc	ra,0x2
    2daa:	74c080e7          	jalr	1868(ra) # 54f2 <exit>
    printf("%s: fork failed\n", s);
    2dae:	85a6                	mv	a1,s1
    2db0:	00003517          	auipc	a0,0x3
    2db4:	7d850513          	addi	a0,a0,2008 # 6588 <malloc+0xc60>
    2db8:	00003097          	auipc	ra,0x3
    2dbc:	ab2080e7          	jalr	-1358(ra) # 586a <printf>
    exit(1);
    2dc0:	4505                	li	a0,1
    2dc2:	00002097          	auipc	ra,0x2
    2dc6:	730080e7          	jalr	1840(ra) # 54f2 <exit>
      printf("%s: mkdir failed\n", s);
    2dca:	85a6                	mv	a1,s1
    2dcc:	00004517          	auipc	a0,0x4
    2dd0:	0ec50513          	addi	a0,a0,236 # 6eb8 <malloc+0x1590>
    2dd4:	00003097          	auipc	ra,0x3
    2dd8:	a96080e7          	jalr	-1386(ra) # 586a <printf>
      exit(1);
    2ddc:	4505                	li	a0,1
    2dde:	00002097          	auipc	ra,0x2
    2de2:	714080e7          	jalr	1812(ra) # 54f2 <exit>
      printf("%s: child chdir failed\n", s);
    2de6:	85a6                	mv	a1,s1
    2de8:	00004517          	auipc	a0,0x4
    2dec:	15850513          	addi	a0,a0,344 # 6f40 <malloc+0x1618>
    2df0:	00003097          	auipc	ra,0x3
    2df4:	a7a080e7          	jalr	-1414(ra) # 586a <printf>
      exit(1);
    2df8:	4505                	li	a0,1
    2dfa:	00002097          	auipc	ra,0x2
    2dfe:	6f8080e7          	jalr	1784(ra) # 54f2 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2e02:	85a6                	mv	a1,s1
    2e04:	00004517          	auipc	a0,0x4
    2e08:	0fc50513          	addi	a0,a0,252 # 6f00 <malloc+0x15d8>
    2e0c:	00003097          	auipc	ra,0x3
    2e10:	a5e080e7          	jalr	-1442(ra) # 586a <printf>
      exit(1);
    2e14:	4505                	li	a0,1
    2e16:	00002097          	auipc	ra,0x2
    2e1a:	6dc080e7          	jalr	1756(ra) # 54f2 <exit>
  wait(&xstatus);
    2e1e:	fdc40513          	addi	a0,s0,-36
    2e22:	00002097          	auipc	ra,0x2
    2e26:	6d8080e7          	jalr	1752(ra) # 54fa <wait>
  exit(xstatus);
    2e2a:	fdc42503          	lw	a0,-36(s0)
    2e2e:	00002097          	auipc	ra,0x2
    2e32:	6c4080e7          	jalr	1732(ra) # 54f2 <exit>

0000000000002e36 <subdir>:
{
    2e36:	1101                	addi	sp,sp,-32
    2e38:	ec06                	sd	ra,24(sp)
    2e3a:	e822                	sd	s0,16(sp)
    2e3c:	e426                	sd	s1,8(sp)
    2e3e:	e04a                	sd	s2,0(sp)
    2e40:	1000                	addi	s0,sp,32
    2e42:	892a                	mv	s2,a0
  unlink("ff");
    2e44:	00004517          	auipc	a0,0x4
    2e48:	24450513          	addi	a0,a0,580 # 7088 <malloc+0x1760>
    2e4c:	00002097          	auipc	ra,0x2
    2e50:	6f6080e7          	jalr	1782(ra) # 5542 <unlink>
  if(mkdir("dd") != 0){
    2e54:	00004517          	auipc	a0,0x4
    2e58:	10450513          	addi	a0,a0,260 # 6f58 <malloc+0x1630>
    2e5c:	00002097          	auipc	ra,0x2
    2e60:	6fe080e7          	jalr	1790(ra) # 555a <mkdir>
    2e64:	38051663          	bnez	a0,31f0 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2e68:	20200593          	li	a1,514
    2e6c:	00004517          	auipc	a0,0x4
    2e70:	10c50513          	addi	a0,a0,268 # 6f78 <malloc+0x1650>
    2e74:	00002097          	auipc	ra,0x2
    2e78:	6be080e7          	jalr	1726(ra) # 5532 <open>
    2e7c:	84aa                	mv	s1,a0
  if(fd < 0){
    2e7e:	38054763          	bltz	a0,320c <subdir+0x3d6>
  write(fd, "ff", 2);
    2e82:	4609                	li	a2,2
    2e84:	00004597          	auipc	a1,0x4
    2e88:	20458593          	addi	a1,a1,516 # 7088 <malloc+0x1760>
    2e8c:	00002097          	auipc	ra,0x2
    2e90:	686080e7          	jalr	1670(ra) # 5512 <write>
  close(fd);
    2e94:	8526                	mv	a0,s1
    2e96:	00002097          	auipc	ra,0x2
    2e9a:	684080e7          	jalr	1668(ra) # 551a <close>
  if(unlink("dd") >= 0){
    2e9e:	00004517          	auipc	a0,0x4
    2ea2:	0ba50513          	addi	a0,a0,186 # 6f58 <malloc+0x1630>
    2ea6:	00002097          	auipc	ra,0x2
    2eaa:	69c080e7          	jalr	1692(ra) # 5542 <unlink>
    2eae:	36055d63          	bgez	a0,3228 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    2eb2:	00004517          	auipc	a0,0x4
    2eb6:	11e50513          	addi	a0,a0,286 # 6fd0 <malloc+0x16a8>
    2eba:	00002097          	auipc	ra,0x2
    2ebe:	6a0080e7          	jalr	1696(ra) # 555a <mkdir>
    2ec2:	38051163          	bnez	a0,3244 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2ec6:	20200593          	li	a1,514
    2eca:	00004517          	auipc	a0,0x4
    2ece:	12e50513          	addi	a0,a0,302 # 6ff8 <malloc+0x16d0>
    2ed2:	00002097          	auipc	ra,0x2
    2ed6:	660080e7          	jalr	1632(ra) # 5532 <open>
    2eda:	84aa                	mv	s1,a0
  if(fd < 0){
    2edc:	38054263          	bltz	a0,3260 <subdir+0x42a>
  write(fd, "FF", 2);
    2ee0:	4609                	li	a2,2
    2ee2:	00004597          	auipc	a1,0x4
    2ee6:	14658593          	addi	a1,a1,326 # 7028 <malloc+0x1700>
    2eea:	00002097          	auipc	ra,0x2
    2eee:	628080e7          	jalr	1576(ra) # 5512 <write>
  close(fd);
    2ef2:	8526                	mv	a0,s1
    2ef4:	00002097          	auipc	ra,0x2
    2ef8:	626080e7          	jalr	1574(ra) # 551a <close>
  fd = open("dd/dd/../ff", 0);
    2efc:	4581                	li	a1,0
    2efe:	00004517          	auipc	a0,0x4
    2f02:	13250513          	addi	a0,a0,306 # 7030 <malloc+0x1708>
    2f06:	00002097          	auipc	ra,0x2
    2f0a:	62c080e7          	jalr	1580(ra) # 5532 <open>
    2f0e:	84aa                	mv	s1,a0
  if(fd < 0){
    2f10:	36054663          	bltz	a0,327c <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    2f14:	660d                	lui	a2,0x3
    2f16:	00009597          	auipc	a1,0x9
    2f1a:	a5a58593          	addi	a1,a1,-1446 # b970 <buf>
    2f1e:	00002097          	auipc	ra,0x2
    2f22:	5ec080e7          	jalr	1516(ra) # 550a <read>
  if(cc != 2 || buf[0] != 'f'){
    2f26:	4789                	li	a5,2
    2f28:	36f51863          	bne	a0,a5,3298 <subdir+0x462>
    2f2c:	00009717          	auipc	a4,0x9
    2f30:	a4474703          	lbu	a4,-1468(a4) # b970 <buf>
    2f34:	06600793          	li	a5,102
    2f38:	36f71063          	bne	a4,a5,3298 <subdir+0x462>
  close(fd);
    2f3c:	8526                	mv	a0,s1
    2f3e:	00002097          	auipc	ra,0x2
    2f42:	5dc080e7          	jalr	1500(ra) # 551a <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2f46:	00004597          	auipc	a1,0x4
    2f4a:	13a58593          	addi	a1,a1,314 # 7080 <malloc+0x1758>
    2f4e:	00004517          	auipc	a0,0x4
    2f52:	0aa50513          	addi	a0,a0,170 # 6ff8 <malloc+0x16d0>
    2f56:	00002097          	auipc	ra,0x2
    2f5a:	5fc080e7          	jalr	1532(ra) # 5552 <link>
    2f5e:	34051b63          	bnez	a0,32b4 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    2f62:	00004517          	auipc	a0,0x4
    2f66:	09650513          	addi	a0,a0,150 # 6ff8 <malloc+0x16d0>
    2f6a:	00002097          	auipc	ra,0x2
    2f6e:	5d8080e7          	jalr	1496(ra) # 5542 <unlink>
    2f72:	34051f63          	bnez	a0,32d0 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2f76:	4581                	li	a1,0
    2f78:	00004517          	auipc	a0,0x4
    2f7c:	08050513          	addi	a0,a0,128 # 6ff8 <malloc+0x16d0>
    2f80:	00002097          	auipc	ra,0x2
    2f84:	5b2080e7          	jalr	1458(ra) # 5532 <open>
    2f88:	36055263          	bgez	a0,32ec <subdir+0x4b6>
  if(chdir("dd") != 0){
    2f8c:	00004517          	auipc	a0,0x4
    2f90:	fcc50513          	addi	a0,a0,-52 # 6f58 <malloc+0x1630>
    2f94:	00002097          	auipc	ra,0x2
    2f98:	5ce080e7          	jalr	1486(ra) # 5562 <chdir>
    2f9c:	36051663          	bnez	a0,3308 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    2fa0:	00004517          	auipc	a0,0x4
    2fa4:	17850513          	addi	a0,a0,376 # 7118 <malloc+0x17f0>
    2fa8:	00002097          	auipc	ra,0x2
    2fac:	5ba080e7          	jalr	1466(ra) # 5562 <chdir>
    2fb0:	36051a63          	bnez	a0,3324 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    2fb4:	00004517          	auipc	a0,0x4
    2fb8:	19450513          	addi	a0,a0,404 # 7148 <malloc+0x1820>
    2fbc:	00002097          	auipc	ra,0x2
    2fc0:	5a6080e7          	jalr	1446(ra) # 5562 <chdir>
    2fc4:	36051e63          	bnez	a0,3340 <subdir+0x50a>
  if(chdir("./..") != 0){
    2fc8:	00004517          	auipc	a0,0x4
    2fcc:	1b050513          	addi	a0,a0,432 # 7178 <malloc+0x1850>
    2fd0:	00002097          	auipc	ra,0x2
    2fd4:	592080e7          	jalr	1426(ra) # 5562 <chdir>
    2fd8:	38051263          	bnez	a0,335c <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    2fdc:	4581                	li	a1,0
    2fde:	00004517          	auipc	a0,0x4
    2fe2:	0a250513          	addi	a0,a0,162 # 7080 <malloc+0x1758>
    2fe6:	00002097          	auipc	ra,0x2
    2fea:	54c080e7          	jalr	1356(ra) # 5532 <open>
    2fee:	84aa                	mv	s1,a0
  if(fd < 0){
    2ff0:	38054463          	bltz	a0,3378 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    2ff4:	660d                	lui	a2,0x3
    2ff6:	00009597          	auipc	a1,0x9
    2ffa:	97a58593          	addi	a1,a1,-1670 # b970 <buf>
    2ffe:	00002097          	auipc	ra,0x2
    3002:	50c080e7          	jalr	1292(ra) # 550a <read>
    3006:	4789                	li	a5,2
    3008:	38f51663          	bne	a0,a5,3394 <subdir+0x55e>
  close(fd);
    300c:	8526                	mv	a0,s1
    300e:	00002097          	auipc	ra,0x2
    3012:	50c080e7          	jalr	1292(ra) # 551a <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3016:	4581                	li	a1,0
    3018:	00004517          	auipc	a0,0x4
    301c:	fe050513          	addi	a0,a0,-32 # 6ff8 <malloc+0x16d0>
    3020:	00002097          	auipc	ra,0x2
    3024:	512080e7          	jalr	1298(ra) # 5532 <open>
    3028:	38055463          	bgez	a0,33b0 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    302c:	20200593          	li	a1,514
    3030:	00004517          	auipc	a0,0x4
    3034:	1d850513          	addi	a0,a0,472 # 7208 <malloc+0x18e0>
    3038:	00002097          	auipc	ra,0x2
    303c:	4fa080e7          	jalr	1274(ra) # 5532 <open>
    3040:	38055663          	bgez	a0,33cc <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3044:	20200593          	li	a1,514
    3048:	00004517          	auipc	a0,0x4
    304c:	1f050513          	addi	a0,a0,496 # 7238 <malloc+0x1910>
    3050:	00002097          	auipc	ra,0x2
    3054:	4e2080e7          	jalr	1250(ra) # 5532 <open>
    3058:	38055863          	bgez	a0,33e8 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    305c:	20000593          	li	a1,512
    3060:	00004517          	auipc	a0,0x4
    3064:	ef850513          	addi	a0,a0,-264 # 6f58 <malloc+0x1630>
    3068:	00002097          	auipc	ra,0x2
    306c:	4ca080e7          	jalr	1226(ra) # 5532 <open>
    3070:	38055a63          	bgez	a0,3404 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3074:	4589                	li	a1,2
    3076:	00004517          	auipc	a0,0x4
    307a:	ee250513          	addi	a0,a0,-286 # 6f58 <malloc+0x1630>
    307e:	00002097          	auipc	ra,0x2
    3082:	4b4080e7          	jalr	1204(ra) # 5532 <open>
    3086:	38055d63          	bgez	a0,3420 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    308a:	4585                	li	a1,1
    308c:	00004517          	auipc	a0,0x4
    3090:	ecc50513          	addi	a0,a0,-308 # 6f58 <malloc+0x1630>
    3094:	00002097          	auipc	ra,0x2
    3098:	49e080e7          	jalr	1182(ra) # 5532 <open>
    309c:	3a055063          	bgez	a0,343c <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    30a0:	00004597          	auipc	a1,0x4
    30a4:	22858593          	addi	a1,a1,552 # 72c8 <malloc+0x19a0>
    30a8:	00004517          	auipc	a0,0x4
    30ac:	16050513          	addi	a0,a0,352 # 7208 <malloc+0x18e0>
    30b0:	00002097          	auipc	ra,0x2
    30b4:	4a2080e7          	jalr	1186(ra) # 5552 <link>
    30b8:	3a050063          	beqz	a0,3458 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    30bc:	00004597          	auipc	a1,0x4
    30c0:	20c58593          	addi	a1,a1,524 # 72c8 <malloc+0x19a0>
    30c4:	00004517          	auipc	a0,0x4
    30c8:	17450513          	addi	a0,a0,372 # 7238 <malloc+0x1910>
    30cc:	00002097          	auipc	ra,0x2
    30d0:	486080e7          	jalr	1158(ra) # 5552 <link>
    30d4:	3a050063          	beqz	a0,3474 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    30d8:	00004597          	auipc	a1,0x4
    30dc:	fa858593          	addi	a1,a1,-88 # 7080 <malloc+0x1758>
    30e0:	00004517          	auipc	a0,0x4
    30e4:	e9850513          	addi	a0,a0,-360 # 6f78 <malloc+0x1650>
    30e8:	00002097          	auipc	ra,0x2
    30ec:	46a080e7          	jalr	1130(ra) # 5552 <link>
    30f0:	3a050063          	beqz	a0,3490 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    30f4:	00004517          	auipc	a0,0x4
    30f8:	11450513          	addi	a0,a0,276 # 7208 <malloc+0x18e0>
    30fc:	00002097          	auipc	ra,0x2
    3100:	45e080e7          	jalr	1118(ra) # 555a <mkdir>
    3104:	3a050463          	beqz	a0,34ac <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3108:	00004517          	auipc	a0,0x4
    310c:	13050513          	addi	a0,a0,304 # 7238 <malloc+0x1910>
    3110:	00002097          	auipc	ra,0x2
    3114:	44a080e7          	jalr	1098(ra) # 555a <mkdir>
    3118:	3a050863          	beqz	a0,34c8 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    311c:	00004517          	auipc	a0,0x4
    3120:	f6450513          	addi	a0,a0,-156 # 7080 <malloc+0x1758>
    3124:	00002097          	auipc	ra,0x2
    3128:	436080e7          	jalr	1078(ra) # 555a <mkdir>
    312c:	3a050c63          	beqz	a0,34e4 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3130:	00004517          	auipc	a0,0x4
    3134:	10850513          	addi	a0,a0,264 # 7238 <malloc+0x1910>
    3138:	00002097          	auipc	ra,0x2
    313c:	40a080e7          	jalr	1034(ra) # 5542 <unlink>
    3140:	3c050063          	beqz	a0,3500 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3144:	00004517          	auipc	a0,0x4
    3148:	0c450513          	addi	a0,a0,196 # 7208 <malloc+0x18e0>
    314c:	00002097          	auipc	ra,0x2
    3150:	3f6080e7          	jalr	1014(ra) # 5542 <unlink>
    3154:	3c050463          	beqz	a0,351c <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3158:	00004517          	auipc	a0,0x4
    315c:	e2050513          	addi	a0,a0,-480 # 6f78 <malloc+0x1650>
    3160:	00002097          	auipc	ra,0x2
    3164:	402080e7          	jalr	1026(ra) # 5562 <chdir>
    3168:	3c050863          	beqz	a0,3538 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    316c:	00004517          	auipc	a0,0x4
    3170:	2ac50513          	addi	a0,a0,684 # 7418 <malloc+0x1af0>
    3174:	00002097          	auipc	ra,0x2
    3178:	3ee080e7          	jalr	1006(ra) # 5562 <chdir>
    317c:	3c050c63          	beqz	a0,3554 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3180:	00004517          	auipc	a0,0x4
    3184:	f0050513          	addi	a0,a0,-256 # 7080 <malloc+0x1758>
    3188:	00002097          	auipc	ra,0x2
    318c:	3ba080e7          	jalr	954(ra) # 5542 <unlink>
    3190:	3e051063          	bnez	a0,3570 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3194:	00004517          	auipc	a0,0x4
    3198:	de450513          	addi	a0,a0,-540 # 6f78 <malloc+0x1650>
    319c:	00002097          	auipc	ra,0x2
    31a0:	3a6080e7          	jalr	934(ra) # 5542 <unlink>
    31a4:	3e051463          	bnez	a0,358c <subdir+0x756>
  if(unlink("dd") == 0){
    31a8:	00004517          	auipc	a0,0x4
    31ac:	db050513          	addi	a0,a0,-592 # 6f58 <malloc+0x1630>
    31b0:	00002097          	auipc	ra,0x2
    31b4:	392080e7          	jalr	914(ra) # 5542 <unlink>
    31b8:	3e050863          	beqz	a0,35a8 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    31bc:	00004517          	auipc	a0,0x4
    31c0:	2cc50513          	addi	a0,a0,716 # 7488 <malloc+0x1b60>
    31c4:	00002097          	auipc	ra,0x2
    31c8:	37e080e7          	jalr	894(ra) # 5542 <unlink>
    31cc:	3e054c63          	bltz	a0,35c4 <subdir+0x78e>
  if(unlink("dd") < 0){
    31d0:	00004517          	auipc	a0,0x4
    31d4:	d8850513          	addi	a0,a0,-632 # 6f58 <malloc+0x1630>
    31d8:	00002097          	auipc	ra,0x2
    31dc:	36a080e7          	jalr	874(ra) # 5542 <unlink>
    31e0:	40054063          	bltz	a0,35e0 <subdir+0x7aa>
}
    31e4:	60e2                	ld	ra,24(sp)
    31e6:	6442                	ld	s0,16(sp)
    31e8:	64a2                	ld	s1,8(sp)
    31ea:	6902                	ld	s2,0(sp)
    31ec:	6105                	addi	sp,sp,32
    31ee:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    31f0:	85ca                	mv	a1,s2
    31f2:	00004517          	auipc	a0,0x4
    31f6:	d6e50513          	addi	a0,a0,-658 # 6f60 <malloc+0x1638>
    31fa:	00002097          	auipc	ra,0x2
    31fe:	670080e7          	jalr	1648(ra) # 586a <printf>
    exit(1);
    3202:	4505                	li	a0,1
    3204:	00002097          	auipc	ra,0x2
    3208:	2ee080e7          	jalr	750(ra) # 54f2 <exit>
    printf("%s: create dd/ff failed\n", s);
    320c:	85ca                	mv	a1,s2
    320e:	00004517          	auipc	a0,0x4
    3212:	d7250513          	addi	a0,a0,-654 # 6f80 <malloc+0x1658>
    3216:	00002097          	auipc	ra,0x2
    321a:	654080e7          	jalr	1620(ra) # 586a <printf>
    exit(1);
    321e:	4505                	li	a0,1
    3220:	00002097          	auipc	ra,0x2
    3224:	2d2080e7          	jalr	722(ra) # 54f2 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3228:	85ca                	mv	a1,s2
    322a:	00004517          	auipc	a0,0x4
    322e:	d7650513          	addi	a0,a0,-650 # 6fa0 <malloc+0x1678>
    3232:	00002097          	auipc	ra,0x2
    3236:	638080e7          	jalr	1592(ra) # 586a <printf>
    exit(1);
    323a:	4505                	li	a0,1
    323c:	00002097          	auipc	ra,0x2
    3240:	2b6080e7          	jalr	694(ra) # 54f2 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3244:	85ca                	mv	a1,s2
    3246:	00004517          	auipc	a0,0x4
    324a:	d9250513          	addi	a0,a0,-622 # 6fd8 <malloc+0x16b0>
    324e:	00002097          	auipc	ra,0x2
    3252:	61c080e7          	jalr	1564(ra) # 586a <printf>
    exit(1);
    3256:	4505                	li	a0,1
    3258:	00002097          	auipc	ra,0x2
    325c:	29a080e7          	jalr	666(ra) # 54f2 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3260:	85ca                	mv	a1,s2
    3262:	00004517          	auipc	a0,0x4
    3266:	da650513          	addi	a0,a0,-602 # 7008 <malloc+0x16e0>
    326a:	00002097          	auipc	ra,0x2
    326e:	600080e7          	jalr	1536(ra) # 586a <printf>
    exit(1);
    3272:	4505                	li	a0,1
    3274:	00002097          	auipc	ra,0x2
    3278:	27e080e7          	jalr	638(ra) # 54f2 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    327c:	85ca                	mv	a1,s2
    327e:	00004517          	auipc	a0,0x4
    3282:	dc250513          	addi	a0,a0,-574 # 7040 <malloc+0x1718>
    3286:	00002097          	auipc	ra,0x2
    328a:	5e4080e7          	jalr	1508(ra) # 586a <printf>
    exit(1);
    328e:	4505                	li	a0,1
    3290:	00002097          	auipc	ra,0x2
    3294:	262080e7          	jalr	610(ra) # 54f2 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3298:	85ca                	mv	a1,s2
    329a:	00004517          	auipc	a0,0x4
    329e:	dc650513          	addi	a0,a0,-570 # 7060 <malloc+0x1738>
    32a2:	00002097          	auipc	ra,0x2
    32a6:	5c8080e7          	jalr	1480(ra) # 586a <printf>
    exit(1);
    32aa:	4505                	li	a0,1
    32ac:	00002097          	auipc	ra,0x2
    32b0:	246080e7          	jalr	582(ra) # 54f2 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    32b4:	85ca                	mv	a1,s2
    32b6:	00004517          	auipc	a0,0x4
    32ba:	dda50513          	addi	a0,a0,-550 # 7090 <malloc+0x1768>
    32be:	00002097          	auipc	ra,0x2
    32c2:	5ac080e7          	jalr	1452(ra) # 586a <printf>
    exit(1);
    32c6:	4505                	li	a0,1
    32c8:	00002097          	auipc	ra,0x2
    32cc:	22a080e7          	jalr	554(ra) # 54f2 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    32d0:	85ca                	mv	a1,s2
    32d2:	00004517          	auipc	a0,0x4
    32d6:	de650513          	addi	a0,a0,-538 # 70b8 <malloc+0x1790>
    32da:	00002097          	auipc	ra,0x2
    32de:	590080e7          	jalr	1424(ra) # 586a <printf>
    exit(1);
    32e2:	4505                	li	a0,1
    32e4:	00002097          	auipc	ra,0x2
    32e8:	20e080e7          	jalr	526(ra) # 54f2 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    32ec:	85ca                	mv	a1,s2
    32ee:	00004517          	auipc	a0,0x4
    32f2:	dea50513          	addi	a0,a0,-534 # 70d8 <malloc+0x17b0>
    32f6:	00002097          	auipc	ra,0x2
    32fa:	574080e7          	jalr	1396(ra) # 586a <printf>
    exit(1);
    32fe:	4505                	li	a0,1
    3300:	00002097          	auipc	ra,0x2
    3304:	1f2080e7          	jalr	498(ra) # 54f2 <exit>
    printf("%s: chdir dd failed\n", s);
    3308:	85ca                	mv	a1,s2
    330a:	00004517          	auipc	a0,0x4
    330e:	df650513          	addi	a0,a0,-522 # 7100 <malloc+0x17d8>
    3312:	00002097          	auipc	ra,0x2
    3316:	558080e7          	jalr	1368(ra) # 586a <printf>
    exit(1);
    331a:	4505                	li	a0,1
    331c:	00002097          	auipc	ra,0x2
    3320:	1d6080e7          	jalr	470(ra) # 54f2 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3324:	85ca                	mv	a1,s2
    3326:	00004517          	auipc	a0,0x4
    332a:	e0250513          	addi	a0,a0,-510 # 7128 <malloc+0x1800>
    332e:	00002097          	auipc	ra,0x2
    3332:	53c080e7          	jalr	1340(ra) # 586a <printf>
    exit(1);
    3336:	4505                	li	a0,1
    3338:	00002097          	auipc	ra,0x2
    333c:	1ba080e7          	jalr	442(ra) # 54f2 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3340:	85ca                	mv	a1,s2
    3342:	00004517          	auipc	a0,0x4
    3346:	e1650513          	addi	a0,a0,-490 # 7158 <malloc+0x1830>
    334a:	00002097          	auipc	ra,0x2
    334e:	520080e7          	jalr	1312(ra) # 586a <printf>
    exit(1);
    3352:	4505                	li	a0,1
    3354:	00002097          	auipc	ra,0x2
    3358:	19e080e7          	jalr	414(ra) # 54f2 <exit>
    printf("%s: chdir ./.. failed\n", s);
    335c:	85ca                	mv	a1,s2
    335e:	00004517          	auipc	a0,0x4
    3362:	e2250513          	addi	a0,a0,-478 # 7180 <malloc+0x1858>
    3366:	00002097          	auipc	ra,0x2
    336a:	504080e7          	jalr	1284(ra) # 586a <printf>
    exit(1);
    336e:	4505                	li	a0,1
    3370:	00002097          	auipc	ra,0x2
    3374:	182080e7          	jalr	386(ra) # 54f2 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3378:	85ca                	mv	a1,s2
    337a:	00004517          	auipc	a0,0x4
    337e:	e1e50513          	addi	a0,a0,-482 # 7198 <malloc+0x1870>
    3382:	00002097          	auipc	ra,0x2
    3386:	4e8080e7          	jalr	1256(ra) # 586a <printf>
    exit(1);
    338a:	4505                	li	a0,1
    338c:	00002097          	auipc	ra,0x2
    3390:	166080e7          	jalr	358(ra) # 54f2 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3394:	85ca                	mv	a1,s2
    3396:	00004517          	auipc	a0,0x4
    339a:	e2250513          	addi	a0,a0,-478 # 71b8 <malloc+0x1890>
    339e:	00002097          	auipc	ra,0x2
    33a2:	4cc080e7          	jalr	1228(ra) # 586a <printf>
    exit(1);
    33a6:	4505                	li	a0,1
    33a8:	00002097          	auipc	ra,0x2
    33ac:	14a080e7          	jalr	330(ra) # 54f2 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    33b0:	85ca                	mv	a1,s2
    33b2:	00004517          	auipc	a0,0x4
    33b6:	e2650513          	addi	a0,a0,-474 # 71d8 <malloc+0x18b0>
    33ba:	00002097          	auipc	ra,0x2
    33be:	4b0080e7          	jalr	1200(ra) # 586a <printf>
    exit(1);
    33c2:	4505                	li	a0,1
    33c4:	00002097          	auipc	ra,0x2
    33c8:	12e080e7          	jalr	302(ra) # 54f2 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    33cc:	85ca                	mv	a1,s2
    33ce:	00004517          	auipc	a0,0x4
    33d2:	e4a50513          	addi	a0,a0,-438 # 7218 <malloc+0x18f0>
    33d6:	00002097          	auipc	ra,0x2
    33da:	494080e7          	jalr	1172(ra) # 586a <printf>
    exit(1);
    33de:	4505                	li	a0,1
    33e0:	00002097          	auipc	ra,0x2
    33e4:	112080e7          	jalr	274(ra) # 54f2 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    33e8:	85ca                	mv	a1,s2
    33ea:	00004517          	auipc	a0,0x4
    33ee:	e5e50513          	addi	a0,a0,-418 # 7248 <malloc+0x1920>
    33f2:	00002097          	auipc	ra,0x2
    33f6:	478080e7          	jalr	1144(ra) # 586a <printf>
    exit(1);
    33fa:	4505                	li	a0,1
    33fc:	00002097          	auipc	ra,0x2
    3400:	0f6080e7          	jalr	246(ra) # 54f2 <exit>
    printf("%s: create dd succeeded!\n", s);
    3404:	85ca                	mv	a1,s2
    3406:	00004517          	auipc	a0,0x4
    340a:	e6250513          	addi	a0,a0,-414 # 7268 <malloc+0x1940>
    340e:	00002097          	auipc	ra,0x2
    3412:	45c080e7          	jalr	1116(ra) # 586a <printf>
    exit(1);
    3416:	4505                	li	a0,1
    3418:	00002097          	auipc	ra,0x2
    341c:	0da080e7          	jalr	218(ra) # 54f2 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3420:	85ca                	mv	a1,s2
    3422:	00004517          	auipc	a0,0x4
    3426:	e6650513          	addi	a0,a0,-410 # 7288 <malloc+0x1960>
    342a:	00002097          	auipc	ra,0x2
    342e:	440080e7          	jalr	1088(ra) # 586a <printf>
    exit(1);
    3432:	4505                	li	a0,1
    3434:	00002097          	auipc	ra,0x2
    3438:	0be080e7          	jalr	190(ra) # 54f2 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    343c:	85ca                	mv	a1,s2
    343e:	00004517          	auipc	a0,0x4
    3442:	e6a50513          	addi	a0,a0,-406 # 72a8 <malloc+0x1980>
    3446:	00002097          	auipc	ra,0x2
    344a:	424080e7          	jalr	1060(ra) # 586a <printf>
    exit(1);
    344e:	4505                	li	a0,1
    3450:	00002097          	auipc	ra,0x2
    3454:	0a2080e7          	jalr	162(ra) # 54f2 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3458:	85ca                	mv	a1,s2
    345a:	00004517          	auipc	a0,0x4
    345e:	e7e50513          	addi	a0,a0,-386 # 72d8 <malloc+0x19b0>
    3462:	00002097          	auipc	ra,0x2
    3466:	408080e7          	jalr	1032(ra) # 586a <printf>
    exit(1);
    346a:	4505                	li	a0,1
    346c:	00002097          	auipc	ra,0x2
    3470:	086080e7          	jalr	134(ra) # 54f2 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3474:	85ca                	mv	a1,s2
    3476:	00004517          	auipc	a0,0x4
    347a:	e8a50513          	addi	a0,a0,-374 # 7300 <malloc+0x19d8>
    347e:	00002097          	auipc	ra,0x2
    3482:	3ec080e7          	jalr	1004(ra) # 586a <printf>
    exit(1);
    3486:	4505                	li	a0,1
    3488:	00002097          	auipc	ra,0x2
    348c:	06a080e7          	jalr	106(ra) # 54f2 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3490:	85ca                	mv	a1,s2
    3492:	00004517          	auipc	a0,0x4
    3496:	e9650513          	addi	a0,a0,-362 # 7328 <malloc+0x1a00>
    349a:	00002097          	auipc	ra,0x2
    349e:	3d0080e7          	jalr	976(ra) # 586a <printf>
    exit(1);
    34a2:	4505                	li	a0,1
    34a4:	00002097          	auipc	ra,0x2
    34a8:	04e080e7          	jalr	78(ra) # 54f2 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    34ac:	85ca                	mv	a1,s2
    34ae:	00004517          	auipc	a0,0x4
    34b2:	ea250513          	addi	a0,a0,-350 # 7350 <malloc+0x1a28>
    34b6:	00002097          	auipc	ra,0x2
    34ba:	3b4080e7          	jalr	948(ra) # 586a <printf>
    exit(1);
    34be:	4505                	li	a0,1
    34c0:	00002097          	auipc	ra,0x2
    34c4:	032080e7          	jalr	50(ra) # 54f2 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    34c8:	85ca                	mv	a1,s2
    34ca:	00004517          	auipc	a0,0x4
    34ce:	ea650513          	addi	a0,a0,-346 # 7370 <malloc+0x1a48>
    34d2:	00002097          	auipc	ra,0x2
    34d6:	398080e7          	jalr	920(ra) # 586a <printf>
    exit(1);
    34da:	4505                	li	a0,1
    34dc:	00002097          	auipc	ra,0x2
    34e0:	016080e7          	jalr	22(ra) # 54f2 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    34e4:	85ca                	mv	a1,s2
    34e6:	00004517          	auipc	a0,0x4
    34ea:	eaa50513          	addi	a0,a0,-342 # 7390 <malloc+0x1a68>
    34ee:	00002097          	auipc	ra,0x2
    34f2:	37c080e7          	jalr	892(ra) # 586a <printf>
    exit(1);
    34f6:	4505                	li	a0,1
    34f8:	00002097          	auipc	ra,0x2
    34fc:	ffa080e7          	jalr	-6(ra) # 54f2 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3500:	85ca                	mv	a1,s2
    3502:	00004517          	auipc	a0,0x4
    3506:	eb650513          	addi	a0,a0,-330 # 73b8 <malloc+0x1a90>
    350a:	00002097          	auipc	ra,0x2
    350e:	360080e7          	jalr	864(ra) # 586a <printf>
    exit(1);
    3512:	4505                	li	a0,1
    3514:	00002097          	auipc	ra,0x2
    3518:	fde080e7          	jalr	-34(ra) # 54f2 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    351c:	85ca                	mv	a1,s2
    351e:	00004517          	auipc	a0,0x4
    3522:	eba50513          	addi	a0,a0,-326 # 73d8 <malloc+0x1ab0>
    3526:	00002097          	auipc	ra,0x2
    352a:	344080e7          	jalr	836(ra) # 586a <printf>
    exit(1);
    352e:	4505                	li	a0,1
    3530:	00002097          	auipc	ra,0x2
    3534:	fc2080e7          	jalr	-62(ra) # 54f2 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3538:	85ca                	mv	a1,s2
    353a:	00004517          	auipc	a0,0x4
    353e:	ebe50513          	addi	a0,a0,-322 # 73f8 <malloc+0x1ad0>
    3542:	00002097          	auipc	ra,0x2
    3546:	328080e7          	jalr	808(ra) # 586a <printf>
    exit(1);
    354a:	4505                	li	a0,1
    354c:	00002097          	auipc	ra,0x2
    3550:	fa6080e7          	jalr	-90(ra) # 54f2 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3554:	85ca                	mv	a1,s2
    3556:	00004517          	auipc	a0,0x4
    355a:	eca50513          	addi	a0,a0,-310 # 7420 <malloc+0x1af8>
    355e:	00002097          	auipc	ra,0x2
    3562:	30c080e7          	jalr	780(ra) # 586a <printf>
    exit(1);
    3566:	4505                	li	a0,1
    3568:	00002097          	auipc	ra,0x2
    356c:	f8a080e7          	jalr	-118(ra) # 54f2 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3570:	85ca                	mv	a1,s2
    3572:	00004517          	auipc	a0,0x4
    3576:	b4650513          	addi	a0,a0,-1210 # 70b8 <malloc+0x1790>
    357a:	00002097          	auipc	ra,0x2
    357e:	2f0080e7          	jalr	752(ra) # 586a <printf>
    exit(1);
    3582:	4505                	li	a0,1
    3584:	00002097          	auipc	ra,0x2
    3588:	f6e080e7          	jalr	-146(ra) # 54f2 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    358c:	85ca                	mv	a1,s2
    358e:	00004517          	auipc	a0,0x4
    3592:	eb250513          	addi	a0,a0,-334 # 7440 <malloc+0x1b18>
    3596:	00002097          	auipc	ra,0x2
    359a:	2d4080e7          	jalr	724(ra) # 586a <printf>
    exit(1);
    359e:	4505                	li	a0,1
    35a0:	00002097          	auipc	ra,0x2
    35a4:	f52080e7          	jalr	-174(ra) # 54f2 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    35a8:	85ca                	mv	a1,s2
    35aa:	00004517          	auipc	a0,0x4
    35ae:	eb650513          	addi	a0,a0,-330 # 7460 <malloc+0x1b38>
    35b2:	00002097          	auipc	ra,0x2
    35b6:	2b8080e7          	jalr	696(ra) # 586a <printf>
    exit(1);
    35ba:	4505                	li	a0,1
    35bc:	00002097          	auipc	ra,0x2
    35c0:	f36080e7          	jalr	-202(ra) # 54f2 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    35c4:	85ca                	mv	a1,s2
    35c6:	00004517          	auipc	a0,0x4
    35ca:	eca50513          	addi	a0,a0,-310 # 7490 <malloc+0x1b68>
    35ce:	00002097          	auipc	ra,0x2
    35d2:	29c080e7          	jalr	668(ra) # 586a <printf>
    exit(1);
    35d6:	4505                	li	a0,1
    35d8:	00002097          	auipc	ra,0x2
    35dc:	f1a080e7          	jalr	-230(ra) # 54f2 <exit>
    printf("%s: unlink dd failed\n", s);
    35e0:	85ca                	mv	a1,s2
    35e2:	00004517          	auipc	a0,0x4
    35e6:	ece50513          	addi	a0,a0,-306 # 74b0 <malloc+0x1b88>
    35ea:	00002097          	auipc	ra,0x2
    35ee:	280080e7          	jalr	640(ra) # 586a <printf>
    exit(1);
    35f2:	4505                	li	a0,1
    35f4:	00002097          	auipc	ra,0x2
    35f8:	efe080e7          	jalr	-258(ra) # 54f2 <exit>

00000000000035fc <rmdot>:
{
    35fc:	1101                	addi	sp,sp,-32
    35fe:	ec06                	sd	ra,24(sp)
    3600:	e822                	sd	s0,16(sp)
    3602:	e426                	sd	s1,8(sp)
    3604:	1000                	addi	s0,sp,32
    3606:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3608:	00004517          	auipc	a0,0x4
    360c:	ec050513          	addi	a0,a0,-320 # 74c8 <malloc+0x1ba0>
    3610:	00002097          	auipc	ra,0x2
    3614:	f4a080e7          	jalr	-182(ra) # 555a <mkdir>
    3618:	e549                	bnez	a0,36a2 <rmdot+0xa6>
  if(chdir("dots") != 0){
    361a:	00004517          	auipc	a0,0x4
    361e:	eae50513          	addi	a0,a0,-338 # 74c8 <malloc+0x1ba0>
    3622:	00002097          	auipc	ra,0x2
    3626:	f40080e7          	jalr	-192(ra) # 5562 <chdir>
    362a:	e951                	bnez	a0,36be <rmdot+0xc2>
  if(unlink(".") == 0){
    362c:	00003517          	auipc	a0,0x3
    3630:	dbc50513          	addi	a0,a0,-580 # 63e8 <malloc+0xac0>
    3634:	00002097          	auipc	ra,0x2
    3638:	f0e080e7          	jalr	-242(ra) # 5542 <unlink>
    363c:	cd59                	beqz	a0,36da <rmdot+0xde>
  if(unlink("..") == 0){
    363e:	00004517          	auipc	a0,0x4
    3642:	eda50513          	addi	a0,a0,-294 # 7518 <malloc+0x1bf0>
    3646:	00002097          	auipc	ra,0x2
    364a:	efc080e7          	jalr	-260(ra) # 5542 <unlink>
    364e:	c545                	beqz	a0,36f6 <rmdot+0xfa>
  if(chdir("/") != 0){
    3650:	00004517          	auipc	a0,0x4
    3654:	8d050513          	addi	a0,a0,-1840 # 6f20 <malloc+0x15f8>
    3658:	00002097          	auipc	ra,0x2
    365c:	f0a080e7          	jalr	-246(ra) # 5562 <chdir>
    3660:	e94d                	bnez	a0,3712 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3662:	00004517          	auipc	a0,0x4
    3666:	ed650513          	addi	a0,a0,-298 # 7538 <malloc+0x1c10>
    366a:	00002097          	auipc	ra,0x2
    366e:	ed8080e7          	jalr	-296(ra) # 5542 <unlink>
    3672:	cd55                	beqz	a0,372e <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3674:	00004517          	auipc	a0,0x4
    3678:	eec50513          	addi	a0,a0,-276 # 7560 <malloc+0x1c38>
    367c:	00002097          	auipc	ra,0x2
    3680:	ec6080e7          	jalr	-314(ra) # 5542 <unlink>
    3684:	c179                	beqz	a0,374a <rmdot+0x14e>
  if(unlink("dots") != 0){
    3686:	00004517          	auipc	a0,0x4
    368a:	e4250513          	addi	a0,a0,-446 # 74c8 <malloc+0x1ba0>
    368e:	00002097          	auipc	ra,0x2
    3692:	eb4080e7          	jalr	-332(ra) # 5542 <unlink>
    3696:	e961                	bnez	a0,3766 <rmdot+0x16a>
}
    3698:	60e2                	ld	ra,24(sp)
    369a:	6442                	ld	s0,16(sp)
    369c:	64a2                	ld	s1,8(sp)
    369e:	6105                	addi	sp,sp,32
    36a0:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    36a2:	85a6                	mv	a1,s1
    36a4:	00004517          	auipc	a0,0x4
    36a8:	e2c50513          	addi	a0,a0,-468 # 74d0 <malloc+0x1ba8>
    36ac:	00002097          	auipc	ra,0x2
    36b0:	1be080e7          	jalr	446(ra) # 586a <printf>
    exit(1);
    36b4:	4505                	li	a0,1
    36b6:	00002097          	auipc	ra,0x2
    36ba:	e3c080e7          	jalr	-452(ra) # 54f2 <exit>
    printf("%s: chdir dots failed\n", s);
    36be:	85a6                	mv	a1,s1
    36c0:	00004517          	auipc	a0,0x4
    36c4:	e2850513          	addi	a0,a0,-472 # 74e8 <malloc+0x1bc0>
    36c8:	00002097          	auipc	ra,0x2
    36cc:	1a2080e7          	jalr	418(ra) # 586a <printf>
    exit(1);
    36d0:	4505                	li	a0,1
    36d2:	00002097          	auipc	ra,0x2
    36d6:	e20080e7          	jalr	-480(ra) # 54f2 <exit>
    printf("%s: rm . worked!\n", s);
    36da:	85a6                	mv	a1,s1
    36dc:	00004517          	auipc	a0,0x4
    36e0:	e2450513          	addi	a0,a0,-476 # 7500 <malloc+0x1bd8>
    36e4:	00002097          	auipc	ra,0x2
    36e8:	186080e7          	jalr	390(ra) # 586a <printf>
    exit(1);
    36ec:	4505                	li	a0,1
    36ee:	00002097          	auipc	ra,0x2
    36f2:	e04080e7          	jalr	-508(ra) # 54f2 <exit>
    printf("%s: rm .. worked!\n", s);
    36f6:	85a6                	mv	a1,s1
    36f8:	00004517          	auipc	a0,0x4
    36fc:	e2850513          	addi	a0,a0,-472 # 7520 <malloc+0x1bf8>
    3700:	00002097          	auipc	ra,0x2
    3704:	16a080e7          	jalr	362(ra) # 586a <printf>
    exit(1);
    3708:	4505                	li	a0,1
    370a:	00002097          	auipc	ra,0x2
    370e:	de8080e7          	jalr	-536(ra) # 54f2 <exit>
    printf("%s: chdir / failed\n", s);
    3712:	85a6                	mv	a1,s1
    3714:	00004517          	auipc	a0,0x4
    3718:	81450513          	addi	a0,a0,-2028 # 6f28 <malloc+0x1600>
    371c:	00002097          	auipc	ra,0x2
    3720:	14e080e7          	jalr	334(ra) # 586a <printf>
    exit(1);
    3724:	4505                	li	a0,1
    3726:	00002097          	auipc	ra,0x2
    372a:	dcc080e7          	jalr	-564(ra) # 54f2 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    372e:	85a6                	mv	a1,s1
    3730:	00004517          	auipc	a0,0x4
    3734:	e1050513          	addi	a0,a0,-496 # 7540 <malloc+0x1c18>
    3738:	00002097          	auipc	ra,0x2
    373c:	132080e7          	jalr	306(ra) # 586a <printf>
    exit(1);
    3740:	4505                	li	a0,1
    3742:	00002097          	auipc	ra,0x2
    3746:	db0080e7          	jalr	-592(ra) # 54f2 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    374a:	85a6                	mv	a1,s1
    374c:	00004517          	auipc	a0,0x4
    3750:	e1c50513          	addi	a0,a0,-484 # 7568 <malloc+0x1c40>
    3754:	00002097          	auipc	ra,0x2
    3758:	116080e7          	jalr	278(ra) # 586a <printf>
    exit(1);
    375c:	4505                	li	a0,1
    375e:	00002097          	auipc	ra,0x2
    3762:	d94080e7          	jalr	-620(ra) # 54f2 <exit>
    printf("%s: unlink dots failed!\n", s);
    3766:	85a6                	mv	a1,s1
    3768:	00004517          	auipc	a0,0x4
    376c:	e2050513          	addi	a0,a0,-480 # 7588 <malloc+0x1c60>
    3770:	00002097          	auipc	ra,0x2
    3774:	0fa080e7          	jalr	250(ra) # 586a <printf>
    exit(1);
    3778:	4505                	li	a0,1
    377a:	00002097          	auipc	ra,0x2
    377e:	d78080e7          	jalr	-648(ra) # 54f2 <exit>

0000000000003782 <dirfile>:
{
    3782:	1101                	addi	sp,sp,-32
    3784:	ec06                	sd	ra,24(sp)
    3786:	e822                	sd	s0,16(sp)
    3788:	e426                	sd	s1,8(sp)
    378a:	e04a                	sd	s2,0(sp)
    378c:	1000                	addi	s0,sp,32
    378e:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3790:	20000593          	li	a1,512
    3794:	00002517          	auipc	a0,0x2
    3798:	55c50513          	addi	a0,a0,1372 # 5cf0 <malloc+0x3c8>
    379c:	00002097          	auipc	ra,0x2
    37a0:	d96080e7          	jalr	-618(ra) # 5532 <open>
  if(fd < 0){
    37a4:	0e054d63          	bltz	a0,389e <dirfile+0x11c>
  close(fd);
    37a8:	00002097          	auipc	ra,0x2
    37ac:	d72080e7          	jalr	-654(ra) # 551a <close>
  if(chdir("dirfile") == 0){
    37b0:	00002517          	auipc	a0,0x2
    37b4:	54050513          	addi	a0,a0,1344 # 5cf0 <malloc+0x3c8>
    37b8:	00002097          	auipc	ra,0x2
    37bc:	daa080e7          	jalr	-598(ra) # 5562 <chdir>
    37c0:	cd6d                	beqz	a0,38ba <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    37c2:	4581                	li	a1,0
    37c4:	00004517          	auipc	a0,0x4
    37c8:	e2450513          	addi	a0,a0,-476 # 75e8 <malloc+0x1cc0>
    37cc:	00002097          	auipc	ra,0x2
    37d0:	d66080e7          	jalr	-666(ra) # 5532 <open>
  if(fd >= 0){
    37d4:	10055163          	bgez	a0,38d6 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    37d8:	20000593          	li	a1,512
    37dc:	00004517          	auipc	a0,0x4
    37e0:	e0c50513          	addi	a0,a0,-500 # 75e8 <malloc+0x1cc0>
    37e4:	00002097          	auipc	ra,0x2
    37e8:	d4e080e7          	jalr	-690(ra) # 5532 <open>
  if(fd >= 0){
    37ec:	10055363          	bgez	a0,38f2 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    37f0:	00004517          	auipc	a0,0x4
    37f4:	df850513          	addi	a0,a0,-520 # 75e8 <malloc+0x1cc0>
    37f8:	00002097          	auipc	ra,0x2
    37fc:	d62080e7          	jalr	-670(ra) # 555a <mkdir>
    3800:	10050763          	beqz	a0,390e <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3804:	00004517          	auipc	a0,0x4
    3808:	de450513          	addi	a0,a0,-540 # 75e8 <malloc+0x1cc0>
    380c:	00002097          	auipc	ra,0x2
    3810:	d36080e7          	jalr	-714(ra) # 5542 <unlink>
    3814:	10050b63          	beqz	a0,392a <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3818:	00004597          	auipc	a1,0x4
    381c:	dd058593          	addi	a1,a1,-560 # 75e8 <malloc+0x1cc0>
    3820:	00002517          	auipc	a0,0x2
    3824:	6c850513          	addi	a0,a0,1736 # 5ee8 <malloc+0x5c0>
    3828:	00002097          	auipc	ra,0x2
    382c:	d2a080e7          	jalr	-726(ra) # 5552 <link>
    3830:	10050b63          	beqz	a0,3946 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3834:	00002517          	auipc	a0,0x2
    3838:	4bc50513          	addi	a0,a0,1212 # 5cf0 <malloc+0x3c8>
    383c:	00002097          	auipc	ra,0x2
    3840:	d06080e7          	jalr	-762(ra) # 5542 <unlink>
    3844:	10051f63          	bnez	a0,3962 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3848:	4589                	li	a1,2
    384a:	00003517          	auipc	a0,0x3
    384e:	b9e50513          	addi	a0,a0,-1122 # 63e8 <malloc+0xac0>
    3852:	00002097          	auipc	ra,0x2
    3856:	ce0080e7          	jalr	-800(ra) # 5532 <open>
  if(fd >= 0){
    385a:	12055263          	bgez	a0,397e <dirfile+0x1fc>
  fd = open(".", 0);
    385e:	4581                	li	a1,0
    3860:	00003517          	auipc	a0,0x3
    3864:	b8850513          	addi	a0,a0,-1144 # 63e8 <malloc+0xac0>
    3868:	00002097          	auipc	ra,0x2
    386c:	cca080e7          	jalr	-822(ra) # 5532 <open>
    3870:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3872:	4605                	li	a2,1
    3874:	00002597          	auipc	a1,0x2
    3878:	54c58593          	addi	a1,a1,1356 # 5dc0 <malloc+0x498>
    387c:	00002097          	auipc	ra,0x2
    3880:	c96080e7          	jalr	-874(ra) # 5512 <write>
    3884:	10a04b63          	bgtz	a0,399a <dirfile+0x218>
  close(fd);
    3888:	8526                	mv	a0,s1
    388a:	00002097          	auipc	ra,0x2
    388e:	c90080e7          	jalr	-880(ra) # 551a <close>
}
    3892:	60e2                	ld	ra,24(sp)
    3894:	6442                	ld	s0,16(sp)
    3896:	64a2                	ld	s1,8(sp)
    3898:	6902                	ld	s2,0(sp)
    389a:	6105                	addi	sp,sp,32
    389c:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    389e:	85ca                	mv	a1,s2
    38a0:	00004517          	auipc	a0,0x4
    38a4:	d0850513          	addi	a0,a0,-760 # 75a8 <malloc+0x1c80>
    38a8:	00002097          	auipc	ra,0x2
    38ac:	fc2080e7          	jalr	-62(ra) # 586a <printf>
    exit(1);
    38b0:	4505                	li	a0,1
    38b2:	00002097          	auipc	ra,0x2
    38b6:	c40080e7          	jalr	-960(ra) # 54f2 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    38ba:	85ca                	mv	a1,s2
    38bc:	00004517          	auipc	a0,0x4
    38c0:	d0c50513          	addi	a0,a0,-756 # 75c8 <malloc+0x1ca0>
    38c4:	00002097          	auipc	ra,0x2
    38c8:	fa6080e7          	jalr	-90(ra) # 586a <printf>
    exit(1);
    38cc:	4505                	li	a0,1
    38ce:	00002097          	auipc	ra,0x2
    38d2:	c24080e7          	jalr	-988(ra) # 54f2 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    38d6:	85ca                	mv	a1,s2
    38d8:	00004517          	auipc	a0,0x4
    38dc:	d2050513          	addi	a0,a0,-736 # 75f8 <malloc+0x1cd0>
    38e0:	00002097          	auipc	ra,0x2
    38e4:	f8a080e7          	jalr	-118(ra) # 586a <printf>
    exit(1);
    38e8:	4505                	li	a0,1
    38ea:	00002097          	auipc	ra,0x2
    38ee:	c08080e7          	jalr	-1016(ra) # 54f2 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    38f2:	85ca                	mv	a1,s2
    38f4:	00004517          	auipc	a0,0x4
    38f8:	d0450513          	addi	a0,a0,-764 # 75f8 <malloc+0x1cd0>
    38fc:	00002097          	auipc	ra,0x2
    3900:	f6e080e7          	jalr	-146(ra) # 586a <printf>
    exit(1);
    3904:	4505                	li	a0,1
    3906:	00002097          	auipc	ra,0x2
    390a:	bec080e7          	jalr	-1044(ra) # 54f2 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    390e:	85ca                	mv	a1,s2
    3910:	00004517          	auipc	a0,0x4
    3914:	d1050513          	addi	a0,a0,-752 # 7620 <malloc+0x1cf8>
    3918:	00002097          	auipc	ra,0x2
    391c:	f52080e7          	jalr	-174(ra) # 586a <printf>
    exit(1);
    3920:	4505                	li	a0,1
    3922:	00002097          	auipc	ra,0x2
    3926:	bd0080e7          	jalr	-1072(ra) # 54f2 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    392a:	85ca                	mv	a1,s2
    392c:	00004517          	auipc	a0,0x4
    3930:	d1c50513          	addi	a0,a0,-740 # 7648 <malloc+0x1d20>
    3934:	00002097          	auipc	ra,0x2
    3938:	f36080e7          	jalr	-202(ra) # 586a <printf>
    exit(1);
    393c:	4505                	li	a0,1
    393e:	00002097          	auipc	ra,0x2
    3942:	bb4080e7          	jalr	-1100(ra) # 54f2 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3946:	85ca                	mv	a1,s2
    3948:	00004517          	auipc	a0,0x4
    394c:	d2850513          	addi	a0,a0,-728 # 7670 <malloc+0x1d48>
    3950:	00002097          	auipc	ra,0x2
    3954:	f1a080e7          	jalr	-230(ra) # 586a <printf>
    exit(1);
    3958:	4505                	li	a0,1
    395a:	00002097          	auipc	ra,0x2
    395e:	b98080e7          	jalr	-1128(ra) # 54f2 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3962:	85ca                	mv	a1,s2
    3964:	00004517          	auipc	a0,0x4
    3968:	d3450513          	addi	a0,a0,-716 # 7698 <malloc+0x1d70>
    396c:	00002097          	auipc	ra,0x2
    3970:	efe080e7          	jalr	-258(ra) # 586a <printf>
    exit(1);
    3974:	4505                	li	a0,1
    3976:	00002097          	auipc	ra,0x2
    397a:	b7c080e7          	jalr	-1156(ra) # 54f2 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    397e:	85ca                	mv	a1,s2
    3980:	00004517          	auipc	a0,0x4
    3984:	d3850513          	addi	a0,a0,-712 # 76b8 <malloc+0x1d90>
    3988:	00002097          	auipc	ra,0x2
    398c:	ee2080e7          	jalr	-286(ra) # 586a <printf>
    exit(1);
    3990:	4505                	li	a0,1
    3992:	00002097          	auipc	ra,0x2
    3996:	b60080e7          	jalr	-1184(ra) # 54f2 <exit>
    printf("%s: write . succeeded!\n", s);
    399a:	85ca                	mv	a1,s2
    399c:	00004517          	auipc	a0,0x4
    39a0:	d4450513          	addi	a0,a0,-700 # 76e0 <malloc+0x1db8>
    39a4:	00002097          	auipc	ra,0x2
    39a8:	ec6080e7          	jalr	-314(ra) # 586a <printf>
    exit(1);
    39ac:	4505                	li	a0,1
    39ae:	00002097          	auipc	ra,0x2
    39b2:	b44080e7          	jalr	-1212(ra) # 54f2 <exit>

00000000000039b6 <iref>:
{
    39b6:	7139                	addi	sp,sp,-64
    39b8:	fc06                	sd	ra,56(sp)
    39ba:	f822                	sd	s0,48(sp)
    39bc:	f426                	sd	s1,40(sp)
    39be:	f04a                	sd	s2,32(sp)
    39c0:	ec4e                	sd	s3,24(sp)
    39c2:	e852                	sd	s4,16(sp)
    39c4:	e456                	sd	s5,8(sp)
    39c6:	e05a                	sd	s6,0(sp)
    39c8:	0080                	addi	s0,sp,64
    39ca:	8b2a                	mv	s6,a0
    39cc:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    39d0:	00004a17          	auipc	s4,0x4
    39d4:	d28a0a13          	addi	s4,s4,-728 # 76f8 <malloc+0x1dd0>
    mkdir("");
    39d8:	00004497          	auipc	s1,0x4
    39dc:	82848493          	addi	s1,s1,-2008 # 7200 <malloc+0x18d8>
    link("README", "");
    39e0:	00002a97          	auipc	s5,0x2
    39e4:	508a8a93          	addi	s5,s5,1288 # 5ee8 <malloc+0x5c0>
    fd = open("xx", O_CREATE);
    39e8:	00004997          	auipc	s3,0x4
    39ec:	c0898993          	addi	s3,s3,-1016 # 75f0 <malloc+0x1cc8>
    39f0:	a891                	j	3a44 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    39f2:	85da                	mv	a1,s6
    39f4:	00004517          	auipc	a0,0x4
    39f8:	d0c50513          	addi	a0,a0,-756 # 7700 <malloc+0x1dd8>
    39fc:	00002097          	auipc	ra,0x2
    3a00:	e6e080e7          	jalr	-402(ra) # 586a <printf>
      exit(1);
    3a04:	4505                	li	a0,1
    3a06:	00002097          	auipc	ra,0x2
    3a0a:	aec080e7          	jalr	-1300(ra) # 54f2 <exit>
      printf("%s: chdir irefd failed\n", s);
    3a0e:	85da                	mv	a1,s6
    3a10:	00004517          	auipc	a0,0x4
    3a14:	d0850513          	addi	a0,a0,-760 # 7718 <malloc+0x1df0>
    3a18:	00002097          	auipc	ra,0x2
    3a1c:	e52080e7          	jalr	-430(ra) # 586a <printf>
      exit(1);
    3a20:	4505                	li	a0,1
    3a22:	00002097          	auipc	ra,0x2
    3a26:	ad0080e7          	jalr	-1328(ra) # 54f2 <exit>
      close(fd);
    3a2a:	00002097          	auipc	ra,0x2
    3a2e:	af0080e7          	jalr	-1296(ra) # 551a <close>
    3a32:	a889                	j	3a84 <iref+0xce>
    unlink("xx");
    3a34:	854e                	mv	a0,s3
    3a36:	00002097          	auipc	ra,0x2
    3a3a:	b0c080e7          	jalr	-1268(ra) # 5542 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3a3e:	397d                	addiw	s2,s2,-1
    3a40:	06090063          	beqz	s2,3aa0 <iref+0xea>
    if(mkdir("irefd") != 0){
    3a44:	8552                	mv	a0,s4
    3a46:	00002097          	auipc	ra,0x2
    3a4a:	b14080e7          	jalr	-1260(ra) # 555a <mkdir>
    3a4e:	f155                	bnez	a0,39f2 <iref+0x3c>
    if(chdir("irefd") != 0){
    3a50:	8552                	mv	a0,s4
    3a52:	00002097          	auipc	ra,0x2
    3a56:	b10080e7          	jalr	-1264(ra) # 5562 <chdir>
    3a5a:	f955                	bnez	a0,3a0e <iref+0x58>
    mkdir("");
    3a5c:	8526                	mv	a0,s1
    3a5e:	00002097          	auipc	ra,0x2
    3a62:	afc080e7          	jalr	-1284(ra) # 555a <mkdir>
    link("README", "");
    3a66:	85a6                	mv	a1,s1
    3a68:	8556                	mv	a0,s5
    3a6a:	00002097          	auipc	ra,0x2
    3a6e:	ae8080e7          	jalr	-1304(ra) # 5552 <link>
    fd = open("", O_CREATE);
    3a72:	20000593          	li	a1,512
    3a76:	8526                	mv	a0,s1
    3a78:	00002097          	auipc	ra,0x2
    3a7c:	aba080e7          	jalr	-1350(ra) # 5532 <open>
    if(fd >= 0)
    3a80:	fa0555e3          	bgez	a0,3a2a <iref+0x74>
    fd = open("xx", O_CREATE);
    3a84:	20000593          	li	a1,512
    3a88:	854e                	mv	a0,s3
    3a8a:	00002097          	auipc	ra,0x2
    3a8e:	aa8080e7          	jalr	-1368(ra) # 5532 <open>
    if(fd >= 0)
    3a92:	fa0541e3          	bltz	a0,3a34 <iref+0x7e>
      close(fd);
    3a96:	00002097          	auipc	ra,0x2
    3a9a:	a84080e7          	jalr	-1404(ra) # 551a <close>
    3a9e:	bf59                	j	3a34 <iref+0x7e>
    3aa0:	03300493          	li	s1,51
    chdir("..");
    3aa4:	00004997          	auipc	s3,0x4
    3aa8:	a7498993          	addi	s3,s3,-1420 # 7518 <malloc+0x1bf0>
    unlink("irefd");
    3aac:	00004917          	auipc	s2,0x4
    3ab0:	c4c90913          	addi	s2,s2,-948 # 76f8 <malloc+0x1dd0>
    chdir("..");
    3ab4:	854e                	mv	a0,s3
    3ab6:	00002097          	auipc	ra,0x2
    3aba:	aac080e7          	jalr	-1364(ra) # 5562 <chdir>
    unlink("irefd");
    3abe:	854a                	mv	a0,s2
    3ac0:	00002097          	auipc	ra,0x2
    3ac4:	a82080e7          	jalr	-1406(ra) # 5542 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3ac8:	34fd                	addiw	s1,s1,-1
    3aca:	f4ed                	bnez	s1,3ab4 <iref+0xfe>
  chdir("/");
    3acc:	00003517          	auipc	a0,0x3
    3ad0:	45450513          	addi	a0,a0,1108 # 6f20 <malloc+0x15f8>
    3ad4:	00002097          	auipc	ra,0x2
    3ad8:	a8e080e7          	jalr	-1394(ra) # 5562 <chdir>
}
    3adc:	70e2                	ld	ra,56(sp)
    3ade:	7442                	ld	s0,48(sp)
    3ae0:	74a2                	ld	s1,40(sp)
    3ae2:	7902                	ld	s2,32(sp)
    3ae4:	69e2                	ld	s3,24(sp)
    3ae6:	6a42                	ld	s4,16(sp)
    3ae8:	6aa2                	ld	s5,8(sp)
    3aea:	6b02                	ld	s6,0(sp)
    3aec:	6121                	addi	sp,sp,64
    3aee:	8082                	ret

0000000000003af0 <openiputtest>:
{
    3af0:	7179                	addi	sp,sp,-48
    3af2:	f406                	sd	ra,40(sp)
    3af4:	f022                	sd	s0,32(sp)
    3af6:	ec26                	sd	s1,24(sp)
    3af8:	1800                	addi	s0,sp,48
    3afa:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3afc:	00004517          	auipc	a0,0x4
    3b00:	c3450513          	addi	a0,a0,-972 # 7730 <malloc+0x1e08>
    3b04:	00002097          	auipc	ra,0x2
    3b08:	a56080e7          	jalr	-1450(ra) # 555a <mkdir>
    3b0c:	04054263          	bltz	a0,3b50 <openiputtest+0x60>
  pid = fork();
    3b10:	00002097          	auipc	ra,0x2
    3b14:	9da080e7          	jalr	-1574(ra) # 54ea <fork>
  if(pid < 0){
    3b18:	04054a63          	bltz	a0,3b6c <openiputtest+0x7c>
  if(pid == 0){
    3b1c:	e93d                	bnez	a0,3b92 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3b1e:	4589                	li	a1,2
    3b20:	00004517          	auipc	a0,0x4
    3b24:	c1050513          	addi	a0,a0,-1008 # 7730 <malloc+0x1e08>
    3b28:	00002097          	auipc	ra,0x2
    3b2c:	a0a080e7          	jalr	-1526(ra) # 5532 <open>
    if(fd >= 0){
    3b30:	04054c63          	bltz	a0,3b88 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3b34:	85a6                	mv	a1,s1
    3b36:	00004517          	auipc	a0,0x4
    3b3a:	c1a50513          	addi	a0,a0,-998 # 7750 <malloc+0x1e28>
    3b3e:	00002097          	auipc	ra,0x2
    3b42:	d2c080e7          	jalr	-724(ra) # 586a <printf>
      exit(1);
    3b46:	4505                	li	a0,1
    3b48:	00002097          	auipc	ra,0x2
    3b4c:	9aa080e7          	jalr	-1622(ra) # 54f2 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3b50:	85a6                	mv	a1,s1
    3b52:	00004517          	auipc	a0,0x4
    3b56:	be650513          	addi	a0,a0,-1050 # 7738 <malloc+0x1e10>
    3b5a:	00002097          	auipc	ra,0x2
    3b5e:	d10080e7          	jalr	-752(ra) # 586a <printf>
    exit(1);
    3b62:	4505                	li	a0,1
    3b64:	00002097          	auipc	ra,0x2
    3b68:	98e080e7          	jalr	-1650(ra) # 54f2 <exit>
    printf("%s: fork failed\n", s);
    3b6c:	85a6                	mv	a1,s1
    3b6e:	00003517          	auipc	a0,0x3
    3b72:	a1a50513          	addi	a0,a0,-1510 # 6588 <malloc+0xc60>
    3b76:	00002097          	auipc	ra,0x2
    3b7a:	cf4080e7          	jalr	-780(ra) # 586a <printf>
    exit(1);
    3b7e:	4505                	li	a0,1
    3b80:	00002097          	auipc	ra,0x2
    3b84:	972080e7          	jalr	-1678(ra) # 54f2 <exit>
    exit(0);
    3b88:	4501                	li	a0,0
    3b8a:	00002097          	auipc	ra,0x2
    3b8e:	968080e7          	jalr	-1688(ra) # 54f2 <exit>
  sleep(1);
    3b92:	4505                	li	a0,1
    3b94:	00002097          	auipc	ra,0x2
    3b98:	9ee080e7          	jalr	-1554(ra) # 5582 <sleep>
  if(unlink("oidir") != 0){
    3b9c:	00004517          	auipc	a0,0x4
    3ba0:	b9450513          	addi	a0,a0,-1132 # 7730 <malloc+0x1e08>
    3ba4:	00002097          	auipc	ra,0x2
    3ba8:	99e080e7          	jalr	-1634(ra) # 5542 <unlink>
    3bac:	cd19                	beqz	a0,3bca <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3bae:	85a6                	mv	a1,s1
    3bb0:	00003517          	auipc	a0,0x3
    3bb4:	bc850513          	addi	a0,a0,-1080 # 6778 <malloc+0xe50>
    3bb8:	00002097          	auipc	ra,0x2
    3bbc:	cb2080e7          	jalr	-846(ra) # 586a <printf>
    exit(1);
    3bc0:	4505                	li	a0,1
    3bc2:	00002097          	auipc	ra,0x2
    3bc6:	930080e7          	jalr	-1744(ra) # 54f2 <exit>
  wait(&xstatus);
    3bca:	fdc40513          	addi	a0,s0,-36
    3bce:	00002097          	auipc	ra,0x2
    3bd2:	92c080e7          	jalr	-1748(ra) # 54fa <wait>
  exit(xstatus);
    3bd6:	fdc42503          	lw	a0,-36(s0)
    3bda:	00002097          	auipc	ra,0x2
    3bde:	918080e7          	jalr	-1768(ra) # 54f2 <exit>

0000000000003be2 <forkforkfork>:
{
    3be2:	1101                	addi	sp,sp,-32
    3be4:	ec06                	sd	ra,24(sp)
    3be6:	e822                	sd	s0,16(sp)
    3be8:	e426                	sd	s1,8(sp)
    3bea:	1000                	addi	s0,sp,32
    3bec:	84aa                	mv	s1,a0
  unlink("stopforking");
    3bee:	00004517          	auipc	a0,0x4
    3bf2:	b8a50513          	addi	a0,a0,-1142 # 7778 <malloc+0x1e50>
    3bf6:	00002097          	auipc	ra,0x2
    3bfa:	94c080e7          	jalr	-1716(ra) # 5542 <unlink>
  int pid = fork();
    3bfe:	00002097          	auipc	ra,0x2
    3c02:	8ec080e7          	jalr	-1812(ra) # 54ea <fork>
  if(pid < 0){
    3c06:	04054563          	bltz	a0,3c50 <forkforkfork+0x6e>
  if(pid == 0){
    3c0a:	c12d                	beqz	a0,3c6c <forkforkfork+0x8a>
  sleep(20); // two seconds
    3c0c:	4551                	li	a0,20
    3c0e:	00002097          	auipc	ra,0x2
    3c12:	974080e7          	jalr	-1676(ra) # 5582 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3c16:	20200593          	li	a1,514
    3c1a:	00004517          	auipc	a0,0x4
    3c1e:	b5e50513          	addi	a0,a0,-1186 # 7778 <malloc+0x1e50>
    3c22:	00002097          	auipc	ra,0x2
    3c26:	910080e7          	jalr	-1776(ra) # 5532 <open>
    3c2a:	00002097          	auipc	ra,0x2
    3c2e:	8f0080e7          	jalr	-1808(ra) # 551a <close>
  wait(0);
    3c32:	4501                	li	a0,0
    3c34:	00002097          	auipc	ra,0x2
    3c38:	8c6080e7          	jalr	-1850(ra) # 54fa <wait>
  sleep(10); // one second
    3c3c:	4529                	li	a0,10
    3c3e:	00002097          	auipc	ra,0x2
    3c42:	944080e7          	jalr	-1724(ra) # 5582 <sleep>
}
    3c46:	60e2                	ld	ra,24(sp)
    3c48:	6442                	ld	s0,16(sp)
    3c4a:	64a2                	ld	s1,8(sp)
    3c4c:	6105                	addi	sp,sp,32
    3c4e:	8082                	ret
    printf("%s: fork failed", s);
    3c50:	85a6                	mv	a1,s1
    3c52:	00003517          	auipc	a0,0x3
    3c56:	af650513          	addi	a0,a0,-1290 # 6748 <malloc+0xe20>
    3c5a:	00002097          	auipc	ra,0x2
    3c5e:	c10080e7          	jalr	-1008(ra) # 586a <printf>
    exit(1);
    3c62:	4505                	li	a0,1
    3c64:	00002097          	auipc	ra,0x2
    3c68:	88e080e7          	jalr	-1906(ra) # 54f2 <exit>
      int fd = open("stopforking", 0);
    3c6c:	00004497          	auipc	s1,0x4
    3c70:	b0c48493          	addi	s1,s1,-1268 # 7778 <malloc+0x1e50>
    3c74:	4581                	li	a1,0
    3c76:	8526                	mv	a0,s1
    3c78:	00002097          	auipc	ra,0x2
    3c7c:	8ba080e7          	jalr	-1862(ra) # 5532 <open>
      if(fd >= 0){
    3c80:	02055463          	bgez	a0,3ca8 <forkforkfork+0xc6>
      if(fork() < 0){
    3c84:	00002097          	auipc	ra,0x2
    3c88:	866080e7          	jalr	-1946(ra) # 54ea <fork>
    3c8c:	fe0554e3          	bgez	a0,3c74 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3c90:	20200593          	li	a1,514
    3c94:	8526                	mv	a0,s1
    3c96:	00002097          	auipc	ra,0x2
    3c9a:	89c080e7          	jalr	-1892(ra) # 5532 <open>
    3c9e:	00002097          	auipc	ra,0x2
    3ca2:	87c080e7          	jalr	-1924(ra) # 551a <close>
    3ca6:	b7f9                	j	3c74 <forkforkfork+0x92>
        exit(0);
    3ca8:	4501                	li	a0,0
    3caa:	00002097          	auipc	ra,0x2
    3cae:	848080e7          	jalr	-1976(ra) # 54f2 <exit>

0000000000003cb2 <preempt>:
{
    3cb2:	7139                	addi	sp,sp,-64
    3cb4:	fc06                	sd	ra,56(sp)
    3cb6:	f822                	sd	s0,48(sp)
    3cb8:	f426                	sd	s1,40(sp)
    3cba:	f04a                	sd	s2,32(sp)
    3cbc:	ec4e                	sd	s3,24(sp)
    3cbe:	e852                	sd	s4,16(sp)
    3cc0:	0080                	addi	s0,sp,64
    3cc2:	8a2a                	mv	s4,a0
  pid1 = fork();
    3cc4:	00002097          	auipc	ra,0x2
    3cc8:	826080e7          	jalr	-2010(ra) # 54ea <fork>
  if(pid1 < 0) {
    3ccc:	00054563          	bltz	a0,3cd6 <preempt+0x24>
    3cd0:	89aa                	mv	s3,a0
  if(pid1 == 0)
    3cd2:	ed19                	bnez	a0,3cf0 <preempt+0x3e>
    for(;;)
    3cd4:	a001                	j	3cd4 <preempt+0x22>
    printf("%s: fork failed");
    3cd6:	00003517          	auipc	a0,0x3
    3cda:	a7250513          	addi	a0,a0,-1422 # 6748 <malloc+0xe20>
    3cde:	00002097          	auipc	ra,0x2
    3ce2:	b8c080e7          	jalr	-1140(ra) # 586a <printf>
    exit(1);
    3ce6:	4505                	li	a0,1
    3ce8:	00002097          	auipc	ra,0x2
    3cec:	80a080e7          	jalr	-2038(ra) # 54f2 <exit>
  pid2 = fork();
    3cf0:	00001097          	auipc	ra,0x1
    3cf4:	7fa080e7          	jalr	2042(ra) # 54ea <fork>
    3cf8:	892a                	mv	s2,a0
  if(pid2 < 0) {
    3cfa:	00054463          	bltz	a0,3d02 <preempt+0x50>
  if(pid2 == 0)
    3cfe:	e105                	bnez	a0,3d1e <preempt+0x6c>
    for(;;)
    3d00:	a001                	j	3d00 <preempt+0x4e>
    printf("%s: fork failed\n", s);
    3d02:	85d2                	mv	a1,s4
    3d04:	00003517          	auipc	a0,0x3
    3d08:	88450513          	addi	a0,a0,-1916 # 6588 <malloc+0xc60>
    3d0c:	00002097          	auipc	ra,0x2
    3d10:	b5e080e7          	jalr	-1186(ra) # 586a <printf>
    exit(1);
    3d14:	4505                	li	a0,1
    3d16:	00001097          	auipc	ra,0x1
    3d1a:	7dc080e7          	jalr	2012(ra) # 54f2 <exit>
  pipe(pfds);
    3d1e:	fc840513          	addi	a0,s0,-56
    3d22:	00001097          	auipc	ra,0x1
    3d26:	7e0080e7          	jalr	2016(ra) # 5502 <pipe>
  pid3 = fork();
    3d2a:	00001097          	auipc	ra,0x1
    3d2e:	7c0080e7          	jalr	1984(ra) # 54ea <fork>
    3d32:	84aa                	mv	s1,a0
  if(pid3 < 0) {
    3d34:	02054e63          	bltz	a0,3d70 <preempt+0xbe>
  if(pid3 == 0){
    3d38:	e13d                	bnez	a0,3d9e <preempt+0xec>
    close(pfds[0]);
    3d3a:	fc842503          	lw	a0,-56(s0)
    3d3e:	00001097          	auipc	ra,0x1
    3d42:	7dc080e7          	jalr	2012(ra) # 551a <close>
    if(write(pfds[1], "x", 1) != 1)
    3d46:	4605                	li	a2,1
    3d48:	00002597          	auipc	a1,0x2
    3d4c:	07858593          	addi	a1,a1,120 # 5dc0 <malloc+0x498>
    3d50:	fcc42503          	lw	a0,-52(s0)
    3d54:	00001097          	auipc	ra,0x1
    3d58:	7be080e7          	jalr	1982(ra) # 5512 <write>
    3d5c:	4785                	li	a5,1
    3d5e:	02f51763          	bne	a0,a5,3d8c <preempt+0xda>
    close(pfds[1]);
    3d62:	fcc42503          	lw	a0,-52(s0)
    3d66:	00001097          	auipc	ra,0x1
    3d6a:	7b4080e7          	jalr	1972(ra) # 551a <close>
    for(;;)
    3d6e:	a001                	j	3d6e <preempt+0xbc>
     printf("%s: fork failed\n", s);
    3d70:	85d2                	mv	a1,s4
    3d72:	00003517          	auipc	a0,0x3
    3d76:	81650513          	addi	a0,a0,-2026 # 6588 <malloc+0xc60>
    3d7a:	00002097          	auipc	ra,0x2
    3d7e:	af0080e7          	jalr	-1296(ra) # 586a <printf>
     exit(1);
    3d82:	4505                	li	a0,1
    3d84:	00001097          	auipc	ra,0x1
    3d88:	76e080e7          	jalr	1902(ra) # 54f2 <exit>
      printf("%s: preempt write error");
    3d8c:	00004517          	auipc	a0,0x4
    3d90:	9fc50513          	addi	a0,a0,-1540 # 7788 <malloc+0x1e60>
    3d94:	00002097          	auipc	ra,0x2
    3d98:	ad6080e7          	jalr	-1322(ra) # 586a <printf>
    3d9c:	b7d9                	j	3d62 <preempt+0xb0>
  close(pfds[1]);
    3d9e:	fcc42503          	lw	a0,-52(s0)
    3da2:	00001097          	auipc	ra,0x1
    3da6:	778080e7          	jalr	1912(ra) # 551a <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3daa:	660d                	lui	a2,0x3
    3dac:	00008597          	auipc	a1,0x8
    3db0:	bc458593          	addi	a1,a1,-1084 # b970 <buf>
    3db4:	fc842503          	lw	a0,-56(s0)
    3db8:	00001097          	auipc	ra,0x1
    3dbc:	752080e7          	jalr	1874(ra) # 550a <read>
    3dc0:	4785                	li	a5,1
    3dc2:	02f50263          	beq	a0,a5,3de6 <preempt+0x134>
    printf("%s: preempt read error");
    3dc6:	00004517          	auipc	a0,0x4
    3dca:	9da50513          	addi	a0,a0,-1574 # 77a0 <malloc+0x1e78>
    3dce:	00002097          	auipc	ra,0x2
    3dd2:	a9c080e7          	jalr	-1380(ra) # 586a <printf>
}
    3dd6:	70e2                	ld	ra,56(sp)
    3dd8:	7442                	ld	s0,48(sp)
    3dda:	74a2                	ld	s1,40(sp)
    3ddc:	7902                	ld	s2,32(sp)
    3dde:	69e2                	ld	s3,24(sp)
    3de0:	6a42                	ld	s4,16(sp)
    3de2:	6121                	addi	sp,sp,64
    3de4:	8082                	ret
  close(pfds[0]);
    3de6:	fc842503          	lw	a0,-56(s0)
    3dea:	00001097          	auipc	ra,0x1
    3dee:	730080e7          	jalr	1840(ra) # 551a <close>
  printf("kill... ");
    3df2:	00004517          	auipc	a0,0x4
    3df6:	9c650513          	addi	a0,a0,-1594 # 77b8 <malloc+0x1e90>
    3dfa:	00002097          	auipc	ra,0x2
    3dfe:	a70080e7          	jalr	-1424(ra) # 586a <printf>
  kill(pid1);
    3e02:	854e                	mv	a0,s3
    3e04:	00001097          	auipc	ra,0x1
    3e08:	71e080e7          	jalr	1822(ra) # 5522 <kill>
  kill(pid2);
    3e0c:	854a                	mv	a0,s2
    3e0e:	00001097          	auipc	ra,0x1
    3e12:	714080e7          	jalr	1812(ra) # 5522 <kill>
  kill(pid3);
    3e16:	8526                	mv	a0,s1
    3e18:	00001097          	auipc	ra,0x1
    3e1c:	70a080e7          	jalr	1802(ra) # 5522 <kill>
  printf("wait... ");
    3e20:	00004517          	auipc	a0,0x4
    3e24:	9a850513          	addi	a0,a0,-1624 # 77c8 <malloc+0x1ea0>
    3e28:	00002097          	auipc	ra,0x2
    3e2c:	a42080e7          	jalr	-1470(ra) # 586a <printf>
  wait(0);
    3e30:	4501                	li	a0,0
    3e32:	00001097          	auipc	ra,0x1
    3e36:	6c8080e7          	jalr	1736(ra) # 54fa <wait>
  wait(0);
    3e3a:	4501                	li	a0,0
    3e3c:	00001097          	auipc	ra,0x1
    3e40:	6be080e7          	jalr	1726(ra) # 54fa <wait>
  wait(0);
    3e44:	4501                	li	a0,0
    3e46:	00001097          	auipc	ra,0x1
    3e4a:	6b4080e7          	jalr	1716(ra) # 54fa <wait>
    3e4e:	b761                	j	3dd6 <preempt+0x124>

0000000000003e50 <sbrkfail>:
{
    3e50:	7119                	addi	sp,sp,-128
    3e52:	fc86                	sd	ra,120(sp)
    3e54:	f8a2                	sd	s0,112(sp)
    3e56:	f4a6                	sd	s1,104(sp)
    3e58:	f0ca                	sd	s2,96(sp)
    3e5a:	ecce                	sd	s3,88(sp)
    3e5c:	e8d2                	sd	s4,80(sp)
    3e5e:	e4d6                	sd	s5,72(sp)
    3e60:	0100                	addi	s0,sp,128
    3e62:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    3e64:	fb040513          	addi	a0,s0,-80
    3e68:	00001097          	auipc	ra,0x1
    3e6c:	69a080e7          	jalr	1690(ra) # 5502 <pipe>
    3e70:	e901                	bnez	a0,3e80 <sbrkfail+0x30>
    3e72:	f8040493          	addi	s1,s0,-128
    3e76:	fa840a13          	addi	s4,s0,-88
    3e7a:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    3e7c:	5afd                	li	s5,-1
    3e7e:	a08d                	j	3ee0 <sbrkfail+0x90>
    printf("%s: pipe() failed\n", s);
    3e80:	85ca                	mv	a1,s2
    3e82:	00003517          	auipc	a0,0x3
    3e86:	80e50513          	addi	a0,a0,-2034 # 6690 <malloc+0xd68>
    3e8a:	00002097          	auipc	ra,0x2
    3e8e:	9e0080e7          	jalr	-1568(ra) # 586a <printf>
    exit(1);
    3e92:	4505                	li	a0,1
    3e94:	00001097          	auipc	ra,0x1
    3e98:	65e080e7          	jalr	1630(ra) # 54f2 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3e9c:	4501                	li	a0,0
    3e9e:	00001097          	auipc	ra,0x1
    3ea2:	6dc080e7          	jalr	1756(ra) # 557a <sbrk>
    3ea6:	064007b7          	lui	a5,0x6400
    3eaa:	40a7853b          	subw	a0,a5,a0
    3eae:	00001097          	auipc	ra,0x1
    3eb2:	6cc080e7          	jalr	1740(ra) # 557a <sbrk>
      write(fds[1], "x", 1);
    3eb6:	4605                	li	a2,1
    3eb8:	00002597          	auipc	a1,0x2
    3ebc:	f0858593          	addi	a1,a1,-248 # 5dc0 <malloc+0x498>
    3ec0:	fb442503          	lw	a0,-76(s0)
    3ec4:	00001097          	auipc	ra,0x1
    3ec8:	64e080e7          	jalr	1614(ra) # 5512 <write>
      for(;;) sleep(1000);
    3ecc:	3e800513          	li	a0,1000
    3ed0:	00001097          	auipc	ra,0x1
    3ed4:	6b2080e7          	jalr	1714(ra) # 5582 <sleep>
    3ed8:	bfd5                	j	3ecc <sbrkfail+0x7c>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3eda:	0991                	addi	s3,s3,4
    3edc:	03498563          	beq	s3,s4,3f06 <sbrkfail+0xb6>
    if((pids[i] = fork()) == 0){
    3ee0:	00001097          	auipc	ra,0x1
    3ee4:	60a080e7          	jalr	1546(ra) # 54ea <fork>
    3ee8:	00a9a023          	sw	a0,0(s3)
    3eec:	d945                	beqz	a0,3e9c <sbrkfail+0x4c>
    if(pids[i] != -1)
    3eee:	ff5506e3          	beq	a0,s5,3eda <sbrkfail+0x8a>
      read(fds[0], &scratch, 1);
    3ef2:	4605                	li	a2,1
    3ef4:	faf40593          	addi	a1,s0,-81
    3ef8:	fb042503          	lw	a0,-80(s0)
    3efc:	00001097          	auipc	ra,0x1
    3f00:	60e080e7          	jalr	1550(ra) # 550a <read>
    3f04:	bfd9                	j	3eda <sbrkfail+0x8a>
  c = sbrk(PGSIZE);
    3f06:	6505                	lui	a0,0x1
    3f08:	00001097          	auipc	ra,0x1
    3f0c:	672080e7          	jalr	1650(ra) # 557a <sbrk>
    3f10:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    3f12:	5afd                	li	s5,-1
    3f14:	a021                	j	3f1c <sbrkfail+0xcc>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3f16:	0491                	addi	s1,s1,4
    3f18:	01448f63          	beq	s1,s4,3f36 <sbrkfail+0xe6>
    if(pids[i] == -1)
    3f1c:	4088                	lw	a0,0(s1)
    3f1e:	ff550ce3          	beq	a0,s5,3f16 <sbrkfail+0xc6>
    kill(pids[i]);
    3f22:	00001097          	auipc	ra,0x1
    3f26:	600080e7          	jalr	1536(ra) # 5522 <kill>
    wait(0);
    3f2a:	4501                	li	a0,0
    3f2c:	00001097          	auipc	ra,0x1
    3f30:	5ce080e7          	jalr	1486(ra) # 54fa <wait>
    3f34:	b7cd                	j	3f16 <sbrkfail+0xc6>
  if(c == (char*)0xffffffffffffffffL){
    3f36:	57fd                	li	a5,-1
    3f38:	04f98163          	beq	s3,a5,3f7a <sbrkfail+0x12a>
  pid = fork();
    3f3c:	00001097          	auipc	ra,0x1
    3f40:	5ae080e7          	jalr	1454(ra) # 54ea <fork>
    3f44:	84aa                	mv	s1,a0
  if(pid < 0){
    3f46:	04054863          	bltz	a0,3f96 <sbrkfail+0x146>
  if(pid == 0){
    3f4a:	c525                	beqz	a0,3fb2 <sbrkfail+0x162>
  wait(&xstatus);
    3f4c:	fbc40513          	addi	a0,s0,-68
    3f50:	00001097          	auipc	ra,0x1
    3f54:	5aa080e7          	jalr	1450(ra) # 54fa <wait>
  if(xstatus != -1 && xstatus != 2)
    3f58:	fbc42783          	lw	a5,-68(s0)
    3f5c:	577d                	li	a4,-1
    3f5e:	00e78563          	beq	a5,a4,3f68 <sbrkfail+0x118>
    3f62:	4709                	li	a4,2
    3f64:	08e79c63          	bne	a5,a4,3ffc <sbrkfail+0x1ac>
}
    3f68:	70e6                	ld	ra,120(sp)
    3f6a:	7446                	ld	s0,112(sp)
    3f6c:	74a6                	ld	s1,104(sp)
    3f6e:	7906                	ld	s2,96(sp)
    3f70:	69e6                	ld	s3,88(sp)
    3f72:	6a46                	ld	s4,80(sp)
    3f74:	6aa6                	ld	s5,72(sp)
    3f76:	6109                	addi	sp,sp,128
    3f78:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3f7a:	85ca                	mv	a1,s2
    3f7c:	00004517          	auipc	a0,0x4
    3f80:	85c50513          	addi	a0,a0,-1956 # 77d8 <malloc+0x1eb0>
    3f84:	00002097          	auipc	ra,0x2
    3f88:	8e6080e7          	jalr	-1818(ra) # 586a <printf>
    exit(1);
    3f8c:	4505                	li	a0,1
    3f8e:	00001097          	auipc	ra,0x1
    3f92:	564080e7          	jalr	1380(ra) # 54f2 <exit>
    printf("%s: fork failed\n", s);
    3f96:	85ca                	mv	a1,s2
    3f98:	00002517          	auipc	a0,0x2
    3f9c:	5f050513          	addi	a0,a0,1520 # 6588 <malloc+0xc60>
    3fa0:	00002097          	auipc	ra,0x2
    3fa4:	8ca080e7          	jalr	-1846(ra) # 586a <printf>
    exit(1);
    3fa8:	4505                	li	a0,1
    3faa:	00001097          	auipc	ra,0x1
    3fae:	548080e7          	jalr	1352(ra) # 54f2 <exit>
    a = sbrk(0);
    3fb2:	4501                	li	a0,0
    3fb4:	00001097          	auipc	ra,0x1
    3fb8:	5c6080e7          	jalr	1478(ra) # 557a <sbrk>
    3fbc:	892a                	mv	s2,a0
    sbrk(10*BIG);
    3fbe:	3e800537          	lui	a0,0x3e800
    3fc2:	00001097          	auipc	ra,0x1
    3fc6:	5b8080e7          	jalr	1464(ra) # 557a <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3fca:	874a                	mv	a4,s2
    3fcc:	3e8007b7          	lui	a5,0x3e800
    3fd0:	97ca                	add	a5,a5,s2
    3fd2:	6685                	lui	a3,0x1
      n += *(a+i);
    3fd4:	00074603          	lbu	a2,0(a4)
    3fd8:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3fda:	9736                	add	a4,a4,a3
    3fdc:	fef71ce3          	bne	a4,a5,3fd4 <sbrkfail+0x184>
    printf("%s: allocate a lot of memory succeeded %d\n", n);
    3fe0:	85a6                	mv	a1,s1
    3fe2:	00004517          	auipc	a0,0x4
    3fe6:	81650513          	addi	a0,a0,-2026 # 77f8 <malloc+0x1ed0>
    3fea:	00002097          	auipc	ra,0x2
    3fee:	880080e7          	jalr	-1920(ra) # 586a <printf>
    exit(1);
    3ff2:	4505                	li	a0,1
    3ff4:	00001097          	auipc	ra,0x1
    3ff8:	4fe080e7          	jalr	1278(ra) # 54f2 <exit>
    exit(1);
    3ffc:	4505                	li	a0,1
    3ffe:	00001097          	auipc	ra,0x1
    4002:	4f4080e7          	jalr	1268(ra) # 54f2 <exit>

0000000000004006 <reparent>:
{
    4006:	7179                	addi	sp,sp,-48
    4008:	f406                	sd	ra,40(sp)
    400a:	f022                	sd	s0,32(sp)
    400c:	ec26                	sd	s1,24(sp)
    400e:	e84a                	sd	s2,16(sp)
    4010:	e44e                	sd	s3,8(sp)
    4012:	e052                	sd	s4,0(sp)
    4014:	1800                	addi	s0,sp,48
    4016:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4018:	00001097          	auipc	ra,0x1
    401c:	55a080e7          	jalr	1370(ra) # 5572 <getpid>
    4020:	8a2a                	mv	s4,a0
    4022:	0c800913          	li	s2,200
    int pid = fork();
    4026:	00001097          	auipc	ra,0x1
    402a:	4c4080e7          	jalr	1220(ra) # 54ea <fork>
    402e:	84aa                	mv	s1,a0
    if(pid < 0){
    4030:	02054263          	bltz	a0,4054 <reparent+0x4e>
    if(pid){
    4034:	cd21                	beqz	a0,408c <reparent+0x86>
      if(wait(0) != pid){
    4036:	4501                	li	a0,0
    4038:	00001097          	auipc	ra,0x1
    403c:	4c2080e7          	jalr	1218(ra) # 54fa <wait>
    4040:	02951863          	bne	a0,s1,4070 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4044:	397d                	addiw	s2,s2,-1
    4046:	fe0910e3          	bnez	s2,4026 <reparent+0x20>
  exit(0);
    404a:	4501                	li	a0,0
    404c:	00001097          	auipc	ra,0x1
    4050:	4a6080e7          	jalr	1190(ra) # 54f2 <exit>
      printf("%s: fork failed\n", s);
    4054:	85ce                	mv	a1,s3
    4056:	00002517          	auipc	a0,0x2
    405a:	53250513          	addi	a0,a0,1330 # 6588 <malloc+0xc60>
    405e:	00002097          	auipc	ra,0x2
    4062:	80c080e7          	jalr	-2036(ra) # 586a <printf>
      exit(1);
    4066:	4505                	li	a0,1
    4068:	00001097          	auipc	ra,0x1
    406c:	48a080e7          	jalr	1162(ra) # 54f2 <exit>
        printf("%s: wait wrong pid\n", s);
    4070:	85ce                	mv	a1,s3
    4072:	00002517          	auipc	a0,0x2
    4076:	69e50513          	addi	a0,a0,1694 # 6710 <malloc+0xde8>
    407a:	00001097          	auipc	ra,0x1
    407e:	7f0080e7          	jalr	2032(ra) # 586a <printf>
        exit(1);
    4082:	4505                	li	a0,1
    4084:	00001097          	auipc	ra,0x1
    4088:	46e080e7          	jalr	1134(ra) # 54f2 <exit>
      int pid2 = fork();
    408c:	00001097          	auipc	ra,0x1
    4090:	45e080e7          	jalr	1118(ra) # 54ea <fork>
      if(pid2 < 0){
    4094:	00054763          	bltz	a0,40a2 <reparent+0x9c>
      exit(0);
    4098:	4501                	li	a0,0
    409a:	00001097          	auipc	ra,0x1
    409e:	458080e7          	jalr	1112(ra) # 54f2 <exit>
        kill(master_pid);
    40a2:	8552                	mv	a0,s4
    40a4:	00001097          	auipc	ra,0x1
    40a8:	47e080e7          	jalr	1150(ra) # 5522 <kill>
        exit(1);
    40ac:	4505                	li	a0,1
    40ae:	00001097          	auipc	ra,0x1
    40b2:	444080e7          	jalr	1092(ra) # 54f2 <exit>

00000000000040b6 <mem>:
{
    40b6:	7139                	addi	sp,sp,-64
    40b8:	fc06                	sd	ra,56(sp)
    40ba:	f822                	sd	s0,48(sp)
    40bc:	f426                	sd	s1,40(sp)
    40be:	f04a                	sd	s2,32(sp)
    40c0:	ec4e                	sd	s3,24(sp)
    40c2:	0080                	addi	s0,sp,64
    40c4:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    40c6:	00001097          	auipc	ra,0x1
    40ca:	424080e7          	jalr	1060(ra) # 54ea <fork>
    m1 = 0;
    40ce:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    40d0:	6909                	lui	s2,0x2
    40d2:	71190913          	addi	s2,s2,1809 # 2711 <sbrkmuch+0x119>
  if((pid = fork()) == 0){
    40d6:	ed39                	bnez	a0,4134 <mem+0x7e>
    while((m2 = malloc(10001)) != 0){
    40d8:	854a                	mv	a0,s2
    40da:	00002097          	auipc	ra,0x2
    40de:	84e080e7          	jalr	-1970(ra) # 5928 <malloc>
    40e2:	c501                	beqz	a0,40ea <mem+0x34>
      *(char**)m2 = m1;
    40e4:	e104                	sd	s1,0(a0)
      m1 = m2;
    40e6:	84aa                	mv	s1,a0
    40e8:	bfc5                	j	40d8 <mem+0x22>
    while(m1){
    40ea:	c881                	beqz	s1,40fa <mem+0x44>
      m2 = *(char**)m1;
    40ec:	8526                	mv	a0,s1
    40ee:	6084                	ld	s1,0(s1)
      free(m1);
    40f0:	00001097          	auipc	ra,0x1
    40f4:	7b0080e7          	jalr	1968(ra) # 58a0 <free>
    while(m1){
    40f8:	f8f5                	bnez	s1,40ec <mem+0x36>
    m1 = malloc(1024*20);
    40fa:	6515                	lui	a0,0x5
    40fc:	00002097          	auipc	ra,0x2
    4100:	82c080e7          	jalr	-2004(ra) # 5928 <malloc>
    if(m1 == 0){
    4104:	c911                	beqz	a0,4118 <mem+0x62>
    free(m1);
    4106:	00001097          	auipc	ra,0x1
    410a:	79a080e7          	jalr	1946(ra) # 58a0 <free>
    exit(0);
    410e:	4501                	li	a0,0
    4110:	00001097          	auipc	ra,0x1
    4114:	3e2080e7          	jalr	994(ra) # 54f2 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4118:	85ce                	mv	a1,s3
    411a:	00003517          	auipc	a0,0x3
    411e:	70e50513          	addi	a0,a0,1806 # 7828 <malloc+0x1f00>
    4122:	00001097          	auipc	ra,0x1
    4126:	748080e7          	jalr	1864(ra) # 586a <printf>
      exit(1);
    412a:	4505                	li	a0,1
    412c:	00001097          	auipc	ra,0x1
    4130:	3c6080e7          	jalr	966(ra) # 54f2 <exit>
    wait(&xstatus);
    4134:	fcc40513          	addi	a0,s0,-52
    4138:	00001097          	auipc	ra,0x1
    413c:	3c2080e7          	jalr	962(ra) # 54fa <wait>
    if(xstatus == -1){
    4140:	fcc42503          	lw	a0,-52(s0)
    4144:	57fd                	li	a5,-1
    4146:	00f50663          	beq	a0,a5,4152 <mem+0x9c>
    exit(xstatus);
    414a:	00001097          	auipc	ra,0x1
    414e:	3a8080e7          	jalr	936(ra) # 54f2 <exit>
      exit(0);
    4152:	4501                	li	a0,0
    4154:	00001097          	auipc	ra,0x1
    4158:	39e080e7          	jalr	926(ra) # 54f2 <exit>

000000000000415c <sharedfd>:
{
    415c:	7159                	addi	sp,sp,-112
    415e:	f486                	sd	ra,104(sp)
    4160:	f0a2                	sd	s0,96(sp)
    4162:	eca6                	sd	s1,88(sp)
    4164:	e8ca                	sd	s2,80(sp)
    4166:	e4ce                	sd	s3,72(sp)
    4168:	e0d2                	sd	s4,64(sp)
    416a:	fc56                	sd	s5,56(sp)
    416c:	f85a                	sd	s6,48(sp)
    416e:	f45e                	sd	s7,40(sp)
    4170:	1880                	addi	s0,sp,112
    4172:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4174:	00002517          	auipc	a0,0x2
    4178:	a2450513          	addi	a0,a0,-1500 # 5b98 <malloc+0x270>
    417c:	00001097          	auipc	ra,0x1
    4180:	3c6080e7          	jalr	966(ra) # 5542 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4184:	20200593          	li	a1,514
    4188:	00002517          	auipc	a0,0x2
    418c:	a1050513          	addi	a0,a0,-1520 # 5b98 <malloc+0x270>
    4190:	00001097          	auipc	ra,0x1
    4194:	3a2080e7          	jalr	930(ra) # 5532 <open>
  if(fd < 0){
    4198:	04054a63          	bltz	a0,41ec <sharedfd+0x90>
    419c:	892a                	mv	s2,a0
  pid = fork();
    419e:	00001097          	auipc	ra,0x1
    41a2:	34c080e7          	jalr	844(ra) # 54ea <fork>
    41a6:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    41a8:	06300593          	li	a1,99
    41ac:	c119                	beqz	a0,41b2 <sharedfd+0x56>
    41ae:	07000593          	li	a1,112
    41b2:	4629                	li	a2,10
    41b4:	fa040513          	addi	a0,s0,-96
    41b8:	00001097          	auipc	ra,0x1
    41bc:	136080e7          	jalr	310(ra) # 52ee <memset>
    41c0:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    41c4:	4629                	li	a2,10
    41c6:	fa040593          	addi	a1,s0,-96
    41ca:	854a                	mv	a0,s2
    41cc:	00001097          	auipc	ra,0x1
    41d0:	346080e7          	jalr	838(ra) # 5512 <write>
    41d4:	47a9                	li	a5,10
    41d6:	02f51963          	bne	a0,a5,4208 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    41da:	34fd                	addiw	s1,s1,-1
    41dc:	f4e5                	bnez	s1,41c4 <sharedfd+0x68>
  if(pid == 0) {
    41de:	04099363          	bnez	s3,4224 <sharedfd+0xc8>
    exit(0);
    41e2:	4501                	li	a0,0
    41e4:	00001097          	auipc	ra,0x1
    41e8:	30e080e7          	jalr	782(ra) # 54f2 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    41ec:	85d2                	mv	a1,s4
    41ee:	00003517          	auipc	a0,0x3
    41f2:	65a50513          	addi	a0,a0,1626 # 7848 <malloc+0x1f20>
    41f6:	00001097          	auipc	ra,0x1
    41fa:	674080e7          	jalr	1652(ra) # 586a <printf>
    exit(1);
    41fe:	4505                	li	a0,1
    4200:	00001097          	auipc	ra,0x1
    4204:	2f2080e7          	jalr	754(ra) # 54f2 <exit>
      printf("%s: write sharedfd failed\n", s);
    4208:	85d2                	mv	a1,s4
    420a:	00003517          	auipc	a0,0x3
    420e:	66650513          	addi	a0,a0,1638 # 7870 <malloc+0x1f48>
    4212:	00001097          	auipc	ra,0x1
    4216:	658080e7          	jalr	1624(ra) # 586a <printf>
      exit(1);
    421a:	4505                	li	a0,1
    421c:	00001097          	auipc	ra,0x1
    4220:	2d6080e7          	jalr	726(ra) # 54f2 <exit>
    wait(&xstatus);
    4224:	f9c40513          	addi	a0,s0,-100
    4228:	00001097          	auipc	ra,0x1
    422c:	2d2080e7          	jalr	722(ra) # 54fa <wait>
    if(xstatus != 0)
    4230:	f9c42983          	lw	s3,-100(s0)
    4234:	00098763          	beqz	s3,4242 <sharedfd+0xe6>
      exit(xstatus);
    4238:	854e                	mv	a0,s3
    423a:	00001097          	auipc	ra,0x1
    423e:	2b8080e7          	jalr	696(ra) # 54f2 <exit>
  close(fd);
    4242:	854a                	mv	a0,s2
    4244:	00001097          	auipc	ra,0x1
    4248:	2d6080e7          	jalr	726(ra) # 551a <close>
  fd = open("sharedfd", 0);
    424c:	4581                	li	a1,0
    424e:	00002517          	auipc	a0,0x2
    4252:	94a50513          	addi	a0,a0,-1718 # 5b98 <malloc+0x270>
    4256:	00001097          	auipc	ra,0x1
    425a:	2dc080e7          	jalr	732(ra) # 5532 <open>
    425e:	8baa                	mv	s7,a0
  nc = np = 0;
    4260:	8ace                	mv	s5,s3
  if(fd < 0){
    4262:	02054563          	bltz	a0,428c <sharedfd+0x130>
    4266:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    426a:	06300493          	li	s1,99
      if(buf[i] == 'p')
    426e:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4272:	4629                	li	a2,10
    4274:	fa040593          	addi	a1,s0,-96
    4278:	855e                	mv	a0,s7
    427a:	00001097          	auipc	ra,0x1
    427e:	290080e7          	jalr	656(ra) # 550a <read>
    4282:	02a05f63          	blez	a0,42c0 <sharedfd+0x164>
    4286:	fa040793          	addi	a5,s0,-96
    428a:	a01d                	j	42b0 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    428c:	85d2                	mv	a1,s4
    428e:	00003517          	auipc	a0,0x3
    4292:	60250513          	addi	a0,a0,1538 # 7890 <malloc+0x1f68>
    4296:	00001097          	auipc	ra,0x1
    429a:	5d4080e7          	jalr	1492(ra) # 586a <printf>
    exit(1);
    429e:	4505                	li	a0,1
    42a0:	00001097          	auipc	ra,0x1
    42a4:	252080e7          	jalr	594(ra) # 54f2 <exit>
        nc++;
    42a8:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    42aa:	0785                	addi	a5,a5,1
    42ac:	fd2783e3          	beq	a5,s2,4272 <sharedfd+0x116>
      if(buf[i] == 'c')
    42b0:	0007c703          	lbu	a4,0(a5) # 3e800000 <__BSS_END__+0x3e7f1680>
    42b4:	fe970ae3          	beq	a4,s1,42a8 <sharedfd+0x14c>
      if(buf[i] == 'p')
    42b8:	ff6719e3          	bne	a4,s6,42aa <sharedfd+0x14e>
        np++;
    42bc:	2a85                	addiw	s5,s5,1
    42be:	b7f5                	j	42aa <sharedfd+0x14e>
  close(fd);
    42c0:	855e                	mv	a0,s7
    42c2:	00001097          	auipc	ra,0x1
    42c6:	258080e7          	jalr	600(ra) # 551a <close>
  unlink("sharedfd");
    42ca:	00002517          	auipc	a0,0x2
    42ce:	8ce50513          	addi	a0,a0,-1842 # 5b98 <malloc+0x270>
    42d2:	00001097          	auipc	ra,0x1
    42d6:	270080e7          	jalr	624(ra) # 5542 <unlink>
  if(nc == N*SZ && np == N*SZ){
    42da:	6789                	lui	a5,0x2
    42dc:	71078793          	addi	a5,a5,1808 # 2710 <sbrkmuch+0x118>
    42e0:	00f99763          	bne	s3,a5,42ee <sharedfd+0x192>
    42e4:	6789                	lui	a5,0x2
    42e6:	71078793          	addi	a5,a5,1808 # 2710 <sbrkmuch+0x118>
    42ea:	02fa8063          	beq	s5,a5,430a <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    42ee:	85d2                	mv	a1,s4
    42f0:	00003517          	auipc	a0,0x3
    42f4:	5c850513          	addi	a0,a0,1480 # 78b8 <malloc+0x1f90>
    42f8:	00001097          	auipc	ra,0x1
    42fc:	572080e7          	jalr	1394(ra) # 586a <printf>
    exit(1);
    4300:	4505                	li	a0,1
    4302:	00001097          	auipc	ra,0x1
    4306:	1f0080e7          	jalr	496(ra) # 54f2 <exit>
    exit(0);
    430a:	4501                	li	a0,0
    430c:	00001097          	auipc	ra,0x1
    4310:	1e6080e7          	jalr	486(ra) # 54f2 <exit>

0000000000004314 <fourfiles>:
{
    4314:	7171                	addi	sp,sp,-176
    4316:	f506                	sd	ra,168(sp)
    4318:	f122                	sd	s0,160(sp)
    431a:	ed26                	sd	s1,152(sp)
    431c:	e94a                	sd	s2,144(sp)
    431e:	e54e                	sd	s3,136(sp)
    4320:	e152                	sd	s4,128(sp)
    4322:	fcd6                	sd	s5,120(sp)
    4324:	f8da                	sd	s6,112(sp)
    4326:	f4de                	sd	s7,104(sp)
    4328:	f0e2                	sd	s8,96(sp)
    432a:	ece6                	sd	s9,88(sp)
    432c:	e8ea                	sd	s10,80(sp)
    432e:	e4ee                	sd	s11,72(sp)
    4330:	1900                	addi	s0,sp,176
    4332:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4334:	00001797          	auipc	a5,0x1
    4338:	6dc78793          	addi	a5,a5,1756 # 5a10 <malloc+0xe8>
    433c:	f6f43823          	sd	a5,-144(s0)
    4340:	00001797          	auipc	a5,0x1
    4344:	6d878793          	addi	a5,a5,1752 # 5a18 <malloc+0xf0>
    4348:	f6f43c23          	sd	a5,-136(s0)
    434c:	00001797          	auipc	a5,0x1
    4350:	6d478793          	addi	a5,a5,1748 # 5a20 <malloc+0xf8>
    4354:	f8f43023          	sd	a5,-128(s0)
    4358:	00001797          	auipc	a5,0x1
    435c:	6d078793          	addi	a5,a5,1744 # 5a28 <malloc+0x100>
    4360:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4364:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4368:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    436a:	4481                	li	s1,0
    436c:	4a11                	li	s4,4
    fname = names[pi];
    436e:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4372:	854e                	mv	a0,s3
    4374:	00001097          	auipc	ra,0x1
    4378:	1ce080e7          	jalr	462(ra) # 5542 <unlink>
    pid = fork();
    437c:	00001097          	auipc	ra,0x1
    4380:	16e080e7          	jalr	366(ra) # 54ea <fork>
    if(pid < 0){
    4384:	04054563          	bltz	a0,43ce <fourfiles+0xba>
    if(pid == 0){
    4388:	c12d                	beqz	a0,43ea <fourfiles+0xd6>
  for(pi = 0; pi < NCHILD; pi++){
    438a:	2485                	addiw	s1,s1,1
    438c:	0921                	addi	s2,s2,8
    438e:	ff4490e3          	bne	s1,s4,436e <fourfiles+0x5a>
    4392:	4491                	li	s1,4
    wait(&xstatus);
    4394:	f6c40513          	addi	a0,s0,-148
    4398:	00001097          	auipc	ra,0x1
    439c:	162080e7          	jalr	354(ra) # 54fa <wait>
    if(xstatus != 0)
    43a0:	f6c42503          	lw	a0,-148(s0)
    43a4:	ed69                	bnez	a0,447e <fourfiles+0x16a>
  for(pi = 0; pi < NCHILD; pi++){
    43a6:	34fd                	addiw	s1,s1,-1
    43a8:	f4f5                	bnez	s1,4394 <fourfiles+0x80>
    43aa:	03000b13          	li	s6,48
    total = 0;
    43ae:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    43b2:	00007a17          	auipc	s4,0x7
    43b6:	5bea0a13          	addi	s4,s4,1470 # b970 <buf>
    43ba:	00007a97          	auipc	s5,0x7
    43be:	5b7a8a93          	addi	s5,s5,1463 # b971 <buf+0x1>
    if(total != N*SZ){
    43c2:	6d05                	lui	s10,0x1
    43c4:	770d0d13          	addi	s10,s10,1904 # 1770 <pipe1+0x2a>
  for(i = 0; i < NCHILD; i++){
    43c8:	03400d93          	li	s11,52
    43cc:	a23d                	j	44fa <fourfiles+0x1e6>
      printf("fork failed\n", s);
    43ce:	85e6                	mv	a1,s9
    43d0:	00002517          	auipc	a0,0x2
    43d4:	5a850513          	addi	a0,a0,1448 # 6978 <malloc+0x1050>
    43d8:	00001097          	auipc	ra,0x1
    43dc:	492080e7          	jalr	1170(ra) # 586a <printf>
      exit(1);
    43e0:	4505                	li	a0,1
    43e2:	00001097          	auipc	ra,0x1
    43e6:	110080e7          	jalr	272(ra) # 54f2 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    43ea:	20200593          	li	a1,514
    43ee:	854e                	mv	a0,s3
    43f0:	00001097          	auipc	ra,0x1
    43f4:	142080e7          	jalr	322(ra) # 5532 <open>
    43f8:	892a                	mv	s2,a0
      if(fd < 0){
    43fa:	04054763          	bltz	a0,4448 <fourfiles+0x134>
      memset(buf, '0'+pi, SZ);
    43fe:	1f400613          	li	a2,500
    4402:	0304859b          	addiw	a1,s1,48
    4406:	00007517          	auipc	a0,0x7
    440a:	56a50513          	addi	a0,a0,1386 # b970 <buf>
    440e:	00001097          	auipc	ra,0x1
    4412:	ee0080e7          	jalr	-288(ra) # 52ee <memset>
    4416:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4418:	00007997          	auipc	s3,0x7
    441c:	55898993          	addi	s3,s3,1368 # b970 <buf>
    4420:	1f400613          	li	a2,500
    4424:	85ce                	mv	a1,s3
    4426:	854a                	mv	a0,s2
    4428:	00001097          	auipc	ra,0x1
    442c:	0ea080e7          	jalr	234(ra) # 5512 <write>
    4430:	85aa                	mv	a1,a0
    4432:	1f400793          	li	a5,500
    4436:	02f51763          	bne	a0,a5,4464 <fourfiles+0x150>
      for(i = 0; i < N; i++){
    443a:	34fd                	addiw	s1,s1,-1
    443c:	f0f5                	bnez	s1,4420 <fourfiles+0x10c>
      exit(0);
    443e:	4501                	li	a0,0
    4440:	00001097          	auipc	ra,0x1
    4444:	0b2080e7          	jalr	178(ra) # 54f2 <exit>
        printf("create failed\n", s);
    4448:	85e6                	mv	a1,s9
    444a:	00003517          	auipc	a0,0x3
    444e:	48650513          	addi	a0,a0,1158 # 78d0 <malloc+0x1fa8>
    4452:	00001097          	auipc	ra,0x1
    4456:	418080e7          	jalr	1048(ra) # 586a <printf>
        exit(1);
    445a:	4505                	li	a0,1
    445c:	00001097          	auipc	ra,0x1
    4460:	096080e7          	jalr	150(ra) # 54f2 <exit>
          printf("write failed %d\n", n);
    4464:	00003517          	auipc	a0,0x3
    4468:	47c50513          	addi	a0,a0,1148 # 78e0 <malloc+0x1fb8>
    446c:	00001097          	auipc	ra,0x1
    4470:	3fe080e7          	jalr	1022(ra) # 586a <printf>
          exit(1);
    4474:	4505                	li	a0,1
    4476:	00001097          	auipc	ra,0x1
    447a:	07c080e7          	jalr	124(ra) # 54f2 <exit>
      exit(xstatus);
    447e:	00001097          	auipc	ra,0x1
    4482:	074080e7          	jalr	116(ra) # 54f2 <exit>
          printf("wrong char\n", s);
    4486:	85e6                	mv	a1,s9
    4488:	00003517          	auipc	a0,0x3
    448c:	47050513          	addi	a0,a0,1136 # 78f8 <malloc+0x1fd0>
    4490:	00001097          	auipc	ra,0x1
    4494:	3da080e7          	jalr	986(ra) # 586a <printf>
          exit(1);
    4498:	4505                	li	a0,1
    449a:	00001097          	auipc	ra,0x1
    449e:	058080e7          	jalr	88(ra) # 54f2 <exit>
      total += n;
    44a2:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    44a6:	660d                	lui	a2,0x3
    44a8:	85d2                	mv	a1,s4
    44aa:	854e                	mv	a0,s3
    44ac:	00001097          	auipc	ra,0x1
    44b0:	05e080e7          	jalr	94(ra) # 550a <read>
    44b4:	02a05363          	blez	a0,44da <fourfiles+0x1c6>
    44b8:	00007797          	auipc	a5,0x7
    44bc:	4b878793          	addi	a5,a5,1208 # b970 <buf>
    44c0:	fff5069b          	addiw	a3,a0,-1
    44c4:	1682                	slli	a3,a3,0x20
    44c6:	9281                	srli	a3,a3,0x20
    44c8:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    44ca:	0007c703          	lbu	a4,0(a5)
    44ce:	fa971ce3          	bne	a4,s1,4486 <fourfiles+0x172>
      for(j = 0; j < n; j++){
    44d2:	0785                	addi	a5,a5,1
    44d4:	fed79be3          	bne	a5,a3,44ca <fourfiles+0x1b6>
    44d8:	b7e9                	j	44a2 <fourfiles+0x18e>
    close(fd);
    44da:	854e                	mv	a0,s3
    44dc:	00001097          	auipc	ra,0x1
    44e0:	03e080e7          	jalr	62(ra) # 551a <close>
    if(total != N*SZ){
    44e4:	03a91963          	bne	s2,s10,4516 <fourfiles+0x202>
    unlink(fname);
    44e8:	8562                	mv	a0,s8
    44ea:	00001097          	auipc	ra,0x1
    44ee:	058080e7          	jalr	88(ra) # 5542 <unlink>
  for(i = 0; i < NCHILD; i++){
    44f2:	0ba1                	addi	s7,s7,8
    44f4:	2b05                	addiw	s6,s6,1
    44f6:	03bb0e63          	beq	s6,s11,4532 <fourfiles+0x21e>
    fname = names[i];
    44fa:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    44fe:	4581                	li	a1,0
    4500:	8562                	mv	a0,s8
    4502:	00001097          	auipc	ra,0x1
    4506:	030080e7          	jalr	48(ra) # 5532 <open>
    450a:	89aa                	mv	s3,a0
    total = 0;
    450c:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    4510:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4514:	bf49                	j	44a6 <fourfiles+0x192>
      printf("wrong length %d\n", total);
    4516:	85ca                	mv	a1,s2
    4518:	00003517          	auipc	a0,0x3
    451c:	3f050513          	addi	a0,a0,1008 # 7908 <malloc+0x1fe0>
    4520:	00001097          	auipc	ra,0x1
    4524:	34a080e7          	jalr	842(ra) # 586a <printf>
      exit(1);
    4528:	4505                	li	a0,1
    452a:	00001097          	auipc	ra,0x1
    452e:	fc8080e7          	jalr	-56(ra) # 54f2 <exit>
}
    4532:	70aa                	ld	ra,168(sp)
    4534:	740a                	ld	s0,160(sp)
    4536:	64ea                	ld	s1,152(sp)
    4538:	694a                	ld	s2,144(sp)
    453a:	69aa                	ld	s3,136(sp)
    453c:	6a0a                	ld	s4,128(sp)
    453e:	7ae6                	ld	s5,120(sp)
    4540:	7b46                	ld	s6,112(sp)
    4542:	7ba6                	ld	s7,104(sp)
    4544:	7c06                	ld	s8,96(sp)
    4546:	6ce6                	ld	s9,88(sp)
    4548:	6d46                	ld	s10,80(sp)
    454a:	6da6                	ld	s11,72(sp)
    454c:	614d                	addi	sp,sp,176
    454e:	8082                	ret

0000000000004550 <concreate>:
{
    4550:	7135                	addi	sp,sp,-160
    4552:	ed06                	sd	ra,152(sp)
    4554:	e922                	sd	s0,144(sp)
    4556:	e526                	sd	s1,136(sp)
    4558:	e14a                	sd	s2,128(sp)
    455a:	fcce                	sd	s3,120(sp)
    455c:	f8d2                	sd	s4,112(sp)
    455e:	f4d6                	sd	s5,104(sp)
    4560:	f0da                	sd	s6,96(sp)
    4562:	ecde                	sd	s7,88(sp)
    4564:	1100                	addi	s0,sp,160
    4566:	89aa                	mv	s3,a0
  file[0] = 'C';
    4568:	04300793          	li	a5,67
    456c:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4570:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4574:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4576:	4b0d                	li	s6,3
    4578:	4a85                	li	s5,1
      link("C0", file);
    457a:	00003b97          	auipc	s7,0x3
    457e:	3a6b8b93          	addi	s7,s7,934 # 7920 <malloc+0x1ff8>
  for(i = 0; i < N; i++){
    4582:	02800a13          	li	s4,40
    4586:	acc1                	j	4856 <concreate+0x306>
      link("C0", file);
    4588:	fa840593          	addi	a1,s0,-88
    458c:	855e                	mv	a0,s7
    458e:	00001097          	auipc	ra,0x1
    4592:	fc4080e7          	jalr	-60(ra) # 5552 <link>
    if(pid == 0) {
    4596:	a45d                	j	483c <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4598:	4795                	li	a5,5
    459a:	02f9693b          	remw	s2,s2,a5
    459e:	4785                	li	a5,1
    45a0:	02f90b63          	beq	s2,a5,45d6 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    45a4:	20200593          	li	a1,514
    45a8:	fa840513          	addi	a0,s0,-88
    45ac:	00001097          	auipc	ra,0x1
    45b0:	f86080e7          	jalr	-122(ra) # 5532 <open>
      if(fd < 0){
    45b4:	26055b63          	bgez	a0,482a <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    45b8:	fa840593          	addi	a1,s0,-88
    45bc:	00003517          	auipc	a0,0x3
    45c0:	36c50513          	addi	a0,a0,876 # 7928 <malloc+0x2000>
    45c4:	00001097          	auipc	ra,0x1
    45c8:	2a6080e7          	jalr	678(ra) # 586a <printf>
        exit(1);
    45cc:	4505                	li	a0,1
    45ce:	00001097          	auipc	ra,0x1
    45d2:	f24080e7          	jalr	-220(ra) # 54f2 <exit>
      link("C0", file);
    45d6:	fa840593          	addi	a1,s0,-88
    45da:	00003517          	auipc	a0,0x3
    45de:	34650513          	addi	a0,a0,838 # 7920 <malloc+0x1ff8>
    45e2:	00001097          	auipc	ra,0x1
    45e6:	f70080e7          	jalr	-144(ra) # 5552 <link>
      exit(0);
    45ea:	4501                	li	a0,0
    45ec:	00001097          	auipc	ra,0x1
    45f0:	f06080e7          	jalr	-250(ra) # 54f2 <exit>
        exit(1);
    45f4:	4505                	li	a0,1
    45f6:	00001097          	auipc	ra,0x1
    45fa:	efc080e7          	jalr	-260(ra) # 54f2 <exit>
  memset(fa, 0, sizeof(fa));
    45fe:	02800613          	li	a2,40
    4602:	4581                	li	a1,0
    4604:	f8040513          	addi	a0,s0,-128
    4608:	00001097          	auipc	ra,0x1
    460c:	ce6080e7          	jalr	-794(ra) # 52ee <memset>
  fd = open(".", 0);
    4610:	4581                	li	a1,0
    4612:	00002517          	auipc	a0,0x2
    4616:	dd650513          	addi	a0,a0,-554 # 63e8 <malloc+0xac0>
    461a:	00001097          	auipc	ra,0x1
    461e:	f18080e7          	jalr	-232(ra) # 5532 <open>
    4622:	892a                	mv	s2,a0
  n = 0;
    4624:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4626:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    462a:	02700b13          	li	s6,39
      fa[i] = 1;
    462e:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4630:	a03d                	j	465e <concreate+0x10e>
        printf("%s: concreate weird file %s\n", s, de.name);
    4632:	f7240613          	addi	a2,s0,-142
    4636:	85ce                	mv	a1,s3
    4638:	00003517          	auipc	a0,0x3
    463c:	31050513          	addi	a0,a0,784 # 7948 <malloc+0x2020>
    4640:	00001097          	auipc	ra,0x1
    4644:	22a080e7          	jalr	554(ra) # 586a <printf>
        exit(1);
    4648:	4505                	li	a0,1
    464a:	00001097          	auipc	ra,0x1
    464e:	ea8080e7          	jalr	-344(ra) # 54f2 <exit>
      fa[i] = 1;
    4652:	fb040793          	addi	a5,s0,-80
    4656:	973e                	add	a4,a4,a5
    4658:	fd770823          	sb	s7,-48(a4)
      n++;
    465c:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    465e:	4641                	li	a2,16
    4660:	f7040593          	addi	a1,s0,-144
    4664:	854a                	mv	a0,s2
    4666:	00001097          	auipc	ra,0x1
    466a:	ea4080e7          	jalr	-348(ra) # 550a <read>
    466e:	04a05a63          	blez	a0,46c2 <concreate+0x172>
    if(de.inum == 0)
    4672:	f7045783          	lhu	a5,-144(s0)
    4676:	d7e5                	beqz	a5,465e <concreate+0x10e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4678:	f7244783          	lbu	a5,-142(s0)
    467c:	ff4791e3          	bne	a5,s4,465e <concreate+0x10e>
    4680:	f7444783          	lbu	a5,-140(s0)
    4684:	ffe9                	bnez	a5,465e <concreate+0x10e>
      i = de.name[1] - '0';
    4686:	f7344783          	lbu	a5,-141(s0)
    468a:	fd07879b          	addiw	a5,a5,-48
    468e:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4692:	faeb60e3          	bltu	s6,a4,4632 <concreate+0xe2>
      if(fa[i]){
    4696:	fb040793          	addi	a5,s0,-80
    469a:	97ba                	add	a5,a5,a4
    469c:	fd07c783          	lbu	a5,-48(a5)
    46a0:	dbcd                	beqz	a5,4652 <concreate+0x102>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    46a2:	f7240613          	addi	a2,s0,-142
    46a6:	85ce                	mv	a1,s3
    46a8:	00003517          	auipc	a0,0x3
    46ac:	2c050513          	addi	a0,a0,704 # 7968 <malloc+0x2040>
    46b0:	00001097          	auipc	ra,0x1
    46b4:	1ba080e7          	jalr	442(ra) # 586a <printf>
        exit(1);
    46b8:	4505                	li	a0,1
    46ba:	00001097          	auipc	ra,0x1
    46be:	e38080e7          	jalr	-456(ra) # 54f2 <exit>
  close(fd);
    46c2:	854a                	mv	a0,s2
    46c4:	00001097          	auipc	ra,0x1
    46c8:	e56080e7          	jalr	-426(ra) # 551a <close>
  if(n != N){
    46cc:	02800793          	li	a5,40
    46d0:	00fa9763          	bne	s5,a5,46de <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    46d4:	4a8d                	li	s5,3
    46d6:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    46d8:	02800a13          	li	s4,40
    46dc:	a8c9                	j	47ae <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    46de:	85ce                	mv	a1,s3
    46e0:	00003517          	auipc	a0,0x3
    46e4:	2b050513          	addi	a0,a0,688 # 7990 <malloc+0x2068>
    46e8:	00001097          	auipc	ra,0x1
    46ec:	182080e7          	jalr	386(ra) # 586a <printf>
    exit(1);
    46f0:	4505                	li	a0,1
    46f2:	00001097          	auipc	ra,0x1
    46f6:	e00080e7          	jalr	-512(ra) # 54f2 <exit>
      printf("%s: fork failed\n", s);
    46fa:	85ce                	mv	a1,s3
    46fc:	00002517          	auipc	a0,0x2
    4700:	e8c50513          	addi	a0,a0,-372 # 6588 <malloc+0xc60>
    4704:	00001097          	auipc	ra,0x1
    4708:	166080e7          	jalr	358(ra) # 586a <printf>
      exit(1);
    470c:	4505                	li	a0,1
    470e:	00001097          	auipc	ra,0x1
    4712:	de4080e7          	jalr	-540(ra) # 54f2 <exit>
      close(open(file, 0));
    4716:	4581                	li	a1,0
    4718:	fa840513          	addi	a0,s0,-88
    471c:	00001097          	auipc	ra,0x1
    4720:	e16080e7          	jalr	-490(ra) # 5532 <open>
    4724:	00001097          	auipc	ra,0x1
    4728:	df6080e7          	jalr	-522(ra) # 551a <close>
      close(open(file, 0));
    472c:	4581                	li	a1,0
    472e:	fa840513          	addi	a0,s0,-88
    4732:	00001097          	auipc	ra,0x1
    4736:	e00080e7          	jalr	-512(ra) # 5532 <open>
    473a:	00001097          	auipc	ra,0x1
    473e:	de0080e7          	jalr	-544(ra) # 551a <close>
      close(open(file, 0));
    4742:	4581                	li	a1,0
    4744:	fa840513          	addi	a0,s0,-88
    4748:	00001097          	auipc	ra,0x1
    474c:	dea080e7          	jalr	-534(ra) # 5532 <open>
    4750:	00001097          	auipc	ra,0x1
    4754:	dca080e7          	jalr	-566(ra) # 551a <close>
      close(open(file, 0));
    4758:	4581                	li	a1,0
    475a:	fa840513          	addi	a0,s0,-88
    475e:	00001097          	auipc	ra,0x1
    4762:	dd4080e7          	jalr	-556(ra) # 5532 <open>
    4766:	00001097          	auipc	ra,0x1
    476a:	db4080e7          	jalr	-588(ra) # 551a <close>
      close(open(file, 0));
    476e:	4581                	li	a1,0
    4770:	fa840513          	addi	a0,s0,-88
    4774:	00001097          	auipc	ra,0x1
    4778:	dbe080e7          	jalr	-578(ra) # 5532 <open>
    477c:	00001097          	auipc	ra,0x1
    4780:	d9e080e7          	jalr	-610(ra) # 551a <close>
      close(open(file, 0));
    4784:	4581                	li	a1,0
    4786:	fa840513          	addi	a0,s0,-88
    478a:	00001097          	auipc	ra,0x1
    478e:	da8080e7          	jalr	-600(ra) # 5532 <open>
    4792:	00001097          	auipc	ra,0x1
    4796:	d88080e7          	jalr	-632(ra) # 551a <close>
    if(pid == 0)
    479a:	08090363          	beqz	s2,4820 <concreate+0x2d0>
      wait(0);
    479e:	4501                	li	a0,0
    47a0:	00001097          	auipc	ra,0x1
    47a4:	d5a080e7          	jalr	-678(ra) # 54fa <wait>
  for(i = 0; i < N; i++){
    47a8:	2485                	addiw	s1,s1,1
    47aa:	0f448563          	beq	s1,s4,4894 <concreate+0x344>
    file[1] = '0' + i;
    47ae:	0304879b          	addiw	a5,s1,48
    47b2:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    47b6:	00001097          	auipc	ra,0x1
    47ba:	d34080e7          	jalr	-716(ra) # 54ea <fork>
    47be:	892a                	mv	s2,a0
    if(pid < 0){
    47c0:	f2054de3          	bltz	a0,46fa <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    47c4:	0354e73b          	remw	a4,s1,s5
    47c8:	00a767b3          	or	a5,a4,a0
    47cc:	2781                	sext.w	a5,a5
    47ce:	d7a1                	beqz	a5,4716 <concreate+0x1c6>
    47d0:	01671363          	bne	a4,s6,47d6 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    47d4:	f129                	bnez	a0,4716 <concreate+0x1c6>
      unlink(file);
    47d6:	fa840513          	addi	a0,s0,-88
    47da:	00001097          	auipc	ra,0x1
    47de:	d68080e7          	jalr	-664(ra) # 5542 <unlink>
      unlink(file);
    47e2:	fa840513          	addi	a0,s0,-88
    47e6:	00001097          	auipc	ra,0x1
    47ea:	d5c080e7          	jalr	-676(ra) # 5542 <unlink>
      unlink(file);
    47ee:	fa840513          	addi	a0,s0,-88
    47f2:	00001097          	auipc	ra,0x1
    47f6:	d50080e7          	jalr	-688(ra) # 5542 <unlink>
      unlink(file);
    47fa:	fa840513          	addi	a0,s0,-88
    47fe:	00001097          	auipc	ra,0x1
    4802:	d44080e7          	jalr	-700(ra) # 5542 <unlink>
      unlink(file);
    4806:	fa840513          	addi	a0,s0,-88
    480a:	00001097          	auipc	ra,0x1
    480e:	d38080e7          	jalr	-712(ra) # 5542 <unlink>
      unlink(file);
    4812:	fa840513          	addi	a0,s0,-88
    4816:	00001097          	auipc	ra,0x1
    481a:	d2c080e7          	jalr	-724(ra) # 5542 <unlink>
    481e:	bfb5                	j	479a <concreate+0x24a>
      exit(0);
    4820:	4501                	li	a0,0
    4822:	00001097          	auipc	ra,0x1
    4826:	cd0080e7          	jalr	-816(ra) # 54f2 <exit>
      close(fd);
    482a:	00001097          	auipc	ra,0x1
    482e:	cf0080e7          	jalr	-784(ra) # 551a <close>
    if(pid == 0) {
    4832:	bb65                	j	45ea <concreate+0x9a>
      close(fd);
    4834:	00001097          	auipc	ra,0x1
    4838:	ce6080e7          	jalr	-794(ra) # 551a <close>
      wait(&xstatus);
    483c:	f6c40513          	addi	a0,s0,-148
    4840:	00001097          	auipc	ra,0x1
    4844:	cba080e7          	jalr	-838(ra) # 54fa <wait>
      if(xstatus != 0)
    4848:	f6c42483          	lw	s1,-148(s0)
    484c:	da0494e3          	bnez	s1,45f4 <concreate+0xa4>
  for(i = 0; i < N; i++){
    4850:	2905                	addiw	s2,s2,1
    4852:	db4906e3          	beq	s2,s4,45fe <concreate+0xae>
    file[1] = '0' + i;
    4856:	0309079b          	addiw	a5,s2,48
    485a:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    485e:	fa840513          	addi	a0,s0,-88
    4862:	00001097          	auipc	ra,0x1
    4866:	ce0080e7          	jalr	-800(ra) # 5542 <unlink>
    pid = fork();
    486a:	00001097          	auipc	ra,0x1
    486e:	c80080e7          	jalr	-896(ra) # 54ea <fork>
    if(pid && (i % 3) == 1){
    4872:	d20503e3          	beqz	a0,4598 <concreate+0x48>
    4876:	036967bb          	remw	a5,s2,s6
    487a:	d15787e3          	beq	a5,s5,4588 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    487e:	20200593          	li	a1,514
    4882:	fa840513          	addi	a0,s0,-88
    4886:	00001097          	auipc	ra,0x1
    488a:	cac080e7          	jalr	-852(ra) # 5532 <open>
      if(fd < 0){
    488e:	fa0553e3          	bgez	a0,4834 <concreate+0x2e4>
    4892:	b31d                	j	45b8 <concreate+0x68>
}
    4894:	60ea                	ld	ra,152(sp)
    4896:	644a                	ld	s0,144(sp)
    4898:	64aa                	ld	s1,136(sp)
    489a:	690a                	ld	s2,128(sp)
    489c:	79e6                	ld	s3,120(sp)
    489e:	7a46                	ld	s4,112(sp)
    48a0:	7aa6                	ld	s5,104(sp)
    48a2:	7b06                	ld	s6,96(sp)
    48a4:	6be6                	ld	s7,88(sp)
    48a6:	610d                	addi	sp,sp,160
    48a8:	8082                	ret

00000000000048aa <bigfile>:
{
    48aa:	7139                	addi	sp,sp,-64
    48ac:	fc06                	sd	ra,56(sp)
    48ae:	f822                	sd	s0,48(sp)
    48b0:	f426                	sd	s1,40(sp)
    48b2:	f04a                	sd	s2,32(sp)
    48b4:	ec4e                	sd	s3,24(sp)
    48b6:	e852                	sd	s4,16(sp)
    48b8:	e456                	sd	s5,8(sp)
    48ba:	0080                	addi	s0,sp,64
    48bc:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    48be:	00003517          	auipc	a0,0x3
    48c2:	10a50513          	addi	a0,a0,266 # 79c8 <malloc+0x20a0>
    48c6:	00001097          	auipc	ra,0x1
    48ca:	c7c080e7          	jalr	-900(ra) # 5542 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    48ce:	20200593          	li	a1,514
    48d2:	00003517          	auipc	a0,0x3
    48d6:	0f650513          	addi	a0,a0,246 # 79c8 <malloc+0x20a0>
    48da:	00001097          	auipc	ra,0x1
    48de:	c58080e7          	jalr	-936(ra) # 5532 <open>
    48e2:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    48e4:	4481                	li	s1,0
    memset(buf, i, SZ);
    48e6:	00007917          	auipc	s2,0x7
    48ea:	08a90913          	addi	s2,s2,138 # b970 <buf>
  for(i = 0; i < N; i++){
    48ee:	4a51                	li	s4,20
  if(fd < 0){
    48f0:	0a054063          	bltz	a0,4990 <bigfile+0xe6>
    memset(buf, i, SZ);
    48f4:	25800613          	li	a2,600
    48f8:	85a6                	mv	a1,s1
    48fa:	854a                	mv	a0,s2
    48fc:	00001097          	auipc	ra,0x1
    4900:	9f2080e7          	jalr	-1550(ra) # 52ee <memset>
    if(write(fd, buf, SZ) != SZ){
    4904:	25800613          	li	a2,600
    4908:	85ca                	mv	a1,s2
    490a:	854e                	mv	a0,s3
    490c:	00001097          	auipc	ra,0x1
    4910:	c06080e7          	jalr	-1018(ra) # 5512 <write>
    4914:	25800793          	li	a5,600
    4918:	08f51a63          	bne	a0,a5,49ac <bigfile+0x102>
  for(i = 0; i < N; i++){
    491c:	2485                	addiw	s1,s1,1
    491e:	fd449be3          	bne	s1,s4,48f4 <bigfile+0x4a>
  close(fd);
    4922:	854e                	mv	a0,s3
    4924:	00001097          	auipc	ra,0x1
    4928:	bf6080e7          	jalr	-1034(ra) # 551a <close>
  fd = open("bigfile.dat", 0);
    492c:	4581                	li	a1,0
    492e:	00003517          	auipc	a0,0x3
    4932:	09a50513          	addi	a0,a0,154 # 79c8 <malloc+0x20a0>
    4936:	00001097          	auipc	ra,0x1
    493a:	bfc080e7          	jalr	-1028(ra) # 5532 <open>
    493e:	8a2a                	mv	s4,a0
  total = 0;
    4940:	4981                	li	s3,0
  for(i = 0; ; i++){
    4942:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4944:	00007917          	auipc	s2,0x7
    4948:	02c90913          	addi	s2,s2,44 # b970 <buf>
  if(fd < 0){
    494c:	06054e63          	bltz	a0,49c8 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4950:	12c00613          	li	a2,300
    4954:	85ca                	mv	a1,s2
    4956:	8552                	mv	a0,s4
    4958:	00001097          	auipc	ra,0x1
    495c:	bb2080e7          	jalr	-1102(ra) # 550a <read>
    if(cc < 0){
    4960:	08054263          	bltz	a0,49e4 <bigfile+0x13a>
    if(cc == 0)
    4964:	c971                	beqz	a0,4a38 <bigfile+0x18e>
    if(cc != SZ/2){
    4966:	12c00793          	li	a5,300
    496a:	08f51b63          	bne	a0,a5,4a00 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    496e:	01f4d79b          	srliw	a5,s1,0x1f
    4972:	9fa5                	addw	a5,a5,s1
    4974:	4017d79b          	sraiw	a5,a5,0x1
    4978:	00094703          	lbu	a4,0(s2)
    497c:	0af71063          	bne	a4,a5,4a1c <bigfile+0x172>
    4980:	12b94703          	lbu	a4,299(s2)
    4984:	08f71c63          	bne	a4,a5,4a1c <bigfile+0x172>
    total += cc;
    4988:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    498c:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    498e:	b7c9                	j	4950 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4990:	85d6                	mv	a1,s5
    4992:	00003517          	auipc	a0,0x3
    4996:	04650513          	addi	a0,a0,70 # 79d8 <malloc+0x20b0>
    499a:	00001097          	auipc	ra,0x1
    499e:	ed0080e7          	jalr	-304(ra) # 586a <printf>
    exit(1);
    49a2:	4505                	li	a0,1
    49a4:	00001097          	auipc	ra,0x1
    49a8:	b4e080e7          	jalr	-1202(ra) # 54f2 <exit>
      printf("%s: write bigfile failed\n", s);
    49ac:	85d6                	mv	a1,s5
    49ae:	00003517          	auipc	a0,0x3
    49b2:	04a50513          	addi	a0,a0,74 # 79f8 <malloc+0x20d0>
    49b6:	00001097          	auipc	ra,0x1
    49ba:	eb4080e7          	jalr	-332(ra) # 586a <printf>
      exit(1);
    49be:	4505                	li	a0,1
    49c0:	00001097          	auipc	ra,0x1
    49c4:	b32080e7          	jalr	-1230(ra) # 54f2 <exit>
    printf("%s: cannot open bigfile\n", s);
    49c8:	85d6                	mv	a1,s5
    49ca:	00003517          	auipc	a0,0x3
    49ce:	04e50513          	addi	a0,a0,78 # 7a18 <malloc+0x20f0>
    49d2:	00001097          	auipc	ra,0x1
    49d6:	e98080e7          	jalr	-360(ra) # 586a <printf>
    exit(1);
    49da:	4505                	li	a0,1
    49dc:	00001097          	auipc	ra,0x1
    49e0:	b16080e7          	jalr	-1258(ra) # 54f2 <exit>
      printf("%s: read bigfile failed\n", s);
    49e4:	85d6                	mv	a1,s5
    49e6:	00003517          	auipc	a0,0x3
    49ea:	05250513          	addi	a0,a0,82 # 7a38 <malloc+0x2110>
    49ee:	00001097          	auipc	ra,0x1
    49f2:	e7c080e7          	jalr	-388(ra) # 586a <printf>
      exit(1);
    49f6:	4505                	li	a0,1
    49f8:	00001097          	auipc	ra,0x1
    49fc:	afa080e7          	jalr	-1286(ra) # 54f2 <exit>
      printf("%s: short read bigfile\n", s);
    4a00:	85d6                	mv	a1,s5
    4a02:	00003517          	auipc	a0,0x3
    4a06:	05650513          	addi	a0,a0,86 # 7a58 <malloc+0x2130>
    4a0a:	00001097          	auipc	ra,0x1
    4a0e:	e60080e7          	jalr	-416(ra) # 586a <printf>
      exit(1);
    4a12:	4505                	li	a0,1
    4a14:	00001097          	auipc	ra,0x1
    4a18:	ade080e7          	jalr	-1314(ra) # 54f2 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4a1c:	85d6                	mv	a1,s5
    4a1e:	00003517          	auipc	a0,0x3
    4a22:	05250513          	addi	a0,a0,82 # 7a70 <malloc+0x2148>
    4a26:	00001097          	auipc	ra,0x1
    4a2a:	e44080e7          	jalr	-444(ra) # 586a <printf>
      exit(1);
    4a2e:	4505                	li	a0,1
    4a30:	00001097          	auipc	ra,0x1
    4a34:	ac2080e7          	jalr	-1342(ra) # 54f2 <exit>
  close(fd);
    4a38:	8552                	mv	a0,s4
    4a3a:	00001097          	auipc	ra,0x1
    4a3e:	ae0080e7          	jalr	-1312(ra) # 551a <close>
  if(total != N*SZ){
    4a42:	678d                	lui	a5,0x3
    4a44:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0xaa>
    4a48:	02f99363          	bne	s3,a5,4a6e <bigfile+0x1c4>
  unlink("bigfile.dat");
    4a4c:	00003517          	auipc	a0,0x3
    4a50:	f7c50513          	addi	a0,a0,-132 # 79c8 <malloc+0x20a0>
    4a54:	00001097          	auipc	ra,0x1
    4a58:	aee080e7          	jalr	-1298(ra) # 5542 <unlink>
}
    4a5c:	70e2                	ld	ra,56(sp)
    4a5e:	7442                	ld	s0,48(sp)
    4a60:	74a2                	ld	s1,40(sp)
    4a62:	7902                	ld	s2,32(sp)
    4a64:	69e2                	ld	s3,24(sp)
    4a66:	6a42                	ld	s4,16(sp)
    4a68:	6aa2                	ld	s5,8(sp)
    4a6a:	6121                	addi	sp,sp,64
    4a6c:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4a6e:	85d6                	mv	a1,s5
    4a70:	00003517          	auipc	a0,0x3
    4a74:	02050513          	addi	a0,a0,32 # 7a90 <malloc+0x2168>
    4a78:	00001097          	auipc	ra,0x1
    4a7c:	df2080e7          	jalr	-526(ra) # 586a <printf>
    exit(1);
    4a80:	4505                	li	a0,1
    4a82:	00001097          	auipc	ra,0x1
    4a86:	a70080e7          	jalr	-1424(ra) # 54f2 <exit>

0000000000004a8a <dirtest>:
{
    4a8a:	1101                	addi	sp,sp,-32
    4a8c:	ec06                	sd	ra,24(sp)
    4a8e:	e822                	sd	s0,16(sp)
    4a90:	e426                	sd	s1,8(sp)
    4a92:	1000                	addi	s0,sp,32
    4a94:	84aa                	mv	s1,a0
  printf("mkdir test\n");
    4a96:	00003517          	auipc	a0,0x3
    4a9a:	01a50513          	addi	a0,a0,26 # 7ab0 <malloc+0x2188>
    4a9e:	00001097          	auipc	ra,0x1
    4aa2:	dcc080e7          	jalr	-564(ra) # 586a <printf>
  if(mkdir("dir0") < 0){
    4aa6:	00003517          	auipc	a0,0x3
    4aaa:	01a50513          	addi	a0,a0,26 # 7ac0 <malloc+0x2198>
    4aae:	00001097          	auipc	ra,0x1
    4ab2:	aac080e7          	jalr	-1364(ra) # 555a <mkdir>
    4ab6:	04054d63          	bltz	a0,4b10 <dirtest+0x86>
  if(chdir("dir0") < 0){
    4aba:	00003517          	auipc	a0,0x3
    4abe:	00650513          	addi	a0,a0,6 # 7ac0 <malloc+0x2198>
    4ac2:	00001097          	auipc	ra,0x1
    4ac6:	aa0080e7          	jalr	-1376(ra) # 5562 <chdir>
    4aca:	06054163          	bltz	a0,4b2c <dirtest+0xa2>
  if(chdir("..") < 0){
    4ace:	00003517          	auipc	a0,0x3
    4ad2:	a4a50513          	addi	a0,a0,-1462 # 7518 <malloc+0x1bf0>
    4ad6:	00001097          	auipc	ra,0x1
    4ada:	a8c080e7          	jalr	-1396(ra) # 5562 <chdir>
    4ade:	06054563          	bltz	a0,4b48 <dirtest+0xbe>
  if(unlink("dir0") < 0){
    4ae2:	00003517          	auipc	a0,0x3
    4ae6:	fde50513          	addi	a0,a0,-34 # 7ac0 <malloc+0x2198>
    4aea:	00001097          	auipc	ra,0x1
    4aee:	a58080e7          	jalr	-1448(ra) # 5542 <unlink>
    4af2:	06054963          	bltz	a0,4b64 <dirtest+0xda>
  printf("%s: mkdir test ok\n");
    4af6:	00003517          	auipc	a0,0x3
    4afa:	01a50513          	addi	a0,a0,26 # 7b10 <malloc+0x21e8>
    4afe:	00001097          	auipc	ra,0x1
    4b02:	d6c080e7          	jalr	-660(ra) # 586a <printf>
}
    4b06:	60e2                	ld	ra,24(sp)
    4b08:	6442                	ld	s0,16(sp)
    4b0a:	64a2                	ld	s1,8(sp)
    4b0c:	6105                	addi	sp,sp,32
    4b0e:	8082                	ret
    printf("%s: mkdir failed\n", s);
    4b10:	85a6                	mv	a1,s1
    4b12:	00002517          	auipc	a0,0x2
    4b16:	3a650513          	addi	a0,a0,934 # 6eb8 <malloc+0x1590>
    4b1a:	00001097          	auipc	ra,0x1
    4b1e:	d50080e7          	jalr	-688(ra) # 586a <printf>
    exit(1);
    4b22:	4505                	li	a0,1
    4b24:	00001097          	auipc	ra,0x1
    4b28:	9ce080e7          	jalr	-1586(ra) # 54f2 <exit>
    printf("%s: chdir dir0 failed\n", s);
    4b2c:	85a6                	mv	a1,s1
    4b2e:	00003517          	auipc	a0,0x3
    4b32:	f9a50513          	addi	a0,a0,-102 # 7ac8 <malloc+0x21a0>
    4b36:	00001097          	auipc	ra,0x1
    4b3a:	d34080e7          	jalr	-716(ra) # 586a <printf>
    exit(1);
    4b3e:	4505                	li	a0,1
    4b40:	00001097          	auipc	ra,0x1
    4b44:	9b2080e7          	jalr	-1614(ra) # 54f2 <exit>
    printf("%s: chdir .. failed\n", s);
    4b48:	85a6                	mv	a1,s1
    4b4a:	00003517          	auipc	a0,0x3
    4b4e:	f9650513          	addi	a0,a0,-106 # 7ae0 <malloc+0x21b8>
    4b52:	00001097          	auipc	ra,0x1
    4b56:	d18080e7          	jalr	-744(ra) # 586a <printf>
    exit(1);
    4b5a:	4505                	li	a0,1
    4b5c:	00001097          	auipc	ra,0x1
    4b60:	996080e7          	jalr	-1642(ra) # 54f2 <exit>
    printf("%s: unlink dir0 failed\n", s);
    4b64:	85a6                	mv	a1,s1
    4b66:	00003517          	auipc	a0,0x3
    4b6a:	f9250513          	addi	a0,a0,-110 # 7af8 <malloc+0x21d0>
    4b6e:	00001097          	auipc	ra,0x1
    4b72:	cfc080e7          	jalr	-772(ra) # 586a <printf>
    exit(1);
    4b76:	4505                	li	a0,1
    4b78:	00001097          	auipc	ra,0x1
    4b7c:	97a080e7          	jalr	-1670(ra) # 54f2 <exit>

0000000000004b80 <fsfull>:
{
    4b80:	7171                	addi	sp,sp,-176
    4b82:	f506                	sd	ra,168(sp)
    4b84:	f122                	sd	s0,160(sp)
    4b86:	ed26                	sd	s1,152(sp)
    4b88:	e94a                	sd	s2,144(sp)
    4b8a:	e54e                	sd	s3,136(sp)
    4b8c:	e152                	sd	s4,128(sp)
    4b8e:	fcd6                	sd	s5,120(sp)
    4b90:	f8da                	sd	s6,112(sp)
    4b92:	f4de                	sd	s7,104(sp)
    4b94:	f0e2                	sd	s8,96(sp)
    4b96:	ece6                	sd	s9,88(sp)
    4b98:	e8ea                	sd	s10,80(sp)
    4b9a:	e4ee                	sd	s11,72(sp)
    4b9c:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4b9e:	00003517          	auipc	a0,0x3
    4ba2:	f8a50513          	addi	a0,a0,-118 # 7b28 <malloc+0x2200>
    4ba6:	00001097          	auipc	ra,0x1
    4baa:	cc4080e7          	jalr	-828(ra) # 586a <printf>
  for(nfiles = 0; ; nfiles++){
    4bae:	4481                	li	s1,0
    name[0] = 'f';
    4bb0:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4bb4:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4bb8:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4bbc:	4b29                	li	s6,10
    printf("%s: writing %s\n", name);
    4bbe:	00003c97          	auipc	s9,0x3
    4bc2:	f7ac8c93          	addi	s9,s9,-134 # 7b38 <malloc+0x2210>
    int total = 0;
    4bc6:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4bc8:	00007a17          	auipc	s4,0x7
    4bcc:	da8a0a13          	addi	s4,s4,-600 # b970 <buf>
    name[0] = 'f';
    4bd0:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4bd4:	0384c7bb          	divw	a5,s1,s8
    4bd8:	0307879b          	addiw	a5,a5,48
    4bdc:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4be0:	0384e7bb          	remw	a5,s1,s8
    4be4:	0377c7bb          	divw	a5,a5,s7
    4be8:	0307879b          	addiw	a5,a5,48
    4bec:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4bf0:	0374e7bb          	remw	a5,s1,s7
    4bf4:	0367c7bb          	divw	a5,a5,s6
    4bf8:	0307879b          	addiw	a5,a5,48
    4bfc:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4c00:	0364e7bb          	remw	a5,s1,s6
    4c04:	0307879b          	addiw	a5,a5,48
    4c08:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4c0c:	f4040aa3          	sb	zero,-171(s0)
    printf("%s: writing %s\n", name);
    4c10:	f5040593          	addi	a1,s0,-176
    4c14:	8566                	mv	a0,s9
    4c16:	00001097          	auipc	ra,0x1
    4c1a:	c54080e7          	jalr	-940(ra) # 586a <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4c1e:	20200593          	li	a1,514
    4c22:	f5040513          	addi	a0,s0,-176
    4c26:	00001097          	auipc	ra,0x1
    4c2a:	90c080e7          	jalr	-1780(ra) # 5532 <open>
    4c2e:	892a                	mv	s2,a0
    if(fd < 0){
    4c30:	0a055663          	bgez	a0,4cdc <fsfull+0x15c>
      printf("%s: open %s failed\n", name);
    4c34:	f5040593          	addi	a1,s0,-176
    4c38:	00003517          	auipc	a0,0x3
    4c3c:	f1050513          	addi	a0,a0,-240 # 7b48 <malloc+0x2220>
    4c40:	00001097          	auipc	ra,0x1
    4c44:	c2a080e7          	jalr	-982(ra) # 586a <printf>
  while(nfiles >= 0){
    4c48:	0604c363          	bltz	s1,4cae <fsfull+0x12e>
    name[0] = 'f';
    4c4c:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4c50:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4c54:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4c58:	4929                	li	s2,10
  while(nfiles >= 0){
    4c5a:	5afd                	li	s5,-1
    name[0] = 'f';
    4c5c:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4c60:	0344c7bb          	divw	a5,s1,s4
    4c64:	0307879b          	addiw	a5,a5,48
    4c68:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4c6c:	0344e7bb          	remw	a5,s1,s4
    4c70:	0337c7bb          	divw	a5,a5,s3
    4c74:	0307879b          	addiw	a5,a5,48
    4c78:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4c7c:	0334e7bb          	remw	a5,s1,s3
    4c80:	0327c7bb          	divw	a5,a5,s2
    4c84:	0307879b          	addiw	a5,a5,48
    4c88:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4c8c:	0324e7bb          	remw	a5,s1,s2
    4c90:	0307879b          	addiw	a5,a5,48
    4c94:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4c98:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4c9c:	f5040513          	addi	a0,s0,-176
    4ca0:	00001097          	auipc	ra,0x1
    4ca4:	8a2080e7          	jalr	-1886(ra) # 5542 <unlink>
    nfiles--;
    4ca8:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4caa:	fb5499e3          	bne	s1,s5,4c5c <fsfull+0xdc>
  printf("fsfull test finished\n");
    4cae:	00003517          	auipc	a0,0x3
    4cb2:	eca50513          	addi	a0,a0,-310 # 7b78 <malloc+0x2250>
    4cb6:	00001097          	auipc	ra,0x1
    4cba:	bb4080e7          	jalr	-1100(ra) # 586a <printf>
}
    4cbe:	70aa                	ld	ra,168(sp)
    4cc0:	740a                	ld	s0,160(sp)
    4cc2:	64ea                	ld	s1,152(sp)
    4cc4:	694a                	ld	s2,144(sp)
    4cc6:	69aa                	ld	s3,136(sp)
    4cc8:	6a0a                	ld	s4,128(sp)
    4cca:	7ae6                	ld	s5,120(sp)
    4ccc:	7b46                	ld	s6,112(sp)
    4cce:	7ba6                	ld	s7,104(sp)
    4cd0:	7c06                	ld	s8,96(sp)
    4cd2:	6ce6                	ld	s9,88(sp)
    4cd4:	6d46                	ld	s10,80(sp)
    4cd6:	6da6                	ld	s11,72(sp)
    4cd8:	614d                	addi	sp,sp,176
    4cda:	8082                	ret
    int total = 0;
    4cdc:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4cde:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4ce2:	40000613          	li	a2,1024
    4ce6:	85d2                	mv	a1,s4
    4ce8:	854a                	mv	a0,s2
    4cea:	00001097          	auipc	ra,0x1
    4cee:	828080e7          	jalr	-2008(ra) # 5512 <write>
      if(cc < BSIZE)
    4cf2:	00aad563          	bge	s5,a0,4cfc <fsfull+0x17c>
      total += cc;
    4cf6:	00a989bb          	addw	s3,s3,a0
    while(1){
    4cfa:	b7e5                	j	4ce2 <fsfull+0x162>
    printf("%s: wrote %d bytes\n", total);
    4cfc:	85ce                	mv	a1,s3
    4cfe:	00003517          	auipc	a0,0x3
    4d02:	e6250513          	addi	a0,a0,-414 # 7b60 <malloc+0x2238>
    4d06:	00001097          	auipc	ra,0x1
    4d0a:	b64080e7          	jalr	-1180(ra) # 586a <printf>
    close(fd);
    4d0e:	854a                	mv	a0,s2
    4d10:	00001097          	auipc	ra,0x1
    4d14:	80a080e7          	jalr	-2038(ra) # 551a <close>
    if(total == 0)
    4d18:	f20988e3          	beqz	s3,4c48 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4d1c:	2485                	addiw	s1,s1,1
    4d1e:	bd4d                	j	4bd0 <fsfull+0x50>

0000000000004d20 <rand>:
{
    4d20:	1141                	addi	sp,sp,-16
    4d22:	e422                	sd	s0,8(sp)
    4d24:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4d26:	00003717          	auipc	a4,0x3
    4d2a:	41a70713          	addi	a4,a4,1050 # 8140 <randstate>
    4d2e:	6308                	ld	a0,0(a4)
    4d30:	001967b7          	lui	a5,0x196
    4d34:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x187c8d>
    4d38:	02f50533          	mul	a0,a0,a5
    4d3c:	3c6ef7b7          	lui	a5,0x3c6ef
    4d40:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e09df>
    4d44:	953e                	add	a0,a0,a5
    4d46:	e308                	sd	a0,0(a4)
}
    4d48:	2501                	sext.w	a0,a0
    4d4a:	6422                	ld	s0,8(sp)
    4d4c:	0141                	addi	sp,sp,16
    4d4e:	8082                	ret

0000000000004d50 <badwrite>:
{
    4d50:	7179                	addi	sp,sp,-48
    4d52:	f406                	sd	ra,40(sp)
    4d54:	f022                	sd	s0,32(sp)
    4d56:	ec26                	sd	s1,24(sp)
    4d58:	e84a                	sd	s2,16(sp)
    4d5a:	e44e                	sd	s3,8(sp)
    4d5c:	e052                	sd	s4,0(sp)
    4d5e:	1800                	addi	s0,sp,48
  unlink("junk");
    4d60:	00003517          	auipc	a0,0x3
    4d64:	e3050513          	addi	a0,a0,-464 # 7b90 <malloc+0x2268>
    4d68:	00000097          	auipc	ra,0x0
    4d6c:	7da080e7          	jalr	2010(ra) # 5542 <unlink>
    4d70:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4d74:	00003997          	auipc	s3,0x3
    4d78:	e1c98993          	addi	s3,s3,-484 # 7b90 <malloc+0x2268>
    write(fd, (char*)0xffffffffffL, 1);
    4d7c:	5a7d                	li	s4,-1
    4d7e:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4d82:	20100593          	li	a1,513
    4d86:	854e                	mv	a0,s3
    4d88:	00000097          	auipc	ra,0x0
    4d8c:	7aa080e7          	jalr	1962(ra) # 5532 <open>
    4d90:	84aa                	mv	s1,a0
    if(fd < 0){
    4d92:	06054b63          	bltz	a0,4e08 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4d96:	4605                	li	a2,1
    4d98:	85d2                	mv	a1,s4
    4d9a:	00000097          	auipc	ra,0x0
    4d9e:	778080e7          	jalr	1912(ra) # 5512 <write>
    close(fd);
    4da2:	8526                	mv	a0,s1
    4da4:	00000097          	auipc	ra,0x0
    4da8:	776080e7          	jalr	1910(ra) # 551a <close>
    unlink("junk");
    4dac:	854e                	mv	a0,s3
    4dae:	00000097          	auipc	ra,0x0
    4db2:	794080e7          	jalr	1940(ra) # 5542 <unlink>
  for(int i = 0; i < assumed_free; i++){
    4db6:	397d                	addiw	s2,s2,-1
    4db8:	fc0915e3          	bnez	s2,4d82 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4dbc:	20100593          	li	a1,513
    4dc0:	00003517          	auipc	a0,0x3
    4dc4:	dd050513          	addi	a0,a0,-560 # 7b90 <malloc+0x2268>
    4dc8:	00000097          	auipc	ra,0x0
    4dcc:	76a080e7          	jalr	1898(ra) # 5532 <open>
    4dd0:	84aa                	mv	s1,a0
  if(fd < 0){
    4dd2:	04054863          	bltz	a0,4e22 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4dd6:	4605                	li	a2,1
    4dd8:	00001597          	auipc	a1,0x1
    4ddc:	fe858593          	addi	a1,a1,-24 # 5dc0 <malloc+0x498>
    4de0:	00000097          	auipc	ra,0x0
    4de4:	732080e7          	jalr	1842(ra) # 5512 <write>
    4de8:	4785                	li	a5,1
    4dea:	04f50963          	beq	a0,a5,4e3c <badwrite+0xec>
    printf("write failed\n");
    4dee:	00003517          	auipc	a0,0x3
    4df2:	dc250513          	addi	a0,a0,-574 # 7bb0 <malloc+0x2288>
    4df6:	00001097          	auipc	ra,0x1
    4dfa:	a74080e7          	jalr	-1420(ra) # 586a <printf>
    exit(1);
    4dfe:	4505                	li	a0,1
    4e00:	00000097          	auipc	ra,0x0
    4e04:	6f2080e7          	jalr	1778(ra) # 54f2 <exit>
      printf("open junk failed\n");
    4e08:	00003517          	auipc	a0,0x3
    4e0c:	d9050513          	addi	a0,a0,-624 # 7b98 <malloc+0x2270>
    4e10:	00001097          	auipc	ra,0x1
    4e14:	a5a080e7          	jalr	-1446(ra) # 586a <printf>
      exit(1);
    4e18:	4505                	li	a0,1
    4e1a:	00000097          	auipc	ra,0x0
    4e1e:	6d8080e7          	jalr	1752(ra) # 54f2 <exit>
    printf("open junk failed\n");
    4e22:	00003517          	auipc	a0,0x3
    4e26:	d7650513          	addi	a0,a0,-650 # 7b98 <malloc+0x2270>
    4e2a:	00001097          	auipc	ra,0x1
    4e2e:	a40080e7          	jalr	-1472(ra) # 586a <printf>
    exit(1);
    4e32:	4505                	li	a0,1
    4e34:	00000097          	auipc	ra,0x0
    4e38:	6be080e7          	jalr	1726(ra) # 54f2 <exit>
  close(fd);
    4e3c:	8526                	mv	a0,s1
    4e3e:	00000097          	auipc	ra,0x0
    4e42:	6dc080e7          	jalr	1756(ra) # 551a <close>
  unlink("junk");
    4e46:	00003517          	auipc	a0,0x3
    4e4a:	d4a50513          	addi	a0,a0,-694 # 7b90 <malloc+0x2268>
    4e4e:	00000097          	auipc	ra,0x0
    4e52:	6f4080e7          	jalr	1780(ra) # 5542 <unlink>
  exit(0);
    4e56:	4501                	li	a0,0
    4e58:	00000097          	auipc	ra,0x0
    4e5c:	69a080e7          	jalr	1690(ra) # 54f2 <exit>

0000000000004e60 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    4e60:	7139                	addi	sp,sp,-64
    4e62:	fc06                	sd	ra,56(sp)
    4e64:	f822                	sd	s0,48(sp)
    4e66:	f426                	sd	s1,40(sp)
    4e68:	f04a                	sd	s2,32(sp)
    4e6a:	ec4e                	sd	s3,24(sp)
    4e6c:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    4e6e:	fc840513          	addi	a0,s0,-56
    4e72:	00000097          	auipc	ra,0x0
    4e76:	690080e7          	jalr	1680(ra) # 5502 <pipe>
    4e7a:	06054863          	bltz	a0,4eea <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    4e7e:	00000097          	auipc	ra,0x0
    4e82:	66c080e7          	jalr	1644(ra) # 54ea <fork>

  if(pid < 0){
    4e86:	06054f63          	bltz	a0,4f04 <countfree+0xa4>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4e8a:	ed59                	bnez	a0,4f28 <countfree+0xc8>
    close(fds[0]);
    4e8c:	fc842503          	lw	a0,-56(s0)
    4e90:	00000097          	auipc	ra,0x0
    4e94:	68a080e7          	jalr	1674(ra) # 551a <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    4e98:	54fd                	li	s1,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4e9a:	4985                	li	s3,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    4e9c:	00001917          	auipc	s2,0x1
    4ea0:	f2490913          	addi	s2,s2,-220 # 5dc0 <malloc+0x498>
      uint64 a = (uint64) sbrk(4096);
    4ea4:	6505                	lui	a0,0x1
    4ea6:	00000097          	auipc	ra,0x0
    4eaa:	6d4080e7          	jalr	1748(ra) # 557a <sbrk>
      if(a == 0xffffffffffffffff){
    4eae:	06950863          	beq	a0,s1,4f1e <countfree+0xbe>
      *(char *)(a + 4096 - 1) = 1;
    4eb2:	6785                	lui	a5,0x1
    4eb4:	953e                	add	a0,a0,a5
    4eb6:	ff350fa3          	sb	s3,-1(a0) # fff <bigdir+0x95>
      if(write(fds[1], "x", 1) != 1){
    4eba:	4605                	li	a2,1
    4ebc:	85ca                	mv	a1,s2
    4ebe:	fcc42503          	lw	a0,-52(s0)
    4ec2:	00000097          	auipc	ra,0x0
    4ec6:	650080e7          	jalr	1616(ra) # 5512 <write>
    4eca:	4785                	li	a5,1
    4ecc:	fcf50ce3          	beq	a0,a5,4ea4 <countfree+0x44>
        printf("write() failed in countfree()\n");
    4ed0:	00003517          	auipc	a0,0x3
    4ed4:	d3050513          	addi	a0,a0,-720 # 7c00 <malloc+0x22d8>
    4ed8:	00001097          	auipc	ra,0x1
    4edc:	992080e7          	jalr	-1646(ra) # 586a <printf>
        exit(1);
    4ee0:	4505                	li	a0,1
    4ee2:	00000097          	auipc	ra,0x0
    4ee6:	610080e7          	jalr	1552(ra) # 54f2 <exit>
    printf("pipe() failed in countfree()\n");
    4eea:	00003517          	auipc	a0,0x3
    4eee:	cd650513          	addi	a0,a0,-810 # 7bc0 <malloc+0x2298>
    4ef2:	00001097          	auipc	ra,0x1
    4ef6:	978080e7          	jalr	-1672(ra) # 586a <printf>
    exit(1);
    4efa:	4505                	li	a0,1
    4efc:	00000097          	auipc	ra,0x0
    4f00:	5f6080e7          	jalr	1526(ra) # 54f2 <exit>
    printf("fork failed in countfree()\n");
    4f04:	00003517          	auipc	a0,0x3
    4f08:	cdc50513          	addi	a0,a0,-804 # 7be0 <malloc+0x22b8>
    4f0c:	00001097          	auipc	ra,0x1
    4f10:	95e080e7          	jalr	-1698(ra) # 586a <printf>
    exit(1);
    4f14:	4505                	li	a0,1
    4f16:	00000097          	auipc	ra,0x0
    4f1a:	5dc080e7          	jalr	1500(ra) # 54f2 <exit>
      }
    }

    exit(0);
    4f1e:	4501                	li	a0,0
    4f20:	00000097          	auipc	ra,0x0
    4f24:	5d2080e7          	jalr	1490(ra) # 54f2 <exit>
  }

  close(fds[1]);
    4f28:	fcc42503          	lw	a0,-52(s0)
    4f2c:	00000097          	auipc	ra,0x0
    4f30:	5ee080e7          	jalr	1518(ra) # 551a <close>

  int n = 0;
    4f34:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    4f36:	4605                	li	a2,1
    4f38:	fc740593          	addi	a1,s0,-57
    4f3c:	fc842503          	lw	a0,-56(s0)
    4f40:	00000097          	auipc	ra,0x0
    4f44:	5ca080e7          	jalr	1482(ra) # 550a <read>
    if(cc < 0){
    4f48:	00054563          	bltz	a0,4f52 <countfree+0xf2>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    4f4c:	c105                	beqz	a0,4f6c <countfree+0x10c>
      break;
    n += 1;
    4f4e:	2485                	addiw	s1,s1,1
  while(1){
    4f50:	b7dd                	j	4f36 <countfree+0xd6>
      printf("read() failed in countfree()\n");
    4f52:	00003517          	auipc	a0,0x3
    4f56:	cce50513          	addi	a0,a0,-818 # 7c20 <malloc+0x22f8>
    4f5a:	00001097          	auipc	ra,0x1
    4f5e:	910080e7          	jalr	-1776(ra) # 586a <printf>
      exit(1);
    4f62:	4505                	li	a0,1
    4f64:	00000097          	auipc	ra,0x0
    4f68:	58e080e7          	jalr	1422(ra) # 54f2 <exit>
  }

  close(fds[0]);
    4f6c:	fc842503          	lw	a0,-56(s0)
    4f70:	00000097          	auipc	ra,0x0
    4f74:	5aa080e7          	jalr	1450(ra) # 551a <close>
  wait((int*)0);
    4f78:	4501                	li	a0,0
    4f7a:	00000097          	auipc	ra,0x0
    4f7e:	580080e7          	jalr	1408(ra) # 54fa <wait>
  
  return n;
}
    4f82:	8526                	mv	a0,s1
    4f84:	70e2                	ld	ra,56(sp)
    4f86:	7442                	ld	s0,48(sp)
    4f88:	74a2                	ld	s1,40(sp)
    4f8a:	7902                	ld	s2,32(sp)
    4f8c:	69e2                	ld	s3,24(sp)
    4f8e:	6121                	addi	sp,sp,64
    4f90:	8082                	ret

0000000000004f92 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4f92:	7179                	addi	sp,sp,-48
    4f94:	f406                	sd	ra,40(sp)
    4f96:	f022                	sd	s0,32(sp)
    4f98:	ec26                	sd	s1,24(sp)
    4f9a:	e84a                	sd	s2,16(sp)
    4f9c:	1800                	addi	s0,sp,48
    4f9e:	84aa                	mv	s1,a0
    4fa0:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4fa2:	00003517          	auipc	a0,0x3
    4fa6:	c9e50513          	addi	a0,a0,-866 # 7c40 <malloc+0x2318>
    4faa:	00001097          	auipc	ra,0x1
    4fae:	8c0080e7          	jalr	-1856(ra) # 586a <printf>
  if((pid = fork()) < 0) {
    4fb2:	00000097          	auipc	ra,0x0
    4fb6:	538080e7          	jalr	1336(ra) # 54ea <fork>
    4fba:	02054e63          	bltz	a0,4ff6 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4fbe:	c929                	beqz	a0,5010 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4fc0:	fdc40513          	addi	a0,s0,-36
    4fc4:	00000097          	auipc	ra,0x0
    4fc8:	536080e7          	jalr	1334(ra) # 54fa <wait>
    if(xstatus != 0) 
    4fcc:	fdc42783          	lw	a5,-36(s0)
    4fd0:	c7b9                	beqz	a5,501e <run+0x8c>
      printf("FAILED\n");
    4fd2:	00003517          	auipc	a0,0x3
    4fd6:	c9650513          	addi	a0,a0,-874 # 7c68 <malloc+0x2340>
    4fda:	00001097          	auipc	ra,0x1
    4fde:	890080e7          	jalr	-1904(ra) # 586a <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4fe2:	fdc42503          	lw	a0,-36(s0)
  }
}
    4fe6:	00153513          	seqz	a0,a0
    4fea:	70a2                	ld	ra,40(sp)
    4fec:	7402                	ld	s0,32(sp)
    4fee:	64e2                	ld	s1,24(sp)
    4ff0:	6942                	ld	s2,16(sp)
    4ff2:	6145                	addi	sp,sp,48
    4ff4:	8082                	ret
    printf("runtest: fork error\n");
    4ff6:	00003517          	auipc	a0,0x3
    4ffa:	c5a50513          	addi	a0,a0,-934 # 7c50 <malloc+0x2328>
    4ffe:	00001097          	auipc	ra,0x1
    5002:	86c080e7          	jalr	-1940(ra) # 586a <printf>
    exit(1);
    5006:	4505                	li	a0,1
    5008:	00000097          	auipc	ra,0x0
    500c:	4ea080e7          	jalr	1258(ra) # 54f2 <exit>
    f(s);
    5010:	854a                	mv	a0,s2
    5012:	9482                	jalr	s1
    exit(0);
    5014:	4501                	li	a0,0
    5016:	00000097          	auipc	ra,0x0
    501a:	4dc080e7          	jalr	1244(ra) # 54f2 <exit>
      printf("OK\n");
    501e:	00003517          	auipc	a0,0x3
    5022:	c5250513          	addi	a0,a0,-942 # 7c70 <malloc+0x2348>
    5026:	00001097          	auipc	ra,0x1
    502a:	844080e7          	jalr	-1980(ra) # 586a <printf>
    502e:	bf55                	j	4fe2 <run+0x50>

0000000000005030 <main>:

int
main(int argc, char *argv[])
{
    5030:	c3010113          	addi	sp,sp,-976
    5034:	3c113423          	sd	ra,968(sp)
    5038:	3c813023          	sd	s0,960(sp)
    503c:	3a913c23          	sd	s1,952(sp)
    5040:	3b213823          	sd	s2,944(sp)
    5044:	3b313423          	sd	s3,936(sp)
    5048:	3b413023          	sd	s4,928(sp)
    504c:	39513c23          	sd	s5,920(sp)
    5050:	39613823          	sd	s6,912(sp)
    5054:	0f80                	addi	s0,sp,976
    5056:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    5058:	4789                	li	a5,2
    505a:	08f50f63          	beq	a0,a5,50f8 <main+0xc8>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    505e:	4785                	li	a5,1
  char *justone = 0;
    5060:	4901                	li	s2,0
  } else if(argc > 1){
    5062:	0ca7c963          	blt	a5,a0,5134 <main+0x104>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    5066:	00003797          	auipc	a5,0x3
    506a:	d2278793          	addi	a5,a5,-734 # 7d88 <malloc+0x2460>
    506e:	c3040713          	addi	a4,s0,-976
    5072:	00003317          	auipc	t1,0x3
    5076:	0a630313          	addi	t1,t1,166 # 8118 <malloc+0x27f0>
    507a:	0007b883          	ld	a7,0(a5)
    507e:	0087b803          	ld	a6,8(a5)
    5082:	6b88                	ld	a0,16(a5)
    5084:	6f8c                	ld	a1,24(a5)
    5086:	7390                	ld	a2,32(a5)
    5088:	7794                	ld	a3,40(a5)
    508a:	01173023          	sd	a7,0(a4)
    508e:	01073423          	sd	a6,8(a4)
    5092:	eb08                	sd	a0,16(a4)
    5094:	ef0c                	sd	a1,24(a4)
    5096:	f310                	sd	a2,32(a4)
    5098:	f714                	sd	a3,40(a4)
    509a:	03078793          	addi	a5,a5,48
    509e:	03070713          	addi	a4,a4,48
    50a2:	fc679ce3          	bne	a5,t1,507a <main+0x4a>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    50a6:	00003517          	auipc	a0,0x3
    50aa:	c8250513          	addi	a0,a0,-894 # 7d28 <malloc+0x2400>
    50ae:	00000097          	auipc	ra,0x0
    50b2:	7bc080e7          	jalr	1980(ra) # 586a <printf>
  int free0 = countfree();
    50b6:	00000097          	auipc	ra,0x0
    50ba:	daa080e7          	jalr	-598(ra) # 4e60 <countfree>
    50be:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    50c0:	c3843503          	ld	a0,-968(s0)
    50c4:	c3040493          	addi	s1,s0,-976
  int fail = 0;
    50c8:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    50ca:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    50cc:	e55d                	bnez	a0,517a <main+0x14a>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    50ce:	00000097          	auipc	ra,0x0
    50d2:	d92080e7          	jalr	-622(ra) # 4e60 <countfree>
    50d6:	85aa                	mv	a1,a0
    50d8:	0f455163          	bge	a0,s4,51ba <main+0x18a>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    50dc:	8652                	mv	a2,s4
    50de:	00003517          	auipc	a0,0x3
    50e2:	c0250513          	addi	a0,a0,-1022 # 7ce0 <malloc+0x23b8>
    50e6:	00000097          	auipc	ra,0x0
    50ea:	784080e7          	jalr	1924(ra) # 586a <printf>
    exit(1);
    50ee:	4505                	li	a0,1
    50f0:	00000097          	auipc	ra,0x0
    50f4:	402080e7          	jalr	1026(ra) # 54f2 <exit>
    50f8:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    50fa:	00003597          	auipc	a1,0x3
    50fe:	b7e58593          	addi	a1,a1,-1154 # 7c78 <malloc+0x2350>
    5102:	6488                	ld	a0,8(s1)
    5104:	00000097          	auipc	ra,0x0
    5108:	194080e7          	jalr	404(ra) # 5298 <strcmp>
    510c:	10050563          	beqz	a0,5216 <main+0x1e6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5110:	00003597          	auipc	a1,0x3
    5114:	c5058593          	addi	a1,a1,-944 # 7d60 <malloc+0x2438>
    5118:	6488                	ld	a0,8(s1)
    511a:	00000097          	auipc	ra,0x0
    511e:	17e080e7          	jalr	382(ra) # 5298 <strcmp>
    5122:	c97d                	beqz	a0,5218 <main+0x1e8>
  } else if(argc == 2 && argv[1][0] != '-'){
    5124:	0084b903          	ld	s2,8(s1)
    5128:	00094703          	lbu	a4,0(s2)
    512c:	02d00793          	li	a5,45
    5130:	f2f71be3          	bne	a4,a5,5066 <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    5134:	00003517          	auipc	a0,0x3
    5138:	b4c50513          	addi	a0,a0,-1204 # 7c80 <malloc+0x2358>
    513c:	00000097          	auipc	ra,0x0
    5140:	72e080e7          	jalr	1838(ra) # 586a <printf>
    exit(1);
    5144:	4505                	li	a0,1
    5146:	00000097          	auipc	ra,0x0
    514a:	3ac080e7          	jalr	940(ra) # 54f2 <exit>
          exit(1);
    514e:	4505                	li	a0,1
    5150:	00000097          	auipc	ra,0x0
    5154:	3a2080e7          	jalr	930(ra) # 54f2 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5158:	40a905bb          	subw	a1,s2,a0
    515c:	855a                	mv	a0,s6
    515e:	00000097          	auipc	ra,0x0
    5162:	70c080e7          	jalr	1804(ra) # 586a <printf>
        if(continuous != 2)
    5166:	09498463          	beq	s3,s4,51ee <main+0x1be>
          exit(1);
    516a:	4505                	li	a0,1
    516c:	00000097          	auipc	ra,0x0
    5170:	386080e7          	jalr	902(ra) # 54f2 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    5174:	04c1                	addi	s1,s1,16
    5176:	6488                	ld	a0,8(s1)
    5178:	c115                	beqz	a0,519c <main+0x16c>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    517a:	00090863          	beqz	s2,518a <main+0x15a>
    517e:	85ca                	mv	a1,s2
    5180:	00000097          	auipc	ra,0x0
    5184:	118080e7          	jalr	280(ra) # 5298 <strcmp>
    5188:	f575                	bnez	a0,5174 <main+0x144>
      if(!run(t->f, t->s))
    518a:	648c                	ld	a1,8(s1)
    518c:	6088                	ld	a0,0(s1)
    518e:	00000097          	auipc	ra,0x0
    5192:	e04080e7          	jalr	-508(ra) # 4f92 <run>
    5196:	fd79                	bnez	a0,5174 <main+0x144>
        fail = 1;
    5198:	89d6                	mv	s3,s5
    519a:	bfe9                	j	5174 <main+0x144>
  if(fail){
    519c:	f20989e3          	beqz	s3,50ce <main+0x9e>
    printf("SOME TESTS FAILED\n");
    51a0:	00003517          	auipc	a0,0x3
    51a4:	b2850513          	addi	a0,a0,-1240 # 7cc8 <malloc+0x23a0>
    51a8:	00000097          	auipc	ra,0x0
    51ac:	6c2080e7          	jalr	1730(ra) # 586a <printf>
    exit(1);
    51b0:	4505                	li	a0,1
    51b2:	00000097          	auipc	ra,0x0
    51b6:	340080e7          	jalr	832(ra) # 54f2 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    51ba:	00003517          	auipc	a0,0x3
    51be:	b5650513          	addi	a0,a0,-1194 # 7d10 <malloc+0x23e8>
    51c2:	00000097          	auipc	ra,0x0
    51c6:	6a8080e7          	jalr	1704(ra) # 586a <printf>
    exit(0);
    51ca:	4501                	li	a0,0
    51cc:	00000097          	auipc	ra,0x0
    51d0:	326080e7          	jalr	806(ra) # 54f2 <exit>
        printf("SOME TESTS FAILED\n");
    51d4:	8556                	mv	a0,s5
    51d6:	00000097          	auipc	ra,0x0
    51da:	694080e7          	jalr	1684(ra) # 586a <printf>
        if(continuous != 2)
    51de:	f74998e3          	bne	s3,s4,514e <main+0x11e>
      int free1 = countfree();
    51e2:	00000097          	auipc	ra,0x0
    51e6:	c7e080e7          	jalr	-898(ra) # 4e60 <countfree>
      if(free1 < free0){
    51ea:	f72547e3          	blt	a0,s2,5158 <main+0x128>
      int free0 = countfree();
    51ee:	00000097          	auipc	ra,0x0
    51f2:	c72080e7          	jalr	-910(ra) # 4e60 <countfree>
    51f6:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    51f8:	c3843583          	ld	a1,-968(s0)
    51fc:	d1fd                	beqz	a1,51e2 <main+0x1b2>
    51fe:	c3040493          	addi	s1,s0,-976
        if(!run(t->f, t->s)){
    5202:	6088                	ld	a0,0(s1)
    5204:	00000097          	auipc	ra,0x0
    5208:	d8e080e7          	jalr	-626(ra) # 4f92 <run>
    520c:	d561                	beqz	a0,51d4 <main+0x1a4>
      for (struct test *t = tests; t->s != 0; t++) {
    520e:	04c1                	addi	s1,s1,16
    5210:	648c                	ld	a1,8(s1)
    5212:	f9e5                	bnez	a1,5202 <main+0x1d2>
    5214:	b7f9                	j	51e2 <main+0x1b2>
    continuous = 1;
    5216:	4985                	li	s3,1
  } tests[] = {
    5218:	00003797          	auipc	a5,0x3
    521c:	b7078793          	addi	a5,a5,-1168 # 7d88 <malloc+0x2460>
    5220:	c3040713          	addi	a4,s0,-976
    5224:	00003317          	auipc	t1,0x3
    5228:	ef430313          	addi	t1,t1,-268 # 8118 <malloc+0x27f0>
    522c:	0007b883          	ld	a7,0(a5)
    5230:	0087b803          	ld	a6,8(a5)
    5234:	6b88                	ld	a0,16(a5)
    5236:	6f8c                	ld	a1,24(a5)
    5238:	7390                	ld	a2,32(a5)
    523a:	7794                	ld	a3,40(a5)
    523c:	01173023          	sd	a7,0(a4)
    5240:	01073423          	sd	a6,8(a4)
    5244:	eb08                	sd	a0,16(a4)
    5246:	ef0c                	sd	a1,24(a4)
    5248:	f310                	sd	a2,32(a4)
    524a:	f714                	sd	a3,40(a4)
    524c:	03078793          	addi	a5,a5,48
    5250:	03070713          	addi	a4,a4,48
    5254:	fc679ce3          	bne	a5,t1,522c <main+0x1fc>
    printf("continuous usertests starting\n");
    5258:	00003517          	auipc	a0,0x3
    525c:	ae850513          	addi	a0,a0,-1304 # 7d40 <malloc+0x2418>
    5260:	00000097          	auipc	ra,0x0
    5264:	60a080e7          	jalr	1546(ra) # 586a <printf>
        printf("SOME TESTS FAILED\n");
    5268:	00003a97          	auipc	s5,0x3
    526c:	a60a8a93          	addi	s5,s5,-1440 # 7cc8 <malloc+0x23a0>
        if(continuous != 2)
    5270:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5272:	00003b17          	auipc	s6,0x3
    5276:	a36b0b13          	addi	s6,s6,-1482 # 7ca8 <malloc+0x2380>
    527a:	bf95                	j	51ee <main+0x1be>

000000000000527c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    527c:	1141                	addi	sp,sp,-16
    527e:	e422                	sd	s0,8(sp)
    5280:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5282:	87aa                	mv	a5,a0
    5284:	0585                	addi	a1,a1,1
    5286:	0785                	addi	a5,a5,1
    5288:	fff5c703          	lbu	a4,-1(a1)
    528c:	fee78fa3          	sb	a4,-1(a5)
    5290:	fb75                	bnez	a4,5284 <strcpy+0x8>
    ;
  return os;
}
    5292:	6422                	ld	s0,8(sp)
    5294:	0141                	addi	sp,sp,16
    5296:	8082                	ret

0000000000005298 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5298:	1141                	addi	sp,sp,-16
    529a:	e422                	sd	s0,8(sp)
    529c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    529e:	00054783          	lbu	a5,0(a0)
    52a2:	cb91                	beqz	a5,52b6 <strcmp+0x1e>
    52a4:	0005c703          	lbu	a4,0(a1)
    52a8:	00f71763          	bne	a4,a5,52b6 <strcmp+0x1e>
    p++, q++;
    52ac:	0505                	addi	a0,a0,1
    52ae:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    52b0:	00054783          	lbu	a5,0(a0)
    52b4:	fbe5                	bnez	a5,52a4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    52b6:	0005c503          	lbu	a0,0(a1)
}
    52ba:	40a7853b          	subw	a0,a5,a0
    52be:	6422                	ld	s0,8(sp)
    52c0:	0141                	addi	sp,sp,16
    52c2:	8082                	ret

00000000000052c4 <strlen>:

uint
strlen(const char *s)
{
    52c4:	1141                	addi	sp,sp,-16
    52c6:	e422                	sd	s0,8(sp)
    52c8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    52ca:	00054783          	lbu	a5,0(a0)
    52ce:	cf91                	beqz	a5,52ea <strlen+0x26>
    52d0:	0505                	addi	a0,a0,1
    52d2:	87aa                	mv	a5,a0
    52d4:	4685                	li	a3,1
    52d6:	9e89                	subw	a3,a3,a0
    52d8:	00f6853b          	addw	a0,a3,a5
    52dc:	0785                	addi	a5,a5,1
    52de:	fff7c703          	lbu	a4,-1(a5)
    52e2:	fb7d                	bnez	a4,52d8 <strlen+0x14>
    ;
  return n;
}
    52e4:	6422                	ld	s0,8(sp)
    52e6:	0141                	addi	sp,sp,16
    52e8:	8082                	ret
  for(n = 0; s[n]; n++)
    52ea:	4501                	li	a0,0
    52ec:	bfe5                	j	52e4 <strlen+0x20>

00000000000052ee <memset>:

void*
memset(void *dst, int c, uint n)
{
    52ee:	1141                	addi	sp,sp,-16
    52f0:	e422                	sd	s0,8(sp)
    52f2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    52f4:	ce09                	beqz	a2,530e <memset+0x20>
    52f6:	87aa                	mv	a5,a0
    52f8:	fff6071b          	addiw	a4,a2,-1
    52fc:	1702                	slli	a4,a4,0x20
    52fe:	9301                	srli	a4,a4,0x20
    5300:	0705                	addi	a4,a4,1
    5302:	972a                	add	a4,a4,a0
    cdst[i] = c;
    5304:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5308:	0785                	addi	a5,a5,1
    530a:	fee79de3          	bne	a5,a4,5304 <memset+0x16>
  }
  return dst;
}
    530e:	6422                	ld	s0,8(sp)
    5310:	0141                	addi	sp,sp,16
    5312:	8082                	ret

0000000000005314 <strchr>:

char*
strchr(const char *s, char c)
{
    5314:	1141                	addi	sp,sp,-16
    5316:	e422                	sd	s0,8(sp)
    5318:	0800                	addi	s0,sp,16
  for(; *s; s++)
    531a:	00054783          	lbu	a5,0(a0)
    531e:	cb99                	beqz	a5,5334 <strchr+0x20>
    if(*s == c)
    5320:	00f58763          	beq	a1,a5,532e <strchr+0x1a>
  for(; *s; s++)
    5324:	0505                	addi	a0,a0,1
    5326:	00054783          	lbu	a5,0(a0)
    532a:	fbfd                	bnez	a5,5320 <strchr+0xc>
      return (char*)s;
  return 0;
    532c:	4501                	li	a0,0
}
    532e:	6422                	ld	s0,8(sp)
    5330:	0141                	addi	sp,sp,16
    5332:	8082                	ret
  return 0;
    5334:	4501                	li	a0,0
    5336:	bfe5                	j	532e <strchr+0x1a>

0000000000005338 <gets>:

char*
gets(char *buf, int max)
{
    5338:	711d                	addi	sp,sp,-96
    533a:	ec86                	sd	ra,88(sp)
    533c:	e8a2                	sd	s0,80(sp)
    533e:	e4a6                	sd	s1,72(sp)
    5340:	e0ca                	sd	s2,64(sp)
    5342:	fc4e                	sd	s3,56(sp)
    5344:	f852                	sd	s4,48(sp)
    5346:	f456                	sd	s5,40(sp)
    5348:	f05a                	sd	s6,32(sp)
    534a:	ec5e                	sd	s7,24(sp)
    534c:	1080                	addi	s0,sp,96
    534e:	8baa                	mv	s7,a0
    5350:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5352:	892a                	mv	s2,a0
    5354:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5356:	4aa9                	li	s5,10
    5358:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    535a:	89a6                	mv	s3,s1
    535c:	2485                	addiw	s1,s1,1
    535e:	0344d863          	bge	s1,s4,538e <gets+0x56>
    cc = read(0, &c, 1);
    5362:	4605                	li	a2,1
    5364:	faf40593          	addi	a1,s0,-81
    5368:	4501                	li	a0,0
    536a:	00000097          	auipc	ra,0x0
    536e:	1a0080e7          	jalr	416(ra) # 550a <read>
    if(cc < 1)
    5372:	00a05e63          	blez	a0,538e <gets+0x56>
    buf[i++] = c;
    5376:	faf44783          	lbu	a5,-81(s0)
    537a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    537e:	01578763          	beq	a5,s5,538c <gets+0x54>
    5382:	0905                	addi	s2,s2,1
    5384:	fd679be3          	bne	a5,s6,535a <gets+0x22>
  for(i=0; i+1 < max; ){
    5388:	89a6                	mv	s3,s1
    538a:	a011                	j	538e <gets+0x56>
    538c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    538e:	99de                	add	s3,s3,s7
    5390:	00098023          	sb	zero,0(s3)
  return buf;
}
    5394:	855e                	mv	a0,s7
    5396:	60e6                	ld	ra,88(sp)
    5398:	6446                	ld	s0,80(sp)
    539a:	64a6                	ld	s1,72(sp)
    539c:	6906                	ld	s2,64(sp)
    539e:	79e2                	ld	s3,56(sp)
    53a0:	7a42                	ld	s4,48(sp)
    53a2:	7aa2                	ld	s5,40(sp)
    53a4:	7b02                	ld	s6,32(sp)
    53a6:	6be2                	ld	s7,24(sp)
    53a8:	6125                	addi	sp,sp,96
    53aa:	8082                	ret

00000000000053ac <stat>:

int
stat(const char *n, struct stat *st)
{
    53ac:	1101                	addi	sp,sp,-32
    53ae:	ec06                	sd	ra,24(sp)
    53b0:	e822                	sd	s0,16(sp)
    53b2:	e426                	sd	s1,8(sp)
    53b4:	e04a                	sd	s2,0(sp)
    53b6:	1000                	addi	s0,sp,32
    53b8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    53ba:	4581                	li	a1,0
    53bc:	00000097          	auipc	ra,0x0
    53c0:	176080e7          	jalr	374(ra) # 5532 <open>
  if(fd < 0)
    53c4:	02054563          	bltz	a0,53ee <stat+0x42>
    53c8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    53ca:	85ca                	mv	a1,s2
    53cc:	00000097          	auipc	ra,0x0
    53d0:	17e080e7          	jalr	382(ra) # 554a <fstat>
    53d4:	892a                	mv	s2,a0
  close(fd);
    53d6:	8526                	mv	a0,s1
    53d8:	00000097          	auipc	ra,0x0
    53dc:	142080e7          	jalr	322(ra) # 551a <close>
  return r;
}
    53e0:	854a                	mv	a0,s2
    53e2:	60e2                	ld	ra,24(sp)
    53e4:	6442                	ld	s0,16(sp)
    53e6:	64a2                	ld	s1,8(sp)
    53e8:	6902                	ld	s2,0(sp)
    53ea:	6105                	addi	sp,sp,32
    53ec:	8082                	ret
    return -1;
    53ee:	597d                	li	s2,-1
    53f0:	bfc5                	j	53e0 <stat+0x34>

00000000000053f2 <atoi>:

int
atoi(const char *s)
{
    53f2:	1141                	addi	sp,sp,-16
    53f4:	e422                	sd	s0,8(sp)
    53f6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    53f8:	00054603          	lbu	a2,0(a0)
    53fc:	fd06079b          	addiw	a5,a2,-48
    5400:	0ff7f793          	andi	a5,a5,255
    5404:	4725                	li	a4,9
    5406:	02f76963          	bltu	a4,a5,5438 <atoi+0x46>
    540a:	86aa                	mv	a3,a0
  n = 0;
    540c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    540e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5410:	0685                	addi	a3,a3,1
    5412:	0025179b          	slliw	a5,a0,0x2
    5416:	9fa9                	addw	a5,a5,a0
    5418:	0017979b          	slliw	a5,a5,0x1
    541c:	9fb1                	addw	a5,a5,a2
    541e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5422:	0006c603          	lbu	a2,0(a3) # 1000 <bigdir+0x96>
    5426:	fd06071b          	addiw	a4,a2,-48
    542a:	0ff77713          	andi	a4,a4,255
    542e:	fee5f1e3          	bgeu	a1,a4,5410 <atoi+0x1e>
  return n;
}
    5432:	6422                	ld	s0,8(sp)
    5434:	0141                	addi	sp,sp,16
    5436:	8082                	ret
  n = 0;
    5438:	4501                	li	a0,0
    543a:	bfe5                	j	5432 <atoi+0x40>

000000000000543c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    543c:	1141                	addi	sp,sp,-16
    543e:	e422                	sd	s0,8(sp)
    5440:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5442:	02b57663          	bgeu	a0,a1,546e <memmove+0x32>
    while(n-- > 0)
    5446:	02c05163          	blez	a2,5468 <memmove+0x2c>
    544a:	fff6079b          	addiw	a5,a2,-1
    544e:	1782                	slli	a5,a5,0x20
    5450:	9381                	srli	a5,a5,0x20
    5452:	0785                	addi	a5,a5,1
    5454:	97aa                	add	a5,a5,a0
  dst = vdst;
    5456:	872a                	mv	a4,a0
      *dst++ = *src++;
    5458:	0585                	addi	a1,a1,1
    545a:	0705                	addi	a4,a4,1
    545c:	fff5c683          	lbu	a3,-1(a1)
    5460:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5464:	fee79ae3          	bne	a5,a4,5458 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5468:	6422                	ld	s0,8(sp)
    546a:	0141                	addi	sp,sp,16
    546c:	8082                	ret
    dst += n;
    546e:	00c50733          	add	a4,a0,a2
    src += n;
    5472:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5474:	fec05ae3          	blez	a2,5468 <memmove+0x2c>
    5478:	fff6079b          	addiw	a5,a2,-1
    547c:	1782                	slli	a5,a5,0x20
    547e:	9381                	srli	a5,a5,0x20
    5480:	fff7c793          	not	a5,a5
    5484:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5486:	15fd                	addi	a1,a1,-1
    5488:	177d                	addi	a4,a4,-1
    548a:	0005c683          	lbu	a3,0(a1)
    548e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5492:	fee79ae3          	bne	a5,a4,5486 <memmove+0x4a>
    5496:	bfc9                	j	5468 <memmove+0x2c>

0000000000005498 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5498:	1141                	addi	sp,sp,-16
    549a:	e422                	sd	s0,8(sp)
    549c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    549e:	ca05                	beqz	a2,54ce <memcmp+0x36>
    54a0:	fff6069b          	addiw	a3,a2,-1
    54a4:	1682                	slli	a3,a3,0x20
    54a6:	9281                	srli	a3,a3,0x20
    54a8:	0685                	addi	a3,a3,1
    54aa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    54ac:	00054783          	lbu	a5,0(a0)
    54b0:	0005c703          	lbu	a4,0(a1)
    54b4:	00e79863          	bne	a5,a4,54c4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    54b8:	0505                	addi	a0,a0,1
    p2++;
    54ba:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    54bc:	fed518e3          	bne	a0,a3,54ac <memcmp+0x14>
  }
  return 0;
    54c0:	4501                	li	a0,0
    54c2:	a019                	j	54c8 <memcmp+0x30>
      return *p1 - *p2;
    54c4:	40e7853b          	subw	a0,a5,a4
}
    54c8:	6422                	ld	s0,8(sp)
    54ca:	0141                	addi	sp,sp,16
    54cc:	8082                	ret
  return 0;
    54ce:	4501                	li	a0,0
    54d0:	bfe5                	j	54c8 <memcmp+0x30>

00000000000054d2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    54d2:	1141                	addi	sp,sp,-16
    54d4:	e406                	sd	ra,8(sp)
    54d6:	e022                	sd	s0,0(sp)
    54d8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    54da:	00000097          	auipc	ra,0x0
    54de:	f62080e7          	jalr	-158(ra) # 543c <memmove>
}
    54e2:	60a2                	ld	ra,8(sp)
    54e4:	6402                	ld	s0,0(sp)
    54e6:	0141                	addi	sp,sp,16
    54e8:	8082                	ret

00000000000054ea <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    54ea:	4885                	li	a7,1
 ecall
    54ec:	00000073          	ecall
 ret
    54f0:	8082                	ret

00000000000054f2 <exit>:
.global exit
exit:
 li a7, SYS_exit
    54f2:	4889                	li	a7,2
 ecall
    54f4:	00000073          	ecall
 ret
    54f8:	8082                	ret

00000000000054fa <wait>:
.global wait
wait:
 li a7, SYS_wait
    54fa:	488d                	li	a7,3
 ecall
    54fc:	00000073          	ecall
 ret
    5500:	8082                	ret

0000000000005502 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5502:	4891                	li	a7,4
 ecall
    5504:	00000073          	ecall
 ret
    5508:	8082                	ret

000000000000550a <read>:
.global read
read:
 li a7, SYS_read
    550a:	4895                	li	a7,5
 ecall
    550c:	00000073          	ecall
 ret
    5510:	8082                	ret

0000000000005512 <write>:
.global write
write:
 li a7, SYS_write
    5512:	48c1                	li	a7,16
 ecall
    5514:	00000073          	ecall
 ret
    5518:	8082                	ret

000000000000551a <close>:
.global close
close:
 li a7, SYS_close
    551a:	48d5                	li	a7,21
 ecall
    551c:	00000073          	ecall
 ret
    5520:	8082                	ret

0000000000005522 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5522:	4899                	li	a7,6
 ecall
    5524:	00000073          	ecall
 ret
    5528:	8082                	ret

000000000000552a <exec>:
.global exec
exec:
 li a7, SYS_exec
    552a:	489d                	li	a7,7
 ecall
    552c:	00000073          	ecall
 ret
    5530:	8082                	ret

0000000000005532 <open>:
.global open
open:
 li a7, SYS_open
    5532:	48bd                	li	a7,15
 ecall
    5534:	00000073          	ecall
 ret
    5538:	8082                	ret

000000000000553a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    553a:	48c5                	li	a7,17
 ecall
    553c:	00000073          	ecall
 ret
    5540:	8082                	ret

0000000000005542 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5542:	48c9                	li	a7,18
 ecall
    5544:	00000073          	ecall
 ret
    5548:	8082                	ret

000000000000554a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    554a:	48a1                	li	a7,8
 ecall
    554c:	00000073          	ecall
 ret
    5550:	8082                	ret

0000000000005552 <link>:
.global link
link:
 li a7, SYS_link
    5552:	48cd                	li	a7,19
 ecall
    5554:	00000073          	ecall
 ret
    5558:	8082                	ret

000000000000555a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    555a:	48d1                	li	a7,20
 ecall
    555c:	00000073          	ecall
 ret
    5560:	8082                	ret

0000000000005562 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5562:	48a5                	li	a7,9
 ecall
    5564:	00000073          	ecall
 ret
    5568:	8082                	ret

000000000000556a <dup>:
.global dup
dup:
 li a7, SYS_dup
    556a:	48a9                	li	a7,10
 ecall
    556c:	00000073          	ecall
 ret
    5570:	8082                	ret

0000000000005572 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5572:	48ad                	li	a7,11
 ecall
    5574:	00000073          	ecall
 ret
    5578:	8082                	ret

000000000000557a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    557a:	48b1                	li	a7,12
 ecall
    557c:	00000073          	ecall
 ret
    5580:	8082                	ret

0000000000005582 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5582:	48b5                	li	a7,13
 ecall
    5584:	00000073          	ecall
 ret
    5588:	8082                	ret

000000000000558a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    558a:	48b9                	li	a7,14
 ecall
    558c:	00000073          	ecall
 ret
    5590:	8082                	ret

0000000000005592 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5592:	1101                	addi	sp,sp,-32
    5594:	ec06                	sd	ra,24(sp)
    5596:	e822                	sd	s0,16(sp)
    5598:	1000                	addi	s0,sp,32
    559a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    559e:	4605                	li	a2,1
    55a0:	fef40593          	addi	a1,s0,-17
    55a4:	00000097          	auipc	ra,0x0
    55a8:	f6e080e7          	jalr	-146(ra) # 5512 <write>
}
    55ac:	60e2                	ld	ra,24(sp)
    55ae:	6442                	ld	s0,16(sp)
    55b0:	6105                	addi	sp,sp,32
    55b2:	8082                	ret

00000000000055b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    55b4:	7139                	addi	sp,sp,-64
    55b6:	fc06                	sd	ra,56(sp)
    55b8:	f822                	sd	s0,48(sp)
    55ba:	f426                	sd	s1,40(sp)
    55bc:	f04a                	sd	s2,32(sp)
    55be:	ec4e                	sd	s3,24(sp)
    55c0:	0080                	addi	s0,sp,64
    55c2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    55c4:	c299                	beqz	a3,55ca <printint+0x16>
    55c6:	0805c863          	bltz	a1,5656 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    55ca:	2581                	sext.w	a1,a1
  neg = 0;
    55cc:	4881                	li	a7,0
    55ce:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    55d2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    55d4:	2601                	sext.w	a2,a2
    55d6:	00003517          	auipc	a0,0x3
    55da:	b4a50513          	addi	a0,a0,-1206 # 8120 <digits>
    55de:	883a                	mv	a6,a4
    55e0:	2705                	addiw	a4,a4,1
    55e2:	02c5f7bb          	remuw	a5,a1,a2
    55e6:	1782                	slli	a5,a5,0x20
    55e8:	9381                	srli	a5,a5,0x20
    55ea:	97aa                	add	a5,a5,a0
    55ec:	0007c783          	lbu	a5,0(a5)
    55f0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    55f4:	0005879b          	sext.w	a5,a1
    55f8:	02c5d5bb          	divuw	a1,a1,a2
    55fc:	0685                	addi	a3,a3,1
    55fe:	fec7f0e3          	bgeu	a5,a2,55de <printint+0x2a>
  if(neg)
    5602:	00088b63          	beqz	a7,5618 <printint+0x64>
    buf[i++] = '-';
    5606:	fd040793          	addi	a5,s0,-48
    560a:	973e                	add	a4,a4,a5
    560c:	02d00793          	li	a5,45
    5610:	fef70823          	sb	a5,-16(a4)
    5614:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5618:	02e05863          	blez	a4,5648 <printint+0x94>
    561c:	fc040793          	addi	a5,s0,-64
    5620:	00e78933          	add	s2,a5,a4
    5624:	fff78993          	addi	s3,a5,-1
    5628:	99ba                	add	s3,s3,a4
    562a:	377d                	addiw	a4,a4,-1
    562c:	1702                	slli	a4,a4,0x20
    562e:	9301                	srli	a4,a4,0x20
    5630:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5634:	fff94583          	lbu	a1,-1(s2)
    5638:	8526                	mv	a0,s1
    563a:	00000097          	auipc	ra,0x0
    563e:	f58080e7          	jalr	-168(ra) # 5592 <putc>
  while(--i >= 0)
    5642:	197d                	addi	s2,s2,-1
    5644:	ff3918e3          	bne	s2,s3,5634 <printint+0x80>
}
    5648:	70e2                	ld	ra,56(sp)
    564a:	7442                	ld	s0,48(sp)
    564c:	74a2                	ld	s1,40(sp)
    564e:	7902                	ld	s2,32(sp)
    5650:	69e2                	ld	s3,24(sp)
    5652:	6121                	addi	sp,sp,64
    5654:	8082                	ret
    x = -xx;
    5656:	40b005bb          	negw	a1,a1
    neg = 1;
    565a:	4885                	li	a7,1
    x = -xx;
    565c:	bf8d                	j	55ce <printint+0x1a>

000000000000565e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    565e:	7119                	addi	sp,sp,-128
    5660:	fc86                	sd	ra,120(sp)
    5662:	f8a2                	sd	s0,112(sp)
    5664:	f4a6                	sd	s1,104(sp)
    5666:	f0ca                	sd	s2,96(sp)
    5668:	ecce                	sd	s3,88(sp)
    566a:	e8d2                	sd	s4,80(sp)
    566c:	e4d6                	sd	s5,72(sp)
    566e:	e0da                	sd	s6,64(sp)
    5670:	fc5e                	sd	s7,56(sp)
    5672:	f862                	sd	s8,48(sp)
    5674:	f466                	sd	s9,40(sp)
    5676:	f06a                	sd	s10,32(sp)
    5678:	ec6e                	sd	s11,24(sp)
    567a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    567c:	0005c903          	lbu	s2,0(a1)
    5680:	18090f63          	beqz	s2,581e <vprintf+0x1c0>
    5684:	8aaa                	mv	s5,a0
    5686:	8b32                	mv	s6,a2
    5688:	00158493          	addi	s1,a1,1
  state = 0;
    568c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    568e:	02500a13          	li	s4,37
      if(c == 'd'){
    5692:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5696:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    569a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    569e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    56a2:	00003b97          	auipc	s7,0x3
    56a6:	a7eb8b93          	addi	s7,s7,-1410 # 8120 <digits>
    56aa:	a839                	j	56c8 <vprintf+0x6a>
        putc(fd, c);
    56ac:	85ca                	mv	a1,s2
    56ae:	8556                	mv	a0,s5
    56b0:	00000097          	auipc	ra,0x0
    56b4:	ee2080e7          	jalr	-286(ra) # 5592 <putc>
    56b8:	a019                	j	56be <vprintf+0x60>
    } else if(state == '%'){
    56ba:	01498f63          	beq	s3,s4,56d8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    56be:	0485                	addi	s1,s1,1
    56c0:	fff4c903          	lbu	s2,-1(s1)
    56c4:	14090d63          	beqz	s2,581e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    56c8:	0009079b          	sext.w	a5,s2
    if(state == 0){
    56cc:	fe0997e3          	bnez	s3,56ba <vprintf+0x5c>
      if(c == '%'){
    56d0:	fd479ee3          	bne	a5,s4,56ac <vprintf+0x4e>
        state = '%';
    56d4:	89be                	mv	s3,a5
    56d6:	b7e5                	j	56be <vprintf+0x60>
      if(c == 'd'){
    56d8:	05878063          	beq	a5,s8,5718 <vprintf+0xba>
      } else if(c == 'l') {
    56dc:	05978c63          	beq	a5,s9,5734 <vprintf+0xd6>
      } else if(c == 'x') {
    56e0:	07a78863          	beq	a5,s10,5750 <vprintf+0xf2>
      } else if(c == 'p') {
    56e4:	09b78463          	beq	a5,s11,576c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    56e8:	07300713          	li	a4,115
    56ec:	0ce78663          	beq	a5,a4,57b8 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    56f0:	06300713          	li	a4,99
    56f4:	0ee78e63          	beq	a5,a4,57f0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    56f8:	11478863          	beq	a5,s4,5808 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    56fc:	85d2                	mv	a1,s4
    56fe:	8556                	mv	a0,s5
    5700:	00000097          	auipc	ra,0x0
    5704:	e92080e7          	jalr	-366(ra) # 5592 <putc>
        putc(fd, c);
    5708:	85ca                	mv	a1,s2
    570a:	8556                	mv	a0,s5
    570c:	00000097          	auipc	ra,0x0
    5710:	e86080e7          	jalr	-378(ra) # 5592 <putc>
      }
      state = 0;
    5714:	4981                	li	s3,0
    5716:	b765                	j	56be <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5718:	008b0913          	addi	s2,s6,8
    571c:	4685                	li	a3,1
    571e:	4629                	li	a2,10
    5720:	000b2583          	lw	a1,0(s6)
    5724:	8556                	mv	a0,s5
    5726:	00000097          	auipc	ra,0x0
    572a:	e8e080e7          	jalr	-370(ra) # 55b4 <printint>
    572e:	8b4a                	mv	s6,s2
      state = 0;
    5730:	4981                	li	s3,0
    5732:	b771                	j	56be <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5734:	008b0913          	addi	s2,s6,8
    5738:	4681                	li	a3,0
    573a:	4629                	li	a2,10
    573c:	000b2583          	lw	a1,0(s6)
    5740:	8556                	mv	a0,s5
    5742:	00000097          	auipc	ra,0x0
    5746:	e72080e7          	jalr	-398(ra) # 55b4 <printint>
    574a:	8b4a                	mv	s6,s2
      state = 0;
    574c:	4981                	li	s3,0
    574e:	bf85                	j	56be <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5750:	008b0913          	addi	s2,s6,8
    5754:	4681                	li	a3,0
    5756:	4641                	li	a2,16
    5758:	000b2583          	lw	a1,0(s6)
    575c:	8556                	mv	a0,s5
    575e:	00000097          	auipc	ra,0x0
    5762:	e56080e7          	jalr	-426(ra) # 55b4 <printint>
    5766:	8b4a                	mv	s6,s2
      state = 0;
    5768:	4981                	li	s3,0
    576a:	bf91                	j	56be <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    576c:	008b0793          	addi	a5,s6,8
    5770:	f8f43423          	sd	a5,-120(s0)
    5774:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5778:	03000593          	li	a1,48
    577c:	8556                	mv	a0,s5
    577e:	00000097          	auipc	ra,0x0
    5782:	e14080e7          	jalr	-492(ra) # 5592 <putc>
  putc(fd, 'x');
    5786:	85ea                	mv	a1,s10
    5788:	8556                	mv	a0,s5
    578a:	00000097          	auipc	ra,0x0
    578e:	e08080e7          	jalr	-504(ra) # 5592 <putc>
    5792:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5794:	03c9d793          	srli	a5,s3,0x3c
    5798:	97de                	add	a5,a5,s7
    579a:	0007c583          	lbu	a1,0(a5)
    579e:	8556                	mv	a0,s5
    57a0:	00000097          	auipc	ra,0x0
    57a4:	df2080e7          	jalr	-526(ra) # 5592 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    57a8:	0992                	slli	s3,s3,0x4
    57aa:	397d                	addiw	s2,s2,-1
    57ac:	fe0914e3          	bnez	s2,5794 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    57b0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    57b4:	4981                	li	s3,0
    57b6:	b721                	j	56be <vprintf+0x60>
        s = va_arg(ap, char*);
    57b8:	008b0993          	addi	s3,s6,8
    57bc:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    57c0:	02090163          	beqz	s2,57e2 <vprintf+0x184>
        while(*s != 0){
    57c4:	00094583          	lbu	a1,0(s2)
    57c8:	c9a1                	beqz	a1,5818 <vprintf+0x1ba>
          putc(fd, *s);
    57ca:	8556                	mv	a0,s5
    57cc:	00000097          	auipc	ra,0x0
    57d0:	dc6080e7          	jalr	-570(ra) # 5592 <putc>
          s++;
    57d4:	0905                	addi	s2,s2,1
        while(*s != 0){
    57d6:	00094583          	lbu	a1,0(s2)
    57da:	f9e5                	bnez	a1,57ca <vprintf+0x16c>
        s = va_arg(ap, char*);
    57dc:	8b4e                	mv	s6,s3
      state = 0;
    57de:	4981                	li	s3,0
    57e0:	bdf9                	j	56be <vprintf+0x60>
          s = "(null)";
    57e2:	00003917          	auipc	s2,0x3
    57e6:	93690913          	addi	s2,s2,-1738 # 8118 <malloc+0x27f0>
        while(*s != 0){
    57ea:	02800593          	li	a1,40
    57ee:	bff1                	j	57ca <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    57f0:	008b0913          	addi	s2,s6,8
    57f4:	000b4583          	lbu	a1,0(s6)
    57f8:	8556                	mv	a0,s5
    57fa:	00000097          	auipc	ra,0x0
    57fe:	d98080e7          	jalr	-616(ra) # 5592 <putc>
    5802:	8b4a                	mv	s6,s2
      state = 0;
    5804:	4981                	li	s3,0
    5806:	bd65                	j	56be <vprintf+0x60>
        putc(fd, c);
    5808:	85d2                	mv	a1,s4
    580a:	8556                	mv	a0,s5
    580c:	00000097          	auipc	ra,0x0
    5810:	d86080e7          	jalr	-634(ra) # 5592 <putc>
      state = 0;
    5814:	4981                	li	s3,0
    5816:	b565                	j	56be <vprintf+0x60>
        s = va_arg(ap, char*);
    5818:	8b4e                	mv	s6,s3
      state = 0;
    581a:	4981                	li	s3,0
    581c:	b54d                	j	56be <vprintf+0x60>
    }
  }
}
    581e:	70e6                	ld	ra,120(sp)
    5820:	7446                	ld	s0,112(sp)
    5822:	74a6                	ld	s1,104(sp)
    5824:	7906                	ld	s2,96(sp)
    5826:	69e6                	ld	s3,88(sp)
    5828:	6a46                	ld	s4,80(sp)
    582a:	6aa6                	ld	s5,72(sp)
    582c:	6b06                	ld	s6,64(sp)
    582e:	7be2                	ld	s7,56(sp)
    5830:	7c42                	ld	s8,48(sp)
    5832:	7ca2                	ld	s9,40(sp)
    5834:	7d02                	ld	s10,32(sp)
    5836:	6de2                	ld	s11,24(sp)
    5838:	6109                	addi	sp,sp,128
    583a:	8082                	ret

000000000000583c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    583c:	715d                	addi	sp,sp,-80
    583e:	ec06                	sd	ra,24(sp)
    5840:	e822                	sd	s0,16(sp)
    5842:	1000                	addi	s0,sp,32
    5844:	e010                	sd	a2,0(s0)
    5846:	e414                	sd	a3,8(s0)
    5848:	e818                	sd	a4,16(s0)
    584a:	ec1c                	sd	a5,24(s0)
    584c:	03043023          	sd	a6,32(s0)
    5850:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5854:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5858:	8622                	mv	a2,s0
    585a:	00000097          	auipc	ra,0x0
    585e:	e04080e7          	jalr	-508(ra) # 565e <vprintf>
}
    5862:	60e2                	ld	ra,24(sp)
    5864:	6442                	ld	s0,16(sp)
    5866:	6161                	addi	sp,sp,80
    5868:	8082                	ret

000000000000586a <printf>:

void
printf(const char *fmt, ...)
{
    586a:	711d                	addi	sp,sp,-96
    586c:	ec06                	sd	ra,24(sp)
    586e:	e822                	sd	s0,16(sp)
    5870:	1000                	addi	s0,sp,32
    5872:	e40c                	sd	a1,8(s0)
    5874:	e810                	sd	a2,16(s0)
    5876:	ec14                	sd	a3,24(s0)
    5878:	f018                	sd	a4,32(s0)
    587a:	f41c                	sd	a5,40(s0)
    587c:	03043823          	sd	a6,48(s0)
    5880:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5884:	00840613          	addi	a2,s0,8
    5888:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    588c:	85aa                	mv	a1,a0
    588e:	4505                	li	a0,1
    5890:	00000097          	auipc	ra,0x0
    5894:	dce080e7          	jalr	-562(ra) # 565e <vprintf>
}
    5898:	60e2                	ld	ra,24(sp)
    589a:	6442                	ld	s0,16(sp)
    589c:	6125                	addi	sp,sp,96
    589e:	8082                	ret

00000000000058a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    58a0:	1141                	addi	sp,sp,-16
    58a2:	e422                	sd	s0,8(sp)
    58a4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    58a6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    58aa:	00003797          	auipc	a5,0x3
    58ae:	8a67b783          	ld	a5,-1882(a5) # 8150 <freep>
    58b2:	a805                	j	58e2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    58b4:	4618                	lw	a4,8(a2)
    58b6:	9db9                	addw	a1,a1,a4
    58b8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    58bc:	6398                	ld	a4,0(a5)
    58be:	6318                	ld	a4,0(a4)
    58c0:	fee53823          	sd	a4,-16(a0)
    58c4:	a091                	j	5908 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    58c6:	ff852703          	lw	a4,-8(a0)
    58ca:	9e39                	addw	a2,a2,a4
    58cc:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    58ce:	ff053703          	ld	a4,-16(a0)
    58d2:	e398                	sd	a4,0(a5)
    58d4:	a099                	j	591a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    58d6:	6398                	ld	a4,0(a5)
    58d8:	00e7e463          	bltu	a5,a4,58e0 <free+0x40>
    58dc:	00e6ea63          	bltu	a3,a4,58f0 <free+0x50>
{
    58e0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    58e2:	fed7fae3          	bgeu	a5,a3,58d6 <free+0x36>
    58e6:	6398                	ld	a4,0(a5)
    58e8:	00e6e463          	bltu	a3,a4,58f0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    58ec:	fee7eae3          	bltu	a5,a4,58e0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    58f0:	ff852583          	lw	a1,-8(a0)
    58f4:	6390                	ld	a2,0(a5)
    58f6:	02059713          	slli	a4,a1,0x20
    58fa:	9301                	srli	a4,a4,0x20
    58fc:	0712                	slli	a4,a4,0x4
    58fe:	9736                	add	a4,a4,a3
    5900:	fae60ae3          	beq	a2,a4,58b4 <free+0x14>
    bp->s.ptr = p->s.ptr;
    5904:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5908:	4790                	lw	a2,8(a5)
    590a:	02061713          	slli	a4,a2,0x20
    590e:	9301                	srli	a4,a4,0x20
    5910:	0712                	slli	a4,a4,0x4
    5912:	973e                	add	a4,a4,a5
    5914:	fae689e3          	beq	a3,a4,58c6 <free+0x26>
  } else
    p->s.ptr = bp;
    5918:	e394                	sd	a3,0(a5)
  freep = p;
    591a:	00003717          	auipc	a4,0x3
    591e:	82f73b23          	sd	a5,-1994(a4) # 8150 <freep>
}
    5922:	6422                	ld	s0,8(sp)
    5924:	0141                	addi	sp,sp,16
    5926:	8082                	ret

0000000000005928 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5928:	7139                	addi	sp,sp,-64
    592a:	fc06                	sd	ra,56(sp)
    592c:	f822                	sd	s0,48(sp)
    592e:	f426                	sd	s1,40(sp)
    5930:	f04a                	sd	s2,32(sp)
    5932:	ec4e                	sd	s3,24(sp)
    5934:	e852                	sd	s4,16(sp)
    5936:	e456                	sd	s5,8(sp)
    5938:	e05a                	sd	s6,0(sp)
    593a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    593c:	02051493          	slli	s1,a0,0x20
    5940:	9081                	srli	s1,s1,0x20
    5942:	04bd                	addi	s1,s1,15
    5944:	8091                	srli	s1,s1,0x4
    5946:	0014899b          	addiw	s3,s1,1
    594a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    594c:	00003517          	auipc	a0,0x3
    5950:	80453503          	ld	a0,-2044(a0) # 8150 <freep>
    5954:	c515                	beqz	a0,5980 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5956:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5958:	4798                	lw	a4,8(a5)
    595a:	02977f63          	bgeu	a4,s1,5998 <malloc+0x70>
    595e:	8a4e                	mv	s4,s3
    5960:	0009871b          	sext.w	a4,s3
    5964:	6685                	lui	a3,0x1
    5966:	00d77363          	bgeu	a4,a3,596c <malloc+0x44>
    596a:	6a05                	lui	s4,0x1
    596c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5970:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5974:	00002917          	auipc	s2,0x2
    5978:	7dc90913          	addi	s2,s2,2012 # 8150 <freep>
  if(p == (char*)-1)
    597c:	5afd                	li	s5,-1
    597e:	a88d                	j	59f0 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    5980:	00009797          	auipc	a5,0x9
    5984:	ff078793          	addi	a5,a5,-16 # e970 <base>
    5988:	00002717          	auipc	a4,0x2
    598c:	7cf73423          	sd	a5,1992(a4) # 8150 <freep>
    5990:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5992:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5996:	b7e1                	j	595e <malloc+0x36>
      if(p->s.size == nunits)
    5998:	02e48b63          	beq	s1,a4,59ce <malloc+0xa6>
        p->s.size -= nunits;
    599c:	4137073b          	subw	a4,a4,s3
    59a0:	c798                	sw	a4,8(a5)
        p += p->s.size;
    59a2:	1702                	slli	a4,a4,0x20
    59a4:	9301                	srli	a4,a4,0x20
    59a6:	0712                	slli	a4,a4,0x4
    59a8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    59aa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    59ae:	00002717          	auipc	a4,0x2
    59b2:	7aa73123          	sd	a0,1954(a4) # 8150 <freep>
      return (void*)(p + 1);
    59b6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    59ba:	70e2                	ld	ra,56(sp)
    59bc:	7442                	ld	s0,48(sp)
    59be:	74a2                	ld	s1,40(sp)
    59c0:	7902                	ld	s2,32(sp)
    59c2:	69e2                	ld	s3,24(sp)
    59c4:	6a42                	ld	s4,16(sp)
    59c6:	6aa2                	ld	s5,8(sp)
    59c8:	6b02                	ld	s6,0(sp)
    59ca:	6121                	addi	sp,sp,64
    59cc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    59ce:	6398                	ld	a4,0(a5)
    59d0:	e118                	sd	a4,0(a0)
    59d2:	bff1                	j	59ae <malloc+0x86>
  hp->s.size = nu;
    59d4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    59d8:	0541                	addi	a0,a0,16
    59da:	00000097          	auipc	ra,0x0
    59de:	ec6080e7          	jalr	-314(ra) # 58a0 <free>
  return freep;
    59e2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    59e6:	d971                	beqz	a0,59ba <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    59e8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    59ea:	4798                	lw	a4,8(a5)
    59ec:	fa9776e3          	bgeu	a4,s1,5998 <malloc+0x70>
    if(p == freep)
    59f0:	00093703          	ld	a4,0(s2)
    59f4:	853e                	mv	a0,a5
    59f6:	fef719e3          	bne	a4,a5,59e8 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    59fa:	8552                	mv	a0,s4
    59fc:	00000097          	auipc	ra,0x0
    5a00:	b7e080e7          	jalr	-1154(ra) # 557a <sbrk>
  if(p == (char*)-1)
    5a04:	fd5518e3          	bne	a0,s5,59d4 <malloc+0xac>
        return 0;
    5a08:	4501                	li	a0,0
    5a0a:	bf45                	j	59ba <malloc+0x92>
