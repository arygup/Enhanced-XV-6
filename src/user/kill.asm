
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	add	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7dd63          	bge	a5,a0,48 <main+0x48>
  12:	00858493          	add	s1,a1,8
  16:	ffe5091b          	addw	s2,a0,-2
  1a:	02091793          	sll	a5,s2,0x20
  1e:	01d7d913          	srl	s2,a5,0x1d
  22:	05c1                	add	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1c8080e7          	jalr	456(ra) # 1f0 <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	2ea080e7          	jalr	746(ra) # 31a <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	add	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	2aa080e7          	jalr	682(ra) # 2ea <exit>
    fprintf(2, "usage: kill pid...\n");
  48:	00000597          	auipc	a1,0x0
  4c:	7d858593          	add	a1,a1,2008 # 820 <malloc+0xee>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	5fa080e7          	jalr	1530(ra) # 64c <fprintf>
    exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	28e080e7          	jalr	654(ra) # 2ea <exit>

0000000000000064 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  64:	1141                	add	sp,sp,-16
  66:	e406                	sd	ra,8(sp)
  68:	e022                	sd	s0,0(sp)
  6a:	0800                	add	s0,sp,16
  extern int main();
  main();
  6c:	00000097          	auipc	ra,0x0
  70:	f94080e7          	jalr	-108(ra) # 0 <main>
  exit(0);
  74:	4501                	li	a0,0
  76:	00000097          	auipc	ra,0x0
  7a:	274080e7          	jalr	628(ra) # 2ea <exit>

000000000000007e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  7e:	1141                	add	sp,sp,-16
  80:	e422                	sd	s0,8(sp)
  82:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  84:	87aa                	mv	a5,a0
  86:	0585                	add	a1,a1,1
  88:	0785                	add	a5,a5,1
  8a:	fff5c703          	lbu	a4,-1(a1)
  8e:	fee78fa3          	sb	a4,-1(a5)
  92:	fb75                	bnez	a4,86 <strcpy+0x8>
    ;
  return os;
}
  94:	6422                	ld	s0,8(sp)
  96:	0141                	add	sp,sp,16
  98:	8082                	ret

000000000000009a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9a:	1141                	add	sp,sp,-16
  9c:	e422                	sd	s0,8(sp)
  9e:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  a0:	00054783          	lbu	a5,0(a0)
  a4:	cb91                	beqz	a5,b8 <strcmp+0x1e>
  a6:	0005c703          	lbu	a4,0(a1)
  aa:	00f71763          	bne	a4,a5,b8 <strcmp+0x1e>
    p++, q++;
  ae:	0505                	add	a0,a0,1
  b0:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  b2:	00054783          	lbu	a5,0(a0)
  b6:	fbe5                	bnez	a5,a6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b8:	0005c503          	lbu	a0,0(a1)
}
  bc:	40a7853b          	subw	a0,a5,a0
  c0:	6422                	ld	s0,8(sp)
  c2:	0141                	add	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strlen>:

uint
strlen(const char *s)
{
  c6:	1141                	add	sp,sp,-16
  c8:	e422                	sd	s0,8(sp)
  ca:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	cf91                	beqz	a5,ec <strlen+0x26>
  d2:	0505                	add	a0,a0,1
  d4:	87aa                	mv	a5,a0
  d6:	86be                	mv	a3,a5
  d8:	0785                	add	a5,a5,1
  da:	fff7c703          	lbu	a4,-1(a5)
  de:	ff65                	bnez	a4,d6 <strlen+0x10>
  e0:	40a6853b          	subw	a0,a3,a0
  e4:	2505                	addw	a0,a0,1
    ;
  return n;
}
  e6:	6422                	ld	s0,8(sp)
  e8:	0141                	add	sp,sp,16
  ea:	8082                	ret
  for(n = 0; s[n]; n++)
  ec:	4501                	li	a0,0
  ee:	bfe5                	j	e6 <strlen+0x20>

00000000000000f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f0:	1141                	add	sp,sp,-16
  f2:	e422                	sd	s0,8(sp)
  f4:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f6:	ca19                	beqz	a2,10c <memset+0x1c>
  f8:	87aa                	mv	a5,a0
  fa:	1602                	sll	a2,a2,0x20
  fc:	9201                	srl	a2,a2,0x20
  fe:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 102:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 106:	0785                	add	a5,a5,1
 108:	fee79de3          	bne	a5,a4,102 <memset+0x12>
  }
  return dst;
}
 10c:	6422                	ld	s0,8(sp)
 10e:	0141                	add	sp,sp,16
 110:	8082                	ret

