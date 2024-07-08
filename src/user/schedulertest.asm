
user/_schedulertest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

#define NFORK 10
#define IO 5

int main()
{
   0:	7139                	add	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	0080                	add	s0,sp,64
  int n, pid;
  int wtime, rtime;
  int twtime = 0, trtime = 0;
  for (n = 0; n < NFORK; n++)
   e:	4481                	li	s1,0
      exit(0);
    }
    else 
    {
#ifdef PBS
      if (n < IO)
  10:	4911                	li	s2,4
  for (n = 0; n < NFORK; n++)
  12:	49a9                	li	s3,10
  14:	a859                	j	aa <main+0xaa>
        set_priority(80, pid);
#endif
    }
  }
  for (; n > 0; n--)
  16:	00905563          	blez	s1,20 <main+0x20>
  for (n = 0; n < NFORK; n++)
  1a:	4901                	li	s2,0
  1c:	4981                	li	s3,0
  1e:	a855                	j	d2 <main+0xd2>
  for (; n > 0; n--)
  20:	4901                	li	s2,0
  22:	4981                	li	s3,0
    {
      trtime += rtime;
      twtime += wtime;
    }
  }
  printf("Average rtime %d,  wtime %d\n", trtime / NFORK, twtime / NFORK);
  24:	45a9                	li	a1,10
  26:	02b9c63b          	divw	a2,s3,a1
  2a:	02b945bb          	divw	a1,s2,a1
  2e:	00001517          	auipc	a0,0x1
  32:	89a50513          	add	a0,a0,-1894 # 8c8 <malloc+0x100>
  36:	00000097          	auipc	ra,0x0
  3a:	6da080e7          	jalr	1754(ra) # 710 <printf>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	340080e7          	jalr	832(ra) # 380 <exit>
      if (n < IO)
  48:	4791                	li	a5,4
  4a:	0497d663          	bge	a5,s1,96 <main+0x96>
        for (volatile int i = 0; i < 1000000000; i++)
  4e:	fc042223          	sw	zero,-60(s0)
  52:	fc442703          	lw	a4,-60(s0)
  56:	2701                	sext.w	a4,a4
  58:	3b9ad7b7          	lui	a5,0x3b9ad
  5c:	9ff78793          	add	a5,a5,-1537 # 3b9ac9ff <base+0x3b9ab9ef>
  60:	00e7cd63          	blt	a5,a4,7a <main+0x7a>
  64:	873e                	mv	a4,a5
  66:	fc442783          	lw	a5,-60(s0)
  6a:	2785                	addw	a5,a5,1
  6c:	fcf42223          	sw	a5,-60(s0)
  70:	fc442783          	lw	a5,-60(s0)
  74:	2781                	sext.w	a5,a5
  76:	fef758e3          	bge	a4,a5,66 <main+0x66>
      printf("Process %d finished\n", n);
  7a:	85a6                	mv	a1,s1
  7c:	00001517          	auipc	a0,0x1
  80:	83450513          	add	a0,a0,-1996 # 8b0 <malloc+0xe8>
  84:	00000097          	auipc	ra,0x0
  88:	68c080e7          	jalr	1676(ra) # 710 <printf>
      exit(0);
  8c:	4501                	li	a0,0
  8e:	00000097          	auipc	ra,0x0
  92:	2f2080e7          	jalr	754(ra) # 380 <exit>
        sleep(200); // IO bound processes
  96:	0c800513          	li	a0,200
  9a:	00000097          	auipc	ra,0x0
  9e:	376080e7          	jalr	886(ra) # 410 <sleep>
  a2:	bfe1                	j	7a <main+0x7a>
  for (n = 0; n < NFORK; n++)
  a4:	2485                	addw	s1,s1,1
  a6:	f7348ae3          	beq	s1,s3,1a <main+0x1a>
    pid = fork();
  aa:	00000097          	auipc	ra,0x0
  ae:	2ce080e7          	jalr	718(ra) # 378 <fork>
    if (pid < 0)
  b2:	f60542e3          	bltz	a0,16 <main+0x16>
    if (pid == 0)
  b6:	d949                	beqz	a0,48 <main+0x48>
      if (n < IO)
  b8:	fe9946e3          	blt	s2,s1,a4 <main+0xa4>
        set_priority(80, pid);
  bc:	85aa                	mv	a1,a0
  be:	05000513          	li	a0,80
  c2:	00000097          	auipc	ra,0x0
  c6:	37e080e7          	jalr	894(ra) # 440 <set_priority>
  for (n = 0; n < NFORK; n++)
  ca:	2485                	addw	s1,s1,1
  cc:	bff9                	j	aa <main+0xaa>
  for (; n > 0; n--)
  ce:	34fd                	addw	s1,s1,-1
  d0:	d8b1                	beqz	s1,24 <main+0x24>
    if (waitx(0, &wtime, &rtime) >= 0)
  d2:	fc840613          	add	a2,s0,-56
  d6:	fcc40593          	add	a1,s0,-52
  da:	4501                	li	a0,0
  dc:	00000097          	auipc	ra,0x0
  e0:	344080e7          	jalr	836(ra) # 420 <waitx>
  e4:	fe0545e3          	bltz	a0,ce <main+0xce>
      trtime += rtime;
  e8:	fc842783          	lw	a5,-56(s0)
  ec:	0127893b          	addw	s2,a5,s2
      twtime += wtime;
  f0:	fcc42783          	lw	a5,-52(s0)
  f4:	013789bb          	addw	s3,a5,s3
  f8:	bfd9                	j	ce <main+0xce>

