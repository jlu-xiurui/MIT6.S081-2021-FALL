
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  fprintf(2, "$ ");
      10:	00001597          	auipc	a1,0x1
      14:	30058593          	addi	a1,a1,768 # 1310 <malloc+0xea>
      18:	4509                	li	a0,2
      1a:	00001097          	auipc	ra,0x1
      1e:	120080e7          	jalr	288(ra) # 113a <fprintf>
  memset(buf, 0, nbuf);
      22:	864a                	mv	a2,s2
      24:	4581                	li	a1,0
      26:	8526                	mv	a0,s1
      28:	00001097          	auipc	ra,0x1
      2c:	b9e080e7          	jalr	-1122(ra) # bc6 <memset>
  gets(buf, nbuf);
      30:	85ca                	mv	a1,s2
      32:	8526                	mv	a0,s1
      34:	00001097          	auipc	ra,0x1
      38:	bdc080e7          	jalr	-1060(ra) # c10 <gets>
  if(buf[0] == 0) // EOF
      3c:	0004c503          	lbu	a0,0(s1)
      40:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      44:	40a00533          	neg	a0,a0
      48:	60e2                	ld	ra,24(sp)
      4a:	6442                	ld	s0,16(sp)
      4c:	64a2                	ld	s1,8(sp)
      4e:	6902                	ld	s2,0(sp)
      50:	6105                	addi	sp,sp,32
      52:	8082                	ret

0000000000000054 <panic>:
  exit(0);
}

void
panic(char *s)
{
      54:	1141                	addi	sp,sp,-16
      56:	e406                	sd	ra,8(sp)
      58:	e022                	sd	s0,0(sp)
      5a:	0800                	addi	s0,sp,16
      5c:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      5e:	00001597          	auipc	a1,0x1
      62:	2ba58593          	addi	a1,a1,698 # 1318 <malloc+0xf2>
      66:	4509                	li	a0,2
      68:	00001097          	auipc	ra,0x1
      6c:	0d2080e7          	jalr	210(ra) # 113a <fprintf>
  exit(1);
      70:	4505                	li	a0,1
      72:	00001097          	auipc	ra,0x1
      76:	d6e080e7          	jalr	-658(ra) # de0 <exit>

000000000000007a <fork1>:
}

int
fork1(void)
{
      7a:	1141                	addi	sp,sp,-16
      7c:	e406                	sd	ra,8(sp)
      7e:	e022                	sd	s0,0(sp)
      80:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      82:	00001097          	auipc	ra,0x1
      86:	d56080e7          	jalr	-682(ra) # dd8 <fork>
  if(pid == -1)
      8a:	57fd                	li	a5,-1
      8c:	00f50663          	beq	a0,a5,98 <fork1+0x1e>
    panic("fork");
  return pid;
}
      90:	60a2                	ld	ra,8(sp)
      92:	6402                	ld	s0,0(sp)
      94:	0141                	addi	sp,sp,16
      96:	8082                	ret
    panic("fork");
      98:	00001517          	auipc	a0,0x1
      9c:	28850513          	addi	a0,a0,648 # 1320 <malloc+0xfa>
      a0:	00000097          	auipc	ra,0x0
      a4:	fb4080e7          	jalr	-76(ra) # 54 <panic>