0000000000000112 <strchr>:

char*
strchr(const char *s, char c)
{
 112:	1141                	add	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	add	s0,sp,16
  for(; *s; s++)
 118:	00054783          	lbu	a5,0(a0)
 11c:	cb99                	beqz	a5,132 <strchr+0x20>
    if(*s == c)
 11e:	00f58763          	beq	a1,a5,12c <strchr+0x1a>
  for(; *s; s++)
 122:	0505                	add	a0,a0,1
 124:	00054783          	lbu	a5,0(a0)
 128:	fbfd                	bnez	a5,11e <strchr+0xc>
      return (char*)s;
  return 0;
 12a:	4501                	li	a0,0
}
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	add	sp,sp,16
 130:	8082                	ret
  return 0;
 132:	4501                	li	a0,0
 134:	bfe5                	j	12c <strchr+0x1a>

0000000000000136 <gets>:

char*
gets(char *buf, int max)
{
 136:	711d                	add	sp,sp,-96
 138:	ec86                	sd	ra,88(sp)
 13a:	e8a2                	sd	s0,80(sp)
 13c:	e4a6                	sd	s1,72(sp)
 13e:	e0ca                	sd	s2,64(sp)
 140:	fc4e                	sd	s3,56(sp)
 142:	f852                	sd	s4,48(sp)
 144:	f456                	sd	s5,40(sp)
 146:	f05a                	sd	s6,32(sp)
 148:	ec5e                	sd	s7,24(sp)
 14a:	1080                	add	s0,sp,96
 14c:	8baa                	mv	s7,a0
 14e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 150:	892a                	mv	s2,a0
 152:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 154:	4aa9                	li	s5,10
 156:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 158:	89a6                	mv	s3,s1
 15a:	2485                	addw	s1,s1,1
 15c:	0344d863          	bge	s1,s4,18c <gets+0x56>
    cc = read(0, &c, 1);
 160:	4605                	li	a2,1
 162:	faf40593          	add	a1,s0,-81
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	19a080e7          	jalr	410(ra) # 302 <read>
    if(cc < 1)
 170:	00a05e63          	blez	a0,18c <gets+0x56>
    buf[i++] = c;
 174:	faf44783          	lbu	a5,-81(s0)
 178:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 17c:	01578763          	beq	a5,s5,18a <gets+0x54>
 180:	0905                	add	s2,s2,1
 182:	fd679be3          	bne	a5,s6,158 <gets+0x22>
  for(i=0; i+1 < max; ){
 186:	89a6                	mv	s3,s1
 188:	a011                	j	18c <gets+0x56>
 18a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 18c:	99de                	add	s3,s3,s7
 18e:	00098023          	sb	zero,0(s3)
  return buf;
}
 192:	855e                	mv	a0,s7
 194:	60e6                	ld	ra,88(sp)
 196:	6446                	ld	s0,80(sp)
 198:	64a6                	ld	s1,72(sp)
 19a:	6906                	ld	s2,64(sp)
 19c:	79e2                	ld	s3,56(sp)
 19e:	7a42                	ld	s4,48(sp)
 1a0:	7aa2                	ld	s5,40(sp)
 1a2:	7b02                	ld	s6,32(sp)
 1a4:	6be2                	ld	s7,24(sp)
 1a6:	6125                	add	sp,sp,96
 1a8:	8082                	ret

00000000000001aa <stat>:

int
stat(const char *n, struct stat *st)
{
 1aa:	1101                	add	sp,sp,-32
 1ac:	ec06                	sd	ra,24(sp)
 1ae:	e822                	sd	s0,16(sp)
 1b0:	e426                	sd	s1,8(sp)
 1b2:	e04a                	sd	s2,0(sp)
 1b4:	1000                	add	s0,sp,32
 1b6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b8:	4581                	li	a1,0
 1ba:	00000097          	auipc	ra,0x0
 1be:	170080e7          	jalr	368(ra) # 32a <open>
  if(fd < 0)
 1c2:	02054563          	bltz	a0,1ec <stat+0x42>
 1c6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c8:	85ca                	mv	a1,s2
 1ca:	00000097          	auipc	ra,0x0
 1ce:	178080e7          	jalr	376(ra) # 342 <fstat>
 1d2:	892a                	mv	s2,a0
  close(fd);
 1d4:	8526                	mv	a0,s1
 1d6:	00000097          	auipc	ra,0x0
 1da:	13c080e7          	jalr	316(ra) # 312 <close>
  return r;
}
 1de:	854a                	mv	a0,s2
 1e0:	60e2                	ld	ra,24(sp)
 1e2:	6442                	ld	s0,16(sp)
 1e4:	64a2                	ld	s1,8(sp)
 1e6:	6902                	ld	s2,0(sp)
 1e8:	6105                	add	sp,sp,32
 1ea:	8082                	ret
    return -1;
 1ec:	597d                	li	s2,-1
 1ee:	bfc5                	j	1de <stat+0x34>

00000000000001f0 <atoi>:

int
atoi(const char *s)
{
 1f0:	1141                	add	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f6:	00054683          	lbu	a3,0(a0)
 1fa:	fd06879b          	addw	a5,a3,-48
 1fe:	0ff7f793          	zext.b	a5,a5
 202:	4625                	li	a2,9
 204:	02f66863          	bltu	a2,a5,234 <atoi+0x44>
 208:	872a                	mv	a4,a0
  n = 0;
 20a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 20c:	0705                	add	a4,a4,1
 20e:	0025179b          	sllw	a5,a0,0x2
 212:	9fa9                	addw	a5,a5,a0
 214:	0017979b          	sllw	a5,a5,0x1
 218:	9fb5                	addw	a5,a5,a3
 21a:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21e:	00074683          	lbu	a3,0(a4)
 222:	fd06879b          	addw	a5,a3,-48
 226:	0ff7f793          	zext.b	a5,a5
 22a:	fef671e3          	bgeu	a2,a5,20c <atoi+0x1c>
  return n;
}
 22e:	6422                	ld	s0,8(sp)
 230:	0141                	add	sp,sp,16
 232:	8082                	ret
  n = 0;
 234:	4501                	li	a0,0
 236:	bfe5                	j	22e <atoi+0x3e>

0000000000000238 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 238:	1141                	add	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23e:	02b57463          	bgeu	a0,a1,266 <memmove+0x2e>
    while(n-- > 0)
 242:	00c05f63          	blez	a2,260 <memmove+0x28>
 246:	1602                	sll	a2,a2,0x20
 248:	9201                	srl	a2,a2,0x20
 24a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24e:	872a                	mv	a4,a0
      *dst++ = *src++;
 250:	0585                	add	a1,a1,1
 252:	0705                	add	a4,a4,1
 254:	fff5c683          	lbu	a3,-1(a1)
 258:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 25c:	fee79ae3          	bne	a5,a4,250 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 260:	6422                	ld	s0,8(sp)
 262:	0141                	add	sp,sp,16
 264:	8082                	ret
    dst += n;
 266:	00c50733          	add	a4,a0,a2
    src += n;
 26a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 26c:	fec05ae3          	blez	a2,260 <memmove+0x28>
 270:	fff6079b          	addw	a5,a2,-1
 274:	1782                	sll	a5,a5,0x20
 276:	9381                	srl	a5,a5,0x20
 278:	fff7c793          	not	a5,a5
 27c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27e:	15fd                	add	a1,a1,-1
 280:	177d                	add	a4,a4,-1
 282:	0005c683          	lbu	a3,0(a1)
 286:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 28a:	fee79ae3          	bne	a5,a4,27e <memmove+0x46>
 28e:	bfc9                	j	260 <memmove+0x28>

0000000000000290 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 290:	1141                	add	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 296:	ca05                	beqz	a2,2c6 <memcmp+0x36>
 298:	fff6069b          	addw	a3,a2,-1
 29c:	1682                	sll	a3,a3,0x20
 29e:	9281                	srl	a3,a3,0x20
 2a0:	0685                	add	a3,a3,1
 2a2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	0005c703          	lbu	a4,0(a1)
 2ac:	00e79863          	bne	a5,a4,2bc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2b0:	0505                	add	a0,a0,1
    p2++;
 2b2:	0585                	add	a1,a1,1
  while (n-- > 0) {
 2b4:	fed518e3          	bne	a0,a3,2a4 <memcmp+0x14>
  }
  return 0;
 2b8:	4501                	li	a0,0
 2ba:	a019                	j	2c0 <memcmp+0x30>
      return *p1 - *p2;
 2bc:	40e7853b          	subw	a0,a5,a4
}
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	add	sp,sp,16
 2c4:	8082                	ret
  return 0;
 2c6:	4501                	li	a0,0
 2c8:	bfe5                	j	2c0 <memcmp+0x30>

