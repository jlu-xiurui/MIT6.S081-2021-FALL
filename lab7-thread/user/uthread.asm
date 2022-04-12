
user/_uthread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:
struct thread *current_thread;
extern void thread_switch(uint64, uint64);

void 
thread_init(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
   6:	00001797          	auipc	a5,0x1
   a:	d4278793          	addi	a5,a5,-702 # d48 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	d2f73523          	sd	a5,-726(a4) # d38 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	d2f72823          	sw	a5,-720(a4) # 2d48 <__global_pointer$+0x182f>
}
  20:	6422                	ld	s0,8(sp)
  22:	0141                	addi	sp,sp,16
  24:	8082                	ret

0000000000000026 <thread_schedule>:

void 
thread_schedule(void)
{
  26:	1141                	addi	sp,sp,-16
  28:	e406                	sd	ra,8(sp)
  2a:	e022                	sd	s0,0(sp)
  2c:	0800                	addi	s0,sp,16
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  2e:	00001317          	auipc	t1,0x1
  32:	d0a33303          	ld	t1,-758(t1) # d38 <current_thread>
  36:	6589                	lui	a1,0x2
  38:	07858593          	addi	a1,a1,120 # 2078 <__global_pointer$+0xb5f>
  3c:	959a                	add	a1,a1,t1
  3e:	4791                	li	a5,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  40:	00009817          	auipc	a6,0x9
  44:	ee880813          	addi	a6,a6,-280 # 8f28 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  48:	6689                	lui	a3,0x2
  4a:	4609                	li	a2,2
      next_thread = t;
      break;
    }
    t = t + 1;
  4c:	07868893          	addi	a7,a3,120 # 2078 <__global_pointer$+0xb5f>
  50:	a809                	j	62 <thread_schedule+0x3c>
    if(t->state == RUNNABLE) {
  52:	00d58733          	add	a4,a1,a3
  56:	4318                	lw	a4,0(a4)
  58:	02c70963          	beq	a4,a2,8a <thread_schedule+0x64>
    t = t + 1;
  5c:	95c6                	add	a1,a1,a7
  for(int i = 0; i < MAX_THREAD; i++){
  5e:	37fd                	addiw	a5,a5,-1
  60:	cb81                	beqz	a5,70 <thread_schedule+0x4a>
    if(t >= all_thread + MAX_THREAD)
  62:	ff05e8e3          	bltu	a1,a6,52 <thread_schedule+0x2c>
      t = all_thread;
  66:	00001597          	auipc	a1,0x1
  6a:	ce258593          	addi	a1,a1,-798 # d48 <all_thread>
  6e:	b7d5                	j	52 <thread_schedule+0x2c>
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  70:	00001517          	auipc	a0,0x1
  74:	b9050513          	addi	a0,a0,-1136 # c00 <malloc+0xea>
  78:	00001097          	auipc	ra,0x1
  7c:	9e0080e7          	jalr	-1568(ra) # a58 <printf>
    exit(-1);
  80:	557d                	li	a0,-1
  82:	00000097          	auipc	ra,0x0
  86:	65e080e7          	jalr	1630(ra) # 6e0 <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  8a:	02b30263          	beq	t1,a1,ae <thread_schedule+0x88>
    next_thread->state = RUNNING;
  8e:	6509                	lui	a0,0x2
  90:	00a587b3          	add	a5,a1,a0
  94:	4705                	li	a4,1
  96:	c398                	sw	a4,0(a5)
    t = current_thread;
    current_thread = next_thread;
  98:	00001797          	auipc	a5,0x1
  9c:	cab7b023          	sd	a1,-864(a5) # d38 <current_thread>
    /* YOUR CODE HERE
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
    uint64 curr_ctx = (uint64)(&t->context);
    uint64 next_ctx = (uint64)(&current_thread->context);
  a0:	0521                	addi	a0,a0,8
    thread_switch(curr_ctx,next_ctx);
  a2:	95aa                	add	a1,a1,a0
  a4:	951a                	add	a0,a0,t1
  a6:	00000097          	auipc	ra,0x0
  aa:	35a080e7          	jalr	858(ra) # 400 <thread_switch>
  } else
    next_thread = 0;
}
  ae:	60a2                	ld	ra,8(sp)
  b0:	6402                	ld	s0,0(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <thread_create>:

void 
thread_create(void (*func)())
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  bc:	00001797          	auipc	a5,0x1
  c0:	c8c78793          	addi	a5,a5,-884 # d48 <all_thread>
    if (t->state == FREE) break;
  c4:	6689                	lui	a3,0x2
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c6:	07868593          	addi	a1,a3,120 # 2078 <__global_pointer$+0xb5f>
  ca:	00009617          	auipc	a2,0x9
  ce:	e5e60613          	addi	a2,a2,-418 # 8f28 <base>
    if (t->state == FREE) break;
  d2:	00d78733          	add	a4,a5,a3
  d6:	4318                	lw	a4,0(a4)
  d8:	c701                	beqz	a4,e0 <thread_create+0x2a>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  da:	97ae                	add	a5,a5,a1
  dc:	fec79be3          	bne	a5,a2,d2 <thread_create+0x1c>
  }
  t->state = RUNNABLE;
  e0:	6709                	lui	a4,0x2
  e2:	97ba                	add	a5,a5,a4
  e4:	4709                	li	a4,2
  e6:	c398                	sw	a4,0(a5)
  // YOUR CODE HERE
  t->context.ra = (uint64)func;
  e8:	e788                	sd	a0,8(a5)
  t->context.sp = (uint64)t->stack + STACK_SIZE;
  ea:	eb9c                	sd	a5,16(a5)
}
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <thread_yield>:

void 
thread_yield(void)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e406                	sd	ra,8(sp)
  f6:	e022                	sd	s0,0(sp)
  f8:	0800                	addi	s0,sp,16
  current_thread->state = RUNNABLE;
  fa:	00001797          	auipc	a5,0x1
  fe:	c3e7b783          	ld	a5,-962(a5) # d38 <current_thread>
 102:	6709                	lui	a4,0x2
 104:	97ba                	add	a5,a5,a4
 106:	4709                	li	a4,2
 108:	c398                	sw	a4,0(a5)
  thread_schedule();
 10a:	00000097          	auipc	ra,0x0
 10e:	f1c080e7          	jalr	-228(ra) # 26 <thread_schedule>
}
 112:	60a2                	ld	ra,8(sp)
 114:	6402                	ld	s0,0(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret

000000000000011a <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 11a:	7179                	addi	sp,sp,-48
 11c:	f406                	sd	ra,40(sp)
 11e:	f022                	sd	s0,32(sp)
 120:	ec26                	sd	s1,24(sp)
 122:	e84a                	sd	s2,16(sp)
 124:	e44e                	sd	s3,8(sp)
 126:	e052                	sd	s4,0(sp)
 128:	1800                	addi	s0,sp,48
  int i;
  printf("thread_a started\n");
 12a:	00001517          	auipc	a0,0x1
 12e:	afe50513          	addi	a0,a0,-1282 # c28 <malloc+0x112>
 132:	00001097          	auipc	ra,0x1
 136:	926080e7          	jalr	-1754(ra) # a58 <printf>
  a_started = 1;
 13a:	4785                	li	a5,1
 13c:	00001717          	auipc	a4,0x1
 140:	bef72c23          	sw	a5,-1032(a4) # d34 <a_started>
  while(b_started == 0 || c_started == 0)
 144:	00001497          	auipc	s1,0x1
 148:	bec48493          	addi	s1,s1,-1044 # d30 <b_started>
 14c:	00001917          	auipc	s2,0x1
 150:	be090913          	addi	s2,s2,-1056 # d2c <c_started>
 154:	a029                	j	15e <thread_a+0x44>
    thread_yield();
 156:	00000097          	auipc	ra,0x0
 15a:	f9c080e7          	jalr	-100(ra) # f2 <thread_yield>
  while(b_started == 0 || c_started == 0)
 15e:	409c                	lw	a5,0(s1)
 160:	2781                	sext.w	a5,a5
 162:	dbf5                	beqz	a5,156 <thread_a+0x3c>
 164:	00092783          	lw	a5,0(s2)
 168:	2781                	sext.w	a5,a5
 16a:	d7f5                	beqz	a5,156 <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 16c:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 16e:	00001a17          	auipc	s4,0x1
 172:	ad2a0a13          	addi	s4,s4,-1326 # c40 <malloc+0x12a>
    a_n += 1;
 176:	00001917          	auipc	s2,0x1
 17a:	bb290913          	addi	s2,s2,-1102 # d28 <a_n>
  for (i = 0; i < 100; i++) {
 17e:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 182:	85a6                	mv	a1,s1
 184:	8552                	mv	a0,s4
 186:	00001097          	auipc	ra,0x1
 18a:	8d2080e7          	jalr	-1838(ra) # a58 <printf>
    a_n += 1;
 18e:	00092783          	lw	a5,0(s2)
 192:	2785                	addiw	a5,a5,1
 194:	00f92023          	sw	a5,0(s2)
    thread_yield();
 198:	00000097          	auipc	ra,0x0
 19c:	f5a080e7          	jalr	-166(ra) # f2 <thread_yield>
  for (i = 0; i < 100; i++) {
 1a0:	2485                	addiw	s1,s1,1
 1a2:	ff3490e3          	bne	s1,s3,182 <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 1a6:	00001597          	auipc	a1,0x1
 1aa:	b825a583          	lw	a1,-1150(a1) # d28 <a_n>
 1ae:	00001517          	auipc	a0,0x1
 1b2:	aa250513          	addi	a0,a0,-1374 # c50 <malloc+0x13a>
 1b6:	00001097          	auipc	ra,0x1
 1ba:	8a2080e7          	jalr	-1886(ra) # a58 <printf>

  current_thread->state = FREE;
 1be:	00001797          	auipc	a5,0x1
 1c2:	b7a7b783          	ld	a5,-1158(a5) # d38 <current_thread>
 1c6:	6709                	lui	a4,0x2
 1c8:	97ba                	add	a5,a5,a4
 1ca:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 1ce:	00000097          	auipc	ra,0x0
 1d2:	e58080e7          	jalr	-424(ra) # 26 <thread_schedule>
}
 1d6:	70a2                	ld	ra,40(sp)
 1d8:	7402                	ld	s0,32(sp)
 1da:	64e2                	ld	s1,24(sp)
 1dc:	6942                	ld	s2,16(sp)
 1de:	69a2                	ld	s3,8(sp)
 1e0:	6a02                	ld	s4,0(sp)
 1e2:	6145                	addi	sp,sp,48
 1e4:	8082                	ret

00000000000001e6 <thread_b>:

void 
thread_b(void)
{
 1e6:	7179                	addi	sp,sp,-48
 1e8:	f406                	sd	ra,40(sp)
 1ea:	f022                	sd	s0,32(sp)
 1ec:	ec26                	sd	s1,24(sp)
 1ee:	e84a                	sd	s2,16(sp)
 1f0:	e44e                	sd	s3,8(sp)
 1f2:	e052                	sd	s4,0(sp)
 1f4:	1800                	addi	s0,sp,48
  int i;
  printf("thread_b started\n");
 1f6:	00001517          	auipc	a0,0x1
 1fa:	a7a50513          	addi	a0,a0,-1414 # c70 <malloc+0x15a>
 1fe:	00001097          	auipc	ra,0x1
 202:	85a080e7          	jalr	-1958(ra) # a58 <printf>
  b_started = 1;
 206:	4785                	li	a5,1
 208:	00001717          	auipc	a4,0x1
 20c:	b2f72423          	sw	a5,-1240(a4) # d30 <b_started>
  while(a_started == 0 || c_started == 0)
 210:	00001497          	auipc	s1,0x1
 214:	b2448493          	addi	s1,s1,-1244 # d34 <a_started>
 218:	00001917          	auipc	s2,0x1
 21c:	b1490913          	addi	s2,s2,-1260 # d2c <c_started>
 220:	a029                	j	22a <thread_b+0x44>
    thread_yield();
 222:	00000097          	auipc	ra,0x0
 226:	ed0080e7          	jalr	-304(ra) # f2 <thread_yield>
  while(a_started == 0 || c_started == 0)
 22a:	409c                	lw	a5,0(s1)
 22c:	2781                	sext.w	a5,a5
 22e:	dbf5                	beqz	a5,222 <thread_b+0x3c>
 230:	00092783          	lw	a5,0(s2)
 234:	2781                	sext.w	a5,a5
 236:	d7f5                	beqz	a5,222 <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 238:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 23a:	00001a17          	auipc	s4,0x1
 23e:	a4ea0a13          	addi	s4,s4,-1458 # c88 <malloc+0x172>
    b_n += 1;
 242:	00001917          	auipc	s2,0x1
 246:	ae290913          	addi	s2,s2,-1310 # d24 <b_n>
  for (i = 0; i < 100; i++) {
 24a:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 24e:	85a6                	mv	a1,s1
 250:	8552                	mv	a0,s4
 252:	00001097          	auipc	ra,0x1
 256:	806080e7          	jalr	-2042(ra) # a58 <printf>
    b_n += 1;
 25a:	00092783          	lw	a5,0(s2)
 25e:	2785                	addiw	a5,a5,1
 260:	00f92023          	sw	a5,0(s2)
    thread_yield();
 264:	00000097          	auipc	ra,0x0
 268:	e8e080e7          	jalr	-370(ra) # f2 <thread_yield>
  for (i = 0; i < 100; i++) {
 26c:	2485                	addiw	s1,s1,1
 26e:	ff3490e3          	bne	s1,s3,24e <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 272:	00001597          	auipc	a1,0x1
 276:	ab25a583          	lw	a1,-1358(a1) # d24 <b_n>
 27a:	00001517          	auipc	a0,0x1
 27e:	a1e50513          	addi	a0,a0,-1506 # c98 <malloc+0x182>
 282:	00000097          	auipc	ra,0x0
 286:	7d6080e7          	jalr	2006(ra) # a58 <printf>

  current_thread->state = FREE;
 28a:	00001797          	auipc	a5,0x1
 28e:	aae7b783          	ld	a5,-1362(a5) # d38 <current_thread>
 292:	6709                	lui	a4,0x2
 294:	97ba                	add	a5,a5,a4
 296:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 29a:	00000097          	auipc	ra,0x0
 29e:	d8c080e7          	jalr	-628(ra) # 26 <thread_schedule>
}
 2a2:	70a2                	ld	ra,40(sp)
 2a4:	7402                	ld	s0,32(sp)
 2a6:	64e2                	ld	s1,24(sp)
 2a8:	6942                	ld	s2,16(sp)
 2aa:	69a2                	ld	s3,8(sp)
 2ac:	6a02                	ld	s4,0(sp)
 2ae:	6145                	addi	sp,sp,48
 2b0:	8082                	ret

00000000000002b2 <thread_c>:

void 
thread_c(void)
{
 2b2:	7179                	addi	sp,sp,-48
 2b4:	f406                	sd	ra,40(sp)
 2b6:	f022                	sd	s0,32(sp)
 2b8:	ec26                	sd	s1,24(sp)
 2ba:	e84a                	sd	s2,16(sp)
 2bc:	e44e                	sd	s3,8(sp)
 2be:	e052                	sd	s4,0(sp)
 2c0:	1800                	addi	s0,sp,48
  int i;
  printf("thread_c started\n");
 2c2:	00001517          	auipc	a0,0x1
 2c6:	9f650513          	addi	a0,a0,-1546 # cb8 <malloc+0x1a2>
 2ca:	00000097          	auipc	ra,0x0
 2ce:	78e080e7          	jalr	1934(ra) # a58 <printf>
  c_started = 1;
 2d2:	4785                	li	a5,1
 2d4:	00001717          	auipc	a4,0x1
 2d8:	a4f72c23          	sw	a5,-1448(a4) # d2c <c_started>
  while(a_started == 0 || b_started == 0)
 2dc:	00001497          	auipc	s1,0x1
 2e0:	a5848493          	addi	s1,s1,-1448 # d34 <a_started>
 2e4:	00001917          	auipc	s2,0x1
 2e8:	a4c90913          	addi	s2,s2,-1460 # d30 <b_started>
 2ec:	a029                	j	2f6 <thread_c+0x44>
    thread_yield();
 2ee:	00000097          	auipc	ra,0x0
 2f2:	e04080e7          	jalr	-508(ra) # f2 <thread_yield>
  while(a_started == 0 || b_started == 0)
 2f6:	409c                	lw	a5,0(s1)
 2f8:	2781                	sext.w	a5,a5
 2fa:	dbf5                	beqz	a5,2ee <thread_c+0x3c>
 2fc:	00092783          	lw	a5,0(s2)
 300:	2781                	sext.w	a5,a5
 302:	d7f5                	beqz	a5,2ee <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 304:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 306:	00001a17          	auipc	s4,0x1
 30a:	9caa0a13          	addi	s4,s4,-1590 # cd0 <malloc+0x1ba>
    c_n += 1;
 30e:	00001917          	auipc	s2,0x1
 312:	a1290913          	addi	s2,s2,-1518 # d20 <c_n>
  for (i = 0; i < 100; i++) {
 316:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 31a:	85a6                	mv	a1,s1
 31c:	8552                	mv	a0,s4
 31e:	00000097          	auipc	ra,0x0
 322:	73a080e7          	jalr	1850(ra) # a58 <printf>
    c_n += 1;
 326:	00092783          	lw	a5,0(s2)
 32a:	2785                	addiw	a5,a5,1
 32c:	00f92023          	sw	a5,0(s2)
    thread_yield();
 330:	00000097          	auipc	ra,0x0
 334:	dc2080e7          	jalr	-574(ra) # f2 <thread_yield>
  for (i = 0; i < 100; i++) {
 338:	2485                	addiw	s1,s1,1
 33a:	ff3490e3          	bne	s1,s3,31a <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 33e:	00001597          	auipc	a1,0x1
 342:	9e25a583          	lw	a1,-1566(a1) # d20 <c_n>
 346:	00001517          	auipc	a0,0x1
 34a:	99a50513          	addi	a0,a0,-1638 # ce0 <malloc+0x1ca>
 34e:	00000097          	auipc	ra,0x0
 352:	70a080e7          	jalr	1802(ra) # a58 <printf>

  current_thread->state = FREE;
 356:	00001797          	auipc	a5,0x1
 35a:	9e27b783          	ld	a5,-1566(a5) # d38 <current_thread>
 35e:	6709                	lui	a4,0x2
 360:	97ba                	add	a5,a5,a4
 362:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 366:	00000097          	auipc	ra,0x0
 36a:	cc0080e7          	jalr	-832(ra) # 26 <thread_schedule>
}
 36e:	70a2                	ld	ra,40(sp)
 370:	7402                	ld	s0,32(sp)
 372:	64e2                	ld	s1,24(sp)
 374:	6942                	ld	s2,16(sp)
 376:	69a2                	ld	s3,8(sp)
 378:	6a02                	ld	s4,0(sp)
 37a:	6145                	addi	sp,sp,48
 37c:	8082                	ret

000000000000037e <main>:

int 
main(int argc, char *argv[]) 
{
 37e:	1141                	addi	sp,sp,-16
 380:	e406                	sd	ra,8(sp)
 382:	e022                	sd	s0,0(sp)
 384:	0800                	addi	s0,sp,16
  a_started = b_started = c_started = 0;
 386:	00001797          	auipc	a5,0x1
 38a:	9a07a323          	sw	zero,-1626(a5) # d2c <c_started>
 38e:	00001797          	auipc	a5,0x1
 392:	9a07a123          	sw	zero,-1630(a5) # d30 <b_started>
 396:	00001797          	auipc	a5,0x1
 39a:	9807af23          	sw	zero,-1634(a5) # d34 <a_started>
  a_n = b_n = c_n = 0;
 39e:	00001797          	auipc	a5,0x1
 3a2:	9807a123          	sw	zero,-1662(a5) # d20 <c_n>
 3a6:	00001797          	auipc	a5,0x1
 3aa:	9607af23          	sw	zero,-1666(a5) # d24 <b_n>
 3ae:	00001797          	auipc	a5,0x1
 3b2:	9607ad23          	sw	zero,-1670(a5) # d28 <a_n>
  thread_init();
 3b6:	00000097          	auipc	ra,0x0
 3ba:	c4a080e7          	jalr	-950(ra) # 0 <thread_init>
  thread_create(thread_a);
 3be:	00000517          	auipc	a0,0x0
 3c2:	d5c50513          	addi	a0,a0,-676 # 11a <thread_a>
 3c6:	00000097          	auipc	ra,0x0
 3ca:	cf0080e7          	jalr	-784(ra) # b6 <thread_create>
  thread_create(thread_b);
 3ce:	00000517          	auipc	a0,0x0
 3d2:	e1850513          	addi	a0,a0,-488 # 1e6 <thread_b>
 3d6:	00000097          	auipc	ra,0x0
 3da:	ce0080e7          	jalr	-800(ra) # b6 <thread_create>
  thread_create(thread_c);
 3de:	00000517          	auipc	a0,0x0
 3e2:	ed450513          	addi	a0,a0,-300 # 2b2 <thread_c>
 3e6:	00000097          	auipc	ra,0x0
 3ea:	cd0080e7          	jalr	-816(ra) # b6 <thread_create>
  thread_schedule();
 3ee:	00000097          	auipc	ra,0x0
 3f2:	c38080e7          	jalr	-968(ra) # 26 <thread_schedule>
  exit(0);
 3f6:	4501                	li	a0,0
 3f8:	00000097          	auipc	ra,0x0
 3fc:	2e8080e7          	jalr	744(ra) # 6e0 <exit>

0000000000000400 <thread_switch>:
         */

	.globl thread_switch
thread_switch:
/* YOUR CODE HERE */
    sd ra, 0(a0)
 400:	00153023          	sd	ra,0(a0)
    sd sp, 8(a0)
 404:	00253423          	sd	sp,8(a0)
    sd s0, 16(a0)
 408:	e900                	sd	s0,16(a0)
    sd s1, 24(a0)
 40a:	ed04                	sd	s1,24(a0)
    sd s2, 32(a0)
 40c:	03253023          	sd	s2,32(a0)
    sd s3, 40(a0)
 410:	03353423          	sd	s3,40(a0)
    sd s4, 48(a0)
 414:	03453823          	sd	s4,48(a0)
    sd s5, 56(a0)
 418:	03553c23          	sd	s5,56(a0)
    sd s6, 64(a0)
 41c:	05653023          	sd	s6,64(a0)
    sd s7, 72(a0)
 420:	05753423          	sd	s7,72(a0)
    sd s8, 80(a0)
 424:	05853823          	sd	s8,80(a0)
    sd s9, 88(a0)
 428:	05953c23          	sd	s9,88(a0)
    sd s10, 96(a0)
 42c:	07a53023          	sd	s10,96(a0)
    sd s11, 104(a0)
 430:	07b53423          	sd	s11,104(a0)

    ld ra, 0(a1)
 434:	0005b083          	ld	ra,0(a1)
    ld sp, 8(a1)
 438:	0085b103          	ld	sp,8(a1)
    ld s0, 16(a1)
 43c:	6980                	ld	s0,16(a1)
    ld s1, 24(a1)
 43e:	6d84                	ld	s1,24(a1)
    ld s2, 32(a1)
 440:	0205b903          	ld	s2,32(a1)
    ld s3, 40(a1)
 444:	0285b983          	ld	s3,40(a1)
    ld s4, 48(a1)
 448:	0305ba03          	ld	s4,48(a1)
    ld s5, 56(a1)
 44c:	0385ba83          	ld	s5,56(a1)
    ld s6, 64(a1)
 450:	0405bb03          	ld	s6,64(a1)
    ld s7, 72(a1)
 454:	0485bb83          	ld	s7,72(a1)
    ld s8, 80(a1)
 458:	0505bc03          	ld	s8,80(a1)
    ld s9, 88(a1)
 45c:	0585bc83          	ld	s9,88(a1)
    ld s10, 96(a1)
 460:	0605bd03          	ld	s10,96(a1)
    ld s11, 104(a1)
 464:	0685bd83          	ld	s11,104(a1)

	ret    /* return to ra */
 468:	8082                	ret

000000000000046a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 46a:	1141                	addi	sp,sp,-16
 46c:	e422                	sd	s0,8(sp)
 46e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 470:	87aa                	mv	a5,a0
 472:	0585                	addi	a1,a1,1
 474:	0785                	addi	a5,a5,1
 476:	fff5c703          	lbu	a4,-1(a1)
 47a:	fee78fa3          	sb	a4,-1(a5)
 47e:	fb75                	bnez	a4,472 <strcpy+0x8>
    ;
  return os;
}
 480:	6422                	ld	s0,8(sp)
 482:	0141                	addi	sp,sp,16
 484:	8082                	ret

0000000000000486 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 486:	1141                	addi	sp,sp,-16
 488:	e422                	sd	s0,8(sp)
 48a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 48c:	00054783          	lbu	a5,0(a0)
 490:	cb91                	beqz	a5,4a4 <strcmp+0x1e>
 492:	0005c703          	lbu	a4,0(a1)
 496:	00f71763          	bne	a4,a5,4a4 <strcmp+0x1e>
    p++, q++;
 49a:	0505                	addi	a0,a0,1
 49c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 49e:	00054783          	lbu	a5,0(a0)
 4a2:	fbe5                	bnez	a5,492 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4a4:	0005c503          	lbu	a0,0(a1)
}
 4a8:	40a7853b          	subw	a0,a5,a0
 4ac:	6422                	ld	s0,8(sp)
 4ae:	0141                	addi	sp,sp,16
 4b0:	8082                	ret

