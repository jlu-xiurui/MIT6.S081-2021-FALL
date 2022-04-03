
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	83010113          	addi	sp,sp,-2000 # 80009830 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	070000ef          	jal	ra,80000086 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f4737          	lui	a4,0xf4
    8000003c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &mscratch0[32 * id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	00009617          	auipc	a2,0x9
    8000004e:	fe660613          	addi	a2,a2,-26 # 80009030 <mscratch0>
    80000052:	97b2                	add	a5,a5,a2
  scratch[4] = CLINT_MTIMECMP(id);
    80000054:	f394                	sd	a3,32(a5)
  scratch[5] = interval;
    80000056:	f798                	sd	a4,40(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000058:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000005c:	00006797          	auipc	a5,0x6
    80000060:	e8478793          	addi	a5,a5,-380 # 80005ee0 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000070:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000074:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000078:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000007c:	30479073          	csrw	mie,a5
}
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	addi	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
{
    80000086:	1141                	addi	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000008e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87ff>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	e1878793          	addi	a5,a5,-488 # 80000ebe <main>
    800000ae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	addi	a5,a5,-1
    800000bc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000c4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000c8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000cc:	10479073          	csrw	sie,a5
  timerinit();
    800000d0:	00000097          	auipc	ra,0x0
    800000d4:	f4c080e7          	jalr	-180(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000d8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000dc:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000de:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e0:	30200073          	mret
}
    800000e4:	60a2                	ld	ra,8(sp)
    800000e6:	6402                	ld	s0,0(sp)
    800000e8:	0141                	addi	sp,sp,16
    800000ea:	8082                	ret

00000000800000ec <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000ec:	715d                	addi	sp,sp,-80
    800000ee:	e486                	sd	ra,72(sp)
    800000f0:	e0a2                	sd	s0,64(sp)
    800000f2:	fc26                	sd	s1,56(sp)
    800000f4:	f84a                	sd	s2,48(sp)
    800000f6:	f44e                	sd	s3,40(sp)
    800000f8:	f052                	sd	s4,32(sp)
    800000fa:	ec56                	sd	s5,24(sp)
    800000fc:	0880                	addi	s0,sp,80
    800000fe:	8a2a                	mv	s4,a0
    80000100:	84ae                	mv	s1,a1
    80000102:	89b2                	mv	s3,a2
  int i;

  acquire(&cons.lock);
    80000104:	00011517          	auipc	a0,0x11
    80000108:	72c50513          	addi	a0,a0,1836 # 80011830 <cons>
    8000010c:	00001097          	auipc	ra,0x1
    80000110:	b04080e7          	jalr	-1276(ra) # 80000c10 <acquire>
  for(i = 0; i < n; i++){
    80000114:	05305b63          	blez	s3,8000016a <consolewrite+0x7e>
    80000118:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011a:	5afd                	li	s5,-1
    8000011c:	4685                	li	a3,1
    8000011e:	8626                	mv	a2,s1
    80000120:	85d2                	mv	a1,s4
    80000122:	fbf40513          	addi	a0,s0,-65
    80000126:	00002097          	auipc	ra,0x2
    8000012a:	454080e7          	jalr	1108(ra) # 8000257a <either_copyin>
    8000012e:	01550c63          	beq	a0,s5,80000146 <consolewrite+0x5a>
      break;
    uartputc(c);
    80000132:	fbf44503          	lbu	a0,-65(s0)
    80000136:	00000097          	auipc	ra,0x0
    8000013a:	7aa080e7          	jalr	1962(ra) # 800008e0 <uartputc>
  for(i = 0; i < n; i++){
    8000013e:	2905                	addiw	s2,s2,1
    80000140:	0485                	addi	s1,s1,1
    80000142:	fd299de3          	bne	s3,s2,8000011c <consolewrite+0x30>
  }
  release(&cons.lock);
    80000146:	00011517          	auipc	a0,0x11
    8000014a:	6ea50513          	addi	a0,a0,1770 # 80011830 <cons>
    8000014e:	00001097          	auipc	ra,0x1
    80000152:	b76080e7          	jalr	-1162(ra) # 80000cc4 <release>

  return i;
}
    80000156:	854a                	mv	a0,s2
    80000158:	60a6                	ld	ra,72(sp)
    8000015a:	6406                	ld	s0,64(sp)
    8000015c:	74e2                	ld	s1,56(sp)
    8000015e:	7942                	ld	s2,48(sp)
    80000160:	79a2                	ld	s3,40(sp)
    80000162:	7a02                	ld	s4,32(sp)
    80000164:	6ae2                	ld	s5,24(sp)
    80000166:	6161                	addi	sp,sp,80
    80000168:	8082                	ret
  for(i = 0; i < n; i++){
    8000016a:	4901                	li	s2,0
    8000016c:	bfe9                	j	80000146 <consolewrite+0x5a>

000000008000016e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	7119                	addi	sp,sp,-128
    80000170:	fc86                	sd	ra,120(sp)
    80000172:	f8a2                	sd	s0,112(sp)
    80000174:	f4a6                	sd	s1,104(sp)
    80000176:	f0ca                	sd	s2,96(sp)
    80000178:	ecce                	sd	s3,88(sp)
    8000017a:	e8d2                	sd	s4,80(sp)
    8000017c:	e4d6                	sd	s5,72(sp)
    8000017e:	e0da                	sd	s6,64(sp)
    80000180:	fc5e                	sd	s7,56(sp)
    80000182:	f862                	sd	s8,48(sp)
    80000184:	f466                	sd	s9,40(sp)
    80000186:	f06a                	sd	s10,32(sp)
    80000188:	ec6e                	sd	s11,24(sp)
    8000018a:	0100                	addi	s0,sp,128
    8000018c:	8b2a                	mv	s6,a0
    8000018e:	8aae                	mv	s5,a1
    80000190:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000192:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80000196:	00011517          	auipc	a0,0x11
    8000019a:	69a50513          	addi	a0,a0,1690 # 80011830 <cons>
    8000019e:	00001097          	auipc	ra,0x1
    800001a2:	a72080e7          	jalr	-1422(ra) # 80000c10 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001a6:	00011497          	auipc	s1,0x11
    800001aa:	68a48493          	addi	s1,s1,1674 # 80011830 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001ae:	89a6                	mv	s3,s1
    800001b0:	00011917          	auipc	s2,0x11
    800001b4:	71890913          	addi	s2,s2,1816 # 800118c8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800001b8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ba:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001bc:	4da9                	li	s11,10
  while(n > 0){
    800001be:	07405863          	blez	s4,8000022e <consoleread+0xc0>
    while(cons.r == cons.w){
    800001c2:	0984a783          	lw	a5,152(s1)
    800001c6:	09c4a703          	lw	a4,156(s1)
    800001ca:	02f71463          	bne	a4,a5,800001f2 <consoleread+0x84>
      if(myproc()->killed){
    800001ce:	00002097          	auipc	ra,0x2
    800001d2:	8bc080e7          	jalr	-1860(ra) # 80001a8a <myproc>
    800001d6:	591c                	lw	a5,48(a0)
    800001d8:	e7b5                	bnez	a5,80000244 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800001da:	85ce                	mv	a1,s3
    800001dc:	854a                	mv	a0,s2
    800001de:	00002097          	auipc	ra,0x2
    800001e2:	0e4080e7          	jalr	228(ra) # 800022c2 <sleep>
    while(cons.r == cons.w){
    800001e6:	0984a783          	lw	a5,152(s1)
    800001ea:	09c4a703          	lw	a4,156(s1)
    800001ee:	fef700e3          	beq	a4,a5,800001ce <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001f2:	0017871b          	addiw	a4,a5,1
    800001f6:	08e4ac23          	sw	a4,152(s1)
    800001fa:	07f7f713          	andi	a4,a5,127
    800001fe:	9726                	add	a4,a4,s1
    80000200:	01874703          	lbu	a4,24(a4)
    80000204:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80000208:	079c0663          	beq	s8,s9,80000274 <consoleread+0x106>
    cbuf = c;
    8000020c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000210:	4685                	li	a3,1
    80000212:	f8f40613          	addi	a2,s0,-113
    80000216:	85d6                	mv	a1,s5
    80000218:	855a                	mv	a0,s6
    8000021a:	00002097          	auipc	ra,0x2
    8000021e:	30a080e7          	jalr	778(ra) # 80002524 <either_copyout>
    80000222:	01a50663          	beq	a0,s10,8000022e <consoleread+0xc0>
    dst++;
    80000226:	0a85                	addi	s5,s5,1
    --n;
    80000228:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000022a:	f9bc1ae3          	bne	s8,s11,800001be <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000022e:	00011517          	auipc	a0,0x11
    80000232:	60250513          	addi	a0,a0,1538 # 80011830 <cons>
    80000236:	00001097          	auipc	ra,0x1
    8000023a:	a8e080e7          	jalr	-1394(ra) # 80000cc4 <release>

  return target - n;
    8000023e:	414b853b          	subw	a0,s7,s4
    80000242:	a811                	j	80000256 <consoleread+0xe8>
        release(&cons.lock);
    80000244:	00011517          	auipc	a0,0x11
    80000248:	5ec50513          	addi	a0,a0,1516 # 80011830 <cons>
    8000024c:	00001097          	auipc	ra,0x1
    80000250:	a78080e7          	jalr	-1416(ra) # 80000cc4 <release>
        return -1;
    80000254:	557d                	li	a0,-1
}
    80000256:	70e6                	ld	ra,120(sp)
    80000258:	7446                	ld	s0,112(sp)
    8000025a:	74a6                	ld	s1,104(sp)
    8000025c:	7906                	ld	s2,96(sp)
    8000025e:	69e6                	ld	s3,88(sp)
    80000260:	6a46                	ld	s4,80(sp)
    80000262:	6aa6                	ld	s5,72(sp)
    80000264:	6b06                	ld	s6,64(sp)
    80000266:	7be2                	ld	s7,56(sp)
    80000268:	7c42                	ld	s8,48(sp)
    8000026a:	7ca2                	ld	s9,40(sp)
    8000026c:	7d02                	ld	s10,32(sp)
    8000026e:	6de2                	ld	s11,24(sp)
    80000270:	6109                	addi	sp,sp,128
    80000272:	8082                	ret
      if(n < target){
    80000274:	000a071b          	sext.w	a4,s4
    80000278:	fb777be3          	bgeu	a4,s7,8000022e <consoleread+0xc0>
        cons.r--;
    8000027c:	00011717          	auipc	a4,0x11
    80000280:	64f72623          	sw	a5,1612(a4) # 800118c8 <cons+0x98>
    80000284:	b76d                	j	8000022e <consoleread+0xc0>

0000000080000286 <consputc>:
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e406                	sd	ra,8(sp)
    8000028a:	e022                	sd	s0,0(sp)
    8000028c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000028e:	10000793          	li	a5,256
    80000292:	00f50a63          	beq	a0,a5,800002a6 <consputc+0x20>
    uartputc_sync(c);
    80000296:	00000097          	auipc	ra,0x0
    8000029a:	564080e7          	jalr	1380(ra) # 800007fa <uartputc_sync>
}
    8000029e:	60a2                	ld	ra,8(sp)
    800002a0:	6402                	ld	s0,0(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002a6:	4521                	li	a0,8
    800002a8:	00000097          	auipc	ra,0x0
    800002ac:	552080e7          	jalr	1362(ra) # 800007fa <uartputc_sync>
    800002b0:	02000513          	li	a0,32
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	546080e7          	jalr	1350(ra) # 800007fa <uartputc_sync>
    800002bc:	4521                	li	a0,8
    800002be:	00000097          	auipc	ra,0x0
    800002c2:	53c080e7          	jalr	1340(ra) # 800007fa <uartputc_sync>
    800002c6:	bfe1                	j	8000029e <consputc+0x18>

00000000800002c8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002c8:	1101                	addi	sp,sp,-32
    800002ca:	ec06                	sd	ra,24(sp)
    800002cc:	e822                	sd	s0,16(sp)
    800002ce:	e426                	sd	s1,8(sp)
    800002d0:	e04a                	sd	s2,0(sp)
    800002d2:	1000                	addi	s0,sp,32
    800002d4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002d6:	00011517          	auipc	a0,0x11
    800002da:	55a50513          	addi	a0,a0,1370 # 80011830 <cons>
    800002de:	00001097          	auipc	ra,0x1
    800002e2:	932080e7          	jalr	-1742(ra) # 80000c10 <acquire>

  switch(c){
    800002e6:	47d5                	li	a5,21
    800002e8:	0af48663          	beq	s1,a5,80000394 <consoleintr+0xcc>
    800002ec:	0297ca63          	blt	a5,s1,80000320 <consoleintr+0x58>
    800002f0:	47a1                	li	a5,8
    800002f2:	0ef48763          	beq	s1,a5,800003e0 <consoleintr+0x118>
    800002f6:	47c1                	li	a5,16
    800002f8:	10f49a63          	bne	s1,a5,8000040c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002fc:	00002097          	auipc	ra,0x2
    80000300:	2d4080e7          	jalr	724(ra) # 800025d0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000304:	00011517          	auipc	a0,0x11
    80000308:	52c50513          	addi	a0,a0,1324 # 80011830 <cons>
    8000030c:	00001097          	auipc	ra,0x1
    80000310:	9b8080e7          	jalr	-1608(ra) # 80000cc4 <release>
}
    80000314:	60e2                	ld	ra,24(sp)
    80000316:	6442                	ld	s0,16(sp)
    80000318:	64a2                	ld	s1,8(sp)
    8000031a:	6902                	ld	s2,0(sp)
    8000031c:	6105                	addi	sp,sp,32
    8000031e:	8082                	ret
  switch(c){
    80000320:	07f00793          	li	a5,127
    80000324:	0af48e63          	beq	s1,a5,800003e0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000328:	00011717          	auipc	a4,0x11
    8000032c:	50870713          	addi	a4,a4,1288 # 80011830 <cons>
    80000330:	0a072783          	lw	a5,160(a4)
    80000334:	09872703          	lw	a4,152(a4)
    80000338:	9f99                	subw	a5,a5,a4
    8000033a:	07f00713          	li	a4,127
    8000033e:	fcf763e3          	bltu	a4,a5,80000304 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000342:	47b5                	li	a5,13
    80000344:	0cf48763          	beq	s1,a5,80000412 <consoleintr+0x14a>
      consputc(c);
    80000348:	8526                	mv	a0,s1
    8000034a:	00000097          	auipc	ra,0x0
    8000034e:	f3c080e7          	jalr	-196(ra) # 80000286 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000352:	00011797          	auipc	a5,0x11
    80000356:	4de78793          	addi	a5,a5,1246 # 80011830 <cons>
    8000035a:	0a07a703          	lw	a4,160(a5)
    8000035e:	0017069b          	addiw	a3,a4,1
    80000362:	0006861b          	sext.w	a2,a3
    80000366:	0ad7a023          	sw	a3,160(a5)
    8000036a:	07f77713          	andi	a4,a4,127
    8000036e:	97ba                	add	a5,a5,a4
    80000370:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000374:	47a9                	li	a5,10
    80000376:	0cf48563          	beq	s1,a5,80000440 <consoleintr+0x178>
    8000037a:	4791                	li	a5,4
    8000037c:	0cf48263          	beq	s1,a5,80000440 <consoleintr+0x178>
    80000380:	00011797          	auipc	a5,0x11
    80000384:	5487a783          	lw	a5,1352(a5) # 800118c8 <cons+0x98>
    80000388:	0807879b          	addiw	a5,a5,128
    8000038c:	f6f61ce3          	bne	a2,a5,80000304 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000390:	863e                	mv	a2,a5
    80000392:	a07d                	j	80000440 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000394:	00011717          	auipc	a4,0x11
    80000398:	49c70713          	addi	a4,a4,1180 # 80011830 <cons>
    8000039c:	0a072783          	lw	a5,160(a4)
    800003a0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003a4:	00011497          	auipc	s1,0x11
    800003a8:	48c48493          	addi	s1,s1,1164 # 80011830 <cons>
    while(cons.e != cons.w &&
    800003ac:	4929                	li	s2,10
    800003ae:	f4f70be3          	beq	a4,a5,80000304 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003b2:	37fd                	addiw	a5,a5,-1
    800003b4:	07f7f713          	andi	a4,a5,127
    800003b8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003ba:	01874703          	lbu	a4,24(a4)
    800003be:	f52703e3          	beq	a4,s2,80000304 <consoleintr+0x3c>
      cons.e--;
    800003c2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003c6:	10000513          	li	a0,256
    800003ca:	00000097          	auipc	ra,0x0
    800003ce:	ebc080e7          	jalr	-324(ra) # 80000286 <consputc>
    while(cons.e != cons.w &&
    800003d2:	0a04a783          	lw	a5,160(s1)
    800003d6:	09c4a703          	lw	a4,156(s1)
    800003da:	fcf71ce3          	bne	a4,a5,800003b2 <consoleintr+0xea>
    800003de:	b71d                	j	80000304 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003e0:	00011717          	auipc	a4,0x11
    800003e4:	45070713          	addi	a4,a4,1104 # 80011830 <cons>
    800003e8:	0a072783          	lw	a5,160(a4)
    800003ec:	09c72703          	lw	a4,156(a4)
    800003f0:	f0f70ae3          	beq	a4,a5,80000304 <consoleintr+0x3c>
      cons.e--;
    800003f4:	37fd                	addiw	a5,a5,-1
    800003f6:	00011717          	auipc	a4,0x11
    800003fa:	4cf72d23          	sw	a5,1242(a4) # 800118d0 <cons+0xa0>
      consputc(BACKSPACE);
    800003fe:	10000513          	li	a0,256
    80000402:	00000097          	auipc	ra,0x0
    80000406:	e84080e7          	jalr	-380(ra) # 80000286 <consputc>
    8000040a:	bded                	j	80000304 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000040c:	ee048ce3          	beqz	s1,80000304 <consoleintr+0x3c>
    80000410:	bf21                	j	80000328 <consoleintr+0x60>
      consputc(c);
    80000412:	4529                	li	a0,10
    80000414:	00000097          	auipc	ra,0x0
    80000418:	e72080e7          	jalr	-398(ra) # 80000286 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000041c:	00011797          	auipc	a5,0x11
    80000420:	41478793          	addi	a5,a5,1044 # 80011830 <cons>
    80000424:	0a07a703          	lw	a4,160(a5)
    80000428:	0017069b          	addiw	a3,a4,1
    8000042c:	0006861b          	sext.w	a2,a3
    80000430:	0ad7a023          	sw	a3,160(a5)
    80000434:	07f77713          	andi	a4,a4,127
    80000438:	97ba                	add	a5,a5,a4
    8000043a:	4729                	li	a4,10
    8000043c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000440:	00011797          	auipc	a5,0x11
    80000444:	48c7a623          	sw	a2,1164(a5) # 800118cc <cons+0x9c>
        wakeup(&cons.r);
    80000448:	00011517          	auipc	a0,0x11
    8000044c:	48050513          	addi	a0,a0,1152 # 800118c8 <cons+0x98>
    80000450:	00002097          	auipc	ra,0x2
    80000454:	ff8080e7          	jalr	-8(ra) # 80002448 <wakeup>
    80000458:	b575                	j	80000304 <consoleintr+0x3c>

000000008000045a <consoleinit>:

void
consoleinit(void)
{
    8000045a:	1141                	addi	sp,sp,-16
    8000045c:	e406                	sd	ra,8(sp)
    8000045e:	e022                	sd	s0,0(sp)
    80000460:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000462:	00008597          	auipc	a1,0x8
    80000466:	bae58593          	addi	a1,a1,-1106 # 80008010 <etext+0x10>
    8000046a:	00011517          	auipc	a0,0x11
    8000046e:	3c650513          	addi	a0,a0,966 # 80011830 <cons>
    80000472:	00000097          	auipc	ra,0x0
    80000476:	70e080e7          	jalr	1806(ra) # 80000b80 <initlock>

  uartinit();
    8000047a:	00000097          	auipc	ra,0x0
    8000047e:	330080e7          	jalr	816(ra) # 800007aa <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000482:	00022797          	auipc	a5,0x22
    80000486:	92e78793          	addi	a5,a5,-1746 # 80021db0 <devsw>
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	ce470713          	addi	a4,a4,-796 # 8000016e <consoleread>
    80000492:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000494:	00000717          	auipc	a4,0x0
    80000498:	c5870713          	addi	a4,a4,-936 # 800000ec <consolewrite>
    8000049c:	ef98                	sd	a4,24(a5)
}
    8000049e:	60a2                	ld	ra,8(sp)
    800004a0:	6402                	ld	s0,0(sp)
    800004a2:	0141                	addi	sp,sp,16
    800004a4:	8082                	ret

00000000800004a6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004a6:	7179                	addi	sp,sp,-48
    800004a8:	f406                	sd	ra,40(sp)
    800004aa:	f022                	sd	s0,32(sp)
    800004ac:	ec26                	sd	s1,24(sp)
    800004ae:	e84a                	sd	s2,16(sp)
    800004b0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004b2:	c219                	beqz	a2,800004b8 <printint+0x12>
    800004b4:	08054663          	bltz	a0,80000540 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004b8:	2501                	sext.w	a0,a0
    800004ba:	4881                	li	a7,0
    800004bc:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004c0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004c2:	2581                	sext.w	a1,a1
    800004c4:	00008617          	auipc	a2,0x8
    800004c8:	b7c60613          	addi	a2,a2,-1156 # 80008040 <digits>
    800004cc:	883a                	mv	a6,a4
    800004ce:	2705                	addiw	a4,a4,1
    800004d0:	02b577bb          	remuw	a5,a0,a1
    800004d4:	1782                	slli	a5,a5,0x20
    800004d6:	9381                	srli	a5,a5,0x20
    800004d8:	97b2                	add	a5,a5,a2
    800004da:	0007c783          	lbu	a5,0(a5)
    800004de:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004e2:	0005079b          	sext.w	a5,a0
    800004e6:	02b5553b          	divuw	a0,a0,a1
    800004ea:	0685                	addi	a3,a3,1
    800004ec:	feb7f0e3          	bgeu	a5,a1,800004cc <printint+0x26>

  if(sign)
    800004f0:	00088b63          	beqz	a7,80000506 <printint+0x60>
    buf[i++] = '-';
    800004f4:	fe040793          	addi	a5,s0,-32
    800004f8:	973e                	add	a4,a4,a5
    800004fa:	02d00793          	li	a5,45
    800004fe:	fef70823          	sb	a5,-16(a4)
    80000502:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80000506:	02e05763          	blez	a4,80000534 <printint+0x8e>
    8000050a:	fd040793          	addi	a5,s0,-48
    8000050e:	00e784b3          	add	s1,a5,a4
    80000512:	fff78913          	addi	s2,a5,-1
    80000516:	993a                	add	s2,s2,a4
    80000518:	377d                	addiw	a4,a4,-1
    8000051a:	1702                	slli	a4,a4,0x20
    8000051c:	9301                	srli	a4,a4,0x20
    8000051e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000522:	fff4c503          	lbu	a0,-1(s1)
    80000526:	00000097          	auipc	ra,0x0
    8000052a:	d60080e7          	jalr	-672(ra) # 80000286 <consputc>
  while(--i >= 0)
    8000052e:	14fd                	addi	s1,s1,-1
    80000530:	ff2499e3          	bne	s1,s2,80000522 <printint+0x7c>
}
    80000534:	70a2                	ld	ra,40(sp)
    80000536:	7402                	ld	s0,32(sp)
    80000538:	64e2                	ld	s1,24(sp)
    8000053a:	6942                	ld	s2,16(sp)
    8000053c:	6145                	addi	sp,sp,48
    8000053e:	8082                	ret
    x = -xx;
    80000540:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000544:	4885                	li	a7,1
    x = -xx;
    80000546:	bf9d                	j	800004bc <printint+0x16>

0000000080000548 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000548:	1101                	addi	sp,sp,-32
    8000054a:	ec06                	sd	ra,24(sp)
    8000054c:	e822                	sd	s0,16(sp)
    8000054e:	e426                	sd	s1,8(sp)
    80000550:	1000                	addi	s0,sp,32
    80000552:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000554:	00011797          	auipc	a5,0x11
    80000558:	3807ae23          	sw	zero,924(a5) # 800118f0 <pr+0x18>
  printf("panic: ");
    8000055c:	00008517          	auipc	a0,0x8
    80000560:	abc50513          	addi	a0,a0,-1348 # 80008018 <etext+0x18>
    80000564:	00000097          	auipc	ra,0x0
    80000568:	02e080e7          	jalr	46(ra) # 80000592 <printf>
  printf(s);
    8000056c:	8526                	mv	a0,s1
    8000056e:	00000097          	auipc	ra,0x0
    80000572:	024080e7          	jalr	36(ra) # 80000592 <printf>
  printf("\n");
    80000576:	00008517          	auipc	a0,0x8
    8000057a:	b5250513          	addi	a0,a0,-1198 # 800080c8 <digits+0x88>
    8000057e:	00000097          	auipc	ra,0x0
    80000582:	014080e7          	jalr	20(ra) # 80000592 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000586:	4785                	li	a5,1
    80000588:	00009717          	auipc	a4,0x9
    8000058c:	a6f72c23          	sw	a5,-1416(a4) # 80009000 <panicked>
  for(;;)
    80000590:	a001                	j	80000590 <panic+0x48>

0000000080000592 <printf>:
{
    80000592:	7131                	addi	sp,sp,-192
    80000594:	fc86                	sd	ra,120(sp)
    80000596:	f8a2                	sd	s0,112(sp)
    80000598:	f4a6                	sd	s1,104(sp)
    8000059a:	f0ca                	sd	s2,96(sp)
    8000059c:	ecce                	sd	s3,88(sp)
    8000059e:	e8d2                	sd	s4,80(sp)
    800005a0:	e4d6                	sd	s5,72(sp)
    800005a2:	e0da                	sd	s6,64(sp)
    800005a4:	fc5e                	sd	s7,56(sp)
    800005a6:	f862                	sd	s8,48(sp)
    800005a8:	f466                	sd	s9,40(sp)
    800005aa:	f06a                	sd	s10,32(sp)
    800005ac:	ec6e                	sd	s11,24(sp)
    800005ae:	0100                	addi	s0,sp,128
    800005b0:	8a2a                	mv	s4,a0
    800005b2:	e40c                	sd	a1,8(s0)
    800005b4:	e810                	sd	a2,16(s0)
    800005b6:	ec14                	sd	a3,24(s0)
    800005b8:	f018                	sd	a4,32(s0)
    800005ba:	f41c                	sd	a5,40(s0)
    800005bc:	03043823          	sd	a6,48(s0)
    800005c0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005c4:	00011d97          	auipc	s11,0x11
    800005c8:	32cdad83          	lw	s11,812(s11) # 800118f0 <pr+0x18>
  if(locking)
    800005cc:	020d9b63          	bnez	s11,80000602 <printf+0x70>
  if (fmt == 0)
    800005d0:	040a0263          	beqz	s4,80000614 <printf+0x82>
  va_start(ap, fmt);
    800005d4:	00840793          	addi	a5,s0,8
    800005d8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005dc:	000a4503          	lbu	a0,0(s4)
    800005e0:	16050263          	beqz	a0,80000744 <printf+0x1b2>
    800005e4:	4481                	li	s1,0
    if(c != '%'){
    800005e6:	02500a93          	li	s5,37
    switch(c){
    800005ea:	07000b13          	li	s6,112
  consputc('x');
    800005ee:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005f0:	00008b97          	auipc	s7,0x8
    800005f4:	a50b8b93          	addi	s7,s7,-1456 # 80008040 <digits>
    switch(c){
    800005f8:	07300c93          	li	s9,115
    800005fc:	06400c13          	li	s8,100
    80000600:	a82d                	j	8000063a <printf+0xa8>
    acquire(&pr.lock);
    80000602:	00011517          	auipc	a0,0x11
    80000606:	2d650513          	addi	a0,a0,726 # 800118d8 <pr>
    8000060a:	00000097          	auipc	ra,0x0
    8000060e:	606080e7          	jalr	1542(ra) # 80000c10 <acquire>
    80000612:	bf7d                	j	800005d0 <printf+0x3e>
    panic("null fmt");
    80000614:	00008517          	auipc	a0,0x8
    80000618:	a1450513          	addi	a0,a0,-1516 # 80008028 <etext+0x28>
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	f2c080e7          	jalr	-212(ra) # 80000548 <panic>
      consputc(c);
    80000624:	00000097          	auipc	ra,0x0
    80000628:	c62080e7          	jalr	-926(ra) # 80000286 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000062c:	2485                	addiw	s1,s1,1
    8000062e:	009a07b3          	add	a5,s4,s1
    80000632:	0007c503          	lbu	a0,0(a5)
    80000636:	10050763          	beqz	a0,80000744 <printf+0x1b2>
    if(c != '%'){
    8000063a:	ff5515e3          	bne	a0,s5,80000624 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000063e:	2485                	addiw	s1,s1,1
    80000640:	009a07b3          	add	a5,s4,s1
    80000644:	0007c783          	lbu	a5,0(a5)
    80000648:	0007891b          	sext.w	s2,a5
    if(c == 0)
    8000064c:	cfe5                	beqz	a5,80000744 <printf+0x1b2>
    switch(c){
    8000064e:	05678a63          	beq	a5,s6,800006a2 <printf+0x110>
    80000652:	02fb7663          	bgeu	s6,a5,8000067e <printf+0xec>
    80000656:	09978963          	beq	a5,s9,800006e8 <printf+0x156>
    8000065a:	07800713          	li	a4,120
    8000065e:	0ce79863          	bne	a5,a4,8000072e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80000662:	f8843783          	ld	a5,-120(s0)
    80000666:	00878713          	addi	a4,a5,8
    8000066a:	f8e43423          	sd	a4,-120(s0)
    8000066e:	4605                	li	a2,1
    80000670:	85ea                	mv	a1,s10
    80000672:	4388                	lw	a0,0(a5)
    80000674:	00000097          	auipc	ra,0x0
    80000678:	e32080e7          	jalr	-462(ra) # 800004a6 <printint>
      break;
    8000067c:	bf45                	j	8000062c <printf+0x9a>
    switch(c){
    8000067e:	0b578263          	beq	a5,s5,80000722 <printf+0x190>
    80000682:	0b879663          	bne	a5,s8,8000072e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80000686:	f8843783          	ld	a5,-120(s0)
    8000068a:	00878713          	addi	a4,a5,8
    8000068e:	f8e43423          	sd	a4,-120(s0)
    80000692:	4605                	li	a2,1
    80000694:	45a9                	li	a1,10
    80000696:	4388                	lw	a0,0(a5)
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	e0e080e7          	jalr	-498(ra) # 800004a6 <printint>
      break;
    800006a0:	b771                	j	8000062c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	addi	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006b2:	03000513          	li	a0,48
    800006b6:	00000097          	auipc	ra,0x0
    800006ba:	bd0080e7          	jalr	-1072(ra) # 80000286 <consputc>
  consputc('x');
    800006be:	07800513          	li	a0,120
    800006c2:	00000097          	auipc	ra,0x0
    800006c6:	bc4080e7          	jalr	-1084(ra) # 80000286 <consputc>
    800006ca:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006cc:	03c9d793          	srli	a5,s3,0x3c
    800006d0:	97de                	add	a5,a5,s7
    800006d2:	0007c503          	lbu	a0,0(a5)
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	bb0080e7          	jalr	-1104(ra) # 80000286 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006de:	0992                	slli	s3,s3,0x4
    800006e0:	397d                	addiw	s2,s2,-1
    800006e2:	fe0915e3          	bnez	s2,800006cc <printf+0x13a>
    800006e6:	b799                	j	8000062c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006e8:	f8843783          	ld	a5,-120(s0)
    800006ec:	00878713          	addi	a4,a5,8
    800006f0:	f8e43423          	sd	a4,-120(s0)
    800006f4:	0007b903          	ld	s2,0(a5)
    800006f8:	00090e63          	beqz	s2,80000714 <printf+0x182>
      for(; *s; s++)
    800006fc:	00094503          	lbu	a0,0(s2)
    80000700:	d515                	beqz	a0,8000062c <printf+0x9a>
        consputc(*s);
    80000702:	00000097          	auipc	ra,0x0
    80000706:	b84080e7          	jalr	-1148(ra) # 80000286 <consputc>
      for(; *s; s++)
    8000070a:	0905                	addi	s2,s2,1
    8000070c:	00094503          	lbu	a0,0(s2)
    80000710:	f96d                	bnez	a0,80000702 <printf+0x170>
    80000712:	bf29                	j	8000062c <printf+0x9a>
        s = "(null)";
    80000714:	00008917          	auipc	s2,0x8
    80000718:	90c90913          	addi	s2,s2,-1780 # 80008020 <etext+0x20>
      for(; *s; s++)
    8000071c:	02800513          	li	a0,40
    80000720:	b7cd                	j	80000702 <printf+0x170>
      consputc('%');
    80000722:	8556                	mv	a0,s5
    80000724:	00000097          	auipc	ra,0x0
    80000728:	b62080e7          	jalr	-1182(ra) # 80000286 <consputc>
      break;
    8000072c:	b701                	j	8000062c <printf+0x9a>
      consputc('%');
    8000072e:	8556                	mv	a0,s5
    80000730:	00000097          	auipc	ra,0x0
    80000734:	b56080e7          	jalr	-1194(ra) # 80000286 <consputc>
      consputc(c);
    80000738:	854a                	mv	a0,s2
    8000073a:	00000097          	auipc	ra,0x0
    8000073e:	b4c080e7          	jalr	-1204(ra) # 80000286 <consputc>
      break;
    80000742:	b5ed                	j	8000062c <printf+0x9a>
  if(locking)
    80000744:	020d9163          	bnez	s11,80000766 <printf+0x1d4>
}
    80000748:	70e6                	ld	ra,120(sp)
    8000074a:	7446                	ld	s0,112(sp)
    8000074c:	74a6                	ld	s1,104(sp)
    8000074e:	7906                	ld	s2,96(sp)
    80000750:	69e6                	ld	s3,88(sp)
    80000752:	6a46                	ld	s4,80(sp)
    80000754:	6aa6                	ld	s5,72(sp)
    80000756:	6b06                	ld	s6,64(sp)
    80000758:	7be2                	ld	s7,56(sp)
    8000075a:	7c42                	ld	s8,48(sp)
    8000075c:	7ca2                	ld	s9,40(sp)
    8000075e:	7d02                	ld	s10,32(sp)
    80000760:	6de2                	ld	s11,24(sp)
    80000762:	6129                	addi	sp,sp,192
    80000764:	8082                	ret
    release(&pr.lock);
    80000766:	00011517          	auipc	a0,0x11
    8000076a:	17250513          	addi	a0,a0,370 # 800118d8 <pr>
    8000076e:	00000097          	auipc	ra,0x0
    80000772:	556080e7          	jalr	1366(ra) # 80000cc4 <release>
}
    80000776:	bfc9                	j	80000748 <printf+0x1b6>

0000000080000778 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000778:	1101                	addi	sp,sp,-32
    8000077a:	ec06                	sd	ra,24(sp)
    8000077c:	e822                	sd	s0,16(sp)
    8000077e:	e426                	sd	s1,8(sp)
    80000780:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000782:	00011497          	auipc	s1,0x11
    80000786:	15648493          	addi	s1,s1,342 # 800118d8 <pr>
    8000078a:	00008597          	auipc	a1,0x8
    8000078e:	8ae58593          	addi	a1,a1,-1874 # 80008038 <etext+0x38>
    80000792:	8526                	mv	a0,s1
    80000794:	00000097          	auipc	ra,0x0
    80000798:	3ec080e7          	jalr	1004(ra) # 80000b80 <initlock>
  pr.locking = 1;
    8000079c:	4785                	li	a5,1
    8000079e:	cc9c                	sw	a5,24(s1)
}
    800007a0:	60e2                	ld	ra,24(sp)
    800007a2:	6442                	ld	s0,16(sp)
    800007a4:	64a2                	ld	s1,8(sp)
    800007a6:	6105                	addi	sp,sp,32
    800007a8:	8082                	ret

00000000800007aa <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007aa:	1141                	addi	sp,sp,-16
    800007ac:	e406                	sd	ra,8(sp)
    800007ae:	e022                	sd	s0,0(sp)
    800007b0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007b2:	100007b7          	lui	a5,0x10000
    800007b6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ba:	f8000713          	li	a4,-128
    800007be:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007c2:	470d                	li	a4,3
    800007c4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007c8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007cc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007d0:	469d                	li	a3,7
    800007d2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007d6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007da:	00008597          	auipc	a1,0x8
    800007de:	87e58593          	addi	a1,a1,-1922 # 80008058 <digits+0x18>
    800007e2:	00011517          	auipc	a0,0x11
    800007e6:	11650513          	addi	a0,a0,278 # 800118f8 <uart_tx_lock>
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	396080e7          	jalr	918(ra) # 80000b80 <initlock>
}
    800007f2:	60a2                	ld	ra,8(sp)
    800007f4:	6402                	ld	s0,0(sp)
    800007f6:	0141                	addi	sp,sp,16
    800007f8:	8082                	ret

00000000800007fa <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007fa:	1101                	addi	sp,sp,-32
    800007fc:	ec06                	sd	ra,24(sp)
    800007fe:	e822                	sd	s0,16(sp)
    80000800:	e426                	sd	s1,8(sp)
    80000802:	1000                	addi	s0,sp,32
    80000804:	84aa                	mv	s1,a0
  push_off();
    80000806:	00000097          	auipc	ra,0x0
    8000080a:	3be080e7          	jalr	958(ra) # 80000bc4 <push_off>

  if(panicked){
    8000080e:	00008797          	auipc	a5,0x8
    80000812:	7f27a783          	lw	a5,2034(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000816:	10000737          	lui	a4,0x10000
  if(panicked){
    8000081a:	c391                	beqz	a5,8000081e <uartputc_sync+0x24>
    for(;;)
    8000081c:	a001                	j	8000081c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000081e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000822:	0ff7f793          	andi	a5,a5,255
    80000826:	0207f793          	andi	a5,a5,32
    8000082a:	dbf5                	beqz	a5,8000081e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000082c:	0ff4f793          	andi	a5,s1,255
    80000830:	10000737          	lui	a4,0x10000
    80000834:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	42c080e7          	jalr	1068(ra) # 80000c64 <pop_off>
}
    80000840:	60e2                	ld	ra,24(sp)
    80000842:	6442                	ld	s0,16(sp)
    80000844:	64a2                	ld	s1,8(sp)
    80000846:	6105                	addi	sp,sp,32
    80000848:	8082                	ret

000000008000084a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000084a:	00008797          	auipc	a5,0x8
    8000084e:	7ba7a783          	lw	a5,1978(a5) # 80009004 <uart_tx_r>
    80000852:	00008717          	auipc	a4,0x8
    80000856:	7b672703          	lw	a4,1974(a4) # 80009008 <uart_tx_w>
    8000085a:	08f70263          	beq	a4,a5,800008de <uartstart+0x94>
{
    8000085e:	7139                	addi	sp,sp,-64
    80000860:	fc06                	sd	ra,56(sp)
    80000862:	f822                	sd	s0,48(sp)
    80000864:	f426                	sd	s1,40(sp)
    80000866:	f04a                	sd	s2,32(sp)
    80000868:	ec4e                	sd	s3,24(sp)
    8000086a:	e852                	sd	s4,16(sp)
    8000086c:	e456                	sd	s5,8(sp)
    8000086e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000870:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r];
    80000874:	00011a17          	auipc	s4,0x11
    80000878:	084a0a13          	addi	s4,s4,132 # 800118f8 <uart_tx_lock>
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    8000087c:	00008497          	auipc	s1,0x8
    80000880:	78848493          	addi	s1,s1,1928 # 80009004 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000884:	00008997          	auipc	s3,0x8
    80000888:	78498993          	addi	s3,s3,1924 # 80009008 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000088c:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000890:	0ff77713          	andi	a4,a4,255
    80000894:	02077713          	andi	a4,a4,32
    80000898:	cb15                	beqz	a4,800008cc <uartstart+0x82>
    int c = uart_tx_buf[uart_tx_r];
    8000089a:	00fa0733          	add	a4,s4,a5
    8000089e:	01874a83          	lbu	s5,24(a4)
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    800008a2:	2785                	addiw	a5,a5,1
    800008a4:	41f7d71b          	sraiw	a4,a5,0x1f
    800008a8:	01b7571b          	srliw	a4,a4,0x1b
    800008ac:	9fb9                	addw	a5,a5,a4
    800008ae:	8bfd                	andi	a5,a5,31
    800008b0:	9f99                	subw	a5,a5,a4
    800008b2:	c09c                	sw	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800008b4:	8526                	mv	a0,s1
    800008b6:	00002097          	auipc	ra,0x2
    800008ba:	b92080e7          	jalr	-1134(ra) # 80002448 <wakeup>
    
    WriteReg(THR, c);
    800008be:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008c2:	409c                	lw	a5,0(s1)
    800008c4:	0009a703          	lw	a4,0(s3)
    800008c8:	fcf712e3          	bne	a4,a5,8000088c <uartstart+0x42>
  }
}
    800008cc:	70e2                	ld	ra,56(sp)
    800008ce:	7442                	ld	s0,48(sp)
    800008d0:	74a2                	ld	s1,40(sp)
    800008d2:	7902                	ld	s2,32(sp)
    800008d4:	69e2                	ld	s3,24(sp)
    800008d6:	6a42                	ld	s4,16(sp)
    800008d8:	6aa2                	ld	s5,8(sp)
    800008da:	6121                	addi	sp,sp,64
    800008dc:	8082                	ret
    800008de:	8082                	ret

00000000800008e0 <uartputc>:
{
    800008e0:	7179                	addi	sp,sp,-48
    800008e2:	f406                	sd	ra,40(sp)
    800008e4:	f022                	sd	s0,32(sp)
    800008e6:	ec26                	sd	s1,24(sp)
    800008e8:	e84a                	sd	s2,16(sp)
    800008ea:	e44e                	sd	s3,8(sp)
    800008ec:	e052                	sd	s4,0(sp)
    800008ee:	1800                	addi	s0,sp,48
    800008f0:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800008f2:	00011517          	auipc	a0,0x11
    800008f6:	00650513          	addi	a0,a0,6 # 800118f8 <uart_tx_lock>
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	316080e7          	jalr	790(ra) # 80000c10 <acquire>
  if(panicked){
    80000902:	00008797          	auipc	a5,0x8
    80000906:	6fe7a783          	lw	a5,1790(a5) # 80009000 <panicked>
    8000090a:	c391                	beqz	a5,8000090e <uartputc+0x2e>
    for(;;)
    8000090c:	a001                	j	8000090c <uartputc+0x2c>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    8000090e:	00008717          	auipc	a4,0x8
    80000912:	6fa72703          	lw	a4,1786(a4) # 80009008 <uart_tx_w>
    80000916:	0017079b          	addiw	a5,a4,1
    8000091a:	41f7d69b          	sraiw	a3,a5,0x1f
    8000091e:	01b6d69b          	srliw	a3,a3,0x1b
    80000922:	9fb5                	addw	a5,a5,a3
    80000924:	8bfd                	andi	a5,a5,31
    80000926:	9f95                	subw	a5,a5,a3
    80000928:	00008697          	auipc	a3,0x8
    8000092c:	6dc6a683          	lw	a3,1756(a3) # 80009004 <uart_tx_r>
    80000930:	04f69263          	bne	a3,a5,80000974 <uartputc+0x94>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000934:	00011a17          	auipc	s4,0x11
    80000938:	fc4a0a13          	addi	s4,s4,-60 # 800118f8 <uart_tx_lock>
    8000093c:	00008497          	auipc	s1,0x8
    80000940:	6c848493          	addi	s1,s1,1736 # 80009004 <uart_tx_r>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000944:	00008917          	auipc	s2,0x8
    80000948:	6c490913          	addi	s2,s2,1732 # 80009008 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000094c:	85d2                	mv	a1,s4
    8000094e:	8526                	mv	a0,s1
    80000950:	00002097          	auipc	ra,0x2
    80000954:	972080e7          	jalr	-1678(ra) # 800022c2 <sleep>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000958:	00092703          	lw	a4,0(s2)
    8000095c:	0017079b          	addiw	a5,a4,1
    80000960:	41f7d69b          	sraiw	a3,a5,0x1f
    80000964:	01b6d69b          	srliw	a3,a3,0x1b
    80000968:	9fb5                	addw	a5,a5,a3
    8000096a:	8bfd                	andi	a5,a5,31
    8000096c:	9f95                	subw	a5,a5,a3
    8000096e:	4094                	lw	a3,0(s1)
    80000970:	fcf68ee3          	beq	a3,a5,8000094c <uartputc+0x6c>
      uart_tx_buf[uart_tx_w] = c;
    80000974:	00011497          	auipc	s1,0x11
    80000978:	f8448493          	addi	s1,s1,-124 # 800118f8 <uart_tx_lock>
    8000097c:	9726                	add	a4,a4,s1
    8000097e:	01370c23          	sb	s3,24(a4)
      uart_tx_w = (uart_tx_w + 1) % UART_TX_BUF_SIZE;
    80000982:	00008717          	auipc	a4,0x8
    80000986:	68f72323          	sw	a5,1670(a4) # 80009008 <uart_tx_w>
      uartstart();
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	ec0080e7          	jalr	-320(ra) # 8000084a <uartstart>
      release(&uart_tx_lock);
    80000992:	8526                	mv	a0,s1
    80000994:	00000097          	auipc	ra,0x0
    80000998:	330080e7          	jalr	816(ra) # 80000cc4 <release>
}
    8000099c:	70a2                	ld	ra,40(sp)
    8000099e:	7402                	ld	s0,32(sp)
    800009a0:	64e2                	ld	s1,24(sp)
    800009a2:	6942                	ld	s2,16(sp)
    800009a4:	69a2                	ld	s3,8(sp)
    800009a6:	6a02                	ld	s4,0(sp)
    800009a8:	6145                	addi	sp,sp,48
    800009aa:	8082                	ret

00000000800009ac <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009ac:	1141                	addi	sp,sp,-16
    800009ae:	e422                	sd	s0,8(sp)
    800009b0:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009b2:	100007b7          	lui	a5,0x10000
    800009b6:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009ba:	8b85                	andi	a5,a5,1
    800009bc:	cb91                	beqz	a5,800009d0 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009be:	100007b7          	lui	a5,0x10000
    800009c2:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800009c6:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800009ca:	6422                	ld	s0,8(sp)
    800009cc:	0141                	addi	sp,sp,16
    800009ce:	8082                	ret
    return -1;
    800009d0:	557d                	li	a0,-1
    800009d2:	bfe5                	j	800009ca <uartgetc+0x1e>

00000000800009d4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800009d4:	1101                	addi	sp,sp,-32
    800009d6:	ec06                	sd	ra,24(sp)
    800009d8:	e822                	sd	s0,16(sp)
    800009da:	e426                	sd	s1,8(sp)
    800009dc:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009de:	54fd                	li	s1,-1
    int c = uartgetc();
    800009e0:	00000097          	auipc	ra,0x0
    800009e4:	fcc080e7          	jalr	-52(ra) # 800009ac <uartgetc>
    if(c == -1)
    800009e8:	00950763          	beq	a0,s1,800009f6 <uartintr+0x22>
      break;
    consoleintr(c);
    800009ec:	00000097          	auipc	ra,0x0
    800009f0:	8dc080e7          	jalr	-1828(ra) # 800002c8 <consoleintr>
  while(1){
    800009f4:	b7f5                	j	800009e0 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009f6:	00011497          	auipc	s1,0x11
    800009fa:	f0248493          	addi	s1,s1,-254 # 800118f8 <uart_tx_lock>
    800009fe:	8526                	mv	a0,s1
    80000a00:	00000097          	auipc	ra,0x0
    80000a04:	210080e7          	jalr	528(ra) # 80000c10 <acquire>
  uartstart();
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	e42080e7          	jalr	-446(ra) # 8000084a <uartstart>
  release(&uart_tx_lock);
    80000a10:	8526                	mv	a0,s1
    80000a12:	00000097          	auipc	ra,0x0
    80000a16:	2b2080e7          	jalr	690(ra) # 80000cc4 <release>
}
    80000a1a:	60e2                	ld	ra,24(sp)
    80000a1c:	6442                	ld	s0,16(sp)
    80000a1e:	64a2                	ld	s1,8(sp)
    80000a20:	6105                	addi	sp,sp,32
    80000a22:	8082                	ret

0000000080000a24 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a24:	1101                	addi	sp,sp,-32
    80000a26:	ec06                	sd	ra,24(sp)
    80000a28:	e822                	sd	s0,16(sp)
    80000a2a:	e426                	sd	s1,8(sp)
    80000a2c:	e04a                	sd	s2,0(sp)
    80000a2e:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a30:	03451793          	slli	a5,a0,0x34
    80000a34:	ebb9                	bnez	a5,80000a8a <kfree+0x66>
    80000a36:	84aa                	mv	s1,a0
    80000a38:	00025797          	auipc	a5,0x25
    80000a3c:	5c878793          	addi	a5,a5,1480 # 80026000 <end>
    80000a40:	04f56563          	bltu	a0,a5,80000a8a <kfree+0x66>
    80000a44:	47c5                	li	a5,17
    80000a46:	07ee                	slli	a5,a5,0x1b
    80000a48:	04f57163          	bgeu	a0,a5,80000a8a <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a4c:	6605                	lui	a2,0x1
    80000a4e:	4585                	li	a1,1
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	2bc080e7          	jalr	700(ra) # 80000d0c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a58:	00011917          	auipc	s2,0x11
    80000a5c:	ed890913          	addi	s2,s2,-296 # 80011930 <kmem>
    80000a60:	854a                	mv	a0,s2
    80000a62:	00000097          	auipc	ra,0x0
    80000a66:	1ae080e7          	jalr	430(ra) # 80000c10 <acquire>
  r->next = kmem.freelist;
    80000a6a:	01893783          	ld	a5,24(s2)
    80000a6e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a70:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a74:	854a                	mv	a0,s2
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	24e080e7          	jalr	590(ra) # 80000cc4 <release>
}
    80000a7e:	60e2                	ld	ra,24(sp)
    80000a80:	6442                	ld	s0,16(sp)
    80000a82:	64a2                	ld	s1,8(sp)
    80000a84:	6902                	ld	s2,0(sp)
    80000a86:	6105                	addi	sp,sp,32
    80000a88:	8082                	ret
    panic("kfree");
    80000a8a:	00007517          	auipc	a0,0x7
    80000a8e:	5d650513          	addi	a0,a0,1494 # 80008060 <digits+0x20>
    80000a92:	00000097          	auipc	ra,0x0
    80000a96:	ab6080e7          	jalr	-1354(ra) # 80000548 <panic>

0000000080000a9a <freerange>:
{
    80000a9a:	7179                	addi	sp,sp,-48
    80000a9c:	f406                	sd	ra,40(sp)
    80000a9e:	f022                	sd	s0,32(sp)
    80000aa0:	ec26                	sd	s1,24(sp)
    80000aa2:	e84a                	sd	s2,16(sp)
    80000aa4:	e44e                	sd	s3,8(sp)
    80000aa6:	e052                	sd	s4,0(sp)
    80000aa8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000aaa:	6785                	lui	a5,0x1
    80000aac:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000ab0:	94aa                	add	s1,s1,a0
    80000ab2:	757d                	lui	a0,0xfffff
    80000ab4:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ab6:	94be                	add	s1,s1,a5
    80000ab8:	0095ee63          	bltu	a1,s1,80000ad4 <freerange+0x3a>
    80000abc:	892e                	mv	s2,a1
    kfree(p);
    80000abe:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac0:	6985                	lui	s3,0x1
    kfree(p);
    80000ac2:	01448533          	add	a0,s1,s4
    80000ac6:	00000097          	auipc	ra,0x0
    80000aca:	f5e080e7          	jalr	-162(ra) # 80000a24 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ace:	94ce                	add	s1,s1,s3
    80000ad0:	fe9979e3          	bgeu	s2,s1,80000ac2 <freerange+0x28>
}
    80000ad4:	70a2                	ld	ra,40(sp)
    80000ad6:	7402                	ld	s0,32(sp)
    80000ad8:	64e2                	ld	s1,24(sp)
    80000ada:	6942                	ld	s2,16(sp)
    80000adc:	69a2                	ld	s3,8(sp)
    80000ade:	6a02                	ld	s4,0(sp)
    80000ae0:	6145                	addi	sp,sp,48
    80000ae2:	8082                	ret

0000000080000ae4 <kinit>:
{
    80000ae4:	1141                	addi	sp,sp,-16
    80000ae6:	e406                	sd	ra,8(sp)
    80000ae8:	e022                	sd	s0,0(sp)
    80000aea:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000aec:	00007597          	auipc	a1,0x7
    80000af0:	57c58593          	addi	a1,a1,1404 # 80008068 <digits+0x28>
    80000af4:	00011517          	auipc	a0,0x11
    80000af8:	e3c50513          	addi	a0,a0,-452 # 80011930 <kmem>
    80000afc:	00000097          	auipc	ra,0x0
    80000b00:	084080e7          	jalr	132(ra) # 80000b80 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b04:	45c5                	li	a1,17
    80000b06:	05ee                	slli	a1,a1,0x1b
    80000b08:	00025517          	auipc	a0,0x25
    80000b0c:	4f850513          	addi	a0,a0,1272 # 80026000 <end>
    80000b10:	00000097          	auipc	ra,0x0
    80000b14:	f8a080e7          	jalr	-118(ra) # 80000a9a <freerange>
}
    80000b18:	60a2                	ld	ra,8(sp)
    80000b1a:	6402                	ld	s0,0(sp)
    80000b1c:	0141                	addi	sp,sp,16
    80000b1e:	8082                	ret

0000000080000b20 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b20:	1101                	addi	sp,sp,-32
    80000b22:	ec06                	sd	ra,24(sp)
    80000b24:	e822                	sd	s0,16(sp)
    80000b26:	e426                	sd	s1,8(sp)
    80000b28:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b2a:	00011497          	auipc	s1,0x11
    80000b2e:	e0648493          	addi	s1,s1,-506 # 80011930 <kmem>
    80000b32:	8526                	mv	a0,s1
    80000b34:	00000097          	auipc	ra,0x0
    80000b38:	0dc080e7          	jalr	220(ra) # 80000c10 <acquire>
  r = kmem.freelist;
    80000b3c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b3e:	c885                	beqz	s1,80000b6e <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b40:	609c                	ld	a5,0(s1)
    80000b42:	00011517          	auipc	a0,0x11
    80000b46:	dee50513          	addi	a0,a0,-530 # 80011930 <kmem>
    80000b4a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	178080e7          	jalr	376(ra) # 80000cc4 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b54:	6605                	lui	a2,0x1
    80000b56:	4595                	li	a1,5
    80000b58:	8526                	mv	a0,s1
    80000b5a:	00000097          	auipc	ra,0x0
    80000b5e:	1b2080e7          	jalr	434(ra) # 80000d0c <memset>
  return (void*)r;
}
    80000b62:	8526                	mv	a0,s1
    80000b64:	60e2                	ld	ra,24(sp)
    80000b66:	6442                	ld	s0,16(sp)
    80000b68:	64a2                	ld	s1,8(sp)
    80000b6a:	6105                	addi	sp,sp,32
    80000b6c:	8082                	ret
  release(&kmem.lock);
    80000b6e:	00011517          	auipc	a0,0x11
    80000b72:	dc250513          	addi	a0,a0,-574 # 80011930 <kmem>
    80000b76:	00000097          	auipc	ra,0x0
    80000b7a:	14e080e7          	jalr	334(ra) # 80000cc4 <release>
  if(r)
    80000b7e:	b7d5                	j	80000b62 <kalloc+0x42>

0000000080000b80 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b80:	1141                	addi	sp,sp,-16
    80000b82:	e422                	sd	s0,8(sp)
    80000b84:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b86:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b88:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b8c:	00053823          	sd	zero,16(a0)
}
    80000b90:	6422                	ld	s0,8(sp)
    80000b92:	0141                	addi	sp,sp,16
    80000b94:	8082                	ret

0000000080000b96 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b96:	411c                	lw	a5,0(a0)
    80000b98:	e399                	bnez	a5,80000b9e <holding+0x8>
    80000b9a:	4501                	li	a0,0
  return r;
}
    80000b9c:	8082                	ret
{
    80000b9e:	1101                	addi	sp,sp,-32
    80000ba0:	ec06                	sd	ra,24(sp)
    80000ba2:	e822                	sd	s0,16(sp)
    80000ba4:	e426                	sd	s1,8(sp)
    80000ba6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000ba8:	6904                	ld	s1,16(a0)
    80000baa:	00001097          	auipc	ra,0x1
    80000bae:	ec4080e7          	jalr	-316(ra) # 80001a6e <mycpu>
    80000bb2:	40a48533          	sub	a0,s1,a0
    80000bb6:	00153513          	seqz	a0,a0
}
    80000bba:	60e2                	ld	ra,24(sp)
    80000bbc:	6442                	ld	s0,16(sp)
    80000bbe:	64a2                	ld	s1,8(sp)
    80000bc0:	6105                	addi	sp,sp,32
    80000bc2:	8082                	ret

0000000080000bc4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bc4:	1101                	addi	sp,sp,-32
    80000bc6:	ec06                	sd	ra,24(sp)
    80000bc8:	e822                	sd	s0,16(sp)
    80000bca:	e426                	sd	s1,8(sp)
    80000bcc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bce:	100024f3          	csrr	s1,sstatus
    80000bd2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bd6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bd8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bdc:	00001097          	auipc	ra,0x1
    80000be0:	e92080e7          	jalr	-366(ra) # 80001a6e <mycpu>
    80000be4:	5d3c                	lw	a5,120(a0)
    80000be6:	cf89                	beqz	a5,80000c00 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000be8:	00001097          	auipc	ra,0x1
    80000bec:	e86080e7          	jalr	-378(ra) # 80001a6e <mycpu>
    80000bf0:	5d3c                	lw	a5,120(a0)
    80000bf2:	2785                	addiw	a5,a5,1
    80000bf4:	dd3c                	sw	a5,120(a0)
}
    80000bf6:	60e2                	ld	ra,24(sp)
    80000bf8:	6442                	ld	s0,16(sp)
    80000bfa:	64a2                	ld	s1,8(sp)
    80000bfc:	6105                	addi	sp,sp,32
    80000bfe:	8082                	ret
    mycpu()->intena = old;
    80000c00:	00001097          	auipc	ra,0x1
    80000c04:	e6e080e7          	jalr	-402(ra) # 80001a6e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c08:	8085                	srli	s1,s1,0x1
    80000c0a:	8885                	andi	s1,s1,1
    80000c0c:	dd64                	sw	s1,124(a0)
    80000c0e:	bfe9                	j	80000be8 <push_off+0x24>

0000000080000c10 <acquire>:
{
    80000c10:	1101                	addi	sp,sp,-32
    80000c12:	ec06                	sd	ra,24(sp)
    80000c14:	e822                	sd	s0,16(sp)
    80000c16:	e426                	sd	s1,8(sp)
    80000c18:	1000                	addi	s0,sp,32
    80000c1a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c1c:	00000097          	auipc	ra,0x0
    80000c20:	fa8080e7          	jalr	-88(ra) # 80000bc4 <push_off>
  if(holding(lk))
    80000c24:	8526                	mv	a0,s1
    80000c26:	00000097          	auipc	ra,0x0
    80000c2a:	f70080e7          	jalr	-144(ra) # 80000b96 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c2e:	4705                	li	a4,1
  if(holding(lk))
    80000c30:	e115                	bnez	a0,80000c54 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c32:	87ba                	mv	a5,a4
    80000c34:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c38:	2781                	sext.w	a5,a5
    80000c3a:	ffe5                	bnez	a5,80000c32 <acquire+0x22>
  __sync_synchronize();
    80000c3c:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c40:	00001097          	auipc	ra,0x1
    80000c44:	e2e080e7          	jalr	-466(ra) # 80001a6e <mycpu>
    80000c48:	e888                	sd	a0,16(s1)
}
    80000c4a:	60e2                	ld	ra,24(sp)
    80000c4c:	6442                	ld	s0,16(sp)
    80000c4e:	64a2                	ld	s1,8(sp)
    80000c50:	6105                	addi	sp,sp,32
    80000c52:	8082                	ret
    panic("acquire");
    80000c54:	00007517          	auipc	a0,0x7
    80000c58:	41c50513          	addi	a0,a0,1052 # 80008070 <digits+0x30>
    80000c5c:	00000097          	auipc	ra,0x0
    80000c60:	8ec080e7          	jalr	-1812(ra) # 80000548 <panic>

0000000080000c64 <pop_off>:

void
pop_off(void)
{
    80000c64:	1141                	addi	sp,sp,-16
    80000c66:	e406                	sd	ra,8(sp)
    80000c68:	e022                	sd	s0,0(sp)
    80000c6a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c6c:	00001097          	auipc	ra,0x1
    80000c70:	e02080e7          	jalr	-510(ra) # 80001a6e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c74:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c78:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c7a:	e78d                	bnez	a5,80000ca4 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c7c:	5d3c                	lw	a5,120(a0)
    80000c7e:	02f05b63          	blez	a5,80000cb4 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c82:	37fd                	addiw	a5,a5,-1
    80000c84:	0007871b          	sext.w	a4,a5
    80000c88:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c8a:	eb09                	bnez	a4,80000c9c <pop_off+0x38>
    80000c8c:	5d7c                	lw	a5,124(a0)
    80000c8e:	c799                	beqz	a5,80000c9c <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c90:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c94:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c98:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c9c:	60a2                	ld	ra,8(sp)
    80000c9e:	6402                	ld	s0,0(sp)
    80000ca0:	0141                	addi	sp,sp,16
    80000ca2:	8082                	ret
    panic("pop_off - interruptible");
    80000ca4:	00007517          	auipc	a0,0x7
    80000ca8:	3d450513          	addi	a0,a0,980 # 80008078 <digits+0x38>
    80000cac:	00000097          	auipc	ra,0x0
    80000cb0:	89c080e7          	jalr	-1892(ra) # 80000548 <panic>
    panic("pop_off");
    80000cb4:	00007517          	auipc	a0,0x7
    80000cb8:	3dc50513          	addi	a0,a0,988 # 80008090 <digits+0x50>
    80000cbc:	00000097          	auipc	ra,0x0
    80000cc0:	88c080e7          	jalr	-1908(ra) # 80000548 <panic>

0000000080000cc4 <release>:
{
    80000cc4:	1101                	addi	sp,sp,-32
    80000cc6:	ec06                	sd	ra,24(sp)
    80000cc8:	e822                	sd	s0,16(sp)
    80000cca:	e426                	sd	s1,8(sp)
    80000ccc:	1000                	addi	s0,sp,32
    80000cce:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cd0:	00000097          	auipc	ra,0x0
    80000cd4:	ec6080e7          	jalr	-314(ra) # 80000b96 <holding>
    80000cd8:	c115                	beqz	a0,80000cfc <release+0x38>
  lk->cpu = 0;
    80000cda:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cde:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ce2:	0f50000f          	fence	iorw,ow
    80000ce6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cea:	00000097          	auipc	ra,0x0
    80000cee:	f7a080e7          	jalr	-134(ra) # 80000c64 <pop_off>
}
    80000cf2:	60e2                	ld	ra,24(sp)
    80000cf4:	6442                	ld	s0,16(sp)
    80000cf6:	64a2                	ld	s1,8(sp)
    80000cf8:	6105                	addi	sp,sp,32
    80000cfa:	8082                	ret
    panic("release");
    80000cfc:	00007517          	auipc	a0,0x7
    80000d00:	39c50513          	addi	a0,a0,924 # 80008098 <digits+0x58>
    80000d04:	00000097          	auipc	ra,0x0
    80000d08:	844080e7          	jalr	-1980(ra) # 80000548 <panic>

0000000080000d0c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d0c:	1141                	addi	sp,sp,-16
    80000d0e:	e422                	sd	s0,8(sp)
    80000d10:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d12:	ce09                	beqz	a2,80000d2c <memset+0x20>
    80000d14:	87aa                	mv	a5,a0
    80000d16:	fff6071b          	addiw	a4,a2,-1
    80000d1a:	1702                	slli	a4,a4,0x20
    80000d1c:	9301                	srli	a4,a4,0x20
    80000d1e:	0705                	addi	a4,a4,1
    80000d20:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000d22:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d26:	0785                	addi	a5,a5,1
    80000d28:	fee79de3          	bne	a5,a4,80000d22 <memset+0x16>
  }
  return dst;
}
    80000d2c:	6422                	ld	s0,8(sp)
    80000d2e:	0141                	addi	sp,sp,16
    80000d30:	8082                	ret

0000000080000d32 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d32:	1141                	addi	sp,sp,-16
    80000d34:	e422                	sd	s0,8(sp)
    80000d36:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d38:	ca05                	beqz	a2,80000d68 <memcmp+0x36>
    80000d3a:	fff6069b          	addiw	a3,a2,-1
    80000d3e:	1682                	slli	a3,a3,0x20
    80000d40:	9281                	srli	a3,a3,0x20
    80000d42:	0685                	addi	a3,a3,1
    80000d44:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d46:	00054783          	lbu	a5,0(a0)
    80000d4a:	0005c703          	lbu	a4,0(a1)
    80000d4e:	00e79863          	bne	a5,a4,80000d5e <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d52:	0505                	addi	a0,a0,1
    80000d54:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d56:	fed518e3          	bne	a0,a3,80000d46 <memcmp+0x14>
  }

  return 0;
    80000d5a:	4501                	li	a0,0
    80000d5c:	a019                	j	80000d62 <memcmp+0x30>
      return *s1 - *s2;
    80000d5e:	40e7853b          	subw	a0,a5,a4
}
    80000d62:	6422                	ld	s0,8(sp)
    80000d64:	0141                	addi	sp,sp,16
    80000d66:	8082                	ret
  return 0;
    80000d68:	4501                	li	a0,0
    80000d6a:	bfe5                	j	80000d62 <memcmp+0x30>

0000000080000d6c <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d6c:	1141                	addi	sp,sp,-16
    80000d6e:	e422                	sd	s0,8(sp)
    80000d70:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d72:	00a5f963          	bgeu	a1,a0,80000d84 <memmove+0x18>
    80000d76:	02061713          	slli	a4,a2,0x20
    80000d7a:	9301                	srli	a4,a4,0x20
    80000d7c:	00e587b3          	add	a5,a1,a4
    80000d80:	02f56563          	bltu	a0,a5,80000daa <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d84:	fff6069b          	addiw	a3,a2,-1
    80000d88:	ce11                	beqz	a2,80000da4 <memmove+0x38>
    80000d8a:	1682                	slli	a3,a3,0x20
    80000d8c:	9281                	srli	a3,a3,0x20
    80000d8e:	0685                	addi	a3,a3,1
    80000d90:	96ae                	add	a3,a3,a1
    80000d92:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d94:	0585                	addi	a1,a1,1
    80000d96:	0785                	addi	a5,a5,1
    80000d98:	fff5c703          	lbu	a4,-1(a1)
    80000d9c:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000da0:	fed59ae3          	bne	a1,a3,80000d94 <memmove+0x28>

  return dst;
}
    80000da4:	6422                	ld	s0,8(sp)
    80000da6:	0141                	addi	sp,sp,16
    80000da8:	8082                	ret
    d += n;
    80000daa:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000dac:	fff6069b          	addiw	a3,a2,-1
    80000db0:	da75                	beqz	a2,80000da4 <memmove+0x38>
    80000db2:	02069613          	slli	a2,a3,0x20
    80000db6:	9201                	srli	a2,a2,0x20
    80000db8:	fff64613          	not	a2,a2
    80000dbc:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000dbe:	17fd                	addi	a5,a5,-1
    80000dc0:	177d                	addi	a4,a4,-1
    80000dc2:	0007c683          	lbu	a3,0(a5)
    80000dc6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000dca:	fec79ae3          	bne	a5,a2,80000dbe <memmove+0x52>
    80000dce:	bfd9                	j	80000da4 <memmove+0x38>

0000000080000dd0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000dd0:	1141                	addi	sp,sp,-16
    80000dd2:	e406                	sd	ra,8(sp)
    80000dd4:	e022                	sd	s0,0(sp)
    80000dd6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000dd8:	00000097          	auipc	ra,0x0
    80000ddc:	f94080e7          	jalr	-108(ra) # 80000d6c <memmove>
}
    80000de0:	60a2                	ld	ra,8(sp)
    80000de2:	6402                	ld	s0,0(sp)
    80000de4:	0141                	addi	sp,sp,16
    80000de6:	8082                	ret

0000000080000de8 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000de8:	1141                	addi	sp,sp,-16
    80000dea:	e422                	sd	s0,8(sp)
    80000dec:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dee:	ce11                	beqz	a2,80000e0a <strncmp+0x22>
    80000df0:	00054783          	lbu	a5,0(a0)
    80000df4:	cf89                	beqz	a5,80000e0e <strncmp+0x26>
    80000df6:	0005c703          	lbu	a4,0(a1)
    80000dfa:	00f71a63          	bne	a4,a5,80000e0e <strncmp+0x26>
    n--, p++, q++;
    80000dfe:	367d                	addiw	a2,a2,-1
    80000e00:	0505                	addi	a0,a0,1
    80000e02:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e04:	f675                	bnez	a2,80000df0 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e06:	4501                	li	a0,0
    80000e08:	a809                	j	80000e1a <strncmp+0x32>
    80000e0a:	4501                	li	a0,0
    80000e0c:	a039                	j	80000e1a <strncmp+0x32>
  if(n == 0)
    80000e0e:	ca09                	beqz	a2,80000e20 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000e10:	00054503          	lbu	a0,0(a0)
    80000e14:	0005c783          	lbu	a5,0(a1)
    80000e18:	9d1d                	subw	a0,a0,a5
}
    80000e1a:	6422                	ld	s0,8(sp)
    80000e1c:	0141                	addi	sp,sp,16
    80000e1e:	8082                	ret
    return 0;
    80000e20:	4501                	li	a0,0
    80000e22:	bfe5                	j	80000e1a <strncmp+0x32>

0000000080000e24 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e24:	1141                	addi	sp,sp,-16
    80000e26:	e422                	sd	s0,8(sp)
    80000e28:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e2a:	872a                	mv	a4,a0
    80000e2c:	8832                	mv	a6,a2
    80000e2e:	367d                	addiw	a2,a2,-1
    80000e30:	01005963          	blez	a6,80000e42 <strncpy+0x1e>
    80000e34:	0705                	addi	a4,a4,1
    80000e36:	0005c783          	lbu	a5,0(a1)
    80000e3a:	fef70fa3          	sb	a5,-1(a4)
    80000e3e:	0585                	addi	a1,a1,1
    80000e40:	f7f5                	bnez	a5,80000e2c <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e42:	00c05d63          	blez	a2,80000e5c <strncpy+0x38>
    80000e46:	86ba                	mv	a3,a4
    *s++ = 0;
    80000e48:	0685                	addi	a3,a3,1
    80000e4a:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e4e:	fff6c793          	not	a5,a3
    80000e52:	9fb9                	addw	a5,a5,a4
    80000e54:	010787bb          	addw	a5,a5,a6
    80000e58:	fef048e3          	bgtz	a5,80000e48 <strncpy+0x24>
  return os;
}
    80000e5c:	6422                	ld	s0,8(sp)
    80000e5e:	0141                	addi	sp,sp,16
    80000e60:	8082                	ret

0000000080000e62 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e422                	sd	s0,8(sp)
    80000e66:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e68:	02c05363          	blez	a2,80000e8e <safestrcpy+0x2c>
    80000e6c:	fff6069b          	addiw	a3,a2,-1
    80000e70:	1682                	slli	a3,a3,0x20
    80000e72:	9281                	srli	a3,a3,0x20
    80000e74:	96ae                	add	a3,a3,a1
    80000e76:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e78:	00d58963          	beq	a1,a3,80000e8a <safestrcpy+0x28>
    80000e7c:	0585                	addi	a1,a1,1
    80000e7e:	0785                	addi	a5,a5,1
    80000e80:	fff5c703          	lbu	a4,-1(a1)
    80000e84:	fee78fa3          	sb	a4,-1(a5)
    80000e88:	fb65                	bnez	a4,80000e78 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e8a:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e8e:	6422                	ld	s0,8(sp)
    80000e90:	0141                	addi	sp,sp,16
    80000e92:	8082                	ret

0000000080000e94 <strlen>:

int
strlen(const char *s)
{
    80000e94:	1141                	addi	sp,sp,-16
    80000e96:	e422                	sd	s0,8(sp)
    80000e98:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e9a:	00054783          	lbu	a5,0(a0)
    80000e9e:	cf91                	beqz	a5,80000eba <strlen+0x26>
    80000ea0:	0505                	addi	a0,a0,1
    80000ea2:	87aa                	mv	a5,a0
    80000ea4:	4685                	li	a3,1
    80000ea6:	9e89                	subw	a3,a3,a0
    80000ea8:	00f6853b          	addw	a0,a3,a5
    80000eac:	0785                	addi	a5,a5,1
    80000eae:	fff7c703          	lbu	a4,-1(a5)
    80000eb2:	fb7d                	bnez	a4,80000ea8 <strlen+0x14>
    ;
  return n;
}
    80000eb4:	6422                	ld	s0,8(sp)
    80000eb6:	0141                	addi	sp,sp,16
    80000eb8:	8082                	ret
  for(n = 0; s[n]; n++)
    80000eba:	4501                	li	a0,0
    80000ebc:	bfe5                	j	80000eb4 <strlen+0x20>

0000000080000ebe <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000ebe:	1141                	addi	sp,sp,-16
    80000ec0:	e406                	sd	ra,8(sp)
    80000ec2:	e022                	sd	s0,0(sp)
    80000ec4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000ec6:	00001097          	auipc	ra,0x1
    80000eca:	b98080e7          	jalr	-1128(ra) # 80001a5e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ece:	00008717          	auipc	a4,0x8
    80000ed2:	13e70713          	addi	a4,a4,318 # 8000900c <started>
  if(cpuid() == 0){
    80000ed6:	c139                	beqz	a0,80000f1c <main+0x5e>
    while(started == 0)
    80000ed8:	431c                	lw	a5,0(a4)
    80000eda:	2781                	sext.w	a5,a5
    80000edc:	dff5                	beqz	a5,80000ed8 <main+0x1a>
      ;
    __sync_synchronize();
    80000ede:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000ee2:	00001097          	auipc	ra,0x1
    80000ee6:	b7c080e7          	jalr	-1156(ra) # 80001a5e <cpuid>
    80000eea:	85aa                	mv	a1,a0
    80000eec:	00007517          	auipc	a0,0x7
    80000ef0:	1cc50513          	addi	a0,a0,460 # 800080b8 <digits+0x78>
    80000ef4:	fffff097          	auipc	ra,0xfffff
    80000ef8:	69e080e7          	jalr	1694(ra) # 80000592 <printf>
    kvminithart();    // turn on paging
    80000efc:	00000097          	auipc	ra,0x0
    80000f00:	18a080e7          	jalr	394(ra) # 80001086 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f04:	00002097          	auipc	ra,0x2
    80000f08:	80c080e7          	jalr	-2036(ra) # 80002710 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f0c:	00005097          	auipc	ra,0x5
    80000f10:	014080e7          	jalr	20(ra) # 80005f20 <plicinithart>
  }

  scheduler();        
    80000f14:	00001097          	auipc	ra,0x1
    80000f18:	0ce080e7          	jalr	206(ra) # 80001fe2 <scheduler>
    consoleinit();
    80000f1c:	fffff097          	auipc	ra,0xfffff
    80000f20:	53e080e7          	jalr	1342(ra) # 8000045a <consoleinit>
    printfinit();
    80000f24:	00000097          	auipc	ra,0x0
    80000f28:	854080e7          	jalr	-1964(ra) # 80000778 <printfinit>
    printf("\n");
    80000f2c:	00007517          	auipc	a0,0x7
    80000f30:	19c50513          	addi	a0,a0,412 # 800080c8 <digits+0x88>
    80000f34:	fffff097          	auipc	ra,0xfffff
    80000f38:	65e080e7          	jalr	1630(ra) # 80000592 <printf>
    printf("xv6 kernel is booting\n");
    80000f3c:	00007517          	auipc	a0,0x7
    80000f40:	16450513          	addi	a0,a0,356 # 800080a0 <digits+0x60>
    80000f44:	fffff097          	auipc	ra,0xfffff
    80000f48:	64e080e7          	jalr	1614(ra) # 80000592 <printf>
    printf("\n");
    80000f4c:	00007517          	auipc	a0,0x7
    80000f50:	17c50513          	addi	a0,a0,380 # 800080c8 <digits+0x88>
    80000f54:	fffff097          	auipc	ra,0xfffff
    80000f58:	63e080e7          	jalr	1598(ra) # 80000592 <printf>
    kinit();         // physical page allocator
    80000f5c:	00000097          	auipc	ra,0x0
    80000f60:	b88080e7          	jalr	-1144(ra) # 80000ae4 <kinit>
    kvminit();       // create kernel page table
    80000f64:	00000097          	auipc	ra,0x0
    80000f68:	352080e7          	jalr	850(ra) # 800012b6 <kvminit>
    kvminithart();   // turn on paging
    80000f6c:	00000097          	auipc	ra,0x0
    80000f70:	11a080e7          	jalr	282(ra) # 80001086 <kvminithart>
    procinit();      // process table
    80000f74:	00001097          	auipc	ra,0x1
    80000f78:	a1a080e7          	jalr	-1510(ra) # 8000198e <procinit>
    trapinit();      // trap vectors
    80000f7c:	00001097          	auipc	ra,0x1
    80000f80:	76c080e7          	jalr	1900(ra) # 800026e8 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f84:	00001097          	auipc	ra,0x1
    80000f88:	78c080e7          	jalr	1932(ra) # 80002710 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f8c:	00005097          	auipc	ra,0x5
    80000f90:	f7e080e7          	jalr	-130(ra) # 80005f0a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f94:	00005097          	auipc	ra,0x5
    80000f98:	f8c080e7          	jalr	-116(ra) # 80005f20 <plicinithart>
    binit();         // buffer cache
    80000f9c:	00002097          	auipc	ra,0x2
    80000fa0:	f56080e7          	jalr	-170(ra) # 80002ef2 <binit>
    iinit();         // inode cache
    80000fa4:	00002097          	auipc	ra,0x2
    80000fa8:	5e6080e7          	jalr	1510(ra) # 8000358a <iinit>
    fileinit();      // file table
    80000fac:	00003097          	auipc	ra,0x3
    80000fb0:	584080e7          	jalr	1412(ra) # 80004530 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fb4:	00005097          	auipc	ra,0x5
    80000fb8:	074080e7          	jalr	116(ra) # 80006028 <virtio_disk_init>
    userinit();      // first user process
    80000fbc:	00001097          	auipc	ra,0x1
    80000fc0:	db0080e7          	jalr	-592(ra) # 80001d6c <userinit>
    __sync_synchronize();
    80000fc4:	0ff0000f          	fence
    started = 1;
    80000fc8:	4785                	li	a5,1
    80000fca:	00008717          	auipc	a4,0x8
    80000fce:	04f72123          	sw	a5,66(a4) # 8000900c <started>
    80000fd2:	b789                	j	80000f14 <main+0x56>

0000000080000fd4 <vmprint_helper>:
  } else {
    return -1;
  }
}
static void vmprint_helper(pagetable_t pagetable,int level){
    if(level > 3)
    80000fd4:	478d                	li	a5,3
    80000fd6:	0ab7c763          	blt	a5,a1,80001084 <vmprint_helper+0xb0>
static void vmprint_helper(pagetable_t pagetable,int level){
    80000fda:	7159                	addi	sp,sp,-112
    80000fdc:	f486                	sd	ra,104(sp)
    80000fde:	f0a2                	sd	s0,96(sp)
    80000fe0:	eca6                	sd	s1,88(sp)
    80000fe2:	e8ca                	sd	s2,80(sp)
    80000fe4:	e4ce                	sd	s3,72(sp)
    80000fe6:	e0d2                	sd	s4,64(sp)
    80000fe8:	fc56                	sd	s5,56(sp)
    80000fea:	f85a                	sd	s6,48(sp)
    80000fec:	f45e                	sd	s7,40(sp)
    80000fee:	f062                	sd	s8,32(sp)
    80000ff0:	ec66                	sd	s9,24(sp)
    80000ff2:	e86a                	sd	s10,16(sp)
    80000ff4:	e46e                	sd	s11,8(sp)
    80000ff6:	1880                	addi	s0,sp,112
    80000ff8:	8aae                	mv	s5,a1
    80000ffa:	892a                	mv	s2,a0
        return;
    for(int i = 0; i < 512; i++){
    80000ffc:	4481                	li	s1,0
        pte_t pte = pagetable[i];
        if(pte & PTE_V){
            uint64 child = PTE2PA(pte);
            for(int j = 0; j < level; j++)
                printf(" ..");
            printf("%d: pte %p pa %p\n",i,pte,child);
    80000ffe:	00007c97          	auipc	s9,0x7
    80001002:	0dac8c93          	addi	s9,s9,218 # 800080d8 <digits+0x98>
            vmprint_helper((pagetable_t)child,level+1);
    80001006:	00158c1b          	addiw	s8,a1,1
            for(int j = 0; j < level; j++)
    8000100a:	4d01                	li	s10,0
                printf(" ..");
    8000100c:	00007b97          	auipc	s7,0x7
    80001010:	0c4b8b93          	addi	s7,s7,196 # 800080d0 <digits+0x90>
    for(int i = 0; i < 512; i++){
    80001014:	20000b13          	li	s6,512
    80001018:	a01d                	j	8000103e <vmprint_helper+0x6a>
            printf("%d: pte %p pa %p\n",i,pte,child);
    8000101a:	86ee                	mv	a3,s11
    8000101c:	8652                	mv	a2,s4
    8000101e:	85a6                	mv	a1,s1
    80001020:	8566                	mv	a0,s9
    80001022:	fffff097          	auipc	ra,0xfffff
    80001026:	570080e7          	jalr	1392(ra) # 80000592 <printf>
            vmprint_helper((pagetable_t)child,level+1);
    8000102a:	85e2                	mv	a1,s8
    8000102c:	856e                	mv	a0,s11
    8000102e:	00000097          	auipc	ra,0x0
    80001032:	fa6080e7          	jalr	-90(ra) # 80000fd4 <vmprint_helper>
    for(int i = 0; i < 512; i++){
    80001036:	2485                	addiw	s1,s1,1
    80001038:	0921                	addi	s2,s2,8
    8000103a:	03648663          	beq	s1,s6,80001066 <vmprint_helper+0x92>
        pte_t pte = pagetable[i];
    8000103e:	00093a03          	ld	s4,0(s2)
        if(pte & PTE_V){
    80001042:	001a7793          	andi	a5,s4,1
    80001046:	dbe5                	beqz	a5,80001036 <vmprint_helper+0x62>
            uint64 child = PTE2PA(pte);
    80001048:	00aa5d93          	srli	s11,s4,0xa
    8000104c:	0db2                	slli	s11,s11,0xc
            for(int j = 0; j < level; j++)
    8000104e:	fd5056e3          	blez	s5,8000101a <vmprint_helper+0x46>
    80001052:	89ea                	mv	s3,s10
                printf(" ..");
    80001054:	855e                	mv	a0,s7
    80001056:	fffff097          	auipc	ra,0xfffff
    8000105a:	53c080e7          	jalr	1340(ra) # 80000592 <printf>
            for(int j = 0; j < level; j++)
    8000105e:	2985                	addiw	s3,s3,1
    80001060:	ff3a9ae3          	bne	s5,s3,80001054 <vmprint_helper+0x80>
    80001064:	bf5d                	j	8000101a <vmprint_helper+0x46>
        }
    }
}
    80001066:	70a6                	ld	ra,104(sp)
    80001068:	7406                	ld	s0,96(sp)
    8000106a:	64e6                	ld	s1,88(sp)
    8000106c:	6946                	ld	s2,80(sp)
    8000106e:	69a6                	ld	s3,72(sp)
    80001070:	6a06                	ld	s4,64(sp)
    80001072:	7ae2                	ld	s5,56(sp)
    80001074:	7b42                	ld	s6,48(sp)
    80001076:	7ba2                	ld	s7,40(sp)
    80001078:	7c02                	ld	s8,32(sp)
    8000107a:	6ce2                	ld	s9,24(sp)
    8000107c:	6d42                	ld	s10,16(sp)
    8000107e:	6da2                	ld	s11,8(sp)
    80001080:	6165                	addi	sp,sp,112
    80001082:	8082                	ret
    80001084:	8082                	ret

0000000080001086 <kvminithart>:
{
    80001086:	1141                	addi	sp,sp,-16
    80001088:	e422                	sd	s0,8(sp)
    8000108a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000108c:	00008797          	auipc	a5,0x8
    80001090:	f847b783          	ld	a5,-124(a5) # 80009010 <kernel_pagetable>
    80001094:	83b1                	srli	a5,a5,0xc
    80001096:	577d                	li	a4,-1
    80001098:	177e                	slli	a4,a4,0x3f
    8000109a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000109c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800010a0:	12000073          	sfence.vma
}
    800010a4:	6422                	ld	s0,8(sp)
    800010a6:	0141                	addi	sp,sp,16
    800010a8:	8082                	ret

00000000800010aa <walk>:
{
    800010aa:	7139                	addi	sp,sp,-64
    800010ac:	fc06                	sd	ra,56(sp)
    800010ae:	f822                	sd	s0,48(sp)
    800010b0:	f426                	sd	s1,40(sp)
    800010b2:	f04a                	sd	s2,32(sp)
    800010b4:	ec4e                	sd	s3,24(sp)
    800010b6:	e852                	sd	s4,16(sp)
    800010b8:	e456                	sd	s5,8(sp)
    800010ba:	e05a                	sd	s6,0(sp)
    800010bc:	0080                	addi	s0,sp,64
    800010be:	84aa                	mv	s1,a0
    800010c0:	89ae                	mv	s3,a1
    800010c2:	8ab2                	mv	s5,a2
  if(va >= MAXVA){
    800010c4:	57fd                	li	a5,-1
    800010c6:	83e9                	srli	a5,a5,0x1a
    800010c8:	4a79                	li	s4,30
  for(int level = 2; level > 0; level--) {
    800010ca:	4b31                	li	s6,12
  if(va >= MAXVA){
    800010cc:	04b7f263          	bgeu	a5,a1,80001110 <walk+0x66>
    panic("walk");
    800010d0:	00007517          	auipc	a0,0x7
    800010d4:	02050513          	addi	a0,a0,32 # 800080f0 <digits+0xb0>
    800010d8:	fffff097          	auipc	ra,0xfffff
    800010dc:	470080e7          	jalr	1136(ra) # 80000548 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800010e0:	060a8663          	beqz	s5,8000114c <walk+0xa2>
    800010e4:	00000097          	auipc	ra,0x0
    800010e8:	a3c080e7          	jalr	-1476(ra) # 80000b20 <kalloc>
    800010ec:	84aa                	mv	s1,a0
    800010ee:	c529                	beqz	a0,80001138 <walk+0x8e>
      memset(pagetable, 0, PGSIZE);
    800010f0:	6605                	lui	a2,0x1
    800010f2:	4581                	li	a1,0
    800010f4:	00000097          	auipc	ra,0x0
    800010f8:	c18080e7          	jalr	-1000(ra) # 80000d0c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800010fc:	00c4d793          	srli	a5,s1,0xc
    80001100:	07aa                	slli	a5,a5,0xa
    80001102:	0017e793          	ori	a5,a5,1
    80001106:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000110a:	3a5d                	addiw	s4,s4,-9
    8000110c:	036a0063          	beq	s4,s6,8000112c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001110:	0149d933          	srl	s2,s3,s4
    80001114:	1ff97913          	andi	s2,s2,511
    80001118:	090e                	slli	s2,s2,0x3
    8000111a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000111c:	00093483          	ld	s1,0(s2)
    80001120:	0014f793          	andi	a5,s1,1
    80001124:	dfd5                	beqz	a5,800010e0 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001126:	80a9                	srli	s1,s1,0xa
    80001128:	04b2                	slli	s1,s1,0xc
    8000112a:	b7c5                	j	8000110a <walk+0x60>
  return &pagetable[PX(0, va)];
    8000112c:	00c9d513          	srli	a0,s3,0xc
    80001130:	1ff57513          	andi	a0,a0,511
    80001134:	050e                	slli	a0,a0,0x3
    80001136:	9526                	add	a0,a0,s1
}
    80001138:	70e2                	ld	ra,56(sp)
    8000113a:	7442                	ld	s0,48(sp)
    8000113c:	74a2                	ld	s1,40(sp)
    8000113e:	7902                	ld	s2,32(sp)
    80001140:	69e2                	ld	s3,24(sp)
    80001142:	6a42                	ld	s4,16(sp)
    80001144:	6aa2                	ld	s5,8(sp)
    80001146:	6b02                	ld	s6,0(sp)
    80001148:	6121                	addi	sp,sp,64
    8000114a:	8082                	ret
        return 0;
    8000114c:	4501                	li	a0,0
    8000114e:	b7ed                	j	80001138 <walk+0x8e>

0000000080001150 <walkaddr>:
  if(va >= MAXVA)
    80001150:	57fd                	li	a5,-1
    80001152:	83e9                	srli	a5,a5,0x1a
    80001154:	00b7f463          	bgeu	a5,a1,8000115c <walkaddr+0xc>
    return 0;
    80001158:	4501                	li	a0,0
}
    8000115a:	8082                	ret
{
    8000115c:	1141                	addi	sp,sp,-16
    8000115e:	e406                	sd	ra,8(sp)
    80001160:	e022                	sd	s0,0(sp)
    80001162:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001164:	4601                	li	a2,0
    80001166:	00000097          	auipc	ra,0x0
    8000116a:	f44080e7          	jalr	-188(ra) # 800010aa <walk>
  if(pte == 0)
    8000116e:	c105                	beqz	a0,8000118e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001170:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001172:	0117f693          	andi	a3,a5,17
    80001176:	4745                	li	a4,17
    return 0;
    80001178:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000117a:	00e68663          	beq	a3,a4,80001186 <walkaddr+0x36>
}
    8000117e:	60a2                	ld	ra,8(sp)
    80001180:	6402                	ld	s0,0(sp)
    80001182:	0141                	addi	sp,sp,16
    80001184:	8082                	ret
  pa = PTE2PA(*pte);
    80001186:	00a7d513          	srli	a0,a5,0xa
    8000118a:	0532                	slli	a0,a0,0xc
  return pa;
    8000118c:	bfcd                	j	8000117e <walkaddr+0x2e>
    return 0;
    8000118e:	4501                	li	a0,0
    80001190:	b7fd                	j	8000117e <walkaddr+0x2e>

0000000080001192 <kvmpa>:
{
    80001192:	1101                	addi	sp,sp,-32
    80001194:	ec06                	sd	ra,24(sp)
    80001196:	e822                	sd	s0,16(sp)
    80001198:	e426                	sd	s1,8(sp)
    8000119a:	1000                	addi	s0,sp,32
    8000119c:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    8000119e:	1552                	slli	a0,a0,0x34
    800011a0:	03455493          	srli	s1,a0,0x34
  pte = walk(kernel_pagetable, va, 0);
    800011a4:	4601                	li	a2,0
    800011a6:	00008517          	auipc	a0,0x8
    800011aa:	e6a53503          	ld	a0,-406(a0) # 80009010 <kernel_pagetable>
    800011ae:	00000097          	auipc	ra,0x0
    800011b2:	efc080e7          	jalr	-260(ra) # 800010aa <walk>
  if(pte == 0)
    800011b6:	cd09                	beqz	a0,800011d0 <kvmpa+0x3e>
  if((*pte & PTE_V) == 0)
    800011b8:	6108                	ld	a0,0(a0)
    800011ba:	00157793          	andi	a5,a0,1
    800011be:	c38d                	beqz	a5,800011e0 <kvmpa+0x4e>
  pa = PTE2PA(*pte);
    800011c0:	8129                	srli	a0,a0,0xa
    800011c2:	0532                	slli	a0,a0,0xc
}
    800011c4:	9526                	add	a0,a0,s1
    800011c6:	60e2                	ld	ra,24(sp)
    800011c8:	6442                	ld	s0,16(sp)
    800011ca:	64a2                	ld	s1,8(sp)
    800011cc:	6105                	addi	sp,sp,32
    800011ce:	8082                	ret
    panic("kvmpa");
    800011d0:	00007517          	auipc	a0,0x7
    800011d4:	f2850513          	addi	a0,a0,-216 # 800080f8 <digits+0xb8>
    800011d8:	fffff097          	auipc	ra,0xfffff
    800011dc:	370080e7          	jalr	880(ra) # 80000548 <panic>
    panic("kvmpa");
    800011e0:	00007517          	auipc	a0,0x7
    800011e4:	f1850513          	addi	a0,a0,-232 # 800080f8 <digits+0xb8>
    800011e8:	fffff097          	auipc	ra,0xfffff
    800011ec:	360080e7          	jalr	864(ra) # 80000548 <panic>

00000000800011f0 <mappages>:
{
    800011f0:	715d                	addi	sp,sp,-80
    800011f2:	e486                	sd	ra,72(sp)
    800011f4:	e0a2                	sd	s0,64(sp)
    800011f6:	fc26                	sd	s1,56(sp)
    800011f8:	f84a                	sd	s2,48(sp)
    800011fa:	f44e                	sd	s3,40(sp)
    800011fc:	f052                	sd	s4,32(sp)
    800011fe:	ec56                	sd	s5,24(sp)
    80001200:	e85a                	sd	s6,16(sp)
    80001202:	e45e                	sd	s7,8(sp)
    80001204:	0880                	addi	s0,sp,80
    80001206:	8aaa                	mv	s5,a0
    80001208:	8b3a                	mv	s6,a4
  a = PGROUNDDOWN(va);
    8000120a:	777d                	lui	a4,0xfffff
    8000120c:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001210:	167d                	addi	a2,a2,-1
    80001212:	00b609b3          	add	s3,a2,a1
    80001216:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000121a:	893e                	mv	s2,a5
    8000121c:	40f68a33          	sub	s4,a3,a5
    a += PGSIZE;
    80001220:	6b85                	lui	s7,0x1
    80001222:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001226:	4605                	li	a2,1
    80001228:	85ca                	mv	a1,s2
    8000122a:	8556                	mv	a0,s5
    8000122c:	00000097          	auipc	ra,0x0
    80001230:	e7e080e7          	jalr	-386(ra) # 800010aa <walk>
    80001234:	c51d                	beqz	a0,80001262 <mappages+0x72>
    if(*pte & PTE_V)
    80001236:	611c                	ld	a5,0(a0)
    80001238:	8b85                	andi	a5,a5,1
    8000123a:	ef81                	bnez	a5,80001252 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000123c:	80b1                	srli	s1,s1,0xc
    8000123e:	04aa                	slli	s1,s1,0xa
    80001240:	0164e4b3          	or	s1,s1,s6
    80001244:	0014e493          	ori	s1,s1,1
    80001248:	e104                	sd	s1,0(a0)
    if(a == last)
    8000124a:	03390863          	beq	s2,s3,8000127a <mappages+0x8a>
    a += PGSIZE;
    8000124e:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001250:	bfc9                	j	80001222 <mappages+0x32>
      panic("remap");
    80001252:	00007517          	auipc	a0,0x7
    80001256:	eae50513          	addi	a0,a0,-338 # 80008100 <digits+0xc0>
    8000125a:	fffff097          	auipc	ra,0xfffff
    8000125e:	2ee080e7          	jalr	750(ra) # 80000548 <panic>
      return -1;
    80001262:	557d                	li	a0,-1
}
    80001264:	60a6                	ld	ra,72(sp)
    80001266:	6406                	ld	s0,64(sp)
    80001268:	74e2                	ld	s1,56(sp)
    8000126a:	7942                	ld	s2,48(sp)
    8000126c:	79a2                	ld	s3,40(sp)
    8000126e:	7a02                	ld	s4,32(sp)
    80001270:	6ae2                	ld	s5,24(sp)
    80001272:	6b42                	ld	s6,16(sp)
    80001274:	6ba2                	ld	s7,8(sp)
    80001276:	6161                	addi	sp,sp,80
    80001278:	8082                	ret
  return 0;
    8000127a:	4501                	li	a0,0
    8000127c:	b7e5                	j	80001264 <mappages+0x74>

000000008000127e <kvmmap>:
{
    8000127e:	1141                	addi	sp,sp,-16
    80001280:	e406                	sd	ra,8(sp)
    80001282:	e022                	sd	s0,0(sp)
    80001284:	0800                	addi	s0,sp,16
    80001286:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    80001288:	86ae                	mv	a3,a1
    8000128a:	85aa                	mv	a1,a0
    8000128c:	00008517          	auipc	a0,0x8
    80001290:	d8453503          	ld	a0,-636(a0) # 80009010 <kernel_pagetable>
    80001294:	00000097          	auipc	ra,0x0
    80001298:	f5c080e7          	jalr	-164(ra) # 800011f0 <mappages>
    8000129c:	e509                	bnez	a0,800012a6 <kvmmap+0x28>
}
    8000129e:	60a2                	ld	ra,8(sp)
    800012a0:	6402                	ld	s0,0(sp)
    800012a2:	0141                	addi	sp,sp,16
    800012a4:	8082                	ret
    panic("kvmmap");
    800012a6:	00007517          	auipc	a0,0x7
    800012aa:	e6250513          	addi	a0,a0,-414 # 80008108 <digits+0xc8>
    800012ae:	fffff097          	auipc	ra,0xfffff
    800012b2:	29a080e7          	jalr	666(ra) # 80000548 <panic>

00000000800012b6 <kvminit>:
{
    800012b6:	1101                	addi	sp,sp,-32
    800012b8:	ec06                	sd	ra,24(sp)
    800012ba:	e822                	sd	s0,16(sp)
    800012bc:	e426                	sd	s1,8(sp)
    800012be:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    800012c0:	00000097          	auipc	ra,0x0
    800012c4:	860080e7          	jalr	-1952(ra) # 80000b20 <kalloc>
    800012c8:	00008797          	auipc	a5,0x8
    800012cc:	d4a7b423          	sd	a0,-696(a5) # 80009010 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    800012d0:	6605                	lui	a2,0x1
    800012d2:	4581                	li	a1,0
    800012d4:	00000097          	auipc	ra,0x0
    800012d8:	a38080e7          	jalr	-1480(ra) # 80000d0c <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800012dc:	4699                	li	a3,6
    800012de:	6605                	lui	a2,0x1
    800012e0:	100005b7          	lui	a1,0x10000
    800012e4:	10000537          	lui	a0,0x10000
    800012e8:	00000097          	auipc	ra,0x0
    800012ec:	f96080e7          	jalr	-106(ra) # 8000127e <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800012f0:	4699                	li	a3,6
    800012f2:	6605                	lui	a2,0x1
    800012f4:	100015b7          	lui	a1,0x10001
    800012f8:	10001537          	lui	a0,0x10001
    800012fc:	00000097          	auipc	ra,0x0
    80001300:	f82080e7          	jalr	-126(ra) # 8000127e <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001304:	4699                	li	a3,6
    80001306:	6641                	lui	a2,0x10
    80001308:	020005b7          	lui	a1,0x2000
    8000130c:	02000537          	lui	a0,0x2000
    80001310:	00000097          	auipc	ra,0x0
    80001314:	f6e080e7          	jalr	-146(ra) # 8000127e <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001318:	4699                	li	a3,6
    8000131a:	00400637          	lui	a2,0x400
    8000131e:	0c0005b7          	lui	a1,0xc000
    80001322:	0c000537          	lui	a0,0xc000
    80001326:	00000097          	auipc	ra,0x0
    8000132a:	f58080e7          	jalr	-168(ra) # 8000127e <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000132e:	00007497          	auipc	s1,0x7
    80001332:	cd248493          	addi	s1,s1,-814 # 80008000 <etext>
    80001336:	46a9                	li	a3,10
    80001338:	80007617          	auipc	a2,0x80007
    8000133c:	cc860613          	addi	a2,a2,-824 # 8000 <_entry-0x7fff8000>
    80001340:	4585                	li	a1,1
    80001342:	05fe                	slli	a1,a1,0x1f
    80001344:	852e                	mv	a0,a1
    80001346:	00000097          	auipc	ra,0x0
    8000134a:	f38080e7          	jalr	-200(ra) # 8000127e <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000134e:	4699                	li	a3,6
    80001350:	4645                	li	a2,17
    80001352:	066e                	slli	a2,a2,0x1b
    80001354:	8e05                	sub	a2,a2,s1
    80001356:	85a6                	mv	a1,s1
    80001358:	8526                	mv	a0,s1
    8000135a:	00000097          	auipc	ra,0x0
    8000135e:	f24080e7          	jalr	-220(ra) # 8000127e <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001362:	46a9                	li	a3,10
    80001364:	6605                	lui	a2,0x1
    80001366:	00006597          	auipc	a1,0x6
    8000136a:	c9a58593          	addi	a1,a1,-870 # 80007000 <_trampoline>
    8000136e:	04000537          	lui	a0,0x4000
    80001372:	157d                	addi	a0,a0,-1
    80001374:	0532                	slli	a0,a0,0xc
    80001376:	00000097          	auipc	ra,0x0
    8000137a:	f08080e7          	jalr	-248(ra) # 8000127e <kvmmap>
}
    8000137e:	60e2                	ld	ra,24(sp)
    80001380:	6442                	ld	s0,16(sp)
    80001382:	64a2                	ld	s1,8(sp)
    80001384:	6105                	addi	sp,sp,32
    80001386:	8082                	ret

0000000080001388 <uvmunmap>:
{
    80001388:	715d                	addi	sp,sp,-80
    8000138a:	e486                	sd	ra,72(sp)
    8000138c:	e0a2                	sd	s0,64(sp)
    8000138e:	fc26                	sd	s1,56(sp)
    80001390:	f84a                	sd	s2,48(sp)
    80001392:	f44e                	sd	s3,40(sp)
    80001394:	f052                	sd	s4,32(sp)
    80001396:	ec56                	sd	s5,24(sp)
    80001398:	e85a                	sd	s6,16(sp)
    8000139a:	e45e                	sd	s7,8(sp)
    8000139c:	0880                	addi	s0,sp,80
  if((va % PGSIZE) != 0)
    8000139e:	03459793          	slli	a5,a1,0x34
    800013a2:	e795                	bnez	a5,800013ce <uvmunmap+0x46>
    800013a4:	8a2a                	mv	s4,a0
    800013a6:	892e                	mv	s2,a1
    800013a8:	8b36                	mv	s6,a3
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013aa:	0632                	slli	a2,a2,0xc
    800013ac:	00b609b3          	add	s3,a2,a1
    if(PTE_FLAGS(*pte) == PTE_V)
    800013b0:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013b2:	6a85                	lui	s5,0x1
    800013b4:	0535e963          	bltu	a1,s3,80001406 <uvmunmap+0x7e>
}
    800013b8:	60a6                	ld	ra,72(sp)
    800013ba:	6406                	ld	s0,64(sp)
    800013bc:	74e2                	ld	s1,56(sp)
    800013be:	7942                	ld	s2,48(sp)
    800013c0:	79a2                	ld	s3,40(sp)
    800013c2:	7a02                	ld	s4,32(sp)
    800013c4:	6ae2                	ld	s5,24(sp)
    800013c6:	6b42                	ld	s6,16(sp)
    800013c8:	6ba2                	ld	s7,8(sp)
    800013ca:	6161                	addi	sp,sp,80
    800013cc:	8082                	ret
    panic("uvmunmap: not aligned");
    800013ce:	00007517          	auipc	a0,0x7
    800013d2:	d4250513          	addi	a0,a0,-702 # 80008110 <digits+0xd0>
    800013d6:	fffff097          	auipc	ra,0xfffff
    800013da:	172080e7          	jalr	370(ra) # 80000548 <panic>
      panic("uvmunmap: not a leaf");
    800013de:	00007517          	auipc	a0,0x7
    800013e2:	d4a50513          	addi	a0,a0,-694 # 80008128 <digits+0xe8>
    800013e6:	fffff097          	auipc	ra,0xfffff
    800013ea:	162080e7          	jalr	354(ra) # 80000548 <panic>
      uint64 pa = PTE2PA(*pte);
    800013ee:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800013f0:	00c79513          	slli	a0,a5,0xc
    800013f4:	fffff097          	auipc	ra,0xfffff
    800013f8:	630080e7          	jalr	1584(ra) # 80000a24 <kfree>
    *pte = 0;
    800013fc:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001400:	9956                	add	s2,s2,s5
    80001402:	fb397be3          	bgeu	s2,s3,800013b8 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001406:	4601                	li	a2,0
    80001408:	85ca                	mv	a1,s2
    8000140a:	8552                	mv	a0,s4
    8000140c:	00000097          	auipc	ra,0x0
    80001410:	c9e080e7          	jalr	-866(ra) # 800010aa <walk>
    80001414:	84aa                	mv	s1,a0
    80001416:	d56d                	beqz	a0,80001400 <uvmunmap+0x78>
    if((*pte & PTE_V) == 0)
    80001418:	611c                	ld	a5,0(a0)
    8000141a:	0017f713          	andi	a4,a5,1
    8000141e:	d36d                	beqz	a4,80001400 <uvmunmap+0x78>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001420:	3ff7f713          	andi	a4,a5,1023
    80001424:	fb770de3          	beq	a4,s7,800013de <uvmunmap+0x56>
    if(do_free){
    80001428:	fc0b0ae3          	beqz	s6,800013fc <uvmunmap+0x74>
    8000142c:	b7c9                	j	800013ee <uvmunmap+0x66>

000000008000142e <uvmcreate>:
{
    8000142e:	1101                	addi	sp,sp,-32
    80001430:	ec06                	sd	ra,24(sp)
    80001432:	e822                	sd	s0,16(sp)
    80001434:	e426                	sd	s1,8(sp)
    80001436:	1000                	addi	s0,sp,32
  pagetable = (pagetable_t) kalloc();
    80001438:	fffff097          	auipc	ra,0xfffff
    8000143c:	6e8080e7          	jalr	1768(ra) # 80000b20 <kalloc>
    80001440:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001442:	c519                	beqz	a0,80001450 <uvmcreate+0x22>
  memset(pagetable, 0, PGSIZE);
    80001444:	6605                	lui	a2,0x1
    80001446:	4581                	li	a1,0
    80001448:	00000097          	auipc	ra,0x0
    8000144c:	8c4080e7          	jalr	-1852(ra) # 80000d0c <memset>
}
    80001450:	8526                	mv	a0,s1
    80001452:	60e2                	ld	ra,24(sp)
    80001454:	6442                	ld	s0,16(sp)
    80001456:	64a2                	ld	s1,8(sp)
    80001458:	6105                	addi	sp,sp,32
    8000145a:	8082                	ret

000000008000145c <uvminit>:
{
    8000145c:	7179                	addi	sp,sp,-48
    8000145e:	f406                	sd	ra,40(sp)
    80001460:	f022                	sd	s0,32(sp)
    80001462:	ec26                	sd	s1,24(sp)
    80001464:	e84a                	sd	s2,16(sp)
    80001466:	e44e                	sd	s3,8(sp)
    80001468:	e052                	sd	s4,0(sp)
    8000146a:	1800                	addi	s0,sp,48
  if(sz >= PGSIZE)
    8000146c:	6785                	lui	a5,0x1
    8000146e:	04f67863          	bgeu	a2,a5,800014be <uvminit+0x62>
    80001472:	8a2a                	mv	s4,a0
    80001474:	89ae                	mv	s3,a1
    80001476:	84b2                	mv	s1,a2
  mem = kalloc();
    80001478:	fffff097          	auipc	ra,0xfffff
    8000147c:	6a8080e7          	jalr	1704(ra) # 80000b20 <kalloc>
    80001480:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001482:	6605                	lui	a2,0x1
    80001484:	4581                	li	a1,0
    80001486:	00000097          	auipc	ra,0x0
    8000148a:	886080e7          	jalr	-1914(ra) # 80000d0c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000148e:	4779                	li	a4,30
    80001490:	86ca                	mv	a3,s2
    80001492:	6605                	lui	a2,0x1
    80001494:	4581                	li	a1,0
    80001496:	8552                	mv	a0,s4
    80001498:	00000097          	auipc	ra,0x0
    8000149c:	d58080e7          	jalr	-680(ra) # 800011f0 <mappages>
  memmove(mem, src, sz);
    800014a0:	8626                	mv	a2,s1
    800014a2:	85ce                	mv	a1,s3
    800014a4:	854a                	mv	a0,s2
    800014a6:	00000097          	auipc	ra,0x0
    800014aa:	8c6080e7          	jalr	-1850(ra) # 80000d6c <memmove>
}
    800014ae:	70a2                	ld	ra,40(sp)
    800014b0:	7402                	ld	s0,32(sp)
    800014b2:	64e2                	ld	s1,24(sp)
    800014b4:	6942                	ld	s2,16(sp)
    800014b6:	69a2                	ld	s3,8(sp)
    800014b8:	6a02                	ld	s4,0(sp)
    800014ba:	6145                	addi	sp,sp,48
    800014bc:	8082                	ret
    panic("inituvm: more than a page");
    800014be:	00007517          	auipc	a0,0x7
    800014c2:	c8250513          	addi	a0,a0,-894 # 80008140 <digits+0x100>
    800014c6:	fffff097          	auipc	ra,0xfffff
    800014ca:	082080e7          	jalr	130(ra) # 80000548 <panic>

00000000800014ce <uvmdealloc>:
{
    800014ce:	1101                	addi	sp,sp,-32
    800014d0:	ec06                	sd	ra,24(sp)
    800014d2:	e822                	sd	s0,16(sp)
    800014d4:	e426                	sd	s1,8(sp)
    800014d6:	1000                	addi	s0,sp,32
    return oldsz;
    800014d8:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800014da:	00b67d63          	bgeu	a2,a1,800014f4 <uvmdealloc+0x26>
    800014de:	84b2                	mv	s1,a2
  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800014e0:	6785                	lui	a5,0x1
    800014e2:	17fd                	addi	a5,a5,-1
    800014e4:	00f60733          	add	a4,a2,a5
    800014e8:	767d                	lui	a2,0xfffff
    800014ea:	8f71                	and	a4,a4,a2
    800014ec:	97ae                	add	a5,a5,a1
    800014ee:	8ff1                	and	a5,a5,a2
    800014f0:	00f76863          	bltu	a4,a5,80001500 <uvmdealloc+0x32>
}
    800014f4:	8526                	mv	a0,s1
    800014f6:	60e2                	ld	ra,24(sp)
    800014f8:	6442                	ld	s0,16(sp)
    800014fa:	64a2                	ld	s1,8(sp)
    800014fc:	6105                	addi	sp,sp,32
    800014fe:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001500:	8f99                	sub	a5,a5,a4
    80001502:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001504:	4685                	li	a3,1
    80001506:	0007861b          	sext.w	a2,a5
    8000150a:	85ba                	mv	a1,a4
    8000150c:	00000097          	auipc	ra,0x0
    80001510:	e7c080e7          	jalr	-388(ra) # 80001388 <uvmunmap>
    80001514:	b7c5                	j	800014f4 <uvmdealloc+0x26>

0000000080001516 <uvmalloc>:
  if(newsz < oldsz)
    80001516:	0ab66163          	bltu	a2,a1,800015b8 <uvmalloc+0xa2>
{
    8000151a:	7139                	addi	sp,sp,-64
    8000151c:	fc06                	sd	ra,56(sp)
    8000151e:	f822                	sd	s0,48(sp)
    80001520:	f426                	sd	s1,40(sp)
    80001522:	f04a                	sd	s2,32(sp)
    80001524:	ec4e                	sd	s3,24(sp)
    80001526:	e852                	sd	s4,16(sp)
    80001528:	e456                	sd	s5,8(sp)
    8000152a:	0080                	addi	s0,sp,64
    8000152c:	8aaa                	mv	s5,a0
    8000152e:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001530:	6985                	lui	s3,0x1
    80001532:	19fd                	addi	s3,s3,-1
    80001534:	95ce                	add	a1,a1,s3
    80001536:	79fd                	lui	s3,0xfffff
    80001538:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000153c:	08c9f063          	bgeu	s3,a2,800015bc <uvmalloc+0xa6>
    80001540:	894e                	mv	s2,s3
    mem = kalloc();
    80001542:	fffff097          	auipc	ra,0xfffff
    80001546:	5de080e7          	jalr	1502(ra) # 80000b20 <kalloc>
    8000154a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000154c:	c51d                	beqz	a0,8000157a <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000154e:	6605                	lui	a2,0x1
    80001550:	4581                	li	a1,0
    80001552:	fffff097          	auipc	ra,0xfffff
    80001556:	7ba080e7          	jalr	1978(ra) # 80000d0c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    8000155a:	4779                	li	a4,30
    8000155c:	86a6                	mv	a3,s1
    8000155e:	6605                	lui	a2,0x1
    80001560:	85ca                	mv	a1,s2
    80001562:	8556                	mv	a0,s5
    80001564:	00000097          	auipc	ra,0x0
    80001568:	c8c080e7          	jalr	-884(ra) # 800011f0 <mappages>
    8000156c:	e905                	bnez	a0,8000159c <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000156e:	6785                	lui	a5,0x1
    80001570:	993e                	add	s2,s2,a5
    80001572:	fd4968e3          	bltu	s2,s4,80001542 <uvmalloc+0x2c>
  return newsz;
    80001576:	8552                	mv	a0,s4
    80001578:	a809                	j	8000158a <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000157a:	864e                	mv	a2,s3
    8000157c:	85ca                	mv	a1,s2
    8000157e:	8556                	mv	a0,s5
    80001580:	00000097          	auipc	ra,0x0
    80001584:	f4e080e7          	jalr	-178(ra) # 800014ce <uvmdealloc>
      return 0;
    80001588:	4501                	li	a0,0
}
    8000158a:	70e2                	ld	ra,56(sp)
    8000158c:	7442                	ld	s0,48(sp)
    8000158e:	74a2                	ld	s1,40(sp)
    80001590:	7902                	ld	s2,32(sp)
    80001592:	69e2                	ld	s3,24(sp)
    80001594:	6a42                	ld	s4,16(sp)
    80001596:	6aa2                	ld	s5,8(sp)
    80001598:	6121                	addi	sp,sp,64
    8000159a:	8082                	ret
      kfree(mem);
    8000159c:	8526                	mv	a0,s1
    8000159e:	fffff097          	auipc	ra,0xfffff
    800015a2:	486080e7          	jalr	1158(ra) # 80000a24 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800015a6:	864e                	mv	a2,s3
    800015a8:	85ca                	mv	a1,s2
    800015aa:	8556                	mv	a0,s5
    800015ac:	00000097          	auipc	ra,0x0
    800015b0:	f22080e7          	jalr	-222(ra) # 800014ce <uvmdealloc>
      return 0;
    800015b4:	4501                	li	a0,0
    800015b6:	bfd1                	j	8000158a <uvmalloc+0x74>
    return oldsz;
    800015b8:	852e                	mv	a0,a1
}
    800015ba:	8082                	ret
  return newsz;
    800015bc:	8532                	mv	a0,a2
    800015be:	b7f1                	j	8000158a <uvmalloc+0x74>

00000000800015c0 <freewalk>:
{
    800015c0:	7179                	addi	sp,sp,-48
    800015c2:	f406                	sd	ra,40(sp)
    800015c4:	f022                	sd	s0,32(sp)
    800015c6:	ec26                	sd	s1,24(sp)
    800015c8:	e84a                	sd	s2,16(sp)
    800015ca:	e44e                	sd	s3,8(sp)
    800015cc:	e052                	sd	s4,0(sp)
    800015ce:	1800                	addi	s0,sp,48
    800015d0:	8a2a                	mv	s4,a0
  for(int i = 0; i < 512; i++){
    800015d2:	84aa                	mv	s1,a0
    800015d4:	6905                	lui	s2,0x1
    800015d6:	992a                	add	s2,s2,a0
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015d8:	4985                	li	s3,1
    800015da:	a821                	j	800015f2 <freewalk+0x32>
      uint64 child = PTE2PA(pte);
    800015dc:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800015de:	0532                	slli	a0,a0,0xc
    800015e0:	00000097          	auipc	ra,0x0
    800015e4:	fe0080e7          	jalr	-32(ra) # 800015c0 <freewalk>
      pagetable[i] = 0;
    800015e8:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800015ec:	04a1                	addi	s1,s1,8
    800015ee:	03248163          	beq	s1,s2,80001610 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800015f2:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015f4:	00f57793          	andi	a5,a0,15
    800015f8:	ff3782e3          	beq	a5,s3,800015dc <freewalk+0x1c>
    } else if(pte & PTE_V){
    800015fc:	8905                	andi	a0,a0,1
    800015fe:	d57d                	beqz	a0,800015ec <freewalk+0x2c>
      panic("freewalk: leaf");
    80001600:	00007517          	auipc	a0,0x7
    80001604:	b6050513          	addi	a0,a0,-1184 # 80008160 <digits+0x120>
    80001608:	fffff097          	auipc	ra,0xfffff
    8000160c:	f40080e7          	jalr	-192(ra) # 80000548 <panic>
  kfree((void*)pagetable);
    80001610:	8552                	mv	a0,s4
    80001612:	fffff097          	auipc	ra,0xfffff
    80001616:	412080e7          	jalr	1042(ra) # 80000a24 <kfree>
}
    8000161a:	70a2                	ld	ra,40(sp)
    8000161c:	7402                	ld	s0,32(sp)
    8000161e:	64e2                	ld	s1,24(sp)
    80001620:	6942                	ld	s2,16(sp)
    80001622:	69a2                	ld	s3,8(sp)
    80001624:	6a02                	ld	s4,0(sp)
    80001626:	6145                	addi	sp,sp,48
    80001628:	8082                	ret

000000008000162a <uvmfree>:
{
    8000162a:	1101                	addi	sp,sp,-32
    8000162c:	ec06                	sd	ra,24(sp)
    8000162e:	e822                	sd	s0,16(sp)
    80001630:	e426                	sd	s1,8(sp)
    80001632:	1000                	addi	s0,sp,32
    80001634:	84aa                	mv	s1,a0
  if(sz > 0)
    80001636:	e999                	bnez	a1,8000164c <uvmfree+0x22>
  freewalk(pagetable);
    80001638:	8526                	mv	a0,s1
    8000163a:	00000097          	auipc	ra,0x0
    8000163e:	f86080e7          	jalr	-122(ra) # 800015c0 <freewalk>
}
    80001642:	60e2                	ld	ra,24(sp)
    80001644:	6442                	ld	s0,16(sp)
    80001646:	64a2                	ld	s1,8(sp)
    80001648:	6105                	addi	sp,sp,32
    8000164a:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000164c:	6605                	lui	a2,0x1
    8000164e:	167d                	addi	a2,a2,-1
    80001650:	962e                	add	a2,a2,a1
    80001652:	4685                	li	a3,1
    80001654:	8231                	srli	a2,a2,0xc
    80001656:	4581                	li	a1,0
    80001658:	00000097          	auipc	ra,0x0
    8000165c:	d30080e7          	jalr	-720(ra) # 80001388 <uvmunmap>
    80001660:	bfe1                	j	80001638 <uvmfree+0xe>

0000000080001662 <uvmcopy>:
  for(i = 0; i < sz; i += PGSIZE){
    80001662:	ca4d                	beqz	a2,80001714 <uvmcopy+0xb2>
{
    80001664:	715d                	addi	sp,sp,-80
    80001666:	e486                	sd	ra,72(sp)
    80001668:	e0a2                	sd	s0,64(sp)
    8000166a:	fc26                	sd	s1,56(sp)
    8000166c:	f84a                	sd	s2,48(sp)
    8000166e:	f44e                	sd	s3,40(sp)
    80001670:	f052                	sd	s4,32(sp)
    80001672:	ec56                	sd	s5,24(sp)
    80001674:	e85a                	sd	s6,16(sp)
    80001676:	e45e                	sd	s7,8(sp)
    80001678:	0880                	addi	s0,sp,80
    8000167a:	8aaa                	mv	s5,a0
    8000167c:	8b2e                	mv	s6,a1
    8000167e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001680:	4481                	li	s1,0
    80001682:	a029                	j	8000168c <uvmcopy+0x2a>
    80001684:	6785                	lui	a5,0x1
    80001686:	94be                	add	s1,s1,a5
    80001688:	0744fa63          	bgeu	s1,s4,800016fc <uvmcopy+0x9a>
    if((pte = walk(old, i, 0)) == 0){
    8000168c:	4601                	li	a2,0
    8000168e:	85a6                	mv	a1,s1
    80001690:	8556                	mv	a0,s5
    80001692:	00000097          	auipc	ra,0x0
    80001696:	a18080e7          	jalr	-1512(ra) # 800010aa <walk>
    8000169a:	d56d                	beqz	a0,80001684 <uvmcopy+0x22>
    if((*pte & PTE_V) == 0){
    8000169c:	6118                	ld	a4,0(a0)
    8000169e:	00177793          	andi	a5,a4,1
    800016a2:	d3ed                	beqz	a5,80001684 <uvmcopy+0x22>
    pa = PTE2PA(*pte);
    800016a4:	00a75593          	srli	a1,a4,0xa
    800016a8:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800016ac:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    800016b0:	fffff097          	auipc	ra,0xfffff
    800016b4:	470080e7          	jalr	1136(ra) # 80000b20 <kalloc>
    800016b8:	89aa                	mv	s3,a0
    800016ba:	c515                	beqz	a0,800016e6 <uvmcopy+0x84>
    memmove(mem, (char*)pa, PGSIZE);
    800016bc:	6605                	lui	a2,0x1
    800016be:	85de                	mv	a1,s7
    800016c0:	fffff097          	auipc	ra,0xfffff
    800016c4:	6ac080e7          	jalr	1708(ra) # 80000d6c <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800016c8:	874a                	mv	a4,s2
    800016ca:	86ce                	mv	a3,s3
    800016cc:	6605                	lui	a2,0x1
    800016ce:	85a6                	mv	a1,s1
    800016d0:	855a                	mv	a0,s6
    800016d2:	00000097          	auipc	ra,0x0
    800016d6:	b1e080e7          	jalr	-1250(ra) # 800011f0 <mappages>
    800016da:	d54d                	beqz	a0,80001684 <uvmcopy+0x22>
      kfree(mem);
    800016dc:	854e                	mv	a0,s3
    800016de:	fffff097          	auipc	ra,0xfffff
    800016e2:	346080e7          	jalr	838(ra) # 80000a24 <kfree>
  uvmunmap(new, 0, i / PGSIZE, 1);
    800016e6:	4685                	li	a3,1
    800016e8:	00c4d613          	srli	a2,s1,0xc
    800016ec:	4581                	li	a1,0
    800016ee:	855a                	mv	a0,s6
    800016f0:	00000097          	auipc	ra,0x0
    800016f4:	c98080e7          	jalr	-872(ra) # 80001388 <uvmunmap>
  return -1;
    800016f8:	557d                	li	a0,-1
    800016fa:	a011                	j	800016fe <uvmcopy+0x9c>
  return 0;
    800016fc:	4501                	li	a0,0
}
    800016fe:	60a6                	ld	ra,72(sp)
    80001700:	6406                	ld	s0,64(sp)
    80001702:	74e2                	ld	s1,56(sp)
    80001704:	7942                	ld	s2,48(sp)
    80001706:	79a2                	ld	s3,40(sp)
    80001708:	7a02                	ld	s4,32(sp)
    8000170a:	6ae2                	ld	s5,24(sp)
    8000170c:	6b42                	ld	s6,16(sp)
    8000170e:	6ba2                	ld	s7,8(sp)
    80001710:	6161                	addi	sp,sp,80
    80001712:	8082                	ret
  return 0;
    80001714:	4501                	li	a0,0
}
    80001716:	8082                	ret

0000000080001718 <uvmclear>:
{
    80001718:	1141                	addi	sp,sp,-16
    8000171a:	e406                	sd	ra,8(sp)
    8000171c:	e022                	sd	s0,0(sp)
    8000171e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001720:	4601                	li	a2,0
    80001722:	00000097          	auipc	ra,0x0
    80001726:	988080e7          	jalr	-1656(ra) # 800010aa <walk>
  if(pte == 0)
    8000172a:	c901                	beqz	a0,8000173a <uvmclear+0x22>
  *pte &= ~PTE_U;
    8000172c:	611c                	ld	a5,0(a0)
    8000172e:	9bbd                	andi	a5,a5,-17
    80001730:	e11c                	sd	a5,0(a0)
}
    80001732:	60a2                	ld	ra,8(sp)
    80001734:	6402                	ld	s0,0(sp)
    80001736:	0141                	addi	sp,sp,16
    80001738:	8082                	ret
    panic("uvmclear");
    8000173a:	00007517          	auipc	a0,0x7
    8000173e:	a3650513          	addi	a0,a0,-1482 # 80008170 <digits+0x130>
    80001742:	fffff097          	auipc	ra,0xfffff
    80001746:	e06080e7          	jalr	-506(ra) # 80000548 <panic>

000000008000174a <copyout>:
  while(len > 0){
    8000174a:	c6bd                	beqz	a3,800017b8 <copyout+0x6e>
{
    8000174c:	715d                	addi	sp,sp,-80
    8000174e:	e486                	sd	ra,72(sp)
    80001750:	e0a2                	sd	s0,64(sp)
    80001752:	fc26                	sd	s1,56(sp)
    80001754:	f84a                	sd	s2,48(sp)
    80001756:	f44e                	sd	s3,40(sp)
    80001758:	f052                	sd	s4,32(sp)
    8000175a:	ec56                	sd	s5,24(sp)
    8000175c:	e85a                	sd	s6,16(sp)
    8000175e:	e45e                	sd	s7,8(sp)
    80001760:	e062                	sd	s8,0(sp)
    80001762:	0880                	addi	s0,sp,80
    80001764:	8b2a                	mv	s6,a0
    80001766:	8c2e                	mv	s8,a1
    80001768:	8a32                	mv	s4,a2
    8000176a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000176c:	7bfd                	lui	s7,0xfffff
    n = PGSIZE - (dstva - va0);
    8000176e:	6a85                	lui	s5,0x1
    80001770:	a015                	j	80001794 <copyout+0x4a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001772:	9562                	add	a0,a0,s8
    80001774:	0004861b          	sext.w	a2,s1
    80001778:	85d2                	mv	a1,s4
    8000177a:	41250533          	sub	a0,a0,s2
    8000177e:	fffff097          	auipc	ra,0xfffff
    80001782:	5ee080e7          	jalr	1518(ra) # 80000d6c <memmove>
    len -= n;
    80001786:	409989b3          	sub	s3,s3,s1
    src += n;
    8000178a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000178c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001790:	02098263          	beqz	s3,800017b4 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001794:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001798:	85ca                	mv	a1,s2
    8000179a:	855a                	mv	a0,s6
    8000179c:	00000097          	auipc	ra,0x0
    800017a0:	9b4080e7          	jalr	-1612(ra) # 80001150 <walkaddr>
    if(pa0 == 0)
    800017a4:	cd01                	beqz	a0,800017bc <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800017a6:	418904b3          	sub	s1,s2,s8
    800017aa:	94d6                	add	s1,s1,s5
    if(n > len)
    800017ac:	fc99f3e3          	bgeu	s3,s1,80001772 <copyout+0x28>
    800017b0:	84ce                	mv	s1,s3
    800017b2:	b7c1                	j	80001772 <copyout+0x28>
  return 0;
    800017b4:	4501                	li	a0,0
    800017b6:	a021                	j	800017be <copyout+0x74>
    800017b8:	4501                	li	a0,0
}
    800017ba:	8082                	ret
      return -1;
    800017bc:	557d                	li	a0,-1
}
    800017be:	60a6                	ld	ra,72(sp)
    800017c0:	6406                	ld	s0,64(sp)
    800017c2:	74e2                	ld	s1,56(sp)
    800017c4:	7942                	ld	s2,48(sp)
    800017c6:	79a2                	ld	s3,40(sp)
    800017c8:	7a02                	ld	s4,32(sp)
    800017ca:	6ae2                	ld	s5,24(sp)
    800017cc:	6b42                	ld	s6,16(sp)
    800017ce:	6ba2                	ld	s7,8(sp)
    800017d0:	6c02                	ld	s8,0(sp)
    800017d2:	6161                	addi	sp,sp,80
    800017d4:	8082                	ret

00000000800017d6 <copyin>:
  while(len > 0){
    800017d6:	c6bd                	beqz	a3,80001844 <copyin+0x6e>
{
    800017d8:	715d                	addi	sp,sp,-80
    800017da:	e486                	sd	ra,72(sp)
    800017dc:	e0a2                	sd	s0,64(sp)
    800017de:	fc26                	sd	s1,56(sp)
    800017e0:	f84a                	sd	s2,48(sp)
    800017e2:	f44e                	sd	s3,40(sp)
    800017e4:	f052                	sd	s4,32(sp)
    800017e6:	ec56                	sd	s5,24(sp)
    800017e8:	e85a                	sd	s6,16(sp)
    800017ea:	e45e                	sd	s7,8(sp)
    800017ec:	e062                	sd	s8,0(sp)
    800017ee:	0880                	addi	s0,sp,80
    800017f0:	8b2a                	mv	s6,a0
    800017f2:	8a2e                	mv	s4,a1
    800017f4:	8c32                	mv	s8,a2
    800017f6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800017f8:	7bfd                	lui	s7,0xfffff
    n = PGSIZE - (srcva - va0);
    800017fa:	6a85                	lui	s5,0x1
    800017fc:	a015                	j	80001820 <copyin+0x4a>
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800017fe:	9562                	add	a0,a0,s8
    80001800:	0004861b          	sext.w	a2,s1
    80001804:	412505b3          	sub	a1,a0,s2
    80001808:	8552                	mv	a0,s4
    8000180a:	fffff097          	auipc	ra,0xfffff
    8000180e:	562080e7          	jalr	1378(ra) # 80000d6c <memmove>
    len -= n;
    80001812:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001816:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001818:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000181c:	02098263          	beqz	s3,80001840 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80001820:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001824:	85ca                	mv	a1,s2
    80001826:	855a                	mv	a0,s6
    80001828:	00000097          	auipc	ra,0x0
    8000182c:	928080e7          	jalr	-1752(ra) # 80001150 <walkaddr>
    if(pa0 == 0)
    80001830:	cd01                	beqz	a0,80001848 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80001832:	418904b3          	sub	s1,s2,s8
    80001836:	94d6                	add	s1,s1,s5
    if(n > len)
    80001838:	fc99f3e3          	bgeu	s3,s1,800017fe <copyin+0x28>
    8000183c:	84ce                	mv	s1,s3
    8000183e:	b7c1                	j	800017fe <copyin+0x28>
  return 0;
    80001840:	4501                	li	a0,0
    80001842:	a021                	j	8000184a <copyin+0x74>
    80001844:	4501                	li	a0,0
}
    80001846:	8082                	ret
      return -1;
    80001848:	557d                	li	a0,-1
}
    8000184a:	60a6                	ld	ra,72(sp)
    8000184c:	6406                	ld	s0,64(sp)
    8000184e:	74e2                	ld	s1,56(sp)
    80001850:	7942                	ld	s2,48(sp)
    80001852:	79a2                	ld	s3,40(sp)
    80001854:	7a02                	ld	s4,32(sp)
    80001856:	6ae2                	ld	s5,24(sp)
    80001858:	6b42                	ld	s6,16(sp)
    8000185a:	6ba2                	ld	s7,8(sp)
    8000185c:	6c02                	ld	s8,0(sp)
    8000185e:	6161                	addi	sp,sp,80
    80001860:	8082                	ret

0000000080001862 <copyinstr>:
  while(got_null == 0 && max > 0){
    80001862:	c6c5                	beqz	a3,8000190a <copyinstr+0xa8>
{
    80001864:	715d                	addi	sp,sp,-80
    80001866:	e486                	sd	ra,72(sp)
    80001868:	e0a2                	sd	s0,64(sp)
    8000186a:	fc26                	sd	s1,56(sp)
    8000186c:	f84a                	sd	s2,48(sp)
    8000186e:	f44e                	sd	s3,40(sp)
    80001870:	f052                	sd	s4,32(sp)
    80001872:	ec56                	sd	s5,24(sp)
    80001874:	e85a                	sd	s6,16(sp)
    80001876:	e45e                	sd	s7,8(sp)
    80001878:	0880                	addi	s0,sp,80
    8000187a:	8a2a                	mv	s4,a0
    8000187c:	8b2e                	mv	s6,a1
    8000187e:	8bb2                	mv	s7,a2
    80001880:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001882:	7afd                	lui	s5,0xfffff
    n = PGSIZE - (srcva - va0);
    80001884:	6985                	lui	s3,0x1
    80001886:	a035                	j	800018b2 <copyinstr+0x50>
        *dst = '\0';
    80001888:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000188c:	4785                	li	a5,1
  if(got_null){
    8000188e:	0017b793          	seqz	a5,a5
    80001892:	40f00533          	neg	a0,a5
}
    80001896:	60a6                	ld	ra,72(sp)
    80001898:	6406                	ld	s0,64(sp)
    8000189a:	74e2                	ld	s1,56(sp)
    8000189c:	7942                	ld	s2,48(sp)
    8000189e:	79a2                	ld	s3,40(sp)
    800018a0:	7a02                	ld	s4,32(sp)
    800018a2:	6ae2                	ld	s5,24(sp)
    800018a4:	6b42                	ld	s6,16(sp)
    800018a6:	6ba2                	ld	s7,8(sp)
    800018a8:	6161                	addi	sp,sp,80
    800018aa:	8082                	ret
    srcva = va0 + PGSIZE;
    800018ac:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800018b0:	c8a9                	beqz	s1,80001902 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800018b2:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800018b6:	85ca                	mv	a1,s2
    800018b8:	8552                	mv	a0,s4
    800018ba:	00000097          	auipc	ra,0x0
    800018be:	896080e7          	jalr	-1898(ra) # 80001150 <walkaddr>
    if(pa0 == 0)
    800018c2:	c131                	beqz	a0,80001906 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800018c4:	41790833          	sub	a6,s2,s7
    800018c8:	984e                	add	a6,a6,s3
    if(n > max)
    800018ca:	0104f363          	bgeu	s1,a6,800018d0 <copyinstr+0x6e>
    800018ce:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800018d0:	955e                	add	a0,a0,s7
    800018d2:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800018d6:	fc080be3          	beqz	a6,800018ac <copyinstr+0x4a>
    800018da:	985a                	add	a6,a6,s6
    800018dc:	87da                	mv	a5,s6
      if(*p == '\0'){
    800018de:	41650633          	sub	a2,a0,s6
    800018e2:	14fd                	addi	s1,s1,-1
    800018e4:	9b26                	add	s6,s6,s1
    800018e6:	00f60733          	add	a4,a2,a5
    800018ea:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd9000>
    800018ee:	df49                	beqz	a4,80001888 <copyinstr+0x26>
        *dst = *p;
    800018f0:	00e78023          	sb	a4,0(a5)
      --max;
    800018f4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800018f8:	0785                	addi	a5,a5,1
    while(n > 0){
    800018fa:	ff0796e3          	bne	a5,a6,800018e6 <copyinstr+0x84>
      dst++;
    800018fe:	8b42                	mv	s6,a6
    80001900:	b775                	j	800018ac <copyinstr+0x4a>
    80001902:	4781                	li	a5,0
    80001904:	b769                	j	8000188e <copyinstr+0x2c>
      return -1;
    80001906:	557d                	li	a0,-1
    80001908:	b779                	j	80001896 <copyinstr+0x34>
  int got_null = 0;
    8000190a:	4781                	li	a5,0
  if(got_null){
    8000190c:	0017b793          	seqz	a5,a5
    80001910:	40f00533          	neg	a0,a5
}
    80001914:	8082                	ret

0000000080001916 <vmprint>:
void vmprint(pagetable_t pagetable){
    80001916:	1101                	addi	sp,sp,-32
    80001918:	ec06                	sd	ra,24(sp)
    8000191a:	e822                	sd	s0,16(sp)
    8000191c:	e426                	sd	s1,8(sp)
    8000191e:	1000                	addi	s0,sp,32
    80001920:	84aa                	mv	s1,a0
    printf("page table %p\n",pagetable);
    80001922:	85aa                	mv	a1,a0
    80001924:	00007517          	auipc	a0,0x7
    80001928:	85c50513          	addi	a0,a0,-1956 # 80008180 <digits+0x140>
    8000192c:	fffff097          	auipc	ra,0xfffff
    80001930:	c66080e7          	jalr	-922(ra) # 80000592 <printf>
    vmprint_helper(pagetable,1);
    80001934:	4585                	li	a1,1
    80001936:	8526                	mv	a0,s1
    80001938:	fffff097          	auipc	ra,0xfffff
    8000193c:	69c080e7          	jalr	1692(ra) # 80000fd4 <vmprint_helper>
    return;
}
    80001940:	60e2                	ld	ra,24(sp)
    80001942:	6442                	ld	s0,16(sp)
    80001944:	64a2                	ld	s1,8(sp)
    80001946:	6105                	addi	sp,sp,32
    80001948:	8082                	ret

000000008000194a <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    8000194a:	1101                	addi	sp,sp,-32
    8000194c:	ec06                	sd	ra,24(sp)
    8000194e:	e822                	sd	s0,16(sp)
    80001950:	e426                	sd	s1,8(sp)
    80001952:	1000                	addi	s0,sp,32
    80001954:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001956:	fffff097          	auipc	ra,0xfffff
    8000195a:	240080e7          	jalr	576(ra) # 80000b96 <holding>
    8000195e:	c909                	beqz	a0,80001970 <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80001960:	749c                	ld	a5,40(s1)
    80001962:	00978f63          	beq	a5,s1,80001980 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001966:	60e2                	ld	ra,24(sp)
    80001968:	6442                	ld	s0,16(sp)
    8000196a:	64a2                	ld	s1,8(sp)
    8000196c:	6105                	addi	sp,sp,32
    8000196e:	8082                	ret
    panic("wakeup1");
    80001970:	00007517          	auipc	a0,0x7
    80001974:	82050513          	addi	a0,a0,-2016 # 80008190 <digits+0x150>
    80001978:	fffff097          	auipc	ra,0xfffff
    8000197c:	bd0080e7          	jalr	-1072(ra) # 80000548 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001980:	4c98                	lw	a4,24(s1)
    80001982:	4785                	li	a5,1
    80001984:	fef711e3          	bne	a4,a5,80001966 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001988:	4789                	li	a5,2
    8000198a:	cc9c                	sw	a5,24(s1)
}
    8000198c:	bfe9                	j	80001966 <wakeup1+0x1c>

000000008000198e <procinit>:
{
    8000198e:	715d                	addi	sp,sp,-80
    80001990:	e486                	sd	ra,72(sp)
    80001992:	e0a2                	sd	s0,64(sp)
    80001994:	fc26                	sd	s1,56(sp)
    80001996:	f84a                	sd	s2,48(sp)
    80001998:	f44e                	sd	s3,40(sp)
    8000199a:	f052                	sd	s4,32(sp)
    8000199c:	ec56                	sd	s5,24(sp)
    8000199e:	e85a                	sd	s6,16(sp)
    800019a0:	e45e                	sd	s7,8(sp)
    800019a2:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    800019a4:	00006597          	auipc	a1,0x6
    800019a8:	7f458593          	addi	a1,a1,2036 # 80008198 <digits+0x158>
    800019ac:	00010517          	auipc	a0,0x10
    800019b0:	fa450513          	addi	a0,a0,-92 # 80011950 <pid_lock>
    800019b4:	fffff097          	auipc	ra,0xfffff
    800019b8:	1cc080e7          	jalr	460(ra) # 80000b80 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019bc:	00010917          	auipc	s2,0x10
    800019c0:	3ac90913          	addi	s2,s2,940 # 80011d68 <proc>
      initlock(&p->lock, "proc");
    800019c4:	00006b97          	auipc	s7,0x6
    800019c8:	7dcb8b93          	addi	s7,s7,2012 # 800081a0 <digits+0x160>
      uint64 va = KSTACK((int) (p - proc));
    800019cc:	8b4a                	mv	s6,s2
    800019ce:	00006a97          	auipc	s5,0x6
    800019d2:	632a8a93          	addi	s5,s5,1586 # 80008000 <etext>
    800019d6:	040009b7          	lui	s3,0x4000
    800019da:	19fd                	addi	s3,s3,-1
    800019dc:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800019de:	00016a17          	auipc	s4,0x16
    800019e2:	18aa0a13          	addi	s4,s4,394 # 80017b68 <tickslock>
      initlock(&p->lock, "proc");
    800019e6:	85de                	mv	a1,s7
    800019e8:	854a                	mv	a0,s2
    800019ea:	fffff097          	auipc	ra,0xfffff
    800019ee:	196080e7          	jalr	406(ra) # 80000b80 <initlock>
      char *pa = kalloc();
    800019f2:	fffff097          	auipc	ra,0xfffff
    800019f6:	12e080e7          	jalr	302(ra) # 80000b20 <kalloc>
    800019fa:	85aa                	mv	a1,a0
      if(pa == 0)
    800019fc:	c929                	beqz	a0,80001a4e <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    800019fe:	416904b3          	sub	s1,s2,s6
    80001a02:	848d                	srai	s1,s1,0x3
    80001a04:	000ab783          	ld	a5,0(s5)
    80001a08:	02f484b3          	mul	s1,s1,a5
    80001a0c:	2485                	addiw	s1,s1,1
    80001a0e:	00d4949b          	slliw	s1,s1,0xd
    80001a12:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001a16:	4699                	li	a3,6
    80001a18:	6605                	lui	a2,0x1
    80001a1a:	8526                	mv	a0,s1
    80001a1c:	00000097          	auipc	ra,0x0
    80001a20:	862080e7          	jalr	-1950(ra) # 8000127e <kvmmap>
      p->kstack = va;
    80001a24:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a28:	17890913          	addi	s2,s2,376
    80001a2c:	fb491de3          	bne	s2,s4,800019e6 <procinit+0x58>
  kvminithart();
    80001a30:	fffff097          	auipc	ra,0xfffff
    80001a34:	656080e7          	jalr	1622(ra) # 80001086 <kvminithart>
}
    80001a38:	60a6                	ld	ra,72(sp)
    80001a3a:	6406                	ld	s0,64(sp)
    80001a3c:	74e2                	ld	s1,56(sp)
    80001a3e:	7942                	ld	s2,48(sp)
    80001a40:	79a2                	ld	s3,40(sp)
    80001a42:	7a02                	ld	s4,32(sp)
    80001a44:	6ae2                	ld	s5,24(sp)
    80001a46:	6b42                	ld	s6,16(sp)
    80001a48:	6ba2                	ld	s7,8(sp)
    80001a4a:	6161                	addi	sp,sp,80
    80001a4c:	8082                	ret
        panic("kalloc");
    80001a4e:	00006517          	auipc	a0,0x6
    80001a52:	75a50513          	addi	a0,a0,1882 # 800081a8 <digits+0x168>
    80001a56:	fffff097          	auipc	ra,0xfffff
    80001a5a:	af2080e7          	jalr	-1294(ra) # 80000548 <panic>

0000000080001a5e <cpuid>:
{
    80001a5e:	1141                	addi	sp,sp,-16
    80001a60:	e422                	sd	s0,8(sp)
    80001a62:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a64:	8512                	mv	a0,tp
}
    80001a66:	2501                	sext.w	a0,a0
    80001a68:	6422                	ld	s0,8(sp)
    80001a6a:	0141                	addi	sp,sp,16
    80001a6c:	8082                	ret

0000000080001a6e <mycpu>:
mycpu(void) {
    80001a6e:	1141                	addi	sp,sp,-16
    80001a70:	e422                	sd	s0,8(sp)
    80001a72:	0800                	addi	s0,sp,16
    80001a74:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001a76:	2781                	sext.w	a5,a5
    80001a78:	079e                	slli	a5,a5,0x7
}
    80001a7a:	00010517          	auipc	a0,0x10
    80001a7e:	eee50513          	addi	a0,a0,-274 # 80011968 <cpus>
    80001a82:	953e                	add	a0,a0,a5
    80001a84:	6422                	ld	s0,8(sp)
    80001a86:	0141                	addi	sp,sp,16
    80001a88:	8082                	ret

0000000080001a8a <myproc>:
myproc(void) {
    80001a8a:	1101                	addi	sp,sp,-32
    80001a8c:	ec06                	sd	ra,24(sp)
    80001a8e:	e822                	sd	s0,16(sp)
    80001a90:	e426                	sd	s1,8(sp)
    80001a92:	1000                	addi	s0,sp,32
  push_off();
    80001a94:	fffff097          	auipc	ra,0xfffff
    80001a98:	130080e7          	jalr	304(ra) # 80000bc4 <push_off>
    80001a9c:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001a9e:	2781                	sext.w	a5,a5
    80001aa0:	079e                	slli	a5,a5,0x7
    80001aa2:	00010717          	auipc	a4,0x10
    80001aa6:	eae70713          	addi	a4,a4,-338 # 80011950 <pid_lock>
    80001aaa:	97ba                	add	a5,a5,a4
    80001aac:	6f84                	ld	s1,24(a5)
  pop_off();
    80001aae:	fffff097          	auipc	ra,0xfffff
    80001ab2:	1b6080e7          	jalr	438(ra) # 80000c64 <pop_off>
}
    80001ab6:	8526                	mv	a0,s1
    80001ab8:	60e2                	ld	ra,24(sp)
    80001aba:	6442                	ld	s0,16(sp)
    80001abc:	64a2                	ld	s1,8(sp)
    80001abe:	6105                	addi	sp,sp,32
    80001ac0:	8082                	ret

0000000080001ac2 <forkret>:
{
    80001ac2:	1141                	addi	sp,sp,-16
    80001ac4:	e406                	sd	ra,8(sp)
    80001ac6:	e022                	sd	s0,0(sp)
    80001ac8:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001aca:	00000097          	auipc	ra,0x0
    80001ace:	fc0080e7          	jalr	-64(ra) # 80001a8a <myproc>
    80001ad2:	fffff097          	auipc	ra,0xfffff
    80001ad6:	1f2080e7          	jalr	498(ra) # 80000cc4 <release>
  if (first) {
    80001ada:	00007797          	auipc	a5,0x7
    80001ade:	d267a783          	lw	a5,-730(a5) # 80008800 <first.1666>
    80001ae2:	eb89                	bnez	a5,80001af4 <forkret+0x32>
  usertrapret();
    80001ae4:	00001097          	auipc	ra,0x1
    80001ae8:	c44080e7          	jalr	-956(ra) # 80002728 <usertrapret>
}
    80001aec:	60a2                	ld	ra,8(sp)
    80001aee:	6402                	ld	s0,0(sp)
    80001af0:	0141                	addi	sp,sp,16
    80001af2:	8082                	ret
    first = 0;
    80001af4:	00007797          	auipc	a5,0x7
    80001af8:	d007a623          	sw	zero,-756(a5) # 80008800 <first.1666>
    fsinit(ROOTDEV);
    80001afc:	4505                	li	a0,1
    80001afe:	00002097          	auipc	ra,0x2
    80001b02:	a0c080e7          	jalr	-1524(ra) # 8000350a <fsinit>
    80001b06:	bff9                	j	80001ae4 <forkret+0x22>

0000000080001b08 <allocpid>:
allocpid() {
    80001b08:	1101                	addi	sp,sp,-32
    80001b0a:	ec06                	sd	ra,24(sp)
    80001b0c:	e822                	sd	s0,16(sp)
    80001b0e:	e426                	sd	s1,8(sp)
    80001b10:	e04a                	sd	s2,0(sp)
    80001b12:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001b14:	00010917          	auipc	s2,0x10
    80001b18:	e3c90913          	addi	s2,s2,-452 # 80011950 <pid_lock>
    80001b1c:	854a                	mv	a0,s2
    80001b1e:	fffff097          	auipc	ra,0xfffff
    80001b22:	0f2080e7          	jalr	242(ra) # 80000c10 <acquire>
  pid = nextpid;
    80001b26:	00007797          	auipc	a5,0x7
    80001b2a:	cde78793          	addi	a5,a5,-802 # 80008804 <nextpid>
    80001b2e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001b30:	0014871b          	addiw	a4,s1,1
    80001b34:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001b36:	854a                	mv	a0,s2
    80001b38:	fffff097          	auipc	ra,0xfffff
    80001b3c:	18c080e7          	jalr	396(ra) # 80000cc4 <release>
}
    80001b40:	8526                	mv	a0,s1
    80001b42:	60e2                	ld	ra,24(sp)
    80001b44:	6442                	ld	s0,16(sp)
    80001b46:	64a2                	ld	s1,8(sp)
    80001b48:	6902                	ld	s2,0(sp)
    80001b4a:	6105                	addi	sp,sp,32
    80001b4c:	8082                	ret

0000000080001b4e <proc_pagetable>:
{
    80001b4e:	1101                	addi	sp,sp,-32
    80001b50:	ec06                	sd	ra,24(sp)
    80001b52:	e822                	sd	s0,16(sp)
    80001b54:	e426                	sd	s1,8(sp)
    80001b56:	e04a                	sd	s2,0(sp)
    80001b58:	1000                	addi	s0,sp,32
    80001b5a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b5c:	00000097          	auipc	ra,0x0
    80001b60:	8d2080e7          	jalr	-1838(ra) # 8000142e <uvmcreate>
    80001b64:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001b66:	c121                	beqz	a0,80001ba6 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b68:	4729                	li	a4,10
    80001b6a:	00005697          	auipc	a3,0x5
    80001b6e:	49668693          	addi	a3,a3,1174 # 80007000 <_trampoline>
    80001b72:	6605                	lui	a2,0x1
    80001b74:	040005b7          	lui	a1,0x4000
    80001b78:	15fd                	addi	a1,a1,-1
    80001b7a:	05b2                	slli	a1,a1,0xc
    80001b7c:	fffff097          	auipc	ra,0xfffff
    80001b80:	674080e7          	jalr	1652(ra) # 800011f0 <mappages>
    80001b84:	02054863          	bltz	a0,80001bb4 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b88:	4719                	li	a4,6
    80001b8a:	06893683          	ld	a3,104(s2)
    80001b8e:	6605                	lui	a2,0x1
    80001b90:	020005b7          	lui	a1,0x2000
    80001b94:	15fd                	addi	a1,a1,-1
    80001b96:	05b6                	slli	a1,a1,0xd
    80001b98:	8526                	mv	a0,s1
    80001b9a:	fffff097          	auipc	ra,0xfffff
    80001b9e:	656080e7          	jalr	1622(ra) # 800011f0 <mappages>
    80001ba2:	02054163          	bltz	a0,80001bc4 <proc_pagetable+0x76>
}
    80001ba6:	8526                	mv	a0,s1
    80001ba8:	60e2                	ld	ra,24(sp)
    80001baa:	6442                	ld	s0,16(sp)
    80001bac:	64a2                	ld	s1,8(sp)
    80001bae:	6902                	ld	s2,0(sp)
    80001bb0:	6105                	addi	sp,sp,32
    80001bb2:	8082                	ret
    uvmfree(pagetable, 0);
    80001bb4:	4581                	li	a1,0
    80001bb6:	8526                	mv	a0,s1
    80001bb8:	00000097          	auipc	ra,0x0
    80001bbc:	a72080e7          	jalr	-1422(ra) # 8000162a <uvmfree>
    return 0;
    80001bc0:	4481                	li	s1,0
    80001bc2:	b7d5                	j	80001ba6 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001bc4:	4681                	li	a3,0
    80001bc6:	4605                	li	a2,1
    80001bc8:	040005b7          	lui	a1,0x4000
    80001bcc:	15fd                	addi	a1,a1,-1
    80001bce:	05b2                	slli	a1,a1,0xc
    80001bd0:	8526                	mv	a0,s1
    80001bd2:	fffff097          	auipc	ra,0xfffff
    80001bd6:	7b6080e7          	jalr	1974(ra) # 80001388 <uvmunmap>
    uvmfree(pagetable, 0);
    80001bda:	4581                	li	a1,0
    80001bdc:	8526                	mv	a0,s1
    80001bde:	00000097          	auipc	ra,0x0
    80001be2:	a4c080e7          	jalr	-1460(ra) # 8000162a <uvmfree>
    return 0;
    80001be6:	4481                	li	s1,0
    80001be8:	bf7d                	j	80001ba6 <proc_pagetable+0x58>

0000000080001bea <proc_freepagetable>:
{
    80001bea:	1101                	addi	sp,sp,-32
    80001bec:	ec06                	sd	ra,24(sp)
    80001bee:	e822                	sd	s0,16(sp)
    80001bf0:	e426                	sd	s1,8(sp)
    80001bf2:	e04a                	sd	s2,0(sp)
    80001bf4:	1000                	addi	s0,sp,32
    80001bf6:	84aa                	mv	s1,a0
    80001bf8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001bfa:	4681                	li	a3,0
    80001bfc:	4605                	li	a2,1
    80001bfe:	040005b7          	lui	a1,0x4000
    80001c02:	15fd                	addi	a1,a1,-1
    80001c04:	05b2                	slli	a1,a1,0xc
    80001c06:	fffff097          	auipc	ra,0xfffff
    80001c0a:	782080e7          	jalr	1922(ra) # 80001388 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001c0e:	4681                	li	a3,0
    80001c10:	4605                	li	a2,1
    80001c12:	020005b7          	lui	a1,0x2000
    80001c16:	15fd                	addi	a1,a1,-1
    80001c18:	05b6                	slli	a1,a1,0xd
    80001c1a:	8526                	mv	a0,s1
    80001c1c:	fffff097          	auipc	ra,0xfffff
    80001c20:	76c080e7          	jalr	1900(ra) # 80001388 <uvmunmap>
  uvmfree(pagetable, sz);
    80001c24:	85ca                	mv	a1,s2
    80001c26:	8526                	mv	a0,s1
    80001c28:	00000097          	auipc	ra,0x0
    80001c2c:	a02080e7          	jalr	-1534(ra) # 8000162a <uvmfree>
}
    80001c30:	60e2                	ld	ra,24(sp)
    80001c32:	6442                	ld	s0,16(sp)
    80001c34:	64a2                	ld	s1,8(sp)
    80001c36:	6902                	ld	s2,0(sp)
    80001c38:	6105                	addi	sp,sp,32
    80001c3a:	8082                	ret

0000000080001c3c <freeproc>:
{
    80001c3c:	1101                	addi	sp,sp,-32
    80001c3e:	ec06                	sd	ra,24(sp)
    80001c40:	e822                	sd	s0,16(sp)
    80001c42:	e426                	sd	s1,8(sp)
    80001c44:	1000                	addi	s0,sp,32
    80001c46:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001c48:	7528                	ld	a0,104(a0)
    80001c4a:	c509                	beqz	a0,80001c54 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001c4c:	fffff097          	auipc	ra,0xfffff
    80001c50:	dd8080e7          	jalr	-552(ra) # 80000a24 <kfree>
  p->trapframe = 0;
    80001c54:	0604b423          	sd	zero,104(s1)
  printf("p->sz = %p,p->maxva = %p\n",p->sz,p->maxva);
    80001c58:	6cb0                	ld	a2,88(s1)
    80001c5a:	68ac                	ld	a1,80(s1)
    80001c5c:	00006517          	auipc	a0,0x6
    80001c60:	55450513          	addi	a0,a0,1364 # 800081b0 <digits+0x170>
    80001c64:	fffff097          	auipc	ra,0xfffff
    80001c68:	92e080e7          	jalr	-1746(ra) # 80000592 <printf>
  if(p->pagetable)
    80001c6c:	70a8                	ld	a0,96(s1)
    80001c6e:	c511                	beqz	a0,80001c7a <freeproc+0x3e>
    proc_freepagetable(p->pagetable, p->maxva);
    80001c70:	6cac                	ld	a1,88(s1)
    80001c72:	00000097          	auipc	ra,0x0
    80001c76:	f78080e7          	jalr	-136(ra) # 80001bea <proc_freepagetable>
  p->pagetable = 0;
    80001c7a:	0604b023          	sd	zero,96(s1)
  p->sz = 0;
    80001c7e:	0404b823          	sd	zero,80(s1)
  p->maxva = 0;
    80001c82:	0404bc23          	sd	zero,88(s1)
  p->pid = 0;
    80001c86:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001c8a:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001c8e:	16048423          	sb	zero,360(s1)
  p->chan = 0;
    80001c92:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001c96:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001c9a:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001c9e:	0004ac23          	sw	zero,24(s1)
}
    80001ca2:	60e2                	ld	ra,24(sp)
    80001ca4:	6442                	ld	s0,16(sp)
    80001ca6:	64a2                	ld	s1,8(sp)
    80001ca8:	6105                	addi	sp,sp,32
    80001caa:	8082                	ret

0000000080001cac <allocproc>:
{
    80001cac:	1101                	addi	sp,sp,-32
    80001cae:	ec06                	sd	ra,24(sp)
    80001cb0:	e822                	sd	s0,16(sp)
    80001cb2:	e426                	sd	s1,8(sp)
    80001cb4:	e04a                	sd	s2,0(sp)
    80001cb6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cb8:	00010497          	auipc	s1,0x10
    80001cbc:	0b048493          	addi	s1,s1,176 # 80011d68 <proc>
    80001cc0:	00016917          	auipc	s2,0x16
    80001cc4:	ea890913          	addi	s2,s2,-344 # 80017b68 <tickslock>
    acquire(&p->lock);
    80001cc8:	8526                	mv	a0,s1
    80001cca:	fffff097          	auipc	ra,0xfffff
    80001cce:	f46080e7          	jalr	-186(ra) # 80000c10 <acquire>
    if(p->state == UNUSED) {
    80001cd2:	4c9c                	lw	a5,24(s1)
    80001cd4:	cf81                	beqz	a5,80001cec <allocproc+0x40>
      release(&p->lock);
    80001cd6:	8526                	mv	a0,s1
    80001cd8:	fffff097          	auipc	ra,0xfffff
    80001cdc:	fec080e7          	jalr	-20(ra) # 80000cc4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ce0:	17848493          	addi	s1,s1,376
    80001ce4:	ff2492e3          	bne	s1,s2,80001cc8 <allocproc+0x1c>
  return 0;
    80001ce8:	4481                	li	s1,0
    80001cea:	a0b9                	j	80001d38 <allocproc+0x8c>
  p->pid = allocpid();
    80001cec:	00000097          	auipc	ra,0x0
    80001cf0:	e1c080e7          	jalr	-484(ra) # 80001b08 <allocpid>
    80001cf4:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001cf6:	fffff097          	auipc	ra,0xfffff
    80001cfa:	e2a080e7          	jalr	-470(ra) # 80000b20 <kalloc>
    80001cfe:	892a                	mv	s2,a0
    80001d00:	f4a8                	sd	a0,104(s1)
    80001d02:	c131                	beqz	a0,80001d46 <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80001d04:	8526                	mv	a0,s1
    80001d06:	00000097          	auipc	ra,0x0
    80001d0a:	e48080e7          	jalr	-440(ra) # 80001b4e <proc_pagetable>
    80001d0e:	892a                	mv	s2,a0
    80001d10:	f0a8                	sd	a0,96(s1)
  if(p->pagetable == 0){
    80001d12:	c129                	beqz	a0,80001d54 <allocproc+0xa8>
  memset(&p->context, 0, sizeof(p->context));
    80001d14:	07000613          	li	a2,112
    80001d18:	4581                	li	a1,0
    80001d1a:	07048513          	addi	a0,s1,112
    80001d1e:	fffff097          	auipc	ra,0xfffff
    80001d22:	fee080e7          	jalr	-18(ra) # 80000d0c <memset>
  p->context.ra = (uint64)forkret;
    80001d26:	00000797          	auipc	a5,0x0
    80001d2a:	d9c78793          	addi	a5,a5,-612 # 80001ac2 <forkret>
    80001d2e:	f8bc                	sd	a5,112(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001d30:	60bc                	ld	a5,64(s1)
    80001d32:	6705                	lui	a4,0x1
    80001d34:	97ba                	add	a5,a5,a4
    80001d36:	fcbc                	sd	a5,120(s1)
}
    80001d38:	8526                	mv	a0,s1
    80001d3a:	60e2                	ld	ra,24(sp)
    80001d3c:	6442                	ld	s0,16(sp)
    80001d3e:	64a2                	ld	s1,8(sp)
    80001d40:	6902                	ld	s2,0(sp)
    80001d42:	6105                	addi	sp,sp,32
    80001d44:	8082                	ret
    release(&p->lock);
    80001d46:	8526                	mv	a0,s1
    80001d48:	fffff097          	auipc	ra,0xfffff
    80001d4c:	f7c080e7          	jalr	-132(ra) # 80000cc4 <release>
    return 0;
    80001d50:	84ca                	mv	s1,s2
    80001d52:	b7dd                	j	80001d38 <allocproc+0x8c>
    freeproc(p);
    80001d54:	8526                	mv	a0,s1
    80001d56:	00000097          	auipc	ra,0x0
    80001d5a:	ee6080e7          	jalr	-282(ra) # 80001c3c <freeproc>
    release(&p->lock);
    80001d5e:	8526                	mv	a0,s1
    80001d60:	fffff097          	auipc	ra,0xfffff
    80001d64:	f64080e7          	jalr	-156(ra) # 80000cc4 <release>
    return 0;
    80001d68:	84ca                	mv	s1,s2
    80001d6a:	b7f9                	j	80001d38 <allocproc+0x8c>

0000000080001d6c <userinit>:
{
    80001d6c:	1101                	addi	sp,sp,-32
    80001d6e:	ec06                	sd	ra,24(sp)
    80001d70:	e822                	sd	s0,16(sp)
    80001d72:	e426                	sd	s1,8(sp)
    80001d74:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d76:	00000097          	auipc	ra,0x0
    80001d7a:	f36080e7          	jalr	-202(ra) # 80001cac <allocproc>
    80001d7e:	84aa                	mv	s1,a0
  initproc = p;
    80001d80:	00007797          	auipc	a5,0x7
    80001d84:	28a7bc23          	sd	a0,664(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001d88:	03400613          	li	a2,52
    80001d8c:	00007597          	auipc	a1,0x7
    80001d90:	a8458593          	addi	a1,a1,-1404 # 80008810 <initcode>
    80001d94:	7128                	ld	a0,96(a0)
    80001d96:	fffff097          	auipc	ra,0xfffff
    80001d9a:	6c6080e7          	jalr	1734(ra) # 8000145c <uvminit>
  p->sz = PGSIZE;
    80001d9e:	6785                	lui	a5,0x1
    80001da0:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    80001da2:	74b8                	ld	a4,104(s1)
    80001da4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001da8:	74b8                	ld	a4,104(s1)
    80001daa:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001dac:	4641                	li	a2,16
    80001dae:	00006597          	auipc	a1,0x6
    80001db2:	42258593          	addi	a1,a1,1058 # 800081d0 <digits+0x190>
    80001db6:	16848513          	addi	a0,s1,360
    80001dba:	fffff097          	auipc	ra,0xfffff
    80001dbe:	0a8080e7          	jalr	168(ra) # 80000e62 <safestrcpy>
  p->cwd = namei("/");
    80001dc2:	00006517          	auipc	a0,0x6
    80001dc6:	41e50513          	addi	a0,a0,1054 # 800081e0 <digits+0x1a0>
    80001dca:	00002097          	auipc	ra,0x2
    80001dce:	16c080e7          	jalr	364(ra) # 80003f36 <namei>
    80001dd2:	16a4b023          	sd	a0,352(s1)
  p->state = RUNNABLE;
    80001dd6:	4789                	li	a5,2
    80001dd8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001dda:	8526                	mv	a0,s1
    80001ddc:	fffff097          	auipc	ra,0xfffff
    80001de0:	ee8080e7          	jalr	-280(ra) # 80000cc4 <release>
}
    80001de4:	60e2                	ld	ra,24(sp)
    80001de6:	6442                	ld	s0,16(sp)
    80001de8:	64a2                	ld	s1,8(sp)
    80001dea:	6105                	addi	sp,sp,32
    80001dec:	8082                	ret

0000000080001dee <growproc>:
{
    80001dee:	1101                	addi	sp,sp,-32
    80001df0:	ec06                	sd	ra,24(sp)
    80001df2:	e822                	sd	s0,16(sp)
    80001df4:	e426                	sd	s1,8(sp)
    80001df6:	e04a                	sd	s2,0(sp)
    80001df8:	1000                	addi	s0,sp,32
    80001dfa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001dfc:	00000097          	auipc	ra,0x0
    80001e00:	c8e080e7          	jalr	-882(ra) # 80001a8a <myproc>
    80001e04:	892a                	mv	s2,a0
  sz = p->sz;
    80001e06:	692c                	ld	a1,80(a0)
    80001e08:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001e0c:	00904f63          	bgtz	s1,80001e2a <growproc+0x3c>
  } else if(n < 0){
    80001e10:	0204cc63          	bltz	s1,80001e48 <growproc+0x5a>
  p->sz = sz;
    80001e14:	1602                	slli	a2,a2,0x20
    80001e16:	9201                	srli	a2,a2,0x20
    80001e18:	04c93823          	sd	a2,80(s2)
  return 0;
    80001e1c:	4501                	li	a0,0
}
    80001e1e:	60e2                	ld	ra,24(sp)
    80001e20:	6442                	ld	s0,16(sp)
    80001e22:	64a2                	ld	s1,8(sp)
    80001e24:	6902                	ld	s2,0(sp)
    80001e26:	6105                	addi	sp,sp,32
    80001e28:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001e2a:	9e25                	addw	a2,a2,s1
    80001e2c:	1602                	slli	a2,a2,0x20
    80001e2e:	9201                	srli	a2,a2,0x20
    80001e30:	1582                	slli	a1,a1,0x20
    80001e32:	9181                	srli	a1,a1,0x20
    80001e34:	7128                	ld	a0,96(a0)
    80001e36:	fffff097          	auipc	ra,0xfffff
    80001e3a:	6e0080e7          	jalr	1760(ra) # 80001516 <uvmalloc>
    80001e3e:	0005061b          	sext.w	a2,a0
    80001e42:	fa69                	bnez	a2,80001e14 <growproc+0x26>
      return -1;
    80001e44:	557d                	li	a0,-1
    80001e46:	bfe1                	j	80001e1e <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001e48:	9e25                	addw	a2,a2,s1
    80001e4a:	1602                	slli	a2,a2,0x20
    80001e4c:	9201                	srli	a2,a2,0x20
    80001e4e:	1582                	slli	a1,a1,0x20
    80001e50:	9181                	srli	a1,a1,0x20
    80001e52:	7128                	ld	a0,96(a0)
    80001e54:	fffff097          	auipc	ra,0xfffff
    80001e58:	67a080e7          	jalr	1658(ra) # 800014ce <uvmdealloc>
    80001e5c:	0005061b          	sext.w	a2,a0
    80001e60:	bf55                	j	80001e14 <growproc+0x26>

0000000080001e62 <fork>:
{
    80001e62:	7179                	addi	sp,sp,-48
    80001e64:	f406                	sd	ra,40(sp)
    80001e66:	f022                	sd	s0,32(sp)
    80001e68:	ec26                	sd	s1,24(sp)
    80001e6a:	e84a                	sd	s2,16(sp)
    80001e6c:	e44e                	sd	s3,8(sp)
    80001e6e:	e052                	sd	s4,0(sp)
    80001e70:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e72:	00000097          	auipc	ra,0x0
    80001e76:	c18080e7          	jalr	-1000(ra) # 80001a8a <myproc>
    80001e7a:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001e7c:	00000097          	auipc	ra,0x0
    80001e80:	e30080e7          	jalr	-464(ra) # 80001cac <allocproc>
    80001e84:	c975                	beqz	a0,80001f78 <fork+0x116>
    80001e86:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->maxva) < 0){
    80001e88:	05893603          	ld	a2,88(s2)
    80001e8c:	712c                	ld	a1,96(a0)
    80001e8e:	06093503          	ld	a0,96(s2)
    80001e92:	fffff097          	auipc	ra,0xfffff
    80001e96:	7d0080e7          	jalr	2000(ra) # 80001662 <uvmcopy>
    80001e9a:	06054063          	bltz	a0,80001efa <fork+0x98>
  np->sz = p->sz;
    80001e9e:	05093783          	ld	a5,80(s2)
    80001ea2:	04f9b823          	sd	a5,80(s3) # 4000050 <_entry-0x7bffffb0>
  np->maxva = p->maxva;
    80001ea6:	05893783          	ld	a5,88(s2)
    80001eaa:	04f9bc23          	sd	a5,88(s3)
  np->ustack = p->ustack;
    80001eae:	04893783          	ld	a5,72(s2)
    80001eb2:	04f9b423          	sd	a5,72(s3)
  np->parent = p;
    80001eb6:	0329b023          	sd	s2,32(s3)
  *(np->trapframe) = *(p->trapframe);
    80001eba:	06893683          	ld	a3,104(s2)
    80001ebe:	87b6                	mv	a5,a3
    80001ec0:	0689b703          	ld	a4,104(s3)
    80001ec4:	12068693          	addi	a3,a3,288
    80001ec8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001ecc:	6788                	ld	a0,8(a5)
    80001ece:	6b8c                	ld	a1,16(a5)
    80001ed0:	6f90                	ld	a2,24(a5)
    80001ed2:	01073023          	sd	a6,0(a4)
    80001ed6:	e708                	sd	a0,8(a4)
    80001ed8:	eb0c                	sd	a1,16(a4)
    80001eda:	ef10                	sd	a2,24(a4)
    80001edc:	02078793          	addi	a5,a5,32
    80001ee0:	02070713          	addi	a4,a4,32
    80001ee4:	fed792e3          	bne	a5,a3,80001ec8 <fork+0x66>
  np->trapframe->a0 = 0;
    80001ee8:	0689b783          	ld	a5,104(s3)
    80001eec:	0607b823          	sd	zero,112(a5)
    80001ef0:	0e000493          	li	s1,224
  for(i = 0; i < NOFILE; i++)
    80001ef4:	16000a13          	li	s4,352
    80001ef8:	a03d                	j	80001f26 <fork+0xc4>
    freeproc(np);
    80001efa:	854e                	mv	a0,s3
    80001efc:	00000097          	auipc	ra,0x0
    80001f00:	d40080e7          	jalr	-704(ra) # 80001c3c <freeproc>
    release(&np->lock);
    80001f04:	854e                	mv	a0,s3
    80001f06:	fffff097          	auipc	ra,0xfffff
    80001f0a:	dbe080e7          	jalr	-578(ra) # 80000cc4 <release>
    return -1;
    80001f0e:	54fd                	li	s1,-1
    80001f10:	a899                	j	80001f66 <fork+0x104>
      np->ofile[i] = filedup(p->ofile[i]);
    80001f12:	00002097          	auipc	ra,0x2
    80001f16:	6b0080e7          	jalr	1712(ra) # 800045c2 <filedup>
    80001f1a:	009987b3          	add	a5,s3,s1
    80001f1e:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001f20:	04a1                	addi	s1,s1,8
    80001f22:	01448763          	beq	s1,s4,80001f30 <fork+0xce>
    if(p->ofile[i])
    80001f26:	009907b3          	add	a5,s2,s1
    80001f2a:	6388                	ld	a0,0(a5)
    80001f2c:	f17d                	bnez	a0,80001f12 <fork+0xb0>
    80001f2e:	bfcd                	j	80001f20 <fork+0xbe>
  np->cwd = idup(p->cwd);
    80001f30:	16093503          	ld	a0,352(s2)
    80001f34:	00002097          	auipc	ra,0x2
    80001f38:	810080e7          	jalr	-2032(ra) # 80003744 <idup>
    80001f3c:	16a9b023          	sd	a0,352(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001f40:	4641                	li	a2,16
    80001f42:	16890593          	addi	a1,s2,360
    80001f46:	16898513          	addi	a0,s3,360
    80001f4a:	fffff097          	auipc	ra,0xfffff
    80001f4e:	f18080e7          	jalr	-232(ra) # 80000e62 <safestrcpy>
  pid = np->pid;
    80001f52:	0389a483          	lw	s1,56(s3)
  np->state = RUNNABLE;
    80001f56:	4789                	li	a5,2
    80001f58:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001f5c:	854e                	mv	a0,s3
    80001f5e:	fffff097          	auipc	ra,0xfffff
    80001f62:	d66080e7          	jalr	-666(ra) # 80000cc4 <release>
}
    80001f66:	8526                	mv	a0,s1
    80001f68:	70a2                	ld	ra,40(sp)
    80001f6a:	7402                	ld	s0,32(sp)
    80001f6c:	64e2                	ld	s1,24(sp)
    80001f6e:	6942                	ld	s2,16(sp)
    80001f70:	69a2                	ld	s3,8(sp)
    80001f72:	6a02                	ld	s4,0(sp)
    80001f74:	6145                	addi	sp,sp,48
    80001f76:	8082                	ret
    return -1;
    80001f78:	54fd                	li	s1,-1
    80001f7a:	b7f5                	j	80001f66 <fork+0x104>

0000000080001f7c <reparent>:
{
    80001f7c:	7179                	addi	sp,sp,-48
    80001f7e:	f406                	sd	ra,40(sp)
    80001f80:	f022                	sd	s0,32(sp)
    80001f82:	ec26                	sd	s1,24(sp)
    80001f84:	e84a                	sd	s2,16(sp)
    80001f86:	e44e                	sd	s3,8(sp)
    80001f88:	e052                	sd	s4,0(sp)
    80001f8a:	1800                	addi	s0,sp,48
    80001f8c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f8e:	00010497          	auipc	s1,0x10
    80001f92:	dda48493          	addi	s1,s1,-550 # 80011d68 <proc>
      pp->parent = initproc;
    80001f96:	00007a17          	auipc	s4,0x7
    80001f9a:	082a0a13          	addi	s4,s4,130 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f9e:	00016997          	auipc	s3,0x16
    80001fa2:	bca98993          	addi	s3,s3,-1078 # 80017b68 <tickslock>
    80001fa6:	a029                	j	80001fb0 <reparent+0x34>
    80001fa8:	17848493          	addi	s1,s1,376
    80001fac:	03348363          	beq	s1,s3,80001fd2 <reparent+0x56>
    if(pp->parent == p){
    80001fb0:	709c                	ld	a5,32(s1)
    80001fb2:	ff279be3          	bne	a5,s2,80001fa8 <reparent+0x2c>
      acquire(&pp->lock);
    80001fb6:	8526                	mv	a0,s1
    80001fb8:	fffff097          	auipc	ra,0xfffff
    80001fbc:	c58080e7          	jalr	-936(ra) # 80000c10 <acquire>
      pp->parent = initproc;
    80001fc0:	000a3783          	ld	a5,0(s4)
    80001fc4:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001fc6:	8526                	mv	a0,s1
    80001fc8:	fffff097          	auipc	ra,0xfffff
    80001fcc:	cfc080e7          	jalr	-772(ra) # 80000cc4 <release>
    80001fd0:	bfe1                	j	80001fa8 <reparent+0x2c>
}
    80001fd2:	70a2                	ld	ra,40(sp)
    80001fd4:	7402                	ld	s0,32(sp)
    80001fd6:	64e2                	ld	s1,24(sp)
    80001fd8:	6942                	ld	s2,16(sp)
    80001fda:	69a2                	ld	s3,8(sp)
    80001fdc:	6a02                	ld	s4,0(sp)
    80001fde:	6145                	addi	sp,sp,48
    80001fe0:	8082                	ret

0000000080001fe2 <scheduler>:
{
    80001fe2:	711d                	addi	sp,sp,-96
    80001fe4:	ec86                	sd	ra,88(sp)
    80001fe6:	e8a2                	sd	s0,80(sp)
    80001fe8:	e4a6                	sd	s1,72(sp)
    80001fea:	e0ca                	sd	s2,64(sp)
    80001fec:	fc4e                	sd	s3,56(sp)
    80001fee:	f852                	sd	s4,48(sp)
    80001ff0:	f456                	sd	s5,40(sp)
    80001ff2:	f05a                	sd	s6,32(sp)
    80001ff4:	ec5e                	sd	s7,24(sp)
    80001ff6:	e862                	sd	s8,16(sp)
    80001ff8:	e466                	sd	s9,8(sp)
    80001ffa:	1080                	addi	s0,sp,96
    80001ffc:	8792                	mv	a5,tp
  int id = r_tp();
    80001ffe:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002000:	00779c13          	slli	s8,a5,0x7
    80002004:	00010717          	auipc	a4,0x10
    80002008:	94c70713          	addi	a4,a4,-1716 # 80011950 <pid_lock>
    8000200c:	9762                	add	a4,a4,s8
    8000200e:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80002012:	00010717          	auipc	a4,0x10
    80002016:	95e70713          	addi	a4,a4,-1698 # 80011970 <cpus+0x8>
    8000201a:	9c3a                	add	s8,s8,a4
      if(p->state == RUNNABLE) {
    8000201c:	4a89                	li	s5,2
        c->proc = p;
    8000201e:	079e                	slli	a5,a5,0x7
    80002020:	00010b17          	auipc	s6,0x10
    80002024:	930b0b13          	addi	s6,s6,-1744 # 80011950 <pid_lock>
    80002028:	9b3e                	add	s6,s6,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000202a:	00016a17          	auipc	s4,0x16
    8000202e:	b3ea0a13          	addi	s4,s4,-1218 # 80017b68 <tickslock>
    int nproc = 0;
    80002032:	4c81                	li	s9,0
    80002034:	a8a1                	j	8000208c <scheduler+0xaa>
        p->state = RUNNING;
    80002036:	0174ac23          	sw	s7,24(s1)
        c->proc = p;
    8000203a:	009b3c23          	sd	s1,24(s6)
        swtch(&c->context, &p->context);
    8000203e:	07048593          	addi	a1,s1,112
    80002042:	8562                	mv	a0,s8
    80002044:	00000097          	auipc	ra,0x0
    80002048:	63a080e7          	jalr	1594(ra) # 8000267e <swtch>
        c->proc = 0;
    8000204c:	000b3c23          	sd	zero,24(s6)
      release(&p->lock);
    80002050:	8526                	mv	a0,s1
    80002052:	fffff097          	auipc	ra,0xfffff
    80002056:	c72080e7          	jalr	-910(ra) # 80000cc4 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000205a:	17848493          	addi	s1,s1,376
    8000205e:	01448d63          	beq	s1,s4,80002078 <scheduler+0x96>
      acquire(&p->lock);
    80002062:	8526                	mv	a0,s1
    80002064:	fffff097          	auipc	ra,0xfffff
    80002068:	bac080e7          	jalr	-1108(ra) # 80000c10 <acquire>
      if(p->state != UNUSED) {
    8000206c:	4c9c                	lw	a5,24(s1)
    8000206e:	d3ed                	beqz	a5,80002050 <scheduler+0x6e>
        nproc++;
    80002070:	2985                	addiw	s3,s3,1
      if(p->state == RUNNABLE) {
    80002072:	fd579fe3          	bne	a5,s5,80002050 <scheduler+0x6e>
    80002076:	b7c1                	j	80002036 <scheduler+0x54>
    if(nproc <= 2) {   // only init and sh exist
    80002078:	013aca63          	blt	s5,s3,8000208c <scheduler+0xaa>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000207c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002080:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002084:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80002088:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000208c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002090:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002094:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    80002098:	89e6                	mv	s3,s9
    for(p = proc; p < &proc[NPROC]; p++) {
    8000209a:	00010497          	auipc	s1,0x10
    8000209e:	cce48493          	addi	s1,s1,-818 # 80011d68 <proc>
        p->state = RUNNING;
    800020a2:	4b8d                	li	s7,3
    800020a4:	bf7d                	j	80002062 <scheduler+0x80>

00000000800020a6 <sched>:
{
    800020a6:	7179                	addi	sp,sp,-48
    800020a8:	f406                	sd	ra,40(sp)
    800020aa:	f022                	sd	s0,32(sp)
    800020ac:	ec26                	sd	s1,24(sp)
    800020ae:	e84a                	sd	s2,16(sp)
    800020b0:	e44e                	sd	s3,8(sp)
    800020b2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800020b4:	00000097          	auipc	ra,0x0
    800020b8:	9d6080e7          	jalr	-1578(ra) # 80001a8a <myproc>
    800020bc:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800020be:	fffff097          	auipc	ra,0xfffff
    800020c2:	ad8080e7          	jalr	-1320(ra) # 80000b96 <holding>
    800020c6:	c93d                	beqz	a0,8000213c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020c8:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800020ca:	2781                	sext.w	a5,a5
    800020cc:	079e                	slli	a5,a5,0x7
    800020ce:	00010717          	auipc	a4,0x10
    800020d2:	88270713          	addi	a4,a4,-1918 # 80011950 <pid_lock>
    800020d6:	97ba                	add	a5,a5,a4
    800020d8:	0907a703          	lw	a4,144(a5)
    800020dc:	4785                	li	a5,1
    800020de:	06f71763          	bne	a4,a5,8000214c <sched+0xa6>
  if(p->state == RUNNING)
    800020e2:	4c98                	lw	a4,24(s1)
    800020e4:	478d                	li	a5,3
    800020e6:	06f70b63          	beq	a4,a5,8000215c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020ea:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800020ee:	8b89                	andi	a5,a5,2
  if(intr_get())
    800020f0:	efb5                	bnez	a5,8000216c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020f2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800020f4:	00010917          	auipc	s2,0x10
    800020f8:	85c90913          	addi	s2,s2,-1956 # 80011950 <pid_lock>
    800020fc:	2781                	sext.w	a5,a5
    800020fe:	079e                	slli	a5,a5,0x7
    80002100:	97ca                	add	a5,a5,s2
    80002102:	0947a983          	lw	s3,148(a5)
    80002106:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002108:	2781                	sext.w	a5,a5
    8000210a:	079e                	slli	a5,a5,0x7
    8000210c:	00010597          	auipc	a1,0x10
    80002110:	86458593          	addi	a1,a1,-1948 # 80011970 <cpus+0x8>
    80002114:	95be                	add	a1,a1,a5
    80002116:	07048513          	addi	a0,s1,112
    8000211a:	00000097          	auipc	ra,0x0
    8000211e:	564080e7          	jalr	1380(ra) # 8000267e <swtch>
    80002122:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002124:	2781                	sext.w	a5,a5
    80002126:	079e                	slli	a5,a5,0x7
    80002128:	97ca                	add	a5,a5,s2
    8000212a:	0937aa23          	sw	s3,148(a5)
}
    8000212e:	70a2                	ld	ra,40(sp)
    80002130:	7402                	ld	s0,32(sp)
    80002132:	64e2                	ld	s1,24(sp)
    80002134:	6942                	ld	s2,16(sp)
    80002136:	69a2                	ld	s3,8(sp)
    80002138:	6145                	addi	sp,sp,48
    8000213a:	8082                	ret
    panic("sched p->lock");
    8000213c:	00006517          	auipc	a0,0x6
    80002140:	0ac50513          	addi	a0,a0,172 # 800081e8 <digits+0x1a8>
    80002144:	ffffe097          	auipc	ra,0xffffe
    80002148:	404080e7          	jalr	1028(ra) # 80000548 <panic>
    panic("sched locks");
    8000214c:	00006517          	auipc	a0,0x6
    80002150:	0ac50513          	addi	a0,a0,172 # 800081f8 <digits+0x1b8>
    80002154:	ffffe097          	auipc	ra,0xffffe
    80002158:	3f4080e7          	jalr	1012(ra) # 80000548 <panic>
    panic("sched running");
    8000215c:	00006517          	auipc	a0,0x6
    80002160:	0ac50513          	addi	a0,a0,172 # 80008208 <digits+0x1c8>
    80002164:	ffffe097          	auipc	ra,0xffffe
    80002168:	3e4080e7          	jalr	996(ra) # 80000548 <panic>
    panic("sched interruptible");
    8000216c:	00006517          	auipc	a0,0x6
    80002170:	0ac50513          	addi	a0,a0,172 # 80008218 <digits+0x1d8>
    80002174:	ffffe097          	auipc	ra,0xffffe
    80002178:	3d4080e7          	jalr	980(ra) # 80000548 <panic>

000000008000217c <exit>:
{
    8000217c:	7179                	addi	sp,sp,-48
    8000217e:	f406                	sd	ra,40(sp)
    80002180:	f022                	sd	s0,32(sp)
    80002182:	ec26                	sd	s1,24(sp)
    80002184:	e84a                	sd	s2,16(sp)
    80002186:	e44e                	sd	s3,8(sp)
    80002188:	e052                	sd	s4,0(sp)
    8000218a:	1800                	addi	s0,sp,48
    8000218c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000218e:	00000097          	auipc	ra,0x0
    80002192:	8fc080e7          	jalr	-1796(ra) # 80001a8a <myproc>
    80002196:	89aa                	mv	s3,a0
  if(p == initproc)
    80002198:	00007797          	auipc	a5,0x7
    8000219c:	e807b783          	ld	a5,-384(a5) # 80009018 <initproc>
    800021a0:	0e050493          	addi	s1,a0,224
    800021a4:	16050913          	addi	s2,a0,352
    800021a8:	02a79363          	bne	a5,a0,800021ce <exit+0x52>
    panic("init exiting");
    800021ac:	00006517          	auipc	a0,0x6
    800021b0:	08450513          	addi	a0,a0,132 # 80008230 <digits+0x1f0>
    800021b4:	ffffe097          	auipc	ra,0xffffe
    800021b8:	394080e7          	jalr	916(ra) # 80000548 <panic>
      fileclose(f);
    800021bc:	00002097          	auipc	ra,0x2
    800021c0:	458080e7          	jalr	1112(ra) # 80004614 <fileclose>
      p->ofile[fd] = 0;
    800021c4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800021c8:	04a1                	addi	s1,s1,8
    800021ca:	01248563          	beq	s1,s2,800021d4 <exit+0x58>
    if(p->ofile[fd]){
    800021ce:	6088                	ld	a0,0(s1)
    800021d0:	f575                	bnez	a0,800021bc <exit+0x40>
    800021d2:	bfdd                	j	800021c8 <exit+0x4c>
  begin_op();
    800021d4:	00002097          	auipc	ra,0x2
    800021d8:	f6e080e7          	jalr	-146(ra) # 80004142 <begin_op>
  iput(p->cwd);
    800021dc:	1609b503          	ld	a0,352(s3)
    800021e0:	00001097          	auipc	ra,0x1
    800021e4:	75c080e7          	jalr	1884(ra) # 8000393c <iput>
  end_op();
    800021e8:	00002097          	auipc	ra,0x2
    800021ec:	fda080e7          	jalr	-38(ra) # 800041c2 <end_op>
  p->cwd = 0;
    800021f0:	1609b023          	sd	zero,352(s3)
  acquire(&initproc->lock);
    800021f4:	00007497          	auipc	s1,0x7
    800021f8:	e2448493          	addi	s1,s1,-476 # 80009018 <initproc>
    800021fc:	6088                	ld	a0,0(s1)
    800021fe:	fffff097          	auipc	ra,0xfffff
    80002202:	a12080e7          	jalr	-1518(ra) # 80000c10 <acquire>
  wakeup1(initproc);
    80002206:	6088                	ld	a0,0(s1)
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	742080e7          	jalr	1858(ra) # 8000194a <wakeup1>
  release(&initproc->lock);
    80002210:	6088                	ld	a0,0(s1)
    80002212:	fffff097          	auipc	ra,0xfffff
    80002216:	ab2080e7          	jalr	-1358(ra) # 80000cc4 <release>
  acquire(&p->lock);
    8000221a:	854e                	mv	a0,s3
    8000221c:	fffff097          	auipc	ra,0xfffff
    80002220:	9f4080e7          	jalr	-1548(ra) # 80000c10 <acquire>
  struct proc *original_parent = p->parent;
    80002224:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80002228:	854e                	mv	a0,s3
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	a9a080e7          	jalr	-1382(ra) # 80000cc4 <release>
  acquire(&original_parent->lock);
    80002232:	8526                	mv	a0,s1
    80002234:	fffff097          	auipc	ra,0xfffff
    80002238:	9dc080e7          	jalr	-1572(ra) # 80000c10 <acquire>
  acquire(&p->lock);
    8000223c:	854e                	mv	a0,s3
    8000223e:	fffff097          	auipc	ra,0xfffff
    80002242:	9d2080e7          	jalr	-1582(ra) # 80000c10 <acquire>
  reparent(p);
    80002246:	854e                	mv	a0,s3
    80002248:	00000097          	auipc	ra,0x0
    8000224c:	d34080e7          	jalr	-716(ra) # 80001f7c <reparent>
  wakeup1(original_parent);
    80002250:	8526                	mv	a0,s1
    80002252:	fffff097          	auipc	ra,0xfffff
    80002256:	6f8080e7          	jalr	1784(ra) # 8000194a <wakeup1>
  p->xstate = status;
    8000225a:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000225e:	4791                	li	a5,4
    80002260:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    80002264:	8526                	mv	a0,s1
    80002266:	fffff097          	auipc	ra,0xfffff
    8000226a:	a5e080e7          	jalr	-1442(ra) # 80000cc4 <release>
  sched();
    8000226e:	00000097          	auipc	ra,0x0
    80002272:	e38080e7          	jalr	-456(ra) # 800020a6 <sched>
  panic("zombie exit");
    80002276:	00006517          	auipc	a0,0x6
    8000227a:	fca50513          	addi	a0,a0,-54 # 80008240 <digits+0x200>
    8000227e:	ffffe097          	auipc	ra,0xffffe
    80002282:	2ca080e7          	jalr	714(ra) # 80000548 <panic>

0000000080002286 <yield>:
{
    80002286:	1101                	addi	sp,sp,-32
    80002288:	ec06                	sd	ra,24(sp)
    8000228a:	e822                	sd	s0,16(sp)
    8000228c:	e426                	sd	s1,8(sp)
    8000228e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002290:	fffff097          	auipc	ra,0xfffff
    80002294:	7fa080e7          	jalr	2042(ra) # 80001a8a <myproc>
    80002298:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000229a:	fffff097          	auipc	ra,0xfffff
    8000229e:	976080e7          	jalr	-1674(ra) # 80000c10 <acquire>
  p->state = RUNNABLE;
    800022a2:	4789                	li	a5,2
    800022a4:	cc9c                	sw	a5,24(s1)
  sched();
    800022a6:	00000097          	auipc	ra,0x0
    800022aa:	e00080e7          	jalr	-512(ra) # 800020a6 <sched>
  release(&p->lock);
    800022ae:	8526                	mv	a0,s1
    800022b0:	fffff097          	auipc	ra,0xfffff
    800022b4:	a14080e7          	jalr	-1516(ra) # 80000cc4 <release>
}
    800022b8:	60e2                	ld	ra,24(sp)
    800022ba:	6442                	ld	s0,16(sp)
    800022bc:	64a2                	ld	s1,8(sp)
    800022be:	6105                	addi	sp,sp,32
    800022c0:	8082                	ret

00000000800022c2 <sleep>:
{
    800022c2:	7179                	addi	sp,sp,-48
    800022c4:	f406                	sd	ra,40(sp)
    800022c6:	f022                	sd	s0,32(sp)
    800022c8:	ec26                	sd	s1,24(sp)
    800022ca:	e84a                	sd	s2,16(sp)
    800022cc:	e44e                	sd	s3,8(sp)
    800022ce:	1800                	addi	s0,sp,48
    800022d0:	89aa                	mv	s3,a0
    800022d2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800022d4:	fffff097          	auipc	ra,0xfffff
    800022d8:	7b6080e7          	jalr	1974(ra) # 80001a8a <myproc>
    800022dc:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    800022de:	05250663          	beq	a0,s2,8000232a <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    800022e2:	fffff097          	auipc	ra,0xfffff
    800022e6:	92e080e7          	jalr	-1746(ra) # 80000c10 <acquire>
    release(lk);
    800022ea:	854a                	mv	a0,s2
    800022ec:	fffff097          	auipc	ra,0xfffff
    800022f0:	9d8080e7          	jalr	-1576(ra) # 80000cc4 <release>
  p->chan = chan;
    800022f4:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800022f8:	4785                	li	a5,1
    800022fa:	cc9c                	sw	a5,24(s1)
  sched();
    800022fc:	00000097          	auipc	ra,0x0
    80002300:	daa080e7          	jalr	-598(ra) # 800020a6 <sched>
  p->chan = 0;
    80002304:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    80002308:	8526                	mv	a0,s1
    8000230a:	fffff097          	auipc	ra,0xfffff
    8000230e:	9ba080e7          	jalr	-1606(ra) # 80000cc4 <release>
    acquire(lk);
    80002312:	854a                	mv	a0,s2
    80002314:	fffff097          	auipc	ra,0xfffff
    80002318:	8fc080e7          	jalr	-1796(ra) # 80000c10 <acquire>
}
    8000231c:	70a2                	ld	ra,40(sp)
    8000231e:	7402                	ld	s0,32(sp)
    80002320:	64e2                	ld	s1,24(sp)
    80002322:	6942                	ld	s2,16(sp)
    80002324:	69a2                	ld	s3,8(sp)
    80002326:	6145                	addi	sp,sp,48
    80002328:	8082                	ret
  p->chan = chan;
    8000232a:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    8000232e:	4785                	li	a5,1
    80002330:	cd1c                	sw	a5,24(a0)
  sched();
    80002332:	00000097          	auipc	ra,0x0
    80002336:	d74080e7          	jalr	-652(ra) # 800020a6 <sched>
  p->chan = 0;
    8000233a:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    8000233e:	bff9                	j	8000231c <sleep+0x5a>

0000000080002340 <wait>:
{
    80002340:	715d                	addi	sp,sp,-80
    80002342:	e486                	sd	ra,72(sp)
    80002344:	e0a2                	sd	s0,64(sp)
    80002346:	fc26                	sd	s1,56(sp)
    80002348:	f84a                	sd	s2,48(sp)
    8000234a:	f44e                	sd	s3,40(sp)
    8000234c:	f052                	sd	s4,32(sp)
    8000234e:	ec56                	sd	s5,24(sp)
    80002350:	e85a                	sd	s6,16(sp)
    80002352:	e45e                	sd	s7,8(sp)
    80002354:	e062                	sd	s8,0(sp)
    80002356:	0880                	addi	s0,sp,80
    80002358:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000235a:	fffff097          	auipc	ra,0xfffff
    8000235e:	730080e7          	jalr	1840(ra) # 80001a8a <myproc>
    80002362:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002364:	8c2a                	mv	s8,a0
    80002366:	fffff097          	auipc	ra,0xfffff
    8000236a:	8aa080e7          	jalr	-1878(ra) # 80000c10 <acquire>
    havekids = 0;
    8000236e:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002370:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    80002372:	00015997          	auipc	s3,0x15
    80002376:	7f698993          	addi	s3,s3,2038 # 80017b68 <tickslock>
        havekids = 1;
    8000237a:	4a85                	li	s5,1
    havekids = 0;
    8000237c:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000237e:	00010497          	auipc	s1,0x10
    80002382:	9ea48493          	addi	s1,s1,-1558 # 80011d68 <proc>
    80002386:	a08d                	j	800023e8 <wait+0xa8>
          pid = np->pid;
    80002388:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000238c:	000b0e63          	beqz	s6,800023a8 <wait+0x68>
    80002390:	4691                	li	a3,4
    80002392:	03448613          	addi	a2,s1,52
    80002396:	85da                	mv	a1,s6
    80002398:	06093503          	ld	a0,96(s2)
    8000239c:	fffff097          	auipc	ra,0xfffff
    800023a0:	3ae080e7          	jalr	942(ra) # 8000174a <copyout>
    800023a4:	02054263          	bltz	a0,800023c8 <wait+0x88>
          freeproc(np);
    800023a8:	8526                	mv	a0,s1
    800023aa:	00000097          	auipc	ra,0x0
    800023ae:	892080e7          	jalr	-1902(ra) # 80001c3c <freeproc>
          release(&np->lock);
    800023b2:	8526                	mv	a0,s1
    800023b4:	fffff097          	auipc	ra,0xfffff
    800023b8:	910080e7          	jalr	-1776(ra) # 80000cc4 <release>
          release(&p->lock);
    800023bc:	854a                	mv	a0,s2
    800023be:	fffff097          	auipc	ra,0xfffff
    800023c2:	906080e7          	jalr	-1786(ra) # 80000cc4 <release>
          return pid;
    800023c6:	a8a9                	j	80002420 <wait+0xe0>
            release(&np->lock);
    800023c8:	8526                	mv	a0,s1
    800023ca:	fffff097          	auipc	ra,0xfffff
    800023ce:	8fa080e7          	jalr	-1798(ra) # 80000cc4 <release>
            release(&p->lock);
    800023d2:	854a                	mv	a0,s2
    800023d4:	fffff097          	auipc	ra,0xfffff
    800023d8:	8f0080e7          	jalr	-1808(ra) # 80000cc4 <release>
            return -1;
    800023dc:	59fd                	li	s3,-1
    800023de:	a089                	j	80002420 <wait+0xe0>
    for(np = proc; np < &proc[NPROC]; np++){
    800023e0:	17848493          	addi	s1,s1,376
    800023e4:	03348463          	beq	s1,s3,8000240c <wait+0xcc>
      if(np->parent == p){
    800023e8:	709c                	ld	a5,32(s1)
    800023ea:	ff279be3          	bne	a5,s2,800023e0 <wait+0xa0>
        acquire(&np->lock);
    800023ee:	8526                	mv	a0,s1
    800023f0:	fffff097          	auipc	ra,0xfffff
    800023f4:	820080e7          	jalr	-2016(ra) # 80000c10 <acquire>
        if(np->state == ZOMBIE){
    800023f8:	4c9c                	lw	a5,24(s1)
    800023fa:	f94787e3          	beq	a5,s4,80002388 <wait+0x48>
        release(&np->lock);
    800023fe:	8526                	mv	a0,s1
    80002400:	fffff097          	auipc	ra,0xfffff
    80002404:	8c4080e7          	jalr	-1852(ra) # 80000cc4 <release>
        havekids = 1;
    80002408:	8756                	mv	a4,s5
    8000240a:	bfd9                	j	800023e0 <wait+0xa0>
    if(!havekids || p->killed){
    8000240c:	c701                	beqz	a4,80002414 <wait+0xd4>
    8000240e:	03092783          	lw	a5,48(s2)
    80002412:	c785                	beqz	a5,8000243a <wait+0xfa>
      release(&p->lock);
    80002414:	854a                	mv	a0,s2
    80002416:	fffff097          	auipc	ra,0xfffff
    8000241a:	8ae080e7          	jalr	-1874(ra) # 80000cc4 <release>
      return -1;
    8000241e:	59fd                	li	s3,-1
}
    80002420:	854e                	mv	a0,s3
    80002422:	60a6                	ld	ra,72(sp)
    80002424:	6406                	ld	s0,64(sp)
    80002426:	74e2                	ld	s1,56(sp)
    80002428:	7942                	ld	s2,48(sp)
    8000242a:	79a2                	ld	s3,40(sp)
    8000242c:	7a02                	ld	s4,32(sp)
    8000242e:	6ae2                	ld	s5,24(sp)
    80002430:	6b42                	ld	s6,16(sp)
    80002432:	6ba2                	ld	s7,8(sp)
    80002434:	6c02                	ld	s8,0(sp)
    80002436:	6161                	addi	sp,sp,80
    80002438:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    8000243a:	85e2                	mv	a1,s8
    8000243c:	854a                	mv	a0,s2
    8000243e:	00000097          	auipc	ra,0x0
    80002442:	e84080e7          	jalr	-380(ra) # 800022c2 <sleep>
    havekids = 0;
    80002446:	bf1d                	j	8000237c <wait+0x3c>

0000000080002448 <wakeup>:
{
    80002448:	7139                	addi	sp,sp,-64
    8000244a:	fc06                	sd	ra,56(sp)
    8000244c:	f822                	sd	s0,48(sp)
    8000244e:	f426                	sd	s1,40(sp)
    80002450:	f04a                	sd	s2,32(sp)
    80002452:	ec4e                	sd	s3,24(sp)
    80002454:	e852                	sd	s4,16(sp)
    80002456:	e456                	sd	s5,8(sp)
    80002458:	0080                	addi	s0,sp,64
    8000245a:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    8000245c:	00010497          	auipc	s1,0x10
    80002460:	90c48493          	addi	s1,s1,-1780 # 80011d68 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    80002464:	4985                	li	s3,1
      p->state = RUNNABLE;
    80002466:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    80002468:	00015917          	auipc	s2,0x15
    8000246c:	70090913          	addi	s2,s2,1792 # 80017b68 <tickslock>
    80002470:	a821                	j	80002488 <wakeup+0x40>
      p->state = RUNNABLE;
    80002472:	0154ac23          	sw	s5,24(s1)
    release(&p->lock);
    80002476:	8526                	mv	a0,s1
    80002478:	fffff097          	auipc	ra,0xfffff
    8000247c:	84c080e7          	jalr	-1972(ra) # 80000cc4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002480:	17848493          	addi	s1,s1,376
    80002484:	01248e63          	beq	s1,s2,800024a0 <wakeup+0x58>
    acquire(&p->lock);
    80002488:	8526                	mv	a0,s1
    8000248a:	ffffe097          	auipc	ra,0xffffe
    8000248e:	786080e7          	jalr	1926(ra) # 80000c10 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    80002492:	4c9c                	lw	a5,24(s1)
    80002494:	ff3791e3          	bne	a5,s3,80002476 <wakeup+0x2e>
    80002498:	749c                	ld	a5,40(s1)
    8000249a:	fd479ee3          	bne	a5,s4,80002476 <wakeup+0x2e>
    8000249e:	bfd1                	j	80002472 <wakeup+0x2a>
}
    800024a0:	70e2                	ld	ra,56(sp)
    800024a2:	7442                	ld	s0,48(sp)
    800024a4:	74a2                	ld	s1,40(sp)
    800024a6:	7902                	ld	s2,32(sp)
    800024a8:	69e2                	ld	s3,24(sp)
    800024aa:	6a42                	ld	s4,16(sp)
    800024ac:	6aa2                	ld	s5,8(sp)
    800024ae:	6121                	addi	sp,sp,64
    800024b0:	8082                	ret

00000000800024b2 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800024b2:	7179                	addi	sp,sp,-48
    800024b4:	f406                	sd	ra,40(sp)
    800024b6:	f022                	sd	s0,32(sp)
    800024b8:	ec26                	sd	s1,24(sp)
    800024ba:	e84a                	sd	s2,16(sp)
    800024bc:	e44e                	sd	s3,8(sp)
    800024be:	1800                	addi	s0,sp,48
    800024c0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800024c2:	00010497          	auipc	s1,0x10
    800024c6:	8a648493          	addi	s1,s1,-1882 # 80011d68 <proc>
    800024ca:	00015997          	auipc	s3,0x15
    800024ce:	69e98993          	addi	s3,s3,1694 # 80017b68 <tickslock>
    acquire(&p->lock);
    800024d2:	8526                	mv	a0,s1
    800024d4:	ffffe097          	auipc	ra,0xffffe
    800024d8:	73c080e7          	jalr	1852(ra) # 80000c10 <acquire>
    if(p->pid == pid){
    800024dc:	5c9c                	lw	a5,56(s1)
    800024de:	01278d63          	beq	a5,s2,800024f8 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800024e2:	8526                	mv	a0,s1
    800024e4:	ffffe097          	auipc	ra,0xffffe
    800024e8:	7e0080e7          	jalr	2016(ra) # 80000cc4 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800024ec:	17848493          	addi	s1,s1,376
    800024f0:	ff3491e3          	bne	s1,s3,800024d2 <kill+0x20>
  }
  return -1;
    800024f4:	557d                	li	a0,-1
    800024f6:	a829                	j	80002510 <kill+0x5e>
      p->killed = 1;
    800024f8:	4785                	li	a5,1
    800024fa:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800024fc:	4c98                	lw	a4,24(s1)
    800024fe:	4785                	li	a5,1
    80002500:	00f70f63          	beq	a4,a5,8000251e <kill+0x6c>
      release(&p->lock);
    80002504:	8526                	mv	a0,s1
    80002506:	ffffe097          	auipc	ra,0xffffe
    8000250a:	7be080e7          	jalr	1982(ra) # 80000cc4 <release>
      return 0;
    8000250e:	4501                	li	a0,0
}
    80002510:	70a2                	ld	ra,40(sp)
    80002512:	7402                	ld	s0,32(sp)
    80002514:	64e2                	ld	s1,24(sp)
    80002516:	6942                	ld	s2,16(sp)
    80002518:	69a2                	ld	s3,8(sp)
    8000251a:	6145                	addi	sp,sp,48
    8000251c:	8082                	ret
        p->state = RUNNABLE;
    8000251e:	4789                	li	a5,2
    80002520:	cc9c                	sw	a5,24(s1)
    80002522:	b7cd                	j	80002504 <kill+0x52>

0000000080002524 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002524:	7179                	addi	sp,sp,-48
    80002526:	f406                	sd	ra,40(sp)
    80002528:	f022                	sd	s0,32(sp)
    8000252a:	ec26                	sd	s1,24(sp)
    8000252c:	e84a                	sd	s2,16(sp)
    8000252e:	e44e                	sd	s3,8(sp)
    80002530:	e052                	sd	s4,0(sp)
    80002532:	1800                	addi	s0,sp,48
    80002534:	84aa                	mv	s1,a0
    80002536:	892e                	mv	s2,a1
    80002538:	89b2                	mv	s3,a2
    8000253a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000253c:	fffff097          	auipc	ra,0xfffff
    80002540:	54e080e7          	jalr	1358(ra) # 80001a8a <myproc>
  if(user_dst){
    80002544:	c08d                	beqz	s1,80002566 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002546:	86d2                	mv	a3,s4
    80002548:	864e                	mv	a2,s3
    8000254a:	85ca                	mv	a1,s2
    8000254c:	7128                	ld	a0,96(a0)
    8000254e:	fffff097          	auipc	ra,0xfffff
    80002552:	1fc080e7          	jalr	508(ra) # 8000174a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002556:	70a2                	ld	ra,40(sp)
    80002558:	7402                	ld	s0,32(sp)
    8000255a:	64e2                	ld	s1,24(sp)
    8000255c:	6942                	ld	s2,16(sp)
    8000255e:	69a2                	ld	s3,8(sp)
    80002560:	6a02                	ld	s4,0(sp)
    80002562:	6145                	addi	sp,sp,48
    80002564:	8082                	ret
    memmove((char *)dst, src, len);
    80002566:	000a061b          	sext.w	a2,s4
    8000256a:	85ce                	mv	a1,s3
    8000256c:	854a                	mv	a0,s2
    8000256e:	ffffe097          	auipc	ra,0xffffe
    80002572:	7fe080e7          	jalr	2046(ra) # 80000d6c <memmove>
    return 0;
    80002576:	8526                	mv	a0,s1
    80002578:	bff9                	j	80002556 <either_copyout+0x32>

000000008000257a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000257a:	7179                	addi	sp,sp,-48
    8000257c:	f406                	sd	ra,40(sp)
    8000257e:	f022                	sd	s0,32(sp)
    80002580:	ec26                	sd	s1,24(sp)
    80002582:	e84a                	sd	s2,16(sp)
    80002584:	e44e                	sd	s3,8(sp)
    80002586:	e052                	sd	s4,0(sp)
    80002588:	1800                	addi	s0,sp,48
    8000258a:	892a                	mv	s2,a0
    8000258c:	84ae                	mv	s1,a1
    8000258e:	89b2                	mv	s3,a2
    80002590:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002592:	fffff097          	auipc	ra,0xfffff
    80002596:	4f8080e7          	jalr	1272(ra) # 80001a8a <myproc>
  if(user_src){
    8000259a:	c08d                	beqz	s1,800025bc <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000259c:	86d2                	mv	a3,s4
    8000259e:	864e                	mv	a2,s3
    800025a0:	85ca                	mv	a1,s2
    800025a2:	7128                	ld	a0,96(a0)
    800025a4:	fffff097          	auipc	ra,0xfffff
    800025a8:	232080e7          	jalr	562(ra) # 800017d6 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800025ac:	70a2                	ld	ra,40(sp)
    800025ae:	7402                	ld	s0,32(sp)
    800025b0:	64e2                	ld	s1,24(sp)
    800025b2:	6942                	ld	s2,16(sp)
    800025b4:	69a2                	ld	s3,8(sp)
    800025b6:	6a02                	ld	s4,0(sp)
    800025b8:	6145                	addi	sp,sp,48
    800025ba:	8082                	ret
    memmove(dst, (char*)src, len);
    800025bc:	000a061b          	sext.w	a2,s4
    800025c0:	85ce                	mv	a1,s3
    800025c2:	854a                	mv	a0,s2
    800025c4:	ffffe097          	auipc	ra,0xffffe
    800025c8:	7a8080e7          	jalr	1960(ra) # 80000d6c <memmove>
    return 0;
    800025cc:	8526                	mv	a0,s1
    800025ce:	bff9                	j	800025ac <either_copyin+0x32>

00000000800025d0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800025d0:	715d                	addi	sp,sp,-80
    800025d2:	e486                	sd	ra,72(sp)
    800025d4:	e0a2                	sd	s0,64(sp)
    800025d6:	fc26                	sd	s1,56(sp)
    800025d8:	f84a                	sd	s2,48(sp)
    800025da:	f44e                	sd	s3,40(sp)
    800025dc:	f052                	sd	s4,32(sp)
    800025de:	ec56                	sd	s5,24(sp)
    800025e0:	e85a                	sd	s6,16(sp)
    800025e2:	e45e                	sd	s7,8(sp)
    800025e4:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800025e6:	00006517          	auipc	a0,0x6
    800025ea:	ae250513          	addi	a0,a0,-1310 # 800080c8 <digits+0x88>
    800025ee:	ffffe097          	auipc	ra,0xffffe
    800025f2:	fa4080e7          	jalr	-92(ra) # 80000592 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025f6:	00010497          	auipc	s1,0x10
    800025fa:	8da48493          	addi	s1,s1,-1830 # 80011ed0 <proc+0x168>
    800025fe:	00015917          	auipc	s2,0x15
    80002602:	6d290913          	addi	s2,s2,1746 # 80017cd0 <bcache+0x150>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002606:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    80002608:	00006997          	auipc	s3,0x6
    8000260c:	c4898993          	addi	s3,s3,-952 # 80008250 <digits+0x210>
    printf("%d %s %s", p->pid, state, p->name);
    80002610:	00006a97          	auipc	s5,0x6
    80002614:	c48a8a93          	addi	s5,s5,-952 # 80008258 <digits+0x218>
    printf("\n");
    80002618:	00006a17          	auipc	s4,0x6
    8000261c:	ab0a0a13          	addi	s4,s4,-1360 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002620:	00006b97          	auipc	s7,0x6
    80002624:	c70b8b93          	addi	s7,s7,-912 # 80008290 <states.1706>
    80002628:	a00d                	j	8000264a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000262a:	ed06a583          	lw	a1,-304(a3)
    8000262e:	8556                	mv	a0,s5
    80002630:	ffffe097          	auipc	ra,0xffffe
    80002634:	f62080e7          	jalr	-158(ra) # 80000592 <printf>
    printf("\n");
    80002638:	8552                	mv	a0,s4
    8000263a:	ffffe097          	auipc	ra,0xffffe
    8000263e:	f58080e7          	jalr	-168(ra) # 80000592 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002642:	17848493          	addi	s1,s1,376
    80002646:	03248163          	beq	s1,s2,80002668 <procdump+0x98>
    if(p->state == UNUSED)
    8000264a:	86a6                	mv	a3,s1
    8000264c:	eb04a783          	lw	a5,-336(s1)
    80002650:	dbed                	beqz	a5,80002642 <procdump+0x72>
      state = "???";
    80002652:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002654:	fcfb6be3          	bltu	s6,a5,8000262a <procdump+0x5a>
    80002658:	1782                	slli	a5,a5,0x20
    8000265a:	9381                	srli	a5,a5,0x20
    8000265c:	078e                	slli	a5,a5,0x3
    8000265e:	97de                	add	a5,a5,s7
    80002660:	6390                	ld	a2,0(a5)
    80002662:	f661                	bnez	a2,8000262a <procdump+0x5a>
      state = "???";
    80002664:	864e                	mv	a2,s3
    80002666:	b7d1                	j	8000262a <procdump+0x5a>
  }
}
    80002668:	60a6                	ld	ra,72(sp)
    8000266a:	6406                	ld	s0,64(sp)
    8000266c:	74e2                	ld	s1,56(sp)
    8000266e:	7942                	ld	s2,48(sp)
    80002670:	79a2                	ld	s3,40(sp)
    80002672:	7a02                	ld	s4,32(sp)
    80002674:	6ae2                	ld	s5,24(sp)
    80002676:	6b42                	ld	s6,16(sp)
    80002678:	6ba2                	ld	s7,8(sp)
    8000267a:	6161                	addi	sp,sp,80
    8000267c:	8082                	ret

000000008000267e <swtch>:
    8000267e:	00153023          	sd	ra,0(a0)
    80002682:	00253423          	sd	sp,8(a0)
    80002686:	e900                	sd	s0,16(a0)
    80002688:	ed04                	sd	s1,24(a0)
    8000268a:	03253023          	sd	s2,32(a0)
    8000268e:	03353423          	sd	s3,40(a0)
    80002692:	03453823          	sd	s4,48(a0)
    80002696:	03553c23          	sd	s5,56(a0)
    8000269a:	05653023          	sd	s6,64(a0)
    8000269e:	05753423          	sd	s7,72(a0)
    800026a2:	05853823          	sd	s8,80(a0)
    800026a6:	05953c23          	sd	s9,88(a0)
    800026aa:	07a53023          	sd	s10,96(a0)
    800026ae:	07b53423          	sd	s11,104(a0)
    800026b2:	0005b083          	ld	ra,0(a1)
    800026b6:	0085b103          	ld	sp,8(a1)
    800026ba:	6980                	ld	s0,16(a1)
    800026bc:	6d84                	ld	s1,24(a1)
    800026be:	0205b903          	ld	s2,32(a1)
    800026c2:	0285b983          	ld	s3,40(a1)
    800026c6:	0305ba03          	ld	s4,48(a1)
    800026ca:	0385ba83          	ld	s5,56(a1)
    800026ce:	0405bb03          	ld	s6,64(a1)
    800026d2:	0485bb83          	ld	s7,72(a1)
    800026d6:	0505bc03          	ld	s8,80(a1)
    800026da:	0585bc83          	ld	s9,88(a1)
    800026de:	0605bd03          	ld	s10,96(a1)
    800026e2:	0685bd83          	ld	s11,104(a1)
    800026e6:	8082                	ret

00000000800026e8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800026e8:	1141                	addi	sp,sp,-16
    800026ea:	e406                	sd	ra,8(sp)
    800026ec:	e022                	sd	s0,0(sp)
    800026ee:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800026f0:	00006597          	auipc	a1,0x6
    800026f4:	bc858593          	addi	a1,a1,-1080 # 800082b8 <states.1706+0x28>
    800026f8:	00015517          	auipc	a0,0x15
    800026fc:	47050513          	addi	a0,a0,1136 # 80017b68 <tickslock>
    80002700:	ffffe097          	auipc	ra,0xffffe
    80002704:	480080e7          	jalr	1152(ra) # 80000b80 <initlock>
}
    80002708:	60a2                	ld	ra,8(sp)
    8000270a:	6402                	ld	s0,0(sp)
    8000270c:	0141                	addi	sp,sp,16
    8000270e:	8082                	ret

0000000080002710 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002710:	1141                	addi	sp,sp,-16
    80002712:	e422                	sd	s0,8(sp)
    80002714:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002716:	00003797          	auipc	a5,0x3
    8000271a:	73a78793          	addi	a5,a5,1850 # 80005e50 <kernelvec>
    8000271e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002722:	6422                	ld	s0,8(sp)
    80002724:	0141                	addi	sp,sp,16
    80002726:	8082                	ret

0000000080002728 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002728:	1141                	addi	sp,sp,-16
    8000272a:	e406                	sd	ra,8(sp)
    8000272c:	e022                	sd	s0,0(sp)
    8000272e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002730:	fffff097          	auipc	ra,0xfffff
    80002734:	35a080e7          	jalr	858(ra) # 80001a8a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002738:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000273c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000273e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002742:	00005617          	auipc	a2,0x5
    80002746:	8be60613          	addi	a2,a2,-1858 # 80007000 <_trampoline>
    8000274a:	00005697          	auipc	a3,0x5
    8000274e:	8b668693          	addi	a3,a3,-1866 # 80007000 <_trampoline>
    80002752:	8e91                	sub	a3,a3,a2
    80002754:	040007b7          	lui	a5,0x4000
    80002758:	17fd                	addi	a5,a5,-1
    8000275a:	07b2                	slli	a5,a5,0xc
    8000275c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000275e:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002762:	7538                	ld	a4,104(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002764:	180026f3          	csrr	a3,satp
    80002768:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000276a:	7538                	ld	a4,104(a0)
    8000276c:	6134                	ld	a3,64(a0)
    8000276e:	6585                	lui	a1,0x1
    80002770:	96ae                	add	a3,a3,a1
    80002772:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002774:	7538                	ld	a4,104(a0)
    80002776:	00000697          	auipc	a3,0x0
    8000277a:	13868693          	addi	a3,a3,312 # 800028ae <usertrap>
    8000277e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002780:	7538                	ld	a4,104(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002782:	8692                	mv	a3,tp
    80002784:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002786:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000278a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000278e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002792:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002796:	7538                	ld	a4,104(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002798:	6f18                	ld	a4,24(a4)
    8000279a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000279e:	712c                	ld	a1,96(a0)
    800027a0:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    800027a2:	00005717          	auipc	a4,0x5
    800027a6:	8ee70713          	addi	a4,a4,-1810 # 80007090 <userret>
    800027aa:	8f11                	sub	a4,a4,a2
    800027ac:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    800027ae:	577d                	li	a4,-1
    800027b0:	177e                	slli	a4,a4,0x3f
    800027b2:	8dd9                	or	a1,a1,a4
    800027b4:	02000537          	lui	a0,0x2000
    800027b8:	157d                	addi	a0,a0,-1
    800027ba:	0536                	slli	a0,a0,0xd
    800027bc:	9782                	jalr	a5
}
    800027be:	60a2                	ld	ra,8(sp)
    800027c0:	6402                	ld	s0,0(sp)
    800027c2:	0141                	addi	sp,sp,16
    800027c4:	8082                	ret

00000000800027c6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800027c6:	1101                	addi	sp,sp,-32
    800027c8:	ec06                	sd	ra,24(sp)
    800027ca:	e822                	sd	s0,16(sp)
    800027cc:	e426                	sd	s1,8(sp)
    800027ce:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800027d0:	00015497          	auipc	s1,0x15
    800027d4:	39848493          	addi	s1,s1,920 # 80017b68 <tickslock>
    800027d8:	8526                	mv	a0,s1
    800027da:	ffffe097          	auipc	ra,0xffffe
    800027de:	436080e7          	jalr	1078(ra) # 80000c10 <acquire>
  ticks++;
    800027e2:	00007517          	auipc	a0,0x7
    800027e6:	83e50513          	addi	a0,a0,-1986 # 80009020 <ticks>
    800027ea:	411c                	lw	a5,0(a0)
    800027ec:	2785                	addiw	a5,a5,1
    800027ee:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800027f0:	00000097          	auipc	ra,0x0
    800027f4:	c58080e7          	jalr	-936(ra) # 80002448 <wakeup>
  release(&tickslock);
    800027f8:	8526                	mv	a0,s1
    800027fa:	ffffe097          	auipc	ra,0xffffe
    800027fe:	4ca080e7          	jalr	1226(ra) # 80000cc4 <release>
}
    80002802:	60e2                	ld	ra,24(sp)
    80002804:	6442                	ld	s0,16(sp)
    80002806:	64a2                	ld	s1,8(sp)
    80002808:	6105                	addi	sp,sp,32
    8000280a:	8082                	ret

000000008000280c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000280c:	1101                	addi	sp,sp,-32
    8000280e:	ec06                	sd	ra,24(sp)
    80002810:	e822                	sd	s0,16(sp)
    80002812:	e426                	sd	s1,8(sp)
    80002814:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002816:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    8000281a:	00074d63          	bltz	a4,80002834 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    8000281e:	57fd                	li	a5,-1
    80002820:	17fe                	slli	a5,a5,0x3f
    80002822:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002824:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002826:	06f70363          	beq	a4,a5,8000288c <devintr+0x80>
  }
}
    8000282a:	60e2                	ld	ra,24(sp)
    8000282c:	6442                	ld	s0,16(sp)
    8000282e:	64a2                	ld	s1,8(sp)
    80002830:	6105                	addi	sp,sp,32
    80002832:	8082                	ret
     (scause & 0xff) == 9){
    80002834:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002838:	46a5                	li	a3,9
    8000283a:	fed792e3          	bne	a5,a3,8000281e <devintr+0x12>
    int irq = plic_claim();
    8000283e:	00003097          	auipc	ra,0x3
    80002842:	71a080e7          	jalr	1818(ra) # 80005f58 <plic_claim>
    80002846:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002848:	47a9                	li	a5,10
    8000284a:	02f50763          	beq	a0,a5,80002878 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    8000284e:	4785                	li	a5,1
    80002850:	02f50963          	beq	a0,a5,80002882 <devintr+0x76>
    return 1;
    80002854:	4505                	li	a0,1
    } else if(irq){
    80002856:	d8f1                	beqz	s1,8000282a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002858:	85a6                	mv	a1,s1
    8000285a:	00006517          	auipc	a0,0x6
    8000285e:	a6650513          	addi	a0,a0,-1434 # 800082c0 <states.1706+0x30>
    80002862:	ffffe097          	auipc	ra,0xffffe
    80002866:	d30080e7          	jalr	-720(ra) # 80000592 <printf>
      plic_complete(irq);
    8000286a:	8526                	mv	a0,s1
    8000286c:	00003097          	auipc	ra,0x3
    80002870:	710080e7          	jalr	1808(ra) # 80005f7c <plic_complete>
    return 1;
    80002874:	4505                	li	a0,1
    80002876:	bf55                	j	8000282a <devintr+0x1e>
      uartintr();
    80002878:	ffffe097          	auipc	ra,0xffffe
    8000287c:	15c080e7          	jalr	348(ra) # 800009d4 <uartintr>
    80002880:	b7ed                	j	8000286a <devintr+0x5e>
      virtio_disk_intr();
    80002882:	00004097          	auipc	ra,0x4
    80002886:	b94080e7          	jalr	-1132(ra) # 80006416 <virtio_disk_intr>
    8000288a:	b7c5                	j	8000286a <devintr+0x5e>
    if(cpuid() == 0){
    8000288c:	fffff097          	auipc	ra,0xfffff
    80002890:	1d2080e7          	jalr	466(ra) # 80001a5e <cpuid>
    80002894:	c901                	beqz	a0,800028a4 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002896:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000289a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000289c:	14479073          	csrw	sip,a5
    return 2;
    800028a0:	4509                	li	a0,2
    800028a2:	b761                	j	8000282a <devintr+0x1e>
      clockintr();
    800028a4:	00000097          	auipc	ra,0x0
    800028a8:	f22080e7          	jalr	-222(ra) # 800027c6 <clockintr>
    800028ac:	b7ed                	j	80002896 <devintr+0x8a>

00000000800028ae <usertrap>:
{
    800028ae:	7179                	addi	sp,sp,-48
    800028b0:	f406                	sd	ra,40(sp)
    800028b2:	f022                	sd	s0,32(sp)
    800028b4:	ec26                	sd	s1,24(sp)
    800028b6:	e84a                	sd	s2,16(sp)
    800028b8:	e44e                	sd	s3,8(sp)
    800028ba:	e052                	sd	s4,0(sp)
    800028bc:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028be:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800028c2:	1007f793          	andi	a5,a5,256
    800028c6:	e7a5                	bnez	a5,8000292e <usertrap+0x80>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028c8:	00003797          	auipc	a5,0x3
    800028cc:	58878793          	addi	a5,a5,1416 # 80005e50 <kernelvec>
    800028d0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800028d4:	fffff097          	auipc	ra,0xfffff
    800028d8:	1b6080e7          	jalr	438(ra) # 80001a8a <myproc>
    800028dc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800028de:	753c                	ld	a5,104(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028e0:	14102773          	csrr	a4,sepc
    800028e4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028e6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800028ea:	47a1                	li	a5,8
    800028ec:	04f71f63          	bne	a4,a5,8000294a <usertrap+0x9c>
    if(p->killed)
    800028f0:	591c                	lw	a5,48(a0)
    800028f2:	e7b1                	bnez	a5,8000293e <usertrap+0x90>
    p->trapframe->epc += 4;
    800028f4:	74b8                	ld	a4,104(s1)
    800028f6:	6f1c                	ld	a5,24(a4)
    800028f8:	0791                	addi	a5,a5,4
    800028fa:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028fc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002900:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002904:	10079073          	csrw	sstatus,a5
    syscall();
    80002908:	00000097          	auipc	ra,0x0
    8000290c:	354080e7          	jalr	852(ra) # 80002c5c <syscall>
  if(p->killed)
    80002910:	589c                	lw	a5,48(s1)
    80002912:	10079263          	bnez	a5,80002a16 <usertrap+0x168>
  usertrapret();
    80002916:	00000097          	auipc	ra,0x0
    8000291a:	e12080e7          	jalr	-494(ra) # 80002728 <usertrapret>
}
    8000291e:	70a2                	ld	ra,40(sp)
    80002920:	7402                	ld	s0,32(sp)
    80002922:	64e2                	ld	s1,24(sp)
    80002924:	6942                	ld	s2,16(sp)
    80002926:	69a2                	ld	s3,8(sp)
    80002928:	6a02                	ld	s4,0(sp)
    8000292a:	6145                	addi	sp,sp,48
    8000292c:	8082                	ret
    panic("usertrap: not from user mode");
    8000292e:	00006517          	auipc	a0,0x6
    80002932:	9b250513          	addi	a0,a0,-1614 # 800082e0 <states.1706+0x50>
    80002936:	ffffe097          	auipc	ra,0xffffe
    8000293a:	c12080e7          	jalr	-1006(ra) # 80000548 <panic>
      exit(-1);
    8000293e:	557d                	li	a0,-1
    80002940:	00000097          	auipc	ra,0x0
    80002944:	83c080e7          	jalr	-1988(ra) # 8000217c <exit>
    80002948:	b775                	j	800028f4 <usertrap+0x46>
  } else if((which_dev = devintr()) != 0){
    8000294a:	00000097          	auipc	ra,0x0
    8000294e:	ec2080e7          	jalr	-318(ra) # 8000280c <devintr>
    80002952:	892a                	mv	s2,a0
    80002954:	ed55                	bnez	a0,80002a10 <usertrap+0x162>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002956:	143029f3          	csrr	s3,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000295a:	14202773          	csrr	a4,scause
      if((r_scause() == 13 || r_scause() == 15) && va < p->sz && va >= p->ustack){
    8000295e:	47b5                	li	a5,13
    80002960:	04f70d63          	beq	a4,a5,800029ba <usertrap+0x10c>
    80002964:	14202773          	csrr	a4,scause
    80002968:	47bd                	li	a5,15
    8000296a:	04f70863          	beq	a4,a5,800029ba <usertrap+0x10c>
    8000296e:	142025f3          	csrr	a1,scause
          printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002972:	5c90                	lw	a2,56(s1)
    80002974:	00006517          	auipc	a0,0x6
    80002978:	98c50513          	addi	a0,a0,-1652 # 80008300 <states.1706+0x70>
    8000297c:	ffffe097          	auipc	ra,0xffffe
    80002980:	c16080e7          	jalr	-1002(ra) # 80000592 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002984:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002988:	14302673          	csrr	a2,stval
          printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000298c:	00006517          	auipc	a0,0x6
    80002990:	9a450513          	addi	a0,a0,-1628 # 80008330 <states.1706+0xa0>
    80002994:	ffffe097          	auipc	ra,0xffffe
    80002998:	bfe080e7          	jalr	-1026(ra) # 80000592 <printf>
          p->killed = 1;
    8000299c:	4785                	li	a5,1
    8000299e:	d89c                	sw	a5,48(s1)
    exit(-1);
    800029a0:	557d                	li	a0,-1
    800029a2:	fffff097          	auipc	ra,0xfffff
    800029a6:	7da080e7          	jalr	2010(ra) # 8000217c <exit>
  if(which_dev == 2)
    800029aa:	4789                	li	a5,2
    800029ac:	f6f915e3          	bne	s2,a5,80002916 <usertrap+0x68>
    yield();
    800029b0:	00000097          	auipc	ra,0x0
    800029b4:	8d6080e7          	jalr	-1834(ra) # 80002286 <yield>
    800029b8:	bfb9                	j	80002916 <usertrap+0x68>
      uint64 va = PGROUNDDOWN(r_stval());
    800029ba:	77fd                	lui	a5,0xfffff
    800029bc:	00f9f9b3          	and	s3,s3,a5
      if((r_scause() == 13 || r_scause() == 15) && va < p->sz && va >= p->ustack){
    800029c0:	68bc                	ld	a5,80(s1)
    800029c2:	faf9f6e3          	bgeu	s3,a5,8000296e <usertrap+0xc0>
    800029c6:	64bc                	ld	a5,72(s1)
    800029c8:	faf9e3e3          	bltu	s3,a5,8000296e <usertrap+0xc0>
          char* mem = kalloc();
    800029cc:	ffffe097          	auipc	ra,0xffffe
    800029d0:	154080e7          	jalr	340(ra) # 80000b20 <kalloc>
    800029d4:	8a2a                	mv	s4,a0
          if(va > p->maxva)
    800029d6:	6cbc                	ld	a5,88(s1)
    800029d8:	0137f563          	bgeu	a5,s3,800029e2 <usertrap+0x134>
              p->maxva = va+PGSIZE;
    800029dc:	6785                	lui	a5,0x1
    800029de:	97ce                	add	a5,a5,s3
    800029e0:	ecbc                	sd	a5,88(s1)
          if(mem == 0){
    800029e2:	020a0463          	beqz	s4,80002a0a <usertrap+0x15c>
          else if(mappages(p->pagetable, va, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800029e6:	4779                	li	a4,30
    800029e8:	86d2                	mv	a3,s4
    800029ea:	6605                	lui	a2,0x1
    800029ec:	85ce                	mv	a1,s3
    800029ee:	70a8                	ld	a0,96(s1)
    800029f0:	fffff097          	auipc	ra,0xfffff
    800029f4:	800080e7          	jalr	-2048(ra) # 800011f0 <mappages>
    800029f8:	dd01                	beqz	a0,80002910 <usertrap+0x62>
              kfree(mem);
    800029fa:	8552                	mv	a0,s4
    800029fc:	ffffe097          	auipc	ra,0xffffe
    80002a00:	028080e7          	jalr	40(ra) # 80000a24 <kfree>
              p->killed = 1;
    80002a04:	4785                	li	a5,1
    80002a06:	d89c                	sw	a5,48(s1)
    80002a08:	bf61                	j	800029a0 <usertrap+0xf2>
              p->killed = 1;
    80002a0a:	4785                	li	a5,1
    80002a0c:	d89c                	sw	a5,48(s1)
    80002a0e:	bf49                	j	800029a0 <usertrap+0xf2>
  if(p->killed)
    80002a10:	589c                	lw	a5,48(s1)
    80002a12:	dfc1                	beqz	a5,800029aa <usertrap+0xfc>
    80002a14:	b771                	j	800029a0 <usertrap+0xf2>
    80002a16:	4901                	li	s2,0
    80002a18:	b761                	j	800029a0 <usertrap+0xf2>

0000000080002a1a <kerneltrap>:
{
    80002a1a:	7179                	addi	sp,sp,-48
    80002a1c:	f406                	sd	ra,40(sp)
    80002a1e:	f022                	sd	s0,32(sp)
    80002a20:	ec26                	sd	s1,24(sp)
    80002a22:	e84a                	sd	s2,16(sp)
    80002a24:	e44e                	sd	s3,8(sp)
    80002a26:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a28:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a2c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a30:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002a34:	1004f793          	andi	a5,s1,256
    80002a38:	cb85                	beqz	a5,80002a68 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a3a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002a3e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002a40:	ef85                	bnez	a5,80002a78 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002a42:	00000097          	auipc	ra,0x0
    80002a46:	dca080e7          	jalr	-566(ra) # 8000280c <devintr>
    80002a4a:	cd1d                	beqz	a0,80002a88 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a4c:	4789                	li	a5,2
    80002a4e:	06f50a63          	beq	a0,a5,80002ac2 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a52:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a56:	10049073          	csrw	sstatus,s1
}
    80002a5a:	70a2                	ld	ra,40(sp)
    80002a5c:	7402                	ld	s0,32(sp)
    80002a5e:	64e2                	ld	s1,24(sp)
    80002a60:	6942                	ld	s2,16(sp)
    80002a62:	69a2                	ld	s3,8(sp)
    80002a64:	6145                	addi	sp,sp,48
    80002a66:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002a68:	00006517          	auipc	a0,0x6
    80002a6c:	8e850513          	addi	a0,a0,-1816 # 80008350 <states.1706+0xc0>
    80002a70:	ffffe097          	auipc	ra,0xffffe
    80002a74:	ad8080e7          	jalr	-1320(ra) # 80000548 <panic>
    panic("kerneltrap: interrupts enabled");
    80002a78:	00006517          	auipc	a0,0x6
    80002a7c:	90050513          	addi	a0,a0,-1792 # 80008378 <states.1706+0xe8>
    80002a80:	ffffe097          	auipc	ra,0xffffe
    80002a84:	ac8080e7          	jalr	-1336(ra) # 80000548 <panic>
    printf("scause %p\n", scause);
    80002a88:	85ce                	mv	a1,s3
    80002a8a:	00006517          	auipc	a0,0x6
    80002a8e:	90e50513          	addi	a0,a0,-1778 # 80008398 <states.1706+0x108>
    80002a92:	ffffe097          	auipc	ra,0xffffe
    80002a96:	b00080e7          	jalr	-1280(ra) # 80000592 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a9a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a9e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002aa2:	00006517          	auipc	a0,0x6
    80002aa6:	90650513          	addi	a0,a0,-1786 # 800083a8 <states.1706+0x118>
    80002aaa:	ffffe097          	auipc	ra,0xffffe
    80002aae:	ae8080e7          	jalr	-1304(ra) # 80000592 <printf>
    panic("kerneltrap");
    80002ab2:	00006517          	auipc	a0,0x6
    80002ab6:	90e50513          	addi	a0,a0,-1778 # 800083c0 <states.1706+0x130>
    80002aba:	ffffe097          	auipc	ra,0xffffe
    80002abe:	a8e080e7          	jalr	-1394(ra) # 80000548 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002ac2:	fffff097          	auipc	ra,0xfffff
    80002ac6:	fc8080e7          	jalr	-56(ra) # 80001a8a <myproc>
    80002aca:	d541                	beqz	a0,80002a52 <kerneltrap+0x38>
    80002acc:	fffff097          	auipc	ra,0xfffff
    80002ad0:	fbe080e7          	jalr	-66(ra) # 80001a8a <myproc>
    80002ad4:	4d18                	lw	a4,24(a0)
    80002ad6:	478d                	li	a5,3
    80002ad8:	f6f71de3          	bne	a4,a5,80002a52 <kerneltrap+0x38>
    yield();
    80002adc:	fffff097          	auipc	ra,0xfffff
    80002ae0:	7aa080e7          	jalr	1962(ra) # 80002286 <yield>
    80002ae4:	b7bd                	j	80002a52 <kerneltrap+0x38>

0000000080002ae6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002ae6:	1101                	addi	sp,sp,-32
    80002ae8:	ec06                	sd	ra,24(sp)
    80002aea:	e822                	sd	s0,16(sp)
    80002aec:	e426                	sd	s1,8(sp)
    80002aee:	1000                	addi	s0,sp,32
    80002af0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002af2:	fffff097          	auipc	ra,0xfffff
    80002af6:	f98080e7          	jalr	-104(ra) # 80001a8a <myproc>
  switch (n) {
    80002afa:	4795                	li	a5,5
    80002afc:	0497e163          	bltu	a5,s1,80002b3e <argraw+0x58>
    80002b00:	048a                	slli	s1,s1,0x2
    80002b02:	00006717          	auipc	a4,0x6
    80002b06:	8f670713          	addi	a4,a4,-1802 # 800083f8 <states.1706+0x168>
    80002b0a:	94ba                	add	s1,s1,a4
    80002b0c:	409c                	lw	a5,0(s1)
    80002b0e:	97ba                	add	a5,a5,a4
    80002b10:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002b12:	753c                	ld	a5,104(a0)
    80002b14:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002b16:	60e2                	ld	ra,24(sp)
    80002b18:	6442                	ld	s0,16(sp)
    80002b1a:	64a2                	ld	s1,8(sp)
    80002b1c:	6105                	addi	sp,sp,32
    80002b1e:	8082                	ret
    return p->trapframe->a1;
    80002b20:	753c                	ld	a5,104(a0)
    80002b22:	7fa8                	ld	a0,120(a5)
    80002b24:	bfcd                	j	80002b16 <argraw+0x30>
    return p->trapframe->a2;
    80002b26:	753c                	ld	a5,104(a0)
    80002b28:	63c8                	ld	a0,128(a5)
    80002b2a:	b7f5                	j	80002b16 <argraw+0x30>
    return p->trapframe->a3;
    80002b2c:	753c                	ld	a5,104(a0)
    80002b2e:	67c8                	ld	a0,136(a5)
    80002b30:	b7dd                	j	80002b16 <argraw+0x30>
    return p->trapframe->a4;
    80002b32:	753c                	ld	a5,104(a0)
    80002b34:	6bc8                	ld	a0,144(a5)
    80002b36:	b7c5                	j	80002b16 <argraw+0x30>
    return p->trapframe->a5;
    80002b38:	753c                	ld	a5,104(a0)
    80002b3a:	6fc8                	ld	a0,152(a5)
    80002b3c:	bfe9                	j	80002b16 <argraw+0x30>
  panic("argraw");
    80002b3e:	00006517          	auipc	a0,0x6
    80002b42:	89250513          	addi	a0,a0,-1902 # 800083d0 <states.1706+0x140>
    80002b46:	ffffe097          	auipc	ra,0xffffe
    80002b4a:	a02080e7          	jalr	-1534(ra) # 80000548 <panic>

0000000080002b4e <fetchaddr>:
{
    80002b4e:	1101                	addi	sp,sp,-32
    80002b50:	ec06                	sd	ra,24(sp)
    80002b52:	e822                	sd	s0,16(sp)
    80002b54:	e426                	sd	s1,8(sp)
    80002b56:	e04a                	sd	s2,0(sp)
    80002b58:	1000                	addi	s0,sp,32
    80002b5a:	84aa                	mv	s1,a0
    80002b5c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002b5e:	fffff097          	auipc	ra,0xfffff
    80002b62:	f2c080e7          	jalr	-212(ra) # 80001a8a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002b66:	693c                	ld	a5,80(a0)
    80002b68:	02f4f863          	bgeu	s1,a5,80002b98 <fetchaddr+0x4a>
    80002b6c:	00848713          	addi	a4,s1,8
    80002b70:	02e7e663          	bltu	a5,a4,80002b9c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002b74:	46a1                	li	a3,8
    80002b76:	8626                	mv	a2,s1
    80002b78:	85ca                	mv	a1,s2
    80002b7a:	7128                	ld	a0,96(a0)
    80002b7c:	fffff097          	auipc	ra,0xfffff
    80002b80:	c5a080e7          	jalr	-934(ra) # 800017d6 <copyin>
    80002b84:	00a03533          	snez	a0,a0
    80002b88:	40a00533          	neg	a0,a0
}
    80002b8c:	60e2                	ld	ra,24(sp)
    80002b8e:	6442                	ld	s0,16(sp)
    80002b90:	64a2                	ld	s1,8(sp)
    80002b92:	6902                	ld	s2,0(sp)
    80002b94:	6105                	addi	sp,sp,32
    80002b96:	8082                	ret
    return -1;
    80002b98:	557d                	li	a0,-1
    80002b9a:	bfcd                	j	80002b8c <fetchaddr+0x3e>
    80002b9c:	557d                	li	a0,-1
    80002b9e:	b7fd                	j	80002b8c <fetchaddr+0x3e>

0000000080002ba0 <fetchstr>:
{
    80002ba0:	7179                	addi	sp,sp,-48
    80002ba2:	f406                	sd	ra,40(sp)
    80002ba4:	f022                	sd	s0,32(sp)
    80002ba6:	ec26                	sd	s1,24(sp)
    80002ba8:	e84a                	sd	s2,16(sp)
    80002baa:	e44e                	sd	s3,8(sp)
    80002bac:	1800                	addi	s0,sp,48
    80002bae:	892a                	mv	s2,a0
    80002bb0:	84ae                	mv	s1,a1
    80002bb2:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002bb4:	fffff097          	auipc	ra,0xfffff
    80002bb8:	ed6080e7          	jalr	-298(ra) # 80001a8a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002bbc:	86ce                	mv	a3,s3
    80002bbe:	864a                	mv	a2,s2
    80002bc0:	85a6                	mv	a1,s1
    80002bc2:	7128                	ld	a0,96(a0)
    80002bc4:	fffff097          	auipc	ra,0xfffff
    80002bc8:	c9e080e7          	jalr	-866(ra) # 80001862 <copyinstr>
  if(err < 0)
    80002bcc:	00054763          	bltz	a0,80002bda <fetchstr+0x3a>
  return strlen(buf);
    80002bd0:	8526                	mv	a0,s1
    80002bd2:	ffffe097          	auipc	ra,0xffffe
    80002bd6:	2c2080e7          	jalr	706(ra) # 80000e94 <strlen>
}
    80002bda:	70a2                	ld	ra,40(sp)
    80002bdc:	7402                	ld	s0,32(sp)
    80002bde:	64e2                	ld	s1,24(sp)
    80002be0:	6942                	ld	s2,16(sp)
    80002be2:	69a2                	ld	s3,8(sp)
    80002be4:	6145                	addi	sp,sp,48
    80002be6:	8082                	ret

0000000080002be8 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002be8:	1101                	addi	sp,sp,-32
    80002bea:	ec06                	sd	ra,24(sp)
    80002bec:	e822                	sd	s0,16(sp)
    80002bee:	e426                	sd	s1,8(sp)
    80002bf0:	1000                	addi	s0,sp,32
    80002bf2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002bf4:	00000097          	auipc	ra,0x0
    80002bf8:	ef2080e7          	jalr	-270(ra) # 80002ae6 <argraw>
    80002bfc:	c088                	sw	a0,0(s1)
  return 0;
}
    80002bfe:	4501                	li	a0,0
    80002c00:	60e2                	ld	ra,24(sp)
    80002c02:	6442                	ld	s0,16(sp)
    80002c04:	64a2                	ld	s1,8(sp)
    80002c06:	6105                	addi	sp,sp,32
    80002c08:	8082                	ret

0000000080002c0a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002c0a:	1101                	addi	sp,sp,-32
    80002c0c:	ec06                	sd	ra,24(sp)
    80002c0e:	e822                	sd	s0,16(sp)
    80002c10:	e426                	sd	s1,8(sp)
    80002c12:	1000                	addi	s0,sp,32
    80002c14:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c16:	00000097          	auipc	ra,0x0
    80002c1a:	ed0080e7          	jalr	-304(ra) # 80002ae6 <argraw>
    80002c1e:	e088                	sd	a0,0(s1)
  return 0;
}
    80002c20:	4501                	li	a0,0
    80002c22:	60e2                	ld	ra,24(sp)
    80002c24:	6442                	ld	s0,16(sp)
    80002c26:	64a2                	ld	s1,8(sp)
    80002c28:	6105                	addi	sp,sp,32
    80002c2a:	8082                	ret

0000000080002c2c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002c2c:	1101                	addi	sp,sp,-32
    80002c2e:	ec06                	sd	ra,24(sp)
    80002c30:	e822                	sd	s0,16(sp)
    80002c32:	e426                	sd	s1,8(sp)
    80002c34:	e04a                	sd	s2,0(sp)
    80002c36:	1000                	addi	s0,sp,32
    80002c38:	84ae                	mv	s1,a1
    80002c3a:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002c3c:	00000097          	auipc	ra,0x0
    80002c40:	eaa080e7          	jalr	-342(ra) # 80002ae6 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002c44:	864a                	mv	a2,s2
    80002c46:	85a6                	mv	a1,s1
    80002c48:	00000097          	auipc	ra,0x0
    80002c4c:	f58080e7          	jalr	-168(ra) # 80002ba0 <fetchstr>
}
    80002c50:	60e2                	ld	ra,24(sp)
    80002c52:	6442                	ld	s0,16(sp)
    80002c54:	64a2                	ld	s1,8(sp)
    80002c56:	6902                	ld	s2,0(sp)
    80002c58:	6105                	addi	sp,sp,32
    80002c5a:	8082                	ret

0000000080002c5c <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002c5c:	1101                	addi	sp,sp,-32
    80002c5e:	ec06                	sd	ra,24(sp)
    80002c60:	e822                	sd	s0,16(sp)
    80002c62:	e426                	sd	s1,8(sp)
    80002c64:	e04a                	sd	s2,0(sp)
    80002c66:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002c68:	fffff097          	auipc	ra,0xfffff
    80002c6c:	e22080e7          	jalr	-478(ra) # 80001a8a <myproc>
    80002c70:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002c72:	06853903          	ld	s2,104(a0)
    80002c76:	0a893783          	ld	a5,168(s2)
    80002c7a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002c7e:	37fd                	addiw	a5,a5,-1
    80002c80:	4751                	li	a4,20
    80002c82:	00f76f63          	bltu	a4,a5,80002ca0 <syscall+0x44>
    80002c86:	00369713          	slli	a4,a3,0x3
    80002c8a:	00005797          	auipc	a5,0x5
    80002c8e:	78678793          	addi	a5,a5,1926 # 80008410 <syscalls>
    80002c92:	97ba                	add	a5,a5,a4
    80002c94:	639c                	ld	a5,0(a5)
    80002c96:	c789                	beqz	a5,80002ca0 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002c98:	9782                	jalr	a5
    80002c9a:	06a93823          	sd	a0,112(s2)
    80002c9e:	a839                	j	80002cbc <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002ca0:	16848613          	addi	a2,s1,360
    80002ca4:	5c8c                	lw	a1,56(s1)
    80002ca6:	00005517          	auipc	a0,0x5
    80002caa:	73250513          	addi	a0,a0,1842 # 800083d8 <states.1706+0x148>
    80002cae:	ffffe097          	auipc	ra,0xffffe
    80002cb2:	8e4080e7          	jalr	-1820(ra) # 80000592 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002cb6:	74bc                	ld	a5,104(s1)
    80002cb8:	577d                	li	a4,-1
    80002cba:	fbb8                	sd	a4,112(a5)
  }
}
    80002cbc:	60e2                	ld	ra,24(sp)
    80002cbe:	6442                	ld	s0,16(sp)
    80002cc0:	64a2                	ld	s1,8(sp)
    80002cc2:	6902                	ld	s2,0(sp)
    80002cc4:	6105                	addi	sp,sp,32
    80002cc6:	8082                	ret

0000000080002cc8 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002cc8:	1101                	addi	sp,sp,-32
    80002cca:	ec06                	sd	ra,24(sp)
    80002ccc:	e822                	sd	s0,16(sp)
    80002cce:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002cd0:	fec40593          	addi	a1,s0,-20
    80002cd4:	4501                	li	a0,0
    80002cd6:	00000097          	auipc	ra,0x0
    80002cda:	f12080e7          	jalr	-238(ra) # 80002be8 <argint>
    return -1;
    80002cde:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002ce0:	00054963          	bltz	a0,80002cf2 <sys_exit+0x2a>
  exit(n);
    80002ce4:	fec42503          	lw	a0,-20(s0)
    80002ce8:	fffff097          	auipc	ra,0xfffff
    80002cec:	494080e7          	jalr	1172(ra) # 8000217c <exit>
  return 0;  // not reached
    80002cf0:	4781                	li	a5,0
}
    80002cf2:	853e                	mv	a0,a5
    80002cf4:	60e2                	ld	ra,24(sp)
    80002cf6:	6442                	ld	s0,16(sp)
    80002cf8:	6105                	addi	sp,sp,32
    80002cfa:	8082                	ret

0000000080002cfc <sys_getpid>:

uint64
sys_getpid(void)
{
    80002cfc:	1141                	addi	sp,sp,-16
    80002cfe:	e406                	sd	ra,8(sp)
    80002d00:	e022                	sd	s0,0(sp)
    80002d02:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002d04:	fffff097          	auipc	ra,0xfffff
    80002d08:	d86080e7          	jalr	-634(ra) # 80001a8a <myproc>
}
    80002d0c:	5d08                	lw	a0,56(a0)
    80002d0e:	60a2                	ld	ra,8(sp)
    80002d10:	6402                	ld	s0,0(sp)
    80002d12:	0141                	addi	sp,sp,16
    80002d14:	8082                	ret

0000000080002d16 <sys_fork>:

uint64
sys_fork(void)
{
    80002d16:	1141                	addi	sp,sp,-16
    80002d18:	e406                	sd	ra,8(sp)
    80002d1a:	e022                	sd	s0,0(sp)
    80002d1c:	0800                	addi	s0,sp,16
  return fork();
    80002d1e:	fffff097          	auipc	ra,0xfffff
    80002d22:	144080e7          	jalr	324(ra) # 80001e62 <fork>
}
    80002d26:	60a2                	ld	ra,8(sp)
    80002d28:	6402                	ld	s0,0(sp)
    80002d2a:	0141                	addi	sp,sp,16
    80002d2c:	8082                	ret

0000000080002d2e <sys_wait>:

uint64
sys_wait(void)
{
    80002d2e:	1101                	addi	sp,sp,-32
    80002d30:	ec06                	sd	ra,24(sp)
    80002d32:	e822                	sd	s0,16(sp)
    80002d34:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002d36:	fe840593          	addi	a1,s0,-24
    80002d3a:	4501                	li	a0,0
    80002d3c:	00000097          	auipc	ra,0x0
    80002d40:	ece080e7          	jalr	-306(ra) # 80002c0a <argaddr>
    80002d44:	87aa                	mv	a5,a0
    return -1;
    80002d46:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002d48:	0007c863          	bltz	a5,80002d58 <sys_wait+0x2a>
  return wait(p);
    80002d4c:	fe843503          	ld	a0,-24(s0)
    80002d50:	fffff097          	auipc	ra,0xfffff
    80002d54:	5f0080e7          	jalr	1520(ra) # 80002340 <wait>
}
    80002d58:	60e2                	ld	ra,24(sp)
    80002d5a:	6442                	ld	s0,16(sp)
    80002d5c:	6105                	addi	sp,sp,32
    80002d5e:	8082                	ret

0000000080002d60 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002d60:	7179                	addi	sp,sp,-48
    80002d62:	f406                	sd	ra,40(sp)
    80002d64:	f022                	sd	s0,32(sp)
    80002d66:	ec26                	sd	s1,24(sp)
    80002d68:	e84a                	sd	s2,16(sp)
    80002d6a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002d6c:	fdc40593          	addi	a1,s0,-36
    80002d70:	4501                	li	a0,0
    80002d72:	00000097          	auipc	ra,0x0
    80002d76:	e76080e7          	jalr	-394(ra) # 80002be8 <argint>
    return -1;
    80002d7a:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80002d7c:	02054263          	bltz	a0,80002da0 <sys_sbrk+0x40>
  addr = myproc()->sz;
    80002d80:	fffff097          	auipc	ra,0xfffff
    80002d84:	d0a080e7          	jalr	-758(ra) # 80001a8a <myproc>
    80002d88:	4924                	lw	s1,80(a0)
  myproc()->sz += n;
    80002d8a:	fffff097          	auipc	ra,0xfffff
    80002d8e:	d00080e7          	jalr	-768(ra) # 80001a8a <myproc>
    80002d92:	fdc42703          	lw	a4,-36(s0)
    80002d96:	693c                	ld	a5,80(a0)
    80002d98:	97ba                	add	a5,a5,a4
    80002d9a:	e93c                	sd	a5,80(a0)
  if(n < 0){
    80002d9c:	00074963          	bltz	a4,80002dae <sys_sbrk+0x4e>
      uvmdealloc(myproc()->pagetable,addr,myproc()->sz);
  }
  return addr;
}
    80002da0:	8526                	mv	a0,s1
    80002da2:	70a2                	ld	ra,40(sp)
    80002da4:	7402                	ld	s0,32(sp)
    80002da6:	64e2                	ld	s1,24(sp)
    80002da8:	6942                	ld	s2,16(sp)
    80002daa:	6145                	addi	sp,sp,48
    80002dac:	8082                	ret
      uvmdealloc(myproc()->pagetable,addr,myproc()->sz);
    80002dae:	fffff097          	auipc	ra,0xfffff
    80002db2:	cdc080e7          	jalr	-804(ra) # 80001a8a <myproc>
    80002db6:	06053903          	ld	s2,96(a0)
    80002dba:	fffff097          	auipc	ra,0xfffff
    80002dbe:	cd0080e7          	jalr	-816(ra) # 80001a8a <myproc>
    80002dc2:	6930                	ld	a2,80(a0)
    80002dc4:	85a6                	mv	a1,s1
    80002dc6:	854a                	mv	a0,s2
    80002dc8:	ffffe097          	auipc	ra,0xffffe
    80002dcc:	706080e7          	jalr	1798(ra) # 800014ce <uvmdealloc>
  return addr;
    80002dd0:	bfc1                	j	80002da0 <sys_sbrk+0x40>

0000000080002dd2 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002dd2:	7139                	addi	sp,sp,-64
    80002dd4:	fc06                	sd	ra,56(sp)
    80002dd6:	f822                	sd	s0,48(sp)
    80002dd8:	f426                	sd	s1,40(sp)
    80002dda:	f04a                	sd	s2,32(sp)
    80002ddc:	ec4e                	sd	s3,24(sp)
    80002dde:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002de0:	fcc40593          	addi	a1,s0,-52
    80002de4:	4501                	li	a0,0
    80002de6:	00000097          	auipc	ra,0x0
    80002dea:	e02080e7          	jalr	-510(ra) # 80002be8 <argint>
    return -1;
    80002dee:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002df0:	06054563          	bltz	a0,80002e5a <sys_sleep+0x88>
  acquire(&tickslock);
    80002df4:	00015517          	auipc	a0,0x15
    80002df8:	d7450513          	addi	a0,a0,-652 # 80017b68 <tickslock>
    80002dfc:	ffffe097          	auipc	ra,0xffffe
    80002e00:	e14080e7          	jalr	-492(ra) # 80000c10 <acquire>
  ticks0 = ticks;
    80002e04:	00006917          	auipc	s2,0x6
    80002e08:	21c92903          	lw	s2,540(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    80002e0c:	fcc42783          	lw	a5,-52(s0)
    80002e10:	cf85                	beqz	a5,80002e48 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002e12:	00015997          	auipc	s3,0x15
    80002e16:	d5698993          	addi	s3,s3,-682 # 80017b68 <tickslock>
    80002e1a:	00006497          	auipc	s1,0x6
    80002e1e:	20648493          	addi	s1,s1,518 # 80009020 <ticks>
    if(myproc()->killed){
    80002e22:	fffff097          	auipc	ra,0xfffff
    80002e26:	c68080e7          	jalr	-920(ra) # 80001a8a <myproc>
    80002e2a:	591c                	lw	a5,48(a0)
    80002e2c:	ef9d                	bnez	a5,80002e6a <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002e2e:	85ce                	mv	a1,s3
    80002e30:	8526                	mv	a0,s1
    80002e32:	fffff097          	auipc	ra,0xfffff
    80002e36:	490080e7          	jalr	1168(ra) # 800022c2 <sleep>
  while(ticks - ticks0 < n){
    80002e3a:	409c                	lw	a5,0(s1)
    80002e3c:	412787bb          	subw	a5,a5,s2
    80002e40:	fcc42703          	lw	a4,-52(s0)
    80002e44:	fce7efe3          	bltu	a5,a4,80002e22 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002e48:	00015517          	auipc	a0,0x15
    80002e4c:	d2050513          	addi	a0,a0,-736 # 80017b68 <tickslock>
    80002e50:	ffffe097          	auipc	ra,0xffffe
    80002e54:	e74080e7          	jalr	-396(ra) # 80000cc4 <release>
  return 0;
    80002e58:	4781                	li	a5,0
}
    80002e5a:	853e                	mv	a0,a5
    80002e5c:	70e2                	ld	ra,56(sp)
    80002e5e:	7442                	ld	s0,48(sp)
    80002e60:	74a2                	ld	s1,40(sp)
    80002e62:	7902                	ld	s2,32(sp)
    80002e64:	69e2                	ld	s3,24(sp)
    80002e66:	6121                	addi	sp,sp,64
    80002e68:	8082                	ret
      release(&tickslock);
    80002e6a:	00015517          	auipc	a0,0x15
    80002e6e:	cfe50513          	addi	a0,a0,-770 # 80017b68 <tickslock>
    80002e72:	ffffe097          	auipc	ra,0xffffe
    80002e76:	e52080e7          	jalr	-430(ra) # 80000cc4 <release>
      return -1;
    80002e7a:	57fd                	li	a5,-1
    80002e7c:	bff9                	j	80002e5a <sys_sleep+0x88>

0000000080002e7e <sys_kill>:

uint64
sys_kill(void)
{
    80002e7e:	1101                	addi	sp,sp,-32
    80002e80:	ec06                	sd	ra,24(sp)
    80002e82:	e822                	sd	s0,16(sp)
    80002e84:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002e86:	fec40593          	addi	a1,s0,-20
    80002e8a:	4501                	li	a0,0
    80002e8c:	00000097          	auipc	ra,0x0
    80002e90:	d5c080e7          	jalr	-676(ra) # 80002be8 <argint>
    80002e94:	87aa                	mv	a5,a0
    return -1;
    80002e96:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002e98:	0007c863          	bltz	a5,80002ea8 <sys_kill+0x2a>
  return kill(pid);
    80002e9c:	fec42503          	lw	a0,-20(s0)
    80002ea0:	fffff097          	auipc	ra,0xfffff
    80002ea4:	612080e7          	jalr	1554(ra) # 800024b2 <kill>
}
    80002ea8:	60e2                	ld	ra,24(sp)
    80002eaa:	6442                	ld	s0,16(sp)
    80002eac:	6105                	addi	sp,sp,32
    80002eae:	8082                	ret

0000000080002eb0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002eb0:	1101                	addi	sp,sp,-32
    80002eb2:	ec06                	sd	ra,24(sp)
    80002eb4:	e822                	sd	s0,16(sp)
    80002eb6:	e426                	sd	s1,8(sp)
    80002eb8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002eba:	00015517          	auipc	a0,0x15
    80002ebe:	cae50513          	addi	a0,a0,-850 # 80017b68 <tickslock>
    80002ec2:	ffffe097          	auipc	ra,0xffffe
    80002ec6:	d4e080e7          	jalr	-690(ra) # 80000c10 <acquire>
  xticks = ticks;
    80002eca:	00006497          	auipc	s1,0x6
    80002ece:	1564a483          	lw	s1,342(s1) # 80009020 <ticks>
  release(&tickslock);
    80002ed2:	00015517          	auipc	a0,0x15
    80002ed6:	c9650513          	addi	a0,a0,-874 # 80017b68 <tickslock>
    80002eda:	ffffe097          	auipc	ra,0xffffe
    80002ede:	dea080e7          	jalr	-534(ra) # 80000cc4 <release>
  return xticks;
}
    80002ee2:	02049513          	slli	a0,s1,0x20
    80002ee6:	9101                	srli	a0,a0,0x20
    80002ee8:	60e2                	ld	ra,24(sp)
    80002eea:	6442                	ld	s0,16(sp)
    80002eec:	64a2                	ld	s1,8(sp)
    80002eee:	6105                	addi	sp,sp,32
    80002ef0:	8082                	ret

0000000080002ef2 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002ef2:	7179                	addi	sp,sp,-48
    80002ef4:	f406                	sd	ra,40(sp)
    80002ef6:	f022                	sd	s0,32(sp)
    80002ef8:	ec26                	sd	s1,24(sp)
    80002efa:	e84a                	sd	s2,16(sp)
    80002efc:	e44e                	sd	s3,8(sp)
    80002efe:	e052                	sd	s4,0(sp)
    80002f00:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002f02:	00005597          	auipc	a1,0x5
    80002f06:	5be58593          	addi	a1,a1,1470 # 800084c0 <syscalls+0xb0>
    80002f0a:	00015517          	auipc	a0,0x15
    80002f0e:	c7650513          	addi	a0,a0,-906 # 80017b80 <bcache>
    80002f12:	ffffe097          	auipc	ra,0xffffe
    80002f16:	c6e080e7          	jalr	-914(ra) # 80000b80 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002f1a:	0001d797          	auipc	a5,0x1d
    80002f1e:	c6678793          	addi	a5,a5,-922 # 8001fb80 <bcache+0x8000>
    80002f22:	0001d717          	auipc	a4,0x1d
    80002f26:	ec670713          	addi	a4,a4,-314 # 8001fde8 <bcache+0x8268>
    80002f2a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002f2e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f32:	00015497          	auipc	s1,0x15
    80002f36:	c6648493          	addi	s1,s1,-922 # 80017b98 <bcache+0x18>
    b->next = bcache.head.next;
    80002f3a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002f3c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002f3e:	00005a17          	auipc	s4,0x5
    80002f42:	58aa0a13          	addi	s4,s4,1418 # 800084c8 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002f46:	2b893783          	ld	a5,696(s2)
    80002f4a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002f4c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002f50:	85d2                	mv	a1,s4
    80002f52:	01048513          	addi	a0,s1,16
    80002f56:	00001097          	auipc	ra,0x1
    80002f5a:	4b0080e7          	jalr	1200(ra) # 80004406 <initsleeplock>
    bcache.head.next->prev = b;
    80002f5e:	2b893783          	ld	a5,696(s2)
    80002f62:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002f64:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f68:	45848493          	addi	s1,s1,1112
    80002f6c:	fd349de3          	bne	s1,s3,80002f46 <binit+0x54>
  }
}
    80002f70:	70a2                	ld	ra,40(sp)
    80002f72:	7402                	ld	s0,32(sp)
    80002f74:	64e2                	ld	s1,24(sp)
    80002f76:	6942                	ld	s2,16(sp)
    80002f78:	69a2                	ld	s3,8(sp)
    80002f7a:	6a02                	ld	s4,0(sp)
    80002f7c:	6145                	addi	sp,sp,48
    80002f7e:	8082                	ret

0000000080002f80 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002f80:	7179                	addi	sp,sp,-48
    80002f82:	f406                	sd	ra,40(sp)
    80002f84:	f022                	sd	s0,32(sp)
    80002f86:	ec26                	sd	s1,24(sp)
    80002f88:	e84a                	sd	s2,16(sp)
    80002f8a:	e44e                	sd	s3,8(sp)
    80002f8c:	1800                	addi	s0,sp,48
    80002f8e:	89aa                	mv	s3,a0
    80002f90:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002f92:	00015517          	auipc	a0,0x15
    80002f96:	bee50513          	addi	a0,a0,-1042 # 80017b80 <bcache>
    80002f9a:	ffffe097          	auipc	ra,0xffffe
    80002f9e:	c76080e7          	jalr	-906(ra) # 80000c10 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002fa2:	0001d497          	auipc	s1,0x1d
    80002fa6:	e964b483          	ld	s1,-362(s1) # 8001fe38 <bcache+0x82b8>
    80002faa:	0001d797          	auipc	a5,0x1d
    80002fae:	e3e78793          	addi	a5,a5,-450 # 8001fde8 <bcache+0x8268>
    80002fb2:	02f48f63          	beq	s1,a5,80002ff0 <bread+0x70>
    80002fb6:	873e                	mv	a4,a5
    80002fb8:	a021                	j	80002fc0 <bread+0x40>
    80002fba:	68a4                	ld	s1,80(s1)
    80002fbc:	02e48a63          	beq	s1,a4,80002ff0 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002fc0:	449c                	lw	a5,8(s1)
    80002fc2:	ff379ce3          	bne	a5,s3,80002fba <bread+0x3a>
    80002fc6:	44dc                	lw	a5,12(s1)
    80002fc8:	ff2799e3          	bne	a5,s2,80002fba <bread+0x3a>
      b->refcnt++;
    80002fcc:	40bc                	lw	a5,64(s1)
    80002fce:	2785                	addiw	a5,a5,1
    80002fd0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002fd2:	00015517          	auipc	a0,0x15
    80002fd6:	bae50513          	addi	a0,a0,-1106 # 80017b80 <bcache>
    80002fda:	ffffe097          	auipc	ra,0xffffe
    80002fde:	cea080e7          	jalr	-790(ra) # 80000cc4 <release>
      acquiresleep(&b->lock);
    80002fe2:	01048513          	addi	a0,s1,16
    80002fe6:	00001097          	auipc	ra,0x1
    80002fea:	45a080e7          	jalr	1114(ra) # 80004440 <acquiresleep>
      return b;
    80002fee:	a8b9                	j	8000304c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002ff0:	0001d497          	auipc	s1,0x1d
    80002ff4:	e404b483          	ld	s1,-448(s1) # 8001fe30 <bcache+0x82b0>
    80002ff8:	0001d797          	auipc	a5,0x1d
    80002ffc:	df078793          	addi	a5,a5,-528 # 8001fde8 <bcache+0x8268>
    80003000:	00f48863          	beq	s1,a5,80003010 <bread+0x90>
    80003004:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003006:	40bc                	lw	a5,64(s1)
    80003008:	cf81                	beqz	a5,80003020 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000300a:	64a4                	ld	s1,72(s1)
    8000300c:	fee49de3          	bne	s1,a4,80003006 <bread+0x86>
  panic("bget: no buffers");
    80003010:	00005517          	auipc	a0,0x5
    80003014:	4c050513          	addi	a0,a0,1216 # 800084d0 <syscalls+0xc0>
    80003018:	ffffd097          	auipc	ra,0xffffd
    8000301c:	530080e7          	jalr	1328(ra) # 80000548 <panic>
      b->dev = dev;
    80003020:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80003024:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80003028:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000302c:	4785                	li	a5,1
    8000302e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003030:	00015517          	auipc	a0,0x15
    80003034:	b5050513          	addi	a0,a0,-1200 # 80017b80 <bcache>
    80003038:	ffffe097          	auipc	ra,0xffffe
    8000303c:	c8c080e7          	jalr	-884(ra) # 80000cc4 <release>
      acquiresleep(&b->lock);
    80003040:	01048513          	addi	a0,s1,16
    80003044:	00001097          	auipc	ra,0x1
    80003048:	3fc080e7          	jalr	1020(ra) # 80004440 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000304c:	409c                	lw	a5,0(s1)
    8000304e:	cb89                	beqz	a5,80003060 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003050:	8526                	mv	a0,s1
    80003052:	70a2                	ld	ra,40(sp)
    80003054:	7402                	ld	s0,32(sp)
    80003056:	64e2                	ld	s1,24(sp)
    80003058:	6942                	ld	s2,16(sp)
    8000305a:	69a2                	ld	s3,8(sp)
    8000305c:	6145                	addi	sp,sp,48
    8000305e:	8082                	ret
    virtio_disk_rw(b, 0);
    80003060:	4581                	li	a1,0
    80003062:	8526                	mv	a0,s1
    80003064:	00003097          	auipc	ra,0x3
    80003068:	108080e7          	jalr	264(ra) # 8000616c <virtio_disk_rw>
    b->valid = 1;
    8000306c:	4785                	li	a5,1
    8000306e:	c09c                	sw	a5,0(s1)
  return b;
    80003070:	b7c5                	j	80003050 <bread+0xd0>

0000000080003072 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003072:	1101                	addi	sp,sp,-32
    80003074:	ec06                	sd	ra,24(sp)
    80003076:	e822                	sd	s0,16(sp)
    80003078:	e426                	sd	s1,8(sp)
    8000307a:	1000                	addi	s0,sp,32
    8000307c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000307e:	0541                	addi	a0,a0,16
    80003080:	00001097          	auipc	ra,0x1
    80003084:	45a080e7          	jalr	1114(ra) # 800044da <holdingsleep>
    80003088:	cd01                	beqz	a0,800030a0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000308a:	4585                	li	a1,1
    8000308c:	8526                	mv	a0,s1
    8000308e:	00003097          	auipc	ra,0x3
    80003092:	0de080e7          	jalr	222(ra) # 8000616c <virtio_disk_rw>
}
    80003096:	60e2                	ld	ra,24(sp)
    80003098:	6442                	ld	s0,16(sp)
    8000309a:	64a2                	ld	s1,8(sp)
    8000309c:	6105                	addi	sp,sp,32
    8000309e:	8082                	ret
    panic("bwrite");
    800030a0:	00005517          	auipc	a0,0x5
    800030a4:	44850513          	addi	a0,a0,1096 # 800084e8 <syscalls+0xd8>
    800030a8:	ffffd097          	auipc	ra,0xffffd
    800030ac:	4a0080e7          	jalr	1184(ra) # 80000548 <panic>

00000000800030b0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800030b0:	1101                	addi	sp,sp,-32
    800030b2:	ec06                	sd	ra,24(sp)
    800030b4:	e822                	sd	s0,16(sp)
    800030b6:	e426                	sd	s1,8(sp)
    800030b8:	e04a                	sd	s2,0(sp)
    800030ba:	1000                	addi	s0,sp,32
    800030bc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800030be:	01050913          	addi	s2,a0,16
    800030c2:	854a                	mv	a0,s2
    800030c4:	00001097          	auipc	ra,0x1
    800030c8:	416080e7          	jalr	1046(ra) # 800044da <holdingsleep>
    800030cc:	c92d                	beqz	a0,8000313e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800030ce:	854a                	mv	a0,s2
    800030d0:	00001097          	auipc	ra,0x1
    800030d4:	3c6080e7          	jalr	966(ra) # 80004496 <releasesleep>

  acquire(&bcache.lock);
    800030d8:	00015517          	auipc	a0,0x15
    800030dc:	aa850513          	addi	a0,a0,-1368 # 80017b80 <bcache>
    800030e0:	ffffe097          	auipc	ra,0xffffe
    800030e4:	b30080e7          	jalr	-1232(ra) # 80000c10 <acquire>
  b->refcnt--;
    800030e8:	40bc                	lw	a5,64(s1)
    800030ea:	37fd                	addiw	a5,a5,-1
    800030ec:	0007871b          	sext.w	a4,a5
    800030f0:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800030f2:	eb05                	bnez	a4,80003122 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800030f4:	68bc                	ld	a5,80(s1)
    800030f6:	64b8                	ld	a4,72(s1)
    800030f8:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800030fa:	64bc                	ld	a5,72(s1)
    800030fc:	68b8                	ld	a4,80(s1)
    800030fe:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003100:	0001d797          	auipc	a5,0x1d
    80003104:	a8078793          	addi	a5,a5,-1408 # 8001fb80 <bcache+0x8000>
    80003108:	2b87b703          	ld	a4,696(a5)
    8000310c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000310e:	0001d717          	auipc	a4,0x1d
    80003112:	cda70713          	addi	a4,a4,-806 # 8001fde8 <bcache+0x8268>
    80003116:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003118:	2b87b703          	ld	a4,696(a5)
    8000311c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000311e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003122:	00015517          	auipc	a0,0x15
    80003126:	a5e50513          	addi	a0,a0,-1442 # 80017b80 <bcache>
    8000312a:	ffffe097          	auipc	ra,0xffffe
    8000312e:	b9a080e7          	jalr	-1126(ra) # 80000cc4 <release>
}
    80003132:	60e2                	ld	ra,24(sp)
    80003134:	6442                	ld	s0,16(sp)
    80003136:	64a2                	ld	s1,8(sp)
    80003138:	6902                	ld	s2,0(sp)
    8000313a:	6105                	addi	sp,sp,32
    8000313c:	8082                	ret
    panic("brelse");
    8000313e:	00005517          	auipc	a0,0x5
    80003142:	3b250513          	addi	a0,a0,946 # 800084f0 <syscalls+0xe0>
    80003146:	ffffd097          	auipc	ra,0xffffd
    8000314a:	402080e7          	jalr	1026(ra) # 80000548 <panic>

000000008000314e <bpin>:

void
bpin(struct buf *b) {
    8000314e:	1101                	addi	sp,sp,-32
    80003150:	ec06                	sd	ra,24(sp)
    80003152:	e822                	sd	s0,16(sp)
    80003154:	e426                	sd	s1,8(sp)
    80003156:	1000                	addi	s0,sp,32
    80003158:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000315a:	00015517          	auipc	a0,0x15
    8000315e:	a2650513          	addi	a0,a0,-1498 # 80017b80 <bcache>
    80003162:	ffffe097          	auipc	ra,0xffffe
    80003166:	aae080e7          	jalr	-1362(ra) # 80000c10 <acquire>
  b->refcnt++;
    8000316a:	40bc                	lw	a5,64(s1)
    8000316c:	2785                	addiw	a5,a5,1
    8000316e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003170:	00015517          	auipc	a0,0x15
    80003174:	a1050513          	addi	a0,a0,-1520 # 80017b80 <bcache>
    80003178:	ffffe097          	auipc	ra,0xffffe
    8000317c:	b4c080e7          	jalr	-1204(ra) # 80000cc4 <release>
}
    80003180:	60e2                	ld	ra,24(sp)
    80003182:	6442                	ld	s0,16(sp)
    80003184:	64a2                	ld	s1,8(sp)
    80003186:	6105                	addi	sp,sp,32
    80003188:	8082                	ret

000000008000318a <bunpin>:

void
bunpin(struct buf *b) {
    8000318a:	1101                	addi	sp,sp,-32
    8000318c:	ec06                	sd	ra,24(sp)
    8000318e:	e822                	sd	s0,16(sp)
    80003190:	e426                	sd	s1,8(sp)
    80003192:	1000                	addi	s0,sp,32
    80003194:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003196:	00015517          	auipc	a0,0x15
    8000319a:	9ea50513          	addi	a0,a0,-1558 # 80017b80 <bcache>
    8000319e:	ffffe097          	auipc	ra,0xffffe
    800031a2:	a72080e7          	jalr	-1422(ra) # 80000c10 <acquire>
  b->refcnt--;
    800031a6:	40bc                	lw	a5,64(s1)
    800031a8:	37fd                	addiw	a5,a5,-1
    800031aa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800031ac:	00015517          	auipc	a0,0x15
    800031b0:	9d450513          	addi	a0,a0,-1580 # 80017b80 <bcache>
    800031b4:	ffffe097          	auipc	ra,0xffffe
    800031b8:	b10080e7          	jalr	-1264(ra) # 80000cc4 <release>
}
    800031bc:	60e2                	ld	ra,24(sp)
    800031be:	6442                	ld	s0,16(sp)
    800031c0:	64a2                	ld	s1,8(sp)
    800031c2:	6105                	addi	sp,sp,32
    800031c4:	8082                	ret

00000000800031c6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800031c6:	1101                	addi	sp,sp,-32
    800031c8:	ec06                	sd	ra,24(sp)
    800031ca:	e822                	sd	s0,16(sp)
    800031cc:	e426                	sd	s1,8(sp)
    800031ce:	e04a                	sd	s2,0(sp)
    800031d0:	1000                	addi	s0,sp,32
    800031d2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800031d4:	00d5d59b          	srliw	a1,a1,0xd
    800031d8:	0001d797          	auipc	a5,0x1d
    800031dc:	0847a783          	lw	a5,132(a5) # 8002025c <sb+0x1c>
    800031e0:	9dbd                	addw	a1,a1,a5
    800031e2:	00000097          	auipc	ra,0x0
    800031e6:	d9e080e7          	jalr	-610(ra) # 80002f80 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800031ea:	0074f713          	andi	a4,s1,7
    800031ee:	4785                	li	a5,1
    800031f0:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800031f4:	14ce                	slli	s1,s1,0x33
    800031f6:	90d9                	srli	s1,s1,0x36
    800031f8:	00950733          	add	a4,a0,s1
    800031fc:	05874703          	lbu	a4,88(a4)
    80003200:	00e7f6b3          	and	a3,a5,a4
    80003204:	c69d                	beqz	a3,80003232 <bfree+0x6c>
    80003206:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003208:	94aa                	add	s1,s1,a0
    8000320a:	fff7c793          	not	a5,a5
    8000320e:	8ff9                	and	a5,a5,a4
    80003210:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80003214:	00001097          	auipc	ra,0x1
    80003218:	104080e7          	jalr	260(ra) # 80004318 <log_write>
  brelse(bp);
    8000321c:	854a                	mv	a0,s2
    8000321e:	00000097          	auipc	ra,0x0
    80003222:	e92080e7          	jalr	-366(ra) # 800030b0 <brelse>
}
    80003226:	60e2                	ld	ra,24(sp)
    80003228:	6442                	ld	s0,16(sp)
    8000322a:	64a2                	ld	s1,8(sp)
    8000322c:	6902                	ld	s2,0(sp)
    8000322e:	6105                	addi	sp,sp,32
    80003230:	8082                	ret
    panic("freeing free block");
    80003232:	00005517          	auipc	a0,0x5
    80003236:	2c650513          	addi	a0,a0,710 # 800084f8 <syscalls+0xe8>
    8000323a:	ffffd097          	auipc	ra,0xffffd
    8000323e:	30e080e7          	jalr	782(ra) # 80000548 <panic>

0000000080003242 <balloc>:
{
    80003242:	711d                	addi	sp,sp,-96
    80003244:	ec86                	sd	ra,88(sp)
    80003246:	e8a2                	sd	s0,80(sp)
    80003248:	e4a6                	sd	s1,72(sp)
    8000324a:	e0ca                	sd	s2,64(sp)
    8000324c:	fc4e                	sd	s3,56(sp)
    8000324e:	f852                	sd	s4,48(sp)
    80003250:	f456                	sd	s5,40(sp)
    80003252:	f05a                	sd	s6,32(sp)
    80003254:	ec5e                	sd	s7,24(sp)
    80003256:	e862                	sd	s8,16(sp)
    80003258:	e466                	sd	s9,8(sp)
    8000325a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000325c:	0001d797          	auipc	a5,0x1d
    80003260:	fe87a783          	lw	a5,-24(a5) # 80020244 <sb+0x4>
    80003264:	cbd1                	beqz	a5,800032f8 <balloc+0xb6>
    80003266:	8baa                	mv	s7,a0
    80003268:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000326a:	0001db17          	auipc	s6,0x1d
    8000326e:	fd6b0b13          	addi	s6,s6,-42 # 80020240 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003272:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003274:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003276:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003278:	6c89                	lui	s9,0x2
    8000327a:	a831                	j	80003296 <balloc+0x54>
    brelse(bp);
    8000327c:	854a                	mv	a0,s2
    8000327e:	00000097          	auipc	ra,0x0
    80003282:	e32080e7          	jalr	-462(ra) # 800030b0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003286:	015c87bb          	addw	a5,s9,s5
    8000328a:	00078a9b          	sext.w	s5,a5
    8000328e:	004b2703          	lw	a4,4(s6)
    80003292:	06eaf363          	bgeu	s5,a4,800032f8 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80003296:	41fad79b          	sraiw	a5,s5,0x1f
    8000329a:	0137d79b          	srliw	a5,a5,0x13
    8000329e:	015787bb          	addw	a5,a5,s5
    800032a2:	40d7d79b          	sraiw	a5,a5,0xd
    800032a6:	01cb2583          	lw	a1,28(s6)
    800032aa:	9dbd                	addw	a1,a1,a5
    800032ac:	855e                	mv	a0,s7
    800032ae:	00000097          	auipc	ra,0x0
    800032b2:	cd2080e7          	jalr	-814(ra) # 80002f80 <bread>
    800032b6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032b8:	004b2503          	lw	a0,4(s6)
    800032bc:	000a849b          	sext.w	s1,s5
    800032c0:	8662                	mv	a2,s8
    800032c2:	faa4fde3          	bgeu	s1,a0,8000327c <balloc+0x3a>
      m = 1 << (bi % 8);
    800032c6:	41f6579b          	sraiw	a5,a2,0x1f
    800032ca:	01d7d69b          	srliw	a3,a5,0x1d
    800032ce:	00c6873b          	addw	a4,a3,a2
    800032d2:	00777793          	andi	a5,a4,7
    800032d6:	9f95                	subw	a5,a5,a3
    800032d8:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800032dc:	4037571b          	sraiw	a4,a4,0x3
    800032e0:	00e906b3          	add	a3,s2,a4
    800032e4:	0586c683          	lbu	a3,88(a3)
    800032e8:	00d7f5b3          	and	a1,a5,a3
    800032ec:	cd91                	beqz	a1,80003308 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032ee:	2605                	addiw	a2,a2,1
    800032f0:	2485                	addiw	s1,s1,1
    800032f2:	fd4618e3          	bne	a2,s4,800032c2 <balloc+0x80>
    800032f6:	b759                	j	8000327c <balloc+0x3a>
  panic("balloc: out of blocks");
    800032f8:	00005517          	auipc	a0,0x5
    800032fc:	21850513          	addi	a0,a0,536 # 80008510 <syscalls+0x100>
    80003300:	ffffd097          	auipc	ra,0xffffd
    80003304:	248080e7          	jalr	584(ra) # 80000548 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003308:	974a                	add	a4,a4,s2
    8000330a:	8fd5                	or	a5,a5,a3
    8000330c:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80003310:	854a                	mv	a0,s2
    80003312:	00001097          	auipc	ra,0x1
    80003316:	006080e7          	jalr	6(ra) # 80004318 <log_write>
        brelse(bp);
    8000331a:	854a                	mv	a0,s2
    8000331c:	00000097          	auipc	ra,0x0
    80003320:	d94080e7          	jalr	-620(ra) # 800030b0 <brelse>
  bp = bread(dev, bno);
    80003324:	85a6                	mv	a1,s1
    80003326:	855e                	mv	a0,s7
    80003328:	00000097          	auipc	ra,0x0
    8000332c:	c58080e7          	jalr	-936(ra) # 80002f80 <bread>
    80003330:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003332:	40000613          	li	a2,1024
    80003336:	4581                	li	a1,0
    80003338:	05850513          	addi	a0,a0,88
    8000333c:	ffffe097          	auipc	ra,0xffffe
    80003340:	9d0080e7          	jalr	-1584(ra) # 80000d0c <memset>
  log_write(bp);
    80003344:	854a                	mv	a0,s2
    80003346:	00001097          	auipc	ra,0x1
    8000334a:	fd2080e7          	jalr	-46(ra) # 80004318 <log_write>
  brelse(bp);
    8000334e:	854a                	mv	a0,s2
    80003350:	00000097          	auipc	ra,0x0
    80003354:	d60080e7          	jalr	-672(ra) # 800030b0 <brelse>
}
    80003358:	8526                	mv	a0,s1
    8000335a:	60e6                	ld	ra,88(sp)
    8000335c:	6446                	ld	s0,80(sp)
    8000335e:	64a6                	ld	s1,72(sp)
    80003360:	6906                	ld	s2,64(sp)
    80003362:	79e2                	ld	s3,56(sp)
    80003364:	7a42                	ld	s4,48(sp)
    80003366:	7aa2                	ld	s5,40(sp)
    80003368:	7b02                	ld	s6,32(sp)
    8000336a:	6be2                	ld	s7,24(sp)
    8000336c:	6c42                	ld	s8,16(sp)
    8000336e:	6ca2                	ld	s9,8(sp)
    80003370:	6125                	addi	sp,sp,96
    80003372:	8082                	ret

0000000080003374 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80003374:	7179                	addi	sp,sp,-48
    80003376:	f406                	sd	ra,40(sp)
    80003378:	f022                	sd	s0,32(sp)
    8000337a:	ec26                	sd	s1,24(sp)
    8000337c:	e84a                	sd	s2,16(sp)
    8000337e:	e44e                	sd	s3,8(sp)
    80003380:	e052                	sd	s4,0(sp)
    80003382:	1800                	addi	s0,sp,48
    80003384:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003386:	47ad                	li	a5,11
    80003388:	04b7fe63          	bgeu	a5,a1,800033e4 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000338c:	ff45849b          	addiw	s1,a1,-12
    80003390:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003394:	0ff00793          	li	a5,255
    80003398:	0ae7e363          	bltu	a5,a4,8000343e <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000339c:	08052583          	lw	a1,128(a0)
    800033a0:	c5ad                	beqz	a1,8000340a <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800033a2:	00092503          	lw	a0,0(s2)
    800033a6:	00000097          	auipc	ra,0x0
    800033aa:	bda080e7          	jalr	-1062(ra) # 80002f80 <bread>
    800033ae:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800033b0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800033b4:	02049593          	slli	a1,s1,0x20
    800033b8:	9181                	srli	a1,a1,0x20
    800033ba:	058a                	slli	a1,a1,0x2
    800033bc:	00b784b3          	add	s1,a5,a1
    800033c0:	0004a983          	lw	s3,0(s1)
    800033c4:	04098d63          	beqz	s3,8000341e <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800033c8:	8552                	mv	a0,s4
    800033ca:	00000097          	auipc	ra,0x0
    800033ce:	ce6080e7          	jalr	-794(ra) # 800030b0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800033d2:	854e                	mv	a0,s3
    800033d4:	70a2                	ld	ra,40(sp)
    800033d6:	7402                	ld	s0,32(sp)
    800033d8:	64e2                	ld	s1,24(sp)
    800033da:	6942                	ld	s2,16(sp)
    800033dc:	69a2                	ld	s3,8(sp)
    800033de:	6a02                	ld	s4,0(sp)
    800033e0:	6145                	addi	sp,sp,48
    800033e2:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800033e4:	02059493          	slli	s1,a1,0x20
    800033e8:	9081                	srli	s1,s1,0x20
    800033ea:	048a                	slli	s1,s1,0x2
    800033ec:	94aa                	add	s1,s1,a0
    800033ee:	0504a983          	lw	s3,80(s1)
    800033f2:	fe0990e3          	bnez	s3,800033d2 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800033f6:	4108                	lw	a0,0(a0)
    800033f8:	00000097          	auipc	ra,0x0
    800033fc:	e4a080e7          	jalr	-438(ra) # 80003242 <balloc>
    80003400:	0005099b          	sext.w	s3,a0
    80003404:	0534a823          	sw	s3,80(s1)
    80003408:	b7e9                	j	800033d2 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000340a:	4108                	lw	a0,0(a0)
    8000340c:	00000097          	auipc	ra,0x0
    80003410:	e36080e7          	jalr	-458(ra) # 80003242 <balloc>
    80003414:	0005059b          	sext.w	a1,a0
    80003418:	08b92023          	sw	a1,128(s2)
    8000341c:	b759                	j	800033a2 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000341e:	00092503          	lw	a0,0(s2)
    80003422:	00000097          	auipc	ra,0x0
    80003426:	e20080e7          	jalr	-480(ra) # 80003242 <balloc>
    8000342a:	0005099b          	sext.w	s3,a0
    8000342e:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80003432:	8552                	mv	a0,s4
    80003434:	00001097          	auipc	ra,0x1
    80003438:	ee4080e7          	jalr	-284(ra) # 80004318 <log_write>
    8000343c:	b771                	j	800033c8 <bmap+0x54>
  panic("bmap: out of range");
    8000343e:	00005517          	auipc	a0,0x5
    80003442:	0ea50513          	addi	a0,a0,234 # 80008528 <syscalls+0x118>
    80003446:	ffffd097          	auipc	ra,0xffffd
    8000344a:	102080e7          	jalr	258(ra) # 80000548 <panic>

000000008000344e <iget>:
{
    8000344e:	7179                	addi	sp,sp,-48
    80003450:	f406                	sd	ra,40(sp)
    80003452:	f022                	sd	s0,32(sp)
    80003454:	ec26                	sd	s1,24(sp)
    80003456:	e84a                	sd	s2,16(sp)
    80003458:	e44e                	sd	s3,8(sp)
    8000345a:	e052                	sd	s4,0(sp)
    8000345c:	1800                	addi	s0,sp,48
    8000345e:	89aa                	mv	s3,a0
    80003460:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    80003462:	0001d517          	auipc	a0,0x1d
    80003466:	dfe50513          	addi	a0,a0,-514 # 80020260 <icache>
    8000346a:	ffffd097          	auipc	ra,0xffffd
    8000346e:	7a6080e7          	jalr	1958(ra) # 80000c10 <acquire>
  empty = 0;
    80003472:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003474:	0001d497          	auipc	s1,0x1d
    80003478:	e0448493          	addi	s1,s1,-508 # 80020278 <icache+0x18>
    8000347c:	0001f697          	auipc	a3,0x1f
    80003480:	88c68693          	addi	a3,a3,-1908 # 80021d08 <log>
    80003484:	a039                	j	80003492 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003486:	02090b63          	beqz	s2,800034bc <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000348a:	08848493          	addi	s1,s1,136
    8000348e:	02d48a63          	beq	s1,a3,800034c2 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003492:	449c                	lw	a5,8(s1)
    80003494:	fef059e3          	blez	a5,80003486 <iget+0x38>
    80003498:	4098                	lw	a4,0(s1)
    8000349a:	ff3716e3          	bne	a4,s3,80003486 <iget+0x38>
    8000349e:	40d8                	lw	a4,4(s1)
    800034a0:	ff4713e3          	bne	a4,s4,80003486 <iget+0x38>
      ip->ref++;
    800034a4:	2785                	addiw	a5,a5,1
    800034a6:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    800034a8:	0001d517          	auipc	a0,0x1d
    800034ac:	db850513          	addi	a0,a0,-584 # 80020260 <icache>
    800034b0:	ffffe097          	auipc	ra,0xffffe
    800034b4:	814080e7          	jalr	-2028(ra) # 80000cc4 <release>
      return ip;
    800034b8:	8926                	mv	s2,s1
    800034ba:	a03d                	j	800034e8 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800034bc:	f7f9                	bnez	a5,8000348a <iget+0x3c>
    800034be:	8926                	mv	s2,s1
    800034c0:	b7e9                	j	8000348a <iget+0x3c>
  if(empty == 0)
    800034c2:	02090c63          	beqz	s2,800034fa <iget+0xac>
  ip->dev = dev;
    800034c6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800034ca:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800034ce:	4785                	li	a5,1
    800034d0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800034d4:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    800034d8:	0001d517          	auipc	a0,0x1d
    800034dc:	d8850513          	addi	a0,a0,-632 # 80020260 <icache>
    800034e0:	ffffd097          	auipc	ra,0xffffd
    800034e4:	7e4080e7          	jalr	2020(ra) # 80000cc4 <release>
}
    800034e8:	854a                	mv	a0,s2
    800034ea:	70a2                	ld	ra,40(sp)
    800034ec:	7402                	ld	s0,32(sp)
    800034ee:	64e2                	ld	s1,24(sp)
    800034f0:	6942                	ld	s2,16(sp)
    800034f2:	69a2                	ld	s3,8(sp)
    800034f4:	6a02                	ld	s4,0(sp)
    800034f6:	6145                	addi	sp,sp,48
    800034f8:	8082                	ret
    panic("iget: no inodes");
    800034fa:	00005517          	auipc	a0,0x5
    800034fe:	04650513          	addi	a0,a0,70 # 80008540 <syscalls+0x130>
    80003502:	ffffd097          	auipc	ra,0xffffd
    80003506:	046080e7          	jalr	70(ra) # 80000548 <panic>

000000008000350a <fsinit>:
fsinit(int dev) {
    8000350a:	7179                	addi	sp,sp,-48
    8000350c:	f406                	sd	ra,40(sp)
    8000350e:	f022                	sd	s0,32(sp)
    80003510:	ec26                	sd	s1,24(sp)
    80003512:	e84a                	sd	s2,16(sp)
    80003514:	e44e                	sd	s3,8(sp)
    80003516:	1800                	addi	s0,sp,48
    80003518:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000351a:	4585                	li	a1,1
    8000351c:	00000097          	auipc	ra,0x0
    80003520:	a64080e7          	jalr	-1436(ra) # 80002f80 <bread>
    80003524:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003526:	0001d997          	auipc	s3,0x1d
    8000352a:	d1a98993          	addi	s3,s3,-742 # 80020240 <sb>
    8000352e:	02000613          	li	a2,32
    80003532:	05850593          	addi	a1,a0,88
    80003536:	854e                	mv	a0,s3
    80003538:	ffffe097          	auipc	ra,0xffffe
    8000353c:	834080e7          	jalr	-1996(ra) # 80000d6c <memmove>
  brelse(bp);
    80003540:	8526                	mv	a0,s1
    80003542:	00000097          	auipc	ra,0x0
    80003546:	b6e080e7          	jalr	-1170(ra) # 800030b0 <brelse>
  if(sb.magic != FSMAGIC)
    8000354a:	0009a703          	lw	a4,0(s3)
    8000354e:	102037b7          	lui	a5,0x10203
    80003552:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003556:	02f71263          	bne	a4,a5,8000357a <fsinit+0x70>
  initlog(dev, &sb);
    8000355a:	0001d597          	auipc	a1,0x1d
    8000355e:	ce658593          	addi	a1,a1,-794 # 80020240 <sb>
    80003562:	854a                	mv	a0,s2
    80003564:	00001097          	auipc	ra,0x1
    80003568:	b3c080e7          	jalr	-1220(ra) # 800040a0 <initlog>
}
    8000356c:	70a2                	ld	ra,40(sp)
    8000356e:	7402                	ld	s0,32(sp)
    80003570:	64e2                	ld	s1,24(sp)
    80003572:	6942                	ld	s2,16(sp)
    80003574:	69a2                	ld	s3,8(sp)
    80003576:	6145                	addi	sp,sp,48
    80003578:	8082                	ret
    panic("invalid file system");
    8000357a:	00005517          	auipc	a0,0x5
    8000357e:	fd650513          	addi	a0,a0,-42 # 80008550 <syscalls+0x140>
    80003582:	ffffd097          	auipc	ra,0xffffd
    80003586:	fc6080e7          	jalr	-58(ra) # 80000548 <panic>

000000008000358a <iinit>:
{
    8000358a:	7179                	addi	sp,sp,-48
    8000358c:	f406                	sd	ra,40(sp)
    8000358e:	f022                	sd	s0,32(sp)
    80003590:	ec26                	sd	s1,24(sp)
    80003592:	e84a                	sd	s2,16(sp)
    80003594:	e44e                	sd	s3,8(sp)
    80003596:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    80003598:	00005597          	auipc	a1,0x5
    8000359c:	fd058593          	addi	a1,a1,-48 # 80008568 <syscalls+0x158>
    800035a0:	0001d517          	auipc	a0,0x1d
    800035a4:	cc050513          	addi	a0,a0,-832 # 80020260 <icache>
    800035a8:	ffffd097          	auipc	ra,0xffffd
    800035ac:	5d8080e7          	jalr	1496(ra) # 80000b80 <initlock>
  for(i = 0; i < NINODE; i++) {
    800035b0:	0001d497          	auipc	s1,0x1d
    800035b4:	cd848493          	addi	s1,s1,-808 # 80020288 <icache+0x28>
    800035b8:	0001e997          	auipc	s3,0x1e
    800035bc:	76098993          	addi	s3,s3,1888 # 80021d18 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    800035c0:	00005917          	auipc	s2,0x5
    800035c4:	fb090913          	addi	s2,s2,-80 # 80008570 <syscalls+0x160>
    800035c8:	85ca                	mv	a1,s2
    800035ca:	8526                	mv	a0,s1
    800035cc:	00001097          	auipc	ra,0x1
    800035d0:	e3a080e7          	jalr	-454(ra) # 80004406 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800035d4:	08848493          	addi	s1,s1,136
    800035d8:	ff3498e3          	bne	s1,s3,800035c8 <iinit+0x3e>
}
    800035dc:	70a2                	ld	ra,40(sp)
    800035de:	7402                	ld	s0,32(sp)
    800035e0:	64e2                	ld	s1,24(sp)
    800035e2:	6942                	ld	s2,16(sp)
    800035e4:	69a2                	ld	s3,8(sp)
    800035e6:	6145                	addi	sp,sp,48
    800035e8:	8082                	ret

00000000800035ea <ialloc>:
{
    800035ea:	715d                	addi	sp,sp,-80
    800035ec:	e486                	sd	ra,72(sp)
    800035ee:	e0a2                	sd	s0,64(sp)
    800035f0:	fc26                	sd	s1,56(sp)
    800035f2:	f84a                	sd	s2,48(sp)
    800035f4:	f44e                	sd	s3,40(sp)
    800035f6:	f052                	sd	s4,32(sp)
    800035f8:	ec56                	sd	s5,24(sp)
    800035fa:	e85a                	sd	s6,16(sp)
    800035fc:	e45e                	sd	s7,8(sp)
    800035fe:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003600:	0001d717          	auipc	a4,0x1d
    80003604:	c4c72703          	lw	a4,-948(a4) # 8002024c <sb+0xc>
    80003608:	4785                	li	a5,1
    8000360a:	04e7fa63          	bgeu	a5,a4,8000365e <ialloc+0x74>
    8000360e:	8aaa                	mv	s5,a0
    80003610:	8bae                	mv	s7,a1
    80003612:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003614:	0001da17          	auipc	s4,0x1d
    80003618:	c2ca0a13          	addi	s4,s4,-980 # 80020240 <sb>
    8000361c:	00048b1b          	sext.w	s6,s1
    80003620:	0044d593          	srli	a1,s1,0x4
    80003624:	018a2783          	lw	a5,24(s4)
    80003628:	9dbd                	addw	a1,a1,a5
    8000362a:	8556                	mv	a0,s5
    8000362c:	00000097          	auipc	ra,0x0
    80003630:	954080e7          	jalr	-1708(ra) # 80002f80 <bread>
    80003634:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003636:	05850993          	addi	s3,a0,88
    8000363a:	00f4f793          	andi	a5,s1,15
    8000363e:	079a                	slli	a5,a5,0x6
    80003640:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003642:	00099783          	lh	a5,0(s3)
    80003646:	c785                	beqz	a5,8000366e <ialloc+0x84>
    brelse(bp);
    80003648:	00000097          	auipc	ra,0x0
    8000364c:	a68080e7          	jalr	-1432(ra) # 800030b0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003650:	0485                	addi	s1,s1,1
    80003652:	00ca2703          	lw	a4,12(s4)
    80003656:	0004879b          	sext.w	a5,s1
    8000365a:	fce7e1e3          	bltu	a5,a4,8000361c <ialloc+0x32>
  panic("ialloc: no inodes");
    8000365e:	00005517          	auipc	a0,0x5
    80003662:	f1a50513          	addi	a0,a0,-230 # 80008578 <syscalls+0x168>
    80003666:	ffffd097          	auipc	ra,0xffffd
    8000366a:	ee2080e7          	jalr	-286(ra) # 80000548 <panic>
      memset(dip, 0, sizeof(*dip));
    8000366e:	04000613          	li	a2,64
    80003672:	4581                	li	a1,0
    80003674:	854e                	mv	a0,s3
    80003676:	ffffd097          	auipc	ra,0xffffd
    8000367a:	696080e7          	jalr	1686(ra) # 80000d0c <memset>
      dip->type = type;
    8000367e:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003682:	854a                	mv	a0,s2
    80003684:	00001097          	auipc	ra,0x1
    80003688:	c94080e7          	jalr	-876(ra) # 80004318 <log_write>
      brelse(bp);
    8000368c:	854a                	mv	a0,s2
    8000368e:	00000097          	auipc	ra,0x0
    80003692:	a22080e7          	jalr	-1502(ra) # 800030b0 <brelse>
      return iget(dev, inum);
    80003696:	85da                	mv	a1,s6
    80003698:	8556                	mv	a0,s5
    8000369a:	00000097          	auipc	ra,0x0
    8000369e:	db4080e7          	jalr	-588(ra) # 8000344e <iget>
}
    800036a2:	60a6                	ld	ra,72(sp)
    800036a4:	6406                	ld	s0,64(sp)
    800036a6:	74e2                	ld	s1,56(sp)
    800036a8:	7942                	ld	s2,48(sp)
    800036aa:	79a2                	ld	s3,40(sp)
    800036ac:	7a02                	ld	s4,32(sp)
    800036ae:	6ae2                	ld	s5,24(sp)
    800036b0:	6b42                	ld	s6,16(sp)
    800036b2:	6ba2                	ld	s7,8(sp)
    800036b4:	6161                	addi	sp,sp,80
    800036b6:	8082                	ret

00000000800036b8 <iupdate>:
{
    800036b8:	1101                	addi	sp,sp,-32
    800036ba:	ec06                	sd	ra,24(sp)
    800036bc:	e822                	sd	s0,16(sp)
    800036be:	e426                	sd	s1,8(sp)
    800036c0:	e04a                	sd	s2,0(sp)
    800036c2:	1000                	addi	s0,sp,32
    800036c4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800036c6:	415c                	lw	a5,4(a0)
    800036c8:	0047d79b          	srliw	a5,a5,0x4
    800036cc:	0001d597          	auipc	a1,0x1d
    800036d0:	b8c5a583          	lw	a1,-1140(a1) # 80020258 <sb+0x18>
    800036d4:	9dbd                	addw	a1,a1,a5
    800036d6:	4108                	lw	a0,0(a0)
    800036d8:	00000097          	auipc	ra,0x0
    800036dc:	8a8080e7          	jalr	-1880(ra) # 80002f80 <bread>
    800036e0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800036e2:	05850793          	addi	a5,a0,88
    800036e6:	40c8                	lw	a0,4(s1)
    800036e8:	893d                	andi	a0,a0,15
    800036ea:	051a                	slli	a0,a0,0x6
    800036ec:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800036ee:	04449703          	lh	a4,68(s1)
    800036f2:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800036f6:	04649703          	lh	a4,70(s1)
    800036fa:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800036fe:	04849703          	lh	a4,72(s1)
    80003702:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003706:	04a49703          	lh	a4,74(s1)
    8000370a:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    8000370e:	44f8                	lw	a4,76(s1)
    80003710:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003712:	03400613          	li	a2,52
    80003716:	05048593          	addi	a1,s1,80
    8000371a:	0531                	addi	a0,a0,12
    8000371c:	ffffd097          	auipc	ra,0xffffd
    80003720:	650080e7          	jalr	1616(ra) # 80000d6c <memmove>
  log_write(bp);
    80003724:	854a                	mv	a0,s2
    80003726:	00001097          	auipc	ra,0x1
    8000372a:	bf2080e7          	jalr	-1038(ra) # 80004318 <log_write>
  brelse(bp);
    8000372e:	854a                	mv	a0,s2
    80003730:	00000097          	auipc	ra,0x0
    80003734:	980080e7          	jalr	-1664(ra) # 800030b0 <brelse>
}
    80003738:	60e2                	ld	ra,24(sp)
    8000373a:	6442                	ld	s0,16(sp)
    8000373c:	64a2                	ld	s1,8(sp)
    8000373e:	6902                	ld	s2,0(sp)
    80003740:	6105                	addi	sp,sp,32
    80003742:	8082                	ret

0000000080003744 <idup>:
{
    80003744:	1101                	addi	sp,sp,-32
    80003746:	ec06                	sd	ra,24(sp)
    80003748:	e822                	sd	s0,16(sp)
    8000374a:	e426                	sd	s1,8(sp)
    8000374c:	1000                	addi	s0,sp,32
    8000374e:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003750:	0001d517          	auipc	a0,0x1d
    80003754:	b1050513          	addi	a0,a0,-1264 # 80020260 <icache>
    80003758:	ffffd097          	auipc	ra,0xffffd
    8000375c:	4b8080e7          	jalr	1208(ra) # 80000c10 <acquire>
  ip->ref++;
    80003760:	449c                	lw	a5,8(s1)
    80003762:	2785                	addiw	a5,a5,1
    80003764:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003766:	0001d517          	auipc	a0,0x1d
    8000376a:	afa50513          	addi	a0,a0,-1286 # 80020260 <icache>
    8000376e:	ffffd097          	auipc	ra,0xffffd
    80003772:	556080e7          	jalr	1366(ra) # 80000cc4 <release>
}
    80003776:	8526                	mv	a0,s1
    80003778:	60e2                	ld	ra,24(sp)
    8000377a:	6442                	ld	s0,16(sp)
    8000377c:	64a2                	ld	s1,8(sp)
    8000377e:	6105                	addi	sp,sp,32
    80003780:	8082                	ret

0000000080003782 <ilock>:
{
    80003782:	1101                	addi	sp,sp,-32
    80003784:	ec06                	sd	ra,24(sp)
    80003786:	e822                	sd	s0,16(sp)
    80003788:	e426                	sd	s1,8(sp)
    8000378a:	e04a                	sd	s2,0(sp)
    8000378c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000378e:	c115                	beqz	a0,800037b2 <ilock+0x30>
    80003790:	84aa                	mv	s1,a0
    80003792:	451c                	lw	a5,8(a0)
    80003794:	00f05f63          	blez	a5,800037b2 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003798:	0541                	addi	a0,a0,16
    8000379a:	00001097          	auipc	ra,0x1
    8000379e:	ca6080e7          	jalr	-858(ra) # 80004440 <acquiresleep>
  if(ip->valid == 0){
    800037a2:	40bc                	lw	a5,64(s1)
    800037a4:	cf99                	beqz	a5,800037c2 <ilock+0x40>
}
    800037a6:	60e2                	ld	ra,24(sp)
    800037a8:	6442                	ld	s0,16(sp)
    800037aa:	64a2                	ld	s1,8(sp)
    800037ac:	6902                	ld	s2,0(sp)
    800037ae:	6105                	addi	sp,sp,32
    800037b0:	8082                	ret
    panic("ilock");
    800037b2:	00005517          	auipc	a0,0x5
    800037b6:	dde50513          	addi	a0,a0,-546 # 80008590 <syscalls+0x180>
    800037ba:	ffffd097          	auipc	ra,0xffffd
    800037be:	d8e080e7          	jalr	-626(ra) # 80000548 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800037c2:	40dc                	lw	a5,4(s1)
    800037c4:	0047d79b          	srliw	a5,a5,0x4
    800037c8:	0001d597          	auipc	a1,0x1d
    800037cc:	a905a583          	lw	a1,-1392(a1) # 80020258 <sb+0x18>
    800037d0:	9dbd                	addw	a1,a1,a5
    800037d2:	4088                	lw	a0,0(s1)
    800037d4:	fffff097          	auipc	ra,0xfffff
    800037d8:	7ac080e7          	jalr	1964(ra) # 80002f80 <bread>
    800037dc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800037de:	05850593          	addi	a1,a0,88
    800037e2:	40dc                	lw	a5,4(s1)
    800037e4:	8bbd                	andi	a5,a5,15
    800037e6:	079a                	slli	a5,a5,0x6
    800037e8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800037ea:	00059783          	lh	a5,0(a1)
    800037ee:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800037f2:	00259783          	lh	a5,2(a1)
    800037f6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800037fa:	00459783          	lh	a5,4(a1)
    800037fe:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003802:	00659783          	lh	a5,6(a1)
    80003806:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000380a:	459c                	lw	a5,8(a1)
    8000380c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000380e:	03400613          	li	a2,52
    80003812:	05b1                	addi	a1,a1,12
    80003814:	05048513          	addi	a0,s1,80
    80003818:	ffffd097          	auipc	ra,0xffffd
    8000381c:	554080e7          	jalr	1364(ra) # 80000d6c <memmove>
    brelse(bp);
    80003820:	854a                	mv	a0,s2
    80003822:	00000097          	auipc	ra,0x0
    80003826:	88e080e7          	jalr	-1906(ra) # 800030b0 <brelse>
    ip->valid = 1;
    8000382a:	4785                	li	a5,1
    8000382c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000382e:	04449783          	lh	a5,68(s1)
    80003832:	fbb5                	bnez	a5,800037a6 <ilock+0x24>
      panic("ilock: no type");
    80003834:	00005517          	auipc	a0,0x5
    80003838:	d6450513          	addi	a0,a0,-668 # 80008598 <syscalls+0x188>
    8000383c:	ffffd097          	auipc	ra,0xffffd
    80003840:	d0c080e7          	jalr	-756(ra) # 80000548 <panic>

0000000080003844 <iunlock>:
{
    80003844:	1101                	addi	sp,sp,-32
    80003846:	ec06                	sd	ra,24(sp)
    80003848:	e822                	sd	s0,16(sp)
    8000384a:	e426                	sd	s1,8(sp)
    8000384c:	e04a                	sd	s2,0(sp)
    8000384e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003850:	c905                	beqz	a0,80003880 <iunlock+0x3c>
    80003852:	84aa                	mv	s1,a0
    80003854:	01050913          	addi	s2,a0,16
    80003858:	854a                	mv	a0,s2
    8000385a:	00001097          	auipc	ra,0x1
    8000385e:	c80080e7          	jalr	-896(ra) # 800044da <holdingsleep>
    80003862:	cd19                	beqz	a0,80003880 <iunlock+0x3c>
    80003864:	449c                	lw	a5,8(s1)
    80003866:	00f05d63          	blez	a5,80003880 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000386a:	854a                	mv	a0,s2
    8000386c:	00001097          	auipc	ra,0x1
    80003870:	c2a080e7          	jalr	-982(ra) # 80004496 <releasesleep>
}
    80003874:	60e2                	ld	ra,24(sp)
    80003876:	6442                	ld	s0,16(sp)
    80003878:	64a2                	ld	s1,8(sp)
    8000387a:	6902                	ld	s2,0(sp)
    8000387c:	6105                	addi	sp,sp,32
    8000387e:	8082                	ret
    panic("iunlock");
    80003880:	00005517          	auipc	a0,0x5
    80003884:	d2850513          	addi	a0,a0,-728 # 800085a8 <syscalls+0x198>
    80003888:	ffffd097          	auipc	ra,0xffffd
    8000388c:	cc0080e7          	jalr	-832(ra) # 80000548 <panic>

0000000080003890 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003890:	7179                	addi	sp,sp,-48
    80003892:	f406                	sd	ra,40(sp)
    80003894:	f022                	sd	s0,32(sp)
    80003896:	ec26                	sd	s1,24(sp)
    80003898:	e84a                	sd	s2,16(sp)
    8000389a:	e44e                	sd	s3,8(sp)
    8000389c:	e052                	sd	s4,0(sp)
    8000389e:	1800                	addi	s0,sp,48
    800038a0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800038a2:	05050493          	addi	s1,a0,80
    800038a6:	08050913          	addi	s2,a0,128
    800038aa:	a021                	j	800038b2 <itrunc+0x22>
    800038ac:	0491                	addi	s1,s1,4
    800038ae:	01248d63          	beq	s1,s2,800038c8 <itrunc+0x38>
    if(ip->addrs[i]){
    800038b2:	408c                	lw	a1,0(s1)
    800038b4:	dde5                	beqz	a1,800038ac <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800038b6:	0009a503          	lw	a0,0(s3)
    800038ba:	00000097          	auipc	ra,0x0
    800038be:	90c080e7          	jalr	-1780(ra) # 800031c6 <bfree>
      ip->addrs[i] = 0;
    800038c2:	0004a023          	sw	zero,0(s1)
    800038c6:	b7dd                	j	800038ac <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    800038c8:	0809a583          	lw	a1,128(s3)
    800038cc:	e185                	bnez	a1,800038ec <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800038ce:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800038d2:	854e                	mv	a0,s3
    800038d4:	00000097          	auipc	ra,0x0
    800038d8:	de4080e7          	jalr	-540(ra) # 800036b8 <iupdate>
}
    800038dc:	70a2                	ld	ra,40(sp)
    800038de:	7402                	ld	s0,32(sp)
    800038e0:	64e2                	ld	s1,24(sp)
    800038e2:	6942                	ld	s2,16(sp)
    800038e4:	69a2                	ld	s3,8(sp)
    800038e6:	6a02                	ld	s4,0(sp)
    800038e8:	6145                	addi	sp,sp,48
    800038ea:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800038ec:	0009a503          	lw	a0,0(s3)
    800038f0:	fffff097          	auipc	ra,0xfffff
    800038f4:	690080e7          	jalr	1680(ra) # 80002f80 <bread>
    800038f8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800038fa:	05850493          	addi	s1,a0,88
    800038fe:	45850913          	addi	s2,a0,1112
    80003902:	a811                	j	80003916 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80003904:	0009a503          	lw	a0,0(s3)
    80003908:	00000097          	auipc	ra,0x0
    8000390c:	8be080e7          	jalr	-1858(ra) # 800031c6 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80003910:	0491                	addi	s1,s1,4
    80003912:	01248563          	beq	s1,s2,8000391c <itrunc+0x8c>
      if(a[j])
    80003916:	408c                	lw	a1,0(s1)
    80003918:	dde5                	beqz	a1,80003910 <itrunc+0x80>
    8000391a:	b7ed                	j	80003904 <itrunc+0x74>
    brelse(bp);
    8000391c:	8552                	mv	a0,s4
    8000391e:	fffff097          	auipc	ra,0xfffff
    80003922:	792080e7          	jalr	1938(ra) # 800030b0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003926:	0809a583          	lw	a1,128(s3)
    8000392a:	0009a503          	lw	a0,0(s3)
    8000392e:	00000097          	auipc	ra,0x0
    80003932:	898080e7          	jalr	-1896(ra) # 800031c6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003936:	0809a023          	sw	zero,128(s3)
    8000393a:	bf51                	j	800038ce <itrunc+0x3e>

000000008000393c <iput>:
{
    8000393c:	1101                	addi	sp,sp,-32
    8000393e:	ec06                	sd	ra,24(sp)
    80003940:	e822                	sd	s0,16(sp)
    80003942:	e426                	sd	s1,8(sp)
    80003944:	e04a                	sd	s2,0(sp)
    80003946:	1000                	addi	s0,sp,32
    80003948:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    8000394a:	0001d517          	auipc	a0,0x1d
    8000394e:	91650513          	addi	a0,a0,-1770 # 80020260 <icache>
    80003952:	ffffd097          	auipc	ra,0xffffd
    80003956:	2be080e7          	jalr	702(ra) # 80000c10 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000395a:	4498                	lw	a4,8(s1)
    8000395c:	4785                	li	a5,1
    8000395e:	02f70363          	beq	a4,a5,80003984 <iput+0x48>
  ip->ref--;
    80003962:	449c                	lw	a5,8(s1)
    80003964:	37fd                	addiw	a5,a5,-1
    80003966:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003968:	0001d517          	auipc	a0,0x1d
    8000396c:	8f850513          	addi	a0,a0,-1800 # 80020260 <icache>
    80003970:	ffffd097          	auipc	ra,0xffffd
    80003974:	354080e7          	jalr	852(ra) # 80000cc4 <release>
}
    80003978:	60e2                	ld	ra,24(sp)
    8000397a:	6442                	ld	s0,16(sp)
    8000397c:	64a2                	ld	s1,8(sp)
    8000397e:	6902                	ld	s2,0(sp)
    80003980:	6105                	addi	sp,sp,32
    80003982:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003984:	40bc                	lw	a5,64(s1)
    80003986:	dff1                	beqz	a5,80003962 <iput+0x26>
    80003988:	04a49783          	lh	a5,74(s1)
    8000398c:	fbf9                	bnez	a5,80003962 <iput+0x26>
    acquiresleep(&ip->lock);
    8000398e:	01048913          	addi	s2,s1,16
    80003992:	854a                	mv	a0,s2
    80003994:	00001097          	auipc	ra,0x1
    80003998:	aac080e7          	jalr	-1364(ra) # 80004440 <acquiresleep>
    release(&icache.lock);
    8000399c:	0001d517          	auipc	a0,0x1d
    800039a0:	8c450513          	addi	a0,a0,-1852 # 80020260 <icache>
    800039a4:	ffffd097          	auipc	ra,0xffffd
    800039a8:	320080e7          	jalr	800(ra) # 80000cc4 <release>
    itrunc(ip);
    800039ac:	8526                	mv	a0,s1
    800039ae:	00000097          	auipc	ra,0x0
    800039b2:	ee2080e7          	jalr	-286(ra) # 80003890 <itrunc>
    ip->type = 0;
    800039b6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800039ba:	8526                	mv	a0,s1
    800039bc:	00000097          	auipc	ra,0x0
    800039c0:	cfc080e7          	jalr	-772(ra) # 800036b8 <iupdate>
    ip->valid = 0;
    800039c4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800039c8:	854a                	mv	a0,s2
    800039ca:	00001097          	auipc	ra,0x1
    800039ce:	acc080e7          	jalr	-1332(ra) # 80004496 <releasesleep>
    acquire(&icache.lock);
    800039d2:	0001d517          	auipc	a0,0x1d
    800039d6:	88e50513          	addi	a0,a0,-1906 # 80020260 <icache>
    800039da:	ffffd097          	auipc	ra,0xffffd
    800039de:	236080e7          	jalr	566(ra) # 80000c10 <acquire>
    800039e2:	b741                	j	80003962 <iput+0x26>

00000000800039e4 <iunlockput>:
{
    800039e4:	1101                	addi	sp,sp,-32
    800039e6:	ec06                	sd	ra,24(sp)
    800039e8:	e822                	sd	s0,16(sp)
    800039ea:	e426                	sd	s1,8(sp)
    800039ec:	1000                	addi	s0,sp,32
    800039ee:	84aa                	mv	s1,a0
  iunlock(ip);
    800039f0:	00000097          	auipc	ra,0x0
    800039f4:	e54080e7          	jalr	-428(ra) # 80003844 <iunlock>
  iput(ip);
    800039f8:	8526                	mv	a0,s1
    800039fa:	00000097          	auipc	ra,0x0
    800039fe:	f42080e7          	jalr	-190(ra) # 8000393c <iput>
}
    80003a02:	60e2                	ld	ra,24(sp)
    80003a04:	6442                	ld	s0,16(sp)
    80003a06:	64a2                	ld	s1,8(sp)
    80003a08:	6105                	addi	sp,sp,32
    80003a0a:	8082                	ret

0000000080003a0c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003a0c:	1141                	addi	sp,sp,-16
    80003a0e:	e422                	sd	s0,8(sp)
    80003a10:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003a12:	411c                	lw	a5,0(a0)
    80003a14:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003a16:	415c                	lw	a5,4(a0)
    80003a18:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003a1a:	04451783          	lh	a5,68(a0)
    80003a1e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003a22:	04a51783          	lh	a5,74(a0)
    80003a26:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003a2a:	04c56783          	lwu	a5,76(a0)
    80003a2e:	e99c                	sd	a5,16(a1)
}
    80003a30:	6422                	ld	s0,8(sp)
    80003a32:	0141                	addi	sp,sp,16
    80003a34:	8082                	ret

0000000080003a36 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a36:	457c                	lw	a5,76(a0)
    80003a38:	0ed7e963          	bltu	a5,a3,80003b2a <readi+0xf4>
{
    80003a3c:	7159                	addi	sp,sp,-112
    80003a3e:	f486                	sd	ra,104(sp)
    80003a40:	f0a2                	sd	s0,96(sp)
    80003a42:	eca6                	sd	s1,88(sp)
    80003a44:	e8ca                	sd	s2,80(sp)
    80003a46:	e4ce                	sd	s3,72(sp)
    80003a48:	e0d2                	sd	s4,64(sp)
    80003a4a:	fc56                	sd	s5,56(sp)
    80003a4c:	f85a                	sd	s6,48(sp)
    80003a4e:	f45e                	sd	s7,40(sp)
    80003a50:	f062                	sd	s8,32(sp)
    80003a52:	ec66                	sd	s9,24(sp)
    80003a54:	e86a                	sd	s10,16(sp)
    80003a56:	e46e                	sd	s11,8(sp)
    80003a58:	1880                	addi	s0,sp,112
    80003a5a:	8baa                	mv	s7,a0
    80003a5c:	8c2e                	mv	s8,a1
    80003a5e:	8ab2                	mv	s5,a2
    80003a60:	84b6                	mv	s1,a3
    80003a62:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003a64:	9f35                	addw	a4,a4,a3
    return 0;
    80003a66:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003a68:	0ad76063          	bltu	a4,a3,80003b08 <readi+0xd2>
  if(off + n > ip->size)
    80003a6c:	00e7f463          	bgeu	a5,a4,80003a74 <readi+0x3e>
    n = ip->size - off;
    80003a70:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a74:	0a0b0963          	beqz	s6,80003b26 <readi+0xf0>
    80003a78:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a7a:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003a7e:	5cfd                	li	s9,-1
    80003a80:	a82d                	j	80003aba <readi+0x84>
    80003a82:	020a1d93          	slli	s11,s4,0x20
    80003a86:	020ddd93          	srli	s11,s11,0x20
    80003a8a:	05890613          	addi	a2,s2,88
    80003a8e:	86ee                	mv	a3,s11
    80003a90:	963a                	add	a2,a2,a4
    80003a92:	85d6                	mv	a1,s5
    80003a94:	8562                	mv	a0,s8
    80003a96:	fffff097          	auipc	ra,0xfffff
    80003a9a:	a8e080e7          	jalr	-1394(ra) # 80002524 <either_copyout>
    80003a9e:	05950d63          	beq	a0,s9,80003af8 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003aa2:	854a                	mv	a0,s2
    80003aa4:	fffff097          	auipc	ra,0xfffff
    80003aa8:	60c080e7          	jalr	1548(ra) # 800030b0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003aac:	013a09bb          	addw	s3,s4,s3
    80003ab0:	009a04bb          	addw	s1,s4,s1
    80003ab4:	9aee                	add	s5,s5,s11
    80003ab6:	0569f763          	bgeu	s3,s6,80003b04 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003aba:	000ba903          	lw	s2,0(s7)
    80003abe:	00a4d59b          	srliw	a1,s1,0xa
    80003ac2:	855e                	mv	a0,s7
    80003ac4:	00000097          	auipc	ra,0x0
    80003ac8:	8b0080e7          	jalr	-1872(ra) # 80003374 <bmap>
    80003acc:	0005059b          	sext.w	a1,a0
    80003ad0:	854a                	mv	a0,s2
    80003ad2:	fffff097          	auipc	ra,0xfffff
    80003ad6:	4ae080e7          	jalr	1198(ra) # 80002f80 <bread>
    80003ada:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003adc:	3ff4f713          	andi	a4,s1,1023
    80003ae0:	40ed07bb          	subw	a5,s10,a4
    80003ae4:	413b06bb          	subw	a3,s6,s3
    80003ae8:	8a3e                	mv	s4,a5
    80003aea:	2781                	sext.w	a5,a5
    80003aec:	0006861b          	sext.w	a2,a3
    80003af0:	f8f679e3          	bgeu	a2,a5,80003a82 <readi+0x4c>
    80003af4:	8a36                	mv	s4,a3
    80003af6:	b771                	j	80003a82 <readi+0x4c>
      brelse(bp);
    80003af8:	854a                	mv	a0,s2
    80003afa:	fffff097          	auipc	ra,0xfffff
    80003afe:	5b6080e7          	jalr	1462(ra) # 800030b0 <brelse>
      tot = -1;
    80003b02:	59fd                	li	s3,-1
  }
  return tot;
    80003b04:	0009851b          	sext.w	a0,s3
}
    80003b08:	70a6                	ld	ra,104(sp)
    80003b0a:	7406                	ld	s0,96(sp)
    80003b0c:	64e6                	ld	s1,88(sp)
    80003b0e:	6946                	ld	s2,80(sp)
    80003b10:	69a6                	ld	s3,72(sp)
    80003b12:	6a06                	ld	s4,64(sp)
    80003b14:	7ae2                	ld	s5,56(sp)
    80003b16:	7b42                	ld	s6,48(sp)
    80003b18:	7ba2                	ld	s7,40(sp)
    80003b1a:	7c02                	ld	s8,32(sp)
    80003b1c:	6ce2                	ld	s9,24(sp)
    80003b1e:	6d42                	ld	s10,16(sp)
    80003b20:	6da2                	ld	s11,8(sp)
    80003b22:	6165                	addi	sp,sp,112
    80003b24:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b26:	89da                	mv	s3,s6
    80003b28:	bff1                	j	80003b04 <readi+0xce>
    return 0;
    80003b2a:	4501                	li	a0,0
}
    80003b2c:	8082                	ret

0000000080003b2e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b2e:	457c                	lw	a5,76(a0)
    80003b30:	10d7e763          	bltu	a5,a3,80003c3e <writei+0x110>
{
    80003b34:	7159                	addi	sp,sp,-112
    80003b36:	f486                	sd	ra,104(sp)
    80003b38:	f0a2                	sd	s0,96(sp)
    80003b3a:	eca6                	sd	s1,88(sp)
    80003b3c:	e8ca                	sd	s2,80(sp)
    80003b3e:	e4ce                	sd	s3,72(sp)
    80003b40:	e0d2                	sd	s4,64(sp)
    80003b42:	fc56                	sd	s5,56(sp)
    80003b44:	f85a                	sd	s6,48(sp)
    80003b46:	f45e                	sd	s7,40(sp)
    80003b48:	f062                	sd	s8,32(sp)
    80003b4a:	ec66                	sd	s9,24(sp)
    80003b4c:	e86a                	sd	s10,16(sp)
    80003b4e:	e46e                	sd	s11,8(sp)
    80003b50:	1880                	addi	s0,sp,112
    80003b52:	8baa                	mv	s7,a0
    80003b54:	8c2e                	mv	s8,a1
    80003b56:	8ab2                	mv	s5,a2
    80003b58:	8936                	mv	s2,a3
    80003b5a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b5c:	00e687bb          	addw	a5,a3,a4
    80003b60:	0ed7e163          	bltu	a5,a3,80003c42 <writei+0x114>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003b64:	00043737          	lui	a4,0x43
    80003b68:	0cf76f63          	bltu	a4,a5,80003c46 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b6c:	0a0b0863          	beqz	s6,80003c1c <writei+0xee>
    80003b70:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b72:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003b76:	5cfd                	li	s9,-1
    80003b78:	a091                	j	80003bbc <writei+0x8e>
    80003b7a:	02099d93          	slli	s11,s3,0x20
    80003b7e:	020ddd93          	srli	s11,s11,0x20
    80003b82:	05848513          	addi	a0,s1,88
    80003b86:	86ee                	mv	a3,s11
    80003b88:	8656                	mv	a2,s5
    80003b8a:	85e2                	mv	a1,s8
    80003b8c:	953a                	add	a0,a0,a4
    80003b8e:	fffff097          	auipc	ra,0xfffff
    80003b92:	9ec080e7          	jalr	-1556(ra) # 8000257a <either_copyin>
    80003b96:	07950263          	beq	a0,s9,80003bfa <writei+0xcc>
      brelse(bp);
      n = -1;
      break;
    }
    log_write(bp);
    80003b9a:	8526                	mv	a0,s1
    80003b9c:	00000097          	auipc	ra,0x0
    80003ba0:	77c080e7          	jalr	1916(ra) # 80004318 <log_write>
    brelse(bp);
    80003ba4:	8526                	mv	a0,s1
    80003ba6:	fffff097          	auipc	ra,0xfffff
    80003baa:	50a080e7          	jalr	1290(ra) # 800030b0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bae:	01498a3b          	addw	s4,s3,s4
    80003bb2:	0129893b          	addw	s2,s3,s2
    80003bb6:	9aee                	add	s5,s5,s11
    80003bb8:	056a7763          	bgeu	s4,s6,80003c06 <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003bbc:	000ba483          	lw	s1,0(s7)
    80003bc0:	00a9559b          	srliw	a1,s2,0xa
    80003bc4:	855e                	mv	a0,s7
    80003bc6:	fffff097          	auipc	ra,0xfffff
    80003bca:	7ae080e7          	jalr	1966(ra) # 80003374 <bmap>
    80003bce:	0005059b          	sext.w	a1,a0
    80003bd2:	8526                	mv	a0,s1
    80003bd4:	fffff097          	auipc	ra,0xfffff
    80003bd8:	3ac080e7          	jalr	940(ra) # 80002f80 <bread>
    80003bdc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bde:	3ff97713          	andi	a4,s2,1023
    80003be2:	40ed07bb          	subw	a5,s10,a4
    80003be6:	414b06bb          	subw	a3,s6,s4
    80003bea:	89be                	mv	s3,a5
    80003bec:	2781                	sext.w	a5,a5
    80003bee:	0006861b          	sext.w	a2,a3
    80003bf2:	f8f674e3          	bgeu	a2,a5,80003b7a <writei+0x4c>
    80003bf6:	89b6                	mv	s3,a3
    80003bf8:	b749                	j	80003b7a <writei+0x4c>
      brelse(bp);
    80003bfa:	8526                	mv	a0,s1
    80003bfc:	fffff097          	auipc	ra,0xfffff
    80003c00:	4b4080e7          	jalr	1204(ra) # 800030b0 <brelse>
      n = -1;
    80003c04:	5b7d                	li	s6,-1
  }

  if(n > 0){
    if(off > ip->size)
    80003c06:	04cba783          	lw	a5,76(s7)
    80003c0a:	0127f463          	bgeu	a5,s2,80003c12 <writei+0xe4>
      ip->size = off;
    80003c0e:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003c12:	855e                	mv	a0,s7
    80003c14:	00000097          	auipc	ra,0x0
    80003c18:	aa4080e7          	jalr	-1372(ra) # 800036b8 <iupdate>
  }

  return n;
    80003c1c:	000b051b          	sext.w	a0,s6
}
    80003c20:	70a6                	ld	ra,104(sp)
    80003c22:	7406                	ld	s0,96(sp)
    80003c24:	64e6                	ld	s1,88(sp)
    80003c26:	6946                	ld	s2,80(sp)
    80003c28:	69a6                	ld	s3,72(sp)
    80003c2a:	6a06                	ld	s4,64(sp)
    80003c2c:	7ae2                	ld	s5,56(sp)
    80003c2e:	7b42                	ld	s6,48(sp)
    80003c30:	7ba2                	ld	s7,40(sp)
    80003c32:	7c02                	ld	s8,32(sp)
    80003c34:	6ce2                	ld	s9,24(sp)
    80003c36:	6d42                	ld	s10,16(sp)
    80003c38:	6da2                	ld	s11,8(sp)
    80003c3a:	6165                	addi	sp,sp,112
    80003c3c:	8082                	ret
    return -1;
    80003c3e:	557d                	li	a0,-1
}
    80003c40:	8082                	ret
    return -1;
    80003c42:	557d                	li	a0,-1
    80003c44:	bff1                	j	80003c20 <writei+0xf2>
    return -1;
    80003c46:	557d                	li	a0,-1
    80003c48:	bfe1                	j	80003c20 <writei+0xf2>

0000000080003c4a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003c4a:	1141                	addi	sp,sp,-16
    80003c4c:	e406                	sd	ra,8(sp)
    80003c4e:	e022                	sd	s0,0(sp)
    80003c50:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c52:	4639                	li	a2,14
    80003c54:	ffffd097          	auipc	ra,0xffffd
    80003c58:	194080e7          	jalr	404(ra) # 80000de8 <strncmp>
}
    80003c5c:	60a2                	ld	ra,8(sp)
    80003c5e:	6402                	ld	s0,0(sp)
    80003c60:	0141                	addi	sp,sp,16
    80003c62:	8082                	ret

0000000080003c64 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c64:	7139                	addi	sp,sp,-64
    80003c66:	fc06                	sd	ra,56(sp)
    80003c68:	f822                	sd	s0,48(sp)
    80003c6a:	f426                	sd	s1,40(sp)
    80003c6c:	f04a                	sd	s2,32(sp)
    80003c6e:	ec4e                	sd	s3,24(sp)
    80003c70:	e852                	sd	s4,16(sp)
    80003c72:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003c74:	04451703          	lh	a4,68(a0)
    80003c78:	4785                	li	a5,1
    80003c7a:	00f71a63          	bne	a4,a5,80003c8e <dirlookup+0x2a>
    80003c7e:	892a                	mv	s2,a0
    80003c80:	89ae                	mv	s3,a1
    80003c82:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c84:	457c                	lw	a5,76(a0)
    80003c86:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003c88:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c8a:	e79d                	bnez	a5,80003cb8 <dirlookup+0x54>
    80003c8c:	a8a5                	j	80003d04 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003c8e:	00005517          	auipc	a0,0x5
    80003c92:	92250513          	addi	a0,a0,-1758 # 800085b0 <syscalls+0x1a0>
    80003c96:	ffffd097          	auipc	ra,0xffffd
    80003c9a:	8b2080e7          	jalr	-1870(ra) # 80000548 <panic>
      panic("dirlookup read");
    80003c9e:	00005517          	auipc	a0,0x5
    80003ca2:	92a50513          	addi	a0,a0,-1750 # 800085c8 <syscalls+0x1b8>
    80003ca6:	ffffd097          	auipc	ra,0xffffd
    80003caa:	8a2080e7          	jalr	-1886(ra) # 80000548 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cae:	24c1                	addiw	s1,s1,16
    80003cb0:	04c92783          	lw	a5,76(s2)
    80003cb4:	04f4f763          	bgeu	s1,a5,80003d02 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cb8:	4741                	li	a4,16
    80003cba:	86a6                	mv	a3,s1
    80003cbc:	fc040613          	addi	a2,s0,-64
    80003cc0:	4581                	li	a1,0
    80003cc2:	854a                	mv	a0,s2
    80003cc4:	00000097          	auipc	ra,0x0
    80003cc8:	d72080e7          	jalr	-654(ra) # 80003a36 <readi>
    80003ccc:	47c1                	li	a5,16
    80003cce:	fcf518e3          	bne	a0,a5,80003c9e <dirlookup+0x3a>
    if(de.inum == 0)
    80003cd2:	fc045783          	lhu	a5,-64(s0)
    80003cd6:	dfe1                	beqz	a5,80003cae <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003cd8:	fc240593          	addi	a1,s0,-62
    80003cdc:	854e                	mv	a0,s3
    80003cde:	00000097          	auipc	ra,0x0
    80003ce2:	f6c080e7          	jalr	-148(ra) # 80003c4a <namecmp>
    80003ce6:	f561                	bnez	a0,80003cae <dirlookup+0x4a>
      if(poff)
    80003ce8:	000a0463          	beqz	s4,80003cf0 <dirlookup+0x8c>
        *poff = off;
    80003cec:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003cf0:	fc045583          	lhu	a1,-64(s0)
    80003cf4:	00092503          	lw	a0,0(s2)
    80003cf8:	fffff097          	auipc	ra,0xfffff
    80003cfc:	756080e7          	jalr	1878(ra) # 8000344e <iget>
    80003d00:	a011                	j	80003d04 <dirlookup+0xa0>
  return 0;
    80003d02:	4501                	li	a0,0
}
    80003d04:	70e2                	ld	ra,56(sp)
    80003d06:	7442                	ld	s0,48(sp)
    80003d08:	74a2                	ld	s1,40(sp)
    80003d0a:	7902                	ld	s2,32(sp)
    80003d0c:	69e2                	ld	s3,24(sp)
    80003d0e:	6a42                	ld	s4,16(sp)
    80003d10:	6121                	addi	sp,sp,64
    80003d12:	8082                	ret

0000000080003d14 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003d14:	711d                	addi	sp,sp,-96
    80003d16:	ec86                	sd	ra,88(sp)
    80003d18:	e8a2                	sd	s0,80(sp)
    80003d1a:	e4a6                	sd	s1,72(sp)
    80003d1c:	e0ca                	sd	s2,64(sp)
    80003d1e:	fc4e                	sd	s3,56(sp)
    80003d20:	f852                	sd	s4,48(sp)
    80003d22:	f456                	sd	s5,40(sp)
    80003d24:	f05a                	sd	s6,32(sp)
    80003d26:	ec5e                	sd	s7,24(sp)
    80003d28:	e862                	sd	s8,16(sp)
    80003d2a:	e466                	sd	s9,8(sp)
    80003d2c:	1080                	addi	s0,sp,96
    80003d2e:	84aa                	mv	s1,a0
    80003d30:	8b2e                	mv	s6,a1
    80003d32:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003d34:	00054703          	lbu	a4,0(a0)
    80003d38:	02f00793          	li	a5,47
    80003d3c:	02f70363          	beq	a4,a5,80003d62 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003d40:	ffffe097          	auipc	ra,0xffffe
    80003d44:	d4a080e7          	jalr	-694(ra) # 80001a8a <myproc>
    80003d48:	16053503          	ld	a0,352(a0)
    80003d4c:	00000097          	auipc	ra,0x0
    80003d50:	9f8080e7          	jalr	-1544(ra) # 80003744 <idup>
    80003d54:	89aa                	mv	s3,a0
  while(*path == '/')
    80003d56:	02f00913          	li	s2,47
  len = path - s;
    80003d5a:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003d5c:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d5e:	4c05                	li	s8,1
    80003d60:	a865                	j	80003e18 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003d62:	4585                	li	a1,1
    80003d64:	4505                	li	a0,1
    80003d66:	fffff097          	auipc	ra,0xfffff
    80003d6a:	6e8080e7          	jalr	1768(ra) # 8000344e <iget>
    80003d6e:	89aa                	mv	s3,a0
    80003d70:	b7dd                	j	80003d56 <namex+0x42>
      iunlockput(ip);
    80003d72:	854e                	mv	a0,s3
    80003d74:	00000097          	auipc	ra,0x0
    80003d78:	c70080e7          	jalr	-912(ra) # 800039e4 <iunlockput>
      return 0;
    80003d7c:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d7e:	854e                	mv	a0,s3
    80003d80:	60e6                	ld	ra,88(sp)
    80003d82:	6446                	ld	s0,80(sp)
    80003d84:	64a6                	ld	s1,72(sp)
    80003d86:	6906                	ld	s2,64(sp)
    80003d88:	79e2                	ld	s3,56(sp)
    80003d8a:	7a42                	ld	s4,48(sp)
    80003d8c:	7aa2                	ld	s5,40(sp)
    80003d8e:	7b02                	ld	s6,32(sp)
    80003d90:	6be2                	ld	s7,24(sp)
    80003d92:	6c42                	ld	s8,16(sp)
    80003d94:	6ca2                	ld	s9,8(sp)
    80003d96:	6125                	addi	sp,sp,96
    80003d98:	8082                	ret
      iunlock(ip);
    80003d9a:	854e                	mv	a0,s3
    80003d9c:	00000097          	auipc	ra,0x0
    80003da0:	aa8080e7          	jalr	-1368(ra) # 80003844 <iunlock>
      return ip;
    80003da4:	bfe9                	j	80003d7e <namex+0x6a>
      iunlockput(ip);
    80003da6:	854e                	mv	a0,s3
    80003da8:	00000097          	auipc	ra,0x0
    80003dac:	c3c080e7          	jalr	-964(ra) # 800039e4 <iunlockput>
      return 0;
    80003db0:	89d2                	mv	s3,s4
    80003db2:	b7f1                	j	80003d7e <namex+0x6a>
  len = path - s;
    80003db4:	40b48633          	sub	a2,s1,a1
    80003db8:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003dbc:	094cd463          	bge	s9,s4,80003e44 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003dc0:	4639                	li	a2,14
    80003dc2:	8556                	mv	a0,s5
    80003dc4:	ffffd097          	auipc	ra,0xffffd
    80003dc8:	fa8080e7          	jalr	-88(ra) # 80000d6c <memmove>
  while(*path == '/')
    80003dcc:	0004c783          	lbu	a5,0(s1)
    80003dd0:	01279763          	bne	a5,s2,80003dde <namex+0xca>
    path++;
    80003dd4:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003dd6:	0004c783          	lbu	a5,0(s1)
    80003dda:	ff278de3          	beq	a5,s2,80003dd4 <namex+0xc0>
    ilock(ip);
    80003dde:	854e                	mv	a0,s3
    80003de0:	00000097          	auipc	ra,0x0
    80003de4:	9a2080e7          	jalr	-1630(ra) # 80003782 <ilock>
    if(ip->type != T_DIR){
    80003de8:	04499783          	lh	a5,68(s3)
    80003dec:	f98793e3          	bne	a5,s8,80003d72 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003df0:	000b0563          	beqz	s6,80003dfa <namex+0xe6>
    80003df4:	0004c783          	lbu	a5,0(s1)
    80003df8:	d3cd                	beqz	a5,80003d9a <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003dfa:	865e                	mv	a2,s7
    80003dfc:	85d6                	mv	a1,s5
    80003dfe:	854e                	mv	a0,s3
    80003e00:	00000097          	auipc	ra,0x0
    80003e04:	e64080e7          	jalr	-412(ra) # 80003c64 <dirlookup>
    80003e08:	8a2a                	mv	s4,a0
    80003e0a:	dd51                	beqz	a0,80003da6 <namex+0x92>
    iunlockput(ip);
    80003e0c:	854e                	mv	a0,s3
    80003e0e:	00000097          	auipc	ra,0x0
    80003e12:	bd6080e7          	jalr	-1066(ra) # 800039e4 <iunlockput>
    ip = next;
    80003e16:	89d2                	mv	s3,s4
  while(*path == '/')
    80003e18:	0004c783          	lbu	a5,0(s1)
    80003e1c:	05279763          	bne	a5,s2,80003e6a <namex+0x156>
    path++;
    80003e20:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003e22:	0004c783          	lbu	a5,0(s1)
    80003e26:	ff278de3          	beq	a5,s2,80003e20 <namex+0x10c>
  if(*path == 0)
    80003e2a:	c79d                	beqz	a5,80003e58 <namex+0x144>
    path++;
    80003e2c:	85a6                	mv	a1,s1
  len = path - s;
    80003e2e:	8a5e                	mv	s4,s7
    80003e30:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003e32:	01278963          	beq	a5,s2,80003e44 <namex+0x130>
    80003e36:	dfbd                	beqz	a5,80003db4 <namex+0xa0>
    path++;
    80003e38:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003e3a:	0004c783          	lbu	a5,0(s1)
    80003e3e:	ff279ce3          	bne	a5,s2,80003e36 <namex+0x122>
    80003e42:	bf8d                	j	80003db4 <namex+0xa0>
    memmove(name, s, len);
    80003e44:	2601                	sext.w	a2,a2
    80003e46:	8556                	mv	a0,s5
    80003e48:	ffffd097          	auipc	ra,0xffffd
    80003e4c:	f24080e7          	jalr	-220(ra) # 80000d6c <memmove>
    name[len] = 0;
    80003e50:	9a56                	add	s4,s4,s5
    80003e52:	000a0023          	sb	zero,0(s4)
    80003e56:	bf9d                	j	80003dcc <namex+0xb8>
  if(nameiparent){
    80003e58:	f20b03e3          	beqz	s6,80003d7e <namex+0x6a>
    iput(ip);
    80003e5c:	854e                	mv	a0,s3
    80003e5e:	00000097          	auipc	ra,0x0
    80003e62:	ade080e7          	jalr	-1314(ra) # 8000393c <iput>
    return 0;
    80003e66:	4981                	li	s3,0
    80003e68:	bf19                	j	80003d7e <namex+0x6a>
  if(*path == 0)
    80003e6a:	d7fd                	beqz	a5,80003e58 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003e6c:	0004c783          	lbu	a5,0(s1)
    80003e70:	85a6                	mv	a1,s1
    80003e72:	b7d1                	j	80003e36 <namex+0x122>

0000000080003e74 <dirlink>:
{
    80003e74:	7139                	addi	sp,sp,-64
    80003e76:	fc06                	sd	ra,56(sp)
    80003e78:	f822                	sd	s0,48(sp)
    80003e7a:	f426                	sd	s1,40(sp)
    80003e7c:	f04a                	sd	s2,32(sp)
    80003e7e:	ec4e                	sd	s3,24(sp)
    80003e80:	e852                	sd	s4,16(sp)
    80003e82:	0080                	addi	s0,sp,64
    80003e84:	892a                	mv	s2,a0
    80003e86:	8a2e                	mv	s4,a1
    80003e88:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e8a:	4601                	li	a2,0
    80003e8c:	00000097          	auipc	ra,0x0
    80003e90:	dd8080e7          	jalr	-552(ra) # 80003c64 <dirlookup>
    80003e94:	e93d                	bnez	a0,80003f0a <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e96:	04c92483          	lw	s1,76(s2)
    80003e9a:	c49d                	beqz	s1,80003ec8 <dirlink+0x54>
    80003e9c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e9e:	4741                	li	a4,16
    80003ea0:	86a6                	mv	a3,s1
    80003ea2:	fc040613          	addi	a2,s0,-64
    80003ea6:	4581                	li	a1,0
    80003ea8:	854a                	mv	a0,s2
    80003eaa:	00000097          	auipc	ra,0x0
    80003eae:	b8c080e7          	jalr	-1140(ra) # 80003a36 <readi>
    80003eb2:	47c1                	li	a5,16
    80003eb4:	06f51163          	bne	a0,a5,80003f16 <dirlink+0xa2>
    if(de.inum == 0)
    80003eb8:	fc045783          	lhu	a5,-64(s0)
    80003ebc:	c791                	beqz	a5,80003ec8 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ebe:	24c1                	addiw	s1,s1,16
    80003ec0:	04c92783          	lw	a5,76(s2)
    80003ec4:	fcf4ede3          	bltu	s1,a5,80003e9e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003ec8:	4639                	li	a2,14
    80003eca:	85d2                	mv	a1,s4
    80003ecc:	fc240513          	addi	a0,s0,-62
    80003ed0:	ffffd097          	auipc	ra,0xffffd
    80003ed4:	f54080e7          	jalr	-172(ra) # 80000e24 <strncpy>
  de.inum = inum;
    80003ed8:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003edc:	4741                	li	a4,16
    80003ede:	86a6                	mv	a3,s1
    80003ee0:	fc040613          	addi	a2,s0,-64
    80003ee4:	4581                	li	a1,0
    80003ee6:	854a                	mv	a0,s2
    80003ee8:	00000097          	auipc	ra,0x0
    80003eec:	c46080e7          	jalr	-954(ra) # 80003b2e <writei>
    80003ef0:	872a                	mv	a4,a0
    80003ef2:	47c1                	li	a5,16
  return 0;
    80003ef4:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ef6:	02f71863          	bne	a4,a5,80003f26 <dirlink+0xb2>
}
    80003efa:	70e2                	ld	ra,56(sp)
    80003efc:	7442                	ld	s0,48(sp)
    80003efe:	74a2                	ld	s1,40(sp)
    80003f00:	7902                	ld	s2,32(sp)
    80003f02:	69e2                	ld	s3,24(sp)
    80003f04:	6a42                	ld	s4,16(sp)
    80003f06:	6121                	addi	sp,sp,64
    80003f08:	8082                	ret
    iput(ip);
    80003f0a:	00000097          	auipc	ra,0x0
    80003f0e:	a32080e7          	jalr	-1486(ra) # 8000393c <iput>
    return -1;
    80003f12:	557d                	li	a0,-1
    80003f14:	b7dd                	j	80003efa <dirlink+0x86>
      panic("dirlink read");
    80003f16:	00004517          	auipc	a0,0x4
    80003f1a:	6c250513          	addi	a0,a0,1730 # 800085d8 <syscalls+0x1c8>
    80003f1e:	ffffc097          	auipc	ra,0xffffc
    80003f22:	62a080e7          	jalr	1578(ra) # 80000548 <panic>
    panic("dirlink");
    80003f26:	00004517          	auipc	a0,0x4
    80003f2a:	7da50513          	addi	a0,a0,2010 # 80008700 <syscalls+0x2f0>
    80003f2e:	ffffc097          	auipc	ra,0xffffc
    80003f32:	61a080e7          	jalr	1562(ra) # 80000548 <panic>

0000000080003f36 <namei>:

struct inode*
namei(char *path)
{
    80003f36:	1101                	addi	sp,sp,-32
    80003f38:	ec06                	sd	ra,24(sp)
    80003f3a:	e822                	sd	s0,16(sp)
    80003f3c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003f3e:	fe040613          	addi	a2,s0,-32
    80003f42:	4581                	li	a1,0
    80003f44:	00000097          	auipc	ra,0x0
    80003f48:	dd0080e7          	jalr	-560(ra) # 80003d14 <namex>
}
    80003f4c:	60e2                	ld	ra,24(sp)
    80003f4e:	6442                	ld	s0,16(sp)
    80003f50:	6105                	addi	sp,sp,32
    80003f52:	8082                	ret

0000000080003f54 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f54:	1141                	addi	sp,sp,-16
    80003f56:	e406                	sd	ra,8(sp)
    80003f58:	e022                	sd	s0,0(sp)
    80003f5a:	0800                	addi	s0,sp,16
    80003f5c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f5e:	4585                	li	a1,1
    80003f60:	00000097          	auipc	ra,0x0
    80003f64:	db4080e7          	jalr	-588(ra) # 80003d14 <namex>
}
    80003f68:	60a2                	ld	ra,8(sp)
    80003f6a:	6402                	ld	s0,0(sp)
    80003f6c:	0141                	addi	sp,sp,16
    80003f6e:	8082                	ret

0000000080003f70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003f70:	1101                	addi	sp,sp,-32
    80003f72:	ec06                	sd	ra,24(sp)
    80003f74:	e822                	sd	s0,16(sp)
    80003f76:	e426                	sd	s1,8(sp)
    80003f78:	e04a                	sd	s2,0(sp)
    80003f7a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f7c:	0001e917          	auipc	s2,0x1e
    80003f80:	d8c90913          	addi	s2,s2,-628 # 80021d08 <log>
    80003f84:	01892583          	lw	a1,24(s2)
    80003f88:	02892503          	lw	a0,40(s2)
    80003f8c:	fffff097          	auipc	ra,0xfffff
    80003f90:	ff4080e7          	jalr	-12(ra) # 80002f80 <bread>
    80003f94:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f96:	02c92683          	lw	a3,44(s2)
    80003f9a:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f9c:	02d05763          	blez	a3,80003fca <write_head+0x5a>
    80003fa0:	0001e797          	auipc	a5,0x1e
    80003fa4:	d9878793          	addi	a5,a5,-616 # 80021d38 <log+0x30>
    80003fa8:	05c50713          	addi	a4,a0,92
    80003fac:	36fd                	addiw	a3,a3,-1
    80003fae:	1682                	slli	a3,a3,0x20
    80003fb0:	9281                	srli	a3,a3,0x20
    80003fb2:	068a                	slli	a3,a3,0x2
    80003fb4:	0001e617          	auipc	a2,0x1e
    80003fb8:	d8860613          	addi	a2,a2,-632 # 80021d3c <log+0x34>
    80003fbc:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003fbe:	4390                	lw	a2,0(a5)
    80003fc0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003fc2:	0791                	addi	a5,a5,4
    80003fc4:	0711                	addi	a4,a4,4
    80003fc6:	fed79ce3          	bne	a5,a3,80003fbe <write_head+0x4e>
  }
  bwrite(buf);
    80003fca:	8526                	mv	a0,s1
    80003fcc:	fffff097          	auipc	ra,0xfffff
    80003fd0:	0a6080e7          	jalr	166(ra) # 80003072 <bwrite>
  brelse(buf);
    80003fd4:	8526                	mv	a0,s1
    80003fd6:	fffff097          	auipc	ra,0xfffff
    80003fda:	0da080e7          	jalr	218(ra) # 800030b0 <brelse>
}
    80003fde:	60e2                	ld	ra,24(sp)
    80003fe0:	6442                	ld	s0,16(sp)
    80003fe2:	64a2                	ld	s1,8(sp)
    80003fe4:	6902                	ld	s2,0(sp)
    80003fe6:	6105                	addi	sp,sp,32
    80003fe8:	8082                	ret

0000000080003fea <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fea:	0001e797          	auipc	a5,0x1e
    80003fee:	d4a7a783          	lw	a5,-694(a5) # 80021d34 <log+0x2c>
    80003ff2:	0af05663          	blez	a5,8000409e <install_trans+0xb4>
{
    80003ff6:	7139                	addi	sp,sp,-64
    80003ff8:	fc06                	sd	ra,56(sp)
    80003ffa:	f822                	sd	s0,48(sp)
    80003ffc:	f426                	sd	s1,40(sp)
    80003ffe:	f04a                	sd	s2,32(sp)
    80004000:	ec4e                	sd	s3,24(sp)
    80004002:	e852                	sd	s4,16(sp)
    80004004:	e456                	sd	s5,8(sp)
    80004006:	0080                	addi	s0,sp,64
    80004008:	0001ea97          	auipc	s5,0x1e
    8000400c:	d30a8a93          	addi	s5,s5,-720 # 80021d38 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004010:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004012:	0001e997          	auipc	s3,0x1e
    80004016:	cf698993          	addi	s3,s3,-778 # 80021d08 <log>
    8000401a:	0189a583          	lw	a1,24(s3)
    8000401e:	014585bb          	addw	a1,a1,s4
    80004022:	2585                	addiw	a1,a1,1
    80004024:	0289a503          	lw	a0,40(s3)
    80004028:	fffff097          	auipc	ra,0xfffff
    8000402c:	f58080e7          	jalr	-168(ra) # 80002f80 <bread>
    80004030:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004032:	000aa583          	lw	a1,0(s5)
    80004036:	0289a503          	lw	a0,40(s3)
    8000403a:	fffff097          	auipc	ra,0xfffff
    8000403e:	f46080e7          	jalr	-186(ra) # 80002f80 <bread>
    80004042:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004044:	40000613          	li	a2,1024
    80004048:	05890593          	addi	a1,s2,88
    8000404c:	05850513          	addi	a0,a0,88
    80004050:	ffffd097          	auipc	ra,0xffffd
    80004054:	d1c080e7          	jalr	-740(ra) # 80000d6c <memmove>
    bwrite(dbuf);  // write dst to disk
    80004058:	8526                	mv	a0,s1
    8000405a:	fffff097          	auipc	ra,0xfffff
    8000405e:	018080e7          	jalr	24(ra) # 80003072 <bwrite>
    bunpin(dbuf);
    80004062:	8526                	mv	a0,s1
    80004064:	fffff097          	auipc	ra,0xfffff
    80004068:	126080e7          	jalr	294(ra) # 8000318a <bunpin>
    brelse(lbuf);
    8000406c:	854a                	mv	a0,s2
    8000406e:	fffff097          	auipc	ra,0xfffff
    80004072:	042080e7          	jalr	66(ra) # 800030b0 <brelse>
    brelse(dbuf);
    80004076:	8526                	mv	a0,s1
    80004078:	fffff097          	auipc	ra,0xfffff
    8000407c:	038080e7          	jalr	56(ra) # 800030b0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004080:	2a05                	addiw	s4,s4,1
    80004082:	0a91                	addi	s5,s5,4
    80004084:	02c9a783          	lw	a5,44(s3)
    80004088:	f8fa49e3          	blt	s4,a5,8000401a <install_trans+0x30>
}
    8000408c:	70e2                	ld	ra,56(sp)
    8000408e:	7442                	ld	s0,48(sp)
    80004090:	74a2                	ld	s1,40(sp)
    80004092:	7902                	ld	s2,32(sp)
    80004094:	69e2                	ld	s3,24(sp)
    80004096:	6a42                	ld	s4,16(sp)
    80004098:	6aa2                	ld	s5,8(sp)
    8000409a:	6121                	addi	sp,sp,64
    8000409c:	8082                	ret
    8000409e:	8082                	ret

00000000800040a0 <initlog>:
{
    800040a0:	7179                	addi	sp,sp,-48
    800040a2:	f406                	sd	ra,40(sp)
    800040a4:	f022                	sd	s0,32(sp)
    800040a6:	ec26                	sd	s1,24(sp)
    800040a8:	e84a                	sd	s2,16(sp)
    800040aa:	e44e                	sd	s3,8(sp)
    800040ac:	1800                	addi	s0,sp,48
    800040ae:	892a                	mv	s2,a0
    800040b0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800040b2:	0001e497          	auipc	s1,0x1e
    800040b6:	c5648493          	addi	s1,s1,-938 # 80021d08 <log>
    800040ba:	00004597          	auipc	a1,0x4
    800040be:	52e58593          	addi	a1,a1,1326 # 800085e8 <syscalls+0x1d8>
    800040c2:	8526                	mv	a0,s1
    800040c4:	ffffd097          	auipc	ra,0xffffd
    800040c8:	abc080e7          	jalr	-1348(ra) # 80000b80 <initlock>
  log.start = sb->logstart;
    800040cc:	0149a583          	lw	a1,20(s3)
    800040d0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800040d2:	0109a783          	lw	a5,16(s3)
    800040d6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800040d8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800040dc:	854a                	mv	a0,s2
    800040de:	fffff097          	auipc	ra,0xfffff
    800040e2:	ea2080e7          	jalr	-350(ra) # 80002f80 <bread>
  log.lh.n = lh->n;
    800040e6:	4d3c                	lw	a5,88(a0)
    800040e8:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800040ea:	02f05563          	blez	a5,80004114 <initlog+0x74>
    800040ee:	05c50713          	addi	a4,a0,92
    800040f2:	0001e697          	auipc	a3,0x1e
    800040f6:	c4668693          	addi	a3,a3,-954 # 80021d38 <log+0x30>
    800040fa:	37fd                	addiw	a5,a5,-1
    800040fc:	1782                	slli	a5,a5,0x20
    800040fe:	9381                	srli	a5,a5,0x20
    80004100:	078a                	slli	a5,a5,0x2
    80004102:	06050613          	addi	a2,a0,96
    80004106:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80004108:	4310                	lw	a2,0(a4)
    8000410a:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000410c:	0711                	addi	a4,a4,4
    8000410e:	0691                	addi	a3,a3,4
    80004110:	fef71ce3          	bne	a4,a5,80004108 <initlog+0x68>
  brelse(buf);
    80004114:	fffff097          	auipc	ra,0xfffff
    80004118:	f9c080e7          	jalr	-100(ra) # 800030b0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    8000411c:	00000097          	auipc	ra,0x0
    80004120:	ece080e7          	jalr	-306(ra) # 80003fea <install_trans>
  log.lh.n = 0;
    80004124:	0001e797          	auipc	a5,0x1e
    80004128:	c007a823          	sw	zero,-1008(a5) # 80021d34 <log+0x2c>
  write_head(); // clear the log
    8000412c:	00000097          	auipc	ra,0x0
    80004130:	e44080e7          	jalr	-444(ra) # 80003f70 <write_head>
}
    80004134:	70a2                	ld	ra,40(sp)
    80004136:	7402                	ld	s0,32(sp)
    80004138:	64e2                	ld	s1,24(sp)
    8000413a:	6942                	ld	s2,16(sp)
    8000413c:	69a2                	ld	s3,8(sp)
    8000413e:	6145                	addi	sp,sp,48
    80004140:	8082                	ret

0000000080004142 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004142:	1101                	addi	sp,sp,-32
    80004144:	ec06                	sd	ra,24(sp)
    80004146:	e822                	sd	s0,16(sp)
    80004148:	e426                	sd	s1,8(sp)
    8000414a:	e04a                	sd	s2,0(sp)
    8000414c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000414e:	0001e517          	auipc	a0,0x1e
    80004152:	bba50513          	addi	a0,a0,-1094 # 80021d08 <log>
    80004156:	ffffd097          	auipc	ra,0xffffd
    8000415a:	aba080e7          	jalr	-1350(ra) # 80000c10 <acquire>
  while(1){
    if(log.committing){
    8000415e:	0001e497          	auipc	s1,0x1e
    80004162:	baa48493          	addi	s1,s1,-1110 # 80021d08 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004166:	4979                	li	s2,30
    80004168:	a039                	j	80004176 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000416a:	85a6                	mv	a1,s1
    8000416c:	8526                	mv	a0,s1
    8000416e:	ffffe097          	auipc	ra,0xffffe
    80004172:	154080e7          	jalr	340(ra) # 800022c2 <sleep>
    if(log.committing){
    80004176:	50dc                	lw	a5,36(s1)
    80004178:	fbed                	bnez	a5,8000416a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000417a:	509c                	lw	a5,32(s1)
    8000417c:	0017871b          	addiw	a4,a5,1
    80004180:	0007069b          	sext.w	a3,a4
    80004184:	0027179b          	slliw	a5,a4,0x2
    80004188:	9fb9                	addw	a5,a5,a4
    8000418a:	0017979b          	slliw	a5,a5,0x1
    8000418e:	54d8                	lw	a4,44(s1)
    80004190:	9fb9                	addw	a5,a5,a4
    80004192:	00f95963          	bge	s2,a5,800041a4 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004196:	85a6                	mv	a1,s1
    80004198:	8526                	mv	a0,s1
    8000419a:	ffffe097          	auipc	ra,0xffffe
    8000419e:	128080e7          	jalr	296(ra) # 800022c2 <sleep>
    800041a2:	bfd1                	j	80004176 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800041a4:	0001e517          	auipc	a0,0x1e
    800041a8:	b6450513          	addi	a0,a0,-1180 # 80021d08 <log>
    800041ac:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800041ae:	ffffd097          	auipc	ra,0xffffd
    800041b2:	b16080e7          	jalr	-1258(ra) # 80000cc4 <release>
      break;
    }
  }
}
    800041b6:	60e2                	ld	ra,24(sp)
    800041b8:	6442                	ld	s0,16(sp)
    800041ba:	64a2                	ld	s1,8(sp)
    800041bc:	6902                	ld	s2,0(sp)
    800041be:	6105                	addi	sp,sp,32
    800041c0:	8082                	ret

00000000800041c2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800041c2:	7139                	addi	sp,sp,-64
    800041c4:	fc06                	sd	ra,56(sp)
    800041c6:	f822                	sd	s0,48(sp)
    800041c8:	f426                	sd	s1,40(sp)
    800041ca:	f04a                	sd	s2,32(sp)
    800041cc:	ec4e                	sd	s3,24(sp)
    800041ce:	e852                	sd	s4,16(sp)
    800041d0:	e456                	sd	s5,8(sp)
    800041d2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800041d4:	0001e497          	auipc	s1,0x1e
    800041d8:	b3448493          	addi	s1,s1,-1228 # 80021d08 <log>
    800041dc:	8526                	mv	a0,s1
    800041de:	ffffd097          	auipc	ra,0xffffd
    800041e2:	a32080e7          	jalr	-1486(ra) # 80000c10 <acquire>
  log.outstanding -= 1;
    800041e6:	509c                	lw	a5,32(s1)
    800041e8:	37fd                	addiw	a5,a5,-1
    800041ea:	0007891b          	sext.w	s2,a5
    800041ee:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800041f0:	50dc                	lw	a5,36(s1)
    800041f2:	efb9                	bnez	a5,80004250 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800041f4:	06091663          	bnez	s2,80004260 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800041f8:	0001e497          	auipc	s1,0x1e
    800041fc:	b1048493          	addi	s1,s1,-1264 # 80021d08 <log>
    80004200:	4785                	li	a5,1
    80004202:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004204:	8526                	mv	a0,s1
    80004206:	ffffd097          	auipc	ra,0xffffd
    8000420a:	abe080e7          	jalr	-1346(ra) # 80000cc4 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000420e:	54dc                	lw	a5,44(s1)
    80004210:	06f04763          	bgtz	a5,8000427e <end_op+0xbc>
    acquire(&log.lock);
    80004214:	0001e497          	auipc	s1,0x1e
    80004218:	af448493          	addi	s1,s1,-1292 # 80021d08 <log>
    8000421c:	8526                	mv	a0,s1
    8000421e:	ffffd097          	auipc	ra,0xffffd
    80004222:	9f2080e7          	jalr	-1550(ra) # 80000c10 <acquire>
    log.committing = 0;
    80004226:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000422a:	8526                	mv	a0,s1
    8000422c:	ffffe097          	auipc	ra,0xffffe
    80004230:	21c080e7          	jalr	540(ra) # 80002448 <wakeup>
    release(&log.lock);
    80004234:	8526                	mv	a0,s1
    80004236:	ffffd097          	auipc	ra,0xffffd
    8000423a:	a8e080e7          	jalr	-1394(ra) # 80000cc4 <release>
}
    8000423e:	70e2                	ld	ra,56(sp)
    80004240:	7442                	ld	s0,48(sp)
    80004242:	74a2                	ld	s1,40(sp)
    80004244:	7902                	ld	s2,32(sp)
    80004246:	69e2                	ld	s3,24(sp)
    80004248:	6a42                	ld	s4,16(sp)
    8000424a:	6aa2                	ld	s5,8(sp)
    8000424c:	6121                	addi	sp,sp,64
    8000424e:	8082                	ret
    panic("log.committing");
    80004250:	00004517          	auipc	a0,0x4
    80004254:	3a050513          	addi	a0,a0,928 # 800085f0 <syscalls+0x1e0>
    80004258:	ffffc097          	auipc	ra,0xffffc
    8000425c:	2f0080e7          	jalr	752(ra) # 80000548 <panic>
    wakeup(&log);
    80004260:	0001e497          	auipc	s1,0x1e
    80004264:	aa848493          	addi	s1,s1,-1368 # 80021d08 <log>
    80004268:	8526                	mv	a0,s1
    8000426a:	ffffe097          	auipc	ra,0xffffe
    8000426e:	1de080e7          	jalr	478(ra) # 80002448 <wakeup>
  release(&log.lock);
    80004272:	8526                	mv	a0,s1
    80004274:	ffffd097          	auipc	ra,0xffffd
    80004278:	a50080e7          	jalr	-1456(ra) # 80000cc4 <release>
  if(do_commit){
    8000427c:	b7c9                	j	8000423e <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000427e:	0001ea97          	auipc	s5,0x1e
    80004282:	abaa8a93          	addi	s5,s5,-1350 # 80021d38 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004286:	0001ea17          	auipc	s4,0x1e
    8000428a:	a82a0a13          	addi	s4,s4,-1406 # 80021d08 <log>
    8000428e:	018a2583          	lw	a1,24(s4)
    80004292:	012585bb          	addw	a1,a1,s2
    80004296:	2585                	addiw	a1,a1,1
    80004298:	028a2503          	lw	a0,40(s4)
    8000429c:	fffff097          	auipc	ra,0xfffff
    800042a0:	ce4080e7          	jalr	-796(ra) # 80002f80 <bread>
    800042a4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800042a6:	000aa583          	lw	a1,0(s5)
    800042aa:	028a2503          	lw	a0,40(s4)
    800042ae:	fffff097          	auipc	ra,0xfffff
    800042b2:	cd2080e7          	jalr	-814(ra) # 80002f80 <bread>
    800042b6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800042b8:	40000613          	li	a2,1024
    800042bc:	05850593          	addi	a1,a0,88
    800042c0:	05848513          	addi	a0,s1,88
    800042c4:	ffffd097          	auipc	ra,0xffffd
    800042c8:	aa8080e7          	jalr	-1368(ra) # 80000d6c <memmove>
    bwrite(to);  // write the log
    800042cc:	8526                	mv	a0,s1
    800042ce:	fffff097          	auipc	ra,0xfffff
    800042d2:	da4080e7          	jalr	-604(ra) # 80003072 <bwrite>
    brelse(from);
    800042d6:	854e                	mv	a0,s3
    800042d8:	fffff097          	auipc	ra,0xfffff
    800042dc:	dd8080e7          	jalr	-552(ra) # 800030b0 <brelse>
    brelse(to);
    800042e0:	8526                	mv	a0,s1
    800042e2:	fffff097          	auipc	ra,0xfffff
    800042e6:	dce080e7          	jalr	-562(ra) # 800030b0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800042ea:	2905                	addiw	s2,s2,1
    800042ec:	0a91                	addi	s5,s5,4
    800042ee:	02ca2783          	lw	a5,44(s4)
    800042f2:	f8f94ee3          	blt	s2,a5,8000428e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800042f6:	00000097          	auipc	ra,0x0
    800042fa:	c7a080e7          	jalr	-902(ra) # 80003f70 <write_head>
    install_trans(); // Now install writes to home locations
    800042fe:	00000097          	auipc	ra,0x0
    80004302:	cec080e7          	jalr	-788(ra) # 80003fea <install_trans>
    log.lh.n = 0;
    80004306:	0001e797          	auipc	a5,0x1e
    8000430a:	a207a723          	sw	zero,-1490(a5) # 80021d34 <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000430e:	00000097          	auipc	ra,0x0
    80004312:	c62080e7          	jalr	-926(ra) # 80003f70 <write_head>
    80004316:	bdfd                	j	80004214 <end_op+0x52>

0000000080004318 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004318:	1101                	addi	sp,sp,-32
    8000431a:	ec06                	sd	ra,24(sp)
    8000431c:	e822                	sd	s0,16(sp)
    8000431e:	e426                	sd	s1,8(sp)
    80004320:	e04a                	sd	s2,0(sp)
    80004322:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004324:	0001e717          	auipc	a4,0x1e
    80004328:	a1072703          	lw	a4,-1520(a4) # 80021d34 <log+0x2c>
    8000432c:	47f5                	li	a5,29
    8000432e:	08e7c063          	blt	a5,a4,800043ae <log_write+0x96>
    80004332:	84aa                	mv	s1,a0
    80004334:	0001e797          	auipc	a5,0x1e
    80004338:	9f07a783          	lw	a5,-1552(a5) # 80021d24 <log+0x1c>
    8000433c:	37fd                	addiw	a5,a5,-1
    8000433e:	06f75863          	bge	a4,a5,800043ae <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004342:	0001e797          	auipc	a5,0x1e
    80004346:	9e67a783          	lw	a5,-1562(a5) # 80021d28 <log+0x20>
    8000434a:	06f05a63          	blez	a5,800043be <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    8000434e:	0001e917          	auipc	s2,0x1e
    80004352:	9ba90913          	addi	s2,s2,-1606 # 80021d08 <log>
    80004356:	854a                	mv	a0,s2
    80004358:	ffffd097          	auipc	ra,0xffffd
    8000435c:	8b8080e7          	jalr	-1864(ra) # 80000c10 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    80004360:	02c92603          	lw	a2,44(s2)
    80004364:	06c05563          	blez	a2,800043ce <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004368:	44cc                	lw	a1,12(s1)
    8000436a:	0001e717          	auipc	a4,0x1e
    8000436e:	9ce70713          	addi	a4,a4,-1586 # 80021d38 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004372:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004374:	4314                	lw	a3,0(a4)
    80004376:	04b68d63          	beq	a3,a1,800043d0 <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    8000437a:	2785                	addiw	a5,a5,1
    8000437c:	0711                	addi	a4,a4,4
    8000437e:	fec79be3          	bne	a5,a2,80004374 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004382:	0621                	addi	a2,a2,8
    80004384:	060a                	slli	a2,a2,0x2
    80004386:	0001e797          	auipc	a5,0x1e
    8000438a:	98278793          	addi	a5,a5,-1662 # 80021d08 <log>
    8000438e:	963e                	add	a2,a2,a5
    80004390:	44dc                	lw	a5,12(s1)
    80004392:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004394:	8526                	mv	a0,s1
    80004396:	fffff097          	auipc	ra,0xfffff
    8000439a:	db8080e7          	jalr	-584(ra) # 8000314e <bpin>
    log.lh.n++;
    8000439e:	0001e717          	auipc	a4,0x1e
    800043a2:	96a70713          	addi	a4,a4,-1686 # 80021d08 <log>
    800043a6:	575c                	lw	a5,44(a4)
    800043a8:	2785                	addiw	a5,a5,1
    800043aa:	d75c                	sw	a5,44(a4)
    800043ac:	a83d                	j	800043ea <log_write+0xd2>
    panic("too big a transaction");
    800043ae:	00004517          	auipc	a0,0x4
    800043b2:	25250513          	addi	a0,a0,594 # 80008600 <syscalls+0x1f0>
    800043b6:	ffffc097          	auipc	ra,0xffffc
    800043ba:	192080e7          	jalr	402(ra) # 80000548 <panic>
    panic("log_write outside of trans");
    800043be:	00004517          	auipc	a0,0x4
    800043c2:	25a50513          	addi	a0,a0,602 # 80008618 <syscalls+0x208>
    800043c6:	ffffc097          	auipc	ra,0xffffc
    800043ca:	182080e7          	jalr	386(ra) # 80000548 <panic>
  for (i = 0; i < log.lh.n; i++) {
    800043ce:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    800043d0:	00878713          	addi	a4,a5,8
    800043d4:	00271693          	slli	a3,a4,0x2
    800043d8:	0001e717          	auipc	a4,0x1e
    800043dc:	93070713          	addi	a4,a4,-1744 # 80021d08 <log>
    800043e0:	9736                	add	a4,a4,a3
    800043e2:	44d4                	lw	a3,12(s1)
    800043e4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800043e6:	faf607e3          	beq	a2,a5,80004394 <log_write+0x7c>
  }
  release(&log.lock);
    800043ea:	0001e517          	auipc	a0,0x1e
    800043ee:	91e50513          	addi	a0,a0,-1762 # 80021d08 <log>
    800043f2:	ffffd097          	auipc	ra,0xffffd
    800043f6:	8d2080e7          	jalr	-1838(ra) # 80000cc4 <release>
}
    800043fa:	60e2                	ld	ra,24(sp)
    800043fc:	6442                	ld	s0,16(sp)
    800043fe:	64a2                	ld	s1,8(sp)
    80004400:	6902                	ld	s2,0(sp)
    80004402:	6105                	addi	sp,sp,32
    80004404:	8082                	ret

0000000080004406 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004406:	1101                	addi	sp,sp,-32
    80004408:	ec06                	sd	ra,24(sp)
    8000440a:	e822                	sd	s0,16(sp)
    8000440c:	e426                	sd	s1,8(sp)
    8000440e:	e04a                	sd	s2,0(sp)
    80004410:	1000                	addi	s0,sp,32
    80004412:	84aa                	mv	s1,a0
    80004414:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004416:	00004597          	auipc	a1,0x4
    8000441a:	22258593          	addi	a1,a1,546 # 80008638 <syscalls+0x228>
    8000441e:	0521                	addi	a0,a0,8
    80004420:	ffffc097          	auipc	ra,0xffffc
    80004424:	760080e7          	jalr	1888(ra) # 80000b80 <initlock>
  lk->name = name;
    80004428:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000442c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004430:	0204a423          	sw	zero,40(s1)
}
    80004434:	60e2                	ld	ra,24(sp)
    80004436:	6442                	ld	s0,16(sp)
    80004438:	64a2                	ld	s1,8(sp)
    8000443a:	6902                	ld	s2,0(sp)
    8000443c:	6105                	addi	sp,sp,32
    8000443e:	8082                	ret

0000000080004440 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004440:	1101                	addi	sp,sp,-32
    80004442:	ec06                	sd	ra,24(sp)
    80004444:	e822                	sd	s0,16(sp)
    80004446:	e426                	sd	s1,8(sp)
    80004448:	e04a                	sd	s2,0(sp)
    8000444a:	1000                	addi	s0,sp,32
    8000444c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000444e:	00850913          	addi	s2,a0,8
    80004452:	854a                	mv	a0,s2
    80004454:	ffffc097          	auipc	ra,0xffffc
    80004458:	7bc080e7          	jalr	1980(ra) # 80000c10 <acquire>
  while (lk->locked) {
    8000445c:	409c                	lw	a5,0(s1)
    8000445e:	cb89                	beqz	a5,80004470 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004460:	85ca                	mv	a1,s2
    80004462:	8526                	mv	a0,s1
    80004464:	ffffe097          	auipc	ra,0xffffe
    80004468:	e5e080e7          	jalr	-418(ra) # 800022c2 <sleep>
  while (lk->locked) {
    8000446c:	409c                	lw	a5,0(s1)
    8000446e:	fbed                	bnez	a5,80004460 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004470:	4785                	li	a5,1
    80004472:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004474:	ffffd097          	auipc	ra,0xffffd
    80004478:	616080e7          	jalr	1558(ra) # 80001a8a <myproc>
    8000447c:	5d1c                	lw	a5,56(a0)
    8000447e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004480:	854a                	mv	a0,s2
    80004482:	ffffd097          	auipc	ra,0xffffd
    80004486:	842080e7          	jalr	-1982(ra) # 80000cc4 <release>
}
    8000448a:	60e2                	ld	ra,24(sp)
    8000448c:	6442                	ld	s0,16(sp)
    8000448e:	64a2                	ld	s1,8(sp)
    80004490:	6902                	ld	s2,0(sp)
    80004492:	6105                	addi	sp,sp,32
    80004494:	8082                	ret

0000000080004496 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004496:	1101                	addi	sp,sp,-32
    80004498:	ec06                	sd	ra,24(sp)
    8000449a:	e822                	sd	s0,16(sp)
    8000449c:	e426                	sd	s1,8(sp)
    8000449e:	e04a                	sd	s2,0(sp)
    800044a0:	1000                	addi	s0,sp,32
    800044a2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800044a4:	00850913          	addi	s2,a0,8
    800044a8:	854a                	mv	a0,s2
    800044aa:	ffffc097          	auipc	ra,0xffffc
    800044ae:	766080e7          	jalr	1894(ra) # 80000c10 <acquire>
  lk->locked = 0;
    800044b2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800044b6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800044ba:	8526                	mv	a0,s1
    800044bc:	ffffe097          	auipc	ra,0xffffe
    800044c0:	f8c080e7          	jalr	-116(ra) # 80002448 <wakeup>
  release(&lk->lk);
    800044c4:	854a                	mv	a0,s2
    800044c6:	ffffc097          	auipc	ra,0xffffc
    800044ca:	7fe080e7          	jalr	2046(ra) # 80000cc4 <release>
}
    800044ce:	60e2                	ld	ra,24(sp)
    800044d0:	6442                	ld	s0,16(sp)
    800044d2:	64a2                	ld	s1,8(sp)
    800044d4:	6902                	ld	s2,0(sp)
    800044d6:	6105                	addi	sp,sp,32
    800044d8:	8082                	ret

00000000800044da <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800044da:	7179                	addi	sp,sp,-48
    800044dc:	f406                	sd	ra,40(sp)
    800044de:	f022                	sd	s0,32(sp)
    800044e0:	ec26                	sd	s1,24(sp)
    800044e2:	e84a                	sd	s2,16(sp)
    800044e4:	e44e                	sd	s3,8(sp)
    800044e6:	1800                	addi	s0,sp,48
    800044e8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800044ea:	00850913          	addi	s2,a0,8
    800044ee:	854a                	mv	a0,s2
    800044f0:	ffffc097          	auipc	ra,0xffffc
    800044f4:	720080e7          	jalr	1824(ra) # 80000c10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800044f8:	409c                	lw	a5,0(s1)
    800044fa:	ef99                	bnez	a5,80004518 <holdingsleep+0x3e>
    800044fc:	4481                	li	s1,0
  release(&lk->lk);
    800044fe:	854a                	mv	a0,s2
    80004500:	ffffc097          	auipc	ra,0xffffc
    80004504:	7c4080e7          	jalr	1988(ra) # 80000cc4 <release>
  return r;
}
    80004508:	8526                	mv	a0,s1
    8000450a:	70a2                	ld	ra,40(sp)
    8000450c:	7402                	ld	s0,32(sp)
    8000450e:	64e2                	ld	s1,24(sp)
    80004510:	6942                	ld	s2,16(sp)
    80004512:	69a2                	ld	s3,8(sp)
    80004514:	6145                	addi	sp,sp,48
    80004516:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004518:	0284a983          	lw	s3,40(s1)
    8000451c:	ffffd097          	auipc	ra,0xffffd
    80004520:	56e080e7          	jalr	1390(ra) # 80001a8a <myproc>
    80004524:	5d04                	lw	s1,56(a0)
    80004526:	413484b3          	sub	s1,s1,s3
    8000452a:	0014b493          	seqz	s1,s1
    8000452e:	bfc1                	j	800044fe <holdingsleep+0x24>

0000000080004530 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004530:	1141                	addi	sp,sp,-16
    80004532:	e406                	sd	ra,8(sp)
    80004534:	e022                	sd	s0,0(sp)
    80004536:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004538:	00004597          	auipc	a1,0x4
    8000453c:	11058593          	addi	a1,a1,272 # 80008648 <syscalls+0x238>
    80004540:	0001e517          	auipc	a0,0x1e
    80004544:	91050513          	addi	a0,a0,-1776 # 80021e50 <ftable>
    80004548:	ffffc097          	auipc	ra,0xffffc
    8000454c:	638080e7          	jalr	1592(ra) # 80000b80 <initlock>
}
    80004550:	60a2                	ld	ra,8(sp)
    80004552:	6402                	ld	s0,0(sp)
    80004554:	0141                	addi	sp,sp,16
    80004556:	8082                	ret

0000000080004558 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004558:	1101                	addi	sp,sp,-32
    8000455a:	ec06                	sd	ra,24(sp)
    8000455c:	e822                	sd	s0,16(sp)
    8000455e:	e426                	sd	s1,8(sp)
    80004560:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004562:	0001e517          	auipc	a0,0x1e
    80004566:	8ee50513          	addi	a0,a0,-1810 # 80021e50 <ftable>
    8000456a:	ffffc097          	auipc	ra,0xffffc
    8000456e:	6a6080e7          	jalr	1702(ra) # 80000c10 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004572:	0001e497          	auipc	s1,0x1e
    80004576:	8f648493          	addi	s1,s1,-1802 # 80021e68 <ftable+0x18>
    8000457a:	0001f717          	auipc	a4,0x1f
    8000457e:	88e70713          	addi	a4,a4,-1906 # 80022e08 <ftable+0xfb8>
    if(f->ref == 0){
    80004582:	40dc                	lw	a5,4(s1)
    80004584:	cf99                	beqz	a5,800045a2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004586:	02848493          	addi	s1,s1,40
    8000458a:	fee49ce3          	bne	s1,a4,80004582 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000458e:	0001e517          	auipc	a0,0x1e
    80004592:	8c250513          	addi	a0,a0,-1854 # 80021e50 <ftable>
    80004596:	ffffc097          	auipc	ra,0xffffc
    8000459a:	72e080e7          	jalr	1838(ra) # 80000cc4 <release>
  return 0;
    8000459e:	4481                	li	s1,0
    800045a0:	a819                	j	800045b6 <filealloc+0x5e>
      f->ref = 1;
    800045a2:	4785                	li	a5,1
    800045a4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800045a6:	0001e517          	auipc	a0,0x1e
    800045aa:	8aa50513          	addi	a0,a0,-1878 # 80021e50 <ftable>
    800045ae:	ffffc097          	auipc	ra,0xffffc
    800045b2:	716080e7          	jalr	1814(ra) # 80000cc4 <release>
}
    800045b6:	8526                	mv	a0,s1
    800045b8:	60e2                	ld	ra,24(sp)
    800045ba:	6442                	ld	s0,16(sp)
    800045bc:	64a2                	ld	s1,8(sp)
    800045be:	6105                	addi	sp,sp,32
    800045c0:	8082                	ret

00000000800045c2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800045c2:	1101                	addi	sp,sp,-32
    800045c4:	ec06                	sd	ra,24(sp)
    800045c6:	e822                	sd	s0,16(sp)
    800045c8:	e426                	sd	s1,8(sp)
    800045ca:	1000                	addi	s0,sp,32
    800045cc:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800045ce:	0001e517          	auipc	a0,0x1e
    800045d2:	88250513          	addi	a0,a0,-1918 # 80021e50 <ftable>
    800045d6:	ffffc097          	auipc	ra,0xffffc
    800045da:	63a080e7          	jalr	1594(ra) # 80000c10 <acquire>
  if(f->ref < 1)
    800045de:	40dc                	lw	a5,4(s1)
    800045e0:	02f05263          	blez	a5,80004604 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800045e4:	2785                	addiw	a5,a5,1
    800045e6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800045e8:	0001e517          	auipc	a0,0x1e
    800045ec:	86850513          	addi	a0,a0,-1944 # 80021e50 <ftable>
    800045f0:	ffffc097          	auipc	ra,0xffffc
    800045f4:	6d4080e7          	jalr	1748(ra) # 80000cc4 <release>
  return f;
}
    800045f8:	8526                	mv	a0,s1
    800045fa:	60e2                	ld	ra,24(sp)
    800045fc:	6442                	ld	s0,16(sp)
    800045fe:	64a2                	ld	s1,8(sp)
    80004600:	6105                	addi	sp,sp,32
    80004602:	8082                	ret
    panic("filedup");
    80004604:	00004517          	auipc	a0,0x4
    80004608:	04c50513          	addi	a0,a0,76 # 80008650 <syscalls+0x240>
    8000460c:	ffffc097          	auipc	ra,0xffffc
    80004610:	f3c080e7          	jalr	-196(ra) # 80000548 <panic>

0000000080004614 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004614:	7139                	addi	sp,sp,-64
    80004616:	fc06                	sd	ra,56(sp)
    80004618:	f822                	sd	s0,48(sp)
    8000461a:	f426                	sd	s1,40(sp)
    8000461c:	f04a                	sd	s2,32(sp)
    8000461e:	ec4e                	sd	s3,24(sp)
    80004620:	e852                	sd	s4,16(sp)
    80004622:	e456                	sd	s5,8(sp)
    80004624:	0080                	addi	s0,sp,64
    80004626:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004628:	0001e517          	auipc	a0,0x1e
    8000462c:	82850513          	addi	a0,a0,-2008 # 80021e50 <ftable>
    80004630:	ffffc097          	auipc	ra,0xffffc
    80004634:	5e0080e7          	jalr	1504(ra) # 80000c10 <acquire>
  if(f->ref < 1)
    80004638:	40dc                	lw	a5,4(s1)
    8000463a:	06f05163          	blez	a5,8000469c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000463e:	37fd                	addiw	a5,a5,-1
    80004640:	0007871b          	sext.w	a4,a5
    80004644:	c0dc                	sw	a5,4(s1)
    80004646:	06e04363          	bgtz	a4,800046ac <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000464a:	0004a903          	lw	s2,0(s1)
    8000464e:	0094ca83          	lbu	s5,9(s1)
    80004652:	0104ba03          	ld	s4,16(s1)
    80004656:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000465a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000465e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004662:	0001d517          	auipc	a0,0x1d
    80004666:	7ee50513          	addi	a0,a0,2030 # 80021e50 <ftable>
    8000466a:	ffffc097          	auipc	ra,0xffffc
    8000466e:	65a080e7          	jalr	1626(ra) # 80000cc4 <release>

  if(ff.type == FD_PIPE){
    80004672:	4785                	li	a5,1
    80004674:	04f90d63          	beq	s2,a5,800046ce <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004678:	3979                	addiw	s2,s2,-2
    8000467a:	4785                	li	a5,1
    8000467c:	0527e063          	bltu	a5,s2,800046bc <fileclose+0xa8>
    begin_op();
    80004680:	00000097          	auipc	ra,0x0
    80004684:	ac2080e7          	jalr	-1342(ra) # 80004142 <begin_op>
    iput(ff.ip);
    80004688:	854e                	mv	a0,s3
    8000468a:	fffff097          	auipc	ra,0xfffff
    8000468e:	2b2080e7          	jalr	690(ra) # 8000393c <iput>
    end_op();
    80004692:	00000097          	auipc	ra,0x0
    80004696:	b30080e7          	jalr	-1232(ra) # 800041c2 <end_op>
    8000469a:	a00d                	j	800046bc <fileclose+0xa8>
    panic("fileclose");
    8000469c:	00004517          	auipc	a0,0x4
    800046a0:	fbc50513          	addi	a0,a0,-68 # 80008658 <syscalls+0x248>
    800046a4:	ffffc097          	auipc	ra,0xffffc
    800046a8:	ea4080e7          	jalr	-348(ra) # 80000548 <panic>
    release(&ftable.lock);
    800046ac:	0001d517          	auipc	a0,0x1d
    800046b0:	7a450513          	addi	a0,a0,1956 # 80021e50 <ftable>
    800046b4:	ffffc097          	auipc	ra,0xffffc
    800046b8:	610080e7          	jalr	1552(ra) # 80000cc4 <release>
  }
}
    800046bc:	70e2                	ld	ra,56(sp)
    800046be:	7442                	ld	s0,48(sp)
    800046c0:	74a2                	ld	s1,40(sp)
    800046c2:	7902                	ld	s2,32(sp)
    800046c4:	69e2                	ld	s3,24(sp)
    800046c6:	6a42                	ld	s4,16(sp)
    800046c8:	6aa2                	ld	s5,8(sp)
    800046ca:	6121                	addi	sp,sp,64
    800046cc:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800046ce:	85d6                	mv	a1,s5
    800046d0:	8552                	mv	a0,s4
    800046d2:	00000097          	auipc	ra,0x0
    800046d6:	488080e7          	jalr	1160(ra) # 80004b5a <pipeclose>
    800046da:	b7cd                	j	800046bc <fileclose+0xa8>

00000000800046dc <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800046dc:	715d                	addi	sp,sp,-80
    800046de:	e486                	sd	ra,72(sp)
    800046e0:	e0a2                	sd	s0,64(sp)
    800046e2:	fc26                	sd	s1,56(sp)
    800046e4:	f84a                	sd	s2,48(sp)
    800046e6:	f44e                	sd	s3,40(sp)
    800046e8:	0880                	addi	s0,sp,80
    800046ea:	84aa                	mv	s1,a0
    800046ec:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800046ee:	ffffd097          	auipc	ra,0xffffd
    800046f2:	39c080e7          	jalr	924(ra) # 80001a8a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800046f6:	409c                	lw	a5,0(s1)
    800046f8:	37f9                	addiw	a5,a5,-2
    800046fa:	4705                	li	a4,1
    800046fc:	04f76763          	bltu	a4,a5,8000474a <filestat+0x6e>
    80004700:	892a                	mv	s2,a0
    ilock(f->ip);
    80004702:	6c88                	ld	a0,24(s1)
    80004704:	fffff097          	auipc	ra,0xfffff
    80004708:	07e080e7          	jalr	126(ra) # 80003782 <ilock>
    stati(f->ip, &st);
    8000470c:	fb840593          	addi	a1,s0,-72
    80004710:	6c88                	ld	a0,24(s1)
    80004712:	fffff097          	auipc	ra,0xfffff
    80004716:	2fa080e7          	jalr	762(ra) # 80003a0c <stati>
    iunlock(f->ip);
    8000471a:	6c88                	ld	a0,24(s1)
    8000471c:	fffff097          	auipc	ra,0xfffff
    80004720:	128080e7          	jalr	296(ra) # 80003844 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004724:	46e1                	li	a3,24
    80004726:	fb840613          	addi	a2,s0,-72
    8000472a:	85ce                	mv	a1,s3
    8000472c:	06093503          	ld	a0,96(s2)
    80004730:	ffffd097          	auipc	ra,0xffffd
    80004734:	01a080e7          	jalr	26(ra) # 8000174a <copyout>
    80004738:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000473c:	60a6                	ld	ra,72(sp)
    8000473e:	6406                	ld	s0,64(sp)
    80004740:	74e2                	ld	s1,56(sp)
    80004742:	7942                	ld	s2,48(sp)
    80004744:	79a2                	ld	s3,40(sp)
    80004746:	6161                	addi	sp,sp,80
    80004748:	8082                	ret
  return -1;
    8000474a:	557d                	li	a0,-1
    8000474c:	bfc5                	j	8000473c <filestat+0x60>

000000008000474e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000474e:	7179                	addi	sp,sp,-48
    80004750:	f406                	sd	ra,40(sp)
    80004752:	f022                	sd	s0,32(sp)
    80004754:	ec26                	sd	s1,24(sp)
    80004756:	e84a                	sd	s2,16(sp)
    80004758:	e44e                	sd	s3,8(sp)
    8000475a:	e052                	sd	s4,0(sp)
    8000475c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000475e:	00854783          	lbu	a5,8(a0)
    80004762:	12078563          	beqz	a5,8000488c <fileread+0x13e>
    80004766:	84aa                	mv	s1,a0
    80004768:	892e                	mv	s2,a1
    8000476a:	89b2                	mv	s3,a2
    return -1;
  if(addr > myproc()->sz)
    8000476c:	ffffd097          	auipc	ra,0xffffd
    80004770:	31e080e7          	jalr	798(ra) # 80001a8a <myproc>
    80004774:	693c                	ld	a5,80(a0)
    80004776:	1127ed63          	bltu	a5,s2,80004890 <fileread+0x142>
      return -1;
  if(walkaddr(myproc()->pagetable,addr) == 0){
    8000477a:	ffffd097          	auipc	ra,0xffffd
    8000477e:	310080e7          	jalr	784(ra) # 80001a8a <myproc>
    80004782:	85ca                	mv	a1,s2
    80004784:	7128                	ld	a0,96(a0)
    80004786:	ffffd097          	auipc	ra,0xffffd
    8000478a:	9ca080e7          	jalr	-1590(ra) # 80001150 <walkaddr>
    8000478e:	cd29                	beqz	a0,800047e8 <fileread+0x9a>
          return -1;
      }
      if(addr > myproc()->maxva)
          myproc()->maxva = addr + PGSIZE;
  }
  if(f->type == FD_PIPE){
    80004790:	409c                	lw	a5,0(s1)
    80004792:	4705                	li	a4,1
    80004794:	0ae78563          	beq	a5,a4,8000483e <fileread+0xf0>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004798:	470d                	li	a4,3
    8000479a:	0ae78b63          	beq	a5,a4,80004850 <fileread+0x102>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000479e:	4709                	li	a4,2
    800047a0:	0ce79e63          	bne	a5,a4,8000487c <fileread+0x12e>
    ilock(f->ip);
    800047a4:	6c88                	ld	a0,24(s1)
    800047a6:	fffff097          	auipc	ra,0xfffff
    800047aa:	fdc080e7          	jalr	-36(ra) # 80003782 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800047ae:	874e                	mv	a4,s3
    800047b0:	5094                	lw	a3,32(s1)
    800047b2:	864a                	mv	a2,s2
    800047b4:	4585                	li	a1,1
    800047b6:	6c88                	ld	a0,24(s1)
    800047b8:	fffff097          	auipc	ra,0xfffff
    800047bc:	27e080e7          	jalr	638(ra) # 80003a36 <readi>
    800047c0:	892a                	mv	s2,a0
    800047c2:	00a05563          	blez	a0,800047cc <fileread+0x7e>
      f->off += r;
    800047c6:	509c                	lw	a5,32(s1)
    800047c8:	9fa9                	addw	a5,a5,a0
    800047ca:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800047cc:	6c88                	ld	a0,24(s1)
    800047ce:	fffff097          	auipc	ra,0xfffff
    800047d2:	076080e7          	jalr	118(ra) # 80003844 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800047d6:	854a                	mv	a0,s2
    800047d8:	70a2                	ld	ra,40(sp)
    800047da:	7402                	ld	s0,32(sp)
    800047dc:	64e2                	ld	s1,24(sp)
    800047de:	6942                	ld	s2,16(sp)
    800047e0:	69a2                	ld	s3,8(sp)
    800047e2:	6a02                	ld	s4,0(sp)
    800047e4:	6145                	addi	sp,sp,48
    800047e6:	8082                	ret
      char* mem = kalloc();
    800047e8:	ffffc097          	auipc	ra,0xffffc
    800047ec:	338080e7          	jalr	824(ra) # 80000b20 <kalloc>
    800047f0:	8a2a                	mv	s4,a0
      if(mappages(myproc()->pagetable,PGROUNDDOWN(addr),PGSIZE,(uint64)mem,PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800047f2:	ffffd097          	auipc	ra,0xffffd
    800047f6:	298080e7          	jalr	664(ra) # 80001a8a <myproc>
    800047fa:	4779                	li	a4,30
    800047fc:	86d2                	mv	a3,s4
    800047fe:	6605                	lui	a2,0x1
    80004800:	75fd                	lui	a1,0xfffff
    80004802:	00b975b3          	and	a1,s2,a1
    80004806:	7128                	ld	a0,96(a0)
    80004808:	ffffd097          	auipc	ra,0xffffd
    8000480c:	9e8080e7          	jalr	-1560(ra) # 800011f0 <mappages>
    80004810:	e105                	bnez	a0,80004830 <fileread+0xe2>
      if(addr > myproc()->maxva)
    80004812:	ffffd097          	auipc	ra,0xffffd
    80004816:	278080e7          	jalr	632(ra) # 80001a8a <myproc>
    8000481a:	6d3c                	ld	a5,88(a0)
    8000481c:	f727fae3          	bgeu	a5,s2,80004790 <fileread+0x42>
          myproc()->maxva = addr + PGSIZE;
    80004820:	ffffd097          	auipc	ra,0xffffd
    80004824:	26a080e7          	jalr	618(ra) # 80001a8a <myproc>
    80004828:	6785                	lui	a5,0x1
    8000482a:	97ca                	add	a5,a5,s2
    8000482c:	ed3c                	sd	a5,88(a0)
    8000482e:	b78d                	j	80004790 <fileread+0x42>
          kfree(mem);
    80004830:	8552                	mv	a0,s4
    80004832:	ffffc097          	auipc	ra,0xffffc
    80004836:	1f2080e7          	jalr	498(ra) # 80000a24 <kfree>
          return -1;
    8000483a:	597d                	li	s2,-1
    8000483c:	bf69                	j	800047d6 <fileread+0x88>
    r = piperead(f->pipe, addr, n);
    8000483e:	864e                	mv	a2,s3
    80004840:	85ca                	mv	a1,s2
    80004842:	6888                	ld	a0,16(s1)
    80004844:	00000097          	auipc	ra,0x0
    80004848:	4aa080e7          	jalr	1194(ra) # 80004cee <piperead>
    8000484c:	892a                	mv	s2,a0
    8000484e:	b761                	j	800047d6 <fileread+0x88>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004850:	02449783          	lh	a5,36(s1)
    80004854:	03079693          	slli	a3,a5,0x30
    80004858:	92c1                	srli	a3,a3,0x30
    8000485a:	4725                	li	a4,9
    8000485c:	02d76c63          	bltu	a4,a3,80004894 <fileread+0x146>
    80004860:	0792                	slli	a5,a5,0x4
    80004862:	0001d717          	auipc	a4,0x1d
    80004866:	54e70713          	addi	a4,a4,1358 # 80021db0 <devsw>
    8000486a:	97ba                	add	a5,a5,a4
    8000486c:	639c                	ld	a5,0(a5)
    8000486e:	c78d                	beqz	a5,80004898 <fileread+0x14a>
    r = devsw[f->major].read(1, addr, n);
    80004870:	864e                	mv	a2,s3
    80004872:	85ca                	mv	a1,s2
    80004874:	4505                	li	a0,1
    80004876:	9782                	jalr	a5
    80004878:	892a                	mv	s2,a0
    8000487a:	bfb1                	j	800047d6 <fileread+0x88>
    panic("fileread");
    8000487c:	00004517          	auipc	a0,0x4
    80004880:	dec50513          	addi	a0,a0,-532 # 80008668 <syscalls+0x258>
    80004884:	ffffc097          	auipc	ra,0xffffc
    80004888:	cc4080e7          	jalr	-828(ra) # 80000548 <panic>
    return -1;
    8000488c:	597d                	li	s2,-1
    8000488e:	b7a1                	j	800047d6 <fileread+0x88>
      return -1;
    80004890:	597d                	li	s2,-1
    80004892:	b791                	j	800047d6 <fileread+0x88>
      return -1;
    80004894:	597d                	li	s2,-1
    80004896:	b781                	j	800047d6 <fileread+0x88>
    80004898:	597d                	li	s2,-1
    8000489a:	bf35                	j	800047d6 <fileread+0x88>

000000008000489c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000489c:	00954783          	lbu	a5,9(a0)
    800048a0:	1c078863          	beqz	a5,80004a70 <filewrite+0x1d4>
{
    800048a4:	715d                	addi	sp,sp,-80
    800048a6:	e486                	sd	ra,72(sp)
    800048a8:	e0a2                	sd	s0,64(sp)
    800048aa:	fc26                	sd	s1,56(sp)
    800048ac:	f84a                	sd	s2,48(sp)
    800048ae:	f44e                	sd	s3,40(sp)
    800048b0:	f052                	sd	s4,32(sp)
    800048b2:	ec56                	sd	s5,24(sp)
    800048b4:	e85a                	sd	s6,16(sp)
    800048b6:	e45e                	sd	s7,8(sp)
    800048b8:	e062                	sd	s8,0(sp)
    800048ba:	0880                	addi	s0,sp,80
    800048bc:	892a                	mv	s2,a0
    800048be:	8aae                	mv	s5,a1
    800048c0:	8a32                	mv	s4,a2
    return -1;
  if(addr > myproc()->sz)
    800048c2:	ffffd097          	auipc	ra,0xffffd
    800048c6:	1c8080e7          	jalr	456(ra) # 80001a8a <myproc>
    800048ca:	693c                	ld	a5,80(a0)
    800048cc:	1b57e463          	bltu	a5,s5,80004a74 <filewrite+0x1d8>
      return -1;
  if(walkaddr(myproc()->pagetable,addr) == 0){
    800048d0:	ffffd097          	auipc	ra,0xffffd
    800048d4:	1ba080e7          	jalr	442(ra) # 80001a8a <myproc>
    800048d8:	85d6                	mv	a1,s5
    800048da:	7128                	ld	a0,96(a0)
    800048dc:	ffffd097          	auipc	ra,0xffffd
    800048e0:	874080e7          	jalr	-1932(ra) # 80001150 <walkaddr>
    800048e4:	c515                	beqz	a0,80004910 <filewrite+0x74>
      }
      if(addr > myproc()->maxva)
          myproc()->maxva = addr + PGSIZE;

  }
  if(f->type == FD_PIPE){
    800048e6:	00092783          	lw	a5,0(s2)
    800048ea:	4705                	li	a4,1
    800048ec:	06e78d63          	beq	a5,a4,80004966 <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800048f0:	470d                	li	a4,3
    800048f2:	08e78363          	beq	a5,a4,80004978 <filewrite+0xdc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800048f6:	4709                	li	a4,2
    800048f8:	16e79463          	bne	a5,a4,80004a60 <filewrite+0x1c4>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800048fc:	15405e63          	blez	s4,80004a58 <filewrite+0x1bc>
    int i = 0;
    80004900:	4981                	li	s3,0
    80004902:	6b05                	lui	s6,0x1
    80004904:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004908:	6b85                	lui	s7,0x1
    8000490a:	c00b8b9b          	addiw	s7,s7,-1024
    8000490e:	a8d5                	j	80004a02 <filewrite+0x166>
      char* mem = kalloc();
    80004910:	ffffc097          	auipc	ra,0xffffc
    80004914:	210080e7          	jalr	528(ra) # 80000b20 <kalloc>
    80004918:	84aa                	mv	s1,a0
      if(mappages(myproc()->pagetable,PGROUNDDOWN(addr),PGSIZE,(uint64)mem,PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    8000491a:	ffffd097          	auipc	ra,0xffffd
    8000491e:	170080e7          	jalr	368(ra) # 80001a8a <myproc>
    80004922:	4779                	li	a4,30
    80004924:	86a6                	mv	a3,s1
    80004926:	6605                	lui	a2,0x1
    80004928:	75fd                	lui	a1,0xfffff
    8000492a:	00baf5b3          	and	a1,s5,a1
    8000492e:	7128                	ld	a0,96(a0)
    80004930:	ffffd097          	auipc	ra,0xffffd
    80004934:	8c0080e7          	jalr	-1856(ra) # 800011f0 <mappages>
    80004938:	e105                	bnez	a0,80004958 <filewrite+0xbc>
      if(addr > myproc()->maxva)
    8000493a:	ffffd097          	auipc	ra,0xffffd
    8000493e:	150080e7          	jalr	336(ra) # 80001a8a <myproc>
    80004942:	6d3c                	ld	a5,88(a0)
    80004944:	fb57f1e3          	bgeu	a5,s5,800048e6 <filewrite+0x4a>
          myproc()->maxva = addr + PGSIZE;
    80004948:	ffffd097          	auipc	ra,0xffffd
    8000494c:	142080e7          	jalr	322(ra) # 80001a8a <myproc>
    80004950:	6785                	lui	a5,0x1
    80004952:	97d6                	add	a5,a5,s5
    80004954:	ed3c                	sd	a5,88(a0)
    80004956:	bf41                	j	800048e6 <filewrite+0x4a>
          kfree(mem);
    80004958:	8526                	mv	a0,s1
    8000495a:	ffffc097          	auipc	ra,0xffffc
    8000495e:	0ca080e7          	jalr	202(ra) # 80000a24 <kfree>
          return -1;
    80004962:	557d                	li	a0,-1
    80004964:	a0f1                	j	80004a30 <filewrite+0x194>
    ret = pipewrite(f->pipe, addr, n);
    80004966:	8652                	mv	a2,s4
    80004968:	85d6                	mv	a1,s5
    8000496a:	01093503          	ld	a0,16(s2)
    8000496e:	00000097          	auipc	ra,0x0
    80004972:	25c080e7          	jalr	604(ra) # 80004bca <pipewrite>
    80004976:	a86d                	j	80004a30 <filewrite+0x194>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004978:	02491783          	lh	a5,36(s2)
    8000497c:	03079693          	slli	a3,a5,0x30
    80004980:	92c1                	srli	a3,a3,0x30
    80004982:	4725                	li	a4,9
    80004984:	0ed76a63          	bltu	a4,a3,80004a78 <filewrite+0x1dc>
    80004988:	0792                	slli	a5,a5,0x4
    8000498a:	0001d717          	auipc	a4,0x1d
    8000498e:	42670713          	addi	a4,a4,1062 # 80021db0 <devsw>
    80004992:	97ba                	add	a5,a5,a4
    80004994:	679c                	ld	a5,8(a5)
    80004996:	c3fd                	beqz	a5,80004a7c <filewrite+0x1e0>
    ret = devsw[f->major].write(1, addr, n);
    80004998:	8652                	mv	a2,s4
    8000499a:	85d6                	mv	a1,s5
    8000499c:	4505                	li	a0,1
    8000499e:	9782                	jalr	a5
    800049a0:	a841                	j	80004a30 <filewrite+0x194>
    800049a2:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    800049a6:	fffff097          	auipc	ra,0xfffff
    800049aa:	79c080e7          	jalr	1948(ra) # 80004142 <begin_op>
      ilock(f->ip);
    800049ae:	01893503          	ld	a0,24(s2)
    800049b2:	fffff097          	auipc	ra,0xfffff
    800049b6:	dd0080e7          	jalr	-560(ra) # 80003782 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800049ba:	8762                	mv	a4,s8
    800049bc:	02092683          	lw	a3,32(s2)
    800049c0:	01598633          	add	a2,s3,s5
    800049c4:	4585                	li	a1,1
    800049c6:	01893503          	ld	a0,24(s2)
    800049ca:	fffff097          	auipc	ra,0xfffff
    800049ce:	164080e7          	jalr	356(ra) # 80003b2e <writei>
    800049d2:	84aa                	mv	s1,a0
    800049d4:	02a05f63          	blez	a0,80004a12 <filewrite+0x176>
        f->off += r;
    800049d8:	02092783          	lw	a5,32(s2)
    800049dc:	9fa9                	addw	a5,a5,a0
    800049de:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800049e2:	01893503          	ld	a0,24(s2)
    800049e6:	fffff097          	auipc	ra,0xfffff
    800049ea:	e5e080e7          	jalr	-418(ra) # 80003844 <iunlock>
      end_op();
    800049ee:	fffff097          	auipc	ra,0xfffff
    800049f2:	7d4080e7          	jalr	2004(ra) # 800041c2 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    800049f6:	049c1963          	bne	s8,s1,80004a48 <filewrite+0x1ac>
        panic("short filewrite");
      i += r;
    800049fa:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800049fe:	0349d663          	bge	s3,s4,80004a2a <filewrite+0x18e>
      int n1 = n - i;
    80004a02:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004a06:	84be                	mv	s1,a5
    80004a08:	2781                	sext.w	a5,a5
    80004a0a:	f8fb5ce3          	bge	s6,a5,800049a2 <filewrite+0x106>
    80004a0e:	84de                	mv	s1,s7
    80004a10:	bf49                	j	800049a2 <filewrite+0x106>
      iunlock(f->ip);
    80004a12:	01893503          	ld	a0,24(s2)
    80004a16:	fffff097          	auipc	ra,0xfffff
    80004a1a:	e2e080e7          	jalr	-466(ra) # 80003844 <iunlock>
      end_op();
    80004a1e:	fffff097          	auipc	ra,0xfffff
    80004a22:	7a4080e7          	jalr	1956(ra) # 800041c2 <end_op>
      if(r < 0)
    80004a26:	fc04d8e3          	bgez	s1,800049f6 <filewrite+0x15a>
    }
    ret = (i == n ? n : -1);
    80004a2a:	8552                	mv	a0,s4
    80004a2c:	033a1863          	bne	s4,s3,80004a5c <filewrite+0x1c0>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004a30:	60a6                	ld	ra,72(sp)
    80004a32:	6406                	ld	s0,64(sp)
    80004a34:	74e2                	ld	s1,56(sp)
    80004a36:	7942                	ld	s2,48(sp)
    80004a38:	79a2                	ld	s3,40(sp)
    80004a3a:	7a02                	ld	s4,32(sp)
    80004a3c:	6ae2                	ld	s5,24(sp)
    80004a3e:	6b42                	ld	s6,16(sp)
    80004a40:	6ba2                	ld	s7,8(sp)
    80004a42:	6c02                	ld	s8,0(sp)
    80004a44:	6161                	addi	sp,sp,80
    80004a46:	8082                	ret
        panic("short filewrite");
    80004a48:	00004517          	auipc	a0,0x4
    80004a4c:	c3050513          	addi	a0,a0,-976 # 80008678 <syscalls+0x268>
    80004a50:	ffffc097          	auipc	ra,0xffffc
    80004a54:	af8080e7          	jalr	-1288(ra) # 80000548 <panic>
    int i = 0;
    80004a58:	4981                	li	s3,0
    80004a5a:	bfc1                	j	80004a2a <filewrite+0x18e>
    ret = (i == n ? n : -1);
    80004a5c:	557d                	li	a0,-1
    80004a5e:	bfc9                	j	80004a30 <filewrite+0x194>
    panic("filewrite");
    80004a60:	00004517          	auipc	a0,0x4
    80004a64:	c2850513          	addi	a0,a0,-984 # 80008688 <syscalls+0x278>
    80004a68:	ffffc097          	auipc	ra,0xffffc
    80004a6c:	ae0080e7          	jalr	-1312(ra) # 80000548 <panic>
    return -1;
    80004a70:	557d                	li	a0,-1
}
    80004a72:	8082                	ret
      return -1;
    80004a74:	557d                	li	a0,-1
    80004a76:	bf6d                	j	80004a30 <filewrite+0x194>
      return -1;
    80004a78:	557d                	li	a0,-1
    80004a7a:	bf5d                	j	80004a30 <filewrite+0x194>
    80004a7c:	557d                	li	a0,-1
    80004a7e:	bf4d                	j	80004a30 <filewrite+0x194>

0000000080004a80 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004a80:	7179                	addi	sp,sp,-48
    80004a82:	f406                	sd	ra,40(sp)
    80004a84:	f022                	sd	s0,32(sp)
    80004a86:	ec26                	sd	s1,24(sp)
    80004a88:	e84a                	sd	s2,16(sp)
    80004a8a:	e44e                	sd	s3,8(sp)
    80004a8c:	e052                	sd	s4,0(sp)
    80004a8e:	1800                	addi	s0,sp,48
    80004a90:	84aa                	mv	s1,a0
    80004a92:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004a94:	0005b023          	sd	zero,0(a1) # fffffffffffff000 <end+0xffffffff7ffd9000>
    80004a98:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004a9c:	00000097          	auipc	ra,0x0
    80004aa0:	abc080e7          	jalr	-1348(ra) # 80004558 <filealloc>
    80004aa4:	e088                	sd	a0,0(s1)
    80004aa6:	c551                	beqz	a0,80004b32 <pipealloc+0xb2>
    80004aa8:	00000097          	auipc	ra,0x0
    80004aac:	ab0080e7          	jalr	-1360(ra) # 80004558 <filealloc>
    80004ab0:	00aa3023          	sd	a0,0(s4)
    80004ab4:	c92d                	beqz	a0,80004b26 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004ab6:	ffffc097          	auipc	ra,0xffffc
    80004aba:	06a080e7          	jalr	106(ra) # 80000b20 <kalloc>
    80004abe:	892a                	mv	s2,a0
    80004ac0:	c125                	beqz	a0,80004b20 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004ac2:	4985                	li	s3,1
    80004ac4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004ac8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004acc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004ad0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004ad4:	00004597          	auipc	a1,0x4
    80004ad8:	bc458593          	addi	a1,a1,-1084 # 80008698 <syscalls+0x288>
    80004adc:	ffffc097          	auipc	ra,0xffffc
    80004ae0:	0a4080e7          	jalr	164(ra) # 80000b80 <initlock>
  (*f0)->type = FD_PIPE;
    80004ae4:	609c                	ld	a5,0(s1)
    80004ae6:	0137a023          	sw	s3,0(a5) # 1000 <_entry-0x7ffff000>
  (*f0)->readable = 1;
    80004aea:	609c                	ld	a5,0(s1)
    80004aec:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004af0:	609c                	ld	a5,0(s1)
    80004af2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004af6:	609c                	ld	a5,0(s1)
    80004af8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004afc:	000a3783          	ld	a5,0(s4)
    80004b00:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004b04:	000a3783          	ld	a5,0(s4)
    80004b08:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004b0c:	000a3783          	ld	a5,0(s4)
    80004b10:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004b14:	000a3783          	ld	a5,0(s4)
    80004b18:	0127b823          	sd	s2,16(a5)
  return 0;
    80004b1c:	4501                	li	a0,0
    80004b1e:	a025                	j	80004b46 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004b20:	6088                	ld	a0,0(s1)
    80004b22:	e501                	bnez	a0,80004b2a <pipealloc+0xaa>
    80004b24:	a039                	j	80004b32 <pipealloc+0xb2>
    80004b26:	6088                	ld	a0,0(s1)
    80004b28:	c51d                	beqz	a0,80004b56 <pipealloc+0xd6>
    fileclose(*f0);
    80004b2a:	00000097          	auipc	ra,0x0
    80004b2e:	aea080e7          	jalr	-1302(ra) # 80004614 <fileclose>
  if(*f1)
    80004b32:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004b36:	557d                	li	a0,-1
  if(*f1)
    80004b38:	c799                	beqz	a5,80004b46 <pipealloc+0xc6>
    fileclose(*f1);
    80004b3a:	853e                	mv	a0,a5
    80004b3c:	00000097          	auipc	ra,0x0
    80004b40:	ad8080e7          	jalr	-1320(ra) # 80004614 <fileclose>
  return -1;
    80004b44:	557d                	li	a0,-1
}
    80004b46:	70a2                	ld	ra,40(sp)
    80004b48:	7402                	ld	s0,32(sp)
    80004b4a:	64e2                	ld	s1,24(sp)
    80004b4c:	6942                	ld	s2,16(sp)
    80004b4e:	69a2                	ld	s3,8(sp)
    80004b50:	6a02                	ld	s4,0(sp)
    80004b52:	6145                	addi	sp,sp,48
    80004b54:	8082                	ret
  return -1;
    80004b56:	557d                	li	a0,-1
    80004b58:	b7fd                	j	80004b46 <pipealloc+0xc6>

0000000080004b5a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004b5a:	1101                	addi	sp,sp,-32
    80004b5c:	ec06                	sd	ra,24(sp)
    80004b5e:	e822                	sd	s0,16(sp)
    80004b60:	e426                	sd	s1,8(sp)
    80004b62:	e04a                	sd	s2,0(sp)
    80004b64:	1000                	addi	s0,sp,32
    80004b66:	84aa                	mv	s1,a0
    80004b68:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004b6a:	ffffc097          	auipc	ra,0xffffc
    80004b6e:	0a6080e7          	jalr	166(ra) # 80000c10 <acquire>
  if(writable){
    80004b72:	02090d63          	beqz	s2,80004bac <pipeclose+0x52>
    pi->writeopen = 0;
    80004b76:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004b7a:	21848513          	addi	a0,s1,536
    80004b7e:	ffffe097          	auipc	ra,0xffffe
    80004b82:	8ca080e7          	jalr	-1846(ra) # 80002448 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004b86:	2204b783          	ld	a5,544(s1)
    80004b8a:	eb95                	bnez	a5,80004bbe <pipeclose+0x64>
    release(&pi->lock);
    80004b8c:	8526                	mv	a0,s1
    80004b8e:	ffffc097          	auipc	ra,0xffffc
    80004b92:	136080e7          	jalr	310(ra) # 80000cc4 <release>
    kfree((char*)pi);
    80004b96:	8526                	mv	a0,s1
    80004b98:	ffffc097          	auipc	ra,0xffffc
    80004b9c:	e8c080e7          	jalr	-372(ra) # 80000a24 <kfree>
  } else
    release(&pi->lock);
}
    80004ba0:	60e2                	ld	ra,24(sp)
    80004ba2:	6442                	ld	s0,16(sp)
    80004ba4:	64a2                	ld	s1,8(sp)
    80004ba6:	6902                	ld	s2,0(sp)
    80004ba8:	6105                	addi	sp,sp,32
    80004baa:	8082                	ret
    pi->readopen = 0;
    80004bac:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004bb0:	21c48513          	addi	a0,s1,540
    80004bb4:	ffffe097          	auipc	ra,0xffffe
    80004bb8:	894080e7          	jalr	-1900(ra) # 80002448 <wakeup>
    80004bbc:	b7e9                	j	80004b86 <pipeclose+0x2c>
    release(&pi->lock);
    80004bbe:	8526                	mv	a0,s1
    80004bc0:	ffffc097          	auipc	ra,0xffffc
    80004bc4:	104080e7          	jalr	260(ra) # 80000cc4 <release>
}
    80004bc8:	bfe1                	j	80004ba0 <pipeclose+0x46>

0000000080004bca <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004bca:	7119                	addi	sp,sp,-128
    80004bcc:	fc86                	sd	ra,120(sp)
    80004bce:	f8a2                	sd	s0,112(sp)
    80004bd0:	f4a6                	sd	s1,104(sp)
    80004bd2:	f0ca                	sd	s2,96(sp)
    80004bd4:	ecce                	sd	s3,88(sp)
    80004bd6:	e8d2                	sd	s4,80(sp)
    80004bd8:	e4d6                	sd	s5,72(sp)
    80004bda:	e0da                	sd	s6,64(sp)
    80004bdc:	fc5e                	sd	s7,56(sp)
    80004bde:	f862                	sd	s8,48(sp)
    80004be0:	f466                	sd	s9,40(sp)
    80004be2:	f06a                	sd	s10,32(sp)
    80004be4:	ec6e                	sd	s11,24(sp)
    80004be6:	0100                	addi	s0,sp,128
    80004be8:	84aa                	mv	s1,a0
    80004bea:	8cae                	mv	s9,a1
    80004bec:	8b32                	mv	s6,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004bee:	ffffd097          	auipc	ra,0xffffd
    80004bf2:	e9c080e7          	jalr	-356(ra) # 80001a8a <myproc>
    80004bf6:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004bf8:	8526                	mv	a0,s1
    80004bfa:	ffffc097          	auipc	ra,0xffffc
    80004bfe:	016080e7          	jalr	22(ra) # 80000c10 <acquire>
  for(i = 0; i < n; i++){
    80004c02:	0d605963          	blez	s6,80004cd4 <pipewrite+0x10a>
    80004c06:	89a6                	mv	s3,s1
    80004c08:	3b7d                	addiw	s6,s6,-1
    80004c0a:	1b02                	slli	s6,s6,0x20
    80004c0c:	020b5b13          	srli	s6,s6,0x20
    80004c10:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004c12:	21848a93          	addi	s5,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004c16:	21c48a13          	addi	s4,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004c1a:	5dfd                	li	s11,-1
    80004c1c:	000b8d1b          	sext.w	s10,s7
    80004c20:	8c6a                	mv	s8,s10
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004c22:	2184a783          	lw	a5,536(s1)
    80004c26:	21c4a703          	lw	a4,540(s1)
    80004c2a:	2007879b          	addiw	a5,a5,512
    80004c2e:	02f71b63          	bne	a4,a5,80004c64 <pipewrite+0x9a>
      if(pi->readopen == 0 || pr->killed){
    80004c32:	2204a783          	lw	a5,544(s1)
    80004c36:	cbad                	beqz	a5,80004ca8 <pipewrite+0xde>
    80004c38:	03092783          	lw	a5,48(s2)
    80004c3c:	e7b5                	bnez	a5,80004ca8 <pipewrite+0xde>
      wakeup(&pi->nread);
    80004c3e:	8556                	mv	a0,s5
    80004c40:	ffffe097          	auipc	ra,0xffffe
    80004c44:	808080e7          	jalr	-2040(ra) # 80002448 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004c48:	85ce                	mv	a1,s3
    80004c4a:	8552                	mv	a0,s4
    80004c4c:	ffffd097          	auipc	ra,0xffffd
    80004c50:	676080e7          	jalr	1654(ra) # 800022c2 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004c54:	2184a783          	lw	a5,536(s1)
    80004c58:	21c4a703          	lw	a4,540(s1)
    80004c5c:	2007879b          	addiw	a5,a5,512
    80004c60:	fcf709e3          	beq	a4,a5,80004c32 <pipewrite+0x68>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004c64:	4685                	li	a3,1
    80004c66:	019b8633          	add	a2,s7,s9
    80004c6a:	f8f40593          	addi	a1,s0,-113
    80004c6e:	06093503          	ld	a0,96(s2)
    80004c72:	ffffd097          	auipc	ra,0xffffd
    80004c76:	b64080e7          	jalr	-1180(ra) # 800017d6 <copyin>
    80004c7a:	05b50e63          	beq	a0,s11,80004cd6 <pipewrite+0x10c>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004c7e:	21c4a783          	lw	a5,540(s1)
    80004c82:	0017871b          	addiw	a4,a5,1
    80004c86:	20e4ae23          	sw	a4,540(s1)
    80004c8a:	1ff7f793          	andi	a5,a5,511
    80004c8e:	97a6                	add	a5,a5,s1
    80004c90:	f8f44703          	lbu	a4,-113(s0)
    80004c94:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004c98:	001d0c1b          	addiw	s8,s10,1
    80004c9c:	001b8793          	addi	a5,s7,1 # 1001 <_entry-0x7fffefff>
    80004ca0:	036b8b63          	beq	s7,s6,80004cd6 <pipewrite+0x10c>
    80004ca4:	8bbe                	mv	s7,a5
    80004ca6:	bf9d                	j	80004c1c <pipewrite+0x52>
        release(&pi->lock);
    80004ca8:	8526                	mv	a0,s1
    80004caa:	ffffc097          	auipc	ra,0xffffc
    80004cae:	01a080e7          	jalr	26(ra) # 80000cc4 <release>
        return -1;
    80004cb2:	5c7d                	li	s8,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);
  return i;
}
    80004cb4:	8562                	mv	a0,s8
    80004cb6:	70e6                	ld	ra,120(sp)
    80004cb8:	7446                	ld	s0,112(sp)
    80004cba:	74a6                	ld	s1,104(sp)
    80004cbc:	7906                	ld	s2,96(sp)
    80004cbe:	69e6                	ld	s3,88(sp)
    80004cc0:	6a46                	ld	s4,80(sp)
    80004cc2:	6aa6                	ld	s5,72(sp)
    80004cc4:	6b06                	ld	s6,64(sp)
    80004cc6:	7be2                	ld	s7,56(sp)
    80004cc8:	7c42                	ld	s8,48(sp)
    80004cca:	7ca2                	ld	s9,40(sp)
    80004ccc:	7d02                	ld	s10,32(sp)
    80004cce:	6de2                	ld	s11,24(sp)
    80004cd0:	6109                	addi	sp,sp,128
    80004cd2:	8082                	ret
  for(i = 0; i < n; i++){
    80004cd4:	4c01                	li	s8,0
  wakeup(&pi->nread);
    80004cd6:	21848513          	addi	a0,s1,536
    80004cda:	ffffd097          	auipc	ra,0xffffd
    80004cde:	76e080e7          	jalr	1902(ra) # 80002448 <wakeup>
  release(&pi->lock);
    80004ce2:	8526                	mv	a0,s1
    80004ce4:	ffffc097          	auipc	ra,0xffffc
    80004ce8:	fe0080e7          	jalr	-32(ra) # 80000cc4 <release>
  return i;
    80004cec:	b7e1                	j	80004cb4 <pipewrite+0xea>

0000000080004cee <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004cee:	715d                	addi	sp,sp,-80
    80004cf0:	e486                	sd	ra,72(sp)
    80004cf2:	e0a2                	sd	s0,64(sp)
    80004cf4:	fc26                	sd	s1,56(sp)
    80004cf6:	f84a                	sd	s2,48(sp)
    80004cf8:	f44e                	sd	s3,40(sp)
    80004cfa:	f052                	sd	s4,32(sp)
    80004cfc:	ec56                	sd	s5,24(sp)
    80004cfe:	e85a                	sd	s6,16(sp)
    80004d00:	0880                	addi	s0,sp,80
    80004d02:	84aa                	mv	s1,a0
    80004d04:	892e                	mv	s2,a1
    80004d06:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004d08:	ffffd097          	auipc	ra,0xffffd
    80004d0c:	d82080e7          	jalr	-638(ra) # 80001a8a <myproc>
    80004d10:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004d12:	8b26                	mv	s6,s1
    80004d14:	8526                	mv	a0,s1
    80004d16:	ffffc097          	auipc	ra,0xffffc
    80004d1a:	efa080e7          	jalr	-262(ra) # 80000c10 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004d1e:	2184a703          	lw	a4,536(s1)
    80004d22:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004d26:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004d2a:	02f71463          	bne	a4,a5,80004d52 <piperead+0x64>
    80004d2e:	2244a783          	lw	a5,548(s1)
    80004d32:	c385                	beqz	a5,80004d52 <piperead+0x64>
    if(pr->killed){
    80004d34:	030a2783          	lw	a5,48(s4)
    80004d38:	ebc1                	bnez	a5,80004dc8 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004d3a:	85da                	mv	a1,s6
    80004d3c:	854e                	mv	a0,s3
    80004d3e:	ffffd097          	auipc	ra,0xffffd
    80004d42:	584080e7          	jalr	1412(ra) # 800022c2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004d46:	2184a703          	lw	a4,536(s1)
    80004d4a:	21c4a783          	lw	a5,540(s1)
    80004d4e:	fef700e3          	beq	a4,a5,80004d2e <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d52:	09505263          	blez	s5,80004dd6 <piperead+0xe8>
    80004d56:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004d58:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004d5a:	2184a783          	lw	a5,536(s1)
    80004d5e:	21c4a703          	lw	a4,540(s1)
    80004d62:	02f70d63          	beq	a4,a5,80004d9c <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004d66:	0017871b          	addiw	a4,a5,1
    80004d6a:	20e4ac23          	sw	a4,536(s1)
    80004d6e:	1ff7f793          	andi	a5,a5,511
    80004d72:	97a6                	add	a5,a5,s1
    80004d74:	0187c783          	lbu	a5,24(a5)
    80004d78:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004d7c:	4685                	li	a3,1
    80004d7e:	fbf40613          	addi	a2,s0,-65
    80004d82:	85ca                	mv	a1,s2
    80004d84:	060a3503          	ld	a0,96(s4)
    80004d88:	ffffd097          	auipc	ra,0xffffd
    80004d8c:	9c2080e7          	jalr	-1598(ra) # 8000174a <copyout>
    80004d90:	01650663          	beq	a0,s6,80004d9c <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d94:	2985                	addiw	s3,s3,1
    80004d96:	0905                	addi	s2,s2,1
    80004d98:	fd3a91e3          	bne	s5,s3,80004d5a <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004d9c:	21c48513          	addi	a0,s1,540
    80004da0:	ffffd097          	auipc	ra,0xffffd
    80004da4:	6a8080e7          	jalr	1704(ra) # 80002448 <wakeup>
  release(&pi->lock);
    80004da8:	8526                	mv	a0,s1
    80004daa:	ffffc097          	auipc	ra,0xffffc
    80004dae:	f1a080e7          	jalr	-230(ra) # 80000cc4 <release>
  return i;
}
    80004db2:	854e                	mv	a0,s3
    80004db4:	60a6                	ld	ra,72(sp)
    80004db6:	6406                	ld	s0,64(sp)
    80004db8:	74e2                	ld	s1,56(sp)
    80004dba:	7942                	ld	s2,48(sp)
    80004dbc:	79a2                	ld	s3,40(sp)
    80004dbe:	7a02                	ld	s4,32(sp)
    80004dc0:	6ae2                	ld	s5,24(sp)
    80004dc2:	6b42                	ld	s6,16(sp)
    80004dc4:	6161                	addi	sp,sp,80
    80004dc6:	8082                	ret
      release(&pi->lock);
    80004dc8:	8526                	mv	a0,s1
    80004dca:	ffffc097          	auipc	ra,0xffffc
    80004dce:	efa080e7          	jalr	-262(ra) # 80000cc4 <release>
      return -1;
    80004dd2:	59fd                	li	s3,-1
    80004dd4:	bff9                	j	80004db2 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004dd6:	4981                	li	s3,0
    80004dd8:	b7d1                	j	80004d9c <piperead+0xae>

0000000080004dda <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004dda:	df010113          	addi	sp,sp,-528
    80004dde:	20113423          	sd	ra,520(sp)
    80004de2:	20813023          	sd	s0,512(sp)
    80004de6:	ffa6                	sd	s1,504(sp)
    80004de8:	fbca                	sd	s2,496(sp)
    80004dea:	f7ce                	sd	s3,488(sp)
    80004dec:	f3d2                	sd	s4,480(sp)
    80004dee:	efd6                	sd	s5,472(sp)
    80004df0:	ebda                	sd	s6,464(sp)
    80004df2:	e7de                	sd	s7,456(sp)
    80004df4:	e3e2                	sd	s8,448(sp)
    80004df6:	ff66                	sd	s9,440(sp)
    80004df8:	fb6a                	sd	s10,432(sp)
    80004dfa:	f76e                	sd	s11,424(sp)
    80004dfc:	0c00                	addi	s0,sp,528
    80004dfe:	84aa                	mv	s1,a0
    80004e00:	dea43c23          	sd	a0,-520(s0)
    80004e04:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004e08:	ffffd097          	auipc	ra,0xffffd
    80004e0c:	c82080e7          	jalr	-894(ra) # 80001a8a <myproc>
    80004e10:	892a                	mv	s2,a0

  begin_op();
    80004e12:	fffff097          	auipc	ra,0xfffff
    80004e16:	330080e7          	jalr	816(ra) # 80004142 <begin_op>
  if((ip = namei(path)) == 0){
    80004e1a:	8526                	mv	a0,s1
    80004e1c:	fffff097          	auipc	ra,0xfffff
    80004e20:	11a080e7          	jalr	282(ra) # 80003f36 <namei>
    80004e24:	c149                	beqz	a0,80004ea6 <exec+0xcc>
    80004e26:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004e28:	fffff097          	auipc	ra,0xfffff
    80004e2c:	95a080e7          	jalr	-1702(ra) # 80003782 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004e30:	04000713          	li	a4,64
    80004e34:	4681                	li	a3,0
    80004e36:	e4840613          	addi	a2,s0,-440
    80004e3a:	4581                	li	a1,0
    80004e3c:	8526                	mv	a0,s1
    80004e3e:	fffff097          	auipc	ra,0xfffff
    80004e42:	bf8080e7          	jalr	-1032(ra) # 80003a36 <readi>
    80004e46:	04000793          	li	a5,64
    80004e4a:	00f51a63          	bne	a0,a5,80004e5e <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004e4e:	e4842703          	lw	a4,-440(s0)
    80004e52:	464c47b7          	lui	a5,0x464c4
    80004e56:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004e5a:	04f70c63          	beq	a4,a5,80004eb2 <exec+0xd8>
  proc_freepagetable(oldpagetable, oldsz);

  return argc; // this ends up in a0, the first argument to main(argc, argv)

 bad:
  printf("bad\n");
    80004e5e:	00004517          	auipc	a0,0x4
    80004e62:	86250513          	addi	a0,a0,-1950 # 800086c0 <syscalls+0x2b0>
    80004e66:	ffffb097          	auipc	ra,0xffffb
    80004e6a:	72c080e7          	jalr	1836(ra) # 80000592 <printf>
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004e6e:	8526                	mv	a0,s1
    80004e70:	fffff097          	auipc	ra,0xfffff
    80004e74:	b74080e7          	jalr	-1164(ra) # 800039e4 <iunlockput>
    end_op();
    80004e78:	fffff097          	auipc	ra,0xfffff
    80004e7c:	34a080e7          	jalr	842(ra) # 800041c2 <end_op>
  }
  return -1;
    80004e80:	557d                	li	a0,-1
}
    80004e82:	20813083          	ld	ra,520(sp)
    80004e86:	20013403          	ld	s0,512(sp)
    80004e8a:	74fe                	ld	s1,504(sp)
    80004e8c:	795e                	ld	s2,496(sp)
    80004e8e:	79be                	ld	s3,488(sp)
    80004e90:	7a1e                	ld	s4,480(sp)
    80004e92:	6afe                	ld	s5,472(sp)
    80004e94:	6b5e                	ld	s6,464(sp)
    80004e96:	6bbe                	ld	s7,456(sp)
    80004e98:	6c1e                	ld	s8,448(sp)
    80004e9a:	7cfa                	ld	s9,440(sp)
    80004e9c:	7d5a                	ld	s10,432(sp)
    80004e9e:	7dba                	ld	s11,424(sp)
    80004ea0:	21010113          	addi	sp,sp,528
    80004ea4:	8082                	ret
    end_op();
    80004ea6:	fffff097          	auipc	ra,0xfffff
    80004eaa:	31c080e7          	jalr	796(ra) # 800041c2 <end_op>
    return -1;
    80004eae:	557d                	li	a0,-1
    80004eb0:	bfc9                	j	80004e82 <exec+0xa8>
  if((pagetable = proc_pagetable(p)) == 0)
    80004eb2:	854a                	mv	a0,s2
    80004eb4:	ffffd097          	auipc	ra,0xffffd
    80004eb8:	c9a080e7          	jalr	-870(ra) # 80001b4e <proc_pagetable>
    80004ebc:	8baa                	mv	s7,a0
    80004ebe:	d145                	beqz	a0,80004e5e <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004ec0:	e6842983          	lw	s3,-408(s0)
    80004ec4:	e8045783          	lhu	a5,-384(s0)
    80004ec8:	c7ad                	beqz	a5,80004f32 <exec+0x158>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004eca:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004ecc:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004ece:	6c85                	lui	s9,0x1
    80004ed0:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004ed4:	def43823          	sd	a5,-528(s0)
    80004ed8:	a489                	j	8000511a <exec+0x340>
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004eda:	00003517          	auipc	a0,0x3
    80004ede:	7c650513          	addi	a0,a0,1990 # 800086a0 <syscalls+0x290>
    80004ee2:	ffffb097          	auipc	ra,0xffffb
    80004ee6:	666080e7          	jalr	1638(ra) # 80000548 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004eea:	8756                	mv	a4,s5
    80004eec:	012d86bb          	addw	a3,s11,s2
    80004ef0:	4581                	li	a1,0
    80004ef2:	8526                	mv	a0,s1
    80004ef4:	fffff097          	auipc	ra,0xfffff
    80004ef8:	b42080e7          	jalr	-1214(ra) # 80003a36 <readi>
    80004efc:	2501                	sext.w	a0,a0
    80004efe:	1aaa9d63          	bne	s5,a0,800050b8 <exec+0x2de>
  for(i = 0; i < sz; i += PGSIZE){
    80004f02:	6785                	lui	a5,0x1
    80004f04:	0127893b          	addw	s2,a5,s2
    80004f08:	77fd                	lui	a5,0xfffff
    80004f0a:	01478a3b          	addw	s4,a5,s4
    80004f0e:	1f897d63          	bgeu	s2,s8,80005108 <exec+0x32e>
    pa = walkaddr(pagetable, va + i);
    80004f12:	02091593          	slli	a1,s2,0x20
    80004f16:	9181                	srli	a1,a1,0x20
    80004f18:	95ea                	add	a1,a1,s10
    80004f1a:	855e                	mv	a0,s7
    80004f1c:	ffffc097          	auipc	ra,0xffffc
    80004f20:	234080e7          	jalr	564(ra) # 80001150 <walkaddr>
    80004f24:	862a                	mv	a2,a0
    if(pa == 0)
    80004f26:	d955                	beqz	a0,80004eda <exec+0x100>
      n = PGSIZE;
    80004f28:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004f2a:	fd9a70e3          	bgeu	s4,s9,80004eea <exec+0x110>
      n = sz - i;
    80004f2e:	8ad2                	mv	s5,s4
    80004f30:	bf6d                	j	80004eea <exec+0x110>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004f32:	4901                	li	s2,0
  iunlockput(ip);
    80004f34:	8526                	mv	a0,s1
    80004f36:	fffff097          	auipc	ra,0xfffff
    80004f3a:	aae080e7          	jalr	-1362(ra) # 800039e4 <iunlockput>
  end_op();
    80004f3e:	fffff097          	auipc	ra,0xfffff
    80004f42:	284080e7          	jalr	644(ra) # 800041c2 <end_op>
  p = myproc();
    80004f46:	ffffd097          	auipc	ra,0xffffd
    80004f4a:	b44080e7          	jalr	-1212(ra) # 80001a8a <myproc>
    80004f4e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004f50:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    80004f54:	6785                	lui	a5,0x1
    80004f56:	17fd                	addi	a5,a5,-1
    80004f58:	993e                	add	s2,s2,a5
    80004f5a:	757d                	lui	a0,0xfffff
    80004f5c:	00a977b3          	and	a5,s2,a0
    80004f60:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004f64:	6609                	lui	a2,0x2
    80004f66:	963e                	add	a2,a2,a5
    80004f68:	85be                	mv	a1,a5
    80004f6a:	855e                	mv	a0,s7
    80004f6c:	ffffc097          	auipc	ra,0xffffc
    80004f70:	5aa080e7          	jalr	1450(ra) # 80001516 <uvmalloc>
    80004f74:	8b2a                	mv	s6,a0
  ip = 0;
    80004f76:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004f78:	14050063          	beqz	a0,800050b8 <exec+0x2de>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004f7c:	75f9                	lui	a1,0xffffe
    80004f7e:	95aa                	add	a1,a1,a0
    80004f80:	855e                	mv	a0,s7
    80004f82:	ffffc097          	auipc	ra,0xffffc
    80004f86:	796080e7          	jalr	1942(ra) # 80001718 <uvmclear>
  stackbase = sp - PGSIZE;
    80004f8a:	7c7d                	lui	s8,0xfffff
    80004f8c:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004f8e:	e0043783          	ld	a5,-512(s0)
    80004f92:	6388                	ld	a0,0(a5)
    80004f94:	c535                	beqz	a0,80005000 <exec+0x226>
    80004f96:	e8840993          	addi	s3,s0,-376
    80004f9a:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80004f9e:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004fa0:	ffffc097          	auipc	ra,0xffffc
    80004fa4:	ef4080e7          	jalr	-268(ra) # 80000e94 <strlen>
    80004fa8:	2505                	addiw	a0,a0,1
    80004faa:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004fae:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004fb2:	13896f63          	bltu	s2,s8,800050f0 <exec+0x316>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004fb6:	e0043d83          	ld	s11,-512(s0)
    80004fba:	000dba03          	ld	s4,0(s11)
    80004fbe:	8552                	mv	a0,s4
    80004fc0:	ffffc097          	auipc	ra,0xffffc
    80004fc4:	ed4080e7          	jalr	-300(ra) # 80000e94 <strlen>
    80004fc8:	0015069b          	addiw	a3,a0,1
    80004fcc:	8652                	mv	a2,s4
    80004fce:	85ca                	mv	a1,s2
    80004fd0:	855e                	mv	a0,s7
    80004fd2:	ffffc097          	auipc	ra,0xffffc
    80004fd6:	778080e7          	jalr	1912(ra) # 8000174a <copyout>
    80004fda:	10054f63          	bltz	a0,800050f8 <exec+0x31e>
    ustack[argc] = sp;
    80004fde:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004fe2:	0485                	addi	s1,s1,1
    80004fe4:	008d8793          	addi	a5,s11,8
    80004fe8:	e0f43023          	sd	a5,-512(s0)
    80004fec:	008db503          	ld	a0,8(s11)
    80004ff0:	c911                	beqz	a0,80005004 <exec+0x22a>
    if(argc >= MAXARG)
    80004ff2:	09a1                	addi	s3,s3,8
    80004ff4:	fb3c96e3          	bne	s9,s3,80004fa0 <exec+0x1c6>
  sz = sz1;
    80004ff8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004ffc:	4481                	li	s1,0
    80004ffe:	a86d                	j	800050b8 <exec+0x2de>
  sp = sz;
    80005000:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80005002:	4481                	li	s1,0
  ustack[argc] = 0;
    80005004:	00349793          	slli	a5,s1,0x3
    80005008:	f9040713          	addi	a4,s0,-112
    8000500c:	97ba                	add	a5,a5,a4
    8000500e:	ee07bc23          	sd	zero,-264(a5) # ef8 <_entry-0x7ffff108>
  sp -= (argc+1) * sizeof(uint64);
    80005012:	00148693          	addi	a3,s1,1
    80005016:	068e                	slli	a3,a3,0x3
    80005018:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000501c:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80005020:	01897663          	bgeu	s2,s8,8000502c <exec+0x252>
  sz = sz1;
    80005024:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80005028:	4481                	li	s1,0
    8000502a:	a079                	j	800050b8 <exec+0x2de>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000502c:	e8840613          	addi	a2,s0,-376
    80005030:	85ca                	mv	a1,s2
    80005032:	855e                	mv	a0,s7
    80005034:	ffffc097          	auipc	ra,0xffffc
    80005038:	716080e7          	jalr	1814(ra) # 8000174a <copyout>
    8000503c:	0c054263          	bltz	a0,80005100 <exec+0x326>
  p->trapframe->a1 = sp;
    80005040:	068ab783          	ld	a5,104(s5)
    80005044:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005048:	df843783          	ld	a5,-520(s0)
    8000504c:	0007c703          	lbu	a4,0(a5)
    80005050:	cf11                	beqz	a4,8000506c <exec+0x292>
    80005052:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005054:	02f00693          	li	a3,47
    80005058:	a029                	j	80005062 <exec+0x288>
  for(last=s=path; *s; s++)
    8000505a:	0785                	addi	a5,a5,1
    8000505c:	fff7c703          	lbu	a4,-1(a5)
    80005060:	c711                	beqz	a4,8000506c <exec+0x292>
    if(*s == '/')
    80005062:	fed71ce3          	bne	a4,a3,8000505a <exec+0x280>
      last = s+1;
    80005066:	def43c23          	sd	a5,-520(s0)
    8000506a:	bfc5                	j	8000505a <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    8000506c:	4641                	li	a2,16
    8000506e:	df843583          	ld	a1,-520(s0)
    80005072:	168a8513          	addi	a0,s5,360
    80005076:	ffffc097          	auipc	ra,0xffffc
    8000507a:	dec080e7          	jalr	-532(ra) # 80000e62 <safestrcpy>
  oldpagetable = p->pagetable;
    8000507e:	060ab503          	ld	a0,96(s5)
  p->pagetable = pagetable;
    80005082:	077ab023          	sd	s7,96(s5)
  p->sz = sz;
    80005086:	056ab823          	sd	s6,80(s5)
  p->maxva = sz;
    8000508a:	056abc23          	sd	s6,88(s5)
  p->ustack = sz;
    8000508e:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005092:	068ab783          	ld	a5,104(s5)
    80005096:	e6043703          	ld	a4,-416(s0)
    8000509a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000509c:	068ab783          	ld	a5,104(s5)
    800050a0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800050a4:	85ea                	mv	a1,s10
    800050a6:	ffffd097          	auipc	ra,0xffffd
    800050aa:	b44080e7          	jalr	-1212(ra) # 80001bea <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800050ae:	0004851b          	sext.w	a0,s1
    800050b2:	bbc1                	j	80004e82 <exec+0xa8>
    800050b4:	e1243423          	sd	s2,-504(s0)
  printf("bad\n");
    800050b8:	00003517          	auipc	a0,0x3
    800050bc:	60850513          	addi	a0,a0,1544 # 800086c0 <syscalls+0x2b0>
    800050c0:	ffffb097          	auipc	ra,0xffffb
    800050c4:	4d2080e7          	jalr	1234(ra) # 80000592 <printf>
    proc_freepagetable(pagetable, sz);
    800050c8:	e0843583          	ld	a1,-504(s0)
    800050cc:	855e                	mv	a0,s7
    800050ce:	ffffd097          	auipc	ra,0xffffd
    800050d2:	b1c080e7          	jalr	-1252(ra) # 80001bea <proc_freepagetable>
  if(ip){
    800050d6:	d8049ce3          	bnez	s1,80004e6e <exec+0x94>
  return -1;
    800050da:	557d                	li	a0,-1
    800050dc:	b35d                	j	80004e82 <exec+0xa8>
    800050de:	e1243423          	sd	s2,-504(s0)
    800050e2:	bfd9                	j	800050b8 <exec+0x2de>
    800050e4:	e1243423          	sd	s2,-504(s0)
    800050e8:	bfc1                	j	800050b8 <exec+0x2de>
    800050ea:	e1243423          	sd	s2,-504(s0)
    800050ee:	b7e9                	j	800050b8 <exec+0x2de>
  sz = sz1;
    800050f0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800050f4:	4481                	li	s1,0
    800050f6:	b7c9                	j	800050b8 <exec+0x2de>
  sz = sz1;
    800050f8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800050fc:	4481                	li	s1,0
    800050fe:	bf6d                	j	800050b8 <exec+0x2de>
  sz = sz1;
    80005100:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80005104:	4481                	li	s1,0
    80005106:	bf4d                	j	800050b8 <exec+0x2de>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005108:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000510c:	2b05                	addiw	s6,s6,1
    8000510e:	0389899b          	addiw	s3,s3,56
    80005112:	e8045783          	lhu	a5,-384(s0)
    80005116:	e0fb5fe3          	bge	s6,a5,80004f34 <exec+0x15a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000511a:	2981                	sext.w	s3,s3
    8000511c:	03800713          	li	a4,56
    80005120:	86ce                	mv	a3,s3
    80005122:	e1040613          	addi	a2,s0,-496
    80005126:	4581                	li	a1,0
    80005128:	8526                	mv	a0,s1
    8000512a:	fffff097          	auipc	ra,0xfffff
    8000512e:	90c080e7          	jalr	-1780(ra) # 80003a36 <readi>
    80005132:	03800793          	li	a5,56
    80005136:	f6f51fe3          	bne	a0,a5,800050b4 <exec+0x2da>
    if(ph.type != ELF_PROG_LOAD)
    8000513a:	e1042783          	lw	a5,-496(s0)
    8000513e:	4705                	li	a4,1
    80005140:	fce796e3          	bne	a5,a4,8000510c <exec+0x332>
    if(ph.memsz < ph.filesz)
    80005144:	e3843603          	ld	a2,-456(s0)
    80005148:	e3043783          	ld	a5,-464(s0)
    8000514c:	f8f669e3          	bltu	a2,a5,800050de <exec+0x304>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005150:	e2043783          	ld	a5,-480(s0)
    80005154:	963e                	add	a2,a2,a5
    80005156:	f8f667e3          	bltu	a2,a5,800050e4 <exec+0x30a>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000515a:	85ca                	mv	a1,s2
    8000515c:	855e                	mv	a0,s7
    8000515e:	ffffc097          	auipc	ra,0xffffc
    80005162:	3b8080e7          	jalr	952(ra) # 80001516 <uvmalloc>
    80005166:	e0a43423          	sd	a0,-504(s0)
    8000516a:	d141                	beqz	a0,800050ea <exec+0x310>
    if(ph.vaddr % PGSIZE != 0)
    8000516c:	e2043d03          	ld	s10,-480(s0)
    80005170:	df043783          	ld	a5,-528(s0)
    80005174:	00fd77b3          	and	a5,s10,a5
    80005178:	f3a1                	bnez	a5,800050b8 <exec+0x2de>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000517a:	e1842d83          	lw	s11,-488(s0)
    8000517e:	e3042c03          	lw	s8,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005182:	f80c03e3          	beqz	s8,80005108 <exec+0x32e>
    80005186:	8a62                	mv	s4,s8
    80005188:	4901                	li	s2,0
    8000518a:	b361                	j	80004f12 <exec+0x138>

000000008000518c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000518c:	7179                	addi	sp,sp,-48
    8000518e:	f406                	sd	ra,40(sp)
    80005190:	f022                	sd	s0,32(sp)
    80005192:	ec26                	sd	s1,24(sp)
    80005194:	e84a                	sd	s2,16(sp)
    80005196:	1800                	addi	s0,sp,48
    80005198:	892e                	mv	s2,a1
    8000519a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000519c:	fdc40593          	addi	a1,s0,-36
    800051a0:	ffffe097          	auipc	ra,0xffffe
    800051a4:	a48080e7          	jalr	-1464(ra) # 80002be8 <argint>
    800051a8:	04054063          	bltz	a0,800051e8 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800051ac:	fdc42703          	lw	a4,-36(s0)
    800051b0:	47bd                	li	a5,15
    800051b2:	02e7ed63          	bltu	a5,a4,800051ec <argfd+0x60>
    800051b6:	ffffd097          	auipc	ra,0xffffd
    800051ba:	8d4080e7          	jalr	-1836(ra) # 80001a8a <myproc>
    800051be:	fdc42703          	lw	a4,-36(s0)
    800051c2:	01c70793          	addi	a5,a4,28
    800051c6:	078e                	slli	a5,a5,0x3
    800051c8:	953e                	add	a0,a0,a5
    800051ca:	611c                	ld	a5,0(a0)
    800051cc:	c395                	beqz	a5,800051f0 <argfd+0x64>
    return -1;
  if(pfd)
    800051ce:	00090463          	beqz	s2,800051d6 <argfd+0x4a>
    *pfd = fd;
    800051d2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800051d6:	4501                	li	a0,0
  if(pf)
    800051d8:	c091                	beqz	s1,800051dc <argfd+0x50>
    *pf = f;
    800051da:	e09c                	sd	a5,0(s1)
}
    800051dc:	70a2                	ld	ra,40(sp)
    800051de:	7402                	ld	s0,32(sp)
    800051e0:	64e2                	ld	s1,24(sp)
    800051e2:	6942                	ld	s2,16(sp)
    800051e4:	6145                	addi	sp,sp,48
    800051e6:	8082                	ret
    return -1;
    800051e8:	557d                	li	a0,-1
    800051ea:	bfcd                	j	800051dc <argfd+0x50>
    return -1;
    800051ec:	557d                	li	a0,-1
    800051ee:	b7fd                	j	800051dc <argfd+0x50>
    800051f0:	557d                	li	a0,-1
    800051f2:	b7ed                	j	800051dc <argfd+0x50>

00000000800051f4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800051f4:	1101                	addi	sp,sp,-32
    800051f6:	ec06                	sd	ra,24(sp)
    800051f8:	e822                	sd	s0,16(sp)
    800051fa:	e426                	sd	s1,8(sp)
    800051fc:	1000                	addi	s0,sp,32
    800051fe:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005200:	ffffd097          	auipc	ra,0xffffd
    80005204:	88a080e7          	jalr	-1910(ra) # 80001a8a <myproc>
    80005208:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000520a:	0e050793          	addi	a5,a0,224
    8000520e:	4501                	li	a0,0
    80005210:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005212:	6398                	ld	a4,0(a5)
    80005214:	cb19                	beqz	a4,8000522a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005216:	2505                	addiw	a0,a0,1
    80005218:	07a1                	addi	a5,a5,8
    8000521a:	fed51ce3          	bne	a0,a3,80005212 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000521e:	557d                	li	a0,-1
}
    80005220:	60e2                	ld	ra,24(sp)
    80005222:	6442                	ld	s0,16(sp)
    80005224:	64a2                	ld	s1,8(sp)
    80005226:	6105                	addi	sp,sp,32
    80005228:	8082                	ret
      p->ofile[fd] = f;
    8000522a:	01c50793          	addi	a5,a0,28
    8000522e:	078e                	slli	a5,a5,0x3
    80005230:	963e                	add	a2,a2,a5
    80005232:	e204                	sd	s1,0(a2)
      return fd;
    80005234:	b7f5                	j	80005220 <fdalloc+0x2c>

0000000080005236 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005236:	715d                	addi	sp,sp,-80
    80005238:	e486                	sd	ra,72(sp)
    8000523a:	e0a2                	sd	s0,64(sp)
    8000523c:	fc26                	sd	s1,56(sp)
    8000523e:	f84a                	sd	s2,48(sp)
    80005240:	f44e                	sd	s3,40(sp)
    80005242:	f052                	sd	s4,32(sp)
    80005244:	ec56                	sd	s5,24(sp)
    80005246:	0880                	addi	s0,sp,80
    80005248:	89ae                	mv	s3,a1
    8000524a:	8ab2                	mv	s5,a2
    8000524c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000524e:	fb040593          	addi	a1,s0,-80
    80005252:	fffff097          	auipc	ra,0xfffff
    80005256:	d02080e7          	jalr	-766(ra) # 80003f54 <nameiparent>
    8000525a:	892a                	mv	s2,a0
    8000525c:	12050f63          	beqz	a0,8000539a <create+0x164>
    return 0;

  ilock(dp);
    80005260:	ffffe097          	auipc	ra,0xffffe
    80005264:	522080e7          	jalr	1314(ra) # 80003782 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005268:	4601                	li	a2,0
    8000526a:	fb040593          	addi	a1,s0,-80
    8000526e:	854a                	mv	a0,s2
    80005270:	fffff097          	auipc	ra,0xfffff
    80005274:	9f4080e7          	jalr	-1548(ra) # 80003c64 <dirlookup>
    80005278:	84aa                	mv	s1,a0
    8000527a:	c921                	beqz	a0,800052ca <create+0x94>
    iunlockput(dp);
    8000527c:	854a                	mv	a0,s2
    8000527e:	ffffe097          	auipc	ra,0xffffe
    80005282:	766080e7          	jalr	1894(ra) # 800039e4 <iunlockput>
    ilock(ip);
    80005286:	8526                	mv	a0,s1
    80005288:	ffffe097          	auipc	ra,0xffffe
    8000528c:	4fa080e7          	jalr	1274(ra) # 80003782 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005290:	2981                	sext.w	s3,s3
    80005292:	4789                	li	a5,2
    80005294:	02f99463          	bne	s3,a5,800052bc <create+0x86>
    80005298:	0444d783          	lhu	a5,68(s1)
    8000529c:	37f9                	addiw	a5,a5,-2
    8000529e:	17c2                	slli	a5,a5,0x30
    800052a0:	93c1                	srli	a5,a5,0x30
    800052a2:	4705                	li	a4,1
    800052a4:	00f76c63          	bltu	a4,a5,800052bc <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800052a8:	8526                	mv	a0,s1
    800052aa:	60a6                	ld	ra,72(sp)
    800052ac:	6406                	ld	s0,64(sp)
    800052ae:	74e2                	ld	s1,56(sp)
    800052b0:	7942                	ld	s2,48(sp)
    800052b2:	79a2                	ld	s3,40(sp)
    800052b4:	7a02                	ld	s4,32(sp)
    800052b6:	6ae2                	ld	s5,24(sp)
    800052b8:	6161                	addi	sp,sp,80
    800052ba:	8082                	ret
    iunlockput(ip);
    800052bc:	8526                	mv	a0,s1
    800052be:	ffffe097          	auipc	ra,0xffffe
    800052c2:	726080e7          	jalr	1830(ra) # 800039e4 <iunlockput>
    return 0;
    800052c6:	4481                	li	s1,0
    800052c8:	b7c5                	j	800052a8 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800052ca:	85ce                	mv	a1,s3
    800052cc:	00092503          	lw	a0,0(s2)
    800052d0:	ffffe097          	auipc	ra,0xffffe
    800052d4:	31a080e7          	jalr	794(ra) # 800035ea <ialloc>
    800052d8:	84aa                	mv	s1,a0
    800052da:	c529                	beqz	a0,80005324 <create+0xee>
  ilock(ip);
    800052dc:	ffffe097          	auipc	ra,0xffffe
    800052e0:	4a6080e7          	jalr	1190(ra) # 80003782 <ilock>
  ip->major = major;
    800052e4:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800052e8:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800052ec:	4785                	li	a5,1
    800052ee:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800052f2:	8526                	mv	a0,s1
    800052f4:	ffffe097          	auipc	ra,0xffffe
    800052f8:	3c4080e7          	jalr	964(ra) # 800036b8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800052fc:	2981                	sext.w	s3,s3
    800052fe:	4785                	li	a5,1
    80005300:	02f98a63          	beq	s3,a5,80005334 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005304:	40d0                	lw	a2,4(s1)
    80005306:	fb040593          	addi	a1,s0,-80
    8000530a:	854a                	mv	a0,s2
    8000530c:	fffff097          	auipc	ra,0xfffff
    80005310:	b68080e7          	jalr	-1176(ra) # 80003e74 <dirlink>
    80005314:	06054b63          	bltz	a0,8000538a <create+0x154>
  iunlockput(dp);
    80005318:	854a                	mv	a0,s2
    8000531a:	ffffe097          	auipc	ra,0xffffe
    8000531e:	6ca080e7          	jalr	1738(ra) # 800039e4 <iunlockput>
  return ip;
    80005322:	b759                	j	800052a8 <create+0x72>
    panic("create: ialloc");
    80005324:	00003517          	auipc	a0,0x3
    80005328:	3a450513          	addi	a0,a0,932 # 800086c8 <syscalls+0x2b8>
    8000532c:	ffffb097          	auipc	ra,0xffffb
    80005330:	21c080e7          	jalr	540(ra) # 80000548 <panic>
    dp->nlink++;  // for ".."
    80005334:	04a95783          	lhu	a5,74(s2)
    80005338:	2785                	addiw	a5,a5,1
    8000533a:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000533e:	854a                	mv	a0,s2
    80005340:	ffffe097          	auipc	ra,0xffffe
    80005344:	378080e7          	jalr	888(ra) # 800036b8 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005348:	40d0                	lw	a2,4(s1)
    8000534a:	00003597          	auipc	a1,0x3
    8000534e:	38e58593          	addi	a1,a1,910 # 800086d8 <syscalls+0x2c8>
    80005352:	8526                	mv	a0,s1
    80005354:	fffff097          	auipc	ra,0xfffff
    80005358:	b20080e7          	jalr	-1248(ra) # 80003e74 <dirlink>
    8000535c:	00054f63          	bltz	a0,8000537a <create+0x144>
    80005360:	00492603          	lw	a2,4(s2)
    80005364:	00003597          	auipc	a1,0x3
    80005368:	37c58593          	addi	a1,a1,892 # 800086e0 <syscalls+0x2d0>
    8000536c:	8526                	mv	a0,s1
    8000536e:	fffff097          	auipc	ra,0xfffff
    80005372:	b06080e7          	jalr	-1274(ra) # 80003e74 <dirlink>
    80005376:	f80557e3          	bgez	a0,80005304 <create+0xce>
      panic("create dots");
    8000537a:	00003517          	auipc	a0,0x3
    8000537e:	36e50513          	addi	a0,a0,878 # 800086e8 <syscalls+0x2d8>
    80005382:	ffffb097          	auipc	ra,0xffffb
    80005386:	1c6080e7          	jalr	454(ra) # 80000548 <panic>
    panic("create: dirlink");
    8000538a:	00003517          	auipc	a0,0x3
    8000538e:	36e50513          	addi	a0,a0,878 # 800086f8 <syscalls+0x2e8>
    80005392:	ffffb097          	auipc	ra,0xffffb
    80005396:	1b6080e7          	jalr	438(ra) # 80000548 <panic>
    return 0;
    8000539a:	84aa                	mv	s1,a0
    8000539c:	b731                	j	800052a8 <create+0x72>

000000008000539e <sys_dup>:
{
    8000539e:	7179                	addi	sp,sp,-48
    800053a0:	f406                	sd	ra,40(sp)
    800053a2:	f022                	sd	s0,32(sp)
    800053a4:	ec26                	sd	s1,24(sp)
    800053a6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800053a8:	fd840613          	addi	a2,s0,-40
    800053ac:	4581                	li	a1,0
    800053ae:	4501                	li	a0,0
    800053b0:	00000097          	auipc	ra,0x0
    800053b4:	ddc080e7          	jalr	-548(ra) # 8000518c <argfd>
    return -1;
    800053b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800053ba:	02054363          	bltz	a0,800053e0 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800053be:	fd843503          	ld	a0,-40(s0)
    800053c2:	00000097          	auipc	ra,0x0
    800053c6:	e32080e7          	jalr	-462(ra) # 800051f4 <fdalloc>
    800053ca:	84aa                	mv	s1,a0
    return -1;
    800053cc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800053ce:	00054963          	bltz	a0,800053e0 <sys_dup+0x42>
  filedup(f);
    800053d2:	fd843503          	ld	a0,-40(s0)
    800053d6:	fffff097          	auipc	ra,0xfffff
    800053da:	1ec080e7          	jalr	492(ra) # 800045c2 <filedup>
  return fd;
    800053de:	87a6                	mv	a5,s1
}
    800053e0:	853e                	mv	a0,a5
    800053e2:	70a2                	ld	ra,40(sp)
    800053e4:	7402                	ld	s0,32(sp)
    800053e6:	64e2                	ld	s1,24(sp)
    800053e8:	6145                	addi	sp,sp,48
    800053ea:	8082                	ret

00000000800053ec <sys_read>:
{
    800053ec:	7179                	addi	sp,sp,-48
    800053ee:	f406                	sd	ra,40(sp)
    800053f0:	f022                	sd	s0,32(sp)
    800053f2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800053f4:	fe840613          	addi	a2,s0,-24
    800053f8:	4581                	li	a1,0
    800053fa:	4501                	li	a0,0
    800053fc:	00000097          	auipc	ra,0x0
    80005400:	d90080e7          	jalr	-624(ra) # 8000518c <argfd>
    return -1;
    80005404:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005406:	04054163          	bltz	a0,80005448 <sys_read+0x5c>
    8000540a:	fe440593          	addi	a1,s0,-28
    8000540e:	4509                	li	a0,2
    80005410:	ffffd097          	auipc	ra,0xffffd
    80005414:	7d8080e7          	jalr	2008(ra) # 80002be8 <argint>
    return -1;
    80005418:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000541a:	02054763          	bltz	a0,80005448 <sys_read+0x5c>
    8000541e:	fd840593          	addi	a1,s0,-40
    80005422:	4505                	li	a0,1
    80005424:	ffffd097          	auipc	ra,0xffffd
    80005428:	7e6080e7          	jalr	2022(ra) # 80002c0a <argaddr>
    return -1;
    8000542c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000542e:	00054d63          	bltz	a0,80005448 <sys_read+0x5c>
  return fileread(f, p, n);
    80005432:	fe442603          	lw	a2,-28(s0)
    80005436:	fd843583          	ld	a1,-40(s0)
    8000543a:	fe843503          	ld	a0,-24(s0)
    8000543e:	fffff097          	auipc	ra,0xfffff
    80005442:	310080e7          	jalr	784(ra) # 8000474e <fileread>
    80005446:	87aa                	mv	a5,a0
}
    80005448:	853e                	mv	a0,a5
    8000544a:	70a2                	ld	ra,40(sp)
    8000544c:	7402                	ld	s0,32(sp)
    8000544e:	6145                	addi	sp,sp,48
    80005450:	8082                	ret

0000000080005452 <sys_write>:
{
    80005452:	7179                	addi	sp,sp,-48
    80005454:	f406                	sd	ra,40(sp)
    80005456:	f022                	sd	s0,32(sp)
    80005458:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000545a:	fe840613          	addi	a2,s0,-24
    8000545e:	4581                	li	a1,0
    80005460:	4501                	li	a0,0
    80005462:	00000097          	auipc	ra,0x0
    80005466:	d2a080e7          	jalr	-726(ra) # 8000518c <argfd>
    return -1;
    8000546a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000546c:	04054163          	bltz	a0,800054ae <sys_write+0x5c>
    80005470:	fe440593          	addi	a1,s0,-28
    80005474:	4509                	li	a0,2
    80005476:	ffffd097          	auipc	ra,0xffffd
    8000547a:	772080e7          	jalr	1906(ra) # 80002be8 <argint>
    return -1;
    8000547e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005480:	02054763          	bltz	a0,800054ae <sys_write+0x5c>
    80005484:	fd840593          	addi	a1,s0,-40
    80005488:	4505                	li	a0,1
    8000548a:	ffffd097          	auipc	ra,0xffffd
    8000548e:	780080e7          	jalr	1920(ra) # 80002c0a <argaddr>
    return -1;
    80005492:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005494:	00054d63          	bltz	a0,800054ae <sys_write+0x5c>
  return filewrite(f, p, n);
    80005498:	fe442603          	lw	a2,-28(s0)
    8000549c:	fd843583          	ld	a1,-40(s0)
    800054a0:	fe843503          	ld	a0,-24(s0)
    800054a4:	fffff097          	auipc	ra,0xfffff
    800054a8:	3f8080e7          	jalr	1016(ra) # 8000489c <filewrite>
    800054ac:	87aa                	mv	a5,a0
}
    800054ae:	853e                	mv	a0,a5
    800054b0:	70a2                	ld	ra,40(sp)
    800054b2:	7402                	ld	s0,32(sp)
    800054b4:	6145                	addi	sp,sp,48
    800054b6:	8082                	ret

00000000800054b8 <sys_close>:
{
    800054b8:	1101                	addi	sp,sp,-32
    800054ba:	ec06                	sd	ra,24(sp)
    800054bc:	e822                	sd	s0,16(sp)
    800054be:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800054c0:	fe040613          	addi	a2,s0,-32
    800054c4:	fec40593          	addi	a1,s0,-20
    800054c8:	4501                	li	a0,0
    800054ca:	00000097          	auipc	ra,0x0
    800054ce:	cc2080e7          	jalr	-830(ra) # 8000518c <argfd>
    return -1;
    800054d2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800054d4:	02054463          	bltz	a0,800054fc <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800054d8:	ffffc097          	auipc	ra,0xffffc
    800054dc:	5b2080e7          	jalr	1458(ra) # 80001a8a <myproc>
    800054e0:	fec42783          	lw	a5,-20(s0)
    800054e4:	07f1                	addi	a5,a5,28
    800054e6:	078e                	slli	a5,a5,0x3
    800054e8:	97aa                	add	a5,a5,a0
    800054ea:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800054ee:	fe043503          	ld	a0,-32(s0)
    800054f2:	fffff097          	auipc	ra,0xfffff
    800054f6:	122080e7          	jalr	290(ra) # 80004614 <fileclose>
  return 0;
    800054fa:	4781                	li	a5,0
}
    800054fc:	853e                	mv	a0,a5
    800054fe:	60e2                	ld	ra,24(sp)
    80005500:	6442                	ld	s0,16(sp)
    80005502:	6105                	addi	sp,sp,32
    80005504:	8082                	ret

0000000080005506 <sys_fstat>:
{
    80005506:	1101                	addi	sp,sp,-32
    80005508:	ec06                	sd	ra,24(sp)
    8000550a:	e822                	sd	s0,16(sp)
    8000550c:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000550e:	fe840613          	addi	a2,s0,-24
    80005512:	4581                	li	a1,0
    80005514:	4501                	li	a0,0
    80005516:	00000097          	auipc	ra,0x0
    8000551a:	c76080e7          	jalr	-906(ra) # 8000518c <argfd>
    return -1;
    8000551e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005520:	02054563          	bltz	a0,8000554a <sys_fstat+0x44>
    80005524:	fe040593          	addi	a1,s0,-32
    80005528:	4505                	li	a0,1
    8000552a:	ffffd097          	auipc	ra,0xffffd
    8000552e:	6e0080e7          	jalr	1760(ra) # 80002c0a <argaddr>
    return -1;
    80005532:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005534:	00054b63          	bltz	a0,8000554a <sys_fstat+0x44>
  return filestat(f, st);
    80005538:	fe043583          	ld	a1,-32(s0)
    8000553c:	fe843503          	ld	a0,-24(s0)
    80005540:	fffff097          	auipc	ra,0xfffff
    80005544:	19c080e7          	jalr	412(ra) # 800046dc <filestat>
    80005548:	87aa                	mv	a5,a0
}
    8000554a:	853e                	mv	a0,a5
    8000554c:	60e2                	ld	ra,24(sp)
    8000554e:	6442                	ld	s0,16(sp)
    80005550:	6105                	addi	sp,sp,32
    80005552:	8082                	ret

0000000080005554 <sys_link>:
{
    80005554:	7169                	addi	sp,sp,-304
    80005556:	f606                	sd	ra,296(sp)
    80005558:	f222                	sd	s0,288(sp)
    8000555a:	ee26                	sd	s1,280(sp)
    8000555c:	ea4a                	sd	s2,272(sp)
    8000555e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005560:	08000613          	li	a2,128
    80005564:	ed040593          	addi	a1,s0,-304
    80005568:	4501                	li	a0,0
    8000556a:	ffffd097          	auipc	ra,0xffffd
    8000556e:	6c2080e7          	jalr	1730(ra) # 80002c2c <argstr>
    return -1;
    80005572:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005574:	10054e63          	bltz	a0,80005690 <sys_link+0x13c>
    80005578:	08000613          	li	a2,128
    8000557c:	f5040593          	addi	a1,s0,-176
    80005580:	4505                	li	a0,1
    80005582:	ffffd097          	auipc	ra,0xffffd
    80005586:	6aa080e7          	jalr	1706(ra) # 80002c2c <argstr>
    return -1;
    8000558a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000558c:	10054263          	bltz	a0,80005690 <sys_link+0x13c>
  begin_op();
    80005590:	fffff097          	auipc	ra,0xfffff
    80005594:	bb2080e7          	jalr	-1102(ra) # 80004142 <begin_op>
  if((ip = namei(old)) == 0){
    80005598:	ed040513          	addi	a0,s0,-304
    8000559c:	fffff097          	auipc	ra,0xfffff
    800055a0:	99a080e7          	jalr	-1638(ra) # 80003f36 <namei>
    800055a4:	84aa                	mv	s1,a0
    800055a6:	c551                	beqz	a0,80005632 <sys_link+0xde>
  ilock(ip);
    800055a8:	ffffe097          	auipc	ra,0xffffe
    800055ac:	1da080e7          	jalr	474(ra) # 80003782 <ilock>
  if(ip->type == T_DIR){
    800055b0:	04449703          	lh	a4,68(s1)
    800055b4:	4785                	li	a5,1
    800055b6:	08f70463          	beq	a4,a5,8000563e <sys_link+0xea>
  ip->nlink++;
    800055ba:	04a4d783          	lhu	a5,74(s1)
    800055be:	2785                	addiw	a5,a5,1
    800055c0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800055c4:	8526                	mv	a0,s1
    800055c6:	ffffe097          	auipc	ra,0xffffe
    800055ca:	0f2080e7          	jalr	242(ra) # 800036b8 <iupdate>
  iunlock(ip);
    800055ce:	8526                	mv	a0,s1
    800055d0:	ffffe097          	auipc	ra,0xffffe
    800055d4:	274080e7          	jalr	628(ra) # 80003844 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800055d8:	fd040593          	addi	a1,s0,-48
    800055dc:	f5040513          	addi	a0,s0,-176
    800055e0:	fffff097          	auipc	ra,0xfffff
    800055e4:	974080e7          	jalr	-1676(ra) # 80003f54 <nameiparent>
    800055e8:	892a                	mv	s2,a0
    800055ea:	c935                	beqz	a0,8000565e <sys_link+0x10a>
  ilock(dp);
    800055ec:	ffffe097          	auipc	ra,0xffffe
    800055f0:	196080e7          	jalr	406(ra) # 80003782 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800055f4:	00092703          	lw	a4,0(s2)
    800055f8:	409c                	lw	a5,0(s1)
    800055fa:	04f71d63          	bne	a4,a5,80005654 <sys_link+0x100>
    800055fe:	40d0                	lw	a2,4(s1)
    80005600:	fd040593          	addi	a1,s0,-48
    80005604:	854a                	mv	a0,s2
    80005606:	fffff097          	auipc	ra,0xfffff
    8000560a:	86e080e7          	jalr	-1938(ra) # 80003e74 <dirlink>
    8000560e:	04054363          	bltz	a0,80005654 <sys_link+0x100>
  iunlockput(dp);
    80005612:	854a                	mv	a0,s2
    80005614:	ffffe097          	auipc	ra,0xffffe
    80005618:	3d0080e7          	jalr	976(ra) # 800039e4 <iunlockput>
  iput(ip);
    8000561c:	8526                	mv	a0,s1
    8000561e:	ffffe097          	auipc	ra,0xffffe
    80005622:	31e080e7          	jalr	798(ra) # 8000393c <iput>
  end_op();
    80005626:	fffff097          	auipc	ra,0xfffff
    8000562a:	b9c080e7          	jalr	-1124(ra) # 800041c2 <end_op>
  return 0;
    8000562e:	4781                	li	a5,0
    80005630:	a085                	j	80005690 <sys_link+0x13c>
    end_op();
    80005632:	fffff097          	auipc	ra,0xfffff
    80005636:	b90080e7          	jalr	-1136(ra) # 800041c2 <end_op>
    return -1;
    8000563a:	57fd                	li	a5,-1
    8000563c:	a891                	j	80005690 <sys_link+0x13c>
    iunlockput(ip);
    8000563e:	8526                	mv	a0,s1
    80005640:	ffffe097          	auipc	ra,0xffffe
    80005644:	3a4080e7          	jalr	932(ra) # 800039e4 <iunlockput>
    end_op();
    80005648:	fffff097          	auipc	ra,0xfffff
    8000564c:	b7a080e7          	jalr	-1158(ra) # 800041c2 <end_op>
    return -1;
    80005650:	57fd                	li	a5,-1
    80005652:	a83d                	j	80005690 <sys_link+0x13c>
    iunlockput(dp);
    80005654:	854a                	mv	a0,s2
    80005656:	ffffe097          	auipc	ra,0xffffe
    8000565a:	38e080e7          	jalr	910(ra) # 800039e4 <iunlockput>
  ilock(ip);
    8000565e:	8526                	mv	a0,s1
    80005660:	ffffe097          	auipc	ra,0xffffe
    80005664:	122080e7          	jalr	290(ra) # 80003782 <ilock>
  ip->nlink--;
    80005668:	04a4d783          	lhu	a5,74(s1)
    8000566c:	37fd                	addiw	a5,a5,-1
    8000566e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005672:	8526                	mv	a0,s1
    80005674:	ffffe097          	auipc	ra,0xffffe
    80005678:	044080e7          	jalr	68(ra) # 800036b8 <iupdate>
  iunlockput(ip);
    8000567c:	8526                	mv	a0,s1
    8000567e:	ffffe097          	auipc	ra,0xffffe
    80005682:	366080e7          	jalr	870(ra) # 800039e4 <iunlockput>
  end_op();
    80005686:	fffff097          	auipc	ra,0xfffff
    8000568a:	b3c080e7          	jalr	-1220(ra) # 800041c2 <end_op>
  return -1;
    8000568e:	57fd                	li	a5,-1
}
    80005690:	853e                	mv	a0,a5
    80005692:	70b2                	ld	ra,296(sp)
    80005694:	7412                	ld	s0,288(sp)
    80005696:	64f2                	ld	s1,280(sp)
    80005698:	6952                	ld	s2,272(sp)
    8000569a:	6155                	addi	sp,sp,304
    8000569c:	8082                	ret

000000008000569e <sys_unlink>:
{
    8000569e:	7151                	addi	sp,sp,-240
    800056a0:	f586                	sd	ra,232(sp)
    800056a2:	f1a2                	sd	s0,224(sp)
    800056a4:	eda6                	sd	s1,216(sp)
    800056a6:	e9ca                	sd	s2,208(sp)
    800056a8:	e5ce                	sd	s3,200(sp)
    800056aa:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800056ac:	08000613          	li	a2,128
    800056b0:	f3040593          	addi	a1,s0,-208
    800056b4:	4501                	li	a0,0
    800056b6:	ffffd097          	auipc	ra,0xffffd
    800056ba:	576080e7          	jalr	1398(ra) # 80002c2c <argstr>
    800056be:	18054163          	bltz	a0,80005840 <sys_unlink+0x1a2>
  begin_op();
    800056c2:	fffff097          	auipc	ra,0xfffff
    800056c6:	a80080e7          	jalr	-1408(ra) # 80004142 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800056ca:	fb040593          	addi	a1,s0,-80
    800056ce:	f3040513          	addi	a0,s0,-208
    800056d2:	fffff097          	auipc	ra,0xfffff
    800056d6:	882080e7          	jalr	-1918(ra) # 80003f54 <nameiparent>
    800056da:	84aa                	mv	s1,a0
    800056dc:	c979                	beqz	a0,800057b2 <sys_unlink+0x114>
  ilock(dp);
    800056de:	ffffe097          	auipc	ra,0xffffe
    800056e2:	0a4080e7          	jalr	164(ra) # 80003782 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800056e6:	00003597          	auipc	a1,0x3
    800056ea:	ff258593          	addi	a1,a1,-14 # 800086d8 <syscalls+0x2c8>
    800056ee:	fb040513          	addi	a0,s0,-80
    800056f2:	ffffe097          	auipc	ra,0xffffe
    800056f6:	558080e7          	jalr	1368(ra) # 80003c4a <namecmp>
    800056fa:	14050a63          	beqz	a0,8000584e <sys_unlink+0x1b0>
    800056fe:	00003597          	auipc	a1,0x3
    80005702:	fe258593          	addi	a1,a1,-30 # 800086e0 <syscalls+0x2d0>
    80005706:	fb040513          	addi	a0,s0,-80
    8000570a:	ffffe097          	auipc	ra,0xffffe
    8000570e:	540080e7          	jalr	1344(ra) # 80003c4a <namecmp>
    80005712:	12050e63          	beqz	a0,8000584e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005716:	f2c40613          	addi	a2,s0,-212
    8000571a:	fb040593          	addi	a1,s0,-80
    8000571e:	8526                	mv	a0,s1
    80005720:	ffffe097          	auipc	ra,0xffffe
    80005724:	544080e7          	jalr	1348(ra) # 80003c64 <dirlookup>
    80005728:	892a                	mv	s2,a0
    8000572a:	12050263          	beqz	a0,8000584e <sys_unlink+0x1b0>
  ilock(ip);
    8000572e:	ffffe097          	auipc	ra,0xffffe
    80005732:	054080e7          	jalr	84(ra) # 80003782 <ilock>
  if(ip->nlink < 1)
    80005736:	04a91783          	lh	a5,74(s2)
    8000573a:	08f05263          	blez	a5,800057be <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000573e:	04491703          	lh	a4,68(s2)
    80005742:	4785                	li	a5,1
    80005744:	08f70563          	beq	a4,a5,800057ce <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005748:	4641                	li	a2,16
    8000574a:	4581                	li	a1,0
    8000574c:	fc040513          	addi	a0,s0,-64
    80005750:	ffffb097          	auipc	ra,0xffffb
    80005754:	5bc080e7          	jalr	1468(ra) # 80000d0c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005758:	4741                	li	a4,16
    8000575a:	f2c42683          	lw	a3,-212(s0)
    8000575e:	fc040613          	addi	a2,s0,-64
    80005762:	4581                	li	a1,0
    80005764:	8526                	mv	a0,s1
    80005766:	ffffe097          	auipc	ra,0xffffe
    8000576a:	3c8080e7          	jalr	968(ra) # 80003b2e <writei>
    8000576e:	47c1                	li	a5,16
    80005770:	0af51563          	bne	a0,a5,8000581a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005774:	04491703          	lh	a4,68(s2)
    80005778:	4785                	li	a5,1
    8000577a:	0af70863          	beq	a4,a5,8000582a <sys_unlink+0x18c>
  iunlockput(dp);
    8000577e:	8526                	mv	a0,s1
    80005780:	ffffe097          	auipc	ra,0xffffe
    80005784:	264080e7          	jalr	612(ra) # 800039e4 <iunlockput>
  ip->nlink--;
    80005788:	04a95783          	lhu	a5,74(s2)
    8000578c:	37fd                	addiw	a5,a5,-1
    8000578e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005792:	854a                	mv	a0,s2
    80005794:	ffffe097          	auipc	ra,0xffffe
    80005798:	f24080e7          	jalr	-220(ra) # 800036b8 <iupdate>
  iunlockput(ip);
    8000579c:	854a                	mv	a0,s2
    8000579e:	ffffe097          	auipc	ra,0xffffe
    800057a2:	246080e7          	jalr	582(ra) # 800039e4 <iunlockput>
  end_op();
    800057a6:	fffff097          	auipc	ra,0xfffff
    800057aa:	a1c080e7          	jalr	-1508(ra) # 800041c2 <end_op>
  return 0;
    800057ae:	4501                	li	a0,0
    800057b0:	a84d                	j	80005862 <sys_unlink+0x1c4>
    end_op();
    800057b2:	fffff097          	auipc	ra,0xfffff
    800057b6:	a10080e7          	jalr	-1520(ra) # 800041c2 <end_op>
    return -1;
    800057ba:	557d                	li	a0,-1
    800057bc:	a05d                	j	80005862 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800057be:	00003517          	auipc	a0,0x3
    800057c2:	f4a50513          	addi	a0,a0,-182 # 80008708 <syscalls+0x2f8>
    800057c6:	ffffb097          	auipc	ra,0xffffb
    800057ca:	d82080e7          	jalr	-638(ra) # 80000548 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800057ce:	04c92703          	lw	a4,76(s2)
    800057d2:	02000793          	li	a5,32
    800057d6:	f6e7f9e3          	bgeu	a5,a4,80005748 <sys_unlink+0xaa>
    800057da:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800057de:	4741                	li	a4,16
    800057e0:	86ce                	mv	a3,s3
    800057e2:	f1840613          	addi	a2,s0,-232
    800057e6:	4581                	li	a1,0
    800057e8:	854a                	mv	a0,s2
    800057ea:	ffffe097          	auipc	ra,0xffffe
    800057ee:	24c080e7          	jalr	588(ra) # 80003a36 <readi>
    800057f2:	47c1                	li	a5,16
    800057f4:	00f51b63          	bne	a0,a5,8000580a <sys_unlink+0x16c>
    if(de.inum != 0)
    800057f8:	f1845783          	lhu	a5,-232(s0)
    800057fc:	e7a1                	bnez	a5,80005844 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800057fe:	29c1                	addiw	s3,s3,16
    80005800:	04c92783          	lw	a5,76(s2)
    80005804:	fcf9ede3          	bltu	s3,a5,800057de <sys_unlink+0x140>
    80005808:	b781                	j	80005748 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000580a:	00003517          	auipc	a0,0x3
    8000580e:	f1650513          	addi	a0,a0,-234 # 80008720 <syscalls+0x310>
    80005812:	ffffb097          	auipc	ra,0xffffb
    80005816:	d36080e7          	jalr	-714(ra) # 80000548 <panic>
    panic("unlink: writei");
    8000581a:	00003517          	auipc	a0,0x3
    8000581e:	f1e50513          	addi	a0,a0,-226 # 80008738 <syscalls+0x328>
    80005822:	ffffb097          	auipc	ra,0xffffb
    80005826:	d26080e7          	jalr	-730(ra) # 80000548 <panic>
    dp->nlink--;
    8000582a:	04a4d783          	lhu	a5,74(s1)
    8000582e:	37fd                	addiw	a5,a5,-1
    80005830:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005834:	8526                	mv	a0,s1
    80005836:	ffffe097          	auipc	ra,0xffffe
    8000583a:	e82080e7          	jalr	-382(ra) # 800036b8 <iupdate>
    8000583e:	b781                	j	8000577e <sys_unlink+0xe0>
    return -1;
    80005840:	557d                	li	a0,-1
    80005842:	a005                	j	80005862 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005844:	854a                	mv	a0,s2
    80005846:	ffffe097          	auipc	ra,0xffffe
    8000584a:	19e080e7          	jalr	414(ra) # 800039e4 <iunlockput>
  iunlockput(dp);
    8000584e:	8526                	mv	a0,s1
    80005850:	ffffe097          	auipc	ra,0xffffe
    80005854:	194080e7          	jalr	404(ra) # 800039e4 <iunlockput>
  end_op();
    80005858:	fffff097          	auipc	ra,0xfffff
    8000585c:	96a080e7          	jalr	-1686(ra) # 800041c2 <end_op>
  return -1;
    80005860:	557d                	li	a0,-1
}
    80005862:	70ae                	ld	ra,232(sp)
    80005864:	740e                	ld	s0,224(sp)
    80005866:	64ee                	ld	s1,216(sp)
    80005868:	694e                	ld	s2,208(sp)
    8000586a:	69ae                	ld	s3,200(sp)
    8000586c:	616d                	addi	sp,sp,240
    8000586e:	8082                	ret

0000000080005870 <sys_open>:

uint64
sys_open(void)
{
    80005870:	7131                	addi	sp,sp,-192
    80005872:	fd06                	sd	ra,184(sp)
    80005874:	f922                	sd	s0,176(sp)
    80005876:	f526                	sd	s1,168(sp)
    80005878:	f14a                	sd	s2,160(sp)
    8000587a:	ed4e                	sd	s3,152(sp)
    8000587c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000587e:	08000613          	li	a2,128
    80005882:	f5040593          	addi	a1,s0,-176
    80005886:	4501                	li	a0,0
    80005888:	ffffd097          	auipc	ra,0xffffd
    8000588c:	3a4080e7          	jalr	932(ra) # 80002c2c <argstr>
    return -1;
    80005890:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005892:	0c054163          	bltz	a0,80005954 <sys_open+0xe4>
    80005896:	f4c40593          	addi	a1,s0,-180
    8000589a:	4505                	li	a0,1
    8000589c:	ffffd097          	auipc	ra,0xffffd
    800058a0:	34c080e7          	jalr	844(ra) # 80002be8 <argint>
    800058a4:	0a054863          	bltz	a0,80005954 <sys_open+0xe4>

  begin_op();
    800058a8:	fffff097          	auipc	ra,0xfffff
    800058ac:	89a080e7          	jalr	-1894(ra) # 80004142 <begin_op>

  if(omode & O_CREATE){
    800058b0:	f4c42783          	lw	a5,-180(s0)
    800058b4:	2007f793          	andi	a5,a5,512
    800058b8:	cbdd                	beqz	a5,8000596e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    800058ba:	4681                	li	a3,0
    800058bc:	4601                	li	a2,0
    800058be:	4589                	li	a1,2
    800058c0:	f5040513          	addi	a0,s0,-176
    800058c4:	00000097          	auipc	ra,0x0
    800058c8:	972080e7          	jalr	-1678(ra) # 80005236 <create>
    800058cc:	892a                	mv	s2,a0
    if(ip == 0){
    800058ce:	c959                	beqz	a0,80005964 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800058d0:	04491703          	lh	a4,68(s2)
    800058d4:	478d                	li	a5,3
    800058d6:	00f71763          	bne	a4,a5,800058e4 <sys_open+0x74>
    800058da:	04695703          	lhu	a4,70(s2)
    800058de:	47a5                	li	a5,9
    800058e0:	0ce7ec63          	bltu	a5,a4,800059b8 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800058e4:	fffff097          	auipc	ra,0xfffff
    800058e8:	c74080e7          	jalr	-908(ra) # 80004558 <filealloc>
    800058ec:	89aa                	mv	s3,a0
    800058ee:	10050263          	beqz	a0,800059f2 <sys_open+0x182>
    800058f2:	00000097          	auipc	ra,0x0
    800058f6:	902080e7          	jalr	-1790(ra) # 800051f4 <fdalloc>
    800058fa:	84aa                	mv	s1,a0
    800058fc:	0e054663          	bltz	a0,800059e8 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005900:	04491703          	lh	a4,68(s2)
    80005904:	478d                	li	a5,3
    80005906:	0cf70463          	beq	a4,a5,800059ce <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000590a:	4789                	li	a5,2
    8000590c:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005910:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005914:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005918:	f4c42783          	lw	a5,-180(s0)
    8000591c:	0017c713          	xori	a4,a5,1
    80005920:	8b05                	andi	a4,a4,1
    80005922:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005926:	0037f713          	andi	a4,a5,3
    8000592a:	00e03733          	snez	a4,a4
    8000592e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005932:	4007f793          	andi	a5,a5,1024
    80005936:	c791                	beqz	a5,80005942 <sys_open+0xd2>
    80005938:	04491703          	lh	a4,68(s2)
    8000593c:	4789                	li	a5,2
    8000593e:	08f70f63          	beq	a4,a5,800059dc <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005942:	854a                	mv	a0,s2
    80005944:	ffffe097          	auipc	ra,0xffffe
    80005948:	f00080e7          	jalr	-256(ra) # 80003844 <iunlock>
  end_op();
    8000594c:	fffff097          	auipc	ra,0xfffff
    80005950:	876080e7          	jalr	-1930(ra) # 800041c2 <end_op>

  return fd;
}
    80005954:	8526                	mv	a0,s1
    80005956:	70ea                	ld	ra,184(sp)
    80005958:	744a                	ld	s0,176(sp)
    8000595a:	74aa                	ld	s1,168(sp)
    8000595c:	790a                	ld	s2,160(sp)
    8000595e:	69ea                	ld	s3,152(sp)
    80005960:	6129                	addi	sp,sp,192
    80005962:	8082                	ret
      end_op();
    80005964:	fffff097          	auipc	ra,0xfffff
    80005968:	85e080e7          	jalr	-1954(ra) # 800041c2 <end_op>
      return -1;
    8000596c:	b7e5                	j	80005954 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    8000596e:	f5040513          	addi	a0,s0,-176
    80005972:	ffffe097          	auipc	ra,0xffffe
    80005976:	5c4080e7          	jalr	1476(ra) # 80003f36 <namei>
    8000597a:	892a                	mv	s2,a0
    8000597c:	c905                	beqz	a0,800059ac <sys_open+0x13c>
    ilock(ip);
    8000597e:	ffffe097          	auipc	ra,0xffffe
    80005982:	e04080e7          	jalr	-508(ra) # 80003782 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005986:	04491703          	lh	a4,68(s2)
    8000598a:	4785                	li	a5,1
    8000598c:	f4f712e3          	bne	a4,a5,800058d0 <sys_open+0x60>
    80005990:	f4c42783          	lw	a5,-180(s0)
    80005994:	dba1                	beqz	a5,800058e4 <sys_open+0x74>
      iunlockput(ip);
    80005996:	854a                	mv	a0,s2
    80005998:	ffffe097          	auipc	ra,0xffffe
    8000599c:	04c080e7          	jalr	76(ra) # 800039e4 <iunlockput>
      end_op();
    800059a0:	fffff097          	auipc	ra,0xfffff
    800059a4:	822080e7          	jalr	-2014(ra) # 800041c2 <end_op>
      return -1;
    800059a8:	54fd                	li	s1,-1
    800059aa:	b76d                	j	80005954 <sys_open+0xe4>
      end_op();
    800059ac:	fffff097          	auipc	ra,0xfffff
    800059b0:	816080e7          	jalr	-2026(ra) # 800041c2 <end_op>
      return -1;
    800059b4:	54fd                	li	s1,-1
    800059b6:	bf79                	j	80005954 <sys_open+0xe4>
    iunlockput(ip);
    800059b8:	854a                	mv	a0,s2
    800059ba:	ffffe097          	auipc	ra,0xffffe
    800059be:	02a080e7          	jalr	42(ra) # 800039e4 <iunlockput>
    end_op();
    800059c2:	fffff097          	auipc	ra,0xfffff
    800059c6:	800080e7          	jalr	-2048(ra) # 800041c2 <end_op>
    return -1;
    800059ca:	54fd                	li	s1,-1
    800059cc:	b761                	j	80005954 <sys_open+0xe4>
    f->type = FD_DEVICE;
    800059ce:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800059d2:	04691783          	lh	a5,70(s2)
    800059d6:	02f99223          	sh	a5,36(s3)
    800059da:	bf2d                	j	80005914 <sys_open+0xa4>
    itrunc(ip);
    800059dc:	854a                	mv	a0,s2
    800059de:	ffffe097          	auipc	ra,0xffffe
    800059e2:	eb2080e7          	jalr	-334(ra) # 80003890 <itrunc>
    800059e6:	bfb1                	j	80005942 <sys_open+0xd2>
      fileclose(f);
    800059e8:	854e                	mv	a0,s3
    800059ea:	fffff097          	auipc	ra,0xfffff
    800059ee:	c2a080e7          	jalr	-982(ra) # 80004614 <fileclose>
    iunlockput(ip);
    800059f2:	854a                	mv	a0,s2
    800059f4:	ffffe097          	auipc	ra,0xffffe
    800059f8:	ff0080e7          	jalr	-16(ra) # 800039e4 <iunlockput>
    end_op();
    800059fc:	ffffe097          	auipc	ra,0xffffe
    80005a00:	7c6080e7          	jalr	1990(ra) # 800041c2 <end_op>
    return -1;
    80005a04:	54fd                	li	s1,-1
    80005a06:	b7b9                	j	80005954 <sys_open+0xe4>

0000000080005a08 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005a08:	7175                	addi	sp,sp,-144
    80005a0a:	e506                	sd	ra,136(sp)
    80005a0c:	e122                	sd	s0,128(sp)
    80005a0e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005a10:	ffffe097          	auipc	ra,0xffffe
    80005a14:	732080e7          	jalr	1842(ra) # 80004142 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005a18:	08000613          	li	a2,128
    80005a1c:	f7040593          	addi	a1,s0,-144
    80005a20:	4501                	li	a0,0
    80005a22:	ffffd097          	auipc	ra,0xffffd
    80005a26:	20a080e7          	jalr	522(ra) # 80002c2c <argstr>
    80005a2a:	02054963          	bltz	a0,80005a5c <sys_mkdir+0x54>
    80005a2e:	4681                	li	a3,0
    80005a30:	4601                	li	a2,0
    80005a32:	4585                	li	a1,1
    80005a34:	f7040513          	addi	a0,s0,-144
    80005a38:	fffff097          	auipc	ra,0xfffff
    80005a3c:	7fe080e7          	jalr	2046(ra) # 80005236 <create>
    80005a40:	cd11                	beqz	a0,80005a5c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005a42:	ffffe097          	auipc	ra,0xffffe
    80005a46:	fa2080e7          	jalr	-94(ra) # 800039e4 <iunlockput>
  end_op();
    80005a4a:	ffffe097          	auipc	ra,0xffffe
    80005a4e:	778080e7          	jalr	1912(ra) # 800041c2 <end_op>
  return 0;
    80005a52:	4501                	li	a0,0
}
    80005a54:	60aa                	ld	ra,136(sp)
    80005a56:	640a                	ld	s0,128(sp)
    80005a58:	6149                	addi	sp,sp,144
    80005a5a:	8082                	ret
    end_op();
    80005a5c:	ffffe097          	auipc	ra,0xffffe
    80005a60:	766080e7          	jalr	1894(ra) # 800041c2 <end_op>
    return -1;
    80005a64:	557d                	li	a0,-1
    80005a66:	b7fd                	j	80005a54 <sys_mkdir+0x4c>

0000000080005a68 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005a68:	7135                	addi	sp,sp,-160
    80005a6a:	ed06                	sd	ra,152(sp)
    80005a6c:	e922                	sd	s0,144(sp)
    80005a6e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005a70:	ffffe097          	auipc	ra,0xffffe
    80005a74:	6d2080e7          	jalr	1746(ra) # 80004142 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005a78:	08000613          	li	a2,128
    80005a7c:	f7040593          	addi	a1,s0,-144
    80005a80:	4501                	li	a0,0
    80005a82:	ffffd097          	auipc	ra,0xffffd
    80005a86:	1aa080e7          	jalr	426(ra) # 80002c2c <argstr>
    80005a8a:	04054a63          	bltz	a0,80005ade <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005a8e:	f6c40593          	addi	a1,s0,-148
    80005a92:	4505                	li	a0,1
    80005a94:	ffffd097          	auipc	ra,0xffffd
    80005a98:	154080e7          	jalr	340(ra) # 80002be8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005a9c:	04054163          	bltz	a0,80005ade <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005aa0:	f6840593          	addi	a1,s0,-152
    80005aa4:	4509                	li	a0,2
    80005aa6:	ffffd097          	auipc	ra,0xffffd
    80005aaa:	142080e7          	jalr	322(ra) # 80002be8 <argint>
     argint(1, &major) < 0 ||
    80005aae:	02054863          	bltz	a0,80005ade <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005ab2:	f6841683          	lh	a3,-152(s0)
    80005ab6:	f6c41603          	lh	a2,-148(s0)
    80005aba:	458d                	li	a1,3
    80005abc:	f7040513          	addi	a0,s0,-144
    80005ac0:	fffff097          	auipc	ra,0xfffff
    80005ac4:	776080e7          	jalr	1910(ra) # 80005236 <create>
     argint(2, &minor) < 0 ||
    80005ac8:	c919                	beqz	a0,80005ade <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005aca:	ffffe097          	auipc	ra,0xffffe
    80005ace:	f1a080e7          	jalr	-230(ra) # 800039e4 <iunlockput>
  end_op();
    80005ad2:	ffffe097          	auipc	ra,0xffffe
    80005ad6:	6f0080e7          	jalr	1776(ra) # 800041c2 <end_op>
  return 0;
    80005ada:	4501                	li	a0,0
    80005adc:	a031                	j	80005ae8 <sys_mknod+0x80>
    end_op();
    80005ade:	ffffe097          	auipc	ra,0xffffe
    80005ae2:	6e4080e7          	jalr	1764(ra) # 800041c2 <end_op>
    return -1;
    80005ae6:	557d                	li	a0,-1
}
    80005ae8:	60ea                	ld	ra,152(sp)
    80005aea:	644a                	ld	s0,144(sp)
    80005aec:	610d                	addi	sp,sp,160
    80005aee:	8082                	ret

0000000080005af0 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005af0:	7135                	addi	sp,sp,-160
    80005af2:	ed06                	sd	ra,152(sp)
    80005af4:	e922                	sd	s0,144(sp)
    80005af6:	e526                	sd	s1,136(sp)
    80005af8:	e14a                	sd	s2,128(sp)
    80005afa:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005afc:	ffffc097          	auipc	ra,0xffffc
    80005b00:	f8e080e7          	jalr	-114(ra) # 80001a8a <myproc>
    80005b04:	892a                	mv	s2,a0
  
  begin_op();
    80005b06:	ffffe097          	auipc	ra,0xffffe
    80005b0a:	63c080e7          	jalr	1596(ra) # 80004142 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005b0e:	08000613          	li	a2,128
    80005b12:	f6040593          	addi	a1,s0,-160
    80005b16:	4501                	li	a0,0
    80005b18:	ffffd097          	auipc	ra,0xffffd
    80005b1c:	114080e7          	jalr	276(ra) # 80002c2c <argstr>
    80005b20:	04054b63          	bltz	a0,80005b76 <sys_chdir+0x86>
    80005b24:	f6040513          	addi	a0,s0,-160
    80005b28:	ffffe097          	auipc	ra,0xffffe
    80005b2c:	40e080e7          	jalr	1038(ra) # 80003f36 <namei>
    80005b30:	84aa                	mv	s1,a0
    80005b32:	c131                	beqz	a0,80005b76 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005b34:	ffffe097          	auipc	ra,0xffffe
    80005b38:	c4e080e7          	jalr	-946(ra) # 80003782 <ilock>
  if(ip->type != T_DIR){
    80005b3c:	04449703          	lh	a4,68(s1)
    80005b40:	4785                	li	a5,1
    80005b42:	04f71063          	bne	a4,a5,80005b82 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005b46:	8526                	mv	a0,s1
    80005b48:	ffffe097          	auipc	ra,0xffffe
    80005b4c:	cfc080e7          	jalr	-772(ra) # 80003844 <iunlock>
  iput(p->cwd);
    80005b50:	16093503          	ld	a0,352(s2)
    80005b54:	ffffe097          	auipc	ra,0xffffe
    80005b58:	de8080e7          	jalr	-536(ra) # 8000393c <iput>
  end_op();
    80005b5c:	ffffe097          	auipc	ra,0xffffe
    80005b60:	666080e7          	jalr	1638(ra) # 800041c2 <end_op>
  p->cwd = ip;
    80005b64:	16993023          	sd	s1,352(s2)
  return 0;
    80005b68:	4501                	li	a0,0
}
    80005b6a:	60ea                	ld	ra,152(sp)
    80005b6c:	644a                	ld	s0,144(sp)
    80005b6e:	64aa                	ld	s1,136(sp)
    80005b70:	690a                	ld	s2,128(sp)
    80005b72:	610d                	addi	sp,sp,160
    80005b74:	8082                	ret
    end_op();
    80005b76:	ffffe097          	auipc	ra,0xffffe
    80005b7a:	64c080e7          	jalr	1612(ra) # 800041c2 <end_op>
    return -1;
    80005b7e:	557d                	li	a0,-1
    80005b80:	b7ed                	j	80005b6a <sys_chdir+0x7a>
    iunlockput(ip);
    80005b82:	8526                	mv	a0,s1
    80005b84:	ffffe097          	auipc	ra,0xffffe
    80005b88:	e60080e7          	jalr	-416(ra) # 800039e4 <iunlockput>
    end_op();
    80005b8c:	ffffe097          	auipc	ra,0xffffe
    80005b90:	636080e7          	jalr	1590(ra) # 800041c2 <end_op>
    return -1;
    80005b94:	557d                	li	a0,-1
    80005b96:	bfd1                	j	80005b6a <sys_chdir+0x7a>

0000000080005b98 <sys_exec>:

uint64
sys_exec(void)
{
    80005b98:	7145                	addi	sp,sp,-464
    80005b9a:	e786                	sd	ra,456(sp)
    80005b9c:	e3a2                	sd	s0,448(sp)
    80005b9e:	ff26                	sd	s1,440(sp)
    80005ba0:	fb4a                	sd	s2,432(sp)
    80005ba2:	f74e                	sd	s3,424(sp)
    80005ba4:	f352                	sd	s4,416(sp)
    80005ba6:	ef56                	sd	s5,408(sp)
    80005ba8:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005baa:	08000613          	li	a2,128
    80005bae:	f4040593          	addi	a1,s0,-192
    80005bb2:	4501                	li	a0,0
    80005bb4:	ffffd097          	auipc	ra,0xffffd
    80005bb8:	078080e7          	jalr	120(ra) # 80002c2c <argstr>
    return -1;
    80005bbc:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005bbe:	0c054a63          	bltz	a0,80005c92 <sys_exec+0xfa>
    80005bc2:	e3840593          	addi	a1,s0,-456
    80005bc6:	4505                	li	a0,1
    80005bc8:	ffffd097          	auipc	ra,0xffffd
    80005bcc:	042080e7          	jalr	66(ra) # 80002c0a <argaddr>
    80005bd0:	0c054163          	bltz	a0,80005c92 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005bd4:	10000613          	li	a2,256
    80005bd8:	4581                	li	a1,0
    80005bda:	e4040513          	addi	a0,s0,-448
    80005bde:	ffffb097          	auipc	ra,0xffffb
    80005be2:	12e080e7          	jalr	302(ra) # 80000d0c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005be6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005bea:	89a6                	mv	s3,s1
    80005bec:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005bee:	02000a13          	li	s4,32
    80005bf2:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005bf6:	00391513          	slli	a0,s2,0x3
    80005bfa:	e3040593          	addi	a1,s0,-464
    80005bfe:	e3843783          	ld	a5,-456(s0)
    80005c02:	953e                	add	a0,a0,a5
    80005c04:	ffffd097          	auipc	ra,0xffffd
    80005c08:	f4a080e7          	jalr	-182(ra) # 80002b4e <fetchaddr>
    80005c0c:	02054a63          	bltz	a0,80005c40 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005c10:	e3043783          	ld	a5,-464(s0)
    80005c14:	c3b9                	beqz	a5,80005c5a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005c16:	ffffb097          	auipc	ra,0xffffb
    80005c1a:	f0a080e7          	jalr	-246(ra) # 80000b20 <kalloc>
    80005c1e:	85aa                	mv	a1,a0
    80005c20:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005c24:	cd11                	beqz	a0,80005c40 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005c26:	6605                	lui	a2,0x1
    80005c28:	e3043503          	ld	a0,-464(s0)
    80005c2c:	ffffd097          	auipc	ra,0xffffd
    80005c30:	f74080e7          	jalr	-140(ra) # 80002ba0 <fetchstr>
    80005c34:	00054663          	bltz	a0,80005c40 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005c38:	0905                	addi	s2,s2,1
    80005c3a:	09a1                	addi	s3,s3,8
    80005c3c:	fb491be3          	bne	s2,s4,80005bf2 <sys_exec+0x5a>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    kfree(argv[i]);
  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c40:	10048913          	addi	s2,s1,256
    80005c44:	6088                	ld	a0,0(s1)
    80005c46:	c529                	beqz	a0,80005c90 <sys_exec+0xf8>
    kfree(argv[i]);
    80005c48:	ffffb097          	auipc	ra,0xffffb
    80005c4c:	ddc080e7          	jalr	-548(ra) # 80000a24 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c50:	04a1                	addi	s1,s1,8
    80005c52:	ff2499e3          	bne	s1,s2,80005c44 <sys_exec+0xac>
  return -1;
    80005c56:	597d                	li	s2,-1
    80005c58:	a82d                	j	80005c92 <sys_exec+0xfa>
      argv[i] = 0;
    80005c5a:	0a8e                	slli	s5,s5,0x3
    80005c5c:	fc040793          	addi	a5,s0,-64
    80005c60:	9abe                	add	s5,s5,a5
    80005c62:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005c66:	e4040593          	addi	a1,s0,-448
    80005c6a:	f4040513          	addi	a0,s0,-192
    80005c6e:	fffff097          	auipc	ra,0xfffff
    80005c72:	16c080e7          	jalr	364(ra) # 80004dda <exec>
    80005c76:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c78:	10048993          	addi	s3,s1,256
    80005c7c:	6088                	ld	a0,0(s1)
    80005c7e:	c911                	beqz	a0,80005c92 <sys_exec+0xfa>
    kfree(argv[i]);
    80005c80:	ffffb097          	auipc	ra,0xffffb
    80005c84:	da4080e7          	jalr	-604(ra) # 80000a24 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c88:	04a1                	addi	s1,s1,8
    80005c8a:	ff3499e3          	bne	s1,s3,80005c7c <sys_exec+0xe4>
    80005c8e:	a011                	j	80005c92 <sys_exec+0xfa>
  return -1;
    80005c90:	597d                	li	s2,-1
}
    80005c92:	854a                	mv	a0,s2
    80005c94:	60be                	ld	ra,456(sp)
    80005c96:	641e                	ld	s0,448(sp)
    80005c98:	74fa                	ld	s1,440(sp)
    80005c9a:	795a                	ld	s2,432(sp)
    80005c9c:	79ba                	ld	s3,424(sp)
    80005c9e:	7a1a                	ld	s4,416(sp)
    80005ca0:	6afa                	ld	s5,408(sp)
    80005ca2:	6179                	addi	sp,sp,464
    80005ca4:	8082                	ret

0000000080005ca6 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005ca6:	7139                	addi	sp,sp,-64
    80005ca8:	fc06                	sd	ra,56(sp)
    80005caa:	f822                	sd	s0,48(sp)
    80005cac:	f426                	sd	s1,40(sp)
    80005cae:	f04a                	sd	s2,32(sp)
    80005cb0:	0080                	addi	s0,sp,64
    uint64 fdarray; // user pointer to array of two integers
    struct file *rf, *wf;
    int fd0, fd1;
    struct proc *p = myproc();
    80005cb2:	ffffc097          	auipc	ra,0xffffc
    80005cb6:	dd8080e7          	jalr	-552(ra) # 80001a8a <myproc>
    80005cba:	84aa                	mv	s1,a0

    if(argaddr(0, &fdarray) < 0)
    80005cbc:	fd840593          	addi	a1,s0,-40
    80005cc0:	4501                	li	a0,0
    80005cc2:	ffffd097          	auipc	ra,0xffffd
    80005cc6:	f48080e7          	jalr	-184(ra) # 80002c0a <argaddr>
        return -1;
    80005cca:	57fd                	li	a5,-1
    if(argaddr(0, &fdarray) < 0)
    80005ccc:	16054563          	bltz	a0,80005e36 <sys_pipe+0x190>
    if(fdarray > myproc()->sz)
    80005cd0:	ffffc097          	auipc	ra,0xffffc
    80005cd4:	dba080e7          	jalr	-582(ra) # 80001a8a <myproc>
    80005cd8:	6934                	ld	a3,80(a0)
    80005cda:	fd843703          	ld	a4,-40(s0)
        return -1;
    80005cde:	57fd                	li	a5,-1
    if(fdarray > myproc()->sz)
    80005ce0:	14e6eb63          	bltu	a3,a4,80005e36 <sys_pipe+0x190>
    if(walkaddr(myproc()->pagetable,fdarray) == 0){
    80005ce4:	ffffc097          	auipc	ra,0xffffc
    80005ce8:	da6080e7          	jalr	-602(ra) # 80001a8a <myproc>
    80005cec:	fd843583          	ld	a1,-40(s0)
    80005cf0:	7128                	ld	a0,96(a0)
    80005cf2:	ffffb097          	auipc	ra,0xffffb
    80005cf6:	45e080e7          	jalr	1118(ra) # 80001150 <walkaddr>
    80005cfa:	e121                	bnez	a0,80005d3a <sys_pipe+0x94>
        char* mem = kalloc();
    80005cfc:	ffffb097          	auipc	ra,0xffffb
    80005d00:	e24080e7          	jalr	-476(ra) # 80000b20 <kalloc>
    80005d04:	892a                	mv	s2,a0
        if(mappages(myproc()->pagetable,PGROUNDDOWN(fdarray),PGSIZE,(uint64)mem,PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80005d06:	ffffc097          	auipc	ra,0xffffc
    80005d0a:	d84080e7          	jalr	-636(ra) # 80001a8a <myproc>
    80005d0e:	4779                	li	a4,30
    80005d10:	86ca                	mv	a3,s2
    80005d12:	6605                	lui	a2,0x1
    80005d14:	75fd                	lui	a1,0xfffff
    80005d16:	fd843783          	ld	a5,-40(s0)
    80005d1a:	8dfd                	and	a1,a1,a5
    80005d1c:	7128                	ld	a0,96(a0)
    80005d1e:	ffffb097          	auipc	ra,0xffffb
    80005d22:	4d2080e7          	jalr	1234(ra) # 800011f0 <mappages>
    80005d26:	e169                	bnez	a0,80005de8 <sys_pipe+0x142>
            kfree(mem);
            return -1;
        }
        if(fdarray > myproc()->maxva)
    80005d28:	ffffc097          	auipc	ra,0xffffc
    80005d2c:	d62080e7          	jalr	-670(ra) # 80001a8a <myproc>
    80005d30:	fd843903          	ld	s2,-40(s0)
    80005d34:	6d3c                	ld	a5,88(a0)
    80005d36:	0d27e063          	bltu	a5,s2,80005df6 <sys_pipe+0x150>
            myproc()->maxva = fdarray + PGSIZE;
    }
    if(pipealloc(&rf, &wf) < 0)
    80005d3a:	fc840593          	addi	a1,s0,-56
    80005d3e:	fd040513          	addi	a0,s0,-48
    80005d42:	fffff097          	auipc	ra,0xfffff
    80005d46:	d3e080e7          	jalr	-706(ra) # 80004a80 <pipealloc>
        return -1;
    80005d4a:	57fd                	li	a5,-1
    if(pipealloc(&rf, &wf) < 0)
    80005d4c:	0e054563          	bltz	a0,80005e36 <sys_pipe+0x190>
    fd0 = -1;
    80005d50:	fcf42223          	sw	a5,-60(s0)
    if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005d54:	fd043503          	ld	a0,-48(s0)
    80005d58:	fffff097          	auipc	ra,0xfffff
    80005d5c:	49c080e7          	jalr	1180(ra) # 800051f4 <fdalloc>
    80005d60:	fca42223          	sw	a0,-60(s0)
    80005d64:	0a054c63          	bltz	a0,80005e1c <sys_pipe+0x176>
    80005d68:	fc843503          	ld	a0,-56(s0)
    80005d6c:	fffff097          	auipc	ra,0xfffff
    80005d70:	488080e7          	jalr	1160(ra) # 800051f4 <fdalloc>
    80005d74:	fca42023          	sw	a0,-64(s0)
    80005d78:	08054863          	bltz	a0,80005e08 <sys_pipe+0x162>
            p->ofile[fd0] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005d7c:	4691                	li	a3,4
    80005d7e:	fc440613          	addi	a2,s0,-60
    80005d82:	fd843583          	ld	a1,-40(s0)
    80005d86:	70a8                	ld	a0,96(s1)
    80005d88:	ffffc097          	auipc	ra,0xffffc
    80005d8c:	9c2080e7          	jalr	-1598(ra) # 8000174a <copyout>
    80005d90:	02054063          	bltz	a0,80005db0 <sys_pipe+0x10a>
            copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005d94:	4691                	li	a3,4
    80005d96:	fc040613          	addi	a2,s0,-64
    80005d9a:	fd843583          	ld	a1,-40(s0)
    80005d9e:	0591                	addi	a1,a1,4
    80005da0:	70a8                	ld	a0,96(s1)
    80005da2:	ffffc097          	auipc	ra,0xffffc
    80005da6:	9a8080e7          	jalr	-1624(ra) # 8000174a <copyout>
        p->ofile[fd1] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    return 0;
    80005daa:	4781                	li	a5,0
    if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005dac:	08055563          	bgez	a0,80005e36 <sys_pipe+0x190>
        p->ofile[fd0] = 0;
    80005db0:	fc442783          	lw	a5,-60(s0)
    80005db4:	07f1                	addi	a5,a5,28
    80005db6:	078e                	slli	a5,a5,0x3
    80005db8:	97a6                	add	a5,a5,s1
    80005dba:	0007b023          	sd	zero,0(a5)
        p->ofile[fd1] = 0;
    80005dbe:	fc042503          	lw	a0,-64(s0)
    80005dc2:	0571                	addi	a0,a0,28
    80005dc4:	050e                	slli	a0,a0,0x3
    80005dc6:	9526                	add	a0,a0,s1
    80005dc8:	00053023          	sd	zero,0(a0)
        fileclose(rf);
    80005dcc:	fd043503          	ld	a0,-48(s0)
    80005dd0:	fffff097          	auipc	ra,0xfffff
    80005dd4:	844080e7          	jalr	-1980(ra) # 80004614 <fileclose>
        fileclose(wf);
    80005dd8:	fc843503          	ld	a0,-56(s0)
    80005ddc:	fffff097          	auipc	ra,0xfffff
    80005de0:	838080e7          	jalr	-1992(ra) # 80004614 <fileclose>
        return -1;
    80005de4:	57fd                	li	a5,-1
    80005de6:	a881                	j	80005e36 <sys_pipe+0x190>
            kfree(mem);
    80005de8:	854a                	mv	a0,s2
    80005dea:	ffffb097          	auipc	ra,0xffffb
    80005dee:	c3a080e7          	jalr	-966(ra) # 80000a24 <kfree>
            return -1;
    80005df2:	57fd                	li	a5,-1
    80005df4:	a089                	j	80005e36 <sys_pipe+0x190>
            myproc()->maxva = fdarray + PGSIZE;
    80005df6:	ffffc097          	auipc	ra,0xffffc
    80005dfa:	c94080e7          	jalr	-876(ra) # 80001a8a <myproc>
    80005dfe:	6785                	lui	a5,0x1
    80005e00:	993e                	add	s2,s2,a5
    80005e02:	05253c23          	sd	s2,88(a0)
    80005e06:	bf15                	j	80005d3a <sys_pipe+0x94>
        if(fd0 >= 0)
    80005e08:	fc442783          	lw	a5,-60(s0)
    80005e0c:	0007c863          	bltz	a5,80005e1c <sys_pipe+0x176>
            p->ofile[fd0] = 0;
    80005e10:	01c78513          	addi	a0,a5,28 # 101c <_entry-0x7fffefe4>
    80005e14:	050e                	slli	a0,a0,0x3
    80005e16:	9526                	add	a0,a0,s1
    80005e18:	00053023          	sd	zero,0(a0)
        fileclose(rf);
    80005e1c:	fd043503          	ld	a0,-48(s0)
    80005e20:	ffffe097          	auipc	ra,0xffffe
    80005e24:	7f4080e7          	jalr	2036(ra) # 80004614 <fileclose>
        fileclose(wf);
    80005e28:	fc843503          	ld	a0,-56(s0)
    80005e2c:	ffffe097          	auipc	ra,0xffffe
    80005e30:	7e8080e7          	jalr	2024(ra) # 80004614 <fileclose>
        return -1;
    80005e34:	57fd                	li	a5,-1
}
    80005e36:	853e                	mv	a0,a5
    80005e38:	70e2                	ld	ra,56(sp)
    80005e3a:	7442                	ld	s0,48(sp)
    80005e3c:	74a2                	ld	s1,40(sp)
    80005e3e:	7902                	ld	s2,32(sp)
    80005e40:	6121                	addi	sp,sp,64
    80005e42:	8082                	ret
	...

0000000080005e50 <kernelvec>:
    80005e50:	7111                	addi	sp,sp,-256
    80005e52:	e006                	sd	ra,0(sp)
    80005e54:	e40a                	sd	sp,8(sp)
    80005e56:	e80e                	sd	gp,16(sp)
    80005e58:	ec12                	sd	tp,24(sp)
    80005e5a:	f016                	sd	t0,32(sp)
    80005e5c:	f41a                	sd	t1,40(sp)
    80005e5e:	f81e                	sd	t2,48(sp)
    80005e60:	fc22                	sd	s0,56(sp)
    80005e62:	e0a6                	sd	s1,64(sp)
    80005e64:	e4aa                	sd	a0,72(sp)
    80005e66:	e8ae                	sd	a1,80(sp)
    80005e68:	ecb2                	sd	a2,88(sp)
    80005e6a:	f0b6                	sd	a3,96(sp)
    80005e6c:	f4ba                	sd	a4,104(sp)
    80005e6e:	f8be                	sd	a5,112(sp)
    80005e70:	fcc2                	sd	a6,120(sp)
    80005e72:	e146                	sd	a7,128(sp)
    80005e74:	e54a                	sd	s2,136(sp)
    80005e76:	e94e                	sd	s3,144(sp)
    80005e78:	ed52                	sd	s4,152(sp)
    80005e7a:	f156                	sd	s5,160(sp)
    80005e7c:	f55a                	sd	s6,168(sp)
    80005e7e:	f95e                	sd	s7,176(sp)
    80005e80:	fd62                	sd	s8,184(sp)
    80005e82:	e1e6                	sd	s9,192(sp)
    80005e84:	e5ea                	sd	s10,200(sp)
    80005e86:	e9ee                	sd	s11,208(sp)
    80005e88:	edf2                	sd	t3,216(sp)
    80005e8a:	f1f6                	sd	t4,224(sp)
    80005e8c:	f5fa                	sd	t5,232(sp)
    80005e8e:	f9fe                	sd	t6,240(sp)
    80005e90:	b8bfc0ef          	jal	ra,80002a1a <kerneltrap>
    80005e94:	6082                	ld	ra,0(sp)
    80005e96:	6122                	ld	sp,8(sp)
    80005e98:	61c2                	ld	gp,16(sp)
    80005e9a:	7282                	ld	t0,32(sp)
    80005e9c:	7322                	ld	t1,40(sp)
    80005e9e:	73c2                	ld	t2,48(sp)
    80005ea0:	7462                	ld	s0,56(sp)
    80005ea2:	6486                	ld	s1,64(sp)
    80005ea4:	6526                	ld	a0,72(sp)
    80005ea6:	65c6                	ld	a1,80(sp)
    80005ea8:	6666                	ld	a2,88(sp)
    80005eaa:	7686                	ld	a3,96(sp)
    80005eac:	7726                	ld	a4,104(sp)
    80005eae:	77c6                	ld	a5,112(sp)
    80005eb0:	7866                	ld	a6,120(sp)
    80005eb2:	688a                	ld	a7,128(sp)
    80005eb4:	692a                	ld	s2,136(sp)
    80005eb6:	69ca                	ld	s3,144(sp)
    80005eb8:	6a6a                	ld	s4,152(sp)
    80005eba:	7a8a                	ld	s5,160(sp)
    80005ebc:	7b2a                	ld	s6,168(sp)
    80005ebe:	7bca                	ld	s7,176(sp)
    80005ec0:	7c6a                	ld	s8,184(sp)
    80005ec2:	6c8e                	ld	s9,192(sp)
    80005ec4:	6d2e                	ld	s10,200(sp)
    80005ec6:	6dce                	ld	s11,208(sp)
    80005ec8:	6e6e                	ld	t3,216(sp)
    80005eca:	7e8e                	ld	t4,224(sp)
    80005ecc:	7f2e                	ld	t5,232(sp)
    80005ece:	7fce                	ld	t6,240(sp)
    80005ed0:	6111                	addi	sp,sp,256
    80005ed2:	10200073          	sret
    80005ed6:	00000013          	nop
    80005eda:	00000013          	nop
    80005ede:	0001                	nop

0000000080005ee0 <timervec>:
    80005ee0:	34051573          	csrrw	a0,mscratch,a0
    80005ee4:	e10c                	sd	a1,0(a0)
    80005ee6:	e510                	sd	a2,8(a0)
    80005ee8:	e914                	sd	a3,16(a0)
    80005eea:	710c                	ld	a1,32(a0)
    80005eec:	7510                	ld	a2,40(a0)
    80005eee:	6194                	ld	a3,0(a1)
    80005ef0:	96b2                	add	a3,a3,a2
    80005ef2:	e194                	sd	a3,0(a1)
    80005ef4:	4589                	li	a1,2
    80005ef6:	14459073          	csrw	sip,a1
    80005efa:	6914                	ld	a3,16(a0)
    80005efc:	6510                	ld	a2,8(a0)
    80005efe:	610c                	ld	a1,0(a0)
    80005f00:	34051573          	csrrw	a0,mscratch,a0
    80005f04:	30200073          	mret
	...

0000000080005f0a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005f0a:	1141                	addi	sp,sp,-16
    80005f0c:	e422                	sd	s0,8(sp)
    80005f0e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005f10:	0c0007b7          	lui	a5,0xc000
    80005f14:	4705                	li	a4,1
    80005f16:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005f18:	c3d8                	sw	a4,4(a5)
}
    80005f1a:	6422                	ld	s0,8(sp)
    80005f1c:	0141                	addi	sp,sp,16
    80005f1e:	8082                	ret

0000000080005f20 <plicinithart>:

void
plicinithart(void)
{
    80005f20:	1141                	addi	sp,sp,-16
    80005f22:	e406                	sd	ra,8(sp)
    80005f24:	e022                	sd	s0,0(sp)
    80005f26:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005f28:	ffffc097          	auipc	ra,0xffffc
    80005f2c:	b36080e7          	jalr	-1226(ra) # 80001a5e <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005f30:	0085171b          	slliw	a4,a0,0x8
    80005f34:	0c0027b7          	lui	a5,0xc002
    80005f38:	97ba                	add	a5,a5,a4
    80005f3a:	40200713          	li	a4,1026
    80005f3e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005f42:	00d5151b          	slliw	a0,a0,0xd
    80005f46:	0c2017b7          	lui	a5,0xc201
    80005f4a:	953e                	add	a0,a0,a5
    80005f4c:	00052023          	sw	zero,0(a0)
}
    80005f50:	60a2                	ld	ra,8(sp)
    80005f52:	6402                	ld	s0,0(sp)
    80005f54:	0141                	addi	sp,sp,16
    80005f56:	8082                	ret

0000000080005f58 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005f58:	1141                	addi	sp,sp,-16
    80005f5a:	e406                	sd	ra,8(sp)
    80005f5c:	e022                	sd	s0,0(sp)
    80005f5e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005f60:	ffffc097          	auipc	ra,0xffffc
    80005f64:	afe080e7          	jalr	-1282(ra) # 80001a5e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005f68:	00d5179b          	slliw	a5,a0,0xd
    80005f6c:	0c201537          	lui	a0,0xc201
    80005f70:	953e                	add	a0,a0,a5
  return irq;
}
    80005f72:	4148                	lw	a0,4(a0)
    80005f74:	60a2                	ld	ra,8(sp)
    80005f76:	6402                	ld	s0,0(sp)
    80005f78:	0141                	addi	sp,sp,16
    80005f7a:	8082                	ret

0000000080005f7c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005f7c:	1101                	addi	sp,sp,-32
    80005f7e:	ec06                	sd	ra,24(sp)
    80005f80:	e822                	sd	s0,16(sp)
    80005f82:	e426                	sd	s1,8(sp)
    80005f84:	1000                	addi	s0,sp,32
    80005f86:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005f88:	ffffc097          	auipc	ra,0xffffc
    80005f8c:	ad6080e7          	jalr	-1322(ra) # 80001a5e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005f90:	00d5151b          	slliw	a0,a0,0xd
    80005f94:	0c2017b7          	lui	a5,0xc201
    80005f98:	97aa                	add	a5,a5,a0
    80005f9a:	c3c4                	sw	s1,4(a5)
}
    80005f9c:	60e2                	ld	ra,24(sp)
    80005f9e:	6442                	ld	s0,16(sp)
    80005fa0:	64a2                	ld	s1,8(sp)
    80005fa2:	6105                	addi	sp,sp,32
    80005fa4:	8082                	ret

0000000080005fa6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005fa6:	1141                	addi	sp,sp,-16
    80005fa8:	e406                	sd	ra,8(sp)
    80005faa:	e022                	sd	s0,0(sp)
    80005fac:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005fae:	479d                	li	a5,7
    80005fb0:	04a7cc63          	blt	a5,a0,80006008 <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80005fb4:	0001d797          	auipc	a5,0x1d
    80005fb8:	04c78793          	addi	a5,a5,76 # 80023000 <disk>
    80005fbc:	00a78733          	add	a4,a5,a0
    80005fc0:	6789                	lui	a5,0x2
    80005fc2:	97ba                	add	a5,a5,a4
    80005fc4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005fc8:	eba1                	bnez	a5,80006018 <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    80005fca:	00451713          	slli	a4,a0,0x4
    80005fce:	0001f797          	auipc	a5,0x1f
    80005fd2:	0327b783          	ld	a5,50(a5) # 80025000 <disk+0x2000>
    80005fd6:	97ba                	add	a5,a5,a4
    80005fd8:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    80005fdc:	0001d797          	auipc	a5,0x1d
    80005fe0:	02478793          	addi	a5,a5,36 # 80023000 <disk>
    80005fe4:	97aa                	add	a5,a5,a0
    80005fe6:	6509                	lui	a0,0x2
    80005fe8:	953e                	add	a0,a0,a5
    80005fea:	4785                	li	a5,1
    80005fec:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005ff0:	0001f517          	auipc	a0,0x1f
    80005ff4:	02850513          	addi	a0,a0,40 # 80025018 <disk+0x2018>
    80005ff8:	ffffc097          	auipc	ra,0xffffc
    80005ffc:	450080e7          	jalr	1104(ra) # 80002448 <wakeup>
}
    80006000:	60a2                	ld	ra,8(sp)
    80006002:	6402                	ld	s0,0(sp)
    80006004:	0141                	addi	sp,sp,16
    80006006:	8082                	ret
    panic("virtio_disk_intr 1");
    80006008:	00002517          	auipc	a0,0x2
    8000600c:	74050513          	addi	a0,a0,1856 # 80008748 <syscalls+0x338>
    80006010:	ffffa097          	auipc	ra,0xffffa
    80006014:	538080e7          	jalr	1336(ra) # 80000548 <panic>
    panic("virtio_disk_intr 2");
    80006018:	00002517          	auipc	a0,0x2
    8000601c:	74850513          	addi	a0,a0,1864 # 80008760 <syscalls+0x350>
    80006020:	ffffa097          	auipc	ra,0xffffa
    80006024:	528080e7          	jalr	1320(ra) # 80000548 <panic>

0000000080006028 <virtio_disk_init>:
{
    80006028:	1101                	addi	sp,sp,-32
    8000602a:	ec06                	sd	ra,24(sp)
    8000602c:	e822                	sd	s0,16(sp)
    8000602e:	e426                	sd	s1,8(sp)
    80006030:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006032:	00002597          	auipc	a1,0x2
    80006036:	74658593          	addi	a1,a1,1862 # 80008778 <syscalls+0x368>
    8000603a:	0001f517          	auipc	a0,0x1f
    8000603e:	06e50513          	addi	a0,a0,110 # 800250a8 <disk+0x20a8>
    80006042:	ffffb097          	auipc	ra,0xffffb
    80006046:	b3e080e7          	jalr	-1218(ra) # 80000b80 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000604a:	100017b7          	lui	a5,0x10001
    8000604e:	4398                	lw	a4,0(a5)
    80006050:	2701                	sext.w	a4,a4
    80006052:	747277b7          	lui	a5,0x74727
    80006056:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000605a:	0ef71163          	bne	a4,a5,8000613c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000605e:	100017b7          	lui	a5,0x10001
    80006062:	43dc                	lw	a5,4(a5)
    80006064:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006066:	4705                	li	a4,1
    80006068:	0ce79a63          	bne	a5,a4,8000613c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000606c:	100017b7          	lui	a5,0x10001
    80006070:	479c                	lw	a5,8(a5)
    80006072:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006074:	4709                	li	a4,2
    80006076:	0ce79363          	bne	a5,a4,8000613c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000607a:	100017b7          	lui	a5,0x10001
    8000607e:	47d8                	lw	a4,12(a5)
    80006080:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006082:	554d47b7          	lui	a5,0x554d4
    80006086:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000608a:	0af71963          	bne	a4,a5,8000613c <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000608e:	100017b7          	lui	a5,0x10001
    80006092:	4705                	li	a4,1
    80006094:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006096:	470d                	li	a4,3
    80006098:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000609a:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000609c:	c7ffe737          	lui	a4,0xc7ffe
    800060a0:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    800060a4:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800060a6:	2701                	sext.w	a4,a4
    800060a8:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800060aa:	472d                	li	a4,11
    800060ac:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800060ae:	473d                	li	a4,15
    800060b0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800060b2:	6705                	lui	a4,0x1
    800060b4:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800060b6:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800060ba:	5bdc                	lw	a5,52(a5)
    800060bc:	2781                	sext.w	a5,a5
  if(max == 0)
    800060be:	c7d9                	beqz	a5,8000614c <virtio_disk_init+0x124>
  if(max < NUM)
    800060c0:	471d                	li	a4,7
    800060c2:	08f77d63          	bgeu	a4,a5,8000615c <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800060c6:	100014b7          	lui	s1,0x10001
    800060ca:	47a1                	li	a5,8
    800060cc:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800060ce:	6609                	lui	a2,0x2
    800060d0:	4581                	li	a1,0
    800060d2:	0001d517          	auipc	a0,0x1d
    800060d6:	f2e50513          	addi	a0,a0,-210 # 80023000 <disk>
    800060da:	ffffb097          	auipc	ra,0xffffb
    800060de:	c32080e7          	jalr	-974(ra) # 80000d0c <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800060e2:	0001d717          	auipc	a4,0x1d
    800060e6:	f1e70713          	addi	a4,a4,-226 # 80023000 <disk>
    800060ea:	00c75793          	srli	a5,a4,0xc
    800060ee:	2781                	sext.w	a5,a5
    800060f0:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    800060f2:	0001f797          	auipc	a5,0x1f
    800060f6:	f0e78793          	addi	a5,a5,-242 # 80025000 <disk+0x2000>
    800060fa:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    800060fc:	0001d717          	auipc	a4,0x1d
    80006100:	f8470713          	addi	a4,a4,-124 # 80023080 <disk+0x80>
    80006104:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80006106:	0001e717          	auipc	a4,0x1e
    8000610a:	efa70713          	addi	a4,a4,-262 # 80024000 <disk+0x1000>
    8000610e:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80006110:	4705                	li	a4,1
    80006112:	00e78c23          	sb	a4,24(a5)
    80006116:	00e78ca3          	sb	a4,25(a5)
    8000611a:	00e78d23          	sb	a4,26(a5)
    8000611e:	00e78da3          	sb	a4,27(a5)
    80006122:	00e78e23          	sb	a4,28(a5)
    80006126:	00e78ea3          	sb	a4,29(a5)
    8000612a:	00e78f23          	sb	a4,30(a5)
    8000612e:	00e78fa3          	sb	a4,31(a5)
}
    80006132:	60e2                	ld	ra,24(sp)
    80006134:	6442                	ld	s0,16(sp)
    80006136:	64a2                	ld	s1,8(sp)
    80006138:	6105                	addi	sp,sp,32
    8000613a:	8082                	ret
    panic("could not find virtio disk");
    8000613c:	00002517          	auipc	a0,0x2
    80006140:	64c50513          	addi	a0,a0,1612 # 80008788 <syscalls+0x378>
    80006144:	ffffa097          	auipc	ra,0xffffa
    80006148:	404080e7          	jalr	1028(ra) # 80000548 <panic>
    panic("virtio disk has no queue 0");
    8000614c:	00002517          	auipc	a0,0x2
    80006150:	65c50513          	addi	a0,a0,1628 # 800087a8 <syscalls+0x398>
    80006154:	ffffa097          	auipc	ra,0xffffa
    80006158:	3f4080e7          	jalr	1012(ra) # 80000548 <panic>
    panic("virtio disk max queue too short");
    8000615c:	00002517          	auipc	a0,0x2
    80006160:	66c50513          	addi	a0,a0,1644 # 800087c8 <syscalls+0x3b8>
    80006164:	ffffa097          	auipc	ra,0xffffa
    80006168:	3e4080e7          	jalr	996(ra) # 80000548 <panic>

000000008000616c <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000616c:	7119                	addi	sp,sp,-128
    8000616e:	fc86                	sd	ra,120(sp)
    80006170:	f8a2                	sd	s0,112(sp)
    80006172:	f4a6                	sd	s1,104(sp)
    80006174:	f0ca                	sd	s2,96(sp)
    80006176:	ecce                	sd	s3,88(sp)
    80006178:	e8d2                	sd	s4,80(sp)
    8000617a:	e4d6                	sd	s5,72(sp)
    8000617c:	e0da                	sd	s6,64(sp)
    8000617e:	fc5e                	sd	s7,56(sp)
    80006180:	f862                	sd	s8,48(sp)
    80006182:	f466                	sd	s9,40(sp)
    80006184:	f06a                	sd	s10,32(sp)
    80006186:	0100                	addi	s0,sp,128
    80006188:	892a                	mv	s2,a0
    8000618a:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000618c:	00c52c83          	lw	s9,12(a0)
    80006190:	001c9c9b          	slliw	s9,s9,0x1
    80006194:	1c82                	slli	s9,s9,0x20
    80006196:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000619a:	0001f517          	auipc	a0,0x1f
    8000619e:	f0e50513          	addi	a0,a0,-242 # 800250a8 <disk+0x20a8>
    800061a2:	ffffb097          	auipc	ra,0xffffb
    800061a6:	a6e080e7          	jalr	-1426(ra) # 80000c10 <acquire>
  for(int i = 0; i < 3; i++){
    800061aa:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800061ac:	4c21                	li	s8,8
      disk.free[i] = 0;
    800061ae:	0001db97          	auipc	s7,0x1d
    800061b2:	e52b8b93          	addi	s7,s7,-430 # 80023000 <disk>
    800061b6:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800061b8:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800061ba:	8a4e                	mv	s4,s3
    800061bc:	a051                	j	80006240 <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800061be:	00fb86b3          	add	a3,s7,a5
    800061c2:	96da                	add	a3,a3,s6
    800061c4:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800061c8:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800061ca:	0207c563          	bltz	a5,800061f4 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800061ce:	2485                	addiw	s1,s1,1
    800061d0:	0711                	addi	a4,a4,4
    800061d2:	23548d63          	beq	s1,s5,8000640c <virtio_disk_rw+0x2a0>
    idx[i] = alloc_desc();
    800061d6:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800061d8:	0001f697          	auipc	a3,0x1f
    800061dc:	e4068693          	addi	a3,a3,-448 # 80025018 <disk+0x2018>
    800061e0:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800061e2:	0006c583          	lbu	a1,0(a3)
    800061e6:	fde1                	bnez	a1,800061be <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800061e8:	2785                	addiw	a5,a5,1
    800061ea:	0685                	addi	a3,a3,1
    800061ec:	ff879be3          	bne	a5,s8,800061e2 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800061f0:	57fd                	li	a5,-1
    800061f2:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800061f4:	02905a63          	blez	s1,80006228 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800061f8:	f9042503          	lw	a0,-112(s0)
    800061fc:	00000097          	auipc	ra,0x0
    80006200:	daa080e7          	jalr	-598(ra) # 80005fa6 <free_desc>
      for(int j = 0; j < i; j++)
    80006204:	4785                	li	a5,1
    80006206:	0297d163          	bge	a5,s1,80006228 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    8000620a:	f9442503          	lw	a0,-108(s0)
    8000620e:	00000097          	auipc	ra,0x0
    80006212:	d98080e7          	jalr	-616(ra) # 80005fa6 <free_desc>
      for(int j = 0; j < i; j++)
    80006216:	4789                	li	a5,2
    80006218:	0097d863          	bge	a5,s1,80006228 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    8000621c:	f9842503          	lw	a0,-104(s0)
    80006220:	00000097          	auipc	ra,0x0
    80006224:	d86080e7          	jalr	-634(ra) # 80005fa6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006228:	0001f597          	auipc	a1,0x1f
    8000622c:	e8058593          	addi	a1,a1,-384 # 800250a8 <disk+0x20a8>
    80006230:	0001f517          	auipc	a0,0x1f
    80006234:	de850513          	addi	a0,a0,-536 # 80025018 <disk+0x2018>
    80006238:	ffffc097          	auipc	ra,0xffffc
    8000623c:	08a080e7          	jalr	138(ra) # 800022c2 <sleep>
  for(int i = 0; i < 3; i++){
    80006240:	f9040713          	addi	a4,s0,-112
    80006244:	84ce                	mv	s1,s3
    80006246:	bf41                	j	800061d6 <virtio_disk_rw+0x6a>
    uint32 reserved;
    uint64 sector;
  } buf0;

  if(write)
    buf0.type = VIRTIO_BLK_T_OUT; // write the disk
    80006248:	4785                	li	a5,1
    8000624a:	f8f42023          	sw	a5,-128(s0)
  else
    buf0.type = VIRTIO_BLK_T_IN; // read the disk
  buf0.reserved = 0;
    8000624e:	f8042223          	sw	zero,-124(s0)
  buf0.sector = sector;
    80006252:	f9943423          	sd	s9,-120(s0)

  // buf0 is on a kernel stack, which is not direct mapped,
  // thus the call to kvmpa().
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    80006256:	f9042983          	lw	s3,-112(s0)
    8000625a:	00499493          	slli	s1,s3,0x4
    8000625e:	0001fa17          	auipc	s4,0x1f
    80006262:	da2a0a13          	addi	s4,s4,-606 # 80025000 <disk+0x2000>
    80006266:	000a3a83          	ld	s5,0(s4)
    8000626a:	9aa6                	add	s5,s5,s1
    8000626c:	f8040513          	addi	a0,s0,-128
    80006270:	ffffb097          	auipc	ra,0xffffb
    80006274:	f22080e7          	jalr	-222(ra) # 80001192 <kvmpa>
    80006278:	00aab023          	sd	a0,0(s5)
  disk.desc[idx[0]].len = sizeof(buf0);
    8000627c:	000a3783          	ld	a5,0(s4)
    80006280:	97a6                	add	a5,a5,s1
    80006282:	4741                	li	a4,16
    80006284:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006286:	000a3783          	ld	a5,0(s4)
    8000628a:	97a6                	add	a5,a5,s1
    8000628c:	4705                	li	a4,1
    8000628e:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80006292:	f9442703          	lw	a4,-108(s0)
    80006296:	000a3783          	ld	a5,0(s4)
    8000629a:	97a6                	add	a5,a5,s1
    8000629c:	00e79723          	sh	a4,14(a5)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800062a0:	0712                	slli	a4,a4,0x4
    800062a2:	000a3783          	ld	a5,0(s4)
    800062a6:	97ba                	add	a5,a5,a4
    800062a8:	05890693          	addi	a3,s2,88
    800062ac:	e394                	sd	a3,0(a5)
  disk.desc[idx[1]].len = BSIZE;
    800062ae:	000a3783          	ld	a5,0(s4)
    800062b2:	97ba                	add	a5,a5,a4
    800062b4:	40000693          	li	a3,1024
    800062b8:	c794                	sw	a3,8(a5)
  if(write)
    800062ba:	100d0a63          	beqz	s10,800063ce <virtio_disk_rw+0x262>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800062be:	0001f797          	auipc	a5,0x1f
    800062c2:	d427b783          	ld	a5,-702(a5) # 80025000 <disk+0x2000>
    800062c6:	97ba                	add	a5,a5,a4
    800062c8:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800062cc:	0001d517          	auipc	a0,0x1d
    800062d0:	d3450513          	addi	a0,a0,-716 # 80023000 <disk>
    800062d4:	0001f797          	auipc	a5,0x1f
    800062d8:	d2c78793          	addi	a5,a5,-724 # 80025000 <disk+0x2000>
    800062dc:	6394                	ld	a3,0(a5)
    800062de:	96ba                	add	a3,a3,a4
    800062e0:	00c6d603          	lhu	a2,12(a3)
    800062e4:	00166613          	ori	a2,a2,1
    800062e8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800062ec:	f9842683          	lw	a3,-104(s0)
    800062f0:	6390                	ld	a2,0(a5)
    800062f2:	9732                	add	a4,a4,a2
    800062f4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0;
    800062f8:	20098613          	addi	a2,s3,512
    800062fc:	0612                	slli	a2,a2,0x4
    800062fe:	962a                	add	a2,a2,a0
    80006300:	02060823          	sb	zero,48(a2) # 2030 <_entry-0x7fffdfd0>
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006304:	00469713          	slli	a4,a3,0x4
    80006308:	6394                	ld	a3,0(a5)
    8000630a:	96ba                	add	a3,a3,a4
    8000630c:	6589                	lui	a1,0x2
    8000630e:	03058593          	addi	a1,a1,48 # 2030 <_entry-0x7fffdfd0>
    80006312:	94ae                	add	s1,s1,a1
    80006314:	94aa                	add	s1,s1,a0
    80006316:	e284                	sd	s1,0(a3)
  disk.desc[idx[2]].len = 1;
    80006318:	6394                	ld	a3,0(a5)
    8000631a:	96ba                	add	a3,a3,a4
    8000631c:	4585                	li	a1,1
    8000631e:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006320:	6394                	ld	a3,0(a5)
    80006322:	96ba                	add	a3,a3,a4
    80006324:	4509                	li	a0,2
    80006326:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    8000632a:	6394                	ld	a3,0(a5)
    8000632c:	9736                	add	a4,a4,a3
    8000632e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006332:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80006336:	03263423          	sd	s2,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    8000633a:	6794                	ld	a3,8(a5)
    8000633c:	0026d703          	lhu	a4,2(a3)
    80006340:	8b1d                	andi	a4,a4,7
    80006342:	2709                	addiw	a4,a4,2
    80006344:	0706                	slli	a4,a4,0x1
    80006346:	9736                	add	a4,a4,a3
    80006348:	01371023          	sh	s3,0(a4)
  __sync_synchronize();
    8000634c:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    80006350:	6798                	ld	a4,8(a5)
    80006352:	00275783          	lhu	a5,2(a4)
    80006356:	2785                	addiw	a5,a5,1
    80006358:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000635c:	100017b7          	lui	a5,0x10001
    80006360:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006364:	00492703          	lw	a4,4(s2)
    80006368:	4785                	li	a5,1
    8000636a:	02f71163          	bne	a4,a5,8000638c <virtio_disk_rw+0x220>
    sleep(b, &disk.vdisk_lock);
    8000636e:	0001f997          	auipc	s3,0x1f
    80006372:	d3a98993          	addi	s3,s3,-710 # 800250a8 <disk+0x20a8>
  while(b->disk == 1) {
    80006376:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006378:	85ce                	mv	a1,s3
    8000637a:	854a                	mv	a0,s2
    8000637c:	ffffc097          	auipc	ra,0xffffc
    80006380:	f46080e7          	jalr	-186(ra) # 800022c2 <sleep>
  while(b->disk == 1) {
    80006384:	00492783          	lw	a5,4(s2)
    80006388:	fe9788e3          	beq	a5,s1,80006378 <virtio_disk_rw+0x20c>
  }

  disk.info[idx[0]].b = 0;
    8000638c:	f9042483          	lw	s1,-112(s0)
    80006390:	20048793          	addi	a5,s1,512 # 10001200 <_entry-0x6fffee00>
    80006394:	00479713          	slli	a4,a5,0x4
    80006398:	0001d797          	auipc	a5,0x1d
    8000639c:	c6878793          	addi	a5,a5,-920 # 80023000 <disk>
    800063a0:	97ba                	add	a5,a5,a4
    800063a2:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800063a6:	0001f917          	auipc	s2,0x1f
    800063aa:	c5a90913          	addi	s2,s2,-934 # 80025000 <disk+0x2000>
    free_desc(i);
    800063ae:	8526                	mv	a0,s1
    800063b0:	00000097          	auipc	ra,0x0
    800063b4:	bf6080e7          	jalr	-1034(ra) # 80005fa6 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800063b8:	0492                	slli	s1,s1,0x4
    800063ba:	00093783          	ld	a5,0(s2)
    800063be:	94be                	add	s1,s1,a5
    800063c0:	00c4d783          	lhu	a5,12(s1)
    800063c4:	8b85                	andi	a5,a5,1
    800063c6:	cf89                	beqz	a5,800063e0 <virtio_disk_rw+0x274>
      i = disk.desc[i].next;
    800063c8:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    800063cc:	b7cd                	j	800063ae <virtio_disk_rw+0x242>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800063ce:	0001f797          	auipc	a5,0x1f
    800063d2:	c327b783          	ld	a5,-974(a5) # 80025000 <disk+0x2000>
    800063d6:	97ba                	add	a5,a5,a4
    800063d8:	4689                	li	a3,2
    800063da:	00d79623          	sh	a3,12(a5)
    800063de:	b5fd                	j	800062cc <virtio_disk_rw+0x160>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800063e0:	0001f517          	auipc	a0,0x1f
    800063e4:	cc850513          	addi	a0,a0,-824 # 800250a8 <disk+0x20a8>
    800063e8:	ffffb097          	auipc	ra,0xffffb
    800063ec:	8dc080e7          	jalr	-1828(ra) # 80000cc4 <release>
}
    800063f0:	70e6                	ld	ra,120(sp)
    800063f2:	7446                	ld	s0,112(sp)
    800063f4:	74a6                	ld	s1,104(sp)
    800063f6:	7906                	ld	s2,96(sp)
    800063f8:	69e6                	ld	s3,88(sp)
    800063fa:	6a46                	ld	s4,80(sp)
    800063fc:	6aa6                	ld	s5,72(sp)
    800063fe:	6b06                	ld	s6,64(sp)
    80006400:	7be2                	ld	s7,56(sp)
    80006402:	7c42                	ld	s8,48(sp)
    80006404:	7ca2                	ld	s9,40(sp)
    80006406:	7d02                	ld	s10,32(sp)
    80006408:	6109                	addi	sp,sp,128
    8000640a:	8082                	ret
  if(write)
    8000640c:	e20d1ee3          	bnez	s10,80006248 <virtio_disk_rw+0xdc>
    buf0.type = VIRTIO_BLK_T_IN; // read the disk
    80006410:	f8042023          	sw	zero,-128(s0)
    80006414:	bd2d                	j	8000624e <virtio_disk_rw+0xe2>

0000000080006416 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006416:	1101                	addi	sp,sp,-32
    80006418:	ec06                	sd	ra,24(sp)
    8000641a:	e822                	sd	s0,16(sp)
    8000641c:	e426                	sd	s1,8(sp)
    8000641e:	e04a                	sd	s2,0(sp)
    80006420:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006422:	0001f517          	auipc	a0,0x1f
    80006426:	c8650513          	addi	a0,a0,-890 # 800250a8 <disk+0x20a8>
    8000642a:	ffffa097          	auipc	ra,0xffffa
    8000642e:	7e6080e7          	jalr	2022(ra) # 80000c10 <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80006432:	0001f717          	auipc	a4,0x1f
    80006436:	bce70713          	addi	a4,a4,-1074 # 80025000 <disk+0x2000>
    8000643a:	02075783          	lhu	a5,32(a4)
    8000643e:	6b18                	ld	a4,16(a4)
    80006440:	00275683          	lhu	a3,2(a4)
    80006444:	8ebd                	xor	a3,a3,a5
    80006446:	8a9d                	andi	a3,a3,7
    80006448:	cab9                	beqz	a3,8000649e <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    8000644a:	0001d917          	auipc	s2,0x1d
    8000644e:	bb690913          	addi	s2,s2,-1098 # 80023000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    80006452:	0001f497          	auipc	s1,0x1f
    80006456:	bae48493          	addi	s1,s1,-1106 # 80025000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    8000645a:	078e                	slli	a5,a5,0x3
    8000645c:	97ba                	add	a5,a5,a4
    8000645e:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    80006460:	20078713          	addi	a4,a5,512
    80006464:	0712                	slli	a4,a4,0x4
    80006466:	974a                	add	a4,a4,s2
    80006468:	03074703          	lbu	a4,48(a4)
    8000646c:	ef21                	bnez	a4,800064c4 <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    8000646e:	20078793          	addi	a5,a5,512
    80006472:	0792                	slli	a5,a5,0x4
    80006474:	97ca                	add	a5,a5,s2
    80006476:	7798                	ld	a4,40(a5)
    80006478:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    8000647c:	7788                	ld	a0,40(a5)
    8000647e:	ffffc097          	auipc	ra,0xffffc
    80006482:	fca080e7          	jalr	-54(ra) # 80002448 <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    80006486:	0204d783          	lhu	a5,32(s1)
    8000648a:	2785                	addiw	a5,a5,1
    8000648c:	8b9d                	andi	a5,a5,7
    8000648e:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80006492:	6898                	ld	a4,16(s1)
    80006494:	00275683          	lhu	a3,2(a4)
    80006498:	8a9d                	andi	a3,a3,7
    8000649a:	fcf690e3          	bne	a3,a5,8000645a <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000649e:	10001737          	lui	a4,0x10001
    800064a2:	533c                	lw	a5,96(a4)
    800064a4:	8b8d                	andi	a5,a5,3
    800064a6:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    800064a8:	0001f517          	auipc	a0,0x1f
    800064ac:	c0050513          	addi	a0,a0,-1024 # 800250a8 <disk+0x20a8>
    800064b0:	ffffb097          	auipc	ra,0xffffb
    800064b4:	814080e7          	jalr	-2028(ra) # 80000cc4 <release>
}
    800064b8:	60e2                	ld	ra,24(sp)
    800064ba:	6442                	ld	s0,16(sp)
    800064bc:	64a2                	ld	s1,8(sp)
    800064be:	6902                	ld	s2,0(sp)
    800064c0:	6105                	addi	sp,sp,32
    800064c2:	8082                	ret
      panic("virtio_disk_intr status");
    800064c4:	00002517          	auipc	a0,0x2
    800064c8:	32450513          	addi	a0,a0,804 # 800087e8 <syscalls+0x3d8>
    800064cc:	ffffa097          	auipc	ra,0xffffa
    800064d0:	07c080e7          	jalr	124(ra) # 80000548 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