00000000000002ca <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ca:	1141                	add	sp,sp,-16
 2cc:	e406                	sd	ra,8(sp)
 2ce:	e022                	sd	s0,0(sp)
 2d0:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2d2:	00000097          	auipc	ra,0x0
 2d6:	f66080e7          	jalr	-154(ra) # 238 <memmove>
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	add	sp,sp,16
 2e0:	8082                	ret

00000000000002e2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e2:	4885                	li	a7,1
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ea:	4889                	li	a7,2
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f2:	488d                	li	a7,3
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2fa:	4891                	li	a7,4
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <read>:
.global read
read:
 li a7, SYS_read
 302:	4895                	li	a7,5
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <write>:
.global write
write:
 li a7, SYS_write
 30a:	48c1                	li	a7,16
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <close>:
.global close
close:
 li a7, SYS_close
 312:	48d5                	li	a7,21
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <kill>:
.global kill
kill:
 li a7, SYS_kill
 31a:	4899                	li	a7,6
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <exec>:
.global exec
exec:
 li a7, SYS_exec
 322:	489d                	li	a7,7
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <open>:
.global open
open:
 li a7, SYS_open
 32a:	48bd                	li	a7,15
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 332:	48c5                	li	a7,17
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 33a:	48c9                	li	a7,18
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 342:	48a1                	li	a7,8
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <link>:
.global link
link:
 li a7, SYS_link
 34a:	48cd                	li	a7,19
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 352:	48d1                	li	a7,20
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 35a:	48a5                	li	a7,9
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <dup>:
.global dup
dup:
 li a7, SYS_dup
 362:	48a9                	li	a7,10
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 36a:	48ad                	li	a7,11
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 372:	48b1                	li	a7,12
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 37a:	48b5                	li	a7,13
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 382:	48b9                	li	a7,14
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 38a:	48d9                	li	a7,22
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <getreadcount>:
.global getreadcount
getreadcount:
 li a7, SYS_getreadcount
 392:	48dd                	li	a7,23
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 39a:	48e1                	li	a7,24
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 3a2:	48e5                	li	a7,25
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 3aa:	48e9                	li	a7,26
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b2:	1101                	add	sp,sp,-32
 3b4:	ec06                	sd	ra,24(sp)
 3b6:	e822                	sd	s0,16(sp)
 3b8:	1000                	add	s0,sp,32
 3ba:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3be:	4605                	li	a2,1
 3c0:	fef40593          	add	a1,s0,-17
 3c4:	00000097          	auipc	ra,0x0
 3c8:	f46080e7          	jalr	-186(ra) # 30a <write>
}
 3cc:	60e2                	ld	ra,24(sp)
 3ce:	6442                	ld	s0,16(sp)
 3d0:	6105                	add	sp,sp,32
 3d2:	8082                	ret