00000000000004b2 <strlen>:

uint
strlen(const char *s)
{
 4b2:	1141                	addi	sp,sp,-16
 4b4:	e422                	sd	s0,8(sp)
 4b6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4b8:	00054783          	lbu	a5,0(a0)
 4bc:	cf91                	beqz	a5,4d8 <strlen+0x26>
 4be:	0505                	addi	a0,a0,1
 4c0:	87aa                	mv	a5,a0
 4c2:	4685                	li	a3,1
 4c4:	9e89                	subw	a3,a3,a0
 4c6:	00f6853b          	addw	a0,a3,a5
 4ca:	0785                	addi	a5,a5,1
 4cc:	fff7c703          	lbu	a4,-1(a5)
 4d0:	fb7d                	bnez	a4,4c6 <strlen+0x14>
    ;
  return n;
}
 4d2:	6422                	ld	s0,8(sp)
 4d4:	0141                	addi	sp,sp,16
 4d6:	8082                	ret
  for(n = 0; s[n]; n++)
 4d8:	4501                	li	a0,0
 4da:	bfe5                	j	4d2 <strlen+0x20>

00000000000004dc <memset>:

void*
memset(void *dst, int c, uint n)
{
 4dc:	1141                	addi	sp,sp,-16
 4de:	e422                	sd	s0,8(sp)
 4e0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4e2:	ce09                	beqz	a2,4fc <memset+0x20>
 4e4:	87aa                	mv	a5,a0
 4e6:	fff6071b          	addiw	a4,a2,-1
 4ea:	1702                	slli	a4,a4,0x20
 4ec:	9301                	srli	a4,a4,0x20
 4ee:	0705                	addi	a4,a4,1
 4f0:	972a                	add	a4,a4,a0
    cdst[i] = c;
 4f2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4f6:	0785                	addi	a5,a5,1
 4f8:	fee79de3          	bne	a5,a4,4f2 <memset+0x16>
  }
  return dst;
}
 4fc:	6422                	ld	s0,8(sp)
 4fe:	0141                	addi	sp,sp,16
 500:	8082                	ret