00000000000000fa <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  fa:	1141                	add	sp,sp,-16
  fc:	e406                	sd	ra,8(sp)
  fe:	e022                	sd	s0,0(sp)
 100:	0800                	add	s0,sp,16
  extern int main();
  main();
 102:	00000097          	auipc	ra,0x0
 106:	efe080e7          	jalr	-258(ra) # 0 <main>
  exit(0);
 10a:	4501                	li	a0,0
 10c:	00000097          	auipc	ra,0x0
 110:	274080e7          	jalr	628(ra) # 380 <exit>

0000000000000114 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 114:	1141                	add	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11a:	87aa                	mv	a5,a0
 11c:	0585                	add	a1,a1,1
 11e:	0785                	add	a5,a5,1
 120:	fff5c703          	lbu	a4,-1(a1)
 124:	fee78fa3          	sb	a4,-1(a5)
 128:	fb75                	bnez	a4,11c <strcpy+0x8>
    ;
  return os;
}
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	add	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 130:	1141                	add	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 136:	00054783          	lbu	a5,0(a0)
 13a:	cb91                	beqz	a5,14e <strcmp+0x1e>
 13c:	0005c703          	lbu	a4,0(a1)
 140:	00f71763          	bne	a4,a5,14e <strcmp+0x1e>
    p++, q++;
 144:	0505                	add	a0,a0,1
 146:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 148:	00054783          	lbu	a5,0(a0)
 14c:	fbe5                	bnez	a5,13c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 14e:	0005c503          	lbu	a0,0(a1)
}
 152:	40a7853b          	subw	a0,a5,a0
 156:	6422                	ld	s0,8(sp)
 158:	0141                	add	sp,sp,16
 15a:	8082                	ret

000000000000015c <strlen>:

uint
strlen(const char *s)
{
 15c:	1141                	add	sp,sp,-16
 15e:	e422                	sd	s0,8(sp)
 160:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 162:	00054783          	lbu	a5,0(a0)
 166:	cf91                	beqz	a5,182 <strlen+0x26>
 168:	0505                	add	a0,a0,1
 16a:	87aa                	mv	a5,a0
 16c:	86be                	mv	a3,a5
 16e:	0785                	add	a5,a5,1
 170:	fff7c703          	lbu	a4,-1(a5)
 174:	ff65                	bnez	a4,16c <strlen+0x10>
 176:	40a6853b          	subw	a0,a3,a0
 17a:	2505                	addw	a0,a0,1
    ;
  return n;
}
 17c:	6422                	ld	s0,8(sp)
 17e:	0141                	add	sp,sp,16
 180:	8082                	ret
  for(n = 0; s[n]; n++)
 182:	4501                	li	a0,0
 184:	bfe5                	j	17c <strlen+0x20>

0000000000000186 <memset>:

void*
memset(void *dst, int c, uint n)
{
 186:	1141                	add	sp,sp,-16
 188:	e422                	sd	s0,8(sp)
 18a:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18c:	ca19                	beqz	a2,1a2 <memset+0x1c>
 18e:	87aa                	mv	a5,a0
 190:	1602                	sll	a2,a2,0x20
 192:	9201                	srl	a2,a2,0x20
 194:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 198:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19c:	0785                	add	a5,a5,1
 19e:	fee79de3          	bne	a5,a4,198 <memset+0x12>
  }
  return dst;
}
 1a2:	6422                	ld	s0,8(sp)
 1a4:	0141                	add	sp,sp,16
 1a6:	8082                	ret

00000000000001a8 <strchr>:

char*
strchr(const char *s, char c)
{
 1a8:	1141                	add	sp,sp,-16
 1aa:	e422                	sd	s0,8(sp)
 1ac:	0800                	add	s0,sp,16
  for(; *s; s++)
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	cb99                	beqz	a5,1c8 <strchr+0x20>
    if(*s == c)
 1b4:	00f58763          	beq	a1,a5,1c2 <strchr+0x1a>
  for(; *s; s++)
 1b8:	0505                	add	a0,a0,1
 1ba:	00054783          	lbu	a5,0(a0)
 1be:	fbfd                	bnez	a5,1b4 <strchr+0xc>
      return (char*)s;
  return 0;
 1c0:	4501                	li	a0,0
}
 1c2:	6422                	ld	s0,8(sp)
 1c4:	0141                	add	sp,sp,16
 1c6:	8082                	ret
  return 0;
 1c8:	4501                	li	a0,0
 1ca:	bfe5                	j	1c2 <strchr+0x1a>

00000000000001cc <gets>:

