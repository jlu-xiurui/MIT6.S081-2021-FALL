
user/_nettests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <decode_qname>:

// Decode a DNS name
static void
decode_qname(char *qn, int max)
{
  char *qnMax = qn + max;
       0:	95aa                	add	a1,a1,a0
      break;
    for(int i = 0; i < l; i++) {
      *qn = *(qn+1);
      qn++;
    }
    *qn++ = '.';
       2:	02e00813          	li	a6,46
    if(qn >= qnMax){
       6:	02b56963          	bltu	a0,a1,38 <decode_qname+0x38>
{
       a:	1141                	addi	sp,sp,-16
       c:	e406                	sd	ra,8(sp)
       e:	e022                	sd	s0,0(sp)
      10:	0800                	addi	s0,sp,16
      printf("invalid DNS reply\n");
      12:	00001517          	auipc	a0,0x1
      16:	05e50513          	addi	a0,a0,94 # 1070 <malloc+0xea>
      1a:	00001097          	auipc	ra,0x1
      1e:	eae080e7          	jalr	-338(ra) # ec8 <printf>
      exit(1);
      22:	4505                	li	a0,1
      24:	00001097          	auipc	ra,0x1
      28:	b1c080e7          	jalr	-1252(ra) # b40 <exit>
    *qn++ = '.';
      2c:	0609                	addi	a2,a2,2
      2e:	9532                	add	a0,a0,a2
      30:	01068023          	sb	a6,0(a3)
    if(qn >= qnMax){
      34:	fcb57be3          	bgeu	a0,a1,a <decode_qname+0xa>
    int l = *qn;
      38:	00054783          	lbu	a5,0(a0)
    if(l == 0)
      3c:	c38d                	beqz	a5,5e <decode_qname+0x5e>
    for(int i = 0; i < l; i++) {
      3e:	37fd                	addiw	a5,a5,-1
      40:	02079613          	slli	a2,a5,0x20
      44:	9201                	srli	a2,a2,0x20
      46:	00160693          	addi	a3,a2,1
      4a:	96aa                	add	a3,a3,a0
    if(l == 0)
      4c:	87aa                	mv	a5,a0
      *qn = *(qn+1);
      4e:	0017c703          	lbu	a4,1(a5)
      52:	00e78023          	sb	a4,0(a5)
      qn++;
      56:	0785                	addi	a5,a5,1
    for(int i = 0; i < l; i++) {
      58:	fed79be3          	bne	a5,a3,4e <decode_qname+0x4e>
      5c:	bfc1                	j	2c <decode_qname+0x2c>
      5e:	8082                	ret

0000000000000060 <ping>:
{
      60:	7171                	addi	sp,sp,-176
      62:	f506                	sd	ra,168(sp)
      64:	f122                	sd	s0,160(sp)
      66:	ed26                	sd	s1,152(sp)
      68:	e94a                	sd	s2,144(sp)
      6a:	e54e                	sd	s3,136(sp)
      6c:	e152                	sd	s4,128(sp)
      6e:	1900                	addi	s0,sp,176
      70:	8a32                	mv	s4,a2
  if((fd = connect(dst, sport, dport)) < 0){
      72:	862e                	mv	a2,a1
      74:	85aa                	mv	a1,a0
      76:	0a000537          	lui	a0,0xa000
      7a:	20250513          	addi	a0,a0,514 # a000202 <__global_pointer$+0x9ffe6b1>
      7e:	00001097          	auipc	ra,0x1
      82:	b62080e7          	jalr	-1182(ra) # be0 <connect>
      86:	08054563          	bltz	a0,110 <ping+0xb0>
      8a:	89aa                	mv	s3,a0
  for(int i = 0; i < attempts; i++) {
      8c:	4481                	li	s1,0
    if(write(fd, obuf, strlen(obuf)) < 0){
      8e:	00001917          	auipc	s2,0x1
      92:	01290913          	addi	s2,s2,18 # 10a0 <malloc+0x11a>
  for(int i = 0; i < attempts; i++) {
      96:	03405463          	blez	s4,be <ping+0x5e>
    if(write(fd, obuf, strlen(obuf)) < 0){
      9a:	854a                	mv	a0,s2
      9c:	00001097          	auipc	ra,0x1
      a0:	876080e7          	jalr	-1930(ra) # 912 <strlen>
      a4:	0005061b          	sext.w	a2,a0
      a8:	85ca                	mv	a1,s2
      aa:	854e                	mv	a0,s3
      ac:	00001097          	auipc	ra,0x1
      b0:	ab4080e7          	jalr	-1356(ra) # b60 <write>
      b4:	06054c63          	bltz	a0,12c <ping+0xcc>
  for(int i = 0; i < attempts; i++) {
      b8:	2485                	addiw	s1,s1,1
      ba:	fe9a10e3          	bne	s4,s1,9a <ping+0x3a>
  int cc = read(fd, ibuf, sizeof(ibuf)-1);
      be:	07f00613          	li	a2,127
      c2:	f5040593          	addi	a1,s0,-176
      c6:	854e                	mv	a0,s3
      c8:	00001097          	auipc	ra,0x1
      cc:	a90080e7          	jalr	-1392(ra) # b58 <read>
      d0:	84aa                	mv	s1,a0
  if(cc < 0){
      d2:	06054b63          	bltz	a0,148 <ping+0xe8>
  close(fd);
      d6:	854e                	mv	a0,s3
      d8:	00001097          	auipc	ra,0x1
      dc:	a90080e7          	jalr	-1392(ra) # b68 <close>
  ibuf[cc] = '\0';
      e0:	fd040793          	addi	a5,s0,-48
      e4:	94be                	add	s1,s1,a5
      e6:	f8048023          	sb	zero,-128(s1)
  if(strcmp(ibuf, "this is the host!") != 0){
      ea:	00001597          	auipc	a1,0x1
      ee:	ffe58593          	addi	a1,a1,-2 # 10e8 <malloc+0x162>
      f2:	f5040513          	addi	a0,s0,-176
      f6:	00000097          	auipc	ra,0x0
      fa:	7f0080e7          	jalr	2032(ra) # 8e6 <strcmp>
      fe:	e13d                	bnez	a0,164 <ping+0x104>
}
     100:	70aa                	ld	ra,168(sp)
     102:	740a                	ld	s0,160(sp)
     104:	64ea                	ld	s1,152(sp)
     106:	694a                	ld	s2,144(sp)
     108:	69aa                	ld	s3,136(sp)
     10a:	6a0a                	ld	s4,128(sp)
     10c:	614d                	addi	sp,sp,176
     10e:	8082                	ret
    fprintf(2, "ping: connect() failed\n");
     110:	00001597          	auipc	a1,0x1
     114:	f7858593          	addi	a1,a1,-136 # 1088 <malloc+0x102>
     118:	4509                	li	a0,2
     11a:	00001097          	auipc	ra,0x1
     11e:	d80080e7          	jalr	-640(ra) # e9a <fprintf>
    exit(1);
     122:	4505                	li	a0,1
     124:	00001097          	auipc	ra,0x1
     128:	a1c080e7          	jalr	-1508(ra) # b40 <exit>
      fprintf(2, "ping: send() failed\n");
     12c:	00001597          	auipc	a1,0x1
     130:	f8c58593          	addi	a1,a1,-116 # 10b8 <malloc+0x132>
     134:	4509                	li	a0,2
     136:	00001097          	auipc	ra,0x1
     13a:	d64080e7          	jalr	-668(ra) # e9a <fprintf>
      exit(1);
     13e:	4505                	li	a0,1
     140:	00001097          	auipc	ra,0x1
     144:	a00080e7          	jalr	-1536(ra) # b40 <exit>
    fprintf(2, "ping: recv() failed\n");
     148:	00001597          	auipc	a1,0x1
     14c:	f8858593          	addi	a1,a1,-120 # 10d0 <malloc+0x14a>
     150:	4509                	li	a0,2
     152:	00001097          	auipc	ra,0x1
     156:	d48080e7          	jalr	-696(ra) # e9a <fprintf>
    exit(1);
     15a:	4505                	li	a0,1
     15c:	00001097          	auipc	ra,0x1
     160:	9e4080e7          	jalr	-1564(ra) # b40 <exit>
    fprintf(2, "ping didn't receive correct payload\n");
     164:	00001597          	auipc	a1,0x1
     168:	f9c58593          	addi	a1,a1,-100 # 1100 <malloc+0x17a>
     16c:	4509                	li	a0,2
     16e:	00001097          	auipc	ra,0x1
     172:	d2c080e7          	jalr	-724(ra) # e9a <fprintf>
    exit(1);
     176:	4505                	li	a0,1
     178:	00001097          	auipc	ra,0x1
     17c:	9c8080e7          	jalr	-1592(ra) # b40 <exit>

0000000000000180 <dns>:
  }
}

static void
dns()
{
     180:	7119                	addi	sp,sp,-128
     182:	fc86                	sd	ra,120(sp)
     184:	f8a2                	sd	s0,112(sp)
     186:	f4a6                	sd	s1,104(sp)
     188:	f0ca                	sd	s2,96(sp)
     18a:	ecce                	sd	s3,88(sp)
     18c:	e8d2                	sd	s4,80(sp)
     18e:	e4d6                	sd	s5,72(sp)
     190:	e0da                	sd	s6,64(sp)
     192:	fc5e                	sd	s7,56(sp)
     194:	f862                	sd	s8,48(sp)
     196:	f466                	sd	s9,40(sp)
     198:	f06a                	sd	s10,32(sp)
     19a:	ec6e                	sd	s11,24(sp)
     19c:	0100                	addi	s0,sp,128
     19e:	83010113          	addi	sp,sp,-2000
  uint8 ibuf[N];
  uint32 dst;
  int fd;
  int len;

  memset(obuf, 0, N);
     1a2:	3e800613          	li	a2,1000
     1a6:	4581                	li	a1,0
     1a8:	ba840513          	addi	a0,s0,-1112
     1ac:	00000097          	auipc	ra,0x0
     1b0:	790080e7          	jalr	1936(ra) # 93c <memset>
  memset(ibuf, 0, N);
     1b4:	3e800613          	li	a2,1000
     1b8:	4581                	li	a1,0
     1ba:	77fd                	lui	a5,0xfffff
     1bc:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffdc6f>
     1c0:	00f40533          	add	a0,s0,a5
     1c4:	00000097          	auipc	ra,0x0
     1c8:	778080e7          	jalr	1912(ra) # 93c <memset>
  
  // 8.8.8.8: google's name server
  dst = (8 << 24) | (8 << 16) | (8 << 8) | (8 << 0);

  if((fd = connect(dst, 10000, 53)) < 0){
     1cc:	03500613          	li	a2,53
     1d0:	6589                	lui	a1,0x2
     1d2:	71058593          	addi	a1,a1,1808 # 2710 <__global_pointer$+0xbbf>
     1d6:	08081537          	lui	a0,0x8081
     1da:	80850513          	addi	a0,a0,-2040 # 8080808 <__global_pointer$+0x807ecb7>
     1de:	00001097          	auipc	ra,0x1
     1e2:	a02080e7          	jalr	-1534(ra) # be0 <connect>
     1e6:	02054d63          	bltz	a0,220 <dns+0xa0>
     1ea:	89aa                	mv	s3,a0
  hdr->id = htons(6828);
     1ec:	77ed                	lui	a5,0xffffb
     1ee:	c1a7879b          	addiw	a5,a5,-998
     1f2:	baf41423          	sh	a5,-1112(s0)
  hdr->rd = 1;
     1f6:	baa45783          	lhu	a5,-1110(s0)
     1fa:	0017e793          	ori	a5,a5,1
     1fe:	baf41523          	sh	a5,-1110(s0)
  hdr->qdcount = htons(1);
     202:	10000793          	li	a5,256
     206:	baf41623          	sh	a5,-1108(s0)
  for(char *c = host; c < host+strlen(host)+1; c++) {
     20a:	00001497          	auipc	s1,0x1
     20e:	f1e48493          	addi	s1,s1,-226 # 1128 <malloc+0x1a2>
  char *l = host; 
     212:	8a26                	mv	s4,s1
  for(char *c = host; c < host+strlen(host)+1; c++) {
     214:	bb440913          	addi	s2,s0,-1100
     218:	8aa6                	mv	s5,s1
    if(*c == '.') {
     21a:	02e00b13          	li	s6,46
  for(char *c = host; c < host+strlen(host)+1; c++) {
     21e:	a82d                	j	258 <dns+0xd8>
    fprintf(2, "ping: connect() failed\n");
     220:	00001597          	auipc	a1,0x1
     224:	e6858593          	addi	a1,a1,-408 # 1088 <malloc+0x102>
     228:	4509                	li	a0,2
     22a:	00001097          	auipc	ra,0x1
     22e:	c70080e7          	jalr	-912(ra) # e9a <fprintf>
    exit(1);
     232:	4505                	li	a0,1
     234:	00001097          	auipc	ra,0x1
     238:	90c080e7          	jalr	-1780(ra) # b40 <exit>
        *qn++ = *d;
     23c:	0705                	addi	a4,a4,1
     23e:	0007c603          	lbu	a2,0(a5) # ffffffffffffb000 <__global_pointer$+0xffffffffffff94af>
     242:	fec70fa3          	sb	a2,-1(a4)
      for(char *d = l; d < c; d++) {
     246:	0785                	addi	a5,a5,1
     248:	fef49ae3          	bne	s1,a5,23c <dns+0xbc>
     24c:	41448933          	sub	s2,s1,s4
     250:	9936                	add	s2,s2,a3
      l = c+1; // skip .
     252:	00148a13          	addi	s4,s1,1
  for(char *c = host; c < host+strlen(host)+1; c++) {
     256:	0485                	addi	s1,s1,1
     258:	8556                	mv	a0,s5
     25a:	00000097          	auipc	ra,0x0
     25e:	6b8080e7          	jalr	1720(ra) # 912 <strlen>
     262:	1502                	slli	a0,a0,0x20
     264:	9101                	srli	a0,a0,0x20
     266:	0505                	addi	a0,a0,1
     268:	9556                	add	a0,a0,s5
     26a:	02a4f363          	bgeu	s1,a0,290 <dns+0x110>
    if(*c == '.') {
     26e:	0004c783          	lbu	a5,0(s1)
     272:	ff6792e3          	bne	a5,s6,256 <dns+0xd6>
      *qn++ = (char) (c-l);
     276:	00190693          	addi	a3,s2,1
     27a:	414487b3          	sub	a5,s1,s4
     27e:	00f90023          	sb	a5,0(s2)
      for(char *d = l; d < c; d++) {
     282:	009a7563          	bgeu	s4,s1,28c <dns+0x10c>
     286:	87d2                	mv	a5,s4
      *qn++ = (char) (c-l);
     288:	8736                	mv	a4,a3
     28a:	bf4d                	j	23c <dns+0xbc>
     28c:	8936                	mv	s2,a3
     28e:	b7d1                	j	252 <dns+0xd2>
  *qn = '\0';
     290:	00090023          	sb	zero,0(s2)
  len += strlen(qname) + 1;
     294:	bb440513          	addi	a0,s0,-1100
     298:	00000097          	auipc	ra,0x0
     29c:	67a080e7          	jalr	1658(ra) # 912 <strlen>
     2a0:	0005049b          	sext.w	s1,a0
  struct dns_question *h = (struct dns_question *) (qname+strlen(qname)+1);
     2a4:	bb440513          	addi	a0,s0,-1100
     2a8:	00000097          	auipc	ra,0x0
     2ac:	66a080e7          	jalr	1642(ra) # 912 <strlen>
     2b0:	02051793          	slli	a5,a0,0x20
     2b4:	9381                	srli	a5,a5,0x20
     2b6:	0785                	addi	a5,a5,1
     2b8:	bb440713          	addi	a4,s0,-1100
     2bc:	97ba                	add	a5,a5,a4
  h->qtype = htons(0x1);
     2be:	00078023          	sb	zero,0(a5)
     2c2:	4705                	li	a4,1
     2c4:	00e780a3          	sb	a4,1(a5)
  h->qclass = htons(0x1);
     2c8:	00078123          	sb	zero,2(a5)
     2cc:	00e781a3          	sb	a4,3(a5)
  }

  len = dns_req(obuf);
  
  if(write(fd, obuf, len) < 0){
     2d0:	0114861b          	addiw	a2,s1,17
     2d4:	ba840593          	addi	a1,s0,-1112
     2d8:	854e                	mv	a0,s3
     2da:	00001097          	auipc	ra,0x1
     2de:	886080e7          	jalr	-1914(ra) # b60 <write>
     2e2:	12054d63          	bltz	a0,41c <dns+0x29c>
    fprintf(2, "dns: send() failed\n");
    exit(1);
  }
  int cc = read(fd, ibuf, sizeof(ibuf));
     2e6:	3e800613          	li	a2,1000
     2ea:	77fd                	lui	a5,0xfffff
     2ec:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffdc6f>
     2f0:	00f405b3          	add	a1,s0,a5
     2f4:	854e                	mv	a0,s3
     2f6:	00001097          	auipc	ra,0x1
     2fa:	862080e7          	jalr	-1950(ra) # b58 <read>
     2fe:	892a                	mv	s2,a0
  if(cc < 0){
     300:	12054c63          	bltz	a0,438 <dns+0x2b8>
  if(cc < sizeof(struct dns)){
     304:	0005079b          	sext.w	a5,a0
     308:	472d                	li	a4,11
     30a:	14f77563          	bgeu	a4,a5,454 <dns+0x2d4>
  if(!hdr->qr) {
     30e:	77fd                	lui	a5,0xfffff
     310:	7c278793          	addi	a5,a5,1986 # fffffffffffff7c2 <__global_pointer$+0xffffffffffffdc71>
     314:	97a2                	add	a5,a5,s0
     316:	00078783          	lb	a5,0(a5)
     31a:	1407da63          	bgez	a5,46e <dns+0x2ee>
  if(hdr->id != htons(6828)){
     31e:	77fd                	lui	a5,0xfffff
     320:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffdc6f>
     324:	97a2                	add	a5,a5,s0
     326:	0007d703          	lhu	a4,0(a5)
     32a:	0007069b          	sext.w	a3,a4
     32e:	67ad                	lui	a5,0xb
     330:	c1a78793          	addi	a5,a5,-998 # ac1a <__global_pointer$+0x90c9>
     334:	16f69963          	bne	a3,a5,4a6 <dns+0x326>
  if(hdr->rcode != 0) {
     338:	777d                	lui	a4,0xfffff
     33a:	7c370793          	addi	a5,a4,1987 # fffffffffffff7c3 <__global_pointer$+0xffffffffffffdc72>
     33e:	97a2                	add	a5,a5,s0
     340:	0007c783          	lbu	a5,0(a5)
     344:	8bbd                	andi	a5,a5,15
     346:	18079463          	bnez	a5,4ce <dns+0x34e>
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
     34a:	7c470793          	addi	a5,a4,1988
     34e:	97a2                	add	a5,a5,s0
     350:	0007d783          	lhu	a5,0(a5)
     354:	0087d713          	srli	a4,a5,0x8
     358:	0087979b          	slliw	a5,a5,0x8
     35c:	0ff77713          	andi	a4,a4,255
     360:	8fd9                	or	a5,a5,a4
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     362:	17c2                	slli	a5,a5,0x30
     364:	93c1                	srli	a5,a5,0x30
     366:	4a81                	li	s5,0
  len = sizeof(struct dns);
     368:	44b1                	li	s1,12
  char *qname = 0;
     36a:	4a01                	li	s4,0
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     36c:	c7b1                	beqz	a5,3b8 <dns+0x238>
    char *qn = (char *) (ibuf+len);
     36e:	7b7d                	lui	s6,0xfffff
     370:	7c0b0793          	addi	a5,s6,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffdc6f>
     374:	97a2                	add	a5,a5,s0
     376:	00978a33          	add	s4,a5,s1
    decode_qname(qn, cc - len);
     37a:	409905bb          	subw	a1,s2,s1
     37e:	8552                	mv	a0,s4
     380:	00000097          	auipc	ra,0x0
     384:	c80080e7          	jalr	-896(ra) # 0 <decode_qname>
    len += strlen(qn)+1;
     388:	8552                	mv	a0,s4
     38a:	00000097          	auipc	ra,0x0
     38e:	588080e7          	jalr	1416(ra) # 912 <strlen>
    len += sizeof(struct dns_question);
     392:	2515                	addiw	a0,a0,5
     394:	9ca9                	addw	s1,s1,a0
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     396:	2a85                	addiw	s5,s5,1
     398:	7c4b0793          	addi	a5,s6,1988
     39c:	97a2                	add	a5,a5,s0
     39e:	0007d783          	lhu	a5,0(a5)
     3a2:	0087d713          	srli	a4,a5,0x8
     3a6:	0087979b          	slliw	a5,a5,0x8
     3aa:	0ff77713          	andi	a4,a4,255
     3ae:	8fd9                	or	a5,a5,a4
     3b0:	17c2                	slli	a5,a5,0x30
     3b2:	93c1                	srli	a5,a5,0x30
     3b4:	fafacde3          	blt	s5,a5,36e <dns+0x1ee>
     3b8:	77fd                	lui	a5,0xfffff
     3ba:	7c678793          	addi	a5,a5,1990 # fffffffffffff7c6 <__global_pointer$+0xffffffffffffdc75>
     3be:	97a2                	add	a5,a5,s0
     3c0:	0007d783          	lhu	a5,0(a5)
     3c4:	0087d713          	srli	a4,a5,0x8
     3c8:	0087979b          	slliw	a5,a5,0x8
     3cc:	0ff77713          	andi	a4,a4,255
     3d0:	8fd9                	or	a5,a5,a4
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
     3d2:	17c2                	slli	a5,a5,0x30
     3d4:	93c1                	srli	a5,a5,0x30
     3d6:	26078963          	beqz	a5,648 <dns+0x4c8>
    if(len >= cc){
     3da:	1124de63          	bge	s1,s2,4f6 <dns+0x376>
     3de:	00001797          	auipc	a5,0x1
     3e2:	e8a78793          	addi	a5,a5,-374 # 1268 <malloc+0x2e2>
     3e6:	000a0363          	beqz	s4,3ec <dns+0x26c>
     3ea:	87d2                	mv	a5,s4
     3ec:	76fd                	lui	a3,0xfffff
     3ee:	7b068713          	addi	a4,a3,1968 # fffffffffffff7b0 <__global_pointer$+0xffffffffffffdc5f>
     3f2:	9722                	add	a4,a4,s0
     3f4:	e31c                	sd	a5,0(a4)
  int record = 0;
     3f6:	7b868793          	addi	a5,a3,1976
     3fa:	97a2                	add	a5,a5,s0
     3fc:	0007b023          	sd	zero,0(a5)
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
     400:	4a01                	li	s4,0
    if((int) qn[0] > 63) {  // compression?
     402:	03f00d93          	li	s11,63
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
     406:	4a85                	li	s5,1
     408:	4d11                	li	s10,4
      printf("DNS arecord for %s is ", qname ? qname : "" );
     40a:	00001c97          	auipc	s9,0x1
     40e:	dc6c8c93          	addi	s9,s9,-570 # 11d0 <malloc+0x24a>
      if(ip[0] != 128 || ip[1] != 52 || ip[2] != 129 || ip[3] != 126) {
     412:	08000c13          	li	s8,128
     416:	03400b93          	li	s7,52
     41a:	aa99                	j	570 <dns+0x3f0>
    fprintf(2, "dns: send() failed\n");
     41c:	00001597          	auipc	a1,0x1
     420:	d2458593          	addi	a1,a1,-732 # 1140 <malloc+0x1ba>
     424:	4509                	li	a0,2
     426:	00001097          	auipc	ra,0x1
     42a:	a74080e7          	jalr	-1420(ra) # e9a <fprintf>
    exit(1);
     42e:	4505                	li	a0,1
     430:	00000097          	auipc	ra,0x0
     434:	710080e7          	jalr	1808(ra) # b40 <exit>
    fprintf(2, "dns: recv() failed\n");
     438:	00001597          	auipc	a1,0x1
     43c:	d2058593          	addi	a1,a1,-736 # 1158 <malloc+0x1d2>
     440:	4509                	li	a0,2
     442:	00001097          	auipc	ra,0x1
     446:	a58080e7          	jalr	-1448(ra) # e9a <fprintf>
    exit(1);
     44a:	4505                	li	a0,1
     44c:	00000097          	auipc	ra,0x0
     450:	6f4080e7          	jalr	1780(ra) # b40 <exit>
    printf("DNS reply too short\n");
     454:	00001517          	auipc	a0,0x1
     458:	d1c50513          	addi	a0,a0,-740 # 1170 <malloc+0x1ea>
     45c:	00001097          	auipc	ra,0x1
     460:	a6c080e7          	jalr	-1428(ra) # ec8 <printf>
    exit(1);
     464:	4505                	li	a0,1
     466:	00000097          	auipc	ra,0x0
     46a:	6da080e7          	jalr	1754(ra) # b40 <exit>
     46e:	77fd                	lui	a5,0xfffff
     470:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffdc6f>
     474:	97a2                	add	a5,a5,s0
     476:	0007d783          	lhu	a5,0(a5)
     47a:	0087d593          	srli	a1,a5,0x8
     47e:	0087979b          	slliw	a5,a5,0x8
     482:	0ff5f593          	andi	a1,a1,255
     486:	8ddd                	or	a1,a1,a5
    printf("Not a DNS reply for %d\n", ntohs(hdr->id));
     488:	15c2                	slli	a1,a1,0x30
     48a:	91c1                	srli	a1,a1,0x30
     48c:	00001517          	auipc	a0,0x1
     490:	cfc50513          	addi	a0,a0,-772 # 1188 <malloc+0x202>
     494:	00001097          	auipc	ra,0x1
     498:	a34080e7          	jalr	-1484(ra) # ec8 <printf>
    exit(1);
     49c:	4505                	li	a0,1
     49e:	00000097          	auipc	ra,0x0
     4a2:	6a2080e7          	jalr	1698(ra) # b40 <exit>
     4a6:	0087559b          	srliw	a1,a4,0x8
     4aa:	0087171b          	slliw	a4,a4,0x8
     4ae:	8dd9                	or	a1,a1,a4
    printf("DNS wrong id: %d\n", ntohs(hdr->id));
     4b0:	15c2                	slli	a1,a1,0x30
     4b2:	91c1                	srli	a1,a1,0x30
     4b4:	00001517          	auipc	a0,0x1
     4b8:	cec50513          	addi	a0,a0,-788 # 11a0 <malloc+0x21a>
     4bc:	00001097          	auipc	ra,0x1
     4c0:	a0c080e7          	jalr	-1524(ra) # ec8 <printf>
    exit(1);
     4c4:	4505                	li	a0,1
     4c6:	00000097          	auipc	ra,0x0
     4ca:	67a080e7          	jalr	1658(ra) # b40 <exit>
    printf("DNS rcode error: %x\n", hdr->rcode);
     4ce:	77fd                	lui	a5,0xfffff
     4d0:	7c378793          	addi	a5,a5,1987 # fffffffffffff7c3 <__global_pointer$+0xffffffffffffdc72>
     4d4:	97a2                	add	a5,a5,s0
     4d6:	0007c583          	lbu	a1,0(a5)
     4da:	89bd                	andi	a1,a1,15
     4dc:	00001517          	auipc	a0,0x1
     4e0:	cdc50513          	addi	a0,a0,-804 # 11b8 <malloc+0x232>
     4e4:	00001097          	auipc	ra,0x1
     4e8:	9e4080e7          	jalr	-1564(ra) # ec8 <printf>
    exit(1);
     4ec:	4505                	li	a0,1
     4ee:	00000097          	auipc	ra,0x0
     4f2:	652080e7          	jalr	1618(ra) # b40 <exit>
      printf("invalid DNS reply\n");
     4f6:	00001517          	auipc	a0,0x1
     4fa:	b7a50513          	addi	a0,a0,-1158 # 1070 <malloc+0xea>
     4fe:	00001097          	auipc	ra,0x1
     502:	9ca080e7          	jalr	-1590(ra) # ec8 <printf>
      exit(1);
     506:	4505                	li	a0,1
     508:	00000097          	auipc	ra,0x0
     50c:	638080e7          	jalr	1592(ra) # b40 <exit>
      decode_qname(qn, cc - len);
     510:	409905bb          	subw	a1,s2,s1
     514:	855a                	mv	a0,s6
     516:	00000097          	auipc	ra,0x0
     51a:	aea080e7          	jalr	-1302(ra) # 0 <decode_qname>
      len += strlen(qn)+1;
     51e:	855a                	mv	a0,s6
     520:	00000097          	auipc	ra,0x0
     524:	3f2080e7          	jalr	1010(ra) # 912 <strlen>
     528:	2485                	addiw	s1,s1,1
     52a:	9ca9                	addw	s1,s1,a0
     52c:	a8a9                	j	586 <dns+0x406>
        printf("wrong ip address");
     52e:	00001517          	auipc	a0,0x1
     532:	cca50513          	addi	a0,a0,-822 # 11f8 <malloc+0x272>
     536:	00001097          	auipc	ra,0x1
     53a:	992080e7          	jalr	-1646(ra) # ec8 <printf>
        exit(1);
     53e:	4505                	li	a0,1
     540:	00000097          	auipc	ra,0x0
     544:	600080e7          	jalr	1536(ra) # b40 <exit>
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
     548:	2a05                	addiw	s4,s4,1
     54a:	77fd                	lui	a5,0xfffff
     54c:	7c678793          	addi	a5,a5,1990 # fffffffffffff7c6 <__global_pointer$+0xffffffffffffdc75>
     550:	97a2                	add	a5,a5,s0
     552:	0007d783          	lhu	a5,0(a5)
     556:	0087d713          	srli	a4,a5,0x8
     55a:	0087979b          	slliw	a5,a5,0x8
     55e:	0ff77713          	andi	a4,a4,255
     562:	8fd9                	or	a5,a5,a4
     564:	17c2                	slli	a5,a5,0x30
     566:	93c1                	srli	a5,a5,0x30
     568:	0efa5663          	bge	s4,a5,654 <dns+0x4d4>
    if(len >= cc){
     56c:	f924d5e3          	bge	s1,s2,4f6 <dns+0x376>
    char *qn = (char *) (ibuf+len);
     570:	77fd                	lui	a5,0xfffff
     572:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffdc6f>
     576:	97a2                	add	a5,a5,s0
     578:	00978b33          	add	s6,a5,s1
    if((int) qn[0] > 63) {  // compression?
     57c:	000b4783          	lbu	a5,0(s6)
     580:	f8fdf8e3          	bgeu	s11,a5,510 <dns+0x390>
      len += 2;
     584:	2489                	addiw	s1,s1,2
    struct dns_data *d = (struct dns_data *) (ibuf+len);
     586:	77fd                	lui	a5,0xfffff
     588:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffdc6f>
     58c:	97a2                	add	a5,a5,s0
     58e:	009786b3          	add	a3,a5,s1
    len += sizeof(struct dns_data);
     592:	00048b1b          	sext.w	s6,s1
     596:	24a9                	addiw	s1,s1,10
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
     598:	0006c783          	lbu	a5,0(a3)
     59c:	0016c703          	lbu	a4,1(a3)
     5a0:	0722                	slli	a4,a4,0x8
     5a2:	8fd9                	or	a5,a5,a4
     5a4:	0087979b          	slliw	a5,a5,0x8
     5a8:	8321                	srli	a4,a4,0x8
     5aa:	8fd9                	or	a5,a5,a4
     5ac:	17c2                	slli	a5,a5,0x30
     5ae:	93c1                	srli	a5,a5,0x30
     5b0:	f9579ce3          	bne	a5,s5,548 <dns+0x3c8>
     5b4:	0086c783          	lbu	a5,8(a3)
     5b8:	0096c703          	lbu	a4,9(a3)
     5bc:	0722                	slli	a4,a4,0x8
     5be:	8fd9                	or	a5,a5,a4
     5c0:	0087979b          	slliw	a5,a5,0x8
     5c4:	8321                	srli	a4,a4,0x8
     5c6:	8fd9                	or	a5,a5,a4
     5c8:	17c2                	slli	a5,a5,0x30
     5ca:	93c1                	srli	a5,a5,0x30
     5cc:	f7a79ee3          	bne	a5,s10,548 <dns+0x3c8>
      printf("DNS arecord for %s is ", qname ? qname : "" );
     5d0:	77fd                	lui	a5,0xfffff
     5d2:	7b078793          	addi	a5,a5,1968 # fffffffffffff7b0 <__global_pointer$+0xffffffffffffdc5f>
     5d6:	97a2                	add	a5,a5,s0
     5d8:	638c                	ld	a1,0(a5)
     5da:	8566                	mv	a0,s9
     5dc:	00001097          	auipc	ra,0x1
     5e0:	8ec080e7          	jalr	-1812(ra) # ec8 <printf>
      uint8 *ip = (ibuf+len);
     5e4:	77fd                	lui	a5,0xfffff
     5e6:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffdc6f>
     5ea:	97a2                	add	a5,a5,s0
     5ec:	94be                	add	s1,s1,a5
      printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
     5ee:	0034c703          	lbu	a4,3(s1)
     5f2:	0024c683          	lbu	a3,2(s1)
     5f6:	0014c603          	lbu	a2,1(s1)
     5fa:	0004c583          	lbu	a1,0(s1)
     5fe:	00001517          	auipc	a0,0x1
     602:	bea50513          	addi	a0,a0,-1046 # 11e8 <malloc+0x262>
     606:	00001097          	auipc	ra,0x1
     60a:	8c2080e7          	jalr	-1854(ra) # ec8 <printf>
      if(ip[0] != 128 || ip[1] != 52 || ip[2] != 129 || ip[3] != 126) {
     60e:	0004c783          	lbu	a5,0(s1)
     612:	f1879ee3          	bne	a5,s8,52e <dns+0x3ae>
     616:	0014c783          	lbu	a5,1(s1)
     61a:	f1779ae3          	bne	a5,s7,52e <dns+0x3ae>
     61e:	0024c703          	lbu	a4,2(s1)
     622:	08100793          	li	a5,129
     626:	f0f714e3          	bne	a4,a5,52e <dns+0x3ae>
     62a:	0034c703          	lbu	a4,3(s1)
     62e:	07e00793          	li	a5,126
     632:	eef71ee3          	bne	a4,a5,52e <dns+0x3ae>
      len += 4;
     636:	00eb049b          	addiw	s1,s6,14
      record = 1;
     63a:	77fd                	lui	a5,0xfffff
     63c:	7b878793          	addi	a5,a5,1976 # fffffffffffff7b8 <__global_pointer$+0xffffffffffffdc67>
     640:	97a2                	add	a5,a5,s0
     642:	0157b023          	sd	s5,0(a5)
     646:	b709                	j	548 <dns+0x3c8>
  int record = 0;
     648:	77fd                	lui	a5,0xfffff
     64a:	7b878793          	addi	a5,a5,1976 # fffffffffffff7b8 <__global_pointer$+0xffffffffffffdc67>
     64e:	97a2                	add	a5,a5,s0
     650:	0007b023          	sd	zero,0(a5)
     654:	77fd                	lui	a5,0xfffff
     656:	7ca78793          	addi	a5,a5,1994 # fffffffffffff7ca <__global_pointer$+0xffffffffffffdc79>
     65a:	97a2                	add	a5,a5,s0
     65c:	0007d783          	lhu	a5,0(a5)
     660:	0087d693          	srli	a3,a5,0x8
     664:	0087971b          	slliw	a4,a5,0x8
     668:	0ff6f793          	andi	a5,a3,255
     66c:	8f5d                	or	a4,a4,a5
  for(int i = 0; i < ntohs(hdr->arcount); i++) {
     66e:	1742                	slli	a4,a4,0x30
     670:	9341                	srli	a4,a4,0x30
     672:	06e05363          	blez	a4,6d8 <dns+0x558>
     676:	4581                	li	a1,0
    if(ntohs(d->type) != 41) {
     678:	02900513          	li	a0,41
    if(*qn != 0) {
     67c:	f9040793          	addi	a5,s0,-112
     680:	97a6                	add	a5,a5,s1
     682:	8307c783          	lbu	a5,-2000(a5)
     686:	e7d9                	bnez	a5,714 <dns+0x594>
    struct dns_data *d = (struct dns_data *) (ibuf+len);
     688:	0014869b          	addiw	a3,s1,1
     68c:	77fd                	lui	a5,0xfffff
     68e:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffdc6f>
     692:	97a2                	add	a5,a5,s0
     694:	96be                	add	a3,a3,a5
    len += sizeof(struct dns_data);
     696:	24ad                	addiw	s1,s1,11
    if(ntohs(d->type) != 41) {
     698:	0006c783          	lbu	a5,0(a3)
     69c:	0016c603          	lbu	a2,1(a3)
     6a0:	0622                	slli	a2,a2,0x8
     6a2:	8fd1                	or	a5,a5,a2
     6a4:	0087979b          	slliw	a5,a5,0x8
     6a8:	8221                	srli	a2,a2,0x8
     6aa:	8fd1                	or	a5,a5,a2
     6ac:	17c2                	slli	a5,a5,0x30
     6ae:	93c1                	srli	a5,a5,0x30
     6b0:	06a79f63          	bne	a5,a0,72e <dns+0x5ae>
    len += ntohs(d->len);
     6b4:	0086c783          	lbu	a5,8(a3)
     6b8:	0096c683          	lbu	a3,9(a3)
     6bc:	06a2                	slli	a3,a3,0x8
     6be:	8fd5                	or	a5,a5,a3
     6c0:	0087979b          	slliw	a5,a5,0x8
     6c4:	82a1                	srli	a3,a3,0x8
     6c6:	8fd5                	or	a5,a5,a3
     6c8:	0107979b          	slliw	a5,a5,0x10
     6cc:	0107d79b          	srliw	a5,a5,0x10
     6d0:	9cbd                	addw	s1,s1,a5
  for(int i = 0; i < ntohs(hdr->arcount); i++) {
     6d2:	2585                	addiw	a1,a1,1
     6d4:	fab714e3          	bne	a4,a1,67c <dns+0x4fc>
  if(len != cc) {
     6d8:	06991863          	bne	s2,s1,748 <dns+0x5c8>
  if(!record) {
     6dc:	77fd                	lui	a5,0xfffff
     6de:	7b878793          	addi	a5,a5,1976 # fffffffffffff7b8 <__global_pointer$+0xffffffffffffdc67>
     6e2:	97a2                	add	a5,a5,s0
     6e4:	639c                	ld	a5,0(a5)
     6e6:	c3c1                	beqz	a5,766 <dns+0x5e6>
  }
  dns_rep(ibuf, cc);

  close(fd);
     6e8:	854e                	mv	a0,s3
     6ea:	00000097          	auipc	ra,0x0
     6ee:	47e080e7          	jalr	1150(ra) # b68 <close>
}  
     6f2:	7d010113          	addi	sp,sp,2000
     6f6:	70e6                	ld	ra,120(sp)
     6f8:	7446                	ld	s0,112(sp)
     6fa:	74a6                	ld	s1,104(sp)
     6fc:	7906                	ld	s2,96(sp)
     6fe:	69e6                	ld	s3,88(sp)
     700:	6a46                	ld	s4,80(sp)
     702:	6aa6                	ld	s5,72(sp)
     704:	6b06                	ld	s6,64(sp)
     706:	7be2                	ld	s7,56(sp)
     708:	7c42                	ld	s8,48(sp)
     70a:	7ca2                	ld	s9,40(sp)
     70c:	7d02                	ld	s10,32(sp)
     70e:	6de2                	ld	s11,24(sp)
     710:	6109                	addi	sp,sp,128
     712:	8082                	ret
      printf("invalid name for EDNS\n");
     714:	00001517          	auipc	a0,0x1
     718:	afc50513          	addi	a0,a0,-1284 # 1210 <malloc+0x28a>
     71c:	00000097          	auipc	ra,0x0
     720:	7ac080e7          	jalr	1964(ra) # ec8 <printf>
      exit(1);
     724:	4505                	li	a0,1
     726:	00000097          	auipc	ra,0x0
     72a:	41a080e7          	jalr	1050(ra) # b40 <exit>
      printf("invalid type for EDNS\n");
     72e:	00001517          	auipc	a0,0x1
     732:	afa50513          	addi	a0,a0,-1286 # 1228 <malloc+0x2a2>
     736:	00000097          	auipc	ra,0x0
     73a:	792080e7          	jalr	1938(ra) # ec8 <printf>
      exit(1);
     73e:	4505                	li	a0,1
     740:	00000097          	auipc	ra,0x0
     744:	400080e7          	jalr	1024(ra) # b40 <exit>
    printf("Processed %d data bytes but received %d\n", len, cc);
     748:	864a                	mv	a2,s2
     74a:	85a6                	mv	a1,s1
     74c:	00001517          	auipc	a0,0x1
     750:	af450513          	addi	a0,a0,-1292 # 1240 <malloc+0x2ba>
     754:	00000097          	auipc	ra,0x0
     758:	774080e7          	jalr	1908(ra) # ec8 <printf>
    exit(1);
     75c:	4505                	li	a0,1
     75e:	00000097          	auipc	ra,0x0
     762:	3e2080e7          	jalr	994(ra) # b40 <exit>
    printf("Didn't receive an arecord\n");
     766:	00001517          	auipc	a0,0x1
     76a:	b0a50513          	addi	a0,a0,-1270 # 1270 <malloc+0x2ea>
     76e:	00000097          	auipc	ra,0x0
     772:	75a080e7          	jalr	1882(ra) # ec8 <printf>
    exit(1);
     776:	4505                	li	a0,1
     778:	00000097          	auipc	ra,0x0
     77c:	3c8080e7          	jalr	968(ra) # b40 <exit>

0000000000000780 <main>:

int
main(int argc, char *argv[])
{
     780:	7179                	addi	sp,sp,-48
     782:	f406                	sd	ra,40(sp)
     784:	f022                	sd	s0,32(sp)
     786:	ec26                	sd	s1,24(sp)
     788:	e84a                	sd	s2,16(sp)
     78a:	1800                	addi	s0,sp,48
  int i, ret;
  uint16 dport = NET_TESTS_PORT;

  printf("nettests running on port %d\n", dport);
     78c:	6499                	lui	s1,0x6
     78e:	5f348593          	addi	a1,s1,1523 # 65f3 <__global_pointer$+0x4aa2>
     792:	00001517          	auipc	a0,0x1
     796:	afe50513          	addi	a0,a0,-1282 # 1290 <malloc+0x30a>
     79a:	00000097          	auipc	ra,0x0
     79e:	72e080e7          	jalr	1838(ra) # ec8 <printf>
  
  printf("testing ping: ");
     7a2:	00001517          	auipc	a0,0x1
     7a6:	b0e50513          	addi	a0,a0,-1266 # 12b0 <malloc+0x32a>
     7aa:	00000097          	auipc	ra,0x0
     7ae:	71e080e7          	jalr	1822(ra) # ec8 <printf>
  ping(2000, dport, 1);
     7b2:	4605                	li	a2,1
     7b4:	5f348593          	addi	a1,s1,1523
     7b8:	7d000513          	li	a0,2000
     7bc:	00000097          	auipc	ra,0x0
     7c0:	8a4080e7          	jalr	-1884(ra) # 60 <ping>
  printf("OK\n");
     7c4:	00001517          	auipc	a0,0x1
     7c8:	afc50513          	addi	a0,a0,-1284 # 12c0 <malloc+0x33a>
     7cc:	00000097          	auipc	ra,0x0
     7d0:	6fc080e7          	jalr	1788(ra) # ec8 <printf>
  
  printf("testing single-process pings: ");
     7d4:	00001517          	auipc	a0,0x1
     7d8:	af450513          	addi	a0,a0,-1292 # 12c8 <malloc+0x342>
     7dc:	00000097          	auipc	ra,0x0
     7e0:	6ec080e7          	jalr	1772(ra) # ec8 <printf>
     7e4:	06400493          	li	s1,100
  for (i = 0; i < 100; i++)
    ping(2000, dport, 1);
     7e8:	6919                	lui	s2,0x6
     7ea:	5f390913          	addi	s2,s2,1523 # 65f3 <__global_pointer$+0x4aa2>
     7ee:	4605                	li	a2,1
     7f0:	85ca                	mv	a1,s2
     7f2:	7d000513          	li	a0,2000
     7f6:	00000097          	auipc	ra,0x0
     7fa:	86a080e7          	jalr	-1942(ra) # 60 <ping>
  for (i = 0; i < 100; i++)
     7fe:	34fd                	addiw	s1,s1,-1
     800:	f4fd                	bnez	s1,7ee <main+0x6e>
  printf("OK\n");
     802:	00001517          	auipc	a0,0x1
     806:	abe50513          	addi	a0,a0,-1346 # 12c0 <malloc+0x33a>
     80a:	00000097          	auipc	ra,0x0
     80e:	6be080e7          	jalr	1726(ra) # ec8 <printf>
  
  printf("testing multi-process pings: ");
     812:	00001517          	auipc	a0,0x1
     816:	ad650513          	addi	a0,a0,-1322 # 12e8 <malloc+0x362>
     81a:	00000097          	auipc	ra,0x0
     81e:	6ae080e7          	jalr	1710(ra) # ec8 <printf>
  for (i = 0; i < 10; i++){
     822:	4929                	li	s2,10
    int pid = fork();
     824:	00000097          	auipc	ra,0x0
     828:	314080e7          	jalr	788(ra) # b38 <fork>
    if (pid == 0){
     82c:	c92d                	beqz	a0,89e <main+0x11e>
  for (i = 0; i < 10; i++){
     82e:	2485                	addiw	s1,s1,1
     830:	ff249ae3          	bne	s1,s2,824 <main+0xa4>
     834:	44a9                	li	s1,10
      ping(2000 + i + 1, dport, 1);
      exit(0);
    }
  }
  for (i = 0; i < 10; i++){
    wait(&ret);
     836:	fdc40513          	addi	a0,s0,-36
     83a:	00000097          	auipc	ra,0x0
     83e:	30e080e7          	jalr	782(ra) # b48 <wait>
    if (ret != 0)
     842:	fdc42783          	lw	a5,-36(s0)
     846:	efad                	bnez	a5,8c0 <main+0x140>
  for (i = 0; i < 10; i++){
     848:	34fd                	addiw	s1,s1,-1
     84a:	f4f5                	bnez	s1,836 <main+0xb6>
      exit(1);
  }
  printf("OK\n");
     84c:	00001517          	auipc	a0,0x1
     850:	a7450513          	addi	a0,a0,-1420 # 12c0 <malloc+0x33a>
     854:	00000097          	auipc	ra,0x0
     858:	674080e7          	jalr	1652(ra) # ec8 <printf>
  
  printf("testing DNS\n");
     85c:	00001517          	auipc	a0,0x1
     860:	aac50513          	addi	a0,a0,-1364 # 1308 <malloc+0x382>
     864:	00000097          	auipc	ra,0x0
     868:	664080e7          	jalr	1636(ra) # ec8 <printf>
  dns();
     86c:	00000097          	auipc	ra,0x0
     870:	914080e7          	jalr	-1772(ra) # 180 <dns>
  printf("DNS OK\n");
     874:	00001517          	auipc	a0,0x1
     878:	aa450513          	addi	a0,a0,-1372 # 1318 <malloc+0x392>
     87c:	00000097          	auipc	ra,0x0
     880:	64c080e7          	jalr	1612(ra) # ec8 <printf>
  
  printf("all tests passed.\n");
     884:	00001517          	auipc	a0,0x1
     888:	a9c50513          	addi	a0,a0,-1380 # 1320 <malloc+0x39a>
     88c:	00000097          	auipc	ra,0x0
     890:	63c080e7          	jalr	1596(ra) # ec8 <printf>
  exit(0);
     894:	4501                	li	a0,0
     896:	00000097          	auipc	ra,0x0
     89a:	2aa080e7          	jalr	682(ra) # b40 <exit>
      ping(2000 + i + 1, dport, 1);
     89e:	7d14851b          	addiw	a0,s1,2001
     8a2:	4605                	li	a2,1
     8a4:	6599                	lui	a1,0x6
     8a6:	5f358593          	addi	a1,a1,1523 # 65f3 <__global_pointer$+0x4aa2>
     8aa:	1542                	slli	a0,a0,0x30
     8ac:	9141                	srli	a0,a0,0x30
     8ae:	fffff097          	auipc	ra,0xfffff
     8b2:	7b2080e7          	jalr	1970(ra) # 60 <ping>
      exit(0);
     8b6:	4501                	li	a0,0
     8b8:	00000097          	auipc	ra,0x0
     8bc:	288080e7          	jalr	648(ra) # b40 <exit>
      exit(1);
     8c0:	4505                	li	a0,1
     8c2:	00000097          	auipc	ra,0x0
     8c6:	27e080e7          	jalr	638(ra) # b40 <exit>

00000000000008ca <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     8ca:	1141                	addi	sp,sp,-16
     8cc:	e422                	sd	s0,8(sp)
     8ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     8d0:	87aa                	mv	a5,a0
     8d2:	0585                	addi	a1,a1,1
     8d4:	0785                	addi	a5,a5,1
     8d6:	fff5c703          	lbu	a4,-1(a1)
     8da:	fee78fa3          	sb	a4,-1(a5)
     8de:	fb75                	bnez	a4,8d2 <strcpy+0x8>
    ;
  return os;
}
     8e0:	6422                	ld	s0,8(sp)
     8e2:	0141                	addi	sp,sp,16
     8e4:	8082                	ret

00000000000008e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     8e6:	1141                	addi	sp,sp,-16
     8e8:	e422                	sd	s0,8(sp)
     8ea:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     8ec:	00054783          	lbu	a5,0(a0)
     8f0:	cb91                	beqz	a5,904 <strcmp+0x1e>
     8f2:	0005c703          	lbu	a4,0(a1)
     8f6:	00f71763          	bne	a4,a5,904 <strcmp+0x1e>
    p++, q++;
     8fa:	0505                	addi	a0,a0,1
     8fc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     8fe:	00054783          	lbu	a5,0(a0)
     902:	fbe5                	bnez	a5,8f2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     904:	0005c503          	lbu	a0,0(a1)
}
     908:	40a7853b          	subw	a0,a5,a0
     90c:	6422                	ld	s0,8(sp)
     90e:	0141                	addi	sp,sp,16
     910:	8082                	ret

0000000000000912 <strlen>:

uint
strlen(const char *s)
{
     912:	1141                	addi	sp,sp,-16
     914:	e422                	sd	s0,8(sp)
     916:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     918:	00054783          	lbu	a5,0(a0)
     91c:	cf91                	beqz	a5,938 <strlen+0x26>
     91e:	0505                	addi	a0,a0,1
     920:	87aa                	mv	a5,a0
     922:	4685                	li	a3,1
     924:	9e89                	subw	a3,a3,a0
     926:	00f6853b          	addw	a0,a3,a5
     92a:	0785                	addi	a5,a5,1
     92c:	fff7c703          	lbu	a4,-1(a5)
     930:	fb7d                	bnez	a4,926 <strlen+0x14>
    ;
  return n;
}
     932:	6422                	ld	s0,8(sp)
     934:	0141                	addi	sp,sp,16
     936:	8082                	ret
  for(n = 0; s[n]; n++)
     938:	4501                	li	a0,0
     93a:	bfe5                	j	932 <strlen+0x20>

000000000000093c <memset>:

void*
memset(void *dst, int c, uint n)
{
     93c:	1141                	addi	sp,sp,-16
     93e:	e422                	sd	s0,8(sp)
     940:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     942:	ce09                	beqz	a2,95c <memset+0x20>
     944:	87aa                	mv	a5,a0
     946:	fff6071b          	addiw	a4,a2,-1
     94a:	1702                	slli	a4,a4,0x20
     94c:	9301                	srli	a4,a4,0x20
     94e:	0705                	addi	a4,a4,1
     950:	972a                	add	a4,a4,a0
    cdst[i] = c;
     952:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     956:	0785                	addi	a5,a5,1
     958:	fee79de3          	bne	a5,a4,952 <memset+0x16>
  }
  return dst;
}
     95c:	6422                	ld	s0,8(sp)
     95e:	0141                	addi	sp,sp,16
     960:	8082                	ret

0000000000000962 <strchr>:

char*
strchr(const char *s, char c)
{
     962:	1141                	addi	sp,sp,-16
     964:	e422                	sd	s0,8(sp)
     966:	0800                	addi	s0,sp,16
  for(; *s; s++)
     968:	00054783          	lbu	a5,0(a0)
     96c:	cb99                	beqz	a5,982 <strchr+0x20>
    if(*s == c)
     96e:	00f58763          	beq	a1,a5,97c <strchr+0x1a>
  for(; *s; s++)
     972:	0505                	addi	a0,a0,1
     974:	00054783          	lbu	a5,0(a0)
     978:	fbfd                	bnez	a5,96e <strchr+0xc>
      return (char*)s;
  return 0;
     97a:	4501                	li	a0,0
}
     97c:	6422                	ld	s0,8(sp)
     97e:	0141                	addi	sp,sp,16
     980:	8082                	ret
  return 0;
     982:	4501                	li	a0,0
     984:	bfe5                	j	97c <strchr+0x1a>

0000000000000986 <gets>:

char*
gets(char *buf, int max)
{
     986:	711d                	addi	sp,sp,-96
     988:	ec86                	sd	ra,88(sp)
     98a:	e8a2                	sd	s0,80(sp)
     98c:	e4a6                	sd	s1,72(sp)
     98e:	e0ca                	sd	s2,64(sp)
     990:	fc4e                	sd	s3,56(sp)
     992:	f852                	sd	s4,48(sp)
     994:	f456                	sd	s5,40(sp)
     996:	f05a                	sd	s6,32(sp)
     998:	ec5e                	sd	s7,24(sp)
     99a:	1080                	addi	s0,sp,96
     99c:	8baa                	mv	s7,a0
     99e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9a0:	892a                	mv	s2,a0
     9a2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     9a4:	4aa9                	li	s5,10
     9a6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     9a8:	89a6                	mv	s3,s1
     9aa:	2485                	addiw	s1,s1,1
     9ac:	0344d863          	bge	s1,s4,9dc <gets+0x56>
    cc = read(0, &c, 1);
     9b0:	4605                	li	a2,1
     9b2:	faf40593          	addi	a1,s0,-81
     9b6:	4501                	li	a0,0
     9b8:	00000097          	auipc	ra,0x0
     9bc:	1a0080e7          	jalr	416(ra) # b58 <read>
    if(cc < 1)
     9c0:	00a05e63          	blez	a0,9dc <gets+0x56>
    buf[i++] = c;
     9c4:	faf44783          	lbu	a5,-81(s0)
     9c8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     9cc:	01578763          	beq	a5,s5,9da <gets+0x54>
     9d0:	0905                	addi	s2,s2,1
     9d2:	fd679be3          	bne	a5,s6,9a8 <gets+0x22>
  for(i=0; i+1 < max; ){
     9d6:	89a6                	mv	s3,s1
     9d8:	a011                	j	9dc <gets+0x56>
     9da:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     9dc:	99de                	add	s3,s3,s7
     9de:	00098023          	sb	zero,0(s3)
  return buf;
}
     9e2:	855e                	mv	a0,s7
     9e4:	60e6                	ld	ra,88(sp)
     9e6:	6446                	ld	s0,80(sp)
     9e8:	64a6                	ld	s1,72(sp)
     9ea:	6906                	ld	s2,64(sp)
     9ec:	79e2                	ld	s3,56(sp)
     9ee:	7a42                	ld	s4,48(sp)
     9f0:	7aa2                	ld	s5,40(sp)
     9f2:	7b02                	ld	s6,32(sp)
     9f4:	6be2                	ld	s7,24(sp)
     9f6:	6125                	addi	sp,sp,96
     9f8:	8082                	ret

00000000000009fa <stat>:

int
stat(const char *n, struct stat *st)
{
     9fa:	1101                	addi	sp,sp,-32
     9fc:	ec06                	sd	ra,24(sp)
     9fe:	e822                	sd	s0,16(sp)
     a00:	e426                	sd	s1,8(sp)
     a02:	e04a                	sd	s2,0(sp)
     a04:	1000                	addi	s0,sp,32
     a06:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a08:	4581                	li	a1,0
     a0a:	00000097          	auipc	ra,0x0
     a0e:	176080e7          	jalr	374(ra) # b80 <open>
  if(fd < 0)
     a12:	02054563          	bltz	a0,a3c <stat+0x42>
     a16:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a18:	85ca                	mv	a1,s2
     a1a:	00000097          	auipc	ra,0x0
     a1e:	17e080e7          	jalr	382(ra) # b98 <fstat>
     a22:	892a                	mv	s2,a0
  close(fd);
     a24:	8526                	mv	a0,s1
     a26:	00000097          	auipc	ra,0x0
     a2a:	142080e7          	jalr	322(ra) # b68 <close>
  return r;
}
     a2e:	854a                	mv	a0,s2
     a30:	60e2                	ld	ra,24(sp)
     a32:	6442                	ld	s0,16(sp)
     a34:	64a2                	ld	s1,8(sp)
     a36:	6902                	ld	s2,0(sp)
     a38:	6105                	addi	sp,sp,32
     a3a:	8082                	ret
    return -1;
     a3c:	597d                	li	s2,-1
     a3e:	bfc5                	j	a2e <stat+0x34>

0000000000000a40 <atoi>:

int
atoi(const char *s)
{
     a40:	1141                	addi	sp,sp,-16
     a42:	e422                	sd	s0,8(sp)
     a44:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a46:	00054603          	lbu	a2,0(a0)
     a4a:	fd06079b          	addiw	a5,a2,-48
     a4e:	0ff7f793          	andi	a5,a5,255
     a52:	4725                	li	a4,9
     a54:	02f76963          	bltu	a4,a5,a86 <atoi+0x46>
     a58:	86aa                	mv	a3,a0
  n = 0;
     a5a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     a5c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     a5e:	0685                	addi	a3,a3,1
     a60:	0025179b          	slliw	a5,a0,0x2
     a64:	9fa9                	addw	a5,a5,a0
     a66:	0017979b          	slliw	a5,a5,0x1
     a6a:	9fb1                	addw	a5,a5,a2
     a6c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     a70:	0006c603          	lbu	a2,0(a3)
     a74:	fd06071b          	addiw	a4,a2,-48
     a78:	0ff77713          	andi	a4,a4,255
     a7c:	fee5f1e3          	bgeu	a1,a4,a5e <atoi+0x1e>
  return n;
}
     a80:	6422                	ld	s0,8(sp)
     a82:	0141                	addi	sp,sp,16
     a84:	8082                	ret
  n = 0;
     a86:	4501                	li	a0,0
     a88:	bfe5                	j	a80 <atoi+0x40>

0000000000000a8a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     a8a:	1141                	addi	sp,sp,-16
     a8c:	e422                	sd	s0,8(sp)
     a8e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     a90:	02b57663          	bgeu	a0,a1,abc <memmove+0x32>
    while(n-- > 0)
     a94:	02c05163          	blez	a2,ab6 <memmove+0x2c>
     a98:	fff6079b          	addiw	a5,a2,-1
     a9c:	1782                	slli	a5,a5,0x20
     a9e:	9381                	srli	a5,a5,0x20
     aa0:	0785                	addi	a5,a5,1
     aa2:	97aa                	add	a5,a5,a0
  dst = vdst;
     aa4:	872a                	mv	a4,a0
      *dst++ = *src++;
     aa6:	0585                	addi	a1,a1,1
     aa8:	0705                	addi	a4,a4,1
     aaa:	fff5c683          	lbu	a3,-1(a1)
     aae:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     ab2:	fee79ae3          	bne	a5,a4,aa6 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ab6:	6422                	ld	s0,8(sp)
     ab8:	0141                	addi	sp,sp,16
     aba:	8082                	ret
    dst += n;
     abc:	00c50733          	add	a4,a0,a2
    src += n;
     ac0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     ac2:	fec05ae3          	blez	a2,ab6 <memmove+0x2c>
     ac6:	fff6079b          	addiw	a5,a2,-1
     aca:	1782                	slli	a5,a5,0x20
     acc:	9381                	srli	a5,a5,0x20
     ace:	fff7c793          	not	a5,a5
     ad2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     ad4:	15fd                	addi	a1,a1,-1
     ad6:	177d                	addi	a4,a4,-1
     ad8:	0005c683          	lbu	a3,0(a1)
     adc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     ae0:	fee79ae3          	bne	a5,a4,ad4 <memmove+0x4a>
     ae4:	bfc9                	j	ab6 <memmove+0x2c>

0000000000000ae6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     ae6:	1141                	addi	sp,sp,-16
     ae8:	e422                	sd	s0,8(sp)
     aea:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     aec:	ca05                	beqz	a2,b1c <memcmp+0x36>
     aee:	fff6069b          	addiw	a3,a2,-1
     af2:	1682                	slli	a3,a3,0x20
     af4:	9281                	srli	a3,a3,0x20
     af6:	0685                	addi	a3,a3,1
     af8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     afa:	00054783          	lbu	a5,0(a0)
     afe:	0005c703          	lbu	a4,0(a1)
     b02:	00e79863          	bne	a5,a4,b12 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b06:	0505                	addi	a0,a0,1
    p2++;
     b08:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b0a:	fed518e3          	bne	a0,a3,afa <memcmp+0x14>
  }
  return 0;
     b0e:	4501                	li	a0,0
     b10:	a019                	j	b16 <memcmp+0x30>
      return *p1 - *p2;
     b12:	40e7853b          	subw	a0,a5,a4
}
     b16:	6422                	ld	s0,8(sp)
     b18:	0141                	addi	sp,sp,16
     b1a:	8082                	ret
  return 0;
     b1c:	4501                	li	a0,0
     b1e:	bfe5                	j	b16 <memcmp+0x30>

0000000000000b20 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b20:	1141                	addi	sp,sp,-16
     b22:	e406                	sd	ra,8(sp)
     b24:	e022                	sd	s0,0(sp)
     b26:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b28:	00000097          	auipc	ra,0x0
     b2c:	f62080e7          	jalr	-158(ra) # a8a <memmove>
}
     b30:	60a2                	ld	ra,8(sp)
     b32:	6402                	ld	s0,0(sp)
     b34:	0141                	addi	sp,sp,16
     b36:	8082                	ret

0000000000000b38 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b38:	4885                	li	a7,1
 ecall
     b3a:	00000073          	ecall
 ret
     b3e:	8082                	ret

0000000000000b40 <exit>:
.global exit
exit:
 li a7, SYS_exit
     b40:	4889                	li	a7,2
 ecall
     b42:	00000073          	ecall
 ret
     b46:	8082                	ret

0000000000000b48 <wait>:
.global wait
wait:
 li a7, SYS_wait
     b48:	488d                	li	a7,3
 ecall
     b4a:	00000073          	ecall
 ret
     b4e:	8082                	ret

0000000000000b50 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b50:	4891                	li	a7,4
 ecall
     b52:	00000073          	ecall
 ret
     b56:	8082                	ret

0000000000000b58 <read>:
.global read
read:
 li a7, SYS_read
     b58:	4895                	li	a7,5
 ecall
     b5a:	00000073          	ecall
 ret
     b5e:	8082                	ret

0000000000000b60 <write>:
.global write
write:
 li a7, SYS_write
     b60:	48c1                	li	a7,16
 ecall
     b62:	00000073          	ecall
 ret
     b66:	8082                	ret

0000000000000b68 <close>:
.global close
close:
 li a7, SYS_close
     b68:	48d5                	li	a7,21
 ecall
     b6a:	00000073          	ecall
 ret
     b6e:	8082                	ret

0000000000000b70 <kill>:
.global kill
kill:
 li a7, SYS_kill
     b70:	4899                	li	a7,6
 ecall
     b72:	00000073          	ecall
 ret
     b76:	8082                	ret

0000000000000b78 <exec>:
.global exec
exec:
 li a7, SYS_exec
     b78:	489d                	li	a7,7
 ecall
     b7a:	00000073          	ecall
 ret
     b7e:	8082                	ret

0000000000000b80 <open>:
.global open
open:
 li a7, SYS_open
     b80:	48bd                	li	a7,15
 ecall
     b82:	00000073          	ecall
 ret
     b86:	8082                	ret

0000000000000b88 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b88:	48c5                	li	a7,17
 ecall
     b8a:	00000073          	ecall
 ret
     b8e:	8082                	ret

0000000000000b90 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b90:	48c9                	li	a7,18
 ecall
     b92:	00000073          	ecall
 ret
     b96:	8082                	ret

0000000000000b98 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     b98:	48a1                	li	a7,8
 ecall
     b9a:	00000073          	ecall
 ret
     b9e:	8082                	ret

0000000000000ba0 <link>:
.global link
link:
 li a7, SYS_link
     ba0:	48cd                	li	a7,19
 ecall
     ba2:	00000073          	ecall
 ret
     ba6:	8082                	ret

0000000000000ba8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     ba8:	48d1                	li	a7,20
 ecall
     baa:	00000073          	ecall
 ret
     bae:	8082                	ret

0000000000000bb0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     bb0:	48a5                	li	a7,9
 ecall
     bb2:	00000073          	ecall
 ret
     bb6:	8082                	ret

0000000000000bb8 <dup>:
.global dup
dup:
 li a7, SYS_dup
     bb8:	48a9                	li	a7,10
 ecall
     bba:	00000073          	ecall
 ret
     bbe:	8082                	ret

0000000000000bc0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     bc0:	48ad                	li	a7,11
 ecall
     bc2:	00000073          	ecall
 ret
     bc6:	8082                	ret

0000000000000bc8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     bc8:	48b1                	li	a7,12
 ecall
     bca:	00000073          	ecall
 ret
     bce:	8082                	ret

0000000000000bd0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     bd0:	48b5                	li	a7,13
 ecall
     bd2:	00000073          	ecall
 ret
     bd6:	8082                	ret

0000000000000bd8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     bd8:	48b9                	li	a7,14
 ecall
     bda:	00000073          	ecall
 ret
     bde:	8082                	ret

0000000000000be0 <connect>:
.global connect
connect:
 li a7, SYS_connect
     be0:	48f5                	li	a7,29
 ecall
     be2:	00000073          	ecall
 ret
     be6:	8082                	ret

0000000000000be8 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     be8:	48f9                	li	a7,30
 ecall
     bea:	00000073          	ecall
 ret
     bee:	8082                	ret

0000000000000bf0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     bf0:	1101                	addi	sp,sp,-32
     bf2:	ec06                	sd	ra,24(sp)
     bf4:	e822                	sd	s0,16(sp)
     bf6:	1000                	addi	s0,sp,32
     bf8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     bfc:	4605                	li	a2,1
     bfe:	fef40593          	addi	a1,s0,-17
     c02:	00000097          	auipc	ra,0x0
     c06:	f5e080e7          	jalr	-162(ra) # b60 <write>
}
     c0a:	60e2                	ld	ra,24(sp)
     c0c:	6442                	ld	s0,16(sp)
     c0e:	6105                	addi	sp,sp,32
     c10:	8082                	ret

0000000000000c12 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c12:	7139                	addi	sp,sp,-64
     c14:	fc06                	sd	ra,56(sp)
     c16:	f822                	sd	s0,48(sp)
     c18:	f426                	sd	s1,40(sp)
     c1a:	f04a                	sd	s2,32(sp)
     c1c:	ec4e                	sd	s3,24(sp)
     c1e:	0080                	addi	s0,sp,64
     c20:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c22:	c299                	beqz	a3,c28 <printint+0x16>
     c24:	0805c863          	bltz	a1,cb4 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     c28:	2581                	sext.w	a1,a1
  neg = 0;
     c2a:	4881                	li	a7,0
     c2c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     c30:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c32:	2601                	sext.w	a2,a2
     c34:	00000517          	auipc	a0,0x0
     c38:	70c50513          	addi	a0,a0,1804 # 1340 <digits>
     c3c:	883a                	mv	a6,a4
     c3e:	2705                	addiw	a4,a4,1
     c40:	02c5f7bb          	remuw	a5,a1,a2
     c44:	1782                	slli	a5,a5,0x20
     c46:	9381                	srli	a5,a5,0x20
     c48:	97aa                	add	a5,a5,a0
     c4a:	0007c783          	lbu	a5,0(a5)
     c4e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c52:	0005879b          	sext.w	a5,a1
     c56:	02c5d5bb          	divuw	a1,a1,a2
     c5a:	0685                	addi	a3,a3,1
     c5c:	fec7f0e3          	bgeu	a5,a2,c3c <printint+0x2a>
  if(neg)
     c60:	00088b63          	beqz	a7,c76 <printint+0x64>
    buf[i++] = '-';
     c64:	fd040793          	addi	a5,s0,-48
     c68:	973e                	add	a4,a4,a5
     c6a:	02d00793          	li	a5,45
     c6e:	fef70823          	sb	a5,-16(a4)
     c72:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     c76:	02e05863          	blez	a4,ca6 <printint+0x94>
     c7a:	fc040793          	addi	a5,s0,-64
     c7e:	00e78933          	add	s2,a5,a4
     c82:	fff78993          	addi	s3,a5,-1
     c86:	99ba                	add	s3,s3,a4
     c88:	377d                	addiw	a4,a4,-1
     c8a:	1702                	slli	a4,a4,0x20
     c8c:	9301                	srli	a4,a4,0x20
     c8e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     c92:	fff94583          	lbu	a1,-1(s2)
     c96:	8526                	mv	a0,s1
     c98:	00000097          	auipc	ra,0x0
     c9c:	f58080e7          	jalr	-168(ra) # bf0 <putc>
  while(--i >= 0)
     ca0:	197d                	addi	s2,s2,-1
     ca2:	ff3918e3          	bne	s2,s3,c92 <printint+0x80>
}
     ca6:	70e2                	ld	ra,56(sp)
     ca8:	7442                	ld	s0,48(sp)
     caa:	74a2                	ld	s1,40(sp)
     cac:	7902                	ld	s2,32(sp)
     cae:	69e2                	ld	s3,24(sp)
     cb0:	6121                	addi	sp,sp,64
     cb2:	8082                	ret
    x = -xx;
     cb4:	40b005bb          	negw	a1,a1
    neg = 1;
     cb8:	4885                	li	a7,1
    x = -xx;
     cba:	bf8d                	j	c2c <printint+0x1a>

0000000000000cbc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     cbc:	7119                	addi	sp,sp,-128
     cbe:	fc86                	sd	ra,120(sp)
     cc0:	f8a2                	sd	s0,112(sp)
     cc2:	f4a6                	sd	s1,104(sp)
     cc4:	f0ca                	sd	s2,96(sp)
     cc6:	ecce                	sd	s3,88(sp)
     cc8:	e8d2                	sd	s4,80(sp)
     cca:	e4d6                	sd	s5,72(sp)
     ccc:	e0da                	sd	s6,64(sp)
     cce:	fc5e                	sd	s7,56(sp)
     cd0:	f862                	sd	s8,48(sp)
     cd2:	f466                	sd	s9,40(sp)
     cd4:	f06a                	sd	s10,32(sp)
     cd6:	ec6e                	sd	s11,24(sp)
     cd8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     cda:	0005c903          	lbu	s2,0(a1)
     cde:	18090f63          	beqz	s2,e7c <vprintf+0x1c0>
     ce2:	8aaa                	mv	s5,a0
     ce4:	8b32                	mv	s6,a2
     ce6:	00158493          	addi	s1,a1,1
  state = 0;
     cea:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     cec:	02500a13          	li	s4,37
      if(c == 'd'){
     cf0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     cf4:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     cf8:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     cfc:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d00:	00000b97          	auipc	s7,0x0
     d04:	640b8b93          	addi	s7,s7,1600 # 1340 <digits>
     d08:	a839                	j	d26 <vprintf+0x6a>
        putc(fd, c);
     d0a:	85ca                	mv	a1,s2
     d0c:	8556                	mv	a0,s5
     d0e:	00000097          	auipc	ra,0x0
     d12:	ee2080e7          	jalr	-286(ra) # bf0 <putc>
     d16:	a019                	j	d1c <vprintf+0x60>
    } else if(state == '%'){
     d18:	01498f63          	beq	s3,s4,d36 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     d1c:	0485                	addi	s1,s1,1
     d1e:	fff4c903          	lbu	s2,-1(s1)
     d22:	14090d63          	beqz	s2,e7c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
     d26:	0009079b          	sext.w	a5,s2
    if(state == 0){
     d2a:	fe0997e3          	bnez	s3,d18 <vprintf+0x5c>
      if(c == '%'){
     d2e:	fd479ee3          	bne	a5,s4,d0a <vprintf+0x4e>
        state = '%';
     d32:	89be                	mv	s3,a5
     d34:	b7e5                	j	d1c <vprintf+0x60>
      if(c == 'd'){
     d36:	05878063          	beq	a5,s8,d76 <vprintf+0xba>
      } else if(c == 'l') {
     d3a:	05978c63          	beq	a5,s9,d92 <vprintf+0xd6>
      } else if(c == 'x') {
     d3e:	07a78863          	beq	a5,s10,dae <vprintf+0xf2>
      } else if(c == 'p') {
     d42:	09b78463          	beq	a5,s11,dca <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
     d46:	07300713          	li	a4,115
     d4a:	0ce78663          	beq	a5,a4,e16 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     d4e:	06300713          	li	a4,99
     d52:	0ee78e63          	beq	a5,a4,e4e <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
     d56:	11478863          	beq	a5,s4,e66 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     d5a:	85d2                	mv	a1,s4
     d5c:	8556                	mv	a0,s5
     d5e:	00000097          	auipc	ra,0x0
     d62:	e92080e7          	jalr	-366(ra) # bf0 <putc>
        putc(fd, c);
     d66:	85ca                	mv	a1,s2
     d68:	8556                	mv	a0,s5
     d6a:	00000097          	auipc	ra,0x0
     d6e:	e86080e7          	jalr	-378(ra) # bf0 <putc>
      }
      state = 0;
     d72:	4981                	li	s3,0
     d74:	b765                	j	d1c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
     d76:	008b0913          	addi	s2,s6,8
     d7a:	4685                	li	a3,1
     d7c:	4629                	li	a2,10
     d7e:	000b2583          	lw	a1,0(s6)
     d82:	8556                	mv	a0,s5
     d84:	00000097          	auipc	ra,0x0
     d88:	e8e080e7          	jalr	-370(ra) # c12 <printint>
     d8c:	8b4a                	mv	s6,s2
      state = 0;
     d8e:	4981                	li	s3,0
     d90:	b771                	j	d1c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     d92:	008b0913          	addi	s2,s6,8
     d96:	4681                	li	a3,0
     d98:	4629                	li	a2,10
     d9a:	000b2583          	lw	a1,0(s6)
     d9e:	8556                	mv	a0,s5
     da0:	00000097          	auipc	ra,0x0
     da4:	e72080e7          	jalr	-398(ra) # c12 <printint>
     da8:	8b4a                	mv	s6,s2
      state = 0;
     daa:	4981                	li	s3,0
     dac:	bf85                	j	d1c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     dae:	008b0913          	addi	s2,s6,8
     db2:	4681                	li	a3,0
     db4:	4641                	li	a2,16
     db6:	000b2583          	lw	a1,0(s6)
     dba:	8556                	mv	a0,s5
     dbc:	00000097          	auipc	ra,0x0
     dc0:	e56080e7          	jalr	-426(ra) # c12 <printint>
     dc4:	8b4a                	mv	s6,s2
      state = 0;
     dc6:	4981                	li	s3,0
     dc8:	bf91                	j	d1c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     dca:	008b0793          	addi	a5,s6,8
     dce:	f8f43423          	sd	a5,-120(s0)
     dd2:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     dd6:	03000593          	li	a1,48
     dda:	8556                	mv	a0,s5
     ddc:	00000097          	auipc	ra,0x0
     de0:	e14080e7          	jalr	-492(ra) # bf0 <putc>
  putc(fd, 'x');
     de4:	85ea                	mv	a1,s10
     de6:	8556                	mv	a0,s5
     de8:	00000097          	auipc	ra,0x0
     dec:	e08080e7          	jalr	-504(ra) # bf0 <putc>
     df0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     df2:	03c9d793          	srli	a5,s3,0x3c
     df6:	97de                	add	a5,a5,s7
     df8:	0007c583          	lbu	a1,0(a5)
     dfc:	8556                	mv	a0,s5
     dfe:	00000097          	auipc	ra,0x0
     e02:	df2080e7          	jalr	-526(ra) # bf0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e06:	0992                	slli	s3,s3,0x4
     e08:	397d                	addiw	s2,s2,-1
     e0a:	fe0914e3          	bnez	s2,df2 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
     e0e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     e12:	4981                	li	s3,0
     e14:	b721                	j	d1c <vprintf+0x60>
        s = va_arg(ap, char*);
     e16:	008b0993          	addi	s3,s6,8
     e1a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
     e1e:	02090163          	beqz	s2,e40 <vprintf+0x184>
        while(*s != 0){
     e22:	00094583          	lbu	a1,0(s2)
     e26:	c9a1                	beqz	a1,e76 <vprintf+0x1ba>
          putc(fd, *s);
     e28:	8556                	mv	a0,s5
     e2a:	00000097          	auipc	ra,0x0
     e2e:	dc6080e7          	jalr	-570(ra) # bf0 <putc>
          s++;
     e32:	0905                	addi	s2,s2,1
        while(*s != 0){
     e34:	00094583          	lbu	a1,0(s2)
     e38:	f9e5                	bnez	a1,e28 <vprintf+0x16c>
        s = va_arg(ap, char*);
     e3a:	8b4e                	mv	s6,s3
      state = 0;
     e3c:	4981                	li	s3,0
     e3e:	bdf9                	j	d1c <vprintf+0x60>
          s = "(null)";
     e40:	00000917          	auipc	s2,0x0
     e44:	4f890913          	addi	s2,s2,1272 # 1338 <malloc+0x3b2>
        while(*s != 0){
     e48:	02800593          	li	a1,40
     e4c:	bff1                	j	e28 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
     e4e:	008b0913          	addi	s2,s6,8
     e52:	000b4583          	lbu	a1,0(s6)
     e56:	8556                	mv	a0,s5
     e58:	00000097          	auipc	ra,0x0
     e5c:	d98080e7          	jalr	-616(ra) # bf0 <putc>
     e60:	8b4a                	mv	s6,s2
      state = 0;
     e62:	4981                	li	s3,0
     e64:	bd65                	j	d1c <vprintf+0x60>
        putc(fd, c);
     e66:	85d2                	mv	a1,s4
     e68:	8556                	mv	a0,s5
     e6a:	00000097          	auipc	ra,0x0
     e6e:	d86080e7          	jalr	-634(ra) # bf0 <putc>
      state = 0;
     e72:	4981                	li	s3,0
     e74:	b565                	j	d1c <vprintf+0x60>
        s = va_arg(ap, char*);
     e76:	8b4e                	mv	s6,s3
      state = 0;
     e78:	4981                	li	s3,0
     e7a:	b54d                	j	d1c <vprintf+0x60>
    }
  }
}
     e7c:	70e6                	ld	ra,120(sp)
     e7e:	7446                	ld	s0,112(sp)
     e80:	74a6                	ld	s1,104(sp)
     e82:	7906                	ld	s2,96(sp)
     e84:	69e6                	ld	s3,88(sp)
     e86:	6a46                	ld	s4,80(sp)
     e88:	6aa6                	ld	s5,72(sp)
     e8a:	6b06                	ld	s6,64(sp)
     e8c:	7be2                	ld	s7,56(sp)
     e8e:	7c42                	ld	s8,48(sp)
     e90:	7ca2                	ld	s9,40(sp)
     e92:	7d02                	ld	s10,32(sp)
     e94:	6de2                	ld	s11,24(sp)
     e96:	6109                	addi	sp,sp,128
     e98:	8082                	ret

0000000000000e9a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     e9a:	715d                	addi	sp,sp,-80
     e9c:	ec06                	sd	ra,24(sp)
     e9e:	e822                	sd	s0,16(sp)
     ea0:	1000                	addi	s0,sp,32
     ea2:	e010                	sd	a2,0(s0)
     ea4:	e414                	sd	a3,8(s0)
     ea6:	e818                	sd	a4,16(s0)
     ea8:	ec1c                	sd	a5,24(s0)
     eaa:	03043023          	sd	a6,32(s0)
     eae:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     eb2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     eb6:	8622                	mv	a2,s0
     eb8:	00000097          	auipc	ra,0x0
     ebc:	e04080e7          	jalr	-508(ra) # cbc <vprintf>
}
     ec0:	60e2                	ld	ra,24(sp)
     ec2:	6442                	ld	s0,16(sp)
     ec4:	6161                	addi	sp,sp,80
     ec6:	8082                	ret

0000000000000ec8 <printf>:

void
printf(const char *fmt, ...)
{
     ec8:	711d                	addi	sp,sp,-96
     eca:	ec06                	sd	ra,24(sp)
     ecc:	e822                	sd	s0,16(sp)
     ece:	1000                	addi	s0,sp,32
     ed0:	e40c                	sd	a1,8(s0)
     ed2:	e810                	sd	a2,16(s0)
     ed4:	ec14                	sd	a3,24(s0)
     ed6:	f018                	sd	a4,32(s0)
     ed8:	f41c                	sd	a5,40(s0)
     eda:	03043823          	sd	a6,48(s0)
     ede:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     ee2:	00840613          	addi	a2,s0,8
     ee6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     eea:	85aa                	mv	a1,a0
     eec:	4505                	li	a0,1
     eee:	00000097          	auipc	ra,0x0
     ef2:	dce080e7          	jalr	-562(ra) # cbc <vprintf>
}
     ef6:	60e2                	ld	ra,24(sp)
     ef8:	6442                	ld	s0,16(sp)
     efa:	6125                	addi	sp,sp,96
     efc:	8082                	ret

0000000000000efe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     efe:	1141                	addi	sp,sp,-16
     f00:	e422                	sd	s0,8(sp)
     f02:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f04:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f08:	00000797          	auipc	a5,0x0
     f0c:	4507b783          	ld	a5,1104(a5) # 1358 <freep>
     f10:	a805                	j	f40 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     f12:	4618                	lw	a4,8(a2)
     f14:	9db9                	addw	a1,a1,a4
     f16:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     f1a:	6398                	ld	a4,0(a5)
     f1c:	6318                	ld	a4,0(a4)
     f1e:	fee53823          	sd	a4,-16(a0)
     f22:	a091                	j	f66 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     f24:	ff852703          	lw	a4,-8(a0)
     f28:	9e39                	addw	a2,a2,a4
     f2a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
     f2c:	ff053703          	ld	a4,-16(a0)
     f30:	e398                	sd	a4,0(a5)
     f32:	a099                	j	f78 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f34:	6398                	ld	a4,0(a5)
     f36:	00e7e463          	bltu	a5,a4,f3e <free+0x40>
     f3a:	00e6ea63          	bltu	a3,a4,f4e <free+0x50>
{
     f3e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f40:	fed7fae3          	bgeu	a5,a3,f34 <free+0x36>
     f44:	6398                	ld	a4,0(a5)
     f46:	00e6e463          	bltu	a3,a4,f4e <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f4a:	fee7eae3          	bltu	a5,a4,f3e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
     f4e:	ff852583          	lw	a1,-8(a0)
     f52:	6390                	ld	a2,0(a5)
     f54:	02059713          	slli	a4,a1,0x20
     f58:	9301                	srli	a4,a4,0x20
     f5a:	0712                	slli	a4,a4,0x4
     f5c:	9736                	add	a4,a4,a3
     f5e:	fae60ae3          	beq	a2,a4,f12 <free+0x14>
    bp->s.ptr = p->s.ptr;
     f62:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     f66:	4790                	lw	a2,8(a5)
     f68:	02061713          	slli	a4,a2,0x20
     f6c:	9301                	srli	a4,a4,0x20
     f6e:	0712                	slli	a4,a4,0x4
     f70:	973e                	add	a4,a4,a5
     f72:	fae689e3          	beq	a3,a4,f24 <free+0x26>
  } else
    p->s.ptr = bp;
     f76:	e394                	sd	a3,0(a5)
  freep = p;
     f78:	00000717          	auipc	a4,0x0
     f7c:	3ef73023          	sd	a5,992(a4) # 1358 <freep>
}
     f80:	6422                	ld	s0,8(sp)
     f82:	0141                	addi	sp,sp,16
     f84:	8082                	ret

0000000000000f86 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     f86:	7139                	addi	sp,sp,-64
     f88:	fc06                	sd	ra,56(sp)
     f8a:	f822                	sd	s0,48(sp)
     f8c:	f426                	sd	s1,40(sp)
     f8e:	f04a                	sd	s2,32(sp)
     f90:	ec4e                	sd	s3,24(sp)
     f92:	e852                	sd	s4,16(sp)
     f94:	e456                	sd	s5,8(sp)
     f96:	e05a                	sd	s6,0(sp)
     f98:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f9a:	02051493          	slli	s1,a0,0x20
     f9e:	9081                	srli	s1,s1,0x20
     fa0:	04bd                	addi	s1,s1,15
     fa2:	8091                	srli	s1,s1,0x4
     fa4:	0014899b          	addiw	s3,s1,1
     fa8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
     faa:	00000517          	auipc	a0,0x0
     fae:	3ae53503          	ld	a0,942(a0) # 1358 <freep>
     fb2:	c515                	beqz	a0,fde <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fb4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     fb6:	4798                	lw	a4,8(a5)
     fb8:	02977f63          	bgeu	a4,s1,ff6 <malloc+0x70>
     fbc:	8a4e                	mv	s4,s3
     fbe:	0009871b          	sext.w	a4,s3
     fc2:	6685                	lui	a3,0x1
     fc4:	00d77363          	bgeu	a4,a3,fca <malloc+0x44>
     fc8:	6a05                	lui	s4,0x1
     fca:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     fce:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     fd2:	00000917          	auipc	s2,0x0
     fd6:	38690913          	addi	s2,s2,902 # 1358 <freep>
  if(p == (char*)-1)
     fda:	5afd                	li	s5,-1
     fdc:	a88d                	j	104e <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
     fde:	00000797          	auipc	a5,0x0
     fe2:	38278793          	addi	a5,a5,898 # 1360 <base>
     fe6:	00000717          	auipc	a4,0x0
     fea:	36f73923          	sd	a5,882(a4) # 1358 <freep>
     fee:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
     ff0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
     ff4:	b7e1                	j	fbc <malloc+0x36>
      if(p->s.size == nunits)
     ff6:	02e48b63          	beq	s1,a4,102c <malloc+0xa6>
        p->s.size -= nunits;
     ffa:	4137073b          	subw	a4,a4,s3
     ffe:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1000:	1702                	slli	a4,a4,0x20
    1002:	9301                	srli	a4,a4,0x20
    1004:	0712                	slli	a4,a4,0x4
    1006:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1008:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    100c:	00000717          	auipc	a4,0x0
    1010:	34a73623          	sd	a0,844(a4) # 1358 <freep>
      return (void*)(p + 1);
    1014:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1018:	70e2                	ld	ra,56(sp)
    101a:	7442                	ld	s0,48(sp)
    101c:	74a2                	ld	s1,40(sp)
    101e:	7902                	ld	s2,32(sp)
    1020:	69e2                	ld	s3,24(sp)
    1022:	6a42                	ld	s4,16(sp)
    1024:	6aa2                	ld	s5,8(sp)
    1026:	6b02                	ld	s6,0(sp)
    1028:	6121                	addi	sp,sp,64
    102a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    102c:	6398                	ld	a4,0(a5)
    102e:	e118                	sd	a4,0(a0)
    1030:	bff1                	j	100c <malloc+0x86>
  hp->s.size = nu;
    1032:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1036:	0541                	addi	a0,a0,16
    1038:	00000097          	auipc	ra,0x0
    103c:	ec6080e7          	jalr	-314(ra) # efe <free>
  return freep;
    1040:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1044:	d971                	beqz	a0,1018 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1046:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1048:	4798                	lw	a4,8(a5)
    104a:	fa9776e3          	bgeu	a4,s1,ff6 <malloc+0x70>
    if(p == freep)
    104e:	00093703          	ld	a4,0(s2)
    1052:	853e                	mv	a0,a5
    1054:	fef719e3          	bne	a4,a5,1046 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    1058:	8552                	mv	a0,s4
    105a:	00000097          	auipc	ra,0x0
    105e:	b6e080e7          	jalr	-1170(ra) # bc8 <sbrk>
  if(p == (char*)-1)
    1062:	fd5518e3          	bne	a0,s5,1032 <malloc+0xac>
        return 0;
    1066:	4501                	li	a0,0
    1068:	bf45                	j	1018 <malloc+0x92>