0000000000000502 <strchr>:

char*
strchr(const char *s, char c)
{
 502:	1141                	addi	sp,sp,-16
 504:	e422                	sd	s0,8(sp)
 506:	0800                	addi	s0,sp,16
  for(; *s; s++)
 508:	00054783          	lbu	a5,0(a0)
 50c:	cb99                	beqz	a5,522 <strchr+0x20>
    if(*s == c)
 50e:	00f58763          	beq	a1,a5,51c <strchr+0x1a>
  for(; *s; s++)
 512:	0505                	addi	a0,a0,1
 514:	00054783          	lbu	a5,0(a0)
 518:	fbfd                	bnez	a5,50e <strchr+0xc>
      return (char*)s;
  return 0;
 51a:	4501                	li	a0,0
}
 51c:	6422                	ld	s0,8(sp)
 51e:	0141                	addi	sp,sp,16
 520:	8082                	ret
  return 0;
 522:	4501                	li	a0,0
 524:	bfe5                	j	51c <strchr+0x1a>

0000000000000526 <gets>:

char*
gets(char *buf, int max)
{
 526:	711d                	addi	sp,sp,-96
 528:	ec86                	sd	ra,88(sp)
 52a:	e8a2                	sd	s0,80(sp)
 52c:	e4a6                	sd	s1,72(sp)
 52e:	e0ca                	sd	s2,64(sp)
 530:	fc4e                	sd	s3,56(sp)
 532:	f852                	sd	s4,48(sp)
 534:	f456                	sd	s5,40(sp)
 536:	f05a                	sd	s6,32(sp)
 538:	ec5e                	sd	s7,24(sp)
 53a:	1080                	addi	s0,sp,96
 53c:	8baa                	mv	s7,a0
 53e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 540:	892a                	mv	s2,a0
 542:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 544:	4aa9                	li	s5,10
 546:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 548:	89a6                	mv	s3,s1
 54a:	2485                	addiw	s1,s1,1
 54c:	0344d863          	bge	s1,s4,57c <gets+0x56>
    cc = read(0, &c, 1);
 550:	4605                	li	a2,1
 552:	faf40593          	addi	a1,s0,-81
 556:	4501                	li	a0,0
 558:	00000097          	auipc	ra,0x0
 55c:	1a0080e7          	jalr	416(ra) # 6f8 <read>
    if(cc < 1)
 560:	00a05e63          	blez	a0,57c <gets+0x56>
    buf[i++] = c;
 564:	faf44783          	lbu	a5,-81(s0)
 568:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 56c:	01578763          	beq	a5,s5,57a <gets+0x54>
 570:	0905                	addi	s2,s2,1
 572:	fd679be3          	bne	a5,s6,548 <gets+0x22>
  for(i=0; i+1 < max; ){
 576:	89a6                	mv	s3,s1
 578:	a011                	j	57c <gets+0x56>
 57a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 57c:	99de                	add	s3,s3,s7
 57e:	00098023          	sb	zero,0(s3)
  return buf;
}
 582:	855e                	mv	a0,s7
 584:	60e6                	ld	ra,88(sp)
 586:	6446                	ld	s0,80(sp)
 588:	64a6                	ld	s1,72(sp)
 58a:	6906                	ld	s2,64(sp)
 58c:	79e2                	ld	s3,56(sp)
 58e:	7a42                	ld	s4,48(sp)
 590:	7aa2                	ld	s5,40(sp)
 592:	7b02                	ld	s6,32(sp)
 594:	6be2                	ld	s7,24(sp)
 596:	6125                	addi	sp,sp,96
 598:	8082                	ret

000000000000059a <stat>:

int
stat(const char *n, struct stat *st)
{
 59a:	1101                	addi	sp,sp,-32
 59c:	ec06                	sd	ra,24(sp)
 59e:	e822                	sd	s0,16(sp)
 5a0:	e426                	sd	s1,8(sp)
 5a2:	e04a                	sd	s2,0(sp)
 5a4:	1000                	addi	s0,sp,32
 5a6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5a8:	4581                	li	a1,0
 5aa:	00000097          	auipc	ra,0x0
 5ae:	176080e7          	jalr	374(ra) # 720 <open>
  if(fd < 0)
 5b2:	02054563          	bltz	a0,5dc <stat+0x42>
 5b6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5b8:	85ca                	mv	a1,s2
 5ba:	00000097          	auipc	ra,0x0
 5be:	17e080e7          	jalr	382(ra) # 738 <fstat>
 5c2:	892a                	mv	s2,a0
  close(fd);
 5c4:	8526                	mv	a0,s1
 5c6:	00000097          	auipc	ra,0x0
 5ca:	142080e7          	jalr	322(ra) # 708 <close>
  return r;
}
 5ce:	854a                	mv	a0,s2
 5d0:	60e2                	ld	ra,24(sp)
 5d2:	6442                	ld	s0,16(sp)
 5d4:	64a2                	ld	s1,8(sp)
 5d6:	6902                	ld	s2,0(sp)
 5d8:	6105                	addi	sp,sp,32
 5da:	8082                	ret
    return -1;
 5dc:	597d                	li	s2,-1
 5de:	bfc5                	j	5ce <stat+0x34>

00000000000005e0 <atoi>:

int
atoi(const char *s)
{
 5e0:	1141                	addi	sp,sp,-16
 5e2:	e422                	sd	s0,8(sp)
 5e4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5e6:	00054603          	lbu	a2,0(a0)
 5ea:	fd06079b          	addiw	a5,a2,-48
 5ee:	0ff7f793          	andi	a5,a5,255
 5f2:	4725                	li	a4,9
 5f4:	02f76963          	bltu	a4,a5,626 <atoi+0x46>
 5f8:	86aa                	mv	a3,a0
  n = 0;
 5fa:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 5fc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 5fe:	0685                	addi	a3,a3,1
 600:	0025179b          	slliw	a5,a0,0x2
 604:	9fa9                	addw	a5,a5,a0
 606:	0017979b          	slliw	a5,a5,0x1
 60a:	9fb1                	addw	a5,a5,a2
 60c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 610:	0006c603          	lbu	a2,0(a3)
 614:	fd06071b          	addiw	a4,a2,-48
 618:	0ff77713          	andi	a4,a4,255
 61c:	fee5f1e3          	bgeu	a1,a4,5fe <atoi+0x1e>
  return n;
}
 620:	6422                	ld	s0,8(sp)
 622:	0141                	addi	sp,sp,16
 624:	8082                	ret
  n = 0;
 626:	4501                	li	a0,0
 628:	bfe5                	j	620 <atoi+0x40>

000000000000062a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 62a:	1141                	addi	sp,sp,-16
 62c:	e422                	sd	s0,8(sp)
 62e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 630:	02b57663          	bgeu	a0,a1,65c <memmove+0x32>
    while(n-- > 0)
 634:	02c05163          	blez	a2,656 <memmove+0x2c>
 638:	fff6079b          	addiw	a5,a2,-1
 63c:	1782                	slli	a5,a5,0x20
 63e:	9381                	srli	a5,a5,0x20
 640:	0785                	addi	a5,a5,1
 642:	97aa                	add	a5,a5,a0
  dst = vdst;
 644:	872a                	mv	a4,a0
      *dst++ = *src++;
 646:	0585                	addi	a1,a1,1
 648:	0705                	addi	a4,a4,1
 64a:	fff5c683          	lbu	a3,-1(a1)
 64e:	fed70fa3          	sb	a3,-1(a4) # 1fff <__global_pointer$+0xae6>
    while(n-- > 0)
 652:	fee79ae3          	bne	a5,a4,646 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 656:	6422                	ld	s0,8(sp)
 658:	0141                	addi	sp,sp,16
 65a:	8082                	ret
    dst += n;
 65c:	00c50733          	add	a4,a0,a2
    src += n;
 660:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 662:	fec05ae3          	blez	a2,656 <memmove+0x2c>
 666:	fff6079b          	addiw	a5,a2,-1
 66a:	1782                	slli	a5,a5,0x20
 66c:	9381                	srli	a5,a5,0x20
 66e:	fff7c793          	not	a5,a5
 672:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 674:	15fd                	addi	a1,a1,-1
 676:	177d                	addi	a4,a4,-1
 678:	0005c683          	lbu	a3,0(a1)
 67c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 680:	fee79ae3          	bne	a5,a4,674 <memmove+0x4a>
 684:	bfc9                	j	656 <memmove+0x2c>

0000000000000686 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 686:	1141                	addi	sp,sp,-16
 688:	e422                	sd	s0,8(sp)
 68a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 68c:	ca05                	beqz	a2,6bc <memcmp+0x36>
 68e:	fff6069b          	addiw	a3,a2,-1
 692:	1682                	slli	a3,a3,0x20
 694:	9281                	srli	a3,a3,0x20
 696:	0685                	addi	a3,a3,1
 698:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 69a:	00054783          	lbu	a5,0(a0)
 69e:	0005c703          	lbu	a4,0(a1)
 6a2:	00e79863          	bne	a5,a4,6b2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 6a6:	0505                	addi	a0,a0,1
    p2++;
 6a8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6aa:	fed518e3          	bne	a0,a3,69a <memcmp+0x14>
  }
  return 0;
 6ae:	4501                	li	a0,0
 6b0:	a019                	j	6b6 <memcmp+0x30>
      return *p1 - *p2;
 6b2:	40e7853b          	subw	a0,a5,a4
}
 6b6:	6422                	ld	s0,8(sp)
 6b8:	0141                	addi	sp,sp,16
 6ba:	8082                	ret
  return 0;
 6bc:	4501                	li	a0,0
 6be:	bfe5                	j	6b6 <memcmp+0x30>