char*
gets(char *buf, int max)
{
 1cc:	711d                	add	sp,sp,-96
 1ce:	ec86                	sd	ra,88(sp)
 1d0:	e8a2                	sd	s0,80(sp)
 1d2:	e4a6                	sd	s1,72(sp)
 1d4:	e0ca                	sd	s2,64(sp)
 1d6:	fc4e                	sd	s3,56(sp)
 1d8:	f852                	sd	s4,48(sp)
 1da:	f456                	sd	s5,40(sp)
 1dc:	f05a                	sd	s6,32(sp)
 1de:	ec5e                	sd	s7,24(sp)
 1e0:	1080                	add	s0,sp,96
 1e2:	8baa                	mv	s7,a0
 1e4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e6:	892a                	mv	s2,a0
 1e8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ea:	4aa9                	li	s5,10
 1ec:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ee:	89a6                	mv	s3,s1
 1f0:	2485                	addw	s1,s1,1
 1f2:	0344d863          	bge	s1,s4,222 <gets+0x56>
    cc = read(0, &c, 1);
 1f6:	4605                	li	a2,1
 1f8:	faf40593          	add	a1,s0,-81
 1fc:	4501                	li	a0,0
 1fe:	00000097          	auipc	ra,0x0
 202:	19a080e7          	jalr	410(ra) # 398 <read>
    if(cc < 1)
 206:	00a05e63          	blez	a0,222 <gets+0x56>
    buf[i++] = c;
 20a:	faf44783          	lbu	a5,-81(s0)
 20e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 212:	01578763          	beq	a5,s5,220 <gets+0x54>
 216:	0905                	add	s2,s2,1
 218:	fd679be3          	bne	a5,s6,1ee <gets+0x22>
  for(i=0; i+1 < max; ){
 21c:	89a6                	mv	s3,s1
 21e:	a011                	j	222 <gets+0x56>
 220:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 222:	99de                	add	s3,s3,s7
 224:	00098023          	sb	zero,0(s3)
  return buf;
}
 228:	855e                	mv	a0,s7
 22a:	60e6                	ld	ra,88(sp)
 22c:	6446                	ld	s0,80(sp)
 22e:	64a6                	ld	s1,72(sp)
 230:	6906                	ld	s2,64(sp)
 232:	79e2                	ld	s3,56(sp)
 234:	7a42                	ld	s4,48(sp)
 236:	7aa2                	ld	s5,40(sp)
 238:	7b02                	ld	s6,32(sp)
 23a:	6be2                	ld	s7,24(sp)
 23c:	6125                	add	sp,sp,96
 23e:	8082                	ret

0000000000000240 <stat>:

int
stat(const char *n, struct stat *st)
{
 240:	1101                	add	sp,sp,-32
 242:	ec06                	sd	ra,24(sp)
 244:	e822                	sd	s0,16(sp)
 246:	e426                	sd	s1,8(sp)
 248:	e04a                	sd	s2,0(sp)
 24a:	1000                	add	s0,sp,32
 24c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24e:	4581                	li	a1,0
 250:	00000097          	auipc	ra,0x0
 254:	170080e7          	jalr	368(ra) # 3c0 <open>
  if(fd < 0)
 258:	02054563          	bltz	a0,282 <stat+0x42>
 25c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 25e:	85ca                	mv	a1,s2
 260:	00000097          	auipc	ra,0x0
 264:	178080e7          	jalr	376(ra) # 3d8 <fstat>
 268:	892a                	mv	s2,a0
  close(fd);
 26a:	8526                	mv	a0,s1
 26c:	00000097          	auipc	ra,0x0
 270:	13c080e7          	jalr	316(ra) # 3a8 <close>
  return r;
}
 274:	854a                	mv	a0,s2
 276:	60e2                	ld	ra,24(sp)
 278:	6442                	ld	s0,16(sp)
 27a:	64a2                	ld	s1,8(sp)
 27c:	6902                	ld	s2,0(sp)
 27e:	6105                	add	sp,sp,32
 280:	8082                	ret
    return -1;
 282:	597d                	li	s2,-1
 284:	bfc5                	j	274 <stat+0x34>

0000000000000286 <atoi>:

int
atoi(const char *s)
{
 286:	1141                	add	sp,sp,-16
 288:	e422                	sd	s0,8(sp)
 28a:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28c:	00054683          	lbu	a3,0(a0)
 290:	fd06879b          	addw	a5,a3,-48
 294:	0ff7f793          	zext.b	a5,a5
 298:	4625                	li	a2,9
 29a:	02f66863          	bltu	a2,a5,2ca <atoi+0x44>
 29e:	872a                	mv	a4,a0
  n = 0;
 2a0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2a2:	0705                	add	a4,a4,1
 2a4:	0025179b          	sllw	a5,a0,0x2
 2a8:	9fa9                	addw	a5,a5,a0
 2aa:	0017979b          	sllw	a5,a5,0x1
 2ae:	9fb5                	addw	a5,a5,a3
 2b0:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b4:	00074683          	lbu	a3,0(a4)
 2b8:	fd06879b          	addw	a5,a3,-48
 2bc:	0ff7f793          	zext.b	a5,a5
 2c0:	fef671e3          	bgeu	a2,a5,2a2 <atoi+0x1c>
  return n;
}
 2c4:	6422                	ld	s0,8(sp)
 2c6:	0141                	add	sp,sp,16
 2c8:	8082                	ret
  n = 0;
 2ca:	4501                	li	a0,0
 2cc:	bfe5                	j	2c4 <atoi+0x3e>

00000000000002ce <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ce:	1141                	add	sp,sp,-16
 2d0:	e422                	sd	s0,8(sp)
 2d2:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d4:	02b57463          	bgeu	a0,a1,2fc <memmove+0x2e>
    while(n-- > 0)
 2d8:	00c05f63          	blez	a2,2f6 <memmove+0x28>
 2dc:	1602                	sll	a2,a2,0x20
 2de:	9201                	srl	a2,a2,0x20
 2e0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e6:	0585                	add	a1,a1,1
 2e8:	0705                	add	a4,a4,1
 2ea:	fff5c683          	lbu	a3,-1(a1)
 2ee:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2f2:	fee79ae3          	bne	a5,a4,2e6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f6:	6422                	ld	s0,8(sp)
 2f8:	0141                	add	sp,sp,16
 2fa:	8082                	ret
    dst += n;
 2fc:	00c50733          	add	a4,a0,a2
    src += n;
 300:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 302:	fec05ae3          	blez	a2,2f6 <memmove+0x28>
 306:	fff6079b          	addw	a5,a2,-1
 30a:	1782                	sll	a5,a5,0x20
 30c:	9381                	srl	a5,a5,0x20
 30e:	fff7c793          	not	a5,a5
 312:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 314:	15fd                	add	a1,a1,-1
 316:	177d                	add	a4,a4,-1
 318:	0005c683          	lbu	a3,0(a1)
 31c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 320:	fee79ae3          	bne	a5,a4,314 <memmove+0x46>
 324:	bfc9                	j	2f6 <memmove+0x28>

0000000000000326 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 326:	1141                	add	sp,sp,-16
 328:	e422                	sd	s0,8(sp)
 32a:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 32c:	ca05                	beqz	a2,35c <memcmp+0x36>
 32e:	fff6069b          	addw	a3,a2,-1
 332:	1682                	sll	a3,a3,0x20
 334:	9281                	srl	a3,a3,0x20
 336:	0685                	add	a3,a3,1
 338:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 33a:	00054783          	lbu	a5,0(a0)
 33e:	0005c703          	lbu	a4,0(a1)
 342:	00e79863          	bne	a5,a4,352 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 346:	0505                	add	a0,a0,1
    p2++;
 348:	0585                	add	a1,a1,1
  while (n-- > 0) {
 34a:	fed518e3          	bne	a0,a3,33a <memcmp+0x14>
  }
  return 0;
 34e:	4501                	li	a0,0
 350:	a019                	j	356 <memcmp+0x30>
      return *p1 - *p2;
 352:	40e7853b          	subw	a0,a5,a4
}
 356:	6422                	ld	s0,8(sp)
 358:	0141                	add	sp,sp,16
 35a:	8082                	ret
  return 0;
 35c:	4501                	li	a0,0
 35e:	bfe5                	j	356 <memcmp+0x30>