00000000000003d4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d4:	7139                	add	sp,sp,-64
 3d6:	fc06                	sd	ra,56(sp)
 3d8:	f822                	sd	s0,48(sp)
 3da:	f426                	sd	s1,40(sp)
 3dc:	f04a                	sd	s2,32(sp)
 3de:	ec4e                	sd	s3,24(sp)
 3e0:	0080                	add	s0,sp,64
 3e2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e4:	c299                	beqz	a3,3ea <printint+0x16>
 3e6:	0805c963          	bltz	a1,478 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ea:	2581                	sext.w	a1,a1
  neg = 0;
 3ec:	4881                	li	a7,0
 3ee:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 3f2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3f4:	2601                	sext.w	a2,a2
 3f6:	00000517          	auipc	a0,0x0
 3fa:	4a250513          	add	a0,a0,1186 # 898 <digits>
 3fe:	883a                	mv	a6,a4
 400:	2705                	addw	a4,a4,1
 402:	02c5f7bb          	remuw	a5,a1,a2
 406:	1782                	sll	a5,a5,0x20
 408:	9381                	srl	a5,a5,0x20
 40a:	97aa                	add	a5,a5,a0
 40c:	0007c783          	lbu	a5,0(a5)
 410:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 414:	0005879b          	sext.w	a5,a1
 418:	02c5d5bb          	divuw	a1,a1,a2
 41c:	0685                	add	a3,a3,1
 41e:	fec7f0e3          	bgeu	a5,a2,3fe <printint+0x2a>
  if(neg)
 422:	00088c63          	beqz	a7,43a <printint+0x66>
    buf[i++] = '-';
 426:	fd070793          	add	a5,a4,-48
 42a:	00878733          	add	a4,a5,s0
 42e:	02d00793          	li	a5,45
 432:	fef70823          	sb	a5,-16(a4)
 436:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 43a:	02e05863          	blez	a4,46a <printint+0x96>
 43e:	fc040793          	add	a5,s0,-64
 442:	00e78933          	add	s2,a5,a4
 446:	fff78993          	add	s3,a5,-1
 44a:	99ba                	add	s3,s3,a4
 44c:	377d                	addw	a4,a4,-1
 44e:	1702                	sll	a4,a4,0x20
 450:	9301                	srl	a4,a4,0x20
 452:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 456:	fff94583          	lbu	a1,-1(s2)
 45a:	8526                	mv	a0,s1
 45c:	00000097          	auipc	ra,0x0
 460:	f56080e7          	jalr	-170(ra) # 3b2 <putc>
  while(--i >= 0)
 464:	197d                	add	s2,s2,-1
 466:	ff3918e3          	bne	s2,s3,456 <printint+0x82>
}
 46a:	70e2                	ld	ra,56(sp)
 46c:	7442                	ld	s0,48(sp)
 46e:	74a2                	ld	s1,40(sp)
 470:	7902                	ld	s2,32(sp)
 472:	69e2                	ld	s3,24(sp)
 474:	6121                	add	sp,sp,64
 476:	8082                	ret
    x = -xx;
 478:	40b005bb          	negw	a1,a1
    neg = 1;
 47c:	4885                	li	a7,1
    x = -xx;
 47e:	bf85                	j	3ee <printint+0x1a>