00000000000006c0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6c0:	1141                	addi	sp,sp,-16
 6c2:	e406                	sd	ra,8(sp)
 6c4:	e022                	sd	s0,0(sp)
 6c6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6c8:	00000097          	auipc	ra,0x0
 6cc:	f62080e7          	jalr	-158(ra) # 62a <memmove>
}
 6d0:	60a2                	ld	ra,8(sp)
 6d2:	6402                	ld	s0,0(sp)
 6d4:	0141                	addi	sp,sp,16
 6d6:	8082                	ret

00000000000006d8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6d8:	4885                	li	a7,1
 ecall
 6da:	00000073          	ecall
 ret
 6de:	8082                	ret

00000000000006e0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6e0:	4889                	li	a7,2
 ecall
 6e2:	00000073          	ecall
 ret
 6e6:	8082                	ret

00000000000006e8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 6e8:	488d                	li	a7,3
 ecall
 6ea:	00000073          	ecall
 ret
 6ee:	8082                	ret

00000000000006f0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6f0:	4891                	li	a7,4
 ecall
 6f2:	00000073          	ecall
 ret
 6f6:	8082                	ret

00000000000006f8 <read>:
.global read
read:
 li a7, SYS_read
 6f8:	4895                	li	a7,5
 ecall
 6fa:	00000073          	ecall
 ret
 6fe:	8082                	ret