0000000000000360 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 360:	1141                	add	sp,sp,-16
 362:	e406                	sd	ra,8(sp)
 364:	e022                	sd	s0,0(sp)
 366:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 368:	00000097          	auipc	ra,0x0
 36c:	f66080e7          	jalr	-154(ra) # 2ce <memmove>
}
 370:	60a2                	ld	ra,8(sp)
 372:	6402                	ld	s0,0(sp)
 374:	0141                	add	sp,sp,16
 376:	8082                	ret

0000000000000378 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 378:	4885                	li	a7,1
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <exit>:
.global exit
exit:
 li a7, SYS_exit
 380:	4889                	li	a7,2
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <wait>:
.global wait
wait:
 li a7, SYS_wait
 388:	488d                	li	a7,3
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 390:	4891                	li	a7,4
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <read>:
.global read
read:
 li a7, SYS_read
 398:	4895                	li	a7,5
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <write>:
.global write
write:
 li a7, SYS_write
 3a0:	48c1                	li	a7,16
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <close>:
.global close
close:
 li a7, SYS_close
 3a8:	48d5                	li	a7,21
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3b0:	4899                	li	a7,6
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b8:	489d                	li	a7,7
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <open>:
.global open
open:
 li a7, SYS_open
 3c0:	48bd                	li	a7,15
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c8:	48c5                	li	a7,17
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3d0:	48c9                	li	a7,18
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d8:	48a1                	li	a7,8
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <link>:
.global link
link:
 li a7, SYS_link
 3e0:	48cd                	li	a7,19
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e8:	48d1                	li	a7,20
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3f0:	48a5                	li	a7,9
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f8:	48a9                	li	a7,10
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 400:	48ad                	li	a7,11
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 408:	48b1                	li	a7,12
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 410:	48b5                	li	a7,13
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 418:	48b9                	li	a7,14
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 420:	48d9                	li	a7,22
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <getreadcount>:
.global getreadcount
getreadcount:
 li a7, SYS_getreadcount
 428:	48dd                	li	a7,23
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 430:	48e1                	li	a7,24
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 438:	48e5                	li	a7,25
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 440:	48e9                	li	a7,26
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 448:	1101                	add	sp,sp,-32
 44a:	ec06                	sd	ra,24(sp)
 44c:	e822                	sd	s0,16(sp)
 44e:	1000                	add	s0,sp,32
 450:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 454:	4605                	li	a2,1
 456:	fef40593          	add	a1,s0,-17
 45a:	00000097          	auipc	ra,0x0
 45e:	f46080e7          	jalr	-186(ra) # 3a0 <write>
}
 462:	60e2                	ld	ra,24(sp)
 464:	6442                	ld	s0,16(sp)
 466:	6105                	add	sp,sp,32
 468:	8082                	ret