0000000000000480 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 480:	715d                	add	sp,sp,-80
 482:	e486                	sd	ra,72(sp)
 484:	e0a2                	sd	s0,64(sp)
 486:	fc26                	sd	s1,56(sp)
 488:	f84a                	sd	s2,48(sp)
 48a:	f44e                	sd	s3,40(sp)
 48c:	f052                	sd	s4,32(sp)
 48e:	ec56                	sd	s5,24(sp)
 490:	e85a                	sd	s6,16(sp)
 492:	e45e                	sd	s7,8(sp)
 494:	e062                	sd	s8,0(sp)
 496:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 498:	0005c903          	lbu	s2,0(a1)
 49c:	18090c63          	beqz	s2,634 <vprintf+0x1b4>
 4a0:	8aaa                	mv	s5,a0
 4a2:	8bb2                	mv	s7,a2
 4a4:	00158493          	add	s1,a1,1
  state = 0;
 4a8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4aa:	02500a13          	li	s4,37
 4ae:	4b55                	li	s6,21
 4b0:	a839                	j	4ce <vprintf+0x4e>
        putc(fd, c);
 4b2:	85ca                	mv	a1,s2
 4b4:	8556                	mv	a0,s5
 4b6:	00000097          	auipc	ra,0x0
 4ba:	efc080e7          	jalr	-260(ra) # 3b2 <putc>
 4be:	a019                	j	4c4 <vprintf+0x44>
    } else if(state == '%'){
 4c0:	01498d63          	beq	s3,s4,4da <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 4c4:	0485                	add	s1,s1,1
 4c6:	fff4c903          	lbu	s2,-1(s1)
 4ca:	16090563          	beqz	s2,634 <vprintf+0x1b4>
    if(state == 0){
 4ce:	fe0999e3          	bnez	s3,4c0 <vprintf+0x40>
      if(c == '%'){
 4d2:	ff4910e3          	bne	s2,s4,4b2 <vprintf+0x32>
        state = '%';
 4d6:	89d2                	mv	s3,s4
 4d8:	b7f5                	j	4c4 <vprintf+0x44>
      if(c == 'd'){
 4da:	13490263          	beq	s2,s4,5fe <vprintf+0x17e>
 4de:	f9d9079b          	addw	a5,s2,-99
 4e2:	0ff7f793          	zext.b	a5,a5
 4e6:	12fb6563          	bltu	s6,a5,610 <vprintf+0x190>
 4ea:	f9d9079b          	addw	a5,s2,-99
 4ee:	0ff7f713          	zext.b	a4,a5
 4f2:	10eb6f63          	bltu	s6,a4,610 <vprintf+0x190>
 4f6:	00271793          	sll	a5,a4,0x2
 4fa:	00000717          	auipc	a4,0x0
 4fe:	34670713          	add	a4,a4,838 # 840 <malloc+0x10e>
 502:	97ba                	add	a5,a5,a4
 504:	439c                	lw	a5,0(a5)
 506:	97ba                	add	a5,a5,a4
 508:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 50a:	008b8913          	add	s2,s7,8
 50e:	4685                	li	a3,1
 510:	4629                	li	a2,10
 512:	000ba583          	lw	a1,0(s7)
 516:	8556                	mv	a0,s5
 518:	00000097          	auipc	ra,0x0
 51c:	ebc080e7          	jalr	-324(ra) # 3d4 <printint>
 520:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 522:	4981                	li	s3,0
 524:	b745                	j	4c4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 526:	008b8913          	add	s2,s7,8
 52a:	4681                	li	a3,0
 52c:	4629                	li	a2,10
 52e:	000ba583          	lw	a1,0(s7)
 532:	8556                	mv	a0,s5
 534:	00000097          	auipc	ra,0x0
 538:	ea0080e7          	jalr	-352(ra) # 3d4 <printint>
 53c:	8bca                	mv	s7,s2
      state = 0;
 53e:	4981                	li	s3,0
 540:	b751                	j	4c4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 542:	008b8913          	add	s2,s7,8
 546:	4681                	li	a3,0
 548:	4641                	li	a2,16
 54a:	000ba583          	lw	a1,0(s7)
 54e:	8556                	mv	a0,s5
 550:	00000097          	auipc	ra,0x0
 554:	e84080e7          	jalr	-380(ra) # 3d4 <printint>
 558:	8bca                	mv	s7,s2
      state = 0;
 55a:	4981                	li	s3,0
 55c:	b7a5                	j	4c4 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 55e:	008b8c13          	add	s8,s7,8
 562:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 566:	03000593          	li	a1,48
 56a:	8556                	mv	a0,s5
 56c:	00000097          	auipc	ra,0x0
 570:	e46080e7          	jalr	-442(ra) # 3b2 <putc>
  putc(fd, 'x');
 574:	07800593          	li	a1,120
 578:	8556                	mv	a0,s5
 57a:	00000097          	auipc	ra,0x0
 57e:	e38080e7          	jalr	-456(ra) # 3b2 <putc>
 582:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 584:	00000b97          	auipc	s7,0x0
 588:	314b8b93          	add	s7,s7,788 # 898 <digits>
 58c:	03c9d793          	srl	a5,s3,0x3c
 590:	97de                	add	a5,a5,s7
 592:	0007c583          	lbu	a1,0(a5)
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	e1a080e7          	jalr	-486(ra) # 3b2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5a0:	0992                	sll	s3,s3,0x4
 5a2:	397d                	addw	s2,s2,-1
 5a4:	fe0914e3          	bnez	s2,58c <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5a8:	8be2                	mv	s7,s8
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	bf21                	j	4c4 <vprintf+0x44>
        s = va_arg(ap, char*);
 5ae:	008b8993          	add	s3,s7,8
 5b2:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5b6:	02090163          	beqz	s2,5d8 <vprintf+0x158>
        while(*s != 0){
 5ba:	00094583          	lbu	a1,0(s2)
 5be:	c9a5                	beqz	a1,62e <vprintf+0x1ae>
          putc(fd, *s);
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	df0080e7          	jalr	-528(ra) # 3b2 <putc>
          s++;
 5ca:	0905                	add	s2,s2,1
        while(*s != 0){
 5cc:	00094583          	lbu	a1,0(s2)
 5d0:	f9e5                	bnez	a1,5c0 <vprintf+0x140>
        s = va_arg(ap, char*);
 5d2:	8bce                	mv	s7,s3
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	b5fd                	j	4c4 <vprintf+0x44>
          s = "(null)";
 5d8:	00000917          	auipc	s2,0x0
 5dc:	26090913          	add	s2,s2,608 # 838 <malloc+0x106>
        while(*s != 0){
 5e0:	02800593          	li	a1,40
 5e4:	bff1                	j	5c0 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 5e6:	008b8913          	add	s2,s7,8
 5ea:	000bc583          	lbu	a1,0(s7)
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	dc2080e7          	jalr	-574(ra) # 3b2 <putc>
 5f8:	8bca                	mv	s7,s2
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b5e1                	j	4c4 <vprintf+0x44>
        putc(fd, c);
 5fe:	02500593          	li	a1,37
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	dae080e7          	jalr	-594(ra) # 3b2 <putc>
      state = 0;
 60c:	4981                	li	s3,0
 60e:	bd5d                	j	4c4 <vprintf+0x44>
        putc(fd, '%');
 610:	02500593          	li	a1,37
 614:	8556                	mv	a0,s5
 616:	00000097          	auipc	ra,0x0
 61a:	d9c080e7          	jalr	-612(ra) # 3b2 <putc>
        putc(fd, c);
 61e:	85ca                	mv	a1,s2
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	d90080e7          	jalr	-624(ra) # 3b2 <putc>
      state = 0;
 62a:	4981                	li	s3,0
 62c:	bd61                	j	4c4 <vprintf+0x44>
        s = va_arg(ap, char*);
 62e:	8bce                	mv	s7,s3
      state = 0;
 630:	4981                	li	s3,0
 632:	bd49                	j	4c4 <vprintf+0x44>
    }
  }
}
 634:	60a6                	ld	ra,72(sp)
 636:	6406                	ld	s0,64(sp)
 638:	74e2                	ld	s1,56(sp)
 63a:	7942                	ld	s2,48(sp)
 63c:	79a2                	ld	s3,40(sp)
 63e:	7a02                	ld	s4,32(sp)
 640:	6ae2                	ld	s5,24(sp)
 642:	6b42                	ld	s6,16(sp)
 644:	6ba2                	ld	s7,8(sp)
 646:	6c02                	ld	s8,0(sp)
 648:	6161                	add	sp,sp,80
 64a:	8082                	ret

000000000000064c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 64c:	715d                	add	sp,sp,-80
 64e:	ec06                	sd	ra,24(sp)
 650:	e822                	sd	s0,16(sp)
 652:	1000                	add	s0,sp,32
 654:	e010                	sd	a2,0(s0)
 656:	e414                	sd	a3,8(s0)
 658:	e818                	sd	a4,16(s0)
 65a:	ec1c                	sd	a5,24(s0)
 65c:	03043023          	sd	a6,32(s0)
 660:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 664:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 668:	8622                	mv	a2,s0
 66a:	00000097          	auipc	ra,0x0
 66e:	e16080e7          	jalr	-490(ra) # 480 <vprintf>
}
 672:	60e2                	ld	ra,24(sp)
 674:	6442                	ld	s0,16(sp)
 676:	6161                	add	sp,sp,80
 678:	8082                	ret

000000000000067a <printf>:

void
printf(const char *fmt, ...)
{
 67a:	711d                	add	sp,sp,-96
 67c:	ec06                	sd	ra,24(sp)
 67e:	e822                	sd	s0,16(sp)
 680:	1000                	add	s0,sp,32
 682:	e40c                	sd	a1,8(s0)
 684:	e810                	sd	a2,16(s0)
 686:	ec14                	sd	a3,24(s0)
 688:	f018                	sd	a4,32(s0)
 68a:	f41c                	sd	a5,40(s0)
 68c:	03043823          	sd	a6,48(s0)
 690:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 694:	00840613          	add	a2,s0,8
 698:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 69c:	85aa                	mv	a1,a0
 69e:	4505                	li	a0,1
 6a0:	00000097          	auipc	ra,0x0
 6a4:	de0080e7          	jalr	-544(ra) # 480 <vprintf>
}
 6a8:	60e2                	ld	ra,24(sp)
 6aa:	6442                	ld	s0,16(sp)
 6ac:	6125                	add	sp,sp,96
 6ae:	8082                	ret

00000000000006b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b0:	1141                	add	sp,sp,-16
 6b2:	e422                	sd	s0,8(sp)
 6b4:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b6:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ba:	00001797          	auipc	a5,0x1
 6be:	9467b783          	ld	a5,-1722(a5) # 1000 <freep>
 6c2:	a02d                	j	6ec <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6c4:	4618                	lw	a4,8(a2)
 6c6:	9f2d                	addw	a4,a4,a1
 6c8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6cc:	6398                	ld	a4,0(a5)
 6ce:	6310                	ld	a2,0(a4)
 6d0:	a83d                	j	70e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6d2:	ff852703          	lw	a4,-8(a0)
 6d6:	9f31                	addw	a4,a4,a2
 6d8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6da:	ff053683          	ld	a3,-16(a0)
 6de:	a091                	j	722 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e0:	6398                	ld	a4,0(a5)
 6e2:	00e7e463          	bltu	a5,a4,6ea <free+0x3a>
 6e6:	00e6ea63          	bltu	a3,a4,6fa <free+0x4a>
{
 6ea:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ec:	fed7fae3          	bgeu	a5,a3,6e0 <free+0x30>
 6f0:	6398                	ld	a4,0(a5)
 6f2:	00e6e463          	bltu	a3,a4,6fa <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f6:	fee7eae3          	bltu	a5,a4,6ea <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6fa:	ff852583          	lw	a1,-8(a0)
 6fe:	6390                	ld	a2,0(a5)
 700:	02059813          	sll	a6,a1,0x20
 704:	01c85713          	srl	a4,a6,0x1c
 708:	9736                	add	a4,a4,a3
 70a:	fae60de3          	beq	a2,a4,6c4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 70e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 712:	4790                	lw	a2,8(a5)
 714:	02061593          	sll	a1,a2,0x20
 718:	01c5d713          	srl	a4,a1,0x1c
 71c:	973e                	add	a4,a4,a5
 71e:	fae68ae3          	beq	a3,a4,6d2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 722:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 724:	00001717          	auipc	a4,0x1
 728:	8cf73e23          	sd	a5,-1828(a4) # 1000 <freep>
}
 72c:	6422                	ld	s0,8(sp)
 72e:	0141                	add	sp,sp,16
 730:	8082                	ret

0000000000000732 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 732:	7139                	add	sp,sp,-64
 734:	fc06                	sd	ra,56(sp)
 736:	f822                	sd	s0,48(sp)
 738:	f426                	sd	s1,40(sp)
 73a:	f04a                	sd	s2,32(sp)
 73c:	ec4e                	sd	s3,24(sp)
 73e:	e852                	sd	s4,16(sp)
 740:	e456                	sd	s5,8(sp)
 742:	e05a                	sd	s6,0(sp)
 744:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 746:	02051493          	sll	s1,a0,0x20
 74a:	9081                	srl	s1,s1,0x20
 74c:	04bd                	add	s1,s1,15
 74e:	8091                	srl	s1,s1,0x4
 750:	0014899b          	addw	s3,s1,1
 754:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 756:	00001517          	auipc	a0,0x1
 75a:	8aa53503          	ld	a0,-1878(a0) # 1000 <freep>
 75e:	c515                	beqz	a0,78a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 760:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 762:	4798                	lw	a4,8(a5)
 764:	02977f63          	bgeu	a4,s1,7a2 <malloc+0x70>
  if(nu < 4096)
 768:	8a4e                	mv	s4,s3
 76a:	0009871b          	sext.w	a4,s3
 76e:	6685                	lui	a3,0x1
 770:	00d77363          	bgeu	a4,a3,776 <malloc+0x44>
 774:	6a05                	lui	s4,0x1
 776:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 77a:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 77e:	00001917          	auipc	s2,0x1
 782:	88290913          	add	s2,s2,-1918 # 1000 <freep>
  if(p == (char*)-1)
 786:	5afd                	li	s5,-1
 788:	a895                	j	7fc <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 78a:	00001797          	auipc	a5,0x1
 78e:	88678793          	add	a5,a5,-1914 # 1010 <base>
 792:	00001717          	auipc	a4,0x1
 796:	86f73723          	sd	a5,-1938(a4) # 1000 <freep>
 79a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 79c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7a0:	b7e1                	j	768 <malloc+0x36>
      if(p->s.size == nunits)
 7a2:	02e48c63          	beq	s1,a4,7da <malloc+0xa8>
        p->s.size -= nunits;
 7a6:	4137073b          	subw	a4,a4,s3
 7aa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7ac:	02071693          	sll	a3,a4,0x20
 7b0:	01c6d713          	srl	a4,a3,0x1c
 7b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7ba:	00001717          	auipc	a4,0x1
 7be:	84a73323          	sd	a0,-1978(a4) # 1000 <freep>
      return (void*)(p + 1);
 7c2:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7c6:	70e2                	ld	ra,56(sp)
 7c8:	7442                	ld	s0,48(sp)
 7ca:	74a2                	ld	s1,40(sp)
 7cc:	7902                	ld	s2,32(sp)
 7ce:	69e2                	ld	s3,24(sp)
 7d0:	6a42                	ld	s4,16(sp)
 7d2:	6aa2                	ld	s5,8(sp)
 7d4:	6b02                	ld	s6,0(sp)
 7d6:	6121                	add	sp,sp,64
 7d8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7da:	6398                	ld	a4,0(a5)
 7dc:	e118                	sd	a4,0(a0)
 7de:	bff1                	j	7ba <malloc+0x88>
  hp->s.size = nu;
 7e0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7e4:	0541                	add	a0,a0,16
 7e6:	00000097          	auipc	ra,0x0
 7ea:	eca080e7          	jalr	-310(ra) # 6b0 <free>
  return freep;
 7ee:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7f2:	d971                	beqz	a0,7c6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f6:	4798                	lw	a4,8(a5)
 7f8:	fa9775e3          	bgeu	a4,s1,7a2 <malloc+0x70>
    if(p == freep)
 7fc:	00093703          	ld	a4,0(s2)
 800:	853e                	mv	a0,a5
 802:	fef719e3          	bne	a4,a5,7f4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 806:	8552                	mv	a0,s4
 808:	00000097          	auipc	ra,0x0
 80c:	b6a080e7          	jalr	-1174(ra) # 372 <sbrk>
  if(p == (char*)-1)
 810:	fd5518e3          	bne	a0,s5,7e0 <malloc+0xae>
        return 0;
 814:	4501                	li	a0,0
 816:	bf45                	j	7c6 <malloc+0x94>