0000000000000700 <write>:
.global write
write:
 li a7, SYS_write
 700:	48c1                	li	a7,16
 ecall
 702:	00000073          	ecall
 ret
 706:	8082                	ret

0000000000000708 <close>:
.global close
close:
 li a7, SYS_close
 708:	48d5                	li	a7,21
 ecall
 70a:	00000073          	ecall
 ret
 70e:	8082                	ret

0000000000000710 <kill>:
.global kill
kill:
 li a7, SYS_kill
 710:	4899                	li	a7,6
 ecall
 712:	00000073          	ecall
 ret
 716:	8082                	ret

0000000000000718 <exec>:
.global exec
exec:
 li a7, SYS_exec
 718:	489d                	li	a7,7
 ecall
 71a:	00000073          	ecall
 ret
 71e:	8082                	ret

0000000000000720 <open>:
.global open
open:
 li a7, SYS_open
 720:	48bd                	li	a7,15
 ecall
 722:	00000073          	ecall
 ret
 726:	8082                	ret

0000000000000728 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 728:	48c5                	li	a7,17
 ecall
 72a:	00000073          	ecall
 ret
 72e:	8082                	ret

0000000000000730 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 730:	48c9                	li	a7,18
 ecall
 732:	00000073          	ecall
 ret
 736:	8082                	ret