000000000000046a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 46a:	7139                	add	sp,sp,-64
 46c:	fc06                	sd	ra,56(sp)
 46e:	f822                	sd	s0,48(sp)
 470:	f426                	sd	s1,40(sp)
 472:	f04a                	sd	s2,32(sp)
 474:	ec4e                	sd	s3,24(sp)
 476:	0080                	add	s0,sp,64
 478:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 47a:	c299                	beqz	a3,480 <printint+0x16>
 47c:	0805c963          	bltz	a1,50e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 480:	2581                	sext.w	a1,a1
  neg = 0;
 482:	4881                	li	a7,0
 484:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 488:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 48a:	2601                	sext.w	a2,a2
 48c:	00000517          	auipc	a0,0x0
 490:	4bc50513          	add	a0,a0,1212 # 948 <digits>
 494:	883a                	mv	a6,a4
 496:	2705                	addw	a4,a4,1
 498:	02c5f7bb          	remuw	a5,a1,a2
 49c:	1782                	sll	a5,a5,0x20
 49e:	9381                	srl	a5,a5,0x20
 4a0:	97aa                	add	a5,a5,a0
 4a2:	0007c783          	lbu	a5,0(a5)
 4a6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4aa:	0005879b          	sext.w	a5,a1
 4ae:	02c5d5bb          	divuw	a1,a1,a2
 4b2:	0685                	add	a3,a3,1
 4b4:	fec7f0e3          	bgeu	a5,a2,494 <printint+0x2a>
  if(neg)
 4b8:	00088c63          	beqz	a7,4d0 <printint+0x66>
    buf[i++] = '-';
 4bc:	fd070793          	add	a5,a4,-48
 4c0:	00878733          	add	a4,a5,s0
 4c4:	02d00793          	li	a5,45
 4c8:	fef70823          	sb	a5,-16(a4)
 4cc:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 4d0:	02e05863          	blez	a4,500 <printint+0x96>
 4d4:	fc040793          	add	a5,s0,-64
 4d8:	00e78933          	add	s2,a5,a4
 4dc:	fff78993          	add	s3,a5,-1
 4e0:	99ba                	add	s3,s3,a4
 4e2:	377d                	addw	a4,a4,-1
 4e4:	1702                	sll	a4,a4,0x20
 4e6:	9301                	srl	a4,a4,0x20
 4e8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ec:	fff94583          	lbu	a1,-1(s2)
 4f0:	8526                	mv	a0,s1
 4f2:	00000097          	auipc	ra,0x0
 4f6:	f56080e7          	jalr	-170(ra) # 448 <putc>
  while(--i >= 0)
 4fa:	197d                	add	s2,s2,-1
 4fc:	ff3918e3          	bne	s2,s3,4ec <printint+0x82>
}
 500:	70e2                	ld	ra,56(sp)
 502:	7442                	ld	s0,48(sp)
 504:	74a2                	ld	s1,40(sp)
 506:	7902                	ld	s2,32(sp)
 508:	69e2                	ld	s3,24(sp)
 50a:	6121                	add	sp,sp,64
 50c:	8082                	ret
    x = -xx;
 50e:	40b005bb          	negw	a1,a1
    neg = 1;
 512:	4885                	li	a7,1
    x = -xx;
 514:	bf85                	j	484 <printint+0x1a>