00000000000000a8 <runcmd>:
{
      a8:	7179                	addi	sp,sp,-48
      aa:	f406                	sd	ra,40(sp)
      ac:	f022                	sd	s0,32(sp)
      ae:	ec26                	sd	s1,24(sp)
      b0:	1800                	addi	s0,sp,48
  if(cmd == 0)
      b2:	c10d                	beqz	a0,d4 <runcmd+0x2c>
      b4:	84aa                	mv	s1,a0
  switch(cmd->type){
      b6:	4118                	lw	a4,0(a0)
      b8:	4795                	li	a5,5
      ba:	02e7e263          	bltu	a5,a4,de <runcmd+0x36>
      be:	00056783          	lwu	a5,0(a0)
      c2:	078a                	slli	a5,a5,0x2
      c4:	00001717          	auipc	a4,0x1
      c8:	35c70713          	addi	a4,a4,860 # 1420 <malloc+0x1fa>
      cc:	97ba                	add	a5,a5,a4
      ce:	439c                	lw	a5,0(a5)
      d0:	97ba                	add	a5,a5,a4
      d2:	8782                	jr	a5
    exit(1);
      d4:	4505                	li	a0,1
      d6:	00001097          	auipc	ra,0x1
      da:	d0a080e7          	jalr	-758(ra) # de0 <exit>
    panic("runcmd");
      de:	00001517          	auipc	a0,0x1
      e2:	24a50513          	addi	a0,a0,586 # 1328 <malloc+0x102>
      e6:	00000097          	auipc	ra,0x0
      ea:	f6e080e7          	jalr	-146(ra) # 54 <panic>
    if(ecmd->argv[0] == 0)
      ee:	6508                	ld	a0,8(a0)
      f0:	c515                	beqz	a0,11c <runcmd+0x74>
    exec(ecmd->argv[0], ecmd->argv);
      f2:	00848593          	addi	a1,s1,8
      f6:	00001097          	auipc	ra,0x1
      fa:	d22080e7          	jalr	-734(ra) # e18 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      fe:	6490                	ld	a2,8(s1)
     100:	00001597          	auipc	a1,0x1
     104:	23058593          	addi	a1,a1,560 # 1330 <malloc+0x10a>
     108:	4509                	li	a0,2
     10a:	00001097          	auipc	ra,0x1
     10e:	030080e7          	jalr	48(ra) # 113a <fprintf>
  exit(0);
     112:	4501                	li	a0,0
     114:	00001097          	auipc	ra,0x1
     118:	ccc080e7          	jalr	-820(ra) # de0 <exit>
      exit(1);
     11c:	4505                	li	a0,1
     11e:	00001097          	auipc	ra,0x1
     122:	cc2080e7          	jalr	-830(ra) # de0 <exit>
    close(rcmd->fd);
     126:	5148                	lw	a0,36(a0)
     128:	00001097          	auipc	ra,0x1
     12c:	ce0080e7          	jalr	-800(ra) # e08 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     130:	508c                	lw	a1,32(s1)
     132:	6888                	ld	a0,16(s1)
     134:	00001097          	auipc	ra,0x1
     138:	cec080e7          	jalr	-788(ra) # e20 <open>
     13c:	00054763          	bltz	a0,14a <runcmd+0xa2>
    runcmd(rcmd->cmd);
     140:	6488                	ld	a0,8(s1)
     142:	00000097          	auipc	ra,0x0
     146:	f66080e7          	jalr	-154(ra) # a8 <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     14a:	6890                	ld	a2,16(s1)
     14c:	00001597          	auipc	a1,0x1
     150:	1f458593          	addi	a1,a1,500 # 1340 <malloc+0x11a>
     154:	4509                	li	a0,2
     156:	00001097          	auipc	ra,0x1
     15a:	fe4080e7          	jalr	-28(ra) # 113a <fprintf>
      exit(1);
     15e:	4505                	li	a0,1
     160:	00001097          	auipc	ra,0x1
     164:	c80080e7          	jalr	-896(ra) # de0 <exit>
    if(fork1() == 0)
     168:	00000097          	auipc	ra,0x0
     16c:	f12080e7          	jalr	-238(ra) # 7a <fork1>
     170:	c919                	beqz	a0,186 <runcmd+0xde>
    wait(0);
     172:	4501                	li	a0,0
     174:	00001097          	auipc	ra,0x1
     178:	c74080e7          	jalr	-908(ra) # de8 <wait>
    runcmd(lcmd->right);
     17c:	6888                	ld	a0,16(s1)
     17e:	00000097          	auipc	ra,0x0
     182:	f2a080e7          	jalr	-214(ra) # a8 <runcmd>
      runcmd(lcmd->left);
     186:	6488                	ld	a0,8(s1)
     188:	00000097          	auipc	ra,0x0
     18c:	f20080e7          	jalr	-224(ra) # a8 <runcmd>
    if(pipe(p) < 0)
     190:	fd840513          	addi	a0,s0,-40
     194:	00001097          	auipc	ra,0x1
     198:	c5c080e7          	jalr	-932(ra) # df0 <pipe>
     19c:	04054363          	bltz	a0,1e2 <runcmd+0x13a>
    if(fork1() == 0){
     1a0:	00000097          	auipc	ra,0x0
     1a4:	eda080e7          	jalr	-294(ra) # 7a <fork1>
     1a8:	c529                	beqz	a0,1f2 <runcmd+0x14a>
    if(fork1() == 0){
     1aa:	00000097          	auipc	ra,0x0
     1ae:	ed0080e7          	jalr	-304(ra) # 7a <fork1>
     1b2:	cd25                	beqz	a0,22a <runcmd+0x182>
    close(p[0]);
     1b4:	fd842503          	lw	a0,-40(s0)
     1b8:	00001097          	auipc	ra,0x1
     1bc:	c50080e7          	jalr	-944(ra) # e08 <close>
    close(p[1]);
     1c0:	fdc42503          	lw	a0,-36(s0)
     1c4:	00001097          	auipc	ra,0x1
     1c8:	c44080e7          	jalr	-956(ra) # e08 <close>
    wait(0);
     1cc:	4501                	li	a0,0
     1ce:	00001097          	auipc	ra,0x1
     1d2:	c1a080e7          	jalr	-998(ra) # de8 <wait>
    wait(0);
     1d6:	4501                	li	a0,0
     1d8:	00001097          	auipc	ra,0x1
     1dc:	c10080e7          	jalr	-1008(ra) # de8 <wait>
    break;
     1e0:	bf0d                	j	112 <runcmd+0x6a>
      panic("pipe");
     1e2:	00001517          	auipc	a0,0x1
     1e6:	16e50513          	addi	a0,a0,366 # 1350 <malloc+0x12a>
     1ea:	00000097          	auipc	ra,0x0
     1ee:	e6a080e7          	jalr	-406(ra) # 54 <panic>
      close(1);
     1f2:	4505                	li	a0,1
     1f4:	00001097          	auipc	ra,0x1
     1f8:	c14080e7          	jalr	-1004(ra) # e08 <close>
      dup(p[1]);
     1fc:	fdc42503          	lw	a0,-36(s0)
     200:	00001097          	auipc	ra,0x1
     204:	c58080e7          	jalr	-936(ra) # e58 <dup>
      close(p[0]);
     208:	fd842503          	lw	a0,-40(s0)
     20c:	00001097          	auipc	ra,0x1
     210:	bfc080e7          	jalr	-1028(ra) # e08 <close>
      close(p[1]);
     214:	fdc42503          	lw	a0,-36(s0)
     218:	00001097          	auipc	ra,0x1
     21c:	bf0080e7          	jalr	-1040(ra) # e08 <close>
      runcmd(pcmd->left);
     220:	6488                	ld	a0,8(s1)
     222:	00000097          	auipc	ra,0x0
     226:	e86080e7          	jalr	-378(ra) # a8 <runcmd>
      close(0);
     22a:	00001097          	auipc	ra,0x1
     22e:	bde080e7          	jalr	-1058(ra) # e08 <close>
      dup(p[0]);
     232:	fd842503          	lw	a0,-40(s0)
     236:	00001097          	auipc	ra,0x1
     23a:	c22080e7          	jalr	-990(ra) # e58 <dup>
      close(p[0]);
     23e:	fd842503          	lw	a0,-40(s0)
     242:	00001097          	auipc	ra,0x1
     246:	bc6080e7          	jalr	-1082(ra) # e08 <close>
      close(p[1]);
     24a:	fdc42503          	lw	a0,-36(s0)
     24e:	00001097          	auipc	ra,0x1
     252:	bba080e7          	jalr	-1094(ra) # e08 <close>
      runcmd(pcmd->right);
     256:	6888                	ld	a0,16(s1)
     258:	00000097          	auipc	ra,0x0
     25c:	e50080e7          	jalr	-432(ra) # a8 <runcmd>
    if(fork1() == 0)
     260:	00000097          	auipc	ra,0x0
     264:	e1a080e7          	jalr	-486(ra) # 7a <fork1>
     268:	ea0515e3          	bnez	a0,112 <runcmd+0x6a>
      runcmd(bcmd->cmd);
     26c:	6488                	ld	a0,8(s1)
     26e:	00000097          	auipc	ra,0x0
     272:	e3a080e7          	jalr	-454(ra) # a8 <runcmd>

0000000000000276 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     276:	1101                	addi	sp,sp,-32
     278:	ec06                	sd	ra,24(sp)
     27a:	e822                	sd	s0,16(sp)
     27c:	e426                	sd	s1,8(sp)
     27e:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     280:	0a800513          	li	a0,168
     284:	00001097          	auipc	ra,0x1
     288:	fa2080e7          	jalr	-94(ra) # 1226 <malloc>
     28c:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     28e:	0a800613          	li	a2,168
     292:	4581                	li	a1,0
     294:	00001097          	auipc	ra,0x1
     298:	932080e7          	jalr	-1742(ra) # bc6 <memset>
  cmd->type = EXEC;
     29c:	4785                	li	a5,1
     29e:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     2a0:	8526                	mv	a0,s1
     2a2:	60e2                	ld	ra,24(sp)
     2a4:	6442                	ld	s0,16(sp)
     2a6:	64a2                	ld	s1,8(sp)
     2a8:	6105                	addi	sp,sp,32
     2aa:	8082                	ret

00000000000002ac <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2ac:	7139                	addi	sp,sp,-64
     2ae:	fc06                	sd	ra,56(sp)
     2b0:	f822                	sd	s0,48(sp)
     2b2:	f426                	sd	s1,40(sp)
     2b4:	f04a                	sd	s2,32(sp)
     2b6:	ec4e                	sd	s3,24(sp)
     2b8:	e852                	sd	s4,16(sp)
     2ba:	e456                	sd	s5,8(sp)
     2bc:	e05a                	sd	s6,0(sp)
     2be:	0080                	addi	s0,sp,64
     2c0:	8b2a                	mv	s6,a0
     2c2:	8aae                	mv	s5,a1
     2c4:	8a32                	mv	s4,a2
     2c6:	89b6                	mv	s3,a3
     2c8:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ca:	02800513          	li	a0,40
     2ce:	00001097          	auipc	ra,0x1
     2d2:	f58080e7          	jalr	-168(ra) # 1226 <malloc>
     2d6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2d8:	02800613          	li	a2,40
     2dc:	4581                	li	a1,0
     2de:	00001097          	auipc	ra,0x1
     2e2:	8e8080e7          	jalr	-1816(ra) # bc6 <memset>
  cmd->type = REDIR;
     2e6:	4789                	li	a5,2
     2e8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2ea:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     2ee:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     2f2:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     2f6:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     2fa:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     2fe:	8526                	mv	a0,s1
     300:	70e2                	ld	ra,56(sp)
     302:	7442                	ld	s0,48(sp)
     304:	74a2                	ld	s1,40(sp)
     306:	7902                	ld	s2,32(sp)
     308:	69e2                	ld	s3,24(sp)
     30a:	6a42                	ld	s4,16(sp)
     30c:	6aa2                	ld	s5,8(sp)
     30e:	6b02                	ld	s6,0(sp)
     310:	6121                	addi	sp,sp,64
     312:	8082                	ret

0000000000000314 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     314:	7179                	addi	sp,sp,-48
     316:	f406                	sd	ra,40(sp)
     318:	f022                	sd	s0,32(sp)
     31a:	ec26                	sd	s1,24(sp)
     31c:	e84a                	sd	s2,16(sp)
     31e:	e44e                	sd	s3,8(sp)
     320:	1800                	addi	s0,sp,48
     322:	89aa                	mv	s3,a0
     324:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     326:	4561                	li	a0,24
     328:	00001097          	auipc	ra,0x1
     32c:	efe080e7          	jalr	-258(ra) # 1226 <malloc>
     330:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     332:	4661                	li	a2,24
     334:	4581                	li	a1,0
     336:	00001097          	auipc	ra,0x1
     33a:	890080e7          	jalr	-1904(ra) # bc6 <memset>
  cmd->type = PIPE;
     33e:	478d                	li	a5,3
     340:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     342:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     346:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     34a:	8526                	mv	a0,s1
     34c:	70a2                	ld	ra,40(sp)
     34e:	7402                	ld	s0,32(sp)
     350:	64e2                	ld	s1,24(sp)
     352:	6942                	ld	s2,16(sp)
     354:	69a2                	ld	s3,8(sp)
     356:	6145                	addi	sp,sp,48
     358:	8082                	ret

000000000000035a <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     35a:	7179                	addi	sp,sp,-48
     35c:	f406                	sd	ra,40(sp)
     35e:	f022                	sd	s0,32(sp)
     360:	ec26                	sd	s1,24(sp)
     362:	e84a                	sd	s2,16(sp)
     364:	e44e                	sd	s3,8(sp)
     366:	1800                	addi	s0,sp,48
     368:	89aa                	mv	s3,a0
     36a:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     36c:	4561                	li	a0,24
     36e:	00001097          	auipc	ra,0x1
     372:	eb8080e7          	jalr	-328(ra) # 1226 <malloc>
     376:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     378:	4661                	li	a2,24
     37a:	4581                	li	a1,0
     37c:	00001097          	auipc	ra,0x1
     380:	84a080e7          	jalr	-1974(ra) # bc6 <memset>
  cmd->type = LIST;
     384:	4791                	li	a5,4
     386:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     388:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     38c:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     390:	8526                	mv	a0,s1
     392:	70a2                	ld	ra,40(sp)
     394:	7402                	ld	s0,32(sp)
     396:	64e2                	ld	s1,24(sp)
     398:	6942                	ld	s2,16(sp)
     39a:	69a2                	ld	s3,8(sp)
     39c:	6145                	addi	sp,sp,48
     39e:	8082                	ret

00000000000003a0 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     3a0:	1101                	addi	sp,sp,-32
     3a2:	ec06                	sd	ra,24(sp)
     3a4:	e822                	sd	s0,16(sp)
     3a6:	e426                	sd	s1,8(sp)
     3a8:	e04a                	sd	s2,0(sp)
     3aa:	1000                	addi	s0,sp,32
     3ac:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3ae:	4541                	li	a0,16
     3b0:	00001097          	auipc	ra,0x1
     3b4:	e76080e7          	jalr	-394(ra) # 1226 <malloc>
     3b8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3ba:	4641                	li	a2,16
     3bc:	4581                	li	a1,0
     3be:	00001097          	auipc	ra,0x1
     3c2:	808080e7          	jalr	-2040(ra) # bc6 <memset>
  cmd->type = BACK;
     3c6:	4795                	li	a5,5
     3c8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3ca:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     3ce:	8526                	mv	a0,s1
     3d0:	60e2                	ld	ra,24(sp)
     3d2:	6442                	ld	s0,16(sp)
     3d4:	64a2                	ld	s1,8(sp)
     3d6:	6902                	ld	s2,0(sp)
     3d8:	6105                	addi	sp,sp,32
     3da:	8082                	ret

00000000000003dc <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     3dc:	7139                	addi	sp,sp,-64
     3de:	fc06                	sd	ra,56(sp)
     3e0:	f822                	sd	s0,48(sp)
     3e2:	f426                	sd	s1,40(sp)
     3e4:	f04a                	sd	s2,32(sp)
     3e6:	ec4e                	sd	s3,24(sp)
     3e8:	e852                	sd	s4,16(sp)
     3ea:	e456                	sd	s5,8(sp)
     3ec:	e05a                	sd	s6,0(sp)
     3ee:	0080                	addi	s0,sp,64
     3f0:	8a2a                	mv	s4,a0
     3f2:	892e                	mv	s2,a1
     3f4:	8ab2                	mv	s5,a2
     3f6:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     3f8:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     3fa:	00001997          	auipc	s3,0x1
     3fe:	07e98993          	addi	s3,s3,126 # 1478 <whitespace>
     402:	00b4fd63          	bgeu	s1,a1,41c <gettoken+0x40>
     406:	0004c583          	lbu	a1,0(s1)
     40a:	854e                	mv	a0,s3
     40c:	00000097          	auipc	ra,0x0
     410:	7e0080e7          	jalr	2016(ra) # bec <strchr>
     414:	c501                	beqz	a0,41c <gettoken+0x40>
    s++;
     416:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     418:	fe9917e3          	bne	s2,s1,406 <gettoken+0x2a>
  if(q)
     41c:	000a8463          	beqz	s5,424 <gettoken+0x48>
    *q = s;
     420:	009ab023          	sd	s1,0(s5)
  ret = *s;
     424:	0004c783          	lbu	a5,0(s1)
     428:	00078a9b          	sext.w	s5,a5
  switch(*s){
     42c:	03c00713          	li	a4,60
     430:	06f76563          	bltu	a4,a5,49a <gettoken+0xbe>
     434:	03a00713          	li	a4,58
     438:	00f76e63          	bltu	a4,a5,454 <gettoken+0x78>
     43c:	cf89                	beqz	a5,456 <gettoken+0x7a>
     43e:	02600713          	li	a4,38
     442:	00e78963          	beq	a5,a4,454 <gettoken+0x78>
     446:	fd87879b          	addiw	a5,a5,-40
     44a:	0ff7f793          	andi	a5,a5,255
     44e:	4705                	li	a4,1
     450:	06f76c63          	bltu	a4,a5,4c8 <gettoken+0xec>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     454:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     456:	000b0463          	beqz	s6,45e <gettoken+0x82>
    *eq = s;
     45a:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     45e:	00001997          	auipc	s3,0x1
     462:	01a98993          	addi	s3,s3,26 # 1478 <whitespace>
     466:	0124fd63          	bgeu	s1,s2,480 <gettoken+0xa4>
     46a:	0004c583          	lbu	a1,0(s1)
     46e:	854e                	mv	a0,s3
     470:	00000097          	auipc	ra,0x0
     474:	77c080e7          	jalr	1916(ra) # bec <strchr>
     478:	c501                	beqz	a0,480 <gettoken+0xa4>
    s++;
     47a:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     47c:	fe9917e3          	bne	s2,s1,46a <gettoken+0x8e>
  *ps = s;
     480:	009a3023          	sd	s1,0(s4)
  return ret;
}
     484:	8556                	mv	a0,s5
     486:	70e2                	ld	ra,56(sp)
     488:	7442                	ld	s0,48(sp)
     48a:	74a2                	ld	s1,40(sp)
     48c:	7902                	ld	s2,32(sp)
     48e:	69e2                	ld	s3,24(sp)
     490:	6a42                	ld	s4,16(sp)
     492:	6aa2                	ld	s5,8(sp)
     494:	6b02                	ld	s6,0(sp)
     496:	6121                	addi	sp,sp,64
     498:	8082                	ret
  switch(*s){
     49a:	03e00713          	li	a4,62
     49e:	02e79163          	bne	a5,a4,4c0 <gettoken+0xe4>
    s++;
     4a2:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     4a6:	0014c703          	lbu	a4,1(s1)
     4aa:	03e00793          	li	a5,62
      s++;
     4ae:	0489                	addi	s1,s1,2
      ret = '+';
     4b0:	02b00a93          	li	s5,43
    if(*s == '>'){
     4b4:	faf701e3          	beq	a4,a5,456 <gettoken+0x7a>
    s++;
     4b8:	84b6                	mv	s1,a3
  ret = *s;
     4ba:	03e00a93          	li	s5,62
     4be:	bf61                	j	456 <gettoken+0x7a>
  switch(*s){
     4c0:	07c00713          	li	a4,124
     4c4:	f8e788e3          	beq	a5,a4,454 <gettoken+0x78>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4c8:	00001997          	auipc	s3,0x1
     4cc:	fb098993          	addi	s3,s3,-80 # 1478 <whitespace>
     4d0:	00001a97          	auipc	s5,0x1
     4d4:	fa0a8a93          	addi	s5,s5,-96 # 1470 <symbols>
     4d8:	0324f563          	bgeu	s1,s2,502 <gettoken+0x126>
     4dc:	0004c583          	lbu	a1,0(s1)
     4e0:	854e                	mv	a0,s3
     4e2:	00000097          	auipc	ra,0x0
     4e6:	70a080e7          	jalr	1802(ra) # bec <strchr>
     4ea:	e505                	bnez	a0,512 <gettoken+0x136>
     4ec:	0004c583          	lbu	a1,0(s1)
     4f0:	8556                	mv	a0,s5
     4f2:	00000097          	auipc	ra,0x0
     4f6:	6fa080e7          	jalr	1786(ra) # bec <strchr>
     4fa:	e909                	bnez	a0,50c <gettoken+0x130>
      s++;
     4fc:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4fe:	fc991fe3          	bne	s2,s1,4dc <gettoken+0x100>
  if(eq)
     502:	06100a93          	li	s5,97
     506:	f40b1ae3          	bnez	s6,45a <gettoken+0x7e>
     50a:	bf9d                	j	480 <gettoken+0xa4>
    ret = 'a';
     50c:	06100a93          	li	s5,97
     510:	b799                	j	456 <gettoken+0x7a>
     512:	06100a93          	li	s5,97
     516:	b781                	j	456 <gettoken+0x7a>

0000000000000518 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     518:	7139                	addi	sp,sp,-64
     51a:	fc06                	sd	ra,56(sp)
     51c:	f822                	sd	s0,48(sp)
     51e:	f426                	sd	s1,40(sp)
     520:	f04a                	sd	s2,32(sp)
     522:	ec4e                	sd	s3,24(sp)
     524:	e852                	sd	s4,16(sp)
     526:	e456                	sd	s5,8(sp)
     528:	0080                	addi	s0,sp,64
     52a:	8a2a                	mv	s4,a0
     52c:	892e                	mv	s2,a1
     52e:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     530:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     532:	00001997          	auipc	s3,0x1
     536:	f4698993          	addi	s3,s3,-186 # 1478 <whitespace>
     53a:	00b4fd63          	bgeu	s1,a1,554 <peek+0x3c>
     53e:	0004c583          	lbu	a1,0(s1)
     542:	854e                	mv	a0,s3
     544:	00000097          	auipc	ra,0x0
     548:	6a8080e7          	jalr	1704(ra) # bec <strchr>
     54c:	c501                	beqz	a0,554 <peek+0x3c>
    s++;
     54e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     550:	fe9917e3          	bne	s2,s1,53e <peek+0x26>
  *ps = s;
     554:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     558:	0004c583          	lbu	a1,0(s1)
     55c:	4501                	li	a0,0
     55e:	e991                	bnez	a1,572 <peek+0x5a>
}
     560:	70e2                	ld	ra,56(sp)
     562:	7442                	ld	s0,48(sp)
     564:	74a2                	ld	s1,40(sp)
     566:	7902                	ld	s2,32(sp)
     568:	69e2                	ld	s3,24(sp)
     56a:	6a42                	ld	s4,16(sp)
     56c:	6aa2                	ld	s5,8(sp)
     56e:	6121                	addi	sp,sp,64
     570:	8082                	ret
  return *s && strchr(toks, *s);
     572:	8556                	mv	a0,s5
     574:	00000097          	auipc	ra,0x0
     578:	678080e7          	jalr	1656(ra) # bec <strchr>
     57c:	00a03533          	snez	a0,a0
     580:	b7c5                	j	560 <peek+0x48>

0000000000000582 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     582:	7159                	addi	sp,sp,-112
     584:	f486                	sd	ra,104(sp)
     586:	f0a2                	sd	s0,96(sp)
     588:	eca6                	sd	s1,88(sp)
     58a:	e8ca                	sd	s2,80(sp)
     58c:	e4ce                	sd	s3,72(sp)
     58e:	e0d2                	sd	s4,64(sp)
     590:	fc56                	sd	s5,56(sp)
     592:	f85a                	sd	s6,48(sp)
     594:	f45e                	sd	s7,40(sp)
     596:	f062                	sd	s8,32(sp)
     598:	ec66                	sd	s9,24(sp)
     59a:	1880                	addi	s0,sp,112
     59c:	8a2a                	mv	s4,a0
     59e:	89ae                	mv	s3,a1
     5a0:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5a2:	00001b97          	auipc	s7,0x1
     5a6:	dd6b8b93          	addi	s7,s7,-554 # 1378 <malloc+0x152>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     5aa:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     5ae:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     5b2:	a02d                	j	5dc <parseredirs+0x5a>
      panic("missing file for redirection");
     5b4:	00001517          	auipc	a0,0x1
     5b8:	da450513          	addi	a0,a0,-604 # 1358 <malloc+0x132>
     5bc:	00000097          	auipc	ra,0x0
     5c0:	a98080e7          	jalr	-1384(ra) # 54 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5c4:	4701                	li	a4,0
     5c6:	4681                	li	a3,0
     5c8:	f9043603          	ld	a2,-112(s0)
     5cc:	f9843583          	ld	a1,-104(s0)
     5d0:	8552                	mv	a0,s4
     5d2:	00000097          	auipc	ra,0x0
     5d6:	cda080e7          	jalr	-806(ra) # 2ac <redircmd>
     5da:	8a2a                	mv	s4,a0
    switch(tok){
     5dc:	03e00b13          	li	s6,62
     5e0:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     5e4:	865e                	mv	a2,s7
     5e6:	85ca                	mv	a1,s2
     5e8:	854e                	mv	a0,s3
     5ea:	00000097          	auipc	ra,0x0
     5ee:	f2e080e7          	jalr	-210(ra) # 518 <peek>
     5f2:	c925                	beqz	a0,662 <parseredirs+0xe0>
    tok = gettoken(ps, es, 0, 0);
     5f4:	4681                	li	a3,0
     5f6:	4601                	li	a2,0
     5f8:	85ca                	mv	a1,s2
     5fa:	854e                	mv	a0,s3
     5fc:	00000097          	auipc	ra,0x0
     600:	de0080e7          	jalr	-544(ra) # 3dc <gettoken>
     604:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     606:	f9040693          	addi	a3,s0,-112
     60a:	f9840613          	addi	a2,s0,-104
     60e:	85ca                	mv	a1,s2
     610:	854e                	mv	a0,s3
     612:	00000097          	auipc	ra,0x0
     616:	dca080e7          	jalr	-566(ra) # 3dc <gettoken>
     61a:	f9851de3          	bne	a0,s8,5b4 <parseredirs+0x32>
    switch(tok){
     61e:	fb9483e3          	beq	s1,s9,5c4 <parseredirs+0x42>
     622:	03648263          	beq	s1,s6,646 <parseredirs+0xc4>
     626:	fb549fe3          	bne	s1,s5,5e4 <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     62a:	4705                	li	a4,1
     62c:	20100693          	li	a3,513
     630:	f9043603          	ld	a2,-112(s0)
     634:	f9843583          	ld	a1,-104(s0)
     638:	8552                	mv	a0,s4
     63a:	00000097          	auipc	ra,0x0
     63e:	c72080e7          	jalr	-910(ra) # 2ac <redircmd>
     642:	8a2a                	mv	s4,a0
      break;
     644:	bf61                	j	5dc <parseredirs+0x5a>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     646:	4705                	li	a4,1
     648:	60100693          	li	a3,1537
     64c:	f9043603          	ld	a2,-112(s0)
     650:	f9843583          	ld	a1,-104(s0)
     654:	8552                	mv	a0,s4
     656:	00000097          	auipc	ra,0x0
     65a:	c56080e7          	jalr	-938(ra) # 2ac <redircmd>
     65e:	8a2a                	mv	s4,a0
      break;
     660:	bfb5                	j	5dc <parseredirs+0x5a>
    }
  }
  return cmd;
}
     662:	8552                	mv	a0,s4
     664:	70a6                	ld	ra,104(sp)
     666:	7406                	ld	s0,96(sp)
     668:	64e6                	ld	s1,88(sp)
     66a:	6946                	ld	s2,80(sp)
     66c:	69a6                	ld	s3,72(sp)
     66e:	6a06                	ld	s4,64(sp)
     670:	7ae2                	ld	s5,56(sp)
     672:	7b42                	ld	s6,48(sp)
     674:	7ba2                	ld	s7,40(sp)
     676:	7c02                	ld	s8,32(sp)
     678:	6ce2                	ld	s9,24(sp)
     67a:	6165                	addi	sp,sp,112
     67c:	8082                	ret

000000000000067e <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     67e:	7159                	addi	sp,sp,-112
     680:	f486                	sd	ra,104(sp)
     682:	f0a2                	sd	s0,96(sp)
     684:	eca6                	sd	s1,88(sp)
     686:	e8ca                	sd	s2,80(sp)
     688:	e4ce                	sd	s3,72(sp)
     68a:	e0d2                	sd	s4,64(sp)
     68c:	fc56                	sd	s5,56(sp)
     68e:	f85a                	sd	s6,48(sp)
     690:	f45e                	sd	s7,40(sp)
     692:	f062                	sd	s8,32(sp)
     694:	ec66                	sd	s9,24(sp)
     696:	1880                	addi	s0,sp,112
     698:	8a2a                	mv	s4,a0
     69a:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     69c:	00001617          	auipc	a2,0x1
     6a0:	ce460613          	addi	a2,a2,-796 # 1380 <malloc+0x15a>
     6a4:	00000097          	auipc	ra,0x0
     6a8:	e74080e7          	jalr	-396(ra) # 518 <peek>
     6ac:	e905                	bnez	a0,6dc <parseexec+0x5e>
     6ae:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     6b0:	00000097          	auipc	ra,0x0
     6b4:	bc6080e7          	jalr	-1082(ra) # 276 <execcmd>
     6b8:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6ba:	8656                	mv	a2,s5
     6bc:	85d2                	mv	a1,s4
     6be:	00000097          	auipc	ra,0x0
     6c2:	ec4080e7          	jalr	-316(ra) # 582 <parseredirs>
     6c6:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     6c8:	008c0913          	addi	s2,s8,8
     6cc:	00001b17          	auipc	s6,0x1
     6d0:	cd4b0b13          	addi	s6,s6,-812 # 13a0 <malloc+0x17a>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     6d4:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     6d8:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     6da:	a0b1                	j	726 <parseexec+0xa8>
    return parseblock(ps, es);
     6dc:	85d6                	mv	a1,s5
     6de:	8552                	mv	a0,s4
     6e0:	00000097          	auipc	ra,0x0
     6e4:	1bc080e7          	jalr	444(ra) # 89c <parseblock>
     6e8:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     6ea:	8526                	mv	a0,s1
     6ec:	70a6                	ld	ra,104(sp)
     6ee:	7406                	ld	s0,96(sp)
     6f0:	64e6                	ld	s1,88(sp)
     6f2:	6946                	ld	s2,80(sp)
     6f4:	69a6                	ld	s3,72(sp)
     6f6:	6a06                	ld	s4,64(sp)
     6f8:	7ae2                	ld	s5,56(sp)
     6fa:	7b42                	ld	s6,48(sp)
     6fc:	7ba2                	ld	s7,40(sp)
     6fe:	7c02                	ld	s8,32(sp)
     700:	6ce2                	ld	s9,24(sp)
     702:	6165                	addi	sp,sp,112
     704:	8082                	ret
      panic("syntax");
     706:	00001517          	auipc	a0,0x1
     70a:	c8250513          	addi	a0,a0,-894 # 1388 <malloc+0x162>
     70e:	00000097          	auipc	ra,0x0
     712:	946080e7          	jalr	-1722(ra) # 54 <panic>
    ret = parseredirs(ret, ps, es);
     716:	8656                	mv	a2,s5
     718:	85d2                	mv	a1,s4
     71a:	8526                	mv	a0,s1
     71c:	00000097          	auipc	ra,0x0
     720:	e66080e7          	jalr	-410(ra) # 582 <parseredirs>
     724:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     726:	865a                	mv	a2,s6
     728:	85d6                	mv	a1,s5
     72a:	8552                	mv	a0,s4
     72c:	00000097          	auipc	ra,0x0
     730:	dec080e7          	jalr	-532(ra) # 518 <peek>
     734:	e131                	bnez	a0,778 <parseexec+0xfa>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     736:	f9040693          	addi	a3,s0,-112
     73a:	f9840613          	addi	a2,s0,-104
     73e:	85d6                	mv	a1,s5
     740:	8552                	mv	a0,s4
     742:	00000097          	auipc	ra,0x0
     746:	c9a080e7          	jalr	-870(ra) # 3dc <gettoken>
     74a:	c51d                	beqz	a0,778 <parseexec+0xfa>
    if(tok != 'a')
     74c:	fb951de3          	bne	a0,s9,706 <parseexec+0x88>
    cmd->argv[argc] = q;
     750:	f9843783          	ld	a5,-104(s0)
     754:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     758:	f9043783          	ld	a5,-112(s0)
     75c:	04f93823          	sd	a5,80(s2)
    argc++;
     760:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     762:	0921                	addi	s2,s2,8
     764:	fb7999e3          	bne	s3,s7,716 <parseexec+0x98>
      panic("too many args");
     768:	00001517          	auipc	a0,0x1
     76c:	c2850513          	addi	a0,a0,-984 # 1390 <malloc+0x16a>
     770:	00000097          	auipc	ra,0x0
     774:	8e4080e7          	jalr	-1820(ra) # 54 <panic>
  cmd->argv[argc] = 0;
     778:	098e                	slli	s3,s3,0x3
     77a:	99e2                	add	s3,s3,s8
     77c:	0009b423          	sd	zero,8(s3)
  cmd->eargv[argc] = 0;
     780:	0409bc23          	sd	zero,88(s3)
  return ret;
     784:	b79d                	j	6ea <parseexec+0x6c>

0000000000000786 <parsepipe>:
{
     786:	7179                	addi	sp,sp,-48
     788:	f406                	sd	ra,40(sp)
     78a:	f022                	sd	s0,32(sp)
     78c:	ec26                	sd	s1,24(sp)
     78e:	e84a                	sd	s2,16(sp)
     790:	e44e                	sd	s3,8(sp)
     792:	1800                	addi	s0,sp,48
     794:	892a                	mv	s2,a0
     796:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     798:	00000097          	auipc	ra,0x0
     79c:	ee6080e7          	jalr	-282(ra) # 67e <parseexec>
     7a0:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     7a2:	00001617          	auipc	a2,0x1
     7a6:	c0660613          	addi	a2,a2,-1018 # 13a8 <malloc+0x182>
     7aa:	85ce                	mv	a1,s3
     7ac:	854a                	mv	a0,s2
     7ae:	00000097          	auipc	ra,0x0
     7b2:	d6a080e7          	jalr	-662(ra) # 518 <peek>
     7b6:	e909                	bnez	a0,7c8 <parsepipe+0x42>
}
     7b8:	8526                	mv	a0,s1
     7ba:	70a2                	ld	ra,40(sp)
     7bc:	7402                	ld	s0,32(sp)
     7be:	64e2                	ld	s1,24(sp)
     7c0:	6942                	ld	s2,16(sp)
     7c2:	69a2                	ld	s3,8(sp)
     7c4:	6145                	addi	sp,sp,48
     7c6:	8082                	ret
    gettoken(ps, es, 0, 0);
     7c8:	4681                	li	a3,0
     7ca:	4601                	li	a2,0
     7cc:	85ce                	mv	a1,s3
     7ce:	854a                	mv	a0,s2
     7d0:	00000097          	auipc	ra,0x0
     7d4:	c0c080e7          	jalr	-1012(ra) # 3dc <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     7d8:	85ce                	mv	a1,s3
     7da:	854a                	mv	a0,s2
     7dc:	00000097          	auipc	ra,0x0
     7e0:	faa080e7          	jalr	-86(ra) # 786 <parsepipe>
     7e4:	85aa                	mv	a1,a0
     7e6:	8526                	mv	a0,s1
     7e8:	00000097          	auipc	ra,0x0
     7ec:	b2c080e7          	jalr	-1236(ra) # 314 <pipecmd>
     7f0:	84aa                	mv	s1,a0
  return cmd;
     7f2:	b7d9                	j	7b8 <parsepipe+0x32>

00000000000007f4 <parseline>:
{
     7f4:	7179                	addi	sp,sp,-48
     7f6:	f406                	sd	ra,40(sp)
     7f8:	f022                	sd	s0,32(sp)
     7fa:	ec26                	sd	s1,24(sp)
     7fc:	e84a                	sd	s2,16(sp)
     7fe:	e44e                	sd	s3,8(sp)
     800:	e052                	sd	s4,0(sp)
     802:	1800                	addi	s0,sp,48
     804:	892a                	mv	s2,a0
     806:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     808:	00000097          	auipc	ra,0x0
     80c:	f7e080e7          	jalr	-130(ra) # 786 <parsepipe>
     810:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     812:	00001a17          	auipc	s4,0x1
     816:	b9ea0a13          	addi	s4,s4,-1122 # 13b0 <malloc+0x18a>
     81a:	8652                	mv	a2,s4
     81c:	85ce                	mv	a1,s3
     81e:	854a                	mv	a0,s2
     820:	00000097          	auipc	ra,0x0
     824:	cf8080e7          	jalr	-776(ra) # 518 <peek>
     828:	c105                	beqz	a0,848 <parseline+0x54>
    gettoken(ps, es, 0, 0);
     82a:	4681                	li	a3,0
     82c:	4601                	li	a2,0
     82e:	85ce                	mv	a1,s3
     830:	854a                	mv	a0,s2
     832:	00000097          	auipc	ra,0x0
     836:	baa080e7          	jalr	-1110(ra) # 3dc <gettoken>
    cmd = backcmd(cmd);
     83a:	8526                	mv	a0,s1
     83c:	00000097          	auipc	ra,0x0
     840:	b64080e7          	jalr	-1180(ra) # 3a0 <backcmd>
     844:	84aa                	mv	s1,a0
     846:	bfd1                	j	81a <parseline+0x26>
  if(peek(ps, es, ";")){
     848:	00001617          	auipc	a2,0x1
     84c:	b7060613          	addi	a2,a2,-1168 # 13b8 <malloc+0x192>
     850:	85ce                	mv	a1,s3
     852:	854a                	mv	a0,s2
     854:	00000097          	auipc	ra,0x0
     858:	cc4080e7          	jalr	-828(ra) # 518 <peek>
     85c:	e911                	bnez	a0,870 <parseline+0x7c>
}
     85e:	8526                	mv	a0,s1
     860:	70a2                	ld	ra,40(sp)
     862:	7402                	ld	s0,32(sp)
     864:	64e2                	ld	s1,24(sp)
     866:	6942                	ld	s2,16(sp)
     868:	69a2                	ld	s3,8(sp)
     86a:	6a02                	ld	s4,0(sp)
     86c:	6145                	addi	sp,sp,48
     86e:	8082                	ret
    gettoken(ps, es, 0, 0);
     870:	4681                	li	a3,0
     872:	4601                	li	a2,0
     874:	85ce                	mv	a1,s3
     876:	854a                	mv	a0,s2
     878:	00000097          	auipc	ra,0x0
     87c:	b64080e7          	jalr	-1180(ra) # 3dc <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     880:	85ce                	mv	a1,s3
     882:	854a                	mv	a0,s2
     884:	00000097          	auipc	ra,0x0
     888:	f70080e7          	jalr	-144(ra) # 7f4 <parseline>
     88c:	85aa                	mv	a1,a0
     88e:	8526                	mv	a0,s1
     890:	00000097          	auipc	ra,0x0
     894:	aca080e7          	jalr	-1334(ra) # 35a <listcmd>
     898:	84aa                	mv	s1,a0
  return cmd;
     89a:	b7d1                	j	85e <parseline+0x6a>

000000000000089c <parseblock>:
{
     89c:	7179                	addi	sp,sp,-48
     89e:	f406                	sd	ra,40(sp)
     8a0:	f022                	sd	s0,32(sp)
     8a2:	ec26                	sd	s1,24(sp)
     8a4:	e84a                	sd	s2,16(sp)
     8a6:	e44e                	sd	s3,8(sp)
     8a8:	1800                	addi	s0,sp,48
     8aa:	84aa                	mv	s1,a0
     8ac:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     8ae:	00001617          	auipc	a2,0x1
     8b2:	ad260613          	addi	a2,a2,-1326 # 1380 <malloc+0x15a>
     8b6:	00000097          	auipc	ra,0x0
     8ba:	c62080e7          	jalr	-926(ra) # 518 <peek>
     8be:	c12d                	beqz	a0,920 <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     8c0:	4681                	li	a3,0
     8c2:	4601                	li	a2,0
     8c4:	85ca                	mv	a1,s2
     8c6:	8526                	mv	a0,s1
     8c8:	00000097          	auipc	ra,0x0
     8cc:	b14080e7          	jalr	-1260(ra) # 3dc <gettoken>
  cmd = parseline(ps, es);
     8d0:	85ca                	mv	a1,s2
     8d2:	8526                	mv	a0,s1
     8d4:	00000097          	auipc	ra,0x0
     8d8:	f20080e7          	jalr	-224(ra) # 7f4 <parseline>
     8dc:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     8de:	00001617          	auipc	a2,0x1
     8e2:	af260613          	addi	a2,a2,-1294 # 13d0 <malloc+0x1aa>
     8e6:	85ca                	mv	a1,s2
     8e8:	8526                	mv	a0,s1
     8ea:	00000097          	auipc	ra,0x0
     8ee:	c2e080e7          	jalr	-978(ra) # 518 <peek>
     8f2:	cd1d                	beqz	a0,930 <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     8f4:	4681                	li	a3,0
     8f6:	4601                	li	a2,0
     8f8:	85ca                	mv	a1,s2
     8fa:	8526                	mv	a0,s1
     8fc:	00000097          	auipc	ra,0x0
     900:	ae0080e7          	jalr	-1312(ra) # 3dc <gettoken>
  cmd = parseredirs(cmd, ps, es);
     904:	864a                	mv	a2,s2
     906:	85a6                	mv	a1,s1
     908:	854e                	mv	a0,s3
     90a:	00000097          	auipc	ra,0x0
     90e:	c78080e7          	jalr	-904(ra) # 582 <parseredirs>
}
     912:	70a2                	ld	ra,40(sp)
     914:	7402                	ld	s0,32(sp)
     916:	64e2                	ld	s1,24(sp)
     918:	6942                	ld	s2,16(sp)
     91a:	69a2                	ld	s3,8(sp)
     91c:	6145                	addi	sp,sp,48
     91e:	8082                	ret
    panic("parseblock");
     920:	00001517          	auipc	a0,0x1
     924:	aa050513          	addi	a0,a0,-1376 # 13c0 <malloc+0x19a>
     928:	fffff097          	auipc	ra,0xfffff
     92c:	72c080e7          	jalr	1836(ra) # 54 <panic>
    panic("syntax - missing )");
     930:	00001517          	auipc	a0,0x1
     934:	aa850513          	addi	a0,a0,-1368 # 13d8 <malloc+0x1b2>
     938:	fffff097          	auipc	ra,0xfffff
     93c:	71c080e7          	jalr	1820(ra) # 54 <panic>

0000000000000940 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     940:	1101                	addi	sp,sp,-32
     942:	ec06                	sd	ra,24(sp)
     944:	e822                	sd	s0,16(sp)
     946:	e426                	sd	s1,8(sp)
     948:	1000                	addi	s0,sp,32
     94a:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     94c:	c521                	beqz	a0,994 <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     94e:	4118                	lw	a4,0(a0)
     950:	4795                	li	a5,5
     952:	04e7e163          	bltu	a5,a4,994 <nulterminate+0x54>
     956:	00056783          	lwu	a5,0(a0)
     95a:	078a                	slli	a5,a5,0x2
     95c:	00001717          	auipc	a4,0x1
     960:	adc70713          	addi	a4,a4,-1316 # 1438 <malloc+0x212>
     964:	97ba                	add	a5,a5,a4
     966:	439c                	lw	a5,0(a5)
     968:	97ba                	add	a5,a5,a4
     96a:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     96c:	651c                	ld	a5,8(a0)
     96e:	c39d                	beqz	a5,994 <nulterminate+0x54>
     970:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     974:	67b8                	ld	a4,72(a5)
     976:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     97a:	07a1                	addi	a5,a5,8
     97c:	ff87b703          	ld	a4,-8(a5)
     980:	fb75                	bnez	a4,974 <nulterminate+0x34>
     982:	a809                	j	994 <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     984:	6508                	ld	a0,8(a0)
     986:	00000097          	auipc	ra,0x0
     98a:	fba080e7          	jalr	-70(ra) # 940 <nulterminate>
    *rcmd->efile = 0;
     98e:	6c9c                	ld	a5,24(s1)
     990:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     994:	8526                	mv	a0,s1
     996:	60e2                	ld	ra,24(sp)
     998:	6442                	ld	s0,16(sp)
     99a:	64a2                	ld	s1,8(sp)
     99c:	6105                	addi	sp,sp,32
     99e:	8082                	ret
    nulterminate(pcmd->left);
     9a0:	6508                	ld	a0,8(a0)
     9a2:	00000097          	auipc	ra,0x0
     9a6:	f9e080e7          	jalr	-98(ra) # 940 <nulterminate>
    nulterminate(pcmd->right);
     9aa:	6888                	ld	a0,16(s1)
     9ac:	00000097          	auipc	ra,0x0
     9b0:	f94080e7          	jalr	-108(ra) # 940 <nulterminate>
    break;
     9b4:	b7c5                	j	994 <nulterminate+0x54>
    nulterminate(lcmd->left);
     9b6:	6508                	ld	a0,8(a0)
     9b8:	00000097          	auipc	ra,0x0
     9bc:	f88080e7          	jalr	-120(ra) # 940 <nulterminate>
    nulterminate(lcmd->right);
     9c0:	6888                	ld	a0,16(s1)
     9c2:	00000097          	auipc	ra,0x0
     9c6:	f7e080e7          	jalr	-130(ra) # 940 <nulterminate>
    break;
     9ca:	b7e9                	j	994 <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     9cc:	6508                	ld	a0,8(a0)
     9ce:	00000097          	auipc	ra,0x0
     9d2:	f72080e7          	jalr	-142(ra) # 940 <nulterminate>
    break;
     9d6:	bf7d                	j	994 <nulterminate+0x54>

00000000000009d8 <parsecmd>:
{
     9d8:	7179                	addi	sp,sp,-48
     9da:	f406                	sd	ra,40(sp)
     9dc:	f022                	sd	s0,32(sp)
     9de:	ec26                	sd	s1,24(sp)
     9e0:	e84a                	sd	s2,16(sp)
     9e2:	1800                	addi	s0,sp,48
     9e4:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     9e8:	84aa                	mv	s1,a0
     9ea:	00000097          	auipc	ra,0x0
     9ee:	1b2080e7          	jalr	434(ra) # b9c <strlen>
     9f2:	1502                	slli	a0,a0,0x20
     9f4:	9101                	srli	a0,a0,0x20
     9f6:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     9f8:	85a6                	mv	a1,s1
     9fa:	fd840513          	addi	a0,s0,-40
     9fe:	00000097          	auipc	ra,0x0
     a02:	df6080e7          	jalr	-522(ra) # 7f4 <parseline>
     a06:	892a                	mv	s2,a0
  peek(&s, es, "");
     a08:	00001617          	auipc	a2,0x1
     a0c:	9e860613          	addi	a2,a2,-1560 # 13f0 <malloc+0x1ca>
     a10:	85a6                	mv	a1,s1
     a12:	fd840513          	addi	a0,s0,-40
     a16:	00000097          	auipc	ra,0x0
     a1a:	b02080e7          	jalr	-1278(ra) # 518 <peek>
  if(s != es){
     a1e:	fd843603          	ld	a2,-40(s0)
     a22:	00961e63          	bne	a2,s1,a3e <parsecmd+0x66>
  nulterminate(cmd);
     a26:	854a                	mv	a0,s2
     a28:	00000097          	auipc	ra,0x0
     a2c:	f18080e7          	jalr	-232(ra) # 940 <nulterminate>
}
     a30:	854a                	mv	a0,s2
     a32:	70a2                	ld	ra,40(sp)
     a34:	7402                	ld	s0,32(sp)
     a36:	64e2                	ld	s1,24(sp)
     a38:	6942                	ld	s2,16(sp)
     a3a:	6145                	addi	sp,sp,48
     a3c:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a3e:	00001597          	auipc	a1,0x1
     a42:	9ba58593          	addi	a1,a1,-1606 # 13f8 <malloc+0x1d2>
     a46:	4509                	li	a0,2
     a48:	00000097          	auipc	ra,0x0
     a4c:	6f2080e7          	jalr	1778(ra) # 113a <fprintf>
    panic("syntax");
     a50:	00001517          	auipc	a0,0x1
     a54:	93850513          	addi	a0,a0,-1736 # 1388 <malloc+0x162>
     a58:	fffff097          	auipc	ra,0xfffff
     a5c:	5fc080e7          	jalr	1532(ra) # 54 <panic>

0000000000000a60 <main>:
{
     a60:	7139                	addi	sp,sp,-64
     a62:	fc06                	sd	ra,56(sp)
     a64:	f822                	sd	s0,48(sp)
     a66:	f426                	sd	s1,40(sp)
     a68:	f04a                	sd	s2,32(sp)
     a6a:	ec4e                	sd	s3,24(sp)
     a6c:	e852                	sd	s4,16(sp)
     a6e:	e456                	sd	s5,8(sp)
     a70:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     a72:	00001497          	auipc	s1,0x1
     a76:	99648493          	addi	s1,s1,-1642 # 1408 <malloc+0x1e2>
     a7a:	4589                	li	a1,2
     a7c:	8526                	mv	a0,s1
     a7e:	00000097          	auipc	ra,0x0
     a82:	3a2080e7          	jalr	930(ra) # e20 <open>
     a86:	00054963          	bltz	a0,a98 <main+0x38>
    if(fd >= 3){
     a8a:	4789                	li	a5,2
     a8c:	fea7d7e3          	bge	a5,a0,a7a <main+0x1a>
      close(fd);
     a90:	00000097          	auipc	ra,0x0
     a94:	378080e7          	jalr	888(ra) # e08 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     a98:	00001497          	auipc	s1,0x1
     a9c:	9f048493          	addi	s1,s1,-1552 # 1488 <buf.1143>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     aa0:	06300913          	li	s2,99
     aa4:	02000993          	li	s3,32
      if(chdir(buf+3) < 0)
     aa8:	00001a17          	auipc	s4,0x1
     aac:	9e3a0a13          	addi	s4,s4,-1565 # 148b <buf.1143+0x3>
        fprintf(2, "cannot cd %s\n", buf+3);
     ab0:	00001a97          	auipc	s5,0x1
     ab4:	960a8a93          	addi	s5,s5,-1696 # 1410 <malloc+0x1ea>
     ab8:	a819                	j	ace <main+0x6e>
    if(fork1() == 0)
     aba:	fffff097          	auipc	ra,0xfffff
     abe:	5c0080e7          	jalr	1472(ra) # 7a <fork1>
     ac2:	c925                	beqz	a0,b32 <main+0xd2>
    wait(0);
     ac4:	4501                	li	a0,0
     ac6:	00000097          	auipc	ra,0x0
     aca:	322080e7          	jalr	802(ra) # de8 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     ace:	06400593          	li	a1,100
     ad2:	8526                	mv	a0,s1
     ad4:	fffff097          	auipc	ra,0xfffff
     ad8:	52c080e7          	jalr	1324(ra) # 0 <getcmd>
     adc:	06054763          	bltz	a0,b4a <main+0xea>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     ae0:	0004c783          	lbu	a5,0(s1)
     ae4:	fd279be3          	bne	a5,s2,aba <main+0x5a>
     ae8:	0014c703          	lbu	a4,1(s1)
     aec:	06400793          	li	a5,100
     af0:	fcf715e3          	bne	a4,a5,aba <main+0x5a>
     af4:	0024c783          	lbu	a5,2(s1)
     af8:	fd3791e3          	bne	a5,s3,aba <main+0x5a>
      buf[strlen(buf)-1] = 0;  // chop \n
     afc:	8526                	mv	a0,s1
     afe:	00000097          	auipc	ra,0x0
     b02:	09e080e7          	jalr	158(ra) # b9c <strlen>
     b06:	fff5079b          	addiw	a5,a0,-1
     b0a:	1782                	slli	a5,a5,0x20
     b0c:	9381                	srli	a5,a5,0x20
     b0e:	97a6                	add	a5,a5,s1
     b10:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     b14:	8552                	mv	a0,s4
     b16:	00000097          	auipc	ra,0x0
     b1a:	33a080e7          	jalr	826(ra) # e50 <chdir>
     b1e:	fa0558e3          	bgez	a0,ace <main+0x6e>
        fprintf(2, "cannot cd %s\n", buf+3);
     b22:	8652                	mv	a2,s4
     b24:	85d6                	mv	a1,s5
     b26:	4509                	li	a0,2
     b28:	00000097          	auipc	ra,0x0
     b2c:	612080e7          	jalr	1554(ra) # 113a <fprintf>
     b30:	bf79                	j	ace <main+0x6e>
      runcmd(parsecmd(buf));
     b32:	00001517          	auipc	a0,0x1
     b36:	95650513          	addi	a0,a0,-1706 # 1488 <buf.1143>
     b3a:	00000097          	auipc	ra,0x0
     b3e:	e9e080e7          	jalr	-354(ra) # 9d8 <parsecmd>
     b42:	fffff097          	auipc	ra,0xfffff
     b46:	566080e7          	jalr	1382(ra) # a8 <runcmd>
  exit(0);
     b4a:	4501                	li	a0,0
     b4c:	00000097          	auipc	ra,0x0
     b50:	294080e7          	jalr	660(ra) # de0 <exit>

0000000000000b54 <strcpy>:



char*
strcpy(char *s, const char *t)
{
     b54:	1141                	addi	sp,sp,-16
     b56:	e422                	sd	s0,8(sp)
     b58:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b5a:	87aa                	mv	a5,a0
     b5c:	0585                	addi	a1,a1,1
     b5e:	0785                	addi	a5,a5,1
     b60:	fff5c703          	lbu	a4,-1(a1)
     b64:	fee78fa3          	sb	a4,-1(a5)
     b68:	fb75                	bnez	a4,b5c <strcpy+0x8>
    ;
  return os;
}
     b6a:	6422                	ld	s0,8(sp)
     b6c:	0141                	addi	sp,sp,16
     b6e:	8082                	ret

0000000000000b70 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b70:	1141                	addi	sp,sp,-16
     b72:	e422                	sd	s0,8(sp)
     b74:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     b76:	00054783          	lbu	a5,0(a0)
     b7a:	cb91                	beqz	a5,b8e <strcmp+0x1e>
     b7c:	0005c703          	lbu	a4,0(a1)
     b80:	00f71763          	bne	a4,a5,b8e <strcmp+0x1e>
    p++, q++;
     b84:	0505                	addi	a0,a0,1
     b86:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     b88:	00054783          	lbu	a5,0(a0)
     b8c:	fbe5                	bnez	a5,b7c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     b8e:	0005c503          	lbu	a0,0(a1)
}
     b92:	40a7853b          	subw	a0,a5,a0
     b96:	6422                	ld	s0,8(sp)
     b98:	0141                	addi	sp,sp,16
     b9a:	8082                	ret

0000000000000b9c <strlen>:

uint
strlen(const char *s)
{
     b9c:	1141                	addi	sp,sp,-16
     b9e:	e422                	sd	s0,8(sp)
     ba0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     ba2:	00054783          	lbu	a5,0(a0)
     ba6:	cf91                	beqz	a5,bc2 <strlen+0x26>
     ba8:	0505                	addi	a0,a0,1
     baa:	87aa                	mv	a5,a0
     bac:	4685                	li	a3,1
     bae:	9e89                	subw	a3,a3,a0
     bb0:	00f6853b          	addw	a0,a3,a5
     bb4:	0785                	addi	a5,a5,1
     bb6:	fff7c703          	lbu	a4,-1(a5)
     bba:	fb7d                	bnez	a4,bb0 <strlen+0x14>
    ;
  return n;
}
     bbc:	6422                	ld	s0,8(sp)
     bbe:	0141                	addi	sp,sp,16
     bc0:	8082                	ret
  for(n = 0; s[n]; n++)
     bc2:	4501                	li	a0,0
     bc4:	bfe5                	j	bbc <strlen+0x20>

0000000000000bc6 <memset>:

void*
memset(void *dst, int c, uint n)
{
     bc6:	1141                	addi	sp,sp,-16
     bc8:	e422                	sd	s0,8(sp)
     bca:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     bcc:	ce09                	beqz	a2,be6 <memset+0x20>
     bce:	87aa                	mv	a5,a0
     bd0:	fff6071b          	addiw	a4,a2,-1
     bd4:	1702                	slli	a4,a4,0x20
     bd6:	9301                	srli	a4,a4,0x20
     bd8:	0705                	addi	a4,a4,1
     bda:	972a                	add	a4,a4,a0
    cdst[i] = c;
     bdc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     be0:	0785                	addi	a5,a5,1
     be2:	fee79de3          	bne	a5,a4,bdc <memset+0x16>
  }
  return dst;
}
     be6:	6422                	ld	s0,8(sp)
     be8:	0141                	addi	sp,sp,16
     bea:	8082                	ret

0000000000000bec <strchr>:

char*
strchr(const char *s, char c)
{
     bec:	1141                	addi	sp,sp,-16
     bee:	e422                	sd	s0,8(sp)
     bf0:	0800                	addi	s0,sp,16
  for(; *s; s++)
     bf2:	00054783          	lbu	a5,0(a0)
     bf6:	cb99                	beqz	a5,c0c <strchr+0x20>
    if(*s == c)
     bf8:	00f58763          	beq	a1,a5,c06 <strchr+0x1a>
  for(; *s; s++)
     bfc:	0505                	addi	a0,a0,1
     bfe:	00054783          	lbu	a5,0(a0)
     c02:	fbfd                	bnez	a5,bf8 <strchr+0xc>
      return (char*)s;
  return 0;
     c04:	4501                	li	a0,0
}
     c06:	6422                	ld	s0,8(sp)
     c08:	0141                	addi	sp,sp,16
     c0a:	8082                	ret
  return 0;
     c0c:	4501                	li	a0,0
     c0e:	bfe5                	j	c06 <strchr+0x1a>

0000000000000c10 <gets>:

char*
gets(char *buf, int max)
{
     c10:	711d                	addi	sp,sp,-96
     c12:	ec86                	sd	ra,88(sp)
     c14:	e8a2                	sd	s0,80(sp)
     c16:	e4a6                	sd	s1,72(sp)
     c18:	e0ca                	sd	s2,64(sp)
     c1a:	fc4e                	sd	s3,56(sp)
     c1c:	f852                	sd	s4,48(sp)
     c1e:	f456                	sd	s5,40(sp)
     c20:	f05a                	sd	s6,32(sp)
     c22:	ec5e                	sd	s7,24(sp)
     c24:	1080                	addi	s0,sp,96
     c26:	8baa                	mv	s7,a0
     c28:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c2a:	892a                	mv	s2,a0
     c2c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c2e:	4aa9                	li	s5,10
     c30:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c32:	89a6                	mv	s3,s1
     c34:	2485                	addiw	s1,s1,1
     c36:	0344d863          	bge	s1,s4,c66 <gets+0x56>
    cc = read(0, &c, 1);
     c3a:	4605                	li	a2,1
     c3c:	faf40593          	addi	a1,s0,-81
     c40:	4501                	li	a0,0
     c42:	00000097          	auipc	ra,0x0
     c46:	1b6080e7          	jalr	438(ra) # df8 <read>
    if(cc < 1)
     c4a:	00a05e63          	blez	a0,c66 <gets+0x56>
    buf[i++] = c;
     c4e:	faf44783          	lbu	a5,-81(s0)
     c52:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c56:	01578763          	beq	a5,s5,c64 <gets+0x54>
     c5a:	0905                	addi	s2,s2,1
     c5c:	fd679be3          	bne	a5,s6,c32 <gets+0x22>
  for(i=0; i+1 < max; ){
     c60:	89a6                	mv	s3,s1
     c62:	a011                	j	c66 <gets+0x56>
     c64:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c66:	99de                	add	s3,s3,s7
     c68:	00098023          	sb	zero,0(s3)
  return buf;
}
     c6c:	855e                	mv	a0,s7
     c6e:	60e6                	ld	ra,88(sp)
     c70:	6446                	ld	s0,80(sp)
     c72:	64a6                	ld	s1,72(sp)
     c74:	6906                	ld	s2,64(sp)
     c76:	79e2                	ld	s3,56(sp)
     c78:	7a42                	ld	s4,48(sp)
     c7a:	7aa2                	ld	s5,40(sp)
     c7c:	7b02                	ld	s6,32(sp)
     c7e:	6be2                	ld	s7,24(sp)
     c80:	6125                	addi	sp,sp,96
     c82:	8082                	ret

0000000000000c84 <stat>:

int
stat(const char *n, struct stat *st)
{
     c84:	1101                	addi	sp,sp,-32
     c86:	ec06                	sd	ra,24(sp)
     c88:	e822                	sd	s0,16(sp)
     c8a:	e426                	sd	s1,8(sp)
     c8c:	e04a                	sd	s2,0(sp)
     c8e:	1000                	addi	s0,sp,32
     c90:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     c92:	4581                	li	a1,0
     c94:	00000097          	auipc	ra,0x0
     c98:	18c080e7          	jalr	396(ra) # e20 <open>
  if(fd < 0)
     c9c:	02054563          	bltz	a0,cc6 <stat+0x42>
     ca0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     ca2:	85ca                	mv	a1,s2
     ca4:	00000097          	auipc	ra,0x0
     ca8:	194080e7          	jalr	404(ra) # e38 <fstat>
     cac:	892a                	mv	s2,a0
  close(fd);
     cae:	8526                	mv	a0,s1
     cb0:	00000097          	auipc	ra,0x0
     cb4:	158080e7          	jalr	344(ra) # e08 <close>
  return r;
}
     cb8:	854a                	mv	a0,s2
     cba:	60e2                	ld	ra,24(sp)
     cbc:	6442                	ld	s0,16(sp)
     cbe:	64a2                	ld	s1,8(sp)
     cc0:	6902                	ld	s2,0(sp)
     cc2:	6105                	addi	sp,sp,32
     cc4:	8082                	ret
    return -1;
     cc6:	597d                	li	s2,-1
     cc8:	bfc5                	j	cb8 <stat+0x34>

0000000000000cca <atoi>:

int
atoi(const char *s)
{
     cca:	1141                	addi	sp,sp,-16
     ccc:	e422                	sd	s0,8(sp)
     cce:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     cd0:	00054603          	lbu	a2,0(a0)
     cd4:	fd06079b          	addiw	a5,a2,-48
     cd8:	0ff7f793          	andi	a5,a5,255
     cdc:	4725                	li	a4,9
     cde:	02f76963          	bltu	a4,a5,d10 <atoi+0x46>
     ce2:	86aa                	mv	a3,a0
  n = 0;
     ce4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     ce6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     ce8:	0685                	addi	a3,a3,1
     cea:	0025179b          	slliw	a5,a0,0x2
     cee:	9fa9                	addw	a5,a5,a0
     cf0:	0017979b          	slliw	a5,a5,0x1
     cf4:	9fb1                	addw	a5,a5,a2
     cf6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     cfa:	0006c603          	lbu	a2,0(a3)
     cfe:	fd06071b          	addiw	a4,a2,-48
     d02:	0ff77713          	andi	a4,a4,255
     d06:	fee5f1e3          	bgeu	a1,a4,ce8 <atoi+0x1e>
  return n;
}
     d0a:	6422                	ld	s0,8(sp)
     d0c:	0141                	addi	sp,sp,16
     d0e:	8082                	ret
  n = 0;
     d10:	4501                	li	a0,0
     d12:	bfe5                	j	d0a <atoi+0x40>

0000000000000d14 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d14:	1141                	addi	sp,sp,-16
     d16:	e422                	sd	s0,8(sp)
     d18:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d1a:	02b57663          	bgeu	a0,a1,d46 <memmove+0x32>
    while(n-- > 0)
     d1e:	02c05163          	blez	a2,d40 <memmove+0x2c>
     d22:	fff6079b          	addiw	a5,a2,-1
     d26:	1782                	slli	a5,a5,0x20
     d28:	9381                	srli	a5,a5,0x20
     d2a:	0785                	addi	a5,a5,1
     d2c:	97aa                	add	a5,a5,a0
  dst = vdst;
     d2e:	872a                	mv	a4,a0
      *dst++ = *src++;
     d30:	0585                	addi	a1,a1,1
     d32:	0705                	addi	a4,a4,1
     d34:	fff5c683          	lbu	a3,-1(a1)
     d38:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d3c:	fee79ae3          	bne	a5,a4,d30 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d40:	6422                	ld	s0,8(sp)
     d42:	0141                	addi	sp,sp,16
     d44:	8082                	ret
    dst += n;
     d46:	00c50733          	add	a4,a0,a2
    src += n;
     d4a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d4c:	fec05ae3          	blez	a2,d40 <memmove+0x2c>
     d50:	fff6079b          	addiw	a5,a2,-1
     d54:	1782                	slli	a5,a5,0x20
     d56:	9381                	srli	a5,a5,0x20
     d58:	fff7c793          	not	a5,a5
     d5c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d5e:	15fd                	addi	a1,a1,-1
     d60:	177d                	addi	a4,a4,-1
     d62:	0005c683          	lbu	a3,0(a1)
     d66:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     d6a:	fee79ae3          	bne	a5,a4,d5e <memmove+0x4a>
     d6e:	bfc9                	j	d40 <memmove+0x2c>

0000000000000d70 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     d70:	1141                	addi	sp,sp,-16
     d72:	e422                	sd	s0,8(sp)
     d74:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     d76:	ca05                	beqz	a2,da6 <memcmp+0x36>
     d78:	fff6069b          	addiw	a3,a2,-1
     d7c:	1682                	slli	a3,a3,0x20
     d7e:	9281                	srli	a3,a3,0x20
     d80:	0685                	addi	a3,a3,1
     d82:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     d84:	00054783          	lbu	a5,0(a0)
     d88:	0005c703          	lbu	a4,0(a1)
     d8c:	00e79863          	bne	a5,a4,d9c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     d90:	0505                	addi	a0,a0,1
    p2++;
     d92:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     d94:	fed518e3          	bne	a0,a3,d84 <memcmp+0x14>
  }
  return 0;
     d98:	4501                	li	a0,0
     d9a:	a019                	j	da0 <memcmp+0x30>
      return *p1 - *p2;
     d9c:	40e7853b          	subw	a0,a5,a4
}
     da0:	6422                	ld	s0,8(sp)
     da2:	0141                	addi	sp,sp,16
     da4:	8082                	ret
  return 0;
     da6:	4501                	li	a0,0
     da8:	bfe5                	j	da0 <memcmp+0x30>

0000000000000daa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     daa:	1141                	addi	sp,sp,-16
     dac:	e406                	sd	ra,8(sp)
     dae:	e022                	sd	s0,0(sp)
     db0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     db2:	00000097          	auipc	ra,0x0
     db6:	f62080e7          	jalr	-158(ra) # d14 <memmove>
}
     dba:	60a2                	ld	ra,8(sp)
     dbc:	6402                	ld	s0,0(sp)
     dbe:	0141                	addi	sp,sp,16
     dc0:	8082                	ret

0000000000000dc2 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
     dc2:	1141                	addi	sp,sp,-16
     dc4:	e422                	sd	s0,8(sp)
     dc6:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
     dc8:	040007b7          	lui	a5,0x4000
}
     dcc:	17f5                	addi	a5,a5,-3
     dce:	07b2                	slli	a5,a5,0xc
     dd0:	4388                	lw	a0,0(a5)
     dd2:	6422                	ld	s0,8(sp)
     dd4:	0141                	addi	sp,sp,16
     dd6:	8082                	ret

0000000000000dd8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     dd8:	4885                	li	a7,1
 ecall
     dda:	00000073          	ecall
 ret
     dde:	8082                	ret

0000000000000de0 <exit>:
.global exit
exit:
 li a7, SYS_exit
     de0:	4889                	li	a7,2
 ecall
     de2:	00000073          	ecall
 ret
     de6:	8082                	ret

0000000000000de8 <wait>:
.global wait
wait:
 li a7, SYS_wait
     de8:	488d                	li	a7,3
 ecall
     dea:	00000073          	ecall
 ret
     dee:	8082                	ret

0000000000000df0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     df0:	4891                	li	a7,4
 ecall
     df2:	00000073          	ecall
 ret
     df6:	8082                	ret

0000000000000df8 <read>:
.global read
read:
 li a7, SYS_read
     df8:	4895                	li	a7,5
 ecall
     dfa:	00000073          	ecall
 ret
     dfe:	8082                	ret

0000000000000e00 <write>:
.global write
write:
 li a7, SYS_write
     e00:	48c1                	li	a7,16
 ecall
     e02:	00000073          	ecall
 ret
     e06:	8082                	ret

0000000000000e08 <close>:
.global close
close:
 li a7, SYS_close
     e08:	48d5                	li	a7,21
 ecall
     e0a:	00000073          	ecall
 ret
     e0e:	8082                	ret

0000000000000e10 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e10:	4899                	li	a7,6
 ecall
     e12:	00000073          	ecall
 ret
     e16:	8082                	ret

0000000000000e18 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e18:	489d                	li	a7,7
 ecall
     e1a:	00000073          	ecall
 ret
     e1e:	8082                	ret

0000000000000e20 <open>:
.global open
open:
 li a7, SYS_open
     e20:	48bd                	li	a7,15
 ecall
     e22:	00000073          	ecall
 ret
     e26:	8082                	ret

0000000000000e28 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e28:	48c5                	li	a7,17
 ecall
     e2a:	00000073          	ecall
 ret
     e2e:	8082                	ret

0000000000000e30 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e30:	48c9                	li	a7,18
 ecall
     e32:	00000073          	ecall
 ret
     e36:	8082                	ret

0000000000000e38 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e38:	48a1                	li	a7,8
 ecall
     e3a:	00000073          	ecall
 ret
     e3e:	8082                	ret

0000000000000e40 <link>:
.global link
link:
 li a7, SYS_link
     e40:	48cd                	li	a7,19
 ecall
     e42:	00000073          	ecall
 ret
     e46:	8082                	ret

0000000000000e48 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e48:	48d1                	li	a7,20
 ecall
     e4a:	00000073          	ecall
 ret
     e4e:	8082                	ret

0000000000000e50 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e50:	48a5                	li	a7,9
 ecall
     e52:	00000073          	ecall
 ret
     e56:	8082                	ret

0000000000000e58 <dup>:
.global dup
dup:
 li a7, SYS_dup
     e58:	48a9                	li	a7,10
 ecall
     e5a:	00000073          	ecall
 ret
     e5e:	8082                	ret

0000000000000e60 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e60:	48ad                	li	a7,11
 ecall
     e62:	00000073          	ecall
 ret
     e66:	8082                	ret

0000000000000e68 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e68:	48b1                	li	a7,12
 ecall
     e6a:	00000073          	ecall
 ret
     e6e:	8082                	ret

0000000000000e70 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e70:	48b5                	li	a7,13
 ecall
     e72:	00000073          	ecall
 ret
     e76:	8082                	ret

0000000000000e78 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e78:	48b9                	li	a7,14
 ecall
     e7a:	00000073          	ecall
 ret
     e7e:	8082                	ret

0000000000000e80 <connect>:
.global connect
connect:
 li a7, SYS_connect
     e80:	48f5                	li	a7,29
 ecall
     e82:	00000073          	ecall
 ret
     e86:	8082                	ret

0000000000000e88 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     e88:	48f9                	li	a7,30
 ecall
     e8a:	00000073          	ecall
 ret
     e8e:	8082                	ret

0000000000000e90 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     e90:	1101                	addi	sp,sp,-32
     e92:	ec06                	sd	ra,24(sp)
     e94:	e822                	sd	s0,16(sp)
     e96:	1000                	addi	s0,sp,32
     e98:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     e9c:	4605                	li	a2,1
     e9e:	fef40593          	addi	a1,s0,-17
     ea2:	00000097          	auipc	ra,0x0
     ea6:	f5e080e7          	jalr	-162(ra) # e00 <write>
}
     eaa:	60e2                	ld	ra,24(sp)
     eac:	6442                	ld	s0,16(sp)
     eae:	6105                	addi	sp,sp,32
     eb0:	8082                	ret

0000000000000eb2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     eb2:	7139                	addi	sp,sp,-64
     eb4:	fc06                	sd	ra,56(sp)
     eb6:	f822                	sd	s0,48(sp)
     eb8:	f426                	sd	s1,40(sp)
     eba:	f04a                	sd	s2,32(sp)
     ebc:	ec4e                	sd	s3,24(sp)
     ebe:	0080                	addi	s0,sp,64
     ec0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ec2:	c299                	beqz	a3,ec8 <printint+0x16>
     ec4:	0805c863          	bltz	a1,f54 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     ec8:	2581                	sext.w	a1,a1
  neg = 0;
     eca:	4881                	li	a7,0
     ecc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     ed0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     ed2:	2601                	sext.w	a2,a2
     ed4:	00000517          	auipc	a0,0x0
     ed8:	58450513          	addi	a0,a0,1412 # 1458 <digits>
     edc:	883a                	mv	a6,a4
     ede:	2705                	addiw	a4,a4,1
     ee0:	02c5f7bb          	remuw	a5,a1,a2
     ee4:	1782                	slli	a5,a5,0x20
     ee6:	9381                	srli	a5,a5,0x20
     ee8:	97aa                	add	a5,a5,a0
     eea:	0007c783          	lbu	a5,0(a5) # 4000000 <__global_pointer$+0x3ffe397>
     eee:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     ef2:	0005879b          	sext.w	a5,a1
     ef6:	02c5d5bb          	divuw	a1,a1,a2
     efa:	0685                	addi	a3,a3,1
     efc:	fec7f0e3          	bgeu	a5,a2,edc <printint+0x2a>
  if(neg)
     f00:	00088b63          	beqz	a7,f16 <printint+0x64>
    buf[i++] = '-';
     f04:	fd040793          	addi	a5,s0,-48
     f08:	973e                	add	a4,a4,a5
     f0a:	02d00793          	li	a5,45
     f0e:	fef70823          	sb	a5,-16(a4)
     f12:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f16:	02e05863          	blez	a4,f46 <printint+0x94>
     f1a:	fc040793          	addi	a5,s0,-64
     f1e:	00e78933          	add	s2,a5,a4
     f22:	fff78993          	addi	s3,a5,-1
     f26:	99ba                	add	s3,s3,a4
     f28:	377d                	addiw	a4,a4,-1
     f2a:	1702                	slli	a4,a4,0x20
     f2c:	9301                	srli	a4,a4,0x20
     f2e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f32:	fff94583          	lbu	a1,-1(s2)
     f36:	8526                	mv	a0,s1
     f38:	00000097          	auipc	ra,0x0
     f3c:	f58080e7          	jalr	-168(ra) # e90 <putc>
  while(--i >= 0)
     f40:	197d                	addi	s2,s2,-1
     f42:	ff3918e3          	bne	s2,s3,f32 <printint+0x80>
}
     f46:	70e2                	ld	ra,56(sp)
     f48:	7442                	ld	s0,48(sp)
     f4a:	74a2                	ld	s1,40(sp)
     f4c:	7902                	ld	s2,32(sp)
     f4e:	69e2                	ld	s3,24(sp)
     f50:	6121                	addi	sp,sp,64
     f52:	8082                	ret
    x = -xx;
     f54:	40b005bb          	negw	a1,a1
    neg = 1;
     f58:	4885                	li	a7,1
    x = -xx;
     f5a:	bf8d                	j	ecc <printint+0x1a>

0000000000000f5c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f5c:	7119                	addi	sp,sp,-128
     f5e:	fc86                	sd	ra,120(sp)
     f60:	f8a2                	sd	s0,112(sp)
     f62:	f4a6                	sd	s1,104(sp)
     f64:	f0ca                	sd	s2,96(sp)
     f66:	ecce                	sd	s3,88(sp)
     f68:	e8d2                	sd	s4,80(sp)
     f6a:	e4d6                	sd	s5,72(sp)
     f6c:	e0da                	sd	s6,64(sp)
     f6e:	fc5e                	sd	s7,56(sp)
     f70:	f862                	sd	s8,48(sp)
     f72:	f466                	sd	s9,40(sp)
     f74:	f06a                	sd	s10,32(sp)
     f76:	ec6e                	sd	s11,24(sp)
     f78:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f7a:	0005c903          	lbu	s2,0(a1)
     f7e:	18090f63          	beqz	s2,111c <vprintf+0x1c0>
     f82:	8aaa                	mv	s5,a0
     f84:	8b32                	mv	s6,a2
     f86:	00158493          	addi	s1,a1,1
  state = 0;
     f8a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     f8c:	02500a13          	li	s4,37
      if(c == 'd'){
     f90:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     f94:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     f98:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     f9c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fa0:	00000b97          	auipc	s7,0x0
     fa4:	4b8b8b93          	addi	s7,s7,1208 # 1458 <digits>
     fa8:	a839                	j	fc6 <vprintf+0x6a>
        putc(fd, c);
     faa:	85ca                	mv	a1,s2
     fac:	8556                	mv	a0,s5
     fae:	00000097          	auipc	ra,0x0
     fb2:	ee2080e7          	jalr	-286(ra) # e90 <putc>
     fb6:	a019                	j	fbc <vprintf+0x60>
    } else if(state == '%'){
     fb8:	01498f63          	beq	s3,s4,fd6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     fbc:	0485                	addi	s1,s1,1
     fbe:	fff4c903          	lbu	s2,-1(s1)
     fc2:	14090d63          	beqz	s2,111c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
     fc6:	0009079b          	sext.w	a5,s2
    if(state == 0){
     fca:	fe0997e3          	bnez	s3,fb8 <vprintf+0x5c>
      if(c == '%'){
     fce:	fd479ee3          	bne	a5,s4,faa <vprintf+0x4e>
        state = '%';
     fd2:	89be                	mv	s3,a5
     fd4:	b7e5                	j	fbc <vprintf+0x60>
      if(c == 'd'){
     fd6:	05878063          	beq	a5,s8,1016 <vprintf+0xba>
      } else if(c == 'l') {
     fda:	05978c63          	beq	a5,s9,1032 <vprintf+0xd6>
      } else if(c == 'x') {
     fde:	07a78863          	beq	a5,s10,104e <vprintf+0xf2>
      } else if(c == 'p') {
     fe2:	09b78463          	beq	a5,s11,106a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
     fe6:	07300713          	li	a4,115
     fea:	0ce78663          	beq	a5,a4,10b6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     fee:	06300713          	li	a4,99
     ff2:	0ee78e63          	beq	a5,a4,10ee <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
     ff6:	11478863          	beq	a5,s4,1106 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     ffa:	85d2                	mv	a1,s4
     ffc:	8556                	mv	a0,s5
     ffe:	00000097          	auipc	ra,0x0
    1002:	e92080e7          	jalr	-366(ra) # e90 <putc>
        putc(fd, c);
    1006:	85ca                	mv	a1,s2
    1008:	8556                	mv	a0,s5
    100a:	00000097          	auipc	ra,0x0
    100e:	e86080e7          	jalr	-378(ra) # e90 <putc>
      }
      state = 0;
    1012:	4981                	li	s3,0
    1014:	b765                	j	fbc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    1016:	008b0913          	addi	s2,s6,8
    101a:	4685                	li	a3,1
    101c:	4629                	li	a2,10
    101e:	000b2583          	lw	a1,0(s6)
    1022:	8556                	mv	a0,s5
    1024:	00000097          	auipc	ra,0x0
    1028:	e8e080e7          	jalr	-370(ra) # eb2 <printint>
    102c:	8b4a                	mv	s6,s2
      state = 0;
    102e:	4981                	li	s3,0
    1030:	b771                	j	fbc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1032:	008b0913          	addi	s2,s6,8
    1036:	4681                	li	a3,0
    1038:	4629                	li	a2,10
    103a:	000b2583          	lw	a1,0(s6)
    103e:	8556                	mv	a0,s5
    1040:	00000097          	auipc	ra,0x0
    1044:	e72080e7          	jalr	-398(ra) # eb2 <printint>
    1048:	8b4a                	mv	s6,s2
      state = 0;
    104a:	4981                	li	s3,0
    104c:	bf85                	j	fbc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    104e:	008b0913          	addi	s2,s6,8
    1052:	4681                	li	a3,0
    1054:	4641                	li	a2,16
    1056:	000b2583          	lw	a1,0(s6)
    105a:	8556                	mv	a0,s5
    105c:	00000097          	auipc	ra,0x0
    1060:	e56080e7          	jalr	-426(ra) # eb2 <printint>
    1064:	8b4a                	mv	s6,s2
      state = 0;
    1066:	4981                	li	s3,0
    1068:	bf91                	j	fbc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    106a:	008b0793          	addi	a5,s6,8
    106e:	f8f43423          	sd	a5,-120(s0)
    1072:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1076:	03000593          	li	a1,48
    107a:	8556                	mv	a0,s5
    107c:	00000097          	auipc	ra,0x0
    1080:	e14080e7          	jalr	-492(ra) # e90 <putc>
  putc(fd, 'x');
    1084:	85ea                	mv	a1,s10
    1086:	8556                	mv	a0,s5
    1088:	00000097          	auipc	ra,0x0
    108c:	e08080e7          	jalr	-504(ra) # e90 <putc>
    1090:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1092:	03c9d793          	srli	a5,s3,0x3c
    1096:	97de                	add	a5,a5,s7
    1098:	0007c583          	lbu	a1,0(a5)
    109c:	8556                	mv	a0,s5
    109e:	00000097          	auipc	ra,0x0
    10a2:	df2080e7          	jalr	-526(ra) # e90 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    10a6:	0992                	slli	s3,s3,0x4
    10a8:	397d                	addiw	s2,s2,-1
    10aa:	fe0914e3          	bnez	s2,1092 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    10ae:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    10b2:	4981                	li	s3,0
    10b4:	b721                	j	fbc <vprintf+0x60>
        s = va_arg(ap, char*);
    10b6:	008b0993          	addi	s3,s6,8
    10ba:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    10be:	02090163          	beqz	s2,10e0 <vprintf+0x184>
        while(*s != 0){
    10c2:	00094583          	lbu	a1,0(s2)
    10c6:	c9a1                	beqz	a1,1116 <vprintf+0x1ba>
          putc(fd, *s);
    10c8:	8556                	mv	a0,s5
    10ca:	00000097          	auipc	ra,0x0
    10ce:	dc6080e7          	jalr	-570(ra) # e90 <putc>
          s++;
    10d2:	0905                	addi	s2,s2,1
        while(*s != 0){
    10d4:	00094583          	lbu	a1,0(s2)
    10d8:	f9e5                	bnez	a1,10c8 <vprintf+0x16c>
        s = va_arg(ap, char*);
    10da:	8b4e                	mv	s6,s3
      state = 0;
    10dc:	4981                	li	s3,0
    10de:	bdf9                	j	fbc <vprintf+0x60>
          s = "(null)";
    10e0:	00000917          	auipc	s2,0x0
    10e4:	37090913          	addi	s2,s2,880 # 1450 <malloc+0x22a>
        while(*s != 0){
    10e8:	02800593          	li	a1,40
    10ec:	bff1                	j	10c8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    10ee:	008b0913          	addi	s2,s6,8
    10f2:	000b4583          	lbu	a1,0(s6)
    10f6:	8556                	mv	a0,s5
    10f8:	00000097          	auipc	ra,0x0
    10fc:	d98080e7          	jalr	-616(ra) # e90 <putc>
    1100:	8b4a                	mv	s6,s2
      state = 0;
    1102:	4981                	li	s3,0
    1104:	bd65                	j	fbc <vprintf+0x60>
        putc(fd, c);
    1106:	85d2                	mv	a1,s4
    1108:	8556                	mv	a0,s5
    110a:	00000097          	auipc	ra,0x0
    110e:	d86080e7          	jalr	-634(ra) # e90 <putc>
      state = 0;
    1112:	4981                	li	s3,0
    1114:	b565                	j	fbc <vprintf+0x60>
        s = va_arg(ap, char*);
    1116:	8b4e                	mv	s6,s3
      state = 0;
    1118:	4981                	li	s3,0
    111a:	b54d                	j	fbc <vprintf+0x60>
    }
  }
}
    111c:	70e6                	ld	ra,120(sp)
    111e:	7446                	ld	s0,112(sp)
    1120:	74a6                	ld	s1,104(sp)
    1122:	7906                	ld	s2,96(sp)
    1124:	69e6                	ld	s3,88(sp)
    1126:	6a46                	ld	s4,80(sp)
    1128:	6aa6                	ld	s5,72(sp)
    112a:	6b06                	ld	s6,64(sp)
    112c:	7be2                	ld	s7,56(sp)
    112e:	7c42                	ld	s8,48(sp)
    1130:	7ca2                	ld	s9,40(sp)
    1132:	7d02                	ld	s10,32(sp)
    1134:	6de2                	ld	s11,24(sp)
    1136:	6109                	addi	sp,sp,128
    1138:	8082                	ret

000000000000113a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    113a:	715d                	addi	sp,sp,-80
    113c:	ec06                	sd	ra,24(sp)
    113e:	e822                	sd	s0,16(sp)
    1140:	1000                	addi	s0,sp,32
    1142:	e010                	sd	a2,0(s0)
    1144:	e414                	sd	a3,8(s0)
    1146:	e818                	sd	a4,16(s0)
    1148:	ec1c                	sd	a5,24(s0)
    114a:	03043023          	sd	a6,32(s0)
    114e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1152:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1156:	8622                	mv	a2,s0
    1158:	00000097          	auipc	ra,0x0
    115c:	e04080e7          	jalr	-508(ra) # f5c <vprintf>
}
    1160:	60e2                	ld	ra,24(sp)
    1162:	6442                	ld	s0,16(sp)
    1164:	6161                	addi	sp,sp,80
    1166:	8082                	ret

0000000000001168 <printf>:

void
printf(const char *fmt, ...)
{
    1168:	711d                	addi	sp,sp,-96
    116a:	ec06                	sd	ra,24(sp)
    116c:	e822                	sd	s0,16(sp)
    116e:	1000                	addi	s0,sp,32
    1170:	e40c                	sd	a1,8(s0)
    1172:	e810                	sd	a2,16(s0)
    1174:	ec14                	sd	a3,24(s0)
    1176:	f018                	sd	a4,32(s0)
    1178:	f41c                	sd	a5,40(s0)
    117a:	03043823          	sd	a6,48(s0)
    117e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1182:	00840613          	addi	a2,s0,8
    1186:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    118a:	85aa                	mv	a1,a0
    118c:	4505                	li	a0,1
    118e:	00000097          	auipc	ra,0x0
    1192:	dce080e7          	jalr	-562(ra) # f5c <vprintf>
}
    1196:	60e2                	ld	ra,24(sp)
    1198:	6442                	ld	s0,16(sp)
    119a:	6125                	addi	sp,sp,96
    119c:	8082                	ret

000000000000119e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    119e:	1141                	addi	sp,sp,-16
    11a0:	e422                	sd	s0,8(sp)
    11a2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11a4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11a8:	00000797          	auipc	a5,0x0
    11ac:	2d87b783          	ld	a5,728(a5) # 1480 <freep>
    11b0:	a805                	j	11e0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11b2:	4618                	lw	a4,8(a2)
    11b4:	9db9                	addw	a1,a1,a4
    11b6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11ba:	6398                	ld	a4,0(a5)
    11bc:	6318                	ld	a4,0(a4)
    11be:	fee53823          	sd	a4,-16(a0)
    11c2:	a091                	j	1206 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11c4:	ff852703          	lw	a4,-8(a0)
    11c8:	9e39                	addw	a2,a2,a4
    11ca:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    11cc:	ff053703          	ld	a4,-16(a0)
    11d0:	e398                	sd	a4,0(a5)
    11d2:	a099                	j	1218 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11d4:	6398                	ld	a4,0(a5)
    11d6:	00e7e463          	bltu	a5,a4,11de <free+0x40>
    11da:	00e6ea63          	bltu	a3,a4,11ee <free+0x50>
{
    11de:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11e0:	fed7fae3          	bgeu	a5,a3,11d4 <free+0x36>
    11e4:	6398                	ld	a4,0(a5)
    11e6:	00e6e463          	bltu	a3,a4,11ee <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11ea:	fee7eae3          	bltu	a5,a4,11de <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    11ee:	ff852583          	lw	a1,-8(a0)
    11f2:	6390                	ld	a2,0(a5)
    11f4:	02059713          	slli	a4,a1,0x20
    11f8:	9301                	srli	a4,a4,0x20
    11fa:	0712                	slli	a4,a4,0x4
    11fc:	9736                	add	a4,a4,a3
    11fe:	fae60ae3          	beq	a2,a4,11b2 <free+0x14>
    bp->s.ptr = p->s.ptr;
    1202:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1206:	4790                	lw	a2,8(a5)
    1208:	02061713          	slli	a4,a2,0x20
    120c:	9301                	srli	a4,a4,0x20
    120e:	0712                	slli	a4,a4,0x4
    1210:	973e                	add	a4,a4,a5
    1212:	fae689e3          	beq	a3,a4,11c4 <free+0x26>
  } else
    p->s.ptr = bp;
    1216:	e394                	sd	a3,0(a5)
  freep = p;
    1218:	00000717          	auipc	a4,0x0
    121c:	26f73423          	sd	a5,616(a4) # 1480 <freep>
}
    1220:	6422                	ld	s0,8(sp)
    1222:	0141                	addi	sp,sp,16
    1224:	8082                	ret

0000000000001226 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1226:	7139                	addi	sp,sp,-64
    1228:	fc06                	sd	ra,56(sp)
    122a:	f822                	sd	s0,48(sp)
    122c:	f426                	sd	s1,40(sp)
    122e:	f04a                	sd	s2,32(sp)
    1230:	ec4e                	sd	s3,24(sp)
    1232:	e852                	sd	s4,16(sp)
    1234:	e456                	sd	s5,8(sp)
    1236:	e05a                	sd	s6,0(sp)
    1238:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    123a:	02051493          	slli	s1,a0,0x20
    123e:	9081                	srli	s1,s1,0x20
    1240:	04bd                	addi	s1,s1,15
    1242:	8091                	srli	s1,s1,0x4
    1244:	0014899b          	addiw	s3,s1,1
    1248:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    124a:	00000517          	auipc	a0,0x0
    124e:	23653503          	ld	a0,566(a0) # 1480 <freep>
    1252:	c515                	beqz	a0,127e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1254:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1256:	4798                	lw	a4,8(a5)
    1258:	02977f63          	bgeu	a4,s1,1296 <malloc+0x70>
    125c:	8a4e                	mv	s4,s3
    125e:	0009871b          	sext.w	a4,s3
    1262:	6685                	lui	a3,0x1
    1264:	00d77363          	bgeu	a4,a3,126a <malloc+0x44>
    1268:	6a05                	lui	s4,0x1
    126a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    126e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1272:	00000917          	auipc	s2,0x0
    1276:	20e90913          	addi	s2,s2,526 # 1480 <freep>
  if(p == (char*)-1)
    127a:	5afd                	li	s5,-1
    127c:	a88d                	j	12ee <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    127e:	00000797          	auipc	a5,0x0
    1282:	27278793          	addi	a5,a5,626 # 14f0 <base>
    1286:	00000717          	auipc	a4,0x0
    128a:	1ef73d23          	sd	a5,506(a4) # 1480 <freep>
    128e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1290:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1294:	b7e1                	j	125c <malloc+0x36>
      if(p->s.size == nunits)
    1296:	02e48b63          	beq	s1,a4,12cc <malloc+0xa6>
        p->s.size -= nunits;
    129a:	4137073b          	subw	a4,a4,s3
    129e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    12a0:	1702                	slli	a4,a4,0x20
    12a2:	9301                	srli	a4,a4,0x20
    12a4:	0712                	slli	a4,a4,0x4
    12a6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    12a8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    12ac:	00000717          	auipc	a4,0x0
    12b0:	1ca73a23          	sd	a0,468(a4) # 1480 <freep>
      return (void*)(p + 1);
    12b4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    12b8:	70e2                	ld	ra,56(sp)
    12ba:	7442                	ld	s0,48(sp)
    12bc:	74a2                	ld	s1,40(sp)
    12be:	7902                	ld	s2,32(sp)
    12c0:	69e2                	ld	s3,24(sp)
    12c2:	6a42                	ld	s4,16(sp)
    12c4:	6aa2                	ld	s5,8(sp)
    12c6:	6b02                	ld	s6,0(sp)
    12c8:	6121                	addi	sp,sp,64
    12ca:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    12cc:	6398                	ld	a4,0(a5)
    12ce:	e118                	sd	a4,0(a0)
    12d0:	bff1                	j	12ac <malloc+0x86>
  hp->s.size = nu;
    12d2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12d6:	0541                	addi	a0,a0,16
    12d8:	00000097          	auipc	ra,0x0
    12dc:	ec6080e7          	jalr	-314(ra) # 119e <free>
  return freep;
    12e0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    12e4:	d971                	beqz	a0,12b8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12e8:	4798                	lw	a4,8(a5)
    12ea:	fa9776e3          	bgeu	a4,s1,1296 <malloc+0x70>
    if(p == freep)
    12ee:	00093703          	ld	a4,0(s2)
    12f2:	853e                	mv	a0,a5
    12f4:	fef719e3          	bne	a4,a5,12e6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    12f8:	8552                	mv	a0,s4
    12fa:	00000097          	auipc	ra,0x0
    12fe:	b6e080e7          	jalr	-1170(ra) # e68 <sbrk>
  if(p == (char*)-1)
    1302:	fd5518e3          	bne	a0,s5,12d2 <malloc+0xac>
        return 0;
    1306:	4501                	li	a0,0
    1308:	bf45                	j	12b8 <malloc+0x92>