0000000000000738 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 738:	48a1                	li	a7,8
 ecall
 73a:	00000073          	ecall
 ret
 73e:	8082                	ret

0000000000000740 <link>:
.global link
link:
 li a7, SYS_link
 740:	48cd                	li	a7,19
 ecall
 742:	00000073          	ecall
 ret
 746:	8082                	ret

0000000000000748 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 748:	48d1                	li	a7,20
 ecall
 74a:	00000073          	ecall
 ret
 74e:	8082                	ret

0000000000000750 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 750:	48a5                	li	a7,9
 ecall
 752:	00000073          	ecall
 ret
 756:	8082                	ret

0000000000000758 <dup>:
.global dup
dup:
 li a7, SYS_dup
 758:	48a9                	li	a7,10
 ecall
 75a:	00000073          	ecall
 ret
 75e:	8082                	ret

0000000000000760 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 760:	48ad                	li	a7,11
 ecall
 762:	00000073          	ecall
 ret
 766:	8082                	ret

0000000000000768 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 768:	48b1                	li	a7,12
 ecall
 76a:	00000073          	ecall
 ret
 76e:	8082                	ret

0000000000000770 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 770:	48b5                	li	a7,13
 ecall
 772:	00000073          	ecall
 ret
 776:	8082                	ret

0000000000000778 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 778:	48b9                	li	a7,14
 ecall
 77a:	00000073          	ecall
 ret
 77e:	8082                	ret

0000000000000780 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 780:	1101                	addi	sp,sp,-32
 782:	ec06                	sd	ra,24(sp)
 784:	e822                	sd	s0,16(sp)
 786:	1000                	addi	s0,sp,32
 788:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 78c:	4605                	li	a2,1
 78e:	fef40593          	addi	a1,s0,-17
 792:	00000097          	auipc	ra,0x0
 796:	f6e080e7          	jalr	-146(ra) # 700 <write>
}
 79a:	60e2                	ld	ra,24(sp)
 79c:	6442                	ld	s0,16(sp)
 79e:	6105                	addi	sp,sp,32
 7a0:	8082                	ret

00000000000007a2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7a2:	7139                	addi	sp,sp,-64
 7a4:	fc06                	sd	ra,56(sp)
 7a6:	f822                	sd	s0,48(sp)
 7a8:	f426                	sd	s1,40(sp)
 7aa:	f04a                	sd	s2,32(sp)
 7ac:	ec4e                	sd	s3,24(sp)
 7ae:	0080                	addi	s0,sp,64
 7b0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7b2:	c299                	beqz	a3,7b8 <printint+0x16>
 7b4:	0805c863          	bltz	a1,844 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7b8:	2581                	sext.w	a1,a1
  neg = 0;
 7ba:	4881                	li	a7,0
 7bc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7c0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7c2:	2601                	sext.w	a2,a2
 7c4:	00000517          	auipc	a0,0x0
 7c8:	54450513          	addi	a0,a0,1348 # d08 <digits>
 7cc:	883a                	mv	a6,a4
 7ce:	2705                	addiw	a4,a4,1
 7d0:	02c5f7bb          	remuw	a5,a1,a2
 7d4:	1782                	slli	a5,a5,0x20
 7d6:	9381                	srli	a5,a5,0x20
 7d8:	97aa                	add	a5,a5,a0
 7da:	0007c783          	lbu	a5,0(a5)
 7de:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7e2:	0005879b          	sext.w	a5,a1
 7e6:	02c5d5bb          	divuw	a1,a1,a2
 7ea:	0685                	addi	a3,a3,1
 7ec:	fec7f0e3          	bgeu	a5,a2,7cc <printint+0x2a>
  if(neg)
 7f0:	00088b63          	beqz	a7,806 <printint+0x64>
    buf[i++] = '-';
 7f4:	fd040793          	addi	a5,s0,-48
 7f8:	973e                	add	a4,a4,a5
 7fa:	02d00793          	li	a5,45
 7fe:	fef70823          	sb	a5,-16(a4)
 802:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 806:	02e05863          	blez	a4,836 <printint+0x94>
 80a:	fc040793          	addi	a5,s0,-64
 80e:	00e78933          	add	s2,a5,a4
 812:	fff78993          	addi	s3,a5,-1
 816:	99ba                	add	s3,s3,a4
 818:	377d                	addiw	a4,a4,-1
 81a:	1702                	slli	a4,a4,0x20
 81c:	9301                	srli	a4,a4,0x20
 81e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 822:	fff94583          	lbu	a1,-1(s2)
 826:	8526                	mv	a0,s1
 828:	00000097          	auipc	ra,0x0
 82c:	f58080e7          	jalr	-168(ra) # 780 <putc>
  while(--i >= 0)
 830:	197d                	addi	s2,s2,-1
 832:	ff3918e3          	bne	s2,s3,822 <printint+0x80>
}
 836:	70e2                	ld	ra,56(sp)
 838:	7442                	ld	s0,48(sp)
 83a:	74a2                	ld	s1,40(sp)
 83c:	7902                	ld	s2,32(sp)
 83e:	69e2                	ld	s3,24(sp)
 840:	6121                	addi	sp,sp,64
 842:	8082                	ret
    x = -xx;
 844:	40b005bb          	negw	a1,a1
    neg = 1;
 848:	4885                	li	a7,1
    x = -xx;
 84a:	bf8d                	j	7bc <printint+0x1a>