0000000000000516 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 516:	715d                	add	sp,sp,-80
 518:	e486                	sd	ra,72(sp)
 51a:	e0a2                	sd	s0,64(sp)
 51c:	fc26                	sd	s1,56(sp)
 51e:	f84a                	sd	s2,48(sp)
 520:	f44e                	sd	s3,40(sp)
 522:	f052                	sd	s4,32(sp)
 524:	ec56                	sd	s5,24(sp)
 526:	e85a                	sd	s6,16(sp)
 528:	e45e                	sd	s7,8(sp)
 52a:	e062                	sd	s8,0(sp)
 52c:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52e:	0005c903          	lbu	s2,0(a1)
 532:	18090c63          	beqz	s2,6ca <vprintf+0x1b4>
 536:	8aaa                	mv	s5,a0
 538:	8bb2                	mv	s7,a2
 53a:	00158493          	add	s1,a1,1
  state = 0;
 53e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 540:	02500a13          	li	s4,37
 544:	4b55                	li	s6,21
 546:	a839                	j	564 <vprintf+0x4e>
        putc(fd, c);
 548:	85ca                	mv	a1,s2
 54a:	8556                	mv	a0,s5
 54c:	00000097          	auipc	ra,0x0
 550:	efc080e7          	jalr	-260(ra) # 448 <putc>
 554:	a019                	j	55a <vprintf+0x44>
    } else if(state == '%'){
 556:	01498d63          	beq	s3,s4,570 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 55a:	0485                	add	s1,s1,1
 55c:	fff4c903          	lbu	s2,-1(s1)
 560:	16090563          	beqz	s2,6ca <vprintf+0x1b4>
    if(state == 0){
 564:	fe0999e3          	bnez	s3,556 <vprintf+0x40>
      if(c == '%'){
 568:	ff4910e3          	bne	s2,s4,548 <vprintf+0x32>
        state = '%';
 56c:	89d2                	mv	s3,s4
 56e:	b7f5                	j	55a <vprintf+0x44>
      if(c == 'd'){
 570:	13490263          	beq	s2,s4,694 <vprintf+0x17e>
 574:	f9d9079b          	addw	a5,s2,-99
 578:	0ff7f793          	zext.b	a5,a5
 57c:	12fb6563          	bltu	s6,a5,6a6 <vprintf+0x190>
 580:	f9d9079b          	addw	a5,s2,-99
 584:	0ff7f713          	zext.b	a4,a5
 588:	10eb6f63          	bltu	s6,a4,6a6 <vprintf+0x190>
 58c:	00271793          	sll	a5,a4,0x2
 590:	00000717          	auipc	a4,0x0
 594:	36070713          	add	a4,a4,864 # 8f0 <malloc+0x128>
 598:	97ba                	add	a5,a5,a4
 59a:	439c                	lw	a5,0(a5)
 59c:	97ba                	add	a5,a5,a4
 59e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5a0:	008b8913          	add	s2,s7,8
 5a4:	4685                	li	a3,1
 5a6:	4629                	li	a2,10
 5a8:	000ba583          	lw	a1,0(s7)
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	ebc080e7          	jalr	-324(ra) # 46a <printint>
 5b6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b745                	j	55a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5bc:	008b8913          	add	s2,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4629                	li	a2,10
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	ea0080e7          	jalr	-352(ra) # 46a <printint>
 5d2:	8bca                	mv	s7,s2
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	b751                	j	55a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 5d8:	008b8913          	add	s2,s7,8
 5dc:	4681                	li	a3,0
 5de:	4641                	li	a2,16
 5e0:	000ba583          	lw	a1,0(s7)
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	e84080e7          	jalr	-380(ra) # 46a <printint>
 5ee:	8bca                	mv	s7,s2
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	b7a5                	j	55a <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 5f4:	008b8c13          	add	s8,s7,8
 5f8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5fc:	03000593          	li	a1,48
 600:	8556                	mv	a0,s5
 602:	00000097          	auipc	ra,0x0
 606:	e46080e7          	jalr	-442(ra) # 448 <putc>
  putc(fd, 'x');
 60a:	07800593          	li	a1,120
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	e38080e7          	jalr	-456(ra) # 448 <putc>
 618:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 61a:	00000b97          	auipc	s7,0x0
 61e:	32eb8b93          	add	s7,s7,814 # 948 <digits>
 622:	03c9d793          	srl	a5,s3,0x3c
 626:	97de                	add	a5,a5,s7
 628:	0007c583          	lbu	a1,0(a5)
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	e1a080e7          	jalr	-486(ra) # 448 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 636:	0992                	sll	s3,s3,0x4
 638:	397d                	addw	s2,s2,-1
 63a:	fe0914e3          	bnez	s2,622 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 63e:	8be2                	mv	s7,s8
      state = 0;
 640:	4981                	li	s3,0
 642:	bf21                	j	55a <vprintf+0x44>
        s = va_arg(ap, char*);
 644:	008b8993          	add	s3,s7,8
 648:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 64c:	02090163          	beqz	s2,66e <vprintf+0x158>
        while(*s != 0){
 650:	00094583          	lbu	a1,0(s2)
 654:	c9a5                	beqz	a1,6c4 <vprintf+0x1ae>
          putc(fd, *s);
 656:	8556                	mv	a0,s5
 658:	00000097          	auipc	ra,0x0
 65c:	df0080e7          	jalr	-528(ra) # 448 <putc>
          s++;
 660:	0905                	add	s2,s2,1
        while(*s != 0){
 662:	00094583          	lbu	a1,0(s2)
 666:	f9e5                	bnez	a1,656 <vprintf+0x140>
        s = va_arg(ap, char*);
 668:	8bce                	mv	s7,s3
      state = 0;
 66a:	4981                	li	s3,0
 66c:	b5fd                	j	55a <vprintf+0x44>
          s = "(null)";
 66e:	00000917          	auipc	s2,0x0
 672:	27a90913          	add	s2,s2,634 # 8e8 <malloc+0x120>
        while(*s != 0){
 676:	02800593          	li	a1,40
 67a:	bff1                	j	656 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 67c:	008b8913          	add	s2,s7,8
 680:	000bc583          	lbu	a1,0(s7)
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	dc2080e7          	jalr	-574(ra) # 448 <putc>
 68e:	8bca                	mv	s7,s2
      state = 0;
 690:	4981                	li	s3,0
 692:	b5e1                	j	55a <vprintf+0x44>
        putc(fd, c);
 694:	02500593          	li	a1,37
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	dae080e7          	jalr	-594(ra) # 448 <putc>
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	bd5d                	j	55a <vprintf+0x44>
        putc(fd, '%');
 6a6:	02500593          	li	a1,37
 6aa:	8556                	mv	a0,s5
 6ac:	00000097          	auipc	ra,0x0
 6b0:	d9c080e7          	jalr	-612(ra) # 448 <putc>
        putc(fd, c);
 6b4:	85ca                	mv	a1,s2
 6b6:	8556                	mv	a0,s5
 6b8:	00000097          	auipc	ra,0x0
 6bc:	d90080e7          	jalr	-624(ra) # 448 <putc>
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	bd61                	j	55a <vprintf+0x44>
        s = va_arg(ap, char*);
 6c4:	8bce                	mv	s7,s3
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	bd49                	j	55a <vprintf+0x44>
    }
  }
}
 6ca:	60a6                	ld	ra,72(sp)
 6cc:	6406                	ld	s0,64(sp)
 6ce:	74e2                	ld	s1,56(sp)
 6d0:	7942                	ld	s2,48(sp)
 6d2:	79a2                	ld	s3,40(sp)
 6d4:	7a02                	ld	s4,32(sp)
 6d6:	6ae2                	ld	s5,24(sp)
 6d8:	6b42                	ld	s6,16(sp)
 6da:	6ba2                	ld	s7,8(sp)
 6dc:	6c02                	ld	s8,0(sp)
 6de:	6161                	add	sp,sp,80
 6e0:	8082                	ret

00000000000006e2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6e2:	715d                	add	sp,sp,-80
 6e4:	ec06                	sd	ra,24(sp)
 6e6:	e822                	sd	s0,16(sp)
 6e8:	1000                	add	s0,sp,32
 6ea:	e010                	sd	a2,0(s0)
 6ec:	e414                	sd	a3,8(s0)
 6ee:	e818                	sd	a4,16(s0)
 6f0:	ec1c                	sd	a5,24(s0)
 6f2:	03043023          	sd	a6,32(s0)
 6f6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6fa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6fe:	8622                	mv	a2,s0
 700:	00000097          	auipc	ra,0x0
 704:	e16080e7          	jalr	-490(ra) # 516 <vprintf>
}
 708:	60e2                	ld	ra,24(sp)
 70a:	6442                	ld	s0,16(sp)
 70c:	6161                	add	sp,sp,80
 70e:	8082                	ret

0000000000000710 <printf>:

void
printf(const char *fmt, ...)
{
 710:	711d                	add	sp,sp,-96
 712:	ec06                	sd	ra,24(sp)
 714:	e822                	sd	s0,16(sp)
 716:	1000                	add	s0,sp,32
 718:	e40c                	sd	a1,8(s0)
 71a:	e810                	sd	a2,16(s0)
 71c:	ec14                	sd	a3,24(s0)
 71e:	f018                	sd	a4,32(s0)
 720:	f41c                	sd	a5,40(s0)
 722:	03043823          	sd	a6,48(s0)
 726:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 72a:	00840613          	add	a2,s0,8
 72e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 732:	85aa                	mv	a1,a0
 734:	4505                	li	a0,1
 736:	00000097          	auipc	ra,0x0
 73a:	de0080e7          	jalr	-544(ra) # 516 <vprintf>
}
 73e:	60e2                	ld	ra,24(sp)
 740:	6442                	ld	s0,16(sp)
 742:	6125                	add	sp,sp,96
 744:	8082                	ret

0000000000000746 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 746:	1141                	add	sp,sp,-16
 748:	e422                	sd	s0,8(sp)
 74a:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 74c:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 750:	00001797          	auipc	a5,0x1
 754:	8b07b783          	ld	a5,-1872(a5) # 1000 <freep>
 758:	a02d                	j	782 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 75a:	4618                	lw	a4,8(a2)
 75c:	9f2d                	addw	a4,a4,a1
 75e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 762:	6398                	ld	a4,0(a5)
 764:	6310                	ld	a2,0(a4)
 766:	a83d                	j	7a4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 768:	ff852703          	lw	a4,-8(a0)
 76c:	9f31                	addw	a4,a4,a2
 76e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 770:	ff053683          	ld	a3,-16(a0)
 774:	a091                	j	7b8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 776:	6398                	ld	a4,0(a5)
 778:	00e7e463          	bltu	a5,a4,780 <free+0x3a>
 77c:	00e6ea63          	bltu	a3,a4,790 <free+0x4a>
{
 780:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 782:	fed7fae3          	bgeu	a5,a3,776 <free+0x30>
 786:	6398                	ld	a4,0(a5)
 788:	00e6e463          	bltu	a3,a4,790 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78c:	fee7eae3          	bltu	a5,a4,780 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 790:	ff852583          	lw	a1,-8(a0)
 794:	6390                	ld	a2,0(a5)
 796:	02059813          	sll	a6,a1,0x20
 79a:	01c85713          	srl	a4,a6,0x1c
 79e:	9736                	add	a4,a4,a3
 7a0:	fae60de3          	beq	a2,a4,75a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7a4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7a8:	4790                	lw	a2,8(a5)
 7aa:	02061593          	sll	a1,a2,0x20
 7ae:	01c5d713          	srl	a4,a1,0x1c
 7b2:	973e                	add	a4,a4,a5
 7b4:	fae68ae3          	beq	a3,a4,768 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7b8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ba:	00001717          	auipc	a4,0x1
 7be:	84f73323          	sd	a5,-1978(a4) # 1000 <freep>
}
 7c2:	6422                	ld	s0,8(sp)
 7c4:	0141                	add	sp,sp,16
 7c6:	8082                	ret

00000000000007c8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7c8:	7139                	add	sp,sp,-64
 7ca:	fc06                	sd	ra,56(sp)
 7cc:	f822                	sd	s0,48(sp)
 7ce:	f426                	sd	s1,40(sp)
 7d0:	f04a                	sd	s2,32(sp)
 7d2:	ec4e                	sd	s3,24(sp)
 7d4:	e852                	sd	s4,16(sp)
 7d6:	e456                	sd	s5,8(sp)
 7d8:	e05a                	sd	s6,0(sp)
 7da:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7dc:	02051493          	sll	s1,a0,0x20
 7e0:	9081                	srl	s1,s1,0x20
 7e2:	04bd                	add	s1,s1,15
 7e4:	8091                	srl	s1,s1,0x4
 7e6:	0014899b          	addw	s3,s1,1
 7ea:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 7ec:	00001517          	auipc	a0,0x1
 7f0:	81453503          	ld	a0,-2028(a0) # 1000 <freep>
 7f4:	c515                	beqz	a0,820 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f8:	4798                	lw	a4,8(a5)
 7fa:	02977f63          	bgeu	a4,s1,838 <malloc+0x70>
  if(nu < 4096)
 7fe:	8a4e                	mv	s4,s3
 800:	0009871b          	sext.w	a4,s3
 804:	6685                	lui	a3,0x1
 806:	00d77363          	bgeu	a4,a3,80c <malloc+0x44>
 80a:	6a05                	lui	s4,0x1
 80c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 810:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 814:	00000917          	auipc	s2,0x0
 818:	7ec90913          	add	s2,s2,2028 # 1000 <freep>
  if(p == (char*)-1)
 81c:	5afd                	li	s5,-1
 81e:	a895                	j	892 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 820:	00000797          	auipc	a5,0x0
 824:	7f078793          	add	a5,a5,2032 # 1010 <base>
 828:	00000717          	auipc	a4,0x0
 82c:	7cf73c23          	sd	a5,2008(a4) # 1000 <freep>
 830:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 832:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 836:	b7e1                	j	7fe <malloc+0x36>
      if(p->s.size == nunits)
 838:	02e48c63          	beq	s1,a4,870 <malloc+0xa8>
        p->s.size -= nunits;
 83c:	4137073b          	subw	a4,a4,s3
 840:	c798                	sw	a4,8(a5)
        p += p->s.size;
 842:	02071693          	sll	a3,a4,0x20
 846:	01c6d713          	srl	a4,a3,0x1c
 84a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 84c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 850:	00000717          	auipc	a4,0x0
 854:	7aa73823          	sd	a0,1968(a4) # 1000 <freep>
      return (void*)(p + 1);
 858:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 85c:	70e2                	ld	ra,56(sp)
 85e:	7442                	ld	s0,48(sp)
 860:	74a2                	ld	s1,40(sp)
 862:	7902                	ld	s2,32(sp)
 864:	69e2                	ld	s3,24(sp)
 866:	6a42                	ld	s4,16(sp)
 868:	6aa2                	ld	s5,8(sp)
 86a:	6b02                	ld	s6,0(sp)
 86c:	6121                	add	sp,sp,64
 86e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 870:	6398                	ld	a4,0(a5)
 872:	e118                	sd	a4,0(a0)
 874:	bff1                	j	850 <malloc+0x88>
  hp->s.size = nu;
 876:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 87a:	0541                	add	a0,a0,16
 87c:	00000097          	auipc	ra,0x0
 880:	eca080e7          	jalr	-310(ra) # 746 <free>
  return freep;
 884:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 888:	d971                	beqz	a0,85c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 88c:	4798                	lw	a4,8(a5)
 88e:	fa9775e3          	bgeu	a4,s1,838 <malloc+0x70>
    if(p == freep)
 892:	00093703          	ld	a4,0(s2)
 896:	853e                	mv	a0,a5
 898:	fef719e3          	bne	a4,a5,88a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 89c:	8552                	mv	a0,s4
 89e:	00000097          	auipc	ra,0x0
 8a2:	b6a080e7          	jalr	-1174(ra) # 408 <sbrk>
  if(p == (char*)-1)
 8a6:	fd5518e3          	bne	a0,s5,876 <malloc+0xae>
        return 0;
 8aa:	4501                	li	a0,0
 8ac:	bf45                	j	85c <malloc+0x94>
