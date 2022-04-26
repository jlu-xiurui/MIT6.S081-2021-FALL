
user/_mmaptest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:

char *testname = "???";

void
err(char *why)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
  printf("mmaptest: %s failed: %s, pid=%d\n", testname, why, getpid());
       e:	00001917          	auipc	s2,0x1
      12:	59293903          	ld	s2,1426(s2) # 15a0 <testname>
      16:	00001097          	auipc	ra,0x1
      1a:	c10080e7          	jalr	-1008(ra) # c26 <getpid>
      1e:	86aa                	mv	a3,a0
      20:	8626                	mv	a2,s1
      22:	85ca                	mv	a1,s2
      24:	00001517          	auipc	a0,0x1
      28:	0ac50513          	addi	a0,a0,172 # 10d0 <malloc+0xe4>
      2c:	00001097          	auipc	ra,0x1
      30:	f02080e7          	jalr	-254(ra) # f2e <printf>
  exit(1);
      34:	4505                	li	a0,1
      36:	00001097          	auipc	ra,0x1
      3a:	b70080e7          	jalr	-1168(ra) # ba6 <exit>

000000000000003e <_v1>:
//
// check the content of the two mapped pages.
//
void
_v1(char *p)
{
      3e:	1141                	addi	sp,sp,-16
      40:	e406                	sd	ra,8(sp)
      42:	e022                	sd	s0,0(sp)
      44:	0800                	addi	s0,sp,16
      46:	4781                	li	a5,0
  int i;
  for (i = 0; i < PGSIZE*2; i++) {
    if (i < PGSIZE + (PGSIZE/2)) {
      48:	6685                	lui	a3,0x1
      4a:	7ff68693          	addi	a3,a3,2047 # 17ff <buf+0x24f>
  for (i = 0; i < PGSIZE*2; i++) {
      4e:	6889                	lui	a7,0x2
      if (p[i] != 'A') {
      50:	04100813          	li	a6,65
      54:	a811                	j	68 <_v1+0x2a>
        printf("mismatch at %d, wanted 'A', got 0x%x\n", i, p[i]);
        err("v1 mismatch (1)");
      }
    } else {
      if (p[i] != 0) {
      56:	00f50633          	add	a2,a0,a5
      5a:	00064603          	lbu	a2,0(a2)
      5e:	e221                	bnez	a2,9e <_v1+0x60>
  for (i = 0; i < PGSIZE*2; i++) {
      60:	2705                	addiw	a4,a4,1
      62:	05175e63          	bge	a4,a7,be <_v1+0x80>
      66:	0785                	addi	a5,a5,1
      68:	0007871b          	sext.w	a4,a5
      6c:	85ba                	mv	a1,a4
    if (i < PGSIZE + (PGSIZE/2)) {
      6e:	fee6c4e3          	blt	a3,a4,56 <_v1+0x18>
      if (p[i] != 'A') {
      72:	00f50733          	add	a4,a0,a5
      76:	00074603          	lbu	a2,0(a4)
      7a:	ff0606e3          	beq	a2,a6,66 <_v1+0x28>
        printf("mismatch at %d, wanted 'A', got 0x%x\n", i, p[i]);
      7e:	00001517          	auipc	a0,0x1
      82:	07a50513          	addi	a0,a0,122 # 10f8 <malloc+0x10c>
      86:	00001097          	auipc	ra,0x1
      8a:	ea8080e7          	jalr	-344(ra) # f2e <printf>
        err("v1 mismatch (1)");
      8e:	00001517          	auipc	a0,0x1
      92:	09250513          	addi	a0,a0,146 # 1120 <malloc+0x134>
      96:	00000097          	auipc	ra,0x0
      9a:	f6a080e7          	jalr	-150(ra) # 0 <err>
        printf("mismatch at %d, wanted zero, got 0x%x\n", i, p[i]);
      9e:	00001517          	auipc	a0,0x1
      a2:	09250513          	addi	a0,a0,146 # 1130 <malloc+0x144>
      a6:	00001097          	auipc	ra,0x1
      aa:	e88080e7          	jalr	-376(ra) # f2e <printf>
        err("v1 mismatch (2)");
      ae:	00001517          	auipc	a0,0x1
      b2:	0aa50513          	addi	a0,a0,170 # 1158 <malloc+0x16c>
      b6:	00000097          	auipc	ra,0x0
      ba:	f4a080e7          	jalr	-182(ra) # 0 <err>
      }
    }
  }
}
      be:	60a2                	ld	ra,8(sp)
      c0:	6402                	ld	s0,0(sp)
      c2:	0141                	addi	sp,sp,16
      c4:	8082                	ret

00000000000000c6 <makefile>:
// create a file to be mapped, containing
// 1.5 pages of 'A' and half a page of zeros.
//
void
makefile(const char *f)
{
      c6:	7179                	addi	sp,sp,-48
      c8:	f406                	sd	ra,40(sp)
      ca:	f022                	sd	s0,32(sp)
      cc:	ec26                	sd	s1,24(sp)
      ce:	e84a                	sd	s2,16(sp)
      d0:	e44e                	sd	s3,8(sp)
      d2:	1800                	addi	s0,sp,48
      d4:	84aa                	mv	s1,a0
  int i;
  int n = PGSIZE/BSIZE;

  unlink(f);
      d6:	00001097          	auipc	ra,0x1
      da:	b20080e7          	jalr	-1248(ra) # bf6 <unlink>
  int fd = open(f, O_WRONLY | O_CREATE);
      de:	20100593          	li	a1,513
      e2:	8526                	mv	a0,s1
      e4:	00001097          	auipc	ra,0x1
      e8:	b02080e7          	jalr	-1278(ra) # be6 <open>
  if (fd == -1)
      ec:	57fd                	li	a5,-1
      ee:	06f50163          	beq	a0,a5,150 <makefile+0x8a>
      f2:	892a                	mv	s2,a0
    err("open");
  memset(buf, 'A', BSIZE);
      f4:	40000613          	li	a2,1024
      f8:	04100593          	li	a1,65
      fc:	00001517          	auipc	a0,0x1
     100:	4b450513          	addi	a0,a0,1204 # 15b0 <buf>
     104:	00001097          	auipc	ra,0x1
     108:	89e080e7          	jalr	-1890(ra) # 9a2 <memset>
     10c:	4499                	li	s1,6
  // write 1.5 page
  for (i = 0; i < n + n/2; i++) {
    if (write(fd, buf, BSIZE) != BSIZE)
     10e:	00001997          	auipc	s3,0x1
     112:	4a298993          	addi	s3,s3,1186 # 15b0 <buf>
     116:	40000613          	li	a2,1024
     11a:	85ce                	mv	a1,s3
     11c:	854a                	mv	a0,s2
     11e:	00001097          	auipc	ra,0x1
     122:	aa8080e7          	jalr	-1368(ra) # bc6 <write>
     126:	40000793          	li	a5,1024
     12a:	02f51b63          	bne	a0,a5,160 <makefile+0x9a>
  for (i = 0; i < n + n/2; i++) {
     12e:	34fd                	addiw	s1,s1,-1
     130:	f0fd                	bnez	s1,116 <makefile+0x50>
      err("write 0 makefile");
  }
  if (close(fd) == -1)
     132:	854a                	mv	a0,s2
     134:	00001097          	auipc	ra,0x1
     138:	a9a080e7          	jalr	-1382(ra) # bce <close>
     13c:	57fd                	li	a5,-1
     13e:	02f50963          	beq	a0,a5,170 <makefile+0xaa>
    err("close");
}
     142:	70a2                	ld	ra,40(sp)
     144:	7402                	ld	s0,32(sp)
     146:	64e2                	ld	s1,24(sp)
     148:	6942                	ld	s2,16(sp)
     14a:	69a2                	ld	s3,8(sp)
     14c:	6145                	addi	sp,sp,48
     14e:	8082                	ret
    err("open");
     150:	00001517          	auipc	a0,0x1
     154:	01850513          	addi	a0,a0,24 # 1168 <malloc+0x17c>
     158:	00000097          	auipc	ra,0x0
     15c:	ea8080e7          	jalr	-344(ra) # 0 <err>
      err("write 0 makefile");
     160:	00001517          	auipc	a0,0x1
     164:	01050513          	addi	a0,a0,16 # 1170 <malloc+0x184>
     168:	00000097          	auipc	ra,0x0
     16c:	e98080e7          	jalr	-360(ra) # 0 <err>
    err("close");
     170:	00001517          	auipc	a0,0x1
     174:	01850513          	addi	a0,a0,24 # 1188 <malloc+0x19c>
     178:	00000097          	auipc	ra,0x0
     17c:	e88080e7          	jalr	-376(ra) # 0 <err>

0000000000000180 <mmap_test>:

void
mmap_test(void)
{
     180:	7139                	addi	sp,sp,-64
     182:	fc06                	sd	ra,56(sp)
     184:	f822                	sd	s0,48(sp)
     186:	f426                	sd	s1,40(sp)
     188:	f04a                	sd	s2,32(sp)
     18a:	ec4e                	sd	s3,24(sp)
     18c:	e852                	sd	s4,16(sp)
     18e:	0080                	addi	s0,sp,64
  int fd;
  int i;
  const char * const f = "mmap.dur";
  printf("mmap_test starting\n");
     190:	00001517          	auipc	a0,0x1
     194:	00050513          	mv	a0,a0
     198:	00001097          	auipc	ra,0x1
     19c:	d96080e7          	jalr	-618(ra) # f2e <printf>
  testname = "mmap_test";
     1a0:	00001797          	auipc	a5,0x1
     1a4:	00878793          	addi	a5,a5,8 # 11a8 <malloc+0x1bc>
     1a8:	00001717          	auipc	a4,0x1
     1ac:	3ef73c23          	sd	a5,1016(a4) # 15a0 <testname>
  //
  // create a file with known content, map it into memory, check that
  // the mapped memory has the same bytes as originally written to the
  // file.
  //
  makefile(f);
     1b0:	00001517          	auipc	a0,0x1
     1b4:	00850513          	addi	a0,a0,8 # 11b8 <malloc+0x1cc>
     1b8:	00000097          	auipc	ra,0x0
     1bc:	f0e080e7          	jalr	-242(ra) # c6 <makefile>
  if ((fd = open(f, O_RDONLY)) == -1)
     1c0:	4581                	li	a1,0
     1c2:	00001517          	auipc	a0,0x1
     1c6:	ff650513          	addi	a0,a0,-10 # 11b8 <malloc+0x1cc>
     1ca:	00001097          	auipc	ra,0x1
     1ce:	a1c080e7          	jalr	-1508(ra) # be6 <open>
     1d2:	57fd                	li	a5,-1
     1d4:	3ef50663          	beq	a0,a5,5c0 <mmap_test+0x440>
     1d8:	892a                	mv	s2,a0
    err("open");

  printf("test mmap f\n");
     1da:	00001517          	auipc	a0,0x1
     1de:	fee50513          	addi	a0,a0,-18 # 11c8 <malloc+0x1dc>
     1e2:	00001097          	auipc	ra,0x1
     1e6:	d4c080e7          	jalr	-692(ra) # f2e <printf>
  // same file (of course in this case updates are prohibited
  // due to PROT_READ). the fifth argument is the file descriptor
  // of the file to be mapped. the last argument is the starting
  // offset in the file.
  //
  char *p = mmap(0, PGSIZE*2, PROT_READ, MAP_PRIVATE, fd, 0);
     1ea:	4781                	li	a5,0
     1ec:	874a                	mv	a4,s2
     1ee:	4689                	li	a3,2
     1f0:	4605                	li	a2,1
     1f2:	6589                	lui	a1,0x2
     1f4:	4501                	li	a0,0
     1f6:	00001097          	auipc	ra,0x1
     1fa:	a50080e7          	jalr	-1456(ra) # c46 <mmap>
     1fe:	84aa                	mv	s1,a0
  if (p == MAP_FAILED)
     200:	57fd                	li	a5,-1
     202:	3cf50763          	beq	a0,a5,5d0 <mmap_test+0x450>
    err("mmap (1)");
  _v1(p);
     206:	00000097          	auipc	ra,0x0
     20a:	e38080e7          	jalr	-456(ra) # 3e <_v1>
  if (munmap(p, PGSIZE*2) == -1)
     20e:	6589                	lui	a1,0x2
     210:	8526                	mv	a0,s1
     212:	00001097          	auipc	ra,0x1
     216:	a3c080e7          	jalr	-1476(ra) # c4e <munmap>
     21a:	57fd                	li	a5,-1
     21c:	3cf50263          	beq	a0,a5,5e0 <mmap_test+0x460>
    err("munmap (1)");

  printf("test mmap f: OK\n");
     220:	00001517          	auipc	a0,0x1
     224:	fd850513          	addi	a0,a0,-40 # 11f8 <malloc+0x20c>
     228:	00001097          	auipc	ra,0x1
     22c:	d06080e7          	jalr	-762(ra) # f2e <printf>
    
  printf("test mmap private\n");
     230:	00001517          	auipc	a0,0x1
     234:	fe050513          	addi	a0,a0,-32 # 1210 <malloc+0x224>
     238:	00001097          	auipc	ra,0x1
     23c:	cf6080e7          	jalr	-778(ra) # f2e <printf>
  // should be able to map file opened read-only with private writable
  // mapping
  p = mmap(0, PGSIZE*2, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
     240:	4781                	li	a5,0
     242:	874a                	mv	a4,s2
     244:	4689                	li	a3,2
     246:	460d                	li	a2,3
     248:	6589                	lui	a1,0x2
     24a:	4501                	li	a0,0
     24c:	00001097          	auipc	ra,0x1
     250:	9fa080e7          	jalr	-1542(ra) # c46 <mmap>
     254:	84aa                	mv	s1,a0
  if (p == MAP_FAILED)
     256:	57fd                	li	a5,-1
     258:	38f50c63          	beq	a0,a5,5f0 <mmap_test+0x470>
    err("mmap (2)");
  if (close(fd) == -1)
     25c:	854a                	mv	a0,s2
     25e:	00001097          	auipc	ra,0x1
     262:	970080e7          	jalr	-1680(ra) # bce <close>
     266:	57fd                	li	a5,-1
     268:	38f50c63          	beq	a0,a5,600 <mmap_test+0x480>
    err("close");
  _v1(p);
     26c:	8526                	mv	a0,s1
     26e:	00000097          	auipc	ra,0x0
     272:	dd0080e7          	jalr	-560(ra) # 3e <_v1>
  for (i = 0; i < PGSIZE*2; i++)
     276:	87a6                	mv	a5,s1
     278:	6709                	lui	a4,0x2
     27a:	9726                	add	a4,a4,s1
    p[i] = 'Z';
     27c:	05a00693          	li	a3,90
     280:	00d78023          	sb	a3,0(a5)
  for (i = 0; i < PGSIZE*2; i++)
     284:	0785                	addi	a5,a5,1
     286:	fef71de3          	bne	a4,a5,280 <mmap_test+0x100>
  if (munmap(p, PGSIZE*2) == -1)
     28a:	6589                	lui	a1,0x2
     28c:	8526                	mv	a0,s1
     28e:	00001097          	auipc	ra,0x1
     292:	9c0080e7          	jalr	-1600(ra) # c4e <munmap>
     296:	57fd                	li	a5,-1
     298:	36f50c63          	beq	a0,a5,610 <mmap_test+0x490>
    err("munmap (2)");

  printf("test mmap private: OK\n");
     29c:	00001517          	auipc	a0,0x1
     2a0:	fac50513          	addi	a0,a0,-84 # 1248 <malloc+0x25c>
     2a4:	00001097          	auipc	ra,0x1
     2a8:	c8a080e7          	jalr	-886(ra) # f2e <printf>
    
  printf("test mmap read-only\n");
     2ac:	00001517          	auipc	a0,0x1
     2b0:	fb450513          	addi	a0,a0,-76 # 1260 <malloc+0x274>
     2b4:	00001097          	auipc	ra,0x1
     2b8:	c7a080e7          	jalr	-902(ra) # f2e <printf>
    
  // check that mmap doesn't allow read/write mapping of a
  // file opened read-only.
  if ((fd = open(f, O_RDONLY)) == -1)
     2bc:	4581                	li	a1,0
     2be:	00001517          	auipc	a0,0x1
     2c2:	efa50513          	addi	a0,a0,-262 # 11b8 <malloc+0x1cc>
     2c6:	00001097          	auipc	ra,0x1
     2ca:	920080e7          	jalr	-1760(ra) # be6 <open>
     2ce:	84aa                	mv	s1,a0
     2d0:	57fd                	li	a5,-1
     2d2:	34f50763          	beq	a0,a5,620 <mmap_test+0x4a0>
    err("open");
  p = mmap(0, PGSIZE*3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     2d6:	4781                	li	a5,0
     2d8:	872a                	mv	a4,a0
     2da:	4685                	li	a3,1
     2dc:	460d                	li	a2,3
     2de:	658d                	lui	a1,0x3
     2e0:	4501                	li	a0,0
     2e2:	00001097          	auipc	ra,0x1
     2e6:	964080e7          	jalr	-1692(ra) # c46 <mmap>
  if (p != MAP_FAILED)
     2ea:	57fd                	li	a5,-1
     2ec:	34f51263          	bne	a0,a5,630 <mmap_test+0x4b0>
    err("mmap call should have failed");
  if (close(fd) == -1)
     2f0:	8526                	mv	a0,s1
     2f2:	00001097          	auipc	ra,0x1
     2f6:	8dc080e7          	jalr	-1828(ra) # bce <close>
     2fa:	57fd                	li	a5,-1
     2fc:	34f50263          	beq	a0,a5,640 <mmap_test+0x4c0>
    err("close");

  printf("test mmap read-only: OK\n");
     300:	00001517          	auipc	a0,0x1
     304:	f9850513          	addi	a0,a0,-104 # 1298 <malloc+0x2ac>
     308:	00001097          	auipc	ra,0x1
     30c:	c26080e7          	jalr	-986(ra) # f2e <printf>
    
  printf("test mmap read/write\n");
     310:	00001517          	auipc	a0,0x1
     314:	fa850513          	addi	a0,a0,-88 # 12b8 <malloc+0x2cc>
     318:	00001097          	auipc	ra,0x1
     31c:	c16080e7          	jalr	-1002(ra) # f2e <printf>
  
  // check that mmap does allow read/write mapping of a
  // file opened read/write.
  if ((fd = open(f, O_RDWR)) == -1)
     320:	4589                	li	a1,2
     322:	00001517          	auipc	a0,0x1
     326:	e9650513          	addi	a0,a0,-362 # 11b8 <malloc+0x1cc>
     32a:	00001097          	auipc	ra,0x1
     32e:	8bc080e7          	jalr	-1860(ra) # be6 <open>
     332:	84aa                	mv	s1,a0
     334:	57fd                	li	a5,-1
     336:	30f50d63          	beq	a0,a5,650 <mmap_test+0x4d0>
    err("open");
  p = mmap(0, PGSIZE*3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     33a:	4781                	li	a5,0
     33c:	872a                	mv	a4,a0
     33e:	4685                	li	a3,1
     340:	460d                	li	a2,3
     342:	658d                	lui	a1,0x3
     344:	4501                	li	a0,0
     346:	00001097          	auipc	ra,0x1
     34a:	900080e7          	jalr	-1792(ra) # c46 <mmap>
     34e:	89aa                	mv	s3,a0
  if (p == MAP_FAILED)
     350:	57fd                	li	a5,-1
     352:	30f50763          	beq	a0,a5,660 <mmap_test+0x4e0>
    err("mmap (3)");
  if (close(fd) == -1)
     356:	8526                	mv	a0,s1
     358:	00001097          	auipc	ra,0x1
     35c:	876080e7          	jalr	-1930(ra) # bce <close>
     360:	57fd                	li	a5,-1
     362:	30f50763          	beq	a0,a5,670 <mmap_test+0x4f0>
    err("close");

  // check that the mapping still works after close(fd).
  _v1(p);
     366:	854e                	mv	a0,s3
     368:	00000097          	auipc	ra,0x0
     36c:	cd6080e7          	jalr	-810(ra) # 3e <_v1>

  // write the mapped memory.
  for (i = 0; i < PGSIZE*2; i++)
     370:	87ce                	mv	a5,s3
     372:	6709                	lui	a4,0x2
     374:	974e                	add	a4,a4,s3
    p[i] = 'Z';
     376:	05a00693          	li	a3,90
     37a:	00d78023          	sb	a3,0(a5)
  for (i = 0; i < PGSIZE*2; i++)
     37e:	0785                	addi	a5,a5,1
     380:	fee79de3          	bne	a5,a4,37a <mmap_test+0x1fa>

  // unmap just the first two of three pages of mapped memory.
  if (munmap(p, PGSIZE*2) == -1)
     384:	6589                	lui	a1,0x2
     386:	854e                	mv	a0,s3
     388:	00001097          	auipc	ra,0x1
     38c:	8c6080e7          	jalr	-1850(ra) # c4e <munmap>
     390:	57fd                	li	a5,-1
     392:	2ef50763          	beq	a0,a5,680 <mmap_test+0x500>
    err("munmap (3)");
  
  printf("test mmap read/write: OK\n");
     396:	00001517          	auipc	a0,0x1
     39a:	f5a50513          	addi	a0,a0,-166 # 12f0 <malloc+0x304>
     39e:	00001097          	auipc	ra,0x1
     3a2:	b90080e7          	jalr	-1136(ra) # f2e <printf>
  
  printf("test mmap dirty\n");
     3a6:	00001517          	auipc	a0,0x1
     3aa:	f6a50513          	addi	a0,a0,-150 # 1310 <malloc+0x324>
     3ae:	00001097          	auipc	ra,0x1
     3b2:	b80080e7          	jalr	-1152(ra) # f2e <printf>
  
  // check that the writes to the mapped memory were
  // written to the file.
  if ((fd = open(f, O_RDWR)) == -1)
     3b6:	4589                	li	a1,2
     3b8:	00001517          	auipc	a0,0x1
     3bc:	e0050513          	addi	a0,a0,-512 # 11b8 <malloc+0x1cc>
     3c0:	00001097          	auipc	ra,0x1
     3c4:	826080e7          	jalr	-2010(ra) # be6 <open>
     3c8:	892a                	mv	s2,a0
     3ca:	57fd                	li	a5,-1
     3cc:	6489                	lui	s1,0x2
     3ce:	80048493          	addi	s1,s1,-2048 # 1800 <buf+0x250>
    err("open");
  for (i = 0; i < PGSIZE + (PGSIZE/2); i++){
    char b;
    if (read(fd, &b, 1) != 1)
      err("read (1)");
    if (b != 'Z')
     3d2:	05a00a13          	li	s4,90
  if ((fd = open(f, O_RDWR)) == -1)
     3d6:	2af50d63          	beq	a0,a5,690 <mmap_test+0x510>
    if (read(fd, &b, 1) != 1)
     3da:	4605                	li	a2,1
     3dc:	fcf40593          	addi	a1,s0,-49
     3e0:	854a                	mv	a0,s2
     3e2:	00000097          	auipc	ra,0x0
     3e6:	7dc080e7          	jalr	2012(ra) # bbe <read>
     3ea:	4785                	li	a5,1
     3ec:	2af51a63          	bne	a0,a5,6a0 <mmap_test+0x520>
    if (b != 'Z')
     3f0:	fcf44783          	lbu	a5,-49(s0)
     3f4:	2b479e63          	bne	a5,s4,6b0 <mmap_test+0x530>
  for (i = 0; i < PGSIZE + (PGSIZE/2); i++){
     3f8:	34fd                	addiw	s1,s1,-1
     3fa:	f0e5                	bnez	s1,3da <mmap_test+0x25a>
      err("file does not contain modifications");
  }
  if (close(fd) == -1)
     3fc:	854a                	mv	a0,s2
     3fe:	00000097          	auipc	ra,0x0
     402:	7d0080e7          	jalr	2000(ra) # bce <close>
     406:	57fd                	li	a5,-1
     408:	2af50c63          	beq	a0,a5,6c0 <mmap_test+0x540>
    err("close");

  printf("test mmap dirty: OK\n");
     40c:	00001517          	auipc	a0,0x1
     410:	f5450513          	addi	a0,a0,-172 # 1360 <malloc+0x374>
     414:	00001097          	auipc	ra,0x1
     418:	b1a080e7          	jalr	-1254(ra) # f2e <printf>

  printf("test not-mapped unmap\n");
     41c:	00001517          	auipc	a0,0x1
     420:	f5c50513          	addi	a0,a0,-164 # 1378 <malloc+0x38c>
     424:	00001097          	auipc	ra,0x1
     428:	b0a080e7          	jalr	-1270(ra) # f2e <printf>
  
  // unmap the rest of the mapped memory.
  if (munmap(p+PGSIZE*2, PGSIZE) == -1)
     42c:	6585                	lui	a1,0x1
     42e:	6509                	lui	a0,0x2
     430:	954e                	add	a0,a0,s3
     432:	00001097          	auipc	ra,0x1
     436:	81c080e7          	jalr	-2020(ra) # c4e <munmap>
     43a:	57fd                	li	a5,-1
     43c:	28f50a63          	beq	a0,a5,6d0 <mmap_test+0x550>
    err("munmap (4)");

  printf("test not-mapped unmap: OK\n");
     440:	00001517          	auipc	a0,0x1
     444:	f6050513          	addi	a0,a0,-160 # 13a0 <malloc+0x3b4>
     448:	00001097          	auipc	ra,0x1
     44c:	ae6080e7          	jalr	-1306(ra) # f2e <printf>
    
  printf("test mmap two files\n");
     450:	00001517          	auipc	a0,0x1
     454:	f7050513          	addi	a0,a0,-144 # 13c0 <malloc+0x3d4>
     458:	00001097          	auipc	ra,0x1
     45c:	ad6080e7          	jalr	-1322(ra) # f2e <printf>
  
  //
  // mmap two files at the same time.
  //
  int fd1;
  if((fd1 = open("mmap1", O_RDWR|O_CREATE)) < 0)
     460:	20200593          	li	a1,514
     464:	00001517          	auipc	a0,0x1
     468:	f7450513          	addi	a0,a0,-140 # 13d8 <malloc+0x3ec>
     46c:	00000097          	auipc	ra,0x0
     470:	77a080e7          	jalr	1914(ra) # be6 <open>
     474:	84aa                	mv	s1,a0
     476:	26054563          	bltz	a0,6e0 <mmap_test+0x560>
    err("open mmap1");
  if(write(fd1, "12345", 5) != 5)
     47a:	4615                	li	a2,5
     47c:	00001597          	auipc	a1,0x1
     480:	f7458593          	addi	a1,a1,-140 # 13f0 <malloc+0x404>
     484:	00000097          	auipc	ra,0x0
     488:	742080e7          	jalr	1858(ra) # bc6 <write>
     48c:	4795                	li	a5,5
     48e:	26f51163          	bne	a0,a5,6f0 <mmap_test+0x570>
    err("write mmap1");
  char *p1 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd1, 0);
     492:	4781                	li	a5,0
     494:	8726                	mv	a4,s1
     496:	4689                	li	a3,2
     498:	4605                	li	a2,1
     49a:	6585                	lui	a1,0x1
     49c:	4501                	li	a0,0
     49e:	00000097          	auipc	ra,0x0
     4a2:	7a8080e7          	jalr	1960(ra) # c46 <mmap>
     4a6:	89aa                	mv	s3,a0
  if(p1 == MAP_FAILED)
     4a8:	57fd                	li	a5,-1
     4aa:	24f50b63          	beq	a0,a5,700 <mmap_test+0x580>
    err("mmap mmap1");
  close(fd1);
     4ae:	8526                	mv	a0,s1
     4b0:	00000097          	auipc	ra,0x0
     4b4:	71e080e7          	jalr	1822(ra) # bce <close>
  unlink("mmap1");
     4b8:	00001517          	auipc	a0,0x1
     4bc:	f2050513          	addi	a0,a0,-224 # 13d8 <malloc+0x3ec>
     4c0:	00000097          	auipc	ra,0x0
     4c4:	736080e7          	jalr	1846(ra) # bf6 <unlink>

  int fd2;
  if((fd2 = open("mmap2", O_RDWR|O_CREATE)) < 0)
     4c8:	20200593          	li	a1,514
     4cc:	00001517          	auipc	a0,0x1
     4d0:	f4c50513          	addi	a0,a0,-180 # 1418 <malloc+0x42c>
     4d4:	00000097          	auipc	ra,0x0
     4d8:	712080e7          	jalr	1810(ra) # be6 <open>
     4dc:	892a                	mv	s2,a0
     4de:	22054963          	bltz	a0,710 <mmap_test+0x590>
    err("open mmap2");
  if(write(fd2, "67890", 5) != 5)
     4e2:	4615                	li	a2,5
     4e4:	00001597          	auipc	a1,0x1
     4e8:	f4c58593          	addi	a1,a1,-180 # 1430 <malloc+0x444>
     4ec:	00000097          	auipc	ra,0x0
     4f0:	6da080e7          	jalr	1754(ra) # bc6 <write>
     4f4:	4795                	li	a5,5
     4f6:	22f51563          	bne	a0,a5,720 <mmap_test+0x5a0>
    err("write mmap2");
  char *p2 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd2, 0);
     4fa:	4781                	li	a5,0
     4fc:	874a                	mv	a4,s2
     4fe:	4689                	li	a3,2
     500:	4605                	li	a2,1
     502:	6585                	lui	a1,0x1
     504:	4501                	li	a0,0
     506:	00000097          	auipc	ra,0x0
     50a:	740080e7          	jalr	1856(ra) # c46 <mmap>
     50e:	84aa                	mv	s1,a0
  if(p2 == MAP_FAILED)
     510:	57fd                	li	a5,-1
     512:	20f50f63          	beq	a0,a5,730 <mmap_test+0x5b0>
    err("mmap mmap2");
  close(fd2);
     516:	854a                	mv	a0,s2
     518:	00000097          	auipc	ra,0x0
     51c:	6b6080e7          	jalr	1718(ra) # bce <close>
  unlink("mmap2");
     520:	00001517          	auipc	a0,0x1
     524:	ef850513          	addi	a0,a0,-264 # 1418 <malloc+0x42c>
     528:	00000097          	auipc	ra,0x0
     52c:	6ce080e7          	jalr	1742(ra) # bf6 <unlink>

  if(memcmp(p1, "12345", 5) != 0)
     530:	4615                	li	a2,5
     532:	00001597          	auipc	a1,0x1
     536:	ebe58593          	addi	a1,a1,-322 # 13f0 <malloc+0x404>
     53a:	854e                	mv	a0,s3
     53c:	00000097          	auipc	ra,0x0
     540:	610080e7          	jalr	1552(ra) # b4c <memcmp>
     544:	1e051e63          	bnez	a0,740 <mmap_test+0x5c0>
    err("mmap1 mismatch");
  if(memcmp(p2, "67890", 5) != 0)
     548:	4615                	li	a2,5
     54a:	00001597          	auipc	a1,0x1
     54e:	ee658593          	addi	a1,a1,-282 # 1430 <malloc+0x444>
     552:	8526                	mv	a0,s1
     554:	00000097          	auipc	ra,0x0
     558:	5f8080e7          	jalr	1528(ra) # b4c <memcmp>
     55c:	1e051a63          	bnez	a0,750 <mmap_test+0x5d0>
    err("mmap2 mismatch");

  munmap(p1, PGSIZE);
     560:	6585                	lui	a1,0x1
     562:	854e                	mv	a0,s3
     564:	00000097          	auipc	ra,0x0
     568:	6ea080e7          	jalr	1770(ra) # c4e <munmap>
  if(memcmp(p2, "67890", 5) != 0)
     56c:	4615                	li	a2,5
     56e:	00001597          	auipc	a1,0x1
     572:	ec258593          	addi	a1,a1,-318 # 1430 <malloc+0x444>
     576:	8526                	mv	a0,s1
     578:	00000097          	auipc	ra,0x0
     57c:	5d4080e7          	jalr	1492(ra) # b4c <memcmp>
     580:	1e051063          	bnez	a0,760 <mmap_test+0x5e0>
    err("mmap2 mismatch (2)");
  munmap(p2, PGSIZE);
     584:	6585                	lui	a1,0x1
     586:	8526                	mv	a0,s1
     588:	00000097          	auipc	ra,0x0
     58c:	6c6080e7          	jalr	1734(ra) # c4e <munmap>
  
  printf("test mmap two files: OK\n");
     590:	00001517          	auipc	a0,0x1
     594:	f0050513          	addi	a0,a0,-256 # 1490 <malloc+0x4a4>
     598:	00001097          	auipc	ra,0x1
     59c:	996080e7          	jalr	-1642(ra) # f2e <printf>
  
  printf("mmap_test: ALL OK\n");
     5a0:	00001517          	auipc	a0,0x1
     5a4:	f1050513          	addi	a0,a0,-240 # 14b0 <malloc+0x4c4>
     5a8:	00001097          	auipc	ra,0x1
     5ac:	986080e7          	jalr	-1658(ra) # f2e <printf>
}
     5b0:	70e2                	ld	ra,56(sp)
     5b2:	7442                	ld	s0,48(sp)
     5b4:	74a2                	ld	s1,40(sp)
     5b6:	7902                	ld	s2,32(sp)
     5b8:	69e2                	ld	s3,24(sp)
     5ba:	6a42                	ld	s4,16(sp)
     5bc:	6121                	addi	sp,sp,64
     5be:	8082                	ret
    err("open");
     5c0:	00001517          	auipc	a0,0x1
     5c4:	ba850513          	addi	a0,a0,-1112 # 1168 <malloc+0x17c>
     5c8:	00000097          	auipc	ra,0x0
     5cc:	a38080e7          	jalr	-1480(ra) # 0 <err>
    err("mmap (1)");
     5d0:	00001517          	auipc	a0,0x1
     5d4:	c0850513          	addi	a0,a0,-1016 # 11d8 <malloc+0x1ec>
     5d8:	00000097          	auipc	ra,0x0
     5dc:	a28080e7          	jalr	-1496(ra) # 0 <err>
    err("munmap (1)");
     5e0:	00001517          	auipc	a0,0x1
     5e4:	c0850513          	addi	a0,a0,-1016 # 11e8 <malloc+0x1fc>
     5e8:	00000097          	auipc	ra,0x0
     5ec:	a18080e7          	jalr	-1512(ra) # 0 <err>
    err("mmap (2)");
     5f0:	00001517          	auipc	a0,0x1
     5f4:	c3850513          	addi	a0,a0,-968 # 1228 <malloc+0x23c>
     5f8:	00000097          	auipc	ra,0x0
     5fc:	a08080e7          	jalr	-1528(ra) # 0 <err>
    err("close");
     600:	00001517          	auipc	a0,0x1
     604:	b8850513          	addi	a0,a0,-1144 # 1188 <malloc+0x19c>
     608:	00000097          	auipc	ra,0x0
     60c:	9f8080e7          	jalr	-1544(ra) # 0 <err>
    err("munmap (2)");
     610:	00001517          	auipc	a0,0x1
     614:	c2850513          	addi	a0,a0,-984 # 1238 <malloc+0x24c>
     618:	00000097          	auipc	ra,0x0
     61c:	9e8080e7          	jalr	-1560(ra) # 0 <err>
    err("open");
     620:	00001517          	auipc	a0,0x1
     624:	b4850513          	addi	a0,a0,-1208 # 1168 <malloc+0x17c>
     628:	00000097          	auipc	ra,0x0
     62c:	9d8080e7          	jalr	-1576(ra) # 0 <err>
    err("mmap call should have failed");
     630:	00001517          	auipc	a0,0x1
     634:	c4850513          	addi	a0,a0,-952 # 1278 <malloc+0x28c>
     638:	00000097          	auipc	ra,0x0
     63c:	9c8080e7          	jalr	-1592(ra) # 0 <err>
    err("close");
     640:	00001517          	auipc	a0,0x1
     644:	b4850513          	addi	a0,a0,-1208 # 1188 <malloc+0x19c>
     648:	00000097          	auipc	ra,0x0
     64c:	9b8080e7          	jalr	-1608(ra) # 0 <err>
    err("open");
     650:	00001517          	auipc	a0,0x1
     654:	b1850513          	addi	a0,a0,-1256 # 1168 <malloc+0x17c>
     658:	00000097          	auipc	ra,0x0
     65c:	9a8080e7          	jalr	-1624(ra) # 0 <err>
    err("mmap (3)");
     660:	00001517          	auipc	a0,0x1
     664:	c7050513          	addi	a0,a0,-912 # 12d0 <malloc+0x2e4>
     668:	00000097          	auipc	ra,0x0
     66c:	998080e7          	jalr	-1640(ra) # 0 <err>
    err("close");
     670:	00001517          	auipc	a0,0x1
     674:	b1850513          	addi	a0,a0,-1256 # 1188 <malloc+0x19c>
     678:	00000097          	auipc	ra,0x0
     67c:	988080e7          	jalr	-1656(ra) # 0 <err>
    err("munmap (3)");
     680:	00001517          	auipc	a0,0x1
     684:	c6050513          	addi	a0,a0,-928 # 12e0 <malloc+0x2f4>
     688:	00000097          	auipc	ra,0x0
     68c:	978080e7          	jalr	-1672(ra) # 0 <err>
    err("open");
     690:	00001517          	auipc	a0,0x1
     694:	ad850513          	addi	a0,a0,-1320 # 1168 <malloc+0x17c>
     698:	00000097          	auipc	ra,0x0
     69c:	968080e7          	jalr	-1688(ra) # 0 <err>
      err("read (1)");
     6a0:	00001517          	auipc	a0,0x1
     6a4:	c8850513          	addi	a0,a0,-888 # 1328 <malloc+0x33c>
     6a8:	00000097          	auipc	ra,0x0
     6ac:	958080e7          	jalr	-1704(ra) # 0 <err>
      err("file does not contain modifications");
     6b0:	00001517          	auipc	a0,0x1
     6b4:	c8850513          	addi	a0,a0,-888 # 1338 <malloc+0x34c>
     6b8:	00000097          	auipc	ra,0x0
     6bc:	948080e7          	jalr	-1720(ra) # 0 <err>
    err("close");
     6c0:	00001517          	auipc	a0,0x1
     6c4:	ac850513          	addi	a0,a0,-1336 # 1188 <malloc+0x19c>
     6c8:	00000097          	auipc	ra,0x0
     6cc:	938080e7          	jalr	-1736(ra) # 0 <err>
    err("munmap (4)");
     6d0:	00001517          	auipc	a0,0x1
     6d4:	cc050513          	addi	a0,a0,-832 # 1390 <malloc+0x3a4>
     6d8:	00000097          	auipc	ra,0x0
     6dc:	928080e7          	jalr	-1752(ra) # 0 <err>
    err("open mmap1");
     6e0:	00001517          	auipc	a0,0x1
     6e4:	d0050513          	addi	a0,a0,-768 # 13e0 <malloc+0x3f4>
     6e8:	00000097          	auipc	ra,0x0
     6ec:	918080e7          	jalr	-1768(ra) # 0 <err>
    err("write mmap1");
     6f0:	00001517          	auipc	a0,0x1
     6f4:	d0850513          	addi	a0,a0,-760 # 13f8 <malloc+0x40c>
     6f8:	00000097          	auipc	ra,0x0
     6fc:	908080e7          	jalr	-1784(ra) # 0 <err>
    err("mmap mmap1");
     700:	00001517          	auipc	a0,0x1
     704:	d0850513          	addi	a0,a0,-760 # 1408 <malloc+0x41c>
     708:	00000097          	auipc	ra,0x0
     70c:	8f8080e7          	jalr	-1800(ra) # 0 <err>
    err("open mmap2");
     710:	00001517          	auipc	a0,0x1
     714:	d1050513          	addi	a0,a0,-752 # 1420 <malloc+0x434>
     718:	00000097          	auipc	ra,0x0
     71c:	8e8080e7          	jalr	-1816(ra) # 0 <err>
    err("write mmap2");
     720:	00001517          	auipc	a0,0x1
     724:	d1850513          	addi	a0,a0,-744 # 1438 <malloc+0x44c>
     728:	00000097          	auipc	ra,0x0
     72c:	8d8080e7          	jalr	-1832(ra) # 0 <err>
    err("mmap mmap2");
     730:	00001517          	auipc	a0,0x1
     734:	d1850513          	addi	a0,a0,-744 # 1448 <malloc+0x45c>
     738:	00000097          	auipc	ra,0x0
     73c:	8c8080e7          	jalr	-1848(ra) # 0 <err>
    err("mmap1 mismatch");
     740:	00001517          	auipc	a0,0x1
     744:	d1850513          	addi	a0,a0,-744 # 1458 <malloc+0x46c>
     748:	00000097          	auipc	ra,0x0
     74c:	8b8080e7          	jalr	-1864(ra) # 0 <err>
    err("mmap2 mismatch");
     750:	00001517          	auipc	a0,0x1
     754:	d1850513          	addi	a0,a0,-744 # 1468 <malloc+0x47c>
     758:	00000097          	auipc	ra,0x0
     75c:	8a8080e7          	jalr	-1880(ra) # 0 <err>
    err("mmap2 mismatch (2)");
     760:	00001517          	auipc	a0,0x1
     764:	d1850513          	addi	a0,a0,-744 # 1478 <malloc+0x48c>
     768:	00000097          	auipc	ra,0x0
     76c:	898080e7          	jalr	-1896(ra) # 0 <err>

0000000000000770 <fork_test>:
// mmap a file, then fork.
// check that the child sees the mapped file.
//
void
fork_test(void)
{
     770:	7179                	addi	sp,sp,-48
     772:	f406                	sd	ra,40(sp)
     774:	f022                	sd	s0,32(sp)
     776:	ec26                	sd	s1,24(sp)
     778:	e84a                	sd	s2,16(sp)
     77a:	1800                	addi	s0,sp,48
  int fd;
  int pid;
  const char * const f = "mmap.dur";
  
  printf("fork_test starting\n");
     77c:	00001517          	auipc	a0,0x1
     780:	d4c50513          	addi	a0,a0,-692 # 14c8 <malloc+0x4dc>
     784:	00000097          	auipc	ra,0x0
     788:	7aa080e7          	jalr	1962(ra) # f2e <printf>
  testname = "fork_test";
     78c:	00001797          	auipc	a5,0x1
     790:	d5478793          	addi	a5,a5,-684 # 14e0 <malloc+0x4f4>
     794:	00001717          	auipc	a4,0x1
     798:	e0f73623          	sd	a5,-500(a4) # 15a0 <testname>
  
  // mmap the file twice.
  makefile(f);
     79c:	00001517          	auipc	a0,0x1
     7a0:	a1c50513          	addi	a0,a0,-1508 # 11b8 <malloc+0x1cc>
     7a4:	00000097          	auipc	ra,0x0
     7a8:	922080e7          	jalr	-1758(ra) # c6 <makefile>
  if ((fd = open(f, O_RDONLY)) == -1)
     7ac:	4581                	li	a1,0
     7ae:	00001517          	auipc	a0,0x1
     7b2:	a0a50513          	addi	a0,a0,-1526 # 11b8 <malloc+0x1cc>
     7b6:	00000097          	auipc	ra,0x0
     7ba:	430080e7          	jalr	1072(ra) # be6 <open>
     7be:	57fd                	li	a5,-1
     7c0:	0af50a63          	beq	a0,a5,874 <fork_test+0x104>
     7c4:	84aa                	mv	s1,a0
    err("open");
  unlink(f);
     7c6:	00001517          	auipc	a0,0x1
     7ca:	9f250513          	addi	a0,a0,-1550 # 11b8 <malloc+0x1cc>
     7ce:	00000097          	auipc	ra,0x0
     7d2:	428080e7          	jalr	1064(ra) # bf6 <unlink>
  char *p1 = mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
     7d6:	4781                	li	a5,0
     7d8:	8726                	mv	a4,s1
     7da:	4685                	li	a3,1
     7dc:	4605                	li	a2,1
     7de:	6589                	lui	a1,0x2
     7e0:	4501                	li	a0,0
     7e2:	00000097          	auipc	ra,0x0
     7e6:	464080e7          	jalr	1124(ra) # c46 <mmap>
     7ea:	892a                	mv	s2,a0
  if (p1 == MAP_FAILED)
     7ec:	57fd                	li	a5,-1
     7ee:	08f50b63          	beq	a0,a5,884 <fork_test+0x114>
    err("mmap (4)");
  char *p2 = mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
     7f2:	4781                	li	a5,0
     7f4:	8726                	mv	a4,s1
     7f6:	4685                	li	a3,1
     7f8:	4605                	li	a2,1
     7fa:	6589                	lui	a1,0x2
     7fc:	4501                	li	a0,0
     7fe:	00000097          	auipc	ra,0x0
     802:	448080e7          	jalr	1096(ra) # c46 <mmap>
     806:	84aa                	mv	s1,a0
  if (p2 == MAP_FAILED)
     808:	57fd                	li	a5,-1
     80a:	08f50563          	beq	a0,a5,894 <fork_test+0x124>
    err("mmap (5)");

  // read just 2nd page.
  if(*(p1+PGSIZE) != 'A')
     80e:	6785                	lui	a5,0x1
     810:	97ca                	add	a5,a5,s2
     812:	0007c703          	lbu	a4,0(a5) # 1000 <malloc+0x14>
     816:	04100793          	li	a5,65
     81a:	08f71563          	bne	a4,a5,8a4 <fork_test+0x134>
    err("fork mismatch (1)");

  if((pid = fork()) < 0)
     81e:	00000097          	auipc	ra,0x0
     822:	380080e7          	jalr	896(ra) # b9e <fork>
     826:	08054763          	bltz	a0,8b4 <fork_test+0x144>
    err("fork");
  if (pid == 0) {
     82a:	cd49                	beqz	a0,8c4 <fork_test+0x154>
    _v1(p1);
    munmap(p1, PGSIZE); // just the first page
    exit(0); // tell the parent that the mapping looks OK.
  }

  int status = -1;
     82c:	57fd                	li	a5,-1
     82e:	fcf42e23          	sw	a5,-36(s0)
  wait(&status);
     832:	fdc40513          	addi	a0,s0,-36
     836:	00000097          	auipc	ra,0x0
     83a:	378080e7          	jalr	888(ra) # bae <wait>

  if(status != 0){
     83e:	fdc42783          	lw	a5,-36(s0)
     842:	e3cd                	bnez	a5,8e4 <fork_test+0x174>
    printf("fork_test failed\n");
    exit(1);
  }

  // check that the parent's mappings are still there.
  _v1(p1);
     844:	854a                	mv	a0,s2
     846:	fffff097          	auipc	ra,0xfffff
     84a:	7f8080e7          	jalr	2040(ra) # 3e <_v1>
  _v1(p2);
     84e:	8526                	mv	a0,s1
     850:	fffff097          	auipc	ra,0xfffff
     854:	7ee080e7          	jalr	2030(ra) # 3e <_v1>

  printf("fork_test OK\n");
     858:	00001517          	auipc	a0,0x1
     85c:	cf050513          	addi	a0,a0,-784 # 1548 <malloc+0x55c>
     860:	00000097          	auipc	ra,0x0
     864:	6ce080e7          	jalr	1742(ra) # f2e <printf>
}
     868:	70a2                	ld	ra,40(sp)
     86a:	7402                	ld	s0,32(sp)
     86c:	64e2                	ld	s1,24(sp)
     86e:	6942                	ld	s2,16(sp)
     870:	6145                	addi	sp,sp,48
     872:	8082                	ret
    err("open");
     874:	00001517          	auipc	a0,0x1
     878:	8f450513          	addi	a0,a0,-1804 # 1168 <malloc+0x17c>
     87c:	fffff097          	auipc	ra,0xfffff
     880:	784080e7          	jalr	1924(ra) # 0 <err>
    err("mmap (4)");
     884:	00001517          	auipc	a0,0x1
     888:	c6c50513          	addi	a0,a0,-916 # 14f0 <malloc+0x504>
     88c:	fffff097          	auipc	ra,0xfffff
     890:	774080e7          	jalr	1908(ra) # 0 <err>
    err("mmap (5)");
     894:	00001517          	auipc	a0,0x1
     898:	c6c50513          	addi	a0,a0,-916 # 1500 <malloc+0x514>
     89c:	fffff097          	auipc	ra,0xfffff
     8a0:	764080e7          	jalr	1892(ra) # 0 <err>
    err("fork mismatch (1)");
     8a4:	00001517          	auipc	a0,0x1
     8a8:	c6c50513          	addi	a0,a0,-916 # 1510 <malloc+0x524>
     8ac:	fffff097          	auipc	ra,0xfffff
     8b0:	754080e7          	jalr	1876(ra) # 0 <err>
    err("fork");
     8b4:	00001517          	auipc	a0,0x1
     8b8:	c7450513          	addi	a0,a0,-908 # 1528 <malloc+0x53c>
     8bc:	fffff097          	auipc	ra,0xfffff
     8c0:	744080e7          	jalr	1860(ra) # 0 <err>
    _v1(p1);
     8c4:	854a                	mv	a0,s2
     8c6:	fffff097          	auipc	ra,0xfffff
     8ca:	778080e7          	jalr	1912(ra) # 3e <_v1>
    munmap(p1, PGSIZE); // just the first page
     8ce:	6585                	lui	a1,0x1
     8d0:	854a                	mv	a0,s2
     8d2:	00000097          	auipc	ra,0x0
     8d6:	37c080e7          	jalr	892(ra) # c4e <munmap>
    exit(0); // tell the parent that the mapping looks OK.
     8da:	4501                	li	a0,0
     8dc:	00000097          	auipc	ra,0x0
     8e0:	2ca080e7          	jalr	714(ra) # ba6 <exit>
    printf("fork_test failed\n");
     8e4:	00001517          	auipc	a0,0x1
     8e8:	c4c50513          	addi	a0,a0,-948 # 1530 <malloc+0x544>
     8ec:	00000097          	auipc	ra,0x0
     8f0:	642080e7          	jalr	1602(ra) # f2e <printf>
    exit(1);
     8f4:	4505                	li	a0,1
     8f6:	00000097          	auipc	ra,0x0
     8fa:	2b0080e7          	jalr	688(ra) # ba6 <exit>

00000000000008fe <main>:
{
     8fe:	1141                	addi	sp,sp,-16
     900:	e406                	sd	ra,8(sp)
     902:	e022                	sd	s0,0(sp)
     904:	0800                	addi	s0,sp,16
  mmap_test();
     906:	00000097          	auipc	ra,0x0
     90a:	87a080e7          	jalr	-1926(ra) # 180 <mmap_test>
  fork_test();
     90e:	00000097          	auipc	ra,0x0
     912:	e62080e7          	jalr	-414(ra) # 770 <fork_test>
  printf("mmaptest: all tests succeeded\n");
     916:	00001517          	auipc	a0,0x1
     91a:	c4250513          	addi	a0,a0,-958 # 1558 <malloc+0x56c>
     91e:	00000097          	auipc	ra,0x0
     922:	610080e7          	jalr	1552(ra) # f2e <printf>
  exit(0);
     926:	4501                	li	a0,0
     928:	00000097          	auipc	ra,0x0
     92c:	27e080e7          	jalr	638(ra) # ba6 <exit>

0000000000000930 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     930:	1141                	addi	sp,sp,-16
     932:	e422                	sd	s0,8(sp)
     934:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     936:	87aa                	mv	a5,a0
     938:	0585                	addi	a1,a1,1
     93a:	0785                	addi	a5,a5,1
     93c:	fff5c703          	lbu	a4,-1(a1) # fff <malloc+0x13>
     940:	fee78fa3          	sb	a4,-1(a5)
     944:	fb75                	bnez	a4,938 <strcpy+0x8>
    ;
  return os;
}
     946:	6422                	ld	s0,8(sp)
     948:	0141                	addi	sp,sp,16
     94a:	8082                	ret

000000000000094c <strcmp>:

int
strcmp(const char *p, const char *q)
{
     94c:	1141                	addi	sp,sp,-16
     94e:	e422                	sd	s0,8(sp)
     950:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     952:	00054783          	lbu	a5,0(a0)
     956:	cb91                	beqz	a5,96a <strcmp+0x1e>
     958:	0005c703          	lbu	a4,0(a1)
     95c:	00f71763          	bne	a4,a5,96a <strcmp+0x1e>
    p++, q++;
     960:	0505                	addi	a0,a0,1
     962:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     964:	00054783          	lbu	a5,0(a0)
     968:	fbe5                	bnez	a5,958 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     96a:	0005c503          	lbu	a0,0(a1)
}
     96e:	40a7853b          	subw	a0,a5,a0
     972:	6422                	ld	s0,8(sp)
     974:	0141                	addi	sp,sp,16
     976:	8082                	ret

0000000000000978 <strlen>:

uint
strlen(const char *s)
{
     978:	1141                	addi	sp,sp,-16
     97a:	e422                	sd	s0,8(sp)
     97c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     97e:	00054783          	lbu	a5,0(a0)
     982:	cf91                	beqz	a5,99e <strlen+0x26>
     984:	0505                	addi	a0,a0,1
     986:	87aa                	mv	a5,a0
     988:	4685                	li	a3,1
     98a:	9e89                	subw	a3,a3,a0
     98c:	00f6853b          	addw	a0,a3,a5
     990:	0785                	addi	a5,a5,1
     992:	fff7c703          	lbu	a4,-1(a5)
     996:	fb7d                	bnez	a4,98c <strlen+0x14>
    ;
  return n;
}
     998:	6422                	ld	s0,8(sp)
     99a:	0141                	addi	sp,sp,16
     99c:	8082                	ret
  for(n = 0; s[n]; n++)
     99e:	4501                	li	a0,0
     9a0:	bfe5                	j	998 <strlen+0x20>

00000000000009a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
     9a2:	1141                	addi	sp,sp,-16
     9a4:	e422                	sd	s0,8(sp)
     9a6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     9a8:	ce09                	beqz	a2,9c2 <memset+0x20>
     9aa:	87aa                	mv	a5,a0
     9ac:	fff6071b          	addiw	a4,a2,-1
     9b0:	1702                	slli	a4,a4,0x20
     9b2:	9301                	srli	a4,a4,0x20
     9b4:	0705                	addi	a4,a4,1
     9b6:	972a                	add	a4,a4,a0
    cdst[i] = c;
     9b8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     9bc:	0785                	addi	a5,a5,1
     9be:	fee79de3          	bne	a5,a4,9b8 <memset+0x16>
  }
  return dst;
}
     9c2:	6422                	ld	s0,8(sp)
     9c4:	0141                	addi	sp,sp,16
     9c6:	8082                	ret

00000000000009c8 <strchr>:

char*
strchr(const char *s, char c)
{
     9c8:	1141                	addi	sp,sp,-16
     9ca:	e422                	sd	s0,8(sp)
     9cc:	0800                	addi	s0,sp,16
  for(; *s; s++)
     9ce:	00054783          	lbu	a5,0(a0)
     9d2:	cb99                	beqz	a5,9e8 <strchr+0x20>
    if(*s == c)
     9d4:	00f58763          	beq	a1,a5,9e2 <strchr+0x1a>
  for(; *s; s++)
     9d8:	0505                	addi	a0,a0,1
     9da:	00054783          	lbu	a5,0(a0)
     9de:	fbfd                	bnez	a5,9d4 <strchr+0xc>
      return (char*)s;
  return 0;
     9e0:	4501                	li	a0,0
}
     9e2:	6422                	ld	s0,8(sp)
     9e4:	0141                	addi	sp,sp,16
     9e6:	8082                	ret
  return 0;
     9e8:	4501                	li	a0,0
     9ea:	bfe5                	j	9e2 <strchr+0x1a>

00000000000009ec <gets>:

char*
gets(char *buf, int max)
{
     9ec:	711d                	addi	sp,sp,-96
     9ee:	ec86                	sd	ra,88(sp)
     9f0:	e8a2                	sd	s0,80(sp)
     9f2:	e4a6                	sd	s1,72(sp)
     9f4:	e0ca                	sd	s2,64(sp)
     9f6:	fc4e                	sd	s3,56(sp)
     9f8:	f852                	sd	s4,48(sp)
     9fa:	f456                	sd	s5,40(sp)
     9fc:	f05a                	sd	s6,32(sp)
     9fe:	ec5e                	sd	s7,24(sp)
     a00:	1080                	addi	s0,sp,96
     a02:	8baa                	mv	s7,a0
     a04:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a06:	892a                	mv	s2,a0
     a08:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a0a:	4aa9                	li	s5,10
     a0c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     a0e:	89a6                	mv	s3,s1
     a10:	2485                	addiw	s1,s1,1
     a12:	0344d863          	bge	s1,s4,a42 <gets+0x56>
    cc = read(0, &c, 1);
     a16:	4605                	li	a2,1
     a18:	faf40593          	addi	a1,s0,-81
     a1c:	4501                	li	a0,0
     a1e:	00000097          	auipc	ra,0x0
     a22:	1a0080e7          	jalr	416(ra) # bbe <read>
    if(cc < 1)
     a26:	00a05e63          	blez	a0,a42 <gets+0x56>
    buf[i++] = c;
     a2a:	faf44783          	lbu	a5,-81(s0)
     a2e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     a32:	01578763          	beq	a5,s5,a40 <gets+0x54>
     a36:	0905                	addi	s2,s2,1
     a38:	fd679be3          	bne	a5,s6,a0e <gets+0x22>
  for(i=0; i+1 < max; ){
     a3c:	89a6                	mv	s3,s1
     a3e:	a011                	j	a42 <gets+0x56>
     a40:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     a42:	99de                	add	s3,s3,s7
     a44:	00098023          	sb	zero,0(s3)
  return buf;
}
     a48:	855e                	mv	a0,s7
     a4a:	60e6                	ld	ra,88(sp)
     a4c:	6446                	ld	s0,80(sp)
     a4e:	64a6                	ld	s1,72(sp)
     a50:	6906                	ld	s2,64(sp)
     a52:	79e2                	ld	s3,56(sp)
     a54:	7a42                	ld	s4,48(sp)
     a56:	7aa2                	ld	s5,40(sp)
     a58:	7b02                	ld	s6,32(sp)
     a5a:	6be2                	ld	s7,24(sp)
     a5c:	6125                	addi	sp,sp,96
     a5e:	8082                	ret

0000000000000a60 <stat>:

int
stat(const char *n, struct stat *st)
{
     a60:	1101                	addi	sp,sp,-32
     a62:	ec06                	sd	ra,24(sp)
     a64:	e822                	sd	s0,16(sp)
     a66:	e426                	sd	s1,8(sp)
     a68:	e04a                	sd	s2,0(sp)
     a6a:	1000                	addi	s0,sp,32
     a6c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a6e:	4581                	li	a1,0
     a70:	00000097          	auipc	ra,0x0
     a74:	176080e7          	jalr	374(ra) # be6 <open>
  if(fd < 0)
     a78:	02054563          	bltz	a0,aa2 <stat+0x42>
     a7c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a7e:	85ca                	mv	a1,s2
     a80:	00000097          	auipc	ra,0x0
     a84:	17e080e7          	jalr	382(ra) # bfe <fstat>
     a88:	892a                	mv	s2,a0
  close(fd);
     a8a:	8526                	mv	a0,s1
     a8c:	00000097          	auipc	ra,0x0
     a90:	142080e7          	jalr	322(ra) # bce <close>
  return r;
}
     a94:	854a                	mv	a0,s2
     a96:	60e2                	ld	ra,24(sp)
     a98:	6442                	ld	s0,16(sp)
     a9a:	64a2                	ld	s1,8(sp)
     a9c:	6902                	ld	s2,0(sp)
     a9e:	6105                	addi	sp,sp,32
     aa0:	8082                	ret
    return -1;
     aa2:	597d                	li	s2,-1
     aa4:	bfc5                	j	a94 <stat+0x34>

0000000000000aa6 <atoi>:

int
atoi(const char *s)
{
     aa6:	1141                	addi	sp,sp,-16
     aa8:	e422                	sd	s0,8(sp)
     aaa:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     aac:	00054603          	lbu	a2,0(a0)
     ab0:	fd06079b          	addiw	a5,a2,-48
     ab4:	0ff7f793          	andi	a5,a5,255
     ab8:	4725                	li	a4,9
     aba:	02f76963          	bltu	a4,a5,aec <atoi+0x46>
     abe:	86aa                	mv	a3,a0
  n = 0;
     ac0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     ac2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     ac4:	0685                	addi	a3,a3,1
     ac6:	0025179b          	slliw	a5,a0,0x2
     aca:	9fa9                	addw	a5,a5,a0
     acc:	0017979b          	slliw	a5,a5,0x1
     ad0:	9fb1                	addw	a5,a5,a2
     ad2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     ad6:	0006c603          	lbu	a2,0(a3)
     ada:	fd06071b          	addiw	a4,a2,-48
     ade:	0ff77713          	andi	a4,a4,255
     ae2:	fee5f1e3          	bgeu	a1,a4,ac4 <atoi+0x1e>
  return n;
}
     ae6:	6422                	ld	s0,8(sp)
     ae8:	0141                	addi	sp,sp,16
     aea:	8082                	ret
  n = 0;
     aec:	4501                	li	a0,0
     aee:	bfe5                	j	ae6 <atoi+0x40>

0000000000000af0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     af0:	1141                	addi	sp,sp,-16
     af2:	e422                	sd	s0,8(sp)
     af4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     af6:	02b57663          	bgeu	a0,a1,b22 <memmove+0x32>
    while(n-- > 0)
     afa:	02c05163          	blez	a2,b1c <memmove+0x2c>
     afe:	fff6079b          	addiw	a5,a2,-1
     b02:	1782                	slli	a5,a5,0x20
     b04:	9381                	srli	a5,a5,0x20
     b06:	0785                	addi	a5,a5,1
     b08:	97aa                	add	a5,a5,a0
  dst = vdst;
     b0a:	872a                	mv	a4,a0
      *dst++ = *src++;
     b0c:	0585                	addi	a1,a1,1
     b0e:	0705                	addi	a4,a4,1
     b10:	fff5c683          	lbu	a3,-1(a1)
     b14:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b18:	fee79ae3          	bne	a5,a4,b0c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b1c:	6422                	ld	s0,8(sp)
     b1e:	0141                	addi	sp,sp,16
     b20:	8082                	ret
    dst += n;
     b22:	00c50733          	add	a4,a0,a2
    src += n;
     b26:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b28:	fec05ae3          	blez	a2,b1c <memmove+0x2c>
     b2c:	fff6079b          	addiw	a5,a2,-1
     b30:	1782                	slli	a5,a5,0x20
     b32:	9381                	srli	a5,a5,0x20
     b34:	fff7c793          	not	a5,a5
     b38:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b3a:	15fd                	addi	a1,a1,-1
     b3c:	177d                	addi	a4,a4,-1
     b3e:	0005c683          	lbu	a3,0(a1)
     b42:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b46:	fee79ae3          	bne	a5,a4,b3a <memmove+0x4a>
     b4a:	bfc9                	j	b1c <memmove+0x2c>

0000000000000b4c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b4c:	1141                	addi	sp,sp,-16
     b4e:	e422                	sd	s0,8(sp)
     b50:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     b52:	ca05                	beqz	a2,b82 <memcmp+0x36>
     b54:	fff6069b          	addiw	a3,a2,-1
     b58:	1682                	slli	a3,a3,0x20
     b5a:	9281                	srli	a3,a3,0x20
     b5c:	0685                	addi	a3,a3,1
     b5e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b60:	00054783          	lbu	a5,0(a0)
     b64:	0005c703          	lbu	a4,0(a1)
     b68:	00e79863          	bne	a5,a4,b78 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b6c:	0505                	addi	a0,a0,1
    p2++;
     b6e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b70:	fed518e3          	bne	a0,a3,b60 <memcmp+0x14>
  }
  return 0;
     b74:	4501                	li	a0,0
     b76:	a019                	j	b7c <memcmp+0x30>
      return *p1 - *p2;
     b78:	40e7853b          	subw	a0,a5,a4
}
     b7c:	6422                	ld	s0,8(sp)
     b7e:	0141                	addi	sp,sp,16
     b80:	8082                	ret
  return 0;
     b82:	4501                	li	a0,0
     b84:	bfe5                	j	b7c <memcmp+0x30>

0000000000000b86 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b86:	1141                	addi	sp,sp,-16
     b88:	e406                	sd	ra,8(sp)
     b8a:	e022                	sd	s0,0(sp)
     b8c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b8e:	00000097          	auipc	ra,0x0
     b92:	f62080e7          	jalr	-158(ra) # af0 <memmove>
}
     b96:	60a2                	ld	ra,8(sp)
     b98:	6402                	ld	s0,0(sp)
     b9a:	0141                	addi	sp,sp,16
     b9c:	8082                	ret

0000000000000b9e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b9e:	4885                	li	a7,1
 ecall
     ba0:	00000073          	ecall
 ret
     ba4:	8082                	ret

0000000000000ba6 <exit>:
.global exit
exit:
 li a7, SYS_exit
     ba6:	4889                	li	a7,2
 ecall
     ba8:	00000073          	ecall
 ret
     bac:	8082                	ret

0000000000000bae <wait>:
.global wait
wait:
 li a7, SYS_wait
     bae:	488d                	li	a7,3
 ecall
     bb0:	00000073          	ecall
 ret
     bb4:	8082                	ret

0000000000000bb6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     bb6:	4891                	li	a7,4
 ecall
     bb8:	00000073          	ecall
 ret
     bbc:	8082                	ret

0000000000000bbe <read>:
.global read
read:
 li a7, SYS_read
     bbe:	4895                	li	a7,5
 ecall
     bc0:	00000073          	ecall
 ret
     bc4:	8082                	ret

0000000000000bc6 <write>:
.global write
write:
 li a7, SYS_write
     bc6:	48c1                	li	a7,16
 ecall
     bc8:	00000073          	ecall
 ret
     bcc:	8082                	ret

0000000000000bce <close>:
.global close
close:
 li a7, SYS_close
     bce:	48d5                	li	a7,21
 ecall
     bd0:	00000073          	ecall
 ret
     bd4:	8082                	ret

0000000000000bd6 <kill>:
.global kill
kill:
 li a7, SYS_kill
     bd6:	4899                	li	a7,6
 ecall
     bd8:	00000073          	ecall
 ret
     bdc:	8082                	ret

0000000000000bde <exec>:
.global exec
exec:
 li a7, SYS_exec
     bde:	489d                	li	a7,7
 ecall
     be0:	00000073          	ecall
 ret
     be4:	8082                	ret

0000000000000be6 <open>:
.global open
open:
 li a7, SYS_open
     be6:	48bd                	li	a7,15
 ecall
     be8:	00000073          	ecall
 ret
     bec:	8082                	ret

0000000000000bee <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     bee:	48c5                	li	a7,17
 ecall
     bf0:	00000073          	ecall
 ret
     bf4:	8082                	ret

0000000000000bf6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     bf6:	48c9                	li	a7,18
 ecall
     bf8:	00000073          	ecall
 ret
     bfc:	8082                	ret

0000000000000bfe <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     bfe:	48a1                	li	a7,8
 ecall
     c00:	00000073          	ecall
 ret
     c04:	8082                	ret

0000000000000c06 <link>:
.global link
link:
 li a7, SYS_link
     c06:	48cd                	li	a7,19
 ecall
     c08:	00000073          	ecall
 ret
     c0c:	8082                	ret

0000000000000c0e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c0e:	48d1                	li	a7,20
 ecall
     c10:	00000073          	ecall
 ret
     c14:	8082                	ret

0000000000000c16 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c16:	48a5                	li	a7,9
 ecall
     c18:	00000073          	ecall
 ret
     c1c:	8082                	ret

0000000000000c1e <dup>:
.global dup
dup:
 li a7, SYS_dup
     c1e:	48a9                	li	a7,10
 ecall
     c20:	00000073          	ecall
 ret
     c24:	8082                	ret

0000000000000c26 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c26:	48ad                	li	a7,11
 ecall
     c28:	00000073          	ecall
 ret
     c2c:	8082                	ret

0000000000000c2e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c2e:	48b1                	li	a7,12
 ecall
     c30:	00000073          	ecall
 ret
     c34:	8082                	ret

0000000000000c36 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c36:	48b5                	li	a7,13
 ecall
     c38:	00000073          	ecall
 ret
     c3c:	8082                	ret

0000000000000c3e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c3e:	48b9                	li	a7,14
 ecall
     c40:	00000073          	ecall
 ret
     c44:	8082                	ret

0000000000000c46 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
     c46:	48d9                	li	a7,22
 ecall
     c48:	00000073          	ecall
 ret
     c4c:	8082                	ret

0000000000000c4e <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
     c4e:	48dd                	li	a7,23
 ecall
     c50:	00000073          	ecall
 ret
     c54:	8082                	ret

0000000000000c56 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c56:	1101                	addi	sp,sp,-32
     c58:	ec06                	sd	ra,24(sp)
     c5a:	e822                	sd	s0,16(sp)
     c5c:	1000                	addi	s0,sp,32
     c5e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c62:	4605                	li	a2,1
     c64:	fef40593          	addi	a1,s0,-17
     c68:	00000097          	auipc	ra,0x0
     c6c:	f5e080e7          	jalr	-162(ra) # bc6 <write>
}
     c70:	60e2                	ld	ra,24(sp)
     c72:	6442                	ld	s0,16(sp)
     c74:	6105                	addi	sp,sp,32
     c76:	8082                	ret

0000000000000c78 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c78:	7139                	addi	sp,sp,-64
     c7a:	fc06                	sd	ra,56(sp)
     c7c:	f822                	sd	s0,48(sp)
     c7e:	f426                	sd	s1,40(sp)
     c80:	f04a                	sd	s2,32(sp)
     c82:	ec4e                	sd	s3,24(sp)
     c84:	0080                	addi	s0,sp,64
     c86:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c88:	c299                	beqz	a3,c8e <printint+0x16>
     c8a:	0805c863          	bltz	a1,d1a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     c8e:	2581                	sext.w	a1,a1
  neg = 0;
     c90:	4881                	li	a7,0
     c92:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     c96:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c98:	2601                	sext.w	a2,a2
     c9a:	00001517          	auipc	a0,0x1
     c9e:	8ee50513          	addi	a0,a0,-1810 # 1588 <digits>
     ca2:	883a                	mv	a6,a4
     ca4:	2705                	addiw	a4,a4,1
     ca6:	02c5f7bb          	remuw	a5,a1,a2
     caa:	1782                	slli	a5,a5,0x20
     cac:	9381                	srli	a5,a5,0x20
     cae:	97aa                	add	a5,a5,a0
     cb0:	0007c783          	lbu	a5,0(a5)
     cb4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     cb8:	0005879b          	sext.w	a5,a1
     cbc:	02c5d5bb          	divuw	a1,a1,a2
     cc0:	0685                	addi	a3,a3,1
     cc2:	fec7f0e3          	bgeu	a5,a2,ca2 <printint+0x2a>
  if(neg)
     cc6:	00088b63          	beqz	a7,cdc <printint+0x64>
    buf[i++] = '-';
     cca:	fd040793          	addi	a5,s0,-48
     cce:	973e                	add	a4,a4,a5
     cd0:	02d00793          	li	a5,45
     cd4:	fef70823          	sb	a5,-16(a4)
     cd8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     cdc:	02e05863          	blez	a4,d0c <printint+0x94>
     ce0:	fc040793          	addi	a5,s0,-64
     ce4:	00e78933          	add	s2,a5,a4
     ce8:	fff78993          	addi	s3,a5,-1
     cec:	99ba                	add	s3,s3,a4
     cee:	377d                	addiw	a4,a4,-1
     cf0:	1702                	slli	a4,a4,0x20
     cf2:	9301                	srli	a4,a4,0x20
     cf4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     cf8:	fff94583          	lbu	a1,-1(s2)
     cfc:	8526                	mv	a0,s1
     cfe:	00000097          	auipc	ra,0x0
     d02:	f58080e7          	jalr	-168(ra) # c56 <putc>
  while(--i >= 0)
     d06:	197d                	addi	s2,s2,-1
     d08:	ff3918e3          	bne	s2,s3,cf8 <printint+0x80>
}
     d0c:	70e2                	ld	ra,56(sp)
     d0e:	7442                	ld	s0,48(sp)
     d10:	74a2                	ld	s1,40(sp)
     d12:	7902                	ld	s2,32(sp)
     d14:	69e2                	ld	s3,24(sp)
     d16:	6121                	addi	sp,sp,64
     d18:	8082                	ret
    x = -xx;
     d1a:	40b005bb          	negw	a1,a1
    neg = 1;
     d1e:	4885                	li	a7,1
    x = -xx;
     d20:	bf8d                	j	c92 <printint+0x1a>

0000000000000d22 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d22:	7119                	addi	sp,sp,-128
     d24:	fc86                	sd	ra,120(sp)
     d26:	f8a2                	sd	s0,112(sp)
     d28:	f4a6                	sd	s1,104(sp)
     d2a:	f0ca                	sd	s2,96(sp)
     d2c:	ecce                	sd	s3,88(sp)
     d2e:	e8d2                	sd	s4,80(sp)
     d30:	e4d6                	sd	s5,72(sp)
     d32:	e0da                	sd	s6,64(sp)
     d34:	fc5e                	sd	s7,56(sp)
     d36:	f862                	sd	s8,48(sp)
     d38:	f466                	sd	s9,40(sp)
     d3a:	f06a                	sd	s10,32(sp)
     d3c:	ec6e                	sd	s11,24(sp)
     d3e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d40:	0005c903          	lbu	s2,0(a1)
     d44:	18090f63          	beqz	s2,ee2 <vprintf+0x1c0>
     d48:	8aaa                	mv	s5,a0
     d4a:	8b32                	mv	s6,a2
     d4c:	00158493          	addi	s1,a1,1
  state = 0;
     d50:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     d52:	02500a13          	li	s4,37
      if(c == 'd'){
     d56:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     d5a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     d5e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     d62:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d66:	00001b97          	auipc	s7,0x1
     d6a:	822b8b93          	addi	s7,s7,-2014 # 1588 <digits>
     d6e:	a839                	j	d8c <vprintf+0x6a>
        putc(fd, c);
     d70:	85ca                	mv	a1,s2
     d72:	8556                	mv	a0,s5
     d74:	00000097          	auipc	ra,0x0
     d78:	ee2080e7          	jalr	-286(ra) # c56 <putc>
     d7c:	a019                	j	d82 <vprintf+0x60>
    } else if(state == '%'){
     d7e:	01498f63          	beq	s3,s4,d9c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     d82:	0485                	addi	s1,s1,1
     d84:	fff4c903          	lbu	s2,-1(s1)
     d88:	14090d63          	beqz	s2,ee2 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
     d8c:	0009079b          	sext.w	a5,s2
    if(state == 0){
     d90:	fe0997e3          	bnez	s3,d7e <vprintf+0x5c>
      if(c == '%'){
     d94:	fd479ee3          	bne	a5,s4,d70 <vprintf+0x4e>
        state = '%';
     d98:	89be                	mv	s3,a5
     d9a:	b7e5                	j	d82 <vprintf+0x60>
      if(c == 'd'){
     d9c:	05878063          	beq	a5,s8,ddc <vprintf+0xba>
      } else if(c == 'l') {
     da0:	05978c63          	beq	a5,s9,df8 <vprintf+0xd6>
      } else if(c == 'x') {
     da4:	07a78863          	beq	a5,s10,e14 <vprintf+0xf2>
      } else if(c == 'p') {
     da8:	09b78463          	beq	a5,s11,e30 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
     dac:	07300713          	li	a4,115
     db0:	0ce78663          	beq	a5,a4,e7c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     db4:	06300713          	li	a4,99
     db8:	0ee78e63          	beq	a5,a4,eb4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
     dbc:	11478863          	beq	a5,s4,ecc <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     dc0:	85d2                	mv	a1,s4
     dc2:	8556                	mv	a0,s5
     dc4:	00000097          	auipc	ra,0x0
     dc8:	e92080e7          	jalr	-366(ra) # c56 <putc>
        putc(fd, c);
     dcc:	85ca                	mv	a1,s2
     dce:	8556                	mv	a0,s5
     dd0:	00000097          	auipc	ra,0x0
     dd4:	e86080e7          	jalr	-378(ra) # c56 <putc>
      }
      state = 0;
     dd8:	4981                	li	s3,0
     dda:	b765                	j	d82 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
     ddc:	008b0913          	addi	s2,s6,8
     de0:	4685                	li	a3,1
     de2:	4629                	li	a2,10
     de4:	000b2583          	lw	a1,0(s6)
     de8:	8556                	mv	a0,s5
     dea:	00000097          	auipc	ra,0x0
     dee:	e8e080e7          	jalr	-370(ra) # c78 <printint>
     df2:	8b4a                	mv	s6,s2
      state = 0;
     df4:	4981                	li	s3,0
     df6:	b771                	j	d82 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     df8:	008b0913          	addi	s2,s6,8
     dfc:	4681                	li	a3,0
     dfe:	4629                	li	a2,10
     e00:	000b2583          	lw	a1,0(s6)
     e04:	8556                	mv	a0,s5
     e06:	00000097          	auipc	ra,0x0
     e0a:	e72080e7          	jalr	-398(ra) # c78 <printint>
     e0e:	8b4a                	mv	s6,s2
      state = 0;
     e10:	4981                	li	s3,0
     e12:	bf85                	j	d82 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     e14:	008b0913          	addi	s2,s6,8
     e18:	4681                	li	a3,0
     e1a:	4641                	li	a2,16
     e1c:	000b2583          	lw	a1,0(s6)
     e20:	8556                	mv	a0,s5
     e22:	00000097          	auipc	ra,0x0
     e26:	e56080e7          	jalr	-426(ra) # c78 <printint>
     e2a:	8b4a                	mv	s6,s2
      state = 0;
     e2c:	4981                	li	s3,0
     e2e:	bf91                	j	d82 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     e30:	008b0793          	addi	a5,s6,8
     e34:	f8f43423          	sd	a5,-120(s0)
     e38:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     e3c:	03000593          	li	a1,48
     e40:	8556                	mv	a0,s5
     e42:	00000097          	auipc	ra,0x0
     e46:	e14080e7          	jalr	-492(ra) # c56 <putc>
  putc(fd, 'x');
     e4a:	85ea                	mv	a1,s10
     e4c:	8556                	mv	a0,s5
     e4e:	00000097          	auipc	ra,0x0
     e52:	e08080e7          	jalr	-504(ra) # c56 <putc>
     e56:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e58:	03c9d793          	srli	a5,s3,0x3c
     e5c:	97de                	add	a5,a5,s7
     e5e:	0007c583          	lbu	a1,0(a5)
     e62:	8556                	mv	a0,s5
     e64:	00000097          	auipc	ra,0x0
     e68:	df2080e7          	jalr	-526(ra) # c56 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e6c:	0992                	slli	s3,s3,0x4
     e6e:	397d                	addiw	s2,s2,-1
     e70:	fe0914e3          	bnez	s2,e58 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
     e74:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     e78:	4981                	li	s3,0
     e7a:	b721                	j	d82 <vprintf+0x60>
        s = va_arg(ap, char*);
     e7c:	008b0993          	addi	s3,s6,8
     e80:	000b3903          	ld	s2,0(s6)
        if(s == 0)
     e84:	02090163          	beqz	s2,ea6 <vprintf+0x184>
        while(*s != 0){
     e88:	00094583          	lbu	a1,0(s2)
     e8c:	c9a1                	beqz	a1,edc <vprintf+0x1ba>
          putc(fd, *s);
     e8e:	8556                	mv	a0,s5
     e90:	00000097          	auipc	ra,0x0
     e94:	dc6080e7          	jalr	-570(ra) # c56 <putc>
          s++;
     e98:	0905                	addi	s2,s2,1
        while(*s != 0){
     e9a:	00094583          	lbu	a1,0(s2)
     e9e:	f9e5                	bnez	a1,e8e <vprintf+0x16c>
        s = va_arg(ap, char*);
     ea0:	8b4e                	mv	s6,s3
      state = 0;
     ea2:	4981                	li	s3,0
     ea4:	bdf9                	j	d82 <vprintf+0x60>
          s = "(null)";
     ea6:	00000917          	auipc	s2,0x0
     eaa:	6da90913          	addi	s2,s2,1754 # 1580 <malloc+0x594>
        while(*s != 0){
     eae:	02800593          	li	a1,40
     eb2:	bff1                	j	e8e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
     eb4:	008b0913          	addi	s2,s6,8
     eb8:	000b4583          	lbu	a1,0(s6)
     ebc:	8556                	mv	a0,s5
     ebe:	00000097          	auipc	ra,0x0
     ec2:	d98080e7          	jalr	-616(ra) # c56 <putc>
     ec6:	8b4a                	mv	s6,s2
      state = 0;
     ec8:	4981                	li	s3,0
     eca:	bd65                	j	d82 <vprintf+0x60>
        putc(fd, c);
     ecc:	85d2                	mv	a1,s4
     ece:	8556                	mv	a0,s5
     ed0:	00000097          	auipc	ra,0x0
     ed4:	d86080e7          	jalr	-634(ra) # c56 <putc>
      state = 0;
     ed8:	4981                	li	s3,0
     eda:	b565                	j	d82 <vprintf+0x60>
        s = va_arg(ap, char*);
     edc:	8b4e                	mv	s6,s3
      state = 0;
     ede:	4981                	li	s3,0
     ee0:	b54d                	j	d82 <vprintf+0x60>
    }
  }
}
     ee2:	70e6                	ld	ra,120(sp)
     ee4:	7446                	ld	s0,112(sp)
     ee6:	74a6                	ld	s1,104(sp)
     ee8:	7906                	ld	s2,96(sp)
     eea:	69e6                	ld	s3,88(sp)
     eec:	6a46                	ld	s4,80(sp)
     eee:	6aa6                	ld	s5,72(sp)
     ef0:	6b06                	ld	s6,64(sp)
     ef2:	7be2                	ld	s7,56(sp)
     ef4:	7c42                	ld	s8,48(sp)
     ef6:	7ca2                	ld	s9,40(sp)
     ef8:	7d02                	ld	s10,32(sp)
     efa:	6de2                	ld	s11,24(sp)
     efc:	6109                	addi	sp,sp,128
     efe:	8082                	ret

0000000000000f00 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     f00:	715d                	addi	sp,sp,-80
     f02:	ec06                	sd	ra,24(sp)
     f04:	e822                	sd	s0,16(sp)
     f06:	1000                	addi	s0,sp,32
     f08:	e010                	sd	a2,0(s0)
     f0a:	e414                	sd	a3,8(s0)
     f0c:	e818                	sd	a4,16(s0)
     f0e:	ec1c                	sd	a5,24(s0)
     f10:	03043023          	sd	a6,32(s0)
     f14:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     f18:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     f1c:	8622                	mv	a2,s0
     f1e:	00000097          	auipc	ra,0x0
     f22:	e04080e7          	jalr	-508(ra) # d22 <vprintf>
}
     f26:	60e2                	ld	ra,24(sp)
     f28:	6442                	ld	s0,16(sp)
     f2a:	6161                	addi	sp,sp,80
     f2c:	8082                	ret

0000000000000f2e <printf>:

void
printf(const char *fmt, ...)
{
     f2e:	711d                	addi	sp,sp,-96
     f30:	ec06                	sd	ra,24(sp)
     f32:	e822                	sd	s0,16(sp)
     f34:	1000                	addi	s0,sp,32
     f36:	e40c                	sd	a1,8(s0)
     f38:	e810                	sd	a2,16(s0)
     f3a:	ec14                	sd	a3,24(s0)
     f3c:	f018                	sd	a4,32(s0)
     f3e:	f41c                	sd	a5,40(s0)
     f40:	03043823          	sd	a6,48(s0)
     f44:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     f48:	00840613          	addi	a2,s0,8
     f4c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     f50:	85aa                	mv	a1,a0
     f52:	4505                	li	a0,1
     f54:	00000097          	auipc	ra,0x0
     f58:	dce080e7          	jalr	-562(ra) # d22 <vprintf>
}
     f5c:	60e2                	ld	ra,24(sp)
     f5e:	6442                	ld	s0,16(sp)
     f60:	6125                	addi	sp,sp,96
     f62:	8082                	ret

0000000000000f64 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     f64:	1141                	addi	sp,sp,-16
     f66:	e422                	sd	s0,8(sp)
     f68:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f6a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f6e:	00000797          	auipc	a5,0x0
     f72:	63a7b783          	ld	a5,1594(a5) # 15a8 <freep>
     f76:	a805                	j	fa6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     f78:	4618                	lw	a4,8(a2)
     f7a:	9db9                	addw	a1,a1,a4
     f7c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     f80:	6398                	ld	a4,0(a5)
     f82:	6318                	ld	a4,0(a4)
     f84:	fee53823          	sd	a4,-16(a0)
     f88:	a091                	j	fcc <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     f8a:	ff852703          	lw	a4,-8(a0)
     f8e:	9e39                	addw	a2,a2,a4
     f90:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
     f92:	ff053703          	ld	a4,-16(a0)
     f96:	e398                	sd	a4,0(a5)
     f98:	a099                	j	fde <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f9a:	6398                	ld	a4,0(a5)
     f9c:	00e7e463          	bltu	a5,a4,fa4 <free+0x40>
     fa0:	00e6ea63          	bltu	a3,a4,fb4 <free+0x50>
{
     fa4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     fa6:	fed7fae3          	bgeu	a5,a3,f9a <free+0x36>
     faa:	6398                	ld	a4,0(a5)
     fac:	00e6e463          	bltu	a3,a4,fb4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     fb0:	fee7eae3          	bltu	a5,a4,fa4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
     fb4:	ff852583          	lw	a1,-8(a0)
     fb8:	6390                	ld	a2,0(a5)
     fba:	02059713          	slli	a4,a1,0x20
     fbe:	9301                	srli	a4,a4,0x20
     fc0:	0712                	slli	a4,a4,0x4
     fc2:	9736                	add	a4,a4,a3
     fc4:	fae60ae3          	beq	a2,a4,f78 <free+0x14>
    bp->s.ptr = p->s.ptr;
     fc8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     fcc:	4790                	lw	a2,8(a5)
     fce:	02061713          	slli	a4,a2,0x20
     fd2:	9301                	srli	a4,a4,0x20
     fd4:	0712                	slli	a4,a4,0x4
     fd6:	973e                	add	a4,a4,a5
     fd8:	fae689e3          	beq	a3,a4,f8a <free+0x26>
  } else
    p->s.ptr = bp;
     fdc:	e394                	sd	a3,0(a5)
  freep = p;
     fde:	00000717          	auipc	a4,0x0
     fe2:	5cf73523          	sd	a5,1482(a4) # 15a8 <freep>
}
     fe6:	6422                	ld	s0,8(sp)
     fe8:	0141                	addi	sp,sp,16
     fea:	8082                	ret

0000000000000fec <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     fec:	7139                	addi	sp,sp,-64
     fee:	fc06                	sd	ra,56(sp)
     ff0:	f822                	sd	s0,48(sp)
     ff2:	f426                	sd	s1,40(sp)
     ff4:	f04a                	sd	s2,32(sp)
     ff6:	ec4e                	sd	s3,24(sp)
     ff8:	e852                	sd	s4,16(sp)
     ffa:	e456                	sd	s5,8(sp)
     ffc:	e05a                	sd	s6,0(sp)
     ffe:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1000:	02051493          	slli	s1,a0,0x20
    1004:	9081                	srli	s1,s1,0x20
    1006:	04bd                	addi	s1,s1,15
    1008:	8091                	srli	s1,s1,0x4
    100a:	0014899b          	addiw	s3,s1,1
    100e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1010:	00000517          	auipc	a0,0x0
    1014:	59853503          	ld	a0,1432(a0) # 15a8 <freep>
    1018:	c515                	beqz	a0,1044 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    101a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    101c:	4798                	lw	a4,8(a5)
    101e:	02977f63          	bgeu	a4,s1,105c <malloc+0x70>
    1022:	8a4e                	mv	s4,s3
    1024:	0009871b          	sext.w	a4,s3
    1028:	6685                	lui	a3,0x1
    102a:	00d77363          	bgeu	a4,a3,1030 <malloc+0x44>
    102e:	6a05                	lui	s4,0x1
    1030:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1034:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1038:	00000917          	auipc	s2,0x0
    103c:	57090913          	addi	s2,s2,1392 # 15a8 <freep>
  if(p == (char*)-1)
    1040:	5afd                	li	s5,-1
    1042:	a88d                	j	10b4 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    1044:	00001797          	auipc	a5,0x1
    1048:	96c78793          	addi	a5,a5,-1684 # 19b0 <base>
    104c:	00000717          	auipc	a4,0x0
    1050:	54f73e23          	sd	a5,1372(a4) # 15a8 <freep>
    1054:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1056:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    105a:	b7e1                	j	1022 <malloc+0x36>
      if(p->s.size == nunits)
    105c:	02e48b63          	beq	s1,a4,1092 <malloc+0xa6>
        p->s.size -= nunits;
    1060:	4137073b          	subw	a4,a4,s3
    1064:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1066:	1702                	slli	a4,a4,0x20
    1068:	9301                	srli	a4,a4,0x20
    106a:	0712                	slli	a4,a4,0x4
    106c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    106e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1072:	00000717          	auipc	a4,0x0
    1076:	52a73b23          	sd	a0,1334(a4) # 15a8 <freep>
      return (void*)(p + 1);
    107a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    107e:	70e2                	ld	ra,56(sp)
    1080:	7442                	ld	s0,48(sp)
    1082:	74a2                	ld	s1,40(sp)
    1084:	7902                	ld	s2,32(sp)
    1086:	69e2                	ld	s3,24(sp)
    1088:	6a42                	ld	s4,16(sp)
    108a:	6aa2                	ld	s5,8(sp)
    108c:	6b02                	ld	s6,0(sp)
    108e:	6121                	addi	sp,sp,64
    1090:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1092:	6398                	ld	a4,0(a5)
    1094:	e118                	sd	a4,0(a0)
    1096:	bff1                	j	1072 <malloc+0x86>
  hp->s.size = nu;
    1098:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    109c:	0541                	addi	a0,a0,16
    109e:	00000097          	auipc	ra,0x0
    10a2:	ec6080e7          	jalr	-314(ra) # f64 <free>
  return freep;
    10a6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    10aa:	d971                	beqz	a0,107e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10ae:	4798                	lw	a4,8(a5)
    10b0:	fa9776e3          	bgeu	a4,s1,105c <malloc+0x70>
    if(p == freep)
    10b4:	00093703          	ld	a4,0(s2)
    10b8:	853e                	mv	a0,a5
    10ba:	fef719e3          	bne	a4,a5,10ac <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    10be:	8552                	mv	a0,s4
    10c0:	00000097          	auipc	ra,0x0
    10c4:	b6e080e7          	jalr	-1170(ra) # c2e <sbrk>
  if(p == (char*)-1)
    10c8:	fd5518e3          	bne	a0,s5,1098 <malloc+0xac>
        return 0;
    10cc:	4501                	li	a0,0
    10ce:	bf45                	j	107e <malloc+0x92>