000000000000084c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 84c:	7119                	addi	sp,sp,-128
 84e:	fc86                	sd	ra,120(sp)
 850:	f8a2                	sd	s0,112(sp)
 852:	f4a6                	sd	s1,104(sp)
 854:	f0ca                	sd	s2,96(sp)
 856:	ecce                	sd	s3,88(sp)
 858:	e8d2                	sd	s4,80(sp)
 85a:	e4d6                	sd	s5,72(sp)
 85c:	e0da                	sd	s6,64(sp)
 85e:	fc5e                	sd	s7,56(sp)
 860:	f862                	sd	s8,48(sp)
 862:	f466                	sd	s9,40(sp)
 864:	f06a                	sd	s10,32(sp)
 866:	ec6e                	sd	s11,24(sp)
 868:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 86a:	0005c903          	lbu	s2,0(a1)
 86e:	18090f63          	beqz	s2,a0c <vprintf+0x1c0>
 872:	8aaa                	mv	s5,a0
 874:	8b32                	mv	s6,a2
 876:	00158493          	addi	s1,a1,1
  state = 0;
 87a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 87c:	02500a13          	li	s4,37
      if(c == 'd'){
 880:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 884:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 888:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 88c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 890:	00000b97          	auipc	s7,0x0
 894:	478b8b93          	addi	s7,s7,1144 # d08 <digits>
 898:	a839                	j	8b6 <vprintf+0x6a>
        putc(fd, c);
 89a:	85ca                	mv	a1,s2
 89c:	8556                	mv	a0,s5
 89e:	00000097          	auipc	ra,0x0
 8a2:	ee2080e7          	jalr	-286(ra) # 780 <putc>
 8a6:	a019                	j	8ac <vprintf+0x60>
    } else if(state == '%'){
 8a8:	01498f63          	beq	s3,s4,8c6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 8ac:	0485                	addi	s1,s1,1
 8ae:	fff4c903          	lbu	s2,-1(s1)
 8b2:	14090d63          	beqz	s2,a0c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 8b6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8ba:	fe0997e3          	bnez	s3,8a8 <vprintf+0x5c>
      if(c == '%'){
 8be:	fd479ee3          	bne	a5,s4,89a <vprintf+0x4e>
        state = '%';
 8c2:	89be                	mv	s3,a5
 8c4:	b7e5                	j	8ac <vprintf+0x60>
      if(c == 'd'){
 8c6:	05878063          	beq	a5,s8,906 <vprintf+0xba>
      } else if(c == 'l') {
 8ca:	05978c63          	beq	a5,s9,922 <vprintf+0xd6>
      } else if(c == 'x') {
 8ce:	07a78863          	beq	a5,s10,93e <vprintf+0xf2>
      } else if(c == 'p') {
 8d2:	09b78463          	beq	a5,s11,95a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 8d6:	07300713          	li	a4,115
 8da:	0ce78663          	beq	a5,a4,9a6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8de:	06300713          	li	a4,99
 8e2:	0ee78e63          	beq	a5,a4,9de <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 8e6:	11478863          	beq	a5,s4,9f6 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8ea:	85d2                	mv	a1,s4
 8ec:	8556                	mv	a0,s5
 8ee:	00000097          	auipc	ra,0x0
 8f2:	e92080e7          	jalr	-366(ra) # 780 <putc>
        putc(fd, c);
 8f6:	85ca                	mv	a1,s2
 8f8:	8556                	mv	a0,s5
 8fa:	00000097          	auipc	ra,0x0
 8fe:	e86080e7          	jalr	-378(ra) # 780 <putc>
      }
      state = 0;
 902:	4981                	li	s3,0
 904:	b765                	j	8ac <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 906:	008b0913          	addi	s2,s6,8
 90a:	4685                	li	a3,1
 90c:	4629                	li	a2,10
 90e:	000b2583          	lw	a1,0(s6)
 912:	8556                	mv	a0,s5
 914:	00000097          	auipc	ra,0x0
 918:	e8e080e7          	jalr	-370(ra) # 7a2 <printint>
 91c:	8b4a                	mv	s6,s2
      state = 0;
 91e:	4981                	li	s3,0
 920:	b771                	j	8ac <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 922:	008b0913          	addi	s2,s6,8
 926:	4681                	li	a3,0
 928:	4629                	li	a2,10
 92a:	000b2583          	lw	a1,0(s6)
 92e:	8556                	mv	a0,s5
 930:	00000097          	auipc	ra,0x0
 934:	e72080e7          	jalr	-398(ra) # 7a2 <printint>
 938:	8b4a                	mv	s6,s2
      state = 0;
 93a:	4981                	li	s3,0
 93c:	bf85                	j	8ac <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 93e:	008b0913          	addi	s2,s6,8
 942:	4681                	li	a3,0
 944:	4641                	li	a2,16
 946:	000b2583          	lw	a1,0(s6)
 94a:	8556                	mv	a0,s5
 94c:	00000097          	auipc	ra,0x0
 950:	e56080e7          	jalr	-426(ra) # 7a2 <printint>
 954:	8b4a                	mv	s6,s2
      state = 0;
 956:	4981                	li	s3,0
 958:	bf91                	j	8ac <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 95a:	008b0793          	addi	a5,s6,8
 95e:	f8f43423          	sd	a5,-120(s0)
 962:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 966:	03000593          	li	a1,48
 96a:	8556                	mv	a0,s5
 96c:	00000097          	auipc	ra,0x0
 970:	e14080e7          	jalr	-492(ra) # 780 <putc>
  putc(fd, 'x');
 974:	85ea                	mv	a1,s10
 976:	8556                	mv	a0,s5
 978:	00000097          	auipc	ra,0x0
 97c:	e08080e7          	jalr	-504(ra) # 780 <putc>
 980:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 982:	03c9d793          	srli	a5,s3,0x3c
 986:	97de                	add	a5,a5,s7
 988:	0007c583          	lbu	a1,0(a5)
 98c:	8556                	mv	a0,s5
 98e:	00000097          	auipc	ra,0x0
 992:	df2080e7          	jalr	-526(ra) # 780 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 996:	0992                	slli	s3,s3,0x4
 998:	397d                	addiw	s2,s2,-1
 99a:	fe0914e3          	bnez	s2,982 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 99e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 9a2:	4981                	li	s3,0
 9a4:	b721                	j	8ac <vprintf+0x60>
        s = va_arg(ap, char*);
 9a6:	008b0993          	addi	s3,s6,8
 9aa:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 9ae:	02090163          	beqz	s2,9d0 <vprintf+0x184>
        while(*s != 0){
 9b2:	00094583          	lbu	a1,0(s2)
 9b6:	c9a1                	beqz	a1,a06 <vprintf+0x1ba>
          putc(fd, *s);
 9b8:	8556                	mv	a0,s5
 9ba:	00000097          	auipc	ra,0x0
 9be:	dc6080e7          	jalr	-570(ra) # 780 <putc>
          s++;
 9c2:	0905                	addi	s2,s2,1
        while(*s != 0){
 9c4:	00094583          	lbu	a1,0(s2)
 9c8:	f9e5                	bnez	a1,9b8 <vprintf+0x16c>
        s = va_arg(ap, char*);
 9ca:	8b4e                	mv	s6,s3
      state = 0;
 9cc:	4981                	li	s3,0
 9ce:	bdf9                	j	8ac <vprintf+0x60>
          s = "(null)";
 9d0:	00000917          	auipc	s2,0x0
 9d4:	33090913          	addi	s2,s2,816 # d00 <malloc+0x1ea>
        while(*s != 0){
 9d8:	02800593          	li	a1,40
 9dc:	bff1                	j	9b8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 9de:	008b0913          	addi	s2,s6,8
 9e2:	000b4583          	lbu	a1,0(s6)
 9e6:	8556                	mv	a0,s5
 9e8:	00000097          	auipc	ra,0x0
 9ec:	d98080e7          	jalr	-616(ra) # 780 <putc>
 9f0:	8b4a                	mv	s6,s2
      state = 0;
 9f2:	4981                	li	s3,0
 9f4:	bd65                	j	8ac <vprintf+0x60>
        putc(fd, c);
 9f6:	85d2                	mv	a1,s4
 9f8:	8556                	mv	a0,s5
 9fa:	00000097          	auipc	ra,0x0
 9fe:	d86080e7          	jalr	-634(ra) # 780 <putc>
      state = 0;
 a02:	4981                	li	s3,0
 a04:	b565                	j	8ac <vprintf+0x60>
        s = va_arg(ap, char*);
 a06:	8b4e                	mv	s6,s3
      state = 0;
 a08:	4981                	li	s3,0
 a0a:	b54d                	j	8ac <vprintf+0x60>
    }
  }
}
 a0c:	70e6                	ld	ra,120(sp)
 a0e:	7446                	ld	s0,112(sp)
 a10:	74a6                	ld	s1,104(sp)
 a12:	7906                	ld	s2,96(sp)
 a14:	69e6                	ld	s3,88(sp)
 a16:	6a46                	ld	s4,80(sp)
 a18:	6aa6                	ld	s5,72(sp)
 a1a:	6b06                	ld	s6,64(sp)
 a1c:	7be2                	ld	s7,56(sp)
 a1e:	7c42                	ld	s8,48(sp)
 a20:	7ca2                	ld	s9,40(sp)
 a22:	7d02                	ld	s10,32(sp)
 a24:	6de2                	ld	s11,24(sp)
 a26:	6109                	addi	sp,sp,128
 a28:	8082                	ret

0000000000000a2a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a2a:	715d                	addi	sp,sp,-80
 a2c:	ec06                	sd	ra,24(sp)
 a2e:	e822                	sd	s0,16(sp)
 a30:	1000                	addi	s0,sp,32
 a32:	e010                	sd	a2,0(s0)
 a34:	e414                	sd	a3,8(s0)
 a36:	e818                	sd	a4,16(s0)
 a38:	ec1c                	sd	a5,24(s0)
 a3a:	03043023          	sd	a6,32(s0)
 a3e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a42:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a46:	8622                	mv	a2,s0
 a48:	00000097          	auipc	ra,0x0
 a4c:	e04080e7          	jalr	-508(ra) # 84c <vprintf>
}
 a50:	60e2                	ld	ra,24(sp)
 a52:	6442                	ld	s0,16(sp)
 a54:	6161                	addi	sp,sp,80
 a56:	8082                	ret

0000000000000a58 <printf>:

void
printf(const char *fmt, ...)
{
 a58:	711d                	addi	sp,sp,-96
 a5a:	ec06                	sd	ra,24(sp)
 a5c:	e822                	sd	s0,16(sp)
 a5e:	1000                	addi	s0,sp,32
 a60:	e40c                	sd	a1,8(s0)
 a62:	e810                	sd	a2,16(s0)
 a64:	ec14                	sd	a3,24(s0)
 a66:	f018                	sd	a4,32(s0)
 a68:	f41c                	sd	a5,40(s0)
 a6a:	03043823          	sd	a6,48(s0)
 a6e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a72:	00840613          	addi	a2,s0,8
 a76:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a7a:	85aa                	mv	a1,a0
 a7c:	4505                	li	a0,1
 a7e:	00000097          	auipc	ra,0x0
 a82:	dce080e7          	jalr	-562(ra) # 84c <vprintf>
}
 a86:	60e2                	ld	ra,24(sp)
 a88:	6442                	ld	s0,16(sp)
 a8a:	6125                	addi	sp,sp,96
 a8c:	8082                	ret

0000000000000a8e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a8e:	1141                	addi	sp,sp,-16
 a90:	e422                	sd	s0,8(sp)
 a92:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a94:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a98:	00000797          	auipc	a5,0x0
 a9c:	2a87b783          	ld	a5,680(a5) # d40 <freep>
 aa0:	a805                	j	ad0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 aa2:	4618                	lw	a4,8(a2)
 aa4:	9db9                	addw	a1,a1,a4
 aa6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 aaa:	6398                	ld	a4,0(a5)
 aac:	6318                	ld	a4,0(a4)
 aae:	fee53823          	sd	a4,-16(a0)
 ab2:	a091                	j	af6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ab4:	ff852703          	lw	a4,-8(a0)
 ab8:	9e39                	addw	a2,a2,a4
 aba:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 abc:	ff053703          	ld	a4,-16(a0)
 ac0:	e398                	sd	a4,0(a5)
 ac2:	a099                	j	b08 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ac4:	6398                	ld	a4,0(a5)
 ac6:	00e7e463          	bltu	a5,a4,ace <free+0x40>
 aca:	00e6ea63          	bltu	a3,a4,ade <free+0x50>
{
 ace:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad0:	fed7fae3          	bgeu	a5,a3,ac4 <free+0x36>
 ad4:	6398                	ld	a4,0(a5)
 ad6:	00e6e463          	bltu	a3,a4,ade <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ada:	fee7eae3          	bltu	a5,a4,ace <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 ade:	ff852583          	lw	a1,-8(a0)
 ae2:	6390                	ld	a2,0(a5)
 ae4:	02059713          	slli	a4,a1,0x20
 ae8:	9301                	srli	a4,a4,0x20
 aea:	0712                	slli	a4,a4,0x4
 aec:	9736                	add	a4,a4,a3
 aee:	fae60ae3          	beq	a2,a4,aa2 <free+0x14>
    bp->s.ptr = p->s.ptr;
 af2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 af6:	4790                	lw	a2,8(a5)
 af8:	02061713          	slli	a4,a2,0x20
 afc:	9301                	srli	a4,a4,0x20
 afe:	0712                	slli	a4,a4,0x4
 b00:	973e                	add	a4,a4,a5
 b02:	fae689e3          	beq	a3,a4,ab4 <free+0x26>
  } else
    p->s.ptr = bp;
 b06:	e394                	sd	a3,0(a5)
  freep = p;
 b08:	00000717          	auipc	a4,0x0
 b0c:	22f73c23          	sd	a5,568(a4) # d40 <freep>
}
 b10:	6422                	ld	s0,8(sp)
 b12:	0141                	addi	sp,sp,16
 b14:	8082                	ret

