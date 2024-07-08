
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	b9010113          	add	sp,sp,-1136 # 80008b90 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	add	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	add	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	sllw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	sll	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	sll	a3,a3,0x3
    80000050:	00009717          	auipc	a4,0x9
    80000054:	a0070713          	add	a4,a4,-1536 # 80008a50 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	4be78793          	add	a5,a5,1214 # 80006520 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	add	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	add	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdbad27>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	ec478793          	add	a5,a5,-316 # 80000f70 <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srl	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	add	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	add	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	fc26                	sd	s1,56(sp)
    80000108:	f84a                	sd	s2,48(sp)
    8000010a:	f44e                	sd	s3,40(sp)
    8000010c:	f052                	sd	s4,32(sp)
    8000010e:	ec56                	sd	s5,24(sp)
    80000110:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000112:	04c05763          	blez	a2,80000160 <consolewrite+0x60>
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	add	a0,s0,-65
    8000012a:	00003097          	auipc	ra,0x3
    8000012e:	94c080e7          	jalr	-1716(ra) # 80002a76 <either_copyin>
    80000132:	01550d63          	beq	a0,s5,8000014c <consolewrite+0x4c>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	780080e7          	jalr	1920(ra) # 800008ba <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addw	s2,s2,1
    80000144:	0485                	add	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	add	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4c>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	711d                	add	sp,sp,-96
    80000166:	ec86                	sd	ra,88(sp)
    80000168:	e8a2                	sd	s0,80(sp)
    8000016a:	e4a6                	sd	s1,72(sp)
    8000016c:	e0ca                	sd	s2,64(sp)
    8000016e:	fc4e                	sd	s3,56(sp)
    80000170:	f852                	sd	s4,48(sp)
    80000172:	f456                	sd	s5,40(sp)
    80000174:	f05a                	sd	s6,32(sp)
    80000176:	ec5e                	sd	s7,24(sp)
    80000178:	1080                	add	s0,sp,96
    8000017a:	8aaa                	mv	s5,a0
    8000017c:	8a2e                	mv	s4,a1
    8000017e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000180:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000184:	00011517          	auipc	a0,0x11
    80000188:	a0c50513          	add	a0,a0,-1524 # 80010b90 <cons>
    8000018c:	00001097          	auipc	ra,0x1
    80000190:	b44080e7          	jalr	-1212(ra) # 80000cd0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000194:	00011497          	auipc	s1,0x11
    80000198:	9fc48493          	add	s1,s1,-1540 # 80010b90 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000019c:	00011917          	auipc	s2,0x11
    800001a0:	a8c90913          	add	s2,s2,-1396 # 80010c28 <cons+0x98>
  while(n > 0){
    800001a4:	09305263          	blez	s3,80000228 <consoleread+0xc4>
    while(cons.r == cons.w){
    800001a8:	0984a783          	lw	a5,152(s1)
    800001ac:	09c4a703          	lw	a4,156(s1)
    800001b0:	02f71763          	bne	a4,a5,800001de <consoleread+0x7a>
      if(killed(myproc())){
    800001b4:	00002097          	auipc	ra,0x2
    800001b8:	bfc080e7          	jalr	-1028(ra) # 80001db0 <myproc>
    800001bc:	00002097          	auipc	ra,0x2
    800001c0:	654080e7          	jalr	1620(ra) # 80002810 <killed>
    800001c4:	ed2d                	bnez	a0,8000023e <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    800001c6:	85a6                	mv	a1,s1
    800001c8:	854a                	mv	a0,s2
    800001ca:	00002097          	auipc	ra,0x2
    800001ce:	530080e7          	jalr	1328(ra) # 800026fa <sleep>
    while(cons.r == cons.w){
    800001d2:	0984a783          	lw	a5,152(s1)
    800001d6:	09c4a703          	lw	a4,156(s1)
    800001da:	fcf70de3          	beq	a4,a5,800001b4 <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	00011717          	auipc	a4,0x11
    800001e2:	9b270713          	add	a4,a4,-1614 # 80010b90 <cons>
    800001e6:	0017869b          	addw	a3,a5,1
    800001ea:	08d72c23          	sw	a3,152(a4)
    800001ee:	07f7f693          	and	a3,a5,127
    800001f2:	9736                	add	a4,a4,a3
    800001f4:	01874703          	lbu	a4,24(a4)
    800001f8:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001fc:	4691                	li	a3,4
    800001fe:	06db8463          	beq	s7,a3,80000266 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000202:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000206:	4685                	li	a3,1
    80000208:	faf40613          	add	a2,s0,-81
    8000020c:	85d2                	mv	a1,s4
    8000020e:	8556                	mv	a0,s5
    80000210:	00002097          	auipc	ra,0x2
    80000214:	760080e7          	jalr	1888(ra) # 80002970 <either_copyout>
    80000218:	57fd                	li	a5,-1
    8000021a:	00f50763          	beq	a0,a5,80000228 <consoleread+0xc4>
      break;

    dst++;
    8000021e:	0a05                	add	s4,s4,1
    --n;
    80000220:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    80000222:	47a9                	li	a5,10
    80000224:	f8fb90e3          	bne	s7,a5,800001a4 <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000228:	00011517          	auipc	a0,0x11
    8000022c:	96850513          	add	a0,a0,-1688 # 80010b90 <cons>
    80000230:	00001097          	auipc	ra,0x1
    80000234:	b54080e7          	jalr	-1196(ra) # 80000d84 <release>

  return target - n;
    80000238:	413b053b          	subw	a0,s6,s3
    8000023c:	a811                	j	80000250 <consoleread+0xec>
        release(&cons.lock);
    8000023e:	00011517          	auipc	a0,0x11
    80000242:	95250513          	add	a0,a0,-1710 # 80010b90 <cons>
    80000246:	00001097          	auipc	ra,0x1
    8000024a:	b3e080e7          	jalr	-1218(ra) # 80000d84 <release>
        return -1;
    8000024e:	557d                	li	a0,-1
}
    80000250:	60e6                	ld	ra,88(sp)
    80000252:	6446                	ld	s0,80(sp)
    80000254:	64a6                	ld	s1,72(sp)
    80000256:	6906                	ld	s2,64(sp)
    80000258:	79e2                	ld	s3,56(sp)
    8000025a:	7a42                	ld	s4,48(sp)
    8000025c:	7aa2                	ld	s5,40(sp)
    8000025e:	7b02                	ld	s6,32(sp)
    80000260:	6be2                	ld	s7,24(sp)
    80000262:	6125                	add	sp,sp,96
    80000264:	8082                	ret
      if(n < target){
    80000266:	0009871b          	sext.w	a4,s3
    8000026a:	fb677fe3          	bgeu	a4,s6,80000228 <consoleread+0xc4>
        cons.r--;
    8000026e:	00011717          	auipc	a4,0x11
    80000272:	9af72d23          	sw	a5,-1606(a4) # 80010c28 <cons+0x98>
    80000276:	bf4d                	j	80000228 <consoleread+0xc4>

0000000080000278 <consputc>:
{
    80000278:	1141                	add	sp,sp,-16
    8000027a:	e406                	sd	ra,8(sp)
    8000027c:	e022                	sd	s0,0(sp)
    8000027e:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    80000280:	10000793          	li	a5,256
    80000284:	00f50a63          	beq	a0,a5,80000298 <consputc+0x20>
    uartputc_sync(c);
    80000288:	00000097          	auipc	ra,0x0
    8000028c:	560080e7          	jalr	1376(ra) # 800007e8 <uartputc_sync>
}
    80000290:	60a2                	ld	ra,8(sp)
    80000292:	6402                	ld	s0,0(sp)
    80000294:	0141                	add	sp,sp,16
    80000296:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000298:	4521                	li	a0,8
    8000029a:	00000097          	auipc	ra,0x0
    8000029e:	54e080e7          	jalr	1358(ra) # 800007e8 <uartputc_sync>
    800002a2:	02000513          	li	a0,32
    800002a6:	00000097          	auipc	ra,0x0
    800002aa:	542080e7          	jalr	1346(ra) # 800007e8 <uartputc_sync>
    800002ae:	4521                	li	a0,8
    800002b0:	00000097          	auipc	ra,0x0
    800002b4:	538080e7          	jalr	1336(ra) # 800007e8 <uartputc_sync>
    800002b8:	bfe1                	j	80000290 <consputc+0x18>

00000000800002ba <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ba:	1101                	add	sp,sp,-32
    800002bc:	ec06                	sd	ra,24(sp)
    800002be:	e822                	sd	s0,16(sp)
    800002c0:	e426                	sd	s1,8(sp)
    800002c2:	e04a                	sd	s2,0(sp)
    800002c4:	1000                	add	s0,sp,32
    800002c6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002c8:	00011517          	auipc	a0,0x11
    800002cc:	8c850513          	add	a0,a0,-1848 # 80010b90 <cons>
    800002d0:	00001097          	auipc	ra,0x1
    800002d4:	a00080e7          	jalr	-1536(ra) # 80000cd0 <acquire>

  switch(c){
    800002d8:	47d5                	li	a5,21
    800002da:	0af48663          	beq	s1,a5,80000386 <consoleintr+0xcc>
    800002de:	0297ca63          	blt	a5,s1,80000312 <consoleintr+0x58>
    800002e2:	47a1                	li	a5,8
    800002e4:	0ef48763          	beq	s1,a5,800003d2 <consoleintr+0x118>
    800002e8:	47c1                	li	a5,16
    800002ea:	10f49a63          	bne	s1,a5,800003fe <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002ee:	00002097          	auipc	ra,0x2
    800002f2:	6d8080e7          	jalr	1752(ra) # 800029c6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002f6:	00011517          	auipc	a0,0x11
    800002fa:	89a50513          	add	a0,a0,-1894 # 80010b90 <cons>
    800002fe:	00001097          	auipc	ra,0x1
    80000302:	a86080e7          	jalr	-1402(ra) # 80000d84 <release>
}
    80000306:	60e2                	ld	ra,24(sp)
    80000308:	6442                	ld	s0,16(sp)
    8000030a:	64a2                	ld	s1,8(sp)
    8000030c:	6902                	ld	s2,0(sp)
    8000030e:	6105                	add	sp,sp,32
    80000310:	8082                	ret
  switch(c){
    80000312:	07f00793          	li	a5,127
    80000316:	0af48e63          	beq	s1,a5,800003d2 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000031a:	00011717          	auipc	a4,0x11
    8000031e:	87670713          	add	a4,a4,-1930 # 80010b90 <cons>
    80000322:	0a072783          	lw	a5,160(a4)
    80000326:	09872703          	lw	a4,152(a4)
    8000032a:	9f99                	subw	a5,a5,a4
    8000032c:	07f00713          	li	a4,127
    80000330:	fcf763e3          	bltu	a4,a5,800002f6 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000334:	47b5                	li	a5,13
    80000336:	0cf48763          	beq	s1,a5,80000404 <consoleintr+0x14a>
      consputc(c);
    8000033a:	8526                	mv	a0,s1
    8000033c:	00000097          	auipc	ra,0x0
    80000340:	f3c080e7          	jalr	-196(ra) # 80000278 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000344:	00011797          	auipc	a5,0x11
    80000348:	84c78793          	add	a5,a5,-1972 # 80010b90 <cons>
    8000034c:	0a07a683          	lw	a3,160(a5)
    80000350:	0016871b          	addw	a4,a3,1
    80000354:	0007061b          	sext.w	a2,a4
    80000358:	0ae7a023          	sw	a4,160(a5)
    8000035c:	07f6f693          	and	a3,a3,127
    80000360:	97b6                	add	a5,a5,a3
    80000362:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000366:	47a9                	li	a5,10
    80000368:	0cf48563          	beq	s1,a5,80000432 <consoleintr+0x178>
    8000036c:	4791                	li	a5,4
    8000036e:	0cf48263          	beq	s1,a5,80000432 <consoleintr+0x178>
    80000372:	00011797          	auipc	a5,0x11
    80000376:	8b67a783          	lw	a5,-1866(a5) # 80010c28 <cons+0x98>
    8000037a:	9f1d                	subw	a4,a4,a5
    8000037c:	08000793          	li	a5,128
    80000380:	f6f71be3          	bne	a4,a5,800002f6 <consoleintr+0x3c>
    80000384:	a07d                	j	80000432 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000386:	00011717          	auipc	a4,0x11
    8000038a:	80a70713          	add	a4,a4,-2038 # 80010b90 <cons>
    8000038e:	0a072783          	lw	a5,160(a4)
    80000392:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000396:	00010497          	auipc	s1,0x10
    8000039a:	7fa48493          	add	s1,s1,2042 # 80010b90 <cons>
    while(cons.e != cons.w &&
    8000039e:	4929                	li	s2,10
    800003a0:	f4f70be3          	beq	a4,a5,800002f6 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a4:	37fd                	addw	a5,a5,-1
    800003a6:	07f7f713          	and	a4,a5,127
    800003aa:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003ac:	01874703          	lbu	a4,24(a4)
    800003b0:	f52703e3          	beq	a4,s2,800002f6 <consoleintr+0x3c>
      cons.e--;
    800003b4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003b8:	10000513          	li	a0,256
    800003bc:	00000097          	auipc	ra,0x0
    800003c0:	ebc080e7          	jalr	-324(ra) # 80000278 <consputc>
    while(cons.e != cons.w &&
    800003c4:	0a04a783          	lw	a5,160(s1)
    800003c8:	09c4a703          	lw	a4,156(s1)
    800003cc:	fcf71ce3          	bne	a4,a5,800003a4 <consoleintr+0xea>
    800003d0:	b71d                	j	800002f6 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d2:	00010717          	auipc	a4,0x10
    800003d6:	7be70713          	add	a4,a4,1982 # 80010b90 <cons>
    800003da:	0a072783          	lw	a5,160(a4)
    800003de:	09c72703          	lw	a4,156(a4)
    800003e2:	f0f70ae3          	beq	a4,a5,800002f6 <consoleintr+0x3c>
      cons.e--;
    800003e6:	37fd                	addw	a5,a5,-1
    800003e8:	00011717          	auipc	a4,0x11
    800003ec:	84f72423          	sw	a5,-1976(a4) # 80010c30 <cons+0xa0>
      consputc(BACKSPACE);
    800003f0:	10000513          	li	a0,256
    800003f4:	00000097          	auipc	ra,0x0
    800003f8:	e84080e7          	jalr	-380(ra) # 80000278 <consputc>
    800003fc:	bded                	j	800002f6 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003fe:	ee048ce3          	beqz	s1,800002f6 <consoleintr+0x3c>
    80000402:	bf21                	j	8000031a <consoleintr+0x60>
      consputc(c);
    80000404:	4529                	li	a0,10
    80000406:	00000097          	auipc	ra,0x0
    8000040a:	e72080e7          	jalr	-398(ra) # 80000278 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000040e:	00010797          	auipc	a5,0x10
    80000412:	78278793          	add	a5,a5,1922 # 80010b90 <cons>
    80000416:	0a07a703          	lw	a4,160(a5)
    8000041a:	0017069b          	addw	a3,a4,1
    8000041e:	0006861b          	sext.w	a2,a3
    80000422:	0ad7a023          	sw	a3,160(a5)
    80000426:	07f77713          	and	a4,a4,127
    8000042a:	97ba                	add	a5,a5,a4
    8000042c:	4729                	li	a4,10
    8000042e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000432:	00010797          	auipc	a5,0x10
    80000436:	7ec7ad23          	sw	a2,2042(a5) # 80010c2c <cons+0x9c>
        wakeup(&cons.r);
    8000043a:	00010517          	auipc	a0,0x10
    8000043e:	7ee50513          	add	a0,a0,2030 # 80010c28 <cons+0x98>
    80000442:	00002097          	auipc	ra,0x2
    80000446:	0ea080e7          	jalr	234(ra) # 8000252c <wakeup>
    8000044a:	b575                	j	800002f6 <consoleintr+0x3c>

000000008000044c <consoleinit>:

void
consoleinit(void)
{
    8000044c:	1141                	add	sp,sp,-16
    8000044e:	e406                	sd	ra,8(sp)
    80000450:	e022                	sd	s0,0(sp)
    80000452:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    80000454:	00008597          	auipc	a1,0x8
    80000458:	bbc58593          	add	a1,a1,-1092 # 80008010 <etext+0x10>
    8000045c:	00010517          	auipc	a0,0x10
    80000460:	73450513          	add	a0,a0,1844 # 80010b90 <cons>
    80000464:	00000097          	auipc	ra,0x0
    80000468:	7dc080e7          	jalr	2012(ra) # 80000c40 <initlock>

  uartinit();
    8000046c:	00000097          	auipc	ra,0x0
    80000470:	32c080e7          	jalr	812(ra) # 80000798 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000474:	00242797          	auipc	a5,0x242
    80000478:	4cc78793          	add	a5,a5,1228 # 80242940 <devsw>
    8000047c:	00000717          	auipc	a4,0x0
    80000480:	ce870713          	add	a4,a4,-792 # 80000164 <consoleread>
    80000484:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000486:	00000717          	auipc	a4,0x0
    8000048a:	c7a70713          	add	a4,a4,-902 # 80000100 <consolewrite>
    8000048e:	ef98                	sd	a4,24(a5)
}
    80000490:	60a2                	ld	ra,8(sp)
    80000492:	6402                	ld	s0,0(sp)
    80000494:	0141                	add	sp,sp,16
    80000496:	8082                	ret

0000000080000498 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80000498:	7179                	add	sp,sp,-48
    8000049a:	f406                	sd	ra,40(sp)
    8000049c:	f022                	sd	s0,32(sp)
    8000049e:	ec26                	sd	s1,24(sp)
    800004a0:	e84a                	sd	s2,16(sp)
    800004a2:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a4:	c219                	beqz	a2,800004aa <printint+0x12>
    800004a6:	08054763          	bltz	a0,80000534 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004aa:	2501                	sext.w	a0,a0
    800004ac:	4881                	li	a7,0
    800004ae:	fd040693          	add	a3,s0,-48

  i = 0;
    800004b2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b4:	2581                	sext.w	a1,a1
    800004b6:	00008617          	auipc	a2,0x8
    800004ba:	3ca60613          	add	a2,a2,970 # 80008880 <digits>
    800004be:	883a                	mv	a6,a4
    800004c0:	2705                	addw	a4,a4,1
    800004c2:	02b577bb          	remuw	a5,a0,a1
    800004c6:	1782                	sll	a5,a5,0x20
    800004c8:	9381                	srl	a5,a5,0x20
    800004ca:	97b2                	add	a5,a5,a2
    800004cc:	0007c783          	lbu	a5,0(a5)
    800004d0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d4:	0005079b          	sext.w	a5,a0
    800004d8:	02b5553b          	divuw	a0,a0,a1
    800004dc:	0685                	add	a3,a3,1
    800004de:	feb7f0e3          	bgeu	a5,a1,800004be <printint+0x26>

  if(sign)
    800004e2:	00088c63          	beqz	a7,800004fa <printint+0x62>
    buf[i++] = '-';
    800004e6:	fe070793          	add	a5,a4,-32
    800004ea:	00878733          	add	a4,a5,s0
    800004ee:	02d00793          	li	a5,45
    800004f2:	fef70823          	sb	a5,-16(a4)
    800004f6:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    800004fa:	02e05763          	blez	a4,80000528 <printint+0x90>
    800004fe:	fd040793          	add	a5,s0,-48
    80000502:	00e784b3          	add	s1,a5,a4
    80000506:	fff78913          	add	s2,a5,-1
    8000050a:	993a                	add	s2,s2,a4
    8000050c:	377d                	addw	a4,a4,-1
    8000050e:	1702                	sll	a4,a4,0x20
    80000510:	9301                	srl	a4,a4,0x20
    80000512:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000516:	fff4c503          	lbu	a0,-1(s1)
    8000051a:	00000097          	auipc	ra,0x0
    8000051e:	d5e080e7          	jalr	-674(ra) # 80000278 <consputc>
  while(--i >= 0)
    80000522:	14fd                	add	s1,s1,-1
    80000524:	ff2499e3          	bne	s1,s2,80000516 <printint+0x7e>
}
    80000528:	70a2                	ld	ra,40(sp)
    8000052a:	7402                	ld	s0,32(sp)
    8000052c:	64e2                	ld	s1,24(sp)
    8000052e:	6942                	ld	s2,16(sp)
    80000530:	6145                	add	sp,sp,48
    80000532:	8082                	ret
    x = -xx;
    80000534:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000538:	4885                	li	a7,1
    x = -xx;
    8000053a:	bf95                	j	800004ae <printint+0x16>

000000008000053c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000053c:	1101                	add	sp,sp,-32
    8000053e:	ec06                	sd	ra,24(sp)
    80000540:	e822                	sd	s0,16(sp)
    80000542:	e426                	sd	s1,8(sp)
    80000544:	1000                	add	s0,sp,32
    80000546:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000548:	00010797          	auipc	a5,0x10
    8000054c:	7007a423          	sw	zero,1800(a5) # 80010c50 <pr+0x18>
  printf("panic: ");
    80000550:	00008517          	auipc	a0,0x8
    80000554:	ac850513          	add	a0,a0,-1336 # 80008018 <etext+0x18>
    80000558:	00000097          	auipc	ra,0x0
    8000055c:	02e080e7          	jalr	46(ra) # 80000586 <printf>
  printf(s);
    80000560:	8526                	mv	a0,s1
    80000562:	00000097          	auipc	ra,0x0
    80000566:	024080e7          	jalr	36(ra) # 80000586 <printf>
  printf("\n");
    8000056a:	00008517          	auipc	a0,0x8
    8000056e:	ab650513          	add	a0,a0,-1354 # 80008020 <etext+0x20>
    80000572:	00000097          	auipc	ra,0x0
    80000576:	014080e7          	jalr	20(ra) # 80000586 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057a:	4785                	li	a5,1
    8000057c:	00008717          	auipc	a4,0x8
    80000580:	48f72a23          	sw	a5,1172(a4) # 80008a10 <panicked>
  for(;;)
    80000584:	a001                	j	80000584 <panic+0x48>

0000000080000586 <printf>:
{
    80000586:	7131                	add	sp,sp,-192
    80000588:	fc86                	sd	ra,120(sp)
    8000058a:	f8a2                	sd	s0,112(sp)
    8000058c:	f4a6                	sd	s1,104(sp)
    8000058e:	f0ca                	sd	s2,96(sp)
    80000590:	ecce                	sd	s3,88(sp)
    80000592:	e8d2                	sd	s4,80(sp)
    80000594:	e4d6                	sd	s5,72(sp)
    80000596:	e0da                	sd	s6,64(sp)
    80000598:	fc5e                	sd	s7,56(sp)
    8000059a:	f862                	sd	s8,48(sp)
    8000059c:	f466                	sd	s9,40(sp)
    8000059e:	f06a                	sd	s10,32(sp)
    800005a0:	ec6e                	sd	s11,24(sp)
    800005a2:	0100                	add	s0,sp,128
    800005a4:	8a2a                	mv	s4,a0
    800005a6:	e40c                	sd	a1,8(s0)
    800005a8:	e810                	sd	a2,16(s0)
    800005aa:	ec14                	sd	a3,24(s0)
    800005ac:	f018                	sd	a4,32(s0)
    800005ae:	f41c                	sd	a5,40(s0)
    800005b0:	03043823          	sd	a6,48(s0)
    800005b4:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005b8:	00010d97          	auipc	s11,0x10
    800005bc:	698dad83          	lw	s11,1688(s11) # 80010c50 <pr+0x18>
  if(locking)
    800005c0:	020d9b63          	bnez	s11,800005f6 <printf+0x70>
  if (fmt == 0)
    800005c4:	040a0263          	beqz	s4,80000608 <printf+0x82>
  va_start(ap, fmt);
    800005c8:	00840793          	add	a5,s0,8
    800005cc:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d0:	000a4503          	lbu	a0,0(s4)
    800005d4:	14050f63          	beqz	a0,80000732 <printf+0x1ac>
    800005d8:	4981                	li	s3,0
    if(c != '%'){
    800005da:	02500a93          	li	s5,37
    switch(c){
    800005de:	07000b93          	li	s7,112
  consputc('x');
    800005e2:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e4:	00008b17          	auipc	s6,0x8
    800005e8:	29cb0b13          	add	s6,s6,668 # 80008880 <digits>
    switch(c){
    800005ec:	07300c93          	li	s9,115
    800005f0:	06400c13          	li	s8,100
    800005f4:	a82d                	j	8000062e <printf+0xa8>
    acquire(&pr.lock);
    800005f6:	00010517          	auipc	a0,0x10
    800005fa:	64250513          	add	a0,a0,1602 # 80010c38 <pr>
    800005fe:	00000097          	auipc	ra,0x0
    80000602:	6d2080e7          	jalr	1746(ra) # 80000cd0 <acquire>
    80000606:	bf7d                	j	800005c4 <printf+0x3e>
    panic("null fmt");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a2850513          	add	a0,a0,-1496 # 80008030 <etext+0x30>
    80000610:	00000097          	auipc	ra,0x0
    80000614:	f2c080e7          	jalr	-212(ra) # 8000053c <panic>
      consputc(c);
    80000618:	00000097          	auipc	ra,0x0
    8000061c:	c60080e7          	jalr	-928(ra) # 80000278 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000620:	2985                	addw	s3,s3,1
    80000622:	013a07b3          	add	a5,s4,s3
    80000626:	0007c503          	lbu	a0,0(a5)
    8000062a:	10050463          	beqz	a0,80000732 <printf+0x1ac>
    if(c != '%'){
    8000062e:	ff5515e3          	bne	a0,s5,80000618 <printf+0x92>
    c = fmt[++i] & 0xff;
    80000632:	2985                	addw	s3,s3,1
    80000634:	013a07b3          	add	a5,s4,s3
    80000638:	0007c783          	lbu	a5,0(a5)
    8000063c:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000640:	cbed                	beqz	a5,80000732 <printf+0x1ac>
    switch(c){
    80000642:	05778a63          	beq	a5,s7,80000696 <printf+0x110>
    80000646:	02fbf663          	bgeu	s7,a5,80000672 <printf+0xec>
    8000064a:	09978863          	beq	a5,s9,800006da <printf+0x154>
    8000064e:	07800713          	li	a4,120
    80000652:	0ce79563          	bne	a5,a4,8000071c <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000656:	f8843783          	ld	a5,-120(s0)
    8000065a:	00878713          	add	a4,a5,8
    8000065e:	f8e43423          	sd	a4,-120(s0)
    80000662:	4605                	li	a2,1
    80000664:	85ea                	mv	a1,s10
    80000666:	4388                	lw	a0,0(a5)
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	e30080e7          	jalr	-464(ra) # 80000498 <printint>
      break;
    80000670:	bf45                	j	80000620 <printf+0x9a>
    switch(c){
    80000672:	09578f63          	beq	a5,s5,80000710 <printf+0x18a>
    80000676:	0b879363          	bne	a5,s8,8000071c <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067a:	f8843783          	ld	a5,-120(s0)
    8000067e:	00878713          	add	a4,a5,8
    80000682:	f8e43423          	sd	a4,-120(s0)
    80000686:	4605                	li	a2,1
    80000688:	45a9                	li	a1,10
    8000068a:	4388                	lw	a0,0(a5)
    8000068c:	00000097          	auipc	ra,0x0
    80000690:	e0c080e7          	jalr	-500(ra) # 80000498 <printint>
      break;
    80000694:	b771                	j	80000620 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000696:	f8843783          	ld	a5,-120(s0)
    8000069a:	00878713          	add	a4,a5,8
    8000069e:	f8e43423          	sd	a4,-120(s0)
    800006a2:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006a6:	03000513          	li	a0,48
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	bce080e7          	jalr	-1074(ra) # 80000278 <consputc>
  consputc('x');
    800006b2:	07800513          	li	a0,120
    800006b6:	00000097          	auipc	ra,0x0
    800006ba:	bc2080e7          	jalr	-1086(ra) # 80000278 <consputc>
    800006be:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c0:	03c95793          	srl	a5,s2,0x3c
    800006c4:	97da                	add	a5,a5,s6
    800006c6:	0007c503          	lbu	a0,0(a5)
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	bae080e7          	jalr	-1106(ra) # 80000278 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d2:	0912                	sll	s2,s2,0x4
    800006d4:	34fd                	addw	s1,s1,-1
    800006d6:	f4ed                	bnez	s1,800006c0 <printf+0x13a>
    800006d8:	b7a1                	j	80000620 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006da:	f8843783          	ld	a5,-120(s0)
    800006de:	00878713          	add	a4,a5,8
    800006e2:	f8e43423          	sd	a4,-120(s0)
    800006e6:	6384                	ld	s1,0(a5)
    800006e8:	cc89                	beqz	s1,80000702 <printf+0x17c>
      for(; *s; s++)
    800006ea:	0004c503          	lbu	a0,0(s1)
    800006ee:	d90d                	beqz	a0,80000620 <printf+0x9a>
        consputc(*s);
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	b88080e7          	jalr	-1144(ra) # 80000278 <consputc>
      for(; *s; s++)
    800006f8:	0485                	add	s1,s1,1
    800006fa:	0004c503          	lbu	a0,0(s1)
    800006fe:	f96d                	bnez	a0,800006f0 <printf+0x16a>
    80000700:	b705                	j	80000620 <printf+0x9a>
        s = "(null)";
    80000702:	00008497          	auipc	s1,0x8
    80000706:	92648493          	add	s1,s1,-1754 # 80008028 <etext+0x28>
      for(; *s; s++)
    8000070a:	02800513          	li	a0,40
    8000070e:	b7cd                	j	800006f0 <printf+0x16a>
      consputc('%');
    80000710:	8556                	mv	a0,s5
    80000712:	00000097          	auipc	ra,0x0
    80000716:	b66080e7          	jalr	-1178(ra) # 80000278 <consputc>
      break;
    8000071a:	b719                	j	80000620 <printf+0x9a>
      consputc('%');
    8000071c:	8556                	mv	a0,s5
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	b5a080e7          	jalr	-1190(ra) # 80000278 <consputc>
      consputc(c);
    80000726:	8526                	mv	a0,s1
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	b50080e7          	jalr	-1200(ra) # 80000278 <consputc>
      break;
    80000730:	bdc5                	j	80000620 <printf+0x9a>
  if(locking)
    80000732:	020d9163          	bnez	s11,80000754 <printf+0x1ce>
}
    80000736:	70e6                	ld	ra,120(sp)
    80000738:	7446                	ld	s0,112(sp)
    8000073a:	74a6                	ld	s1,104(sp)
    8000073c:	7906                	ld	s2,96(sp)
    8000073e:	69e6                	ld	s3,88(sp)
    80000740:	6a46                	ld	s4,80(sp)
    80000742:	6aa6                	ld	s5,72(sp)
    80000744:	6b06                	ld	s6,64(sp)
    80000746:	7be2                	ld	s7,56(sp)
    80000748:	7c42                	ld	s8,48(sp)
    8000074a:	7ca2                	ld	s9,40(sp)
    8000074c:	7d02                	ld	s10,32(sp)
    8000074e:	6de2                	ld	s11,24(sp)
    80000750:	6129                	add	sp,sp,192
    80000752:	8082                	ret
    release(&pr.lock);
    80000754:	00010517          	auipc	a0,0x10
    80000758:	4e450513          	add	a0,a0,1252 # 80010c38 <pr>
    8000075c:	00000097          	auipc	ra,0x0
    80000760:	628080e7          	jalr	1576(ra) # 80000d84 <release>
}
    80000764:	bfc9                	j	80000736 <printf+0x1b0>

0000000080000766 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000766:	1101                	add	sp,sp,-32
    80000768:	ec06                	sd	ra,24(sp)
    8000076a:	e822                	sd	s0,16(sp)
    8000076c:	e426                	sd	s1,8(sp)
    8000076e:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    80000770:	00010497          	auipc	s1,0x10
    80000774:	4c848493          	add	s1,s1,1224 # 80010c38 <pr>
    80000778:	00008597          	auipc	a1,0x8
    8000077c:	8c858593          	add	a1,a1,-1848 # 80008040 <etext+0x40>
    80000780:	8526                	mv	a0,s1
    80000782:	00000097          	auipc	ra,0x0
    80000786:	4be080e7          	jalr	1214(ra) # 80000c40 <initlock>
  pr.locking = 1;
    8000078a:	4785                	li	a5,1
    8000078c:	cc9c                	sw	a5,24(s1)
}
    8000078e:	60e2                	ld	ra,24(sp)
    80000790:	6442                	ld	s0,16(sp)
    80000792:	64a2                	ld	s1,8(sp)
    80000794:	6105                	add	sp,sp,32
    80000796:	8082                	ret

0000000080000798 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000798:	1141                	add	sp,sp,-16
    8000079a:	e406                	sd	ra,8(sp)
    8000079c:	e022                	sd	s0,0(sp)
    8000079e:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a0:	100007b7          	lui	a5,0x10000
    800007a4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007a8:	f8000713          	li	a4,-128
    800007ac:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b0:	470d                	li	a4,3
    800007b2:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007b6:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007ba:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007be:	469d                	li	a3,7
    800007c0:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c4:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007c8:	00008597          	auipc	a1,0x8
    800007cc:	88058593          	add	a1,a1,-1920 # 80008048 <etext+0x48>
    800007d0:	00010517          	auipc	a0,0x10
    800007d4:	48850513          	add	a0,a0,1160 # 80010c58 <uart_tx_lock>
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	468080e7          	jalr	1128(ra) # 80000c40 <initlock>
}
    800007e0:	60a2                	ld	ra,8(sp)
    800007e2:	6402                	ld	s0,0(sp)
    800007e4:	0141                	add	sp,sp,16
    800007e6:	8082                	ret

00000000800007e8 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007e8:	1101                	add	sp,sp,-32
    800007ea:	ec06                	sd	ra,24(sp)
    800007ec:	e822                	sd	s0,16(sp)
    800007ee:	e426                	sd	s1,8(sp)
    800007f0:	1000                	add	s0,sp,32
    800007f2:	84aa                	mv	s1,a0
  push_off();
    800007f4:	00000097          	auipc	ra,0x0
    800007f8:	490080e7          	jalr	1168(ra) # 80000c84 <push_off>

  if(panicked){
    800007fc:	00008797          	auipc	a5,0x8
    80000800:	2147a783          	lw	a5,532(a5) # 80008a10 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000804:	10000737          	lui	a4,0x10000
  if(panicked){
    80000808:	c391                	beqz	a5,8000080c <uartputc_sync+0x24>
    for(;;)
    8000080a:	a001                	j	8000080a <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000810:	0207f793          	and	a5,a5,32
    80000814:	dfe5                	beqz	a5,8000080c <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000816:	0ff4f513          	zext.b	a0,s1
    8000081a:	100007b7          	lui	a5,0x10000
    8000081e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000822:	00000097          	auipc	ra,0x0
    80000826:	502080e7          	jalr	1282(ra) # 80000d24 <pop_off>
}
    8000082a:	60e2                	ld	ra,24(sp)
    8000082c:	6442                	ld	s0,16(sp)
    8000082e:	64a2                	ld	s1,8(sp)
    80000830:	6105                	add	sp,sp,32
    80000832:	8082                	ret

0000000080000834 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000834:	00008797          	auipc	a5,0x8
    80000838:	1e47b783          	ld	a5,484(a5) # 80008a18 <uart_tx_r>
    8000083c:	00008717          	auipc	a4,0x8
    80000840:	1e473703          	ld	a4,484(a4) # 80008a20 <uart_tx_w>
    80000844:	06f70a63          	beq	a4,a5,800008b8 <uartstart+0x84>
{
    80000848:	7139                	add	sp,sp,-64
    8000084a:	fc06                	sd	ra,56(sp)
    8000084c:	f822                	sd	s0,48(sp)
    8000084e:	f426                	sd	s1,40(sp)
    80000850:	f04a                	sd	s2,32(sp)
    80000852:	ec4e                	sd	s3,24(sp)
    80000854:	e852                	sd	s4,16(sp)
    80000856:	e456                	sd	s5,8(sp)
    80000858:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000085a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000085e:	00010a17          	auipc	s4,0x10
    80000862:	3faa0a13          	add	s4,s4,1018 # 80010c58 <uart_tx_lock>
    uart_tx_r += 1;
    80000866:	00008497          	auipc	s1,0x8
    8000086a:	1b248493          	add	s1,s1,434 # 80008a18 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000086e:	00008997          	auipc	s3,0x8
    80000872:	1b298993          	add	s3,s3,434 # 80008a20 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000876:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087a:	02077713          	and	a4,a4,32
    8000087e:	c705                	beqz	a4,800008a6 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000880:	01f7f713          	and	a4,a5,31
    80000884:	9752                	add	a4,a4,s4
    80000886:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000088a:	0785                	add	a5,a5,1
    8000088c:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000088e:	8526                	mv	a0,s1
    80000890:	00002097          	auipc	ra,0x2
    80000894:	c9c080e7          	jalr	-868(ra) # 8000252c <wakeup>
    
    WriteReg(THR, c);
    80000898:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000089c:	609c                	ld	a5,0(s1)
    8000089e:	0009b703          	ld	a4,0(s3)
    800008a2:	fcf71ae3          	bne	a4,a5,80000876 <uartstart+0x42>
  }
}
    800008a6:	70e2                	ld	ra,56(sp)
    800008a8:	7442                	ld	s0,48(sp)
    800008aa:	74a2                	ld	s1,40(sp)
    800008ac:	7902                	ld	s2,32(sp)
    800008ae:	69e2                	ld	s3,24(sp)
    800008b0:	6a42                	ld	s4,16(sp)
    800008b2:	6aa2                	ld	s5,8(sp)
    800008b4:	6121                	add	sp,sp,64
    800008b6:	8082                	ret
    800008b8:	8082                	ret

00000000800008ba <uartputc>:
{
    800008ba:	7179                	add	sp,sp,-48
    800008bc:	f406                	sd	ra,40(sp)
    800008be:	f022                	sd	s0,32(sp)
    800008c0:	ec26                	sd	s1,24(sp)
    800008c2:	e84a                	sd	s2,16(sp)
    800008c4:	e44e                	sd	s3,8(sp)
    800008c6:	e052                	sd	s4,0(sp)
    800008c8:	1800                	add	s0,sp,48
    800008ca:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008cc:	00010517          	auipc	a0,0x10
    800008d0:	38c50513          	add	a0,a0,908 # 80010c58 <uart_tx_lock>
    800008d4:	00000097          	auipc	ra,0x0
    800008d8:	3fc080e7          	jalr	1020(ra) # 80000cd0 <acquire>
  if(panicked){
    800008dc:	00008797          	auipc	a5,0x8
    800008e0:	1347a783          	lw	a5,308(a5) # 80008a10 <panicked>
    800008e4:	e7c9                	bnez	a5,8000096e <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008e6:	00008717          	auipc	a4,0x8
    800008ea:	13a73703          	ld	a4,314(a4) # 80008a20 <uart_tx_w>
    800008ee:	00008797          	auipc	a5,0x8
    800008f2:	12a7b783          	ld	a5,298(a5) # 80008a18 <uart_tx_r>
    800008f6:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fa:	00010997          	auipc	s3,0x10
    800008fe:	35e98993          	add	s3,s3,862 # 80010c58 <uart_tx_lock>
    80000902:	00008497          	auipc	s1,0x8
    80000906:	11648493          	add	s1,s1,278 # 80008a18 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090a:	00008917          	auipc	s2,0x8
    8000090e:	11690913          	add	s2,s2,278 # 80008a20 <uart_tx_w>
    80000912:	00e79f63          	bne	a5,a4,80000930 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000916:	85ce                	mv	a1,s3
    80000918:	8526                	mv	a0,s1
    8000091a:	00002097          	auipc	ra,0x2
    8000091e:	de0080e7          	jalr	-544(ra) # 800026fa <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000922:	00093703          	ld	a4,0(s2)
    80000926:	609c                	ld	a5,0(s1)
    80000928:	02078793          	add	a5,a5,32
    8000092c:	fee785e3          	beq	a5,a4,80000916 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000930:	00010497          	auipc	s1,0x10
    80000934:	32848493          	add	s1,s1,808 # 80010c58 <uart_tx_lock>
    80000938:	01f77793          	and	a5,a4,31
    8000093c:	97a6                	add	a5,a5,s1
    8000093e:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000942:	0705                	add	a4,a4,1
    80000944:	00008797          	auipc	a5,0x8
    80000948:	0ce7be23          	sd	a4,220(a5) # 80008a20 <uart_tx_w>
  uartstart();
    8000094c:	00000097          	auipc	ra,0x0
    80000950:	ee8080e7          	jalr	-280(ra) # 80000834 <uartstart>
  release(&uart_tx_lock);
    80000954:	8526                	mv	a0,s1
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	42e080e7          	jalr	1070(ra) # 80000d84 <release>
}
    8000095e:	70a2                	ld	ra,40(sp)
    80000960:	7402                	ld	s0,32(sp)
    80000962:	64e2                	ld	s1,24(sp)
    80000964:	6942                	ld	s2,16(sp)
    80000966:	69a2                	ld	s3,8(sp)
    80000968:	6a02                	ld	s4,0(sp)
    8000096a:	6145                	add	sp,sp,48
    8000096c:	8082                	ret
    for(;;)
    8000096e:	a001                	j	8000096e <uartputc+0xb4>

0000000080000970 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000970:	1141                	add	sp,sp,-16
    80000972:	e422                	sd	s0,8(sp)
    80000974:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000976:	100007b7          	lui	a5,0x10000
    8000097a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000097e:	8b85                	and	a5,a5,1
    80000980:	cb81                	beqz	a5,80000990 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80000982:	100007b7          	lui	a5,0x10000
    80000986:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000098a:	6422                	ld	s0,8(sp)
    8000098c:	0141                	add	sp,sp,16
    8000098e:	8082                	ret
    return -1;
    80000990:	557d                	li	a0,-1
    80000992:	bfe5                	j	8000098a <uartgetc+0x1a>

0000000080000994 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000994:	1101                	add	sp,sp,-32
    80000996:	ec06                	sd	ra,24(sp)
    80000998:	e822                	sd	s0,16(sp)
    8000099a:	e426                	sd	s1,8(sp)
    8000099c:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000099e:	54fd                	li	s1,-1
    800009a0:	a029                	j	800009aa <uartintr+0x16>
      break;
    consoleintr(c);
    800009a2:	00000097          	auipc	ra,0x0
    800009a6:	918080e7          	jalr	-1768(ra) # 800002ba <consoleintr>
    int c = uartgetc();
    800009aa:	00000097          	auipc	ra,0x0
    800009ae:	fc6080e7          	jalr	-58(ra) # 80000970 <uartgetc>
    if(c == -1)
    800009b2:	fe9518e3          	bne	a0,s1,800009a2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009b6:	00010497          	auipc	s1,0x10
    800009ba:	2a248493          	add	s1,s1,674 # 80010c58 <uart_tx_lock>
    800009be:	8526                	mv	a0,s1
    800009c0:	00000097          	auipc	ra,0x0
    800009c4:	310080e7          	jalr	784(ra) # 80000cd0 <acquire>
  uartstart();
    800009c8:	00000097          	auipc	ra,0x0
    800009cc:	e6c080e7          	jalr	-404(ra) # 80000834 <uartstart>
  release(&uart_tx_lock);
    800009d0:	8526                	mv	a0,s1
    800009d2:	00000097          	auipc	ra,0x0
    800009d6:	3b2080e7          	jalr	946(ra) # 80000d84 <release>
}
    800009da:	60e2                	ld	ra,24(sp)
    800009dc:	6442                	ld	s0,16(sp)
    800009de:	64a2                	ld	s1,8(sp)
    800009e0:	6105                	add	sp,sp,32
    800009e2:	8082                	ret

00000000800009e4 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009e4:	7179                	add	sp,sp,-48
    800009e6:	f406                	sd	ra,40(sp)
    800009e8:	f022                	sd	s0,32(sp)
    800009ea:	ec26                	sd	s1,24(sp)
    800009ec:	e84a                	sd	s2,16(sp)
    800009ee:	e44e                	sd	s3,8(sp)
    800009f0:	1800                	add	s0,sp,48
    800009f2:	84aa                	mv	s1,a0
  // if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
  //   panic("kfree");

  // COW
  int flg = 0;
  acquire(&nump_using_lock);
    800009f4:	00010517          	auipc	a0,0x10
    800009f8:	29c50513          	add	a0,a0,668 # 80010c90 <nump_using_lock>
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	2d4080e7          	jalr	724(ra) # 80000cd0 <acquire>
  int idx = (uint64)pa/PGSIZE;
    80000a04:	00c4d793          	srl	a5,s1,0xc
    80000a08:	2781                	sext.w	a5,a5
  nump_using[idx] = nump_using[idx] - 1;  // decrement the count of number of processes using this page 
    80000a0a:	078a                	sll	a5,a5,0x2
    80000a0c:	00010717          	auipc	a4,0x10
    80000a10:	2bc70713          	add	a4,a4,700 # 80010cc8 <nump_using>
    80000a14:	97ba                	add	a5,a5,a4
    80000a16:	4398                	lw	a4,0(a5)
    80000a18:	377d                	addw	a4,a4,-1
    80000a1a:	0007091b          	sext.w	s2,a4
    80000a1e:	c398                	sw	a4,0(a5)
  if(nump_using[idx] >= 1)
    flg = 1;
  if(nump_using[idx] < 0)
    80000a20:	06094163          	bltz	s2,80000a82 <kfree+0x9e>
    printf("kfree: nump_using < 0");
  release(&nump_using_lock);
    80000a24:	00010517          	auipc	a0,0x10
    80000a28:	26c50513          	add	a0,a0,620 # 80010c90 <nump_using_lock>
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	358080e7          	jalr	856(ra) # 80000d84 <release>
  if(flg == 1)
    80000a34:	05204063          	bgtz	s2,80000a74 <kfree+0x90>
    return;

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a38:	6605                	lui	a2,0x1
    80000a3a:	4585                	li	a1,1
    80000a3c:	8526                	mv	a0,s1
    80000a3e:	00000097          	auipc	ra,0x0
    80000a42:	38e080e7          	jalr	910(ra) # 80000dcc <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a46:	00010997          	auipc	s3,0x10
    80000a4a:	24a98993          	add	s3,s3,586 # 80010c90 <nump_using_lock>
    80000a4e:	00010917          	auipc	s2,0x10
    80000a52:	25a90913          	add	s2,s2,602 # 80010ca8 <kmem>
    80000a56:	854a                	mv	a0,s2
    80000a58:	00000097          	auipc	ra,0x0
    80000a5c:	278080e7          	jalr	632(ra) # 80000cd0 <acquire>
  r->next = kmem.freelist;
    80000a60:	0309b783          	ld	a5,48(s3)
    80000a64:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a66:	0299b823          	sd	s1,48(s3)
  release(&kmem.lock);
    80000a6a:	854a                	mv	a0,s2
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	318080e7          	jalr	792(ra) # 80000d84 <release>
}
    80000a74:	70a2                	ld	ra,40(sp)
    80000a76:	7402                	ld	s0,32(sp)
    80000a78:	64e2                	ld	s1,24(sp)
    80000a7a:	6942                	ld	s2,16(sp)
    80000a7c:	69a2                	ld	s3,8(sp)
    80000a7e:	6145                	add	sp,sp,48
    80000a80:	8082                	ret
    printf("kfree: nump_using < 0");
    80000a82:	00007517          	auipc	a0,0x7
    80000a86:	5ce50513          	add	a0,a0,1486 # 80008050 <etext+0x50>
    80000a8a:	00000097          	auipc	ra,0x0
    80000a8e:	afc080e7          	jalr	-1284(ra) # 80000586 <printf>
  release(&nump_using_lock);
    80000a92:	00010517          	auipc	a0,0x10
    80000a96:	1fe50513          	add	a0,a0,510 # 80010c90 <nump_using_lock>
    80000a9a:	00000097          	auipc	ra,0x0
    80000a9e:	2ea080e7          	jalr	746(ra) # 80000d84 <release>
  if(flg == 1)
    80000aa2:	bf59                	j	80000a38 <kfree+0x54>

0000000080000aa4 <freerange>:
{
    80000aa4:	7179                	add	sp,sp,-48
    80000aa6:	f406                	sd	ra,40(sp)
    80000aa8:	f022                	sd	s0,32(sp)
    80000aaa:	ec26                	sd	s1,24(sp)
    80000aac:	e84a                	sd	s2,16(sp)
    80000aae:	e44e                	sd	s3,8(sp)
    80000ab0:	e052                	sd	s4,0(sp)
    80000ab2:	1800                	add	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ab4:	6785                	lui	a5,0x1
    80000ab6:	fff78713          	add	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000aba:	00e504b3          	add	s1,a0,a4
    80000abe:	777d                	lui	a4,0xfffff
    80000ac0:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac2:	94be                	add	s1,s1,a5
    80000ac4:	0095ee63          	bltu	a1,s1,80000ae0 <freerange+0x3c>
    80000ac8:	892e                	mv	s2,a1
    kfree(p);
    80000aca:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000acc:	6985                	lui	s3,0x1
    kfree(p);
    80000ace:	01448533          	add	a0,s1,s4
    80000ad2:	00000097          	auipc	ra,0x0
    80000ad6:	f12080e7          	jalr	-238(ra) # 800009e4 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ada:	94ce                	add	s1,s1,s3
    80000adc:	fe9979e3          	bgeu	s2,s1,80000ace <freerange+0x2a>
}
    80000ae0:	70a2                	ld	ra,40(sp)
    80000ae2:	7402                	ld	s0,32(sp)
    80000ae4:	64e2                	ld	s1,24(sp)
    80000ae6:	6942                	ld	s2,16(sp)
    80000ae8:	69a2                	ld	s3,8(sp)
    80000aea:	6a02                	ld	s4,0(sp)
    80000aec:	6145                	add	sp,sp,48
    80000aee:	8082                	ret

0000000080000af0 <kinit>:
{
    80000af0:	1101                	add	sp,sp,-32
    80000af2:	ec06                	sd	ra,24(sp)
    80000af4:	e822                	sd	s0,16(sp)
    80000af6:	e426                	sd	s1,8(sp)
    80000af8:	1000                	add	s0,sp,32
  initlock(&kmem.lock, "kmem");
    80000afa:	00010497          	auipc	s1,0x10
    80000afe:	19648493          	add	s1,s1,406 # 80010c90 <nump_using_lock>
    80000b02:	00007597          	auipc	a1,0x7
    80000b06:	56658593          	add	a1,a1,1382 # 80008068 <etext+0x68>
    80000b0a:	00010517          	auipc	a0,0x10
    80000b0e:	19e50513          	add	a0,a0,414 # 80010ca8 <kmem>
    80000b12:	00000097          	auipc	ra,0x0
    80000b16:	12e080e7          	jalr	302(ra) # 80000c40 <initlock>
  initlock(&nump_using_lock,"nump_using lock");
    80000b1a:	00007597          	auipc	a1,0x7
    80000b1e:	55658593          	add	a1,a1,1366 # 80008070 <etext+0x70>
    80000b22:	8526                	mv	a0,s1
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	11c080e7          	jalr	284(ra) # 80000c40 <initlock>
  acquire(&nump_using_lock);
    80000b2c:	8526                	mv	a0,s1
    80000b2e:	00000097          	auipc	ra,0x0
    80000b32:	1a2080e7          	jalr	418(ra) # 80000cd0 <acquire>
  while(sz > i)
    80000b36:	00010797          	auipc	a5,0x10
    80000b3a:	19278793          	add	a5,a5,402 # 80010cc8 <nump_using>
    80000b3e:	00230697          	auipc	a3,0x230
    80000b42:	18a68693          	add	a3,a3,394 # 80230cc8 <cpus>
    nump_using[i] = 1;
    80000b46:	4705                	li	a4,1
    80000b48:	c398                	sw	a4,0(a5)
  while(sz > i)
    80000b4a:	0791                	add	a5,a5,4
    80000b4c:	fed79ee3          	bne	a5,a3,80000b48 <kinit+0x58>
  release(&nump_using_lock);
    80000b50:	00010517          	auipc	a0,0x10
    80000b54:	14050513          	add	a0,a0,320 # 80010c90 <nump_using_lock>
    80000b58:	00000097          	auipc	ra,0x0
    80000b5c:	22c080e7          	jalr	556(ra) # 80000d84 <release>
  freerange(end, (void*)PHYSTOP);
    80000b60:	45c5                	li	a1,17
    80000b62:	05ee                	sll	a1,a1,0x1b
    80000b64:	00243517          	auipc	a0,0x243
    80000b68:	f7450513          	add	a0,a0,-140 # 80243ad8 <end>
    80000b6c:	00000097          	auipc	ra,0x0
    80000b70:	f38080e7          	jalr	-200(ra) # 80000aa4 <freerange>
}
    80000b74:	60e2                	ld	ra,24(sp)
    80000b76:	6442                	ld	s0,16(sp)
    80000b78:	64a2                	ld	s1,8(sp)
    80000b7a:	6105                	add	sp,sp,32
    80000b7c:	8082                	ret

0000000080000b7e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b7e:	7179                	add	sp,sp,-48
    80000b80:	f406                	sd	ra,40(sp)
    80000b82:	f022                	sd	s0,32(sp)
    80000b84:	ec26                	sd	s1,24(sp)
    80000b86:	e84a                	sd	s2,16(sp)
    80000b88:	e44e                	sd	s3,8(sp)
    80000b8a:	1800                	add	s0,sp,48
  struct run *r;

  acquire(&kmem.lock);
    80000b8c:	00010517          	auipc	a0,0x10
    80000b90:	11c50513          	add	a0,a0,284 # 80010ca8 <kmem>
    80000b94:	00000097          	auipc	ra,0x0
    80000b98:	13c080e7          	jalr	316(ra) # 80000cd0 <acquire>
  r = kmem.freelist;
    80000b9c:	00010497          	auipc	s1,0x10
    80000ba0:	1244b483          	ld	s1,292(s1) # 80010cc0 <kmem+0x18>
  if(r)
    80000ba4:	c4c9                	beqz	s1,80000c2e <kalloc+0xb0>
    kmem.freelist = r->next;
    80000ba6:	609c                	ld	a5,0(s1)
    80000ba8:	00010997          	auipc	s3,0x10
    80000bac:	0e898993          	add	s3,s3,232 # 80010c90 <nump_using_lock>
    80000bb0:	02f9b823          	sd	a5,48(s3)
  release(&kmem.lock);
    80000bb4:	00010517          	auipc	a0,0x10
    80000bb8:	0f450513          	add	a0,a0,244 # 80010ca8 <kmem>
    80000bbc:	00000097          	auipc	ra,0x0
    80000bc0:	1c8080e7          	jalr	456(ra) # 80000d84 <release>

  if(r)
  {
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000bc4:	6605                	lui	a2,0x1
    80000bc6:	4595                	li	a1,5
    80000bc8:	8526                	mv	a0,s1
    80000bca:	00000097          	auipc	ra,0x0
    80000bce:	202080e7          	jalr	514(ra) # 80000dcc <memset>
    // COW
    int idxx = (uint64)r/PGSIZE;
    80000bd2:	00c4d913          	srl	s2,s1,0xc
    80000bd6:	2901                	sext.w	s2,s2
    acquire(&nump_using_lock);
    80000bd8:	854e                	mv	a0,s3
    80000bda:	00000097          	auipc	ra,0x0
    80000bde:	0f6080e7          	jalr	246(ra) # 80000cd0 <acquire>
    nump_using[idxx] = nump_using[idxx] + 1;  // mark that this page is being used by one more process
    80000be2:	090a                	sll	s2,s2,0x2
    80000be4:	00010797          	auipc	a5,0x10
    80000be8:	0e478793          	add	a5,a5,228 # 80010cc8 <nump_using>
    80000bec:	97ca                	add	a5,a5,s2
    80000bee:	4398                	lw	a4,0(a5)
    80000bf0:	2705                	addw	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fdbb529>
    80000bf2:	0007069b          	sext.w	a3,a4
    80000bf6:	c398                	sw	a4,0(a5)
    if(nump_using[idxx] < 1)
    80000bf8:	02d05263          	blez	a3,80000c1c <kalloc+0x9e>
      printf("kalloc: nump_using < 1");
    release(&nump_using_lock);
    80000bfc:	00010517          	auipc	a0,0x10
    80000c00:	09450513          	add	a0,a0,148 # 80010c90 <nump_using_lock>
    80000c04:	00000097          	auipc	ra,0x0
    80000c08:	180080e7          	jalr	384(ra) # 80000d84 <release>
  }
  return (void*)r;
}
    80000c0c:	8526                	mv	a0,s1
    80000c0e:	70a2                	ld	ra,40(sp)
    80000c10:	7402                	ld	s0,32(sp)
    80000c12:	64e2                	ld	s1,24(sp)
    80000c14:	6942                	ld	s2,16(sp)
    80000c16:	69a2                	ld	s3,8(sp)
    80000c18:	6145                	add	sp,sp,48
    80000c1a:	8082                	ret
      printf("kalloc: nump_using < 1");
    80000c1c:	00007517          	auipc	a0,0x7
    80000c20:	46450513          	add	a0,a0,1124 # 80008080 <etext+0x80>
    80000c24:	00000097          	auipc	ra,0x0
    80000c28:	962080e7          	jalr	-1694(ra) # 80000586 <printf>
    80000c2c:	bfc1                	j	80000bfc <kalloc+0x7e>
  release(&kmem.lock);
    80000c2e:	00010517          	auipc	a0,0x10
    80000c32:	07a50513          	add	a0,a0,122 # 80010ca8 <kmem>
    80000c36:	00000097          	auipc	ra,0x0
    80000c3a:	14e080e7          	jalr	334(ra) # 80000d84 <release>
  if(r)
    80000c3e:	b7f9                	j	80000c0c <kalloc+0x8e>

0000000080000c40 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000c40:	1141                	add	sp,sp,-16
    80000c42:	e422                	sd	s0,8(sp)
    80000c44:	0800                	add	s0,sp,16
  lk->name = name;
    80000c46:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000c48:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000c4c:	00053823          	sd	zero,16(a0)
}
    80000c50:	6422                	ld	s0,8(sp)
    80000c52:	0141                	add	sp,sp,16
    80000c54:	8082                	ret

0000000080000c56 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000c56:	411c                	lw	a5,0(a0)
    80000c58:	e399                	bnez	a5,80000c5e <holding+0x8>
    80000c5a:	4501                	li	a0,0
  return r;
}
    80000c5c:	8082                	ret
{
    80000c5e:	1101                	add	sp,sp,-32
    80000c60:	ec06                	sd	ra,24(sp)
    80000c62:	e822                	sd	s0,16(sp)
    80000c64:	e426                	sd	s1,8(sp)
    80000c66:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000c68:	6904                	ld	s1,16(a0)
    80000c6a:	00001097          	auipc	ra,0x1
    80000c6e:	12a080e7          	jalr	298(ra) # 80001d94 <mycpu>
    80000c72:	40a48533          	sub	a0,s1,a0
    80000c76:	00153513          	seqz	a0,a0
}
    80000c7a:	60e2                	ld	ra,24(sp)
    80000c7c:	6442                	ld	s0,16(sp)
    80000c7e:	64a2                	ld	s1,8(sp)
    80000c80:	6105                	add	sp,sp,32
    80000c82:	8082                	ret

0000000080000c84 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000c84:	1101                	add	sp,sp,-32
    80000c86:	ec06                	sd	ra,24(sp)
    80000c88:	e822                	sd	s0,16(sp)
    80000c8a:	e426                	sd	s1,8(sp)
    80000c8c:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c8e:	100024f3          	csrr	s1,sstatus
    80000c92:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000c96:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c98:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c9c:	00001097          	auipc	ra,0x1
    80000ca0:	0f8080e7          	jalr	248(ra) # 80001d94 <mycpu>
    80000ca4:	5d3c                	lw	a5,120(a0)
    80000ca6:	cf89                	beqz	a5,80000cc0 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000ca8:	00001097          	auipc	ra,0x1
    80000cac:	0ec080e7          	jalr	236(ra) # 80001d94 <mycpu>
    80000cb0:	5d3c                	lw	a5,120(a0)
    80000cb2:	2785                	addw	a5,a5,1
    80000cb4:	dd3c                	sw	a5,120(a0)
}
    80000cb6:	60e2                	ld	ra,24(sp)
    80000cb8:	6442                	ld	s0,16(sp)
    80000cba:	64a2                	ld	s1,8(sp)
    80000cbc:	6105                	add	sp,sp,32
    80000cbe:	8082                	ret
    mycpu()->intena = old;
    80000cc0:	00001097          	auipc	ra,0x1
    80000cc4:	0d4080e7          	jalr	212(ra) # 80001d94 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000cc8:	8085                	srl	s1,s1,0x1
    80000cca:	8885                	and	s1,s1,1
    80000ccc:	dd64                	sw	s1,124(a0)
    80000cce:	bfe9                	j	80000ca8 <push_off+0x24>

0000000080000cd0 <acquire>:
{
    80000cd0:	1101                	add	sp,sp,-32
    80000cd2:	ec06                	sd	ra,24(sp)
    80000cd4:	e822                	sd	s0,16(sp)
    80000cd6:	e426                	sd	s1,8(sp)
    80000cd8:	1000                	add	s0,sp,32
    80000cda:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000cdc:	00000097          	auipc	ra,0x0
    80000ce0:	fa8080e7          	jalr	-88(ra) # 80000c84 <push_off>
  if(holding(lk))
    80000ce4:	8526                	mv	a0,s1
    80000ce6:	00000097          	auipc	ra,0x0
    80000cea:	f70080e7          	jalr	-144(ra) # 80000c56 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000cee:	4705                	li	a4,1
  if(holding(lk))
    80000cf0:	e115                	bnez	a0,80000d14 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000cf2:	87ba                	mv	a5,a4
    80000cf4:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000cf8:	2781                	sext.w	a5,a5
    80000cfa:	ffe5                	bnez	a5,80000cf2 <acquire+0x22>
  __sync_synchronize();
    80000cfc:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000d00:	00001097          	auipc	ra,0x1
    80000d04:	094080e7          	jalr	148(ra) # 80001d94 <mycpu>
    80000d08:	e888                	sd	a0,16(s1)
}
    80000d0a:	60e2                	ld	ra,24(sp)
    80000d0c:	6442                	ld	s0,16(sp)
    80000d0e:	64a2                	ld	s1,8(sp)
    80000d10:	6105                	add	sp,sp,32
    80000d12:	8082                	ret
    panic("acquire");
    80000d14:	00007517          	auipc	a0,0x7
    80000d18:	38450513          	add	a0,a0,900 # 80008098 <etext+0x98>
    80000d1c:	00000097          	auipc	ra,0x0
    80000d20:	820080e7          	jalr	-2016(ra) # 8000053c <panic>

0000000080000d24 <pop_off>:

void
pop_off(void)
{
    80000d24:	1141                	add	sp,sp,-16
    80000d26:	e406                	sd	ra,8(sp)
    80000d28:	e022                	sd	s0,0(sp)
    80000d2a:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    80000d2c:	00001097          	auipc	ra,0x1
    80000d30:	068080e7          	jalr	104(ra) # 80001d94 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d34:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000d38:	8b89                	and	a5,a5,2
  if(intr_get())
    80000d3a:	e78d                	bnez	a5,80000d64 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000d3c:	5d3c                	lw	a5,120(a0)
    80000d3e:	02f05b63          	blez	a5,80000d74 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000d42:	37fd                	addw	a5,a5,-1
    80000d44:	0007871b          	sext.w	a4,a5
    80000d48:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000d4a:	eb09                	bnez	a4,80000d5c <pop_off+0x38>
    80000d4c:	5d7c                	lw	a5,124(a0)
    80000d4e:	c799                	beqz	a5,80000d5c <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d50:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000d54:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000d58:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000d5c:	60a2                	ld	ra,8(sp)
    80000d5e:	6402                	ld	s0,0(sp)
    80000d60:	0141                	add	sp,sp,16
    80000d62:	8082                	ret
    panic("pop_off - interruptible");
    80000d64:	00007517          	auipc	a0,0x7
    80000d68:	33c50513          	add	a0,a0,828 # 800080a0 <etext+0xa0>
    80000d6c:	fffff097          	auipc	ra,0xfffff
    80000d70:	7d0080e7          	jalr	2000(ra) # 8000053c <panic>
    panic("pop_off");
    80000d74:	00007517          	auipc	a0,0x7
    80000d78:	34450513          	add	a0,a0,836 # 800080b8 <etext+0xb8>
    80000d7c:	fffff097          	auipc	ra,0xfffff
    80000d80:	7c0080e7          	jalr	1984(ra) # 8000053c <panic>

0000000080000d84 <release>:
{
    80000d84:	1101                	add	sp,sp,-32
    80000d86:	ec06                	sd	ra,24(sp)
    80000d88:	e822                	sd	s0,16(sp)
    80000d8a:	e426                	sd	s1,8(sp)
    80000d8c:	1000                	add	s0,sp,32
    80000d8e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000d90:	00000097          	auipc	ra,0x0
    80000d94:	ec6080e7          	jalr	-314(ra) # 80000c56 <holding>
    80000d98:	c115                	beqz	a0,80000dbc <release+0x38>
  lk->cpu = 0;
    80000d9a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d9e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000da2:	0f50000f          	fence	iorw,ow
    80000da6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000daa:	00000097          	auipc	ra,0x0
    80000dae:	f7a080e7          	jalr	-134(ra) # 80000d24 <pop_off>
}
    80000db2:	60e2                	ld	ra,24(sp)
    80000db4:	6442                	ld	s0,16(sp)
    80000db6:	64a2                	ld	s1,8(sp)
    80000db8:	6105                	add	sp,sp,32
    80000dba:	8082                	ret
    panic("release");
    80000dbc:	00007517          	auipc	a0,0x7
    80000dc0:	30450513          	add	a0,a0,772 # 800080c0 <etext+0xc0>
    80000dc4:	fffff097          	auipc	ra,0xfffff
    80000dc8:	778080e7          	jalr	1912(ra) # 8000053c <panic>

0000000080000dcc <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000dcc:	1141                	add	sp,sp,-16
    80000dce:	e422                	sd	s0,8(sp)
    80000dd0:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000dd2:	ca19                	beqz	a2,80000de8 <memset+0x1c>
    80000dd4:	87aa                	mv	a5,a0
    80000dd6:	1602                	sll	a2,a2,0x20
    80000dd8:	9201                	srl	a2,a2,0x20
    80000dda:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000dde:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000de2:	0785                	add	a5,a5,1
    80000de4:	fee79de3          	bne	a5,a4,80000dde <memset+0x12>
  }
  return dst;
}
    80000de8:	6422                	ld	s0,8(sp)
    80000dea:	0141                	add	sp,sp,16
    80000dec:	8082                	ret

0000000080000dee <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000dee:	1141                	add	sp,sp,-16
    80000df0:	e422                	sd	s0,8(sp)
    80000df2:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000df4:	ca05                	beqz	a2,80000e24 <memcmp+0x36>
    80000df6:	fff6069b          	addw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000dfa:	1682                	sll	a3,a3,0x20
    80000dfc:	9281                	srl	a3,a3,0x20
    80000dfe:	0685                	add	a3,a3,1
    80000e00:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000e02:	00054783          	lbu	a5,0(a0)
    80000e06:	0005c703          	lbu	a4,0(a1)
    80000e0a:	00e79863          	bne	a5,a4,80000e1a <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000e0e:	0505                	add	a0,a0,1
    80000e10:	0585                	add	a1,a1,1
  while(n-- > 0){
    80000e12:	fed518e3          	bne	a0,a3,80000e02 <memcmp+0x14>
  }

  return 0;
    80000e16:	4501                	li	a0,0
    80000e18:	a019                	j	80000e1e <memcmp+0x30>
      return *s1 - *s2;
    80000e1a:	40e7853b          	subw	a0,a5,a4
}
    80000e1e:	6422                	ld	s0,8(sp)
    80000e20:	0141                	add	sp,sp,16
    80000e22:	8082                	ret
  return 0;
    80000e24:	4501                	li	a0,0
    80000e26:	bfe5                	j	80000e1e <memcmp+0x30>

0000000080000e28 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000e28:	1141                	add	sp,sp,-16
    80000e2a:	e422                	sd	s0,8(sp)
    80000e2c:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000e2e:	c205                	beqz	a2,80000e4e <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000e30:	02a5e263          	bltu	a1,a0,80000e54 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000e34:	1602                	sll	a2,a2,0x20
    80000e36:	9201                	srl	a2,a2,0x20
    80000e38:	00c587b3          	add	a5,a1,a2
{
    80000e3c:	872a                	mv	a4,a0
      *d++ = *s++;
    80000e3e:	0585                	add	a1,a1,1
    80000e40:	0705                	add	a4,a4,1
    80000e42:	fff5c683          	lbu	a3,-1(a1)
    80000e46:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000e4a:	fef59ae3          	bne	a1,a5,80000e3e <memmove+0x16>

  return dst;
}
    80000e4e:	6422                	ld	s0,8(sp)
    80000e50:	0141                	add	sp,sp,16
    80000e52:	8082                	ret
  if(s < d && s + n > d){
    80000e54:	02061693          	sll	a3,a2,0x20
    80000e58:	9281                	srl	a3,a3,0x20
    80000e5a:	00d58733          	add	a4,a1,a3
    80000e5e:	fce57be3          	bgeu	a0,a4,80000e34 <memmove+0xc>
    d += n;
    80000e62:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000e64:	fff6079b          	addw	a5,a2,-1
    80000e68:	1782                	sll	a5,a5,0x20
    80000e6a:	9381                	srl	a5,a5,0x20
    80000e6c:	fff7c793          	not	a5,a5
    80000e70:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000e72:	177d                	add	a4,a4,-1
    80000e74:	16fd                	add	a3,a3,-1
    80000e76:	00074603          	lbu	a2,0(a4)
    80000e7a:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000e7e:	fee79ae3          	bne	a5,a4,80000e72 <memmove+0x4a>
    80000e82:	b7f1                	j	80000e4e <memmove+0x26>

0000000080000e84 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000e84:	1141                	add	sp,sp,-16
    80000e86:	e406                	sd	ra,8(sp)
    80000e88:	e022                	sd	s0,0(sp)
    80000e8a:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    80000e8c:	00000097          	auipc	ra,0x0
    80000e90:	f9c080e7          	jalr	-100(ra) # 80000e28 <memmove>
}
    80000e94:	60a2                	ld	ra,8(sp)
    80000e96:	6402                	ld	s0,0(sp)
    80000e98:	0141                	add	sp,sp,16
    80000e9a:	8082                	ret

0000000080000e9c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e9c:	1141                	add	sp,sp,-16
    80000e9e:	e422                	sd	s0,8(sp)
    80000ea0:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000ea2:	ce11                	beqz	a2,80000ebe <strncmp+0x22>
    80000ea4:	00054783          	lbu	a5,0(a0)
    80000ea8:	cf89                	beqz	a5,80000ec2 <strncmp+0x26>
    80000eaa:	0005c703          	lbu	a4,0(a1)
    80000eae:	00f71a63          	bne	a4,a5,80000ec2 <strncmp+0x26>
    n--, p++, q++;
    80000eb2:	367d                	addw	a2,a2,-1
    80000eb4:	0505                	add	a0,a0,1
    80000eb6:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000eb8:	f675                	bnez	a2,80000ea4 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000eba:	4501                	li	a0,0
    80000ebc:	a809                	j	80000ece <strncmp+0x32>
    80000ebe:	4501                	li	a0,0
    80000ec0:	a039                	j	80000ece <strncmp+0x32>
  if(n == 0)
    80000ec2:	ca09                	beqz	a2,80000ed4 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000ec4:	00054503          	lbu	a0,0(a0)
    80000ec8:	0005c783          	lbu	a5,0(a1)
    80000ecc:	9d1d                	subw	a0,a0,a5
}
    80000ece:	6422                	ld	s0,8(sp)
    80000ed0:	0141                	add	sp,sp,16
    80000ed2:	8082                	ret
    return 0;
    80000ed4:	4501                	li	a0,0
    80000ed6:	bfe5                	j	80000ece <strncmp+0x32>

0000000080000ed8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000ed8:	1141                	add	sp,sp,-16
    80000eda:	e422                	sd	s0,8(sp)
    80000edc:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000ede:	87aa                	mv	a5,a0
    80000ee0:	86b2                	mv	a3,a2
    80000ee2:	367d                	addw	a2,a2,-1
    80000ee4:	00d05963          	blez	a3,80000ef6 <strncpy+0x1e>
    80000ee8:	0785                	add	a5,a5,1
    80000eea:	0005c703          	lbu	a4,0(a1)
    80000eee:	fee78fa3          	sb	a4,-1(a5)
    80000ef2:	0585                	add	a1,a1,1
    80000ef4:	f775                	bnez	a4,80000ee0 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000ef6:	873e                	mv	a4,a5
    80000ef8:	9fb5                	addw	a5,a5,a3
    80000efa:	37fd                	addw	a5,a5,-1
    80000efc:	00c05963          	blez	a2,80000f0e <strncpy+0x36>
    *s++ = 0;
    80000f00:	0705                	add	a4,a4,1
    80000f02:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000f06:	40e786bb          	subw	a3,a5,a4
    80000f0a:	fed04be3          	bgtz	a3,80000f00 <strncpy+0x28>
  return os;
}
    80000f0e:	6422                	ld	s0,8(sp)
    80000f10:	0141                	add	sp,sp,16
    80000f12:	8082                	ret

0000000080000f14 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000f14:	1141                	add	sp,sp,-16
    80000f16:	e422                	sd	s0,8(sp)
    80000f18:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000f1a:	02c05363          	blez	a2,80000f40 <safestrcpy+0x2c>
    80000f1e:	fff6069b          	addw	a3,a2,-1
    80000f22:	1682                	sll	a3,a3,0x20
    80000f24:	9281                	srl	a3,a3,0x20
    80000f26:	96ae                	add	a3,a3,a1
    80000f28:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000f2a:	00d58963          	beq	a1,a3,80000f3c <safestrcpy+0x28>
    80000f2e:	0585                	add	a1,a1,1
    80000f30:	0785                	add	a5,a5,1
    80000f32:	fff5c703          	lbu	a4,-1(a1)
    80000f36:	fee78fa3          	sb	a4,-1(a5)
    80000f3a:	fb65                	bnez	a4,80000f2a <safestrcpy+0x16>
    ;
  *s = 0;
    80000f3c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000f40:	6422                	ld	s0,8(sp)
    80000f42:	0141                	add	sp,sp,16
    80000f44:	8082                	ret

0000000080000f46 <strlen>:

int
strlen(const char *s)
{
    80000f46:	1141                	add	sp,sp,-16
    80000f48:	e422                	sd	s0,8(sp)
    80000f4a:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000f4c:	00054783          	lbu	a5,0(a0)
    80000f50:	cf91                	beqz	a5,80000f6c <strlen+0x26>
    80000f52:	0505                	add	a0,a0,1
    80000f54:	87aa                	mv	a5,a0
    80000f56:	86be                	mv	a3,a5
    80000f58:	0785                	add	a5,a5,1
    80000f5a:	fff7c703          	lbu	a4,-1(a5)
    80000f5e:	ff65                	bnez	a4,80000f56 <strlen+0x10>
    80000f60:	40a6853b          	subw	a0,a3,a0
    80000f64:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80000f66:	6422                	ld	s0,8(sp)
    80000f68:	0141                	add	sp,sp,16
    80000f6a:	8082                	ret
  for(n = 0; s[n]; n++)
    80000f6c:	4501                	li	a0,0
    80000f6e:	bfe5                	j	80000f66 <strlen+0x20>

0000000080000f70 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000f70:	1141                	add	sp,sp,-16
    80000f72:	e406                	sd	ra,8(sp)
    80000f74:	e022                	sd	s0,0(sp)
    80000f76:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80000f78:	00001097          	auipc	ra,0x1
    80000f7c:	e0c080e7          	jalr	-500(ra) # 80001d84 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f80:	00008717          	auipc	a4,0x8
    80000f84:	aa870713          	add	a4,a4,-1368 # 80008a28 <started>
  if(cpuid() == 0){
    80000f88:	c139                	beqz	a0,80000fce <main+0x5e>
    while(started == 0)
    80000f8a:	431c                	lw	a5,0(a4)
    80000f8c:	2781                	sext.w	a5,a5
    80000f8e:	dff5                	beqz	a5,80000f8a <main+0x1a>
      ;
    __sync_synchronize();
    80000f90:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000f94:	00001097          	auipc	ra,0x1
    80000f98:	df0080e7          	jalr	-528(ra) # 80001d84 <cpuid>
    80000f9c:	85aa                	mv	a1,a0
    80000f9e:	00007517          	auipc	a0,0x7
    80000fa2:	14250513          	add	a0,a0,322 # 800080e0 <etext+0xe0>
    80000fa6:	fffff097          	auipc	ra,0xfffff
    80000faa:	5e0080e7          	jalr	1504(ra) # 80000586 <printf>
    kvminithart();    // turn on paging
    80000fae:	00000097          	auipc	ra,0x0
    80000fb2:	0d8080e7          	jalr	216(ra) # 80001086 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000fb6:	00002097          	auipc	ra,0x2
    80000fba:	d52080e7          	jalr	-686(ra) # 80002d08 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000fbe:	00005097          	auipc	ra,0x5
    80000fc2:	5a2080e7          	jalr	1442(ra) # 80006560 <plicinithart>
  }

  scheduler();        
    80000fc6:	00001097          	auipc	ra,0x1
    80000fca:	42a080e7          	jalr	1066(ra) # 800023f0 <scheduler>
    consoleinit();
    80000fce:	fffff097          	auipc	ra,0xfffff
    80000fd2:	47e080e7          	jalr	1150(ra) # 8000044c <consoleinit>
    printfinit();
    80000fd6:	fffff097          	auipc	ra,0xfffff
    80000fda:	790080e7          	jalr	1936(ra) # 80000766 <printfinit>
    printf("\n");
    80000fde:	00007517          	auipc	a0,0x7
    80000fe2:	04250513          	add	a0,a0,66 # 80008020 <etext+0x20>
    80000fe6:	fffff097          	auipc	ra,0xfffff
    80000fea:	5a0080e7          	jalr	1440(ra) # 80000586 <printf>
    printf("xv6 kernel is booting\n");
    80000fee:	00007517          	auipc	a0,0x7
    80000ff2:	0da50513          	add	a0,a0,218 # 800080c8 <etext+0xc8>
    80000ff6:	fffff097          	auipc	ra,0xfffff
    80000ffa:	590080e7          	jalr	1424(ra) # 80000586 <printf>
    printf("\n");
    80000ffe:	00007517          	auipc	a0,0x7
    80001002:	02250513          	add	a0,a0,34 # 80008020 <etext+0x20>
    80001006:	fffff097          	auipc	ra,0xfffff
    8000100a:	580080e7          	jalr	1408(ra) # 80000586 <printf>
    kinit();         // physical page allocator
    8000100e:	00000097          	auipc	ra,0x0
    80001012:	ae2080e7          	jalr	-1310(ra) # 80000af0 <kinit>
    kvminit();       // create kernel page table
    80001016:	00000097          	auipc	ra,0x0
    8000101a:	326080e7          	jalr	806(ra) # 8000133c <kvminit>
    kvminithart();   // turn on paging
    8000101e:	00000097          	auipc	ra,0x0
    80001022:	068080e7          	jalr	104(ra) # 80001086 <kvminithart>
    procinit();      // process table
    80001026:	00001097          	auipc	ra,0x1
    8000102a:	caa080e7          	jalr	-854(ra) # 80001cd0 <procinit>
    trapinit();      // trap vectors
    8000102e:	00002097          	auipc	ra,0x2
    80001032:	cb2080e7          	jalr	-846(ra) # 80002ce0 <trapinit>
    trapinithart();  // install kernel trap vector
    80001036:	00002097          	auipc	ra,0x2
    8000103a:	cd2080e7          	jalr	-814(ra) # 80002d08 <trapinithart>
    plicinit();      // set up interrupt controller
    8000103e:	00005097          	auipc	ra,0x5
    80001042:	50c080e7          	jalr	1292(ra) # 8000654a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001046:	00005097          	auipc	ra,0x5
    8000104a:	51a080e7          	jalr	1306(ra) # 80006560 <plicinithart>
    binit();         // buffer cache
    8000104e:	00002097          	auipc	ra,0x2
    80001052:	6d8080e7          	jalr	1752(ra) # 80003726 <binit>
    iinit();         // inode table
    80001056:	00003097          	auipc	ra,0x3
    8000105a:	d76080e7          	jalr	-650(ra) # 80003dcc <iinit>
    fileinit();      // file table
    8000105e:	00004097          	auipc	ra,0x4
    80001062:	cec080e7          	jalr	-788(ra) # 80004d4a <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001066:	00005097          	auipc	ra,0x5
    8000106a:	602080e7          	jalr	1538(ra) # 80006668 <virtio_disk_init>
    userinit();      // first user process
    8000106e:	00001097          	auipc	ra,0x1
    80001072:	164080e7          	jalr	356(ra) # 800021d2 <userinit>
    __sync_synchronize();
    80001076:	0ff0000f          	fence
    started = 1;
    8000107a:	4785                	li	a5,1
    8000107c:	00008717          	auipc	a4,0x8
    80001080:	9af72623          	sw	a5,-1620(a4) # 80008a28 <started>
    80001084:	b789                	j	80000fc6 <main+0x56>

0000000080001086 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001086:	1141                	add	sp,sp,-16
    80001088:	e422                	sd	s0,8(sp)
    8000108a:	0800                	add	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000108c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80001090:	00008797          	auipc	a5,0x8
    80001094:	9a07b783          	ld	a5,-1632(a5) # 80008a30 <kernel_pagetable>
    80001098:	83b1                	srl	a5,a5,0xc
    8000109a:	577d                	li	a4,-1
    8000109c:	177e                	sll	a4,a4,0x3f
    8000109e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800010a0:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800010a4:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800010a8:	6422                	ld	s0,8(sp)
    800010aa:	0141                	add	sp,sp,16
    800010ac:	8082                	ret

00000000800010ae <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800010ae:	7139                	add	sp,sp,-64
    800010b0:	fc06                	sd	ra,56(sp)
    800010b2:	f822                	sd	s0,48(sp)
    800010b4:	f426                	sd	s1,40(sp)
    800010b6:	f04a                	sd	s2,32(sp)
    800010b8:	ec4e                	sd	s3,24(sp)
    800010ba:	e852                	sd	s4,16(sp)
    800010bc:	e456                	sd	s5,8(sp)
    800010be:	e05a                	sd	s6,0(sp)
    800010c0:	0080                	add	s0,sp,64
    800010c2:	84aa                	mv	s1,a0
    800010c4:	89ae                	mv	s3,a1
    800010c6:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800010c8:	57fd                	li	a5,-1
    800010ca:	83e9                	srl	a5,a5,0x1a
    800010cc:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800010ce:	4b31                	li	s6,12
  if(va >= MAXVA)
    800010d0:	04b7f263          	bgeu	a5,a1,80001114 <walk+0x66>
    panic("walk");
    800010d4:	00007517          	auipc	a0,0x7
    800010d8:	02450513          	add	a0,a0,36 # 800080f8 <etext+0xf8>
    800010dc:	fffff097          	auipc	ra,0xfffff
    800010e0:	460080e7          	jalr	1120(ra) # 8000053c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800010e4:	060a8663          	beqz	s5,80001150 <walk+0xa2>
    800010e8:	00000097          	auipc	ra,0x0
    800010ec:	a96080e7          	jalr	-1386(ra) # 80000b7e <kalloc>
    800010f0:	84aa                	mv	s1,a0
    800010f2:	c529                	beqz	a0,8000113c <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800010f4:	6605                	lui	a2,0x1
    800010f6:	4581                	li	a1,0
    800010f8:	00000097          	auipc	ra,0x0
    800010fc:	cd4080e7          	jalr	-812(ra) # 80000dcc <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001100:	00c4d793          	srl	a5,s1,0xc
    80001104:	07aa                	sll	a5,a5,0xa
    80001106:	0017e793          	or	a5,a5,1
    8000110a:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000110e:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7fdbb51f>
    80001110:	036a0063          	beq	s4,s6,80001130 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001114:	0149d933          	srl	s2,s3,s4
    80001118:	1ff97913          	and	s2,s2,511
    8000111c:	090e                	sll	s2,s2,0x3
    8000111e:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001120:	00093483          	ld	s1,0(s2)
    80001124:	0014f793          	and	a5,s1,1
    80001128:	dfd5                	beqz	a5,800010e4 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000112a:	80a9                	srl	s1,s1,0xa
    8000112c:	04b2                	sll	s1,s1,0xc
    8000112e:	b7c5                	j	8000110e <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001130:	00c9d513          	srl	a0,s3,0xc
    80001134:	1ff57513          	and	a0,a0,511
    80001138:	050e                	sll	a0,a0,0x3
    8000113a:	9526                	add	a0,a0,s1
}
    8000113c:	70e2                	ld	ra,56(sp)
    8000113e:	7442                	ld	s0,48(sp)
    80001140:	74a2                	ld	s1,40(sp)
    80001142:	7902                	ld	s2,32(sp)
    80001144:	69e2                	ld	s3,24(sp)
    80001146:	6a42                	ld	s4,16(sp)
    80001148:	6aa2                	ld	s5,8(sp)
    8000114a:	6b02                	ld	s6,0(sp)
    8000114c:	6121                	add	sp,sp,64
    8000114e:	8082                	ret
        return 0;
    80001150:	4501                	li	a0,0
    80001152:	b7ed                	j	8000113c <walk+0x8e>

0000000080001154 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001154:	57fd                	li	a5,-1
    80001156:	83e9                	srl	a5,a5,0x1a
    80001158:	00b7f463          	bgeu	a5,a1,80001160 <walkaddr+0xc>
    return 0;
    8000115c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000115e:	8082                	ret
{
    80001160:	1141                	add	sp,sp,-16
    80001162:	e406                	sd	ra,8(sp)
    80001164:	e022                	sd	s0,0(sp)
    80001166:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001168:	4601                	li	a2,0
    8000116a:	00000097          	auipc	ra,0x0
    8000116e:	f44080e7          	jalr	-188(ra) # 800010ae <walk>
  if(pte == 0)
    80001172:	c105                	beqz	a0,80001192 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001174:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001176:	0117f693          	and	a3,a5,17
    8000117a:	4745                	li	a4,17
    return 0;
    8000117c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000117e:	00e68663          	beq	a3,a4,8000118a <walkaddr+0x36>
}
    80001182:	60a2                	ld	ra,8(sp)
    80001184:	6402                	ld	s0,0(sp)
    80001186:	0141                	add	sp,sp,16
    80001188:	8082                	ret
  pa = PTE2PA(*pte);
    8000118a:	83a9                	srl	a5,a5,0xa
    8000118c:	00c79513          	sll	a0,a5,0xc
  return pa;
    80001190:	bfcd                	j	80001182 <walkaddr+0x2e>
    return 0;
    80001192:	4501                	li	a0,0
    80001194:	b7fd                	j	80001182 <walkaddr+0x2e>

0000000080001196 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001196:	715d                	add	sp,sp,-80
    80001198:	e486                	sd	ra,72(sp)
    8000119a:	e0a2                	sd	s0,64(sp)
    8000119c:	fc26                	sd	s1,56(sp)
    8000119e:	f84a                	sd	s2,48(sp)
    800011a0:	f44e                	sd	s3,40(sp)
    800011a2:	f052                	sd	s4,32(sp)
    800011a4:	ec56                	sd	s5,24(sp)
    800011a6:	e85a                	sd	s6,16(sp)
    800011a8:	e45e                	sd	s7,8(sp)
    800011aa:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800011ac:	c639                	beqz	a2,800011fa <mappages+0x64>
    800011ae:	8aaa                	mv	s5,a0
    800011b0:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800011b2:	777d                	lui	a4,0xfffff
    800011b4:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800011b8:	fff58993          	add	s3,a1,-1
    800011bc:	99b2                	add	s3,s3,a2
    800011be:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800011c2:	893e                	mv	s2,a5
    800011c4:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800011c8:	6b85                	lui	s7,0x1
    800011ca:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800011ce:	4605                	li	a2,1
    800011d0:	85ca                	mv	a1,s2
    800011d2:	8556                	mv	a0,s5
    800011d4:	00000097          	auipc	ra,0x0
    800011d8:	eda080e7          	jalr	-294(ra) # 800010ae <walk>
    800011dc:	cd1d                	beqz	a0,8000121a <mappages+0x84>
    if(*pte & PTE_V)
    800011de:	611c                	ld	a5,0(a0)
    800011e0:	8b85                	and	a5,a5,1
    800011e2:	e785                	bnez	a5,8000120a <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800011e4:	80b1                	srl	s1,s1,0xc
    800011e6:	04aa                	sll	s1,s1,0xa
    800011e8:	0164e4b3          	or	s1,s1,s6
    800011ec:	0014e493          	or	s1,s1,1
    800011f0:	e104                	sd	s1,0(a0)
    if(a == last)
    800011f2:	05390063          	beq	s2,s3,80001232 <mappages+0x9c>
    a += PGSIZE;
    800011f6:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800011f8:	bfc9                	j	800011ca <mappages+0x34>
    panic("mappages: size");
    800011fa:	00007517          	auipc	a0,0x7
    800011fe:	f0650513          	add	a0,a0,-250 # 80008100 <etext+0x100>
    80001202:	fffff097          	auipc	ra,0xfffff
    80001206:	33a080e7          	jalr	826(ra) # 8000053c <panic>
      panic("mappages: remap");
    8000120a:	00007517          	auipc	a0,0x7
    8000120e:	f0650513          	add	a0,a0,-250 # 80008110 <etext+0x110>
    80001212:	fffff097          	auipc	ra,0xfffff
    80001216:	32a080e7          	jalr	810(ra) # 8000053c <panic>
      return -1;
    8000121a:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000121c:	60a6                	ld	ra,72(sp)
    8000121e:	6406                	ld	s0,64(sp)
    80001220:	74e2                	ld	s1,56(sp)
    80001222:	7942                	ld	s2,48(sp)
    80001224:	79a2                	ld	s3,40(sp)
    80001226:	7a02                	ld	s4,32(sp)
    80001228:	6ae2                	ld	s5,24(sp)
    8000122a:	6b42                	ld	s6,16(sp)
    8000122c:	6ba2                	ld	s7,8(sp)
    8000122e:	6161                	add	sp,sp,80
    80001230:	8082                	ret
  return 0;
    80001232:	4501                	li	a0,0
    80001234:	b7e5                	j	8000121c <mappages+0x86>

0000000080001236 <kvmmap>:
{
    80001236:	1141                	add	sp,sp,-16
    80001238:	e406                	sd	ra,8(sp)
    8000123a:	e022                	sd	s0,0(sp)
    8000123c:	0800                	add	s0,sp,16
    8000123e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001240:	86b2                	mv	a3,a2
    80001242:	863e                	mv	a2,a5
    80001244:	00000097          	auipc	ra,0x0
    80001248:	f52080e7          	jalr	-174(ra) # 80001196 <mappages>
    8000124c:	e509                	bnez	a0,80001256 <kvmmap+0x20>
}
    8000124e:	60a2                	ld	ra,8(sp)
    80001250:	6402                	ld	s0,0(sp)
    80001252:	0141                	add	sp,sp,16
    80001254:	8082                	ret
    panic("kvmmap");
    80001256:	00007517          	auipc	a0,0x7
    8000125a:	eca50513          	add	a0,a0,-310 # 80008120 <etext+0x120>
    8000125e:	fffff097          	auipc	ra,0xfffff
    80001262:	2de080e7          	jalr	734(ra) # 8000053c <panic>

0000000080001266 <kvmmake>:
{
    80001266:	1101                	add	sp,sp,-32
    80001268:	ec06                	sd	ra,24(sp)
    8000126a:	e822                	sd	s0,16(sp)
    8000126c:	e426                	sd	s1,8(sp)
    8000126e:	e04a                	sd	s2,0(sp)
    80001270:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001272:	00000097          	auipc	ra,0x0
    80001276:	90c080e7          	jalr	-1780(ra) # 80000b7e <kalloc>
    8000127a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000127c:	6605                	lui	a2,0x1
    8000127e:	4581                	li	a1,0
    80001280:	00000097          	auipc	ra,0x0
    80001284:	b4c080e7          	jalr	-1204(ra) # 80000dcc <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001288:	4719                	li	a4,6
    8000128a:	6685                	lui	a3,0x1
    8000128c:	10000637          	lui	a2,0x10000
    80001290:	100005b7          	lui	a1,0x10000
    80001294:	8526                	mv	a0,s1
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	fa0080e7          	jalr	-96(ra) # 80001236 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000129e:	4719                	li	a4,6
    800012a0:	6685                	lui	a3,0x1
    800012a2:	10001637          	lui	a2,0x10001
    800012a6:	100015b7          	lui	a1,0x10001
    800012aa:	8526                	mv	a0,s1
    800012ac:	00000097          	auipc	ra,0x0
    800012b0:	f8a080e7          	jalr	-118(ra) # 80001236 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800012b4:	4719                	li	a4,6
    800012b6:	004006b7          	lui	a3,0x400
    800012ba:	0c000637          	lui	a2,0xc000
    800012be:	0c0005b7          	lui	a1,0xc000
    800012c2:	8526                	mv	a0,s1
    800012c4:	00000097          	auipc	ra,0x0
    800012c8:	f72080e7          	jalr	-142(ra) # 80001236 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800012cc:	00007917          	auipc	s2,0x7
    800012d0:	d3490913          	add	s2,s2,-716 # 80008000 <etext>
    800012d4:	4729                	li	a4,10
    800012d6:	80007697          	auipc	a3,0x80007
    800012da:	d2a68693          	add	a3,a3,-726 # 8000 <_entry-0x7fff8000>
    800012de:	4605                	li	a2,1
    800012e0:	067e                	sll	a2,a2,0x1f
    800012e2:	85b2                	mv	a1,a2
    800012e4:	8526                	mv	a0,s1
    800012e6:	00000097          	auipc	ra,0x0
    800012ea:	f50080e7          	jalr	-176(ra) # 80001236 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800012ee:	4719                	li	a4,6
    800012f0:	46c5                	li	a3,17
    800012f2:	06ee                	sll	a3,a3,0x1b
    800012f4:	412686b3          	sub	a3,a3,s2
    800012f8:	864a                	mv	a2,s2
    800012fa:	85ca                	mv	a1,s2
    800012fc:	8526                	mv	a0,s1
    800012fe:	00000097          	auipc	ra,0x0
    80001302:	f38080e7          	jalr	-200(ra) # 80001236 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001306:	4729                	li	a4,10
    80001308:	6685                	lui	a3,0x1
    8000130a:	00006617          	auipc	a2,0x6
    8000130e:	cf660613          	add	a2,a2,-778 # 80007000 <_trampoline>
    80001312:	040005b7          	lui	a1,0x4000
    80001316:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001318:	05b2                	sll	a1,a1,0xc
    8000131a:	8526                	mv	a0,s1
    8000131c:	00000097          	auipc	ra,0x0
    80001320:	f1a080e7          	jalr	-230(ra) # 80001236 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001324:	8526                	mv	a0,s1
    80001326:	00001097          	auipc	ra,0x1
    8000132a:	914080e7          	jalr	-1772(ra) # 80001c3a <proc_mapstacks>
}
    8000132e:	8526                	mv	a0,s1
    80001330:	60e2                	ld	ra,24(sp)
    80001332:	6442                	ld	s0,16(sp)
    80001334:	64a2                	ld	s1,8(sp)
    80001336:	6902                	ld	s2,0(sp)
    80001338:	6105                	add	sp,sp,32
    8000133a:	8082                	ret

000000008000133c <kvminit>:
{
    8000133c:	1141                	add	sp,sp,-16
    8000133e:	e406                	sd	ra,8(sp)
    80001340:	e022                	sd	s0,0(sp)
    80001342:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    80001344:	00000097          	auipc	ra,0x0
    80001348:	f22080e7          	jalr	-222(ra) # 80001266 <kvmmake>
    8000134c:	00007797          	auipc	a5,0x7
    80001350:	6ea7b223          	sd	a0,1764(a5) # 80008a30 <kernel_pagetable>
}
    80001354:	60a2                	ld	ra,8(sp)
    80001356:	6402                	ld	s0,0(sp)
    80001358:	0141                	add	sp,sp,16
    8000135a:	8082                	ret

000000008000135c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000135c:	715d                	add	sp,sp,-80
    8000135e:	e486                	sd	ra,72(sp)
    80001360:	e0a2                	sd	s0,64(sp)
    80001362:	fc26                	sd	s1,56(sp)
    80001364:	f84a                	sd	s2,48(sp)
    80001366:	f44e                	sd	s3,40(sp)
    80001368:	f052                	sd	s4,32(sp)
    8000136a:	ec56                	sd	s5,24(sp)
    8000136c:	e85a                	sd	s6,16(sp)
    8000136e:	e45e                	sd	s7,8(sp)
    80001370:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001372:	03459793          	sll	a5,a1,0x34
    80001376:	e795                	bnez	a5,800013a2 <uvmunmap+0x46>
    80001378:	8a2a                	mv	s4,a0
    8000137a:	892e                	mv	s2,a1
    8000137c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000137e:	0632                	sll	a2,a2,0xc
    80001380:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001384:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001386:	6b05                	lui	s6,0x1
    80001388:	0735e263          	bltu	a1,s3,800013ec <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000138c:	60a6                	ld	ra,72(sp)
    8000138e:	6406                	ld	s0,64(sp)
    80001390:	74e2                	ld	s1,56(sp)
    80001392:	7942                	ld	s2,48(sp)
    80001394:	79a2                	ld	s3,40(sp)
    80001396:	7a02                	ld	s4,32(sp)
    80001398:	6ae2                	ld	s5,24(sp)
    8000139a:	6b42                	ld	s6,16(sp)
    8000139c:	6ba2                	ld	s7,8(sp)
    8000139e:	6161                	add	sp,sp,80
    800013a0:	8082                	ret
    panic("uvmunmap: not aligned");
    800013a2:	00007517          	auipc	a0,0x7
    800013a6:	d8650513          	add	a0,a0,-634 # 80008128 <etext+0x128>
    800013aa:	fffff097          	auipc	ra,0xfffff
    800013ae:	192080e7          	jalr	402(ra) # 8000053c <panic>
      panic("uvmunmap: walk");
    800013b2:	00007517          	auipc	a0,0x7
    800013b6:	d8e50513          	add	a0,a0,-626 # 80008140 <etext+0x140>
    800013ba:	fffff097          	auipc	ra,0xfffff
    800013be:	182080e7          	jalr	386(ra) # 8000053c <panic>
      panic("uvmunmap: not mapped");
    800013c2:	00007517          	auipc	a0,0x7
    800013c6:	d8e50513          	add	a0,a0,-626 # 80008150 <etext+0x150>
    800013ca:	fffff097          	auipc	ra,0xfffff
    800013ce:	172080e7          	jalr	370(ra) # 8000053c <panic>
      panic("uvmunmap: not a leaf");
    800013d2:	00007517          	auipc	a0,0x7
    800013d6:	d9650513          	add	a0,a0,-618 # 80008168 <etext+0x168>
    800013da:	fffff097          	auipc	ra,0xfffff
    800013de:	162080e7          	jalr	354(ra) # 8000053c <panic>
    *pte = 0;
    800013e2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013e6:	995a                	add	s2,s2,s6
    800013e8:	fb3972e3          	bgeu	s2,s3,8000138c <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800013ec:	4601                	li	a2,0
    800013ee:	85ca                	mv	a1,s2
    800013f0:	8552                	mv	a0,s4
    800013f2:	00000097          	auipc	ra,0x0
    800013f6:	cbc080e7          	jalr	-836(ra) # 800010ae <walk>
    800013fa:	84aa                	mv	s1,a0
    800013fc:	d95d                	beqz	a0,800013b2 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800013fe:	6108                	ld	a0,0(a0)
    80001400:	00157793          	and	a5,a0,1
    80001404:	dfdd                	beqz	a5,800013c2 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001406:	3ff57793          	and	a5,a0,1023
    8000140a:	fd7784e3          	beq	a5,s7,800013d2 <uvmunmap+0x76>
    if(do_free){
    8000140e:	fc0a8ae3          	beqz	s5,800013e2 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80001412:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    80001414:	0532                	sll	a0,a0,0xc
    80001416:	fffff097          	auipc	ra,0xfffff
    8000141a:	5ce080e7          	jalr	1486(ra) # 800009e4 <kfree>
    8000141e:	b7d1                	j	800013e2 <uvmunmap+0x86>

0000000080001420 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001420:	1101                	add	sp,sp,-32
    80001422:	ec06                	sd	ra,24(sp)
    80001424:	e822                	sd	s0,16(sp)
    80001426:	e426                	sd	s1,8(sp)
    80001428:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000142a:	fffff097          	auipc	ra,0xfffff
    8000142e:	754080e7          	jalr	1876(ra) # 80000b7e <kalloc>
    80001432:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001434:	c519                	beqz	a0,80001442 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001436:	6605                	lui	a2,0x1
    80001438:	4581                	li	a1,0
    8000143a:	00000097          	auipc	ra,0x0
    8000143e:	992080e7          	jalr	-1646(ra) # 80000dcc <memset>
  return pagetable;
}
    80001442:	8526                	mv	a0,s1
    80001444:	60e2                	ld	ra,24(sp)
    80001446:	6442                	ld	s0,16(sp)
    80001448:	64a2                	ld	s1,8(sp)
    8000144a:	6105                	add	sp,sp,32
    8000144c:	8082                	ret

000000008000144e <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000144e:	7179                	add	sp,sp,-48
    80001450:	f406                	sd	ra,40(sp)
    80001452:	f022                	sd	s0,32(sp)
    80001454:	ec26                	sd	s1,24(sp)
    80001456:	e84a                	sd	s2,16(sp)
    80001458:	e44e                	sd	s3,8(sp)
    8000145a:	e052                	sd	s4,0(sp)
    8000145c:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000145e:	6785                	lui	a5,0x1
    80001460:	04f67863          	bgeu	a2,a5,800014b0 <uvmfirst+0x62>
    80001464:	8a2a                	mv	s4,a0
    80001466:	89ae                	mv	s3,a1
    80001468:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000146a:	fffff097          	auipc	ra,0xfffff
    8000146e:	714080e7          	jalr	1812(ra) # 80000b7e <kalloc>
    80001472:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001474:	6605                	lui	a2,0x1
    80001476:	4581                	li	a1,0
    80001478:	00000097          	auipc	ra,0x0
    8000147c:	954080e7          	jalr	-1708(ra) # 80000dcc <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001480:	4779                	li	a4,30
    80001482:	86ca                	mv	a3,s2
    80001484:	6605                	lui	a2,0x1
    80001486:	4581                	li	a1,0
    80001488:	8552                	mv	a0,s4
    8000148a:	00000097          	auipc	ra,0x0
    8000148e:	d0c080e7          	jalr	-756(ra) # 80001196 <mappages>
  memmove(mem, src, sz);
    80001492:	8626                	mv	a2,s1
    80001494:	85ce                	mv	a1,s3
    80001496:	854a                	mv	a0,s2
    80001498:	00000097          	auipc	ra,0x0
    8000149c:	990080e7          	jalr	-1648(ra) # 80000e28 <memmove>
}
    800014a0:	70a2                	ld	ra,40(sp)
    800014a2:	7402                	ld	s0,32(sp)
    800014a4:	64e2                	ld	s1,24(sp)
    800014a6:	6942                	ld	s2,16(sp)
    800014a8:	69a2                	ld	s3,8(sp)
    800014aa:	6a02                	ld	s4,0(sp)
    800014ac:	6145                	add	sp,sp,48
    800014ae:	8082                	ret
    panic("uvmfirst: more than a page");
    800014b0:	00007517          	auipc	a0,0x7
    800014b4:	cd050513          	add	a0,a0,-816 # 80008180 <etext+0x180>
    800014b8:	fffff097          	auipc	ra,0xfffff
    800014bc:	084080e7          	jalr	132(ra) # 8000053c <panic>

00000000800014c0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800014c0:	1101                	add	sp,sp,-32
    800014c2:	ec06                	sd	ra,24(sp)
    800014c4:	e822                	sd	s0,16(sp)
    800014c6:	e426                	sd	s1,8(sp)
    800014c8:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800014ca:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800014cc:	00b67d63          	bgeu	a2,a1,800014e6 <uvmdealloc+0x26>
    800014d0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800014d2:	6785                	lui	a5,0x1
    800014d4:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800014d6:	00f60733          	add	a4,a2,a5
    800014da:	76fd                	lui	a3,0xfffff
    800014dc:	8f75                	and	a4,a4,a3
    800014de:	97ae                	add	a5,a5,a1
    800014e0:	8ff5                	and	a5,a5,a3
    800014e2:	00f76863          	bltu	a4,a5,800014f2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800014e6:	8526                	mv	a0,s1
    800014e8:	60e2                	ld	ra,24(sp)
    800014ea:	6442                	ld	s0,16(sp)
    800014ec:	64a2                	ld	s1,8(sp)
    800014ee:	6105                	add	sp,sp,32
    800014f0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800014f2:	8f99                	sub	a5,a5,a4
    800014f4:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800014f6:	4685                	li	a3,1
    800014f8:	0007861b          	sext.w	a2,a5
    800014fc:	85ba                	mv	a1,a4
    800014fe:	00000097          	auipc	ra,0x0
    80001502:	e5e080e7          	jalr	-418(ra) # 8000135c <uvmunmap>
    80001506:	b7c5                	j	800014e6 <uvmdealloc+0x26>

0000000080001508 <uvmalloc>:
  if(newsz < oldsz)
    80001508:	0ab66563          	bltu	a2,a1,800015b2 <uvmalloc+0xaa>
{
    8000150c:	7139                	add	sp,sp,-64
    8000150e:	fc06                	sd	ra,56(sp)
    80001510:	f822                	sd	s0,48(sp)
    80001512:	f426                	sd	s1,40(sp)
    80001514:	f04a                	sd	s2,32(sp)
    80001516:	ec4e                	sd	s3,24(sp)
    80001518:	e852                	sd	s4,16(sp)
    8000151a:	e456                	sd	s5,8(sp)
    8000151c:	e05a                	sd	s6,0(sp)
    8000151e:	0080                	add	s0,sp,64
    80001520:	8aaa                	mv	s5,a0
    80001522:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001524:	6785                	lui	a5,0x1
    80001526:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001528:	95be                	add	a1,a1,a5
    8000152a:	77fd                	lui	a5,0xfffff
    8000152c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001530:	08c9f363          	bgeu	s3,a2,800015b6 <uvmalloc+0xae>
    80001534:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001536:	0126eb13          	or	s6,a3,18
    mem = kalloc();
    8000153a:	fffff097          	auipc	ra,0xfffff
    8000153e:	644080e7          	jalr	1604(ra) # 80000b7e <kalloc>
    80001542:	84aa                	mv	s1,a0
    if(mem == 0){
    80001544:	c51d                	beqz	a0,80001572 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80001546:	6605                	lui	a2,0x1
    80001548:	4581                	li	a1,0
    8000154a:	00000097          	auipc	ra,0x0
    8000154e:	882080e7          	jalr	-1918(ra) # 80000dcc <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001552:	875a                	mv	a4,s6
    80001554:	86a6                	mv	a3,s1
    80001556:	6605                	lui	a2,0x1
    80001558:	85ca                	mv	a1,s2
    8000155a:	8556                	mv	a0,s5
    8000155c:	00000097          	auipc	ra,0x0
    80001560:	c3a080e7          	jalr	-966(ra) # 80001196 <mappages>
    80001564:	e90d                	bnez	a0,80001596 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001566:	6785                	lui	a5,0x1
    80001568:	993e                	add	s2,s2,a5
    8000156a:	fd4968e3          	bltu	s2,s4,8000153a <uvmalloc+0x32>
  return newsz;
    8000156e:	8552                	mv	a0,s4
    80001570:	a809                	j	80001582 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80001572:	864e                	mv	a2,s3
    80001574:	85ca                	mv	a1,s2
    80001576:	8556                	mv	a0,s5
    80001578:	00000097          	auipc	ra,0x0
    8000157c:	f48080e7          	jalr	-184(ra) # 800014c0 <uvmdealloc>
      return 0;
    80001580:	4501                	li	a0,0
}
    80001582:	70e2                	ld	ra,56(sp)
    80001584:	7442                	ld	s0,48(sp)
    80001586:	74a2                	ld	s1,40(sp)
    80001588:	7902                	ld	s2,32(sp)
    8000158a:	69e2                	ld	s3,24(sp)
    8000158c:	6a42                	ld	s4,16(sp)
    8000158e:	6aa2                	ld	s5,8(sp)
    80001590:	6b02                	ld	s6,0(sp)
    80001592:	6121                	add	sp,sp,64
    80001594:	8082                	ret
      kfree(mem);
    80001596:	8526                	mv	a0,s1
    80001598:	fffff097          	auipc	ra,0xfffff
    8000159c:	44c080e7          	jalr	1100(ra) # 800009e4 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800015a0:	864e                	mv	a2,s3
    800015a2:	85ca                	mv	a1,s2
    800015a4:	8556                	mv	a0,s5
    800015a6:	00000097          	auipc	ra,0x0
    800015aa:	f1a080e7          	jalr	-230(ra) # 800014c0 <uvmdealloc>
      return 0;
    800015ae:	4501                	li	a0,0
    800015b0:	bfc9                	j	80001582 <uvmalloc+0x7a>
    return oldsz;
    800015b2:	852e                	mv	a0,a1
}
    800015b4:	8082                	ret
  return newsz;
    800015b6:	8532                	mv	a0,a2
    800015b8:	b7e9                	j	80001582 <uvmalloc+0x7a>

00000000800015ba <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800015ba:	7179                	add	sp,sp,-48
    800015bc:	f406                	sd	ra,40(sp)
    800015be:	f022                	sd	s0,32(sp)
    800015c0:	ec26                	sd	s1,24(sp)
    800015c2:	e84a                	sd	s2,16(sp)
    800015c4:	e44e                	sd	s3,8(sp)
    800015c6:	e052                	sd	s4,0(sp)
    800015c8:	1800                	add	s0,sp,48
    800015ca:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800015cc:	84aa                	mv	s1,a0
    800015ce:	6905                	lui	s2,0x1
    800015d0:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015d2:	4985                	li	s3,1
    800015d4:	a829                	j	800015ee <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800015d6:	83a9                	srl	a5,a5,0xa
      freewalk((pagetable_t)child);
    800015d8:	00c79513          	sll	a0,a5,0xc
    800015dc:	00000097          	auipc	ra,0x0
    800015e0:	fde080e7          	jalr	-34(ra) # 800015ba <freewalk>
      pagetable[i] = 0;
    800015e4:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800015e8:	04a1                	add	s1,s1,8
    800015ea:	03248163          	beq	s1,s2,8000160c <freewalk+0x52>
    pte_t pte = pagetable[i];
    800015ee:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015f0:	00f7f713          	and	a4,a5,15
    800015f4:	ff3701e3          	beq	a4,s3,800015d6 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800015f8:	8b85                	and	a5,a5,1
    800015fa:	d7fd                	beqz	a5,800015e8 <freewalk+0x2e>
      panic("freewalk: leaf");
    800015fc:	00007517          	auipc	a0,0x7
    80001600:	ba450513          	add	a0,a0,-1116 # 800081a0 <etext+0x1a0>
    80001604:	fffff097          	auipc	ra,0xfffff
    80001608:	f38080e7          	jalr	-200(ra) # 8000053c <panic>
    }
  }
  kfree((void*)pagetable);
    8000160c:	8552                	mv	a0,s4
    8000160e:	fffff097          	auipc	ra,0xfffff
    80001612:	3d6080e7          	jalr	982(ra) # 800009e4 <kfree>
}
    80001616:	70a2                	ld	ra,40(sp)
    80001618:	7402                	ld	s0,32(sp)
    8000161a:	64e2                	ld	s1,24(sp)
    8000161c:	6942                	ld	s2,16(sp)
    8000161e:	69a2                	ld	s3,8(sp)
    80001620:	6a02                	ld	s4,0(sp)
    80001622:	6145                	add	sp,sp,48
    80001624:	8082                	ret

0000000080001626 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001626:	1101                	add	sp,sp,-32
    80001628:	ec06                	sd	ra,24(sp)
    8000162a:	e822                	sd	s0,16(sp)
    8000162c:	e426                	sd	s1,8(sp)
    8000162e:	1000                	add	s0,sp,32
    80001630:	84aa                	mv	s1,a0
  if(sz > 0)
    80001632:	e999                	bnez	a1,80001648 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001634:	8526                	mv	a0,s1
    80001636:	00000097          	auipc	ra,0x0
    8000163a:	f84080e7          	jalr	-124(ra) # 800015ba <freewalk>
}
    8000163e:	60e2                	ld	ra,24(sp)
    80001640:	6442                	ld	s0,16(sp)
    80001642:	64a2                	ld	s1,8(sp)
    80001644:	6105                	add	sp,sp,32
    80001646:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001648:	6785                	lui	a5,0x1
    8000164a:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000164c:	95be                	add	a1,a1,a5
    8000164e:	4685                	li	a3,1
    80001650:	00c5d613          	srl	a2,a1,0xc
    80001654:	4581                	li	a1,0
    80001656:	00000097          	auipc	ra,0x0
    8000165a:	d06080e7          	jalr	-762(ra) # 8000135c <uvmunmap>
    8000165e:	bfd9                	j	80001634 <uvmfree+0xe>

0000000080001660 <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80001660:	7159                	add	sp,sp,-112
    80001662:	f486                	sd	ra,104(sp)
    80001664:	f0a2                	sd	s0,96(sp)
    80001666:	eca6                	sd	s1,88(sp)
    80001668:	e8ca                	sd	s2,80(sp)
    8000166a:	e4ce                	sd	s3,72(sp)
    8000166c:	e0d2                	sd	s4,64(sp)
    8000166e:	fc56                	sd	s5,56(sp)
    80001670:	f85a                	sd	s6,48(sp)
    80001672:	f45e                	sd	s7,40(sp)
    80001674:	f062                	sd	s8,32(sp)
    80001676:	ec66                	sd	s9,24(sp)
    80001678:	e86a                	sd	s10,16(sp)
    8000167a:	e46e                	sd	s11,8(sp)
    8000167c:	1880                	add	s0,sp,112
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  // char *mem;

  for(i = 0; i < sz; i += PGSIZE)
    8000167e:	10060963          	beqz	a2,80001790 <uvmcopy+0x130>
    80001682:	8baa                	mv	s7,a0
    80001684:	8b2e                	mv	s6,a1
    80001686:	8ab2                	mv	s5,a2
    80001688:	4901                	li	s2,0
    // COW 
    if(flags & PTE_W)
    {
      flags &= (~PTE_W);        // remove write permission
      flags |= PTE_COW;         // add COW flag
      *pte = PA2PTE(pa)|flags;  // update the PTE
    8000168a:	7d7d                	lui	s10,0xfffff
    8000168c:	002d5d13          	srl	s10,s10,0x2
      // kfree(mem);
      goto err;
    }
    // COW 
    int idxx = (uint64)pa/PGSIZE;
    acquire(&nump_using_lock);
    80001690:	0000fa17          	auipc	s4,0xf
    80001694:	600a0a13          	add	s4,s4,1536 # 80010c90 <nump_using_lock>
    nump_using[idxx] = nump_using[idxx] + 1;  // mark that this page is being used by one more process
    80001698:	0000fc97          	auipc	s9,0xf
    8000169c:	630c8c93          	add	s9,s9,1584 # 80010cc8 <nump_using>
    if(nump_using[idxx] <= 1)
    800016a0:	4c05                	li	s8,1
      printf("uvmcopy: nump_using < 1");
    800016a2:	00007d97          	auipc	s11,0x7
    800016a6:	b4ed8d93          	add	s11,s11,-1202 # 800081f0 <etext+0x1f0>
    800016aa:	a8a5                	j	80001722 <uvmcopy+0xc2>
      panic("uvmcopy: pte should exist");
    800016ac:	00007517          	auipc	a0,0x7
    800016b0:	b0450513          	add	a0,a0,-1276 # 800081b0 <etext+0x1b0>
    800016b4:	fffff097          	auipc	ra,0xfffff
    800016b8:	e88080e7          	jalr	-376(ra) # 8000053c <panic>
      panic("uvmcopy: page not present");
    800016bc:	00007517          	auipc	a0,0x7
    800016c0:	b1450513          	add	a0,a0,-1260 # 800081d0 <etext+0x1d0>
    800016c4:	fffff097          	auipc	ra,0xfffff
    800016c8:	e78080e7          	jalr	-392(ra) # 8000053c <panic>
      flags &= (~PTE_W);        // remove write permission
    800016cc:	3fb77693          	and	a3,a4,1019
      flags |= PTE_COW;         // add COW flag
    800016d0:	1006e713          	or	a4,a3,256
      *pte = PA2PTE(pa)|flags;  // update the PTE
    800016d4:	01a7f7b3          	and	a5,a5,s10
    800016d8:	8fd9                	or	a5,a5,a4
    800016da:	e11c                	sd	a5,0(a0)
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0)
    800016dc:	86a6                	mv	a3,s1
    800016de:	6605                	lui	a2,0x1
    800016e0:	85ca                	mv	a1,s2
    800016e2:	855a                	mv	a0,s6
    800016e4:	00000097          	auipc	ra,0x0
    800016e8:	ab2080e7          	jalr	-1358(ra) # 80001196 <mappages>
    800016ec:	89aa                	mv	s3,a0
    800016ee:	e12d                	bnez	a0,80001750 <uvmcopy+0xf0>
    int idxx = (uint64)pa/PGSIZE;
    800016f0:	80b1                	srl	s1,s1,0xc
    800016f2:	2481                	sext.w	s1,s1
    acquire(&nump_using_lock);
    800016f4:	8552                	mv	a0,s4
    800016f6:	fffff097          	auipc	ra,0xfffff
    800016fa:	5da080e7          	jalr	1498(ra) # 80000cd0 <acquire>
    nump_using[idxx] = nump_using[idxx] + 1;  // mark that this page is being used by one more process
    800016fe:	048a                	sll	s1,s1,0x2
    80001700:	94e6                	add	s1,s1,s9
    80001702:	409c                	lw	a5,0(s1)
    80001704:	2785                	addw	a5,a5,1
    80001706:	0007871b          	sext.w	a4,a5
    8000170a:	c09c                	sw	a5,0(s1)
    if(nump_using[idxx] <= 1)
    8000170c:	06ec5c63          	bge	s8,a4,80001784 <uvmcopy+0x124>
    release(&nump_using_lock);
    80001710:	8552                	mv	a0,s4
    80001712:	fffff097          	auipc	ra,0xfffff
    80001716:	672080e7          	jalr	1650(ra) # 80000d84 <release>
  for(i = 0; i < sz; i += PGSIZE)
    8000171a:	6785                	lui	a5,0x1
    8000171c:	993e                	add	s2,s2,a5
    8000171e:	05597363          	bgeu	s2,s5,80001764 <uvmcopy+0x104>
    if((pte = walk(old, i, 0)) == 0)
    80001722:	4601                	li	a2,0
    80001724:	85ca                	mv	a1,s2
    80001726:	855e                	mv	a0,s7
    80001728:	00000097          	auipc	ra,0x0
    8000172c:	986080e7          	jalr	-1658(ra) # 800010ae <walk>
    80001730:	dd35                	beqz	a0,800016ac <uvmcopy+0x4c>
    if((*pte & PTE_V) == 0)
    80001732:	611c                	ld	a5,0(a0)
    80001734:	0017f713          	and	a4,a5,1
    80001738:	d351                	beqz	a4,800016bc <uvmcopy+0x5c>
    pa = PTE2PA(*pte);
    8000173a:	00a7d493          	srl	s1,a5,0xa
    8000173e:	04b2                	sll	s1,s1,0xc
    flags = PTE_FLAGS(*pte);
    80001740:	0007871b          	sext.w	a4,a5
    if(flags & PTE_W)
    80001744:	0047f693          	and	a3,a5,4
    80001748:	f2d1                	bnez	a3,800016cc <uvmcopy+0x6c>
    flags = PTE_FLAGS(*pte);
    8000174a:	3ff77713          	and	a4,a4,1023
    8000174e:	b779                	j	800016dc <uvmcopy+0x7c>
    
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001750:	4685                	li	a3,1
    80001752:	00c95613          	srl	a2,s2,0xc
    80001756:	4581                	li	a1,0
    80001758:	855a                	mv	a0,s6
    8000175a:	00000097          	auipc	ra,0x0
    8000175e:	c02080e7          	jalr	-1022(ra) # 8000135c <uvmunmap>
  return -1;
    80001762:	59fd                	li	s3,-1
}
    80001764:	854e                	mv	a0,s3
    80001766:	70a6                	ld	ra,104(sp)
    80001768:	7406                	ld	s0,96(sp)
    8000176a:	64e6                	ld	s1,88(sp)
    8000176c:	6946                	ld	s2,80(sp)
    8000176e:	69a6                	ld	s3,72(sp)
    80001770:	6a06                	ld	s4,64(sp)
    80001772:	7ae2                	ld	s5,56(sp)
    80001774:	7b42                	ld	s6,48(sp)
    80001776:	7ba2                	ld	s7,40(sp)
    80001778:	7c02                	ld	s8,32(sp)
    8000177a:	6ce2                	ld	s9,24(sp)
    8000177c:	6d42                	ld	s10,16(sp)
    8000177e:	6da2                	ld	s11,8(sp)
    80001780:	6165                	add	sp,sp,112
    80001782:	8082                	ret
      printf("uvmcopy: nump_using < 1");
    80001784:	856e                	mv	a0,s11
    80001786:	fffff097          	auipc	ra,0xfffff
    8000178a:	e00080e7          	jalr	-512(ra) # 80000586 <printf>
    8000178e:	b749                	j	80001710 <uvmcopy+0xb0>
  return 0;
    80001790:	4981                	li	s3,0
    80001792:	bfc9                	j	80001764 <uvmcopy+0x104>

0000000080001794 <removecopy>:


// create a new page in COW
int
removecopy(pagetable_t pt, uint64 va, uint64 sz)
{
    80001794:	7179                	add	sp,sp,-48
    80001796:	f406                	sd	ra,40(sp)
    80001798:	f022                	sd	s0,32(sp)
    8000179a:	ec26                	sd	s1,24(sp)
    8000179c:	e84a                	sd	s2,16(sp)
    8000179e:	e44e                	sd	s3,8(sp)
    800017a0:	e052                	sd	s4,0(sp)
    800017a2:	1800                	add	s0,sp,48
  char *mem;
  va = PGROUNDDOWN(va);
    800017a4:	77fd                	lui	a5,0xfffff
    800017a6:	8dfd                	and	a1,a1,a5
  if (MAXVA <= va)
    800017a8:	57fd                	li	a5,-1
    800017aa:	83e9                	srl	a5,a5,0x1a
    800017ac:	04b7e763          	bltu	a5,a1,800017fa <removecopy+0x66>
    printf("removecopy: va not available\n");
    // printf("va: %p\n",va);
    // printf("MAXVA: %p\n",MAXVA);
    return 1;
  }
  if (sz != 0 && (va > sz - PGSIZE && va < sz))    // if size defined, check for availaible space
    800017b0:	c619                	beqz	a2,800017be <removecopy+0x2a>
    800017b2:	77fd                	lui	a5,0xfffff
    800017b4:	97b2                	add	a5,a5,a2
    800017b6:	00b7f463          	bgeu	a5,a1,800017be <removecopy+0x2a>
    800017ba:	04c5ea63          	bltu	a1,a2,8000180e <removecopy+0x7a>
    // printf("va: %p\n",va);
    // printf("sz: %p\n",sz);
    // printf("PGSIZE: %p\n",PGSIZE);
    return 1;
  }
  pte_t *pte = walk(pt,va,0);
    800017be:	4601                	li	a2,0
    800017c0:	00000097          	auipc	ra,0x0
    800017c4:	8ee080e7          	jalr	-1810(ra) # 800010ae <walk>
    800017c8:	892a                	mv	s2,a0
  if(!(*pte & PTE_V) || !(*pte & PTE_COW))
    800017ca:	611c                	ld	a5,0(a0)
    800017cc:	1017f693          	and	a3,a5,257
    800017d0:	10100713          	li	a4,257
    800017d4:	04e68763          	beq	a3,a4,80001822 <removecopy+0x8e>
  {
    printf("removecopy: page not writable or not COW");
    800017d8:	00007517          	auipc	a0,0x7
    800017dc:	a7050513          	add	a0,a0,-1424 # 80008248 <etext+0x248>
    800017e0:	fffff097          	auipc	ra,0xfffff
    800017e4:	da6080e7          	jalr	-602(ra) # 80000586 <printf>
    return 1;
    800017e8:	4505                	li	a0,1
  uint64 pa = PTE2PA(*pte);            // get the physical address
  memmove(mem,(char*)pa,PGSIZE);
  *pte = PA2PTE(mem)|flags;
  kfree((void*)pa);
  return 0;
}
    800017ea:	70a2                	ld	ra,40(sp)
    800017ec:	7402                	ld	s0,32(sp)
    800017ee:	64e2                	ld	s1,24(sp)
    800017f0:	6942                	ld	s2,16(sp)
    800017f2:	69a2                	ld	s3,8(sp)
    800017f4:	6a02                	ld	s4,0(sp)
    800017f6:	6145                	add	sp,sp,48
    800017f8:	8082                	ret
    printf("removecopy: va not available\n");
    800017fa:	00007517          	auipc	a0,0x7
    800017fe:	a0e50513          	add	a0,a0,-1522 # 80008208 <etext+0x208>
    80001802:	fffff097          	auipc	ra,0xfffff
    80001806:	d84080e7          	jalr	-636(ra) # 80000586 <printf>
    return 1;
    8000180a:	4505                	li	a0,1
    8000180c:	bff9                	j	800017ea <removecopy+0x56>
    printf("removecopy: size not available\n");
    8000180e:	00007517          	auipc	a0,0x7
    80001812:	a1a50513          	add	a0,a0,-1510 # 80008228 <etext+0x228>
    80001816:	fffff097          	auipc	ra,0xfffff
    8000181a:	d70080e7          	jalr	-656(ra) # 80000586 <printf>
    return 1;
    8000181e:	4505                	li	a0,1
    80001820:	b7e9                	j	800017ea <removecopy+0x56>
  flags = flags & (~PTE_COW);          // remove COW flag
    80001822:	2ff7f993          	and	s3,a5,767
  if((mem = kalloc())==0)              // allocate a new page
    80001826:	fffff097          	auipc	ra,0xfffff
    8000182a:	358080e7          	jalr	856(ra) # 80000b7e <kalloc>
    8000182e:	84aa                	mv	s1,a0
    80001830:	c91d                	beqz	a0,80001866 <removecopy+0xd2>
  uint64 pa = PTE2PA(*pte);            // get the physical address
    80001832:	00093a03          	ld	s4,0(s2) # 1000 <_entry-0x7ffff000>
    80001836:	00aa5a13          	srl	s4,s4,0xa
    8000183a:	0a32                	sll	s4,s4,0xc
  memmove(mem,(char*)pa,PGSIZE);
    8000183c:	6605                	lui	a2,0x1
    8000183e:	85d2                	mv	a1,s4
    80001840:	fffff097          	auipc	ra,0xfffff
    80001844:	5e8080e7          	jalr	1512(ra) # 80000e28 <memmove>
  *pte = PA2PTE(mem)|flags;
    80001848:	80b1                	srl	s1,s1,0xc
    8000184a:	04aa                	sll	s1,s1,0xa
    8000184c:	0134e4b3          	or	s1,s1,s3
    80001850:	0044e493          	or	s1,s1,4
    80001854:	00993023          	sd	s1,0(s2)
  kfree((void*)pa);
    80001858:	8552                	mv	a0,s4
    8000185a:	fffff097          	auipc	ra,0xfffff
    8000185e:	18a080e7          	jalr	394(ra) # 800009e4 <kfree>
  return 0;
    80001862:	4501                	li	a0,0
    80001864:	b759                	j	800017ea <removecopy+0x56>
    panic("removecopy: kalloc error");
    80001866:	00007517          	auipc	a0,0x7
    8000186a:	a1250513          	add	a0,a0,-1518 # 80008278 <etext+0x278>
    8000186e:	fffff097          	auipc	ra,0xfffff
    80001872:	cce080e7          	jalr	-818(ra) # 8000053c <panic>

0000000080001876 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001876:	1141                	add	sp,sp,-16
    80001878:	e406                	sd	ra,8(sp)
    8000187a:	e022                	sd	s0,0(sp)
    8000187c:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000187e:	4601                	li	a2,0
    80001880:	00000097          	auipc	ra,0x0
    80001884:	82e080e7          	jalr	-2002(ra) # 800010ae <walk>
  if(pte == 0)
    80001888:	c901                	beqz	a0,80001898 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000188a:	611c                	ld	a5,0(a0)
    8000188c:	9bbd                	and	a5,a5,-17
    8000188e:	e11c                	sd	a5,0(a0)
}
    80001890:	60a2                	ld	ra,8(sp)
    80001892:	6402                	ld	s0,0(sp)
    80001894:	0141                	add	sp,sp,16
    80001896:	8082                	ret
    panic("uvmclear");
    80001898:	00007517          	auipc	a0,0x7
    8000189c:	a0050513          	add	a0,a0,-1536 # 80008298 <etext+0x298>
    800018a0:	fffff097          	auipc	ra,0xfffff
    800018a4:	c9c080e7          	jalr	-868(ra) # 8000053c <panic>

00000000800018a8 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800018a8:	c2dd                	beqz	a3,8000194e <copyout+0xa6>
{
    800018aa:	711d                	add	sp,sp,-96
    800018ac:	ec86                	sd	ra,88(sp)
    800018ae:	e8a2                	sd	s0,80(sp)
    800018b0:	e4a6                	sd	s1,72(sp)
    800018b2:	e0ca                	sd	s2,64(sp)
    800018b4:	fc4e                	sd	s3,56(sp)
    800018b6:	f852                	sd	s4,48(sp)
    800018b8:	f456                	sd	s5,40(sp)
    800018ba:	f05a                	sd	s6,32(sp)
    800018bc:	ec5e                	sd	s7,24(sp)
    800018be:	e862                	sd	s8,16(sp)
    800018c0:	e466                	sd	s9,8(sp)
    800018c2:	1080                	add	s0,sp,96
    800018c4:	8baa                	mv	s7,a0
    800018c6:	89ae                	mv	s3,a1
    800018c8:	8b32                	mv	s6,a2
    800018ca:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    800018cc:	7cfd                	lui	s9,0xfffff
    {
      removecopy(pagetable,va0, 0);
      pa0 = walkaddr(pagetable,va0);
    }

    n = PGSIZE - (dstva - va0);
    800018ce:	6c05                	lui	s8,0x1
    800018d0:	a089                	j	80001912 <copyout+0x6a>
      removecopy(pagetable,va0, 0);
    800018d2:	4601                	li	a2,0
    800018d4:	85ca                	mv	a1,s2
    800018d6:	855e                	mv	a0,s7
    800018d8:	00000097          	auipc	ra,0x0
    800018dc:	ebc080e7          	jalr	-324(ra) # 80001794 <removecopy>
      pa0 = walkaddr(pagetable,va0);
    800018e0:	85ca                	mv	a1,s2
    800018e2:	855e                	mv	a0,s7
    800018e4:	00000097          	auipc	ra,0x0
    800018e8:	870080e7          	jalr	-1936(ra) # 80001154 <walkaddr>
    800018ec:	8a2a                	mv	s4,a0
    800018ee:	a0b9                	j	8000193c <copyout+0x94>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800018f0:	41298533          	sub	a0,s3,s2
    800018f4:	0004861b          	sext.w	a2,s1
    800018f8:	85da                	mv	a1,s6
    800018fa:	9552                	add	a0,a0,s4
    800018fc:	fffff097          	auipc	ra,0xfffff
    80001900:	52c080e7          	jalr	1324(ra) # 80000e28 <memmove>

    len -= n;
    80001904:	409a8ab3          	sub	s5,s5,s1
    src += n;
    80001908:	9b26                	add	s6,s6,s1
    dstva = va0 + PGSIZE;
    8000190a:	018909b3          	add	s3,s2,s8
  while(len > 0){
    8000190e:	020a8e63          	beqz	s5,8000194a <copyout+0xa2>
    va0 = PGROUNDDOWN(dstva);
    80001912:	0199f933          	and	s2,s3,s9
    pa0 = walkaddr(pagetable, va0);
    80001916:	85ca                	mv	a1,s2
    80001918:	855e                	mv	a0,s7
    8000191a:	00000097          	auipc	ra,0x0
    8000191e:	83a080e7          	jalr	-1990(ra) # 80001154 <walkaddr>
    80001922:	8a2a                	mv	s4,a0
    if(pa0 == 0)
    80001924:	c51d                	beqz	a0,80001952 <copyout+0xaa>
    if(*walk(pagetable,va0,0) & PTE_COW)
    80001926:	4601                	li	a2,0
    80001928:	85ca                	mv	a1,s2
    8000192a:	855e                	mv	a0,s7
    8000192c:	fffff097          	auipc	ra,0xfffff
    80001930:	782080e7          	jalr	1922(ra) # 800010ae <walk>
    80001934:	611c                	ld	a5,0(a0)
    80001936:	1007f793          	and	a5,a5,256
    8000193a:	ffc1                	bnez	a5,800018d2 <copyout+0x2a>
    n = PGSIZE - (dstva - va0);
    8000193c:	413904b3          	sub	s1,s2,s3
    80001940:	94e2                	add	s1,s1,s8
    80001942:	fa9af7e3          	bgeu	s5,s1,800018f0 <copyout+0x48>
    80001946:	84d6                	mv	s1,s5
    80001948:	b765                	j	800018f0 <copyout+0x48>
  }
  return 0;
    8000194a:	4501                	li	a0,0
    8000194c:	a021                	j	80001954 <copyout+0xac>
    8000194e:	4501                	li	a0,0
}
    80001950:	8082                	ret
      return -1;
    80001952:	557d                	li	a0,-1
}
    80001954:	60e6                	ld	ra,88(sp)
    80001956:	6446                	ld	s0,80(sp)
    80001958:	64a6                	ld	s1,72(sp)
    8000195a:	6906                	ld	s2,64(sp)
    8000195c:	79e2                	ld	s3,56(sp)
    8000195e:	7a42                	ld	s4,48(sp)
    80001960:	7aa2                	ld	s5,40(sp)
    80001962:	7b02                	ld	s6,32(sp)
    80001964:	6be2                	ld	s7,24(sp)
    80001966:	6c42                	ld	s8,16(sp)
    80001968:	6ca2                	ld	s9,8(sp)
    8000196a:	6125                	add	sp,sp,96
    8000196c:	8082                	ret

000000008000196e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000196e:	caa5                	beqz	a3,800019de <copyin+0x70>
{
    80001970:	715d                	add	sp,sp,-80
    80001972:	e486                	sd	ra,72(sp)
    80001974:	e0a2                	sd	s0,64(sp)
    80001976:	fc26                	sd	s1,56(sp)
    80001978:	f84a                	sd	s2,48(sp)
    8000197a:	f44e                	sd	s3,40(sp)
    8000197c:	f052                	sd	s4,32(sp)
    8000197e:	ec56                	sd	s5,24(sp)
    80001980:	e85a                	sd	s6,16(sp)
    80001982:	e45e                	sd	s7,8(sp)
    80001984:	e062                	sd	s8,0(sp)
    80001986:	0880                	add	s0,sp,80
    80001988:	8b2a                	mv	s6,a0
    8000198a:	8a2e                	mv	s4,a1
    8000198c:	8c32                	mv	s8,a2
    8000198e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001990:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001992:	6a85                	lui	s5,0x1
    80001994:	a01d                	j	800019ba <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001996:	018505b3          	add	a1,a0,s8
    8000199a:	0004861b          	sext.w	a2,s1
    8000199e:	412585b3          	sub	a1,a1,s2
    800019a2:	8552                	mv	a0,s4
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	484080e7          	jalr	1156(ra) # 80000e28 <memmove>

    len -= n;
    800019ac:	409989b3          	sub	s3,s3,s1
    dst += n;
    800019b0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800019b2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800019b6:	02098263          	beqz	s3,800019da <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800019ba:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800019be:	85ca                	mv	a1,s2
    800019c0:	855a                	mv	a0,s6
    800019c2:	fffff097          	auipc	ra,0xfffff
    800019c6:	792080e7          	jalr	1938(ra) # 80001154 <walkaddr>
    if(pa0 == 0)
    800019ca:	cd01                	beqz	a0,800019e2 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800019cc:	418904b3          	sub	s1,s2,s8
    800019d0:	94d6                	add	s1,s1,s5
    800019d2:	fc99f2e3          	bgeu	s3,s1,80001996 <copyin+0x28>
    800019d6:	84ce                	mv	s1,s3
    800019d8:	bf7d                	j	80001996 <copyin+0x28>
  }
  return 0;
    800019da:	4501                	li	a0,0
    800019dc:	a021                	j	800019e4 <copyin+0x76>
    800019de:	4501                	li	a0,0
}
    800019e0:	8082                	ret
      return -1;
    800019e2:	557d                	li	a0,-1
}
    800019e4:	60a6                	ld	ra,72(sp)
    800019e6:	6406                	ld	s0,64(sp)
    800019e8:	74e2                	ld	s1,56(sp)
    800019ea:	7942                	ld	s2,48(sp)
    800019ec:	79a2                	ld	s3,40(sp)
    800019ee:	7a02                	ld	s4,32(sp)
    800019f0:	6ae2                	ld	s5,24(sp)
    800019f2:	6b42                	ld	s6,16(sp)
    800019f4:	6ba2                	ld	s7,8(sp)
    800019f6:	6c02                	ld	s8,0(sp)
    800019f8:	6161                	add	sp,sp,80
    800019fa:	8082                	ret

00000000800019fc <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800019fc:	c2dd                	beqz	a3,80001aa2 <copyinstr+0xa6>
{
    800019fe:	715d                	add	sp,sp,-80
    80001a00:	e486                	sd	ra,72(sp)
    80001a02:	e0a2                	sd	s0,64(sp)
    80001a04:	fc26                	sd	s1,56(sp)
    80001a06:	f84a                	sd	s2,48(sp)
    80001a08:	f44e                	sd	s3,40(sp)
    80001a0a:	f052                	sd	s4,32(sp)
    80001a0c:	ec56                	sd	s5,24(sp)
    80001a0e:	e85a                	sd	s6,16(sp)
    80001a10:	e45e                	sd	s7,8(sp)
    80001a12:	0880                	add	s0,sp,80
    80001a14:	8a2a                	mv	s4,a0
    80001a16:	8b2e                	mv	s6,a1
    80001a18:	8bb2                	mv	s7,a2
    80001a1a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001a1c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001a1e:	6985                	lui	s3,0x1
    80001a20:	a02d                	j	80001a4a <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001a22:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7fdbb528>
    80001a26:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001a28:	37fd                	addw	a5,a5,-1
    80001a2a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001a2e:	60a6                	ld	ra,72(sp)
    80001a30:	6406                	ld	s0,64(sp)
    80001a32:	74e2                	ld	s1,56(sp)
    80001a34:	7942                	ld	s2,48(sp)
    80001a36:	79a2                	ld	s3,40(sp)
    80001a38:	7a02                	ld	s4,32(sp)
    80001a3a:	6ae2                	ld	s5,24(sp)
    80001a3c:	6b42                	ld	s6,16(sp)
    80001a3e:	6ba2                	ld	s7,8(sp)
    80001a40:	6161                	add	sp,sp,80
    80001a42:	8082                	ret
    srcva = va0 + PGSIZE;
    80001a44:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001a48:	c8a9                	beqz	s1,80001a9a <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80001a4a:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001a4e:	85ca                	mv	a1,s2
    80001a50:	8552                	mv	a0,s4
    80001a52:	fffff097          	auipc	ra,0xfffff
    80001a56:	702080e7          	jalr	1794(ra) # 80001154 <walkaddr>
    if(pa0 == 0)
    80001a5a:	c131                	beqz	a0,80001a9e <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001a5c:	417906b3          	sub	a3,s2,s7
    80001a60:	96ce                	add	a3,a3,s3
    80001a62:	00d4f363          	bgeu	s1,a3,80001a68 <copyinstr+0x6c>
    80001a66:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001a68:	955e                	add	a0,a0,s7
    80001a6a:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001a6e:	daf9                	beqz	a3,80001a44 <copyinstr+0x48>
    80001a70:	87da                	mv	a5,s6
    80001a72:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001a74:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001a78:	96da                	add	a3,a3,s6
    80001a7a:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001a7c:	00f60733          	add	a4,a2,a5
    80001a80:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7fdbb528>
    80001a84:	df59                	beqz	a4,80001a22 <copyinstr+0x26>
        *dst = *p;
    80001a86:	00e78023          	sb	a4,0(a5)
      dst++;
    80001a8a:	0785                	add	a5,a5,1
    while(n > 0){
    80001a8c:	fed797e3          	bne	a5,a3,80001a7a <copyinstr+0x7e>
    80001a90:	14fd                	add	s1,s1,-1
    80001a92:	94c2                	add	s1,s1,a6
      --max;
    80001a94:	8c8d                	sub	s1,s1,a1
      dst++;
    80001a96:	8b3e                	mv	s6,a5
    80001a98:	b775                	j	80001a44 <copyinstr+0x48>
    80001a9a:	4781                	li	a5,0
    80001a9c:	b771                	j	80001a28 <copyinstr+0x2c>
      return -1;
    80001a9e:	557d                	li	a0,-1
    80001aa0:	b779                	j	80001a2e <copyinstr+0x32>
  int got_null = 0;
    80001aa2:	4781                	li	a5,0
  if(got_null){
    80001aa4:	37fd                	addw	a5,a5,-1
    80001aa6:	0007851b          	sext.w	a0,a5
}
    80001aaa:	8082                	ret

0000000080001aac <sched_pbs>:
}
#endif

#ifdef PBS
void sched_pbs()
{
    80001aac:	715d                	add	sp,sp,-80
    80001aae:	e486                	sd	ra,72(sp)
    80001ab0:	e0a2                	sd	s0,64(sp)
    80001ab2:	fc26                	sd	s1,56(sp)
    80001ab4:	f84a                	sd	s2,48(sp)
    80001ab6:	f44e                	sd	s3,40(sp)
    80001ab8:	f052                	sd	s4,32(sp)
    80001aba:	ec56                	sd	s5,24(sp)
    80001abc:	e85a                	sd	s6,16(sp)
    80001abe:	e45e                	sd	s7,8(sp)
    80001ac0:	e062                	sd	s8,0(sp)
    80001ac2:	0880                	add	s0,sp,80
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ac4:	8c12                	mv	s8,tp
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
  int id = r_tp();
    80001ac6:	2c01                	sext.w	s8,s8
  struct proc *selected = c->proc;
    80001ac8:	007c1713          	sll	a4,s8,0x7
    80001acc:	0022f797          	auipc	a5,0x22f
    80001ad0:	1fc78793          	add	a5,a5,508 # 80230cc8 <cpus>
    80001ad4:	97ba                	add	a5,a5,a4
    80001ad6:	0007b903          	ld	s2,0(a5)
  for (struct proc *p = proc; p < &proc[NPROC]; p++) // from gpt
    80001ada:	0022f497          	auipc	s1,0x22f
    80001ade:	61e48493          	add	s1,s1,1566 # 802310f8 <proc>
    if (p->state != RUNNABLE) // || p->state != RUNNING)
    80001ae2:	4a0d                	li	s4,3
    p->dynamic_priority = ((3*p->run_time - p->wait_time - p->sleep_time)*50/(p->run_time + p->wait_time + p->sleep_time + 1));
    80001ae4:	03200b13          	li	s6,50
    if(p->dynamic_priority > 100)
    80001ae8:	06400a93          	li	s5,100
    80001aec:	06400b93          	li	s7,100
  for (struct proc *p = proc; p < &proc[NPROC]; p++) // from gpt
    80001af0:	00237997          	auipc	s3,0x237
    80001af4:	c0898993          	add	s3,s3,-1016 # 802386f8 <tickslock>
    80001af8:	a0a1                	j	80001b40 <sched_pbs+0x94>
      release(&p->lock);
    80001afa:	8526                	mv	a0,s1
    80001afc:	fffff097          	auipc	ra,0xfffff
    80001b00:	288080e7          	jalr	648(ra) # 80000d84 <release>
      continue;
    80001b04:	a815                	j	80001b38 <sched_pbs+0x8c>
        release(&selected->lock);
    80001b06:	854a                	mv	a0,s2
    80001b08:	fffff097          	auipc	ra,0xfffff
    80001b0c:	27c080e7          	jalr	636(ra) # 80000d84 <release>
    80001b10:	8926                	mv	s2,s1
    80001b12:	a01d                	j	80001b38 <sched_pbs+0x8c>
    if(p->dynamic_priority == selected->dynamic_priority && p->num_shed < selected->num_shed)   // less times scheduled gets more priority
    80001b14:	1d44a703          	lw	a4,468(s1)
    80001b18:	1d492783          	lw	a5,468(s2)
    80001b1c:	08f75663          	bge	a4,a5,80001ba8 <sched_pbs+0xfc>
      release(&selected->lock);
    80001b20:	854a                	mv	a0,s2
    80001b22:	fffff097          	auipc	ra,0xfffff
    80001b26:	262080e7          	jalr	610(ra) # 80000d84 <release>
      continue;
    80001b2a:	8926                	mv	s2,s1
    80001b2c:	a031                	j	80001b38 <sched_pbs+0x8c>
    release(&p->lock);
    80001b2e:	8526                	mv	a0,s1
    80001b30:	fffff097          	auipc	ra,0xfffff
    80001b34:	254080e7          	jalr	596(ra) # 80000d84 <release>
  for (struct proc *p = proc; p < &proc[NPROC]; p++) // from gpt
    80001b38:	1d848493          	add	s1,s1,472
    80001b3c:	09348b63          	beq	s1,s3,80001bd2 <sched_pbs+0x126>
    acquire(&p->lock);
    80001b40:	8526                	mv	a0,s1
    80001b42:	fffff097          	auipc	ra,0xfffff
    80001b46:	18e080e7          	jalr	398(ra) # 80000cd0 <acquire>
    if (p->state != RUNNABLE) // || p->state != RUNNING)
    80001b4a:	4c9c                	lw	a5,24(s1)
    80001b4c:	fb4797e3          	bne	a5,s4,80001afa <sched_pbs+0x4e>
    p->dynamic_priority = ((3*p->run_time - p->wait_time - p->sleep_time)*50/(p->run_time + p->wait_time + p->sleep_time + 1));
    80001b50:	1c04a703          	lw	a4,448(s1)
    80001b54:	1c44a603          	lw	a2,452(s1)
    80001b58:	1c84a683          	lw	a3,456(s1)
    80001b5c:	0017179b          	sllw	a5,a4,0x1
    80001b60:	9fb9                	addw	a5,a5,a4
    80001b62:	9f91                	subw	a5,a5,a2
    80001b64:	9f95                	subw	a5,a5,a3
    80001b66:	036787bb          	mulw	a5,a5,s6
    80001b6a:	9f31                	addw	a4,a4,a2
    80001b6c:	9f35                	addw	a4,a4,a3
    80001b6e:	2705                	addw	a4,a4,1
    80001b70:	02e7c7bb          	divw	a5,a5,a4
    if(p->dynamic_priority < 0)
    80001b74:	0007871b          	sext.w	a4,a5
    80001b78:	fff74713          	not	a4,a4
    80001b7c:	977d                	sra	a4,a4,0x3f
    80001b7e:	8ff9                	and	a5,a5,a4
    p->dynamic_priority += p->priority;
    80001b80:	1cc4a703          	lw	a4,460(s1)
    80001b84:	9fb9                	addw	a5,a5,a4
    if(p->dynamic_priority > 100)
    80001b86:	0007871b          	sext.w	a4,a5
    80001b8a:	00ead363          	bge	s5,a4,80001b90 <sched_pbs+0xe4>
    80001b8e:	87de                	mv	a5,s7
    80001b90:	0007871b          	sext.w	a4,a5
    80001b94:	1cf4a823          	sw	a5,464(s1)
    if (!selected || p->dynamic_priority < selected->dynamic_priority)
    80001b98:	02090b63          	beqz	s2,80001bce <sched_pbs+0x122>
    80001b9c:	1d092783          	lw	a5,464(s2)
    80001ba0:	f6f743e3          	blt	a4,a5,80001b06 <sched_pbs+0x5a>
    if(p->dynamic_priority == selected->dynamic_priority && p->num_shed < selected->num_shed)   // less times scheduled gets more priority
    80001ba4:	f6e788e3          	beq	a5,a4,80001b14 <sched_pbs+0x68>
    if(p->dynamic_priority == selected->dynamic_priority && p->num_shed == selected->num_shed && p->ctime < selected->ctime) // ctime gives spawn time
    80001ba8:	1d04b703          	ld	a4,464(s1)
    80001bac:	1d093783          	ld	a5,464(s2)
    80001bb0:	f6f71fe3          	bne	a4,a5,80001b2e <sched_pbs+0x82>
    80001bb4:	16c4a703          	lw	a4,364(s1)
    80001bb8:	16c92783          	lw	a5,364(s2)
    80001bbc:	f6f779e3          	bgeu	a4,a5,80001b2e <sched_pbs+0x82>
      release(&selected->lock);
    80001bc0:	854a                	mv	a0,s2
    80001bc2:	fffff097          	auipc	ra,0xfffff
    80001bc6:	1c2080e7          	jalr	450(ra) # 80000d84 <release>
      continue;
    80001bca:	8926                	mv	s2,s1
    80001bcc:	b7b5                	j	80001b38 <sched_pbs+0x8c>
    80001bce:	8926                	mv	s2,s1
    80001bd0:	b7a5                	j	80001b38 <sched_pbs+0x8c>
  if (selected)
    80001bd2:	04090863          	beqz	s2,80001c22 <sched_pbs+0x176>
    selected->state = RUNNING;
    80001bd6:	4791                	li	a5,4
    80001bd8:	00f92c23          	sw	a5,24(s2)
    c->proc = selected;
    80001bdc:	0022f517          	auipc	a0,0x22f
    80001be0:	0ec50513          	add	a0,a0,236 # 80230cc8 <cpus>
    80001be4:	0c1e                	sll	s8,s8,0x7
    80001be6:	018504b3          	add	s1,a0,s8
    80001bea:	0124b023          	sd	s2,0(s1)
    selected->run_time = 0;
    80001bee:	1c092023          	sw	zero,448(s2)
    selected->wait_time = 0;
    80001bf2:	1c092223          	sw	zero,452(s2)
    selected->sleep_time = 0;
    80001bf6:	1c092423          	sw	zero,456(s2)
    selected->num_shed++;
    80001bfa:	1d492783          	lw	a5,468(s2)
    80001bfe:	2785                	addw	a5,a5,1
    80001c00:	1cf92a23          	sw	a5,468(s2)
    swtch(&c->context, &selected->context);
    80001c04:	0c21                	add	s8,s8,8 # 1008 <_entry-0x7fffeff8>
    80001c06:	06090593          	add	a1,s2,96
    80001c0a:	9562                	add	a0,a0,s8
    80001c0c:	00001097          	auipc	ra,0x1
    80001c10:	06a080e7          	jalr	106(ra) # 80002c76 <swtch>
    c->proc = 0;
    80001c14:	0004b023          	sd	zero,0(s1)
    release(&selected->lock);
    80001c18:	854a                	mv	a0,s2
    80001c1a:	fffff097          	auipc	ra,0xfffff
    80001c1e:	16a080e7          	jalr	362(ra) # 80000d84 <release>
}
    80001c22:	60a6                	ld	ra,72(sp)
    80001c24:	6406                	ld	s0,64(sp)
    80001c26:	74e2                	ld	s1,56(sp)
    80001c28:	7942                	ld	s2,48(sp)
    80001c2a:	79a2                	ld	s3,40(sp)
    80001c2c:	7a02                	ld	s4,32(sp)
    80001c2e:	6ae2                	ld	s5,24(sp)
    80001c30:	6b42                	ld	s6,16(sp)
    80001c32:	6ba2                	ld	s7,8(sp)
    80001c34:	6c02                	ld	s8,0(sp)
    80001c36:	6161                	add	sp,sp,80
    80001c38:	8082                	ret

0000000080001c3a <proc_mapstacks>:
{
    80001c3a:	7139                	add	sp,sp,-64
    80001c3c:	fc06                	sd	ra,56(sp)
    80001c3e:	f822                	sd	s0,48(sp)
    80001c40:	f426                	sd	s1,40(sp)
    80001c42:	f04a                	sd	s2,32(sp)
    80001c44:	ec4e                	sd	s3,24(sp)
    80001c46:	e852                	sd	s4,16(sp)
    80001c48:	e456                	sd	s5,8(sp)
    80001c4a:	e05a                	sd	s6,0(sp)
    80001c4c:	0080                	add	s0,sp,64
    80001c4e:	89aa                	mv	s3,a0
  for (p = proc; p < &proc[NPROC]; p++)
    80001c50:	0022f497          	auipc	s1,0x22f
    80001c54:	4a848493          	add	s1,s1,1192 # 802310f8 <proc>
    uint64 va = KSTACK((int)(p - proc));
    80001c58:	8b26                	mv	s6,s1
    80001c5a:	00006a97          	auipc	s5,0x6
    80001c5e:	3a6a8a93          	add	s5,s5,934 # 80008000 <etext>
    80001c62:	04000937          	lui	s2,0x4000
    80001c66:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001c68:	0932                	sll	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001c6a:	00237a17          	auipc	s4,0x237
    80001c6e:	a8ea0a13          	add	s4,s4,-1394 # 802386f8 <tickslock>
    char *pa = kalloc();
    80001c72:	fffff097          	auipc	ra,0xfffff
    80001c76:	f0c080e7          	jalr	-244(ra) # 80000b7e <kalloc>
    80001c7a:	862a                	mv	a2,a0
    if (pa == 0)
    80001c7c:	c131                	beqz	a0,80001cc0 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80001c7e:	416485b3          	sub	a1,s1,s6
    80001c82:	858d                	sra	a1,a1,0x3
    80001c84:	000ab783          	ld	a5,0(s5)
    80001c88:	02f585b3          	mul	a1,a1,a5
    80001c8c:	2585                	addw	a1,a1,1
    80001c8e:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001c92:	4719                	li	a4,6
    80001c94:	6685                	lui	a3,0x1
    80001c96:	40b905b3          	sub	a1,s2,a1
    80001c9a:	854e                	mv	a0,s3
    80001c9c:	fffff097          	auipc	ra,0xfffff
    80001ca0:	59a080e7          	jalr	1434(ra) # 80001236 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80001ca4:	1d848493          	add	s1,s1,472
    80001ca8:	fd4495e3          	bne	s1,s4,80001c72 <proc_mapstacks+0x38>
}
    80001cac:	70e2                	ld	ra,56(sp)
    80001cae:	7442                	ld	s0,48(sp)
    80001cb0:	74a2                	ld	s1,40(sp)
    80001cb2:	7902                	ld	s2,32(sp)
    80001cb4:	69e2                	ld	s3,24(sp)
    80001cb6:	6a42                	ld	s4,16(sp)
    80001cb8:	6aa2                	ld	s5,8(sp)
    80001cba:	6b02                	ld	s6,0(sp)
    80001cbc:	6121                	add	sp,sp,64
    80001cbe:	8082                	ret
      panic("kalloc");
    80001cc0:	00006517          	auipc	a0,0x6
    80001cc4:	5e850513          	add	a0,a0,1512 # 800082a8 <etext+0x2a8>
    80001cc8:	fffff097          	auipc	ra,0xfffff
    80001ccc:	874080e7          	jalr	-1932(ra) # 8000053c <panic>

0000000080001cd0 <procinit>:
{
    80001cd0:	7139                	add	sp,sp,-64
    80001cd2:	fc06                	sd	ra,56(sp)
    80001cd4:	f822                	sd	s0,48(sp)
    80001cd6:	f426                	sd	s1,40(sp)
    80001cd8:	f04a                	sd	s2,32(sp)
    80001cda:	ec4e                	sd	s3,24(sp)
    80001cdc:	e852                	sd	s4,16(sp)
    80001cde:	e456                	sd	s5,8(sp)
    80001ce0:	e05a                	sd	s6,0(sp)
    80001ce2:	0080                	add	s0,sp,64
  initlock(&pid_lock, "nextpid");
    80001ce4:	00006597          	auipc	a1,0x6
    80001ce8:	5cc58593          	add	a1,a1,1484 # 800082b0 <etext+0x2b0>
    80001cec:	0022f517          	auipc	a0,0x22f
    80001cf0:	3dc50513          	add	a0,a0,988 # 802310c8 <pid_lock>
    80001cf4:	fffff097          	auipc	ra,0xfffff
    80001cf8:	f4c080e7          	jalr	-180(ra) # 80000c40 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001cfc:	00006597          	auipc	a1,0x6
    80001d00:	5bc58593          	add	a1,a1,1468 # 800082b8 <etext+0x2b8>
    80001d04:	0022f517          	auipc	a0,0x22f
    80001d08:	3dc50513          	add	a0,a0,988 # 802310e0 <wait_lock>
    80001d0c:	fffff097          	auipc	ra,0xfffff
    80001d10:	f34080e7          	jalr	-204(ra) # 80000c40 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80001d14:	0022f497          	auipc	s1,0x22f
    80001d18:	3e448493          	add	s1,s1,996 # 802310f8 <proc>
    initlock(&p->lock, "proc");
    80001d1c:	00006b17          	auipc	s6,0x6
    80001d20:	5acb0b13          	add	s6,s6,1452 # 800082c8 <etext+0x2c8>
    p->kstack = KSTACK((int)(p - proc));
    80001d24:	8aa6                	mv	s5,s1
    80001d26:	00006a17          	auipc	s4,0x6
    80001d2a:	2daa0a13          	add	s4,s4,730 # 80008000 <etext>
    80001d2e:	04000937          	lui	s2,0x4000
    80001d32:	197d                	add	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001d34:	0932                	sll	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001d36:	00237997          	auipc	s3,0x237
    80001d3a:	9c298993          	add	s3,s3,-1598 # 802386f8 <tickslock>
    initlock(&p->lock, "proc");
    80001d3e:	85da                	mv	a1,s6
    80001d40:	8526                	mv	a0,s1
    80001d42:	fffff097          	auipc	ra,0xfffff
    80001d46:	efe080e7          	jalr	-258(ra) # 80000c40 <initlock>
    p->state = UNUSED;
    80001d4a:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001d4e:	415487b3          	sub	a5,s1,s5
    80001d52:	878d                	sra	a5,a5,0x3
    80001d54:	000a3703          	ld	a4,0(s4)
    80001d58:	02e787b3          	mul	a5,a5,a4
    80001d5c:	2785                	addw	a5,a5,1
    80001d5e:	00d7979b          	sllw	a5,a5,0xd
    80001d62:	40f907b3          	sub	a5,s2,a5
    80001d66:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80001d68:	1d848493          	add	s1,s1,472
    80001d6c:	fd3499e3          	bne	s1,s3,80001d3e <procinit+0x6e>
}
    80001d70:	70e2                	ld	ra,56(sp)
    80001d72:	7442                	ld	s0,48(sp)
    80001d74:	74a2                	ld	s1,40(sp)
    80001d76:	7902                	ld	s2,32(sp)
    80001d78:	69e2                	ld	s3,24(sp)
    80001d7a:	6a42                	ld	s4,16(sp)
    80001d7c:	6aa2                	ld	s5,8(sp)
    80001d7e:	6b02                	ld	s6,0(sp)
    80001d80:	6121                	add	sp,sp,64
    80001d82:	8082                	ret

0000000080001d84 <cpuid>:
{
    80001d84:	1141                	add	sp,sp,-16
    80001d86:	e422                	sd	s0,8(sp)
    80001d88:	0800                	add	s0,sp,16
    80001d8a:	8512                	mv	a0,tp
  return id;
}
    80001d8c:	2501                	sext.w	a0,a0
    80001d8e:	6422                	ld	s0,8(sp)
    80001d90:	0141                	add	sp,sp,16
    80001d92:	8082                	ret

0000000080001d94 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80001d94:	1141                	add	sp,sp,-16
    80001d96:	e422                	sd	s0,8(sp)
    80001d98:	0800                	add	s0,sp,16
    80001d9a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001d9c:	2781                	sext.w	a5,a5
    80001d9e:	079e                	sll	a5,a5,0x7
  return c;
}
    80001da0:	0022f517          	auipc	a0,0x22f
    80001da4:	f2850513          	add	a0,a0,-216 # 80230cc8 <cpus>
    80001da8:	953e                	add	a0,a0,a5
    80001daa:	6422                	ld	s0,8(sp)
    80001dac:	0141                	add	sp,sp,16
    80001dae:	8082                	ret

0000000080001db0 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001db0:	1101                	add	sp,sp,-32
    80001db2:	ec06                	sd	ra,24(sp)
    80001db4:	e822                	sd	s0,16(sp)
    80001db6:	e426                	sd	s1,8(sp)
    80001db8:	1000                	add	s0,sp,32
  push_off();
    80001dba:	fffff097          	auipc	ra,0xfffff
    80001dbe:	eca080e7          	jalr	-310(ra) # 80000c84 <push_off>
    80001dc2:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001dc4:	2781                	sext.w	a5,a5
    80001dc6:	079e                	sll	a5,a5,0x7
    80001dc8:	0022f717          	auipc	a4,0x22f
    80001dcc:	f0070713          	add	a4,a4,-256 # 80230cc8 <cpus>
    80001dd0:	97ba                	add	a5,a5,a4
    80001dd2:	6384                	ld	s1,0(a5)
  pop_off();
    80001dd4:	fffff097          	auipc	ra,0xfffff
    80001dd8:	f50080e7          	jalr	-176(ra) # 80000d24 <pop_off>
  return p;
}
    80001ddc:	8526                	mv	a0,s1
    80001dde:	60e2                	ld	ra,24(sp)
    80001de0:	6442                	ld	s0,16(sp)
    80001de2:	64a2                	ld	s1,8(sp)
    80001de4:	6105                	add	sp,sp,32
    80001de6:	8082                	ret

0000000080001de8 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001de8:	1141                	add	sp,sp,-16
    80001dea:	e406                	sd	ra,8(sp)
    80001dec:	e022                	sd	s0,0(sp)
    80001dee:	0800                	add	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001df0:	00000097          	auipc	ra,0x0
    80001df4:	fc0080e7          	jalr	-64(ra) # 80001db0 <myproc>
    80001df8:	fffff097          	auipc	ra,0xfffff
    80001dfc:	f8c080e7          	jalr	-116(ra) # 80000d84 <release>

  if (first)
    80001e00:	00007797          	auipc	a5,0x7
    80001e04:	bc07a783          	lw	a5,-1088(a5) # 800089c0 <first.1>
    80001e08:	eb89                	bnez	a5,80001e1a <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001e0a:	00001097          	auipc	ra,0x1
    80001e0e:	f16080e7          	jalr	-234(ra) # 80002d20 <usertrapret>
}
    80001e12:	60a2                	ld	ra,8(sp)
    80001e14:	6402                	ld	s0,0(sp)
    80001e16:	0141                	add	sp,sp,16
    80001e18:	8082                	ret
    first = 0;
    80001e1a:	00007797          	auipc	a5,0x7
    80001e1e:	ba07a323          	sw	zero,-1114(a5) # 800089c0 <first.1>
    fsinit(ROOTDEV);
    80001e22:	4505                	li	a0,1
    80001e24:	00002097          	auipc	ra,0x2
    80001e28:	f28080e7          	jalr	-216(ra) # 80003d4c <fsinit>
    80001e2c:	bff9                	j	80001e0a <forkret+0x22>

0000000080001e2e <allocpid>:
{
    80001e2e:	1101                	add	sp,sp,-32
    80001e30:	ec06                	sd	ra,24(sp)
    80001e32:	e822                	sd	s0,16(sp)
    80001e34:	e426                	sd	s1,8(sp)
    80001e36:	e04a                	sd	s2,0(sp)
    80001e38:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    80001e3a:	0022f917          	auipc	s2,0x22f
    80001e3e:	28e90913          	add	s2,s2,654 # 802310c8 <pid_lock>
    80001e42:	854a                	mv	a0,s2
    80001e44:	fffff097          	auipc	ra,0xfffff
    80001e48:	e8c080e7          	jalr	-372(ra) # 80000cd0 <acquire>
  pid = nextpid;
    80001e4c:	00007797          	auipc	a5,0x7
    80001e50:	b7878793          	add	a5,a5,-1160 # 800089c4 <nextpid>
    80001e54:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001e56:	0014871b          	addw	a4,s1,1
    80001e5a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001e5c:	854a                	mv	a0,s2
    80001e5e:	fffff097          	auipc	ra,0xfffff
    80001e62:	f26080e7          	jalr	-218(ra) # 80000d84 <release>
}
    80001e66:	8526                	mv	a0,s1
    80001e68:	60e2                	ld	ra,24(sp)
    80001e6a:	6442                	ld	s0,16(sp)
    80001e6c:	64a2                	ld	s1,8(sp)
    80001e6e:	6902                	ld	s2,0(sp)
    80001e70:	6105                	add	sp,sp,32
    80001e72:	8082                	ret

0000000080001e74 <proc_pagetable>:
{
    80001e74:	1101                	add	sp,sp,-32
    80001e76:	ec06                	sd	ra,24(sp)
    80001e78:	e822                	sd	s0,16(sp)
    80001e7a:	e426                	sd	s1,8(sp)
    80001e7c:	e04a                	sd	s2,0(sp)
    80001e7e:	1000                	add	s0,sp,32
    80001e80:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001e82:	fffff097          	auipc	ra,0xfffff
    80001e86:	59e080e7          	jalr	1438(ra) # 80001420 <uvmcreate>
    80001e8a:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001e8c:	c121                	beqz	a0,80001ecc <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001e8e:	4729                	li	a4,10
    80001e90:	00005697          	auipc	a3,0x5
    80001e94:	17068693          	add	a3,a3,368 # 80007000 <_trampoline>
    80001e98:	6605                	lui	a2,0x1
    80001e9a:	040005b7          	lui	a1,0x4000
    80001e9e:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ea0:	05b2                	sll	a1,a1,0xc
    80001ea2:	fffff097          	auipc	ra,0xfffff
    80001ea6:	2f4080e7          	jalr	756(ra) # 80001196 <mappages>
    80001eaa:	02054863          	bltz	a0,80001eda <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001eae:	4719                	li	a4,6
    80001eb0:	05893683          	ld	a3,88(s2)
    80001eb4:	6605                	lui	a2,0x1
    80001eb6:	020005b7          	lui	a1,0x2000
    80001eba:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001ebc:	05b6                	sll	a1,a1,0xd
    80001ebe:	8526                	mv	a0,s1
    80001ec0:	fffff097          	auipc	ra,0xfffff
    80001ec4:	2d6080e7          	jalr	726(ra) # 80001196 <mappages>
    80001ec8:	02054163          	bltz	a0,80001eea <proc_pagetable+0x76>
}
    80001ecc:	8526                	mv	a0,s1
    80001ece:	60e2                	ld	ra,24(sp)
    80001ed0:	6442                	ld	s0,16(sp)
    80001ed2:	64a2                	ld	s1,8(sp)
    80001ed4:	6902                	ld	s2,0(sp)
    80001ed6:	6105                	add	sp,sp,32
    80001ed8:	8082                	ret
    uvmfree(pagetable, 0);
    80001eda:	4581                	li	a1,0
    80001edc:	8526                	mv	a0,s1
    80001ede:	fffff097          	auipc	ra,0xfffff
    80001ee2:	748080e7          	jalr	1864(ra) # 80001626 <uvmfree>
    return 0;
    80001ee6:	4481                	li	s1,0
    80001ee8:	b7d5                	j	80001ecc <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001eea:	4681                	li	a3,0
    80001eec:	4605                	li	a2,1
    80001eee:	040005b7          	lui	a1,0x4000
    80001ef2:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ef4:	05b2                	sll	a1,a1,0xc
    80001ef6:	8526                	mv	a0,s1
    80001ef8:	fffff097          	auipc	ra,0xfffff
    80001efc:	464080e7          	jalr	1124(ra) # 8000135c <uvmunmap>
    uvmfree(pagetable, 0);
    80001f00:	4581                	li	a1,0
    80001f02:	8526                	mv	a0,s1
    80001f04:	fffff097          	auipc	ra,0xfffff
    80001f08:	722080e7          	jalr	1826(ra) # 80001626 <uvmfree>
    return 0;
    80001f0c:	4481                	li	s1,0
    80001f0e:	bf7d                	j	80001ecc <proc_pagetable+0x58>

0000000080001f10 <proc_freepagetable>:
{
    80001f10:	1101                	add	sp,sp,-32
    80001f12:	ec06                	sd	ra,24(sp)
    80001f14:	e822                	sd	s0,16(sp)
    80001f16:	e426                	sd	s1,8(sp)
    80001f18:	e04a                	sd	s2,0(sp)
    80001f1a:	1000                	add	s0,sp,32
    80001f1c:	84aa                	mv	s1,a0
    80001f1e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001f20:	4681                	li	a3,0
    80001f22:	4605                	li	a2,1
    80001f24:	040005b7          	lui	a1,0x4000
    80001f28:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001f2a:	05b2                	sll	a1,a1,0xc
    80001f2c:	fffff097          	auipc	ra,0xfffff
    80001f30:	430080e7          	jalr	1072(ra) # 8000135c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001f34:	4681                	li	a3,0
    80001f36:	4605                	li	a2,1
    80001f38:	020005b7          	lui	a1,0x2000
    80001f3c:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001f3e:	05b6                	sll	a1,a1,0xd
    80001f40:	8526                	mv	a0,s1
    80001f42:	fffff097          	auipc	ra,0xfffff
    80001f46:	41a080e7          	jalr	1050(ra) # 8000135c <uvmunmap>
  uvmfree(pagetable, sz);
    80001f4a:	85ca                	mv	a1,s2
    80001f4c:	8526                	mv	a0,s1
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	6d8080e7          	jalr	1752(ra) # 80001626 <uvmfree>
}
    80001f56:	60e2                	ld	ra,24(sp)
    80001f58:	6442                	ld	s0,16(sp)
    80001f5a:	64a2                	ld	s1,8(sp)
    80001f5c:	6902                	ld	s2,0(sp)
    80001f5e:	6105                	add	sp,sp,32
    80001f60:	8082                	ret

0000000080001f62 <freeproc>:
{
    80001f62:	1101                	add	sp,sp,-32
    80001f64:	ec06                	sd	ra,24(sp)
    80001f66:	e822                	sd	s0,16(sp)
    80001f68:	e426                	sd	s1,8(sp)
    80001f6a:	1000                	add	s0,sp,32
    80001f6c:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001f6e:	6d28                	ld	a0,88(a0)
    80001f70:	c509                	beqz	a0,80001f7a <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001f72:	fffff097          	auipc	ra,0xfffff
    80001f76:	a72080e7          	jalr	-1422(ra) # 800009e4 <kfree>
  p->trapframe = 0;
    80001f7a:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001f7e:	68a8                	ld	a0,80(s1)
    80001f80:	c511                	beqz	a0,80001f8c <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001f82:	64ac                	ld	a1,72(s1)
    80001f84:	00000097          	auipc	ra,0x0
    80001f88:	f8c080e7          	jalr	-116(ra) # 80001f10 <proc_freepagetable>
  p->pagetable = 0;
    80001f8c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001f90:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001f94:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001f98:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001f9c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001fa0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001fa4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001fa8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001fac:	0004ac23          	sw	zero,24(s1)
  p->tick_ctr = 0; // MLFQ
    80001fb0:	1a04a823          	sw	zero,432(s1)
  p->ticks = 0;
    80001fb4:	1604aa23          	sw	zero,372(s1)
  p->handler = 0;
    80001fb8:	1804b823          	sd	zero,400(s1)
  p->sigalarm = 0;
    80001fbc:	1804b023          	sd	zero,384(s1)
  p->interval = -1;
    80001fc0:	57fd                	li	a5,-1
    80001fc2:	18f4ac23          	sw	a5,408(s1)
  p->current_ticks = 0;
    80001fc6:	1604ac23          	sw	zero,376(s1)
  p->curr_queue = -1;
    80001fca:	1af4a023          	sw	a5,416(s1)
  p->prev_queue = -1;
    80001fce:	1af4a223          	sw	a5,420(s1)
  p->time_wait = 0;
    80001fd2:	1a04a423          	sw	zero,424(s1)
  p->time_run_queue = 0;
    80001fd6:	1a04a623          	sw	zero,428(s1)
  p->queue_level = 0;
    80001fda:	1a04aa23          	sw	zero,436(s1)
  p->last_exec = ticks;
    80001fde:	00007797          	auipc	a5,0x7
    80001fe2:	a627a783          	lw	a5,-1438(a5) # 80008a40 <ticks>
    80001fe6:	1af4ac23          	sw	a5,440(s1)
  p->wait_time = 0; // PBS
    80001fea:	1c04a223          	sw	zero,452(s1)
  p->run_time = 0;
    80001fee:	1c04a023          	sw	zero,448(s1)
  p->priority = 0;  // static priority
    80001ff2:	1c04a623          	sw	zero,460(s1)
  p->dynamic_priority = 0;
    80001ff6:	1c04a823          	sw	zero,464(s1)
  p->sleep_time = 0;
    80001ffa:	1c04a423          	sw	zero,456(s1)
  p->num_shed = 0;
    80001ffe:	1c04aa23          	sw	zero,468(s1)
}
    80002002:	60e2                	ld	ra,24(sp)
    80002004:	6442                	ld	s0,16(sp)
    80002006:	64a2                	ld	s1,8(sp)
    80002008:	6105                	add	sp,sp,32
    8000200a:	8082                	ret

000000008000200c <allocproc>:
{
    8000200c:	1101                	add	sp,sp,-32
    8000200e:	ec06                	sd	ra,24(sp)
    80002010:	e822                	sd	s0,16(sp)
    80002012:	e426                	sd	s1,8(sp)
    80002014:	e04a                	sd	s2,0(sp)
    80002016:	1000                	add	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    80002018:	0022f497          	auipc	s1,0x22f
    8000201c:	0e048493          	add	s1,s1,224 # 802310f8 <proc>
    80002020:	00236917          	auipc	s2,0x236
    80002024:	6d890913          	add	s2,s2,1752 # 802386f8 <tickslock>
    acquire(&p->lock);
    80002028:	8526                	mv	a0,s1
    8000202a:	fffff097          	auipc	ra,0xfffff
    8000202e:	ca6080e7          	jalr	-858(ra) # 80000cd0 <acquire>
    if (p->state == UNUSED)
    80002032:	4c9c                	lw	a5,24(s1)
    80002034:	cfa1                	beqz	a5,8000208c <allocproc+0x80>
      release(&p->lock);
    80002036:	8526                	mv	a0,s1
    80002038:	fffff097          	auipc	ra,0xfffff
    8000203c:	d4c080e7          	jalr	-692(ra) # 80000d84 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002040:	1d848493          	add	s1,s1,472
    80002044:	ff2492e3          	bne	s1,s2,80002028 <allocproc+0x1c>
  for (p = proc; p < &proc[NPROC]; p++)
    80002048:	0022f497          	auipc	s1,0x22f
    8000204c:	0b048493          	add	s1,s1,176 # 802310f8 <proc>
    80002050:	00236917          	auipc	s2,0x236
    80002054:	6a890913          	add	s2,s2,1704 # 802386f8 <tickslock>
    acquire(&p->lock);
    80002058:	8526                	mv	a0,s1
    8000205a:	fffff097          	auipc	ra,0xfffff
    8000205e:	c76080e7          	jalr	-906(ra) # 80000cd0 <acquire>
    if (p->state == UNUSED)
    80002062:	4c9c                	lw	a5,24(s1)
    80002064:	c785                	beqz	a5,8000208c <allocproc+0x80>
      release(&p->lock);
    80002066:	8526                	mv	a0,s1
    80002068:	fffff097          	auipc	ra,0xfffff
    8000206c:	d1c080e7          	jalr	-740(ra) # 80000d84 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002070:	1d848493          	add	s1,s1,472
    80002074:	ff2492e3          	bne	s1,s2,80002058 <allocproc+0x4c>
  printf("allocproc: no usable process. Increase NPROC in param.h\n");
    80002078:	00006517          	auipc	a0,0x6
    8000207c:	25850513          	add	a0,a0,600 # 800082d0 <etext+0x2d0>
    80002080:	ffffe097          	auipc	ra,0xffffe
    80002084:	506080e7          	jalr	1286(ra) # 80000586 <printf>
  return 0;
    80002088:	4481                	li	s1,0
    8000208a:	a229                	j	80002194 <allocproc+0x188>
  p->pid = allocpid();
    8000208c:	00000097          	auipc	ra,0x0
    80002090:	da2080e7          	jalr	-606(ra) # 80001e2e <allocpid>
    80002094:	d888                	sw	a0,48(s1)
  p->state = USED;
    80002096:	4785                	li	a5,1
    80002098:	cc9c                	sw	a5,24(s1)
  p->tick_ctr = 0; // MLFQ
    8000209a:	1a04a823          	sw	zero,432(s1)
  p->queue_level = 0;
    8000209e:	1a04aa23          	sw	zero,436(s1)
  p->last_exec = ticks;
    800020a2:	00007797          	auipc	a5,0x7
    800020a6:	99e7a783          	lw	a5,-1634(a5) # 80008a40 <ticks>
    800020aa:	1af4ac23          	sw	a5,440(s1)
  p->ticks = 0;
    800020ae:	1604aa23          	sw	zero,372(s1)
  p->handler = 0;
    800020b2:	1804b823          	sd	zero,400(s1)
  p->sigalarm = 0;
    800020b6:	1804b023          	sd	zero,384(s1)
  p->interval = -1;
    800020ba:	57fd                	li	a5,-1
    800020bc:	18f4ac23          	sw	a5,408(s1)
  p->current_ticks = 0;
    800020c0:	1604ac23          	sw	zero,376(s1)
  p->curr_queue = -1;
    800020c4:	1af4a023          	sw	a5,416(s1)
  p->prev_queue = -1;
    800020c8:	1af4a223          	sw	a5,420(s1)
  p->time_wait = 0;
    800020cc:	1a04a423          	sw	zero,424(s1)
  p->time_run_queue = 0;
    800020d0:	1a04a623          	sw	zero,428(s1)
  p->wait_time = 0; // PBS
    800020d4:	1c04a223          	sw	zero,452(s1)
  p->run_time = 0;
    800020d8:	1c04a023          	sw	zero,448(s1)
  p->priority = 50;  // static priority
    800020dc:	03200793          	li	a5,50
    800020e0:	1cf4a623          	sw	a5,460(s1)
  p->dynamic_priority = 0;
    800020e4:	1c04a823          	sw	zero,464(s1)
  p->sleep_time = 0;
    800020e8:	1c04a423          	sw	zero,456(s1)
  p->num_shed = 0;
    800020ec:	1c04aa23          	sw	zero,468(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    800020f0:	fffff097          	auipc	ra,0xfffff
    800020f4:	a8e080e7          	jalr	-1394(ra) # 80000b7e <kalloc>
    800020f8:	892a                	mv	s2,a0
    800020fa:	eca8                	sd	a0,88(s1)
    800020fc:	c15d                	beqz	a0,800021a2 <allocproc+0x196>
  p->pagetable = proc_pagetable(p);
    800020fe:	8526                	mv	a0,s1
    80002100:	00000097          	auipc	ra,0x0
    80002104:	d74080e7          	jalr	-652(ra) # 80001e74 <proc_pagetable>
    80002108:	892a                	mv	s2,a0
    8000210a:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    8000210c:	c55d                	beqz	a0,800021ba <allocproc+0x1ae>
  memset(&p->context, 0, sizeof(p->context));
    8000210e:	07000613          	li	a2,112
    80002112:	4581                	li	a1,0
    80002114:	06048513          	add	a0,s1,96
    80002118:	fffff097          	auipc	ra,0xfffff
    8000211c:	cb4080e7          	jalr	-844(ra) # 80000dcc <memset>
  p->context.ra = (uint64)forkret;
    80002120:	00000797          	auipc	a5,0x0
    80002124:	cc878793          	add	a5,a5,-824 # 80001de8 <forkret>
    80002128:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000212a:	60bc                	ld	a5,64(s1)
    8000212c:	6705                	lui	a4,0x1
    8000212e:	97ba                	add	a5,a5,a4
    80002130:	f4bc                	sd	a5,104(s1)
  p->rtime = 0;
    80002132:	1604a423          	sw	zero,360(s1)
  p->etime = 0;
    80002136:	1604a823          	sw	zero,368(s1)
  p->ctime = ticks;
    8000213a:	00007797          	auipc	a5,0x7
    8000213e:	9067a783          	lw	a5,-1786(a5) # 80008a40 <ticks>
    80002142:	16f4a623          	sw	a5,364(s1)
  p->tick_ctr = 0; // MLFQ
    80002146:	1a04a823          	sw	zero,432(s1)
  p->queue_level = 0;
    8000214a:	1a04aa23          	sw	zero,436(s1)
  p->last_exec = ticks;
    8000214e:	1af4ac23          	sw	a5,440(s1)
  p->ticks = 0;
    80002152:	1604aa23          	sw	zero,372(s1)
  p->handler = 0;
    80002156:	1804b823          	sd	zero,400(s1)
  p->sigalarm = 0;
    8000215a:	1804b023          	sd	zero,384(s1)
  p->interval = -1;
    8000215e:	57fd                	li	a5,-1
    80002160:	18f4ac23          	sw	a5,408(s1)
  p->current_ticks = 0;
    80002164:	1604ac23          	sw	zero,376(s1)
  p->curr_queue = -1;
    80002168:	1af4a023          	sw	a5,416(s1)
  p->prev_queue = -1;
    8000216c:	1af4a223          	sw	a5,420(s1)
  p->time_wait = 0;
    80002170:	1a04a423          	sw	zero,424(s1)
  p->time_run_queue = 0;
    80002174:	1a04a623          	sw	zero,428(s1)
  p->wait_time = 0; // PBS
    80002178:	1c04a223          	sw	zero,452(s1)
  p->run_time = 0;
    8000217c:	1c04a023          	sw	zero,448(s1)
  p->priority = 50;  // static priority
    80002180:	03200793          	li	a5,50
    80002184:	1cf4a623          	sw	a5,460(s1)
  p->dynamic_priority = 0;
    80002188:	1c04a823          	sw	zero,464(s1)
  p->sleep_time = 0;
    8000218c:	1c04a423          	sw	zero,456(s1)
  p->num_shed = 0;
    80002190:	1c04aa23          	sw	zero,468(s1)
}
    80002194:	8526                	mv	a0,s1
    80002196:	60e2                	ld	ra,24(sp)
    80002198:	6442                	ld	s0,16(sp)
    8000219a:	64a2                	ld	s1,8(sp)
    8000219c:	6902                	ld	s2,0(sp)
    8000219e:	6105                	add	sp,sp,32
    800021a0:	8082                	ret
    freeproc(p);
    800021a2:	8526                	mv	a0,s1
    800021a4:	00000097          	auipc	ra,0x0
    800021a8:	dbe080e7          	jalr	-578(ra) # 80001f62 <freeproc>
    release(&p->lock);
    800021ac:	8526                	mv	a0,s1
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	bd6080e7          	jalr	-1066(ra) # 80000d84 <release>
    return 0;
    800021b6:	84ca                	mv	s1,s2
    800021b8:	bff1                	j	80002194 <allocproc+0x188>
    freeproc(p);
    800021ba:	8526                	mv	a0,s1
    800021bc:	00000097          	auipc	ra,0x0
    800021c0:	da6080e7          	jalr	-602(ra) # 80001f62 <freeproc>
    release(&p->lock);
    800021c4:	8526                	mv	a0,s1
    800021c6:	fffff097          	auipc	ra,0xfffff
    800021ca:	bbe080e7          	jalr	-1090(ra) # 80000d84 <release>
    return 0;
    800021ce:	84ca                	mv	s1,s2
    800021d0:	b7d1                	j	80002194 <allocproc+0x188>

00000000800021d2 <userinit>:
{
    800021d2:	1101                	add	sp,sp,-32
    800021d4:	ec06                	sd	ra,24(sp)
    800021d6:	e822                	sd	s0,16(sp)
    800021d8:	e426                	sd	s1,8(sp)
    800021da:	1000                	add	s0,sp,32
  p = allocproc();
    800021dc:	00000097          	auipc	ra,0x0
    800021e0:	e30080e7          	jalr	-464(ra) # 8000200c <allocproc>
    800021e4:	84aa                	mv	s1,a0
  initproc = p;
    800021e6:	00007797          	auipc	a5,0x7
    800021ea:	84a7b923          	sd	a0,-1966(a5) # 80008a38 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800021ee:	03400613          	li	a2,52
    800021f2:	00006597          	auipc	a1,0x6
    800021f6:	7de58593          	add	a1,a1,2014 # 800089d0 <initcode>
    800021fa:	6928                	ld	a0,80(a0)
    800021fc:	fffff097          	auipc	ra,0xfffff
    80002200:	252080e7          	jalr	594(ra) # 8000144e <uvmfirst>
  p->sz = PGSIZE;
    80002204:	6785                	lui	a5,0x1
    80002206:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    80002208:	6cb8                	ld	a4,88(s1)
    8000220a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    8000220e:	6cb8                	ld	a4,88(s1)
    80002210:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80002212:	4641                	li	a2,16
    80002214:	00006597          	auipc	a1,0x6
    80002218:	0fc58593          	add	a1,a1,252 # 80008310 <etext+0x310>
    8000221c:	15848513          	add	a0,s1,344
    80002220:	fffff097          	auipc	ra,0xfffff
    80002224:	cf4080e7          	jalr	-780(ra) # 80000f14 <safestrcpy>
  p->cwd = namei("/");
    80002228:	00006517          	auipc	a0,0x6
    8000222c:	0f850513          	add	a0,a0,248 # 80008320 <etext+0x320>
    80002230:	00002097          	auipc	ra,0x2
    80002234:	53a080e7          	jalr	1338(ra) # 8000476a <namei>
    80002238:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000223c:	478d                	li	a5,3
    8000223e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80002240:	8526                	mv	a0,s1
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	b42080e7          	jalr	-1214(ra) # 80000d84 <release>
}
    8000224a:	60e2                	ld	ra,24(sp)
    8000224c:	6442                	ld	s0,16(sp)
    8000224e:	64a2                	ld	s1,8(sp)
    80002250:	6105                	add	sp,sp,32
    80002252:	8082                	ret

0000000080002254 <growproc>:
{
    80002254:	1101                	add	sp,sp,-32
    80002256:	ec06                	sd	ra,24(sp)
    80002258:	e822                	sd	s0,16(sp)
    8000225a:	e426                	sd	s1,8(sp)
    8000225c:	e04a                	sd	s2,0(sp)
    8000225e:	1000                	add	s0,sp,32
    80002260:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80002262:	00000097          	auipc	ra,0x0
    80002266:	b4e080e7          	jalr	-1202(ra) # 80001db0 <myproc>
    8000226a:	84aa                	mv	s1,a0
  sz = p->sz;
    8000226c:	652c                	ld	a1,72(a0)
  if (n > 0)
    8000226e:	01204c63          	bgtz	s2,80002286 <growproc+0x32>
  else if (n < 0)
    80002272:	02094663          	bltz	s2,8000229e <growproc+0x4a>
  p->sz = sz;
    80002276:	e4ac                	sd	a1,72(s1)
  return 0;
    80002278:	4501                	li	a0,0
}
    8000227a:	60e2                	ld	ra,24(sp)
    8000227c:	6442                	ld	s0,16(sp)
    8000227e:	64a2                	ld	s1,8(sp)
    80002280:	6902                	ld	s2,0(sp)
    80002282:	6105                	add	sp,sp,32
    80002284:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80002286:	4691                	li	a3,4
    80002288:	00b90633          	add	a2,s2,a1
    8000228c:	6928                	ld	a0,80(a0)
    8000228e:	fffff097          	auipc	ra,0xfffff
    80002292:	27a080e7          	jalr	634(ra) # 80001508 <uvmalloc>
    80002296:	85aa                	mv	a1,a0
    80002298:	fd79                	bnez	a0,80002276 <growproc+0x22>
      return -1;
    8000229a:	557d                	li	a0,-1
    8000229c:	bff9                	j	8000227a <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000229e:	00b90633          	add	a2,s2,a1
    800022a2:	6928                	ld	a0,80(a0)
    800022a4:	fffff097          	auipc	ra,0xfffff
    800022a8:	21c080e7          	jalr	540(ra) # 800014c0 <uvmdealloc>
    800022ac:	85aa                	mv	a1,a0
    800022ae:	b7e1                	j	80002276 <growproc+0x22>

00000000800022b0 <fork>:
{
    800022b0:	7139                	add	sp,sp,-64
    800022b2:	fc06                	sd	ra,56(sp)
    800022b4:	f822                	sd	s0,48(sp)
    800022b6:	f426                	sd	s1,40(sp)
    800022b8:	f04a                	sd	s2,32(sp)
    800022ba:	ec4e                	sd	s3,24(sp)
    800022bc:	e852                	sd	s4,16(sp)
    800022be:	e456                	sd	s5,8(sp)
    800022c0:	0080                	add	s0,sp,64
  struct proc *p = myproc();
    800022c2:	00000097          	auipc	ra,0x0
    800022c6:	aee080e7          	jalr	-1298(ra) # 80001db0 <myproc>
    800022ca:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0)
    800022cc:	00000097          	auipc	ra,0x0
    800022d0:	d40080e7          	jalr	-704(ra) # 8000200c <allocproc>
    800022d4:	10050c63          	beqz	a0,800023ec <fork+0x13c>
    800022d8:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)         // COW should stop memory copy
    800022da:	048ab603          	ld	a2,72(s5)
    800022de:	692c                	ld	a1,80(a0)
    800022e0:	050ab503          	ld	a0,80(s5)
    800022e4:	fffff097          	auipc	ra,0xfffff
    800022e8:	37c080e7          	jalr	892(ra) # 80001660 <uvmcopy>
    800022ec:	04054863          	bltz	a0,8000233c <fork+0x8c>
  np->sz = p->sz;
    800022f0:	048ab783          	ld	a5,72(s5)
    800022f4:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800022f8:	058ab683          	ld	a3,88(s5)
    800022fc:	87b6                	mv	a5,a3
    800022fe:	058a3703          	ld	a4,88(s4)
    80002302:	12068693          	add	a3,a3,288
    80002306:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000230a:	6788                	ld	a0,8(a5)
    8000230c:	6b8c                	ld	a1,16(a5)
    8000230e:	6f90                	ld	a2,24(a5)
    80002310:	01073023          	sd	a6,0(a4)
    80002314:	e708                	sd	a0,8(a4)
    80002316:	eb0c                	sd	a1,16(a4)
    80002318:	ef10                	sd	a2,24(a4)
    8000231a:	02078793          	add	a5,a5,32
    8000231e:	02070713          	add	a4,a4,32
    80002322:	fed792e3          	bne	a5,a3,80002306 <fork+0x56>
  np->trapframe->a0 = 0;
    80002326:	058a3783          	ld	a5,88(s4)
    8000232a:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    8000232e:	0d0a8493          	add	s1,s5,208
    80002332:	0d0a0913          	add	s2,s4,208
    80002336:	150a8993          	add	s3,s5,336
    8000233a:	a00d                	j	8000235c <fork+0xac>
    freeproc(np);
    8000233c:	8552                	mv	a0,s4
    8000233e:	00000097          	auipc	ra,0x0
    80002342:	c24080e7          	jalr	-988(ra) # 80001f62 <freeproc>
    release(&np->lock);
    80002346:	8552                	mv	a0,s4
    80002348:	fffff097          	auipc	ra,0xfffff
    8000234c:	a3c080e7          	jalr	-1476(ra) # 80000d84 <release>
    return -1;
    80002350:	597d                	li	s2,-1
    80002352:	a059                	j	800023d8 <fork+0x128>
  for (i = 0; i < NOFILE; i++)
    80002354:	04a1                	add	s1,s1,8
    80002356:	0921                	add	s2,s2,8
    80002358:	01348b63          	beq	s1,s3,8000236e <fork+0xbe>
    if (p->ofile[i])
    8000235c:	6088                	ld	a0,0(s1)
    8000235e:	d97d                	beqz	a0,80002354 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80002360:	00003097          	auipc	ra,0x3
    80002364:	a7c080e7          	jalr	-1412(ra) # 80004ddc <filedup>
    80002368:	00a93023          	sd	a0,0(s2)
    8000236c:	b7e5                	j	80002354 <fork+0xa4>
  np->cwd = idup(p->cwd);
    8000236e:	150ab503          	ld	a0,336(s5)
    80002372:	00002097          	auipc	ra,0x2
    80002376:	c14080e7          	jalr	-1004(ra) # 80003f86 <idup>
    8000237a:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000237e:	4641                	li	a2,16
    80002380:	158a8593          	add	a1,s5,344
    80002384:	158a0513          	add	a0,s4,344
    80002388:	fffff097          	auipc	ra,0xfffff
    8000238c:	b8c080e7          	jalr	-1140(ra) # 80000f14 <safestrcpy>
  pid = np->pid;
    80002390:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80002394:	8552                	mv	a0,s4
    80002396:	fffff097          	auipc	ra,0xfffff
    8000239a:	9ee080e7          	jalr	-1554(ra) # 80000d84 <release>
  acquire(&wait_lock);
    8000239e:	0022f497          	auipc	s1,0x22f
    800023a2:	d4248493          	add	s1,s1,-702 # 802310e0 <wait_lock>
    800023a6:	8526                	mv	a0,s1
    800023a8:	fffff097          	auipc	ra,0xfffff
    800023ac:	928080e7          	jalr	-1752(ra) # 80000cd0 <acquire>
  np->parent = p;
    800023b0:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800023b4:	8526                	mv	a0,s1
    800023b6:	fffff097          	auipc	ra,0xfffff
    800023ba:	9ce080e7          	jalr	-1586(ra) # 80000d84 <release>
  acquire(&np->lock);
    800023be:	8552                	mv	a0,s4
    800023c0:	fffff097          	auipc	ra,0xfffff
    800023c4:	910080e7          	jalr	-1776(ra) # 80000cd0 <acquire>
  np->state = RUNNABLE;
    800023c8:	478d                	li	a5,3
    800023ca:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800023ce:	8552                	mv	a0,s4
    800023d0:	fffff097          	auipc	ra,0xfffff
    800023d4:	9b4080e7          	jalr	-1612(ra) # 80000d84 <release>
}
    800023d8:	854a                	mv	a0,s2
    800023da:	70e2                	ld	ra,56(sp)
    800023dc:	7442                	ld	s0,48(sp)
    800023de:	74a2                	ld	s1,40(sp)
    800023e0:	7902                	ld	s2,32(sp)
    800023e2:	69e2                	ld	s3,24(sp)
    800023e4:	6a42                	ld	s4,16(sp)
    800023e6:	6aa2                	ld	s5,8(sp)
    800023e8:	6121                	add	sp,sp,64
    800023ea:	8082                	ret
    return -1;
    800023ec:	597d                	li	s2,-1
    800023ee:	b7ed                	j	800023d8 <fork+0x128>

00000000800023f0 <scheduler>:
{
    800023f0:	1141                	add	sp,sp,-16
    800023f2:	e406                	sd	ra,8(sp)
    800023f4:	e022                	sd	s0,0(sp)
    800023f6:	0800                	add	s0,sp,16
    800023f8:	8792                	mv	a5,tp
  c->proc = 0;
    800023fa:	2781                	sext.w	a5,a5
    800023fc:	079e                	sll	a5,a5,0x7
    800023fe:	0022f717          	auipc	a4,0x22f
    80002402:	8ca70713          	add	a4,a4,-1846 # 80230cc8 <cpus>
    80002406:	97ba                	add	a5,a5,a4
    80002408:	0007b023          	sd	zero,0(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000240c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002410:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002414:	10079073          	csrw	sstatus,a5
    sched_pbs();
    80002418:	fffff097          	auipc	ra,0xfffff
    8000241c:	694080e7          	jalr	1684(ra) # 80001aac <sched_pbs>
  for (;;)
    80002420:	b7f5                	j	8000240c <scheduler+0x1c>

0000000080002422 <sched>:
{
    80002422:	7179                	add	sp,sp,-48
    80002424:	f406                	sd	ra,40(sp)
    80002426:	f022                	sd	s0,32(sp)
    80002428:	ec26                	sd	s1,24(sp)
    8000242a:	e84a                	sd	s2,16(sp)
    8000242c:	e44e                	sd	s3,8(sp)
    8000242e:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80002430:	00000097          	auipc	ra,0x0
    80002434:	980080e7          	jalr	-1664(ra) # 80001db0 <myproc>
    80002438:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    8000243a:	fffff097          	auipc	ra,0xfffff
    8000243e:	81c080e7          	jalr	-2020(ra) # 80000c56 <holding>
    80002442:	c53d                	beqz	a0,800024b0 <sched+0x8e>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002444:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80002446:	2781                	sext.w	a5,a5
    80002448:	079e                	sll	a5,a5,0x7
    8000244a:	0022f717          	auipc	a4,0x22f
    8000244e:	87e70713          	add	a4,a4,-1922 # 80230cc8 <cpus>
    80002452:	97ba                	add	a5,a5,a4
    80002454:	5fb8                	lw	a4,120(a5)
    80002456:	4785                	li	a5,1
    80002458:	06f71463          	bne	a4,a5,800024c0 <sched+0x9e>
  if (p->state == RUNNING)
    8000245c:	4c98                	lw	a4,24(s1)
    8000245e:	4791                	li	a5,4
    80002460:	06f70863          	beq	a4,a5,800024d0 <sched+0xae>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002464:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002468:	8b89                	and	a5,a5,2
  if (intr_get())
    8000246a:	ebbd                	bnez	a5,800024e0 <sched+0xbe>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000246c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000246e:	0022f917          	auipc	s2,0x22f
    80002472:	85a90913          	add	s2,s2,-1958 # 80230cc8 <cpus>
    80002476:	2781                	sext.w	a5,a5
    80002478:	079e                	sll	a5,a5,0x7
    8000247a:	97ca                	add	a5,a5,s2
    8000247c:	07c7a983          	lw	s3,124(a5)
    80002480:	8592                	mv	a1,tp
  swtch(&p->context, &mycpu()->context);
    80002482:	2581                	sext.w	a1,a1
    80002484:	059e                	sll	a1,a1,0x7
    80002486:	05a1                	add	a1,a1,8
    80002488:	95ca                	add	a1,a1,s2
    8000248a:	06048513          	add	a0,s1,96
    8000248e:	00000097          	auipc	ra,0x0
    80002492:	7e8080e7          	jalr	2024(ra) # 80002c76 <swtch>
    80002496:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002498:	2781                	sext.w	a5,a5
    8000249a:	079e                	sll	a5,a5,0x7
    8000249c:	993e                	add	s2,s2,a5
    8000249e:	07392e23          	sw	s3,124(s2)
}
    800024a2:	70a2                	ld	ra,40(sp)
    800024a4:	7402                	ld	s0,32(sp)
    800024a6:	64e2                	ld	s1,24(sp)
    800024a8:	6942                	ld	s2,16(sp)
    800024aa:	69a2                	ld	s3,8(sp)
    800024ac:	6145                	add	sp,sp,48
    800024ae:	8082                	ret
    panic("sched p->lock");
    800024b0:	00006517          	auipc	a0,0x6
    800024b4:	e7850513          	add	a0,a0,-392 # 80008328 <etext+0x328>
    800024b8:	ffffe097          	auipc	ra,0xffffe
    800024bc:	084080e7          	jalr	132(ra) # 8000053c <panic>
    panic("sched locks");
    800024c0:	00006517          	auipc	a0,0x6
    800024c4:	e7850513          	add	a0,a0,-392 # 80008338 <etext+0x338>
    800024c8:	ffffe097          	auipc	ra,0xffffe
    800024cc:	074080e7          	jalr	116(ra) # 8000053c <panic>
    panic("sched running");
    800024d0:	00006517          	auipc	a0,0x6
    800024d4:	e7850513          	add	a0,a0,-392 # 80008348 <etext+0x348>
    800024d8:	ffffe097          	auipc	ra,0xffffe
    800024dc:	064080e7          	jalr	100(ra) # 8000053c <panic>
    panic("sched interruptible");
    800024e0:	00006517          	auipc	a0,0x6
    800024e4:	e7850513          	add	a0,a0,-392 # 80008358 <etext+0x358>
    800024e8:	ffffe097          	auipc	ra,0xffffe
    800024ec:	054080e7          	jalr	84(ra) # 8000053c <panic>

00000000800024f0 <yield>:
{
    800024f0:	1101                	add	sp,sp,-32
    800024f2:	ec06                	sd	ra,24(sp)
    800024f4:	e822                	sd	s0,16(sp)
    800024f6:	e426                	sd	s1,8(sp)
    800024f8:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    800024fa:	00000097          	auipc	ra,0x0
    800024fe:	8b6080e7          	jalr	-1866(ra) # 80001db0 <myproc>
    80002502:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002504:	ffffe097          	auipc	ra,0xffffe
    80002508:	7cc080e7          	jalr	1996(ra) # 80000cd0 <acquire>
  p->state = RUNNABLE;
    8000250c:	478d                	li	a5,3
    8000250e:	cc9c                	sw	a5,24(s1)
  sched();
    80002510:	00000097          	auipc	ra,0x0
    80002514:	f12080e7          	jalr	-238(ra) # 80002422 <sched>
  release(&p->lock);
    80002518:	8526                	mv	a0,s1
    8000251a:	fffff097          	auipc	ra,0xfffff
    8000251e:	86a080e7          	jalr	-1942(ra) # 80000d84 <release>
}
    80002522:	60e2                	ld	ra,24(sp)
    80002524:	6442                	ld	s0,16(sp)
    80002526:	64a2                	ld	s1,8(sp)
    80002528:	6105                	add	sp,sp,32
    8000252a:	8082                	ret

000000008000252c <wakeup>:
{
    8000252c:	7139                	add	sp,sp,-64
    8000252e:	fc06                	sd	ra,56(sp)
    80002530:	f822                	sd	s0,48(sp)
    80002532:	f426                	sd	s1,40(sp)
    80002534:	f04a                	sd	s2,32(sp)
    80002536:	ec4e                	sd	s3,24(sp)
    80002538:	e852                	sd	s4,16(sp)
    8000253a:	e456                	sd	s5,8(sp)
    8000253c:	e05a                	sd	s6,0(sp)
    8000253e:	0080                	add	s0,sp,64
    80002540:	8a2a                	mv	s4,a0
  for (p = proc; p < &proc[NPROC]; p++)
    80002542:	0022f497          	auipc	s1,0x22f
    80002546:	bb648493          	add	s1,s1,-1098 # 802310f8 <proc>
      if (p->state == SLEEPING && p->chan == chan)
    8000254a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000254c:	4b0d                	li	s6,3
        p->last_exec = ticks;
    8000254e:	00006a97          	auipc	s5,0x6
    80002552:	4f2a8a93          	add	s5,s5,1266 # 80008a40 <ticks>
  for (p = proc; p < &proc[NPROC]; p++)
    80002556:	00236917          	auipc	s2,0x236
    8000255a:	1a290913          	add	s2,s2,418 # 802386f8 <tickslock>
    8000255e:	a811                	j	80002572 <wakeup+0x46>
      release(&p->lock);
    80002560:	8526                	mv	a0,s1
    80002562:	fffff097          	auipc	ra,0xfffff
    80002566:	822080e7          	jalr	-2014(ra) # 80000d84 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    8000256a:	1d848493          	add	s1,s1,472
    8000256e:	03248e63          	beq	s1,s2,800025aa <wakeup+0x7e>
    if (p != myproc())
    80002572:	00000097          	auipc	ra,0x0
    80002576:	83e080e7          	jalr	-1986(ra) # 80001db0 <myproc>
    8000257a:	fea488e3          	beq	s1,a0,8000256a <wakeup+0x3e>
      acquire(&p->lock);
    8000257e:	8526                	mv	a0,s1
    80002580:	ffffe097          	auipc	ra,0xffffe
    80002584:	750080e7          	jalr	1872(ra) # 80000cd0 <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    80002588:	4c9c                	lw	a5,24(s1)
    8000258a:	fd379be3          	bne	a5,s3,80002560 <wakeup+0x34>
    8000258e:	709c                	ld	a5,32(s1)
    80002590:	fd4798e3          	bne	a5,s4,80002560 <wakeup+0x34>
        p->state = RUNNABLE;
    80002594:	0164ac23          	sw	s6,24(s1)
        p->last_exec = ticks;
    80002598:	000aa783          	lw	a5,0(s5)
    8000259c:	1af4ac23          	sw	a5,440(s1)
        p->tick_ctr = 0;
    800025a0:	1a04a823          	sw	zero,432(s1)
        p->in_time = ticks;
    800025a4:	1af4ae23          	sw	a5,444(s1)
    800025a8:	bf65                	j	80002560 <wakeup+0x34>
}
    800025aa:	70e2                	ld	ra,56(sp)
    800025ac:	7442                	ld	s0,48(sp)
    800025ae:	74a2                	ld	s1,40(sp)
    800025b0:	7902                	ld	s2,32(sp)
    800025b2:	69e2                	ld	s3,24(sp)
    800025b4:	6a42                	ld	s4,16(sp)
    800025b6:	6aa2                	ld	s5,8(sp)
    800025b8:	6b02                	ld	s6,0(sp)
    800025ba:	6121                	add	sp,sp,64
    800025bc:	8082                	ret

00000000800025be <reparent>:
{
    800025be:	7179                	add	sp,sp,-48
    800025c0:	f406                	sd	ra,40(sp)
    800025c2:	f022                	sd	s0,32(sp)
    800025c4:	ec26                	sd	s1,24(sp)
    800025c6:	e84a                	sd	s2,16(sp)
    800025c8:	e44e                	sd	s3,8(sp)
    800025ca:	e052                	sd	s4,0(sp)
    800025cc:	1800                	add	s0,sp,48
    800025ce:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800025d0:	0022f497          	auipc	s1,0x22f
    800025d4:	b2848493          	add	s1,s1,-1240 # 802310f8 <proc>
      pp->parent = initproc;
    800025d8:	00006a17          	auipc	s4,0x6
    800025dc:	460a0a13          	add	s4,s4,1120 # 80008a38 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800025e0:	00236997          	auipc	s3,0x236
    800025e4:	11898993          	add	s3,s3,280 # 802386f8 <tickslock>
    800025e8:	a029                	j	800025f2 <reparent+0x34>
    800025ea:	1d848493          	add	s1,s1,472
    800025ee:	01348d63          	beq	s1,s3,80002608 <reparent+0x4a>
    if (pp->parent == p)
    800025f2:	7c9c                	ld	a5,56(s1)
    800025f4:	ff279be3          	bne	a5,s2,800025ea <reparent+0x2c>
      pp->parent = initproc;
    800025f8:	000a3503          	ld	a0,0(s4)
    800025fc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800025fe:	00000097          	auipc	ra,0x0
    80002602:	f2e080e7          	jalr	-210(ra) # 8000252c <wakeup>
    80002606:	b7d5                	j	800025ea <reparent+0x2c>
}
    80002608:	70a2                	ld	ra,40(sp)
    8000260a:	7402                	ld	s0,32(sp)
    8000260c:	64e2                	ld	s1,24(sp)
    8000260e:	6942                	ld	s2,16(sp)
    80002610:	69a2                	ld	s3,8(sp)
    80002612:	6a02                	ld	s4,0(sp)
    80002614:	6145                	add	sp,sp,48
    80002616:	8082                	ret

0000000080002618 <exit>:
{
    80002618:	7179                	add	sp,sp,-48
    8000261a:	f406                	sd	ra,40(sp)
    8000261c:	f022                	sd	s0,32(sp)
    8000261e:	ec26                	sd	s1,24(sp)
    80002620:	e84a                	sd	s2,16(sp)
    80002622:	e44e                	sd	s3,8(sp)
    80002624:	e052                	sd	s4,0(sp)
    80002626:	1800                	add	s0,sp,48
    80002628:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000262a:	fffff097          	auipc	ra,0xfffff
    8000262e:	786080e7          	jalr	1926(ra) # 80001db0 <myproc>
    80002632:	89aa                	mv	s3,a0
  if (p == initproc)
    80002634:	00006797          	auipc	a5,0x6
    80002638:	4047b783          	ld	a5,1028(a5) # 80008a38 <initproc>
    8000263c:	0d050493          	add	s1,a0,208
    80002640:	15050913          	add	s2,a0,336
    80002644:	02a79363          	bne	a5,a0,8000266a <exit+0x52>
    panic("init exiting");
    80002648:	00006517          	auipc	a0,0x6
    8000264c:	d2850513          	add	a0,a0,-728 # 80008370 <etext+0x370>
    80002650:	ffffe097          	auipc	ra,0xffffe
    80002654:	eec080e7          	jalr	-276(ra) # 8000053c <panic>
      fileclose(f);
    80002658:	00002097          	auipc	ra,0x2
    8000265c:	7d6080e7          	jalr	2006(ra) # 80004e2e <fileclose>
      p->ofile[fd] = 0;
    80002660:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    80002664:	04a1                	add	s1,s1,8
    80002666:	01248563          	beq	s1,s2,80002670 <exit+0x58>
    if (p->ofile[fd])
    8000266a:	6088                	ld	a0,0(s1)
    8000266c:	f575                	bnez	a0,80002658 <exit+0x40>
    8000266e:	bfdd                	j	80002664 <exit+0x4c>
  begin_op();
    80002670:	00002097          	auipc	ra,0x2
    80002674:	2fa080e7          	jalr	762(ra) # 8000496a <begin_op>
  iput(p->cwd);
    80002678:	1509b503          	ld	a0,336(s3)
    8000267c:	00002097          	auipc	ra,0x2
    80002680:	b02080e7          	jalr	-1278(ra) # 8000417e <iput>
  end_op();
    80002684:	00002097          	auipc	ra,0x2
    80002688:	360080e7          	jalr	864(ra) # 800049e4 <end_op>
  p->cwd = 0;
    8000268c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002690:	0022f497          	auipc	s1,0x22f
    80002694:	a5048493          	add	s1,s1,-1456 # 802310e0 <wait_lock>
    80002698:	8526                	mv	a0,s1
    8000269a:	ffffe097          	auipc	ra,0xffffe
    8000269e:	636080e7          	jalr	1590(ra) # 80000cd0 <acquire>
  reparent(p);
    800026a2:	854e                	mv	a0,s3
    800026a4:	00000097          	auipc	ra,0x0
    800026a8:	f1a080e7          	jalr	-230(ra) # 800025be <reparent>
  wakeup(p->parent);
    800026ac:	0389b503          	ld	a0,56(s3)
    800026b0:	00000097          	auipc	ra,0x0
    800026b4:	e7c080e7          	jalr	-388(ra) # 8000252c <wakeup>
  acquire(&p->lock);
    800026b8:	854e                	mv	a0,s3
    800026ba:	ffffe097          	auipc	ra,0xffffe
    800026be:	616080e7          	jalr	1558(ra) # 80000cd0 <acquire>
  p->xstate = status;
    800026c2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800026c6:	4795                	li	a5,5
    800026c8:	00f9ac23          	sw	a5,24(s3)
  p->etime = ticks;
    800026cc:	00006797          	auipc	a5,0x6
    800026d0:	3747a783          	lw	a5,884(a5) # 80008a40 <ticks>
    800026d4:	16f9a823          	sw	a5,368(s3)
  release(&wait_lock);
    800026d8:	8526                	mv	a0,s1
    800026da:	ffffe097          	auipc	ra,0xffffe
    800026de:	6aa080e7          	jalr	1706(ra) # 80000d84 <release>
  sched();
    800026e2:	00000097          	auipc	ra,0x0
    800026e6:	d40080e7          	jalr	-704(ra) # 80002422 <sched>
  panic("zombie exit");
    800026ea:	00006517          	auipc	a0,0x6
    800026ee:	c9650513          	add	a0,a0,-874 # 80008380 <etext+0x380>
    800026f2:	ffffe097          	auipc	ra,0xffffe
    800026f6:	e4a080e7          	jalr	-438(ra) # 8000053c <panic>

00000000800026fa <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800026fa:	7179                	add	sp,sp,-48
    800026fc:	f406                	sd	ra,40(sp)
    800026fe:	f022                	sd	s0,32(sp)
    80002700:	ec26                	sd	s1,24(sp)
    80002702:	e84a                	sd	s2,16(sp)
    80002704:	e44e                	sd	s3,8(sp)
    80002706:	1800                	add	s0,sp,48
    80002708:	89aa                	mv	s3,a0
    8000270a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000270c:	fffff097          	auipc	ra,0xfffff
    80002710:	6a4080e7          	jalr	1700(ra) # 80001db0 <myproc>
    80002714:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    80002716:	ffffe097          	auipc	ra,0xffffe
    8000271a:	5ba080e7          	jalr	1466(ra) # 80000cd0 <acquire>
  release(lk);
    8000271e:	854a                	mv	a0,s2
    80002720:	ffffe097          	auipc	ra,0xffffe
    80002724:	664080e7          	jalr	1636(ra) # 80000d84 <release>

  // Go to sleep.
  p->chan = chan;
    80002728:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000272c:	4789                	li	a5,2
    8000272e:	cc9c                	sw	a5,24(s1)

  sched();
    80002730:	00000097          	auipc	ra,0x0
    80002734:	cf2080e7          	jalr	-782(ra) # 80002422 <sched>

  // Tidy up.
  p->chan = 0;
    80002738:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000273c:	8526                	mv	a0,s1
    8000273e:	ffffe097          	auipc	ra,0xffffe
    80002742:	646080e7          	jalr	1606(ra) # 80000d84 <release>
  acquire(lk);
    80002746:	854a                	mv	a0,s2
    80002748:	ffffe097          	auipc	ra,0xffffe
    8000274c:	588080e7          	jalr	1416(ra) # 80000cd0 <acquire>
}
    80002750:	70a2                	ld	ra,40(sp)
    80002752:	7402                	ld	s0,32(sp)
    80002754:	64e2                	ld	s1,24(sp)
    80002756:	6942                	ld	s2,16(sp)
    80002758:	69a2                	ld	s3,8(sp)
    8000275a:	6145                	add	sp,sp,48
    8000275c:	8082                	ret

000000008000275e <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    8000275e:	7179                	add	sp,sp,-48
    80002760:	f406                	sd	ra,40(sp)
    80002762:	f022                	sd	s0,32(sp)
    80002764:	ec26                	sd	s1,24(sp)
    80002766:	e84a                	sd	s2,16(sp)
    80002768:	e44e                	sd	s3,8(sp)
    8000276a:	1800                	add	s0,sp,48
    8000276c:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    8000276e:	0022f497          	auipc	s1,0x22f
    80002772:	98a48493          	add	s1,s1,-1654 # 802310f8 <proc>
    80002776:	00236997          	auipc	s3,0x236
    8000277a:	f8298993          	add	s3,s3,-126 # 802386f8 <tickslock>
  {
    acquire(&p->lock);
    8000277e:	8526                	mv	a0,s1
    80002780:	ffffe097          	auipc	ra,0xffffe
    80002784:	550080e7          	jalr	1360(ra) # 80000cd0 <acquire>
    if (p->pid == pid)
    80002788:	589c                	lw	a5,48(s1)
    8000278a:	01278d63          	beq	a5,s2,800027a4 <kill+0x46>
        p->tick_ctr = 0;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000278e:	8526                	mv	a0,s1
    80002790:	ffffe097          	auipc	ra,0xffffe
    80002794:	5f4080e7          	jalr	1524(ra) # 80000d84 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002798:	1d848493          	add	s1,s1,472
    8000279c:	ff3491e3          	bne	s1,s3,8000277e <kill+0x20>
  }
  return -1;
    800027a0:	557d                	li	a0,-1
    800027a2:	a829                	j	800027bc <kill+0x5e>
      p->killed = 1;
    800027a4:	4785                	li	a5,1
    800027a6:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    800027a8:	4c98                	lw	a4,24(s1)
    800027aa:	4789                	li	a5,2
    800027ac:	00f70f63          	beq	a4,a5,800027ca <kill+0x6c>
      release(&p->lock);
    800027b0:	8526                	mv	a0,s1
    800027b2:	ffffe097          	auipc	ra,0xffffe
    800027b6:	5d2080e7          	jalr	1490(ra) # 80000d84 <release>
      return 0;
    800027ba:	4501                	li	a0,0
}
    800027bc:	70a2                	ld	ra,40(sp)
    800027be:	7402                	ld	s0,32(sp)
    800027c0:	64e2                	ld	s1,24(sp)
    800027c2:	6942                	ld	s2,16(sp)
    800027c4:	69a2                	ld	s3,8(sp)
    800027c6:	6145                	add	sp,sp,48
    800027c8:	8082                	ret
        p->state = RUNNABLE;
    800027ca:	478d                	li	a5,3
    800027cc:	cc9c                	sw	a5,24(s1)
        p->last_exec = ticks;
    800027ce:	00006797          	auipc	a5,0x6
    800027d2:	2727a783          	lw	a5,626(a5) # 80008a40 <ticks>
    800027d6:	1af4ac23          	sw	a5,440(s1)
        p->in_time = ticks;
    800027da:	1af4ae23          	sw	a5,444(s1)
        p->tick_ctr = 0;
    800027de:	1a04a823          	sw	zero,432(s1)
    800027e2:	b7f9                	j	800027b0 <kill+0x52>

00000000800027e4 <setkilled>:

void setkilled(struct proc *p)
{
    800027e4:	1101                	add	sp,sp,-32
    800027e6:	ec06                	sd	ra,24(sp)
    800027e8:	e822                	sd	s0,16(sp)
    800027ea:	e426                	sd	s1,8(sp)
    800027ec:	1000                	add	s0,sp,32
    800027ee:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800027f0:	ffffe097          	auipc	ra,0xffffe
    800027f4:	4e0080e7          	jalr	1248(ra) # 80000cd0 <acquire>
  p->killed = 1;
    800027f8:	4785                	li	a5,1
    800027fa:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800027fc:	8526                	mv	a0,s1
    800027fe:	ffffe097          	auipc	ra,0xffffe
    80002802:	586080e7          	jalr	1414(ra) # 80000d84 <release>
}
    80002806:	60e2                	ld	ra,24(sp)
    80002808:	6442                	ld	s0,16(sp)
    8000280a:	64a2                	ld	s1,8(sp)
    8000280c:	6105                	add	sp,sp,32
    8000280e:	8082                	ret

0000000080002810 <killed>:

int killed(struct proc *p)
{
    80002810:	1101                	add	sp,sp,-32
    80002812:	ec06                	sd	ra,24(sp)
    80002814:	e822                	sd	s0,16(sp)
    80002816:	e426                	sd	s1,8(sp)
    80002818:	e04a                	sd	s2,0(sp)
    8000281a:	1000                	add	s0,sp,32
    8000281c:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    8000281e:	ffffe097          	auipc	ra,0xffffe
    80002822:	4b2080e7          	jalr	1202(ra) # 80000cd0 <acquire>
  k = p->killed;
    80002826:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000282a:	8526                	mv	a0,s1
    8000282c:	ffffe097          	auipc	ra,0xffffe
    80002830:	558080e7          	jalr	1368(ra) # 80000d84 <release>
  return k;
}
    80002834:	854a                	mv	a0,s2
    80002836:	60e2                	ld	ra,24(sp)
    80002838:	6442                	ld	s0,16(sp)
    8000283a:	64a2                	ld	s1,8(sp)
    8000283c:	6902                	ld	s2,0(sp)
    8000283e:	6105                	add	sp,sp,32
    80002840:	8082                	ret

0000000080002842 <wait>:
{
    80002842:	715d                	add	sp,sp,-80
    80002844:	e486                	sd	ra,72(sp)
    80002846:	e0a2                	sd	s0,64(sp)
    80002848:	fc26                	sd	s1,56(sp)
    8000284a:	f84a                	sd	s2,48(sp)
    8000284c:	f44e                	sd	s3,40(sp)
    8000284e:	f052                	sd	s4,32(sp)
    80002850:	ec56                	sd	s5,24(sp)
    80002852:	e85a                	sd	s6,16(sp)
    80002854:	e45e                	sd	s7,8(sp)
    80002856:	e062                	sd	s8,0(sp)
    80002858:	0880                	add	s0,sp,80
    8000285a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000285c:	fffff097          	auipc	ra,0xfffff
    80002860:	554080e7          	jalr	1364(ra) # 80001db0 <myproc>
    80002864:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002866:	0022f517          	auipc	a0,0x22f
    8000286a:	87a50513          	add	a0,a0,-1926 # 802310e0 <wait_lock>
    8000286e:	ffffe097          	auipc	ra,0xffffe
    80002872:	462080e7          	jalr	1122(ra) # 80000cd0 <acquire>
    havekids = 0;
    80002876:	4b81                	li	s7,0
        if (pp->state == ZOMBIE)
    80002878:	4a15                	li	s4,5
        havekids = 1;
    8000287a:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++)
    8000287c:	00236997          	auipc	s3,0x236
    80002880:	e7c98993          	add	s3,s3,-388 # 802386f8 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002884:	0022fc17          	auipc	s8,0x22f
    80002888:	85cc0c13          	add	s8,s8,-1956 # 802310e0 <wait_lock>
    8000288c:	a0d1                	j	80002950 <wait+0x10e>
          pid = pp->pid;
    8000288e:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002892:	000b0e63          	beqz	s6,800028ae <wait+0x6c>
    80002896:	4691                	li	a3,4
    80002898:	02c48613          	add	a2,s1,44
    8000289c:	85da                	mv	a1,s6
    8000289e:	05093503          	ld	a0,80(s2)
    800028a2:	fffff097          	auipc	ra,0xfffff
    800028a6:	006080e7          	jalr	6(ra) # 800018a8 <copyout>
    800028aa:	04054163          	bltz	a0,800028ec <wait+0xaa>
          freeproc(pp);
    800028ae:	8526                	mv	a0,s1
    800028b0:	fffff097          	auipc	ra,0xfffff
    800028b4:	6b2080e7          	jalr	1714(ra) # 80001f62 <freeproc>
          release(&pp->lock);
    800028b8:	8526                	mv	a0,s1
    800028ba:	ffffe097          	auipc	ra,0xffffe
    800028be:	4ca080e7          	jalr	1226(ra) # 80000d84 <release>
          release(&wait_lock);
    800028c2:	0022f517          	auipc	a0,0x22f
    800028c6:	81e50513          	add	a0,a0,-2018 # 802310e0 <wait_lock>
    800028ca:	ffffe097          	auipc	ra,0xffffe
    800028ce:	4ba080e7          	jalr	1210(ra) # 80000d84 <release>
}
    800028d2:	854e                	mv	a0,s3
    800028d4:	60a6                	ld	ra,72(sp)
    800028d6:	6406                	ld	s0,64(sp)
    800028d8:	74e2                	ld	s1,56(sp)
    800028da:	7942                	ld	s2,48(sp)
    800028dc:	79a2                	ld	s3,40(sp)
    800028de:	7a02                	ld	s4,32(sp)
    800028e0:	6ae2                	ld	s5,24(sp)
    800028e2:	6b42                	ld	s6,16(sp)
    800028e4:	6ba2                	ld	s7,8(sp)
    800028e6:	6c02                	ld	s8,0(sp)
    800028e8:	6161                	add	sp,sp,80
    800028ea:	8082                	ret
            release(&pp->lock);
    800028ec:	8526                	mv	a0,s1
    800028ee:	ffffe097          	auipc	ra,0xffffe
    800028f2:	496080e7          	jalr	1174(ra) # 80000d84 <release>
            release(&wait_lock);
    800028f6:	0022e517          	auipc	a0,0x22e
    800028fa:	7ea50513          	add	a0,a0,2026 # 802310e0 <wait_lock>
    800028fe:	ffffe097          	auipc	ra,0xffffe
    80002902:	486080e7          	jalr	1158(ra) # 80000d84 <release>
            return -1;
    80002906:	59fd                	li	s3,-1
    80002908:	b7e9                	j	800028d2 <wait+0x90>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    8000290a:	1d848493          	add	s1,s1,472
    8000290e:	03348463          	beq	s1,s3,80002936 <wait+0xf4>
      if (pp->parent == p)
    80002912:	7c9c                	ld	a5,56(s1)
    80002914:	ff279be3          	bne	a5,s2,8000290a <wait+0xc8>
        acquire(&pp->lock);
    80002918:	8526                	mv	a0,s1
    8000291a:	ffffe097          	auipc	ra,0xffffe
    8000291e:	3b6080e7          	jalr	950(ra) # 80000cd0 <acquire>
        if (pp->state == ZOMBIE)
    80002922:	4c9c                	lw	a5,24(s1)
    80002924:	f74785e3          	beq	a5,s4,8000288e <wait+0x4c>
        release(&pp->lock);
    80002928:	8526                	mv	a0,s1
    8000292a:	ffffe097          	auipc	ra,0xffffe
    8000292e:	45a080e7          	jalr	1114(ra) # 80000d84 <release>
        havekids = 1;
    80002932:	8756                	mv	a4,s5
    80002934:	bfd9                	j	8000290a <wait+0xc8>
    if (!havekids || killed(p))
    80002936:	c31d                	beqz	a4,8000295c <wait+0x11a>
    80002938:	854a                	mv	a0,s2
    8000293a:	00000097          	auipc	ra,0x0
    8000293e:	ed6080e7          	jalr	-298(ra) # 80002810 <killed>
    80002942:	ed09                	bnez	a0,8000295c <wait+0x11a>
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002944:	85e2                	mv	a1,s8
    80002946:	854a                	mv	a0,s2
    80002948:	00000097          	auipc	ra,0x0
    8000294c:	db2080e7          	jalr	-590(ra) # 800026fa <sleep>
    havekids = 0;
    80002950:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002952:	0022e497          	auipc	s1,0x22e
    80002956:	7a648493          	add	s1,s1,1958 # 802310f8 <proc>
    8000295a:	bf65                	j	80002912 <wait+0xd0>
      release(&wait_lock);
    8000295c:	0022e517          	auipc	a0,0x22e
    80002960:	78450513          	add	a0,a0,1924 # 802310e0 <wait_lock>
    80002964:	ffffe097          	auipc	ra,0xffffe
    80002968:	420080e7          	jalr	1056(ra) # 80000d84 <release>
      return -1;
    8000296c:	59fd                	li	s3,-1
    8000296e:	b795                	j	800028d2 <wait+0x90>

0000000080002970 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002970:	7179                	add	sp,sp,-48
    80002972:	f406                	sd	ra,40(sp)
    80002974:	f022                	sd	s0,32(sp)
    80002976:	ec26                	sd	s1,24(sp)
    80002978:	e84a                	sd	s2,16(sp)
    8000297a:	e44e                	sd	s3,8(sp)
    8000297c:	e052                	sd	s4,0(sp)
    8000297e:	1800                	add	s0,sp,48
    80002980:	84aa                	mv	s1,a0
    80002982:	892e                	mv	s2,a1
    80002984:	89b2                	mv	s3,a2
    80002986:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002988:	fffff097          	auipc	ra,0xfffff
    8000298c:	428080e7          	jalr	1064(ra) # 80001db0 <myproc>
  if (user_dst)
    80002990:	c08d                	beqz	s1,800029b2 <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    80002992:	86d2                	mv	a3,s4
    80002994:	864e                	mv	a2,s3
    80002996:	85ca                	mv	a1,s2
    80002998:	6928                	ld	a0,80(a0)
    8000299a:	fffff097          	auipc	ra,0xfffff
    8000299e:	f0e080e7          	jalr	-242(ra) # 800018a8 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800029a2:	70a2                	ld	ra,40(sp)
    800029a4:	7402                	ld	s0,32(sp)
    800029a6:	64e2                	ld	s1,24(sp)
    800029a8:	6942                	ld	s2,16(sp)
    800029aa:	69a2                	ld	s3,8(sp)
    800029ac:	6a02                	ld	s4,0(sp)
    800029ae:	6145                	add	sp,sp,48
    800029b0:	8082                	ret
    memmove((char *)dst, src, len);
    800029b2:	000a061b          	sext.w	a2,s4
    800029b6:	85ce                	mv	a1,s3
    800029b8:	854a                	mv	a0,s2
    800029ba:	ffffe097          	auipc	ra,0xffffe
    800029be:	46e080e7          	jalr	1134(ra) # 80000e28 <memmove>
    return 0;
    800029c2:	8526                	mv	a0,s1
    800029c4:	bff9                	j	800029a2 <either_copyout+0x32>

00000000800029c6 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800029c6:	715d                	add	sp,sp,-80
    800029c8:	e486                	sd	ra,72(sp)
    800029ca:	e0a2                	sd	s0,64(sp)
    800029cc:	fc26                	sd	s1,56(sp)
    800029ce:	f84a                	sd	s2,48(sp)
    800029d0:	f44e                	sd	s3,40(sp)
    800029d2:	f052                	sd	s4,32(sp)
    800029d4:	ec56                	sd	s5,24(sp)
    800029d6:	e85a                	sd	s6,16(sp)
    800029d8:	e45e                	sd	s7,8(sp)
    800029da:	0880                	add	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    800029dc:	00005517          	auipc	a0,0x5
    800029e0:	64450513          	add	a0,a0,1604 # 80008020 <etext+0x20>
    800029e4:	ffffe097          	auipc	ra,0xffffe
    800029e8:	ba2080e7          	jalr	-1118(ra) # 80000586 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    800029ec:	0022f497          	auipc	s1,0x22f
    800029f0:	86448493          	add	s1,s1,-1948 # 80231250 <proc+0x158>
    800029f4:	00236917          	auipc	s2,0x236
    800029f8:	e5c90913          	add	s2,s2,-420 # 80238850 <bcache+0x140>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029fc:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800029fe:	00006997          	auipc	s3,0x6
    80002a02:	99298993          	add	s3,s3,-1646 # 80008390 <etext+0x390>
    printf("%d %s %s", p->pid, state, p->name);
    80002a06:	00006a97          	auipc	s5,0x6
    80002a0a:	992a8a93          	add	s5,s5,-1646 # 80008398 <etext+0x398>
    printf("\n");
    80002a0e:	00005a17          	auipc	s4,0x5
    80002a12:	612a0a13          	add	s4,s4,1554 # 80008020 <etext+0x20>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a16:	00006b97          	auipc	s7,0x6
    80002a1a:	e82b8b93          	add	s7,s7,-382 # 80008898 <states.0>
    80002a1e:	a00d                	j	80002a40 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002a20:	ed86a583          	lw	a1,-296(a3)
    80002a24:	8556                	mv	a0,s5
    80002a26:	ffffe097          	auipc	ra,0xffffe
    80002a2a:	b60080e7          	jalr	-1184(ra) # 80000586 <printf>
    printf("\n");
    80002a2e:	8552                	mv	a0,s4
    80002a30:	ffffe097          	auipc	ra,0xffffe
    80002a34:	b56080e7          	jalr	-1194(ra) # 80000586 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80002a38:	1d848493          	add	s1,s1,472
    80002a3c:	03248263          	beq	s1,s2,80002a60 <procdump+0x9a>
    if (p->state == UNUSED)
    80002a40:	86a6                	mv	a3,s1
    80002a42:	ec04a783          	lw	a5,-320(s1)
    80002a46:	dbed                	beqz	a5,80002a38 <procdump+0x72>
      state = "???";
    80002a48:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a4a:	fcfb6be3          	bltu	s6,a5,80002a20 <procdump+0x5a>
    80002a4e:	02079713          	sll	a4,a5,0x20
    80002a52:	01d75793          	srl	a5,a4,0x1d
    80002a56:	97de                	add	a5,a5,s7
    80002a58:	6390                	ld	a2,0(a5)
    80002a5a:	f279                	bnez	a2,80002a20 <procdump+0x5a>
      state = "???";
    80002a5c:	864e                	mv	a2,s3
    80002a5e:	b7c9                	j	80002a20 <procdump+0x5a>
  }
}
    80002a60:	60a6                	ld	ra,72(sp)
    80002a62:	6406                	ld	s0,64(sp)
    80002a64:	74e2                	ld	s1,56(sp)
    80002a66:	7942                	ld	s2,48(sp)
    80002a68:	79a2                	ld	s3,40(sp)
    80002a6a:	7a02                	ld	s4,32(sp)
    80002a6c:	6ae2                	ld	s5,24(sp)
    80002a6e:	6b42                	ld	s6,16(sp)
    80002a70:	6ba2                	ld	s7,8(sp)
    80002a72:	6161                	add	sp,sp,80
    80002a74:	8082                	ret

0000000080002a76 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002a76:	7179                	add	sp,sp,-48
    80002a78:	f406                	sd	ra,40(sp)
    80002a7a:	f022                	sd	s0,32(sp)
    80002a7c:	ec26                	sd	s1,24(sp)
    80002a7e:	e84a                	sd	s2,16(sp)
    80002a80:	e44e                	sd	s3,8(sp)
    80002a82:	e052                	sd	s4,0(sp)
    80002a84:	1800                	add	s0,sp,48
    80002a86:	892a                	mv	s2,a0
    80002a88:	84ae                	mv	s1,a1
    80002a8a:	89b2                	mv	s3,a2
    80002a8c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002a8e:	fffff097          	auipc	ra,0xfffff
    80002a92:	322080e7          	jalr	802(ra) # 80001db0 <myproc>
  if (user_src)
    80002a96:	c08d                	beqz	s1,80002ab8 <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    80002a98:	86d2                	mv	a3,s4
    80002a9a:	864e                	mv	a2,s3
    80002a9c:	85ca                	mv	a1,s2
    80002a9e:	6928                	ld	a0,80(a0)
    80002aa0:	fffff097          	auipc	ra,0xfffff
    80002aa4:	ece080e7          	jalr	-306(ra) # 8000196e <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002aa8:	70a2                	ld	ra,40(sp)
    80002aaa:	7402                	ld	s0,32(sp)
    80002aac:	64e2                	ld	s1,24(sp)
    80002aae:	6942                	ld	s2,16(sp)
    80002ab0:	69a2                	ld	s3,8(sp)
    80002ab2:	6a02                	ld	s4,0(sp)
    80002ab4:	6145                	add	sp,sp,48
    80002ab6:	8082                	ret
    memmove(dst, (char *)src, len);
    80002ab8:	000a061b          	sext.w	a2,s4
    80002abc:	85ce                	mv	a1,s3
    80002abe:	854a                	mv	a0,s2
    80002ac0:	ffffe097          	auipc	ra,0xffffe
    80002ac4:	368080e7          	jalr	872(ra) # 80000e28 <memmove>
    return 0;
    80002ac8:	8526                	mv	a0,s1
    80002aca:	bff9                	j	80002aa8 <either_copyin+0x32>

0000000080002acc <update_time>:

void update_time()
{
    80002acc:	7179                	add	sp,sp,-48
    80002ace:	f406                	sd	ra,40(sp)
    80002ad0:	f022                	sd	s0,32(sp)
    80002ad2:	ec26                	sd	s1,24(sp)
    80002ad4:	e84a                	sd	s2,16(sp)
    80002ad6:	e44e                	sd	s3,8(sp)
    80002ad8:	1800                	add	s0,sp,48
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
    80002ada:	0022e497          	auipc	s1,0x22e
    80002ade:	61e48493          	add	s1,s1,1566 # 802310f8 <proc>
  {
    acquire(&p->lock);
    if (p->state == RUNNING)
    80002ae2:	4991                	li	s3,4
  for (p = proc; p < &proc[NPROC]; p++)
    80002ae4:	00236917          	auipc	s2,0x236
    80002ae8:	c1490913          	add	s2,s2,-1004 # 802386f8 <tickslock>
    80002aec:	a811                	j	80002b00 <update_time+0x34>
      p->rtime++; // MLFQ
    release(&p->lock);
    80002aee:	8526                	mv	a0,s1
    80002af0:	ffffe097          	auipc	ra,0xffffe
    80002af4:	294080e7          	jalr	660(ra) # 80000d84 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002af8:	1d848493          	add	s1,s1,472
    80002afc:	03248063          	beq	s1,s2,80002b1c <update_time+0x50>
    acquire(&p->lock);
    80002b00:	8526                	mv	a0,s1
    80002b02:	ffffe097          	auipc	ra,0xffffe
    80002b06:	1ce080e7          	jalr	462(ra) # 80000cd0 <acquire>
    if (p->state == RUNNING)
    80002b0a:	4c9c                	lw	a5,24(s1)
    80002b0c:	ff3791e3          	bne	a5,s3,80002aee <update_time+0x22>
      p->rtime++; // MLFQ
    80002b10:	1684a783          	lw	a5,360(s1)
    80002b14:	2785                	addw	a5,a5,1
    80002b16:	16f4a423          	sw	a5,360(s1)
    80002b1a:	bfd1                	j	80002aee <update_time+0x22>
  }
}
    80002b1c:	70a2                	ld	ra,40(sp)
    80002b1e:	7402                	ld	s0,32(sp)
    80002b20:	64e2                	ld	s1,24(sp)
    80002b22:	6942                	ld	s2,16(sp)
    80002b24:	69a2                	ld	s3,8(sp)
    80002b26:	6145                	add	sp,sp,48
    80002b28:	8082                	ret

0000000080002b2a <waitx>:

// waitx
int waitx(uint64 addr, uint *wtime, uint *rtime)
{
    80002b2a:	711d                	add	sp,sp,-96
    80002b2c:	ec86                	sd	ra,88(sp)
    80002b2e:	e8a2                	sd	s0,80(sp)
    80002b30:	e4a6                	sd	s1,72(sp)
    80002b32:	e0ca                	sd	s2,64(sp)
    80002b34:	fc4e                	sd	s3,56(sp)
    80002b36:	f852                	sd	s4,48(sp)
    80002b38:	f456                	sd	s5,40(sp)
    80002b3a:	f05a                	sd	s6,32(sp)
    80002b3c:	ec5e                	sd	s7,24(sp)
    80002b3e:	e862                	sd	s8,16(sp)
    80002b40:	e466                	sd	s9,8(sp)
    80002b42:	e06a                	sd	s10,0(sp)
    80002b44:	1080                	add	s0,sp,96
    80002b46:	8b2a                	mv	s6,a0
    80002b48:	8bae                	mv	s7,a1
    80002b4a:	8c32                	mv	s8,a2
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();
    80002b4c:	fffff097          	auipc	ra,0xfffff
    80002b50:	264080e7          	jalr	612(ra) # 80001db0 <myproc>
    80002b54:	892a                	mv	s2,a0

  acquire(&wait_lock);
    80002b56:	0022e517          	auipc	a0,0x22e
    80002b5a:	58a50513          	add	a0,a0,1418 # 802310e0 <wait_lock>
    80002b5e:	ffffe097          	auipc	ra,0xffffe
    80002b62:	172080e7          	jalr	370(ra) # 80000cd0 <acquire>

  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    80002b66:	4c81                	li	s9,0
      {
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        havekids = 1;
        if (np->state == ZOMBIE)
    80002b68:	4a15                	li	s4,5
        havekids = 1;
    80002b6a:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++)
    80002b6c:	00236997          	auipc	s3,0x236
    80002b70:	b8c98993          	add	s3,s3,-1140 # 802386f8 <tickslock>
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002b74:	0022ed17          	auipc	s10,0x22e
    80002b78:	56cd0d13          	add	s10,s10,1388 # 802310e0 <wait_lock>
    80002b7c:	a8e9                	j	80002c56 <waitx+0x12c>
          pid = np->pid;
    80002b7e:	0304a983          	lw	s3,48(s1)
          *rtime = np->rtime;
    80002b82:	1684a783          	lw	a5,360(s1)
    80002b86:	00fc2023          	sw	a5,0(s8)
          *wtime = np->etime - np->ctime - np->rtime;
    80002b8a:	16c4a703          	lw	a4,364(s1)
    80002b8e:	9f3d                	addw	a4,a4,a5
    80002b90:	1704a783          	lw	a5,368(s1)
    80002b94:	9f99                	subw	a5,a5,a4
    80002b96:	00fba023          	sw	a5,0(s7)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002b9a:	000b0e63          	beqz	s6,80002bb6 <waitx+0x8c>
    80002b9e:	4691                	li	a3,4
    80002ba0:	02c48613          	add	a2,s1,44
    80002ba4:	85da                	mv	a1,s6
    80002ba6:	05093503          	ld	a0,80(s2)
    80002baa:	fffff097          	auipc	ra,0xfffff
    80002bae:	cfe080e7          	jalr	-770(ra) # 800018a8 <copyout>
    80002bb2:	04054363          	bltz	a0,80002bf8 <waitx+0xce>
          freeproc(np);
    80002bb6:	8526                	mv	a0,s1
    80002bb8:	fffff097          	auipc	ra,0xfffff
    80002bbc:	3aa080e7          	jalr	938(ra) # 80001f62 <freeproc>
          release(&np->lock);
    80002bc0:	8526                	mv	a0,s1
    80002bc2:	ffffe097          	auipc	ra,0xffffe
    80002bc6:	1c2080e7          	jalr	450(ra) # 80000d84 <release>
          release(&wait_lock);
    80002bca:	0022e517          	auipc	a0,0x22e
    80002bce:	51650513          	add	a0,a0,1302 # 802310e0 <wait_lock>
    80002bd2:	ffffe097          	auipc	ra,0xffffe
    80002bd6:	1b2080e7          	jalr	434(ra) # 80000d84 <release>
  }
}
    80002bda:	854e                	mv	a0,s3
    80002bdc:	60e6                	ld	ra,88(sp)
    80002bde:	6446                	ld	s0,80(sp)
    80002be0:	64a6                	ld	s1,72(sp)
    80002be2:	6906                	ld	s2,64(sp)
    80002be4:	79e2                	ld	s3,56(sp)
    80002be6:	7a42                	ld	s4,48(sp)
    80002be8:	7aa2                	ld	s5,40(sp)
    80002bea:	7b02                	ld	s6,32(sp)
    80002bec:	6be2                	ld	s7,24(sp)
    80002bee:	6c42                	ld	s8,16(sp)
    80002bf0:	6ca2                	ld	s9,8(sp)
    80002bf2:	6d02                	ld	s10,0(sp)
    80002bf4:	6125                	add	sp,sp,96
    80002bf6:	8082                	ret
            release(&np->lock);
    80002bf8:	8526                	mv	a0,s1
    80002bfa:	ffffe097          	auipc	ra,0xffffe
    80002bfe:	18a080e7          	jalr	394(ra) # 80000d84 <release>
            release(&wait_lock);
    80002c02:	0022e517          	auipc	a0,0x22e
    80002c06:	4de50513          	add	a0,a0,1246 # 802310e0 <wait_lock>
    80002c0a:	ffffe097          	auipc	ra,0xffffe
    80002c0e:	17a080e7          	jalr	378(ra) # 80000d84 <release>
            return -1;
    80002c12:	59fd                	li	s3,-1
    80002c14:	b7d9                	j	80002bda <waitx+0xb0>
    for (np = proc; np < &proc[NPROC]; np++)
    80002c16:	1d848493          	add	s1,s1,472
    80002c1a:	03348463          	beq	s1,s3,80002c42 <waitx+0x118>
      if (np->parent == p)
    80002c1e:	7c9c                	ld	a5,56(s1)
    80002c20:	ff279be3          	bne	a5,s2,80002c16 <waitx+0xec>
        acquire(&np->lock);
    80002c24:	8526                	mv	a0,s1
    80002c26:	ffffe097          	auipc	ra,0xffffe
    80002c2a:	0aa080e7          	jalr	170(ra) # 80000cd0 <acquire>
        if (np->state == ZOMBIE)
    80002c2e:	4c9c                	lw	a5,24(s1)
    80002c30:	f54787e3          	beq	a5,s4,80002b7e <waitx+0x54>
        release(&np->lock);
    80002c34:	8526                	mv	a0,s1
    80002c36:	ffffe097          	auipc	ra,0xffffe
    80002c3a:	14e080e7          	jalr	334(ra) # 80000d84 <release>
        havekids = 1;
    80002c3e:	8756                	mv	a4,s5
    80002c40:	bfd9                	j	80002c16 <waitx+0xec>
    if (!havekids || p->killed)
    80002c42:	c305                	beqz	a4,80002c62 <waitx+0x138>
    80002c44:	02892783          	lw	a5,40(s2)
    80002c48:	ef89                	bnez	a5,80002c62 <waitx+0x138>
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002c4a:	85ea                	mv	a1,s10
    80002c4c:	854a                	mv	a0,s2
    80002c4e:	00000097          	auipc	ra,0x0
    80002c52:	aac080e7          	jalr	-1364(ra) # 800026fa <sleep>
    havekids = 0;
    80002c56:	8766                	mv	a4,s9
    for (np = proc; np < &proc[NPROC]; np++)
    80002c58:	0022e497          	auipc	s1,0x22e
    80002c5c:	4a048493          	add	s1,s1,1184 # 802310f8 <proc>
    80002c60:	bf7d                	j	80002c1e <waitx+0xf4>
      release(&wait_lock);
    80002c62:	0022e517          	auipc	a0,0x22e
    80002c66:	47e50513          	add	a0,a0,1150 # 802310e0 <wait_lock>
    80002c6a:	ffffe097          	auipc	ra,0xffffe
    80002c6e:	11a080e7          	jalr	282(ra) # 80000d84 <release>
      return -1;
    80002c72:	59fd                	li	s3,-1
    80002c74:	b79d                	j	80002bda <waitx+0xb0>

0000000080002c76 <swtch>:
    80002c76:	00153023          	sd	ra,0(a0)
    80002c7a:	00253423          	sd	sp,8(a0)
    80002c7e:	e900                	sd	s0,16(a0)
    80002c80:	ed04                	sd	s1,24(a0)
    80002c82:	03253023          	sd	s2,32(a0)
    80002c86:	03353423          	sd	s3,40(a0)
    80002c8a:	03453823          	sd	s4,48(a0)
    80002c8e:	03553c23          	sd	s5,56(a0)
    80002c92:	05653023          	sd	s6,64(a0)
    80002c96:	05753423          	sd	s7,72(a0)
    80002c9a:	05853823          	sd	s8,80(a0)
    80002c9e:	05953c23          	sd	s9,88(a0)
    80002ca2:	07a53023          	sd	s10,96(a0)
    80002ca6:	07b53423          	sd	s11,104(a0)
    80002caa:	0005b083          	ld	ra,0(a1)
    80002cae:	0085b103          	ld	sp,8(a1)
    80002cb2:	6980                	ld	s0,16(a1)
    80002cb4:	6d84                	ld	s1,24(a1)
    80002cb6:	0205b903          	ld	s2,32(a1)
    80002cba:	0285b983          	ld	s3,40(a1)
    80002cbe:	0305ba03          	ld	s4,48(a1)
    80002cc2:	0385ba83          	ld	s5,56(a1)
    80002cc6:	0405bb03          	ld	s6,64(a1)
    80002cca:	0485bb83          	ld	s7,72(a1)
    80002cce:	0505bc03          	ld	s8,80(a1)
    80002cd2:	0585bc83          	ld	s9,88(a1)
    80002cd6:	0605bd03          	ld	s10,96(a1)
    80002cda:	0685bd83          	ld	s11,104(a1)
    80002cde:	8082                	ret

0000000080002ce0 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002ce0:	1141                	add	sp,sp,-16
    80002ce2:	e406                	sd	ra,8(sp)
    80002ce4:	e022                	sd	s0,0(sp)
    80002ce6:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80002ce8:	00005597          	auipc	a1,0x5
    80002cec:	6f058593          	add	a1,a1,1776 # 800083d8 <etext+0x3d8>
    80002cf0:	00236517          	auipc	a0,0x236
    80002cf4:	a0850513          	add	a0,a0,-1528 # 802386f8 <tickslock>
    80002cf8:	ffffe097          	auipc	ra,0xffffe
    80002cfc:	f48080e7          	jalr	-184(ra) # 80000c40 <initlock>
}
    80002d00:	60a2                	ld	ra,8(sp)
    80002d02:	6402                	ld	s0,0(sp)
    80002d04:	0141                	add	sp,sp,16
    80002d06:	8082                	ret

0000000080002d08 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002d08:	1141                	add	sp,sp,-16
    80002d0a:	e422                	sd	s0,8(sp)
    80002d0c:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002d0e:	00003797          	auipc	a5,0x3
    80002d12:	78278793          	add	a5,a5,1922 # 80006490 <kernelvec>
    80002d16:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002d1a:	6422                	ld	s0,8(sp)
    80002d1c:	0141                	add	sp,sp,16
    80002d1e:	8082                	ret

0000000080002d20 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002d20:	1141                	add	sp,sp,-16
    80002d22:	e406                	sd	ra,8(sp)
    80002d24:	e022                	sd	s0,0(sp)
    80002d26:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80002d28:	fffff097          	auipc	ra,0xfffff
    80002d2c:	088080e7          	jalr	136(ra) # 80001db0 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d30:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002d34:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d36:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002d3a:	00004697          	auipc	a3,0x4
    80002d3e:	2c668693          	add	a3,a3,710 # 80007000 <_trampoline>
    80002d42:	00004717          	auipc	a4,0x4
    80002d46:	2be70713          	add	a4,a4,702 # 80007000 <_trampoline>
    80002d4a:	8f15                	sub	a4,a4,a3
    80002d4c:	040007b7          	lui	a5,0x4000
    80002d50:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002d52:	07b2                	sll	a5,a5,0xc
    80002d54:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002d56:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002d5a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002d5c:	18002673          	csrr	a2,satp
    80002d60:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002d62:	6d30                	ld	a2,88(a0)
    80002d64:	6138                	ld	a4,64(a0)
    80002d66:	6585                	lui	a1,0x1
    80002d68:	972e                	add	a4,a4,a1
    80002d6a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002d6c:	6d38                	ld	a4,88(a0)
    80002d6e:	00000617          	auipc	a2,0x0
    80002d72:	1bc60613          	add	a2,a2,444 # 80002f2a <usertrap>
    80002d76:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002d78:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002d7a:	8612                	mv	a2,tp
    80002d7c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d7e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002d82:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002d86:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d8a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002d8e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002d90:	6f18                	ld	a4,24(a4)
    80002d92:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002d96:	6928                	ld	a0,80(a0)
    80002d98:	8131                	srl	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002d9a:	00004717          	auipc	a4,0x4
    80002d9e:	30270713          	add	a4,a4,770 # 8000709c <userret>
    80002da2:	8f15                	sub	a4,a4,a3
    80002da4:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002da6:	577d                	li	a4,-1
    80002da8:	177e                	sll	a4,a4,0x3f
    80002daa:	8d59                	or	a0,a0,a4
    80002dac:	9782                	jalr	a5
}
    80002dae:	60a2                	ld	ra,8(sp)
    80002db0:	6402                	ld	s0,0(sp)
    80002db2:	0141                	add	sp,sp,16
    80002db4:	8082                	ret

0000000080002db6 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80002db6:	7139                	add	sp,sp,-64
    80002db8:	fc06                	sd	ra,56(sp)
    80002dba:	f822                	sd	s0,48(sp)
    80002dbc:	f426                	sd	s1,40(sp)
    80002dbe:	f04a                	sd	s2,32(sp)
    80002dc0:	ec4e                	sd	s3,24(sp)
    80002dc2:	e852                	sd	s4,16(sp)
    80002dc4:	e456                	sd	s5,8(sp)
    80002dc6:	0080                	add	s0,sp,64
  acquire(&tickslock);
    80002dc8:	00236517          	auipc	a0,0x236
    80002dcc:	93050513          	add	a0,a0,-1744 # 802386f8 <tickslock>
    80002dd0:	ffffe097          	auipc	ra,0xffffe
    80002dd4:	f00080e7          	jalr	-256(ra) # 80000cd0 <acquire>
  ticks++;
    80002dd8:	00006717          	auipc	a4,0x6
    80002ddc:	c6870713          	add	a4,a4,-920 # 80008a40 <ticks>
    80002de0:	431c                	lw	a5,0(a4)
    80002de2:	2785                	addw	a5,a5,1
    80002de4:	c31c                	sw	a5,0(a4)
  update_time();
    80002de6:	00000097          	auipc	ra,0x0
    80002dea:	ce6080e7          	jalr	-794(ra) # 80002acc <update_time>
  // PBS
  for (struct proc *p = proc; p < &proc[NPROC]; p++)
    80002dee:	0022e497          	auipc	s1,0x22e
    80002df2:	30a48493          	add	s1,s1,778 # 802310f8 <proc>
  {
    acquire(&p->lock);          // copilt
    if (p->state == RUNNING)
    80002df6:	4991                	li	s3,4
    {
      // p->rtime++;
      p->run_time++;
    }
    if (p->state == SLEEPING)
    80002df8:	4a09                	li	s4,2
    {
      // p->wtime++;
      p->wait_time++;
    }
    if (p->state == RUNNABLE)
    80002dfa:	4a8d                	li	s5,3
  for (struct proc *p = proc; p < &proc[NPROC]; p++)
    80002dfc:	00236917          	auipc	s2,0x236
    80002e00:	8fc90913          	add	s2,s2,-1796 # 802386f8 <tickslock>
    80002e04:	a839                	j	80002e22 <clockintr+0x6c>
      p->run_time++;
    80002e06:	1c04a783          	lw	a5,448(s1)
    80002e0a:	2785                	addw	a5,a5,1
    80002e0c:	1cf4a023          	sw	a5,448(s1)
    {
      // p->stime++;
      p->sleep_time++;
    }
    release(&p->lock);
    80002e10:	8526                	mv	a0,s1
    80002e12:	ffffe097          	auipc	ra,0xffffe
    80002e16:	f72080e7          	jalr	-142(ra) # 80000d84 <release>
  for (struct proc *p = proc; p < &proc[NPROC]; p++)
    80002e1a:	1d848493          	add	s1,s1,472
    80002e1e:	03248a63          	beq	s1,s2,80002e52 <clockintr+0x9c>
    acquire(&p->lock);          // copilt
    80002e22:	8526                	mv	a0,s1
    80002e24:	ffffe097          	auipc	ra,0xffffe
    80002e28:	eac080e7          	jalr	-340(ra) # 80000cd0 <acquire>
    if (p->state == RUNNING)
    80002e2c:	4c9c                	lw	a5,24(s1)
    80002e2e:	fd378ce3          	beq	a5,s3,80002e06 <clockintr+0x50>
    if (p->state == SLEEPING)
    80002e32:	01479863          	bne	a5,s4,80002e42 <clockintr+0x8c>
      p->wait_time++;
    80002e36:	1c44a783          	lw	a5,452(s1)
    80002e3a:	2785                	addw	a5,a5,1
    80002e3c:	1cf4a223          	sw	a5,452(s1)
    if (p->state == RUNNABLE)
    80002e40:	bfc1                	j	80002e10 <clockintr+0x5a>
    80002e42:	fd5797e3          	bne	a5,s5,80002e10 <clockintr+0x5a>
      p->sleep_time++;
    80002e46:	1c84a783          	lw	a5,456(s1)
    80002e4a:	2785                	addw	a5,a5,1
    80002e4c:	1cf4a423          	sw	a5,456(s1)
    80002e50:	b7c1                	j	80002e10 <clockintr+0x5a>
  }
  wakeup(&ticks);
    80002e52:	00006517          	auipc	a0,0x6
    80002e56:	bee50513          	add	a0,a0,-1042 # 80008a40 <ticks>
    80002e5a:	fffff097          	auipc	ra,0xfffff
    80002e5e:	6d2080e7          	jalr	1746(ra) # 8000252c <wakeup>
  release(&tickslock);
    80002e62:	00236517          	auipc	a0,0x236
    80002e66:	89650513          	add	a0,a0,-1898 # 802386f8 <tickslock>
    80002e6a:	ffffe097          	auipc	ra,0xffffe
    80002e6e:	f1a080e7          	jalr	-230(ra) # 80000d84 <release>
}
    80002e72:	70e2                	ld	ra,56(sp)
    80002e74:	7442                	ld	s0,48(sp)
    80002e76:	74a2                	ld	s1,40(sp)
    80002e78:	7902                	ld	s2,32(sp)
    80002e7a:	69e2                	ld	s3,24(sp)
    80002e7c:	6a42                	ld	s4,16(sp)
    80002e7e:	6aa2                	ld	s5,8(sp)
    80002e80:	6121                	add	sp,sp,64
    80002e82:	8082                	ret

0000000080002e84 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e84:	142027f3          	csrr	a5,scause

    return 2;
  }
  else
  {
    return 0;
    80002e88:	4501                	li	a0,0
  if ((scause & 0x8000000000000000L) &&
    80002e8a:	0807df63          	bgez	a5,80002f28 <devintr+0xa4>
{
    80002e8e:	1101                	add	sp,sp,-32
    80002e90:	ec06                	sd	ra,24(sp)
    80002e92:	e822                	sd	s0,16(sp)
    80002e94:	e426                	sd	s1,8(sp)
    80002e96:	1000                	add	s0,sp,32
      (scause & 0xff) == 9)
    80002e98:	0ff7f713          	zext.b	a4,a5
  if ((scause & 0x8000000000000000L) &&
    80002e9c:	46a5                	li	a3,9
    80002e9e:	00d70d63          	beq	a4,a3,80002eb8 <devintr+0x34>
  else if (scause == 0x8000000000000001L)
    80002ea2:	577d                	li	a4,-1
    80002ea4:	177e                	sll	a4,a4,0x3f
    80002ea6:	0705                	add	a4,a4,1
    return 0;
    80002ea8:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80002eaa:	04e78e63          	beq	a5,a4,80002f06 <devintr+0x82>
  }
}
    80002eae:	60e2                	ld	ra,24(sp)
    80002eb0:	6442                	ld	s0,16(sp)
    80002eb2:	64a2                	ld	s1,8(sp)
    80002eb4:	6105                	add	sp,sp,32
    80002eb6:	8082                	ret
    int irq = plic_claim();
    80002eb8:	00003097          	auipc	ra,0x3
    80002ebc:	6e0080e7          	jalr	1760(ra) # 80006598 <plic_claim>
    80002ec0:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80002ec2:	47a9                	li	a5,10
    80002ec4:	02f50763          	beq	a0,a5,80002ef2 <devintr+0x6e>
    else if (irq == VIRTIO0_IRQ)
    80002ec8:	4785                	li	a5,1
    80002eca:	02f50963          	beq	a0,a5,80002efc <devintr+0x78>
    return 1;
    80002ece:	4505                	li	a0,1
    else if (irq)
    80002ed0:	dcf9                	beqz	s1,80002eae <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80002ed2:	85a6                	mv	a1,s1
    80002ed4:	00005517          	auipc	a0,0x5
    80002ed8:	50c50513          	add	a0,a0,1292 # 800083e0 <etext+0x3e0>
    80002edc:	ffffd097          	auipc	ra,0xffffd
    80002ee0:	6aa080e7          	jalr	1706(ra) # 80000586 <printf>
      plic_complete(irq);
    80002ee4:	8526                	mv	a0,s1
    80002ee6:	00003097          	auipc	ra,0x3
    80002eea:	6d6080e7          	jalr	1750(ra) # 800065bc <plic_complete>
    return 1;
    80002eee:	4505                	li	a0,1
    80002ef0:	bf7d                	j	80002eae <devintr+0x2a>
      uartintr();
    80002ef2:	ffffe097          	auipc	ra,0xffffe
    80002ef6:	aa2080e7          	jalr	-1374(ra) # 80000994 <uartintr>
    if (irq)
    80002efa:	b7ed                	j	80002ee4 <devintr+0x60>
      virtio_disk_intr();
    80002efc:	00004097          	auipc	ra,0x4
    80002f00:	b86080e7          	jalr	-1146(ra) # 80006a82 <virtio_disk_intr>
    if (irq)
    80002f04:	b7c5                	j	80002ee4 <devintr+0x60>
    if (cpuid() == 0)
    80002f06:	fffff097          	auipc	ra,0xfffff
    80002f0a:	e7e080e7          	jalr	-386(ra) # 80001d84 <cpuid>
    80002f0e:	c901                	beqz	a0,80002f1e <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002f10:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002f14:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002f16:	14479073          	csrw	sip,a5
    return 2;
    80002f1a:	4509                	li	a0,2
    80002f1c:	bf49                	j	80002eae <devintr+0x2a>
      clockintr();
    80002f1e:	00000097          	auipc	ra,0x0
    80002f22:	e98080e7          	jalr	-360(ra) # 80002db6 <clockintr>
    80002f26:	b7ed                	j	80002f10 <devintr+0x8c>
}
    80002f28:	8082                	ret

0000000080002f2a <usertrap>:
{
    80002f2a:	1101                	add	sp,sp,-32
    80002f2c:	ec06                	sd	ra,24(sp)
    80002f2e:	e822                	sd	s0,16(sp)
    80002f30:	e426                	sd	s1,8(sp)
    80002f32:	e04a                	sd	s2,0(sp)
    80002f34:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f36:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002f3a:	1007f793          	and	a5,a5,256
    80002f3e:	e7b9                	bnez	a5,80002f8c <usertrap+0x62>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002f40:	00003797          	auipc	a5,0x3
    80002f44:	55078793          	add	a5,a5,1360 # 80006490 <kernelvec>
    80002f48:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002f4c:	fffff097          	auipc	ra,0xfffff
    80002f50:	e64080e7          	jalr	-412(ra) # 80001db0 <myproc>
    80002f54:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002f56:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f58:	14102773          	csrr	a4,sepc
    80002f5c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002f5e:	14202773          	csrr	a4,scause
  if(r_scause() == 15)    // COW
    80002f62:	47bd                	li	a5,15
    80002f64:	02f70c63          	beq	a4,a5,80002f9c <usertrap+0x72>
    80002f68:	14202773          	csrr	a4,scause
  else if (r_scause() == 8)
    80002f6c:	47a1                	li	a5,8
    80002f6e:	04f70463          	beq	a4,a5,80002fb6 <usertrap+0x8c>
  else if ((which_dev = devintr()) != 0)
    80002f72:	00000097          	auipc	ra,0x0
    80002f76:	f12080e7          	jalr	-238(ra) # 80002e84 <devintr>
    80002f7a:	892a                	mv	s2,a0
    80002f7c:	c551                	beqz	a0,80003008 <usertrap+0xde>
  if (killed(p))
    80002f7e:	8526                	mv	a0,s1
    80002f80:	00000097          	auipc	ra,0x0
    80002f84:	890080e7          	jalr	-1904(ra) # 80002810 <killed>
    80002f88:	c179                	beqz	a0,8000304e <usertrap+0x124>
    80002f8a:	a86d                	j	80003044 <usertrap+0x11a>
    panic("usertrap: not from user mode");
    80002f8c:	00005517          	auipc	a0,0x5
    80002f90:	47450513          	add	a0,a0,1140 # 80008400 <etext+0x400>
    80002f94:	ffffd097          	auipc	ra,0xffffd
    80002f98:	5a8080e7          	jalr	1448(ra) # 8000053c <panic>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002f9c:	143025f3          	csrr	a1,stval
    p->killed = removecopy(p->pagetable,r_stval(), PGROUNDDOWN(p->trapframe->sp)); // kill the process
    80002fa0:	6d3c                	ld	a5,88(a0)
    80002fa2:	7b9c                	ld	a5,48(a5)
    80002fa4:	767d                	lui	a2,0xfffff
    80002fa6:	8e7d                	and	a2,a2,a5
    80002fa8:	6928                	ld	a0,80(a0)
    80002faa:	ffffe097          	auipc	ra,0xffffe
    80002fae:	7ea080e7          	jalr	2026(ra) # 80001794 <removecopy>
    80002fb2:	d488                	sw	a0,40(s1)
    80002fb4:	a025                	j	80002fdc <usertrap+0xb2>
    if (killed(p))
    80002fb6:	00000097          	auipc	ra,0x0
    80002fba:	85a080e7          	jalr	-1958(ra) # 80002810 <killed>
    80002fbe:	ed1d                	bnez	a0,80002ffc <usertrap+0xd2>
    p->trapframe->epc += 4;
    80002fc0:	6cb8                	ld	a4,88(s1)
    80002fc2:	6f1c                	ld	a5,24(a4)
    80002fc4:	0791                	add	a5,a5,4
    80002fc6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002fc8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002fcc:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002fd0:	10079073          	csrw	sstatus,a5
    syscall();
    80002fd4:	00000097          	auipc	ra,0x0
    80002fd8:	32a080e7          	jalr	810(ra) # 800032fe <syscall>
  if (killed(p))
    80002fdc:	8526                	mv	a0,s1
    80002fde:	00000097          	auipc	ra,0x0
    80002fe2:	832080e7          	jalr	-1998(ra) # 80002810 <killed>
    80002fe6:	ed31                	bnez	a0,80003042 <usertrap+0x118>
  usertrapret();
    80002fe8:	00000097          	auipc	ra,0x0
    80002fec:	d38080e7          	jalr	-712(ra) # 80002d20 <usertrapret>
}
    80002ff0:	60e2                	ld	ra,24(sp)
    80002ff2:	6442                	ld	s0,16(sp)
    80002ff4:	64a2                	ld	s1,8(sp)
    80002ff6:	6902                	ld	s2,0(sp)
    80002ff8:	6105                	add	sp,sp,32
    80002ffa:	8082                	ret
      exit(-1);
    80002ffc:	557d                	li	a0,-1
    80002ffe:	fffff097          	auipc	ra,0xfffff
    80003002:	61a080e7          	jalr	1562(ra) # 80002618 <exit>
    80003006:	bf6d                	j	80002fc0 <usertrap+0x96>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003008:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000300c:	5890                	lw	a2,48(s1)
    8000300e:	00005517          	auipc	a0,0x5
    80003012:	41250513          	add	a0,a0,1042 # 80008420 <etext+0x420>
    80003016:	ffffd097          	auipc	ra,0xffffd
    8000301a:	570080e7          	jalr	1392(ra) # 80000586 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000301e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003022:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003026:	00005517          	auipc	a0,0x5
    8000302a:	42a50513          	add	a0,a0,1066 # 80008450 <etext+0x450>
    8000302e:	ffffd097          	auipc	ra,0xffffd
    80003032:	558080e7          	jalr	1368(ra) # 80000586 <printf>
    setkilled(p);
    80003036:	8526                	mv	a0,s1
    80003038:	fffff097          	auipc	ra,0xfffff
    8000303c:	7ac080e7          	jalr	1964(ra) # 800027e4 <setkilled>
    80003040:	bf71                	j	80002fdc <usertrap+0xb2>
  if (killed(p))
    80003042:	4901                	li	s2,0
    exit(-1);
    80003044:	557d                	li	a0,-1
    80003046:	fffff097          	auipc	ra,0xfffff
    8000304a:	5d2080e7          	jalr	1490(ra) # 80002618 <exit>
  if (which_dev == 2)
    8000304e:	4789                	li	a5,2
    80003050:	f8f91ce3          	bne	s2,a5,80002fe8 <usertrap+0xbe>
    if(p->ticks != 0)
    80003054:	1744a783          	lw	a5,372(s1)
    80003058:	cf81                	beqz	a5,80003070 <usertrap+0x146>
      if(p->current_ticks == p->ticks + 1)
    8000305a:	1784a703          	lw	a4,376(s1)
    8000305e:	0017869b          	addw	a3,a5,1
    80003062:	00e68c63          	beq	a3,a4,8000307a <usertrap+0x150>
      else if(p->ticks > 0)
    80003066:	00f05563          	blez	a5,80003070 <usertrap+0x146>
        p->current_ticks = p->current_ticks + 1;
    8000306a:	2705                	addw	a4,a4,1
    8000306c:	16e4ac23          	sw	a4,376(s1)
    yield();
    80003070:	fffff097          	auipc	ra,0xfffff
    80003074:	480080e7          	jalr	1152(ra) # 800024f0 <yield>
    80003078:	bf85                	j	80002fe8 <usertrap+0xbe>
        p->current_ticks = p->current_ticks + 1;
    8000307a:	2705                	addw	a4,a4,1
    8000307c:	16e4ac23          	sw	a4,376(s1)
        p->sigalarm = kalloc();
    80003080:	ffffe097          	auipc	ra,0xffffe
    80003084:	afe080e7          	jalr	-1282(ra) # 80000b7e <kalloc>
    80003088:	18a4b023          	sd	a0,384(s1)
        if (p->sigalarm) 
    8000308c:	d175                	beqz	a0,80003070 <usertrap+0x146>
          memset(p->sigalarm, 0, PGSIZE); // Initialize to zero
    8000308e:	6605                	lui	a2,0x1
    80003090:	4581                	li	a1,0
    80003092:	ffffe097          	auipc	ra,0xffffe
    80003096:	d3a080e7          	jalr	-710(ra) # 80000dcc <memset>
          memmove(p->sigalarm, p->trapframe, PGSIZE);
    8000309a:	6605                	lui	a2,0x1
    8000309c:	6cac                	ld	a1,88(s1)
    8000309e:	1804b503          	ld	a0,384(s1)
    800030a2:	ffffe097          	auipc	ra,0xffffe
    800030a6:	d86080e7          	jalr	-634(ra) # 80000e28 <memmove>
          p->trapframe->epc = p->handler;
    800030aa:	6cbc                	ld	a5,88(s1)
    800030ac:	1904b703          	ld	a4,400(s1)
    800030b0:	ef98                	sd	a4,24(a5)
    800030b2:	bf7d                	j	80003070 <usertrap+0x146>

00000000800030b4 <kerneltrap>:
{
    800030b4:	7179                	add	sp,sp,-48
    800030b6:	f406                	sd	ra,40(sp)
    800030b8:	f022                	sd	s0,32(sp)
    800030ba:	ec26                	sd	s1,24(sp)
    800030bc:	e84a                	sd	s2,16(sp)
    800030be:	e44e                	sd	s3,8(sp)
    800030c0:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800030c2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800030c6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800030ca:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    800030ce:	1004f793          	and	a5,s1,256
    800030d2:	cb85                	beqz	a5,80003102 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800030d4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800030d8:	8b89                	and	a5,a5,2
  if (intr_get() != 0)
    800030da:	ef85                	bnez	a5,80003112 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    800030dc:	00000097          	auipc	ra,0x0
    800030e0:	da8080e7          	jalr	-600(ra) # 80002e84 <devintr>
    800030e4:	cd1d                	beqz	a0,80003122 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800030e6:	4789                	li	a5,2
    800030e8:	06f50a63          	beq	a0,a5,8000315c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800030ec:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800030f0:	10049073          	csrw	sstatus,s1
}
    800030f4:	70a2                	ld	ra,40(sp)
    800030f6:	7402                	ld	s0,32(sp)
    800030f8:	64e2                	ld	s1,24(sp)
    800030fa:	6942                	ld	s2,16(sp)
    800030fc:	69a2                	ld	s3,8(sp)
    800030fe:	6145                	add	sp,sp,48
    80003100:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80003102:	00005517          	auipc	a0,0x5
    80003106:	36e50513          	add	a0,a0,878 # 80008470 <etext+0x470>
    8000310a:	ffffd097          	auipc	ra,0xffffd
    8000310e:	432080e7          	jalr	1074(ra) # 8000053c <panic>
    panic("kerneltrap: interrupts enabled");
    80003112:	00005517          	auipc	a0,0x5
    80003116:	38650513          	add	a0,a0,902 # 80008498 <etext+0x498>
    8000311a:	ffffd097          	auipc	ra,0xffffd
    8000311e:	422080e7          	jalr	1058(ra) # 8000053c <panic>
    printf("scause %p\n", scause);
    80003122:	85ce                	mv	a1,s3
    80003124:	00005517          	auipc	a0,0x5
    80003128:	39450513          	add	a0,a0,916 # 800084b8 <etext+0x4b8>
    8000312c:	ffffd097          	auipc	ra,0xffffd
    80003130:	45a080e7          	jalr	1114(ra) # 80000586 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003134:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003138:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000313c:	00005517          	auipc	a0,0x5
    80003140:	38c50513          	add	a0,a0,908 # 800084c8 <etext+0x4c8>
    80003144:	ffffd097          	auipc	ra,0xffffd
    80003148:	442080e7          	jalr	1090(ra) # 80000586 <printf>
    panic("kerneltrap");
    8000314c:	00005517          	auipc	a0,0x5
    80003150:	39450513          	add	a0,a0,916 # 800084e0 <etext+0x4e0>
    80003154:	ffffd097          	auipc	ra,0xffffd
    80003158:	3e8080e7          	jalr	1000(ra) # 8000053c <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000315c:	fffff097          	auipc	ra,0xfffff
    80003160:	c54080e7          	jalr	-940(ra) # 80001db0 <myproc>
    80003164:	d541                	beqz	a0,800030ec <kerneltrap+0x38>
    80003166:	fffff097          	auipc	ra,0xfffff
    8000316a:	c4a080e7          	jalr	-950(ra) # 80001db0 <myproc>
    8000316e:	4d18                	lw	a4,24(a0)
    80003170:	4791                	li	a5,4
    80003172:	f6f71de3          	bne	a4,a5,800030ec <kerneltrap+0x38>
    yield();
    80003176:	fffff097          	auipc	ra,0xfffff
    8000317a:	37a080e7          	jalr	890(ra) # 800024f0 <yield>
    8000317e:	b7bd                	j	800030ec <kerneltrap+0x38>

0000000080003180 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80003180:	1101                	add	sp,sp,-32
    80003182:	ec06                	sd	ra,24(sp)
    80003184:	e822                	sd	s0,16(sp)
    80003186:	e426                	sd	s1,8(sp)
    80003188:	1000                	add	s0,sp,32
    8000318a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000318c:	fffff097          	auipc	ra,0xfffff
    80003190:	c24080e7          	jalr	-988(ra) # 80001db0 <myproc>
  switch (n) {
    80003194:	4795                	li	a5,5
    80003196:	0497e163          	bltu	a5,s1,800031d8 <argraw+0x58>
    8000319a:	048a                	sll	s1,s1,0x2
    8000319c:	00005717          	auipc	a4,0x5
    800031a0:	72c70713          	add	a4,a4,1836 # 800088c8 <states.0+0x30>
    800031a4:	94ba                	add	s1,s1,a4
    800031a6:	409c                	lw	a5,0(s1)
    800031a8:	97ba                	add	a5,a5,a4
    800031aa:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800031ac:	6d3c                	ld	a5,88(a0)
    800031ae:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800031b0:	60e2                	ld	ra,24(sp)
    800031b2:	6442                	ld	s0,16(sp)
    800031b4:	64a2                	ld	s1,8(sp)
    800031b6:	6105                	add	sp,sp,32
    800031b8:	8082                	ret
    return p->trapframe->a1;
    800031ba:	6d3c                	ld	a5,88(a0)
    800031bc:	7fa8                	ld	a0,120(a5)
    800031be:	bfcd                	j	800031b0 <argraw+0x30>
    return p->trapframe->a2;
    800031c0:	6d3c                	ld	a5,88(a0)
    800031c2:	63c8                	ld	a0,128(a5)
    800031c4:	b7f5                	j	800031b0 <argraw+0x30>
    return p->trapframe->a3;
    800031c6:	6d3c                	ld	a5,88(a0)
    800031c8:	67c8                	ld	a0,136(a5)
    800031ca:	b7dd                	j	800031b0 <argraw+0x30>
    return p->trapframe->a4;
    800031cc:	6d3c                	ld	a5,88(a0)
    800031ce:	6bc8                	ld	a0,144(a5)
    800031d0:	b7c5                	j	800031b0 <argraw+0x30>
    return p->trapframe->a5;
    800031d2:	6d3c                	ld	a5,88(a0)
    800031d4:	6fc8                	ld	a0,152(a5)
    800031d6:	bfe9                	j	800031b0 <argraw+0x30>
  panic("argraw");
    800031d8:	00005517          	auipc	a0,0x5
    800031dc:	31850513          	add	a0,a0,792 # 800084f0 <etext+0x4f0>
    800031e0:	ffffd097          	auipc	ra,0xffffd
    800031e4:	35c080e7          	jalr	860(ra) # 8000053c <panic>

00000000800031e8 <fetchaddr>:
{
    800031e8:	1101                	add	sp,sp,-32
    800031ea:	ec06                	sd	ra,24(sp)
    800031ec:	e822                	sd	s0,16(sp)
    800031ee:	e426                	sd	s1,8(sp)
    800031f0:	e04a                	sd	s2,0(sp)
    800031f2:	1000                	add	s0,sp,32
    800031f4:	84aa                	mv	s1,a0
    800031f6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800031f8:	fffff097          	auipc	ra,0xfffff
    800031fc:	bb8080e7          	jalr	-1096(ra) # 80001db0 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003200:	653c                	ld	a5,72(a0)
    80003202:	02f4f863          	bgeu	s1,a5,80003232 <fetchaddr+0x4a>
    80003206:	00848713          	add	a4,s1,8
    8000320a:	02e7e663          	bltu	a5,a4,80003236 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000320e:	46a1                	li	a3,8
    80003210:	8626                	mv	a2,s1
    80003212:	85ca                	mv	a1,s2
    80003214:	6928                	ld	a0,80(a0)
    80003216:	ffffe097          	auipc	ra,0xffffe
    8000321a:	758080e7          	jalr	1880(ra) # 8000196e <copyin>
    8000321e:	00a03533          	snez	a0,a0
    80003222:	40a00533          	neg	a0,a0
}
    80003226:	60e2                	ld	ra,24(sp)
    80003228:	6442                	ld	s0,16(sp)
    8000322a:	64a2                	ld	s1,8(sp)
    8000322c:	6902                	ld	s2,0(sp)
    8000322e:	6105                	add	sp,sp,32
    80003230:	8082                	ret
    return -1;
    80003232:	557d                	li	a0,-1
    80003234:	bfcd                	j	80003226 <fetchaddr+0x3e>
    80003236:	557d                	li	a0,-1
    80003238:	b7fd                	j	80003226 <fetchaddr+0x3e>

000000008000323a <fetchstr>:
{
    8000323a:	7179                	add	sp,sp,-48
    8000323c:	f406                	sd	ra,40(sp)
    8000323e:	f022                	sd	s0,32(sp)
    80003240:	ec26                	sd	s1,24(sp)
    80003242:	e84a                	sd	s2,16(sp)
    80003244:	e44e                	sd	s3,8(sp)
    80003246:	1800                	add	s0,sp,48
    80003248:	892a                	mv	s2,a0
    8000324a:	84ae                	mv	s1,a1
    8000324c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000324e:	fffff097          	auipc	ra,0xfffff
    80003252:	b62080e7          	jalr	-1182(ra) # 80001db0 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80003256:	86ce                	mv	a3,s3
    80003258:	864a                	mv	a2,s2
    8000325a:	85a6                	mv	a1,s1
    8000325c:	6928                	ld	a0,80(a0)
    8000325e:	ffffe097          	auipc	ra,0xffffe
    80003262:	79e080e7          	jalr	1950(ra) # 800019fc <copyinstr>
    80003266:	00054e63          	bltz	a0,80003282 <fetchstr+0x48>
  return strlen(buf);
    8000326a:	8526                	mv	a0,s1
    8000326c:	ffffe097          	auipc	ra,0xffffe
    80003270:	cda080e7          	jalr	-806(ra) # 80000f46 <strlen>
}
    80003274:	70a2                	ld	ra,40(sp)
    80003276:	7402                	ld	s0,32(sp)
    80003278:	64e2                	ld	s1,24(sp)
    8000327a:	6942                	ld	s2,16(sp)
    8000327c:	69a2                	ld	s3,8(sp)
    8000327e:	6145                	add	sp,sp,48
    80003280:	8082                	ret
    return -1;
    80003282:	557d                	li	a0,-1
    80003284:	bfc5                	j	80003274 <fetchstr+0x3a>

0000000080003286 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80003286:	1101                	add	sp,sp,-32
    80003288:	ec06                	sd	ra,24(sp)
    8000328a:	e822                	sd	s0,16(sp)
    8000328c:	e426                	sd	s1,8(sp)
    8000328e:	1000                	add	s0,sp,32
    80003290:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003292:	00000097          	auipc	ra,0x0
    80003296:	eee080e7          	jalr	-274(ra) # 80003180 <argraw>
    8000329a:	c088                	sw	a0,0(s1)
}
    8000329c:	60e2                	ld	ra,24(sp)
    8000329e:	6442                	ld	s0,16(sp)
    800032a0:	64a2                	ld	s1,8(sp)
    800032a2:	6105                	add	sp,sp,32
    800032a4:	8082                	ret

00000000800032a6 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800032a6:	1101                	add	sp,sp,-32
    800032a8:	ec06                	sd	ra,24(sp)
    800032aa:	e822                	sd	s0,16(sp)
    800032ac:	e426                	sd	s1,8(sp)
    800032ae:	1000                	add	s0,sp,32
    800032b0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800032b2:	00000097          	auipc	ra,0x0
    800032b6:	ece080e7          	jalr	-306(ra) # 80003180 <argraw>
    800032ba:	e088                	sd	a0,0(s1)
}
    800032bc:	60e2                	ld	ra,24(sp)
    800032be:	6442                	ld	s0,16(sp)
    800032c0:	64a2                	ld	s1,8(sp)
    800032c2:	6105                	add	sp,sp,32
    800032c4:	8082                	ret

00000000800032c6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800032c6:	7179                	add	sp,sp,-48
    800032c8:	f406                	sd	ra,40(sp)
    800032ca:	f022                	sd	s0,32(sp)
    800032cc:	ec26                	sd	s1,24(sp)
    800032ce:	e84a                	sd	s2,16(sp)
    800032d0:	1800                	add	s0,sp,48
    800032d2:	84ae                	mv	s1,a1
    800032d4:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800032d6:	fd840593          	add	a1,s0,-40
    800032da:	00000097          	auipc	ra,0x0
    800032de:	fcc080e7          	jalr	-52(ra) # 800032a6 <argaddr>
  return fetchstr(addr, buf, max);
    800032e2:	864a                	mv	a2,s2
    800032e4:	85a6                	mv	a1,s1
    800032e6:	fd843503          	ld	a0,-40(s0)
    800032ea:	00000097          	auipc	ra,0x0
    800032ee:	f50080e7          	jalr	-176(ra) # 8000323a <fetchstr>
}
    800032f2:	70a2                	ld	ra,40(sp)
    800032f4:	7402                	ld	s0,32(sp)
    800032f6:	64e2                	ld	s1,24(sp)
    800032f8:	6942                	ld	s2,16(sp)
    800032fa:	6145                	add	sp,sp,48
    800032fc:	8082                	ret

00000000800032fe <syscall>:
[SYS_set_priority] sys_set_priority, // set_priority
};

void
syscall(void)
{
    800032fe:	1101                	add	sp,sp,-32
    80003300:	ec06                	sd	ra,24(sp)
    80003302:	e822                	sd	s0,16(sp)
    80003304:	e426                	sd	s1,8(sp)
    80003306:	e04a                	sd	s2,0(sp)
    80003308:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000330a:	fffff097          	auipc	ra,0xfffff
    8000330e:	aa6080e7          	jalr	-1370(ra) # 80001db0 <myproc>
    80003312:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003314:	05853903          	ld	s2,88(a0)
    80003318:	0a893783          	ld	a5,168(s2)
    8000331c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003320:	37fd                	addw	a5,a5,-1
    80003322:	4765                	li	a4,25
    80003324:	00f76f63          	bltu	a4,a5,80003342 <syscall+0x44>
    80003328:	00369713          	sll	a4,a3,0x3
    8000332c:	00005797          	auipc	a5,0x5
    80003330:	5b478793          	add	a5,a5,1460 # 800088e0 <syscalls>
    80003334:	97ba                	add	a5,a5,a4
    80003336:	639c                	ld	a5,0(a5)
    80003338:	c789                	beqz	a5,80003342 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000333a:	9782                	jalr	a5
    8000333c:	06a93823          	sd	a0,112(s2)
    80003340:	a839                	j	8000335e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003342:	15848613          	add	a2,s1,344
    80003346:	588c                	lw	a1,48(s1)
    80003348:	00005517          	auipc	a0,0x5
    8000334c:	1b050513          	add	a0,a0,432 # 800084f8 <etext+0x4f8>
    80003350:	ffffd097          	auipc	ra,0xffffd
    80003354:	236080e7          	jalr	566(ra) # 80000586 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003358:	6cbc                	ld	a5,88(s1)
    8000335a:	577d                	li	a4,-1
    8000335c:	fbb8                	sd	a4,112(a5)
  }
}
    8000335e:	60e2                	ld	ra,24(sp)
    80003360:	6442                	ld	s0,16(sp)
    80003362:	64a2                	ld	s1,8(sp)
    80003364:	6902                	ld	s2,0(sp)
    80003366:	6105                	add	sp,sp,32
    80003368:	8082                	ret

000000008000336a <sys_sigalarm>:
#include "globals.h"



uint64 sys_sigalarm(void)          // sigalarm
{
    8000336a:	1141                	add	sp,sp,-16
    8000336c:	e406                	sd	ra,8(sp)
    8000336e:	e022                	sd	s0,0(sp)
    80003370:	0800                	add	s0,sp,16
  myproc()->current_ticks = 0;     // update ticks
    80003372:	fffff097          	auipc	ra,0xfffff
    80003376:	a3e080e7          	jalr	-1474(ra) # 80001db0 <myproc>
    8000337a:	16052c23          	sw	zero,376(a0)
  argint(0, &myproc()->ticks);     // 1st argument retrieve an integer argument from the user's memory space.
    8000337e:	fffff097          	auipc	ra,0xfffff
    80003382:	a32080e7          	jalr	-1486(ra) # 80001db0 <myproc>
    80003386:	17450593          	add	a1,a0,372
    8000338a:	4501                	li	a0,0
    8000338c:	00000097          	auipc	ra,0x0
    80003390:	efa080e7          	jalr	-262(ra) # 80003286 <argint>
  argaddr(1, &myproc()->handler);  // 2nd argument retrieve an address (pointer) argument from the user's memory space.
    80003394:	fffff097          	auipc	ra,0xfffff
    80003398:	a1c080e7          	jalr	-1508(ra) # 80001db0 <myproc>
    8000339c:	19050593          	add	a1,a0,400
    800033a0:	4505                	li	a0,1
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	f04080e7          	jalr	-252(ra) # 800032a6 <argaddr>
  return 0;
}
    800033aa:	4501                	li	a0,0
    800033ac:	60a2                	ld	ra,8(sp)
    800033ae:	6402                	ld	s0,0(sp)
    800033b0:	0141                	add	sp,sp,16
    800033b2:	8082                	ret

00000000800033b4 <sys_sigreturn>:

uint64 sys_sigreturn(void)        // sigreturn gpt
{
    800033b4:	1101                	add	sp,sp,-32
    800033b6:	ec06                	sd	ra,24(sp)
    800033b8:	e822                	sd	s0,16(sp)
    800033ba:	e426                	sd	s1,8(sp)
    800033bc:	1000                	add	s0,sp,32
    struct proc* p = myproc();
    800033be:	fffff097          	auipc	ra,0xfffff
    800033c2:	9f2080e7          	jalr	-1550(ra) # 80001db0 <myproc>
    800033c6:	84aa                	mv	s1,a0

    // Restore the saved trapframe from sigalarm
    memmove(p->trapframe, p->sigalarm, PGSIZE);
    800033c8:	6605                	lui	a2,0x1
    800033ca:	18053583          	ld	a1,384(a0)
    800033ce:	6d28                	ld	a0,88(a0)
    800033d0:	ffffe097          	auipc	ra,0xffffe
    800033d4:	a58080e7          	jalr	-1448(ra) # 80000e28 <memmove>

    // Free the memory allocated for sigalarm
    kfree(p->sigalarm);
    800033d8:	1804b503          	ld	a0,384(s1)
    800033dc:	ffffd097          	auipc	ra,0xffffd
    800033e0:	608080e7          	jalr	1544(ra) # 800009e4 <kfree>
    // p->sigalarm = NULL;
    
    // if(p->sigalarm)
    //   return -1;
    // Reset current_ticks to 0
    p->current_ticks = 0;
    800033e4:	1604ac23          	sw	zero,376(s1)

    // Return the value of a0 from the restored trapframe
    return p->trapframe->a0;
    800033e8:	6cbc                	ld	a5,88(s1)
}
    800033ea:	7ba8                	ld	a0,112(a5)
    800033ec:	60e2                	ld	ra,24(sp)
    800033ee:	6442                	ld	s0,16(sp)
    800033f0:	64a2                	ld	s1,8(sp)
    800033f2:	6105                	add	sp,sp,32
    800033f4:	8082                	ret

00000000800033f6 <sys_set_priority>:



uint64 sys_set_priority(void)   // chat gpt 
{                               // copilot
    800033f6:	7179                	add	sp,sp,-48
    800033f8:	f406                	sd	ra,40(sp)
    800033fa:	f022                	sd	s0,32(sp)
    800033fc:	ec26                	sd	s1,24(sp)
    800033fe:	e84a                	sd	s2,16(sp)
    80003400:	1800                	add	s0,sp,48
  int pid, priority;
  int oldpriority = 0, flag = 0;
  argint(0, &priority);
    80003402:	fd840593          	add	a1,s0,-40
    80003406:	4501                	li	a0,0
    80003408:	00000097          	auipc	ra,0x0
    8000340c:	e7e080e7          	jalr	-386(ra) # 80003286 <argint>
  argint(1, &pid);
    80003410:	fdc40593          	add	a1,s0,-36
    80003414:	4505                	li	a0,1
    80003416:	00000097          	auipc	ra,0x0
    8000341a:	e70080e7          	jalr	-400(ra) # 80003286 <argint>
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
    8000341e:	0022e497          	auipc	s1,0x22e
    80003422:	cda48493          	add	s1,s1,-806 # 802310f8 <proc>
    80003426:	00235917          	auipc	s2,0x235
    8000342a:	2d290913          	add	s2,s2,722 # 802386f8 <tickslock>
  {
    acquire(&p->lock);
    8000342e:	8526                	mv	a0,s1
    80003430:	ffffe097          	auipc	ra,0xffffe
    80003434:	8a0080e7          	jalr	-1888(ra) # 80000cd0 <acquire>
    if (p->pid == pid)
    80003438:	5898                	lw	a4,48(s1)
    8000343a:	fdc42783          	lw	a5,-36(s0)
    8000343e:	02f70763          	beq	a4,a5,8000346c <sys_set_priority+0x76>
      p->priority = priority;
      release(&p->lock);
      flag = 1;
      break;
    }
    release(&p->lock);
    80003442:	8526                	mv	a0,s1
    80003444:	ffffe097          	auipc	ra,0xffffe
    80003448:	940080e7          	jalr	-1728(ra) # 80000d84 <release>
  for (p = proc; p < &proc[NPROC]; p++)
    8000344c:	1d848493          	add	s1,s1,472
    80003450:	fd249fe3          	bne	s1,s2,8000342e <sys_set_priority+0x38>
  }
  if (flag == 0)
  {
    printf("Process with PID %d does not exist\n", pid);
    80003454:	fdc42583          	lw	a1,-36(s0)
    80003458:	00005517          	auipc	a0,0x5
    8000345c:	0c050513          	add	a0,a0,192 # 80008518 <etext+0x518>
    80003460:	ffffd097          	auipc	ra,0xffffd
    80003464:	126080e7          	jalr	294(ra) # 80000586 <printf>
    return -1;
    80003468:	557d                	li	a0,-1
    8000346a:	a02d                	j	80003494 <sys_set_priority+0x9e>
      oldpriority = p->priority;
    8000346c:	1cc4a903          	lw	s2,460(s1)
      p->dynamic_priority = priority + 25;
    80003470:	fd842783          	lw	a5,-40(s0)
    80003474:	0197871b          	addw	a4,a5,25
    80003478:	1ce4a823          	sw	a4,464(s1)
      p->priority = priority;
    8000347c:	1cf4a623          	sw	a5,460(s1)
      release(&p->lock);
    80003480:	8526                	mv	a0,s1
    80003482:	ffffe097          	auipc	ra,0xffffe
    80003486:	902080e7          	jalr	-1790(ra) # 80000d84 <release>
  }
  if (oldpriority > priority)
    8000348a:	fd842783          	lw	a5,-40(s0)
    8000348e:	0127c963          	blt	a5,s2,800034a0 <sys_set_priority+0xaa>
    yield();
  // printf("set_priority: %d %d %d\n", pid, oldpriority, priority);
  return oldpriority;
    80003492:	854a                	mv	a0,s2
}
    80003494:	70a2                	ld	ra,40(sp)
    80003496:	7402                	ld	s0,32(sp)
    80003498:	64e2                	ld	s1,24(sp)
    8000349a:	6942                	ld	s2,16(sp)
    8000349c:	6145                	add	sp,sp,48
    8000349e:	8082                	ret
    yield();
    800034a0:	fffff097          	auipc	ra,0xfffff
    800034a4:	050080e7          	jalr	80(ra) # 800024f0 <yield>
    800034a8:	b7ed                	j	80003492 <sys_set_priority+0x9c>

00000000800034aa <sys_exit>:


uint64
sys_exit(void)
{
    800034aa:	1101                	add	sp,sp,-32
    800034ac:	ec06                	sd	ra,24(sp)
    800034ae:	e822                	sd	s0,16(sp)
    800034b0:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    800034b2:	fec40593          	add	a1,s0,-20
    800034b6:	4501                	li	a0,0
    800034b8:	00000097          	auipc	ra,0x0
    800034bc:	dce080e7          	jalr	-562(ra) # 80003286 <argint>
  exit(n);
    800034c0:	fec42503          	lw	a0,-20(s0)
    800034c4:	fffff097          	auipc	ra,0xfffff
    800034c8:	154080e7          	jalr	340(ra) # 80002618 <exit>
  return 0; // not reached
}
    800034cc:	4501                	li	a0,0
    800034ce:	60e2                	ld	ra,24(sp)
    800034d0:	6442                	ld	s0,16(sp)
    800034d2:	6105                	add	sp,sp,32
    800034d4:	8082                	ret

00000000800034d6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800034d6:	1141                	add	sp,sp,-16
    800034d8:	e406                	sd	ra,8(sp)
    800034da:	e022                	sd	s0,0(sp)
    800034dc:	0800                	add	s0,sp,16
  return myproc()->pid;
    800034de:	fffff097          	auipc	ra,0xfffff
    800034e2:	8d2080e7          	jalr	-1838(ra) # 80001db0 <myproc>
}
    800034e6:	5908                	lw	a0,48(a0)
    800034e8:	60a2                	ld	ra,8(sp)
    800034ea:	6402                	ld	s0,0(sp)
    800034ec:	0141                	add	sp,sp,16
    800034ee:	8082                	ret

00000000800034f0 <sys_fork>:

uint64
sys_fork(void)
{
    800034f0:	1141                	add	sp,sp,-16
    800034f2:	e406                	sd	ra,8(sp)
    800034f4:	e022                	sd	s0,0(sp)
    800034f6:	0800                	add	s0,sp,16
  return fork();
    800034f8:	fffff097          	auipc	ra,0xfffff
    800034fc:	db8080e7          	jalr	-584(ra) # 800022b0 <fork>
}
    80003500:	60a2                	ld	ra,8(sp)
    80003502:	6402                	ld	s0,0(sp)
    80003504:	0141                	add	sp,sp,16
    80003506:	8082                	ret

0000000080003508 <sys_wait>:

uint64
sys_wait(void)
{
    80003508:	1101                	add	sp,sp,-32
    8000350a:	ec06                	sd	ra,24(sp)
    8000350c:	e822                	sd	s0,16(sp)
    8000350e:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80003510:	fe840593          	add	a1,s0,-24
    80003514:	4501                	li	a0,0
    80003516:	00000097          	auipc	ra,0x0
    8000351a:	d90080e7          	jalr	-624(ra) # 800032a6 <argaddr>
  return wait(p);
    8000351e:	fe843503          	ld	a0,-24(s0)
    80003522:	fffff097          	auipc	ra,0xfffff
    80003526:	320080e7          	jalr	800(ra) # 80002842 <wait>
}
    8000352a:	60e2                	ld	ra,24(sp)
    8000352c:	6442                	ld	s0,16(sp)
    8000352e:	6105                	add	sp,sp,32
    80003530:	8082                	ret

0000000080003532 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003532:	7179                	add	sp,sp,-48
    80003534:	f406                	sd	ra,40(sp)
    80003536:	f022                	sd	s0,32(sp)
    80003538:	ec26                	sd	s1,24(sp)
    8000353a:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000353c:	fdc40593          	add	a1,s0,-36
    80003540:	4501                	li	a0,0
    80003542:	00000097          	auipc	ra,0x0
    80003546:	d44080e7          	jalr	-700(ra) # 80003286 <argint>
  addr = myproc()->sz;
    8000354a:	fffff097          	auipc	ra,0xfffff
    8000354e:	866080e7          	jalr	-1946(ra) # 80001db0 <myproc>
    80003552:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0)
    80003554:	fdc42503          	lw	a0,-36(s0)
    80003558:	fffff097          	auipc	ra,0xfffff
    8000355c:	cfc080e7          	jalr	-772(ra) # 80002254 <growproc>
    80003560:	00054863          	bltz	a0,80003570 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80003564:	8526                	mv	a0,s1
    80003566:	70a2                	ld	ra,40(sp)
    80003568:	7402                	ld	s0,32(sp)
    8000356a:	64e2                	ld	s1,24(sp)
    8000356c:	6145                	add	sp,sp,48
    8000356e:	8082                	ret
    return -1;
    80003570:	54fd                	li	s1,-1
    80003572:	bfcd                	j	80003564 <sys_sbrk+0x32>

0000000080003574 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003574:	7139                	add	sp,sp,-64
    80003576:	fc06                	sd	ra,56(sp)
    80003578:	f822                	sd	s0,48(sp)
    8000357a:	f426                	sd	s1,40(sp)
    8000357c:	f04a                	sd	s2,32(sp)
    8000357e:	ec4e                	sd	s3,24(sp)
    80003580:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003582:	fcc40593          	add	a1,s0,-52
    80003586:	4501                	li	a0,0
    80003588:	00000097          	auipc	ra,0x0
    8000358c:	cfe080e7          	jalr	-770(ra) # 80003286 <argint>
  acquire(&tickslock);
    80003590:	00235517          	auipc	a0,0x235
    80003594:	16850513          	add	a0,a0,360 # 802386f8 <tickslock>
    80003598:	ffffd097          	auipc	ra,0xffffd
    8000359c:	738080e7          	jalr	1848(ra) # 80000cd0 <acquire>
  ticks0 = ticks;
    800035a0:	00005917          	auipc	s2,0x5
    800035a4:	4a092903          	lw	s2,1184(s2) # 80008a40 <ticks>
  while (ticks - ticks0 < n)
    800035a8:	fcc42783          	lw	a5,-52(s0)
    800035ac:	cf9d                	beqz	a5,800035ea <sys_sleep+0x76>
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800035ae:	00235997          	auipc	s3,0x235
    800035b2:	14a98993          	add	s3,s3,330 # 802386f8 <tickslock>
    800035b6:	00005497          	auipc	s1,0x5
    800035ba:	48a48493          	add	s1,s1,1162 # 80008a40 <ticks>
    if (killed(myproc()))
    800035be:	ffffe097          	auipc	ra,0xffffe
    800035c2:	7f2080e7          	jalr	2034(ra) # 80001db0 <myproc>
    800035c6:	fffff097          	auipc	ra,0xfffff
    800035ca:	24a080e7          	jalr	586(ra) # 80002810 <killed>
    800035ce:	ed15                	bnez	a0,8000360a <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    800035d0:	85ce                	mv	a1,s3
    800035d2:	8526                	mv	a0,s1
    800035d4:	fffff097          	auipc	ra,0xfffff
    800035d8:	126080e7          	jalr	294(ra) # 800026fa <sleep>
  while (ticks - ticks0 < n)
    800035dc:	409c                	lw	a5,0(s1)
    800035de:	412787bb          	subw	a5,a5,s2
    800035e2:	fcc42703          	lw	a4,-52(s0)
    800035e6:	fce7ece3          	bltu	a5,a4,800035be <sys_sleep+0x4a>
  }
  release(&tickslock);
    800035ea:	00235517          	auipc	a0,0x235
    800035ee:	10e50513          	add	a0,a0,270 # 802386f8 <tickslock>
    800035f2:	ffffd097          	auipc	ra,0xffffd
    800035f6:	792080e7          	jalr	1938(ra) # 80000d84 <release>
  return 0;
    800035fa:	4501                	li	a0,0
}
    800035fc:	70e2                	ld	ra,56(sp)
    800035fe:	7442                	ld	s0,48(sp)
    80003600:	74a2                	ld	s1,40(sp)
    80003602:	7902                	ld	s2,32(sp)
    80003604:	69e2                	ld	s3,24(sp)
    80003606:	6121                	add	sp,sp,64
    80003608:	8082                	ret
      release(&tickslock);
    8000360a:	00235517          	auipc	a0,0x235
    8000360e:	0ee50513          	add	a0,a0,238 # 802386f8 <tickslock>
    80003612:	ffffd097          	auipc	ra,0xffffd
    80003616:	772080e7          	jalr	1906(ra) # 80000d84 <release>
      return -1;
    8000361a:	557d                	li	a0,-1
    8000361c:	b7c5                	j	800035fc <sys_sleep+0x88>

000000008000361e <sys_kill>:

uint64
sys_kill(void)
{
    8000361e:	1101                	add	sp,sp,-32
    80003620:	ec06                	sd	ra,24(sp)
    80003622:	e822                	sd	s0,16(sp)
    80003624:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    80003626:	fec40593          	add	a1,s0,-20
    8000362a:	4501                	li	a0,0
    8000362c:	00000097          	auipc	ra,0x0
    80003630:	c5a080e7          	jalr	-934(ra) # 80003286 <argint>
  return kill(pid);
    80003634:	fec42503          	lw	a0,-20(s0)
    80003638:	fffff097          	auipc	ra,0xfffff
    8000363c:	126080e7          	jalr	294(ra) # 8000275e <kill>
}
    80003640:	60e2                	ld	ra,24(sp)
    80003642:	6442                	ld	s0,16(sp)
    80003644:	6105                	add	sp,sp,32
    80003646:	8082                	ret

0000000080003648 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003648:	1101                	add	sp,sp,-32
    8000364a:	ec06                	sd	ra,24(sp)
    8000364c:	e822                	sd	s0,16(sp)
    8000364e:	e426                	sd	s1,8(sp)
    80003650:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003652:	00235517          	auipc	a0,0x235
    80003656:	0a650513          	add	a0,a0,166 # 802386f8 <tickslock>
    8000365a:	ffffd097          	auipc	ra,0xffffd
    8000365e:	676080e7          	jalr	1654(ra) # 80000cd0 <acquire>
  xticks = ticks;
    80003662:	00005497          	auipc	s1,0x5
    80003666:	3de4a483          	lw	s1,990(s1) # 80008a40 <ticks>
  release(&tickslock);
    8000366a:	00235517          	auipc	a0,0x235
    8000366e:	08e50513          	add	a0,a0,142 # 802386f8 <tickslock>
    80003672:	ffffd097          	auipc	ra,0xffffd
    80003676:	712080e7          	jalr	1810(ra) # 80000d84 <release>
  return xticks;
}
    8000367a:	02049513          	sll	a0,s1,0x20
    8000367e:	9101                	srl	a0,a0,0x20
    80003680:	60e2                	ld	ra,24(sp)
    80003682:	6442                	ld	s0,16(sp)
    80003684:	64a2                	ld	s1,8(sp)
    80003686:	6105                	add	sp,sp,32
    80003688:	8082                	ret

000000008000368a <sys_waitx>:

uint64
sys_waitx(void)
{
    8000368a:	7139                	add	sp,sp,-64
    8000368c:	fc06                	sd	ra,56(sp)
    8000368e:	f822                	sd	s0,48(sp)
    80003690:	f426                	sd	s1,40(sp)
    80003692:	f04a                	sd	s2,32(sp)
    80003694:	0080                	add	s0,sp,64
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
    80003696:	fd840593          	add	a1,s0,-40
    8000369a:	4501                	li	a0,0
    8000369c:	00000097          	auipc	ra,0x0
    800036a0:	c0a080e7          	jalr	-1014(ra) # 800032a6 <argaddr>
  argaddr(1, &addr1); // user virtual memory
    800036a4:	fd040593          	add	a1,s0,-48
    800036a8:	4505                	li	a0,1
    800036aa:	00000097          	auipc	ra,0x0
    800036ae:	bfc080e7          	jalr	-1028(ra) # 800032a6 <argaddr>
  argaddr(2, &addr2);
    800036b2:	fc840593          	add	a1,s0,-56
    800036b6:	4509                	li	a0,2
    800036b8:	00000097          	auipc	ra,0x0
    800036bc:	bee080e7          	jalr	-1042(ra) # 800032a6 <argaddr>
  int ret = waitx(addr, &wtime, &rtime);
    800036c0:	fc040613          	add	a2,s0,-64
    800036c4:	fc440593          	add	a1,s0,-60
    800036c8:	fd843503          	ld	a0,-40(s0)
    800036cc:	fffff097          	auipc	ra,0xfffff
    800036d0:	45e080e7          	jalr	1118(ra) # 80002b2a <waitx>
    800036d4:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800036d6:	ffffe097          	auipc	ra,0xffffe
    800036da:	6da080e7          	jalr	1754(ra) # 80001db0 <myproc>
    800036de:	84aa                	mv	s1,a0
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    800036e0:	4691                	li	a3,4
    800036e2:	fc440613          	add	a2,s0,-60
    800036e6:	fd043583          	ld	a1,-48(s0)
    800036ea:	6928                	ld	a0,80(a0)
    800036ec:	ffffe097          	auipc	ra,0xffffe
    800036f0:	1bc080e7          	jalr	444(ra) # 800018a8 <copyout>
    return -1;
    800036f4:	57fd                	li	a5,-1
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    800036f6:	00054f63          	bltz	a0,80003714 <sys_waitx+0x8a>
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    800036fa:	4691                	li	a3,4
    800036fc:	fc040613          	add	a2,s0,-64
    80003700:	fc843583          	ld	a1,-56(s0)
    80003704:	68a8                	ld	a0,80(s1)
    80003706:	ffffe097          	auipc	ra,0xffffe
    8000370a:	1a2080e7          	jalr	418(ra) # 800018a8 <copyout>
    8000370e:	00054a63          	bltz	a0,80003722 <sys_waitx+0x98>
    return -1;
  return ret;
    80003712:	87ca                	mv	a5,s2
    80003714:	853e                	mv	a0,a5
    80003716:	70e2                	ld	ra,56(sp)
    80003718:	7442                	ld	s0,48(sp)
    8000371a:	74a2                	ld	s1,40(sp)
    8000371c:	7902                	ld	s2,32(sp)
    8000371e:	6121                	add	sp,sp,64
    80003720:	8082                	ret
    return -1;
    80003722:	57fd                	li	a5,-1
    80003724:	bfc5                	j	80003714 <sys_waitx+0x8a>

0000000080003726 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003726:	7179                	add	sp,sp,-48
    80003728:	f406                	sd	ra,40(sp)
    8000372a:	f022                	sd	s0,32(sp)
    8000372c:	ec26                	sd	s1,24(sp)
    8000372e:	e84a                	sd	s2,16(sp)
    80003730:	e44e                	sd	s3,8(sp)
    80003732:	e052                	sd	s4,0(sp)
    80003734:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003736:	00005597          	auipc	a1,0x5
    8000373a:	e0a58593          	add	a1,a1,-502 # 80008540 <etext+0x540>
    8000373e:	00235517          	auipc	a0,0x235
    80003742:	fd250513          	add	a0,a0,-46 # 80238710 <bcache>
    80003746:	ffffd097          	auipc	ra,0xffffd
    8000374a:	4fa080e7          	jalr	1274(ra) # 80000c40 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000374e:	0023d797          	auipc	a5,0x23d
    80003752:	fc278793          	add	a5,a5,-62 # 80240710 <bcache+0x8000>
    80003756:	0023d717          	auipc	a4,0x23d
    8000375a:	22270713          	add	a4,a4,546 # 80240978 <bcache+0x8268>
    8000375e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003762:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003766:	00235497          	auipc	s1,0x235
    8000376a:	fc248493          	add	s1,s1,-62 # 80238728 <bcache+0x18>
    b->next = bcache.head.next;
    8000376e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003770:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003772:	00005a17          	auipc	s4,0x5
    80003776:	dd6a0a13          	add	s4,s4,-554 # 80008548 <etext+0x548>
    b->next = bcache.head.next;
    8000377a:	2b893783          	ld	a5,696(s2)
    8000377e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003780:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003784:	85d2                	mv	a1,s4
    80003786:	01048513          	add	a0,s1,16
    8000378a:	00001097          	auipc	ra,0x1
    8000378e:	496080e7          	jalr	1174(ra) # 80004c20 <initsleeplock>
    bcache.head.next->prev = b;
    80003792:	2b893783          	ld	a5,696(s2)
    80003796:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003798:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000379c:	45848493          	add	s1,s1,1112
    800037a0:	fd349de3          	bne	s1,s3,8000377a <binit+0x54>
  }
}
    800037a4:	70a2                	ld	ra,40(sp)
    800037a6:	7402                	ld	s0,32(sp)
    800037a8:	64e2                	ld	s1,24(sp)
    800037aa:	6942                	ld	s2,16(sp)
    800037ac:	69a2                	ld	s3,8(sp)
    800037ae:	6a02                	ld	s4,0(sp)
    800037b0:	6145                	add	sp,sp,48
    800037b2:	8082                	ret

00000000800037b4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800037b4:	7179                	add	sp,sp,-48
    800037b6:	f406                	sd	ra,40(sp)
    800037b8:	f022                	sd	s0,32(sp)
    800037ba:	ec26                	sd	s1,24(sp)
    800037bc:	e84a                	sd	s2,16(sp)
    800037be:	e44e                	sd	s3,8(sp)
    800037c0:	1800                	add	s0,sp,48
    800037c2:	892a                	mv	s2,a0
    800037c4:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800037c6:	00235517          	auipc	a0,0x235
    800037ca:	f4a50513          	add	a0,a0,-182 # 80238710 <bcache>
    800037ce:	ffffd097          	auipc	ra,0xffffd
    800037d2:	502080e7          	jalr	1282(ra) # 80000cd0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800037d6:	0023d497          	auipc	s1,0x23d
    800037da:	1f24b483          	ld	s1,498(s1) # 802409c8 <bcache+0x82b8>
    800037de:	0023d797          	auipc	a5,0x23d
    800037e2:	19a78793          	add	a5,a5,410 # 80240978 <bcache+0x8268>
    800037e6:	02f48f63          	beq	s1,a5,80003824 <bread+0x70>
    800037ea:	873e                	mv	a4,a5
    800037ec:	a021                	j	800037f4 <bread+0x40>
    800037ee:	68a4                	ld	s1,80(s1)
    800037f0:	02e48a63          	beq	s1,a4,80003824 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800037f4:	449c                	lw	a5,8(s1)
    800037f6:	ff279ce3          	bne	a5,s2,800037ee <bread+0x3a>
    800037fa:	44dc                	lw	a5,12(s1)
    800037fc:	ff3799e3          	bne	a5,s3,800037ee <bread+0x3a>
      b->refcnt++;
    80003800:	40bc                	lw	a5,64(s1)
    80003802:	2785                	addw	a5,a5,1
    80003804:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003806:	00235517          	auipc	a0,0x235
    8000380a:	f0a50513          	add	a0,a0,-246 # 80238710 <bcache>
    8000380e:	ffffd097          	auipc	ra,0xffffd
    80003812:	576080e7          	jalr	1398(ra) # 80000d84 <release>
      acquiresleep(&b->lock);
    80003816:	01048513          	add	a0,s1,16
    8000381a:	00001097          	auipc	ra,0x1
    8000381e:	440080e7          	jalr	1088(ra) # 80004c5a <acquiresleep>
      return b;
    80003822:	a8b9                	j	80003880 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003824:	0023d497          	auipc	s1,0x23d
    80003828:	19c4b483          	ld	s1,412(s1) # 802409c0 <bcache+0x82b0>
    8000382c:	0023d797          	auipc	a5,0x23d
    80003830:	14c78793          	add	a5,a5,332 # 80240978 <bcache+0x8268>
    80003834:	00f48863          	beq	s1,a5,80003844 <bread+0x90>
    80003838:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000383a:	40bc                	lw	a5,64(s1)
    8000383c:	cf81                	beqz	a5,80003854 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000383e:	64a4                	ld	s1,72(s1)
    80003840:	fee49de3          	bne	s1,a4,8000383a <bread+0x86>
  panic("bget: no buffers");
    80003844:	00005517          	auipc	a0,0x5
    80003848:	d0c50513          	add	a0,a0,-756 # 80008550 <etext+0x550>
    8000384c:	ffffd097          	auipc	ra,0xffffd
    80003850:	cf0080e7          	jalr	-784(ra) # 8000053c <panic>
      b->dev = dev;
    80003854:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003858:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000385c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003860:	4785                	li	a5,1
    80003862:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003864:	00235517          	auipc	a0,0x235
    80003868:	eac50513          	add	a0,a0,-340 # 80238710 <bcache>
    8000386c:	ffffd097          	auipc	ra,0xffffd
    80003870:	518080e7          	jalr	1304(ra) # 80000d84 <release>
      acquiresleep(&b->lock);
    80003874:	01048513          	add	a0,s1,16
    80003878:	00001097          	auipc	ra,0x1
    8000387c:	3e2080e7          	jalr	994(ra) # 80004c5a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003880:	409c                	lw	a5,0(s1)
    80003882:	cb89                	beqz	a5,80003894 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003884:	8526                	mv	a0,s1
    80003886:	70a2                	ld	ra,40(sp)
    80003888:	7402                	ld	s0,32(sp)
    8000388a:	64e2                	ld	s1,24(sp)
    8000388c:	6942                	ld	s2,16(sp)
    8000388e:	69a2                	ld	s3,8(sp)
    80003890:	6145                	add	sp,sp,48
    80003892:	8082                	ret
    virtio_disk_rw(b, 0);
    80003894:	4581                	li	a1,0
    80003896:	8526                	mv	a0,s1
    80003898:	00003097          	auipc	ra,0x3
    8000389c:	fba080e7          	jalr	-70(ra) # 80006852 <virtio_disk_rw>
    b->valid = 1;
    800038a0:	4785                	li	a5,1
    800038a2:	c09c                	sw	a5,0(s1)
  return b;
    800038a4:	b7c5                	j	80003884 <bread+0xd0>

00000000800038a6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800038a6:	1101                	add	sp,sp,-32
    800038a8:	ec06                	sd	ra,24(sp)
    800038aa:	e822                	sd	s0,16(sp)
    800038ac:	e426                	sd	s1,8(sp)
    800038ae:	1000                	add	s0,sp,32
    800038b0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800038b2:	0541                	add	a0,a0,16
    800038b4:	00001097          	auipc	ra,0x1
    800038b8:	440080e7          	jalr	1088(ra) # 80004cf4 <holdingsleep>
    800038bc:	cd01                	beqz	a0,800038d4 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800038be:	4585                	li	a1,1
    800038c0:	8526                	mv	a0,s1
    800038c2:	00003097          	auipc	ra,0x3
    800038c6:	f90080e7          	jalr	-112(ra) # 80006852 <virtio_disk_rw>
}
    800038ca:	60e2                	ld	ra,24(sp)
    800038cc:	6442                	ld	s0,16(sp)
    800038ce:	64a2                	ld	s1,8(sp)
    800038d0:	6105                	add	sp,sp,32
    800038d2:	8082                	ret
    panic("bwrite");
    800038d4:	00005517          	auipc	a0,0x5
    800038d8:	c9450513          	add	a0,a0,-876 # 80008568 <etext+0x568>
    800038dc:	ffffd097          	auipc	ra,0xffffd
    800038e0:	c60080e7          	jalr	-928(ra) # 8000053c <panic>

00000000800038e4 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800038e4:	1101                	add	sp,sp,-32
    800038e6:	ec06                	sd	ra,24(sp)
    800038e8:	e822                	sd	s0,16(sp)
    800038ea:	e426                	sd	s1,8(sp)
    800038ec:	e04a                	sd	s2,0(sp)
    800038ee:	1000                	add	s0,sp,32
    800038f0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800038f2:	01050913          	add	s2,a0,16
    800038f6:	854a                	mv	a0,s2
    800038f8:	00001097          	auipc	ra,0x1
    800038fc:	3fc080e7          	jalr	1020(ra) # 80004cf4 <holdingsleep>
    80003900:	c925                	beqz	a0,80003970 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80003902:	854a                	mv	a0,s2
    80003904:	00001097          	auipc	ra,0x1
    80003908:	3ac080e7          	jalr	940(ra) # 80004cb0 <releasesleep>

  acquire(&bcache.lock);
    8000390c:	00235517          	auipc	a0,0x235
    80003910:	e0450513          	add	a0,a0,-508 # 80238710 <bcache>
    80003914:	ffffd097          	auipc	ra,0xffffd
    80003918:	3bc080e7          	jalr	956(ra) # 80000cd0 <acquire>
  b->refcnt--;
    8000391c:	40bc                	lw	a5,64(s1)
    8000391e:	37fd                	addw	a5,a5,-1
    80003920:	0007871b          	sext.w	a4,a5
    80003924:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003926:	e71d                	bnez	a4,80003954 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003928:	68b8                	ld	a4,80(s1)
    8000392a:	64bc                	ld	a5,72(s1)
    8000392c:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000392e:	68b8                	ld	a4,80(s1)
    80003930:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003932:	0023d797          	auipc	a5,0x23d
    80003936:	dde78793          	add	a5,a5,-546 # 80240710 <bcache+0x8000>
    8000393a:	2b87b703          	ld	a4,696(a5)
    8000393e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003940:	0023d717          	auipc	a4,0x23d
    80003944:	03870713          	add	a4,a4,56 # 80240978 <bcache+0x8268>
    80003948:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000394a:	2b87b703          	ld	a4,696(a5)
    8000394e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003950:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003954:	00235517          	auipc	a0,0x235
    80003958:	dbc50513          	add	a0,a0,-580 # 80238710 <bcache>
    8000395c:	ffffd097          	auipc	ra,0xffffd
    80003960:	428080e7          	jalr	1064(ra) # 80000d84 <release>
}
    80003964:	60e2                	ld	ra,24(sp)
    80003966:	6442                	ld	s0,16(sp)
    80003968:	64a2                	ld	s1,8(sp)
    8000396a:	6902                	ld	s2,0(sp)
    8000396c:	6105                	add	sp,sp,32
    8000396e:	8082                	ret
    panic("brelse");
    80003970:	00005517          	auipc	a0,0x5
    80003974:	c0050513          	add	a0,a0,-1024 # 80008570 <etext+0x570>
    80003978:	ffffd097          	auipc	ra,0xffffd
    8000397c:	bc4080e7          	jalr	-1084(ra) # 8000053c <panic>

0000000080003980 <bpin>:

void
bpin(struct buf *b) {
    80003980:	1101                	add	sp,sp,-32
    80003982:	ec06                	sd	ra,24(sp)
    80003984:	e822                	sd	s0,16(sp)
    80003986:	e426                	sd	s1,8(sp)
    80003988:	1000                	add	s0,sp,32
    8000398a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000398c:	00235517          	auipc	a0,0x235
    80003990:	d8450513          	add	a0,a0,-636 # 80238710 <bcache>
    80003994:	ffffd097          	auipc	ra,0xffffd
    80003998:	33c080e7          	jalr	828(ra) # 80000cd0 <acquire>
  b->refcnt++;
    8000399c:	40bc                	lw	a5,64(s1)
    8000399e:	2785                	addw	a5,a5,1
    800039a0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800039a2:	00235517          	auipc	a0,0x235
    800039a6:	d6e50513          	add	a0,a0,-658 # 80238710 <bcache>
    800039aa:	ffffd097          	auipc	ra,0xffffd
    800039ae:	3da080e7          	jalr	986(ra) # 80000d84 <release>
}
    800039b2:	60e2                	ld	ra,24(sp)
    800039b4:	6442                	ld	s0,16(sp)
    800039b6:	64a2                	ld	s1,8(sp)
    800039b8:	6105                	add	sp,sp,32
    800039ba:	8082                	ret

00000000800039bc <bunpin>:

void
bunpin(struct buf *b) {
    800039bc:	1101                	add	sp,sp,-32
    800039be:	ec06                	sd	ra,24(sp)
    800039c0:	e822                	sd	s0,16(sp)
    800039c2:	e426                	sd	s1,8(sp)
    800039c4:	1000                	add	s0,sp,32
    800039c6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800039c8:	00235517          	auipc	a0,0x235
    800039cc:	d4850513          	add	a0,a0,-696 # 80238710 <bcache>
    800039d0:	ffffd097          	auipc	ra,0xffffd
    800039d4:	300080e7          	jalr	768(ra) # 80000cd0 <acquire>
  b->refcnt--;
    800039d8:	40bc                	lw	a5,64(s1)
    800039da:	37fd                	addw	a5,a5,-1
    800039dc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800039de:	00235517          	auipc	a0,0x235
    800039e2:	d3250513          	add	a0,a0,-718 # 80238710 <bcache>
    800039e6:	ffffd097          	auipc	ra,0xffffd
    800039ea:	39e080e7          	jalr	926(ra) # 80000d84 <release>
}
    800039ee:	60e2                	ld	ra,24(sp)
    800039f0:	6442                	ld	s0,16(sp)
    800039f2:	64a2                	ld	s1,8(sp)
    800039f4:	6105                	add	sp,sp,32
    800039f6:	8082                	ret

00000000800039f8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800039f8:	1101                	add	sp,sp,-32
    800039fa:	ec06                	sd	ra,24(sp)
    800039fc:	e822                	sd	s0,16(sp)
    800039fe:	e426                	sd	s1,8(sp)
    80003a00:	e04a                	sd	s2,0(sp)
    80003a02:	1000                	add	s0,sp,32
    80003a04:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003a06:	00d5d59b          	srlw	a1,a1,0xd
    80003a0a:	0023d797          	auipc	a5,0x23d
    80003a0e:	3e27a783          	lw	a5,994(a5) # 80240dec <sb+0x1c>
    80003a12:	9dbd                	addw	a1,a1,a5
    80003a14:	00000097          	auipc	ra,0x0
    80003a18:	da0080e7          	jalr	-608(ra) # 800037b4 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003a1c:	0074f713          	and	a4,s1,7
    80003a20:	4785                	li	a5,1
    80003a22:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003a26:	14ce                	sll	s1,s1,0x33
    80003a28:	90d9                	srl	s1,s1,0x36
    80003a2a:	00950733          	add	a4,a0,s1
    80003a2e:	05874703          	lbu	a4,88(a4)
    80003a32:	00e7f6b3          	and	a3,a5,a4
    80003a36:	c69d                	beqz	a3,80003a64 <bfree+0x6c>
    80003a38:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003a3a:	94aa                	add	s1,s1,a0
    80003a3c:	fff7c793          	not	a5,a5
    80003a40:	8f7d                	and	a4,a4,a5
    80003a42:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003a46:	00001097          	auipc	ra,0x1
    80003a4a:	0f6080e7          	jalr	246(ra) # 80004b3c <log_write>
  brelse(bp);
    80003a4e:	854a                	mv	a0,s2
    80003a50:	00000097          	auipc	ra,0x0
    80003a54:	e94080e7          	jalr	-364(ra) # 800038e4 <brelse>
}
    80003a58:	60e2                	ld	ra,24(sp)
    80003a5a:	6442                	ld	s0,16(sp)
    80003a5c:	64a2                	ld	s1,8(sp)
    80003a5e:	6902                	ld	s2,0(sp)
    80003a60:	6105                	add	sp,sp,32
    80003a62:	8082                	ret
    panic("freeing free block");
    80003a64:	00005517          	auipc	a0,0x5
    80003a68:	b1450513          	add	a0,a0,-1260 # 80008578 <etext+0x578>
    80003a6c:	ffffd097          	auipc	ra,0xffffd
    80003a70:	ad0080e7          	jalr	-1328(ra) # 8000053c <panic>

0000000080003a74 <balloc>:
{
    80003a74:	711d                	add	sp,sp,-96
    80003a76:	ec86                	sd	ra,88(sp)
    80003a78:	e8a2                	sd	s0,80(sp)
    80003a7a:	e4a6                	sd	s1,72(sp)
    80003a7c:	e0ca                	sd	s2,64(sp)
    80003a7e:	fc4e                	sd	s3,56(sp)
    80003a80:	f852                	sd	s4,48(sp)
    80003a82:	f456                	sd	s5,40(sp)
    80003a84:	f05a                	sd	s6,32(sp)
    80003a86:	ec5e                	sd	s7,24(sp)
    80003a88:	e862                	sd	s8,16(sp)
    80003a8a:	e466                	sd	s9,8(sp)
    80003a8c:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003a8e:	0023d797          	auipc	a5,0x23d
    80003a92:	3467a783          	lw	a5,838(a5) # 80240dd4 <sb+0x4>
    80003a96:	cff5                	beqz	a5,80003b92 <balloc+0x11e>
    80003a98:	8baa                	mv	s7,a0
    80003a9a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003a9c:	0023db17          	auipc	s6,0x23d
    80003aa0:	334b0b13          	add	s6,s6,820 # 80240dd0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003aa4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003aa6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003aa8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003aaa:	6c89                	lui	s9,0x2
    80003aac:	a061                	j	80003b34 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003aae:	97ca                	add	a5,a5,s2
    80003ab0:	8e55                	or	a2,a2,a3
    80003ab2:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003ab6:	854a                	mv	a0,s2
    80003ab8:	00001097          	auipc	ra,0x1
    80003abc:	084080e7          	jalr	132(ra) # 80004b3c <log_write>
        brelse(bp);
    80003ac0:	854a                	mv	a0,s2
    80003ac2:	00000097          	auipc	ra,0x0
    80003ac6:	e22080e7          	jalr	-478(ra) # 800038e4 <brelse>
  bp = bread(dev, bno);
    80003aca:	85a6                	mv	a1,s1
    80003acc:	855e                	mv	a0,s7
    80003ace:	00000097          	auipc	ra,0x0
    80003ad2:	ce6080e7          	jalr	-794(ra) # 800037b4 <bread>
    80003ad6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003ad8:	40000613          	li	a2,1024
    80003adc:	4581                	li	a1,0
    80003ade:	05850513          	add	a0,a0,88
    80003ae2:	ffffd097          	auipc	ra,0xffffd
    80003ae6:	2ea080e7          	jalr	746(ra) # 80000dcc <memset>
  log_write(bp);
    80003aea:	854a                	mv	a0,s2
    80003aec:	00001097          	auipc	ra,0x1
    80003af0:	050080e7          	jalr	80(ra) # 80004b3c <log_write>
  brelse(bp);
    80003af4:	854a                	mv	a0,s2
    80003af6:	00000097          	auipc	ra,0x0
    80003afa:	dee080e7          	jalr	-530(ra) # 800038e4 <brelse>
}
    80003afe:	8526                	mv	a0,s1
    80003b00:	60e6                	ld	ra,88(sp)
    80003b02:	6446                	ld	s0,80(sp)
    80003b04:	64a6                	ld	s1,72(sp)
    80003b06:	6906                	ld	s2,64(sp)
    80003b08:	79e2                	ld	s3,56(sp)
    80003b0a:	7a42                	ld	s4,48(sp)
    80003b0c:	7aa2                	ld	s5,40(sp)
    80003b0e:	7b02                	ld	s6,32(sp)
    80003b10:	6be2                	ld	s7,24(sp)
    80003b12:	6c42                	ld	s8,16(sp)
    80003b14:	6ca2                	ld	s9,8(sp)
    80003b16:	6125                	add	sp,sp,96
    80003b18:	8082                	ret
    brelse(bp);
    80003b1a:	854a                	mv	a0,s2
    80003b1c:	00000097          	auipc	ra,0x0
    80003b20:	dc8080e7          	jalr	-568(ra) # 800038e4 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003b24:	015c87bb          	addw	a5,s9,s5
    80003b28:	00078a9b          	sext.w	s5,a5
    80003b2c:	004b2703          	lw	a4,4(s6)
    80003b30:	06eaf163          	bgeu	s5,a4,80003b92 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80003b34:	41fad79b          	sraw	a5,s5,0x1f
    80003b38:	0137d79b          	srlw	a5,a5,0x13
    80003b3c:	015787bb          	addw	a5,a5,s5
    80003b40:	40d7d79b          	sraw	a5,a5,0xd
    80003b44:	01cb2583          	lw	a1,28(s6)
    80003b48:	9dbd                	addw	a1,a1,a5
    80003b4a:	855e                	mv	a0,s7
    80003b4c:	00000097          	auipc	ra,0x0
    80003b50:	c68080e7          	jalr	-920(ra) # 800037b4 <bread>
    80003b54:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003b56:	004b2503          	lw	a0,4(s6)
    80003b5a:	000a849b          	sext.w	s1,s5
    80003b5e:	8762                	mv	a4,s8
    80003b60:	faa4fde3          	bgeu	s1,a0,80003b1a <balloc+0xa6>
      m = 1 << (bi % 8);
    80003b64:	00777693          	and	a3,a4,7
    80003b68:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003b6c:	41f7579b          	sraw	a5,a4,0x1f
    80003b70:	01d7d79b          	srlw	a5,a5,0x1d
    80003b74:	9fb9                	addw	a5,a5,a4
    80003b76:	4037d79b          	sraw	a5,a5,0x3
    80003b7a:	00f90633          	add	a2,s2,a5
    80003b7e:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80003b82:	00c6f5b3          	and	a1,a3,a2
    80003b86:	d585                	beqz	a1,80003aae <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003b88:	2705                	addw	a4,a4,1
    80003b8a:	2485                	addw	s1,s1,1
    80003b8c:	fd471ae3          	bne	a4,s4,80003b60 <balloc+0xec>
    80003b90:	b769                	j	80003b1a <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80003b92:	00005517          	auipc	a0,0x5
    80003b96:	9fe50513          	add	a0,a0,-1538 # 80008590 <etext+0x590>
    80003b9a:	ffffd097          	auipc	ra,0xffffd
    80003b9e:	9ec080e7          	jalr	-1556(ra) # 80000586 <printf>
  return 0;
    80003ba2:	4481                	li	s1,0
    80003ba4:	bfa9                	j	80003afe <balloc+0x8a>

0000000080003ba6 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003ba6:	7179                	add	sp,sp,-48
    80003ba8:	f406                	sd	ra,40(sp)
    80003baa:	f022                	sd	s0,32(sp)
    80003bac:	ec26                	sd	s1,24(sp)
    80003bae:	e84a                	sd	s2,16(sp)
    80003bb0:	e44e                	sd	s3,8(sp)
    80003bb2:	e052                	sd	s4,0(sp)
    80003bb4:	1800                	add	s0,sp,48
    80003bb6:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003bb8:	47ad                	li	a5,11
    80003bba:	02b7e863          	bltu	a5,a1,80003bea <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80003bbe:	02059793          	sll	a5,a1,0x20
    80003bc2:	01e7d593          	srl	a1,a5,0x1e
    80003bc6:	00b504b3          	add	s1,a0,a1
    80003bca:	0504a903          	lw	s2,80(s1)
    80003bce:	06091e63          	bnez	s2,80003c4a <bmap+0xa4>
      addr = balloc(ip->dev);
    80003bd2:	4108                	lw	a0,0(a0)
    80003bd4:	00000097          	auipc	ra,0x0
    80003bd8:	ea0080e7          	jalr	-352(ra) # 80003a74 <balloc>
    80003bdc:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003be0:	06090563          	beqz	s2,80003c4a <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80003be4:	0524a823          	sw	s2,80(s1)
    80003be8:	a08d                	j	80003c4a <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003bea:	ff45849b          	addw	s1,a1,-12
    80003bee:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003bf2:	0ff00793          	li	a5,255
    80003bf6:	08e7e563          	bltu	a5,a4,80003c80 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003bfa:	08052903          	lw	s2,128(a0)
    80003bfe:	00091d63          	bnez	s2,80003c18 <bmap+0x72>
      addr = balloc(ip->dev);
    80003c02:	4108                	lw	a0,0(a0)
    80003c04:	00000097          	auipc	ra,0x0
    80003c08:	e70080e7          	jalr	-400(ra) # 80003a74 <balloc>
    80003c0c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003c10:	02090d63          	beqz	s2,80003c4a <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003c14:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003c18:	85ca                	mv	a1,s2
    80003c1a:	0009a503          	lw	a0,0(s3)
    80003c1e:	00000097          	auipc	ra,0x0
    80003c22:	b96080e7          	jalr	-1130(ra) # 800037b4 <bread>
    80003c26:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003c28:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80003c2c:	02049713          	sll	a4,s1,0x20
    80003c30:	01e75593          	srl	a1,a4,0x1e
    80003c34:	00b784b3          	add	s1,a5,a1
    80003c38:	0004a903          	lw	s2,0(s1)
    80003c3c:	02090063          	beqz	s2,80003c5c <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003c40:	8552                	mv	a0,s4
    80003c42:	00000097          	auipc	ra,0x0
    80003c46:	ca2080e7          	jalr	-862(ra) # 800038e4 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003c4a:	854a                	mv	a0,s2
    80003c4c:	70a2                	ld	ra,40(sp)
    80003c4e:	7402                	ld	s0,32(sp)
    80003c50:	64e2                	ld	s1,24(sp)
    80003c52:	6942                	ld	s2,16(sp)
    80003c54:	69a2                	ld	s3,8(sp)
    80003c56:	6a02                	ld	s4,0(sp)
    80003c58:	6145                	add	sp,sp,48
    80003c5a:	8082                	ret
      addr = balloc(ip->dev);
    80003c5c:	0009a503          	lw	a0,0(s3)
    80003c60:	00000097          	auipc	ra,0x0
    80003c64:	e14080e7          	jalr	-492(ra) # 80003a74 <balloc>
    80003c68:	0005091b          	sext.w	s2,a0
      if(addr){
    80003c6c:	fc090ae3          	beqz	s2,80003c40 <bmap+0x9a>
        a[bn] = addr;
    80003c70:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003c74:	8552                	mv	a0,s4
    80003c76:	00001097          	auipc	ra,0x1
    80003c7a:	ec6080e7          	jalr	-314(ra) # 80004b3c <log_write>
    80003c7e:	b7c9                	j	80003c40 <bmap+0x9a>
  panic("bmap: out of range");
    80003c80:	00005517          	auipc	a0,0x5
    80003c84:	92850513          	add	a0,a0,-1752 # 800085a8 <etext+0x5a8>
    80003c88:	ffffd097          	auipc	ra,0xffffd
    80003c8c:	8b4080e7          	jalr	-1868(ra) # 8000053c <panic>

0000000080003c90 <iget>:
{
    80003c90:	7179                	add	sp,sp,-48
    80003c92:	f406                	sd	ra,40(sp)
    80003c94:	f022                	sd	s0,32(sp)
    80003c96:	ec26                	sd	s1,24(sp)
    80003c98:	e84a                	sd	s2,16(sp)
    80003c9a:	e44e                	sd	s3,8(sp)
    80003c9c:	e052                	sd	s4,0(sp)
    80003c9e:	1800                	add	s0,sp,48
    80003ca0:	89aa                	mv	s3,a0
    80003ca2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003ca4:	0023d517          	auipc	a0,0x23d
    80003ca8:	14c50513          	add	a0,a0,332 # 80240df0 <itable>
    80003cac:	ffffd097          	auipc	ra,0xffffd
    80003cb0:	024080e7          	jalr	36(ra) # 80000cd0 <acquire>
  empty = 0;
    80003cb4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003cb6:	0023d497          	auipc	s1,0x23d
    80003cba:	15248493          	add	s1,s1,338 # 80240e08 <itable+0x18>
    80003cbe:	0023f697          	auipc	a3,0x23f
    80003cc2:	bda68693          	add	a3,a3,-1062 # 80242898 <log>
    80003cc6:	a039                	j	80003cd4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003cc8:	02090b63          	beqz	s2,80003cfe <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003ccc:	08848493          	add	s1,s1,136
    80003cd0:	02d48a63          	beq	s1,a3,80003d04 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003cd4:	449c                	lw	a5,8(s1)
    80003cd6:	fef059e3          	blez	a5,80003cc8 <iget+0x38>
    80003cda:	4098                	lw	a4,0(s1)
    80003cdc:	ff3716e3          	bne	a4,s3,80003cc8 <iget+0x38>
    80003ce0:	40d8                	lw	a4,4(s1)
    80003ce2:	ff4713e3          	bne	a4,s4,80003cc8 <iget+0x38>
      ip->ref++;
    80003ce6:	2785                	addw	a5,a5,1
    80003ce8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003cea:	0023d517          	auipc	a0,0x23d
    80003cee:	10650513          	add	a0,a0,262 # 80240df0 <itable>
    80003cf2:	ffffd097          	auipc	ra,0xffffd
    80003cf6:	092080e7          	jalr	146(ra) # 80000d84 <release>
      return ip;
    80003cfa:	8926                	mv	s2,s1
    80003cfc:	a03d                	j	80003d2a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003cfe:	f7f9                	bnez	a5,80003ccc <iget+0x3c>
    80003d00:	8926                	mv	s2,s1
    80003d02:	b7e9                	j	80003ccc <iget+0x3c>
  if(empty == 0)
    80003d04:	02090c63          	beqz	s2,80003d3c <iget+0xac>
  ip->dev = dev;
    80003d08:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003d0c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003d10:	4785                	li	a5,1
    80003d12:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003d16:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003d1a:	0023d517          	auipc	a0,0x23d
    80003d1e:	0d650513          	add	a0,a0,214 # 80240df0 <itable>
    80003d22:	ffffd097          	auipc	ra,0xffffd
    80003d26:	062080e7          	jalr	98(ra) # 80000d84 <release>
}
    80003d2a:	854a                	mv	a0,s2
    80003d2c:	70a2                	ld	ra,40(sp)
    80003d2e:	7402                	ld	s0,32(sp)
    80003d30:	64e2                	ld	s1,24(sp)
    80003d32:	6942                	ld	s2,16(sp)
    80003d34:	69a2                	ld	s3,8(sp)
    80003d36:	6a02                	ld	s4,0(sp)
    80003d38:	6145                	add	sp,sp,48
    80003d3a:	8082                	ret
    panic("iget: no inodes");
    80003d3c:	00005517          	auipc	a0,0x5
    80003d40:	88450513          	add	a0,a0,-1916 # 800085c0 <etext+0x5c0>
    80003d44:	ffffc097          	auipc	ra,0xffffc
    80003d48:	7f8080e7          	jalr	2040(ra) # 8000053c <panic>

0000000080003d4c <fsinit>:
fsinit(int dev) {
    80003d4c:	7179                	add	sp,sp,-48
    80003d4e:	f406                	sd	ra,40(sp)
    80003d50:	f022                	sd	s0,32(sp)
    80003d52:	ec26                	sd	s1,24(sp)
    80003d54:	e84a                	sd	s2,16(sp)
    80003d56:	e44e                	sd	s3,8(sp)
    80003d58:	1800                	add	s0,sp,48
    80003d5a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003d5c:	4585                	li	a1,1
    80003d5e:	00000097          	auipc	ra,0x0
    80003d62:	a56080e7          	jalr	-1450(ra) # 800037b4 <bread>
    80003d66:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003d68:	0023d997          	auipc	s3,0x23d
    80003d6c:	06898993          	add	s3,s3,104 # 80240dd0 <sb>
    80003d70:	02000613          	li	a2,32
    80003d74:	05850593          	add	a1,a0,88
    80003d78:	854e                	mv	a0,s3
    80003d7a:	ffffd097          	auipc	ra,0xffffd
    80003d7e:	0ae080e7          	jalr	174(ra) # 80000e28 <memmove>
  brelse(bp);
    80003d82:	8526                	mv	a0,s1
    80003d84:	00000097          	auipc	ra,0x0
    80003d88:	b60080e7          	jalr	-1184(ra) # 800038e4 <brelse>
  if(sb.magic != FSMAGIC)
    80003d8c:	0009a703          	lw	a4,0(s3)
    80003d90:	102037b7          	lui	a5,0x10203
    80003d94:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003d98:	02f71263          	bne	a4,a5,80003dbc <fsinit+0x70>
  initlog(dev, &sb);
    80003d9c:	0023d597          	auipc	a1,0x23d
    80003da0:	03458593          	add	a1,a1,52 # 80240dd0 <sb>
    80003da4:	854a                	mv	a0,s2
    80003da6:	00001097          	auipc	ra,0x1
    80003daa:	b2c080e7          	jalr	-1236(ra) # 800048d2 <initlog>
}
    80003dae:	70a2                	ld	ra,40(sp)
    80003db0:	7402                	ld	s0,32(sp)
    80003db2:	64e2                	ld	s1,24(sp)
    80003db4:	6942                	ld	s2,16(sp)
    80003db6:	69a2                	ld	s3,8(sp)
    80003db8:	6145                	add	sp,sp,48
    80003dba:	8082                	ret
    panic("invalid file system");
    80003dbc:	00005517          	auipc	a0,0x5
    80003dc0:	81450513          	add	a0,a0,-2028 # 800085d0 <etext+0x5d0>
    80003dc4:	ffffc097          	auipc	ra,0xffffc
    80003dc8:	778080e7          	jalr	1912(ra) # 8000053c <panic>

0000000080003dcc <iinit>:
{
    80003dcc:	7179                	add	sp,sp,-48
    80003dce:	f406                	sd	ra,40(sp)
    80003dd0:	f022                	sd	s0,32(sp)
    80003dd2:	ec26                	sd	s1,24(sp)
    80003dd4:	e84a                	sd	s2,16(sp)
    80003dd6:	e44e                	sd	s3,8(sp)
    80003dd8:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    80003dda:	00005597          	auipc	a1,0x5
    80003dde:	80e58593          	add	a1,a1,-2034 # 800085e8 <etext+0x5e8>
    80003de2:	0023d517          	auipc	a0,0x23d
    80003de6:	00e50513          	add	a0,a0,14 # 80240df0 <itable>
    80003dea:	ffffd097          	auipc	ra,0xffffd
    80003dee:	e56080e7          	jalr	-426(ra) # 80000c40 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003df2:	0023d497          	auipc	s1,0x23d
    80003df6:	02648493          	add	s1,s1,38 # 80240e18 <itable+0x28>
    80003dfa:	0023f997          	auipc	s3,0x23f
    80003dfe:	aae98993          	add	s3,s3,-1362 # 802428a8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003e02:	00004917          	auipc	s2,0x4
    80003e06:	7ee90913          	add	s2,s2,2030 # 800085f0 <etext+0x5f0>
    80003e0a:	85ca                	mv	a1,s2
    80003e0c:	8526                	mv	a0,s1
    80003e0e:	00001097          	auipc	ra,0x1
    80003e12:	e12080e7          	jalr	-494(ra) # 80004c20 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003e16:	08848493          	add	s1,s1,136
    80003e1a:	ff3498e3          	bne	s1,s3,80003e0a <iinit+0x3e>
}
    80003e1e:	70a2                	ld	ra,40(sp)
    80003e20:	7402                	ld	s0,32(sp)
    80003e22:	64e2                	ld	s1,24(sp)
    80003e24:	6942                	ld	s2,16(sp)
    80003e26:	69a2                	ld	s3,8(sp)
    80003e28:	6145                	add	sp,sp,48
    80003e2a:	8082                	ret

0000000080003e2c <ialloc>:
{
    80003e2c:	7139                	add	sp,sp,-64
    80003e2e:	fc06                	sd	ra,56(sp)
    80003e30:	f822                	sd	s0,48(sp)
    80003e32:	f426                	sd	s1,40(sp)
    80003e34:	f04a                	sd	s2,32(sp)
    80003e36:	ec4e                	sd	s3,24(sp)
    80003e38:	e852                	sd	s4,16(sp)
    80003e3a:	e456                	sd	s5,8(sp)
    80003e3c:	e05a                	sd	s6,0(sp)
    80003e3e:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003e40:	0023d717          	auipc	a4,0x23d
    80003e44:	f9c72703          	lw	a4,-100(a4) # 80240ddc <sb+0xc>
    80003e48:	4785                	li	a5,1
    80003e4a:	04e7f863          	bgeu	a5,a4,80003e9a <ialloc+0x6e>
    80003e4e:	8aaa                	mv	s5,a0
    80003e50:	8b2e                	mv	s6,a1
    80003e52:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003e54:	0023da17          	auipc	s4,0x23d
    80003e58:	f7ca0a13          	add	s4,s4,-132 # 80240dd0 <sb>
    80003e5c:	00495593          	srl	a1,s2,0x4
    80003e60:	018a2783          	lw	a5,24(s4)
    80003e64:	9dbd                	addw	a1,a1,a5
    80003e66:	8556                	mv	a0,s5
    80003e68:	00000097          	auipc	ra,0x0
    80003e6c:	94c080e7          	jalr	-1716(ra) # 800037b4 <bread>
    80003e70:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003e72:	05850993          	add	s3,a0,88
    80003e76:	00f97793          	and	a5,s2,15
    80003e7a:	079a                	sll	a5,a5,0x6
    80003e7c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003e7e:	00099783          	lh	a5,0(s3)
    80003e82:	cf9d                	beqz	a5,80003ec0 <ialloc+0x94>
    brelse(bp);
    80003e84:	00000097          	auipc	ra,0x0
    80003e88:	a60080e7          	jalr	-1440(ra) # 800038e4 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003e8c:	0905                	add	s2,s2,1
    80003e8e:	00ca2703          	lw	a4,12(s4)
    80003e92:	0009079b          	sext.w	a5,s2
    80003e96:	fce7e3e3          	bltu	a5,a4,80003e5c <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80003e9a:	00004517          	auipc	a0,0x4
    80003e9e:	75e50513          	add	a0,a0,1886 # 800085f8 <etext+0x5f8>
    80003ea2:	ffffc097          	auipc	ra,0xffffc
    80003ea6:	6e4080e7          	jalr	1764(ra) # 80000586 <printf>
  return 0;
    80003eaa:	4501                	li	a0,0
}
    80003eac:	70e2                	ld	ra,56(sp)
    80003eae:	7442                	ld	s0,48(sp)
    80003eb0:	74a2                	ld	s1,40(sp)
    80003eb2:	7902                	ld	s2,32(sp)
    80003eb4:	69e2                	ld	s3,24(sp)
    80003eb6:	6a42                	ld	s4,16(sp)
    80003eb8:	6aa2                	ld	s5,8(sp)
    80003eba:	6b02                	ld	s6,0(sp)
    80003ebc:	6121                	add	sp,sp,64
    80003ebe:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003ec0:	04000613          	li	a2,64
    80003ec4:	4581                	li	a1,0
    80003ec6:	854e                	mv	a0,s3
    80003ec8:	ffffd097          	auipc	ra,0xffffd
    80003ecc:	f04080e7          	jalr	-252(ra) # 80000dcc <memset>
      dip->type = type;
    80003ed0:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003ed4:	8526                	mv	a0,s1
    80003ed6:	00001097          	auipc	ra,0x1
    80003eda:	c66080e7          	jalr	-922(ra) # 80004b3c <log_write>
      brelse(bp);
    80003ede:	8526                	mv	a0,s1
    80003ee0:	00000097          	auipc	ra,0x0
    80003ee4:	a04080e7          	jalr	-1532(ra) # 800038e4 <brelse>
      return iget(dev, inum);
    80003ee8:	0009059b          	sext.w	a1,s2
    80003eec:	8556                	mv	a0,s5
    80003eee:	00000097          	auipc	ra,0x0
    80003ef2:	da2080e7          	jalr	-606(ra) # 80003c90 <iget>
    80003ef6:	bf5d                	j	80003eac <ialloc+0x80>

0000000080003ef8 <iupdate>:
{
    80003ef8:	1101                	add	sp,sp,-32
    80003efa:	ec06                	sd	ra,24(sp)
    80003efc:	e822                	sd	s0,16(sp)
    80003efe:	e426                	sd	s1,8(sp)
    80003f00:	e04a                	sd	s2,0(sp)
    80003f02:	1000                	add	s0,sp,32
    80003f04:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003f06:	415c                	lw	a5,4(a0)
    80003f08:	0047d79b          	srlw	a5,a5,0x4
    80003f0c:	0023d597          	auipc	a1,0x23d
    80003f10:	edc5a583          	lw	a1,-292(a1) # 80240de8 <sb+0x18>
    80003f14:	9dbd                	addw	a1,a1,a5
    80003f16:	4108                	lw	a0,0(a0)
    80003f18:	00000097          	auipc	ra,0x0
    80003f1c:	89c080e7          	jalr	-1892(ra) # 800037b4 <bread>
    80003f20:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003f22:	05850793          	add	a5,a0,88
    80003f26:	40d8                	lw	a4,4(s1)
    80003f28:	8b3d                	and	a4,a4,15
    80003f2a:	071a                	sll	a4,a4,0x6
    80003f2c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003f2e:	04449703          	lh	a4,68(s1)
    80003f32:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003f36:	04649703          	lh	a4,70(s1)
    80003f3a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003f3e:	04849703          	lh	a4,72(s1)
    80003f42:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003f46:	04a49703          	lh	a4,74(s1)
    80003f4a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003f4e:	44f8                	lw	a4,76(s1)
    80003f50:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003f52:	03400613          	li	a2,52
    80003f56:	05048593          	add	a1,s1,80
    80003f5a:	00c78513          	add	a0,a5,12
    80003f5e:	ffffd097          	auipc	ra,0xffffd
    80003f62:	eca080e7          	jalr	-310(ra) # 80000e28 <memmove>
  log_write(bp);
    80003f66:	854a                	mv	a0,s2
    80003f68:	00001097          	auipc	ra,0x1
    80003f6c:	bd4080e7          	jalr	-1068(ra) # 80004b3c <log_write>
  brelse(bp);
    80003f70:	854a                	mv	a0,s2
    80003f72:	00000097          	auipc	ra,0x0
    80003f76:	972080e7          	jalr	-1678(ra) # 800038e4 <brelse>
}
    80003f7a:	60e2                	ld	ra,24(sp)
    80003f7c:	6442                	ld	s0,16(sp)
    80003f7e:	64a2                	ld	s1,8(sp)
    80003f80:	6902                	ld	s2,0(sp)
    80003f82:	6105                	add	sp,sp,32
    80003f84:	8082                	ret

0000000080003f86 <idup>:
{
    80003f86:	1101                	add	sp,sp,-32
    80003f88:	ec06                	sd	ra,24(sp)
    80003f8a:	e822                	sd	s0,16(sp)
    80003f8c:	e426                	sd	s1,8(sp)
    80003f8e:	1000                	add	s0,sp,32
    80003f90:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003f92:	0023d517          	auipc	a0,0x23d
    80003f96:	e5e50513          	add	a0,a0,-418 # 80240df0 <itable>
    80003f9a:	ffffd097          	auipc	ra,0xffffd
    80003f9e:	d36080e7          	jalr	-714(ra) # 80000cd0 <acquire>
  ip->ref++;
    80003fa2:	449c                	lw	a5,8(s1)
    80003fa4:	2785                	addw	a5,a5,1
    80003fa6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003fa8:	0023d517          	auipc	a0,0x23d
    80003fac:	e4850513          	add	a0,a0,-440 # 80240df0 <itable>
    80003fb0:	ffffd097          	auipc	ra,0xffffd
    80003fb4:	dd4080e7          	jalr	-556(ra) # 80000d84 <release>
}
    80003fb8:	8526                	mv	a0,s1
    80003fba:	60e2                	ld	ra,24(sp)
    80003fbc:	6442                	ld	s0,16(sp)
    80003fbe:	64a2                	ld	s1,8(sp)
    80003fc0:	6105                	add	sp,sp,32
    80003fc2:	8082                	ret

0000000080003fc4 <ilock>:
{
    80003fc4:	1101                	add	sp,sp,-32
    80003fc6:	ec06                	sd	ra,24(sp)
    80003fc8:	e822                	sd	s0,16(sp)
    80003fca:	e426                	sd	s1,8(sp)
    80003fcc:	e04a                	sd	s2,0(sp)
    80003fce:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003fd0:	c115                	beqz	a0,80003ff4 <ilock+0x30>
    80003fd2:	84aa                	mv	s1,a0
    80003fd4:	451c                	lw	a5,8(a0)
    80003fd6:	00f05f63          	blez	a5,80003ff4 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003fda:	0541                	add	a0,a0,16
    80003fdc:	00001097          	auipc	ra,0x1
    80003fe0:	c7e080e7          	jalr	-898(ra) # 80004c5a <acquiresleep>
  if(ip->valid == 0){
    80003fe4:	40bc                	lw	a5,64(s1)
    80003fe6:	cf99                	beqz	a5,80004004 <ilock+0x40>
}
    80003fe8:	60e2                	ld	ra,24(sp)
    80003fea:	6442                	ld	s0,16(sp)
    80003fec:	64a2                	ld	s1,8(sp)
    80003fee:	6902                	ld	s2,0(sp)
    80003ff0:	6105                	add	sp,sp,32
    80003ff2:	8082                	ret
    panic("ilock");
    80003ff4:	00004517          	auipc	a0,0x4
    80003ff8:	61c50513          	add	a0,a0,1564 # 80008610 <etext+0x610>
    80003ffc:	ffffc097          	auipc	ra,0xffffc
    80004000:	540080e7          	jalr	1344(ra) # 8000053c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004004:	40dc                	lw	a5,4(s1)
    80004006:	0047d79b          	srlw	a5,a5,0x4
    8000400a:	0023d597          	auipc	a1,0x23d
    8000400e:	dde5a583          	lw	a1,-546(a1) # 80240de8 <sb+0x18>
    80004012:	9dbd                	addw	a1,a1,a5
    80004014:	4088                	lw	a0,0(s1)
    80004016:	fffff097          	auipc	ra,0xfffff
    8000401a:	79e080e7          	jalr	1950(ra) # 800037b4 <bread>
    8000401e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004020:	05850593          	add	a1,a0,88
    80004024:	40dc                	lw	a5,4(s1)
    80004026:	8bbd                	and	a5,a5,15
    80004028:	079a                	sll	a5,a5,0x6
    8000402a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000402c:	00059783          	lh	a5,0(a1)
    80004030:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80004034:	00259783          	lh	a5,2(a1)
    80004038:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000403c:	00459783          	lh	a5,4(a1)
    80004040:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80004044:	00659783          	lh	a5,6(a1)
    80004048:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000404c:	459c                	lw	a5,8(a1)
    8000404e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80004050:	03400613          	li	a2,52
    80004054:	05b1                	add	a1,a1,12
    80004056:	05048513          	add	a0,s1,80
    8000405a:	ffffd097          	auipc	ra,0xffffd
    8000405e:	dce080e7          	jalr	-562(ra) # 80000e28 <memmove>
    brelse(bp);
    80004062:	854a                	mv	a0,s2
    80004064:	00000097          	auipc	ra,0x0
    80004068:	880080e7          	jalr	-1920(ra) # 800038e4 <brelse>
    ip->valid = 1;
    8000406c:	4785                	li	a5,1
    8000406e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80004070:	04449783          	lh	a5,68(s1)
    80004074:	fbb5                	bnez	a5,80003fe8 <ilock+0x24>
      panic("ilock: no type");
    80004076:	00004517          	auipc	a0,0x4
    8000407a:	5a250513          	add	a0,a0,1442 # 80008618 <etext+0x618>
    8000407e:	ffffc097          	auipc	ra,0xffffc
    80004082:	4be080e7          	jalr	1214(ra) # 8000053c <panic>

0000000080004086 <iunlock>:
{
    80004086:	1101                	add	sp,sp,-32
    80004088:	ec06                	sd	ra,24(sp)
    8000408a:	e822                	sd	s0,16(sp)
    8000408c:	e426                	sd	s1,8(sp)
    8000408e:	e04a                	sd	s2,0(sp)
    80004090:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80004092:	c905                	beqz	a0,800040c2 <iunlock+0x3c>
    80004094:	84aa                	mv	s1,a0
    80004096:	01050913          	add	s2,a0,16
    8000409a:	854a                	mv	a0,s2
    8000409c:	00001097          	auipc	ra,0x1
    800040a0:	c58080e7          	jalr	-936(ra) # 80004cf4 <holdingsleep>
    800040a4:	cd19                	beqz	a0,800040c2 <iunlock+0x3c>
    800040a6:	449c                	lw	a5,8(s1)
    800040a8:	00f05d63          	blez	a5,800040c2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800040ac:	854a                	mv	a0,s2
    800040ae:	00001097          	auipc	ra,0x1
    800040b2:	c02080e7          	jalr	-1022(ra) # 80004cb0 <releasesleep>
}
    800040b6:	60e2                	ld	ra,24(sp)
    800040b8:	6442                	ld	s0,16(sp)
    800040ba:	64a2                	ld	s1,8(sp)
    800040bc:	6902                	ld	s2,0(sp)
    800040be:	6105                	add	sp,sp,32
    800040c0:	8082                	ret
    panic("iunlock");
    800040c2:	00004517          	auipc	a0,0x4
    800040c6:	56650513          	add	a0,a0,1382 # 80008628 <etext+0x628>
    800040ca:	ffffc097          	auipc	ra,0xffffc
    800040ce:	472080e7          	jalr	1138(ra) # 8000053c <panic>

00000000800040d2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800040d2:	7179                	add	sp,sp,-48
    800040d4:	f406                	sd	ra,40(sp)
    800040d6:	f022                	sd	s0,32(sp)
    800040d8:	ec26                	sd	s1,24(sp)
    800040da:	e84a                	sd	s2,16(sp)
    800040dc:	e44e                	sd	s3,8(sp)
    800040de:	e052                	sd	s4,0(sp)
    800040e0:	1800                	add	s0,sp,48
    800040e2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800040e4:	05050493          	add	s1,a0,80
    800040e8:	08050913          	add	s2,a0,128
    800040ec:	a021                	j	800040f4 <itrunc+0x22>
    800040ee:	0491                	add	s1,s1,4
    800040f0:	01248d63          	beq	s1,s2,8000410a <itrunc+0x38>
    if(ip->addrs[i]){
    800040f4:	408c                	lw	a1,0(s1)
    800040f6:	dde5                	beqz	a1,800040ee <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800040f8:	0009a503          	lw	a0,0(s3)
    800040fc:	00000097          	auipc	ra,0x0
    80004100:	8fc080e7          	jalr	-1796(ra) # 800039f8 <bfree>
      ip->addrs[i] = 0;
    80004104:	0004a023          	sw	zero,0(s1)
    80004108:	b7dd                	j	800040ee <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000410a:	0809a583          	lw	a1,128(s3)
    8000410e:	e185                	bnez	a1,8000412e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80004110:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80004114:	854e                	mv	a0,s3
    80004116:	00000097          	auipc	ra,0x0
    8000411a:	de2080e7          	jalr	-542(ra) # 80003ef8 <iupdate>
}
    8000411e:	70a2                	ld	ra,40(sp)
    80004120:	7402                	ld	s0,32(sp)
    80004122:	64e2                	ld	s1,24(sp)
    80004124:	6942                	ld	s2,16(sp)
    80004126:	69a2                	ld	s3,8(sp)
    80004128:	6a02                	ld	s4,0(sp)
    8000412a:	6145                	add	sp,sp,48
    8000412c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000412e:	0009a503          	lw	a0,0(s3)
    80004132:	fffff097          	auipc	ra,0xfffff
    80004136:	682080e7          	jalr	1666(ra) # 800037b4 <bread>
    8000413a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000413c:	05850493          	add	s1,a0,88
    80004140:	45850913          	add	s2,a0,1112
    80004144:	a021                	j	8000414c <itrunc+0x7a>
    80004146:	0491                	add	s1,s1,4
    80004148:	01248b63          	beq	s1,s2,8000415e <itrunc+0x8c>
      if(a[j])
    8000414c:	408c                	lw	a1,0(s1)
    8000414e:	dde5                	beqz	a1,80004146 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80004150:	0009a503          	lw	a0,0(s3)
    80004154:	00000097          	auipc	ra,0x0
    80004158:	8a4080e7          	jalr	-1884(ra) # 800039f8 <bfree>
    8000415c:	b7ed                	j	80004146 <itrunc+0x74>
    brelse(bp);
    8000415e:	8552                	mv	a0,s4
    80004160:	fffff097          	auipc	ra,0xfffff
    80004164:	784080e7          	jalr	1924(ra) # 800038e4 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004168:	0809a583          	lw	a1,128(s3)
    8000416c:	0009a503          	lw	a0,0(s3)
    80004170:	00000097          	auipc	ra,0x0
    80004174:	888080e7          	jalr	-1912(ra) # 800039f8 <bfree>
    ip->addrs[NDIRECT] = 0;
    80004178:	0809a023          	sw	zero,128(s3)
    8000417c:	bf51                	j	80004110 <itrunc+0x3e>

000000008000417e <iput>:
{
    8000417e:	1101                	add	sp,sp,-32
    80004180:	ec06                	sd	ra,24(sp)
    80004182:	e822                	sd	s0,16(sp)
    80004184:	e426                	sd	s1,8(sp)
    80004186:	e04a                	sd	s2,0(sp)
    80004188:	1000                	add	s0,sp,32
    8000418a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000418c:	0023d517          	auipc	a0,0x23d
    80004190:	c6450513          	add	a0,a0,-924 # 80240df0 <itable>
    80004194:	ffffd097          	auipc	ra,0xffffd
    80004198:	b3c080e7          	jalr	-1220(ra) # 80000cd0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000419c:	4498                	lw	a4,8(s1)
    8000419e:	4785                	li	a5,1
    800041a0:	02f70363          	beq	a4,a5,800041c6 <iput+0x48>
  ip->ref--;
    800041a4:	449c                	lw	a5,8(s1)
    800041a6:	37fd                	addw	a5,a5,-1
    800041a8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800041aa:	0023d517          	auipc	a0,0x23d
    800041ae:	c4650513          	add	a0,a0,-954 # 80240df0 <itable>
    800041b2:	ffffd097          	auipc	ra,0xffffd
    800041b6:	bd2080e7          	jalr	-1070(ra) # 80000d84 <release>
}
    800041ba:	60e2                	ld	ra,24(sp)
    800041bc:	6442                	ld	s0,16(sp)
    800041be:	64a2                	ld	s1,8(sp)
    800041c0:	6902                	ld	s2,0(sp)
    800041c2:	6105                	add	sp,sp,32
    800041c4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800041c6:	40bc                	lw	a5,64(s1)
    800041c8:	dff1                	beqz	a5,800041a4 <iput+0x26>
    800041ca:	04a49783          	lh	a5,74(s1)
    800041ce:	fbf9                	bnez	a5,800041a4 <iput+0x26>
    acquiresleep(&ip->lock);
    800041d0:	01048913          	add	s2,s1,16
    800041d4:	854a                	mv	a0,s2
    800041d6:	00001097          	auipc	ra,0x1
    800041da:	a84080e7          	jalr	-1404(ra) # 80004c5a <acquiresleep>
    release(&itable.lock);
    800041de:	0023d517          	auipc	a0,0x23d
    800041e2:	c1250513          	add	a0,a0,-1006 # 80240df0 <itable>
    800041e6:	ffffd097          	auipc	ra,0xffffd
    800041ea:	b9e080e7          	jalr	-1122(ra) # 80000d84 <release>
    itrunc(ip);
    800041ee:	8526                	mv	a0,s1
    800041f0:	00000097          	auipc	ra,0x0
    800041f4:	ee2080e7          	jalr	-286(ra) # 800040d2 <itrunc>
    ip->type = 0;
    800041f8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800041fc:	8526                	mv	a0,s1
    800041fe:	00000097          	auipc	ra,0x0
    80004202:	cfa080e7          	jalr	-774(ra) # 80003ef8 <iupdate>
    ip->valid = 0;
    80004206:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000420a:	854a                	mv	a0,s2
    8000420c:	00001097          	auipc	ra,0x1
    80004210:	aa4080e7          	jalr	-1372(ra) # 80004cb0 <releasesleep>
    acquire(&itable.lock);
    80004214:	0023d517          	auipc	a0,0x23d
    80004218:	bdc50513          	add	a0,a0,-1060 # 80240df0 <itable>
    8000421c:	ffffd097          	auipc	ra,0xffffd
    80004220:	ab4080e7          	jalr	-1356(ra) # 80000cd0 <acquire>
    80004224:	b741                	j	800041a4 <iput+0x26>

0000000080004226 <iunlockput>:
{
    80004226:	1101                	add	sp,sp,-32
    80004228:	ec06                	sd	ra,24(sp)
    8000422a:	e822                	sd	s0,16(sp)
    8000422c:	e426                	sd	s1,8(sp)
    8000422e:	1000                	add	s0,sp,32
    80004230:	84aa                	mv	s1,a0
  iunlock(ip);
    80004232:	00000097          	auipc	ra,0x0
    80004236:	e54080e7          	jalr	-428(ra) # 80004086 <iunlock>
  iput(ip);
    8000423a:	8526                	mv	a0,s1
    8000423c:	00000097          	auipc	ra,0x0
    80004240:	f42080e7          	jalr	-190(ra) # 8000417e <iput>
}
    80004244:	60e2                	ld	ra,24(sp)
    80004246:	6442                	ld	s0,16(sp)
    80004248:	64a2                	ld	s1,8(sp)
    8000424a:	6105                	add	sp,sp,32
    8000424c:	8082                	ret

000000008000424e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000424e:	1141                	add	sp,sp,-16
    80004250:	e422                	sd	s0,8(sp)
    80004252:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    80004254:	411c                	lw	a5,0(a0)
    80004256:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80004258:	415c                	lw	a5,4(a0)
    8000425a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000425c:	04451783          	lh	a5,68(a0)
    80004260:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004264:	04a51783          	lh	a5,74(a0)
    80004268:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000426c:	04c56783          	lwu	a5,76(a0)
    80004270:	e99c                	sd	a5,16(a1)
}
    80004272:	6422                	ld	s0,8(sp)
    80004274:	0141                	add	sp,sp,16
    80004276:	8082                	ret

0000000080004278 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004278:	457c                	lw	a5,76(a0)
    8000427a:	0ed7e963          	bltu	a5,a3,8000436c <readi+0xf4>
{
    8000427e:	7159                	add	sp,sp,-112
    80004280:	f486                	sd	ra,104(sp)
    80004282:	f0a2                	sd	s0,96(sp)
    80004284:	eca6                	sd	s1,88(sp)
    80004286:	e8ca                	sd	s2,80(sp)
    80004288:	e4ce                	sd	s3,72(sp)
    8000428a:	e0d2                	sd	s4,64(sp)
    8000428c:	fc56                	sd	s5,56(sp)
    8000428e:	f85a                	sd	s6,48(sp)
    80004290:	f45e                	sd	s7,40(sp)
    80004292:	f062                	sd	s8,32(sp)
    80004294:	ec66                	sd	s9,24(sp)
    80004296:	e86a                	sd	s10,16(sp)
    80004298:	e46e                	sd	s11,8(sp)
    8000429a:	1880                	add	s0,sp,112
    8000429c:	8b2a                	mv	s6,a0
    8000429e:	8bae                	mv	s7,a1
    800042a0:	8a32                	mv	s4,a2
    800042a2:	84b6                	mv	s1,a3
    800042a4:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800042a6:	9f35                	addw	a4,a4,a3
    return 0;
    800042a8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800042aa:	0ad76063          	bltu	a4,a3,8000434a <readi+0xd2>
  if(off + n > ip->size)
    800042ae:	00e7f463          	bgeu	a5,a4,800042b6 <readi+0x3e>
    n = ip->size - off;
    800042b2:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800042b6:	0a0a8963          	beqz	s5,80004368 <readi+0xf0>
    800042ba:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800042bc:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800042c0:	5c7d                	li	s8,-1
    800042c2:	a82d                	j	800042fc <readi+0x84>
    800042c4:	020d1d93          	sll	s11,s10,0x20
    800042c8:	020ddd93          	srl	s11,s11,0x20
    800042cc:	05890613          	add	a2,s2,88
    800042d0:	86ee                	mv	a3,s11
    800042d2:	963a                	add	a2,a2,a4
    800042d4:	85d2                	mv	a1,s4
    800042d6:	855e                	mv	a0,s7
    800042d8:	ffffe097          	auipc	ra,0xffffe
    800042dc:	698080e7          	jalr	1688(ra) # 80002970 <either_copyout>
    800042e0:	05850d63          	beq	a0,s8,8000433a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800042e4:	854a                	mv	a0,s2
    800042e6:	fffff097          	auipc	ra,0xfffff
    800042ea:	5fe080e7          	jalr	1534(ra) # 800038e4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800042ee:	013d09bb          	addw	s3,s10,s3
    800042f2:	009d04bb          	addw	s1,s10,s1
    800042f6:	9a6e                	add	s4,s4,s11
    800042f8:	0559f763          	bgeu	s3,s5,80004346 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800042fc:	00a4d59b          	srlw	a1,s1,0xa
    80004300:	855a                	mv	a0,s6
    80004302:	00000097          	auipc	ra,0x0
    80004306:	8a4080e7          	jalr	-1884(ra) # 80003ba6 <bmap>
    8000430a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000430e:	cd85                	beqz	a1,80004346 <readi+0xce>
    bp = bread(ip->dev, addr);
    80004310:	000b2503          	lw	a0,0(s6)
    80004314:	fffff097          	auipc	ra,0xfffff
    80004318:	4a0080e7          	jalr	1184(ra) # 800037b4 <bread>
    8000431c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000431e:	3ff4f713          	and	a4,s1,1023
    80004322:	40ec87bb          	subw	a5,s9,a4
    80004326:	413a86bb          	subw	a3,s5,s3
    8000432a:	8d3e                	mv	s10,a5
    8000432c:	2781                	sext.w	a5,a5
    8000432e:	0006861b          	sext.w	a2,a3
    80004332:	f8f679e3          	bgeu	a2,a5,800042c4 <readi+0x4c>
    80004336:	8d36                	mv	s10,a3
    80004338:	b771                	j	800042c4 <readi+0x4c>
      brelse(bp);
    8000433a:	854a                	mv	a0,s2
    8000433c:	fffff097          	auipc	ra,0xfffff
    80004340:	5a8080e7          	jalr	1448(ra) # 800038e4 <brelse>
      tot = -1;
    80004344:	59fd                	li	s3,-1
  }
  return tot;
    80004346:	0009851b          	sext.w	a0,s3
}
    8000434a:	70a6                	ld	ra,104(sp)
    8000434c:	7406                	ld	s0,96(sp)
    8000434e:	64e6                	ld	s1,88(sp)
    80004350:	6946                	ld	s2,80(sp)
    80004352:	69a6                	ld	s3,72(sp)
    80004354:	6a06                	ld	s4,64(sp)
    80004356:	7ae2                	ld	s5,56(sp)
    80004358:	7b42                	ld	s6,48(sp)
    8000435a:	7ba2                	ld	s7,40(sp)
    8000435c:	7c02                	ld	s8,32(sp)
    8000435e:	6ce2                	ld	s9,24(sp)
    80004360:	6d42                	ld	s10,16(sp)
    80004362:	6da2                	ld	s11,8(sp)
    80004364:	6165                	add	sp,sp,112
    80004366:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004368:	89d6                	mv	s3,s5
    8000436a:	bff1                	j	80004346 <readi+0xce>
    return 0;
    8000436c:	4501                	li	a0,0
}
    8000436e:	8082                	ret

0000000080004370 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004370:	457c                	lw	a5,76(a0)
    80004372:	10d7e863          	bltu	a5,a3,80004482 <writei+0x112>
{
    80004376:	7159                	add	sp,sp,-112
    80004378:	f486                	sd	ra,104(sp)
    8000437a:	f0a2                	sd	s0,96(sp)
    8000437c:	eca6                	sd	s1,88(sp)
    8000437e:	e8ca                	sd	s2,80(sp)
    80004380:	e4ce                	sd	s3,72(sp)
    80004382:	e0d2                	sd	s4,64(sp)
    80004384:	fc56                	sd	s5,56(sp)
    80004386:	f85a                	sd	s6,48(sp)
    80004388:	f45e                	sd	s7,40(sp)
    8000438a:	f062                	sd	s8,32(sp)
    8000438c:	ec66                	sd	s9,24(sp)
    8000438e:	e86a                	sd	s10,16(sp)
    80004390:	e46e                	sd	s11,8(sp)
    80004392:	1880                	add	s0,sp,112
    80004394:	8aaa                	mv	s5,a0
    80004396:	8bae                	mv	s7,a1
    80004398:	8a32                	mv	s4,a2
    8000439a:	8936                	mv	s2,a3
    8000439c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000439e:	00e687bb          	addw	a5,a3,a4
    800043a2:	0ed7e263          	bltu	a5,a3,80004486 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800043a6:	00043737          	lui	a4,0x43
    800043aa:	0ef76063          	bltu	a4,a5,8000448a <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800043ae:	0c0b0863          	beqz	s6,8000447e <writei+0x10e>
    800043b2:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800043b4:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800043b8:	5c7d                	li	s8,-1
    800043ba:	a091                	j	800043fe <writei+0x8e>
    800043bc:	020d1d93          	sll	s11,s10,0x20
    800043c0:	020ddd93          	srl	s11,s11,0x20
    800043c4:	05848513          	add	a0,s1,88
    800043c8:	86ee                	mv	a3,s11
    800043ca:	8652                	mv	a2,s4
    800043cc:	85de                	mv	a1,s7
    800043ce:	953a                	add	a0,a0,a4
    800043d0:	ffffe097          	auipc	ra,0xffffe
    800043d4:	6a6080e7          	jalr	1702(ra) # 80002a76 <either_copyin>
    800043d8:	07850263          	beq	a0,s8,8000443c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800043dc:	8526                	mv	a0,s1
    800043de:	00000097          	auipc	ra,0x0
    800043e2:	75e080e7          	jalr	1886(ra) # 80004b3c <log_write>
    brelse(bp);
    800043e6:	8526                	mv	a0,s1
    800043e8:	fffff097          	auipc	ra,0xfffff
    800043ec:	4fc080e7          	jalr	1276(ra) # 800038e4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800043f0:	013d09bb          	addw	s3,s10,s3
    800043f4:	012d093b          	addw	s2,s10,s2
    800043f8:	9a6e                	add	s4,s4,s11
    800043fa:	0569f663          	bgeu	s3,s6,80004446 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800043fe:	00a9559b          	srlw	a1,s2,0xa
    80004402:	8556                	mv	a0,s5
    80004404:	fffff097          	auipc	ra,0xfffff
    80004408:	7a2080e7          	jalr	1954(ra) # 80003ba6 <bmap>
    8000440c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80004410:	c99d                	beqz	a1,80004446 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80004412:	000aa503          	lw	a0,0(s5)
    80004416:	fffff097          	auipc	ra,0xfffff
    8000441a:	39e080e7          	jalr	926(ra) # 800037b4 <bread>
    8000441e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004420:	3ff97713          	and	a4,s2,1023
    80004424:	40ec87bb          	subw	a5,s9,a4
    80004428:	413b06bb          	subw	a3,s6,s3
    8000442c:	8d3e                	mv	s10,a5
    8000442e:	2781                	sext.w	a5,a5
    80004430:	0006861b          	sext.w	a2,a3
    80004434:	f8f674e3          	bgeu	a2,a5,800043bc <writei+0x4c>
    80004438:	8d36                	mv	s10,a3
    8000443a:	b749                	j	800043bc <writei+0x4c>
      brelse(bp);
    8000443c:	8526                	mv	a0,s1
    8000443e:	fffff097          	auipc	ra,0xfffff
    80004442:	4a6080e7          	jalr	1190(ra) # 800038e4 <brelse>
  }

  if(off > ip->size)
    80004446:	04caa783          	lw	a5,76(s5)
    8000444a:	0127f463          	bgeu	a5,s2,80004452 <writei+0xe2>
    ip->size = off;
    8000444e:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004452:	8556                	mv	a0,s5
    80004454:	00000097          	auipc	ra,0x0
    80004458:	aa4080e7          	jalr	-1372(ra) # 80003ef8 <iupdate>

  return tot;
    8000445c:	0009851b          	sext.w	a0,s3
}
    80004460:	70a6                	ld	ra,104(sp)
    80004462:	7406                	ld	s0,96(sp)
    80004464:	64e6                	ld	s1,88(sp)
    80004466:	6946                	ld	s2,80(sp)
    80004468:	69a6                	ld	s3,72(sp)
    8000446a:	6a06                	ld	s4,64(sp)
    8000446c:	7ae2                	ld	s5,56(sp)
    8000446e:	7b42                	ld	s6,48(sp)
    80004470:	7ba2                	ld	s7,40(sp)
    80004472:	7c02                	ld	s8,32(sp)
    80004474:	6ce2                	ld	s9,24(sp)
    80004476:	6d42                	ld	s10,16(sp)
    80004478:	6da2                	ld	s11,8(sp)
    8000447a:	6165                	add	sp,sp,112
    8000447c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000447e:	89da                	mv	s3,s6
    80004480:	bfc9                	j	80004452 <writei+0xe2>
    return -1;
    80004482:	557d                	li	a0,-1
}
    80004484:	8082                	ret
    return -1;
    80004486:	557d                	li	a0,-1
    80004488:	bfe1                	j	80004460 <writei+0xf0>
    return -1;
    8000448a:	557d                	li	a0,-1
    8000448c:	bfd1                	j	80004460 <writei+0xf0>

000000008000448e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000448e:	1141                	add	sp,sp,-16
    80004490:	e406                	sd	ra,8(sp)
    80004492:	e022                	sd	s0,0(sp)
    80004494:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004496:	4639                	li	a2,14
    80004498:	ffffd097          	auipc	ra,0xffffd
    8000449c:	a04080e7          	jalr	-1532(ra) # 80000e9c <strncmp>
}
    800044a0:	60a2                	ld	ra,8(sp)
    800044a2:	6402                	ld	s0,0(sp)
    800044a4:	0141                	add	sp,sp,16
    800044a6:	8082                	ret

00000000800044a8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800044a8:	7139                	add	sp,sp,-64
    800044aa:	fc06                	sd	ra,56(sp)
    800044ac:	f822                	sd	s0,48(sp)
    800044ae:	f426                	sd	s1,40(sp)
    800044b0:	f04a                	sd	s2,32(sp)
    800044b2:	ec4e                	sd	s3,24(sp)
    800044b4:	e852                	sd	s4,16(sp)
    800044b6:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800044b8:	04451703          	lh	a4,68(a0)
    800044bc:	4785                	li	a5,1
    800044be:	00f71a63          	bne	a4,a5,800044d2 <dirlookup+0x2a>
    800044c2:	892a                	mv	s2,a0
    800044c4:	89ae                	mv	s3,a1
    800044c6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800044c8:	457c                	lw	a5,76(a0)
    800044ca:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800044cc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800044ce:	e79d                	bnez	a5,800044fc <dirlookup+0x54>
    800044d0:	a8a5                	j	80004548 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800044d2:	00004517          	auipc	a0,0x4
    800044d6:	15e50513          	add	a0,a0,350 # 80008630 <etext+0x630>
    800044da:	ffffc097          	auipc	ra,0xffffc
    800044de:	062080e7          	jalr	98(ra) # 8000053c <panic>
      panic("dirlookup read");
    800044e2:	00004517          	auipc	a0,0x4
    800044e6:	16650513          	add	a0,a0,358 # 80008648 <etext+0x648>
    800044ea:	ffffc097          	auipc	ra,0xffffc
    800044ee:	052080e7          	jalr	82(ra) # 8000053c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800044f2:	24c1                	addw	s1,s1,16
    800044f4:	04c92783          	lw	a5,76(s2)
    800044f8:	04f4f763          	bgeu	s1,a5,80004546 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800044fc:	4741                	li	a4,16
    800044fe:	86a6                	mv	a3,s1
    80004500:	fc040613          	add	a2,s0,-64
    80004504:	4581                	li	a1,0
    80004506:	854a                	mv	a0,s2
    80004508:	00000097          	auipc	ra,0x0
    8000450c:	d70080e7          	jalr	-656(ra) # 80004278 <readi>
    80004510:	47c1                	li	a5,16
    80004512:	fcf518e3          	bne	a0,a5,800044e2 <dirlookup+0x3a>
    if(de.inum == 0)
    80004516:	fc045783          	lhu	a5,-64(s0)
    8000451a:	dfe1                	beqz	a5,800044f2 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000451c:	fc240593          	add	a1,s0,-62
    80004520:	854e                	mv	a0,s3
    80004522:	00000097          	auipc	ra,0x0
    80004526:	f6c080e7          	jalr	-148(ra) # 8000448e <namecmp>
    8000452a:	f561                	bnez	a0,800044f2 <dirlookup+0x4a>
      if(poff)
    8000452c:	000a0463          	beqz	s4,80004534 <dirlookup+0x8c>
        *poff = off;
    80004530:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004534:	fc045583          	lhu	a1,-64(s0)
    80004538:	00092503          	lw	a0,0(s2)
    8000453c:	fffff097          	auipc	ra,0xfffff
    80004540:	754080e7          	jalr	1876(ra) # 80003c90 <iget>
    80004544:	a011                	j	80004548 <dirlookup+0xa0>
  return 0;
    80004546:	4501                	li	a0,0
}
    80004548:	70e2                	ld	ra,56(sp)
    8000454a:	7442                	ld	s0,48(sp)
    8000454c:	74a2                	ld	s1,40(sp)
    8000454e:	7902                	ld	s2,32(sp)
    80004550:	69e2                	ld	s3,24(sp)
    80004552:	6a42                	ld	s4,16(sp)
    80004554:	6121                	add	sp,sp,64
    80004556:	8082                	ret

0000000080004558 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004558:	711d                	add	sp,sp,-96
    8000455a:	ec86                	sd	ra,88(sp)
    8000455c:	e8a2                	sd	s0,80(sp)
    8000455e:	e4a6                	sd	s1,72(sp)
    80004560:	e0ca                	sd	s2,64(sp)
    80004562:	fc4e                	sd	s3,56(sp)
    80004564:	f852                	sd	s4,48(sp)
    80004566:	f456                	sd	s5,40(sp)
    80004568:	f05a                	sd	s6,32(sp)
    8000456a:	ec5e                	sd	s7,24(sp)
    8000456c:	e862                	sd	s8,16(sp)
    8000456e:	e466                	sd	s9,8(sp)
    80004570:	1080                	add	s0,sp,96
    80004572:	84aa                	mv	s1,a0
    80004574:	8b2e                	mv	s6,a1
    80004576:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004578:	00054703          	lbu	a4,0(a0)
    8000457c:	02f00793          	li	a5,47
    80004580:	02f70263          	beq	a4,a5,800045a4 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004584:	ffffe097          	auipc	ra,0xffffe
    80004588:	82c080e7          	jalr	-2004(ra) # 80001db0 <myproc>
    8000458c:	15053503          	ld	a0,336(a0)
    80004590:	00000097          	auipc	ra,0x0
    80004594:	9f6080e7          	jalr	-1546(ra) # 80003f86 <idup>
    80004598:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000459a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000459e:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800045a0:	4b85                	li	s7,1
    800045a2:	a875                	j	8000465e <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800045a4:	4585                	li	a1,1
    800045a6:	4505                	li	a0,1
    800045a8:	fffff097          	auipc	ra,0xfffff
    800045ac:	6e8080e7          	jalr	1768(ra) # 80003c90 <iget>
    800045b0:	8a2a                	mv	s4,a0
    800045b2:	b7e5                	j	8000459a <namex+0x42>
      iunlockput(ip);
    800045b4:	8552                	mv	a0,s4
    800045b6:	00000097          	auipc	ra,0x0
    800045ba:	c70080e7          	jalr	-912(ra) # 80004226 <iunlockput>
      return 0;
    800045be:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800045c0:	8552                	mv	a0,s4
    800045c2:	60e6                	ld	ra,88(sp)
    800045c4:	6446                	ld	s0,80(sp)
    800045c6:	64a6                	ld	s1,72(sp)
    800045c8:	6906                	ld	s2,64(sp)
    800045ca:	79e2                	ld	s3,56(sp)
    800045cc:	7a42                	ld	s4,48(sp)
    800045ce:	7aa2                	ld	s5,40(sp)
    800045d0:	7b02                	ld	s6,32(sp)
    800045d2:	6be2                	ld	s7,24(sp)
    800045d4:	6c42                	ld	s8,16(sp)
    800045d6:	6ca2                	ld	s9,8(sp)
    800045d8:	6125                	add	sp,sp,96
    800045da:	8082                	ret
      iunlock(ip);
    800045dc:	8552                	mv	a0,s4
    800045de:	00000097          	auipc	ra,0x0
    800045e2:	aa8080e7          	jalr	-1368(ra) # 80004086 <iunlock>
      return ip;
    800045e6:	bfe9                	j	800045c0 <namex+0x68>
      iunlockput(ip);
    800045e8:	8552                	mv	a0,s4
    800045ea:	00000097          	auipc	ra,0x0
    800045ee:	c3c080e7          	jalr	-964(ra) # 80004226 <iunlockput>
      return 0;
    800045f2:	8a4e                	mv	s4,s3
    800045f4:	b7f1                	j	800045c0 <namex+0x68>
  len = path - s;
    800045f6:	40998633          	sub	a2,s3,s1
    800045fa:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800045fe:	099c5863          	bge	s8,s9,8000468e <namex+0x136>
    memmove(name, s, DIRSIZ);
    80004602:	4639                	li	a2,14
    80004604:	85a6                	mv	a1,s1
    80004606:	8556                	mv	a0,s5
    80004608:	ffffd097          	auipc	ra,0xffffd
    8000460c:	820080e7          	jalr	-2016(ra) # 80000e28 <memmove>
    80004610:	84ce                	mv	s1,s3
  while(*path == '/')
    80004612:	0004c783          	lbu	a5,0(s1)
    80004616:	01279763          	bne	a5,s2,80004624 <namex+0xcc>
    path++;
    8000461a:	0485                	add	s1,s1,1
  while(*path == '/')
    8000461c:	0004c783          	lbu	a5,0(s1)
    80004620:	ff278de3          	beq	a5,s2,8000461a <namex+0xc2>
    ilock(ip);
    80004624:	8552                	mv	a0,s4
    80004626:	00000097          	auipc	ra,0x0
    8000462a:	99e080e7          	jalr	-1634(ra) # 80003fc4 <ilock>
    if(ip->type != T_DIR){
    8000462e:	044a1783          	lh	a5,68(s4)
    80004632:	f97791e3          	bne	a5,s7,800045b4 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80004636:	000b0563          	beqz	s6,80004640 <namex+0xe8>
    8000463a:	0004c783          	lbu	a5,0(s1)
    8000463e:	dfd9                	beqz	a5,800045dc <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004640:	4601                	li	a2,0
    80004642:	85d6                	mv	a1,s5
    80004644:	8552                	mv	a0,s4
    80004646:	00000097          	auipc	ra,0x0
    8000464a:	e62080e7          	jalr	-414(ra) # 800044a8 <dirlookup>
    8000464e:	89aa                	mv	s3,a0
    80004650:	dd41                	beqz	a0,800045e8 <namex+0x90>
    iunlockput(ip);
    80004652:	8552                	mv	a0,s4
    80004654:	00000097          	auipc	ra,0x0
    80004658:	bd2080e7          	jalr	-1070(ra) # 80004226 <iunlockput>
    ip = next;
    8000465c:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000465e:	0004c783          	lbu	a5,0(s1)
    80004662:	01279763          	bne	a5,s2,80004670 <namex+0x118>
    path++;
    80004666:	0485                	add	s1,s1,1
  while(*path == '/')
    80004668:	0004c783          	lbu	a5,0(s1)
    8000466c:	ff278de3          	beq	a5,s2,80004666 <namex+0x10e>
  if(*path == 0)
    80004670:	cb9d                	beqz	a5,800046a6 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80004672:	0004c783          	lbu	a5,0(s1)
    80004676:	89a6                	mv	s3,s1
  len = path - s;
    80004678:	4c81                	li	s9,0
    8000467a:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000467c:	01278963          	beq	a5,s2,8000468e <namex+0x136>
    80004680:	dbbd                	beqz	a5,800045f6 <namex+0x9e>
    path++;
    80004682:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80004684:	0009c783          	lbu	a5,0(s3)
    80004688:	ff279ce3          	bne	a5,s2,80004680 <namex+0x128>
    8000468c:	b7ad                	j	800045f6 <namex+0x9e>
    memmove(name, s, len);
    8000468e:	2601                	sext.w	a2,a2
    80004690:	85a6                	mv	a1,s1
    80004692:	8556                	mv	a0,s5
    80004694:	ffffc097          	auipc	ra,0xffffc
    80004698:	794080e7          	jalr	1940(ra) # 80000e28 <memmove>
    name[len] = 0;
    8000469c:	9cd6                	add	s9,s9,s5
    8000469e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800046a2:	84ce                	mv	s1,s3
    800046a4:	b7bd                	j	80004612 <namex+0xba>
  if(nameiparent){
    800046a6:	f00b0de3          	beqz	s6,800045c0 <namex+0x68>
    iput(ip);
    800046aa:	8552                	mv	a0,s4
    800046ac:	00000097          	auipc	ra,0x0
    800046b0:	ad2080e7          	jalr	-1326(ra) # 8000417e <iput>
    return 0;
    800046b4:	4a01                	li	s4,0
    800046b6:	b729                	j	800045c0 <namex+0x68>

00000000800046b8 <dirlink>:
{
    800046b8:	7139                	add	sp,sp,-64
    800046ba:	fc06                	sd	ra,56(sp)
    800046bc:	f822                	sd	s0,48(sp)
    800046be:	f426                	sd	s1,40(sp)
    800046c0:	f04a                	sd	s2,32(sp)
    800046c2:	ec4e                	sd	s3,24(sp)
    800046c4:	e852                	sd	s4,16(sp)
    800046c6:	0080                	add	s0,sp,64
    800046c8:	892a                	mv	s2,a0
    800046ca:	8a2e                	mv	s4,a1
    800046cc:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800046ce:	4601                	li	a2,0
    800046d0:	00000097          	auipc	ra,0x0
    800046d4:	dd8080e7          	jalr	-552(ra) # 800044a8 <dirlookup>
    800046d8:	e93d                	bnez	a0,8000474e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800046da:	04c92483          	lw	s1,76(s2)
    800046de:	c49d                	beqz	s1,8000470c <dirlink+0x54>
    800046e0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800046e2:	4741                	li	a4,16
    800046e4:	86a6                	mv	a3,s1
    800046e6:	fc040613          	add	a2,s0,-64
    800046ea:	4581                	li	a1,0
    800046ec:	854a                	mv	a0,s2
    800046ee:	00000097          	auipc	ra,0x0
    800046f2:	b8a080e7          	jalr	-1142(ra) # 80004278 <readi>
    800046f6:	47c1                	li	a5,16
    800046f8:	06f51163          	bne	a0,a5,8000475a <dirlink+0xa2>
    if(de.inum == 0)
    800046fc:	fc045783          	lhu	a5,-64(s0)
    80004700:	c791                	beqz	a5,8000470c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004702:	24c1                	addw	s1,s1,16
    80004704:	04c92783          	lw	a5,76(s2)
    80004708:	fcf4ede3          	bltu	s1,a5,800046e2 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000470c:	4639                	li	a2,14
    8000470e:	85d2                	mv	a1,s4
    80004710:	fc240513          	add	a0,s0,-62
    80004714:	ffffc097          	auipc	ra,0xffffc
    80004718:	7c4080e7          	jalr	1988(ra) # 80000ed8 <strncpy>
  de.inum = inum;
    8000471c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004720:	4741                	li	a4,16
    80004722:	86a6                	mv	a3,s1
    80004724:	fc040613          	add	a2,s0,-64
    80004728:	4581                	li	a1,0
    8000472a:	854a                	mv	a0,s2
    8000472c:	00000097          	auipc	ra,0x0
    80004730:	c44080e7          	jalr	-956(ra) # 80004370 <writei>
    80004734:	1541                	add	a0,a0,-16
    80004736:	00a03533          	snez	a0,a0
    8000473a:	40a00533          	neg	a0,a0
}
    8000473e:	70e2                	ld	ra,56(sp)
    80004740:	7442                	ld	s0,48(sp)
    80004742:	74a2                	ld	s1,40(sp)
    80004744:	7902                	ld	s2,32(sp)
    80004746:	69e2                	ld	s3,24(sp)
    80004748:	6a42                	ld	s4,16(sp)
    8000474a:	6121                	add	sp,sp,64
    8000474c:	8082                	ret
    iput(ip);
    8000474e:	00000097          	auipc	ra,0x0
    80004752:	a30080e7          	jalr	-1488(ra) # 8000417e <iput>
    return -1;
    80004756:	557d                	li	a0,-1
    80004758:	b7dd                	j	8000473e <dirlink+0x86>
      panic("dirlink read");
    8000475a:	00004517          	auipc	a0,0x4
    8000475e:	efe50513          	add	a0,a0,-258 # 80008658 <etext+0x658>
    80004762:	ffffc097          	auipc	ra,0xffffc
    80004766:	dda080e7          	jalr	-550(ra) # 8000053c <panic>

000000008000476a <namei>:

struct inode*
namei(char *path)
{
    8000476a:	1101                	add	sp,sp,-32
    8000476c:	ec06                	sd	ra,24(sp)
    8000476e:	e822                	sd	s0,16(sp)
    80004770:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004772:	fe040613          	add	a2,s0,-32
    80004776:	4581                	li	a1,0
    80004778:	00000097          	auipc	ra,0x0
    8000477c:	de0080e7          	jalr	-544(ra) # 80004558 <namex>
}
    80004780:	60e2                	ld	ra,24(sp)
    80004782:	6442                	ld	s0,16(sp)
    80004784:	6105                	add	sp,sp,32
    80004786:	8082                	ret

0000000080004788 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004788:	1141                	add	sp,sp,-16
    8000478a:	e406                	sd	ra,8(sp)
    8000478c:	e022                	sd	s0,0(sp)
    8000478e:	0800                	add	s0,sp,16
    80004790:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004792:	4585                	li	a1,1
    80004794:	00000097          	auipc	ra,0x0
    80004798:	dc4080e7          	jalr	-572(ra) # 80004558 <namex>
}
    8000479c:	60a2                	ld	ra,8(sp)
    8000479e:	6402                	ld	s0,0(sp)
    800047a0:	0141                	add	sp,sp,16
    800047a2:	8082                	ret

00000000800047a4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800047a4:	1101                	add	sp,sp,-32
    800047a6:	ec06                	sd	ra,24(sp)
    800047a8:	e822                	sd	s0,16(sp)
    800047aa:	e426                	sd	s1,8(sp)
    800047ac:	e04a                	sd	s2,0(sp)
    800047ae:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800047b0:	0023e917          	auipc	s2,0x23e
    800047b4:	0e890913          	add	s2,s2,232 # 80242898 <log>
    800047b8:	01892583          	lw	a1,24(s2)
    800047bc:	02892503          	lw	a0,40(s2)
    800047c0:	fffff097          	auipc	ra,0xfffff
    800047c4:	ff4080e7          	jalr	-12(ra) # 800037b4 <bread>
    800047c8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800047ca:	02c92603          	lw	a2,44(s2)
    800047ce:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800047d0:	00c05f63          	blez	a2,800047ee <write_head+0x4a>
    800047d4:	0023e717          	auipc	a4,0x23e
    800047d8:	0f470713          	add	a4,a4,244 # 802428c8 <log+0x30>
    800047dc:	87aa                	mv	a5,a0
    800047de:	060a                	sll	a2,a2,0x2
    800047e0:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800047e2:	4314                	lw	a3,0(a4)
    800047e4:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800047e6:	0711                	add	a4,a4,4
    800047e8:	0791                	add	a5,a5,4
    800047ea:	fec79ce3          	bne	a5,a2,800047e2 <write_head+0x3e>
  }
  bwrite(buf);
    800047ee:	8526                	mv	a0,s1
    800047f0:	fffff097          	auipc	ra,0xfffff
    800047f4:	0b6080e7          	jalr	182(ra) # 800038a6 <bwrite>
  brelse(buf);
    800047f8:	8526                	mv	a0,s1
    800047fa:	fffff097          	auipc	ra,0xfffff
    800047fe:	0ea080e7          	jalr	234(ra) # 800038e4 <brelse>
}
    80004802:	60e2                	ld	ra,24(sp)
    80004804:	6442                	ld	s0,16(sp)
    80004806:	64a2                	ld	s1,8(sp)
    80004808:	6902                	ld	s2,0(sp)
    8000480a:	6105                	add	sp,sp,32
    8000480c:	8082                	ret

000000008000480e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000480e:	0023e797          	auipc	a5,0x23e
    80004812:	0b67a783          	lw	a5,182(a5) # 802428c4 <log+0x2c>
    80004816:	0af05d63          	blez	a5,800048d0 <install_trans+0xc2>
{
    8000481a:	7139                	add	sp,sp,-64
    8000481c:	fc06                	sd	ra,56(sp)
    8000481e:	f822                	sd	s0,48(sp)
    80004820:	f426                	sd	s1,40(sp)
    80004822:	f04a                	sd	s2,32(sp)
    80004824:	ec4e                	sd	s3,24(sp)
    80004826:	e852                	sd	s4,16(sp)
    80004828:	e456                	sd	s5,8(sp)
    8000482a:	e05a                	sd	s6,0(sp)
    8000482c:	0080                	add	s0,sp,64
    8000482e:	8b2a                	mv	s6,a0
    80004830:	0023ea97          	auipc	s5,0x23e
    80004834:	098a8a93          	add	s5,s5,152 # 802428c8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004838:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000483a:	0023e997          	auipc	s3,0x23e
    8000483e:	05e98993          	add	s3,s3,94 # 80242898 <log>
    80004842:	a00d                	j	80004864 <install_trans+0x56>
    brelse(lbuf);
    80004844:	854a                	mv	a0,s2
    80004846:	fffff097          	auipc	ra,0xfffff
    8000484a:	09e080e7          	jalr	158(ra) # 800038e4 <brelse>
    brelse(dbuf);
    8000484e:	8526                	mv	a0,s1
    80004850:	fffff097          	auipc	ra,0xfffff
    80004854:	094080e7          	jalr	148(ra) # 800038e4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004858:	2a05                	addw	s4,s4,1
    8000485a:	0a91                	add	s5,s5,4
    8000485c:	02c9a783          	lw	a5,44(s3)
    80004860:	04fa5e63          	bge	s4,a5,800048bc <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004864:	0189a583          	lw	a1,24(s3)
    80004868:	014585bb          	addw	a1,a1,s4
    8000486c:	2585                	addw	a1,a1,1
    8000486e:	0289a503          	lw	a0,40(s3)
    80004872:	fffff097          	auipc	ra,0xfffff
    80004876:	f42080e7          	jalr	-190(ra) # 800037b4 <bread>
    8000487a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000487c:	000aa583          	lw	a1,0(s5)
    80004880:	0289a503          	lw	a0,40(s3)
    80004884:	fffff097          	auipc	ra,0xfffff
    80004888:	f30080e7          	jalr	-208(ra) # 800037b4 <bread>
    8000488c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000488e:	40000613          	li	a2,1024
    80004892:	05890593          	add	a1,s2,88
    80004896:	05850513          	add	a0,a0,88
    8000489a:	ffffc097          	auipc	ra,0xffffc
    8000489e:	58e080e7          	jalr	1422(ra) # 80000e28 <memmove>
    bwrite(dbuf);  // write dst to disk
    800048a2:	8526                	mv	a0,s1
    800048a4:	fffff097          	auipc	ra,0xfffff
    800048a8:	002080e7          	jalr	2(ra) # 800038a6 <bwrite>
    if(recovering == 0)
    800048ac:	f80b1ce3          	bnez	s6,80004844 <install_trans+0x36>
      bunpin(dbuf);
    800048b0:	8526                	mv	a0,s1
    800048b2:	fffff097          	auipc	ra,0xfffff
    800048b6:	10a080e7          	jalr	266(ra) # 800039bc <bunpin>
    800048ba:	b769                	j	80004844 <install_trans+0x36>
}
    800048bc:	70e2                	ld	ra,56(sp)
    800048be:	7442                	ld	s0,48(sp)
    800048c0:	74a2                	ld	s1,40(sp)
    800048c2:	7902                	ld	s2,32(sp)
    800048c4:	69e2                	ld	s3,24(sp)
    800048c6:	6a42                	ld	s4,16(sp)
    800048c8:	6aa2                	ld	s5,8(sp)
    800048ca:	6b02                	ld	s6,0(sp)
    800048cc:	6121                	add	sp,sp,64
    800048ce:	8082                	ret
    800048d0:	8082                	ret

00000000800048d2 <initlog>:
{
    800048d2:	7179                	add	sp,sp,-48
    800048d4:	f406                	sd	ra,40(sp)
    800048d6:	f022                	sd	s0,32(sp)
    800048d8:	ec26                	sd	s1,24(sp)
    800048da:	e84a                	sd	s2,16(sp)
    800048dc:	e44e                	sd	s3,8(sp)
    800048de:	1800                	add	s0,sp,48
    800048e0:	892a                	mv	s2,a0
    800048e2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800048e4:	0023e497          	auipc	s1,0x23e
    800048e8:	fb448493          	add	s1,s1,-76 # 80242898 <log>
    800048ec:	00004597          	auipc	a1,0x4
    800048f0:	d7c58593          	add	a1,a1,-644 # 80008668 <etext+0x668>
    800048f4:	8526                	mv	a0,s1
    800048f6:	ffffc097          	auipc	ra,0xffffc
    800048fa:	34a080e7          	jalr	842(ra) # 80000c40 <initlock>
  log.start = sb->logstart;
    800048fe:	0149a583          	lw	a1,20(s3)
    80004902:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004904:	0109a783          	lw	a5,16(s3)
    80004908:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000490a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000490e:	854a                	mv	a0,s2
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	ea4080e7          	jalr	-348(ra) # 800037b4 <bread>
  log.lh.n = lh->n;
    80004918:	4d30                	lw	a2,88(a0)
    8000491a:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000491c:	00c05f63          	blez	a2,8000493a <initlog+0x68>
    80004920:	87aa                	mv	a5,a0
    80004922:	0023e717          	auipc	a4,0x23e
    80004926:	fa670713          	add	a4,a4,-90 # 802428c8 <log+0x30>
    8000492a:	060a                	sll	a2,a2,0x2
    8000492c:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000492e:	4ff4                	lw	a3,92(a5)
    80004930:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004932:	0791                	add	a5,a5,4
    80004934:	0711                	add	a4,a4,4
    80004936:	fec79ce3          	bne	a5,a2,8000492e <initlog+0x5c>
  brelse(buf);
    8000493a:	fffff097          	auipc	ra,0xfffff
    8000493e:	faa080e7          	jalr	-86(ra) # 800038e4 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004942:	4505                	li	a0,1
    80004944:	00000097          	auipc	ra,0x0
    80004948:	eca080e7          	jalr	-310(ra) # 8000480e <install_trans>
  log.lh.n = 0;
    8000494c:	0023e797          	auipc	a5,0x23e
    80004950:	f607ac23          	sw	zero,-136(a5) # 802428c4 <log+0x2c>
  write_head(); // clear the log
    80004954:	00000097          	auipc	ra,0x0
    80004958:	e50080e7          	jalr	-432(ra) # 800047a4 <write_head>
}
    8000495c:	70a2                	ld	ra,40(sp)
    8000495e:	7402                	ld	s0,32(sp)
    80004960:	64e2                	ld	s1,24(sp)
    80004962:	6942                	ld	s2,16(sp)
    80004964:	69a2                	ld	s3,8(sp)
    80004966:	6145                	add	sp,sp,48
    80004968:	8082                	ret

000000008000496a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000496a:	1101                	add	sp,sp,-32
    8000496c:	ec06                	sd	ra,24(sp)
    8000496e:	e822                	sd	s0,16(sp)
    80004970:	e426                	sd	s1,8(sp)
    80004972:	e04a                	sd	s2,0(sp)
    80004974:	1000                	add	s0,sp,32
  acquire(&log.lock);
    80004976:	0023e517          	auipc	a0,0x23e
    8000497a:	f2250513          	add	a0,a0,-222 # 80242898 <log>
    8000497e:	ffffc097          	auipc	ra,0xffffc
    80004982:	352080e7          	jalr	850(ra) # 80000cd0 <acquire>
  while(1){
    if(log.committing){
    80004986:	0023e497          	auipc	s1,0x23e
    8000498a:	f1248493          	add	s1,s1,-238 # 80242898 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000498e:	4979                	li	s2,30
    80004990:	a039                	j	8000499e <begin_op+0x34>
      sleep(&log, &log.lock);
    80004992:	85a6                	mv	a1,s1
    80004994:	8526                	mv	a0,s1
    80004996:	ffffe097          	auipc	ra,0xffffe
    8000499a:	d64080e7          	jalr	-668(ra) # 800026fa <sleep>
    if(log.committing){
    8000499e:	50dc                	lw	a5,36(s1)
    800049a0:	fbed                	bnez	a5,80004992 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800049a2:	5098                	lw	a4,32(s1)
    800049a4:	2705                	addw	a4,a4,1
    800049a6:	0027179b          	sllw	a5,a4,0x2
    800049aa:	9fb9                	addw	a5,a5,a4
    800049ac:	0017979b          	sllw	a5,a5,0x1
    800049b0:	54d4                	lw	a3,44(s1)
    800049b2:	9fb5                	addw	a5,a5,a3
    800049b4:	00f95963          	bge	s2,a5,800049c6 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800049b8:	85a6                	mv	a1,s1
    800049ba:	8526                	mv	a0,s1
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	d3e080e7          	jalr	-706(ra) # 800026fa <sleep>
    800049c4:	bfe9                	j	8000499e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800049c6:	0023e517          	auipc	a0,0x23e
    800049ca:	ed250513          	add	a0,a0,-302 # 80242898 <log>
    800049ce:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800049d0:	ffffc097          	auipc	ra,0xffffc
    800049d4:	3b4080e7          	jalr	948(ra) # 80000d84 <release>
      break;
    }
  }
}
    800049d8:	60e2                	ld	ra,24(sp)
    800049da:	6442                	ld	s0,16(sp)
    800049dc:	64a2                	ld	s1,8(sp)
    800049de:	6902                	ld	s2,0(sp)
    800049e0:	6105                	add	sp,sp,32
    800049e2:	8082                	ret

00000000800049e4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800049e4:	7139                	add	sp,sp,-64
    800049e6:	fc06                	sd	ra,56(sp)
    800049e8:	f822                	sd	s0,48(sp)
    800049ea:	f426                	sd	s1,40(sp)
    800049ec:	f04a                	sd	s2,32(sp)
    800049ee:	ec4e                	sd	s3,24(sp)
    800049f0:	e852                	sd	s4,16(sp)
    800049f2:	e456                	sd	s5,8(sp)
    800049f4:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800049f6:	0023e497          	auipc	s1,0x23e
    800049fa:	ea248493          	add	s1,s1,-350 # 80242898 <log>
    800049fe:	8526                	mv	a0,s1
    80004a00:	ffffc097          	auipc	ra,0xffffc
    80004a04:	2d0080e7          	jalr	720(ra) # 80000cd0 <acquire>
  log.outstanding -= 1;
    80004a08:	509c                	lw	a5,32(s1)
    80004a0a:	37fd                	addw	a5,a5,-1
    80004a0c:	0007891b          	sext.w	s2,a5
    80004a10:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004a12:	50dc                	lw	a5,36(s1)
    80004a14:	e7b9                	bnez	a5,80004a62 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004a16:	04091e63          	bnez	s2,80004a72 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004a1a:	0023e497          	auipc	s1,0x23e
    80004a1e:	e7e48493          	add	s1,s1,-386 # 80242898 <log>
    80004a22:	4785                	li	a5,1
    80004a24:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004a26:	8526                	mv	a0,s1
    80004a28:	ffffc097          	auipc	ra,0xffffc
    80004a2c:	35c080e7          	jalr	860(ra) # 80000d84 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004a30:	54dc                	lw	a5,44(s1)
    80004a32:	06f04763          	bgtz	a5,80004aa0 <end_op+0xbc>
    acquire(&log.lock);
    80004a36:	0023e497          	auipc	s1,0x23e
    80004a3a:	e6248493          	add	s1,s1,-414 # 80242898 <log>
    80004a3e:	8526                	mv	a0,s1
    80004a40:	ffffc097          	auipc	ra,0xffffc
    80004a44:	290080e7          	jalr	656(ra) # 80000cd0 <acquire>
    log.committing = 0;
    80004a48:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004a4c:	8526                	mv	a0,s1
    80004a4e:	ffffe097          	auipc	ra,0xffffe
    80004a52:	ade080e7          	jalr	-1314(ra) # 8000252c <wakeup>
    release(&log.lock);
    80004a56:	8526                	mv	a0,s1
    80004a58:	ffffc097          	auipc	ra,0xffffc
    80004a5c:	32c080e7          	jalr	812(ra) # 80000d84 <release>
}
    80004a60:	a03d                	j	80004a8e <end_op+0xaa>
    panic("log.committing");
    80004a62:	00004517          	auipc	a0,0x4
    80004a66:	c0e50513          	add	a0,a0,-1010 # 80008670 <etext+0x670>
    80004a6a:	ffffc097          	auipc	ra,0xffffc
    80004a6e:	ad2080e7          	jalr	-1326(ra) # 8000053c <panic>
    wakeup(&log);
    80004a72:	0023e497          	auipc	s1,0x23e
    80004a76:	e2648493          	add	s1,s1,-474 # 80242898 <log>
    80004a7a:	8526                	mv	a0,s1
    80004a7c:	ffffe097          	auipc	ra,0xffffe
    80004a80:	ab0080e7          	jalr	-1360(ra) # 8000252c <wakeup>
  release(&log.lock);
    80004a84:	8526                	mv	a0,s1
    80004a86:	ffffc097          	auipc	ra,0xffffc
    80004a8a:	2fe080e7          	jalr	766(ra) # 80000d84 <release>
}
    80004a8e:	70e2                	ld	ra,56(sp)
    80004a90:	7442                	ld	s0,48(sp)
    80004a92:	74a2                	ld	s1,40(sp)
    80004a94:	7902                	ld	s2,32(sp)
    80004a96:	69e2                	ld	s3,24(sp)
    80004a98:	6a42                	ld	s4,16(sp)
    80004a9a:	6aa2                	ld	s5,8(sp)
    80004a9c:	6121                	add	sp,sp,64
    80004a9e:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004aa0:	0023ea97          	auipc	s5,0x23e
    80004aa4:	e28a8a93          	add	s5,s5,-472 # 802428c8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004aa8:	0023ea17          	auipc	s4,0x23e
    80004aac:	df0a0a13          	add	s4,s4,-528 # 80242898 <log>
    80004ab0:	018a2583          	lw	a1,24(s4)
    80004ab4:	012585bb          	addw	a1,a1,s2
    80004ab8:	2585                	addw	a1,a1,1
    80004aba:	028a2503          	lw	a0,40(s4)
    80004abe:	fffff097          	auipc	ra,0xfffff
    80004ac2:	cf6080e7          	jalr	-778(ra) # 800037b4 <bread>
    80004ac6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004ac8:	000aa583          	lw	a1,0(s5)
    80004acc:	028a2503          	lw	a0,40(s4)
    80004ad0:	fffff097          	auipc	ra,0xfffff
    80004ad4:	ce4080e7          	jalr	-796(ra) # 800037b4 <bread>
    80004ad8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004ada:	40000613          	li	a2,1024
    80004ade:	05850593          	add	a1,a0,88
    80004ae2:	05848513          	add	a0,s1,88
    80004ae6:	ffffc097          	auipc	ra,0xffffc
    80004aea:	342080e7          	jalr	834(ra) # 80000e28 <memmove>
    bwrite(to);  // write the log
    80004aee:	8526                	mv	a0,s1
    80004af0:	fffff097          	auipc	ra,0xfffff
    80004af4:	db6080e7          	jalr	-586(ra) # 800038a6 <bwrite>
    brelse(from);
    80004af8:	854e                	mv	a0,s3
    80004afa:	fffff097          	auipc	ra,0xfffff
    80004afe:	dea080e7          	jalr	-534(ra) # 800038e4 <brelse>
    brelse(to);
    80004b02:	8526                	mv	a0,s1
    80004b04:	fffff097          	auipc	ra,0xfffff
    80004b08:	de0080e7          	jalr	-544(ra) # 800038e4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004b0c:	2905                	addw	s2,s2,1
    80004b0e:	0a91                	add	s5,s5,4
    80004b10:	02ca2783          	lw	a5,44(s4)
    80004b14:	f8f94ee3          	blt	s2,a5,80004ab0 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004b18:	00000097          	auipc	ra,0x0
    80004b1c:	c8c080e7          	jalr	-884(ra) # 800047a4 <write_head>
    install_trans(0); // Now install writes to home locations
    80004b20:	4501                	li	a0,0
    80004b22:	00000097          	auipc	ra,0x0
    80004b26:	cec080e7          	jalr	-788(ra) # 8000480e <install_trans>
    log.lh.n = 0;
    80004b2a:	0023e797          	auipc	a5,0x23e
    80004b2e:	d807ad23          	sw	zero,-614(a5) # 802428c4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004b32:	00000097          	auipc	ra,0x0
    80004b36:	c72080e7          	jalr	-910(ra) # 800047a4 <write_head>
    80004b3a:	bdf5                	j	80004a36 <end_op+0x52>

0000000080004b3c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004b3c:	1101                	add	sp,sp,-32
    80004b3e:	ec06                	sd	ra,24(sp)
    80004b40:	e822                	sd	s0,16(sp)
    80004b42:	e426                	sd	s1,8(sp)
    80004b44:	e04a                	sd	s2,0(sp)
    80004b46:	1000                	add	s0,sp,32
    80004b48:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004b4a:	0023e917          	auipc	s2,0x23e
    80004b4e:	d4e90913          	add	s2,s2,-690 # 80242898 <log>
    80004b52:	854a                	mv	a0,s2
    80004b54:	ffffc097          	auipc	ra,0xffffc
    80004b58:	17c080e7          	jalr	380(ra) # 80000cd0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004b5c:	02c92603          	lw	a2,44(s2)
    80004b60:	47f5                	li	a5,29
    80004b62:	06c7c563          	blt	a5,a2,80004bcc <log_write+0x90>
    80004b66:	0023e797          	auipc	a5,0x23e
    80004b6a:	d4e7a783          	lw	a5,-690(a5) # 802428b4 <log+0x1c>
    80004b6e:	37fd                	addw	a5,a5,-1
    80004b70:	04f65e63          	bge	a2,a5,80004bcc <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004b74:	0023e797          	auipc	a5,0x23e
    80004b78:	d447a783          	lw	a5,-700(a5) # 802428b8 <log+0x20>
    80004b7c:	06f05063          	blez	a5,80004bdc <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004b80:	4781                	li	a5,0
    80004b82:	06c05563          	blez	a2,80004bec <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004b86:	44cc                	lw	a1,12(s1)
    80004b88:	0023e717          	auipc	a4,0x23e
    80004b8c:	d4070713          	add	a4,a4,-704 # 802428c8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004b90:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004b92:	4314                	lw	a3,0(a4)
    80004b94:	04b68c63          	beq	a3,a1,80004bec <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004b98:	2785                	addw	a5,a5,1
    80004b9a:	0711                	add	a4,a4,4
    80004b9c:	fef61be3          	bne	a2,a5,80004b92 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004ba0:	0621                	add	a2,a2,8
    80004ba2:	060a                	sll	a2,a2,0x2
    80004ba4:	0023e797          	auipc	a5,0x23e
    80004ba8:	cf478793          	add	a5,a5,-780 # 80242898 <log>
    80004bac:	97b2                	add	a5,a5,a2
    80004bae:	44d8                	lw	a4,12(s1)
    80004bb0:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004bb2:	8526                	mv	a0,s1
    80004bb4:	fffff097          	auipc	ra,0xfffff
    80004bb8:	dcc080e7          	jalr	-564(ra) # 80003980 <bpin>
    log.lh.n++;
    80004bbc:	0023e717          	auipc	a4,0x23e
    80004bc0:	cdc70713          	add	a4,a4,-804 # 80242898 <log>
    80004bc4:	575c                	lw	a5,44(a4)
    80004bc6:	2785                	addw	a5,a5,1
    80004bc8:	d75c                	sw	a5,44(a4)
    80004bca:	a82d                	j	80004c04 <log_write+0xc8>
    panic("too big a transaction");
    80004bcc:	00004517          	auipc	a0,0x4
    80004bd0:	ab450513          	add	a0,a0,-1356 # 80008680 <etext+0x680>
    80004bd4:	ffffc097          	auipc	ra,0xffffc
    80004bd8:	968080e7          	jalr	-1688(ra) # 8000053c <panic>
    panic("log_write outside of trans");
    80004bdc:	00004517          	auipc	a0,0x4
    80004be0:	abc50513          	add	a0,a0,-1348 # 80008698 <etext+0x698>
    80004be4:	ffffc097          	auipc	ra,0xffffc
    80004be8:	958080e7          	jalr	-1704(ra) # 8000053c <panic>
  log.lh.block[i] = b->blockno;
    80004bec:	00878693          	add	a3,a5,8
    80004bf0:	068a                	sll	a3,a3,0x2
    80004bf2:	0023e717          	auipc	a4,0x23e
    80004bf6:	ca670713          	add	a4,a4,-858 # 80242898 <log>
    80004bfa:	9736                	add	a4,a4,a3
    80004bfc:	44d4                	lw	a3,12(s1)
    80004bfe:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004c00:	faf609e3          	beq	a2,a5,80004bb2 <log_write+0x76>
  }
  release(&log.lock);
    80004c04:	0023e517          	auipc	a0,0x23e
    80004c08:	c9450513          	add	a0,a0,-876 # 80242898 <log>
    80004c0c:	ffffc097          	auipc	ra,0xffffc
    80004c10:	178080e7          	jalr	376(ra) # 80000d84 <release>
}
    80004c14:	60e2                	ld	ra,24(sp)
    80004c16:	6442                	ld	s0,16(sp)
    80004c18:	64a2                	ld	s1,8(sp)
    80004c1a:	6902                	ld	s2,0(sp)
    80004c1c:	6105                	add	sp,sp,32
    80004c1e:	8082                	ret

0000000080004c20 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004c20:	1101                	add	sp,sp,-32
    80004c22:	ec06                	sd	ra,24(sp)
    80004c24:	e822                	sd	s0,16(sp)
    80004c26:	e426                	sd	s1,8(sp)
    80004c28:	e04a                	sd	s2,0(sp)
    80004c2a:	1000                	add	s0,sp,32
    80004c2c:	84aa                	mv	s1,a0
    80004c2e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004c30:	00004597          	auipc	a1,0x4
    80004c34:	a8858593          	add	a1,a1,-1400 # 800086b8 <etext+0x6b8>
    80004c38:	0521                	add	a0,a0,8
    80004c3a:	ffffc097          	auipc	ra,0xffffc
    80004c3e:	006080e7          	jalr	6(ra) # 80000c40 <initlock>
  lk->name = name;
    80004c42:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004c46:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004c4a:	0204a423          	sw	zero,40(s1)
}
    80004c4e:	60e2                	ld	ra,24(sp)
    80004c50:	6442                	ld	s0,16(sp)
    80004c52:	64a2                	ld	s1,8(sp)
    80004c54:	6902                	ld	s2,0(sp)
    80004c56:	6105                	add	sp,sp,32
    80004c58:	8082                	ret

0000000080004c5a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004c5a:	1101                	add	sp,sp,-32
    80004c5c:	ec06                	sd	ra,24(sp)
    80004c5e:	e822                	sd	s0,16(sp)
    80004c60:	e426                	sd	s1,8(sp)
    80004c62:	e04a                	sd	s2,0(sp)
    80004c64:	1000                	add	s0,sp,32
    80004c66:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004c68:	00850913          	add	s2,a0,8
    80004c6c:	854a                	mv	a0,s2
    80004c6e:	ffffc097          	auipc	ra,0xffffc
    80004c72:	062080e7          	jalr	98(ra) # 80000cd0 <acquire>
  while (lk->locked) {
    80004c76:	409c                	lw	a5,0(s1)
    80004c78:	cb89                	beqz	a5,80004c8a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004c7a:	85ca                	mv	a1,s2
    80004c7c:	8526                	mv	a0,s1
    80004c7e:	ffffe097          	auipc	ra,0xffffe
    80004c82:	a7c080e7          	jalr	-1412(ra) # 800026fa <sleep>
  while (lk->locked) {
    80004c86:	409c                	lw	a5,0(s1)
    80004c88:	fbed                	bnez	a5,80004c7a <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004c8a:	4785                	li	a5,1
    80004c8c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004c8e:	ffffd097          	auipc	ra,0xffffd
    80004c92:	122080e7          	jalr	290(ra) # 80001db0 <myproc>
    80004c96:	591c                	lw	a5,48(a0)
    80004c98:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004c9a:	854a                	mv	a0,s2
    80004c9c:	ffffc097          	auipc	ra,0xffffc
    80004ca0:	0e8080e7          	jalr	232(ra) # 80000d84 <release>
}
    80004ca4:	60e2                	ld	ra,24(sp)
    80004ca6:	6442                	ld	s0,16(sp)
    80004ca8:	64a2                	ld	s1,8(sp)
    80004caa:	6902                	ld	s2,0(sp)
    80004cac:	6105                	add	sp,sp,32
    80004cae:	8082                	ret

0000000080004cb0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004cb0:	1101                	add	sp,sp,-32
    80004cb2:	ec06                	sd	ra,24(sp)
    80004cb4:	e822                	sd	s0,16(sp)
    80004cb6:	e426                	sd	s1,8(sp)
    80004cb8:	e04a                	sd	s2,0(sp)
    80004cba:	1000                	add	s0,sp,32
    80004cbc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004cbe:	00850913          	add	s2,a0,8
    80004cc2:	854a                	mv	a0,s2
    80004cc4:	ffffc097          	auipc	ra,0xffffc
    80004cc8:	00c080e7          	jalr	12(ra) # 80000cd0 <acquire>
  lk->locked = 0;
    80004ccc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004cd0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004cd4:	8526                	mv	a0,s1
    80004cd6:	ffffe097          	auipc	ra,0xffffe
    80004cda:	856080e7          	jalr	-1962(ra) # 8000252c <wakeup>
  release(&lk->lk);
    80004cde:	854a                	mv	a0,s2
    80004ce0:	ffffc097          	auipc	ra,0xffffc
    80004ce4:	0a4080e7          	jalr	164(ra) # 80000d84 <release>
}
    80004ce8:	60e2                	ld	ra,24(sp)
    80004cea:	6442                	ld	s0,16(sp)
    80004cec:	64a2                	ld	s1,8(sp)
    80004cee:	6902                	ld	s2,0(sp)
    80004cf0:	6105                	add	sp,sp,32
    80004cf2:	8082                	ret

0000000080004cf4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004cf4:	7179                	add	sp,sp,-48
    80004cf6:	f406                	sd	ra,40(sp)
    80004cf8:	f022                	sd	s0,32(sp)
    80004cfa:	ec26                	sd	s1,24(sp)
    80004cfc:	e84a                	sd	s2,16(sp)
    80004cfe:	e44e                	sd	s3,8(sp)
    80004d00:	1800                	add	s0,sp,48
    80004d02:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004d04:	00850913          	add	s2,a0,8
    80004d08:	854a                	mv	a0,s2
    80004d0a:	ffffc097          	auipc	ra,0xffffc
    80004d0e:	fc6080e7          	jalr	-58(ra) # 80000cd0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004d12:	409c                	lw	a5,0(s1)
    80004d14:	ef99                	bnez	a5,80004d32 <holdingsleep+0x3e>
    80004d16:	4481                	li	s1,0
  release(&lk->lk);
    80004d18:	854a                	mv	a0,s2
    80004d1a:	ffffc097          	auipc	ra,0xffffc
    80004d1e:	06a080e7          	jalr	106(ra) # 80000d84 <release>
  return r;
}
    80004d22:	8526                	mv	a0,s1
    80004d24:	70a2                	ld	ra,40(sp)
    80004d26:	7402                	ld	s0,32(sp)
    80004d28:	64e2                	ld	s1,24(sp)
    80004d2a:	6942                	ld	s2,16(sp)
    80004d2c:	69a2                	ld	s3,8(sp)
    80004d2e:	6145                	add	sp,sp,48
    80004d30:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004d32:	0284a983          	lw	s3,40(s1)
    80004d36:	ffffd097          	auipc	ra,0xffffd
    80004d3a:	07a080e7          	jalr	122(ra) # 80001db0 <myproc>
    80004d3e:	5904                	lw	s1,48(a0)
    80004d40:	413484b3          	sub	s1,s1,s3
    80004d44:	0014b493          	seqz	s1,s1
    80004d48:	bfc1                	j	80004d18 <holdingsleep+0x24>

0000000080004d4a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004d4a:	1141                	add	sp,sp,-16
    80004d4c:	e406                	sd	ra,8(sp)
    80004d4e:	e022                	sd	s0,0(sp)
    80004d50:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004d52:	00004597          	auipc	a1,0x4
    80004d56:	97658593          	add	a1,a1,-1674 # 800086c8 <etext+0x6c8>
    80004d5a:	0023e517          	auipc	a0,0x23e
    80004d5e:	c8650513          	add	a0,a0,-890 # 802429e0 <ftable>
    80004d62:	ffffc097          	auipc	ra,0xffffc
    80004d66:	ede080e7          	jalr	-290(ra) # 80000c40 <initlock>
}
    80004d6a:	60a2                	ld	ra,8(sp)
    80004d6c:	6402                	ld	s0,0(sp)
    80004d6e:	0141                	add	sp,sp,16
    80004d70:	8082                	ret

0000000080004d72 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004d72:	1101                	add	sp,sp,-32
    80004d74:	ec06                	sd	ra,24(sp)
    80004d76:	e822                	sd	s0,16(sp)
    80004d78:	e426                	sd	s1,8(sp)
    80004d7a:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004d7c:	0023e517          	auipc	a0,0x23e
    80004d80:	c6450513          	add	a0,a0,-924 # 802429e0 <ftable>
    80004d84:	ffffc097          	auipc	ra,0xffffc
    80004d88:	f4c080e7          	jalr	-180(ra) # 80000cd0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004d8c:	0023e497          	auipc	s1,0x23e
    80004d90:	c6c48493          	add	s1,s1,-916 # 802429f8 <ftable+0x18>
    80004d94:	0023f717          	auipc	a4,0x23f
    80004d98:	c0470713          	add	a4,a4,-1020 # 80243998 <disk>
    if(f->ref == 0){
    80004d9c:	40dc                	lw	a5,4(s1)
    80004d9e:	cf99                	beqz	a5,80004dbc <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004da0:	02848493          	add	s1,s1,40
    80004da4:	fee49ce3          	bne	s1,a4,80004d9c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004da8:	0023e517          	auipc	a0,0x23e
    80004dac:	c3850513          	add	a0,a0,-968 # 802429e0 <ftable>
    80004db0:	ffffc097          	auipc	ra,0xffffc
    80004db4:	fd4080e7          	jalr	-44(ra) # 80000d84 <release>
  return 0;
    80004db8:	4481                	li	s1,0
    80004dba:	a819                	j	80004dd0 <filealloc+0x5e>
      f->ref = 1;
    80004dbc:	4785                	li	a5,1
    80004dbe:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004dc0:	0023e517          	auipc	a0,0x23e
    80004dc4:	c2050513          	add	a0,a0,-992 # 802429e0 <ftable>
    80004dc8:	ffffc097          	auipc	ra,0xffffc
    80004dcc:	fbc080e7          	jalr	-68(ra) # 80000d84 <release>
}
    80004dd0:	8526                	mv	a0,s1
    80004dd2:	60e2                	ld	ra,24(sp)
    80004dd4:	6442                	ld	s0,16(sp)
    80004dd6:	64a2                	ld	s1,8(sp)
    80004dd8:	6105                	add	sp,sp,32
    80004dda:	8082                	ret

0000000080004ddc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004ddc:	1101                	add	sp,sp,-32
    80004dde:	ec06                	sd	ra,24(sp)
    80004de0:	e822                	sd	s0,16(sp)
    80004de2:	e426                	sd	s1,8(sp)
    80004de4:	1000                	add	s0,sp,32
    80004de6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004de8:	0023e517          	auipc	a0,0x23e
    80004dec:	bf850513          	add	a0,a0,-1032 # 802429e0 <ftable>
    80004df0:	ffffc097          	auipc	ra,0xffffc
    80004df4:	ee0080e7          	jalr	-288(ra) # 80000cd0 <acquire>
  if(f->ref < 1)
    80004df8:	40dc                	lw	a5,4(s1)
    80004dfa:	02f05263          	blez	a5,80004e1e <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004dfe:	2785                	addw	a5,a5,1
    80004e00:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004e02:	0023e517          	auipc	a0,0x23e
    80004e06:	bde50513          	add	a0,a0,-1058 # 802429e0 <ftable>
    80004e0a:	ffffc097          	auipc	ra,0xffffc
    80004e0e:	f7a080e7          	jalr	-134(ra) # 80000d84 <release>
  return f;
}
    80004e12:	8526                	mv	a0,s1
    80004e14:	60e2                	ld	ra,24(sp)
    80004e16:	6442                	ld	s0,16(sp)
    80004e18:	64a2                	ld	s1,8(sp)
    80004e1a:	6105                	add	sp,sp,32
    80004e1c:	8082                	ret
    panic("filedup");
    80004e1e:	00004517          	auipc	a0,0x4
    80004e22:	8b250513          	add	a0,a0,-1870 # 800086d0 <etext+0x6d0>
    80004e26:	ffffb097          	auipc	ra,0xffffb
    80004e2a:	716080e7          	jalr	1814(ra) # 8000053c <panic>

0000000080004e2e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004e2e:	7139                	add	sp,sp,-64
    80004e30:	fc06                	sd	ra,56(sp)
    80004e32:	f822                	sd	s0,48(sp)
    80004e34:	f426                	sd	s1,40(sp)
    80004e36:	f04a                	sd	s2,32(sp)
    80004e38:	ec4e                	sd	s3,24(sp)
    80004e3a:	e852                	sd	s4,16(sp)
    80004e3c:	e456                	sd	s5,8(sp)
    80004e3e:	0080                	add	s0,sp,64
    80004e40:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004e42:	0023e517          	auipc	a0,0x23e
    80004e46:	b9e50513          	add	a0,a0,-1122 # 802429e0 <ftable>
    80004e4a:	ffffc097          	auipc	ra,0xffffc
    80004e4e:	e86080e7          	jalr	-378(ra) # 80000cd0 <acquire>
  if(f->ref < 1)
    80004e52:	40dc                	lw	a5,4(s1)
    80004e54:	06f05163          	blez	a5,80004eb6 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004e58:	37fd                	addw	a5,a5,-1
    80004e5a:	0007871b          	sext.w	a4,a5
    80004e5e:	c0dc                	sw	a5,4(s1)
    80004e60:	06e04363          	bgtz	a4,80004ec6 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004e64:	0004a903          	lw	s2,0(s1)
    80004e68:	0094ca83          	lbu	s5,9(s1)
    80004e6c:	0104ba03          	ld	s4,16(s1)
    80004e70:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004e74:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004e78:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004e7c:	0023e517          	auipc	a0,0x23e
    80004e80:	b6450513          	add	a0,a0,-1180 # 802429e0 <ftable>
    80004e84:	ffffc097          	auipc	ra,0xffffc
    80004e88:	f00080e7          	jalr	-256(ra) # 80000d84 <release>

  if(ff.type == FD_PIPE){
    80004e8c:	4785                	li	a5,1
    80004e8e:	04f90d63          	beq	s2,a5,80004ee8 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004e92:	3979                	addw	s2,s2,-2
    80004e94:	4785                	li	a5,1
    80004e96:	0527e063          	bltu	a5,s2,80004ed6 <fileclose+0xa8>
    begin_op();
    80004e9a:	00000097          	auipc	ra,0x0
    80004e9e:	ad0080e7          	jalr	-1328(ra) # 8000496a <begin_op>
    iput(ff.ip);
    80004ea2:	854e                	mv	a0,s3
    80004ea4:	fffff097          	auipc	ra,0xfffff
    80004ea8:	2da080e7          	jalr	730(ra) # 8000417e <iput>
    end_op();
    80004eac:	00000097          	auipc	ra,0x0
    80004eb0:	b38080e7          	jalr	-1224(ra) # 800049e4 <end_op>
    80004eb4:	a00d                	j	80004ed6 <fileclose+0xa8>
    panic("fileclose");
    80004eb6:	00004517          	auipc	a0,0x4
    80004eba:	82250513          	add	a0,a0,-2014 # 800086d8 <etext+0x6d8>
    80004ebe:	ffffb097          	auipc	ra,0xffffb
    80004ec2:	67e080e7          	jalr	1662(ra) # 8000053c <panic>
    release(&ftable.lock);
    80004ec6:	0023e517          	auipc	a0,0x23e
    80004eca:	b1a50513          	add	a0,a0,-1254 # 802429e0 <ftable>
    80004ece:	ffffc097          	auipc	ra,0xffffc
    80004ed2:	eb6080e7          	jalr	-330(ra) # 80000d84 <release>
  }
}
    80004ed6:	70e2                	ld	ra,56(sp)
    80004ed8:	7442                	ld	s0,48(sp)
    80004eda:	74a2                	ld	s1,40(sp)
    80004edc:	7902                	ld	s2,32(sp)
    80004ede:	69e2                	ld	s3,24(sp)
    80004ee0:	6a42                	ld	s4,16(sp)
    80004ee2:	6aa2                	ld	s5,8(sp)
    80004ee4:	6121                	add	sp,sp,64
    80004ee6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004ee8:	85d6                	mv	a1,s5
    80004eea:	8552                	mv	a0,s4
    80004eec:	00000097          	auipc	ra,0x0
    80004ef0:	348080e7          	jalr	840(ra) # 80005234 <pipeclose>
    80004ef4:	b7cd                	j	80004ed6 <fileclose+0xa8>

0000000080004ef6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004ef6:	715d                	add	sp,sp,-80
    80004ef8:	e486                	sd	ra,72(sp)
    80004efa:	e0a2                	sd	s0,64(sp)
    80004efc:	fc26                	sd	s1,56(sp)
    80004efe:	f84a                	sd	s2,48(sp)
    80004f00:	f44e                	sd	s3,40(sp)
    80004f02:	0880                	add	s0,sp,80
    80004f04:	84aa                	mv	s1,a0
    80004f06:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004f08:	ffffd097          	auipc	ra,0xffffd
    80004f0c:	ea8080e7          	jalr	-344(ra) # 80001db0 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004f10:	409c                	lw	a5,0(s1)
    80004f12:	37f9                	addw	a5,a5,-2
    80004f14:	4705                	li	a4,1
    80004f16:	04f76763          	bltu	a4,a5,80004f64 <filestat+0x6e>
    80004f1a:	892a                	mv	s2,a0
    ilock(f->ip);
    80004f1c:	6c88                	ld	a0,24(s1)
    80004f1e:	fffff097          	auipc	ra,0xfffff
    80004f22:	0a6080e7          	jalr	166(ra) # 80003fc4 <ilock>
    stati(f->ip, &st);
    80004f26:	fb840593          	add	a1,s0,-72
    80004f2a:	6c88                	ld	a0,24(s1)
    80004f2c:	fffff097          	auipc	ra,0xfffff
    80004f30:	322080e7          	jalr	802(ra) # 8000424e <stati>
    iunlock(f->ip);
    80004f34:	6c88                	ld	a0,24(s1)
    80004f36:	fffff097          	auipc	ra,0xfffff
    80004f3a:	150080e7          	jalr	336(ra) # 80004086 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004f3e:	46e1                	li	a3,24
    80004f40:	fb840613          	add	a2,s0,-72
    80004f44:	85ce                	mv	a1,s3
    80004f46:	05093503          	ld	a0,80(s2)
    80004f4a:	ffffd097          	auipc	ra,0xffffd
    80004f4e:	95e080e7          	jalr	-1698(ra) # 800018a8 <copyout>
    80004f52:	41f5551b          	sraw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004f56:	60a6                	ld	ra,72(sp)
    80004f58:	6406                	ld	s0,64(sp)
    80004f5a:	74e2                	ld	s1,56(sp)
    80004f5c:	7942                	ld	s2,48(sp)
    80004f5e:	79a2                	ld	s3,40(sp)
    80004f60:	6161                	add	sp,sp,80
    80004f62:	8082                	ret
  return -1;
    80004f64:	557d                	li	a0,-1
    80004f66:	bfc5                	j	80004f56 <filestat+0x60>

0000000080004f68 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004f68:	7179                	add	sp,sp,-48
    80004f6a:	f406                	sd	ra,40(sp)
    80004f6c:	f022                	sd	s0,32(sp)
    80004f6e:	ec26                	sd	s1,24(sp)
    80004f70:	e84a                	sd	s2,16(sp)
    80004f72:	e44e                	sd	s3,8(sp)
    80004f74:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004f76:	00854783          	lbu	a5,8(a0)
    80004f7a:	c3d5                	beqz	a5,8000501e <fileread+0xb6>
    80004f7c:	84aa                	mv	s1,a0
    80004f7e:	89ae                	mv	s3,a1
    80004f80:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004f82:	411c                	lw	a5,0(a0)
    80004f84:	4705                	li	a4,1
    80004f86:	04e78963          	beq	a5,a4,80004fd8 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004f8a:	470d                	li	a4,3
    80004f8c:	04e78d63          	beq	a5,a4,80004fe6 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004f90:	4709                	li	a4,2
    80004f92:	06e79e63          	bne	a5,a4,8000500e <fileread+0xa6>
    ilock(f->ip);
    80004f96:	6d08                	ld	a0,24(a0)
    80004f98:	fffff097          	auipc	ra,0xfffff
    80004f9c:	02c080e7          	jalr	44(ra) # 80003fc4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004fa0:	874a                	mv	a4,s2
    80004fa2:	5094                	lw	a3,32(s1)
    80004fa4:	864e                	mv	a2,s3
    80004fa6:	4585                	li	a1,1
    80004fa8:	6c88                	ld	a0,24(s1)
    80004faa:	fffff097          	auipc	ra,0xfffff
    80004fae:	2ce080e7          	jalr	718(ra) # 80004278 <readi>
    80004fb2:	892a                	mv	s2,a0
    80004fb4:	00a05563          	blez	a0,80004fbe <fileread+0x56>
      f->off += r;
    80004fb8:	509c                	lw	a5,32(s1)
    80004fba:	9fa9                	addw	a5,a5,a0
    80004fbc:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004fbe:	6c88                	ld	a0,24(s1)
    80004fc0:	fffff097          	auipc	ra,0xfffff
    80004fc4:	0c6080e7          	jalr	198(ra) # 80004086 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004fc8:	854a                	mv	a0,s2
    80004fca:	70a2                	ld	ra,40(sp)
    80004fcc:	7402                	ld	s0,32(sp)
    80004fce:	64e2                	ld	s1,24(sp)
    80004fd0:	6942                	ld	s2,16(sp)
    80004fd2:	69a2                	ld	s3,8(sp)
    80004fd4:	6145                	add	sp,sp,48
    80004fd6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004fd8:	6908                	ld	a0,16(a0)
    80004fda:	00000097          	auipc	ra,0x0
    80004fde:	3c2080e7          	jalr	962(ra) # 8000539c <piperead>
    80004fe2:	892a                	mv	s2,a0
    80004fe4:	b7d5                	j	80004fc8 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004fe6:	02451783          	lh	a5,36(a0)
    80004fea:	03079693          	sll	a3,a5,0x30
    80004fee:	92c1                	srl	a3,a3,0x30
    80004ff0:	4725                	li	a4,9
    80004ff2:	02d76863          	bltu	a4,a3,80005022 <fileread+0xba>
    80004ff6:	0792                	sll	a5,a5,0x4
    80004ff8:	0023e717          	auipc	a4,0x23e
    80004ffc:	94870713          	add	a4,a4,-1720 # 80242940 <devsw>
    80005000:	97ba                	add	a5,a5,a4
    80005002:	639c                	ld	a5,0(a5)
    80005004:	c38d                	beqz	a5,80005026 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80005006:	4505                	li	a0,1
    80005008:	9782                	jalr	a5
    8000500a:	892a                	mv	s2,a0
    8000500c:	bf75                	j	80004fc8 <fileread+0x60>
    panic("fileread");
    8000500e:	00003517          	auipc	a0,0x3
    80005012:	6da50513          	add	a0,a0,1754 # 800086e8 <etext+0x6e8>
    80005016:	ffffb097          	auipc	ra,0xffffb
    8000501a:	526080e7          	jalr	1318(ra) # 8000053c <panic>
    return -1;
    8000501e:	597d                	li	s2,-1
    80005020:	b765                	j	80004fc8 <fileread+0x60>
      return -1;
    80005022:	597d                	li	s2,-1
    80005024:	b755                	j	80004fc8 <fileread+0x60>
    80005026:	597d                	li	s2,-1
    80005028:	b745                	j	80004fc8 <fileread+0x60>

000000008000502a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000502a:	00954783          	lbu	a5,9(a0)
    8000502e:	10078e63          	beqz	a5,8000514a <filewrite+0x120>
{
    80005032:	715d                	add	sp,sp,-80
    80005034:	e486                	sd	ra,72(sp)
    80005036:	e0a2                	sd	s0,64(sp)
    80005038:	fc26                	sd	s1,56(sp)
    8000503a:	f84a                	sd	s2,48(sp)
    8000503c:	f44e                	sd	s3,40(sp)
    8000503e:	f052                	sd	s4,32(sp)
    80005040:	ec56                	sd	s5,24(sp)
    80005042:	e85a                	sd	s6,16(sp)
    80005044:	e45e                	sd	s7,8(sp)
    80005046:	e062                	sd	s8,0(sp)
    80005048:	0880                	add	s0,sp,80
    8000504a:	892a                	mv	s2,a0
    8000504c:	8b2e                	mv	s6,a1
    8000504e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80005050:	411c                	lw	a5,0(a0)
    80005052:	4705                	li	a4,1
    80005054:	02e78263          	beq	a5,a4,80005078 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005058:	470d                	li	a4,3
    8000505a:	02e78563          	beq	a5,a4,80005084 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000505e:	4709                	li	a4,2
    80005060:	0ce79d63          	bne	a5,a4,8000513a <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80005064:	0ac05b63          	blez	a2,8000511a <filewrite+0xf0>
    int i = 0;
    80005068:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    8000506a:	6b85                	lui	s7,0x1
    8000506c:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80005070:	6c05                	lui	s8,0x1
    80005072:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80005076:	a851                	j	8000510a <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80005078:	6908                	ld	a0,16(a0)
    8000507a:	00000097          	auipc	ra,0x0
    8000507e:	22a080e7          	jalr	554(ra) # 800052a4 <pipewrite>
    80005082:	a045                	j	80005122 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80005084:	02451783          	lh	a5,36(a0)
    80005088:	03079693          	sll	a3,a5,0x30
    8000508c:	92c1                	srl	a3,a3,0x30
    8000508e:	4725                	li	a4,9
    80005090:	0ad76f63          	bltu	a4,a3,8000514e <filewrite+0x124>
    80005094:	0792                	sll	a5,a5,0x4
    80005096:	0023e717          	auipc	a4,0x23e
    8000509a:	8aa70713          	add	a4,a4,-1878 # 80242940 <devsw>
    8000509e:	97ba                	add	a5,a5,a4
    800050a0:	679c                	ld	a5,8(a5)
    800050a2:	cbc5                	beqz	a5,80005152 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    800050a4:	4505                	li	a0,1
    800050a6:	9782                	jalr	a5
    800050a8:	a8ad                	j	80005122 <filewrite+0xf8>
      if(n1 > max)
    800050aa:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800050ae:	00000097          	auipc	ra,0x0
    800050b2:	8bc080e7          	jalr	-1860(ra) # 8000496a <begin_op>
      ilock(f->ip);
    800050b6:	01893503          	ld	a0,24(s2)
    800050ba:	fffff097          	auipc	ra,0xfffff
    800050be:	f0a080e7          	jalr	-246(ra) # 80003fc4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800050c2:	8756                	mv	a4,s5
    800050c4:	02092683          	lw	a3,32(s2)
    800050c8:	01698633          	add	a2,s3,s6
    800050cc:	4585                	li	a1,1
    800050ce:	01893503          	ld	a0,24(s2)
    800050d2:	fffff097          	auipc	ra,0xfffff
    800050d6:	29e080e7          	jalr	670(ra) # 80004370 <writei>
    800050da:	84aa                	mv	s1,a0
    800050dc:	00a05763          	blez	a0,800050ea <filewrite+0xc0>
        f->off += r;
    800050e0:	02092783          	lw	a5,32(s2)
    800050e4:	9fa9                	addw	a5,a5,a0
    800050e6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800050ea:	01893503          	ld	a0,24(s2)
    800050ee:	fffff097          	auipc	ra,0xfffff
    800050f2:	f98080e7          	jalr	-104(ra) # 80004086 <iunlock>
      end_op();
    800050f6:	00000097          	auipc	ra,0x0
    800050fa:	8ee080e7          	jalr	-1810(ra) # 800049e4 <end_op>

      if(r != n1){
    800050fe:	009a9f63          	bne	s5,s1,8000511c <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80005102:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80005106:	0149db63          	bge	s3,s4,8000511c <filewrite+0xf2>
      int n1 = n - i;
    8000510a:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000510e:	0004879b          	sext.w	a5,s1
    80005112:	f8fbdce3          	bge	s7,a5,800050aa <filewrite+0x80>
    80005116:	84e2                	mv	s1,s8
    80005118:	bf49                	j	800050aa <filewrite+0x80>
    int i = 0;
    8000511a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    8000511c:	033a1d63          	bne	s4,s3,80005156 <filewrite+0x12c>
    80005120:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80005122:	60a6                	ld	ra,72(sp)
    80005124:	6406                	ld	s0,64(sp)
    80005126:	74e2                	ld	s1,56(sp)
    80005128:	7942                	ld	s2,48(sp)
    8000512a:	79a2                	ld	s3,40(sp)
    8000512c:	7a02                	ld	s4,32(sp)
    8000512e:	6ae2                	ld	s5,24(sp)
    80005130:	6b42                	ld	s6,16(sp)
    80005132:	6ba2                	ld	s7,8(sp)
    80005134:	6c02                	ld	s8,0(sp)
    80005136:	6161                	add	sp,sp,80
    80005138:	8082                	ret
    panic("filewrite");
    8000513a:	00003517          	auipc	a0,0x3
    8000513e:	5be50513          	add	a0,a0,1470 # 800086f8 <etext+0x6f8>
    80005142:	ffffb097          	auipc	ra,0xffffb
    80005146:	3fa080e7          	jalr	1018(ra) # 8000053c <panic>
    return -1;
    8000514a:	557d                	li	a0,-1
}
    8000514c:	8082                	ret
      return -1;
    8000514e:	557d                	li	a0,-1
    80005150:	bfc9                	j	80005122 <filewrite+0xf8>
    80005152:	557d                	li	a0,-1
    80005154:	b7f9                	j	80005122 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80005156:	557d                	li	a0,-1
    80005158:	b7e9                	j	80005122 <filewrite+0xf8>

000000008000515a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000515a:	7179                	add	sp,sp,-48
    8000515c:	f406                	sd	ra,40(sp)
    8000515e:	f022                	sd	s0,32(sp)
    80005160:	ec26                	sd	s1,24(sp)
    80005162:	e84a                	sd	s2,16(sp)
    80005164:	e44e                	sd	s3,8(sp)
    80005166:	e052                	sd	s4,0(sp)
    80005168:	1800                	add	s0,sp,48
    8000516a:	84aa                	mv	s1,a0
    8000516c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000516e:	0005b023          	sd	zero,0(a1)
    80005172:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80005176:	00000097          	auipc	ra,0x0
    8000517a:	bfc080e7          	jalr	-1028(ra) # 80004d72 <filealloc>
    8000517e:	e088                	sd	a0,0(s1)
    80005180:	c551                	beqz	a0,8000520c <pipealloc+0xb2>
    80005182:	00000097          	auipc	ra,0x0
    80005186:	bf0080e7          	jalr	-1040(ra) # 80004d72 <filealloc>
    8000518a:	00aa3023          	sd	a0,0(s4)
    8000518e:	c92d                	beqz	a0,80005200 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80005190:	ffffc097          	auipc	ra,0xffffc
    80005194:	9ee080e7          	jalr	-1554(ra) # 80000b7e <kalloc>
    80005198:	892a                	mv	s2,a0
    8000519a:	c125                	beqz	a0,800051fa <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000519c:	4985                	li	s3,1
    8000519e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800051a2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800051a6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800051aa:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800051ae:	00003597          	auipc	a1,0x3
    800051b2:	55a58593          	add	a1,a1,1370 # 80008708 <etext+0x708>
    800051b6:	ffffc097          	auipc	ra,0xffffc
    800051ba:	a8a080e7          	jalr	-1398(ra) # 80000c40 <initlock>
  (*f0)->type = FD_PIPE;
    800051be:	609c                	ld	a5,0(s1)
    800051c0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800051c4:	609c                	ld	a5,0(s1)
    800051c6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800051ca:	609c                	ld	a5,0(s1)
    800051cc:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800051d0:	609c                	ld	a5,0(s1)
    800051d2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800051d6:	000a3783          	ld	a5,0(s4)
    800051da:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800051de:	000a3783          	ld	a5,0(s4)
    800051e2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800051e6:	000a3783          	ld	a5,0(s4)
    800051ea:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800051ee:	000a3783          	ld	a5,0(s4)
    800051f2:	0127b823          	sd	s2,16(a5)
  return 0;
    800051f6:	4501                	li	a0,0
    800051f8:	a025                	j	80005220 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800051fa:	6088                	ld	a0,0(s1)
    800051fc:	e501                	bnez	a0,80005204 <pipealloc+0xaa>
    800051fe:	a039                	j	8000520c <pipealloc+0xb2>
    80005200:	6088                	ld	a0,0(s1)
    80005202:	c51d                	beqz	a0,80005230 <pipealloc+0xd6>
    fileclose(*f0);
    80005204:	00000097          	auipc	ra,0x0
    80005208:	c2a080e7          	jalr	-982(ra) # 80004e2e <fileclose>
  if(*f1)
    8000520c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80005210:	557d                	li	a0,-1
  if(*f1)
    80005212:	c799                	beqz	a5,80005220 <pipealloc+0xc6>
    fileclose(*f1);
    80005214:	853e                	mv	a0,a5
    80005216:	00000097          	auipc	ra,0x0
    8000521a:	c18080e7          	jalr	-1000(ra) # 80004e2e <fileclose>
  return -1;
    8000521e:	557d                	li	a0,-1
}
    80005220:	70a2                	ld	ra,40(sp)
    80005222:	7402                	ld	s0,32(sp)
    80005224:	64e2                	ld	s1,24(sp)
    80005226:	6942                	ld	s2,16(sp)
    80005228:	69a2                	ld	s3,8(sp)
    8000522a:	6a02                	ld	s4,0(sp)
    8000522c:	6145                	add	sp,sp,48
    8000522e:	8082                	ret
  return -1;
    80005230:	557d                	li	a0,-1
    80005232:	b7fd                	j	80005220 <pipealloc+0xc6>

0000000080005234 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005234:	1101                	add	sp,sp,-32
    80005236:	ec06                	sd	ra,24(sp)
    80005238:	e822                	sd	s0,16(sp)
    8000523a:	e426                	sd	s1,8(sp)
    8000523c:	e04a                	sd	s2,0(sp)
    8000523e:	1000                	add	s0,sp,32
    80005240:	84aa                	mv	s1,a0
    80005242:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005244:	ffffc097          	auipc	ra,0xffffc
    80005248:	a8c080e7          	jalr	-1396(ra) # 80000cd0 <acquire>
  if(writable){
    8000524c:	02090d63          	beqz	s2,80005286 <pipeclose+0x52>
    pi->writeopen = 0;
    80005250:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005254:	21848513          	add	a0,s1,536
    80005258:	ffffd097          	auipc	ra,0xffffd
    8000525c:	2d4080e7          	jalr	724(ra) # 8000252c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80005260:	2204b783          	ld	a5,544(s1)
    80005264:	eb95                	bnez	a5,80005298 <pipeclose+0x64>
    release(&pi->lock);
    80005266:	8526                	mv	a0,s1
    80005268:	ffffc097          	auipc	ra,0xffffc
    8000526c:	b1c080e7          	jalr	-1252(ra) # 80000d84 <release>
    kfree((char*)pi);
    80005270:	8526                	mv	a0,s1
    80005272:	ffffb097          	auipc	ra,0xffffb
    80005276:	772080e7          	jalr	1906(ra) # 800009e4 <kfree>
  } else
    release(&pi->lock);
}
    8000527a:	60e2                	ld	ra,24(sp)
    8000527c:	6442                	ld	s0,16(sp)
    8000527e:	64a2                	ld	s1,8(sp)
    80005280:	6902                	ld	s2,0(sp)
    80005282:	6105                	add	sp,sp,32
    80005284:	8082                	ret
    pi->readopen = 0;
    80005286:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000528a:	21c48513          	add	a0,s1,540
    8000528e:	ffffd097          	auipc	ra,0xffffd
    80005292:	29e080e7          	jalr	670(ra) # 8000252c <wakeup>
    80005296:	b7e9                	j	80005260 <pipeclose+0x2c>
    release(&pi->lock);
    80005298:	8526                	mv	a0,s1
    8000529a:	ffffc097          	auipc	ra,0xffffc
    8000529e:	aea080e7          	jalr	-1302(ra) # 80000d84 <release>
}
    800052a2:	bfe1                	j	8000527a <pipeclose+0x46>

00000000800052a4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800052a4:	711d                	add	sp,sp,-96
    800052a6:	ec86                	sd	ra,88(sp)
    800052a8:	e8a2                	sd	s0,80(sp)
    800052aa:	e4a6                	sd	s1,72(sp)
    800052ac:	e0ca                	sd	s2,64(sp)
    800052ae:	fc4e                	sd	s3,56(sp)
    800052b0:	f852                	sd	s4,48(sp)
    800052b2:	f456                	sd	s5,40(sp)
    800052b4:	f05a                	sd	s6,32(sp)
    800052b6:	ec5e                	sd	s7,24(sp)
    800052b8:	e862                	sd	s8,16(sp)
    800052ba:	1080                	add	s0,sp,96
    800052bc:	84aa                	mv	s1,a0
    800052be:	8aae                	mv	s5,a1
    800052c0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800052c2:	ffffd097          	auipc	ra,0xffffd
    800052c6:	aee080e7          	jalr	-1298(ra) # 80001db0 <myproc>
    800052ca:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800052cc:	8526                	mv	a0,s1
    800052ce:	ffffc097          	auipc	ra,0xffffc
    800052d2:	a02080e7          	jalr	-1534(ra) # 80000cd0 <acquire>
  while(i < n){
    800052d6:	0b405663          	blez	s4,80005382 <pipewrite+0xde>
  int i = 0;
    800052da:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800052dc:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800052de:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800052e2:	21c48b93          	add	s7,s1,540
    800052e6:	a089                	j	80005328 <pipewrite+0x84>
      release(&pi->lock);
    800052e8:	8526                	mv	a0,s1
    800052ea:	ffffc097          	auipc	ra,0xffffc
    800052ee:	a9a080e7          	jalr	-1382(ra) # 80000d84 <release>
      return -1;
    800052f2:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800052f4:	854a                	mv	a0,s2
    800052f6:	60e6                	ld	ra,88(sp)
    800052f8:	6446                	ld	s0,80(sp)
    800052fa:	64a6                	ld	s1,72(sp)
    800052fc:	6906                	ld	s2,64(sp)
    800052fe:	79e2                	ld	s3,56(sp)
    80005300:	7a42                	ld	s4,48(sp)
    80005302:	7aa2                	ld	s5,40(sp)
    80005304:	7b02                	ld	s6,32(sp)
    80005306:	6be2                	ld	s7,24(sp)
    80005308:	6c42                	ld	s8,16(sp)
    8000530a:	6125                	add	sp,sp,96
    8000530c:	8082                	ret
      wakeup(&pi->nread);
    8000530e:	8562                	mv	a0,s8
    80005310:	ffffd097          	auipc	ra,0xffffd
    80005314:	21c080e7          	jalr	540(ra) # 8000252c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80005318:	85a6                	mv	a1,s1
    8000531a:	855e                	mv	a0,s7
    8000531c:	ffffd097          	auipc	ra,0xffffd
    80005320:	3de080e7          	jalr	990(ra) # 800026fa <sleep>
  while(i < n){
    80005324:	07495063          	bge	s2,s4,80005384 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80005328:	2204a783          	lw	a5,544(s1)
    8000532c:	dfd5                	beqz	a5,800052e8 <pipewrite+0x44>
    8000532e:	854e                	mv	a0,s3
    80005330:	ffffd097          	auipc	ra,0xffffd
    80005334:	4e0080e7          	jalr	1248(ra) # 80002810 <killed>
    80005338:	f945                	bnez	a0,800052e8 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000533a:	2184a783          	lw	a5,536(s1)
    8000533e:	21c4a703          	lw	a4,540(s1)
    80005342:	2007879b          	addw	a5,a5,512
    80005346:	fcf704e3          	beq	a4,a5,8000530e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000534a:	4685                	li	a3,1
    8000534c:	01590633          	add	a2,s2,s5
    80005350:	faf40593          	add	a1,s0,-81
    80005354:	0509b503          	ld	a0,80(s3)
    80005358:	ffffc097          	auipc	ra,0xffffc
    8000535c:	616080e7          	jalr	1558(ra) # 8000196e <copyin>
    80005360:	03650263          	beq	a0,s6,80005384 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005364:	21c4a783          	lw	a5,540(s1)
    80005368:	0017871b          	addw	a4,a5,1
    8000536c:	20e4ae23          	sw	a4,540(s1)
    80005370:	1ff7f793          	and	a5,a5,511
    80005374:	97a6                	add	a5,a5,s1
    80005376:	faf44703          	lbu	a4,-81(s0)
    8000537a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000537e:	2905                	addw	s2,s2,1
    80005380:	b755                	j	80005324 <pipewrite+0x80>
  int i = 0;
    80005382:	4901                	li	s2,0
  wakeup(&pi->nread);
    80005384:	21848513          	add	a0,s1,536
    80005388:	ffffd097          	auipc	ra,0xffffd
    8000538c:	1a4080e7          	jalr	420(ra) # 8000252c <wakeup>
  release(&pi->lock);
    80005390:	8526                	mv	a0,s1
    80005392:	ffffc097          	auipc	ra,0xffffc
    80005396:	9f2080e7          	jalr	-1550(ra) # 80000d84 <release>
  return i;
    8000539a:	bfa9                	j	800052f4 <pipewrite+0x50>

000000008000539c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000539c:	715d                	add	sp,sp,-80
    8000539e:	e486                	sd	ra,72(sp)
    800053a0:	e0a2                	sd	s0,64(sp)
    800053a2:	fc26                	sd	s1,56(sp)
    800053a4:	f84a                	sd	s2,48(sp)
    800053a6:	f44e                	sd	s3,40(sp)
    800053a8:	f052                	sd	s4,32(sp)
    800053aa:	ec56                	sd	s5,24(sp)
    800053ac:	e85a                	sd	s6,16(sp)
    800053ae:	0880                	add	s0,sp,80
    800053b0:	84aa                	mv	s1,a0
    800053b2:	892e                	mv	s2,a1
    800053b4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800053b6:	ffffd097          	auipc	ra,0xffffd
    800053ba:	9fa080e7          	jalr	-1542(ra) # 80001db0 <myproc>
    800053be:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800053c0:	8526                	mv	a0,s1
    800053c2:	ffffc097          	auipc	ra,0xffffc
    800053c6:	90e080e7          	jalr	-1778(ra) # 80000cd0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800053ca:	2184a703          	lw	a4,536(s1)
    800053ce:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800053d2:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800053d6:	02f71763          	bne	a4,a5,80005404 <piperead+0x68>
    800053da:	2244a783          	lw	a5,548(s1)
    800053de:	c39d                	beqz	a5,80005404 <piperead+0x68>
    if(killed(pr)){
    800053e0:	8552                	mv	a0,s4
    800053e2:	ffffd097          	auipc	ra,0xffffd
    800053e6:	42e080e7          	jalr	1070(ra) # 80002810 <killed>
    800053ea:	e949                	bnez	a0,8000547c <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800053ec:	85a6                	mv	a1,s1
    800053ee:	854e                	mv	a0,s3
    800053f0:	ffffd097          	auipc	ra,0xffffd
    800053f4:	30a080e7          	jalr	778(ra) # 800026fa <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800053f8:	2184a703          	lw	a4,536(s1)
    800053fc:	21c4a783          	lw	a5,540(s1)
    80005400:	fcf70de3          	beq	a4,a5,800053da <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005404:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005406:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005408:	05505463          	blez	s5,80005450 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    8000540c:	2184a783          	lw	a5,536(s1)
    80005410:	21c4a703          	lw	a4,540(s1)
    80005414:	02f70e63          	beq	a4,a5,80005450 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005418:	0017871b          	addw	a4,a5,1
    8000541c:	20e4ac23          	sw	a4,536(s1)
    80005420:	1ff7f793          	and	a5,a5,511
    80005424:	97a6                	add	a5,a5,s1
    80005426:	0187c783          	lbu	a5,24(a5)
    8000542a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000542e:	4685                	li	a3,1
    80005430:	fbf40613          	add	a2,s0,-65
    80005434:	85ca                	mv	a1,s2
    80005436:	050a3503          	ld	a0,80(s4)
    8000543a:	ffffc097          	auipc	ra,0xffffc
    8000543e:	46e080e7          	jalr	1134(ra) # 800018a8 <copyout>
    80005442:	01650763          	beq	a0,s6,80005450 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005446:	2985                	addw	s3,s3,1
    80005448:	0905                	add	s2,s2,1
    8000544a:	fd3a91e3          	bne	s5,s3,8000540c <piperead+0x70>
    8000544e:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005450:	21c48513          	add	a0,s1,540
    80005454:	ffffd097          	auipc	ra,0xffffd
    80005458:	0d8080e7          	jalr	216(ra) # 8000252c <wakeup>
  release(&pi->lock);
    8000545c:	8526                	mv	a0,s1
    8000545e:	ffffc097          	auipc	ra,0xffffc
    80005462:	926080e7          	jalr	-1754(ra) # 80000d84 <release>
  return i;
}
    80005466:	854e                	mv	a0,s3
    80005468:	60a6                	ld	ra,72(sp)
    8000546a:	6406                	ld	s0,64(sp)
    8000546c:	74e2                	ld	s1,56(sp)
    8000546e:	7942                	ld	s2,48(sp)
    80005470:	79a2                	ld	s3,40(sp)
    80005472:	7a02                	ld	s4,32(sp)
    80005474:	6ae2                	ld	s5,24(sp)
    80005476:	6b42                	ld	s6,16(sp)
    80005478:	6161                	add	sp,sp,80
    8000547a:	8082                	ret
      release(&pi->lock);
    8000547c:	8526                	mv	a0,s1
    8000547e:	ffffc097          	auipc	ra,0xffffc
    80005482:	906080e7          	jalr	-1786(ra) # 80000d84 <release>
      return -1;
    80005486:	59fd                	li	s3,-1
    80005488:	bff9                	j	80005466 <piperead+0xca>

000000008000548a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000548a:	1141                	add	sp,sp,-16
    8000548c:	e422                	sd	s0,8(sp)
    8000548e:	0800                	add	s0,sp,16
    80005490:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005492:	8905                	and	a0,a0,1
    80005494:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80005496:	8b89                	and	a5,a5,2
    80005498:	c399                	beqz	a5,8000549e <flags2perm+0x14>
      perm |= PTE_W;
    8000549a:	00456513          	or	a0,a0,4
    return perm;
}
    8000549e:	6422                	ld	s0,8(sp)
    800054a0:	0141                	add	sp,sp,16
    800054a2:	8082                	ret

00000000800054a4 <exec>:

int
exec(char *path, char **argv)
{
    800054a4:	df010113          	add	sp,sp,-528
    800054a8:	20113423          	sd	ra,520(sp)
    800054ac:	20813023          	sd	s0,512(sp)
    800054b0:	ffa6                	sd	s1,504(sp)
    800054b2:	fbca                	sd	s2,496(sp)
    800054b4:	f7ce                	sd	s3,488(sp)
    800054b6:	f3d2                	sd	s4,480(sp)
    800054b8:	efd6                	sd	s5,472(sp)
    800054ba:	ebda                	sd	s6,464(sp)
    800054bc:	e7de                	sd	s7,456(sp)
    800054be:	e3e2                	sd	s8,448(sp)
    800054c0:	ff66                	sd	s9,440(sp)
    800054c2:	fb6a                	sd	s10,432(sp)
    800054c4:	f76e                	sd	s11,424(sp)
    800054c6:	0c00                	add	s0,sp,528
    800054c8:	892a                	mv	s2,a0
    800054ca:	dea43c23          	sd	a0,-520(s0)
    800054ce:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800054d2:	ffffd097          	auipc	ra,0xffffd
    800054d6:	8de080e7          	jalr	-1826(ra) # 80001db0 <myproc>
    800054da:	84aa                	mv	s1,a0

  begin_op();
    800054dc:	fffff097          	auipc	ra,0xfffff
    800054e0:	48e080e7          	jalr	1166(ra) # 8000496a <begin_op>

  if((ip = namei(path)) == 0){
    800054e4:	854a                	mv	a0,s2
    800054e6:	fffff097          	auipc	ra,0xfffff
    800054ea:	284080e7          	jalr	644(ra) # 8000476a <namei>
    800054ee:	c92d                	beqz	a0,80005560 <exec+0xbc>
    800054f0:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800054f2:	fffff097          	auipc	ra,0xfffff
    800054f6:	ad2080e7          	jalr	-1326(ra) # 80003fc4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800054fa:	04000713          	li	a4,64
    800054fe:	4681                	li	a3,0
    80005500:	e5040613          	add	a2,s0,-432
    80005504:	4581                	li	a1,0
    80005506:	8552                	mv	a0,s4
    80005508:	fffff097          	auipc	ra,0xfffff
    8000550c:	d70080e7          	jalr	-656(ra) # 80004278 <readi>
    80005510:	04000793          	li	a5,64
    80005514:	00f51a63          	bne	a0,a5,80005528 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005518:	e5042703          	lw	a4,-432(s0)
    8000551c:	464c47b7          	lui	a5,0x464c4
    80005520:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005524:	04f70463          	beq	a4,a5,8000556c <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005528:	8552                	mv	a0,s4
    8000552a:	fffff097          	auipc	ra,0xfffff
    8000552e:	cfc080e7          	jalr	-772(ra) # 80004226 <iunlockput>
    end_op();
    80005532:	fffff097          	auipc	ra,0xfffff
    80005536:	4b2080e7          	jalr	1202(ra) # 800049e4 <end_op>
  }
  return -1;
    8000553a:	557d                	li	a0,-1
}
    8000553c:	20813083          	ld	ra,520(sp)
    80005540:	20013403          	ld	s0,512(sp)
    80005544:	74fe                	ld	s1,504(sp)
    80005546:	795e                	ld	s2,496(sp)
    80005548:	79be                	ld	s3,488(sp)
    8000554a:	7a1e                	ld	s4,480(sp)
    8000554c:	6afe                	ld	s5,472(sp)
    8000554e:	6b5e                	ld	s6,464(sp)
    80005550:	6bbe                	ld	s7,456(sp)
    80005552:	6c1e                	ld	s8,448(sp)
    80005554:	7cfa                	ld	s9,440(sp)
    80005556:	7d5a                	ld	s10,432(sp)
    80005558:	7dba                	ld	s11,424(sp)
    8000555a:	21010113          	add	sp,sp,528
    8000555e:	8082                	ret
    end_op();
    80005560:	fffff097          	auipc	ra,0xfffff
    80005564:	484080e7          	jalr	1156(ra) # 800049e4 <end_op>
    return -1;
    80005568:	557d                	li	a0,-1
    8000556a:	bfc9                	j	8000553c <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000556c:	8526                	mv	a0,s1
    8000556e:	ffffd097          	auipc	ra,0xffffd
    80005572:	906080e7          	jalr	-1786(ra) # 80001e74 <proc_pagetable>
    80005576:	8b2a                	mv	s6,a0
    80005578:	d945                	beqz	a0,80005528 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000557a:	e7042d03          	lw	s10,-400(s0)
    8000557e:	e8845783          	lhu	a5,-376(s0)
    80005582:	10078463          	beqz	a5,8000568a <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005586:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005588:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    8000558a:	6c85                	lui	s9,0x1
    8000558c:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    80005590:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80005594:	6a85                	lui	s5,0x1
    80005596:	a0b5                	j	80005602 <exec+0x15e>
      panic("loadseg: address should exist");
    80005598:	00003517          	auipc	a0,0x3
    8000559c:	17850513          	add	a0,a0,376 # 80008710 <etext+0x710>
    800055a0:	ffffb097          	auipc	ra,0xffffb
    800055a4:	f9c080e7          	jalr	-100(ra) # 8000053c <panic>
    if(sz - i < PGSIZE)
    800055a8:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800055aa:	8726                	mv	a4,s1
    800055ac:	012c06bb          	addw	a3,s8,s2
    800055b0:	4581                	li	a1,0
    800055b2:	8552                	mv	a0,s4
    800055b4:	fffff097          	auipc	ra,0xfffff
    800055b8:	cc4080e7          	jalr	-828(ra) # 80004278 <readi>
    800055bc:	2501                	sext.w	a0,a0
    800055be:	24a49863          	bne	s1,a0,8000580e <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    800055c2:	012a893b          	addw	s2,s5,s2
    800055c6:	03397563          	bgeu	s2,s3,800055f0 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    800055ca:	02091593          	sll	a1,s2,0x20
    800055ce:	9181                	srl	a1,a1,0x20
    800055d0:	95de                	add	a1,a1,s7
    800055d2:	855a                	mv	a0,s6
    800055d4:	ffffc097          	auipc	ra,0xffffc
    800055d8:	b80080e7          	jalr	-1152(ra) # 80001154 <walkaddr>
    800055dc:	862a                	mv	a2,a0
    if(pa == 0)
    800055de:	dd4d                	beqz	a0,80005598 <exec+0xf4>
    if(sz - i < PGSIZE)
    800055e0:	412984bb          	subw	s1,s3,s2
    800055e4:	0004879b          	sext.w	a5,s1
    800055e8:	fcfcf0e3          	bgeu	s9,a5,800055a8 <exec+0x104>
    800055ec:	84d6                	mv	s1,s5
    800055ee:	bf6d                	j	800055a8 <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800055f0:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800055f4:	2d85                	addw	s11,s11,1
    800055f6:	038d0d1b          	addw	s10,s10,56
    800055fa:	e8845783          	lhu	a5,-376(s0)
    800055fe:	08fdd763          	bge	s11,a5,8000568c <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005602:	2d01                	sext.w	s10,s10
    80005604:	03800713          	li	a4,56
    80005608:	86ea                	mv	a3,s10
    8000560a:	e1840613          	add	a2,s0,-488
    8000560e:	4581                	li	a1,0
    80005610:	8552                	mv	a0,s4
    80005612:	fffff097          	auipc	ra,0xfffff
    80005616:	c66080e7          	jalr	-922(ra) # 80004278 <readi>
    8000561a:	03800793          	li	a5,56
    8000561e:	1ef51663          	bne	a0,a5,8000580a <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    80005622:	e1842783          	lw	a5,-488(s0)
    80005626:	4705                	li	a4,1
    80005628:	fce796e3          	bne	a5,a4,800055f4 <exec+0x150>
    if(ph.memsz < ph.filesz)
    8000562c:	e4043483          	ld	s1,-448(s0)
    80005630:	e3843783          	ld	a5,-456(s0)
    80005634:	1ef4e863          	bltu	s1,a5,80005824 <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005638:	e2843783          	ld	a5,-472(s0)
    8000563c:	94be                	add	s1,s1,a5
    8000563e:	1ef4e663          	bltu	s1,a5,8000582a <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    80005642:	df043703          	ld	a4,-528(s0)
    80005646:	8ff9                	and	a5,a5,a4
    80005648:	1e079463          	bnez	a5,80005830 <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000564c:	e1c42503          	lw	a0,-484(s0)
    80005650:	00000097          	auipc	ra,0x0
    80005654:	e3a080e7          	jalr	-454(ra) # 8000548a <flags2perm>
    80005658:	86aa                	mv	a3,a0
    8000565a:	8626                	mv	a2,s1
    8000565c:	85ca                	mv	a1,s2
    8000565e:	855a                	mv	a0,s6
    80005660:	ffffc097          	auipc	ra,0xffffc
    80005664:	ea8080e7          	jalr	-344(ra) # 80001508 <uvmalloc>
    80005668:	e0a43423          	sd	a0,-504(s0)
    8000566c:	1c050563          	beqz	a0,80005836 <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005670:	e2843b83          	ld	s7,-472(s0)
    80005674:	e2042c03          	lw	s8,-480(s0)
    80005678:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000567c:	00098463          	beqz	s3,80005684 <exec+0x1e0>
    80005680:	4901                	li	s2,0
    80005682:	b7a1                	j	800055ca <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005684:	e0843903          	ld	s2,-504(s0)
    80005688:	b7b5                	j	800055f4 <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000568a:	4901                	li	s2,0
  iunlockput(ip);
    8000568c:	8552                	mv	a0,s4
    8000568e:	fffff097          	auipc	ra,0xfffff
    80005692:	b98080e7          	jalr	-1128(ra) # 80004226 <iunlockput>
  end_op();
    80005696:	fffff097          	auipc	ra,0xfffff
    8000569a:	34e080e7          	jalr	846(ra) # 800049e4 <end_op>
  p = myproc();
    8000569e:	ffffc097          	auipc	ra,0xffffc
    800056a2:	712080e7          	jalr	1810(ra) # 80001db0 <myproc>
    800056a6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800056a8:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800056ac:	6985                	lui	s3,0x1
    800056ae:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    800056b0:	99ca                	add	s3,s3,s2
    800056b2:	77fd                	lui	a5,0xfffff
    800056b4:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800056b8:	4691                	li	a3,4
    800056ba:	6609                	lui	a2,0x2
    800056bc:	964e                	add	a2,a2,s3
    800056be:	85ce                	mv	a1,s3
    800056c0:	855a                	mv	a0,s6
    800056c2:	ffffc097          	auipc	ra,0xffffc
    800056c6:	e46080e7          	jalr	-442(ra) # 80001508 <uvmalloc>
    800056ca:	892a                	mv	s2,a0
    800056cc:	e0a43423          	sd	a0,-504(s0)
    800056d0:	e509                	bnez	a0,800056da <exec+0x236>
  if(pagetable)
    800056d2:	e1343423          	sd	s3,-504(s0)
    800056d6:	4a01                	li	s4,0
    800056d8:	aa1d                	j	8000580e <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    800056da:	75f9                	lui	a1,0xffffe
    800056dc:	95aa                	add	a1,a1,a0
    800056de:	855a                	mv	a0,s6
    800056e0:	ffffc097          	auipc	ra,0xffffc
    800056e4:	196080e7          	jalr	406(ra) # 80001876 <uvmclear>
  stackbase = sp - PGSIZE;
    800056e8:	7bfd                	lui	s7,0xfffff
    800056ea:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800056ec:	e0043783          	ld	a5,-512(s0)
    800056f0:	6388                	ld	a0,0(a5)
    800056f2:	c52d                	beqz	a0,8000575c <exec+0x2b8>
    800056f4:	e9040993          	add	s3,s0,-368
    800056f8:	f9040c13          	add	s8,s0,-112
    800056fc:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800056fe:	ffffc097          	auipc	ra,0xffffc
    80005702:	848080e7          	jalr	-1976(ra) # 80000f46 <strlen>
    80005706:	0015079b          	addw	a5,a0,1
    8000570a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000570e:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    80005712:	13796563          	bltu	s2,s7,8000583c <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005716:	e0043d03          	ld	s10,-512(s0)
    8000571a:	000d3a03          	ld	s4,0(s10)
    8000571e:	8552                	mv	a0,s4
    80005720:	ffffc097          	auipc	ra,0xffffc
    80005724:	826080e7          	jalr	-2010(ra) # 80000f46 <strlen>
    80005728:	0015069b          	addw	a3,a0,1
    8000572c:	8652                	mv	a2,s4
    8000572e:	85ca                	mv	a1,s2
    80005730:	855a                	mv	a0,s6
    80005732:	ffffc097          	auipc	ra,0xffffc
    80005736:	176080e7          	jalr	374(ra) # 800018a8 <copyout>
    8000573a:	10054363          	bltz	a0,80005840 <exec+0x39c>
    ustack[argc] = sp;
    8000573e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005742:	0485                	add	s1,s1,1
    80005744:	008d0793          	add	a5,s10,8
    80005748:	e0f43023          	sd	a5,-512(s0)
    8000574c:	008d3503          	ld	a0,8(s10)
    80005750:	c909                	beqz	a0,80005762 <exec+0x2be>
    if(argc >= MAXARG)
    80005752:	09a1                	add	s3,s3,8
    80005754:	fb8995e3          	bne	s3,s8,800056fe <exec+0x25a>
  ip = 0;
    80005758:	4a01                	li	s4,0
    8000575a:	a855                	j	8000580e <exec+0x36a>
  sp = sz;
    8000575c:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80005760:	4481                	li	s1,0
  ustack[argc] = 0;
    80005762:	00349793          	sll	a5,s1,0x3
    80005766:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7fdbb4b8>
    8000576a:	97a2                	add	a5,a5,s0
    8000576c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005770:	00148693          	add	a3,s1,1
    80005774:	068e                	sll	a3,a3,0x3
    80005776:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000577a:	ff097913          	and	s2,s2,-16
  sz = sz1;
    8000577e:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80005782:	f57968e3          	bltu	s2,s7,800056d2 <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005786:	e9040613          	add	a2,s0,-368
    8000578a:	85ca                	mv	a1,s2
    8000578c:	855a                	mv	a0,s6
    8000578e:	ffffc097          	auipc	ra,0xffffc
    80005792:	11a080e7          	jalr	282(ra) # 800018a8 <copyout>
    80005796:	0a054763          	bltz	a0,80005844 <exec+0x3a0>
  p->trapframe->a1 = sp;
    8000579a:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000579e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800057a2:	df843783          	ld	a5,-520(s0)
    800057a6:	0007c703          	lbu	a4,0(a5)
    800057aa:	cf11                	beqz	a4,800057c6 <exec+0x322>
    800057ac:	0785                	add	a5,a5,1
    if(*s == '/')
    800057ae:	02f00693          	li	a3,47
    800057b2:	a039                	j	800057c0 <exec+0x31c>
      last = s+1;
    800057b4:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800057b8:	0785                	add	a5,a5,1
    800057ba:	fff7c703          	lbu	a4,-1(a5)
    800057be:	c701                	beqz	a4,800057c6 <exec+0x322>
    if(*s == '/')
    800057c0:	fed71ce3          	bne	a4,a3,800057b8 <exec+0x314>
    800057c4:	bfc5                	j	800057b4 <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    800057c6:	4641                	li	a2,16
    800057c8:	df843583          	ld	a1,-520(s0)
    800057cc:	158a8513          	add	a0,s5,344
    800057d0:	ffffb097          	auipc	ra,0xffffb
    800057d4:	744080e7          	jalr	1860(ra) # 80000f14 <safestrcpy>
  oldpagetable = p->pagetable;
    800057d8:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800057dc:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800057e0:	e0843783          	ld	a5,-504(s0)
    800057e4:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800057e8:	058ab783          	ld	a5,88(s5)
    800057ec:	e6843703          	ld	a4,-408(s0)
    800057f0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800057f2:	058ab783          	ld	a5,88(s5)
    800057f6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800057fa:	85e6                	mv	a1,s9
    800057fc:	ffffc097          	auipc	ra,0xffffc
    80005800:	714080e7          	jalr	1812(ra) # 80001f10 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005804:	0004851b          	sext.w	a0,s1
    80005808:	bb15                	j	8000553c <exec+0x98>
    8000580a:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000580e:	e0843583          	ld	a1,-504(s0)
    80005812:	855a                	mv	a0,s6
    80005814:	ffffc097          	auipc	ra,0xffffc
    80005818:	6fc080e7          	jalr	1788(ra) # 80001f10 <proc_freepagetable>
  return -1;
    8000581c:	557d                	li	a0,-1
  if(ip){
    8000581e:	d00a0fe3          	beqz	s4,8000553c <exec+0x98>
    80005822:	b319                	j	80005528 <exec+0x84>
    80005824:	e1243423          	sd	s2,-504(s0)
    80005828:	b7dd                	j	8000580e <exec+0x36a>
    8000582a:	e1243423          	sd	s2,-504(s0)
    8000582e:	b7c5                	j	8000580e <exec+0x36a>
    80005830:	e1243423          	sd	s2,-504(s0)
    80005834:	bfe9                	j	8000580e <exec+0x36a>
    80005836:	e1243423          	sd	s2,-504(s0)
    8000583a:	bfd1                	j	8000580e <exec+0x36a>
  ip = 0;
    8000583c:	4a01                	li	s4,0
    8000583e:	bfc1                	j	8000580e <exec+0x36a>
    80005840:	4a01                	li	s4,0
  if(pagetable)
    80005842:	b7f1                	j	8000580e <exec+0x36a>
  sz = sz1;
    80005844:	e0843983          	ld	s3,-504(s0)
    80005848:	b569                	j	800056d2 <exec+0x22e>

000000008000584a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000584a:	7179                	add	sp,sp,-48
    8000584c:	f406                	sd	ra,40(sp)
    8000584e:	f022                	sd	s0,32(sp)
    80005850:	ec26                	sd	s1,24(sp)
    80005852:	e84a                	sd	s2,16(sp)
    80005854:	1800                	add	s0,sp,48
    80005856:	892e                	mv	s2,a1
    80005858:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000585a:	fdc40593          	add	a1,s0,-36
    8000585e:	ffffe097          	auipc	ra,0xffffe
    80005862:	a28080e7          	jalr	-1496(ra) # 80003286 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005866:	fdc42703          	lw	a4,-36(s0)
    8000586a:	47bd                	li	a5,15
    8000586c:	02e7eb63          	bltu	a5,a4,800058a2 <argfd+0x58>
    80005870:	ffffc097          	auipc	ra,0xffffc
    80005874:	540080e7          	jalr	1344(ra) # 80001db0 <myproc>
    80005878:	fdc42703          	lw	a4,-36(s0)
    8000587c:	01a70793          	add	a5,a4,26
    80005880:	078e                	sll	a5,a5,0x3
    80005882:	953e                	add	a0,a0,a5
    80005884:	611c                	ld	a5,0(a0)
    80005886:	c385                	beqz	a5,800058a6 <argfd+0x5c>
    return -1;
  if(pfd)
    80005888:	00090463          	beqz	s2,80005890 <argfd+0x46>
    *pfd = fd;
    8000588c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005890:	4501                	li	a0,0
  if(pf)
    80005892:	c091                	beqz	s1,80005896 <argfd+0x4c>
    *pf = f;
    80005894:	e09c                	sd	a5,0(s1)
}
    80005896:	70a2                	ld	ra,40(sp)
    80005898:	7402                	ld	s0,32(sp)
    8000589a:	64e2                	ld	s1,24(sp)
    8000589c:	6942                	ld	s2,16(sp)
    8000589e:	6145                	add	sp,sp,48
    800058a0:	8082                	ret
    return -1;
    800058a2:	557d                	li	a0,-1
    800058a4:	bfcd                	j	80005896 <argfd+0x4c>
    800058a6:	557d                	li	a0,-1
    800058a8:	b7fd                	j	80005896 <argfd+0x4c>

00000000800058aa <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800058aa:	1101                	add	sp,sp,-32
    800058ac:	ec06                	sd	ra,24(sp)
    800058ae:	e822                	sd	s0,16(sp)
    800058b0:	e426                	sd	s1,8(sp)
    800058b2:	1000                	add	s0,sp,32
    800058b4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800058b6:	ffffc097          	auipc	ra,0xffffc
    800058ba:	4fa080e7          	jalr	1274(ra) # 80001db0 <myproc>
    800058be:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800058c0:	0d050793          	add	a5,a0,208
    800058c4:	4501                	li	a0,0
    800058c6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800058c8:	6398                	ld	a4,0(a5)
    800058ca:	cb19                	beqz	a4,800058e0 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800058cc:	2505                	addw	a0,a0,1
    800058ce:	07a1                	add	a5,a5,8
    800058d0:	fed51ce3          	bne	a0,a3,800058c8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800058d4:	557d                	li	a0,-1
}
    800058d6:	60e2                	ld	ra,24(sp)
    800058d8:	6442                	ld	s0,16(sp)
    800058da:	64a2                	ld	s1,8(sp)
    800058dc:	6105                	add	sp,sp,32
    800058de:	8082                	ret
      p->ofile[fd] = f;
    800058e0:	01a50793          	add	a5,a0,26
    800058e4:	078e                	sll	a5,a5,0x3
    800058e6:	963e                	add	a2,a2,a5
    800058e8:	e204                	sd	s1,0(a2)
      return fd;
    800058ea:	b7f5                	j	800058d6 <fdalloc+0x2c>

00000000800058ec <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800058ec:	715d                	add	sp,sp,-80
    800058ee:	e486                	sd	ra,72(sp)
    800058f0:	e0a2                	sd	s0,64(sp)
    800058f2:	fc26                	sd	s1,56(sp)
    800058f4:	f84a                	sd	s2,48(sp)
    800058f6:	f44e                	sd	s3,40(sp)
    800058f8:	f052                	sd	s4,32(sp)
    800058fa:	ec56                	sd	s5,24(sp)
    800058fc:	e85a                	sd	s6,16(sp)
    800058fe:	0880                	add	s0,sp,80
    80005900:	8b2e                	mv	s6,a1
    80005902:	89b2                	mv	s3,a2
    80005904:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005906:	fb040593          	add	a1,s0,-80
    8000590a:	fffff097          	auipc	ra,0xfffff
    8000590e:	e7e080e7          	jalr	-386(ra) # 80004788 <nameiparent>
    80005912:	84aa                	mv	s1,a0
    80005914:	14050b63          	beqz	a0,80005a6a <create+0x17e>
    return 0;

  ilock(dp);
    80005918:	ffffe097          	auipc	ra,0xffffe
    8000591c:	6ac080e7          	jalr	1708(ra) # 80003fc4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005920:	4601                	li	a2,0
    80005922:	fb040593          	add	a1,s0,-80
    80005926:	8526                	mv	a0,s1
    80005928:	fffff097          	auipc	ra,0xfffff
    8000592c:	b80080e7          	jalr	-1152(ra) # 800044a8 <dirlookup>
    80005930:	8aaa                	mv	s5,a0
    80005932:	c921                	beqz	a0,80005982 <create+0x96>
    iunlockput(dp);
    80005934:	8526                	mv	a0,s1
    80005936:	fffff097          	auipc	ra,0xfffff
    8000593a:	8f0080e7          	jalr	-1808(ra) # 80004226 <iunlockput>
    ilock(ip);
    8000593e:	8556                	mv	a0,s5
    80005940:	ffffe097          	auipc	ra,0xffffe
    80005944:	684080e7          	jalr	1668(ra) # 80003fc4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005948:	4789                	li	a5,2
    8000594a:	02fb1563          	bne	s6,a5,80005974 <create+0x88>
    8000594e:	044ad783          	lhu	a5,68(s5)
    80005952:	37f9                	addw	a5,a5,-2
    80005954:	17c2                	sll	a5,a5,0x30
    80005956:	93c1                	srl	a5,a5,0x30
    80005958:	4705                	li	a4,1
    8000595a:	00f76d63          	bltu	a4,a5,80005974 <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000595e:	8556                	mv	a0,s5
    80005960:	60a6                	ld	ra,72(sp)
    80005962:	6406                	ld	s0,64(sp)
    80005964:	74e2                	ld	s1,56(sp)
    80005966:	7942                	ld	s2,48(sp)
    80005968:	79a2                	ld	s3,40(sp)
    8000596a:	7a02                	ld	s4,32(sp)
    8000596c:	6ae2                	ld	s5,24(sp)
    8000596e:	6b42                	ld	s6,16(sp)
    80005970:	6161                	add	sp,sp,80
    80005972:	8082                	ret
    iunlockput(ip);
    80005974:	8556                	mv	a0,s5
    80005976:	fffff097          	auipc	ra,0xfffff
    8000597a:	8b0080e7          	jalr	-1872(ra) # 80004226 <iunlockput>
    return 0;
    8000597e:	4a81                	li	s5,0
    80005980:	bff9                	j	8000595e <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005982:	85da                	mv	a1,s6
    80005984:	4088                	lw	a0,0(s1)
    80005986:	ffffe097          	auipc	ra,0xffffe
    8000598a:	4a6080e7          	jalr	1190(ra) # 80003e2c <ialloc>
    8000598e:	8a2a                	mv	s4,a0
    80005990:	c529                	beqz	a0,800059da <create+0xee>
  ilock(ip);
    80005992:	ffffe097          	auipc	ra,0xffffe
    80005996:	632080e7          	jalr	1586(ra) # 80003fc4 <ilock>
  ip->major = major;
    8000599a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000599e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800059a2:	4905                	li	s2,1
    800059a4:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800059a8:	8552                	mv	a0,s4
    800059aa:	ffffe097          	auipc	ra,0xffffe
    800059ae:	54e080e7          	jalr	1358(ra) # 80003ef8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800059b2:	032b0b63          	beq	s6,s2,800059e8 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800059b6:	004a2603          	lw	a2,4(s4)
    800059ba:	fb040593          	add	a1,s0,-80
    800059be:	8526                	mv	a0,s1
    800059c0:	fffff097          	auipc	ra,0xfffff
    800059c4:	cf8080e7          	jalr	-776(ra) # 800046b8 <dirlink>
    800059c8:	06054f63          	bltz	a0,80005a46 <create+0x15a>
  iunlockput(dp);
    800059cc:	8526                	mv	a0,s1
    800059ce:	fffff097          	auipc	ra,0xfffff
    800059d2:	858080e7          	jalr	-1960(ra) # 80004226 <iunlockput>
  return ip;
    800059d6:	8ad2                	mv	s5,s4
    800059d8:	b759                	j	8000595e <create+0x72>
    iunlockput(dp);
    800059da:	8526                	mv	a0,s1
    800059dc:	fffff097          	auipc	ra,0xfffff
    800059e0:	84a080e7          	jalr	-1974(ra) # 80004226 <iunlockput>
    return 0;
    800059e4:	8ad2                	mv	s5,s4
    800059e6:	bfa5                	j	8000595e <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800059e8:	004a2603          	lw	a2,4(s4)
    800059ec:	00003597          	auipc	a1,0x3
    800059f0:	d4458593          	add	a1,a1,-700 # 80008730 <etext+0x730>
    800059f4:	8552                	mv	a0,s4
    800059f6:	fffff097          	auipc	ra,0xfffff
    800059fa:	cc2080e7          	jalr	-830(ra) # 800046b8 <dirlink>
    800059fe:	04054463          	bltz	a0,80005a46 <create+0x15a>
    80005a02:	40d0                	lw	a2,4(s1)
    80005a04:	00003597          	auipc	a1,0x3
    80005a08:	d3458593          	add	a1,a1,-716 # 80008738 <etext+0x738>
    80005a0c:	8552                	mv	a0,s4
    80005a0e:	fffff097          	auipc	ra,0xfffff
    80005a12:	caa080e7          	jalr	-854(ra) # 800046b8 <dirlink>
    80005a16:	02054863          	bltz	a0,80005a46 <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    80005a1a:	004a2603          	lw	a2,4(s4)
    80005a1e:	fb040593          	add	a1,s0,-80
    80005a22:	8526                	mv	a0,s1
    80005a24:	fffff097          	auipc	ra,0xfffff
    80005a28:	c94080e7          	jalr	-876(ra) # 800046b8 <dirlink>
    80005a2c:	00054d63          	bltz	a0,80005a46 <create+0x15a>
    dp->nlink++;  // for ".."
    80005a30:	04a4d783          	lhu	a5,74(s1)
    80005a34:	2785                	addw	a5,a5,1
    80005a36:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005a3a:	8526                	mv	a0,s1
    80005a3c:	ffffe097          	auipc	ra,0xffffe
    80005a40:	4bc080e7          	jalr	1212(ra) # 80003ef8 <iupdate>
    80005a44:	b761                	j	800059cc <create+0xe0>
  ip->nlink = 0;
    80005a46:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005a4a:	8552                	mv	a0,s4
    80005a4c:	ffffe097          	auipc	ra,0xffffe
    80005a50:	4ac080e7          	jalr	1196(ra) # 80003ef8 <iupdate>
  iunlockput(ip);
    80005a54:	8552                	mv	a0,s4
    80005a56:	ffffe097          	auipc	ra,0xffffe
    80005a5a:	7d0080e7          	jalr	2000(ra) # 80004226 <iunlockput>
  iunlockput(dp);
    80005a5e:	8526                	mv	a0,s1
    80005a60:	ffffe097          	auipc	ra,0xffffe
    80005a64:	7c6080e7          	jalr	1990(ra) # 80004226 <iunlockput>
  return 0;
    80005a68:	bddd                	j	8000595e <create+0x72>
    return 0;
    80005a6a:	8aaa                	mv	s5,a0
    80005a6c:	bdcd                	j	8000595e <create+0x72>

0000000080005a6e <sys_dup>:
{
    80005a6e:	7179                	add	sp,sp,-48
    80005a70:	f406                	sd	ra,40(sp)
    80005a72:	f022                	sd	s0,32(sp)
    80005a74:	ec26                	sd	s1,24(sp)
    80005a76:	e84a                	sd	s2,16(sp)
    80005a78:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005a7a:	fd840613          	add	a2,s0,-40
    80005a7e:	4581                	li	a1,0
    80005a80:	4501                	li	a0,0
    80005a82:	00000097          	auipc	ra,0x0
    80005a86:	dc8080e7          	jalr	-568(ra) # 8000584a <argfd>
    return -1;
    80005a8a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005a8c:	02054363          	bltz	a0,80005ab2 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80005a90:	fd843903          	ld	s2,-40(s0)
    80005a94:	854a                	mv	a0,s2
    80005a96:	00000097          	auipc	ra,0x0
    80005a9a:	e14080e7          	jalr	-492(ra) # 800058aa <fdalloc>
    80005a9e:	84aa                	mv	s1,a0
    return -1;
    80005aa0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005aa2:	00054863          	bltz	a0,80005ab2 <sys_dup+0x44>
  filedup(f);
    80005aa6:	854a                	mv	a0,s2
    80005aa8:	fffff097          	auipc	ra,0xfffff
    80005aac:	334080e7          	jalr	820(ra) # 80004ddc <filedup>
  return fd;
    80005ab0:	87a6                	mv	a5,s1
}
    80005ab2:	853e                	mv	a0,a5
    80005ab4:	70a2                	ld	ra,40(sp)
    80005ab6:	7402                	ld	s0,32(sp)
    80005ab8:	64e2                	ld	s1,24(sp)
    80005aba:	6942                	ld	s2,16(sp)
    80005abc:	6145                	add	sp,sp,48
    80005abe:	8082                	ret

0000000080005ac0 <sys_getreadcount>:
{
    80005ac0:	1141                	add	sp,sp,-16
    80005ac2:	e422                	sd	s0,8(sp)
    80005ac4:	0800                	add	s0,sp,16
}
    80005ac6:	00003517          	auipc	a0,0x3
    80005aca:	f7e52503          	lw	a0,-130(a0) # 80008a44 <read_count>
    80005ace:	6422                	ld	s0,8(sp)
    80005ad0:	0141                	add	sp,sp,16
    80005ad2:	8082                	ret

0000000080005ad4 <sys_read>:
{
    80005ad4:	7179                	add	sp,sp,-48
    80005ad6:	f406                	sd	ra,40(sp)
    80005ad8:	f022                	sd	s0,32(sp)
    80005ada:	1800                	add	s0,sp,48
  read_count++;               // sys_getreadcount
    80005adc:	00003717          	auipc	a4,0x3
    80005ae0:	f6870713          	add	a4,a4,-152 # 80008a44 <read_count>
    80005ae4:	431c                	lw	a5,0(a4)
    80005ae6:	2785                	addw	a5,a5,1
    80005ae8:	c31c                	sw	a5,0(a4)
  argaddr(1, &p);
    80005aea:	fd840593          	add	a1,s0,-40
    80005aee:	4505                	li	a0,1
    80005af0:	ffffd097          	auipc	ra,0xffffd
    80005af4:	7b6080e7          	jalr	1974(ra) # 800032a6 <argaddr>
  argint(2, &n);
    80005af8:	fe440593          	add	a1,s0,-28
    80005afc:	4509                	li	a0,2
    80005afe:	ffffd097          	auipc	ra,0xffffd
    80005b02:	788080e7          	jalr	1928(ra) # 80003286 <argint>
  if(argfd(0, 0, &f) < 0)
    80005b06:	fe840613          	add	a2,s0,-24
    80005b0a:	4581                	li	a1,0
    80005b0c:	4501                	li	a0,0
    80005b0e:	00000097          	auipc	ra,0x0
    80005b12:	d3c080e7          	jalr	-708(ra) # 8000584a <argfd>
    80005b16:	87aa                	mv	a5,a0
    return -1;
    80005b18:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005b1a:	0207cc63          	bltz	a5,80005b52 <sys_read+0x7e>
  acquire(&tickslock);
    80005b1e:	00233517          	auipc	a0,0x233
    80005b22:	bda50513          	add	a0,a0,-1062 # 802386f8 <tickslock>
    80005b26:	ffffb097          	auipc	ra,0xffffb
    80005b2a:	1aa080e7          	jalr	426(ra) # 80000cd0 <acquire>
  release(&tickslock);
    80005b2e:	00233517          	auipc	a0,0x233
    80005b32:	bca50513          	add	a0,a0,-1078 # 802386f8 <tickslock>
    80005b36:	ffffb097          	auipc	ra,0xffffb
    80005b3a:	24e080e7          	jalr	590(ra) # 80000d84 <release>
  return fileread(f, p, n);
    80005b3e:	fe442603          	lw	a2,-28(s0)
    80005b42:	fd843583          	ld	a1,-40(s0)
    80005b46:	fe843503          	ld	a0,-24(s0)
    80005b4a:	fffff097          	auipc	ra,0xfffff
    80005b4e:	41e080e7          	jalr	1054(ra) # 80004f68 <fileread>
}
    80005b52:	70a2                	ld	ra,40(sp)
    80005b54:	7402                	ld	s0,32(sp)
    80005b56:	6145                	add	sp,sp,48
    80005b58:	8082                	ret

0000000080005b5a <sys_write>:
{
    80005b5a:	7179                	add	sp,sp,-48
    80005b5c:	f406                	sd	ra,40(sp)
    80005b5e:	f022                	sd	s0,32(sp)
    80005b60:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80005b62:	fd840593          	add	a1,s0,-40
    80005b66:	4505                	li	a0,1
    80005b68:	ffffd097          	auipc	ra,0xffffd
    80005b6c:	73e080e7          	jalr	1854(ra) # 800032a6 <argaddr>
  argint(2, &n);
    80005b70:	fe440593          	add	a1,s0,-28
    80005b74:	4509                	li	a0,2
    80005b76:	ffffd097          	auipc	ra,0xffffd
    80005b7a:	710080e7          	jalr	1808(ra) # 80003286 <argint>
  if(argfd(0, 0, &f) < 0)
    80005b7e:	fe840613          	add	a2,s0,-24
    80005b82:	4581                	li	a1,0
    80005b84:	4501                	li	a0,0
    80005b86:	00000097          	auipc	ra,0x0
    80005b8a:	cc4080e7          	jalr	-828(ra) # 8000584a <argfd>
    80005b8e:	87aa                	mv	a5,a0
    return -1;
    80005b90:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005b92:	0007cc63          	bltz	a5,80005baa <sys_write+0x50>
  return filewrite(f, p, n);
    80005b96:	fe442603          	lw	a2,-28(s0)
    80005b9a:	fd843583          	ld	a1,-40(s0)
    80005b9e:	fe843503          	ld	a0,-24(s0)
    80005ba2:	fffff097          	auipc	ra,0xfffff
    80005ba6:	488080e7          	jalr	1160(ra) # 8000502a <filewrite>
}
    80005baa:	70a2                	ld	ra,40(sp)
    80005bac:	7402                	ld	s0,32(sp)
    80005bae:	6145                	add	sp,sp,48
    80005bb0:	8082                	ret

0000000080005bb2 <sys_close>:
{
    80005bb2:	1101                	add	sp,sp,-32
    80005bb4:	ec06                	sd	ra,24(sp)
    80005bb6:	e822                	sd	s0,16(sp)
    80005bb8:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005bba:	fe040613          	add	a2,s0,-32
    80005bbe:	fec40593          	add	a1,s0,-20
    80005bc2:	4501                	li	a0,0
    80005bc4:	00000097          	auipc	ra,0x0
    80005bc8:	c86080e7          	jalr	-890(ra) # 8000584a <argfd>
    return -1;
    80005bcc:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005bce:	02054463          	bltz	a0,80005bf6 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005bd2:	ffffc097          	auipc	ra,0xffffc
    80005bd6:	1de080e7          	jalr	478(ra) # 80001db0 <myproc>
    80005bda:	fec42783          	lw	a5,-20(s0)
    80005bde:	07e9                	add	a5,a5,26
    80005be0:	078e                	sll	a5,a5,0x3
    80005be2:	953e                	add	a0,a0,a5
    80005be4:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005be8:	fe043503          	ld	a0,-32(s0)
    80005bec:	fffff097          	auipc	ra,0xfffff
    80005bf0:	242080e7          	jalr	578(ra) # 80004e2e <fileclose>
  return 0;
    80005bf4:	4781                	li	a5,0
}
    80005bf6:	853e                	mv	a0,a5
    80005bf8:	60e2                	ld	ra,24(sp)
    80005bfa:	6442                	ld	s0,16(sp)
    80005bfc:	6105                	add	sp,sp,32
    80005bfe:	8082                	ret

0000000080005c00 <sys_fstat>:
{
    80005c00:	1101                	add	sp,sp,-32
    80005c02:	ec06                	sd	ra,24(sp)
    80005c04:	e822                	sd	s0,16(sp)
    80005c06:	1000                	add	s0,sp,32
  argaddr(1, &st);
    80005c08:	fe040593          	add	a1,s0,-32
    80005c0c:	4505                	li	a0,1
    80005c0e:	ffffd097          	auipc	ra,0xffffd
    80005c12:	698080e7          	jalr	1688(ra) # 800032a6 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005c16:	fe840613          	add	a2,s0,-24
    80005c1a:	4581                	li	a1,0
    80005c1c:	4501                	li	a0,0
    80005c1e:	00000097          	auipc	ra,0x0
    80005c22:	c2c080e7          	jalr	-980(ra) # 8000584a <argfd>
    80005c26:	87aa                	mv	a5,a0
    return -1;
    80005c28:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005c2a:	0007ca63          	bltz	a5,80005c3e <sys_fstat+0x3e>
  return filestat(f, st);
    80005c2e:	fe043583          	ld	a1,-32(s0)
    80005c32:	fe843503          	ld	a0,-24(s0)
    80005c36:	fffff097          	auipc	ra,0xfffff
    80005c3a:	2c0080e7          	jalr	704(ra) # 80004ef6 <filestat>
}
    80005c3e:	60e2                	ld	ra,24(sp)
    80005c40:	6442                	ld	s0,16(sp)
    80005c42:	6105                	add	sp,sp,32
    80005c44:	8082                	ret

0000000080005c46 <sys_link>:
{
    80005c46:	7169                	add	sp,sp,-304
    80005c48:	f606                	sd	ra,296(sp)
    80005c4a:	f222                	sd	s0,288(sp)
    80005c4c:	ee26                	sd	s1,280(sp)
    80005c4e:	ea4a                	sd	s2,272(sp)
    80005c50:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005c52:	08000613          	li	a2,128
    80005c56:	ed040593          	add	a1,s0,-304
    80005c5a:	4501                	li	a0,0
    80005c5c:	ffffd097          	auipc	ra,0xffffd
    80005c60:	66a080e7          	jalr	1642(ra) # 800032c6 <argstr>
    return -1;
    80005c64:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005c66:	10054e63          	bltz	a0,80005d82 <sys_link+0x13c>
    80005c6a:	08000613          	li	a2,128
    80005c6e:	f5040593          	add	a1,s0,-176
    80005c72:	4505                	li	a0,1
    80005c74:	ffffd097          	auipc	ra,0xffffd
    80005c78:	652080e7          	jalr	1618(ra) # 800032c6 <argstr>
    return -1;
    80005c7c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005c7e:	10054263          	bltz	a0,80005d82 <sys_link+0x13c>
  begin_op();
    80005c82:	fffff097          	auipc	ra,0xfffff
    80005c86:	ce8080e7          	jalr	-792(ra) # 8000496a <begin_op>
  if((ip = namei(old)) == 0){
    80005c8a:	ed040513          	add	a0,s0,-304
    80005c8e:	fffff097          	auipc	ra,0xfffff
    80005c92:	adc080e7          	jalr	-1316(ra) # 8000476a <namei>
    80005c96:	84aa                	mv	s1,a0
    80005c98:	c551                	beqz	a0,80005d24 <sys_link+0xde>
  ilock(ip);
    80005c9a:	ffffe097          	auipc	ra,0xffffe
    80005c9e:	32a080e7          	jalr	810(ra) # 80003fc4 <ilock>
  if(ip->type == T_DIR){
    80005ca2:	04449703          	lh	a4,68(s1)
    80005ca6:	4785                	li	a5,1
    80005ca8:	08f70463          	beq	a4,a5,80005d30 <sys_link+0xea>
  ip->nlink++;
    80005cac:	04a4d783          	lhu	a5,74(s1)
    80005cb0:	2785                	addw	a5,a5,1
    80005cb2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005cb6:	8526                	mv	a0,s1
    80005cb8:	ffffe097          	auipc	ra,0xffffe
    80005cbc:	240080e7          	jalr	576(ra) # 80003ef8 <iupdate>
  iunlock(ip);
    80005cc0:	8526                	mv	a0,s1
    80005cc2:	ffffe097          	auipc	ra,0xffffe
    80005cc6:	3c4080e7          	jalr	964(ra) # 80004086 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005cca:	fd040593          	add	a1,s0,-48
    80005cce:	f5040513          	add	a0,s0,-176
    80005cd2:	fffff097          	auipc	ra,0xfffff
    80005cd6:	ab6080e7          	jalr	-1354(ra) # 80004788 <nameiparent>
    80005cda:	892a                	mv	s2,a0
    80005cdc:	c935                	beqz	a0,80005d50 <sys_link+0x10a>
  ilock(dp);
    80005cde:	ffffe097          	auipc	ra,0xffffe
    80005ce2:	2e6080e7          	jalr	742(ra) # 80003fc4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005ce6:	00092703          	lw	a4,0(s2)
    80005cea:	409c                	lw	a5,0(s1)
    80005cec:	04f71d63          	bne	a4,a5,80005d46 <sys_link+0x100>
    80005cf0:	40d0                	lw	a2,4(s1)
    80005cf2:	fd040593          	add	a1,s0,-48
    80005cf6:	854a                	mv	a0,s2
    80005cf8:	fffff097          	auipc	ra,0xfffff
    80005cfc:	9c0080e7          	jalr	-1600(ra) # 800046b8 <dirlink>
    80005d00:	04054363          	bltz	a0,80005d46 <sys_link+0x100>
  iunlockput(dp);
    80005d04:	854a                	mv	a0,s2
    80005d06:	ffffe097          	auipc	ra,0xffffe
    80005d0a:	520080e7          	jalr	1312(ra) # 80004226 <iunlockput>
  iput(ip);
    80005d0e:	8526                	mv	a0,s1
    80005d10:	ffffe097          	auipc	ra,0xffffe
    80005d14:	46e080e7          	jalr	1134(ra) # 8000417e <iput>
  end_op();
    80005d18:	fffff097          	auipc	ra,0xfffff
    80005d1c:	ccc080e7          	jalr	-820(ra) # 800049e4 <end_op>
  return 0;
    80005d20:	4781                	li	a5,0
    80005d22:	a085                	j	80005d82 <sys_link+0x13c>
    end_op();
    80005d24:	fffff097          	auipc	ra,0xfffff
    80005d28:	cc0080e7          	jalr	-832(ra) # 800049e4 <end_op>
    return -1;
    80005d2c:	57fd                	li	a5,-1
    80005d2e:	a891                	j	80005d82 <sys_link+0x13c>
    iunlockput(ip);
    80005d30:	8526                	mv	a0,s1
    80005d32:	ffffe097          	auipc	ra,0xffffe
    80005d36:	4f4080e7          	jalr	1268(ra) # 80004226 <iunlockput>
    end_op();
    80005d3a:	fffff097          	auipc	ra,0xfffff
    80005d3e:	caa080e7          	jalr	-854(ra) # 800049e4 <end_op>
    return -1;
    80005d42:	57fd                	li	a5,-1
    80005d44:	a83d                	j	80005d82 <sys_link+0x13c>
    iunlockput(dp);
    80005d46:	854a                	mv	a0,s2
    80005d48:	ffffe097          	auipc	ra,0xffffe
    80005d4c:	4de080e7          	jalr	1246(ra) # 80004226 <iunlockput>
  ilock(ip);
    80005d50:	8526                	mv	a0,s1
    80005d52:	ffffe097          	auipc	ra,0xffffe
    80005d56:	272080e7          	jalr	626(ra) # 80003fc4 <ilock>
  ip->nlink--;
    80005d5a:	04a4d783          	lhu	a5,74(s1)
    80005d5e:	37fd                	addw	a5,a5,-1
    80005d60:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005d64:	8526                	mv	a0,s1
    80005d66:	ffffe097          	auipc	ra,0xffffe
    80005d6a:	192080e7          	jalr	402(ra) # 80003ef8 <iupdate>
  iunlockput(ip);
    80005d6e:	8526                	mv	a0,s1
    80005d70:	ffffe097          	auipc	ra,0xffffe
    80005d74:	4b6080e7          	jalr	1206(ra) # 80004226 <iunlockput>
  end_op();
    80005d78:	fffff097          	auipc	ra,0xfffff
    80005d7c:	c6c080e7          	jalr	-916(ra) # 800049e4 <end_op>
  return -1;
    80005d80:	57fd                	li	a5,-1
}
    80005d82:	853e                	mv	a0,a5
    80005d84:	70b2                	ld	ra,296(sp)
    80005d86:	7412                	ld	s0,288(sp)
    80005d88:	64f2                	ld	s1,280(sp)
    80005d8a:	6952                	ld	s2,272(sp)
    80005d8c:	6155                	add	sp,sp,304
    80005d8e:	8082                	ret

0000000080005d90 <sys_unlink>:
{
    80005d90:	7151                	add	sp,sp,-240
    80005d92:	f586                	sd	ra,232(sp)
    80005d94:	f1a2                	sd	s0,224(sp)
    80005d96:	eda6                	sd	s1,216(sp)
    80005d98:	e9ca                	sd	s2,208(sp)
    80005d9a:	e5ce                	sd	s3,200(sp)
    80005d9c:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005d9e:	08000613          	li	a2,128
    80005da2:	f3040593          	add	a1,s0,-208
    80005da6:	4501                	li	a0,0
    80005da8:	ffffd097          	auipc	ra,0xffffd
    80005dac:	51e080e7          	jalr	1310(ra) # 800032c6 <argstr>
    80005db0:	18054163          	bltz	a0,80005f32 <sys_unlink+0x1a2>
  begin_op();
    80005db4:	fffff097          	auipc	ra,0xfffff
    80005db8:	bb6080e7          	jalr	-1098(ra) # 8000496a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005dbc:	fb040593          	add	a1,s0,-80
    80005dc0:	f3040513          	add	a0,s0,-208
    80005dc4:	fffff097          	auipc	ra,0xfffff
    80005dc8:	9c4080e7          	jalr	-1596(ra) # 80004788 <nameiparent>
    80005dcc:	84aa                	mv	s1,a0
    80005dce:	c979                	beqz	a0,80005ea4 <sys_unlink+0x114>
  ilock(dp);
    80005dd0:	ffffe097          	auipc	ra,0xffffe
    80005dd4:	1f4080e7          	jalr	500(ra) # 80003fc4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005dd8:	00003597          	auipc	a1,0x3
    80005ddc:	95858593          	add	a1,a1,-1704 # 80008730 <etext+0x730>
    80005de0:	fb040513          	add	a0,s0,-80
    80005de4:	ffffe097          	auipc	ra,0xffffe
    80005de8:	6aa080e7          	jalr	1706(ra) # 8000448e <namecmp>
    80005dec:	14050a63          	beqz	a0,80005f40 <sys_unlink+0x1b0>
    80005df0:	00003597          	auipc	a1,0x3
    80005df4:	94858593          	add	a1,a1,-1720 # 80008738 <etext+0x738>
    80005df8:	fb040513          	add	a0,s0,-80
    80005dfc:	ffffe097          	auipc	ra,0xffffe
    80005e00:	692080e7          	jalr	1682(ra) # 8000448e <namecmp>
    80005e04:	12050e63          	beqz	a0,80005f40 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005e08:	f2c40613          	add	a2,s0,-212
    80005e0c:	fb040593          	add	a1,s0,-80
    80005e10:	8526                	mv	a0,s1
    80005e12:	ffffe097          	auipc	ra,0xffffe
    80005e16:	696080e7          	jalr	1686(ra) # 800044a8 <dirlookup>
    80005e1a:	892a                	mv	s2,a0
    80005e1c:	12050263          	beqz	a0,80005f40 <sys_unlink+0x1b0>
  ilock(ip);
    80005e20:	ffffe097          	auipc	ra,0xffffe
    80005e24:	1a4080e7          	jalr	420(ra) # 80003fc4 <ilock>
  if(ip->nlink < 1)
    80005e28:	04a91783          	lh	a5,74(s2)
    80005e2c:	08f05263          	blez	a5,80005eb0 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005e30:	04491703          	lh	a4,68(s2)
    80005e34:	4785                	li	a5,1
    80005e36:	08f70563          	beq	a4,a5,80005ec0 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005e3a:	4641                	li	a2,16
    80005e3c:	4581                	li	a1,0
    80005e3e:	fc040513          	add	a0,s0,-64
    80005e42:	ffffb097          	auipc	ra,0xffffb
    80005e46:	f8a080e7          	jalr	-118(ra) # 80000dcc <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005e4a:	4741                	li	a4,16
    80005e4c:	f2c42683          	lw	a3,-212(s0)
    80005e50:	fc040613          	add	a2,s0,-64
    80005e54:	4581                	li	a1,0
    80005e56:	8526                	mv	a0,s1
    80005e58:	ffffe097          	auipc	ra,0xffffe
    80005e5c:	518080e7          	jalr	1304(ra) # 80004370 <writei>
    80005e60:	47c1                	li	a5,16
    80005e62:	0af51563          	bne	a0,a5,80005f0c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005e66:	04491703          	lh	a4,68(s2)
    80005e6a:	4785                	li	a5,1
    80005e6c:	0af70863          	beq	a4,a5,80005f1c <sys_unlink+0x18c>
  iunlockput(dp);
    80005e70:	8526                	mv	a0,s1
    80005e72:	ffffe097          	auipc	ra,0xffffe
    80005e76:	3b4080e7          	jalr	948(ra) # 80004226 <iunlockput>
  ip->nlink--;
    80005e7a:	04a95783          	lhu	a5,74(s2)
    80005e7e:	37fd                	addw	a5,a5,-1
    80005e80:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005e84:	854a                	mv	a0,s2
    80005e86:	ffffe097          	auipc	ra,0xffffe
    80005e8a:	072080e7          	jalr	114(ra) # 80003ef8 <iupdate>
  iunlockput(ip);
    80005e8e:	854a                	mv	a0,s2
    80005e90:	ffffe097          	auipc	ra,0xffffe
    80005e94:	396080e7          	jalr	918(ra) # 80004226 <iunlockput>
  end_op();
    80005e98:	fffff097          	auipc	ra,0xfffff
    80005e9c:	b4c080e7          	jalr	-1204(ra) # 800049e4 <end_op>
  return 0;
    80005ea0:	4501                	li	a0,0
    80005ea2:	a84d                	j	80005f54 <sys_unlink+0x1c4>
    end_op();
    80005ea4:	fffff097          	auipc	ra,0xfffff
    80005ea8:	b40080e7          	jalr	-1216(ra) # 800049e4 <end_op>
    return -1;
    80005eac:	557d                	li	a0,-1
    80005eae:	a05d                	j	80005f54 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005eb0:	00003517          	auipc	a0,0x3
    80005eb4:	89050513          	add	a0,a0,-1904 # 80008740 <etext+0x740>
    80005eb8:	ffffa097          	auipc	ra,0xffffa
    80005ebc:	684080e7          	jalr	1668(ra) # 8000053c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005ec0:	04c92703          	lw	a4,76(s2)
    80005ec4:	02000793          	li	a5,32
    80005ec8:	f6e7f9e3          	bgeu	a5,a4,80005e3a <sys_unlink+0xaa>
    80005ecc:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005ed0:	4741                	li	a4,16
    80005ed2:	86ce                	mv	a3,s3
    80005ed4:	f1840613          	add	a2,s0,-232
    80005ed8:	4581                	li	a1,0
    80005eda:	854a                	mv	a0,s2
    80005edc:	ffffe097          	auipc	ra,0xffffe
    80005ee0:	39c080e7          	jalr	924(ra) # 80004278 <readi>
    80005ee4:	47c1                	li	a5,16
    80005ee6:	00f51b63          	bne	a0,a5,80005efc <sys_unlink+0x16c>
    if(de.inum != 0)
    80005eea:	f1845783          	lhu	a5,-232(s0)
    80005eee:	e7a1                	bnez	a5,80005f36 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005ef0:	29c1                	addw	s3,s3,16
    80005ef2:	04c92783          	lw	a5,76(s2)
    80005ef6:	fcf9ede3          	bltu	s3,a5,80005ed0 <sys_unlink+0x140>
    80005efa:	b781                	j	80005e3a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005efc:	00003517          	auipc	a0,0x3
    80005f00:	85c50513          	add	a0,a0,-1956 # 80008758 <etext+0x758>
    80005f04:	ffffa097          	auipc	ra,0xffffa
    80005f08:	638080e7          	jalr	1592(ra) # 8000053c <panic>
    panic("unlink: writei");
    80005f0c:	00003517          	auipc	a0,0x3
    80005f10:	86450513          	add	a0,a0,-1948 # 80008770 <etext+0x770>
    80005f14:	ffffa097          	auipc	ra,0xffffa
    80005f18:	628080e7          	jalr	1576(ra) # 8000053c <panic>
    dp->nlink--;
    80005f1c:	04a4d783          	lhu	a5,74(s1)
    80005f20:	37fd                	addw	a5,a5,-1
    80005f22:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005f26:	8526                	mv	a0,s1
    80005f28:	ffffe097          	auipc	ra,0xffffe
    80005f2c:	fd0080e7          	jalr	-48(ra) # 80003ef8 <iupdate>
    80005f30:	b781                	j	80005e70 <sys_unlink+0xe0>
    return -1;
    80005f32:	557d                	li	a0,-1
    80005f34:	a005                	j	80005f54 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005f36:	854a                	mv	a0,s2
    80005f38:	ffffe097          	auipc	ra,0xffffe
    80005f3c:	2ee080e7          	jalr	750(ra) # 80004226 <iunlockput>
  iunlockput(dp);
    80005f40:	8526                	mv	a0,s1
    80005f42:	ffffe097          	auipc	ra,0xffffe
    80005f46:	2e4080e7          	jalr	740(ra) # 80004226 <iunlockput>
  end_op();
    80005f4a:	fffff097          	auipc	ra,0xfffff
    80005f4e:	a9a080e7          	jalr	-1382(ra) # 800049e4 <end_op>
  return -1;
    80005f52:	557d                	li	a0,-1
}
    80005f54:	70ae                	ld	ra,232(sp)
    80005f56:	740e                	ld	s0,224(sp)
    80005f58:	64ee                	ld	s1,216(sp)
    80005f5a:	694e                	ld	s2,208(sp)
    80005f5c:	69ae                	ld	s3,200(sp)
    80005f5e:	616d                	add	sp,sp,240
    80005f60:	8082                	ret

0000000080005f62 <sys_open>:

uint64
sys_open(void)
{
    80005f62:	7131                	add	sp,sp,-192
    80005f64:	fd06                	sd	ra,184(sp)
    80005f66:	f922                	sd	s0,176(sp)
    80005f68:	f526                	sd	s1,168(sp)
    80005f6a:	f14a                	sd	s2,160(sp)
    80005f6c:	ed4e                	sd	s3,152(sp)
    80005f6e:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005f70:	f4c40593          	add	a1,s0,-180
    80005f74:	4505                	li	a0,1
    80005f76:	ffffd097          	auipc	ra,0xffffd
    80005f7a:	310080e7          	jalr	784(ra) # 80003286 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005f7e:	08000613          	li	a2,128
    80005f82:	f5040593          	add	a1,s0,-176
    80005f86:	4501                	li	a0,0
    80005f88:	ffffd097          	auipc	ra,0xffffd
    80005f8c:	33e080e7          	jalr	830(ra) # 800032c6 <argstr>
    80005f90:	87aa                	mv	a5,a0
    return -1;
    80005f92:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005f94:	0a07c863          	bltz	a5,80006044 <sys_open+0xe2>

  begin_op();
    80005f98:	fffff097          	auipc	ra,0xfffff
    80005f9c:	9d2080e7          	jalr	-1582(ra) # 8000496a <begin_op>

  if(omode & O_CREATE){
    80005fa0:	f4c42783          	lw	a5,-180(s0)
    80005fa4:	2007f793          	and	a5,a5,512
    80005fa8:	cbdd                	beqz	a5,8000605e <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80005faa:	4681                	li	a3,0
    80005fac:	4601                	li	a2,0
    80005fae:	4589                	li	a1,2
    80005fb0:	f5040513          	add	a0,s0,-176
    80005fb4:	00000097          	auipc	ra,0x0
    80005fb8:	938080e7          	jalr	-1736(ra) # 800058ec <create>
    80005fbc:	84aa                	mv	s1,a0
    if(ip == 0){
    80005fbe:	c951                	beqz	a0,80006052 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005fc0:	04449703          	lh	a4,68(s1)
    80005fc4:	478d                	li	a5,3
    80005fc6:	00f71763          	bne	a4,a5,80005fd4 <sys_open+0x72>
    80005fca:	0464d703          	lhu	a4,70(s1)
    80005fce:	47a5                	li	a5,9
    80005fd0:	0ce7ec63          	bltu	a5,a4,800060a8 <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005fd4:	fffff097          	auipc	ra,0xfffff
    80005fd8:	d9e080e7          	jalr	-610(ra) # 80004d72 <filealloc>
    80005fdc:	892a                	mv	s2,a0
    80005fde:	c56d                	beqz	a0,800060c8 <sys_open+0x166>
    80005fe0:	00000097          	auipc	ra,0x0
    80005fe4:	8ca080e7          	jalr	-1846(ra) # 800058aa <fdalloc>
    80005fe8:	89aa                	mv	s3,a0
    80005fea:	0c054a63          	bltz	a0,800060be <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005fee:	04449703          	lh	a4,68(s1)
    80005ff2:	478d                	li	a5,3
    80005ff4:	0ef70563          	beq	a4,a5,800060de <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005ff8:	4789                	li	a5,2
    80005ffa:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005ffe:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80006002:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80006006:	f4c42783          	lw	a5,-180(s0)
    8000600a:	0017c713          	xor	a4,a5,1
    8000600e:	8b05                	and	a4,a4,1
    80006010:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80006014:	0037f713          	and	a4,a5,3
    80006018:	00e03733          	snez	a4,a4
    8000601c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80006020:	4007f793          	and	a5,a5,1024
    80006024:	c791                	beqz	a5,80006030 <sys_open+0xce>
    80006026:	04449703          	lh	a4,68(s1)
    8000602a:	4789                	li	a5,2
    8000602c:	0cf70063          	beq	a4,a5,800060ec <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80006030:	8526                	mv	a0,s1
    80006032:	ffffe097          	auipc	ra,0xffffe
    80006036:	054080e7          	jalr	84(ra) # 80004086 <iunlock>
  end_op();
    8000603a:	fffff097          	auipc	ra,0xfffff
    8000603e:	9aa080e7          	jalr	-1622(ra) # 800049e4 <end_op>

  return fd;
    80006042:	854e                	mv	a0,s3
}
    80006044:	70ea                	ld	ra,184(sp)
    80006046:	744a                	ld	s0,176(sp)
    80006048:	74aa                	ld	s1,168(sp)
    8000604a:	790a                	ld	s2,160(sp)
    8000604c:	69ea                	ld	s3,152(sp)
    8000604e:	6129                	add	sp,sp,192
    80006050:	8082                	ret
      end_op();
    80006052:	fffff097          	auipc	ra,0xfffff
    80006056:	992080e7          	jalr	-1646(ra) # 800049e4 <end_op>
      return -1;
    8000605a:	557d                	li	a0,-1
    8000605c:	b7e5                	j	80006044 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    8000605e:	f5040513          	add	a0,s0,-176
    80006062:	ffffe097          	auipc	ra,0xffffe
    80006066:	708080e7          	jalr	1800(ra) # 8000476a <namei>
    8000606a:	84aa                	mv	s1,a0
    8000606c:	c905                	beqz	a0,8000609c <sys_open+0x13a>
    ilock(ip);
    8000606e:	ffffe097          	auipc	ra,0xffffe
    80006072:	f56080e7          	jalr	-170(ra) # 80003fc4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80006076:	04449703          	lh	a4,68(s1)
    8000607a:	4785                	li	a5,1
    8000607c:	f4f712e3          	bne	a4,a5,80005fc0 <sys_open+0x5e>
    80006080:	f4c42783          	lw	a5,-180(s0)
    80006084:	dba1                	beqz	a5,80005fd4 <sys_open+0x72>
      iunlockput(ip);
    80006086:	8526                	mv	a0,s1
    80006088:	ffffe097          	auipc	ra,0xffffe
    8000608c:	19e080e7          	jalr	414(ra) # 80004226 <iunlockput>
      end_op();
    80006090:	fffff097          	auipc	ra,0xfffff
    80006094:	954080e7          	jalr	-1708(ra) # 800049e4 <end_op>
      return -1;
    80006098:	557d                	li	a0,-1
    8000609a:	b76d                	j	80006044 <sys_open+0xe2>
      end_op();
    8000609c:	fffff097          	auipc	ra,0xfffff
    800060a0:	948080e7          	jalr	-1720(ra) # 800049e4 <end_op>
      return -1;
    800060a4:	557d                	li	a0,-1
    800060a6:	bf79                	j	80006044 <sys_open+0xe2>
    iunlockput(ip);
    800060a8:	8526                	mv	a0,s1
    800060aa:	ffffe097          	auipc	ra,0xffffe
    800060ae:	17c080e7          	jalr	380(ra) # 80004226 <iunlockput>
    end_op();
    800060b2:	fffff097          	auipc	ra,0xfffff
    800060b6:	932080e7          	jalr	-1742(ra) # 800049e4 <end_op>
    return -1;
    800060ba:	557d                	li	a0,-1
    800060bc:	b761                	j	80006044 <sys_open+0xe2>
      fileclose(f);
    800060be:	854a                	mv	a0,s2
    800060c0:	fffff097          	auipc	ra,0xfffff
    800060c4:	d6e080e7          	jalr	-658(ra) # 80004e2e <fileclose>
    iunlockput(ip);
    800060c8:	8526                	mv	a0,s1
    800060ca:	ffffe097          	auipc	ra,0xffffe
    800060ce:	15c080e7          	jalr	348(ra) # 80004226 <iunlockput>
    end_op();
    800060d2:	fffff097          	auipc	ra,0xfffff
    800060d6:	912080e7          	jalr	-1774(ra) # 800049e4 <end_op>
    return -1;
    800060da:	557d                	li	a0,-1
    800060dc:	b7a5                	j	80006044 <sys_open+0xe2>
    f->type = FD_DEVICE;
    800060de:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800060e2:	04649783          	lh	a5,70(s1)
    800060e6:	02f91223          	sh	a5,36(s2)
    800060ea:	bf21                	j	80006002 <sys_open+0xa0>
    itrunc(ip);
    800060ec:	8526                	mv	a0,s1
    800060ee:	ffffe097          	auipc	ra,0xffffe
    800060f2:	fe4080e7          	jalr	-28(ra) # 800040d2 <itrunc>
    800060f6:	bf2d                	j	80006030 <sys_open+0xce>

00000000800060f8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800060f8:	7175                	add	sp,sp,-144
    800060fa:	e506                	sd	ra,136(sp)
    800060fc:	e122                	sd	s0,128(sp)
    800060fe:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80006100:	fffff097          	auipc	ra,0xfffff
    80006104:	86a080e7          	jalr	-1942(ra) # 8000496a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80006108:	08000613          	li	a2,128
    8000610c:	f7040593          	add	a1,s0,-144
    80006110:	4501                	li	a0,0
    80006112:	ffffd097          	auipc	ra,0xffffd
    80006116:	1b4080e7          	jalr	436(ra) # 800032c6 <argstr>
    8000611a:	02054963          	bltz	a0,8000614c <sys_mkdir+0x54>
    8000611e:	4681                	li	a3,0
    80006120:	4601                	li	a2,0
    80006122:	4585                	li	a1,1
    80006124:	f7040513          	add	a0,s0,-144
    80006128:	fffff097          	auipc	ra,0xfffff
    8000612c:	7c4080e7          	jalr	1988(ra) # 800058ec <create>
    80006130:	cd11                	beqz	a0,8000614c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006132:	ffffe097          	auipc	ra,0xffffe
    80006136:	0f4080e7          	jalr	244(ra) # 80004226 <iunlockput>
  end_op();
    8000613a:	fffff097          	auipc	ra,0xfffff
    8000613e:	8aa080e7          	jalr	-1878(ra) # 800049e4 <end_op>
  return 0;
    80006142:	4501                	li	a0,0
}
    80006144:	60aa                	ld	ra,136(sp)
    80006146:	640a                	ld	s0,128(sp)
    80006148:	6149                	add	sp,sp,144
    8000614a:	8082                	ret
    end_op();
    8000614c:	fffff097          	auipc	ra,0xfffff
    80006150:	898080e7          	jalr	-1896(ra) # 800049e4 <end_op>
    return -1;
    80006154:	557d                	li	a0,-1
    80006156:	b7fd                	j	80006144 <sys_mkdir+0x4c>

0000000080006158 <sys_mknod>:

uint64
sys_mknod(void)
{
    80006158:	7135                	add	sp,sp,-160
    8000615a:	ed06                	sd	ra,152(sp)
    8000615c:	e922                	sd	s0,144(sp)
    8000615e:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80006160:	fffff097          	auipc	ra,0xfffff
    80006164:	80a080e7          	jalr	-2038(ra) # 8000496a <begin_op>
  argint(1, &major);
    80006168:	f6c40593          	add	a1,s0,-148
    8000616c:	4505                	li	a0,1
    8000616e:	ffffd097          	auipc	ra,0xffffd
    80006172:	118080e7          	jalr	280(ra) # 80003286 <argint>
  argint(2, &minor);
    80006176:	f6840593          	add	a1,s0,-152
    8000617a:	4509                	li	a0,2
    8000617c:	ffffd097          	auipc	ra,0xffffd
    80006180:	10a080e7          	jalr	266(ra) # 80003286 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80006184:	08000613          	li	a2,128
    80006188:	f7040593          	add	a1,s0,-144
    8000618c:	4501                	li	a0,0
    8000618e:	ffffd097          	auipc	ra,0xffffd
    80006192:	138080e7          	jalr	312(ra) # 800032c6 <argstr>
    80006196:	02054b63          	bltz	a0,800061cc <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000619a:	f6841683          	lh	a3,-152(s0)
    8000619e:	f6c41603          	lh	a2,-148(s0)
    800061a2:	458d                	li	a1,3
    800061a4:	f7040513          	add	a0,s0,-144
    800061a8:	fffff097          	auipc	ra,0xfffff
    800061ac:	744080e7          	jalr	1860(ra) # 800058ec <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800061b0:	cd11                	beqz	a0,800061cc <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800061b2:	ffffe097          	auipc	ra,0xffffe
    800061b6:	074080e7          	jalr	116(ra) # 80004226 <iunlockput>
  end_op();
    800061ba:	fffff097          	auipc	ra,0xfffff
    800061be:	82a080e7          	jalr	-2006(ra) # 800049e4 <end_op>
  return 0;
    800061c2:	4501                	li	a0,0
}
    800061c4:	60ea                	ld	ra,152(sp)
    800061c6:	644a                	ld	s0,144(sp)
    800061c8:	610d                	add	sp,sp,160
    800061ca:	8082                	ret
    end_op();
    800061cc:	fffff097          	auipc	ra,0xfffff
    800061d0:	818080e7          	jalr	-2024(ra) # 800049e4 <end_op>
    return -1;
    800061d4:	557d                	li	a0,-1
    800061d6:	b7fd                	j	800061c4 <sys_mknod+0x6c>

00000000800061d8 <sys_chdir>:

uint64
sys_chdir(void)
{
    800061d8:	7135                	add	sp,sp,-160
    800061da:	ed06                	sd	ra,152(sp)
    800061dc:	e922                	sd	s0,144(sp)
    800061de:	e526                	sd	s1,136(sp)
    800061e0:	e14a                	sd	s2,128(sp)
    800061e2:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800061e4:	ffffc097          	auipc	ra,0xffffc
    800061e8:	bcc080e7          	jalr	-1076(ra) # 80001db0 <myproc>
    800061ec:	892a                	mv	s2,a0
  
  begin_op();
    800061ee:	ffffe097          	auipc	ra,0xffffe
    800061f2:	77c080e7          	jalr	1916(ra) # 8000496a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800061f6:	08000613          	li	a2,128
    800061fa:	f6040593          	add	a1,s0,-160
    800061fe:	4501                	li	a0,0
    80006200:	ffffd097          	auipc	ra,0xffffd
    80006204:	0c6080e7          	jalr	198(ra) # 800032c6 <argstr>
    80006208:	04054b63          	bltz	a0,8000625e <sys_chdir+0x86>
    8000620c:	f6040513          	add	a0,s0,-160
    80006210:	ffffe097          	auipc	ra,0xffffe
    80006214:	55a080e7          	jalr	1370(ra) # 8000476a <namei>
    80006218:	84aa                	mv	s1,a0
    8000621a:	c131                	beqz	a0,8000625e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000621c:	ffffe097          	auipc	ra,0xffffe
    80006220:	da8080e7          	jalr	-600(ra) # 80003fc4 <ilock>
  if(ip->type != T_DIR){
    80006224:	04449703          	lh	a4,68(s1)
    80006228:	4785                	li	a5,1
    8000622a:	04f71063          	bne	a4,a5,8000626a <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000622e:	8526                	mv	a0,s1
    80006230:	ffffe097          	auipc	ra,0xffffe
    80006234:	e56080e7          	jalr	-426(ra) # 80004086 <iunlock>
  iput(p->cwd);
    80006238:	15093503          	ld	a0,336(s2)
    8000623c:	ffffe097          	auipc	ra,0xffffe
    80006240:	f42080e7          	jalr	-190(ra) # 8000417e <iput>
  end_op();
    80006244:	ffffe097          	auipc	ra,0xffffe
    80006248:	7a0080e7          	jalr	1952(ra) # 800049e4 <end_op>
  p->cwd = ip;
    8000624c:	14993823          	sd	s1,336(s2)
  return 0;
    80006250:	4501                	li	a0,0
}
    80006252:	60ea                	ld	ra,152(sp)
    80006254:	644a                	ld	s0,144(sp)
    80006256:	64aa                	ld	s1,136(sp)
    80006258:	690a                	ld	s2,128(sp)
    8000625a:	610d                	add	sp,sp,160
    8000625c:	8082                	ret
    end_op();
    8000625e:	ffffe097          	auipc	ra,0xffffe
    80006262:	786080e7          	jalr	1926(ra) # 800049e4 <end_op>
    return -1;
    80006266:	557d                	li	a0,-1
    80006268:	b7ed                	j	80006252 <sys_chdir+0x7a>
    iunlockput(ip);
    8000626a:	8526                	mv	a0,s1
    8000626c:	ffffe097          	auipc	ra,0xffffe
    80006270:	fba080e7          	jalr	-70(ra) # 80004226 <iunlockput>
    end_op();
    80006274:	ffffe097          	auipc	ra,0xffffe
    80006278:	770080e7          	jalr	1904(ra) # 800049e4 <end_op>
    return -1;
    8000627c:	557d                	li	a0,-1
    8000627e:	bfd1                	j	80006252 <sys_chdir+0x7a>

0000000080006280 <sys_exec>:

uint64
sys_exec(void)
{
    80006280:	7121                	add	sp,sp,-448
    80006282:	ff06                	sd	ra,440(sp)
    80006284:	fb22                	sd	s0,432(sp)
    80006286:	f726                	sd	s1,424(sp)
    80006288:	f34a                	sd	s2,416(sp)
    8000628a:	ef4e                	sd	s3,408(sp)
    8000628c:	eb52                	sd	s4,400(sp)
    8000628e:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80006290:	e4840593          	add	a1,s0,-440
    80006294:	4505                	li	a0,1
    80006296:	ffffd097          	auipc	ra,0xffffd
    8000629a:	010080e7          	jalr	16(ra) # 800032a6 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000629e:	08000613          	li	a2,128
    800062a2:	f5040593          	add	a1,s0,-176
    800062a6:	4501                	li	a0,0
    800062a8:	ffffd097          	auipc	ra,0xffffd
    800062ac:	01e080e7          	jalr	30(ra) # 800032c6 <argstr>
    800062b0:	87aa                	mv	a5,a0
    return -1;
    800062b2:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800062b4:	0c07c263          	bltz	a5,80006378 <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    800062b8:	10000613          	li	a2,256
    800062bc:	4581                	li	a1,0
    800062be:	e5040513          	add	a0,s0,-432
    800062c2:	ffffb097          	auipc	ra,0xffffb
    800062c6:	b0a080e7          	jalr	-1270(ra) # 80000dcc <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800062ca:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800062ce:	89a6                	mv	s3,s1
    800062d0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800062d2:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800062d6:	00391513          	sll	a0,s2,0x3
    800062da:	e4040593          	add	a1,s0,-448
    800062de:	e4843783          	ld	a5,-440(s0)
    800062e2:	953e                	add	a0,a0,a5
    800062e4:	ffffd097          	auipc	ra,0xffffd
    800062e8:	f04080e7          	jalr	-252(ra) # 800031e8 <fetchaddr>
    800062ec:	02054a63          	bltz	a0,80006320 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    800062f0:	e4043783          	ld	a5,-448(s0)
    800062f4:	c3b9                	beqz	a5,8000633a <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800062f6:	ffffb097          	auipc	ra,0xffffb
    800062fa:	888080e7          	jalr	-1912(ra) # 80000b7e <kalloc>
    800062fe:	85aa                	mv	a1,a0
    80006300:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80006304:	cd11                	beqz	a0,80006320 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006306:	6605                	lui	a2,0x1
    80006308:	e4043503          	ld	a0,-448(s0)
    8000630c:	ffffd097          	auipc	ra,0xffffd
    80006310:	f2e080e7          	jalr	-210(ra) # 8000323a <fetchstr>
    80006314:	00054663          	bltz	a0,80006320 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80006318:	0905                	add	s2,s2,1
    8000631a:	09a1                	add	s3,s3,8
    8000631c:	fb491de3          	bne	s2,s4,800062d6 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006320:	f5040913          	add	s2,s0,-176
    80006324:	6088                	ld	a0,0(s1)
    80006326:	c921                	beqz	a0,80006376 <sys_exec+0xf6>
    kfree(argv[i]);
    80006328:	ffffa097          	auipc	ra,0xffffa
    8000632c:	6bc080e7          	jalr	1724(ra) # 800009e4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006330:	04a1                	add	s1,s1,8
    80006332:	ff2499e3          	bne	s1,s2,80006324 <sys_exec+0xa4>
  return -1;
    80006336:	557d                	li	a0,-1
    80006338:	a081                	j	80006378 <sys_exec+0xf8>
      argv[i] = 0;
    8000633a:	0009079b          	sext.w	a5,s2
    8000633e:	078e                	sll	a5,a5,0x3
    80006340:	fd078793          	add	a5,a5,-48
    80006344:	97a2                	add	a5,a5,s0
    80006346:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000634a:	e5040593          	add	a1,s0,-432
    8000634e:	f5040513          	add	a0,s0,-176
    80006352:	fffff097          	auipc	ra,0xfffff
    80006356:	152080e7          	jalr	338(ra) # 800054a4 <exec>
    8000635a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000635c:	f5040993          	add	s3,s0,-176
    80006360:	6088                	ld	a0,0(s1)
    80006362:	c901                	beqz	a0,80006372 <sys_exec+0xf2>
    kfree(argv[i]);
    80006364:	ffffa097          	auipc	ra,0xffffa
    80006368:	680080e7          	jalr	1664(ra) # 800009e4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000636c:	04a1                	add	s1,s1,8
    8000636e:	ff3499e3          	bne	s1,s3,80006360 <sys_exec+0xe0>
  return ret;
    80006372:	854a                	mv	a0,s2
    80006374:	a011                	j	80006378 <sys_exec+0xf8>
  return -1;
    80006376:	557d                	li	a0,-1
}
    80006378:	70fa                	ld	ra,440(sp)
    8000637a:	745a                	ld	s0,432(sp)
    8000637c:	74ba                	ld	s1,424(sp)
    8000637e:	791a                	ld	s2,416(sp)
    80006380:	69fa                	ld	s3,408(sp)
    80006382:	6a5a                	ld	s4,400(sp)
    80006384:	6139                	add	sp,sp,448
    80006386:	8082                	ret

0000000080006388 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006388:	7139                	add	sp,sp,-64
    8000638a:	fc06                	sd	ra,56(sp)
    8000638c:	f822                	sd	s0,48(sp)
    8000638e:	f426                	sd	s1,40(sp)
    80006390:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006392:	ffffc097          	auipc	ra,0xffffc
    80006396:	a1e080e7          	jalr	-1506(ra) # 80001db0 <myproc>
    8000639a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000639c:	fd840593          	add	a1,s0,-40
    800063a0:	4501                	li	a0,0
    800063a2:	ffffd097          	auipc	ra,0xffffd
    800063a6:	f04080e7          	jalr	-252(ra) # 800032a6 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800063aa:	fc840593          	add	a1,s0,-56
    800063ae:	fd040513          	add	a0,s0,-48
    800063b2:	fffff097          	auipc	ra,0xfffff
    800063b6:	da8080e7          	jalr	-600(ra) # 8000515a <pipealloc>
    return -1;
    800063ba:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800063bc:	0c054463          	bltz	a0,80006484 <sys_pipe+0xfc>
  fd0 = -1;
    800063c0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800063c4:	fd043503          	ld	a0,-48(s0)
    800063c8:	fffff097          	auipc	ra,0xfffff
    800063cc:	4e2080e7          	jalr	1250(ra) # 800058aa <fdalloc>
    800063d0:	fca42223          	sw	a0,-60(s0)
    800063d4:	08054b63          	bltz	a0,8000646a <sys_pipe+0xe2>
    800063d8:	fc843503          	ld	a0,-56(s0)
    800063dc:	fffff097          	auipc	ra,0xfffff
    800063e0:	4ce080e7          	jalr	1230(ra) # 800058aa <fdalloc>
    800063e4:	fca42023          	sw	a0,-64(s0)
    800063e8:	06054863          	bltz	a0,80006458 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800063ec:	4691                	li	a3,4
    800063ee:	fc440613          	add	a2,s0,-60
    800063f2:	fd843583          	ld	a1,-40(s0)
    800063f6:	68a8                	ld	a0,80(s1)
    800063f8:	ffffb097          	auipc	ra,0xffffb
    800063fc:	4b0080e7          	jalr	1200(ra) # 800018a8 <copyout>
    80006400:	02054063          	bltz	a0,80006420 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006404:	4691                	li	a3,4
    80006406:	fc040613          	add	a2,s0,-64
    8000640a:	fd843583          	ld	a1,-40(s0)
    8000640e:	0591                	add	a1,a1,4
    80006410:	68a8                	ld	a0,80(s1)
    80006412:	ffffb097          	auipc	ra,0xffffb
    80006416:	496080e7          	jalr	1174(ra) # 800018a8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000641a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000641c:	06055463          	bgez	a0,80006484 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80006420:	fc442783          	lw	a5,-60(s0)
    80006424:	07e9                	add	a5,a5,26
    80006426:	078e                	sll	a5,a5,0x3
    80006428:	97a6                	add	a5,a5,s1
    8000642a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000642e:	fc042783          	lw	a5,-64(s0)
    80006432:	07e9                	add	a5,a5,26
    80006434:	078e                	sll	a5,a5,0x3
    80006436:	94be                	add	s1,s1,a5
    80006438:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000643c:	fd043503          	ld	a0,-48(s0)
    80006440:	fffff097          	auipc	ra,0xfffff
    80006444:	9ee080e7          	jalr	-1554(ra) # 80004e2e <fileclose>
    fileclose(wf);
    80006448:	fc843503          	ld	a0,-56(s0)
    8000644c:	fffff097          	auipc	ra,0xfffff
    80006450:	9e2080e7          	jalr	-1566(ra) # 80004e2e <fileclose>
    return -1;
    80006454:	57fd                	li	a5,-1
    80006456:	a03d                	j	80006484 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80006458:	fc442783          	lw	a5,-60(s0)
    8000645c:	0007c763          	bltz	a5,8000646a <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006460:	07e9                	add	a5,a5,26
    80006462:	078e                	sll	a5,a5,0x3
    80006464:	97a6                	add	a5,a5,s1
    80006466:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000646a:	fd043503          	ld	a0,-48(s0)
    8000646e:	fffff097          	auipc	ra,0xfffff
    80006472:	9c0080e7          	jalr	-1600(ra) # 80004e2e <fileclose>
    fileclose(wf);
    80006476:	fc843503          	ld	a0,-56(s0)
    8000647a:	fffff097          	auipc	ra,0xfffff
    8000647e:	9b4080e7          	jalr	-1612(ra) # 80004e2e <fileclose>
    return -1;
    80006482:	57fd                	li	a5,-1
}
    80006484:	853e                	mv	a0,a5
    80006486:	70e2                	ld	ra,56(sp)
    80006488:	7442                	ld	s0,48(sp)
    8000648a:	74a2                	ld	s1,40(sp)
    8000648c:	6121                	add	sp,sp,64
    8000648e:	8082                	ret

0000000080006490 <kernelvec>:
    80006490:	7111                	add	sp,sp,-256
    80006492:	e006                	sd	ra,0(sp)
    80006494:	e40a                	sd	sp,8(sp)
    80006496:	e80e                	sd	gp,16(sp)
    80006498:	ec12                	sd	tp,24(sp)
    8000649a:	f016                	sd	t0,32(sp)
    8000649c:	f41a                	sd	t1,40(sp)
    8000649e:	f81e                	sd	t2,48(sp)
    800064a0:	fc22                	sd	s0,56(sp)
    800064a2:	e0a6                	sd	s1,64(sp)
    800064a4:	e4aa                	sd	a0,72(sp)
    800064a6:	e8ae                	sd	a1,80(sp)
    800064a8:	ecb2                	sd	a2,88(sp)
    800064aa:	f0b6                	sd	a3,96(sp)
    800064ac:	f4ba                	sd	a4,104(sp)
    800064ae:	f8be                	sd	a5,112(sp)
    800064b0:	fcc2                	sd	a6,120(sp)
    800064b2:	e146                	sd	a7,128(sp)
    800064b4:	e54a                	sd	s2,136(sp)
    800064b6:	e94e                	sd	s3,144(sp)
    800064b8:	ed52                	sd	s4,152(sp)
    800064ba:	f156                	sd	s5,160(sp)
    800064bc:	f55a                	sd	s6,168(sp)
    800064be:	f95e                	sd	s7,176(sp)
    800064c0:	fd62                	sd	s8,184(sp)
    800064c2:	e1e6                	sd	s9,192(sp)
    800064c4:	e5ea                	sd	s10,200(sp)
    800064c6:	e9ee                	sd	s11,208(sp)
    800064c8:	edf2                	sd	t3,216(sp)
    800064ca:	f1f6                	sd	t4,224(sp)
    800064cc:	f5fa                	sd	t5,232(sp)
    800064ce:	f9fe                	sd	t6,240(sp)
    800064d0:	be5fc0ef          	jal	800030b4 <kerneltrap>
    800064d4:	6082                	ld	ra,0(sp)
    800064d6:	6122                	ld	sp,8(sp)
    800064d8:	61c2                	ld	gp,16(sp)
    800064da:	7282                	ld	t0,32(sp)
    800064dc:	7322                	ld	t1,40(sp)
    800064de:	73c2                	ld	t2,48(sp)
    800064e0:	7462                	ld	s0,56(sp)
    800064e2:	6486                	ld	s1,64(sp)
    800064e4:	6526                	ld	a0,72(sp)
    800064e6:	65c6                	ld	a1,80(sp)
    800064e8:	6666                	ld	a2,88(sp)
    800064ea:	7686                	ld	a3,96(sp)
    800064ec:	7726                	ld	a4,104(sp)
    800064ee:	77c6                	ld	a5,112(sp)
    800064f0:	7866                	ld	a6,120(sp)
    800064f2:	688a                	ld	a7,128(sp)
    800064f4:	692a                	ld	s2,136(sp)
    800064f6:	69ca                	ld	s3,144(sp)
    800064f8:	6a6a                	ld	s4,152(sp)
    800064fa:	7a8a                	ld	s5,160(sp)
    800064fc:	7b2a                	ld	s6,168(sp)
    800064fe:	7bca                	ld	s7,176(sp)
    80006500:	7c6a                	ld	s8,184(sp)
    80006502:	6c8e                	ld	s9,192(sp)
    80006504:	6d2e                	ld	s10,200(sp)
    80006506:	6dce                	ld	s11,208(sp)
    80006508:	6e6e                	ld	t3,216(sp)
    8000650a:	7e8e                	ld	t4,224(sp)
    8000650c:	7f2e                	ld	t5,232(sp)
    8000650e:	7fce                	ld	t6,240(sp)
    80006510:	6111                	add	sp,sp,256
    80006512:	10200073          	sret
    80006516:	00000013          	nop
    8000651a:	00000013          	nop
    8000651e:	0001                	nop

0000000080006520 <timervec>:
    80006520:	34051573          	csrrw	a0,mscratch,a0
    80006524:	e10c                	sd	a1,0(a0)
    80006526:	e510                	sd	a2,8(a0)
    80006528:	e914                	sd	a3,16(a0)
    8000652a:	6d0c                	ld	a1,24(a0)
    8000652c:	7110                	ld	a2,32(a0)
    8000652e:	6194                	ld	a3,0(a1)
    80006530:	96b2                	add	a3,a3,a2
    80006532:	e194                	sd	a3,0(a1)
    80006534:	4589                	li	a1,2
    80006536:	14459073          	csrw	sip,a1
    8000653a:	6914                	ld	a3,16(a0)
    8000653c:	6510                	ld	a2,8(a0)
    8000653e:	610c                	ld	a1,0(a0)
    80006540:	34051573          	csrrw	a0,mscratch,a0
    80006544:	30200073          	mret
	...

000000008000654a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000654a:	1141                	add	sp,sp,-16
    8000654c:	e422                	sd	s0,8(sp)
    8000654e:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006550:	0c0007b7          	lui	a5,0xc000
    80006554:	4705                	li	a4,1
    80006556:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006558:	c3d8                	sw	a4,4(a5)
}
    8000655a:	6422                	ld	s0,8(sp)
    8000655c:	0141                	add	sp,sp,16
    8000655e:	8082                	ret

0000000080006560 <plicinithart>:

void
plicinithart(void)
{
    80006560:	1141                	add	sp,sp,-16
    80006562:	e406                	sd	ra,8(sp)
    80006564:	e022                	sd	s0,0(sp)
    80006566:	0800                	add	s0,sp,16
  int hart = cpuid();
    80006568:	ffffc097          	auipc	ra,0xffffc
    8000656c:	81c080e7          	jalr	-2020(ra) # 80001d84 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006570:	0085171b          	sllw	a4,a0,0x8
    80006574:	0c0027b7          	lui	a5,0xc002
    80006578:	97ba                	add	a5,a5,a4
    8000657a:	40200713          	li	a4,1026
    8000657e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006582:	00d5151b          	sllw	a0,a0,0xd
    80006586:	0c2017b7          	lui	a5,0xc201
    8000658a:	97aa                	add	a5,a5,a0
    8000658c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006590:	60a2                	ld	ra,8(sp)
    80006592:	6402                	ld	s0,0(sp)
    80006594:	0141                	add	sp,sp,16
    80006596:	8082                	ret

0000000080006598 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006598:	1141                	add	sp,sp,-16
    8000659a:	e406                	sd	ra,8(sp)
    8000659c:	e022                	sd	s0,0(sp)
    8000659e:	0800                	add	s0,sp,16
  int hart = cpuid();
    800065a0:	ffffb097          	auipc	ra,0xffffb
    800065a4:	7e4080e7          	jalr	2020(ra) # 80001d84 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800065a8:	00d5151b          	sllw	a0,a0,0xd
    800065ac:	0c2017b7          	lui	a5,0xc201
    800065b0:	97aa                	add	a5,a5,a0
  return irq;
}
    800065b2:	43c8                	lw	a0,4(a5)
    800065b4:	60a2                	ld	ra,8(sp)
    800065b6:	6402                	ld	s0,0(sp)
    800065b8:	0141                	add	sp,sp,16
    800065ba:	8082                	ret

00000000800065bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800065bc:	1101                	add	sp,sp,-32
    800065be:	ec06                	sd	ra,24(sp)
    800065c0:	e822                	sd	s0,16(sp)
    800065c2:	e426                	sd	s1,8(sp)
    800065c4:	1000                	add	s0,sp,32
    800065c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800065c8:	ffffb097          	auipc	ra,0xffffb
    800065cc:	7bc080e7          	jalr	1980(ra) # 80001d84 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800065d0:	00d5151b          	sllw	a0,a0,0xd
    800065d4:	0c2017b7          	lui	a5,0xc201
    800065d8:	97aa                	add	a5,a5,a0
    800065da:	c3c4                	sw	s1,4(a5)
}
    800065dc:	60e2                	ld	ra,24(sp)
    800065de:	6442                	ld	s0,16(sp)
    800065e0:	64a2                	ld	s1,8(sp)
    800065e2:	6105                	add	sp,sp,32
    800065e4:	8082                	ret

00000000800065e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800065e6:	1141                	add	sp,sp,-16
    800065e8:	e406                	sd	ra,8(sp)
    800065ea:	e022                	sd	s0,0(sp)
    800065ec:	0800                	add	s0,sp,16
  if(i >= NUM)
    800065ee:	479d                	li	a5,7
    800065f0:	04a7cc63          	blt	a5,a0,80006648 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800065f4:	0023d797          	auipc	a5,0x23d
    800065f8:	3a478793          	add	a5,a5,932 # 80243998 <disk>
    800065fc:	97aa                	add	a5,a5,a0
    800065fe:	0187c783          	lbu	a5,24(a5)
    80006602:	ebb9                	bnez	a5,80006658 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006604:	00451693          	sll	a3,a0,0x4
    80006608:	0023d797          	auipc	a5,0x23d
    8000660c:	39078793          	add	a5,a5,912 # 80243998 <disk>
    80006610:	6398                	ld	a4,0(a5)
    80006612:	9736                	add	a4,a4,a3
    80006614:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80006618:	6398                	ld	a4,0(a5)
    8000661a:	9736                	add	a4,a4,a3
    8000661c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006620:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006624:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006628:	97aa                	add	a5,a5,a0
    8000662a:	4705                	li	a4,1
    8000662c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006630:	0023d517          	auipc	a0,0x23d
    80006634:	38050513          	add	a0,a0,896 # 802439b0 <disk+0x18>
    80006638:	ffffc097          	auipc	ra,0xffffc
    8000663c:	ef4080e7          	jalr	-268(ra) # 8000252c <wakeup>
}
    80006640:	60a2                	ld	ra,8(sp)
    80006642:	6402                	ld	s0,0(sp)
    80006644:	0141                	add	sp,sp,16
    80006646:	8082                	ret
    panic("free_desc 1");
    80006648:	00002517          	auipc	a0,0x2
    8000664c:	13850513          	add	a0,a0,312 # 80008780 <etext+0x780>
    80006650:	ffffa097          	auipc	ra,0xffffa
    80006654:	eec080e7          	jalr	-276(ra) # 8000053c <panic>
    panic("free_desc 2");
    80006658:	00002517          	auipc	a0,0x2
    8000665c:	13850513          	add	a0,a0,312 # 80008790 <etext+0x790>
    80006660:	ffffa097          	auipc	ra,0xffffa
    80006664:	edc080e7          	jalr	-292(ra) # 8000053c <panic>

0000000080006668 <virtio_disk_init>:
{
    80006668:	1101                	add	sp,sp,-32
    8000666a:	ec06                	sd	ra,24(sp)
    8000666c:	e822                	sd	s0,16(sp)
    8000666e:	e426                	sd	s1,8(sp)
    80006670:	e04a                	sd	s2,0(sp)
    80006672:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006674:	00002597          	auipc	a1,0x2
    80006678:	12c58593          	add	a1,a1,300 # 800087a0 <etext+0x7a0>
    8000667c:	0023d517          	auipc	a0,0x23d
    80006680:	44450513          	add	a0,a0,1092 # 80243ac0 <disk+0x128>
    80006684:	ffffa097          	auipc	ra,0xffffa
    80006688:	5bc080e7          	jalr	1468(ra) # 80000c40 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000668c:	100017b7          	lui	a5,0x10001
    80006690:	4398                	lw	a4,0(a5)
    80006692:	2701                	sext.w	a4,a4
    80006694:	747277b7          	lui	a5,0x74727
    80006698:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000669c:	14f71b63          	bne	a4,a5,800067f2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800066a0:	100017b7          	lui	a5,0x10001
    800066a4:	43dc                	lw	a5,4(a5)
    800066a6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800066a8:	4709                	li	a4,2
    800066aa:	14e79463          	bne	a5,a4,800067f2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800066ae:	100017b7          	lui	a5,0x10001
    800066b2:	479c                	lw	a5,8(a5)
    800066b4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800066b6:	12e79e63          	bne	a5,a4,800067f2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800066ba:	100017b7          	lui	a5,0x10001
    800066be:	47d8                	lw	a4,12(a5)
    800066c0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800066c2:	554d47b7          	lui	a5,0x554d4
    800066c6:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800066ca:	12f71463          	bne	a4,a5,800067f2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800066ce:	100017b7          	lui	a5,0x10001
    800066d2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800066d6:	4705                	li	a4,1
    800066d8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800066da:	470d                	li	a4,3
    800066dc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800066de:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800066e0:	c7ffe6b7          	lui	a3,0xc7ffe
    800066e4:	75f68693          	add	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47dbac87>
    800066e8:	8f75                	and	a4,a4,a3
    800066ea:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800066ec:	472d                	li	a4,11
    800066ee:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800066f0:	5bbc                	lw	a5,112(a5)
    800066f2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800066f6:	8ba1                	and	a5,a5,8
    800066f8:	10078563          	beqz	a5,80006802 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800066fc:	100017b7          	lui	a5,0x10001
    80006700:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006704:	43fc                	lw	a5,68(a5)
    80006706:	2781                	sext.w	a5,a5
    80006708:	10079563          	bnez	a5,80006812 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000670c:	100017b7          	lui	a5,0x10001
    80006710:	5bdc                	lw	a5,52(a5)
    80006712:	2781                	sext.w	a5,a5
  if(max == 0)
    80006714:	10078763          	beqz	a5,80006822 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80006718:	471d                	li	a4,7
    8000671a:	10f77c63          	bgeu	a4,a5,80006832 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000671e:	ffffa097          	auipc	ra,0xffffa
    80006722:	460080e7          	jalr	1120(ra) # 80000b7e <kalloc>
    80006726:	0023d497          	auipc	s1,0x23d
    8000672a:	27248493          	add	s1,s1,626 # 80243998 <disk>
    8000672e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006730:	ffffa097          	auipc	ra,0xffffa
    80006734:	44e080e7          	jalr	1102(ra) # 80000b7e <kalloc>
    80006738:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000673a:	ffffa097          	auipc	ra,0xffffa
    8000673e:	444080e7          	jalr	1092(ra) # 80000b7e <kalloc>
    80006742:	87aa                	mv	a5,a0
    80006744:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006746:	6088                	ld	a0,0(s1)
    80006748:	cd6d                	beqz	a0,80006842 <virtio_disk_init+0x1da>
    8000674a:	0023d717          	auipc	a4,0x23d
    8000674e:	25673703          	ld	a4,598(a4) # 802439a0 <disk+0x8>
    80006752:	cb65                	beqz	a4,80006842 <virtio_disk_init+0x1da>
    80006754:	c7fd                	beqz	a5,80006842 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80006756:	6605                	lui	a2,0x1
    80006758:	4581                	li	a1,0
    8000675a:	ffffa097          	auipc	ra,0xffffa
    8000675e:	672080e7          	jalr	1650(ra) # 80000dcc <memset>
  memset(disk.avail, 0, PGSIZE);
    80006762:	0023d497          	auipc	s1,0x23d
    80006766:	23648493          	add	s1,s1,566 # 80243998 <disk>
    8000676a:	6605                	lui	a2,0x1
    8000676c:	4581                	li	a1,0
    8000676e:	6488                	ld	a0,8(s1)
    80006770:	ffffa097          	auipc	ra,0xffffa
    80006774:	65c080e7          	jalr	1628(ra) # 80000dcc <memset>
  memset(disk.used, 0, PGSIZE);
    80006778:	6605                	lui	a2,0x1
    8000677a:	4581                	li	a1,0
    8000677c:	6888                	ld	a0,16(s1)
    8000677e:	ffffa097          	auipc	ra,0xffffa
    80006782:	64e080e7          	jalr	1614(ra) # 80000dcc <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006786:	100017b7          	lui	a5,0x10001
    8000678a:	4721                	li	a4,8
    8000678c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000678e:	4098                	lw	a4,0(s1)
    80006790:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006794:	40d8                	lw	a4,4(s1)
    80006796:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000679a:	6498                	ld	a4,8(s1)
    8000679c:	0007069b          	sext.w	a3,a4
    800067a0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800067a4:	9701                	sra	a4,a4,0x20
    800067a6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800067aa:	6898                	ld	a4,16(s1)
    800067ac:	0007069b          	sext.w	a3,a4
    800067b0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800067b4:	9701                	sra	a4,a4,0x20
    800067b6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800067ba:	4705                	li	a4,1
    800067bc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800067be:	00e48c23          	sb	a4,24(s1)
    800067c2:	00e48ca3          	sb	a4,25(s1)
    800067c6:	00e48d23          	sb	a4,26(s1)
    800067ca:	00e48da3          	sb	a4,27(s1)
    800067ce:	00e48e23          	sb	a4,28(s1)
    800067d2:	00e48ea3          	sb	a4,29(s1)
    800067d6:	00e48f23          	sb	a4,30(s1)
    800067da:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800067de:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800067e2:	0727a823          	sw	s2,112(a5)
}
    800067e6:	60e2                	ld	ra,24(sp)
    800067e8:	6442                	ld	s0,16(sp)
    800067ea:	64a2                	ld	s1,8(sp)
    800067ec:	6902                	ld	s2,0(sp)
    800067ee:	6105                	add	sp,sp,32
    800067f0:	8082                	ret
    panic("could not find virtio disk");
    800067f2:	00002517          	auipc	a0,0x2
    800067f6:	fbe50513          	add	a0,a0,-66 # 800087b0 <etext+0x7b0>
    800067fa:	ffffa097          	auipc	ra,0xffffa
    800067fe:	d42080e7          	jalr	-702(ra) # 8000053c <panic>
    panic("virtio disk FEATURES_OK unset");
    80006802:	00002517          	auipc	a0,0x2
    80006806:	fce50513          	add	a0,a0,-50 # 800087d0 <etext+0x7d0>
    8000680a:	ffffa097          	auipc	ra,0xffffa
    8000680e:	d32080e7          	jalr	-718(ra) # 8000053c <panic>
    panic("virtio disk should not be ready");
    80006812:	00002517          	auipc	a0,0x2
    80006816:	fde50513          	add	a0,a0,-34 # 800087f0 <etext+0x7f0>
    8000681a:	ffffa097          	auipc	ra,0xffffa
    8000681e:	d22080e7          	jalr	-734(ra) # 8000053c <panic>
    panic("virtio disk has no queue 0");
    80006822:	00002517          	auipc	a0,0x2
    80006826:	fee50513          	add	a0,a0,-18 # 80008810 <etext+0x810>
    8000682a:	ffffa097          	auipc	ra,0xffffa
    8000682e:	d12080e7          	jalr	-750(ra) # 8000053c <panic>
    panic("virtio disk max queue too short");
    80006832:	00002517          	auipc	a0,0x2
    80006836:	ffe50513          	add	a0,a0,-2 # 80008830 <etext+0x830>
    8000683a:	ffffa097          	auipc	ra,0xffffa
    8000683e:	d02080e7          	jalr	-766(ra) # 8000053c <panic>
    panic("virtio disk kalloc");
    80006842:	00002517          	auipc	a0,0x2
    80006846:	00e50513          	add	a0,a0,14 # 80008850 <etext+0x850>
    8000684a:	ffffa097          	auipc	ra,0xffffa
    8000684e:	cf2080e7          	jalr	-782(ra) # 8000053c <panic>

0000000080006852 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006852:	7159                	add	sp,sp,-112
    80006854:	f486                	sd	ra,104(sp)
    80006856:	f0a2                	sd	s0,96(sp)
    80006858:	eca6                	sd	s1,88(sp)
    8000685a:	e8ca                	sd	s2,80(sp)
    8000685c:	e4ce                	sd	s3,72(sp)
    8000685e:	e0d2                	sd	s4,64(sp)
    80006860:	fc56                	sd	s5,56(sp)
    80006862:	f85a                	sd	s6,48(sp)
    80006864:	f45e                	sd	s7,40(sp)
    80006866:	f062                	sd	s8,32(sp)
    80006868:	ec66                	sd	s9,24(sp)
    8000686a:	e86a                	sd	s10,16(sp)
    8000686c:	1880                	add	s0,sp,112
    8000686e:	8a2a                	mv	s4,a0
    80006870:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006872:	00c52c83          	lw	s9,12(a0)
    80006876:	001c9c9b          	sllw	s9,s9,0x1
    8000687a:	1c82                	sll	s9,s9,0x20
    8000687c:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006880:	0023d517          	auipc	a0,0x23d
    80006884:	24050513          	add	a0,a0,576 # 80243ac0 <disk+0x128>
    80006888:	ffffa097          	auipc	ra,0xffffa
    8000688c:	448080e7          	jalr	1096(ra) # 80000cd0 <acquire>
  for(int i = 0; i < 3; i++){
    80006890:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    80006892:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006894:	0023db17          	auipc	s6,0x23d
    80006898:	104b0b13          	add	s6,s6,260 # 80243998 <disk>
  for(int i = 0; i < 3; i++){
    8000689c:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000689e:	0023dc17          	auipc	s8,0x23d
    800068a2:	222c0c13          	add	s8,s8,546 # 80243ac0 <disk+0x128>
    800068a6:	a095                	j	8000690a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800068a8:	00fb0733          	add	a4,s6,a5
    800068ac:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800068b0:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    800068b2:	0207c563          	bltz	a5,800068dc <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    800068b6:	2605                	addw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    800068b8:	0591                	add	a1,a1,4
    800068ba:	05560d63          	beq	a2,s5,80006914 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800068be:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    800068c0:	0023d717          	auipc	a4,0x23d
    800068c4:	0d870713          	add	a4,a4,216 # 80243998 <disk>
    800068c8:	87ca                	mv	a5,s2
    if(disk.free[i]){
    800068ca:	01874683          	lbu	a3,24(a4)
    800068ce:	fee9                	bnez	a3,800068a8 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    800068d0:	2785                	addw	a5,a5,1
    800068d2:	0705                	add	a4,a4,1
    800068d4:	fe979be3          	bne	a5,s1,800068ca <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    800068d8:	57fd                	li	a5,-1
    800068da:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    800068dc:	00c05e63          	blez	a2,800068f8 <virtio_disk_rw+0xa6>
    800068e0:	060a                	sll	a2,a2,0x2
    800068e2:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    800068e6:	0009a503          	lw	a0,0(s3)
    800068ea:	00000097          	auipc	ra,0x0
    800068ee:	cfc080e7          	jalr	-772(ra) # 800065e6 <free_desc>
      for(int j = 0; j < i; j++)
    800068f2:	0991                	add	s3,s3,4
    800068f4:	ffa999e3          	bne	s3,s10,800068e6 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800068f8:	85e2                	mv	a1,s8
    800068fa:	0023d517          	auipc	a0,0x23d
    800068fe:	0b650513          	add	a0,a0,182 # 802439b0 <disk+0x18>
    80006902:	ffffc097          	auipc	ra,0xffffc
    80006906:	df8080e7          	jalr	-520(ra) # 800026fa <sleep>
  for(int i = 0; i < 3; i++){
    8000690a:	f9040993          	add	s3,s0,-112
{
    8000690e:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80006910:	864a                	mv	a2,s2
    80006912:	b775                	j	800068be <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006914:	f9042503          	lw	a0,-112(s0)
    80006918:	00a50713          	add	a4,a0,10
    8000691c:	0712                	sll	a4,a4,0x4

  if(write)
    8000691e:	0023d797          	auipc	a5,0x23d
    80006922:	07a78793          	add	a5,a5,122 # 80243998 <disk>
    80006926:	00e786b3          	add	a3,a5,a4
    8000692a:	01703633          	snez	a2,s7
    8000692e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006930:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80006934:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006938:	f6070613          	add	a2,a4,-160
    8000693c:	6394                	ld	a3,0(a5)
    8000693e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006940:	00870593          	add	a1,a4,8
    80006944:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006946:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006948:	0007b803          	ld	a6,0(a5)
    8000694c:	9642                	add	a2,a2,a6
    8000694e:	46c1                	li	a3,16
    80006950:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006952:	4585                	li	a1,1
    80006954:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80006958:	f9442683          	lw	a3,-108(s0)
    8000695c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006960:	0692                	sll	a3,a3,0x4
    80006962:	9836                	add	a6,a6,a3
    80006964:	058a0613          	add	a2,s4,88
    80006968:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000696c:	0007b803          	ld	a6,0(a5)
    80006970:	96c2                	add	a3,a3,a6
    80006972:	40000613          	li	a2,1024
    80006976:	c690                	sw	a2,8(a3)
  if(write)
    80006978:	001bb613          	seqz	a2,s7
    8000697c:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006980:	00166613          	or	a2,a2,1
    80006984:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80006988:	f9842603          	lw	a2,-104(s0)
    8000698c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006990:	00250693          	add	a3,a0,2
    80006994:	0692                	sll	a3,a3,0x4
    80006996:	96be                	add	a3,a3,a5
    80006998:	58fd                	li	a7,-1
    8000699a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000699e:	0612                	sll	a2,a2,0x4
    800069a0:	9832                	add	a6,a6,a2
    800069a2:	f9070713          	add	a4,a4,-112
    800069a6:	973e                	add	a4,a4,a5
    800069a8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800069ac:	6398                	ld	a4,0(a5)
    800069ae:	9732                	add	a4,a4,a2
    800069b0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800069b2:	4609                	li	a2,2
    800069b4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800069b8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800069bc:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    800069c0:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800069c4:	6794                	ld	a3,8(a5)
    800069c6:	0026d703          	lhu	a4,2(a3)
    800069ca:	8b1d                	and	a4,a4,7
    800069cc:	0706                	sll	a4,a4,0x1
    800069ce:	96ba                	add	a3,a3,a4
    800069d0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800069d4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800069d8:	6798                	ld	a4,8(a5)
    800069da:	00275783          	lhu	a5,2(a4)
    800069de:	2785                	addw	a5,a5,1
    800069e0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800069e4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800069e8:	100017b7          	lui	a5,0x10001
    800069ec:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800069f0:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800069f4:	0023d917          	auipc	s2,0x23d
    800069f8:	0cc90913          	add	s2,s2,204 # 80243ac0 <disk+0x128>
  while(b->disk == 1) {
    800069fc:	4485                	li	s1,1
    800069fe:	00b79c63          	bne	a5,a1,80006a16 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006a02:	85ca                	mv	a1,s2
    80006a04:	8552                	mv	a0,s4
    80006a06:	ffffc097          	auipc	ra,0xffffc
    80006a0a:	cf4080e7          	jalr	-780(ra) # 800026fa <sleep>
  while(b->disk == 1) {
    80006a0e:	004a2783          	lw	a5,4(s4)
    80006a12:	fe9788e3          	beq	a5,s1,80006a02 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006a16:	f9042903          	lw	s2,-112(s0)
    80006a1a:	00290713          	add	a4,s2,2
    80006a1e:	0712                	sll	a4,a4,0x4
    80006a20:	0023d797          	auipc	a5,0x23d
    80006a24:	f7878793          	add	a5,a5,-136 # 80243998 <disk>
    80006a28:	97ba                	add	a5,a5,a4
    80006a2a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006a2e:	0023d997          	auipc	s3,0x23d
    80006a32:	f6a98993          	add	s3,s3,-150 # 80243998 <disk>
    80006a36:	00491713          	sll	a4,s2,0x4
    80006a3a:	0009b783          	ld	a5,0(s3)
    80006a3e:	97ba                	add	a5,a5,a4
    80006a40:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006a44:	854a                	mv	a0,s2
    80006a46:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006a4a:	00000097          	auipc	ra,0x0
    80006a4e:	b9c080e7          	jalr	-1124(ra) # 800065e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006a52:	8885                	and	s1,s1,1
    80006a54:	f0ed                	bnez	s1,80006a36 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006a56:	0023d517          	auipc	a0,0x23d
    80006a5a:	06a50513          	add	a0,a0,106 # 80243ac0 <disk+0x128>
    80006a5e:	ffffa097          	auipc	ra,0xffffa
    80006a62:	326080e7          	jalr	806(ra) # 80000d84 <release>
}
    80006a66:	70a6                	ld	ra,104(sp)
    80006a68:	7406                	ld	s0,96(sp)
    80006a6a:	64e6                	ld	s1,88(sp)
    80006a6c:	6946                	ld	s2,80(sp)
    80006a6e:	69a6                	ld	s3,72(sp)
    80006a70:	6a06                	ld	s4,64(sp)
    80006a72:	7ae2                	ld	s5,56(sp)
    80006a74:	7b42                	ld	s6,48(sp)
    80006a76:	7ba2                	ld	s7,40(sp)
    80006a78:	7c02                	ld	s8,32(sp)
    80006a7a:	6ce2                	ld	s9,24(sp)
    80006a7c:	6d42                	ld	s10,16(sp)
    80006a7e:	6165                	add	sp,sp,112
    80006a80:	8082                	ret

0000000080006a82 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006a82:	1101                	add	sp,sp,-32
    80006a84:	ec06                	sd	ra,24(sp)
    80006a86:	e822                	sd	s0,16(sp)
    80006a88:	e426                	sd	s1,8(sp)
    80006a8a:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006a8c:	0023d497          	auipc	s1,0x23d
    80006a90:	f0c48493          	add	s1,s1,-244 # 80243998 <disk>
    80006a94:	0023d517          	auipc	a0,0x23d
    80006a98:	02c50513          	add	a0,a0,44 # 80243ac0 <disk+0x128>
    80006a9c:	ffffa097          	auipc	ra,0xffffa
    80006aa0:	234080e7          	jalr	564(ra) # 80000cd0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006aa4:	10001737          	lui	a4,0x10001
    80006aa8:	533c                	lw	a5,96(a4)
    80006aaa:	8b8d                	and	a5,a5,3
    80006aac:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006aae:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006ab2:	689c                	ld	a5,16(s1)
    80006ab4:	0204d703          	lhu	a4,32(s1)
    80006ab8:	0027d783          	lhu	a5,2(a5)
    80006abc:	04f70863          	beq	a4,a5,80006b0c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006ac0:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006ac4:	6898                	ld	a4,16(s1)
    80006ac6:	0204d783          	lhu	a5,32(s1)
    80006aca:	8b9d                	and	a5,a5,7
    80006acc:	078e                	sll	a5,a5,0x3
    80006ace:	97ba                	add	a5,a5,a4
    80006ad0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006ad2:	00278713          	add	a4,a5,2
    80006ad6:	0712                	sll	a4,a4,0x4
    80006ad8:	9726                	add	a4,a4,s1
    80006ada:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006ade:	e721                	bnez	a4,80006b26 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006ae0:	0789                	add	a5,a5,2
    80006ae2:	0792                	sll	a5,a5,0x4
    80006ae4:	97a6                	add	a5,a5,s1
    80006ae6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006ae8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006aec:	ffffc097          	auipc	ra,0xffffc
    80006af0:	a40080e7          	jalr	-1472(ra) # 8000252c <wakeup>

    disk.used_idx += 1;
    80006af4:	0204d783          	lhu	a5,32(s1)
    80006af8:	2785                	addw	a5,a5,1
    80006afa:	17c2                	sll	a5,a5,0x30
    80006afc:	93c1                	srl	a5,a5,0x30
    80006afe:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006b02:	6898                	ld	a4,16(s1)
    80006b04:	00275703          	lhu	a4,2(a4)
    80006b08:	faf71ce3          	bne	a4,a5,80006ac0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80006b0c:	0023d517          	auipc	a0,0x23d
    80006b10:	fb450513          	add	a0,a0,-76 # 80243ac0 <disk+0x128>
    80006b14:	ffffa097          	auipc	ra,0xffffa
    80006b18:	270080e7          	jalr	624(ra) # 80000d84 <release>
}
    80006b1c:	60e2                	ld	ra,24(sp)
    80006b1e:	6442                	ld	s0,16(sp)
    80006b20:	64a2                	ld	s1,8(sp)
    80006b22:	6105                	add	sp,sp,32
    80006b24:	8082                	ret
      panic("virtio_disk_intr status");
    80006b26:	00002517          	auipc	a0,0x2
    80006b2a:	d4250513          	add	a0,a0,-702 # 80008868 <etext+0x868>
    80006b2e:	ffffa097          	auipc	ra,0xffffa
    80006b32:	a0e080e7          	jalr	-1522(ra) # 8000053c <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	sll	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	sll	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
