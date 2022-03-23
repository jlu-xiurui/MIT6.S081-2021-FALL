
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
    80000060:	f9478793          	addi	a5,a5,-108 # 80005ff0 <timervec>
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
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd77df>
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
    8000012a:	7a6080e7          	jalr	1958(ra) # 800028cc <either_copyin>
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
    800001d2:	b02080e7          	jalr	-1278(ra) # 80001cd0 <myproc>
    800001d6:	591c                	lw	a5,48(a0)
    800001d8:	e7b5                	bnez	a5,80000244 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800001da:	85ce                	mv	a1,s3
    800001dc:	854a                	mv	a0,s2
    800001de:	00002097          	auipc	ra,0x2
    800001e2:	436080e7          	jalr	1078(ra) # 80002614 <sleep>
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
    8000021e:	65c080e7          	jalr	1628(ra) # 80002876 <either_copyout>
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
    80000300:	626080e7          	jalr	1574(ra) # 80002922 <procdump>
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
    80000454:	34a080e7          	jalr	842(ra) # 8000279a <wakeup>
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
    80000466:	b9e58593          	addi	a1,a1,-1122 # 80008000 <etext>
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
    80000482:	00021797          	auipc	a5,0x21
    80000486:	72e78793          	addi	a5,a5,1838 # 80021bb0 <devsw>
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
    800004c8:	b6c60613          	addi	a2,a2,-1172 # 80008030 <digits>
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
    80000560:	aac50513          	addi	a0,a0,-1364 # 80008008 <etext+0x8>
    80000564:	00000097          	auipc	ra,0x0
    80000568:	02e080e7          	jalr	46(ra) # 80000592 <printf>
  printf(s);
    8000056c:	8526                	mv	a0,s1
    8000056e:	00000097          	auipc	ra,0x0
    80000572:	024080e7          	jalr	36(ra) # 80000592 <printf>
  printf("\n");
    80000576:	00008517          	auipc	a0,0x8
    8000057a:	b4250513          	addi	a0,a0,-1214 # 800080b8 <digits+0x88>
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
    800005f4:	a40b8b93          	addi	s7,s7,-1472 # 80008030 <digits>
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
    80000618:	a0450513          	addi	a0,a0,-1532 # 80008018 <etext+0x18>
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
    80000718:	8fc90913          	addi	s2,s2,-1796 # 80008010 <etext+0x10>
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
    8000078e:	89e58593          	addi	a1,a1,-1890 # 80008028 <etext+0x28>
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
    800007de:	86e58593          	addi	a1,a1,-1938 # 80008048 <digits+0x18>
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
    800008ba:	ee4080e7          	jalr	-284(ra) # 8000279a <wakeup>
    
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
    80000954:	cc4080e7          	jalr	-828(ra) # 80002614 <sleep>
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
    80000a38:	00026797          	auipc	a5,0x26
    80000a3c:	5e878793          	addi	a5,a5,1512 # 80027020 <end>
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
    80000a8e:	5c650513          	addi	a0,a0,1478 # 80008050 <digits+0x20>
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
    80000af0:	56c58593          	addi	a1,a1,1388 # 80008058 <digits+0x28>
    80000af4:	00011517          	auipc	a0,0x11
    80000af8:	e3c50513          	addi	a0,a0,-452 # 80011930 <kmem>
    80000afc:	00000097          	auipc	ra,0x0
    80000b00:	084080e7          	jalr	132(ra) # 80000b80 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b04:	45c5                	li	a1,17
    80000b06:	05ee                	slli	a1,a1,0x1b
    80000b08:	00026517          	auipc	a0,0x26
    80000b0c:	51850513          	addi	a0,a0,1304 # 80027020 <end>
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
    80000bae:	10a080e7          	jalr	266(ra) # 80001cb4 <mycpu>
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
    80000be0:	0d8080e7          	jalr	216(ra) # 80001cb4 <mycpu>
    80000be4:	5d3c                	lw	a5,120(a0)
    80000be6:	cf89                	beqz	a5,80000c00 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000be8:	00001097          	auipc	ra,0x1
    80000bec:	0cc080e7          	jalr	204(ra) # 80001cb4 <mycpu>
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
    80000c04:	0b4080e7          	jalr	180(ra) # 80001cb4 <mycpu>
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
    80000c44:	074080e7          	jalr	116(ra) # 80001cb4 <mycpu>
    80000c48:	e888                	sd	a0,16(s1)
}
    80000c4a:	60e2                	ld	ra,24(sp)
    80000c4c:	6442                	ld	s0,16(sp)
    80000c4e:	64a2                	ld	s1,8(sp)
    80000c50:	6105                	addi	sp,sp,32
    80000c52:	8082                	ret
    panic("acquire");
    80000c54:	00007517          	auipc	a0,0x7
    80000c58:	40c50513          	addi	a0,a0,1036 # 80008060 <digits+0x30>
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
    80000c70:	048080e7          	jalr	72(ra) # 80001cb4 <mycpu>
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
    80000ca8:	3c450513          	addi	a0,a0,964 # 80008068 <digits+0x38>
    80000cac:	00000097          	auipc	ra,0x0
    80000cb0:	89c080e7          	jalr	-1892(ra) # 80000548 <panic>
    panic("pop_off");
    80000cb4:	00007517          	auipc	a0,0x7
    80000cb8:	3cc50513          	addi	a0,a0,972 # 80008080 <digits+0x50>
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
    80000d00:	38c50513          	addi	a0,a0,908 # 80008088 <digits+0x58>
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
    80000eca:	dde080e7          	jalr	-546(ra) # 80001ca4 <cpuid>
#endif    
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
    80000ee6:	dc2080e7          	jalr	-574(ra) # 80001ca4 <cpuid>
    80000eea:	85aa                	mv	a1,a0
    80000eec:	00007517          	auipc	a0,0x7
    80000ef0:	1bc50513          	addi	a0,a0,444 # 800080a8 <digits+0x78>
    80000ef4:	fffff097          	auipc	ra,0xfffff
    80000ef8:	69e080e7          	jalr	1694(ra) # 80000592 <printf>
    kvminithart();    // turn on paging
    80000efc:	00000097          	auipc	ra,0x0
    80000f00:	192080e7          	jalr	402(ra) # 8000108e <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f04:	00002097          	auipc	ra,0x2
    80000f08:	b5e080e7          	jalr	-1186(ra) # 80002a62 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f0c:	00005097          	auipc	ra,0x5
    80000f10:	124080e7          	jalr	292(ra) # 80006030 <plicinithart>
  }

  scheduler();        
    80000f14:	00001097          	auipc	ra,0x1
    80000f18:	400080e7          	jalr	1024(ra) # 80002314 <scheduler>
    consoleinit();
    80000f1c:	fffff097          	auipc	ra,0xfffff
    80000f20:	53e080e7          	jalr	1342(ra) # 8000045a <consoleinit>
    statsinit();
    80000f24:	00006097          	auipc	ra,0x6
    80000f28:	8ce080e7          	jalr	-1842(ra) # 800067f2 <statsinit>
    printfinit();
    80000f2c:	00000097          	auipc	ra,0x0
    80000f30:	84c080e7          	jalr	-1972(ra) # 80000778 <printfinit>
    printf("\n");
    80000f34:	00007517          	auipc	a0,0x7
    80000f38:	18450513          	addi	a0,a0,388 # 800080b8 <digits+0x88>
    80000f3c:	fffff097          	auipc	ra,0xfffff
    80000f40:	656080e7          	jalr	1622(ra) # 80000592 <printf>
    printf("xv6 kernel is booting\n");
    80000f44:	00007517          	auipc	a0,0x7
    80000f48:	14c50513          	addi	a0,a0,332 # 80008090 <digits+0x60>
    80000f4c:	fffff097          	auipc	ra,0xfffff
    80000f50:	646080e7          	jalr	1606(ra) # 80000592 <printf>
    printf("\n");
    80000f54:	00007517          	auipc	a0,0x7
    80000f58:	16450513          	addi	a0,a0,356 # 800080b8 <digits+0x88>
    80000f5c:	fffff097          	auipc	ra,0xfffff
    80000f60:	636080e7          	jalr	1590(ra) # 80000592 <printf>
    kinit();         // physical page allocator
    80000f64:	00000097          	auipc	ra,0x0
    80000f68:	b80080e7          	jalr	-1152(ra) # 80000ae4 <kinit>
    kvminit();       // create kernel page table
    80000f6c:	00000097          	auipc	ra,0x0
    80000f70:	476080e7          	jalr	1142(ra) # 800013e2 <kvminit>
    kvminithart();   // turn on paging
    80000f74:	00000097          	auipc	ra,0x0
    80000f78:	11a080e7          	jalr	282(ra) # 8000108e <kvminithart>
    procinit();      // process table
    80000f7c:	00001097          	auipc	ra,0x1
    80000f80:	cc0080e7          	jalr	-832(ra) # 80001c3c <procinit>
    trapinit();      // trap vectors
    80000f84:	00002097          	auipc	ra,0x2
    80000f88:	ab6080e7          	jalr	-1354(ra) # 80002a3a <trapinit>
    trapinithart();  // install kernel trap vector
    80000f8c:	00002097          	auipc	ra,0x2
    80000f90:	ad6080e7          	jalr	-1322(ra) # 80002a62 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f94:	00005097          	auipc	ra,0x5
    80000f98:	086080e7          	jalr	134(ra) # 8000601a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f9c:	00005097          	auipc	ra,0x5
    80000fa0:	094080e7          	jalr	148(ra) # 80006030 <plicinithart>
    binit();         // buffer cache
    80000fa4:	00002097          	auipc	ra,0x2
    80000fa8:	200080e7          	jalr	512(ra) # 800031a4 <binit>
    iinit();         // inode cache
    80000fac:	00003097          	auipc	ra,0x3
    80000fb0:	890080e7          	jalr	-1904(ra) # 8000383c <iinit>
    fileinit();      // file table
    80000fb4:	00004097          	auipc	ra,0x4
    80000fb8:	82a080e7          	jalr	-2006(ra) # 800047de <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fbc:	00005097          	auipc	ra,0x5
    80000fc0:	17c080e7          	jalr	380(ra) # 80006138 <virtio_disk_init>
    userinit();      // first user process
    80000fc4:	00001097          	auipc	ra,0x1
    80000fc8:	056080e7          	jalr	86(ra) # 8000201a <userinit>
    __sync_synchronize();
    80000fcc:	0ff0000f          	fence
    started = 1;
    80000fd0:	4785                	li	a5,1
    80000fd2:	00008717          	auipc	a4,0x8
    80000fd6:	02f72d23          	sw	a5,58(a4) # 8000900c <started>
    80000fda:	bf2d                	j	80000f14 <main+0x56>

0000000080000fdc <vmprint_helper>:
  }*/
   return copyinstr_new(pagetable,dst,srcva,max);
}
// lab3 pgtbl : print vm
static void vmprint_helper(pagetable_t pagetable,int level){
    if(level > 3)
    80000fdc:	478d                	li	a5,3
    80000fde:	0ab7c763          	blt	a5,a1,8000108c <vmprint_helper+0xb0>
static void vmprint_helper(pagetable_t pagetable,int level){
    80000fe2:	7159                	addi	sp,sp,-112
    80000fe4:	f486                	sd	ra,104(sp)
    80000fe6:	f0a2                	sd	s0,96(sp)
    80000fe8:	eca6                	sd	s1,88(sp)
    80000fea:	e8ca                	sd	s2,80(sp)
    80000fec:	e4ce                	sd	s3,72(sp)
    80000fee:	e0d2                	sd	s4,64(sp)
    80000ff0:	fc56                	sd	s5,56(sp)
    80000ff2:	f85a                	sd	s6,48(sp)
    80000ff4:	f45e                	sd	s7,40(sp)
    80000ff6:	f062                	sd	s8,32(sp)
    80000ff8:	ec66                	sd	s9,24(sp)
    80000ffa:	e86a                	sd	s10,16(sp)
    80000ffc:	e46e                	sd	s11,8(sp)
    80000ffe:	1880                	addi	s0,sp,112
    80001000:	8aae                	mv	s5,a1
    80001002:	892a                	mv	s2,a0
        return;
    for(int i = 0; i < 512; i++){
    80001004:	4481                	li	s1,0
        pte_t pte = pagetable[i];
        if(pte & PTE_V){
            uint64 child = PTE2PA(pte);
            for(int j = 0; j < level; j++)
                printf(" ..");
            printf("%d: pte %p pa %p\n",i,pte,child);
    80001006:	00007c97          	auipc	s9,0x7
    8000100a:	0c2c8c93          	addi	s9,s9,194 # 800080c8 <digits+0x98>
            vmprint_helper((pagetable_t)child,level+1);
    8000100e:	00158c1b          	addiw	s8,a1,1
            for(int j = 0; j < level; j++)
    80001012:	4d01                	li	s10,0
                printf(" ..");
    80001014:	00007b97          	auipc	s7,0x7
    80001018:	0acb8b93          	addi	s7,s7,172 # 800080c0 <digits+0x90>
    for(int i = 0; i < 512; i++){
    8000101c:	20000b13          	li	s6,512
    80001020:	a01d                	j	80001046 <vmprint_helper+0x6a>
            printf("%d: pte %p pa %p\n",i,pte,child);
    80001022:	86ee                	mv	a3,s11
    80001024:	8652                	mv	a2,s4
    80001026:	85a6                	mv	a1,s1
    80001028:	8566                	mv	a0,s9
    8000102a:	fffff097          	auipc	ra,0xfffff
    8000102e:	568080e7          	jalr	1384(ra) # 80000592 <printf>
            vmprint_helper((pagetable_t)child,level+1);
    80001032:	85e2                	mv	a1,s8
    80001034:	856e                	mv	a0,s11
    80001036:	00000097          	auipc	ra,0x0
    8000103a:	fa6080e7          	jalr	-90(ra) # 80000fdc <vmprint_helper>
    for(int i = 0; i < 512; i++){
    8000103e:	2485                	addiw	s1,s1,1
    80001040:	0921                	addi	s2,s2,8
    80001042:	03648663          	beq	s1,s6,8000106e <vmprint_helper+0x92>
        pte_t pte = pagetable[i];
    80001046:	00093a03          	ld	s4,0(s2)
        if(pte & PTE_V){
    8000104a:	001a7793          	andi	a5,s4,1
    8000104e:	dbe5                	beqz	a5,8000103e <vmprint_helper+0x62>
            uint64 child = PTE2PA(pte);
    80001050:	00aa5d93          	srli	s11,s4,0xa
    80001054:	0db2                	slli	s11,s11,0xc
            for(int j = 0; j < level; j++)
    80001056:	fd5056e3          	blez	s5,80001022 <vmprint_helper+0x46>
    8000105a:	89ea                	mv	s3,s10
                printf(" ..");
    8000105c:	855e                	mv	a0,s7
    8000105e:	fffff097          	auipc	ra,0xfffff
    80001062:	534080e7          	jalr	1332(ra) # 80000592 <printf>
            for(int j = 0; j < level; j++)
    80001066:	2985                	addiw	s3,s3,1
    80001068:	ff3a9ae3          	bne	s5,s3,8000105c <vmprint_helper+0x80>
    8000106c:	bf5d                	j	80001022 <vmprint_helper+0x46>
        }
    }
}
    8000106e:	70a6                	ld	ra,104(sp)
    80001070:	7406                	ld	s0,96(sp)
    80001072:	64e6                	ld	s1,88(sp)
    80001074:	6946                	ld	s2,80(sp)
    80001076:	69a6                	ld	s3,72(sp)
    80001078:	6a06                	ld	s4,64(sp)
    8000107a:	7ae2                	ld	s5,56(sp)
    8000107c:	7b42                	ld	s6,48(sp)
    8000107e:	7ba2                	ld	s7,40(sp)
    80001080:	7c02                	ld	s8,32(sp)
    80001082:	6ce2                	ld	s9,24(sp)
    80001084:	6d42                	ld	s10,16(sp)
    80001086:	6da2                	ld	s11,8(sp)
    80001088:	6165                	addi	sp,sp,112
    8000108a:	8082                	ret
    8000108c:	8082                	ret

000000008000108e <kvminithart>:
{
    8000108e:	1141                	addi	sp,sp,-16
    80001090:	e422                	sd	s0,8(sp)
    80001092:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80001094:	00008797          	auipc	a5,0x8
    80001098:	f7c7b783          	ld	a5,-132(a5) # 80009010 <kernel_pagetable>
    8000109c:	83b1                	srli	a5,a5,0xc
    8000109e:	577d                	li	a4,-1
    800010a0:	177e                	slli	a4,a4,0x3f
    800010a2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800010a4:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800010a8:	12000073          	sfence.vma
}
    800010ac:	6422                	ld	s0,8(sp)
    800010ae:	0141                	addi	sp,sp,16
    800010b0:	8082                	ret

00000000800010b2 <walk>:
{
    800010b2:	7139                	addi	sp,sp,-64
    800010b4:	fc06                	sd	ra,56(sp)
    800010b6:	f822                	sd	s0,48(sp)
    800010b8:	f426                	sd	s1,40(sp)
    800010ba:	f04a                	sd	s2,32(sp)
    800010bc:	ec4e                	sd	s3,24(sp)
    800010be:	e852                	sd	s4,16(sp)
    800010c0:	e456                	sd	s5,8(sp)
    800010c2:	e05a                	sd	s6,0(sp)
    800010c4:	0080                	addi	s0,sp,64
    800010c6:	84aa                	mv	s1,a0
    800010c8:	89ae                	mv	s3,a1
    800010ca:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800010cc:	57fd                	li	a5,-1
    800010ce:	83e9                	srli	a5,a5,0x1a
    800010d0:	4a79                	li	s4,30
  for(int level = 2; level > 0; level--) {
    800010d2:	4b31                	li	s6,12
  if(va >= MAXVA)
    800010d4:	04b7f263          	bgeu	a5,a1,80001118 <walk+0x66>
    panic("walk");
    800010d8:	00007517          	auipc	a0,0x7
    800010dc:	00850513          	addi	a0,a0,8 # 800080e0 <digits+0xb0>
    800010e0:	fffff097          	auipc	ra,0xfffff
    800010e4:	468080e7          	jalr	1128(ra) # 80000548 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800010e8:	060a8663          	beqz	s5,80001154 <walk+0xa2>
    800010ec:	00000097          	auipc	ra,0x0
    800010f0:	a34080e7          	jalr	-1484(ra) # 80000b20 <kalloc>
    800010f4:	84aa                	mv	s1,a0
    800010f6:	c529                	beqz	a0,80001140 <walk+0x8e>
      memset(pagetable, 0, PGSIZE);
    800010f8:	6605                	lui	a2,0x1
    800010fa:	4581                	li	a1,0
    800010fc:	00000097          	auipc	ra,0x0
    80001100:	c10080e7          	jalr	-1008(ra) # 80000d0c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001104:	00c4d793          	srli	a5,s1,0xc
    80001108:	07aa                	slli	a5,a5,0xa
    8000110a:	0017e793          	ori	a5,a5,1
    8000110e:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001112:	3a5d                	addiw	s4,s4,-9
    80001114:	036a0063          	beq	s4,s6,80001134 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001118:	0149d933          	srl	s2,s3,s4
    8000111c:	1ff97913          	andi	s2,s2,511
    80001120:	090e                	slli	s2,s2,0x3
    80001122:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001124:	00093483          	ld	s1,0(s2)
    80001128:	0014f793          	andi	a5,s1,1
    8000112c:	dfd5                	beqz	a5,800010e8 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000112e:	80a9                	srli	s1,s1,0xa
    80001130:	04b2                	slli	s1,s1,0xc
    80001132:	b7c5                	j	80001112 <walk+0x60>
  return &pagetable[PX(0, va)];
    80001134:	00c9d513          	srli	a0,s3,0xc
    80001138:	1ff57513          	andi	a0,a0,511
    8000113c:	050e                	slli	a0,a0,0x3
    8000113e:	9526                	add	a0,a0,s1
}
    80001140:	70e2                	ld	ra,56(sp)
    80001142:	7442                	ld	s0,48(sp)
    80001144:	74a2                	ld	s1,40(sp)
    80001146:	7902                	ld	s2,32(sp)
    80001148:	69e2                	ld	s3,24(sp)
    8000114a:	6a42                	ld	s4,16(sp)
    8000114c:	6aa2                	ld	s5,8(sp)
    8000114e:	6b02                	ld	s6,0(sp)
    80001150:	6121                	addi	sp,sp,64
    80001152:	8082                	ret
        return 0;
    80001154:	4501                	li	a0,0
    80001156:	b7ed                	j	80001140 <walk+0x8e>

0000000080001158 <walkaddr>:
  if(va >= MAXVA)
    80001158:	57fd                	li	a5,-1
    8000115a:	83e9                	srli	a5,a5,0x1a
    8000115c:	00b7f463          	bgeu	a5,a1,80001164 <walkaddr+0xc>
    return 0;
    80001160:	4501                	li	a0,0
}
    80001162:	8082                	ret
{
    80001164:	1141                	addi	sp,sp,-16
    80001166:	e406                	sd	ra,8(sp)
    80001168:	e022                	sd	s0,0(sp)
    8000116a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000116c:	4601                	li	a2,0
    8000116e:	00000097          	auipc	ra,0x0
    80001172:	f44080e7          	jalr	-188(ra) # 800010b2 <walk>
  if(pte == 0)
    80001176:	c105                	beqz	a0,80001196 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001178:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000117a:	0117f693          	andi	a3,a5,17
    8000117e:	4745                	li	a4,17
    return 0;
    80001180:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001182:	00e68663          	beq	a3,a4,8000118e <walkaddr+0x36>
}
    80001186:	60a2                	ld	ra,8(sp)
    80001188:	6402                	ld	s0,0(sp)
    8000118a:	0141                	addi	sp,sp,16
    8000118c:	8082                	ret
  pa = PTE2PA(*pte);
    8000118e:	00a7d513          	srli	a0,a5,0xa
    80001192:	0532                	slli	a0,a0,0xc
  return pa;
    80001194:	bfcd                	j	80001186 <walkaddr+0x2e>
    return 0;
    80001196:	4501                	li	a0,0
    80001198:	b7fd                	j	80001186 <walkaddr+0x2e>

000000008000119a <kvmpa>:
{
    8000119a:	1101                	addi	sp,sp,-32
    8000119c:	ec06                	sd	ra,24(sp)
    8000119e:	e822                	sd	s0,16(sp)
    800011a0:	e426                	sd	s1,8(sp)
    800011a2:	e04a                	sd	s2,0(sp)
    800011a4:	1000                	addi	s0,sp,32
    800011a6:	84aa                	mv	s1,a0
  uint64 off = va % PGSIZE;
    800011a8:	1552                	slli	a0,a0,0x34
    800011aa:	03455913          	srli	s2,a0,0x34
  pte = walk(myproc()->kpagetable, va, 0);
    800011ae:	00001097          	auipc	ra,0x1
    800011b2:	b22080e7          	jalr	-1246(ra) # 80001cd0 <myproc>
    800011b6:	4601                	li	a2,0
    800011b8:	85a6                	mv	a1,s1
    800011ba:	6d28                	ld	a0,88(a0)
    800011bc:	00000097          	auipc	ra,0x0
    800011c0:	ef6080e7          	jalr	-266(ra) # 800010b2 <walk>
  if(pte == 0)
    800011c4:	cd11                	beqz	a0,800011e0 <kvmpa+0x46>
  if((*pte & PTE_V) == 0)
    800011c6:	6108                	ld	a0,0(a0)
    800011c8:	00157793          	andi	a5,a0,1
    800011cc:	c395                	beqz	a5,800011f0 <kvmpa+0x56>
  pa = PTE2PA(*pte);
    800011ce:	8129                	srli	a0,a0,0xa
    800011d0:	0532                	slli	a0,a0,0xc
}
    800011d2:	954a                	add	a0,a0,s2
    800011d4:	60e2                	ld	ra,24(sp)
    800011d6:	6442                	ld	s0,16(sp)
    800011d8:	64a2                	ld	s1,8(sp)
    800011da:	6902                	ld	s2,0(sp)
    800011dc:	6105                	addi	sp,sp,32
    800011de:	8082                	ret
    panic("kvmpa");
    800011e0:	00007517          	auipc	a0,0x7
    800011e4:	f0850513          	addi	a0,a0,-248 # 800080e8 <digits+0xb8>
    800011e8:	fffff097          	auipc	ra,0xfffff
    800011ec:	360080e7          	jalr	864(ra) # 80000548 <panic>
    panic("kvmpa");
    800011f0:	00007517          	auipc	a0,0x7
    800011f4:	ef850513          	addi	a0,a0,-264 # 800080e8 <digits+0xb8>
    800011f8:	fffff097          	auipc	ra,0xfffff
    800011fc:	350080e7          	jalr	848(ra) # 80000548 <panic>

0000000080001200 <mappages>:
{
    80001200:	715d                	addi	sp,sp,-80
    80001202:	e486                	sd	ra,72(sp)
    80001204:	e0a2                	sd	s0,64(sp)
    80001206:	fc26                	sd	s1,56(sp)
    80001208:	f84a                	sd	s2,48(sp)
    8000120a:	f44e                	sd	s3,40(sp)
    8000120c:	f052                	sd	s4,32(sp)
    8000120e:	ec56                	sd	s5,24(sp)
    80001210:	e85a                	sd	s6,16(sp)
    80001212:	e45e                	sd	s7,8(sp)
    80001214:	0880                	addi	s0,sp,80
    80001216:	8a2a                	mv	s4,a0
    80001218:	8b3a                	mv	s6,a4
  a = PGROUNDDOWN(va);
    8000121a:	777d                	lui	a4,0xfffff
    8000121c:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001220:	167d                	addi	a2,a2,-1
    80001222:	00b609b3          	add	s3,a2,a1
    80001226:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000122a:	893e                	mv	s2,a5
    8000122c:	40f68ab3          	sub	s5,a3,a5
    a += PGSIZE;
    80001230:	6b85                	lui	s7,0x1
    80001232:	012a84b3          	add	s1,s5,s2
    if((pte = walk(pagetable, a, 1)) == 0){
    80001236:	4605                	li	a2,1
    80001238:	85ca                	mv	a1,s2
    8000123a:	8552                	mv	a0,s4
    8000123c:	00000097          	auipc	ra,0x0
    80001240:	e76080e7          	jalr	-394(ra) # 800010b2 <walk>
    80001244:	c931                	beqz	a0,80001298 <mappages+0x98>
    if(*pte & PTE_V){
    80001246:	611c                	ld	a5,0(a0)
    80001248:	8b85                	andi	a5,a5,1
    8000124a:	ef81                	bnez	a5,80001262 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000124c:	80b1                	srli	s1,s1,0xc
    8000124e:	04aa                	slli	s1,s1,0xa
    80001250:	0164e4b3          	or	s1,s1,s6
    80001254:	0014e493          	ori	s1,s1,1
    80001258:	e104                	sd	s1,0(a0)
    if(a == last)
    8000125a:	05390b63          	beq	s2,s3,800012b0 <mappages+0xb0>
    a += PGSIZE;
    8000125e:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0){
    80001260:	bfc9                	j	80001232 <mappages+0x32>
        printf("va = %p,pa = %p\n",a,PTE2PA(*walk(pagetable,a,0)));
    80001262:	4601                	li	a2,0
    80001264:	85ca                	mv	a1,s2
    80001266:	8552                	mv	a0,s4
    80001268:	00000097          	auipc	ra,0x0
    8000126c:	e4a080e7          	jalr	-438(ra) # 800010b2 <walk>
    80001270:	6110                	ld	a2,0(a0)
    80001272:	8229                	srli	a2,a2,0xa
    80001274:	0632                	slli	a2,a2,0xc
    80001276:	85ca                	mv	a1,s2
    80001278:	00007517          	auipc	a0,0x7
    8000127c:	e7850513          	addi	a0,a0,-392 # 800080f0 <digits+0xc0>
    80001280:	fffff097          	auipc	ra,0xfffff
    80001284:	312080e7          	jalr	786(ra) # 80000592 <printf>
      panic("remap");
    80001288:	00007517          	auipc	a0,0x7
    8000128c:	e8050513          	addi	a0,a0,-384 # 80008108 <digits+0xd8>
    80001290:	fffff097          	auipc	ra,0xfffff
    80001294:	2b8080e7          	jalr	696(ra) # 80000548 <panic>
      return -1;
    80001298:	557d                	li	a0,-1
}
    8000129a:	60a6                	ld	ra,72(sp)
    8000129c:	6406                	ld	s0,64(sp)
    8000129e:	74e2                	ld	s1,56(sp)
    800012a0:	7942                	ld	s2,48(sp)
    800012a2:	79a2                	ld	s3,40(sp)
    800012a4:	7a02                	ld	s4,32(sp)
    800012a6:	6ae2                	ld	s5,24(sp)
    800012a8:	6b42                	ld	s6,16(sp)
    800012aa:	6ba2                	ld	s7,8(sp)
    800012ac:	6161                	addi	sp,sp,80
    800012ae:	8082                	ret
  return 0;
    800012b0:	4501                	li	a0,0
    800012b2:	b7e5                	j	8000129a <mappages+0x9a>

00000000800012b4 <user_kvmmap>:
{
    800012b4:	1141                	addi	sp,sp,-16
    800012b6:	e406                	sd	ra,8(sp)
    800012b8:	e022                	sd	s0,0(sp)
    800012ba:	0800                	addi	s0,sp,16
  if(mappages(kpagetable, va, sz, pa, perm) != 0){
    800012bc:	00000097          	auipc	ra,0x0
    800012c0:	f44080e7          	jalr	-188(ra) # 80001200 <mappages>
    800012c4:	e509                	bnez	a0,800012ce <user_kvmmap+0x1a>
}
    800012c6:	60a2                	ld	ra,8(sp)
    800012c8:	6402                	ld	s0,0(sp)
    800012ca:	0141                	addi	sp,sp,16
    800012cc:	8082                	ret
    panic("user_kvmmap");
    800012ce:	00007517          	auipc	a0,0x7
    800012d2:	e4250513          	addi	a0,a0,-446 # 80008110 <digits+0xe0>
    800012d6:	fffff097          	auipc	ra,0xfffff
    800012da:	272080e7          	jalr	626(ra) # 80000548 <panic>

00000000800012de <user_kvmcreate>:
{
    800012de:	1101                	addi	sp,sp,-32
    800012e0:	ec06                	sd	ra,24(sp)
    800012e2:	e822                	sd	s0,16(sp)
    800012e4:	e426                	sd	s1,8(sp)
    800012e6:	e04a                	sd	s2,0(sp)
    800012e8:	1000                	addi	s0,sp,32
  pagetable_t kpagetable = (pagetable_t) kalloc();
    800012ea:	00000097          	auipc	ra,0x0
    800012ee:	836080e7          	jalr	-1994(ra) # 80000b20 <kalloc>
    800012f2:	84aa                	mv	s1,a0
  memset(kpagetable, 0, PGSIZE);
    800012f4:	6605                	lui	a2,0x1
    800012f6:	4581                	li	a1,0
    800012f8:	00000097          	auipc	ra,0x0
    800012fc:	a14080e7          	jalr	-1516(ra) # 80000d0c <memset>
  user_kvmmap(kpagetable,UART0,PGSIZE, UART0, PTE_R | PTE_W);
    80001300:	4719                	li	a4,6
    80001302:	100006b7          	lui	a3,0x10000
    80001306:	6605                	lui	a2,0x1
    80001308:	100005b7          	lui	a1,0x10000
    8000130c:	8526                	mv	a0,s1
    8000130e:	00000097          	auipc	ra,0x0
    80001312:	fa6080e7          	jalr	-90(ra) # 800012b4 <user_kvmmap>
  user_kvmmap(kpagetable,VIRTIO0, PGSIZE,VIRTIO0, PTE_R | PTE_W);
    80001316:	4719                	li	a4,6
    80001318:	100016b7          	lui	a3,0x10001
    8000131c:	6605                	lui	a2,0x1
    8000131e:	100015b7          	lui	a1,0x10001
    80001322:	8526                	mv	a0,s1
    80001324:	00000097          	auipc	ra,0x0
    80001328:	f90080e7          	jalr	-112(ra) # 800012b4 <user_kvmmap>
  user_kvmmap(kpagetable,PLIC,0x400000,PLIC, PTE_R | PTE_W);
    8000132c:	4719                	li	a4,6
    8000132e:	0c0006b7          	lui	a3,0xc000
    80001332:	00400637          	lui	a2,0x400
    80001336:	0c0005b7          	lui	a1,0xc000
    8000133a:	8526                	mv	a0,s1
    8000133c:	00000097          	auipc	ra,0x0
    80001340:	f78080e7          	jalr	-136(ra) # 800012b4 <user_kvmmap>
  user_kvmmap(kpagetable,KERNBASE,(uint64)etext-KERNBASE,KERNBASE, PTE_R | PTE_X);
    80001344:	00007917          	auipc	s2,0x7
    80001348:	cbc90913          	addi	s2,s2,-836 # 80008000 <etext>
    8000134c:	4729                	li	a4,10
    8000134e:	4685                	li	a3,1
    80001350:	06fe                	slli	a3,a3,0x1f
    80001352:	80007617          	auipc	a2,0x80007
    80001356:	cae60613          	addi	a2,a2,-850 # 8000 <_entry-0x7fff8000>
    8000135a:	85b6                	mv	a1,a3
    8000135c:	8526                	mv	a0,s1
    8000135e:	00000097          	auipc	ra,0x0
    80001362:	f56080e7          	jalr	-170(ra) # 800012b4 <user_kvmmap>
  user_kvmmap(kpagetable,(uint64)etext,PHYSTOP-(uint64)etext,(uint64)etext, PTE_R | PTE_W);
    80001366:	4719                	li	a4,6
    80001368:	86ca                	mv	a3,s2
    8000136a:	4645                	li	a2,17
    8000136c:	066e                	slli	a2,a2,0x1b
    8000136e:	41260633          	sub	a2,a2,s2
    80001372:	85ca                	mv	a1,s2
    80001374:	8526                	mv	a0,s1
    80001376:	00000097          	auipc	ra,0x0
    8000137a:	f3e080e7          	jalr	-194(ra) # 800012b4 <user_kvmmap>
  user_kvmmap(kpagetable,TRAMPOLINE, PGSIZE,(uint64)trampoline, PTE_R | PTE_X);
    8000137e:	4729                	li	a4,10
    80001380:	00006697          	auipc	a3,0x6
    80001384:	c8068693          	addi	a3,a3,-896 # 80007000 <_trampoline>
    80001388:	6605                	lui	a2,0x1
    8000138a:	040005b7          	lui	a1,0x4000
    8000138e:	15fd                	addi	a1,a1,-1
    80001390:	05b2                	slli	a1,a1,0xc
    80001392:	8526                	mv	a0,s1
    80001394:	00000097          	auipc	ra,0x0
    80001398:	f20080e7          	jalr	-224(ra) # 800012b4 <user_kvmmap>
}
    8000139c:	8526                	mv	a0,s1
    8000139e:	60e2                	ld	ra,24(sp)
    800013a0:	6442                	ld	s0,16(sp)
    800013a2:	64a2                	ld	s1,8(sp)
    800013a4:	6902                	ld	s2,0(sp)
    800013a6:	6105                	addi	sp,sp,32
    800013a8:	8082                	ret

00000000800013aa <kvmmap>:
{
    800013aa:	1141                	addi	sp,sp,-16
    800013ac:	e406                	sd	ra,8(sp)
    800013ae:	e022                	sd	s0,0(sp)
    800013b0:	0800                	addi	s0,sp,16
    800013b2:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800013b4:	86ae                	mv	a3,a1
    800013b6:	85aa                	mv	a1,a0
    800013b8:	00008517          	auipc	a0,0x8
    800013bc:	c5853503          	ld	a0,-936(a0) # 80009010 <kernel_pagetable>
    800013c0:	00000097          	auipc	ra,0x0
    800013c4:	e40080e7          	jalr	-448(ra) # 80001200 <mappages>
    800013c8:	e509                	bnez	a0,800013d2 <kvmmap+0x28>
}
    800013ca:	60a2                	ld	ra,8(sp)
    800013cc:	6402                	ld	s0,0(sp)
    800013ce:	0141                	addi	sp,sp,16
    800013d0:	8082                	ret
    panic("kvmmap");
    800013d2:	00007517          	auipc	a0,0x7
    800013d6:	d4e50513          	addi	a0,a0,-690 # 80008120 <digits+0xf0>
    800013da:	fffff097          	auipc	ra,0xfffff
    800013de:	16e080e7          	jalr	366(ra) # 80000548 <panic>

00000000800013e2 <kvminit>:
{
    800013e2:	1101                	addi	sp,sp,-32
    800013e4:	ec06                	sd	ra,24(sp)
    800013e6:	e822                	sd	s0,16(sp)
    800013e8:	e426                	sd	s1,8(sp)
    800013ea:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    800013ec:	fffff097          	auipc	ra,0xfffff
    800013f0:	734080e7          	jalr	1844(ra) # 80000b20 <kalloc>
    800013f4:	00008797          	auipc	a5,0x8
    800013f8:	c0a7be23          	sd	a0,-996(a5) # 80009010 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    800013fc:	6605                	lui	a2,0x1
    800013fe:	4581                	li	a1,0
    80001400:	00000097          	auipc	ra,0x0
    80001404:	90c080e7          	jalr	-1780(ra) # 80000d0c <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001408:	4699                	li	a3,6
    8000140a:	6605                	lui	a2,0x1
    8000140c:	100005b7          	lui	a1,0x10000
    80001410:	10000537          	lui	a0,0x10000
    80001414:	00000097          	auipc	ra,0x0
    80001418:	f96080e7          	jalr	-106(ra) # 800013aa <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000141c:	4699                	li	a3,6
    8000141e:	6605                	lui	a2,0x1
    80001420:	100015b7          	lui	a1,0x10001
    80001424:	10001537          	lui	a0,0x10001
    80001428:	00000097          	auipc	ra,0x0
    8000142c:	f82080e7          	jalr	-126(ra) # 800013aa <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001430:	4699                	li	a3,6
    80001432:	00400637          	lui	a2,0x400
    80001436:	0c0005b7          	lui	a1,0xc000
    8000143a:	0c000537          	lui	a0,0xc000
    8000143e:	00000097          	auipc	ra,0x0
    80001442:	f6c080e7          	jalr	-148(ra) # 800013aa <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001446:	00007497          	auipc	s1,0x7
    8000144a:	bba48493          	addi	s1,s1,-1094 # 80008000 <etext>
    8000144e:	46a9                	li	a3,10
    80001450:	80007617          	auipc	a2,0x80007
    80001454:	bb060613          	addi	a2,a2,-1104 # 8000 <_entry-0x7fff8000>
    80001458:	4585                	li	a1,1
    8000145a:	05fe                	slli	a1,a1,0x1f
    8000145c:	852e                	mv	a0,a1
    8000145e:	00000097          	auipc	ra,0x0
    80001462:	f4c080e7          	jalr	-180(ra) # 800013aa <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001466:	4699                	li	a3,6
    80001468:	4645                	li	a2,17
    8000146a:	066e                	slli	a2,a2,0x1b
    8000146c:	8e05                	sub	a2,a2,s1
    8000146e:	85a6                	mv	a1,s1
    80001470:	8526                	mv	a0,s1
    80001472:	00000097          	auipc	ra,0x0
    80001476:	f38080e7          	jalr	-200(ra) # 800013aa <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000147a:	46a9                	li	a3,10
    8000147c:	6605                	lui	a2,0x1
    8000147e:	00006597          	auipc	a1,0x6
    80001482:	b8258593          	addi	a1,a1,-1150 # 80007000 <_trampoline>
    80001486:	04000537          	lui	a0,0x4000
    8000148a:	157d                	addi	a0,a0,-1
    8000148c:	0532                	slli	a0,a0,0xc
    8000148e:	00000097          	auipc	ra,0x0
    80001492:	f1c080e7          	jalr	-228(ra) # 800013aa <kvmmap>
}
    80001496:	60e2                	ld	ra,24(sp)
    80001498:	6442                	ld	s0,16(sp)
    8000149a:	64a2                	ld	s1,8(sp)
    8000149c:	6105                	addi	sp,sp,32
    8000149e:	8082                	ret

00000000800014a0 <uvmunmap>:
{
    800014a0:	715d                	addi	sp,sp,-80
    800014a2:	e486                	sd	ra,72(sp)
    800014a4:	e0a2                	sd	s0,64(sp)
    800014a6:	fc26                	sd	s1,56(sp)
    800014a8:	f84a                	sd	s2,48(sp)
    800014aa:	f44e                	sd	s3,40(sp)
    800014ac:	f052                	sd	s4,32(sp)
    800014ae:	ec56                	sd	s5,24(sp)
    800014b0:	e85a                	sd	s6,16(sp)
    800014b2:	e45e                	sd	s7,8(sp)
    800014b4:	0880                	addi	s0,sp,80
  if((va % PGSIZE) != 0)
    800014b6:	03459793          	slli	a5,a1,0x34
    800014ba:	e795                	bnez	a5,800014e6 <uvmunmap+0x46>
    800014bc:	8a2a                	mv	s4,a0
    800014be:	892e                	mv	s2,a1
    800014c0:	8ab6                	mv	s5,a3
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800014c2:	0632                	slli	a2,a2,0xc
    800014c4:	00b609b3          	add	s3,a2,a1
    if(PTE_FLAGS(*pte) == PTE_V)
    800014c8:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800014ca:	6b05                	lui	s6,0x1
    800014cc:	0935e163          	bltu	a1,s3,8000154e <uvmunmap+0xae>
}
    800014d0:	60a6                	ld	ra,72(sp)
    800014d2:	6406                	ld	s0,64(sp)
    800014d4:	74e2                	ld	s1,56(sp)
    800014d6:	7942                	ld	s2,48(sp)
    800014d8:	79a2                	ld	s3,40(sp)
    800014da:	7a02                	ld	s4,32(sp)
    800014dc:	6ae2                	ld	s5,24(sp)
    800014de:	6b42                	ld	s6,16(sp)
    800014e0:	6ba2                	ld	s7,8(sp)
    800014e2:	6161                	addi	sp,sp,80
    800014e4:	8082                	ret
    panic("uvmunmap: not aligned");
    800014e6:	00007517          	auipc	a0,0x7
    800014ea:	c4250513          	addi	a0,a0,-958 # 80008128 <digits+0xf8>
    800014ee:	fffff097          	auipc	ra,0xfffff
    800014f2:	05a080e7          	jalr	90(ra) # 80000548 <panic>
          printf("va = %p",a);
    800014f6:	85ca                	mv	a1,s2
    800014f8:	00007517          	auipc	a0,0x7
    800014fc:	c4850513          	addi	a0,a0,-952 # 80008140 <digits+0x110>
    80001500:	fffff097          	auipc	ra,0xfffff
    80001504:	092080e7          	jalr	146(ra) # 80000592 <printf>
          panic("uvmunmap: walk");
    80001508:	00007517          	auipc	a0,0x7
    8000150c:	c4050513          	addi	a0,a0,-960 # 80008148 <digits+0x118>
    80001510:	fffff097          	auipc	ra,0xfffff
    80001514:	038080e7          	jalr	56(ra) # 80000548 <panic>
      panic("uvmunmap: not mapped");
    80001518:	00007517          	auipc	a0,0x7
    8000151c:	c4050513          	addi	a0,a0,-960 # 80008158 <digits+0x128>
    80001520:	fffff097          	auipc	ra,0xfffff
    80001524:	028080e7          	jalr	40(ra) # 80000548 <panic>
      panic("uvmunmap: not a leaf");
    80001528:	00007517          	auipc	a0,0x7
    8000152c:	c4850513          	addi	a0,a0,-952 # 80008170 <digits+0x140>
    80001530:	fffff097          	auipc	ra,0xfffff
    80001534:	018080e7          	jalr	24(ra) # 80000548 <panic>
      uint64 pa = PTE2PA(*pte);
    80001538:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000153a:	0532                	slli	a0,a0,0xc
    8000153c:	fffff097          	auipc	ra,0xfffff
    80001540:	4e8080e7          	jalr	1256(ra) # 80000a24 <kfree>
    *pte = 0;
    80001544:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001548:	995a                	add	s2,s2,s6
    8000154a:	f93973e3          	bgeu	s2,s3,800014d0 <uvmunmap+0x30>
      if((pte = walk(pagetable, a, 0)) == 0){
    8000154e:	4601                	li	a2,0
    80001550:	85ca                	mv	a1,s2
    80001552:	8552                	mv	a0,s4
    80001554:	00000097          	auipc	ra,0x0
    80001558:	b5e080e7          	jalr	-1186(ra) # 800010b2 <walk>
    8000155c:	84aa                	mv	s1,a0
    8000155e:	dd41                	beqz	a0,800014f6 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0){
    80001560:	6108                	ld	a0,0(a0)
    80001562:	00157793          	andi	a5,a0,1
    80001566:	dbcd                	beqz	a5,80001518 <uvmunmap+0x78>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001568:	3ff57793          	andi	a5,a0,1023
    8000156c:	fb778ee3          	beq	a5,s7,80001528 <uvmunmap+0x88>
    if(do_free){
    80001570:	fc0a8ae3          	beqz	s5,80001544 <uvmunmap+0xa4>
    80001574:	b7d1                	j	80001538 <uvmunmap+0x98>

0000000080001576 <uvmcreate>:
{
    80001576:	1101                	addi	sp,sp,-32
    80001578:	ec06                	sd	ra,24(sp)
    8000157a:	e822                	sd	s0,16(sp)
    8000157c:	e426                	sd	s1,8(sp)
    8000157e:	1000                	addi	s0,sp,32
  pagetable = (pagetable_t) kalloc();
    80001580:	fffff097          	auipc	ra,0xfffff
    80001584:	5a0080e7          	jalr	1440(ra) # 80000b20 <kalloc>
    80001588:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000158a:	c519                	beqz	a0,80001598 <uvmcreate+0x22>
  memset(pagetable, 0, PGSIZE);
    8000158c:	6605                	lui	a2,0x1
    8000158e:	4581                	li	a1,0
    80001590:	fffff097          	auipc	ra,0xfffff
    80001594:	77c080e7          	jalr	1916(ra) # 80000d0c <memset>
}
    80001598:	8526                	mv	a0,s1
    8000159a:	60e2                	ld	ra,24(sp)
    8000159c:	6442                	ld	s0,16(sp)
    8000159e:	64a2                	ld	s1,8(sp)
    800015a0:	6105                	addi	sp,sp,32
    800015a2:	8082                	ret

00000000800015a4 <uvminit>:
{
    800015a4:	7179                	addi	sp,sp,-48
    800015a6:	f406                	sd	ra,40(sp)
    800015a8:	f022                	sd	s0,32(sp)
    800015aa:	ec26                	sd	s1,24(sp)
    800015ac:	e84a                	sd	s2,16(sp)
    800015ae:	e44e                	sd	s3,8(sp)
    800015b0:	e052                	sd	s4,0(sp)
    800015b2:	1800                	addi	s0,sp,48
  if(sz >= PGSIZE)
    800015b4:	6785                	lui	a5,0x1
    800015b6:	04f67863          	bgeu	a2,a5,80001606 <uvminit+0x62>
    800015ba:	8a2a                	mv	s4,a0
    800015bc:	89ae                	mv	s3,a1
    800015be:	84b2                	mv	s1,a2
  mem = kalloc();
    800015c0:	fffff097          	auipc	ra,0xfffff
    800015c4:	560080e7          	jalr	1376(ra) # 80000b20 <kalloc>
    800015c8:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800015ca:	6605                	lui	a2,0x1
    800015cc:	4581                	li	a1,0
    800015ce:	fffff097          	auipc	ra,0xfffff
    800015d2:	73e080e7          	jalr	1854(ra) # 80000d0c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800015d6:	4779                	li	a4,30
    800015d8:	86ca                	mv	a3,s2
    800015da:	6605                	lui	a2,0x1
    800015dc:	4581                	li	a1,0
    800015de:	8552                	mv	a0,s4
    800015e0:	00000097          	auipc	ra,0x0
    800015e4:	c20080e7          	jalr	-992(ra) # 80001200 <mappages>
  memmove(mem, src, sz);
    800015e8:	8626                	mv	a2,s1
    800015ea:	85ce                	mv	a1,s3
    800015ec:	854a                	mv	a0,s2
    800015ee:	fffff097          	auipc	ra,0xfffff
    800015f2:	77e080e7          	jalr	1918(ra) # 80000d6c <memmove>
}
    800015f6:	70a2                	ld	ra,40(sp)
    800015f8:	7402                	ld	s0,32(sp)
    800015fa:	64e2                	ld	s1,24(sp)
    800015fc:	6942                	ld	s2,16(sp)
    800015fe:	69a2                	ld	s3,8(sp)
    80001600:	6a02                	ld	s4,0(sp)
    80001602:	6145                	addi	sp,sp,48
    80001604:	8082                	ret
    panic("inituvm: more than a page");
    80001606:	00007517          	auipc	a0,0x7
    8000160a:	b8250513          	addi	a0,a0,-1150 # 80008188 <digits+0x158>
    8000160e:	fffff097          	auipc	ra,0xfffff
    80001612:	f3a080e7          	jalr	-198(ra) # 80000548 <panic>

0000000080001616 <uvmdealloc>:
{
    80001616:	1101                	addi	sp,sp,-32
    80001618:	ec06                	sd	ra,24(sp)
    8000161a:	e822                	sd	s0,16(sp)
    8000161c:	e426                	sd	s1,8(sp)
    8000161e:	1000                	addi	s0,sp,32
    return oldsz;
    80001620:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001622:	00b67d63          	bgeu	a2,a1,8000163c <uvmdealloc+0x26>
    80001626:	84b2                	mv	s1,a2
  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001628:	6785                	lui	a5,0x1
    8000162a:	17fd                	addi	a5,a5,-1
    8000162c:	00f60733          	add	a4,a2,a5
    80001630:	767d                	lui	a2,0xfffff
    80001632:	8f71                	and	a4,a4,a2
    80001634:	97ae                	add	a5,a5,a1
    80001636:	8ff1                	and	a5,a5,a2
    80001638:	00f76863          	bltu	a4,a5,80001648 <uvmdealloc+0x32>
}
    8000163c:	8526                	mv	a0,s1
    8000163e:	60e2                	ld	ra,24(sp)
    80001640:	6442                	ld	s0,16(sp)
    80001642:	64a2                	ld	s1,8(sp)
    80001644:	6105                	addi	sp,sp,32
    80001646:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001648:	8f99                	sub	a5,a5,a4
    8000164a:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000164c:	4685                	li	a3,1
    8000164e:	0007861b          	sext.w	a2,a5
    80001652:	85ba                	mv	a1,a4
    80001654:	00000097          	auipc	ra,0x0
    80001658:	e4c080e7          	jalr	-436(ra) # 800014a0 <uvmunmap>
    8000165c:	b7c5                	j	8000163c <uvmdealloc+0x26>

000000008000165e <uvmalloc>:
{
    8000165e:	7139                	addi	sp,sp,-64
    80001660:	fc06                	sd	ra,56(sp)
    80001662:	f822                	sd	s0,48(sp)
    80001664:	f426                	sd	s1,40(sp)
    80001666:	f04a                	sd	s2,32(sp)
    80001668:	ec4e                	sd	s3,24(sp)
    8000166a:	e852                	sd	s4,16(sp)
    8000166c:	e456                	sd	s5,8(sp)
    8000166e:	e05a                	sd	s6,0(sp)
    80001670:	0080                	addi	s0,sp,64
  if(newsz > PLIC){
    80001672:	0c0007b7          	lui	a5,0xc000
    80001676:	06c7e663          	bltu	a5,a2,800016e2 <uvmalloc+0x84>
    8000167a:	8aaa                	mv	s5,a0
    8000167c:	8b32                	mv	s6,a2
    return oldsz;
    8000167e:	852e                	mv	a0,a1
  if(newsz < oldsz)
    80001680:	06b66a63          	bltu	a2,a1,800016f4 <uvmalloc+0x96>
  oldsz = PGROUNDUP(oldsz);
    80001684:	6985                	lui	s3,0x1
    80001686:	19fd                	addi	s3,s3,-1
    80001688:	95ce                	add	a1,a1,s3
    8000168a:	79fd                	lui	s3,0xfffff
    8000168c:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001690:	0ac9f363          	bgeu	s3,a2,80001736 <uvmalloc+0xd8>
    80001694:	fff60a13          	addi	s4,a2,-1 # ffffffffffffefff <end+0xffffffff7ffd7fdf>
    80001698:	413a0a33          	sub	s4,s4,s3
    8000169c:	77fd                	lui	a5,0xfffff
    8000169e:	00fa7a33          	and	s4,s4,a5
    800016a2:	6785                	lui	a5,0x1
    800016a4:	97ce                	add	a5,a5,s3
    800016a6:	9a3e                	add	s4,s4,a5
    800016a8:	894e                	mv	s2,s3
    mem = kalloc();
    800016aa:	fffff097          	auipc	ra,0xfffff
    800016ae:	476080e7          	jalr	1142(ra) # 80000b20 <kalloc>
    800016b2:	84aa                	mv	s1,a0
    if(mem == 0){
    800016b4:	c931                	beqz	a0,80001708 <uvmalloc+0xaa>
    memset(mem, 0, PGSIZE);
    800016b6:	6605                	lui	a2,0x1
    800016b8:	4581                	li	a1,0
    800016ba:	fffff097          	auipc	ra,0xfffff
    800016be:	652080e7          	jalr	1618(ra) # 80000d0c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800016c2:	4779                	li	a4,30
    800016c4:	86a6                	mv	a3,s1
    800016c6:	6605                	lui	a2,0x1
    800016c8:	85ca                	mv	a1,s2
    800016ca:	8556                	mv	a0,s5
    800016cc:	00000097          	auipc	ra,0x0
    800016d0:	b34080e7          	jalr	-1228(ra) # 80001200 <mappages>
    800016d4:	e139                	bnez	a0,8000171a <uvmalloc+0xbc>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800016d6:	6785                	lui	a5,0x1
    800016d8:	993e                	add	s2,s2,a5
    800016da:	fd4918e3          	bne	s2,s4,800016aa <uvmalloc+0x4c>
  return newsz;
    800016de:	855a                	mv	a0,s6
    800016e0:	a811                	j	800016f4 <uvmalloc+0x96>
      printf("out of PLIC\n");
    800016e2:	00007517          	auipc	a0,0x7
    800016e6:	ac650513          	addi	a0,a0,-1338 # 800081a8 <digits+0x178>
    800016ea:	fffff097          	auipc	ra,0xfffff
    800016ee:	ea8080e7          	jalr	-344(ra) # 80000592 <printf>
      return 0;
    800016f2:	4501                	li	a0,0
}
    800016f4:	70e2                	ld	ra,56(sp)
    800016f6:	7442                	ld	s0,48(sp)
    800016f8:	74a2                	ld	s1,40(sp)
    800016fa:	7902                	ld	s2,32(sp)
    800016fc:	69e2                	ld	s3,24(sp)
    800016fe:	6a42                	ld	s4,16(sp)
    80001700:	6aa2                	ld	s5,8(sp)
    80001702:	6b02                	ld	s6,0(sp)
    80001704:	6121                	addi	sp,sp,64
    80001706:	8082                	ret
      uvmdealloc(pagetable, a, oldsz);
    80001708:	864e                	mv	a2,s3
    8000170a:	85ca                	mv	a1,s2
    8000170c:	8556                	mv	a0,s5
    8000170e:	00000097          	auipc	ra,0x0
    80001712:	f08080e7          	jalr	-248(ra) # 80001616 <uvmdealloc>
      return 0;
    80001716:	4501                	li	a0,0
    80001718:	bff1                	j	800016f4 <uvmalloc+0x96>
      kfree(mem);
    8000171a:	8526                	mv	a0,s1
    8000171c:	fffff097          	auipc	ra,0xfffff
    80001720:	308080e7          	jalr	776(ra) # 80000a24 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001724:	864e                	mv	a2,s3
    80001726:	85ca                	mv	a1,s2
    80001728:	8556                	mv	a0,s5
    8000172a:	00000097          	auipc	ra,0x0
    8000172e:	eec080e7          	jalr	-276(ra) # 80001616 <uvmdealloc>
      return 0;
    80001732:	4501                	li	a0,0
    80001734:	b7c1                	j	800016f4 <uvmalloc+0x96>
  return newsz;
    80001736:	8532                	mv	a0,a2
    80001738:	bf75                	j	800016f4 <uvmalloc+0x96>

000000008000173a <kvmdealloc>:
{
    8000173a:	1101                	addi	sp,sp,-32
    8000173c:	ec06                	sd	ra,24(sp)
    8000173e:	e822                	sd	s0,16(sp)
    80001740:	e426                	sd	s1,8(sp)
    80001742:	1000                	addi	s0,sp,32
    return oldsz;
    80001744:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001746:	00b67d63          	bgeu	a2,a1,80001760 <kvmdealloc+0x26>
    8000174a:	84b2                	mv	s1,a2
  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000174c:	6785                	lui	a5,0x1
    8000174e:	17fd                	addi	a5,a5,-1
    80001750:	00f60733          	add	a4,a2,a5
    80001754:	767d                	lui	a2,0xfffff
    80001756:	8f71                	and	a4,a4,a2
    80001758:	97ae                	add	a5,a5,a1
    8000175a:	8ff1                	and	a5,a5,a2
    8000175c:	00f76863          	bltu	a4,a5,8000176c <kvmdealloc+0x32>
}
    80001760:	8526                	mv	a0,s1
    80001762:	60e2                	ld	ra,24(sp)
    80001764:	6442                	ld	s0,16(sp)
    80001766:	64a2                	ld	s1,8(sp)
    80001768:	6105                	addi	sp,sp,32
    8000176a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000176c:	8f99                	sub	a5,a5,a4
    8000176e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 0);
    80001770:	4681                	li	a3,0
    80001772:	0007861b          	sext.w	a2,a5
    80001776:	85ba                	mv	a1,a4
    80001778:	00000097          	auipc	ra,0x0
    8000177c:	d28080e7          	jalr	-728(ra) # 800014a0 <uvmunmap>
    80001780:	b7c5                	j	80001760 <kvmdealloc+0x26>

0000000080001782 <freewalk>:
{
    80001782:	7179                	addi	sp,sp,-48
    80001784:	f406                	sd	ra,40(sp)
    80001786:	f022                	sd	s0,32(sp)
    80001788:	ec26                	sd	s1,24(sp)
    8000178a:	e84a                	sd	s2,16(sp)
    8000178c:	e44e                	sd	s3,8(sp)
    8000178e:	e052                	sd	s4,0(sp)
    80001790:	1800                	addi	s0,sp,48
    80001792:	8a2a                	mv	s4,a0
  for(int i = 0; i < 512; i++){
    80001794:	84aa                	mv	s1,a0
    80001796:	6905                	lui	s2,0x1
    80001798:	992a                	add	s2,s2,a0
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000179a:	4985                	li	s3,1
    8000179c:	a821                	j	800017b4 <freewalk+0x32>
      uint64 child = PTE2PA(pte);
    8000179e:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800017a0:	0532                	slli	a0,a0,0xc
    800017a2:	00000097          	auipc	ra,0x0
    800017a6:	fe0080e7          	jalr	-32(ra) # 80001782 <freewalk>
      pagetable[i] = 0;
    800017aa:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800017ae:	04a1                	addi	s1,s1,8
    800017b0:	03248d63          	beq	s1,s2,800017ea <freewalk+0x68>
    pte_t pte = pagetable[i];
    800017b4:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800017b6:	00f57793          	andi	a5,a0,15
    800017ba:	ff3782e3          	beq	a5,s3,8000179e <freewalk+0x1c>
    } else if(pte & PTE_V){
    800017be:	00157793          	andi	a5,a0,1
    800017c2:	d7f5                	beqz	a5,800017ae <freewalk+0x2c>
      printf("leaf pa = %p\n",PTE2PA(pte));
    800017c4:	00a55593          	srli	a1,a0,0xa
    800017c8:	05b2                	slli	a1,a1,0xc
    800017ca:	00007517          	auipc	a0,0x7
    800017ce:	9ee50513          	addi	a0,a0,-1554 # 800081b8 <digits+0x188>
    800017d2:	fffff097          	auipc	ra,0xfffff
    800017d6:	dc0080e7          	jalr	-576(ra) # 80000592 <printf>
      panic("freewalk: leaf");
    800017da:	00007517          	auipc	a0,0x7
    800017de:	9ee50513          	addi	a0,a0,-1554 # 800081c8 <digits+0x198>
    800017e2:	fffff097          	auipc	ra,0xfffff
    800017e6:	d66080e7          	jalr	-666(ra) # 80000548 <panic>
  kfree((void*)pagetable);
    800017ea:	8552                	mv	a0,s4
    800017ec:	fffff097          	auipc	ra,0xfffff
    800017f0:	238080e7          	jalr	568(ra) # 80000a24 <kfree>
}
    800017f4:	70a2                	ld	ra,40(sp)
    800017f6:	7402                	ld	s0,32(sp)
    800017f8:	64e2                	ld	s1,24(sp)
    800017fa:	6942                	ld	s2,16(sp)
    800017fc:	69a2                	ld	s3,8(sp)
    800017fe:	6a02                	ld	s4,0(sp)
    80001800:	6145                	addi	sp,sp,48
    80001802:	8082                	ret

0000000080001804 <kfreewalk>:
void kfreewalk(pagetable_t kpagetable){
    80001804:	7179                	addi	sp,sp,-48
    80001806:	f406                	sd	ra,40(sp)
    80001808:	f022                	sd	s0,32(sp)
    8000180a:	ec26                	sd	s1,24(sp)
    8000180c:	e84a                	sd	s2,16(sp)
    8000180e:	e44e                	sd	s3,8(sp)
    80001810:	e052                	sd	s4,0(sp)
    80001812:	1800                	addi	s0,sp,48
    80001814:	8a2a                	mv	s4,a0
    for(int i = 0; i < 512; i++){
    80001816:	84aa                	mv	s1,a0
    80001818:	6985                	lui	s3,0x1
    8000181a:	99aa                	add	s3,s3,a0
    8000181c:	a821                	j	80001834 <kfreewalk+0x30>
                uint64 child = PTE2PA(pte);
    8000181e:	8129                	srli	a0,a0,0xa
                kfreewalk((pagetable_t)child);
    80001820:	0532                	slli	a0,a0,0xc
    80001822:	00000097          	auipc	ra,0x0
    80001826:	fe2080e7          	jalr	-30(ra) # 80001804 <kfreewalk>
            kpagetable[i] = 0;
    8000182a:	00093023          	sd	zero,0(s2) # 1000 <_entry-0x7ffff000>
    for(int i = 0; i < 512; i++){
    8000182e:	04a1                	addi	s1,s1,8
    80001830:	01348b63          	beq	s1,s3,80001846 <kfreewalk+0x42>
        pte_t pte = kpagetable[i];
    80001834:	8926                	mv	s2,s1
    80001836:	6088                	ld	a0,0(s1)
        if((pte & PTE_V)){
    80001838:	00157793          	andi	a5,a0,1
    8000183c:	dbed                	beqz	a5,8000182e <kfreewalk+0x2a>
            if((pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000183e:	00e57793          	andi	a5,a0,14
    80001842:	f7e5                	bnez	a5,8000182a <kfreewalk+0x26>
    80001844:	bfe9                	j	8000181e <kfreewalk+0x1a>
    kfree((void*)kpagetable);
    80001846:	8552                	mv	a0,s4
    80001848:	fffff097          	auipc	ra,0xfffff
    8000184c:	1dc080e7          	jalr	476(ra) # 80000a24 <kfree>
}
    80001850:	70a2                	ld	ra,40(sp)
    80001852:	7402                	ld	s0,32(sp)
    80001854:	64e2                	ld	s1,24(sp)
    80001856:	6942                	ld	s2,16(sp)
    80001858:	69a2                	ld	s3,8(sp)
    8000185a:	6a02                	ld	s4,0(sp)
    8000185c:	6145                	addi	sp,sp,48
    8000185e:	8082                	ret

0000000080001860 <user_kvmfree>:
void user_kvmfree(pagetable_t kpagetable){
    80001860:	1141                	addi	sp,sp,-16
    80001862:	e406                	sd	ra,8(sp)
    80001864:	e022                	sd	s0,0(sp)
    80001866:	0800                	addi	s0,sp,16
    kfreewalk(kpagetable);
    80001868:	00000097          	auipc	ra,0x0
    8000186c:	f9c080e7          	jalr	-100(ra) # 80001804 <kfreewalk>
}
    80001870:	60a2                	ld	ra,8(sp)
    80001872:	6402                	ld	s0,0(sp)
    80001874:	0141                	addi	sp,sp,16
    80001876:	8082                	ret

0000000080001878 <uvmfree>:
{
    80001878:	1101                	addi	sp,sp,-32
    8000187a:	ec06                	sd	ra,24(sp)
    8000187c:	e822                	sd	s0,16(sp)
    8000187e:	e426                	sd	s1,8(sp)
    80001880:	1000                	addi	s0,sp,32
    80001882:	84aa                	mv	s1,a0
    if(sz > 0)
    80001884:	e999                	bnez	a1,8000189a <uvmfree+0x22>
    freewalk(pagetable);
    80001886:	8526                	mv	a0,s1
    80001888:	00000097          	auipc	ra,0x0
    8000188c:	efa080e7          	jalr	-262(ra) # 80001782 <freewalk>
}
    80001890:	60e2                	ld	ra,24(sp)
    80001892:	6442                	ld	s0,16(sp)
    80001894:	64a2                	ld	s1,8(sp)
    80001896:	6105                	addi	sp,sp,32
    80001898:	8082                	ret
        uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000189a:	6605                	lui	a2,0x1
    8000189c:	167d                	addi	a2,a2,-1
    8000189e:	962e                	add	a2,a2,a1
    800018a0:	4685                	li	a3,1
    800018a2:	8231                	srli	a2,a2,0xc
    800018a4:	4581                	li	a1,0
    800018a6:	00000097          	auipc	ra,0x0
    800018aa:	bfa080e7          	jalr	-1030(ra) # 800014a0 <uvmunmap>
    800018ae:	bfe1                	j	80001886 <uvmfree+0xe>

00000000800018b0 <uvmcopy>:
  for(i = 0; i < sz; i += PGSIZE){
    800018b0:	c679                	beqz	a2,8000197e <uvmcopy+0xce>
{
    800018b2:	715d                	addi	sp,sp,-80
    800018b4:	e486                	sd	ra,72(sp)
    800018b6:	e0a2                	sd	s0,64(sp)
    800018b8:	fc26                	sd	s1,56(sp)
    800018ba:	f84a                	sd	s2,48(sp)
    800018bc:	f44e                	sd	s3,40(sp)
    800018be:	f052                	sd	s4,32(sp)
    800018c0:	ec56                	sd	s5,24(sp)
    800018c2:	e85a                	sd	s6,16(sp)
    800018c4:	e45e                	sd	s7,8(sp)
    800018c6:	0880                	addi	s0,sp,80
    800018c8:	8b2a                	mv	s6,a0
    800018ca:	8aae                	mv	s5,a1
    800018cc:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800018ce:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800018d0:	4601                	li	a2,0
    800018d2:	85ce                	mv	a1,s3
    800018d4:	855a                	mv	a0,s6
    800018d6:	fffff097          	auipc	ra,0xfffff
    800018da:	7dc080e7          	jalr	2012(ra) # 800010b2 <walk>
    800018de:	c531                	beqz	a0,8000192a <uvmcopy+0x7a>
    if((*pte & PTE_V) == 0)
    800018e0:	6118                	ld	a4,0(a0)
    800018e2:	00177793          	andi	a5,a4,1
    800018e6:	cbb1                	beqz	a5,8000193a <uvmcopy+0x8a>
    pa = PTE2PA(*pte);
    800018e8:	00a75593          	srli	a1,a4,0xa
    800018ec:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800018f0:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800018f4:	fffff097          	auipc	ra,0xfffff
    800018f8:	22c080e7          	jalr	556(ra) # 80000b20 <kalloc>
    800018fc:	892a                	mv	s2,a0
    800018fe:	c939                	beqz	a0,80001954 <uvmcopy+0xa4>
    memmove(mem, (char*)pa, PGSIZE);
    80001900:	6605                	lui	a2,0x1
    80001902:	85de                	mv	a1,s7
    80001904:	fffff097          	auipc	ra,0xfffff
    80001908:	468080e7          	jalr	1128(ra) # 80000d6c <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000190c:	8726                	mv	a4,s1
    8000190e:	86ca                	mv	a3,s2
    80001910:	6605                	lui	a2,0x1
    80001912:	85ce                	mv	a1,s3
    80001914:	8556                	mv	a0,s5
    80001916:	00000097          	auipc	ra,0x0
    8000191a:	8ea080e7          	jalr	-1814(ra) # 80001200 <mappages>
    8000191e:	e515                	bnez	a0,8000194a <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80001920:	6785                	lui	a5,0x1
    80001922:	99be                	add	s3,s3,a5
    80001924:	fb49e6e3          	bltu	s3,s4,800018d0 <uvmcopy+0x20>
    80001928:	a081                	j	80001968 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    8000192a:	00007517          	auipc	a0,0x7
    8000192e:	8ae50513          	addi	a0,a0,-1874 # 800081d8 <digits+0x1a8>
    80001932:	fffff097          	auipc	ra,0xfffff
    80001936:	c16080e7          	jalr	-1002(ra) # 80000548 <panic>
      panic("uvmcopy: page not present");
    8000193a:	00007517          	auipc	a0,0x7
    8000193e:	8be50513          	addi	a0,a0,-1858 # 800081f8 <digits+0x1c8>
    80001942:	fffff097          	auipc	ra,0xfffff
    80001946:	c06080e7          	jalr	-1018(ra) # 80000548 <panic>
      kfree(mem);
    8000194a:	854a                	mv	a0,s2
    8000194c:	fffff097          	auipc	ra,0xfffff
    80001950:	0d8080e7          	jalr	216(ra) # 80000a24 <kfree>
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001954:	4685                	li	a3,1
    80001956:	00c9d613          	srli	a2,s3,0xc
    8000195a:	4581                	li	a1,0
    8000195c:	8556                	mv	a0,s5
    8000195e:	00000097          	auipc	ra,0x0
    80001962:	b42080e7          	jalr	-1214(ra) # 800014a0 <uvmunmap>
  return -1;
    80001966:	557d                	li	a0,-1
}
    80001968:	60a6                	ld	ra,72(sp)
    8000196a:	6406                	ld	s0,64(sp)
    8000196c:	74e2                	ld	s1,56(sp)
    8000196e:	7942                	ld	s2,48(sp)
    80001970:	79a2                	ld	s3,40(sp)
    80001972:	7a02                	ld	s4,32(sp)
    80001974:	6ae2                	ld	s5,24(sp)
    80001976:	6b42                	ld	s6,16(sp)
    80001978:	6ba2                	ld	s7,8(sp)
    8000197a:	6161                	addi	sp,sp,80
    8000197c:	8082                	ret
  return 0;
    8000197e:	4501                	li	a0,0
}
    80001980:	8082                	ret

0000000080001982 <kvmcopy>:
{
    80001982:	7139                	addi	sp,sp,-64
    80001984:	fc06                	sd	ra,56(sp)
    80001986:	f822                	sd	s0,48(sp)
    80001988:	f426                	sd	s1,40(sp)
    8000198a:	f04a                	sd	s2,32(sp)
    8000198c:	ec4e                	sd	s3,24(sp)
    8000198e:	e852                	sd	s4,16(sp)
    80001990:	e456                	sd	s5,8(sp)
    80001992:	0080                	addi	s0,sp,64
  oldsz = PGROUNDUP(oldsz);
    80001994:	6a85                	lui	s5,0x1
    80001996:	1afd                	addi	s5,s5,-1
    80001998:	9656                	add	a2,a2,s5
    8000199a:	7afd                	lui	s5,0xfffff
    8000199c:	01567ab3          	and	s5,a2,s5
  for(i = oldsz; i < newsz; i += PGSIZE){
    800019a0:	08daff63          	bgeu	s5,a3,80001a3e <kvmcopy+0xbc>
    800019a4:	8a2a                	mv	s4,a0
    800019a6:	89ae                	mv	s3,a1
    800019a8:	8936                	mv	s2,a3
    800019aa:	84d6                	mv	s1,s5
    if((pte = walk(old, i, 0)) == 0)
    800019ac:	4601                	li	a2,0
    800019ae:	85a6                	mv	a1,s1
    800019b0:	8552                	mv	a0,s4
    800019b2:	fffff097          	auipc	ra,0xfffff
    800019b6:	700080e7          	jalr	1792(ra) # 800010b2 <walk>
    800019ba:	c51d                	beqz	a0,800019e8 <kvmcopy+0x66>
    if((*pte & PTE_V) == 0)
    800019bc:	6118                	ld	a4,0(a0)
    800019be:	00177793          	andi	a5,a4,1
    800019c2:	cb9d                	beqz	a5,800019f8 <kvmcopy+0x76>
    pa = PTE2PA(*pte);
    800019c4:	00a75693          	srli	a3,a4,0xa
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
    800019c8:	3ef77713          	andi	a4,a4,1007
    800019cc:	06b2                	slli	a3,a3,0xc
    800019ce:	6605                	lui	a2,0x1
    800019d0:	85a6                	mv	a1,s1
    800019d2:	854e                	mv	a0,s3
    800019d4:	00000097          	auipc	ra,0x0
    800019d8:	82c080e7          	jalr	-2004(ra) # 80001200 <mappages>
    800019dc:	e515                	bnez	a0,80001a08 <kvmcopy+0x86>
  for(i = oldsz; i < newsz; i += PGSIZE){
    800019de:	6785                	lui	a5,0x1
    800019e0:	94be                	add	s1,s1,a5
    800019e2:	fd24e5e3          	bltu	s1,s2,800019ac <kvmcopy+0x2a>
    800019e6:	a099                	j	80001a2c <kvmcopy+0xaa>
      panic("kvmcopy: pte should exist");
    800019e8:	00007517          	auipc	a0,0x7
    800019ec:	83050513          	addi	a0,a0,-2000 # 80008218 <digits+0x1e8>
    800019f0:	fffff097          	auipc	ra,0xfffff
    800019f4:	b58080e7          	jalr	-1192(ra) # 80000548 <panic>
      panic("kvmcopy: page not present");
    800019f8:	00007517          	auipc	a0,0x7
    800019fc:	84050513          	addi	a0,a0,-1984 # 80008238 <digits+0x208>
    80001a00:	fffff097          	auipc	ra,0xfffff
    80001a04:	b48080e7          	jalr	-1208(ra) # 80000548 <panic>
  printf("kvmcopy err\n");
    80001a08:	00007517          	auipc	a0,0x7
    80001a0c:	85050513          	addi	a0,a0,-1968 # 80008258 <digits+0x228>
    80001a10:	fffff097          	auipc	ra,0xfffff
    80001a14:	b82080e7          	jalr	-1150(ra) # 80000592 <printf>
  uvmunmap(new, oldsz, i / PGSIZE, 1);
    80001a18:	4685                	li	a3,1
    80001a1a:	00c4d613          	srli	a2,s1,0xc
    80001a1e:	85d6                	mv	a1,s5
    80001a20:	854e                	mv	a0,s3
    80001a22:	00000097          	auipc	ra,0x0
    80001a26:	a7e080e7          	jalr	-1410(ra) # 800014a0 <uvmunmap>
  return -1;
    80001a2a:	557d                	li	a0,-1
}
    80001a2c:	70e2                	ld	ra,56(sp)
    80001a2e:	7442                	ld	s0,48(sp)
    80001a30:	74a2                	ld	s1,40(sp)
    80001a32:	7902                	ld	s2,32(sp)
    80001a34:	69e2                	ld	s3,24(sp)
    80001a36:	6a42                	ld	s4,16(sp)
    80001a38:	6aa2                	ld	s5,8(sp)
    80001a3a:	6121                	addi	sp,sp,64
    80001a3c:	8082                	ret
  return 0;
    80001a3e:	4501                	li	a0,0
    80001a40:	b7f5                	j	80001a2c <kvmcopy+0xaa>

0000000080001a42 <uvmclear>:
{
    80001a42:	1141                	addi	sp,sp,-16
    80001a44:	e406                	sd	ra,8(sp)
    80001a46:	e022                	sd	s0,0(sp)
    80001a48:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001a4a:	4601                	li	a2,0
    80001a4c:	fffff097          	auipc	ra,0xfffff
    80001a50:	666080e7          	jalr	1638(ra) # 800010b2 <walk>
  if(pte == 0)
    80001a54:	c901                	beqz	a0,80001a64 <uvmclear+0x22>
  *pte &= ~PTE_U;
    80001a56:	611c                	ld	a5,0(a0)
    80001a58:	9bbd                	andi	a5,a5,-17
    80001a5a:	e11c                	sd	a5,0(a0)
}
    80001a5c:	60a2                	ld	ra,8(sp)
    80001a5e:	6402                	ld	s0,0(sp)
    80001a60:	0141                	addi	sp,sp,16
    80001a62:	8082                	ret
    panic("uvmclear");
    80001a64:	00007517          	auipc	a0,0x7
    80001a68:	80450513          	addi	a0,a0,-2044 # 80008268 <digits+0x238>
    80001a6c:	fffff097          	auipc	ra,0xfffff
    80001a70:	adc080e7          	jalr	-1316(ra) # 80000548 <panic>

0000000080001a74 <copyout>:
  while(len > 0){
    80001a74:	c6bd                	beqz	a3,80001ae2 <copyout+0x6e>
{
    80001a76:	715d                	addi	sp,sp,-80
    80001a78:	e486                	sd	ra,72(sp)
    80001a7a:	e0a2                	sd	s0,64(sp)
    80001a7c:	fc26                	sd	s1,56(sp)
    80001a7e:	f84a                	sd	s2,48(sp)
    80001a80:	f44e                	sd	s3,40(sp)
    80001a82:	f052                	sd	s4,32(sp)
    80001a84:	ec56                	sd	s5,24(sp)
    80001a86:	e85a                	sd	s6,16(sp)
    80001a88:	e45e                	sd	s7,8(sp)
    80001a8a:	e062                	sd	s8,0(sp)
    80001a8c:	0880                	addi	s0,sp,80
    80001a8e:	8b2a                	mv	s6,a0
    80001a90:	8c2e                	mv	s8,a1
    80001a92:	8a32                	mv	s4,a2
    80001a94:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001a96:	7bfd                	lui	s7,0xfffff
    n = PGSIZE - (dstva - va0);
    80001a98:	6a85                	lui	s5,0x1
    80001a9a:	a015                	j	80001abe <copyout+0x4a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001a9c:	9562                	add	a0,a0,s8
    80001a9e:	0004861b          	sext.w	a2,s1
    80001aa2:	85d2                	mv	a1,s4
    80001aa4:	41250533          	sub	a0,a0,s2
    80001aa8:	fffff097          	auipc	ra,0xfffff
    80001aac:	2c4080e7          	jalr	708(ra) # 80000d6c <memmove>
    len -= n;
    80001ab0:	409989b3          	sub	s3,s3,s1
    src += n;
    80001ab4:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001ab6:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001aba:	02098263          	beqz	s3,80001ade <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001abe:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001ac2:	85ca                	mv	a1,s2
    80001ac4:	855a                	mv	a0,s6
    80001ac6:	fffff097          	auipc	ra,0xfffff
    80001aca:	692080e7          	jalr	1682(ra) # 80001158 <walkaddr>
    if(pa0 == 0)
    80001ace:	cd01                	beqz	a0,80001ae6 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001ad0:	418904b3          	sub	s1,s2,s8
    80001ad4:	94d6                	add	s1,s1,s5
    if(n > len)
    80001ad6:	fc99f3e3          	bgeu	s3,s1,80001a9c <copyout+0x28>
    80001ada:	84ce                	mv	s1,s3
    80001adc:	b7c1                	j	80001a9c <copyout+0x28>
  return 0;
    80001ade:	4501                	li	a0,0
    80001ae0:	a021                	j	80001ae8 <copyout+0x74>
    80001ae2:	4501                	li	a0,0
}
    80001ae4:	8082                	ret
      return -1;
    80001ae6:	557d                	li	a0,-1
}
    80001ae8:	60a6                	ld	ra,72(sp)
    80001aea:	6406                	ld	s0,64(sp)
    80001aec:	74e2                	ld	s1,56(sp)
    80001aee:	7942                	ld	s2,48(sp)
    80001af0:	79a2                	ld	s3,40(sp)
    80001af2:	7a02                	ld	s4,32(sp)
    80001af4:	6ae2                	ld	s5,24(sp)
    80001af6:	6b42                	ld	s6,16(sp)
    80001af8:	6ba2                	ld	s7,8(sp)
    80001afa:	6c02                	ld	s8,0(sp)
    80001afc:	6161                	addi	sp,sp,80
    80001afe:	8082                	ret

0000000080001b00 <kcopyout>:
  while(len > 0){
    80001b00:	cabd                	beqz	a3,80001b76 <kcopyout+0x76>
{
    80001b02:	715d                	addi	sp,sp,-80
    80001b04:	e486                	sd	ra,72(sp)
    80001b06:	e0a2                	sd	s0,64(sp)
    80001b08:	fc26                	sd	s1,56(sp)
    80001b0a:	f84a                	sd	s2,48(sp)
    80001b0c:	f44e                	sd	s3,40(sp)
    80001b0e:	f052                	sd	s4,32(sp)
    80001b10:	ec56                	sd	s5,24(sp)
    80001b12:	e85a                	sd	s6,16(sp)
    80001b14:	e45e                	sd	s7,8(sp)
    80001b16:	e062                	sd	s8,0(sp)
    80001b18:	0880                	addi	s0,sp,80
    80001b1a:	8baa                	mv	s7,a0
    80001b1c:	892e                	mv	s2,a1
    80001b1e:	8ab2                	mv	s5,a2
    80001b20:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80001b22:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (dstva - va0);
    80001b24:	6b05                	lui	s6,0x1
    80001b26:	a015                	j	80001b4a <kcopyout+0x4a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001b28:	41390533          	sub	a0,s2,s3
    80001b2c:	0004861b          	sext.w	a2,s1
    80001b30:	85d6                	mv	a1,s5
    80001b32:	953e                	add	a0,a0,a5
    80001b34:	fffff097          	auipc	ra,0xfffff
    80001b38:	238080e7          	jalr	568(ra) # 80000d6c <memmove>
    len -= n;
    80001b3c:	409a0a33          	sub	s4,s4,s1
    src += n;
    80001b40:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80001b42:	01698933          	add	s2,s3,s6
  while(len > 0){
    80001b46:	020a0663          	beqz	s4,80001b72 <kcopyout+0x72>
    va0 = PGROUNDDOWN(dstva);
    80001b4a:	018979b3          	and	s3,s2,s8
    pa0 = PTE2PA(*walk(pagetable, va0, 0));
    80001b4e:	4601                	li	a2,0
    80001b50:	85ce                	mv	a1,s3
    80001b52:	855e                	mv	a0,s7
    80001b54:	fffff097          	auipc	ra,0xfffff
    80001b58:	55e080e7          	jalr	1374(ra) # 800010b2 <walk>
    80001b5c:	611c                	ld	a5,0(a0)
    80001b5e:	83a9                	srli	a5,a5,0xa
    80001b60:	07b2                	slli	a5,a5,0xc
    if(pa0 == 0)
    80001b62:	cf81                	beqz	a5,80001b7a <kcopyout+0x7a>
    n = PGSIZE - (dstva - va0);
    80001b64:	412984b3          	sub	s1,s3,s2
    80001b68:	94da                	add	s1,s1,s6
    if(n > len)
    80001b6a:	fa9a7fe3          	bgeu	s4,s1,80001b28 <kcopyout+0x28>
    80001b6e:	84d2                	mv	s1,s4
    80001b70:	bf65                	j	80001b28 <kcopyout+0x28>
  return 0;
    80001b72:	4501                	li	a0,0
    80001b74:	a021                	j	80001b7c <kcopyout+0x7c>
    80001b76:	4501                	li	a0,0
}
    80001b78:	8082                	ret
      return -1;
    80001b7a:	557d                	li	a0,-1
}
    80001b7c:	60a6                	ld	ra,72(sp)
    80001b7e:	6406                	ld	s0,64(sp)
    80001b80:	74e2                	ld	s1,56(sp)
    80001b82:	7942                	ld	s2,48(sp)
    80001b84:	79a2                	ld	s3,40(sp)
    80001b86:	7a02                	ld	s4,32(sp)
    80001b88:	6ae2                	ld	s5,24(sp)
    80001b8a:	6b42                	ld	s6,16(sp)
    80001b8c:	6ba2                	ld	s7,8(sp)
    80001b8e:	6c02                	ld	s8,0(sp)
    80001b90:	6161                	addi	sp,sp,80
    80001b92:	8082                	ret

0000000080001b94 <copyin>:
{
    80001b94:	1141                	addi	sp,sp,-16
    80001b96:	e406                	sd	ra,8(sp)
    80001b98:	e022                	sd	s0,0(sp)
    80001b9a:	0800                	addi	s0,sp,16
  return copyin_new(pagetable,dst,srcva,len);
    80001b9c:	00005097          	auipc	ra,0x5
    80001ba0:	aa4080e7          	jalr	-1372(ra) # 80006640 <copyin_new>
}
    80001ba4:	60a2                	ld	ra,8(sp)
    80001ba6:	6402                	ld	s0,0(sp)
    80001ba8:	0141                	addi	sp,sp,16
    80001baa:	8082                	ret

0000000080001bac <copyinstr>:
{
    80001bac:	1141                	addi	sp,sp,-16
    80001bae:	e406                	sd	ra,8(sp)
    80001bb0:	e022                	sd	s0,0(sp)
    80001bb2:	0800                	addi	s0,sp,16
   return copyinstr_new(pagetable,dst,srcva,max);
    80001bb4:	00005097          	auipc	ra,0x5
    80001bb8:	af4080e7          	jalr	-1292(ra) # 800066a8 <copyinstr_new>
}
    80001bbc:	60a2                	ld	ra,8(sp)
    80001bbe:	6402                	ld	s0,0(sp)
    80001bc0:	0141                	addi	sp,sp,16
    80001bc2:	8082                	ret

0000000080001bc4 <vmprint>:
void vmprint(pagetable_t pagetable){
    80001bc4:	1101                	addi	sp,sp,-32
    80001bc6:	ec06                	sd	ra,24(sp)
    80001bc8:	e822                	sd	s0,16(sp)
    80001bca:	e426                	sd	s1,8(sp)
    80001bcc:	1000                	addi	s0,sp,32
    80001bce:	84aa                	mv	s1,a0
    printf("page table %p\n",pagetable);
    80001bd0:	85aa                	mv	a1,a0
    80001bd2:	00006517          	auipc	a0,0x6
    80001bd6:	6a650513          	addi	a0,a0,1702 # 80008278 <digits+0x248>
    80001bda:	fffff097          	auipc	ra,0xfffff
    80001bde:	9b8080e7          	jalr	-1608(ra) # 80000592 <printf>
    vmprint_helper(pagetable,1);
    80001be2:	4585                	li	a1,1
    80001be4:	8526                	mv	a0,s1
    80001be6:	fffff097          	auipc	ra,0xfffff
    80001bea:	3f6080e7          	jalr	1014(ra) # 80000fdc <vmprint_helper>
    return;
}
    80001bee:	60e2                	ld	ra,24(sp)
    80001bf0:	6442                	ld	s0,16(sp)
    80001bf2:	64a2                	ld	s1,8(sp)
    80001bf4:	6105                	addi	sp,sp,32
    80001bf6:	8082                	ret

0000000080001bf8 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    80001bf8:	1101                	addi	sp,sp,-32
    80001bfa:	ec06                	sd	ra,24(sp)
    80001bfc:	e822                	sd	s0,16(sp)
    80001bfe:	e426                	sd	s1,8(sp)
    80001c00:	1000                	addi	s0,sp,32
    80001c02:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001c04:	fffff097          	auipc	ra,0xfffff
    80001c08:	f92080e7          	jalr	-110(ra) # 80000b96 <holding>
    80001c0c:	c909                	beqz	a0,80001c1e <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80001c0e:	749c                	ld	a5,40(s1)
    80001c10:	00978f63          	beq	a5,s1,80001c2e <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001c14:	60e2                	ld	ra,24(sp)
    80001c16:	6442                	ld	s0,16(sp)
    80001c18:	64a2                	ld	s1,8(sp)
    80001c1a:	6105                	addi	sp,sp,32
    80001c1c:	8082                	ret
    panic("wakeup1");
    80001c1e:	00006517          	auipc	a0,0x6
    80001c22:	66a50513          	addi	a0,a0,1642 # 80008288 <digits+0x258>
    80001c26:	fffff097          	auipc	ra,0xfffff
    80001c2a:	922080e7          	jalr	-1758(ra) # 80000548 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001c2e:	4c98                	lw	a4,24(s1)
    80001c30:	4785                	li	a5,1
    80001c32:	fef711e3          	bne	a4,a5,80001c14 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001c36:	4789                	li	a5,2
    80001c38:	cc9c                	sw	a5,24(s1)
}
    80001c3a:	bfe9                	j	80001c14 <wakeup1+0x1c>

0000000080001c3c <procinit>:
{
    80001c3c:	7179                	addi	sp,sp,-48
    80001c3e:	f406                	sd	ra,40(sp)
    80001c40:	f022                	sd	s0,32(sp)
    80001c42:	ec26                	sd	s1,24(sp)
    80001c44:	e84a                	sd	s2,16(sp)
    80001c46:	e44e                	sd	s3,8(sp)
    80001c48:	1800                	addi	s0,sp,48
  initlock(&pid_lock, "nextpid");
    80001c4a:	00006597          	auipc	a1,0x6
    80001c4e:	64658593          	addi	a1,a1,1606 # 80008290 <digits+0x260>
    80001c52:	00010517          	auipc	a0,0x10
    80001c56:	cfe50513          	addi	a0,a0,-770 # 80011950 <pid_lock>
    80001c5a:	fffff097          	auipc	ra,0xfffff
    80001c5e:	f26080e7          	jalr	-218(ra) # 80000b80 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c62:	00010497          	auipc	s1,0x10
    80001c66:	10648493          	addi	s1,s1,262 # 80011d68 <proc>
      initlock(&p->lock, "proc");
    80001c6a:	00006997          	auipc	s3,0x6
    80001c6e:	62e98993          	addi	s3,s3,1582 # 80008298 <digits+0x268>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c72:	00016917          	auipc	s2,0x16
    80001c76:	cf690913          	addi	s2,s2,-778 # 80017968 <tickslock>
      initlock(&p->lock, "proc");
    80001c7a:	85ce                	mv	a1,s3
    80001c7c:	8526                	mv	a0,s1
    80001c7e:	fffff097          	auipc	ra,0xfffff
    80001c82:	f02080e7          	jalr	-254(ra) # 80000b80 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c86:	17048493          	addi	s1,s1,368
    80001c8a:	ff2498e3          	bne	s1,s2,80001c7a <procinit+0x3e>
  kvminithart();
    80001c8e:	fffff097          	auipc	ra,0xfffff
    80001c92:	400080e7          	jalr	1024(ra) # 8000108e <kvminithart>
}
    80001c96:	70a2                	ld	ra,40(sp)
    80001c98:	7402                	ld	s0,32(sp)
    80001c9a:	64e2                	ld	s1,24(sp)
    80001c9c:	6942                	ld	s2,16(sp)
    80001c9e:	69a2                	ld	s3,8(sp)
    80001ca0:	6145                	addi	sp,sp,48
    80001ca2:	8082                	ret

0000000080001ca4 <cpuid>:
{
    80001ca4:	1141                	addi	sp,sp,-16
    80001ca6:	e422                	sd	s0,8(sp)
    80001ca8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001caa:	8512                	mv	a0,tp
}
    80001cac:	2501                	sext.w	a0,a0
    80001cae:	6422                	ld	s0,8(sp)
    80001cb0:	0141                	addi	sp,sp,16
    80001cb2:	8082                	ret

0000000080001cb4 <mycpu>:
mycpu(void) {
    80001cb4:	1141                	addi	sp,sp,-16
    80001cb6:	e422                	sd	s0,8(sp)
    80001cb8:	0800                	addi	s0,sp,16
    80001cba:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001cbc:	2781                	sext.w	a5,a5
    80001cbe:	079e                	slli	a5,a5,0x7
}
    80001cc0:	00010517          	auipc	a0,0x10
    80001cc4:	ca850513          	addi	a0,a0,-856 # 80011968 <cpus>
    80001cc8:	953e                	add	a0,a0,a5
    80001cca:	6422                	ld	s0,8(sp)
    80001ccc:	0141                	addi	sp,sp,16
    80001cce:	8082                	ret

0000000080001cd0 <myproc>:
myproc(void) {
    80001cd0:	1101                	addi	sp,sp,-32
    80001cd2:	ec06                	sd	ra,24(sp)
    80001cd4:	e822                	sd	s0,16(sp)
    80001cd6:	e426                	sd	s1,8(sp)
    80001cd8:	1000                	addi	s0,sp,32
  push_off();
    80001cda:	fffff097          	auipc	ra,0xfffff
    80001cde:	eea080e7          	jalr	-278(ra) # 80000bc4 <push_off>
    80001ce2:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001ce4:	2781                	sext.w	a5,a5
    80001ce6:	079e                	slli	a5,a5,0x7
    80001ce8:	00010717          	auipc	a4,0x10
    80001cec:	c6870713          	addi	a4,a4,-920 # 80011950 <pid_lock>
    80001cf0:	97ba                	add	a5,a5,a4
    80001cf2:	6f84                	ld	s1,24(a5)
  pop_off();
    80001cf4:	fffff097          	auipc	ra,0xfffff
    80001cf8:	f70080e7          	jalr	-144(ra) # 80000c64 <pop_off>
}
    80001cfc:	8526                	mv	a0,s1
    80001cfe:	60e2                	ld	ra,24(sp)
    80001d00:	6442                	ld	s0,16(sp)
    80001d02:	64a2                	ld	s1,8(sp)
    80001d04:	6105                	addi	sp,sp,32
    80001d06:	8082                	ret

0000000080001d08 <forkret>:
{
    80001d08:	1141                	addi	sp,sp,-16
    80001d0a:	e406                	sd	ra,8(sp)
    80001d0c:	e022                	sd	s0,0(sp)
    80001d0e:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001d10:	00000097          	auipc	ra,0x0
    80001d14:	fc0080e7          	jalr	-64(ra) # 80001cd0 <myproc>
    80001d18:	fffff097          	auipc	ra,0xfffff
    80001d1c:	fac080e7          	jalr	-84(ra) # 80000cc4 <release>
  if (first) {
    80001d20:	00007797          	auipc	a5,0x7
    80001d24:	bf07a783          	lw	a5,-1040(a5) # 80008910 <first.1711>
    80001d28:	eb89                	bnez	a5,80001d3a <forkret+0x32>
  usertrapret();
    80001d2a:	00001097          	auipc	ra,0x1
    80001d2e:	d50080e7          	jalr	-688(ra) # 80002a7a <usertrapret>
}
    80001d32:	60a2                	ld	ra,8(sp)
    80001d34:	6402                	ld	s0,0(sp)
    80001d36:	0141                	addi	sp,sp,16
    80001d38:	8082                	ret
    first = 0;
    80001d3a:	00007797          	auipc	a5,0x7
    80001d3e:	bc07ab23          	sw	zero,-1066(a5) # 80008910 <first.1711>
    fsinit(ROOTDEV);
    80001d42:	4505                	li	a0,1
    80001d44:	00002097          	auipc	ra,0x2
    80001d48:	a78080e7          	jalr	-1416(ra) # 800037bc <fsinit>
    80001d4c:	bff9                	j	80001d2a <forkret+0x22>

0000000080001d4e <allocpid>:
allocpid() {
    80001d4e:	1101                	addi	sp,sp,-32
    80001d50:	ec06                	sd	ra,24(sp)
    80001d52:	e822                	sd	s0,16(sp)
    80001d54:	e426                	sd	s1,8(sp)
    80001d56:	e04a                	sd	s2,0(sp)
    80001d58:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001d5a:	00010917          	auipc	s2,0x10
    80001d5e:	bf690913          	addi	s2,s2,-1034 # 80011950 <pid_lock>
    80001d62:	854a                	mv	a0,s2
    80001d64:	fffff097          	auipc	ra,0xfffff
    80001d68:	eac080e7          	jalr	-340(ra) # 80000c10 <acquire>
  pid = nextpid;
    80001d6c:	00007797          	auipc	a5,0x7
    80001d70:	ba878793          	addi	a5,a5,-1112 # 80008914 <nextpid>
    80001d74:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001d76:	0014871b          	addiw	a4,s1,1
    80001d7a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001d7c:	854a                	mv	a0,s2
    80001d7e:	fffff097          	auipc	ra,0xfffff
    80001d82:	f46080e7          	jalr	-186(ra) # 80000cc4 <release>
}
    80001d86:	8526                	mv	a0,s1
    80001d88:	60e2                	ld	ra,24(sp)
    80001d8a:	6442                	ld	s0,16(sp)
    80001d8c:	64a2                	ld	s1,8(sp)
    80001d8e:	6902                	ld	s2,0(sp)
    80001d90:	6105                	addi	sp,sp,32
    80001d92:	8082                	ret

0000000080001d94 <proc_pagetable>:
{
    80001d94:	1101                	addi	sp,sp,-32
    80001d96:	ec06                	sd	ra,24(sp)
    80001d98:	e822                	sd	s0,16(sp)
    80001d9a:	e426                	sd	s1,8(sp)
    80001d9c:	e04a                	sd	s2,0(sp)
    80001d9e:	1000                	addi	s0,sp,32
    80001da0:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001da2:	fffff097          	auipc	ra,0xfffff
    80001da6:	7d4080e7          	jalr	2004(ra) # 80001576 <uvmcreate>
    80001daa:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001dac:	c121                	beqz	a0,80001dec <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001dae:	4729                	li	a4,10
    80001db0:	00005697          	auipc	a3,0x5
    80001db4:	25068693          	addi	a3,a3,592 # 80007000 <_trampoline>
    80001db8:	6605                	lui	a2,0x1
    80001dba:	040005b7          	lui	a1,0x4000
    80001dbe:	15fd                	addi	a1,a1,-1
    80001dc0:	05b2                	slli	a1,a1,0xc
    80001dc2:	fffff097          	auipc	ra,0xfffff
    80001dc6:	43e080e7          	jalr	1086(ra) # 80001200 <mappages>
    80001dca:	02054863          	bltz	a0,80001dfa <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001dce:	4719                	li	a4,6
    80001dd0:	06093683          	ld	a3,96(s2)
    80001dd4:	6605                	lui	a2,0x1
    80001dd6:	020005b7          	lui	a1,0x2000
    80001dda:	15fd                	addi	a1,a1,-1
    80001ddc:	05b6                	slli	a1,a1,0xd
    80001dde:	8526                	mv	a0,s1
    80001de0:	fffff097          	auipc	ra,0xfffff
    80001de4:	420080e7          	jalr	1056(ra) # 80001200 <mappages>
    80001de8:	02054163          	bltz	a0,80001e0a <proc_pagetable+0x76>
}
    80001dec:	8526                	mv	a0,s1
    80001dee:	60e2                	ld	ra,24(sp)
    80001df0:	6442                	ld	s0,16(sp)
    80001df2:	64a2                	ld	s1,8(sp)
    80001df4:	6902                	ld	s2,0(sp)
    80001df6:	6105                	addi	sp,sp,32
    80001df8:	8082                	ret
    uvmfree(pagetable, 0);
    80001dfa:	4581                	li	a1,0
    80001dfc:	8526                	mv	a0,s1
    80001dfe:	00000097          	auipc	ra,0x0
    80001e02:	a7a080e7          	jalr	-1414(ra) # 80001878 <uvmfree>
    return 0;
    80001e06:	4481                	li	s1,0
    80001e08:	b7d5                	j	80001dec <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e0a:	4681                	li	a3,0
    80001e0c:	4605                	li	a2,1
    80001e0e:	040005b7          	lui	a1,0x4000
    80001e12:	15fd                	addi	a1,a1,-1
    80001e14:	05b2                	slli	a1,a1,0xc
    80001e16:	8526                	mv	a0,s1
    80001e18:	fffff097          	auipc	ra,0xfffff
    80001e1c:	688080e7          	jalr	1672(ra) # 800014a0 <uvmunmap>
    uvmfree(pagetable, 0);
    80001e20:	4581                	li	a1,0
    80001e22:	8526                	mv	a0,s1
    80001e24:	00000097          	auipc	ra,0x0
    80001e28:	a54080e7          	jalr	-1452(ra) # 80001878 <uvmfree>
    return 0;
    80001e2c:	4481                	li	s1,0
    80001e2e:	bf7d                	j	80001dec <proc_pagetable+0x58>

0000000080001e30 <proc_freepagetable>:
{
    80001e30:	1101                	addi	sp,sp,-32
    80001e32:	ec06                	sd	ra,24(sp)
    80001e34:	e822                	sd	s0,16(sp)
    80001e36:	e426                	sd	s1,8(sp)
    80001e38:	e04a                	sd	s2,0(sp)
    80001e3a:	1000                	addi	s0,sp,32
    80001e3c:	84aa                	mv	s1,a0
    80001e3e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e40:	4681                	li	a3,0
    80001e42:	4605                	li	a2,1
    80001e44:	040005b7          	lui	a1,0x4000
    80001e48:	15fd                	addi	a1,a1,-1
    80001e4a:	05b2                	slli	a1,a1,0xc
    80001e4c:	fffff097          	auipc	ra,0xfffff
    80001e50:	654080e7          	jalr	1620(ra) # 800014a0 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001e54:	4681                	li	a3,0
    80001e56:	4605                	li	a2,1
    80001e58:	020005b7          	lui	a1,0x2000
    80001e5c:	15fd                	addi	a1,a1,-1
    80001e5e:	05b6                	slli	a1,a1,0xd
    80001e60:	8526                	mv	a0,s1
    80001e62:	fffff097          	auipc	ra,0xfffff
    80001e66:	63e080e7          	jalr	1598(ra) # 800014a0 <uvmunmap>
  uvmfree(pagetable, sz);
    80001e6a:	85ca                	mv	a1,s2
    80001e6c:	8526                	mv	a0,s1
    80001e6e:	00000097          	auipc	ra,0x0
    80001e72:	a0a080e7          	jalr	-1526(ra) # 80001878 <uvmfree>
}
    80001e76:	60e2                	ld	ra,24(sp)
    80001e78:	6442                	ld	s0,16(sp)
    80001e7a:	64a2                	ld	s1,8(sp)
    80001e7c:	6902                	ld	s2,0(sp)
    80001e7e:	6105                	addi	sp,sp,32
    80001e80:	8082                	ret

0000000080001e82 <freeproc>:
{
    80001e82:	1101                	addi	sp,sp,-32
    80001e84:	ec06                	sd	ra,24(sp)
    80001e86:	e822                	sd	s0,16(sp)
    80001e88:	e426                	sd	s1,8(sp)
    80001e8a:	1000                	addi	s0,sp,32
    80001e8c:	84aa                	mv	s1,a0
    if(p->trapframe)
    80001e8e:	7128                	ld	a0,96(a0)
    80001e90:	c509                	beqz	a0,80001e9a <freeproc+0x18>
        kfree((void*)p->trapframe);
    80001e92:	fffff097          	auipc	ra,0xfffff
    80001e96:	b92080e7          	jalr	-1134(ra) # 80000a24 <kfree>
    p->trapframe = 0;
    80001e9a:	0604b023          	sd	zero,96(s1)
    if(p->kstack){
    80001e9e:	60bc                	ld	a5,64(s1)
    80001ea0:	e7b9                	bnez	a5,80001eee <freeproc+0x6c>
    if(p->kpagetable)
    80001ea2:	6ca8                	ld	a0,88(s1)
    80001ea4:	c509                	beqz	a0,80001eae <freeproc+0x2c>
        user_kvmfree(p->kpagetable);
    80001ea6:	00000097          	auipc	ra,0x0
    80001eaa:	9ba080e7          	jalr	-1606(ra) # 80001860 <user_kvmfree>
    if(p->pagetable)
    80001eae:	68a8                	ld	a0,80(s1)
    80001eb0:	c511                	beqz	a0,80001ebc <freeproc+0x3a>
        proc_freepagetable(p->pagetable, p->sz);
    80001eb2:	64ac                	ld	a1,72(s1)
    80001eb4:	00000097          	auipc	ra,0x0
    80001eb8:	f7c080e7          	jalr	-132(ra) # 80001e30 <proc_freepagetable>
    p->pagetable = 0;
    80001ebc:	0404b823          	sd	zero,80(s1)
    p->kpagetable = 0;
    80001ec0:	0404bc23          	sd	zero,88(s1)
    p->sz = 0;
    80001ec4:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001ec8:	0204ac23          	sw	zero,56(s1)
    p->parent = 0;
    80001ecc:	0204b023          	sd	zero,32(s1)
    p->name[0] = 0;
    80001ed0:	16048023          	sb	zero,352(s1)
    p->chan = 0;
    80001ed4:	0204b423          	sd	zero,40(s1)
    p->killed = 0;
    80001ed8:	0204a823          	sw	zero,48(s1)
    p->xstate = 0;
    80001edc:	0204aa23          	sw	zero,52(s1)
    p->state = UNUSED;
    80001ee0:	0004ac23          	sw	zero,24(s1)
}
    80001ee4:	60e2                	ld	ra,24(sp)
    80001ee6:	6442                	ld	s0,16(sp)
    80001ee8:	64a2                	ld	s1,8(sp)
    80001eea:	6105                	addi	sp,sp,32
    80001eec:	8082                	ret
        kfree((void*)PTE2PA(*walk(p->kpagetable,KSTACK(0),0)));
    80001eee:	4601                	li	a2,0
    80001ef0:	040005b7          	lui	a1,0x4000
    80001ef4:	15f5                	addi	a1,a1,-3
    80001ef6:	05b2                	slli	a1,a1,0xc
    80001ef8:	6ca8                	ld	a0,88(s1)
    80001efa:	fffff097          	auipc	ra,0xfffff
    80001efe:	1b8080e7          	jalr	440(ra) # 800010b2 <walk>
    80001f02:	6108                	ld	a0,0(a0)
    80001f04:	8129                	srli	a0,a0,0xa
    80001f06:	0532                	slli	a0,a0,0xc
    80001f08:	fffff097          	auipc	ra,0xfffff
    80001f0c:	b1c080e7          	jalr	-1252(ra) # 80000a24 <kfree>
        p->kstack = 0;
    80001f10:	0404b023          	sd	zero,64(s1)
    80001f14:	b779                	j	80001ea2 <freeproc+0x20>

0000000080001f16 <allocproc>:
{
    80001f16:	1101                	addi	sp,sp,-32
    80001f18:	ec06                	sd	ra,24(sp)
    80001f1a:	e822                	sd	s0,16(sp)
    80001f1c:	e426                	sd	s1,8(sp)
    80001f1e:	e04a                	sd	s2,0(sp)
    80001f20:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f22:	00010497          	auipc	s1,0x10
    80001f26:	e4648493          	addi	s1,s1,-442 # 80011d68 <proc>
    80001f2a:	00016917          	auipc	s2,0x16
    80001f2e:	a3e90913          	addi	s2,s2,-1474 # 80017968 <tickslock>
    acquire(&p->lock);
    80001f32:	8526                	mv	a0,s1
    80001f34:	fffff097          	auipc	ra,0xfffff
    80001f38:	cdc080e7          	jalr	-804(ra) # 80000c10 <acquire>
    if(p->state == UNUSED) {
    80001f3c:	4c9c                	lw	a5,24(s1)
    80001f3e:	cf81                	beqz	a5,80001f56 <allocproc+0x40>
      release(&p->lock);
    80001f40:	8526                	mv	a0,s1
    80001f42:	fffff097          	auipc	ra,0xfffff
    80001f46:	d82080e7          	jalr	-638(ra) # 80000cc4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f4a:	17048493          	addi	s1,s1,368
    80001f4e:	ff2492e3          	bne	s1,s2,80001f32 <allocproc+0x1c>
  return 0;
    80001f52:	4481                	li	s1,0
    80001f54:	a049                	j	80001fd6 <allocproc+0xc0>
  p->pid = allocpid();
    80001f56:	00000097          	auipc	ra,0x0
    80001f5a:	df8080e7          	jalr	-520(ra) # 80001d4e <allocpid>
    80001f5e:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001f60:	fffff097          	auipc	ra,0xfffff
    80001f64:	bc0080e7          	jalr	-1088(ra) # 80000b20 <kalloc>
    80001f68:	892a                	mv	s2,a0
    80001f6a:	f0a8                	sd	a0,96(s1)
    80001f6c:	cd25                	beqz	a0,80001fe4 <allocproc+0xce>
  p->pagetable = proc_pagetable(p);
    80001f6e:	8526                	mv	a0,s1
    80001f70:	00000097          	auipc	ra,0x0
    80001f74:	e24080e7          	jalr	-476(ra) # 80001d94 <proc_pagetable>
    80001f78:	892a                	mv	s2,a0
    80001f7a:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001f7c:	c93d                	beqz	a0,80001ff2 <allocproc+0xdc>
  p->kpagetable = user_kvmcreate();
    80001f7e:	fffff097          	auipc	ra,0xfffff
    80001f82:	360080e7          	jalr	864(ra) # 800012de <user_kvmcreate>
    80001f86:	eca8                	sd	a0,88(s1)
  char *pa = kalloc();
    80001f88:	fffff097          	auipc	ra,0xfffff
    80001f8c:	b98080e7          	jalr	-1128(ra) # 80000b20 <kalloc>
    80001f90:	86aa                	mv	a3,a0
  if(pa == 0)
    80001f92:	cd25                	beqz	a0,8000200a <allocproc+0xf4>
  user_kvmmap(p->kpagetable,va,PGSIZE,(uint64)pa,PTE_R | PTE_W);
    80001f94:	4719                	li	a4,6
    80001f96:	6605                	lui	a2,0x1
    80001f98:	04000937          	lui	s2,0x4000
    80001f9c:	1975                	addi	s2,s2,-3
    80001f9e:	00c91593          	slli	a1,s2,0xc
    80001fa2:	6ca8                	ld	a0,88(s1)
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	310080e7          	jalr	784(ra) # 800012b4 <user_kvmmap>
  p->kstack = KSTACK(0);
    80001fac:	0932                	slli	s2,s2,0xc
    80001fae:	0524b023          	sd	s2,64(s1)
  memset(&p->context, 0, sizeof(p->context));
    80001fb2:	07000613          	li	a2,112
    80001fb6:	4581                	li	a1,0
    80001fb8:	06848513          	addi	a0,s1,104
    80001fbc:	fffff097          	auipc	ra,0xfffff
    80001fc0:	d50080e7          	jalr	-688(ra) # 80000d0c <memset>
  p->context.ra = (uint64)forkret;
    80001fc4:	00000797          	auipc	a5,0x0
    80001fc8:	d4478793          	addi	a5,a5,-700 # 80001d08 <forkret>
    80001fcc:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001fce:	60bc                	ld	a5,64(s1)
    80001fd0:	6705                	lui	a4,0x1
    80001fd2:	97ba                	add	a5,a5,a4
    80001fd4:	f8bc                	sd	a5,112(s1)
}
    80001fd6:	8526                	mv	a0,s1
    80001fd8:	60e2                	ld	ra,24(sp)
    80001fda:	6442                	ld	s0,16(sp)
    80001fdc:	64a2                	ld	s1,8(sp)
    80001fde:	6902                	ld	s2,0(sp)
    80001fe0:	6105                	addi	sp,sp,32
    80001fe2:	8082                	ret
    release(&p->lock);
    80001fe4:	8526                	mv	a0,s1
    80001fe6:	fffff097          	auipc	ra,0xfffff
    80001fea:	cde080e7          	jalr	-802(ra) # 80000cc4 <release>
    return 0;
    80001fee:	84ca                	mv	s1,s2
    80001ff0:	b7dd                	j	80001fd6 <allocproc+0xc0>
    freeproc(p);
    80001ff2:	8526                	mv	a0,s1
    80001ff4:	00000097          	auipc	ra,0x0
    80001ff8:	e8e080e7          	jalr	-370(ra) # 80001e82 <freeproc>
    release(&p->lock);
    80001ffc:	8526                	mv	a0,s1
    80001ffe:	fffff097          	auipc	ra,0xfffff
    80002002:	cc6080e7          	jalr	-826(ra) # 80000cc4 <release>
    return 0;
    80002006:	84ca                	mv	s1,s2
    80002008:	b7f9                	j	80001fd6 <allocproc+0xc0>
      panic("kalloc");
    8000200a:	00006517          	auipc	a0,0x6
    8000200e:	29650513          	addi	a0,a0,662 # 800082a0 <digits+0x270>
    80002012:	ffffe097          	auipc	ra,0xffffe
    80002016:	536080e7          	jalr	1334(ra) # 80000548 <panic>

000000008000201a <userinit>:
{
    8000201a:	1101                	addi	sp,sp,-32
    8000201c:	ec06                	sd	ra,24(sp)
    8000201e:	e822                	sd	s0,16(sp)
    80002020:	e426                	sd	s1,8(sp)
    80002022:	1000                	addi	s0,sp,32
  p = allocproc();
    80002024:	00000097          	auipc	ra,0x0
    80002028:	ef2080e7          	jalr	-270(ra) # 80001f16 <allocproc>
    8000202c:	84aa                	mv	s1,a0
  initproc = p;
    8000202e:	00007797          	auipc	a5,0x7
    80002032:	fea7b523          	sd	a0,-22(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80002036:	03400613          	li	a2,52
    8000203a:	00007597          	auipc	a1,0x7
    8000203e:	8e658593          	addi	a1,a1,-1818 # 80008920 <initcode>
    80002042:	6928                	ld	a0,80(a0)
    80002044:	fffff097          	auipc	ra,0xfffff
    80002048:	560080e7          	jalr	1376(ra) # 800015a4 <uvminit>
  kvmcopy(p->pagetable, p->kpagetable,0, sizeof(initcode));
    8000204c:	03400693          	li	a3,52
    80002050:	4601                	li	a2,0
    80002052:	6cac                	ld	a1,88(s1)
    80002054:	68a8                	ld	a0,80(s1)
    80002056:	00000097          	auipc	ra,0x0
    8000205a:	92c080e7          	jalr	-1748(ra) # 80001982 <kvmcopy>
  p->sz = PGSIZE;
    8000205e:	6785                	lui	a5,0x1
    80002060:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80002062:	70b8                	ld	a4,96(s1)
    80002064:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80002068:	70b8                	ld	a4,96(s1)
    8000206a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000206c:	4641                	li	a2,16
    8000206e:	00006597          	auipc	a1,0x6
    80002072:	23a58593          	addi	a1,a1,570 # 800082a8 <digits+0x278>
    80002076:	16048513          	addi	a0,s1,352
    8000207a:	fffff097          	auipc	ra,0xfffff
    8000207e:	de8080e7          	jalr	-536(ra) # 80000e62 <safestrcpy>
  p->cwd = namei("/");
    80002082:	00006517          	auipc	a0,0x6
    80002086:	23650513          	addi	a0,a0,566 # 800082b8 <digits+0x288>
    8000208a:	00002097          	auipc	ra,0x2
    8000208e:	15a080e7          	jalr	346(ra) # 800041e4 <namei>
    80002092:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80002096:	4789                	li	a5,2
    80002098:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000209a:	8526                	mv	a0,s1
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	c28080e7          	jalr	-984(ra) # 80000cc4 <release>
}
    800020a4:	60e2                	ld	ra,24(sp)
    800020a6:	6442                	ld	s0,16(sp)
    800020a8:	64a2                	ld	s1,8(sp)
    800020aa:	6105                	addi	sp,sp,32
    800020ac:	8082                	ret

00000000800020ae <growproc>:
{
    800020ae:	7139                	addi	sp,sp,-64
    800020b0:	fc06                	sd	ra,56(sp)
    800020b2:	f822                	sd	s0,48(sp)
    800020b4:	f426                	sd	s1,40(sp)
    800020b6:	f04a                	sd	s2,32(sp)
    800020b8:	ec4e                	sd	s3,24(sp)
    800020ba:	e852                	sd	s4,16(sp)
    800020bc:	e456                	sd	s5,8(sp)
    800020be:	0080                	addi	s0,sp,64
    800020c0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800020c2:	00000097          	auipc	ra,0x0
    800020c6:	c0e080e7          	jalr	-1010(ra) # 80001cd0 <myproc>
    800020ca:	8a2a                	mv	s4,a0
  sz = p->sz;
    800020cc:	652c                	ld	a1,72(a0)
    800020ce:	0005899b          	sext.w	s3,a1
  if(n > 0){
    800020d2:	02904363          	bgtz	s1,800020f8 <growproc+0x4a>
  } else if(n < 0){
    800020d6:	0404cf63          	bltz	s1,80002134 <growproc+0x86>
  p->sz = sz; 
    800020da:	02099493          	slli	s1,s3,0x20
    800020de:	9081                	srli	s1,s1,0x20
    800020e0:	049a3423          	sd	s1,72(s4) # fffffffffffff048 <end+0xffffffff7ffd8028>
  return 0;
    800020e4:	4501                	li	a0,0
}
    800020e6:	70e2                	ld	ra,56(sp)
    800020e8:	7442                	ld	s0,48(sp)
    800020ea:	74a2                	ld	s1,40(sp)
    800020ec:	7902                	ld	s2,32(sp)
    800020ee:	69e2                	ld	s3,24(sp)
    800020f0:	6a42                	ld	s4,16(sp)
    800020f2:	6aa2                	ld	s5,8(sp)
    800020f4:	6121                	addi	sp,sp,64
    800020f6:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz1, sz1 + n)) == 0) {
    800020f8:	02059913          	slli	s2,a1,0x20
    800020fc:	02095913          	srli	s2,s2,0x20
    80002100:	013484bb          	addw	s1,s1,s3
    80002104:	1482                	slli	s1,s1,0x20
    80002106:	9081                	srli	s1,s1,0x20
    80002108:	8626                	mv	a2,s1
    8000210a:	85ca                	mv	a1,s2
    8000210c:	6928                	ld	a0,80(a0)
    8000210e:	fffff097          	auipc	ra,0xfffff
    80002112:	550080e7          	jalr	1360(ra) # 8000165e <uvmalloc>
    80002116:	0005099b          	sext.w	s3,a0
    8000211a:	04098963          	beqz	s3,8000216c <growproc+0xbe>
    kvmcopy(p->pagetable,p->kpagetable,sz1,sz1 + n);
    8000211e:	86a6                	mv	a3,s1
    80002120:	864a                	mv	a2,s2
    80002122:	058a3583          	ld	a1,88(s4)
    80002126:	050a3503          	ld	a0,80(s4)
    8000212a:	00000097          	auipc	ra,0x0
    8000212e:	858080e7          	jalr	-1960(ra) # 80001982 <kvmcopy>
    80002132:	b765                	j	800020da <growproc+0x2c>
    sz = uvmdealloc(p->pagetable, sz1, sz1 + n);
    80002134:	02059a93          	slli	s5,a1,0x20
    80002138:	020ada93          	srli	s5,s5,0x20
    8000213c:	013484bb          	addw	s1,s1,s3
    80002140:	02049913          	slli	s2,s1,0x20
    80002144:	02095913          	srli	s2,s2,0x20
    80002148:	864a                	mv	a2,s2
    8000214a:	85d6                	mv	a1,s5
    8000214c:	6928                	ld	a0,80(a0)
    8000214e:	fffff097          	auipc	ra,0xfffff
    80002152:	4c8080e7          	jalr	1224(ra) # 80001616 <uvmdealloc>
    80002156:	0005099b          	sext.w	s3,a0
    kvmdealloc(p->kpagetable, sz1, sz1 + n);
    8000215a:	864a                	mv	a2,s2
    8000215c:	85d6                	mv	a1,s5
    8000215e:	058a3503          	ld	a0,88(s4)
    80002162:	fffff097          	auipc	ra,0xfffff
    80002166:	5d8080e7          	jalr	1496(ra) # 8000173a <kvmdealloc>
    8000216a:	bf85                	j	800020da <growproc+0x2c>
      return -1;
    8000216c:	557d                	li	a0,-1
    8000216e:	bfa5                	j	800020e6 <growproc+0x38>

0000000080002170 <fork>:
{
    80002170:	7179                	addi	sp,sp,-48
    80002172:	f406                	sd	ra,40(sp)
    80002174:	f022                	sd	s0,32(sp)
    80002176:	ec26                	sd	s1,24(sp)
    80002178:	e84a                	sd	s2,16(sp)
    8000217a:	e44e                	sd	s3,8(sp)
    8000217c:	e052                	sd	s4,0(sp)
    8000217e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002180:	00000097          	auipc	ra,0x0
    80002184:	b50080e7          	jalr	-1200(ra) # 80001cd0 <myproc>
    80002188:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000218a:	00000097          	auipc	ra,0x0
    8000218e:	d8c080e7          	jalr	-628(ra) # 80001f16 <allocproc>
    80002192:	10050c63          	beqz	a0,800022aa <fork+0x13a>
    80002196:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80002198:	04893603          	ld	a2,72(s2) # 4000048 <_entry-0x7bffffb8>
    8000219c:	692c                	ld	a1,80(a0)
    8000219e:	05093503          	ld	a0,80(s2)
    800021a2:	fffff097          	auipc	ra,0xfffff
    800021a6:	70e080e7          	jalr	1806(ra) # 800018b0 <uvmcopy>
    800021aa:	06054563          	bltz	a0,80002214 <fork+0xa4>
  if(kvmcopy(np->pagetable, np->kpagetable,0, p->sz) < 0){
    800021ae:	04893683          	ld	a3,72(s2)
    800021b2:	4601                	li	a2,0
    800021b4:	0589b583          	ld	a1,88(s3)
    800021b8:	0509b503          	ld	a0,80(s3)
    800021bc:	fffff097          	auipc	ra,0xfffff
    800021c0:	7c6080e7          	jalr	1990(ra) # 80001982 <kvmcopy>
    800021c4:	06054463          	bltz	a0,8000222c <fork+0xbc>
  np->sz = p->sz;
    800021c8:	04893783          	ld	a5,72(s2)
    800021cc:	04f9b423          	sd	a5,72(s3)
  np->parent = p;
    800021d0:	0329b023          	sd	s2,32(s3)
  *(np->trapframe) = *(p->trapframe);
    800021d4:	06093683          	ld	a3,96(s2)
    800021d8:	87b6                	mv	a5,a3
    800021da:	0609b703          	ld	a4,96(s3)
    800021de:	12068693          	addi	a3,a3,288
    800021e2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800021e6:	6788                	ld	a0,8(a5)
    800021e8:	6b8c                	ld	a1,16(a5)
    800021ea:	6f90                	ld	a2,24(a5)
    800021ec:	01073023          	sd	a6,0(a4)
    800021f0:	e708                	sd	a0,8(a4)
    800021f2:	eb0c                	sd	a1,16(a4)
    800021f4:	ef10                	sd	a2,24(a4)
    800021f6:	02078793          	addi	a5,a5,32
    800021fa:	02070713          	addi	a4,a4,32
    800021fe:	fed792e3          	bne	a5,a3,800021e2 <fork+0x72>
  np->trapframe->a0 = 0;
    80002202:	0609b783          	ld	a5,96(s3)
    80002206:	0607b823          	sd	zero,112(a5)
    8000220a:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    8000220e:	15800a13          	li	s4,344
    80002212:	a099                	j	80002258 <fork+0xe8>
    freeproc(np);
    80002214:	854e                	mv	a0,s3
    80002216:	00000097          	auipc	ra,0x0
    8000221a:	c6c080e7          	jalr	-916(ra) # 80001e82 <freeproc>
    release(&np->lock);
    8000221e:	854e                	mv	a0,s3
    80002220:	fffff097          	auipc	ra,0xfffff
    80002224:	aa4080e7          	jalr	-1372(ra) # 80000cc4 <release>
    return -1;
    80002228:	54fd                	li	s1,-1
    8000222a:	a0bd                	j	80002298 <fork+0x128>
    freeproc(np);
    8000222c:	854e                	mv	a0,s3
    8000222e:	00000097          	auipc	ra,0x0
    80002232:	c54080e7          	jalr	-940(ra) # 80001e82 <freeproc>
    release(&np->lock);
    80002236:	854e                	mv	a0,s3
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	a8c080e7          	jalr	-1396(ra) # 80000cc4 <release>
    return -1;
    80002240:	54fd                	li	s1,-1
    80002242:	a899                	j	80002298 <fork+0x128>
      np->ofile[i] = filedup(p->ofile[i]);
    80002244:	00002097          	auipc	ra,0x2
    80002248:	62c080e7          	jalr	1580(ra) # 80004870 <filedup>
    8000224c:	009987b3          	add	a5,s3,s1
    80002250:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80002252:	04a1                	addi	s1,s1,8
    80002254:	01448763          	beq	s1,s4,80002262 <fork+0xf2>
    if(p->ofile[i])
    80002258:	009907b3          	add	a5,s2,s1
    8000225c:	6388                	ld	a0,0(a5)
    8000225e:	f17d                	bnez	a0,80002244 <fork+0xd4>
    80002260:	bfcd                	j	80002252 <fork+0xe2>
  np->cwd = idup(p->cwd);
    80002262:	15893503          	ld	a0,344(s2)
    80002266:	00001097          	auipc	ra,0x1
    8000226a:	790080e7          	jalr	1936(ra) # 800039f6 <idup>
    8000226e:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002272:	4641                	li	a2,16
    80002274:	16090593          	addi	a1,s2,352
    80002278:	16098513          	addi	a0,s3,352
    8000227c:	fffff097          	auipc	ra,0xfffff
    80002280:	be6080e7          	jalr	-1050(ra) # 80000e62 <safestrcpy>
  pid = np->pid;
    80002284:	0389a483          	lw	s1,56(s3)
  np->state = RUNNABLE;
    80002288:	4789                	li	a5,2
    8000228a:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000228e:	854e                	mv	a0,s3
    80002290:	fffff097          	auipc	ra,0xfffff
    80002294:	a34080e7          	jalr	-1484(ra) # 80000cc4 <release>
}
    80002298:	8526                	mv	a0,s1
    8000229a:	70a2                	ld	ra,40(sp)
    8000229c:	7402                	ld	s0,32(sp)
    8000229e:	64e2                	ld	s1,24(sp)
    800022a0:	6942                	ld	s2,16(sp)
    800022a2:	69a2                	ld	s3,8(sp)
    800022a4:	6a02                	ld	s4,0(sp)
    800022a6:	6145                	addi	sp,sp,48
    800022a8:	8082                	ret
    return -1;
    800022aa:	54fd                	li	s1,-1
    800022ac:	b7f5                	j	80002298 <fork+0x128>

00000000800022ae <reparent>:
{
    800022ae:	7179                	addi	sp,sp,-48
    800022b0:	f406                	sd	ra,40(sp)
    800022b2:	f022                	sd	s0,32(sp)
    800022b4:	ec26                	sd	s1,24(sp)
    800022b6:	e84a                	sd	s2,16(sp)
    800022b8:	e44e                	sd	s3,8(sp)
    800022ba:	e052                	sd	s4,0(sp)
    800022bc:	1800                	addi	s0,sp,48
    800022be:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022c0:	00010497          	auipc	s1,0x10
    800022c4:	aa848493          	addi	s1,s1,-1368 # 80011d68 <proc>
      pp->parent = initproc;
    800022c8:	00007a17          	auipc	s4,0x7
    800022cc:	d50a0a13          	addi	s4,s4,-688 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022d0:	00015997          	auipc	s3,0x15
    800022d4:	69898993          	addi	s3,s3,1688 # 80017968 <tickslock>
    800022d8:	a029                	j	800022e2 <reparent+0x34>
    800022da:	17048493          	addi	s1,s1,368
    800022de:	03348363          	beq	s1,s3,80002304 <reparent+0x56>
    if(pp->parent == p){
    800022e2:	709c                	ld	a5,32(s1)
    800022e4:	ff279be3          	bne	a5,s2,800022da <reparent+0x2c>
      acquire(&pp->lock);
    800022e8:	8526                	mv	a0,s1
    800022ea:	fffff097          	auipc	ra,0xfffff
    800022ee:	926080e7          	jalr	-1754(ra) # 80000c10 <acquire>
      pp->parent = initproc;
    800022f2:	000a3783          	ld	a5,0(s4)
    800022f6:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    800022f8:	8526                	mv	a0,s1
    800022fa:	fffff097          	auipc	ra,0xfffff
    800022fe:	9ca080e7          	jalr	-1590(ra) # 80000cc4 <release>
    80002302:	bfe1                	j	800022da <reparent+0x2c>
}
    80002304:	70a2                	ld	ra,40(sp)
    80002306:	7402                	ld	s0,32(sp)
    80002308:	64e2                	ld	s1,24(sp)
    8000230a:	6942                	ld	s2,16(sp)
    8000230c:	69a2                	ld	s3,8(sp)
    8000230e:	6a02                	ld	s4,0(sp)
    80002310:	6145                	addi	sp,sp,48
    80002312:	8082                	ret

0000000080002314 <scheduler>:
{
    80002314:	715d                	addi	sp,sp,-80
    80002316:	e486                	sd	ra,72(sp)
    80002318:	e0a2                	sd	s0,64(sp)
    8000231a:	fc26                	sd	s1,56(sp)
    8000231c:	f84a                	sd	s2,48(sp)
    8000231e:	f44e                	sd	s3,40(sp)
    80002320:	f052                	sd	s4,32(sp)
    80002322:	ec56                	sd	s5,24(sp)
    80002324:	e85a                	sd	s6,16(sp)
    80002326:	e45e                	sd	s7,8(sp)
    80002328:	e062                	sd	s8,0(sp)
    8000232a:	0880                	addi	s0,sp,80
    8000232c:	8792                	mv	a5,tp
  int id = r_tp();
    8000232e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002330:	00779b13          	slli	s6,a5,0x7
    80002334:	0000f717          	auipc	a4,0xf
    80002338:	61c70713          	addi	a4,a4,1564 # 80011950 <pid_lock>
    8000233c:	975a                	add	a4,a4,s6
    8000233e:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80002342:	0000f717          	auipc	a4,0xf
    80002346:	62e70713          	addi	a4,a4,1582 # 80011970 <cpus+0x8>
    8000234a:	9b3a                	add	s6,s6,a4
        c->proc = p;
    8000234c:	079e                	slli	a5,a5,0x7
    8000234e:	0000fa17          	auipc	s4,0xf
    80002352:	602a0a13          	addi	s4,s4,1538 # 80011950 <pid_lock>
    80002356:	9a3e                	add	s4,s4,a5
        w_satp(MAKE_SATP(p->kpagetable));
    80002358:	5bfd                	li	s7,-1
    8000235a:	1bfe                	slli	s7,s7,0x3f
    for(p = proc; p < &proc[NPROC]; p++) {
    8000235c:	00015997          	auipc	s3,0x15
    80002360:	60c98993          	addi	s3,s3,1548 # 80017968 <tickslock>
    80002364:	a8b9                	j	800023c2 <scheduler+0xae>
        p->state = RUNNING;
    80002366:	0154ac23          	sw	s5,24(s1)
        c->proc = p;
    8000236a:	009a3c23          	sd	s1,24(s4)
        w_satp(MAKE_SATP(p->kpagetable));
    8000236e:	6cbc                	ld	a5,88(s1)
    80002370:	83b1                	srli	a5,a5,0xc
    80002372:	0177e7b3          	or	a5,a5,s7
  asm volatile("csrw satp, %0" : : "r" (x));
    80002376:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000237a:	12000073          	sfence.vma
        swtch(&c->context, &p->context);
    8000237e:	06848593          	addi	a1,s1,104
    80002382:	855a                	mv	a0,s6
    80002384:	00000097          	auipc	ra,0x0
    80002388:	64c080e7          	jalr	1612(ra) # 800029d0 <swtch>
        kvminithart();
    8000238c:	fffff097          	auipc	ra,0xfffff
    80002390:	d02080e7          	jalr	-766(ra) # 8000108e <kvminithart>
        c->proc = 0;
    80002394:	000a3c23          	sd	zero,24(s4)
        found = 1;
    80002398:	4c05                	li	s8,1
      release(&p->lock);
    8000239a:	8526                	mv	a0,s1
    8000239c:	fffff097          	auipc	ra,0xfffff
    800023a0:	928080e7          	jalr	-1752(ra) # 80000cc4 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800023a4:	17048493          	addi	s1,s1,368
    800023a8:	01348b63          	beq	s1,s3,800023be <scheduler+0xaa>
      acquire(&p->lock);
    800023ac:	8526                	mv	a0,s1
    800023ae:	fffff097          	auipc	ra,0xfffff
    800023b2:	862080e7          	jalr	-1950(ra) # 80000c10 <acquire>
      if(p->state == RUNNABLE) {
    800023b6:	4c9c                	lw	a5,24(s1)
    800023b8:	ff2791e3          	bne	a5,s2,8000239a <scheduler+0x86>
    800023bc:	b76d                	j	80002366 <scheduler+0x52>
    if(found == 0) {
    800023be:	020c0063          	beqz	s8,800023de <scheduler+0xca>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800023c2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800023c6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800023ca:	10079073          	csrw	sstatus,a5
    int found = 0;
    800023ce:	4c01                	li	s8,0
    for(p = proc; p < &proc[NPROC]; p++) {
    800023d0:	00010497          	auipc	s1,0x10
    800023d4:	99848493          	addi	s1,s1,-1640 # 80011d68 <proc>
      if(p->state == RUNNABLE) {
    800023d8:	4909                	li	s2,2
        p->state = RUNNING;
    800023da:	4a8d                	li	s5,3
    800023dc:	bfc1                	j	800023ac <scheduler+0x98>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800023de:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800023e2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800023e6:	10079073          	csrw	sstatus,a5
        kvminithart();
    800023ea:	fffff097          	auipc	ra,0xfffff
    800023ee:	ca4080e7          	jalr	-860(ra) # 8000108e <kvminithart>
      asm volatile("wfi");
    800023f2:	10500073          	wfi
    800023f6:	b7f1                	j	800023c2 <scheduler+0xae>

00000000800023f8 <sched>:
{
    800023f8:	7179                	addi	sp,sp,-48
    800023fa:	f406                	sd	ra,40(sp)
    800023fc:	f022                	sd	s0,32(sp)
    800023fe:	ec26                	sd	s1,24(sp)
    80002400:	e84a                	sd	s2,16(sp)
    80002402:	e44e                	sd	s3,8(sp)
    80002404:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002406:	00000097          	auipc	ra,0x0
    8000240a:	8ca080e7          	jalr	-1846(ra) # 80001cd0 <myproc>
    8000240e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002410:	ffffe097          	auipc	ra,0xffffe
    80002414:	786080e7          	jalr	1926(ra) # 80000b96 <holding>
    80002418:	c93d                	beqz	a0,8000248e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000241a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000241c:	2781                	sext.w	a5,a5
    8000241e:	079e                	slli	a5,a5,0x7
    80002420:	0000f717          	auipc	a4,0xf
    80002424:	53070713          	addi	a4,a4,1328 # 80011950 <pid_lock>
    80002428:	97ba                	add	a5,a5,a4
    8000242a:	0907a703          	lw	a4,144(a5)
    8000242e:	4785                	li	a5,1
    80002430:	06f71763          	bne	a4,a5,8000249e <sched+0xa6>
  if(p->state == RUNNING)
    80002434:	4c98                	lw	a4,24(s1)
    80002436:	478d                	li	a5,3
    80002438:	06f70b63          	beq	a4,a5,800024ae <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000243c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002440:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002442:	efb5                	bnez	a5,800024be <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002444:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002446:	0000f917          	auipc	s2,0xf
    8000244a:	50a90913          	addi	s2,s2,1290 # 80011950 <pid_lock>
    8000244e:	2781                	sext.w	a5,a5
    80002450:	079e                	slli	a5,a5,0x7
    80002452:	97ca                	add	a5,a5,s2
    80002454:	0947a983          	lw	s3,148(a5)
    80002458:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000245a:	2781                	sext.w	a5,a5
    8000245c:	079e                	slli	a5,a5,0x7
    8000245e:	0000f597          	auipc	a1,0xf
    80002462:	51258593          	addi	a1,a1,1298 # 80011970 <cpus+0x8>
    80002466:	95be                	add	a1,a1,a5
    80002468:	06848513          	addi	a0,s1,104
    8000246c:	00000097          	auipc	ra,0x0
    80002470:	564080e7          	jalr	1380(ra) # 800029d0 <swtch>
    80002474:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002476:	2781                	sext.w	a5,a5
    80002478:	079e                	slli	a5,a5,0x7
    8000247a:	97ca                	add	a5,a5,s2
    8000247c:	0937aa23          	sw	s3,148(a5)
}
    80002480:	70a2                	ld	ra,40(sp)
    80002482:	7402                	ld	s0,32(sp)
    80002484:	64e2                	ld	s1,24(sp)
    80002486:	6942                	ld	s2,16(sp)
    80002488:	69a2                	ld	s3,8(sp)
    8000248a:	6145                	addi	sp,sp,48
    8000248c:	8082                	ret
    panic("sched p->lock");
    8000248e:	00006517          	auipc	a0,0x6
    80002492:	e3250513          	addi	a0,a0,-462 # 800082c0 <digits+0x290>
    80002496:	ffffe097          	auipc	ra,0xffffe
    8000249a:	0b2080e7          	jalr	178(ra) # 80000548 <panic>
    panic("sched locks");
    8000249e:	00006517          	auipc	a0,0x6
    800024a2:	e3250513          	addi	a0,a0,-462 # 800082d0 <digits+0x2a0>
    800024a6:	ffffe097          	auipc	ra,0xffffe
    800024aa:	0a2080e7          	jalr	162(ra) # 80000548 <panic>
    panic("sched running");
    800024ae:	00006517          	auipc	a0,0x6
    800024b2:	e3250513          	addi	a0,a0,-462 # 800082e0 <digits+0x2b0>
    800024b6:	ffffe097          	auipc	ra,0xffffe
    800024ba:	092080e7          	jalr	146(ra) # 80000548 <panic>
    panic("sched interruptible");
    800024be:	00006517          	auipc	a0,0x6
    800024c2:	e3250513          	addi	a0,a0,-462 # 800082f0 <digits+0x2c0>
    800024c6:	ffffe097          	auipc	ra,0xffffe
    800024ca:	082080e7          	jalr	130(ra) # 80000548 <panic>

00000000800024ce <exit>:
{
    800024ce:	7179                	addi	sp,sp,-48
    800024d0:	f406                	sd	ra,40(sp)
    800024d2:	f022                	sd	s0,32(sp)
    800024d4:	ec26                	sd	s1,24(sp)
    800024d6:	e84a                	sd	s2,16(sp)
    800024d8:	e44e                	sd	s3,8(sp)
    800024da:	e052                	sd	s4,0(sp)
    800024dc:	1800                	addi	s0,sp,48
    800024de:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800024e0:	fffff097          	auipc	ra,0xfffff
    800024e4:	7f0080e7          	jalr	2032(ra) # 80001cd0 <myproc>
    800024e8:	89aa                	mv	s3,a0
  if(p == initproc)
    800024ea:	00007797          	auipc	a5,0x7
    800024ee:	b2e7b783          	ld	a5,-1234(a5) # 80009018 <initproc>
    800024f2:	0d850493          	addi	s1,a0,216
    800024f6:	15850913          	addi	s2,a0,344
    800024fa:	02a79363          	bne	a5,a0,80002520 <exit+0x52>
    panic("init exiting");
    800024fe:	00006517          	auipc	a0,0x6
    80002502:	e0a50513          	addi	a0,a0,-502 # 80008308 <digits+0x2d8>
    80002506:	ffffe097          	auipc	ra,0xffffe
    8000250a:	042080e7          	jalr	66(ra) # 80000548 <panic>
      fileclose(f);
    8000250e:	00002097          	auipc	ra,0x2
    80002512:	3b4080e7          	jalr	948(ra) # 800048c2 <fileclose>
      p->ofile[fd] = 0;
    80002516:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000251a:	04a1                	addi	s1,s1,8
    8000251c:	01248563          	beq	s1,s2,80002526 <exit+0x58>
    if(p->ofile[fd]){
    80002520:	6088                	ld	a0,0(s1)
    80002522:	f575                	bnez	a0,8000250e <exit+0x40>
    80002524:	bfdd                	j	8000251a <exit+0x4c>
  begin_op();
    80002526:	00002097          	auipc	ra,0x2
    8000252a:	eca080e7          	jalr	-310(ra) # 800043f0 <begin_op>
  iput(p->cwd);
    8000252e:	1589b503          	ld	a0,344(s3)
    80002532:	00001097          	auipc	ra,0x1
    80002536:	6bc080e7          	jalr	1724(ra) # 80003bee <iput>
  end_op();
    8000253a:	00002097          	auipc	ra,0x2
    8000253e:	f36080e7          	jalr	-202(ra) # 80004470 <end_op>
  p->cwd = 0;
    80002542:	1409bc23          	sd	zero,344(s3)
  acquire(&initproc->lock);
    80002546:	00007497          	auipc	s1,0x7
    8000254a:	ad248493          	addi	s1,s1,-1326 # 80009018 <initproc>
    8000254e:	6088                	ld	a0,0(s1)
    80002550:	ffffe097          	auipc	ra,0xffffe
    80002554:	6c0080e7          	jalr	1728(ra) # 80000c10 <acquire>
  wakeup1(initproc);
    80002558:	6088                	ld	a0,0(s1)
    8000255a:	fffff097          	auipc	ra,0xfffff
    8000255e:	69e080e7          	jalr	1694(ra) # 80001bf8 <wakeup1>
  release(&initproc->lock);
    80002562:	6088                	ld	a0,0(s1)
    80002564:	ffffe097          	auipc	ra,0xffffe
    80002568:	760080e7          	jalr	1888(ra) # 80000cc4 <release>
  acquire(&p->lock);
    8000256c:	854e                	mv	a0,s3
    8000256e:	ffffe097          	auipc	ra,0xffffe
    80002572:	6a2080e7          	jalr	1698(ra) # 80000c10 <acquire>
  struct proc *original_parent = p->parent;
    80002576:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    8000257a:	854e                	mv	a0,s3
    8000257c:	ffffe097          	auipc	ra,0xffffe
    80002580:	748080e7          	jalr	1864(ra) # 80000cc4 <release>
  acquire(&original_parent->lock);
    80002584:	8526                	mv	a0,s1
    80002586:	ffffe097          	auipc	ra,0xffffe
    8000258a:	68a080e7          	jalr	1674(ra) # 80000c10 <acquire>
  acquire(&p->lock);
    8000258e:	854e                	mv	a0,s3
    80002590:	ffffe097          	auipc	ra,0xffffe
    80002594:	680080e7          	jalr	1664(ra) # 80000c10 <acquire>
  reparent(p);
    80002598:	854e                	mv	a0,s3
    8000259a:	00000097          	auipc	ra,0x0
    8000259e:	d14080e7          	jalr	-748(ra) # 800022ae <reparent>
  wakeup1(original_parent);
    800025a2:	8526                	mv	a0,s1
    800025a4:	fffff097          	auipc	ra,0xfffff
    800025a8:	654080e7          	jalr	1620(ra) # 80001bf8 <wakeup1>
  p->xstate = status;
    800025ac:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    800025b0:	4791                	li	a5,4
    800025b2:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    800025b6:	8526                	mv	a0,s1
    800025b8:	ffffe097          	auipc	ra,0xffffe
    800025bc:	70c080e7          	jalr	1804(ra) # 80000cc4 <release>
  sched();
    800025c0:	00000097          	auipc	ra,0x0
    800025c4:	e38080e7          	jalr	-456(ra) # 800023f8 <sched>
  panic("zombie exit");
    800025c8:	00006517          	auipc	a0,0x6
    800025cc:	d5050513          	addi	a0,a0,-688 # 80008318 <digits+0x2e8>
    800025d0:	ffffe097          	auipc	ra,0xffffe
    800025d4:	f78080e7          	jalr	-136(ra) # 80000548 <panic>

00000000800025d8 <yield>:
{
    800025d8:	1101                	addi	sp,sp,-32
    800025da:	ec06                	sd	ra,24(sp)
    800025dc:	e822                	sd	s0,16(sp)
    800025de:	e426                	sd	s1,8(sp)
    800025e0:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800025e2:	fffff097          	auipc	ra,0xfffff
    800025e6:	6ee080e7          	jalr	1774(ra) # 80001cd0 <myproc>
    800025ea:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800025ec:	ffffe097          	auipc	ra,0xffffe
    800025f0:	624080e7          	jalr	1572(ra) # 80000c10 <acquire>
  p->state = RUNNABLE;
    800025f4:	4789                	li	a5,2
    800025f6:	cc9c                	sw	a5,24(s1)
  sched();
    800025f8:	00000097          	auipc	ra,0x0
    800025fc:	e00080e7          	jalr	-512(ra) # 800023f8 <sched>
  release(&p->lock);
    80002600:	8526                	mv	a0,s1
    80002602:	ffffe097          	auipc	ra,0xffffe
    80002606:	6c2080e7          	jalr	1730(ra) # 80000cc4 <release>
}
    8000260a:	60e2                	ld	ra,24(sp)
    8000260c:	6442                	ld	s0,16(sp)
    8000260e:	64a2                	ld	s1,8(sp)
    80002610:	6105                	addi	sp,sp,32
    80002612:	8082                	ret

0000000080002614 <sleep>:
{
    80002614:	7179                	addi	sp,sp,-48
    80002616:	f406                	sd	ra,40(sp)
    80002618:	f022                	sd	s0,32(sp)
    8000261a:	ec26                	sd	s1,24(sp)
    8000261c:	e84a                	sd	s2,16(sp)
    8000261e:	e44e                	sd	s3,8(sp)
    80002620:	1800                	addi	s0,sp,48
    80002622:	89aa                	mv	s3,a0
    80002624:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002626:	fffff097          	auipc	ra,0xfffff
    8000262a:	6aa080e7          	jalr	1706(ra) # 80001cd0 <myproc>
    8000262e:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002630:	05250663          	beq	a0,s2,8000267c <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    80002634:	ffffe097          	auipc	ra,0xffffe
    80002638:	5dc080e7          	jalr	1500(ra) # 80000c10 <acquire>
    release(lk);
    8000263c:	854a                	mv	a0,s2
    8000263e:	ffffe097          	auipc	ra,0xffffe
    80002642:	686080e7          	jalr	1670(ra) # 80000cc4 <release>
  p->chan = chan;
    80002646:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000264a:	4785                	li	a5,1
    8000264c:	cc9c                	sw	a5,24(s1)
  sched();
    8000264e:	00000097          	auipc	ra,0x0
    80002652:	daa080e7          	jalr	-598(ra) # 800023f8 <sched>
  p->chan = 0;
    80002656:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    8000265a:	8526                	mv	a0,s1
    8000265c:	ffffe097          	auipc	ra,0xffffe
    80002660:	668080e7          	jalr	1640(ra) # 80000cc4 <release>
    acquire(lk);
    80002664:	854a                	mv	a0,s2
    80002666:	ffffe097          	auipc	ra,0xffffe
    8000266a:	5aa080e7          	jalr	1450(ra) # 80000c10 <acquire>
}
    8000266e:	70a2                	ld	ra,40(sp)
    80002670:	7402                	ld	s0,32(sp)
    80002672:	64e2                	ld	s1,24(sp)
    80002674:	6942                	ld	s2,16(sp)
    80002676:	69a2                	ld	s3,8(sp)
    80002678:	6145                	addi	sp,sp,48
    8000267a:	8082                	ret
  p->chan = chan;
    8000267c:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    80002680:	4785                	li	a5,1
    80002682:	cd1c                	sw	a5,24(a0)
  sched();
    80002684:	00000097          	auipc	ra,0x0
    80002688:	d74080e7          	jalr	-652(ra) # 800023f8 <sched>
  p->chan = 0;
    8000268c:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    80002690:	bff9                	j	8000266e <sleep+0x5a>

0000000080002692 <wait>:
{
    80002692:	715d                	addi	sp,sp,-80
    80002694:	e486                	sd	ra,72(sp)
    80002696:	e0a2                	sd	s0,64(sp)
    80002698:	fc26                	sd	s1,56(sp)
    8000269a:	f84a                	sd	s2,48(sp)
    8000269c:	f44e                	sd	s3,40(sp)
    8000269e:	f052                	sd	s4,32(sp)
    800026a0:	ec56                	sd	s5,24(sp)
    800026a2:	e85a                	sd	s6,16(sp)
    800026a4:	e45e                	sd	s7,8(sp)
    800026a6:	e062                	sd	s8,0(sp)
    800026a8:	0880                	addi	s0,sp,80
    800026aa:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800026ac:	fffff097          	auipc	ra,0xfffff
    800026b0:	624080e7          	jalr	1572(ra) # 80001cd0 <myproc>
    800026b4:	892a                	mv	s2,a0
  acquire(&p->lock);
    800026b6:	8c2a                	mv	s8,a0
    800026b8:	ffffe097          	auipc	ra,0xffffe
    800026bc:	558080e7          	jalr	1368(ra) # 80000c10 <acquire>
    havekids = 0;
    800026c0:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800026c2:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    800026c4:	00015997          	auipc	s3,0x15
    800026c8:	2a498993          	addi	s3,s3,676 # 80017968 <tickslock>
        havekids = 1;
    800026cc:	4a85                	li	s5,1
    havekids = 0;
    800026ce:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800026d0:	0000f497          	auipc	s1,0xf
    800026d4:	69848493          	addi	s1,s1,1688 # 80011d68 <proc>
    800026d8:	a08d                	j	8000273a <wait+0xa8>
          pid = np->pid;
    800026da:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800026de:	000b0e63          	beqz	s6,800026fa <wait+0x68>
    800026e2:	4691                	li	a3,4
    800026e4:	03448613          	addi	a2,s1,52
    800026e8:	85da                	mv	a1,s6
    800026ea:	05093503          	ld	a0,80(s2)
    800026ee:	fffff097          	auipc	ra,0xfffff
    800026f2:	386080e7          	jalr	902(ra) # 80001a74 <copyout>
    800026f6:	02054263          	bltz	a0,8000271a <wait+0x88>
          freeproc(np);
    800026fa:	8526                	mv	a0,s1
    800026fc:	fffff097          	auipc	ra,0xfffff
    80002700:	786080e7          	jalr	1926(ra) # 80001e82 <freeproc>
          release(&np->lock);
    80002704:	8526                	mv	a0,s1
    80002706:	ffffe097          	auipc	ra,0xffffe
    8000270a:	5be080e7          	jalr	1470(ra) # 80000cc4 <release>
          release(&p->lock);
    8000270e:	854a                	mv	a0,s2
    80002710:	ffffe097          	auipc	ra,0xffffe
    80002714:	5b4080e7          	jalr	1460(ra) # 80000cc4 <release>
          return pid;
    80002718:	a8a9                	j	80002772 <wait+0xe0>
            release(&np->lock);
    8000271a:	8526                	mv	a0,s1
    8000271c:	ffffe097          	auipc	ra,0xffffe
    80002720:	5a8080e7          	jalr	1448(ra) # 80000cc4 <release>
            release(&p->lock);
    80002724:	854a                	mv	a0,s2
    80002726:	ffffe097          	auipc	ra,0xffffe
    8000272a:	59e080e7          	jalr	1438(ra) # 80000cc4 <release>
            return -1;
    8000272e:	59fd                	li	s3,-1
    80002730:	a089                	j	80002772 <wait+0xe0>
    for(np = proc; np < &proc[NPROC]; np++){
    80002732:	17048493          	addi	s1,s1,368
    80002736:	03348463          	beq	s1,s3,8000275e <wait+0xcc>
      if(np->parent == p){
    8000273a:	709c                	ld	a5,32(s1)
    8000273c:	ff279be3          	bne	a5,s2,80002732 <wait+0xa0>
        acquire(&np->lock);
    80002740:	8526                	mv	a0,s1
    80002742:	ffffe097          	auipc	ra,0xffffe
    80002746:	4ce080e7          	jalr	1230(ra) # 80000c10 <acquire>
        if(np->state == ZOMBIE){
    8000274a:	4c9c                	lw	a5,24(s1)
    8000274c:	f94787e3          	beq	a5,s4,800026da <wait+0x48>
        release(&np->lock);
    80002750:	8526                	mv	a0,s1
    80002752:	ffffe097          	auipc	ra,0xffffe
    80002756:	572080e7          	jalr	1394(ra) # 80000cc4 <release>
        havekids = 1;
    8000275a:	8756                	mv	a4,s5
    8000275c:	bfd9                	j	80002732 <wait+0xa0>
    if(!havekids || p->killed){
    8000275e:	c701                	beqz	a4,80002766 <wait+0xd4>
    80002760:	03092783          	lw	a5,48(s2)
    80002764:	c785                	beqz	a5,8000278c <wait+0xfa>
      release(&p->lock);
    80002766:	854a                	mv	a0,s2
    80002768:	ffffe097          	auipc	ra,0xffffe
    8000276c:	55c080e7          	jalr	1372(ra) # 80000cc4 <release>
      return -1;
    80002770:	59fd                	li	s3,-1
}
    80002772:	854e                	mv	a0,s3
    80002774:	60a6                	ld	ra,72(sp)
    80002776:	6406                	ld	s0,64(sp)
    80002778:	74e2                	ld	s1,56(sp)
    8000277a:	7942                	ld	s2,48(sp)
    8000277c:	79a2                	ld	s3,40(sp)
    8000277e:	7a02                	ld	s4,32(sp)
    80002780:	6ae2                	ld	s5,24(sp)
    80002782:	6b42                	ld	s6,16(sp)
    80002784:	6ba2                	ld	s7,8(sp)
    80002786:	6c02                	ld	s8,0(sp)
    80002788:	6161                	addi	sp,sp,80
    8000278a:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    8000278c:	85e2                	mv	a1,s8
    8000278e:	854a                	mv	a0,s2
    80002790:	00000097          	auipc	ra,0x0
    80002794:	e84080e7          	jalr	-380(ra) # 80002614 <sleep>
    havekids = 0;
    80002798:	bf1d                	j	800026ce <wait+0x3c>

000000008000279a <wakeup>:
{
    8000279a:	7139                	addi	sp,sp,-64
    8000279c:	fc06                	sd	ra,56(sp)
    8000279e:	f822                	sd	s0,48(sp)
    800027a0:	f426                	sd	s1,40(sp)
    800027a2:	f04a                	sd	s2,32(sp)
    800027a4:	ec4e                	sd	s3,24(sp)
    800027a6:	e852                	sd	s4,16(sp)
    800027a8:	e456                	sd	s5,8(sp)
    800027aa:	0080                	addi	s0,sp,64
    800027ac:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    800027ae:	0000f497          	auipc	s1,0xf
    800027b2:	5ba48493          	addi	s1,s1,1466 # 80011d68 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    800027b6:	4985                	li	s3,1
      p->state = RUNNABLE;
    800027b8:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    800027ba:	00015917          	auipc	s2,0x15
    800027be:	1ae90913          	addi	s2,s2,430 # 80017968 <tickslock>
    800027c2:	a821                	j	800027da <wakeup+0x40>
      p->state = RUNNABLE;
    800027c4:	0154ac23          	sw	s5,24(s1)
    release(&p->lock);
    800027c8:	8526                	mv	a0,s1
    800027ca:	ffffe097          	auipc	ra,0xffffe
    800027ce:	4fa080e7          	jalr	1274(ra) # 80000cc4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800027d2:	17048493          	addi	s1,s1,368
    800027d6:	01248e63          	beq	s1,s2,800027f2 <wakeup+0x58>
    acquire(&p->lock);
    800027da:	8526                	mv	a0,s1
    800027dc:	ffffe097          	auipc	ra,0xffffe
    800027e0:	434080e7          	jalr	1076(ra) # 80000c10 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    800027e4:	4c9c                	lw	a5,24(s1)
    800027e6:	ff3791e3          	bne	a5,s3,800027c8 <wakeup+0x2e>
    800027ea:	749c                	ld	a5,40(s1)
    800027ec:	fd479ee3          	bne	a5,s4,800027c8 <wakeup+0x2e>
    800027f0:	bfd1                	j	800027c4 <wakeup+0x2a>
}
    800027f2:	70e2                	ld	ra,56(sp)
    800027f4:	7442                	ld	s0,48(sp)
    800027f6:	74a2                	ld	s1,40(sp)
    800027f8:	7902                	ld	s2,32(sp)
    800027fa:	69e2                	ld	s3,24(sp)
    800027fc:	6a42                	ld	s4,16(sp)
    800027fe:	6aa2                	ld	s5,8(sp)
    80002800:	6121                	addi	sp,sp,64
    80002802:	8082                	ret

0000000080002804 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002804:	7179                	addi	sp,sp,-48
    80002806:	f406                	sd	ra,40(sp)
    80002808:	f022                	sd	s0,32(sp)
    8000280a:	ec26                	sd	s1,24(sp)
    8000280c:	e84a                	sd	s2,16(sp)
    8000280e:	e44e                	sd	s3,8(sp)
    80002810:	1800                	addi	s0,sp,48
    80002812:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002814:	0000f497          	auipc	s1,0xf
    80002818:	55448493          	addi	s1,s1,1364 # 80011d68 <proc>
    8000281c:	00015997          	auipc	s3,0x15
    80002820:	14c98993          	addi	s3,s3,332 # 80017968 <tickslock>
    acquire(&p->lock);
    80002824:	8526                	mv	a0,s1
    80002826:	ffffe097          	auipc	ra,0xffffe
    8000282a:	3ea080e7          	jalr	1002(ra) # 80000c10 <acquire>
    if(p->pid == pid){
    8000282e:	5c9c                	lw	a5,56(s1)
    80002830:	01278d63          	beq	a5,s2,8000284a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002834:	8526                	mv	a0,s1
    80002836:	ffffe097          	auipc	ra,0xffffe
    8000283a:	48e080e7          	jalr	1166(ra) # 80000cc4 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000283e:	17048493          	addi	s1,s1,368
    80002842:	ff3491e3          	bne	s1,s3,80002824 <kill+0x20>
  }
  return -1;
    80002846:	557d                	li	a0,-1
    80002848:	a829                	j	80002862 <kill+0x5e>
      p->killed = 1;
    8000284a:	4785                	li	a5,1
    8000284c:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    8000284e:	4c98                	lw	a4,24(s1)
    80002850:	4785                	li	a5,1
    80002852:	00f70f63          	beq	a4,a5,80002870 <kill+0x6c>
      release(&p->lock);
    80002856:	8526                	mv	a0,s1
    80002858:	ffffe097          	auipc	ra,0xffffe
    8000285c:	46c080e7          	jalr	1132(ra) # 80000cc4 <release>
      return 0;
    80002860:	4501                	li	a0,0
}
    80002862:	70a2                	ld	ra,40(sp)
    80002864:	7402                	ld	s0,32(sp)
    80002866:	64e2                	ld	s1,24(sp)
    80002868:	6942                	ld	s2,16(sp)
    8000286a:	69a2                	ld	s3,8(sp)
    8000286c:	6145                	addi	sp,sp,48
    8000286e:	8082                	ret
        p->state = RUNNABLE;
    80002870:	4789                	li	a5,2
    80002872:	cc9c                	sw	a5,24(s1)
    80002874:	b7cd                	j	80002856 <kill+0x52>

0000000080002876 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002876:	7179                	addi	sp,sp,-48
    80002878:	f406                	sd	ra,40(sp)
    8000287a:	f022                	sd	s0,32(sp)
    8000287c:	ec26                	sd	s1,24(sp)
    8000287e:	e84a                	sd	s2,16(sp)
    80002880:	e44e                	sd	s3,8(sp)
    80002882:	e052                	sd	s4,0(sp)
    80002884:	1800                	addi	s0,sp,48
    80002886:	84aa                	mv	s1,a0
    80002888:	892e                	mv	s2,a1
    8000288a:	89b2                	mv	s3,a2
    8000288c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000288e:	fffff097          	auipc	ra,0xfffff
    80002892:	442080e7          	jalr	1090(ra) # 80001cd0 <myproc>
  if(user_dst){
    80002896:	c08d                	beqz	s1,800028b8 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002898:	86d2                	mv	a3,s4
    8000289a:	864e                	mv	a2,s3
    8000289c:	85ca                	mv	a1,s2
    8000289e:	6928                	ld	a0,80(a0)
    800028a0:	fffff097          	auipc	ra,0xfffff
    800028a4:	1d4080e7          	jalr	468(ra) # 80001a74 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800028a8:	70a2                	ld	ra,40(sp)
    800028aa:	7402                	ld	s0,32(sp)
    800028ac:	64e2                	ld	s1,24(sp)
    800028ae:	6942                	ld	s2,16(sp)
    800028b0:	69a2                	ld	s3,8(sp)
    800028b2:	6a02                	ld	s4,0(sp)
    800028b4:	6145                	addi	sp,sp,48
    800028b6:	8082                	ret
    memmove((char *)dst, src, len);
    800028b8:	000a061b          	sext.w	a2,s4
    800028bc:	85ce                	mv	a1,s3
    800028be:	854a                	mv	a0,s2
    800028c0:	ffffe097          	auipc	ra,0xffffe
    800028c4:	4ac080e7          	jalr	1196(ra) # 80000d6c <memmove>
    return 0;
    800028c8:	8526                	mv	a0,s1
    800028ca:	bff9                	j	800028a8 <either_copyout+0x32>

00000000800028cc <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800028cc:	7179                	addi	sp,sp,-48
    800028ce:	f406                	sd	ra,40(sp)
    800028d0:	f022                	sd	s0,32(sp)
    800028d2:	ec26                	sd	s1,24(sp)
    800028d4:	e84a                	sd	s2,16(sp)
    800028d6:	e44e                	sd	s3,8(sp)
    800028d8:	e052                	sd	s4,0(sp)
    800028da:	1800                	addi	s0,sp,48
    800028dc:	892a                	mv	s2,a0
    800028de:	84ae                	mv	s1,a1
    800028e0:	89b2                	mv	s3,a2
    800028e2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800028e4:	fffff097          	auipc	ra,0xfffff
    800028e8:	3ec080e7          	jalr	1004(ra) # 80001cd0 <myproc>
  if(user_src){
    800028ec:	c08d                	beqz	s1,8000290e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800028ee:	86d2                	mv	a3,s4
    800028f0:	864e                	mv	a2,s3
    800028f2:	85ca                	mv	a1,s2
    800028f4:	6928                	ld	a0,80(a0)
    800028f6:	fffff097          	auipc	ra,0xfffff
    800028fa:	29e080e7          	jalr	670(ra) # 80001b94 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800028fe:	70a2                	ld	ra,40(sp)
    80002900:	7402                	ld	s0,32(sp)
    80002902:	64e2                	ld	s1,24(sp)
    80002904:	6942                	ld	s2,16(sp)
    80002906:	69a2                	ld	s3,8(sp)
    80002908:	6a02                	ld	s4,0(sp)
    8000290a:	6145                	addi	sp,sp,48
    8000290c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000290e:	000a061b          	sext.w	a2,s4
    80002912:	85ce                	mv	a1,s3
    80002914:	854a                	mv	a0,s2
    80002916:	ffffe097          	auipc	ra,0xffffe
    8000291a:	456080e7          	jalr	1110(ra) # 80000d6c <memmove>
    return 0;
    8000291e:	8526                	mv	a0,s1
    80002920:	bff9                	j	800028fe <either_copyin+0x32>

0000000080002922 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002922:	715d                	addi	sp,sp,-80
    80002924:	e486                	sd	ra,72(sp)
    80002926:	e0a2                	sd	s0,64(sp)
    80002928:	fc26                	sd	s1,56(sp)
    8000292a:	f84a                	sd	s2,48(sp)
    8000292c:	f44e                	sd	s3,40(sp)
    8000292e:	f052                	sd	s4,32(sp)
    80002930:	ec56                	sd	s5,24(sp)
    80002932:	e85a                	sd	s6,16(sp)
    80002934:	e45e                	sd	s7,8(sp)
    80002936:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002938:	00005517          	auipc	a0,0x5
    8000293c:	78050513          	addi	a0,a0,1920 # 800080b8 <digits+0x88>
    80002940:	ffffe097          	auipc	ra,0xffffe
    80002944:	c52080e7          	jalr	-942(ra) # 80000592 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002948:	0000f497          	auipc	s1,0xf
    8000294c:	58048493          	addi	s1,s1,1408 # 80011ec8 <proc+0x160>
    80002950:	00015917          	auipc	s2,0x15
    80002954:	17890913          	addi	s2,s2,376 # 80017ac8 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002958:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    8000295a:	00006997          	auipc	s3,0x6
    8000295e:	9ce98993          	addi	s3,s3,-1586 # 80008328 <digits+0x2f8>
    printf("%d %s %s", p->pid, state, p->name);
    80002962:	00006a97          	auipc	s5,0x6
    80002966:	9cea8a93          	addi	s5,s5,-1586 # 80008330 <digits+0x300>
    printf("\n");
    8000296a:	00005a17          	auipc	s4,0x5
    8000296e:	74ea0a13          	addi	s4,s4,1870 # 800080b8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002972:	00006b97          	auipc	s7,0x6
    80002976:	9f6b8b93          	addi	s7,s7,-1546 # 80008368 <states.1751>
    8000297a:	a00d                	j	8000299c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000297c:	ed86a583          	lw	a1,-296(a3)
    80002980:	8556                	mv	a0,s5
    80002982:	ffffe097          	auipc	ra,0xffffe
    80002986:	c10080e7          	jalr	-1008(ra) # 80000592 <printf>
    printf("\n");
    8000298a:	8552                	mv	a0,s4
    8000298c:	ffffe097          	auipc	ra,0xffffe
    80002990:	c06080e7          	jalr	-1018(ra) # 80000592 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002994:	17048493          	addi	s1,s1,368
    80002998:	03248163          	beq	s1,s2,800029ba <procdump+0x98>
    if(p->state == UNUSED)
    8000299c:	86a6                	mv	a3,s1
    8000299e:	eb84a783          	lw	a5,-328(s1)
    800029a2:	dbed                	beqz	a5,80002994 <procdump+0x72>
      state = "???";
    800029a4:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029a6:	fcfb6be3          	bltu	s6,a5,8000297c <procdump+0x5a>
    800029aa:	1782                	slli	a5,a5,0x20
    800029ac:	9381                	srli	a5,a5,0x20
    800029ae:	078e                	slli	a5,a5,0x3
    800029b0:	97de                	add	a5,a5,s7
    800029b2:	6390                	ld	a2,0(a5)
    800029b4:	f661                	bnez	a2,8000297c <procdump+0x5a>
      state = "???";
    800029b6:	864e                	mv	a2,s3
    800029b8:	b7d1                	j	8000297c <procdump+0x5a>
  }
}
    800029ba:	60a6                	ld	ra,72(sp)
    800029bc:	6406                	ld	s0,64(sp)
    800029be:	74e2                	ld	s1,56(sp)
    800029c0:	7942                	ld	s2,48(sp)
    800029c2:	79a2                	ld	s3,40(sp)
    800029c4:	7a02                	ld	s4,32(sp)
    800029c6:	6ae2                	ld	s5,24(sp)
    800029c8:	6b42                	ld	s6,16(sp)
    800029ca:	6ba2                	ld	s7,8(sp)
    800029cc:	6161                	addi	sp,sp,80
    800029ce:	8082                	ret

00000000800029d0 <swtch>:
    800029d0:	00153023          	sd	ra,0(a0)
    800029d4:	00253423          	sd	sp,8(a0)
    800029d8:	e900                	sd	s0,16(a0)
    800029da:	ed04                	sd	s1,24(a0)
    800029dc:	03253023          	sd	s2,32(a0)
    800029e0:	03353423          	sd	s3,40(a0)
    800029e4:	03453823          	sd	s4,48(a0)
    800029e8:	03553c23          	sd	s5,56(a0)
    800029ec:	05653023          	sd	s6,64(a0)
    800029f0:	05753423          	sd	s7,72(a0)
    800029f4:	05853823          	sd	s8,80(a0)
    800029f8:	05953c23          	sd	s9,88(a0)
    800029fc:	07a53023          	sd	s10,96(a0)
    80002a00:	07b53423          	sd	s11,104(a0)
    80002a04:	0005b083          	ld	ra,0(a1)
    80002a08:	0085b103          	ld	sp,8(a1)
    80002a0c:	6980                	ld	s0,16(a1)
    80002a0e:	6d84                	ld	s1,24(a1)
    80002a10:	0205b903          	ld	s2,32(a1)
    80002a14:	0285b983          	ld	s3,40(a1)
    80002a18:	0305ba03          	ld	s4,48(a1)
    80002a1c:	0385ba83          	ld	s5,56(a1)
    80002a20:	0405bb03          	ld	s6,64(a1)
    80002a24:	0485bb83          	ld	s7,72(a1)
    80002a28:	0505bc03          	ld	s8,80(a1)
    80002a2c:	0585bc83          	ld	s9,88(a1)
    80002a30:	0605bd03          	ld	s10,96(a1)
    80002a34:	0685bd83          	ld	s11,104(a1)
    80002a38:	8082                	ret

0000000080002a3a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002a3a:	1141                	addi	sp,sp,-16
    80002a3c:	e406                	sd	ra,8(sp)
    80002a3e:	e022                	sd	s0,0(sp)
    80002a40:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002a42:	00006597          	auipc	a1,0x6
    80002a46:	94e58593          	addi	a1,a1,-1714 # 80008390 <states.1751+0x28>
    80002a4a:	00015517          	auipc	a0,0x15
    80002a4e:	f1e50513          	addi	a0,a0,-226 # 80017968 <tickslock>
    80002a52:	ffffe097          	auipc	ra,0xffffe
    80002a56:	12e080e7          	jalr	302(ra) # 80000b80 <initlock>
}
    80002a5a:	60a2                	ld	ra,8(sp)
    80002a5c:	6402                	ld	s0,0(sp)
    80002a5e:	0141                	addi	sp,sp,16
    80002a60:	8082                	ret

0000000080002a62 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002a62:	1141                	addi	sp,sp,-16
    80002a64:	e422                	sd	s0,8(sp)
    80002a66:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a68:	00003797          	auipc	a5,0x3
    80002a6c:	4f878793          	addi	a5,a5,1272 # 80005f60 <kernelvec>
    80002a70:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002a74:	6422                	ld	s0,8(sp)
    80002a76:	0141                	addi	sp,sp,16
    80002a78:	8082                	ret

0000000080002a7a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002a7a:	1141                	addi	sp,sp,-16
    80002a7c:	e406                	sd	ra,8(sp)
    80002a7e:	e022                	sd	s0,0(sp)
    80002a80:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002a82:	fffff097          	auipc	ra,0xfffff
    80002a86:	24e080e7          	jalr	590(ra) # 80001cd0 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a8a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002a8e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a90:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002a94:	00004617          	auipc	a2,0x4
    80002a98:	56c60613          	addi	a2,a2,1388 # 80007000 <_trampoline>
    80002a9c:	00004697          	auipc	a3,0x4
    80002aa0:	56468693          	addi	a3,a3,1380 # 80007000 <_trampoline>
    80002aa4:	8e91                	sub	a3,a3,a2
    80002aa6:	040007b7          	lui	a5,0x4000
    80002aaa:	17fd                	addi	a5,a5,-1
    80002aac:	07b2                	slli	a5,a5,0xc
    80002aae:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002ab0:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002ab4:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002ab6:	180026f3          	csrr	a3,satp
    80002aba:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002abc:	7138                	ld	a4,96(a0)
    80002abe:	6134                	ld	a3,64(a0)
    80002ac0:	6585                	lui	a1,0x1
    80002ac2:	96ae                	add	a3,a3,a1
    80002ac4:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002ac6:	7138                	ld	a4,96(a0)
    80002ac8:	00000697          	auipc	a3,0x0
    80002acc:	13868693          	addi	a3,a3,312 # 80002c00 <usertrap>
    80002ad0:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002ad2:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002ad4:	8692                	mv	a3,tp
    80002ad6:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ad8:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002adc:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002ae0:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002ae4:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002ae8:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002aea:	6f18                	ld	a4,24(a4)
    80002aec:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002af0:	692c                	ld	a1,80(a0)
    80002af2:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002af4:	00004717          	auipc	a4,0x4
    80002af8:	59c70713          	addi	a4,a4,1436 # 80007090 <userret>
    80002afc:	8f11                	sub	a4,a4,a2
    80002afe:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002b00:	577d                	li	a4,-1
    80002b02:	177e                	slli	a4,a4,0x3f
    80002b04:	8dd9                	or	a1,a1,a4
    80002b06:	02000537          	lui	a0,0x2000
    80002b0a:	157d                	addi	a0,a0,-1
    80002b0c:	0536                	slli	a0,a0,0xd
    80002b0e:	9782                	jalr	a5
}
    80002b10:	60a2                	ld	ra,8(sp)
    80002b12:	6402                	ld	s0,0(sp)
    80002b14:	0141                	addi	sp,sp,16
    80002b16:	8082                	ret

0000000080002b18 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002b18:	1101                	addi	sp,sp,-32
    80002b1a:	ec06                	sd	ra,24(sp)
    80002b1c:	e822                	sd	s0,16(sp)
    80002b1e:	e426                	sd	s1,8(sp)
    80002b20:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002b22:	00015497          	auipc	s1,0x15
    80002b26:	e4648493          	addi	s1,s1,-442 # 80017968 <tickslock>
    80002b2a:	8526                	mv	a0,s1
    80002b2c:	ffffe097          	auipc	ra,0xffffe
    80002b30:	0e4080e7          	jalr	228(ra) # 80000c10 <acquire>
  ticks++;
    80002b34:	00006517          	auipc	a0,0x6
    80002b38:	4ec50513          	addi	a0,a0,1260 # 80009020 <ticks>
    80002b3c:	411c                	lw	a5,0(a0)
    80002b3e:	2785                	addiw	a5,a5,1
    80002b40:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002b42:	00000097          	auipc	ra,0x0
    80002b46:	c58080e7          	jalr	-936(ra) # 8000279a <wakeup>
  release(&tickslock);
    80002b4a:	8526                	mv	a0,s1
    80002b4c:	ffffe097          	auipc	ra,0xffffe
    80002b50:	178080e7          	jalr	376(ra) # 80000cc4 <release>
}
    80002b54:	60e2                	ld	ra,24(sp)
    80002b56:	6442                	ld	s0,16(sp)
    80002b58:	64a2                	ld	s1,8(sp)
    80002b5a:	6105                	addi	sp,sp,32
    80002b5c:	8082                	ret

0000000080002b5e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002b5e:	1101                	addi	sp,sp,-32
    80002b60:	ec06                	sd	ra,24(sp)
    80002b62:	e822                	sd	s0,16(sp)
    80002b64:	e426                	sd	s1,8(sp)
    80002b66:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b68:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002b6c:	00074d63          	bltz	a4,80002b86 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002b70:	57fd                	li	a5,-1
    80002b72:	17fe                	slli	a5,a5,0x3f
    80002b74:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002b76:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002b78:	06f70363          	beq	a4,a5,80002bde <devintr+0x80>
  }
}
    80002b7c:	60e2                	ld	ra,24(sp)
    80002b7e:	6442                	ld	s0,16(sp)
    80002b80:	64a2                	ld	s1,8(sp)
    80002b82:	6105                	addi	sp,sp,32
    80002b84:	8082                	ret
     (scause & 0xff) == 9){
    80002b86:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002b8a:	46a5                	li	a3,9
    80002b8c:	fed792e3          	bne	a5,a3,80002b70 <devintr+0x12>
    int irq = plic_claim();
    80002b90:	00003097          	auipc	ra,0x3
    80002b94:	4d8080e7          	jalr	1240(ra) # 80006068 <plic_claim>
    80002b98:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002b9a:	47a9                	li	a5,10
    80002b9c:	02f50763          	beq	a0,a5,80002bca <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002ba0:	4785                	li	a5,1
    80002ba2:	02f50963          	beq	a0,a5,80002bd4 <devintr+0x76>
    return 1;
    80002ba6:	4505                	li	a0,1
    } else if(irq){
    80002ba8:	d8f1                	beqz	s1,80002b7c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002baa:	85a6                	mv	a1,s1
    80002bac:	00005517          	auipc	a0,0x5
    80002bb0:	7ec50513          	addi	a0,a0,2028 # 80008398 <states.1751+0x30>
    80002bb4:	ffffe097          	auipc	ra,0xffffe
    80002bb8:	9de080e7          	jalr	-1570(ra) # 80000592 <printf>
      plic_complete(irq);
    80002bbc:	8526                	mv	a0,s1
    80002bbe:	00003097          	auipc	ra,0x3
    80002bc2:	4ce080e7          	jalr	1230(ra) # 8000608c <plic_complete>
    return 1;
    80002bc6:	4505                	li	a0,1
    80002bc8:	bf55                	j	80002b7c <devintr+0x1e>
      uartintr();
    80002bca:	ffffe097          	auipc	ra,0xffffe
    80002bce:	e0a080e7          	jalr	-502(ra) # 800009d4 <uartintr>
    80002bd2:	b7ed                	j	80002bbc <devintr+0x5e>
      virtio_disk_intr();
    80002bd4:	00004097          	auipc	ra,0x4
    80002bd8:	952080e7          	jalr	-1710(ra) # 80006526 <virtio_disk_intr>
    80002bdc:	b7c5                	j	80002bbc <devintr+0x5e>
    if(cpuid() == 0){
    80002bde:	fffff097          	auipc	ra,0xfffff
    80002be2:	0c6080e7          	jalr	198(ra) # 80001ca4 <cpuid>
    80002be6:	c901                	beqz	a0,80002bf6 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002be8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002bec:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002bee:	14479073          	csrw	sip,a5
    return 2;
    80002bf2:	4509                	li	a0,2
    80002bf4:	b761                	j	80002b7c <devintr+0x1e>
      clockintr();
    80002bf6:	00000097          	auipc	ra,0x0
    80002bfa:	f22080e7          	jalr	-222(ra) # 80002b18 <clockintr>
    80002bfe:	b7ed                	j	80002be8 <devintr+0x8a>

0000000080002c00 <usertrap>:
{
    80002c00:	1101                	addi	sp,sp,-32
    80002c02:	ec06                	sd	ra,24(sp)
    80002c04:	e822                	sd	s0,16(sp)
    80002c06:	e426                	sd	s1,8(sp)
    80002c08:	e04a                	sd	s2,0(sp)
    80002c0a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c0c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002c10:	1007f793          	andi	a5,a5,256
    80002c14:	e3ad                	bnez	a5,80002c76 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002c16:	00003797          	auipc	a5,0x3
    80002c1a:	34a78793          	addi	a5,a5,842 # 80005f60 <kernelvec>
    80002c1e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002c22:	fffff097          	auipc	ra,0xfffff
    80002c26:	0ae080e7          	jalr	174(ra) # 80001cd0 <myproc>
    80002c2a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002c2c:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c2e:	14102773          	csrr	a4,sepc
    80002c32:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c34:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002c38:	47a1                	li	a5,8
    80002c3a:	04f71c63          	bne	a4,a5,80002c92 <usertrap+0x92>
    if(p->killed)
    80002c3e:	591c                	lw	a5,48(a0)
    80002c40:	e3b9                	bnez	a5,80002c86 <usertrap+0x86>
    p->trapframe->epc += 4;
    80002c42:	70b8                	ld	a4,96(s1)
    80002c44:	6f1c                	ld	a5,24(a4)
    80002c46:	0791                	addi	a5,a5,4
    80002c48:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c4a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002c4e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c52:	10079073          	csrw	sstatus,a5
    syscall();
    80002c56:	00000097          	auipc	ra,0x0
    80002c5a:	2e0080e7          	jalr	736(ra) # 80002f36 <syscall>
  if(p->killed)
    80002c5e:	589c                	lw	a5,48(s1)
    80002c60:	ebc1                	bnez	a5,80002cf0 <usertrap+0xf0>
  usertrapret();
    80002c62:	00000097          	auipc	ra,0x0
    80002c66:	e18080e7          	jalr	-488(ra) # 80002a7a <usertrapret>
}
    80002c6a:	60e2                	ld	ra,24(sp)
    80002c6c:	6442                	ld	s0,16(sp)
    80002c6e:	64a2                	ld	s1,8(sp)
    80002c70:	6902                	ld	s2,0(sp)
    80002c72:	6105                	addi	sp,sp,32
    80002c74:	8082                	ret
    panic("usertrap: not from user mode");
    80002c76:	00005517          	auipc	a0,0x5
    80002c7a:	74250513          	addi	a0,a0,1858 # 800083b8 <states.1751+0x50>
    80002c7e:	ffffe097          	auipc	ra,0xffffe
    80002c82:	8ca080e7          	jalr	-1846(ra) # 80000548 <panic>
      exit(-1);
    80002c86:	557d                	li	a0,-1
    80002c88:	00000097          	auipc	ra,0x0
    80002c8c:	846080e7          	jalr	-1978(ra) # 800024ce <exit>
    80002c90:	bf4d                	j	80002c42 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002c92:	00000097          	auipc	ra,0x0
    80002c96:	ecc080e7          	jalr	-308(ra) # 80002b5e <devintr>
    80002c9a:	892a                	mv	s2,a0
    80002c9c:	c501                	beqz	a0,80002ca4 <usertrap+0xa4>
  if(p->killed)
    80002c9e:	589c                	lw	a5,48(s1)
    80002ca0:	c3a1                	beqz	a5,80002ce0 <usertrap+0xe0>
    80002ca2:	a815                	j	80002cd6 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ca4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002ca8:	5c90                	lw	a2,56(s1)
    80002caa:	00005517          	auipc	a0,0x5
    80002cae:	72e50513          	addi	a0,a0,1838 # 800083d8 <states.1751+0x70>
    80002cb2:	ffffe097          	auipc	ra,0xffffe
    80002cb6:	8e0080e7          	jalr	-1824(ra) # 80000592 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002cba:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002cbe:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002cc2:	00005517          	auipc	a0,0x5
    80002cc6:	74650513          	addi	a0,a0,1862 # 80008408 <states.1751+0xa0>
    80002cca:	ffffe097          	auipc	ra,0xffffe
    80002cce:	8c8080e7          	jalr	-1848(ra) # 80000592 <printf>
    p->killed = 1;
    80002cd2:	4785                	li	a5,1
    80002cd4:	d89c                	sw	a5,48(s1)
    exit(-1);
    80002cd6:	557d                	li	a0,-1
    80002cd8:	fffff097          	auipc	ra,0xfffff
    80002cdc:	7f6080e7          	jalr	2038(ra) # 800024ce <exit>
  if(which_dev == 2)
    80002ce0:	4789                	li	a5,2
    80002ce2:	f8f910e3          	bne	s2,a5,80002c62 <usertrap+0x62>
    yield();
    80002ce6:	00000097          	auipc	ra,0x0
    80002cea:	8f2080e7          	jalr	-1806(ra) # 800025d8 <yield>
    80002cee:	bf95                	j	80002c62 <usertrap+0x62>
  int which_dev = 0;
    80002cf0:	4901                	li	s2,0
    80002cf2:	b7d5                	j	80002cd6 <usertrap+0xd6>

0000000080002cf4 <kerneltrap>:
{
    80002cf4:	7179                	addi	sp,sp,-48
    80002cf6:	f406                	sd	ra,40(sp)
    80002cf8:	f022                	sd	s0,32(sp)
    80002cfa:	ec26                	sd	s1,24(sp)
    80002cfc:	e84a                	sd	s2,16(sp)
    80002cfe:	e44e                	sd	s3,8(sp)
    80002d00:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d02:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d06:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d0a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002d0e:	1004f793          	andi	a5,s1,256
    80002d12:	cb85                	beqz	a5,80002d42 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d14:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002d18:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002d1a:	ef85                	bnez	a5,80002d52 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002d1c:	00000097          	auipc	ra,0x0
    80002d20:	e42080e7          	jalr	-446(ra) # 80002b5e <devintr>
    80002d24:	cd1d                	beqz	a0,80002d62 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002d26:	4789                	li	a5,2
    80002d28:	06f50a63          	beq	a0,a5,80002d9c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002d2c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d30:	10049073          	csrw	sstatus,s1
}
    80002d34:	70a2                	ld	ra,40(sp)
    80002d36:	7402                	ld	s0,32(sp)
    80002d38:	64e2                	ld	s1,24(sp)
    80002d3a:	6942                	ld	s2,16(sp)
    80002d3c:	69a2                	ld	s3,8(sp)
    80002d3e:	6145                	addi	sp,sp,48
    80002d40:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002d42:	00005517          	auipc	a0,0x5
    80002d46:	6e650513          	addi	a0,a0,1766 # 80008428 <states.1751+0xc0>
    80002d4a:	ffffd097          	auipc	ra,0xffffd
    80002d4e:	7fe080e7          	jalr	2046(ra) # 80000548 <panic>
    panic("kerneltrap: interrupts enabled");
    80002d52:	00005517          	auipc	a0,0x5
    80002d56:	6fe50513          	addi	a0,a0,1790 # 80008450 <states.1751+0xe8>
    80002d5a:	ffffd097          	auipc	ra,0xffffd
    80002d5e:	7ee080e7          	jalr	2030(ra) # 80000548 <panic>
    printf("scause %p\n", scause);
    80002d62:	85ce                	mv	a1,s3
    80002d64:	00005517          	auipc	a0,0x5
    80002d68:	70c50513          	addi	a0,a0,1804 # 80008470 <states.1751+0x108>
    80002d6c:	ffffe097          	auipc	ra,0xffffe
    80002d70:	826080e7          	jalr	-2010(ra) # 80000592 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d74:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002d78:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002d7c:	00005517          	auipc	a0,0x5
    80002d80:	70450513          	addi	a0,a0,1796 # 80008480 <states.1751+0x118>
    80002d84:	ffffe097          	auipc	ra,0xffffe
    80002d88:	80e080e7          	jalr	-2034(ra) # 80000592 <printf>
    panic("kerneltrap");
    80002d8c:	00005517          	auipc	a0,0x5
    80002d90:	70c50513          	addi	a0,a0,1804 # 80008498 <states.1751+0x130>
    80002d94:	ffffd097          	auipc	ra,0xffffd
    80002d98:	7b4080e7          	jalr	1972(ra) # 80000548 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002d9c:	fffff097          	auipc	ra,0xfffff
    80002da0:	f34080e7          	jalr	-204(ra) # 80001cd0 <myproc>
    80002da4:	d541                	beqz	a0,80002d2c <kerneltrap+0x38>
    80002da6:	fffff097          	auipc	ra,0xfffff
    80002daa:	f2a080e7          	jalr	-214(ra) # 80001cd0 <myproc>
    80002dae:	4d18                	lw	a4,24(a0)
    80002db0:	478d                	li	a5,3
    80002db2:	f6f71de3          	bne	a4,a5,80002d2c <kerneltrap+0x38>
    yield();
    80002db6:	00000097          	auipc	ra,0x0
    80002dba:	822080e7          	jalr	-2014(ra) # 800025d8 <yield>
    80002dbe:	b7bd                	j	80002d2c <kerneltrap+0x38>

0000000080002dc0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002dc0:	1101                	addi	sp,sp,-32
    80002dc2:	ec06                	sd	ra,24(sp)
    80002dc4:	e822                	sd	s0,16(sp)
    80002dc6:	e426                	sd	s1,8(sp)
    80002dc8:	1000                	addi	s0,sp,32
    80002dca:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002dcc:	fffff097          	auipc	ra,0xfffff
    80002dd0:	f04080e7          	jalr	-252(ra) # 80001cd0 <myproc>
  switch (n) {
    80002dd4:	4795                	li	a5,5
    80002dd6:	0497e163          	bltu	a5,s1,80002e18 <argraw+0x58>
    80002dda:	048a                	slli	s1,s1,0x2
    80002ddc:	00005717          	auipc	a4,0x5
    80002de0:	6f470713          	addi	a4,a4,1780 # 800084d0 <states.1751+0x168>
    80002de4:	94ba                	add	s1,s1,a4
    80002de6:	409c                	lw	a5,0(s1)
    80002de8:	97ba                	add	a5,a5,a4
    80002dea:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002dec:	713c                	ld	a5,96(a0)
    80002dee:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002df0:	60e2                	ld	ra,24(sp)
    80002df2:	6442                	ld	s0,16(sp)
    80002df4:	64a2                	ld	s1,8(sp)
    80002df6:	6105                	addi	sp,sp,32
    80002df8:	8082                	ret
    return p->trapframe->a1;
    80002dfa:	713c                	ld	a5,96(a0)
    80002dfc:	7fa8                	ld	a0,120(a5)
    80002dfe:	bfcd                	j	80002df0 <argraw+0x30>
    return p->trapframe->a2;
    80002e00:	713c                	ld	a5,96(a0)
    80002e02:	63c8                	ld	a0,128(a5)
    80002e04:	b7f5                	j	80002df0 <argraw+0x30>
    return p->trapframe->a3;
    80002e06:	713c                	ld	a5,96(a0)
    80002e08:	67c8                	ld	a0,136(a5)
    80002e0a:	b7dd                	j	80002df0 <argraw+0x30>
    return p->trapframe->a4;
    80002e0c:	713c                	ld	a5,96(a0)
    80002e0e:	6bc8                	ld	a0,144(a5)
    80002e10:	b7c5                	j	80002df0 <argraw+0x30>
    return p->trapframe->a5;
    80002e12:	713c                	ld	a5,96(a0)
    80002e14:	6fc8                	ld	a0,152(a5)
    80002e16:	bfe9                	j	80002df0 <argraw+0x30>
  panic("argraw");
    80002e18:	00005517          	auipc	a0,0x5
    80002e1c:	69050513          	addi	a0,a0,1680 # 800084a8 <states.1751+0x140>
    80002e20:	ffffd097          	auipc	ra,0xffffd
    80002e24:	728080e7          	jalr	1832(ra) # 80000548 <panic>

0000000080002e28 <fetchaddr>:
{
    80002e28:	1101                	addi	sp,sp,-32
    80002e2a:	ec06                	sd	ra,24(sp)
    80002e2c:	e822                	sd	s0,16(sp)
    80002e2e:	e426                	sd	s1,8(sp)
    80002e30:	e04a                	sd	s2,0(sp)
    80002e32:	1000                	addi	s0,sp,32
    80002e34:	84aa                	mv	s1,a0
    80002e36:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002e38:	fffff097          	auipc	ra,0xfffff
    80002e3c:	e98080e7          	jalr	-360(ra) # 80001cd0 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002e40:	653c                	ld	a5,72(a0)
    80002e42:	02f4f863          	bgeu	s1,a5,80002e72 <fetchaddr+0x4a>
    80002e46:	00848713          	addi	a4,s1,8
    80002e4a:	02e7e663          	bltu	a5,a4,80002e76 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002e4e:	46a1                	li	a3,8
    80002e50:	8626                	mv	a2,s1
    80002e52:	85ca                	mv	a1,s2
    80002e54:	6928                	ld	a0,80(a0)
    80002e56:	fffff097          	auipc	ra,0xfffff
    80002e5a:	d3e080e7          	jalr	-706(ra) # 80001b94 <copyin>
    80002e5e:	00a03533          	snez	a0,a0
    80002e62:	40a00533          	neg	a0,a0
}
    80002e66:	60e2                	ld	ra,24(sp)
    80002e68:	6442                	ld	s0,16(sp)
    80002e6a:	64a2                	ld	s1,8(sp)
    80002e6c:	6902                	ld	s2,0(sp)
    80002e6e:	6105                	addi	sp,sp,32
    80002e70:	8082                	ret
    return -1;
    80002e72:	557d                	li	a0,-1
    80002e74:	bfcd                	j	80002e66 <fetchaddr+0x3e>
    80002e76:	557d                	li	a0,-1
    80002e78:	b7fd                	j	80002e66 <fetchaddr+0x3e>

0000000080002e7a <fetchstr>:
{
    80002e7a:	7179                	addi	sp,sp,-48
    80002e7c:	f406                	sd	ra,40(sp)
    80002e7e:	f022                	sd	s0,32(sp)
    80002e80:	ec26                	sd	s1,24(sp)
    80002e82:	e84a                	sd	s2,16(sp)
    80002e84:	e44e                	sd	s3,8(sp)
    80002e86:	1800                	addi	s0,sp,48
    80002e88:	892a                	mv	s2,a0
    80002e8a:	84ae                	mv	s1,a1
    80002e8c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002e8e:	fffff097          	auipc	ra,0xfffff
    80002e92:	e42080e7          	jalr	-446(ra) # 80001cd0 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002e96:	86ce                	mv	a3,s3
    80002e98:	864a                	mv	a2,s2
    80002e9a:	85a6                	mv	a1,s1
    80002e9c:	6928                	ld	a0,80(a0)
    80002e9e:	fffff097          	auipc	ra,0xfffff
    80002ea2:	d0e080e7          	jalr	-754(ra) # 80001bac <copyinstr>
  if(err < 0)
    80002ea6:	00054763          	bltz	a0,80002eb4 <fetchstr+0x3a>
  return strlen(buf);
    80002eaa:	8526                	mv	a0,s1
    80002eac:	ffffe097          	auipc	ra,0xffffe
    80002eb0:	fe8080e7          	jalr	-24(ra) # 80000e94 <strlen>
}
    80002eb4:	70a2                	ld	ra,40(sp)
    80002eb6:	7402                	ld	s0,32(sp)
    80002eb8:	64e2                	ld	s1,24(sp)
    80002eba:	6942                	ld	s2,16(sp)
    80002ebc:	69a2                	ld	s3,8(sp)
    80002ebe:	6145                	addi	sp,sp,48
    80002ec0:	8082                	ret

0000000080002ec2 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002ec2:	1101                	addi	sp,sp,-32
    80002ec4:	ec06                	sd	ra,24(sp)
    80002ec6:	e822                	sd	s0,16(sp)
    80002ec8:	e426                	sd	s1,8(sp)
    80002eca:	1000                	addi	s0,sp,32
    80002ecc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002ece:	00000097          	auipc	ra,0x0
    80002ed2:	ef2080e7          	jalr	-270(ra) # 80002dc0 <argraw>
    80002ed6:	c088                	sw	a0,0(s1)
  return 0;
}
    80002ed8:	4501                	li	a0,0
    80002eda:	60e2                	ld	ra,24(sp)
    80002edc:	6442                	ld	s0,16(sp)
    80002ede:	64a2                	ld	s1,8(sp)
    80002ee0:	6105                	addi	sp,sp,32
    80002ee2:	8082                	ret

0000000080002ee4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002ee4:	1101                	addi	sp,sp,-32
    80002ee6:	ec06                	sd	ra,24(sp)
    80002ee8:	e822                	sd	s0,16(sp)
    80002eea:	e426                	sd	s1,8(sp)
    80002eec:	1000                	addi	s0,sp,32
    80002eee:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002ef0:	00000097          	auipc	ra,0x0
    80002ef4:	ed0080e7          	jalr	-304(ra) # 80002dc0 <argraw>
    80002ef8:	e088                	sd	a0,0(s1)
  return 0;
}
    80002efa:	4501                	li	a0,0
    80002efc:	60e2                	ld	ra,24(sp)
    80002efe:	6442                	ld	s0,16(sp)
    80002f00:	64a2                	ld	s1,8(sp)
    80002f02:	6105                	addi	sp,sp,32
    80002f04:	8082                	ret

0000000080002f06 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002f06:	1101                	addi	sp,sp,-32
    80002f08:	ec06                	sd	ra,24(sp)
    80002f0a:	e822                	sd	s0,16(sp)
    80002f0c:	e426                	sd	s1,8(sp)
    80002f0e:	e04a                	sd	s2,0(sp)
    80002f10:	1000                	addi	s0,sp,32
    80002f12:	84ae                	mv	s1,a1
    80002f14:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002f16:	00000097          	auipc	ra,0x0
    80002f1a:	eaa080e7          	jalr	-342(ra) # 80002dc0 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002f1e:	864a                	mv	a2,s2
    80002f20:	85a6                	mv	a1,s1
    80002f22:	00000097          	auipc	ra,0x0
    80002f26:	f58080e7          	jalr	-168(ra) # 80002e7a <fetchstr>
}
    80002f2a:	60e2                	ld	ra,24(sp)
    80002f2c:	6442                	ld	s0,16(sp)
    80002f2e:	64a2                	ld	s1,8(sp)
    80002f30:	6902                	ld	s2,0(sp)
    80002f32:	6105                	addi	sp,sp,32
    80002f34:	8082                	ret

0000000080002f36 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002f36:	1101                	addi	sp,sp,-32
    80002f38:	ec06                	sd	ra,24(sp)
    80002f3a:	e822                	sd	s0,16(sp)
    80002f3c:	e426                	sd	s1,8(sp)
    80002f3e:	e04a                	sd	s2,0(sp)
    80002f40:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002f42:	fffff097          	auipc	ra,0xfffff
    80002f46:	d8e080e7          	jalr	-626(ra) # 80001cd0 <myproc>
    80002f4a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002f4c:	06053903          	ld	s2,96(a0)
    80002f50:	0a893783          	ld	a5,168(s2)
    80002f54:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002f58:	37fd                	addiw	a5,a5,-1
    80002f5a:	4751                	li	a4,20
    80002f5c:	00f76f63          	bltu	a4,a5,80002f7a <syscall+0x44>
    80002f60:	00369713          	slli	a4,a3,0x3
    80002f64:	00005797          	auipc	a5,0x5
    80002f68:	58478793          	addi	a5,a5,1412 # 800084e8 <syscalls>
    80002f6c:	97ba                	add	a5,a5,a4
    80002f6e:	639c                	ld	a5,0(a5)
    80002f70:	c789                	beqz	a5,80002f7a <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002f72:	9782                	jalr	a5
    80002f74:	06a93823          	sd	a0,112(s2)
    80002f78:	a839                	j	80002f96 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002f7a:	16048613          	addi	a2,s1,352
    80002f7e:	5c8c                	lw	a1,56(s1)
    80002f80:	00005517          	auipc	a0,0x5
    80002f84:	53050513          	addi	a0,a0,1328 # 800084b0 <states.1751+0x148>
    80002f88:	ffffd097          	auipc	ra,0xffffd
    80002f8c:	60a080e7          	jalr	1546(ra) # 80000592 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002f90:	70bc                	ld	a5,96(s1)
    80002f92:	577d                	li	a4,-1
    80002f94:	fbb8                	sd	a4,112(a5)
  }
}
    80002f96:	60e2                	ld	ra,24(sp)
    80002f98:	6442                	ld	s0,16(sp)
    80002f9a:	64a2                	ld	s1,8(sp)
    80002f9c:	6902                	ld	s2,0(sp)
    80002f9e:	6105                	addi	sp,sp,32
    80002fa0:	8082                	ret

0000000080002fa2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002fa2:	1101                	addi	sp,sp,-32
    80002fa4:	ec06                	sd	ra,24(sp)
    80002fa6:	e822                	sd	s0,16(sp)
    80002fa8:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002faa:	fec40593          	addi	a1,s0,-20
    80002fae:	4501                	li	a0,0
    80002fb0:	00000097          	auipc	ra,0x0
    80002fb4:	f12080e7          	jalr	-238(ra) # 80002ec2 <argint>
    return -1;
    80002fb8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002fba:	00054963          	bltz	a0,80002fcc <sys_exit+0x2a>
  exit(n);
    80002fbe:	fec42503          	lw	a0,-20(s0)
    80002fc2:	fffff097          	auipc	ra,0xfffff
    80002fc6:	50c080e7          	jalr	1292(ra) # 800024ce <exit>
  return 0;  // not reached
    80002fca:	4781                	li	a5,0
}
    80002fcc:	853e                	mv	a0,a5
    80002fce:	60e2                	ld	ra,24(sp)
    80002fd0:	6442                	ld	s0,16(sp)
    80002fd2:	6105                	addi	sp,sp,32
    80002fd4:	8082                	ret

0000000080002fd6 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002fd6:	1141                	addi	sp,sp,-16
    80002fd8:	e406                	sd	ra,8(sp)
    80002fda:	e022                	sd	s0,0(sp)
    80002fdc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002fde:	fffff097          	auipc	ra,0xfffff
    80002fe2:	cf2080e7          	jalr	-782(ra) # 80001cd0 <myproc>
}
    80002fe6:	5d08                	lw	a0,56(a0)
    80002fe8:	60a2                	ld	ra,8(sp)
    80002fea:	6402                	ld	s0,0(sp)
    80002fec:	0141                	addi	sp,sp,16
    80002fee:	8082                	ret

0000000080002ff0 <sys_fork>:

uint64
sys_fork(void)
{
    80002ff0:	1141                	addi	sp,sp,-16
    80002ff2:	e406                	sd	ra,8(sp)
    80002ff4:	e022                	sd	s0,0(sp)
    80002ff6:	0800                	addi	s0,sp,16
  return fork();
    80002ff8:	fffff097          	auipc	ra,0xfffff
    80002ffc:	178080e7          	jalr	376(ra) # 80002170 <fork>
}
    80003000:	60a2                	ld	ra,8(sp)
    80003002:	6402                	ld	s0,0(sp)
    80003004:	0141                	addi	sp,sp,16
    80003006:	8082                	ret

0000000080003008 <sys_wait>:

uint64
sys_wait(void)
{
    80003008:	1101                	addi	sp,sp,-32
    8000300a:	ec06                	sd	ra,24(sp)
    8000300c:	e822                	sd	s0,16(sp)
    8000300e:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80003010:	fe840593          	addi	a1,s0,-24
    80003014:	4501                	li	a0,0
    80003016:	00000097          	auipc	ra,0x0
    8000301a:	ece080e7          	jalr	-306(ra) # 80002ee4 <argaddr>
    8000301e:	87aa                	mv	a5,a0
    return -1;
    80003020:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80003022:	0007c863          	bltz	a5,80003032 <sys_wait+0x2a>
  return wait(p);
    80003026:	fe843503          	ld	a0,-24(s0)
    8000302a:	fffff097          	auipc	ra,0xfffff
    8000302e:	668080e7          	jalr	1640(ra) # 80002692 <wait>
}
    80003032:	60e2                	ld	ra,24(sp)
    80003034:	6442                	ld	s0,16(sp)
    80003036:	6105                	addi	sp,sp,32
    80003038:	8082                	ret

000000008000303a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000303a:	7179                	addi	sp,sp,-48
    8000303c:	f406                	sd	ra,40(sp)
    8000303e:	f022                	sd	s0,32(sp)
    80003040:	ec26                	sd	s1,24(sp)
    80003042:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80003044:	fdc40593          	addi	a1,s0,-36
    80003048:	4501                	li	a0,0
    8000304a:	00000097          	auipc	ra,0x0
    8000304e:	e78080e7          	jalr	-392(ra) # 80002ec2 <argint>
    80003052:	87aa                	mv	a5,a0
    return -1;
    80003054:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80003056:	0207c063          	bltz	a5,80003076 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000305a:	fffff097          	auipc	ra,0xfffff
    8000305e:	c76080e7          	jalr	-906(ra) # 80001cd0 <myproc>
    80003062:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80003064:	fdc42503          	lw	a0,-36(s0)
    80003068:	fffff097          	auipc	ra,0xfffff
    8000306c:	046080e7          	jalr	70(ra) # 800020ae <growproc>
    80003070:	00054863          	bltz	a0,80003080 <sys_sbrk+0x46>
    return -1;
  return addr;
    80003074:	8526                	mv	a0,s1
}
    80003076:	70a2                	ld	ra,40(sp)
    80003078:	7402                	ld	s0,32(sp)
    8000307a:	64e2                	ld	s1,24(sp)
    8000307c:	6145                	addi	sp,sp,48
    8000307e:	8082                	ret
    return -1;
    80003080:	557d                	li	a0,-1
    80003082:	bfd5                	j	80003076 <sys_sbrk+0x3c>

0000000080003084 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003084:	7139                	addi	sp,sp,-64
    80003086:	fc06                	sd	ra,56(sp)
    80003088:	f822                	sd	s0,48(sp)
    8000308a:	f426                	sd	s1,40(sp)
    8000308c:	f04a                	sd	s2,32(sp)
    8000308e:	ec4e                	sd	s3,24(sp)
    80003090:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80003092:	fcc40593          	addi	a1,s0,-52
    80003096:	4501                	li	a0,0
    80003098:	00000097          	auipc	ra,0x0
    8000309c:	e2a080e7          	jalr	-470(ra) # 80002ec2 <argint>
    return -1;
    800030a0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800030a2:	06054563          	bltz	a0,8000310c <sys_sleep+0x88>
  acquire(&tickslock);
    800030a6:	00015517          	auipc	a0,0x15
    800030aa:	8c250513          	addi	a0,a0,-1854 # 80017968 <tickslock>
    800030ae:	ffffe097          	auipc	ra,0xffffe
    800030b2:	b62080e7          	jalr	-1182(ra) # 80000c10 <acquire>
  ticks0 = ticks;
    800030b6:	00006917          	auipc	s2,0x6
    800030ba:	f6a92903          	lw	s2,-150(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    800030be:	fcc42783          	lw	a5,-52(s0)
    800030c2:	cf85                	beqz	a5,800030fa <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800030c4:	00015997          	auipc	s3,0x15
    800030c8:	8a498993          	addi	s3,s3,-1884 # 80017968 <tickslock>
    800030cc:	00006497          	auipc	s1,0x6
    800030d0:	f5448493          	addi	s1,s1,-172 # 80009020 <ticks>
    if(myproc()->killed){
    800030d4:	fffff097          	auipc	ra,0xfffff
    800030d8:	bfc080e7          	jalr	-1028(ra) # 80001cd0 <myproc>
    800030dc:	591c                	lw	a5,48(a0)
    800030de:	ef9d                	bnez	a5,8000311c <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800030e0:	85ce                	mv	a1,s3
    800030e2:	8526                	mv	a0,s1
    800030e4:	fffff097          	auipc	ra,0xfffff
    800030e8:	530080e7          	jalr	1328(ra) # 80002614 <sleep>
  while(ticks - ticks0 < n){
    800030ec:	409c                	lw	a5,0(s1)
    800030ee:	412787bb          	subw	a5,a5,s2
    800030f2:	fcc42703          	lw	a4,-52(s0)
    800030f6:	fce7efe3          	bltu	a5,a4,800030d4 <sys_sleep+0x50>
  }
  release(&tickslock);
    800030fa:	00015517          	auipc	a0,0x15
    800030fe:	86e50513          	addi	a0,a0,-1938 # 80017968 <tickslock>
    80003102:	ffffe097          	auipc	ra,0xffffe
    80003106:	bc2080e7          	jalr	-1086(ra) # 80000cc4 <release>
  return 0;
    8000310a:	4781                	li	a5,0
}
    8000310c:	853e                	mv	a0,a5
    8000310e:	70e2                	ld	ra,56(sp)
    80003110:	7442                	ld	s0,48(sp)
    80003112:	74a2                	ld	s1,40(sp)
    80003114:	7902                	ld	s2,32(sp)
    80003116:	69e2                	ld	s3,24(sp)
    80003118:	6121                	addi	sp,sp,64
    8000311a:	8082                	ret
      release(&tickslock);
    8000311c:	00015517          	auipc	a0,0x15
    80003120:	84c50513          	addi	a0,a0,-1972 # 80017968 <tickslock>
    80003124:	ffffe097          	auipc	ra,0xffffe
    80003128:	ba0080e7          	jalr	-1120(ra) # 80000cc4 <release>
      return -1;
    8000312c:	57fd                	li	a5,-1
    8000312e:	bff9                	j	8000310c <sys_sleep+0x88>

0000000080003130 <sys_kill>:

uint64
sys_kill(void)
{
    80003130:	1101                	addi	sp,sp,-32
    80003132:	ec06                	sd	ra,24(sp)
    80003134:	e822                	sd	s0,16(sp)
    80003136:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80003138:	fec40593          	addi	a1,s0,-20
    8000313c:	4501                	li	a0,0
    8000313e:	00000097          	auipc	ra,0x0
    80003142:	d84080e7          	jalr	-636(ra) # 80002ec2 <argint>
    80003146:	87aa                	mv	a5,a0
    return -1;
    80003148:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000314a:	0007c863          	bltz	a5,8000315a <sys_kill+0x2a>
  return kill(pid);
    8000314e:	fec42503          	lw	a0,-20(s0)
    80003152:	fffff097          	auipc	ra,0xfffff
    80003156:	6b2080e7          	jalr	1714(ra) # 80002804 <kill>
}
    8000315a:	60e2                	ld	ra,24(sp)
    8000315c:	6442                	ld	s0,16(sp)
    8000315e:	6105                	addi	sp,sp,32
    80003160:	8082                	ret

0000000080003162 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003162:	1101                	addi	sp,sp,-32
    80003164:	ec06                	sd	ra,24(sp)
    80003166:	e822                	sd	s0,16(sp)
    80003168:	e426                	sd	s1,8(sp)
    8000316a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000316c:	00014517          	auipc	a0,0x14
    80003170:	7fc50513          	addi	a0,a0,2044 # 80017968 <tickslock>
    80003174:	ffffe097          	auipc	ra,0xffffe
    80003178:	a9c080e7          	jalr	-1380(ra) # 80000c10 <acquire>
  xticks = ticks;
    8000317c:	00006497          	auipc	s1,0x6
    80003180:	ea44a483          	lw	s1,-348(s1) # 80009020 <ticks>
  release(&tickslock);
    80003184:	00014517          	auipc	a0,0x14
    80003188:	7e450513          	addi	a0,a0,2020 # 80017968 <tickslock>
    8000318c:	ffffe097          	auipc	ra,0xffffe
    80003190:	b38080e7          	jalr	-1224(ra) # 80000cc4 <release>
  return xticks;
}
    80003194:	02049513          	slli	a0,s1,0x20
    80003198:	9101                	srli	a0,a0,0x20
    8000319a:	60e2                	ld	ra,24(sp)
    8000319c:	6442                	ld	s0,16(sp)
    8000319e:	64a2                	ld	s1,8(sp)
    800031a0:	6105                	addi	sp,sp,32
    800031a2:	8082                	ret

00000000800031a4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800031a4:	7179                	addi	sp,sp,-48
    800031a6:	f406                	sd	ra,40(sp)
    800031a8:	f022                	sd	s0,32(sp)
    800031aa:	ec26                	sd	s1,24(sp)
    800031ac:	e84a                	sd	s2,16(sp)
    800031ae:	e44e                	sd	s3,8(sp)
    800031b0:	e052                	sd	s4,0(sp)
    800031b2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800031b4:	00005597          	auipc	a1,0x5
    800031b8:	3e458593          	addi	a1,a1,996 # 80008598 <syscalls+0xb0>
    800031bc:	00014517          	auipc	a0,0x14
    800031c0:	7c450513          	addi	a0,a0,1988 # 80017980 <bcache>
    800031c4:	ffffe097          	auipc	ra,0xffffe
    800031c8:	9bc080e7          	jalr	-1604(ra) # 80000b80 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800031cc:	0001c797          	auipc	a5,0x1c
    800031d0:	7b478793          	addi	a5,a5,1972 # 8001f980 <bcache+0x8000>
    800031d4:	0001d717          	auipc	a4,0x1d
    800031d8:	a1470713          	addi	a4,a4,-1516 # 8001fbe8 <bcache+0x8268>
    800031dc:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800031e0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800031e4:	00014497          	auipc	s1,0x14
    800031e8:	7b448493          	addi	s1,s1,1972 # 80017998 <bcache+0x18>
    b->next = bcache.head.next;
    800031ec:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800031ee:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800031f0:	00005a17          	auipc	s4,0x5
    800031f4:	3b0a0a13          	addi	s4,s4,944 # 800085a0 <syscalls+0xb8>
    b->next = bcache.head.next;
    800031f8:	2b893783          	ld	a5,696(s2)
    800031fc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800031fe:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003202:	85d2                	mv	a1,s4
    80003204:	01048513          	addi	a0,s1,16
    80003208:	00001097          	auipc	ra,0x1
    8000320c:	4ac080e7          	jalr	1196(ra) # 800046b4 <initsleeplock>
    bcache.head.next->prev = b;
    80003210:	2b893783          	ld	a5,696(s2)
    80003214:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003216:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000321a:	45848493          	addi	s1,s1,1112
    8000321e:	fd349de3          	bne	s1,s3,800031f8 <binit+0x54>
  }
}
    80003222:	70a2                	ld	ra,40(sp)
    80003224:	7402                	ld	s0,32(sp)
    80003226:	64e2                	ld	s1,24(sp)
    80003228:	6942                	ld	s2,16(sp)
    8000322a:	69a2                	ld	s3,8(sp)
    8000322c:	6a02                	ld	s4,0(sp)
    8000322e:	6145                	addi	sp,sp,48
    80003230:	8082                	ret

0000000080003232 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003232:	7179                	addi	sp,sp,-48
    80003234:	f406                	sd	ra,40(sp)
    80003236:	f022                	sd	s0,32(sp)
    80003238:	ec26                	sd	s1,24(sp)
    8000323a:	e84a                	sd	s2,16(sp)
    8000323c:	e44e                	sd	s3,8(sp)
    8000323e:	1800                	addi	s0,sp,48
    80003240:	89aa                	mv	s3,a0
    80003242:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80003244:	00014517          	auipc	a0,0x14
    80003248:	73c50513          	addi	a0,a0,1852 # 80017980 <bcache>
    8000324c:	ffffe097          	auipc	ra,0xffffe
    80003250:	9c4080e7          	jalr	-1596(ra) # 80000c10 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003254:	0001d497          	auipc	s1,0x1d
    80003258:	9e44b483          	ld	s1,-1564(s1) # 8001fc38 <bcache+0x82b8>
    8000325c:	0001d797          	auipc	a5,0x1d
    80003260:	98c78793          	addi	a5,a5,-1652 # 8001fbe8 <bcache+0x8268>
    80003264:	02f48f63          	beq	s1,a5,800032a2 <bread+0x70>
    80003268:	873e                	mv	a4,a5
    8000326a:	a021                	j	80003272 <bread+0x40>
    8000326c:	68a4                	ld	s1,80(s1)
    8000326e:	02e48a63          	beq	s1,a4,800032a2 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003272:	449c                	lw	a5,8(s1)
    80003274:	ff379ce3          	bne	a5,s3,8000326c <bread+0x3a>
    80003278:	44dc                	lw	a5,12(s1)
    8000327a:	ff2799e3          	bne	a5,s2,8000326c <bread+0x3a>
      b->refcnt++;
    8000327e:	40bc                	lw	a5,64(s1)
    80003280:	2785                	addiw	a5,a5,1
    80003282:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003284:	00014517          	auipc	a0,0x14
    80003288:	6fc50513          	addi	a0,a0,1788 # 80017980 <bcache>
    8000328c:	ffffe097          	auipc	ra,0xffffe
    80003290:	a38080e7          	jalr	-1480(ra) # 80000cc4 <release>
      acquiresleep(&b->lock);
    80003294:	01048513          	addi	a0,s1,16
    80003298:	00001097          	auipc	ra,0x1
    8000329c:	456080e7          	jalr	1110(ra) # 800046ee <acquiresleep>
      return b;
    800032a0:	a8b9                	j	800032fe <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800032a2:	0001d497          	auipc	s1,0x1d
    800032a6:	98e4b483          	ld	s1,-1650(s1) # 8001fc30 <bcache+0x82b0>
    800032aa:	0001d797          	auipc	a5,0x1d
    800032ae:	93e78793          	addi	a5,a5,-1730 # 8001fbe8 <bcache+0x8268>
    800032b2:	00f48863          	beq	s1,a5,800032c2 <bread+0x90>
    800032b6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800032b8:	40bc                	lw	a5,64(s1)
    800032ba:	cf81                	beqz	a5,800032d2 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800032bc:	64a4                	ld	s1,72(s1)
    800032be:	fee49de3          	bne	s1,a4,800032b8 <bread+0x86>
  panic("bget: no buffers");
    800032c2:	00005517          	auipc	a0,0x5
    800032c6:	2e650513          	addi	a0,a0,742 # 800085a8 <syscalls+0xc0>
    800032ca:	ffffd097          	auipc	ra,0xffffd
    800032ce:	27e080e7          	jalr	638(ra) # 80000548 <panic>
      b->dev = dev;
    800032d2:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800032d6:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800032da:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800032de:	4785                	li	a5,1
    800032e0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800032e2:	00014517          	auipc	a0,0x14
    800032e6:	69e50513          	addi	a0,a0,1694 # 80017980 <bcache>
    800032ea:	ffffe097          	auipc	ra,0xffffe
    800032ee:	9da080e7          	jalr	-1574(ra) # 80000cc4 <release>
      acquiresleep(&b->lock);
    800032f2:	01048513          	addi	a0,s1,16
    800032f6:	00001097          	auipc	ra,0x1
    800032fa:	3f8080e7          	jalr	1016(ra) # 800046ee <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800032fe:	409c                	lw	a5,0(s1)
    80003300:	cb89                	beqz	a5,80003312 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003302:	8526                	mv	a0,s1
    80003304:	70a2                	ld	ra,40(sp)
    80003306:	7402                	ld	s0,32(sp)
    80003308:	64e2                	ld	s1,24(sp)
    8000330a:	6942                	ld	s2,16(sp)
    8000330c:	69a2                	ld	s3,8(sp)
    8000330e:	6145                	addi	sp,sp,48
    80003310:	8082                	ret
    virtio_disk_rw(b, 0);
    80003312:	4581                	li	a1,0
    80003314:	8526                	mv	a0,s1
    80003316:	00003097          	auipc	ra,0x3
    8000331a:	f66080e7          	jalr	-154(ra) # 8000627c <virtio_disk_rw>
    b->valid = 1;
    8000331e:	4785                	li	a5,1
    80003320:	c09c                	sw	a5,0(s1)
  return b;
    80003322:	b7c5                	j	80003302 <bread+0xd0>

0000000080003324 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003324:	1101                	addi	sp,sp,-32
    80003326:	ec06                	sd	ra,24(sp)
    80003328:	e822                	sd	s0,16(sp)
    8000332a:	e426                	sd	s1,8(sp)
    8000332c:	1000                	addi	s0,sp,32
    8000332e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003330:	0541                	addi	a0,a0,16
    80003332:	00001097          	auipc	ra,0x1
    80003336:	456080e7          	jalr	1110(ra) # 80004788 <holdingsleep>
    8000333a:	cd01                	beqz	a0,80003352 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000333c:	4585                	li	a1,1
    8000333e:	8526                	mv	a0,s1
    80003340:	00003097          	auipc	ra,0x3
    80003344:	f3c080e7          	jalr	-196(ra) # 8000627c <virtio_disk_rw>
}
    80003348:	60e2                	ld	ra,24(sp)
    8000334a:	6442                	ld	s0,16(sp)
    8000334c:	64a2                	ld	s1,8(sp)
    8000334e:	6105                	addi	sp,sp,32
    80003350:	8082                	ret
    panic("bwrite");
    80003352:	00005517          	auipc	a0,0x5
    80003356:	26e50513          	addi	a0,a0,622 # 800085c0 <syscalls+0xd8>
    8000335a:	ffffd097          	auipc	ra,0xffffd
    8000335e:	1ee080e7          	jalr	494(ra) # 80000548 <panic>

0000000080003362 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003362:	1101                	addi	sp,sp,-32
    80003364:	ec06                	sd	ra,24(sp)
    80003366:	e822                	sd	s0,16(sp)
    80003368:	e426                	sd	s1,8(sp)
    8000336a:	e04a                	sd	s2,0(sp)
    8000336c:	1000                	addi	s0,sp,32
    8000336e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003370:	01050913          	addi	s2,a0,16
    80003374:	854a                	mv	a0,s2
    80003376:	00001097          	auipc	ra,0x1
    8000337a:	412080e7          	jalr	1042(ra) # 80004788 <holdingsleep>
    8000337e:	c92d                	beqz	a0,800033f0 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003380:	854a                	mv	a0,s2
    80003382:	00001097          	auipc	ra,0x1
    80003386:	3c2080e7          	jalr	962(ra) # 80004744 <releasesleep>

  acquire(&bcache.lock);
    8000338a:	00014517          	auipc	a0,0x14
    8000338e:	5f650513          	addi	a0,a0,1526 # 80017980 <bcache>
    80003392:	ffffe097          	auipc	ra,0xffffe
    80003396:	87e080e7          	jalr	-1922(ra) # 80000c10 <acquire>
  b->refcnt--;
    8000339a:	40bc                	lw	a5,64(s1)
    8000339c:	37fd                	addiw	a5,a5,-1
    8000339e:	0007871b          	sext.w	a4,a5
    800033a2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800033a4:	eb05                	bnez	a4,800033d4 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800033a6:	68bc                	ld	a5,80(s1)
    800033a8:	64b8                	ld	a4,72(s1)
    800033aa:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800033ac:	64bc                	ld	a5,72(s1)
    800033ae:	68b8                	ld	a4,80(s1)
    800033b0:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800033b2:	0001c797          	auipc	a5,0x1c
    800033b6:	5ce78793          	addi	a5,a5,1486 # 8001f980 <bcache+0x8000>
    800033ba:	2b87b703          	ld	a4,696(a5)
    800033be:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800033c0:	0001d717          	auipc	a4,0x1d
    800033c4:	82870713          	addi	a4,a4,-2008 # 8001fbe8 <bcache+0x8268>
    800033c8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800033ca:	2b87b703          	ld	a4,696(a5)
    800033ce:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800033d0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800033d4:	00014517          	auipc	a0,0x14
    800033d8:	5ac50513          	addi	a0,a0,1452 # 80017980 <bcache>
    800033dc:	ffffe097          	auipc	ra,0xffffe
    800033e0:	8e8080e7          	jalr	-1816(ra) # 80000cc4 <release>
}
    800033e4:	60e2                	ld	ra,24(sp)
    800033e6:	6442                	ld	s0,16(sp)
    800033e8:	64a2                	ld	s1,8(sp)
    800033ea:	6902                	ld	s2,0(sp)
    800033ec:	6105                	addi	sp,sp,32
    800033ee:	8082                	ret
    panic("brelse");
    800033f0:	00005517          	auipc	a0,0x5
    800033f4:	1d850513          	addi	a0,a0,472 # 800085c8 <syscalls+0xe0>
    800033f8:	ffffd097          	auipc	ra,0xffffd
    800033fc:	150080e7          	jalr	336(ra) # 80000548 <panic>

0000000080003400 <bpin>:

void
bpin(struct buf *b) {
    80003400:	1101                	addi	sp,sp,-32
    80003402:	ec06                	sd	ra,24(sp)
    80003404:	e822                	sd	s0,16(sp)
    80003406:	e426                	sd	s1,8(sp)
    80003408:	1000                	addi	s0,sp,32
    8000340a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000340c:	00014517          	auipc	a0,0x14
    80003410:	57450513          	addi	a0,a0,1396 # 80017980 <bcache>
    80003414:	ffffd097          	auipc	ra,0xffffd
    80003418:	7fc080e7          	jalr	2044(ra) # 80000c10 <acquire>
  b->refcnt++;
    8000341c:	40bc                	lw	a5,64(s1)
    8000341e:	2785                	addiw	a5,a5,1
    80003420:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003422:	00014517          	auipc	a0,0x14
    80003426:	55e50513          	addi	a0,a0,1374 # 80017980 <bcache>
    8000342a:	ffffe097          	auipc	ra,0xffffe
    8000342e:	89a080e7          	jalr	-1894(ra) # 80000cc4 <release>
}
    80003432:	60e2                	ld	ra,24(sp)
    80003434:	6442                	ld	s0,16(sp)
    80003436:	64a2                	ld	s1,8(sp)
    80003438:	6105                	addi	sp,sp,32
    8000343a:	8082                	ret

000000008000343c <bunpin>:

void
bunpin(struct buf *b) {
    8000343c:	1101                	addi	sp,sp,-32
    8000343e:	ec06                	sd	ra,24(sp)
    80003440:	e822                	sd	s0,16(sp)
    80003442:	e426                	sd	s1,8(sp)
    80003444:	1000                	addi	s0,sp,32
    80003446:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003448:	00014517          	auipc	a0,0x14
    8000344c:	53850513          	addi	a0,a0,1336 # 80017980 <bcache>
    80003450:	ffffd097          	auipc	ra,0xffffd
    80003454:	7c0080e7          	jalr	1984(ra) # 80000c10 <acquire>
  b->refcnt--;
    80003458:	40bc                	lw	a5,64(s1)
    8000345a:	37fd                	addiw	a5,a5,-1
    8000345c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000345e:	00014517          	auipc	a0,0x14
    80003462:	52250513          	addi	a0,a0,1314 # 80017980 <bcache>
    80003466:	ffffe097          	auipc	ra,0xffffe
    8000346a:	85e080e7          	jalr	-1954(ra) # 80000cc4 <release>
}
    8000346e:	60e2                	ld	ra,24(sp)
    80003470:	6442                	ld	s0,16(sp)
    80003472:	64a2                	ld	s1,8(sp)
    80003474:	6105                	addi	sp,sp,32
    80003476:	8082                	ret

0000000080003478 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003478:	1101                	addi	sp,sp,-32
    8000347a:	ec06                	sd	ra,24(sp)
    8000347c:	e822                	sd	s0,16(sp)
    8000347e:	e426                	sd	s1,8(sp)
    80003480:	e04a                	sd	s2,0(sp)
    80003482:	1000                	addi	s0,sp,32
    80003484:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003486:	00d5d59b          	srliw	a1,a1,0xd
    8000348a:	0001d797          	auipc	a5,0x1d
    8000348e:	bd27a783          	lw	a5,-1070(a5) # 8002005c <sb+0x1c>
    80003492:	9dbd                	addw	a1,a1,a5
    80003494:	00000097          	auipc	ra,0x0
    80003498:	d9e080e7          	jalr	-610(ra) # 80003232 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000349c:	0074f713          	andi	a4,s1,7
    800034a0:	4785                	li	a5,1
    800034a2:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800034a6:	14ce                	slli	s1,s1,0x33
    800034a8:	90d9                	srli	s1,s1,0x36
    800034aa:	00950733          	add	a4,a0,s1
    800034ae:	05874703          	lbu	a4,88(a4)
    800034b2:	00e7f6b3          	and	a3,a5,a4
    800034b6:	c69d                	beqz	a3,800034e4 <bfree+0x6c>
    800034b8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800034ba:	94aa                	add	s1,s1,a0
    800034bc:	fff7c793          	not	a5,a5
    800034c0:	8ff9                	and	a5,a5,a4
    800034c2:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800034c6:	00001097          	auipc	ra,0x1
    800034ca:	100080e7          	jalr	256(ra) # 800045c6 <log_write>
  brelse(bp);
    800034ce:	854a                	mv	a0,s2
    800034d0:	00000097          	auipc	ra,0x0
    800034d4:	e92080e7          	jalr	-366(ra) # 80003362 <brelse>
}
    800034d8:	60e2                	ld	ra,24(sp)
    800034da:	6442                	ld	s0,16(sp)
    800034dc:	64a2                	ld	s1,8(sp)
    800034de:	6902                	ld	s2,0(sp)
    800034e0:	6105                	addi	sp,sp,32
    800034e2:	8082                	ret
    panic("freeing free block");
    800034e4:	00005517          	auipc	a0,0x5
    800034e8:	0ec50513          	addi	a0,a0,236 # 800085d0 <syscalls+0xe8>
    800034ec:	ffffd097          	auipc	ra,0xffffd
    800034f0:	05c080e7          	jalr	92(ra) # 80000548 <panic>

00000000800034f4 <balloc>:
{
    800034f4:	711d                	addi	sp,sp,-96
    800034f6:	ec86                	sd	ra,88(sp)
    800034f8:	e8a2                	sd	s0,80(sp)
    800034fa:	e4a6                	sd	s1,72(sp)
    800034fc:	e0ca                	sd	s2,64(sp)
    800034fe:	fc4e                	sd	s3,56(sp)
    80003500:	f852                	sd	s4,48(sp)
    80003502:	f456                	sd	s5,40(sp)
    80003504:	f05a                	sd	s6,32(sp)
    80003506:	ec5e                	sd	s7,24(sp)
    80003508:	e862                	sd	s8,16(sp)
    8000350a:	e466                	sd	s9,8(sp)
    8000350c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000350e:	0001d797          	auipc	a5,0x1d
    80003512:	b367a783          	lw	a5,-1226(a5) # 80020044 <sb+0x4>
    80003516:	cbd1                	beqz	a5,800035aa <balloc+0xb6>
    80003518:	8baa                	mv	s7,a0
    8000351a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000351c:	0001db17          	auipc	s6,0x1d
    80003520:	b24b0b13          	addi	s6,s6,-1244 # 80020040 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003524:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003526:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003528:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000352a:	6c89                	lui	s9,0x2
    8000352c:	a831                	j	80003548 <balloc+0x54>
    brelse(bp);
    8000352e:	854a                	mv	a0,s2
    80003530:	00000097          	auipc	ra,0x0
    80003534:	e32080e7          	jalr	-462(ra) # 80003362 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003538:	015c87bb          	addw	a5,s9,s5
    8000353c:	00078a9b          	sext.w	s5,a5
    80003540:	004b2703          	lw	a4,4(s6)
    80003544:	06eaf363          	bgeu	s5,a4,800035aa <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80003548:	41fad79b          	sraiw	a5,s5,0x1f
    8000354c:	0137d79b          	srliw	a5,a5,0x13
    80003550:	015787bb          	addw	a5,a5,s5
    80003554:	40d7d79b          	sraiw	a5,a5,0xd
    80003558:	01cb2583          	lw	a1,28(s6)
    8000355c:	9dbd                	addw	a1,a1,a5
    8000355e:	855e                	mv	a0,s7
    80003560:	00000097          	auipc	ra,0x0
    80003564:	cd2080e7          	jalr	-814(ra) # 80003232 <bread>
    80003568:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000356a:	004b2503          	lw	a0,4(s6)
    8000356e:	000a849b          	sext.w	s1,s5
    80003572:	8662                	mv	a2,s8
    80003574:	faa4fde3          	bgeu	s1,a0,8000352e <balloc+0x3a>
      m = 1 << (bi % 8);
    80003578:	41f6579b          	sraiw	a5,a2,0x1f
    8000357c:	01d7d69b          	srliw	a3,a5,0x1d
    80003580:	00c6873b          	addw	a4,a3,a2
    80003584:	00777793          	andi	a5,a4,7
    80003588:	9f95                	subw	a5,a5,a3
    8000358a:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000358e:	4037571b          	sraiw	a4,a4,0x3
    80003592:	00e906b3          	add	a3,s2,a4
    80003596:	0586c683          	lbu	a3,88(a3)
    8000359a:	00d7f5b3          	and	a1,a5,a3
    8000359e:	cd91                	beqz	a1,800035ba <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800035a0:	2605                	addiw	a2,a2,1
    800035a2:	2485                	addiw	s1,s1,1
    800035a4:	fd4618e3          	bne	a2,s4,80003574 <balloc+0x80>
    800035a8:	b759                	j	8000352e <balloc+0x3a>
  panic("balloc: out of blocks");
    800035aa:	00005517          	auipc	a0,0x5
    800035ae:	03e50513          	addi	a0,a0,62 # 800085e8 <syscalls+0x100>
    800035b2:	ffffd097          	auipc	ra,0xffffd
    800035b6:	f96080e7          	jalr	-106(ra) # 80000548 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800035ba:	974a                	add	a4,a4,s2
    800035bc:	8fd5                	or	a5,a5,a3
    800035be:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800035c2:	854a                	mv	a0,s2
    800035c4:	00001097          	auipc	ra,0x1
    800035c8:	002080e7          	jalr	2(ra) # 800045c6 <log_write>
        brelse(bp);
    800035cc:	854a                	mv	a0,s2
    800035ce:	00000097          	auipc	ra,0x0
    800035d2:	d94080e7          	jalr	-620(ra) # 80003362 <brelse>
  bp = bread(dev, bno);
    800035d6:	85a6                	mv	a1,s1
    800035d8:	855e                	mv	a0,s7
    800035da:	00000097          	auipc	ra,0x0
    800035de:	c58080e7          	jalr	-936(ra) # 80003232 <bread>
    800035e2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800035e4:	40000613          	li	a2,1024
    800035e8:	4581                	li	a1,0
    800035ea:	05850513          	addi	a0,a0,88
    800035ee:	ffffd097          	auipc	ra,0xffffd
    800035f2:	71e080e7          	jalr	1822(ra) # 80000d0c <memset>
  log_write(bp);
    800035f6:	854a                	mv	a0,s2
    800035f8:	00001097          	auipc	ra,0x1
    800035fc:	fce080e7          	jalr	-50(ra) # 800045c6 <log_write>
  brelse(bp);
    80003600:	854a                	mv	a0,s2
    80003602:	00000097          	auipc	ra,0x0
    80003606:	d60080e7          	jalr	-672(ra) # 80003362 <brelse>
}
    8000360a:	8526                	mv	a0,s1
    8000360c:	60e6                	ld	ra,88(sp)
    8000360e:	6446                	ld	s0,80(sp)
    80003610:	64a6                	ld	s1,72(sp)
    80003612:	6906                	ld	s2,64(sp)
    80003614:	79e2                	ld	s3,56(sp)
    80003616:	7a42                	ld	s4,48(sp)
    80003618:	7aa2                	ld	s5,40(sp)
    8000361a:	7b02                	ld	s6,32(sp)
    8000361c:	6be2                	ld	s7,24(sp)
    8000361e:	6c42                	ld	s8,16(sp)
    80003620:	6ca2                	ld	s9,8(sp)
    80003622:	6125                	addi	sp,sp,96
    80003624:	8082                	ret

0000000080003626 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80003626:	7179                	addi	sp,sp,-48
    80003628:	f406                	sd	ra,40(sp)
    8000362a:	f022                	sd	s0,32(sp)
    8000362c:	ec26                	sd	s1,24(sp)
    8000362e:	e84a                	sd	s2,16(sp)
    80003630:	e44e                	sd	s3,8(sp)
    80003632:	e052                	sd	s4,0(sp)
    80003634:	1800                	addi	s0,sp,48
    80003636:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003638:	47ad                	li	a5,11
    8000363a:	04b7fe63          	bgeu	a5,a1,80003696 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000363e:	ff45849b          	addiw	s1,a1,-12
    80003642:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003646:	0ff00793          	li	a5,255
    8000364a:	0ae7e363          	bltu	a5,a4,800036f0 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000364e:	08052583          	lw	a1,128(a0)
    80003652:	c5ad                	beqz	a1,800036bc <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003654:	00092503          	lw	a0,0(s2)
    80003658:	00000097          	auipc	ra,0x0
    8000365c:	bda080e7          	jalr	-1062(ra) # 80003232 <bread>
    80003660:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003662:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003666:	02049593          	slli	a1,s1,0x20
    8000366a:	9181                	srli	a1,a1,0x20
    8000366c:	058a                	slli	a1,a1,0x2
    8000366e:	00b784b3          	add	s1,a5,a1
    80003672:	0004a983          	lw	s3,0(s1)
    80003676:	04098d63          	beqz	s3,800036d0 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000367a:	8552                	mv	a0,s4
    8000367c:	00000097          	auipc	ra,0x0
    80003680:	ce6080e7          	jalr	-794(ra) # 80003362 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003684:	854e                	mv	a0,s3
    80003686:	70a2                	ld	ra,40(sp)
    80003688:	7402                	ld	s0,32(sp)
    8000368a:	64e2                	ld	s1,24(sp)
    8000368c:	6942                	ld	s2,16(sp)
    8000368e:	69a2                	ld	s3,8(sp)
    80003690:	6a02                	ld	s4,0(sp)
    80003692:	6145                	addi	sp,sp,48
    80003694:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80003696:	02059493          	slli	s1,a1,0x20
    8000369a:	9081                	srli	s1,s1,0x20
    8000369c:	048a                	slli	s1,s1,0x2
    8000369e:	94aa                	add	s1,s1,a0
    800036a0:	0504a983          	lw	s3,80(s1)
    800036a4:	fe0990e3          	bnez	s3,80003684 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800036a8:	4108                	lw	a0,0(a0)
    800036aa:	00000097          	auipc	ra,0x0
    800036ae:	e4a080e7          	jalr	-438(ra) # 800034f4 <balloc>
    800036b2:	0005099b          	sext.w	s3,a0
    800036b6:	0534a823          	sw	s3,80(s1)
    800036ba:	b7e9                	j	80003684 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800036bc:	4108                	lw	a0,0(a0)
    800036be:	00000097          	auipc	ra,0x0
    800036c2:	e36080e7          	jalr	-458(ra) # 800034f4 <balloc>
    800036c6:	0005059b          	sext.w	a1,a0
    800036ca:	08b92023          	sw	a1,128(s2)
    800036ce:	b759                	j	80003654 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800036d0:	00092503          	lw	a0,0(s2)
    800036d4:	00000097          	auipc	ra,0x0
    800036d8:	e20080e7          	jalr	-480(ra) # 800034f4 <balloc>
    800036dc:	0005099b          	sext.w	s3,a0
    800036e0:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800036e4:	8552                	mv	a0,s4
    800036e6:	00001097          	auipc	ra,0x1
    800036ea:	ee0080e7          	jalr	-288(ra) # 800045c6 <log_write>
    800036ee:	b771                	j	8000367a <bmap+0x54>
  panic("bmap: out of range");
    800036f0:	00005517          	auipc	a0,0x5
    800036f4:	f1050513          	addi	a0,a0,-240 # 80008600 <syscalls+0x118>
    800036f8:	ffffd097          	auipc	ra,0xffffd
    800036fc:	e50080e7          	jalr	-432(ra) # 80000548 <panic>

0000000080003700 <iget>:
{
    80003700:	7179                	addi	sp,sp,-48
    80003702:	f406                	sd	ra,40(sp)
    80003704:	f022                	sd	s0,32(sp)
    80003706:	ec26                	sd	s1,24(sp)
    80003708:	e84a                	sd	s2,16(sp)
    8000370a:	e44e                	sd	s3,8(sp)
    8000370c:	e052                	sd	s4,0(sp)
    8000370e:	1800                	addi	s0,sp,48
    80003710:	89aa                	mv	s3,a0
    80003712:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    80003714:	0001d517          	auipc	a0,0x1d
    80003718:	94c50513          	addi	a0,a0,-1716 # 80020060 <icache>
    8000371c:	ffffd097          	auipc	ra,0xffffd
    80003720:	4f4080e7          	jalr	1268(ra) # 80000c10 <acquire>
  empty = 0;
    80003724:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003726:	0001d497          	auipc	s1,0x1d
    8000372a:	95248493          	addi	s1,s1,-1710 # 80020078 <icache+0x18>
    8000372e:	0001e697          	auipc	a3,0x1e
    80003732:	3da68693          	addi	a3,a3,986 # 80021b08 <log>
    80003736:	a039                	j	80003744 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003738:	02090b63          	beqz	s2,8000376e <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000373c:	08848493          	addi	s1,s1,136
    80003740:	02d48a63          	beq	s1,a3,80003774 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003744:	449c                	lw	a5,8(s1)
    80003746:	fef059e3          	blez	a5,80003738 <iget+0x38>
    8000374a:	4098                	lw	a4,0(s1)
    8000374c:	ff3716e3          	bne	a4,s3,80003738 <iget+0x38>
    80003750:	40d8                	lw	a4,4(s1)
    80003752:	ff4713e3          	bne	a4,s4,80003738 <iget+0x38>
      ip->ref++;
    80003756:	2785                	addiw	a5,a5,1
    80003758:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    8000375a:	0001d517          	auipc	a0,0x1d
    8000375e:	90650513          	addi	a0,a0,-1786 # 80020060 <icache>
    80003762:	ffffd097          	auipc	ra,0xffffd
    80003766:	562080e7          	jalr	1378(ra) # 80000cc4 <release>
      return ip;
    8000376a:	8926                	mv	s2,s1
    8000376c:	a03d                	j	8000379a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000376e:	f7f9                	bnez	a5,8000373c <iget+0x3c>
    80003770:	8926                	mv	s2,s1
    80003772:	b7e9                	j	8000373c <iget+0x3c>
  if(empty == 0)
    80003774:	02090c63          	beqz	s2,800037ac <iget+0xac>
  ip->dev = dev;
    80003778:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000377c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003780:	4785                	li	a5,1
    80003782:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003786:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    8000378a:	0001d517          	auipc	a0,0x1d
    8000378e:	8d650513          	addi	a0,a0,-1834 # 80020060 <icache>
    80003792:	ffffd097          	auipc	ra,0xffffd
    80003796:	532080e7          	jalr	1330(ra) # 80000cc4 <release>
}
    8000379a:	854a                	mv	a0,s2
    8000379c:	70a2                	ld	ra,40(sp)
    8000379e:	7402                	ld	s0,32(sp)
    800037a0:	64e2                	ld	s1,24(sp)
    800037a2:	6942                	ld	s2,16(sp)
    800037a4:	69a2                	ld	s3,8(sp)
    800037a6:	6a02                	ld	s4,0(sp)
    800037a8:	6145                	addi	sp,sp,48
    800037aa:	8082                	ret
    panic("iget: no inodes");
    800037ac:	00005517          	auipc	a0,0x5
    800037b0:	e6c50513          	addi	a0,a0,-404 # 80008618 <syscalls+0x130>
    800037b4:	ffffd097          	auipc	ra,0xffffd
    800037b8:	d94080e7          	jalr	-620(ra) # 80000548 <panic>

00000000800037bc <fsinit>:
fsinit(int dev) {
    800037bc:	7179                	addi	sp,sp,-48
    800037be:	f406                	sd	ra,40(sp)
    800037c0:	f022                	sd	s0,32(sp)
    800037c2:	ec26                	sd	s1,24(sp)
    800037c4:	e84a                	sd	s2,16(sp)
    800037c6:	e44e                	sd	s3,8(sp)
    800037c8:	1800                	addi	s0,sp,48
    800037ca:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800037cc:	4585                	li	a1,1
    800037ce:	00000097          	auipc	ra,0x0
    800037d2:	a64080e7          	jalr	-1436(ra) # 80003232 <bread>
    800037d6:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800037d8:	0001d997          	auipc	s3,0x1d
    800037dc:	86898993          	addi	s3,s3,-1944 # 80020040 <sb>
    800037e0:	02000613          	li	a2,32
    800037e4:	05850593          	addi	a1,a0,88
    800037e8:	854e                	mv	a0,s3
    800037ea:	ffffd097          	auipc	ra,0xffffd
    800037ee:	582080e7          	jalr	1410(ra) # 80000d6c <memmove>
  brelse(bp);
    800037f2:	8526                	mv	a0,s1
    800037f4:	00000097          	auipc	ra,0x0
    800037f8:	b6e080e7          	jalr	-1170(ra) # 80003362 <brelse>
  if(sb.magic != FSMAGIC)
    800037fc:	0009a703          	lw	a4,0(s3)
    80003800:	102037b7          	lui	a5,0x10203
    80003804:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003808:	02f71263          	bne	a4,a5,8000382c <fsinit+0x70>
  initlog(dev, &sb);
    8000380c:	0001d597          	auipc	a1,0x1d
    80003810:	83458593          	addi	a1,a1,-1996 # 80020040 <sb>
    80003814:	854a                	mv	a0,s2
    80003816:	00001097          	auipc	ra,0x1
    8000381a:	b38080e7          	jalr	-1224(ra) # 8000434e <initlog>
}
    8000381e:	70a2                	ld	ra,40(sp)
    80003820:	7402                	ld	s0,32(sp)
    80003822:	64e2                	ld	s1,24(sp)
    80003824:	6942                	ld	s2,16(sp)
    80003826:	69a2                	ld	s3,8(sp)
    80003828:	6145                	addi	sp,sp,48
    8000382a:	8082                	ret
    panic("invalid file system");
    8000382c:	00005517          	auipc	a0,0x5
    80003830:	dfc50513          	addi	a0,a0,-516 # 80008628 <syscalls+0x140>
    80003834:	ffffd097          	auipc	ra,0xffffd
    80003838:	d14080e7          	jalr	-748(ra) # 80000548 <panic>

000000008000383c <iinit>:
{
    8000383c:	7179                	addi	sp,sp,-48
    8000383e:	f406                	sd	ra,40(sp)
    80003840:	f022                	sd	s0,32(sp)
    80003842:	ec26                	sd	s1,24(sp)
    80003844:	e84a                	sd	s2,16(sp)
    80003846:	e44e                	sd	s3,8(sp)
    80003848:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    8000384a:	00005597          	auipc	a1,0x5
    8000384e:	df658593          	addi	a1,a1,-522 # 80008640 <syscalls+0x158>
    80003852:	0001d517          	auipc	a0,0x1d
    80003856:	80e50513          	addi	a0,a0,-2034 # 80020060 <icache>
    8000385a:	ffffd097          	auipc	ra,0xffffd
    8000385e:	326080e7          	jalr	806(ra) # 80000b80 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003862:	0001d497          	auipc	s1,0x1d
    80003866:	82648493          	addi	s1,s1,-2010 # 80020088 <icache+0x28>
    8000386a:	0001e997          	auipc	s3,0x1e
    8000386e:	2ae98993          	addi	s3,s3,686 # 80021b18 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003872:	00005917          	auipc	s2,0x5
    80003876:	dd690913          	addi	s2,s2,-554 # 80008648 <syscalls+0x160>
    8000387a:	85ca                	mv	a1,s2
    8000387c:	8526                	mv	a0,s1
    8000387e:	00001097          	auipc	ra,0x1
    80003882:	e36080e7          	jalr	-458(ra) # 800046b4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003886:	08848493          	addi	s1,s1,136
    8000388a:	ff3498e3          	bne	s1,s3,8000387a <iinit+0x3e>
}
    8000388e:	70a2                	ld	ra,40(sp)
    80003890:	7402                	ld	s0,32(sp)
    80003892:	64e2                	ld	s1,24(sp)
    80003894:	6942                	ld	s2,16(sp)
    80003896:	69a2                	ld	s3,8(sp)
    80003898:	6145                	addi	sp,sp,48
    8000389a:	8082                	ret

000000008000389c <ialloc>:
{
    8000389c:	715d                	addi	sp,sp,-80
    8000389e:	e486                	sd	ra,72(sp)
    800038a0:	e0a2                	sd	s0,64(sp)
    800038a2:	fc26                	sd	s1,56(sp)
    800038a4:	f84a                	sd	s2,48(sp)
    800038a6:	f44e                	sd	s3,40(sp)
    800038a8:	f052                	sd	s4,32(sp)
    800038aa:	ec56                	sd	s5,24(sp)
    800038ac:	e85a                	sd	s6,16(sp)
    800038ae:	e45e                	sd	s7,8(sp)
    800038b0:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800038b2:	0001c717          	auipc	a4,0x1c
    800038b6:	79a72703          	lw	a4,1946(a4) # 8002004c <sb+0xc>
    800038ba:	4785                	li	a5,1
    800038bc:	04e7fa63          	bgeu	a5,a4,80003910 <ialloc+0x74>
    800038c0:	8aaa                	mv	s5,a0
    800038c2:	8bae                	mv	s7,a1
    800038c4:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800038c6:	0001ca17          	auipc	s4,0x1c
    800038ca:	77aa0a13          	addi	s4,s4,1914 # 80020040 <sb>
    800038ce:	00048b1b          	sext.w	s6,s1
    800038d2:	0044d593          	srli	a1,s1,0x4
    800038d6:	018a2783          	lw	a5,24(s4)
    800038da:	9dbd                	addw	a1,a1,a5
    800038dc:	8556                	mv	a0,s5
    800038de:	00000097          	auipc	ra,0x0
    800038e2:	954080e7          	jalr	-1708(ra) # 80003232 <bread>
    800038e6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800038e8:	05850993          	addi	s3,a0,88
    800038ec:	00f4f793          	andi	a5,s1,15
    800038f0:	079a                	slli	a5,a5,0x6
    800038f2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800038f4:	00099783          	lh	a5,0(s3)
    800038f8:	c785                	beqz	a5,80003920 <ialloc+0x84>
    brelse(bp);
    800038fa:	00000097          	auipc	ra,0x0
    800038fe:	a68080e7          	jalr	-1432(ra) # 80003362 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003902:	0485                	addi	s1,s1,1
    80003904:	00ca2703          	lw	a4,12(s4)
    80003908:	0004879b          	sext.w	a5,s1
    8000390c:	fce7e1e3          	bltu	a5,a4,800038ce <ialloc+0x32>
  panic("ialloc: no inodes");
    80003910:	00005517          	auipc	a0,0x5
    80003914:	d4050513          	addi	a0,a0,-704 # 80008650 <syscalls+0x168>
    80003918:	ffffd097          	auipc	ra,0xffffd
    8000391c:	c30080e7          	jalr	-976(ra) # 80000548 <panic>
      memset(dip, 0, sizeof(*dip));
    80003920:	04000613          	li	a2,64
    80003924:	4581                	li	a1,0
    80003926:	854e                	mv	a0,s3
    80003928:	ffffd097          	auipc	ra,0xffffd
    8000392c:	3e4080e7          	jalr	996(ra) # 80000d0c <memset>
      dip->type = type;
    80003930:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003934:	854a                	mv	a0,s2
    80003936:	00001097          	auipc	ra,0x1
    8000393a:	c90080e7          	jalr	-880(ra) # 800045c6 <log_write>
      brelse(bp);
    8000393e:	854a                	mv	a0,s2
    80003940:	00000097          	auipc	ra,0x0
    80003944:	a22080e7          	jalr	-1502(ra) # 80003362 <brelse>
      return iget(dev, inum);
    80003948:	85da                	mv	a1,s6
    8000394a:	8556                	mv	a0,s5
    8000394c:	00000097          	auipc	ra,0x0
    80003950:	db4080e7          	jalr	-588(ra) # 80003700 <iget>
}
    80003954:	60a6                	ld	ra,72(sp)
    80003956:	6406                	ld	s0,64(sp)
    80003958:	74e2                	ld	s1,56(sp)
    8000395a:	7942                	ld	s2,48(sp)
    8000395c:	79a2                	ld	s3,40(sp)
    8000395e:	7a02                	ld	s4,32(sp)
    80003960:	6ae2                	ld	s5,24(sp)
    80003962:	6b42                	ld	s6,16(sp)
    80003964:	6ba2                	ld	s7,8(sp)
    80003966:	6161                	addi	sp,sp,80
    80003968:	8082                	ret

000000008000396a <iupdate>:
{
    8000396a:	1101                	addi	sp,sp,-32
    8000396c:	ec06                	sd	ra,24(sp)
    8000396e:	e822                	sd	s0,16(sp)
    80003970:	e426                	sd	s1,8(sp)
    80003972:	e04a                	sd	s2,0(sp)
    80003974:	1000                	addi	s0,sp,32
    80003976:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003978:	415c                	lw	a5,4(a0)
    8000397a:	0047d79b          	srliw	a5,a5,0x4
    8000397e:	0001c597          	auipc	a1,0x1c
    80003982:	6da5a583          	lw	a1,1754(a1) # 80020058 <sb+0x18>
    80003986:	9dbd                	addw	a1,a1,a5
    80003988:	4108                	lw	a0,0(a0)
    8000398a:	00000097          	auipc	ra,0x0
    8000398e:	8a8080e7          	jalr	-1880(ra) # 80003232 <bread>
    80003992:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003994:	05850793          	addi	a5,a0,88
    80003998:	40c8                	lw	a0,4(s1)
    8000399a:	893d                	andi	a0,a0,15
    8000399c:	051a                	slli	a0,a0,0x6
    8000399e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800039a0:	04449703          	lh	a4,68(s1)
    800039a4:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800039a8:	04649703          	lh	a4,70(s1)
    800039ac:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800039b0:	04849703          	lh	a4,72(s1)
    800039b4:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800039b8:	04a49703          	lh	a4,74(s1)
    800039bc:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800039c0:	44f8                	lw	a4,76(s1)
    800039c2:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800039c4:	03400613          	li	a2,52
    800039c8:	05048593          	addi	a1,s1,80
    800039cc:	0531                	addi	a0,a0,12
    800039ce:	ffffd097          	auipc	ra,0xffffd
    800039d2:	39e080e7          	jalr	926(ra) # 80000d6c <memmove>
  log_write(bp);
    800039d6:	854a                	mv	a0,s2
    800039d8:	00001097          	auipc	ra,0x1
    800039dc:	bee080e7          	jalr	-1042(ra) # 800045c6 <log_write>
  brelse(bp);
    800039e0:	854a                	mv	a0,s2
    800039e2:	00000097          	auipc	ra,0x0
    800039e6:	980080e7          	jalr	-1664(ra) # 80003362 <brelse>
}
    800039ea:	60e2                	ld	ra,24(sp)
    800039ec:	6442                	ld	s0,16(sp)
    800039ee:	64a2                	ld	s1,8(sp)
    800039f0:	6902                	ld	s2,0(sp)
    800039f2:	6105                	addi	sp,sp,32
    800039f4:	8082                	ret

00000000800039f6 <idup>:
{
    800039f6:	1101                	addi	sp,sp,-32
    800039f8:	ec06                	sd	ra,24(sp)
    800039fa:	e822                	sd	s0,16(sp)
    800039fc:	e426                	sd	s1,8(sp)
    800039fe:	1000                	addi	s0,sp,32
    80003a00:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003a02:	0001c517          	auipc	a0,0x1c
    80003a06:	65e50513          	addi	a0,a0,1630 # 80020060 <icache>
    80003a0a:	ffffd097          	auipc	ra,0xffffd
    80003a0e:	206080e7          	jalr	518(ra) # 80000c10 <acquire>
  ip->ref++;
    80003a12:	449c                	lw	a5,8(s1)
    80003a14:	2785                	addiw	a5,a5,1
    80003a16:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003a18:	0001c517          	auipc	a0,0x1c
    80003a1c:	64850513          	addi	a0,a0,1608 # 80020060 <icache>
    80003a20:	ffffd097          	auipc	ra,0xffffd
    80003a24:	2a4080e7          	jalr	676(ra) # 80000cc4 <release>
}
    80003a28:	8526                	mv	a0,s1
    80003a2a:	60e2                	ld	ra,24(sp)
    80003a2c:	6442                	ld	s0,16(sp)
    80003a2e:	64a2                	ld	s1,8(sp)
    80003a30:	6105                	addi	sp,sp,32
    80003a32:	8082                	ret

0000000080003a34 <ilock>:
{
    80003a34:	1101                	addi	sp,sp,-32
    80003a36:	ec06                	sd	ra,24(sp)
    80003a38:	e822                	sd	s0,16(sp)
    80003a3a:	e426                	sd	s1,8(sp)
    80003a3c:	e04a                	sd	s2,0(sp)
    80003a3e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003a40:	c115                	beqz	a0,80003a64 <ilock+0x30>
    80003a42:	84aa                	mv	s1,a0
    80003a44:	451c                	lw	a5,8(a0)
    80003a46:	00f05f63          	blez	a5,80003a64 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003a4a:	0541                	addi	a0,a0,16
    80003a4c:	00001097          	auipc	ra,0x1
    80003a50:	ca2080e7          	jalr	-862(ra) # 800046ee <acquiresleep>
  if(ip->valid == 0){
    80003a54:	40bc                	lw	a5,64(s1)
    80003a56:	cf99                	beqz	a5,80003a74 <ilock+0x40>
}
    80003a58:	60e2                	ld	ra,24(sp)
    80003a5a:	6442                	ld	s0,16(sp)
    80003a5c:	64a2                	ld	s1,8(sp)
    80003a5e:	6902                	ld	s2,0(sp)
    80003a60:	6105                	addi	sp,sp,32
    80003a62:	8082                	ret
    panic("ilock");
    80003a64:	00005517          	auipc	a0,0x5
    80003a68:	c0450513          	addi	a0,a0,-1020 # 80008668 <syscalls+0x180>
    80003a6c:	ffffd097          	auipc	ra,0xffffd
    80003a70:	adc080e7          	jalr	-1316(ra) # 80000548 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003a74:	40dc                	lw	a5,4(s1)
    80003a76:	0047d79b          	srliw	a5,a5,0x4
    80003a7a:	0001c597          	auipc	a1,0x1c
    80003a7e:	5de5a583          	lw	a1,1502(a1) # 80020058 <sb+0x18>
    80003a82:	9dbd                	addw	a1,a1,a5
    80003a84:	4088                	lw	a0,0(s1)
    80003a86:	fffff097          	auipc	ra,0xfffff
    80003a8a:	7ac080e7          	jalr	1964(ra) # 80003232 <bread>
    80003a8e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003a90:	05850593          	addi	a1,a0,88
    80003a94:	40dc                	lw	a5,4(s1)
    80003a96:	8bbd                	andi	a5,a5,15
    80003a98:	079a                	slli	a5,a5,0x6
    80003a9a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003a9c:	00059783          	lh	a5,0(a1)
    80003aa0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003aa4:	00259783          	lh	a5,2(a1)
    80003aa8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003aac:	00459783          	lh	a5,4(a1)
    80003ab0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003ab4:	00659783          	lh	a5,6(a1)
    80003ab8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003abc:	459c                	lw	a5,8(a1)
    80003abe:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003ac0:	03400613          	li	a2,52
    80003ac4:	05b1                	addi	a1,a1,12
    80003ac6:	05048513          	addi	a0,s1,80
    80003aca:	ffffd097          	auipc	ra,0xffffd
    80003ace:	2a2080e7          	jalr	674(ra) # 80000d6c <memmove>
    brelse(bp);
    80003ad2:	854a                	mv	a0,s2
    80003ad4:	00000097          	auipc	ra,0x0
    80003ad8:	88e080e7          	jalr	-1906(ra) # 80003362 <brelse>
    ip->valid = 1;
    80003adc:	4785                	li	a5,1
    80003ade:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003ae0:	04449783          	lh	a5,68(s1)
    80003ae4:	fbb5                	bnez	a5,80003a58 <ilock+0x24>
      panic("ilock: no type");
    80003ae6:	00005517          	auipc	a0,0x5
    80003aea:	b8a50513          	addi	a0,a0,-1142 # 80008670 <syscalls+0x188>
    80003aee:	ffffd097          	auipc	ra,0xffffd
    80003af2:	a5a080e7          	jalr	-1446(ra) # 80000548 <panic>

0000000080003af6 <iunlock>:
{
    80003af6:	1101                	addi	sp,sp,-32
    80003af8:	ec06                	sd	ra,24(sp)
    80003afa:	e822                	sd	s0,16(sp)
    80003afc:	e426                	sd	s1,8(sp)
    80003afe:	e04a                	sd	s2,0(sp)
    80003b00:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003b02:	c905                	beqz	a0,80003b32 <iunlock+0x3c>
    80003b04:	84aa                	mv	s1,a0
    80003b06:	01050913          	addi	s2,a0,16
    80003b0a:	854a                	mv	a0,s2
    80003b0c:	00001097          	auipc	ra,0x1
    80003b10:	c7c080e7          	jalr	-900(ra) # 80004788 <holdingsleep>
    80003b14:	cd19                	beqz	a0,80003b32 <iunlock+0x3c>
    80003b16:	449c                	lw	a5,8(s1)
    80003b18:	00f05d63          	blez	a5,80003b32 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003b1c:	854a                	mv	a0,s2
    80003b1e:	00001097          	auipc	ra,0x1
    80003b22:	c26080e7          	jalr	-986(ra) # 80004744 <releasesleep>
}
    80003b26:	60e2                	ld	ra,24(sp)
    80003b28:	6442                	ld	s0,16(sp)
    80003b2a:	64a2                	ld	s1,8(sp)
    80003b2c:	6902                	ld	s2,0(sp)
    80003b2e:	6105                	addi	sp,sp,32
    80003b30:	8082                	ret
    panic("iunlock");
    80003b32:	00005517          	auipc	a0,0x5
    80003b36:	b4e50513          	addi	a0,a0,-1202 # 80008680 <syscalls+0x198>
    80003b3a:	ffffd097          	auipc	ra,0xffffd
    80003b3e:	a0e080e7          	jalr	-1522(ra) # 80000548 <panic>

0000000080003b42 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003b42:	7179                	addi	sp,sp,-48
    80003b44:	f406                	sd	ra,40(sp)
    80003b46:	f022                	sd	s0,32(sp)
    80003b48:	ec26                	sd	s1,24(sp)
    80003b4a:	e84a                	sd	s2,16(sp)
    80003b4c:	e44e                	sd	s3,8(sp)
    80003b4e:	e052                	sd	s4,0(sp)
    80003b50:	1800                	addi	s0,sp,48
    80003b52:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003b54:	05050493          	addi	s1,a0,80
    80003b58:	08050913          	addi	s2,a0,128
    80003b5c:	a021                	j	80003b64 <itrunc+0x22>
    80003b5e:	0491                	addi	s1,s1,4
    80003b60:	01248d63          	beq	s1,s2,80003b7a <itrunc+0x38>
    if(ip->addrs[i]){
    80003b64:	408c                	lw	a1,0(s1)
    80003b66:	dde5                	beqz	a1,80003b5e <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003b68:	0009a503          	lw	a0,0(s3)
    80003b6c:	00000097          	auipc	ra,0x0
    80003b70:	90c080e7          	jalr	-1780(ra) # 80003478 <bfree>
      ip->addrs[i] = 0;
    80003b74:	0004a023          	sw	zero,0(s1)
    80003b78:	b7dd                	j	80003b5e <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003b7a:	0809a583          	lw	a1,128(s3)
    80003b7e:	e185                	bnez	a1,80003b9e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003b80:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003b84:	854e                	mv	a0,s3
    80003b86:	00000097          	auipc	ra,0x0
    80003b8a:	de4080e7          	jalr	-540(ra) # 8000396a <iupdate>
}
    80003b8e:	70a2                	ld	ra,40(sp)
    80003b90:	7402                	ld	s0,32(sp)
    80003b92:	64e2                	ld	s1,24(sp)
    80003b94:	6942                	ld	s2,16(sp)
    80003b96:	69a2                	ld	s3,8(sp)
    80003b98:	6a02                	ld	s4,0(sp)
    80003b9a:	6145                	addi	sp,sp,48
    80003b9c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003b9e:	0009a503          	lw	a0,0(s3)
    80003ba2:	fffff097          	auipc	ra,0xfffff
    80003ba6:	690080e7          	jalr	1680(ra) # 80003232 <bread>
    80003baa:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003bac:	05850493          	addi	s1,a0,88
    80003bb0:	45850913          	addi	s2,a0,1112
    80003bb4:	a811                	j	80003bc8 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80003bb6:	0009a503          	lw	a0,0(s3)
    80003bba:	00000097          	auipc	ra,0x0
    80003bbe:	8be080e7          	jalr	-1858(ra) # 80003478 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80003bc2:	0491                	addi	s1,s1,4
    80003bc4:	01248563          	beq	s1,s2,80003bce <itrunc+0x8c>
      if(a[j])
    80003bc8:	408c                	lw	a1,0(s1)
    80003bca:	dde5                	beqz	a1,80003bc2 <itrunc+0x80>
    80003bcc:	b7ed                	j	80003bb6 <itrunc+0x74>
    brelse(bp);
    80003bce:	8552                	mv	a0,s4
    80003bd0:	fffff097          	auipc	ra,0xfffff
    80003bd4:	792080e7          	jalr	1938(ra) # 80003362 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003bd8:	0809a583          	lw	a1,128(s3)
    80003bdc:	0009a503          	lw	a0,0(s3)
    80003be0:	00000097          	auipc	ra,0x0
    80003be4:	898080e7          	jalr	-1896(ra) # 80003478 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003be8:	0809a023          	sw	zero,128(s3)
    80003bec:	bf51                	j	80003b80 <itrunc+0x3e>

0000000080003bee <iput>:
{
    80003bee:	1101                	addi	sp,sp,-32
    80003bf0:	ec06                	sd	ra,24(sp)
    80003bf2:	e822                	sd	s0,16(sp)
    80003bf4:	e426                	sd	s1,8(sp)
    80003bf6:	e04a                	sd	s2,0(sp)
    80003bf8:	1000                	addi	s0,sp,32
    80003bfa:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003bfc:	0001c517          	auipc	a0,0x1c
    80003c00:	46450513          	addi	a0,a0,1124 # 80020060 <icache>
    80003c04:	ffffd097          	auipc	ra,0xffffd
    80003c08:	00c080e7          	jalr	12(ra) # 80000c10 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c0c:	4498                	lw	a4,8(s1)
    80003c0e:	4785                	li	a5,1
    80003c10:	02f70363          	beq	a4,a5,80003c36 <iput+0x48>
  ip->ref--;
    80003c14:	449c                	lw	a5,8(s1)
    80003c16:	37fd                	addiw	a5,a5,-1
    80003c18:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003c1a:	0001c517          	auipc	a0,0x1c
    80003c1e:	44650513          	addi	a0,a0,1094 # 80020060 <icache>
    80003c22:	ffffd097          	auipc	ra,0xffffd
    80003c26:	0a2080e7          	jalr	162(ra) # 80000cc4 <release>
}
    80003c2a:	60e2                	ld	ra,24(sp)
    80003c2c:	6442                	ld	s0,16(sp)
    80003c2e:	64a2                	ld	s1,8(sp)
    80003c30:	6902                	ld	s2,0(sp)
    80003c32:	6105                	addi	sp,sp,32
    80003c34:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c36:	40bc                	lw	a5,64(s1)
    80003c38:	dff1                	beqz	a5,80003c14 <iput+0x26>
    80003c3a:	04a49783          	lh	a5,74(s1)
    80003c3e:	fbf9                	bnez	a5,80003c14 <iput+0x26>
    acquiresleep(&ip->lock);
    80003c40:	01048913          	addi	s2,s1,16
    80003c44:	854a                	mv	a0,s2
    80003c46:	00001097          	auipc	ra,0x1
    80003c4a:	aa8080e7          	jalr	-1368(ra) # 800046ee <acquiresleep>
    release(&icache.lock);
    80003c4e:	0001c517          	auipc	a0,0x1c
    80003c52:	41250513          	addi	a0,a0,1042 # 80020060 <icache>
    80003c56:	ffffd097          	auipc	ra,0xffffd
    80003c5a:	06e080e7          	jalr	110(ra) # 80000cc4 <release>
    itrunc(ip);
    80003c5e:	8526                	mv	a0,s1
    80003c60:	00000097          	auipc	ra,0x0
    80003c64:	ee2080e7          	jalr	-286(ra) # 80003b42 <itrunc>
    ip->type = 0;
    80003c68:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003c6c:	8526                	mv	a0,s1
    80003c6e:	00000097          	auipc	ra,0x0
    80003c72:	cfc080e7          	jalr	-772(ra) # 8000396a <iupdate>
    ip->valid = 0;
    80003c76:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003c7a:	854a                	mv	a0,s2
    80003c7c:	00001097          	auipc	ra,0x1
    80003c80:	ac8080e7          	jalr	-1336(ra) # 80004744 <releasesleep>
    acquire(&icache.lock);
    80003c84:	0001c517          	auipc	a0,0x1c
    80003c88:	3dc50513          	addi	a0,a0,988 # 80020060 <icache>
    80003c8c:	ffffd097          	auipc	ra,0xffffd
    80003c90:	f84080e7          	jalr	-124(ra) # 80000c10 <acquire>
    80003c94:	b741                	j	80003c14 <iput+0x26>

0000000080003c96 <iunlockput>:
{
    80003c96:	1101                	addi	sp,sp,-32
    80003c98:	ec06                	sd	ra,24(sp)
    80003c9a:	e822                	sd	s0,16(sp)
    80003c9c:	e426                	sd	s1,8(sp)
    80003c9e:	1000                	addi	s0,sp,32
    80003ca0:	84aa                	mv	s1,a0
  iunlock(ip);
    80003ca2:	00000097          	auipc	ra,0x0
    80003ca6:	e54080e7          	jalr	-428(ra) # 80003af6 <iunlock>
  iput(ip);
    80003caa:	8526                	mv	a0,s1
    80003cac:	00000097          	auipc	ra,0x0
    80003cb0:	f42080e7          	jalr	-190(ra) # 80003bee <iput>
}
    80003cb4:	60e2                	ld	ra,24(sp)
    80003cb6:	6442                	ld	s0,16(sp)
    80003cb8:	64a2                	ld	s1,8(sp)
    80003cba:	6105                	addi	sp,sp,32
    80003cbc:	8082                	ret

0000000080003cbe <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003cbe:	1141                	addi	sp,sp,-16
    80003cc0:	e422                	sd	s0,8(sp)
    80003cc2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003cc4:	411c                	lw	a5,0(a0)
    80003cc6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003cc8:	415c                	lw	a5,4(a0)
    80003cca:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003ccc:	04451783          	lh	a5,68(a0)
    80003cd0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003cd4:	04a51783          	lh	a5,74(a0)
    80003cd8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003cdc:	04c56783          	lwu	a5,76(a0)
    80003ce0:	e99c                	sd	a5,16(a1)
}
    80003ce2:	6422                	ld	s0,8(sp)
    80003ce4:	0141                	addi	sp,sp,16
    80003ce6:	8082                	ret

0000000080003ce8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003ce8:	457c                	lw	a5,76(a0)
    80003cea:	0ed7e863          	bltu	a5,a3,80003dda <readi+0xf2>
{
    80003cee:	7159                	addi	sp,sp,-112
    80003cf0:	f486                	sd	ra,104(sp)
    80003cf2:	f0a2                	sd	s0,96(sp)
    80003cf4:	eca6                	sd	s1,88(sp)
    80003cf6:	e8ca                	sd	s2,80(sp)
    80003cf8:	e4ce                	sd	s3,72(sp)
    80003cfa:	e0d2                	sd	s4,64(sp)
    80003cfc:	fc56                	sd	s5,56(sp)
    80003cfe:	f85a                	sd	s6,48(sp)
    80003d00:	f45e                	sd	s7,40(sp)
    80003d02:	f062                	sd	s8,32(sp)
    80003d04:	ec66                	sd	s9,24(sp)
    80003d06:	e86a                	sd	s10,16(sp)
    80003d08:	e46e                	sd	s11,8(sp)
    80003d0a:	1880                	addi	s0,sp,112
    80003d0c:	8baa                	mv	s7,a0
    80003d0e:	8c2e                	mv	s8,a1
    80003d10:	8ab2                	mv	s5,a2
    80003d12:	84b6                	mv	s1,a3
    80003d14:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003d16:	9f35                	addw	a4,a4,a3
    return 0;
    80003d18:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003d1a:	08d76f63          	bltu	a4,a3,80003db8 <readi+0xd0>
  if(off + n > ip->size)
    80003d1e:	00e7f463          	bgeu	a5,a4,80003d26 <readi+0x3e>
    n = ip->size - off;
    80003d22:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d26:	0a0b0863          	beqz	s6,80003dd6 <readi+0xee>
    80003d2a:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d2c:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003d30:	5cfd                	li	s9,-1
    80003d32:	a82d                	j	80003d6c <readi+0x84>
    80003d34:	020a1d93          	slli	s11,s4,0x20
    80003d38:	020ddd93          	srli	s11,s11,0x20
    80003d3c:	05890613          	addi	a2,s2,88
    80003d40:	86ee                	mv	a3,s11
    80003d42:	963a                	add	a2,a2,a4
    80003d44:	85d6                	mv	a1,s5
    80003d46:	8562                	mv	a0,s8
    80003d48:	fffff097          	auipc	ra,0xfffff
    80003d4c:	b2e080e7          	jalr	-1234(ra) # 80002876 <either_copyout>
    80003d50:	05950d63          	beq	a0,s9,80003daa <readi+0xc2>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003d54:	854a                	mv	a0,s2
    80003d56:	fffff097          	auipc	ra,0xfffff
    80003d5a:	60c080e7          	jalr	1548(ra) # 80003362 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003d5e:	013a09bb          	addw	s3,s4,s3
    80003d62:	009a04bb          	addw	s1,s4,s1
    80003d66:	9aee                	add	s5,s5,s11
    80003d68:	0569f663          	bgeu	s3,s6,80003db4 <readi+0xcc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003d6c:	000ba903          	lw	s2,0(s7)
    80003d70:	00a4d59b          	srliw	a1,s1,0xa
    80003d74:	855e                	mv	a0,s7
    80003d76:	00000097          	auipc	ra,0x0
    80003d7a:	8b0080e7          	jalr	-1872(ra) # 80003626 <bmap>
    80003d7e:	0005059b          	sext.w	a1,a0
    80003d82:	854a                	mv	a0,s2
    80003d84:	fffff097          	auipc	ra,0xfffff
    80003d88:	4ae080e7          	jalr	1198(ra) # 80003232 <bread>
    80003d8c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d8e:	3ff4f713          	andi	a4,s1,1023
    80003d92:	40ed07bb          	subw	a5,s10,a4
    80003d96:	413b06bb          	subw	a3,s6,s3
    80003d9a:	8a3e                	mv	s4,a5
    80003d9c:	2781                	sext.w	a5,a5
    80003d9e:	0006861b          	sext.w	a2,a3
    80003da2:	f8f679e3          	bgeu	a2,a5,80003d34 <readi+0x4c>
    80003da6:	8a36                	mv	s4,a3
    80003da8:	b771                	j	80003d34 <readi+0x4c>
      brelse(bp);
    80003daa:	854a                	mv	a0,s2
    80003dac:	fffff097          	auipc	ra,0xfffff
    80003db0:	5b6080e7          	jalr	1462(ra) # 80003362 <brelse>
  }
  return tot;
    80003db4:	0009851b          	sext.w	a0,s3
}
    80003db8:	70a6                	ld	ra,104(sp)
    80003dba:	7406                	ld	s0,96(sp)
    80003dbc:	64e6                	ld	s1,88(sp)
    80003dbe:	6946                	ld	s2,80(sp)
    80003dc0:	69a6                	ld	s3,72(sp)
    80003dc2:	6a06                	ld	s4,64(sp)
    80003dc4:	7ae2                	ld	s5,56(sp)
    80003dc6:	7b42                	ld	s6,48(sp)
    80003dc8:	7ba2                	ld	s7,40(sp)
    80003dca:	7c02                	ld	s8,32(sp)
    80003dcc:	6ce2                	ld	s9,24(sp)
    80003dce:	6d42                	ld	s10,16(sp)
    80003dd0:	6da2                	ld	s11,8(sp)
    80003dd2:	6165                	addi	sp,sp,112
    80003dd4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003dd6:	89da                	mv	s3,s6
    80003dd8:	bff1                	j	80003db4 <readi+0xcc>
    return 0;
    80003dda:	4501                	li	a0,0
}
    80003ddc:	8082                	ret

0000000080003dde <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003dde:	457c                	lw	a5,76(a0)
    80003de0:	10d7e663          	bltu	a5,a3,80003eec <writei+0x10e>
{
    80003de4:	7159                	addi	sp,sp,-112
    80003de6:	f486                	sd	ra,104(sp)
    80003de8:	f0a2                	sd	s0,96(sp)
    80003dea:	eca6                	sd	s1,88(sp)
    80003dec:	e8ca                	sd	s2,80(sp)
    80003dee:	e4ce                	sd	s3,72(sp)
    80003df0:	e0d2                	sd	s4,64(sp)
    80003df2:	fc56                	sd	s5,56(sp)
    80003df4:	f85a                	sd	s6,48(sp)
    80003df6:	f45e                	sd	s7,40(sp)
    80003df8:	f062                	sd	s8,32(sp)
    80003dfa:	ec66                	sd	s9,24(sp)
    80003dfc:	e86a                	sd	s10,16(sp)
    80003dfe:	e46e                	sd	s11,8(sp)
    80003e00:	1880                	addi	s0,sp,112
    80003e02:	8baa                	mv	s7,a0
    80003e04:	8c2e                	mv	s8,a1
    80003e06:	8ab2                	mv	s5,a2
    80003e08:	8936                	mv	s2,a3
    80003e0a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003e0c:	00e687bb          	addw	a5,a3,a4
    80003e10:	0ed7e063          	bltu	a5,a3,80003ef0 <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003e14:	00043737          	lui	a4,0x43
    80003e18:	0cf76e63          	bltu	a4,a5,80003ef4 <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003e1c:	0a0b0763          	beqz	s6,80003eca <writei+0xec>
    80003e20:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e22:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003e26:	5cfd                	li	s9,-1
    80003e28:	a091                	j	80003e6c <writei+0x8e>
    80003e2a:	02099d93          	slli	s11,s3,0x20
    80003e2e:	020ddd93          	srli	s11,s11,0x20
    80003e32:	05848513          	addi	a0,s1,88
    80003e36:	86ee                	mv	a3,s11
    80003e38:	8656                	mv	a2,s5
    80003e3a:	85e2                	mv	a1,s8
    80003e3c:	953a                	add	a0,a0,a4
    80003e3e:	fffff097          	auipc	ra,0xfffff
    80003e42:	a8e080e7          	jalr	-1394(ra) # 800028cc <either_copyin>
    80003e46:	07950263          	beq	a0,s9,80003eaa <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003e4a:	8526                	mv	a0,s1
    80003e4c:	00000097          	auipc	ra,0x0
    80003e50:	77a080e7          	jalr	1914(ra) # 800045c6 <log_write>
    brelse(bp);
    80003e54:	8526                	mv	a0,s1
    80003e56:	fffff097          	auipc	ra,0xfffff
    80003e5a:	50c080e7          	jalr	1292(ra) # 80003362 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003e5e:	01498a3b          	addw	s4,s3,s4
    80003e62:	0129893b          	addw	s2,s3,s2
    80003e66:	9aee                	add	s5,s5,s11
    80003e68:	056a7663          	bgeu	s4,s6,80003eb4 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003e6c:	000ba483          	lw	s1,0(s7)
    80003e70:	00a9559b          	srliw	a1,s2,0xa
    80003e74:	855e                	mv	a0,s7
    80003e76:	fffff097          	auipc	ra,0xfffff
    80003e7a:	7b0080e7          	jalr	1968(ra) # 80003626 <bmap>
    80003e7e:	0005059b          	sext.w	a1,a0
    80003e82:	8526                	mv	a0,s1
    80003e84:	fffff097          	auipc	ra,0xfffff
    80003e88:	3ae080e7          	jalr	942(ra) # 80003232 <bread>
    80003e8c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e8e:	3ff97713          	andi	a4,s2,1023
    80003e92:	40ed07bb          	subw	a5,s10,a4
    80003e96:	414b06bb          	subw	a3,s6,s4
    80003e9a:	89be                	mv	s3,a5
    80003e9c:	2781                	sext.w	a5,a5
    80003e9e:	0006861b          	sext.w	a2,a3
    80003ea2:	f8f674e3          	bgeu	a2,a5,80003e2a <writei+0x4c>
    80003ea6:	89b6                	mv	s3,a3
    80003ea8:	b749                	j	80003e2a <writei+0x4c>
      brelse(bp);
    80003eaa:	8526                	mv	a0,s1
    80003eac:	fffff097          	auipc	ra,0xfffff
    80003eb0:	4b6080e7          	jalr	1206(ra) # 80003362 <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003eb4:	04cba783          	lw	a5,76(s7)
    80003eb8:	0127f463          	bgeu	a5,s2,80003ec0 <writei+0xe2>
      ip->size = off;
    80003ebc:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003ec0:	855e                	mv	a0,s7
    80003ec2:	00000097          	auipc	ra,0x0
    80003ec6:	aa8080e7          	jalr	-1368(ra) # 8000396a <iupdate>
  }

  return n;
    80003eca:	000b051b          	sext.w	a0,s6
}
    80003ece:	70a6                	ld	ra,104(sp)
    80003ed0:	7406                	ld	s0,96(sp)
    80003ed2:	64e6                	ld	s1,88(sp)
    80003ed4:	6946                	ld	s2,80(sp)
    80003ed6:	69a6                	ld	s3,72(sp)
    80003ed8:	6a06                	ld	s4,64(sp)
    80003eda:	7ae2                	ld	s5,56(sp)
    80003edc:	7b42                	ld	s6,48(sp)
    80003ede:	7ba2                	ld	s7,40(sp)
    80003ee0:	7c02                	ld	s8,32(sp)
    80003ee2:	6ce2                	ld	s9,24(sp)
    80003ee4:	6d42                	ld	s10,16(sp)
    80003ee6:	6da2                	ld	s11,8(sp)
    80003ee8:	6165                	addi	sp,sp,112
    80003eea:	8082                	ret
    return -1;
    80003eec:	557d                	li	a0,-1
}
    80003eee:	8082                	ret
    return -1;
    80003ef0:	557d                	li	a0,-1
    80003ef2:	bff1                	j	80003ece <writei+0xf0>
    return -1;
    80003ef4:	557d                	li	a0,-1
    80003ef6:	bfe1                	j	80003ece <writei+0xf0>

0000000080003ef8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003ef8:	1141                	addi	sp,sp,-16
    80003efa:	e406                	sd	ra,8(sp)
    80003efc:	e022                	sd	s0,0(sp)
    80003efe:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003f00:	4639                	li	a2,14
    80003f02:	ffffd097          	auipc	ra,0xffffd
    80003f06:	ee6080e7          	jalr	-282(ra) # 80000de8 <strncmp>
}
    80003f0a:	60a2                	ld	ra,8(sp)
    80003f0c:	6402                	ld	s0,0(sp)
    80003f0e:	0141                	addi	sp,sp,16
    80003f10:	8082                	ret

0000000080003f12 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003f12:	7139                	addi	sp,sp,-64
    80003f14:	fc06                	sd	ra,56(sp)
    80003f16:	f822                	sd	s0,48(sp)
    80003f18:	f426                	sd	s1,40(sp)
    80003f1a:	f04a                	sd	s2,32(sp)
    80003f1c:	ec4e                	sd	s3,24(sp)
    80003f1e:	e852                	sd	s4,16(sp)
    80003f20:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003f22:	04451703          	lh	a4,68(a0)
    80003f26:	4785                	li	a5,1
    80003f28:	00f71a63          	bne	a4,a5,80003f3c <dirlookup+0x2a>
    80003f2c:	892a                	mv	s2,a0
    80003f2e:	89ae                	mv	s3,a1
    80003f30:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f32:	457c                	lw	a5,76(a0)
    80003f34:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003f36:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f38:	e79d                	bnez	a5,80003f66 <dirlookup+0x54>
    80003f3a:	a8a5                	j	80003fb2 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003f3c:	00004517          	auipc	a0,0x4
    80003f40:	74c50513          	addi	a0,a0,1868 # 80008688 <syscalls+0x1a0>
    80003f44:	ffffc097          	auipc	ra,0xffffc
    80003f48:	604080e7          	jalr	1540(ra) # 80000548 <panic>
      panic("dirlookup read");
    80003f4c:	00004517          	auipc	a0,0x4
    80003f50:	75450513          	addi	a0,a0,1876 # 800086a0 <syscalls+0x1b8>
    80003f54:	ffffc097          	auipc	ra,0xffffc
    80003f58:	5f4080e7          	jalr	1524(ra) # 80000548 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f5c:	24c1                	addiw	s1,s1,16
    80003f5e:	04c92783          	lw	a5,76(s2)
    80003f62:	04f4f763          	bgeu	s1,a5,80003fb0 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f66:	4741                	li	a4,16
    80003f68:	86a6                	mv	a3,s1
    80003f6a:	fc040613          	addi	a2,s0,-64
    80003f6e:	4581                	li	a1,0
    80003f70:	854a                	mv	a0,s2
    80003f72:	00000097          	auipc	ra,0x0
    80003f76:	d76080e7          	jalr	-650(ra) # 80003ce8 <readi>
    80003f7a:	47c1                	li	a5,16
    80003f7c:	fcf518e3          	bne	a0,a5,80003f4c <dirlookup+0x3a>
    if(de.inum == 0)
    80003f80:	fc045783          	lhu	a5,-64(s0)
    80003f84:	dfe1                	beqz	a5,80003f5c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003f86:	fc240593          	addi	a1,s0,-62
    80003f8a:	854e                	mv	a0,s3
    80003f8c:	00000097          	auipc	ra,0x0
    80003f90:	f6c080e7          	jalr	-148(ra) # 80003ef8 <namecmp>
    80003f94:	f561                	bnez	a0,80003f5c <dirlookup+0x4a>
      if(poff)
    80003f96:	000a0463          	beqz	s4,80003f9e <dirlookup+0x8c>
        *poff = off;
    80003f9a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003f9e:	fc045583          	lhu	a1,-64(s0)
    80003fa2:	00092503          	lw	a0,0(s2)
    80003fa6:	fffff097          	auipc	ra,0xfffff
    80003faa:	75a080e7          	jalr	1882(ra) # 80003700 <iget>
    80003fae:	a011                	j	80003fb2 <dirlookup+0xa0>
  return 0;
    80003fb0:	4501                	li	a0,0
}
    80003fb2:	70e2                	ld	ra,56(sp)
    80003fb4:	7442                	ld	s0,48(sp)
    80003fb6:	74a2                	ld	s1,40(sp)
    80003fb8:	7902                	ld	s2,32(sp)
    80003fba:	69e2                	ld	s3,24(sp)
    80003fbc:	6a42                	ld	s4,16(sp)
    80003fbe:	6121                	addi	sp,sp,64
    80003fc0:	8082                	ret

0000000080003fc2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003fc2:	711d                	addi	sp,sp,-96
    80003fc4:	ec86                	sd	ra,88(sp)
    80003fc6:	e8a2                	sd	s0,80(sp)
    80003fc8:	e4a6                	sd	s1,72(sp)
    80003fca:	e0ca                	sd	s2,64(sp)
    80003fcc:	fc4e                	sd	s3,56(sp)
    80003fce:	f852                	sd	s4,48(sp)
    80003fd0:	f456                	sd	s5,40(sp)
    80003fd2:	f05a                	sd	s6,32(sp)
    80003fd4:	ec5e                	sd	s7,24(sp)
    80003fd6:	e862                	sd	s8,16(sp)
    80003fd8:	e466                	sd	s9,8(sp)
    80003fda:	1080                	addi	s0,sp,96
    80003fdc:	84aa                	mv	s1,a0
    80003fde:	8b2e                	mv	s6,a1
    80003fe0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003fe2:	00054703          	lbu	a4,0(a0)
    80003fe6:	02f00793          	li	a5,47
    80003fea:	02f70363          	beq	a4,a5,80004010 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003fee:	ffffe097          	auipc	ra,0xffffe
    80003ff2:	ce2080e7          	jalr	-798(ra) # 80001cd0 <myproc>
    80003ff6:	15853503          	ld	a0,344(a0)
    80003ffa:	00000097          	auipc	ra,0x0
    80003ffe:	9fc080e7          	jalr	-1540(ra) # 800039f6 <idup>
    80004002:	89aa                	mv	s3,a0
  while(*path == '/')
    80004004:	02f00913          	li	s2,47
  len = path - s;
    80004008:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000400a:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000400c:	4c05                	li	s8,1
    8000400e:	a865                	j	800040c6 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80004010:	4585                	li	a1,1
    80004012:	4505                	li	a0,1
    80004014:	fffff097          	auipc	ra,0xfffff
    80004018:	6ec080e7          	jalr	1772(ra) # 80003700 <iget>
    8000401c:	89aa                	mv	s3,a0
    8000401e:	b7dd                	j	80004004 <namex+0x42>
      iunlockput(ip);
    80004020:	854e                	mv	a0,s3
    80004022:	00000097          	auipc	ra,0x0
    80004026:	c74080e7          	jalr	-908(ra) # 80003c96 <iunlockput>
      return 0;
    8000402a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000402c:	854e                	mv	a0,s3
    8000402e:	60e6                	ld	ra,88(sp)
    80004030:	6446                	ld	s0,80(sp)
    80004032:	64a6                	ld	s1,72(sp)
    80004034:	6906                	ld	s2,64(sp)
    80004036:	79e2                	ld	s3,56(sp)
    80004038:	7a42                	ld	s4,48(sp)
    8000403a:	7aa2                	ld	s5,40(sp)
    8000403c:	7b02                	ld	s6,32(sp)
    8000403e:	6be2                	ld	s7,24(sp)
    80004040:	6c42                	ld	s8,16(sp)
    80004042:	6ca2                	ld	s9,8(sp)
    80004044:	6125                	addi	sp,sp,96
    80004046:	8082                	ret
      iunlock(ip);
    80004048:	854e                	mv	a0,s3
    8000404a:	00000097          	auipc	ra,0x0
    8000404e:	aac080e7          	jalr	-1364(ra) # 80003af6 <iunlock>
      return ip;
    80004052:	bfe9                	j	8000402c <namex+0x6a>
      iunlockput(ip);
    80004054:	854e                	mv	a0,s3
    80004056:	00000097          	auipc	ra,0x0
    8000405a:	c40080e7          	jalr	-960(ra) # 80003c96 <iunlockput>
      return 0;
    8000405e:	89d2                	mv	s3,s4
    80004060:	b7f1                	j	8000402c <namex+0x6a>
  len = path - s;
    80004062:	40b48633          	sub	a2,s1,a1
    80004066:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000406a:	094cd463          	bge	s9,s4,800040f2 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000406e:	4639                	li	a2,14
    80004070:	8556                	mv	a0,s5
    80004072:	ffffd097          	auipc	ra,0xffffd
    80004076:	cfa080e7          	jalr	-774(ra) # 80000d6c <memmove>
  while(*path == '/')
    8000407a:	0004c783          	lbu	a5,0(s1)
    8000407e:	01279763          	bne	a5,s2,8000408c <namex+0xca>
    path++;
    80004082:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004084:	0004c783          	lbu	a5,0(s1)
    80004088:	ff278de3          	beq	a5,s2,80004082 <namex+0xc0>
    ilock(ip);
    8000408c:	854e                	mv	a0,s3
    8000408e:	00000097          	auipc	ra,0x0
    80004092:	9a6080e7          	jalr	-1626(ra) # 80003a34 <ilock>
    if(ip->type != T_DIR){
    80004096:	04499783          	lh	a5,68(s3)
    8000409a:	f98793e3          	bne	a5,s8,80004020 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000409e:	000b0563          	beqz	s6,800040a8 <namex+0xe6>
    800040a2:	0004c783          	lbu	a5,0(s1)
    800040a6:	d3cd                	beqz	a5,80004048 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800040a8:	865e                	mv	a2,s7
    800040aa:	85d6                	mv	a1,s5
    800040ac:	854e                	mv	a0,s3
    800040ae:	00000097          	auipc	ra,0x0
    800040b2:	e64080e7          	jalr	-412(ra) # 80003f12 <dirlookup>
    800040b6:	8a2a                	mv	s4,a0
    800040b8:	dd51                	beqz	a0,80004054 <namex+0x92>
    iunlockput(ip);
    800040ba:	854e                	mv	a0,s3
    800040bc:	00000097          	auipc	ra,0x0
    800040c0:	bda080e7          	jalr	-1062(ra) # 80003c96 <iunlockput>
    ip = next;
    800040c4:	89d2                	mv	s3,s4
  while(*path == '/')
    800040c6:	0004c783          	lbu	a5,0(s1)
    800040ca:	05279763          	bne	a5,s2,80004118 <namex+0x156>
    path++;
    800040ce:	0485                	addi	s1,s1,1
  while(*path == '/')
    800040d0:	0004c783          	lbu	a5,0(s1)
    800040d4:	ff278de3          	beq	a5,s2,800040ce <namex+0x10c>
  if(*path == 0)
    800040d8:	c79d                	beqz	a5,80004106 <namex+0x144>
    path++;
    800040da:	85a6                	mv	a1,s1
  len = path - s;
    800040dc:	8a5e                	mv	s4,s7
    800040de:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800040e0:	01278963          	beq	a5,s2,800040f2 <namex+0x130>
    800040e4:	dfbd                	beqz	a5,80004062 <namex+0xa0>
    path++;
    800040e6:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800040e8:	0004c783          	lbu	a5,0(s1)
    800040ec:	ff279ce3          	bne	a5,s2,800040e4 <namex+0x122>
    800040f0:	bf8d                	j	80004062 <namex+0xa0>
    memmove(name, s, len);
    800040f2:	2601                	sext.w	a2,a2
    800040f4:	8556                	mv	a0,s5
    800040f6:	ffffd097          	auipc	ra,0xffffd
    800040fa:	c76080e7          	jalr	-906(ra) # 80000d6c <memmove>
    name[len] = 0;
    800040fe:	9a56                	add	s4,s4,s5
    80004100:	000a0023          	sb	zero,0(s4)
    80004104:	bf9d                	j	8000407a <namex+0xb8>
  if(nameiparent){
    80004106:	f20b03e3          	beqz	s6,8000402c <namex+0x6a>
    iput(ip);
    8000410a:	854e                	mv	a0,s3
    8000410c:	00000097          	auipc	ra,0x0
    80004110:	ae2080e7          	jalr	-1310(ra) # 80003bee <iput>
    return 0;
    80004114:	4981                	li	s3,0
    80004116:	bf19                	j	8000402c <namex+0x6a>
  if(*path == 0)
    80004118:	d7fd                	beqz	a5,80004106 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000411a:	0004c783          	lbu	a5,0(s1)
    8000411e:	85a6                	mv	a1,s1
    80004120:	b7d1                	j	800040e4 <namex+0x122>

0000000080004122 <dirlink>:
{
    80004122:	7139                	addi	sp,sp,-64
    80004124:	fc06                	sd	ra,56(sp)
    80004126:	f822                	sd	s0,48(sp)
    80004128:	f426                	sd	s1,40(sp)
    8000412a:	f04a                	sd	s2,32(sp)
    8000412c:	ec4e                	sd	s3,24(sp)
    8000412e:	e852                	sd	s4,16(sp)
    80004130:	0080                	addi	s0,sp,64
    80004132:	892a                	mv	s2,a0
    80004134:	8a2e                	mv	s4,a1
    80004136:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004138:	4601                	li	a2,0
    8000413a:	00000097          	auipc	ra,0x0
    8000413e:	dd8080e7          	jalr	-552(ra) # 80003f12 <dirlookup>
    80004142:	e93d                	bnez	a0,800041b8 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004144:	04c92483          	lw	s1,76(s2)
    80004148:	c49d                	beqz	s1,80004176 <dirlink+0x54>
    8000414a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000414c:	4741                	li	a4,16
    8000414e:	86a6                	mv	a3,s1
    80004150:	fc040613          	addi	a2,s0,-64
    80004154:	4581                	li	a1,0
    80004156:	854a                	mv	a0,s2
    80004158:	00000097          	auipc	ra,0x0
    8000415c:	b90080e7          	jalr	-1136(ra) # 80003ce8 <readi>
    80004160:	47c1                	li	a5,16
    80004162:	06f51163          	bne	a0,a5,800041c4 <dirlink+0xa2>
    if(de.inum == 0)
    80004166:	fc045783          	lhu	a5,-64(s0)
    8000416a:	c791                	beqz	a5,80004176 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000416c:	24c1                	addiw	s1,s1,16
    8000416e:	04c92783          	lw	a5,76(s2)
    80004172:	fcf4ede3          	bltu	s1,a5,8000414c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004176:	4639                	li	a2,14
    80004178:	85d2                	mv	a1,s4
    8000417a:	fc240513          	addi	a0,s0,-62
    8000417e:	ffffd097          	auipc	ra,0xffffd
    80004182:	ca6080e7          	jalr	-858(ra) # 80000e24 <strncpy>
  de.inum = inum;
    80004186:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000418a:	4741                	li	a4,16
    8000418c:	86a6                	mv	a3,s1
    8000418e:	fc040613          	addi	a2,s0,-64
    80004192:	4581                	li	a1,0
    80004194:	854a                	mv	a0,s2
    80004196:	00000097          	auipc	ra,0x0
    8000419a:	c48080e7          	jalr	-952(ra) # 80003dde <writei>
    8000419e:	872a                	mv	a4,a0
    800041a0:	47c1                	li	a5,16
  return 0;
    800041a2:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041a4:	02f71863          	bne	a4,a5,800041d4 <dirlink+0xb2>
}
    800041a8:	70e2                	ld	ra,56(sp)
    800041aa:	7442                	ld	s0,48(sp)
    800041ac:	74a2                	ld	s1,40(sp)
    800041ae:	7902                	ld	s2,32(sp)
    800041b0:	69e2                	ld	s3,24(sp)
    800041b2:	6a42                	ld	s4,16(sp)
    800041b4:	6121                	addi	sp,sp,64
    800041b6:	8082                	ret
    iput(ip);
    800041b8:	00000097          	auipc	ra,0x0
    800041bc:	a36080e7          	jalr	-1482(ra) # 80003bee <iput>
    return -1;
    800041c0:	557d                	li	a0,-1
    800041c2:	b7dd                	j	800041a8 <dirlink+0x86>
      panic("dirlink read");
    800041c4:	00004517          	auipc	a0,0x4
    800041c8:	4ec50513          	addi	a0,a0,1260 # 800086b0 <syscalls+0x1c8>
    800041cc:	ffffc097          	auipc	ra,0xffffc
    800041d0:	37c080e7          	jalr	892(ra) # 80000548 <panic>
    panic("dirlink");
    800041d4:	00004517          	auipc	a0,0x4
    800041d8:	5fc50513          	addi	a0,a0,1532 # 800087d0 <syscalls+0x2e8>
    800041dc:	ffffc097          	auipc	ra,0xffffc
    800041e0:	36c080e7          	jalr	876(ra) # 80000548 <panic>

00000000800041e4 <namei>:

struct inode*
namei(char *path)
{
    800041e4:	1101                	addi	sp,sp,-32
    800041e6:	ec06                	sd	ra,24(sp)
    800041e8:	e822                	sd	s0,16(sp)
    800041ea:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800041ec:	fe040613          	addi	a2,s0,-32
    800041f0:	4581                	li	a1,0
    800041f2:	00000097          	auipc	ra,0x0
    800041f6:	dd0080e7          	jalr	-560(ra) # 80003fc2 <namex>
}
    800041fa:	60e2                	ld	ra,24(sp)
    800041fc:	6442                	ld	s0,16(sp)
    800041fe:	6105                	addi	sp,sp,32
    80004200:	8082                	ret

0000000080004202 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004202:	1141                	addi	sp,sp,-16
    80004204:	e406                	sd	ra,8(sp)
    80004206:	e022                	sd	s0,0(sp)
    80004208:	0800                	addi	s0,sp,16
    8000420a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000420c:	4585                	li	a1,1
    8000420e:	00000097          	auipc	ra,0x0
    80004212:	db4080e7          	jalr	-588(ra) # 80003fc2 <namex>
}
    80004216:	60a2                	ld	ra,8(sp)
    80004218:	6402                	ld	s0,0(sp)
    8000421a:	0141                	addi	sp,sp,16
    8000421c:	8082                	ret

000000008000421e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000421e:	1101                	addi	sp,sp,-32
    80004220:	ec06                	sd	ra,24(sp)
    80004222:	e822                	sd	s0,16(sp)
    80004224:	e426                	sd	s1,8(sp)
    80004226:	e04a                	sd	s2,0(sp)
    80004228:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000422a:	0001e917          	auipc	s2,0x1e
    8000422e:	8de90913          	addi	s2,s2,-1826 # 80021b08 <log>
    80004232:	01892583          	lw	a1,24(s2)
    80004236:	02892503          	lw	a0,40(s2)
    8000423a:	fffff097          	auipc	ra,0xfffff
    8000423e:	ff8080e7          	jalr	-8(ra) # 80003232 <bread>
    80004242:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004244:	02c92683          	lw	a3,44(s2)
    80004248:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000424a:	02d05763          	blez	a3,80004278 <write_head+0x5a>
    8000424e:	0001e797          	auipc	a5,0x1e
    80004252:	8ea78793          	addi	a5,a5,-1814 # 80021b38 <log+0x30>
    80004256:	05c50713          	addi	a4,a0,92
    8000425a:	36fd                	addiw	a3,a3,-1
    8000425c:	1682                	slli	a3,a3,0x20
    8000425e:	9281                	srli	a3,a3,0x20
    80004260:	068a                	slli	a3,a3,0x2
    80004262:	0001e617          	auipc	a2,0x1e
    80004266:	8da60613          	addi	a2,a2,-1830 # 80021b3c <log+0x34>
    8000426a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000426c:	4390                	lw	a2,0(a5)
    8000426e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004270:	0791                	addi	a5,a5,4
    80004272:	0711                	addi	a4,a4,4
    80004274:	fed79ce3          	bne	a5,a3,8000426c <write_head+0x4e>
  }
  bwrite(buf);
    80004278:	8526                	mv	a0,s1
    8000427a:	fffff097          	auipc	ra,0xfffff
    8000427e:	0aa080e7          	jalr	170(ra) # 80003324 <bwrite>
  brelse(buf);
    80004282:	8526                	mv	a0,s1
    80004284:	fffff097          	auipc	ra,0xfffff
    80004288:	0de080e7          	jalr	222(ra) # 80003362 <brelse>
}
    8000428c:	60e2                	ld	ra,24(sp)
    8000428e:	6442                	ld	s0,16(sp)
    80004290:	64a2                	ld	s1,8(sp)
    80004292:	6902                	ld	s2,0(sp)
    80004294:	6105                	addi	sp,sp,32
    80004296:	8082                	ret

0000000080004298 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004298:	0001e797          	auipc	a5,0x1e
    8000429c:	89c7a783          	lw	a5,-1892(a5) # 80021b34 <log+0x2c>
    800042a0:	0af05663          	blez	a5,8000434c <install_trans+0xb4>
{
    800042a4:	7139                	addi	sp,sp,-64
    800042a6:	fc06                	sd	ra,56(sp)
    800042a8:	f822                	sd	s0,48(sp)
    800042aa:	f426                	sd	s1,40(sp)
    800042ac:	f04a                	sd	s2,32(sp)
    800042ae:	ec4e                	sd	s3,24(sp)
    800042b0:	e852                	sd	s4,16(sp)
    800042b2:	e456                	sd	s5,8(sp)
    800042b4:	0080                	addi	s0,sp,64
    800042b6:	0001ea97          	auipc	s5,0x1e
    800042ba:	882a8a93          	addi	s5,s5,-1918 # 80021b38 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800042be:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800042c0:	0001e997          	auipc	s3,0x1e
    800042c4:	84898993          	addi	s3,s3,-1976 # 80021b08 <log>
    800042c8:	0189a583          	lw	a1,24(s3)
    800042cc:	014585bb          	addw	a1,a1,s4
    800042d0:	2585                	addiw	a1,a1,1
    800042d2:	0289a503          	lw	a0,40(s3)
    800042d6:	fffff097          	auipc	ra,0xfffff
    800042da:	f5c080e7          	jalr	-164(ra) # 80003232 <bread>
    800042de:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800042e0:	000aa583          	lw	a1,0(s5)
    800042e4:	0289a503          	lw	a0,40(s3)
    800042e8:	fffff097          	auipc	ra,0xfffff
    800042ec:	f4a080e7          	jalr	-182(ra) # 80003232 <bread>
    800042f0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800042f2:	40000613          	li	a2,1024
    800042f6:	05890593          	addi	a1,s2,88
    800042fa:	05850513          	addi	a0,a0,88
    800042fe:	ffffd097          	auipc	ra,0xffffd
    80004302:	a6e080e7          	jalr	-1426(ra) # 80000d6c <memmove>
    bwrite(dbuf);  // write dst to disk
    80004306:	8526                	mv	a0,s1
    80004308:	fffff097          	auipc	ra,0xfffff
    8000430c:	01c080e7          	jalr	28(ra) # 80003324 <bwrite>
    bunpin(dbuf);
    80004310:	8526                	mv	a0,s1
    80004312:	fffff097          	auipc	ra,0xfffff
    80004316:	12a080e7          	jalr	298(ra) # 8000343c <bunpin>
    brelse(lbuf);
    8000431a:	854a                	mv	a0,s2
    8000431c:	fffff097          	auipc	ra,0xfffff
    80004320:	046080e7          	jalr	70(ra) # 80003362 <brelse>
    brelse(dbuf);
    80004324:	8526                	mv	a0,s1
    80004326:	fffff097          	auipc	ra,0xfffff
    8000432a:	03c080e7          	jalr	60(ra) # 80003362 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000432e:	2a05                	addiw	s4,s4,1
    80004330:	0a91                	addi	s5,s5,4
    80004332:	02c9a783          	lw	a5,44(s3)
    80004336:	f8fa49e3          	blt	s4,a5,800042c8 <install_trans+0x30>
}
    8000433a:	70e2                	ld	ra,56(sp)
    8000433c:	7442                	ld	s0,48(sp)
    8000433e:	74a2                	ld	s1,40(sp)
    80004340:	7902                	ld	s2,32(sp)
    80004342:	69e2                	ld	s3,24(sp)
    80004344:	6a42                	ld	s4,16(sp)
    80004346:	6aa2                	ld	s5,8(sp)
    80004348:	6121                	addi	sp,sp,64
    8000434a:	8082                	ret
    8000434c:	8082                	ret

000000008000434e <initlog>:
{
    8000434e:	7179                	addi	sp,sp,-48
    80004350:	f406                	sd	ra,40(sp)
    80004352:	f022                	sd	s0,32(sp)
    80004354:	ec26                	sd	s1,24(sp)
    80004356:	e84a                	sd	s2,16(sp)
    80004358:	e44e                	sd	s3,8(sp)
    8000435a:	1800                	addi	s0,sp,48
    8000435c:	892a                	mv	s2,a0
    8000435e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004360:	0001d497          	auipc	s1,0x1d
    80004364:	7a848493          	addi	s1,s1,1960 # 80021b08 <log>
    80004368:	00004597          	auipc	a1,0x4
    8000436c:	35858593          	addi	a1,a1,856 # 800086c0 <syscalls+0x1d8>
    80004370:	8526                	mv	a0,s1
    80004372:	ffffd097          	auipc	ra,0xffffd
    80004376:	80e080e7          	jalr	-2034(ra) # 80000b80 <initlock>
  log.start = sb->logstart;
    8000437a:	0149a583          	lw	a1,20(s3)
    8000437e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004380:	0109a783          	lw	a5,16(s3)
    80004384:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004386:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000438a:	854a                	mv	a0,s2
    8000438c:	fffff097          	auipc	ra,0xfffff
    80004390:	ea6080e7          	jalr	-346(ra) # 80003232 <bread>
  log.lh.n = lh->n;
    80004394:	4d3c                	lw	a5,88(a0)
    80004396:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004398:	02f05563          	blez	a5,800043c2 <initlog+0x74>
    8000439c:	05c50713          	addi	a4,a0,92
    800043a0:	0001d697          	auipc	a3,0x1d
    800043a4:	79868693          	addi	a3,a3,1944 # 80021b38 <log+0x30>
    800043a8:	37fd                	addiw	a5,a5,-1
    800043aa:	1782                	slli	a5,a5,0x20
    800043ac:	9381                	srli	a5,a5,0x20
    800043ae:	078a                	slli	a5,a5,0x2
    800043b0:	06050613          	addi	a2,a0,96
    800043b4:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800043b6:	4310                	lw	a2,0(a4)
    800043b8:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800043ba:	0711                	addi	a4,a4,4
    800043bc:	0691                	addi	a3,a3,4
    800043be:	fef71ce3          	bne	a4,a5,800043b6 <initlog+0x68>
  brelse(buf);
    800043c2:	fffff097          	auipc	ra,0xfffff
    800043c6:	fa0080e7          	jalr	-96(ra) # 80003362 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    800043ca:	00000097          	auipc	ra,0x0
    800043ce:	ece080e7          	jalr	-306(ra) # 80004298 <install_trans>
  log.lh.n = 0;
    800043d2:	0001d797          	auipc	a5,0x1d
    800043d6:	7607a123          	sw	zero,1890(a5) # 80021b34 <log+0x2c>
  write_head(); // clear the log
    800043da:	00000097          	auipc	ra,0x0
    800043de:	e44080e7          	jalr	-444(ra) # 8000421e <write_head>
}
    800043e2:	70a2                	ld	ra,40(sp)
    800043e4:	7402                	ld	s0,32(sp)
    800043e6:	64e2                	ld	s1,24(sp)
    800043e8:	6942                	ld	s2,16(sp)
    800043ea:	69a2                	ld	s3,8(sp)
    800043ec:	6145                	addi	sp,sp,48
    800043ee:	8082                	ret

00000000800043f0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800043f0:	1101                	addi	sp,sp,-32
    800043f2:	ec06                	sd	ra,24(sp)
    800043f4:	e822                	sd	s0,16(sp)
    800043f6:	e426                	sd	s1,8(sp)
    800043f8:	e04a                	sd	s2,0(sp)
    800043fa:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800043fc:	0001d517          	auipc	a0,0x1d
    80004400:	70c50513          	addi	a0,a0,1804 # 80021b08 <log>
    80004404:	ffffd097          	auipc	ra,0xffffd
    80004408:	80c080e7          	jalr	-2036(ra) # 80000c10 <acquire>
  while(1){
    if(log.committing){
    8000440c:	0001d497          	auipc	s1,0x1d
    80004410:	6fc48493          	addi	s1,s1,1788 # 80021b08 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004414:	4979                	li	s2,30
    80004416:	a039                	j	80004424 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004418:	85a6                	mv	a1,s1
    8000441a:	8526                	mv	a0,s1
    8000441c:	ffffe097          	auipc	ra,0xffffe
    80004420:	1f8080e7          	jalr	504(ra) # 80002614 <sleep>
    if(log.committing){
    80004424:	50dc                	lw	a5,36(s1)
    80004426:	fbed                	bnez	a5,80004418 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004428:	509c                	lw	a5,32(s1)
    8000442a:	0017871b          	addiw	a4,a5,1
    8000442e:	0007069b          	sext.w	a3,a4
    80004432:	0027179b          	slliw	a5,a4,0x2
    80004436:	9fb9                	addw	a5,a5,a4
    80004438:	0017979b          	slliw	a5,a5,0x1
    8000443c:	54d8                	lw	a4,44(s1)
    8000443e:	9fb9                	addw	a5,a5,a4
    80004440:	00f95963          	bge	s2,a5,80004452 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004444:	85a6                	mv	a1,s1
    80004446:	8526                	mv	a0,s1
    80004448:	ffffe097          	auipc	ra,0xffffe
    8000444c:	1cc080e7          	jalr	460(ra) # 80002614 <sleep>
    80004450:	bfd1                	j	80004424 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004452:	0001d517          	auipc	a0,0x1d
    80004456:	6b650513          	addi	a0,a0,1718 # 80021b08 <log>
    8000445a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000445c:	ffffd097          	auipc	ra,0xffffd
    80004460:	868080e7          	jalr	-1944(ra) # 80000cc4 <release>
      break;
    }
  }
}
    80004464:	60e2                	ld	ra,24(sp)
    80004466:	6442                	ld	s0,16(sp)
    80004468:	64a2                	ld	s1,8(sp)
    8000446a:	6902                	ld	s2,0(sp)
    8000446c:	6105                	addi	sp,sp,32
    8000446e:	8082                	ret

0000000080004470 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004470:	7139                	addi	sp,sp,-64
    80004472:	fc06                	sd	ra,56(sp)
    80004474:	f822                	sd	s0,48(sp)
    80004476:	f426                	sd	s1,40(sp)
    80004478:	f04a                	sd	s2,32(sp)
    8000447a:	ec4e                	sd	s3,24(sp)
    8000447c:	e852                	sd	s4,16(sp)
    8000447e:	e456                	sd	s5,8(sp)
    80004480:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004482:	0001d497          	auipc	s1,0x1d
    80004486:	68648493          	addi	s1,s1,1670 # 80021b08 <log>
    8000448a:	8526                	mv	a0,s1
    8000448c:	ffffc097          	auipc	ra,0xffffc
    80004490:	784080e7          	jalr	1924(ra) # 80000c10 <acquire>
  log.outstanding -= 1;
    80004494:	509c                	lw	a5,32(s1)
    80004496:	37fd                	addiw	a5,a5,-1
    80004498:	0007891b          	sext.w	s2,a5
    8000449c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000449e:	50dc                	lw	a5,36(s1)
    800044a0:	efb9                	bnez	a5,800044fe <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800044a2:	06091663          	bnez	s2,8000450e <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800044a6:	0001d497          	auipc	s1,0x1d
    800044aa:	66248493          	addi	s1,s1,1634 # 80021b08 <log>
    800044ae:	4785                	li	a5,1
    800044b0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800044b2:	8526                	mv	a0,s1
    800044b4:	ffffd097          	auipc	ra,0xffffd
    800044b8:	810080e7          	jalr	-2032(ra) # 80000cc4 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800044bc:	54dc                	lw	a5,44(s1)
    800044be:	06f04763          	bgtz	a5,8000452c <end_op+0xbc>
    acquire(&log.lock);
    800044c2:	0001d497          	auipc	s1,0x1d
    800044c6:	64648493          	addi	s1,s1,1606 # 80021b08 <log>
    800044ca:	8526                	mv	a0,s1
    800044cc:	ffffc097          	auipc	ra,0xffffc
    800044d0:	744080e7          	jalr	1860(ra) # 80000c10 <acquire>
    log.committing = 0;
    800044d4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800044d8:	8526                	mv	a0,s1
    800044da:	ffffe097          	auipc	ra,0xffffe
    800044de:	2c0080e7          	jalr	704(ra) # 8000279a <wakeup>
    release(&log.lock);
    800044e2:	8526                	mv	a0,s1
    800044e4:	ffffc097          	auipc	ra,0xffffc
    800044e8:	7e0080e7          	jalr	2016(ra) # 80000cc4 <release>
}
    800044ec:	70e2                	ld	ra,56(sp)
    800044ee:	7442                	ld	s0,48(sp)
    800044f0:	74a2                	ld	s1,40(sp)
    800044f2:	7902                	ld	s2,32(sp)
    800044f4:	69e2                	ld	s3,24(sp)
    800044f6:	6a42                	ld	s4,16(sp)
    800044f8:	6aa2                	ld	s5,8(sp)
    800044fa:	6121                	addi	sp,sp,64
    800044fc:	8082                	ret
    panic("log.committing");
    800044fe:	00004517          	auipc	a0,0x4
    80004502:	1ca50513          	addi	a0,a0,458 # 800086c8 <syscalls+0x1e0>
    80004506:	ffffc097          	auipc	ra,0xffffc
    8000450a:	042080e7          	jalr	66(ra) # 80000548 <panic>
    wakeup(&log);
    8000450e:	0001d497          	auipc	s1,0x1d
    80004512:	5fa48493          	addi	s1,s1,1530 # 80021b08 <log>
    80004516:	8526                	mv	a0,s1
    80004518:	ffffe097          	auipc	ra,0xffffe
    8000451c:	282080e7          	jalr	642(ra) # 8000279a <wakeup>
  release(&log.lock);
    80004520:	8526                	mv	a0,s1
    80004522:	ffffc097          	auipc	ra,0xffffc
    80004526:	7a2080e7          	jalr	1954(ra) # 80000cc4 <release>
  if(do_commit){
    8000452a:	b7c9                	j	800044ec <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000452c:	0001da97          	auipc	s5,0x1d
    80004530:	60ca8a93          	addi	s5,s5,1548 # 80021b38 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004534:	0001da17          	auipc	s4,0x1d
    80004538:	5d4a0a13          	addi	s4,s4,1492 # 80021b08 <log>
    8000453c:	018a2583          	lw	a1,24(s4)
    80004540:	012585bb          	addw	a1,a1,s2
    80004544:	2585                	addiw	a1,a1,1
    80004546:	028a2503          	lw	a0,40(s4)
    8000454a:	fffff097          	auipc	ra,0xfffff
    8000454e:	ce8080e7          	jalr	-792(ra) # 80003232 <bread>
    80004552:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004554:	000aa583          	lw	a1,0(s5)
    80004558:	028a2503          	lw	a0,40(s4)
    8000455c:	fffff097          	auipc	ra,0xfffff
    80004560:	cd6080e7          	jalr	-810(ra) # 80003232 <bread>
    80004564:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004566:	40000613          	li	a2,1024
    8000456a:	05850593          	addi	a1,a0,88
    8000456e:	05848513          	addi	a0,s1,88
    80004572:	ffffc097          	auipc	ra,0xffffc
    80004576:	7fa080e7          	jalr	2042(ra) # 80000d6c <memmove>
    bwrite(to);  // write the log
    8000457a:	8526                	mv	a0,s1
    8000457c:	fffff097          	auipc	ra,0xfffff
    80004580:	da8080e7          	jalr	-600(ra) # 80003324 <bwrite>
    brelse(from);
    80004584:	854e                	mv	a0,s3
    80004586:	fffff097          	auipc	ra,0xfffff
    8000458a:	ddc080e7          	jalr	-548(ra) # 80003362 <brelse>
    brelse(to);
    8000458e:	8526                	mv	a0,s1
    80004590:	fffff097          	auipc	ra,0xfffff
    80004594:	dd2080e7          	jalr	-558(ra) # 80003362 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004598:	2905                	addiw	s2,s2,1
    8000459a:	0a91                	addi	s5,s5,4
    8000459c:	02ca2783          	lw	a5,44(s4)
    800045a0:	f8f94ee3          	blt	s2,a5,8000453c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800045a4:	00000097          	auipc	ra,0x0
    800045a8:	c7a080e7          	jalr	-902(ra) # 8000421e <write_head>
    install_trans(); // Now install writes to home locations
    800045ac:	00000097          	auipc	ra,0x0
    800045b0:	cec080e7          	jalr	-788(ra) # 80004298 <install_trans>
    log.lh.n = 0;
    800045b4:	0001d797          	auipc	a5,0x1d
    800045b8:	5807a023          	sw	zero,1408(a5) # 80021b34 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800045bc:	00000097          	auipc	ra,0x0
    800045c0:	c62080e7          	jalr	-926(ra) # 8000421e <write_head>
    800045c4:	bdfd                	j	800044c2 <end_op+0x52>

00000000800045c6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800045c6:	1101                	addi	sp,sp,-32
    800045c8:	ec06                	sd	ra,24(sp)
    800045ca:	e822                	sd	s0,16(sp)
    800045cc:	e426                	sd	s1,8(sp)
    800045ce:	e04a                	sd	s2,0(sp)
    800045d0:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800045d2:	0001d717          	auipc	a4,0x1d
    800045d6:	56272703          	lw	a4,1378(a4) # 80021b34 <log+0x2c>
    800045da:	47f5                	li	a5,29
    800045dc:	08e7c063          	blt	a5,a4,8000465c <log_write+0x96>
    800045e0:	84aa                	mv	s1,a0
    800045e2:	0001d797          	auipc	a5,0x1d
    800045e6:	5427a783          	lw	a5,1346(a5) # 80021b24 <log+0x1c>
    800045ea:	37fd                	addiw	a5,a5,-1
    800045ec:	06f75863          	bge	a4,a5,8000465c <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800045f0:	0001d797          	auipc	a5,0x1d
    800045f4:	5387a783          	lw	a5,1336(a5) # 80021b28 <log+0x20>
    800045f8:	06f05a63          	blez	a5,8000466c <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    800045fc:	0001d917          	auipc	s2,0x1d
    80004600:	50c90913          	addi	s2,s2,1292 # 80021b08 <log>
    80004604:	854a                	mv	a0,s2
    80004606:	ffffc097          	auipc	ra,0xffffc
    8000460a:	60a080e7          	jalr	1546(ra) # 80000c10 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    8000460e:	02c92603          	lw	a2,44(s2)
    80004612:	06c05563          	blez	a2,8000467c <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004616:	44cc                	lw	a1,12(s1)
    80004618:	0001d717          	auipc	a4,0x1d
    8000461c:	52070713          	addi	a4,a4,1312 # 80021b38 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004620:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004622:	4314                	lw	a3,0(a4)
    80004624:	04b68d63          	beq	a3,a1,8000467e <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    80004628:	2785                	addiw	a5,a5,1
    8000462a:	0711                	addi	a4,a4,4
    8000462c:	fec79be3          	bne	a5,a2,80004622 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004630:	0621                	addi	a2,a2,8
    80004632:	060a                	slli	a2,a2,0x2
    80004634:	0001d797          	auipc	a5,0x1d
    80004638:	4d478793          	addi	a5,a5,1236 # 80021b08 <log>
    8000463c:	963e                	add	a2,a2,a5
    8000463e:	44dc                	lw	a5,12(s1)
    80004640:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004642:	8526                	mv	a0,s1
    80004644:	fffff097          	auipc	ra,0xfffff
    80004648:	dbc080e7          	jalr	-580(ra) # 80003400 <bpin>
    log.lh.n++;
    8000464c:	0001d717          	auipc	a4,0x1d
    80004650:	4bc70713          	addi	a4,a4,1212 # 80021b08 <log>
    80004654:	575c                	lw	a5,44(a4)
    80004656:	2785                	addiw	a5,a5,1
    80004658:	d75c                	sw	a5,44(a4)
    8000465a:	a83d                	j	80004698 <log_write+0xd2>
    panic("too big a transaction");
    8000465c:	00004517          	auipc	a0,0x4
    80004660:	07c50513          	addi	a0,a0,124 # 800086d8 <syscalls+0x1f0>
    80004664:	ffffc097          	auipc	ra,0xffffc
    80004668:	ee4080e7          	jalr	-284(ra) # 80000548 <panic>
    panic("log_write outside of trans");
    8000466c:	00004517          	auipc	a0,0x4
    80004670:	08450513          	addi	a0,a0,132 # 800086f0 <syscalls+0x208>
    80004674:	ffffc097          	auipc	ra,0xffffc
    80004678:	ed4080e7          	jalr	-300(ra) # 80000548 <panic>
  for (i = 0; i < log.lh.n; i++) {
    8000467c:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    8000467e:	00878713          	addi	a4,a5,8
    80004682:	00271693          	slli	a3,a4,0x2
    80004686:	0001d717          	auipc	a4,0x1d
    8000468a:	48270713          	addi	a4,a4,1154 # 80021b08 <log>
    8000468e:	9736                	add	a4,a4,a3
    80004690:	44d4                	lw	a3,12(s1)
    80004692:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004694:	faf607e3          	beq	a2,a5,80004642 <log_write+0x7c>
  }
  release(&log.lock);
    80004698:	0001d517          	auipc	a0,0x1d
    8000469c:	47050513          	addi	a0,a0,1136 # 80021b08 <log>
    800046a0:	ffffc097          	auipc	ra,0xffffc
    800046a4:	624080e7          	jalr	1572(ra) # 80000cc4 <release>
}
    800046a8:	60e2                	ld	ra,24(sp)
    800046aa:	6442                	ld	s0,16(sp)
    800046ac:	64a2                	ld	s1,8(sp)
    800046ae:	6902                	ld	s2,0(sp)
    800046b0:	6105                	addi	sp,sp,32
    800046b2:	8082                	ret

00000000800046b4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800046b4:	1101                	addi	sp,sp,-32
    800046b6:	ec06                	sd	ra,24(sp)
    800046b8:	e822                	sd	s0,16(sp)
    800046ba:	e426                	sd	s1,8(sp)
    800046bc:	e04a                	sd	s2,0(sp)
    800046be:	1000                	addi	s0,sp,32
    800046c0:	84aa                	mv	s1,a0
    800046c2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800046c4:	00004597          	auipc	a1,0x4
    800046c8:	04c58593          	addi	a1,a1,76 # 80008710 <syscalls+0x228>
    800046cc:	0521                	addi	a0,a0,8
    800046ce:	ffffc097          	auipc	ra,0xffffc
    800046d2:	4b2080e7          	jalr	1202(ra) # 80000b80 <initlock>
  lk->name = name;
    800046d6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800046da:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800046de:	0204a423          	sw	zero,40(s1)
}
    800046e2:	60e2                	ld	ra,24(sp)
    800046e4:	6442                	ld	s0,16(sp)
    800046e6:	64a2                	ld	s1,8(sp)
    800046e8:	6902                	ld	s2,0(sp)
    800046ea:	6105                	addi	sp,sp,32
    800046ec:	8082                	ret

00000000800046ee <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800046ee:	1101                	addi	sp,sp,-32
    800046f0:	ec06                	sd	ra,24(sp)
    800046f2:	e822                	sd	s0,16(sp)
    800046f4:	e426                	sd	s1,8(sp)
    800046f6:	e04a                	sd	s2,0(sp)
    800046f8:	1000                	addi	s0,sp,32
    800046fa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800046fc:	00850913          	addi	s2,a0,8
    80004700:	854a                	mv	a0,s2
    80004702:	ffffc097          	auipc	ra,0xffffc
    80004706:	50e080e7          	jalr	1294(ra) # 80000c10 <acquire>
  while (lk->locked) {
    8000470a:	409c                	lw	a5,0(s1)
    8000470c:	cb89                	beqz	a5,8000471e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000470e:	85ca                	mv	a1,s2
    80004710:	8526                	mv	a0,s1
    80004712:	ffffe097          	auipc	ra,0xffffe
    80004716:	f02080e7          	jalr	-254(ra) # 80002614 <sleep>
  while (lk->locked) {
    8000471a:	409c                	lw	a5,0(s1)
    8000471c:	fbed                	bnez	a5,8000470e <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000471e:	4785                	li	a5,1
    80004720:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004722:	ffffd097          	auipc	ra,0xffffd
    80004726:	5ae080e7          	jalr	1454(ra) # 80001cd0 <myproc>
    8000472a:	5d1c                	lw	a5,56(a0)
    8000472c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000472e:	854a                	mv	a0,s2
    80004730:	ffffc097          	auipc	ra,0xffffc
    80004734:	594080e7          	jalr	1428(ra) # 80000cc4 <release>
}
    80004738:	60e2                	ld	ra,24(sp)
    8000473a:	6442                	ld	s0,16(sp)
    8000473c:	64a2                	ld	s1,8(sp)
    8000473e:	6902                	ld	s2,0(sp)
    80004740:	6105                	addi	sp,sp,32
    80004742:	8082                	ret

0000000080004744 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004744:	1101                	addi	sp,sp,-32
    80004746:	ec06                	sd	ra,24(sp)
    80004748:	e822                	sd	s0,16(sp)
    8000474a:	e426                	sd	s1,8(sp)
    8000474c:	e04a                	sd	s2,0(sp)
    8000474e:	1000                	addi	s0,sp,32
    80004750:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004752:	00850913          	addi	s2,a0,8
    80004756:	854a                	mv	a0,s2
    80004758:	ffffc097          	auipc	ra,0xffffc
    8000475c:	4b8080e7          	jalr	1208(ra) # 80000c10 <acquire>
  lk->locked = 0;
    80004760:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004764:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004768:	8526                	mv	a0,s1
    8000476a:	ffffe097          	auipc	ra,0xffffe
    8000476e:	030080e7          	jalr	48(ra) # 8000279a <wakeup>
  release(&lk->lk);
    80004772:	854a                	mv	a0,s2
    80004774:	ffffc097          	auipc	ra,0xffffc
    80004778:	550080e7          	jalr	1360(ra) # 80000cc4 <release>
}
    8000477c:	60e2                	ld	ra,24(sp)
    8000477e:	6442                	ld	s0,16(sp)
    80004780:	64a2                	ld	s1,8(sp)
    80004782:	6902                	ld	s2,0(sp)
    80004784:	6105                	addi	sp,sp,32
    80004786:	8082                	ret

0000000080004788 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004788:	7179                	addi	sp,sp,-48
    8000478a:	f406                	sd	ra,40(sp)
    8000478c:	f022                	sd	s0,32(sp)
    8000478e:	ec26                	sd	s1,24(sp)
    80004790:	e84a                	sd	s2,16(sp)
    80004792:	e44e                	sd	s3,8(sp)
    80004794:	1800                	addi	s0,sp,48
    80004796:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004798:	00850913          	addi	s2,a0,8
    8000479c:	854a                	mv	a0,s2
    8000479e:	ffffc097          	auipc	ra,0xffffc
    800047a2:	472080e7          	jalr	1138(ra) # 80000c10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800047a6:	409c                	lw	a5,0(s1)
    800047a8:	ef99                	bnez	a5,800047c6 <holdingsleep+0x3e>
    800047aa:	4481                	li	s1,0
  release(&lk->lk);
    800047ac:	854a                	mv	a0,s2
    800047ae:	ffffc097          	auipc	ra,0xffffc
    800047b2:	516080e7          	jalr	1302(ra) # 80000cc4 <release>
  return r;
}
    800047b6:	8526                	mv	a0,s1
    800047b8:	70a2                	ld	ra,40(sp)
    800047ba:	7402                	ld	s0,32(sp)
    800047bc:	64e2                	ld	s1,24(sp)
    800047be:	6942                	ld	s2,16(sp)
    800047c0:	69a2                	ld	s3,8(sp)
    800047c2:	6145                	addi	sp,sp,48
    800047c4:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800047c6:	0284a983          	lw	s3,40(s1)
    800047ca:	ffffd097          	auipc	ra,0xffffd
    800047ce:	506080e7          	jalr	1286(ra) # 80001cd0 <myproc>
    800047d2:	5d04                	lw	s1,56(a0)
    800047d4:	413484b3          	sub	s1,s1,s3
    800047d8:	0014b493          	seqz	s1,s1
    800047dc:	bfc1                	j	800047ac <holdingsleep+0x24>

00000000800047de <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800047de:	1141                	addi	sp,sp,-16
    800047e0:	e406                	sd	ra,8(sp)
    800047e2:	e022                	sd	s0,0(sp)
    800047e4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800047e6:	00004597          	auipc	a1,0x4
    800047ea:	f3a58593          	addi	a1,a1,-198 # 80008720 <syscalls+0x238>
    800047ee:	0001d517          	auipc	a0,0x1d
    800047f2:	46250513          	addi	a0,a0,1122 # 80021c50 <ftable>
    800047f6:	ffffc097          	auipc	ra,0xffffc
    800047fa:	38a080e7          	jalr	906(ra) # 80000b80 <initlock>
}
    800047fe:	60a2                	ld	ra,8(sp)
    80004800:	6402                	ld	s0,0(sp)
    80004802:	0141                	addi	sp,sp,16
    80004804:	8082                	ret

0000000080004806 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004806:	1101                	addi	sp,sp,-32
    80004808:	ec06                	sd	ra,24(sp)
    8000480a:	e822                	sd	s0,16(sp)
    8000480c:	e426                	sd	s1,8(sp)
    8000480e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004810:	0001d517          	auipc	a0,0x1d
    80004814:	44050513          	addi	a0,a0,1088 # 80021c50 <ftable>
    80004818:	ffffc097          	auipc	ra,0xffffc
    8000481c:	3f8080e7          	jalr	1016(ra) # 80000c10 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004820:	0001d497          	auipc	s1,0x1d
    80004824:	44848493          	addi	s1,s1,1096 # 80021c68 <ftable+0x18>
    80004828:	0001e717          	auipc	a4,0x1e
    8000482c:	3e070713          	addi	a4,a4,992 # 80022c08 <ftable+0xfb8>
    if(f->ref == 0){
    80004830:	40dc                	lw	a5,4(s1)
    80004832:	cf99                	beqz	a5,80004850 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004834:	02848493          	addi	s1,s1,40
    80004838:	fee49ce3          	bne	s1,a4,80004830 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000483c:	0001d517          	auipc	a0,0x1d
    80004840:	41450513          	addi	a0,a0,1044 # 80021c50 <ftable>
    80004844:	ffffc097          	auipc	ra,0xffffc
    80004848:	480080e7          	jalr	1152(ra) # 80000cc4 <release>
  return 0;
    8000484c:	4481                	li	s1,0
    8000484e:	a819                	j	80004864 <filealloc+0x5e>
      f->ref = 1;
    80004850:	4785                	li	a5,1
    80004852:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004854:	0001d517          	auipc	a0,0x1d
    80004858:	3fc50513          	addi	a0,a0,1020 # 80021c50 <ftable>
    8000485c:	ffffc097          	auipc	ra,0xffffc
    80004860:	468080e7          	jalr	1128(ra) # 80000cc4 <release>
}
    80004864:	8526                	mv	a0,s1
    80004866:	60e2                	ld	ra,24(sp)
    80004868:	6442                	ld	s0,16(sp)
    8000486a:	64a2                	ld	s1,8(sp)
    8000486c:	6105                	addi	sp,sp,32
    8000486e:	8082                	ret

0000000080004870 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004870:	1101                	addi	sp,sp,-32
    80004872:	ec06                	sd	ra,24(sp)
    80004874:	e822                	sd	s0,16(sp)
    80004876:	e426                	sd	s1,8(sp)
    80004878:	1000                	addi	s0,sp,32
    8000487a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000487c:	0001d517          	auipc	a0,0x1d
    80004880:	3d450513          	addi	a0,a0,980 # 80021c50 <ftable>
    80004884:	ffffc097          	auipc	ra,0xffffc
    80004888:	38c080e7          	jalr	908(ra) # 80000c10 <acquire>
  if(f->ref < 1)
    8000488c:	40dc                	lw	a5,4(s1)
    8000488e:	02f05263          	blez	a5,800048b2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004892:	2785                	addiw	a5,a5,1
    80004894:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004896:	0001d517          	auipc	a0,0x1d
    8000489a:	3ba50513          	addi	a0,a0,954 # 80021c50 <ftable>
    8000489e:	ffffc097          	auipc	ra,0xffffc
    800048a2:	426080e7          	jalr	1062(ra) # 80000cc4 <release>
  return f;
}
    800048a6:	8526                	mv	a0,s1
    800048a8:	60e2                	ld	ra,24(sp)
    800048aa:	6442                	ld	s0,16(sp)
    800048ac:	64a2                	ld	s1,8(sp)
    800048ae:	6105                	addi	sp,sp,32
    800048b0:	8082                	ret
    panic("filedup");
    800048b2:	00004517          	auipc	a0,0x4
    800048b6:	e7650513          	addi	a0,a0,-394 # 80008728 <syscalls+0x240>
    800048ba:	ffffc097          	auipc	ra,0xffffc
    800048be:	c8e080e7          	jalr	-882(ra) # 80000548 <panic>

00000000800048c2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800048c2:	7139                	addi	sp,sp,-64
    800048c4:	fc06                	sd	ra,56(sp)
    800048c6:	f822                	sd	s0,48(sp)
    800048c8:	f426                	sd	s1,40(sp)
    800048ca:	f04a                	sd	s2,32(sp)
    800048cc:	ec4e                	sd	s3,24(sp)
    800048ce:	e852                	sd	s4,16(sp)
    800048d0:	e456                	sd	s5,8(sp)
    800048d2:	0080                	addi	s0,sp,64
    800048d4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800048d6:	0001d517          	auipc	a0,0x1d
    800048da:	37a50513          	addi	a0,a0,890 # 80021c50 <ftable>
    800048de:	ffffc097          	auipc	ra,0xffffc
    800048e2:	332080e7          	jalr	818(ra) # 80000c10 <acquire>
  if(f->ref < 1)
    800048e6:	40dc                	lw	a5,4(s1)
    800048e8:	06f05163          	blez	a5,8000494a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800048ec:	37fd                	addiw	a5,a5,-1
    800048ee:	0007871b          	sext.w	a4,a5
    800048f2:	c0dc                	sw	a5,4(s1)
    800048f4:	06e04363          	bgtz	a4,8000495a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800048f8:	0004a903          	lw	s2,0(s1)
    800048fc:	0094ca83          	lbu	s5,9(s1)
    80004900:	0104ba03          	ld	s4,16(s1)
    80004904:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004908:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000490c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004910:	0001d517          	auipc	a0,0x1d
    80004914:	34050513          	addi	a0,a0,832 # 80021c50 <ftable>
    80004918:	ffffc097          	auipc	ra,0xffffc
    8000491c:	3ac080e7          	jalr	940(ra) # 80000cc4 <release>

  if(ff.type == FD_PIPE){
    80004920:	4785                	li	a5,1
    80004922:	04f90d63          	beq	s2,a5,8000497c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004926:	3979                	addiw	s2,s2,-2
    80004928:	4785                	li	a5,1
    8000492a:	0527e063          	bltu	a5,s2,8000496a <fileclose+0xa8>
    begin_op();
    8000492e:	00000097          	auipc	ra,0x0
    80004932:	ac2080e7          	jalr	-1342(ra) # 800043f0 <begin_op>
    iput(ff.ip);
    80004936:	854e                	mv	a0,s3
    80004938:	fffff097          	auipc	ra,0xfffff
    8000493c:	2b6080e7          	jalr	694(ra) # 80003bee <iput>
    end_op();
    80004940:	00000097          	auipc	ra,0x0
    80004944:	b30080e7          	jalr	-1232(ra) # 80004470 <end_op>
    80004948:	a00d                	j	8000496a <fileclose+0xa8>
    panic("fileclose");
    8000494a:	00004517          	auipc	a0,0x4
    8000494e:	de650513          	addi	a0,a0,-538 # 80008730 <syscalls+0x248>
    80004952:	ffffc097          	auipc	ra,0xffffc
    80004956:	bf6080e7          	jalr	-1034(ra) # 80000548 <panic>
    release(&ftable.lock);
    8000495a:	0001d517          	auipc	a0,0x1d
    8000495e:	2f650513          	addi	a0,a0,758 # 80021c50 <ftable>
    80004962:	ffffc097          	auipc	ra,0xffffc
    80004966:	362080e7          	jalr	866(ra) # 80000cc4 <release>
  }
}
    8000496a:	70e2                	ld	ra,56(sp)
    8000496c:	7442                	ld	s0,48(sp)
    8000496e:	74a2                	ld	s1,40(sp)
    80004970:	7902                	ld	s2,32(sp)
    80004972:	69e2                	ld	s3,24(sp)
    80004974:	6a42                	ld	s4,16(sp)
    80004976:	6aa2                	ld	s5,8(sp)
    80004978:	6121                	addi	sp,sp,64
    8000497a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000497c:	85d6                	mv	a1,s5
    8000497e:	8552                	mv	a0,s4
    80004980:	00000097          	auipc	ra,0x0
    80004984:	372080e7          	jalr	882(ra) # 80004cf2 <pipeclose>
    80004988:	b7cd                	j	8000496a <fileclose+0xa8>

000000008000498a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000498a:	715d                	addi	sp,sp,-80
    8000498c:	e486                	sd	ra,72(sp)
    8000498e:	e0a2                	sd	s0,64(sp)
    80004990:	fc26                	sd	s1,56(sp)
    80004992:	f84a                	sd	s2,48(sp)
    80004994:	f44e                	sd	s3,40(sp)
    80004996:	0880                	addi	s0,sp,80
    80004998:	84aa                	mv	s1,a0
    8000499a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000499c:	ffffd097          	auipc	ra,0xffffd
    800049a0:	334080e7          	jalr	820(ra) # 80001cd0 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800049a4:	409c                	lw	a5,0(s1)
    800049a6:	37f9                	addiw	a5,a5,-2
    800049a8:	4705                	li	a4,1
    800049aa:	04f76763          	bltu	a4,a5,800049f8 <filestat+0x6e>
    800049ae:	892a                	mv	s2,a0
    ilock(f->ip);
    800049b0:	6c88                	ld	a0,24(s1)
    800049b2:	fffff097          	auipc	ra,0xfffff
    800049b6:	082080e7          	jalr	130(ra) # 80003a34 <ilock>
    stati(f->ip, &st);
    800049ba:	fb840593          	addi	a1,s0,-72
    800049be:	6c88                	ld	a0,24(s1)
    800049c0:	fffff097          	auipc	ra,0xfffff
    800049c4:	2fe080e7          	jalr	766(ra) # 80003cbe <stati>
    iunlock(f->ip);
    800049c8:	6c88                	ld	a0,24(s1)
    800049ca:	fffff097          	auipc	ra,0xfffff
    800049ce:	12c080e7          	jalr	300(ra) # 80003af6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800049d2:	46e1                	li	a3,24
    800049d4:	fb840613          	addi	a2,s0,-72
    800049d8:	85ce                	mv	a1,s3
    800049da:	05093503          	ld	a0,80(s2)
    800049de:	ffffd097          	auipc	ra,0xffffd
    800049e2:	096080e7          	jalr	150(ra) # 80001a74 <copyout>
    800049e6:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800049ea:	60a6                	ld	ra,72(sp)
    800049ec:	6406                	ld	s0,64(sp)
    800049ee:	74e2                	ld	s1,56(sp)
    800049f0:	7942                	ld	s2,48(sp)
    800049f2:	79a2                	ld	s3,40(sp)
    800049f4:	6161                	addi	sp,sp,80
    800049f6:	8082                	ret
  return -1;
    800049f8:	557d                	li	a0,-1
    800049fa:	bfc5                	j	800049ea <filestat+0x60>

00000000800049fc <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800049fc:	7179                	addi	sp,sp,-48
    800049fe:	f406                	sd	ra,40(sp)
    80004a00:	f022                	sd	s0,32(sp)
    80004a02:	ec26                	sd	s1,24(sp)
    80004a04:	e84a                	sd	s2,16(sp)
    80004a06:	e44e                	sd	s3,8(sp)
    80004a08:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004a0a:	00854783          	lbu	a5,8(a0)
    80004a0e:	c3d5                	beqz	a5,80004ab2 <fileread+0xb6>
    80004a10:	84aa                	mv	s1,a0
    80004a12:	89ae                	mv	s3,a1
    80004a14:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004a16:	411c                	lw	a5,0(a0)
    80004a18:	4705                	li	a4,1
    80004a1a:	04e78963          	beq	a5,a4,80004a6c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004a1e:	470d                	li	a4,3
    80004a20:	04e78d63          	beq	a5,a4,80004a7a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004a24:	4709                	li	a4,2
    80004a26:	06e79e63          	bne	a5,a4,80004aa2 <fileread+0xa6>
    ilock(f->ip);
    80004a2a:	6d08                	ld	a0,24(a0)
    80004a2c:	fffff097          	auipc	ra,0xfffff
    80004a30:	008080e7          	jalr	8(ra) # 80003a34 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004a34:	874a                	mv	a4,s2
    80004a36:	5094                	lw	a3,32(s1)
    80004a38:	864e                	mv	a2,s3
    80004a3a:	4585                	li	a1,1
    80004a3c:	6c88                	ld	a0,24(s1)
    80004a3e:	fffff097          	auipc	ra,0xfffff
    80004a42:	2aa080e7          	jalr	682(ra) # 80003ce8 <readi>
    80004a46:	892a                	mv	s2,a0
    80004a48:	00a05563          	blez	a0,80004a52 <fileread+0x56>
      f->off += r;
    80004a4c:	509c                	lw	a5,32(s1)
    80004a4e:	9fa9                	addw	a5,a5,a0
    80004a50:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004a52:	6c88                	ld	a0,24(s1)
    80004a54:	fffff097          	auipc	ra,0xfffff
    80004a58:	0a2080e7          	jalr	162(ra) # 80003af6 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004a5c:	854a                	mv	a0,s2
    80004a5e:	70a2                	ld	ra,40(sp)
    80004a60:	7402                	ld	s0,32(sp)
    80004a62:	64e2                	ld	s1,24(sp)
    80004a64:	6942                	ld	s2,16(sp)
    80004a66:	69a2                	ld	s3,8(sp)
    80004a68:	6145                	addi	sp,sp,48
    80004a6a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004a6c:	6908                	ld	a0,16(a0)
    80004a6e:	00000097          	auipc	ra,0x0
    80004a72:	418080e7          	jalr	1048(ra) # 80004e86 <piperead>
    80004a76:	892a                	mv	s2,a0
    80004a78:	b7d5                	j	80004a5c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004a7a:	02451783          	lh	a5,36(a0)
    80004a7e:	03079693          	slli	a3,a5,0x30
    80004a82:	92c1                	srli	a3,a3,0x30
    80004a84:	4725                	li	a4,9
    80004a86:	02d76863          	bltu	a4,a3,80004ab6 <fileread+0xba>
    80004a8a:	0792                	slli	a5,a5,0x4
    80004a8c:	0001d717          	auipc	a4,0x1d
    80004a90:	12470713          	addi	a4,a4,292 # 80021bb0 <devsw>
    80004a94:	97ba                	add	a5,a5,a4
    80004a96:	639c                	ld	a5,0(a5)
    80004a98:	c38d                	beqz	a5,80004aba <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004a9a:	4505                	li	a0,1
    80004a9c:	9782                	jalr	a5
    80004a9e:	892a                	mv	s2,a0
    80004aa0:	bf75                	j	80004a5c <fileread+0x60>
    panic("fileread");
    80004aa2:	00004517          	auipc	a0,0x4
    80004aa6:	c9e50513          	addi	a0,a0,-866 # 80008740 <syscalls+0x258>
    80004aaa:	ffffc097          	auipc	ra,0xffffc
    80004aae:	a9e080e7          	jalr	-1378(ra) # 80000548 <panic>
    return -1;
    80004ab2:	597d                	li	s2,-1
    80004ab4:	b765                	j	80004a5c <fileread+0x60>
      return -1;
    80004ab6:	597d                	li	s2,-1
    80004ab8:	b755                	j	80004a5c <fileread+0x60>
    80004aba:	597d                	li	s2,-1
    80004abc:	b745                	j	80004a5c <fileread+0x60>

0000000080004abe <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004abe:	00954783          	lbu	a5,9(a0)
    80004ac2:	14078563          	beqz	a5,80004c0c <filewrite+0x14e>
{
    80004ac6:	715d                	addi	sp,sp,-80
    80004ac8:	e486                	sd	ra,72(sp)
    80004aca:	e0a2                	sd	s0,64(sp)
    80004acc:	fc26                	sd	s1,56(sp)
    80004ace:	f84a                	sd	s2,48(sp)
    80004ad0:	f44e                	sd	s3,40(sp)
    80004ad2:	f052                	sd	s4,32(sp)
    80004ad4:	ec56                	sd	s5,24(sp)
    80004ad6:	e85a                	sd	s6,16(sp)
    80004ad8:	e45e                	sd	s7,8(sp)
    80004ada:	e062                	sd	s8,0(sp)
    80004adc:	0880                	addi	s0,sp,80
    80004ade:	892a                	mv	s2,a0
    80004ae0:	8aae                	mv	s5,a1
    80004ae2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004ae4:	411c                	lw	a5,0(a0)
    80004ae6:	4705                	li	a4,1
    80004ae8:	02e78263          	beq	a5,a4,80004b0c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004aec:	470d                	li	a4,3
    80004aee:	02e78563          	beq	a5,a4,80004b18 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004af2:	4709                	li	a4,2
    80004af4:	10e79463          	bne	a5,a4,80004bfc <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004af8:	0ec05e63          	blez	a2,80004bf4 <filewrite+0x136>
    int i = 0;
    80004afc:	4981                	li	s3,0
    80004afe:	6b05                	lui	s6,0x1
    80004b00:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004b04:	6b85                	lui	s7,0x1
    80004b06:	c00b8b9b          	addiw	s7,s7,-1024
    80004b0a:	a851                	j	80004b9e <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004b0c:	6908                	ld	a0,16(a0)
    80004b0e:	00000097          	auipc	ra,0x0
    80004b12:	254080e7          	jalr	596(ra) # 80004d62 <pipewrite>
    80004b16:	a85d                	j	80004bcc <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004b18:	02451783          	lh	a5,36(a0)
    80004b1c:	03079693          	slli	a3,a5,0x30
    80004b20:	92c1                	srli	a3,a3,0x30
    80004b22:	4725                	li	a4,9
    80004b24:	0ed76663          	bltu	a4,a3,80004c10 <filewrite+0x152>
    80004b28:	0792                	slli	a5,a5,0x4
    80004b2a:	0001d717          	auipc	a4,0x1d
    80004b2e:	08670713          	addi	a4,a4,134 # 80021bb0 <devsw>
    80004b32:	97ba                	add	a5,a5,a4
    80004b34:	679c                	ld	a5,8(a5)
    80004b36:	cff9                	beqz	a5,80004c14 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    80004b38:	4505                	li	a0,1
    80004b3a:	9782                	jalr	a5
    80004b3c:	a841                	j	80004bcc <filewrite+0x10e>
    80004b3e:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004b42:	00000097          	auipc	ra,0x0
    80004b46:	8ae080e7          	jalr	-1874(ra) # 800043f0 <begin_op>
      ilock(f->ip);
    80004b4a:	01893503          	ld	a0,24(s2)
    80004b4e:	fffff097          	auipc	ra,0xfffff
    80004b52:	ee6080e7          	jalr	-282(ra) # 80003a34 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004b56:	8762                	mv	a4,s8
    80004b58:	02092683          	lw	a3,32(s2)
    80004b5c:	01598633          	add	a2,s3,s5
    80004b60:	4585                	li	a1,1
    80004b62:	01893503          	ld	a0,24(s2)
    80004b66:	fffff097          	auipc	ra,0xfffff
    80004b6a:	278080e7          	jalr	632(ra) # 80003dde <writei>
    80004b6e:	84aa                	mv	s1,a0
    80004b70:	02a05f63          	blez	a0,80004bae <filewrite+0xf0>
        f->off += r;
    80004b74:	02092783          	lw	a5,32(s2)
    80004b78:	9fa9                	addw	a5,a5,a0
    80004b7a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004b7e:	01893503          	ld	a0,24(s2)
    80004b82:	fffff097          	auipc	ra,0xfffff
    80004b86:	f74080e7          	jalr	-140(ra) # 80003af6 <iunlock>
      end_op();
    80004b8a:	00000097          	auipc	ra,0x0
    80004b8e:	8e6080e7          	jalr	-1818(ra) # 80004470 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004b92:	049c1963          	bne	s8,s1,80004be4 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    80004b96:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004b9a:	0349d663          	bge	s3,s4,80004bc6 <filewrite+0x108>
      int n1 = n - i;
    80004b9e:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004ba2:	84be                	mv	s1,a5
    80004ba4:	2781                	sext.w	a5,a5
    80004ba6:	f8fb5ce3          	bge	s6,a5,80004b3e <filewrite+0x80>
    80004baa:	84de                	mv	s1,s7
    80004bac:	bf49                	j	80004b3e <filewrite+0x80>
      iunlock(f->ip);
    80004bae:	01893503          	ld	a0,24(s2)
    80004bb2:	fffff097          	auipc	ra,0xfffff
    80004bb6:	f44080e7          	jalr	-188(ra) # 80003af6 <iunlock>
      end_op();
    80004bba:	00000097          	auipc	ra,0x0
    80004bbe:	8b6080e7          	jalr	-1866(ra) # 80004470 <end_op>
      if(r < 0)
    80004bc2:	fc04d8e3          	bgez	s1,80004b92 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004bc6:	8552                	mv	a0,s4
    80004bc8:	033a1863          	bne	s4,s3,80004bf8 <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004bcc:	60a6                	ld	ra,72(sp)
    80004bce:	6406                	ld	s0,64(sp)
    80004bd0:	74e2                	ld	s1,56(sp)
    80004bd2:	7942                	ld	s2,48(sp)
    80004bd4:	79a2                	ld	s3,40(sp)
    80004bd6:	7a02                	ld	s4,32(sp)
    80004bd8:	6ae2                	ld	s5,24(sp)
    80004bda:	6b42                	ld	s6,16(sp)
    80004bdc:	6ba2                	ld	s7,8(sp)
    80004bde:	6c02                	ld	s8,0(sp)
    80004be0:	6161                	addi	sp,sp,80
    80004be2:	8082                	ret
        panic("short filewrite");
    80004be4:	00004517          	auipc	a0,0x4
    80004be8:	b6c50513          	addi	a0,a0,-1172 # 80008750 <syscalls+0x268>
    80004bec:	ffffc097          	auipc	ra,0xffffc
    80004bf0:	95c080e7          	jalr	-1700(ra) # 80000548 <panic>
    int i = 0;
    80004bf4:	4981                	li	s3,0
    80004bf6:	bfc1                	j	80004bc6 <filewrite+0x108>
    ret = (i == n ? n : -1);
    80004bf8:	557d                	li	a0,-1
    80004bfa:	bfc9                	j	80004bcc <filewrite+0x10e>
    panic("filewrite");
    80004bfc:	00004517          	auipc	a0,0x4
    80004c00:	b6450513          	addi	a0,a0,-1180 # 80008760 <syscalls+0x278>
    80004c04:	ffffc097          	auipc	ra,0xffffc
    80004c08:	944080e7          	jalr	-1724(ra) # 80000548 <panic>
    return -1;
    80004c0c:	557d                	li	a0,-1
}
    80004c0e:	8082                	ret
      return -1;
    80004c10:	557d                	li	a0,-1
    80004c12:	bf6d                	j	80004bcc <filewrite+0x10e>
    80004c14:	557d                	li	a0,-1
    80004c16:	bf5d                	j	80004bcc <filewrite+0x10e>

0000000080004c18 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004c18:	7179                	addi	sp,sp,-48
    80004c1a:	f406                	sd	ra,40(sp)
    80004c1c:	f022                	sd	s0,32(sp)
    80004c1e:	ec26                	sd	s1,24(sp)
    80004c20:	e84a                	sd	s2,16(sp)
    80004c22:	e44e                	sd	s3,8(sp)
    80004c24:	e052                	sd	s4,0(sp)
    80004c26:	1800                	addi	s0,sp,48
    80004c28:	84aa                	mv	s1,a0
    80004c2a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004c2c:	0005b023          	sd	zero,0(a1)
    80004c30:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004c34:	00000097          	auipc	ra,0x0
    80004c38:	bd2080e7          	jalr	-1070(ra) # 80004806 <filealloc>
    80004c3c:	e088                	sd	a0,0(s1)
    80004c3e:	c551                	beqz	a0,80004cca <pipealloc+0xb2>
    80004c40:	00000097          	auipc	ra,0x0
    80004c44:	bc6080e7          	jalr	-1082(ra) # 80004806 <filealloc>
    80004c48:	00aa3023          	sd	a0,0(s4)
    80004c4c:	c92d                	beqz	a0,80004cbe <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004c4e:	ffffc097          	auipc	ra,0xffffc
    80004c52:	ed2080e7          	jalr	-302(ra) # 80000b20 <kalloc>
    80004c56:	892a                	mv	s2,a0
    80004c58:	c125                	beqz	a0,80004cb8 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004c5a:	4985                	li	s3,1
    80004c5c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004c60:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004c64:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004c68:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004c6c:	00004597          	auipc	a1,0x4
    80004c70:	b0458593          	addi	a1,a1,-1276 # 80008770 <syscalls+0x288>
    80004c74:	ffffc097          	auipc	ra,0xffffc
    80004c78:	f0c080e7          	jalr	-244(ra) # 80000b80 <initlock>
  (*f0)->type = FD_PIPE;
    80004c7c:	609c                	ld	a5,0(s1)
    80004c7e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004c82:	609c                	ld	a5,0(s1)
    80004c84:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004c88:	609c                	ld	a5,0(s1)
    80004c8a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004c8e:	609c                	ld	a5,0(s1)
    80004c90:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004c94:	000a3783          	ld	a5,0(s4)
    80004c98:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004c9c:	000a3783          	ld	a5,0(s4)
    80004ca0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004ca4:	000a3783          	ld	a5,0(s4)
    80004ca8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004cac:	000a3783          	ld	a5,0(s4)
    80004cb0:	0127b823          	sd	s2,16(a5)
  return 0;
    80004cb4:	4501                	li	a0,0
    80004cb6:	a025                	j	80004cde <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004cb8:	6088                	ld	a0,0(s1)
    80004cba:	e501                	bnez	a0,80004cc2 <pipealloc+0xaa>
    80004cbc:	a039                	j	80004cca <pipealloc+0xb2>
    80004cbe:	6088                	ld	a0,0(s1)
    80004cc0:	c51d                	beqz	a0,80004cee <pipealloc+0xd6>
    fileclose(*f0);
    80004cc2:	00000097          	auipc	ra,0x0
    80004cc6:	c00080e7          	jalr	-1024(ra) # 800048c2 <fileclose>
  if(*f1)
    80004cca:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004cce:	557d                	li	a0,-1
  if(*f1)
    80004cd0:	c799                	beqz	a5,80004cde <pipealloc+0xc6>
    fileclose(*f1);
    80004cd2:	853e                	mv	a0,a5
    80004cd4:	00000097          	auipc	ra,0x0
    80004cd8:	bee080e7          	jalr	-1042(ra) # 800048c2 <fileclose>
  return -1;
    80004cdc:	557d                	li	a0,-1
}
    80004cde:	70a2                	ld	ra,40(sp)
    80004ce0:	7402                	ld	s0,32(sp)
    80004ce2:	64e2                	ld	s1,24(sp)
    80004ce4:	6942                	ld	s2,16(sp)
    80004ce6:	69a2                	ld	s3,8(sp)
    80004ce8:	6a02                	ld	s4,0(sp)
    80004cea:	6145                	addi	sp,sp,48
    80004cec:	8082                	ret
  return -1;
    80004cee:	557d                	li	a0,-1
    80004cf0:	b7fd                	j	80004cde <pipealloc+0xc6>

0000000080004cf2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004cf2:	1101                	addi	sp,sp,-32
    80004cf4:	ec06                	sd	ra,24(sp)
    80004cf6:	e822                	sd	s0,16(sp)
    80004cf8:	e426                	sd	s1,8(sp)
    80004cfa:	e04a                	sd	s2,0(sp)
    80004cfc:	1000                	addi	s0,sp,32
    80004cfe:	84aa                	mv	s1,a0
    80004d00:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004d02:	ffffc097          	auipc	ra,0xffffc
    80004d06:	f0e080e7          	jalr	-242(ra) # 80000c10 <acquire>
  if(writable){
    80004d0a:	02090d63          	beqz	s2,80004d44 <pipeclose+0x52>
    pi->writeopen = 0;
    80004d0e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004d12:	21848513          	addi	a0,s1,536
    80004d16:	ffffe097          	auipc	ra,0xffffe
    80004d1a:	a84080e7          	jalr	-1404(ra) # 8000279a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004d1e:	2204b783          	ld	a5,544(s1)
    80004d22:	eb95                	bnez	a5,80004d56 <pipeclose+0x64>
    release(&pi->lock);
    80004d24:	8526                	mv	a0,s1
    80004d26:	ffffc097          	auipc	ra,0xffffc
    80004d2a:	f9e080e7          	jalr	-98(ra) # 80000cc4 <release>
    kfree((char*)pi);
    80004d2e:	8526                	mv	a0,s1
    80004d30:	ffffc097          	auipc	ra,0xffffc
    80004d34:	cf4080e7          	jalr	-780(ra) # 80000a24 <kfree>
  } else
    release(&pi->lock);
}
    80004d38:	60e2                	ld	ra,24(sp)
    80004d3a:	6442                	ld	s0,16(sp)
    80004d3c:	64a2                	ld	s1,8(sp)
    80004d3e:	6902                	ld	s2,0(sp)
    80004d40:	6105                	addi	sp,sp,32
    80004d42:	8082                	ret
    pi->readopen = 0;
    80004d44:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004d48:	21c48513          	addi	a0,s1,540
    80004d4c:	ffffe097          	auipc	ra,0xffffe
    80004d50:	a4e080e7          	jalr	-1458(ra) # 8000279a <wakeup>
    80004d54:	b7e9                	j	80004d1e <pipeclose+0x2c>
    release(&pi->lock);
    80004d56:	8526                	mv	a0,s1
    80004d58:	ffffc097          	auipc	ra,0xffffc
    80004d5c:	f6c080e7          	jalr	-148(ra) # 80000cc4 <release>
}
    80004d60:	bfe1                	j	80004d38 <pipeclose+0x46>

0000000080004d62 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004d62:	7119                	addi	sp,sp,-128
    80004d64:	fc86                	sd	ra,120(sp)
    80004d66:	f8a2                	sd	s0,112(sp)
    80004d68:	f4a6                	sd	s1,104(sp)
    80004d6a:	f0ca                	sd	s2,96(sp)
    80004d6c:	ecce                	sd	s3,88(sp)
    80004d6e:	e8d2                	sd	s4,80(sp)
    80004d70:	e4d6                	sd	s5,72(sp)
    80004d72:	e0da                	sd	s6,64(sp)
    80004d74:	fc5e                	sd	s7,56(sp)
    80004d76:	f862                	sd	s8,48(sp)
    80004d78:	f466                	sd	s9,40(sp)
    80004d7a:	f06a                	sd	s10,32(sp)
    80004d7c:	ec6e                	sd	s11,24(sp)
    80004d7e:	0100                	addi	s0,sp,128
    80004d80:	84aa                	mv	s1,a0
    80004d82:	8cae                	mv	s9,a1
    80004d84:	8b32                	mv	s6,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004d86:	ffffd097          	auipc	ra,0xffffd
    80004d8a:	f4a080e7          	jalr	-182(ra) # 80001cd0 <myproc>
    80004d8e:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004d90:	8526                	mv	a0,s1
    80004d92:	ffffc097          	auipc	ra,0xffffc
    80004d96:	e7e080e7          	jalr	-386(ra) # 80000c10 <acquire>
  for(i = 0; i < n; i++){
    80004d9a:	0d605963          	blez	s6,80004e6c <pipewrite+0x10a>
    80004d9e:	89a6                	mv	s3,s1
    80004da0:	3b7d                	addiw	s6,s6,-1
    80004da2:	1b02                	slli	s6,s6,0x20
    80004da4:	020b5b13          	srli	s6,s6,0x20
    80004da8:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004daa:	21848a93          	addi	s5,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004dae:	21c48a13          	addi	s4,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004db2:	5dfd                	li	s11,-1
    80004db4:	000b8d1b          	sext.w	s10,s7
    80004db8:	8c6a                	mv	s8,s10
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004dba:	2184a783          	lw	a5,536(s1)
    80004dbe:	21c4a703          	lw	a4,540(s1)
    80004dc2:	2007879b          	addiw	a5,a5,512
    80004dc6:	02f71b63          	bne	a4,a5,80004dfc <pipewrite+0x9a>
      if(pi->readopen == 0 || pr->killed){
    80004dca:	2204a783          	lw	a5,544(s1)
    80004dce:	cbad                	beqz	a5,80004e40 <pipewrite+0xde>
    80004dd0:	03092783          	lw	a5,48(s2)
    80004dd4:	e7b5                	bnez	a5,80004e40 <pipewrite+0xde>
      wakeup(&pi->nread);
    80004dd6:	8556                	mv	a0,s5
    80004dd8:	ffffe097          	auipc	ra,0xffffe
    80004ddc:	9c2080e7          	jalr	-1598(ra) # 8000279a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004de0:	85ce                	mv	a1,s3
    80004de2:	8552                	mv	a0,s4
    80004de4:	ffffe097          	auipc	ra,0xffffe
    80004de8:	830080e7          	jalr	-2000(ra) # 80002614 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004dec:	2184a783          	lw	a5,536(s1)
    80004df0:	21c4a703          	lw	a4,540(s1)
    80004df4:	2007879b          	addiw	a5,a5,512
    80004df8:	fcf709e3          	beq	a4,a5,80004dca <pipewrite+0x68>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004dfc:	4685                	li	a3,1
    80004dfe:	019b8633          	add	a2,s7,s9
    80004e02:	f8f40593          	addi	a1,s0,-113
    80004e06:	05093503          	ld	a0,80(s2)
    80004e0a:	ffffd097          	auipc	ra,0xffffd
    80004e0e:	d8a080e7          	jalr	-630(ra) # 80001b94 <copyin>
    80004e12:	05b50e63          	beq	a0,s11,80004e6e <pipewrite+0x10c>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004e16:	21c4a783          	lw	a5,540(s1)
    80004e1a:	0017871b          	addiw	a4,a5,1
    80004e1e:	20e4ae23          	sw	a4,540(s1)
    80004e22:	1ff7f793          	andi	a5,a5,511
    80004e26:	97a6                	add	a5,a5,s1
    80004e28:	f8f44703          	lbu	a4,-113(s0)
    80004e2c:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004e30:	001d0c1b          	addiw	s8,s10,1
    80004e34:	001b8793          	addi	a5,s7,1 # 1001 <_entry-0x7fffefff>
    80004e38:	036b8b63          	beq	s7,s6,80004e6e <pipewrite+0x10c>
    80004e3c:	8bbe                	mv	s7,a5
    80004e3e:	bf9d                	j	80004db4 <pipewrite+0x52>
        release(&pi->lock);
    80004e40:	8526                	mv	a0,s1
    80004e42:	ffffc097          	auipc	ra,0xffffc
    80004e46:	e82080e7          	jalr	-382(ra) # 80000cc4 <release>
        return -1;
    80004e4a:	5c7d                	li	s8,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);
  return i;
}
    80004e4c:	8562                	mv	a0,s8
    80004e4e:	70e6                	ld	ra,120(sp)
    80004e50:	7446                	ld	s0,112(sp)
    80004e52:	74a6                	ld	s1,104(sp)
    80004e54:	7906                	ld	s2,96(sp)
    80004e56:	69e6                	ld	s3,88(sp)
    80004e58:	6a46                	ld	s4,80(sp)
    80004e5a:	6aa6                	ld	s5,72(sp)
    80004e5c:	6b06                	ld	s6,64(sp)
    80004e5e:	7be2                	ld	s7,56(sp)
    80004e60:	7c42                	ld	s8,48(sp)
    80004e62:	7ca2                	ld	s9,40(sp)
    80004e64:	7d02                	ld	s10,32(sp)
    80004e66:	6de2                	ld	s11,24(sp)
    80004e68:	6109                	addi	sp,sp,128
    80004e6a:	8082                	ret
  for(i = 0; i < n; i++){
    80004e6c:	4c01                	li	s8,0
  wakeup(&pi->nread);
    80004e6e:	21848513          	addi	a0,s1,536
    80004e72:	ffffe097          	auipc	ra,0xffffe
    80004e76:	928080e7          	jalr	-1752(ra) # 8000279a <wakeup>
  release(&pi->lock);
    80004e7a:	8526                	mv	a0,s1
    80004e7c:	ffffc097          	auipc	ra,0xffffc
    80004e80:	e48080e7          	jalr	-440(ra) # 80000cc4 <release>
  return i;
    80004e84:	b7e1                	j	80004e4c <pipewrite+0xea>

0000000080004e86 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004e86:	715d                	addi	sp,sp,-80
    80004e88:	e486                	sd	ra,72(sp)
    80004e8a:	e0a2                	sd	s0,64(sp)
    80004e8c:	fc26                	sd	s1,56(sp)
    80004e8e:	f84a                	sd	s2,48(sp)
    80004e90:	f44e                	sd	s3,40(sp)
    80004e92:	f052                	sd	s4,32(sp)
    80004e94:	ec56                	sd	s5,24(sp)
    80004e96:	e85a                	sd	s6,16(sp)
    80004e98:	0880                	addi	s0,sp,80
    80004e9a:	84aa                	mv	s1,a0
    80004e9c:	892e                	mv	s2,a1
    80004e9e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004ea0:	ffffd097          	auipc	ra,0xffffd
    80004ea4:	e30080e7          	jalr	-464(ra) # 80001cd0 <myproc>
    80004ea8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004eaa:	8b26                	mv	s6,s1
    80004eac:	8526                	mv	a0,s1
    80004eae:	ffffc097          	auipc	ra,0xffffc
    80004eb2:	d62080e7          	jalr	-670(ra) # 80000c10 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004eb6:	2184a703          	lw	a4,536(s1)
    80004eba:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004ebe:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ec2:	02f71463          	bne	a4,a5,80004eea <piperead+0x64>
    80004ec6:	2244a783          	lw	a5,548(s1)
    80004eca:	c385                	beqz	a5,80004eea <piperead+0x64>
    if(pr->killed){
    80004ecc:	030a2783          	lw	a5,48(s4)
    80004ed0:	ebc1                	bnez	a5,80004f60 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004ed2:	85da                	mv	a1,s6
    80004ed4:	854e                	mv	a0,s3
    80004ed6:	ffffd097          	auipc	ra,0xffffd
    80004eda:	73e080e7          	jalr	1854(ra) # 80002614 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ede:	2184a703          	lw	a4,536(s1)
    80004ee2:	21c4a783          	lw	a5,540(s1)
    80004ee6:	fef700e3          	beq	a4,a5,80004ec6 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004eea:	09505263          	blez	s5,80004f6e <piperead+0xe8>
    80004eee:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004ef0:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004ef2:	2184a783          	lw	a5,536(s1)
    80004ef6:	21c4a703          	lw	a4,540(s1)
    80004efa:	02f70d63          	beq	a4,a5,80004f34 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004efe:	0017871b          	addiw	a4,a5,1
    80004f02:	20e4ac23          	sw	a4,536(s1)
    80004f06:	1ff7f793          	andi	a5,a5,511
    80004f0a:	97a6                	add	a5,a5,s1
    80004f0c:	0187c783          	lbu	a5,24(a5)
    80004f10:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004f14:	4685                	li	a3,1
    80004f16:	fbf40613          	addi	a2,s0,-65
    80004f1a:	85ca                	mv	a1,s2
    80004f1c:	050a3503          	ld	a0,80(s4)
    80004f20:	ffffd097          	auipc	ra,0xffffd
    80004f24:	b54080e7          	jalr	-1196(ra) # 80001a74 <copyout>
    80004f28:	01650663          	beq	a0,s6,80004f34 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f2c:	2985                	addiw	s3,s3,1
    80004f2e:	0905                	addi	s2,s2,1
    80004f30:	fd3a91e3          	bne	s5,s3,80004ef2 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004f34:	21c48513          	addi	a0,s1,540
    80004f38:	ffffe097          	auipc	ra,0xffffe
    80004f3c:	862080e7          	jalr	-1950(ra) # 8000279a <wakeup>
  release(&pi->lock);
    80004f40:	8526                	mv	a0,s1
    80004f42:	ffffc097          	auipc	ra,0xffffc
    80004f46:	d82080e7          	jalr	-638(ra) # 80000cc4 <release>
  return i;
}
    80004f4a:	854e                	mv	a0,s3
    80004f4c:	60a6                	ld	ra,72(sp)
    80004f4e:	6406                	ld	s0,64(sp)
    80004f50:	74e2                	ld	s1,56(sp)
    80004f52:	7942                	ld	s2,48(sp)
    80004f54:	79a2                	ld	s3,40(sp)
    80004f56:	7a02                	ld	s4,32(sp)
    80004f58:	6ae2                	ld	s5,24(sp)
    80004f5a:	6b42                	ld	s6,16(sp)
    80004f5c:	6161                	addi	sp,sp,80
    80004f5e:	8082                	ret
      release(&pi->lock);
    80004f60:	8526                	mv	a0,s1
    80004f62:	ffffc097          	auipc	ra,0xffffc
    80004f66:	d62080e7          	jalr	-670(ra) # 80000cc4 <release>
      return -1;
    80004f6a:	59fd                	li	s3,-1
    80004f6c:	bff9                	j	80004f4a <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f6e:	4981                	li	s3,0
    80004f70:	b7d1                	j	80004f34 <piperead+0xae>

0000000080004f72 <exec>:
#include "elf.h"

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);
int
exec(char *path, char **argv)
{
    80004f72:	df010113          	addi	sp,sp,-528
    80004f76:	20113423          	sd	ra,520(sp)
    80004f7a:	20813023          	sd	s0,512(sp)
    80004f7e:	ffa6                	sd	s1,504(sp)
    80004f80:	fbca                	sd	s2,496(sp)
    80004f82:	f7ce                	sd	s3,488(sp)
    80004f84:	f3d2                	sd	s4,480(sp)
    80004f86:	efd6                	sd	s5,472(sp)
    80004f88:	ebda                	sd	s6,464(sp)
    80004f8a:	e7de                	sd	s7,456(sp)
    80004f8c:	e3e2                	sd	s8,448(sp)
    80004f8e:	ff66                	sd	s9,440(sp)
    80004f90:	fb6a                	sd	s10,432(sp)
    80004f92:	f76e                	sd	s11,424(sp)
    80004f94:	0c00                	addi	s0,sp,528
    80004f96:	84aa                	mv	s1,a0
    80004f98:	dea43c23          	sd	a0,-520(s0)
    80004f9c:	e0b43023          	sd	a1,-512(s0)
    uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pagetable_t pagetable = 0, oldpagetable;
    struct proc *p = myproc();
    80004fa0:	ffffd097          	auipc	ra,0xffffd
    80004fa4:	d30080e7          	jalr	-720(ra) # 80001cd0 <myproc>
    80004fa8:	892a                	mv	s2,a0
    begin_op();
    80004faa:	fffff097          	auipc	ra,0xfffff
    80004fae:	446080e7          	jalr	1094(ra) # 800043f0 <begin_op>

    if((ip = namei(path)) == 0){
    80004fb2:	8526                	mv	a0,s1
    80004fb4:	fffff097          	auipc	ra,0xfffff
    80004fb8:	230080e7          	jalr	560(ra) # 800041e4 <namei>
    80004fbc:	c92d                	beqz	a0,8000502e <exec+0xbc>
    80004fbe:	84aa                	mv	s1,a0
        end_op();
        return -1;
    }
    ilock(ip);
    80004fc0:	fffff097          	auipc	ra,0xfffff
    80004fc4:	a74080e7          	jalr	-1420(ra) # 80003a34 <ilock>
    // Check ELF header
    if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004fc8:	04000713          	li	a4,64
    80004fcc:	4681                	li	a3,0
    80004fce:	e4840613          	addi	a2,s0,-440
    80004fd2:	4581                	li	a1,0
    80004fd4:	8526                	mv	a0,s1
    80004fd6:	fffff097          	auipc	ra,0xfffff
    80004fda:	d12080e7          	jalr	-750(ra) # 80003ce8 <readi>
    80004fde:	04000793          	li	a5,64
    80004fe2:	00f51a63          	bne	a0,a5,80004ff6 <exec+0x84>
        goto bad;
    if(elf.magic != ELF_MAGIC)
    80004fe6:	e4842703          	lw	a4,-440(s0)
    80004fea:	464c47b7          	lui	a5,0x464c4
    80004fee:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004ff2:	04f70463          	beq	a4,a5,8000503a <exec+0xc8>

bad:
    if(pagetable)
        proc_freepagetable(pagetable, sz);
    if(ip){
        iunlockput(ip);
    80004ff6:	8526                	mv	a0,s1
    80004ff8:	fffff097          	auipc	ra,0xfffff
    80004ffc:	c9e080e7          	jalr	-866(ra) # 80003c96 <iunlockput>
        end_op();
    80005000:	fffff097          	auipc	ra,0xfffff
    80005004:	470080e7          	jalr	1136(ra) # 80004470 <end_op>
    }
    return -1;
    80005008:	557d                	li	a0,-1
}
    8000500a:	20813083          	ld	ra,520(sp)
    8000500e:	20013403          	ld	s0,512(sp)
    80005012:	74fe                	ld	s1,504(sp)
    80005014:	795e                	ld	s2,496(sp)
    80005016:	79be                	ld	s3,488(sp)
    80005018:	7a1e                	ld	s4,480(sp)
    8000501a:	6afe                	ld	s5,472(sp)
    8000501c:	6b5e                	ld	s6,464(sp)
    8000501e:	6bbe                	ld	s7,456(sp)
    80005020:	6c1e                	ld	s8,448(sp)
    80005022:	7cfa                	ld	s9,440(sp)
    80005024:	7d5a                	ld	s10,432(sp)
    80005026:	7dba                	ld	s11,424(sp)
    80005028:	21010113          	addi	sp,sp,528
    8000502c:	8082                	ret
        end_op();
    8000502e:	fffff097          	auipc	ra,0xfffff
    80005032:	442080e7          	jalr	1090(ra) # 80004470 <end_op>
        return -1;
    80005036:	557d                	li	a0,-1
    80005038:	bfc9                	j	8000500a <exec+0x98>
    if((pagetable = proc_pagetable(p)) == 0)
    8000503a:	854a                	mv	a0,s2
    8000503c:	ffffd097          	auipc	ra,0xffffd
    80005040:	d58080e7          	jalr	-680(ra) # 80001d94 <proc_pagetable>
    80005044:	8baa                	mv	s7,a0
    80005046:	d945                	beqz	a0,80004ff6 <exec+0x84>
    for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005048:	e6842983          	lw	s3,-408(s0)
    8000504c:	e8045783          	lhu	a5,-384(s0)
    80005050:	c7ad                	beqz	a5,800050ba <exec+0x148>
    uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80005052:	4901                	li	s2,0
    for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005054:	4b01                	li	s6,0
        if(ph.vaddr % PGSIZE != 0)
    80005056:	6c85                	lui	s9,0x1
    80005058:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000505c:	def43823          	sd	a5,-528(s0)
    80005060:	a48d                	j	800052c2 <exec+0x350>
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80005062:	00003517          	auipc	a0,0x3
    80005066:	71650513          	addi	a0,a0,1814 # 80008778 <syscalls+0x290>
    8000506a:	ffffb097          	auipc	ra,0xffffb
    8000506e:	4de080e7          	jalr	1246(ra) # 80000548 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005072:	8756                	mv	a4,s5
    80005074:	012d86bb          	addw	a3,s11,s2
    80005078:	4581                	li	a1,0
    8000507a:	8526                	mv	a0,s1
    8000507c:	fffff097          	auipc	ra,0xfffff
    80005080:	c6c080e7          	jalr	-916(ra) # 80003ce8 <readi>
    80005084:	2501                	sext.w	a0,a0
    80005086:	1eaa9563          	bne	s5,a0,80005270 <exec+0x2fe>
  for(i = 0; i < sz; i += PGSIZE){
    8000508a:	6785                	lui	a5,0x1
    8000508c:	0127893b          	addw	s2,a5,s2
    80005090:	77fd                	lui	a5,0xfffff
    80005092:	01478a3b          	addw	s4,a5,s4
    80005096:	21897d63          	bgeu	s2,s8,800052b0 <exec+0x33e>
    pa = walkaddr(pagetable, va + i);
    8000509a:	02091593          	slli	a1,s2,0x20
    8000509e:	9181                	srli	a1,a1,0x20
    800050a0:	95ea                	add	a1,a1,s10
    800050a2:	855e                	mv	a0,s7
    800050a4:	ffffc097          	auipc	ra,0xffffc
    800050a8:	0b4080e7          	jalr	180(ra) # 80001158 <walkaddr>
    800050ac:	862a                	mv	a2,a0
    if(pa == 0)
    800050ae:	d955                	beqz	a0,80005062 <exec+0xf0>
      n = PGSIZE;
    800050b0:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800050b2:	fd9a70e3          	bgeu	s4,s9,80005072 <exec+0x100>
      n = sz - i;
    800050b6:	8ad2                	mv	s5,s4
    800050b8:	bf6d                	j	80005072 <exec+0x100>
    uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    800050ba:	4901                	li	s2,0
    iunlockput(ip);
    800050bc:	8526                	mv	a0,s1
    800050be:	fffff097          	auipc	ra,0xfffff
    800050c2:	bd8080e7          	jalr	-1064(ra) # 80003c96 <iunlockput>
    end_op();
    800050c6:	fffff097          	auipc	ra,0xfffff
    800050ca:	3aa080e7          	jalr	938(ra) # 80004470 <end_op>
    p = myproc();
    800050ce:	ffffd097          	auipc	ra,0xffffd
    800050d2:	c02080e7          	jalr	-1022(ra) # 80001cd0 <myproc>
    800050d6:	8aaa                	mv	s5,a0
    uint64 oldsz = p->sz;
    800050d8:	04853d03          	ld	s10,72(a0)
    sz = PGROUNDUP(sz);
    800050dc:	6785                	lui	a5,0x1
    800050de:	17fd                	addi	a5,a5,-1
    800050e0:	993e                	add	s2,s2,a5
    800050e2:	757d                	lui	a0,0xfffff
    800050e4:	00a977b3          	and	a5,s2,a0
    800050e8:	e0f43423          	sd	a5,-504(s0)
    if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800050ec:	6609                	lui	a2,0x2
    800050ee:	963e                	add	a2,a2,a5
    800050f0:	85be                	mv	a1,a5
    800050f2:	855e                	mv	a0,s7
    800050f4:	ffffc097          	auipc	ra,0xffffc
    800050f8:	56a080e7          	jalr	1386(ra) # 8000165e <uvmalloc>
    800050fc:	8b2a                	mv	s6,a0
    ip = 0;
    800050fe:	4481                	li	s1,0
    if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80005100:	16050863          	beqz	a0,80005270 <exec+0x2fe>
    uvmclear(pagetable, sz-2*PGSIZE);
    80005104:	75f9                	lui	a1,0xffffe
    80005106:	95aa                	add	a1,a1,a0
    80005108:	855e                	mv	a0,s7
    8000510a:	ffffd097          	auipc	ra,0xffffd
    8000510e:	938080e7          	jalr	-1736(ra) # 80001a42 <uvmclear>
    stackbase = sp - PGSIZE;
    80005112:	7c7d                	lui	s8,0xfffff
    80005114:	9c5a                	add	s8,s8,s6
    for(argc = 0; argv[argc]; argc++) {
    80005116:	e0043783          	ld	a5,-512(s0)
    8000511a:	6388                	ld	a0,0(a5)
    8000511c:	c535                	beqz	a0,80005188 <exec+0x216>
    8000511e:	e8840993          	addi	s3,s0,-376
    80005122:	f8840c93          	addi	s9,s0,-120
    sp = sz;
    80005126:	895a                	mv	s2,s6
        sp -= strlen(argv[argc]) + 1;
    80005128:	ffffc097          	auipc	ra,0xffffc
    8000512c:	d6c080e7          	jalr	-660(ra) # 80000e94 <strlen>
    80005130:	2505                	addiw	a0,a0,1
    80005132:	40a90933          	sub	s2,s2,a0
        sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005136:	ff097913          	andi	s2,s2,-16
        if(sp < stackbase)
    8000513a:	15896f63          	bltu	s2,s8,80005298 <exec+0x326>
        if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000513e:	e0043d83          	ld	s11,-512(s0)
    80005142:	000dba03          	ld	s4,0(s11)
    80005146:	8552                	mv	a0,s4
    80005148:	ffffc097          	auipc	ra,0xffffc
    8000514c:	d4c080e7          	jalr	-692(ra) # 80000e94 <strlen>
    80005150:	0015069b          	addiw	a3,a0,1
    80005154:	8652                	mv	a2,s4
    80005156:	85ca                	mv	a1,s2
    80005158:	855e                	mv	a0,s7
    8000515a:	ffffd097          	auipc	ra,0xffffd
    8000515e:	91a080e7          	jalr	-1766(ra) # 80001a74 <copyout>
    80005162:	12054f63          	bltz	a0,800052a0 <exec+0x32e>
        ustack[argc] = sp;
    80005166:	0129b023          	sd	s2,0(s3)
    for(argc = 0; argv[argc]; argc++) {
    8000516a:	0485                	addi	s1,s1,1
    8000516c:	008d8793          	addi	a5,s11,8
    80005170:	e0f43023          	sd	a5,-512(s0)
    80005174:	008db503          	ld	a0,8(s11)
    80005178:	c911                	beqz	a0,8000518c <exec+0x21a>
        if(argc >= MAXARG)
    8000517a:	09a1                	addi	s3,s3,8
    8000517c:	fb3c96e3          	bne	s9,s3,80005128 <exec+0x1b6>
    sz = sz1;
    80005180:	e1643423          	sd	s6,-504(s0)
    ip = 0;
    80005184:	4481                	li	s1,0
    80005186:	a0ed                	j	80005270 <exec+0x2fe>
    sp = sz;
    80005188:	895a                	mv	s2,s6
    for(argc = 0; argv[argc]; argc++) {
    8000518a:	4481                	li	s1,0
    ustack[argc] = 0;
    8000518c:	00349793          	slli	a5,s1,0x3
    80005190:	f9040713          	addi	a4,s0,-112
    80005194:	97ba                	add	a5,a5,a4
    80005196:	ee07bc23          	sd	zero,-264(a5) # ef8 <_entry-0x7ffff108>
    sp -= (argc+1) * sizeof(uint64);
    8000519a:	00148693          	addi	a3,s1,1
    8000519e:	068e                	slli	a3,a3,0x3
    800051a0:	40d90933          	sub	s2,s2,a3
    sp -= sp % 16;
    800051a4:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800051a8:	01897663          	bgeu	s2,s8,800051b4 <exec+0x242>
    sz = sz1;
    800051ac:	e1643423          	sd	s6,-504(s0)
    ip = 0;
    800051b0:	4481                	li	s1,0
    800051b2:	a87d                	j	80005270 <exec+0x2fe>
    if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800051b4:	e8840613          	addi	a2,s0,-376
    800051b8:	85ca                	mv	a1,s2
    800051ba:	855e                	mv	a0,s7
    800051bc:	ffffd097          	auipc	ra,0xffffd
    800051c0:	8b8080e7          	jalr	-1864(ra) # 80001a74 <copyout>
    800051c4:	0e054263          	bltz	a0,800052a8 <exec+0x336>
    p->trapframe->a1 = sp;
    800051c8:	060ab783          	ld	a5,96(s5)
    800051cc:	0727bc23          	sd	s2,120(a5)
    for(last=s=path; *s; s++)
    800051d0:	df843783          	ld	a5,-520(s0)
    800051d4:	0007c703          	lbu	a4,0(a5)
    800051d8:	cf11                	beqz	a4,800051f4 <exec+0x282>
    800051da:	0785                	addi	a5,a5,1
        if(*s == '/')
    800051dc:	02f00693          	li	a3,47
    800051e0:	a029                	j	800051ea <exec+0x278>
    for(last=s=path; *s; s++)
    800051e2:	0785                	addi	a5,a5,1
    800051e4:	fff7c703          	lbu	a4,-1(a5)
    800051e8:	c711                	beqz	a4,800051f4 <exec+0x282>
        if(*s == '/')
    800051ea:	fed71ce3          	bne	a4,a3,800051e2 <exec+0x270>
            last = s+1;
    800051ee:	def43c23          	sd	a5,-520(s0)
    800051f2:	bfc5                	j	800051e2 <exec+0x270>
    safestrcpy(p->name, last, sizeof(p->name));
    800051f4:	4641                	li	a2,16
    800051f6:	df843583          	ld	a1,-520(s0)
    800051fa:	160a8513          	addi	a0,s5,352
    800051fe:	ffffc097          	auipc	ra,0xffffc
    80005202:	c64080e7          	jalr	-924(ra) # 80000e62 <safestrcpy>
    kvmdealloc(p->kpagetable,oldsz,0);
    80005206:	4601                	li	a2,0
    80005208:	85ea                	mv	a1,s10
    8000520a:	058ab503          	ld	a0,88(s5)
    8000520e:	ffffc097          	auipc	ra,0xffffc
    80005212:	52c080e7          	jalr	1324(ra) # 8000173a <kvmdealloc>
    kvmcopy(pagetable,p->kpagetable,0,sz);
    80005216:	86da                	mv	a3,s6
    80005218:	4601                	li	a2,0
    8000521a:	058ab583          	ld	a1,88(s5)
    8000521e:	855e                	mv	a0,s7
    80005220:	ffffc097          	auipc	ra,0xffffc
    80005224:	762080e7          	jalr	1890(ra) # 80001982 <kvmcopy>
    oldpagetable = p->pagetable;
    80005228:	050ab503          	ld	a0,80(s5)
    p->pagetable = pagetable;
    8000522c:	057ab823          	sd	s7,80(s5)
    p->sz = sz;
    80005230:	056ab423          	sd	s6,72(s5)
    p->trapframe->epc = elf.entry;  // initial program counter = main
    80005234:	060ab783          	ld	a5,96(s5)
    80005238:	e6043703          	ld	a4,-416(s0)
    8000523c:	ef98                	sd	a4,24(a5)
    p->trapframe->sp = sp; // initial stack pointer
    8000523e:	060ab783          	ld	a5,96(s5)
    80005242:	0327b823          	sd	s2,48(a5)
    proc_freepagetable(oldpagetable, oldsz);
    80005246:	85ea                	mv	a1,s10
    80005248:	ffffd097          	auipc	ra,0xffffd
    8000524c:	be8080e7          	jalr	-1048(ra) # 80001e30 <proc_freepagetable>
    if(p->pid == 1) vmprint(pagetable);
    80005250:	038aa703          	lw	a4,56(s5)
    80005254:	4785                	li	a5,1
    80005256:	00f70563          	beq	a4,a5,80005260 <exec+0x2ee>
    return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000525a:	0004851b          	sext.w	a0,s1
    8000525e:	b375                	j	8000500a <exec+0x98>
    if(p->pid == 1) vmprint(pagetable);
    80005260:	855e                	mv	a0,s7
    80005262:	ffffd097          	auipc	ra,0xffffd
    80005266:	962080e7          	jalr	-1694(ra) # 80001bc4 <vmprint>
    8000526a:	bfc5                	j	8000525a <exec+0x2e8>
    8000526c:	e1243423          	sd	s2,-504(s0)
        proc_freepagetable(pagetable, sz);
    80005270:	e0843583          	ld	a1,-504(s0)
    80005274:	855e                	mv	a0,s7
    80005276:	ffffd097          	auipc	ra,0xffffd
    8000527a:	bba080e7          	jalr	-1094(ra) # 80001e30 <proc_freepagetable>
    if(ip){
    8000527e:	d6049ce3          	bnez	s1,80004ff6 <exec+0x84>
    return -1;
    80005282:	557d                	li	a0,-1
    80005284:	b359                	j	8000500a <exec+0x98>
    80005286:	e1243423          	sd	s2,-504(s0)
    8000528a:	b7dd                	j	80005270 <exec+0x2fe>
    8000528c:	e1243423          	sd	s2,-504(s0)
    80005290:	b7c5                	j	80005270 <exec+0x2fe>
    80005292:	e1243423          	sd	s2,-504(s0)
    80005296:	bfe9                	j	80005270 <exec+0x2fe>
    sz = sz1;
    80005298:	e1643423          	sd	s6,-504(s0)
    ip = 0;
    8000529c:	4481                	li	s1,0
    8000529e:	bfc9                	j	80005270 <exec+0x2fe>
    sz = sz1;
    800052a0:	e1643423          	sd	s6,-504(s0)
    ip = 0;
    800052a4:	4481                	li	s1,0
    800052a6:	b7e9                	j	80005270 <exec+0x2fe>
    sz = sz1;
    800052a8:	e1643423          	sd	s6,-504(s0)
    ip = 0;
    800052ac:	4481                	li	s1,0
    800052ae:	b7c9                	j	80005270 <exec+0x2fe>
        if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800052b0:	e0843903          	ld	s2,-504(s0)
    for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800052b4:	2b05                	addiw	s6,s6,1
    800052b6:	0389899b          	addiw	s3,s3,56
    800052ba:	e8045783          	lhu	a5,-384(s0)
    800052be:	defb5fe3          	bge	s6,a5,800050bc <exec+0x14a>
        if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800052c2:	2981                	sext.w	s3,s3
    800052c4:	03800713          	li	a4,56
    800052c8:	86ce                	mv	a3,s3
    800052ca:	e1040613          	addi	a2,s0,-496
    800052ce:	4581                	li	a1,0
    800052d0:	8526                	mv	a0,s1
    800052d2:	fffff097          	auipc	ra,0xfffff
    800052d6:	a16080e7          	jalr	-1514(ra) # 80003ce8 <readi>
    800052da:	03800793          	li	a5,56
    800052de:	f8f517e3          	bne	a0,a5,8000526c <exec+0x2fa>
        if(ph.type != ELF_PROG_LOAD)
    800052e2:	e1042783          	lw	a5,-496(s0)
    800052e6:	4705                	li	a4,1
    800052e8:	fce796e3          	bne	a5,a4,800052b4 <exec+0x342>
        if(ph.memsz < ph.filesz)
    800052ec:	e3843603          	ld	a2,-456(s0)
    800052f0:	e3043783          	ld	a5,-464(s0)
    800052f4:	f8f669e3          	bltu	a2,a5,80005286 <exec+0x314>
        if(ph.vaddr + ph.memsz < ph.vaddr)
    800052f8:	e2043783          	ld	a5,-480(s0)
    800052fc:	963e                	add	a2,a2,a5
    800052fe:	f8f667e3          	bltu	a2,a5,8000528c <exec+0x31a>
        if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80005302:	85ca                	mv	a1,s2
    80005304:	855e                	mv	a0,s7
    80005306:	ffffc097          	auipc	ra,0xffffc
    8000530a:	358080e7          	jalr	856(ra) # 8000165e <uvmalloc>
    8000530e:	e0a43423          	sd	a0,-504(s0)
    80005312:	d141                	beqz	a0,80005292 <exec+0x320>
        if(ph.vaddr % PGSIZE != 0)
    80005314:	e2043d03          	ld	s10,-480(s0)
    80005318:	df043783          	ld	a5,-528(s0)
    8000531c:	00fd77b3          	and	a5,s10,a5
    80005320:	fba1                	bnez	a5,80005270 <exec+0x2fe>
        if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005322:	e1842d83          	lw	s11,-488(s0)
    80005326:	e3042c03          	lw	s8,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000532a:	f80c03e3          	beqz	s8,800052b0 <exec+0x33e>
    8000532e:	8a62                	mv	s4,s8
    80005330:	4901                	li	s2,0
    80005332:	b3a5                	j	8000509a <exec+0x128>

0000000080005334 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005334:	7179                	addi	sp,sp,-48
    80005336:	f406                	sd	ra,40(sp)
    80005338:	f022                	sd	s0,32(sp)
    8000533a:	ec26                	sd	s1,24(sp)
    8000533c:	e84a                	sd	s2,16(sp)
    8000533e:	1800                	addi	s0,sp,48
    80005340:	892e                	mv	s2,a1
    80005342:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80005344:	fdc40593          	addi	a1,s0,-36
    80005348:	ffffe097          	auipc	ra,0xffffe
    8000534c:	b7a080e7          	jalr	-1158(ra) # 80002ec2 <argint>
    80005350:	04054063          	bltz	a0,80005390 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005354:	fdc42703          	lw	a4,-36(s0)
    80005358:	47bd                	li	a5,15
    8000535a:	02e7ed63          	bltu	a5,a4,80005394 <argfd+0x60>
    8000535e:	ffffd097          	auipc	ra,0xffffd
    80005362:	972080e7          	jalr	-1678(ra) # 80001cd0 <myproc>
    80005366:	fdc42703          	lw	a4,-36(s0)
    8000536a:	01a70793          	addi	a5,a4,26
    8000536e:	078e                	slli	a5,a5,0x3
    80005370:	953e                	add	a0,a0,a5
    80005372:	651c                	ld	a5,8(a0)
    80005374:	c395                	beqz	a5,80005398 <argfd+0x64>
    return -1;
  if(pfd)
    80005376:	00090463          	beqz	s2,8000537e <argfd+0x4a>
    *pfd = fd;
    8000537a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000537e:	4501                	li	a0,0
  if(pf)
    80005380:	c091                	beqz	s1,80005384 <argfd+0x50>
    *pf = f;
    80005382:	e09c                	sd	a5,0(s1)
}
    80005384:	70a2                	ld	ra,40(sp)
    80005386:	7402                	ld	s0,32(sp)
    80005388:	64e2                	ld	s1,24(sp)
    8000538a:	6942                	ld	s2,16(sp)
    8000538c:	6145                	addi	sp,sp,48
    8000538e:	8082                	ret
    return -1;
    80005390:	557d                	li	a0,-1
    80005392:	bfcd                	j	80005384 <argfd+0x50>
    return -1;
    80005394:	557d                	li	a0,-1
    80005396:	b7fd                	j	80005384 <argfd+0x50>
    80005398:	557d                	li	a0,-1
    8000539a:	b7ed                	j	80005384 <argfd+0x50>

000000008000539c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000539c:	1101                	addi	sp,sp,-32
    8000539e:	ec06                	sd	ra,24(sp)
    800053a0:	e822                	sd	s0,16(sp)
    800053a2:	e426                	sd	s1,8(sp)
    800053a4:	1000                	addi	s0,sp,32
    800053a6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800053a8:	ffffd097          	auipc	ra,0xffffd
    800053ac:	928080e7          	jalr	-1752(ra) # 80001cd0 <myproc>
    800053b0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800053b2:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd80b8>
    800053b6:	4501                	li	a0,0
    800053b8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800053ba:	6398                	ld	a4,0(a5)
    800053bc:	cb19                	beqz	a4,800053d2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800053be:	2505                	addiw	a0,a0,1
    800053c0:	07a1                	addi	a5,a5,8
    800053c2:	fed51ce3          	bne	a0,a3,800053ba <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800053c6:	557d                	li	a0,-1
}
    800053c8:	60e2                	ld	ra,24(sp)
    800053ca:	6442                	ld	s0,16(sp)
    800053cc:	64a2                	ld	s1,8(sp)
    800053ce:	6105                	addi	sp,sp,32
    800053d0:	8082                	ret
      p->ofile[fd] = f;
    800053d2:	01a50793          	addi	a5,a0,26
    800053d6:	078e                	slli	a5,a5,0x3
    800053d8:	963e                	add	a2,a2,a5
    800053da:	e604                	sd	s1,8(a2)
      return fd;
    800053dc:	b7f5                	j	800053c8 <fdalloc+0x2c>

00000000800053de <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800053de:	715d                	addi	sp,sp,-80
    800053e0:	e486                	sd	ra,72(sp)
    800053e2:	e0a2                	sd	s0,64(sp)
    800053e4:	fc26                	sd	s1,56(sp)
    800053e6:	f84a                	sd	s2,48(sp)
    800053e8:	f44e                	sd	s3,40(sp)
    800053ea:	f052                	sd	s4,32(sp)
    800053ec:	ec56                	sd	s5,24(sp)
    800053ee:	0880                	addi	s0,sp,80
    800053f0:	89ae                	mv	s3,a1
    800053f2:	8ab2                	mv	s5,a2
    800053f4:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800053f6:	fb040593          	addi	a1,s0,-80
    800053fa:	fffff097          	auipc	ra,0xfffff
    800053fe:	e08080e7          	jalr	-504(ra) # 80004202 <nameiparent>
    80005402:	892a                	mv	s2,a0
    80005404:	12050f63          	beqz	a0,80005542 <create+0x164>
    return 0;

  ilock(dp);
    80005408:	ffffe097          	auipc	ra,0xffffe
    8000540c:	62c080e7          	jalr	1580(ra) # 80003a34 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005410:	4601                	li	a2,0
    80005412:	fb040593          	addi	a1,s0,-80
    80005416:	854a                	mv	a0,s2
    80005418:	fffff097          	auipc	ra,0xfffff
    8000541c:	afa080e7          	jalr	-1286(ra) # 80003f12 <dirlookup>
    80005420:	84aa                	mv	s1,a0
    80005422:	c921                	beqz	a0,80005472 <create+0x94>
    iunlockput(dp);
    80005424:	854a                	mv	a0,s2
    80005426:	fffff097          	auipc	ra,0xfffff
    8000542a:	870080e7          	jalr	-1936(ra) # 80003c96 <iunlockput>
    ilock(ip);
    8000542e:	8526                	mv	a0,s1
    80005430:	ffffe097          	auipc	ra,0xffffe
    80005434:	604080e7          	jalr	1540(ra) # 80003a34 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005438:	2981                	sext.w	s3,s3
    8000543a:	4789                	li	a5,2
    8000543c:	02f99463          	bne	s3,a5,80005464 <create+0x86>
    80005440:	0444d783          	lhu	a5,68(s1)
    80005444:	37f9                	addiw	a5,a5,-2
    80005446:	17c2                	slli	a5,a5,0x30
    80005448:	93c1                	srli	a5,a5,0x30
    8000544a:	4705                	li	a4,1
    8000544c:	00f76c63          	bltu	a4,a5,80005464 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005450:	8526                	mv	a0,s1
    80005452:	60a6                	ld	ra,72(sp)
    80005454:	6406                	ld	s0,64(sp)
    80005456:	74e2                	ld	s1,56(sp)
    80005458:	7942                	ld	s2,48(sp)
    8000545a:	79a2                	ld	s3,40(sp)
    8000545c:	7a02                	ld	s4,32(sp)
    8000545e:	6ae2                	ld	s5,24(sp)
    80005460:	6161                	addi	sp,sp,80
    80005462:	8082                	ret
    iunlockput(ip);
    80005464:	8526                	mv	a0,s1
    80005466:	fffff097          	auipc	ra,0xfffff
    8000546a:	830080e7          	jalr	-2000(ra) # 80003c96 <iunlockput>
    return 0;
    8000546e:	4481                	li	s1,0
    80005470:	b7c5                	j	80005450 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80005472:	85ce                	mv	a1,s3
    80005474:	00092503          	lw	a0,0(s2)
    80005478:	ffffe097          	auipc	ra,0xffffe
    8000547c:	424080e7          	jalr	1060(ra) # 8000389c <ialloc>
    80005480:	84aa                	mv	s1,a0
    80005482:	c529                	beqz	a0,800054cc <create+0xee>
  ilock(ip);
    80005484:	ffffe097          	auipc	ra,0xffffe
    80005488:	5b0080e7          	jalr	1456(ra) # 80003a34 <ilock>
  ip->major = major;
    8000548c:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005490:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005494:	4785                	li	a5,1
    80005496:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000549a:	8526                	mv	a0,s1
    8000549c:	ffffe097          	auipc	ra,0xffffe
    800054a0:	4ce080e7          	jalr	1230(ra) # 8000396a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800054a4:	2981                	sext.w	s3,s3
    800054a6:	4785                	li	a5,1
    800054a8:	02f98a63          	beq	s3,a5,800054dc <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800054ac:	40d0                	lw	a2,4(s1)
    800054ae:	fb040593          	addi	a1,s0,-80
    800054b2:	854a                	mv	a0,s2
    800054b4:	fffff097          	auipc	ra,0xfffff
    800054b8:	c6e080e7          	jalr	-914(ra) # 80004122 <dirlink>
    800054bc:	06054b63          	bltz	a0,80005532 <create+0x154>
  iunlockput(dp);
    800054c0:	854a                	mv	a0,s2
    800054c2:	ffffe097          	auipc	ra,0xffffe
    800054c6:	7d4080e7          	jalr	2004(ra) # 80003c96 <iunlockput>
  return ip;
    800054ca:	b759                	j	80005450 <create+0x72>
    panic("create: ialloc");
    800054cc:	00003517          	auipc	a0,0x3
    800054d0:	2cc50513          	addi	a0,a0,716 # 80008798 <syscalls+0x2b0>
    800054d4:	ffffb097          	auipc	ra,0xffffb
    800054d8:	074080e7          	jalr	116(ra) # 80000548 <panic>
    dp->nlink++;  // for ".."
    800054dc:	04a95783          	lhu	a5,74(s2)
    800054e0:	2785                	addiw	a5,a5,1
    800054e2:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800054e6:	854a                	mv	a0,s2
    800054e8:	ffffe097          	auipc	ra,0xffffe
    800054ec:	482080e7          	jalr	1154(ra) # 8000396a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800054f0:	40d0                	lw	a2,4(s1)
    800054f2:	00003597          	auipc	a1,0x3
    800054f6:	2b658593          	addi	a1,a1,694 # 800087a8 <syscalls+0x2c0>
    800054fa:	8526                	mv	a0,s1
    800054fc:	fffff097          	auipc	ra,0xfffff
    80005500:	c26080e7          	jalr	-986(ra) # 80004122 <dirlink>
    80005504:	00054f63          	bltz	a0,80005522 <create+0x144>
    80005508:	00492603          	lw	a2,4(s2)
    8000550c:	00003597          	auipc	a1,0x3
    80005510:	2a458593          	addi	a1,a1,676 # 800087b0 <syscalls+0x2c8>
    80005514:	8526                	mv	a0,s1
    80005516:	fffff097          	auipc	ra,0xfffff
    8000551a:	c0c080e7          	jalr	-1012(ra) # 80004122 <dirlink>
    8000551e:	f80557e3          	bgez	a0,800054ac <create+0xce>
      panic("create dots");
    80005522:	00003517          	auipc	a0,0x3
    80005526:	29650513          	addi	a0,a0,662 # 800087b8 <syscalls+0x2d0>
    8000552a:	ffffb097          	auipc	ra,0xffffb
    8000552e:	01e080e7          	jalr	30(ra) # 80000548 <panic>
    panic("create: dirlink");
    80005532:	00003517          	auipc	a0,0x3
    80005536:	29650513          	addi	a0,a0,662 # 800087c8 <syscalls+0x2e0>
    8000553a:	ffffb097          	auipc	ra,0xffffb
    8000553e:	00e080e7          	jalr	14(ra) # 80000548 <panic>
    return 0;
    80005542:	84aa                	mv	s1,a0
    80005544:	b731                	j	80005450 <create+0x72>

0000000080005546 <sys_dup>:
{
    80005546:	7179                	addi	sp,sp,-48
    80005548:	f406                	sd	ra,40(sp)
    8000554a:	f022                	sd	s0,32(sp)
    8000554c:	ec26                	sd	s1,24(sp)
    8000554e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005550:	fd840613          	addi	a2,s0,-40
    80005554:	4581                	li	a1,0
    80005556:	4501                	li	a0,0
    80005558:	00000097          	auipc	ra,0x0
    8000555c:	ddc080e7          	jalr	-548(ra) # 80005334 <argfd>
    return -1;
    80005560:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005562:	02054363          	bltz	a0,80005588 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80005566:	fd843503          	ld	a0,-40(s0)
    8000556a:	00000097          	auipc	ra,0x0
    8000556e:	e32080e7          	jalr	-462(ra) # 8000539c <fdalloc>
    80005572:	84aa                	mv	s1,a0
    return -1;
    80005574:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005576:	00054963          	bltz	a0,80005588 <sys_dup+0x42>
  filedup(f);
    8000557a:	fd843503          	ld	a0,-40(s0)
    8000557e:	fffff097          	auipc	ra,0xfffff
    80005582:	2f2080e7          	jalr	754(ra) # 80004870 <filedup>
  return fd;
    80005586:	87a6                	mv	a5,s1
}
    80005588:	853e                	mv	a0,a5
    8000558a:	70a2                	ld	ra,40(sp)
    8000558c:	7402                	ld	s0,32(sp)
    8000558e:	64e2                	ld	s1,24(sp)
    80005590:	6145                	addi	sp,sp,48
    80005592:	8082                	ret

0000000080005594 <sys_read>:
{
    80005594:	7179                	addi	sp,sp,-48
    80005596:	f406                	sd	ra,40(sp)
    80005598:	f022                	sd	s0,32(sp)
    8000559a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000559c:	fe840613          	addi	a2,s0,-24
    800055a0:	4581                	li	a1,0
    800055a2:	4501                	li	a0,0
    800055a4:	00000097          	auipc	ra,0x0
    800055a8:	d90080e7          	jalr	-624(ra) # 80005334 <argfd>
    return -1;
    800055ac:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800055ae:	04054163          	bltz	a0,800055f0 <sys_read+0x5c>
    800055b2:	fe440593          	addi	a1,s0,-28
    800055b6:	4509                	li	a0,2
    800055b8:	ffffe097          	auipc	ra,0xffffe
    800055bc:	90a080e7          	jalr	-1782(ra) # 80002ec2 <argint>
    return -1;
    800055c0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800055c2:	02054763          	bltz	a0,800055f0 <sys_read+0x5c>
    800055c6:	fd840593          	addi	a1,s0,-40
    800055ca:	4505                	li	a0,1
    800055cc:	ffffe097          	auipc	ra,0xffffe
    800055d0:	918080e7          	jalr	-1768(ra) # 80002ee4 <argaddr>
    return -1;
    800055d4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800055d6:	00054d63          	bltz	a0,800055f0 <sys_read+0x5c>
  return fileread(f, p, n);
    800055da:	fe442603          	lw	a2,-28(s0)
    800055de:	fd843583          	ld	a1,-40(s0)
    800055e2:	fe843503          	ld	a0,-24(s0)
    800055e6:	fffff097          	auipc	ra,0xfffff
    800055ea:	416080e7          	jalr	1046(ra) # 800049fc <fileread>
    800055ee:	87aa                	mv	a5,a0
}
    800055f0:	853e                	mv	a0,a5
    800055f2:	70a2                	ld	ra,40(sp)
    800055f4:	7402                	ld	s0,32(sp)
    800055f6:	6145                	addi	sp,sp,48
    800055f8:	8082                	ret

00000000800055fa <sys_write>:
{
    800055fa:	7179                	addi	sp,sp,-48
    800055fc:	f406                	sd	ra,40(sp)
    800055fe:	f022                	sd	s0,32(sp)
    80005600:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005602:	fe840613          	addi	a2,s0,-24
    80005606:	4581                	li	a1,0
    80005608:	4501                	li	a0,0
    8000560a:	00000097          	auipc	ra,0x0
    8000560e:	d2a080e7          	jalr	-726(ra) # 80005334 <argfd>
    return -1;
    80005612:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005614:	04054163          	bltz	a0,80005656 <sys_write+0x5c>
    80005618:	fe440593          	addi	a1,s0,-28
    8000561c:	4509                	li	a0,2
    8000561e:	ffffe097          	auipc	ra,0xffffe
    80005622:	8a4080e7          	jalr	-1884(ra) # 80002ec2 <argint>
    return -1;
    80005626:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005628:	02054763          	bltz	a0,80005656 <sys_write+0x5c>
    8000562c:	fd840593          	addi	a1,s0,-40
    80005630:	4505                	li	a0,1
    80005632:	ffffe097          	auipc	ra,0xffffe
    80005636:	8b2080e7          	jalr	-1870(ra) # 80002ee4 <argaddr>
    return -1;
    8000563a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000563c:	00054d63          	bltz	a0,80005656 <sys_write+0x5c>
  return filewrite(f, p, n);
    80005640:	fe442603          	lw	a2,-28(s0)
    80005644:	fd843583          	ld	a1,-40(s0)
    80005648:	fe843503          	ld	a0,-24(s0)
    8000564c:	fffff097          	auipc	ra,0xfffff
    80005650:	472080e7          	jalr	1138(ra) # 80004abe <filewrite>
    80005654:	87aa                	mv	a5,a0
}
    80005656:	853e                	mv	a0,a5
    80005658:	70a2                	ld	ra,40(sp)
    8000565a:	7402                	ld	s0,32(sp)
    8000565c:	6145                	addi	sp,sp,48
    8000565e:	8082                	ret

0000000080005660 <sys_close>:
{
    80005660:	1101                	addi	sp,sp,-32
    80005662:	ec06                	sd	ra,24(sp)
    80005664:	e822                	sd	s0,16(sp)
    80005666:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005668:	fe040613          	addi	a2,s0,-32
    8000566c:	fec40593          	addi	a1,s0,-20
    80005670:	4501                	li	a0,0
    80005672:	00000097          	auipc	ra,0x0
    80005676:	cc2080e7          	jalr	-830(ra) # 80005334 <argfd>
    return -1;
    8000567a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000567c:	02054463          	bltz	a0,800056a4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005680:	ffffc097          	auipc	ra,0xffffc
    80005684:	650080e7          	jalr	1616(ra) # 80001cd0 <myproc>
    80005688:	fec42783          	lw	a5,-20(s0)
    8000568c:	07e9                	addi	a5,a5,26
    8000568e:	078e                	slli	a5,a5,0x3
    80005690:	97aa                	add	a5,a5,a0
    80005692:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    80005696:	fe043503          	ld	a0,-32(s0)
    8000569a:	fffff097          	auipc	ra,0xfffff
    8000569e:	228080e7          	jalr	552(ra) # 800048c2 <fileclose>
  return 0;
    800056a2:	4781                	li	a5,0
}
    800056a4:	853e                	mv	a0,a5
    800056a6:	60e2                	ld	ra,24(sp)
    800056a8:	6442                	ld	s0,16(sp)
    800056aa:	6105                	addi	sp,sp,32
    800056ac:	8082                	ret

00000000800056ae <sys_fstat>:
{
    800056ae:	1101                	addi	sp,sp,-32
    800056b0:	ec06                	sd	ra,24(sp)
    800056b2:	e822                	sd	s0,16(sp)
    800056b4:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800056b6:	fe840613          	addi	a2,s0,-24
    800056ba:	4581                	li	a1,0
    800056bc:	4501                	li	a0,0
    800056be:	00000097          	auipc	ra,0x0
    800056c2:	c76080e7          	jalr	-906(ra) # 80005334 <argfd>
    return -1;
    800056c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800056c8:	02054563          	bltz	a0,800056f2 <sys_fstat+0x44>
    800056cc:	fe040593          	addi	a1,s0,-32
    800056d0:	4505                	li	a0,1
    800056d2:	ffffe097          	auipc	ra,0xffffe
    800056d6:	812080e7          	jalr	-2030(ra) # 80002ee4 <argaddr>
    return -1;
    800056da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800056dc:	00054b63          	bltz	a0,800056f2 <sys_fstat+0x44>
  return filestat(f, st);
    800056e0:	fe043583          	ld	a1,-32(s0)
    800056e4:	fe843503          	ld	a0,-24(s0)
    800056e8:	fffff097          	auipc	ra,0xfffff
    800056ec:	2a2080e7          	jalr	674(ra) # 8000498a <filestat>
    800056f0:	87aa                	mv	a5,a0
}
    800056f2:	853e                	mv	a0,a5
    800056f4:	60e2                	ld	ra,24(sp)
    800056f6:	6442                	ld	s0,16(sp)
    800056f8:	6105                	addi	sp,sp,32
    800056fa:	8082                	ret

00000000800056fc <sys_link>:
{
    800056fc:	7169                	addi	sp,sp,-304
    800056fe:	f606                	sd	ra,296(sp)
    80005700:	f222                	sd	s0,288(sp)
    80005702:	ee26                	sd	s1,280(sp)
    80005704:	ea4a                	sd	s2,272(sp)
    80005706:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005708:	08000613          	li	a2,128
    8000570c:	ed040593          	addi	a1,s0,-304
    80005710:	4501                	li	a0,0
    80005712:	ffffd097          	auipc	ra,0xffffd
    80005716:	7f4080e7          	jalr	2036(ra) # 80002f06 <argstr>
    return -1;
    8000571a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000571c:	10054e63          	bltz	a0,80005838 <sys_link+0x13c>
    80005720:	08000613          	li	a2,128
    80005724:	f5040593          	addi	a1,s0,-176
    80005728:	4505                	li	a0,1
    8000572a:	ffffd097          	auipc	ra,0xffffd
    8000572e:	7dc080e7          	jalr	2012(ra) # 80002f06 <argstr>
    return -1;
    80005732:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005734:	10054263          	bltz	a0,80005838 <sys_link+0x13c>
  begin_op();
    80005738:	fffff097          	auipc	ra,0xfffff
    8000573c:	cb8080e7          	jalr	-840(ra) # 800043f0 <begin_op>
  if((ip = namei(old)) == 0){
    80005740:	ed040513          	addi	a0,s0,-304
    80005744:	fffff097          	auipc	ra,0xfffff
    80005748:	aa0080e7          	jalr	-1376(ra) # 800041e4 <namei>
    8000574c:	84aa                	mv	s1,a0
    8000574e:	c551                	beqz	a0,800057da <sys_link+0xde>
  ilock(ip);
    80005750:	ffffe097          	auipc	ra,0xffffe
    80005754:	2e4080e7          	jalr	740(ra) # 80003a34 <ilock>
  if(ip->type == T_DIR){
    80005758:	04449703          	lh	a4,68(s1)
    8000575c:	4785                	li	a5,1
    8000575e:	08f70463          	beq	a4,a5,800057e6 <sys_link+0xea>
  ip->nlink++;
    80005762:	04a4d783          	lhu	a5,74(s1)
    80005766:	2785                	addiw	a5,a5,1
    80005768:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000576c:	8526                	mv	a0,s1
    8000576e:	ffffe097          	auipc	ra,0xffffe
    80005772:	1fc080e7          	jalr	508(ra) # 8000396a <iupdate>
  iunlock(ip);
    80005776:	8526                	mv	a0,s1
    80005778:	ffffe097          	auipc	ra,0xffffe
    8000577c:	37e080e7          	jalr	894(ra) # 80003af6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005780:	fd040593          	addi	a1,s0,-48
    80005784:	f5040513          	addi	a0,s0,-176
    80005788:	fffff097          	auipc	ra,0xfffff
    8000578c:	a7a080e7          	jalr	-1414(ra) # 80004202 <nameiparent>
    80005790:	892a                	mv	s2,a0
    80005792:	c935                	beqz	a0,80005806 <sys_link+0x10a>
  ilock(dp);
    80005794:	ffffe097          	auipc	ra,0xffffe
    80005798:	2a0080e7          	jalr	672(ra) # 80003a34 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000579c:	00092703          	lw	a4,0(s2)
    800057a0:	409c                	lw	a5,0(s1)
    800057a2:	04f71d63          	bne	a4,a5,800057fc <sys_link+0x100>
    800057a6:	40d0                	lw	a2,4(s1)
    800057a8:	fd040593          	addi	a1,s0,-48
    800057ac:	854a                	mv	a0,s2
    800057ae:	fffff097          	auipc	ra,0xfffff
    800057b2:	974080e7          	jalr	-1676(ra) # 80004122 <dirlink>
    800057b6:	04054363          	bltz	a0,800057fc <sys_link+0x100>
  iunlockput(dp);
    800057ba:	854a                	mv	a0,s2
    800057bc:	ffffe097          	auipc	ra,0xffffe
    800057c0:	4da080e7          	jalr	1242(ra) # 80003c96 <iunlockput>
  iput(ip);
    800057c4:	8526                	mv	a0,s1
    800057c6:	ffffe097          	auipc	ra,0xffffe
    800057ca:	428080e7          	jalr	1064(ra) # 80003bee <iput>
  end_op();
    800057ce:	fffff097          	auipc	ra,0xfffff
    800057d2:	ca2080e7          	jalr	-862(ra) # 80004470 <end_op>
  return 0;
    800057d6:	4781                	li	a5,0
    800057d8:	a085                	j	80005838 <sys_link+0x13c>
    end_op();
    800057da:	fffff097          	auipc	ra,0xfffff
    800057de:	c96080e7          	jalr	-874(ra) # 80004470 <end_op>
    return -1;
    800057e2:	57fd                	li	a5,-1
    800057e4:	a891                	j	80005838 <sys_link+0x13c>
    iunlockput(ip);
    800057e6:	8526                	mv	a0,s1
    800057e8:	ffffe097          	auipc	ra,0xffffe
    800057ec:	4ae080e7          	jalr	1198(ra) # 80003c96 <iunlockput>
    end_op();
    800057f0:	fffff097          	auipc	ra,0xfffff
    800057f4:	c80080e7          	jalr	-896(ra) # 80004470 <end_op>
    return -1;
    800057f8:	57fd                	li	a5,-1
    800057fa:	a83d                	j	80005838 <sys_link+0x13c>
    iunlockput(dp);
    800057fc:	854a                	mv	a0,s2
    800057fe:	ffffe097          	auipc	ra,0xffffe
    80005802:	498080e7          	jalr	1176(ra) # 80003c96 <iunlockput>
  ilock(ip);
    80005806:	8526                	mv	a0,s1
    80005808:	ffffe097          	auipc	ra,0xffffe
    8000580c:	22c080e7          	jalr	556(ra) # 80003a34 <ilock>
  ip->nlink--;
    80005810:	04a4d783          	lhu	a5,74(s1)
    80005814:	37fd                	addiw	a5,a5,-1
    80005816:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000581a:	8526                	mv	a0,s1
    8000581c:	ffffe097          	auipc	ra,0xffffe
    80005820:	14e080e7          	jalr	334(ra) # 8000396a <iupdate>
  iunlockput(ip);
    80005824:	8526                	mv	a0,s1
    80005826:	ffffe097          	auipc	ra,0xffffe
    8000582a:	470080e7          	jalr	1136(ra) # 80003c96 <iunlockput>
  end_op();
    8000582e:	fffff097          	auipc	ra,0xfffff
    80005832:	c42080e7          	jalr	-958(ra) # 80004470 <end_op>
  return -1;
    80005836:	57fd                	li	a5,-1
}
    80005838:	853e                	mv	a0,a5
    8000583a:	70b2                	ld	ra,296(sp)
    8000583c:	7412                	ld	s0,288(sp)
    8000583e:	64f2                	ld	s1,280(sp)
    80005840:	6952                	ld	s2,272(sp)
    80005842:	6155                	addi	sp,sp,304
    80005844:	8082                	ret

0000000080005846 <sys_unlink>:
{
    80005846:	7151                	addi	sp,sp,-240
    80005848:	f586                	sd	ra,232(sp)
    8000584a:	f1a2                	sd	s0,224(sp)
    8000584c:	eda6                	sd	s1,216(sp)
    8000584e:	e9ca                	sd	s2,208(sp)
    80005850:	e5ce                	sd	s3,200(sp)
    80005852:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005854:	08000613          	li	a2,128
    80005858:	f3040593          	addi	a1,s0,-208
    8000585c:	4501                	li	a0,0
    8000585e:	ffffd097          	auipc	ra,0xffffd
    80005862:	6a8080e7          	jalr	1704(ra) # 80002f06 <argstr>
    80005866:	18054163          	bltz	a0,800059e8 <sys_unlink+0x1a2>
  begin_op();
    8000586a:	fffff097          	auipc	ra,0xfffff
    8000586e:	b86080e7          	jalr	-1146(ra) # 800043f0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005872:	fb040593          	addi	a1,s0,-80
    80005876:	f3040513          	addi	a0,s0,-208
    8000587a:	fffff097          	auipc	ra,0xfffff
    8000587e:	988080e7          	jalr	-1656(ra) # 80004202 <nameiparent>
    80005882:	84aa                	mv	s1,a0
    80005884:	c979                	beqz	a0,8000595a <sys_unlink+0x114>
  ilock(dp);
    80005886:	ffffe097          	auipc	ra,0xffffe
    8000588a:	1ae080e7          	jalr	430(ra) # 80003a34 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000588e:	00003597          	auipc	a1,0x3
    80005892:	f1a58593          	addi	a1,a1,-230 # 800087a8 <syscalls+0x2c0>
    80005896:	fb040513          	addi	a0,s0,-80
    8000589a:	ffffe097          	auipc	ra,0xffffe
    8000589e:	65e080e7          	jalr	1630(ra) # 80003ef8 <namecmp>
    800058a2:	14050a63          	beqz	a0,800059f6 <sys_unlink+0x1b0>
    800058a6:	00003597          	auipc	a1,0x3
    800058aa:	f0a58593          	addi	a1,a1,-246 # 800087b0 <syscalls+0x2c8>
    800058ae:	fb040513          	addi	a0,s0,-80
    800058b2:	ffffe097          	auipc	ra,0xffffe
    800058b6:	646080e7          	jalr	1606(ra) # 80003ef8 <namecmp>
    800058ba:	12050e63          	beqz	a0,800059f6 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800058be:	f2c40613          	addi	a2,s0,-212
    800058c2:	fb040593          	addi	a1,s0,-80
    800058c6:	8526                	mv	a0,s1
    800058c8:	ffffe097          	auipc	ra,0xffffe
    800058cc:	64a080e7          	jalr	1610(ra) # 80003f12 <dirlookup>
    800058d0:	892a                	mv	s2,a0
    800058d2:	12050263          	beqz	a0,800059f6 <sys_unlink+0x1b0>
  ilock(ip);
    800058d6:	ffffe097          	auipc	ra,0xffffe
    800058da:	15e080e7          	jalr	350(ra) # 80003a34 <ilock>
  if(ip->nlink < 1)
    800058de:	04a91783          	lh	a5,74(s2)
    800058e2:	08f05263          	blez	a5,80005966 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800058e6:	04491703          	lh	a4,68(s2)
    800058ea:	4785                	li	a5,1
    800058ec:	08f70563          	beq	a4,a5,80005976 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800058f0:	4641                	li	a2,16
    800058f2:	4581                	li	a1,0
    800058f4:	fc040513          	addi	a0,s0,-64
    800058f8:	ffffb097          	auipc	ra,0xffffb
    800058fc:	414080e7          	jalr	1044(ra) # 80000d0c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005900:	4741                	li	a4,16
    80005902:	f2c42683          	lw	a3,-212(s0)
    80005906:	fc040613          	addi	a2,s0,-64
    8000590a:	4581                	li	a1,0
    8000590c:	8526                	mv	a0,s1
    8000590e:	ffffe097          	auipc	ra,0xffffe
    80005912:	4d0080e7          	jalr	1232(ra) # 80003dde <writei>
    80005916:	47c1                	li	a5,16
    80005918:	0af51563          	bne	a0,a5,800059c2 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    8000591c:	04491703          	lh	a4,68(s2)
    80005920:	4785                	li	a5,1
    80005922:	0af70863          	beq	a4,a5,800059d2 <sys_unlink+0x18c>
  iunlockput(dp);
    80005926:	8526                	mv	a0,s1
    80005928:	ffffe097          	auipc	ra,0xffffe
    8000592c:	36e080e7          	jalr	878(ra) # 80003c96 <iunlockput>
  ip->nlink--;
    80005930:	04a95783          	lhu	a5,74(s2)
    80005934:	37fd                	addiw	a5,a5,-1
    80005936:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000593a:	854a                	mv	a0,s2
    8000593c:	ffffe097          	auipc	ra,0xffffe
    80005940:	02e080e7          	jalr	46(ra) # 8000396a <iupdate>
  iunlockput(ip);
    80005944:	854a                	mv	a0,s2
    80005946:	ffffe097          	auipc	ra,0xffffe
    8000594a:	350080e7          	jalr	848(ra) # 80003c96 <iunlockput>
  end_op();
    8000594e:	fffff097          	auipc	ra,0xfffff
    80005952:	b22080e7          	jalr	-1246(ra) # 80004470 <end_op>
  return 0;
    80005956:	4501                	li	a0,0
    80005958:	a84d                	j	80005a0a <sys_unlink+0x1c4>
    end_op();
    8000595a:	fffff097          	auipc	ra,0xfffff
    8000595e:	b16080e7          	jalr	-1258(ra) # 80004470 <end_op>
    return -1;
    80005962:	557d                	li	a0,-1
    80005964:	a05d                	j	80005a0a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005966:	00003517          	auipc	a0,0x3
    8000596a:	e7250513          	addi	a0,a0,-398 # 800087d8 <syscalls+0x2f0>
    8000596e:	ffffb097          	auipc	ra,0xffffb
    80005972:	bda080e7          	jalr	-1062(ra) # 80000548 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005976:	04c92703          	lw	a4,76(s2)
    8000597a:	02000793          	li	a5,32
    8000597e:	f6e7f9e3          	bgeu	a5,a4,800058f0 <sys_unlink+0xaa>
    80005982:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005986:	4741                	li	a4,16
    80005988:	86ce                	mv	a3,s3
    8000598a:	f1840613          	addi	a2,s0,-232
    8000598e:	4581                	li	a1,0
    80005990:	854a                	mv	a0,s2
    80005992:	ffffe097          	auipc	ra,0xffffe
    80005996:	356080e7          	jalr	854(ra) # 80003ce8 <readi>
    8000599a:	47c1                	li	a5,16
    8000599c:	00f51b63          	bne	a0,a5,800059b2 <sys_unlink+0x16c>
    if(de.inum != 0)
    800059a0:	f1845783          	lhu	a5,-232(s0)
    800059a4:	e7a1                	bnez	a5,800059ec <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800059a6:	29c1                	addiw	s3,s3,16
    800059a8:	04c92783          	lw	a5,76(s2)
    800059ac:	fcf9ede3          	bltu	s3,a5,80005986 <sys_unlink+0x140>
    800059b0:	b781                	j	800058f0 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800059b2:	00003517          	auipc	a0,0x3
    800059b6:	e3e50513          	addi	a0,a0,-450 # 800087f0 <syscalls+0x308>
    800059ba:	ffffb097          	auipc	ra,0xffffb
    800059be:	b8e080e7          	jalr	-1138(ra) # 80000548 <panic>
    panic("unlink: writei");
    800059c2:	00003517          	auipc	a0,0x3
    800059c6:	e4650513          	addi	a0,a0,-442 # 80008808 <syscalls+0x320>
    800059ca:	ffffb097          	auipc	ra,0xffffb
    800059ce:	b7e080e7          	jalr	-1154(ra) # 80000548 <panic>
    dp->nlink--;
    800059d2:	04a4d783          	lhu	a5,74(s1)
    800059d6:	37fd                	addiw	a5,a5,-1
    800059d8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800059dc:	8526                	mv	a0,s1
    800059de:	ffffe097          	auipc	ra,0xffffe
    800059e2:	f8c080e7          	jalr	-116(ra) # 8000396a <iupdate>
    800059e6:	b781                	j	80005926 <sys_unlink+0xe0>
    return -1;
    800059e8:	557d                	li	a0,-1
    800059ea:	a005                	j	80005a0a <sys_unlink+0x1c4>
    iunlockput(ip);
    800059ec:	854a                	mv	a0,s2
    800059ee:	ffffe097          	auipc	ra,0xffffe
    800059f2:	2a8080e7          	jalr	680(ra) # 80003c96 <iunlockput>
  iunlockput(dp);
    800059f6:	8526                	mv	a0,s1
    800059f8:	ffffe097          	auipc	ra,0xffffe
    800059fc:	29e080e7          	jalr	670(ra) # 80003c96 <iunlockput>
  end_op();
    80005a00:	fffff097          	auipc	ra,0xfffff
    80005a04:	a70080e7          	jalr	-1424(ra) # 80004470 <end_op>
  return -1;
    80005a08:	557d                	li	a0,-1
}
    80005a0a:	70ae                	ld	ra,232(sp)
    80005a0c:	740e                	ld	s0,224(sp)
    80005a0e:	64ee                	ld	s1,216(sp)
    80005a10:	694e                	ld	s2,208(sp)
    80005a12:	69ae                	ld	s3,200(sp)
    80005a14:	616d                	addi	sp,sp,240
    80005a16:	8082                	ret

0000000080005a18 <sys_open>:

uint64
sys_open(void)
{
    80005a18:	7131                	addi	sp,sp,-192
    80005a1a:	fd06                	sd	ra,184(sp)
    80005a1c:	f922                	sd	s0,176(sp)
    80005a1e:	f526                	sd	s1,168(sp)
    80005a20:	f14a                	sd	s2,160(sp)
    80005a22:	ed4e                	sd	s3,152(sp)
    80005a24:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005a26:	08000613          	li	a2,128
    80005a2a:	f5040593          	addi	a1,s0,-176
    80005a2e:	4501                	li	a0,0
    80005a30:	ffffd097          	auipc	ra,0xffffd
    80005a34:	4d6080e7          	jalr	1238(ra) # 80002f06 <argstr>
    return -1;
    80005a38:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005a3a:	0c054163          	bltz	a0,80005afc <sys_open+0xe4>
    80005a3e:	f4c40593          	addi	a1,s0,-180
    80005a42:	4505                	li	a0,1
    80005a44:	ffffd097          	auipc	ra,0xffffd
    80005a48:	47e080e7          	jalr	1150(ra) # 80002ec2 <argint>
    80005a4c:	0a054863          	bltz	a0,80005afc <sys_open+0xe4>

  begin_op();
    80005a50:	fffff097          	auipc	ra,0xfffff
    80005a54:	9a0080e7          	jalr	-1632(ra) # 800043f0 <begin_op>

  if(omode & O_CREATE){
    80005a58:	f4c42783          	lw	a5,-180(s0)
    80005a5c:	2007f793          	andi	a5,a5,512
    80005a60:	cbdd                	beqz	a5,80005b16 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005a62:	4681                	li	a3,0
    80005a64:	4601                	li	a2,0
    80005a66:	4589                	li	a1,2
    80005a68:	f5040513          	addi	a0,s0,-176
    80005a6c:	00000097          	auipc	ra,0x0
    80005a70:	972080e7          	jalr	-1678(ra) # 800053de <create>
    80005a74:	892a                	mv	s2,a0
    if(ip == 0){
    80005a76:	c959                	beqz	a0,80005b0c <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005a78:	04491703          	lh	a4,68(s2)
    80005a7c:	478d                	li	a5,3
    80005a7e:	00f71763          	bne	a4,a5,80005a8c <sys_open+0x74>
    80005a82:	04695703          	lhu	a4,70(s2)
    80005a86:	47a5                	li	a5,9
    80005a88:	0ce7ec63          	bltu	a5,a4,80005b60 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005a8c:	fffff097          	auipc	ra,0xfffff
    80005a90:	d7a080e7          	jalr	-646(ra) # 80004806 <filealloc>
    80005a94:	89aa                	mv	s3,a0
    80005a96:	10050263          	beqz	a0,80005b9a <sys_open+0x182>
    80005a9a:	00000097          	auipc	ra,0x0
    80005a9e:	902080e7          	jalr	-1790(ra) # 8000539c <fdalloc>
    80005aa2:	84aa                	mv	s1,a0
    80005aa4:	0e054663          	bltz	a0,80005b90 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005aa8:	04491703          	lh	a4,68(s2)
    80005aac:	478d                	li	a5,3
    80005aae:	0cf70463          	beq	a4,a5,80005b76 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005ab2:	4789                	li	a5,2
    80005ab4:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005ab8:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005abc:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005ac0:	f4c42783          	lw	a5,-180(s0)
    80005ac4:	0017c713          	xori	a4,a5,1
    80005ac8:	8b05                	andi	a4,a4,1
    80005aca:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005ace:	0037f713          	andi	a4,a5,3
    80005ad2:	00e03733          	snez	a4,a4
    80005ad6:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005ada:	4007f793          	andi	a5,a5,1024
    80005ade:	c791                	beqz	a5,80005aea <sys_open+0xd2>
    80005ae0:	04491703          	lh	a4,68(s2)
    80005ae4:	4789                	li	a5,2
    80005ae6:	08f70f63          	beq	a4,a5,80005b84 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005aea:	854a                	mv	a0,s2
    80005aec:	ffffe097          	auipc	ra,0xffffe
    80005af0:	00a080e7          	jalr	10(ra) # 80003af6 <iunlock>
  end_op();
    80005af4:	fffff097          	auipc	ra,0xfffff
    80005af8:	97c080e7          	jalr	-1668(ra) # 80004470 <end_op>

  return fd;
}
    80005afc:	8526                	mv	a0,s1
    80005afe:	70ea                	ld	ra,184(sp)
    80005b00:	744a                	ld	s0,176(sp)
    80005b02:	74aa                	ld	s1,168(sp)
    80005b04:	790a                	ld	s2,160(sp)
    80005b06:	69ea                	ld	s3,152(sp)
    80005b08:	6129                	addi	sp,sp,192
    80005b0a:	8082                	ret
      end_op();
    80005b0c:	fffff097          	auipc	ra,0xfffff
    80005b10:	964080e7          	jalr	-1692(ra) # 80004470 <end_op>
      return -1;
    80005b14:	b7e5                	j	80005afc <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005b16:	f5040513          	addi	a0,s0,-176
    80005b1a:	ffffe097          	auipc	ra,0xffffe
    80005b1e:	6ca080e7          	jalr	1738(ra) # 800041e4 <namei>
    80005b22:	892a                	mv	s2,a0
    80005b24:	c905                	beqz	a0,80005b54 <sys_open+0x13c>
    ilock(ip);
    80005b26:	ffffe097          	auipc	ra,0xffffe
    80005b2a:	f0e080e7          	jalr	-242(ra) # 80003a34 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005b2e:	04491703          	lh	a4,68(s2)
    80005b32:	4785                	li	a5,1
    80005b34:	f4f712e3          	bne	a4,a5,80005a78 <sys_open+0x60>
    80005b38:	f4c42783          	lw	a5,-180(s0)
    80005b3c:	dba1                	beqz	a5,80005a8c <sys_open+0x74>
      iunlockput(ip);
    80005b3e:	854a                	mv	a0,s2
    80005b40:	ffffe097          	auipc	ra,0xffffe
    80005b44:	156080e7          	jalr	342(ra) # 80003c96 <iunlockput>
      end_op();
    80005b48:	fffff097          	auipc	ra,0xfffff
    80005b4c:	928080e7          	jalr	-1752(ra) # 80004470 <end_op>
      return -1;
    80005b50:	54fd                	li	s1,-1
    80005b52:	b76d                	j	80005afc <sys_open+0xe4>
      end_op();
    80005b54:	fffff097          	auipc	ra,0xfffff
    80005b58:	91c080e7          	jalr	-1764(ra) # 80004470 <end_op>
      return -1;
    80005b5c:	54fd                	li	s1,-1
    80005b5e:	bf79                	j	80005afc <sys_open+0xe4>
    iunlockput(ip);
    80005b60:	854a                	mv	a0,s2
    80005b62:	ffffe097          	auipc	ra,0xffffe
    80005b66:	134080e7          	jalr	308(ra) # 80003c96 <iunlockput>
    end_op();
    80005b6a:	fffff097          	auipc	ra,0xfffff
    80005b6e:	906080e7          	jalr	-1786(ra) # 80004470 <end_op>
    return -1;
    80005b72:	54fd                	li	s1,-1
    80005b74:	b761                	j	80005afc <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005b76:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005b7a:	04691783          	lh	a5,70(s2)
    80005b7e:	02f99223          	sh	a5,36(s3)
    80005b82:	bf2d                	j	80005abc <sys_open+0xa4>
    itrunc(ip);
    80005b84:	854a                	mv	a0,s2
    80005b86:	ffffe097          	auipc	ra,0xffffe
    80005b8a:	fbc080e7          	jalr	-68(ra) # 80003b42 <itrunc>
    80005b8e:	bfb1                	j	80005aea <sys_open+0xd2>
      fileclose(f);
    80005b90:	854e                	mv	a0,s3
    80005b92:	fffff097          	auipc	ra,0xfffff
    80005b96:	d30080e7          	jalr	-720(ra) # 800048c2 <fileclose>
    iunlockput(ip);
    80005b9a:	854a                	mv	a0,s2
    80005b9c:	ffffe097          	auipc	ra,0xffffe
    80005ba0:	0fa080e7          	jalr	250(ra) # 80003c96 <iunlockput>
    end_op();
    80005ba4:	fffff097          	auipc	ra,0xfffff
    80005ba8:	8cc080e7          	jalr	-1844(ra) # 80004470 <end_op>
    return -1;
    80005bac:	54fd                	li	s1,-1
    80005bae:	b7b9                	j	80005afc <sys_open+0xe4>

0000000080005bb0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005bb0:	7175                	addi	sp,sp,-144
    80005bb2:	e506                	sd	ra,136(sp)
    80005bb4:	e122                	sd	s0,128(sp)
    80005bb6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005bb8:	fffff097          	auipc	ra,0xfffff
    80005bbc:	838080e7          	jalr	-1992(ra) # 800043f0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005bc0:	08000613          	li	a2,128
    80005bc4:	f7040593          	addi	a1,s0,-144
    80005bc8:	4501                	li	a0,0
    80005bca:	ffffd097          	auipc	ra,0xffffd
    80005bce:	33c080e7          	jalr	828(ra) # 80002f06 <argstr>
    80005bd2:	02054963          	bltz	a0,80005c04 <sys_mkdir+0x54>
    80005bd6:	4681                	li	a3,0
    80005bd8:	4601                	li	a2,0
    80005bda:	4585                	li	a1,1
    80005bdc:	f7040513          	addi	a0,s0,-144
    80005be0:	fffff097          	auipc	ra,0xfffff
    80005be4:	7fe080e7          	jalr	2046(ra) # 800053de <create>
    80005be8:	cd11                	beqz	a0,80005c04 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005bea:	ffffe097          	auipc	ra,0xffffe
    80005bee:	0ac080e7          	jalr	172(ra) # 80003c96 <iunlockput>
  end_op();
    80005bf2:	fffff097          	auipc	ra,0xfffff
    80005bf6:	87e080e7          	jalr	-1922(ra) # 80004470 <end_op>
  return 0;
    80005bfa:	4501                	li	a0,0
}
    80005bfc:	60aa                	ld	ra,136(sp)
    80005bfe:	640a                	ld	s0,128(sp)
    80005c00:	6149                	addi	sp,sp,144
    80005c02:	8082                	ret
    end_op();
    80005c04:	fffff097          	auipc	ra,0xfffff
    80005c08:	86c080e7          	jalr	-1940(ra) # 80004470 <end_op>
    return -1;
    80005c0c:	557d                	li	a0,-1
    80005c0e:	b7fd                	j	80005bfc <sys_mkdir+0x4c>

0000000080005c10 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005c10:	7135                	addi	sp,sp,-160
    80005c12:	ed06                	sd	ra,152(sp)
    80005c14:	e922                	sd	s0,144(sp)
    80005c16:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005c18:	ffffe097          	auipc	ra,0xffffe
    80005c1c:	7d8080e7          	jalr	2008(ra) # 800043f0 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005c20:	08000613          	li	a2,128
    80005c24:	f7040593          	addi	a1,s0,-144
    80005c28:	4501                	li	a0,0
    80005c2a:	ffffd097          	auipc	ra,0xffffd
    80005c2e:	2dc080e7          	jalr	732(ra) # 80002f06 <argstr>
    80005c32:	04054a63          	bltz	a0,80005c86 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005c36:	f6c40593          	addi	a1,s0,-148
    80005c3a:	4505                	li	a0,1
    80005c3c:	ffffd097          	auipc	ra,0xffffd
    80005c40:	286080e7          	jalr	646(ra) # 80002ec2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005c44:	04054163          	bltz	a0,80005c86 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005c48:	f6840593          	addi	a1,s0,-152
    80005c4c:	4509                	li	a0,2
    80005c4e:	ffffd097          	auipc	ra,0xffffd
    80005c52:	274080e7          	jalr	628(ra) # 80002ec2 <argint>
     argint(1, &major) < 0 ||
    80005c56:	02054863          	bltz	a0,80005c86 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005c5a:	f6841683          	lh	a3,-152(s0)
    80005c5e:	f6c41603          	lh	a2,-148(s0)
    80005c62:	458d                	li	a1,3
    80005c64:	f7040513          	addi	a0,s0,-144
    80005c68:	fffff097          	auipc	ra,0xfffff
    80005c6c:	776080e7          	jalr	1910(ra) # 800053de <create>
     argint(2, &minor) < 0 ||
    80005c70:	c919                	beqz	a0,80005c86 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005c72:	ffffe097          	auipc	ra,0xffffe
    80005c76:	024080e7          	jalr	36(ra) # 80003c96 <iunlockput>
  end_op();
    80005c7a:	ffffe097          	auipc	ra,0xffffe
    80005c7e:	7f6080e7          	jalr	2038(ra) # 80004470 <end_op>
  return 0;
    80005c82:	4501                	li	a0,0
    80005c84:	a031                	j	80005c90 <sys_mknod+0x80>
    end_op();
    80005c86:	ffffe097          	auipc	ra,0xffffe
    80005c8a:	7ea080e7          	jalr	2026(ra) # 80004470 <end_op>
    return -1;
    80005c8e:	557d                	li	a0,-1
}
    80005c90:	60ea                	ld	ra,152(sp)
    80005c92:	644a                	ld	s0,144(sp)
    80005c94:	610d                	addi	sp,sp,160
    80005c96:	8082                	ret

0000000080005c98 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005c98:	7135                	addi	sp,sp,-160
    80005c9a:	ed06                	sd	ra,152(sp)
    80005c9c:	e922                	sd	s0,144(sp)
    80005c9e:	e526                	sd	s1,136(sp)
    80005ca0:	e14a                	sd	s2,128(sp)
    80005ca2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005ca4:	ffffc097          	auipc	ra,0xffffc
    80005ca8:	02c080e7          	jalr	44(ra) # 80001cd0 <myproc>
    80005cac:	892a                	mv	s2,a0
  
  begin_op();
    80005cae:	ffffe097          	auipc	ra,0xffffe
    80005cb2:	742080e7          	jalr	1858(ra) # 800043f0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005cb6:	08000613          	li	a2,128
    80005cba:	f6040593          	addi	a1,s0,-160
    80005cbe:	4501                	li	a0,0
    80005cc0:	ffffd097          	auipc	ra,0xffffd
    80005cc4:	246080e7          	jalr	582(ra) # 80002f06 <argstr>
    80005cc8:	04054b63          	bltz	a0,80005d1e <sys_chdir+0x86>
    80005ccc:	f6040513          	addi	a0,s0,-160
    80005cd0:	ffffe097          	auipc	ra,0xffffe
    80005cd4:	514080e7          	jalr	1300(ra) # 800041e4 <namei>
    80005cd8:	84aa                	mv	s1,a0
    80005cda:	c131                	beqz	a0,80005d1e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005cdc:	ffffe097          	auipc	ra,0xffffe
    80005ce0:	d58080e7          	jalr	-680(ra) # 80003a34 <ilock>
  if(ip->type != T_DIR){
    80005ce4:	04449703          	lh	a4,68(s1)
    80005ce8:	4785                	li	a5,1
    80005cea:	04f71063          	bne	a4,a5,80005d2a <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005cee:	8526                	mv	a0,s1
    80005cf0:	ffffe097          	auipc	ra,0xffffe
    80005cf4:	e06080e7          	jalr	-506(ra) # 80003af6 <iunlock>
  iput(p->cwd);
    80005cf8:	15893503          	ld	a0,344(s2)
    80005cfc:	ffffe097          	auipc	ra,0xffffe
    80005d00:	ef2080e7          	jalr	-270(ra) # 80003bee <iput>
  end_op();
    80005d04:	ffffe097          	auipc	ra,0xffffe
    80005d08:	76c080e7          	jalr	1900(ra) # 80004470 <end_op>
  p->cwd = ip;
    80005d0c:	14993c23          	sd	s1,344(s2)
  return 0;
    80005d10:	4501                	li	a0,0
}
    80005d12:	60ea                	ld	ra,152(sp)
    80005d14:	644a                	ld	s0,144(sp)
    80005d16:	64aa                	ld	s1,136(sp)
    80005d18:	690a                	ld	s2,128(sp)
    80005d1a:	610d                	addi	sp,sp,160
    80005d1c:	8082                	ret
    end_op();
    80005d1e:	ffffe097          	auipc	ra,0xffffe
    80005d22:	752080e7          	jalr	1874(ra) # 80004470 <end_op>
    return -1;
    80005d26:	557d                	li	a0,-1
    80005d28:	b7ed                	j	80005d12 <sys_chdir+0x7a>
    iunlockput(ip);
    80005d2a:	8526                	mv	a0,s1
    80005d2c:	ffffe097          	auipc	ra,0xffffe
    80005d30:	f6a080e7          	jalr	-150(ra) # 80003c96 <iunlockput>
    end_op();
    80005d34:	ffffe097          	auipc	ra,0xffffe
    80005d38:	73c080e7          	jalr	1852(ra) # 80004470 <end_op>
    return -1;
    80005d3c:	557d                	li	a0,-1
    80005d3e:	bfd1                	j	80005d12 <sys_chdir+0x7a>

0000000080005d40 <sys_exec>:

uint64
sys_exec(void)
{
    80005d40:	7145                	addi	sp,sp,-464
    80005d42:	e786                	sd	ra,456(sp)
    80005d44:	e3a2                	sd	s0,448(sp)
    80005d46:	ff26                	sd	s1,440(sp)
    80005d48:	fb4a                	sd	s2,432(sp)
    80005d4a:	f74e                	sd	s3,424(sp)
    80005d4c:	f352                	sd	s4,416(sp)
    80005d4e:	ef56                	sd	s5,408(sp)
    80005d50:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005d52:	08000613          	li	a2,128
    80005d56:	f4040593          	addi	a1,s0,-192
    80005d5a:	4501                	li	a0,0
    80005d5c:	ffffd097          	auipc	ra,0xffffd
    80005d60:	1aa080e7          	jalr	426(ra) # 80002f06 <argstr>
    return -1;
    80005d64:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005d66:	0c054a63          	bltz	a0,80005e3a <sys_exec+0xfa>
    80005d6a:	e3840593          	addi	a1,s0,-456
    80005d6e:	4505                	li	a0,1
    80005d70:	ffffd097          	auipc	ra,0xffffd
    80005d74:	174080e7          	jalr	372(ra) # 80002ee4 <argaddr>
    80005d78:	0c054163          	bltz	a0,80005e3a <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005d7c:	10000613          	li	a2,256
    80005d80:	4581                	li	a1,0
    80005d82:	e4040513          	addi	a0,s0,-448
    80005d86:	ffffb097          	auipc	ra,0xffffb
    80005d8a:	f86080e7          	jalr	-122(ra) # 80000d0c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005d8e:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005d92:	89a6                	mv	s3,s1
    80005d94:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005d96:	02000a13          	li	s4,32
    80005d9a:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005d9e:	00391513          	slli	a0,s2,0x3
    80005da2:	e3040593          	addi	a1,s0,-464
    80005da6:	e3843783          	ld	a5,-456(s0)
    80005daa:	953e                	add	a0,a0,a5
    80005dac:	ffffd097          	auipc	ra,0xffffd
    80005db0:	07c080e7          	jalr	124(ra) # 80002e28 <fetchaddr>
    80005db4:	02054a63          	bltz	a0,80005de8 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005db8:	e3043783          	ld	a5,-464(s0)
    80005dbc:	c3b9                	beqz	a5,80005e02 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005dbe:	ffffb097          	auipc	ra,0xffffb
    80005dc2:	d62080e7          	jalr	-670(ra) # 80000b20 <kalloc>
    80005dc6:	85aa                	mv	a1,a0
    80005dc8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005dcc:	cd11                	beqz	a0,80005de8 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005dce:	6605                	lui	a2,0x1
    80005dd0:	e3043503          	ld	a0,-464(s0)
    80005dd4:	ffffd097          	auipc	ra,0xffffd
    80005dd8:	0a6080e7          	jalr	166(ra) # 80002e7a <fetchstr>
    80005ddc:	00054663          	bltz	a0,80005de8 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005de0:	0905                	addi	s2,s2,1
    80005de2:	09a1                	addi	s3,s3,8
    80005de4:	fb491be3          	bne	s2,s4,80005d9a <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005de8:	10048913          	addi	s2,s1,256
    80005dec:	6088                	ld	a0,0(s1)
    80005dee:	c529                	beqz	a0,80005e38 <sys_exec+0xf8>
    kfree(argv[i]);
    80005df0:	ffffb097          	auipc	ra,0xffffb
    80005df4:	c34080e7          	jalr	-972(ra) # 80000a24 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005df8:	04a1                	addi	s1,s1,8
    80005dfa:	ff2499e3          	bne	s1,s2,80005dec <sys_exec+0xac>
  return -1;
    80005dfe:	597d                	li	s2,-1
    80005e00:	a82d                	j	80005e3a <sys_exec+0xfa>
      argv[i] = 0;
    80005e02:	0a8e                	slli	s5,s5,0x3
    80005e04:	fc040793          	addi	a5,s0,-64
    80005e08:	9abe                	add	s5,s5,a5
    80005e0a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005e0e:	e4040593          	addi	a1,s0,-448
    80005e12:	f4040513          	addi	a0,s0,-192
    80005e16:	fffff097          	auipc	ra,0xfffff
    80005e1a:	15c080e7          	jalr	348(ra) # 80004f72 <exec>
    80005e1e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e20:	10048993          	addi	s3,s1,256
    80005e24:	6088                	ld	a0,0(s1)
    80005e26:	c911                	beqz	a0,80005e3a <sys_exec+0xfa>
    kfree(argv[i]);
    80005e28:	ffffb097          	auipc	ra,0xffffb
    80005e2c:	bfc080e7          	jalr	-1028(ra) # 80000a24 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e30:	04a1                	addi	s1,s1,8
    80005e32:	ff3499e3          	bne	s1,s3,80005e24 <sys_exec+0xe4>
    80005e36:	a011                	j	80005e3a <sys_exec+0xfa>
  return -1;
    80005e38:	597d                	li	s2,-1
}
    80005e3a:	854a                	mv	a0,s2
    80005e3c:	60be                	ld	ra,456(sp)
    80005e3e:	641e                	ld	s0,448(sp)
    80005e40:	74fa                	ld	s1,440(sp)
    80005e42:	795a                	ld	s2,432(sp)
    80005e44:	79ba                	ld	s3,424(sp)
    80005e46:	7a1a                	ld	s4,416(sp)
    80005e48:	6afa                	ld	s5,408(sp)
    80005e4a:	6179                	addi	sp,sp,464
    80005e4c:	8082                	ret

0000000080005e4e <sys_pipe>:

uint64
sys_pipe(void)
{
    80005e4e:	7139                	addi	sp,sp,-64
    80005e50:	fc06                	sd	ra,56(sp)
    80005e52:	f822                	sd	s0,48(sp)
    80005e54:	f426                	sd	s1,40(sp)
    80005e56:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005e58:	ffffc097          	auipc	ra,0xffffc
    80005e5c:	e78080e7          	jalr	-392(ra) # 80001cd0 <myproc>
    80005e60:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005e62:	fd840593          	addi	a1,s0,-40
    80005e66:	4501                	li	a0,0
    80005e68:	ffffd097          	auipc	ra,0xffffd
    80005e6c:	07c080e7          	jalr	124(ra) # 80002ee4 <argaddr>
    return -1;
    80005e70:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005e72:	0e054063          	bltz	a0,80005f52 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005e76:	fc840593          	addi	a1,s0,-56
    80005e7a:	fd040513          	addi	a0,s0,-48
    80005e7e:	fffff097          	auipc	ra,0xfffff
    80005e82:	d9a080e7          	jalr	-614(ra) # 80004c18 <pipealloc>
    return -1;
    80005e86:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005e88:	0c054563          	bltz	a0,80005f52 <sys_pipe+0x104>
  fd0 = -1;
    80005e8c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005e90:	fd043503          	ld	a0,-48(s0)
    80005e94:	fffff097          	auipc	ra,0xfffff
    80005e98:	508080e7          	jalr	1288(ra) # 8000539c <fdalloc>
    80005e9c:	fca42223          	sw	a0,-60(s0)
    80005ea0:	08054c63          	bltz	a0,80005f38 <sys_pipe+0xea>
    80005ea4:	fc843503          	ld	a0,-56(s0)
    80005ea8:	fffff097          	auipc	ra,0xfffff
    80005eac:	4f4080e7          	jalr	1268(ra) # 8000539c <fdalloc>
    80005eb0:	fca42023          	sw	a0,-64(s0)
    80005eb4:	06054863          	bltz	a0,80005f24 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005eb8:	4691                	li	a3,4
    80005eba:	fc440613          	addi	a2,s0,-60
    80005ebe:	fd843583          	ld	a1,-40(s0)
    80005ec2:	68a8                	ld	a0,80(s1)
    80005ec4:	ffffc097          	auipc	ra,0xffffc
    80005ec8:	bb0080e7          	jalr	-1104(ra) # 80001a74 <copyout>
    80005ecc:	02054063          	bltz	a0,80005eec <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005ed0:	4691                	li	a3,4
    80005ed2:	fc040613          	addi	a2,s0,-64
    80005ed6:	fd843583          	ld	a1,-40(s0)
    80005eda:	0591                	addi	a1,a1,4
    80005edc:	68a8                	ld	a0,80(s1)
    80005ede:	ffffc097          	auipc	ra,0xffffc
    80005ee2:	b96080e7          	jalr	-1130(ra) # 80001a74 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005ee6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005ee8:	06055563          	bgez	a0,80005f52 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005eec:	fc442783          	lw	a5,-60(s0)
    80005ef0:	07e9                	addi	a5,a5,26
    80005ef2:	078e                	slli	a5,a5,0x3
    80005ef4:	97a6                	add	a5,a5,s1
    80005ef6:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005efa:	fc042503          	lw	a0,-64(s0)
    80005efe:	0569                	addi	a0,a0,26
    80005f00:	050e                	slli	a0,a0,0x3
    80005f02:	9526                	add	a0,a0,s1
    80005f04:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005f08:	fd043503          	ld	a0,-48(s0)
    80005f0c:	fffff097          	auipc	ra,0xfffff
    80005f10:	9b6080e7          	jalr	-1610(ra) # 800048c2 <fileclose>
    fileclose(wf);
    80005f14:	fc843503          	ld	a0,-56(s0)
    80005f18:	fffff097          	auipc	ra,0xfffff
    80005f1c:	9aa080e7          	jalr	-1622(ra) # 800048c2 <fileclose>
    return -1;
    80005f20:	57fd                	li	a5,-1
    80005f22:	a805                	j	80005f52 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005f24:	fc442783          	lw	a5,-60(s0)
    80005f28:	0007c863          	bltz	a5,80005f38 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005f2c:	01a78513          	addi	a0,a5,26
    80005f30:	050e                	slli	a0,a0,0x3
    80005f32:	9526                	add	a0,a0,s1
    80005f34:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005f38:	fd043503          	ld	a0,-48(s0)
    80005f3c:	fffff097          	auipc	ra,0xfffff
    80005f40:	986080e7          	jalr	-1658(ra) # 800048c2 <fileclose>
    fileclose(wf);
    80005f44:	fc843503          	ld	a0,-56(s0)
    80005f48:	fffff097          	auipc	ra,0xfffff
    80005f4c:	97a080e7          	jalr	-1670(ra) # 800048c2 <fileclose>
    return -1;
    80005f50:	57fd                	li	a5,-1
}
    80005f52:	853e                	mv	a0,a5
    80005f54:	70e2                	ld	ra,56(sp)
    80005f56:	7442                	ld	s0,48(sp)
    80005f58:	74a2                	ld	s1,40(sp)
    80005f5a:	6121                	addi	sp,sp,64
    80005f5c:	8082                	ret
	...

0000000080005f60 <kernelvec>:
    80005f60:	7111                	addi	sp,sp,-256
    80005f62:	e006                	sd	ra,0(sp)
    80005f64:	e40a                	sd	sp,8(sp)
    80005f66:	e80e                	sd	gp,16(sp)
    80005f68:	ec12                	sd	tp,24(sp)
    80005f6a:	f016                	sd	t0,32(sp)
    80005f6c:	f41a                	sd	t1,40(sp)
    80005f6e:	f81e                	sd	t2,48(sp)
    80005f70:	fc22                	sd	s0,56(sp)
    80005f72:	e0a6                	sd	s1,64(sp)
    80005f74:	e4aa                	sd	a0,72(sp)
    80005f76:	e8ae                	sd	a1,80(sp)
    80005f78:	ecb2                	sd	a2,88(sp)
    80005f7a:	f0b6                	sd	a3,96(sp)
    80005f7c:	f4ba                	sd	a4,104(sp)
    80005f7e:	f8be                	sd	a5,112(sp)
    80005f80:	fcc2                	sd	a6,120(sp)
    80005f82:	e146                	sd	a7,128(sp)
    80005f84:	e54a                	sd	s2,136(sp)
    80005f86:	e94e                	sd	s3,144(sp)
    80005f88:	ed52                	sd	s4,152(sp)
    80005f8a:	f156                	sd	s5,160(sp)
    80005f8c:	f55a                	sd	s6,168(sp)
    80005f8e:	f95e                	sd	s7,176(sp)
    80005f90:	fd62                	sd	s8,184(sp)
    80005f92:	e1e6                	sd	s9,192(sp)
    80005f94:	e5ea                	sd	s10,200(sp)
    80005f96:	e9ee                	sd	s11,208(sp)
    80005f98:	edf2                	sd	t3,216(sp)
    80005f9a:	f1f6                	sd	t4,224(sp)
    80005f9c:	f5fa                	sd	t5,232(sp)
    80005f9e:	f9fe                	sd	t6,240(sp)
    80005fa0:	d55fc0ef          	jal	ra,80002cf4 <kerneltrap>
    80005fa4:	6082                	ld	ra,0(sp)
    80005fa6:	6122                	ld	sp,8(sp)
    80005fa8:	61c2                	ld	gp,16(sp)
    80005faa:	7282                	ld	t0,32(sp)
    80005fac:	7322                	ld	t1,40(sp)
    80005fae:	73c2                	ld	t2,48(sp)
    80005fb0:	7462                	ld	s0,56(sp)
    80005fb2:	6486                	ld	s1,64(sp)
    80005fb4:	6526                	ld	a0,72(sp)
    80005fb6:	65c6                	ld	a1,80(sp)
    80005fb8:	6666                	ld	a2,88(sp)
    80005fba:	7686                	ld	a3,96(sp)
    80005fbc:	7726                	ld	a4,104(sp)
    80005fbe:	77c6                	ld	a5,112(sp)
    80005fc0:	7866                	ld	a6,120(sp)
    80005fc2:	688a                	ld	a7,128(sp)
    80005fc4:	692a                	ld	s2,136(sp)
    80005fc6:	69ca                	ld	s3,144(sp)
    80005fc8:	6a6a                	ld	s4,152(sp)
    80005fca:	7a8a                	ld	s5,160(sp)
    80005fcc:	7b2a                	ld	s6,168(sp)
    80005fce:	7bca                	ld	s7,176(sp)
    80005fd0:	7c6a                	ld	s8,184(sp)
    80005fd2:	6c8e                	ld	s9,192(sp)
    80005fd4:	6d2e                	ld	s10,200(sp)
    80005fd6:	6dce                	ld	s11,208(sp)
    80005fd8:	6e6e                	ld	t3,216(sp)
    80005fda:	7e8e                	ld	t4,224(sp)
    80005fdc:	7f2e                	ld	t5,232(sp)
    80005fde:	7fce                	ld	t6,240(sp)
    80005fe0:	6111                	addi	sp,sp,256
    80005fe2:	10200073          	sret
    80005fe6:	00000013          	nop
    80005fea:	00000013          	nop
    80005fee:	0001                	nop

0000000080005ff0 <timervec>:
    80005ff0:	34051573          	csrrw	a0,mscratch,a0
    80005ff4:	e10c                	sd	a1,0(a0)
    80005ff6:	e510                	sd	a2,8(a0)
    80005ff8:	e914                	sd	a3,16(a0)
    80005ffa:	710c                	ld	a1,32(a0)
    80005ffc:	7510                	ld	a2,40(a0)
    80005ffe:	6194                	ld	a3,0(a1)
    80006000:	96b2                	add	a3,a3,a2
    80006002:	e194                	sd	a3,0(a1)
    80006004:	4589                	li	a1,2
    80006006:	14459073          	csrw	sip,a1
    8000600a:	6914                	ld	a3,16(a0)
    8000600c:	6510                	ld	a2,8(a0)
    8000600e:	610c                	ld	a1,0(a0)
    80006010:	34051573          	csrrw	a0,mscratch,a0
    80006014:	30200073          	mret
	...

000000008000601a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000601a:	1141                	addi	sp,sp,-16
    8000601c:	e422                	sd	s0,8(sp)
    8000601e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006020:	0c0007b7          	lui	a5,0xc000
    80006024:	4705                	li	a4,1
    80006026:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006028:	c3d8                	sw	a4,4(a5)
}
    8000602a:	6422                	ld	s0,8(sp)
    8000602c:	0141                	addi	sp,sp,16
    8000602e:	8082                	ret

0000000080006030 <plicinithart>:

void
plicinithart(void)
{
    80006030:	1141                	addi	sp,sp,-16
    80006032:	e406                	sd	ra,8(sp)
    80006034:	e022                	sd	s0,0(sp)
    80006036:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006038:	ffffc097          	auipc	ra,0xffffc
    8000603c:	c6c080e7          	jalr	-916(ra) # 80001ca4 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006040:	0085171b          	slliw	a4,a0,0x8
    80006044:	0c0027b7          	lui	a5,0xc002
    80006048:	97ba                	add	a5,a5,a4
    8000604a:	40200713          	li	a4,1026
    8000604e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006052:	00d5151b          	slliw	a0,a0,0xd
    80006056:	0c2017b7          	lui	a5,0xc201
    8000605a:	953e                	add	a0,a0,a5
    8000605c:	00052023          	sw	zero,0(a0)
}
    80006060:	60a2                	ld	ra,8(sp)
    80006062:	6402                	ld	s0,0(sp)
    80006064:	0141                	addi	sp,sp,16
    80006066:	8082                	ret

0000000080006068 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006068:	1141                	addi	sp,sp,-16
    8000606a:	e406                	sd	ra,8(sp)
    8000606c:	e022                	sd	s0,0(sp)
    8000606e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006070:	ffffc097          	auipc	ra,0xffffc
    80006074:	c34080e7          	jalr	-972(ra) # 80001ca4 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006078:	00d5179b          	slliw	a5,a0,0xd
    8000607c:	0c201537          	lui	a0,0xc201
    80006080:	953e                	add	a0,a0,a5
  return irq;
}
    80006082:	4148                	lw	a0,4(a0)
    80006084:	60a2                	ld	ra,8(sp)
    80006086:	6402                	ld	s0,0(sp)
    80006088:	0141                	addi	sp,sp,16
    8000608a:	8082                	ret

000000008000608c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000608c:	1101                	addi	sp,sp,-32
    8000608e:	ec06                	sd	ra,24(sp)
    80006090:	e822                	sd	s0,16(sp)
    80006092:	e426                	sd	s1,8(sp)
    80006094:	1000                	addi	s0,sp,32
    80006096:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006098:	ffffc097          	auipc	ra,0xffffc
    8000609c:	c0c080e7          	jalr	-1012(ra) # 80001ca4 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800060a0:	00d5151b          	slliw	a0,a0,0xd
    800060a4:	0c2017b7          	lui	a5,0xc201
    800060a8:	97aa                	add	a5,a5,a0
    800060aa:	c3c4                	sw	s1,4(a5)
}
    800060ac:	60e2                	ld	ra,24(sp)
    800060ae:	6442                	ld	s0,16(sp)
    800060b0:	64a2                	ld	s1,8(sp)
    800060b2:	6105                	addi	sp,sp,32
    800060b4:	8082                	ret

00000000800060b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800060b6:	1141                	addi	sp,sp,-16
    800060b8:	e406                	sd	ra,8(sp)
    800060ba:	e022                	sd	s0,0(sp)
    800060bc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800060be:	479d                	li	a5,7
    800060c0:	04a7cc63          	blt	a5,a0,80006118 <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    800060c4:	0001d797          	auipc	a5,0x1d
    800060c8:	f3c78793          	addi	a5,a5,-196 # 80023000 <disk>
    800060cc:	00a78733          	add	a4,a5,a0
    800060d0:	6789                	lui	a5,0x2
    800060d2:	97ba                	add	a5,a5,a4
    800060d4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800060d8:	eba1                	bnez	a5,80006128 <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    800060da:	00451713          	slli	a4,a0,0x4
    800060de:	0001f797          	auipc	a5,0x1f
    800060e2:	f227b783          	ld	a5,-222(a5) # 80025000 <disk+0x2000>
    800060e6:	97ba                	add	a5,a5,a4
    800060e8:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    800060ec:	0001d797          	auipc	a5,0x1d
    800060f0:	f1478793          	addi	a5,a5,-236 # 80023000 <disk>
    800060f4:	97aa                	add	a5,a5,a0
    800060f6:	6509                	lui	a0,0x2
    800060f8:	953e                	add	a0,a0,a5
    800060fa:	4785                	li	a5,1
    800060fc:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80006100:	0001f517          	auipc	a0,0x1f
    80006104:	f1850513          	addi	a0,a0,-232 # 80025018 <disk+0x2018>
    80006108:	ffffc097          	auipc	ra,0xffffc
    8000610c:	692080e7          	jalr	1682(ra) # 8000279a <wakeup>
}
    80006110:	60a2                	ld	ra,8(sp)
    80006112:	6402                	ld	s0,0(sp)
    80006114:	0141                	addi	sp,sp,16
    80006116:	8082                	ret
    panic("virtio_disk_intr 1");
    80006118:	00002517          	auipc	a0,0x2
    8000611c:	70050513          	addi	a0,a0,1792 # 80008818 <syscalls+0x330>
    80006120:	ffffa097          	auipc	ra,0xffffa
    80006124:	428080e7          	jalr	1064(ra) # 80000548 <panic>
    panic("virtio_disk_intr 2");
    80006128:	00002517          	auipc	a0,0x2
    8000612c:	70850513          	addi	a0,a0,1800 # 80008830 <syscalls+0x348>
    80006130:	ffffa097          	auipc	ra,0xffffa
    80006134:	418080e7          	jalr	1048(ra) # 80000548 <panic>

0000000080006138 <virtio_disk_init>:
{
    80006138:	1101                	addi	sp,sp,-32
    8000613a:	ec06                	sd	ra,24(sp)
    8000613c:	e822                	sd	s0,16(sp)
    8000613e:	e426                	sd	s1,8(sp)
    80006140:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006142:	00002597          	auipc	a1,0x2
    80006146:	70658593          	addi	a1,a1,1798 # 80008848 <syscalls+0x360>
    8000614a:	0001f517          	auipc	a0,0x1f
    8000614e:	f5e50513          	addi	a0,a0,-162 # 800250a8 <disk+0x20a8>
    80006152:	ffffb097          	auipc	ra,0xffffb
    80006156:	a2e080e7          	jalr	-1490(ra) # 80000b80 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000615a:	100017b7          	lui	a5,0x10001
    8000615e:	4398                	lw	a4,0(a5)
    80006160:	2701                	sext.w	a4,a4
    80006162:	747277b7          	lui	a5,0x74727
    80006166:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000616a:	0ef71163          	bne	a4,a5,8000624c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000616e:	100017b7          	lui	a5,0x10001
    80006172:	43dc                	lw	a5,4(a5)
    80006174:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006176:	4705                	li	a4,1
    80006178:	0ce79a63          	bne	a5,a4,8000624c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000617c:	100017b7          	lui	a5,0x10001
    80006180:	479c                	lw	a5,8(a5)
    80006182:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80006184:	4709                	li	a4,2
    80006186:	0ce79363          	bne	a5,a4,8000624c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000618a:	100017b7          	lui	a5,0x10001
    8000618e:	47d8                	lw	a4,12(a5)
    80006190:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006192:	554d47b7          	lui	a5,0x554d4
    80006196:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000619a:	0af71963          	bne	a4,a5,8000624c <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000619e:	100017b7          	lui	a5,0x10001
    800061a2:	4705                	li	a4,1
    800061a4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800061a6:	470d                	li	a4,3
    800061a8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800061aa:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800061ac:	c7ffe737          	lui	a4,0xc7ffe
    800061b0:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd773f>
    800061b4:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800061b6:	2701                	sext.w	a4,a4
    800061b8:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800061ba:	472d                	li	a4,11
    800061bc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800061be:	473d                	li	a4,15
    800061c0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800061c2:	6705                	lui	a4,0x1
    800061c4:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800061c6:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800061ca:	5bdc                	lw	a5,52(a5)
    800061cc:	2781                	sext.w	a5,a5
  if(max == 0)
    800061ce:	c7d9                	beqz	a5,8000625c <virtio_disk_init+0x124>
  if(max < NUM)
    800061d0:	471d                	li	a4,7
    800061d2:	08f77d63          	bgeu	a4,a5,8000626c <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800061d6:	100014b7          	lui	s1,0x10001
    800061da:	47a1                	li	a5,8
    800061dc:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800061de:	6609                	lui	a2,0x2
    800061e0:	4581                	li	a1,0
    800061e2:	0001d517          	auipc	a0,0x1d
    800061e6:	e1e50513          	addi	a0,a0,-482 # 80023000 <disk>
    800061ea:	ffffb097          	auipc	ra,0xffffb
    800061ee:	b22080e7          	jalr	-1246(ra) # 80000d0c <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800061f2:	0001d717          	auipc	a4,0x1d
    800061f6:	e0e70713          	addi	a4,a4,-498 # 80023000 <disk>
    800061fa:	00c75793          	srli	a5,a4,0xc
    800061fe:	2781                	sext.w	a5,a5
    80006200:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80006202:	0001f797          	auipc	a5,0x1f
    80006206:	dfe78793          	addi	a5,a5,-514 # 80025000 <disk+0x2000>
    8000620a:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    8000620c:	0001d717          	auipc	a4,0x1d
    80006210:	e7470713          	addi	a4,a4,-396 # 80023080 <disk+0x80>
    80006214:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80006216:	0001e717          	auipc	a4,0x1e
    8000621a:	dea70713          	addi	a4,a4,-534 # 80024000 <disk+0x1000>
    8000621e:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80006220:	4705                	li	a4,1
    80006222:	00e78c23          	sb	a4,24(a5)
    80006226:	00e78ca3          	sb	a4,25(a5)
    8000622a:	00e78d23          	sb	a4,26(a5)
    8000622e:	00e78da3          	sb	a4,27(a5)
    80006232:	00e78e23          	sb	a4,28(a5)
    80006236:	00e78ea3          	sb	a4,29(a5)
    8000623a:	00e78f23          	sb	a4,30(a5)
    8000623e:	00e78fa3          	sb	a4,31(a5)
}
    80006242:	60e2                	ld	ra,24(sp)
    80006244:	6442                	ld	s0,16(sp)
    80006246:	64a2                	ld	s1,8(sp)
    80006248:	6105                	addi	sp,sp,32
    8000624a:	8082                	ret
    panic("could not find virtio disk");
    8000624c:	00002517          	auipc	a0,0x2
    80006250:	60c50513          	addi	a0,a0,1548 # 80008858 <syscalls+0x370>
    80006254:	ffffa097          	auipc	ra,0xffffa
    80006258:	2f4080e7          	jalr	756(ra) # 80000548 <panic>
    panic("virtio disk has no queue 0");
    8000625c:	00002517          	auipc	a0,0x2
    80006260:	61c50513          	addi	a0,a0,1564 # 80008878 <syscalls+0x390>
    80006264:	ffffa097          	auipc	ra,0xffffa
    80006268:	2e4080e7          	jalr	740(ra) # 80000548 <panic>
    panic("virtio disk max queue too short");
    8000626c:	00002517          	auipc	a0,0x2
    80006270:	62c50513          	addi	a0,a0,1580 # 80008898 <syscalls+0x3b0>
    80006274:	ffffa097          	auipc	ra,0xffffa
    80006278:	2d4080e7          	jalr	724(ra) # 80000548 <panic>

000000008000627c <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000627c:	7119                	addi	sp,sp,-128
    8000627e:	fc86                	sd	ra,120(sp)
    80006280:	f8a2                	sd	s0,112(sp)
    80006282:	f4a6                	sd	s1,104(sp)
    80006284:	f0ca                	sd	s2,96(sp)
    80006286:	ecce                	sd	s3,88(sp)
    80006288:	e8d2                	sd	s4,80(sp)
    8000628a:	e4d6                	sd	s5,72(sp)
    8000628c:	e0da                	sd	s6,64(sp)
    8000628e:	fc5e                	sd	s7,56(sp)
    80006290:	f862                	sd	s8,48(sp)
    80006292:	f466                	sd	s9,40(sp)
    80006294:	f06a                	sd	s10,32(sp)
    80006296:	0100                	addi	s0,sp,128
    80006298:	892a                	mv	s2,a0
    8000629a:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000629c:	00c52c83          	lw	s9,12(a0)
    800062a0:	001c9c9b          	slliw	s9,s9,0x1
    800062a4:	1c82                	slli	s9,s9,0x20
    800062a6:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800062aa:	0001f517          	auipc	a0,0x1f
    800062ae:	dfe50513          	addi	a0,a0,-514 # 800250a8 <disk+0x20a8>
    800062b2:	ffffb097          	auipc	ra,0xffffb
    800062b6:	95e080e7          	jalr	-1698(ra) # 80000c10 <acquire>
  for(int i = 0; i < 3; i++){
    800062ba:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800062bc:	4c21                	li	s8,8
      disk.free[i] = 0;
    800062be:	0001db97          	auipc	s7,0x1d
    800062c2:	d42b8b93          	addi	s7,s7,-702 # 80023000 <disk>
    800062c6:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800062c8:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800062ca:	8a4e                	mv	s4,s3
    800062cc:	a051                	j	80006350 <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800062ce:	00fb86b3          	add	a3,s7,a5
    800062d2:	96da                	add	a3,a3,s6
    800062d4:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800062d8:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800062da:	0207c563          	bltz	a5,80006304 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800062de:	2485                	addiw	s1,s1,1
    800062e0:	0711                	addi	a4,a4,4
    800062e2:	23548d63          	beq	s1,s5,8000651c <virtio_disk_rw+0x2a0>
    idx[i] = alloc_desc();
    800062e6:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800062e8:	0001f697          	auipc	a3,0x1f
    800062ec:	d3068693          	addi	a3,a3,-720 # 80025018 <disk+0x2018>
    800062f0:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800062f2:	0006c583          	lbu	a1,0(a3)
    800062f6:	fde1                	bnez	a1,800062ce <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800062f8:	2785                	addiw	a5,a5,1
    800062fa:	0685                	addi	a3,a3,1
    800062fc:	ff879be3          	bne	a5,s8,800062f2 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80006300:	57fd                	li	a5,-1
    80006302:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80006304:	02905a63          	blez	s1,80006338 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80006308:	f9042503          	lw	a0,-112(s0)
    8000630c:	00000097          	auipc	ra,0x0
    80006310:	daa080e7          	jalr	-598(ra) # 800060b6 <free_desc>
      for(int j = 0; j < i; j++)
    80006314:	4785                	li	a5,1
    80006316:	0297d163          	bge	a5,s1,80006338 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    8000631a:	f9442503          	lw	a0,-108(s0)
    8000631e:	00000097          	auipc	ra,0x0
    80006322:	d98080e7          	jalr	-616(ra) # 800060b6 <free_desc>
      for(int j = 0; j < i; j++)
    80006326:	4789                	li	a5,2
    80006328:	0097d863          	bge	a5,s1,80006338 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    8000632c:	f9842503          	lw	a0,-104(s0)
    80006330:	00000097          	auipc	ra,0x0
    80006334:	d86080e7          	jalr	-634(ra) # 800060b6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006338:	0001f597          	auipc	a1,0x1f
    8000633c:	d7058593          	addi	a1,a1,-656 # 800250a8 <disk+0x20a8>
    80006340:	0001f517          	auipc	a0,0x1f
    80006344:	cd850513          	addi	a0,a0,-808 # 80025018 <disk+0x2018>
    80006348:	ffffc097          	auipc	ra,0xffffc
    8000634c:	2cc080e7          	jalr	716(ra) # 80002614 <sleep>
  for(int i = 0; i < 3; i++){
    80006350:	f9040713          	addi	a4,s0,-112
    80006354:	84ce                	mv	s1,s3
    80006356:	bf41                	j	800062e6 <virtio_disk_rw+0x6a>
    uint32 reserved;
    uint64 sector;
  } buf0;

  if(write)
    buf0.type = VIRTIO_BLK_T_OUT; // write the disk
    80006358:	4785                	li	a5,1
    8000635a:	f8f42023          	sw	a5,-128(s0)
  else
    buf0.type = VIRTIO_BLK_T_IN; // read the disk
  buf0.reserved = 0;
    8000635e:	f8042223          	sw	zero,-124(s0)
  buf0.sector = sector;
    80006362:	f9943423          	sd	s9,-120(s0)

  // buf0 is on a kernel stack, which is not direct mapped,
  // thus the call to kvmpa().
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    80006366:	f9042983          	lw	s3,-112(s0)
    8000636a:	00499493          	slli	s1,s3,0x4
    8000636e:	0001fa17          	auipc	s4,0x1f
    80006372:	c92a0a13          	addi	s4,s4,-878 # 80025000 <disk+0x2000>
    80006376:	000a3a83          	ld	s5,0(s4)
    8000637a:	9aa6                	add	s5,s5,s1
    8000637c:	f8040513          	addi	a0,s0,-128
    80006380:	ffffb097          	auipc	ra,0xffffb
    80006384:	e1a080e7          	jalr	-486(ra) # 8000119a <kvmpa>
    80006388:	00aab023          	sd	a0,0(s5)
  disk.desc[idx[0]].len = sizeof(buf0);
    8000638c:	000a3783          	ld	a5,0(s4)
    80006390:	97a6                	add	a5,a5,s1
    80006392:	4741                	li	a4,16
    80006394:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006396:	000a3783          	ld	a5,0(s4)
    8000639a:	97a6                	add	a5,a5,s1
    8000639c:	4705                	li	a4,1
    8000639e:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    800063a2:	f9442703          	lw	a4,-108(s0)
    800063a6:	000a3783          	ld	a5,0(s4)
    800063aa:	97a6                	add	a5,a5,s1
    800063ac:	00e79723          	sh	a4,14(a5)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800063b0:	0712                	slli	a4,a4,0x4
    800063b2:	000a3783          	ld	a5,0(s4)
    800063b6:	97ba                	add	a5,a5,a4
    800063b8:	05890693          	addi	a3,s2,88
    800063bc:	e394                	sd	a3,0(a5)
  disk.desc[idx[1]].len = BSIZE;
    800063be:	000a3783          	ld	a5,0(s4)
    800063c2:	97ba                	add	a5,a5,a4
    800063c4:	40000693          	li	a3,1024
    800063c8:	c794                	sw	a3,8(a5)
  if(write)
    800063ca:	100d0a63          	beqz	s10,800064de <virtio_disk_rw+0x262>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800063ce:	0001f797          	auipc	a5,0x1f
    800063d2:	c327b783          	ld	a5,-974(a5) # 80025000 <disk+0x2000>
    800063d6:	97ba                	add	a5,a5,a4
    800063d8:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800063dc:	0001d517          	auipc	a0,0x1d
    800063e0:	c2450513          	addi	a0,a0,-988 # 80023000 <disk>
    800063e4:	0001f797          	auipc	a5,0x1f
    800063e8:	c1c78793          	addi	a5,a5,-996 # 80025000 <disk+0x2000>
    800063ec:	6394                	ld	a3,0(a5)
    800063ee:	96ba                	add	a3,a3,a4
    800063f0:	00c6d603          	lhu	a2,12(a3)
    800063f4:	00166613          	ori	a2,a2,1
    800063f8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800063fc:	f9842683          	lw	a3,-104(s0)
    80006400:	6390                	ld	a2,0(a5)
    80006402:	9732                	add	a4,a4,a2
    80006404:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0;
    80006408:	20098613          	addi	a2,s3,512
    8000640c:	0612                	slli	a2,a2,0x4
    8000640e:	962a                	add	a2,a2,a0
    80006410:	02060823          	sb	zero,48(a2) # 2030 <_entry-0x7fffdfd0>
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006414:	00469713          	slli	a4,a3,0x4
    80006418:	6394                	ld	a3,0(a5)
    8000641a:	96ba                	add	a3,a3,a4
    8000641c:	6589                	lui	a1,0x2
    8000641e:	03058593          	addi	a1,a1,48 # 2030 <_entry-0x7fffdfd0>
    80006422:	94ae                	add	s1,s1,a1
    80006424:	94aa                	add	s1,s1,a0
    80006426:	e284                	sd	s1,0(a3)
  disk.desc[idx[2]].len = 1;
    80006428:	6394                	ld	a3,0(a5)
    8000642a:	96ba                	add	a3,a3,a4
    8000642c:	4585                	li	a1,1
    8000642e:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006430:	6394                	ld	a3,0(a5)
    80006432:	96ba                	add	a3,a3,a4
    80006434:	4509                	li	a0,2
    80006436:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    8000643a:	6394                	ld	a3,0(a5)
    8000643c:	9736                	add	a4,a4,a3
    8000643e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006442:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80006446:	03263423          	sd	s2,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    8000644a:	6794                	ld	a3,8(a5)
    8000644c:	0026d703          	lhu	a4,2(a3)
    80006450:	8b1d                	andi	a4,a4,7
    80006452:	2709                	addiw	a4,a4,2
    80006454:	0706                	slli	a4,a4,0x1
    80006456:	9736                	add	a4,a4,a3
    80006458:	01371023          	sh	s3,0(a4)
  __sync_synchronize();
    8000645c:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    80006460:	6798                	ld	a4,8(a5)
    80006462:	00275783          	lhu	a5,2(a4)
    80006466:	2785                	addiw	a5,a5,1
    80006468:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000646c:	100017b7          	lui	a5,0x10001
    80006470:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006474:	00492703          	lw	a4,4(s2)
    80006478:	4785                	li	a5,1
    8000647a:	02f71163          	bne	a4,a5,8000649c <virtio_disk_rw+0x220>
    sleep(b, &disk.vdisk_lock);
    8000647e:	0001f997          	auipc	s3,0x1f
    80006482:	c2a98993          	addi	s3,s3,-982 # 800250a8 <disk+0x20a8>
  while(b->disk == 1) {
    80006486:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006488:	85ce                	mv	a1,s3
    8000648a:	854a                	mv	a0,s2
    8000648c:	ffffc097          	auipc	ra,0xffffc
    80006490:	188080e7          	jalr	392(ra) # 80002614 <sleep>
  while(b->disk == 1) {
    80006494:	00492783          	lw	a5,4(s2)
    80006498:	fe9788e3          	beq	a5,s1,80006488 <virtio_disk_rw+0x20c>
  }

  disk.info[idx[0]].b = 0;
    8000649c:	f9042483          	lw	s1,-112(s0)
    800064a0:	20048793          	addi	a5,s1,512 # 10001200 <_entry-0x6fffee00>
    800064a4:	00479713          	slli	a4,a5,0x4
    800064a8:	0001d797          	auipc	a5,0x1d
    800064ac:	b5878793          	addi	a5,a5,-1192 # 80023000 <disk>
    800064b0:	97ba                	add	a5,a5,a4
    800064b2:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800064b6:	0001f917          	auipc	s2,0x1f
    800064ba:	b4a90913          	addi	s2,s2,-1206 # 80025000 <disk+0x2000>
    free_desc(i);
    800064be:	8526                	mv	a0,s1
    800064c0:	00000097          	auipc	ra,0x0
    800064c4:	bf6080e7          	jalr	-1034(ra) # 800060b6 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800064c8:	0492                	slli	s1,s1,0x4
    800064ca:	00093783          	ld	a5,0(s2)
    800064ce:	94be                	add	s1,s1,a5
    800064d0:	00c4d783          	lhu	a5,12(s1)
    800064d4:	8b85                	andi	a5,a5,1
    800064d6:	cf89                	beqz	a5,800064f0 <virtio_disk_rw+0x274>
      i = disk.desc[i].next;
    800064d8:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    800064dc:	b7cd                	j	800064be <virtio_disk_rw+0x242>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800064de:	0001f797          	auipc	a5,0x1f
    800064e2:	b227b783          	ld	a5,-1246(a5) # 80025000 <disk+0x2000>
    800064e6:	97ba                	add	a5,a5,a4
    800064e8:	4689                	li	a3,2
    800064ea:	00d79623          	sh	a3,12(a5)
    800064ee:	b5fd                	j	800063dc <virtio_disk_rw+0x160>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800064f0:	0001f517          	auipc	a0,0x1f
    800064f4:	bb850513          	addi	a0,a0,-1096 # 800250a8 <disk+0x20a8>
    800064f8:	ffffa097          	auipc	ra,0xffffa
    800064fc:	7cc080e7          	jalr	1996(ra) # 80000cc4 <release>
}
    80006500:	70e6                	ld	ra,120(sp)
    80006502:	7446                	ld	s0,112(sp)
    80006504:	74a6                	ld	s1,104(sp)
    80006506:	7906                	ld	s2,96(sp)
    80006508:	69e6                	ld	s3,88(sp)
    8000650a:	6a46                	ld	s4,80(sp)
    8000650c:	6aa6                	ld	s5,72(sp)
    8000650e:	6b06                	ld	s6,64(sp)
    80006510:	7be2                	ld	s7,56(sp)
    80006512:	7c42                	ld	s8,48(sp)
    80006514:	7ca2                	ld	s9,40(sp)
    80006516:	7d02                	ld	s10,32(sp)
    80006518:	6109                	addi	sp,sp,128
    8000651a:	8082                	ret
  if(write)
    8000651c:	e20d1ee3          	bnez	s10,80006358 <virtio_disk_rw+0xdc>
    buf0.type = VIRTIO_BLK_T_IN; // read the disk
    80006520:	f8042023          	sw	zero,-128(s0)
    80006524:	bd2d                	j	8000635e <virtio_disk_rw+0xe2>

0000000080006526 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006526:	1101                	addi	sp,sp,-32
    80006528:	ec06                	sd	ra,24(sp)
    8000652a:	e822                	sd	s0,16(sp)
    8000652c:	e426                	sd	s1,8(sp)
    8000652e:	e04a                	sd	s2,0(sp)
    80006530:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006532:	0001f517          	auipc	a0,0x1f
    80006536:	b7650513          	addi	a0,a0,-1162 # 800250a8 <disk+0x20a8>
    8000653a:	ffffa097          	auipc	ra,0xffffa
    8000653e:	6d6080e7          	jalr	1750(ra) # 80000c10 <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80006542:	0001f717          	auipc	a4,0x1f
    80006546:	abe70713          	addi	a4,a4,-1346 # 80025000 <disk+0x2000>
    8000654a:	02075783          	lhu	a5,32(a4)
    8000654e:	6b18                	ld	a4,16(a4)
    80006550:	00275683          	lhu	a3,2(a4)
    80006554:	8ebd                	xor	a3,a3,a5
    80006556:	8a9d                	andi	a3,a3,7
    80006558:	cab9                	beqz	a3,800065ae <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    8000655a:	0001d917          	auipc	s2,0x1d
    8000655e:	aa690913          	addi	s2,s2,-1370 # 80023000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    80006562:	0001f497          	auipc	s1,0x1f
    80006566:	a9e48493          	addi	s1,s1,-1378 # 80025000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    8000656a:	078e                	slli	a5,a5,0x3
    8000656c:	97ba                	add	a5,a5,a4
    8000656e:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    80006570:	20078713          	addi	a4,a5,512
    80006574:	0712                	slli	a4,a4,0x4
    80006576:	974a                	add	a4,a4,s2
    80006578:	03074703          	lbu	a4,48(a4)
    8000657c:	ef21                	bnez	a4,800065d4 <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    8000657e:	20078793          	addi	a5,a5,512
    80006582:	0792                	slli	a5,a5,0x4
    80006584:	97ca                	add	a5,a5,s2
    80006586:	7798                	ld	a4,40(a5)
    80006588:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    8000658c:	7788                	ld	a0,40(a5)
    8000658e:	ffffc097          	auipc	ra,0xffffc
    80006592:	20c080e7          	jalr	524(ra) # 8000279a <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    80006596:	0204d783          	lhu	a5,32(s1)
    8000659a:	2785                	addiw	a5,a5,1
    8000659c:	8b9d                	andi	a5,a5,7
    8000659e:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800065a2:	6898                	ld	a4,16(s1)
    800065a4:	00275683          	lhu	a3,2(a4)
    800065a8:	8a9d                	andi	a3,a3,7
    800065aa:	fcf690e3          	bne	a3,a5,8000656a <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800065ae:	10001737          	lui	a4,0x10001
    800065b2:	533c                	lw	a5,96(a4)
    800065b4:	8b8d                	andi	a5,a5,3
    800065b6:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    800065b8:	0001f517          	auipc	a0,0x1f
    800065bc:	af050513          	addi	a0,a0,-1296 # 800250a8 <disk+0x20a8>
    800065c0:	ffffa097          	auipc	ra,0xffffa
    800065c4:	704080e7          	jalr	1796(ra) # 80000cc4 <release>
}
    800065c8:	60e2                	ld	ra,24(sp)
    800065ca:	6442                	ld	s0,16(sp)
    800065cc:	64a2                	ld	s1,8(sp)
    800065ce:	6902                	ld	s2,0(sp)
    800065d0:	6105                	addi	sp,sp,32
    800065d2:	8082                	ret
      panic("virtio_disk_intr status");
    800065d4:	00002517          	auipc	a0,0x2
    800065d8:	2e450513          	addi	a0,a0,740 # 800088b8 <syscalls+0x3d0>
    800065dc:	ffffa097          	auipc	ra,0xffffa
    800065e0:	f6c080e7          	jalr	-148(ra) # 80000548 <panic>

00000000800065e4 <statscopyin>:
  int ncopyin;
  int ncopyinstr;
} stats;

int
statscopyin(char *buf, int sz) {
    800065e4:	7179                	addi	sp,sp,-48
    800065e6:	f406                	sd	ra,40(sp)
    800065e8:	f022                	sd	s0,32(sp)
    800065ea:	ec26                	sd	s1,24(sp)
    800065ec:	e84a                	sd	s2,16(sp)
    800065ee:	e44e                	sd	s3,8(sp)
    800065f0:	e052                	sd	s4,0(sp)
    800065f2:	1800                	addi	s0,sp,48
    800065f4:	892a                	mv	s2,a0
    800065f6:	89ae                	mv	s3,a1
  int n;
  n = snprintf(buf, sz, "copyin: %d\n", stats.ncopyin);
    800065f8:	00003a17          	auipc	s4,0x3
    800065fc:	a30a0a13          	addi	s4,s4,-1488 # 80009028 <stats>
    80006600:	000a2683          	lw	a3,0(s4)
    80006604:	00002617          	auipc	a2,0x2
    80006608:	2cc60613          	addi	a2,a2,716 # 800088d0 <syscalls+0x3e8>
    8000660c:	00000097          	auipc	ra,0x0
    80006610:	2c2080e7          	jalr	706(ra) # 800068ce <snprintf>
    80006614:	84aa                	mv	s1,a0
  n += snprintf(buf+n, sz, "copyinstr: %d\n", stats.ncopyinstr);
    80006616:	004a2683          	lw	a3,4(s4)
    8000661a:	00002617          	auipc	a2,0x2
    8000661e:	2c660613          	addi	a2,a2,710 # 800088e0 <syscalls+0x3f8>
    80006622:	85ce                	mv	a1,s3
    80006624:	954a                	add	a0,a0,s2
    80006626:	00000097          	auipc	ra,0x0
    8000662a:	2a8080e7          	jalr	680(ra) # 800068ce <snprintf>
  return n;
}
    8000662e:	9d25                	addw	a0,a0,s1
    80006630:	70a2                	ld	ra,40(sp)
    80006632:	7402                	ld	s0,32(sp)
    80006634:	64e2                	ld	s1,24(sp)
    80006636:	6942                	ld	s2,16(sp)
    80006638:	69a2                	ld	s3,8(sp)
    8000663a:	6a02                	ld	s4,0(sp)
    8000663c:	6145                	addi	sp,sp,48
    8000663e:	8082                	ret

0000000080006640 <copyin_new>:
// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int
copyin_new(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    80006640:	7179                	addi	sp,sp,-48
    80006642:	f406                	sd	ra,40(sp)
    80006644:	f022                	sd	s0,32(sp)
    80006646:	ec26                	sd	s1,24(sp)
    80006648:	e84a                	sd	s2,16(sp)
    8000664a:	e44e                	sd	s3,8(sp)
    8000664c:	1800                	addi	s0,sp,48
    8000664e:	89ae                	mv	s3,a1
    80006650:	84b2                	mv	s1,a2
    80006652:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80006654:	ffffb097          	auipc	ra,0xffffb
    80006658:	67c080e7          	jalr	1660(ra) # 80001cd0 <myproc>

  if (srcva >= p->sz || srcva+len >= p->sz || srcva+len < srcva)
    8000665c:	653c                	ld	a5,72(a0)
    8000665e:	02f4ff63          	bgeu	s1,a5,8000669c <copyin_new+0x5c>
    80006662:	01248733          	add	a4,s1,s2
    80006666:	02f77d63          	bgeu	a4,a5,800066a0 <copyin_new+0x60>
    8000666a:	02976d63          	bltu	a4,s1,800066a4 <copyin_new+0x64>
    return -1;
  memmove((void *) dst, (void *)srcva, len);
    8000666e:	0009061b          	sext.w	a2,s2
    80006672:	85a6                	mv	a1,s1
    80006674:	854e                	mv	a0,s3
    80006676:	ffffa097          	auipc	ra,0xffffa
    8000667a:	6f6080e7          	jalr	1782(ra) # 80000d6c <memmove>
  stats.ncopyin++;   // XXX lock
    8000667e:	00003717          	auipc	a4,0x3
    80006682:	9aa70713          	addi	a4,a4,-1622 # 80009028 <stats>
    80006686:	431c                	lw	a5,0(a4)
    80006688:	2785                	addiw	a5,a5,1
    8000668a:	c31c                	sw	a5,0(a4)
  return 0;
    8000668c:	4501                	li	a0,0
}
    8000668e:	70a2                	ld	ra,40(sp)
    80006690:	7402                	ld	s0,32(sp)
    80006692:	64e2                	ld	s1,24(sp)
    80006694:	6942                	ld	s2,16(sp)
    80006696:	69a2                	ld	s3,8(sp)
    80006698:	6145                	addi	sp,sp,48
    8000669a:	8082                	ret
    return -1;
    8000669c:	557d                	li	a0,-1
    8000669e:	bfc5                	j	8000668e <copyin_new+0x4e>
    800066a0:	557d                	li	a0,-1
    800066a2:	b7f5                	j	8000668e <copyin_new+0x4e>
    800066a4:	557d                	li	a0,-1
    800066a6:	b7e5                	j	8000668e <copyin_new+0x4e>

00000000800066a8 <copyinstr_new>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr_new(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    800066a8:	7179                	addi	sp,sp,-48
    800066aa:	f406                	sd	ra,40(sp)
    800066ac:	f022                	sd	s0,32(sp)
    800066ae:	ec26                	sd	s1,24(sp)
    800066b0:	e84a                	sd	s2,16(sp)
    800066b2:	e44e                	sd	s3,8(sp)
    800066b4:	1800                	addi	s0,sp,48
    800066b6:	89ae                	mv	s3,a1
    800066b8:	8932                	mv	s2,a2
    800066ba:	84b6                	mv	s1,a3
  struct proc *p = myproc();
    800066bc:	ffffb097          	auipc	ra,0xffffb
    800066c0:	614080e7          	jalr	1556(ra) # 80001cd0 <myproc>
  char *s = (char *) srcva;
  
  stats.ncopyinstr++;   // XXX lock
    800066c4:	00003717          	auipc	a4,0x3
    800066c8:	96470713          	addi	a4,a4,-1692 # 80009028 <stats>
    800066cc:	435c                	lw	a5,4(a4)
    800066ce:	2785                	addiw	a5,a5,1
    800066d0:	c35c                	sw	a5,4(a4)
  for(int i = 0; i < max && srcva + i < p->sz; i++){
    800066d2:	cc85                	beqz	s1,8000670a <copyinstr_new+0x62>
    800066d4:	00990833          	add	a6,s2,s1
    800066d8:	87ca                	mv	a5,s2
    800066da:	6538                	ld	a4,72(a0)
    800066dc:	00e7ff63          	bgeu	a5,a4,800066fa <copyinstr_new+0x52>
    dst[i] = s[i];
    800066e0:	0007c683          	lbu	a3,0(a5)
    800066e4:	41278733          	sub	a4,a5,s2
    800066e8:	974e                	add	a4,a4,s3
    800066ea:	00d70023          	sb	a3,0(a4)
    if(s[i] == '\0')
    800066ee:	c285                	beqz	a3,8000670e <copyinstr_new+0x66>
  for(int i = 0; i < max && srcva + i < p->sz; i++){
    800066f0:	0785                	addi	a5,a5,1
    800066f2:	ff0794e3          	bne	a5,a6,800066da <copyinstr_new+0x32>
      return 0;
  }
  return -1;
    800066f6:	557d                	li	a0,-1
    800066f8:	a011                	j	800066fc <copyinstr_new+0x54>
    800066fa:	557d                	li	a0,-1
}
    800066fc:	70a2                	ld	ra,40(sp)
    800066fe:	7402                	ld	s0,32(sp)
    80006700:	64e2                	ld	s1,24(sp)
    80006702:	6942                	ld	s2,16(sp)
    80006704:	69a2                	ld	s3,8(sp)
    80006706:	6145                	addi	sp,sp,48
    80006708:	8082                	ret
  return -1;
    8000670a:	557d                	li	a0,-1
    8000670c:	bfc5                	j	800066fc <copyinstr_new+0x54>
      return 0;
    8000670e:	4501                	li	a0,0
    80006710:	b7f5                	j	800066fc <copyinstr_new+0x54>

0000000080006712 <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    80006712:	1141                	addi	sp,sp,-16
    80006714:	e422                	sd	s0,8(sp)
    80006716:	0800                	addi	s0,sp,16
  return -1;
}
    80006718:	557d                	li	a0,-1
    8000671a:	6422                	ld	s0,8(sp)
    8000671c:	0141                	addi	sp,sp,16
    8000671e:	8082                	ret

0000000080006720 <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    80006720:	7179                	addi	sp,sp,-48
    80006722:	f406                	sd	ra,40(sp)
    80006724:	f022                	sd	s0,32(sp)
    80006726:	ec26                	sd	s1,24(sp)
    80006728:	e84a                	sd	s2,16(sp)
    8000672a:	e44e                	sd	s3,8(sp)
    8000672c:	e052                	sd	s4,0(sp)
    8000672e:	1800                	addi	s0,sp,48
    80006730:	892a                	mv	s2,a0
    80006732:	89ae                	mv	s3,a1
    80006734:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    80006736:	00020517          	auipc	a0,0x20
    8000673a:	8ca50513          	addi	a0,a0,-1846 # 80026000 <stats>
    8000673e:	ffffa097          	auipc	ra,0xffffa
    80006742:	4d2080e7          	jalr	1234(ra) # 80000c10 <acquire>

  if(stats.sz == 0) {
    80006746:	00021797          	auipc	a5,0x21
    8000674a:	8d27a783          	lw	a5,-1838(a5) # 80027018 <stats+0x1018>
    8000674e:	cbb5                	beqz	a5,800067c2 <statsread+0xa2>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    80006750:	00021797          	auipc	a5,0x21
    80006754:	8b078793          	addi	a5,a5,-1872 # 80027000 <stats+0x1000>
    80006758:	4fd8                	lw	a4,28(a5)
    8000675a:	4f9c                	lw	a5,24(a5)
    8000675c:	9f99                	subw	a5,a5,a4
    8000675e:	0007869b          	sext.w	a3,a5

  if (m > 0) {
    80006762:	06d05e63          	blez	a3,800067de <statsread+0xbe>
    if(m > n)
    80006766:	8a3e                	mv	s4,a5
    80006768:	00d4d363          	bge	s1,a3,8000676e <statsread+0x4e>
    8000676c:	8a26                	mv	s4,s1
    8000676e:	000a049b          	sext.w	s1,s4
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    80006772:	86a6                	mv	a3,s1
    80006774:	00020617          	auipc	a2,0x20
    80006778:	8a460613          	addi	a2,a2,-1884 # 80026018 <stats+0x18>
    8000677c:	963a                	add	a2,a2,a4
    8000677e:	85ce                	mv	a1,s3
    80006780:	854a                	mv	a0,s2
    80006782:	ffffc097          	auipc	ra,0xffffc
    80006786:	0f4080e7          	jalr	244(ra) # 80002876 <either_copyout>
    8000678a:	57fd                	li	a5,-1
    8000678c:	00f50a63          	beq	a0,a5,800067a0 <statsread+0x80>
      stats.off += m;
    80006790:	00021717          	auipc	a4,0x21
    80006794:	87070713          	addi	a4,a4,-1936 # 80027000 <stats+0x1000>
    80006798:	4f5c                	lw	a5,28(a4)
    8000679a:	014787bb          	addw	a5,a5,s4
    8000679e:	cf5c                	sw	a5,28(a4)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    800067a0:	00020517          	auipc	a0,0x20
    800067a4:	86050513          	addi	a0,a0,-1952 # 80026000 <stats>
    800067a8:	ffffa097          	auipc	ra,0xffffa
    800067ac:	51c080e7          	jalr	1308(ra) # 80000cc4 <release>
  return m;
}
    800067b0:	8526                	mv	a0,s1
    800067b2:	70a2                	ld	ra,40(sp)
    800067b4:	7402                	ld	s0,32(sp)
    800067b6:	64e2                	ld	s1,24(sp)
    800067b8:	6942                	ld	s2,16(sp)
    800067ba:	69a2                	ld	s3,8(sp)
    800067bc:	6a02                	ld	s4,0(sp)
    800067be:	6145                	addi	sp,sp,48
    800067c0:	8082                	ret
    stats.sz = statscopyin(stats.buf, BUFSZ);
    800067c2:	6585                	lui	a1,0x1
    800067c4:	00020517          	auipc	a0,0x20
    800067c8:	85450513          	addi	a0,a0,-1964 # 80026018 <stats+0x18>
    800067cc:	00000097          	auipc	ra,0x0
    800067d0:	e18080e7          	jalr	-488(ra) # 800065e4 <statscopyin>
    800067d4:	00021797          	auipc	a5,0x21
    800067d8:	84a7a223          	sw	a0,-1980(a5) # 80027018 <stats+0x1018>
    800067dc:	bf95                	j	80006750 <statsread+0x30>
    stats.sz = 0;
    800067de:	00021797          	auipc	a5,0x21
    800067e2:	82278793          	addi	a5,a5,-2014 # 80027000 <stats+0x1000>
    800067e6:	0007ac23          	sw	zero,24(a5)
    stats.off = 0;
    800067ea:	0007ae23          	sw	zero,28(a5)
    m = -1;
    800067ee:	54fd                	li	s1,-1
    800067f0:	bf45                	j	800067a0 <statsread+0x80>

00000000800067f2 <statsinit>:

void
statsinit(void)
{
    800067f2:	1141                	addi	sp,sp,-16
    800067f4:	e406                	sd	ra,8(sp)
    800067f6:	e022                	sd	s0,0(sp)
    800067f8:	0800                	addi	s0,sp,16
  initlock(&stats.lock, "stats");
    800067fa:	00002597          	auipc	a1,0x2
    800067fe:	0f658593          	addi	a1,a1,246 # 800088f0 <syscalls+0x408>
    80006802:	0001f517          	auipc	a0,0x1f
    80006806:	7fe50513          	addi	a0,a0,2046 # 80026000 <stats>
    8000680a:	ffffa097          	auipc	ra,0xffffa
    8000680e:	376080e7          	jalr	886(ra) # 80000b80 <initlock>

  devsw[STATS].read = statsread;
    80006812:	0001b797          	auipc	a5,0x1b
    80006816:	39e78793          	addi	a5,a5,926 # 80021bb0 <devsw>
    8000681a:	00000717          	auipc	a4,0x0
    8000681e:	f0670713          	addi	a4,a4,-250 # 80006720 <statsread>
    80006822:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    80006824:	00000717          	auipc	a4,0x0
    80006828:	eee70713          	addi	a4,a4,-274 # 80006712 <statswrite>
    8000682c:	f798                	sd	a4,40(a5)
}
    8000682e:	60a2                	ld	ra,8(sp)
    80006830:	6402                	ld	s0,0(sp)
    80006832:	0141                	addi	sp,sp,16
    80006834:	8082                	ret

0000000080006836 <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    80006836:	1101                	addi	sp,sp,-32
    80006838:	ec22                	sd	s0,24(sp)
    8000683a:	1000                	addi	s0,sp,32
    8000683c:	882a                	mv	a6,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    8000683e:	c299                	beqz	a3,80006844 <sprintint+0xe>
    80006840:	0805c163          	bltz	a1,800068c2 <sprintint+0x8c>
    x = -xx;
  else
    x = xx;
    80006844:	2581                	sext.w	a1,a1
    80006846:	4301                	li	t1,0

  i = 0;
    80006848:	fe040713          	addi	a4,s0,-32
    8000684c:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    8000684e:	2601                	sext.w	a2,a2
    80006850:	00002697          	auipc	a3,0x2
    80006854:	0a868693          	addi	a3,a3,168 # 800088f8 <digits>
    80006858:	88aa                	mv	a7,a0
    8000685a:	2505                	addiw	a0,a0,1
    8000685c:	02c5f7bb          	remuw	a5,a1,a2
    80006860:	1782                	slli	a5,a5,0x20
    80006862:	9381                	srli	a5,a5,0x20
    80006864:	97b6                	add	a5,a5,a3
    80006866:	0007c783          	lbu	a5,0(a5)
    8000686a:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    8000686e:	0005879b          	sext.w	a5,a1
    80006872:	02c5d5bb          	divuw	a1,a1,a2
    80006876:	0705                	addi	a4,a4,1
    80006878:	fec7f0e3          	bgeu	a5,a2,80006858 <sprintint+0x22>

  if(sign)
    8000687c:	00030b63          	beqz	t1,80006892 <sprintint+0x5c>
    buf[i++] = '-';
    80006880:	ff040793          	addi	a5,s0,-16
    80006884:	97aa                	add	a5,a5,a0
    80006886:	02d00713          	li	a4,45
    8000688a:	fee78823          	sb	a4,-16(a5)
    8000688e:	0028851b          	addiw	a0,a7,2

  n = 0;
  while(--i >= 0)
    80006892:	02a05c63          	blez	a0,800068ca <sprintint+0x94>
    80006896:	fe040793          	addi	a5,s0,-32
    8000689a:	00a78733          	add	a4,a5,a0
    8000689e:	87c2                	mv	a5,a6
    800068a0:	0805                	addi	a6,a6,1
    800068a2:	fff5061b          	addiw	a2,a0,-1
    800068a6:	1602                	slli	a2,a2,0x20
    800068a8:	9201                	srli	a2,a2,0x20
    800068aa:	9642                	add	a2,a2,a6
  *s = c;
    800068ac:	fff74683          	lbu	a3,-1(a4)
    800068b0:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    800068b4:	177d                	addi	a4,a4,-1
    800068b6:	0785                	addi	a5,a5,1
    800068b8:	fec79ae3          	bne	a5,a2,800068ac <sprintint+0x76>
    n += sputc(s+n, buf[i]);
  return n;
}
    800068bc:	6462                	ld	s0,24(sp)
    800068be:	6105                	addi	sp,sp,32
    800068c0:	8082                	ret
    x = -xx;
    800068c2:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    800068c6:	4305                	li	t1,1
    x = -xx;
    800068c8:	b741                	j	80006848 <sprintint+0x12>
  while(--i >= 0)
    800068ca:	4501                	li	a0,0
    800068cc:	bfc5                	j	800068bc <sprintint+0x86>

00000000800068ce <snprintf>:

int
snprintf(char *buf, int sz, char *fmt, ...)
{
    800068ce:	7171                	addi	sp,sp,-176
    800068d0:	fc86                	sd	ra,120(sp)
    800068d2:	f8a2                	sd	s0,112(sp)
    800068d4:	f4a6                	sd	s1,104(sp)
    800068d6:	f0ca                	sd	s2,96(sp)
    800068d8:	ecce                	sd	s3,88(sp)
    800068da:	e8d2                	sd	s4,80(sp)
    800068dc:	e4d6                	sd	s5,72(sp)
    800068de:	e0da                	sd	s6,64(sp)
    800068e0:	fc5e                	sd	s7,56(sp)
    800068e2:	f862                	sd	s8,48(sp)
    800068e4:	f466                	sd	s9,40(sp)
    800068e6:	f06a                	sd	s10,32(sp)
    800068e8:	ec6e                	sd	s11,24(sp)
    800068ea:	0100                	addi	s0,sp,128
    800068ec:	e414                	sd	a3,8(s0)
    800068ee:	e818                	sd	a4,16(s0)
    800068f0:	ec1c                	sd	a5,24(s0)
    800068f2:	03043023          	sd	a6,32(s0)
    800068f6:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  if (fmt == 0)
    800068fa:	ca0d                	beqz	a2,8000692c <snprintf+0x5e>
    800068fc:	8baa                	mv	s7,a0
    800068fe:	89ae                	mv	s3,a1
    80006900:	8a32                	mv	s4,a2
    panic("null fmt");

  va_start(ap, fmt);
    80006902:	00840793          	addi	a5,s0,8
    80006906:	f8f43423          	sd	a5,-120(s0)
  int off = 0;
    8000690a:	4481                	li	s1,0
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    8000690c:	4901                	li	s2,0
    8000690e:	02b05763          	blez	a1,8000693c <snprintf+0x6e>
    if(c != '%'){
    80006912:	02500a93          	li	s5,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    80006916:	07300b13          	li	s6,115
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
      break;
    case 's':
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s && off < sz; s++)
    8000691a:	02800d93          	li	s11,40
  *s = c;
    8000691e:	02500d13          	li	s10,37
    switch(c){
    80006922:	07800c93          	li	s9,120
    80006926:	06400c13          	li	s8,100
    8000692a:	a01d                	j	80006950 <snprintf+0x82>
    panic("null fmt");
    8000692c:	00001517          	auipc	a0,0x1
    80006930:	6ec50513          	addi	a0,a0,1772 # 80008018 <etext+0x18>
    80006934:	ffffa097          	auipc	ra,0xffffa
    80006938:	c14080e7          	jalr	-1004(ra) # 80000548 <panic>
  int off = 0;
    8000693c:	4481                	li	s1,0
    8000693e:	a86d                	j	800069f8 <snprintf+0x12a>
  *s = c;
    80006940:	009b8733          	add	a4,s7,s1
    80006944:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80006948:	2485                	addiw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    8000694a:	2905                	addiw	s2,s2,1
    8000694c:	0b34d663          	bge	s1,s3,800069f8 <snprintf+0x12a>
    80006950:	012a07b3          	add	a5,s4,s2
    80006954:	0007c783          	lbu	a5,0(a5)
    80006958:	0007871b          	sext.w	a4,a5
    8000695c:	cfd1                	beqz	a5,800069f8 <snprintf+0x12a>
    if(c != '%'){
    8000695e:	ff5711e3          	bne	a4,s5,80006940 <snprintf+0x72>
    c = fmt[++i] & 0xff;
    80006962:	2905                	addiw	s2,s2,1
    80006964:	012a07b3          	add	a5,s4,s2
    80006968:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    8000696c:	c7d1                	beqz	a5,800069f8 <snprintf+0x12a>
    switch(c){
    8000696e:	05678c63          	beq	a5,s6,800069c6 <snprintf+0xf8>
    80006972:	02fb6763          	bltu	s6,a5,800069a0 <snprintf+0xd2>
    80006976:	0b578763          	beq	a5,s5,80006a24 <snprintf+0x156>
    8000697a:	0b879b63          	bne	a5,s8,80006a30 <snprintf+0x162>
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    8000697e:	f8843783          	ld	a5,-120(s0)
    80006982:	00878713          	addi	a4,a5,8
    80006986:	f8e43423          	sd	a4,-120(s0)
    8000698a:	4685                	li	a3,1
    8000698c:	4629                	li	a2,10
    8000698e:	438c                	lw	a1,0(a5)
    80006990:	009b8533          	add	a0,s7,s1
    80006994:	00000097          	auipc	ra,0x0
    80006998:	ea2080e7          	jalr	-350(ra) # 80006836 <sprintint>
    8000699c:	9ca9                	addw	s1,s1,a0
      break;
    8000699e:	b775                	j	8000694a <snprintf+0x7c>
    switch(c){
    800069a0:	09979863          	bne	a5,s9,80006a30 <snprintf+0x162>
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    800069a4:	f8843783          	ld	a5,-120(s0)
    800069a8:	00878713          	addi	a4,a5,8
    800069ac:	f8e43423          	sd	a4,-120(s0)
    800069b0:	4685                	li	a3,1
    800069b2:	4641                	li	a2,16
    800069b4:	438c                	lw	a1,0(a5)
    800069b6:	009b8533          	add	a0,s7,s1
    800069ba:	00000097          	auipc	ra,0x0
    800069be:	e7c080e7          	jalr	-388(ra) # 80006836 <sprintint>
    800069c2:	9ca9                	addw	s1,s1,a0
      break;
    800069c4:	b759                	j	8000694a <snprintf+0x7c>
      if((s = va_arg(ap, char*)) == 0)
    800069c6:	f8843783          	ld	a5,-120(s0)
    800069ca:	00878713          	addi	a4,a5,8
    800069ce:	f8e43423          	sd	a4,-120(s0)
    800069d2:	639c                	ld	a5,0(a5)
    800069d4:	c3b1                	beqz	a5,80006a18 <snprintf+0x14a>
      for(; *s && off < sz; s++)
    800069d6:	0007c703          	lbu	a4,0(a5)
    800069da:	db25                	beqz	a4,8000694a <snprintf+0x7c>
    800069dc:	0134de63          	bge	s1,s3,800069f8 <snprintf+0x12a>
    800069e0:	009b86b3          	add	a3,s7,s1
  *s = c;
    800069e4:	00e68023          	sb	a4,0(a3)
        off += sputc(buf+off, *s);
    800069e8:	2485                	addiw	s1,s1,1
      for(; *s && off < sz; s++)
    800069ea:	0785                	addi	a5,a5,1
    800069ec:	0007c703          	lbu	a4,0(a5)
    800069f0:	df29                	beqz	a4,8000694a <snprintf+0x7c>
    800069f2:	0685                	addi	a3,a3,1
    800069f4:	fe9998e3          	bne	s3,s1,800069e4 <snprintf+0x116>
      off += sputc(buf+off, c);
      break;
    }
  }
  return off;
}
    800069f8:	8526                	mv	a0,s1
    800069fa:	70e6                	ld	ra,120(sp)
    800069fc:	7446                	ld	s0,112(sp)
    800069fe:	74a6                	ld	s1,104(sp)
    80006a00:	7906                	ld	s2,96(sp)
    80006a02:	69e6                	ld	s3,88(sp)
    80006a04:	6a46                	ld	s4,80(sp)
    80006a06:	6aa6                	ld	s5,72(sp)
    80006a08:	6b06                	ld	s6,64(sp)
    80006a0a:	7be2                	ld	s7,56(sp)
    80006a0c:	7c42                	ld	s8,48(sp)
    80006a0e:	7ca2                	ld	s9,40(sp)
    80006a10:	7d02                	ld	s10,32(sp)
    80006a12:	6de2                	ld	s11,24(sp)
    80006a14:	614d                	addi	sp,sp,176
    80006a16:	8082                	ret
        s = "(null)";
    80006a18:	00001797          	auipc	a5,0x1
    80006a1c:	5f878793          	addi	a5,a5,1528 # 80008010 <etext+0x10>
      for(; *s && off < sz; s++)
    80006a20:	876e                	mv	a4,s11
    80006a22:	bf6d                	j	800069dc <snprintf+0x10e>
  *s = c;
    80006a24:	009b87b3          	add	a5,s7,s1
    80006a28:	01a78023          	sb	s10,0(a5)
      off += sputc(buf+off, '%');
    80006a2c:	2485                	addiw	s1,s1,1
      break;
    80006a2e:	bf31                	j	8000694a <snprintf+0x7c>
  *s = c;
    80006a30:	009b8733          	add	a4,s7,s1
    80006a34:	01a70023          	sb	s10,0(a4)
      off += sputc(buf+off, c);
    80006a38:	0014871b          	addiw	a4,s1,1
  *s = c;
    80006a3c:	975e                	add	a4,a4,s7
    80006a3e:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80006a42:	2489                	addiw	s1,s1,2
      break;
    80006a44:	b719                	j	8000694a <snprintf+0x7c>
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