0000000000000b16 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b16:	7139                	addi	sp,sp,-64
 b18:	fc06                	sd	ra,56(sp)
 b1a:	f822                	sd	s0,48(sp)
 b1c:	f426                	sd	s1,40(sp)
 b1e:	f04a                	sd	s2,32(sp)
 b20:	ec4e                	sd	s3,24(sp)
 b22:	e852                	sd	s4,16(sp)
 b24:	e456                	sd	s5,8(sp)
 b26:	e05a                	sd	s6,0(sp)
 b28:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b2a:	02051493          	slli	s1,a0,0x20
 b2e:	9081                	srli	s1,s1,0x20
 b30:	04bd                	addi	s1,s1,15
 b32:	8091                	srli	s1,s1,0x4
 b34:	0014899b          	addiw	s3,s1,1
 b38:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b3a:	00000517          	auipc	a0,0x0
 b3e:	20653503          	ld	a0,518(a0) # d40 <freep>
 b42:	c515                	beqz	a0,b6e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b44:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b46:	4798                	lw	a4,8(a5)
 b48:	02977f63          	bgeu	a4,s1,b86 <malloc+0x70>
 b4c:	8a4e                	mv	s4,s3
 b4e:	0009871b          	sext.w	a4,s3
 b52:	6685                	lui	a3,0x1
 b54:	00d77363          	bgeu	a4,a3,b5a <malloc+0x44>
 b58:	6a05                	lui	s4,0x1
 b5a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b5e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b62:	00000917          	auipc	s2,0x0
 b66:	1de90913          	addi	s2,s2,478 # d40 <freep>
  if(p == (char*)-1)
 b6a:	5afd                	li	s5,-1
 b6c:	a88d                	j	bde <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 b6e:	00008797          	auipc	a5,0x8
 b72:	3ba78793          	addi	a5,a5,954 # 8f28 <base>
 b76:	00000717          	auipc	a4,0x0
 b7a:	1cf73523          	sd	a5,458(a4) # d40 <freep>
 b7e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b80:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b84:	b7e1                	j	b4c <malloc+0x36>
      if(p->s.size == nunits)
 b86:	02e48b63          	beq	s1,a4,bbc <malloc+0xa6>
        p->s.size -= nunits;
 b8a:	4137073b          	subw	a4,a4,s3
 b8e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b90:	1702                	slli	a4,a4,0x20
 b92:	9301                	srli	a4,a4,0x20
 b94:	0712                	slli	a4,a4,0x4
 b96:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b98:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b9c:	00000717          	auipc	a4,0x0
 ba0:	1aa73223          	sd	a0,420(a4) # d40 <freep>
      return (void*)(p + 1);
 ba4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ba8:	70e2                	ld	ra,56(sp)
 baa:	7442                	ld	s0,48(sp)
 bac:	74a2                	ld	s1,40(sp)
 bae:	7902                	ld	s2,32(sp)
 bb0:	69e2                	ld	s3,24(sp)
 bb2:	6a42                	ld	s4,16(sp)
 bb4:	6aa2                	ld	s5,8(sp)
 bb6:	6b02                	ld	s6,0(sp)
 bb8:	6121                	addi	sp,sp,64
 bba:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 bbc:	6398                	ld	a4,0(a5)
 bbe:	e118                	sd	a4,0(a0)
 bc0:	bff1                	j	b9c <malloc+0x86>
  hp->s.size = nu;
 bc2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bc6:	0541                	addi	a0,a0,16
 bc8:	00000097          	auipc	ra,0x0
 bcc:	ec6080e7          	jalr	-314(ra) # a8e <free>
  return freep;
 bd0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bd4:	d971                	beqz	a0,ba8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bd6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bd8:	4798                	lw	a4,8(a5)
 bda:	fa9776e3          	bgeu	a4,s1,b86 <malloc+0x70>
    if(p == freep)
 bde:	00093703          	ld	a4,0(s2)
 be2:	853e                	mv	a0,a5
 be4:	fef719e3          	bne	a4,a5,bd6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 be8:	8552                	mv	a0,s4
 bea:	00000097          	auipc	ra,0x0
 bee:	b7e080e7          	jalr	-1154(ra) # 768 <sbrk>
  if(p == (char*)-1)
 bf2:	fd5518e3          	bne	a0,s5,bc2 <malloc+0xac>
        return 0;
 bf6:	4501                	li	a0,0
 bf8:	bf45                	j	ba8 <malloc+0x92>
